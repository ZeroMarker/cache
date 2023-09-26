/// 名称:DHCMed.EPDService.InitRepLoadSrv
/// 描述: 初始化报告加载数据服务（主要解决报告加载慢的问题）
/// 编写者：zhufei
/// 编写日期: 2019-09-26
Class DHCMed.EPDService.InitRepLoadSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2019-09-26
/// Description:  共用加载初始化报告数据方法
/// Table：       无
/// Input：       pList:    参数列表
/// Return：      %String
/// d ##class(DHCMed.EPDService.InitRepLoadSrv).LoadInitRepData(pList)
ClassMethod LoadInitRepData(pList) As %String
{
	New (pList)
	Set return="[]"
	
	Set ResultStr=""
	Set xInd=0,Cnt=0
	For {
		Set xInd=$o(pList(xInd))
		Quit:xInd=""
		
		Set xArgs=$g(pList(xInd))
		
		Set Cnt=Cnt+1
		Set Method = $p(xArgs,"!!",1)
		Set Arg1   = $p(xArgs,"!!",2)
		Set Arg2   = $p(xArgs,"!!",3)
		Set Arg3   = $p(xArgs,"!!",4)
		Set Arg4   = $p(xArgs,"!!",5)
		Set Arg5   = $p(xArgs,"!!",6)
		Set Arg6   = $p(xArgs,"!!",7)
		Set Arg7   = $p(xArgs,"!!",8)
		Set Arg8   = $p(xArgs,"!!",9)
		Set Arg9   = $p(xArgs,"!!",10)
		
		Set DataValue=""
		If Method="GetConfigInfo" {
			Set DataValue=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Arg1,"")
		} ElseIf Method="GetDictionary" {
			Set DicCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Arg2,"")
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(Arg1,DicCode,1)
			If $IsObject(objDic){
				Set DataValue=objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
			}
		} ElseIf Method="GetAreaInfo" {
			Set AreaIds=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Arg1,"")
			Continue:AreaIds=""
			For indA=1:1:$l(AreaIds,"`") {
				Set tAreaId=+$p(AreaIds,"`",indA)
				Set tAreaDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(tAreaId)
				If DataValue'="" {
					Set DataValue=DataValue_"`"_tAreaId_"^"_tAreaDesc
				} Else {
					Set DataValue=tAreaId_"^"_tAreaDesc
				}
			}
		} Else {
			Set DataValue=""
		}
		Set rResult=""""_$zcvt(DataValue,"O","JSON")_""""
		
		If ResultStr'="" {
			Set ResultStr=ResultStr_","_rResult
		} Else {
			Set ResultStr=rResult
		}
	}
	Set return="["_ResultStr_"]"
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-10-09
/// Description:  获取患者就诊信息
/// Table：       PA_Adm
/// Input：       
/// Return：      %String
/// w ##class(DHCMed.EPDService.InitRepLoadSrv).GetPatInfo(362)
ClassMethod GetPatInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID,%session)
	Set return=""
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	//患者基本信息
	Set AdmInfo=$g(^PAADM(aEpisodeID))
	Set PatientID=$p(AdmInfo,"^",1)
	Set AdmType=$p(AdmInfo,"^",2)	
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set Sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	//Set Sex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",Sex,langid)
	Set:Sex'="" Sex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,Sex)
	Set BirthDay=$p($g(^PAPER(PatientID,"ALL")),"^",6)	
	Set BirthDay=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BirthDay)	
	Set MrNo = ##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(aEpisodeID,AdmType,"")
	Set CardInfo = ##class(DHCMed.EPDService.CommonSrv).GetActiveCardNo(PatientID)
	If ($p(CardInfo,"^",2)="") {
		Set (xCardTypeDicID,objMap,MapCardTypeID,MapCardTypeCode,MapCardType,CardType,CardNumber)=""
		Set CardNumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)  //证件号
		Set CardTypeDr=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)  
		Set CardType=$p($g(^PAC("CARD",+CardTypeDr)),"^",2)     //证件类型
		If (CardType'="")&&(CardNumber'="") { 		
		 	Set MapTypeDr = $o(^CT.MA.Util.BT.DicTypeMapI("IndexMapPro"," HISCTPACCARDTYPE"," EPD",0))
		    Set:MapTypeDr'="" xCardTypeDicID = $o(^CF.MA.Util.BT.DictionaryMapI("IndexMapDicDesc",MapTypeDr,CardType,0))
			Set objMap = ##class(DHCMA.Util.BT.DictionaryMap).GetObjById(xCardTypeDicID)
			If $IsObject(objMap)&&(objMap.MapDicDr) {
				Set MapCardTypeID = objMap.MapDicDr.%Id()
				Set MapCardTypeCode = objMap.MapDicDr.Code
				Set MapCardType = objMap.MapDicDr.Description
			}
		}
		Set:(MapCardTypeCode'="")&&(MapCardType'="") CardInfo =MapCardTypeCode_"^"_CardNumber_"^"_MapCardType
	}
	if (CardInfo'=""){
		Set CardInfo = $p(CardInfo,"^",1)_"^"_$p(CardInfo,"^",2)_"^"_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,$p(CardInfo,"^",3))
	}
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,aEpisodeID,AdmDate,AdmTime)	//返回值为“*岁*月*天”
	Set AgeNumber = +Age
	Set AgeUnit = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,$p(Age,AgeNumber,2))
	Set Age = AgeNumber_AgeUnit
	Set AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set AdmTime=$zt(AdmTime,1)		
	Set PatEncrypt=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,"")	
	Set EncryptLevel=$p(PatEncrypt,"^",1)
	Set PatLevel=$p(PatEncrypt,"^",2)
	Set EncryptLevelDesc=$p(PatEncrypt,"^",4)
	
	Set LocID=+$p(AdmInfo,"^",4)
	Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)	
	Set WardID=+$p(AdmInfo,"^",70)
    Set Ward=$p($g(^PAWARD(+$p(AdmInfo,"^",70))),"^",2)
    
    Set Nation=""
    Set NationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
    Set:NationDr'="" Nation=$p(^CT("NAT",+NationDr),"^",2) 
    
    Set return=PapmiNo_"^"_MrNo_"^"_PatientName_"^"_Sex_"^"_Age_"^"_BirthDay_"^"_Nation_"^"_CardInfo_"^"_AdmType_"^"_AdmDate_"^"_AdmTime_"^"_EncryptLevel_"^"_PatLevel_"^"_LocID_"^"_LocDesc_"^"_WardID_"^"_Ward_"^"_EncryptLevelDesc

	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-10-16
