/// 名称:     护理病历基础字段表
/// 描述:     用于多语言翻译
/// 编写者：  yaojining
/// 编写日期: 2023.1.30
/// 产品组：  护理
Class CT.NUR.EMR.BaseField Extends (%Persistent, User.Abstract) [ SqlTableName = BaseField ]
{

/// 字段代码
Property BFCode As %String [ SqlColumnNumber = 2, SqlFieldName = BF_Code ];

/// 字段名称
Property BFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BF_Desc ];

/// 字段对应页面
Property BFPage As %String [ SqlColumnNumber = 4, SqlFieldName = BF_Page ];

/// 状态
Property BFStatusDR As CT.NUR.EMR.StatusDict [ SqlColumnNumber = 5, SqlFieldName = BF_Status_DR ];

Index StatusCode On (BFStatusDR, BFCode);

Storage Default
{
<Data name="BaseFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BFCode</Value>
</Value>
<Value name="3">
<Value>BFDesc</Value>
</Value>
<Value name="4">
<Value>BFPage</Value>
</Value>
<Value name="5">
<Value>BFStatusDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.BaseFieldD</DataLocation>
<DefaultData>BaseFieldDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.BaseFieldD</IdLocation>
<IndexLocation>^CT.NUR.EMR.BaseFieldI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.BaseFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
