/// 财务上的子利益医院分类1
Class User.DHCSuAvailbHospital Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_SuAvailbHospital ]
{

Property SAHActiveFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SAH_ActiveFlag ];

Property SAHCode As %String(TRUNCATE = 1) [ Required, SqlFieldName = SAH_Code ];

Property SAHDefaultFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SAH_DefaultFlag ];

Property SAHDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = SAH_Desc ];

Property SAHHospitalDR As User.CTHospital [ SqlFieldName = SAH_Hospital_DR ];

Index SAHCodeIndex On SAHCode [ Unique ];

Index SAHDescIndex On SAHDesc;

Query GetAvailHospital() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,SAH_Desc FROM DHC_SuAvailbHospital
}

Storage Default
{
<Data name="DHCSuAvailbHospitalCLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCSuAvailbHospitalDefaultData">
<Value name="1">
<Value>SAHCode</Value>
</Value>
<Value name="2">
<Value>SAHDesc</Value>
</Value>
<Value name="3">
<Value>SAHHospitalDR</Value>
</Value>
<Value name="4">
<Value>SAHDefaultFlag</Value>
</Value>
<Value name="5">
<Value>SAHActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCSuAvailbHospitalD</DataLocation>
<DefaultData>DHCSuAvailbHospitalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCSuAvailbHospitalD</IdLocation>
<IndexLocation>^User.DHCSuAvailbHospitalI</IndexLocation>
<StreamLocation>^User.DHCSuAvailbHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
