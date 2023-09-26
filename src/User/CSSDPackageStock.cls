/// 库存盘点表
Class User.CSSDPackageStock Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageStock ]
{

Property CSSDPSPackage As User.CSSDPackage [ SqlColumnNumber = 2, SqlFieldName = CSSDPS_Package_DR ];

Property CSSDPSLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDPS_Label ];

/// 入库日期
Property CSSDPSInDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CSSDPS_InDate ];

/// 入库时间
Property CSSDPSInTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CSSDPS_InTime ];

/// 入库人
Property CSSDPSInUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = CSSDPS_InUserDR ];

/// 失效日期
Property CSSDPSExpDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = CSSDPS_ExpDate ];

/// 确认标志
Property CSSDPSChkFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CSSDPS_ChkFlag ];

/// 第三方标签标志
Property CSSDPSThirdFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CSSDPS_ThirdFlag ];

/// 存放位置
Property CSSDPSLocation As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDPS_Location ];

Index CSSDPSLabelIndex On CSSDPSLabel As Exact;

Index ChkDate On (CSSDPSChkFlag As Exact, CSSDPSInDate As Exact);

Index ThirdDate On (CSSDPSThirdFlag As Exact, CSSDPSInDate As Exact);

Storage Default
{
<Data name="CSSDPackageStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPSPackage</Value>
</Value>
<Value name="3">
<Value>CSSDPSLabel</Value>
</Value>
<Value name="4">
<Value>CSSDPSInDate</Value>
</Value>
<Value name="5">
<Value>CSSDPSInTime</Value>
</Value>
<Value name="6">
<Value>CSSDPSInUserDR</Value>
</Value>
<Value name="7">
<Value>CSSDPSExpDate</Value>
</Value>
<Value name="8">
<Value>CSSDPSChkFlag</Value>
</Value>
<Value name="9">
<Value>CSSDPSThirdFlag</Value>
</Value>
<Value name="10">
<Value>CSSDPSLocation</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageStockD</DataLocation>
<DefaultData>CSSDPackageStockDefaultData</DefaultData>
<IdLocation>^User.CSSDPackageStockD</IdLocation>
<IndexLocation>^User.CSSDPackageStockI</IndexLocation>
<SqlRowIdName>CSSDPS_RowId</SqlRowIdName>
<StreamLocation>^User.CSSDPackageStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
