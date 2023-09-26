Class web.DHCEQ.EM.CTMasterItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询设备项
/// 入参：EquipTypeDR 设备类组id
///      StatCatDR 设备类型id
///      Name 设备项名称
///      AssetType 资产类型
///      MaintFlag 维修标记
/// 		CurItemDR	Mozy003014	2020-4-21	只显示当前设备项
/// modify by lmm 2019-08-06 972010 增加入参 ExportType 有值时不输出内容 
/// d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.CTMasterItem","GetMasterItem","","","","","","","","id1")
Query GetMasterItem(EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", MaintFlag As %Library.String = "", ExportType As %Library.String = "", CurItemDR As %Library.String = "", EquipAttributeString As %String = "", InCloudFlag As %String = "", EquipCatDR As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TCatDR:%String,TCat:%String,TUnitDR:%String,TUnit:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TDepreMethodDR:%String,TDepreMethod:%String,TLimitYearsNum:%String,THold2:%String,THold2Desc:%String,TComputerFlag:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", MaintFlag As %Library.String = "", ExportType As %Library.String = "", CurItemDR As %Library.String = "", EquipAttributeString As %String = "", InCloudFlag As %String = "", EquipCatDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if ExportType'="" Quit $$$OK //add by lmm 2019-08-06 972010
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",MaintFlag)'=0
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
	..d ResetVariablesGetItem
	..d BuildDataGetItem
		
	Quit $$$OK
	
BuildDataGetItem
	;当前登录人是否有权限查看表数据 CZF0138
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCMasterItem",rowid,sHospID)'="Y"
	s TRowID = rowid
	q:(CurItemDR'="")&&(CurItemDR'=TRowID)	;Mozy003014		2020-04-21
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	q:(StatCatDR'="")&&(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)
	q:(TStatCatDR'="")&(+AssetType>0)&(AssetType'=$Piece($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",5))	/// Mozy0145	20141017
	i TStatCatDR'="" d
	.s TStatCat=$P($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TDepreMethodDR=$P($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",11)	// MZY0030	1340074		2020-06-01
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	q:(EquipCatDR'="")&&(EquipCatDR'=TCatDR)  //add by lmm 2020-05-14
	i TCatDR'="" d
	.s TCat=$P($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",2) //modified by zyq 2022-10-10
	.s TLimitYearsNum=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)	;Modified by jdl 2012-3-7 JDL0120
	.i TDepreMethodDR="" s TDepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(TCatDR)	// MZY0030	1340074		2020-06-01
	.i TDepreMethodDR'="" d
	..s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	;Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TCatDR,"","",rowid))
	//add by lmm 2020-05-07 begin
	set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	i (EquipAttributeString'="")
	{
		s EALength=$L(EquipAttributeString,SplitNumCode)
		s hasFlag=1
		f i=1:1:EALength d
		.q:hasFlag'=1
		.s EquipAttributeID=$p($P(EquipAttributeString,SplitNumCode,i),"id",2)
		.;modify by lmm 2020-09-07 1485332
		.i (InCloudFlag="")&&($o(^DHCEQEquipAttributeList(0,"SourceAttribute",1,rowid,EquipAttributeID,0))="") s hasFlag=0
		.i (InCloudFlag="Y")&&($o(^DHCEQEquipAttributeList(0,"SourceAttribute",1,rowid,EquipAttributeID,0))'="") s hasFlag=0
		i hasFlag=0 {quit}
	}	
	i ($o(^DHCEQEquipAttributeList(0,"SourceAttribute",1,rowid,1,0))'="")
	{
		s TComputerFlag="Y"
	}
	else
	{
		s TComputerFlag="N"
	}
	//add by lmm 2020-05-07 end
	d OutputRowGetItem
	quit
OutputRowGetItem
	s Data=$lb(TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc,TComputerFlag) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
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

/// modified by ZY0302 20220601
/// Creator:	CZF0138
/// CreatDate:	2021-04-28
/// Description:查询设备项
/// Input:		Params:Json格式字符串,EquipAttributeString:设备属性,EquipAttributeStringCat:设备属性分类
/// Command:	d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.CTMasterItem","MasterItem","{""_HospList"":""东华标准版数字化口腔医院"",""MICode"":"""",""MIEquipTypeDR_ETDesc"":"""",""MIHold1_TDesc"":"""",""MIDesc"":"""",""MIStatCatDR_SCDesc"":"""",""MIHold1Code"":"""",""MIUnitDR_UOMDesc"":"""",""MIEquipCatDR_ECDesc"":"""",""MIRowID"":"""",""MIEquipTypeDR"":"""",""MIHold1"":"""",""MIStatCatDR"":"""",""MIUnitDR"":"""",""MIEquipCatDR"":"""",""ReadOnly"":"""",""MIRemark"":"""",""gHospId"":""2"",""BDPHospId"":""3""}")
Query MasterItem(Params As %String, EquipAttributeString As %String = "", EquipAttributeStringCat As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TEquipType:%String,TEquipTypeDR:%String,TCatDR:%String,TCat:%String,TStatCatDR:%String,TStatCat:%String,TRemark:%String,TUnitDR:%String,TUnit:%String,TInvalidFlag:%String,TCFDADR:%String,TCFDAListDR:%String,THospitalDR:%String,TManageLevel:%String,TLocalWJWCode:%String,TLocalFinanceCode:%String,TCFDADesc:%String,THospital:%String,TJob:%String,TCFDACode:%String,TCatCode:%String,TRow:%String,TMeasureFee:%String,TIsStandard:%String,TStandardItemDR:%String,TStandardItem:%String")
{
}

ClassMethod MasterItemExecute(ByRef qHandle As %Binary, Params As %String, EquipAttributeString As %String = "", EquipAttributeStringCat As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s MstItmObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(Params)
	s Code=MstItmObj.%Get("MICode")
	s Desc=MstItmObj.%Get("MIDesc")
	s EquipTypeDR=MstItmObj.%Get("MIEquipTypeDR")
	s EquipType=MstItmObj.%Get("MIEquipTypeDR_ETDesc")
	s CatDR=MstItmObj.%Get("MIEquipCatDR")
	s Cat=MstItmObj.%Get("MIEquipCatDR_ECDesc")
	s StatCatDR=MstItmObj.%Get("MIStatCatDR")
	s StatCat=MstItmObj.%Get("MIStatCatDR_SCDesc")
	/// modified by ZY0302 20220601
	s MICFDADR=MstItmObj.%Get("MICFDADR")
	s MICFDACode=MstItmObj.%Get("MICFDADR_TCode")
	s MICFDADesc=MstItmObj.%Get("MICFDADR_TDesc")
	s gHospId=MstItmObj.%Get("gHospId") 
	s BDPHospId=MstItmObj.%Get("BDPHospId")
	s IsStandard=MstItmObj.%Get("MIStandFlag")
	s IsStandard=$case(IsStandard,"1":"Y",:"")
	s StandardItemDR=MstItmObj.%Get("MIStandItemDR")
	s StandardItem=MstItmObj.%Get("MIStandItemDR_MIDesc")
	///end modified by ZY0302 20220601
	
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Cat=$ZCONVERT(Cat ,"U")
 	s StatCat=$ZCONVERT(StatCat ,"U")
 	s EquipType=$ZCONVERT(EquipType ,"U")
	s index=1
	s TRow=1
	s TJob=$j
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	s LTEquipTypeDR=0
	f  s LTEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",LTEquipTypeDR))  quit:LTEquipTypeDR=""  d
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=LTEquipTypeDR)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(LTEquipTypeDR,"","","2")'=0 
	.s LTEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",LTEquipTypeDR)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",LTEquipTypeDR,rowid))  quit:rowid=""  d
	..d ResetVariablesGetMasterItem
	..d BuildDataGetMasterItem
		
	d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQCMasterItem.MasterItem",TJob,index-1)
	
	Quit $$$OK
BuildDataGetMasterItem
	;当前登录人是否有权限查看表数据 CZF0138
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCMasterItem",rowid,sHospID)'="Y"
	s LTRowID = rowid
	s LTCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	s LTDesc=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s LTCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i LTCatDR'=""  d
	.s LTCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",LTCatDR)),"^",2) 
	.s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",LTCatDR)),"^",1) 
	s LTStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5) 
	i LTStatCatDR'="" s LTStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",LTStatCatDR)),"^",2) 
	s LTRemark=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",6)
	s LTUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i LTUnitDR'="" s LTUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",(LTUnitDR))
	s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:LTInvalidFlag="Y"
	q:(Desc'="")&&(($ZCONVERT(LTDesc ,"U")'[$ZCONVERT(Desc,"U"))&&($ZCONVERT(LTCode,"U")'[$ZCONVERT(Desc,"U")))   //modified by MYL 20221114 增加拼音查询
	q:($ZCONVERT(LTEquipType,"U")'[EquipType)&(EquipType'="")
	q:($ZCONVERT(LTCat,"U")'[Cat)&(Cat'="")
	q:($ZCONVERT(LTStatCat,"U")'[StatCat)&(StatCat'="")
	q:(EquipTypeDR'="")&(EquipTypeDR'=LTEquipTypeDR)
	q:(CatDR'="")&(CatDR'=LTCatDR)
	q:(StatCatDR'="")&(StatCatDR'=LTStatCatDR)
	s ENSRowID=$o(^DHCEQCCode("DHCEQETNotAccessSC",0,"StatCat",LTEquipTypeDR,LTStatCatDR,""))
	q:$p($g(^DHCEQCCode("DHCEQETNotAccessSC",+ENSRowID)),"^",4)="Y"
	/// modified by ZY0302 20220601
	//s TForceInspectFlag=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",9)
	s TCFDADR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",9)
	q:(MICFDADR'="")&&(TCFDADR'=MICFDADR)
	i TCFDADR'=""
	{
		s TCFDACode=$P(^DHCEQCCode("DHCEQCTree",TCFDADR),"^",2)
		s TCFDADesc=$P(^DHCEQCCode("DHCEQCTree",TCFDADR),"^",3)
	}
	s TCFDAListDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",10)
	s THospitalDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	s THospital=##class(web.DHCEQCommon).GetTrakNameByID("CTHospital",THospitalDR)
	s TManageLevel=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)
	s TLocalWJWCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",13)
	s TLocalFinanceCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",14)
	s TMeasureFee=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",20)	//czf 1283059 单台计量费用
	s TIsStandard=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",21)	//是否标准设备项
	q:(IsStandard'="")&&(IsStandard'=TIsStandard)
	s TIsStandard=$case(TIsStandard,"Y":"是",:"否")
	s TStandardItemDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",22)
	q:(StandardItemDR'="")&&(StandardItemDR'=TStandardItemDR)
	i TStandardItemDR'="" s TStandardItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TStandardItemDR)),"^",1)
	//end modified by ZY0302 20220601
    // add by LMH 20220725 BUG LMH0012
    //start by LMH  20220725 BUG LMH0012 
	//设备属性查询过滤
	Set SplitNumCode="^" 
	i (EquipAttributeString'="")
	{
		s EALength=$L(EquipAttributeString,SplitNumCode)
		s hasFlag=1
		f i=1:1:EALength d
		.q:hasFlag'=1
		.s EquipAttributeID=$p($P(EquipAttributeString,SplitNumCode,i),"id",2)
		.q:EquipAttributeID=""
		.i $o(^DHCEQEquipAttributeList(0,"SourceAttribute",1,rowid,EquipAttributeID,0))="" s hasFlag=0
		i hasFlag=0  quit 
	}
	//设备属性分类过滤
	i (EquipAttributeStringCat'="")
	{
		s EACLength=$L(EquipAttributeStringCat,",")
		s hasFlag=1
		f i=1:1:EACLength d
		.q:hasFlag'=1
		.s EquipAttributeCatID=$P(EquipAttributeStringCat,",",i)
		.q:EquipAttributeCatID=""
		.i $o(^DHCEQEquipAttributeList(0,"SubInfo",1,rowid,EquipAttributeCatID,0))="" s hasFlag=0 //modified by LMH 20220909 2651629 修改soursetype错误 3改为1
		i hasFlag=0 quit 
	}
	//end by LMH  20220725 BUG LMH0012
	d OutputRowGetMasterItem
	quit
OutputRowGetMasterItem
	s Data=$lb(LTRowID,LTCode,LTDesc,LTEquipType,LTEquipTypeDR,LTCatDR,LTCat,LTStatCatDR,LTStatCat,LTRemark,LTUnitDR,LTUnit,LTInvalidFlag,TCFDADR,TCFDAListDR,THospitalDR,TManageLevel,TLocalWJWCode,TLocalFinanceCode,TCFDADesc,THospital,TJob,TCFDACode,TCatCode,TRow,TMeasureFee,TIsStandard,TStandardItemDR,TStandardItem)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetMasterItem
	s (LTRowID,LTCode,LTDesc,LTCatDR,LTCat,LTStatCatDR,LTStatCat,LTRemark,LTUnitDR,LTUnit,LTInvalidFlag)=""
	s (TForceInspectFlag,TCFDADR,TCFDAListDR,THospitalDR,TManageLevel,TLocalWJWCode,TLocalFinanceCode,TCFDADesc,THospital,TCFDACode,TCatCode,TMeasureFee,TIsStandard,TStandardItemDR,TStandardItem)=""
	quit
}

ClassMethod MasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MasterItemExecute ]
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

ClassMethod MasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// modified by ZY0302 20220601 json方式交互 修改表结构字段
/// Creator:	CZF0138
/// CreatDate:	2021-04-28
/// Description:设备项保存方法
/// Input:		val:设备项数据json
/// 			isDel:删除标志
/// 			EquipAttribute:设备属性id串(id1^id2^id100)
/// 			gHospId:登录医院ID
/// 			BDPHospId:平台组件医院ID
/// Output:		成功:RowID，失败:SQLCODE
/// Command:	w ##class(web.DHCEQ.EM.CTMasterItem).SaveData("","","^电脑[总院]^DN^2^354^8^^4^^^^^^^^","","","2","2")
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "", EquipAttribute As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "", EquipAttributeStringCat As %String = "")
{
	k PLIST,rowid
	//s rowid=$p(val,"^",1)	/// modified by ZY0302 20220601
	Set $ZT="ERROR"
	
	s TableName="DHC_EQCMasterItem"
	s ClassName="User.DHCEQCMasterItem"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	//s BussID=rowid	/// modified by ZY0302 20220601
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	 
	TSTART
	i (+isDel=1)
	{
		/// modified by ZY0302 20220601
		s BussID=val
		s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		
	 	s PLIST(9)="Y"
	 	&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :BussID) 

		If SQLCODE
		{
			TRollback
			q SQLCODE
		}
		/*
		/// modified by ZY0302 20220601
		;删除设备项医院对照关系
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCMasterItem",BussID,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			Quit RtnCode
		}
		*/
		;保存数据日志
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""MIInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i Rtn
		{
			TRollback
			q Rtn
		}
		TCommit
		Quit BussID
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCMasterItem",JsonData,.PLIST)
		s rowid = JsonData.MIRowID
		i (+isDel=3) s rowid=""
		s Desc=JsonData.MIDesc
		s Code=JsonData.MICode
		s EquipTypeDR=JsonData.MIEqupTypeDR
		s StandFlag=JsonData.MIStandFlag
		s PLIST(9) ="N"
		i PLIST(22)="true" d	//add by fx0008 2759984
		.s PLIST(22)="Y"
		e  d
		.s PLIST(22)="N"
		;判断数据是否重复 CZF0138
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCMasterItem",rowid,Code_"^"_Desc_"^"_EquipTypeDR,sHospID)
		s FindRowID=$p(RtnInfo,"$",1)
		
		if (FindRowID="")
		{
		 	i (rowid="")
		 	{
			 	Set BussID="",OperateType="A"
				&SQL(Insert Into SQLUSER.DHC_EQCMasterItem Values :PLIST())
			} 
			else
			{
				Set BussID=rowid,OperateType="U"
				s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :rowid) 	 
			}
		}
		else
		{
			 q:rowid="" ""
			 q:(rowid'="")&&(rowid'=FindRowID) ""
			 Set BussID=rowid,OperateType="U"
			 s OldObject=##Class(User.DHCEQCMasterItem).%OpenId(BussID)
			 s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			 &SQL(Update SQLUSER.DHC_EQCMasterItem Values :PLIST() where MI_RowID = :rowid)
		}
		If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
		Set ID=$g(%ROWID)
		;标准设备项ID更新 czf 2021-07-19
		i StandFlag="Y"
		{
			&SQL(Update SQLUSER.DHC_EQCMasterItem set MI_StandItemDR=:ID where MI_RowID = :ID)
		}
		else
		{
			//&SQL(Update SQLUSER.DHC_EQCMasterItem set MI_StandItemDR=NULL where MI_RowID = :ID)
		}
		If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
		
		;保存设备项医院对照关系 CZF0138
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCMasterItem",ID,sHospID)
	    if RtnCode<0
		{
			TROLLBACK
			Quit RtnCode
		}
	    
	    ;数据日志更新
		s OldObject=""	//先关闭对象 czf 2021-01-21
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCMasterItem).%OpenId(ID))
		i BussID'=""	//更新数据获取更新字段Json串
		{
			s key=""
			For
			{
				s value=FinalObj.GetNext(.key)
				q:key=""
	    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
			}
		}
		else			//插入数据
		{
			s BussID=ID
			s NewObj=FinalObj
		}
	
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
			If Rtn
		 	{
			 	TRollback
			 	q Rtn
			}
		}
 	
	 	;设备属性相关调整
	 	Set return=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(1,ID,EquipAttribute)
		if return
		{
			TROLLBACK
			Quit return
		}
		
		;设备属性分类保存 czf 2022-04-14
		set return=##class(web.DHCEQ.EM.BUSAttributeCat).SaveEQAttributeCat(1,ID,EquipAttributeStringCat)
		if return
		{
			TRollback
			q Rtn
		}
		
		TCOMMIT
	 	q ID
	}
ERROR
 	Set ErrorMsg=$ZE	          
 	TROLLBACK		       
 	Quit "<ERROR>"_ErrorMsg
}

