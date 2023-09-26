/// 名称: web.DHCCPW.MR.ClinPathWaysStat
/// 描述: 临床路径统计
/// 编写者：李宇峰
/// 编写日期: 2010-07-13
Class web.DHCCPW.MR.ClinPathWaysStat Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// ***********************************************************
/// 临床路径出院统计 2010-11-13 Update By ZF
/// ***********************************************************
/// 
/// Creator：     李宇峰
/// CreatDate：   2010-07-13
/// Description:  取住院科室下，出院人数，入径人数，入径率，出院人数比，入径人数比，路径数，平均住院日，平均费用，入径病人平均住院日，入径病人平均费用。
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStat","QryDischStat","2010-11-01","2010-11-14")
Query QryDischStat(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "CtRowid:%Integer,CtDesc:%String,CTLOCNum:%String,pathWayPerson:%String,pathWayCtlocPercent:%String,CTLOPercent:%String,pathWayPercent:%String,pathWayNum:%String,CTLOCDayAverage:%String,CTLOCConstAverage:%String,pathDayAverage:%String,pathConstAverage:%String,NeedInPathCount:%String,ClosePathWayCount:%String,ClosePathWayRatio:%String,OutPathWayCount:%String,OutPathWayRation:%String")
{
}

ClassMethod QryDischStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	;Set:StartDate["/" StartDate=$zdh(StartDate,4)
	;Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set StartDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(StartDate)
	Set EndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EndDate)
	Set:StartDate'="" StartDate=+StartDate
	;Set:EndDate["/" EndDate=$zdh(EndDate,4)
	;Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate'="" EndDate=+EndDate
	Quit:(StartDate="")||(EndDate="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryDischStat")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set AdmNum=0,PathNum=0
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=StartDate:1:EndDate {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
			//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
			Set LocID=$p(AdmInfo,"^",4)     //就诊科室
			Continue:LocID=""
			
			//Set AdmitDate=$p(AdmInfo,"^",6)  //就诊日期
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
			Set AdmitDate=$p(AdmDateTime,"^",1)
			//Set DischDate=$p(AdmInfo,"^",17) //出院日期
			//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
			Set DischDate=$p(DischDateTime,"^",1)
				
		    If DischDate'="" {
			    Set AdmDays=DischDate-AdmitDate
		    } Else {
				Set AdmDays=+$h-AdmitDate    //住院天数
			}
			Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
			Set CountCost=+$p(strCost,"^",1)  //住院总费用
			Set MRAdm=$p(AdmInfo,"^",61)     //MRAdm
			
			Set AdmNum=AdmNum+1
			//科室出院人数
			Set num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmCount"))
			//科室病人住院总天数
			Set tmpDays=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmDays"))
			Set ^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmDays")=tmpDays+AdmDays
			//科室病人住院总费用
			Set tmpCost=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmCost"))
			Set ^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmCost")=tmpCost+CountCost
			
			
			Set (PathWayID,CPWID,CPWStatus)=""
			Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
			If PathWayID'="" {
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					;应入径人数  入径病人算到应入径人数里面
				    Set num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"NeedInPathCount"))  
				    ;w Paadm,!
					If $IsObject(objPathWay.CPWPathwayDR) {
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
				}
				
			}Else{
				//应入径人数  没入径但诊断符合的病人也算入应入径人数里面      wangcs 2012-09-13
			   ;^DHCMRi("CPWA",0,"IndexPaadm",77272,20)
			   Set NoticeCPWID=""
			   If ($d(^DHCMRi("CPWA",0,"IndexPaadm",Paadm))){
				 Set CPWAnalysisID=0
				 Set CPWAnalysisID=$o(^DHCMRi("CPWA",0,"IndexPaadm",Paadm,CPWAnalysisID))
				 If (CPWAnalysisID'=""){
					Set CPWAnalysisObj=##Class(User.DHCMRClinPathWayAnalysis).%OpenId(CPWAnalysisID)
					If ($IsObject(CPWAnalysisObj)){
						//Set:CPWAnalysisObj.CPWACPWDID'="" num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"NeedInPathCount"))  
						Set:CPWAnalysisObj.CPWACPWDID'="" NoticeCPWID=CPWAnalysisObj.CPWACPWDID
					}
				 }
			   }
			   Set CPWLog=##Class(web.DHCCPW.MR.ClinPathWayInPathLogSrv).GetLogByPaadm(Paadm,"")
			   Set:(NoticeCPWID="")&&(CPWLog'="") NoticeCPWID=$p(CPWLog,"^",8)
			   Set:NoticeCPWID'="" num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"NeedInPathCount"))
			}
			Continue:(PathWayID="")||(CPWID="")
			//科室入径人数
			Set num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"InPathWayCount"))     ;wangcs 2012-09-13
			Set:CPWStatus="O" num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"OutPathWayCount"))  ;wangcs 2012-09-13
			//Continue:CPWStatus'="C"
			Set PathNum=PathNum+1
			//科室完成人数
			Set num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"ClosePathWayCount"))   ;wangcs 2012-09-13
			//科室入径病人住院总天数
			Set tmpDays=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayDays"))
			Set ^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayDays")=tmpDays+AdmDays
			//科室入径病人住院总费用
			Set tmpCost=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayCost"))
			Set ^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayCost")=tmpCost+CountCost
			//入径病人实施路径
			If '$d(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayCPWID",CPWID)) {
				Set num=$i(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocCPWNum"))
				Set ^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayCPWID",CPWID)=""
			}
		}
	}
	Set (DischTotal,NeedInpathTotal,InpathTotal,ClosePathTotal,OutPathTotal,PathTotal,AdmDaysTotal,AdmCostTotal,ClosePathDaysOfTotal,ClosePathCostOfTotal)=0
	Set LocID=0
	For {
		Set LocID=$o(^TMP(ZIndex,JIndex,"QryDischStat",LocID))
		Quit:LocID=""
		Set LocDesc=$p(^CTLOC(LocID),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Set LocAdmCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmCount"))     //科室出院总人数
		Set DischTotal=+DischTotal+LocAdmCount   //计算出院总人数
		
		Set LocAdmDays=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmDays"))       //科室出院病人出院总天数
		Set AdmDaysTotal=+AdmDaysTotal+LocAdmDays //计算住院总天数
		
		Set LocAdmCost=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocAdmCost"))       //科室出院病人总费用
		Set AdmCostTotal=+AdmCostTotal+LocAdmCost //计算出院病人总费用
		
		Set LocCPWNum=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"LocCPWNum"))         //科室路径数量
		Set PathTotal=+PathTotal+LocCPWNum       //计算路径总数
		
		;Set ClosePathWayCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"ClosePathWayCount")) //科室完成路径总人数
		Set PathWayDays=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayDays"))     //科室完成路径病人总住院天数
		Set ClosePathDaysOfTotal=+ClosePathDaysOfTotal+PathWayDays  //计算完成路径总住院天数
		
		Set PathWayCost=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"PathWayCost"))     //科室完成路径病人总费用
		Set ClosePathCostOfTotal=+ClosePathCostOfTotal+PathWayCost  //计算完成路径总费用
		
		//***********************Start*******************************************
		//wangcs 2012-09-12
		Set InPathWayCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"InPathWayCount"))        //入径总人数、
		Set InpathTotal=+InpathTotal+InPathWayCount   //计算入径总人数
		
		Set NeedPathWayCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"NeedInPathCount"))     //应入径人数
		Set NeedInpathTotal=+NeedInpathTotal+NeedPathWayCount  //计算应入径总人数
		
		Set ClosePathWayCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"ClosePathWayCount"))  //完成人数
		Set ClosePathTotal=+ClosePathTotal+ClosePathWayCount //计算完成路径总人数
		
		Set OutPathWayCount=+$g(^TMP(ZIndex,JIndex,"QryDischStat",LocID,"OutPathWayCount"))       //出径人数
		Set OutPathTotal=+OutPathTotal+OutPathWayCount      //计算出径总人数
		//***********************************************************************
		
		If (InPathWayCount'=0)&&(ClosePathWayCount'=0) {
			Set ClosePathWayRatio=$fn((ClosePathWayCount/InPathWayCount)*100,"",2)_"%"               //完成率
		} Else {
			Set ClosePathWayRatio="0.00%"
		}
		
		If (InPathWayCount'=0)&&(NeedPathWayCount'=0) {
			Set PathWayRatio=$fn((InPathWayCount/NeedPathWayCount)*100,"",2)_"%"               //入径率
		} Else {
			Set PathWayRatio="0.00%"
		}
		If (InPathWayCount'=0)&&(OutPathWayCount'=0) {
			Set OutPathWayRatio=$fn((OutPathWayCount/InPathWayCount)*100,"",2)_"%"               //出径率
		} Else {
			Set OutPathWayRatio="0.00%"
		}
		If (AdmNum'=0)&&(LocAdmCount'=0) {
			Set AdmNumRatio=$fn((LocAdmCount/AdmNum)*100,"",2)_"%"                      //科室病人占有率
		} Else {
			Set AdmNumRatio="0.00%"
		}
		
		If (InPathWayCount'=0)&&(LocAdmCount'=0) {
			Set PathWayNumRatio=$fn((InPathWayCount/LocAdmCount)*100,"",2)_"%"                //科室入径占有率
		} Else {
			Set PathWayNumRatio="0.00%"
		}
		
		
		If (LocAdmDays'=0)&&(LocAdmCount'=0) {
			Set AdmDaysRatio=$fn(LocAdmDays/LocAdmCount,"",2)                           //平均住院日
		} Else {
			Set AdmDaysRatio="0.00"
		}
		
		If (LocAdmCost'=0)&&(LocAdmCount'=0) {
			Set AdmCostRatio=$fn(LocAdmCost/LocAdmCount,"",2)                           //平均费用
		} Else {
			Set AdmCostRatio="0.00"
		}
		If (PathWayDays'=0)&&(ClosePathWayCount'=0) {
			Set PathDaysRatio=$fn(PathWayDays/ClosePathWayCount,"",2)                        //入径患者平均住院日
		} Else {
			Set PathDaysRatio="0.00"
		}
		If (PathWayCost'=0)&&(ClosePathWayCount'=0) {
			Set PathCostRatio=$fn(PathWayCost/ClosePathWayCount,"",2)                        //入径患者平均费用
		} Else {
			Set PathCostRatio="0.00"
		}
		
		Set Data=$lb(LocID,LocDesc,LocAdmCount,InPathWayCount,PathWayRatio,AdmNumRatio,PathWayNumRatio,LocCPWNum,AdmDaysRatio,AdmCostRatio,PathDaysRatio,PathCostRatio,NeedPathWayCount,ClosePathWayCount,ClosePathWayRatio,OutPathWayCount,OutPathWayRatio)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Set (PathWayRatioTotal,AdmNumRatioTotal,PathWayNumRatioTotal,AdmDaysRatioTotal,AdmCostRatioTotal,PathDaysRatioTotal,PathCostRatioTotal,ClosePathWayRatioTotal,OutPathWayRatioTotal)=0
	If (InpathTotal'=0)&&(NeedInpathTotal'=0){
		Set PathWayRatioTotal=$fn((InpathTotal/NeedInpathTotal)*100,"",2)_"%"               //医院总入径率
	}Else{
		Set PathWayRatioTotal="0.00%"
	}
	
	If (InpathTotal'=0)&&(DischTotal'=0) {
		Set PathWayNumRatioTotal=$fn((InpathTotal/DischTotal)*100,"",2)_"%"                //入径占出院总人数
	} Else {
		Set PathWayNumRatioTotal="0.00%"
	}
	If (AdmDaysTotal'=0)&&(DischTotal'=0) {
		Set AdmDaysRatioTotal=$fn(AdmDaysTotal/DischTotal,"",2)                           //平均住院日
	} Else {
		Set AdmDaysRatioTotal="0.00"
	}
	If (AdmCostTotal'=0)&&(DischTotal'=0) {
		Set AdmCostRatioTotal=$fn(AdmCostTotal/DischTotal,"",2)                           //平均费用
	} Else {
		Set AdmCostRatioTotal="0.00"
	}	
	If (ClosePathDaysOfTotal'=0)&&(ClosePathTotal'=0) {
		Set PathDaysRatioTotal=$fn(ClosePathDaysOfTotal/ClosePathTotal,"",2)                        //入径患者平均住院日
	} Else {
		Set PathDaysRatioTotal="0.00"
	}
	If (ClosePathCostOfTotal'=0)&&(ClosePathTotal'=0) {
		Set PathCostRatioTotal=$fn(ClosePathCostOfTotal/ClosePathTotal,"",2)                        //入径患者平均费用
	} Else {
		Set PathCostRatioTotal="0.00"
	}
	If (InpathTotal'=0)&&(ClosePathTotal'=0) {
		Set ClosePathWayRatioTotal=$fn((ClosePathTotal/InpathTotal)*100,"",2)_"%"               //完成率
	} Else {
		Set ClosePathWayRatioTotal="0.00%"
	}
	If (InpathTotal'=0)&&(OutPathTotal'=0) {
		Set OutPathWayRatioTotal=$fn((OutPathTotal/InpathTotal)*100,"",2)_"%"               //出径率
	} Else {
		Set OutPathWayRatioTotal="0.00%"
	}
	Set Data=$lb(0,"总计",DischTotal,InpathTotal,PathWayRatioTotal,"-",PathWayNumRatioTotal,PathTotal,AdmDaysRatioTotal,AdmCostRatioTotal,PathDaysRatioTotal,PathCostRatioTotal,NeedInpathTotal,ClosePathTotal,ClosePathWayRatioTotal,OutPathTotal,OutPathWayRatioTotal)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Kill ^TMP(ZIndex,JIndex,"QryDischStat")
	
	Quit $$$OK
}

