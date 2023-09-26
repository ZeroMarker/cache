Class User.DHCCRMLiPeiRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = LP_RowId, SqlTableName = DHC_CRM_LiPeiRecord ]
{

Parameter ClassName = "User.DHCCRMLiPeiRecord";

/// PAADM
Property LPPAADM As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = LP_PAADM ];

/// 应付Deductible
Property LPDedAmount As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = LP_DedAmount ];

/// 应付CoPay
Property LPCoAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = LP_CoAmount ];

/// 应付NotCover
Property LPNCAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = LP_NCAmount ];

/// 创建人
Property LPUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = LP_UserDr ];

/// 创建时间
Property LPDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = LP_Date ];

/// 实付Deductible
Property LPFactDedAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = LP_FactDedAmount ];

/// Deductible人
Property LPDedUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = LP_DedUserDr ];

/// Deductible时间
Property LPDedDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = LP_DedDate ];

/// 实付CoPay
Property LPFactCoAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = LP_FactCoAmount ];

/// CoPay人
Property LPCoUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = LP_CoUserDr ];

/// CoPay时间
Property LPCoDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = LP_CoDate ];

/// 实付NotCover
Property LPFactNCAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = LP_FactNCAmount ];

/// NotCover人
Property LPNCUserDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = LP_NCUserDr ];

/// NotCover时间
Property LPNCDate As %Library.Date [ SqlColumnNumber = 16, SqlFieldName = LP_NCDate ];

/// 备注
Property LPRemark As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 17, SqlFieldName = LP_Remark ];

/// 应付Amount
Property LPPayAmount As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = LP_PayAmount ];

/// 实付Amount
Property LPFactAmount As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = LP_FactAmount ];

/// 实付人
Property LPFactUserDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = LP_FactUserDr ];

/// 实付时间
Property LPFactDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = LP_FactDate ];

/// PAPMI
Property LPPAPMI As User.PAPerson [ SqlColumnNumber = 22, SqlFieldName = LP_PAPMI ];

/// 平账
Property LPEqual As %Library.String [ SqlColumnNumber = 23, SqlFieldName = LP_Equal ];

/// 平账人
Property LPEqualUserDr As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = LP_EqualUserDr ];

/// 平账时间
Property LPEqualDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = LP_EqualDate ];

Storage Default
{
<Data name="DHCCRMLiPeiRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LPPAADM</Value>
</Value>
<Value name="3">
<Value>LPDedAmount</Value>
</Value>
<Value name="4">
<Value>LPCoAmount</Value>
</Value>
<Value name="5">
<Value>LPNCAmount</Value>
</Value>
<Value name="6">
<Value>LPUserDr</Value>
</Value>
<Value name="7">
<Value>LPDate</Value>
</Value>
<Value name="8">
<Value>LPFactDedAmount</Value>
</Value>
<Value name="9">
<Value>LPDedUserDr</Value>
</Value>
<Value name="10">
<Value>LPDedDate</Value>
</Value>
<Value name="11">
<Value>LPFactCoAmount</Value>
</Value>
<Value name="12">
<Value>LPCoUserDr</Value>
</Value>
<Value name="13">
<Value>LPCoDate</Value>
</Value>
<Value name="14">
<Value>LPFactNCAmount</Value>
</Value>
<Value name="15">
<Value>LPNCUserDr</Value>
</Value>
<Value name="16">
<Value>LPNCDate</Value>
</Value>
<Value name="17">
<Value>LPRemark</Value>
</Value>
<Value name="18">
<Value>LPPayAmount</Value>
</Value>
<Value name="19">
<Value>LPFactAmount</Value>
</Value>
<Value name="20">
<Value>LPFactUserDr</Value>
</Value>
<Value name="21">
<Value>LPFactDate</Value>
</Value>
<Value name="22">
<Value>LPPAPMI</Value>
</Value>
<Value name="23">
<Value>LPEqual</Value>
</Value>
<Value name="24">
<Value>LPEqualUserDr</Value>
</Value>
<Value name="25">
<Value>LPEqualDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMLiPeiRecordD</DataLocation>
<DefaultData>DHCCRMLiPeiRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMLiPeiRecordD</IdLocation>
<IndexLocation>^User.DHCCRMLiPeiRecordI</IndexLocation>
<StreamLocation>^User.DHCCRMLiPeiRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
