Class User.DHCMatComments Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatComments ]
{

Relationship ChildDHCMatCommentsItm As User.DHCMatCommentsItm [ Cardinality = children, Inverse = MATCNTIParRef ];

/// 点评单号
Property MATCNTNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = MATCNT_No ];

/// 建单日期
Property MATCNTCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = MATCNT_CreateDate ];

/// 建单时间
Property MATCNTCreateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = MATCNT_CreateTime ];

/// 建单人
Property MATCNTCreateUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MATCNT_CreateUser ];

/// 业务类型
Property MATCNTType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = MATCNT_Type ];

/// 提交标志
Property MATCNTSubmFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MATCNT_SubmFlag ];

/// 点评单备注
Property MATCNTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = MATCNT_Remark ];

/// 院区ID
Property MATCNTHospDR As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = MATCNT_Hosp_DR ];

/// 查询条件
Property MATCNTConditions As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 10, SqlFieldName = MATCNT_Conditions ];

Storage Default
{
<Data name="DHCMatCommentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCNTNo</Value>
</Value>
<Value name="3">
<Value>MATCNTCreateDate</Value>
</Value>
<Value name="4">
<Value>MATCNTCreateTime</Value>
</Value>
<Value name="5">
<Value>MATCNTCreateUser</Value>
</Value>
<Value name="6">
<Value>MATCNTType</Value>
</Value>
<Value name="7">
<Value>MATCNTSubmFlag</Value>
</Value>
<Value name="8">
<Value>MATCNTRemark</Value>
</Value>
<Value name="9">
<Value>MATCNTHospDR</Value>
</Value>
<Value name="10">
<Value>MATCNTConditions</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatCommentsD</DataLocation>
<DefaultData>User.DHCMatCommentsDefaultData</DefaultData>
<IdLocation>^User.DHCMatCommentsD</IdLocation>
<IndexLocation>^User.DHCMatCommentsI</IndexLocation>
<StreamLocation>^User.DHCMatCommentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
