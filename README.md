# BORON Lightweight Cryptography Hardware Design & FPGA Implementation

![Platform: Vivado](https://img.shields.io/badge/Platform-Vivado-orange)
![Hardware: Verilog HDL](https://img.shields.io/badge/Hardware-Verilog%20HDL-blue)
![Target: Basys 3 (Artix-7)](https://img.shields.io/badge/Target-Basys%203%20(Artix--7)-green)
![Status: TÜBİTAK 2209-A Supported](https://img.shields.io/badge/Status-T%C3%9CB%C4%B0TAK%202209--A%20Supported-red)

[cite_start]Bu proje, **TÜBİTAK 2209-A Üniversite Öğrencileri Araştırma Projeleri Destek Programı** kapsamında geliştirilmiştir[cite: 2, 3]. [cite_start]Projenin temel amacı, IoT tabanlı sistemler için verimlilik esaslarını yerine getiren **BORON** hafif sıklet (lightweight) şifreleme algoritmasının donanım tabanlı tasarımı ve FPGA üzerinde prototiplenmesidir[cite: 5, 22].

## 📌 Proje Özeti
[cite_start]IoT cihazlarının kısıtlı işlem gücü ve enerji kaynakları göz önünde bulundurularak, BORON algoritması (80-bit anahtar, 64-bit veri bloğu) Verilog HDL kullanılarak modüler bir mimaride tasarlanmıştır[cite: 17, 23]. [cite_start]Tasarım, hem şifreleme (encryption) hem de deşifreleme (decryption) süreçlerini kapsayan tam bir IP çekirdeği (IP Core) olarak geliştirilmiştir[cite: 53, 172].

![media/dosya_adi.png](https://github.com/yasinyilmaaz/Boron_algorithm/blob/main/media/vivado.png)

### Temel Özellikler
* [cite_start]**Algoritma Yapısı**: İkame-Permütasyon Ağı (SPN) mimarisi[cite: 20, 58].
* [cite_start]**Parametreler**: 64-bit blok boyutu, 80-bit anahtar uzunluğu ve 25 tur operasyon[cite: 23, 59].
* [cite_start]**Donanım Yaklaşımı**: FPGA üzerinde alan israfını önlemek için **tekrarlamalı (iterative) mimari** tercih edilmiştir[cite: 104, 106].
* [cite_start]**Doğrulama**: C dili ile oluşturulan referans "Golden Model" ve Vivado simülasyonları ile matematiksel tutarlılık ispatlanmıştır[cite: 89, 99].

##  Teknik Mimari ve Modüller
[cite_start]Sistem, donanımsal senkronizasyonu yöneten bir Sonlu Durum Makinesi (FSM) ve üç ana katmandan oluşur[cite: 63, 81]:

1.  [cite_start]**S-Box Katmanı**: 16 adet 4x4 S-Box birimi eşzamanlı çalışarak paralel işlem kapasitesini maksimize eder[cite: 71].
2.  [cite_start]**Permütasyon Katmanı**: Blok karıştırma (Block Shuffle), dairesel kaydırma ve 16-bitlik bloklar arası XOR işlemlerini içerir[cite: 72, 73].
3.  [cite_start]**Anahtar Üretim Modülü**: 80-bitlik kök anahtardan her tur için dinamik olarak 64-bitlik alt anahtarlar üretir[cite: 76, 77].

##  Performans ve Kaynak Kullanımı
[cite_start]**Basys 3 (Artix-7 XC7A35T)** platformu üzerinde yapılan fiziksel test sonuçları şöyledir[cite: 25, 115]:

### Donanım Kaynakları (Utilization)
| Modül | Slice LUTs | Slice Registers |
| :--- | :--- | :--- |
| **Boron_Complete_Wrapper** | [cite_start]1620 [cite: 116] | [cite_start]2400 [cite: 116] |
| **Kullanım Oranı** | [cite_start]<%10 [cite: 116] | [cite_start]<%10 [cite: 116] |

### Zamanlama ve Güç Analizi
* [cite_start]**Çalışma Frekansı**: 100 MHz[cite: 122].
* [cite_start]**WNS (Worst Negative Slack)**: 1,080 ns (ILA Laboratuvar Ölçümü)[cite: 121, 136].
* [cite_start]**Toplam Güç Tüketimi**: ~0.115 W (Prototip ölçümü)[cite: 162].
* [cite_start]**Termal Doyum**: İşlem başladığında sıcaklık 48.7°C seviyesinde dengeye ulaşmaktadır[cite: 142, 162].

##  Depo Yapısı
* [cite_start]`Dec_Boron_Wrapper.v`: Sistemin en üst sarmalayıcı (top-level) modülü[cite: 256].
* [cite_start]`Dec_Boron_Cntrl.v`: Şifreleme/Deşifreleme süreçlerini yöneten FSM kontrol birimi[cite: 226].
* [cite_start]`Dec_Key_Scheduler.v`: Deşifreleme süreci için anahtar planlayıcı[cite: 272].
* [cite_start]`Dec_Round.v`: Bir turluk şifreleme/deşifreleme operasyonunu gerçekleştiren modül[cite: 288].
* [cite_start]`Dec_S_box.v`: Algoritmanın doğrusal olmayan dönüşüm katmanı[cite: 275].

##  Kullanım
1.  [cite_start]**Vivado IDE** üzerinde yeni bir proje oluşturun ve hedef cihaz olarak `XC7A35T` seçin[cite: 180].
2.  `src` dizinindeki tüm `.v` dosyalarını projeye ekleyin.
3.  [cite_start]Simülasyon için `Boron_Complete_Wrapper_tb.v` dosyasını kullanarak çıktıları doğrulayın[cite: 166].
4.  [cite_start]Bitstream dosyasını oluşturarak Basys 3 kartına yükleyin; sonuçları VIO veya ILA üzerinden gözlemleyin[cite: 253, 266].

---
[cite_start]**Proje Yürütücüsü:** Mehmet Korkut Kösem [cite: 6]  
**Danışman:** Doç. [cite_start]Dr. Selman Hızal [cite: 7]
