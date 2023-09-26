/// 通用服务类
Class DHCHAI.IRS.UtilHCSSSrv Extends %RegisteredObject
{

/*  //启用虚拟病区查询
    Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")
    If (IsStatParWard=1) {
        
        
    }*/
/// select * from DHCHAI.DP.PAAdmTrans where TransType=B and ((xTransDays="-1")and (xTransDate<aDateTo)) and ((xTransDays>0) and (xTransDate>=))
/// Description:  取科室一段时间在床患者列表
/// Table：       
/// Input:                    
/// return:       reType 默认由床位返回所在病区
/// Creator：     liuzhenhe
/// CreatDate：   2022-12
/// zw ##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed("1","2022-07-13","2022-07-30","W")    
ClassMethod GetLocEpisByBed(hospIds As %String, fromDateTime As %String, toDateTime As %String, reType As %String = "B-W", ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
    
    Set:reType'["-" reType="B-"_reType   
    Set TransType=$p(reType,"-",1)
    Set LocType=$p(reType,"-",2)
    
    //Quit:hospIds="" $$ArguErr("hospId不能为空")
    Quit:(fromDateTime="")||(toDateTime="") $$ArguErr("开始时间、结束时间不能为空")
    Set (DateFrom,TimeFrom,DateTo,TimeTo)=""
    Set DateFrom=$p(fromDateTime," ",1)
    Set TimeFrom=$p(fromDateTime," ",2)
    Set DateTo=$p(toDateTime," ",1)
    Set TimeTo=$p(toDateTime," ",2)
    Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
    Set:TimeFrom[":" TimeFrom=$zth(TimeFrom,1)
    Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)
    Set:TimeTo[":" TimeTo=$zth(TimeTo,1)
    #;    Set ADate=DateFrom_TimeFrom
    #;    Set BDate=DateTo_TimeTo

    Quit:(DateFrom="")||(DateTo="") $$ArguErr("开始日期、结束日期不能为空")
    Quit:'$d(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",TransType)) $$ArguErr("医院没有转科记录")
    Set INFCSSHPFlag=##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    Set Count=0,return=##Class(%Library.ArrayOfDataTypes).%New()
    Set $ZT="GetLocEpisByLocDateErr"
    kill ArrTran
 
    // 获取最早一个转床记录点
    Set xTransDays=""
    For {
        Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",TransType,xTransDays))
        Quit:xTransDays=""
        Set xTransDate=""
        
       //xTransDays<0 表示在科病人
        Set xTransDate=""
        //xTransDays>0 表示出科病人
        Set:xTransDays>=0 xTransDate=DateFrom-xTransDays
        For {
            Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",TransType,xTransDays,xTransDate))
            Quit:xTransDate=""
            Quit:xTransDate>DateTo  //转入日期大于截止日期
            
            Set xTransID=""
            For {
                Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",TransType,xTransDays,xTransDate,xTransID))
                Quit:xTransID=""
                Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
                Continue:TranData=""
                Set TransDate=$lg(TranData,7)   ;objTrans.PATransDate
                Set TransTime=$lg(TranData,8)   ;objTrans.PATransTime
                Set TransTime=+TransTime
                Set:TransTime=0 TransTime=1
             
                Set OutLocDate=$lg(TranData,10) ;objTrans.PAOutLocDate
                Set OutLocTime=+$lg(TranData,11) ;objTrans.PAOutLocTime
                Continue:(TransDate=DateTo)&&(TransTime>TimeTo)     //转入时间在规定时间之外
                Set:+OutLocDate=0 TransXDate=+$h
                Set:OutLocTime=0 OutLocTime=1
                Set EpisodeDr=$lg(TranData,3)   //objTrans.PAEpisodeDr.%Id()
                Continue:EpisodeDr=""
                Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
                Continue:(AdmData="")||($lg(AdmData,19)="C")||($lg(AdmData,19)="P")||($lg(AdmData,19)="U")           //||($lg(AdmData,18)'="I")
                Set ArrTran(EpisodeDr,TransDate,xTransID,xTransDays)=""
            }
        } 
    }
    Do return.SetAt("OK",Count)
    
    Set xPaadm=""
    For {
        Set xPaadm=$o(ArrTran(xPaadm))
        Quit:xPaadm=""
        //Set VisitStatus = $li($g(^DHCHAI.DP.PAAdmD(xPaadm)),19)
        //Continue:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院P、在院A、出院D、退院C、作废U
        Set xDate="",TransID="",Turn="" //Turn 是相对于开始日期的遍历方向
        Set beforeDate=$o(ArrTran(xPaadm,DateFrom),-1)    //获取前一个时间
        if beforeDate="" {
            Set afterDate=$o(ArrTran(xPaadm,DateFrom-1))    //处理转床和转科日期不在同一天的情况   
            Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,afterDate+1),-1)
            Set:xDate>=DateFrom xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,DateFrom-1))   //如果是转床当天发生了转科，取最早的一次
            Continue:xDate=""

            Continue:xDate>=DateTo
            Set TransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,xDate,""))
            Set PATransDays=$lg($g(^DHCHAI.DP.PAAdmTransD(TransID)),9)
             //时点口径和时段口径  默认时点口径
            if (+INFCSSHPFlag=0) &&(PATransDays=1) {
                Set tID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,xDate,""),-1)   //获取最后的转科记录
                Set PAOutLocDate=$lg($g(^DHCHAI.DP.PAAdmTransD(tID)),10)  
                Continue:PAOutLocDate=xDate      //当天住院当天出院的不要
            }
            Set Turn="1"
        }else{
            
            //说明在开始日期之前住院
            Set xDate = $o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,DateFrom),-1)
            Continue:xDate=""
            Set TransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xPaadm,xDate,""),-1)
            Set Turn="-1"
        }
        Set TransLocDr=$lg($g(^DHCHAI.DP.PAAdmTransD(TransID)),5)  ;objTrans.PATransLocDr.%Id()
        Continue:TransLocDr=""
        Set Count=Count+1
        Set LocEpidInfo=$lb(TransLocDr,xPaadm,TransID,Turn)
        Do return.SetAt(LocEpidInfo,Count)
    }
    kill ArrTran
    Quit return

