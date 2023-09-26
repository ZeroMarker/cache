/// 名称: DHCHAI.STATV2.S450SHCSSPosBac
/// 描述: 医院感染病原体感染部位分布统计表（实时现患）
/// 编写者: liuzhenhe
/// 编写日期: 2021-09-26
Class DHCHAI.STATV2.S450SHCSSPosBac Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-12-30
/// Description:  医院/社区感染病原体感染部位分布（实时现患）
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aStaType ：科室/病区类型
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450SHCSSPosBac","QryHCSSBacInfPos","","2022-12-30","2022-12-30","E")
Query QryHCSSBacInfPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aInfType As %String = "") As %Query(ROWSPEC = "BacName:%String,InfCaseCnt:%String,PosTypeDesc:%String,InfDiagDesc:%String,InfDiagCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryHCSSBacInfPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aInfType As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    
    If aInfType=1 {
		set aInfType="医院感染"
	}Elseif (aInfType=0){
		set aInfType="社区感染"
	}Else{
		set aInfType=""
	}
	
    Set NIndex="QryHCSSBacInfPos"
	Kill ^TMP($zn,$j,NIndex)
    Set StatType=aStaType
	Set:aStaType'="W" StatType="E"  //不是病区就是科室
        //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,aStaType)         
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""

        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		continue:$d(^TMP($zn,$j,NIndex,"Paadm",Paadm))
		Set ^TMP($zn,$j,NIndex,"Paadm",Paadm)=""
		Set BacPosArray =..GetHCSSBacPos(Paadm,aDateFrom,aDateTo,aInfType)
		For indexx1=1:1:BacPosArray.Count() {
			Set BacPosInfo=BacPosArray.GetAt(indexx1)
			Continue:BacPosInfo=""
			Set Bacteria=  $LIST(BacPosInfo,2)
			Set InfPosDescs=  $LIST(BacPosInfo,4)
			continue:InfPosDescs=""
			For indxxxi=1:1:$l(InfPosDescs,"|") {
				Set tmpPos = $p(InfPosDescs,"|",indxxxi)
				Continue:tmpPos=""
				Set InfPosDesc=$p(tmpPos,"^",2)
				Set PosTypeDesc=$p(tmpPos,"^",5)
				Continue:Bacteria=""
				Continue:InfPosDesc=""    //感染诊断
				Continue:PosTypeDesc=""      //诊断部位
				
				Set ^TMP($zn,$j,NIndex,"InfPosList",Bacteria,InfPosDesc)=PosTypeDesc
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",Bacteria,InfPosDesc)) 
				Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",Bacteria)) //感染例数
			}
		}
	}	
	// 输出Data
	Set xBacName=""
	For {
		Set xBacName=$o(^TMP($zn,$j,NIndex,"InfPosList",xBacName))
		Quit:xBacName=""
			
		Set xDiag = ""
	 	For {
			Set xDiag = $o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag))
			Quit:xDiag=""	
			
			Set InfDiagDesc  =xDiag
			Set InfCaseCnt 	 =$g(^TMP($zn,$j,NIndex,"InfCase",xBacName)) //感染例数
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			Set PosTypeDesc      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag))
			Set Data=$lb(xBacName,InfCaseCnt,PosTypeDesc,InfDiagDesc,InfDiagCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1	
	 	}
	}	
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHCSSBacInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHCSSBacInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHCSSBacInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHCSSBacInfPosExecute ]
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

