Class DHCHAI.STATV2.S410SHCssInf Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LZH
/// CreatDate：   2022-12-26
/// Description:  现患率统计
/// Input：       aDateFrom : 开始日期
///               aDateTo：结束日期
///               aHospIDs：院区ID
///               aLocIDs：科室ID
///               aLocType：W -病区 E -科室(统计单位)
///               aQryCon：1-全部病区 2-有数据病区(筛选条件)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.STATV2.S410SHCssInf","QryInfPre1","2022-12-01","2022-12-21","1","","E","","")
Query QryInfPre1(aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %Text = "", aLocType As %String = "E", aQryCon As %String = "1", aStatDimens As %String = "") As %Query(ROWSPEC = "ind:%String,DimenCode:%String,LocID:%String,LocDesc:%String,InCount:%Integer,Count:%Integer,CountRatio:%String,HospInfCount:%Integer,HAIRatio:%String,HospInfCase:%Integer,INFRatio:%String,ComInfCount:%Integer,ComHAIRatio:%String,ComInfCase:%Integer,ComINFRatio:%String") [ SqlProc ]
{
}

ClassMethod QryInfPre1Execute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aHospIDs As %String = "", aLocIDs As %Text = "", aLocType As %String = "E", aQryCon As %String = "2", aStatDimens As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
   
    Set:aLocType'="W" aLocType="E"
    Set listLocID=$listfromstring(aLocIDs,",")
 
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aLocType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
    
    Set NIndex="QryInfPre1"
    Kill ^TMP($zn,$j,NIndex)

    //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:LocID=""
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set HospDr=$li(LocData,8)
            
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocID,LocID)
        For indDimens=1:1:$l(StatDimensInfo,"^") {
            Set DimensKey=$p(StatDimensInfo,"^",indDimens)
            Continue:DimensKey=""
            // 全院住院患者人数
            If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
            {
                Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
                Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
            }
            
            // 全院科室患者
            If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)) {
                // 科室患者
                Set ^TMP($zn,$j,NIndex,DimensKey,"PatLocAdm",LocID,Paadm)="" 
                Set (aLocID,aWardID) = ""  
                if StatType="E" {
                    Set aLocID  = LocID
                }else{
                    Set aWardID = LocID
                }
                // 科室患者感染
                Set InfPosInfo=##class(DHCHAI.STATV2.S410SHCssInf).GetInfPosInfo(Paadm,aDateFrom,aDateTo,aLocID,aWardID)
                If (InfPosInfo'="") {
                    For InfNo=1:1:$L(InfPosInfo,"|") {
                        Set InfPosMsg=$p(InfPosInfo,"|",InfNo)
                        continue:InfPosMsg=""
                        Set DiagID  = $p(InfPosMsg,"^",1)
                        Set InfDate = $p(InfPosMsg,"^",3)
                        Set InfType=$p(InfPosMsg,"^",7)
                        
                        If (InfType="医院感染") {
                            If '$d(^TMP($zn,$j,NIndex,DimensKey,"HospInfPat",Paadm)) {
                                Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"HospInfPat"))
                                Set ^TMP($zn,$j,NIndex,DimensKey,"HospInfPat",Paadm)=""
                            }
                            //记录医院感染例次数
                            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"HospInfCase"))
                        }
                        
                        If (InfType="社区感染") {
                            If '$d(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat",Paadm)) {
                                Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfPat"))
                                Set ^TMP($zn,$j,NIndex,DimensKey,"ComInfPat",Paadm)=""
                            }
                            //记录医院感染例次数
                            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"ComInfCase"))
                        }
                    }
                }                                   
            }
        }
    }
    
    // 输出Data
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListToString(aHospIDs,"|")
    Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
    Set xDimensKey=""
    For DimIndx=1:1:ArryStatDimens.Count() {
        Set DimList=ArryStatDimens.GetAt(DimIndx)
        Set DimenCode   = $lg(DimList,1)
        Set LocDesc = $lg(DimList,3)
        Set IsActive    = $lg(DimList,4)
        Continue:DimenCode=""
        Set LocDr = +$p(DimenCode,"-",3)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set InCount     =+$g(^TMP($zn,$j,NIndex,DimenCode,"PatAdm"))            //在院患者数(应查人数)
        Set Count       =InCount                                                //实查人数
        Set:InCount>0 CountRatio=$fn((Count/InCount)*100,"",2)_"%"  //实查率
        Set HospInfCount =+$g(^TMP($zn,$j,NIndex,DimenCode,"HospInfPat"))           //医院感染人数
        Set HospInfCase  =+$g(^TMP($zn,$j,NIndex,DimenCode,"HospInfCase"))          //医院感染例次数
        Set ComInfCount  =+$g(^TMP($zn,$j,NIndex,DimenCode,"ComInfPat"))            //社区感染人数
        Set ComInfCase   =+$g(^TMP($zn,$j,NIndex,DimenCode,"ComInfCase"))           //社区感染例次数
        
        Set HAIRatio="0.00%",INFRatio="0.00%"
        Set:InCount>0 HAIRatio=$fn((HospInfCount/InCount)*100,"",2)_"%"     //感染率
        Set:InCount>0 INFRatio=$fn((HospInfCase/InCount)*100,"",2)_"%"      //感染例次率
        
        Set ComHAIRatio="0.00%",ComINFRatio="0.00%"
        Set:InCount>0 ComHAIRatio=$fn((ComInfCount/InCount)*100,"",2)_"%"   //感染率
        Set:InCount>0 ComINFRatio=$fn((ComInfCase/InCount)*100,"",2)_"%"    //感染例次率
        
        Continue:(IsActive="0")&&(InCount=0)
        Continue:(aQryCon="2")&&(HospInfCount=0)&&(ComInfCount=0)
        Continue:(aQryCon="3")&&(InCount=0)
        Set Data=$lb("",DimenCode,"",LocDesc,InCount,Count,CountRatio,HospInfCount,HAIRatio,HospInfCase,INFRatio,ComInfCount,ComHAIRatio,ComInfCase,ComINFRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
        if (LocCount>1){
            Set ^TMP($zn,$j,NIndex,"Sum","PatAdm")=InCount     +$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))            //在院患者数(应查人数)
            Set ^TMP($zn,$j,NIndex,"Sum","HospInfPat")=HospInfCount +$g(^TMP($zn,$j,NIndex,"Sum","HospInfPat"))           //医院感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","HospInfCase")=HospInfCase  +$g(^TMP($zn,$j,NIndex,"Sum","HospInfCase"))          //医院感染例次数
            Set ^TMP($zn,$j,NIndex,"Sum","ComInfPat")=ComInfCount  +$g(^TMP($zn,$j,NIndex,"Sum","ComInfPat"))            //社区感染人数
            Set ^TMP($zn,$j,NIndex,"Sum","ComInfCase")=ComInfCase   +$g(^TMP($zn,$j,NIndex,"Sum","ComInfCase"))           //社区感染例次数    
        }
    }       
    if (LocCount>1){
        Set InCount     =+$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))            //在院患者数(应查人数)
        Set Count       =InCount                                                //实查人数
        Set:InCount>0 CountRatio=$fn((Count/InCount)*100,"",2)_"%"  //实查率
        Set HospInfCount =+$g(^TMP($zn,$j,NIndex,"Sum","HospInfPat"))           //医院感染人数
        Set HospInfCase  =+$g(^TMP($zn,$j,NIndex,"Sum","HospInfCase"))          //医院感染例次数
        Set ComInfCount  =+$g(^TMP($zn,$j,NIndex,"Sum","ComInfPat"))            //社区感染人数
        Set ComInfCase   =+$g(^TMP($zn,$j,NIndex,"Sum","ComInfCase"))           //社区感染例次数
        Set HAIRatio="0.00%",INFRatio="0.00%"
        Set:InCount>0 HAIRatio=$fn((HospInfCount/InCount)*100,"",2)_"%"     //感染率
        Set:InCount>0 INFRatio=$fn((HospInfCase/InCount)*100,"",2)_"%"      //感染例次率
        
        Set ComHAIRatio="0.00%",ComINFRatio="0.00%"
        Set:InCount>0 ComHAIRatio=$fn((ComInfCount/InCount)*100,"",2)_"%"   //感染率
        Set:InCount>0 ComINFRatio=$fn((ComInfCase/InCount)*100,"",2)_"%"    //感染例次率
        
        Set Data=$lb("","","","全部",InCount,Count,CountRatio,HospInfCount,HAIRatio,HospInfCase,INFRatio,ComInfCount,ComHAIRatio,ComInfCase,ComINFRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryInfPre1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPreExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryInfPre1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPreExecute ]
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

