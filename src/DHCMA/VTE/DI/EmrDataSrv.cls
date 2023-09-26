Class DHCMA.VTE.DI.EmrDataSrv Extends %RegisteredObject
{

/// Creator：     mazhaoyan
/// CreatDate：   2019-08-09
/// Description:  通过就诊号+术语集获取病历信息     
/// Input：       aEpisodeID:就诊号 
///               aGlossary:术语集标识符
/// Output        术语集对应该电子病历单元值
///               类型：数组 
///               格式：[{"实例ID","值"},{"实例ID","值"},...]
///               唯一模板为单值，可重复模板可能有多值
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.EmrDataSrv","QueryEmrRecord","88","2020-08-18","2020-08-18")
Query QueryEmrRecord(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "xInstanceID:%String,aEpisodeID:%String,value:%String,glossaryCode:%String,Title:%String,glossaryTitle:%String,glossarySubTitle:%String,HappenDate:%String,HappenTime:%String,ModifyDate:%String,ModifyTime:%String,ModifyUserCode:%String,ModifyUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryEmrRecordExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set $ZT="AutoTaskErr"
	Set item = ""
	For{
		Set item = $o(^DHCVTE.EMRItemPara(item))	
		Quit:item=""
		Set tEmrCodeStr = $g(^DHCVTE.EMRItemPara(item))
		Continue:tEmrCodeStr=""
		Set DocType=$p(tEmrCodeStr,":",1)
		Set EmrCodes=$p(tEmrCodeStr,":",2)
		Set glossaryTitle=$p(DocType,"|",1)
		Set glossarySubTitle=$p(DocType,"|",2)
		Continue:(glossaryTitle="")||(glossarySubTitle="")||(EmrCodes="")
		
		
		For indDT=1:1:$l(EmrCodes,"|") {
			Set glossaryCode=$p(EmrCodes,"|",indDT)
			Continue:glossaryCode=""
			//获取每个术语集的电子病历数据
			Set arr=##Class(EMRservice.BIEMRService).GetDataByGlossary(+aEpisodeID,glossaryCode)
			Set xInstanceID=""
			For	{
	   			Set value=arr.GetNext(.xInstanceID) 
	   			zw xInstanceID
	    		Quit:xInstanceID=""
		
	    		Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(xInstanceID)
				Continue:'$IsObject(objInstance)
				If objInstance'="" Do objInstance.%Close()
		
				Set Title       = objInstance.Title          // 标题
				Set HappenDate  = objInstance.HappenDate     // 发生日期
				Set HappenTime  = objInstance.HappenTime     // 发生时间
				Set ModifyDate	= objInstance.ModifyDate     // 修改日期
				Set ModifyTime	= objInstance.ModifyTime     // 修改时间
				Set ModifyUser  = objInstance.ModifyUser     // 修改医生
				Set ModifyUserCode="",ModifyUserDesc=""
				Set:ModifyUser'="" ModifyUserCode=$p($g(^SSU("SSUSR",ModifyUser)),"^",1)
				Set:ModifyUser'="" ModifyUserDesc=$p($g(^SSU("SSUSR",ModifyUser)),"^",2)
				Continue:(aDateFrom'="")&(ModifyDate<aDateFrom)
				Continue:(aDateTo'="")&(ModifyDate>aDateTo)
				Set Data=$lb(xInstanceID,aEpisodeID,value,glossaryCode,Title,glossaryTitle,glossarySubTitle,HappenDate,HappenTime,ModifyDate,ModifyTime,ModifyUserCode,ModifyUserDesc)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
AutoTaskErr
	Quit $$$OK
}

ClassMethod QueryEmrRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmrRecordExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryEmrRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmrRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(DHCMA.VTE.DI.EmrDataSrv).SetItemPara()
/// 标准版
ClassMethod SetItemPara()
{
	New
	Set ^DHCVTE.EMRItemPara(1)="入院记录|主诉:HDSD00.13.114"
	Set ^DHCVTE.EMRItemPara(2)="入院记录|现病史:HDSD00.13.095"
	Set ^DHCVTE.EMRItemPara(3)="入院记录|既往史:HDSD00.13.042"
	Set ^DHCVTE.EMRItemPara(4)="入院记录|手术史:HDSD00.13.065"
	Set ^DHCVTE.EMRItemPara(5)="入院记录|婚育史:HDSD00.13.041"
	Set ^DHCVTE.EMRItemPara(6)="入院记录|家族史:HDSD00.13.043"
	Set ^DHCVTE.EMRItemPara(7)="入院记录|体格检查:HDSD00.13.088"
	Set ^DHCVTE.EMRItemPara(8)="入院记录|脉率:HDSD00.13.080"
	Set ^DHCVTE.EMRItemPara(9)="入院记录|呼吸频率:HDSD00.13.077"
	Set ^DHCVTE.EMRItemPara(10)="入院记录|收缩压:HDSD00.13.085"
	Set ^DHCVTE.EMRItemPara(11)="入院记录|舒张压:HDSD00.13.086"
	Set ^DHCVTE.EMRItemPara(12)="入院记录|身高:HDSD00.13.083"
	Set ^DHCVTE.EMRItemPara(13)="入院记录|初步诊断:HDSD00.13.023|HDSD00.13.025"
	Set ^DHCVTE.EMRItemPara(14)="入院记录|修正诊断:HDSD00.13.099|HDSD00.13.101"
	Set ^DHCVTE.EMRItemPara(15)="入院记录|确定诊断:HDSD00.13.051|HDSD00.13.053"
	Set ^DHCVTE.EMRItemPara(16)="入院记录|补充诊断:HDSD00.13.006"
	Set ^DHCVTE.EMRItemPara(18)="24h内入出院记录|主诉:HDSD00.13.114"
	Set ^DHCVTE.EMRItemPara(19)="24h内入出院记录|现病史:HDSD00.13.095"
	Set ^DHCVTE.EMRItemPara(20)="24h内入出院记录|入院情况:HDSD00.13.056"
	Set ^DHCVTE.EMRItemPara(21)="24h内入出院记录|症状名称:HDSD00.13.108"
	Set ^DHCVTE.EMRItemPara(22)="24h内入出院记录|入院诊断:HDSD00.13.060|HDSD00.13.062"
	Set ^DHCVTE.EMRItemPara(23)="24h内入出院记录|出院情况:HDSD00.13.010"
	Set ^DHCVTE.EMRItemPara(21)="24h内入出院记录|出院诊断:HDSD00.13.016|HDSD00.13.018"
	Set ^DHCVTE.EMRItemPara(22)="24h内入出院记录|出院医嘱:HDSD00.13.012"
	Set ^DHCVTE.EMRItemPara(23)="24h内入院死亡记录|入院诊断:HDSD00.13.060|HDSD00.13.062"
	Set ^DHCVTE.EMRItemPara(24)="24h内入院死亡记录|死亡诊断:HDSD00.13.070|HDSD00.13.072"
	Set ^DHCVTE.EMRItemPara(25)="首次病程记录|主诉:HDSD00.14.137"
	Set ^DHCVTE.EMRItemPara(26)="首次病程记录|病例特点:HDSD00.14.005"
	Set ^DHCVTE.EMRItemPara(27)="首次病程记录|入院诊断:HDSD00.14.300"
	Set ^DHCVTE.EMRItemPara(28)="首次病程记录|出院诊断:HDSD00.14.301"
	Set ^DHCVTE.EMRItemPara(29)="首次病程记录|初步诊断:HDSD00.14.321|HDSD00.14.322"
	Set ^DHCVTE.EMRItemPara(30)="日常病程记录|住院病程:HDSD00.14.139"
	Set ^DHCVTE.EMRItemPara(31)="日常病程记录|医嘱内容:HDSD00.14.118"
	Set ^DHCVTE.EMRItemPara(32)="上级医生查房记录|查房记录:HDSD00.14.011"
	Set ^DHCVTE.EMRItemPara(33)="上级医生查房记录|医嘱内容:HDSD00.14.118"
	Set ^DHCVTE.EMRItemPara(34)="出院记录|出院诊断:HDSD00.14.018|HDSD00.14.020"
	Set ^DHCVTE.EMRItemPara(35)="死亡记录|直接死亡原因名称:HDSD00.14.124"
	Set ^DHCVTE.EMRItemPara(36)="死亡记录|死亡诊断:HDSD00.14.107"
	Quit "OK"
}

}
