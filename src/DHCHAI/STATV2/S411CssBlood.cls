/// 名称: DHCHAI.STATV2.S411CssBlood
/// 描述: 横断面-输血和经血传播疾病感染情况统计
/// 编写者：zhoubo
/// 编写日期: 2021-07-07
Class DHCHAI.STATV2.S411CssBlood Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-07-07
/// Description:  输血和经血传播疾病感染情况统计
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aStaType ：科室/病区类型 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S411CssBlood","CssQryBloodInfo","2","W")
Query CssQryBloodInfo(aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SurNumber:%String,DimensKey:%String,DimensDesc:%String,JMSY11:%String,JMSY10:%String,JMSY21:%String,JMSY20:%String,JMSY3Y:%String,JMSY3N:%String,JMSY3U:%String,JMSY4Y:%String,JMSY4N:%String,JMSY4U:%String,JMSY5Y:%String,JMSY5N:%String,JMSY5U:%String,JMSY6Y:%String,JMSY6N:%String,JMSY6U:%String,JCJB11:%String,JCJB10:%String,JCJB21:%String,JCJB20:%String,JCJB31:%String,JCJB30:%String,JCJB41:%String,JCJB40:%String,JCJB51:%String,JCJB50:%String,JCJB61:%String,JCJB60:%String,JCJB71:%String,JCJB70:%String,JCJB81:%String,JCJB80:%String,JCJB91:%String,JCJB90:%String,SurPatCnt:%String") [ SqlProc ]
{
}

ClassMethod CssQryBloodInfoExecute(ByRef qHandle As %Binary, aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aSurNumID="") $$$OK
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
    Set NIndex="CssQryBloodInfo"
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
    Set xPaadms=""
 
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
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
              
        // 取横断面对应输血和经血传播疾病感染情况
        // "1#1#Y#Y#N#U","1#1#1#1#0#1#1#1#1"
        Set (JMSY1,JMSY2,JMSY3,JMSY4,JMSY5,JMSY6)=""
        Set (JCJB1,JCJB2,JCJB3,JCJB4,JCJB5,JCJB6,JCJB7,JCJB8,JCJB9)=""
        Set xCSSID=0,IsSurPat=0
        For {
            Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm,xCSSID))
            Quit:xCSSID=""
			Set RepFlag =0   //报告状态位判断
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
	            Set RepFlag =1
	        }
			Continue:RepFlag=0
            // Add by zhaoyj 2022-06-17 Global方式
            Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
            Continue:CSSData=""
            Continue:$lg(CSSData,5)'=1
            //是 1 否 0 存在 Y 不存在 N 未查 U(default) 未选""(备用)
            /// 输液（调查日）和经血传播病毒情况（住院期间） Blood transfusion
            /// 静脉输液#静脉输液是否抗菌药物#乙肝感染#丙肝感染#HIV感染#梅毒感染 6
            /// 是 1 否 0 存在 Y 不存在 N 未查 U(default) 未选""(备用)
            Set IRTransBloodInf = $lg(CSSData,32)
            Set JMSY1 = $p(IRTransBloodInf,"#",1)
            Set:JMSY1="" JMSY1="default"
            Set JMSY2 = $p(IRTransBloodInf,"#",2)
            //Set:JMSY2="" JMSY2="default"
            Set JMSY3 = $p(IRTransBloodInf,"#",3)
            Set:JMSY3="" JMSY3="default"
            Set JMSY4 = $p(IRTransBloodInf,"#",4)
            Set:JMSY4="" JMSY4="default"
            Set JMSY5 = $p(IRTransBloodInf,"#",5)
            Set:JMSY5="" JMSY5="default"
            Set JMSY6 = $p(IRTransBloodInf,"#",6)
            Set:JMSY6="" JMSY6="default"
            /// 基础疾病和危险因素  
            /// 实体肿瘤#血液系统恶性肿瘤#糖尿病#呼吸衰竭#肾功能补全#肝硬化#昏迷#使用免疫抑制剂#使用糖皮质激素 9
            /// 是1 否0
            //是1 否0
            Set IRBaseRisk = $lg(CSSData,33)
            Set JCJB1 =  $p(IRBaseRisk,"#",1)
            Set:JCJB1="" JCJB1="default"
            Set JCJB2 =  $p(IRBaseRisk,"#",2)
            Set:JCJB2="" JCJB2="default"
            Set JCJB3 =  $p(IRBaseRisk,"#",3)
            Set:JCJB3="" JCJB3="default"
            Set JCJB4 =  $p(IRBaseRisk,"#",4)
            Set:JCJB4="" JCJB4="default"
            Set JCJB5 =  $p(IRBaseRisk,"#",5)
            Set:JCJB5="" JCJB5="default"
            Set JCJB6 =  $p(IRBaseRisk,"#",6)
            Set:JCJB6="" JCJB6="default"
            Set JCJB7 =  $p(IRBaseRisk,"#",7)
            Set:JCJB7="" JCJB7="default"
            Set JCJB8 =  $p(IRBaseRisk,"#",8)
            Set:JCJB8="" JCJB8="default"
            Set JCJB9 =  $p(IRBaseRisk,"#",9)
            Set:JCJB9="" JCJB9="default"
            Set IsSurPat=1
        }
        continue:IsSurPat=0 
        //统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
        Continue:StatDimensInfo=""
        For indDimens=1:1:$l(StatDimensInfo,"^") {
            Set DimensKey=$p(StatDimensInfo,"^",indDimens)
            Continue:DimensKey=""
            //实查人数（调查人数）
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY1",JMSY1))
            Set:JMSY2'="" num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY2",JMSY2))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY3",JMSY3))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY4",JMSY4))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY5",JMSY5))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JMSY6",JMSY6))
            
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB1",JCJB1))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB2",JCJB2))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB3",JCJB3))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB4",JCJB4))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB5",JCJB5))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB6",JCJB6))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB7",JCJB7))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB8",JCJB8))
            Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"JCJB9",JCJB9))
            If (LocCount>1) {
				Set locDr = +$p(DimensKey,"-",3)
        		Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_locDr_","))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","SurPat"))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY1",JMSY1))
                Set:JMSY2'="" num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY2",JMSY2))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY3",JMSY3))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY4",JMSY4))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY5",JMSY5))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JMSY6",JMSY6))
                
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB1",JCJB1))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB2",JCJB2))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB3",JCJB3))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB4",JCJB4))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB5",JCJB5))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB6",JCJB6))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB7",JCJB7))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB8",JCJB8))
                Set num=$i(^TMP($zn,$j,NIndex,"Sum","JCJB9",JCJB9))
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
        do BuildData
        Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //实查人数
        Set Data=$lb(SurNumber,xDimensKey,DimensDesc,JMSY11,JMSY10,JMSY21,JMSY20,JMSY3Y,JMSY3N,JMSY3U,JMSY4Y,JMSY4N,JMSY4U,JMSY5Y,JMSY5N,JMSY5U,JMSY6Y,JMSY6N,JMSY6U)
        Set Data=Data_$lb(JCJB11,JCJB10,JCJB21,JCJB20,JCJB31,JCJB30,JCJB41,JCJB40,JCJB51,JCJB50,JCJB61,JCJB60,JCJB71,JCJB70,JCJB81,JCJB80,JCJB91,JCJB90,SurPatCnt)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
        
    }
    
    If (LocCount>1) {
        Set xDimensKey="Sum"
        do BuildData
        Set SurPatCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))  //实查人数
        Set Data=$lb(SurNumber,"","全部",JMSY11,JMSY10,JMSY21,JMSY20,JMSY3Y,JMSY3N,JMSY3U,JMSY4Y,JMSY4N,JMSY4U,JMSY5Y,JMSY5N,JMSY5U,JMSY6Y,JMSY6N,JMSY6U)
        Set Data=Data_$lb(JCJB11,JCJB10,JCJB21,JCJB20,JCJB31,JCJB30,JCJB41,JCJB40,JCJB51,JCJB50,JCJB61,JCJB60,JCJB71,JCJB70,JCJB81,JCJB80,JCJB91,JCJB90,SurPatCnt)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
    
