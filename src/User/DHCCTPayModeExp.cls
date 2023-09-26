Class User.DHCCTPayModeExp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_CTPayModeExp ]
{

Relationship ChildRefundRule As User.DHCCTPayModeRefundRule [ Cardinality = children, Inverse = PRRPERParRef ];

Property PMEAppRefundPMDR As %String(TRUNCATE = 1) [ SqlFieldName = PME_AppRefundPM_DR ];

Property PMEClassName As %String(TRUNCATE = 1) [ SqlFieldName = PME_ClassName ];

Property PMEHardComDR As User.DHCCardHardComManager [ SqlFieldName = PME_HardCom_DR ];

Property PMEIFMode As %String(DISPLAYLIST = ",DLL,WebService,ScanPay", TRUNCATE = 1, VALUELIST = ",DLL,WS,SP") [ Required, SqlFieldName = PME_IFMode ];

Property PMEIOType As %String(DISPLAYLIST = ",OutPatient,InPatient", TRUNCATE = 1, VALUELIST = ",OP,IP") [ SqlFieldName = PME_IOType ];

Property PMEMethodName As %String(TRUNCATE = 1) [ SqlFieldName = PME_MethodName ];

Property PMEPayModeDR As %String(TRUNCATE = 1) [ Required, SqlFieldName = PME_PayMode_DR ];

/// 退费规则有效标志
Property PMERefundFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PME_RefundFlag ];

Index PMEPayModeDRIndex On (PMEIOType, PMEPayModeDR) [ Unique ];

Index PMEPayModeIDIndex On PMEPayModeDR [ Unique ];

Storage Default
{
<Data name="DHCCTPayModeExpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PMEClassName</Value>
</Value>
<Value name="3">
<Value>PMEHardComDR</Value>
</Value>
<Value name="4">
<Value>PMEIFMode</Value>
</Value>
<Value name="5">
<Value>PMEIOType</Value>
</Value>
<Value name="6">
<Value>PMEMethodName</Value>
</Value>
<Value name="7">
<Value>PMEPayModeDR</Value>
</Value>
<Value name="8">
<Value>PMEReundFlag</Value>
</Value>
<Value name="9">
<Value>PMERfeundFlag</Value>
</Value>
<Value name="10">
<Value>PMERefundFlag</Value>
</Value>
<Value name="11">
<Value>PMEAppRefundPMDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCCTPayModeExpD</DataLocation>
<DefaultData>DHCCTPayModeExpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCTPayModeExpD</IdLocation>
<IndexLocation>^User.DHCCTPayModeExpI</IndexLocation>
<StreamLocation>^User.DHCCTPayModeExpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
