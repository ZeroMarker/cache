/// 名称: DHCHAI.STATV2.S420SHPosInf
/// 描述: 感染部位分布统计表（实时现患）
/// 编写者：liuzhenhe
/// 编写日期: 2021-09-28
Class DHCHAI.STATV2.S420SHPosInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2021-10-08
/// Description:  医院/社区感染科室部位情况统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:         aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期  
/// 			  aLocType ：科室/病区类型
/// 			  aQryCon  ：有效数据筛查
/// 			  aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S420SHPosInf","QryHCSSLocInfPos","1","2022-09-28","2022-09-28","W","2","1","437")
Query QryHCSSLocInfPos(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "2", aInfType As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,SurPatCnt:%Integer,InfPatCnt:%Integer,InfCaseCnt:%Integer,PosTypeDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryHCSSLocInfPosExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String = "", aQryCon As %String = "1", aInfType As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    Set:aLocType'="W" aLocType="E"
    Set listLocID=$listfromstring(aLocIDs,",")
   
    
    if aInfType=1 {
        set aInfType="医院感染"
    }elseif (aInfType=0){
        set aInfType="社区感染"
    }else{
        set aInfType=""
    }
    /// 取所有需要调查的科室  默认是全院科室
    Set NIndex="QryHCSSLocInfPos"
    Kill ^TMP($zn,$j,NIndex)
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
    
    set (SurPatCnt,InfPatCnt,InfCaseCnt,InfDiagCnt)=0
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        Set HospDr=$li(LocData,8)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
        For indDimens=1:1:$l(StatDimensInfo,"^") {
            Set DimensKey=$p(StatDimensInfo,"^",indDimens)
            Continue:DimensKey=""
            
            If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
            {
                Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))  //实查人数
                Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
            }
            
            If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocDr,Paadm)) {
                // 科室患者
                Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocDr,Paadm)=""    
                Set PosArray=..GetHCSSLocPos(Paadm,aDateFrom,aDateTo,aInfType)   
                For indexx1=1:1:PosArray.Count() {
                    Set PosInfo=PosArray.GetAt(indexx1)
                    Continue:PosInfo=""
                    Set DiagID  =  $LIST(PosInfo,1)
                    Set InfDate =  $LIST(PosInfo,2)
                    Set InfXDate=  $LIST(PosInfo,3)
                    Set InfEffect=  $LIST(PosInfo,4)
                    Set InfType =  $LIST(PosInfo,5)
                    Set PosTypeDesc =  $LIST(PosInfo,6) 
                    Set PosDesc =  $LIST(PosInfo,7) 
                     
                    Set:'$d(^TMP($zn,$j,NIndex,DimensKey,Paadm)) num=+$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))   //感染人数
                    if '$d(^TMP($zn,$j,NIndex,DimensKey,Paadm,DiagID)) {
                        Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))   
                        Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,PosDesc))      
                    } 
                    Set ^TMP($zn,$j,NIndex,DimensKey,Paadm,DiagID)=""
                    Set ^TMP($zn,$j,NIndex,DimensKey,"InfPosList",PosDesc)=PosTypeDesc
                }
            }   
            
        }
    }
    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
    // 输出Data
    Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
    Set xDimensKey=""
    For DimIndx=1:1:ArryStatDimens.Count() {
        Set DimList=ArryStatDimens.GetAt(DimIndx)
        Set xDimensKey  =$lg(DimList,1)
        Set DimensDesc  =$lg(DimList,3)
        Set IsActive    =$lg(DimList,4)
        Continue:xDimensKey=""
        Continue:(aHospIDs'["|")&(xDimensKey["A")        //非全院不显示"全院"
        Set LocDr = +$p(xDimensKey,"-",3)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        
        Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  //实查人数
        Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
        Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
        If (LocCount>1) {
            Set ^TMP($zn,$j,NIndex,"Sum","PatAdm")=SurPatCnt  +$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))  //实查人数
            Set ^TMP($zn,$j,NIndex,"Sum","InfPat")=InfPatCnt  +$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  //感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","InfCase")=InfCaseCnt +$g(^TMP($zn,$j,NIndex,"Sum","InfCase")) //感染例数
        }
        if '$d(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList")){
            Continue:(aQryCon'=1)&&(aQryCon'=3)
            Set Data=$lb(xDimensKey_"-"_aLocType,DimensDesc,SurPatCnt,InfPatCnt,InfCaseCnt,"","",0)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
            Continue
        }
        Set xDiag=""
        For {
            Set xDiag=$o(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiag))
            Quit:xDiag=""
            Set InfDiagDesc =xDiag     //感染诊断
            Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,xDiag)) 
            Set PosTypeDesc = $g(^TMP($zn,$j,NIndex,xDimensKey,"InfPosList",xDiag))    //部位分类（大）
            Set Data=$lb(xDimensKey_"-"_aLocType,DimensDesc,SurPatCnt,InfPatCnt,InfCaseCnt,PosTypeDesc,InfDiagDesc,InfDiagCnt)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
            If (LocCount>1) {
                Set ^TMP($zn,$j,NIndex,"Sum",xDiag)=InfDiagCnt  +$g(^TMP($zn,$j,NIndex,"Sum",xDiag)) 
                Set ^TMP($zn,$j,NIndex,"Sum","InfPosList",xDiag)=PosTypeDesc    //部位分类（大）
            }
        }
    }
    If (LocCount>1) {
        Set SurPatCnt  = +$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))    //实查人数
        Set InfPatCnt  = +$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  //感染人数
        Set InfCaseCnt = +$g(^TMP($zn,$j,NIndex,"Sum","InfCase")) //感染例数
        Set xDiag=""
        For {
            Set xDiag=$o(^TMP($zn,$j,NIndex,"Sum","InfPosList",xDiag))
            Quit:xDiag=""
            Set InfDiagDesc =xDiag
            Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,"Sum",xDiag)) //感染部位例数
            Set PosDesc =..GetDescByDesc(InfDiagDesc)

            Set Data=$lb("------"_aLocType,"全部",SurPatCnt,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHCSSLocInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHCSSLocInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHCSSLocInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHCSSLocInfPosExecute ]
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
/// Description:  获取科室患者感染部位信息(实时现患)
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos
/// Input:                      
/// return:    
/// w ##class(DHCHAI.STATV2.S420SHPosInf).GetHCSSLocPos(169,"","","")
ClassMethod GetHCSSLocPos(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aInfType As %String = "", aLoc As %String = "", aLocType As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeID,aDateFrom,aDateTo,aInfType,aLoc,aLocType)
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
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:($lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3")
		
			// 2.获取感染诊断信息（未转归，转归未治愈）
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
				// 转归情况
				Set InfEffect=""
				
				Set IRInfEffectDr=$lg(DiagsData,8)
                if IRInfEffectDr'=""{
                    Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
                    Set:IRInfEffectDr'="" InfEffect = $lg(IRInfEffectData,3)
                }
				Continue:(aDateTo'="")&&(InfDate>aDateTo) 					//感染日期大于调查结束日期表明感染还未开始
				if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
					Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
				}
				if (aLocType'="")&&(aLoc'="") {
#;                    Set TransLocId=..GetTransLocId(aEpisodeID,InfDate,InfXDate,aLocType)
#;                    Set:TransLocId'="" TransLocId=","_TransLocId_","
#;                    continue:TransLocId'[(","_aLoc_",")
                    //感染科室归属若按统计时间最后所在科室计算
                    Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,aDateTo,"00:00:01")
                    Set WardID=$p(LocInfo,"^",5)   //所在病区
                    Set LocID=$p(LocInfo,"^",1)   //所在科室
                    Continue:(aLoc'=LocID)&&(aLoc'=WardID)       
				}
				
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
                Set PosDesc=$lg(InfPosData,3)     //默认一个报告对应一个感染部位
                Set BigCode=$e(PosCode,1,2)
                Set PosData=""
                Set:BigCode'="" PosID=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
                Set:PosID'="" PosData=$g(^DHCHAI.BT.InfPosD(PosID))
				Set PosTypeDesc=$lg(PosData,3)
				
				Set InfPosData=$lb(DiagID,InfDate,InfXDate,InfEffect,InfType,PosTypeDesc,PosDesc)    //诊断id 感染时间 转归时间 转归 感染类型 感染部位分类 具体感染部位
				Set Count=Count+1
				Do return.SetAt(InfPosData,Count)
			}
		}
	}
	Quit return
}

