Class web.DHCBL.CARD.CardTypeDef Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 删除卡类型
ClassMethod Delete(RowId As %String) As %Integer
{
	Quit ##class(User.DHCCardTypeDef).%DeleteId(RowId)
}

/// 新增卡类型
ClassMethod Insert(Code As %String, Desc As %String, PrtINVFlag As %String, FareType As %String, UseINVType As %String, ReclaimFlag As %String, DateFrom As %String, DateTo As %String, DefaultFlag As %String, HardComDR As %String, BarCodeDR As %String, ActiveFlag As %String, ReadCardMode As %String, CardNoLength As %String, SecrityNoFlag As %String, ReadCardFocusElement As %String, CardRefFocusElement As %String, OverWriteFlag As %String, PANoCardRefFlag As %String, SearchMasFlag As %String, SetFocusElement As %String, PreCardFlag As %String, CardAccountRelation As %String, CardFareCost As %String, INVPRTXMLName As %String, PatPageXMLName As %String, StChangeValidateFlag As %String, SearchCardNoMode As %String, CardNamePlateStr As %String, ValidateMode As %String, SupportLossFlag As %String, SupportExChangeFlag As %String, SupportFillFlag As %String, UsePANoToCardNO As %String, CardPayNeedCheckFlag As %String) As %Integer
{
	n obj
	s ^TMPCardType=$lb(Code , Desc , PrtINVFlag , FareType , UseINVType , ReclaimFlag , DateFrom , DateTo , DefaultFlag , HardComDR , BarCodeDR , ActiveFlag , ReadCardMode , CardNoLength , SecrityNoFlag , ReadCardFocusElement , CardRefFocusElement , OverWriteFlag , PANoCardRefFlag , SearchMasFlag , SetFocusElement , PreCardFlag , CardAccountRelation , CardFareCost , INVPRTXMLName, PatPageXMLName, StChangeValidateFlag,UsePANoToCardNO,CardPayNeedCheckFlag)
	if (DefaultFlag="Y")
	{
		&sql(update SQLUser.DHC_CardTypeDef set CTD_DefaultFlag='N')
		If ((+SQLCODE '=0 )&&(+SQLCODE'=100)) quit 200
	}
	;d ##class(web.DHCBL.CARD.CardTypeDef).Insert("11","就诊卡","Y","NP","I","Y",+$h,+$h+30,"Y","","")
	Set obj = ##class(User.DHCCardTypeDef).%New()
	
	Set obj.CTDCode = Code
	Set obj.CTDDesc = Desc
	Set obj.CTDPrtINVFlag = PrtINVFlag
	Set obj.CTDFareType = FareType
	Set obj.CTDUseINVType = UseINVType
	Set obj.CTDReclaimFlag = ReclaimFlag
	If (obj.CTDDateFromIsValid(+DateFrom))
		{	
			if (DateFrom'="") {
			   Set obj.CTDDateFrom =..%ZDH(DateFrom) //$ZDH(DateFrom,4)
			} 
		}
	If (obj.CTDDateToIsValid(+DateTo))
		{    
		     if (DateTo'="") {
			   Set obj.CTDDateTo =..%ZDH(DateTo) //$ZDH(DateTo,4) 
		     }  
		}
	Set obj.CTDDefaultFlag = DefaultFlag
	//s ^zjtest = HardComDR_":"_BarCodeDR
	If (HardComDR '= "")
	{
		Do obj.CTDHardComDRSetObjectId(HardComDR)
	}

	If (BarCodeDR '= "")
	{
		Do obj.CTDBarCodeComDRSetObjectId(BarCodeDR)
	}
	
	Set obj.CTDActiveFlag = ActiveFlag
	Set obj.CTDReadCardFocusElement = ReadCardFocusElement
	Set obj.CTDCardRefFocusElement = CardRefFocusElement
	Set obj.CTDOverWriteFlag = OverWriteFlag
	Set obj.CTDPANoCardRefFlag = PANoCardRefFlag
	
	Set obj.CTDSearchMasFlag = SearchMasFlag
	Set obj.CTDSetFocusElement = SetFocusElement
	Set obj.CTDPreCardFlag = PreCardFlag
	Set obj.CTDCardAccountRelation = CardAccountRelation	
	Set obj.CTDCardFareCost = CardFareCost
	
	Set obj.CTDReadCardMode = ReadCardMode
	Set obj.CTDCardNoLength = CardNoLength
	Set obj.CTDSecurityNoFlag = SecrityNoFlag
		
	Set obj.CTDINVPRTXMLName = INVPRTXMLName
	Set obj.CTDPatPageXMLName = PatPageXMLName
	Set obj.CTDStChangeValidateFlag = StChangeValidateFlag

	Set obj.CTDSearchCardNoMode = SearchCardNoMode
	Set obj.CTDCardNamePlateStr = CardNamePlateStr
	Set obj.CTDValidateMode =ValidateMode
	Set obj.CTDSupportLossFlag = SupportLossFlag
	Set obj.CTDSupportExChangeFlag = SupportExChangeFlag
	Set obj.CTDSupportFillFlag =SupportFillFlag
	set obj.CTDUsePANoToCardNO=UsePANoToCardNO
	set obj.CTDCardPayNeedCheckFlag=CardPayNeedCheckFlag	
	Set sc = obj.%Save()
	if ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Quit -1
	}
	
	Quit 0
}

ClassMethod Update(RowId As %String, Code As %String, Desc As %String, PrtINVFlag As %String, FareType As %String, UseINVType As %String, ReclaimFlag As %String, DateFrom As %String, DateTo As %String, DefaultFlag As %String, HardComDR As %String, BarCodeDR As %String, ActiveFlag As %String, ReadCardMode As %String, CardNoLength As %String, SecrityNoFlag As %String, ReadCardFocusElement As %String, CardRefFocusElement As %String, OverWriteFlag As %String, PANoCardRefFlag As %String, SearchMasFlag As %String, SetFocusElement As %String, PreCardFlag As %String, CardAccountRelation As %String, CardFareCost As %String, INVPRTXMLName As %String, PatPageXMLName As %String, StChangeValidateFlag As %String, SearchCardNoMode As %String, CardNamePlateStr As %String, ValidateMode As %String, SupportLossFlag As %String, SupportExChangeFlag As %String, SupportFillFlag As %String, UsePANoToCardNO As %String, CardPayNeedCheckFlag As %String) As %Integer
{
	n obj
	;w ##class(web.DHCBL.CARD.CardTypeDef).Update(2, "11","就诊卡","Y","C","L","Y","","","N","","","IE","Handle","12","N","Name","","N","N","N","CardNo","N","N","10","RegPrint","PatFirstPage","Y")
	s ^TMPCardType=$lb(RowId, Code , Desc , PrtINVFlag , FareType , UseINVType , ReclaimFlag , DateFrom , DateTo , DefaultFlag , HardComDR , BarCodeDR , ActiveFlag , ReadCardMode , CardNoLength , SecrityNoFlag , ReadCardFocusElement , CardRefFocusElement , OverWriteFlag , PANoCardRefFlag , SearchMasFlag , SetFocusElement , PreCardFlag , CardAccountRelation , CardFareCost , INVPRTXMLName, PatPageXMLName, StChangeValidateFlag, SearchCardNoMode, CardNamePlateStr, ValidateMode, SupportLossFlag, SupportExChangeFlag, SupportFillFlag,UsePANoToCardNO,CardPayNeedCheckFlag)
	;s ^Tomming("CardType","Update")=$lb(SearchCardNoMode, CardNamePlateStr, ValidateMode, SupportLossFlag, SupportExChangeFlag, SupportFillFlag)

	Set rtn = ""
	Set clr = ""
	
	i DefaultFlag="Y" 
	{
		&sql(update SQLUser.DHC_CardTypeDef set CTD_DefaultFlag='N')
		If ((+SQLCODE '=0 )&&(+SQLCODE'=100)) quit 200
	}
	
	;d ##class(web.DHCBL.CARD.CardTypeDef).Update(3,"222","普通卡","Y","","I","Y",+$h,+$h+30,"Y","","")
	Set obj = ##class(User.DHCCardTypeDef).%OpenId(RowId)
	If ((obj) && (+rtn = 0))
	{
		
		Set obj.CTDCode = Code
		Set obj.CTDDesc = Desc
		Set obj.CTDPrtINVFlag = PrtINVFlag
		Set obj.CTDFareType = FareType
		Set obj.CTDUseINVType = UseINVType
		Set obj.CTDReclaimFlag = ReclaimFlag
		If (obj.CTDDateFromIsValid(+DateFrom))
		{   
			IF DateFrom'="" {
				Set obj.CTDDateFrom=..%ZDH(DateFrom) //$ZDH(DateFrom,4)
			}else{
				Set obj.CTDDateFrom=""
			}
		}
		    ;obj.CTDDateFromDisplayToLogical(DateFrom)}
		If (obj.CTDDateToIsValid(+DateTo))
		{  
			if DateTo'="" {
				s obj.CTDDateTo=..%ZDH(DateTo) //$ZDH(DateTo,4)
			}else{
				s obj.CTDDateTo=""
			}
		}
		
		If (HardComDR '= "")
		{
			Do obj.CTDHardComDRSetObjectId(HardComDR)
			Set clr="1"
		}
		
		If (BarCodeDR '= "")
		{
			Do obj.CTDBarCodeComDRSetObjectId(BarCodeDR)			
			Set clr= clr_"2"
		}
	
		Set obj.CTDActiveFlag = ActiveFlag
		Set obj.CTDDefaultFlag = DefaultFlag
		Set obj.CTDReadCardFocusElement = ReadCardFocusElement
		Set obj.CTDCardRefFocusElement = CardRefFocusElement
		Set obj.CTDOverWriteFlag = OverWriteFlag
		Set obj.CTDPANoCardRefFlag = PANoCardRefFlag	
	
		Set obj.CTDSearchMasFlag = SearchMasFlag
		Set obj.CTDSetFocusElement = SetFocusElement
		Set obj.CTDPreCardFlag = PreCardFlag
		Set obj.CTDCardAccountRelation = CardAccountRelation	
		Set obj.CTDCardFareCost = CardFareCost
		
		Set obj.CTDReadCardMode = ReadCardMode
		Set obj.CTDCardNoLength = CardNoLength
		Set obj.CTDSecurityNoFlag = SecrityNoFlag
		
		Set obj.CTDINVPRTXMLName = INVPRTXMLName
		Set obj.CTDPatPageXMLName = PatPageXMLName
		Set obj.CTDStChangeValidateFlag =StChangeValidateFlag
		
		Set obj.CTDSearchCardNoMode = SearchCardNoMode
		Set obj.CTDCardNamePlateStr = CardNamePlateStr
		Set obj.CTDValidateMode =ValidateMode
		Set obj.CTDSupportLossFlag = SupportLossFlag
		Set obj.CTDSupportExChangeFlag = SupportExChangeFlag
		Set obj.CTDSupportFillFlag =SupportFillFlag
		Set obj.CTDUsePANoToCardNO=UsePANoToCardNO
		Set obj.CTDCardPayNeedCheckFlag=CardPayNeedCheckFlag
		
		Set sc = obj.%Save()
		
		Set sc = obj.%Close()
		if ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set rtn="105"
		}
		
		if (+clr= 0)
		{
			&sql(update SQLUser.DHC_CardTypeDef Set CTD_HardCom_DR=null Where CTD_RowId = :RowId)			
			If (%ROWCOUNT =0 ) Set rtn=SQLCODE
			
			if (+rtn = 0)
			{
				&sql(update SQLUser.DHC_CardTypeDef Set CTD_BarCodeCom_DR=null Where CTD_RowId = :RowId)
				If (%ROWCOUNT =0 ) Set rtn=SQLCODE
			}
		}
		elseif (+clr = 1)
		{
			&sql(update SQLUser.DHC_CardTypeDef Set CTD_BarCodeCom_DR=null Where CTD_RowId = :RowId)
			If (%ROWCOUNT =0 ) Set rtn=SQLCODE	
		}
		elseif (+clr = 2)
		{
			&sql(update SQLUser.DHC_CardTypeDef Set CTD_HardCom_DR=null Where CTD_RowId = :RowId)			
			If (%ROWCOUNT =0 ) Set rtn=SQLCODE	
		}
		
		if ($System.Status.IsError(sc))
		{
			Do $System.Status.DisplayError(sc)
			Set rtn="105"
		}
	}
	Set ^zjtest = RowId_">"_clr_":"_HardComDR _ "^" _ BarCodeDR_"^"_rtn
	Quit +rtn
}

