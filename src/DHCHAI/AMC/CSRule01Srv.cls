/// 名称: DHCHAI.AMC.CSRule01Srv
/// 描述: 疑似病例筛查规则--检出致病菌
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.AMC.CSRule01Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRule01Srv).GetResult("检出致病菌",9,.arr)
ClassMethod GetResult(aItmScreen As %String, aEpisodeID As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aItmScreen,aEpisodeID,%ArrayResult)
	Set return=0
	Quit:(aItmScreen="")||(aEpisodeID="") return
	Quit:'$IsObject(%ArrayResult) return
	
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjByDesc(aItmScreen)
	Quit:'$IsObject(objItmScreen) return
	Quit:objItmScreen.CCIsActive'=1 return
	Set ItmScreenID=objItmScreen.%Id()
	Set ItmScreenDesc=objItmScreen.CCDesc
	Set:objItmScreen.CCDesc2'="" ItmScreenDesc=objItmScreen.CCDesc2
	Set KeyWords=objItmScreen.CCKeyWords
	
	Kill arrResult
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-Bacteria"  //检验-检出菌
		
		Set xBacteria=""
		For {
			Set xBacteria=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID,xBacteria))
			Quit:xBacteria=""
			Continue:$l(xBacteria)<2 //表示菌为空
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrBacteria",aEpisodeID,xItemID,xBacteria,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set Bacteria=obj.CCBacteria
				Continue:Bacteria=""  //细菌
				
				Set SCode=obj.CCSCode
				Set Specimen=obj.CCSpecimen
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				If $IsObject(objBactMap){
					Continue:objBactMap.BTIsActive'=1
					If $IsObject(objBactMap.BTMapItemDr){
						Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
					}
				}
				Continue:Bacteria=""
				
				//多耐
				Set MRBTypeID="",MRBTypeDesc=""
				If $IsObject(obj.CCMRBTpDr) {
					Set MRBTypeID=obj.CCMRBTpDr.%Id()
					Set MRBTypeDesc=obj.CCMRBTpDr.BTDesc
				}
				If MRBTypeID'="" {
					Set arrResult(Bacteria,"MRB",MRBTypeID)=MRBTypeDesc
				}
				
				Set objStanSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objStanSpec){
					Set Specimen=objStanSpec.BTSpecDesc
					Set:Specimen'="" arrResult(Bacteria,"INF",Specimen)=""
					//是否无菌部位
					If $IsObject(objStanSpec.BTPropertyDr){
						Set SpecProperty=objStanSpec.BTPropertyDr.BTDesc
						If SpecProperty["无菌部位" {
							Set arrResult(Bacteria,"TSAb")=1
						}
					}
				}
				
				Set arrResult(Bacteria,"Rst",ActDate,xID)=$lb(xID,Specimen,Bacteria,ActDate,MRBType,IsSterile)
				
				//判断是否入院48小时后项目
				Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
				Set arrResult(Bacteria,"48H",ActDate,+flg)=""
			}
		}
	}
	Quit:$o(arrResult(0))="" return
	
	Set xBacteria=""
	For {
		Set xBacteria=$o(arrResult(xBacteria))
		Quit:xBacteria=""
		
		//触发次数
		Set SuInfDates=##Class(%ListOfDataTypes).%New()
		Set ResultCnt=0,ResultIDs="",SpecimenList=""
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xBacteria,"Rst",xActDate))
			Quit:xActDate=""
			
			Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
			Set IsO48Hour=$d(arrResult(xActDate,"48H",1))
			Set SuInfData=$lb(xActDate,IsI48Hour,IsO48Hour,xActDate,xActDate)
			Do SuInfDates.Insert(SuInfData)
			
			Set xID=0
			For {
				Set xID=$o(arrResult(xBacteria,"Rst",xActDate,xID))
				Quit:xID=""
				Set ResultCnt=ResultCnt+1
				
				Set tResult=$g(arrResult(xBacteria,"Rst",xActDate,xID))
				Set Specimen=$list(tResult,2)
				If $listfind(SpecimenList,Specimen)<1 {
					Set SpecimenList=SpecimenList_$lb(Specimen)
				}
			}
		}
		Continue:ResultCnt<1
		Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(SpecimenList,"、")
		
		//非无菌部位检出菌，需要检查常规检验异常值
		If $g(arrResult(Bacteria,"TSAb"))'=1 {
			Set IsCheckTSAb=1
			Set IsCheckSx=1
			Set IsCheckFe=1
		} Else {
			Set IsCheckTSAb=0
			Set IsCheckSx=0
			Set IsCheckFe=0
		}
		
		//多耐菌分类
		Set MRBType=""
		Set xMRBTypeID=""
		For {
			Set xMRBTypeID=$o(arrResult(xBacteria,"MRB",xMRBTypeID))
			Quit:xMRBTypeID=""
			Set MRBType=MRBType_","_$g(arrResult(xBacteria,"MRB",xMRBTypeID))
		}
		Set:MRBType'="" MRBType=$e(MRBType,2,$l(MRBType))
		
		//疑似诊断关键词
		Set InfSuKeys=""
		Set xSpec=""
		For {
			Set xSpec=$o(arrResult(xBacteria,"INF",xSpec))
			Quit:xSpec=""
			Set InfSuKeys=InfSuKeys_"^"_xSpec
		}
		Set:InfSuKeys'="" InfSuKeys=$e(InfSuKeys,2,$l(InfSuKeys))
		
		Set ResultNote=$s(MRBType'="":"【多耐】"_xBacteria,1:xBacteria)
		Set:SpecimenStr'="" ResultNote=ResultNote_" （"_SpecimenStr_"）"
		Set FromDate=$o(arrResult(xBacteria,"Rst",0))
		Set ToDate=$o(arrResult(xBacteria,"Rst",""),-1)
		If FromDate=ToDate {
			//Set ResultDate=$zd(FromDate,3)
			Set ResultDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)
		} Else {
			//Set ResultDate=$zd(FromDate,3)_"～"_$zd(ToDate,3)
			Set ResultDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)_"～"_##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ToDate)
		}
		
		Set ItmScreenTxt=xBacteria
		Set RstFromDate=FromDate
		Set RstToDate=ToDate
		
		Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenID)
		Continue:'$IsObject(obj)
		Set obj.CSItmScreenTxt = ItmScreenTxt
		Set obj.CSResultNote   = ResultNote
		Set obj.CSResultDate   = ResultDate
		Set obj.CSResultCnt    = ResultCnt
		Set obj.CSRstFromDate  = RstFromDate
		Set obj.CSRstToDate    = RstToDate
		Set obj.CSInfSuKeys    = InfSuKeys
		Set obj.CSSuInfDates   = SuInfDates  //疑似感染日期（日期区间）
		Set obj.CSIsCheckSx    = IsCheckSx   //是否检查阳性症状或体征
		Set obj.CSIsCheckFe    = IsCheckFe   //是否检查发热
		Set obj.CSIsCheckTSAb  = IsCheckTSAb //是否检查常规检验异常
		
		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
	}
	Kill arrResult
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
