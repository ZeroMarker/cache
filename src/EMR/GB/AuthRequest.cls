/// 名称:	EMR.GB.AuthRequest
/// 描述:	申请授权表
/// 编写者：yejian
/// 编写日期: 2023-5-16
/// 产品组：电子病历产品组
Class EMR.GB.AuthRequest Extends %Persistent
{

Index IdxReqUser On RequestUserID;

Index IdxReqDt On RequestDate;

Index IdxReqDtUser On (RequestDate, RequestUserID);

Index IdxReqDtDeptUser On (RequestDate, RequestDept);

/// 申请人
Property RequestUserID As User.SSUser;

/// 申请科室
Property RequestDept As User.CTLoc;

/// 发出申请的日期
Property RequestDate As %Date;

/// 发出申请的时间
Property RequestTime As %Time;

/// 申请原因
Property Reason As CT.EMR.DOC.AuthRequestReason;

/// 申请时限
Property TimeLimit As CT.EMR.DOC.AuthTimeList;

/// 申请前内容
Property BeforeRequestContent As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 申请后欲修改的内容
Property AfterRequestContent As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 申请备注
Property Remark As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="AuthRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RequestUserID</Value>
</Value>
<Value name="3">
<Value>RequestDept</Value>
</Value>
<Value name="4">
<Value>RequestDate</Value>
</Value>
<Value name="5">
<Value>RequestTime</Value>
</Value>
<Value name="6">
<Value>Reason</Value>
</Value>
<Value name="7">
<Value>TimeLimit</Value>
</Value>
<Value name="8">
<Value>BeforeRequestContent</Value>
</Value>
<Value name="9">
<Value>AfterRequestContent</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^EMR.GB.AuthRequestD</DataLocation>
<DefaultData>AuthRequestDefaultData</DefaultData>
<IdLocation>^EMR.GB.AuthRequestD</IdLocation>
<IndexLocation>^EMR.GB.AuthRequestI</IndexLocation>
<StreamLocation>^EMR.GB.AuthRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
