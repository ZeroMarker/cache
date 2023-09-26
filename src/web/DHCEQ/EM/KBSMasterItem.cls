Class web.DHCEQ.EM.KBSMasterItem Extends %RegisteredObject [ ClassType = "" ]
{

/// Creator:	CZF 1967027
/// CreatDate:	2021-06-28
/// Description:查询参考设备项
/// Input:		Params:Json格式字符串
/// Command:	d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.KBSMasterItem","KBSMasterItem","{""_HospList"":""东华标准版数字化口腔医院"",""MICode"":"""",""MIEquipTypeDR_ETDesc"":"""",""MIHold1_TDesc"":"""",""MIDesc"":"""",""MIStatCatDR_SCDesc"":"""",""MIHold1Code"":"""",""MIUnitDR_UOMDesc"":"""",""MIEquipCatDR_ECDesc"":"""",""MIRowID"":"""",""MIEquipTypeDR"":"""",""MIHold1"":"""",""MIStatCatDR"":"""",""MIUnitDR"":"""",""MIEquipCatDR"":"""",""ReadOnly"":"""",""MIRemark"":"""",""gHospId"":""2"",""BDPHospId"":""3""}")
Query KBSMasterItem(Params As %String) As %Query(ROWSPEC = "TRow:%String,TRowID:%String,TDesc:%String,TCode:%String,TFinanceTypeDR:%String,TFinanceType:%String,TStatCatDR:%String,TStatCat:%String,TCatDR:%String,TCatDesc:%String,TCatCode:%String,TTreeCatDR:%String,TTreeCat:%String,TUnitDR:%String,TUnit:%String,TForceInspectFlag:%String,TMedicalFlag:%String,TRaditionFlag:%String,TMesureFlagFlag:%String,TCycleNum:%String,TCycleUnitDR:%String,TCycleUnit:%String,TRemark:%String")
{
}

ClassMethod KBSMasterItemExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	//new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s MstItmObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(Params)
	s Code=MstItmObj.%Get("SMICode")
	s Desc=MstItmObj.%Get("SMIDesc")
	s FinanceTypeDR=MstItmObj.%Get("SMIFinanceTypeDR")
	s FinanceType=MstItmObj.%Get("SMIFinanceTypeDR_FTDesc")
	s StatCatDR=MstItmObj.%Get("SMIStatCatDR")
	s StatCat=MstItmObj.%Get("SMIStatCatDR_SCDesc")
	s CatDR=MstItmObj.%Get("SMICatDR")
	s Cat=MstItmObj.%Get("SMICatDR_ECDesc")
	s TreeDR=MstItmObj.%Get("SMITreeDR")
	s TreeCat=MstItmObj.%Get("SMITreeDR_TDesc")
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Cat=$ZCONVERT(Cat ,"U")
 	s StatCat=$ZCONVERT(StatCat ,"U")
 	s FinanceType=$ZCONVERT(FinanceType ,"U")
	s index=1
	s TRow=1
	s TJob=$j
	
	s TFinanceTypeDR=0
	f  s TFinanceTypeDR=$o(^DHCEQKB("DHCEQKBSMstItem",0,"FinanceTypeDR",TFinanceTypeDR))  quit:TFinanceTypeDR=""  d
	.q:(FinanceTypeDR'="")&&(FinanceTypeDR'=TFinanceTypeDR)
	.s TFinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",TFinanceTypeDR)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQKB("DHCEQKBSMstItem",0,"FinanceTypeDR",TFinanceTypeDR,rowid))  quit:rowid=""  d
	..d ResetKBSMasterItem
	..d BuildDataKBSMasterItem
	
	Quit $$$OK
BuildDataKBSMasterItem
	s TRowID = rowid
	s KBSMsterItemInfo=$g(^DHCEQKB("DHCEQKBSMstItem",rowid))
	q:$p(KBSMsterItemInfo,"^",8)="Y"
	s TDesc=$p(KBSMsterItemInfo,"^",1)
	s TCode=$p(KBSMsterItemInfo,"^",2)
	q:($ZCONVERT(TCode,"U")'[Code)&(Code'="") 
	q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	s TStatCatDR=$p(KBSMsterItemInfo,"^",4)
	q:(StatCatDR'="")&(StatCatDR'=TStatCatDR)
	s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	q:($ZCONVERT(TStatCat,"U")'[StatCat)&(StatCat'="")
	s TCatDR=$p(KBSMsterItemInfo,"^",5)
	q:(CatDR'="")&(CatDR'=TCatDR)
	i TCatDR'=""  d
	.s TCatDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",2) 
	.s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",1)
	q:($ZCONVERT(TCatDesc,"U")'[Cat)&(Cat'="")
	s TTreeCatDR=$p(KBSMsterItemInfo,"^",6)
	i TTreeCatDR'="" s TTreeCat=$p($g(^DHCEQCCode("DHCEQCTree",TTreeCatDR)),"^",3)
	s TUnitDR=$p(KBSMsterItemInfo,"^",7)
	s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TForceInspectFlag=$p(KBSMsterItemInfo,"^",9)	;强检标志
	s TForceInspectFlag=$case(TForceInspectFlag,"Y":"是","N":"否",:"")
	s TMedicalFlag=$p(KBSMsterItemInfo,"^",10)		;医疗标志
	s TMedicalFlag=$case(TMedicalFlag,"Y":"是","N":"否",:"")
	s TRaditionFlag=$p(KBSMsterItemInfo,"^",11)		;放射标志
	s TRaditionFlag=$case(TRaditionFlag,"Y":"是","N":"否",:"")
	s TMesureFlagFlag=$p(KBSMsterItemInfo,"^",12)	;计量标志
	s TMesureFlagFlag=$case(TMesureFlagFlag,"Y":"是","N":"否",:"")
	s TCycleNum=$p(KBSMsterItemInfo,"^",13)
	s TCycleUnitDR=$p(KBSMsterItemInfo,"^",14)
	s TCycleUnit=##class(web.DHCEQCommon).GetTrakNameByID("cycleunit",TCycleUnitDR)
	s TRemark=$p(KBSMsterItemInfo,"^",15)
	d OutputRowKBSMasterItem
	quit
OutputRowKBSMasterItem
	s Data=$lb(TRow,TRowID,TDesc,TCode,TFinanceTypeDR,TFinanceType,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TUnitDR,TUnit,TForceInspectFlag,TMedicalFlag,TRaditionFlag,TMesureFlagFlag,TCycleNum,TCycleUnitDR,TCycleUnit,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetKBSMasterItem
	s (TRowID,KBSMsterItemInfo,TDesc,TCode,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TUnitDR,TUnit)=""
	s (TForceInspectFlag,TMedicalFlag,TRaditionFlag,TMesureFlagFlag,TCycleNum,TCycleUnitDR,TCycleUnit,TRemark)=""
	quit
}

ClassMethod KBSMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = KBSMasterItemExecute ]
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

