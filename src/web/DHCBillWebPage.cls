/// 名称: web.DHCBillWebPage.cls
/// 描述: 页面元素设置
/// 编写者: ZhYW
/// 编写日期: 2019-04-16
Class web.DHCBillWebPage Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 保存页面设置数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillWebPage).Save("28","aacc^bb^ccdd")
ClassMethod Save(id As %String, pageInfo As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("Save")=$lb(id, pageInfo)
	set rtn=0
	
	set cspName=$p(pageInfo,"^",1)
	set pageName=$p(pageInfo,"^",2)
	set confURL=$p(pageInfo,"^",3)	
	if (cspName="") quit -1_"^"_"参数错误"
	
	ts
	
	if (id="") {
		set obj=##class(User.DHCBillWebPage).%New()
	}else {
		set obj=##class(User.DHCBillWebPage).%OpenId(id, 0)
	}
	if ('$isObject(obj)) {
		do obj.%Close()
		tro
		quit -2_"^"_"创建对象失败"
	}
	set obj.WPCSPName=cspName
	set obj.WPPageName=pageName
	set obj.WPConfURL=confURL
	set sc=obj.%Save()
	do obj.%Close()
	if $$$ISERR(sc) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	set rowId=obj.%Id()
	if ($tl>0) tc
	
	quit rtn_"^"_rowId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 删除DHC_BillWebPage表数据
/// Input: 
/// Output: 
/// Debug: w ##class(web.DHCBillWebPage).Delete()
ClassMethod Delete(id As %String) As %String
{
	set sc=##class(User.DHCBillWebPage).%DeleteId(id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		quit ##class(web.DHCBillCommon).ReturnToJson("删除失败:"_$system.Status.GetErrorText(sc), $system.Status.GetErrorCodes(sc))
	}
	quit ##class(web.DHCBillCommon).ReturnToJson("删除成功", 0)
}

/// Creator: ZhYW
/// CreatDate: 2019-04-16
/// Description: 通过csp名获取DHC_BillWebPage表的RowId
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillWebPage).GetWebPageRowId("dhcbill.ipbill.reg.csp")
ClassMethod GetWebPageRowId(cspName As %String) As %String
{
	quit $s((cspName'=""):$o(^DHCBillWP(0,"CSPName",cspName,"0")),1:"")
}

/// Creator: ZhYW
/// CreatDate: 2019-11-01
/// Description: 页面查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillWebPage","FindWebPage","dhcbill")
Query FindWebPage(keyCode As %String = "") As websys.Query(ROWSPEC = "rowId:%String,cspName:%String,pageName:%String,confURL:%String")
{
}

ClassMethod FindWebPageExecute(ByRef qHandle As %Binary, keyCode As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	set rowId=0
	while($o(^DHCBillWP(rowId))) {
		set rowId=$o(^DHCBillWP(rowId))
		set pageData=$g(^DHCBillWP(rowId))
		continue:(pageData="")
		set cspName=$p(pageData,"^",1)
		set pageName=$p(pageData,"^",2)
		continue:((keyCode'="")&&(cspName'[keyCode)&&(pageName'[keyCode))
		set confURL=$p(pageData,"^",3)
		do OutputWebPage
	}
	quit $$$OK

OutputWebPage
	set Data=$lb(rowId,cspName,pageName,confURL)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
