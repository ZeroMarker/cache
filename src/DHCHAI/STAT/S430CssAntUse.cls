/// 名称: DHCHAI.STAT.S430CssAntUse
/// 描述: 医院感染横断面调查
/// 编写者：chenjb
/// 编写日期: 2018-10-10
Class DHCHAI.STAT.S430CssAntUse Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2018-10-10
/// Description:  抗菌药物使用情况统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S430CssAntUse","CssQryAntUse","1","1")
Query CssQryAntUse(aSurNumID As %String, aLocModel As %String = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,HospSurSum:%String,HospAntUse:%String,HospAntUseZL:%String,AntUseZLRatio:%String,HospAntUseYF:%String,AntUseYFRatio:%String,HospAntUseZLYF:%String,AntUseZLYFRatio:%String,HospAntUseWZZ:%String,HospAntUseQT:%String,HospAntUseDL:%String,AntUseDLRatio:%String,HospAntUseEL:%String,AntUseELRatio:%String,HospAntUseSL:%String,AntUseSLRatio:%String,HospAntUseESIL:%String,AntUseESILRatio:%String,HospAntUseSLYS:%String,AntUseSLYSRatio:%String") [ SqlProc ]
{
}

ClassMethod CssQryAntUseExecute(ByRef qHandle As %Binary, aSurNumID As %String, aLocModel As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aLocModel="" aLocModel="1"
	Quit:(aSurNumID="")||(aLocModel="") $$$OK
	//Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate
 	Set SurNumber = objSExec.SESurvNumber	//
 	Quit:'$IsObject(objSExec.SEHospDr) $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(objSExec.SEHospDr.%Id(),"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	/// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="CssQryAntUse"
	Kill ^TMP($zn,$j,NIndex)
    
    Set StatDimensStr=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensStr()
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	
    //横断面调查病人就诊列表
    Set ListLocArray=##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
    For index1=1:1:ListLocArray.Count() {
		Set CSSEpisInfo=ListLocArray.GetAt(index1)
		Continue:CSSEpisInfo=""
		
		Set Paadm       = $lg(CSSEpisInfo,1)
		Set TransID     = $lg(CSSEpisInfo,2)
		Set TransLocDr  = $lg(CSSEpisInfo,3)
		Set LinkLocDr   = $lg(CSSEpisInfo,4)
		Continue:(TransID="")||(TransLocDr="")
		Set objAdmTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(TransID)
		Continue:'$IsObject(objAdmTrans)
		Set TransType=objAdmTrans.PATransType
		If TransType="E" {
			Set objLoc=objAdmTrans.PATransLocDr
			Set objWard=""
		} Else {
			Set objLoc=objAdmTrans.PALinkLocDr
			Set objWard=objAdmTrans.PATransLocDr
		}
		Continue:'$IsObject(objLoc)
		Continue:'$IsObject(objLoc.BTHospDr)
		Set HospDr=objLoc.BTHospDr.%Id()
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
		Set LocDr=objLoc.%Id()
		Set LocDesc=objLoc.BTDesc
		Set WardDr="",WardDesc=""
		If $IsObject(objWard){
			Set WardDr=objWard.%Id()
			Set WardDesc=objWard.BTDesc
		}
		Set GroupDr="",GroupDesc=""
		If $IsObject(objLoc.BTGroupDr) {
			Set GroupDr=objLoc.BTGroupDr.%Id()
			Set GroupDesc=objLoc.BTGroupDr.BTDesc
		}
		Continue:'$d(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm))
		
		Set AntDescs =..GetAntInfo(Paadm)
		Set (AntFlg,Pos,Com)=""
		If (AntDescs'="") {
			Set AntFlg = +$p(AntDescs,"^",1)
			Set Pos=$p(AntDescs,"^",2)  //目的
			Set Com=$p(AntDescs,"^",3)  //联合
		}
		//统计维度
		Set StatDimensInfo=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 实查人数
			Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
			// 全院抗菌用药人数
			If (AntFlg=1){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUse"))
				if (Pos="治疗"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseZL"))
				}ElseIf (Pos="预防"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseYF"))
				}ElseIf (Pos="治疗+预防"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseZLYF"))
				}ElseIf (Pos="无指征"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseWZZ"))
				}Else{
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseQT"))
				}
				//全院联用
				If (Com="单联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseDL"))
				}
				ElseIf (Com="二联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseEL"))
				}
				ElseIf (Com="三联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSL"))
				}
				ElseIf (Com="四联"){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseESIL"))
				}Else{
					//四联以上
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntUseSLYS"))
				}
			}
		}
	}
	
	Set xDimensKey="",RowIndex=0
	For {
		Set xDimensKey=$o(^TMP($zn,$j,NIndex,xDimensKey))
		Quit:xDimensKey=""
		// 全院
		Set HospSurSum     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //全院实查人
		Set HospAntUse     =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUse"))
		Set HospAntUseZL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseZL"))
		Set HospAntUseYF   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseYF"))
		Set HospAntUseZLYF =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseZLYF"))  
		Set HospAntUseWZZ  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseWZZ")) 
		Set HospAntUseQT   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseQT")) 
		Set HospAntUseDL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseDL"))
		Set HospAntUseEL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseEL")) 
		Set HospAntUseSL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSL"))  
		Set HospAntUseESIL   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseESIL")) 
		Set HospAntUseSLYS   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntUseSLYS")) 
		
		Set (AntUseZLRatio,AntUseYFRatio,AntUseZLYFRatio)="0.00%"
		Set:HospSurSum>0 AntUseZLRatio=$fn((HospAntUseZL/HospSurSum)*100,"",2)_"%" //治疗占比
		Set:HospSurSum>0 AntUseYFRatio=$fn((HospAntUseYF/HospSurSum)*100,"",2)_"%" //治疗占比
		Set:HospSurSum>0 AntUseZLYFRatio=$fn((HospAntUseZLYF/HospSurSum)*100,"",2)_"%" //治疗占比
		Set (AntUseDLRatio,AntUseELRatio,AntUseSLRatio,AntUseESILRatio,AntUseSLYSRatio)="0.00%"
		Set:HospSurSum>0 AntUseDLRatio=$fn((HospAntUseDL/HospSurSum)*100,"",2)_"%" //联用占比
		Set:HospSurSum>0 AntUseELRatio=$fn((HospAntUseEL/HospSurSum)*100,"",2)_"%" //联用占比
		Set:HospSurSum>0 AntUseSLRatio=$fn((HospAntUseSL/HospSurSum)*100,"",2)_"%" //联用占比
		Set:HospSurSum>0 AntUseESILRatio=$fn((HospAntUseESIL/HospSurSum)*100,"",2)_"%" //联用占比
		Set:HospSurSum>0 AntUseSLYSRatio=$fn((HospAntUseSLYS/HospSurSum)*100,"",2)_"%" //联用占比
		
		Set DimensDesc=##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc(xDimensKey)
		Set RowIndex=RowIndex+1
		Set Data=$lb(xDimensKey,DimensDesc,HospSurSum,HospAntUse,HospAntUseZL,AntUseZLRatio,HospAntUseYF,AntUseYFRatio,HospAntUseZLYF,AntUseZLYFRatio,HospAntUseWZZ,HospAntUseQT)
		Set Data=Data_$lb(HospAntUseDL,AntUseDLRatio,HospAntUseEL,AntUseELRatio,HospAntUseSL,AntUseSLRatio,HospAntUseESIL,AntUseESILRatio,HospAntUseSLYS,AntUseSLYSRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryAntUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryAntUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetCurrInfPosInfo("2561","64728","64870")
ClassMethod GetCurrInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Quit:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode="4"
		// 感染诊断信息
		Set LinkDiags = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
		
		For indx = 1:1:$l(LinkDiags,","){
			Set xDiagID = $p(LinkDiags,",",indx)
			Continue:xDiagID=""
			
			Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
			Continue:'$IsObject(objDiags)
			// 感染日期
			Set InfDate  = objDiags.IRInfDate
			Set InfXDate = objDiags.IRInfXDate
			Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
			Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
			// 感染诊断
			Set objInfPos = objDiags.IRInfPosDr
			If $IsObject(objInfPos){
				Set InfPosDescs = InfPosDescs_"|"_xDiagID_"^"_objInfPos.BTDesc
			}
		}
	}

	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetSurInfo("3")
ClassMethod GetSurInfo(aSurNumID As %String) As %String
{
	New (aSurNumID)
	
	Set return = ""
	Quit:aSurNumID="" return
	Set objS = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Set DateFrom 	= objS.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set DateTo 	= objS.SESurvEndDate
 	Set SurNumber = objS.SESurvNumber	//
 	Quit:'$IsObject(objS.SEHospDr) return
 	Set DateFrom =##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DateFrom)
 	Set DateTo =  ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DateTo)
 
 	Set return = DateFrom_"^"_DateTo_"^"_SurNumber_"^"_objS.SEHospDr.%Id()
 	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  横断面明细表
/// Table：       DHCHAI.DP.PAAdm
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STAT.S410CssInf","QryCSSInfPatDtl","3","")
Query QryCSSInfPatDtl(aSurNumID As %String, aTypeFlg As %String = "", aLocDesc As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,RepID:%String,InfType:%String,InfDates:%String,InfPosDescs:%String,InfEffects:%String") [ SqlProc ]
{
}

ClassMethod QryCSSInfPatDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aTypeFlg As %String = "", aLocDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set objSExec = ##class(DHCHAI.IR.SurveyExec).GetObjById(aSurNumID)
	Quit:'$IsObject(objSExec) $$$OK
 	Set aDateFrom 	= objSExec.SESurvSttDate    //通过调查定义表取开始结束日期
 	Set aDateTo 	= objSExec.SESurvEndDate 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set xEpisodeID = ""
	For {
		Set xEpisodeID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xEpisodeID))
		Quit:xEpisodeID=""    
				
		Set PatData =..BuildPaadmData(xEpisodeID)
		Continue:PatData=""		    
		Set (RepID,InfType,InfDate,InfDiag,InfZG) =""
		if (aTypeFlg="1")
		{
			Set xRepID = ""
			For {
				Set xRepID = $o(^DHCHAI.IR.INFReportI("IndexPaadmType",xEpisodeID,"7",xRepID))
				Quit:xRepID=""
				//取报告里的信息
				Set xObjRep = ##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
				if $Isobject(xObjRep) {
					Set RepID = xRepID
					Set LinkCSSs = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
					Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
					if $IsObject(xObj) {
						Set InfType = xObj.IRInfCategoryDr  //0院内/1社区感染						
					}
					// 感染诊断信息
					Set LinkDiags = xObjRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
					
					For indx = 1:1:$l(LinkDiags,","){
						Set xDiagID = $p(LinkDiags,",",indx)
						Continue:xDiagID=""
						
						Set objDiags = ##class(DHCHAI.IR.INFDiagnos).GetObjById(xDiagID)
						Continue:'$IsObject(objDiags)
						// 感染日期
						Set InfDate  = objDiags.IRInfDate
						Set InfXDate = objDiags.IRInfXDate
						
						Continue:InfDate>aDateTo    // 感染日期大于查询截止日期，非查询期间发生感染
						Continue:(InfXDate'="")&(InfXDate<=aDateTo) // 调查期间感染已结束
						Set:$IsObject(objDiags.IRInfEffectDr) InfZG = objDiags.IRInfEffectDr.BTDesc
						// 感染诊断						
						Set objInfPos = objDiags.IRInfPosDr
						
						If $IsObject(objInfPos){
							Set InfDiag = objInfPos.BTDesc							
							Set Data=PatData_$lb(RepID,InfType,InfDate,InfDiag,InfZG)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}						
					}
				}
			}			
		}    
		else
		{			
			Set Data=PatData_$lb(RepID,InfType,InfDate,InfDiag,InfZG)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}

	}
	Quit $$$OK
}

