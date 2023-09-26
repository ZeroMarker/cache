/// 名称: DHCHAI.STATV2.S420CssPosInf
/// 描述: 住院患者医院感染部位分布统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-19
Class DHCHAI.STATV2.S420CssPosInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-19
/// Description:  医院感染部位分布统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aStaType ：科室/病区类型
///               aInfType : 感染类型（1:医院感染、0:社区感染）
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420CssPosInf","QryInfPosCSS","2","W","1","G","6,7")
Query QryInfPosCSS(aSurNumID As %String, aStaType As %String, aInfType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,InfPatCnt:%Integer,InfCaseCnt:%Integer,PosDesc:%String,InfDiagDesc:%String,InfDiagCnt:%Integer,CSSCnt:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aStaType As %String, aInfType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Set SurNumID = aSurNumID
    Set StaType = aStaType
    Set InfType = aInfType
    Set StatDimens = aStatDimens
    Set LocIDs = aLocIDs
    Quit:SurNumID="" $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set DateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set DateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set HospDr    = $li(SurvData,3)
    Quit:HospDr="" $$$OK
    Set HospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(HospDr,"|")
    Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
    Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)
       
    Set StatDimensStr = StatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(StaType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //默认不是病区就是科室
    Set LocCount=$l(LocIDs,",")  //科室、病区入参个数
     //（1:医院感染、0:社区感染）
    Set aInfType=$s(aInfType=1:"医院感染",aInfType=0:"社区感染",1:"")
    
    Set NIndex="QryInfPosCSS"
    Kill ^TMP($zn,$j,NIndex)
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set HospDr  = $li($g(^DHCHAI.BT.LocationD(LocDr)),8)
        Continue:(HospIDs'="")&&($listfind(HospIDs,HospDr)<1)
        
        //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(SurNumID,Paadm,"")
 
        Set CSSReportID  = $p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3)
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4)
        Set:aInfType="社区感染" CSSInfPos =CSSComInfPos
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^")  
        //统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,"",LocDr,LocDr)
        Continue:StatDimensInfo=""

        For indDimens=1:1:$l(StatDimensInfo,"^") {
            Set DimensKey=$p(StatDimensInfo,"^",indDimens)
            Continue:DimensKey=""

            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CSSPat"))    //实查人数
            Continue:CSSInfPos=""    
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))    // 感染人数

            //记录感染部位信息
            For indxi=1:1:$l(CSSInfPos,"^") {
                Set tmpInfPosDesc = $p(CSSInfPos,"^",indxi)
                Continue:tmpInfPosDesc=""
                Continue:+$d(^TMP($zn,$j,NIndex,"PatInfPos",Paadm,DimensKey,tmpInfPosDesc))   
                Set ^TMP($zn,$j,NIndex,"PatInfPos",Paadm,DimensKey,tmpInfPosDesc)=""
                Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))     //感染例次
                Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,"PosDesc",tmpInfPosDesc))  //感染部位数量 
            }
        }
    }  
    do BuildData
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
    
BuildData
    Set HospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(HospIDs,"|")
    // 输出Data
    Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,HospIDs,"","","","I")
    Set xDimensKey=""
    For DimIndx=1:1:ArryStatDimens.Count() {
        Set DimList=ArryStatDimens.GetAt(DimIndx)
        Set xDimensKey  =$lg(DimList,1)
        Set DimensDesc  =$lg(DimList,3)
        Set IsActive    =$lg(DimList,4)
        Continue:xDimensKey=""
        Set LocDr = +$p(xDimensKey,"-",3)
    
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        
        Set CSSCnt  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"CSSPat"))    //实查人数
        Set InfPatCnt  = +$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
        Set InfCaseCnt = +$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
        If (LocCount>1) {
            Set num=+$g(^TMP($zn,$j,NIndex,"Sum","CSSPat"))
            Set ^TMP($zn,$j,NIndex,"Sum","CSSPat")=num+CSSCnt
            Set num=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))
            Set ^TMP($zn,$j,NIndex,"Sum","InfPat")=num+InfPatCnt
            Set num=+$g(^TMP($zn,$j,NIndex,"Sum","InfCase"))
            Set ^TMP($zn,$j,NIndex,"Sum","InfCase")=num+InfCaseCnt
        }
  
        Set xDiag=""
        For {
            Set xDiag=$o(^TMP($zn,$j,NIndex,xDimensKey,"PosDesc",xDiag))
            
            Quit:xDiag=""
            Set InfDiagDesc =xDiag
            Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PosDesc",xDiag)) //感染部位例数
            Set PosDesc =..GetDescByDesc(InfDiagDesc)
           
            Set Data=$lb(xDimensKey,DimensDesc,InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt,CSSCnt)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
            If (LocCount>1) {
                Set ^TMP($zn,$j,NIndex,"Sum","InfPosList",xDiag)=""
                Set num=+$g(^TMP($zn,$j,NIndex,"Sum",xDiag))
                Set ^TMP($zn,$j,NIndex,"Sum",xDiag)=num+InfDiagCnt
            }
        }
        if ('$d(^TMP($zn,$j,NIndex,xDimensKey,"PosDesc"))) {    //&&(aQryCon="3")
            Set Data=$lb(xDimensKey,DimensDesc,0,0,"","",0,CSSCnt)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
    }
    If (LocCount>1) {
        Set CSSCnt  = +$g(^TMP($zn,$j,NIndex,"Sum","CSSPat"))    //实查人数
        Set InfPatCnt  = +$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  //感染人数
        Set InfCaseCnt = +$g(^TMP($zn,$j,NIndex,"Sum","InfCase")) //感染例数
         For {
            Set xDiag=$o(^TMP($zn,$j,NIndex,"Sum","InfPosList",xDiag))
            Quit:xDiag=""
            Set InfDiagDesc =xDiag
            Set InfDiagCnt  =+$g(^TMP($zn,$j,NIndex,"Sum",xDiag)) //感染部位例数
            Set PosDesc =..GetDescByDesc(InfDiagDesc)

            Set Data=$lb("","全部",InfPatCnt,InfCaseCnt,PosDesc,InfDiagDesc,InfDiagCnt,CSSCnt)
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
    }
}

