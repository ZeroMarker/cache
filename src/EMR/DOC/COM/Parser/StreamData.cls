/// 名称:	EMR.DOC.COM.Parser.StreamData
/// 描述:	Stream 解析类
/// 编写者：yejian
/// 编写日期: 2020-12-7
Class EMR.DOC.COM.Parser.StreamData Extends %RegisteredObject
{

/// 分隔符
Parameter strSpitor = "-----------------------------6da3a15030fde";

/// Creator：      yejain
/// CreatDate：    2020-12-7
/// Description:   模板\实例数据的流数据解析服务 (metadata,sctipts,PresentationData)
/// Table：        
/// Input：        Stream :模板数据流,实例数据流
/// Return：       节点流数据 (metadata,sctipts,PresentationData)
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.Parser.StreamData).Test()	
ClassMethod ParserStream(argstream As %GlobalBinaryStream, argStartlable As %String, argEndlable As %String, len As %String) As %GlobalBinaryStream
{

	s ReturnValue=##Class(%GlobalBinaryStream).%New()
		
	s templatestream=##Class(%GlobalBinaryStream).%New()
	d templatestream.CopyFrom(argstream)
	d templatestream.Rewind()

	s BegLocation=-1
	s EndLocation=-1
	
	s BegLocation = templatestream.FindAt("-1",argStartlable)
	s EndLocation = templatestream.FindAt(BegLocation,argEndlable)
	q:((BegLocation=-1)&&(EndLocation=-1)) ReturnValue
	
	s Readlen=EndLocation-BegLocation+len
	
	d templatestream.Rewind()
	d templatestream.MoveTo(BegLocation)
	
	if (Readlen>32000)
	{
		s tmplen=0
		s count=+Readlen\32000
		
		for i=1:1:count
		{	
			d ReturnValue.Write(templatestream.Read(32000))
			s tmplen=32000*i
		}
		s lastlen=+Readlen-tmplen
		d ReturnValue.Write(templatestream.Read(lastlen))
	}
	else
	{
		d ReturnValue.Write(templatestream.Read(Readlen))
	}
	
	q ReturnValue
}

