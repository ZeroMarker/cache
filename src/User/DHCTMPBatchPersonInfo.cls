/// 批量办理卡时，需要临时存储数据的地方
Class User.DHCTMPBatchPersonInfo Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_TMPBatchPersonInfo ]
{

Property Address As %String(TRUNCATE = 1) [ SqlFieldName = Address ];

Property Birth As %String(TRUNCATE = 1) [ Required, SqlFieldName = Birth ];

Property CardNo As %String(TRUNCATE = 1) [ SqlFieldName = CardNo ];

/// =0 or ="" 没有注册
/// =1  表示注册
Property CreatCardFlag As %Integer;

Property CardTypeDefine As %String(TRUNCATE = 1) [ SqlFieldName = CardTypeDefine ];

Property CardTypeDefineDesc As %String(TRUNCATE = 1) [ SqlFieldName = CardTypeDefineDesc ];

Property CityDesc As %String(TRUNCATE = 1) [ SqlFieldName = CityDesc ];

Property CityDescLookUpRowID As %String(TRUNCATE = 1) [ SqlFieldName = CityDescLookUpRowID ];

Property EmployeeCompanyLookUpRowID As %String(TRUNCATE = 1) [ Required, SqlFieldName = EmployeeCompanyLookUpRowID ];

/// 导入用户
Property UserDR As %String(TRUNCATE = 1) [ Required ];

Property CountryDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = CountryDesc ];

Property Name As %String(TRUNCATE = 1) [ Required, SqlFieldName = Name ];

Property CountryDescLookUpRowID As %String(TRUNCATE = 1) [ Required, SqlFieldName = CountryDescLookUpRowID ];

Property CredNo As %String(TRUNCATE = 1) [ Required, SqlFieldName = CredNo ];

Property CredType As %String(TRUNCATE = 1) [ Required, SqlFieldName = CredType ];

Property PAPMINo As %String(TRUNCATE = 1) [ SqlFieldName = PAPMINo ];

Property CredTypeDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = CredTypeDesc ];

/// 集团单位名称
Property GroupUnitName As %String(TRUNCATE = 1) [ Required, SqlFieldName = GroupUnitName ];

Property InMedicare As %String(TRUNCATE = 1) [ SqlFieldName = InMedicare ];

Property PatType As %String(TRUNCATE = 1) [ Required, SqlFieldName = PatType ];

Property NationDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = NationDesc ];

Property ProvinceInfo As %String(TRUNCATE = 1) [ Required, SqlFieldName = ProvinceInfo ];

Property NationDescLookUpRowID As %String(TRUNCATE = 1) [ Required, SqlFieldName = NationDescLookUpRowID ];

Property OpMedicare As %String(TRUNCATE = 1) [ SqlFieldName = OpMedicare ];

/// 患者类型说明
Property PatTypeDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = PatTypeDesc ];

Property ProvinceInfoLookUpRowID As %String(TRUNCATE = 1) [ Required, SqlFieldName = ProvinceInfoLookUpRowID ];

Property Sex As %String(TRUNCATE = 1) [ Required, SqlFieldName = Sex ];

/// 性别描述
Property SexDesc As %String(TRUNCATE = 1) [ Required, SqlFieldName = SexDesc ];

Property Vocation As %String(TRUNCATE = 1) [ SqlFieldName = Vocation ];

/// 本次导入时， 唯一的卡类型和卡号
Index UniqueTypeNo On (CardTypeDefine, CardNo) [ Unique ];

Index UserDRIndex On UserDR;

