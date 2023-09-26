/// 名称: web.DHCEQ.EM.BUSConfig
/// 描述: 附属设备
/// 编写者：Mozy
/// 编写日期: 2018-11-21
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSConfig Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// modified by ZY0243 20200917 增加返回值信息描述
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
	// Mozy003001	2020-03-17	调整修改数组
	k CLIST
	s rowid=$p(val,"^",1)
 	s CLIST(2) = $p(val,"^",2)	;C_Type
 	s SourceType = $p(val,"^",3)
 	s SourceID = $p(val,"^",4)
 	i (SourceType="")||(SourceID="") q "-1001^来源类型或来源ID不能为空!"
 	s CLIST(3) = $p(val,"^",3)	;C_SourceType
 	s CLIST(4) = $p(val,"^",4)	;C_SourceID
 	s CLIST(5) = $p(val,"^",5)	;C_ItemDR
 	s CLIST(6) = $p(val,"^",6)	;C_Item
	s CLIST(7) = $p(val,"^",7)	;C_Price
 	s CLIST(8) = $p(val,"^",8)	;C_QuantityNum
 	i (CLIST(2)=3)||(CLIST(2)=4) s CLIST(8) = 1		// MZY0069	1728996		2021-02-18	硬件/软件配置设置默认数量为1
	s CLIST(9) = $p(val,"^",9)	;C_UnitDR
 	s CLIST(10) = $p(val,"^",10)  ;C_BrandDR
	s CLIST(11) = $p(val,"^",11)  ;C_VendorDR
	/*/ Mozy0255	1190551		2020-3-6	取消自动保存供应商默认信息
	i (CLIST(11) ="")
	{
		i (CLIST(3)=1) s CLIST(11) = $p($g(^DHCEQOpenCheckRequest(+CLIST(4))),"^", 5)
		i (CLIST(3)=2) s CLIST(11) = $p($g(^DHCEQEquip(+CLIST(4))),"^", 25)
	}*/
	s CLIST(12) = $p(val,"^",12)  ;C_ManuFactoryDR
	s CLIST(13) = $p(val,"^",13)  ;C_Spec
	s CLIST(14) = $p(val,"^",14)  ;C_Model
	s CLIST(15) = $p(val,"^",15)  ;C_Parameters
	s CLIST(16) = $p(val,"^",16)  ;C_GuaranteePeriodNum
	s CLIST(17) = $p(val,"^",17)  ;C_CountryDR
	;s CLIST(18) = $p(val,"^",18)  ;C_LeaveFacNo
	s CLIST(18)=$TRANSLATE($p(val,"^",18),"，",",")
	s CLIST(19) = $p(val,"^",19)	;C_LeaveDate
	i $p(val,"^",19)'=""  s CLIST(19) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")	
	s CLIST(20) = $p(val,"^",20)	;C_Location
	s CLIST(21) = $p(val,"^",21)	;C_ReceiverDR
 	s CLIST(22) = $p(val,"^",22)	;C_MeasureFlag
 	s CLIST(23) = $p(val,"^",23)	;C_GuaranteeStartDate
 	i $p(val,"^",23)'=""  s CLIST(23) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"date")
 	s CLIST(24) = $p(val,"^",24)	;C_GuaranteeEndDate
 	i $p(val,"^",24)'=""  s CLIST(24) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")
 	s CLIST(25) = $p(val,"^",25)	;C_DisuseFlag
 	s CLIST(26) = $p(val,"^",26)	;C_DisuseDate 
	s CLIST(27) = $p(val,"^",27)	;C_InvoiceNo
	s CLIST(28) = $p(val,"^",28)	;C_OpenFlag
	s CLIST(29) = $p(val,"^",29)	;C_Remark
	;s CLIST(30) = $p(val,"^",30)	;C_Status
 	;i CLIST(30)="" s CLIST(30)="0" //新增配置
 	;i CLIST(30)="2" s CLIST(30)="1"  //修改配置
 	s CLIST(37) = $p(val,"^",31)	;C_ServiceHandler
 	s CLIST(38) = $p(val,"^",32)	;C_ServiceTel
 	s CLIST(39) = $p(val,"^",33)	;C_RegisterNo
	//modfied by ZY0306 增加附属设备导入功能
 	s CLIST(40) = $p(val,"^",34)	;C_RecomendYears
 	s CLIST(41) = $p(val,"^",35)	;C_Hold3
 	s CLIST(42) = $p(val,"^",36)	;C_Hold4
 	s CLIST(43) = $p(val,"^",37)	;C_Hold5
 	s CLIST(44) = $p(val,"^",38)	;C_Hold6
 	
 	if (CLIST(3)=1) 
 	{
	 	s OCRRowID=$p($g(^DHCEQOpenCheckList(CLIST(3))),"^",1)
	 	s CLIST(11) =$p($g(^DHCEQOpenCheckRequest(OCRRowID)),"^",5) //供应商
	 }
 	
 	TSTART
	s tmpid=""
	&SQL(select C_RowID into :tmpid from sqluser.DHC_EQConfig where C_Type=:CLIST(2) and C_SourceType=:CLIST(3) and C_SourceID=:CLIST(4) and C_Item=:CLIST(6) and C_Model=:CLIST(14))
	if ((tmpid'="")&(SQLCODE'=100)&(tmpid'=rowid)) q "-3003^有重复记录!"	;重复记录
	if (rowid="")
	{
		//新增配置
		s CLIST(30)="0"
		&SQL(Insert Into SQLUSER.DHC_EQConfig Values :CLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^新增记录失败!"
		}
 		s rowid=$g(%ROWID)
		
		//插入操作信息表 lmm 2020-03-05 LMM0062
		s SourceType="45"
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s OperateInfo="^"_SourceType_"^"_rowid_"^"_User_"^^0"
	 	s SQLCODE=##Class(web.DHCEQ.Plat.BUSOperateLog).SaveData(OperateInfo,"3")
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^更新操作记录失败!"
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
	 		q SQLCODE_"^更新操作记录失败!"
		} 
		//modify by lmm 2020-03-05 LMM0062
		
		s CLIST(30)="1"  //修改配置
 	 	&SQL(Update SQLUSER.DHC_EQConfig Values :CLIST() where C_RowID = :rowid)
 	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	Quit SQLCODE_"^更新记录失败!"
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

/// 插入操作人信息表
/// modify by lmm 2020-03-06
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
	s OIRowID=##class(web.DHCEQ.EM.BUSConfig).GetOperateInfo(RowID)
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
/// modify by lmm 2020-03-06 LMM0062 注释不用
/// Flag:0-附属设备 	1-软/硬件 	2-其他		FromTypeList()
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","GetConfig","1","1","70","","","50")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","GetConfig","",2,"","","",169)
Query GetConfig(Type As %String = "", SourceType As %String = "", ItemDR As %String = "", ProviderDR As %String = "", ManuFacturerDR As %String = "", SourceID As %String = "", Flag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TType:%String,TTypeDesc:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TItemDR:%String,TItem:%String,TName:%String,TPrice:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TBrandDR:%String,TBrand:%String,TProviderDR:%String,TProvider:%String,TManuFactoryDR:%String,TManuFactory:%String,TSpec:%String,TModelDR:%String,TModel:%String,TParameters:%String,TGuaranteePeriodNum:%String,TCountryDR:%String,TCountry:%String,TLeaveFacNo:%String,TLeaveDate:%String,TLocationDR:%String,TLocation:%String,TReceiverDR:%String,TReceiver:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TDisuseFlag:%String,TDisuseDate:%String,TInvoiceNo:%String,TOpenFlag:%String,TMeasureFlag:%String,TRemark:%String,TStatus:%String,TServiceHandler:%String,TServiceTel:%String,TManyToManyFlag:%String,TAppendFlag:%String,THold6:%String")
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
	.;q:(Flag=2)&&((TType'=1)&&(TType'=2))		Mozy	2019-5-13	896416	匹配"web.DHCEQ.EM.BUSConfig.FromTypeList"
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
	..s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //modified by CZF0093 2020-03-17
	.s TSpec = $p($g(^DHCEQConfig(rowid)),"^",12)
	.s TModel = $p($g(^DHCEQConfig(rowid)),"^",13)
    .s TParameters = $p($g(^DHCEQConfig(rowid)),"^",14)
    .s TGuaranteePeriodNum = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQConfig(rowid)),"^",15),"",2)	// Mozy0249	1195350,1195363		20200227
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
    .s TStatus = $p($g(^DHCEQConfig(rowid)),"^",29)
    .s TStatus = $CASE(TStatus,"0":"新增","1":"修改","2":"审核",:"没有定义") //czf 2022-11-14
    .s TServiceHandler = $p($g(^DHCEQConfig(rowid)),"^",36)
    .s TServiceTel = $p($g(^DHCEQConfig(rowid)),"^",37)
    .s TManyToManyFlag = $p($g(^DHCEQConfig(rowid)),"^",38)
    .// Mozy0249	1195350,1195363		20200227
    .s TAppendFlag="N"
    .i TOpenFlag'="Y" s TAppendFlag="Y"
    .s TRowID = rowid
    .s THold6 = $p($g(^DHCEQConfig(rowid)),"^",43)
	.d OutputRowGetConfig
	quit
