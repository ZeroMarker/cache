/// 名称: DHCHAI.STATV2.S450CSSPosBac
/// 描述: 住院患者医院感染部位分布统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-20
Class DHCHAI.STATV2.S450CSSPosBac Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  住院患者医院感染部位分布统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID： 调查编号  
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryCSSBacInfPos","3","1")
Query QryCSSBacInfPos(aSurNumID As %String, aInfType As %String = "") As %Query(ROWSPEC = "BacName:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryCSSBacInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
	Quit:SurvData="" $$$OK
 	Set aDateFrom = $lg(SurvData,5)    //通过调查定义表取开始结束日期
 	Set aDateTo   = $lg(SurvData,6)
 	Set SurNumber = $lg(SurvData,2)
 	Set aHospDr    = $lg(SurvData,3)
 	Quit:aHospDr="" $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//（1:医院感染、0:社区感染）
    Set aInfType=$s(aInfType=1:"医院",aInfType=0:"社区",1:"")
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
	/// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="QryCSSBacInfPos"
	Kill ^TMP($zn,$j,NIndex)
	
	Set xPaadm = ""
	For {
		Set xPaadm = $o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xPaadm))
		Quit:xPaadm=""
		
		Set xCSSID=""
		For {
			Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xPaadm,xCSSID))
			Quit:xCSSID=""
			
			// Add by zhaoyj 2022-06-17 Global方式
			Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
			Continue:CSSData=""
			Continue:$lg(CSSData,5)'=1
			Continue:$lg(CSSData,6)=""
			Set InfCategory = ""
			Set IRInfCategoryDr=$lg(CSSData,7)
			Set:IRInfCategoryDr'="" InfCategory = $lg($g(^DHCHAI.BT.DictionaryD(IRInfCategoryDr)),3)
			Set InfectionDesc = $lg($g(^DHCHAI.BT.DictionaryD($lg(CSSData,6))),3)
			Set:InfectionDesc="不存在" InfCategory=""
             Continue:(aInfType'="")&&(InfCategory'[aInfType)
			//过滤删除的报告
			Set ReportID=""
			Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
			For indRep=1:1:arrReport.Count() {
				Set RepData=arrReport.GetAt(indRep)
				Continue:RepData=""
				Set ReportID=$lg(RepData,20)
				Set IRStatusDr=$lg(RepData,8)
				Continue:IRStatusDr=""
				Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
				//1保存、2提交、3审核、4作废、5退回、6取消审核
				Continue:(RepStatus="4")
                Set ReportID=$lg(RepData,1)
			}
			Continue:ReportID=""
            If (aInfType="医院"){
				Set IRInfPathogen1 = $lg(CSSData,8)
                Set InfPosDr = $p(IRInfPathogen1,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen1,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen1,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen1,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
                Set IRInfPathogen = $lg(CSSData,9)
                Set InfPosDr = $p(IRInfPathogen,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
                Set IRInfPathogen = $lg(CSSData,10)
                Set InfPosDr = $p(IRInfPathogen,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
            }ElseIf aInfType="社区"{
                Set IRInfPathogen1 = $lg(CSSData,12)
                Set InfPosDr = $p(IRInfPathogen1,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen1,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen1,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen1,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
                Set IRInfPathogen = $lg(CSSData,13)
                Set InfPosDr = $p(IRInfPathogen,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
                Set IRInfPathogen = $lg(CSSData,14)
                Set InfPosDr = $p(IRInfPathogen,"#",1)
                If (InfPosDr'=""){
                    do BuildInfDesc
                    Set InfBacDr1 = $p(IRInfPathogen,"#",2)
                    If (InfBacDr1'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr1)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr2 = $p(IRInfPathogen,"#",4)
                    If (InfBacDr2'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr2)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                    Set InfBacDr3 = $p(IRInfPathogen,"#",6)
                    If (InfBacDr3'=""){
                        Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr3)),3)
                        Set ^TMP($zn,$j,NIndex,"InfPosList",InfBacDesc,InfPosDesc)=PosDesc
                        // 记录感染部位数量
                        Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",InfBacDesc,InfPosDesc))
                    }
                }
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
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			Set PosDesc      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag))
			Set Data=$lb(xBacName,PosDesc,InfDiagDesc,InfDiagCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
	 	}
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildInfDesc
    if (+CSSRepPosDispalyConfig=0){
         Set InfPosDesc=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr)),3)
         Set PosDesc =InfPosDesc
    }else{
         Set InfPosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),3)
         Set PosDesc =..GetDescByDesc(InfPosDesc)
    }
}

