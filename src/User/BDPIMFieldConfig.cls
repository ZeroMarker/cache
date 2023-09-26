/// 基础数据平台-导入配置表管理-子表字段维护
/// 陈莹
Class User.BDPIMFieldConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_IMFieldConfig ]
{

Relationship ParRef As User.BDPIMConfig [ Cardinality = parent, Inverse = ChildField ];

/// 字段中文描述
Property IMFCFieldDesc As %String(MAXLEN = "") [ Required ];

/// 表字段名称
Property IMFCFieldName As %String(MAXLEN = "") [ Required ];

/// 字段类型
Property IMFCFieldType As %String(MAXLEN = "");

/// 通过Code找ID 只有DR类型的使用
Property IMFCCodeToID As %String(MAXLEN = "");

/// 关联表 2016/9/28新加字段
Property IMFCConTable As %String(MAXLEN = "");

/// 继承标识 2016/9/28新加字段
Property IMFCInheritFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否唯一 2016/11/21新加字段
Property IMFCUnique As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否必填项 2016/11/21新加字段
Property IMFCRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 是否导入 2016/11/21新加字段
Property IMFCImport As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 顺序字段
Property IMFCOrder As %Float;

/// 导出--通过ID找代码或者描述 只有DR类型的使用  2021-02-19
Property EXFCIDToCode As %String(MAXLEN = "");

/// 导出--如何取字段（Global）
Property EXFCGetField As %String(MAXLEN = "");

/// 是否导出
Property IMFCExport As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N");

/// 导出-字段类型
Property EXFCFieldType As %String(MAXLEN = "");

Index FieldNameIndex On (IMFCFieldName As Exact, IMFCFieldType As Exact, ParRef);

Index FieldNameUniqueI On (IMFCFieldName, ParRef) [ Unique ];

Index DescNameIndex On (IMFCFieldDesc As Exact, IMFCFieldName As Exact, ParRef);

Index ParSeqIdx On (ParRef, IMFCOrder);

Storage Default
{
<Data name="BDPIMFieldConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IMFCFieldDesc</Value>
</Value>
<Value name="3">
<Value>IMFCFieldName</Value>
</Value>
<Value name="4">
<Value>IMFCFieldType</Value>
</Value>
<Value name="5">
<Value>IMFCCodeToID</Value>
</Value>
<Value name="6">
<Value>IMFCConTable</Value>
</Value>
<Value name="7">
<Value>IMFCInheritFlag</Value>
</Value>
<Value name="8">
<Value>IMFCUnique</Value>
</Value>
<Value name="9">
<Value>IMFCRequired</Value>
</Value>
<Value name="10">
<Value>IMFCImport</Value>
</Value>
<Value name="11">
<Value>IMFCOrder</Value>
</Value>
<Value name="12">
<Value>EXFCIDToCode</Value>
</Value>
<Value name="13">
<Value>EXFCGetField</Value>
</Value>
<Value name="14">
<Value>IMFCExport</Value>
</Value>
<Value name="15">
<Value>EXFCFieldType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>BDPIMFieldConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPIMConfigC("ChildField")</IdLocation>
<IndexLocation>^User.BDPIMFieldConfigI</IndexLocation>
<StreamLocation>^User.BDPIMFieldConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
