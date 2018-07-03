Project 904
===========

<ruby>据说，<rp>(</rp><rt>It is said that</rt><rp>)</rp></ruby>《高考英语词汇手册》上有904条例句。现在，这个数据得到确认了。

这个项目能够生成这些例句的索引表，从而<ruby>使<rp>(</rp><rt>make</rt><rp>)</rp></ruby>根据已知的中文或英文离线查询到相应的翻译<ruby>成为可能<rp>(</rp><rt>possible</rt><rp>)</rp></ruby>。这对于随机布置这本书上的例句作为翻译作业的情况将能提供帮助。

## 下载 ##

转到本仓库的[release/publication.pdf](release/publication.pdf)以下载最终文档。

## 编译方法 ##

你需要：

- xeLaTeX和宏包：
    - xeCJK
    - geometry
    - titlesec
    - multicol
- Ruby。测试时使用的版本是Windows上的2.4.1，但是其他版本应当也能正常工作。
- 如果你需要打印小册子，我建议使用Adobe Acrobat Reader。

然后，运行`ruby index.rb`，执行整理索引和排版文档的工作。
