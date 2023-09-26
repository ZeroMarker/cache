/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 医生交班本子表
Class User.DHCDocPassWorkNSub Extends (%Persistent, User.Abstract)
{

Relationship ChildLog As User.DHCDocPassWorkNLog [ Cardinality = children, Inverse = LParRef ];

Relationship ChildType As User.DHCDocPassWorkNSubType [ Cardinality = children, Inverse = TParRef ];

Relationship SParRef As User.DHCDocPassWorkNMain [ Cardinality = parent, Inverse = ChildSub, Required, SqlFieldName = S_ParRef ];

/// 病人类型
Property SType As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = S_Type ];

/// 就诊ID
Property SAdmID As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = S_AdmID ];

/// 就诊科室 [和主表一致]
Property SLocID As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = S_LocID ];

/// 班次日期 [和主表一致]
Property SBCDate As %Date [ SqlColumnNumber = 5, SqlFieldName = S_BCDate ];

/// 交班日期 [实际填写日期，一般和班次日期一致]
Property SSubmitDate As %Date [ SqlColumnNumber = 6, SqlFieldName = S_SubmitDate ];

/// 交班时间 [实际填写时间]
Property SSubmitTime As %Time [ SqlColumnNumber = 7, SqlFieldName = S_SubmitTime ];

/// 交班人 [实际填写者]
Property SSubmitUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = S_SubmitUser ];

/// 交班内容
Property SContent As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = S_Content ];

/// 接班日期 
Property SAcceptDate As %Date [ SqlColumnNumber = 10, SqlFieldName = S_AcceptDate ];

/// 接班时间 
Property SAcceptTime As %Time [ SqlColumnNumber = 11, SqlFieldName = S_AcceptTime ];

/// 接班人
Property SAccpetUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = S_AccpetUser ];

/// 接班内容
Property SAcceptContent As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = S_AcceptContent ];

/// 插入日期
Property SAddDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = S_AddDate ];

/// 插入时间
Property SAddTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 15, SqlFieldName = S_AddTime ];

/// 插入人
Property SAddUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = S_AddUser ];

/// 最后修改日期
Property SFDate As %Date [ Required, SqlColumnNumber = 17, SqlFieldName = S_FDate ];

/// 最后修改时间
Property SFTime As %Time [ Required, SqlColumnNumber = 18, SqlFieldName = S_FTime ];

/// 最后修改人
Property SFUser As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = S_FUser ];

Index SAdmID On SAdmID;

Index SAdmLocBCDate On (SAdmID, SLocID, SBCDate);

Storage Default
{
<Data name="DHCDocPassWorkNSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SType</Value>
</Value>
<Value name="3">
<Value>SAdmID</Value>
</Value>
<Value name="4">
<Value>SLocID</Value>
</Value>
<Value name="5">
<Value>SBCDate</Value>
</Value>
<Value name="6">
<Value>SSubmitDate</Value>
</Value>
<Value name="7">
<Value>SSubmitTime</Value>
</Value>
<Value name="8">
<Value>SSubmitUser</Value>
</Value>
<Value name="9">
<Value>SContent</Value>
</Value>
<Value name="10">
<Value>SAcceptDate</Value>
</Value>
<Value name="11">
<Value>SAcceptTime</Value>
</Value>
<Value name="12">
<Value>SAccpetUser</Value>
</Value>
<Value name="13">
<Value>SAcceptContent</Value>
</Value>
<Value name="14">
<Value>SAddDate</Value>
</Value>
<Value name="15">
<Value>SAddTime</Value>
</Value>
<Value name="16">
<Value>SAddUser</Value>
</Value>
<Value name="17">
<Value>SFDate</Value>
</Value>
<Value name="18">
<Value>SFTime</Value>
</Value>
<Value name="19">
<Value>SFUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCDocPassWorkNSubDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNMainC("ChildSub")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNSubI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
