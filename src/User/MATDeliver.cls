Class User.MATDeliver Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATD_RowId, SqlTableName = MAT_Deliver ]
{

Relationship ChildMATDeliverItm As User.MATDeliverItm [ Cardinality = children, Inverse = MATDIParRef ];

/// 定数包条码
Property MATDNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = MATD_No ];

/// 订单id
Property MATDINPODR As User.INPO [ SqlColumnNumber = 3, SqlFieldName = MATD_INPO_DR ];

/// 配送单id
Property MATDDeliverId As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATD_DeliverId ];

/// 供应商
Property MATDAPCVMDR As User.APCVendor [ SqlColumnNumber = 5, SqlFieldName = MATD_APCVM_DR ];

/// 科室id
Property MATDCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = MATD_CTLOC_DR ];

/// 录入人
Property MATDCreateUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = MATD_CreateUser ];

/// 录入日期
Property MATDCreateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MATD_CreateDate ];

/// 录入单时间
Property MATDCreateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = MATDCreateTime ];

/// 验收标记(Y/N)
Property MATDAcceptFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = MATD_AcceptFlag ];

Index DeliverId On MATDDeliverId As Exact;

Storage Default
{
<Data name="MATDeliverDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATDNo</Value>
</Value>
<Value name="3">
<Value>MATDINPODR</Value>
</Value>
<Value name="4">
<Value>MATDDeliverId</Value>
</Value>
<Value name="5">
<Value>MATDAPCVMDR</Value>
</Value>
<Value name="6">
<Value>MATDCTLOCDR</Value>
</Value>
<Value name="7">
<Value>MATDCreateUser</Value>
</Value>
<Value name="8">
<Value>MATDCreateDate</Value>
</Value>
<Value name="9">
<Value>MATDCreateTime</Value>
</Value>
<Value name="10">
<Value>MATDAcceptFlag</Value>
</Value>
</Data>
<DataLocation>^User.MATDeliverD</DataLocation>
<DefaultData>MATDeliverDefaultData</DefaultData>
<IdLocation>^User.MATDeliverD</IdLocation>
<IndexLocation>^User.MATDeliverI</IndexLocation>
<SqlRowIdName>MATD_RowId</SqlRowIdName>
<StreamLocation>^User.MATDeliverS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
