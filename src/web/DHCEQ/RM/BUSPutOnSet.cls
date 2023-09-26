/// 名称: web.DHCEQ.RM.BUSPutOnSet
/// 描述: 设备租赁上架设置
/// 编写者：ZX
/// 编写日期: 2019-12-17
/// 产品组：设备管理
Class web.DHCEQ.RM.BUSPutOnSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   上架设置数据保存
/// Input：        data:前台获取字符串 {"field":"value","field":"value",...}  Type 操作类型：(1：删除),(2：新增),(其他:保存)
/// Return：       Json数据 {"SQLCODE":SQLCODE,"RowID":RowID或错误码}
ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORPutOnSet"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set HosptailID=%session.Get("LOGON.HOSPID") //Add by QW20200506 增加院区
	s Date=+$H
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSPutOnSet",JsonData,.PLIST)
	s RowID = JsonData.POSRowID
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQSPutOnSet set POS_Status='3' where POS_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		if $d(^DHCEQSShareResource(0,"PutOnSet",RowID))
		{
			&SQL(update sqluser.DHC_EQSShareResource set RE_PutOnFlag='N' where RE_PutOnSetDR=:RowID)
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
	}
	ELSE
	{
		//Add by QW20200506 Bug:QW0059 需求号:1294273
		if ((PLIST(12)'="")&&(PLIST(13)'=""))
		{
			if (PLIST(12)>PLIST(13)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9212")
		}
		//Add by QW20200506 Bug:QW0059 需求号:1294273
		//Modified by QW20200506 判断当前登录科室是否是租赁中心 begin
		s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(LocID)
		if (LocIDType=1)&&(JsonData.POSShareItemDR="")  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3404")
		if (LocIDType=1) s PLIST(14)="2"  //租赁中心状态默认审核
		else  s PLIST(14)="1"  //状态默认提交
		//Modified by QW20200506  end
		//Modify by zx 2020-04-09 BUG ZX0083
		s EquipID=JsonData.POSEquipDR
		s ItemID=JsonData.POSItemDR
		s Model=JsonData.POSModelDR
		s Loc=JsonData.POSLocDR
		s TmpID=""
		;数据重复在调用此方法前已检测
		i EquipID'="" d
		.;首先检测是否有无效的设备,直接恢复原数据
		.&SQL(Select POS_RowID Into :TmpID from SQLUSER.DHC_EQSPutOnSet Where POS_EquipDR=:EquipID and POS_Status='3')
		i (TmpID="")&&(ItemID'="") d
		.;再检测无效的设备项,直接恢复原数据，暂时只考虑设备项一致
		.&SQL(Select POS_RowID Into :TmpID from SQLUSER.DHC_EQSPutOnSet Where POS_ItemDR=:ItemID and POS_ModelDR=:Model and POS_LocDR=:Loc and POS_Status='3')
		//Modify by zx 2020-04-09 BUG ZX0083
		i (RowID'="")&&(TmpID'="")&&(TmpID'=RowID) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3403")
		i TmpID'="" s RowID=TmpID
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQSPutOnSet Values :PLIST() where POS_RowID = :RowID)
		}
		else
		{	
			Set PLIST(7)=HosptailID //Add by QW20200506 增加院区
			&SQL(insert into SQLUSER.DHC_EQSPutOnSet Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
		//Modify by zx 2020-04-09 BUG ZX0083
		//有共享资源存在先集体下架
		if $d(^DHCEQSShareResource(0,"PutOnSet",RowID))
		{
			&SQL(update sqluser.DHC_EQSShareResource set RE_PutOnFlag='N' where RE_PutOnSetDR=:RowID)
			If SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
		//为自动上架时集体上架
		i JsonData.POSAutoPutOnFlag="1"
		{
			s SQLCODE=##Class(web.DHCEQ.RM.BUSPutOnSet).SavaShareResourceBySet(RowID)
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORPutOnSet
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   解析单条上架设置信息
/// Table：        DHC_EQSPutOnSet
/// Input：        RowID:上架设置表ID
/// Return：       表数据解析 json返回{"field":"value","field":"value",...}
/// w ##Class(web.DHCEQ.RM.BUSPutOnSet).GetOnePutOnSet(1)
ClassMethod GetOnePutOnSet(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOnePutOnSet"
	s ObjPutOnSet=##Class(User.DHCEQSPutOnSet).%OpenId(RowID)
	s PutOnSetInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjPutOnSet)
	d PutOnSetInfo.%Set("POSEquipDR_EQName",ObjPutOnSet.POSEquipDR.EQName)
	//Modify by zx 2020-04-10 BUG ZX0083
	i ObjPutOnSet.POSSubID'="" d PutOnSetInfo.%Set("POSSub",$p($g(^DHCEQBuildingUnit(ObjPutOnSet.POSSubID)),"^",2))
	d PutOnSetInfo.%Set("POSItemDR_MIDesc",ObjPutOnSet.POSItemDR.MIDesc)
	d PutOnSetInfo.%Set("POSModelDR_MDesc",ObjPutOnSet.POSModelDR.MDesc)
	d PutOnSetInfo.%Set("POSLocDR_DeptDesc",ObjPutOnSet.POSLocDR.DeptDesc)
	i ObjPutOnSet.POSHospitalDR'="" d PutOnSetInfo.%Set("POSHospitalDR_HOSPDesc",$p($g(^CT("HOSP",ObjPutOnSet.POSHospitalDR)),"^",2))
	d PutOnSetInfo.%Set("POSManageLocDR_DeptDesc",ObjPutOnSet.POSManageLocDR.DeptDesc)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,PutOnSetInfo)
ERRORGetOnePutOnSet
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   设备上架设置明细查询
/// Input：        ShareType:资源类型 EquipDR:设备ID SubID:辅助信息ID ItemDR:设备项ID ModelDR:机型ID HospitalDR:医院ID LocDR:科室ID ManageLocDR:管理科室ID AutoPutOnFlag:是否自动上架 OuterType:共享类型 FromDate:设置开始日期 ToDate:设置截止日期
/// Modified By QW20200506 增加入参Status,POSShareItemDR 出参POSShareItemDR,POSShareItem
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSPutOnSet","GetPutOnSet","0")
Query GetPutOnSet(ShareType As %String = "", EquipDR As %String = "", SubID As %String = "", ItemDR As %String = "", ModelDR As %String = "", HospitalDR As %String = "", LocDR As %String = "", ManageLocDR As %String = "", AutoPutOnFlag As %String = "", OuterType As %String = "", FromDate As %String = "", ToDate As %String = "", Status As %String = "", POSShareItemDR As %String = "") As %Query(ROWSPEC = "POSRowID:%String,POSShareType:%String,POSShareTypeDesc:%String,POSEquipDR:%String,POSEquipDR_EQName:%String,POSEquipDR_EQEquipNo:%String,POSSubID:%String,POSSub:%String,POSItemDR:%String,POSItemDR_MIDesc:%String,POSModelDR:%String,POSModelDR_MDesc:%String,POSHospitalDR:%String,POSHospitalDR_HOSPDesc:%String,POSLocDR:%String,POSLocDR_DeptDesc:%String,POSManageLocDR:%String,POSManageLocDR_DeptDesc:%String,POSAutoPutOnFlag:%String,POSAutoPutOnFlagDesc:%String,POSOuterType:%String,POSOuterTypeDesc:%String,POSFromDate:%String,POSToDate:%String,POSStatus:%String,POSStatusDesc:%String,POSUpdateUserDR:%String,POSUpdateUserDR_UName:%String,POSSubmitUserDR:%String,POSSubmitUserDR_UName:%String,POSAuditUserDR:%String,POSAuditUserDR_UName:%String,POSHold1:%String,POSHold2:%String,POSHold3:%String,POSHold4:%String,POSHold5:%String,POSShareItemDR:%String,POSShareItemDR_SIDesc:%String")
{
}

ClassMethod GetPutOnSetExecute(ByRef qHandle As %Binary, ShareType As %String = "", EquipDR As %String = "", SubID As %String = "", ItemDR As %String = "", ModelDR As %String = "", HospitalDR As %String = "", LocDR As %String = "", ManageLocDR As %String = "", AutoPutOnFlag As %String = "", OuterType As %String = "", FromDate As %String = "", ToDate As %String = "", Status As %String = "", POSShareItemDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s ^DHCEQZX("S",2)=ShareType_"^"_EquipDR_"^"_SubID_"^"_ItemDR_"^"_ModelDR_"^"_HospitalDR_"^"_LocDR_"^"_ManageLocDR_"^"_AutoPutOnFlag_"^"_OuterType_"^"_FromDate_"^"_ToDate_"^"_Status_"^"_POSShareItemDR
	//add by lmm 2020-04-02 1255743
	i FromDate'="" s FromDate=##class(web.DHCEQCommon).TransValueFromPage(FromDate,"date")
	i ToDate'="" s ToDate=##class(web.DHCEQCommon).TransValueFromPage(ToDate,"date")
	i (AutoPutOnFlag="true")||(AutoPutOnFlag="Y")
	{
		s AutoPutOnFlag=1
	}
	else
	{
		s AutoPutOnFlag=""
	}
	//Add by QW20200507 判断当前登录科室是否是租赁中心 begin
	s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(LocID)
	//Add by QW20200507 end
	f  s rowid=$o(^DHCEQSPutOnSet(rowid))  quit:rowid=""  d
	.d ResetVariablesGetPutOnSet
	.s TRowID = rowid
	.s TShareType = $p($g(^DHCEQSPutOnSet(rowid)),"^",1)
	.q:(ShareType'="")&&(ShareType'=TShareType)
	.s TShareTypeDesc =$CASE(TShareType,"0":"设备", "1":"Room","":"")
	.s TEquipDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",2)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.i TEquipDR'="" d
	..s TEquipName = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TEquipNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TSubID = $p($g(^DHCEQSPutOnSet(rowid)),"^",3)
	.q:(SubID'="")&&(SubID'=TSubID)
	.i TSubID'="" s TSub=$p($g(^DHCEQBuildingUnit(TSubID)),"^",2)
	.s TItemDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",4)
	.q:(ItemDR'="")&&(ItemDR'=TItemDR)
	.i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.s TModelDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",5)
	.q:(ModelDR'="")&&(ModelDR'=TModelDR)
	.i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s THospitalDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",6)
	.q:(THospitalDR'="")&&(##Class(web.DHCEQCommon).CheckHOSLimit(THospitalDR)=0) ;Add by QW20200507
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	.s TLocDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",7)
	.;Modified By QW20200529 BUG:QW0064 Begin
	.;q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(LocIDType=0)&&(LocID'=TLocDR)
	.;Modified By QW20200529 BUG:QW0064 End
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TManageLocDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",8)
	.;q:(ManageLocDR'="")&&(ManageLocDR'=TManageLocDR)
	.q:(LocIDType=1)&&(LocID'=TManageLocDR) ;Modified By QW20200529 BUG:QW0064
	.i TManageLocDR'="" s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TAutoPutOnFlag = $p($g(^DHCEQSPutOnSet(rowid)),"^",9)
	.q:(AutoPutOnFlag'="")&&(AutoPutOnFlag'=TAutoPutOnFlag)
	.i TAutoPutOnFlag'="" s TAutoPutOnFlagDesc =$CASE(TAutoPutOnFlag,"0":"否", "1":"是")
	.s TOuterType = $p($g(^DHCEQSPutOnSet(rowid)),"^",10)
	.q:(OuterType'="")&&(OuterType'=TOuterType)
	.i TOuterType'="" s TOuterTypeDesc =$CASE(TOuterType,"0":"院内共享", "1":"院区共享","2":"院外共享") ;Modified by QW20200506 修改描述
	.s TFromDate = $p($g(^DHCEQSPutOnSet(rowid)),"^",11)
	.;modify by lmm 2020-04-02 1255743
	.q:(FromDate'="")&&(FromDate>TFromDate)
	.i TFromDate'="" s TFromDate=##class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")
	.s TToDate = $p($g(^DHCEQSPutOnSet(rowid)),"^",12)
	.q:(ToDate'="")&&(ToDate<TToDate)
	.i TToDate'="" s TToDate=##class(web.DHCEQCommon).TransValueToPage(TToDate,"date")
	.s TStatus = $p($g(^DHCEQSPutOnSet(rowid)),"^",13)
	.q:TStatus="3" //过滤作废
	.q:(Status'="")&&(TStatus'=Status)   ;Modified by QW20200512
	.i TStatus'="" s TStatusDesc =$CASE(TStatus,"0":"新增", "1":"提交","2":"已生效","3":"作废")		/// QW20200428	修正状态
	.s TUpdateUserDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",14)
	.i TUpdateUserDR'="" s TUpdateUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TSubmitUserDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",15)
	.i TSubmitUserDR'="" s TSubmitUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TAuditUserDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",16)
	.i TAuditUserDR'="" s TAuditUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s THold1 = $p($g(^DHCEQSPutOnSet(rowid)),"^",17)
	.s THold2 = $p($g(^DHCEQSPutOnSet(rowid)),"^",18)
	.s THold3 = $p($g(^DHCEQSPutOnSet(rowid)),"^",19)
	.s THold4 = $p($g(^DHCEQSPutOnSet(rowid)),"^",20)
	.s THold5 = $p($g(^DHCEQSPutOnSet(rowid)),"^",21)
	.;Add by QW20200506 资源项 begin
	.s TPOSShareItemDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",22)
	.if TPOSShareItemDR'="" s TPOSShareItem = $Piece($Get(^DHCEQSCShareItem(TPOSShareItemDR)),"^",3)
	.;Add by QW20200506 资源项 end
	.d OutputRowGetPutOnSet
	Quit $$$OK
OutputRowGetPutOnSet
	s Data=$lb(TRowID,TShareType,TShareTypeDesc,TEquipDR,TEquipName,TEquipNo,TSubID,TSub,TItemDR,TItem,TModelDR,TModel,THospitalDR,THospital,TLocDR,TLoc,TManageLocDR,TManageLoc,TAutoPutOnFlag,TAutoPutOnFlagDesc,TOuterType,TOuterTypeDesc,TFromDate,TToDate,TStatus,TStatusDesc,TUpdateUserDR,TUpdateUser,TSubmitUserDR,TSubmitUser,TAuditUserDR,TAuditUser,THold1,THold2,THold3,THold4,THold5,TPOSShareItemDR,TPOSShareItem) ;Modified By QW20200506 资源项 出参POSShareItemDR,POSShareItem
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPutOnSet
	s (TRowID,TShareType,TShareTypeDesc,TEquipDR,TEquipName,TEquipNo,TSubID,TSub,TItemDR,TItem,TModelDR,TModel,THospitalDR,THospital,TLocDR,TLoc,TManageLocDR,TManageLoc,TAutoPutOnFlag,TAutoPutOnFlagDesc,TOuterType,TOuterTypeDesc,TFromDate,TToDate,TStatus,TStatusDesc,TUpdateUserDR,TUpdateUser,TSubmitUserDR,TSubmitUser,TAuditUserDR,TAuditUser,THold1,THold2,THold3,THold4,THold5,TPOSShareItemDR,TPOSShareItem)=""  ;Modified By QW20200506 资源项 出参POSShareItemDR,POSShareItem
	quit
}

ClassMethod GetPutOnSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPutOnSetExecute ]
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

ClassMethod GetPutOnSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPutOnSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetShortPutOnSet(Desc As %String = "", LocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TShareType:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TSubID:%String,TSub:%String,TItemDR:%String,TItem:%String,TModelDR:%String,TModel:%String,TLocDR:%String,TLoc:%String,TOuterType:%String")
{
}

ClassMethod GetShortPutOnSetExecute(ByRef qHandle As %Binary, Desc As %String = "", LocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i LocID="" s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(LocID)  //判断当前登录科室是否是租赁中心
	s Desc=$ZCONVERT(Desc,"U")
	
	f  s rowid=$o(^DHCEQSPutOnSet(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSPutOnSet(rowid)),"^",13)'="2"
	.d ResetVariablesGetShortPutOnSet
	.s TRowID = rowid
	.s TShareType = $p($g(^DHCEQSPutOnSet(rowid)),"^",1)
	.s TShareType =$CASE(TShareType,"0":"设备", "1":"Room","":"")
	.s TEquipDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",2)
	.i TEquipDR'="" d
	..s TEquipName = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TEquipNo = $p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TSubID = $p($g(^DHCEQSPutOnSet(rowid)),"^",3)
	.i TSubID'="" s TSub=$p($g(^DHCEQBuildingUnit(TSubID)),"^",2)
	.s TItemDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",4)
	.i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.i TEquipName="" s TEquipName=TItem
	.q:(Desc'="")&&($ZCONVERT(TEquipNo,"U")'[Desc)&&($ZCONVERT(TEquipName,"U")'[Desc)
	.s TModelDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",5)
	.i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TLocDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",7)
	.q:(LocIDType'="1")&&(LocID'=TLocDR)  //非租赁中心无法选择其他科室上架设置
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TOuterType = $p($g(^DHCEQSPutOnSet(rowid)),"^",10)
	.i TOuterType'="" s TOuterType =$CASE(TOuterType,"0":"院内共享", "1":"院区共享","2":"院外共享") ;Modified by QW20200506 修改描述
	.d OutputRowGetShortPutOnSet
	Quit $$$OK
OutputRowGetShortPutOnSet
	s Data=$lb(TRowID,TShareType,TEquipDR,TEquipName,TEquipNo,TSubID,TSub,TItemDR,TItem,TModelDR,TModel,TLocDR,TLoc,TOuterType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortPutOnSet
	s (TRowID,TShareType,TEquipDR,TEquipName,TEquipNo,TSubID,TSub,TItemDR,TItem,TModelDR,TModel,TLocDR,TLoc,TOuterType)=""
	quit
}

ClassMethod GetShortPutOnSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortPutOnSetExecute ]
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

ClassMethod GetShortPutOnSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortPutOnSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2020-03-09
/// Description:   上架设置范围内设备集中上架
/// Input：        RowID:上架设置表ID
/// Return：       SaveResult:成功,0 失败,其他
/// w ##Class(web.DHCEQ.RM.BUSPutOnSet).SavaShareResourceBySet("2")
ClassMethod SavaShareResourceBySet(SRRowID)
{
	new SaveResult,EquipDR,ItemDR,ModelDR,EQModelDR,UseLocDR,EQUseLocDR,EQStatus,EQStockStatus
	s SaveResult="0"
	s EquipDR=$p($g(^DHCEQSPutOnSet(SRRowID)),"^",2)
	i EquipDR'="" d
	.s SaveResult=##Class(web.DHCEQ.RM.BUSShareResource).SaveShareResource(SRRowID,EquipDR)
	.s SaveResult=##class(web.DHCEQ.Plat.JsonObject).FromJSON(SaveResult)	//CZF0131 2021-01-20
	.s SaveResult=SaveResult.%Get("SQLCODE")
	e  d
	.s ItemDR=$p($g(^DHCEQSPutOnSet(SRRowID)),"^",4)
	.s ModelDR=$p($g(^DHCEQSPutOnSet(SRRowID)),"^",5)
	.s UseLocDR=$p($g(^DHCEQSPutOnSet(SRRowID)),"^",7)
	.s EQUseLocDR=0
	.;//Modefied by zc0089 2020-12-08 取设备索引改成库房 begin
	.;f  s EQUseLocDR=$o(^DHCEQEquip(0,"LocItem",EQUseLocDR)) q:(EQUseLocDR="")||(SaveResult'="0")  d
	.f  s EQUseLocDR=$o(^DHCEQEquip(0,"StoreLocItem",EQUseLocDR)) q:(EQUseLocDR="")||(SaveResult'="0")  d
	..q:(UseLocDR'="")&&(UseLocDR'=EQUseLocDR)
	..s EquipDR=0
	..;f  s EquipDR=$o(^DHCEQEquip(0,"LocItem",EQUseLocDR,ItemDR,EquipDR)) q:(EquipDR="")||(SaveResult'="0")  d
	..f  s EquipDR=$o(^DHCEQEquip(0,"StoreLocItem",EQUseLocDR,ItemDR,EquipDR)) q:(EquipDR="")||(SaveResult'="0")  d
	...;//Modefied by zc0089 2020-12-08 取设备索引改成库房 end
	...s EQModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	...q:(ModelDR'="")&&(ModelDR'=EQModelDR)
	...s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	...s EQStockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	...q:'((EQStockStatus="1")&&(EQStatus<=2))
	...s SaveResult=##Class(web.DHCEQ.RM.BUSShareResource).SaveShareResource(SRRowID,EquipDR)
	...s SaveResult=##class(web.DHCEQ.Plat.JsonObject).FromJSON(SaveResult)	//CZF0131 2021-01-20
	...s SaveResult=SaveResult.%Get("SQLCODE")
	
	q SaveResult
}

/// w ##Class(web.DHCEQ.RM.BUSPutOnSet).GetShareItem("356")
ClassMethod GetShareItem(Item)
{
	i Item="" q ""
	s SharItemID=""
	s SharItemListID=0
	f  s SharItemListID=$o(^DHCEQSCShareItemList(SharItemListID)) q:(SharItemListID="")||(SharItemID'="")  d
	.q:$p($g(^DHCEQSCShareItemList(SharItemListID)),"^",5)="Y"
	.q:$p($g(^DHCEQSCShareItemList(SharItemListID)),"^",2)'=Item
	.s SharItemID=$p($g(^DHCEQSCShareItemList(SharItemListID)),"^",1)
	
	q SharItemID
}

/// add by csj 2020-07-02 获取待审批上架设置数量 需求号：1396144
/// w ##Class(web.DHCEQ.RM.BUSPutOnSet).GetPutOnSetAuditNum()
ClassMethod GetPutOnSetAuditNum()
{
	s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(LocID)
	s PutOnSetAuditNum=0
	s rowid=0
	f  s rowid=$o(^DHCEQSPutOnSet(rowid))  quit:rowid=""  d
	.s TShareType = $p($g(^DHCEQSPutOnSet(rowid)),"^",1)
	.q:TShareType'=0
	.s THospitalDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",6)
	.q:(THospitalDR'="")&&(##Class(web.DHCEQCommon).CheckHOSLimit(THospitalDR)=0)
	.s TLocDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",7)
	.q:(LocIDType=0)&&(LocID'=TLocDR)
	.s TManageLocDR = $p($g(^DHCEQSPutOnSet(rowid)),"^",8)
	.q:(LocIDType=1)&&(LocID'=TManageLocDR) ;Modified By QW20200529 BUG:QW0064
	.i TManageLocDR'="" s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TStatus = $p($g(^DHCEQSPutOnSet(rowid)),"^",13)
	.q:TStatus'=1  
	.s PutOnSetAuditNum=PutOnSetAuditNum+1
	q PutOnSetAuditNum
}

}
