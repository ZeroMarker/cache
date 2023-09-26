/// Add By CSJ 2020-02-24 
/// 描述：树操作类
Class web.DHCEQ.Plat.LIBTree Extends %RegisteredObject [ ProcedureBlock ]
{

/// Add By CSJ 2020-02-24
/// 描述:获取分类树JSON字符串
/// 入参:parid 父节点id
/// 返回值:分类树JSON字符串
/// w ##class(web.DHCEQ.Plat.LIBTree).GetEquipeCatTreeStr()
/// Modefied by zc0119 2022-6-20 添加入参tEquipTypeDR和tStatCatDR
ClassMethod GetEquipeCatTreeStr(parid As %String = "0", tEquipTypeDR As %String = "", tStatCatDR As %String = "")
{
	s JsonObj=##class(web.DHCEQ.Plat.LIBTree).GetEquipeCatTree(parid,tEquipTypeDR,tStatCatDR) // Modefied by zc0119 2022-6-20 添加入参tEquipTypeDR和tStatCatDR	//CZF0131 2021-01-20
	s objType=JsonObj.%ClassName()
	i (objType="%ArrayOfDataTypes")||(objType="%ListOfDataTypes")
	{
		//q ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(JsonObj)		//字符流超长，转换字符串报错,改为直接返回字符流，前台用ajax异步获取w值
		
		s StreamStr= ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(JsonObj,1)		//czf 2021-02-25 begin
		
		/*用此种方式或StreamStr.OutputToDevice()直接w字符流,弊端是其他方法中调用此方法不能获取w值,只能获取到q出的值
		do StreamStr.Rewind()
		while 'StreamStr.AtEnd {
			w StreamStr.Read(10000)
		}
		q ""
		*/
		d StreamStr.OutputToDevice()
		q ""		//czf 2021-02-25 end
	}
	else
	{
		q JsonObj.%ToJSON()
	}
}

/// Add By CSJ 2020-09-15
/// 描述:获取级别树JSON字符串
/// 入参:parid 父节点id
/// 返回值:分类树JSON字符串
/// w ##class(web.DHCEQ.Plat.LIBTree).GetTreeMapStr()
ClassMethod GetTreeMapStr(parid As %String = "0")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ChildTree=##class(web.DHCEQ.Plat.LIBTree).GetTreeMap(parid)
	d TreeItem.%Set("id","top")
	d TreeItem.%Set("text","设备级别树")
	d TreeItem.%Set("children",ChildTree)
	d TreeItem.%Set("state","closed")
	d ReturnInfo.Insert(TreeItem)

	q ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(ReturnInfo)
}

