Import sqluser

/// Descript:	其他组接口程序
/// Creater:	wangjiabin
/// CreateDate:	2015-11-10
Class web.DHCSTMHUI.ServiceForOthers Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	取材料库房一段时间内的出库数据汇总(预算管理等财务软件使用)
/// Creater:	wangjiabin
/// CreateDate:	2015-11-10
/// Table:		
/// Input:		开始日期(Y-m-d格式或数字格式), 截止日期(Y-m-d格式或数字格式), 科室id(若多个科室,使用逗号隔开)
/// Return:		日期^科室编码^科室名称^库存分类描述^进价金额^售价金额^类组
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForOthers","GetTransOutInfo","2015-11-10","2015-11-10",153)
Query GetTransOutInfo(StartDate As %String, EndDate As %String, LocId As %String) As Query(ROWSPEC = "loccode,locdesc,catdesc,rpamt:%Float,spamt:%Float,scgdesc") [ SqlProc ]
{
}

ClassMethod GetTransOutInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String) As %Status
{
	n (qHandle,StartDate,EndDate,LocId)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:StartDate="" $$$OK
	q:LocId="" $$$OK
	
	s pid=..NewPid()
	k ^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid)
	
	k InitiInciInfo		//"数组",记录库存项相关数据
	
	f date=StartDate:1:EndDate d
	.;1. 统计转出部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","T",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)	;出库科室
	..q:FromLocId=""
	..q:(","_LocId_",")'[(","_FromLocId_",")
	..
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)		;接收科室
	..
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s inciid=$p(inclbid,"||",1)
	..q:'$d(^INCI(inciid,1))
	..
	..///Inci部分
	..s (Incsc,Scg,StkType)=""
	..i '$d(InitiInciInfo(inciid)) d
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	...s StkType=$p(ScgInfo,"^",3)
	...s Scg=$p(ScgInfo,"^",5)
	...s Incsc=$p(^INCI(inciid,2),"^",2)
	...
	...s InitiInciInfo(inciid)=Incsc_"^"_Scg_"^"_StkType
	..e  d
	...s InciInfo=InitiInciInfo(inciid)
	...s Incsc=$p(InciInfo,"^",1)
	...s Scg=$p(InciInfo,"^",2)
	...s StkType=$p(InciInfo,"^",3)
	..
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..
	..s Sub="^"_ToLocId_"^"_Incsc
	..i '$d(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub)) d
	...s ^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",1)=RpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",1)
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",2)=SpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",2)
	.
	.
	.;2. 统计转入部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","K",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)	;出库科室
	..
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)		;接收科室
	..q:ToLocId=""
	..q:(","_LocId_",")'[(","_ToLocId_",")
	..
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s inciid=$p(inclbid,"||",1)
	..q:'$d(^INCI(inciid,1))
	..
	..///Inci部分
	..s (Incsc,Scg,StkType)=""
	..i '$d(InitiInciInfo(inciid)) d
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	...s StkType=$p(ScgInfo,"^",3)
	...s Scg=$p(ScgInfo,"^",5)
	...s Incsc=$p(^INCI(inciid,2),"^",2)
	...
	...s InitiInciInfo(inciid)=Incsc_"^"_Scg_"^"_StkType
	..e  d
	...s InciInfo=InitiInciInfo(inciid)
	...s Incsc=$p(InciInfo,"^",1)
	...s Scg=$p(InciInfo,"^",2)
	...s StkType=$p(InciInfo,"^",3)
	..
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..
	..s Sub="^"_FromLocId_"^"_Incsc
	..i '$d(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub)) d
	...s ^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",1)=RpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",1)
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",2)=SpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",2)


	;输出数据, 返回值需要处理的,可在下方代码中修改维护
	s Sub=""
	f  s Sub=$o(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub)) q:Sub=""  d
	.s ToLocId=$p(Sub,"^",2)
	.s loccode=$p(^CTLOC(ToLocId),"^",1)
	.s locdesc=$p(^CTLOC(ToLocId),"^",2)
	.s:locdesc["-" locdesc=$p(locdesc,"-",2)
	.s IncscId=$p(Sub,"^",3)
	.s IncscDesc=$p(^INC("SC",IncscId),"^",2)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).StkCatGrpStr(IncscId)
	.s ScgDesc=$p(ScgInfo,"^",2)
	.;出库取正数
	.s RpAmt=-$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",1)
	.s SpAmt=-$p(^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid,Sub),"^",2)
	.d OutputRow
	
	k ^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(loccode,locdesc,IncscDesc,RpAmt,SpAmt,ScgDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// Descript:	取材料库房一段时间内的入库退货数据汇总(预算管理等财务软件使用)
/// Creater:	xuchao
/// CreateDate:	2016-5-25
/// Table:		
/// Input:		开始日期(Y-m-d格式或数字格式), 截止日期(Y-m-d格式或数字格式), 科室id(若多个科室,使用逗号隔开)
/// Return:		供应商^进价金额^售价金额
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForOthers","GetImportInfo","2015-11-10","2015-11-10",153)
Query GetImportInfo(StartDate As %String, EndDate As %String, LocId As %String) As Query(ROWSPEC = "VenName,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetImportInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String) As %Status
{
	n (qHandle,StartDate,EndDate,LocId)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:StartDate="" $$$OK
	q:LocId="" $$$OK
	
	s pid=..NewPid()
	k ^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid)
	
	k InitiInciInfo		//"数组",记录库存项相关数据
	
	f date=StartDate:1:EndDate d
	.;1. 统计入库部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","G",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s dhcingr=+pointer
 	..s dhcingri=$p(pointer,"||",2)
 	..q:'$d(^DHCINGR(dhcingr))
 	..q:'$d(^DHCINGR(dhcingr,"GRI",dhcingri))
	..s RecLocId=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",3)
	..q:(","_LocId_",")'[(","_RecLocId_",")
	..s inclbid=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",1)
 	..q:inclbid=""
 	..s inciid=$p(inclbid,"||",1)
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..s apcvmid=$p(^DHCINGR(dhcingr),"^",3)
 	..s VenName=""
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)
	..///Inci部分
	..s (Incsc,Scg,StkType)=""
	..i '$d(InitiInciInfo(inciid)) d
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	...s StkType=$p(ScgInfo,"^",3)
	...s Scg=$p(ScgInfo,"^",5)
	...s Incsc=$p(^INCI(inciid,2),"^",2)
	...
	...s InitiInciInfo(inciid)=Incsc_"^"_Scg_"^"_StkType
	..e  d
	...s InciInfo=InitiInciInfo(inciid)
	...s Incsc=$p(InciInfo,"^",1)
	...s Scg=$p(InciInfo,"^",2)
	...s StkType=$p(InciInfo,"^",3)
	..
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..
	..s Sub=apcvmid_"^"_VenName
	..i '$d(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub)) d
	...s ^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",1)=RpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",1)
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",2)=SpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",2)
	.
	.
	.;2. 统计退货部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","R",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..
	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s ingrtid=$p(pointer,"||",1)
 	..s retch=$p(pointer,"||",2)
 	..q:'$d(^INGRT(ingrtid))
 	..q:'$d(^INGRT(ingrtid,"DHCGRR",retch))
 	..s retstr=^INGRT(ingrtid)
 	..s retistr=^INGRT(ingrtid,"DHCGRR",retch)
 	..s ingriid=$p(retistr,"^",1) ;
 	..s dhcingri=ingriid
 	..s dhcingrich=$p(dhcingri,"||",2)
 	..s dhcingri=$p(dhcingri,"||",1)
 	..q:dhcingri=""
 	..q:dhcingrich=""
 	..s retcom=$p(retstr,"^",6)
 	..q:retcom'="Y"
 	..s RetLocId=$p(retstr,"^",7)
	..q:(","_LocId_",")'[(","_RetLocId_",")
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..s inciid=$p(inclbid,"||",1)
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
	..s apcvmid=$p(^INGRT(ingrtid),"^",2)
	..s VenName=""
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)

	..///Inci部分
	..s (Incsc,Scg,StkType)=""
	..i '$d(InitiInciInfo(inciid)) d
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	...s StkType=$p(ScgInfo,"^",3)
	...s Scg=$p(ScgInfo,"^",5)
	...s Incsc=$p(^INCI(inciid,2),"^",2)
	...
	...s InitiInciInfo(inciid)=Incsc_"^"_Scg_"^"_StkType
	..e  d
	...s InciInfo=InitiInciInfo(inciid)
	...s Incsc=$p(InciInfo,"^",1)
	...s Scg=$p(InciInfo,"^",2)
	...s StkType=$p(InciInfo,"^",3)
	..
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..
	..s Sub=apcvmid_"^"_VenName
	..i '$d(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub)) d
	...s ^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",1)=RpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",1)
	...s $p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",2)=SpAmt+$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",2)


	;输出数据, 返回值需要处理的,可在下方代码中修改维护
	s Sub=""
	f  s Sub=$o(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub)) q:Sub=""  d
	.s VenName=$p(Sub,"^",2)
	.s RpAmt=$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",1)
	.s SpAmt=$p(^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid,Sub),"^",2)
	.d OutputRow2
	
	k ^TMP("DHCSTM.ServiceForOthers","GetImportInfo",pid)
	Quit $$$OK
	
