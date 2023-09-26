/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：结构化诊断日志表
/// Table：User.SDSDiagnosDelLog
Class User.SDSDiagnosDelLog Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_DiagnosDelLog ]
{

/// 指向术语(诊断)
Property SDSTermDR As MKBTerm [ SqlColumnNumber = 2, SqlFieldName = SDS_Term_DR ];

/// 指向患者表 
Property SDSPMIDR As SDSPatMas [ Required, SqlColumnNumber = 3, SqlFieldName = SDS_PMI_DR ];

/// 诊断补充信息
Property SDSSupplement As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = SDS_Supplement ];

/// 关联ICD代码
Property SDSIcdCode As %String [ SqlColumnNumber = 5, SqlFieldName = SDS_IcdCode ];

/// 关联ICD描述
Property SDSIcdDesc As %String [ SqlColumnNumber = 6, SqlFieldName = SDS_IcdDesc ];

/// 指向术语(诊断词表)
Property SDSWordDR As %String [ SqlColumnNumber = 7, SqlFieldName = SDS_Word_DR ];

/// 开立日期 , Required
Property SDSOpenDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = SDS_OpenDate ];

/// 顺序
Property SDSSequence As %String [ SqlColumnNumber = 9, SqlFieldName = SDS_Sequence ];

/// 结构化诊断id
Property SDSDiagnosId As %String [ SqlColumnNumber = 10, SqlFieldName = SDS_DiagnosId ];

/// 结构化诊断属性值串
Property SDSValue As %String [ SqlColumnNumber = 11, SqlFieldName = SDS_Value ];

/// 结构化诊断表达式展示名
Property SDSDisplayName As %String [ SqlColumnNumber = 12, SqlFieldName = SDS_DisplayName ];

/// 主诊断
Property SDSMainDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SDS_MainDiagFlag ];

/// 录入人
Property SDSInsertUserDR As SSUser [ Required, SqlColumnNumber = 14, SqlFieldName = SDS_InsertUser_DR ];

/// 录入日期
Property SDSInsertDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 15, SqlFieldName = SDS_InsertDate ];

/// 录入时间
Property SDSInsertTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 16, SqlFieldName = SDS_InsertTime ];

/// 更新人
Property SDSUpdateUserDR As SSUser [ Required, SqlColumnNumber = 17, SqlFieldName = SDS_UpdateUser_DR ];

/// 更新日期
Property SDSUpdateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 18, SqlFieldName = SDS_UpdateDate ];

/// 更新时间
Property SDSUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 19, SqlFieldName = SDS_UpdateTime ];

Index PMIIndex On SDSPMIDR;

Storage Default
{
<Data name="SDSDiagnosDelLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSTermDR</Value>
</Value>
<Value name="3">
<Value>SDSPMIDR</Value>
</Value>
<Value name="4">
<Value>SDSSupplement</Value>
</Value>
<Value name="5">
<Value>SDSIcdCode</Value>
</Value>
<Value name="6">
<Value>SDSIcdDesc</Value>
</Value>
<Value name="7">
<Value>SDSWordDR</Value>
</Value>
<Value name="8">
<Value>SDSOpenDate</Value>
</Value>
<Value name="9">
<Value>SDSSequence</Value>
</Value>
<Value name="10">
<Value>SDSDiagnosId</Value>
</Value>
<Value name="11">
<Value>SDSValue</Value>
</Value>
<Value name="12">
<Value>SDSDisplayName</Value>
</Value>
<Value name="13">
<Value>SDSMainDiagFlag</Value>
</Value>
<Value name="14">
<Value>SDSInsertUserDR</Value>
</Value>
<Value name="15">
<Value>SDSInsertDate</Value>
</Value>
<Value name="16">
<Value>SDSInsertTime</Value>
</Value>
<Value name="17">
<Value>SDSUpdateUserDR</Value>
</Value>
<Value name="18">
<Value>SDSUpdateDate</Value>
</Value>
<Value name="19">
<Value>SDSUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.SDSDiagnosDelLogD</DataLocation>
<DefaultData>SDSDiagnosDelLogDefaultData</DefaultData>
<IdLocation>^User.SDSDiagnosDelLogD</IdLocation>
<IndexLocation>^User.SDSDiagnosDelLogI</IndexLocation>
<StreamLocation>^User.SDSDiagnosDelLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
