Class User.DHCReqInfo Extends (%Persistent, User.Abstract) [ SqlRowIdName = DRQI_RowId, SqlTableName = DHC_ReqInfo ]
{

/// 出库科室
Property DRQIFroLocDr As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = DRQI_FroLoc_Dr ];

/// 请求科室
Property DRQIToLocDr As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = DRQI_ToLoc_Dr ];

Property DRQIInciDr As INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = DRQI_Inci_Dr ];

/// 代码
Property DRQICode As %String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 5, SqlFieldName = DRQI_Code ];

/// 名称
Property DRQIDesc As %String(COLLATION = "Exact", MAXLEN = 220) [ SqlColumnNumber = 6, SqlFieldName = DRQI_Desc ];

/// 数量
Property DRQIQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 7, SqlFieldName = DRQI_Qty ];

/// 单位
Property DRQIUom As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DRQI_Uom ];

/// 第三方ID
Property DRQISecondId As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRQI_SecondId ];

/// 来自哪个平台 SCI ECS
Property DRQIFromSecond As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DRQI_FromSecond ];

/// HIS申请明细id
Property DRQIReqItmDr As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DRQI_ReqItm_Dr ];

Property DRQIUser As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = DRQI_User ];

Property DRQIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DRQI_Date ];

Property DRQITime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DRQI_Time ];

Index Indexfrotoloc On (DRQIFroLocDr As Exact, DRQIToLocDr As Exact);

Storage Default
{
<Data name="ReqInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRQIFroLocDr</Value>
</Value>
<Value name="3">
<Value>DRQIToLocDr</Value>
</Value>
<Value name="4">
<Value>DRQICode</Value>
</Value>
<Value name="5">
<Value>DRQIDesc</Value>
</Value>
<Value name="6">
<Value>DRQIInciDr</Value>
</Value>
<Value name="7">
<Value>DRQIQty</Value>
</Value>
<Value name="8">
<Value>DRQIUom</Value>
</Value>
<Value name="9">
<Value>DRQISecondId</Value>
</Value>
<Value name="10">
<Value>DRQIFromSecond</Value>
</Value>
<Value name="11">
<Value>DRQIReqItmDr</Value>
</Value>
<Value name="12">
<Value>DRQIUser</Value>
</Value>
<Value name="13">
<Value>DRQIDate</Value>
</Value>
<Value name="14">
<Value>DRQITime</Value>
</Value>
</Data>
<DataLocation>^User.DHCReqInfoD</DataLocation>
<DefaultData>ReqInfoDefaultData</DefaultData>
<IdLocation>^User.DHCReqInfoD</IdLocation>
<IndexLocation>^User.DHCReqInfoI</IndexLocation>
<SqlRowIdName>DRQI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCReqInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