ClassMethod QryCSSBacInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSBacInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
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
/// CreatDate：   2022-12-1
/// Description:  医院感染病原体感染部位分布
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID： 调查编号  
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryCSSBacInfPosDetail","2","0","抗菌药物相关性腹泻","厄氏菌属")
Query QryCSSBacInfPosDetail(aSurNumID As %String, aInfType As %String = "", aDiagDesc As %String = "", aInfBacDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,PosDesc:%String,InfBacDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCSSBacInfPosDetailExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfType As %String = "", aDiagDesc As %String = "", aInfBacDesc As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Set ^TMPLH=aDiagDesc_"!"_aInfBacDesc
    Quit:(aSurNumID="") $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set aDateFrom = $lg(SurvData,5)    //通过调查定义表取开始结束日期
    Set aDateTo   = $lg(SurvData,6)
    Set SurNumber = $lg(SurvData,2)
    Set aHospDr    = $lg(SurvData,3)
    Quit:aHospDr="" $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    //（1:医院感染、0:社区感染）
    Set aInfType=$s(aInfType=1:"医院",aInfType=0:"社区",1:"")
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    /// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="QryCSSBacInfPosDetail"
    Kill ^TMP($zn,$j,NIndex)
    
    Set xPaadm = ""
    For {
        Set xPaadm = $o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xPaadm))
        Quit:xPaadm=""
        Set PatData =..BuildPaadmData(xPaadm)
        Continue:PatData=""
        Set xCSSID=""
        For {
            Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,xPaadm,xCSSID))
            Quit:xCSSID=""
            
            // Add by zhaoyj 2022-06-17 Global方式
            Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
            Continue:CSSData=""
            Continue:$lg(CSSData,5)'=1
            Continue:$lg(CSSData,6)=""
            Set InfCategory = ""
            Set IRInfCategoryDr=$lg(CSSData,7)
            Set:IRInfCategoryDr'="" InfCategory = $lg($g(^DHCHAI.BT.DictionaryD(IRInfCategoryDr)),3)
            Set InfectionDesc = $lg($g(^DHCHAI.BT.DictionaryD($lg(CSSData,6))),3)
            Set:InfectionDesc="不存在" InfCategory=""
             Continue:(aInfType'="")&&(InfCategory'[aInfType)
            //过滤删除的报告
            Set ReportID=""
            Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
            For indRep=1:1:arrReport.Count() {
                Set RepData=arrReport.GetAt(indRep)
                Continue:RepData=""
                Set ReportID=$lg(RepData,1)
                Set IRStatusDr=$lg(RepData,8)
                Continue:IRStatusDr=""
                Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
                //1保存、2提交、3审核、4作废、5退回、6取消审核
                Continue:(RepStatus="4")
            }
            Continue:ReportID=""
            If (aInfType="医院"){
                for indInf=8:1:10 {
                    Set IRInfPathogen = $lg(CSSData,indInf)
                    Set InfPosDr = $p(IRInfPathogen,"#",1)
                    If (InfPosDr'=""){
                        
                        if (+CSSRepPosDispalyConfig=0){
                             Set InfPosDesc=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr)),3)
                             Set PosDesc =InfPosDesc
                        }else{
                             Set InfPosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),3)
                             Set PosDesc =..GetDescByDesc(InfPosDesc)
                        }
                        Continue:(aDiagDesc'="")&&(aDiagDesc'=InfPosDesc)
                        for indBac=2:2:6{
                            Set InfBacDr = $p(IRInfPathogen,"#",indBac)
                            continue:InfBacDr=""
                            Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr)),3)
                            do BuildData
                        }
                    
                    }
                }
            }ElseIf aInfType="社区"{
                for indInf=12:1:14 {
                    Set IRInfPathogen = $lg(CSSData,indInf)
                    Set InfPosDr = $p(IRInfPathogen,"#",1)
                    If (InfPosDr'=""){
                        if (+CSSRepPosDispalyConfig=0){
                             Set comInfPosDesc=$lg($g(^DHCHAI.BT.DictionaryD(InfPosDr)),3)
                             Set PosDesc =comInfPosDesc
                        }else{
                             Set comInfPosDesc=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr)),3)
                             Set PosDesc =..GetDescByDesc(comInfPosDesc)
                        }
                        Continue:(aDiagDesc'="")&&(aDiagDesc'=comInfPosDesc)
                        for indBac=2:2:6{
                            Set InfBacDr = $p(IRInfPathogen,"#",indBac)
                            continue:InfBacDr=""
                            Set InfBacDesc=$lg($g(^DHCHAI.DP.LabBacteriaD(InfBacDr)),3)
                            do BuildData
                        }
                    
                    }
                } 
            }
        }   
    }

    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
