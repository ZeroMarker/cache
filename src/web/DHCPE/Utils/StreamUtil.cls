/// Descript:流处理类
/// Creater:	wangguoying
/// CreateDate:	2019-03-26
Class web.DHCPE.Utils.StreamUtil Extends %RegisteredObject
{

/// Descript:往流中插入字符串
/// Input:
/// 				Stream：待插入的流
/// 				Str：待插入的字符串
/// 				Position：插入位置
/// Return: Stream：插入后的流
/// Creater:	wangguoying
/// CreateDate:	2019-03-26
/// Debug: w ##class(web.DHCPE.Utils.StreamUtil).InsertStream()
ClassMethod InsertStream(Stream As %GlobalCharacterStream, Str As %String, Position As %Integer) As %GlobalCharacterStream
{
	q:Stream.IsNull() Stream
	s Len=Stream.SizeGet()
	q:Len<=0 Stream
	s RetStream=##class(%GlobalCharacterStream).%New()
	s $ZT="InsertStreamErr"
	d Stream.Rewind()
	s:Position>1 RetStream=..SubStream(Stream,1,Position-1)
	s LastStream=..SubStream(Stream,Position)
	d RetStream.MoveToEnd()
	d RetStream.Write(Str)
	d RetStream.Rewind()
	s RetStream=..AppendStream(RetStream,LastStream)
	q RetStream
InsertStreamErr
	b ;$ZE
	s $zt=""
	q RetStream
}

/// Descript:截取流
/// Input:
/// 				Stream：待截取的流
/// 				Position：截取位置  从1开始
/// 				Length：截取后流的长度 为0时，截取剩余全部内容
/// Return: Stream：截取后的流
/// Creater:	wangguoying
/// CreateDate:	2019-03-26
/// Debug: w ##class(web.DHCPE.Utils.StreamUtil).SubStream()
ClassMethod SubStream(Stream As %GlobalCharacterStream, Position As %Integer, Length As %Integer = 0)
{
	s RetStream=##class(%GlobalCharacterStream).%New()
	s $ZT="SubStreamErr"
	d Stream.Rewind()
	s SLen=Stream.SizeGet()
	s:(Length>(SLen-Position+1))||(Length=0) Length= SLen-Position+1
	d Stream.MoveTo(Position)
	s Remainder=Length#32652  ;  Stream.Read()一次默认读取32652
	s Divisor=Length\32652
	i Divisor>0
	{
		f i=1:1:Divisor  d
		.d RetStream.Write(Stream.Read(32652))
	}
	i Remainder>0
	{
		d RetStream.Write(Stream.Read(Remainder))
	}
	q RetStream
	
SubStreamErr
	s $zt=""
	q RetStream
}

/// Descript:拼接流
/// Input:
/// 				Stream：流
/// 				AppendStream：待拼接流
/// Return: Stream：拼接后的流
/// Creater:	wangguoying
/// CreateDate:	2019-03-26
/// Debug: w ##class(web.DHCPE.Utils.StreamUtil).SubStream()
ClassMethod AppendStream(Stream As %GlobalCharacterStream, AppendStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s RetStream=##class(%GlobalCharacterStream).%New()
	s $ZT="AppendStreamErr"
	d Stream.Rewind()
	d RetStream.CopyFrom(Stream)
	s Len=AppendStream.SizeGet()
	q:Len=0 RetStream
	s Remainder=Len#32652  ;  Stream.Read()一次默认读取32652
	s Divisor=Len\32652
	s Num=Divisor
	s:Remainder'=0 Num=Num+1
	d RetStream.MoveToEnd()
	d AppendStream.Rewind()
	f i=1:1:Num  d
	.d RetStream.Write(AppendStream.Read(32652))
	q RetStream
AppendStreamErr
	b ;$ze
	s $zt=""
	q RetStream
}

/// Descript:判断参数是否是流
/// Input:
/// 				Variable：入参
/// Return: 0：否   1：是
/// Creater:	wangguoying
/// CreateDate:	2019-03-26
/// Debug: w ##class(web.DHCPE.Utils.StreamUtil).IsStream()
ClassMethod IsStream(Variable)
{
	s $zt="IsStreamErr"
	q Variable.%Extends("%Stream.Object")
IsStreamErr
	q 0
}

ClassMethod EncodeStream(Stream As %GlobalCharacterStream, Encode As %String = "") As %GlobalCharacterStream
{
	s RetStream=##class(%GlobalCharacterStream).%New()
	s:Encode="" Encode="UTF8"
	s $ZT="EncodeStreamErr"
	while 'Stream.AtEnd{
		s ReadStr=Stream.Read()
		d RetStream.Write($ZCVT(ReadStr,"I",Encode))
	}
	q RetStream
EncodeStreamErr
	s $ZT=""
	q RetStream
}

}
