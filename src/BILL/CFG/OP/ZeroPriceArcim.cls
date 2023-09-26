/// 名称: BILL.CFG.OP.ZeroPriceArcim.cls
/// 描述: 允许零价格医嘱维护业务类
/// 编写者: ZhYW
/// 编写日期: 2022-06-16
/// 产品组：计费医保组
Class BILL.CFG.OP.ZeroPriceArcim Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-06-16
/// Description: 查询配置的医嘱项
/// Input: 
/// Output: 配置ID,医嘱项ID,医嘱项名称,生效开始日期,生效结束日期,创建人,创建日期,创建时间,更新人,更新日期,更新时间
/// Debug: do ##class(%ResultSet).RunQuery("BILL.CFG.OP.ZeroPriceArcim","QryZeroPriceArcimList","ycx","2")
Query QryZeroPriceArcimList(arcimId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "CfgId:%String:配置ID,ArcimId:%String:医嘱项ID,ArcimDesc:%String:医嘱项名称,DateFrom:%String:生效开始日期,DateTo:%String:生效结束日期,CreatUserName:%String:创建人,CreatDate:%String:创建日期,CreatTime:%String:创建时间,UpdtUserName:%String:更新人,UpdtDate:%String:更新日期,UpdtTime:%String:更新时间")
{
}

ClassMethod QryZeroPriceArcimListExecute(ByRef qHandle As %Binary, arcimId As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryZeroPriceArcimList")=$lb(arcimId, hospId, langId)
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	if (arcimId'="") {
		set id=0
		while($o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcimId,id))) {
			set id=$o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcimId,id))
			do GetARCIMCfgData
		}
		quit $$$OK
	}
	
	set id=0
	while($o(^CF.BILL.OP.ZeroPriceArcimD(id))) {
		set id=$o(^CF.BILL.OP.ZeroPriceArcimD(id))
		do GetARCIMCfgData
	}
	quit $$$OK
