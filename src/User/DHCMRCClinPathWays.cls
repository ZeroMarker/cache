/// 临床路径
Class User.DHCMRCClinPathWays Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPW_RowId, SqlTableName = DHC_MRC_ClinPathWays ]
{

Relationship ChildEP As User.DHCMRCClinPathWaysEp [ Cardinality = children, Inverse = EPParRef ];

Relationship ChildRule As User.DHCMRCClinPathWaysRule [ Cardinality = children, Inverse = CPWRParRef ];

/// 激活标志
Property CPWActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPW_Active ];

/// 临床路径类型
Property CPWCPWTypeDR As DHCMRCClinPathType [ SqlColumnNumber = 7, SqlFieldName = CPW_CPWType_DR ];

/// 代码
Property CPWCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CPW_Code ];

/// 开始日期
Property CPWDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CPW_DateFrom ];

/// 截止日期
Property CPWDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CPW_DateTo ];

/// 描述
Property CPWDesc As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPW_Desc ];

/// 参考费用
Property CPWCost As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPW_Cost ];

/// 参考天数
Property CPWDays As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPW_Days ];

/// 准入ICD
Property CPWICD As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPW_ICD ];

/// 准入提示
Property CPWLabel As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CPW_Label ];

/// 变异原因分析
Property CPWVarDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CPW_VarDesc ];

/// 版本号
Property CPWVersion As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CPW_Version ];

/// 发布日期
Property CPWVerDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CPW_VerDate ];

/// 发布时间
Property CPWVerTime As %Time [ SqlColumnNumber = 15, SqlFieldName = CPW_VerTime ];

/// 发布人  Table:SSUser
Property CPWVerUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CPW_VerUser_DR ];

/// 临床路径字典
Property CPWCPWDicDR As DHCMRCClinPathWaysDic [ SqlColumnNumber = 17, SqlFieldName = CPW_CPWDic_DR ];

/// 是否分支型临床路径 //add by wuqk 2011-07-21
Property CPWOffShoot As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = CPW_OffShoot ];

/// 临床路径知识
Property CPWHelpFild As %String(MAXLEN = "", TRUNCATE = 1) [ InitialExpression = "nothing" ];

/// 关联的评估字典    add by wuqk 2011-09-16 list Of %String
/// 存储格式 $lb("subCateId:0","subCateId:1")  第二个字符为是否必填项目
Property CPWEvaluateList As %String(MAXLEN = "") [ SqlFieldName = CPW_EvaluateList ];

/// 准入诊断关键词
Property CPWKeys As %String(TRUNCATE = 1) [ SqlFieldName = CPW_Keys ];

/// 准入手术ICD
Property CPWOperICD As %String(TRUNCATE = 1) [ SqlFieldName = CPW_OperICD ];

/// 准入手术关键词
Property CPWOperKeys As %String(TRUNCATE = 1) [ SqlFieldName = CPW_OperKeys ];

/// 临床路径字典、有效标、发布时间索引
Index IndexPathWayDic On (CPWCPWDicDR As AlphaUp, CPWActive As AlphaUp, CPWVerDate As AlphaUp, CPWVerTime As AlphaUp);

/// 临床路径字典索引(用来生成版本号)
Index IndexClinPathWaysDicVer On (CPWCPWDicDR As AlphaUp, CPWVersion As AlphaUp);

/// 临床路径字典索引
Index IndexPathWayDicAA On (CPWCPWDicDR As AlphaUp, CPWActive As AlphaUp);

/// Creator：     zhufei
/// CreatDate：   2015-06-16
/// Description:  根据ID取路径
/// Table：       User.DHCMRCClinPathWays
/// Input：       Id : User.DHCMRCClinPathWays.ID
/// Return：      返回Object
/// w ##class(User.DHCMRCClinPathWays).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRCClinPathWays
{
	new (aId)
	quit:'##class(User.DHCMRCClinPathWays).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRCClinPathWays).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWCode</Value>
</Value>
<Value name="3">
<Value>CPWDesc</Value>
</Value>
<Value name="4">
<Value>CPWCPWTypeDR</Value>
</Value>
<Value name="5">
<Value>CPWActive</Value>
</Value>
<Value name="6">
<Value>CPWDateFrom</Value>
</Value>
<Value name="7">
<Value>CPWDateTo</Value>
</Value>
<Value name="8">
<Value>CPWCost</Value>
</Value>
<Value name="9">
<Value>CPWDays</Value>
</Value>
<Value name="10">
<Value>CPWICD</Value>
</Value>
<Value name="11">
<Value>CPWLabel</Value>
</Value>
<Value name="12">
<Value>CPWVarDesc</Value>
</Value>
<Value name="13">
<Value>CPWVersion</Value>
</Value>
<Value name="14">
<Value>CPWVerDate</Value>
</Value>
<Value name="15">
<Value>CPWVerTime</Value>
</Value>
<Value name="16">
<Value>CPWVerUserDR</Value>
</Value>
<Value name="17">
<Value>CPWCPWDicDR</Value>
</Value>
<Value name="18">
<Value>CPWOffShoot</Value>
</Value>
<Value name="19">
<Value>CPWHelpFild</Value>
</Value>
<Value name="20">
<Value>CPWEvaluateList</Value>
</Value>
<Value name="21">
<Value>CPWKeys</Value>
</Value>
<Value name="22">
<Value>CPWOperICD</Value>
</Value>
<Value name="23">
<Value>CPWOperKeys</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("CPW")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("CPW")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0)</IndexLocation>
<StreamLocation>^User.DHCMRCClinPathWaysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
