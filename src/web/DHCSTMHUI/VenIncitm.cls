Import sqluser

/// Descript: 供应商可供货列表维护
/// Creater: lihui
/// CreateDate:	20200226
Class web.DHCSTMHUI.VenIncitm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存供应商供应项目信息
/// Creater:	lihui
/// CreateDate:	20190430
/// Table: DHC_ItmVen
/// Input: 供应商id^库存项RowId串 
/// Output:		
/// Return：成功:"";否则:失败信息
/// 
/// w ##class(web.DHCSTMHUI.VenIncitm).Save("1","2767")
ClassMethod Save(Venid As %String, InciObj As %String) As %Library.String
{
	n (Venid,InciObj,%session)
	;s ^litmp("Saveinciven")=InciObj
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Venid="" d RtnObj.Err(-1,"","选取需要授权物资的供应商","",0) q RtnObj.Json()
	i InciObj="" d RtnObj.Err(-1,"","选取需要授权物资","",0) q RtnObj.Json()
	s PjObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PjObj.%FromJSON(InciObj)
	i sc'=0 d RtnObj.Err(-3,"","入参解析错误") q RtnObj.Json()
	s err=""
	while(RtnObj.success=0){
		s ItmObj=PjObj.%Pop()
		q:ItmObj=""
		s IncId=ItmObj.%Get("RowId")
		s ret=..Insert(Venid,IncId)
		i +ret<0 d
		.s incicode=$p(^INCI(IncId,1),"^",1)
		.i err="" d
		..s err=incicode_","_ret
		.e  d
		..s err=err_";"_incicode_","_ret
	}
	i err'="" d RtnObj.Err(-4,"",err)  q RtnObj.Json()
  	q RtnObj.Json()
}

/// Descript:	插入供应商供应项目信息
/// Creater:	lihui
/// CreateDate:	20190430
/// Table: dhc_itmven
/// Input: 供应商id^库存项RowId
/// Output:		
/// Return：rowid
/// w ##class(web.DHCSTMHUI.VenIncitm).Insert("656","6315","9","","","","","","","","","","","M","","","")
ClassMethod Insert(Vendor As %String, IncId As %String) As %Library.String
{
	n (Vendor,IncId,%session)
	q:Vendor="" ""
	q:IncId="" ""
	s Vendortmp="",Err=0
	s rowid=""
	&sql(SELECT DHCIV_Rowid INTO :rowid FROM DHC_ItmVen WHERE DHCIV_INCI_DR=:IncId AND DHCIV_APCVM_DR=:Vendor)
	i rowid'="" d
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmVen",rowid)
	.s enddate=""
	.&sql(UPDATE DHC_ItmVen SET DHCIV_EndDate=:enddate WHERE DHCIV_Rowid=:rowid)
	.i SQLCODE'=0  d
	..s Err=-1_"授权失败"
	.q:+Err'=0
	.d ##class(Log).SaveLog("DHC_ItmVen","User.DHCItmVen","供应商供货信息",rowid,Vendor,"U","",OldJsonStr)
	e  d
	.s startdate=+$h
	.&sql(Insert into DHC_ItmVen(DHCIV_APCVM_DR,DHCIV_INCI_DR,DHCIV_StartDate) values(:Vendor,:IncId,:startdate))
	.i SQLCODE'=0  d
	..s Err=-1_"授权失败"
	.q:+Err'=0
	.d ##class(Log).SaveLog("DHC_ItmVen","User.DHCItmVen","供应商供货信息",$SYSTEM.SQL.GetROWID(),Vendor,"A")
	q Err
}

