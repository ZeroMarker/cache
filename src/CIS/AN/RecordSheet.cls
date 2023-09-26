/// 手术麻醉记录表单
Class CIS.AN.RecordSheet Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = RecordSheet ]
{

/// 手术ID
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 表单所属的数据模块
Property DataModule As CT.AN.DataModule [ Required, SqlColumnNumber = 3 ];

/// 表单创建人
Property CreateUser As %String [ Required, SqlColumnNumber = 4 ];

/// 表单创建日期
Property CreateDate As %Date [ InitialExpression = {+$H}, SqlColumnNumber = 5 ];

/// 表单创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 表单最后更新人
Property UpdateUser As %String [ SqlColumnNumber = 7 ];

/// 表单最后更新日期
Property UpdateDate As %Date [ InitialExpression = {+$H}, SqlColumnNumber = 8 ];

/// 表单最后更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9 ];

/// 表单归档人
Property FileUser As %String [ SqlColumnNumber = 10 ];

/// 表单归档日期
Property FileDate As %Date [ InitialExpression = {+$H}, SqlColumnNumber = 11 ];

/// 表单归档时间
Property FileTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12 ];

/// 表单归档位置
Property FilePath As %String(MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 编辑标志
Property EditFlag As %String(DISPLAYLIST = ",正常,已提交,已归档,已删除", VALUELIST = ",N,S,A,D") [ SqlColumnNumber = 14 ];

/// 表单提交用户
Property SubmitUser As %String [ SqlColumnNumber = 15 ];

/// 表单提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 16 ];

/// 表单提交时间
Property SubmitTime As %Time [ SqlColumnNumber = 17 ];

/// 表单名称
Property SheetName As %String(MAXLEN = 200) [ SqlColumnNumber = 18 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="RecordSheetDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>DataModule</Value>
</Value>
<Value name="3">
<Value>CreateUser</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>FileUser</Value>
</Value>
<Value name="10">
<Value>FileDate</Value>
</Value>
<Value name="11">
<Value>FileTime</Value>
</Value>
<Value name="12">
<Value>FilePath</Value>
</Value>
<Value name="13">
<Value>EditFlag</Value>
</Value>
<Value name="14">
<Value>SubmitUser</Value>
</Value>
<Value name="15">
<Value>SubmitDate</Value>
</Value>
<Value name="16">
<Value>SubmitTime</Value>
</Value>
<Value name="17">
<Value>SheetName</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.RecordSheetD</DataLocation>
<DefaultData>RecordSheetDefaultData</DefaultData>
<IdLocation>^CIS.AN.RecordSheetD</IdLocation>
<IndexLocation>^CIS.AN.RecordSheetI</IndexLocation>
<StreamLocation>^CIS.AN.RecordSheetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
