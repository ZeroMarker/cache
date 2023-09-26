Import SQLUser

Class web.UDHCOPOtherLB Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ReadListObjectValueBroker(JSFunName As %String = "", ListName As %String = "", ClassName As %String, PropertyName As %String) As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadListObjectValueBroker("","","User.DHCOPGroupSettings","GSUseINVType")
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	
	s myCount = myobj.Properties.Count()
	s myIdx=0
	
	s myParList=""
	f i=1:1:myCount q:(myParList'="")  d
	.s mypropobj=myobj.Properties.GetAt(i)
	.i (mypropobj.Name=PropertyName) d
	..s myParList=mypropobj.Parameters
	
	s myDisList=myParList.GetAt("DISPLAYLIST")
	s myValList=myParList.GetAt("VALUELIST")
	d mypropobj.%Close()
	d myobj.%Close()
	
	s mySelFlag=0
	s mylistCount= $l(myDisList,",")
	f i=1:1:mylistCount  d
	.s myDisValue=$p(myDisList,",",i)
	.s myValue=$p(myValList,",",i)
	.s mydes= myDisValue
	.s myval = myValue
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	
	q 0
}

/// w ##class(web.UDHCOPOtherLB).ReadCardTypeDefineListBroker("DHCWeb_AddToListA","CardTypeDefine") 
ClassMethod ReadCardTypeDefineListBrokerOLD(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "") As %String
{
	///读取卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	;w ##class(web.UDHCOPOtherLB).ReadCardTypeDefineListBroker("DHCWeb_AddToListA","CardTypeDefine","")
	;m ^TMPCardTypeDefine=%session.Data
	s ^TMPSessionStr("123")=JSFunName_"^"_ListName_"^"_SessionStr
	;b ;02
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s ^TMPSessionStr("234")=SessionStr
	;b ;03
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
		;w "OK"
	}
	
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)   
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.;w rtnval,!,!,!
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod getDefaultCardType() As %String
{
	///读取默认卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	;w ##class(web.UDHCOPOtherLB).getDefaultCardType()
	;
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	
	
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")||(mySelFlag=1)  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.q:myDefault'="Y"
	.
	.s mySelFlag=1
	.
	.s myval=myTypeID_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	
	q myval
}