BuildData
    Quit:(aInfBacDesc'="")&&(aInfBacDesc'=InfBacDesc)
    Set DimensDesc="全部"
    Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(xPaadm)),38)   //就诊次数
    Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(PosDesc,InfBacDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

ClassMethod QryCSSBacInfPosDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryCSSBacInfPosDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  取现患感染病原体
/// Table：       DHCHAI.IR.INFCSS、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aEpisodeID：就诊ID
///               aInfType:（医院感染，社区感染）
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S450CSSPosBac).GetCurrInfPosInfo(4,"46","医院感染")
ClassMethod GetCurrInfPosInfo(aSurNumID As %String, aEpisodeID As %String, aInfType As %String = "") As %String
{
	New (aSurNumID,aEpisodeID,aInfType)
	Set return=""
	Quit:(aSurNumID="")||(aEpisodeID="") return
	
	Set CSSInfFlag=0,CSSInfPos=""
	Set xCSSID=0
	For {
		Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
		Quit:xCSSID=""
		
		// Add by zhaoyj 2022-06-17 Global方式
		Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
		Continue:CSSData=""
		Continue:$lg(CSSData,5)'=1
		Continue:$lg(CSSData,6)=""
		Set InfCategory = ""
		Set IRInfCategoryDr=$lg(CSSData,7)
		Set:IRInfCategoryDr'="" InfCategory = $lg($g(^DHCHAI.BT.DictionaryD(IRInfCategoryDr)),3)
		Set InfectionDesc = $lg($g(^DHCHAI.BT.DictionaryD($lg(CSSData,6))),3)
		Set:InfectionDesc="不存在" InfCategory=""
		Continue:(aInfType'="")&&(aInfType'=InfCategory)
		//过滤删除的报告
		Set ReportID=""
		Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
		For indRep=1:1:arrReport.Count() {
			Set RepData=arrReport.GetAt(indRep)
			Continue:RepData=""
			Set ReportID=$lg(RepData,20)
			Set IRStatusDr=$lg(RepData,8)
			Continue:IRStatusDr=""
			Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
			//1保存、2提交、3审核、4作废、5退回、6取消审核
			Continue:(RepStatus="4")
		}
		// 感染诊断信息
		Set CSSInfPos=""
		// 医院感染信息
		Set IRInfPathogen1 = $lg(CSSData,8)
		Set IRInfPathogen2 = $lg(CSSData,9)
		Set IRInfPathogen3 = $lg(CSSData,10)
		Set InfPosDr1 = $p(IRInfPathogen1,"#",1)
		Set InfPosDr2 = $p(IRInfPathogen2,"#",1)
		Set InfPosDr3 = $p(IRInfPathogen3,"#",1)

		Set InfPosDesc1="",InfPosDesc2="",InfPosDesc3=""
		Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr1)),3)
		Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr2)),3)
		Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr3)),3)
		Set CSSInfPos=InfPosDesc1_"^"_InfPosDesc2_"^"_InfPosDesc3
		Set:CSSInfPos="^^" CSSInfPos=""
		// 社区感染信息
		Set CSSComInfPos=""
		Set IRComInfPathogen1 = $lg(CSSData, 12)
		Set IRComInfPathogen2 = $lg(CSSData, 13)
		Set IRComInfPathogen3 = $lg(CSSData, 14)
		Set InfPosDr1 = $p(IRComInfPathogen1,"#",1)
		Set InfPosDr2 = $p(IRComInfPathogen2,"#",1)
		Set InfPosDr3 = $p(IRComInfPathogen3,"#",1)
		Set InfPosDesc1="",InfPosDesc2="",InfPosDesc3=""
		Set:InfPosDr1'="" InfPosDesc1=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr1)),3)
		Set:InfPosDr2'="" InfPosDesc2=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr2)),3)
		Set:InfPosDr3'="" InfPosDesc3=$lg($g(^DHCHAI.BT.InfPosD(InfPosDr3)),3)
		Set CSSComInfPos=InfPosDesc1_"^"_InfPosDesc2_"^"_InfPosDesc3
		Set:CSSComInfPos="^^" CSSComInfPos=""
		
		Set:InfectionDesc="不存在" CSSInfPos="",CSSComInfPos=""
		Set return=ReportID_"!!"_xCSSID_"!!"_CSSInfPos_"!!"_CSSComInfPos_"!!"_InfCategory
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2019-10-18
/// Description:  判断患者是否发生医院感染,返回感染部位信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S450CSSPosBac).GetInfPosByDate("24","65773","65773")
ClassMethod GetInfPosByDate(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:aDateFrom>aDateTo return
	
	Set InfPosDescs=""
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
			// 感染诊断信息
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DiagID=$lg(INFRepExtData, 3)
				Continue:DiagID=""
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug
				
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				Set InfXDate  = $lg(DiagsData,7)
				Continue:InfDate>aDateTo    // 非现患率调查，感染日期大于查询截止日期，非查询期间发生感染
				Continue:InfDate<aDateFrom  // 非现患率调查，感染日期小于查询开始日期，非查询期间发生感染
				//感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg(DiagsData,18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
				}
				
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				//感染科室
				Set InfLocDesc=""
				Set IRInfLocDr=$lg(DiagsData,6)
				If (IRInfLocDr'=""){
					Set IRInfLocData = $g(^DHCHAI.BT.LocationD(IRInfLocDr))
					Set LocDesc2 = $lg(IRInfLocData,4)
					Set LocDesc  = $lg(IRInfLocData,3)
					Set InfLocDesc = $s(LocDesc2'="":LocDesc2,1:LocDesc)
				}
				Set Bacteria = $lg(DiagsData,16)
				
				//转归情况
				Set InfEffect=""
				Set IRInfEffectDr=$lg(DiagsData,8)
				Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
				Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
				If (InfPos'=""){
					Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType_"^"_InfLocDesc_"^"_Bacteria  
				}
			}
		}
	}
	Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
	Set:InfPosDescs'="" return=InfPosDescs
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2020-10-12
/// Description:  住院患者医院感染部位分布统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryHospBacInfPos","2021-01-29","2021-01-29","1|2","E","1")
Query QryHospBacInfPos(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "1") As %Query(ROWSPEC = "BacName:%String,InfCaseCnt:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%String") [ SqlProc ]
{
}

