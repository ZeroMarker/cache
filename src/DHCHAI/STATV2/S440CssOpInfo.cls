/// 名称: DHCHAI.STATV2.S440CssOpInfo
/// 描述: 手术相关情况汇总表
/// 编写者：zhoubo
/// 编写日期: 2019-11-20
Class DHCHAI.STATV2.S440CssOpInfo Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-11-20
/// Description:  手术相关情况汇总表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aStaType ：科室/病区类型 
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S440CssOpInfo","CssQryOpInfo","2","W","H","6,7")
Query CssQryOpInfo(aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SurNumber:%String,DimensKey:%String,DimensDesc:%String,PatAdmCnt:%Integer,SurPatCnt:%Integer,OpUseCnt:%Integer,OpUseI:%Integer,OpUseII:%Integer,OpUseIII:%Integer,OpUseIV:%Integer,OpUse0:%Integer") [ SqlProc ]
{
}

ClassMethod CssQryOpInfoExecute(ByRef qHandle As %Binary, aSurNumID As %String, aStaType As %String, aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
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
    Set NIndex="CssQryOpInfo"
	Kill ^TMP($zn,$j,NIndex)
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
       
		//取横断面对应手术信息
		Set CSSOpInfo=..GetOpInfo(aSurNumID,Paadm)
		Set CSSReportID = $p(CSSOpInfo,"!!",1)
		Set OpUse=+$p(CSSOpInfo,"!!",2)
		Set OpUseDesc=$p(CSSOpInfo,"!!",3)
		
		//统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 实查人数
			Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPat"))
			If OpUse=1 {
				//手术人数
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"OpUse"))
				if (OpUseDesc'=""){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,OpUseDesc))
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
        Set SurPatCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPat"))  //实查人数
        Set OpUseCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"OpUse"))  //手术人数
        Set OpUseI    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅰ"))
        Set OpUseII   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅱ"))
        Set OpUseIII  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅲ"))
        Set OpUseIV   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"Ⅳ"))
        Set OpUse0    =+$g(^TMP($zn,$j,NIndex,xDimensKey,"无"))
        
        Set Data=$lb(SurNumber,xDimensKey,DimensDesc,PatAdmCnt,SurPatCnt,OpUseCnt)
        Set Data=Data_$lb(OpUseI,OpUseII,OpUseIII,OpUseIV,OpUse0)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
         If (LocCount>1) {
            Set ^TMP($zn,$j,NIndex,"Sum","SurPat") = SurPatCnt +$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))  //实查人数
            Set ^TMP($zn,$j,NIndex,"Sum","OpUse") = OpUseCnt  +$g(^TMP($zn,$j,NIndex,"Sum","OpUse"))  //手术人数
            Set ^TMP($zn,$j,NIndex,"Sum","Ⅰ") = OpUseI    +$g(^TMP($zn,$j,NIndex,"Sum","Ⅰ"))
            Set ^TMP($zn,$j,NIndex,"Sum","Ⅱ") = OpUseII   +$g(^TMP($zn,$j,NIndex,"Sum","Ⅱ"))
            Set ^TMP($zn,$j,NIndex,"Sum","Ⅲ") = OpUseIII  +$g(^TMP($zn,$j,NIndex,"Sum","Ⅲ"))
            Set ^TMP($zn,$j,NIndex,"Sum","Ⅳ") = OpUseIV   +$g(^TMP($zn,$j,NIndex,"Sum","Ⅳ"))
            Set ^TMP($zn,$j,NIndex,"Sum","无") = OpUse0    +$g(^TMP($zn,$j,NIndex,"Sum","无"))
        }
    }
     If (LocCount>1) {
        Set SurPatCnt =+$g(^TMP($zn,$j,NIndex,"Sum","SurPat"))  //实查人数
        Set OpUseCnt  =+$g(^TMP($zn,$j,NIndex,"Sum","OpUse"))  //手术人数
        Set OpUseI    =+$g(^TMP($zn,$j,NIndex,"Sum","Ⅰ"))
        Set OpUseII   =+$g(^TMP($zn,$j,NIndex,"Sum","Ⅱ"))
        Set OpUseIII  =+$g(^TMP($zn,$j,NIndex,"Sum","Ⅲ"))
        Set OpUseIV   =+$g(^TMP($zn,$j,NIndex,"Sum","Ⅳ"))
        Set OpUse0    =+$g(^TMP($zn,$j,NIndex,"Sum","无"))
        
        Set Data=$lb(SurNumber,"","全部",PatAdmCnt,SurPatCnt,OpUseCnt)
        Set Data=Data_$lb(OpUseI,OpUseII,OpUseIII,OpUseIV,OpUse0)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryOpInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryOpInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryOpInfoExecute ]
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
/// CreatDate：   2019-11-20
/// Description:  横断面手术患者明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aSurNumID ：调查ID
/// 			  aDimensKey: 维度
///               aCssFlg : 1：实查患者 其他:统计手术患者信息 
///               aCutDesc : 切口类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S440CssOpInfo","CssQryOpInfoDtl","2","0001-00-0000-H-1","W","","")
Query CssQryOpInfoDtl(aSurNumID As %String, aDimensKey As %String, aStaType As %String, aCutDesc As %String, aCssFlg As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,TransID:%String,GroupDr:%String,GroupDesc:%String,LocID:%String,LocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,OperFlag:%String,OpCutDesc:%String") [ SqlProc ]
{
}

ClassMethod CssQryOpInfoDtlExecute(ByRef qHandle As %Binary, aSurNumID As %String, aDimensKey As %String, aStaType As %String, aCutDesc As %String, aCssFlg As %String = "", aLocIDs As %Text = "") As %Status
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
    Set aCutDesc=$s(aCutDesc=1:"Ⅰ",aCutDesc=2:"Ⅱ",aCutDesc=3:"Ⅲ",aCutDesc=4:"Ⅳ",aCutDesc=0:"无",1:"")
 
    Set DimensMark  = $p(aDimensKey,"-",4)  
    Set aLocType   = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    
    Set StaType =$p(aDimensKey,"-",$l(aDimensKey,"-"))          //1.统计类型(W|E)-aLocType
    Set aHospIDs    = +$p(aDimensKey,"-",1)                     //2.统计院区-aHospIDs
    Set:aHospIDs="0" aHospIDs=""    
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    Set:aLocType="" StatType=aStaType

    Set NIndex="CssQryOpInfoDtl"
	Kill ^TMP($zn,$j,NIndex)

    //横断面调查病人就诊列表
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(HospDr,DateFrom,DateTo,StatType)         

    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""
        
        Set LocID   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Set TransID = $LIST(TransInfo,3)
        Continue:(TransID="")
        Set TransData = $g(^DHCHAI.DP.PAAdmTransD(TransID))
        Continue:TransData=""
        //未调查
        Continue:'..CheckCssRep(aSurNumID,Paadm)
         Continue:(aLocDr'="")&(aLocDr'=LocID)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocID_","))
        Set TransType=$li(TransData,4)
        
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
        
        //取横断面对应手术信息
        Set CSSOpInfo=..GetOpInfo(aSurNumID,Paadm)
        Set CSSReportID = $p(CSSOpInfo,"!!",1)
        Set OperFlag=+$p(CSSOpInfo,"!!",2)
        Set OpCutDesc=$p(CSSOpInfo,"!!",3)
        Continue:((aCssFlg="")&&(OperFlag'=1))       // 过滤非手术患者
        Continue:((aCutDesc'="")&&(aCutDesc'=OpCutDesc)) // 切口类型过滤
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
        Set OperFlag=$s(OperFlag=1:"是",1:"否")
        Set Data=$lb(DimensDesc,AdmTimes)_PatData_$lb(TransID,GroupDr,GroupDesc,LocID,LocDesc,TransDateTime,OutLocDateTime,OperFlag,OpCutDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod CssQryOpInfoDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryOpInfoDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryOpInfoDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryOpInfoDtlExecute ]
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
/// CreatDate：   2019-11-20
/// Description:  横断面手术信息
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       横断面手术信息
/// w ##class(DHCHAI.STATV2.S440CssOpInfo).GetOpInfo("6","122")
ClassMethod GetOpInfo(aSurNumID As %String, aEpisodeID As %String) As %String
{
	New (aSurNumID,aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="")||(aSurNumID="") return
	
	Set xCSSID=0
	For {
		Set xCSSID=$o(^DHCHAI.IR.INFCSSI("IndexSurEpisodeID"," "_aSurNumID,aEpisodeID,xCSSID))
		Quit:xCSSID=""
		
		// Add by zhaoyj 2022-06-17 Global方式
		Set CSSData=$g(^DHCHAI.IR.INFCSSD(xCSSID))
		Continue:CSSData=""
		Continue:$lg(CSSData,5)'=1
		
		Set arrReport=##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("DHCHAI.IR.INFCSS",xCSSID)
		Set RepFlag =0   //报告状态位判断
		Set ReportID ="" //最后一份报告ID
		For indRep=1:1:arrReport.Count() {
			Quit:RepFlag=1
			Set RepData=arrReport.GetAt(indRep)
			Continue:RepData=""
			Set ReportID=$lg(RepData,20)
			Set IRStatusDr=$lg(RepData,8)
			Continue:IRStatusDr=""
			Set RepStatus=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
			//1保存、2提交、3审核、4作废、5退回、6取消审核
			Continue:(RepStatus="4")
			Set RepFlag=1			
		}
		Continue:RepFlag=0
		Set (OperCut)=""
		Set IROperFlag    = +$lg(CSSData,15)      //是否手术
		Set IROperCuteTypeDr     = $lg(CSSData,16)
		Set:IROperCuteTypeDr'="" OperCut=$lg($g(^DHCHAI.BT.DictionaryD(IROperCuteTypeDr)),3)
		Set return = ReportID_"!!"_IROperFlag_"!!"_OperCut
	}
	Quit return
}

}
