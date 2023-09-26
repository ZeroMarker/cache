Class DHCEPRFS.INST.MRPrintChargeDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//打印病案收费记录子表

/// 关联主表
Relationship TheMRPrintCharge As DHCEPRFS.INST.MRPrintCharge [ Cardinality = parent, Inverse = TheMRPrintChargeDetail ];

/// 序号
Property DetailNum As %Integer [ Required ];

/// 就诊ID
Property MREpisodeID As %String;

/// 病案ID
Property MRMedRecordID As %String;

/// 收费类别编码 10 邮寄费 20 基础费 30 打印费
Property ChargeTypeCode As %String [ Required ];

/// MRLogDetail 表ID
Property MRLogDetailID As %String;

/// 打印时间
Property PrintTime As %Time;

/// 数量
Property Quan As %Float [ Required ];

/// 单价
Property Price As %Float [ Required ];

/// 金额
Property Amount As %Float [ Required ];

Index IdxMain On (TheMRPrintCharge, DetailNum) [ Unique ];

Index IdxMREpisode On (MREpisodeID, MRMedRecordID);

Index IdxMRLogDetail On MRLogDetailID;

Storage Default
{
<Data name="MRPrintChargeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailNum</Value>
</Value>
<Value name="3">
<Value>MREpisodeID</Value>
</Value>
<Value name="4">
<Value>MRMedRecordID</Value>
</Value>
<Value name="5">
<Value>ChargeTypeCode</Value>
</Value>
<Value name="6">
<Value>MRLogDetailID</Value>
</Value>
<Value name="7">
<Value>Quan</Value>
</Value>
<Value name="8">
<Value>Price</Value>
</Value>
<Value name="9">
<Value>Amount</Value>
</Value>
<Value name="10">
<Value>PrintTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheMRPrintChargeDetail")</DataLocation>
<DefaultData>MRPrintChargeDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintChargeC("TheMRPrintChargeDetail")</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintChargeDetI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintChar3FCES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
