# Hurst Exponent and Smoothing Window Analysis

This repository contains an R script that demonstrates the relationship between the **Hurst exponent** and the **smoothing window size** in randomly generated 'time series data'. The Hurst exponent is a measure of the roughness, typically interpreted as long-term memory of a time series. This script illustrates how increasing the smoothing window size in random data increases the Hurst exponent. The script includes visualizations and statistical analysis to explore this relationship.

## Key Concepts

### 1. **Hurst Exponent**
The Hurst exponent (H) is a statistical measure used to characterize the long-term memory or persistence of a time series. It ranges between 0 and 1:
- **H ≈ 0.5**: Indicates a random walk (no long-term memory).
- **H > 0.5**: Suggests persistent behavior (long-term memory, trending).
- **H < 0.5**: Indicates anti-persistent behavior (mean-reverting).

### 2. **Smoothing Window**
Smoothing is a technique used to reduce noise in time series data by averaging values over a specified window. Larger smoothing windows result in smoother data but may also obscure finer details.

### 3. **Relationship Between Smoothing and Hurst Exponent**
As the smoothing window size increases, the time series becomes less rough, and the Hurst exponent tends to increase. This is because smoothing reduces short-term fluctuations, making the series appear more persistent. You can see on the plot that wondow size=50 yields Hurst  value = 0.83. Notice, that the underlying data is same random generated data, but smoothing has been applied. The original series appears rough and erratic, consistent with random noise but the smoothed series appears more trend-like, reflecting the artificial persistence introduced by the smoothing window.

---

## Script Overview

### Libraries Used
- `FGN`: For calculating the Hurst exponent. It can be obtained from [here](https://cran.r-project.org/src/contrib/Archive/FGN/)
- `stats`: For statistical functions like the Ljung-Box test and smoothing.
- `ggplot2`: For creating visualizations.

### Key Functions
1. **`batch_process`**:
   - Processes a list of time series.
   - Calculates the Hurst exponent and Ljung-Box test p-value for each series.
   - Handles errors gracefully.

2. **`smooth_series`**:
   - Applies a moving average smoothing to a time series using a specified window size.

3. **Main Workflow**:
   - Generates random time series data.
   - Applies smoothing with varying window sizes.
   - Computes Hurst exponents for smoothed and unsmoothed data.
   - Visualizes the results and calculates the correlation between window size and Hurst exponent.

---

## Why Is This Important for Financial Analysis?

The Hurst exponent is used to identify whether a financial time series exhibits random walk behavior (efficient market) or persistent/anti-persistent behavior (inefficient market).

Our excersize highlights an important mathematical and practical consideration: smoothing can distort the true scaling properties of a time series. While smoothing is useful for noise reduction, it can also artificially inflate the Hurst exponent, leading to misleading conclusions about the persistence or roughness of the data.

In financial or other real-world applications, care must be taken to distinguish between genuine persistence and artifacts introduced by preprocessing steps like smoothing. The smoothing process, such as moving average, introduces correlation between neighboring points in the time series. This correlation is not inherent to the original data but is an artifact of the smoothing operation. As a result, the series appears to have long-range dependence, even though the underlying data is random.

Happy analyzing! 🚀

---

# Зависимость показателя Херста от окна сглаживания данных

Этот репозиторий содержит скрипт R, который демонстрирует связь между **показателем Херста** и **размером окна сглаживания** в случайно сгенерированных «данных временного ряда». Показатель Херста — это мера шероховатости, обычно интерпретируемая как долговременная память временного ряда. Этот скрипт иллюстрирует, как увеличение размера окна сглаживания в случайных данных увеличивает показатель Херста. Скрипт включает визуализации и статистический анализ для изучения этой связи.

## Ключевые концепции

### 1. **Показатель Херста**
Показатель Херста (H) — это статистическая мера, используемая для характеристики долговременной памяти или устойчивости временного ряда. Он находится в диапазоне от 0 до 1:
- **H ≈ 0,5**: указывает на случайное блуждание (отсутствие долговременной памяти).
- **H > 0,5**: предполагает устойчивое поведение (долговременная память, тренд).
- **H < 0,5**: указывает на антиперсистентное поведение (возврат к среднему).

### 2. **Окно сглаживания**
Сглаживание — это метод, используемый для снижения шума в данных временных рядов путем усреднения значений по указанному окну. Большие окна сглаживания приводят к более сглаженным данным, но также могут скрывать более мелкие детали.

### 3. **Связь между сглаживанием и показателем Херста**
По мере увеличения размера окна сглаживания временной ряд становится менее грубым, а показатель Херста имеет тенденцию к увеличению. Это происходит потому, что сглаживание уменьшает краткосрочные колебания, делая ряд более устойчивым. Вы можете видеть на графике, что размер окна = 50 дает значение Херста = 0,83. Обратите внимание, что базовые данные — это те же самые случайно сгенерированные данные, но было применено сглаживание. Исходный ряд выглядит грубым и нестабильным, соответствующим случайному шуму, но сглаженный ряд выглядит более трендовым, отражая искусственную устойчивость, введенную окном сглаживания.

---

## Обзор скрипта

### Используемые библиотеки
- `FGN`: Для расчета показателя Херста. Его можно получить [здесь](https://cran.r-project.org/src/contrib/Archive/FGN/)
- `stats`: Для статистических функций, таких как тест Льюнга-Бокса и сглаживание.
- `ggplot2`: Для создания визуализаций.

### Ключевые функции
1. **`batch_process`**:
- Вычисляет показатель Херста и p-значение теста Льюнга-Бокса для каждого ряда.

2. **`smooth_series`**:
- Применяет сглаживание скользящей средней к временному ряду с использованием указанного размера окна.

3. **Основной рабочий процесс**:
- Генерирует случайные данные временного ряда.
- Применяет сглаживание с различными размерами окна.
- Вычисляет показатели Херста для сглаженных и несглаженных данных.
- Визуализирует результаты и вычисляет корреляцию между размером окна и показателем Херста.

---

## Почему это важно для финансового анализа?

Показатель Херста используется для определения того, демонстрирует ли финансовый временной ряд поведение случайного блуждания (эффективный рынок) или устойчивое/антиустойчивое поведение (неэффективный рынок).

Наш пример подчеркивает важное математическое и практическое соображение: сглаживание может исказить истинные масштабные свойства временного ряда. Хотя сглаживание полезно для снижения шума, оно также может искусственно завышать показатель Херста, что приводит к ошибочным выводам о персистентности данных.

В финансовых или других реальных приложениях необходимо соблюдать осторожность, чтобы различать персистентность и артефакты, вносимые предварительной обработкой. Процесс сглаживания, такой как скользящее среднее, вводит корреляцию между соседними точками во временном ряду. Эта корреляция не присуща исходным данным, а является артефактом операции сглаживания. В результате кажется, что ряд имеет долгосрочную зависимость, хотя исходные данные случайны.