/// 读卡设备Query
Query CardEquipmentQuery(Name As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CCM_DESC,CCM_RowID FROM  SQLUser.DHC_CardHardComManager
	WHERE (CCM_ComGroup_DR in (SELECT CCG_RowID FROM SQLUser.DHC_CardHardComGroup
								WHERE CCG_TYPE='CE'	) and ((CCM_DateTo is null) or (CCM_DateTo>=+$H))
			)
}

/// 条形码设备Query
Query BarCodeEquipmentQuery(Name As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT CCM_DESC,CCM_RowID FROM  SQLUser.DHC_CardHardComManager
	WHERE (CCM_ComGroup_DR in (SELECT CCG_RowID FROM SQLUser.DHC_CardHardComGroup
								WHERE CCG_TYPE='BC'	) and ((CCM_DateTo is null) or (CCM_DateTo>=+$H))
		)
}

/// 卡类型列表Query
Query SelectByDesc(Code As %String, Desc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTD_RowID,CTD_Code,CTD_Desc,CTD_FareType,CTD_PrtINVFlag,
CTD_UseINVType,CTD_CardFareCost,CTD_ReclaimFlag,CTD_DefaultFlag,
CTD_DateFrom,CTD_DateTo,CTD_ActiveFlag,CTD_HardCom_DR,CTD_BarCodeCom_DR,
CTD_HardCom_DR->CCM_Desc AS HardComName,CTD_BarCodeCom_DR->CCM_Desc As BarCodeName,
CTD_ActiveFlag,CTD_ReadCardMode,CTD_CardNoLength,CTD_SecurityNoFlag,CTD_ReadCardFocusElement,
CTD_PANoCardRefFlag,CTD_CardRefFocusElement,CTD_OverWriteFlag,CTD_SearchMasFlag,
CTD_SetFocusElement,CTD_PreCardFlag,CTD_CardAccountRelation,CTD_CardFareCost,
CTD_INVPRTXMLName,CTD_PatPageXMLName,CTD_StChangeValidateFlag,
CTD_SearchCardNoMode,CTD_CardNamePlateStr,CTD_ValidateMode,
CTD_SupportLossFlag,CTD_SupportExChangeFlag,CTD_SupportFillFlag,CTD_UsePANoToCardNO,CTD_CardPayNeedCheckFlag

 FROM SQLUser.DHC_CardTypeDef
 WHERE ((CTD_Code %StartsWith :Code)  AND (CTD_Desc %StartsWith :Desc) )
}

