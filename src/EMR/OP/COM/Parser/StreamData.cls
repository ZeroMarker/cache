/// 名称:	EMR.OP.COM.Parser.StreamData
/// 描述:	Stream 解析类
/// 编写者：yejian
/// 编写日期: 2020-12-7
Class EMR.OP.COM.Parser.StreamData Extends %RegisteredObject
{

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
