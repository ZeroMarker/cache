/// 测量单位
Class CT.AN.Uom Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Uom ]
{

/// 单位代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 单位名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 4 ];

/// 单位类型
Property UnitType As %String(DISPLAYLIST = ",普通单位,浓度单位,速度单位,剂量单位,时间单位", VALUELIST = ",N,C,S,D,T") [ Required, SqlColumnNumber = 5 ];

Property LocalDesc As %String [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// 单位类型索引
Index IUnitType On UnitType;

/// 单位代码唯一索引
Index ICode On Code [ Unique ];

/// 外部索引
Index IExt On ExternalID;

Storage Default
{
<Data name="UomDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ExternalID</Value>
</Value>
<Value name="4">
<Value>UnitType</Value>
</Value>
<Value name="5">
<Value>LocalDesc</Value>
</Value>
<Value name="6">
<Value>ActiveDate</Value>
</Value>
<Value name="7">
<Value>ExpireDate</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.UomD</DataLocation>
<DefaultData>UomDefaultData</DefaultData>
<IdLocation>^CT.AN.UomD</IdLocation>
<IndexLocation>^CT.AN.UomI</IndexLocation>
<StreamLocation>^CT.AN.UomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
