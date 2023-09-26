Class web.DHCEQ.BA.CTEquipService Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2019-09-06
/// 描述:根据科室，类组，金额段获取设备清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.CTEquipService","GetEquipList",327,,,"10000","")
Query GetEquipList(vLocDR As %String = "", vDesc As %String = "", vEquipTypeDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "") As %Query(ROWSPEC = "TEQRowID:%String,TItemDR:%String,TEQNo:%String,TEQName:%String,TModel:%String,TOriginalFee:%String,TEquipType:%String,TStoreLoc:%String,TStoreLocDR:%String") [ SqlProc ]
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vLocDR As %String = "", vDesc As %String = "", vEquipTypeDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i vFromOriginalFee="" Quit $$$OK
	
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR))  q:StoreLocDR=""  d
	.q:(vLocDR'="")&&(StoreLocDR'=vLocDR)
	.s EquipTypeDR=0
	.f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
	..q:(vEquipTypeDR'="")&&(vEquipTypeDR'=EquipTypeDR)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR)=1
	..s EQRowID=0
	..f  s EQRowID=$o(^DHCEQEquip(0,"StoreEquipType","N",1,StoreLocDR,EquipTypeDR,EQRowID))  q:EQRowID=""  d
	...s OriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27))
	...q:($o(^DHCEQBenefitEquipList(0,"Equip",EQRowID,0))="") //add by WY 2022-06-30 2770697设备清单过滤非效益分析设备
	...q:(vFromOriginalFee'="")&&(OriginalFee<vFromOriginalFee)
	...q:(vToOriginalFee'="")&&(OriginalFee>vToOriginalFee)
	...d ResetVariablesGetEquipList
	...s TEQRowID=EQRowID
	...s TItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
	...q:(vItemDR'="")&&(TItemDR'=vItemDR)
	...s TEQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	...s TEQName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	...s TEQCode=$p($g(^DHCEQEquip(TEQRowID)),"^",6)
	...q:(vDesc'="")&&($ZCONVERT(TEQNo,"U")'[$ZCONVERT(vDesc,"U"))&&($ZCONVERT(TEQName,"U")'[$ZCONVERT(vDesc,"U"))&&($ZCONVERT(TEQCode,"U")'[$ZCONVERT(vDesc,"U"))
	...s TModel=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	...i TModel'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModel)
	...s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee)
	...s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipTypeDR)
	...s TStoreLocDR=StoreLocDR
	...s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	...d OutputRowGetEquipList
	
	Quit $$$OK
OutputRowGetEquipList
	s Data=$lb(TEQRowID,TItemDR,TEQNo,TEQName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipList
	s (TEQRowID,TItemDR,TEQNo,TEQName,TModel,TOriginalFee,TEquipType,TStoreLoc,TStoreLocDR)=""
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY0257 20210325
/// Add By DJ 2019-12-25
/// 设备服务项目
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.CTEquipService","GetEquipService",0,1,2)
Query GetEquipService(BussType As %String = "", SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TOeordItem:%String,TServiceItemDR:%String,Opt:%String,TOeordCode:%String,TOeordPrice:%String") [ SqlProc ]
{
}

ClassMethod GetEquipServiceExecute(ByRef qHandle As %Binary, BussType As %String = "", SourceType As %String = "", SourceID As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	///modified by ZY0237 设备先找设备项,再找设备的对照服务项
	i (BussType="")||(SourceType="")||(SourceID="") Quit $$$OK
	i (BussType=0)&&(SourceType=1)&&('$Data(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID)))
	{
		s SourceType=2 
		s SourceID=$p($g(^DHCEQEquip(SourceID)),"^",7)
		if '$Data(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID)) Quit $$$OK
		d BuildEquipService
	}else
	{
		if '$Data(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID)) Quit $$$OK
		d BuildEquipService
	}
	
	Quit $$$OK
BuildEquipService
	s ESServiceID=0
	f  s ESServiceID=$o(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID,ESServiceID))  q:ESServiceID=""  d
	.s ESRowID=0
	.f  s ESRowID=$o(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID,ESServiceID,ESRowID))  q:ESRowID=""  d
	..s ESInvalidFlag=$p($g(^DHCEQEquipService(ESRowID)),"^",9)
	..q:ESInvalidFlag="Y"
	..s TRowID=ESRowID
	..s TSourceType=$Case(SourceType,"1":"设备","2":"设备项","3":"购置申请",:"未定义")
	..s TOeordItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",ESServiceID)),"^",1)
	..s TServiceItemDR=ESServiceID
	..s TOeordCode=$p($g(^DHCEQCCode("DHCEQCServiceItem",ESServiceID)),"^",2) //医嘱项代码 add by wy 2022-7-15
	..s TOeordPrice=$p($g(^DHCEQCCode("DHCEQCServiceItem",ESServiceID)),"^",4) //医嘱项费用
	..i TOeordPrice="" s TOeordPrice=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID("DHC-HIS",$p($g(^DHCEQCCode("DHCEQCServiceItem",ESServiceID)),"^",6),+$H)  //当设备对照服务项为空的时候从HIS里面取
	..d OutputRowGetEquipService
	quit
OutputRowGetEquipService
	s Data=$lb(TRowID,TSourceType,TOeordItem,TServiceItemDR,Opt,TOeordCode,TOeordPrice)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEquipServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipServiceExecute ]
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

ClassMethod GetEquipServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY0282 20211112 增加服务对照用到的数量
/// modified by ZY0257 20210325 增加参数
/// modified by zy ZY0224 2020-04-26
/// Add By DJ 2019-09-05
/// 描述:获取某一周期范围内的HIS医嘱执行科室及医嘱项目明细
/// 入参:vStartDate  开始日期  格式YYYY-MM-DD
/// 		vEndDate	结束日期  格式YYYY-MM-DD
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.CTEquipService","GetOeordItem","36","","","0","1","107","true")
Query GetOeordItem(vLocDR As %String = "", vORCatDR As %String = "", vORItemCatDR As %String = "", BussType As %String = "", SourceType As %String = "", SourceID As %String = "", vIncludeInput As %String = "", Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TExeLoc:%String,TOeordItem:%String,TExeLocDR:%String,TOeordItemDR:%String,TOrdCatDR:%String,TOrdCat:%String,TOrdItemCatDR:%String,TOrdItemCat:%String,Opt:%String,TSingleFlag:%String,TCount:%String,TRowID:%String,TARCode:%String,TARPrice:%String") [ SqlProc ]
{
}

ClassMethod GetOeordItemExecute(ByRef qHandle As %Binary, vLocDR As %String = "", vORCatDR As %String = "", vORItemCatDR As %String = "", BussType As %String = "", SourceType As %String = "", SourceID As %String = "", vIncludeInput As %String = "", Code As %String = "", Desc As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s vIncludeInput=##Class(web.DHCEQCommon).TransValueFromPage(vIncludeInput,"bool")
	s Code=$ZCONVERT(Code,"U")
	//s ^ZY("GetOeordItem")=vLocDR_"^"_vORCatDR_"^"_vORItemCatDR_"^"_BussType_"^"_SourceType_"^"_SourceID_"^"_vIncludeInput
	//s ItemDR=""
	//i vEQRowID'="" s ItemDR=$p($g(^DHCEQEquip(vEQRowID)),"^",7)
	s LocStr=""
	i vLocDR'=""  d
	.s CIRowID=0
	.f  s CIRowID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"SYSID",1,vLocDR,CIRowID))  q:CIRowID=""  d
	..s CIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",16)
	..q:CIInvalidFlag="Y"
	..i LocStr'="" s LocStr=LocStr_","
	..s LocStr=LocStr_$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",5)
	
	s DeptDR=0
	f  s DeptDR=$o(^DHCEQDeptOrdItem(0,"DeptOrdCatItem",DeptDR))  q:DeptDR=""  d
	.q:(LocStr'="")&&((","_LocStr_",")'[(","_DeptDR_","))
	.;add by wy 2022-7-12 当科室对照表数据不存在时,直接取DHCEQCDepartment对照的HIS科室ID
	.if (LocStr="")&&(vLocDR'="") d
	..s LocStr=$p($g(^DHCEQCCode("DHCEQCDepartment",vLocDR)),"^",11)  
	.q:(LocStr'="")&&(LocStr'=DeptDR)	//modifed by ZY 2853008  20220913
	.s OrdCatDR=0
	.f  s OrdCatDR=$o(^DHCEQDeptOrdItem(0,"DeptOrdCatItem",DeptDR,OrdCatDR))  q:OrdCatDR=""  d
	..q:(vORCatDR'="")&&((","_vORCatDR_",")'[(","_OrdCatDR_","))
	..s OrdItemCatDR=0
	..f  s OrdItemCatDR=$o(^DHCEQDeptOrdItem(0,"DeptOrdCatItem",DeptDR,OrdCatDR,OrdItemCatDR))  q:OrdItemCatDR=""  d
	...d ResetVariablesGetOeordItem
	...q:(vORItemCatDR'="")&&((","_vORItemCatDR_",")'[(","_OrdItemCatDR_","))
	...///Modefied by zc0107 20211115 修改医嘱项目输出错误 begin
	...;s DOIRowID=$o(^DHCEQDeptOrdItem(0,"DeptOrdCatItem",DeptDR,OrdCatDR,OrdItemCatDR,0))
	...s DOIRowID=0
	...f  s DOIRowID=$o(^DHCEQDeptOrdItem(0,"DeptOrdCatItem",DeptDR,OrdCatDR,OrdItemCatDR,DOIRowID))  q:DOIRowID=""  d
	....s TOeordItemDR=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",2)
	....;过滤已维护记录
	....s Find=0
	....s SIRowID=0
	....f  s SIRowID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",TOeordItemDR,SIRowID))  q:(SIRowID="")||(Find'=0)  d
	.....s ESRowID=0
	.....f  s ESRowID=$o(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID,SIRowID,ESRowID))  q:(ESRowID="")||(Find'=0)  d
	......s ESInvalidFlag=$p($g(^DHCEQEquipService(ESRowID)),"^",9)
	......q:ESInvalidFlag="Y"
	......s Find=1
	.....q:Find'=0
	.....///效益分析且是设备时,查看设备项对照
	.....i (BussType=0)&&(SourceType=1)  d
	......s tmpSourceType=2
	......s tmpSourceID=$p($g(^DHCEQEquip(SourceID)),"^",7)
	......s ESRowID=0
	......f  s ESRowID=$o(^DHCEQEquipService(0,"BussSource",BussType,tmpSourceType,tmpSourceID,SIRowID,ESRowID))  q:(ESRowID="")||(Find'=0)  d
	.......s ESInvalidFlag=$p($g(^DHCEQEquipService(ESRowID)),"^",9)
	.......q:ESInvalidFlag="Y"
	.......s Find=1
	....///Modefied by zc0107 20211115 修改医嘱项目输出错误 end
	....///modified by ZY0284 20211122 输出逻辑少了一层
	....q:Find'=0
	....s TExeLoc=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",5)
	....s TOeordItem=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",6)
	....s TExeLocDR=DeptDR
	....s THospitalDR = ##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TExeLocDR)	//2233105 czf 2021-11-18
	....q:##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"1","","")
	....s TOrdCatDR=OrdCatDR
	....s TOrdCat=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",7)
	....s TOrdItemCatDR=OrdItemCatDR
	....s TOrdItemCat=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",8)
 	....s subscript=$p(TOeordItemDR,"||",1)   //add by wy 2022-6-29 2767476,2767443增加医嘱code查询和输出
 	....s version=$p(TOeordItemDR,"||",2)
 	....S TARCode=$p($g(^ARCIM(subscript,version,1)),"^",1) 
 	....q:(Code'="")&&($ZCONVERT(TARCode,"U")'[Code)
    ....//modified by ZY20230506 bug:3463707
    ....s TARPrice=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID("DHC-HIS",TOeordItemDR,+$H,THospitalDR) //$p($g(^ARCIM(subscript,version,1)),"^",8) ;Price
 	....q:(Desc'="")&&($ZCONVERT(TOeordItem,"U")'[Desc)  //add by wy 2022-7-12 2790212增加执行科室查询
	....d OutputRowGetOeordItem
	
	/// modified by ZY0257 20210325 增加输出手工添加的服务项输出
	i vIncludeInput="Y"
	{
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCServiceItem",rowid))  quit:rowid=""  d
		.d ResetVariablesGetOeordItem
		.s DataList=""
		.s DataList=$g(^DHCEQCCode("DHCEQCServiceItem",rowid))
		.s TRowID=rowid
		.s TOeordItemDR = rowid	//rowid
		.q:$p(DataList,"^",8)="Y"
		.q:$p(DataList,"^",12)="Y"
		.s TOeordItem=$p(DataList,"^",1)
		.s TExType=$p(DataList,"^",5)
		.s TSingleFlag=$p(DataList,"^",15)
		.s TARCode=$p(DataList,"^",2)  //add by wy 2022-6-29 增加医嘱code查询和输出
		.s TARPrice=$p(DataList,"^",4)
		.s TCount=0
		.i TSingleFlag="Y" d
		..s vSourceID=0
		..f  s vSourceID=$o(^DHCEQEquipService(0,"ServiceSource",rowid,0,1,vSourceID)) q:vSourceID=""  d
		...s vESRowID=0
		...f  s vESRowID=$o(^DHCEQEquipService(0,"ServiceSource",rowid,0,1,vSourceID,vESRowID)) q:vESRowID=""  d
		....q:$p($g(^DHCEQEquipService(vESRowID)),"^",9)="Y"
		....s TCount=TCount+1
		.
		.i TExType="DHC-HIS" d
		..s TOeordItemDR=$p(DataList,"^",6)
		..s TOrdItemCatDR=$p($g(^ARCIM(+TOeordItemDR,+$p(TOeordItemDR,"||",2),1)),"^",10)	//医嘱子类ID[ARC_ItemCat]
		..i TOrdItemCatDR'="" d 
		...s TOrdItemCat=$p($g(^ARC("IC",TOrdItemCatDR)),"^",2)
		...s TOrdCatDR=$p($g(^ARC("IC",TOrdItemCatDR)),"^",8)	//医嘱大类[OEC_OrderCategory]
		...i TOrdCatDR'="" s TOrdCat=$p($g(^OEC("ORCAT",TOrdCatDR)),"^",2)
	 	...s subscript=$p(TOeordItemDR,"||",1)  //add by wy 2022-6-29 增加医嘱code查询和输出
	 	...s version=$p(TOeordItemDR,"||",2)
	 	...i TARCode="" S TARCode=$p($g(^ARCIM(subscript,version,1)),"^",1) ;Code
 	    ...q:(Code'="")&&($ZCONVERT(TARCode,"U")'[Code)
	 	...i TARPrice="" s TARPrice=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID("DHC-HIS",TOeordItemDR,+$H)
 	    ...q:(Desc'="")&&($ZCONVERT(TOeordItem,"U")'[Desc) 
		...d OutputRowGetOeordItem
	}
	
	Quit $$$OK
OutputRowGetOeordItem
	s Data=$lb(TExeLoc,TOeordItem,TExeLocDR,TOeordItemDR,TOrdCatDR,TOrdCat,TOrdItemCatDR,TOrdItemCat,Opt,TSingleFlag,TCount,TRowID,TARCode,TARPrice)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOeordItem
	s (TExeLoc,TOeordItem,TExeLocDR,TOeordItemDR,TOrdCatDR,TOrdCat,TOrdItemCatDR,TOrdItemCat,Opt,TSingleFlag,TCount,TRowID,TARCode,TARPrice)=""
	quit
}

ClassMethod GetOeordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOeordItemExecute ]
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

ClassMethod GetOeordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOeordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DeleteData(vIDs As %String = "")
{
	TSTART
	s SQLCODE=0
	s i=0
	s Count=$L(vIDs,",")
	f i=1:1:Count  d
	.q:SQLCODE'=0
	.s CurID=$p(vIDs,",",i)
	.i CurID'="" &SQL(Update SQLUSER.DHC_EQEquipService Set ES_InvalidFlag='Y' where ES_RowID=:CurID)
	
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
}

/// modified add by ZY0247 20201222
/// modified by zy ZY0224 2020-04-26
ClassMethod SaveData(vOrdItemIDs As %String = "", vSaveType As %String = "", BussType As %String = "", SourceType As %String = "", SourceID As %String = "")
{
	s vSaveType=##Class(web.DHCEQCommon).TransValueFromPage(vSaveType,"bool")
	TSTART
	s ItemDR=""
	s SQLCODE=0
	s i=0
	s Count=$L(vOrdItemIDs,",")
	f i=1:1:Count  d
	.q:SQLCODE'=0
	.s CurID=$p(vOrdItemIDs,",",i)
	.i CurID'=""  d
	..;检测服务项目是否存在
	..s Find=0
	..s SIRowID=0
	..f  s SIRowID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID","DHC-HIS",CurID,SIRowID)) q:(SIRowID="")||(Find'=0)  d
	...s SIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",SIRowID)),"^",12)
	...q:SIInvalidFlag="Y"
	...s Find=SIRowID
	..;存储服务项目
	..i Find=0  d
	...s OrdItemCode=$p($g(^ARCIM($p(CurID,"||",1),$p(CurID,"||",2),1)),"^",1)
	...s OrdItemDesc=$p($g(^ARCIM($p(CurID,"||",1),$p(CurID,"||",2),1)),"^",2)
	...//modified by ZY0256 20210315 增加医嘱项金额的获取
	...s OrdItemPrice=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID("DHC-HIS",CurID, +$H)
	...&SQL(Insert Into SQLUSER.DHC_EQCServiceItem(SI_Desc,SI_Code,SI_Price,SI_ExType,SI_ExID,SI_ImportFlag,SI_InvalidFlag,SI_ExDesc) values(:OrdItemDesc,:OrdItemCode,:OrdItemPrice,'DHC-HIS',:CurID,'Y','N',:OrdItemDesc)) 
	...s ServiceID=$g(%ROWID)
	..e  d
	...s ServiceID=Find
	..q:SQLCODE'=0
	..;存储设备服务对照
	..i BussType=0 d
	...i SourceType="1" s ItemDR=$p($g(^DHCEQEquip(SourceID)),"^",7)
	...i vSaveType="Y"  d
	....&SQL(Insert Into SQLUSER.DHC_EQEquipService(ES_SourceType,ES_SourceID,ES_ServiceDR,ES_InvalidFlag,ES_BussType,ES_ExType) values(2,:ItemDR,:ServiceID,'N',:BussType,'DHC-HIS'))
	...e  d
	....&SQL(Insert Into SQLUSER.DHC_EQEquipService(ES_SourceType,ES_SourceID,ES_ServiceDR,ES_InvalidFlag,ES_BussType,ES_ExType) values(1,:SourceID,:ServiceID,'N',:BussType,'DHC-HIS'))
	..e  i BussType=1 d
	...&SQL(Insert Into SQLUSER.DHC_EQEquipService(ES_SourceType,ES_SourceID,ES_ServiceDR,ES_InvalidFlag,ES_BussType,ES_ExType) values(3,:SourceID,:ServiceID,'N',:BussType,'DHC-HIS'))
	
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
}

/// d ##Class(web.DHCEQ.BA.CTEquipService).GetOrdCat()
ClassMethod GetOrdCat(Paras As %String = "")
{
	s OrtCatStr=""
	s ORCATRowID=0
	f  s ORCATRowID=$o(^DHCEQDeptOrdItem(0,"OrdCat",ORCATRowID))  q:ORCATRowID=""  d
	.s DOIRowID=$o(^DHCEQDeptOrdItem(0,"OrdCat",ORCATRowID,0))
	.s ORCATDesc=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",7)
	.i OrtCatStr'="" s OrtCatStr=OrtCatStr_"@"
	.s OrtCatStr=OrtCatStr_ORCATRowID_"^"_ORCATRowID_ORCATDesc
	
#;	//DHCHIS
#;	s ORCATRowID=0
#;	f  s ORCATRowID=$o(^OEC("ORCAT",ORCATRowID))  q:ORCATRowID=""  d
#;	.s ORCATDesc=$p($g(^OEC("ORCAT",ORCATRowID)),"^",2)
#;	.i OrtCatStr'="" s OrtCatStr=OrtCatStr_"@"
#;	.s OrtCatStr=OrtCatStr_ORCATRowID_"^"_ORCATRowID_ORCATDesc
	
	q OrtCatStr
}

/// w ##Class(web.DHCEQ.BA.CTEquipService).GetOrdItemCat(1)
ClassMethod GetOrdItemCat(vOrdCatDRs As %String = "")
{
	i vOrdCatDRs="" q ""
	
	s OrtCatItemStr=""
	s ORCATRowID=0
	f  s ORCATRowID=$o(^DHCEQDeptOrdItem(0,"OrdCatItem",ORCATRowID))  q:ORCATRowID=""  d
	.q:(vOrdCatDRs'="")&&((","_vOrdCatDRs_",")'[(","_ORCATRowID_","))
	.;s ORCATDesc=$p($g(^OEC("ORCAT",ORCATRowID)),"^",2)
	.s ARCRowID=0
	.f  s ARCRowID=$o(^DHCEQDeptOrdItem(0,"OrdCatItem",ORCATRowID,ARCRowID)) q:ARCRowID=""  d
	..;s ARCDesc=$p($g(^ARC("IC",ARCRowID)),"^",2)
	..s DOIRowID=$o(^DHCEQDeptOrdItem(0,"OrdCatItem",ORCATRowID,ARCRowID,0))
	..s ORCATDesc=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",7)
	..s ARCDesc=$p($g(^DHCEQDeptOrdItem(DOIRowID)),"^",8)
	..i OrtCatItemStr'="" s OrtCatItemStr=OrtCatItemStr_"@"
	..s OrtCatItemStr=OrtCatItemStr_ARCRowID_"^["_ORCATRowID_"]"_ARCDesc
	
#;	///DHCHIS
#;	s ORCATRowID=0
#;	f  s ORCATRowID=$o(^OEC("ORCAT",ORCATRowID))  q:ORCATRowID=""  d
#;	.q:(vOrdCatDRs'="")&&((","_vOrdCatDRs_",")'[(","_ORCATRowID_","))
#;	.s ORCATDesc=$p($g(^OEC("ORCAT",ORCATRowID)),"^",2)
#;	.s ARCRowID=0
#;	.f  s ARCRowID=$o(^ARC("IC",0,"OrdCat",ORCATRowID,ARCRowID)) q:ARCRowID=""  d
#;	..s ARCDesc=$p($g(^ARC("IC",ARCRowID)),"^",2)
#;	..i OrtCatItemStr'="" s OrtCatItemStr=OrtCatItemStr_"@"
#;	..s OrtCatItemStr=OrtCatItemStr_ARCRowID_"^["_ORCATRowID_"]"_ARCDesc
	
	q OrtCatItemStr
}

/// d ##Class(web.DHCEQ.BA.CTEquipService).Download("2022-07","2022-07")
/// modified by wy 2022-7-5 2770790 调整获取科室医嘱项
/// /同步某一时间段内的科室医嘱项
ClassMethod Download(vSMonth As %String = "", vEMonth As %String = "")
{
	s CurTime=$p($H,",",2)
	i ((CurTime>=28800)&&(CurTime<=64800)) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","(8:00--18:00)上班高峰期禁止同步数据!")
	i (vSMonth="")||(vEMonth="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","同步数据开始月份与结束月份不能为空!")
	s BeginDate=##Class(web.DHCEQReport).GetReportDate(vSMonth,"1","","1")
	s EndDate=##Class(web.DHCEQReport).GetReportDate(vEMonth,"2","","1")
	;i (EndDate-BeginDate)>31 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9200","同步数据量较大,请以月为单位同步!")
	k ^Temp("DHCEQGetHisOrdItem",$J)
	s WLOrdDate=BeginDate-1
	f  s WLOrdDate=$o(^DHCWorkLoad(0,"DateItemOrd",WLOrdDate))  q:(WLOrdDate="")||(WLOrdDate>EndDate)  d
	.q:$D(^DHCEQDeptOrdItem(0,"OrderDate",WLOrdDate))
	.s ^DHCEQDeptOrdItem(0,"OrderDate",WLOrdDate)=""
	.s WLOrdItemDR=0
	.f  s WLOrdItemDR=$o(^DHCWorkLoad(0,"DateItemOrd",WLOrdDate,WLOrdItemDR))  q:WLOrdItemDR=""  d
	..s WLRowID=0
	..f  s WLRowID=$o(^DHCWorkLoad(0,"DateItemOrd",WLOrdDate,WLOrdItemDR,WLRowID))  q:WLRowID=""  d
	...s WLRecDept=$p($g(^DHCWorkLoad(WLRowID)),"^",1)
	...q:WLRecDept=""
	...i '$D(^Temp("DHCEQGetHisOrdItem",$J,WLRecDept,WLOrdItemDR))&&'$D(^DHCEQDeptOrdItem(0,"DeptOrdItem",WLRecDept,WLOrdItemDR)) s ^Temp("DHCEQGetHisOrdItem",$J,WLRecDept,WLOrdItemDR)=""
	...s ^Temp("DHCEQGetHisOrdItem",$J,WLRecDept,WLOrdItemDR)=WLOrdItemDR
	//存储
	TSTART
	s SQLCODE=0
	s LocDR=0
	f  s LocDR=$o(^Temp("DHCEQGetHisOrdItem",$J,LocDR))  q:(LocDR="")||(SQLCODE'=0)  d
	.s OrdItemDR=""
	.f  s OrdItemDR=$o(^Temp("DHCEQGetHisOrdItem",$J,LocDR,OrdItemDR))  q:(OrdItemDR="")||(SQLCODE'=0)  d
	..s LocDesc=$p($g(^CTLOC(LocDR)),"^",2)
	..s OrdItem=$p($g(^ARCIM(+OrdItemDR,+$p(OrdItemDR,"||",2),1)),"^",2)
	..s OrdItemCatDR=$p($g(^ARCIM(+OrdItemDR,+$p(OrdItemDR,"||",2),1)),"^",10)	//医嘱子类ID[ARC_ItemCat]
	..s OrdItemCat=$p($g(^ARC("IC",OrdItemCatDR)),"^",2)
	..s OrdCatDR=$p($g(^ARC("IC",OrdItemCatDR)),"^",8)	//医嘱大类[OEC_OrderCategory]
	..s OrdCat=$p($g(^OEC("ORCAT",OrdCatDR)),"^",2)
	..k PLIST
	..s PLIST(2)=LocDR
	..s PLIST(3)=OrdItemDR
	..s PLIST(4)=OrdCatDR
	..s PLIST(5)=OrdItemCatDR
	..s PLIST(6)=LocDesc
	..s PLIST(7)=OrdItem
	..s PLIST(8)=OrdCat
	..s PLIST(9)=OrdItemCat
	..s tmpid=""
	..&SQL(Select DOI_RowID into :tmpid from sqluser.DHC_EQDeptOrdItem where DOI_DeptID=:LocDR and DOI_OrderItemID=:OrdItemDR and DOI_OrderCatID=:OrdCatDR and DOI_OrderItemCatID=:OrdItemCatDR)
	..i tmpid=""  d
	...&SQL(Insert Into SQLUSER.DHC_EQDeptOrdItem Values :PLIST())
	
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	k ^Temp("DHCEQGetHisOrdItem",$J)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
}

/// modified by ZY20230105 bug:3187233
/// modified by ZY0222 2020-04-16
/// w ##class(web.DHCEQ.BA.CTEquipService).GetListNum(1,3,2)
ClassMethod GetListNum(BussType, SourceType, SourceID)
{
	new count,firstID,objInfo
	s count=0
	s firstID=""
	i $Data(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID))
	{
		s SIRowID=0
		For  Set SIRowID=$Order(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID,SIRowID))  Quit:SIRowID=""  Do
		.s rowid=0
		.For  Set rowid=$Order(^DHCEQEquipService(0,"BussSource",BussType,SourceType,SourceID,SIRowID,rowid))  Quit:rowid=""  Do
		..q:$p($g(^DHCEQEquipService(rowid)),"^",9)="Y"
		..s count=count+1
		..i count=1 s firstID=rowid
	}
	
	s objInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	d objInfo.%Set("count",count)
	d objInfo.%Set("firstID",firstID)
    i firstID'=""
    {
        s ServiceItemDR=$p($g(^DHCEQEquipService(firstID)),"^",4)
        s SIDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",1)
    }
    else
    {
        s SIDesc=""
    }
    d objInfo.%Set("ESServiceDR_SIDesc",SIDesc)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
}

/// add by ZY0247 20201222
/// 根据服务项以及发生的科室，来取得相应的设备
/// 根据轮询方式获取
/// w ##Class(web.DHCEQ.BA.CTEquipService).GetEquipByService(405,113)
ClassMethod GetEquipByService(ServiceItem, LocDR, vJob As %String = "", GatherDate As %String = "")
{
	new SingleFlag,SourceType,SourceID,EquipID,RowID,ItemDR,ESInvalidFlag,CIInvalidFlag,CISYSID,ModelDR
	new PreEquipID,NewEquipID
	i ServiceItem="" q ""
	i LocDR="" q ""
	i vJob="" s vJob=$J
	//服务项是单一设备使用的时候,就直接取当前对照的设备.
	s SingleFlag=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItem)),"^",15)
	i SingleFlag="Y"
	{
		s NewEquipID=""
		s SourceID=0
		f  s SourceID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,0,1,SourceID))  quit:(SourceID="")||(NewEquipID'="")  d 
		.s RowID=0
		.f  s RowID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,0,1,SourceID,RowID))  quit:(RowID="")||(NewEquipID'="")  d 
		..s ESInvalidFlag=$p($g(^DHCEQEquipService(RowID)),"^",9)
		..q:ESInvalidFlag="Y"
		..s NewEquipID=SourceID
		q NewEquipID
	}
	
	if '$Data(^TempDHCEQ("GetEquipByService",vJob,ServiceItem,LocDR))
	{
		s SourceType=0
		f  s SourceType=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,0,SourceType))  quit:(SourceType="")  d 
		.s SourceID=0
		.f  s SourceID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,0,SourceType,SourceID))  quit:(SourceID="")  d 
		..s RowID=0
		..f  s RowID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,0,SourceType,SourceID,RowID))  quit:(RowID="")  d 
		...;Add By DJ 2017-06-22 DJ0189 过滤无效设备服务对照
		...s ESInvalidFlag=$p($g(^DHCEQEquipService(RowID)),"^",9)
		...q:ESInvalidFlag="Y"
		...s AddFlag=0	//筛选设备,是否加入到队列中
		...;如果指定设备,则轮询可以做这个服务的设备
		...i SourceType=1  d
		....s EquipID=SourceID
		....d CheckNearEquip
		...;如果指定设备项,则轮询可以做这个服务的设备项包含的所有设备
		...e  i SourceType=2  d
		....s ItemDR=SourceID
		....s ModelDR=$p($g(^DHCEQEquipService(RowID)),"^",3)
		....s CIRowID=0
		....f  s CIRowID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"EXID",1,LocDR,CIRowID))  q:CIRowID=""  d
		.....s CIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",16)
		.....q:CIInvalidFlag="Y"
		.....s CISYSID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",2)
		.....s EquipID=0
		.....f  s EquipID=$o(^DHCEQEquip(0,"LocItem",CISYSID,ItemDR,EquipID))  quit:(EquipID="")  d
		......;过滤掉机型不一致的
		......q:((ModelDR'="")&&(ModelDR'=$p($g(^DHCEQEquip(EquipID)),"^",3)))
		......d CheckNearEquip
	}
	
	//上次使用的设备
	s PreEquipID=$g(^DHCEQEquipService(0,"EX","Rotate",ServiceItem,LocDR))
	i PreEquipID="" s PreEquipID=0
	s NewEquipID=$o(^TempDHCEQ("GetEquipByService",vJob,ServiceItem,LocDR,PreEquipID))
	//PreEquipID是最后一个的时候,取第一个设备ID
	i NewEquipID="" s NewEquipID=$o(^TempDHCEQ("GetEquipByService",vJob,ServiceItem,LocDR,0))
	
	k ^TempDHCEQ("GetEquipByService",vJob,ServiceItem,LocDR)
	
	q NewEquipID
