/// 基础字典项目子类
Class User.DHCMRCBaseDicSubCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = BDSC_RowId, SqlTableName = DHC_MRC_BaseDicSubCategory ]
{

Property BDSCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BDSC_Code ];

Property BDSCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = BDSC_Desc ];

Relationship BDSCParRef As User.DHCMRCBaseDicCategory [ Cardinality = parent, Inverse = ChildSubCat, SqlFieldName = BDSC_ParRef ];

/// 数据类型
Property BDSCType As %String(COLLATION = "AlphaUp", DISPLAYLIST = ",Dictionary,Bool,Text,Date,Int,Number", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",DIC,B,T,D,I,N") [ SqlColumnNumber = 5, SqlFieldName = BDSC_CType ];

/// 是否允许多选
Property BDSCMultiSelect As %Boolean [ SqlColumnNumber = 6, SqlFieldName = BDSC_MultiSelect ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDSCCode</Value>
</Value>
<Value name="3">
<Value>BDSCDesc</Value>
</Value>
<Value name="4">
<Value>BDSCMultiSelect</Value>
</Value>
<Value name="5">
<Value>BDSCType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SUB")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SUB")</IdLocation>
<IndexLocation>{%%PARENT}("SUB")(0)</IndexLocation>
<SqlChildSub>BDSC_Childsub</SqlChildSub>
<SqlRowIdName>BDSC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCBaseDicSubCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
