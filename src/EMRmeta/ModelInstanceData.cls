/// 名称:EMRmeta.ModelInstanceData
/// 描述:病历范例（个人模板）
/// 编写者：Guozongtao
/// 编写日期: 2015-05-11
Class EMRmeta.ModelInstanceData Extends %Persistent
{

Index IdxCreateUser On CreateUser;

Index IdxUsrChartSeq On (CreateUser, ChartItemID, Sequence);

Index IdxModelInsCateID On (CreateUser, ModelInsCategoryID, Sequence);

Index IdxShareLocIDChartSeq On (ShareLocID, ChartItemID, Sequence);

Property Name As %String(TRUNCATE = 1);

/// Copy EMRinstance.ECRecord's Structure
Property CategoryID As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EpisodeType As %String(TRUNCATE = 1);

Property GroupCategoryID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property DocumentType As %String(TRUNCATE = 1);

/// Copy EMRinstance.InstanceData's Structure
Property CreateDate As %Date;

Property CreateTime As %Time;

Property CreateUser As %String(TRUNCATE = 1);

Property GroupItemID As %String(TRUNCATE = 1);

Property GroupItemName As %String(TRUNCATE = 1);

Property HappenDate As %Date;

Property HappenTime As %Time;

Property InstanceData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ModelInstanceDataS");

Property InstanceMetaData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ModelInstanceDataS");

Property InstanceScriptData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ModelInstanceDataS");

Property InstanceMedia As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ModelInstanceDataS");

Property InstanceInitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.ModelInstanceDataS");

Property ListNo As %String(TRUNCATE = 1);

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property ModifyUser As %String(TRUNCATE = 1);

Property Status As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property Title As %String(TRUNCATE = 1);

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

Property TitleCode As %String(TRUNCATE = 1);

Property Memo As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Sequence As %Integer;

Property ModelInsCategoryID As %String(TRUNCATE = 1);

/// First Letter of Pinyin
Property FPinyin As %String;

/// 共享科室 CreateUserLocID
Property ShareLocID As %String;

/// d ##Class(EMRmeta.ModelInstanceData).AddSequence() 
ClassMethod AddSequence()
{
	d ##class(EMRmeta.ModelInstanceData).%BuildIndices()
	s id=""
	for{
		s id = $O(^DHCEMRM.ModelInstanceDataD(id))
		q:(id="")
		s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
		s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(obj.Name," ",""),4,"")
		s obj.Sequence=obj.%Id()
		s obj.ModelInsCategoryID=0
		d obj.%Save()
	}
}

Storage Default
{
<Data name="ModelInstanceDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>CategoryType</Value>
</Value>
<Value name="4">
<Value>ChartItemID</Value>
</Value>
<Value name="5">
<Value>ChartItemType</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>EpisodeType</Value>
</Value>
<Value name="8">
<Value>GroupCategoryID</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
<Value name="10">
<Value>DocumentType</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>CreateUser</Value>
</Value>
<Value name="14">
<Value>GroupItemID</Value>
</Value>
<Value name="15">
<Value>GroupItemName</Value>
</Value>
<Value name="16">
<Value>HappenDate</Value>
</Value>
<Value name="17">
<Value>HappenTime</Value>
</Value>
<Value name="18">
<Value>InstanceData</Value>
</Value>
<Value name="19">
<Value>InstanceMetaData</Value>
</Value>
<Value name="20">
<Value>InstanceScriptData</Value>
</Value>
<Value name="21">
<Value>InstanceMedia</Value>
</Value>
<Value name="22">
<Value>ListNo</Value>
</Value>
<Value name="23">
<Value>ModifyDate</Value>
</Value>
<Value name="24">
<Value>ModifyTime</Value>
</Value>
<Value name="25">
<Value>ModifyUser</Value>
</Value>
<Value name="26">
<Value>Status</Value>
</Value>
<Value name="27">
<Value>TemplateID</Value>
</Value>
<Value name="28">
<Value>TemplateVersion</Value>
</Value>
<Value name="29">
<Value>Title</Value>
</Value>
<Value name="30">
<Value>Remark</Value>
</Value>
<Value name="31">
<Value>TitleCode</Value>
</Value>
<Value name="32">
<Value>Memo</Value>
</Value>
<Value name="33">
<Value>Name</Value>
</Value>
<Value name="34">
<Value>Sequence</Value>
</Value>
<Value name="35">
<Value>ModelInsCategoryID</Value>
</Value>
<Value name="36">
<Value>FPinyin</Value>
</Value>
<Value name="37">
<Value>InstanceInitialData</Value>
</Value>
<Value name="38">
<Value>ShareLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ModelInstanceDataD</DataLocation>
<DefaultData>ModelInstanceDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.ModelInstanceDataD</IdLocation>
<IndexLocation>^DHCEMRM.ModelInstanceDataI</IndexLocation>
<StreamLocation>^DHCEMRM.ModelInstanceDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
