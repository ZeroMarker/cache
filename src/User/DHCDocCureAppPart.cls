/// Desc:治疗申请选择部位/穴位记录表
Class User.DHCDocCureAppPart Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_DocCure_AppPart ]
{

Parameter EXTENTSIZE = 250;

/// CAP_CureApp_DR 关联申请单
Property CPPCureAppDR As User.DHCDocCureApp [ SqlColumnNumber = 2, SqlFieldName = CAP_CureApp_DR ];

/// 部位/穴位
Property CAPPartDR As User.DHCDocCurePartSet [ SqlColumnNumber = 3, SqlFieldName = CAP_Part_DR ];

/// 部位/穴位组，通过部位穴位组选择的做记录
Property CAPPartGrpDR As %String [ SqlColumnNumber = 4, SqlFieldName = CAP_PartGrp_DR ];

/// 执行状态，是否在执行时被选择
Property CAPExecStatus As %String [ SqlColumnNumber = 5, SqlFieldName = CAP_ExecStatus ];

/// 关联执行记录
Property CAPOrdExecDR As User.OEOrdExec [ SqlColumnNumber = 6, SqlFieldName = CAP_OrdExec_DR ];

Index CureAppDRIndex On CPPCureAppDR;

Index OrdExecDRIndex On CAPOrdExecDR;

Storage Default
{
<Data name="DHCDocCureAppPartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPPCureAppDR</Value>
</Value>
<Value name="3">
<Value>CAPPartDR</Value>
</Value>
<Value name="4">
<Value>CAPPartGrpDR</Value>
</Value>
<Value name="5">
<Value>CAPExecStatus</Value>
</Value>
<Value name="6">
<Value>CAPOrdExecDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCureAppPartD</DataLocation>
<DefaultData>DHCDocCureAppPartDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCDocCureAppPartD</IdLocation>
<IndexLocation>^User.DHCDocCureAppPartI</IndexLocation>
<StreamLocation>^User.DHCDocCureAppPartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
