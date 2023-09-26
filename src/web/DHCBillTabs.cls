/// 名称: web.DHCBillTabs.cls
/// 描述: 计费页签
/// 编写者：ZhYW
/// 编写日期: 2018-03-28
Class web.DHCBillTabs Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2022-03-01
/// Description: 查询业务类型
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillTabs","QryBizTypes")
Query QryBizTypes() As websys.Query(ROWSPEC = "value:%String:编码,text:%String:描述")
{
}

ClassMethod QryBizTypesExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set json=##class(BILL.CFG.COM.GroupAuth).GetTabBizTypes()
	set iter=json.%GetIterator()
   	while iter.%GetNext(.key, .value) {
   		do OutputBizTypes
   	}
	quit $$$OK
OutputBizTypes
	set data=$lb(key,value)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-03-28
/// Description: 查询DHC_BillTabs
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillTabs","QryBillTabs", "")
Query QryBillTabs(type As %String) As websys.Query(ROWSPEC = "rowId:%Integer,id:%String,title:%String,href:%String,active:%String:是否启用,type:%String:业务类型代码,typeDesc:%String:业务类型") [ SqlProc ]
{
}

ClassMethod QryBillTabsExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	kill tabList
	
	set rowId=0
	while($o(^DHCBILLTABS(rowId))) {
		set rowId=$o(^DHCBILLTABS(rowId))
		set tabData=$g(^DHCBILLTABS(rowId))
		set tabType=$p(tabData,"^",5)
		continue:((type'="")&&(type'=tabType))
		set tabList(tabType,rowId)=""
	}
	
	set tabType=""
	while($o(tabList(tabType),-1)'="") {
		set tabType=$o(tabList(tabType),-1)
		set rowId=0
		while($o(tabList(tabType,rowId))) {
			set rowId=$o(tabList(tabType,rowId))
			set tabData=$g(^DHCBILLTABS(rowId))
			set id=$p(tabData,"^",1)
			set title=$p(tabData,"^",2)
			set href=$p(tabData,"^",3)
			set active=$p(tabData,"^",4)
			set tabType=$p(tabData,"^",5)
			set typeDesc=##class(BILL.CFG.COM.GroupAuth).GetTabTitle(tabType)
			do OutputTabs
		}
	} 
	quit $$$OK
OutputTabs
	set data=$lb(rowId,id,title,href,active,tabType,typeDesc)
	set ^CacheTemp(repid,ind)=data
	set ind=$i(ind)
	quit
}

/// Debug: w ##class(web.DHCBillTabs).SaveTabs("","")
ClassMethod SaveTabs(rowId As %String, tabInfo As %String) As %String
{
	set $zt="ERROR"
	set tabId=$p(tabInfo,$c(3),1)
	set tabTitle=$p(tabInfo,$c(3),2)
	set tabHref=$p(tabInfo,$c(3),3)
	set activeFlag=$p(tabInfo,$c(3),4)
	set type=$p(tabInfo,$c(3),5)

	quit:(tabId="") -1_"^"_"id为空"
	quit:(tabTitle="") -1_"^"_"title为空"
	quit:(activeFlag="") -1_"^"_"启用状态为空"
	quit:(type="") -1_"^"_"业务类型为空"

	set id=$o(^DHCBILLTABSi(0,"TABID",tabId,0))
	quit:((+id'=0)&&(+id'=+rowId)) -1_"^"_"id重复"   //判断是否重复
	
	ts
	
	if (+rowId'=0) {
		set obj=##class(User.DHCBillTabs).%OpenId(rowId, 0)
	}else {
		set obj=##class(User.DHCBillTabs).%New()
	}
	set obj.BTTabID=tabId
	set obj.BTTabTitle=tabTitle
	set obj.BTTabUrl=tabHref
	set obj.BTActiveFlag=activeFlag
	set obj.BTBusinessType=type
	set sc=obj.%Save()
	if $$$ISERR(sc) {
		tro
		quit $System.Status.GetErrorCodes(sc)_"^"_$system.Status.GetOneErrorText(sc)
	}
	if ($tl>0) tc
	
	quit 0
ERROR
	quit ..AppException()
}

}