/// Creator：     liuzhenhe
/// CreatDate：   2021-09-28
/// Description:  获取患者病原体感染部位信息(实时现患)
/// Table：       
/// Input:                      
/// return:    
/// w ##class(DHCHAI.STATV2.S450SHCSSPosBac).GetHCSSBacPos(169,"","","")
ClassMethod GetHCSSBacPos(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfType)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aEpisodeID="") return
	// 1. 遍历患者（已审核）院感报告
	Set RepType="",Count=0
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")

		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			
			// Add by zhaoyj 2022-06-17 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""                  //1 保存 2 提交 3 审核 4 作废
			Continue:($lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3")
		
			// 2.获取感染诊断信息（未转归，转归未治愈）
            Set xSub=0,InfPosDescs=""
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""	
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				// 转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
                if (IRInfEffectDr'=""){
				Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
				Set:IRInfEffectDr'="" InfEffect = $lg(IRInfEffectData,3)
                }
				Continue:(aDateTo'="")&&(InfDate>aDateTo) 					//感染日期大于调查结束日期表明感染还未开始
				if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
					Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
				}
			
				Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
			
				/// 感染类型（社区感染0、医院感染1）
                Set IRInfType=$lg(DiagsData,18)
                Set:IRInfType="" IRInfType=1
                Set InfType=$s(IRInfType=0:"社区感染",IRInfType=1:"医院感染",1:InfType)
                Continue:(aInfType'="")&&(aInfType'=InfType)
              
				// 感染诊断
				Continue:$lg(DiagsData,3)=""
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
                continue:InfPosData=""
                Set PosCode=$lg(InfPosData,2)
                Set BigCode=$e(PosCode,1,2)
                Set PosDiagData=""
                Set:BigCode'="" PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set BigPosDesc=$lg(PosDiagData,3)
				
				Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfType_"^"_BigPosDesc
			}
			
			Continue:InfPosDescs=""
			Set InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			// 3. 获取病原体信息
			Set xLabSub=0
			For {
				Set xLabSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFLab","U"),xID,xLabSub))
				Quit:xLabSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xLabSub))
				Continue:INFRepExtData=""
                Set xLabID=$lg(INFRepExtData,3)
                Set INFLabData = $g(^DHCHAI.IR.INFLabD(xLabID))
				Continue:INFLabData=""
				Continue:$lg(INFLabData,2)=""
				
				Set xSubID = ""
				For {
					Set xSubID = $o(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
					Quit:xSubID=""
					
                    Set INFLabBactData = $g(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
					Continue:INFLabBactData=""
					Set IRBactDicDr=$lg(INFLabBactData,2)
					Continue:IRBactDicDr=""
					Set Bacteria = $lg($g(^DHCHAI.DP.LabBacteriaD(IRBactDicDr)),3)
					Set BactData=$lb(aEpisodeID,Bacteria,xLabID,InfPosDescs)
					Set Count=Count+1
					Do return.SetAt(BactData,Count)
				}
			}
		}
	}
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-12-30
/// Description:  获取患者病原体、感染部位信息(实时现患)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
///               aInfType : 感染类型（1:医院感染、0:社区感染)
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S450SHCSSPosBac).GetInfPosInfo("133",$zdh("2019-12-01",3),$zdh("2019-12-30",3),1)
ClassMethod GetInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfType As %String = "") As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfType)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	Set aInfType=$s(aInfType=1:"医院感染",aInfType=0:"社区感染",1:"")
	Set RepType=""
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1")
		
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-17 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData,3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:(InfDate>aDateTo) //感染日期大于调查结束日期表明感染还未开始
				Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
				Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
				Set:InfXDate'="" InfXDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
				/// 感染类型（社区感染0、医院感染1）
                Set IRInfType=$lg(DiagsData,18)
                Set:IRInfType="" IRInfType=1
                Set InfType=$s(IRInfType=0:"社区感染",IRInfType=1:"医院感染",1:InfType)
                
                Continue:(aInfType'="")&&(aInfType'=InfType)
				// 感染诊断
				Continue:$lg(DiagsData,3)=""
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
                continue:InfPosData=""
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Set PosID=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set PosData=$g(^DHCHAI.BT.InfPosD(PosID))
				Set BigPosDesc=$lg(PosData,3)
				Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfType_"^"_PosTypeDesc_"^"_InfXDate
			}
			Continue:InfPosDescs=""
		
			Set Bacterias=""
			Set xLabSub=0
			For {
				Set xLabSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFLab","U"),xID,xLabSub))
				Quit:xLabSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xLabSub))
				Continue:INFRepExtData=""
				Set LabID=$lg(INFRepExtData,3)
				Continue:LabID=""
			
				Set INFLabData = $g(^DHCHAI.IR.INFLabD(LabID))
				Continue:INFLabData=""
				Continue:$lg(INFLabData,2)=""
				
				Set xSubID = ""
				For {
					Set xSubID = $o(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
					Quit:xSubID=""
					
                    Set INFLabBactData = $g(^DHCHAI.IR.INFLabD(xLabID,"BACT",xSubID))
					Continue:INFLabBactData=""
					Set IRBactDicDr=$lg(INFLabBactData,2)
					Continue:IRBactDicDr=""
					Set Bacteria = $lg($g(^DHCHAI.DP.LabBacteriaD(IRBactDicDr)),3)

					Set Bacterias = Bacterias_"^"_Bacteria
                    Set DimensData=$lb(DimenCode,LocID,"    "_LocDesc,IsActive)
					Set Count=Count+1
					Do return.SetAt(DimensData,Count)
				}
			}
			Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
			Set:Bacterias'="" Bacterias = $e(Bacterias,2,$length(Bacterias))
			Set:InfPosDescs'="" return=return_"#"_InfPosDescs_","_Bacterias
		}
	}
	Set:return'="" return = $e(return,2,$length(return))
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2021-09-28
/// Description:  医院/社区感染病原体感染部位分布统计病人明细
/// Table：       
/// Input:       
///               aInfType : 感染类型（医院感染、社区感染）
///               aPosDesc : 感染部位                   
/// return:  
/// d ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S450SHCSSPosBac","QryHCSSBacInfPosDtl","1","2022-12-15","2022-12-15","E","1","","")     
Query QryHCSSBacInfPosDtl(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String = "", aInfType As %String = "", BacName As %String = "", aPosDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,PosTypeDesc:%String,InfDiagDesc:%String,InfDate:%String,InfXDate:%String,InfType:%String,InfEffect:%String,CollDateTime:%String,LabEpisodeNo:%String,Specimen:%String,LabRepDate:%String,TSDesc:%String,RuleMRB:%String,Bacteria:%String") [ SqlProc ]
{
}

ClassMethod QryHCSSBacInfPosDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String = "", aInfType As %String = "", BacName As %String = "", aPosDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ^TMPLH($zn,$j)=$lb(aHospIDs, aDateFrom, aDateTo, aStaType, aInfType, BacName, aPosDesc)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    If aInfType=1 {
		set aInfType="医院感染"
	}Elseif (aInfType=0){
		set aInfType="社区感染"
	}Else{
		set aInfType=""
	}
	
    Set NIndex="QryHCSSBacInfPosDtl"
	Kill ^TMP($zn,$j,NIndex)

    Set:aStaType'="W" aStaType="E"  //不是病区就是科室
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,aStaType)         
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""

        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        Set HospDr=$li(LocData,8)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
        continue:$d(^TMP($zn,$j,NIndex,"Paadm",Paadm))
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
        Set GroupDesc=$li(GroupData,3)
        Set LocDesc=""
        If LocData'="" {
            Set LocDesc2   = $li(LocData,4)
            Set tmpLocDesc = $li(LocData,3)
            Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        Set TransDate=$li(TransData,7)
        Set:TransDate'="" TransDate=$zd(TransDate,3)
        Set TransTime=$li(TransData,8)
        Set:TransTime'="" TransTime=$zt(TransTime,1)
        Set OutLocDate=$li(TransData,10)
        Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
        Set OutLocTime=$li(TransData,11)
        Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
        Set TransDateTime=TransDate_" "_TransTime
        Set OutLocDateTime=OutLocDate_" "_OutLocTime
        Set ^TMP($zn,$j,NIndex,"Paadm",Paadm)=""
        Set BacPosArray =..GetHCSSBacPos(Paadm,aDateFrom,aDateTo,aInfType)
        For indexx1=1:1:BacPosArray.Count() {
            Set BacPosInfo=BacPosArray.GetAt(indexx1)
            Continue:BacPosInfo=""
            Set Bacteria=  $LIST(BacPosInfo,2)
            Set LabID = $LIST(BacPosInfo,3)
            Set InfPosDescs=  $LIST(BacPosInfo,4)
            Set objRuleMRB = ##class(DHCHAI.IRS.CCResultSrv).GetMRBType(Paadm,"",Bacteria)
            Set RuleMRB=""
            If $IsObject(objRuleMRB){
                Set RuleMRB = objRuleMRB.BTDesc     // 多耐类型
            }

            continue:InfPosDescs=""
            For indxxxi=1:1:$l(InfPosDescs,"|") {
                Set tmpPos = $p(InfPosDescs,"|",indxxxi)
                Continue:tmpPos=""
                Set DiagID=$p(tmpPos,"^",1)
                Set InfPosDesc=$p(tmpPos,"^",2)
                Set InfDate=$p(tmpPos,"^",3)
                Set InfType=$p(tmpPos,"^",4)
                Set PosTypeDesc=$p(tmpPos,"^",5)
                Set InfXDate=$p(tmpPos,"^",6)
                
                Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
                Continue:DiagsData=""
                // 转归情况
                Set InfEffect=""
                Set IRInfEffectDr=$lg(DiagsData,8)
                if (IRInfEffectDr'=""){
                    Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
                    Set:IRInfEffectDr'="" InfEffect = $lg(IRInfEffectData,3)
                }
                Continue:Bacteria=""
                Continue:(BacName'="")&&(BacName'=Bacteria)
                Continue:InfPosDesc=""    //感染诊断
                Continue:(aPosDesc'="")&&(aPosDesc'=InfPosDesc)
                Continue:PosTypeDesc=""      //诊断部位(大)
                
                Set PatData =..BuildPaadmData(Paadm)
                Set DimensDesc="全部"  //科室、病区名称
                Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
                Set ^CacheTemp(repid,ind)=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)_$lb(PosTypeDesc,InfPosDesc,InfDate,InfXDate,InfType,InfEffect)_..GetLabInfoByID(LabID)_$lb(RuleMRB,Bacteria) 
				Set ind=ind+1	
			}
		}
	}		
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHCSSBacInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHCSSBacInfPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHCSSBacInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHCSSBacInfPosDtlExecute ]
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

