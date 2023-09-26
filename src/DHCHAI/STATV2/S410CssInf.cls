/// 名称: DHCHAI.STATV2.S410CssInf
/// 描述: 医院感染（例次）现患率统计表
/// 编写者：zhoubo
/// 编写日期: 2019-11-19
Class DHCHAI.STATV2.S410CssInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-19
/// Description:  医院感染（例次）现患率统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aLocType ：科室/病区类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S410CssInf","QryInfPreByCSS","3","W","1","")
Query QryInfPreByCSS(aSurNumID As %String, aStaType As %String, aQryCon As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,SurPatCnt:%Integer,SurPatRatio:%String,InfPatCnt:%Integer,InfPatRatio:%String,InfCaseCnt:%Integer,InfCaseRatio:%String,ComInfPatCnt:%Integer,ComInfPatRatio:%String,ComInfCaseCnt:%Integer,ComInfCaseRatio:%String,InfComInfPatCnt:%Integer,InfComInfCaseCnt:%Integer,InfComInfPatRatio:%String,InfComInfCaseRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreByCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aStaType As %String, aQryCon As %String = "", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aSurNumID="" $$$OK
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
	
	/// 取所有需要调查的科室  默认是全院科室
    Set NIndex="QryInfPreByCSS"
	Kill ^TMP($zn,$j,NIndex)
	//新增加维度
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
      //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        Set HospDr  = $li(LocData,8)
        Continue:(HospIDs'="")&&($listfind(HospIDs,HospDr)<1)
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Set LocDesc=""
        If LocData'="" {
            Set LocDesc2   = $li(LocData,4)
            Set tmpLocDesc = $li(LocData,3)
            Set LocDesc = $s(LocDesc2'="":LocDesc2,1:tmpLocDesc)
        }
        //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm)
        Set CSSReportID  = $p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3)
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4)
        Set CSSInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfPos,"^") 
        Set CSSComInfPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSComInfPos,"^")  
        // 感染分类 1：社区感染 0：医院感染
        Set InfCategory=$p(CSSInfDianosInfo,"!!",5)

        Set CSSInfComPos=""  //  医院+社区
        If (InfCategory="医院+社区"){
            Set CSSInfComPos = CSSComInfPos_"^"_CSSInfPos
        }
        Set CSSInfComPos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSInfComPos,"^")  
        //统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
        Continue:StatDimensInfo=""
        For indDimens=1:1:$l(StatDimensInfo,"^") {
            Set DimensKey=$p(StatDimensInfo,"^",indDimens)
            Continue:DimensKey=""
 
            //应查人数（住院人数）
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"AdmPat"))
            If CSSReportID'="" {
                //实查人数（调查人数）
                Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
                If (CSSInfPos'=""){ 
                    //感染人数
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfPat"))

                    For indxi=1:1:$l(CSSInfPos,"^") {
                        Set tmpInfPosDesc = $p(CSSInfPos,"^",indxi)
                        Continue:tmpInfPosDesc=""
                        Continue:+$d(^TMP($zn,$j,NIndex,"PatInfPos",Paadm,DimensKey,tmpInfPosDesc))   
                        Set ^TMP($zn,$j,NIndex,"PatInfPos",Paadm,DimensKey,tmpInfPosDesc)=""
                        Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,"InfCase"))     //感染例次

                    }

                }
                If (CSSComInfPos'=""){ 
                    //感染人数
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat"))
                    
                    For indxi=1:1:$l(CSSComInfPos,"^") {
                        Set tmpInfPosDesc = $p(CSSComInfPos,"^",indxi)

                        Continue:tmpInfPosDesc=""
                        Continue:+$d(^TMP($zn,$j,NIndex,"PatComInfPos",Paadm,DimensKey,tmpInfPosDesc))   
                        Set ^TMP($zn,$j,NIndex,"PatComInfPos",Paadm,DimensKey,tmpInfPosDesc)=""
                        Set num=+$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfCase"))     //感染例次
                    }

                }
                If (InfCategory="医院+社区"){ // 医院+社区感染
                    //感染人数
                    Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"InfComInfPat"))
                    //感染例数
                    Set num=+$g(^TMP($zn,$j,NIndex,DimensKey,"InfComInfCase"))
                    Set InfPosDesc1=$p(CSSInfComPos,"^",1)
                    Set InfPosDesc2=$p(CSSInfComPos,"^",2)
                    Set InfPosDesc3=$p(CSSInfComPos,"^",3)
                    Set InfPosDesc4=$p(CSSInfComPos,"^",4)
                    Set InfPosDesc5=$p(CSSInfComPos,"^",5)
                    Set InfPosDesc6=$p(CSSInfComPos,"^",6)
                    Set:InfPosDesc1'="" num=num+1
                    Set:InfPosDesc2'="" num=num+1
                    Set:InfPosDesc3'="" num=num+1
                    Set:InfPosDesc4'="" num=num+1
                    Set:InfPosDesc5'="" num=num+1
                    Set:InfPosDesc6'="" num=num+1
                    Set ^TMP($zn,$j,NIndex,DimensKey,"InfComInfCase")=num
                }
            }
        }
    }
    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(HospIDs,"|")
    // 输出Data
    Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
    Set xDimensKey=""
    For DimIndx=1:1:ArryStatDimens.Count() {
        Set DimList=ArryStatDimens.GetAt(DimIndx)
        Set xDimensKey  =$lg(DimList,1)
        Set DimensDesc  =$lg(DimList,3)
        Set IsActive    =$lg(DimList,4)
        Continue:xDimensKey=""
        Set LocDr = +$p(xDimensKey,"-",3)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        
        Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AdmPat"))  //应查人数
        Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //实查人数
        Set InfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfPat"))  //感染人数
        Set InfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfCase")) //感染例数
        Continue:(aQryCon=2)&&(SurPatCnt=0)        // 2显示有数据病区(科室)(分子)
        Continue:(aQryCon=3)&&(PatAdmCnt=0)        // 3显示有数据病区(科室)(分母)
        Set ComInfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfPat"))  //社区感染人数
        Set ComInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"ComInfCase")) //社区感染例数
        
        Set InfComInfPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfComInfPat"))  //医院+社区感染人数
        Set InfComInfCaseCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InfComInfCase")) //医院+社区感染人数
        Set InfComInfPatRatio="0.00%",InfComInfCaseRatio="0.00%"
        Set:PatAdmCnt>0 InfComInfPatRatio=$fn((InfComInfPatCnt/PatAdmCnt)*100,"",2)_"%" //社区现患率
        Set:PatAdmCnt>0 InfComInfCaseRatio=$fn((InfComInfCaseCnt/PatAdmCnt)*100,"",2)_"%" //社区现患例次率
        
        Set SurPatRatio="0.00%"
        Set:PatAdmCnt>0 SurPatRatio=$fn((SurPatCnt/PatAdmCnt)*100,"",2)_"%" //实查率
        Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
        Set:PatAdmCnt>0 InfPatRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" //现患率
        Set:PatAdmCnt>0 InfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" //现患例次率
        Set ComInfPatRatio="0.00%",ComInfCaseRatio="0.00%"
        Set:PatAdmCnt>0 ComInfPatRatio=$fn((ComInfPatCnt/PatAdmCnt)*100,"",2)_"%" //社区现患率
        Set:PatAdmCnt>0 ComInfCaseRatio=$fn((ComInfCaseCnt/PatAdmCnt)*100,"",2)_"%" //社区现患例次率
       
        Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,SurPatCnt,SurPatRatio,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio,ComInfPatCnt,ComInfPatRatio,ComInfCaseCnt,ComInfCaseRatio,InfComInfPatCnt,InfComInfCaseCnt,InfComInfPatRatio,InfComInfCaseRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
        
        If (LocCount>1) {
            Set ^TMP($zn,$j,NIndex,"Sum","AdmPat")=PatAdmCnt+$g(^TMP($zn,$j,NIndex,"Sum","AdmPat"))
            Set ^TMP($zn,$j,NIndex,"Sum","SurPat")=SurPatCnt+$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))
            Set ^TMP($zn,$j,NIndex,"Sum","InfPat") = InfPatCnt+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  //感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","InfCase") = InfCaseCnt+$g(^TMP($zn,$j,NIndex,"Sum","InfCase")) //感染例数
            Set ^TMP($zn,$j,NIndex,"Sum","ComInfPat") = ComInfPatCnt +$g(^TMP($zn,$j,NIndex,"Sum","ComInfPat"))  //社区感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","ComInfCase") = ComInfCaseCnt +$g(^TMP($zn,$j,NIndex,"Sum","ComInfCase")) //社区感染例数
            Set ^TMP($zn,$j,NIndex,"Sum","InfComInfPat") = InfComInfPatCnt  +$g(^TMP($zn,$j,NIndex,"Sum","InfComInfPat"))  //医院+社区感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","InfComInfCase") = InfComInfCaseCnt +$g(^TMP($zn,$j,NIndex,"Sum","InfComInfCase")) //医院+社区感染人数
        }
    }
    
    If (LocCount>1) {
            Set PatAdmCnt=+$g(^TMP($zn,$j,NIndex,"Sum","AdmPat"))
            Set SurPatCnt=+$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))
            Set InfPatCnt=+$g(^TMP($zn,$j,NIndex,"Sum","InfPat"))  
            Set InfCaseCnt=+$g(^TMP($zn,$j,NIndex,"Sum","InfCase")) 
            Set ComInfPatCnt=+$g(^TMP($zn,$j,NIndex,"Sum","ComInfPat"))  
            Set ComInfCaseCnt=+$g(^TMP($zn,$j,NIndex,"Sum","ComInfCase")) 
            Set InfComInfPatCnt=+$g(^TMP($zn,$j,NIndex,"Sum","InfComInfPat"))  
            Set InfComInfCaseCnt=+$g(^TMP($zn,$j,NIndex,"Sum","InfComInfCase")) 
            Set InfComInfPatRatio="0.00%",InfComInfCaseRatio="0.00%"
            Set:PatAdmCnt>0 InfComInfPatRatio=$fn((InfComInfPatCnt/PatAdmCnt)*100,"",2)_"%" //社区现患率
            Set:PatAdmCnt>0 InfComInfCaseRatio=$fn((InfComInfCaseCnt/PatAdmCnt)*100,"",2)_"%" //社区现患例次率
            
            Set SurPatRatio="0.00%"
            Set:PatAdmCnt>0 SurPatRatio=$fn((SurPatCnt/PatAdmCnt)*100,"",2)_"%" //实查率
            Set InfPatRatio="0.00%",InfCaseRatio="0.00%"
            Set:PatAdmCnt>0 InfPatRatio=$fn((InfPatCnt/PatAdmCnt)*100,"",2)_"%" //现患率
            Set:PatAdmCnt>0 InfCaseRatio=$fn((InfCaseCnt/PatAdmCnt)*100,"",2)_"%" //现患例次率
            Set ComInfPatRatio="0.00%",ComInfCaseRatio="0.00%"
            Set:PatAdmCnt>0 ComInfPatRatio=$fn((ComInfPatCnt/PatAdmCnt)*100,"",2)_"%" //社区现患率
            Set:PatAdmCnt>0 ComInfCaseRatio=$fn((ComInfCaseCnt/PatAdmCnt)*100,"",2)_"%" //社区现患例次率
  
            Set Data=$lb("","全部",PatAdmCnt,SurPatCnt,SurPatRatio,InfPatCnt,InfPatRatio,InfCaseCnt,InfCaseRatio,ComInfPatCnt,ComInfPatRatio,ComInfCaseCnt,ComInfCaseRatio,InfComInfPatCnt,InfComInfCaseCnt,InfComInfPatRatio,InfComInfCaseRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreByCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreByCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreByCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreByCSSExecute ]
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
/// Description:  医院感染（例次）现患病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aTypeFlag :统计类型 1：应查人数2：实查人数 3：感染人数4：感染例数
///               aInfTypeFlag: 1：社区感染 0：医院感染
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S410CssInf","QryInfPreDtlByCSS","3","0000-00-0000-A-1",3,"1")
Query QryInfPreDtlByCSS(aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String, aInfTypeFlag As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,CSSReportID:%String,CSSRepDianos:%String") [ SqlProc ]
{
}

ClassMethod QryInfPreDtlByCSSExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aTypeFlag As %String, aInfTypeFlag As %String, aStaType As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    Quit:(aSurNumID="")||(aTypeFlag="") $$$OK
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
	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:+aHospIDs="0" aHospIDs=""
	Set:aStaType'="W" aStaType="E"
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Quit:(aLocType'="")&(aLocType'=aStaType) $$$OK
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set NIndex="QryInfPreDtlByCSS"
    Kill ^TMP($zn,$j,NIndex)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set:aLocType="" StatType=aStaType
    Set InfType=$Case(aInfTypeFlag,1:"社区感染",0:"医院感染",:"")
    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed("1",aDateFrom,aDateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate(DateFrom,DateTo,StatType,"","I")
    Set xPaadms=""
        
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
        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
        Continue:(aLocType'="")&&(LocID'=aLocDr)
        
        //取横断面对应感染信息
        Set CSSInfDianosInfo=..GetCSSInfDianosInfo(aSurNumID,Paadm,InfType)
        Set CSSReportID=$p(CSSInfDianosInfo,"!!",1)
        Set CSSInfPos    = $p(CSSInfDianosInfo,"!!",3) // 医院感染部位
        Set CSSComInfPos = $p(CSSInfDianosInfo,"!!",4) // 社区感染部位
        Set InfCategory=$p(CSSInfDianosInfo,"!!",5)

        Set tInfCategory=""
        If (InfCategory="医院感染"){
            Set tInfCategory=0
        }
        If (InfCategory="社区感染"){
            Set tInfCategory=1
        }
        If (InfCategory="医院+社区"){
            Set tInfCategory=10
        }
        Continue:(aInfTypeFlag'="")&&(tInfCategory'[aInfTypeFlag)
        Continue:(aTypeFlag=2)&&(CSSReportID="")
        Continue:(aTypeFlag=3)&&((CSSInfPos="")&&((CSSComInfPos="")))
        Continue:(aTypeFlag=4)&&((CSSInfPos="")&&((CSSComInfPos="")))
        Set:aInfTypeFlag="1" CSSInfPos=""
        Set:aInfTypeFlag="0" CSSComInfPos=""

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
   
        If (aTypeFlag=1)||(aTypeFlag=2)||(aTypeFlag=3) {
	        continue:(aInfTypeFlag=0)&&(CSSInfPos="")
            continue:(aInfTypeFlag=1)&&(CSSComInfPos="")      //补丁-防止有人填了医院+社区但是没有填具体的感染部位
            //应查人数、实查人数、感染人数
            Set CSSRepDianos=CSSInfPos_"^"_CSSComInfPos
            Set:CSSRepDianos="^" CSSRepDianos=""
            Set CSSRepDianos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(CSSRepDianos,"^")    
             
            Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,CSSReportID,CSSRepDianos)   
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        } ElseIf aTypeFlag=4 {
            //感染例数
            Set tCSSRepDianos=CSSInfPos_"^"_CSSComInfPos
            Set tCSSRepDianos=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(tCSSRepDianos,"^")  
            For indRD=1:1:$l(tCSSRepDianos,"^") {
                Set tRepDiagnos=$p(tCSSRepDianos,"^",indRD)
                Continue:tRepDiagnos=""

                Set CSSRepDianos=tRepDiagnos
               
                Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,CSSReportID,CSSRepDianos) 
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryInfPreDtlByCSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreDtlByCSSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPreDtlByCSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreDtlByCSSExecute ]
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