ClassMethod KBSMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = KBSMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Creator:	CZF 1967027
/// CreatDate:	2021-06-28
/// Description:参考设备项保存方法
/// Input:		data:设备项json数据串
/// 			DelIs:删除标志
/// Output:		成功:RowID，失败:SQLCODE
/// Command:	w ##class(web.DHCEQ.EM.KBSMasterItem).SaveData("^电脑[总院]^DN^2^354^8^^4^^^^^^^^","")
ClassMethod SaveData(data As %Library.String = "", DelIs As %Library.String = "")
{
	k PLIST,rowid
	Set $ZT="ERRORSave"
	s SQLCODE=0
	
	TSTART
	i (+DelIs=1)
	{
		s rowid=data
	 	&SQL(Update SQLUSER.DHC_EQKBSMstItem Set SMI_InvalidFlag='Y' where SMI_RowID = :rowid)
	 	If SQLCODE
	 	{
		 	TRollback
		 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s ID=rowid
	} 
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQKBSMstItem",JsonData,.PLIST)
		s PLIST(9) = "N"
		s rowid=JsonData.SMIRowID
		s Desc=JsonData.SMIDesc
		s Code=JsonData.SMICode
		s FinanceTypeDR=JsonData.SMIFinanceTypeDR
		i Desc="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"描述不能为空!")
		i Code="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"代码不能为空!")
		i FinanceTypeDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"资产大类不能为空!")
		
		s Rowid=""
		&SQL(select SMI_RowID into :Rowid from SQLUSER.DHC_EQKBSMstItem where SMI_Code=:Code and SMI_Desc=:Desc and SMI_FinanceTypeDR=:FinanceTypeDR and SMI_InvalidFlag='N')
		
		if (Rowid="")
		{
		 	i (rowid="")
		 	{
				&SQL(Insert Into SQLUSER.DHC_EQKBSMstItem Values :PLIST())
			} 
			else
			{
				&SQL(Update SQLUSER.DHC_EQKBSMstItem Values :PLIST() where SMI_RowID = :rowid) 	 
			}
		}
		else
		{
			 q:rowid="" ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"数据重复!"_Rowid)
			 q:(rowid'="")&&(rowid'=Rowid) ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"数据重复!")
			 &SQL(Update SQLUSER.DHC_EQKBSMstItem Values :PLIST() where SMI_RowID = :rowid)
		}
		If SQLCODE
	 	{
		 	TRollback
		 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set ID=$g(%ROWID)
	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
ERRORSave
 	s ErrorMsg=$ZE
 	TRollback
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Creator:	CZF 1967027
/// CreatDate:	2021-06-28
/// Description:获取参考设备项行记录
/// Input:		RowID:标准设备项RowID
/// Output:		
/// Command:	w ##class(web.DHCEQ.EM.KBSMasterItem).GetOneKBSMstItem("1")
ClassMethod GetOneKBSMstItem(RowID)
{
	s $ZT="ERRORGetOneKBSMstItem"
	s ObjKBSMstItem=##Class(User.DHCEQKBSMstItem).%OpenId(RowID)
	s KBSMstItmInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjKBSMstItem)
	d KBSMstItmInfo.%Set("SMIRowID",RowID)
	d KBSMstItmInfo.%Set("SMIFinanceTypeDR_FTDesc",##class(web.DHCEQCommon).GetTrakNameByID("financetype",KBSMstItmInfo.SMIFinanceTypeDR))
	d KBSMstItmInfo.%Set("SMITreeDR_TDesc",KBSMstItmInfo.SMITreeDR.TDesc)
	d KBSMstItmInfo.%Set("SMIStatCatDR_SCDesc",##class(web.DHCEQCommon).GetTrakNameByID("statcat",KBSMstItmInfo.SMIStatCatDR))
	d KBSMstItmInfo.%Set("SMICatDR_ECDesc",##class(web.DHCEQCommon).GetTrakNameByID("equipcat",KBSMstItmInfo.SMICatDR))
	d KBSMstItmInfo.%Set("SMIUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",KBSMstItmInfo.SMIUnitDR))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,KBSMstItmInfo)
ERRORGetOneKBSMstItem
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// Createor:CZF 2021-07-15 1967027
/// Description：参考设备项放大镜
/// Input：EquipTypeDR 设备类组id
///      StatCatDR 设备类型id
///      Name 参考设备项名称
///      EquipCatDR 设备分类id 
/// d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.KBSMasterItem","GetKBSMasterItem","3","","","")
Query GetKBSMasterItem(EquipTypeDR As %String, StatCatDR As %String = "", Name As %String = "", EquipCatDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,TRowID:%String,TCode:%String:代码,TFinanceTypeDR:%String,TFinanceType:%String:资产大类,TStatCatDR:%String,TStatCat:%String:设备类型,TCatDR:%String,TCatDesc:%String:设备分类,TCatCode:%String:分类代码,TTreeCatDR:%String,TTreeCat:%String:68分类,TTreeCode:%String:68分类代码,TUnitDR:%String,TUnit:%String:单位")
{
}

ClassMethod GetKBSMasterItemExecute(ByRef qHandle As %Binary, EquipTypeDR As %String, StatCatDR As %String = "", Name As %String = "", EquipCatDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i EquipTypeDR="" Quit $$$OK
	s FinanceTypeDR=$p(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR),"^",9)
	s TFinanceTypeDR=0
	f  s TFinanceTypeDR=$o(^DHCEQKB("DHCEQKBSMstItem",0,"FinanceTypeDR",TFinanceTypeDR))  quit:TFinanceTypeDR=""  d
	.q:(FinanceTypeDR'="")&&(FinanceTypeDR'=TFinanceTypeDR)
	.s TFinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",TFinanceTypeDR)),"^",2)
	.s rowid=0
	.f  s rowid=$o(^DHCEQKB("DHCEQKBSMstItem",0,"FinanceTypeDR",TFinanceTypeDR,rowid))  quit:rowid=""  d
	..d ResetGetKBSMasterItem
	..d BuildDataGetKBSMasterItem
	
	Quit $$$OK
BuildDataGetKBSMasterItem
	s TRowID = rowid
	s KBSMsterItemInfo=$g(^DHCEQKB("DHCEQKBSMstItem",rowid))
	q:$p(KBSMsterItemInfo,"^",8)="Y"
	s TName=$p(KBSMsterItemInfo,"^",1)
	s TCode=$p(KBSMsterItemInfo,"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	s TStatCatDR=$p(KBSMsterItemInfo,"^",4)
	q:(StatCatDR'="")&(StatCatDR'=TStatCatDR)
	s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	s TCatDR=$p(KBSMsterItemInfo,"^",5)
	q:(EquipCatDR'="")&(EquipCatDR'=TCatDR)
	i TCatDR'=""  d
	.s TCatDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",2) 
	.s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TCatDR)),"^",1)
	s TTreeCatDR=$p(KBSMsterItemInfo,"^",6)
	i TTreeCatDR'="" d
	.s TTreeCat=$p($g(^DHCEQCCode("DHCEQCTree",TTreeCatDR)),"^",3)
	.s TTreeCode=$p($g(^DHCEQCCode("DHCEQCTree",TTreeCatDR)),"^",2)
	s TUnitDR=$p(KBSMsterItemInfo,"^",7)
	s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TForceInspectFlag=$p(KBSMsterItemInfo,"^",9)	;强检标志
	s TMedicalFlag=$p(KBSMsterItemInfo,"^",10)		;医疗标志
	s TRaditionFlag=$p(KBSMsterItemInfo,"^",11)		;放射标志
	s TMesureFlagFlag=$p(KBSMsterItemInfo,"^",12)	;计量标志
	s TCycleNum=$p(KBSMsterItemInfo,"^",13)
	s TCycleUnitDR=$p(KBSMsterItemInfo,"^",14)
	s TCycleUnit=##class(web.DHCEQCommon).GetTrakNameByID("cycleunit",TCycleUnitDR)
	s TRemark=$p(KBSMsterItemInfo,"^",15)
	s TIsStandard=$p(KBSMsterItemInfo,"^",21)
	s TStandardDR=$p(KBSMsterItemInfo,"^",22)
	d OutputRowGetKBSMasterItem
	quit
OutputRowGetKBSMasterItem
	s Data=$lb(TName,TRowID,TCode,TFinanceTypeDR,TFinanceType,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TTreeCode,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetKBSMasterItem
	s (TRowID,KBSMsterItemInfo,TName,TCode,TStatCatDR,TStatCat,TCatDR,TCatDesc,TCatCode,TTreeCatDR,TTreeCat,TTreeCode,TUnitDR,TUnit)=""
	s (TForceInspectFlag,TMedicalFlag,TRaditionFlag,TMesureFlagFlag,TCycleNum,TCycleUnitDR,TCycleUnit,TRemark,TIsStandard)=""
	quit
}

ClassMethod GetKBSMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKBSMasterItemExecute ]
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

ClassMethod GetKBSMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKBSMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