OutputRowGetConfig
	Set Data=$lb(TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag,TAppendFlag,THold6)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfig
	s (TRowID,TType,TTypeDesc,TSourceType,TSourceTypeDesc,TSourceID,TItemDR,TItem,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModelDR,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TLeaveFacNo,TLeaveDate,TLocationDR,TLocation,TReceiverDR,TReceiver,TGuaranteeStartDate,TGuaranteeEndDate,TDisuseFlag,TDisuseDate,TInvoiceNo,TOpenFlag,TMeasureFlag,TRemark,TStatus,TServiceHandler,TServiceTel,TManyToManyFlag,TAppendFlag,THold6)=""
	quit
}

ClassMethod GetConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigExecute ]
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
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),";")
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","GetCItem","1","")
/// 入参：Type配置类型，FacilityFlag是否包含简易台账资产类组
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组
Query GetCItem(Type, Name, FacilityFlag As %String = "0") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TUOM:%String,TMeasureFlag:%String,TUOMDR:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TEquipCatDR:%String,TEquipCat:%String")
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
		.s TUOMDR=$p($g(^DHCEQCCode("DHCEQCConfigItem",rowid)),"^",5)		// MZY0061	1610216		2020-12-2
		.s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
		.s TRowID=rowid
		.d OutputRowGetCItem
	}
	
	Quit $$$OK
	
BuildDataGetCItem
	q:$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	s TUOMDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)	// Mozy0249	1195350,1195363		20200227
	s TUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom", $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7))
	s TMeasureFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",17)
	
	//czf 2022-04-19 begin
	s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",3)
	s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	//czf 2022-04-19 end
	s TRowID=rowid
	d OutputRowGetCItem
	quit