CheckNearEquip
	
	s FindLoc=0
	i $p(^DHCEQEquip(EquipID),"^",19)=LocDR s FindLoc=1
	s CIRowID=0
	f  s CIRowID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"EXID",6,LocDR,CIRowID))  q:(CIRowID="")||(FindLoc'=0)  d
	.s CIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",16)
	.q:CIInvalidFlag="Y"
	.s CISYSID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",2)
	.i $p(^DHCEQEquip(EquipID),"^",19)=CISYSID s FindLoc=1
	q:FindLoc=0
	;过滤掉无效的
	q:$p($g(^DHCEQEquip(EquipID)),"^",59)'="N"
	;过滤掉非在用的
	q:$p($g(^DHCEQEquip(EquipID)),"^",38)'=1
	;过滤掉非在库
	q:$p($g(^DHCEQEquip(EquipID)),"^",60)'=1
	
	///补采逻辑修改：医嘱没有采集过的记录；轮询过的设备，不能参与轮询，剩下的设备参与轮询
	q:$Data(^DHCEQUseRecord(0,"EquipServiceDate",1,EquipID,ServiceItem,GatherDate,0))>0
	//
	s ^TempDHCEQ("GetEquipByService",vJob,ServiceItem,LocDR,EquipID)=""
	q
}

