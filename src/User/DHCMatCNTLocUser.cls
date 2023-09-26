Class User.DHCMatCNTLocUser Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCNT_LocUser ]
{

Index RowIDBasedIDKeyIndex On MATCNTLUChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MatCNTLUParRef As User.DHCMatCNTLoc [ Cardinality = parent, Inverse = ChildDHCMatCNTLocUser, Required, SqlFieldName = MatCNTLU_ParRef ];

Property MATCNTLUChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCMatCNTLoc($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = MatCNTLU_ChildSub ];

/// 评价人员
Property MatCNTLUComUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = MatCNTLU_ComUser ];

/// 开始日期
Property MatCNTLUStatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MatCNTLU_StatDate ];

/// 开始时间
Property MatCNTLUStatTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MatCNTLU_StatTime ];

/// 截止日期
Property MatCNTLUEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MatCNTLU_EndDate ];

/// 截止时间
Property MatCNTLUEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MatCNTLU_EndTime ];

/// 激活标志
Property MatCNTLUActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MatCNTLU_ActiveFlag ];

Index DHCSTMCLUIndex On (MatCNTLUParRef As Exact, MatCNTLUComUser As Exact);

Storage Default
{
<Data name="User.DHCMatCNTLocUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MatCNTLUComUser</Value>
</Value>
<Value name="3">
<Value>MatCNTLUStatDate</Value>
</Value>
<Value name="4">
<Value>MatCNTLUStatTime</Value>
</Value>
<Value name="5">
<Value>MatCNTLUEndDate</Value>
</Value>
<Value name="6">
<Value>MatCNTLUEndTime</Value>
</Value>
<Value name="7">
<Value>MatCNTLUActiveFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCMatCNTLocUser")</DataLocation>
<DefaultData>DHCMatCNTLocUserDefaultData</DefaultData>
<IdLocation>^User.DHCMatCNTLocUserC("ChildDHCMatCNTLocUser")</IdLocation>
<IndexLocation>^User.DHCMatCNTLocUserI</IndexLocation>
<StreamLocation>^User.DHCMatCNTLocUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
