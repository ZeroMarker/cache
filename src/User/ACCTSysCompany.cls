/// 单位,换成dhcca的
Class User.ACCTSysCompany Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysCompany ]
{

Property CompCode As %String(MAXLEN = 20) [ Required, SqlFieldName = comp_code ];

Property CompName As %String(MAXLEN = 40) [ Required, SqlFieldName = comp_name ];

Property Prov As %String(MAXLEN = 20) [ SqlFieldName = prov ];

Property City As %String(MAXLEN = 20) [ SqlFieldName = city ];

Property IsCount As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_count ];

Property Address As %String(MAXLEN = 40) [ SqlFieldName = address ];

Property DisEmail As %String(MAXLEN = 40) [ SqlFieldName = dis_email ];

Property LinkPhone As %String(MAXLEN = 20) [ SqlFieldName = link_phone ];

Property LinkMan As %String(MAXLEN = 40) [ SqlFieldName = linkman ];

Property TaxNo As %String(MAXLEN = 20) [ SqlFieldName = tax_no ];

Property CompLeader As %String(MAXLEN = 40) [ SqlFieldName = comp_leader ];

Property AccManager As %String(MAXLEN = 40) [ SqlFieldName = acc_manager ];

Property CompLevel As %Integer [ Required, SqlFieldName = comp_level ];

Property IsLast As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = is_last ];

Property Spell As %String(MAXLEN = 8) [ SqlFieldName = spell ];

Index PKCompCode On CompCode [ Unique ];

Storage Default
{
<Data name="ACCTSysCompanyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccManager</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
<Value name="4">
<Value>City</Value>
</Value>
<Value name="5">
<Value>CompCode</Value>
</Value>
<Value name="6">
<Value>CompLeader</Value>
</Value>
<Value name="7">
<Value>CompLevel</Value>
</Value>
<Value name="8">
<Value>CompName</Value>
</Value>
<Value name="9">
<Value>DisEmail</Value>
</Value>
<Value name="10">
<Value>IsCount</Value>
</Value>
<Value name="11">
<Value>IsLast</Value>
</Value>
<Value name="12">
<Value>LinkMan</Value>
</Value>
<Value name="13">
<Value>LinkPhone</Value>
</Value>
<Value name="14">
<Value>Prov</Value>
</Value>
<Value name="15">
<Value>Spell</Value>
</Value>
<Value name="16">
<Value>TaxNo</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysCompanyD</DataLocation>
<DefaultData>ACCTSysCompanyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysCompanyD</IdLocation>
<IndexLocation>^User.ACCTSysCompanyI</IndexLocation>
<StreamLocation>^User.ACCTSysCompanyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