OutputRow2
	Set Data=$lb(VenName,RpAmt,SpAmt)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetLocDepType(locdr)
{
	n (locdr)
	s locdepdr=$p(^CTLOC(locdr),"^",19)
	q:locdepdr="" "其他"
	s deptdesc=$p(^RBC("DEP",locdepdr),"^",2)
	q deptdesc
}

/// Description:物资科库存变动数据(用于成本核算接口)
/// Creater:	wangjiabin
/// CreateDate:	2017-07-07
/// Input:		开始日期(Y-m-d格式或数字格式), 截止日期(Y-m-d格式或数字格式), 科室id(若多个科室,使用逗号隔开)
/// Return:		TrId,TrType:业务类型,TrNo:业务单号,TrDate:业务日期,VendorCode:供应商代码,
/// 			VendorDesc:供应商名称,LocCode:库房代码,LocDesc:库房名称,ScgCode:类组代码,ScgDesc:类组名称,
/// 			InciCode:库存项代码,InciDesc:库存项名称,UomDesc:业务单位,Qty:业务数量,Rp:进价,
/// 			RpAmt:进价金额,Sp:售价(=Rp),SpAmt:售价金额(=RpAmt)
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForOthers","GetTrDetail","2015-11-10","2015-11-10",153)
Query GetTrDetail(StartDate As %String, EndDate As %String, LocIdStr As %String) As Query(ROWSPEC = "TrId,TrType,TrNo,TrDate,VendorCode,VendorDesc,LocCode,LocDesc,ScgCode,ScgDesc,InciCode,InciDesc,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float")
{
}