Method CardTypeDefineDescSet(Arg As %String) As %Status
{
	;s myobj=##class(User.DHCTMPBatchPersonInfo).%New()
	;s myobj.CardTypeDefineDesc="就诊卡"
	s i%CardTypeDefineDesc=Arg
	;^DHCCARDTYPEDef({CTD_RowID})
	s myCTRowID=""
	s myRowID=0
	f  s myRowID=$o(^DHCCARDTYPEDef(myRowID))  q:(myRowID="")!(myCTRowID'="")  d
	.s myCTDesc=$ZCONVERT($p(^DHCCARDTYPEDef(myRowID),"^",2),"U")
	.q:(myCTDesc'=$ZCONVERT(Arg,"U"))
	.s myCTRowID=myRowID
	
	s i%CardTypeDefine=myCTRowID
	
	Quit $$$OK
}

/// LookUpRowID
Method CityDescSet(Arg As %String) As %Status
{
	;获取城市的RowID
	;$ZCONVERT("Hello","U")
	s i%CityDesc=Arg
	s myRowID=""
	i Arg'="" d
	.;^CT("CIT",0,"Desc",$$ALPHAUP({CTCIT_Desc}),{CTCIT_RowId})
	.s myRowID=$o(^CT("CIT",0,"Desc", $ZCONVERT(Arg,"U"),0))
	
	s i%CityDescLookUpRowID=myRowID
	
	Quit $$$OK
}

/// LookUpRowID
Method CountryDescSet(Arg As %String) As %Status
{
	;获取 国家的RowID
	;
	s i%CountryDesc=Arg
	s myRowID=""
	i Arg'="" d
	.;^CT("COU",0,"Desc",$$ALPHAUP({CTCOU_Desc}),{CTCOU_RowId})
	.s myRowID=$o(^CT("COU",0,"Desc",$ZCONVERT(Arg, "U"),0))
	
	s i%CountryDescLookUpRowID=myRowID
	
	
	Quit $$$OK
}

Method CredTypeDescSet(Arg As %String) As %Status
{
	;获取证件类型RowID
	;
	s i%CredTypeDesc=Arg
	s myRowID=""
	s myCTRowID=""
	;^DHCACCCredType({CRT_RowID})
	;^PAC("CARD",0,"Desc",$$ALPHAUP({CARD_Desc}),{CARD_RowId})
	;f  s myRowID=$o(^DHCACCCredType(myRowID))  q:(myRowID="")!(myRowID'="")  d
	;.;CredTypeDesc
	;.s myCTDesc=$ZCONVERT($p(^DHCACCCredType(myRowID),"^",2),"U")
	;.q:(myCTDesc'=$ZCONVERT(Arg,"U"))
	;.s myCTRowID=myRowID
	s myRowID=""
	i Arg'="" d
	.;^CT("COU",0,"Desc",$$ALPHAUP({CTCOU_Desc}),{CTCOU_RowId})
	.s myRowID=$o(^PAC("CARD",0,"Desc",$ZCONVERT(Arg, "U"),0))
	
	s i%CredType=myRowID
	
	Quit $$$OK
}

/// 根据操作员删除数据
ClassMethod DeleteByUserDR(UserDR As %String) As %String
{
	;s myrtn=##class(User.DHCTMPBatchPersonInfo).DeleteByUserDR()
	s myrtn=0
	&sql(delete from DHC_TMPBatchPersonInfo where UserDR=:UserDR)
	i SQLCODE=100{
		s myrtn=0
	}else{
		s myrtn=SQLCODE
	}
	q myrtn
}

/// /LookUpRowID
Method ProvinceInfoSet(Arg As %String) As %Status
{
	;获取省份RowID
	s i%ProvinceInfo=Arg
	s myRowID=""
	i Arg'="" d
	.;^CT("PROV",0,"Desc",$$ALPHAUP({PROV_Desc}),{PROV_RowId})
	.s myRowID=$o(^CT("PROV",0,"Desc",$ZCONVERT(Arg,"U") ,0))
	s i%ProvinceInfoLookUpRowID=myRowID
	
	Quit $$$OK
}

/// LookUpRowID
Method NationDescSet(Arg As %String) As %Status
{
	;获取民族RowID
	s i%NationDesc=Arg
	s myRowID=""
	i Arg'="" d
	.;^CT("NAT",0,"Desc",$$ALPHAUP({CTNAT_Desc}),{CTNAT_RowId})
	.s myRowID=$o(^CT("NAT",0,"Desc",$ZCONVERT(Arg,"U"),0))
	
	s i%NationDescLookUpRowID=myRowID
	Quit $$$OK
}

Method PatTypeDescSet(Arg As %String) As %Status
{
	s i%PatTypeDesc=Arg
	;^CT("SS",0,"Desc",$$ALPHAUP({SS_Desc}),{SS_RowId})
	s myRowID=""
	i Arg'="" d
	.;^CT("NAT",0,"Desc",$$ALPHAUP({CTNAT_Desc}),{CTNAT_RowId})
	.s myRowID=$o(^CT("SS",0,"Desc",$ZCONVERT(Arg,"U"),0))
	
	s i%PatType=myRowID
	Quit $$$OK
}

Method SexDescSet(Arg As %String) As %Status
{
	;^CT("SEX",0,"Desc",$$ALPHAUP({CTSEX_Desc}),{CTSEX_RowId})
	s i%SexDesc=Arg
	s myRowID=""
	i Arg'="" d
	.s myRowID=$o(^CT("SEX",0,"Desc",$ZCONVERT(Arg,"U"),0))
	s i%Sex=myRowID
	
	Quit $$$OK
}

Method GroupUnitNameSet(Arg As %String) As %Status
{
	s i%GroupUnitName=Arg
	s myRowID=""
	i Arg'="" d
	.s myRowID=$o(^CT("CTCO",0,"CTCO_Desc",$ZCONVERT(Arg,"U"),0))
	s i%EmployeeCompanyLookUpRowID=myRowID
	
	q $$$OK
}

Storage Default
{
<Data name="DHCTMPBatchPersonInfoCLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCTMPBatchPersonInfoDefaultData">
<Value name="1">
<Value>ImportUser</Value>
</Value>
<Value name="2">
<Value>CreatCardFlag</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>PAPMINo</Value>
</Value>
<Value name="5">
<Value>Sex</Value>
</Value>
<Value name="6">
<Value>Birth</Value>
</Value>
<Value name="7">
<Value>PatType</Value>
</Value>
<Value name="8">
<Value>CardNo</Value>
</Value>
<Value name="9">
<Value>CardTypeDefine</Value>
</Value>
<Value name="10">
<Value>CountryDesc</Value>
</Value>
<Value name="11">
<Value>ProvinceInfo</Value>
</Value>
<Value name="12">
<Value>CityDesc</Value>
</Value>
<Value name="13">
<Value>CredNo</Value>
</Value>
<Value name="14">
<Value>CredTypeDesc</Value>
</Value>
<Value name="15">
<Value>NationDesc</Value>
</Value>
<Value name="16">
<Value>Address</Value>
</Value>
<Value name="17">
<Value>Company</Value>
</Value>
<Value name="18">
<Value>InMedicare</Value>
</Value>
<Value name="19">
<Value>OpMedicare</Value>
</Value>
<Value name="20">
<Value>Vocation</Value>
</Value>
<Value name="21">
<Value>GroupUnitName</Value>
</Value>
<Value name="22">
<Value>UserDR</Value>
</Value>
<Value name="23">
<Value>SexDesc</Value>
</Value>
<Value name="24">
<Value>CityDescLookUpRowID</Value>
</Value>
<Value name="25">
<Value>CountryDescLookUpRowID</Value>
</Value>
<Value name="26">
<Value>CredType</Value>
</Value>
<Value name="27">
<Value>NationDescLookUpRowID</Value>
</Value>
<Value name="28">
<Value>ProvinceInfoLookUpRowID</Value>
</Value>
<Value name="29">
<Value>PatTypeDesc</Value>
</Value>
<Value name="30">
<Value>CardTypeDefineDesc</Value>
</Value>
<Value name="31">
<Value>EmployeeCompany</Value>
</Value>
<Value name="32">
<Value>EmployeeCompanyLookUpRowID</Value>
</Value>
</Data>
<DataLocation>^DHCTMPBatchPersonInfoD</DataLocation>
<DefaultData>DHCTMPBatchPersonInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCTMPBatchPersonInfoD</IdLocation>
<IndexLocation>^DHCTMPBatchPersonInfoI</IndexLocation>
<StreamLocation>^User.DHCTMPBatchPersonInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
