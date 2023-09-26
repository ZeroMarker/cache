/// 配置门诊界面右下角的HIS功能链接
Class EMRmeta.OPHisTools Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxName On Name;

Property Name As %String(TRUNCATE = 1);

Property Position As %Integer;

Property Text As %String(TRUNCATE = 1);

Property ColSpan As %Integer;

Property Link As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Background As %String(TRUNCATE = 1);

Property Color As %String(TRUNCATE = 1);

Property Visible As %String(TRUNCATE = 1);

Property FormWidth As %Integer;

Property FormHeight As %Integer;

/// 当Link设置为链接时，在打开的窗关闭后执行opHistoolMethods中的方法，
Property FnNameAfterClose As %String(TRUNCATE = 1);

/// d ##class(EMRmeta.OPHisTools).%BuildIndices()
ClassMethod insertRecord(Name, Text, Link, Background, Visible As %String, Position, ColSpan As %Integer)
{
	s id=$O(^DHCEMRM.OPHisToolsI("IdxName"," "_$zcvt(Name,"U"),""))
	q:(""'=id)

	s obj = ##Class(EMRmeta.OPHisTools).%New()
	s obj.Name = Name
	s obj.Position = Position
	s obj.Text = Text
	s obj.ColSpan = ColSpan
	s obj.Link = Link
	s obj.Background = Background
	s obj.Visible = Visible
	d obj.%Save()
}

/// d ##Class(EMRmeta.OPHisTools).InitFor8()
ClassMethod InitFor8()
{
	d ##class(EMRmeta.OPHisTools).%BuildIndices()
	
	s Name = "examination"
	s Position = 11
	s Text = "检查申请单"
	s ColSpan = 2
	s Link = "websys.csp?a=a&TMENU=50311&TPAGID=5124606382&PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&WardID="
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "examResult"
	s Position = 12
	s Text = "检查结果"
	s ColSpan = 2
	s Link = "epr.chart.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&ChartID=23&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=&Random=2"
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "allergic"
	s Position = 13
	s Text = "过敏记录"
	s ColSpan = 1 
	s Link = "websys.default.csp?WEBSYS.TCOMPONENT=PAAllergy.ListEMR&PatientID=@patientID&EpisodeID=@episodeID"
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "oeord"
	s Position = 21
	s Text = "医嘱"
	s ColSpan = 2
	s Link = "oeorder.entrysinglelogon.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&CTLOC=@userLocID"
	s Background = "#7B8AEB"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "appointment"
	s Position = 22
	s Text = "预约"
	s ColSpan = 2
	s Link = "dhc.reg.appscheduler.csp?PatientID=@patientID&EpisodeID=@episodeID"
	s Background = "#7B8AEB"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "inpatient"
	s Position = 24
	s Text = "住院证"
	s ColSpan = 2
	s Link = "dhcdocipbooknew.csp?IPBKFlag=Booking&EpisodeID=@episodeID"
	s Background = "#8595d3"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)
	
	
	s Name = "admComplete"
	s Position = 31
	s ColSpan = 6
	s Text = "完成接诊"
	s Link = "href:websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOutPatientList"
	s Background = "#F05948"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)
	
	d ##Class(EMRmeta.OPHisTools).InsertDiag()
}

/// d ##Class(EMRmeta.OPHisTools).Init()
ClassMethod Init()
{
    d ##class(EMRmeta.OPHisTools).%BuildIndices()	
	
	s Name = "examination"
	s Position = 11
	s Text = "检查申请单"
	s ColSpan = 2
	s Link = "websys.csp?a=a&TMENU=50311&TPAGID=5124606382&PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&WardID="
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "examResult"
	s Position = 12
	s Text = "检查结果"
	s ColSpan = 2
	s Link = "epr.chart.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&ChartID=23&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=&Random=2"
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "newPACS"
	s Position = 13
	s Text = "新PACS"
	s ColSpan = 1
	s Link = ""
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "oralPic"
	s Position = 14
	s Text = "口腔图片"
	s ColSpan = 1
	s Link = "epr.chart.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&ChartID=153&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=&Random=2"
	s Background = "#72CD2F"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "oeord"
	s Position = 21
	s Text = "医嘱"
	s ColSpan = 2
	s Link = "oeorder.entrysinglelogon.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&CTLOC=@userLocID"
	s Background = "#7B8AEB"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "appointment"
	s Position = 22
	s Text = "预约"
	s ColSpan = 2
	s Link = "websys.csp?a=a&TMENU=52966&TPAGID=5124606376"
	s Background = "#7B8AEB"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "inpatient"
	s Position = 24
	s Text = "住院证"
	s ColSpan = 2
	s Link = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIPBookNew&IPBKFlag=Booking&PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm&WardID="
	s Background = "#8595d3"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)

	
	s Name = "admComplete"
	s Position = 31
	s ColSpan = 6
	s Text = "完成接诊"
	s Link = ""
	s Background = "#F05948"
	s Visible = "Y"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)
	
	d ##Class(EMRmeta.OPHisTools).InsertDiag()
}

/// d ##Class(EMRmeta.OPHisTools).InsertDiag()
ClassMethod InsertDiag()
{
	
	s Name = "diag"
	s Position = 0
	s ColSpan = 0
	s Text = "诊断"
	s Link = "dhcmrdiagnosnew.csp?PatientID=@patientID&EpisodeID=@episodeID&mradm=@mradm"
	s Background = ""
	s Visible = "N"
	d ..insertRecord(Name, Text, Link, Background, Visible, Position, ColSpan)
}

Storage Default
{
<Data name="OPHisToolsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Position</Value>
</Value>
<Value name="4">
<Value>Text</Value>
</Value>
<Value name="5">
<Value>ColSpan</Value>
</Value>
<Value name="6">
<Value>Link</Value>
</Value>
<Value name="7">
<Value>Background</Value>
</Value>
<Value name="8">
<Value>Visible</Value>
</Value>
<Value name="9">
<Value>Color</Value>
</Value>
<Value name="10">
<Value>FormWidth</Value>
</Value>
<Value name="11">
<Value>FormHeight</Value>
</Value>
<Value name="12">
<Value>FnNameAfterClose</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPHisToolsD</DataLocation>
<DefaultData>OPHisToolsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.OPHisToolsD</IdLocation>
<IndexLocation>^DHCEMRM.OPHisToolsI</IndexLocation>
<StreamLocation>^DHCEMRM.OPHisToolsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
