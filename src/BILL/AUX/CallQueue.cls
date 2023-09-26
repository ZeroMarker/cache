/// 名称: BILL.AUX.CallQueue.cls
/// 描述: 叫号队列表
/// 编写者: ZhYW
/// 编写日期: 2021-08-18
/// 产品组：计费医保组
Class BILL.AUX.CallQueue Extends (%Persistent, User.Abstract)
{

Property PAPMIDR As User.PAPatMas(CAPTION = "患者主索引") [ Required, SqlColumnNumber = 2 ];

Property AdmDR As User.PAAdm(CAPTION = "就诊RowID") [ SqlColumnNumber = 3 ];

Property CreatServer As %String(CAPTION = "生成队列终端号") [ SqlColumnNumber = 4 ];

Property CreatDate As %Date(CAPTION = "创建日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

Property CreatTime As %Time(CAPTION = "创建时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

Property CreatUserDR As User.SSUser(CAPTION = "创建人") [ SqlColumnNumber = 7 ];

/// OPPay:门诊收费, OPDep:门诊预交金, HDDep:血透押金, IPReg:住院登记, IPDep:住院押金, IPPay:出院结算
Property BIZType As %String(CAPTION = "业务类型", TRUNCATE = 1, VALUELIST = ",OPPay,OPDep,HDDep,IPReg,IPDep,IPPay") [ SqlColumnNumber = 8 ];

/// OP:门诊, IP:住院
Property QueueType As %String(CAPTION = "队列类型", TRUNCATE = 1, VALUELIST = ",OP,IP") [ Required, SqlColumnNumber = 9 ];

Property QueueNo As %String(CAPTION = "队列号") [ Required, SqlColumnNumber = 10 ];

/// G:待叫号, C:已叫号, P:过号
Property CalledStatus As %String(CAPTION = "叫号状态", TRUNCATE = 1, VALUELIST = ",G,C,P") [ InitialExpression = "N", SqlColumnNumber = 11 ];

Property UpdateDate As %Date(CAPTION = "更新日期", FORMAT = 1) [ SqlColumnNumber = 12 ];

Property UpdateTime As %Time(CAPTION = "更新时间") [ SqlColumnNumber = 13 ];

Property UpdateUserDR As User.SSUser(CAPTION = "更新操作员") [ SqlColumnNumber = 14 ];

Property CalledClient As %String(CAPTION = "叫号终端") [ SqlColumnNumber = 15 ];

Property NumOfCalls As %Integer(CAPTION = "叫号次数") [ InitialExpression = 0, SqlColumnNumber = 16 ];

/// 过号时重新生成一条新队列，生成的新队列存原队列ID
Property InitQueueDR As BILL.AUX.CallQueue(CAPTION = "原队列记录ID") [ SqlColumnNumber = 17 ];

Property HospDR As User.CTHospital(CAPTION = "院区指针") [ Required, SqlColumnNumber = 18 ];

Index QueTypeQueNo On (QueueType As Exact, QueueNo As Exact);

Index QueTypeCalled On (QueueType As Exact, CalledStatus As Exact);

Index QueTypeDate On (QueueType As Exact, CreatDate As Exact);

Storage Default
{
<Data name="CallQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAPMIDR</Value>
</Value>
<Value name="3">
<Value>AdmDR</Value>
</Value>
<Value name="4">
<Value>CreatServer</Value>
</Value>
<Value name="5">
<Value>CreatDate</Value>
</Value>
<Value name="6">
<Value>CreatTime</Value>
</Value>
<Value name="7">
<Value>CreatUserDR</Value>
</Value>
<Value name="8">
<Value>BIZType</Value>
</Value>
<Value name="9">
<Value>QueueType</Value>
</Value>
<Value name="10">
<Value>QueueNo</Value>
</Value>
<Value name="11">
<Value>CalledStatus</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>UpdateUserDR</Value>
</Value>
<Value name="15">
<Value>CalledClient</Value>
</Value>
<Value name="16">
<Value>NumOfCalls</Value>
</Value>
<Value name="17">
<Value>InitQueueDR</Value>
</Value>
<Value name="18">
<Value>HospDR</Value>
</Value>
</Data>
<DataLocation>^BILL.AUX.CallQueueD</DataLocation>
<DefaultData>CallQueueDefaultData</DefaultData>
<IdLocation>^BILL.AUX.CallQueueD</IdLocation>
<IndexLocation>^BILL.AUX.CallQueueI</IndexLocation>
<StreamLocation>^BILL.AUX.CallQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
