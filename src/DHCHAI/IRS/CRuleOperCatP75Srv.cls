/// 名称: DHCHAI.IRS.CRuleOperCatP75Srv
/// 描述: 手术分类75百分位相关服务
/// 编写者：pylian
/// 编写日期: 2021-09-29
Class DHCHAI.IRS.CRuleOperCatP75Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-09-29
/// Description:  获得手术分类75百分位手术时长
/// Table：       DHCHAI.IR.CRuleOperCatP75
/// Input：		  
/// Return：      
/// w ##Class(DHCHAI.IRS.CRuleOperCatP75Srv).GetOperCatP75("1","2020-11-03","1","")
ClassMethod GetOperCatP75(aOperCat As %String, aDate As %String, aHospID As %String = "", aHospGrpID As %String = "") As %String
{
	New (aOperCat,aDate,aHospID,aHospGrpID)
	Set return=""
    Quit:(aOperCat="")||(aDate="") return
    Set ToYM=""
    Set:aDate["-" ToYM =$p(aDate,"-",1)_"-"_$p(aDate,"-",2)
   
    Set xID=0
    If (aHospID'=""){
    	Set xID=$o(^MA.HAI.IR.CRuleOperCatP75I("IndexHOperCatDate",aOperCat,ToYM,aHospID,0))
    	Quit:xID="" return
	    Set OperCatP75Data=$g(^MA.HAI.IR.CRuleOperCatP75D(xID))
	    Quit:OperCatP75Data="" return
	    Set OperMin=$lg(OperCatP75Data,3)
	}Else {
		If ($d(^DHCHAI.IR.CRuleOperCatP75I("IndexGOperCatDate"))) {
			Set xID=$o(^MA.HAI.IR.CRuleOperCatP75I("IndexGOperCatDate",aOperCat,ToYM,aHospGrpID,0))
			Quit:xID="" return
		    Set OperCatP75Data=$g(^MA.HAI.IR.CRuleOperCatP75D(xID))
		    Quit:OperCatP75Data="" return
		    Set OperMin=$lg(OperCatP75Data,3)
		}
	 }  
   
   Set return=OperMin
   Quit return
}

/// 1.起止日期按月份计算，最终以每月最后一天75百分位为准
/// 2.多院区情况下，需区分医院，能够查询总院(只算总院，未算多医院组合情况)
/// 3.查询时段跨月的情况下，以结束日期所在月份为准
/// 4.对于新增的手术分类，自动任务不主动处理，之前数据不计75百分位中
/// Creator：     pylian
/// CreatDate：   2021-09-29
/// Description:  同步手术分类75百分位手术时长
/// Table：       DHCHAI.IR.CRuleOperCatP75
/// Input：		  
/// Return：      
/// w ##Class(DHCHAI.IRS.CRuleOperCatP75Srv).SyncOperCatP75("2020-11-03")
ClassMethod SyncOperCatP75(aDate As %String) As %String
{
	New (aDate)
	Set return=""
    Quit:(aDate="") return
    Set FromY="",FromM="", FromDate="", ToY="", ToM="",ToDate=aDate
    Set:aDate["-" ToY =$p(aDate,"-",1), ToM =+$p(aDate,"-",2)
    Set FromY=ToY,FromM=ToM+1
    Set:FromM<10 FromM="0"_FromM
    Set:(ToM-11)<1 FromY=ToY-1
    Set FromDate=FromY_"-"_FromM_"-"_"01"
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(FromDate)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Quit:(aDateFrom="")||(aDateTo="") return
    //Set ExclStatus=##class(DHCHAI.BT.Config).GetValByCode("OPSExclStatus")   //20211012 根据配置过滤手术状态

    //是否多个院区
    Set HospNum=0
    Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalD(xHospID))
		Quit:xHospID=""
		Set HospInfo=$g(^DHCHAI.BT.HospitalD(xHospID))
		Continue:$lg(HospInfo,7)'=1
		Set HospNum=HospNum+1
	}
	
   	K ^TMP($zn,$j)
   			
    Set xOperCatID=""
 	For {
		Set xOperCatID=$o(^CF.MA.HAI.IR.CRuleOperCatD(xOperCatID))
		Quit:xOperCatID=""
		
		For xDate=aDateFrom:1:aDateTo {
			Set xTime=""
			For {
	 			Set xTime=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime))
				Quit:xTime=""
				
				Set xOperLocDr=""
				For {
					Set xOperLocDr=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr))
					Quit:xOperLocDr=""
					
					//手术科室
					Set OperLocData = $g(^DHCHAI.BT.LocationD(xOperLocDr))
					Continue:OperLocData=""
					Set HospDr=$li(OperLocData,8)
					Continue:HospDr=""
					Set HospInfo="",HospGroupDr=""
					Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
					Set HospGroupDr=$lg(HospInfo,5)
					
					Set xID=""
					For {
			 			Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexOperDateTimeOperLoc",xDate,xTime,xOperLocDr,xID))
						Quit:xID=""
						
						Set AnaesData=$g(^DHCHAI.DP.OROperAnaesD(xID))
					 	Continue:AnaesData=""
					 	//过滤无效数据
					 	Set ORIsActive=$li(AnaesData,31)
					 	Continue:ORIsActive'=1
					 	//过滤手术状态
				 		Set OperStatus = $li(AnaesData,34) 	// 状态(A申请、F完成、D拒绝、R安排、L离室、N非预约、I术中、P恢复室、L离室、C取消)
						Set tOperStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue("OPS01","OperStatus",OperStatus)
						Set:tOperStatus'="" OperStatus=tOperStatus
					 	//Continue:"ADC"[OperStatus 
					 	//Continue:ExclStatus[OperStatus   //20211012 根据配置过滤手术状态

					    Set OperCatDrs = $lg(AnaesData,36)
						Continue:(","_OperCatDrs_",")'[(","_xOperCatID_",")
					
						Set OperDate    = $li(AnaesData,6)			// 手术开始日期
						Set ORSttTime   = $li(AnaesData,7)			// 手术开始时间
						Set OREndDate   = $li(AnaesData,8)			// 手术结束日期
						Set OREndTime   = $li(AnaesData,9)			// 手术结束时间
						
						Continue:(OperDate="")||(ORSttTime="")||(OREndDate="")||(OREndTime="")
						Set OperMin=(OREndDate-OperDate)*24*60+(OREndDate-OREndTime)   //手术时长转化为分钟
						
						Set ^TMP($zn,$j,"HospGrp",xOperCatID,HospGroupDr,OperMin,xID)=""
						Set num=$i(^TMP($zn,$j,"HospGrpCnt",xOperCatID))
				
						Set ^TMP($zn,$j,"Hosp",xOperCatID,HospDr,OperMin,xID)=""
						Set num=$i(^TMP($zn,$j,"HospCnt",xOperCatID,HospDr))
					}
				}
			}
		}
		
		If (HospNum>1) {   //多家院区情况
			Set HospGrpCnt=$g(^TMP($zn,$j,"HospGrpCnt",xOperCatID))
			Set P75=HospGrpCnt*0.75
			Set:P75'["." P75Next=P75+1
			Set:P75["." P75=$p(P75,".",1)+1,P75Next=P75

			Set GrpOperMin=""
			Set xHospGrpDr=""
			For {
				Set xHospGrpDr=$o(^TMP($zn,$j,"HospGrp",xOperCatID,xHospGrpDr))   
				Quit:xHospGrpDr=""			
				
				Set Num=0
				Set xOperMin=0
				For {
					Set xOperMin=$o(^TMP($zn,$j,"HospGrp",xOperCatID,xHospGrpDr,xOperMin))   
					Quit:xOperMin=""
					Set Num=Num+1
					Continue:(Num<P75)||(Num>P75Next)
					Set:Num=P75 GrpOperMin=+xOperMin
					Set:(P75Next'=P75)&&(Num=P75Next) GrpOperMin=(GrpOperMin+xOperMin)/2
				}
				
				Set InputStr=""
				Set InputStr=InputStr_"^"_xOperCatID
				Set InputStr=InputStr_"^"_GrpOperMin
				Set InputStr=InputStr_"^"_xHospGrpDr
				Set InputStr=InputStr_"^"_""		
				Set InputStr=InputStr_"^"_FromY_"-"_FromM
				Set InputStr=InputStr_"^"_ToY_"-"_ToM
				Set InputStr=InputStr_"^"_1
				
				Set ret=##class(DHCHAI.IR.CRuleOperCatP75).Update(InputStr,"^")
				If (+ret)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.IR.CRuleOperCatP75"
					Set ErrMethod = "Update"
					Set ErrArgStr = $lb(InputStr,"^")
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("",ErrClass,ErrMethod,ErrArgStr)
				}
			}
		}
		
		Set OperMin=""
		Set xHospDr=""
		For {
			Set xHospDr=$o(^TMP($zn,$j,"Hosp",xOperCatID,xHospDr))   
			Quit:xHospDr=""			
			
			Set HospCnt=$g(^TMP($zn,$j,"HospCnt",xOperCatID,xHospDr))
			Set P75=HospCnt*0.75
			Set:P75'["." P75Next=P75+1
			Set:P75["." P75=$p(P75,".",1)+1,P75Next=P75

			Set Num=0
			Set xOperMin=0
			For {
				Set xOperMin=$o(^TMP($zn,$j,"Hosp",xOperCatID,xHospDr,xOperMin))   
				Quit:xOperMin=""
				Set Num=Num+1
				Continue:(Num<P75)||(Num>P75Next)
				Set:Num=P75 OperMin=+xOperMin
				Set:(P75Next'=P75)&&(Num=P75Next) OperMin=(OperMin+xOperMin)/2
			}
			
			Set InputStr=""
			Set InputStr=InputStr_"^"_xOperCatID
			Set InputStr=InputStr_"^"_OperMin
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_xHospDr
			Set InputStr=InputStr_"^"_FromY_"-"_FromM
			Set InputStr=InputStr_"^"_ToY_"-"_ToM
			Set InputStr=InputStr_"^"_1
			
			Set ret=##class(DHCHAI.IR.CRuleOperCatP75).Update(InputStr,"^")
			If (+ret)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.IR.CRuleOperCatP75"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog("",ErrClass,ErrMethod,ErrArgStr)
			}
		}
 	}
	
	k ^TMP($zn,$j)		 	 
	Quit return
}

}