ClassMethod ReadBankListBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	s json="["
	f  s myBMRowid=$o(^CMC("CMCBM",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CMC("CMCBM",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CMC("CMCBM",myBMRowid),"^", 1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	
	.i JSFunName="GetBankToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	
	s json=json_"]"    
	if (JSFunName="GetBankToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadBankCardType(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s json="["
	s myIdx=1
	f  s myBMRowid=$o(^ARC("CARD",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^ARC("CARD",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^ARC("CARD",myBMRowid),"^", 1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	..s mySelFlag=0	//默认为空
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetBankCardTypeToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetBankCardTypeToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadSex(JSFunName As %String = "", ListName As %String = "", HospId As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s DefaultSex=$G(^DHCDocCardConfig(HospCodeNode,"DefaultSex"))
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s json="["
	f  s myBMRowid=$o(^CT("SEX",myBMRowid)) q:(myBMRowid="")  d
	.s DataFrom=$p(^CT("SEX",myBMRowid),"^", 4)
	.q:(DataFrom'="")&&(DataFrom>+$h)
	.s DateTo=$p(^CT("SEX",myBMRowid),"^", 5)
	.q:(DateTo'="")&&(DateTo<=..%SysDate())
	.s mydes=$p(^CT("SEX",myBMRowid),"^", 2)
	.s Active=$p(^CT("SEX",myBMRowid),"^", 8)
	.q:Active'="Y"
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SEX",myBMRowid),"^", 1)
	.i DefaultSex=myBMRowid d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetSexToHUIJson" d
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Sex",myBMRowid)
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""",""AliasAtr"":"""_$g(AliasAtr)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetSexToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadPatType(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "") As %String
{
	;CT_SocialStatus
	;w ##class(web.UDHCOPOtherLB).ReadPatType("","","^6^1^6^^DHCHealth^")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s myDataFlag=0
	s ^TMPSessionStr122=SessionStr
	s HospID=""
	s:SessionStr'="" HospID=$p(SessionStr,"^",5)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	s json="["
	f  s myBMRowid=$o(^CT("SS",myBMRowid)) q:(myBMRowid="")  d
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",myBMRowid,HospID)="N"
	.s mydes=$p(^CT("SS",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SS",myBMRowid),"^", 1)
	.i (mydes="自费") d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.;Check Out Flag
	.s myFindFlag=1
	.i (+myDataFlag=1) d
	..s myFindFlag=myPEObj.FindPatTypeByDR(myBMRowid)
	..i myPEObj.DefaultPatTypeDR=myBMRowid  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	
	.i JSFunName="GetPatTypeToHUIJson" d
	..s AliasStr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_SocialStatus",myBMRowid)
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""",""AliasStr"":"""_$g(AliasStr)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetPatTypeToHUIJson"){
		q json
	}
	q 0
}

/// 获取患者类型(增加是否连接医保的标志)
/// Table: CT_SocialStatus
/// w ##class(web.UDHCOPOtherLB).ReadPatTypeFYB("GetPatTypeFYBToHUIJson")
ClassMethod ReadPatTypeFYB(JSFunName As %String = "", ListName As %String = "", HospId As %String = "") As %String
{
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s myBConStr=##class(web.DHCOPConfig).GetOPBaseConfig(HospId)
	s myYBConFlag=$p(myBConStr,"^",10)
	s myConFlag="0"		;表示不连接
	
	s json="["
	s myBMRowid=0
	f  s myBMRowid=$o(^CT("SS",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^CT("SS",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SS",myBMRowid),"^", 1)
	.s myReaRowID=""
	.;^DHCPACADM(0,"Social",{PAC_SocialStatus_Dr},{PAC_RowId})
	.s myPACRowID=$o(^DHCPACADM(0,"Social",myBMRowid,""))
	.i (myPACRowID'="") d
	..s myReaRowID=$p(^DHCPACADM(myPACRowID),"^",2)
	.s myInsFlag=0
	.i (myReaRowID'="") d
	..s myInsFlag=$p($g(^PAC("ADMREA",myReaRowID)),"^",9)
	.i ((myYBConFlag=1)&&(+myInsFlag>0)) d
	..s myConFlag=myInsFlag
	.e  d
	..s myConFlag=0
	.s myval=myval_"^"_myConFlag_"^"_myReaRowID
	.i (mydes="自费") d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i (JSFunName="GetPatTypeFYBToHUIJson") d
	..s OneJsonData="{""text"":"""_mydes_""",""value"":"""_myval_""""
	..i (mySelFlag=1) s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	i (JSFunName="GetPatTypeFYBToHUIJson"){
		q json
	}
	
	q 0
}

ClassMethod ReadPatTypeAdm(JSFunName As %String = "", ListName As %String = "") As %String
{
	;PAC_AdmReason
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^PAC("ADMREA",myBMRowid),"^", 1)		;
	.i mydes="自费" d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod ReadCredType(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadCredType("","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myBMRowid=$o(^DHCACCCredType(myBMRowid)) q:(myBMRowid="")  d
	.s active=$p(^DHCACCCredType(myBMRowid),"^",4)
	.q:active'="Y"
	.s def=$p(^DHCACCCredType(myBMRowid),"^",3)
	.s mydes=$p(^DHCACCCredType(myBMRowid),"^", 1)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^DHCACCCredType(myBMRowid),"^", 2)
	.i def="Y" d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod GetCredType() As %String
{
	s ret=""
  	s myBMRowid=0
	f  s myBMRowid=$o(^PAC("CARD",myBMRowid)) q:(myBMRowid="")  d
	.s active=$p(^PAC("CARD",myBMRowid,"DHC"),"^",1)
	.q:active'="Y"
	.s myDateFrom=$p(^PAC("CARD",myBMRowid),"^",3)
	.Q:(myDateFrom>+$H)&(myDateFrom'="")
	.s myDateTo=$p(^PAC("CARD",myBMRowid),"^",4)
	.Q:(myDateTo<+$H)&(myDateTo'="")
	.s def=$p(^PAC("CARD",myBMRowid, "DHC"),"^",2)
	.s mydes=$p(^PAC("CARD",myBMRowid),"^", 2)		;Desc
	.q:mydes["身份证"
	.If ret="" Set ret=myBMRowid_"!"_mydes
	.else  Set ret=ret_"^"_myBMRowid_"!"_mydes 
	Q ret
}

ClassMethod ReadCredTypeExp(JSFunName As %String = "", ListName As %String = "", HospId As %String = "", CardTypeID As %String = "") As %String
{
	;读取 PAC_CardType and DHC_CredType  相互之间的数据
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadCredTypeExp("","")
	s json="["
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
    s (CTDCredTypeListStr,CTDCredTypeDefault)=""
    if CardTypeID'=""{
        s CTDCredTypeListStr=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",43)
        s CTDCredTypeDefault=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",44)
    }
	Set langid=..%LanguageID()
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	for {
		s myBMRowid=$o(^PAC("CARD",myBMRowid))
		q:(myBMRowid="")
		s active=$p(^PAC("CARD",myBMRowid,"DHC"),"^",1)
		continue:active'="Y"
		s myDateFrom=$p(^PAC("CARD",myBMRowid),"^",3)
		continue:(myDateFrom>+$H)&(myDateFrom'="")
		s myDateTo=$p(^PAC("CARD",myBMRowid),"^",4)
		continue:(myDateTo<+$H)&(myDateTo'="")
		s def=$p(^PAC("CARD",myBMRowid, "DHC"),"^",2)
		s mydes=$p(^PAC("CARD",myBMRowid),"^", 2)		;Desc
		Set mydes= ##class(User.DHCCredType).GetTranByDesc("CRTDesc",mydes,langid)
		s CredTypeSort=9999 
		s CredTypeSortType=##class(web.DHCOPRegConfig).GetSpecConfigNode("acccredtypeSort",HospId)
		if (CredTypeSortType'=""){
			s CredTypeSort=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.DHCCredType",CredTypeSortType,myBMRowid)
			if (CredTypeSort="") s CredTypeSort=9999 
		}
		s CredTypeList(CredTypeSort,myBMRowid)=$g(mydes)
	}
	s CredTypeSort=""
	for {
		s CredTypeSort=$o(CredTypeList(CredTypeSort))
		q:CredTypeSort=""
		s myBMRowid=""
		for {
			s myBMRowid=$o(CredTypeList(CredTypeSort,myBMRowid))
			q:myBMRowid=""
            Continue:(CTDCredTypeListStr'="")&&((","_CTDCredTypeListStr_",")'[(","_myBMRowid_","))
			s def=$p(^PAC("CARD",myBMRowid, "DHC"),"^",2)
			//code用于判断是否身份证
			s myval=myBMRowid_"^"_$p(^PAC("CARD", myBMRowid),"^", 1)
			s mydes=$G(CredTypeList(CredTypeSort,myBMRowid))
			i (def="Y")&&(CTDCredTypeDefault=""){
                s mySelFlag=1
            }else{
                s mySelFlag=0
                s:CTDCredTypeDefault=myBMRowid mySelFlag=1
            } 
			if (JSFunName="GetCredTypeToHUIJson"){
				s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
				i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
				s OneJsonData=OneJsonData_"}"
				i myIdx=1 d
				.s json=json_OneJsonData
				e  d
				.s json=json_","_OneJsonData
			}else{
				s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
				s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
				&javascript<#(rtnval)#>
			}
		    s myIdx=myIdx+1
		}
	}
	s json=json_"]"    
	if (JSFunName="GetCredTypeToHUIJson"){
		q json
	}
	q 0
}

ClassMethod getdefaultCredType() As %Library.String
{
	s defCredType="",defCredTypeID="",active="N"
	q:'$d(^DHCACCCredType("0","DFT","Y")) "-1^^"
	s rtn="-1"
	f  s defCredTypeID=$o(^DHCACCCredType("0","DFT","Y",defCredTypeID))  q:(defCredTypeID="")!(active="Y")  d
	.s active=$p(^DHCACCCredType(defCredTypeID),"^",4)
	.q:active'="Y"
	.s defCredType=$p(^DHCACCCredType(defCredTypeID),"^",1)
	.s defCredTypeROWID=defCredTypeID
	.s rtn=0
	q rtn_"^"_defCredType_"^"_defCredTypeROWID
}

ClassMethod ReadPayMType(JSFunName As %String, ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadPayMType("","")
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=1
	s myIdx=0
	s mydes="缴款"
	s myval="P"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="退款"
	s myval="R"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q 0
}

ClassMethod ReadAccountType(JSFunName As %String, ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadPayMType("","")
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=1
	s myIdx=0
	s mydes="个人账户"
	s myval="P"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="集体账户"
	s myval="C"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q 0
}

ClassMethod ReadPayModeBroker(JSFunName As %String, ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadINVPRTFlagBroker("","")
	s myBMRowid=0
	s mySelFlag=1
	s myIdx=0
	s mydes="全部"
	s myval=""
	s json="["
	i JSFunName="GetPayModeToHUIJson" {
		s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""_",""selected"":true"_"}"
		s json=json_OneJsonData
	}else{
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
		s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
		&javascript<#(rtnval)#>
	}
	
	s rowid=0
	f  s rowid=$o(^CT("CTPM",rowid)) q:rowid=""  d
	.s mydes=$p(^CT("CTPM",rowid),"^",2)
	.s myIdx=myIdx+1
	.s mySelFlag=0
	.i JSFunName="GetPayModeToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(rowid)_""""_"}"
	..s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(rowid),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	s json=json_"]"
	i JSFunName="GetPayModeToHUIJson" q json
}

ClassMethod ReadPayMode(JSFunName As %String = "", ListName As %String = "", gGroupID As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s json="["
	s myGSRowID=$o(^DHCOPGSi("GS",0,"GSDR",gGroupID,0))
	q:myGSRowID="" "-1"
	f  s myBMRowid=$o(^DHCOPGS("GS",myGSRowID,"PM",myBMRowid)) q:(myBMRowid="")  s str=^(myBMRowid) d
	.s def=$p(str,"^",4)
	.;q:def'="Y"
	.s paymodedr=$p(str,"^",1)
	.q:paymodedr=""
	.q:'$d(^CT("CTPM",paymodedr))
	.s paymodecode=$p(^CT("CTPM",paymodedr),"^",1)
	.q:paymodecode="CPP"
	.s myPMPDFlag=$p(str,"^",7)
	.q:myPMPDFlag'="Y"
	.s RPFlag=$p(str,"^",6)
	.s mydes=$p(^CT("CTPM",paymodedr),"^",2)
	.s myval=paymodedr
	.s myval=myval_"^"_paymodecode_"^"_RPFlag
	.i def="Y" d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	
	.i JSFunName="GetPayModeToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetPayModeToHUIJson"){
		q json
	}
	q 0
}

ClassMethod getdefaultpaymode(group As %String) As %String
{
	q:'$d(^DHCOPGS("GS",group)) "-320^^"
	s rtn="-320",paymodeid="",paymode=""
	s sub=0
	s myGSRowID=$o(^DHCOPGSi("GS",0,"GSDR",group,0))
	q:myGSRowID="" "-1"
	
	f  s sub=$o(^DHCOPGS("GS",myGSRowID,"PM",sub)) q:sub=""  s str=^(sub) d
	.s def=$p(str,"^",4)
	.q:def'="Y"
	.s paymodedr=$p(str,"^",1)
	.q:paymodedr=""
	.q:'$d(^CT("CTPM",paymodedr))
	.s paymodecode=$p(^CT("CTPM",paymodedr),"^",1)
	.q:paymodecode="CPP"
	.s rtn="0"
	.s paymodeid=paymodedr
	.s paymode=$p(^CT("CTPM",paymodedr),"^",2)
	q rtn_"^"_paymode_"^"_paymodeid
}

ClassMethod ReadAllPayModeBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadAllPayModeBroker("","")
	s myIdx=0
	s myCTPMRowID=0
	f  s myCTPMRowID=$o(^CT("CTPM",myCTPMRowID)) q:myCTPMRowID=""  d
	.s myCTPMCode=$p(^CT("CTPM",myCTPMRowID),"^",1)
	.s myCTPMDesc=$p(^CT("CTPM",myCTPMRowID),"^",2)
	.s myPMSub=0
	.s mydes=myCTPMDesc
	.s myval=myCTPMRowID_"^"_myCTPMCode
	.i myIdx=0 d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	
	q 0
}

ClassMethod ReadOPFeeUserListBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	n (JSFunName, ListName)
	
	;w ##class(web.UDHCOPOtherLB).ReadOPFeeUserListBroker("","")
	s myCount=0
	s myIdx=0
	
	k ^TMPOPFOperIDLB($j)
	
	;^DHCINVOICE(0,"USER",{INV_Usr},{INV_rowid})
	;发现门诊发票退出
	s myUserDR=0
	s myINVFlag=""
	f  s myUserDR=$o(^DHCINVOICE(0,"USER",myUserDR)) q:(myUserDR="")  d
	.s myINVFlag=""
	.s myINVRowID=0
	.s myFindFlag=0
	.f  s myINVRowID=$o(^DHCINVOICE(0,"USER",myUserDR,myINVRowID)) q:((myINVRowID="")||(+myFindFlag))  d
	..s myINVFlag=$p($g(^DHCINVOICE(myINVRowID)),"^",8)
	..;q:(myINVFlag'="O")
	..q:(myINVFlag="I")
	..s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	..s mySelFlag=0
	..i myIdx=0 d
	...s mySelFlag=1
	..s myval=myUserDR
	..q:($g(^TMPOPFOperIDLB($j, myUserDR)))
	..i $g(^TMPOPFOperIDLB($j, myUserDR)) d
	...s myFindFlag=1
	..s ^TMPOPFOperIDLB($j, myUserDR)=myUserDR
	..s mydes=myUserName
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=+myIdx+1
	..s myCount=+myCount+1
	
	;^DHCACDi("AccM",0,"User",{AccPD_User_DR},
	s myUserDR=0
	f  s myUserDR=$o(^DHCACDi("AccM",0,"User",myUserDR)) q:(myUserDR="")  d
	.;存在退出
	.q:(myUserDR=$g(^TMPOPFOperIDLB($j,myUserDR)))
	.s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	.s mySelFlag=0
	.i myIdx=0 d
	..s mySelFlag=1
	.s myval=myUserDR
	.s ^TMPOPFOperIDLB($j, myUserDR)=myUserDR
	.s mydes=myUserName
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=+myIdx+1
	.s myCount=+myCount+1
	
	k ^TMPOPFOperIDLB($j)
	
	q myCount
}

ClassMethod ReadOPGRPFeeUserListBroker(JSFunName As %String = "", ListName As %String = "", GrpRowID As %String, ExpStr As %String) As %String
{
	n (JSFunName, ListName, GrpRowID, ExpStr)
	
	;
	;w ##class(web.UDHCOPOtherLB).ReadOPGRPFeeUserListBroker("","","137","")
	s myCount=0
	s myIdx=0
	i GrpRowID="" d
	.;默认的收费用户
	.s myCount=..ReadOPFeeUserListBroker(JSFunName, ListName)
	e  d
	.;取出此安全组下的用户
	.;^SSU("SSUSR",0,"Group",{SSUSR_Group},{SSUSR_RowId})
	.s myUserDR=0
	.f  s myUserDR=$o(^SSU("SSUSR",0,"Group",GrpRowID, myUserDR)) q:(myUserDR="")  d
	..s myUserName=$p($g(^SSU("SSUSR",myUserDR)),"^",2)
	..s mySelFlag=0
	..i myIdx=0 d
	...s mySelFlag=1
	..s myval=myUserDR
	..s mydes=myUserName
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=+myIdx+1
	..s myCount=+myCount+1
	
	q myCount
}

ClassMethod ReadYBFlagByRowID(INSRowID As %String) As %String
{
	///根据费别获取的医保标志
	n (INSRowID)
	
	q:(INSRowID="") 0
	
	s rtn=0
	;^PAC("ADMREA",{REA_RowId})
	
	s myYBFlag=$p(^PAC("ADMREA",INSRowID),"^",9)
	
	q myYBFlag
}

ClassMethod ReadYBFlagByPayType(PatTypeRowID As %String) As %String
{
	;根据患者类型获取是否连接医保，优先连接
	;w ##class(web.UDHCOPOtherLB).ReadYBFlagByPayType()
	n (PatTypeRowID)
	
	q:(PatTypeRowID="") 0
	
	s myBConStr=##class(web.DHCOPConfig).GetOPBaseConfig()
	s myYBConFlag=$p(myBConStr,"^",10)
	s myConFlag="0"		;表示不连接
	
	s myReaRowID=""
	;^DHCPACADM(0,"Social",{PAC_SocialStatus_Dr},{PAC_RowId})
	s myPACRowID=0
	
	f  s myPACRowID=$o(^DHCPACADM(0,"Social",PatTypeRowID,myPACRowID)) q:(myPACRowID="")  d
	.q:(+myConFlag'=0)
	.i (myPACRowID'="") d
	..s myReaRowID=$p(^DHCPACADM(myPACRowID),"^",2)
	.s myInsFlag=0
	.i (myReaRowID'="") d
	..s myInsFlag=$p(^PAC("ADMREA",myReaRowID),"^",9)
	.b	;;;
	.i ((myYBConFlag=1)&&(+$g(myInsFlag)>0)) d
	..s myConFlag=myInsFlag
	.e  d
	..s myConFlag=0
	
	q myConFlag
}

ClassMethod ReadINVPRTFlagBroker(JSFunName As %String, ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadINVPRTFlagBroker("","")
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=1
	s myIdx=0
	s mydes="全部"
	s myval=""
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="作废发票"
	s myval="A"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>

	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="红冲发票"
	s myval="S"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q 0
}

ClassMethod ReadFootFlagBroker(JSFunName As %String, ListName As %String = "") As %String
{
	;w ##class(web.UDHCOPOtherLB).ReadFootFlagBroker("","")
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=1
	s myIdx=0
	s mydes="全部"
	s myval=""
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="结算"
	s myval="Y"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>

	s mySelFlag=0
	s myIdx=myIdx+1
	s mydes="未结算"
	s myval="N"
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	
	q 0
}

Query ReadADMINSType() As %SQLQuery(CONTAINID = 1)
{
	SELECT REA_RowID, REA_Desc FROM PAC_AdmReason
}

Query ReadCTPayMode() As %SQLQuery(CONTAINID = 1)
{
	SELECT CTPM_RowID, CTPM_Desc  FROM CT_PayMode
}

/*Query ReadSSUser(CTCode As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT SSUSR_Name as 姓名,SSUSR_Initials as  代码  FROM SS_User where SSUSR_Initials %STARTSWITH :CTCode or SSUSR_Name %STARTSWITH :CTCode
}*/
Query ReadSSUser(desc As %Library.String, HospId As %String = "") As websys.Query(CONTAINID = 3, ROWSPEC = "ID:%String,USER:%String")
{
}

ClassMethod ReadSSUserExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, HospId As %String = "") As %Library.Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s USERID=0
	s desc=$zcvt(desc,"U")
	for {
		s USERID=$O(^SSU("SSUSR",USERID)) Q:USERID=""
		s USERIDNAME=$p(^SSU("SSUSR",USERID),"^",2)
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",USERID,HospId)="N"
		s SSUSRInitials=$p(^SSU("SSUSR",USERID),"^",1)
		continue:((desc'="")&&($zcvt(USERIDNAME,"U")'[desc)&&($zcvt(SSUSRInitials,"U")'[desc))
		s USRActive=$p(^SSU("SSUSR",USERID),"^",19)
		continue:USRActive'="Y"
		s Datefrom=$p(^SSU("SSUSR",USERID),"^",96)
		s DateTo=$p(^SSU("SSUSR",USERID),"^",97)
		continue:(Datefrom'="")&&(Datefrom>+$H)
		continue:(DateTo'="")&&(DateTo<+$H)
		d OuputRow
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow
	set Data=$lb(USERID,USERIDNAME)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ReadDepartmentListBroker(JSFunName As %String = "", ListName As %String = "", Zone As %String = "") As %String
{
	///读取科室
	
	s mydes=""
	s myval=""
	s mySelFlag=1
	s myDataFlag=0
	s myIdx=0
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	s myIdx=myIdx+1
	s mySelFlag=0
	s ExaBoroughRowId=0
	f  s ExaBoroughRowId=$O(^User.DHCExaBoroughD(ExaBoroughRowId)) q:ExaBoroughRowId=""  d	
	.s Bor=$List(^User.DHCExaBoroughD(ExaBoroughRowId),5)
	.i Bor=Zone d
	..s BorDepRowId=0
	..f  s BorDepRowId=$O(^User.DHCExaBorDepD(BorDepRowId)) q:BorDepRowId=""  d
	...s DepBor=$List(^User.DHCExaBorDepD(BorDepRowId),6)
	...i DepBor=ExaBoroughRowId d
	....s ^DHCZLJtest(BorDepRowId)=DepBor
	....s DepRowId=$List(^User.DHCExaBorDepD(BorDepRowId),7)
	....s Dep=$p(^CTLOC(DepRowId),"^",2)
	....s mydes=$p(Dep,"-",2)
	....s myval=DepRowId
	....s myval=myval_"^"_$p(^CTLOC(DepRowId),"^",2)	
	....s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	....s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	....&javascript<#(rtnval)#>
	....s myIdx=myIdx+1
	q 0
}

/// ////////////////////2012-12-23 zzy
ClassMethod ReadPatTypeAdmByOrder(JSFunName As %String = "", ListName As %String = "", OrderID As %String = "") As %String
{
	;PAC_AdmReason
	s BBExtCode=$p($g(^OEORD(+OrderID,"I",$P(OrderID,"||",2),11)),"^",18)
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^PAC("ADMREA",myBMRowid),"^", 1)		;
	.i myBMRowid=BBExtCode d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/// 号别列表  2014-01-13
/// w ##class(web.UDHCOPOtherLB).SessionTypeListBroker("DHCWeb_AddToListA","SessionTypeDefine","876","251")
ClassMethod SessionTypeListBroker(JSFunName As %String = "", ListName As %String = "", UserID As %String = "", CTLocID As %String = "") As %String
{
	s ^peng("SessionType")=JSFunName_"^"_ListName_"^"_UserID_"^"_CTLocID
	//根据用户ID查找改医生出诊号别
	//s UserID="876"
	//s CTLocID="189"
	s CTPCPRowId=$p($g(^SSU("SSUSR",UserID)),"^",14)
	s mydes=""
	s myval=""
	s myIdx=1
	s mySelFlag=0
	s MarkdMarkDr=0
	f  s MarkdMarkDr=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",CTPCPRowId,MarkdMarkDr)) q:MarkdMarkDr=""  d
	.q:(CTPCPRowId=MarkdMarkDr) ;去掉本人
	.s ID=0
	.f  s ID=$o(^User.DHCMarkDocI("MarkdDocMarkIndex",CTPCPRowId,MarkdMarkDr,ID)) q:ID=""  d
	..s MarkddepDr=$lg(^User.DHCMarkDocD(ID),4)
	..q:(CTLocID'="")&&(MarkddepDr'=CTLocID) ;去掉不是当前科室
	..s myval=MarkdMarkDr
	..s mydes=$p(^CTPCP(MarkdMarkDr,1),"^",2)
	..//w myval_"^"_mydes_"^"_MarkddepDr,!	
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>	
	..s myIdx=myIdx+1
	q 0
}

ClassMethod ReadCardTypeDefineListBroker(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "", defCardDr As %String = "") As %String
{
	//s ^peng("JSFunName")=JSFunName
	///读取卡类型定义
	;^DHCCARDTYPEDef(myTypeID)
	;w ##class(web.UDHCOPOtherLB).ReadCardTypeDefineListBroker("","")
	;m ^TMPCardTypeDefine=%session.Data
	s ^TMPSessionStr=SessionStr
	s HospId=$p(SessionStr,"^",5)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s myTypeID=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myDataFlag=0
	s ^TMPSessionStr=SessionStr
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	Set langid=..%LanguageID()
	s json="["
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.Set mydes= ##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc",mydes,langid)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",myTypeID,HospId)="N"
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.Set $P(myval,"^",3)= ##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc",$P(myval,"^",3),langid)
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	..i myPEObj.DefaultCardTypeDR=myTypeID  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	.i JSFunName="GetCardTypeToJson" d
	..i myIdx=0 d
	...s json=json_"['"_$g(mydes)_"','"_$g(myval)_"']"
	..e  d
	...s json=json_",['"_$g(mydes)_"','"_$g(myval)_"']"
	.i JSFunName="GetCardTypeToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true" s defCardDr=myTypeID
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.i (JSFunName'="GetCardTypeToJson")&&(JSFunName'="GetCardTypeToHUIJson")  d
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetCardTypeToJson")||(JSFunName="GetCardTypeToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadCardTypeDefineListBroker1(myTypeID As %String) As %String
{
	s myval=myTypeID
	q:myTypeID="" ""
	s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	Q myval
}

/// 获取退卡时可以使用的支付方式，退卡只支持原支付方式及现金
ClassMethod PayModeToCancleCard(CardRowId As %String) As %String
{
	
	q:CardRowId="" "[]"
	s CashDr=$o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4("CASH"),""))
	s CashDesc=$p(^CT("CTPM",CashDr),"^",2)
	s PayModeJson="[{""text"":"""_$g(CashDesc)_""",""id"":"""_$g(CashDr)_""",""selected"":true}]"
	s INVRowID=$p(^DHCCARD("CF",CardRowId),"^",17)
	if INVRowID'="" {
		s INVChild=$o(^DHCCARDINVPRT(INVRowID,"P",0))
		if INVChild'="" {
			s OldPayModeDr=$p(^DHCCARDINVPRT(INVRowID,"P",INVChild),"^",1)
			if (OldPayModeDr'="")&&(OldPayModeDr'=CashDr) {
				s OldPayModeDesc=$p(^CT("CTPM",OldPayModeDr),"^",2)
				s PayModeJson="["
				s PayModeJson=PayModeJson_"{""text"":"""_$g(OldPayModeDesc)_""",""id"":"""_$g(OldPayModeDr)_""",""selected"":true},"
				s PayModeJson=PayModeJson_"{""text"":"""_$g(CashDesc)_""",""id"":"""_$g(CashDr)_"""}"
				s PayModeJson=PayModeJson_"]"
			}
		}
	}
	q PayModeJson
}

ClassMethod ReadSexNew(JSFunName As %String = "", ListName As %String = "", HospId As %String = "") As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadSexNew("GetSexToHUIJson","",2)
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s DefaultSex=$G(^DHCDocCardConfig(HospCodeNode,"DefaultSex"))
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s json="["
	f  s myBMRowid=$o(^CT("SEX",myBMRowid)) q:(myBMRowid="")  d
	.s DataFrom=$p(^CT("SEX",myBMRowid),"^", 4)
	.q:(DataFrom'="")&&(DataFrom>+$h)
	.s DateTo=$p(^CT("SEX",myBMRowid),"^", 5)
	.q:(DateTo'="")&&(DateTo<=..%SysDate())
	.s mydes=$p(^CT("SEX",myBMRowid),"^", 2)
	.s Active=$p(^CT("SEX",myBMRowid),"^", 8)
	.q:Active'="Y"
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SEX",myBMRowid),"^", 1)
	.i DefaultSex=myBMRowid d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetSexToHUIJson" d
	..s AliasAtr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_Sex",myBMRowid)
	..s OneJsonData="{""Desc"":"""_$g(mydes)_""",""Value"":"""_$g(myBMRowid)_""",""AliasAtr"":"""_$g(AliasAtr)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetSexToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadPatTypeAll(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "") As %String
{
	;CT_SocialStatus
	;w ##class(web.UDHCOPOtherLB).ReadPatType("","","^6^1^6^^DHCHealth^")
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s myDataFlag=0
	s ^TMPSessionStr122=SessionStr
	s HospID=""
	s:SessionStr'="" HospID=$p(SessionStr,"^",5)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	s json="["
	f  s myBMRowid=$o(^CT("SS",myBMRowid)) q:(myBMRowid="")  d
	.;Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",myBMRowid,HospID)="N"
	.s mydes=$p(^CT("SS",myBMRowid),"^", 2)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^CT("SS",myBMRowid),"^", 1)
	.i (mydes="自费") d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.;Check Out Flag
	.s myFindFlag=1
	.i (+myDataFlag=1) d
	..s myFindFlag=myPEObj.FindPatTypeByDR(myBMRowid)
	..i myPEObj.DefaultPatTypeDR=myBMRowid  d
	...s mySelFlag=1
	.q:(+myFindFlag=0)
	
	.i JSFunName="GetPatTypeToHUIJson" d
	..s AliasStr=##class(DHCDoc.Util.Base).GetAliasByTabName("CT_SocialStatus",myBMRowid)
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""",""AliasStr"":"""_$g(AliasStr)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetPatTypeToHUIJson"){
		q json
	}
	q 0
}

ClassMethod ReadAdmReason(JSFunName As %String = "", ListName As %String = "", SessionStr As %String = "") As %String
{
	
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	s myDataFlag=0
	s ^TMPSessionStr122=SessionStr
	s:SessionStr'="" HospID=$p(SessionStr,"^",5)
	Set langid=..%LanguageID()
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s firstIDStr=""
	s json="["
	s myBMRowid=0
	f  s myBMRowid=$o(^PAC("ADMREA",myBMRowid)) q:(myBMRowid="")  d
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PAC_AdmReason",myBMRowid,HospID)="N"
	.s mydes=$p(^PAC("ADMREA",myBMRowid),"^", 2)
	.s DataFrom=$p(^PAC("ADMREA",myBMRowid),"^", 3)
	.s DateTo=$p(^PAC("ADMREA",myBMRowid),"^", 4)
	.q:(DataFrom'="")&&(DataFrom>..%SysDate())
	.q:(DateTo'="")&&(DateTo<=..%SysDate())
	.s mydes=##class(User.PACAdmReason).GetTranByDesc("READesc",mydes,langid)
	.s myval=myBMRowid
	.s myval=myval_"^"_$p(^PAC("ADMREA",myBMRowid),"^", 1)
	.i (mydes="自费") d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetAdmReasonToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myBMRowid)_""",""AliasStr"":"""_""_""""
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=0 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"    
	if (JSFunName="GetAdmReasonToHUIJson"){
		q json
	}
	q 0
}

/// Dessc: 通过证件类型ID和身份证Code，判断证件类型ID是否属于身份证
/// Input: FCredTypeID:证件类型ID、CredTypeCode:身份证Code
/// Output: -1/0^描述: 否/是^描述
/// Debug: w ##class(web.UDHCOPOtherLB).CheckISCredType(20)
ClassMethod CheckISCredType(FCredTypeID, CredTypeCode = "01")
{
	Q:(FCredTypeID="")||(CredTypeCode="") "-1^缺少有效入参"
	
	s CredTypeID=$o(^DHCACCCredType("0","Code",CredTypeCode,0))
	Q:(+CredTypeID=0) "-1^没有找到有效证件类型Code"
	
	Q:FCredTypeID'=CredTypeID "-1^不是身份证证件类型"
	Q "0^成功"
}

/// w ##class(web.UDHCOPOtherLB).GetNameType()
ClassMethod GetNameType() As %String
{
	
	s ret=""
	set rs=##class(%ResultSet).%New()
  	set rs.ClassName="web.DHCBL.CT.CTPatMasNameType"
	set rs.QueryName="GetDataForCmb1"
	set sc=rs.Execute("", "", "")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s ID=rs.Data("ID")
		s CTPMNTDesc=rs.Data("CTPMNTDesc")
		If ret="" Set ret=ID_"!"_CTPMNTDesc
		else  Set ret=ret_"^"_ID_"!"_CTPMNTDesc
	}
	Q ret
}

}