/// Description:  根据参数配置获取字典
/// Table：       
/// Input：       
/// Return：      %String
/// w ##class(DHCMed.EPDService.InitRepLoadSrv).GetDictionary("GetDictionary!!EpdInitIntimateKey!!EpidemicContact")
ClassMethod GetDictionary(aConfigList As %String) As %String
{
	New (aConfigList,%session)
	Set return=""
	Set Method = $p(aConfigList,"!!",1)
	Set Config = $p(aConfigList,"!!",2)
	Set Dictionary = $p(aConfigList,"!!",3)
	Set HospID=""
	Set:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	Set DataValue= ""
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	//基础字典
	If Method="GetDictionary" {
		Set DicCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Config,HospID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(Dictionary,DicCode,1)
		If $IsObject(objDic){
			Set DataValue=objDic.%Id()_"^"_objDic.Code_"^"_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,objDic.Description)
		}
	} ElseIf Method="GetAreaInfo" {  //省市详细
		Set AreaIds=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Config,HospID)
		Quit:AreaIds="" return
		For indA=1:1:$l(AreaIds,"`") {
			Set tAreaId=+$p(AreaIds,"`",indA)
			Set tAreaDesc=##class(DHCMed.EPD.AreaDic).GetShordDescById(tAreaId)
			If DataValue'="" {
				Set DataValue=DataValue_"`"_tAreaId_"^"_tAreaDesc
			} Else {
				Set DataValue=tAreaId_"^"_tAreaDesc
			}
		}
	} Else {
		Set DataValue=""
	}
	Set return = DataValue
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-29
/// Description:  通过地址获取省市县乡
/// Table：       DHCMed.EPD.AreaDic
/// Input：       地址
/// Return：      拆分的字典项
/// w ##class(DHCMed.EPDService.InitRepLoadSrv).GetAddress("北京市北京市辖区东城区")
ClassMethod GetAddress(Address As %String) As %String
{
	New (Address,%session)
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Set Address=$tr(Address," ","")
	Quit:Address="" return
	
	Set (ProvinceDr,ProvinceDesc)=""
	Set (CityDr,CityDesc)=""
	Set (CountyDr,CountyDesc)=""
	Set (VillageDr,VillageDesc,VillageTxt)=""
	
	//省匹配
	Set ParentCode=""
	For indProvince=1:1:99 {
		Set ProvinceCode=indProvince
		Set:$l(ProvinceCode)<2 ProvinceCode="0"_ProvinceCode
		
		Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_"000000",0))
		Continue:ID=""
		Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
		Continue:'$IsObject(obj)
		Set IsActive=obj.IsActive
		Continue:IsActive'=1
		Set ShortDesc=obj.ShortDesc
		Set ShortDesc=$tr(ShortDesc," ","")
		If $e(Address,1,$l(ShortDesc))=ShortDesc {
			Set ProvinceDr=ID
			Set ProvinceDesc=ShortDesc
			Set ProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,ProvinceDesc)	
			Set ParentCode=ProvinceCode
			Quit
		} Else {
			Set ShortDesc2=ShortDesc
			If $e(ShortDesc2,*,*)="省" {
				Set ShortDesc2=$e(ShortDesc2,1,*-1)
			} ElseIf $e(ShortDesc2,*,*)="市" {
				Set ShortDesc2=$e(ShortDesc2,1,*-1)
			}
			If $e(Address,1,$l(ShortDesc2))=ShortDesc2 {
				Set ProvinceDr=ID
				Set ProvinceDesc=ShortDesc
				Set ProvinceDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,ProvinceDesc)
				Set ParentCode=ProvinceCode
				Quit
			}
		}
	}
	//市匹配，省允许为空
	For indProvince=1:1:99 {
		Set ProvinceCode=indProvince
		Set:$l(ProvinceCode)<2 ProvinceCode="0"_ProvinceCode
		Continue:($l(ParentCode)>=2)&&($e(ParentCode,1,2)'=ProvinceCode)
		
		For indCity=1:1:99 {
			Set CityCode=indCity
			Set:$l(CityCode)<2 CityCode="0"_CityCode
			
			Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_"0000",0))
			Continue:ID=""
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			Continue:'$IsObject(obj)
			Set IsActive=obj.IsActive
			Continue:IsActive'=1
			Set ShortDesc=obj.ShortDesc
			Set ShortDesc=$tr(ShortDesc," ","")
			
			If (Address[ShortDesc) {
				Set CityDr=ID
				Set CityDesc=ShortDesc
				Set CityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,CityDesc)
				Set ParentCode=ProvinceCode_CityCode
				Set Address=$p(Address,ShortDesc,2)
				Quit
			} Else {
				Set ShortDesc2=ShortDesc
				If $e(ShortDesc2,*,*)="市" {
					Set ShortDesc2=$e(ShortDesc2,1,*-1)
				} ElseIf $e(ShortDesc2,*,*)="区" {
					Set ShortDesc2=$e(ShortDesc2,1,*-1)
				}
				If Address[ShortDesc2 {
					Set CityDr=ID
					Set CityDesc=ShortDesc
					Set CityDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,CityDesc)
					Set ParentCode=ProvinceCode_CityCode
					Set Address=$p(Address,ShortDesc2,2)
					Quit
				}
			}
		}
	}
	If (CityDr'="")&&(ProvinceDr="") {
		Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_$e(ParentCode,1,2)_"000000",0))
		If ID'="" {
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			If $IsObject(obj){
				Set ProvinceDr=ID
				Set ProvinceDesc=obj.ShortDesc
			}
		}
	}
	//县匹配，省不允许为空，市允许为空
	If ProvinceDr'="" {
		Set ProvinceCode=$e(ParentCode,1,2)
		For indCity=1:1:99 {
			Set CityCode=indCity
			Set:$l(CityCode)<2 CityCode="0"_CityCode
			//Continue:($l(ParentCode)>=4)&&($e(ParentCode,3,4)'=CityCode)
			
			For indCounty=1:1:99 {
				Set CountyCode=indCounty
				Set:$l(CountyCode)<2 CountyCode="0"_CountyCode
				
				Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_CountyCode_"00",0))
				Continue:ID=""
				Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
				Continue:'$IsObject(obj)
				Set IsActive=obj.IsActive
				Continue:IsActive'=1
				Set ShortDesc=obj.ShortDesc
				Set ShortDesc=$tr(ShortDesc," ","")
				
				If (Address[ShortDesc) {
					Set CountyDr=ID
					Set CountyDesc=ShortDesc
					Set CountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,CountyDesc)
					Set ParentCode=ProvinceCode_CityCode_CountyCode
					Set Address=$p(Address,ShortDesc,2)
					Quit
				} Else {
					Set ShortDesc2=ShortDesc
					If $e(ShortDesc2,*,*)="市" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					} ElseIf $e(ShortDesc2,*,*)="区" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					} ElseIf $e(ShortDesc2,*,*)="县" {
						Set ShortDesc2=$e(ShortDesc2,1,*-1)
					}
					If Address[ShortDesc2 {
						Set CountyDr=ID
						Set CountyDesc=ShortDesc
						Set CountyDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,CountyDesc)
						Set ParentCode=ProvinceCode_CityCode_CountyCode
						Set Address=$p(Address,ShortDesc2,2)
						Quit
					}
				}
			}
		}
	}
	If (CountyDr'="") {
		Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_$e(ParentCode,1,4)_"0000",0))
		If ID'="" {
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			If $IsObject(obj){
				Set CityDr=ID
				Set CityDesc=obj.ShortDesc
			}
		}
	}
	//乡匹配，省市县都不允许为空
	If CountyDr'="" {
		Set ProvinceCode=$e(ParentCode,1,2)
		Set CityCode=$e(ParentCode,3,4)
		Set CountyCode=$e(ParentCode,5,6)
		For indVillage=1:1:99 {
			Set VillageCode=indVillage
			Set:$l(VillageCode)<2 VillageCode="0"_VillageCode
			
			Set ID=$o(^DHCMed.EPDCi("AREADIC","CodeIndex"," "_ProvinceCode_CityCode_CountyCode_VillageCode,0))
			Continue:ID=""
			Set obj=##Class(DHCMed.EPD.AreaDic).GetObjById(ID)
			Continue:'$IsObject(obj)
			Set IsActive=obj.IsActive
			Continue:IsActive'=1
			Set ShortDesc=obj.ShortDesc
			Set ShortDesc=$tr(ShortDesc," ","")
			Set ShortDesc2=ShortDesc
			If ShortDesc2["乡" {
				Set ShortDesc2=$e(ShortDesc2,1,*-1)
			} ElseIf ShortDesc2["镇" {
				Set ShortDesc2=$e(ShortDesc2,1,*-1)
			} ElseIf ShortDesc2["街道" {
				Set ShortDesc2=$e(ShortDesc2,1,*-2)
			} ElseIf ShortDesc2["社区" {
				Set ShortDesc2=$e(ShortDesc2,1,*-2)
			} ElseIf ShortDesc2["办事处" {
				Set ShortDesc2=$e(ShortDesc2,1,*-3)
			}
			
			If (Address[ShortDesc) {
				Set VillageDr=ID
				Set VillageDesc=ShortDesc
				Set VillageDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,VillageDesc)
				Set VillageTxt=$p(Address,ShortDesc,2)
				Quit
			} ElseIf Address[ShortDesc2 {
				Set VillageDr=ID
				Set VillageDesc=ShortDesc
				Set VillageDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,VillageDesc)
				Set VillageTxt=$p(Address,ShortDesc2,2)
				Quit
			} Else {}
		}
	}

	Set return=ProvinceDr_"^"_ProvinceDesc_"`"_CityDr_"^"_CityDesc_"`"_CountyDr_"^"_CountyDesc_"`"_VillageDr_"^"_VillageDesc_"`"_VillageTxt   //输出与参数配置保持一致
	Quit return
}

}
