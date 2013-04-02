

注意在正式发布时，需要修改 Config.h 文件中的 IsEnvironmentProd 为 YES，而平时开发时需要保持为 NO。


注意现在数据库是预先生成好的，是 quizDbV1.dat 文件。
如果改动了与原始quiz相关的任何地方，比如加了package或group或quiz，或改了packageConfig.plist，此时要重新生成quizDbV1.dat 文件。
    另外注意在有改动的时候，还可能需要使用 iphone/tools 中的工具作一些加工。
要生成这个文件，可以在 LZDataAccess.initDbMain 中只执行 [[self singleton]initDbWithGeneratedSql];
然后从output的log找到 dbFilePath= 的字样的后面的路径，这个文件就是我们要的预先生成好的数据库文件。但是注意不要去玩app，免得数据不是干净的初始化，而带有游戏数据。







