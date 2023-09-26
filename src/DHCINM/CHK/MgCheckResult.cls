/// Creater:wangpf
/// Descriptions:质控查房、夜查房父表
/// Date:2020-06-12
Class DHCINM.CHK.MgCheckResult Extends %Persistent
{

Relationship ChildSub As DHCINM.CHK.MgCheckResultSub [ Cardinality = children, Inverse = Parref ];

/// 被评病区
Property CheckWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Check_Ward ];

/// 检查任务
Property CheckTask As DHCINM.CHK.MgQualCheckTask [ SqlColumnNumber = 3, SqlFieldName = Check_Task ];

/// 质控类型
Property CheckType As CT.DHCINM.Set.MgSysParamSub [ SqlColumnNumber = 4, SqlFieldName = Check_Type ];

/// 质控项目
Property CheckItem As CT.DHCINM.DB.MgQualItem [ SqlColumnNumber = 5, SqlFieldName = Check_Item ];

/// 得分
Property CheckScore As %String [ SqlColumnNumber = 6, SqlFieldName = Check_Score ];

/// 状态 【S:提交 N:未提交】
Property CheckStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Check_Status ];

/// 记录修改人
Property CheckUser As %String [ SqlColumnNumber = 8, SqlFieldName = Check_User ];

/// 备注
Property CheckRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Check_Remark ];

/// 是否重点关注
Property IfFocus As %Boolean [ SqlColumnNumber = 10, SqlFieldName = If_Focus ];

/// 双签人
Property SignUser As %String [ SqlColumnNumber = 11, SqlFieldName = Sign_User ];

/// 护士长签名(夜查房行数据 名称 非ID)
Property CheckNurse As %String [ SqlColumnNumber = 12, SqlFieldName = Check_Nurse ];

/// 评分类型 1：按比例。2：按分值
Property CheckScoreType As %String [ SqlColumnNumber = 13, SqlFieldName = Check_ScoreType ];

/// 评分类型 1:是否模式 2:符合模式 3:得分模式 4:扣分模式 5:选项模式 6:扣分原因模式
Property CheckScoreTypeSub As %String [ SqlColumnNumber = 14, SqlFieldName = Check_ScoreTypeSub ];

/// 评价模式 按分值选项模式有效 1:统一 2:自定义
Property CheckStandardMode As %String [ SqlColumnNumber = 15, SqlFieldName = Check_StandardMode ];

/// 评价标准 按比例或按分值选项模式统一选项时有效
Property CheckStandardList As %String(MAXLEN = 500) [ SqlColumnNumber = 16, SqlFieldName = Check_StandardList ];

/// 插入列 1:患者 2:护士 3:自定义
Property CheckInsert As %String [ SqlColumnNumber = 17, SqlFieldName = Check_Insert ];

/// 插入列默认列数
Property CheckInsertCount As %String [ InitialExpression = 1, SqlColumnNumber = 18, SqlFieldName = Check_InsertCount ];

/// 创建人
Property CreateUser As %String [ Required, SqlColumnNumber = 19, SqlFieldName = Create_User ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 20, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 21, SqlFieldName = Create_Time ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 22, SqlFieldName = Submit_Date ];

/// 提交时间
Property SubmitTime As %Time [ SqlColumnNumber = 23, SqlFieldName = Submit_Time ];

/// 检查日期 夜查房(日历模式)检查日期=任务开始日期=任务结束日期
Property CheckDate As %Date [ SqlColumnNumber = 24, SqlFieldName = Check_Date ];

/// 达标线
Property CheckPass As %String [ SqlColumnNumber = 25, SqlFieldName = Check_Pass ];

/// 插入表头患者
Property InsertHeadPat As list Of %String [ SqlColumnNumber = 26, SqlFieldName = Insert_HeadPat ];

/// 插入表头护士
Property InsertHeadNur As list Of %String [ SqlColumnNumber = 27, SqlFieldName = Insert_HeadNur ];

/// 插入表头自定义
Property InsertHeadInput As list Of %String [ SqlColumnNumber = 28, SqlFieldName = Insert_HeadInput ];

/// 符合模式是否使用分数
Property CheckScoreFlag As %String [ SqlColumnNumber = 29, SqlFieldName = Check_ScoreFlag ];

/// 符合模式使用分值扣分总值
Property CheckAccordScore As %String [ SqlColumnNumber = 30, SqlFieldName = Check_AccordScore ];

/// 符合模式使用分值总值
Property CheckAccordScoreSum As %String [ SqlColumnNumber = 31, SqlFieldName = Check_AccordScoreSum ];

/// 上传图片
Property Picture As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 32, SqlFieldName = Picture ];

Index Qual On (CheckTask, CheckItem);

Index Ward On (CheckTask, CheckItem, CheckWard);

Index Date On (CheckDate, CheckStatus, CheckWard, CheckItem);

Storage Default
{
<Data name="MgCheckResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckWard</Value>
</Value>
<Value name="3">
<Value>CheckTask</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
<Value name="5">
<Value>CheckItem</Value>
</Value>
<Value name="6">
<Value>CheckScore</Value>
</Value>
<Value name="7">
<Value>CheckStatus</Value>
</Value>
<Value name="8">
<Value>CheckUser</Value>
</Value>
<Value name="9">
<Value>CheckRemark</Value>
</Value>
<Value name="10">
<Value>IfFocus</Value>
</Value>
<Value name="11">
<Value>SignUser</Value>
</Value>
<Value name="12">
<Value>CheckNurse</Value>
</Value>
<Value name="13">
<Value>CheckScoreType</Value>
</Value>
<Value name="14">
<Value>CheckScoreTypeSub</Value>
</Value>
<Value name="15">
<Value>CheckStandardMode</Value>
</Value>
<Value name="16">
<Value>CheckStandardList</Value>
</Value>
<Value name="17">
<Value>CheckInsert</Value>
</Value>
<Value name="18">
<Value>CheckInsertCount</Value>
</Value>
<Value name="19">
<Value>CreateUser</Value>
</Value>
<Value name="20">
<Value>CreateDate</Value>
</Value>
<Value name="21">
<Value>CreateTime</Value>
</Value>
<Value name="22">
<Value>SubmitDate</Value>
</Value>
<Value name="23">
<Value>SubmitTime</Value>
</Value>
<Value name="24">
<Value>CheckDate</Value>
</Value>
<Value name="25">
<Value>CheckPass</Value>
</Value>
<Value name="26">
<Value>InsertHeadPat</Value>
</Value>
<Value name="27">
<Value>InsertHeadNur</Value>
</Value>
<Value name="28">
<Value>InsertHeadInput</Value>
</Value>
<Value name="29">
<Value>CheckScoreFlag</Value>
</Value>
<Value name="30">
<Value>CheckAccordScore</Value>
</Value>
<Value name="31">
<Value>CheckAccordScoreSum</Value>
</Value>
<Value name="32">
<Value>Picture</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgCheckResultD</DataLocation>
<DefaultData>MgCheckResultDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgCheckResultD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgCheckResultI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgCheckResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
