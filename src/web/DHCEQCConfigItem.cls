Import SQLUser

Class web.DHCEQCConfigItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 5;

// 设备配置项目

Parameter SQLCODE = "CI_ValueUnit";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CI_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "CI_RowID";

Parameter SQLFILTER = " (CI_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CI_Desc,
	   CI_RowID,
	   CI_Code
FROM sqluser.DHC_EQCConfigItem
where CI_InvalidFlag = 'N' and CI_Desc like nvl(:para,'')||'%'
}

ClassMethod ConfigItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConfigItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ConfigItemExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetConfigItem
	Quit $$$OK
BuildDataGetConfigItem
	f  s rowid=$o(^DHCEQCCode("DHCEQCConfigItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetConfigItem
	.s LRowID = rowid	//rowid
	.s LCode=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",1) //代码
	.s LDesc=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",2) //描述
	.s LRemark=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",3) //备注
	.s ConfigItemCat=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",4) //配置类型分类
	.i ConfigItemCat'="" s LConfigItemCat=$p($g(^DHCEQCCode("DHCEQCConfigItemCat",ConfigItemCat)),"^",2)
	.s LValueUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",5))	// MZY0061	1610237		2020-12-2	单位
	.s LInvalidFlag=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",6) //无效标志
	.q:(LInvalidFlag="Y")
	.d OutputRowGetConfigItem
	quit
OutputRowGetConfigItem
    s Data=$lb(LRowID,LCode,LDesc,LRemark,LConfigItemCat,LValueUnit,LInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetConfigItem
	s (LRowID,LCode,LDesc,LRemark,LConfigItemCat,LValueUnit,LInvalidFlag)=""
	quit
}

ClassMethod ConfigItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConfigItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ConfigItem() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TConfigItemCat:%String,TValueUnit:%String,TInvalidFlag:%String,TRow:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
	
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	s PLIST(7)="Y"
 	 &SQL(Update SQLUSER.DHC_EQCConfigItem Values :PLIST() where CI_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 } 
 s PLIST(2) = $p(val,"^",2)	;代码
 s PLIST(3) = $p(val,"^",3)	;描述
 s PLIST(4) = $p(val,"^",4)	;备注
 s PLIST(5) = $p(val,"^",5)	;配置类型分类
 s PLIST(6) = $p(val,"^",6)	;单位
 // &SQL(select CI_RowID into :Rowid from DHC_EQCConfigItem ) //where UOM_UOMDR=:UOMDR and UOM_UOMType=:UOMType)
 	//if (Rowid="")
 	//{
 i (+isDel=2)
 {
	 s PLIST(7)="N"
 	&SQL(Insert Into SQLUSER.DHC_EQCConfigItem Values :PLIST())
 } 
 if (rowid'="") 
 {
	 s PLIST(7)="N"
 	 &SQL(Update SQLUSER.DHC_EQCConfigItem Values :PLIST() where CI_RowID = :rowid) 	 
 }
 //}
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCConfigItem",rowid)
	s resultex=rowid_"^"	//代码
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",1) //代码
	s resultex=resultex_"^"	//描述
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",2) //描述
	s resultex=resultex_"^"	//备注
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",3) //备注
	s resultex=resultex_"^"	//配置类型分类
	i $p(result,"^",4)'=""  d
	.s ConfigItemCat=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",4)
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItemCat",ConfigItemCat)),"^",2) //配置类型分类
	s resultex=resultex_"^"	//单位
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))	// MZY0061	1610237		2020-12-2	单位
	s resultex=resultex_"^"	//代码
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",4) //代码
	// MZY0061	1610237		2020-12-2
	s resultex=resultex_"^"	//单位DR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",5) //单位DR
	
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

ClassMethod ConfigItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConfigItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ConfigItemCatExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetConfigItemCat
	Quit $$$OK
BuildDataGetConfigItemCat
	f  s rowid=$o(^DHCEQCCode("DHCEQCConfigItemCat",rowid))  quit:rowid=""  d
	.d ResetVariablesGetConfigItemCat
	.s LRowID = rowid	//rowid
	.s LDesc=$p($g(^DHCEQCCode("DHCEQCConfigItemCat",rowid)),"^",2)
	.q:$p($g(^DHCEQCCode("DHCEQCConfigItemCat",rowid)),"^",4)="Y"  //QW0006-20150928
	.q:(LDesc'[Desc)
	.d OutputRowGetConfigItemCat
	quit
OutputRowGetConfigItemCat
   s Data=$lb(LDesc,LRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfigItemCat
	s (LDesc,LRowID)=""
	quit
}

ClassMethod ConfigItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConfigItemCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query ConfigItemCat(Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String:描述,Hidden:%String")
{
}

}