ClassMethod QryHospBacInfPosExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocType As %String = "E", aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryHospBacInfPos"
	Kill ^TMP($zn,$j,NIndex)
	
	
	// 同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		Set Paadm      = $LIST(TransInfo,1)
		Continue:Paadm=""
		
		Set InfPosDescs =..GetInfPosByDate(Paadm,aDateFrom,aDateTo)
		Continue:InfPosDescs=""
		if ($d(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm))){
			Set LabRepDr = ""
			For{
				Set LabRepDr=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr))
				Quit:LabRepDr=""
				Set LabRepID=""
				For{
					Set LabRepID=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr,LabRepID))
					Quit:LabRepID=""
					// Add by zhaoyj 2022-06-17 Global方式
					Set InfData=$g(^DHCHAI.IR.INFMBRD(LabRepID))
					Continue:InfData=""
					Set IRInfTypeDr=$lg(InfData,10)
					Set InfTypeCode = $lg($g(^DHCHAI.BT.DictionaryD(IRInfTypeDr)),2)
					Quit:InfTypeCode=""
					Continue:((InfTypeCode'=1)&(InfTypeCode'=5))	// 过滤非HA（医院感染）和HA（医院感染）重复感染类型的报告
					Set BactDesc = $lg(InfData,8)			    	// 取病原体
					Continue:BactDesc=""
					//感染例数
					Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",BactDesc))
					Set CCSID=""
					For{
						Set CCSID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",Paadm,CCSID))
						Quit:CCSID=""
						Set CSSData=$g(^DHCHAI.IR.CCScreeningD(CCSID))
						Continue:CSSData=""
						Continue:$lg(CSSData,5)'=1	//过滤排除的报告
						Set CSInfSuPosDr=$lg(CSSData,6)
						Set BTInfPosDr=$lg($g(^DHCHAI.BT.InfSuPosD(CSInfSuPosDr)),3)
						Set InfPosDesc =$lg($g(^DHCHAI.BT.InfPosD(BTInfPosDr)),3)
						Continue:InfPosDesc=""
						Set PosDesc =..GetDescByDesc(InfPosDesc)	//找到感染部位和系统
						Set ^TMP($zn,$j,NIndex,"InfPosList",BactDesc,InfPosDesc)=PosDesc
						// 记录感染部位数量
						Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",BactDesc,InfPosDesc))
					}
				}			
			}
    	}else{
	   		for InfNo=1:1:$L(InfPosDescs,"|") {
				Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
				continue:InfPosMsg=""
				Set DiagID	= $p(InfPosMsg,"^",1)
				Set InfDate	= $p(InfPosMsg,"^",3)
				Set InfType	= $p(InfPosMsg,"^",7)
				Set Bacteria = $p(InfPosMsg,"^",9)
				Set InfPosDesc = $p(InfPosMsg,"^",2)
				Set PosDesc = $p(InfPosMsg,"^",6)
				Continue:Bacteria=""
				Continue:InfPosDesc=""
				Continue:PosDesc=""
				Continue:InfType="社区感染"
				Set ^TMP($zn,$j,NIndex,"InfPosList",Bacteria,InfPosDesc)=PosDesc
				// 记录感染部位数量
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",Bacteria,InfPosDesc))
				//感染例数
				Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",Bacteria))
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
			Set InfCaseCnt 	 =+$g(^TMP($zn,$j,NIndex,"InfCase",xBacName)) //感染例数
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			Set PosDesc      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag))
			Set Data=$lb(xBacName,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospBacInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospBacInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
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

/// Creator：     zhoubo/chenr
/// CreatDate：   2020-09-16
/// Description:  医院感染病原体感染部位分布统计病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aInfType : 感染类型（医院感染、社区感染）
///               aPosDesc : 感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryHospBacInfPosDtl","2021-01-29","2021-01-29","1|3|4","E","","")
Query QryHospBacInfPosDtl(aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aLocType As %String = "E", BacName As %String = "", aPosDesc As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,xBacName:%String,InfCaseCnt:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%String,InfDate:%String") [ SqlProc ]
{
}

ClassMethod QryHospBacInfPosDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aLocType As %String = "E", BacName As %String = "", aPosDesc As %String = "") As %Status
{

	
		Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryHospBacInfPosDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// 同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		Set Paadm      = $LIST(TransInfo,1)
		Continue:Paadm=""
		Set PatData =..BuildPaadmData(Paadm)
		Continue:PatData=""
		Set InfPosDescs =..GetInfPosByDate(Paadm,aDateFrom,aDateTo)
		Continue:InfPosDescs=""
		if ($d(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm))){
			Set LabRepDr = ""
			For{
				Set LabRepDr=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr))
				Quit:LabRepDr=""
				Set LabRepID=""
				For{
					Set LabRepID=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr,LabRepID))
					Quit:LabRepID=""
					// Add by zhaoyj 2022-06-17 Global方式
					Set InfData=$g(^DHCHAI.IR.INFMBRD(LabRepID))
					Continue:InfData=""
					Set IRInfTypeDr=$lg(InfData,10)
					Set InfTypeCode = $lg($g(^DHCHAI.BT.DictionaryD(IRInfTypeDr)),2)
					Quit:InfTypeCode=""
					Continue:((InfTypeCode'=1)&(InfTypeCode'=5))	// 过滤非HA（医院感染）和HA（医院感染）重复感染类型的报告
					Set BactDesc = $lg(InfData,8)			    	// 取病原体
					Continue:BactDesc=""
					Continue:(BacName'="")&&(BactDesc'=BacName)
					//感染例数
					Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",BactDesc))
					Set CCSID=""
					For{
						Set CCSID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",Paadm,CCSID))
						Quit:CCSID=""
						Set CSSData=$g(^DHCHAI.IR.CCScreeningD(CCSID))
						Continue:CSSData=""
						Continue:$lg(CSSData,5)'=1	   //过滤排除的报告
						Set CSInfSuPosDr=$lg(CSSData,6)
						Set BTInfPosDr=$lg($g(^DHCHAI.BT.InfSuPosD(CSInfSuPosDr)),3)
						Set InfPosDesc =$lg($g(^DHCHAI.BT.InfPosD(BTInfPosDr)),3)
						Continue:InfPosDesc=""
						Continue:(aPosDesc'="")&&(InfPosDesc'=aPosDesc)
						Set PosDesc =..GetDescByDesc(InfPosDesc)	//找到感染部位和系统
						Set ^TMP($zn,$j,NIndex,"InfPosList",BactDesc,InfPosDesc,Paadm,Paadm,PosDesc)=""
						// 记录感染部位数量
						Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",BactDesc,InfPosDesc))
					}
				}			
			}
    	}else{
	   		for InfNo=1:1:$L(InfPosDescs,"|") {
				Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
				continue:InfPosMsg=""
				Set DiagID	= $p(InfPosMsg,"^",1)
				Set InfDate	= $p(InfPosMsg,"^",3)
				Set InfType	= $p(InfPosMsg,"^",7)
				Set Bacteria = $p(InfPosMsg,"^",9)
				Set InfPosDesc = $p(InfPosMsg,"^",2)
				Set PosDesc = $p(InfPosMsg,"^",6)
				
				Continue:InfType="社区感染"
				continue:Bacteria=""
				Continue:(BacName'="")&&(Bacteria'=BacName)
				Continue:(aPosDesc'="")&&(InfPosDesc'=aPosDesc)
				Set ^TMP($zn,$j,NIndex,"InfPosList",Bacteria,InfPosDesc,Paadm,PosDesc)=InfDate
				// 记录感染部位数量
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",Bacteria,InfPosDesc))
				//感染例数
				Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",Bacteria))
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
			Set InfCaseCnt 	 =+$g(^TMP($zn,$j,NIndex,"InfCase",xBacName)) //感染例数
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			set xPaadm=""
			for {
				Set xPaadm=$o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm))
				Quit:xPaadm=""	
				
				Set PosDesc= $o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm,""))
				continue:PosDesc=""
				
				Set InfDate      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm,PosDesc))
				Set InfDate=$zd(InfDate,3)
				Set BacData=$lb(xBacName,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCount,InfDate)
				Set PatData =..BuildPaadmData(xPaadm)
				
				Set Data=PatData_BacData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryHospBacInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospBacInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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