GetLocEpisByLocDateErr
    Set $ZT=""
    Set aMsgErr=$Zerror
    Do return.Clear()
    Do return.SetAt("异常处理程序: w aMsgErr,!",Count)
    Quit return
ArguErr(Msg)
    Set return=##Class(%Library.ArrayOfDataTypes).%New()
    Do return.SetAt(Msg,0)
    Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-06-17
/// Description:  查询感染部位-诊断信息 报表使用 按照Code排序
/// Table：       DHCHAI.BT.InfPos
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.UtilHCSSSrv","QryInfPosToSelect","")
Query QryInfPosToSelect(aTypeCode As %String = "") As %Query(ROWSPEC = "PosCode:%String,PosDesc:%String,DiagCode:%String,DiagDesc:%String,ID:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosToSelectExecute(ByRef qHandle As %Binary, aTypeCode As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Kill ^TMP($zn,$j,"QryInfPosToSelect")
    Set CSSRepPosDispalyConfig=##class(DHCHAI.BT.Config).GetValByCode("CSSRepPosDispalyConfig")
    if (+CSSRepPosDispalyConfig=0)&&(aTypeCode=""){
        Set aTypeCode="CSSINFDiag"
    }
    if aTypeCode="" {
        do BuildDataByInf
    }else{
        do BuildDataByDic
    }

    Kill ^TMP($zn,$j,"QryInfPosToSelect")
    Quit $$$OK
BuildDataByInf
    
    //感染部位
    Set xCode = ""
    For {
        Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
        Quit:xCode=""
        Set xID = ""
        For {
            Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
            Quit:xID=""
            // Add by zhaoyj 2022-06-17 Global方式
            Set InfPosData = $g(^DHCHAI.BT.InfPosD(xID))
            Continue:InfPosData=""
            
            Set Code     = $lg(InfPosData,2)
            Set Desc     = $lg(InfPosData,3)
            Set DiagFlag = $lg(InfPosData,4)
            Set GCode    = $lg(InfPosData,5)
            Set:GCode="" GCode="9999"
            Set IsActive = $lg(InfPosData,6)
            Continue:IsActive'=1
            Continue:DiagFlag'=0  //查询所有部位
            Set ^TMP($zn,$j,"QryInfPosToSelect","InfPos",xID)=$lb(xID,Code,Desc)
        }
    }
    //感染诊断
    Set PosID=""
    for{
        Set PosID=$o(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID))
        QUit:PosID=""
        Set PosCode=$li($g(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID)),2)
        Set PosDesc=$li($g(^TMP($zn,$j,"QryInfPosToSelect","InfPos",PosID)),3)
    
        Set xCode = ""
        For {
            Set xCode = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode))
            Quit:xCode=""
            Continue:$e(xCode,1,2)'=PosCode
            Set xID = ""
            For {
                Set xID = $o(^DHCHAI.BT.InfPosI("IdxofCode",xCode,xID))
                Quit:xID=""
                Set InfPosData = $g(^DHCHAI.BT.InfPosD(xID))
                Continue:InfPosData=""
                Set DiagCode =$lg(InfPosData,2)
                Set DiagDesc =$lg(InfPosData,3)
                Set IsActive =$lg(InfPosData,6)
                Continue:IsActive'=1
                Continue:DiagFlag'=1  //查询所有诊断  
                Continue:PosDesc=DiagDesc
                Set Data=$lb(PosCode,PosDesc,DiagCode,DiagDesc,xID)
                Set ^CacheTemp(repid,ind) = Data
                Set ind=ind+1
            }
        }
    }
   

