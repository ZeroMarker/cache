Class DHCEPRFS.INST.MRSealUp Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 02 归档就诊主索引ID
Property MREpisodeID As %String [ Required, SqlColumnNumber = 2 ];

/// 03 病历封存原因
Property SealUpReason As %String [ SqlColumnNumber = 3 ];

/// 04 申请病历封存人姓名
Property SealUpName As %String [ SqlColumnNumber = 4 ];

/// 05 申请病历封存人与患者关系
Property SealUpRelation As %String [ SqlColumnNumber = 5 ];

/// 06 申请病历封存人电话
Property SealUpPhone As %String [ SqlColumnNumber = 6 ];

/// 07 主治医生ID
Property SealUpDocID As %String [ SqlColumnNumber = 7 ];

/// 08 医务处医生ID
Property SealUpDeptID As %String [ SqlColumnNumber = 8 ];

/// 09 封存日期
Property SealUpDate As %Date [ SqlColumnNumber = 9 ];

/// 10 封存时间
Property SealUpTime As %Time [ SqlColumnNumber = 10 ];

/// 11 解封主治医生人
Property UnSealDoc As %String [ SqlColumnNumber = 11 ];

/// 12 解封医务处医生
Property UnSealDept As %String [ SqlColumnNumber = 12 ];

/// 13 最后修改日期
Property UnSealDate As %Date [ SqlColumnNumber = 13 ];

/// 14 最后修改时间
Property UnSealTime As %Time [ SqlColumnNumber = 14 ];

/// 15 封存序号
Property SealNo As %Integer [ SqlColumnNumber = 15 ];

/// 16 封存状态(VALUELIST = "SEALED,UNSEALED")
Property SealStatus As %String [ InitialExpression = "SEALED", Required, SqlColumnNumber = 16 ];

/// 17 封存患者姓名
Property SealUpPatientName As %String [ SqlColumnNumber = 17 ];

/// 18 封存患者电话
Property SealUpPatientPhone As %String [ SqlColumnNumber = 18 ];

/// 19 封存版本
Property VersionNum As %Integer [ SqlColumnNumber = 19 ];

/// 本次封存对应的归档版本类型编码
Property VersionTypeCode As %String [ Calculated ];

/// 解除封存操作员
Property UnSealUserID As %String;

Index IdxOnSealNo On (MREpisodeID, SealNo) [ Unique ];

Index IdxOnVersionNum On (MREpisodeID, SealUpDate, SealUpTime) [ Unique ];

Method VersionTypeCodeGet() As %String
{
	q:(i%SealNo = "1") "SEALUP001"
	q:(i%SealNo = "2") "SEALUP002"
	q:(i%SealNo = "3") "SEALUP003"
	q:(i%SealNo = "4") "SEALUP004"
	q:(i%SealNo = "5") "SEALUP005"
	q:(i%SealNo = "6") "SEALUP006"
	q:(i%SealNo = "7") "SEALUP007"
	q:(i%SealNo = "8") "SEALUP008"
	q:(i%SealNo = "9") "SEALUP009"
	q:(i%SealNo = "10") "SEALUP010"
	q ""
}

Storage Default
{
<Data name="MRSealUpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>SealUpReason</Value>
</Value>
<Value name="4">
<Value>SealUpName</Value>
</Value>
<Value name="5">
<Value>SealUpRelation</Value>
</Value>
<Value name="6">
<Value>SealUpUserID</Value>
</Value>
<Value name="7">
<Value>SealUpDate</Value>
</Value>
<Value name="8">
<Value>SealUpTime</Value>
</Value>
<Value name="9">
<Value>UnSealUserID</Value>
</Value>
<Value name="10">
<Value>UnSealDate</Value>
</Value>
<Value name="11">
<Value>UnSealTime</Value>
</Value>
<Value name="12">
<Value>SealNo</Value>
</Value>
<Value name="13">
<Value>SealStatus</Value>
</Value>
<Value name="14">
<Value>SealUpPhone</Value>
</Value>
<Value name="15">
<Value>SealUpDoc</Value>
</Value>
<Value name="16">
<Value>SealUpDept</Value>
</Value>
<Value name="17">
<Value>UnSealDoc</Value>
</Value>
<Value name="18">
<Value>UnSealDept</Value>
</Value>
<Value name="19">
<Value>SealUpPatientName</Value>
</Value>
<Value name="20">
<Value>SealUpDocID</Value>
</Value>
<Value name="21">
<Value>SealUpDeptID</Value>
</Value>
<Value name="22">
<Value>SealUpPatientPhone</Value>
</Value>
<Value name="23">
<Value>VersionNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRSealUpD</DataLocation>
<DefaultData>MRSealUpDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.MRSealUpD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRSealUpI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRSealUpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
