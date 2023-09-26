Class web.DHCEQ.EM.BUSEconCalc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0287 20211216
/// Add By ZY 
/// 描述:经济测量表Query
/// 入参:SourceType As %String = "", SourceID As %String = "", CalcFlag As %String = ""
/// 访问表:DHC_EQEconCalc
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSEconCalc","GetEconCalc",2,11,"Y")
Query GetEconCalc(SourceType As %String = "", SourceID As %String = "", CalcFlag As %String = "Y", PurchaseTypeCode As %String = "") As %Query(ROWSPEC = "ECRowID:%String,ECSourceType:%String,ECSourceID:%String,ECYear:%String,ECServiceIncome:%String,ECMaterialIncome:%String,ECMaintFee:%String,ECFeeOfEmployee:%String,ECMaterialFee:%String,ECDepreFee:%String,ECBuildingFee:%String,ECEnergyFee:%String,ECEffect:%String,ECWorkLoadNum:%String,ECPositiveRate:%String,ECHold1:%String,ECHold2:%String,ECHold3:%String,ECHold4:%String,ECHold5:%String,ECEquipDR:%String,TEquip:%String,TModel:%String,TLeaveFactoryNo:%String,TUseLoc:%String,TOriginalFee:%String,TLimitYearsNum:%String,TStartDate:%String,TTransAssetDate:%String,TNo:%String")
{
}

ClassMethod GetEconCalcExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", CalcFlag As %String = "Y", PurchaseTypeCode As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s BRDDepreFee=""
	s index=1
	i $Data(^DHCEQEconCalc(0,"Source",SourceType,SourceID,CalcFlag))<1
	{
		d ResetVariablesGetEconCalc
		s ECSourceType=SourceType
		s ECSourceID=SourceID
		d OutputRowGetEconCalc
	}
	else
	{
		if SourceType=1
		{
			Set BRDRowID=$Order(^DHCEQBuyRequestDetail(0,"BuyRequestList",SourceID,""))
			i BRDRowID'="" s BRDDepreFee=$p($g(^DHCEQBuyRequestDetail(BRDRowID)),"^",11)
		}
		
		s rowid=0
		f  s rowid=$o(^DHCEQEconCalc(0,"Source",SourceType,SourceID,CalcFlag,rowid))  quit:rowid=""  d
		.d ResetVariablesGetEconCalc
		.s Datalist=$g(^DHCEQEconCalc(rowid))
		.s ECRowID = rowid
		.s ECSourceType=$p(Datalist,"^",1)
		.s ECSourceID=$p(Datalist,"^",2)
		.s ECEquipDR=$p(Datalist,"^",3)
		.q:(PurchaseTypeCode="01")&&(ECEquipDR'="")
		.q:(PurchaseTypeCode="02")&&(ECEquipDR="")
		.i ECEquipDR'="" d
	    ..s EquipData=$g(^DHCEQEquip(ECEquipDR))
	    ..s TEquip=$p(EquipData,"^",1)
		..s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",$p(EquipData,"^",3))
		..s TLeaveFactoryNo = $p(EquipData,"^",10)
		..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(EquipData,"^",19))
		..s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"1") 
		..s TLimitYearsNum = $p(EquipData,"^",31)
		..s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
		..s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
		..s TNo = $p(EquipData,"^",71)
		.s ECYear=$p(Datalist,"^",5)
		.s ECServiceIncome=$p(Datalist,"^",6)
		.s ECMaterialIncome=$p(Datalist,"^",7)
		.s ECMaintFee=$p(Datalist,"^",8)
		.s ECFeeOfEmployee=$p(Datalist,"^",9)
		.s ECMaterialFee=$p(Datalist,"^",10) 
		.//modified by ZY0223 2020-04-17 取值错误
		.s ECDepreFee=$p(Datalist,"^",11) 
		.i ECDepreFee="" s ECDepreFee=BRDDepreFee	
		.s ECBuildingFee=$p(Datalist,"^",12)
		.s ECEnergyFee=$p(Datalist,"^",13)
		.s ECEffect=$p(Datalist,"^",14)
		.s ECWorkLoadNum=$p(Datalist,"^",15)
		.s ECPositiveRate=$p(Datalist,"^",16)
		.s ECHold1=$p(Datalist,"^",17)
		.s ECHold2=$p(Datalist,"^",18)
		.s ECHold3=$p(Datalist,"^",19)
		.s ECHold4=$p(Datalist,"^",20)
		.s ECHold5=$p(Datalist,"^",21)
		.d OutputRowGetEconCalc
	}
	Quit $$$OK
	
