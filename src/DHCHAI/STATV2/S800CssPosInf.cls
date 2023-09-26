/// 名称: DHCHAI.STATV2.S800CssPosInf
/// 描述: 医院感染部位例次占比统计
/// 编写者：zhoubo
/// 编写日期: 2020-05-11
Class DHCHAI.STATV2.S800CssPosInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-06-17
/// Description:  住院患者医院感染部位分布统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID： 调查编号  
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S800CssPosInf","QryCSSBacInfPos","3","1")
Query QryCSSBacInfPos(aSurNumID As %String, aInfType As %String = "", aStaType As %String = "E", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "PosDesc:%String,InfPosCount:%Integer") [ SqlProc ]
{
}

ClassMethod QryCSSBacInfPosExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfType As %String = "", aStaType As %String = "E", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
	Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
	Quit:SurvData="" $$$OK
 	Set aDateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
 	Set aDateTo   = $li(SurvData,6)
 	Set SurNumber = $li(SurvData,2)
 	Set aHospDr    = $li(SurvData,3)
 	Quit:aHospDr="" $$$OK
 	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	//（1:医院感染、0:社区感染）
    Set aInfType=$s(aInfType=1:"医院",aInfType=0:"社区",1:"")
     //新增加维度
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="E" StatType="W"  
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    /// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="QryCSSBacInfPos"
    Kill ^TMP($zn,$j,NIndex)
     //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospDr,aDateFrom,aDateTo,StatType)         
    Set xPaadms=""
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        //未调查
        Continue:Paadm=""
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
                //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm,aInfType)
        Set CSSReportID  = $p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3)
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4)
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^") 
        Set CSSComInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSComInfPos,"^")  
        Set:(aInfType="社区") CSSInfPos=CSSComInfPos
        
        For indxi=1:1:$l(CSSInfPos,"^") {
            Set InfPosDesc = $p(CSSInfPos,"^",indxi)
            if (+CSSRepPosDispalyConfig=0){
                 Set PosDesc =InfPosDesc
            }else{
                 Set PosDesc =..GetDescByDesc(InfPosDesc)
            }
            Continue:PosDesc=""
            Set num=+$i(^TMP($zn,$j,NIndex,"InfPosCount",PosDesc))
            
        }
        
	}
	// 输出Data
	Set xPosDesc=""
	For {
		Set xPosDesc=$o(^TMP($zn,$j,NIndex,"InfPosCount",xPosDesc))
		Quit:xPosDesc=""
		
		Set InfPosCount =$g(^TMP($zn,$j,NIndex,"InfPosCount",xPosDesc))
		Set Data=$lb(xPosDesc,InfPosCount)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	   
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
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

/// Creator：     zhoubo
/// CreatDate：   2022-06-17
/// Description:  住院患者医院感染部位分布统计表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID： 调查编号  
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S800CssPosInf","QryCSSBacInfPosDtl","3","1","")
Query QryCSSBacInfPosDtl(aSurNumID As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "E", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,PosDesc:%String,InfPosDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCSSBacInfPosDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "E", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aSurNumID="") $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set aDateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set aDateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set aHospDr    = $li(SurvData,3)
    Quit:aHospDr="" $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Set:aStaType'="E" aStaType="W"  
    //（1:医院感染、0:社区感染）
     Set aInfType=$s(aInfType=1:"医院",aInfType=0:"社区",1:"")
    
    /// 取所有需要调查的科室  默认是全院科室    
    Set NIndex="QryCSSBacInfPosDtl"
    Kill ^TMP($zn,$j,NIndex)
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")     //根据CSS配置取感染部位
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospDr,aDateFrom,aDateTo,aStaType)         
    Set xPaadms=""
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
        Continue:(TransID="")
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        //未调查
        Continue:Paadm=""
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        continue:LocData=""
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }Else{
            Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
            Set GroupDesc=$li(GroupData,3)
        }
        Set LocDesc=""
        If LocData'="" {
            Set LocDesc2   = $li(LocData,4)
            Set tmpLocDesc = $li(LocData,3)
            Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }
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
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
        //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm,aInfType)
        Set CSSReportID  = $p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3)
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4)
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^") 
        Set CSSComInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSComInfPos,"^")  
        Set:(aInfType="社区") CSSInfPos=CSSComInfPos
        
        For indxi=1:1:$l(CSSInfPos,"^") {
            Set InfPosDesc = $p(CSSInfPos,"^",indxi)
             if (+CSSRepPosDispalyConfig=0){
                 Set PosDesc =InfPosDesc
            }else{
                 Set PosDesc =..GetDescByDesc(InfPosDesc)
            }
            Continue:PosDesc=""
            If (((aPosDesc'="")&&(aPosDesc=PosDesc))||(aPosDesc="")){
                do BuildData
            }
            
        }
    }
    Quit $$$OK
BuildData
    Set DimensDesc="全部"
    Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
    Set Data=$lb("全部",AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,TransDateTime,OutLocDateTime,PosDesc,InfPosDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryCSSBacInfPosDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSBacInfPosDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSBacInfPosDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSBacInfPosDtlExecute ]
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
