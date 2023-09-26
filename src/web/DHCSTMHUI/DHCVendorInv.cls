Import sqluser

Class web.DHCSTMHUI.DHCVendorInv Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTVendorINVM";

/// Descript:	保存发票信息
/// 对象类型数据
ClassMethod jsSaveInvInfo(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveInvInfo(Params)
	q RtnObj.Json()
}

/// Descript:   保存发票信息
/// Creater:    lxt
/// CreateDate: 2019-10-10
/// Table:		DHC_InvInfo
/// Input:		发票信息
ClassMethod SaveInvInfo(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s RowId=PJObj.%Get("RowId")
	s Vendor=PJObj.%Get("Vendor")
	s InvCode=PJObj.%Get("InvCode")
	s InvNo=PJObj.%Get("InvNo")
	s InvAmt=PJObj.%Get("InvAmt")
	s InvDate=PJObj.%Get("InvDate")
	s CreateUser=PJObj.%Get("gUserId")
	s IngrLoc=PJObj.%Get("IngrLoc")
	s CompFlag=PJObj.%Get("CompFlag")
	s FilledFlag=PJObj.%Get("FilledFlag")
	
	i IngrLoc="" d RtnObj.Err(-2,"","科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i Vendor="" d RtnObj.Err(-2,"","供应商不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	//i InvCode="" d RtnObj.Err(-2,"","发票代码不能为空!","",0)
	//q:RtnObj.success'=0 RtnObj
	//i InvNo="" d RtnObj.Err(-2,"","发票号不能为空!","",0)
	//q:RtnObj.success'=0 RtnObj
	//i InvAmt="" d RtnObj.Err(-2,"","发票金额不能为空!","",0)
	//q:RtnObj.success'=0 RtnObj
	s InvDate=..DH2L(InvDate)
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	
	s tmpRowId=""
	&sql(select %ID into :tmpRowId from DHC_VendorInv where nvl(INV_InvCode,'')=nvl(:InvCode,'') and INV_InvNo=:InvNo and INV_RowId<>:RowId)
	q:tmpRowId'="" RtnObj.Err(-2,"",InvNo_"此发票信息已存在","",0)

	i RowId="" d
	.&sql(Insert into DHC_VendorInv(INV_InvCode,INV_InvNo,INV_APCVM_DR,INV_InvRpAmt,INV_InvDate,INV_CreateUser,INV_CreateDate,INV_CreateTime,INV_CTLOC_DR,INV_UserCompleted,INV_Filled)
		values(:InvCode,:InvNo,:Vendor,:InvAmt,:InvDate,:CreateUser,:CreateDate,:CreateTime,:IngrLoc,:CompFlag,:FilledFlag))
	.i SQLCODE'=0 d RtnObj.Err(-3,"",InvNo_"保存失败!"_SQLCODE)
	.q:RtnObj.success'=0
	.s RowId=$p(%ROWID,$c(1))
	e  d
	.s FilledFlag=$p(^DHCVendorInv(RowId),"^",12)
	.//i FilledFlag="Y" d RtnObj.Err(-2,"","已审核不允许修改！")
	.//q:RtnObj.success'=0
	.&sql(update DHC_VendorInv set INV_InvCode=:InvCode,INV_InvNo=:InvNo,INV_APCVM_DR=:Vendor,INV_InvRpAmt=:InvAmt,
		INV_InvDate=:InvDate,INV_CreateUser=:CreateUser,INV_CreateDate=:CreateDate,INV_CreateTime=:CreateTime,
		INV_CTLOC_DR=:IngrLoc 
		where INV_RowId=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-4,RowId,InvNo_"保存失败!"_SQLCODE)
	.q:RtnObj.success'=0
	i RtnObj.success'=0 q RtnObj
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	查询发票信息
/// Creator: 	lxt
/// CreatDate: 	2019-10-10
/// Table: 		DHC_InvInfo
/// Input: 		Params对象
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCVendorInv","GetInvInfo",^templxt("123"))
Query GetInvInfo(Params As %String, PInvId As %String) As Query(ROWSPEC = "RowId,InvCode,InvNo,VendorId,VendorDesc,InvAmt:%Float,InvDate,CreateUserId,CreateUserName,CreateDate,CreateTime,CompFlag,RpAmt:%Float,LocId,LocDesc,FilledFlag") [ SqlProc ]
{
}

ClassMethod GetInvInfoExecute(ByRef qHandle As %Binary, Params As %String, PInvId As %String) As %Status
{
	n (qHandle,Params,PInvId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pVendor=PJObj.%Get("Vendor")
	s pInvCode=PJObj.%Get("InvCode")
	s pInvNo=PJObj.%Get("InvNo")
	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pCompFlag=PJObj.%Get("CompFlag")
	s pFilledFlag=PJObj.%Get("FilledFlag")
	s pIngrLoc=PJObj.%Get("IngrLoc")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	
	s SqlStr="SELECT INV_RowId, INV_InvCode, INV_InvNo, INV_APCVM_DR,INV_CTLOC_DR,INV_CTLOC_DR->CTLOC_Desc as LocDesc,"
		_"INV_InvRpAmt, INV_InvDate, INV_CreateUser, INV_CreateDate, INV_CreateTime,INV_RpAmt,"
		_"INV_UserCompleted,INV_Filled "
		_" FROM DHC_VendorInv"
		_" WHERE 1=1"
	i pVendor'="" d
	.s SqlStr=SqlStr_" AND INV_APCVM_DR ="_pVendor
	i pIngrLoc'="" d
	.s SqlStr=SqlStr_" AND INV_CTLOC_DR ="_pIngrLoc
	i pInvCode'="" d
	.s SqlStr=SqlStr_" AND INV_InvCode LIKE '%"_pInvCode_"%'"
	i pInvNo'="" d
	.s SqlStr=SqlStr_" AND INV_InvNo LIKE '%"_pInvNo_"%'"
	i ((pStartDate'="")&&(pEndDate'="")) d
	.s SqlStr=SqlStr_" AND INV_CreateDate between '"_pStartDate_"' and '"_pEndDate_"'"
	i PInvId'="" d
	.s SqlStr=SqlStr_" AND INV_RowId ="_PInvId
	s SqlStr=SqlStr_" order by INV_CreateDate Desc,INV_CreateTime desc"
	
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("INV_RowId")
		s InvCode = result.Data("INV_InvCode")
		s InvNo = result.Data("INV_InvNo")
		s VendorId = result.Data("INV_APCVM_DR")
		s InvAmt = result.Data("INV_InvRpAmt")
		s InvDate = result.Data("INV_InvDate")
		s CreateUserId = result.Data("INV_CreateUser")
		s CreateDate = result.Data("INV_CreateDate")
		s CreateTime = result.Data("INV_CreateTime")
		s CompFlag = result.Data("INV_UserCompleted")
		s:CompFlag="" CompFlag="N"
		continue:(pCompFlag'="")&&(pCompFlag'=CompFlag)
		s FilledFlag = result.Data("INV_Filled")
		s:FilledFlag="" FilledFlag="N"
		continue:(pFilledFlag'="")&&(pFilledFlag'=FilledFlag)
		s RpAmt = result.Data("INV_RpAmt")
		s LocId = result.Data("INV_CTLOC_DR")
		s LocDesc = result.Data("LocDesc")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s (VendorDesc,CreateUserName)=""
		s:VendorId'="" VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
		s:CreateUserId'="" CreateUserName=$p(^SSU("SSUSR",CreateUserId),"^",2)
		d OutPutRowInv
	}
	d result.Close()
	Quit $$$OK
OutPutRowInv
	s Data=$lb(RowId,InvCode,InvNo,VendorId,VendorDesc,InvAmt,InvDate,CreateUserId,CreateUserName,CreateDate,CreateTime,CompFlag,RpAmt,LocId,LocDesc,FilledFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询发票明细
/// Creator:	lxt
/// CreatDate:	2019-10-10
/// Table:		DHC_InvInfo
/// Input:		发票RowId
ClassMethod SelectInvInfo(RowId As %String) As %Library.String
{
	n (RowId)
	q:RowId="" ""
	
	s (VendorDesc,LocDesc)=""
	s InvCode=$p(^DHCVendorInv(RowId),"^",16)
	s InvNo=$p(^DHCVendorInv(RowId),"^",10)
	s VendorId=$p(^DHCVendorInv(RowId),"^",2)
	s:VendorId'="" VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	s Vendor=..sssComboStr(VendorId,VendorDesc)
	s LocId=$p(^DHCVendorInv(RowId),"^",7)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s IngrLoc=..sssComboStr(LocId,LocDesc)
	s InvAmt=$p(^DHCVendorInv(RowId),"^",13)
	s InvDate=$p(^DHCVendorInv(RowId),"^",15)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	s RpAmt=$p(^DHCVendorInv(RowId),"^",8)
	s Data=RowId_"^"_InvCode_"^"_InvNo_"^"_Vendor_"^"_InvAmt_"^"_InvDate_"^"_IngrLoc_"^"_RpAmt
	s Title="RowId^InvCode^InvNo^Vendor^InvAmt^InvDate^IngrLoc^RpAmt"
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Result
}

/// Descript:	判断某入库退货单明细是否全部被组合
/// Creater:	tsr
/// CreateDate: 2018-07-24
/// Input:		入库退货单id
/// Return:		1:全部组合;0:存在未组合项目
ClassMethod CheckIng(IngId As %String, Type As %String) As %Library.String
{
	n (IngId,Type)
	q:IngId="" 1
	s Flag=1
	s Chl=0
	i Type="G" d
	.f  s Chl=$o(^DHCINGR(IngId,"GRI",Chl)) q:(Chl="")!(Flag=0)  d
	..s IngItmId=IngId_"||"_Chl
	..s Inv=""
	..s InvNo=$p(^DHCINGR(IngId,"GRI",Chl),"^",27)
	..s Inv=$o(^DHCVendorInv(0,"TypeItm","G",IngItmId,0))
	..i (Inv="")&(InvNo="") d
	...s Flag=0
	e  i Type="R" d
	.f  s Chl=$o(^INGRT(IngId,"DHCGRR",Chl)) q:(Chl="")!(Flag=0)  d
	..s IngItmId=IngId_"||"_Chl
	..s Inv=""
	..s InvNo=$p(^INGRT(IngId,"DHCGRR",Chl),"^",12)
	..s Inv=$o(^DHCVendorInv(0,"TypeItm","R",IngItmId,0))
	..i (Inv="")&(InvNo="") d
	...s Flag=0
	q Flag
}

/// Descript:	判断入库退货单明细是否被组合
/// Creater:	tsr
/// CreateDate: 2018-07-24
/// Input:		入库退货单子表id
/// Return:		1:组合;0:未组合
ClassMethod CheckIngDetail(IngiId As %String, Type As %String) As %Library.String
{
	n (IngiId,Type)
	q:IngiId="" 1
	s Flag=1
	s Chl=0
	i Type="G" d
	.s IngId=+IngiId
	.s Chl=$p(IngiId,"||",2)
	.s Inv=""
	.s InvNo=$p(^DHCINGR(IngId,"GRI",Chl),"^",27)
	.s Inv=$o(^DHCVendorInv(0,"TypeItm","G",IngiId,0))
	.i (Inv="")&(InvNo="") d
	..s Flag=0
	e  i Type="R" d
	.s IngId=+IngiId
	.s Chl=$p(IngiId,"||",2)
	.s Inv=""
	.s InvNo=$p(^INGRT(IngId,"DHCGRR",Chl),"^",12)
	.s Inv=$o(^DHCVendorInv(0,"TypeItm","R",IngiId,0))
	.i (Inv="")&(InvNo="") d
	..s Flag=0
	q Flag
}

/// Descript:	待组合入库退货单查询
/// Creator: 	lxt
/// CreatDate: 	2018-07-24
/// Table: 		DHC_INGdRec,DHC_INGDRET
/// Input: 		科室Id,Params对象
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCVendorInv","GetIngdRec",^templxt("234"))
Query GetIngdRec(Params As %String) As Query(ROWSPEC = "RowId,GRNo,Vendor,VendorDesc,RpAmt:%Float,SpAmt:%Float,Type") [ SqlProc ]
{
}

ClassMethod GetIngdRecExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s LocId=PJObj.%Get("LocId")
	s pVendor=PJObj.%Get("Vendor")
	s pScg=PJObj.%Get("Scg")
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	q:LocId="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s HospId=..sssHospId(LocId)
	s:HospId="" HospId=gHospId
	s StkGrpType=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),LocId,pScg,HospId)
	
	//检索入库信息
	s SqlStr = "select INGR_RowId as RowId,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as VendorDesc,"_
		"INGR_Completed,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType StkType "_
		"from DHC_INGdRec where (INGR_CreateDate between "_StartDate_" and "_EndDate_") and INGR_Loc_Dr="_LocId
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("RowId")
		s GRNo = result.Data("INGR_No")
		s Vendor = result.Data("INGR_APCVM_DR")
		s VendorDesc = result.Data("VendorDesc")
		CONTINUE:(pVendor'="")&(Vendor'=pVendor)
		s Complete = result.Data("INGR_Completed")
		CONTINUE:Complete'="Y"
		s StkGrpId = result.Data("INGR_SCG_DR")
		CONTINUE:(StkGrpId'="")&&(StkGrpType'="")&&(("^"_StkGrpType_"^")'[("^"_StkGrpId_"^"))
		s Audit = result.Data("INGR_AuditFlag")
		CONTINUE:Audit'="Y"
		s StkType=result.Data("StkType")
		CONTINUE:StkType'=..sssCode()
		s Type="G"
		CONTINUE:..CheckIng(RowId,Type)=1	;该入库单明细已经全部组合
		//总金额
		&sql(select sum(initm_realtotal),sum(initm_SpAmt)
		into :RpAmt,:SpAmt from dhc_ingdrecitm where ingri_ingr_parref=:RowId)
		d OutPutGRRow
	}
	d result.Close()

	//检索退货信息
	s SqlStr = "select INGRT_Rowid as RowId,INGRT_NO,INGRT_APCVM_DR,INGRT_APCVM_DR->APCVM_Name as VendorDesc,"_
		"INGRT_Completed,INGRT_SCG_DR,INGRT_AuditFlag,INGRT_StkType StkType "_
		"from DHC_INGDRET where (INGRT_Date between "_StartDate_" and "_EndDate_") and INGRT_CTLOC_DR="_LocId
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (result.Next())
	{
		s RowId = result.Data("RowId")
		s GRNo = result.Data("INGRT_NO")
		s Vendor = result.Data("INGRT_APCVM_DR")
		s VendorDesc = result.Data("VendorDesc")
		CONTINUE:(pVendor'="")&(Vendor'=pVendor)
		s Complete = result.Data("INGRT_Completed")
		CONTINUE:Complete'="Y"
		s StkGrpId = result.Data("INGRT_SCG_DR")
		CONTINUE:(StkGrpId'="")&&(StkGrpType'="")&&(("^"_StkGrpType_"^")'[("^"_StkGrpId_"^"))
		s Audit = result.Data("INGRT_AuditFlag")
		CONTINUE:Audit'="Y"
		s StkType = result.Data("StkType")
		CONTINUE:StkType'=..sssCode()
		s Type="R"
		CONTINUE:..CheckIng(RowId,Type)=1	;该退货单明细已经全部组合
		//总金额
		&sql(select sum(INGRTI_RETAMOUNT),sum(INGRTI_SpAmt)
		into :RpAmt,:SpAmt from DHC_INGRTITM where INGRTI_INGRT_PARREF=:RowId)
		s RpAmt=-RpAmt
		s SpAmt=-SpAmt
		d OutPutGRRow
	}
	d result.Close()
	Quit $$$OK
OutPutGRRow
	s Data=$lb(RowId,GRNo,Vendor,VendorDesc,RpAmt,SpAmt,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	待组合入库退货单明细查询
/// Creator: 	tsr
/// CreatDate: 	2018-08-03
/// Table: 		DHC_INGdRec,DHC_INGDRET
/// Input: 		科室Id,Params对象
Query GetIngdRecItm(Params As %String) As Query(ROWSPEC = "RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvAmt:%Float,InvNo,InvDate,Manf,SxNo,Type") [ SqlProc ]
{
}

ClassMethod GetIngdRecItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		i Type="G"
		{
			s SqlStr = "SELECT INGRI_Rowid as RowId, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate, INGRI_RecQty,"
				_"initm_INCI_DR, initm_INCI_DR->INCI_Code as IncCode, initm_INCI_DR->INCI_Desc as IncDesc,"
				_"initm_invmoney, initm_invno, initm_phmnf_dr, initm_phmnf_dr->PHMNF_Name as Manf,"
				_"initm_realprice, initm_realtotal, initm_saleprice, initm_SpAmt, initm_invdate, initm_sxno "
				_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_RowId
			s result=##class(%ResultSet).%New()
			s result=##class(%Library.ResultSet).%New()
			d result.RuntimeModeSet(0)
			d result.Prepare(SqlStr)
			s sc=result.Execute()
			i $$$ISERR(sc) d RtnObj.Err(-1,RowId,"查询失败")
			q:RtnObj.success'=0
			while (result.Next())
			{
				s RowId = result.Data("RowId")
				CONTINUE:..CheckIngDetail(RowId,Type)=1		;该入库单明细已经组合
				s IncId = result.Data("initm_INCI_DR")
				s Code = result.Data("IncCode")
				s Description = result.Data("IncDesc")
				s BatchNo = result.Data("INGRI_BatchNo")
				s UomId = result.Data("INGRI_CTUOM_DR")
				s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
				s ExpDate=result.Data("INGRI_ExpDate")
				s:ExpDate'="" ExpDate=..DL2H(ExpDate)
				s Qty = result.Data("INGRI_RecQty")
				s Rp = result.Data("initm_realprice")
				s RpAmt = result.Data("initm_realtotal")
				s Sp = result.Data("initm_saleprice")
				s SpAmt = result.Data("initm_SpAmt")
				s InvAmt = result.Data("initm_invmoney")
				s InvNo = result.Data("initm_invno")
				s InvDate = result.Data("initm_invdate")
				s:InvDate'="" InvDate=..DL2H(InvDate)
				s SxNo = result.Data("initm_sxno")
				s ManfId = result.Data("initm_phmnf_dr")
				s Manf = result.Data("Manf")
				s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
				d OutPutRowDetail
			}
			d result.Close()
		}
		i Type="R"
		{
			s SqlStr = "SELECT INGRTI_RowId AS RowId, INGRTI_INGRI_DR, INGRTI_INGRI_DR->initm_phmnf_dr->phmnf_name Manf,"
				_"INGRTI_RetQty, INGRTI_RetUom_DR, INGRTI_RetAmount, INGRTI_MEDRTITM_DR, INGRTI_Sxno,"
				_"INGRTI_RealPrice, INGRTI_SalePrice, INGRTI_SpAmt, INGRTI_InvNo, INGRTI_InvAmt, INGRTI_InvDate "
				_"FROM DHC_INGRTITM WHERE INGRTI_INGRT_Parref="_RowId
			s result=##class(%ResultSet).%New()
			s result=##class(%Library.ResultSet).%New()
			d result.RuntimeModeSet(0)
			d result.Prepare(SqlStr)
			s sc=result.Execute()
			i $$$ISERR(sc) d RtnObj.Err(-1,RowId,"查询失败")
			q:RtnObj.success'=0	
			while (result.Next())
			{
				s RowId = result.Data("RowId")
				CONTINUE:..CheckIngDetail(RowId,Type)=1		;该退货单明细已经组合
				s Ingri = result.Data("INGRTI_INGRI_DR")
				s Inclb = result.Data("INGRTI_MEDRTITM_DR")
				s IncId = +Inclb
				s Code=$p($G(^INCI(IncId,1)),"^",1)
				s Description=$p($G(^INCI(IncId,1)),"^",2)
				s UomId = result.Data("INGRTI_RetUom_DR")
				s UomDesc=$s(UomId'="":$p(^CT("UOM",UomId),"^",2),1:"")
				s InclbObj=##class(User.INCItmLcBt).%OpenId(Inclb)
				s BatchNo=InclbObj.INCLBINCIBDR.INCIBNo
				s ExpDate=InclbObj.INCLBINCIBDR.INCIBExpDate
				s:ExpDate'="" ExpDate=..DL2H(ExpDate)
				s Qty = result.Data("INGRTI_RetQty")
				s Rp = result.Data("INGRTI_RealPrice")
				s RpAmt = -result.Data("INGRTI_RetAmount")
				s Sp = result.Data("INGRTI_SalePrice")
				s SpAmt = -result.Data("INGRTI_SpAmt")
				s InvAmt = -result.Data("INGRTI_InvAmt")
				s InvNo = result.Data("INGRTI_InvNo")
				s InvDate = result.Data("INGRTI_InvDate")
				s:InvDate'="" InvDate=..DL2H(InvDate)
				s SxNo = result.Data("INGRTI_Sxno")
				s Manf = result.Data("Manf")
				s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)  
				d OutPutRowDetail
			}
			d result.Close()
		}
	}
	
	Quit $$$OK
OutPutRowDetail
	s Data=$lb(RowId,IncId,Code,Description,Spec,UomDesc,BatchNo,ExpDate,Qty,Rp,RpAmt,Sp,SpAmt,InvAmt,InvNo,InvDate,Manf,SxNo,Type)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	入库退货单发票组合(根据入库退货单明细)
/// Creater:	tsr
/// CreateDate: 2018-07-25
/// Input:		科室Id,Main,Detail
ClassMethod jsSaveByItm(InvId As %String, LocId As %String, Detail As %String, Params As %String) As %Library.String
{
	n (InvId,LocId,Detail,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	tstart
	i InvId="" d
	.s RtnObj=..InsertInv(Params)
	.q:RtnObj.success'=0
	.s InvId=RtnObj.rowid
	i RtnObj.success'=0 tro  q RtnObj.Json() 
	i InvId="" tro  q RtnObj.Err(-1,"","发票信息不能为空","",0).Json()
	s RtnObj=..UpdVendorInvItmByItm(InvId,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=..UpdVendorInv(InvId,LocId)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tcommit 
	s RtnObj.rowid=InvId
	q RtnObj.Json()
}

/// Descript:	保存发票组合单明细(根据入库退货单明细)
/// Creater:	tsr
/// CreateDate: 2018-07-25
/// Input:		发票组合单主表Id,Detail
ClassMethod UpdVendorInvItmByItm(MainId As %String, Detail As %String) As RtnObj
{
	n (MainId,Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s RpAmt=Obj.%Get("RpAmt")
		s SpAmt=Obj.%Get("SpAmt")
		s obj=##class(User.DHCVendorInvItm).%New(MainId)
		d obj.INVIINVParRefSetObjectId(MainId)
		s Ch=$o(^DHCVendorInv(MainId,"I",""),-1)+1
		s obj.INVIChildSub=Ch
		s obj.INVIINGRIDR=RowId
		s obj.INVIInvRpAmt=RpAmt
		s obj.INVIInvSpAmt=SpAmt
		s obj.INVIType=Type
		s sc=obj.%Save()
		i $$$ISERR(sc) d
		.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
		.d RtnObj.Err(-2,"","发票明细保存失败:"_sc)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// Descript:	保存发票组合单
/// Creater:	tsr
/// CreateDate: 2018-07-25
/// Input:		科室Id,Main
ClassMethod UpdVendorInv(InvId As %String, LocId As %String) As RtnObj
{
	n (InvId,LocId)
	s RtnObj=##class(RtnObj).%New()
	
	s SumRpAmt=0,SumSpAmt=0
	s chl=0
	f  s chl=$o(^DHCVendorInv(InvId,"I",chl)) q:(RtnObj.success'=0)||(chl="")  d
	.s RpAmt=$p(^DHCVendorInv(InvId,"I",chl),"^",2)
	.s SpAmt=$p(^DHCVendorInv(InvId,"I",chl),"^",3)
	.s SumRpAmt=SumRpAmt+RpAmt
	.s SumSpAmt=SumSpAmt+SpAmt

	s obj=##class(User.DHCVendorInv).%OpenId(InvId)
	d obj.%Reload()
	s obj.INVRpAmt=SumRpAmt
	s obj.INVSpAmt=SumSpAmt
	s obj.INVUserCompleted="N"
	s obj.INVFilled="N"
	d obj.INVCTLOCDRSetObjectId(LocId)
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s sc=$tr($System.Status.GetErrorText(sc),$c(13,10,0,9))
	.d RtnObj.Err(-7,RowId,VendorDesc_"发票信息补充失败!"_sc)
	q:RtnObj.success'=0 RtnObj
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Descript:	保存发票信息
/// 对象类型数据
ClassMethod jsDeleteItm(RowId As %String) As %String
{
	n (RowId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..DeleteItm(RowId)
	q RtnObj.Json()
}

/// Descript:	发票组合单明细删除
/// Creator: 	tsr
/// CreatDate: 	2018-07-24
/// Table: 		DHC_VendorInvItm
/// Input: 		发票组合单Id
/// w ##class(web.DHCSTMHUI.DHCVendorInv).DeleteItm(8,"[{""RowId"":""8||2""}]")
ClassMethod DeleteItm(RowId As %String) As RtnObj
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	i RowId="" d RtnObj.Err(-1,"","未选择发票明细","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Inv=$p(RowId,"||",1)
	s chl=$p(RowId,"||",2)
	
	s RpAmt=$p(^DHCVendorInv(Inv,"I",chl),"^",2)
	s SpAmt=$p(^DHCVendorInv(Inv,"I",chl),"^",3)
	s InvRpAmt=$p(^DHCVendorInv(Inv),"^",8)
	s InvSpAmt=$p(^DHCVendorInv(Inv),"^",9)
	s InvRpAmt=InvRpAmt-RpAmt
	s InvSpAmt=InvSpAmt-SpAmt
	&sql(delete from DHC_VendorInvItm where %id=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-3,RowId,"删除明细失败!")
	q:RtnObj.success'=0 RtnObj
	s $p(^DHCVendorInv(Inv),"^",8)=InvRpAmt
	s $p(^DHCVendorInv(Inv),"^",9)=InvSpAmt
	
	q RtnObj
}

/// Descript:	发票组合单完成
/// Creator: 	tsr
/// CreatDate: 	2018-07-24
/// Table: 		DHC_VendorInv
/// Input: 		发票组合单Id
ClassMethod SetComp(Inv As %String) As %String
{
	n (Inv)
	s RtnObj=##class(RtnObj).%New()
	i Inv="" d RtnObj.Err(-1,"","发票组合单Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Comp="N"
	&sql(SELECT INV_UserCompleted INTO :Comp FROM DHC_VendorInv WHERE %ID=:Inv)
	i Comp="Y" d RtnObj.Err(-2,Inv,"已完成,不能重复完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ..sssLock(..%GetParameter("AppName")_Inv)<0 d RtnObj.Err(-99,Inv,"加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Comp="Y"
	&sql(update DHC_VendorInv set INV_UserCompleted=:Comp where %ID=:Inv)
	i SQLCODE'=0 d RtnObj.Err(-3,Inv,"更新发票组合单失败!")
	d ..sssUnLock(..%GetParameter("AppName")_Inv)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj.rowid=Inv
	q RtnObj.Json()
}

/// Descript:	发票组合单取消完成
/// Creator: 	tsr
/// CreatDate: 	2018-07-24
/// Table: 		DHC_VendorInv
/// Input: 		发票组合单Id
ClassMethod CancelComp(Inv As %String) As %String
{
	n (Inv)
	s RtnObj=##class(RtnObj).%New()
	i Inv="" d RtnObj.Err(-1,"","发票组合单Id不能为空!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Comp="Y"
	&sql(select INV_UserCompleted,INV_InvNo,INV_Filled into :Comp,:InvNo,:Filled from DHC_VendorInv where %ID=:Inv)
	i SQLCODE'=0 d RtnObj.Err(-2,Inv,"查询发票组合单失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i Comp'="Y" d RtnObj.Err(-3,Inv,"未完成,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i Filled="Y" d RtnObj.Err(-4,Inv,"已确认,不允许取消完成!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	i ..sssLock(..%GetParameter("AppName")_Inv)<0 d RtnObj.Err(-99,Inv,"加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Comp="N"
	&sql(update DHC_VendorInv set INV_UserCompleted=:Comp where %ID=:Inv)
	i SQLCODE'=0 d RtnObj.Err(-5,Inv,"更新发票组合单失败!")
	d ..sssUnLock(..%GetParameter("AppName")_Inv)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj.rowid=Inv
	q RtnObj.Json()
}

/// Descript:	查询发票组合明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-20
/// Table: 		DHC_VendorInv
/// Input: 		Params对象
Query DHCVendorInvItm(Inv As %String) As Query(ROWSPEC = "RowId,Ingri,IncId,Code,Description,Spec,Qty:%Float,UomDesc,Manf,Rp:%Float,Sp:%Float,RpAmt:%Float,SpAmt:%Float,Type,IngrNo") [ SqlProc ]
{
}

ClassMethod DHCVendorInvItmExecute(ByRef qHandle As %Binary, Inv As %String) As %Status
{
	n (qHandle,Inv)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inv="" $$$OK

	s Ch=0
	f  s Ch=$o(^DHCVendorInv(Inv,"I",Ch)) q:Ch=""  d
	.s Invi=Inv_"||"_Ch q:Invi=""
	.s Ingri=$p(^DHCVendorInv(Inv,"I",Ch),"^",1)
	.s Type=$p(^DHCVendorInv(Inv,"I",Ch),"^",4)
	.i Type="G" d
	..s RecItm=..SelRecItmInfo(Ingri)
	.e  d
	..s RecItm=..SelRetItmInfo(Ingri)
	.s IncId=$p(RecItm,"^",1)
	.s Code=$p(RecItm,"^",2)
	.s Description=$p(RecItm,"^",3)
	.s Spec=$p(RecItm,"^",4)
	.s Qty=$p(RecItm,"^",5)
	.s UomDesc=$p(RecItm,"^",6)
	.s Manf=$p(RecItm,"^",7)
	.s Rp=$p(RecItm,"^",8)
	.s Sp=$p(RecItm,"^",9)
	.s RpAmt=$p(RecItm,"^",10)
	.s SpAmt=$p(RecItm,"^",11)
	.s IngrNo=$p(RecItm,"^",12)
	.d OutPutItmRow 

	Quit $$$OK
OutPutItmRow
	s Data=$lb(Invi,Ingri,IncId,Code,Description,Spec,Qty,UomDesc,Manf,Rp,Sp,RpAmt,SpAmt,Type,IngrNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询入库明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-20
/// Table: 		DHC_INGdRecItm
/// Input: 		入库明细Id
ClassMethod SelRecItmInfo(Ingri) As %String
{
	n (Ingri)
	s DHCINGR=+Ingri q:DHCINGR="" ""
	s DHCINGRCH=$p(Ingri,"||",2) q:DHCINGRCH="" ""
	q:'$d(^DHCINGR(DHCINGR,"GRI",DHCINGRCH)) ""
	
	s IngrNo=$p(^DHCINGR(DHCINGR),"^",1)
	s RecQty=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",4)
	s IncId=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",25)
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	s (IncCode,IncDesc)=""
	s:IncId'="" IncCode=$p(^INCI(IncId,1),"^",1)
	s:IncId'="" IncDesc=$p(^INCI(IncId,1),"^",2)
	s Uom=+$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10)
	s UomDesc=""
	s:Uom'="" UomDesc=$p(^CT("UOM",Uom),"^",2)
	s manf=""
	s manfid=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",29) 
	i manfid'="" s manf=$p(^PHMNF(manfid),"^",2) 
	s rp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30) 
	s sp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",32)
	s spamt=sp*RecQty	
	s rpamt=rp*RecQty
	s ret=IncId_"^"_IncCode_"^"_IncDesc_"^"_spec_"^"_RecQty_"^"_UomDesc_"^"_manf_"^"_rp_"^"_sp_"^"_rpamt
		_"^"_spamt_"^"_IngrNo
	q ret
}

/// Descript:	查询退货明细信息
/// Creator: 	tsr
/// CreatDate: 	2018-06-20
/// Table: 		DHC_INGRTITM
/// Input: 		退货明细Id
ClassMethod SelRetItmInfo(Ingri) As %String
{
	n (Ingri)
	s DHCINGRT=+Ingri q:DHCINGRT="" ""
	s DHCINGRTCH=$p(Ingri,"||",2) q:DHCINGRTCH="" ""
	q:'$d(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH)) ""
	
	s IngrtNo=$p(^INGRT(DHCINGRT),"^",1)
	s Qty=$p(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH),"^",2)
	s inclb=$p(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH),"^",6)
	s IncId=+inclb
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	s IncCode=$p(^INCI(IncId,1),"^",1)
	s IncDesc=$p(^INCI(IncId,1),"^",2)
	s Uom=$P(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH),"^",3)
	s UomDesc=""
	s:Uom'="" UomDesc=$p($g(^CT("UOM",Uom)),"^",2)
	
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	s manf=$p(ManfInfo,"^",2)
	
	s rp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH),"^",7)
	s sp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCINGRTCH),"^",8)
	s spamt=-1*sp*Qty
	s rpamt=-1*rp*Qty
	s ret=IncId_"^"_IncCode_"^"_IncDesc_"^"_spec_"^"_Qty_"^"_UomDesc_"^"_manf_"^"_rp_"^"_sp_"^"_rpamt
		_"^"_spamt_"^"_IngrtNo
	q ret
}

/// Descript:	保存发票信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCVendorInv).jsAuditInvInfo(2)
ClassMethod jsAuditInvInfo(Inv As %String) As %String
{
	n (Inv)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..AuditInvInfo(Inv)
	q RtnObj.Json()
}

/// Descript:   保存发票信息
/// Creater:    lxt
/// CreateDate: 2019-10-10
/// Table:		DHC_InvInfo
/// Input:		发票信息
ClassMethod AuditInvInfo(Inv As %String) As RtnObj
{
	n (Inv)
	s RtnObj=##class(RtnObj).%New()
	q:Inv="" RtnObj.Err(-1,"","请选择发票信息","",0)
	
	ts
	s FilledFlag="Y"
	&sql(update DHC_VendorInv set INV_Filled=:FilledFlag where INV_RowId=:Inv)
	i SQLCODE'=0 d
	.tro
	.d RtnObj.Err(-2,Inv,"审核失败!"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	
	s InvCode=$p(^DHCVendorInv(Inv),"^",16)
	s InvNo=$p(^DHCVendorInv(Inv),"^",10)
	s InvDate=$p(^DHCVendorInv(Inv),"^",15)
	s:InvDate'="" InvDate=..DL2H(InvDate)
	
	s Detail=""
	s Title="RowId^Type^InvNo^InvCode^InvDate^InvAmt"
	s chl=0
	f  s chl=$o(^DHCVendorInv(Inv,"I",chl)) q:(RtnObj.success'=0)||(chl="")  d
	.s Pointer=$p(^DHCVendorInv(Inv,"I",chl),"^",1)
	.s RpAmt=$p(^DHCVendorInv(Inv,"I",chl),"^",2)
	.s Type=$p(^DHCVendorInv(Inv,"I",chl),"^",4)
	.s tmpInvCode="",tmpInvNo=""
	.i Type="G" d
	..&sql(select initm_invcode,initm_invno into :tmpInvCode,:tmpInvNo from dhc_ingdrecitm where %id=:Pointer)
	.i Type="R" d
	..s RpAmt=-RpAmt
	..&sql(select INGRTI_InvCode,INGRTI_InvNo into :tmpInvCode,:tmpInvNo from dhc_ingrtitm where %id=:Pointer)
	.i ((tmpInvCode'="")||(tmpInvNo'=""))&&(tmpInvCode'=InvCode)&&(tmpInvNo'=InvNo) d RtnObj.Err(-3,Inv,"部分明细已存在不同发票信息，不能审核！","",0)
	.s Data=Pointer_"^"_Type_"^"_InvNo_"^"_InvCode_"^"_InvDate_"^"_RpAmt
	.s Data=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i Detail="" d
	..s Detail=Data
	.e  d
	..s Detail=Detail_","_Data
	i RtnObj.success'=0  d
	.tro
	.d RtnObj.Err(-3,Inv,"发票不存在有效明细!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s Detail="["_Detail_"]"
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecInv).Update(Detail)
	i RtnObj.success'=0 d
	.tro
	.d RtnObj.Err(-3,Inv,"更新单据发票信息失败")
	q:RtnObj.success'=0 RtnObj
	
	tc
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.DHCVendorInv).GetInvAmtByIngr("3drt4","456")
ClassMethod GetInvAmtByIngr(InvCode, InvNo)
{
	n (InvCode,InvNo)
	s InvAmt=0,IngrInvAmt=0,IngrtInvAmt=0
	&sql(select sum(initm_invmoney) into :IngrInvAmt from DHC_INGdRecItm where nvl(initm_InvCode,'')=nvl(:InvCode,'') and initm_invno=:InvNo)
	&sql(select sum(INGRTI_InvAmt) into :IngrtInvAmt from DHC_INGRTITM where nvl(INGRTI_InvCode,'')=nvl(:InvCode,'') and INGRTI_InvNo=:InvNo)
	s IngrtInvAmt=-IngrtInvAmt
	s InvAmt=IngrInvAmt+IngrtInvAmt
	
	q InvAmt
}

/// Descript:	保存更新发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-15
/// Table:		DHC_VendorInv
/// Input:		发票信息
/// w ##class(web.DHCSTMHUI.DHCVendorInv).jsSave("[{""RowId"":""56"",""InvCode"":""gggg"",""InvNo"":""20221108"",""VendorId"":""19"",""InvAmt"":""100000"",""InvDate"":""2022-11-08"",""LocId"":""163""}])
ClassMethod jsSave(ListData) As %String
{
	n (ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(ListData)
	q RtnObj.Json()
}

/// Descript:	保存更新发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-15
/// Table:		DHC_VendorInv
ClassMethod Save(ListData) As RtnObj
{
	n (ListData)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	i (ListData="")  q RtnObj.Err(-1,"",MethodName_":不存在需要保存的明细!","",0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-2,"",MethodName_":参数解析错误")
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RtnObj=..UpdateInvInfo(Obj)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	保存更新发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-15
/// Table:		DHC_VendorInv
ClassMethod UpdateInvInfo(ListDataObj As %String) As RtnObj
{
	n (ListDataObj)
	s RtnObj=##class(RtnObj).%New()
	s RowId=ListDataObj.%Get("RowId")
	s Vendor=ListDataObj.%Get("VendorId")
	s InvCode=ListDataObj.%Get("InvCode")
	s InvNo=ListDataObj.%Get("InvNo")
	s InvAmt=ListDataObj.%Get("InvAmt")
	s InvDate=ListDataObj.%Get("InvDate")
	s UpdateUser=ListDataObj.%Get("gUserId")
	s LocId=ListDataObj.%Get("LocId")
	s CompFlag=ListDataObj.%Get("CompFlag")
	s FilledFlag=ListDataObj.%Get("FilledFlag")
	i (RowId="")||('$d(^DHCVendorInv(RowId))) d RtnObj.Err(-3,"","发票记录不存在!","",0)
	q:RtnObj.success'=0 RtnObj
	i LocId="" d RtnObj.Err(-4,"",RowId_"科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i Vendor="" d RtnObj.Err(-5,"",RowId_"供应商不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s FilledFlag=$p(^DHCVendorInv(RowId),"^",12)
	i FilledFlag="Y" d RtnObj.Err(-6,"",RowId_"发票记录已审核不允许修改！","",0)
	q:RtnObj.success'=0 RtnObj
	s InvDate=..DH2L(InvDate)
	s UpdateDate=+$h
	s UpdateTime=$p($h,",",2)
	s tmpRowId=""
	i InvNo'="" d
	.&sql(select %ID into :tmpRowId from DHC_VendorInv where nvl(INV_InvCode,'')=nvl(:InvCode,'') and INV_InvNo=:InvNo and INV_RowId<>:RowId)
	q:(tmpRowId'="")&&(tmpRowId'=RowId) RtnObj.Err(-7,"",InvNo_"此发票信息已存在","",0)
	&sql(update DHC_VendorInv set INV_InvCode=:InvCode,INV_InvNo=:InvNo,INV_APCVM_DR=:Vendor,INV_InvRpAmt=:InvAmt,
		INV_InvDate=:InvDate,INV_UpdateUser=:UpdateUser,INV_UpdateDate=:UpdateDate,INV_UpdateTime=:UpdateTime,
		INV_CTLOC_DR=:LocId
		where INV_RowId=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-8,RowId,InvNo_"保存失败!"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	预制发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-15
/// Table:		DHC_VendorInv
ClassMethod InsertInv(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	s LocId=PJObj.%Get("LocId")
	s Vendor=PJObj.%Get("Vendor")
	s CreateUser=PJObj.%Get("gUserId")
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	&sql(Insert into DHC_VendorInv(INV_APCVM_DR,INV_CreateUser,INV_CreateDate,INV_CreateTime,INV_CTLOC_DR)
		values(:Vendor,:CreateUser,:CreateDate,:CreateTime,:LocId))
	i SQLCODE'=0 d RtnObj.Err(-3,"",InvNo_"保存失败!"_SQLCODE)
	q:RtnObj.success'=0
	s InvId=$p(%ROWID,$c(1))
	s RtnObj.rowid=InvId
	q RtnObj
}

/// Descript:	删除发票记录信息
/// Creater:    wxj
/// CreateDate: 2022-11-16
/// Table:		DHC_VendorInv
/// w ##class(web.DHCSTMHUI.DHCVendorInv).jsDelete(489)
ClassMethod jsDelete(InvId) As %Library.String
{
	n (InvId,%session)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..Delete(InvId)
	q RtnObj.Json()
}

/// Descript:	删除发票记录信息
/// Creater:    wxj
/// CreateDate: 2022-11-16
/// Table:		DHC_VendorInv
///  w ##class(web.DHCSTMHUI.DHCVendorInv).Delete(489)
ClassMethod Delete(InvId) As RtnObj
{
	n (InvId,%session)
	s RtnObj=##class(RtnObj).%New()
	i InvId=""  q RtnObj.Err(-1,"","请选择发票记录","",0)
	i '$d(^DHCVendorInv(InvId)) q RtnObj.Err(-2,"","发票记录不存在!","",0)
	s CompFlag=$p(^DHCVendorInv(InvId),"^",11)
	i CompFlag="Y" q RtnObj.Err(-3,"","发票已完成!","",0)
	s FilledFlag=$p(^DHCVendorInv(InvId),"^",12)
	i FilledFlag="Y" q RtnObj.Err(-4,"","发票已审核!","",0)
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_VendorInv",InvId)
	&sql(Delete from DHC_VendorInv where %ID=:InvId) 
	i SQLCODE'=0 d
	.d RtnObj.Err(-5,"","删除发票记录失败!")
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_VendorInv","User.DHCVendorInv","发票信息",InvId,"","D",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	取消审核发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-16
/// Table:		DHC_VendorInv
/// w ##class(web.DHCSTMHUI.DHCVendorInv).jsCancelAudit(2)
ClassMethod jsCancelAudit(InvId As %String) As %String
{
	n (InvId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelAudit(InvId)
	q RtnObj.Json()
}

/// Descript:	取消审核发票信息
/// Creater:    wxj
/// CreateDate: 2022-11-16
/// Table:		DHC_VendorInv
ClassMethod CancelAudit(InvId As %String) As RtnObj
{
	n (InvId)
	s RtnObj=##class(RtnObj).%New()
	q:InvId="" RtnObj.Err(-1,"","请选择发票信息","",0)
	i '$d(^DHCVendorInv(InvId)) q RtnObj.Err(-2,"","发票记录不存在!","",0)
	s CompFlag=$p(^DHCVendorInv(InvId),"^",11)
	i CompFlag'="Y" q RtnObj.Err(-3,"","发票未完成!","",0)
	s FilledFlag=$p(^DHCVendorInv(InvId),"^",12)
	i FilledFlag'="Y" q RtnObj.Err(-4,"","发票未审核!","",0)
	
	ts	
	s (InvCode,InvNo,InvDate)=""	
	s Detail=""
	s Title="RowId^Type^InvNo^InvCode^InvDate^InvAmt"
	s chl=0
	f  s chl=$o(^DHCVendorInv(InvId,"I",chl)) q:(RtnObj.success'=0)||(chl="")  d
	.s Pointer=$p(^DHCVendorInv(InvId,"I",chl),"^",1)
	.s RpAmt=$p(^DHCVendorInv(InvId,"I",chl),"^",2)
	.s Type=$p(^DHCVendorInv(InvId,"I",chl),"^",4)
	.s tmpInvCode="",tmpInvNo=""
	.s Data=Pointer_"^"_Type_"^"_InvNo_"^"_InvCode_"^"_InvDate_"^"_RpAmt
	.s Data=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.i Detail="" d
	..s Detail=Data
	.e  d
	..s Detail=Detail_","_Data
	s Detail="["_Detail_"]"
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecInv).Update(Detail)
	i RtnObj.success'=0 d
	.tro
	.d RtnObj.Err(-5,InvId,"更新单据发票信息失败")
	q:RtnObj.success'=0 RtnObj
	
	&sql(update DHC_VendorInv set INV_Filled=null,INV_AuditUser_Dr=null,INV_AuditDate=null,INV_AuditTime=null where INV_RowId=:InvId)
	i SQLCODE'=0 d
	.tro
	.d RtnObj.Err(-6,InvId,"取消审核失败!")
	q:RtnObj.success'=0 RtnObj
	tc
	q RtnObj
}

}
