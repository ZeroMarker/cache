Class User.MATLocControConfig Extends (%Persistent, User.Abstract) [ SqlTableName = MAT_LocControlConfig ]
{

/// 安全组
Property MATLCCGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = MATLCC_Group_DR ];

/// 菜单代码
Property MATLCCMenuCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = MATLCC_MenuCode ];

/// 菜单名称
Property MATLCCMenuDesc As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATLCC_MenuDesc ];

/// 控件名称
Property MATLCCComponents As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = MATLCC_Components ];

/// 科室类型
Property MATLCCLocType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATLCC_LocType ];

/// 启用标志
Property MATLCCActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MATLCC_ActiveFlag ];

/// Csp链接
Property MATLCCLinkUrl As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = MATLCC_LinkUrl ];

Index MATLCCGroupCode On (MATLCCGroupDR As Exact, MATLCCMenuCode As Exact);

Storage Default
{
<Data name="MATLocControConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATLCCGroupDR</Value>
</Value>
<Value name="3">
<Value>MATLCCMenuCode</Value>
</Value>
<Value name="4">
<Value>MATLCCMenuDesc</Value>
</Value>
<Value name="5">
<Value>MATLCCComponents</Value>
</Value>
<Value name="6">
<Value>MATLCCLocType</Value>
</Value>
<Value name="7">
<Value>MATLCCActiveFlag</Value>
</Value>
<Value name="8">
<Value>MATLCCLinkUrl</Value>
</Value>
</Data>
<DataLocation>^User.MATLocControConfigD</DataLocation>
<DefaultData>MATLocControConfigDefaultData</DefaultData>
<IdLocation>^User.MATLocControConfigD</IdLocation>
<IndexLocation>^User.MATLocControConfigI</IndexLocation>
<StreamLocation>^User.MATLocControConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
