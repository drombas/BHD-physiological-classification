# Physiological signal classification ([BHD 2021](https://brainhack-donostia.github.io/))

### Project goal
[Physiopy](https://github.com/physiopy/) is a python3 suite to format and analyse physiological recordings. The goal of this project is implementing an automatic signal classifier by finding robust and simple features that allow discerning between them.

### Data ([download link](https://drive.google.com/drive/folders/1fsMe5E5jcSUlhsYRlaNTi7u7FzpO3LYi?usp=sharing))
- 4 types of signals (cardiac, respiratory chest, O2 and CO2)
- 240 time-series (60x4) recordings of 500 seconds long
- 2 files: time_series.csv (time-series data) and labels.csv (time-series labels)

<img src="https://user-images.githubusercontent.com/50577357/121769520-5816f600-cb64-11eb-899a-f6679044f2c7.png" width="700" height="500" />

### Developed algorithm
1. Rule-based frequency domain classification of cardiac vs. respiratory
2. Feature-based ime-domain classifier for chest, O2 and CO2


### Results


### How to reach us
- Mattermost: [physiopy channel](https://mattermost.brainhack.org/brainhack/channels/physiopy), [@drombas](https://mattermost.brainhack.org/brainhack/messages/@drombas) ,[@smoia](https://mattermost.brainhack.org/brainhack/messages/@smoia)
