/// 科室
Class DHCCL.Config.Location Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Location ]
{

/// 科室代码
Property Code As %String [ SqlColumnNumber = 2 ];

/// 科室名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 是否病区
Property WardFlag As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// 科室类型
Property LocType As %String(DISPLAYLIST = ",Ward,Execute,Drug Injection,Dispensing,Cashier,Other,Operating Theatre,Emergency,Day Surgery,Medical Records,OutPatient Consulting Room,Clinic,Admission Point", MAXLEN = 26, TRUNCATE = 1, VALUELIST = ",W,E,DI,D,C,O,OP,EM,DS,MR,OR,CL,ADM") [ SqlColumnNumber = 8 ];

/// 科室组
Property DeptGroup As %String [ SqlColumnNumber = 9 ];

/// 医院
Property Hospital As DHCCL.Hospital [ SqlColumnNumber = 10 ];

/// 外部系统科室ID
Property ExternalID As %String [ SqlColumnNumber = 11 ];

Index Code On Code [ Unique ];

Index Group On DeptGroup;

Index Type On LocType As Exact;

Index Hosp On Hospital;

Index Ext On ExternalID;

Storage Default
{
<Data name="LocationDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>WardFlag</Value>
</Value>
<Value name="7">
<Value>LocType</Value>
</Value>
<Value name="8">
<Value>DeptGroup</Value>
</Value>
<Value name="9">
<Value>Hospital</Value>
</Value>
<Value name="10">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.LocationD</DataLocation>
<DefaultData>LocationDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.LocationD</IdLocation>
<IndexLocation>^DHCCL.Config.LocationI</IndexLocation>
<StreamLocation>^DHCCL.Config.LocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
