/// 名称: web.DHCIPBillRegConf.cls
/// 描述: 住院登记设置
/// 编写者: ZhYW
/// 编写日期: 2019-04-16
Class web.DHCIPBillRegConf Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 保存登记页面缓存的DOM对象，用来维护项目必填和页面元素跳转顺序
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillRegConf).SaveDOMCache()
ClassMethod SaveDOMCache(obj As %String) As %String
{
	set ^DHCBILLCONFIG("RegDOMCache")=obj
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-11-01
/// Description: 查询住院页面缓存DOM元素
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillRegConf","FindRegDOMList")
Query FindRegDOMList() As websys.Query(ROWSPEC = "id:%String,text:%String,required:%String,disabled:%String,focus:%String")
{
}

ClassMethod FindRegDOMListExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	set jsonStr=$g(^DHCBILLCONFIG("RegDOMCache"))
	if (jsonStr="") quit $$$OK
	
	set focusId="PatientNo"            //首屏焦点位置
	set requiredIdStr="Name"_$c(2)_"Sex"_$c(2)_"BirthDate"_$c(2)_"Country"        //必填元素
	set requiredIdStr=requiredIdStr_$c(2)_"AdmReason"_$c(2)_"Dept"_$c(2)_"Ward"   
	set disabledIdStr="VisitStatus"_$c(2)_"User"_$c(2)_"SuggestDepAmt"            //禁用元素

	set jsonObj=##class(%DynamicAbstractObject).%FromJSON(jsonStr)
	set iter=jsonObj.%GetIterator()
   	while iter.%GetNext(.key, .value) {
   		set id=key
   		set text=value
   		set required=$s((($c(2)_requiredIdStr_$c(2))[($c(2)_id_$c(2))):1, 1:0)
   		set disabled=$s((($c(2)_disabledIdStr_$c(2))[($c(2)_id_$c(2))):1, 1:0)
   		set focus=$s((focusId=id):1, 1:0)
   		do OutputRegDOMList
   	}
	quit $$$OK
	
OutputRegDOMList
	set Data=$lb(id,text,required,disabled,focus)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-11-01
/// Description: 查询页面配置数据
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillRegConf","FindPageConf", 5)
Query FindPageConf(pageId As %String, hospId As %String) As websys.Query(ROWSPEC = "site:%String,modeDesc:%String,siteId:%String,userDesc:%String,confIdStr:%String")
{
}

ClassMethod FindPageConfExecute(ByRef qHandle As %Binary, pageId As %String, hospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+pageId=0)  quit $$$OK
	
	kill ^||TMP($j)
	
	set site=""
	for  set site=$o(^DHCBillWP(0,pageId,"Site",site))  quit:(site="")  do
	.set code=""
	.for  set code=$o(^DHCBillWP(0,pageId,"Site",site,"Code",code))  quit:(code="")  do
	..set sub=0
	..for  set sub=$o(^DHCBillWP(0,pageId,"Site",site,"Code",code,"C",sub))  quit:(sub="")  do
	...set cfgData=$g(^DHCBillWP(pageId,"C",sub))
	...quit:(cfgData="")
	...set confId=pageId_"||"_sub
	...set siteDR=$p(cfgData,"^",2)
	...quit:(+siteDR=0)
	...set showFlag="Y"
	...if ((site="HOSPITAL")&&(siteDR'=hospId)) do
	....set showFlag="N"
	...else  if (site="GROUP") do
	....set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_Group", siteDR, hospId)
	...quit:(showFlag="N")
	...if ('$d(^||TMP($j,site,siteDR))) do
	....set ^||TMP($j,site,siteDR)=confId
	...else  do
	....set ^||TMP($j,site,siteDR)=$g(^||TMP($j,site,siteDR))_"^"_confId

	set site=""
	for  set site=$o(^||TMP($j,site))  quit:(site="")  do
	.set modeDesc=""
	.if (site="GROUP") do
	..set modeDesc="安全组"
	.else  if (site="HOSPITAL") do
	..set modeDesc="医院"
	.set siteId="0"
	.for  set siteId=$o(^||TMP($j,site,siteId))  quit:(siteId="")  do
	..set userDesc=""
	..if (site="GROUP") do
	...set userDesc=$p(^SSU("SSGRP",siteId),"^",1)
	..else  if (site="HOSPITAL") do
	...set userDesc=$p(^CT("HOSP",siteId),"^",2)
	..set confIdStr=$g(^||TMP($j,site,siteId))
	..do OutputPageConf
	
	kill ^||TMP($j)
	quit $$$OK
	
OutputPageConf
	set Data=$lb(site,modeDesc,siteId,userDesc,confIdStr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-11-01
/// Description: 通过DHC_BillPageConf.PC_RowID和PC_Code取值
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillRegConf).GetConfValById("5||56^5||57", "DOMSEQ")
ClassMethod GetConfValById(confIdStr As %String, code As %String) As %String
{
	set rtn=""
	for i=1:1:$l(confIdStr,"^") quit:(rtn'="")  do
	.set confId=$p(confIdStr,"^",i)
	.set pageId=+confId
	.set sub=$p(confId,"||",2)
	.set cfgData=$g(^DHCBillWP(pageId,"C",sub))
	.quit:(cfgData="")
	.set myCode=$p(cfgData,"^",3)
	.quit:(code'=myCode)
	.set value=$p(cfgData,"^",4)
	.set rtn=value
	
	quit rtn
}

}