/// Description:  根据LabID 获取(采样时间 送检标本号 标本  报告时间    检验医嘱)
/// Table：       DHCHAI.IR.INFLab 、 DHCHAI.DP.LabVisitReport
/// Input:        aLabID            
/// return:       $lb
/// Creator：     liuzhenhe
/// CreatDate：   2023-01-06
/// zw ##class(DHCHAI.STATV2.S450SHCSSPosBac).GetLabInfoByID(3)
ClassMethod GetLabInfoByID(aLabID As %String = "")
{
    new (aLabID)
    Set (CollDateTime,LabEpisodeNo,Specimen,LabRepDate,TSDesc)=""
    Set return=$lb(CollDateTime,LabEpisodeNo,Specimen,LabRepDate,TSDesc)
    Quit:aLabID="" return
    Set LabData=$g(^DHCHAI.IR.INFLabD(aLabID))
    Quit:LabData="" return
    
    Set TSDesc=$lg(LabData,4)   
    Set TSDesc2=$lg(LabData,5)  //检验医嘱-对照
    Set SpecimenDr=$lg(LabData,6) //标本ID

    Set SubmissDate=$lg(LabData,7)   //送检日期
    Set:SubmissDate'="" SubmissDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SubmissDate)
    Set SubmissLocDr=$lg(LabData,8)
    Set LocDesc=$lg($g(^DHCHAI.BT.LocationD(SubmissLocDr)),3)  
    Set LocDesc2=$lg($g(^DHCHAI.BT.LocationD(SubmissLocDr)),4)
    Set SubmissLoc = $s(LocDesc2'="":LocDesc2,1:LocDesc) //送检科室


    Set SpecimenID=$lg(LabData,6)
    Set objSpecimen=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecimenID)
    Set Specimen=""
    Set:$IsObject(objSpecimen) Specimen = objSpecimen.BTSpecDesc    // 标本
    Set IRLabRepDr=$lg(LabData,3) //报告ID
   
    if (IRLabRepDr'=""){
        Set LabRepData=$g(^DHCHAI.DP.LabVisitReportD(IRLabRepDr)) 

        if LabRepData'="" {
            Set LabAuthDate= $lg(LabRepData,10)   // 报告时间
            Set LabAuthTime= $lg(LabRepData,11)
            Set:LabAuthDate'="" LabRepDate=$zd(LabAuthDate,3)_" "_$zt(LabAuthTime,1)
            Set LabVisitNumberDr=$lg(LabRepData,2)
            Set LabVisitNumberData=$g(^DHCHAI.DP.LabVisitNumberD(LabVisitNumberDr))
            Set LabEpisodeNo= $lg(LabVisitNumberData,3)    //标本号
            Set LabCollDate= $lg(LabVisitNumberData,8)          //采集日期
            Set LabCollTime= $lg(LabVisitNumberData,9)  //采集时间
            
            Set LabRecDate= $lg(LabVisitNumberData,11)  //接受日期
            Set LabRecTime= $lg(LabVisitNumberData,12)  //接受时间

            Set:LabCollDate'="" CollDateTime=$zd(LabCollDate,3)_" "_$zt(LabCollTime,1)
            Set:(CollDateTime="")&&(LabRecDate'="") CollDateTime=$zd(LabRecDate,3)_" "_$zt(LabRecTime,1)
            
        }

    }
    Set:TSDesc="" TSDesc=TSDesc2
    Set:CollDateTime="" CollDateTime=SubmissDate
    Set return=$lb(CollDateTime,LabEpisodeNo,Specimen,LabRepDate,TSDesc)
    Quit return
}

}