/// Creator：     chenrui
/// CreatDate：   2020-10-12
/// Description:  社区感染部位分布统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDateFrom : 开始日期
/// 			  aDateTo：结束日期
/// 			  aHospIDs：院区ID
/// 			  aLocType：W -病区 E -科室(统计单位)
/// 			  aQryCon：1-全部病区 2-有数据病区(筛选条件)
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryComBacInfPos","2020-07-01","2020-12-09","1|3|4","1")
Query QryComBacInfPos(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aQryCon As %String = "1") As %Query(ROWSPEC = "BacName:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%String,ComCaseCnt:%String") [ SqlProc ]
{
}

ClassMethod QryComBacInfPosExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryComBacInfPos"
	Kill ^TMP($zn,$j,NIndex)
	
	
	// 同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		Set Paadm      = $LIST(TransInfo,1)
		Continue:Paadm=""
		
		Set InfPosDescs =..GetInfPosByDate(Paadm,aDateFrom,aDateTo)
		Continue:InfPosDescs=""
		if ($d(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm))){
			Set LabRepDr = ""
			For{
				Set LabRepDr=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr))
				Quit:LabRepDr=""
				Set LabRepID=""
				For{
					Set LabRepID=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr,LabRepID))
					Quit:LabRepID=""
					// Add by zhaoyj 2022-06-17 Global方式
					Set InfData=$g(^DHCHAI.IR.INFMBRD(LabRepID))
					Continue:InfData=""
					Set IRInfTypeDr=$lg(InfData,10)
					Set InfTypeCode = $lg($g(^DHCHAI.BT.DictionaryD(IRInfTypeDr)),2)
					Quit:InfTypeCode=""
					Continue:((InfTypeCode'=2)&(InfTypeCode'=6))	// 过滤非HA（医院感染）和HA（医院感染）重复感染类型的报告
					Set BactDesc = $lg(InfData,8)			    	// 取病原体
					Continue:BactDesc=""
					//感染例数
					Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",BactDesc))
					Set CCSID=""
					For{
						Set CCSID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",Paadm,CCSID))
						Quit:CCSID=""
						Set CSSData=$g(^DHCHAI.IR.CCScreeningD(CCSID))
						Continue:CSSData=""
						Continue:$lg(CSSData,5)'=1	   //过滤排除的报告
						Set CSInfSuPosDr=$lg(CSSData,6)
						Set BTInfPosDr=$lg($g(^DHCHAI.BT.InfSuPosD(CSInfSuPosDr)),3)
						Set InfPosDesc =$lg($g(^DHCHAI.BT.InfPosD(BTInfPosDr)),3)
						Continue:InfPosDesc=""
						Set PosDesc =..GetDescByDesc(InfPosDesc)	//找到感染部位和系统
						Set ^TMP($zn,$j,NIndex,"InfPosList",BactDesc,InfPosDesc)=PosDesc
						// 记录感染部位数量
						Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",BactDesc,InfPosDesc))
					}
				}			
			}
    	}else{
	   		for InfNo=1:1:$L(InfPosDescs,"|") {
				Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
				continue:InfPosMsg=""
				Set DiagID	= $p(InfPosMsg,"^",1)
				Set InfDate	= $p(InfPosMsg,"^",3)
				Set InfType	= $p(InfPosMsg,"^",7)
				Set Bacteria = $p(InfPosMsg,"^",9)
				Set InfPosDesc = $p(InfPosMsg,"^",2)
				Set PosDesc = $p(InfPosMsg,"^",6)
				
				Continue:InfType="医院感染"
				Continue:Bacteria=""
				Set ^TMP($zn,$j,NIndex,"InfPosList",Bacteria,InfPosDesc)=PosDesc
				// 记录感染部位数量
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",Bacteria,InfPosDesc))
				//感染例数
				Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",Bacteria))
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
			Set InfCaseCnt 	 =+$g(^TMP($zn,$j,NIndex,"InfCase",xBacName)) //感染例数
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			Set PosDesc      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag))
			Set Data=$lb(xBacName,PosDesc,InfDiagDesc,InfDiagCount,InfCaseCnt)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	 	}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryComBacInfPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryComBacInfPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosExecute ]
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

