/// 名称: web.DHCIPBillCostMonitorConfig.cls
/// 描述: 住院费用核查配置类
/// 编写者：ZhYW
/// 编写日期: 2017-07-19
Class web.DHCIPBillCostMonitorConfig Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2017-07-19
/// Description: 查询分类规则明细
/// Input: MPCRowID:监控点RowID
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCostMonitorConfig", "FindTypeRulesList", 1)
Query FindTypeRulesList(MPCRowID As %String) As websys.Query(ROWSPEC = "TCDRowID:%String,TRulesCode:%String,TRulesType:%String,TRulesTypeDR:%String,TRulesDesc:%String,TMaxQty:%String")
{
}

ClassMethod FindTypeRulesListExecute(ByRef qHandle As %Binary, MPCRowID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+MPCRowID=0)   quit $$$OK
	
	set code=""
	while($o(^DHCMPConfigi(0,"ARCType",MPCRowID,code))'="") {
		set code=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,code))
		set typeDR=0
		while($o(^DHCMPConfigi(0,"ARCType",MPCRowID,code,typeDR))'="") {
			set typeDR=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,code,typeDR))
			set type="", desc=""
			if (code="OECCAT") {
				set type="医嘱大类"
				set desc=$p($g(^OEC("ORCAT",typeDR)),"^",2)
			}elseif (code="ARCIC") {
				set type="医嘱子类"
				set desc=$p($g(^ARC("IC",typeDR)),"^",2)
			}elseif (code="ARCIM") {
				set type="医嘱项"
				set desc=$p($g(^ARCIM(+typeDR,1,1)),"^",2)
			}
			set sub=0
			while($o(^DHCMPConfigi(0,"ARCType",MPCRowID,code,typeDR,sub))) {
				set sub=$o(^DHCMPConfigi(0,"ARCType",MPCRowID,code,typeDR,sub))
				set data=$g(^DHCMPConfig(MPCRowID,"D",sub))
				continue:(data="")
				set maxQty=$p(data,"^",7)
				set CDRowID=MPCRowID_"||"_sub
				do OutputRulesList	
			}
		}
	}
	
	quit $$$OK
OutputRulesList
	set Data=$lb(CDRowID,code,type,typeDR,desc,maxQty)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCIPBillCostMonitorConfig", "FindMonitorPoint")
Query FindMonitorPoint(hospId As %String, keyCode As %String = "") As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,active:%String,type:%String,reviewed:%String")
{
}

ClassMethod FindMonitorPointExecute(ByRef qHandle As %Binary, hospId As %String, keyCode As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	set rowId=0
	while($o(^DHCMPConfig(rowId))) {
		set rowId=$o(^DHCMPConfig(rowId))
		set data=$g(^DHCMPConfig(rowId))
		continue:(data="")
		set hospDR=$p(data,"^",6)
		continue:(hospDR'=hospId)
		set code=$p(data,"^",1)
		set desc=$p(data,"^",2)
		continue:((keyCode'="")&&(desc'[keyCode))
		set active=$p(data,"^",4)    //是否启用标志
		set type=$p(data,"^",5)
		set reviewed=$p(data,"^",7)
		do OutputMonitorPoint
	}
	
	quit $$$OK
OutputMonitorPoint
   set Data=$lb(rowId,code,desc,active,type,reviewed)
   set ^CacheTemp(repid,ind)=Data
   set ind=$i(ind)
   quit
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: DHC_BillMonitorPointConfig写数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).SaveMonitor("{""Id"":"""",""Code"":""03"",""Desc"":""而突然"",""Explain"":"""",""Active"":""N"",""Type"":""C""}")
ClassMethod SaveMonitor(jsonStr As %String) As %String
{
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	ts
	if (jsonObj.Id="") {
		set dataObj=##class(User.DHCBillMonitorPointConfig).%New()
	}else {
		set dataObj=##class(User.DHCBillMonitorPointConfig).%OpenId(jsonObj.Id, 0)
	}
	if ('$IsObject(dataObj)) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson("对象不存在", -2)
	}
	set dataObj.MPCCode=jsonObj.Code
	set dataObj.MPCDesc=jsonObj.Desc
	set dataObj.MPCExplain=jsonObj.Explain
	set dataObj.MPCActiveFlag=jsonObj.Active
	set dataObj.MPCType=jsonObj.Type
	do dataObj.MPCHospDRSetObjectId(jsonObj.HospId)
	set dataObj.MPCReviewedFlag=jsonObj.Reviewed  //2022-04-28 ZhYW 能否审核标识
	set sc=dataObj.%Save()
	if $$$ISERR(sc) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson($system.Status.GetErrorText(sc), $System.Status.GetErrorCodes(sc))
	}
	do dataObj.%Close()
	if ($tl>0) tc
	
	quit ##class(web.DHCBillCommon).ReturnToJson("保存成功", 0)
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: 删除DHC_BillMonitorPointConfig数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).DeleteMonitor("")
ClassMethod DeleteMonitor(id As %String) As %String
{
	//删除监控点
	set sc=##class(User.DHCBillMonitorPointConfig).%DeleteId(id)
	if $system.Status.IsError(sc) {
		quit ##class(web.DHCBillCommon).ReturnToJson($system.Status.GetErrorText(sc), $System.Status.GetErrorCodes(sc))
	}
	quit ##class(web.DHCBillCommon).ReturnToJson("删除成功", 0)
}

/// Creator: ZhYW
/// CreatDate: 2017-07-19
/// Description: 查询医嘱大类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCostMonitorConfig", "FindOECOrdCat")
Query FindOECOrdCat(HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindOECOrdCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^OEC("ORCAT",rowId))) {
		set rowId=$o(^OEC("ORCAT",rowId))
		set data=$g(^OEC("ORCAT",rowId))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory", rowId, HospId)
		continue:(showFlag="N")
		set code=$p(data,"^",1)
		set desc=$p(data,"^",2)
		do OutputOECOrdCat
	}
	
	quit $$$OK
