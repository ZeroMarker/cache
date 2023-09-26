Class EPRservice.BLPDFSign Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 保存签名文件信息，再物理保存文件成功之后调用
ClassMethod SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, FileName, FilePath As %String)
{
	s obj=##Class(EPRinstance.PDFSign).%New()
	s obj.EpisodeID=EpisodeID
	s obj.PrintDocID=PrintDocID
	s obj.EPRNum=EPRNum
	s obj.FileName=FileName
	s obj.FilePath=FilePath
	s obj.IsValid=1
	s obj.CreateDate=$p($h, ",", 1)
	s obj.CreateTime=$p($h, ",", 2)
	d obj.%Save()
}

/// 获取存在FTP上的路径
ClassMethod GetFilePath(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id=..GetLastValidSign(EpisodeID, PrintDocID, EPRNum)
	q:(id="") ""
		
	s obj=##Class(EPRinstance.PDFSign).%OpenId(id)
	q:(obj="")
	q obj.FilePath
}

/// 取最后一条有效相关的记录，返回ID
ClassMethod GetLastValidSign(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id = ..GetLastSign(EpisodeID, PrintDocID, EPRNum)
	q:(id="") ""
	
	s obj=##Class(EPRinstance.PDFSign).%OpenId(id)
	q:(obj="")	
	
	q:(obj.IsValid=1) id
	
	q ""
}

/// 取最后一条相关的记录，返回ID
ClassMethod GetLastSign(EpisodeID, PrintDocID, EPRNum As %String) As %String
{
	s id=""
	s id=$O(^DHCEPRI.PDFSignI("Idx", " "_EpisodeID, " "_PrintDocID, " "_EPRNum, id), -1)
	q id
}

/// 将所有相关的签名日志记录都设置为失效状态
/// d ##Class(EPRservice.BLHandWrittenSign).SetSignUnvalid(EpisodeID, PrintDocID, EPRNum)
ClassMethod SetSignUnvalid(EpisodeID, PrintDocID, EPRNum As %String)
{
	s id=""
	s log=""
	for {
		s id=$O(^DHCEPRI.PDFSignI("Idx", " "_EpisodeID, " "_PrintDocID, " "_EPRNum, id), -1)
		q:(id="") 
		s log=##Class(EPRinstance.PDFSign).%OpenId(id)
		if (log '= "")
		{
			s log.IsValid=0
			d log.%Save()
			s log=""
		}
    }
}

/// w ##Class(EPRservice.BLPDFSign).IsNeedSign("")
/// 是1，否0 
ClassMethod IsNeedSign(PrintDocID As %String) As %String
{
	q "1"
}

}