BuildData
        Set JMSY11 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY1","1")) 
        Set JMSY10 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY1","0"))
        Set JMSY21 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY2","1"))
        Set JMSY20 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY2","0"))
        Set JMSY3Y =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY3","Y")) 
        Set JMSY3N =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY3","N"))
        Set JMSY3U =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY3","U"))
        Set JMSY4Y =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY4","Y"))
        Set JMSY4N =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY4","N"))
        Set JMSY4U =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY4","U"))
        Set JMSY5Y =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY5","Y"))
        Set JMSY5N =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY5","N"))
        Set JMSY5U =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY5","U"))
        Set JMSY6Y =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY6","Y"))
        Set JMSY6N =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY6","N"))
        Set JMSY6U =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JMSY6","U"))
                                                                  
        Set JCJB11 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB1","1"))
        Set JCJB10 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB1","0"))
        Set JCJB21 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB2","1"))
        Set JCJB20 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB2","0"))
        Set JCJB31 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB3","1"))
        Set JCJB30 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB3","0"))
        Set JCJB41 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB4","1"))
        Set JCJB40 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB4","0"))
        Set JCJB51 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB5","1"))
        Set JCJB50 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB5","0"))
        Set JCJB61 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB6","1"))
        Set JCJB60 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB6","0"))
        Set JCJB71 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB7","1"))
        Set JCJB70 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB7","0"))
        Set JCJB81 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB8","1"))
        Set JCJB80 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB8","0"))
        Set JCJB91 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB9","1"))
        Set JCJB90 =+$g(^TMP($zn,$j,NIndex,xDimensKey,"JCJB9","0"))
}

ClassMethod CssQryBloodInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryBloodInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryBloodInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryBloodInfoExecute ]
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

