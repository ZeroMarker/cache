/// 基础数据平台配置-图标管理
/// 基础数据平台-陈莹
Class User.BDPIconManage Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_IconManage ]
{

/// 代码
Property BDPICONCode As %String(MAXLEN = 220) [ Required, SqlColumnNumber = 2, SqlFieldName = BDPICON_Code ];

/// 描述
Property BDPICONDesc As %String(MAXLEN = 220) [ Required, SqlColumnNumber = 3, SqlFieldName = BDPICON_Desc ];

Index Code On BDPICONCode As Exact;

Index Desc On BDPICONDesc As Exact;

Storage Default
{
<Data name="BDPIconManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPICONCode</Value>
</Value>
<Value name="3">
<Value>BDPICONDesc</Value>
</Value>
</Data>
<DataLocation>^User.BDPIconManageD</DataLocation>
<DefaultData>BDPIconManageDefaultData</DefaultData>
<IdLocation>^User.BDPIconManageD</IdLocation>
<IndexLocation>^User.BDPIconManageI</IndexLocation>
<StreamLocation>^User.BDPIconManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
