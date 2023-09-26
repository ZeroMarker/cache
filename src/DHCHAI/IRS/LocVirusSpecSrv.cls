/// 名称: DHCHAI.IRS.LocVirusSpecSrv
/// 描述: 科室病毒阳性标本服务类
/// 编写者: zhoubo
/// 编写日期: 2022-12-29
Class DHCHAI.IRS.LocVirusSpecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-12-29
/// Description:  科室病毒阳性标本查询
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1：送检日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocID     : 科室/护理单元
///               aVirusTest : 病毒项目
///               aWarnHours : 入院72小时后触发
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.LocVirusSpecSrv","QryLocVirusSpecDtl","","1","2019-12-03","2022-05-26","","","","","")
Query QryLocVirusSpecDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatUnit As %String, aLocID As %String = "", aSpecDesc As %String = "", aVirusTest As %String = "", aAbFlag As %String = "", aWarnHours As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,VisitNumberDr:%String,EpisodeNo:%String,RecDate:%String,RepDate:%String,LabSpecimen:%String,AbTestDescList:%String,VirusItem:%String") [ SqlProc ]
{
}

ClassMethod QryLocVirusSpecDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatUnit As %String, aLocID As %String = "", aSpecDesc As %String = "", aVirusTest As %String = "", aAbFlag As %String = "", aWarnHours As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set NIndex="QryLocVirusSpecDtl"
    Set:aLocID="0" aLocID=""
    
    // Add by zhaoyj 2022-06-15 Global方式
	Set ItemID=$o(^DHCHAI.IR.CCItmMastI("IdxofCode","LAB-TestAb",0))
	Set ItemData=$g(^DHCHAI.IR.CCItmMastD(ItemID))
	Quit:ItemData="" $$$OK
	Set CCIsActive=$lg(ItemData,4)
	Quit:CCIsActive'=1 $$$OK
	Set ItemDr=ItemID
	
	Kill ^TMP($zn,$j,NIndex)
    //送检日期
    If aDateType=1{ // 接收日期时间索引
		Set xSCode =""
		For {
			Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode))
			Quit:xSCode=""
			
			For xDate = aDateFrom:1:aDateTo{		
				Set xTime = ""
				For {
					Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime))
					Quit:xTime=""
					Set xVisitNumberDr=""
					For {
						Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime",xSCode,xDate,xTime,xVisitNumberDr))
						Quit:xVisitNumberDr=""
						
						Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
						Continue:VisitData=""
						Set LabIsActive = $lg(VisitData,18)
						Continue:LabIsActive'=1
		
						Do BuildVirusDtl(xVisitNumberDr)
					}
				}
			}
		}
	} Else { //报告日期
		For xDate = aDateFrom:1:aDateTo{		
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
				Quit:xTime=""
				
				Set xReportDr=""
				For {
					Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xReportDr))
					Quit:xReportDr=""
					
					Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xReportDr))
					Continue:LabReportData=""				
					Set VisitNumberDr = $lg(LabReportData,2)
					Set LabIsActive		=$lg(LabReportData,18)
					Continue:LabIsActive'=1
						
					Do BuildVirusDtl(VisitNumberDr)
	    
				}
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildVirusDtl(xVisitNumberDr)
	
	Set VisitNumberData  = $g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
	Quit:VisitNumberData=""
	Set EpisodeDr =$lg(VisitNumberData,2)
	Set EpisodeNo =$lg(VisitNumberData,3)
	Set LabSpecimen = $lg(VisitNumberData,6)
	Set LabSCode    = $lg(VisitNumberData,14)
	Set CollDate    = $lg(VisitNumberData,8)
	Set CollTime    = $lg(VisitNumberData,9)
	Set RecDate     = $lg(VisitNumberData,11)
	Set RecTime     = $lg(VisitNumberData,12)
	Set:CollDate="" CollDate=RecDate
	Set:CollTime="" CollTime=RecTime
	
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
	Quit:PAAdmData="" 
	Set AdmDate = $lg(PAAdmData,20)
	Set AdmTime = $lg(PAAdmData,21)
	Set Hours = ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime(AdmDate,AdmTime,CollDate,CollTime)
	Quit:(aWarnHours'="")&&(Hours<aWarnHours)
	Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
	Quit:SpecMapID=""
	Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
	Quit:SpecMapData=""
	Set BTMapItemDr = $lg(SpecMapData,3)
	Quit:BTMapItemDr=""
	Quit:(aSpecID'="")&&(aSpecID'=BTMapItemDr) //标本过滤
	Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))
	Set SpecDesc=""
	Set:SpecData'="" SpecDesc = $lg(SpecData,3)
	Set:SpecDesc'="" LabSpecimen=SpecDesc
	Quit:(aSpecDesc'="")&&(aSpecDesc'=LabSpecimen)
	Set ActLocDr  = $lg(VisitNumberData,7)    // 送检科室
	Set LabWardDr  = $lg(VisitNumberData,19)  // 送检病区
	If (aStatUnit=1){ // 按照病区统计
		 Set ActLocDr=LabWardDr
		 If (ActLocDr=""){
		 	Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,CollDate,CollTime)
			Set ActLocDr = $p(TransInfo,"^",2)
		 }

	}
	Quit:ActLocDr=""
	Quit:(aLocID'="")&(aLocID'=ActLocDr)
	Set LabLocData  = $g(^DHCHAI.BT.LocationD(ActLocDr))
	Quit:LabLocData=""
	Set HospDr = $lg(LabLocData,8)
	Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) //医院过滤
	
	Set VirusFlg =0          //生化免疫检测标志
	Set VirusItem=""
	Set xTestSetDesc = ""
	For {
		Set xTestSetDesc = $o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xVisitNumberDr,xTestSetDesc))
		Quit:xTestSetDesc=""
		Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,xTestSetDesc,0))
		if (TestSetMapID'=""){
			Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
			Continue:TestSetMapData=""
			Continue:'$lg(TestSetMapData,7) 		//无效判断
			Set TSMapItemDr=$lg(TestSetMapData,4)
			Set TSMapItemData=""
			Set:TSMapItemDr'="" TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(TSMapItemDr))		
			If (TSMapItemData'="") {    //检验医嘱对照
				Continue:'$lg(TSMapItemData,5)	//无效判断
				Set MapTSCode=$lg(TSMapItemData,2)
				Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))
				Set MapTSDesc = $lg(TSMapItemData,3)
				
				Set TestSetCatDr = $lg(TSMapItemData,4)
				Set LabTestSetCatData=""
				Set:TestSetCatDr'="" LabTestSetCatData = $g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))
				If (LabTestSetCatData'="") {
					Set MapTSCatDesc=$lg(LabTestSetCatData,3)
					Set:MapTSCatDesc="生化免疫检测" VirusFlg =1  	//update 20211129  病毒支原体检测修改为生化免疫检测
					Set VirusItem = MapTSDesc
					Quit
				}	
			}				
		}
	}
	If (VirusFlg=0) {  //检查检验项目是否存在于检验结果中
		Set xTestSetDr=""
		For {
			Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
			Quit:xTestSetDr=""
			Quit:VirusFlg=1
			
			//最新检验报告
			Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
			Quit:xOrder=""
			Set xVisitReportDr=0
			For {
				Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
				Quit:xVisitReportDr=""
				Quit:VirusFlg=1
				
				Set xTestCode=""
				For {
					Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
					Quit:xTestCode=""
					Quit:VirusFlg=1
				 
					Set xMapItemDr=0
					For {
						Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
						Quit:xMapItemDr=""
						
						Set TSMapItemData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
						Continue:TSMapItemData=""	  //检验医嘱对照
						Continue:'$lg(TSMapItemData,5)	//无效判断
						Set TestSet	= $lg(TSMapItemData,3)					
						Set VirusItem = TestSet				
						Set MapTSCode=$lg(TSMapItemData,2)
						Continue:(aVirusTest'="")&((","_aVirusTest_",")'[(","_MapTSCode_","))					
						Set TestSetCatDr=$lg(TSMapItemData,4)
						Continue:TestSetCatDr=""
						Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
						Continue:TestSetCatData=""
						Set MapTSCatDesc = $lg(TestSetCatData,3)
						Set:(MapTSCatDesc="生化免疫检测") VirusFlg=1   	//update 20211129  病毒支原体检测修改为生化免疫检测
						Quit														
					}
				}
			}
		}
	}
	Quit:VirusFlg=0	  //过滤非指定类型的送检
    
	Set IsAbFlag =0    //是否异常结果	
	Set AbTestDescList=""
	Set xActDate=0
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:IsAbFlag=1

		Set xRstID=0
		For {
			Set xRstID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",EpisodeDr,ItemDr,xActDate,xRstID))
			Quit:xRstID=""
			Set RstData = $g(^DHCHAI.IR.CCResultD(xRstID))
			Continue:RstData=""
			Continue:$lg(RstData,14)'=1
			Continue:$lg(RstData,21)'=1
			Set LabResultID=$p($lg(RstData,19),"=",2)
				
			Set RepRstData = $g(^DHCHAI.DP.LabVisitRepResultD(LabResultID))
			Continue:RepRstData=""
			Set LabReportDr      = $lg(RepRstData,2)
			Set TestDesc         = $lg(RepRstData,3)
			Continue:LabReportDr=""
			Set LabReportData    = $g(^DHCHAI.DP.LabVisitReportD(LabReportDr))
			Continue:LabReportData=""
			Set LabVisitNumberDr = $lg(LabReportData,2)
			Continue:LabVisitNumberDr=""
			Set:LabVisitNumberDr=xVisitNumberDr IsAbFlag=1
			If (IsAbFlag=1) {
				Set AbTestDescList=AbTestDescList_","_TestDesc	
			}		
			Quit	
		}
	}	
	Set:AbTestDescList'="" AbTestDescList=$e(AbTestDescList,2,$l(AbTestDescList))	
	Quit:(aAbFlag'="")&&(aAbFlag'=IsAbFlag)
	Set RepDate =""
	Set xTestSetDr=""
	For {
		Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr))
		Quit:xTestSetDr=""
	    Quit:RepDate'=""
	    
		//最新检验报告
		Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,""),-1)
		Quit:xOrder=""
		Set xVisitReportDr=0
		For {
			Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumberDr,xTestSetDr,xOrder,xVisitReportDr))
			Quit:xVisitReportDr=""
			
			Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xVisitReportDr))
			Continue:LabReportData=""
			Set RepDate = $lg(LabReportData,10)
			Quit:RepDate'=""
		}
	}
	//患者转科基本信息
	Set PatData =..BuildPaadmData(EpisodeDr)
	Quit:PatData=""
	Set:RecDate'="" RecDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RecDate)
	Set:RepDate'="" RepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
		
	Set ^CacheTemp(repid,ind)=PatData_$lb(xVisitNumberDr,EpisodeNo,RecDate,RepDate,LabSpecimen,AbTestDescList,VirusItem)
	Set ind=ind+1
	
	Quit
}

