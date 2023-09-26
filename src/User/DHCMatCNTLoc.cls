Class User.DHCMatCNTLoc Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCNT_Loc ]
{

Relationship ChildDHCMatCNTLocUser As User.DHCMatCNTLocUser [ Cardinality = children, Inverse = MatCNTLUParRef ];

/// 被评价科室
Property MATCLoc As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = MATC_Loc ];

/// 可点评的科室
Property MATCComLoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = MATC_ComLoc ];

/// 开始日期
Property MATCComStatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MATC_ComStatDate ];

/// 开始时间
Property MATCComStatTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MATC_ComStatTime ];

/// 截止日期
Property MATCComEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MATC_ComEndDate ];

/// 截止时间
Property MATCComEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MATC_ComEndTime ];

/// 激活标志
Property MATCActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MATC_ActiveFlag ];

Index DHCSTMCLIndex On (MATCLoc As Exact, MATCComLoc As Exact);

Storage Default
{
<Data name="User.DHCMatCNTLocUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCLoc</Value>
</Value>
<Value name="3">
<Value>MATCComLoc</Value>
</Value>
<Value name="4">
<Value>MATCComStatDate</Value>
</Value>
<Value name="5">
<Value>MATCComStatTime</Value>
</Value>
<Value name="6">
<Value>MATCComEndDate</Value>
</Value>
<Value name="7">
<Value>MATCComEndTime</Value>
</Value>
<Value name="8">
<Value>MATCActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatCNTLocD</DataLocation>
<DefaultData>User.DHCMatCNTLocDefaultData</DefaultData>
<IdLocation>^User.DHCMatCNTLocD</IdLocation>
<IndexLocation>^User.DHCMatCNTLocI</IndexLocation>
<StreamLocation>^User.DHCMatCNTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
