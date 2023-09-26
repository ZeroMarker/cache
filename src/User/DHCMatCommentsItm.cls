Class User.DHCMatCommentsItm Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCommentsItm ]
{

Index RowIDBasedIDKeyIndex On MATCNTIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MATCNTIParRef As User.DHCMatComments [ Cardinality = parent, Inverse = ChildDHCMatCommentsItm, Required, SqlFieldName = MATCNTI_ParRef ];

Property MATCNTIChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCMatComments($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = MATCNTI_ChildSub ];

Relationship ChildDHCMatCommentsLog As User.DHCMatCommentsLog [ Cardinality = children, Inverse = MATCNTLParRef ];

/// 高值医嘱表RowId
Property MATCNTIHvOrdItmDR As User.DHCHVMatOrdItm [ SqlColumnNumber = 3, SqlFieldName = MATCNTI_HvOrdItm_DR ];

/// 当前结果
Property MATCNTICurrRet As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MATCNTI_CurrRet ];

/// 就诊ID
Property MATCNTIAdmDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = MATCNTI_Adm_DR ];

/// 科室
Property MATCNTIOriLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = MATCNTI_OriLoc_DR ];

/// 医生
Property MATCNTIOriDoctorDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = MATCNTI_OriDoctor_DR ];

// Index DHCSTMCItmIndex On (MATCNTIHvOrdItmDR);

Storage Default
{
<Data name="DHCMatCommentsItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCNTIHvOrdItmDR</Value>
</Value>
<Value name="3">
<Value>MATCNTICurrRet</Value>
</Value>
<Value name="4">
<Value>MATCNTIAdmDR</Value>
</Value>
<Value name="5">
<Value>MATCNTIOriLocDR</Value>
</Value>
<Value name="6">
<Value>MATCNTIOriDoctorDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCMatCommentsItm")</DataLocation>
<DefaultData>DHCMatCommentsItmDefaultData</DefaultData>
<IdLocation>^User.DHCMatCommentsItmC("ChildDHCMatCommentsItm")</IdLocation>
<IndexLocation>^User.DHCMatCommentsItmI</IndexLocation>
<StreamLocation>^User.DHCMatCommentsItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
