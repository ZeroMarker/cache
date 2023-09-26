Class EMRservice.BL.BLEPRPageURL Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetAllPageUrls() As %String
{
	s myTitle = ""
	s myURL = ""
	s myParas = ""
	s result = ""
	&sql(DECLARE MyCursor CURSOR FOR
 		SELECT Title, URL, Paras INTO :myTitle, :myURL, :myParas
 		FROM EMRmeta.EPRPageURL ORDER BY Num)
	
		&sql(OPEN MyCursor)
		for {
			&SQL(FETCH MyCursor) 
			Q:SQLCODE
 			s result = result_myURL_"#"_myTitle_"#"_myParas_"^^"
		}
		
		&sql(CLOSE MyCursor)
	q result
	
	//q "./epr.newfw.dhcoeordsch.csp#测试1#PatientID=[patientID]&EpisodeID=[episodeID]^^./epr.chart.csp#测试2#PatientID=[patientID]&EpisodeID=[episodeID]&EpisodeIDs=&mradm=[episodeID]&ChartID=22&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID="
}

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Title:%String,URL:%String,Paras:%String,Num:%String,Type:%String")
{
		SELECT ID,Title,URL,Paras,Num,Type
		FROM EMRmeta.EPRPageURL
		ORDER BY Num
}

ClassMethod UpdateData(rowID As %String, URL As %String, Paras As %String, Title As %String, Num As %String, Type As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EMRmeta.EPRPageURL).%OpenId(rowID)
	q:(EPRPageURL="") "0"
	set EPRPageURL.URL = URL
	set EPRPageURL.Paras = Paras
	set EPRPageURL.Title = Title
	set EPRPageURL.Num = Num
	set EPRPageURL.Type = Type
	s status = EPRPageURL.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

//增加

ClassMethod AddData(URL As %String, Paras As %String, Title As %String, Num As %String, Type As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EMRmeta.EPRPageURL).%New()
	set EPRPageURL.URL = URL
	set EPRPageURL.Paras = Paras
	set EPRPageURL.Title = Title
	set EPRPageURL.Num = Num
	set EPRPageURL.Type = Type
	s status = EPRPageURL.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

//删除

ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EMRmeta.EPRPageURL).%OpenId(rowID)
	q:(EPRPageURL="") "0"
	s status = EPRPageURL.%DeleteId(rowID)
	q:('$$$ISOK(status)) "0"	
	q "1"
}

/// 初始化类型
/// d ##Class(EMRservice.BL.BLEPRPageURL).InitAllPageUrlsType()
ClassMethod InitAllPageUrlsType()
{
	s count = 0
	s num = ""
	for
	{
		s num = $o(^DHCEMRM.EPRPageURLI("IdxNum",num))
		q:(num = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.EPRPageURLI("IdxNum",num,rowId))
			q:(rowId = "")
			s objUrl = ##Class(EMRmeta.EPRPageURL).%OpenId(rowId)
			s objUrl.Type = "EMR"
			d objUrl.%Save()
			s count = count + 1
		}
	}
}

}
