/// 医嘱CA认证 数据资源类型定义
Class User.DHCSignResType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SRT_Rowid, SqlTableName = DHC_SignResType ]
{

/// 代码
Property SRTCode As %String [ SqlColumnNumber = 2, SqlFieldName = SRT_Code ];

/// 描述
Property SRTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SRT_Desc ];

/// 是否有效
Property SRTActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SRT_Active ];

Storage Default
{
<Data name="DHCSignResTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SRTActive</Value>
</Value>
<Value name="3">
<Value>SRTCode</Value>
</Value>
<Value name="4">
<Value>SRTDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCSignResTypeD</DataLocation>
<DefaultData>DHCSignResTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCSignResTypeD</IdLocation>
<IndexLocation>^User.DHCSignResTypeI</IndexLocation>
<StreamLocation>^User.DHCSignResTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
