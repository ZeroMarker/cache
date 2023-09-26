/// 导入导出基础配置表
Class User.BDPEILink Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_EILink ]
{

/// 配置名
Property EILFileName As %String(MAXLEN = "") [ Required ];

/// 模板类型  例如BIData
Property EILType As %String(MAXLEN = "") [ Required ];

/// 文件类型
Property EILFileType As %String(DISPLAYLIST = ",Excel,Gof", VALUELIST = ",E,G") [ Required ];

/// 导入导出类型
Property EILEIType As %String(DISPLAYLIST = ",Import,Export", VALUELIST = ",I,E") [ Required ];

/// 开始sheet（数字）
Property EILStartSheet As %String;

/// 结束sheet
Property EILEndSheet As %String;

/// 起读行数
Property EILStartRow As %String;

/// 根据模板类型查询rowid
Index EILTypeI On EILType;

/// 根据文件名称查询rowid
Index EILFileNameI On EILFileName;

/// 根据模板类型，导入导出类型 和文件类型 查询rowid
Index TypeIndex On (EILType As Exact, EILEIType As Exact, EILFileType As Exact);

Storage Default
{
<Data name="BDPEILinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EILFileName</Value>
</Value>
<Value name="3">
<Value>EILType</Value>
</Value>
<Value name="4">
<Value>EILFileType</Value>
</Value>
<Value name="5">
<Value>EILEIType</Value>
</Value>
<Value name="6">
<Value>EILStartSheet</Value>
</Value>
<Value name="7">
<Value>EILEndSheet</Value>
</Value>
<Value name="8">
<Value>EILStartRow</Value>
</Value>
</Data>
<DataLocation>^User.BDPEILinkD</DataLocation>
<DefaultData>BDPEILinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPEILinkD</IdLocation>
<IndexLocation>^User.BDPEILinkI</IndexLocation>
<StreamLocation>^User.BDPEILinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