OutputRowGetCItem
	s Data=$lb(TName,TRowID,TCode,TUOM,TMeasureFlag,TUOMDR,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TEquipCatDR,TEquipCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCItem
	s (TName,TRowID,TCode,TUOM,TMeasureFlag,TUOMDR,TEquipType,TStatCatDR,TStatCat,TEquipCatDR,TEquipCat)=""
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
/// w ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,707)
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

/// czf 2023-02-28
/// 判断设备包含附属设备
/// w ##Class(web.DHCEQ.EM.BUSConfig).EQHasConfig(1,707)
ClassMethod EQHasConfig(SourceType As %String = "", SourceID As %String = "")
{
	i (SourceType="")||(SourceID="") q ""
	s result=""
	s CRowid=0
	f  s CRowid=$o(^DHCEQConfig(0,"SourceID",SourceType,SourceID,CRowid)) q:(CRowid="")  d
	.i result'="" s result=result_","
	.s result=result_CRowid
	i result'="" q 1
	
	s result=""
	i (result="")&&(SourceType=2)
	{
		s configEQID=0
		f  s configEQID=$o(^DHCEQEquip(0,"Parent",SourceID,configEQID)) q:configEQID=""  d
		.q:$p($g(^DHCEQEquip(configEQID)),"^",59)="Y"
		.i result'="" s result=result_","
		.s result=result_configEQID
		
	}
	i result'="" q 1
	q 0
}

/// Mozy	2018-11-25	获取主设备相关附属设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","GetEQConfigList",178)
Query GetEQConfigList(EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TModel:%String,TUnit:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TCountry:%String,TUseLoc:%String,TOrigin:%String,TProvider:%String,TManuFactory:%String,TOriginalFee:%String,TQuantity:%String,TLimitYearsNum:%String,TRemark:%String,TDisplayStatus:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TEquipType:%String,TStoreLoc:%String,TNo:%String,TLocation:%String,TFileNo:%String,Thold8:%String,Thold9:%String")
{
}

ClassMethod GetEQConfigListExecute(ByRef qHandle As %Binary, EquipDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i EquipDR="" Quit $$$OK
 	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQEquip("0","Parent",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetEQConfigList
	.s TRowID = rowid
	.s EquipData=$g(^DHCEQEquip(TRowID))
	.s TName = $p(EquipData,"^",1)
	.s TModelDR = $p(EquipData,"^",3)
	.s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TUnitDR = $p(EquipData,"^",5)
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TLeaveFactoryNo = $p(EquipData,"^",10)
	.s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date")
	.s TOpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",12),"date")
	.s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",13),"date")
	.s TCountryDR = $p(EquipData,"^",16)
	.s TCountry = ##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	.s TUseLocDR = $p(EquipData,"^",19)
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TOriginDR = $p(EquipData,"^",20)
	.i TOriginDR'="" s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.s TProviderDR = $p(EquipData,"^",25)
	.s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TManuFactoryDR = $p(EquipData,"^",26)
	.s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	.s TOriginalFee = $p(EquipData,"^",27)
	.s TQuantity = 1
	.s TLimitYearsNum = $p(EquipData,"^",31)
	.s TRemark = $p(EquipData,"^",34)
	.s TStatus = $p(EquipData,"^",38)
	.s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
	.s TGuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",50),"date")
	.s TGuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",51),"date")
	.s TInvalidFlag = $p(EquipData,"^",59)
	.q:TInvalidFlag'="N"
	.s TEquipTypeDR = $p(EquipData,"^",63)
	.s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.s TStoreLocDR = $p(EquipData,"^",67)
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TNo = $p(EquipData,"^",71)
	.s TLocationDR = $p(EquipData,"^",72)
	.s TLocation=##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	.s TFileNo=$p(EquipData,"^",85)
	.s Thold8=$p(EquipData,"^",93)
	.s Thold8=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(Thold8)
	.s Thold9=$p(EquipData,"^",94)
	.i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	.d OutputRowGetEQConfigList
	
	//Mozy	976774	2019-8-1	0:复制 1：生成台账
	i ##class(web.DHCEQCommon).GetSysInfo("201011")=0
	{
		; ^DHCEQConfig(0,"SourceID",2,408,121) = "" 
		s rowid=0
		f  s rowid=$o(^DHCEQConfig("0","SourceID",2,EquipDR,rowid)) quit:rowid=""  d
		.d ResetVariablesGetEQConfigList
		.s TRowID = rowid
		.s EquipData=$g(^DHCEQConfig(TRowID))
		.q:$p(EquipData,"^",1)'=1		; MZY0026	1320840		2020-05-20
		.// MZY0154	3256238		2023-03-03	类组
		.i $p(EquipData,"^",4)'="" d
		..s TEquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",$p(EquipData,"^",4))),"^",3)
		..s TEquipType = ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.s TName = $p(EquipData,"^",5)
		.s TOriginalFee = $p(EquipData,"^",6)
		.s TQuantity = $p(EquipData,"^",7)
		.s TUnitDR = $p(EquipData,"^",8)
		.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s Thold9=$p(EquipData,"^",9)
		.i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
		.s TProviderDR = $p(EquipData,"^",10)
		.s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.s TManuFactoryDR = $p(EquipData,"^",11)
		.s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.;s TModel = $p(EquipData,"^",12)
		.s TModel = $p(EquipData,"^",13)
		.s TCountryDR = $p(EquipData,"^",16)
		.s TCountry = ##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
		.s TLeaveFactoryNo = $p(EquipData,"^",17)
		.s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",18),"date")
		.s TLocation = $p(EquipData,"^",19)
		.s TGuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",22),"date")
		.s TGuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",23),"date")
		.s TRemark = $p(EquipData,"^",28)
		.;s TStatus = $p(EquipData,"^",29)
		.;s TDisplayStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStatusDisplay(TStatus)
		.d OutputRowGetEQConfigList
	}
	Quit $$$OK
OutputRowGetEQConfigList
	Set Data=$lb(TRowID,TName,TModel,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TUseLoc,TOrigin,TProvider,TManuFactory,TOriginalFee,TQuantity,TLimitYearsNum,TRemark,TDisplayStatus,TGuaranteeStartDate,TGuaranteeEndDate,TEquipType,TStoreLoc,TNo,TLocation,TFileNo,Thold8,Thold9)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEQConfigList
	Set (TRowID,TName,TModel,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TUseLoc,TOrigin,TProvider,TManuFactory,TOriginalFee,TQuantity,TLimitYearsNum,TRemark,TDisplayStatus,TGuaranteeStartDate,TGuaranteeEndDate,TEquipType,TStoreLoc,TNo,TLocation,TFileNo,Thold8,Thold9)=""
	quit
}

ClassMethod GetEQConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQConfigListExecute ]
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

ClassMethod GetEQConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2019-4-30
/// Description:   配置类型列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","FromTypeList",0)
Query FromTypeList(FromType As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod FromTypeListExecute(ByRef qHandle As %Binary, FromType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;s ^DHCEQMozy("web.DHCEQ.EM.BUSConfig.FromTypeList")=FromType
	
	//标识:	0-附属设备 	1-软/硬件 	2-其他
	//0:附件	1:附属设备	2:文件	3:硬件配置	4：软件配置
	if FromType=0
	{
		// Mozy003002	2020-03-18
		i ##class(web.DHCEQCommon).GetSysInfo("990079")=1
		{
			s rowid=1
			s Code="02"
			s Desc="附属设备"
			d OutputRowFromTypeList
		}
	}
	elseif FromType=1
	{
		s rowid=3
		s Code="01"
		s Desc="硬件配置"
		d OutputRowFromTypeList
		s rowid=4
		s Code="02"
		s Desc="软件配置"
		d OutputRowFromTypeList
	}
	elseif FromType=2
	{
		s rowid=0
		s Code="01"
		s Desc="附件"
		d OutputRowFromTypeList
		// Mozy003002	2020-03-18
		i ##class(web.DHCEQCommon).GetSysInfo("990079")=1
		{
			s rowid=1
			s Code="02"
			s Desc="附属设备"
			d OutputRowFromTypeList
		}
		s rowid=2
		s Code="03"
		s Desc="文件"
		d OutputRowFromTypeList
		s rowid=3
		s Code="04"
		s Desc="硬件配置"
		d OutputRowFromTypeList
		s rowid=4
		s Code="05"
		s Desc="软件配置"
		d OutputRowFromTypeList
	}
	Quit $$$OK
OutputRowFromTypeList
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod FromTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FromTypeListExecute ]
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

ClassMethod FromTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FromTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2019-4-30
/// w ##Class(web.DHCEQ.EM.BUSConfig).GetOneConfigNew(17)
ClassMethod GetOneConfigNew(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneConfigNew"
	// C_RowID	C_Type	C_SourceType	C_SourceID	C_ItemDR	C_Item	C_Price	C_QuantityNum	C_UnitDR	C_BrandDR	C_ProviderDR	C_ManuFactoryDR	
	// C_Spec	C_Model	C_Parameters	C_GuaranteePeriodNum	C_CountryDR	C_LeaveFacNo	C_LeaveDate	C_Location	C_ReceiverDR	C_MeasureFlag
	// C_GuaranteeStartDate	C_GuaranteeEndDate	C_DisuseFlag	C_DisuseDate	C_InvoiceNo	C_OpenFlag	C_Remark	C_Status	C_UpdateUserDR	
	// C_UpdateDate	C_UpdateTime	C_AuditUserDR	C_AuditDate	C_AuditTime	C_ServiceHandler	C_ServiceTel	
	// C_Hold1	C_Hold2	C_Hold3	C_Hold4	C_Hold5	C_Hold6
	s ObjConfig=##Class(User.DHCEQConfig).%OpenId(RowID)
	s ConfigInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjConfig)
	
	d ConfigInfo.%Set("CType_Desc",$CASE(ObjConfig.CType,"0":"附件","1":"附属设备","2":"文件","3":"硬件配置","4":"软件配置",:" "))
	s CItemDRDesc=""
	i ObjConfig.CType=1 s CItemDRDesc=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",ObjConfig.CItemDR)
	i ObjConfig.CType>2 s CItemDRDesc=$p($g(^DHCEQCCode("DHCEQCConfigItem",+ObjConfig.CItemDR)),"^",2)
	d ConfigInfo.%Set("CItemDR_Desc",CItemDRDesc)
	d ConfigInfo.%Set("CProviderDR_VDesc",ObjConfig.CProviderDR.VName)
	d ConfigInfo.%Set("CBrandDR_Desc",$p($g(^DHCEQCCode("DHCEQCBrand",+ObjConfig.CBrandDR)),"^",3))
	d ConfigInfo.%Set("CManuFactoryDR_MDesc",ObjConfig.CManuFactoryDR.VName)		//modified by CZF0103 20200408
	//s CManuFactoryDR=ObjConfig.CManuFactoryDRGetObjectId()
	//d ConfigInfo.%Set("CManuFactoryDR_MDesc",$p($g(^DHCEQCCode("DHCEQCVendor",+CManuFactoryDR)),"^",2))	//modified by CZF0093 2020-03-17
	d ConfigInfo.%Set("CUnitDR_UOMDesc",ObjConfig.CUnitDR.UOMDesc)
	d ConfigInfo.%Set("CCountryDR_CDesc",ObjConfig.CCountryDR.CTCOUDesc)
	d ConfigInfo.%Set("CReceiverDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjConfig.CReceiverDR))
	
	//czf 2022-04-19 begin
	s (MIEquipTypeDR,MIEquipTypeDRETDesc,MIEquipCatDR,MIEquipCatDRECDesc,MIStatCatDR,MIStatCatDRSCDesc)=""
	i ObjConfig.CType=1
	{
		s CItemDR=ObjConfig.CItemDR
		i CItemDR'=""
		{
			s MIEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CItemDR)),"^",3)
			s MIEquipTypeDRETDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",MIEquipTypeDR)),"^",2)
			s MIStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CItemDR)),"^",5)
			s MIStatCatDRSCDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",MIStatCatDR)),"^",2)
			s MIEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CItemDR)),"^",4)
			s MIEquipCatDRECDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",MIEquipCatDR)),"^",2)
		}
	}
	d ConfigInfo.%Set("MIEquipTypeDR",MIEquipTypeDR)
	d ConfigInfo.%Set("MIEquipTypeDR_ETDesc",MIEquipTypeDRETDesc)
	d ConfigInfo.%Set("MIStatCatDR",MIStatCatDR)
	d ConfigInfo.%Set("MIStatCatDR_SCDesc",MIStatCatDRSCDesc)
	d ConfigInfo.%Set("MIEquipCatDR",MIEquipCatDR)
	d ConfigInfo.%Set("MIEquipCatDR_ECDesc",MIEquipCatDRECDesc)
	//czf 2022-04-19 end
	
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ConfigInfo)
ERRORGetOneConfigNew
	TROLLBACK 
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// add by czf 2022-11-08
/// 获取主设备的附属设备数
/// w ##class(web.DHCEQ.EM.BUSConfig).GetEQConfigInfo(10175)
ClassMethod GetEQConfigInfo(EquipDR)
{
	n (EquipDR)
	i EquipDR="" q ""
	s num=0
	s rowid=0
	f  s rowid=$o(^DHCEQEquip("0","Parent",EquipDR,rowid))  quit:rowid=""  d
	.s TRowID = rowid
	.s EquipData=$g(^DHCEQEquip(TRowID))
	.s TInvalidFlag = $p(EquipData,"^",59)
	.q:TInvalidFlag'="N"
	.s TName = $p(EquipData,"^",1)
	.s TModelDR = $p(EquipData,"^",3)
	.s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TUnitDR = $p(EquipData,"^",5)
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TLeaveFactoryNo = $p(EquipData,"^",10)
	.s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date")
	.s num=num+1
	
	q num
}

