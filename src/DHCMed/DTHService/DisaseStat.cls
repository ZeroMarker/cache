/// Creator: chenrui
/// CreateDate: 2023-04-12
/// Description： 死亡报告分布统计服务类
Class DHCMed.DTHService.DisaseStat Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		chenrui
/// CreateDate:		2023-04-12
/// Description:  	死亡报告分布统计服务类（按年龄统计）
/// Table：       	
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
/// Return：      	返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.DTHService.DisaseStat","QryDisMapAge","2","1","2019-01-01","2023-04-12","")
Query QryDisMapAge(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepStatus As %String) As %Query(ROWSPEC = "AgeDecs:%String,RepNum:%String") [ SqlProc ]
{
}

ClassMethod QryDisMapAgeExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Quit:(DateFrom>DateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    Set:aRepStatus'="" aRepStatus=","_aRepStatus_","
    
    Set:aDateType="" aDateType = 1 // 默认为报告日期
    
	Set NIndex="QryDisMapAge"
	k ^TMP($zn,$j,NIndex)
	// 报告日期
	if (aDateType=1){
		For xRepDate=DateFrom:1:DateTo {
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.DTHi("REP","IndexDate",xRepDate,xReportID))
				Quit:xReportID=""
				Set objRep=##class(DHCMed.DTH.Report).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.RepStatusDR)
				Set RepStatus=objRep.RepStatusDR.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[(","_RepStatus_","))
				
				Set PatAge = objRep.Age
				Set AgeFlag = ..GetAgeNumber(PatAge)
				if (AgeFlag=1){
					Set AgeDesc = "0-10岁"
				}elseif (AgeFlag=2){
					Set AgeDesc = "10-20岁"
				}elseif (AgeFlag=3){
					Set AgeDesc = "20-30岁"
				}elseif (AgeFlag=4){
					Set AgeDesc = "30-40岁"
				}elseif (AgeFlag=5){
					Set AgeDesc = "40-50岁"
				}elseif (AgeFlag=6){
					Set AgeDesc = "50-60岁"
				}elseif (AgeFlag=7){
					Set AgeDesc = "60-70岁"
				}elseif (AgeFlag=8){
					Set AgeDesc = "70-80岁"
				}elseif (AgeFlag=9){
					Set AgeDesc = "80-90岁"
				}elseif (AgeFlag=10){
					Set AgeDesc = "90-100岁"
				}else{
					Set AgeDesc = "大于100岁"
				}
				Set ^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID",xReportID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID"))
				Set ^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID")=Num+1
			}
		}
	}else{
		// 死亡日期
		For xDecDate=DateFrom:1:DateTo {
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.DTHi("REP","IndexDeathDate",xDecDate,xReportID))
				Quit:xReportID=""
				Set objRep=##class(DHCMed.DTH.Report).GetObjById(xReportID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.RepStatusDR)
				Set RepStatus=objRep.RepStatusDR.%Id()
				Continue:(aRepStatus'="")&&(aRepStatus'[(","_RepStatus_","))
				
				Set PatAge = objRep.Age
				Set AgeFlag = ..GetAgeNumber(PatAge)
				if (AgeFlag=1){
					Set AgeDesc = "0-10岁"
				}elseif (AgeFlag=2){
					Set AgeDesc = "10-20岁"
				}elseif (AgeFlag=3){
					Set AgeDesc = "20-30岁"
				}elseif (AgeFlag=4){
					Set AgeDesc = "30-40岁"
				}elseif (AgeFlag=5){
					Set AgeDesc = "40-50岁"
				}elseif (AgeFlag=6){
					Set AgeDesc = "50-60岁"
				}elseif (AgeFlag=7){
					Set AgeDesc = "60-70岁"
				}elseif (AgeFlag=8){
					Set AgeDesc = "70-80岁"
				}elseif (AgeFlag=9){
					Set AgeDesc = "80-90岁"
				}elseif (AgeFlag=10){
					Set AgeDesc = "90-100岁"
				}else{
					Set AgeDesc = "大于100岁"
				}
				Set ^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID",xReportID)=""
				Set Num=+$g(^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID"))
				Set ^TMP($zn,$j,NIndex,AgeDesc,"DTHReportID")=Num+1
			}
		}
	}
	Set xAgeDecs=""
	For{
		Set xAgeDecs=$o(^TMP($zn,$j,NIndex,xAgeDecs))
		Quit:xAgeDecs=""
		Set RepNum=+$g(^TMP($zn,$j,NIndex,xAgeDecs,"DTHReportID"))
		Set Data=$lb(xAgeDecs,RepNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDisMapAgeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisMapAgeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDisMapAgeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisMapAgeExecute ]
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

/// Creator:    chenrui
/// CreateDate: 2023-04-12
/// Description:获取年龄信息
/// Input:      instr:字符串
///             separate:分割符
/// Output:     更改打印原因
/// w ##Class(DHCMed.DTHService.DisaseStat).GetAgeNumber("12天")
ClassMethod GetAgeNumber(aAge As %String) As %String
{
	new (aAge)
	Set rerturn = 0
	Quit:aAge="" rerturn
	if (aAge'["岁"){
		Set rerturn = 1		// 0-10岁
		Quit rerturn
	}
	Set AgeInfo = $p(aAge,"岁",1)
	if (AgeInfo<=10){
		Set rerturn = 1		// 0-10岁
	}elseif (AgeInfo<=20){
		Set rerturn = 2		// 10-20岁
	}elseif (AgeInfo<=30){
		Set rerturn = 3		// 20-30岁
	}elseif (AgeInfo<=40){
		Set rerturn = 4		// 30-40岁
	}elseif (AgeInfo<=50){
		Set rerturn = 5		// 40-50岁
	}elseif (AgeInfo<=60){
		Set rerturn = 6		// 50-60岁
	}elseif (AgeInfo<=70){
		Set rerturn = 7		// 60-70岁
	}elseif (AgeInfo<=80){
		Set rerturn = 8		// 70-80岁
	}elseif (AgeInfo<=90){
		Set rerturn = 9		// 80-90岁
	}elseif (AgeInfo<=100){
		Set rerturn = 10	// 90-100岁
	}else{
		Set rerturn = 11	// 100-110岁
	}
	
	
	Quit rerturn
}

// Creator:		chenrui

/// CreateDate:		2023-04-12
/// Description:  	死亡报告分布统计服务类（按年龄统计）
/// Table：       	
/// Input:        	aHospIDs： 多个医院用"|"连接
/// 			  	aDateFrom：开始日期
/// 			  	aDateTo：  结束日期
/// Return：      	返回ROWSPEC
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.DTHService.DisaseStat","QryDisMapReason","2","2019-01-01","2023-04-12")
Query QryDisMapReason(aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "Reason:%String,RepNum:%String") [ SqlProc ]
{
}

ClassMethod QryDisMapReasonExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Quit:(DateFrom>DateTo) $$$OK
 	
    Set:aHospIDs'="" aHospIDs=","_aHospIDs_","
    
	Set NIndex="QryDisMapReason"
	k ^TMP($zn,$j,NIndex)
	
	For xRepDate=DateFrom:1:DateTo {
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.DTHi("REP","IndexDate",xRepDate,xReportID))
			Quit:xReportID=""
			Set objRep=##class(DHCMed.DTH.Report).GetObjById(xReportID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.RepStatusDR)
			Set RepStatus=objRep.RepStatusDR.Description
			Continue:(RepStatus["删除")||(RepStatus["作废")||(RepStatus["草稿")
			Set Reason = objRep.AReason
			Continue:Reason=""
			Set ^TMP($zn,$j,NIndex,Reason,"DTHReportID",xReportID)=""
			Set Num=+$g(^TMP($zn,$j,NIndex,Reason,"DTHReportID"))
			Set ^TMP($zn,$j,NIndex,Reason,"DTHReportID")=Num+1
		}
	}
	Set xReason=""
	For{
		Set xReason=$o(^TMP($zn,$j,NIndex,xReason))
		Quit:xReason=""
		Set RepNum=+$g(^TMP($zn,$j,NIndex,xReason,"DTHReportID"))
		Set Data=$lb(xReason,RepNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDisMapReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisMapReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDisMapReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisMapReasonExecute ]
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

/// 根据字典描述与代码，找到ID
/// w ##class(DHCMed.DTHService.DisaseStat).GetIDByDesc("编码,审核","DTHRunningState")
ClassMethod GetIDByDesc(aDesc As %String, aCode As %String) As %String
{
	new (aDesc,aCode)
	Quit:aDesc="" 0
	Quit:aCode="" -2
	set return=""
	Set Length = $l(aDesc,",")
	For i=1:1:Length{
		Set Desc = $p(aDesc,",",i)
		Set obj = ##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc(aCode,Desc)
		Set RowID = obj.%Id()
		Set return = return_","_RowID
	}
	
	Set return = $p(return,",",2,Length+1)
	
	
	Quit return
}

}
