/// 参数配置子表
Class User.CSSDParameterItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = PI_RowId, SqlTableName = CSSD_ParameterItm ]
{

Relationship ParameterItmParRef As User.CSSDParameter [ Cardinality = parent, Inverse = ChildParameterItm, Required, SqlFieldName = PI_ParRef ];

/// 配置单位（安全组，科室，人员，医院）
Property PIType As %String(COLLATION = "Exact", DISPLAYLIST = ",SS_Group,CT_Loc,SS_User,DHC", MAXLEN = 8, SELECTIVITY = "20.0000%", VALUELIST = ",G,L,U,D") [ SqlColumnNumber = 3, SqlFieldName = PI_Type ];

/// 配置单位id
Property PIPointer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PI_Pointer ];

/// 参数值
Property PIValue As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PI_Value ];

/// 院区
Property PIHospitalDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = PI_Hospital_DR ];

/// 生效日期
Property PIStDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = PI_StDate ];

Index HospTypePointer On (PIHospitalDR As Exact, PIType As Exact, PIPointer As Exact);

Index TypePointer On (PIType As Exact, PIPointer As Exact);

Storage Default
{
<Data name="CSSDParameterItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3">
<Value>PIType</Value>
</Value>
<Value name="4">
<Value>PIPointer</Value>
</Value>
<Value name="5">
<Value>PIValue</Value>
</Value>
<Value name="6">
<Value>PIHospitalDR</Value>
</Value>
<Value name="7">
<Value>PIStDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Itm")</DataLocation>
<DefaultData>CSSDParameterItmDefaultData</DefaultData>
<IdLocation>^User.CSSDParameterC("ChildParameterItm")</IdLocation>
<IndexLocation>^User.CSSDParameterItmI</IndexLocation>
<SqlRowIdName>PI_RowId</SqlRowIdName>
<StreamLocation>^User.CSSDParameterItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
