/// 名称: web.DHCCPW.MR.ClinPathWaysAnalysis
/// 描述: 临床路径统计分析
/// 编写者：zhufei
/// 编写日期: 2011-01-20
Class web.DHCCPW.MR.ClinPathWaysAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-01-20
/// Description:  出院病人出入径分析
/// Input：       DateFrom(开始日期),DateTo(结束日期)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysAnalysis","QryCPWDischStat","2011-01-01","2011-01-20","")
Query QryCPWDischStat(argDateFrom As %String, argDateTo As %String, argLocID As %String) As %Query(ROWSPEC = "LocDesc:%String,CPWDesc:%String,DischNum:%String,CPWDischNum:%String,InCPWNum:%String,CloseCPWNum:%String,OutCPWNum:%String,InDays:%String,OutDays:%String,CloseDays:%String,CPWRatio:%String,InRatio:%String,OutRatio:%String,InCost:%String,InDrugRatio:%String,CloseCost:%String,CloseDrugRatio:%String,OutCost:%String,OutDrugRatio:%String")
{
}

ClassMethod QryCPWDischStatExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Kill ^TMP($zn,$j,"QryCPWDischStat")
	
	Set ConfigType=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("GetCPWICDType")
	If $IsObject(objConfig) {
		Set ConfigType=objConfig.BCValue
	}
	
	//处理HIS中出入径信息
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(argLocID'=AdmLoc)
			Set num=$i(^TMP($zn,$j,"QryCPWDischStat","Admit",AdmLoc))
			
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			
			Set lsICDToCPW=..CheckICDToCPW(MRAdm,ConfigType)
			For ICDToCPWInd=1:1:$listlength(lsICDToCPW)
			{
				Set ICDToCPWDesc=$list(lsICDToCPW,ICDToCPWInd)
				Continue:ICDToCPWDesc=""
				Set num=$i(^TMP($zn,$j,"QryCPWDischStat","CPW",ICDToCPWDesc,"CPWDisch"))
			}
			
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
				If $IsObject(objPathWay) {
					Set CPWDesc=objPathWay.CPWPathwayDR.CPWDesc
					Set CPWStatus=objPathWay.CPWStatus
					Continue:CPWDesc=""
					Continue:(CPWStatus'="I")&&(CPWStatus'="C")&&(CPWStatus'="O")
					
					Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
					Set CountCost=+$p(strCost,"^",1)  //住院总费用
					Set DrugCost=+$p(strCost,"^",2)   //药费
					Set AdmDays=##class(web.DHCCPW.MR.PAADMSrv).GetAdmDays(Paadm)
					
					Set num=$i(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"In"))
					Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InCost")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InCost"))+CountCost
					Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDrug")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDrug"))+DrugCost
					Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDays")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDays"))+AdmDays
					If CPWStatus="C" {
						Set num=$i(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Close"))
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseCost")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseCost"))+CountCost
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDrug")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDrug"))+DrugCost
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDays")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDays"))+AdmDays
					}
					If CPWStatus="O" {
						Set num=$i(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Out"))
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutCost")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutCost"))+CountCost
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDrug")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDrug"))+DrugCost
						Set ^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDays")=$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDays"))+AdmDays
					}
				}
			}
		}
	}
	
	/*****************************************************
	// update by zf 20110601
	// ^DHCMRC("DEPCPW",1)
	Set LocCPWID=0
	For {
		Set LocCPWID=$o(^DHCMRC("DEPCPW",LocCPWID))
		Quit:LocCPWID=""
		Set objLocCPW=##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(1)
		If $IsObject(objLocCPW){
			Set LocID=objLocCPW.DCPWCTLOCDR
			Set CPWDesc=objLocCPW.DCPWCPWDR.CPWDDesc
			Continue:(LocID="")||(CPWDesc="")
			Set ^TMP($zn,$j,"QryCPWDischStat","LCPW",LocID,CPWDesc)=""
		}
	}
	Set LocID=0
	For {
		Set LocID=$o(^TMP($zn,$j,"QryCPWDischStat","LCPW",LocID))
		Quit:LocID=""
		Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)     //科室(病种科室/出院科室)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		
		Set CPWDesc=""                              //实施病种名称
		For {
			Set CPWDesc=$o(^TMP($zn,$j,"QryCPWDischStat","LCPW",LocID,CPWDesc))
			Quit:CPWDesc=""
			
			Set DischNum=+$g(^TMP($zn,$j,"QryCPWDischStat","Admit",LocID))            //期内出院病人总数
			Set CPWDischNum=0                                                         //病种出院人数
			Set InCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"In"))       //期内入径标记人数
			Set CloseCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Close")) //期内完成路径标记人数
			Set OutCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Out"))     //期内出径标记人数
			
			Set (CPWRatio,InRatio,OutRatio,InDrugRatio,OutDrugRatio,CloseDrugRatio)="0.00%"
			Set (InDays,OutDays,CloseDays,InCost,CloseCost,OutCost)=0
			If DischNum'=0 {
				Set CPWRatio=$fn((CPWDischNum/DischNum)*100,"",2)_"%"   //覆盖率
			}
			If CPWDischNum'=0 {
				Set InRatio=$fn((InCPWNum/CPWDischNum)*100,"",2)_"%"    //入径率
				Set OutRatio=$fn((OutCPWNum/CPWDischNum)*100,"",2)_"%"  //出径率
			}
			
			If InCPWNum'=0 {
				Set InDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDays"))
				Set InDays=$fn(InDays/InCPWNum,"",2)                   //入径病人平均住院日
				Set InCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InCost"))
				Set InDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDrug"))
				If InCost'=0 {
					Set InDrugRatio=$fn((InDrug/InCost)*100,"",2)_"%"  //入径病人药品费用所占比例(%)
				}
				Set InCost=$fn(InCost/InCPWNum,"",2)                   //入径病人次均费用
			}
			If OutCPWNum'=0 {
				Set OutDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDays"))
				Set OutDays=$fn(OutDays/OutCPWNum,"",2)                   //出径病人平均住院日
				Set OutCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutCost"))
				Set OutDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDrug"))
				If OutCost'=0 {
					Set OutDrugRatio=$fn((OutDrug/OutCost)*100,"",2)_"%"  //出径病人药品费用所占比例(%)
				}
				Set OutCost=$fn(OutCost/OutCPWNum,"",2)                   //出径病人次均费用
			}
			If CloseCPWNum'=0 {
				Set CloseDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDays"))
				Set CloseDays=$fn(CloseDays/CloseCPWNum,"",2)                   //完成路径病人平均住院日
				Set CloseCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseCost"))
				Set CloseDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDrug"))
				If CloseCost'=0 {
					Set CloseDrugRatio=$fn((CloseDrug/CloseCost)*100,"",2)_"%"  //完成路径病人药品费用所占比例(%)
				}
				Set CloseCost=$fn(CloseCost/CloseCPWNum,"",2)                   //完成路径病人次均费用
			}
			
			//科室	实施病种名称	期内出院病人总数	病种出院人数	期内入径标记人数	期内完成路径人数	期内出径标记人数	入径病人平均住院日	出径病人平均住院日	完成路径病人平均住院日	覆盖率%	入径率%	出径率%	入径病人次均费用	入径病人药品费用所占比例(%)	完成路径病人次均费用	完成路径病人药品费用所占比例(%)	出径病人次均费用	出径病人药品费用所占比例(%)
			Set Data=$lb(LocDesc,CPWDesc,DischNum,CPWDischNum,InCPWNum,CloseCPWNum,OutCPWNum,InDays,OutDays,CloseDays,CPWRatio,InRatio,OutRatio,InCost,InDrugRatio,CloseCost,CloseDrugRatio,OutCost,OutDrugRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	******************************************************/
	
	Set LocID=0,LocDesc=""
	Set CPWDesc=""                              //实施病种名称
	For {
		Set CPWDesc=$o(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc))
		Quit:CPWDesc=""
		
		Set DischNum=+$g(^TMP($zn,$j,"QryCPWDischStat","Admit",LocID))            //期内出院病人总数
		Set CPWDischNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CPWDisch"))    //病种出院人数
		Set InCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"In"))       //期内入径标记人数
		Set CloseCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Close")) //期内完成路径标记人数
		Set OutCPWNum=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"Out"))     //期内出径标记人数
		
		Set (CPWRatio,InRatio,OutRatio,InDrugRatio,OutDrugRatio,CloseDrugRatio)="0.00%"
		Set (InDays,OutDays,CloseDays,InCost,CloseCost,OutCost)=0
		If DischNum'=0 {
			Set CPWRatio=$fn((CPWDischNum/DischNum)*100,"",2)_"%"   //覆盖率
		}
		If CPWDischNum'=0 {
			Set InRatio=$fn((InCPWNum/CPWDischNum)*100,"",2)_"%"    //入径率
		}
		If InCPWNum'=0 {
			Set OutRatio=$fn((OutCPWNum/InCPWNum)*100,"",2)_"%"     //出径率
		}
		
		If InCPWNum'=0 {
			Set InDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDays"))
			Set InDays=$fn(InDays/InCPWNum,"",2)                   //入径病人平均住院日
			Set InCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InCost"))
			Set InDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"InDrug"))
			If InCost'=0 {
				Set InDrugRatio=$fn((InDrug/InCost)*100,"",2)_"%"  //入径病人药品费用所占比例(%)
			}
			Set InCost=$fn(InCost/InCPWNum,"",2)                   //入径病人次均费用
		}
		If OutCPWNum'=0 {
			Set OutDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDays"))
			Set OutDays=$fn(OutDays/OutCPWNum,"",2)                   //出径病人平均住院日
			Set OutCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutCost"))
			Set OutDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"OutDrug"))
			If OutCost'=0 {
				Set OutDrugRatio=$fn((OutDrug/OutCost)*100,"",2)_"%"  //出径病人药品费用所占比例(%)
			}
			Set OutCost=$fn(OutCost/OutCPWNum,"",2)                   //出径病人次均费用
		}
		If CloseCPWNum'=0 {
			Set CloseDays=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDays"))
			Set CloseDays=$fn(CloseDays/CloseCPWNum,"",2)                   //完成路径病人平均住院日
			Set CloseCost=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseCost"))
			Set CloseDrug=+$g(^TMP($zn,$j,"QryCPWDischStat","CPW",CPWDesc,"CloseDrug"))
			If CloseCost'=0 {
				Set CloseDrugRatio=$fn((CloseDrug/CloseCost)*100,"",2)_"%"  //完成路径病人药品费用所占比例(%)
			}
			Set CloseCost=$fn(CloseCost/CloseCPWNum,"",2)                   //完成路径病人次均费用
		}
		
		//科室	实施病种名称	期内出院病人总数	病种出院人数	期内入径标记人数	期内完成路径人数	期内出径标记人数	入径病人平均住院日	出径病人平均住院日	完成路径病人平均住院日	覆盖率%	入径率%	出径率%	入径病人次均费用	入径病人药品费用所占比例(%)	完成路径病人次均费用	完成路径病人药品费用所占比例(%)	出径病人次均费用	出径病人药品费用所占比例(%)
		Set Data=$lb(LocDesc,CPWDesc,DischNum,CPWDischNum,InCPWNum,CloseCPWNum,OutCPWNum,InDays,OutDays,CloseDays,CPWRatio,InRatio,OutRatio,InCost,InDrugRatio,CloseCost,CloseDrugRatio,OutCost,OutDrugRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,"QryCPWDischStat")

	Quit $$$OK
}

