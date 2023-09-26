Class User.CSSDExtDevBindDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDEBD_Rowid, SqlTableName = CSSD_ExtDevBindDetail ]
{

/// 外来器械明细ID
Property CSSDEBDItmDR As User.CSSDItem [ SqlColumnNumber = 2, SqlFieldName = CSSDEBD_Itm_DR ];

/// 外来器械包ID
Property CSSDEBDPackage As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDEBD_Package_DR ];

/// 外来器械明细数
Property CSSDEBDQty As %Numeric [ SqlColumnNumber = 4, SqlFieldName = CSSDEBD_Qty ];

/// 是否植入物
Property CSSDEBDIsImplants As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = CSSDEBD_IsImplants ];

/// 分包数（维护的数量）  1,2,3,4
Property CSSDEBDNum As %Numeric [ SqlColumnNumber = 6, SqlFieldName = CSSDEBD_Num ];

/// 外来器械表id
Property CSSDEBDParrefDr As User.CSSDExtDevBind [ SqlColumnNumber = 7, SqlFieldName = CSSDEBD_Parref_DR ];

/// 外来器械具体标签
Property CSSDEBDLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDEBD_Label ];

/// 分包数（外来器械后两位）  01,02,03,04
Property CSSDEBDPkgNum As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDEBD_PkgNum ];

Index CSSDParrefDrImplantsIndex On (CSSDEBDParrefDr As Exact, CSSDEBDIsImplants As Exact);

Index CSSDParrefDrPkgNumIndex On (CSSDEBDParrefDr As Exact, CSSDEBDPkgNum As Exact);

Index CSSDEBDLabelIndex On CSSDEBDLabel As Exact;

Index ParrefDrPkgDrItmDr On (CSSDEBDParrefDr As Exact, CSSDEBDPackage As Exact, CSSDEBDItmDR As Exact);

Index ParrefDrPkgDrIndex On (CSSDEBDParrefDr As Exact, CSSDEBDPackage As Exact);

Storage Default
{
<Data name="CSSDExtDevBindDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDEBDItmDR</Value>
</Value>
<Value name="3">
<Value>CSSDEBDPackage</Value>
</Value>
<Value name="4">
<Value>CSSDEBDQty</Value>
</Value>
<Value name="5">
<Value>CSSDEBDIsImplants</Value>
</Value>
<Value name="6">
<Value>CSSDEBDNum</Value>
</Value>
<Value name="7">
<Value>CSSDEBDParrefDr</Value>
</Value>
<Value name="8">
<Value>CSSDEBDLabel</Value>
</Value>
<Value name="9">
<Value>CSSDEBDPkgNum</Value>
</Value>
</Data>
<DataLocation>^User.CSSDExtDevBindDetailD</DataLocation>
<DefaultData>CSSDExtDevBindDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDExtDevBindDetailD</IdLocation>
<IndexLocation>^User.CSSDExtDevBindDetailI</IndexLocation>
<SqlRowIdName>CSSDEBD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDExtDevBindDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
