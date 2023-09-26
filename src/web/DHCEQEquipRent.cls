/// 创建:zy 2010-07-22  No ZY0024
/// ----------------------------------
Class web.DHCEQEquipRent Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zy 2010-07-22  No ZY0024
/// 描述:设备租赁定义
/// ----------------------------------
Query EquipRent(SourceTypeDR As %String = "", SourceIDDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TName:%String,TModel:%String,TModelDR:%String,TMode:%String,TUOM:%String,TUOMDR:%String,TPrice:%String,TNo:%String,TFileNo:%String,TLeaveFactoryNo:%String,TRow:%String,TWorkLoadUOMDR:%String,TWorkLoadUOM:%String")
{
}

ClassMethod EquipRentExecute(ByRef qHandle As %Binary, SourceTypeDR As %String = "", SourceIDDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetEquipRent
	Quit $$$OK
BuildDataGetEquipRent
	f  s rowid=$o(^DHCEQEquipRent(rowid))  quit:rowid=""  d
	.d ResetVariablesGetEquipRent
	.s TRowID = rowid										//rowid
	.s TSourceType=$p($g(^DHCEQEquipRent(rowid)),"^",1) 	//代码
	.q:(TSourceType'=SourceTypeDR)&(SourceTypeDR'="")
	.i TSourceType'="" s TSourceType=$CASE(TSourceType,"1":"设备","2":"设备项")
	.s TSourceID=$p($g(^DHCEQEquipRent(rowid)),"^",2) 		//描述
	.q:(TSourceID'=SourceIDDR)&(SourceIDDR'="")
	.i (TSourceID'="")&($p($g(^DHCEQEquipRent(rowid)),"^",1)=2) s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.i (TSourceID'="")&($p($g(^DHCEQEquipRent(rowid)),"^",1)=1) d
	..s TName=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	..s TName=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	..s TNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)     //add by HHM 2015-12-23 添加设备编号显示，区分设备、设备项相同的情况
	..s TFileNo=$p($g(^DHCEQEquip(TSourceID)),"^",85)  //add by HHM 2015-12-23 档案号
	..s TLeaveFactoryNo=$p($g(^DHCEQEquip(TSourceID)),"^",10)  //add by HHM 2015-12-23  出厂编号
	.s TModelDR=$p($g(^DHCEQEquipRent(rowid)),"^",3) 	//
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TMode=$p($g(^DHCEQEquipRent(rowid)),"^",4) 	//代码
	.i TMode'="" s TMode=$CASE(TMode,"1":"租赁时长","2":"工作量")
	.s TUOMDR=$p($g(^DHCEQEquipRent(rowid)),"^",5) 	//
	.i TUOMDR'="" s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
	.s TWorkLoadUOMDR=$p($g(^DHCEQEquipRent(rowid)),"^",10) 	//add by wy 2017-8-18
	.i TWorkLoadUOMDR'="" s TWorkLoadUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUOMDR)
	.s TPrice=$p($g(^DHCEQEquipRent(rowid)),"^",6) 			
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice)			//add by HHM 2015-12-24 价格
	.d OutputRowGetEquipRent
	quit
OutputRowGetEquipRent
	s TRow=index     //add by HHM 2015-12-24 序号
    s Data=$lb(TRowID,TSourceType,TSourceID,TName,TModel,TModelDR,TMode,TUOM,TUOMDR,TPrice,TNo,TFileNo,TLeaveFactoryNo,TRow,TWorkLoadUOMDR,TWorkLoadUOM)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipRent
	s (TRowID,TSourceType,TSourceID,TName,TModel,TModelDR,TMode,TUOM,TUOMDR,TPrice,TNo,TFileNo,TLeaveFactoryNo,TRow,TWorkLoadUOMDR,TWorkLoadUOM)=""
	quit
}

ClassMethod EquipRentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipRentExecute ]
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