/// w ##Class(web.DHCEQ.EM.BUSConfig).GetConfigInfoByOpenCheck(381)
ClassMethod GetConfigInfoByOpenCheck(OCLDR)
{
	s configInfo=""
	i OCLDR="" q ""
	If $Data(^DHCEQConfig(0,"SourceID",1,OCLDR))
	{
		Set configRowId=""
		For  Set configRowId=$Order(^DHCEQConfig(0,"SourceID",1,OCLDR,configRowId))  Quit:configRowId=""  Do
		.If configInfo'="" Set configInfo=configInfo_"&&"
		.Set configInfo=configInfo_..GetOneConfig(configRowId)
	}
	q ##class(web.DHCEQCommon).Replace(configInfo,$c(13,10),";")
}

/// 获取验收单每个设备附属设备信息
/// w ##Class(web.DHCEQ.EM.BUSConfig).GetConfigInfoByOpenCheckNew(381)
ClassMethod GetConfigInfoByOpenCheckNew(OCLDR)
{
	n (OCLDR)
	i OCLDR="" q "{}"
	
	s OriginalFee=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",17)
	s Quantity=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",16)
	i $Order(^DHCEQConfig(0,"SourceID",1,OCLDR,""))="" q "{}"
	s EQConfigObj={}
	for EQCount=1:1:Quantity
	{
		s configInfo=""
		s CRowid=0
		f  s CRowid=$Order(^DHCEQConfig(0,"SourceID",1,OCLDR,CRowid)) Quit:(CRowid="")  Do
		.s CQuantityNum=$P($g(^DHCEQConfig(CRowid)),"^",7)
		.s PrintNum=CQuantityNum
		.s CSNos=$P($g(^DHCEQConfig(CRowid)),"^",17)
		.d DoInsertEquip
		.s PrintNum=n
		.s CSNos=snos
		.s perConfigInfo=..GetOneConfig(CRowid)
		.s $p(perConfigInfo,"^",7)=PrintNum	//每个设备的附属设备数量
		.s $P(perConfigInfo,"^",17)=CSNos
		.If configInfo'="" s configInfo=configInfo_"&&"
		.s configInfo=configInfo_perConfigInfo
		
		s configInfo=##class(web.DHCEQCommon).Replace(configInfo,$c(13,10),";")
		d EQConfigObj.%Set("EQ"_EQCount,configInfo)
	}
	
	q EQConfigObj.%ToJSON()
	
DoInsertEquip
	s n=0
	s snos=""
	s CCount=n*Quantity+EQCount		;初始化分配附属配置设备计数
	while (CCount<=CQuantityNum)
	{
		s sn=$p($P($g(^DHCEQConfig(CRowid)),"^",17),",",CCount)			//拆分出厂编号
		i snos'="" s snos=snos_","
		s snos=snos_sn
		
		s n=n+1
		s CCount=n*Quantity+EQCount
	}
	quit
}

