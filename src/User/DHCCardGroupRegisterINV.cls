/// 集团卡注册打印发票日志
Class User.DHCCardGroupRegisterINV Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_CardGroupRegisterINV ]
{

Relationship CGPersons As User.DHCCardGroupPerson [ Cardinality = children, Inverse = ParRef ];

Property CGRCTCompanyDR As %String(TRUNCATE = 1) [ SqlFieldName = CGR_CTCompany_DR ];

/// 对应的发票记录指针
/// DHCCARDGRINV
Property CGRCardINVDR As DHCCardINVPRT [ SqlFieldName = CGR_CardINV_DR ];

/// 集团名称/单位名称
Property CGRGroupName As %String(TRUNCATE = 1) [ SqlFieldName = CGR_GroupName ];

/// 打印发票日期
Property CGRInvPrtDate As %Date [ SqlFieldName = CGR_InvPrtDate ];

/// 集团注册打印发票标志
Property CGRInvPrtFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CGR_InvPrtFlag ];

Property CGRInvPrtTime As %Time [ SqlFieldName = CGR_InvPrtTime ];

/// 注册日期
Property CGRRegDate As %Date [ Required, SqlFieldName = CGR_RegDate ];

Property CGRRegTime As %Time [ Required, SqlFieldName = CGR_RegTime ];

/// 注册人
Property CGRRegUserDR As %String(TRUNCATE = 1) [ Required, SqlFieldName = CGR_RegUser_DR ];

Index CGRCardINVDRIndex On CGRCardINVDR;

Storage Default
{
<Data name="DHCCardGroupRegisterCLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCardGroupRegisterINVDefaultData">
<Value name="1">
<Value>CGRGroupName</Value>
</Value>
<Value name="2">
<Value>CGRCTCompanyDR</Value>
</Value>
<Value name="3">
<Value>CGRRegUserDR</Value>
</Value>
<Value name="4">
<Value>CGRRegDate</Value>
</Value>
<Value name="5">
<Value>CGRRegTime</Value>
</Value>
<Value name="6">
<Value>CGRInvPrtFlag</Value>
</Value>
<Value name="7">
<Value>CGRInvPrtDate</Value>
</Value>
<Value name="8">
<Value>CGRInvPrtTime</Value>
</Value>
<Value name="9">
<Value>CGRCardINVDR</Value>
</Value>
</Data>
<DataLocation>^DHCCARDGRINVD</DataLocation>
<DefaultData>DHCCardGroupRegisterINVDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCARDGRINVD</IdLocation>
<IndexLocation>^DHCCARDGRINVI</IndexLocation>
<StreamLocation>^DHCCARDGRINVS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
