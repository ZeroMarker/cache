/// Description： 医用知识库科室对照表
/// Creator：石萧伟
/// Date： 2018-06-19
Class User.MKBLocContrast Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBLC_RowId, SqlTableName = MKB_LocContrast ]
{

/// 医用知识库科室
Property MKBLocDr As User.MKBTerm [ SqlColumnNumber = 2, SqlFieldName = MKB_Loc_Dr ];

/// 基础数据平台科室
Property MKBCTLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MKB_CTLoc_Dr ];

Index LocIndex On (MKBCTLocDr As Exact, MKBLocDr As Exact);

Index MKBLocIndex On (MKBLocDr As Exact, MKBCTLocDr As Exact);

Index MKBCTLocIndex On (MKBCTLocDr As Exact, MKBLocDr As Exact);

Storage Default
{
<Data name="MKBLocContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBLocDr</Value>
</Value>
<Value name="3">
<Value>MKBCTLocDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBLocContrastD</DataLocation>
<DefaultData>MKBLocContrastDefaultData</DefaultData>
<IdLocation>^User.MKBLocContrastD</IdLocation>
<IndexLocation>^User.MKBLocContrastI</IndexLocation>
<StreamLocation>^User.MKBLocContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
