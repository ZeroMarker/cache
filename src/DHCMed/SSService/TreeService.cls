/// 2018年12月3日
/// 用于hisui产品字典改造,为了解决原有的树参数跟目前的树参数查询不一致问题  
Class DHCMed.SSService.TreeService Extends %RegisteredObject
{

/// 查询字典树
/// Add By liuzhenhe 20118-12-03 生成字典树
/// D ##class(%ResultSet).RunQuery("DHCMed.SSService.TreeService","QryDictionaryTree","root-EPD")
Query QryDictionaryTree(aType As %String, aDesc As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String") [ SqlProc ]
{
}

ClassMethod QryDictionaryTreeExecute(ByRef qHandle As %Binary, aType As %String, aDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	set nodeType=$p(aType,"-",1)  //获得节点类型 ,以后借此判断
 	if (nodeType="root") {		
 		//节点类型为root,一级查询 
	 	set PorCode=$p(aType,"-",2)  //获得产品代码  在基础字典查询里这没有多少意义
	 	set rowid=""
	 	for {
		 	set rowid=$o(^DHCMed.SS.ProductsD(rowid))
		 	quit:rowid=""
		 	
		 	set objProduct=##class(DHCMed.SS.Products).%OpenId(rowid) //获取产品
		 	continue:'$IsObject(objProduct)      //如果产品不存在返回
		 	do objProduct.%Close()
		 	continue:objProduct.ProActive'=1     //如果产品无效返回
		 	if (PorCode'="")&&(PorCode'="SYS") {
			 	continue:PorCode'=objProduct.ProCode  //如果产品代码不一致,返回
			}
		 	set data=$lb("")
		 	set $li(data,1)="product-"_objProduct.ProCode
		 	set $li(data,2)=objProduct.ProName
		 	set iconFileName="menuconfig.gif"

		 	set $li(data,3)="../scripts/dhcmed/img/"_iconFileName
		 	set $li(data,4)="false"
		 	set $li(data,5)="closed"
		 	set $li(data,6)=""
		 	//0
		 	set ^CacheTemp(repid,ind)=data
		 	set ind=ind+1
		 }
	}
	
	if (nodeType="product") {
	 	set PorCode=$p(aType,"-",2)
	 	set xProCode=""
	 	for {
			set xProCode=$o(^DHCMed.SS.DictionaryI("ProductCodeIndex",xProCode))
			quit:xProCode=""
			continue:$zcvt(PorCode,"U")'=$e(xProCode,2,$l(xProCode))
			set rowid=""
			for {
				set rowid=$o(^DHCMed.SS.DictionaryI("ProductCodeIndex",xProCode," SYS",rowid))
			 	quit:rowid=""
			 	set objDic=##class(DHCMed.SS.Dictionary).%OpenId(rowid)
			 	continue:'$IsObject(objDic)
			 	do objDic.%Close()
			 	set data=$lb("")
			 	Continue:((aDesc'="")&&(objDic.Description'[aDesc))
			 	set $li(data,1)="dicType-"_objDic.Code_"-"_objDic.%Id()
			 	set $li(data,2)=objDic.Description
			 	set iconFileName="menudic.gif"
			 	set $li(data,3)="../scripts/dhcmed/img/"_iconFileName
			 	set $li(data,4)=""
			 	set $li(data,5)=""
			 	set $li(data,6)=""
			 	set ^CacheTemp(repid,ind)=data
			 	set ind=ind+1
		 	}
		 }		
	}
	
	Quit $$$OK
}

ClassMethod QryDictionaryTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDictionaryTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDictionaryTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDictionaryTreeExecute ]
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

}
