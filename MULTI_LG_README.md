
# README — Disney Channel Hindi / English Flussonic Configuration

## 1. Source Audio/Video Tracks

Your source shows:

```text
Video:
v1 H.264 1920x1080
PID: 211

Audio:
a1 AAC mono
PID: 221

a2 AAC mono
PID: 222
```

Assuming:

```text
a1 = Hindi
a2 = English
```

you can create separate outputs.

---

## 2. Full Configuration

```text
stream disney_hindi {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;
    input http://138.121.15.230:9002/DISNEY-CHANNEL/index.m3u8;
    input hls://45.166.93.156:9999/play/a0f3/index.m3u8;
    input hls://190.11.225.124:5000/live/disney_hd/playlist.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_hindi?tracks=v1a1;
}

stream disney_eng {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;
    input http://138.121.15.230:9002/DISNEY-CHANNEL/index.m3u8;
    input hls://45.166.93.156:9999/play/a0f3/index.m3u8;
    input hls://190.11.225.124:5000/live/disney_hd/playlist.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_eng?tracks=v1a2;
}
```

### Output mapping

```text
disney_hindi
    v1 + a1
    Video + Hindi Audio

disney_eng
    v1 + a2
    Video + English Audio
```

---

## 3. If You Want Both Audio Tracks

You can also create an output containing both:

```text
stream disney_multi {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;
    input http://138.121.15.230:9002/DISNEY-CHANNEL/index.m3u8;
    input hls://45.166.93.156:9999/play/a0f3/index.m3u8;
    input hls://190.11.225.124:5000/live/disney_hd/playlist.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_multi?tracks=v1a1a2;
}
```

Output:

```text
v1 = Video
a1 = Hindi
a2 = English
```

---

## 4. Recommended Configuration

If your actual goal is:

**One Hindi channel + one English channel**

I recommend keeping the streams separate:

```text
stream disney_hindi {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_hindi?tracks=v1a1;
}

stream disney_eng {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_eng?tracks=v1a2;
}
```

This avoids unnecessarily using the four different inputs twice.

---

## 5. Important: Verify the Track

Your screenshot shows:

```text
Input media info:

a1 aac mono spa pid:221
a2 aac mono eng pid:222
v1 h264 1920x1080 pid:211
```

So in your screenshot the language is actually shown:

```text
a1 = spa
a2 = eng
```

Therefore **English is `a2`**.

Use:

```text
tracks=v1a2
```

for the English stream.

### English

```text
v1a2
```

### Spanish

```text
v1a1
```

---

## 6. Final English Configuration

For the screenshot you provided, this is the configuration you want:

```text
stream disney_eng {
    input hls://cdn1tlinkgo.tlink.cl/disneychannelhd/mono.m3u8;

    push rtmp://100.100.100.19:1935/static/disney_eng?tracks=v1a2;
}
```

The resulting stream contains:

```text
Video:   v1
Audio:   a2
Language: ENG
```

So your RTMP destination becomes:

```text
rtmp://100.100.100.19:1935/static/disney_eng
```


