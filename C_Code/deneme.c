#include <stdio.h>
#include <stdint.h>

// 1. İkame Katmanı: 4-bitlik girişleri karmaşıklaştıran BORON S-Box Tablosu
const uint8_t sbox[16] = {0xE, 0x4, 0xB, 0x1, 0x7, 0x9, 0xC, 0xA, 
                          0xD, 0x2, 0x0, 0xF, 0x8, 0x5, 0x3, 0x6};

// S-Box İşlemi (64-bit veri üzerinde 16 adet 4-bitlik S-Box'ın paralel uygulanması)
uint64_t apply_sbox_layer(uint64_t state) {
    uint64_t new_state = 0;
    for (int i = 0; i < 16; i++) {
        uint8_t nibble = (state >> (i * 4)) & 0xF;
        new_state |= ((uint64_t)sbox[nibble] << (i * 4));
    }
    return new_state;
}

// 2. Permütasyon Katmanı: Block Shuffle (16-bit bloklar içi 4-bitlik yer değiştirme)
uint16_t block_shuffle(uint16_t block) {
    uint16_t p0 = (block) & 0xF;
    uint16_t p1 = (block >> 4) & 0xF;
    uint16_t p2 = (block >> 8) & 0xF;
    uint16_t p3 = (block >> 12) & 0xF;
    // P: 0, 1, 2, 3 -> 2, 3, 0, 1 kuralına göre karıştırma
    return (p1 << 12) | (p0 << 8) | (p3 << 4) | p2; 
}

// 3. Permütasyon Katmanı: Round Permutation (16-bit bloklarda sola döner kaydırma)
uint64_t apply_round_permutation(uint64_t state) {
    uint16_t w0 = state & 0xFFFF;
    uint16_t w1 = (state >> 16) & 0xFFFF;
    uint16_t w2 = (state >> 32) & 0xFFFF;
    uint16_t w3 = (state >> 48) & 0xFFFF;

    // Sola döner kaydırma (Circular Left Shift)
    w0 = (w0 << 1) | (w0 >> 15);
    w1 = (w1 << 4) | (w1 >> 12);
    w2 = (w2 << 7) | (w2 >> 9);
    w3 = (w3 << 9) | (w3 >> 7);

    return ((uint64_t)w3 << 48) | ((uint64_t)w2 << 32) | ((uint64_t)w1 << 16) | w0;
}

// 4. Doğrusal Katman: XOR İşlemi (16-bit bloklar arası XOR)
uint64_t apply_xor_layer(uint64_t state) {
    uint16_t w0 = state & 0xFFFF;
    uint16_t w1 = (state >> 16) & 0xFFFF;
    uint16_t w2 = (state >> 32) & 0xFFFF;
    uint16_t w3 = (state >> 48) & 0xFFFF;

    uint16_t new_w3 = w3 ^ w2 ^ w0;
    uint16_t new_w2 = w2 ^ w0;
    uint16_t new_w1 = w3 ^ w1;
    uint16_t new_w0 = w3 ^ w1 ^ w0;

    return ((uint64_t)new_w3 << 48) | ((uint64_t)new_w2 << 32) | ((uint64_t)new_w1 << 16) | new_w0;
}

// BORON Şifreleme Ana Döngüsü (25 Tur)
uint64_t boron_encrypt(uint64_t plaintext, uint64_t* round_keys) {
    uint64_t state = plaintext;
    
    for (int i = 0; i < 25; i++) {
        // 1. Tur Anahtarı Ekleme
        state ^= round_keys[i];
        
        // 2. İkame Katmanı
        state = apply_sbox_layer(state);
        
        // 3. Permütasyon ve Doğrusal Katman
        // Block shuffle işlemi (64 bit üzerinden 4 adet 16 bitlik bloğa uygulanır)
        uint16_t w0 = block_shuffle(state & 0xFFFF);
        uint16_t w1 = block_shuffle((state >> 16) & 0xFFFF);
        uint16_t w2 = block_shuffle((state >> 32) & 0xFFFF);
        uint16_t w3 = block_shuffle((state >> 48) & 0xFFFF);
        state = ((uint64_t)w3 << 48) | ((uint64_t)w2 << 32) | ((uint64_t)w1 << 16) | w0;
        
        state = apply_round_permutation(state);
        state = apply_xor_layer(state);
    }
    
    // Son Tur Anahtarı Ekleme (K25)
    state ^= round_keys[25];
    return state;
}

int main() {
    // Simülasyonda test ettiğimiz 64-bitlik Açık Metin (Plaintext)
    // Örnek olarak tamamen sıfırlardan oluşan bir metin verilmiştir.
    uint64_t plaintext = 0x0000000000000000;
    
    // 25 Tur + 1 Son Tur (K25) için toplam 26 adet 64-bitlik alt anahtar (Subkey) dizisi.
    // Not: Gerçek bir donanım testinde bu dizi, 80-bitlik ana anahtardan 
    // Anahtar Üretim (Key Scheduling) fonksiyonu ile türetilen değerlerle doldurulur.
    // Burada temel test amacıyla dizi sıfırlanmıştır.
    uint64_t round_keys[26] = {0}; 
    
    // BORON Şifreleme fonksiyonunun çalıştırılması
    uint64_t ciphertext = boron_encrypt(plaintext, round_keys);
    
    // Sonuçların terminale (konsola) hex formatında yazdırılması
    printf("BORON-80 Sifreleme Testi\n");
    printf("----------------------------------------\n");
    printf("Acik Metin (Plaintext)    : 0x%016llX\n", plaintext);
    printf("Sifreli Metin (Ciphertext): 0x%016llX\n", ciphertext);
    
    return 0;
}