/// Descript:	保存供应商供应项目信息
/// Creater:	lihui
/// CreateDate:	20190430
/// Table: DHC_ItmVen
/// Input: 供应商id^库存项RowId 
/// Output:		
/// Return：成功:"";否则:失败信息
/// 
/// w ##class(web.DHCSTMHUI.VenIncitm).AddInciVendor("2766",^litmp("AddInciVendor1"))
ClassMethod AddInciVendor(Incid As %String, VenObj As %String) As %Library.String
{
	n (Incid,VenObj,%session)
	;s ^litmp("AddInciVendor")=Incid
	;s ^litmp("AddInciVendor1")=VenObj
	s RtnObj=##class(RtnObj).%New()
	i Incid="" d RtnObj.Err(-1,"","选取需要授权供应商的物资","",0) q RtnObj.Json()
	i VenObj="" d RtnObj.Err(-2,"","选取需要授权的供应商","",0) q RtnObj.Json()
	s PjObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PjObj.%FromJSON(VenObj)
	i sc'=0 d RtnObj.Err(-3,"","入参解析失败") q RtnObj.Json()
	s err=""
	while(RtnObj.success=0){
		s ItmObj=PjObj.%Pop()
		q:ItmObj=""
		s Venid=ItmObj.%Get("RowId")
		s ret=..Insert(Venid,Incid)
		i +ret<0 d
		.s vendorname=$p(^APC("APCVM",Venid),"^",1)
		.i err="" d
		..s err=vendorname_","_ret
		.e  d
		..s err=err_";"_vendorname_","_ret
	}
	i err'="" d RtnObj.Err(-4,"",err) q RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	取消物资授权的供应商
/// Creater:	lihui
/// CreateDate:	20190505
/// Table: DHC_ItmVen
/// Input: 库存项RowId^供应商id
/// Output:		
/// Return：成功:"";否则:失败信息
/// 
/// w ##class(web.DHCSTMHUI.VenIncitm).StopInciVendor("1","2767")
ClassMethod StopInciVendor(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^litmp("StopInciVendor")=Params
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PjObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PjObj.%FromJSON(Params)
	i sc'=0 d RtnObj.Err(-1,"","入参解析失败") q RtnObj.Json()
	s err=""
	while(RtnObj.success=0){
		s ItmObj=PjObj.%Pop()
		q:ItmObj=""
		s Rowid=ItmObj.%Get("RowId")
		s ret=..Stop(Rowid)
		i +ret<0 d
		.i err="" d
		..s err=ret
		.e  d
		..s err=err_";"_ret
	}
  	i err'="" d RtnObj.Err(-3,"",err) q RtnObj.Json()
  	q RtnObj.Json()
}

/// Descript:	取消授权供应商列表
/// Creater:	lihui
/// CreateDate:	20190430
/// Table: dhc_itmven
/// Input: 供应商id^库存项RowId
/// Output:		
/// Return：rowid
/// w ##class(web.DHCSTMHUI.VenIncitm).Stop()
ClassMethod Stop(Rowid As %String) As %Library.String
{
	n (Rowid,%session)
	;s ^litmp("web.DHCSTMHUI.VenIncitm")=Rowid
	q:Rowid="" ""
	s Err=0
	s (IncId,Vendor)=""
	&sql(SELECT DHCIV_APCVM_DR,DHCIV_INCI_DR into:Vendor,:IncId FROM DHC_ItmVen WHERE DHCIV_Rowid=:Rowid)
	q:SQLCODE -1_"此物资未授权该供应商"
	s vendorname=$p(^APC("APCVM",Vendor),"^",1)
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmVen",Rowid)
	s enddate=+$h
	&sql(UPDATE DHC_ItmVen SET DHCIV_EndDate=:enddate WHERE DHCIV_Rowid=:Rowid)
	i SQLCODE'=0  d
	.s Err=-2
	q:Err'=0 Err_vendorname_"取消授权失败"
	d ##class(Log).SaveLog("DHC_ItmVen","User.DHCItmVen","供应商供货信息",Rowid,Vendor,"U","",OldJsonStr)
	q Err
}

/// Description: 查询所有启用的供应商
/// Creator:	lihui
/// CreateDate:	20190429
/// Table:		APC_Vendor
/// Input:		StrParam
/// Output:		
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.VenIncitm","GetAllVendor",^litmp("GetAllVendor"))
Query GetAllVendor(Params As %String) As Query(ROWSPEC = "Venid,Code,Name,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,Status") [ SqlProc ]
{
}

ClassMethod GetAllVendorExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pName=PJObj.%Get("VendDesc")
	s Status=PJObj.%Get("Status")
	s pVendorCat=PJObj.%Get("VendorCat")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Type=..sssCode()
	s StrSql="select APCVM_RowId,APCVM_Code Code,APCVM_Name Name,APCVM_Tel,APCVM_Category_DR,"
		_"APCVM_Category_DR->APCVC_Desc,APCVM_CtrlAcct_DR,APCVM_CrAvail,APCVM_LstPoDate,APCVM_Fax,"
		_"APCVM_President,APCVM_Status Status,APCVM_Type,APCVM_Category_DR"
		_" from APC_Vendor where 1=1"
	s:Status'="" StrSql=StrSql_" and APCVM_Status = '"_Status_"'"
	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		
		s Venid = result.Data("APCVM_RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",Venid,gHospId)
		continue:ShowDataFlag="N"
		s type=result.Data("APCVM_Type")
		CONTINUE:Type'=type
		s Code = result.Data("Code")
		s Name = result.Data("Name")
		s STV=$o(^DHCSTV(0,Venid,0))
		s STVAlias = $p(^DHCSTV(STV),"^",46)
		s pName = $$ALPHAUP^SSUTIL4(pName)
		continue:(pName'="")&&(($$ALPHAUP^SSUTIL4(Name)'[pName)
			&&($$ALPHAUP^SSUTIL4(Code)'[pName)
			&&($$ALPHAUP^SSUTIL4(STVAlias)'[pName))
		s CategoryId = result.Data("APCVM_Category_DR")
		continue:(pVendorCat'="")&&(pVendorCat'=CategoryId)
		s Tel = result.Data("APCVM_Tel")
		s CategoryId=result.Data("APCVM_Category_DR")
		s Category = result.Data("APCVC_Desc")
		s CtrlAcct = result.Data("APCVM_CtrlAcct_DR")
		s CrAvail = result.Data("APCVM_CrAvail")
		s LstPoDate = result.Data("APCVM_LstPoDate")
		s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
		s Fax = result.Data("APCVM_Fax")
		s President = result.Data("APCVM_President")
		s President=$p(President,"||",1)
		s Status = result.Data("Status")
		d OutPutRowAllVen
	}
	d result.Close()
	Quit $$$OK
OutPutRowAllVen
 s Data=$lb(Venid,Code,Name,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,Status)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	查找供应商授权供应项目信息
/// Creater:	lihui
/// CreateDate:	20200228
/// Table: DHC_ItmVen
/// Input: 供应商id
/// Output:		
/// Return：Rowid^库存项RowId^材料名称^配送商RowId^生产厂家RowId^开始日期^截止日期^中标前进价^协议进价^中标前售价^协议售价^质量层次^最高售价^本轮招标次数^类别^备注^是否中标标志^备案采购标志,
/// d ##class(web.DHCSTMHUI.VenIncitm).GetVenInci(1)
Query GetVenInci(Vendor As %String) As Query(ROWSPEC = "RowId,IncId,Incicode,Incidesc,Spec,Vendor,VendorDesc,Carrier,CarrierDesc,PhManf,PhManfDesc,StartDate,EndDate,BeforeRp:%Float,DealRp:%Float,BeforeSp:%Float,DealSp:%Float,QutyLevel,HighSp:%Float,Num:%Float,Sort,Remark,Win,RecPurMark") [ SqlProc ]
{
}

ClassMethod GetVenInciExecute(ByRef qHandle As %Binary, Vendor As %String) As %Status
{
	n (qHandle,Vendor)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	;s ^tmpli("GetVenInci")=Vendor
	q:Vendor="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s StrSql="SELECT DHCIV_Rowid as Rowid,DHCIV_INCI_DR,DHCIV_Carrier_DR,DHCIV_MANF_DR,DHCIV_StartDate,"
	s StrSql=StrSql_"DHCIV_EndDate,DHCIV_PrePurPrice,DHCIV_PurPrice,DHCIV_PreSP,DHCIV_SalePrice,"
	s StrSql=StrSql_"DHCIV_QualityLevel,DHCIV_SP_Max,DHCIV_Number,DHCIV_ItmType,DHCIV_Remark,"
	s StrSql=StrSql_"DHCIV_Marker,DHCIV_PurBack,DHCIV_APCVM_DR FROM DHC_ItmVen WHERE DHCIV_APCVM_DR="_Vendor_"order by DHCIV_Rowid DESC"
    d result.Prepare(StrSql)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("Rowid") 
		CONTINUE:+RowId=0
		s IncId=result.Data("DHCIV_INCI_DR")
		s Incicode=$p(^INCI(IncId,1),"^",1)
		s Incidesc=$p(^INCI(IncId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
		s TmpGrpType=$p(TmpGrpInfo,"^",3)
		continue:TmpGrpType'=..sssCode()
		s Carrier=result.Data("DHCIV_Carrier_DR")
		s CarrierDesc=""
		s:Carrier'="" CarrierDesc=$p(^DHCCARR(Carrier),"^",2)
		s PhManf=result.Data("DHCIV_MANF_DR")
		s PhManfDesc=""
		s:PhManf'="" PhManfDesc=$p(^PHMNF(PhManf),"^",2)
		s StartDate=result.Data("DHCIV_StartDate")
		s:+StartDate'=0 StartDate=..DL2H(StartDate)
		s EndDate=result.Data("DHCIV_EndDate")
		;continue:(EndDate'="")&&(EndDate<=+$h)  ;授权过期
		s:+EndDate'=0 EndDate=..DL2H(EndDate)
		s BeforeRp=result.Data("DHCIV_PrePurPrice")
		s DealRp=result.Data("DHCIV_PurPrice")
		s BeforeSp=result.Data("DHCIV_PreSP")
		s DealSp=result.Data("DHCIV_SalePrice")
		s QutyLevel=result.Data("DHCIV_QualityLevel")
		s HighSp=result.Data("DHCIV_SP_Max")
		s Num=result.Data("DHCIV_Number")  
		s Sort=result.Data("DHCIV_ItmType")  
		s Remark=result.Data("DHCIV_Remark")
		s Win=result.Data("DHCIV_Marker")               
		s RecPurMark=result.Data("DHCIV_PurBack")
		s Vendor=result.Data("DHCIV_APCVM_DR")
		s VendorDesc=""
		s:Vendor'="" VendorDesc=$p(^APC("APCVM",Vendor),"^",3)
		d OutPutRowVenInci 
	}
	d result.Close()
	Quit $$$OK
OutPutRowVenInci
 s Data=$lb(RowId,IncId,Incicode,Incidesc,Spec,Vendor,VendorDesc,Carrier,CarrierDesc,PhManf,PhManfDesc,StartDate,EndDate
			,BeforeRp,DealRp,BeforeSp,DealSp,QutyLevel,HighSp
			,Num,Sort,Remark,Win,RecPurMark)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	查找物资对应的授权供应商信息
/// Creater:	lihui
/// CreateDate:	20200304
/// Table: DHC_ItmVen
/// Input:开始行,一页显示记录数,供应商id
/// Output:		
/// Return：Rowid^库存项RowId^材料名称^配送商RowId^生产厂家RowId^开始日期^截止日期^中标前进价^协议进价^中标前售价^协议售价^质量层次^最高售价^本轮招标次数^类别^备注^是否中标标志^备案采购标志,
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.VenIncitm","GetInciApc",1)
Query GetInciApc(Inci As %String) As Query(ROWSPEC = "RowId,IncId,Incicode,Incidesc,Vendor,VendorDesc,Carrier,CarrierDesc,PhManf,PhManfDesc,StartDate,EndDate,BeforeRp:%Float,DealRp:%Float,BeforeSp:%Float,DealSp:%Float,QutyLevel,HighSp:%Float,Num:%Float,Sort,Remark,Win,RecPurMark") [ SqlProc ]
{
}

ClassMethod GetInciApcExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	;s ^tmpli("GetVenInci")=Inci
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s StrSql="SELECT DHCIV_Rowid as Rowid,DHCIV_INCI_DR,DHCIV_Carrier_DR,DHCIV_MANF_DR,DHCIV_StartDate,"
	s StrSql=StrSql_"DHCIV_EndDate,DHCIV_PrePurPrice,DHCIV_PurPrice,DHCIV_PreSP,DHCIV_SalePrice,"
	s StrSql=StrSql_"DHCIV_QualityLevel,DHCIV_SP_Max,DHCIV_Number,DHCIV_ItmType,DHCIV_Remark,"
	s StrSql=StrSql_"DHCIV_Marker,DHCIV_PurBack,DHCIV_APCVM_DR FROM DHC_ItmVen WHERE DHCIV_INCI_DR="_Inci_"order by DHCIV_Rowid DESC"
	d result.Prepare(StrSql)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("Rowid") 
		CONTINUE:+RowId'>0
		s IncId=result.Data("DHCIV_INCI_DR")
		s Incicode=$p(^INCI(IncId,1),"^",1)
		s Incidesc=$p(^INCI(IncId,1),"^",2)
		s TmpGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
		s TmpGrpType=$p(TmpGrpInfo,"^",3)
		continue:TmpGrpType'=..sssCode()
		s Carrier=result.Data("DHCIV_Carrier_DR")
		s CarrierDesc=""
		s:Carrier'="" CarrierDesc=$p(^DHCCARR(Carrier),"^",2)
		s PhManf=result.Data("DHCIV_MANF_DR")
		s PhManfDesc=""
		s:PhManf'="" PhManfDesc=$p(^PHMNF(PhManf),"^",2)
		s StartDate=result.Data("DHCIV_StartDate")
		s:+StartDate'=0 StartDate=..DL2H(StartDate)
		s EndDate=result.Data("DHCIV_EndDate")
		;continue:(EndDate'="")&&(EndDate<=+$h)  ;授权过期
		s:+EndDate'=0 EndDate=..DL2H(EndDate)
		s BeforeRp=result.Data("DHCIV_PrePurPrice")
		s DealRp=result.Data("DHCIV_PurPrice")
		s BeforeSp=result.Data("DHCIV_PreSP")
		s DealSp=result.Data("DHCIV_SalePrice")
		s QutyLevel=result.Data("DHCIV_QualityLevel")
		s HighSp=result.Data("DHCIV_SP_Max")
		s Num=result.Data("DHCIV_Number")  
		s Sort=result.Data("DHCIV_ItmType")  
		s Remark=result.Data("DHCIV_Remark")
		s Win=result.Data("DHCIV_Marker")               
		s RecPurMark=result.Data("DHCIV_PurBack")
		s Vendor=result.Data("DHCIV_APCVM_DR")
		s VendorDesc=""
		s:Vendor'="" VendorDesc=$p(^APC("APCVM",Vendor),"^",3)
		d OutPutRowInciVen 
	}
	d result.Close()
	Quit $$$OK
OutPutRowInciVen
 s Data=$lb(RowId,IncId,Incicode,Incidesc,Vendor,VendorDesc,Carrier,CarrierDesc,PhManf,PhManfDesc,StartDate,EndDate
			,BeforeRp,DealRp,BeforeSp,DealSp,QutyLevel,HighSp
			,Num,Sort,Remark,Win,RecPurMark)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description: 查询某个物资未授权供应商
/// Creator:	lihui
/// CreateDate:	20190429
/// Table:		APC_Vendor
/// Input:		start,limit,sort,dir,StrParam
/// Output:		
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.VenIncitm","GetUnInciApc",2766,^tmpli("GetUnInciApc"))
Query GetUnInciApc(Inci As %String, Params As %String) As Query(ROWSPEC = "RowId,Code,Name,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,Status") [ SqlProc ]
{
}

ClassMethod GetUnInciApcExecute(ByRef qHandle As %Binary, Inci As %String, Params As %String) As %Status
{
	n (qHandle,Inci,Params)
	;s ^litmp("GetUnInciApc1")=Inci
	;s ^tmpli("GetUnInciApc")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s PjObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s sc=PjObj.%FromJSON(Params)
	i sc'=0 q $$$OK
	s Type=..sssCode()
	s VendCode=PjObj.%Get("VendCode")
	s VendDesc=PjObj.%Get("VendDesc")
	s VendorCat=PjObj.%Get("VendorCat")
	s Status=PjObj.%Get("Status")
	s gHospId=PjObj.%Get("gHospId")
	s pHospId=PjObj.%Get("BDPHospital")
	s gHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s StrSql="select APCVM_RowId,APCVM_Code Code,APCVM_Name Name,APCVM_Tel,APCVM_Category_DR,"
		_"APCVM_Category_DR->APCVC_Desc,APCVM_CtrlAcct_DR,APCVM_CrAvail,APCVM_LstPoDate,APCVM_Fax,"
		_"APCVM_President,APCVM_Status Status,APCVM_Type,APCVM_Category_DR"
		_" from APC_Vendor where 1=1"
	s:Status'="" StrSql=StrSql_" and APCVM_Status = '"_Status_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s RowId = result.Data("APCVM_RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",RowId,gHospId)
		continue:ShowDataFlag="N"
		s type=result.Data("APCVM_Type")
		CONTINUE:Type'=type
		s EndDate=""
		&sql(SELECT DHCIV_EndDate into:EndDate FROM DHC_ItmVen WHERE DHCIV_APCVM_DR=:RowId AND DHCIV_INCI_DR=:Inci)
		continue:((SQLCODE=0)&&(EndDate'="")&&(EndDate>+$h)) ;授权过期
		s Code = result.Data("Code")
		continue:(VendCode'="")&&(Code'[VendCode)
		s Name = result.Data("Name")
		continue:(VendDesc'="")&&(Name'[VendDesc)
		s CategoryId = result.Data("APCVM_Category_DR")
		continue:(VendorCat'="")&&(VendorCat'=CategoryId)
		s Tel = result.Data("APCVM_Tel")
		s CategoryId=result.Data("APCVM_Category_DR")
		s Category = result.Data("APCVC_Desc")
		s CtrlAcct = result.Data("APCVM_CtrlAcct_DR")
		s CrAvail = result.Data("APCVM_CrAvail")
		s LstPoDate = result.Data("APCVM_LstPoDate")
		s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
		s Fax = result.Data("APCVM_Fax")
		s President = result.Data("APCVM_President")
		s President=$p(President,"||",1)
		s Status = result.Data("Status")
		d OutPutRowUnVenInci
	}
	d result.Close()
	Quit $$$OK
OutPutRowUnVenInci
 s Data=$lb(RowId,Code,Name,Tel,Category,CategoryId,CtrlAcct,CrAvail,LstPoDate,Fax,President,Status)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