/// Creator：     LZH
/// CreatDate：   2022-12-26
/// Description:  现患率--住院患者感染（例次）发病率明细表(包括社区感染和医院感染)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        
///               aDateFrom：开始日期
///               aDateTo：  结束日期
///               aDimensKey：统计维度
///               aDimensType：统计类型(默认W)
///               aInfType：感染类型(0:社区感染，1:医院感染)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S410SHCssInf","QryS030InfPreDtl","2022-12-01","2022-12-23","0001-07-0209-E-4")
Query QryS030InfPreDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aInfType As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,tmpInfPosID:%String,InfType:%String,tmpInfPosDescs:%String,InfDate:%String,InfEffect:%String,InfXDate:%String") [ SqlProc ]
{
}

ClassMethod QryS030InfPreDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aDimensType As %String = "W", aInfType As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)     //院区
    Set:aHospIDs="0" aHospIDs=""
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")   //科室类型
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")       //科室组
    Set aLocDr=""                                                           //科室
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set NIndex="QryS030InfPreDtl"
    Kill ^TMP($zn,$j,NIndex)
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)

    //同期在科、在病区
    Set:aDimensType'="W" aDimensType="E"  //不是病区就是科室
    Set StatType=aLocType
    Set:aLocType="" StatType=aDimensType
    //横断面调查病人就诊列表
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,StatType)         
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
        Continue:(TransID="")
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        Continue:(aLocDr'="")&(aLocDr'=LocID)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
        Set LocDesc = $li(LocData,3)
        Set HospDr  = $li(LocData,8)
        //医院分组过滤
        Continue:HospDr=""
        Set HospInfo="",HospGroupDr=""
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)
        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)      
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
        //院区过滤
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
            
        }
        Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
        Set GroupDesc=$li(GroupData,3)
        //按科室组、科室/病区过滤
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
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
        Set (aLocID,aWardID)=""
         
        if StatType="E" {
           Set aLocID  = LocID
        }else{
           Set aWardID = LocID
         }    
        //患者感染信息
        Set InfPoss =##class(DHCHAI.STATV2.S410SHCssInf).GetInfPosInfo(Paadm,aDateFrom,aDateTo,aLocID,aWardID)
        
        Continue:InfPoss=""
       
        Set (InfPosDescs,InfDates,InfEffects)=""
        For indxi=1:1:$l(InfPoss,"|") {
            
            Set tmpInfPos       = $p(InfPoss,"|",indxi)
            Set tmpInfPosID     = $p(tmpInfPos,"^",1)
            Set tmpInfPosDescs  = $p(tmpInfPos,"^",2)
            Set InfDate         = $p(tmpInfPos,"^",3)
            Set InfXDate         = $p(tmpInfPos,"^",4)
            Set:InfDate'="" InfDate = $zd(InfDate,3)
            Set:InfXDate'="" InfXDate = $zd(InfXDate,3)
            Set InfEffect       = $p(tmpInfPos,"^",5)
            Set InfType         = $p(tmpInfPos,"^",7)
            
            Continue:(aInfType=0)&(InfType'="社区感染")
            Continue:(aInfType=1)&(InfType'="医院感染")
            
            Set InfData=$lb(tmpInfPosID,InfType,tmpInfPosDescs,InfDate,InfEffect,InfXDate)
            
            Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime)_InfData
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        }
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod QryS030InfPreDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryS030InfPreDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryS010InfDtlExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2020-03-18
/// Description:  判断患者是否发生医院感染,返回感染部位信息(现患率)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.STATV2.S410SHCssInf).GetInfPosInfo("1","65360","65419")
ClassMethod GetInfPosInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String = "", aWardID As %String = "") As %String
{
    New (aEpisodeID,aDateFrom,aDateTo,aLocID,aWardID)
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
            // Add by zhaoyj 2022-06-15 Global方式
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
                Set DiagID=$lg(INFRepExtData,3)
                Continue:DiagID=""
                
                Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(DiagID))
                Continue:DiagsData=""
                Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug 
                                //转归情况
                Set InfEffect=""
                Set IRInfEffectDr=$lg(DiagsData,8)
                If (IRInfEffectDr'=""){
                    Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
                    Set:IRInfEffectDr'="" InfEffect = $lg(IRInfEffectData,3)
                }
                // 感染日期
                Set InfDate  = $lg(DiagsData,5)
                Set InfXDate  = $lg(DiagsData,7)
                Continue:InfDate>aDateTo    // 现患率调查，感染日期大于查询截止日期，非查询期间发生感染
                Continue:(aDateTo'="")&&(InfDate>aDateTo)                   //感染日期大于调查结束日期表明感染还未开始
                if (InfEffect="治愈")||(InfEffect="死亡"){   //只有治愈和死亡才算结束
                    Continue:(+InfXDate'=0)&(InfXDate<=aDateFrom)  //感染转归日期小于调查开始日期即调查时已经结束
                }
                //感染科室归属按统计时间最后所在科室计算
                Set LocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(aEpisodeID,aDateTo,"00:00:01")
                If (aWardID'="") {
                    Set InfLocDr=$p(LocInfo,"^",5)   //所在病区
                    Continue:(InfLocDr'=aWardID)                
                }
                If (aLocID'=""){
                    Set InfLocDr=$p(LocInfo,"^",1)   //所在科室
                    Continue:(InfLocDr'=aLocID)
                }

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
                Continue:InfPosData=""
                Set PosCode=$lg(InfPosData,2)
                Set BigCode=$e(PosCode,1,2)
                Set PosDiagData=""
                Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
                Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
                Set PosDesc=$lg(PosDiagData,3)

                If (InfPos'=""){
                    Set InfPosDescs = InfPosDescs_"|"_DiagID_"^"_$lg(InfPosData,3)_"^"_InfDate_"^"_InfXDate_"^"_InfEffect_"^"_PosDesc_"^"_InfType
                }
            }
        }
    }
    Set:InfPosDescs'="" InfPosDescs = $e(InfPosDescs,2,$l(InfPosDescs))
    Set:InfPosDescs'="" return=InfPosDescs
    Quit return
}

}