/// 根据卡ID找到卡类型信息
Query SelectByRowID(RowID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTD_RowID,CTD_Code,CTD_Desc,CTD_FareType,CTD_PrtINVFlag,
CTD_UseINVType,CTD_CardFareCost,CTD_ReclaimFlag,CTD_DefaultFlag,
CTD_DateFrom,CTD_DateTo,CTD_ActiveFlag,CTD_HardCom_DR,CTD_BarCodeCom_DR
 FROM SQLUser.DHC_CardTypeDef
 WHERE ((CTD_RowID = :RowID))
}

ClassMethod EquipmentBroker(itemjs As %String, itemjsex As %String, val As %String)
{
	Set CEName = ""	
	Set CERowId = ""
	Set js = ""
	&SQL(SELECT CCM_RowId,CCM_DESC into :CERowId , :CEName FROM SQLUser.DHC_CardHardComManager
		WHERE (CCM_DESC %STARTSWITH :val)
		 )
	Set js = itemjs_"('"_$zcvt(CEName,"O","JS")_"');"
		 
	If (itemjsex '= "")
	{
		Set js = js_itemjsex_"('"_$zcvt(CERowId_"^"_CEName,"O","JS")_"');"	
	}

	&js<#(js)#>
}

/// 卡类型List
Query SelectAll(Desc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTD_RowID,CTD_Desc,CTD_HardCom_DR,CTD_BarCodeCom_DR,
CTD_HardCom_DR->CCM_Desc AS HardComName,CTD_BarCodeCom_DR->CCM_Desc As BarCodeName
 FROM SQLUser.DHC_CardTypeDef
 WHERE (CTD_Desc %StartsWith :Desc )
}

ClassMethod SelectCOM(RowID As %String) As %String
{
	Set ClassId = ""
	Set ObjectId = ""
	Set CodeBase = ""
	&Sql(Select CCM_CLASSID, CCM_OBJECTID,CCM_CodeBase into :ClassId,:ObjectId,:CodeBase
	From SQLUser.DHC_CardHardComManager
	WHERE (CCM_RowID = :RowID)
	)
	
	Quit ClassId _ "^"_ObjectId_"^"_CodeBase
}

Query XMLPConfigQuery(Name As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "模板名称:%String")
{
	SELECT XPC_Flag FROM SQLUser.DHC_XMLPConfig
	WHERE (XPC_Flag %StartsWith :Name)
}

// w ##class(web.DHCBL.CARD.CardTypeDef).InsertByJson(^dhcInsertByJson)

/// {"CTDCode":"124","CTDDesc":"124","CTDPrtINVFlag":"Y","CTDFareType":"","CTDUseINVType":"I","CTDReclaimFlag":"Y","CTDDateFrom":"2018-08-08","CTDDateTo":"","CTDDefaultFlag":"Y","CTDHardComDR":"","CTDBarCodeComDR":"","CTDActiveFlag":"Y","CTDReadCardFocusElement":"PAPMINo","CTDCardRefFocusElement":"","CTDOverWriteFlag":"","CTDPANoCardRefFlag":"","CTDSearchMasFlag":"","CTDSetFocusElement":"","CTDPreCardFlag":"","CTDCardAccountRelation":"","CTDCardFareCost":"","CTDReadCardMode":"Read","CTDCardNoLength":"","CTDSecurityNoFlag":"Y","CTDINVPRTXMLName":"","CTDPatPageXMLName":"","CTDStChangeValidateFlag":"","CTDSearchCardNoMode":"","CTDCardNamePlateStr":"1421","CTDValidateMode":"","CTDSupportLossFlag":"Y","CTDSupportExChangeFlag":"Y","CTDSupportFillFlag":"Y","CTDUsePANoToCardNO":"Y","CTDCardPayNeedCheckFlag":"Y"}
ClassMethod InsertByJson(JsonStr As %String)
{
	n (JsonStr)
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	if (jsonObj.CTDDefaultFlag="Y")
	{
		&sql(update SQLUser.DHC_CardTypeDef set CTD_DefaultFlag='N')
		If ((+SQLCODE '=0 )&&(+SQLCODE'=100)) quit 200
	}
	//Set obj = ##class(User.DHCCardTypeDef).%New()
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardTypeDef")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
	}
	b ;434
	if '$d(PLIST) Quit -1
	&sql(insert into SQLUSER.DHC_CardTypeDef values :PLIST())
	
	
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardTypeDef).GetCardTypeDataJson(17,^dhcGetCardTypeDataJson,"User.DHCCardTypeDef")
ClassMethod GetCardTypeDataJson(RowId As %String, jsonFiledStr As %String, ClassDesc As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	s ^dhcGetCardTypeDataJsonName=ClassDesc_","_RowId
	if RowId=""{
		//s CardObj=$System.OBJ.New(UserName)	
		s CardObj=$ZOBJCLASSMETHOD(ClassDesc,"%New")
	}else{
		s CardObj=$ZOBJCLASSMETHOD(ClassDesc,"%OpenId",RowId)
	}
	
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(ClassDesc)
	s myCount = myobj.Properties.Count()
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		s dataType=mypropobj.Type
		continue:jsonFiled.%GetTypeOf(PropertyName)="unassigned" 
		if $e(dataType,1)'="%"{
			s val=$ZOBJMETHOD(CardObj,PropertyName_"GetObjectId")
		}else{
			s val=$PROPERTY(CardObj,PropertyName)
			if dataType="%Library.Date"{
				s val=..%ZD(val)
			}	
		}
		s filedName=jsonFiled.%Get(PropertyName)
		do jsonData.%Set(filedName,val)
        if (PropertyName="CTDCredTypeListStr"){
            s CTDCredTypeListDesc=""
            for Len=1:1:$l(val,","){
                s CredTypeID=$p(val,",",Len)
                Continue:CredTypeID=""
                s CredTypeDesc=$p($g(^PAC("CARD",CredTypeID)),"^",2)
                i CTDCredTypeListDesc="" s CTDCredTypeListDesc=CredTypeDesc
                e  s CTDCredTypeListDesc=CTDCredTypeListDesc_","_CredTypeDesc
            }
            do jsonData.%Set("CredTypeList",CTDCredTypeListDesc)
        }
	}
	
	Quit jsonData.%ToJSON()
}