/// add by ZY 20211011 
/// 判断一个设备和是否有当前服务项的对照信息。用于his设备或设备项服务对照 补采，重采.
/// 参数 BussType  0:效益分析，1:采购申请论证
/// 	ServiceItem	服务项ID
/// 	FindEquipID 当前要检查的设备ID
/// 返回值  0，没有对照  1，有对照
ClassMethod CheckEquipByService(BussType, ServiceItem, FindEquipID)
{
	new InFlag,SourceType,SourceID,ESRowID,ItemDR,ModelDR,EquipID
	s InFlag=0
	i '$Data(^DHCEQEquipService(0,"BussService",BussType,ServiceItem)) q InFlag
	s SourceType=0
	f  s SourceType=$o(^DHCEQEquipService(0,"BussService",BussType,ServiceItem,SourceType))  q:(SourceType="")||(InFlag'=0)  d
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQEquipService(0,"BussService",BussType,ServiceItem,SourceType,SourceID))  q:(SourceID="")||(InFlag'=0)  d
	..s ESRowID=0
	..f  s ESRowID=$o(^DHCEQEquipService(0,"BussService",BussType,ServiceItem,SourceType,SourceID,ESRowID))  q:(ESRowID="")||(InFlag'=0)  d
	...q:$p($g(^DHCEQEquipService(ESRowID)),"^",9)="Y"
	...i SourceType=1  d
	....i FindEquipID=SourceID s InFlag=1
	...;如果指定设备项,则轮询可以做这个服务的设备项包含的所有设备
	...e  i SourceType=2  d
	....s ItemDR=SourceID
	....s ModelDR=$p($g(^DHCEQEquipService(ESRowID)),"^",3)
	....s vEquipID=0
	....f  s vEquipID=$o(^DHCEQEquip(0,"Item",ItemDR,"N",vEquipID))  quit:(vEquipID="")||(InFlag'=0)  d
	.....;过滤掉机型不一致的
	.....q:((ModelDR'="")&&(ModelDR'=$p($g(^DHCEQEquip(vEquipID)),"^",3)))
	.....i FindEquipID=vEquipID s InFlag=1
	q InFlag
}

}