/// 获取患者时段内所处科室
/// w ##class(DHCHAI.STATV2.S420SHPosInf).getTransLocId(169,"","","E")
ClassMethod GetTransLocId(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocType As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo,aLocType)
	Quit:(aEpisodeID="")&&(aLocType="")
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W")
	
	Set xDate="",TransLocId=""
	Set:aDateTo'="" xDate=aDateTo+1
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate),-1)
		Quit:xDate=""
		Continue:(aDateTo'="")&&(xDate>aDateTo)
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-17 Global方式
			Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xID))
			Continue:TransData=""
			Set PATransLocDr=$lg(TransData,5)
			Continue:PATransLocDr=""
			Set LocDr=PATransLocDr
            Continue:'$lg($g(^DHCHAI.BT.LocationD(LocDr)),5)
			Set LocID=LocDr
			Set TransLocId=TransLocId_","_LocID
		}
		Quit:(aDateFrom'="")&&(xDate<aDateFrom)     
	}
	Set:TransLocId'="" TransLocId=$e(TransLocId,2,*)
	Quit TransLocId
}

/// Creator：     zhoubo
/// CreatDate：   2019-11-21
/// Description:  医院/社区感染科室患者明细(实时现患)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aDimensKey: 维度
///               aInfType : 感染类型（1:医院感染、0:社区感染）
///               aPosDesc : 感染部位
/// 			  aPatFlag ：1.输出实查患者 
/// Return：      返回ROWSPEC 
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420SHPosInf","QryHCSSLocInfPosDtl","2023-02-03","2023-02-03","0003-07-0465-W-3-W","1","","")
Query QryHCSSLocInfPosDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aPatFlag As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,DiagID:%String,InfType:%String,PosDesc:%String,InfDate:%String,InfEffect:%String,InfXDate:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryHCSSLocInfPosDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aPatFlag As %String = "", aLocIDs As %Text = "") As %Status
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
    
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)     //院区
    Set:aHospIDs="0" aHospIDs=""
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")   //科室类型
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")       //科室组
    Set aLocDr=""                                                           //科室
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set:aLocType="" aLocType =$e(aDimensKey,$l(aDimensKey),$l(aDimensKey))
    Set NIndex="QryHCSSLocInfPosDtl"
    Kill ^TMP($zn,$j,NIndex)
    
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    
    //同期在科、在病区
    Set:aLocType="" aLocType=$p(aDimensKey,"-",6)
    Set:aLocType'="W" aLocType="E"  //不是病区就是科室
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed("1",aDateFrom,aDateTo,aLocType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
   
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
         
        Continue:(aLocDr'="")&(aLocDr'=LocID)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set HospDr  = $li(LocData,8)
        Continue:HospDr=""
        Set LocDesc = $li(LocData,3)
        
        //医院分组过滤
        Continue:HospDr=""
        Set HospInfo="",HospGroupDr=""
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)
        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)      

        //院区过滤
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
        Set GroupDesc=$li(GroupData,3)
        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)    
        
        If '$d(^TMP($zn,$j,NIndex,"PatAdm","Loc"_aLocDr,Paadm))
        {
            Set ^TMP($zn,$j,NIndex,"PatAdm","Loc"_aLocDr,Paadm)=""   
        }else{
            Continue
        }
       
        //患者基本信息
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
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
              //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
        
        
           
        Set PosArray=..GetHCSSLocPos(Paadm,aDateFrom,aDateTo,aInfType,aLocDr,aLocType)  
        //w ##class(DHCHAI.STATV2.S410SHCssInf).GetInfPosInfo(Paadm,aDateFrom,aDateTo,,aLocDr,aLocDr) 
        if (PosArray.Count()<1){
             if (aPatFlag=1){
                Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)_$lb("","","","","","","")
                Set ^CacheTemp(repid,ind)=Data
                Set ind=ind+1
                Continue
            }
        }
        For indexx1=1:1:PosArray.Count() {
            Set PosInfo=PosArray.GetAt(indexx1)
            Continue:PosInfo=""
            Set DiagID  =  $LIST(PosInfo,1)
            Set InfDate =  $LIST(PosInfo,2)
            Set InfXDate=  $LIST(PosInfo,3)
            Set InfEffect=  $LIST(PosInfo,4)
            Set InfType =  $LIST(PosInfo,5)
            Set PosDescType =  $LIST(PosInfo,6)  //部位（大）
            Set PosDesc =  $LIST(PosInfo,7)      //诊断
            continue:(aPosDesc'="")&&(PosDesc'=aPosDesc)
            Set:InfDate'="" InfDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
            Set:InfXDate'="" InfXDate= ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfXDate)
            
            Set InfData=$lb(DiagID,InfType,PosDesc,InfDate,InfEffect,InfXDate,InfType)
            Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)_InfData
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
		}
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHCSSLocInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHCSSLocInfPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHCSSLocInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHCSSLocInfPosDtlExecute ]
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

}
