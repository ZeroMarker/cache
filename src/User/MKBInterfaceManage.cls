/// Description： 知识库接口管理表
/// Creator：丁亚男
/// Date： 2018-03-26
Class User.MKBInterfaceManage Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBINM_RowId, SqlTableName = MKB_InterfaceManage ]
{

/// 代码
Property MKBINMCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBINM_Code ];

/// 描述
Property MKBINMDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBINM_Desc ];

/// 方法
Property MKBINMFunction As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBINM_Function ];

/// 返回值
Property MKBINMReturnValue As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBINM_ReturnValue ];

/// 上级分类
Property MKBINMLastLevel As User.MKBInterfaceManage [ SqlColumnNumber = 6, SqlFieldName = MKBINM_LastLevel ];

/// 级别
Property MKBINMLevel As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBINM_Level ];

/// 备注
Property MKBINMRemark As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = MKBINM_Remark ];

/// 是否激活
Property MKBINMActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MKBINM_Active ];

Index CodeIndex On MKBINMCode [ Unique ];

Index DescIndex On MKBINMDesc;

Index ParentIndex On MKBINMLastLevel As Exact;

Index ParLevelIndex On (MKBINMLastLevel As Exact, MKBINMLevel As Exact);

Storage Default
{
<Data name="MKBInterfaceManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBINMCode</Value>
</Value>
<Value name="3">
<Value>MKBINMDesc</Value>
</Value>
<Value name="4">
<Value>MKBINMFunction</Value>
</Value>
<Value name="5">
<Value>MKBINMReturnValue</Value>
</Value>
<Value name="6">
<Value>MKBINMLastLevel</Value>
</Value>
<Value name="7">
<Value>MKBINMLevel</Value>
</Value>
<Value name="8">
<Value>MKBINMRemark</Value>
</Value>
<Value name="9">
<Value>MKBINMActive</Value>
</Value>
</Data>
<DataLocation>^User.MKBInterfaceManageD</DataLocation>
<DefaultData>MKBInterfaceManageDefaultData</DefaultData>
<IdLocation>^User.MKBInterfaceManageD</IdLocation>
<IndexLocation>^User.MKBInterfaceManageI</IndexLocation>
<StreamLocation>^User.MKBInterfaceManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
