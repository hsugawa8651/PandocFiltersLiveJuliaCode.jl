# 例題

ここに {#a,b,c} 索引したいものがあります。



## 次の次の節節

インライン画像 ![ラ・ルーン](lalune.jpg "月への旅行") です。

# タグのないコードブロック

```
2.0^3
```

# 実行しないコード

```julia
2.0^3
```

# えらーはでない

えらーはでないこーどです

```julia-exec,julia
2.0^3
```

# えらーがでる

えらーがでるこーどです

```julia-exec,julia
2.^[3,4]
```


# 何もないコード

次のコードは消えます。

```julia-exec,julia
#hide
```

![これはキャプションです](@OUTPUT/image1.png)


# コードを入れる

ここにコード

```julia-exec,julia
xs = [1,2]; ys= [3,4]
@show xs
@show ys
```

![これはキャプションです](@OUTPUT/image1.png)

コードは終わり
コードは終わり


# 次の節

次の節の頭

## 次の節節

別のコード

savefig は消えます。

```julia-exec,julia
using PyPlot
fig=plt.figure()
axs=fig.add_subplot(111)
axs.plot(1,1,".")
savefig(joinpath(@OUTPUT,"image1.png")) #hide
savefig(joinpath(@OUTPUT,"image2.png")) #hide
```

![これはキャプションです](@OUTPUT/image1.png)
![これはキャプションです](@OUTPUT/image2.png)

別のコードは終わり
別のコードは終わり



# 最後

ここに {#a,b,c} 索引したいものがあります。
ここに {#a,b,c} 索引したいものがあります。
