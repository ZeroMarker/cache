Class User.DHCMatCNTOrdReCheck Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_MatCNT_OrdReCheck ]
{

/// 点评明细ID
Property MCNTORComitmDR As User.DHCMatCommentsItm [ SqlColumnNumber = 2, SqlFieldName = MCNTOR_Comitm_DR ];

/// 操作医生
Property MCNTORDocDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = MCNTOR_DocDR ];

/// 医师备注(接受Accept,申诉时存申诉原因)
Property MCNTORDocNote As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = MCNTOR_DocNote ];

/// 医生操作日期
Property MCNTORDocDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = MCNTOR_DocDate ];

/// 医生操作时间
Property MCNTORDocTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = MCNTOR_DocTime ];

/// 审核人
Property MCNTORUser As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = MCNTOR_User ];

/// 审核结果
Property MCNTORResult As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = MCNTOR_Result ];

/// 审核日期
Property MCNTORDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MCNTOR_Date ];

/// 审核时间
Property MCNTORTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MCNTOR_Time ];

/// 审核科室
Property MCNTORLoc As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = MCNTOR_Loc ];

/// 激活标志
Property MCNTORActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MCNTOR_ActiveFlag ];

Index DHCSTMCRCIndex On MCNTORComitmDR As Exact;

Storage Default
{
<Data name="DHCMatCNTOrdReCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MCNTORComitmDR</Value>
</Value>
<Value name="3">
<Value>MCNTORDocDR</Value>
</Value>
<Value name="4">
<Value>MCNTORDocNote</Value>
</Value>
<Value name="5">
<Value>MCNTORDocDate</Value>
</Value>
<Value name="6">
<Value>MCNTORDocTime</Value>
</Value>
<Value name="7">
<Value>MCNTORUser</Value>
</Value>
<Value name="8">
<Value>MCNTORResult</Value>
</Value>
<Value name="9">
<Value>MCNTORDate</Value>
</Value>
<Value name="10">
<Value>MCNTORTime</Value>
</Value>
<Value name="11">
<Value>MCNTORLoc</Value>
</Value>
<Value name="12">
<Value>MCNTORActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatCNTOrdReCheckD</DataLocation>
<DefaultData>User.DHCMatCNTOrdReCheckDefaultData</DefaultData>
<IdLocation>^User.DHCMatCNTOrdReCheckD</IdLocation>
<IndexLocation>^User.DHCMatCNTOrdReCheckI</IndexLocation>
<StreamLocation>^User.DHCMatCNTOrdReCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
