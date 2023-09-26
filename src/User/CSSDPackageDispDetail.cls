Class User.CSSDPackageDispDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDPDD_Rowid, SqlTableName = CSSD_PackageDispDetail ]
{

/// 普通循环包发放绑定标签
Property CSSDPDDParrefDr As User.CSSDPackageDisp [ SqlColumnNumber = 2, SqlFieldName = CSSDPDD_Parref_DR ];

Property CSSDPDDLabel As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CSSDPDD_Label ];

Property CSSDPDDPackageDr As User.CSSDPackage [ SqlColumnNumber = 4, SqlFieldName = CSSDPDD_PackageDr ];

/// 包装材料
Property CSSDPDDPackMaterial As User.CSSDMaterial [ SqlColumnNumber = 5, SqlFieldName = CSSDPDD_PackMaterial ];

/// 价格
Property CSSDPDDDispPrice As %Numeric [ InitialExpression = 0, Required, SqlColumnNumber = 6, SqlFieldName = CSSDPDD_DispPrice ];

Property CSSDPDRecUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = CSSDPD_RecUser_DR ];

/// 明细扫码领用日期
Property CSSDPDDUseDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CSSDPDD_UseDate ];

/// 明细扫码领用时间
Property CSSDPDDUseTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CSSDPDD_UseTime ];

/// 明细扫码归还日期
Property CSSDPDDReturnDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = CSSDPDD_ReturnDate ];

/// 明细扫码归还时间
Property CSSDPDDReturnTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = CSSDPDD_ReturnTime ];

/// 领用人
Property CSSDPDDInnurseDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = CSSDPDD_InnurseDr ];

/// 归还人
Property CSSDPDDInurBrDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = CSSDPDD_InurBrDr ];

Index CSSDPDDParrefPackageDr On (CSSDPDDParrefDr As Exact, CSSDPDDPackageDr As Exact);

Index CSSDPDDParref On CSSDPDDParrefDr As Exact;

Index CSSDPDDParrefCSSDPDDLabel On (CSSDPDDParrefDr As Exact, CSSDPDDLabel As Exact);

Index CSSDPDDLabelIndex On CSSDPDDLabel As Exact;

Storage Default
{
<Data name="CSSDPackageDispDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPDDParrefDr</Value>
</Value>
<Value name="3">
<Value>CSSDPDDLabel</Value>
</Value>
<Value name="4">
<Value>CSSDPDDPackageDr</Value>
</Value>
<Value name="5">
<Value>CSSDPDDPackMaterial</Value>
</Value>
<Value name="6">
<Value>CSSDPDDDispPrice</Value>
</Value>
<Value name="7">
<Value>CSSDPDRecUser</Value>
</Value>
<Value name="8">
<Value>CSSDPDDUseDate</Value>
</Value>
<Value name="9">
<Value>CSSDPDDUseTime</Value>
</Value>
<Value name="10">
<Value>CSSDPDDReturnDate</Value>
</Value>
<Value name="11">
<Value>CSSDPDDReturnTime</Value>
</Value>
<Value name="12"/>
<Value name="13"/>
<Value name="14">
<Value>CSSDPDDInnurseDr</Value>
</Value>
<Value name="15">
<Value>CSSDPDDInurBrDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageDispDetailD</DataLocation>
<DefaultData>CSSDPackageDispDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDPackageDispDetailD</IdLocation>
<IndexLocation>^User.CSSDPackageDispDetailI</IndexLocation>
<SqlRowIdName>CSSDPDD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackageDispDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
