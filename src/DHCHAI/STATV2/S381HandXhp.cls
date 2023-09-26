/// 名称: DHCHAI.STATV2.S381HandXhp
/// 描述: 住院患者手卫生消耗品统计表
/// 编写者：chenjb
/// 编写日期: 2022-03-15
Class DHCHAI.STATV2.S381HandXhp Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-10-15
/// Description:  住院患者手卫生消耗品统计表
/// Table：       DHCHAI.DP.PAAdm
/// Input:        aHospIDs： 多个医院用"|"连接
/// 			  aDateFrom：开始日期
/// 			  aDateTo：  结束日期 
///               aStaType:  统计类型E：科室W：病区 
/// 		 	  aQryCon:	 是否仅显示有数据的科室
/// Return：      返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.S381HandXhp","QrySDayInf","1|2","2022-03-01","2022-03-31","W",1)
Query QrySDayInf(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Query(ROWSPEC = "DimensKey:%String,DimensDesc:%String,PatAdmCnt:%String,InDaysCnt:%String,XhpDesc:%String,XhpGg:%String,XhpCnt:%String,XhpAvg:%String") [ SqlProc ]
{
}

ClassMethod QrySDayInfExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aStaType As %String, aQryCon As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aDateFrom>aDateTo) $$$OK
	Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    
    Set NIndex="QrySDayInf"
	Kill ^TMP($zn,$j,NIndex)
    //新增加维度
    Set StatDimensStr=..GetStatDimensStr(aStaType)
	Quit:StatDimensStr="" $$$OK
	Set StatType=$e(StatDimensStr,$l(StatDimensStr),$l(StatDimensStr))
	Set:StatType'="W" StatType="E"  //不是病区就是科室
	
    //同期在科/病区:某段时间的在科人数
    //Set ListLocArray=..GetTransEpisByLocDate(aDateFrom,aDateTo,StatType,"","I")
    Set ListLocArray=..GetLocEpisByDate(aDateFrom,aDateTo,StatType,"","I")
    For index1=1:1:ListLocArray.Count() {
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Paadm      = $LIST(TransInfo,1)
		Set LocID      = $LIST(TransInfo,2)
		Set TransType  = $LIST(TransInfo,3)
		Set TransDates = $LIST(TransInfo,4)
		Set LnkLocDr   = $LIST(TransInfo,5)
		Set TransIDs   = $LIST(TransInfo,6)
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
		//统计维度
		Set StatDimensInfo=..GetStatDimensInfo(StatDimensStr,HospDr,GroupDr,LocDr,WardDr)
		Continue:StatDimensInfo=""
		For indDimens=1:1:$l(StatDimensInfo,"^") {
			Set DimensKey=$p(StatDimensInfo,"^",indDimens)
			Continue:DimensKey=""
			// 全院住院患者人数
			If '$d(^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm))
			{
				Set num=$i(^TMP($zn,$j,NIndex,DimensKey,"PatAdm"))
				Set ^TMP($zn,$j,NIndex,DimensKey,"PatAdm",Paadm)=""
			}
			//同期在科天数
			//Set:TransDates'="" ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+$l(TransDates,",") 
			Set InDaysT = ..GetInDays(Paadm,aDateFrom,aDateTo,TransIDs)
			Set ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+InDaysT 
			//Set ^TMP($zn,$j,NIndex,DimensKey,"InDays") = +$g(^TMP($zn,$j,NIndex,DimensKey,"InDays"))+$l(TransDates,",") 
					
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
		
		Set PatAdmCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"PatAdm"))  //住院患者人数
		Set InDaysCnt  =+$g(^TMP($zn,$j,NIndex,xDimensKey,"InDays"))  //患者住院天数
		
		Continue:((IsActive'=1)||(DimensDesc["停用")||(DimensDesc["作废"))&&(PatAdmCnt=0)
		//Continue:(aQryCon=2)&&(InDaysCnt=0)	//有住院天数	
		//根据科室病区查询手卫生消耗品数据lb返回
		Set ListXhpArray=..GetLocXhpByDate(aDateFrom,aDateTo,xDimensKey,StatType)
		if ListXhpArray.Count()>0 {
			For indexX=1:1:ListXhpArray.Count() {
				Set (XhpDesc,XhpGg,XhpCnt,XhpAvg)=""
				Set XhpInfo=ListXhpArray.GetAt(indexX)	
				Continue:XhpInfo=""
				Set XhpDesc      = $LIST(XhpInfo,1)
				Set XhpGg      = $LIST(XhpInfo,2)
				Set XhpCnt =$LIST(XhpInfo,3)
				Set:InDaysCnt>0 XhpAvg = $fn((XhpCnt/InDaysCnt),"",2)
				Set:XhpAvg="" XhpAvg = "0.00"
				Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InDaysCnt,XhpDesc,XhpGg,XhpCnt,XhpAvg)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				//记录历史
				Set ^TMP($zn,$j,NIndex,"xhpIdx",XhpDesc,XhpGg)=""
			}
		}
		/*
		else
		{
			//存在的手消用品赋值0，循环历史
			Set tmpXhpDesc=""
			For {
				Set tmpXhpDesc=$o(^TMP($zn,$j,NIndex,"xhpIdx",tmpXhpDesc))
	 			Quit:tmpXhpDesc=""
	 			Set tmpXhpGg = ""
	 			For {
		 			Set tmpXhpGg=$o(^TMP($zn,$j,NIndex,"xhpIdx",tmpXhpDesc,tmpXhpGg))
		 			Quit:tmpXhpGg=""
					Set XhpCnt =0
					Set:InDaysCnt>0 XhpAvg = $fn((XhpCnt/InDaysCnt),"",2)
					Set:XhpAvg="" XhpAvg = "0.00"
					Set Data=$lb(xDimensKey,DimensDesc,PatAdmCnt,InDaysCnt,tmpXhpDesc,tmpXhpGg,XhpCnt,XhpAvg)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
		 		}
			}
		}
		*/			
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QrySDayInfClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySDayInfExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySDayInfFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySDayInfExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2022-06-16
/// Description:  
/// Table：       
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List 
/// zw ##class(DHCHAI.STATV2.S381HandXhp).GetLocXhpByDate($zdh("2022-03-01",3),$zdh("2022-03-15",3),"0001-06-0000-G-3")
ClassMethod GetLocXhpByDate(aDateFrom As %String, aDateTo As %String, aLocID As %String, aStatType As %String = "", ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocID,aStatType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocID="") return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetLocXhpByDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetLocXhpByDateErr"
	Set xKeyHosp = +$p(aLocID,"-",1)
	Set xKeyGrp = +$p(aLocID,"-",2)
	Set xKeyLocW = +$p(aLocID,"-",3)
	Set xLoc=""
	For {
		Set xLoc=$o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc))
	 	Quit:xLoc=""
	 	Set LocData = $g(^DHCHAI.BT.LocationD(xLoc))
	 	Continue:LocData=""
	 	Set HospDr=$lg(LocData,8)
	 	Set GroupDr  = $lg(LocData,7)
	 	Set BTTypeDr = $lg(LocData,5)
	 	// Add by zhaoyj 2022-06-16 Global方式
	 	Set BTTypeData =$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
	 	Set BTTypeCode=$lg(BTTypeData,2)
	 	Continue:aStatType'=BTTypeCode
	 	//就诊类型增加只统计住院的
	 	Set BTCateDr = $lg(LocData,6)
	 	Set CateData =$g(^DHCHAI.BT.DictionaryD(BTCateDr))
	 	Set jzlxCode=$lg(CateData,2)
	 	Continue:jzlxCode'="I"
	 	Continue:(aLocID["H")&(xKeyHosp'=HospDr)
	 	Continue:(aLocID["G")&((xKeyHosp'=HospDr)||(xKeyGrp'=GroupDr))
	 	Continue:((aLocID["E")||(aLocID["W"))&((xKeyHosp'=HospDr)||(xKeyGrp'=GroupDr)||(xKeyLocW'=xLoc))
	 	
		For xDate=aDateFrom:1:aDateTo {
		 	Set xID=""
		 	For {
				Set xID=$o(^DHCHAI.IR.HandHyConsumsI("IndexLocDate",xLoc,xDate,xID))
			 	Quit:xID=""
			 	
			 	Set objInfo=$g(^DHCHAI.IR.HandHyConsumsD(xID))  //##class(DHCHAI.IR.HandHyConsums).GetObjById(xID)
			 	Continue:(objInfo="")
			 	
				//Set ObsDate = obj.HHCObsDate
				Set Consumption =$lg(objInfo,5)  // obj.HHCConsumption  //消耗量
				Set Recipient = $lg(objInfo,6) //obj.HHCRecipient
				
				Set IsActive  = +$lg(objInfo,10)
				Set HHCProduct =$lg(objInfo,4)  //手消耗用品
				Set HHCProductData = $g(^DHCHAI.IR.HandHyProductsD(HHCProduct))
				Continue:HHCProductData=""
				Set ProductDr   = HHCProduct
				Set ProductCode = $li(HHCProductData,2)
				Set ProductDesc = $li(HHCProductData,3)  //名称
				Set HHPSpec     = $li(HHCProductData,5)  //规格
				//add for 627983:手卫生用品消耗量-某科室只有一条手卫生消耗记录时，将对应的手卫生用品置为无效，该科室所有项目均为0，但仍统计
				Set ProIsActive     = $li(HHCProductData,8)
				Continue:ProIsActive=0
				Continue:IsActive=0		//bug:627961,能够统计到无效的手卫生用品消耗的记录
				//end
				Set (UnitDr,UnitCode,UnitDesc)=""
				Set HHPUnit=$li(HHCProductData,6)
				If (HHPUnit'="") {
					Set UnitDr   = HHPUnit
					Set UnitCode = $li($g(^DHCHAI.BT.DictionaryD(UnitDr)),2)
					Set UnitDesc = $li($g(^DHCHAI.BT.DictionaryD(UnitDr)),3)
				}
				Set ProSpec=HHPSpec_UnitDesc  //唯一
				//Set ConsuSum  = Consumption*HHPSpec
				Set ConsuSum = +Consumption
				Set ^TMP(ZIndex,JIndex,NIndex,ProductDesc,ProSpec)=(+$g(^TMP(ZIndex,JIndex,NIndex,ProductDesc,ProSpec)))+ConsuSum
			}
		}
	}
	Set xProductDesc=""
	Set Count=0
	For {
		Set xProductDesc=$o(^TMP(ZIndex,JIndex,NIndex,xProductDesc))
		Quit:xProductDesc=""	
		Set xProSpec=""
		For {
			Set xProSpec=$o(^TMP(ZIndex,JIndex,NIndex,xProductDesc,xProSpec))
			Quit:xProSpec=""
			Set Count=Count+1
			Set LocInfo=$lb(xProductDesc,xProSpec,+$g(^TMP(ZIndex,JIndex,NIndex,xProductDesc,xProSpec)))
			Do return.SetAt(LocInfo,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetLocXhpByDateErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

}