ClassMethod GetTrDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocIdStr As %String) As %Status
{
	n (qHandle,StartDate,EndDate,LocIdStr)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:StartDate="" $$$OK
	q:LocIdStr="" $$$OK
	
	s STKTYPE=..sssCode()
	k TrDetailInciInfo			//"数组",记录库存项相关数据
	
	s TrTypeStr="G^T^K^R^A"		;控制台帐类组
	s LocLen=$l(LocIdStr,",")
	f i=1:1:LocLen d
	.s LocId=$p(LocIdStr,",",i)
	.q:LocId=""
	.s LocCode=$p(^CTLOC(LocId),"^",1)
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s TrType=""
	.f  s TrType=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,TrType)) q:TrType=""  d
	..q:'$lf($lfs(TrTypeStr,"^"),TrType)
	..s TrDate=StartDate-1
	..f  s TrDate=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,TrType,TrDate)) q:(TrDate="")||(TrDate>EndDate)  d
	...s TrDateZ=$zd(TrDate,3)
	...s TrId=0
	...f  s TrId=$o(^DHCINTR(0,"LOCTYPEDATE",LocId,TrType,TrDate,TrId)) q:TrId=""  d
	....s TrInfo=^DHCINTR(TrId)
	....s TrNo=$p(TrInfo,"^",13)
	....s Qty=$p(TrInfo,"^",6)
	....s Inclb=$p(TrInfo,"^",7)
	....s TrUomId=$p(TrInfo,"^",10)
	....s Rp=$p(TrInfo,"^",16)
	....s RpAmt=$p(TrInfo,"^",17)
	....s Sp=Rp
	....s SpAmt=RpAmt
	....q:TrUomId=""
	....s UomDesc=$p(^CT("UOM",TrUomId),"^",2)
	....
	....s Inci=$p(Inclb,"||",1)
	....q:Inci=""
	....i '$d(TrDetailInciInfo(Inci)) d
	.....s InciCode=$p(^INCI(Inci,1),"^",1)
	.....s InciDesc=$p(^INCI(Inci,1),"^",2)
	.....s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.....s ScgCode=$p(ScgInfo,"^",1)
	.....s ScgDesc=$p(ScgInfo,"^",2)
	.....s StkType=$p(ScgInfo,"^",3)
	.....s Scg=$p(ScgInfo,"^",5)
	.....s Incsc=$p(^INCI(Inci,2),"^",2)
	.....s TrDetailInciInfo(Inci)=Incsc_"^"_Scg_"^"_StkType_"^"_ScgCode_"^"_ScgDesc_"^"_InciCode_"^"_InciDesc
	....e  d
	.....s InciInfo=TrDetailInciInfo(Inci)
	.....s StkType=$p(InciInfo,"^",3)
	.....s ScgCode=$p(InciInfo,"^",4)
	.....s ScgDesc=$p(InciInfo,"^",5)
	.....s InciCode=$p(InciInfo,"^",6)
	.....s InciDesc=$p(InciInfo,"^",7)
	....q:StkType'=STKTYPE
	....
	....s (VendorCode,VendorDesc)=""
	....i (TrType="G")||(TrType="R") d
	.....s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.....s VendorId=$p(VendorInfo,"^",1)
	.....q:VendorId=""
	.....s VendorCode=$p(^APC("APCVM",VendorId),"^",2)
	.....s VendorDesc=$p(VendorInfo,"^",2)
	....
	....d OutPutTrDetail
	Quit $$$OK
