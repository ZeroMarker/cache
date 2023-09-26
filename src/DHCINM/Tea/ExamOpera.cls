/// Creater:lulin
/// Descriptions:技操考核主表
/// Date:2020-07-20
Class DHCINM.Tea.ExamOpera Extends %Persistent
{

Relationship ChildSub As DHCINM.Tea.ExamOperaSub [ Cardinality = children, Inverse = Parref ];

/// 用户id
Property UserDR As CF.DHCINM.DB.MgUser [ SqlColumnNumber = 2, SqlFieldName = UserDR ];

/// 检查任务
Property ReleaseDR As DHCINM.Tea.ExamRelease [ SqlColumnNumber = 3, SqlFieldName = CheckTask ];

/// 项目
Property CheckItem As CF.DHCINM.DB.TeaOpera [ SqlColumnNumber = 4, SqlFieldName = CheckItem ];

/// 病区
Property CheckWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = CheckWard ];

/// 得分
Property CheckScore As %String [ SqlColumnNumber = 6, SqlFieldName = CheckScore ];

/// 状态 【S:提交 N:未提交】
Property CheckStatus As %String [ SqlColumnNumber = 7, SqlFieldName = CheckStatus ];

/// 备注
Property CheckRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = CheckRemark ];

/// 类型-setcodeSub
Property OperaType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 9, SqlFieldName = OperaType ];

/// 考核主题
Property OperaDesc As %String [ SqlColumnNumber = 10, SqlFieldName = OperaDesc ];

/// 评分方式A:是否模式,B:符合模式,C:得分模式,D:扣分模式,E:选项模式,F:扣分原因模式
Property OperaMode As %String [ SqlColumnNumber = 11, SqlFieldName = OperaMode ];

/// 评价标准模式选项【"选项方式"使用，A:统一，O:自定义】
Property OperaStandType As %String [ SqlColumnNumber = 12, SqlFieldName = OperaStandType ];

/// 评价标准--描述」分值，多个 评分方式：A\B或者：E&&OperaStandType=A
Property OperaStand As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 13, SqlFieldName = OperaStand ];

/// 结果定义描述」符号」分数1」分数2【分数2可为空】
Property OperaResult As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 14, SqlFieldName = OperaResult ];

/// 总分
Property OperaScore As %String [ SqlColumnNumber = 15, SqlFieldName = OperaScore ];

/// 达标线
Property OperaPass As %String [ SqlColumnNumber = 16, SqlFieldName = OperaPass ];

/// 创建人
Property CreateUser As %String [ Required, SqlColumnNumber = 17, SqlFieldName = CreateUser ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 18, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 19, SqlFieldName = CreateTime ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 20, SqlFieldName = SubmitDate ];

/// 提交时间
Property SubmitTime As %Time [ SqlColumnNumber = 21, SqlFieldName = SubmitTime ];

/// 第几次解答【弃用】
Property AnswerTimes As %Integer [ SqlColumnNumber = 22, SqlFieldName = AnswerTimes ];

/// 检查
Property CheckDate As %Date [ SqlColumnNumber = 23, SqlFieldName = CheckDate ];

/// 监察人
Property CheckUser As %String [ Required, SqlColumnNumber = 24, SqlFieldName = CheckUser ];

Index release On ReleaseDR;

Index User On (ReleaseDR, CheckItem, UserDR);

Index CheckItem On (CheckItem, UserDR);

Index releaseUser On (ReleaseDR, UserDR);

Index DateWard On (CheckDate, CheckWard);

Index WardDate On (CheckWard, CheckDate);

Storage Default
{
<Data name="ExamOperaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserDR</Value>
</Value>
<Value name="3">
<Value>ReleaseDR</Value>
</Value>
<Value name="4">
<Value>CheckItem</Value>
</Value>
<Value name="5">
<Value>CheckWard</Value>
</Value>
<Value name="6">
<Value>CheckScore</Value>
</Value>
<Value name="7">
<Value>CheckStatus</Value>
</Value>
<Value name="8">
<Value>CheckRemark</Value>
</Value>
<Value name="9">
<Value>OperaType</Value>
</Value>
<Value name="10">
<Value>OperaDesc</Value>
</Value>
<Value name="11">
<Value>OperaMode</Value>
</Value>
<Value name="12">
<Value>OperaStandType</Value>
</Value>
<Value name="13">
<Value>OperaStand</Value>
</Value>
<Value name="14">
<Value>OperaResult</Value>
</Value>
<Value name="15">
<Value>OperaScore</Value>
</Value>
<Value name="16">
<Value>OperaPass</Value>
</Value>
<Value name="17">
<Value>CreateUser</Value>
</Value>
<Value name="18">
<Value>CreateDate</Value>
</Value>
<Value name="19">
<Value>CreateTime</Value>
</Value>
<Value name="20">
<Value>SubmitDate</Value>
</Value>
<Value name="21">
<Value>SubmitTime</Value>
</Value>
<Value name="22">
<Value>AnswerTimes</Value>
</Value>
<Value name="23">
<Value>CheckDate</Value>
</Value>
<Value name="24">
<Value>CheckUser</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.ExamOperaD</DataLocation>
<DefaultData>ExamOperaDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.ExamOperaD</IdLocation>
<IndexLocation>^DHCINM.Tea.ExamOperaI</IndexLocation>
<StreamLocation>^DHCINM.Tea.ExamOperaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