BuildDataByDic
    Quit:aTypeCode="" 
    Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
    Quit:'$IsObject(objType) 
    Set TypeID=objType.%Id()
    
    Set xCode = ""
    For {
        Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode))
        Quit:xCode=""
        
        Set xID = ""
        For {
            Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode,xID))
            Quit:xID=""
            
            Set DicData = $g(^DHCHAI.BT.DictionaryD(xID))
            Continue:DicData=""
            
            Set DicCode  = $lg(DicData,2)
            Set DicDesc  = $lg(DicData,3)
            Set IndNo  = $lg(DicData,5)
            Set IndNo=$tr($j(IndNo, 7), " ", "0")    //不足7位补足
            Set:$l(IndNo)>7 IndNo="9999999"_IndNo    //超过7位太不正常
            Set IsActive  = $lg(DicData,6)
            Continue:IsActive'=1
            Set ^TMP($zn,$j,"QryInfPosToSelect","IndNo",IndNo)=$lb(xID,DicCode,DicDesc)
       }
    }
    //感染诊断
    Set xIndNo=""
    for{
        Set xIndNo=$o(^TMP($zn,$j,"QryInfPosToSelect","IndNo",xIndNo))
        QUit:xIndNo=""
        Set ID=$lg($g(^TMP($zn,$j,"QryInfPosToSelect","IndNo",xIndNo)),1)
        Set DiagCode=$lg($g(^TMP($zn,$j,"QryInfPosToSelect","IndNo",xIndNo)),2)
        Set DiagDesc=$lg($g(^TMP($zn,$j,"QryInfPosToSelect","IndNo",xIndNo)),3)
        Set Data=$lb("","",DiagCode,DiagDesc,ID)
        Set ^CacheTemp(repid,ind) = Data
        Set ind=ind+1

    }
}

ClassMethod QryInfPosToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
    set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryInfPosToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosToSelectExecute ]
{
    set AtEnd=$LIST(qHandle,1)
    set repid=$LIST(qHandle,2)
    set ind=$LIST(qHandle,3)
    set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        set AtEnd=1
        set Row=""
    }
    Else      {             // fetch row
        set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