ClassMethod SaveByJson(CardTypeId As %String, JsonStr As %String, HospID = "")
{
	n (CardTypeId,JsonStr,HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_CardTypeDef",HospID)
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	
	if (jsonObj.CTDDefaultFlag="Y")
	{
		&sql(update SQLUser.DHC_CardTypeDef set CTD_DefaultFlag='N')
		If ((+SQLCODE '=0 )&&(+SQLCODE'=100)) quit 200
	}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardTypeDef")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
	}
	if '$d(PLIST) Quit -1
	if CardTypeId=""{
		&sql(insert into SQLUSER.DHC_CardTypeDef values :PLIST())
		if 'SQLCODE{
			d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_CardTypeDef",$p(%ROWID,$c(1)),HospID)
		}
	}else{
		&sql(update SQLUSER.DHC_CardTypeDef values :PLIST() where CTD_RowID=:CardTypeId)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardTypeDef).GetCardTypes()
ClassMethod GetCardTypes(Code As %String, Desc As %String, HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s rowJson=[]
	s num=0
	s id=0
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCCardTypeDef")
	s myCount = myobj.Properties.Count()
	for{
		s id=$o(^DHCCARDTYPEDef(id))
		Quit:id=""
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",id,HospID)
		s CardCode=$p(^DHCCARDTYPEDef(id),"^",1)
		s CardDesc=$p(^DHCCARDTYPEDef(id),"^",2)
		continue:(CardCode'="")&&(CardCode'[Code)
		continue:(CardDesc'="")&&(CardDesc'[Desc)
		s num=num+1
		k PLIST
		&sql(select * into :PLIST() from SQLUSER.DHC_CardTypeDef where CTD_RowID=:id)
		s oneCardTyeJson={}
		s SqlRowIdName=myobj.SqlRowIdName
		s val=""""_id_""""
		s @("oneCardTyeJson."_"RowId"_"="_val)
		f i=1:1:myCount {
			s mypropobj=myobj.Properties.GetAt(i)
			s PropertyName=mypropobj.Name
			s dataType=mypropobj.Type
			s sqlNum=mypropobj.SqlColumnNumber
			continue:sqlNum=""
			s val=$g(PLIST(sqlNum))
			if dataType="%Library.Date"{
				s val=..%ZD(val)
			}
			s val=""""_val_""""
			s @("oneCardTyeJson."_PropertyName_"="_val)
		}	
		do rowJson.%Push(oneCardTyeJson)
	}
	s resultJson={}
	s resultJson.rows=rowJson
	s resultJson.total=num
	Quit resultJson.%ToJSON()
}

ClassMethod SaveCardTypeSet(SetStr As %String, HospId As %String)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s SearchCardNoMode=$p(SetStr,"^",1)
	s AllowAgeNoCreadCard=$p(SetStr,"^",2)
	s CanNoCread=$p(SetStr,"^",3)
	s ForeignInfoByAge=$p(SetStr,"^",4)
	s BuildAddrHomeByIDCard=$p(SetStr,"^",5)
	s BuildAddrBirthByIDCard=$p(SetStr,"^",6)
	s BuildAddrLookUpByIDCard=$p(SetStr,"^",7)
	s BuildAddrHouseByIDCard=$p(SetStr,"^",8)
	s LimitBirthTimeByAge=$p(SetStr,"^",9)
	s AddrDefType=$p(SetStr,"^",10)
	s DefaultSex=$p(SetStr,"^",11)
	s AutoFillUnitInfo=$p(SetStr,"^",12)
	s ret=##class(web.DHCDocConfig).SaveConfig2("SearchCardNoModeConfig",SearchCardNoMode,HospId)
	
	s ^DHCDocCardConfig(HospCodeNode,"AllowAgeNoCreadCard")=AllowAgeNoCreadCard
	
	s ^DHCDocCardConfig(HospCodeNode,"NOCREAD")=CanNoCread
	
	s ^DHCDocCardConfig(HospCodeNode,"ForeignInfoByAge")=ForeignInfoByAge
	
	s ^DHCDocCardConfig(HospCodeNode,"BuildAddrHomeByIDCard")=BuildAddrHomeByIDCard
	
	s ^DHCDocCardConfig(HospCodeNode,"BuildAddrBirthByIDCard")=BuildAddrBirthByIDCard
	
	s ^DHCDocCardConfig(HospCodeNode,"BuildAddrLookUpByIDCard")=BuildAddrLookUpByIDCard
	
	s ^DHCDocCardConfig(HospCodeNode,"LimitBirthTimeByAge")=LimitBirthTimeByAge
	
	s ^DHCDocCardConfig(HospCodeNode,"BuildAddrHouseByIDCard")=BuildAddrHouseByIDCard
	s ^DHCDocCardConfig(HospCodeNode,"ADDRTYPEDef")=AddrDefType
	s ^DHCDocCardConfig(HospCodeNode,"DefaultSex")=DefaultSex
	s ^DHCDocCardConfig(HospCodeNode,"AutoFillUnitInfo")=AutoFillUnitInfo
	Quit 0
}

ClassMethod GetCardTypeSet(HospId As %String)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s SearchCardNoMode=##class(web.DHCDocConfig).GetConfigNodeNew2("SearchCardNoModeConfig",HospId)
	s ^Tempscl("GetCardTypeSet")=HospId_","_HospCodeNode
	s AllowAgeNoCreadCard=$g(^DHCDocCardConfig(HospCodeNode,"AllowAgeNoCreadCard"))
	s CanNoCread=$g(^DHCDocCardConfig(HospCodeNode,"NOCREAD"))
	s ForeignInfoByAge=$g(^DHCDocCardConfig(HospCodeNode,"ForeignInfoByAge"))
	s BuildAddrHomeByIDCard=$g(^DHCDocCardConfig(HospCodeNode,"BuildAddrHomeByIDCard"))
	s BuildAddrBirthByIDCard=$g(^DHCDocCardConfig(HospCodeNode,"BuildAddrBirthByIDCard"))
	s BuildAddrLookUpByIDCard=$g(^DHCDocCardConfig(HospCodeNode,"BuildAddrLookUpByIDCard"))
	s BuildAddrHouseByIDCard=$g(^DHCDocCardConfig(HospCodeNode,"BuildAddrHouseByIDCard"))
	s LimitBirthTimeByAge=$g(^DHCDocCardConfig(HospCodeNode,"LimitBirthTimeByAge"))
	s AutoFillUnitInfo=$g(^DHCDocCardConfig(HospCodeNode,"AutoFillUnitInfo"))
	Quit SearchCardNoMode_"^"_AllowAgeNoCreadCard_"^"_CanNoCread_"^"_ForeignInfoByAge_"^"_BuildAddrHomeByIDCard_"^"_BuildAddrBirthByIDCard_"^"_BuildAddrLookUpByIDCard_"^"_BuildAddrHouseByIDCard_"^"_LimitBirthTimeByAge_"^"_AutoFillUnitInfo
}

