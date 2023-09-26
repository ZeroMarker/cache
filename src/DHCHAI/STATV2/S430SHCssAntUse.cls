/// 名称: DHCHAI.STATV2.S430SHCssAntUse
/// 描述: 实时现患抗菌药物使用情况汇总表
/// 编写者：zhoubo
/// 编写日期: 2019-12-26
Class DHCHAI.STATV2.S430SHCssAntUse Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-12-26
/// Description:  实时现患抗菌药物使用情况汇总表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aStaType ：科室/病区类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430SHCssAntUse","CssQryAntUse","","2018-01-01","2019-11-21","W")
Query CssQryAntUse(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,SurPatAdm:%String,AntiPatCnt:%String,AntiUseRatio:%String,AntiZLCount:%String,AntiYFCount:%String,AntiZLYFCount,AntiWZZCount:%String,AntiQTCount:%String,AntUseZLRatio:%String,AntUseYFRatio:%String,AntUseZLYFRatio:%String,AntiDALCount:%String,AntiERLCount:%String,AntiSALCount:%String,AntiSILCount:%String,AntiWULCount:%String") [ SqlProc ]
{
}

ClassMethod CssQryAntUseExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="CssQryAntUse"
	Kill ^TMP($zn,$j,NIndex)
    //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    if (+INFCSSHPFlag=0){
        //同期在科:某段时间的零点在科人数
        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|O")
    }else{
        //同期在科:某段时间的在科人数
        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|A2|O")
    }
	For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		
		//获取抗菌药物信息
		Set UseAntiFlag=""
		Set AntiDateFrom = $p(TransDates,",",1)
		Set AntiDateTo   = $p(TransDates,",",$l(TransDates,","))
		Set AntiInfoArr =..GetAntUseInfo(Paadm,AntiDateFrom,AntiDateTo)
		Set:(AntiInfoArr.Count()>0) UseAntiFlag=1
		
		//计算抗菌药物例次数
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			
			// 调查人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"SurPatAdm",Paadm)=""
			}
			//抗菌药物使用人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"AntiPat",Paadm)) {
				//记录抗菌药物使用人数
				Set:UseAntiFlag="1" num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntiPat"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"AntiPat",Paadm)=""
				Set CombCount=0
				For indexx1=1:1:AntiInfoArr.Count() {
					Set AntiInfo=AntiInfoArr.GetAt(indexx1)
					Continue:AntiInfo=""
					
					Set UsePurpose = $LIST(AntiInfo,11)
					Set:UsePurpose="治疗" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiZLCount"))
					Set:UsePurpose="预防" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiYFCount"))
					Set:UsePurpose="治疗+预防" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiZLYFCount"))
					Set:UsePurpose="无指征" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiWZZCount"))
					Set:UsePurpose="其他" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiQTCount"))
					Set CombCount =CombCount+1
				}
				If (CombCount>0){
                    Set:CombCount>4 CombCount=4
					Set:CombCount="1" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiDALCount"))
					Set:CombCount="2" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiERLCount"))
					Set:CombCount="3" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiSALCount"))
					Set:CombCount="4" num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiSILCount"))
					Set:(("1,2,3,4")'[CombCount) num = $i(^TMP($zn,$j,NIndex,DimensKey,"AntiWULCount"))
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
		Set xDimensKey	=$lg(DimList,1)
		Set DimensDesc	=$lg(DimList,3)
		Set IsActive	=$lg(DimList,4)
		Continue:xDimensKey=""
		Set SurPatAdm  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"SurPatAdm"))  //调查人数
		Set AntiPatCnt =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiPat"))    //抗菌药物使用人数
		Set AntiUseRatio="0.00%"   //抗菌药物使用率
		Set:SurPatAdm>0 AntiUseRatio=$fn((AntiPatCnt/SurPatAdm)*100,"",2)_"%"
		Set AntiZLCount   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiZLCount"))
		Set AntiYFCount   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiYFCount"))
		Set AntiZLYFCount =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiZLYFCount"))
		Set AntiWZZCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiWZZCount"))
		Set AntiQTCount   =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiQTCount"))
		
		Set (AntUseZLRatio,AntUseYFRatio,AntUseZLYFRatio)="0.00%"
		Set:SurPatAdm>0 AntUseZLRatio=$fn((AntiZLCount/SurPatAdm)*100,"",2)_"%" //治疗占比
		Set:SurPatAdm>0 AntUseYFRatio=$fn((AntiYFCount/SurPatAdm)*100,"",2)_"%" //预防占比
		Set:SurPatAdm>0 AntUseZLYFRatio=$fn((AntiZLYFCount/SurPatAdm)*100,"",2)_"%" //治疗+预防占比
		Set AntiDALCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiDALCount"))
		Set AntiERLCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiERLCount"))
		Set AntiSALCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiSALCount"))
		Set AntiSILCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiSILCount"))
		Set AntiWULCount  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"AntiWULCount"))
		
		Set Data=$lb(xDimensKey,DimensDesc,SurPatAdm,AntiPatCnt,AntiUseRatio,AntiZLCount,AntiYFCount,AntiZLYFCount,AntiWZZCount,AntiQTCount,AntUseZLRatio,AntUseYFRatio,AntUseZLYFRatio,AntiDALCount,AntiERLCount,AntiSALCount,AntiSILCount,AntiWULCount)
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

