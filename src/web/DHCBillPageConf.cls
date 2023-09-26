/// 名称: web.DHCBillPageConf.cls
/// 描述: 界面配置
/// 编写者: ZhYW
/// 编写日期: 2019-04-16
Class web.DHCBillPageConf Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 保存页面设置数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).Save()
ClassMethod Save(obj As %ObjectHandle) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	ts
	
	if (obj.PCRowID="") {
		set dataObj=##class(User.DHCBillPageConf).%New(obj.PCWPParRef)
	}else {
		set dataObj=##class(User.DHCBillPageConf).%OpenId(obj.PCRowID, 0)
	}
	if ('$IsObject(dataObj)) {
		do dataObj.%Close()
		tro
		quit -1_"^"_"创建对象失败"
	}

	do dataObj.PCWPParRefSetObjectId(obj.PCWPParRef)
	set dataObj.PCSite=obj.PCSite
	set dataObj.PCSiteDR=obj.PCSiteDR
	set dataObj.PCCode=obj.PCCode
	set dataObj.PCValue=obj.PCValue
	set dataObj.PCDesc=obj.PCDesc
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 删除DHC_BillPageConf表数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).Delete("16||25")
ClassMethod Delete(idStr As %String) As %String
{
	set ^TMP("Delete")=idStr
	set rtn=0
	set msg="删除成功"
	ts
	set i=0
	while ((i<$l(idStr,"^"))&&(rtn=0)) {
		set id=$p(idStr,"^",$i(i))
		set sc=##class(User.DHCBillPageConf).%DeleteId(id)
		if $system.Status.IsError(sc) {            //检查删除是否成功
			set rtn=$system.Status.GetErrorCodes(sc)
			set msg=$system.Status.GetErrorText(sc)
		}
	}
	if (rtn=0) {
		if ($tl>0) tc
	}else {
		tro
	}
	quit ##class(web.DHCBillCommon).ReturnToJson(msg, rtn)
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 获取DHC_BillPageConf表的RowId
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).GetPageConfId("27","SYSTEM","LCATE","")
ClassMethod GetPageConfId(pageId As %String, site As %String, code As %String, siteId As %String = "") As %String
{
	set confId=""
	quit:(pageId="") confId

	set sub=0
	while($o(^DHCBillWP(0,pageId,"Site",site,"Code",code,"C",sub))&&(confId="")) {
		set sub=$o(^DHCBillWP(0,pageId,"Site",site,"Code",code,"C",sub))
		set cfgData=$g(^DHCBillWP(pageId,"C",sub))
		continue:(cfgData="")
		set mySiteDR=$p(cfgData,"^",2)
		continue:(siteId'=mySiteDR)
		set confId=pageId_"||"_sub
	}
	
	quit confId
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 获取DHC_BillPageConf表PC_Value
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).GetConfValue("18")
ClassMethod GetConfValue(pageId As %String, site As %String, code As %String, siteId As %String) As %String
{
	set value=""
	set confId=..GetPageConfId(pageId, site, code, siteId)
	if (+confId'=0) {
		set obj=##class(User.DHCBillPageConf).%OpenId(confId, 0)
		set value=obj.PCValue
		do obj.%Close()
	}

	quit value
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.opbill.emergtrans2ip.csp", "LCATE", "", "2")
ClassMethod GetPageConfValue(cspName As %String, code As %String, groupId As %String, hospId As %String) As %String
{
	set rtn=""
	set pageId=##class(web.DHCBillWebPage).GetWebPageRowId(cspName)
	if (pageId="") {
		quit rtn
	}
	//优先级:系统->安全组->院区
	set array(1)="SYSTEM"_"^"
	set array(2)="GROUP"_"^"_groupId
	set array(3)="HOSPITAL"_"^"_hospId
	set i=0
	while($o(array(i))&&(rtn="")) {
		set i=$o(array(i))
		set data=$g(array(i))
		set site=$p(data,"^",1)
		set siteId=$p(data,"^",2)
		set rtn=..GetConfValue(pageId, site, code, siteId)
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-11-01
/// Description: 查询不能转入住院医嘱子类(急诊费用转住院配置用)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindLimit2IPItemCat", "5", "HOSPITAL", "OP2IP", 2)
Query FindLimit2IPItemCat(pageId As %String, site As %String, code As %String, siteId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String,selected:%Boolean")
{
}

ClassMethod FindLimit2IPItemCatExecute(ByRef qHandle As %Binary, pageId As %String, site As %String, code As %String, siteId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set limitItemCatStr=..GetConfValue(pageId, site, code, siteId)
	
	set hospId=siteId
	
	set id=0
	while($o(^ARC("IC",id))) {
		set id=$o(^ARC("IC",id))
		set data=$g(^ARC("IC",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", id, hospId)
		continue:(showFlag="N")
		set myCode=$p(data,"^",1)
		set myDesc=$p(data,"^",2)
		set selected=$s((($c(2)_limitItemCatStr_$c(2))[($c(2)_id_$c(2))):"true", 1:"false")
		do OutputLimit2IPItemCat
	}
	
	quit $$$OK
	
OutputLimit2IPItemCat
	set Data=$lb(id,myCode,myDesc,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 保存页面设置数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPageConf).SaveConfInfo(4, ^TMP("confList"))
ClassMethod SaveConfInfo(pageId As %String, confList As %ArrayOfDataTypes) As %String
{
	set $zt="ERROR"

	set rtn=0
	
	ts
	
	set i=0
	while(($o(confList(i)))&&(+rtn=0)) {
		set i=$o(confList(i))
		set jsonStr=$g(confList(i))
		continue:(jsonStr="")
		set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
		set PCSite=jsonObj.PCSite
		set PCSiteDR=jsonObj.PCSiteDR
		set PCCode=jsonObj.PCCode
		set PCValue=jsonObj.PCValue
		set PCDesc=jsonObj.PCDesc
		set confId=jsonObj.PCRowID
		if (confId="") {
			set confId=..GetPageConfId(pageId, PCSite, PCCode, PCSiteDR)
		}
		set jsonObj.PCWPParRef=pageId
		set jsonObj.PCRowID=confId
		set rtn=..Save(jsonObj)
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

Query LookUpHospital(desc As %String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String")
{
	SELECT HOSP_Desc,HOSP_RowId
	FROM SQLUser.CT_Hospital
	WHERE((%ALPHAUP HOSP_RowId [ %ALPHAUP :desc) OR (:desc IS NULL))
	AND (HOSP_RowId > 0)
}

/// Creator: ZhYW
/// CreatDate: 2020-04-08
/// Description: 查询需要对冲的支付方式(住院取消结算配置用)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindPayMode")
Query FindPayMode() As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindPayModeExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set id=0
	while($o(^CT("CTPM",id))) {
		set id=$o(^CT("CTPM",id))
		set data=$g(^CT("CTPM",id))
		continue:(data="")
		set dateFrom=$p(data,"^",5)
		set dateTo=$p(data,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set desc=$p(data,"^",2)
		do OutputPMFrom
	}
	
	quit $$$OK
	
OutputPMFrom
	set Data=$lb(id,desc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: tangzf
/// CreatDate: 2021-6-7
/// Description: 修改支付方式对照
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindModifyPayModeCon",10,"HOSPITAL","TRANSPM",2)
Query FindModifyPayModeCon(pageId As %String, site As %String, code As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "confId,RowId,Code,Desc")
{
}

ClassMethod FindModifyPayModeConExecute(ByRef qHandle As %Binary, pageId As %String, site As %String, code As %String, hospId As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("BILL_Com_ModifyPayMode", hospId)
	set siteId=defHospId
	
	set sub=0
	while($o(^DHCBillWP(0,pageId,"Site",site,"Code",code,"C",sub))) {
		set sub=$o(^DHCBillWP(0,pageId,"Site",site,"Code",code,"C",sub))
		set cfgData=$g(^DHCBillWP(pageId,"C",sub))
		continue:(cfgData="")
		set confId=pageId_"||"_sub
		set siteDR=$p(cfgData,"^",2)
		continue:(siteId'=siteDR)
		set myValue=$p(cfgData,"^",4)
		set len=$l(myValue,"|")
		for i=1:1:len {
			set paymDR=$p(myValue,"|",i)
			continue:(paymDR="")
			set paymData=$g(^CT("CTPM",paymDR))
			set dateFrom=$p(paymData,"^",5)
			set dateTo=$p(paymData,"^",6)
			continue:((dateFrom'="")&&(dateFrom>+$h))
			continue:((dateTo'="")&&(dateTo<+$h))
			set paymCode=$p(paymData,"^",1)
			set paymDesc=$p(paymData,"^",2)
			set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
			do OutputMPCList
		}
	}
	
	quit $$$OK
	
OutputMPCList
	set Data=$lb(confId,paymDR,paymCode,paymDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: tangzf
/// CreatDate: 2021-6-7
/// Description: 对外接口测试
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindInterfaceTest",10,"HOSPITAL","TRANSPM",2)
Query FindInterfaceTest(pageId As %String, site As %String, code As %String, hospId As %String) As websys.Query(ROWSPEC = "confId,ConCode,Coninfo,ConDesc")
{
}

ClassMethod FindInterfaceTestExecute(ByRef qHandle As %Binary, pageId As %String, site As %String, code As %String, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("BILL_Com_InterfaceTest", hospId)
	set siteId=defHospId
	
	set myCode=""
	while($o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode))'="") {
		set myCode=$o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode))
		set sub=0
		while($o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode,"C",sub))) {
			set sub=$o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode,"C",sub))
			set cfgData=$g(^DHCBillWP(pageId,"C",sub))
			continue:(cfgData="")
			set confId=pageId_"||"_sub
			set siteDR=$p(cfgData,"^",2)
			continue:(siteId'=siteDR)
			set myCode=$p(cfgData,"^",3)
			set myValue=$p(cfgData,"^",4)
			set myDesc=$p(cfgData,"^",5)
			do OutputInterfaceTest
		}
	}
	
	quit $$$OK
	
OutputInterfaceTest
	set Data=$lb(confId,myCode,myValue,myDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-07-15
/// Description: 查询用户
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindUserList",2)
Query FindUserList(hospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindUserListExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set id=0
	while($o(^SSU("SSUSR",id))) {
		set id=$o(^SSU("SSUSR",id))
		set data=$g(^SSU("SSUSR",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User", id, hospId)
		continue:(showFlag="N")
		set userName=$p(data,"^",2)
		set isActive=$p(data,"^",19)
		continue:(isActive'="Y")
		set dateFrom=$p(data,"^",96)
		set dateTo=$p(data,"^",97)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		do OutputUserList
	}
	
	quit $$$OK
	
OutputUserList
	set Data=$lb(id,userName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-07-15
/// Description: 查询撤销非本人收费产生的异常人员设置
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPageConf","FindOPChgRolUsrCfgList",19,"HOSPITAL","ROLUSER",2)
Query FindOPChgRolUsrCfgList(pageId As %String, site As %String, code As %String, hospId As %String) As websys.Query(ROWSPEC = "ConfId:%String,UserId:%String,UserDesc:%String")
{
}

ClassMethod FindOPChgRolUsrCfgListExecute(ByRef qHandle As %Binary, pageId As %String, site As %String, code As %String, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_ChgException", hospId)
	set siteId=defHospId
	
	set myCode=code
	while($o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode))'="") {
		set myCode=$o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode))
		set userDR=$p(myCode,code,2)
		set userDesc=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
		set sub=0
		while($o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode,"C",sub))) {
			set sub=$o(^DHCBillWP(0,pageId,"Site",site,"Code",myCode,"C",sub))
			set cfgData=$g(^DHCBillWP(pageId,"C",sub))
			continue:(cfgData="")
			set confId=pageId_"||"_sub
			set siteDR=$p(cfgData,"^",2)
			continue:(hospId'=siteDR)
			do OutputRolUsrCfgList
		}
	}
	
	quit $$$OK
	
OutputRolUsrCfgList
	set Data=$lb(confId,userDR,userDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