OutputRowGetEconCalc
	s Data=$lb(ECRowID,ECSourceType,ECSourceID,ECYear,ECServiceIncome,ECMaterialIncome,ECMaintFee,ECFeeOfEmployee,ECMaterialFee,ECDepreFee,ECBuildingFee,ECEnergyFee,ECEffect,ECWorkLoadNum,ECPositiveRate,ECHold1,ECHold2,ECHold3,ECHold4,ECHold5,ECEquipDR,TEquip,TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEconCalc
	s (Datalist,EquipData,ECRowID,ECSourceType,ECSourceID,ECYear,ECServiceIncome,ECMaterialIncome,ECMaintFee,ECFeeOfEmployee,ECMaterialFee,ECDepreFee,ECBuildingFee,ECEnergyFee,ECEffect,ECWorkLoadNum,ECPositiveRate,ECHold1,ECHold2,ECHold3,ECHold4,ECHold5,TEquip,TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo)=""
	quit
}

ClassMethod GetEconCalcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetEconCalcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By ZY 
/// 描述:经济测量表保存
ClassMethod SaveData(val, OperateType As %String = "0")
{
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-09-11 分割标志替换
    Set $ZT="ERROR"
	TSTART
    s length=$l(val,SplitRowCode)
	f k=1:1:length  d
	.s OneList=$p(val,SplitRowCode,k)
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSEconCalc).SaveDataList(OneList,OperateType)
	.q:SQLCODE'=0
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,length)
    //q SQLCODE_"^"_length
ERROR 
	TRollBack	
	Set ErrorMsg=$ZE	  
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ErrorMsg)
}

/// Add By ZY 
/// 描述:经济测量表保存
/// input: val:保存数据json格式串 OperateType: 0 保存及更新,1 删除
/// output: 失败返回SQLCODE 成功返回SQLCODE及RowID
ClassMethod SaveDataList(val As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,RowID
	Set $ZT="SaveDataERROR"
	TSTART
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEconCalc",JsonData,.PLIST)
	s RowID=JsonData.ECRowID
	If (+OperateType=1)
	{
		i RowID="" Quit "-1"
	 	&SQL(delete from sqluser.DHC_EQEconCalc where EC_RowID=:RowID)
 	}
 	elseIf (+OperateType=0) //新增,更新
 	{
		if RowID'=""
		{
		    &SQL(Update SQLUSER.DHC_EQEconCalc Values :PLIST() where EC_RowID = :RowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQEconCalc Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	TCOMMIT
	Quit SQLCODE
SaveDataERROR 
	TRollBack	
	Set ErrorMsg=$ZE	  
	Quit SQLCODE
}

/// Add By ZY0215 2020-04-02
/// 描述:经济测量记录获取
/// w ##Class(web.DHCEQ.EM.BUSEconCalc).GetOneEconCalc(1)
ClassMethod GetOneEconCalc(ECRowID As %Library.String = "")
{
	s $ZT="ERRORGetOneEconCalc"
	s ObjEconCalc=##Class(User.DHCEQEconCalc).%OpenId(ECRowID)
	s EconCalc=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjEconCalc)
	d EconCalc.%Set("ECRowID",ECRowID)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,EconCalc)
ERRORGetOneEconCalc
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// modified by ZY20230105 bug:3187233
/// modified by ZY0222 2020-04-16
/// w ##class(web.DHCEQ.EM.BUSEconCalc).GetListNum(1,11,"Y")
ClassMethod GetListNum(SourceType, SourceID, CalcFlag)
{
    new count,firstID,objInfo,Total,ECWorkLoadNumAvg
    s (count,Total,ECWorkLoadNumAvg,Profit)=0
    s firstID=""
    i $Data(^DHCEQEconCalc(0,"Source",SourceType,SourceID,CalcFlag))
    {
        s rowid=0
        For  Set rowid=$Order(^DHCEQEconCalc(0,"Source",SourceType,SourceID,CalcFlag,rowid))  Quit:rowid=""  Do
        .s Datalist=$g(^DHCEQEconCalc(rowid))
        .s ECServiceIncome=$p(Datalist,"^",6)
        .s ECMaterialIncome=$p(Datalist,"^",7)
        .s ECMaintFee=$p(Datalist,"^",8)
        .s ECFeeOfEmployee=$p(Datalist,"^",9)
        .s ECMaterialFee=$p(Datalist,"^",10) 
        .s ECDepreFee=$p(Datalist,"^",11)  
        .s ECBuildingFee=$p(Datalist,"^",12)
        .s ECEnergyFee=$p(Datalist,"^",13)
        .s ECEffect=$p(Datalist,"^",14)
        .s ECWorkLoadNum=$p(Datalist,"^",15)
        .s Profit=Profit+ECWorkLoadNum*ECServiceIncome+ECMaterialIncome-ECMaintFee-ECFeeOfEmployee-ECMaterialFee-ECDepreFee-ECBuildingFee-ECEnergyFee-ECEffect
        .s Total=Total+$p(Datalist,"^",15)
        .s count=count+1
        .i count=1 s firstID=rowid
    }
    
    s objInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
    d objInfo.%Set("count",count)
    d objInfo.%Set("firstID",firstID)
    i count>0 s ECWorkLoadNumAvg=Total/count
    d objInfo.%Set("ECWorkLoadNumAvg",ECWorkLoadNumAvg)
    d objInfo.%Set("Profit",Profit)
    
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
}

}
