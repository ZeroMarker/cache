/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断表
/// Table：User.SDSDiagnos
Class User.SDSDiagnos Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_Diagnos ]
{

Relationship ChildProperty As User.SDSDiagnosProperty [ Cardinality = children, Inverse = ParRefDiagnos ];

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

/// 指向数据处理工厂或全局化诊断词表(各版本ICD对照)
Property SDSWordDR As %String [ SqlColumnNumber = 7, SqlFieldName = SDS_Word_DR ];

/// 开立日期 , Required
Property SDSOpenDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = SDS_OpenDate ];

/// 顺序
Property SDSSequence As %String [ SqlColumnNumber = 9, SqlFieldName = SDS_Sequence ];

/// 主诊断
Property SDSMainDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SDS_MainDiagFlag ];

/// 诊断标记 指向MKBTerm
Property SDSTagDR As %String(MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = SDS_Tag_DR ];

/// 级别
Property SDSLevel As %String [ SqlColumnNumber = 12, SqlFieldName = SDS_Level ];

/// 发病日期
Property SDSOnsetDate As %Date [ SqlColumnNumber = 13, SqlFieldName = SDS_OnsetDate ];

/// 诊断类型
Property SDSTypeDR As MKBTerm [ SqlColumnNumber = 14, SqlFieldName = SDS_Type_DR ];

/// 诊断状态
Property SDSStatusDR As MKBTerm [ SqlColumnNumber = 15, SqlFieldName = SDS_Status_DR ];

/// 分类
/// 标准ICD诊断根据ICD诊断代码表中的中医证型、中医诊断标识判断
/// 非标ICD诊断类型1：西医，2：中医，3：证型, 同User.MRDiagnos字段MRDIAQuestionnaire
Property SDSCat As %String [ SqlColumnNumber = 16, SqlFieldName = SDS_Cat ];

Index PMIIndex On SDSPMIDR;

Index PMITermIndex On (SDSPMIDR, SDSTermDR);

Index PMIWordIndex On (SDSPMIDR, SDSWordDR As Exact);

Index PMISeqIndex On (SDSPMIDR, SDSSequence As Exact);

Index PMIMainIndex On (SDSPMIDR, SDSMainDiagFlag As Exact);

Storage Default
{
<Data name="SDSDiagnosDefaultData">
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
<Value>SDSMainDiagFlag</Value>
</Value>
<Value name="11">
<Value>SDSTagDR</Value>
</Value>
<Value name="12">
<Value>SDSLevel</Value>
</Value>
<Value name="13">
<Value>SDSOnsetDate</Value>
</Value>
<Value name="14">
<Value>SDSTypeDR</Value>
</Value>
<Value name="15">
<Value>SDSStatusDR</Value>
</Value>
<Value name="16">
<Value>SDSCat</Value>
</Value>
</Data>
<DataLocation>^User.SDSDiagnosD</DataLocation>
<DefaultData>SDSDiagnosDefaultData</DefaultData>
<IdLocation>^User.SDSDiagnosD</IdLocation>
<IndexLocation>^User.SDSDiagnosI</IndexLocation>
<StreamLocation>^User.SDSDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