ClassMethod QryDischStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QryDischStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     李宇峰
/// CreatDate：   2010-07-14
/// Description:  取住院科室下下的入径病人的基本信息，一个临床路径下的人数，平均住院日，平均费用，变异人数，变异比例，参考费用。
///  Modify by wuqk 2011-11-22 增加输出 ImplItemRatio：已完成项目比例
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStat","QryDischStatDetail","2010-11-13","2010-11-14",44)
Query QryDischStatDetail(argStartDate As %String, argEndDate As %String, argLocID As %String) As %Query(ROWSPEC = "CtRowid:%Integer,admId:%String,cpwRowid:%String,pathRowid:%String,PatientId:%String,PAPMIName:%String,sex:%String,PAPMIAge:%String,PAAdmDocCodeDR:%String,admDate:%String,DischgDate:%String,cpwInDate:%String,cpwOutDate:%String,days:%String,const1:%String,CheckVar:%String,pathStr:%String,DrugRatio:%String,ImplItemRatio:%String,InMedicare:%String")
{
}

ClassMethod QryDischStatDetailExecute(ByRef qHandle As %Binary, argStartDate As %String, argEndDate As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	;Set:argStartDate["/" argStartDate=$zdh(argStartDate,4)
	;Set:argStartDate["-" argStartDate=$zdh(argStartDate,3)
	Set argStartDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argStartDate)
	Set argEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(argEndDate)
	Set:argStartDate'="" argStartDate=+argStartDate
	;Set:argEndDate["/" argEndDate=$zdh(argEndDate,4)
	;Set:argEndDate["-" argEndDate=$zdh(argEndDate,3)
	Set:argEndDate'="" argEndDate=+argEndDate
	Set:argEndDate="" argEndDate=+$h
	Quit:(argStartDate="")||(argEndDate="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryDischStatDetail")
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argStartDate:1:argEndDate {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
			//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
			Set LocID=$p(AdmInfo,"^",4)     //就诊科室
			Continue:LocID=""
			//Continue:(argLocID'="")&&(LocID'=argLocID)
			Continue:(argLocID'=0)&&(LocID'=argLocID)	//Modified by zhaoyu 2013-01-06 出院患者统计合计无数据
			
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Set (PathWayID,CPWID,CPWStatus)=""
			Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,""),-1)
			If PathWayID'="" {
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay){
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
					}
					Set CPWStatus=objPathWay.CPWStatus
				}
			}
			Continue:(PathWayID="")||(CPWID="")
			;Continue:CPWStatus'="C"
			Continue:CPWStatus=""   ;wangcs 2013-04-28
			
			//Set AdmitDate=$p(AdmInfo,"^",6)  //就诊日期
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
			Set AdmitDate=$p(AdmDateTime,"^",1)
			//Set DischDate=$p(AdmInfo,"^",17) //出院日期
			//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
			Set DischDate=$p(DischDateTime,"^",1)
				
		    If DischDate'="" {
			    Set AdmDays=DischDate-AdmitDate
		    } Else {
				Set AdmDays=+$h-AdmitDate    //住院天数
			}
			Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
			Set CountCost=+$p(strCost,"^",1)  //住院总费用
			Set DrugCost=+$p(strCost,"^",2)   //药费
			If (CountCost'=0)&&(DrugCost'=0) {                //药费比例
				Set DrugRatio=$fn((DrugCost/CountCost)*100,"",2)_"%"
			} Else {
				Set DrugRatio="00.00%"
			}
			Set:CountCost'="" CountCost=$fn(CountCost,"",2)
			Set:DrugCost'="" DrugCost=$fn(DrugCost,"",2)
			Set CheckVar=..CheckVariance(PathWayID)
			
			Set tmpDays=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmDays",CPWID))
			Set ^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmDays",CPWID)=tmpDays+AdmDays
			
			Set tmpCosts=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmCosts",CPWID))
			Set ^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmCosts",CPWID)=tmpCosts+CountCost
			
			Set:CheckVar="Yes" num=$i(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"CheckVar",CPWID))
			
			Set num=$i(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmNum",CPWID))
			Set ^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"PathWay",CPWID,PathWayID)=AdmDays_"^"_CountCost_"^"_DrugRatio_"^"_CheckVar
		}
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID))
		Quit:LocID=""
				
		Set CPWID=0
		For {
			Set CPWID=$o(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"PathWay",CPWID))
			Quit:CPWID=""
			
			Set AdmDays=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmDays",CPWID))
			Set AdmNum=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmNum",CPWID))
			Set AdmCosts=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"AdmCosts",CPWID))
			Set CheckVarNum=+$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"CheckVar",CPWID))
			If (AdmDays'=0)&&(AdmNum'=0) {                //平均住院日
				Set AdmDaysAverage=$fn(AdmDays/AdmNum,"",2)
			} Else {
				Set AdmDaysAverage="0.00"
			}
			If (AdmCosts'=0)&&(AdmNum'=0) {                //平均住院费用
				Set AdmCostsAverage=$fn(AdmCosts/AdmNum,"",2)
			} Else {
				Set AdmCostsAverage="0.00"
			}
			If (CheckVarNum'=0)&&(AdmNum'=0) {             //变异比例
				Set CheckVarRatio=$fn((CheckVarNum/AdmNum)*100,"",2)_"%"
			} Else {
				Set CheckVarRatio="0.00%"
			}
			
			Set PathWayID=0
			For {
				Set PathWayID=$o(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"PathWay",CPWID,PathWayID))
				Quit:PathWayID=""
				
				Set (MRAdm,CPWID,CPWDesc,CPWCost,CPWDays,CPWInDate,CPWOutDate)=""
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay){
					Set MRAdm=objPathWay.CPWMRADMDR
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
						Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc_" V"_objPathWay.CPWPathwayDR.CPWVersion_".0.0"  //add by wuqk 2011-07-26  为避免同一路径不同版本信息自动合并，加上版本号传出
						Set CPWCost=objPathWay.CPWPathwayDR.CPWCost
						Set CPWDays=objPathWay.CPWPathwayDR.CPWDays
						Set CPWInDate=objPathWay.CPWInDate
						;Set:CPWInDate'="" CPWInDate=$zd(CPWInDate,3)
						Set:CPWInDate'="" CPWInDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CPWInDate)
						Set CPWOutDate=objPathWay.CPWOutDate
						;Set:CPWOutDate'="" CPWOutDate=$zd(CPWOutDate,3)
						Set:CPWOutDate'="" CPWOutDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CPWOutDate)
					}
				}
				
				//add by wuqk 2011-11-22  ---------begin-----
				Set ImplItemNum=..GetCurrentItems(PathWayID)     //已执行临床路径项目的个数
				Set ItemNum=..GetCPWItems(CPWID)                 //临床路径中所包含的项目个数
				If (+ImplItemNum'=0)&&(+ItemNum'=0) {
					Set ImplItemRatio=$fn((ImplItemNum/ItemNum)*100,"",2)_"%"      // 实施项目比例
				} Else {
					Set ImplItemRatio="00.00%"
				}
				//add by wuqk 2011-11-22 ------end-----
				
				Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Continue:(MRAdm="")||(Paadm="")
				
				Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,AdmitDate,DischDate,AdmDoc)=""
				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
			    If $IsObject(objPaadm)
			    {
				    If $IsObject(objPaadm.PAADMPAPMIDR)
				    {
					    Set objPatient=objPaadm.PAADMPAPMIDR
					    Set PatientID=objPatient.%Id()
					    //Set PapmiNo=objPatient.PAPMINo
					    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
					    Set PatName=objPatient.PAPMIName
					    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
			    		Set Birthday=objPatient.PAPMIDOB
		    			;Set:Birthday'="" Birthda=$zd(Birthday,3)
		    			Set:Birthday'="" Birthda=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
						
		    			//update by zf 20150228 统一调用年龄计算方法
		    			Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”
		    		}
					
				    //Set AdmitDate=objPaadm.PAADMAdmDate
				    //Set AdmitTime=objPaadm.PAADMAdmTime
				    //upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
					Set AdmitDate=$p(AdmDateTime,"^",1)
					Set AdmitTime=$p(AdmDateTime,"^",2)
				    //Set DischDate=objPaadm.PAADMDischgDate
				    //Set DischTime=objPaadm.PAADMDischgTime
				    //Update by pylian 2016-01-21 修改出院时间取值方式
					Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
					Set DischDate=$p(DischDateTime,"^",1)
				    Set DischTime=$p(DischDateTime,"^",2)
				    ;Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
				    Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
				    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
				    ;Set:DischDate'="" DischDate=$zd(DischDate,3)
				    Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
				    Set:DischTime'="" DischTime=$zt(DischTime,1)
					If $IsObject(objPaadm.PAADMAdmDocCodeDR)
					{
						Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
					}
				}
				
				Set PathStr="<font color='Royal Blue'>"_CPWDesc_"</font>"_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='Royal Blue'>人数</font>:"_AdmNum_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='Royal Blue'>平均住院日</font>:"_AdmDaysAverage_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='Royal Blue'>平均费用</font>:"_AdmCostsAverage_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='Royal Blue'>变异人数</font>:"_CheckVarNum_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='Royal Blue'>变异比例</font>:"_CheckVarRatio_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='red'>参考费用</font>:"_CPWCost_"&nbsp&nbsp&nbsp&nbsp"
				Set PathStr=PathStr_"<font color='red'>参考住院日</font>:"_CPWDays_"天"
				
				Set tmpInfo=$g(^TMP(ZIndex,JIndex,"QryDischStatDetail",LocID,"PathWay",CPWID,PathWayID))
				Set AdmDays=$p(tmpInfo,"^",1)
				Set CountCost=$p(tmpInfo,"^",2)
				Set DrugRatio=$p(tmpInfo,"^",3)
				Set CheckVar=$p(tmpInfo,"^",4)
				
				Set InMedicare=##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID(Paadm)
				
				set Data=$lb(LocID,Paadm,CPWID,PathWayID,PatientID,PatName,Sex,Age,AdmDoc,AdmitDate,DischDate,CPWInDate,CPWOutDate,AdmDays,CountCost,CheckVar,PathStr,DrugRatio,ImplItemRatio,InMedicare)
	 			Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryDischStatDetail")
	
 	Quit $$$OK
}

