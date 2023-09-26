Class DHCEPRFS.INST.MRPrintListRec Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//打印暂存记录表

/// APrintLogStr="PMREpisodeID^PActUserID^PActPages^PActPrice^PActSchemeID^PRemark^PMRItemIDS^PName^PRelationship^PContact^PIDNumber^PPrintTimes~"
/// MRPrintChargeID
Property MRPrintChargeID As %String;

/// MRVersionID
Property MRVersionID As %String;

/// 就诊编号
Property MREpisodeID As %String;

/// 病案号
Property MRMedRecordID As %String;

/// 打印页数
Property ActPages As %Integer;

/// 单价
Property ActPrice As %Float;

/// 方案ID
Property ActSchemeID As %String;

/// 备注
Property Remark As %String;

Property MRItemIDS As %String(MAXLEN = 2048, TRUNCATE = 1);

/// 联系人姓名
Property Name As %String;

/// 关系
Property Relationship As %String;

/// Contact
Property Contact As %String;

/// 身份证
Property IDNumber As %String;

/// 打印份数
Property PrintTimes As %Integer;

Index IdxMRPrintChargeID On MRPrintChargeID;

Storage Default
{
<Data name="MRPrintListRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPrintChargeID</Value>
</Value>
<Value name="3">
<Value>MRVersionID</Value>
</Value>
<Value name="4">
<Value>MREpisodeID</Value>
</Value>
<Value name="5">
<Value>MedRecordNO</Value>
</Value>
<Value name="6">
<Value>PrintTimes</Value>
</Value>
<Value name="7">
<Value>MRItemIDS</Value>
</Value>
<Value name="8">
<Value>ActPages</Value>
</Value>
<Value name="9">
<Value>ActPrice</Value>
</Value>
<Value name="10">
<Value>ActSchemeID</Value>
</Value>
<Value name="11">
<Value>Remark</Value>
</Value>
<Value name="12">
<Value>Name</Value>
</Value>
<Value name="13">
<Value>Relationship</Value>
</Value>
<Value name="14">
<Value>Contact</Value>
</Value>
<Value name="15">
<Value>IDNumber</Value>
</Value>
<Value name="16">
<Value>MRMedRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintListRecD</DataLocation>
<DefaultData>MRPrintListRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintListRecD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintListRecI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintListRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
