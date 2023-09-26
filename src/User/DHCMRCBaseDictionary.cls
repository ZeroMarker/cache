/// 基础字典
Class User.DHCMRCBaseDictionary Extends (%Persistent, web.DHCCPW.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = BD_RowId, SqlTableName = DHC_MRC_BaseDictionary ]
{

/// 代码
Property BDCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BD_Code ];

/// 描述
Property BDDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BD_Desc ];

/// 基础字典类型
Property BDTypeDR As DHCMRCBaseDicSubCategory [ SqlColumnNumber = 4, SqlFieldName = BD_TypeDR ];

/// 临床路径字典
Property BDCPWDDR As DHCMRCClinPathWaysDic [ SqlColumnNumber = 5, SqlFieldName = BD_CPWDDR ];

/// 激活标志
Property BDActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BD_Active ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDCode</Value>
</Value>
<Value name="3">
<Value>BDDesc</Value>
</Value>
<Value name="4">
<Value>BDTypeDR</Value>
</Value>
<Value name="5">
<Value>BDCPWDDR</Value>
</Value>
<Value name="6">
<Value>BDActive</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BD")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BD")</IdLocation>
<IndexLocation>^DHCMRCi("BD",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
