/// 基础配置字典
Class User.DHCMRCBaseConfig Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BC_RowId, SqlTableName = DHC_MRC_BaseConfig ]
{

/// Code
Property BCCode As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BC_Code ];

/// Desc
Property BCDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BC_Desc ];

/// Value
Property BCValue As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = BC_Value ];

/// Resume
Property BCResume As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = BC_Resume ];

/// 代码 索引
Index IndexCode On BCCode As SqlString;

/// Creator：     zhufei
/// CreatDate：   2015-06-29
/// Description:  根据ID取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.ID
/// Return：      返回object
/// w ##class(User.DHCMRCBaseConfig).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseConfig
{
	New (argId)
	Set return=##Class(User.DHCMRCBaseConfig).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-16-29
/// Description:  根据Code取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.Code
/// Return：      返回object
/// w ##class(User.DHCMRCBaseConfig).GetValueByCode("IsLinkLabARCOS")
ClassMethod GetValueByCode(argCode As %String) As User.DHCMRCBaseConfig
{
	New (argCode)
	Set return=""
	Quit:argCode="" return
	Set RowID=$o(^DHCMRCi("BC",0,"IndexCode"," "_argCode,0))
	Quit:RowID="" return
	Set objConfig=..GetObjById(RowID)
	If $IsObject(objConfig){
		Set return=objConfig.BCValue
	}
	Quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BCCode</Value>
</Value>
<Value name="3">
<Value>BCDesc</Value>
</Value>
<Value name="4">
<Value>BCValue</Value>
</Value>
<Value name="5">
<Value>BCResume</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BC")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BC")</IdLocation>
<IndexLocation>^DHCMRCi("BC",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
