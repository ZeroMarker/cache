/// This is a class used as a place holder for queries used to store and retrieve 
/// specific data from the websys.Preferences class
/// eg. order favourites, appointments, etc
Class epr.PreferencesQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Make sure you change the components and respective javascripts to reflect any changes, check notes on components for fields that use these delims.
/// OEOrder.PrefTabs.EditList
/// OEOrder.PrefTabs.Edit
/// d ##Class(epr.PreferencesQuery).GetOEPrefDelims(.itemdataDelim,.groupitemDelim,.tabgroupDelim,.preflistDelim)
ClassMethod GetOEPrefDelims(ByRef itemdataDelim As %Library.String = "", ByRef groupitemDelim As %Library.Integer = "", ByRef tabgroupDelim As %Library.Boolean = "", ByRef preflistDelim As %Library.Binary = "")
{
}

/// retrieves details used for order entry preferences and preferences setup.
/// zhouzq 生成界面需要的%request属性值
/// d ##Class(epr.PreferencesQuery).GetOEPrefTabs()
/// w ##class(websys.Preferences).GetDataExPlus(208,100,"DHCHEALTH",8, "W50008",.app, "ORDER","OEOrder.PrefTabs.EditList", .activecontext, "2", "")
/// select * from websys.Preferences where appsubkey='OEOrder.PrefTabs.EditList' and (ObjectReference=8 or ObjectReference=208 or ObjectReference=100 or ObjectReference='DHCHEALTH')
ClassMethod GetOEPrefTabs(CONTEXT As %Library.String = "")
{
}

/// retrieves name set for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
ClassMethod GetOETabGroupName(TABITEMS As %Library.String = "", groupno As %Library.Integer = 0) As %Library.String
{
}

/// DrawOrderPrefTabs is like a broker method
ClassMethod DrawOrderPrefTabs(FocusWindowName As %String = "", CONTEXT As %String = "") As %String
{
}

/// DrawOrderPrefTabItems is like a broker method
ClassMethod DrawOrderPrefTabItems(TABIDX As %String = "", FocusWindowName As %String = "", EpisodeID As %String = "", CTLOC As %String = "", formulary As %String = "", CONTEXT As %String = "") As %String
{
}

ClassMethod FindOETabItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOETabItemsFetch ]
{
}

ClassMethod FindOETabItemsExecute(ByRef QHandle As %Library.Binary, TABITEMS As %Library.String = "", groupno As %Library.Integer = 0, getDetails As %Library.Boolean = 0, SSGroupID As %Library.String = "", EpisodeID As %Library.String = "", formulary As %Library.String = "") As %Library.Status
{
}

ClassMethod FindOETabItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOETabItemsExecute ]
{
}

ClassMethod FindOETabListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOETabListFetch ]
{
}

/// d ##class(%ResultSet).RunQuery("epr.PreferencesQuery","FindOETabList")
ClassMethod FindOETabListExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindOETabListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOETabListExecute ]
{
}

/// brings back each item for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
/// accepts a boolean 'getDetails' to determine whether to fetch extra details against ecah item.
/// getDetails = 0 (default) for preferences setup.
/// getDetails = 1 in order entry screen (oeorder.entry.redrawprefs.csp)
Query FindOETabItems(TABITEMS As %Library.String, groupno As %Library.Integer, getDetails As %Library.Boolean, SSGroupID As %Library.String, EpisodeID As %Library.String, formulary As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc,hasdefault")
{
}

/// used in order entry preferences list
/// brings back each tab in the order favourites/preferences list
Query FindOETabList() As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

ClassMethod websysDeleteOETabs(compref As %Library.String = "")
{
}

/// Saves favourite orders into websys.Preferences
/// data=$lb(chart,chartframesize,tablist)
/// where chart=%String,chartframesize=%String, tablist=$lb(tab1,tab2,...,tabX)
/// where tabX=tabname_tabgroupDelim_grp1_tabgroupDelim_grp2_tabgroupDelim_..._tabgroupDelim_grp5_category_tabgroupDelim_subcategory
/// where tabname=%String,category=%String(id of OECOrderCategory),subcategory=%String(id of ARCItemCat)
/// and grpX=grpname_groupitemDelim_item1_groupitemDelim_item2_groupitemDelim_..._groupitemDelim_itemX
/// where grpname=%String and itemX=type_itemdataDelim_itemid
/// where type="ARCIM" or "ARCOS" and itemid=rowid of ARCItmMast or rowid of ARCOrdSet
/// tabgroupDelim,groupitemDelim,itemdataDelim defined in GetOrderEntryDelims
ClassMethod websysSaveOETabs(compref As %Library.String = "", id As %Library.String = "")
{
}

/// used in order entry from 'AddToFav' link to update selected items to the first group of the user's preferences
/// 原版医嘱录入界面(UDHCOEOrder.List.Custom)中用于AddToFav操作增加医嘱到模板中
ClassMethod websysSaveOETabsUserAdd()
{
}

/// creator:郭荣勇
/// date:2014-08-07
/// desc:根据登录科室得到医嘱模版类型标识,用于区分门,急,住院的医嘱个人模版
/// input:登录科室ID
/// output:个人医嘱模版类型
ClassMethod GetPrefTypeByLoc(LogonLoc As %String) As %String
{
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
}

ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "医嘱名称:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,子类:%String,价格:%String,基本药物:%String,计价单位:%String,库存数:%String,打包数:%String,通用名:%String,在途数:%String,收费规定:%String,医保类别:%String,自付比例:%String,接收科室:%String,代码:%String")
{
}

/// 修改模板
ClassMethod PrefEditItem(EditType As %String, objectType As %String, CONTEXT As %String, SelectPosition As %String, OldOrderType As %String, OldItemID As %String, NewOrderType As %String, NewItemID As %String) As %String
{
}

}
