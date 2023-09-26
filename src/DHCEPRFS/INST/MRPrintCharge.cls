Class DHCEPRFS.INST.MRPrintCharge Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//打印病案收费记录主表

/// 打印开始日期
Property BeginActDate As %Date [ Required ];

/// 打印开始时间
Property BeginActTime As %Time [ Required ];

/// 结算日期
Property FootDate As %Date;

/// 结算时间
Property FootTime As %Time;

/// 患者ID
Property MRPatientID As %String [ Required ];

/// 操作员
Property ActUserID As %String [ Required ];

/// 总金额
Property TotalAmount As %Float [ Required ];

/// 结算操作员	2016.03.09 新增
Property FootUserID As %String;

/// 打印操作员
Property PrintUserID As %String;

/// 打印日期
Property PrintDate As %Date;

/// 打印时间
Property PrintTime As %Time;

/// 状态 ("LIST","CHARGE","PRINT")
Property Status As %String;

/// 关联Detail表
Relationship TheMRPrintChargeDetail As DHCEPRFS.INST.MRPrintChargeDetail [ Cardinality = children, Inverse = TheMRPrintCharge ];

Index IdxMRPatient On MRPatientID;

Index IdxActUser On ActUserID;

Index IdxFootDate On FootDate;

Index IdxBeginActDate On BeginActDate;

Index IdxActUserFootDate On (ActUserID, FootDate);

Storage Default
{
<Data name="MRPrintChargeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BeginActDate</Value>
</Value>
<Value name="3">
<Value>BeginActTime</Value>
</Value>
<Value name="4">
<Value>FootDate</Value>
</Value>
<Value name="5">
<Value>FootTime</Value>
</Value>
<Value name="6">
<Value>MRPatientID</Value>
</Value>
<Value name="7">
<Value>ActUserID</Value>
</Value>
<Value name="8">
<Value>TotalAmount</Value>
</Value>
<Value name="9">
<Value>FootUserID</Value>
</Value>
<Value name="10">
<Value>PrintUserID</Value>
</Value>
<Value name="11">
<Value>PrintDate</Value>
</Value>
<Value name="12">
<Value>PrintTime</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRPrintChargeD</DataLocation>
<DefaultData>MRPrintChargeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRPrintChargeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRPrintChargeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRPrintChargeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