ClassMethod QryDischStatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischStatDetailExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QryDischStatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischStatDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ***********************************************************
/// 临床路径在院统计 2010-11-13 Update By ZF
/// ***********************************************************
/// Creator：     李宇峰
/// CreatDate：   2010-06-30
/// Description:  取执行科室下，入径人数，在院人数，路径数，入径人数/在院人数。
/// Input：       无参数
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStat","QryAdmitStat")
Query QryAdmitStat() As %Query(ROWSPEC = "CtRowid:%Integer,CtDesc:%String:科室名称,InHospitalNum:%String:在院人数,InPathWayNum:%String:入径人数,PathWayNum:%String:路径数,InPathWayPercent:%String:入径人数/在院人数")
{
}

ClassMethod QryAdmitStatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryAdmitStat")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤

				//按照护理配置 过滤已出院未离床患者 
				Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
				Set DischDate=$p(DischDateTime,"^",1)
				Continue:DischDate'=""
				
				//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
				Set LocID=$p(AdmInfo,"^",4)
				Continue:LocID=""
				Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocAdmNum"))  //科室在院人数
				
				Set MRADMID=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRADMID,PathWayID))
					Quit:PathWayID=""
					
					Set (Status,CPWID)=""
					Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay){
						Set Status=objPathWay.CPWStatus
						If $IsObject(objPathWay.CPWPathwayDR){
							Set CPWID=objPathWay.CPWPathwayDR.%Id()
						}
					}
					Continue:Status'="I"
					Continue:CPWID=""
					Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocInCPWNum"))          //科室入径人数
					If '$d(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocCPW",CPWID)){
						Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocCPWNum"))        //科室路径数
					}
					Set ^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocCPW",CPWID)=""
				}
			}
		}
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID))
		Quit:LocID=""
		Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set AdmNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocAdmNum"))
		Set InCPWNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocInCPWNum"))
		Set CPWNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStat",LocID,"LocCPWNum"))
		If (InCPWNum'=0)&&(AdmNum'=0) {                //    入径/在院
			Set InCPWRatio=$fn((InCPWNum/AdmNum)*100,"",2)_"%"
		} Else {
			Set InCPWRatio="00.00%"
		}
		Set Data=$lb(LocID,LocDesc,AdmNum,InCPWNum,CPWNum,InCPWRatio)
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Kill ^TMP(ZIndex,JIndex,"QryAdmitStat")
	
	Quit $$$OK
}