GetARCIMCfgData
	set data=$g(^CF.BILL.OP.ZeroPriceArcimD(id))
	set hospDR=$lg(data,11)
	quit:(hospDR'=hospId)
	set arcim=$lg(data,2)
	quit:(arcim="")
	set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
	set dateFrom=$lg(data,3)
	set dateTo=$lg(data,4)
	set dateFrom=##class(websys.Conversions).DateLogicalToHtml(dateFrom)
	set dateTo=##class(websys.Conversions).DateLogicalToHtml(dateTo)
	set creatUserDR=$lg(data,5)
	set creatUserName=$s((+creatUserDR'=0):$p(^SSU("SSUSR",creatUserDR),"^",2),1:"")
	set creatUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", creatUserName, langId)
	set creatDate=$lg(data,6)
	set creatTime=$lg(data,7)
	set creatDate=##class(websys.Conversions).DateLogicalToHtml(creatDate)
	set creatTime=##class(websys.Conversions).TimeLogicalToHtml(creatTime)
	set updtUserDR=$lg(data,8)
	set updtUserName=$s((+updtUserDR'=0):$p(^SSU("SSUSR",updtUserDR),"^",2),1:"")
	set updtUserName=##class(User.SSUser).GetTranByDesc("SSUSRName", updtUserName, langId)
	set updtDate=$lg(data,9)
	set updtTime=$lg(data,10)
	set updtDate=##class(websys.Conversions).DateLogicalToHtml(updtDate)
	set updtTime=##class(websys.Conversions).TimeLogicalToHtml(updtTime)
	do OutputARCIMCfgList
	quit
OutputARCIMCfgList
	set data=$lb(id,arcim,arcimDesc,dateFrom,dateTo,creatUserName,creatDate,creatTime,updtUserName,updtDate,updtTime)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-16
/// Description: 保存配置数据
/// Input: 
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.CFG.OP.ZeroPriceArcim).SaveData("{""cfgId"":""16"",""arcimId"":""3885||1"",""dateFrom"":"""",""dateTo"":"""",""userId"":""1"",""hospId"":""2""}")
ClassMethod SaveData(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("SaveData")=jsonStr
	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	
	set json.dateFrom=##class(websys.Conversions).DateHtmlToLogical(json.dateFrom)
	set json.dateTo=##class(websys.Conversions).DateHtmlToLogical(json.dateTo)
	set json.UpdtDate=##class(websys.Conversions).DateHtmlToLogical(json.UpdtDate)
	set json.UpdtTime=##class(websys.Conversions).DateHtmlToLogical(json.UpdtTime)
	
	set rtn=0
	
	if (json.dateFrom=0) {
		quit -1_"^"_"生效开始日期不能为空"
	}
	if (json.dateTo>0) {
		if (json.dateTo<+$h) {
			quit -1_"^"_"生效结束日期不能小于当天"
		}
		if (json.dateTo<json.dateFrom) {
			quit -1_"^"_"生效结束日期不能小于生效开始日期"
		}
	}
	
	set oldData="{}"
	if (json.cfgId>0) {
		set oldData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.OP.ZeroPriceArcim", json.cfgId)   //取更新前的数据，用于留痕
	}else {
		if (json.dateFrom<+$h) {
			quit -1_"^"_"生效开始日期不能小于当天"
		}
	}
	
	set rtnVlaue=..ChkIsRepeat(json.cfgId, json.arcimId, json.hospId)
	set rtn=$p(rtnVlaue,"^",1)
	quit:(+rtn) rtnVlaue
	
	ts
	
	if (json.cfgId>0) {
		set dataObj=##class(CF.BILL.OP.ZeroPriceArcim).%OpenId(json.cfgId, 0)
		do dataObj.UpdtUserDRSetObjectId(json.userId)
		set dataObj.UpdtDate=+$h
		set dataObj.UpdtTime=$p($h,",",2)
	}else {
		set dataObj=##class(CF.BILL.OP.ZeroPriceArcim).%New()
		do dataObj.ARCIMDRSetObjectId(json.arcimId)
		do dataObj.CreatUserDRSetObjectId(json.userId)
		do dataObj.HospDRSetObjectId(json.hospId)
	}
	set dataObj.DateFrom=json.dateFrom
	set dataObj.DateTo=json.dateTo
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	if ($tl>0) tc
	
	//保存日志
	set className="CF.BILL.OP.ZeroPriceArcim"
	set tableName=$g(^oddCOM(className,53))
	set classNameDesc="允许零价格医嘱配置"
	set newData=##class(web.DHCBillCommon).GetClsPropValById("CF.BILL.OP.ZeroPriceArcim", dataId)
	if (json.cfgId>0) {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "修改", "U", newData, oldData, json.userId)
	}else {
		do ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(tableName, className, classNameDesc, dataId, "插入", "A", newData, json.userId)
	}
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-06-16
/// Description: 校验是否重复
/// Input: cfgId:CF_BILL_OP.ZeroPriceArcim.RowId, arcim:ARC_ItmMast.RowId, hospId:CT_Hospital.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(BILL.CFG.OP.ZeroPriceArcim).ChkIsRepeat("","3741||1",9)
ClassMethod ChkIsRepeat(cfgId As %String, arcim As %String, hospId As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("ChkIsRepeat")=$lb(cfgId, arcim, hospId)
	set rtn=0
	quit:(arcim="") rtn
	
	set pId=""
	set id=0
	while($o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcim,id))) {
		set id=$o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcim,id))
		set data=$g(^CF.BILL.OP.ZeroPriceArcimD(id))
		set hospDR=$lg(data,11)
		continue:(hospDR'=hospId)
		set pId=id
		quit
	}
	set rtn=((pId'="")&&(pId'=cfgId))
	quit:(+rtn) +rtn_"^"_"已有该项目，不能重复添加"
	quit 0
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-06-16
/// Description: 校验是否是维护的零价格医嘱
/// Input: arcim:ARC_ItmMast.RowId, hospId:CT_Hospital.RowId
/// Return: 0:否, 1:是
/// Other: 业务层使用
/// Debug: w ##class(BILL.CFG.OP.ZeroPriceArcim).IsZeroPriceARCIM("3741||1",2)
ClassMethod IsZeroPriceARCIM(arcim As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(arcim="") rtn
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_ZeroPriceArcim", hospId)
	
	set id=0
	while($o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcim,id))) {
		set id=$o(^CF.BILL.OP.ZeroPriceArcimI("IdxARCIMDR",arcim,id))
		set data=$g(^CF.BILL.OP.ZeroPriceArcimD(id))
		set hospDR=$lg(data,11)
		continue:(hospDR'=defHospId)
		set dateFrom=$lg(data,3)
		set dateTo=$lg(data,4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set rtn=1
		quit
	}
	quit rtn
}

}
