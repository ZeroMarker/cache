/// ----------------------------------
/// 创建:wy 2018-05-01  
/// 描述:新增、更新、删除
/// 重写配置清单的增删改查，同时将操作人操作时间信息存入DHC_EQOperateInfo
/// ----------------------------------
Class web.DHCEQConfig Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 32;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "C_RowID";

Parameter SQLDESCRIPTION = "C_RowID";

Parameter SQLROWID = "C_RowID";

/// 创建:wy 2018-4-27 
/// 描述:增加、修改数据
/// 入参： val保存信息字符串,Status	
/// 返回值：SQLCODE_"^"_rowid
/// 访问表:DHC_EQConfig
ClassMethod SaveData(val As %Library.String = "")
{
	Set $ZT="ERRORSave"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	k PLIST

	s rowid=$p(val,"^",1)
 	s PLIST(2) = $p(val,"^",2)	;C_Type
 	s PLIST(3) = $p(val,"^",3)	;C_SourceType
 	s PLIST(4) = $p(val,"^",4)	;C_SourceID
 	s PLIST(5) = $p(val,"^",5)	;C_ItemDR
 	s PLIST(6) = $p(val,"^",6)	;C_Item
	s PLIST(7) = $p(val,"^",7)	;C_Price
 	s PLIST(8) = $p(val,"^",8)	;C_QuantityNum
	s PLIST(9) = $p(val,"^",9)	;C_UnitDR
 	s PLIST(10) = $p(val,"^",10)  ;C_BrandDR
	s PLIST(11) = $p(val,"^",11)  ;C_VendorDR
	s PLIST(12) = $p(val,"^",12)  ;C_ManuFactoryDR
	s PLIST(13) = $p(val,"^",13)  ;C_Spec
	s PLIST(14) = $p(val,"^",14)  ;C_Model
	s PLIST(15) = $p(val,"^",15)  ;C_Parameters
	s PLIST(16) = $p(val,"^",16)  ;C_GuaranteePeriodNum
	s PLIST(17) = $p(val,"^",17)  ;C_CountryDR
	;s PLIST(18) = $p(val,"^",18)  ;C_LeaveFacNo
	s PLIST(18)=$TRANSLATE($p(val,"^",18),"，",",")
	s PLIST(19) = $p(val,"^",19)	;C_LeaveDate
	i $p(val,"^",19)'=""  s PLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")	
	s PLIST(20) = $p(val,"^",20)	;C_Location
	s PLIST(21) = $p(val,"^",21)	;C_ReceiverDR
 	s PLIST(22) = $p(val,"^",22)	;C_MeasureFlag
 	s PLIST(23) = $p(val,"^",23)	;C_GuaranteeStartDate
 	i $p(val,"^",23)'=""  s PLIST(23) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"date")
 	s PLIST(24) = $p(val,"^",24)	;C_GuaranteeEndDate
 	i $p(val,"^",24)'=""  s PLIST(24) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")
 	s PLIST(25) = $p(val,"^",25)	;C_DisuseFlag
 	s PLIST(26) = $p(val,"^",26)	;C_DisuseDate 
	s PLIST(27) = $p(val,"^",27)	;C_InvoiceNo
	s PLIST(28) = $p(val,"^",28)	;C_OpenFlag
	s PLIST(29) = $p(val,"^",29)	;C_Remark
	;s PLIST(30) = $p(val,"^",30)	;C_Status
 	;i PLIST(30)="" s PLIST(30)="0" //新增配置
 	;i PLIST(30)="2" s PLIST(30)="1"  //修改配置
 	s PLIST(37) = $p(val,"^",31)	;C_ServiceHandler
 	s PLIST(38) = $p(val,"^",32)	;C_ServiceTel
 	s PLIST(39) = $p(val,"^",33)	;C_Hold1
 	;s PLIST(40) = $p(val,"^",30)	;C_Hold2
 	;s PLIST(41) = $p(val,"^",30)	;C_Hold3
 	;s PLIST(42) = $p(val,"^",30)	;C_Hold4
 	;s PLIST(43) = $p(val,"^",30)	;C_Hold5
 	;s PLIST(44) = $p(val,"^",30)	;C_Hold6
 	TSTART
	s tmpid=""
	&SQL(select C_RowID into :tmpid from sqluser.DHC_EQConfig where C_Type=:PLIST(2) and C_SourceType=:PLIST(3) and C_SourceID=:PLIST(4) and C_ItemDR=:PLIST(5))
	if ((tmpid'="")&(SQLCODE'=100)&(tmpid'=rowid)) q "-3003^"	;重复记录
	if (rowid="")
	{
		s PLIST(30)="0" //新增配置
		&SQL(Insert Into SQLUSER.DHC_EQConfig Values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"
		}
 		s rowid=$g(%ROWID)
		 //插入操作信息表
		//modify by lmm 2020-03-05 LMM0062
		s SourceType="45"
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s OperateInfo="^"_SourceType_"^"_rowid_"^"_User_"^^0"

	 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
		//modify by lmm 2020-03-05 LMM0062
		 i SQLCODE
		 {
			 TROLLBACK
			 q SQLCODE_"^"
		 }	
	}
	else
	{
		
		
		//modify by lmm 2020-03-05 LMM0062
		s SourceType="45"
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s OperateInfo="^"_SourceType_"^"_rowid_"^"_User_"^^0"

	 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
	  	i SQLCODE
		{
	 		TROLLBACK
	 		q SQLCODE_"^"
		} 
		//modify by lmm 2020-03-05 LMM0062
		
		s PLIST(30)="1"  //修改配置
 	 	&SQL(Update SQLUSER.DHC_EQConfig Values :PLIST() where C_RowID = :rowid)
 	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	Quit SQLCODE_"^"
	 	} 	 
 	}
	TCOMMIT
 	q SQLCODE_"^"_rowid
ERRORSave 
	TRollBack
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息
}

/// 删除方法与新增跟新分开
/// 描述:根据rowid号删除数据
/// 入参： 	RowID 
/// 返回值：SQLCODE
ClassMethod DeleteData(RowID)
{
	s SQLCODE=0
	
	&SQL(delete from sqluser.DHC_EQConfig where C_RowID=:RowID  )
	q SQLCODE
}

// modify by lmm 2020-03-05 LMM0062 注释不用

/*
ClassMethod InsertOperateInfo(RowID, Status)
{
	k CHCPlist
	s CHCPlist(4)=+$H
	s CHCPlist(5)=$P($H,",",2)
	s CHCPlist(2)=$p($g(^DHCEQConfig(RowID)),"^",2)
	s CHCPlist(3)=RowID
	s CHCPlist(6)=%session.Get("LOGON.USERID")
	s CHCPlist(7)=Status
	&SQL(insert into sqluser.DHC_EQOperateInfo values :CHCPlist())
	q SQLCODE
}

/// 更新操作人信息表
ClassMethod UpdateOperateInfo(RowID, Status)
{
	k CHCPlist
	s CHCPlist(7)="1"
	s CHCPlist(2)=$p($g(^DHCEQConfig(RowID)),"^",2)
	s CHCPlist(3)=RowID
	s CHCPlist(6)=%session.Get("LOGON.USERID")
	s CHCPlist(4)=+$H
	s CHCPlist(5)=$P($H,",",2)
	s OIRowID=##class(web.DHCEQConfig).GetOperateInfo(RowID)
	&SQL(update sqluser.DHC_EQOperateInfo values :CHCPlist() where OI_RowID=:OIRowID)
	q SQLCODE
}

/// 判断选择DHC_EQOperateInfo的RowID
ClassMethod GetOperateInfo(RowID)
{
	s OIRowID=""
	&SQL(select OI_RowID into :OIRowID from sqluser.DHC_EQOperateInfo where OI_SourceID=:RowID and OI_OperateState='1')
	q OIRowID
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCEQConfig","GetConfig","1","1","70","","","50")
Query GetConfig(Type As %String = "", SourceType As %String = "", ItemDR As %String = "", ProviderDR As %String = "", ManuFacturerDR As %String = "", SourceID As %String = "", Flag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TTypeDesc:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TItemDR:%String,TItem:%String,TName:%String,TPrice:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TBrandDR:%String,TBrand:%String,TProviderDR:%String,TProvider:%String,TManuFactoryDR:%String,TManuFactory:%String,TSpec:%String,TModelDR:%String,TModel:%String,TParameters:%String,TGuaranteePeriodNum:%String,TCountryDR:%String,TCountry:%String,TLeaveFacNo:%String,TLeaveDate:%String,TLocationDR:%String,TLocation:%String,TReceiverDR:%String,TReceiver:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TDisuseFlag:%String,TDisuseDate:%String,TInvoiceNo:%String,TOpenFlag:%String,TMeasureFlag:%String,TRemark:%String,TStatus:%String,TServiceHandler:%String,TServiceTel:%String,TManyToManyFlag:%String")
{
}

ClassMethod GetConfigExecute(ByRef qHandle As %Binary, Type As %String = "", SourceType As %String = "", ItemDR As %String = "", ProviderDR As %String = "", ManuFacturerDR As %String = "", SourceID As %String = "", Flag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetConfig
	Quit $$$OK
BuildDataGetConfig
	f  s rowid=$o(^DHCEQConfig(rowid))  quit:rowid=""  d
	.d ResetVariablesGetConfig
	.s TType = $p($g(^DHCEQConfig(rowid)),"^",1)
	.q:(Type'="")&&(TType'=Type)
	.q:(Flag=0)&&(TType'=1)           //控制配置类型为附属设备的界面，只显示附属设备
	.q:(Flag=1)&&((TType'=3)&&(TType'=4))
	.q:(Flag=2)&&((TType'=1)&&(TType'=2))
	.s TTypeDesc=$case(TType,0:"附件",1:"附属设备",2:"文件",3:"硬件配置",4:"软件配置")
	.s TSourceType=$p($g(^DHCEQConfig(rowid)),"^",2)
	.q:(TSourceType'=SourceType)
	.s TSourceTypeDesc=$case(TSourceType,1:"验收",2:"设备")
	.s TSourceID=$p($g(^DHCEQConfig(rowid)),"^",3)
	.q:(TSourceID'=SourceID)                  //根据验收明细ID过滤单据
	.s TName=$p($g(^DHCEQConfig(rowid)),"^",5)
	.s TItemDR = $p($g(^DHCEQConfig(rowid)),"^",4) //1附属设备取设备项：3和4软硬件配置取配置项
	.q:(ItemDR'="")&&(TItemDR'=ItemDR)
	.i TItemDR'=""  d
	..i TType="1" d
	...s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	...i TName="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..i (TType="3")||(TType="4") d
	...s TItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TItemDR)),"^",2)
	...i TName="" s TName=$p($g(^DHCEQCCode("DHCEQCConfigItem",TItemDR)),"^",2)
	.s TPrice=$p($g(^DHCEQConfig(rowid)),"^",6)
	.s TQuantityNum=$p($g(^DHCEQConfig(rowid)),"^",7)
	.s TUnitDR=$p($g(^DHCEQConfig(rowid)),"^",8)
	.i TUnitDR '="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TBrandDR=$p($g(^DHCEQConfig(rowid)),"^",9)
	.i TBrandDR '=""  d
	..s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	.s TProviderDR=$p($g(^DHCEQConfig(rowid)),"^",10)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.i TProviderDR '=""  d
	..s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	.s TManuFactoryDR=$p($g(^DHCEQConfig(rowid)),"^",11)
	.q:(ManuFacturerDR'="")&&(TManuFactoryDR'=ManuFacturerDR)
	.i TManuFactoryDR '=""  d
	..s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TSpec = $p($g(^DHCEQConfig(rowid)),"^",12)
	.s TModel = $p($g(^DHCEQConfig(rowid)),"^",13)
    .s TParameters = $p($g(^DHCEQConfig(rowid)),"^",14)
    .s TGuaranteePeriodNum = $p($g(^DHCEQConfig(rowid)),"^",15)
    .s TCountryDR = $p($g(^DHCEQConfig(rowid)),"^",16)
    .i TCountryDR '=""  s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    .s TLeaveFacNo = $p($g(^DHCEQConfig(rowid)),"^",17)
    .s TLeaveDate =$p($g(^DHCEQConfig(rowid)),"^",18)
    .i TLeaveDate '="" s TLeaveDate = ##Class(web.DHCEQCommon).TransValueToPage(TLeaveDate,"date")
    .s TLocation = $p($g(^DHCEQConfig(rowid)),"^",19)
    .;i TLocationDR '=""  s TLocation=##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
    .s TReceiverDR = $p($g(^DHCEQConfig(rowid)),"^",20)
	.s TReceiver = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TReceiverDR)
    .s TMeasureFlag = $p($g(^DHCEQConfig(rowid)),"^",21)
    .s TGuaranteeStartDate =$p($g(^DHCEQConfig(rowid)),"^",22)
    .i TGuaranteeStartDate'="" s TGuaranteeStartDate=##class(web.DHCEQCommon).TransValueToPage(TGuaranteeStartDate,"date")
    .s TGuaranteeEndDate =$p($g(^DHCEQConfig(rowid)),"^",23)
    .i TGuaranteeEndDate'="" s TGuaranteeEndDate=##class(web.DHCEQCommon).TransValueToPage(TGuaranteeEndDate,"date")
    .s TDisuseFlag = $p($g(^DHCEQConfig(rowid)),"^",24)
    .s TDisuseDate = $p($g(^DHCEQConfig(rowid)),"^",25)
    .i TDisuseDate'="" s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
    .s TInvoiceNo = $p($g(^DHCEQConfig(rowid)),"^",26)
    .s TOpenFlag = $p($g(^DHCEQConfig(rowid)),"^",27)
    .s TRemark = $p($g(^DHCEQConfig(rowid)),"^",28)
    .s TStatus=$p($g(^DHCEQConfig(rowid)),"^",29)
    .s TServiceHandler = $p($g(^DHCEQConfig(rowid)),"^",36)
    .s TServiceTel = $p($g(^DHCEQConfig(rowid)),"^",37)
    .s TManyToManyFlag = $p($g(^DHCEQConfig(rowid)),"^",38)
    .s TRowID = rowid
	.d OutputRowGetConfig
	quit
OutputRowGetConfig
	s Data=$lb(TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfig
	s (TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag)=""
	quit
}

ClassMethod GetConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigExecute ]
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

ClassMethod GetConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod TransStatusTopage(Status)
{
	q $Case(Status,"0":"新增","1":"修改",:"没有定义")
}

/// 解析字符串
ClassMethod GetOneConfig(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQConfig(rowid)
	s resultex=resultex_"^"	;ItemDR
	i $p(result,"^",4)'=""  d
	.i $p($g(^DHCEQConfig(rowid)),"^",1)="1" d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",4))),"^",1)
	.e  d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCUOM",$p(result,"^",8))),"^",4)
	s resultex=resultex_"^"   ;BrandDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",$p(result,"^",9))),"^",3)
	s resultex=resultex_"^"	;CVendor
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCVendor",$p(result,"^",10))),"^",2)
	s resultex=resultex_"^" ;ManuFactoryDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",11))),"^",1)
	s resultex=resultex_"^" ;CountryDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(result,"^",20))   ;User
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",22),"date")
	e  d
	.s resultex=resultex_"^" 
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",23),"date")
	e  d
	.s resultex=resultex_"^" 
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

Query GetChangeConfig(RowID, ChangeType, StartDate, EndDate, Status) As %Query(ROWSPEC = "TRowID:%String,TSourceDR:%String,TEquipDR:%String,TChangeDate:%String,TChangeType:%String,TFromConfigItemDR:%String,TFromValue:%String,TToConfigItemDR:%String,TToValue:%String,TRemark:%String,TAuditUserDR:%String,TAuditDate:%String,TStatus:%String,TSource:%String,TEquip:%String,TFromConfigItem:%String,TToConfigItem:%String,TAuditUser:%String")
{
}

ClassMethod GetChangeConfigExecute(ByRef qHandle As %Binary, RowID, ChangeType, StartDate, EndDate, Status) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetChangeConfig
	Quit $$$OK
BuildDataGetChangeConfig
	f  s rowid=$o(^DHCEQChangeConfig(RowID))  quit:rowid=""  d
	.d ResetVariablesGetChangeConfig
	.s TRowID = rowid
	.s TSourceDR = $p($g(^DHCEQChangeConfig(rowid)),"^",1)
	.i TSourceDR '=""  d
	.//.s TSource = $p($g(^DHCEQConfig(TSourceDR)),"^",XX)
	.s TEquipDR = $p($g(^DHCEQChangeConfig(rowid)),"^",2)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQChangeConfig(rowid)),"^",3)>EndDate)||($p($g(^DHCEQChangeConfig(rowid)),"^",3)<StartDate)
	.s TChangeDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeConfig(rowid)),"^",3),"date")
	.s TChangeType = $p($g(^DHCEQChangeConfig(rowid)),"^",4)
	.q:(ChangeType'="")&&(ChangeType'=TChangeType)
	.s TChangeType=$CASE(TChangeType,"0":"新增","1":"更新","2":"删除",:"没有定义")
	.s TFromConfigItemDR = $p($g(^DHCEQChangeConfig(rowid)),"^",5)
	.i TFromConfigItemDR '=""  d
	..s TFromConfigItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TFromConfigItemDR)),"^",2)
	..s FromUnit=$p($g(^DHCEQCCode("DHCEQCConfigItem",TFromConfigItemDR)),"^",5)
	.s TFromValue = $p($g(^DHCEQChangeConfig(rowid)),"^",6)_" "_FromUnit
	.s TToConfigItemDR = $p($g(^DHCEQChangeConfig(rowid)),"^",7)
	.i TToConfigItemDR '=""  d
	..s TToConfigItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TToConfigItemDR)),"^",2)
	..s ToUnit=$p($g(^DHCEQCCode("DHCEQCConfigItem",TToConfigItemDR)),"^",5)
	.s TToValue = $p($g(^DHCEQChangeConfig(rowid)),"^",8)_" "_ToUnit
	.s TRemark = $p($g(^DHCEQChangeConfig(rowid)),"^",9)
	.s TAuditUserDR = $p($g(^DHCEQChangeConfig(rowid)),"^",10)
	.i TAuditUserDR '=""  d
	..s TAuditUser = $p($g(^SSU("SSUSR",TAuditUserDR)),"^",2)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeConfig(rowid)),"^",11),"date")
	.s TStatus = $p($g(^DHCEQChangeConfig(rowid)),"^",12)
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.d OutputRowGetChangeConfig
	quit
OutputRowGetChangeConfig
	s Data=$lb(TRowID,TSourceDR,TEquipDR,TChangeDate,TChangeType,TFromConfigItemDR,TFromValue,TToConfigItemDR,TToValue,TRemark,TAuditUserDR,TAuditDate,TStatus,TSource,TEquip,TFromConfigItem,TToConfigItem,TAuditUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeConfig
	s (FromUnit,ToUnit,TRowID,TSourceDR,TEquipDR,TChangeDate,TChangeType,TFromConfigItemDR,TFromValue,TToConfigItemDR,TToValue,TRemark,TAuditUserDR,TAuditDate,TStatus,TSource,TEquip,TFromConfigItem,TToConfigItem,TAuditUser)=""
	quit
}

ClassMethod GetChangeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeConfigExecute ]
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

ClassMethod GetChangeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ChangeTypeList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=>全部</option>"
	w "<option value=0>新增</option>"
	w "<option value=1>更新</option>"
	w "<option value=2>删除</option>"
	w "</select>",!
}

ClassMethod StatusList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=>全部</option>"
	w "<option value=0>新增</option>"
	w "<option value=1>提交</option>"
	w "</select>",!
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQConfig","GetCItem","3","")
/// 入参：Type配置类型，FacilityFlag是否包含简易台账资产类组
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组
Query GetCItem(Type, Name, FacilityFlag As %String = "0") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TMeasureFlag:%String")
{
}

ClassMethod GetCItemExecute(ByRef qHandle As %Binary, Type, Name, FacilityFlag As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i Type="" q $$$OK
	if (Type="0")
	{
		q $$$OK
	}
	elseif (Type="1")
	{
		s Hospital=##Class(web.DHCEQCommon).GetHospital()
		i Hospital'=""
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR))  quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",FacilityFlag)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid))  quit:rowid=""  d
			..d ResetVariablesGetCItem
			..d BuildDataGetCItem
		}
		else
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",FacilityFlag)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
			..d ResetVariablesGetCItem
			..d BuildDataGetCItem
		}
	}
	elseif (Type="2")
	{
		q $$$OK
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCConfigItem",rowid))  quit:rowid=""  d
		.d ResetVariablesGetCItem
		.q:$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",6)="Y"
		.s TName = $p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",2)
		.s TCode=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",1)
		.q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
		.s TRowID=rowid
		.d OutputRowGetCItem
	}
	
	Quit $$$OK
	
BuildDataGetCItem
	q:$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	s TMeasureFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",17)
	s TRowID=rowid
	d OutputRowGetCItem
	quit
OutputRowGetCItem
	s Data=$lb(TName,TRowID,TCode,TMeasureFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCItem
	s (TName,TRowID,TCode,TMeasureFlag)=""
	quit
}

ClassMethod GetCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCItemExecute ]
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

ClassMethod GetCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy		2018-5-15
/// 根据来源获取配置表IDs
/// w ##Class(web.DHCEQConfig).GetConfigDRs(1,707)
ClassMethod GetConfigDRs(SourceType As %String = "", SourceID As %String = "")
{
	i (SourceType="")||(SourceID="") q ""
	s result=""
	s CRowid=0
	f  s CRowid=$o(^DHCEQConfig(0,"SourceID",SourceType,SourceID,CRowid)) q:(CRowid="")  d
	.i result'="" s result=result_","
	.s result=result_CRowid
	
	q result
}

/// Mozy	2018-11-20
/// 获取设备相关的附属设备记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQConfig","GetConfigForEquip",153)
Query GetConfigForEquip(EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TTypeDesc:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TItemDR:%String,TItem:%String,TName:%String,TPrice:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TBrandDR:%String,TBrand:%String,TProviderDR:%String,TProvider:%String,TManuFactoryDR:%String,TManuFactory:%String,TSpec:%String,TModelDR:%String,TModel:%String,TParameters:%String,TGuaranteePeriodNum:%String,TCountryDR:%String,TCountry:%String,TLeaveFacNo:%String,TLeaveDate:%String,TLocationDR:%String,TLocation:%String,TReceiverDR:%String,TReceiver:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TDisuseFlag:%String,TDisuseDate:%String,TInvoiceNo:%String,TOpenFlag:%String,TMeasureFlag:%String,TRemark:%String,TStatus:%String,TServiceHandler:%String,TServiceTel:%String,TManyToManyFlag:%String")
{
}

ClassMethod GetConfigForEquipExecute(ByRef qHandle As %Binary, EquipDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i EquipDR="" Quit $$$OK
 	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQConfig(rowid)) quit:rowid=""  d
	.d ResetVariablesGetConfigForEquip
	.s TType = $p($g(^DHCEQConfig(rowid)),"^",1)
	.s TTypeDesc=$case(TType,0:"附件",1:"附属设备",2:"文件",3:"硬件配置",4:"软件配置")
	.s TSourceType=$p($g(^DHCEQConfig(rowid)),"^",2)
	.s TSourceTypeDesc=$case(TSourceType,1:"验收",2:"设备")
	.s TSourceID=$p($g(^DHCEQConfig(rowid)),"^",3)
	.s TName=$p($g(^DHCEQConfig(rowid)),"^",5)
	.s TItemDR = $p($g(^DHCEQConfig(rowid)),"^",4) //1附属设备取设备项：3和4软硬件配置取配置项
	.i TItemDR'=""  d
	..i TType="1" d
	...s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	...i TName="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..i (TType="3")||(TType="4") d
	...s TItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TItemDR)),"^",2)
	...i TName="" s TName=$p($g(^DHCEQCCode("DHCEQCConfigItem",TItemDR)),"^",2)
	.s TPrice=$p($g(^DHCEQConfig(rowid)),"^",6)
	.s TQuantityNum=$p($g(^DHCEQConfig(rowid)),"^",7)
	.s TUnitDR=$p($g(^DHCEQConfig(rowid)),"^",8)
	.i TUnitDR '="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TBrandDR=$p($g(^DHCEQConfig(rowid)),"^",9)
	.i TBrandDR '=""  d
	..s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	.s TProviderDR=$p($g(^DHCEQConfig(rowid)),"^",10)
	.i TProviderDR '=""  d
	..s TProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",2)
	.s TManuFactoryDR=$p($g(^DHCEQConfig(rowid)),"^",11)
	.i TManuFactoryDR '=""  d
	..s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TSpec = $p($g(^DHCEQConfig(rowid)),"^",12)
	.s TModel = $p($g(^DHCEQConfig(rowid)),"^",13)
    .s TParameters = $p($g(^DHCEQConfig(rowid)),"^",14)
    .s TGuaranteePeriodNum = $p($g(^DHCEQConfig(rowid)),"^",15)
    .s TCountryDR = $p($g(^DHCEQConfig(rowid)),"^",16)
    .i TCountryDR '=""  s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    .s TLeaveFacNo = $p($g(^DHCEQConfig(rowid)),"^",17)
    .s TLeaveDate =$p($g(^DHCEQConfig(rowid)),"^",18)
    .i TLeaveDate '="" s TLeaveDate = ##Class(web.DHCEQCommon).TransValueToPage(TLeaveDate,"date")
    .s TLocation = $p($g(^DHCEQConfig(rowid)),"^",19)
    .;i TLocationDR '=""  s TLocation=##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
    .s TReceiverDR = $p($g(^DHCEQConfig(rowid)),"^",20)
	.s TReceiver = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TReceiverDR)
    .s TMeasureFlag = $p($g(^DHCEQConfig(rowid)),"^",21)
    .s TGuaranteeStartDate =$p($g(^DHCEQConfig(rowid)),"^",22)
    .i TGuaranteeStartDate'="" s TGuaranteeStartDate=##class(web.DHCEQCommon).TransValueToPage(TGuaranteeStartDate,"date")
    .s TGuaranteeEndDate =$p($g(^DHCEQConfig(rowid)),"^",23)
    .i TGuaranteeEndDate'="" s TGuaranteeEndDate=##class(web.DHCEQCommon).TransValueToPage(TGuaranteeEndDate,"date")
    .s TDisuseFlag = $p($g(^DHCEQConfig(rowid)),"^",24)
    .s TDisuseDate = $p($g(^DHCEQConfig(rowid)),"^",25)
    .i TDisuseDate'="" s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
    .s TInvoiceNo = $p($g(^DHCEQConfig(rowid)),"^",26)
    .s TOpenFlag = $p($g(^DHCEQConfig(rowid)),"^",27)
    .s TRemark = $p($g(^DHCEQConfig(rowid)),"^",28)
    .s TStatus=$p($g(^DHCEQConfig(rowid)),"^",29)
    .s TServiceHandler = $p($g(^DHCEQConfig(rowid)),"^",36)
    .s TServiceTel = $p($g(^DHCEQConfig(rowid)),"^",37)
    .s TManyToManyFlag = $p($g(^DHCEQConfig(rowid)),"^",38)
    .s TRowID = rowid
	.d OutputRowGetConfigForEquip
	Quit $$$OK
OutputRowGetConfigForEquip
	Set Data=$lb(TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfigForEquip
	s (TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag)=""
	quit
}

ClassMethod GetConfigForEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigForEquipExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConfigForEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigForEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
