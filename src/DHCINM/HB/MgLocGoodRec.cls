/// Creater:wangpf
/// Descriptions:科室好人好事记录
/// Date:2020-07-11
Class DHCINM.HB.MgLocGoodRec Extends %Persistent
{

/// 记录病区
Property GoodWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Good_Ward ];

/// 记录日期
Property GoodDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Good_Date ];

/// 记录时间
Property GoodTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Good_Time ];

/// 记录地点
Property GoodLocation As %String [ SqlColumnNumber = 5, SqlFieldName = Good_Location ];

/// 记录参与人
Property GoodParticipant As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Good_Participant ];

/// 记录内容
Property GoodContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Good_Content ];

/// 记录状态 N:保存 Y:提交
Property GoodStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 8, SqlFieldName = Good_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 9, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = Create_Time ];

Index ToolIndex On (GoodDate, GoodWard, GoodStatus);

Storage Default
{
<Data name="MgLocGoodRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GoodWard</Value>
</Value>
<Value name="3">
<Value>GoodDate</Value>
</Value>
<Value name="4">
<Value>GoodTime</Value>
</Value>
<Value name="5">
<Value>GoodLocation</Value>
</Value>
<Value name="6">
<Value>GoodParticipant</Value>
</Value>
<Value name="7">
<Value>GoodContent</Value>
</Value>
<Value name="8">
<Value>GoodStatus</Value>
</Value>
<Value name="9">
<Value>Creator</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgLocGoodRecD</DataLocation>
<DefaultData>MgLocGoodRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgLocGoodRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgLocGoodRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgLocGoodRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