OutputOECOrdCat
	set Data=$lb(rowId,desc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2017-07-19
/// Description: 查询医嘱子类
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCostMonitorConfig", "FindItemCat")
Query FindItemCat(HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindItemCatExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set rowId=0
	while($o(^ARC("IC",rowId))) {
		set rowId=$o(^ARC("IC",rowId))
		set data=$g(^ARC("IC",rowId))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", rowId, HospId)
		continue:(showFlag="N")
		set code=$p(data,"^",1)
		set desc=$p(data,"^",2)
		do OutputItemCat
	}
	
	quit $$$OK
OutputItemCat
	set Data=$lb(rowId,desc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: 通过监控点id获取配置表数据(json)
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).GetCheckDataByConfId(1)
ClassMethod GetCheckDataByConfId(MPCRowID As %String) As %String
{
	set CDRowID=""
	set sub=0
	while($o(^DHCMPConfig(MPCRowID,"D",sub))) {
		set sub=$o(^DHCMPConfig(MPCRowID,"D",sub))
		set data=$g(^DHCMPConfig(MPCRowID,"D",sub))
		continue:(data="")
		set myId=MPCRowID_"||"_sub
		set type=$p(data,"^",2)
		continue:(type'="")
		set CDRowID=myId
		quit
	}	
	quit ##class(web.DHCBillCommon).GetClsPropValById("User.DHCBillCheckData", CDRowID)
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: DHC_BillCheckData写数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).SaveRules("{""MoniId"":""1"",""Id"":""1||11"",""Type"":""OECCAT"",""TypeDR"":""1"",""MaxQty"":""""}")
ClassMethod SaveRules(jsonStr As %String) As %String
{
	set ^TMP("SaveRules")=jsonStr
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	
	if ((jsonObj.Type'="")&&(jsonObj.TypeDR'="")) {
		set mySub=$o(^DHCMPConfigi(0,"ARCType",jsonObj.MoniId,jsonObj.Type,jsonObj.TypeDR,""))
		set myId=$s((+mySub'=0):(jsonObj.MoniId_"||"_mySub),1:"")
		if ((myId'="")&&(myId'=jsonObj.Id)) {
			quit ##class(web.DHCBillCommon).ReturnToJson("已有该记录，不能重复添加", -2)
		}
	}
	
	ts
	if (jsonObj.Id="") {
		set dataObj=##class(User.DHCBillCheckData).%New(jsonObj.MoniId)
	}else {
		set dataObj=##class(User.DHCBillCheckData).%OpenId(jsonObj.Id, 0)
	}
	if ('$IsObject(dataObj)) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson("对象不存在", -2)
	}
	do dataObj.CDParRefSetObjectId(jsonObj.MoniId)
	set dataObj.CDARCType=jsonObj.Type
	set dataObj.CDARCTypeDR=jsonObj.TypeDR
	set dataObj.CDMaxQty=jsonObj.MaxQty
	set sc=dataObj.%Save()
	if $$$ISERR(sc) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson($system.Status.GetErrorText(sc), $System.Status.GetErrorCodes(sc))
	}
	do dataObj.%Close()
	if ($tl>0) tc
	
	quit ##class(web.DHCBillCommon).ReturnToJson("保存成功", 0)
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: DHC_BillCheckData写数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).SaveCheckData()
ClassMethod SaveCheckData(jsonStr As %String) As %String
{
	set ^TMP("SaveCheckData")=jsonStr
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	ts
	if (jsonObj.Id="") {
		set dataObj=##class(User.DHCBillCheckData).%New(jsonObj.MoniId)
	}else {
		set dataObj=##class(User.DHCBillCheckData).%OpenId(jsonObj.Id, 0)
	}
	if ('$IsObject(dataObj)) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson("对象不存在", -2)
	}
	do dataObj.CDParRefSetObjectId(jsonObj.MoniId)
	set dataObj.CDDaysMode=jsonObj.DaysMode
	set dataObj.CDAirMode=jsonObj.AirMode
	set dataObj.CDAirStDate=##class(websys.Conversions).DateHtmlToLogical(jsonObj.AirStDate)
	set dataObj.CDAirEndDate=##class(websys.Conversions).DateHtmlToLogical(jsonObj.AirEndDate)
	set sc=dataObj.%Save()
	if $$$ISERR(sc) {
		do dataObj.%Close()
		tro
		quit ##class(web.DHCBillCommon).ReturnToJson($system.Status.GetErrorText(sc), $System.Status.GetErrorCodes(sc))
	}
	do dataObj.%Close()
	if ($tl>0) tc
	
	quit ##class(web.DHCBillCommon).ReturnToJson("保存成功", 0)
}

/// Creator: ZhYW
/// CreatDate: 2020-01-09
/// Description: 删除DHC_BillCheckData数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillCostMonitorConfig).DeleteCD()
ClassMethod DeleteCD(id As %String) As %String
{
	set sc=##class(User.DHCBillCheckData).%DeleteId(id)
	if $system.Status.IsError(sc) {
		quit ##class(web.DHCBillCommon).ReturnToJson($system.Status.GetErrorText(sc), $System.Status.GetErrorCodes(sc))
	}
	quit ##class(web.DHCBillCommon).ReturnToJson("删除成功", 0)
}

}
