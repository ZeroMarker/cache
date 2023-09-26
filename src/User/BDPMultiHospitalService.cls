/// Functgion: 多院区业务 
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class User.BDPMultiHospitalService Extends %Persistent [ SqlTableName = BDP_MultiHospitalService ]
{

///  多院区业务配置  子表
Relationship ChildServiceConfig As User.BDPHospitalServiceConfig [ Cardinality = children, Inverse = HospitalServiceParRef ];

/// 代码
Property BDPMHOSPServiceCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = BDPMHOSPService_Code ];

/// 功能
Property BDPMHOSPServiceDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = BDPMHOSPService_Desc ];

/// 类型：受限  不受限   
Property BDPMHOSPServiceType As %String(DISPLAYLIST = ",Limited,UnLimited", VALUELIST = ",L,UL") [ Required, SqlColumnNumber = 4, SqlFieldName = BDPMHOSPService_Type ];

Index CodeIdx On BDPMHOSPServiceCode As Exact;

Index DescIdx On BDPMHOSPServiceDesc As Exact;

Storage Default
{
<Data name="BDPMultiHospitalServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPMHOSPServiceCode</Value>
</Value>
<Value name="3">
<Value>BDPMHOSPServiceDesc</Value>
</Value>
<Value name="4">
<Value>BDPMHOSPServiceType</Value>
</Value>
</Data>
<DataLocation>^User.BDPMultiHospitalServiceD</DataLocation>
<DefaultData>BDPMultiHospitalServiceDefaultData</DefaultData>
<IdLocation>^User.BDPMultiHospitalServiceD</IdLocation>
<IndexLocation>^User.BDPMultiHospitalServiceI</IndexLocation>
<StreamLocation>^User.BDPMultiHospitalServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
