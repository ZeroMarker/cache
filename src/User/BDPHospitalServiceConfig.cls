/// Functgion: 多院区业务配置 
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class User.BDPHospitalServiceConfig Extends %Persistent [ SqlTableName = BDP_HospitalServiceConfig ]
{

Relationship HospitalServiceParRef As User.BDPMultiHospitalService [ Cardinality = parent, Inverse = ChildServiceConfig ];

Relationship ChildConfigCategory As User.BDPHospSerConfigCategory [ Cardinality = children, Inverse = ServiceConfigParRef ];

/// 类型： 按登录DL、按开单KD、按就诊JZ、按接收JS
Property BDPSerConfigType As %String(DISPLAYLIST = ",DL,KD,JZ,JS", VALUELIST = ",DL,KD,JZ,JS") [ SqlColumnNumber = 2, SqlFieldName = BDPSerConfig_Type ];

/// 当前医院  
Property BDPSerConfigCurrenHospDR As CTHospital [ Required, SqlColumnNumber = 3, SqlFieldName = BDPSerConfig_CurrenHosp_DR ];

/// 可操作医院
Property BDPSerConfigOperateHospDR As CTHospital [ Required, SqlColumnNumber = 4, SqlFieldName = BDPSerConfig_OperateHosp_DR ];

/// 项目：科室LOC、医嘱ORD、医嘱子类ORDCAT
Property BDPSerConfigCategory As %String(DISPLAYLIST = ",Loc,Order,OrderCat", VALUELIST = ",LOC,ORD,ORDCAT") [ SqlColumnNumber = 5, SqlFieldName = BDPSerConfig_Category ];

Index CurrenHospDRIdx On (BDPSerConfigCurrenHospDR As Exact, HospitalServiceParRef);

Index ServiceConfigIdx On (BDPSerConfigCurrenHospDR As Exact, HospitalServiceParRef, BDPSerConfigType, BDPSerConfigOperateHospDR, BDPSerConfigCategory);

Storage Default
{
<Data name="BDPHospitalServiceConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPSerConfigType</Value>
</Value>
<Value name="3">
<Value>BDPSerConfigCurrenHospDR</Value>
</Value>
<Value name="4">
<Value>BDPSerConfigOperateHospDR</Value>
</Value>
<Value name="5">
<Value>BDPSerConfigCategory</Value>
</Value>
</Data>
<DataLocation>^User.BDPHospitalServiceConfigD</DataLocation>
<DefaultData>BDPHospitalServiceConfigDefaultData</DefaultData>
<IdLocation>^User.BDPHospitalServiceConfigD</IdLocation>
<IndexLocation>^User.BDPHospitalServiceConfigI</IndexLocation>
<StreamLocation>^User.BDPHospitalServiceConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