/// Add By CSJ 2020-02-24
/// 描述:递归生成分类树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
/// Modefied by zc0119 2022-6-20 添加入参vEquipTypeDR和vStatCatDR
ClassMethod GetEquipeCatTree(parid As %String = "0", vEquipTypeDR As %String = "", vStatCatDR As %String = "")
{
	//i vEquipTypeDR="" q ##class(%ListOfDataTypes).%New()	//Modefied by zc0119 2022-6-20 判断是否传入类组ID
	s CatFilterFlag=##class(web.DHCEQCommon).GetSysInfo("992004")
	
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s FinanceType=$p($g(^DHCEQCCode("DHCEQCEquipType", +vEquipTypeDR)),"^",9)	//Modefied by zc0119 2022-6-20 根据类组ID取财务类型
	s childid=0
	for  s childid=$o(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",parid,childid)) quit:childid=""  d
	.d ResetECVariables
	.s TInvalidFlag=$P(^DHCEQCCode("DHCEQCEquipeCat",childid),"^",7)
	.q:TInvalidFlag="Y"
	.//	Modefied by zc0119 2022-6-20 根据类组与类型条件过滤设备分类 begin
	.s FTParentDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",childid)),"^",10)		
	.s SCParentDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",childid)),"^",11)
	.;q:(CatFilterFlag=1)&&((vEquipTypeDR="")||(FTParentDR'=FinanceType))
	.;q:(CatFilterFlag=2)&&(SCParentDR'="")&&(vStatCatDR'="")&&(SCParentDR'=vStatCatDR)	//设备分类所属类型不为空时按类型过滤	
	.;q:(CatFilterFlag=2)&&((SCParentDR="")||(vStatCatDR=""))&&(vEquipTypeDR'="")&&(FTParentDR'=FinanceType)	//设备分类所属类型为空或设备类型为空时按财务大类过滤 //czf 1904153 2021-05-07 end
	.s ParentCatDR=$P(^DHCEQCCode("DHCEQCEquipeCat",childid),"^",4)
	.s TDesc=$P(^DHCEQCCode("DHCEQCEquipeCat",childid),"^",2)
	.d TreeItem.%Set("id",childid)
	.d TreeItem.%Set("text",TDesc)
	.i $d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",childid)) d
	..s children=##class(web.DHCEQ.Plat.LIBTree).GetEquipeCatTree(childid,vEquipTypeDR,vStatCatDR)  // Modefied by zc0119 2022-6-20 添加入参vEquipTypeDR和vStatCatDR
	..q:children.Count()=0
	..d TreeItem.%Set("children",children)
	..d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)
	
	q ReturnInfo
	
ResetECVariables
	s (TDesc,TCode)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// Add By CSJ 2020-09-15
/// 描述:递归生成级别树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
ClassMethod GetTreeMap(parid As %String = "0")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	
	s childid=0
	for  s childid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",parid,childid)) quit:childid=""  d
	.d ResetVariables
	.s TInvalidFlag=$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",12)
	.q:TInvalidFlag="Y"
	.s ParentCatDR=$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",4)
	.s TDesc=##class("web.DHCEQCTreeMap").GetTreeDesc(childid)
	.d TreeItem.%Set("id",childid)
	.d TreeItem.%Set("text",TDesc)
	.i $d(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",childid)) d
	..s children=##class(web.DHCEQ.Plat.LIBTree).GetTreeMap(childid)
	..q:children.Count()=0		//CZF0131 2021-01-20
	..d TreeItem.%Set("children",children)
	..d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)		//CZF0131 2021-01-20
	
	q ReturnInfo
	
ResetVariables
	s (TDesc,TCode)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// Add By CSJ 2020-10-22
/// 描述:效益分析数据穿透显示
/// 入参:parid 父节点id
/// 返回值:分类树JSON字符串
/// w ##class(web.DHCEQ.Plat.LIBTree).GetBaShowListStr()
ClassMethod GetBaShowListStr(ItemName As %String = "")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20 begin
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ChildTree=##class(web.DHCEQ.Plat.LIBTree).GetBaCatListStr(ItemName)
	d TreeItem.%Set("id","top")
	d TreeItem.%Set("text","专用设备")
	d TreeItem.%Set("children",ChildTree)
#;	d TreeItem.%Set("state","closed")
	d ReturnInfo.Insert(TreeItem)

	q ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(ReturnInfo)	//CZF0131 2021-01-20 end
}

/// Add By CSJ 2020-10-23
/// 描述:效益分析数据穿透显示
/// 入参:parid 父节点id
/// 返回值:分类树JSON字符串
/// w ##class(web.DHCEQ.Plat.LIBTree).GetBaShowListStr()
ClassMethod GetBaCatListStr(ItemName As %String = "")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	s ChildTree=##class(web.DHCEQ.Plat.LIBTree).GetEquipAttributeTree(ItemName)
	d TreeItem.%Set("id","0")
	d TreeItem.%Set("text","用途")
	d TreeItem.%Set("children",ChildTree)
#;	d TreeItem.%Set("state","closed")
	d ReturnInfo.Insert(TreeItem)
	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	d TreeItem.%Set("id","1")
	d TreeItem.%Set("text","价值分类")
#;	d TreeItem.%Set("state","closed")
	d TreeItem.%Set("children",##class(%ListOfDataTypes).%New())	//CZF0131 2021-01-20
	d ReturnInfo.Insert(TreeItem)
	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	d TreeItem.%Set("id","2")
	d TreeItem.%Set("text","租赁中心设备")
#;	d TreeItem.%Set("state","closed")
	d TreeItem.%Set("children",##class(%ListOfDataTypes).%New())	//CZF0131 2021-01-20
	d ReturnInfo.Insert(TreeItem)

	q ReturnInfo
}

/// Add By CSJ 2020-10-23
/// 描述:生成设备属性树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
ClassMethod GetEquipAttributeTree(ItemName As %String = "")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	
	s childid=0
	for  s childid=$o(^DHCEQCCode("DHCEQCEquipAttribute",childid)) quit:childid=""  d
	.d ResetAttVariables
	.q:$P(^DHCEQCCode("DHCEQCEquipAttribute",childid),"^",5)="Y"
	.s ChildTree=##class(web.DHCEQ.Plat.LIBTree).GetItemTreeByAttr(childid,ItemName)
	.;q:ChildTree.%Size()=0
	.s TDesc=$P(^DHCEQCCode("DHCEQCEquipAttribute",childid),"^",2)
	.d TreeItem.%Set("children",ChildTree)
	.d TreeItem.%Set("id",childid)
	.d TreeItem.%Set("text",TDesc)
	.;d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)
	
	q ReturnInfo
	
ResetAttVariables
	s (TDesc,TCode)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// Add By CSJ 2020-10-23
/// 描述:设备项树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
ClassMethod GetItemTreeByAttr(AttributeDR As %String = "", ItemName As %String = "")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s childid=0
	if (AttributeDR'=""){
		for  s childid=$o(^DHCEQCCode("DHCEQCMasterItem",childid)) quit:childid=""  d
		.q:$o(^DHCEQEquipAttributeList(0,"AttributeSource",AttributeDR,1,childid,0))=""
		.d ResetItemVariables
		.q:$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",8)="Y"
		.q:$p($g(^DHCEQCCode("DHCEQCFinanceType",$p(^DHCEQCCode("DHCEQCEquipType",$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",3)),"^",9))),"^",2)'="专用设备" //过滤专用设备
		.;s ChildTree=##class(web.DHCEQ.Plat.LIBTree).GetEquipTreeByItemID(childid)
		.;q:ChildTree.%Size()=0
		.s TDesc=$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",1)
		.q:(ItemName'="")&&(TDesc'[ItemName)
		.;d TreeItem.%Set("children",ChildTree)
		.d TreeItem.%Set("id",childid)
		.d TreeItem.%Set("text",TDesc)
		.d TreeItem.%Set("click","true")
		.;d TreeItem.%Set("state","closed")
		.d ReturnInfo.Insert(TreeItem)
	}
	else{
		for  s childid=$o(^DHCEQCCode("DHCEQCMasterItem",childid)) quit:childid=""  d
		.d ResetItemVariables
		.q:$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",8)="Y"
		.q:$p($g(^DHCEQCCode("DHCEQCFinanceType",$p(^DHCEQCCode("DHCEQCEquipType",$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",3)),"^",9))),"^",2)'="专用设备" //过滤专用设备
		.s TDesc=$P(^DHCEQCCode("DHCEQCMasterItem",childid),"^",1)
		.q:(ItemName'="")&&(TDesc'[ItemName)
		.;q:##class(web.DHCEQ.Plat.LIBTree).GetEquipCountByItemID(childid)=0
		.d TreeItem.%Set("id",childid)
		.d TreeItem.%Set("text",TDesc)
		.d TreeItem.%Set("click","true")
		.d ReturnInfo.Insert(TreeItem)
	}
	q ReturnInfo
	
ResetItemVariables
	s (TDesc,TCode)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBTree","GetEquipList")
Query GetEquipList(ItemDR) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TNo,TWorkLoadNum,TUseLoc,TModel,TManuFactory,TProvider,TOpenCheckDate,TStartDate")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, ItemDR) As %Status
{
	s gnum=1
	Set repid=$I(^CacheTemp)
	Set index=1
 	Set qHandle=$lb(0,repid,0)
 	i ItemDR="" q $$$OK
	s rowid=0
	for  s rowid=$o(^DHCEQEquip(0,"Item",ItemDR,"N",rowid)) quit:rowid=""  d
	.d ResetVariablesGetEquipList
	.s EquipData=^DHCEQEquip(rowid)
	.s TWorkLoadNum=..GetWorkLoadNumByEquipID(rowid)
	.q:(TWorkLoadNum="")||(TWorkLoadNum=0)
	.s TRowID=rowid
	.s TName=$P(EquipData,"^",1)
	.s TUseLoc=$p(EquipData,"^",67)	//使用科室
	.s TModel=$p(EquipData,"^",3)		//规格型号
	.s TManuFactoryDR=$p(EquipData,"^",26)	//生产厂家
	.s TProviderDR=$p(EquipData,"^",25)	//供应商
 	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
 	.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //modify by mwz 20210415 MWZ0046
	.s TOpenCheckDate=$p(EquipData,"^",12)		//开箱日期
	.i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
	.s TStartDate=$p(EquipData,"^",44)			//启用日期
	.i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
 	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
 	.s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc) //modify by mwz 20210415 MWZ0046
	.s TNo=$P(^DHCEQEquip(rowid),"^",71)
	.d OutputRowGetEquipList
	quit $$$OK
ResetVariablesGetEquipList
	s (TRowID,TName,TNo,TWorkLoadNum,TUseLoc,TModel,TManuFactory,TProvider,TOpenCheckDate,TStartDate)=""
	quit

	//add by CZF0097 2020-03-23
OutputRowGetEquipList
	Set TRow=gnum	// 20150914  Mozy0165 序号
	s Data=$lb(TRowID,TName,TNo,TWorkLoadNum,TUseLoc,TModel,TManuFactory,TProvider,TOpenCheckDate,TStartDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	s gnum=gnum+1
	
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

/// Add By CSJ 2020-10-23
/// 描述:设备项树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
ClassMethod GetServiceItemByPatientID(EquipDR, LocID, PatientID)
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	
	s usid=""
	f  s usid=$o(^DHCEQUseRecord(0,"PatientID",1,EquipDR,LocID,PatientID,usid)) quit:usid=""  d
	.q:$P(^DHCEQUseRecord(usid),"^",20)="Y"
	.d ResetURVariables
	.s ServiceItemDR=$P(^DHCEQUseRecord(usid),"^",15)
	.i ServiceItemDR'="" s ServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",1)
	.s TDesc=ServiceItem
	.d TreeItem.%Set("id",ServiceItemDR)
	.d TreeItem.%Set("text",TDesc)
	.;d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)

	
	q ReturnInfo
	
ResetURVariables
	s (TDesc,TCode,ServiceItem)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// Add By CSJ 2020-10-23
ClassMethod GetWorkLoadNumByEquipID(EquipDR)
{
	i EquipDR="" quit 0
	s WorkLoadNum=0
	s (WorkLoadNumUnitDR,WorkLoadNumUnit)=""
		
#;	s urid=0
#;	for  s urid=$o(^DHCEQUseRecord(0,"Source",1,EquipDR,urid)) quit:urid=""  d
#;	.q:$P(^DHCEQUseRecord(urid),"^",20)="Y"
#;	.s WorkLoadNum=WorkLoadNum+$P(^DHCEQUseRecord(urid),"^",7)
#;	.s WorkLoadNumUnitDR=$P(^DHCEQUseRecord(urid),"^",8)
#;	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)

	&SQL(SELECT TOP 1 SUM(UR_WorkLoadNum),UR_WorkLoadUnitDR into:WorkLoadNum,:WorkLoadNumUnitDR FROM SQLUSER.DHC_EQUseRecord WHERE UR_InvalidFlag!='Y' AND UR_SourceType=1 AND UR_SourceID=:EquipDR)
	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)
	i WorkLoadNumUnit="" s WorkLoadNumUnit="次"
	i WorkLoadNum="" s WorkLoadNum=0
	q WorkLoadNum_WorkLoadNumUnit
}

/// Add By CSJ 2020-10-23
/// w ##class(web.DHCEQ.Plat.LIBTree).GetServiceItemWorkLoadNum(5,934)
ClassMethod GetServiceItemWorkLoadNum(EquipDR, ServiceItem)
{
	s WorkLoadNum=0
	s (WorkLoadNumUnitDR,WorkLoadNumUnit)=""
#;	s urid=0
#;	for  s urid=$o(^DHCEQUseRecord(0,"EquipService",1,EquipDR,ServiceItem,urid)) quit:urid=""  d
#;	.q:$P(^DHCEQUseRecord(urid),"^",20)="Y"
#;	.s WorkLoadNum=WorkLoadNum+$P(^DHCEQUseRecord(urid),"^",7)
#;	.s WorkLoadNumUnitDR=$P(^DHCEQUseRecord(urid),"^",8)
#;	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)

	&SQL(SELECT TOP 1 SUM(UR_WorkLoadNum),UR_WorkLoadUnitDR into:WorkLoadNum,:WorkLoadNumUnitDR FROM SQLUSER.DHC_EQUseRecord WHERE UR_InvalidFlag!='Y' AND UR_SourceType=1 AND UR_SourceID=:EquipDR AND UR_ServiceItemDR=:ServiceItem)
	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)
	i WorkLoadNumUnit="" s WorkLoadNumUnit="次"
	i WorkLoadNum="" s WorkLoadNum=0
	q WorkLoadNum_WorkLoadNumUnit
}

/// Add By CSJ 2020-10-23
ClassMethod GetPatientWorkLoadNum(EquipDR, ServiceItemDR, PatientID)
{
	s PatientIDWorkLoadNum=0
	s PatientFee=0
	s (WorkLoadNumUnit,WorkLoadNumUnitDR)=""

	s urid=0
 	f  s urid=$o(^DHCEQUseRecord(0,"SourceServicePatient",1,EquipDR,ServiceItemDR,PatientID,urid)) quit:urid=""  d
	.q:$P(^DHCEQUseRecord(urid),"^",20)="Y"
	.s PatientIDWorkLoadNum=PatientIDWorkLoadNum+$P(^DHCEQUseRecord(urid),"^",7)
	.s PatientFee=PatientFee+$P(^DHCEQUseRecord(urid),"^",12)
	s WorkLoadNumUnitDR=$P(^DHCEQUseRecord($o(^DHCEQUseRecord(0,"SourceServicePatient",1,EquipDR,ServiceItemDR,PatientID,0))),"^",8)
	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)
#;	&SQL(SELECT TOP 1 SUM(UR_WorkLoadNum),UR_WorkLoadUnitDR into:PatientIDWorkLoadNum,:WorkLoadNumUnitDR FROM SQLUSER.DHC_EQUseRecord WHERE UR_InvalidFlag!='Y' AND UR_SourceType=1 AND UR_SourceID=:EquipDR AND UR_ServiceItemDR=:ServiceItemDR AND UR_PatientID=:PatientID)
#;	s WorkLoadNumUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadNumUnitDR)
	i WorkLoadNumUnit="" s WorkLoadNumUnit="次"
	i PatientIDWorkLoadNum="" s PatientIDWorkLoadNum=0
	q PatientIDWorkLoadNum_WorkLoadNumUnit_"^"_PatientFee
}

/// Add By CSJ 2020-10-23
/// 描述:设备项树JSON对象
/// 入参:parid 父节点id
/// 返回值:JSON对象
/// w ##class(web.DHCEQ.Plat.LIBTree).GetServiceItemByEquipID()
ClassMethod GetServiceItemByEquipID(EquipDR, pServiceItem As %String = "")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s serviceitemdr=""
	for  s serviceitemdr=$o(^DHCEQUseRecord(0,"EquipService",1,EquipDR,serviceitemdr)) quit:serviceitemdr=""  d
	.d ResetServItmVariables
	.;s TWorkloadNum=..GetServiceItemWorkLoadNum(EquipDR,serviceitemdr)
	.;q:TWorkloadNum=0
	.s ServiceItem=$p($g(^DHCEQCCode("DHCEQCServiceItem",serviceitemdr)),"^",1)
	.q:(pServiceItem'="")&&(ServiceItem'[pServiceItem)
	.s TDesc=ServiceItem ;_"("_TWorkloadNum_")"
	.d TreeItem.%Set("id",serviceitemdr)
	.d TreeItem.%Set("text",TDesc)
	.;d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)
	
	q ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(ReturnInfo)	//CZF0131 2021-01-20
	
ResetServItmVariables
	s (TDesc,TCode,ServiceItem)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBTree","GetPatientList",116,13385)
Query GetPatientList(ServiceItemDR, EquipDR As %String = "") As %Query(ROWSPEC = "TRowID,PatientName,PatientAge,PatientSex,UseDate,PatientWorkLoadNum,PatientWorkLoadFee")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, ServiceItemDR, EquipDR As %String = "") As %Status
{
	s gnum=1
	Set repid=$I(^CacheTemp)
	Set index=1
 	Set qHandle=$lb(0,repid,0)
 	i ServiceItemDR="" quit $$$OK
 	s PatientID=0
 	f  s PatientID=$o(^DHCEQUseRecord(0,"SourceServicePatient",1,EquipDR,ServiceItemDR,PatientID)) quit:PatientID=""  d
 	.d ResetVariablesGetPatientList
 	.s urid=$o(^DHCEQUseRecord(0,"SourceServicePatient",1,EquipDR,ServiceItemDR,PatientID,0))
	.s PatientName=$P(^DHCEQUseRecord(urid),"^",46)
	.s PatientAge=$P(^DHCEQUseRecord(urid),"^",45)
    .//modified by ZY 20221009  2948101
    .;i PatientAge'="" s PatientAge=$ZD(PatientAge,3)    ;##class(web.DHCClinicCom).CalAge(PatientAge,+$h)
    .s PatientAge=##class(web.DHCEQCommon).TransValueToPage(PatientAge,"date")
    .s PatientSex=$Case($P(^DHCEQUseRecord(urid),"^",44),"M":"男","F":"女","":"") //modified by ZY0261 20210506
    .s UseDate=$P(^DHCEQUseRecord(urid),"^",3)  
    .//modified by ZY 20221009  2948101
    .;i UseDate'="" s UseDate=$ZD(UseDate,3)
    .s UseDate=##class(web.DHCEQCommon).TransValueToPage(UseDate,"date")
	.s PatientWorkLoadNum=..GetPatientWorkLoadNum(EquipDR,ServiceItemDR,PatientID)
	.s PatientWorkLoadFee=$p(PatientWorkLoadNum,"^",2)
	.s PatientWorkLoadNum=$p(PatientWorkLoadNum,"^",1)
	.q:PatientWorkLoadNum=0
	.d OutputRowGetPatientList
	
	quit $$$OK
ResetVariablesGetPatientList
	s (PatientName,PatientWorkLoadNum,PatientAge,PatientSex,UseDate,PatientWorkLoadNum,PatientWorkLoadFee)=""
	quit

OutputRowGetPatientList
	s Data=$lb(PatientID,PatientName,PatientAge,PatientSex,UseDate,PatientWorkLoadNum,PatientWorkLoadFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	
	quit
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By CZF 2021-06-22
/// 描述:获取设备级别树JSON字符串
/// 入参:parid 父节点id
/// 返回值:分类树JSON字符串
/// w ##class(web.DHCEQ.Plat.LIBTree).GetTreeMapTreeStr(0,1,0)
ClassMethod GetTreeMapTreeStr(parid As %String = "0", Type As %String = "1", isShow As %String = "1")
{
    s JsonObj=..GetTreeMapTree(parid,Type)
    s objType=JsonObj.%ClassName()
    i (objType="%ArrayOfDataTypes")||(objType="%ListOfDataTypes")
    {
        i isShow="1"  //modify by cjc 2022/08/30
        {
            //科室级别树,没有维护级别的科室数据也显示出来 czf 2022-07-04
            s childrenArrObj=JsonObj.GetAt(1).children
            i childrenArrObj="" s childrenArrObj=##class(%ListOfDataTypes).%New()
            s DeptRowID=0
            f  s DeptRowID = $o(^DHCEQCCode("DHCEQCDepartment",DeptRowID)) q:DeptRowID=""  d
            .q:$p($g(^DHCEQCCode("DHCEQCDepartment",DeptRowID)),"^",19)="Y"
            .s FilterFalg=0
            .s TreeMapID=0
            .f  s TreeMapID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID",Type,DeptRowID,TreeMapID)) q:(TreeMapID="")||(FilterFalg'=0)  d
            ..q:$p($g(^DHCEQCCode("DHCEQCTreeMap",TreeMapID)),"^",12)="Y"
            ..s FilterFalg=1
            .q:FilterFalg'=0
            .s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()
            .d TreeItem.%Set("id",DeptRowID)
            .q:('$D(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,DeptRowID)))&&('$D(^DHCEQCCode("DHCEQCLocType",0,"LocType",2,DeptRowID)))	//modify by fx 2022/12/06
            .d TreeItem.%Set("text",##Class(web.DHCEQCommon).GetTrakNameByID("dept",DeptRowID))
            .d childrenArrObj.Insert(TreeItem)
            i JsonObj.GetAt(1).children="" d
            .d JsonObj.GetAt(1).%Set("children",childrenArrObj)
            .d JsonObj.GetAt(1).%Set("state","closed")
        }
        s StreamStr= ##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(JsonObj,1)
        d StreamStr.OutputToDevice()
        q ""
    }
    else
    {
        q JsonObj.%ToJSON()
    }
}

/// Add By CZF 2021-06-22
/// 描述:获取设备级别树JSON字符串,不能使用Not ProcedureBlock
/// 入参:parid 父节点id
/// 返回值:JSON对象
/// w ##class(web.DHCEQ.Plat.LIBTree).GetTreeMapTree(0,1)
ClassMethod GetTreeMapTree(parid As %String = "0", Type As %String = "1")
{
	s ReturnInfo=##class(%ListOfDataTypes).%New()	//CZF0131 2021-01-20
	s childid=0
	for  s childid=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",parid,childid)) quit:childid=""  d
	.d ResetVariables
	.q:$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",12)="Y"
	.q:(Type'="")&&(Type'=$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",2))
	.s ParentCatDR=$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",4)
	.s TTreeID=$P(^DHCEQCCode("DHCEQCTreeMap",childid),"^",3)
	.s TDesc=##class("web.DHCEQCTreeMap").GetTreeDesc(childid)
	.d TreeItem.%Set("id",TTreeID)
	.d TreeItem.%Set("text",TDesc)
	.i $d(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",childid)) d
	..s children=..GetTreeMapTree(childid,1)
	..q:children.Count()=0
	..d TreeItem.%Set("children",children)
	..d TreeItem.%Set("state","closed")
	.d ReturnInfo.Insert(TreeItem)
	q ReturnInfo
ResetVariables
	s (TDesc,TTreeID)="" 	
	s TreeItem=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20
	quit
}

/// Creator: CJC  
/// CreatDate: 2022-09-03
/// Description:  科室级别树查询
/// Input: Dept,ParDept,DeptLevel("1"--包含层级,"2"--不包含层级,"3"--全部)
/// Output: Data:(TRowID,TCode,TDesc,TParCode,TParDesc,TInvalidFlag)
/// others: isNode--是否显示存在级别树内的节点(Y显示，N不显示)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBTree","GetLocList","","","","","","3")
Query GetLocList(parid As %String = "0", Type As %String = "1", isNode As %String = "N", Dept As %String = "", ParDept As %String = "", DeptLevel As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TParCode:%String,TParDesc:%String,TInvalidFlag:%String,TJob:%String")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, parid As %String = "0", Type As %String = "1", isNode As %String = "N", Dept As %String = "", ParDept As %String = "", DeptLevel As %String = "3", Job As %String = "") As %Status
{
    
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s Dept=$ZCONVERT(Dept ,"U")
    s ParDept=$ZCONVERT(ParDept ,"U")
    s index=1
    s DeptRowID=0
    s TJob=$J
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //%session.Get("LOGON.USERID")
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("Department",TJob,curuser)  //清除临时数据
    s gnum=1  //设置临时数据索引
    f  s DeptRowID = $o(^DHCEQCCode("DHCEQCDepartment",DeptRowID)) q:DeptRowID=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCDepartment",DeptRowID)),"^",19)="Y"
    .d ResetVariablesGetLocList
    .s TRowID=DeptRowID
    .s LocTypeID=0   ///过滤属性为库房的科室 begin
    .s LocTypeRowID=0
    .s LocTypeID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType","2",TRowID,LocTypeID))
    .q:(LocTypeID="")
    .s LocTypeRowID=$p($g(^DHCEQCCode("DHCEQCLocType",LocTypeID)),"^",2) ///过滤属性为库房的科室 end
    .s TCode = ##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TRowID)
    .s TDesc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRowID)
    .q:(Dept'="")&&($ZCONVERT(TDesc,"U")'[Dept)
    .s TreeMapID=0
    .s TTreeMapID=0
    .S TParID=0
    .// MZY0149	3124625		2023-01-09	修正索引
    .f  s TreeMapID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID","1",TRowID,TreeMapID)) q:(TreeMapID="")  d
    ..q:$p($g(^DHCEQCCode("DHCEQCTreeMap",TreeMapID)),"^",12)="Y"
    ..s TTreeMapID=TreeMapID
    ..s TParID=$p($g(^DHCEQCCode("DHCEQCTreeMap",TreeMapID)),"^",4)
    .q:((DeptLevel="1")&&(TTreeMapID=0))
    .q:((DeptLevel="2")&&(TTreeMapID'=0))
    .if TreeMapID'=0  d
    ..s TParDeptRowID =$p($g(^DHCEQCCode("DHCEQCTreeMap",TParID)),"^",3)
    ..if (TParDeptRowID'="科室级别树")  d
    ...s TParCode = ##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TParDeptRowID)
    ...s TParDesc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TParDeptRowID)
    ..e  d
    ...s TParCode = TParDeptRowID
    ...s TParDesc = TParDeptRowID
    .q:(ParDept'="")&&($ZCONVERT(TParDesc,"U")'[ParDept)
    .d OutputRowGetLocList
    Quit $$$OK
    
OutputRowGetLocList
    s Data=$lb(TRowID,TCode,TDesc,TParCode,TParDesc,TInvalidFlag,TJob)
    s tmpValue=TCode_"^"_TDesc_"^"_TParCode_"^"_TParDesc  //将想要导出的放入临时数据
    ;w tmpValue,!
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("Department",+$H,TJob,curuser,gnum,tmpValue)  //设置临时global
    s gnum=gnum+1
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetLocList
    s (TRowID,TCode,TDesc,TParCode,TParDesc,TInvalidFlag,TParDeptRowID) =""
    quit
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ActionExecute ]
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

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ActionExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:  CJC  
/// CreatDate: 2022-09-06
/// Description: 科室级别树增删改查
/// Table: DHC_EQCTreeMap
/// Input：data:前台获取字符串 field:value,filed:vale  DelIs:操作类型：（0：新增与修改）,（1：删除）
/// Return： Json
/// 增加：w ##class(web.DHCEQ.Plat.LIBTree).SaveData("{""TMSourceType"":""CT_Loc"",""TMType"":""1"",""TMRowID"":"""",""TMTreeID"":""10"",""TMParTreeID"":""8"",""TM_InvalidFlag"":""N""}","0")
/// 删除：w ##class(web.DHCEQ.Plat.LIBTree).SaveData("","1")，引号内输入treeid
ClassMethod SaveData(Data, DelIs As %Library.String = "")
{
    new ( %session)
    s $ZT="ERRORGetLocList"
    s SQLCODE=0
    k PLIST,RowID
    s TableName="DHC_EQCTreeMap"
    s ClassName="User.DHCEQCTreeMap"
    s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
    s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
    s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
    
    TSTART
    if DelIs=1
    {   
        s RowID=Data
        s BussID=RowID
        &SQL(Update SQLUSER.DHC_EQCTreeMap set TM_InvalidFlag='Y' where TM_TreeID = :RowID)
        If SQLCODE
        {   
            TRollback
            q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
        }
        s Rtn=##Class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"U","{""TMInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
        i Rtn
        {
            TRollback 
            q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",Rtn) 
        }
        TCommit
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
    }
    else
    {
        s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
        s PLIST = ##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCTreeMap",JsonData,.PLIST)
        s index=0
        s TMRowID=""

        f  s index=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID","1",JsonData.TMParTreeID,index)) quit:(index="")||(TMRowID'="")  d
        .q:$p($g(^DHCEQCCode("DHCEQCTreeMap",index)),"^",12)="Y"
        .s TMRowID=index
        s RowID = JsonData.TMRowID
        s PLIST(13) = "N"   
        s PLIST(5)=TMRowID
        s tmpid=""
        //判断数据是否重复
        if RowID = "" //RowID为空进行新增操作
        {
            //当treeid等数据重复时不能插入
            &SQL(select TM_RowID into :tmpid from SQLUSER.DHC_EQCTreeMap where TM_TreeID=:PLIST(4) and TM_InvalidFlag=:PLIST(13)) 
            if (tmpid="")  //添加新数据，并且设置删除标志位为N
            {
                s PLIST(13)="N"
                s BussID=RowID,OperateType="A"
                &SQL(insert into SQLUSER.DHC_EQCTreeMap values :PLIST())
                s RowID=$g(%ROWID) // 获取新增rowid
            }
            else      //修改删除标志位 Y->N
            {
                s PLIST(13)="N"
                s BussID=RowID,OperateType="D"
                s OldObject=##Class(User.DHCEQCTreeMap).%OpenId(BussID)
                s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
                &SQL(Update SQLUSER.DHC_EQCTreeMap values :PLIST() where TM_RowID=:tmpid)
            }
        }
        else
        {
            s BussID=RowID,OperateType="D"
            s OldObject=##Class(User.DHCEQCTreeMap).%OpenId(BussID)
            s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
            &SQL(Update SQLUSER.DHC_EQCTreeMap Values :PLIST() where TM_RowID = :RowID)
        }
        s OldObject=""  //先关闭对象
        s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCTreeMap).%OpenId(RowID))
        s BussID=RowID
        s NewObj=FinalObj
        i NewObj.%ToJSON()'="{}"    //本次未更新则不记录
        {
            s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
            If Rtn
            {
                TRollback
                q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",Rtn) 
            }
        }
        
        TCommit
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
    }
    TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORGetLocList
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
