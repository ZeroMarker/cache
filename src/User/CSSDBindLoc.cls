Class User.CSSDBindLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDBL_Rowid, SqlTableName = CSSD_BindLoc ]
{

/// 科室类型：接收科室 （RecLoc） 
Property CSSDBLTypeCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDBL_TypeCode ];

/// 科室类型：申请科室\回收科室\接收科室
Property CSSDBLTypeDesc As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDBL_TypeDesc ];

/// 科室字段
Property CSSDBLLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = CSSDBL_LocDr ];

/// 是否可用
Property CSSDBLUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5, SqlFieldName = CSSDBL_UseFlag ];

/// 是否默认
Property CSSDBLDefaultFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = CSSDBL_DefaultFlag ];

/// 供应中心字段
Property CSSDBLDeptCenterDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = CSSDBL_DeptCenterDr ];

Index CSSDBLTypeLocDrIndex On (CSSDBLTypeCode As Exact, CSSDBLLocDr As Exact);

Index CSSDBLTypeDefaultFlagIndex On (CSSDBLTypeCode As Exact, CSSDBLDefaultFlag As Exact);

Index CSSDBLDeptCenterTypeLocDr On (CSSDBLDeptCenterDr As Exact, CSSDBLTypeCode As Exact, CSSDBLLocDr As Exact);

Storage Default
{
<Data name="CSSDBindLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDBLTypeCode</Value>
</Value>
<Value name="3">
<Value>CSSDBLTypeDesc</Value>
</Value>
<Value name="4">
<Value>CSSDBLLocDr</Value>
</Value>
<Value name="5">
<Value>CSSDBLUseFlag</Value>
</Value>
<Value name="6">
<Value>CSSDBLDefaultFlag</Value>
</Value>
<Value name="7">
<Value>CSSDBLDeptCenterDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDBindLocD</DataLocation>
<DefaultData>CSSDBindLocDefaultData</DefaultData>
<IdLocation>^User.CSSDBindLocD</IdLocation>
<IndexLocation>^User.CSSDBindLocI</IndexLocation>
<SqlRowIdName>CSSDBL_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDBindLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