ClassMethod QryAdmitStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmitStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmitStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmitStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     李宇峰
/// CreatDate：   2010-07-01
/// Description:  取某一个科室下，全部临床路径，每个路径的入径人数，每个路径的入径人数/本科室的全部入径人数，每个路径的入径人数/在院人数。
/// Input：       argLocID 就诊科室
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysStat","QryAdmitStatDetail",151)
Query QryAdmitStatDetail(argLocID As %String) As %Query(ROWSPEC = "CtRowid:%Integer,MRAdm:%String,EpisodeID:%String,PatientID:%String,PathWayId:%Integer:1,PathNumStr:%String:1,MrPathRowid:%String,PAPMIName:%String:姓名,sex:%String:性别,PAPMIAge:%String:年龄,PAAdmDocCodeDR:%String:医生,admDate:%String:入院日期,cpwInDate:%String:入径日期,currentStepDesc:%String:所处步骤,cpwDateNo:%String:入径天数,cpwDataNoPercent:%String:入径天数/在院天数,implItemsPercent:%String:已实施项目比例,CheckVar:%String:是否变异,cont:%String:住院费用,DrugRatio:%String:药费比例,AdmDays:%String:在院天数,InMedicare:%String:病案号")
{
}

ClassMethod QryAdmitStatDetailExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryAdmitStatDetail")
	
	Set WardID=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))  //通过病区、病房查找在院病人人数
		Quit:WardID=""
		Set RoomID=0
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=0
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
				
				//按照护理配置 过滤已出院未离床患者 
				Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(Paadm)
				Set DischDate=$p(DischDateTime,"^",1)
				Continue:DischDate'=""
				
				//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
				Set LocID=$p(AdmInfo,"^",4)
				Continue:LocID=""
				Continue:(argLocID'="")&&(argLocID'=LocID)
				
				Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocAdmNum"))  //科室在院人数
				
				Set MRADMID=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
				Set PathWayID=0
				For {
					Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRADMID,PathWayID))
					Quit:PathWayID=""
					
					Set (Status,CPWID)=""
					Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay){
						Set Status=objPathWay.CPWStatus
						If $IsObject(objPathWay.CPWPathwayDR){
							Set CPWID=objPathWay.CPWPathwayDR.%Id()
						}
					}
					Continue:Status'="I"
					Continue:CPWID=""
					Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocInCPWNum"))          //科室入径人数
					Set num=$i(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocInCPWNum",CPWID))    //科室路径入径人数
					Set ^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocCPW",CPWID,PathWayID)=""
				}
			}
		}
	}
	
	Set LocID=0
	For {
		Set LocID=$o(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID))
		Quit:LocID=""
		
		Set CPWID=0
		For {
			Set CPWID=$o(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocCPW",CPWID))
			Quit:CPWID=""
			
			Set AdmNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocAdmNum"))
			Set InCPWNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocInCPWNum"))
			Set PathWayID=0
			For {
				Set PathWayID=$o(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocCPW",CPWID,PathWayID))
				Quit:PathWayID=""
				
				Set (MRAdm,CPWID,CPWDesc,CPWCost,CPWDays,CPWInDate)=""
				Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay){
					Set MRAdm=objPathWay.CPWMRADMDR
					If $IsObject(objPathWay.CPWPathwayDR){
						Set CPWID=objPathWay.CPWPathwayDR.%Id()
						Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc_" V"_objPathWay.CPWPathwayDR.CPWVersion_".0.0"  //add by wuqk 2011-07-26  为避免同一路径不同版本信息自动合并，加上版本号传出
						Set CPWCost=objPathWay.CPWPathwayDR.CPWCost
						Set CPWDays=objPathWay.CPWPathwayDR.CPWDays
						Set CPWInDate=objPathWay.CPWInDate
						;Set:CPWInDate'="" CPWInDate=$zd(CPWInDate,3)
						Set:CPWInDate'="" CPWInDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CPWInDate)
					}
				}
				Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
				Continue:(MRAdm="")||(Paadm="")
				
				Set cInCPWNum=+$g(^TMP(ZIndex,JIndex,"QryAdmitStatDetail",LocID,"LocInCPWNum",CPWID))
				If (cInCPWNum'=0)&&(InCPWNum'=0) {
					Set InCPWRatio1=$fn((cInCPWNum/InCPWNum)*100,"",2)_"%"    // 路径入径人数/科室入径人数
				} Else {
					Set InCPWRatio1="00.00%"
				}
				If (cInCPWNum'=0)&&(AdmNum'=0) {
					Set InCPWRatio2=$fn((cInCPWNum/AdmNum)*100,"",2)_"%"      // 路径入径人数/科室在院人数
				} Else {
					Set InCPWRatio2="00.00%"
				}
				Set PathNumStr="<font color='Royal Blue'>"_CPWDesc_"</font>: "_cInCPWNum_"&nbsp&nbsp&nbsp&nbsp"   //modify by wuqk 2011-07-26 InCPWNum->cInCPWNum
				Set PathNumStr=PathNumStr_"<font color='Royal Blue'>人数/在院人数:</font> "_InCPWRatio2_"&nbsp&nbsp&nbsp&nbsp"
				Set PathNumStr=PathNumStr_"<font color='Royal Blue'>人数/入径人数</font>: "_InCPWRatio1_"&nbsp&nbsp&nbsp&nbsp"
				Set PathNumStr=PathNumStr_"<font color='red'>参考费用：</font>"_CPWCost_"&nbsp&nbsp&nbsp&nbsp"
				Set PathNumStr=PathNumStr_"<font color='red'>参考住院日:</font>"_CPWDays_"天"
				Set StepInfo=##class(web.DHCCPW.MR.ClinicalPathWays).GetCurrentStepInfo(Paadm,"^")
				Set CurrStepDesc=$p(StepInfo,"^",4)              //当前所处步骤
				Set CPWInDays=+$p(StepInfo,"^",2)-1              //入径天数
				Set ImplItemNum=..GetCurrentItems(PathWayID)     //已执行临床路径项目的个数
				Set ItemNum=..GetCPWItems(CPWID)                 //临床路径中所包含的项目个数
				If (+ImplItemNum'=0)&&(+ItemNum'=0) {
					Set ImplItemRatio=$fn((ImplItemNum/ItemNum)*100,"",2)_"%"      // 实施项目比例
				} Else {
					Set ImplItemRatio="00.00%"
				}
				Set CheckVar=..CheckVariance(PathWayID)           //是否有变异记录
				
				Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,AdmitDate,AdmDays,AdmDoc)=""
				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
			    If $IsObject(objPaadm)
			    {
				    If $IsObject(objPaadm.PAADMPAPMIDR)
				    {
					    Set objPatient=objPaadm.PAADMPAPMIDR
					    Set PatientID=objPatient.%Id()
					    //Set PapmiNo=objPatient.PAPMINo
					    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
					    Set PatName=objPatient.PAPMIName
					    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
					    Set Birthday=objPatient.PAPMIDOB
		    			;Set:Birthday'="" Birthda=$zd(Birthday,3)
		    			Set:Birthday'="" Birthda=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
						
		    			//update by zf 20150228 统一调用年龄计算方法
		    			Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,Paadm,"","")	//返回“*岁*月*天”
		    		}
					
				    //Set AdmitDate=objPaadm.PAADMAdmDate
				    //Set AdmitTime=objPaadm.PAADMAdmTime
				    //upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
					Set AdmitDate=$p(AdmDateTime,"^",1)
					Set AdmitTime=$p(AdmDateTime,"^",2)
					Set AdmDays=+$h-AdmitDate
				    ;Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
				    Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
				    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
					If $IsObject(objPaadm.PAADMAdmDocCodeDR)
					{
						Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
					}
				}
				If (CPWInDays'=0)&&(AdmDays'=0) {
					Set InDayRatio=$fn((CPWInDays/AdmDays)*100,"",2)_"%"      // 实施项目比例
				} Else {
					Set InDayRatio="00.00%"
				}
				Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
				Set CountCost=+$p(strCost,"^",1)  //住院总费用
				Set DrugCost=+$p(strCost,"^",2)   //药费
				If (CountCost'=0)&&(DrugCost'=0) {                //药费比例
					Set DrugRatio=$fn((DrugCost/CountCost)*100,"",2)_"%"
				} Else {
					Set DrugRatio="00.00%"
				}
				Set:CountCost'="" CountCost=$fn(CountCost,"",2)
				Set:DrugCost'="" DrugCost=$fn(DrugCost,"",2)
				
				Set InMedicare=##class(web.DHCCPW.MR.Interface).GetMrNoByEpisodeID(Paadm)
				
				Set Data=$lb(LocID,MRAdm,Paadm,PatientID,CPWID,PathNumStr,PathWayID,PatName,Sex,Age,AdmDoc,AdmitDate,CPWInDate,CurrStepDesc,CPWInDays,InDayRatio,ImplItemRatio,CheckVar,CountCost,DrugRatio,AdmDays,InMedicare)
 				Set ^CacheTemp(repid,ind)=Data
 				Set ind=ind+1
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryAdmitStatDetail")
	
	Quit $$$OK
}