ClassMethod EquipRentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipRentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 2010-8-20 Adjust By JDL
/// ----------------------------------
/// 添加:zy 2010-07-20   No ZY0024
/// 描述:增删改
/// w ##Class(web.DHCEQEquipRent).SaveData("^2^40^^1^^^","0")
ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	k PLIST,rowid
	s flag=""
 	s rowid=$p(val,"^",1)
 	w rowid
 	Set $ZT="ERROR"
 	TSTART
 	if (+isDel=1)
 	{
 		&SQL(Delete From SQLUSER.DHC_EQEquipRent where ER_RowID = :rowid)
 	}
 	elseif (+isDel=0)
 	{
 		s PLIST(2) = $p(val,"^",2)	;SourceType
 		s SourceType= $p(val,"^",2)
 		s PLIST(3) = $p(val,"^",3)	;SourceID
 		s SourceID= $p(val,"^",3)
 		s PLIST(4) = $p(val,"^",4) ;Modeldr
 		s PLIST(5) = $p(val,"^",5)	;mode
 		s PLIST(6) = $p(val,"^",6)  //uomdr
		s PLIST(7) = $p(val,"^",7)  //price
		s PLIST(11) = $p(val,"^",8)  ////add by wy 2017-8-18 WorkloadUOMDR
	
		;检测是否重复 SourceType,SourceID,Model
		s ERRowID=0
		s Flag=0
		f  s ERRowID=$o(^DHCEQEquipRent(0,"SourceID",SourceType,SourceID,ERRowID))  quit:(ERRowID="")  d
		.i (SourceType=1)&&(ERRowID'=rowid) s Flag=1
		.;机型也一致,且非修改原数据,则为重复数据,不能修改
		.i ($p(val,"^",4)=$p($g(^DHCEQEquipRent(ERRowID)),"^",3))&&(ERRowID'=rowid) s Flag=1
		i Flag=1 q "重复记录"
		i (rowid="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQEquipRent Values :PLIST())
		} 
		else
		{
			&SQL(Update SQLUSER.DHC_EQEquipRent Values :PLIST() where ER_RowID = :rowid) 	 
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	Set ID=$g(%ROWID)
 	q ID
ERROR
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 添加:zy 2010-07-20  No ZY0024
/// 描述:增删改
ClassMethod GetDataByID(rowid As %Library.String = "")
{
	
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQEquipRent(rowid)
	s resultex=resultex_"^"	
	i $p(result,"^",2)'=""  d  //spurceid
	.s Desc=""
	.i $p(result,"^",1)'=""  d
	.i $p(result,"^",1)=2 d
	..s Desc=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",2))),"^",1)
	.e  i $p(result,"^",1)=1 d
	..s Desc=$p($g(^DHCEQEquip($p(result,"^",2))),"^",1)
	.s resultex=resultex_Desc //描述
	s resultex=resultex_"^"	
	i $p(result,"^",3)'=""  d  //model
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	//7
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5)) //单位代码
	s resultex=resultex_"^"
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",10)) ////add by wy 2017-8-18工作量单位
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_"^"_resultex
}

ClassMethod GetSourceType(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") ;add by csj 20180929 Hisui下拉列表改造
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"  //add by lmm 2017-07-28 417679
	w "<option value=2>设备项</option>"
	w "<option value=1>设备</option>"
	w "</select>",!
}

ClassMethod GetMode(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") ;add by csj 20180929 Hisui下拉列表改造
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>租赁时长</option>"
	w "<option value=2>工作量</option>"
	w "</select>",!
}

/// ----------------------------------
/// 添加:zy 2010-07-20  No ZY0024
/// 描述:根据设备项和库房取可以租赁的设备
/// d ##Class(%ResultSet).RunQuery("web.DHCEQEquipRent","GetEquipRentByItem","","")
Query GetEquipRentByItem(Desc As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,hidden:%String,TModel:%String:型号,hidden:%String")
{
}

ClassMethod GetEquipRentByItemExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	;q $$$OK
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i StoreLocDR="" q $$$OK

	;判断是否为租赁中心
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q $$$OK
	s itemid=0
	f  s itemid=$o(^DHCEQEquipRent(0,"SourceID",2,itemid))  quit:itemid=""  d
	.d ResetVariablesEquipRent
	.s TRowID = itemid
	.s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",1)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",2)
	.q:((Desc'="")&&(($ZCONVERT(TName,"U"))'[Desc))&&((Desc'="")&&(($ZCONVERT(TCode,"U"))'[Desc))
	.s ERRowID=0
	.f  s ERRowID=$o(^DHCEQEquipRent(0,"SourceID",2,itemid,ERRowID))  quit:(ERRowID="")  d
	..s TModelDR=$p($g(^DHCEQEquipRent(ERRowID)),"^",3)
	..s flag=0
	..s equipdr=0
	..f  s equipdr=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR,itemid,equipdr)) q:(equipdr="")||(flag=1)  d
	...;只取非报废和其他的
	...q:$p(^DHCEQEquip(equipdr),"^",38)>2	
	...;只取在库的
	...q:($p(^DHCEQEquip(equipdr),"^",60)<1)||($p(^DHCEQEquip(equipdr),"^",60)>2)
	...;判断机型是否匹配
	...i (TModelDR="")||(TModelDR=$p($g(^DHCEQEquip(equipdr)),"^",3)) s flag=1
	..
	..q:flag'=1
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..d OutputRowEquipRent
	Quit $$$OK
OutputRowEquipRent
	s Data=$lb(TName,TRowID,TModel,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipRent
	s (TRowID,TName,TModel,TModelDR,TCode,TItemDR,flag)=""
	quit
}

ClassMethod GetEquipRentByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRentByItemExecute ]
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

ClassMethod GetEquipRentByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRentByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// ----------------------------------
/// 添加:zy 2010-07-20  No ZY0024
/// 描述:根据库房取可以租赁的设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquipRent","GetEquipRentByEquip","",572)
Query GetEquipRentByEquip(Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", CurRowID As %String = "", ActionCode As %String = "") As %Query(ROWSPEC = "TName:%String:名称,hidden:%String,TNo:%String:入库明细,TModel:%String:型号,hidden:%String,TStoreLoc:%String:设备库房,hidden:%String,hidden:%String,hidden:%String,TFileNo:%String:档案号")
{
}

ClassMethod GetEquipRentByEquipExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", CurRowID As %String = "", ActionCode As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i StoreLocDR="" q $$$OK
	;判断是否为租赁中心
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q $$$OK

	s TStoreLocDR=StoreLocDR
	s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s equipdr=0
	f  s equipdr=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,equipdr)) q:equipdr=""  d
	.;过滤无效掉设备
	.q:$p(^DHCEQEquip(equipdr),"^",59)="Y"
	.;只取非报废和其他的
	.q:$p(^DHCEQEquip(equipdr),"^",38)>2
	.;只取在库的
	.q:($p(^DHCEQEquip(equipdr),"^",60)<1)||($p(^DHCEQEquip(equipdr),"^",60)>2)
	.;过滤掉未定义租赁信息的
	.q:..GetEquipRentInfo(equipdr)=""
	.;过滤掉已经租赁过还未归还的设备
	.q:..GetEquipUsedInfo(equipdr,CurRowID,ActionCode)=1
	.;过滤在修设备
	.q:..GetEquipMaintInfo(equipdr)=1		//Add By DJ 2016-04-28
	.d ResetVariablesRentEquip
	.s TRowID = equipdr
	.s TName=$p($g(^DHCEQEquip(equipdr)),"^",1)
	.s TModelDR= $p($g(^DHCEQEquip(equipdr)),"^",3)
	.q:(ModelDR'="")&&(TModelDR'=ModelDR)
	.s TCode=$p($g(^DHCEQEquip(equipdr)),"^",6)
	.s TNo= $p($g(^DHCEQEquip(equipdr)),"^",71)
	.s TItemDR= $p($g(^DHCEQEquip(equipdr)),"^",7)
	.s TFileNo= $p($g(^DHCEQEquip(equipdr)),"^",85)
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.q:(Desc'="")&($ZCONVERT(TName,"U")'[Desc)&($ZCONVERT(TCode,"U")'[Desc)&($ZCONVERT(TNo,"U")'[Desc)&($ZCONVERT(TFileNo,"U")'[Desc)
	.
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.i TItemDR'="" s TItem= $p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.d OutputRowRentEquip
	
	Quit $$$OK
	
OutputRowRentEquip
    s Data=$lb(TName,TRowID,TNo,TModel,TModelDR,TStoreLoc,TStoreLocDR,TItem,TItemDR,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesRentEquip
	s (TRowID,TName,TModel,TModelDR,TNo,TItem,TItemDR,TCode,flag,TFileNo)=""
	quit
}

ClassMethod GetEquipRentByEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRentByEquipExecute ]
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

ClassMethod GetEquipRentByEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRentByEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 描述:取租赁设备的价格定义信息
/// 入参：EquipDR
/// 返回：未找到对应的租赁价格定义,则返回""
/// 	  否则返回相应信息	EquipRentID^price^uom
/// w ##Class(web.DHCEQEquipRent).GetEquipRentInfo("1")
ClassMethod GetEquipRentInfo(EquipDR)
{
	n EquipRentID,Item,Model,ERRowID,Flag	
	i EquipDR="" q ""
	;取设备定义的租赁价格
	s EquipRentID=$o(^DHCEQEquipRent(0,"SourceID",1,EquipDR,0))
	;如果未定义,则取设备项上的定义
	i EquipRentID=""  d
	.s Item=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	.s Model= $p($g(^DHCEQEquip(EquipDR)),"^",3)
	.q:Item=""
	.s ERRowID=0
	.s Flag=0
	.f  s ERRowID=$o(^DHCEQEquipRent(0,"SourceID",2,Item,ERRowID))  quit:((ERRowID="")||(Flag=1))  d
	..i $p($g(^DHCEQEquipRent(ERRowID)),"^",3)=Model  d
	...s EquipRentID=ERRowID
	...s Flag=1
	..e  d
	...i ($p($g(^DHCEQEquipRent(ERRowID)),"^",3)="") s EquipRentID=ERRowID
	i EquipRentID="" q ""
	q EquipRentID_"^"_$p($g(^DHCEQEquipRent(EquipRentID)),"^",6)_"^"_$p($g(^DHCEQEquipRent(EquipRentID)),"^",5)
}

/// add by GBX 2015-7-15 11:12:08
/// 描述:过滤掉已经租赁还未还回的设备
/// 入参:EquipDR
/// 返回：被占用返回1 否则返回0
/// w ##Class(web.DHCEQEquipRent).GetEquipUsedInfo("11728")
ClassMethod GetEquipUsedInfo(EquipDR, vRowID, vActionCode)
{
	if EquipDR="" q ""
	s Flag=0
	s Status=""
	f  s Status=$o(^DHCEQRent(0,"Status",Status)) q:(Status="")||(Flag'=0)  d
	.q:Status=3
	.s RentID=0
	.f  s RentID=$o(^DHCEQRent(0,"Status",Status,RentID)) q:(RentID="")||(Flag'=0)  d
	..s EquipID=$p($g(^DHCEQRent(RentID)),"^",9)
	..q:EquipID=""
	..i EquipDR=EquipID  d
	...s Flag=1
	...i RentID=vRowID s Flag=0
	...i ((vActionCode="ZL_Loan")&&(Status<2)) s Flag=0
	/*
	s MMaintRequestID=0
	f  s MMaintRequestID=$o(^DHCEQMMaintRequest(MMaintRequestID)) q:MMaintRequestID=""  d
	.s Status=$p($g(^DHCEQMMaintRequest(MMaintRequestID)),"^",41)
	.s ObjDR=$p($g(^DHCEQMMaintRequest(MMaintRequestID)),"^",5)
	.q:(Status'=2)
	.q:(ObjDR'=EquipDR)
	.s Flag=1
	*/
	
	q Flag
}

ClassMethod GetShortEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 282913 Add by BRB 2016-11-14 增加按照设备定价显示单位的方法
ClassMethod GetShortEquipExecute(ByRef qHandle As %Binary, Equip As %String, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid
 	new passed
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Equip=##class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip,"U")
	i ((vNeedUseLoc=1)&&(vUseLoc="")) Quit $$$OK
	s LocTypeDR=""
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	d BuildDataGetShortEquip
	Quit $$$OK
BuildDataGetShortEquip
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetShortEquip
	.s RowID = rowid
	.d CheckDataGetShortEquip
	.q:passed=0
	.;s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	.s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	.q:'$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) 
	.s ABCType = $p($g(^DHCEQEquip(rowid)),"^",2)
	.s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	.i ModelDR '=""  d
	..s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	.s EquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	.i EquiCatDR '=""  d
	..s EquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	.s UnitDR = $p($g(^DHCEQEquip(rowid)),"^",5)
	.i UnitDR '=""  d
	..s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.;s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	.;s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	.s InstallLocDR = $p($g(^DHCEQEquip(rowid)),"^",8)
	.i InstallLocDR '=""  d
	..s InstallLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",InstallLocDR)
	.s InstallDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",9),"date")
	.;s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	.s LeaveFactoryDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",11),"date")
	.s OpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",12),"date")
	.s CheckDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",13),"date")
	.s MakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",14),"date")
	.s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)
	.s CountryDR = $p($g(^DHCEQEquip(rowid)),"^",16)
	.i CountryDR '=""  d
	..s Country =##class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
	.s ManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	.i ManageLocDR '=""  d
	..s ManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) ; ##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR)	
	.s ManageLevelDR = $p($g(^DHCEQEquip(rowid)),"^",18)
	.i ManageLevelDR '=""  d
	..s ManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	.//s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	.i UseLocDR '=""  d
	..s UseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.s OriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	.i OriginDR '=""  d
	..s Origin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	.s FromDeptDR = $p($g(^DHCEQEquip(rowid)),"^",21)
	.i FromDeptDR '=""  d
	..s FromDept = ##class(web.DHCEQCommon).GetTrakNameByID("dept",FromDeptDR)
	.s ToDeptDR = $p($g(^DHCEQEquip(rowid)),"^",22)
	.i ToDeptDR '=""  d
	..s ToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",ToDeptDR)),"^",2)
	.s BuyTypeDR = $p($g(^DHCEQEquip(rowid)),"^",23)
	.i BuyTypeDR '=""  d
	..s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeDR)),"^",2)
	.s EquipTechLevelDR  = $p($g(^DHCEQEquip(rowid)),"^",24)
	.s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	.i ProviderDR '=""  d
	..s Provider =##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	.s ManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	.i ManuFactoryDR '=""  d
	..s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //CZF0093
	.s OriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	.s NetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	.s NetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	.s GroupDR = $p($g(^DHCEQEquip(rowid)),"^",30)
	.i GroupDR '=""  d
	..s Group = $p($g(^DHCEQGroup(GroupDR)),"^",2)
	.s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	.s ContractListDR = $p($g(^DHCEQEquip(rowid)),"^",32)
	.i ContractListDR '=""  d
	..s ContractList = $p($g(^DHCEQContractList(ContractListDR)),"^",1)
	.s DepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	.i DepreMethodDR '=""  d
	..s DepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	.s Remark = $p($g(^DHCEQEquip(rowid)),"^",34)
	.s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	.s DesignWorkLoadNum = $p($g(^DHCEQEquip(rowid)),"^",36)
	.s WorkLoadUnitDR = $p($g(^DHCEQEquip(rowid)),"^",37)
	.i WorkLoadUnitDR '=""  d
	..s WorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUnitDR)
	.s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	.s ManageUserDR = $p($g(^DHCEQEquip(rowid)),"^",39)
	.i ManageUserDR '=""  d
	..s ManageUser =##class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)
	.s MaintUserDR = $p($g(^DHCEQEquip(rowid)),"^",40)
	.i MaintUserDR '=""  d
	..s MaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",MaintUserDR)
	.s ContactUser = $p($g(^DHCEQEquip(rowid)),"^",41)
	.s ContactMode = $p($g(^DHCEQEquip(rowid)),"^",42)
	.s AppendFeeTotalFee = $p($g(^DHCEQEquip(rowid)),"^",43)
	.s StartDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",44),"date")
	.s TransAssetDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	.s GuaranteeFlag = $p($g(^DHCEQEquip(rowid)),"^",46)
	.s InputFlag = $p($g(^DHCEQEquip(rowid)),"^",47)
	.s TestFlag = $p($g(^DHCEQEquip(rowid)),"^",48)
	.s MedicalFlag = $p($g(^DHCEQEquip(rowid)),"^",49)
	.s GuaranteeStartDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",50),"date")
	.s GuaranteeEndDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",51),"date")
	.s AddUserDR = $p($g(^DHCEQEquip(rowid)),"^",52)
	.i AddUserDR '=""  d
	..s AddUser =##class(web.DHCEQCommon).GetTrakNameByID("user",AddUserDR)
	.s AddDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",53),"date")
	.s AddTime = $p($g(^DHCEQEquip(rowid)),"^",54)
	.s UpdateUserDR = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",55),"date")
	.i UpdateUserDR '=""  d
	..s UpdateUser =##class(web.DHCEQCommon).GetTrakNameByID("user",UpdateUserDR)
	.s UpdateDate =##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",56),"date")
	.s UpdateTime = $p($g(^DHCEQEquip(rowid)),"^",57)
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.;s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	.s KeeperDR = $p($g(^DHCEQEquip(rowid)),"^",66)
	.i KeeperDR '=""  d
	..s Keeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",KeeperDR)
	.i StoreLocDR '=""  d
	..s StoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s StartDepreMonth = $p($g(^DHCEQEquip(rowid)),"^",68)
	.s ServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	.i ServiceDR '=""  d
	..s Service = $p($g(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1)
	.s InStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	.i InStockListDR '=""  d
	..s InStockList = $p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	.;s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	.s ServiceHandler = $p($g(^DHCEQEquip(rowid)),"^",72)
	.s ServiceTel = $p($g(^DHCEQEquip(rowid)),"^",73)
	.s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.i StatCatDR'="" d
	..s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	.d OutputRowGetShortEquip
	quit
OutputRowGetShortEquip
	s Data=$lb(Name,RowID,UseLoc,No,LeaveFactoryNo,UseLocDR,ModelDR,Model,UnitDR,Unit) //282854 Modify By BRB 2016-11-14增加单位
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortEquip
	s (Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser)=""
	quit
CheckDataGetShortEquip
	s passed=1
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag'="N" s passed=0	// Mozy0072		2011-12-07
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	//新增:2009-12-02 党军 begin DJ0036
	;s BAFlag=$p($g(^DHCEQEquip(rowid)),"^",81)
	;i (vBAFlag'="")&&(BAFlag'=vBAFlag) s passed=0
	//2009-12-02 党军 end DJ0036
	//修改 2011-02-15 zy begin ZY0052
	i (vBAFlag="Y") d
	.s passed=##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	//2011-02-15 zy end ZY0052
	s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipType'="")&&("1"=##class(web.DHCEQCommon).EquipTypeIsIn(EquipType)) s passed=0
	s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	i (Equip'="")&&(($ZCONVERT(Name,"U")'[Equip)&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&(RowID'=Equip)&($ZCONVERT(MemoryCode,"U")'[Equip)&($ZCONVERT(No,"U")'[Equip)&($ZCONVERT(Code,"U")'[Equip))   d
	.s passed=0
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	///add by 2007-01-18
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	i ((Status="3")||(Status="4")) d //2010-12-29 DJ
	.s passed=0
	
	s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR'=""  d //2010-10-28 DJ
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR)))  d 
	..s passed=0
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	i (vUseLoc'="")
	{
		i ((Status="0")||(Status="2"))
			{	if (vUseLoc'=StoreLocDR) s passed=0}
		elseif  (vUseLoc'=UseLocDR) 
			{	s passed=0}
	}
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	s StockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i vStockStatuType="" d
	.i ((StockStatus="0")||(StockStatus="3")) s passed=0
	e  d
	.s Flag=##class(web.DHCEQBuyRequest).StringIsIn(vStockStatuType,StockStatus)
	.i Flag="N" s passed=0
	///end
	quit
}

ClassMethod GetShortEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortEquipExecute ]
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

/// NeedUseLoc，是否需要使用科室，0：不需要，当UseLoc为空时不限制科室  1：需要，未指定科室则查找不到数据
/// 2009-12-02 党军 DJ0036 增加vBAFlag参数
Query GetShortEquip(Equip, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "") As %Query(ROWSPEC = "Name:%String,HIDDEN:%String,UseLoc:%String,No:%String,LeaveFactoryNo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Unit:%String")
{
}

/// w ##class(%Library.ResultSet).RunQuery("web.DHCEQCMasterItem","GetMasterItem","","","")
Query GetMasterItem(EquipTypeDR, StatCatDR, Name) As %Query(ROWSPEC = "Name:%String,Hidden:%String,Code:%String,Hidden:%String,Cat:%String,Hidden:%String,Unit:%String,Hidden:%String,EquipType:%String,Hidden:%String,StatCat:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, EquipTypeDR, StatCatDR, Name) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;Modified by JDL 2011-6-15 JDL0083
	s Hospital=##Class(web.DHCEQCommon).GetHospital()

	i Hospital'=""
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	else
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	
	Quit $$$OK
	
BuildDataGetItem
	s TRowID = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	q:(StatCatDR'="")&&(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR'="" s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i TCatDR'="" d
	.s TCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TCatDR),"^",2)
	.s TLimitYearsNum=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)	;Modified by jdl 2012-3-7 JDL0120
	.s TDepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(TCatDR)
	.i TDepreMethodDR'="" d
	..s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	
	d OutputRowGetItem
	quit
OutputRowGetItem
	s Data=$lb(TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetItem
	s (TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc)=""
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取租赁中心所有设备
/// w ##class(web.DHCEQEquipRent).GetRentLocEquip()
ClassMethod GetRentLocEquip()
{
	s EquipRentInfo=""
	;s GNum=1
	k ^DHCEQTemp("RentEquip",0)
	s LocTypeDR=0
	f  s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",LocTypeDR)) q:LocTypeDR=""  d
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q:StoreLocDR=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,EquipID)) q:EquipID=""  d
	...s EquipType=$p($g(^DHCEQEquip(EquipID)),"^",63)
	...q:(EquipType'="")&&("1"=##class(web.DHCEQCommon).EquipTypeIsIn(EquipType))
	...q:$p(^DHCEQEquip(EquipID),"^",38)>2
	...;只取在库的
	...q:($p(^DHCEQEquip(EquipID),"^",60)<1)||($p(^DHCEQEquip(EquipID),"^",60)>2)
	...q:($p($g(^DHCEQEquip(EquipID)),"^",59)'="N")
	...q:(..IsInEquipRentInfo(EquipID)'=0)
	...;q:($p(^DHCEQEquip(EquipID),"^",1)'["呼吸机")
	...s ModelDR=""
	...s UOMDR=""
	...s ModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	...s UOMDR=$p($g(^DHCEQEquip(EquipID)),"^",5)
	...i EquipRentInfo'="" d
	....s EquipRentInfo=EquipRentInfo_"&"_"^1^"_EquipID_"^"_ModelDR_"^1^"_UOMDR_"^180"
	...e  d
	....s EquipRentInfo="^1^"_EquipID_"^"_ModelDR_"^1^"_UOMDR_"^180"
	...;s ^DHCEQTemp("RentEquip",0,$j,+$H,GNum)="^1^"_EquipID_"^"_ModelDR_"^1^"_UOMDR_"^100"
	...;s GNum=GNum+1
	
	q EquipRentInfo
}

ClassMethod GetRentEquipNum()
{
	q $g(^DHCEQTemp("RentEquip",0,$j,+$H,-1))
}

ClassMethod GetRentEquipInfo(GNum)
{
	q $g(^DHCEQTemp("RentEquip",0,$j,+$H,GNum))
}

ClassMethod IsInEquipRentInfo(EquipDR)
{
	s EquipRentID=$o(^DHCEQEquipRent(0,"SourceID",1,EquipDR,0))
	if EquipRentID=""  q "0"
	else  q "-1"
}

/// 按设备获取租赁中心所有设备
/// modify by GBX 2016-01-25
/// w ##class(web.DHCEQEquipRent).GetRentLocItem()
ClassMethod GetRentLocItem()
{
	s ItemRentInfo=""
	;s GNum=1
	k ^DHCEQTemp("RentEquipInfo",0,$j,+$H)
	s LocTypeDR=0
	f  s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",LocTypeDR)) q:LocTypeDR=""  d
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q:StoreLocDR=""  d
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,EquipID)) q:EquipID=""  d
	...s EquipType=$p($g(^DHCEQEquip(EquipID)),"^",63)
	...q:(EquipType'="")&&("1"=##class(web.DHCEQCommon).EquipTypeIsIn(EquipType))
	...q:$p(^DHCEQEquip(EquipID),"^",38)>2
	...;只取在库的
	...q:($p(^DHCEQEquip(EquipID),"^",60)<1)||($p(^DHCEQEquip(EquipID),"^",60)>2)
	...q:($p($g(^DHCEQEquip(EquipID)),"^",59)'="N")
	...s ModelDR=""
	...s UOMDR=""
	...s Item=""
	...s Item=$p($g(^DHCEQEquip(EquipID)),"^",7)
	...s ItemDesc=$p($g(^DHCEQCCode("DHCEQCMasterItem",Item)),"^",1)
	...;q:ItemDesc'["呼吸机"
	...q:(..IsInItemRentInfo(Item)'=0)
	...s ModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	...if ModelDR=""  d
	....s ModelDR="Model"
	...s UOMDR=$p($g(^DHCEQEquip(EquipID)),"^",5)
	...s ^DHCEQTemp("RentEquipInfo",0,$j,+$H,Item,ModelDR)=UOMDR  ;"^2^"_Item_"^"_ModelDR_"^1^"_UOMDR_"^100"

	s ItemID=0
	f  s ItemID=$o(^DHCEQTemp("RentEquipInfo",0,$j,+$H,ItemID)) q:(ItemID="")  d
	.s ModelID=0
	.f  s ModelDR=$o(^DHCEQTemp("RentEquipInfo",0,$j,+$H,ItemID,ModelID)) q:(ModelID="")  d
	..s UOMID=""
	..s UOMID=$g(^DHCEQTemp("RentEquipInfo",0,$j,+$H,ItemID,ModelID))
	..i ModelID="Model"  d
	...s ModelDR=""
	..s ModelID=ModelDR
	..i ItemRentInfo'="" d
	...s ItemRentInfo=ItemRentInfo_"&"_"^2^"_ItemID_"^"_ModelDR_"^1^"_UOMID_"^180"
	..e  d
	...s ItemRentInfo="^2^"_ItemID_"^"_ModelDR_"^1^"_UOMID_"^180"
	;k ^DHCEQTemp("RentEquipInfo",0,$j,+$H)
	
	q ItemRentInfo
}

ClassMethod IsInItemRentInfo(ItemDR)
{
	s EquipRentID=$o(^DHCEQEquipRent(0,"SourceID",2,ItemDR,0))
	if EquipRentID=""  q "0"
	else  q "-1"
}

// 附件多选选择

ClassMethod GetAffixsInfo(EquipDR)
{
	s infos=""
	s rowid=0
 	f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	.q:$p($g(^DHCEQAffix(rowid)),"^",15)'="N"
	.i infos'="" s infos=infos_"&"
	.s infos=infos_$p($g(^DHCEQAffix(rowid)),"^",4)_"^"_rowid
	
	q infos
}

/// Add By DJ 2016-04-28
/// 描述:获取设备是否在修状态
ClassMethod GetEquipMaintInfo(vEquipDR As %String = "")
{
	i vEquipDR="" q "0"
	s MRFlag=0
	s MRStatus=""
	f  s MRStatus=$o(^DHCEQMMaintRequest(0,"Status",MRStatus))  q:(MRStatus="")||(MRFlag'=0)  d
	.q:MRStatus>1
	.s MRRowID=0
	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Status",MRStatus,MRRowID))  q:(MRRowID="")||(MRFlag'=0)  d
	..s MRInvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
	..q:MRInvalidFlag="Y"
	..s MRSourceTypeDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",63)
	..q:MRSourceTypeDR'=1
	..s MRObjDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
	..i MRObjDR'="" d		//modified by csj 20190918	需求号：1014411
	...s EQRowID=$p($g(^DHCEQMExObj(MRObjDR)),"^",5)
	...i EQRowID=vEquipDR s MRFlag=1
	
	q MRFlag
}

/// mozy	2016-8-18
/// Flag=0可以显示
/// 需要加条件的地方加入q:(##Class(web.DHCEQEquipRent).CheckEquipIsInRent(7023))即可
ClassMethod CheckEquipIsInRent(EquipDR As %String = "")
{
	i EquipDR="" q "0"
	new ItemDR,Flag
	; ^DHCEQEquipRent(0,"SourceID",2,48,9) = "" 
	s Flag=1
	s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))		//Add By DJ 2016-12-01 begin
	i LGTRowID="" q 1
	s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,0))
	i LTRowID="" q 1		//Add By DJ 2016-12-01 end
	;i $p($g(^DHCEQEquip(EquipDR)),"^",67)'=LTRowID q 1	;非设备器材科
	s LTRowID=0
	f  s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LTRowID)) q:(LTRowID="")||(Flag'=1)  d
	.i $p($g(^DHCEQEquip(EquipDR)),"^",67)=LTRowID d
	..s Flag=0	
	i Flag=0 q 0
	
	i ..GetEquipRentInfo(EquipDR)="" q 1     ;租赁定价中未定义的设备    //Add by czf 364357
	
	i $d(^DHCEQEquipRent(0,"SourceID",1,EquipDR)) s Flag=0
	s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	i $d(^DHCEQEquipRent(0,"SourceID",2,ItemDR)) s Flag=0
	
	q Flag
}

/// 微信端设备弹出框
/// d ##class(%ResultSet).RunQuery("web.DHCEQEquipRent","GetEquipRentByEquipForWechat","","126")
Query GetEquipRentByEquipForWechat(Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", CurRowID As %String = "", ActionCode As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TNo:%String:入库明细,TModel:%String:型号,TModelDR:%String:机型,TStoreLoc:%String:设备库房,TStoreLocDR:%String:库房,TItem:%String:设备项,TItemDR:%String:设备项,TFileNo:%String:档案号")
{
}

ClassMethod GetEquipRentByEquipForWechatExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", CurRowID As %String = "", ActionCode As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i StoreLocDR="" q $$$OK
	;判断是否为租赁中心
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q $$$OK

	s TStoreLocDR=StoreLocDR
	s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s equipdr=0
	f  s equipdr=$o(^DHCEQEquip(0,"StoreLoc",StoreLocDR,equipdr)) q:equipdr=""  d
	.;过滤无效掉设备
	.q:$p(^DHCEQEquip(equipdr),"^",59)="Y"
	.;只取非报废和其他的
	.q:$p(^DHCEQEquip(equipdr),"^",38)>2
	.;只取在库的
	.q:($p(^DHCEQEquip(equipdr),"^",60)<1)||($p(^DHCEQEquip(equipdr),"^",60)>2)
	.;过滤掉未定义租赁信息的
	.q:..GetEquipRentInfo(equipdr)=""
	.;过滤掉已经租赁过还未归还的设备
	.q:..GetEquipUsedInfo(equipdr,CurRowID,ActionCode)=1
	.;过滤在修设备
	.q:..GetEquipMaintInfo(equipdr)=1		//Add By DJ 2016-04-28
	.d ResetVariablesRentEquipForWechat
	.s TRowID = equipdr
	.s TName=$p($g(^DHCEQEquip(equipdr)),"^",1)
	.s TModelDR= $p($g(^DHCEQEquip(equipdr)),"^",3)
	.q:(ModelDR'="")&&(TModelDR'=ModelDR)
	.s TCode=$p($g(^DHCEQEquip(equipdr)),"^",6)
	.s TNo= $p($g(^DHCEQEquip(equipdr)),"^",71)
	.s TItemDR= $p($g(^DHCEQEquip(equipdr)),"^",7)
	.s TFileNo= $p($g(^DHCEQEquip(equipdr)),"^",85)
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.q:(Desc'="")&($ZCONVERT(TName,"U")'[Desc)&($ZCONVERT(TCode,"U")'[Desc)&($ZCONVERT(TNo,"U")'[Desc)&($ZCONVERT(TFileNo,"U")'[Desc)
	.
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.i TItemDR'="" s TItem= $p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.d OutputRowRentEquipForWechat
	
	Quit $$$OK
	
OutputRowRentEquipForWechat
    s Data=$lb(TName,TRowID,TNo,TModel,TModelDR,TStoreLoc,TStoreLocDR,TItem,TItemDR,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesRentEquipForWechat
	s (TRowID,TName,TModel,TModelDR,TNo,TItem,TItemDR,TCode,flag,TFileNo)=""
	quit
}

ClassMethod GetEquipRentByEquipForWechatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRentByEquipForWechatExecute ]
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

ClassMethod GetEquipRentByEquipForWechatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRentByEquipForWechatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// ----------------------------------
/// 微信端设备项弹出框
/// d ##Class(%ResultSet).RunQuery("web.DHCEQEquipRent","GetEquipRentByItemForWechat","","126")
Query GetEquipRentByItemForWechat(Desc As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TModel:%String,TModelDR:%String")
{
}

ClassMethod GetEquipRentByItemForWechatExecute(ByRef qHandle As %Binary, Desc As %String = "", StoreLocDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	;q $$$OK
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	i StoreLocDR="" q $$$OK

	;判断是否为租赁中心
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q $$$OK
	s itemid=0
	f  s itemid=$o(^DHCEQEquipRent(0,"SourceID",2,itemid))  quit:itemid=""  d
	.d ResetVariablesEquipRentForWechat
	.s TRowID = itemid
	.s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",1)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",2)
	.q:((Desc'="")&&(($ZCONVERT(TName,"U"))'[Desc))&&((Desc'="")&&(($ZCONVERT(TCode,"U"))'[Desc))
	.s ERRowID=0
	.f  s ERRowID=$o(^DHCEQEquipRent(0,"SourceID",2,itemid,ERRowID))  quit:(ERRowID="")  d
	..s TModelDR=$p($g(^DHCEQEquipRent(ERRowID)),"^",3)
	..s flag=0
	..s equipdr=0
	..f  s equipdr=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR,itemid,equipdr)) q:(equipdr="")||(flag=1)  d
	...;只取非报废和其他的
	...q:$p(^DHCEQEquip(equipdr),"^",38)>2	
	...;只取在库的
	...q:($p(^DHCEQEquip(equipdr),"^",60)<1)||($p(^DHCEQEquip(equipdr),"^",60)>2)
	...;判断机型是否匹配
	...i (TModelDR="")||(TModelDR=$p($g(^DHCEQEquip(equipdr)),"^",3)) s flag=1
	..
	..q:flag'=1
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..d OutputRowEquipRentForWechat
	Quit $$$OK
OutputRowEquipRentForWechat
	s Data=$lb(TName,TRowID,TModel,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesEquipRentForWechat
	s (TRowID,TName,TModel,TModelDR,TCode,TItemDR,flag)=""
	quit
}

ClassMethod GetEquipRentByItemForWechatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipRentByItemForWechatExecute ]
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

ClassMethod GetEquipRentByItemForWechatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipRentByItemForWechatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

Storage Default
{
<Data name="DHCEQEquipRentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQEquipRentD</DataLocation>
<DefaultData>DHCEQEquipRentDefaultData</DefaultData>
<IdLocation>^web.DHCEQEquipRentD</IdLocation>
<IndexLocation>^web.DHCEQEquipRentI</IndexLocation>
<StreamLocation>^web.DHCEQEquipRentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