/// CZF 2022-11-14
/// 描述：提交附属设备记录时生成附属设备台账及新增数据调整
/// w ##class(web.DHCEQ.EM.BUSConfig).SubmitData(112)
ClassMethod SubmitData(rowid)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	n (rowid,User)
	i rowid="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","附属设备ID不能为空!")
	
	s Date=+$h
	s Time=$p($h,",",2)
	s SQLCODE=0
	s $zt="ErrorSubmit"
	s ErrMsg=""
	
	TStart
	&SQL(Update SQLUSER.DHC_EQConfig set C_Status=2 where C_RowID=:rowid)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"^更新附属设备状态失败!错误详细:"_$g(%msg))
	}
	
	//插入台账并进行新增数据调整
	i ##class(web.DHCEQCommon).GetSysInfo("201011")=1
	{
		i $p($g(^DHCEQConfig(rowid)),"^",43)="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","该附属设备已生成台账记录!")
		s SourceType=$p($g(^DHCEQConfig(rowid)),"^",2)
		s SourceID=$p($g(^DHCEQConfig(rowid)),"^",3)
		i (SourceType=2)&&(SourceID'="")
		{
			s CCount=$P($g(^DHCEQConfig(rowid)),"^",7)
			for i = 1:1:CCount
			{
				q:SQLCODE'=0
				s prefix=""
				s sn=$p($P($g(^DHCEQConfig(rowid)),"^",17),",",i)
				s LastEquipID=$Order(^DHCEQEquip(0,"Parent",SourceID,""),-1)	//当前EquipID设备的最后一个附属设备ID
				i LastEquipID="" d
				.s prefix=1
				e  d
				.s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",71)		;No
				.;s prefix=$p($g(^DHCEQEquip(LastEquipID)),"^",85)		;FileNo
				.s prefix=1+$p(prefix,"-",2)
				s prefix=##class(web.DHCEQCCounter).LPAD(prefix,"0",2)
				s RtnInfo=..InsertEquip(rowid,SourceID,sn,prefix,User)  		;生成台账
				
				s SQLCODE=$p(RtnInfo,"^",1)
				s ErrMsg=$p(RtnInfo,"^",2,*)
				q:SQLCODE'=0
				s ConfigEquipID=$p(RtnInfo,"^",2)
				
				//新增数据调整
				k ADPLIST
				s ADPLIST(2)=2 		//新增数据
				s ADPLIST(3)="N"	//reportFlag
				s ADPLIST(4)=Date
				s ADPLIST(5)=Time
				s ADPLIST(6)=""
				s ADPLIST(7)=""
				s ADPLIST(8)="新增台账附属设备"
				s ADPLIST(9)=##class(web.DHCEQCommon).GetTrakNameByID("user",User)		//RequestUser
				s ADPLIST(10)=User
				s ADPLIST(11)=""	//remark
				s ADPLIST(12)="1"	//Status 执行
				s ADPLIST(13)="Y"	//DisplayFlag
				s ADPLIST(14)=User
				s ADPLIST(15)=Date
				s ADPLIST(16)=Time
				//s PLIST(17)=InvalidUserDR
				//s PLIST(18)=InvalidDate
				//s PLIST(19)=InvalidTime
				//s PLIST(20)=InvalidReason
				s ADPLIST(21)=1
				s ADPLIST(22)=""
				s ADPLIST(23)=""
				s ADPLIST(24)=""
				s ADPLIST(25)=""
				&SQL(insert into sqluser.DHC_EQAdjustData values :ADPLIST())
				i SQLCODE s ErrMsg="生成数据调整记录失败，错误信息："_$g(%msg)
				q:SQLCODE'=0
				s AdjustID=$g(%ROWID)
				i AdjustID="" s SQLCODE="-1300",ErrMsg="生成数据调整记录失败！"
				q:SQLCODE'=0
				
				k ADLPLIST
				s EquipData=$g(^DHCEQEquip(ConfigEquipID))
				s ADLPLIST(2)=AdjustID   //ADL_AdjustDataDR
				s AdjustType=$p($g(^DHCEQAdjustData(AdjustID)),"^",1)
				s ADLPLIST(3)=ConfigEquipID   //ADL_EquipDR
				s ADLPLIST(4)=""   //ADL_FromLocDR
				s ADLPLIST(5)=""   //ADL_FromEquipTypeDR
				s ADLPLIST(6)=""   //ADL_FromStatCatDR
				s ADLPLIST(7)=""   //ADL_FromOriginDR
				s ADLPLIST(8)=""   //ADL_FromInfo
				s ADLPLIST(9)=$p(EquipData,"^",67)   //ADL_ToLocDR
				s ADLPLIST(10)=$p(EquipData,"^",63)   //ADL_ToEquipTypeDR
				s ADLPLIST(11)=$p(EquipData,"^",75)   //ADL_ToStatCatDR
				s ADLPLIST(12)=$p(EquipData,"^",20)   //ADL_ToOriginDR
				s ADLPLIST(13)=""   //ADL_ToInfo
				s ADLPLIST(14)=$p(EquipData,"^",38)   //ADL_EQStatus
				s ADLPLIST(15)=$p(EquipData,"^",27)   //ADL_OriginalFee
				s ADLPLIST(16)=$p(EquipData,"^",35)   //ADL_DepreTotal
				s ADLPLIST(17)=$p(EquipData,"^",28)   //ADL_NetFee
				&SQL(insert into sqluser.DHC_EQAdjustDataList values :ADLPLIST())
				i SQLCODE s ErrMsg="生成数据调整明细记录失败，错误信息："_$g(%msg)
				q:SQLCODE'=0
				i AdjustID="" s SQLCODE="-1300",ErrMsg="生成数据调整明细记录失败！"
				q:SQLCODE'=0
			}
			i SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrMsg)
			}
			
			//C_Hold6台账生成标识
			&SQL(Update SQLUSER.DHC_EQConfig set C_Hold6="Y" where C_RowID=:rowid)
			i SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"^更新附属设备台账生成标识错误!错误详细:"_$g(%msg))
			}
		}	
	}
	
	TCommit
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,rowid)
	
