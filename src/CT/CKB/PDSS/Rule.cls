Class CT.CKB.PDSS.Rule Extends %Persistent [ SqlRowIdName = R_RowId, SqlTableName = Rule ]
{

/// 备注  
Property RRemark As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = R_Remark ];

/// 规则名称
Property RName As %String [ SqlColumnNumber = 3, SqlFieldName = R_Name ];

/// 规则状态
/// 新增(Add) /  修改(Edit)  / 发布(Release) / 取消发布(CancelRelease)  / 删除 (Remove)
Property RStatus As %String [ SqlColumnNumber = 4, SqlFieldName = R_Status ];

/// 唯一标识 2020/12/16
Property RUniqeIdentity As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = R_UniqeIdentity ];

Index UniqeIdentity On RUniqeIdentity As Exact;

Storage Default
{
<Data name="RuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RRemark</Value>
</Value>
<Value name="3">
<Value>RName</Value>
</Value>
<Value name="4">
<Value>RStatus</Value>
</Value>
<Value name="5">
<Value>RUniqeIdentity</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.RuleD</DataLocation>
<DefaultData>RuleDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.RuleD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.RuleI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.RuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
