/// 右侧资源区内容
Class EMRmeta.OPResource Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxName On Name;

Property Name As %String(TRUNCATE = 1);

Property Title As %String(TRUNCATE = 1);

Property Frame As %String(TRUNCATE = 1);

Property Content As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Href As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Position As %Integer;

/// 空：不显示； Window：在弹出的资源区内显示； Panel：在主页面的资源区中显示
Property Visible As %String(TRUNCATE = 1);

/// 缩放比例 数字 如90；不缩放则为空
Property Zoom As %String;

/// 滚动条 yes / no; 默认为空，则为no
Property Scrolling As %String;

/// 切换过来的时候，是否刷新 Y为刷新，其他值为不刷新
Property RefreshOnSelect As %String;

/// d ##Class(EMRmeta.OPResource).Init()
ClassMethod Init()
{
	d ##class(EMRmeta.OPResource).%BuildIndices()
		
	s Name = "admHistory"
	s Title = "历史就诊"
	s Frame = ""
	s Content = ""
	s Href = "emr.op.history.csp"
	s Position = "1"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)
	
	s Name = "knowledgeBase"
	s Title = "知识库"
	s Frame = "kbDataFrame"
	s Content = "emr.op.kbtree.csp"
	s Href = ""
	s Position = "2"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)	
	
	s Name = "resDiagnoData"
	s Title = "诊断"
	s Frame = "diagnoDataFrame"
	s Content = "emr.op.diagnodata.csp"
	s Href = ""
	s Position = "3"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)

	s Name = "resOEORDData"
	s Title = "医嘱"
	s Frame = "oeordDataFrame"
	s Content = "emr.op.oeorddata.csp"
	s Href = ""
	s Position = "3"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)			
	
	s Name = "resLISData"
	s Title = "检验结果"
	s Frame = "lisDataFrame"
	s Content = "emr.op.lisdata.csp"
	s Href = ""
	s Position = "4"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)			
	
	s Name = "resPACSData"
	s Title = "检查结果"
	s Frame = "pacsDataFrame"
	s Content = "emr.op.pacsdata.csp"
	s Href = ""
	s Position = "5"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)		
	
	s Name = "resVitalsigns"
	s Title = "生命体征"
	s Frame = "vitalsignsFrame"
	s Content = "emr.op.vitalsigns.csp"
	s Href = ""
	s Position = "7"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)

	s Name = "DIAoeordFrame"
	s Title = "医嘱录入"
	s Frame = "oeordFrame"
	s Content = "../csp/websys.csp?TDIRECTPAGE=oeorder.oplistcustom.new.csp&PatientName=@patientName&EpisodeName=@episodeName"
	s Href = ""
	s Position = "8"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)

	s Name = "DIAoeordCNFrame"
	s Title = "中草药录入"
	s Frame = "oeordCNFrame"
	s Content = "../csp/websys.csp?TDIRECTPAGE=oeorder.cmlistcustom.csp&PatientName=@patientName&EpisodeName=@episodeName"
	s Href = ""
	s Position = "9"
	s Visible = "Panel"
	d ..insertRecord(Name, Title, Frame, Content, Href, Visible, Position)
}

/// d ##class(EMRmeta.OPResource).%BuildIndices()
ClassMethod insertRecord(Name, Title, Frame, Content, Href, Visible As %String, Position As %Integer)
{
	s id=$O(^DHCEMRM.OPResourceI("IdxName"," "_$zcvt(Name,"U"),""))
	q:(""'=id)

	s obj = ##Class(EMRmeta.OPResource).%New()
	s obj.Name = Name
	s obj.Title = Title
	s obj.Frame = Frame
	s obj.Content = Content
	s obj.Href = Href
	s obj.Position = Position
	s obj.Visible = Visible
	d obj.%Save()
}

/// d ##class(EMRmeta.OPResource).UpdateData()
ClassMethod UpdateData()
{
	s id=$O(^DHCEMRM.OPResourceI("IdxName"," "_$zcvt("admHistory","U"),""))
	q:(""=id)
	s obj = ##Class(EMRmeta.OPResource).%OpenId(id)
	s obj.Href = ""	
	s obj.Content = "emr.op.history.csp?PatientID=@patientID&EpisodeID=@episodeID&UserLocID=@userlocID&SsgroupID=@ssgroupID&UserID=@userID"			 
	d obj.%Save()
}

Storage Default
{
<Data name="OPResourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>EMRKey</Value>
</Value>
<Value name="4">
<Value>Link</Value>
</Value>
<Value name="5">
<Value>Title</Value>
</Value>
<Value name="6">
<Value>Frame</Value>
</Value>
<Value name="7">
<Value>Content</Value>
</Value>
<Value name="8">
<Value>Href</Value>
</Value>
<Value name="9">
<Value>Position</Value>
</Value>
<Value name="10">
<Value>Visible</Value>
</Value>
<Value name="11">
<Value>Zoom</Value>
</Value>
<Value name="12">
<Value>Scrolling</Value>
</Value>
<Value name="13">
<Value>RefreshOnSelect</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPResourceD</DataLocation>
<DefaultData>OPResourceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.OPResourceD</IdLocation>
<IndexLocation>^DHCEMRM.OPResourceI</IndexLocation>
<StreamLocation>^DHCEMRM.OPResourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