ClassMethod QryCSSInfPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSInfPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSInfPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSInfPatDtlExecute ]
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

ClassMethod BuildPaadmData(aEpisodeID) As %String
{
	Set return=""
	Quit:aEpisodeID="" return
	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) return
	
	Set EpisodeIDx = objPaadm.PAEpisodeIDx
	Set SCode = $p(EpisodeIDx,"||",1)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set PapmiNo = objPaadm.PAPapmiNo
	Set MrNo = objPaadm.PAMrNo
	Set PatName = objPaadm.PAPatName
	Set Sex = objPaadm.PASex
	Set Sex = $s(Sex="M":"男",Sex="F":"女",1:"")
	Set Age = objPaadm.PAAge
	Set AdmType = objPaadm.PAAdmType
	
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
	
	Set VisitStatus = objPaadm.PAVisitStatus
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Set AdmDate = objPaadm.PAAdmDate
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime = objPaadm.PAAdmTime
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set objAdmLoc = objPaadm.PAAdmLocDr
	Set AdmLocDesc=""
	If $isobject(objAdmLoc) {
		Set LocDesc2 = objAdmLoc.BTDesc2
		Set LocDesc = objAdmLoc.BTDesc
		Set AdmLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objAdmWard = objPaadm.PAAdmWardDr
	Set AdmWardDesc=""
	If $isobject(objAdmWard) {
		Set WardDesc2 = objAdmWard.BTDesc2
		Set WardDesc = objAdmWard.BTDesc
		Set AdmWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}

	Set AdmRoom = objPaadm.PAAdmRoom
	Set objAdmBed = objPaadm.PAAdmBedDr
	Set AdmBed=""
	If $isobject(objAdmBed) {
		Set AdmBed = objAdmBed.BTDesc
	}
	Set DischDate = objPaadm.PADischDate
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set DischTime = objPaadm.PADischTime
	Set:DischTime'="" DischTime=$zt(DischTime)
    
    Set objDischLoc = objPaadm.PADischLocDr
	Set DischLocDesc=""
	If $isobject(objDischLoc) {
		Set LocDesc2 = objDischLoc.BTDesc2
		Set LocDesc = objDischLoc.BTDesc
		Set DischLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
	}
	Set objDischWard = objPaadm.PADischWardDr
	Set DischWardDesc=""
	If $isobject(objDischWard) {
		Set WardDesc2 = objDischWard.BTDesc2
		Set WardDesc = objDischWard.BTDesc
		Set DischWardDesc = $s(WardDesc2'="":WardDesc2,1:WardDesc)
	}
	
	Set AdmDateTime=AdmDate_" "_AdmTime
	Set DischDateTime=DischDate_" "_DischTime

	Set return = $lb(aEpisodeID,PapmiNo,MrNo,PatName,Sex,Age,AdmType,VisitStatus,AdmDateTime,AdmLocDesc,AdmWardDesc,AdmRoom,AdmBed,DischDateTime,DischLocDesc,DischWardDesc)
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-10-11
/// Description:  判断横断面是否发生医院感染,返回现患感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STAT.S410CssInf).GetCurrInfPosInfo("2561")
ClassMethod GetAntInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set RepType="7"  //横断面调查

	Set xID = ""
	For {
		Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
		Quit:xID=""
		Set objINFRep=##class(DHCHAI.IR.INFReport).GetObjById(xID)
		Quit:'$IsObject(objINFRep)
		Set RepStatus=objINFRep.IRStatusDr
		Continue:'$IsObject(RepStatus)        //1 保存 2 提交 3 审核 4 作废
		Continue:RepStatus.BTCode="4"
		Continue:return'=""
		
		Set LinkCSSs = objINFRep.GetRepLinkIDs("DHCHAI.IR.INFCSS")
		Continue:LinkCSSs=""
		Set xObj = ##class(DHCHAI.IR.INFCSS).GetObjById(+LinkCSSs)  //子父表一对一
		Continue:'$IsObject(xObj)
		Set (AntUsePurpose,CombinedMed)=""
		Set AntiIsUser    = xObj.IRAntiFlag      //是否抗菌药物
		Set objAntPur     = xObj.IRAntiUsePurposeDr
		Set:$Isobject(objAntPur) AntUsePurpose=objAntPur.BTDesc
		Set objCombineMed = xObj.IRAntiCombinedMedDr
		Set:$Isobject(objCombineMed) CombinedMed =objCombineMed.BTDesc 		
		Set return = AntiIsUser_"^"_AntUsePurpose_"^"_CombinedMed
	}
	Quit return
}

}