ClassMethod QryLocVirusSpecDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocVirusSpecDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocVirusSpecDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocVirusSpecDtlExecute ]
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

/// add by zhoub
/// 2019-10-23
/// 共用取病人信息方法，输出列和内容不要动！否则维度统计报表信息会混乱
ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	new (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set PAAdmData=$g(^DHCHAI.DP.PAAdmD(aEpisodeID))
	Quit:PAAdmData="" return
	
	Set EpisodeIDx = $lg(PAAdmData,2)
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = $lg(PAAdmData,3)
	Set PapmiNo = $lg(PAAdmData,4)
	Set MrNo = $lg(PAAdmData,5)
	Set PatName = $lg(PAAdmData,6)
	Set Sex = $lg(PAAdmData,7)
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = $lg(PAAdmData,37)
	Set AdmType = $lg(PAAdmData,18)
	
	// O门诊、E急诊、EP急诊留观、I住院
	If AdmType="I"{
		Set AdmType="住院"
	}ElseIf AdmType="O" {
		Set AdmType="门诊"
	}ElseIf AdmType="E" {
		Set AdmType="急诊"
	}ElseIf AdmType="EP" {
		Set AdmType="急诊留观"
	}
	
	Set VisitStatus = $lg(PAAdmData,19)
	Set VisitStatus = $s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="C":"退院",VisitStatus="P":"预住院",VisitStatus="U":"作废",1:"")
	Set AdmDate = $lg(PAAdmData,20)
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = $lg(PAAdmData,21)
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set TransData=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,AdmDate,AdmTime)  //换成取第一个科室、病区 ？？？？
	Quit:TransData="" return
	
	//Set AdmLocDr = $li(PAAdmData,22)
	Set AdmLocDr = $p(TransData,"^",1)
	Set:AdmLocDr="" AdmLocDr = $lg(PAAdmData,22)   //update20211009 处理急诊留观没有转科科室情况
	Set AdmLocDesc=""
	Set LocData = $g(^DHCHAI.BT.LocationD(AdmLocDr))
	If LocData'="" {
		Set LocDesc2 = $lg(LocData,4)
		Set LocDesc  = $lg(LocData,3)
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	
	//Set AdmWardDr = +$li(PAAdmData,23)
	Set AdmWardDr = $p(TransData,"^",2)
	Set:AdmWardDr="" AdmWardDr = $lg(PAAdmData,23)   //update20211009 处理急诊留观没有转科科室情况
	Set WardData = $g(^DHCHAI.BT.LocationD(AdmWardDr))
	Set AdmWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $lg(WardData,4)
		Set WardDesc  = $lg(WardData,3)
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	Set AdmRoom  = $lg(PAAdmData,24)
	Set AdmBedDr = $lg(PAAdmData,25)
	Set AdmBedData=""
	Set AdmBed=""
	If (AdmBedDr'="") {
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
		If AdmBedData'="" {
			Set AdmBed = $lg(AdmBedData,3)
		}
	}
	Set DischDate = $lg(PAAdmData,26)
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = $lg(PAAdmData,27)
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set DischLocDr = $lg(PAAdmData,28)
    Set LocData=""
    If (DischLocDr'="") {
    	Set LocData = $g(^DHCHAI.BT.LocationD(DischLocDr))
    }
	Set DischLocDesc=""
	If LocData'="" {
		Set LocDesc2 = $lg(LocData,4)
		Set LocDesc  = $lg(LocData,3)
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set DischWardDr = $lg(PAAdmData,29)
	Set WardData=""
    If (DischWardDr'="") {
    	Set WardData = $g(^DHCHAI.BT.LocationD(DischWardDr))
    }
	Set DischWardDesc=""
	If WardData'="" {
		Set WardDesc2 = $lg(WardData,4)
		Set WardDesc  = $lg(WardData,3)
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime
	
	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

}