/// Createor:CZF 2021-07-15 1967027
/// Description：标准设备项放大镜
/// Input：EquipTypeDR 设备类组id
///      StatCatDR 设备类型id
///      Name 标准设备项名称
///      EquipCatDR 设备分类id 
/// OutPut:TName,TRowID,TCode,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TTreeCode,TUnitDR,TUnit
/// d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.CTMasterItem","StandardItem","3","","","")
Query StandardItem(EquipTypeDR As %String, StatCatDR As %String = "", Name As %String = "", EquipCatDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,TRowID:%String,TCode:%String,TEquipTypeDR:%String,TEquipType:%String:设备类组,TStatCatDR:%String,TStatCat:%String:设备类型,TCatDR:%String,TCatDesc:%String:设备分类,TCatCode:%String:分类代码,TTreeCatDR:%String,TTreeCat:%String:68分类,TTreeCode:%String:68分类代码,TUnitDR:%String,TUnit:%String:单位")
{
}

ClassMethod StandardItemExecute(ByRef qHandle As %Binary, EquipTypeDR As %String, StatCatDR As %String = "", Name As %String = "", EquipCatDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
	.q:(EquipTypeDR'="")&&((","_EquipTypeDR_",")'[(","_TEquipTypeDR_",")) // modify by cjc 2022-07-26 增加管理类组多选筛选 需求2772683
	.s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
	..d ResetStandardItem
	..d BuildDataStandardItem
	
	Quit $$$OK
BuildDataStandardItem
	s TRowID = rowid
	s StandardItemInfo=$g(^DHCEQCCode("DHCEQCMasterItem",rowid))
	q:$p(StandardItemInfo,"^",8)="Y"
	q:$p(StandardItemInfo,"^",21)'="Y"	//过滤非标准设备项
	s TName=$p(StandardItemInfo,"^",1)
	s TCode=$p(StandardItemInfo,"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	s TCatDR=$p(StandardItemInfo,"^",4)
	q:(EquipCatDR'="")&(EquipCatDR'=TCatDR)
	s TStatCatDR=$p(StandardItemInfo,"^",5)
	q:(StatCatDR'="")&(StatCatDR'=TStatCatDR)
	s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	i TCatDR'=""  d
	.s TCatDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",2) 
	.s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",1)
	s TTreeCatDR=$p(StandardItemInfo,"^",10)
	i TTreeCatDR'="" d
	.s TTreeCat=$p($g(^DHCEQCCode("DHCEQCTree",TTreeCatDR)),"^",3)
	.s TTreeCode=$p($g(^DHCEQCCode("DHCEQCTree",TTreeCatDR)),"^",2)
	s TUnitDR=$p(StandardItemInfo,"^",7)
	s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	d OutputRowStandardItem
	quit
OutputRowStandardItem
	s Data=$lb(TName,TRowID,TCode,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TTreeCode,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetStandardItem
	s (TRowID,StandardItemInfo,TName,TCode,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TTreeCode,TUnitDR,TUnit)=""
	quit
}

ClassMethod StandardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StandardItemExecute ]
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

ClassMethod StandardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StandardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY0302 20220601
/// w ##Class(web.DHCEQ.EM.CTMasterItem).GetOneMasterItem(1)
ClassMethod GetOneMasterItem(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneMasterItem"
	s ObjMasterItem=##Class(User.DHCEQCMasterItem).%OpenId(RowID)
	s MasterItemInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjMasterItem)
	d MasterItemInfo.%Set("MIRowID",RowID)
	d MasterItemInfo.%Set("MIEquipTypeDR_ETDesc",ObjMasterItem.MIEquipTypeDR.ETDesc)
	d MasterItemInfo.%Set("MICatDR_ECDesc",ObjMasterItem.MICatDR.ECDesc)
	d MasterItemInfo.%Set("MIStatCatDR_SCDesc",ObjMasterItem.MIStatCatDR.SCDesc)
	d MasterItemInfo.%Set("MIUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjMasterItem.MIUnitDR))
	d MasterItemInfo.%Set("MICFDADR_TDesc",ObjMasterItem.MICFDADR.TDesc)
	d MasterItemInfo.%Set("MICFDADR_TCode",ObjMasterItem.MICFDADR.TCode)
	d MasterItemInfo.%Set("MIHospitalDR_CTDesc",##class(web.DHCEQCommon).GetTrakNameByID("CTHospital",ObjMasterItem.MIHospitalDR))
	d MasterItemInfo.%Set("MIStandItemDR_MIDesc",ObjMasterItem.MIStandItemDR.MIDesc)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,MasterItemInfo)
ERRORGetOneMasterItem
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

}
