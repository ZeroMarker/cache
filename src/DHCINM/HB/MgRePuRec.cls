/// Creater:wangpf
/// Descriptions:奖罚事例记录
/// Date:2020-07-14
Class DHCINM.HB.MgRePuRec Extends %Persistent
{

/// 奖罚病区
Property RecWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Rec_Ward ];

/// 奖罚日期
Property RecDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Rec_Date ];

/// 奖罚时间
Property RecTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Rec_Time ];

/// 奖罚类型 R:奖励 P:处罚
Property RecType As %String(DISPLAYLIST = ",奖励,处罚", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",R,P") [ SqlColumnNumber = 5, SqlFieldName = Rec_Type ];

/// 奖罚类型Sub
Property RecTypeSub As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 6, SqlFieldName = Rec_TypeSub ];

/// 奖罚参与人
Property RecParticipant As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Rec_Participant ];

/// 奖罚原因
Property RecReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Rec_Reason ];

/// 奖罚状态 N:保存 Y:提交
Property RecStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 9, SqlFieldName = Rec_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 10, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = Create_Time ];

Index ToolIndex On (RecDate, RecWard, RecType, RecTypeSub, RecStatus);

Storage Default
{
<Data name="MgRePuRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecWard</Value>
</Value>
<Value name="3">
<Value>RecDate</Value>
</Value>
<Value name="4">
<Value>RecTime</Value>
</Value>
<Value name="5">
<Value>RecType</Value>
</Value>
<Value name="6">
<Value>RecTypeSub</Value>
</Value>
<Value name="7">
<Value>RecParticipant</Value>
</Value>
<Value name="8">
<Value>RecReason</Value>
</Value>
<Value name="9">
<Value>RecStatus</Value>
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
</Data>
<DataLocation>^DHCINM.HB.MgRePuRecD</DataLocation>
<DefaultData>MgRePuRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgRePuRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgRePuRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgRePuRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
