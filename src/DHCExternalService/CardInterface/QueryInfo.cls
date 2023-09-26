Class DHCExternalService.CardInterface.QueryInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询签约状态
ClassMethod QueryInfo(InputXml As %String = "", Type As %String = "") As DHCExternalService.CardInterface.Entity.ReturnInfo
{
	n (InputXml,Type)
	s $ZT="QueryInfoErr"
	s InputObj=##class(DHCExternalService.CardInterface.Entity.RequestInfo).%New()
	d InputObj.XMLNodeDeserialize(.InputObj, "Request", InputXml)
	s RtnObj=##class(DHCExternalService.CardInterface.Entity.ReturnInfo).%New()
	s CardType=..GetCardType(InputObj.CardType)
	s Status=##class(DHCExternalService.CardInterface.CardManager).CardHadCreate(CardType,InputObj.CardNo)
	i Status=""{
		s:Type="1" RtnObj.SignedStatus="0"
		q RtnObj
	}elseif(Status'="N"){
		s:Type="1" RtnObj.SignedStatus="0"
		q RtnObj
	}
	s CardID=##class(DHCExternalService.CardInterface.CardManager).GetCardIDByCardNo(CardType,InputObj.CardNo)
	i Type="1"{
		s RtnObj=..QuerySignInfo(CardID)
	}elseif Type="2"{
		s RtnObj=..QueryPatInfo(CardID)
	}
	//卡号类型
	s RtnObj.CardNo=InputObj.CardNo
	s RtnObj.CardType=InputObj.CardType
	s RtnObj.CardSecurityNo=InputObj.CardSecurityNo
	d InputObj.%Close()
	q RtnObj
QueryInfoErr
	d InputObj.%Close()
	s RtnObj.SignedStatus="0"
	q RtnObj
}

/// 根据卡ID得到签约状态
ClassMethod QuerySignInfo(CardID As %String) As DHCExternalService.CardInterface.Entity.ReturnInfo
{
	s RtnObj=##class(DHCExternalService.CardInterface.Entity.ReturnInfo).%New()
	s RtnObj=..QueryPatInfo(CardID)
	s SignStatus=$P(^DHCCARD("CF",CardID),"^",19)
	s:SignStatus="1" RtnObj.SignedStatus="1"  //签约并绑定
	s:SignStatus="0" RtnObj.SignedStatus="3"  //绑定
	s:SignStatus="" RtnObj.SignedStatus="3"
	q RtnObj
}

/// 根据卡ID得到病人信息
ClassMethod QueryPatInfo(CardID As %String) As DHCExternalService.CardInterface.Entity.ReturnInfo
{
	s RegNo=$P(^DHCCARD("CF",CardID),"^",6)
	s Info=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatInfoByPANo(RegNo,"")
	s RtnObj=##class(DHCExternalService.CardInterface.Entity.ReturnInfo).%New()
	i +Info'=0 q RtnObj
	s Info=$P(Info,"^",2)
	s Obj=##class(web.DHCEntity.PCA.CardPatInfoReg).%New()
	d Obj.XMLNodeDeserialize(.Obj, "CardPatInfoReg", Info)
	s RtnObj.IDCardNo=Obj.CredNo
	s RtnObj.CredTypeCode=Obj.CredType  ;需要转换
	s RtnObj.CredTypeCode=..GetCredType(RtnObj.CredTypeCode)
	s RtnObj.MobileNo=Obj.MobPhone  ;obj.TelHome
	s:RtnObj.MobileNo="" RtnObj.MobileNo=Obj.TelHome
	s RtnObj.Sex=Obj.Sex ;需要转换
	s RtnObj.Sex=..GetSex(RtnObj.Sex)
	s RtnObj.PatientName=Obj.Name
	s RtnObj.Dob=Obj.Birth ;需要转换
	s:RtnObj.Dob'="" RtnObj.Dob=$ZD(RtnObj.Dob,8)
	s RtnObj.PatientID=RegNo
	s RtnObj.RelationName=Obj.ForeignName
	s RtnObj.RelationTel=Obj.ForeignPhone
	
	q RtnObj
}

/// 得到卡类型  根据外部卡类型得到his卡类型
ClassMethod GetCardType(Type)
{
	q Type
}

/// 得到证件类型  根据his类型得到外部类型
ClassMethod GetCredType(Type)
{
	q Type
}

/// 得到性别  根据his性别得到外部性别
ClassMethod GetSex(Sex)
{
	q Sex
}

}