/// create 20200925 by yuanlei
/// 建卡界面基础数据排序
ClassMethod SaveSortItemSet(SetStr As %String, HospId As %String) As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	
	s SortNation=$p(SetStr,"^",1)
	s SortMarital=$p(SetStr,"^",2)
	s SortOccupation=$p(SetStr,"^",3)
	s SortRelation=$p(SetStr,"^",4)
	
	
	s ^DHCDocCardConfig(HospCodeNode,"SortNation")=SortNation
	s ^DHCDocCardConfig(HospCodeNode,"SortMarital")=SortMarital
	s ^DHCDocCardConfig(HospCodeNode,"SortOccupation")=SortOccupation
	s ^DHCDocCardConfig(HospCodeNode,"SortRelation")=SortRelation
	
	q 0
}

ClassMethod GetSortItemSet(HospId As %String) As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	
	s SortNation=$g(^DHCDocCardConfig(HospCodeNode,"SortNation"))
	s SortMarital=$g(^DHCDocCardConfig(HospCodeNode,"SortMarital"))
	s SortOccupation=$g(^DHCDocCardConfig(HospCodeNode,"SortOccupation"))
	s SortRelation=$g(^DHCDocCardConfig(HospCodeNode,"SortRelation"))
	
	s OutStr=SortNation_"^"_SortMarital_"^"_SortOccupation_"^"_SortRelation
	
	q OutStr
}