OutPutTrDetail
	Set Data=$lb(TrId,TrType,TrNo,TrDateZ,VendorCode,VendorDesc,LocCode,LocDesc,ScgCode,ScgDesc,
		InciCode,InciDesc,UomDesc,Qty,Rp,RpAmt,Sp,SpAmt)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// Descript:	取科室一段时间内的所领取耗材数据汇总(综合查询组使用)
/// Creater:	lxt
/// CreateDate:	20210720
/// Table:		
/// Input:		开始日期(Y-m-d格式或数字格式), 截止日期(Y-m-d格式或数字格式)
/// Return:		科室编码^科室名称^进价金额^售价金额
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForOthers","GetLocTransOutInfo","2021-01-01","2021-07-20")
Query GetLocTransOutInfo(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "LocCode,LocDesc,RpAmt:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod GetLocTransOutInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	q:StartDate="" $$$OK
	q:StartDate="" $$$OK
	
	s pid=..NewPid()
	k ^TMPDHCSTM("GetLocTransOutInfo",pid)
	
	//k InitiInciInfo		//"数组",记录库存项相关数据
	
	f date=StartDate:1:EndDate d
	.;1. 统计转出部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","T",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)	;出库科室
	..q:FromLocId=""
	..s ifstock=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(FromLocId)
	..q:ifstock="Y"
	..
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)		;接收科室
	..
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s inciid=$p(inclbid,"||",1)
	..q:'$d(^INCI(inciid,1))
	..
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	..s StkType=$p(ScgInfo,"^",3)
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..i '$d(^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId)) d
	...s ^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId),"^",1)=RpAmt+$p(^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId),"^",1)
	...s $p(^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId),"^",2)=SpAmt+$p(^TMPDHCSTM("GetLocTransOutInfo",pid,FromLocId),"^",2)
	.
	.
	.;2. 统计转入部分
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate","K",date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)	;出库科室
	..
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)		;接收科室
	..q:ToLocId=""
	..s ifstock=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(ToLocId)
	..q:ifstock="Y"
	..
	..s inclbid=$p(^DHCINTR(intrid),"^",7)
	..q:inclbid=""
	..
	..s inciid=$p(inclbid,"||",1)
	..q:'$d(^INCI(inciid,1))
	..
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	..s StkType=$p(ScgInfo,"^",3)
	..q:StkType'=..sssCode()
	..
	..s RpAmt=$p(^DHCINTR(intrid),"^",17)
	..s SpAmt=$p(^DHCINTR(intrid),"^",8)
	..
	..i '$d(^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId)) d
	...s ^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId)=RpAmt_"^"_SpAmt
	..e  d
	...s $p(^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId),"^",1)=RpAmt+$p(^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId),"^",1)
	...s $p(^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId),"^",2)=SpAmt+$p(^TMPDHCSTM("GetLocTransOutInfo",pid,ToLocId),"^",2)

	;输出数据, 返回值需要处理的,可在下方代码中修改维护
	s LocId=""
	f  s LocId=$o(^TMPDHCSTM("GetLocTransOutInfo",pid,LocId)) q:LocId=""  d
	.s LocCode=$p(^CTLOC(LocId),"^",1)
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s RpAmt=$p(^TMPDHCSTM("GetLocTransOutInfo",pid,LocId),"^",1)
	.s SpAmt=$p(^TMPDHCSTM("GetLocTransOutInfo",pid,LocId),"^",2)
	.d OutputRowLoc
	
	k ^TMP("DHCSTM.ServiceForOthers","GetTransOutInfo",pid)
	Quit $$$OK
	
OutputRowLoc
	s Data=$lb(LocCode,LocDesc,RpAmt,SpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	Quit
}

}
