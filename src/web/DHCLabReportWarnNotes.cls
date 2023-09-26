Class web.DHCLabReportWarnNotes Extends %Persistent
{

/// w ##Class(web.DHCLabReportWarnNotes).GetNotes(212312||B002||1,"B0180")
ClassMethod GetNotes(TestSetRow, tc) As %String
{
	s TestSetRow=$g(TestSetRow)
	s LabNo=$p(TestSetRow,"||",1),TS=$p(TestSetRow,"||",2),TSCNT=$p(TestSetRow,"||",3)
	i '$l(LabNo) q ""
	i '$l(TS) q ""
	i '$l(TSCNT) q ""
	i $p($g(^TEPI(LabNo,1,TS,TSCNT)),"\",31)'="A" q ""
	s RegNo=$p(^TEPI(LabNo),"\",18) ;登记号
	i '$l(RegNo) q ""	
	
	i '$d(^TEPI(LabNo,1,TS,TSCNT,"DATA",tc)) q ""
	S CurResult=$p(^TEPI(LabNo,1,TS,TSCNT,"DATA",tc),"\",1) 
	s CurAuthDate=$p(^TEPI(LabNo,1,TS,TSCNT),"\",4)
	s CurAuthTime=$p(^TEPI(LabNo,1,TS,TSCNT),"\",5)
	
	s Notes=""
	//如果有 48小时内，肌酐升高大于等于26.5umol/L
	//7天内肌酐升高大于等于1.5倍基础值的
	//提示 急性肾损伤（AKI）可疑
    f  s ADate=$o(^TDHCOldResult(1,RegNo,tc,CurAuthDate),-1) q:(ADate="")!(Notes'="")  d
    .s ATime="" f  S ATime=$o(^TDHCOldResult(1,RegNo,tc,ADate,""),-1) q:(ATime="")!(Notes'="")  d
    ..s fLabno=$o(^TDHCOldResult(1,RegNo,tc,ADate,ATime,""),-1)
    ..i '$L(fLabno) Quit
    ..s fts=$o(^TDHCOldResult(1,RegNo,tc,ADate,ATime,fLabno,""),-1)
    ..i '$l(fts) Quit
    ..S ftscnt=$o(^TDHCOldResult(1,RegNo,tc,ADate,ATime,fLabno,fts,""),-1)
    ..I '$l(ftscnt) Quit
    ..S Result=$p($G(^TEPI(fLabno,1,fts,ftscnt,"DATA",tc)),"\",1) 
    ..//S diffHours=(CurAuthDate-ADate)*24+((CurAuthTime-ATime)/3600)
    ..i (+(CurResult-Result))>=26.5 s Notes="急性肾损伤（AKI）可疑!"
    ..i (+(CurResult-Result)/100)>=0.5 s Notes="急性肾损伤（AKI）可疑!"
	q Notes
}

Storage Default
{
<Data name="DHCLabReportWarnNotesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabReportWarnNotesD</DataLocation>
<DefaultData>DHCLabReportWarnNotesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabReportWarnNotesD</IdLocation>
<IndexLocation>^web.DHCLabReportWarnNotesI</IndexLocation>
<StreamLocation>^web.DHCLabReportWarnNotesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