ErrorSubmit
	TRollBack
	s ErMsg=$ze
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErMsg)
}

/// CZF 2022-11-14
/// 描述：附属设备插入台账并进行新增数据调整
/// 当配置类型为附属设备且系统参数为1时生成台账
ClassMethod InsertEquip(CRowid, EquipID, sn As %String = "", prefix As %String = "", User As %String = "")
{
	n (CRowid, EquipID, sn, prefix,User)
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$h
	s Time=$p($h,",",2)
	s SQLCODE=0
	s $zt="ErrorInsertEquip"
	
	k CPPI
	s CPPI(8) = $P($g(^DHCEQConfig(CRowid)),"^",4)		;C_ItemDR
	s CPPI(4) = $P($g(^DHCEQConfig(CRowid)),"^",13)  	;C_Model
	i CPPI(4)'="" s CPPI(4) =##Class(web.DHCEQCModel).UpdModel(CPPI(4), CPPI(8))
	s CPPI(2) = $P($g(^DHCEQConfig(CRowid)),"^",5)  	;Name
	s CPPI(5) = $P($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4)  ;EquipCatDR
	s CPPI(6) = $P($g(^DHCEQConfig(CRowid)),"^",8)	;C_UnitDR
	s CPPI(7) = $p($g(^DHCEQCCode("DHCEQCMasterItem", +CPPI(8))),"^",2)	;EQ_Code
	
 	s CPPI(11) = sn										;C_LeaveFacNo
	s CPPI(12) = $P($g(^DHCEQConfig(CRowid)),"^",18)	;C_LeaveDate
	s CPPI(13) = $p($g(^DHCEQEquip(EquipID)),"^",12) 	;EQ_OpenCheckDate					;OpenCheckDate
 	s CPPI(14) = $p($g(^DHCEQEquip(EquipID)),"^",13)	;EQ_CheckDate						;CheckDate
	s CPPI(16) = $P($g(^DHCEQConfig(CRowid)),"^",21)	;C_MeasureFlag	计量标志	Mozy	20180930
	s CPPI(17) = $P($g(^DHCEQConfig(CRowid)),"^",16)  	;C_CountryDR
	s CPPI(18) = $p($g(^DHCEQEquip(EquipID)),"^",17)  	;ManageLocDR
	s CPPI(20) = $p($g(^DHCEQEquip(EquipID)),"^",19)	;UseLoc
	s CPPI(21) = $p($g(^DHCEQEquip(EquipID)),"^",20)	;OriginDR
	s CPPI(22) = $p($g(^DHCEQEquip(EquipID)),"^",21)	;FromDept
	s CPPI(23) = $p($g(^DHCEQEquip(EquipID)),"^",22)	;ToDept
	s CPPI(24) = $p($g(^DHCEQEquip(EquipID)),"^",23)	;BuyTypeDR
	s CPPI(25) = $p($g(^DHCEQEquip(EquipID)),"^",24)	;EquipTechLevelDR
	s CPPI(26) = $P($g(^DHCEQConfig(CRowid)),"^",10)  	;C_VendorDR
	s CPPI(27) = $P($g(^DHCEQConfig(CRowid)),"^",11)  	;C_ManuFactoryDR
	s CPPI(28) = $P($g(^DHCEQConfig(CRowid)),"^",6)		;C_Price
	s CPPI(29) = $P($g(^DHCEQConfig(CRowid)),"^",6)		;NetFee
	
 	i $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4)'="" d
 	.s CPPI(32) = ##Class(web.DHCEQCEquipeCat).GetYearsByCatID($p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",4),$p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",5)) 	;LimitYearsNum
	s CPPI(34)=3		;不计提折旧
	s CPPI(35) = $P($g(^DHCEQConfig(CRowid)),"^",28)	;C_Remark
	s CPPI(39) = $p($g(^DHCEQEquip(EquipID)),"^",38) 	;Status
	s CPPI(40) = $p($g(^DHCEQEquip(EquipID)),"^",39)	;ManageUserDR
	s CPPI(45)=Date		;EQ_StartDate
	s CPPI(46)=Date		;EQ_TransAssetDate
	s CPPI(48) = "N"   	;InputFlag
	s CPPI(51) = $P($g(^DHCEQConfig(CRowid)),"^",22)	;C_GuaranteeStartDate	
	s CPPI(52)= $P($g(^DHCEQConfig(CRowid)),"^",23)		;C_GuaranteeEndDate
	s CPPI(53)=User		;EQ_AddUserDR 
	s CPPI(54)=Date		;EQ_AddDate
	s CPPI(55)=Time		;EQ_AddTime
	s CPPI(56)=User		;EQ_UpdateUserDR
	s CPPI(57)=Date		;EQ_UpdateDate
	s CPPI(58)=Time		;EQ_UpdateTime
	s CPPI(60) = "N"	;EQ_InvalidFlag
	s CPPI(61) = "1"	;EQ_StockStatus
	s CPPI(64) = $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",3) 		//EquipType
	s CPPI(65) = $p($g(^DHCEQEquip(EquipID)),"^",64) 	;PurchaseTypeDR
 	s CPPI(66) = $p($g(^DHCEQEquip(EquipID)),"^",65) 	;PurposeTypeDR
 	s CPPI(67) = $p($g(^DHCEQEquip(EquipID)),"^",66)	;KeeperUserDR
	s CPPI(68) = $p($g(^DHCEQEquip(EquipID)),"^",67)	;StoreLoc
	s CPPI(73) = $P($g(^DHCEQConfig(CRowid)),"^",19)	;C_Location
	i CPPI(73)'="" s CPPI(73)=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding(CPPI(73),4,"","U")_"^"_CPPI(73))
	s CPPI(74) = $P($g(^DHCEQConfig(CRowid)),"^",15)  ;C_GuaranteePeriodNum
	s CPPI(76) = $p($g(^DHCEQCCode("DHCEQCMasterItem",CPPI(8))),"^",5)  	;StatCatDR
	s CPPI(78) = ""
	s CPPI(81)=$P($g(^DHCEQConfig(CRowid)),"^",39)	//厂家建议年限												;OpenCheckListDR
	s CPPI(90) = $P($g(^DHCEQConfig(CRowid)),"^",25)	;C_DisuseDate 	
	s CPPI(93)=$P($g(^DHCEQConfig(CRowid)),"^",38)	//注册证号	
	s CPPI(95) = $P($g(^DHCEQConfig(CRowid)),"^",9)  ;C_BrandDR
	s CPPI(103) = $p($g(^DHCEQEquip(EquipID)),"^",102)  					;RaditionFlag	放射标志
	s CPPI(114)=$P($g(^DHCEQConfig(CRowid)),"^",36)							;ServiceHandler
	s CPPI(115)=$P($g(^DHCEQConfig(CRowid)),"^",37)							;ServiceTel
	;i $p($g(^DHCEQEquip(EquipID)),"^",85)'="" Set CPPI(86) = $p($g(^DHCEQEquip(EquipID)),"^",85)_"-"_prefix	档案号
	s CPPI(120) = EquipID		//主设备ID
	s CPPI(122) = CRowid
    &SQL(Insert Into SQLUSER.DHC_EQEquip Values :CPPI())
    
	i SQLCODE
	{
		 q SQLCODE_"^生成附属设备台账失败!"_$g(%msg)
	}
	s EID=$G(%ROWID)
	i prefix="" d
	.s SQLCODE=##CLASS(web.DHCEQEquip).UpdateEquipNo(EID,Date)
	e  d
	.s tmpeqno=$p($g(^DHCEQEquip(EquipID)),"^",71)_"-"_prefix
	.&SQL(Update SQLUSER.DHC_EQEquip set EQ_No=:tmpeqno Where EQ_RowID=:EID)
	i SQLCODE
	{
		 q SQLCODE_"^更新附属设备编号失败!错误信息："_$g(%msg)
	}
	
	i $P($g(^DHCEQConfig(CRowid)),"^",21)="Y"
	{
		Set TMPEAID=""
		Set EAID=0
		For  Set EAID=$Order(^DHCEQCCode("DHCEQCEquipAttribute",0,"Code",11,EAID)) Quit:(EAID="")||(TMPEAID'="")  Do
		.Quit:$p($g(^DHCEQCCode("DHCEQCEquipAttribute",EAID)),"^",5)="Y"
		.Set TMPEAID=EAID
		i TMPEAID'="" &SQL(insert into sqluser.DHC_EQEquipAttributeList (EAL_EquipAttributeDR,EAL_SourceType,EAL_SourceID) values (:TMPEAID,'3',:EID))
	}
	q SQLCODE_"^"_EID
	
ErrorInsertEquip
	s ErMsg=$ze
	q "-1300^"_ErMsg
}

