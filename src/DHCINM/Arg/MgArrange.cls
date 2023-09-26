/// creator:xbl
/// date:20170804
/// desc:排班记录类
Class DHCINM.Arg.MgArrange Extends %Persistent
{

/// 排班单号 开始日期+病区Id
Property ArgListNo As %String [ SqlColumnNumber = 2, SqlFieldName = Arg_ListNo ];

/// 病区Id
Property ArgWardDR As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Arg_WardDR ];

/// 开始日期
Property ArgStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Arg_StDate ];

/// 结束日期
Property ArgEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Arg_EndDate ];

/// 备注
Property ArgRemarks As %String(MAXLEN = 10000) [ SqlColumnNumber = 6, SqlFieldName = Arg_Remarks ];

/// 状态 N 草稿 S 保存未提交 R 提交 A 审核 B 驳回
Property ArgStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Arg_Status ];

/// 创建人
Property ArgCrtUser As %String [ SqlColumnNumber = 8, SqlFieldName = Arg_CrtUser ];

/// 创建日期
Property ArgCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Arg_CrtDate ];

/// 创建时间
Property ArgCrtTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Arg_CrtTime ];

/// 申请状态 S 申请 A 授权
Property ArgEditFlag As %String [ SqlColumnNumber = 11, SqlFieldName = Arg_EditFlag ];

/// 授权开始日期
Property ArgAuthorDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Arg_AuthorDate ];

/// 授权开始时间
Property ArgAuthorTime As %Time [ SqlColumnNumber = 13, SqlFieldName = Arg_AuthorTime ];

/// 授权小时数
Property ArgAuthorHours As %Integer [ SqlColumnNumber = 14, SqlFieldName = Arg_AuthorHours ];

/// 提交日期
Property ArgSubmitDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Arg_SubmitDate ];

/// 提交时间
Property ArgSubmitTime As %Time [ SqlColumnNumber = 16, SqlFieldName = Arg_SubmitTime ];

/// 备注2
Property ArgOtherRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 17, SqlFieldName = Arg_OtherRemark ];

Index ListNo On ArgListNo;

Index Ward On ArgWardDR;

Index WardDate On (ArgWardDR, ArgStDate, ArgEndDate);

Index WardEndDate On (ArgWardDR, ArgEndDate);

Storage Default
{
<Data name="MgArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgListNo</Value>
</Value>
<Value name="3">
<Value>ArgWardDR</Value>
</Value>
<Value name="4">
<Value>ArgStDate</Value>
</Value>
<Value name="5">
<Value>ArgEndDate</Value>
</Value>
<Value name="6">
<Value>ArgRemarks</Value>
</Value>
<Value name="7">
<Value>ArgStatus</Value>
</Value>
<Value name="8">
<Value>ArgCrtUser</Value>
</Value>
<Value name="9">
<Value>ArgCrtDate</Value>
</Value>
<Value name="10">
<Value>ArgCrtTime</Value>
</Value>
<Value name="11">
<Value>ArgEditFlag</Value>
</Value>
<Value name="12">
<Value>ArgAuthorDate</Value>
</Value>
<Value name="13">
<Value>ArgAuthorTime</Value>
</Value>
<Value name="14">
<Value>ArgAuthorHours</Value>
</Value>
<Value name="15">
<Value>ArgSubmitDate</Value>
</Value>
<Value name="16">
<Value>ArgSubmitTime</Value>
</Value>
<Value name="17">
<Value>ArgOtherRemark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgArrangeD</DataLocation>
<DefaultData>MgArrangeDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArrangeD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArrangeI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
