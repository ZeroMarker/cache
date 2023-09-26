/// 标本
Class CIS.AN.Specimen Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Specimen ]
{

/// 病理申请记录
Property PathologyRecord As CIS.AN.PathologyRecord [ SqlColumnNumber = 2 ];

/// 标本名称
Property Description As %String(MAXLEN = 200) [ SqlColumnNumber = 3 ];

/// 标本数量
Property Qty As %String [ SqlColumnNumber = 4 ];

/// 标本说明
Property Note As %String(MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 标本离体日期
Property OutDate As %Date [ SqlColumnNumber = 6 ];

/// 标本离体时间
Property OutTime As %Time [ SqlColumnNumber = 7 ];

/// 标本固定日期
Property FixedDate As %Date [ SqlColumnNumber = 8 ];

/// 标本固定时间
Property FixedTime As %Time [ SqlColumnNumber = 9 ];

/// 标本处理
Property Handle As %String(DISPLAYLIST = ",送病理,送冰冻,未送检", VALUELIST = ",P,F,N") [ SqlColumnNumber = 10 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 11 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 12 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 13 ];

/// 条码号
Property BarCode As %String [ SqlColumnNumber = 14 ];

/// 标本提交状态
Property Status As %String(DISPLAYLIST = ",未提交,已提交,已接收", VALUELIST = ",N,A,R") [ SqlColumnNumber = 15 ];

/// 标本序号
Property SeqNo As %String [ SqlColumnNumber = 16 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 17 ];

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 18 ];

/// 标本类型
Property SpecimenType As %String(DISPLAYLIST = ",病理标本,冰冻标本", VALUELIST = ",P,F") [ SqlColumnNumber = 19 ];

/// 送出日期
Property SendOutDate As %Date [ SqlColumnNumber = 20 ];

/// 送出时间
Property SendOutTime As %Time [ SqlColumnNumber = 21 ];

/// 浸泡日期
Property SoakDate As %Date [ SqlColumnNumber = 22 ];

/// 浸泡时间
Property SoakTime As %Time [ SqlColumnNumber = 23 ];

/// 创建用户
Property CreateUser As %String [ SqlColumnNumber = 24 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 25 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 26 ];

/// 病理申请记录索引
Index IPath On PathologyRecord;

/// 条码号索引
Index IBarCode On BarCode;

/// 外部系统ID索引
Index IExt On ExternalID [ Unique ];

Index IOPS On OperSchedule;

/// 病理申请记录外键约束
ForeignKey FKPathologyRecord(PathologyRecord) References CIS.AN.PathologyRecord() [ OnDelete = cascade ];

Storage Default
{
<Data name="SpecimenDefaultData">
<Value name="1">
<Value>PathologyRecord</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Qty</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
<Value name="5">
<Value>OutDate</Value>
</Value>
<Value name="6">
<Value>OutTime</Value>
</Value>
<Value name="7">
<Value>FixedDate</Value>
</Value>
<Value name="8">
<Value>FixedTime</Value>
</Value>
<Value name="9">
<Value>Handle</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>BarCode</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>SeqNo</Value>
</Value>
<Value name="16">
<Value>ExternalID</Value>
</Value>
<Value name="17">
<Value>OperSchedule</Value>
</Value>
<Value name="18">
<Value>SpecimenType</Value>
</Value>
<Value name="19">
<Value>SendOutDate</Value>
</Value>
<Value name="20">
<Value>SendOutTime</Value>
</Value>
<Value name="21">
<Value>SoakDate</Value>
</Value>
<Value name="22">
<Value>SoakTime</Value>
</Value>
<Value name="23">
<Value>CreateUser</Value>
</Value>
<Value name="24">
<Value>CreateDate</Value>
</Value>
<Value name="25">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SpecimenD</DataLocation>
<DefaultData>SpecimenDefaultData</DefaultData>
<IdLocation>^CIS.AN.SpecimenD</IdLocation>
<IndexLocation>^CIS.AN.SpecimenI</IndexLocation>
<StreamLocation>^CIS.AN.SpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