/// Creator：      MZY0156	3373159		2023-03-24
/// CreatDate：    2023-3-
/// Description:   获取验收单打印附属设备清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSConfig","OCRConfigList",95)
Query OCRConfigList(RowID As %String = "") As %Query(ROWSPEC = "TOCRHold1:%String,TProvider:%String,TBuyType:%String,TName:%String,TEquipType:%String,TModel:%String,TEquipCat:%String,TUnit:%String,TManuFactory:%String,TQuantity:%String,TOriginalFee:%String,TotalFee:%String,TCheckDate:%String,TLeaveFactoryNo:%String,TUseLoc:%String,TPurposeType:%String,TCurrency:%String,TConfigState:%String,TFileState:%String,TFileNo:%String,TRunningState:%String,TPackageState:%String,TRemark:%String,TRowid:%String,CItem:%String,CPrice:%String,CQuantityNum:%String,CUnit:%String,CProvider:%String,CManuFactory:%String,CModel:%String,CLeaveFacNo:%String,CLeaveDate:%String")
{
}

ClassMethod OCRConfigListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	;s ^DHCEQMozy("web.DHCEQ.EM.BUSConfig.OCRConfigList")=RowID
	i RowID="" Quit $$$OK
	s OCLDR=$Order(^DHCEQOpenCheckList(0,"OpenCheckRequest",RowID,""))
	i OCLDR="" Quit $$$OK
	s index=1
	
	s TOCRHold1=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",37)
	s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$P($g(^DHCEQOpenCheckRequest(RowID)),"^",5))
	s TConfigState=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",13)
	s TFileState=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",14)
	s TRunningState=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",16)
	s TPackageState=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",12)
	s TRemark=$P($g(^DHCEQOpenCheckRequest(RowID)),"^",21)

	s TName=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",2)
	s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",3))
	s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",5))
	s TEquipCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",6))
	s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",7))
	s TBuyType=##class(web.DHCEQCommon).GetTrakNameByID("buytype",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",13))
	s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",15))
	s TQuantity=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",16)
	s TOriginalFee=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",17)
	s TotalFee=TOriginalFee*TQuantity
	s TCheckDate=##Class(web.DHCEQCommon).TransValueToPage($P($g(^DHCEQOpenCheckList(OCLDR)),"^",46),"date")
	s TLeaveFactoryNo=$g(^DHCEQOpenCheckList(OCLDR,"EX"))
	s TFileNo=$g(^DHCEQOpenCheckList(OCLDR,"FileNo"))
	s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",33))
	s TPurposeType=##class(web.DHCEQCommon).GetTrakNameByID("purposetype",$P($g(^DHCEQOpenCheckList(OCLDR)),"^",24))
	s TCurrency=$P($g(^DHCEQOpenCheckList(OCLDR)),"^",21)

	s configInfo=""
	s CRowid=0
	f  s CRowid=$Order(^DHCEQConfig(0,"SourceID",1,OCLDR,CRowid)) Quit:(CRowid="")  Do
	.s TRowid=CRowid
	.
	.s CItem=$P($g(^DHCEQConfig(TRowid)),"^",5)
	.s CPrice=$P($g(^DHCEQConfig(TRowid)),"^",6)
	.s CQuantityNum=$P($g(^DHCEQConfig(TRowid)),"^",7)
	.s CUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",$P($g(^DHCEQConfig(TRowid)),"^",8))
	.s CProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$P($g(^DHCEQConfig(TRowid)),"^",10))
	.s CManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$P($g(^DHCEQConfig(TRowid)),"^",11))
	.s CModel=$P($g(^DHCEQConfig(TRowid)),"^",13)
	.s CLeaveFacNo=$P($g(^DHCEQConfig(TRowid)),"^",17)
	.s CLeaveDate=##Class(web.DHCEQCommon).TransValueToPage($P($g(^DHCEQConfig(TRowid)),"^",18),"date")
	.d OutputRowOCRConfigList
	
	Quit $$$OK
OutputRowOCRConfigList
	Set Data=$lb(TOCRHold1,TProvider,TBuyType,TName,TEquipType,TModel,TEquipCat,TUnit,TManuFactory,TQuantity,TOriginalFee,TotalFee,TCheckDate,TLeaveFactoryNo,TUseLoc,TPurposeType,TCurrency,TConfigState,TFileState,TFileNo,TRunningState,TPackageState,TRemark,TRowid,CItem,CPrice,CQuantityNum,CUnit,CProvider,CManuFactory,CModel,CLeaveFacNo,CLeaveDate)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod OCRConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OCRConfigListExecute ]
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

ClassMethod OCRConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OCRConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