ClassMethod QryCPWDischStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWDischStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWDischStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWDischStatExecute ]
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

/// w ##Class(web.DHCCPW.MR.ClinPathWaysAnalysis).CheckICDToCPW(76813,"")
ClassMethod CheckICDToCPW(argMRAdm As %String, argICDType As %String) As %String
{
	New (argMRAdm,argICDType)
	Set return=""
	Quit:argMRAdm="" return
	
	Set MRAdm=argMRAdm
	
	//根据类型判断入院诊断是否符合临床路径准入标准ICD
	Set MRICD10="",MRICDDesc=""
	If argICDType="1" {
		//安徽省立 通过临床诊断的第一主要诊断来判断
		Set MRDiagnos=0
		For {
			Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
			Quit:MRDiagnos=""
			Set TypeDicCode=""
			Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
			If MRDiagType'="" {
				Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
				Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
			}
			Continue:TypeDicCode'="M" //Main(M)为主要诊断类型
			Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
			Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
			Set ICD10=$p(tmpICD,"^",4)
			Set ICDDesc=$p(tmpICD,"^",3)
			Continue:(ICD10="")||(ICDDesc="")
			Set MRICD10=ICD10
			Set MRICDDesc=ICDDesc
			Quit:(MRICD10'="")&&(MRICDDesc'="")  //取到符合标准的数据就退出（只取第一个符合的诊断）
		}
	} Else {
		//默认 通过临床诊断的第一诊断来判断
		Set MRDiagnos=$o(^MR(MRAdm,"DIA",0))
		If MRDiagnos'="" {
			Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
			Set tmpICD=##Class(web.DHCCPW.MR.SysBaseSrv).GetMRCICDDX(MRCICDDxID)
			Set ICD10=$p(tmpICD,"^",4)
			Set ICDDesc=$p(tmpICD,"^",3)
			If (ICD10'="")&&(ICDDesc'="") {
				Set MRICD10=ICD10
				Set MRICDDesc=ICDDesc
			}
		}
	}
	
	//判断此诊断符合哪条路径的准入标准,根据准入ICD来判断
	If MRICD10'="" {
		Set CPWID=0
		For {
			Set CPWID=$o(^DHCMRC("CPW",CPWID))
			Quit:CPWID=""
			Set (CPWDesc,CPWICD,CPWLebal,CurrVersion)=""
			Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			If $IsObject(objCPW) {
				Set CPWDesc=objCPW.CPWDesc
				Set CPWICD=objCPW.CPWICD
				If $IsObject(objCPW.CPWCPWDicDR) {
					Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
				}
			}
			Continue:CurrVersion'=CPWID
			Continue:$g(CPWICD)=""
			
			Set flg=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(MRICD10,CPWICD)
			Set:flg>0 return=return_$lb(CPWDesc)
		}
	}
	//w:return'="" $listtostring(return,"///"),!
	
	Quit return
}

}
