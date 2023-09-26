/// 名称：DHCMA.Util.BTS.DictionaryMapSrv
/// 描述：基础字典对照服务
/// 编写者：pylian
/// 编写日期: 2020-04-07
Class DHCMA.Util.BTS.DictionaryMapSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-04-07
/// Description:  查询基础字典项目
/// Table：       DHCMed.SS.DictionaryMap、DHCMA.Util.BT.DicTypeMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.DictionaryMapSrv","QryDicMap","71")
Query QryDicMap(aDicTypeID As %String, aAlias As %String = "") As %Query(ROWSPEC = "DicID:%String,Code:%String,Desc:%String,IsActive:%String,IsActDesc:%String,DicType:%String,DicTypeDesc:%String,Product:%String,MapID:%String,MapDicDesc:%String,MapDicTypeID:%String") [ SqlProc ]
{
}

ClassMethod QryDicMapExecute(ByRef qHandle As %Binary, aDicTypeID As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aDicTypeID="" $$$OK
	
	Set DicTypeCode = $lg(^DHCMA.Util.BT.DicTypeD(aDicTypeID),2)
	Set xID = ""
	For {
		Set xID = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapType"," "_$ZCVT(DicTypeCode,"U"),xID))
		Quit:xID=""
		
		Set objMapType = ##class(DHCMA.Util.BT.DicTypeMap).GetObjById(xID)
		Continue:'$Isobject(objMapType)
		
		Set Product = objMapType.MapProduct
		Set DicType = objMapType.MapProDicType
	
	    Set DicTypeID = $o(^DHCMed.SS.DictionaryI("IndexTypeCode"," SYS"," "_$ZCVT(DicType,"U"),0))
	    Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicTypeID)
	    Continue:'$Isobject(objDic)
	   
	    Set DicTypeDesc = objDic.Description
	   	Set xDicID =""
	   	For {	   	
	   		Set xDicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT(DicType,"U"),xDicID))
	   		Quit:xDicID=""
			
			Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xDicID)
	   	 	Continue:'$Isobject(objDic)
	   	 	
	   	 	Set Code = objDic.Code
	    	Set Desc = objDic.Description
	 		Set IsActive = objDic.Active
        	Set IsActDesc=$s(IsActive=1:"是",1:"否")
            
            
            Set xMapID ="",MapDicDesc="",MapDicTypeID=""
            If ($d(^CF.MA.Util.BT.DictionaryMapI("IndexMapDic",xID,xDicID))) {	           
			   	For {	   	
			   		Set xMapID=$o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDic",xID,xDicID,xMapID))
			   		Quit:xMapID=""    
	        		
	        		Set objMap=##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xMapID)
	        	 	Continue:'$Isobject(objMap) 
	        	 	Continue:'$Isobject(objMap.MapDicTypeDr) 
	        		Set MapDicDesc = objMap.MapDicDesc
	        		Set MapDicTypeID = objMap.MapDicTypeDr.%Id()
	        		Continue:(aAlias'="")&&(Desc'[aAlias)&&(aAlias'[Desc)&&(MapDicDesc'[aAlias)&&(aAlias'[MapDicDesc)
	        		
	        		Set Data = $lb(xDicID,Code,Desc,IsActive,IsActDesc,DicType,DicTypeDesc,Product,xMapID,MapDicDesc,MapDicTypeID)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
			   	}
            }Else {	 
           		Continue:(aAlias'="")&&(Desc'[aAlias)&&(aAlias'[Desc)
	        	Set Data = $lb(xDicID,Code,Desc,IsActive,IsActDesc,DicType,DicTypeDesc,Product,xMapID,MapDicDesc,MapDicTypeID)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
            }

	   	}
	}
	Quit $$$OK
}

ClassMethod QryDicMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDicMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicMapExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator     : pylian
/// CreatDate   : 2020-05-28
/// Description : 获取患者基础字典对照结果
/// Table       : DHCMA.Util.BT.DictionaryMap
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMA.Util.BTS.DictionaryMapSrv).GetDicInfo("5","DTH")
ClassMethod GetDicInfo(aEpisodeID As %String, aProductCode As %String) As %String
{
	New (aEpisodeID,aProductCode,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:(aEpisodeID="")||(aProductCode="") return
	
	Set aProductCode = $ZCVT(aProductCode,"U")
	//患者基本信息
	Set AdmInfo=$g(^PAADM(aEpisodeID))
	Set PatientID=$p(AdmInfo,"^",1)
	
    //性别
    Set (xSexDicID,objMap,MapSexID,MapSexCode,MapSex,Sex)=""
    Set SexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	Set:SexDr'="" Sex=$p($g(^CT("SEX",+SexDr)),"^",2)
	If (Sex'="") {
		Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTSEX"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xSexDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Sex,0))
	    Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xSexDicID)
	    If $IsObject(objMap)&&(objMap.MapDicDr) {
		    Set MapSexID = objMap.MapDicDr.%Id()
		    Set MapSexCode = objMap.MapDicDr.Code
		    Set MapSex = objMap.MapDicDr.Description
	    }
	}
    //民族
    Set (xNationDicID,objMap,MapNationID,MapNationCode,MapNation,Nation)=""
    Set NationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
    Set:NationDr'="" Nation=$p(^CT("NAT",+NationDr),"^",2) 
    If (Nation'="") {
	    Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTNATION"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xNationDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Nation,0))
	    Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xNationDicID)
	    If $IsObject(objMap)&&(objMap.MapDicDr) {
		    Set MapNationID = objMap.MapDicDr.%Id()
		    Set MapNationCode = objMap.MapDicDr.Code
		    Set MapNation = objMap.MapDicDr.Description
		    Set MapNation = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,MapNation)	
	    }
    }
    //国籍
    Set (xCountryDicID,objMap,MapCountryID,MapCountryCode,MapCountry,Country)=""
    Set CountryDr=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
    Set:CountryDr'="" Country=$p(^CT("COU",+CountryDr),"^",2) 
    If (Country'="") {
	    Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTCOUNTRY"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xCountryDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Country,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xCountryDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapCountryID = objMap.MapDicDr.%Id()
			Set MapCountryCode = objMap.MapDicDr.Code
			Set MapCountry = objMap.MapDicDr.Description
			Set MapCountry=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCountry","CTCOUDesc",Languages,MapCountry)
		}
    }
    
    //HISCTOccupation	职业字典
	Set (xOccupationDicID,objMap,MapOccupationID,MapOccupationCode,MapOccupation,Occupation)=""
	Set OccupationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
	Set:OccupationDr'="" Occupation=$p(^CT("OCC",+OccupationDr),"^",2)  
	If (Occupation'="") {
		Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTOCCUPATION"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xOccupationDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Occupation,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xOccupationDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapOccupationID = objMap.MapDicDr.%Id()
			Set MapOccupationCode = objMap.MapDicDr.Code
			Set MapOccupation = objMap.MapDicDr.Description
		}
	}
	
    //HISCTMarital	婚姻字典
	Set (xMaritalDicID,objMap,MapMaritalID,MapMaritalCode,MapMarital,Marital)=""
	Set MaritalDr=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
	Set:MaritalDr'="" Marital=$p(^CT("MAR",+MaritalDr),"^",2)  
	If (Marital'="") {
		Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTMARITAL"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xMaritalDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Marital,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xMaritalDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapMaritalID = objMap.MapDicDr.%Id()
			Set MapMaritalCode = objMap.MapDicDr.Code
			Set MapMarital = objMap.MapDicDr.Description
		}
	}
	
	//HISCTEducation	学历字典
	Set (xEducationDicID,objMap,MapEducationID,MapEducationCode,MapEducation,Education)=""
	Set EducationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",5)
	Set:EducationDr'="" Education=$p(^CT("EDU",+EducationDr),"^",2)  
	If (Education'="") {
		Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTEDUCATION"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xEducationDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Education,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xEducationDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapEducationID = objMap.MapDicDr.%Id()
			Set MapEducationCode = objMap.MapDicDr.Code
			Set MapEducation = objMap.MapDicDr.Description
		}
	}
	
	//HISCTSocialStatus	医疗付费方式
	Set (xSocialStatusDicID,objMap,MapSocialStatusID,MapSocialStatusCode,MapSocialStatus,SocialStatus)=""
	Set SocialStatusDr=$p($g(^PAPER(PatientID,"PER",1)),"^",10)
	Set:SocialStatusDr'="" SocialStatus=$p(^CT("SS",+SocialStatusDr),"^",2)  
	If (SocialStatus'="") {
		Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTSOCIALSTATUS"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xSocialStatusDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,SocialStatus,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xSocialStatusDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapSocialStatusID = objMap.MapDicDr.%Id()
			Set MapSocialStatusCode = objMap.MapDicDr.Code
			Set MapSocialStatus = objMap.MapDicDr.Description
		}
	}
	//关系
	Set (xRelationDicID,objMap,MapRelationID,MapRelationCode,MapRelation,Relation)=""
	Set RelationDr=$p($g(^PAPER(PatientID,"EMP")),"^",4)
	Set:RelationDr'="" Relation=$p(^CT("RLT",+RelationDr),"^",2) 
	If (Relation'="") { 
	 	Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTRELATION"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xRelationDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,Relation,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xRelationDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapRelationID = objMap.MapDicDr.%Id()
			Set MapRelationCode = objMap.MapDicDr.Code
			Set MapRelation = objMap.MapDicDr.Description
		}
	}
	//证件类型
	Set (xCardTypeDicID,objMap,MapCardTypeID,MapCardTypeCode,MapCardType,CardType,CardNumber)=""
	Set CardTypeDr=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	Set:CardTypeDr'="" CardType=$p(^PAC("CARD",+CardTypeDr),"^",2)
	If (CardType'="") { 
		Set CardNumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)  
	 	Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISPACCARDTYPE"," "_$ZCVT(aProductCode,"U"),0))
	    Set:MapTypeDr'="" xCardTypeDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,CardType,0))
		Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xCardTypeDicID)
		If $IsObject(objMap)&&(objMap.MapDicDr) {
			Set MapCardTypeID = objMap.MapDicDr.%Id()
			Set MapCardTypeCode = objMap.MapDicDr.Code
			Set MapCardType = objMap.MapDicDr.Description
		}
	}
	
	Set return =MapSexID_","_MapSexCode_","_MapSex_"^"_MapNationID_","_MapNationCode_","_MapNation_"^"_MapCountryID_","_MapCountryCode_","_MapCountry_"^"_MapOccupationID_","_MapOccupationCode_","_MapOccupation_"^"_MapMaritalID_","_MapMaritalCode_","_MapMarital_"^"_MapEducationID_","_MapEducationCode_","_MapEducation_"^"_MapSocialStatusID_","_MapSocialStatusCode_","_MapSocialStatus_"^"_MapRelationID_","_MapRelationCode_","_MapRelation_"^"_MapCardTypeID_","_MapCardTypeCode_","_MapCardType_","_CardNumber

	Quit return
}

}