ClassMethod QryAdmitStatDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmitStatDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmitStatDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmitStatDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
/// Creator：     李宇峰
/// CreatDate：   2010-07-02
/// Description: 计算一个临床路径中的全部天数。
/// w ##class(web.DHCCPW.MR.ClinPathWaysStat).GetCPWDays(1)
ClassMethod GetCPWDays(CPWRowid As %String)
{
	New (CPWRowid)
	Set days=0
	Set EpChild=0
	For  Set EpChild=$o(^DHCMRC("CPW",CPWRowid,"EP",EpChild)) Quit:EpChild=""  Do
	.Set StepChild=0
	.For  Set StepChild=$o(^DHCMRC("CPW",CPWRowid,"EP",EpChild,"STEP",StepChild)) Quit:StepChild=""  Do
	..Set StepRowid=CPWRowid_"||"_EpChild_"||"_StepChild
	..Set obj=##class(web.DHCCPW.MRC.PathWEpStep).GetObjById(StepRowid)
	..Set day=obj.CPWSDay
	..Set days=days+day
	Quit days
}
*/
/// Creator：     李宇峰
/// CreatDate：   2010-07-02
/// Description: 计算一个病人入径后已经执行临床路径项目个数。
/// w ##class(web.DHCCPW.MR.ClinPathWaysStat).GetCurrentItems(1)
ClassMethod GetCurrentItems(argPathWayID As %String) As %String
{
	New (argPathWayID)
	Set return=0
	Quit:argPathWayID="" return
	
	Set ImplID=0,Count=0
	For {
		Set ImplID=$o(^DHCMR("CPW",argPathWayID,"IMPL",ImplID))
		Quit:ImplID=""
		Set ImplementID=argPathWayID_"||"_ImplID
		Set objImplement=##class(web.DHCCPW.MR.Implement).GetObjById(ImplementID)
		If $IsObject(objImplement) {
				Set Active=objImplement.CPWEActive
				Continue:Active["N"  //如果实施记录无效,算做未执行
				Set Count=Count+1
		}
	}
	Set return=Count
	
	Quit return
}

/// Creator：     李宇峰
/// CreatDate：   2010-07-02
/// Description: 计算一个临床路径所所包含的临床路径项目的个数。
/// w ##class(web.DHCCPW.MR.ClinPathWaysStat).GetCPWItems(1)
ClassMethod GetCPWItems(CPWRowid As %String)
{
	New (CPWRowid)
	Set items=0
	Set EpChild=0
	For  Set EpChild=$o(^DHCMRC("CPW",CPWRowid,"EP",EpChild)) Quit:EpChild=""  Do
	.Set StepChild=0
	.For  Set StepChild=$o(^DHCMRC("CPW",CPWRowid,"EP",EpChild,"STEP",StepChild)) Quit:StepChild=""  Do
	..Set ItemChild=0
	..For  Set ItemChild=$o(^DHCMRC("CPW",CPWRowid,"EP",EpChild,"STEP",StepChild,"ITEM",ItemChild)) Quit:ItemChild=""  Do
	...Set items=items+1
	Quit items
}

/// Creator：     李宇峰
/// CreatDate：   2010-07-02
/// Description: 检查一个病人是否有变异记录。
/// w ##class(web.DHCCPW.MR.ClinPathWaysStat).CheckVariance()
ClassMethod CheckVariance(argPathWayID As %String)
{
	New (argPathWayID)
	Set return="No"
	Set ChildSub=0
	For {
		Set ChildSub=$o(^DHCMR("CPW",argPathWayID,"VAR",ChildSub))
		Quit:(ChildSub="")||(return="Yes")
		Set return="Yes"
	}
	Quit return
}

Storage Default
{
<Data name="ClinPathWaysStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.ClinPathWays653D</DataLocation>
<DefaultData>ClinPathWaysStatDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.ClinPathWays653D</IdLocation>
<IndexLocation>^web.DHCCPW.MR.ClinPathWays653I</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.ClinPathWays653S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
