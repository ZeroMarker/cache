/// 提供一个患者基本信息接口
Class web.DHCBL.CARDIF.ICardPaPatMasInfo Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 6;

/// 把 部分特殊数据保存到数据库中
/// 这个需要各个项目完成，
ClassMethod SavePatOtherInfo(PAPMIRowID As %String, PatObj As web.DHCEntity.PCA.PATMAS) As %String
{
	;w ##class(web.DHCBL.CARDIF.ICardPaPatMasInfo).SavePatOtherInfo()
	s myrtn=0
	;对于这里使用版本控制
	s myobj=##class(User.PAPatMas).%OpenId(PAPMIRowID)
    Do myobj.%Reload()								//禁用对象缓存，从磁盘重新加载数据，防止对象获取到错误的数据
	s myobj.PAPMIHealthFundNo=PatObj.PatYBCode    //医保号
	;s myobj.PAPMISecondPhone=PatObj.EmployeeCompany    
	s myobj.PAPMISecondPhone=PatObj.Company     //工作单位
	
	s sr=myobj.%Save()
	If ($System.Status.IsError(sr))
	{
		Do $System.Status.DisplayError(sr)
		//为-104则说明是papatmas表插入错误
		Set myrtn = "-104"
		quit myrtn
	}
	d myobj.%Close()
	s DHCPatObj=##class(User.DHCPAPatMas).%OpenId(PAPMIRowID)
	if (PatObj.BirthTime'=""){
	    s myBirthTime=..%ZTH(PatObj.BirthTime)
	    s DHCPatObj.PAPMIBirthTime=myBirthTime   
	}
	d DHCPatObj.PAPMIStreetBirthSetObjectId(PatObj.StreetBirth)
	d DHCPatObj.PAPMIStreetHouseSetObjectId(PatObj.StreetHouse)
	d DHCPatObj.PAPMIStreetNowSetObjectId(PatObj.StreetNow)
	s sc=DHCPatObj.%Save()
	if $$$ISERR(sc) {
		//为-1041则说明是DHC_PA_PatMas表插入错误
	    s myrtn="-1041"
	    quit myrtn
	}
	d DHCPatObj.%Close()
	//公医证号、费别
	s ^PAPER(PAPMIRowID ,"DHCINS")="^"_PatObj.InsurCardNo_"^"_PatObj.AdmReason
	/*
	//出生地
	s $P(^PAPER(PAPMIRowID,"DHC"),"^",2)=PatObj.BirthPlace
	//家庭邮编
	s $P(^PAPER(PAPMIRowID,"DHC"),"^",31)=PatObj.PostCode
	//籍贯
	s $P(^PAPER(PAPMIRowID,"DHC"),"^",32)=PatObj.HomePlace
	//户口地址
	s $P(^PAPER(PAPMIRowID,"DHC"),"^",33)=PatObj.RegisterPlace
	//家庭所在地区
	s $P(^PAPER(PAPMIRowID,"DHC"),"^",34)=PatObj.HouseArea
	*/
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PAPMIRowID,0))
	i DHCPersonID="" d
	.s DHCPersonObj=##class(User.DHCPerson).%New()
	.d DHCPersonObj.PAPERPaPersondrSetObjectId(PAPMIRowID)
	e  d
	.s DHCPersonObj=##class(User.DHCPerson).%OpenId(DHCPersonID)
	//出生地
	s DHCPersonObj.PAPERBirthAddress=PatObj.BirthPlace
	//工作单位邮编
	s DHCPersonObj.PAPERComment1=PatObj.CompanyPostCode
	//非代码表邮编
	s DHCPersonObj.PAPERComment2=PatObj.PostCode
	//邮编(户口)
	s DHCPersonObj.PAPERComment3=PatObj.PostCodeHouse
	//户口地址
	s DHCPersonObj.PAPERHouseAddress=PatObj.RegisterPlace
	//省(出生)
	s DHCPersonObj.PAPERBirthProvinceDR=PatObj.ProvinceBirth
	//市(出生)
	s DHCPersonObj.PAPERBirthCityDR=PatObj.CityBirth
	//县(出生)
	s DHCPersonObj.PAPERBirthAreadr=PatObj.AreaBirth
	//地址(出生)
	s DHCPersonObj.PAPERBirthAddress=PatObj.AddressBirth
	//省(户口)
	s DHCPersonObj.PAPERHouseProvinceDR=PatObj.ProvinceHouse
	//市(户口)
	s DHCPersonObj.PAPERHouseCityDR=PatObj.Cityhouse
	//县(户口)
	s DHCPersonObj.PAPERHouseAreaDR=PatObj.AreaHouse
	s sr=DHCPersonObj.%Save()
	
	If ($System.Status.IsError(sr))
	{
		Do $System.Status.DisplayError(sr)
		Set myrtn = "-1051"   //为1051则说明是User.DHCPerson表插入错误
		quit myrtn
	}
	//合同单位 此处open方式保存，会导致PAPMI_MobPhone 置为空,不清楚原因scl
	//s myperson=##class(User.PAPerson).%OpenId(PAPMIRowID)
	if (PatObj.HCPDR'=$C(1)) //(PatObj.HCPDR'="")&&
	{
		//d myperson.PAPERHCPDRSetObjectId(PatObj.HCPDR)
		s $p(^PAPER(PAPMIRowID,"PER",4),"^",17)=PatObj.HCPDR
	}
	//s sr=myperson.%Save()
	If ($System.Status.IsError(sr))
	{
		Do $System.Status.DisplayError(sr)
		Set myrtn = "-105"   //为104则说明是papatmas表插入错误
		quit myrtn
	}
	//d myperson.%Close()
	
	q myrtn
}

