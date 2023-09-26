/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语注册表
/// Table：User.MKBTermBase
Class User.MKBTermBase Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = MKBTB_RowId, SqlTableName = MKB_TermBase ]
{

/// 术语ID
Property MKBTBCode As %String(MAXLEN = "") [ Required, SqlFieldName = MKBTB_Code ];

/// 术语名
Property MKBTBDesc As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Desc ];

/// 术语类型
Property MKBTBType As %String(DISPLAYLIST = ",列表,树形", VALUELIST = ",L,T") [ SqlFieldName = MKBTB_Type ];

/// 术语库版本
Property MKBTBVersion As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Version ];

/// 术语库出处
Property MKBTBSource As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Source ];

/// 术语库拼音首字母检索码
Property MKBTBPYCode As %String(MAXLEN = "") [ SqlFieldName = MKBTB_PYCode ];

/// 术语库备注
Property MKBTBNote As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Note ];

/// 术语分类
Property MKBTBCatDr As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Cat_Dr ];

/// 术语标识
Property MKBTBFlag As %String(DISPLAYLIST = ",诊断,药品,检验,检查,手术,分类,部位,病因,通用描述,科室,ICD10国际码,ICD10北京码,诊断标记,ICD11,诊断修饰,知识分级,诊断类型,诊断状态,中医诊断", VALUELIST = ",Diagnose,Drug,Lab,Check,Operation,Cat,Part,Pathogeny,GenDesc,Loc,ICD10Inter,ICD10BJ,DiagMark,ICD11,DiagModifi,KnoClass,DiaType,DiaState,TCMDiag") [ SqlFieldName = MKBTB_Flag ];

/// 顺序
Property MKBTBSequence As %String(MAXLEN = "") [ SqlFieldName = MKBTB_Sequence ];

/// 编码规则
Property MKBTBCodeRules As %String(MAXLEN = "") [ Required, SqlFieldName = MKBTB_CodeRules ];

Index CodeIndex On MKBTBCode [ Unique ];

Index DescIndex On MKBTBDesc [ Unique ];

Index FlagIndex On MKBTBFlag [ Unique ];

Index SeqIndex On MKBTBSequence As Exact;

Index CodeRulesIndex On MKBTBCodeRules [ Unique ];

Storage Default
{
<Data name="MKBTermBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTBCode</Value>
</Value>
<Value name="3">
<Value>MKBTBDesc</Value>
</Value>
<Value name="4">
<Value>MKBTBType</Value>
</Value>
<Value name="5">
<Value>MKBTBVersion</Value>
</Value>
<Value name="6">
<Value>MKBTBSource</Value>
</Value>
<Value name="7">
<Value>MKBTBPYCode</Value>
</Value>
<Value name="8">
<Value>MKBTBNote</Value>
</Value>
<Value name="9">
<Value>MKBTBCatDr</Value>
</Value>
<Value name="10">
<Value>MKBTBFlag</Value>
</Value>
<Value name="11">
<Value>MKBTBSequence</Value>
</Value>
<Value name="12">
<Value>MKBTBCodeRules</Value>
</Value>
</Data>
<DataLocation>^User.MKBTermBaseD</DataLocation>
<DefaultData>MKBTermBaseDefaultData</DefaultData>
<IdLocation>^User.MKBTermBaseD</IdLocation>
<IndexLocation>^User.MKBTermBaseI</IndexLocation>
<StreamLocation>^User.MKBTermBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
