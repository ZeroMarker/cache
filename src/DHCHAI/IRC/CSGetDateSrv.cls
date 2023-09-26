/// 名称: DHCHAI.IRC.CSGetDateSrv
/// 描述: 取筛查日期相关服务
/// 编写者：zhufei
/// 编写日期: 2017-09-01
Class DHCHAI.IRC.CSGetDateSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取入院后n天日期列表
/// Table：       DHCHAI.DP.PAAdm
/// Input：       aEpisodeID : 就诊号
///               aArg : 数值参数
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetAdmDateList()
ClassMethod GetAdmDateList(aEpisodeID As %String, aArg As %String) As %List
{
	New (aEpisodeID,aArg)
	Set return=""
	Quit:(aEpisodeID="")||(aArg="") return
	
	Set aArg=+aArg
	Quit:aArg<1 return
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate=objEpisode.PAAdmDate
	For indDate=AdmDate:1:(AdmDate+aArg-1) {
		Continue:$listfind(return,indDate)>0
		Set return=return_$lb(indDate)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取术后n天日期列表（包括手术日）
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeID : 就诊号
///               aArg : 数值参数
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList()
ClassMethod GetOperNextDateList(aEpisodeID As %String, aArg As %String) As %List
{
	New (aEpisodeID,aArg)
	Set return=""
	Quit:(aEpisodeID="")||(aArg="") return
	
	Set aArg=+aArg
	Quit:aArg<1 return
	Set OperDates=##class(DHCHAI.DPS.OROperAnaesSrv).GetOperDates(aEpisodeID)
	If OperDates'="" {
		For indDT=1:1:$listlength(OperDates) {
			Set OperDate=$listget(OperDates,indDT)
			Continue:OperDate=""
			Set return=return_$lb(OperDate)  //手术日
			For indDate=(OperDate+1):1:(OperDate+aArg) {
				Continue:$listfind(return,indDate)>0
				Set return=return_$lb(indDate)
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取术前n天日期列表（不包括手术日）
/// Table：       DHCHAI.DP.OROperAnaes
/// Input：       aEpisodeID : 就诊号
///               aArg : 数值参数
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList()
ClassMethod GetOperPrevDateList(aEpisodeID As %String, aArg As %String) As %List
{
	New (aEpisodeID,aArg)
	Set return=""
	Quit:(aEpisodeID="")||(aArg="") return
	
	Set aArg=+aArg
	Quit:aArg<1 return
	Set OperDates=##class(DHCHAI.DPS.OROperAnaesSrv).GetOperDates(aEpisodeID)
	If OperDates'="" {
		For indDT=1:1:$listlength(OperDates) {
			Set OperDate=$listget(OperDates,indDT)
			Continue:OperDate=""
			For indDate=(OperDate-aArg):1:(OperDate-1) {
				Continue:$listfind(return,indDate)>0
				Set return=return_$lb(indDate)
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取发热日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetFeverDateList()
ClassMethod GetFeverDateList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="MR-ObsFever"  //护理-发热
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Continue:$listfind(return,ActDate)>0
				Set return=return_$lb(ActDate)
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取抗菌药物使用日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetAntiDateList()
ClassMethod GetAntiDateList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="OE-AntiUse"  //医嘱-抗菌用药
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				If RepDate'="" {
					For xActDate=ActDate:1:RepDate {
						Continue:$listfind(return,xActDate)>0
						Set return=return_$lb(xActDate)
					}
				} Else {
					Continue:$listfind(return,ActDate)>0
					Set return=return_$lb(ActDate)
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取确诊感染日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetInfDiagDateList()
ClassMethod GetInfDiagDateList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xRepType=""
	For {
		Set xRepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType))
		Quit:xRepType=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,xRepType,xID))
			Quit:xID=""
			
			Set objReport=##class(DHCHAI.IR.INFReport).GetObjById(xID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.IRStatusDr)
			Set StatusCode=objReport.IRStatusDr.BTCode
			Continue:StatusCode=4   //作废|删除 //无效报告退出
			
			Set arrInfDiag=objReport.GetRepLinkObjs("DHCHAI.IR.INFDiagnos")
			Continue:arrInfDiag.Count()<1
			For indD=1:1:arrInfDiag.Count() {
				Set objInfDiag=arrInfDiag.GetAt(indD)
				Continue:'$IsObject(objInfDiag)
				Set InfDate=objInfDiag.IRInfDate
				Continue:InfDate=""
				
				Continue:$listfind(return,InfDate)>0
				Set return=return_$lb(InfDate)
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取血常规异常日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetBloodTestDateList()
ClassMethod GetBloodTestDateList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:tKeyword'="血常规"
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Continue:$listfind(return,ActDate)>0
				Set return=return_$lb(ActDate)
			}
		}
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-11-01
/// Description:  取上次入院的出院日期
/// Table：       DHCHAI.DP.PAAdm
/// Input：       aEpisodeID : 就诊号
///               aArg : 数值参数
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetLastAdmDate(111)
ClassMethod GetLastAdmDate(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
		
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set PAPatientID = objEpisode.PAPatientIDx
	Set EpisodeID= $p(objEpisode.PAEpisodeIDx,"||",2)
	Set ZIndex=$zn,JIndex=$j,NIndex="GetLastAdmDate"
	
	Kill ^TMP(ZIndex,JIndex,NIndex)  //先清空临时数据
	//^TMP(ZIndex,JIndex,NIndex
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",PAPatientID,xID))
		Quit:xID=""
		
		Set objLEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
		Quit:'$IsObject(objLEpisode)
		Continue:objLEpisode.PAAdmType'="I"  //判断住院病人
		Set LEpisodeID =$p(objLEpisode.PAEpisodeIDx,"||",2)  
		Set ^TMP(ZIndex,JIndex,NIndex,LEpisodeID)=xID     //按数字大小排序处理
	}
	Set xID = $o(^TMP(ZIndex,JIndex,NIndex,EpisodeID),-1)	//his系统下是顺序递增的
	Kill:xID="" ^TMP(ZIndex,JIndex,NIndex)  //退出前清空临时数据
	Quit:xID="" return
	Set xID = $g(^TMP(ZIndex,JIndex,NIndex,xID))
	Set objLEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xID)
	Kill:'$IsObject(objLEpisode) ^TMP(ZIndex,JIndex,NIndex)    //退出前清空临时数据
	Quit:'$IsObject(objLEpisode) return
	
	Set return = objLEpisode.PADischDate_","_objLEpisode.PADischTime
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-11-27
/// Description:  取阳性症状或体征日期
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetSxDateList(452)
ClassMethod GetSxDateList(aEpisodeDr As %String) As %List
{
	New (aEpisodeDr)
	Set return=""
	Quit:(aEpisodeDr="") return
	
	//病程-症状或体征、护理-发热
	Set tList=$lb("RME-Symptom","MR-ObsFever")
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Set ItemCode=objItmMast.CCCode
		Continue:$listfind(tList,ItemCode)<1 //筛查 症状或体征、发热、腹泻
		
		Set xActDate=""
		For {
			Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate))
			Quit:xActDate=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,xItemID,xActDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Continue:ActDate=""
				
				Set Result=obj.CCResult
				Continue:Result=""
				Set IsAbFlag=obj.CCIsAbFlag  //感染词
				
				If ItemCode="MR-ObsFever" {
					Set tActDate="Fe"_ActDate
					If $listfind(return,tActDate)<1 {
						Set return=return_$lb(tActDate)
					}
				} ElseIf ItemCode="RME-Symptom" {
					/*
					If Result["发热" {
						Set tActDate="Fe"_ActDate
						If $listfind(return,tActDate)<1 {
							Set return=return_$lb(tActDate)
						}
					}*/
					Set xKey=""
					For indKey=1:1:$l(Result,";"){
						Set xKey=$p(Result,";",indKey)
						Continue:xKey=""
						Continue:xKey["发热"
						Set tActDate="Sx"_ActDate
						If $listfind(return,tActDate)<1 {
							Set return=return_$lb(tActDate)
						}
						Quit
					}
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-01
/// Description:  取常规检验（白细胞、中性粒细胞）异常日期列表
/// Table：       DHCHAI.IR.Result
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRC.CSGetDateSrv).GetTSAbDateList()
ClassMethod GetTSAbDateList(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set xItemID=0
	For {
		Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID))
		Quit:xItemID=""
		
		Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
		Continue:'$IsObject(objItmMast)
		Continue:objItmMast.CCCode'="LAB-TestAb"  //检验-常规检验异常
		
		Set xKeyWordDr=""
		For {
			Set xKeyWordDr=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr))
			Quit:xKeyWordDr=""
			
			Set objKeyWord=##class(DHCHAI.IR.CCKeyWord).GetObjById(xKeyWordDr)
			Continue:'$IsObject(objKeyWord)
			Set tKeyword=objKeyWord.CCDesc
			Continue:(tKeyword'="血常规")&&(tKeyword'="C反应蛋白")
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrKeyWordDr",aEpisodeID,xItemID,xKeyWordDr,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				Continue:$listfind(return,ActDate)>0
				Set return=return_$lb(ActDate)
			}
		}
	}
	Quit return
}

}
