Class EPRmeta.EPRPageURL Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Title As %String(TRUNCATE = 1);

Property URL As %String(MAXLEN = 32767, TRUNCATE = 1);

Property Paras As %String(MAXLEN = 32767, TRUNCATE = 1);

Property Num As %String(MAXLEN = 32767, TRUNCATE = 1);

ClassMethod GetAllPageUrls() As %String
{
	s myTitle = ""
	s myURL = ""
	s myParas = ""
	s result = ""
	&sql(DECLARE MyCursor CURSOR FOR
 		SELECT Title, URL, Paras INTO :myTitle, :myURL, :myParas
 		FROM EPRmeta.EPRPageURL ORDER BY Num)
	
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

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Title:%String,URL:%String,Paras:%String,Num:%String")
{
		SELECT ID,Title,URL,Paras,Num
		FROM EPRmeta.EPRPageURL
		ORDER BY Num
}

Storage Default
{
<Data name="EPRPageURLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionName</Value>
</Value>
<Value name="4">
<Value>Paras</Value>
</Value>
<Value name="5">
<Value>URL</Value>
</Value>
<Value name="6">
<Value>Title</Value>
</Value>
<Value name="7">
<Value>Num</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRPageURLD</DataLocation>
<DefaultData>EPRPageURLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRPageURLD</IdLocation>
<IndexLocation>^DHCEPRM.EPRPageURLI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRPageURLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