/// w ##class(web.DHCBL.CARD.CardTypeDef).GetAddrDefTypeJson(2)
ClassMethod GetAddrDefTypeJson(HospId As %String)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s AddrDef=$G(^DHCDocCardConfig(HospCodeNode,"ADDRTYPEDef"))
	s json="["
	s OneJsonData="{""text"":"""_"出生"_""",""id"":"""_"出生"""_""
	i AddrDef["出生" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_OneJsonData
	
	s OneJsonData="{""text"":"""_"现住"_""",""id"":"""_"现住"""_""
	i AddrDef["现住" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	
	s OneJsonData="{""text"":"""_"户口"_""",""id"":"""_"户口"""_""
	i AddrDef["户口" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	
	s json=json_"]"  
	q json
}

ClassMethod GetAddrDefTypeJsonNew(HospId As %String)
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s AddrDef=$G(^DHCDocCardConfig(HospCodeNode,"ADDRTYPEDef"))
	s json="["
	s OneJsonData="{""Value"":"""_"出生"_""",""Desc"":"""_"出生"""_""
	i AddrDef["出生" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_OneJsonData
	
	s OneJsonData="{""Value"":"""_"现住"_""",""Desc"":"""_"现住"""_""
	i AddrDef["现住" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	
	s OneJsonData="{""Value"":"""_"户口"_""",""Desc"":"""_"户口"""_""
	i AddrDef["户口" s OneJsonData=OneJsonData_",""selected"":true"
	s OneJsonData=OneJsonData_"}"
	s json=json_","_OneJsonData
	
	s json=json_"]"  
	q json
}

}
