Class User.DHCMatCommentsLog Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCommentsLog ]
{

Index RowIDBasedIDKeyIndex On MATCNTLChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MATCNTLParRef As User.DHCMatCommentsItm [ Cardinality = parent, Inverse = ChildDHCMatCommentsLog, Required, SqlFieldName = MATCNTL_ParRef ];

Property MATCNTLChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCMatComments($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = MATCNTL_ChildSub ];

// Property MATCNTLChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCMatComments($p(%d(0),"||"),"I",$p(%d(0),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = MATCNTL_ChildSub ];

/// 点评日期
Property MATCNTLCommentDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = MATCNTL_CommentDate ];

/// 点评时间
Property MATCNTLCommentTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = MATCNTL_CommentTime ];

/// 点评人
Property MATCNTLCommentUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MATCNTL_CommentUser ];

/// 点评不合格原因ID
Property MATCNTLReasonDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = MATCNTL_Reason_DR ];

/// 点评建议ID
Property MATCNTLAdviceDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = MATCNTL_Advice_DR ];

/// 点评结果
Property MATCNTLResult As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = MATCNTL_Result ];

/// 点评备注
Property MATCNTLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = MATCNTL_Remark ];

Storage Default
{
<Data name="DHCMatCommentsItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATCNTLCommentDate</Value>
</Value>
<Value name="3">
<Value>MATCNTLCommentTime</Value>
</Value>
<Value name="4">
<Value>MATCNTLCommentUser</Value>
</Value>
<Value name="5">
<Value>MATCNTLReasonDR</Value>
</Value>
<Value name="6">
<Value>MATCNTLAdviceDR</Value>
</Value>
<Value name="7">
<Value>MATCNTLResult</Value>
</Value>
<Value name="8">
<Value>MATCNTLRemark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCMatCommentsLog")</DataLocation>
<DefaultData>DHCMatCommentsLogDefaultData</DefaultData>
<IdLocation>^User.DHCMatCommentsLogC("ChildDHCMatCommentsLog")</IdLocation>
<IndexLocation>^User.DHCMatCommentsLogI</IndexLocation>
<StreamLocation>^User.DHCMatCommentsLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
