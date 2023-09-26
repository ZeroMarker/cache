/// Creater:wangpf
/// Descriptions:外出学习记录
/// Date:2020-08-19
Class DHCINM.HB.MgOutStudyRec Extends %Persistent
{

/// 病区
Property OutWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Out_Ward ];

/// 护士
Property OutNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 3, SqlFieldName = Out_Nurse ];

/// 开始日期
Property OutStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Out_StDate ];

/// 结束日期
Property OutEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Out_EndDate ];

/// 级别
Property OutLevel As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 6, SqlFieldName = Out_Level ];

/// 类型
Property OutType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 7, SqlFieldName = Out_Type ];

/// 是否本专业
Property OutIsSpecial As %Integer [ SqlColumnNumber = 8, SqlFieldName = Out_IsSpecial ];

/// 隶属专业组
Property OutSpecialGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 9, SqlFieldName = Out_SpecialGroup ];

/// 学习内容
Property OutContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Out_Content ];

/// 学习地点
Property OutLocation As %String [ SqlColumnNumber = 11, SqlFieldName = Out_Location ];

/// 学分类型
Property OutScoreType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 12, SqlFieldName = Out_ScoreType ];

/// 学分
Property OutScore As %String [ SqlColumnNumber = 13, SqlFieldName = Out_Score ];

/// 培训单位
Property OutUnit As %String [ SqlColumnNumber = 14, SqlFieldName = Out_Unit ];

/// 费用
Property OutCost As %String [ SqlColumnNumber = 15, SqlFieldName = Out_Cost ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 16, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 17, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = Create_Time ];

Index ToolIndex On (OutStDate, OutWard, OutLevel);

Storage Default
{
<Data name="MgOutStudyRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OutWard</Value>
</Value>
<Value name="3">
<Value>OutNurse</Value>
</Value>
<Value name="4">
<Value>OutStDate</Value>
</Value>
<Value name="5">
<Value>OutEndDate</Value>
</Value>
<Value name="6">
<Value>OutLevel</Value>
</Value>
<Value name="7">
<Value>OutType</Value>
</Value>
<Value name="8">
<Value>OutIsSpecial</Value>
</Value>
<Value name="9">
<Value>OutSpecialGroup</Value>
</Value>
<Value name="10">
<Value>OutContent</Value>
</Value>
<Value name="11">
<Value>OutLocation</Value>
</Value>
<Value name="12">
<Value>OutScoreType</Value>
</Value>
<Value name="13">
<Value>OutScore</Value>
</Value>
<Value name="14">
<Value>OutUnit</Value>
</Value>
<Value name="15">
<Value>OutCost</Value>
</Value>
<Value name="16">
<Value>Creator</Value>
</Value>
<Value name="17">
<Value>CreateDate</Value>
</Value>
<Value name="18">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgOutStudyRecD</DataLocation>
<DefaultData>MgOutStudyRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgOutStudyRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgOutStudyRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgOutStudyRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
