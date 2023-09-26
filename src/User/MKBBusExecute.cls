/// Description： 业务执行表
/// Creator：丁亚男
/// Date： 2018-03-26
Class User.MKBBusExecute Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBBE_RowId, SqlTableName = MKB_BusExecute ]
{

/// 代码
Property MKBBECode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBBE_Code ];

/// 业务执行动作
Property MKBBEBusExe As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBBE_BusExe ];

/// 业务场景
Property MKBBEBusScene As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBBE_BusScene ];

/// 上级分类
Property MKBBELastLevel As User.MKBBusExecute [ SqlColumnNumber = 5, SqlFieldName = MKBBE_LastLevel ];

/// 级别
Property MKBBELevel As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBBE_Level ];

/// 是否激活
Property MKBBEActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MKBBE_Active ];

/// 业务接口
Property MKBBEInterfDr As User.MKBInterfaceManage [ SqlColumnNumber = 8, SqlFieldName = MKBBE_Interf_Dr ];

Index CodeIndex On MKBBECode [ Unique ];

Index DescIndex On MKBBEBusExe [ Unique ];

Index ParentIndex On MKBBELastLevel As Exact;

Index ParLevelIndex On (MKBBELastLevel As Exact, MKBBELevel As Exact);

Storage Default
{
<Data name="MKBBusExecuteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBBECode</Value>
</Value>
<Value name="3">
<Value>MKBBEBusExe</Value>
</Value>
<Value name="4">
<Value>MKBBEBusScene</Value>
</Value>
<Value name="5">
<Value>MKBBELastLevel</Value>
</Value>
<Value name="6">
<Value>MKBBELevel</Value>
</Value>
<Value name="7">
<Value>MKBBEActive</Value>
</Value>
<Value name="8">
<Value>MKBBEInterfDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBBusExecuteD</DataLocation>
<DefaultData>MKBBusExecuteDefaultData</DefaultData>
<IdLocation>^User.MKBBusExecuteD</IdLocation>
<IndexLocation>^User.MKBBusExecuteI</IndexLocation>
<StreamLocation>^User.MKBBusExecuteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
