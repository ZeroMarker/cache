/// 对于集团医院经济利益分割标准
/// 1.科室对照标准
/// 
Class User.DHCSubHospAvailSeg Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_SubHospAvailSeg ]
{

Property SASCTLocDR As CTLoc [ Required, SqlFieldName = SAS_CTLoc_DR ];

/// SASSubAvailHospDR1
Property SASSubAvailHospDR As DHCSuAvailbHospital [ Required, SqlFieldName = SAS_SubAvailHosp_DR ];

Index AvLocIdx On (SASCTLocDR, SASSubAvailHospDR) [ Unique ];

Storage Default
{
<Data name="DHCSubHospAvailSegDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SASCTLocDR</Value>
</Value>
<Value name="3">
<Value>SASSubAvailHospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCSubHospAvailSegD</DataLocation>
<DefaultData>DHCSubHospAvailSegDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCSubHospAvailSegD</IdLocation>
<IndexLocation>^User.DHCSubHospAvailSegI</IndexLocation>
<StreamLocation>^User.DHCSubHospAvailSegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