/// Desc:       根据分隔符截取第一个数据
/// Creator:    yejain
/// CreateDate: 2020-12-7
/// Input:      argStream 源数据流
///            argSeparator 分隔符
/// Output:     argOutFirstStream 返回截取的第一个数据流
///            argOutLastStream 剩下的流数据 
/// Debug:         w ##Class(EMR.DOC.COM.Parser.StreamData).Test1()
ClassMethod GetFirstParserStream(argStream As %GlobalBinaryStream, argSeparator As %String, ByRef argOutFirstStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s lastStream = ##Class(%GlobalBinaryStream).%New()
	q:(argStream.Size <= 0) lastStream
	d argStream.Rewind()
	s begLocation = 1
	s findLocation = argStream.FindAt("-1",argSeparator)
	s endLocation = $case(findLocation,-1:argStream.Size,:findLocation-1)
	d argStream.Rewind()
	d argStream.MoveTo(begLocation)
	s totalLen = endLocation 
	s readLen = 32000
	if (totalLen > readLen) 
	{
		s count = totalLen\readLen
		for i=1:1:count
		{	
			d argOutFirstStream.Write(argStream.Read(readLen))
		}
		s lastLen = totalLen - (count*readLen)
		d argOutFirstStream.Write(argStream.Read(lastLen))	
	}
	else
	{
		d argOutFirstStream.Write(argStream.Read(totalLen))
	}	
	d argStream.Read($l(argSeparator))	
	
    while('argStream.AtEnd)
    {
	    d lastStream.Write(argStream.Read(readLen))
	}
	q lastStream
}

/// Desc:       压缩流数据
/// Creator:    yejain
/// CreateDate: 2022-12-28
/// Table：        
/// Input：        argStream :源数据流(未压缩)
/// Return：       压缩后数据流。压缩后的数据流格式为：压缩数据流段1_argSpitor_压缩数据流段2_argSpitor
/// Others：       
/// Debug:         w ##Class(EMRservice.Parser.StreamData).CompressStream("")
ClassMethod CompressStream(argStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	q:(argStream.Size<1) argStream
	s ReturnValue = ##class(%GlobalBinaryStream).%New()
	s argSpitor=..#strSpitor
	d argStream.Rewind()
    while (argStream.AtEnd = 0)
    {
        s tmpStr = argStream.Read(32000)
        s compressStr = ##class(%SYSTEM.Util).Compress(tmpStr)
        d ReturnValue.Write(compressStr)
        d ReturnValue.Write(argSpitor)
    } 	
    
    q ReturnValue
}

/// Desc:       解压缩流数据
/// Creator:    yejain
/// CreateDate: 2022-12-28
/// Table：        
/// Input：        argStream :源数据流(已压缩 压缩后的数据流格式为：压缩数据流段1_argSpitor_压缩数据流段2_argSpitor ),argSpitor 分割符
/// Return：       解压缩后的流数据。
/// Others：       
/// Debug:         w ##Class(EMRservice.Parser.StreamData).DeCompressStream("")
ClassMethod DeCompressStream(argStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s ReturnValue = ##class(%GlobalBinaryStream).%New()
	s argSpitor=..#strSpitor
	//如果压缩文件不包含分隔符，则直接返回流数据
	s sptNum = argStream.FindAt(1,argSpitor,"")
	q:(sptNum<1) argStream
	s arr = ..SplitStream(argStream,argSpitor)
	
	s key = ""
	while (arr.GetNext(.key))
	{
		s tstream = arr.GetAt(key)
		d tstream.Rewind()
		
		s compressStr = tstream.Read()
		s dStr = ##class(%SYSTEM.Util).Decompress(compressStr)
		d ReturnValue.Write(dStr)
	}	
	
	q ReturnValue
}

/// Desc:       按照分割符分拆流数据
/// Creator:    yejain
/// CreateDate: 2022-12-28
/// Table：        
/// Input：        inStream :数据流
/// Return：       使用分割符分拆流数据后，产生的一个数组对象
/// Others：       原始出处：EMRservice.Export.HtmlPage
/// Debug:         w ##Class(EMRservice.Parser.StreamData).SplitStream("","")	
ClassMethod SplitStream(inStream, splitor) As %ArrayOfObjects
{
	//s arr = ##class(%ArrayOfDataTypes).%New()
	s arr = ##class(%ArrayOfObjects).%New()
	
	q:('$isobject(inStream)) arr
	
	s totSize = inStream.Size
	s cur = 1, pos = 1, idxList = ""
	while (cur '= -1)
	{
		s cur = inStream.FindAt(cur,splitor,"")
		if (cur = "-1")
		{
			q:(pos > totSize)
			s idxList = idxList_$lb(pos_","_totSize)
		}
		else
		{
			s idxList = idxList_$lb(pos_","_(cur-1))
			s pos = cur + $L(splitor)
			s cur = pos
		}
	}

	s count = $LL(idxList), buffer = 32000
	for i = 1:1:count
	{
		s tmp = $lg(idxList,i)
		s start = $p(tmp,",",1)
		s end = $p(tmp,",",2)
		
		d inStream.MoveTo(start)
		s ts = ##class(%GlobalBinaryStream).%New()
		while(start <= end)
		{
			if (start + buffer) > end
			{
				d ts.Write(inStream.Read(end - start + 1))
				s start = end
				quit
			}
			else
			{
				d ts.Write(inStream.Read(buffer))
				s start = start + buffer
			}
		}
		
		//d ts.Rewind()
		//w !,!,ts.Read()
		
		d arr.SetAt(ts,i)
	}
	
	quit arr
}

ClassMethod Test()
{
	
	s obj=##Class(TestSrv.TestTemplate).%OpenId(3)

    s metadata = ##Class(%FileCharacterStream).%New()	
	s metadata.Filename="d:\metadata.txt"
	d metadata.TranslateTableSet("UTF8")
	d metadata.CopyFrom(..ParserStream(obj.TestData,"<MetaData","</MetaData>","11"))
    d metadata.SaveStream()
    d metadata.%Close()

    s stritps = ##Class(%FileCharacterStream).%New()	
	s stritps.Filename="d:\stritps.txt"
	d stritps.TranslateTableSet("UTF8")
	d stritps.CopyFrom(..ParserStream(obj.TestData,"<Scripts>","</Scripts>","10"))
    d stritps.SaveStream()
    d stritps.%Close()
	
	s Presentation = ##Class(%FileCharacterStream).%New()	
	s Presentation.Filename="d:\PresentationData.txt"
	d Presentation.TranslateTableSet("UTF8")
	d Presentation.CopyFrom(..ParserStream(obj.TestData,"<PresentationData>","</PresentationData>","19"))
    d Presentation.SaveStream()
    d Presentation.%Close()
}

ClassMethod Test1()
{
	s argInData = ##Class(%GlobalBinaryStream).%New()
	d argInData.Write("{""params"":{""action"":""LOAD_TEMPLATE"",""args"":{""TemplateVersionID"":""10""}},""product"":""GlobalEMR""}")
	s tmpInData = ##Class(%GlobalBinaryStream).%New()
	d tmpInData.CopyFrom(argInData)
	s separator = "-----------------------------8eb5b37251gef"

		s tmpData = ##Class(%GlobalBinaryStream).%New()
		s tmpInData = ..GetFirstParserStream(tmpInData,separator,.tmpData)
		d tmpData.OutputToDevice()
		d tmpInData.OutputToDevice()
		w !
}

}