/// Creator：     zhoubo
/// CreatDate：   2019-12-26
/// Description:  抗菌药物使用情况病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDimensKey: 维度
///               aStaType : 1:统计抗菌药物患者信息
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430SHCssAntUse","CssQryAntUseDtl","2023-04-13","2023-04-13","0003-00-0000-H-2","W")
Query CssQryAntUseDtl(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String) As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,GroupDesc:%String,LocDesc:%String,WardDesc:%String,TransDate:%String,OutLocDate:%String,OrdID:%String,OrdItemID:%String,OrdDesc:%String,Generic:%String,Priority:%String,OrdDateTime:%String,SttDateTime:%String,OrdLocDesc:%String,OrdDocDesc:%String,EndDateTime:%String,UsePurpose:%String,Instruc:%String,DrgPoison:%String") [ SqlProc ]
{
}

ClassMethod CssQryAntUseDtlExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
 	
	Set DimensMark	= $p(aDimensKey,"-",4)
	Set aHospIDs	= +$p(aDimensKey,"-",1)
	Set:aHospIDs="0" aHospIDs=""
	Set aLocType	= $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
	Set aLocGroup	= $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
	Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
	
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set INFCSSHPFlag= ##class(DHCHAI.BT.Config).GetValByCode("INFCSSHPFlag")
    if (+INFCSSHPFlag=0){
        //同期在科:某段时间的零点在科人数
        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|O")
    }else{
        //同期在科:某段时间的在科人数
        Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I","A|A2|O")
    }
	For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		If TransType="E" {
			Set LocDr  = LocID
			Set WardDr = ""
			Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		} Else {
			Set LocDr  = LnkLocDr
			Set WardDr = LocID
			Set LocData = $g(^DHCHAI.BT.LocationD(WardDr))
		}
		Set HospDr=$li(LocData,8)
		Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1)	
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
		//按科室组、科室/病区过滤
		Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
		Continue:(aLocType'="")&&((LocDr'=aLocDr)&&(WardDr'=aLocDr))
		//获取抗菌药物信息
		Set UseAntiFlag=""
		Set TransDate = $p(TransDates,",",1)
		Set OutLocDate   = $p(TransDates,",",$l(TransDates,","))
		Set AntiInfoArr =..GetAntUseInfo(Paadm,TransDate,OutLocDate)
		Set:(AntiInfoArr.Count()>0) UseAntiFlag=1
		Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
		Set PatData =..BuildPaadmData(Paadm)
	    Continue:PatData=""
		If (aStaType=1){   // 统计使用抗菌药物使用人数信息
			For indexx1=1:1:AntiInfoArr.Count() {
				Set AntiInfo=AntiInfoArr.GetAt(indexx1)
				Continue:AntiInfo=""
				Set Data = PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDate,OutLocDate)_AntiInfo
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}Else {
	    	Set Data=PatData_$lb(GroupDesc,LocDesc,WardDesc,TransDate,OutLocDate,"","","","","","","","","","","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod CssQryAntUseDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CssQryAntUseDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CssQryAntUseDtlExecute ]
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
/// CreatDate：   2021-07-20
/// Description:  实时现患抗菌药物使用情况汇总表
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// 			  aStaType ：科室/病区类型
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430SHCssAntUse","QryAntUseTotal","","2020-12-12","2020-12-12","W")
Query QryAntUseTotal(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,UseAntiCnt:%String,CombSingle:%String,CombTwo:%String,CombThree:%String,CombFourAndMore:%String,AntCureCount:%String,AntPreCount:%String,AntCureRatio:%String,AntPreRatio:%String,CombSingleRatio:%String,CombTwoRatio:%String,CombThreeRatio:%String,CombFourAndMoreRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseTotalExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1", aStatDimens As %String = "", aLocIDs As %Text = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set:aStaType="" aStaType="E"
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
    Set listLocID=$listfromstring(aLocIDs,",")
	
    Set StatDimensStr = aStatDimens
    Set:StatDimensStr="" StatDimensStr=..GetStatDimensStr(aStaType)
    Quit:StatDimensStr="" $$$OK
    Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
    Set:StatType'="W" StatType="E"  //默认不是病区就是科室
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
	
    Set NIndex="QryAntUseTotal"
	Kill ^TMP($zn,$j,NIndex)
	
     //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,aStaType)         
    Set HospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""

        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
		Set HospDr=$li(LocData,8)
        Continue:(HospIDs'="")&&($listfind(HospIDs,HospDr)<1) 
		Set GroupDr  = $li(LocData,7)
		If GroupDr="" {
			Set GroupDesc="其他科"
			Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
		}
 
		//获取抗菌药物使用信息
		Set AntUseFlg=0,CureUseFlg=0,PreUseFlg=0
        Set AntUseArr =..GetAntCombInfo(Paadm,aDateFrom,aDateTo)   
        Set:AntUseArr.Count()>0 AntUseFlg=1
        for AntInd=1:1:AntUseArr.Count(){
            Set OrderInfo=AntUseArr.GetAt(AntInd)
            Set UsePurpose = $li(OrderInfo,11)
            //Set:UsePurpose="治疗+预防" UsePurpose="治疗"
            Set:UsePurpose["治疗" CureUseFlg=1
            Set:UsePurpose["预防" PreUseFlg=1
            //联合用药等级
            Set CombCount=$lg(OrderInfo,14)
        }
       
		//统计维度
        Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,LocDr)
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 实查人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)){
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//使用抗菌药物人数
			If (AntUseFlg=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)){
					Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))
					Set ^TMP($zn,$j,NIndex,DimensKey,"UseAnti",Paadm)=""
					
					Set:+CombCount>0 num=$i(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))		
				}
			}
			//治疗使用抗菌药物人数
			If (CureUseFlg=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti",Paadm)=""
					}
			}
			//预防使用抗菌药物人数
			If (PreUseFlg=1) {
				If '$d(^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti",Paadm))
					{
						Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti"))
						Set ^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti",Paadm)=""
					}
			}					
		}
	}
	do BuildData()
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
BuildData()
	// 输出Data
	//1.实查人数
    //2.使用抗菌药物人数
   	//3.联用情况
    //4.使用目的
	Set ArryStatDimens=..GetArrayStatDimens(StatDimensStr,aHospIDs,"","","","I")
	Set xDimensKey=""
	For DimIndx=1:1:ArryStatDimens.Count() {
		Set DimList=ArryStatDimens.GetAt(DimIndx)
		Set DimensKey	= $lg(DimList,1)
		Set DimensDesc	= $lg(DimList,3)
		Set IsActive	= $lg(DimList,4)
		Continue:DimensKey=""
		Continue:(aHospIDs'["|")&(DimensKey["A")		//非全院不显示"全院"
        Set LocDr = +$p(DimensKey,"-",3)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        
		Set PatAdmCnt  	=+$g(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))  			//实查人数
		Set UseAntiCnt  =+$g(^TMP($zn,$j,NIndex,DimensKey,"UseAnti"))  			//抗菌药物使用人数
		
		Set AntPreCount=0,AntCureCount=0
		Set AntCureCount=+$g(^TMP($zn,$j,NIndex,DimensKey,"CureUseAnti"))    //治疗用药人数
		Set AntPreCount=+$g(^TMP($zn,$j,NIndex,DimensKey,"PreUseAnti"))      //预防用药人数
		
		Set CombSingle=0,CombTwo=0,CombThree=0,CombFourAndMore=0
		Set CombCount=""
		for{
			Set CombCount=$o(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))
			Quit:CombCount=""
			
			Set:CombCount=1 CombSingle=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//一联人数
			Set:CombCount=2 CombTwo=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))		//二联人数
			Set:CombCount=3 CombThree=+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//三联人数
			Set:CombCount>=4 CombFourAndMore=CombFourAndMore+$g(^TMP($zn,$j,NIndex,DimensKey,"AntComb",CombCount))	//四联及以上人数
		}	
		
		Set (AntCureRatio,AntPreRatio)="0.00%"
		Set:UseAntiCnt>0 AntCureRatio=$fn((AntCureCount/UseAntiCnt)*100,"",2)_"%" //治疗占比
		Set:UseAntiCnt>0 AntPreRatio=$fn((AntPreCount/UseAntiCnt)*100,"",2)_"%" //预防占比
		
		Set (CombSingleRatio,CombTwoRatio,CombThreeRatio,CombFourAndMoreRatio)="0.00%"
		Set:UseAntiCnt>0 CombSingleRatio=$fn((CombSingle/UseAntiCnt)*100,"",2)_"%" //一联占比
		Set:UseAntiCnt>0 CombTwoRatio=$fn((CombTwo/UseAntiCnt)*100,"",2)_"%" //二联占比
		Set:UseAntiCnt>0 CombThreeRatio=$fn((CombThree/UseAntiCnt)*100,"",2)_"%" //三联占比
		Set:UseAntiCnt>0 CombFourAndMoreRatio=$fn((CombFourAndMore/UseAntiCnt)*100,"",2)_"%" //四联占比及以上
        if (LocCount>1){
            Set ^TMP($zn,$j,NIndex,"Sum","PatAdm")=PatAdmCnt   +$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))            //实查人数
            Set ^TMP($zn,$j,NIndex,"Sum","UseAnti")=UseAntiCnt  +$g(^TMP($zn,$j,NIndex,"Sum","UseAnti"))           //抗菌药物使用人数
            Set ^TMP($zn,$j,NIndex,"Sum","CureUseAnti")=AntCureCount+$g(^TMP($zn,$j,NIndex,"Sum","CureUseAnti"))    //治疗用药人数
            Set ^TMP($zn,$j,NIndex,"Sum","PreUseAnti")=AntPreCount+$g(^TMP($zn,$j,NIndex,"Sum","PreUseAnti"))      //预防用药人数
            Set ^TMP($zn,$j,NIndex,"Sum","CombSingle")=CombSingle+$g(^TMP($zn,$j,NIndex,"Sum","CombSingle"))  //一联人数
            Set ^TMP($zn,$j,NIndex,"Sum","CombTwo")=CombTwo+$g(^TMP($zn,$j,NIndex,"Sum","CombTwo"))     //二联人数
            Set ^TMP($zn,$j,NIndex,"Sum","CombThree")=CombThree+$g(^TMP($zn,$j,NIndex,"Sum","CombThree"))    //三联人数
            Set ^TMP($zn,$j,NIndex,"Sum","CombFourAndMore")=CombFourAndMore+$g(^TMP($zn,$j,NIndex,"Sum","CombFourAndMore"))  //四联及以上人数
        }
        Continue:(IsActive="0")&&(PatAdmCnt=0)
        Continue:(aQryCon="2")&&(UseAntiCnt=0)
        Continue:(aQryCon="3")&&(PatAdmCnt=0)  
        Set Data=$lb(DimensKey,DimensDesc,PatAdmCnt,UseAntiCnt,CombSingle,CombTwo,CombThree,CombFourAndMore,AntCureCount,AntPreCount,AntCureRatio,AntPreRatio,CombSingleRatio,CombTwoRatio,CombThreeRatio,CombFourAndMoreRatio)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
       
    }
    if (LocCount>1){
        Set PatAdmCnt =  +$g(^TMP($zn,$j,NIndex,"Sum","PatAdm"))            //实查人数
        Set UseAntiCnt = +$g(^TMP($zn,$j,NIndex,"Sum","UseAnti"))           //抗菌药物使用人数
        Set AntCureCount=+$g(^TMP($zn,$j,NIndex,"Sum","CureUseAnti"))    //治疗用药人数
        Set AntPreCount=+$g(^TMP($zn,$j,NIndex,"Sum","PreUseAnti"))      //预防用药人数
        Set CombSingle=+$g(^TMP($zn,$j,NIndex,"Sum","CombSingle"))   //一联人数
        Set CombTwo=+$g(^TMP($zn,$j,NIndex,"Sum","CombTwo"))      //二联人数
        Set CombThree=+$g(^TMP($zn,$j,NIndex,"Sum","CombThree"))    //三联人数
        Set CombFourAndMore=+$g(^TMP($zn,$j,NIndex,"Sum","CombFourAndMore"))  //四联及以上人数
        Set (AntCureRatio,AntPreRatio)="0.00%"
        Set:UseAntiCnt>0 AntCureRatio=$fn((AntCureCount/UseAntiCnt)*100,"",2)_"%" //治疗占比
        Set:UseAntiCnt>0 AntPreRatio=$fn((AntPreCount/UseAntiCnt)*100,"",2)_"%" //预防占比
        
        Set (CombSingleRatio,CombTwoRatio,CombThreeRatio,CombFourAndMoreRatio)="0.00%"
        Set:UseAntiCnt>0 CombSingleRatio=$fn((CombSingle/UseAntiCnt)*100,"",2)_"%" //一联占比
        Set:UseAntiCnt>0 CombTwoRatio=$fn((CombTwo/UseAntiCnt)*100,"",2)_"%" //二联占比
        Set:UseAntiCnt>0 CombThreeRatio=$fn((CombThree/UseAntiCnt)*100,"",2)_"%" //三联占比
        Set:UseAntiCnt>0 CombFourAndMoreRatio=$fn((CombFourAndMore/UseAntiCnt)*100,"",2)_"%" //四联占比及以上
        Set Data=$lb("","全部",PatAdmCnt,UseAntiCnt,CombSingle,CombTwo,CombThree,CombFourAndMore,AntCureCount,AntPreCount,AntCureRatio,AntPreRatio,CombSingleRatio,CombTwoRatio,CombThreeRatio,CombFourAndMoreRatio)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
}

