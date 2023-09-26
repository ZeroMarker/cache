Class User.DHCInvInfo Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InvInfo ]
{

Relationship ChildDHCInvInfoItm As User.DHCInvInfoItm [ Cardinality = children, Inverse = INVIParRef ];

/// 发票Id
Property INVId As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INV_Id ];

/// 发票代码
Property INVCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INV_Code ];

/// 发票号
Property INVNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INV_No ];

/// 供应商Rowid
Property INVAPCVMDR As User.APCVendor [ SqlColumnNumber = 5, SqlFieldName = INV_APCVM_DR ];

/// 发票金额
Property INVAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = INV_Amt ];

/// 发票日期
Property INVDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = INV_Date ];

/// 录入人
Property INVCreateUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INV_CreateUser ];

/// 录入日期
Property INVCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = INV_CreateDate ];

/// 录入单时间
Property INVCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INV_CreateTime ];

/// 发票验收标志
Property INVCheckFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = INV_CheckFlag ];

Storage Default
{
<Data name="DHCInvInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INVId</Value>
</Value>
<Value name="3">
<Value>INVCode</Value>
</Value>
<Value name="4">
<Value>INVNo</Value>
</Value>
<Value name="5">
<Value>INVAPCVMDR</Value>
</Value>
<Value name="6">
<Value>INVAmt</Value>
</Value>
<Value name="7">
<Value>INVDate</Value>
</Value>
<Value name="8">
<Value>INVCreateUser</Value>
</Value>
<Value name="9">
<Value>INVCreateDate</Value>
</Value>
<Value name="10">
<Value>INVCreateTime</Value>
</Value>
<Value name="11">
<Value>INVCheckFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCInvInfoD</DataLocation>
<DefaultData>DHCInvInfoDefaultData</DefaultData>
<IdLocation>^User.DHCInvInfoD</IdLocation>
<IndexLocation>^User.DHCInvInfoI</IndexLocation>
<StreamLocation>^User.DHCInvInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
