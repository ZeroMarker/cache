/// 问卷评估内容维护
Class User.DHCHMCEvaluationDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CEvaluationDetail ]
{

Parameter ClassName = "User.DHCHMCEvaluationDetail";

/// 代码
Property EDCode As %String [ Required, SqlFieldName = ED_Code ];

/// 描述
Property EDDesc As %String [ Required, SqlFieldName = ED_Desc ];

/// 结果类型（评估项目I、评估因子F、评估结果R）
/// 原有类型作废(DISPLAYLIST = "说明型,数值型,下拉列表,日期型", VALUELIST = "T,N,C,D")
Property EDType As %String [ SqlFieldName = ED_Type ];

/// 【作废】数据来源
Property EDDataSource As %String [ SqlFieldName = ED_DataSource ];

/// 性别限定
Property EDSex As %String [ SqlFieldName = ED_Sex ];

/// 【作废】单位
Property EDUnit As %String [ SqlFieldName = ED_Unit ];

/// 激活 Y/N
Property EDActive As %String [ SqlFieldName = ED_Active ];

/// 备注说明/表达式说明
Property EDNote As %String [ SqlFieldName = ED_Note ];

/// 外部关联码
Property EDRelateCode As %String [ SqlFieldName = ED_RelateCode ];

/// 类名
/// 当计算规则复杂，难以用表达式维护时，可以指定一个后台类方法，通过类方法计算得出结果
Property EDClassName As %String [ SqlFieldName = ED_ClassName ];

/// 方法名
Property EDMethodName As %String [ SqlFieldName = ED_MethodName ];

/// 问卷量表(主题)定义表
Property EDCQDSubjectDR As User.DHCHMCQDSubject [ SqlFieldName = ED_CQDSubjectDR ];

/// 计算表达式  说明：
/// 1.评估项目I：根据问卷内容计算“评估项目I”得分（根据问卷内容选项或值，计算评估项目得分）
/// 2.评估因子F：根据“评估项目I”计算“评估因子F”得分（参考匹兹堡睡眠质量评分因子7计算方式，一个评估因子关联多个问卷内容，如：问题8-9总得分=0:因子7计分0分；2>=问题8-9总得分>=1:因子7计分1分；4>=问题8-9总得分>=3:因子7计分2分；6>=问题8-9总得分>=5:因子7计分3分；）
/// 3.评估结果R：根据“评估项目I”和“评估因子F”计算“评估结果R”得分（与评估因子计算逻辑相同，如：中医体质评估-平和体质：得分>=27时为平和体质；21>得分>19倾向于平和体质；）
Property EDExpression As %String(MAXLEN = 200) [ SqlFieldName = ED_Expression ];

/// 顺序号
/// 非空字段，只有结果类型为“评估结果R”时，才需要顺序号，其他类型可以默认为0
Property EDSort As %Integer [ SqlFieldName = ED_Sort ];

/// 更新日期
Property EDUpdateDate As %Date [ SqlFieldName = ED_UpdateDate ];

/// 更新时间
Property EDUpdateTime As %Time [ SqlFieldName = ED_UpdateTime ];

/// 更新人 指向SS_User
Property EDUpdateUserDR As %String [ SqlFieldName = ED_UpdateUserDR ];

Index EDCodeIndex On EDCode;

Index RelateCodeIndex On EDRelateCode;

Index EDDescIndex On EDDesc;

Index IdxOfQuesCode On (EDCQDSubjectDR, EDCode) [ Unique ];

Storage Default
{
<Data name="DHCHMCEvaluationDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDActive</Value>
</Value>
<Value name="3">
<Value>EDCode</Value>
</Value>
<Value name="4">
<Value>EDDataSource</Value>
</Value>
<Value name="5">
<Value>EDDesc</Value>
</Value>
<Value name="6">
<Value>EDNote</Value>
</Value>
<Value name="7">
<Value>EDSex</Value>
</Value>
<Value name="8">
<Value>EDType</Value>
</Value>
<Value name="9">
<Value>EDUnit</Value>
</Value>
<Value name="10">
<Value>EDRelateCode</Value>
</Value>
<Value name="11">
<Value>EDClassName</Value>
</Value>
<Value name="12">
<Value>EDMethodName</Value>
</Value>
<Value name="13">
<Value>EDCQDSubjectDR</Value>
</Value>
<Value name="14">
<Value>EDExpression</Value>
</Value>
<Value name="15">
<Value>EDSort</Value>
</Value>
<Value name="16">
<Value>EDUpdateDate</Value>
</Value>
<Value name="17">
<Value>EDUpdateTime</Value>
</Value>
<Value name="18">
<Value>EDUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCEvaluationDetailD</DataLocation>
<DefaultData>DHCHMCEvaluationDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCEvaluationDetailD</IdLocation>
<IndexLocation>^User.DHCHMCEvaluationDetailI</IndexLocation>
<StreamLocation>^User.DHCHMCEvaluationDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
