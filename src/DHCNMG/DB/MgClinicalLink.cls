/// Creator:gzj
/// Date:2018-08-11
/// Description:临床工作项目关联医嘱 用法
Class DHCNMG.DB.MgClinicalLink Extends %Persistent [ Owner = {dhpm1} ]
{

Property LinkParref As DHCNMG.DB.MgClinicalTypeSub [ SqlColumnNumber = 2, SqlFieldName = Link_Parref ];

/// User.ARCItmMast
Property LinkItmMask As %String [ SqlColumnNumber = 3, SqlFieldName = Link_ItmMask ];

/// User.PHCInstruc
Property LinkInstruc As %String [ SqlColumnNumber = 4, SqlFieldName = Link_Instruc ];

/// 状态
Property LinkStatus As %String [ SqlColumnNumber = 5, SqlFieldName = LinkStatus ];

Index Mask On (LinkStatus, LinkItmMask);

Index Instruc On (LinkStatus, LinkInstruc);

Index parref On (LinkStatus, LinkParref);

Storage Default
{
<Data name="MgClinicalLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LinkParref</Value>
</Value>
<Value name="3">
<Value>LinkItmMask</Value>
</Value>
<Value name="4">
<Value>LinkInstruc</Value>
</Value>
<Value name="5">
<Value>LinkStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgClinicalLinkD</DataLocation>
<DefaultData>MgClinicalLinkDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgClinicalLinkD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgClinicalLinkI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgClinicalLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
