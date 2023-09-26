/// 名称: DHCHAI.IRC.CSRule13Srv
/// 描述: 疑似病例筛查规则--诊断血流感染
/// 编写者：zhufei
/// 编写日期: 2018-03-14
Class DHCHAI.IRC.CSRule13Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule13Srv).GetResult("诊断血流感染",452,.arr)
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
	Set KeyWords=objItmScreen.CCKeyWords  //血流感染
	Set Arg1=objItmScreen.CCArg1  //检出1次的菌
	Set Arg2=objItmScreen.CCArg2  //24H检出2次以上菌
	If Arg1'="" {
		Set Arg1=$tr(Arg1,"^","、")
		Set Arg1=$tr(Arg1,"|","、")
		Set Arg1=$tr(Arg1,",","、")
		Set Arg1=$tr(Arg1,"，","、")
		Set Arg1=##class(DHCHAI.Utils.CommonSrv).ListFromString(Arg1,"、")
	}
	If Arg2'="" {
		Set Arg2=$tr(Arg2,"^","、")
		Set Arg2=$tr(Arg2,"|","、")
		Set Arg2=$tr(Arg2,",","、")
		Set Arg2=$tr(Arg2,"，","、")
		Set Arg2=##class(DHCHAI.Utils.CommonSrv).ListFromString(Arg2,"、")
	}
	
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
				
				Set SCode=obj.CCSCode
				Set Specimen=obj.CCSpecimen
				Set Bacteria=obj.CCBacteria
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Continue:Specimen=""  //标本
				Continue:Bacteria=""  //细菌
				Continue:ActDate=""   //送检日期
				
				Set objStanSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objStanSpec){
					Continue:objStanSpec.BTIsActive'=1
					Set Specimen=objStanSpec.BTSpecDesc
				}
				Continue:Specimen'["血"
				
				Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				If $IsObject(objBactMap){
					Continue:objBactMap.BTIsActive'=1
					If $IsObject(objBactMap.BTMapItemDr){
						Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
					}
				}
				Continue:Bacteria=""
				
				If $listfind(Arg1,Bacteria)>0 {  //检出1次的菌
					Set arrResult(Bacteria,"Rst",ActDate,ActTime,xID)=$lb(xID,Specimen,Bacteria,ActDate,ActTime,1)
				} ElseIf $listfind(Arg2,Bacteria)>0 {  //24H检出2次以上菌
					Set arrResult(Bacteria,"Rst",ActDate,ActTime,xID)=$lb(xID,Specimen,Bacteria,ActDate,ActTime,2)
				}
				
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
		Set FromDate="",ToDate=""
		Set xActDate=""
		For {
			Set xActDate=$o(arrResult(xBacteria,"Rst",xActDate))
			Quit:xActDate=""
			
			Set IsI48Hour=$d(arrResult(xBacteria,"48H",xActDate,0))
			Set IsO48Hour=$d(arrResult(xBacteria,"48H",xActDate,1))
			Set SuInfData=$lb(xActDate,IsI48Hour,IsO48Hour,xActDate,xActDate)
			Do SuInfDates.Insert(SuInfData)
			
			Set xActTime=""
			For {
				Set xActTime=$o(arrResult(xBacteria,"Rst",xActDate,xActTime))
				Quit:xActTime=""
				
				Set pActDate=xActDate
				Set pActTime=$o(arrResult(xBacteria,"Rst",xActDate,xActTime),-1)
				If pActTime="" {
					Set pActDate=xActDate-1
					Set pActTime=$o(arrResult(xBacteria,"Rst",pActDate,""),-1)
				}
				
				Set xID=0
				For {
					Set xID=$o(arrResult(xBacteria,"Rst",xActDate,xActTime,xID))
					Quit:xID=""
					
					Set tResult=$g(arrResult(xBacteria,"Rst",xActDate,xActTime,xID))
					Continue:tResult=""
					Set Specimen=$listget(tResult,2)
					Set ActDate=$listget(tResult,4)
					Set ActTime=$listget(tResult,5)
					Set ActType=$listget(tResult,6)
					Set ActFlag=0
					If ActType=1 {
						Set ActFlag=1
					} ElseIf ActType=2 {
						If xActDate=pActDate {
							Set ActFlag=1
						} Else {
							Continue:pActTime=""
							Continue:(xActTime-pActTime)>0
							Set ActFlag=1
						}
					}
					Continue:ActFlag<1
					If $listfind(SpecimenList,Specimen)<1 {
						Set SpecimenList=SpecimenList_$lb(Specimen)
					}
					Set ResultCnt=ResultCnt+1
					Set:FromDate="" FromDate=ActDate
					Set ToDate=ActDate
				}
			}
		}
		Continue:ResultCnt<1
		Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(SpecimenList,"、")
		
		Set ResultNote="血流感染"_"-"_xBacteria
		Set:SpecimenStr'="" ResultNote=ResultNote_" （"_SpecimenStr_"）"
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
		Set InfSuKeys="血流感染"
		
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
		Set obj.CSIsCheckSx    = 0 //不检查阳性症状或体征
		
		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
	}
	Kill arrResult
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
