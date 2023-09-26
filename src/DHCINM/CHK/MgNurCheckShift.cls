/// Descriptions:护士长夜查房换班
/// Date:2020-06-12
/// Creator:wangpf
Class DHCINM.CHK.MgNurCheckShift Extends %Persistent
{

/// 状态【N:创建,S:提交，NA:交换人护士长审核，HA:护理部审核，B:驳回，C:作废】
Property ShiftStatus As %String [ SqlColumnNumber = 2, SqlFieldName = Shift_Status ];

/// 换班日期
Property ShiftDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Shift_Date ];

/// 交换日期
Property ShiftToDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Shift_ToDate ];

/// 换班人
Property ShiftPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Shift_Per ];

/// 交换人
Property ShiftToPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Shift_ToPer ];

/// 换班班次
Property ShiftPost As DHCINM.CHK.MgQualCheckTask [ SqlColumnNumber = 7, SqlFieldName = Shift_Post ];

/// 交换班次
Property ShiftToPost As DHCINM.CHK.MgQualCheckTask [ SqlColumnNumber = 8, SqlFieldName = Shift_ToPost ];

/// 备注
Property ShiftRemark As %String [ SqlColumnNumber = 9, SqlFieldName = Shift_Remark ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 10, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = CreateTime ];

/// 最后操作人
Property Updator As %String [ SqlColumnNumber = 13, SqlFieldName = Updator ];

/// 最后操作日期
Property UpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = UpdateDate ];

/// 最后操作时间
Property UpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = UpdateTime ];

Index ShiftPer On (ShiftPost, ShiftPer);

Index ShiftToPer On (ShiftToPost, ShiftToPer);

Storage Default
{
<Data name="MgNurCheckShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShiftStatus</Value>
</Value>
<Value name="3">
<Value>ShiftDate</Value>
</Value>
<Value name="4">
<Value>ShiftToDate</Value>
</Value>
<Value name="5">
<Value>ShiftPer</Value>
</Value>
<Value name="6">
<Value>ShiftToPer</Value>
</Value>
<Value name="7">
<Value>ShiftPost</Value>
</Value>
<Value name="8">
<Value>ShiftToPost</Value>
</Value>
<Value name="9">
<Value>ShiftRemark</Value>
</Value>
<Value name="10">
<Value>Creator</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>Updator</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgNurCheckShiftD</DataLocation>
<DefaultData>MgNurCheckShiftDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgNurCheckShiftD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgNurCheckShiftI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgNurCheckShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
