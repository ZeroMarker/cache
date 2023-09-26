/// 辅助功能区收藏夹
Class User.MKBBookMarks Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_BookMarks ]
{

/// Id串(诊断id-属性id*内容id）
Property MKBBMCode As %String(MAXLEN = "") [ SqlFieldName = MKBBM_Code ];

/// 搜索条件串
Property MKBBMDesc As %String(MAXLEN = "") [ SqlFieldName = MKBBM_Desc ];

/// 收藏人（从session取）
Property MKBBMUser As User.SSUser [ SqlFieldName = MKBBM_User ];

/// 收藏科室 （从session取）
Property MKBBMLoc As User.CTLoc [ SqlFieldName = MKBBM_Loc ];

/// 收藏日期
Property MKBBMDate As %Date [ SqlFieldName = MKBBM_Date ];

Index CodeIndex On MKBBMCode;

Index DescIndex On MKBBMDesc;

Index CodeUserLocIndex On (MKBBMCode As Exact, MKBBMDesc As Exact, MKBBMUser As Exact, MKBBMLoc As Exact);

Storage Default
{
<Data name="MKBBookMarksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBBMCode</Value>
</Value>
<Value name="3">
<Value>MKBBMDesc</Value>
</Value>
<Value name="4">
<Value>MKBBMUser</Value>
</Value>
<Value name="5">
<Value>MKBBMLoc</Value>
</Value>
<Value name="6">
<Value>MKBBMDate</Value>
</Value>
</Data>
<DataLocation>^User.MKBBookMarksD</DataLocation>
<DefaultData>MKBBookMarksDefaultData</DefaultData>
<IdLocation>^User.MKBBookMarksD</IdLocation>
<IndexLocation>^User.MKBBookMarksI</IndexLocation>
<StreamLocation>^User.MKBBookMarksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