ClassMethod QryInfPosCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSExecute ]
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
/// CreatDate：   2019-11-19
/// Description:  医院感染部位分布统计病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aInfType : 感染类型（医院感染、社区感染）
///               aPosDesc : 感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420CssPosInf","QryInfPosCSSDtl","2","","0","抗菌药物相关性腹泻","W","6,7")
Query QryInfPosCSSDtl(aSurNumID As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,CSSReportID:%String,CSSRepDianos:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosCSSDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Set ^TMPLH=aPosDesc
    Quit:(aSurNumID="") $$$OK
    
    Set aInfType=$s(aInfType=1:"医院感染",aInfType=0:"社区感染",1:aInfType)
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set aDateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set aDateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set aHospDr   = $li(SurvData,3)
    Quit:aHospDr="" $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)
    Set:+aHospIDs="0" aHospIDs=""
    Set:aStaType'="W" aStaType="E"
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set NIndex="QryInfPosCSSDtl"
    Kill ^TMP($zn,$j,NIndex)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set:aLocType="" StatType=aStaType
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed("1",aDateFrom,aDateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
   
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
         
        //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocDr'="")&(aLocDr'=LocID)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
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
        
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set HospDr  = $li(LocData,8)
        Continue:HospDr=""
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)
        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
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
       
        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
        Continue:(aLocType'="")&&(LocID'=aLocDr)
        //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm,"")
        Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3) // 医院感染部位
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4) // 社区感染部位
        
        Set:aInfType="社区感染" CSSInfPos =CSSComInfPos
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^")  
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
        //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^")  
        For indRD=1:1:$l(CSSInfPos,"^") {
            Set tRepDiagnos=$p(CSSInfPos,"^",indRD)
            Continue:tRepDiagnos=""

            Continue:((aPosDesc'="")&&(aPosDesc'=tRepDiagnos))
            Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,CSSReportID,tRepDiagnos)   
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryInfPosCSSDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosCSSDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosCSSDtlExecute ]
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
/// CreatDate：   2022-12-19
/// Description:  横断面调查
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
///               aDimensKey: 维度
///               aInfType : 感染类型（医院感染、社区感染）
///               aPosDesc : 感染部位
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420CssPosInf","QryCSSPatDtl","2","0000-00-0000-A-1","医院感染","","W","17,7")
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420CssPosInf","QryCSSPatDtl","2","0001-07-0009-W-3","医院感染","","W","17,7")
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S420CssPosInf","QryCSSPatDtl","2","0000-00-0000-A-1","医院感染","","W","17,7")
Query QryCSSPatDtl(aSurNumID As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,CSSReportID:%String") [ SqlProc ]
{
}

ClassMethod QryCSSPatDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aInfType As %String, aPosDesc As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Status
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
    Set aHospDr   = $li(SurvData,3)
    Quit:aHospDr="" $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospDr,"|")
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)
    Set:+aHospIDs="0" aHospIDs=""
    Set:aStaType'="W" aStaType="E"
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    
    Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set:aLocDr="0" aLocDr=""
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set NIndex="QryCSSPatDtl"
    Kill ^TMP($zn,$j,NIndex)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set:aLocType="" StatType=aStaType
    
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed("1",aDateFrom,aDateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
    Set xPaadms=""
    
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
          
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
         //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocDr'="")&(aLocDr'=LocID)
        
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
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
        
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set HospDr  = $li(LocData,8)
        Continue:HospDr=""
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)

        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)    //&&(HospGroupDr'="")
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
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

        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)

       
        Set PatData =..BuildPaadmData(Paadm)
        Continue:PatData=""
        //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数

        Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,CSSReportID)   
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1

    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryCSSPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCSSPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCSSPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCSSPatDtlExecute ]
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