ClassMethod QryAntUseTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseTotalExecute ]
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
/// CreatDate：   2021-07-20
/// Description:  抗菌药物使用情况病人明细
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aDimensKey: 维度
///               aStaType : E/W
///          	  aQryType : 实查人数"1"/抗菌用药人数""(默认抗菌用药人数)
/// 			  aPurpose : 治疗Cure 预防Pre    使用简写英文以避免中文乱码 
/// 			  aComMed  : 1 2 3 4(四联以上)
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S430SHCssAntUse","QryAntUseTotalDetail","2022-12-15","2022-12-15","0000-07-0000-G-1","W","","","","")
Query QryAntUseTotalDetail(aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aQryType As %String = "", aPurpose As %String = "", aComMed As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DischLocDesc:%String,DischWardDesc:%String,CombCount:%String,AntiMapDesc:%String,UsePurpose:%String,UseSttDate:%String,UseEndDate:%String,UseOrdLocDesc:%String,OrdID:%String,OrdDate:%String,DrgPoison:%String,Instruc:%String,OrdDocDesc:%String,CarPrvTpDesc:%String,Priority:%String,HCSSFlag:%String") [ SqlProc ]
{
}

ClassMethod QryAntUseTotalDetailExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aDimensKey As %String, aStaType As %String, aQryType As %String = "", aPurpose As %String = "", aComMed As %String = "", aLocIDs As %Text = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    
    Set DimensMark  = $p(aDimensKey,"-",4)
    Set aHospIDs    = +$p(aDimensKey,"-",1)
    Set:aHospIDs="0" aHospIDs=""
    Set aLocType    = $Case(DimensMark,"E":DimensMark,"W":DimensMark,:"")
    Set aLocGroup   = $Case(DimensMark,"G":+$p(aDimensKey,"-",2),:"")
    Set aLocDr=""
    Set:aLocType'="" aLocDr=+$p(aDimensKey,"-",3)
    Set:aLocDr=0 aLocDr=""
    Set HospGrpDr=""
    Set:DimensMark="A" HospGrpDr=$p(aDimensKey,"-",5)
    
    Set StatType=aStaType
    Set:StatType="" StatType=aLocType
    Set:StatType'="W" StatType="E"  //不是病区就是科室
    Set:aLocType="" StatType=aStaType
    Set NIndex="QryAntUseTotalDetail"
    kill ^TMP($zn,$j,NIndex)
         //同期在科:某段时间的在科人数
    Set LocEpisArray=##class(DHCHAI.IRS.UtilHCSSSrv).GetLocEpisByBed(aHospIDs,aDateFrom,aDateTo,StatType)         
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    For index1=1:1:LocEpisArray.Count() {
        Set TransInfo=LocEpisArray.GetAt(index1)   
        Continue:TransInfo=""

        Set LocDr   = $LIST(TransInfo,1)
        Set Paadm  = $LIST(TransInfo,2)
        Continue:(aLocDr'="")&(aLocDr'=LocDr)
        Continue:(aLocIDs'="")&((","_aLocIDs_",")'[(","_LocDr_","))
        Set LocData = $g(^DHCHAI.BT.LocationD(LocDr))
        Set LocDesc = $li(LocData,3)
        Set HospDr=$li(LocData,8)
        Continue:(aHospIDs'="")&&($listfind(aHospIDs,HospDr)<1) 
        Set HospInfo=$g(^DHCHAI.BT.HospitalD(HospDr))
        Set HospDesc=$lg(HospInfo,3)
        Set HospGroupDr=$lg(HospInfo,5)
        Continue:(HospGrpDr'="")&&(HospGroupDr'=HospGrpDr)
        Set HospGrpInfo=$g(^DHCHAI.BT.HospGroupD(+HospGroupDr)) 
        Set HospGrpDesc=$lg(HospGrpInfo,3)   
        Set:HospGrpDesc="" HospGrpDesc="全院" 
        Set GroupDr  = $li(LocData,7)
        If GroupDr="" {
            Set GroupDesc="其他科"
            Set GroupDr=$o(^DHCHAI.BT.LocGroupI("IdxofDesc","其他科",0))
        }
        Continue:(aLocGroup'="")&(aLocGroup'=GroupDr)
        Set GroupData=$g(^DHCHAI.BT.LocGroupD(GroupDr))
        Set GroupDesc=$li(GroupData,3)
        Set PatData =..BuildPaadmData(Paadm)
         //取统计维度
        Set DimensDesc =""
        Set:DimensMark="" DimensDesc="全部"
        Set:DimensMark="A" DimensDesc=HospGrpDesc
        Set:DimensMark="H" DimensDesc=HospDesc          //医院名称
        Set:DimensMark="G" DimensDesc=GroupDesc             //分组名称
        Set:(DimensMark="E")||(DimensMark="W") DimensDesc=LocDesc  //科室、病区名称
        Set AdmTimes = $lg($g(^DHCHAI.DP.PAAdmD(Paadm)),38)   //就诊次数
        Continue:PatData=""
        Set InfData = ##class(DHCHAI.IRS.INFCSSSHSrv).GetInfData(Paadm,aDateFrom,aDateTo) 
        Set HCSSFlag="否" 
        if (InfData'=""){
             Set HCSSFlag="是"
        }
        if (aQryType="1"){
            Set Data = $lb(DimensDesc,AdmTimes)_PatData_$lb("","","","","","","","","","","","","",HCSSFlag)
            Set ^CacheTemp(repid,ind)=Data 
            Set ind=ind+1
        } else {
            
            //获取抗菌药物使用信息
            Set AntUseFlg=0
            Set AntUseArr =..GetAntCombInfo(Paadm,aDateFrom,aDateTo)   //"00:00:01","00:00:01"
            
            Set:AntUseArr.Count()>0 AntUseFlg=1
            
            for AntInd=1:1:AntUseArr.Count(){
                Set OrderInfo=AntUseArr.GetAt(AntInd)
                Set AntiMapDesc=$li(OrderInfo,4)     //标准名称
                Set UsePurpose =$lg(OrderInfo,11)
                Set OrdDate = $li(OrderInfo,6)
                Set UseSttDate=$li(OrderInfo,7)      //开始时间
                Set UseEndDate=$li(OrderInfo,10)     //结束时间
                Set:OrdDate'="" OrdDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+OrdDate)_" "_$zt(+$p(OrdDate," ",2))
                Set UseSttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+UseSttDate)_" "_$zt(+$p(UseSttDate," ",2))
                Set:UseEndDate'="" UseEndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+UseEndDate)_" "_$zt(+$p(UseEndDate," ",2))
                Set UseOrdLocDesc=$li(OrderInfo,8)   //开医嘱科室
                Continue:(aPurpose="Cure")&&(UsePurpose'["治疗")  
                Continue:(aPurpose="Pre")&&(UsePurpose'["预防") 
                
                Set OrdID=$li(OrderInfo,1)    
                Set DrgPoison  = $li(OrderInfo,13)
                Set:DrgPoison="KSS1" DrgPoison="非限制使用级"
                Set:DrgPoison="KSS2" DrgPoison="限制使用级"
                Set:DrgPoison="KSS3" DrgPoison="特殊使用级" 
                
                Set Instruc=$li(OrderInfo,12)  
                Set Priority=$li(OrderInfo,5)  
                Set OrdLocDesc=$li(OrderInfo,8) 
                Set OrdItemData=$g(^DHCHAI.DP.OEOrdItemD(OrdID))
                Set OrdDocDesc =$lg(OrdItemData,14)  
                Set OEDocDr=""
                Set:$p(OrdDocDesc,"|",1)'="" OEDocDr=$p(OrdDocDesc,"|",1)
                Set CarPrvTpId="",CarPrvTpDesc=""
                Set:OEDocDr'="" CarPrvTpId=$p($g(^CTPCP(OEDocDr,1)),"^",4)  //CTCarPrvTp
                Set:CarPrvTpId'="" CarPrvTpDesc=$p(^CT("CPT",CarPrvTpId),"^",2)  
                Set CombCount=$lg(OrderInfo,14)
                Continue:(aComMed'="")&&(aComMed'=CombCount)
                Set:+CombCount=1 CombCount="一联"
                Set:+CombCount=2 CombCount="二联"
                Set:+CombCount=3 CombCount="三联"
                Set:+CombCount>=4 CombCount="四联及以上"
                Set:CombCount=0 CombCount=""  
                
                Set Data = $lb(DimensDesc,AdmTimes)_PatData_$lb(CombCount,AntiMapDesc,UsePurpose,UseSttDate,UseEndDate,UseOrdLocDesc,OrdID,OrdDate,DrgPoison,Instruc,OrdDocDesc,CarPrvTpDesc,Priority,HCSSFlag)
                Set ^CacheTemp(repid,ind)=Data 
                Set ind=ind+1
            }
        }
       
	}
	
	kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryAntUseTotalDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntUseTotalDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntUseTotalDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntUseTotalDetailExecute ]
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
/// CreatDate：   2021-07-20
/// Description:  返回患者就诊号+联用情况+抗菌用药信息...
/// 参照-##class(DHCHAI.STATV2.S132AntComb).GetAntComb("2",$zdh("2020-01-01",3),$zdh("2021-04-28",3))
/// ps.如果有抗菌药物信息，但联用为0，说明该抗菌药物没有标准对照
/// w ##class(DHCHAI.STATV2.S430SHCssAntUse).GetAntInfo("2",$zdh("2020-07-15",3),$zdh("2021-07-15",3))
ClassMethod GetAntInfo(aEpisodeID, aDateFrom, aDateTo)
{
	new (aEpisodeID,aDateFrom,aDateTo)     
	
	Set MIndex="GetAntInfo"
	Kill ^TMP($zn,$j,MIndex)
	Set xScode = "",Num=1
	
	For {
		Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
		Quit:xScode=""
		
		Set xSttDate = ""
		For {
			Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
			Quit:xSttDate=""
			Continue:(xSttDate>aDateTo)
			
			Set xOrdItemID =""
			For {
				Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
				Quit:xOrdItemID=""
		
				Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
				Continue:$li(OEOrdItemData,25)=0	
	           
	            Set SttDate = $li(OEOrdItemData,15)	
				Set EndDate = $li(OEOrdItemData,17)
				Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
				Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
				Continue:PriorityMap=""
				Continue:PriorityMap="OUT"   //add 20211217 过滤出院带药医嘱
				
	            If PriorityMap="N"{
					Set EndDate = SttDate
				}else{
					If EndDate=""{		// 长期医嘱未停止只计算到传入结束日期
						Set EndDate = aDateTo
					}
				}
				Continue:EndDate<aDateFrom  // 停药日期在转入日期前
                Continue:SttDate>=aDateTo   // 用药日期在转出日期后,当天新开的药也不算
				
                Set Instruc = $li(OEOrdItemData,20) //给药途径
   				Set InstrucMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiAdminRoute",Instruc)		
				Continue:InstrucMapStr=""
				Set InstrucMap = $p(InstrucMapStr,"^",3)
				Set InstrucList=##class(DHCHAI.BT.Config).GetValByCode("StatInstrucList")
                Set InstrucList=","_InstrucList_","
				Continue:(InstrucList'="")&&(InstrucList'[(","_InstrucMap_","))
				
				//记录抗菌药物使用
				Set AntiDesc = $li(OEOrdItemData,4)
				
				Set AntiMapDr=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xScode,AntiDesc)
				Continue:'$ISObject(AntiMapDr)
				If $ISObject(AntiMapDr)&&$ISObject(AntiMapDr.BTMapItemDr){
					Set AntiMapDesc=AntiMapDr.BTMapItemDr.BTName    //如果有标准对照取标准对照名称，纳入联用统计
					for xDate=SttDate:1:EndDate{
						Set ^TMP($zn,$j,MIndex,"AntComb",xDate,AntiMapDesc)=""   
					}
				}else{
					Set AntiMapDesc=AntiDesc
				}
				
				Set:SttDate'="" SttDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(SttDate)
				Set:EndDate'="" EndDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(EndDate)
				Set UsePurpose = $li(OEOrdItemData,30) //用药目的
				Set:UsePurpose="" UsePurpose="其他"
				Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(xScode,"AntiMedPurpose",UsePurpose)
				Set UsePurpose = $p(UsePurposeMapStr,"^",3)   
				Set DrgPoison = $li(OEOrdItemData,29) //抗菌用药等级
				
				Set OEOrdLocDr=$li(OEOrdItemData,12)
				Set OEOrdLocData=$g(^DHCHAI.BT.LocationD(OEOrdLocDr))
				If OEOrdLocData'="" {
					Set OrdLocDesc=$li(OEOrdLocData,3)
				} Else {
					Set OrdLocDesc=$li(OEOrdItemData,39)  //ID|Code|Desc
					Set:$p(OrdLocDesc,"|",3)'="" OrdLocDesc=$p(OrdLocDesc,"|",3)
				}
				//名称1+目的2+开始时间3+结束时间4+开医嘱科室5
				Set ^TMP($zn,$j,MIndex,aEpisodeID,Num)=AntiMapDesc_"^"_UsePurpose_"^"_SttDate_"^"_EndDate_"^"_OrdLocDesc
				Set Num=Num+1
			}
		}
	}
	//最大抗菌药物联用和日期
	Set CombCount=0
	Set xDate="",maxDate=""
	for{
		Set xDate=$o(^TMP($zn,$j,MIndex,"AntComb",xDate))
		Quit:xDate=""
		Continue:(xDate<aDateFrom)||(xDate>aDateTo)
		
		Set Count=0,xAntiDesc=""
		for{
			Set xAntiDesc=$o(^TMP($zn,$j,MIndex,"AntComb",xDate,xAntiDesc))	
			Quit:xAntiDesc=""
			
			Set Count=Count+1
		}
		Set:Count>CombCount CombCount=Count,maxDate=xDate
	}
	Set Num=0
	Set xNum="",return=aEpisodeID_$C(1)_CombCount 
	for{
		Set xNum=$o(^TMP($zn,$j,MIndex,aEpisodeID,xNum))
		Quit:xNum=""
		Set return=return_$C(1)_$g(^TMP($zn,$j,MIndex,aEpisodeID,xNum))
	}

	kill ^TMP($zn,$j,MIndex)
	
	Quit return
}

}