/// Creator：     zhoubo/chenr
/// CreatDate：   2020-09-16
/// Description:  社区感染病原体感染部位分布统计病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aInfType : 感染类型（医院感染、社区感染）
///               aPosDesc : 感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S450CSSPosBac","QryCommBacInfPosDtl","2019-01-01","2019-03-01","1|2","","")
Query QryCommBacInfPosDtl(aDateFrom As %String, aDateTo As %String, aHospIDs As %String, BacName As %String = "", aPosDesc As %String = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,xBacName:%String,InfCaseCnt:%String,PosDesc:%String,InfDiagDesc:%String,InfDiagCount:%String,InfDate:%String") [ SqlProc ]
{
}

ClassMethod QryCommBacInfPosDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, BacName As %String = "", aPosDesc As %String = "") As %Status
{

	
			Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	Set aLocType="E"
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	
    Set NIndex="QryCommBacInfPosDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	// 同期在科:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,aLocType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		Set Paadm      = $LIST(TransInfo,1)
		Continue:Paadm=""
		
		Set InfPosDescs =..GetInfPosByDate(Paadm,aDateFrom,aDateTo)
		Continue:InfPosDescs=""
		if ($d(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm))){
			Set LabRepDr = ""
			For{
				Set LabRepDr=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr))
				Quit:LabRepDr=""
				Set LabRepID=""
				For{
					Set LabRepID=$o(^DHCHAI.IR.INFMBRI("IndexLabEpisode",Paadm,LabRepDr,LabRepID))
					Quit:LabRepID=""
					// Add by zhaoyj 2022-06-17 Global方式
					Set InfData=$g(^DHCHAI.IR.INFMBRD(LabRepID))
					Continue:InfData=""
					Set IRInfTypeDr=$lg(InfData,10)
					Set InfTypeCode = $lg($g(^DHCHAI.BT.DictionaryD(IRInfTypeDr)),2)
					Quit:InfTypeCode=""
					Continue:((InfTypeCode'=2)&(InfTypeCode'=6))	// 过滤非CA（社区感染）和CA（社区感染）重复感染类型的报告
					Set BactDesc = $lg(InfData,8)			    	// 取病原体
					Continue:BactDesc=""
					Continue:(BacName'="")&&(BactDesc'=BactDesc)
					//感染例数
					Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",BactDesc))
					Set CCSID=""
					For{
						Set CCSID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeDr",Paadm,CCSID))
						Quit:CCSID=""
						Set CSSData=$g(^DHCHAI.IR.CCScreeningD(CCSID))
						Continue:CSSData=""
						Continue:$lg(CSSData,5)'=1	   //过滤排除的报告
						Set CSInfSuPosDr=$lg(CSSData,6)
						Set BTInfPosDr=$lg($g(^DHCHAI.BT.InfSuPosD(CSInfSuPosDr)),3)
						Set InfPosDesc =$lg($g(^DHCHAI.BT.InfPosD(BTInfPosDr)),3)
						Continue:InfPosDesc=""
						Set PosDesc =..GetDescByDesc(InfPosDesc)	//找到感染部位和系统
						Continue:(aPosDesc'="")&&(PosDesc'=aPosDesc)
						Set ^TMP($zn,$j,NIndex,"InfPosList",BactDesc,InfPosDesc,Paadm,PosDesc)=""
						// 记录感染部位数量
						Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",BactDesc,InfPosDesc))
					}
				}			
			}
    	}else{
	   		for InfNo=1:1:$L(InfPosDescs,"|") {
				Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
				continue:InfPosMsg=""
				Set DiagID	= $p(InfPosMsg,"^",1)
				Set InfDate	= $p(InfPosMsg,"^",3)
				Set InfType	= $p(InfPosMsg,"^",7)
				Set Bacteria = $p(InfPosMsg,"^",9)
				Set InfPosDesc = $p(InfPosMsg,"^",2)
				Set PosDesc = $p(InfPosMsg,"^",6)
				
				Continue:InfType="医院感染"
				continue:Bacteria=""
				Continue:(BacName'="")&&(Bacteria'=BacName)
				Continue:(aPosDesc'="")&&(InfPosDesc'=aPosDesc)
				continue:InfDate=""
				Set ^TMP($zn,$j,NIndex,"InfPosList",Bacteria,InfPosDesc,Paadm,PosDesc)=InfDate
				// 记录感染部位数量
				Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",Bacteria,InfPosDesc))
				//感染例数
				Set xnum =+$i(^TMP($zn,$j,NIndex,"InfCase",Bacteria))
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
			Set InfCaseCnt 	 =+$g(^TMP($zn,$j,NIndex,"InfCase",xBacName)) //感染例数
			Set InfDiagCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xBacName,xDiag))
			set xPaadm=""
			for {
				Set xPaadm=$o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm))
				Quit:xPaadm=""	
				Set PosDesc= $o(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm,""))
				continue:PosDesc=""
				
				Set InfDate      =$g(^TMP($zn,$j,NIndex,"InfPosList",xBacName,xDiag,xPaadm,PosDesc))
				Set InfDate=$zd(InfDate,3)
				Set BacData=$lb(xBacName,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCount,InfDate)

				Set PatData =..BuildPaadmData(xPaadm)
                 Set DimensDesc="全部"  //科室、病区名称
                Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
                Set Data=$lb(DimensDesc,AdmTimes)_PatData_BacData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
	 	}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryCommBacInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCommBacInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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
