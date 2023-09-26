Class DHCCPM.DHCRepDataCont Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_RepDataCont ]
{

Property RDCDBDataType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RDC_DBDataType ];

Property RDCDBType As %String(DISPLAYLIST = ",Cache,SQLServer", TRUNCATE = 1, VALUELIST = ",C,SL") [ Required, SqlFieldName = RDC_DBType ];

Property RDCDNDataType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RDC_DNDataType ];

Property RDCPackageType As %String(TRUNCATE = 1) [ Required, SqlFieldName = RDC_PackageType ];

Property RDCSCType As %String(DISPLAYLIST = ",Simple,Complex", TRUNCATE = 1, VALUELIST = ",S,C") [ Required, SqlFieldName = RDC_SCType ];

Index RDCDBDataTypeIndex On (RDCDBType As Exact, RDCDBDataType As Exact, RDCDNDataType As Exact);

/// 使用数据库端的数据类型查询DotNet端数据类型
Query SelectByDBDataType(DBType As %String, DBDataType As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,RDC_DBDataType,RDC_DBType,RDC_DNDataType,RDC_PackageType,RDC_SCType, RDC_DBType FROM 

DHC_RepDataCont
 WHERE (RDC_DBType = :DBType AND RDC_DBDataType = :DBDataType)
 ORDER BY %ID
}

/// /按照数据库类型查找 %STARTSWITH
/// /s res=##class(%ResulSet).%New("DHCCPM.DHCRepDataCont:SelectByDBType")
/// /%ID, RDC_DBDataType,RDC_DNDataType,RDC_PackageType,RDC_SCType
Query SelectByDBType(DBType As %String, RDCPackageType As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,RDC_DBDataType,RDC_DNDataType,RDC_PackageType,RDC_SCType,RDC_DBType
FROM DHC_RepDataCont
 WHERE (RDC_DBType = :DBType)
 ORDER BY RDC_DBDataType,%ID
}

Storage Default
{
<Data name="DHCRepDataContClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCRepDataContDefaultData">
<Value name="1">
<Value>RDCDBDataType</Value>
</Value>
<Value name="2">
<Value>RDCDBType</Value>
</Value>
<Value name="3">
<Value>RDCDNDataType</Value>
</Value>
<Value name="4">
<Value>RDCPackageType</Value>
</Value>
<Value name="5">
<Value>RDCSCType</Value>
</Value>
</Data>
<DataLocation>^DHCCPM.DHCRepDataContD</DataLocation>
<DefaultData>DHCRepDataContDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPM.DHCRepDataContD</IdLocation>
<IndexLocation>^DHCCPM.DHCRepDataContI</IndexLocation>
<Property name="RDCDBDataType"/>
<Property name="RDCDBType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="RDCDNDataType"/>
<Property name="RDCPackageType"/>
<Property name="RDCSCType">
<Selectivity>50.0000%</Selectivity>
</Property>
<StreamLocation>^DHCCPM.DHCRepDataContS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