/// creater				lixiangzong
/// date					2012.07.14
/// desc					注册建卡界面缺少的用工号查询已经建卡的信息
/// input				EmployeeNo，工号
/// output				EmployeeNoFlag(0 工号不正确 papmirowid)_"^"_name(被谁占用(工号对应卡号姓名))_"^"_UserName(工号对应姓名)_"^"_CardNo(被占用卡号)
/// w ##class(web.DHCBL.CARDIF.ICardPaPatMasInfo).GetPAPMIRowIDByEmployeeNo("70289")
ClassMethod GetPAPMIRowIDByEmployeeNo(EmployeeNo) As %String
{
	
	s PAPERRowId=0,PAPERName="",UserName="",PAPERRowIdSet="",CardNo=""
	s UserRowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(EmployeeNo),0))
    Q:UserRowID="" PAPERRowId_"^"_PAPERName_"^"_UserName_"^"_CardNo
    s FromDate=$P(^SSU("SSUSR",UserRowID),"^",96)
    s FromTo=$P(^SSU("SSUSR",UserRowID),"^",97)
    if ((FromDate'="")&&(FromDate>$h))!((FromTo'="")&&(FromTo<$h)) {
		q PAPERRowId_"^"_PAPERName_"^"_UserName_"^"_CardNo
    }
	s UserName=$P(^SSU("SSUSR",UserRowID),"^",2)
	f  s PAPERRowId=$O(^PAPERi("EmplNo1",$$ALPHAUP^SSUTIL4(EmployeeNo)_"Z",PAPERRowId)) Q:PAPERRowId=""  d
	.s PAPERName=$P(^PAPER(PAPERRowId,"ALL"),"^",1)
	.s CradRefRowiD=0  f  s CradRefRowiD=$O(^DHCCARDi("CF",0,"PAPMIDR",PAPERRowId,CradRefRowiD)) Q:CradRefRowiD=""  d
	..s ActiveFlag=$P(^DHCCARD("CF",CradRefRowiD),"^",10)
	..Q:ActiveFlag'="N"
	..s CardNo=$P(^DHCCARD("CF",CradRefRowiD),"^",2)
	..s PAPERRowIdSet=PAPERRowId
	Q PAPERRowIdSet_"^"_PAPERName_"^"_UserName_"^"_CardNo
}

/// create 2020-10-12 by yuanlei
/// 根据工号获取用户的相关信息
/// input:EmployeeNo(工号)
/// output：姓名^性别^出生日期^身份证号^民族^婚姻状况^地址^联系电话^国籍^照片
ClassMethod GetUserInfoByEmployeeNo(EmployeeNo As %String) As %String
{
	s UserInfo=""
	s UserRowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(EmployeeNo),0))
    Q:UserRowID="" UserInfo
    
    s UserInfo=$g(^SSU("SSUSR",UserRowID))
    s UserInfoExt=$g(^SSU("SSUSR",UserRowID,"EXT"))
    
    s SexStr="",NationStr="",MaritalStr="",CountryStr=""
    s UserName=$p(UserInfo,"^",2)
    s CredNo=$p(UserInfo,"^",122)
    s SexDr=$p(UserInfo,"^",123)
    i SexDr'="" {
	    s Sex=$p($g(^CT("SEX",SexDr)),"^",2)
	    s:Sex'="" SexStr=SexDr_$c(1)_Sex
    }
    s Tel=$p(UserInfo,"^",99)
    s PatDob=$p(UserInfoExt,"^",1)
    s:PatDob'="" PatDob=..%ZD(PatDob)
    s CountryDr=$p(UserInfoExt,"^",2)
    i CountryDr'="" {
	    s Country=$p($g(^CT("COU",CountryDr)),"^",2)
	    s:Country'="" CountryStr=CountryDr_$c(1)_Country
    }
    s NationDr=$p(UserInfoExt,"^",3)
    i NationDr'="" {
	    s Nation=$p(^CT("NAT",NationDr),"^",2)
	    s:Nation'="" NationStr=NationDr_$c(1)_Nation
    }
    s MaritalDR=$p(UserInfoExt,"^",4)
    s:MaritalDR'="" Marital=$p(^CT("MAR",MaritalDR),"^",2)
    i MaritalDR'="" {
	    s Marital=$p(^CT("MAR",MaritalDR),"^",2)
	    s:Marital'="" MaritalStr=MaritalDR_$c(1)_Marital
    }
    s Address=$p(UserInfoExt,"^",6)
    s Img=$g(^SSU("SSUSR",UserRowID,"EXTIMG"))
    
    s UserInfo=UserName_"^"_SexStr_"^"_PatDob_"^"_CredNo_"^"_NationStr
    s UserInfo=UserInfo_"^"_MaritalStr_"^"_Address_"^"_Tel_"^"_CountryStr_"^"_Img
    
    q UserInfo
}

}