/// Description:  输血和经血传播疾病感染情况明细统计   基础疾病 明细统计      
/// Input:                    
/// return:  
/// Creator：     liuzhenhe
/// CreatDate：   2022-12-01
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S411CssBlood","CssQryBloodDetailInfo","2","0000-00-0000-A-1","W","JCJB","实体肿瘤","N","")
Query CssQryBloodDetailInfo(aSurNumID As %String, aDimensKey As %String, aStaType As %String, aCode As %String = "", aDesc As %String = "", aResult As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocDr:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,aDesc:%String,aResult:%String") [ SqlProc ]
{
}

ClassMethod CssQryBloodDetailInfoExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aStaType As %String, aCode As %String = "", aDesc As %String = "", aResult As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)

    Quit:(aSurNumID="") $$$OK
    Set SurvData = $g(^DHCHAI.IR.SurveyExecD(aSurNumID))
    Quit:SurvData="" $$$OK
    Set DateFrom = $li(SurvData,5)    //通过调查定义表取开始结束日期
    Set DateTo   = $li(SurvData,6)
    Set SurNumber = $li(SurvData,2)
    Set HospDr   = $li(SurvData,3)
    Quit:HospDr="" $$$OK

    Set DateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateFrom)
    Set DateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DateTo)
    Set DimensMark  = $p(aDimensKey,"-",4)  
    Set aLocType   = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    
    Set StatType = aLocType                                     //1.统计类型(W|E)-aLocType
    Set aHospIDs    = +$p(aDimensKey,"-",1)                     //2.统计院区-aHospIDs
    Set:aHospIDs="0" aHospIDs=""    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set:aLocType="" StatType=aStaType
    
    Set NIndex="CssQryBloodDetailInfo"
    Kill ^TMP($zn,$j,NIndex)
     //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         //##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate(StatType,aDateFrom,aDateTo,"")
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
        Continue:'..CheckCssRep(aSurNumID,Paadm)
        Continue:(aLocDr'="")&(aLocDr'=LocDr)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
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
        Set Result=aResult
        // 取横断面对应输血和经血传播疾病感染情况
        // "1#1#Y#Y#N#U","1#1#1#1#0#1#1#1#1"
        if (aCode'="")||(aDesc'=""){
            set pos=..getPos(aCode, aDesc)
            continue:+pos<1
            Set xCSSID=0
            For {
                Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,Paadm,xCSSID))
                Quit:xCSSID=""

                Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
                Continue:CSSData=""
                Continue:$lg(CSSData,5)'=1

                //是 1 否 0 存在 Y 不存在 N 未查 U(default) 未选""(备用)
                Set IRTransBloodInf = $lg(CSSData,32)
                Set JMSYVal=$p(IRTransBloodInf,"#",pos)
               
                if JMSYVal="" {
                    Set:+pos<2 JMSYVal="default"
                    Set:+pos>=3 JMSYVal="default"
                }
                //是1 否0
                Set IRBaseRisk = $lg(CSSData,33)
                Set JCJBVal=$p(IRBaseRisk,"#",pos)
                if JCJBVal="" {
                    Set JCJBVal="default"
                }
            }
            if aCode="JMSY" {
                continue:(aResult'="")&&(JMSYVal'=aResult)
                 Set Result=$case(JMSYVal,"1":"是","0":"否","Y":"存在","N":"不存在","U":"未查",:"")
            }elseif aCode="JCJB" {
                 continue:(aResult'="")&&(JCJBVal'=aResult)
                 Set Result=$case(JCJBVal,"1":"是","0":"否","Y":"存在","N":"不存在","U":"未查",:"")
            }else{
                continue:aCode'=""   //之外的情况
            }
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
        //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数  
        Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocDr,LocDesc,TransDateTime,OutLocDateTime,aDesc,Result)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
   
    Kill ^TMP($zn,$j,NIndex)
    Quit $$$OK
}

ClassMethod CssQryBloodDetailInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryBloodDetailInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CssQryBloodDetailInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryBloodDetailInfoExecute ]
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

/// Description:  获得对应字典
/// Table：       
/// Input:                    
/// return:  
/// Creator：     liuzhenhe
/// CreatDate：   2022-12-01
///  w ##class(DHCHAI.STATV2.S411CssBlood).getPos("JMSY","静脉输液")
ClassMethod getPos(aCode, aDesc) As %String
{
    new (aCode,aDesc)
    Quit:(aCode="")||(aDesc="")
    Set pos=""
    Set pos("JMSY","静脉输液")="1"
    Set pos("JMSY","含抗菌药物")="2"
    Set pos("JMSY","乙肝")="3"
    Set pos("JMSY","丙肝")="4"
    Set pos("JMSY","HIV")="5"
    Set pos("JMSY","梅毒")="6"
    
    Set pos("JCJB","实体肿瘤")="1"
    Set pos("JCJB","血液系统恶性肿瘤")="2"
    Set pos("JCJB","糖尿病")="3"
    Set pos("JCJB","呼吸衰竭")="4"
    Set pos("JCJB","肾功能不全")="5"
    Set pos("JCJB","肝硬化")="6"
    Set pos("JCJB","昏迷")="7"
    Set pos("JCJB","使用免疫抑制剂")="8"
    Set pos("JCJB","使用糖皮质激素")="9"

    if $d(pos(aCode,aDesc)) {
        Set return=$g(pos(aCode,aDesc))
        Quit return
    }
    Quit "0"
}

}
