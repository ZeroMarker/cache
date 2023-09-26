/// creator:xbl
/// createdate:20170810
/// desc:科室
Class DHCNMG.DB.MgWardLoc Extends %Persistent
{

/// 代码
Property LocCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Loc_Code ];

/// 描述
Property LocDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Loc_Desc ];

/// CT_LocRowId
Property CTLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = CT_LocDR ];

/// 科室护士长
Property LocNurHeadDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 5, SqlFieldName = Loc_NurHeadDR ];

/// 启用日期
Property LocStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Loc_StDate ];

/// 停用日期 
Property LocEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Loc_EndDate ];

/// 所属片区（大科）
Property LocAreaDR As DHCNMG.DB.MgWardArea [ SqlColumnNumber = 8, SqlFieldName = Loc_AreaDR ];

Index Code On LocCode [ Unique ];

Index Loc On CTLocDR [ Condition = {CT_LocDR'=""} ];

Index NurHead On LocNurHeadDR [ Condition = {Loc_NurHeadDR'=""} ];

Index Area On LocAreaDR;

Index Desc On LocDesc;

Storage Default
{
<Data name="MgWardLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocCode</Value>
</Value>
<Value name="3">
<Value>LocDesc</Value>
</Value>
<Value name="4">
<Value>CTLocDR</Value>
</Value>
<Value name="5">
<Value>LocNurHeadDR</Value>
</Value>
<Value name="6">
<Value>LocStDate</Value>
</Value>
<Value name="7">
<Value>LocEndDate</Value>
</Value>
<Value name="8">
<Value>LocAreaDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgWardLocD</DataLocation>
<DefaultData>MgWardLocDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgWardLocD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgWardLocI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgWardLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
