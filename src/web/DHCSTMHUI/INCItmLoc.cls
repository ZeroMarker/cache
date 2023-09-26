Import sqluser

Class web.DHCSTMHUI.INCItmLoc Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 批量更新科室库存项目信息
/// Author:zhangdongmei
/// Date:2012-08-23
/// Argu:
///  科室库存id^货位id^补货标准^补货数量^库存上限^库存下限
///  ^锁定标志^备用货位^强制库存标志^配液打包标志^管理药标志^管理组id^采购标志
/// w ##class(web.DHCSTMHUI.INCItmLoc).Save(^tmplh(34))
ClassMethod Save(ListData As %String) As RtnObj
{
	n (ListData,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Incil=Obj.%Get("incil")
		q:Incil=""
		s IncDesc=$p(^INCI(+Incil,1),"^",2)
		s RtnObj=..Update(ListData)
		q:RtnObj.success<0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 更新科室库存项目信息
/// Author:zhwh
/// Date:2012-07-23
/// Argu:
///  incil  - 科室库存项rowid
///  data - 数据串
ClassMethod Update(ListData As %String) As RtnObj
{
	n (ListData,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Incil=Obj.%Get("incil")
		s incsb=Obj.%Get("incsb")				//货位rowid
		s repLevel=Obj.%Get("repLev")			//补货标准
		s repQty=Obj.%Get("repQty")				//补货数量
		s maxQty=Obj.%Get("maxQty")				//库存上限
		s minQty=Obj.%Get("minQty")				//库存下限
		s lockFlag=Obj.%Get("ChkLockFlag")		//锁定标志
		s spareStkBin=Obj.%Get("spStkBin")		//备用货位
		s manFlag=Obj.%Get("ChkManFlag")		//管理药标志(1,0)
		i manFlag="Y" s manFlag=1
		i manFlag="N" s manFlag=0
		s lmGrp=Obj.%Get("inciLmg")				//管理组rowid
		s planFlag="Y"							//采购标志
		s wareHouse=Obj.%Get("wareHouse")		//供应仓库
		s ZeroStk=Obj.%Get("ZeroStkFlag")		//零库存标志
		s PurBasQty=Obj.%Get("PurBasQty")		//采购基数
		s uomid=$p(^INCI(+Incil,1),"^",10)
		s puruomid=$p(^INCI(+Incil,3),"^",6)
		s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruomid,uomid)
		s:maxQty'="" maxQty=maxQty*fac			//转换成基本单位对应的数量
		s:minQty'="" minQty=minQty*fac
		s:repQty'="" repQty=repQty*fac
		s:repLevel'="" repLevel=repLevel*fac
		s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_ItmLoc",Incil)
		s obj=##class(User.INCItmLoc).%OpenId(Incil)
		s obj.INCILRepLev=repLevel
		s obj.INCILRepQty=repQty
		s obj.INCILMaxQty=maxQty
		s obj.INCILMinQty=minQty
		d obj.INCILINCSBDRSetObjectId(incsb)
		d obj.INCILWareHouseDRSetObjectId(wareHouse)
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-7,"","表插入失败!")  q
		q:RtnObj.success'=0
		s RtnObj=##class(Log).SaveLog("INC_ItmLoc","User.INCItmLoc","科室库存信息",Incil,"","U","",OldJsonStr)
		q:RtnObj.success'=0
		s err=0
		s dINCIL=""
		&sql(select %ID into :dINCIL from dhc_incitmloc where incil_incil_dr=:Incil)
		i dINCIL'="" d
		.s obj1=##class(User.DHCIncItmLoc).%OpenId(dINCIL)
		.s OldJsonStrCh=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_IncItmLoc",dINCIL)
		e  d
		.s obj1=##class(User.DHCIncItmLoc).%New()
		.s obj1.INCILINCILDR=##class(User.INCItmLoc).%OpenId(Incil)
		.s OldJsonStrCh=""
		s obj1.INCILLockFlag=lockFlag
		s obj1.INCILLMGRPDR=##class(User.DHCLocManGrp).%OpenId(lmGrp)
		s obj1.INCILPLANFLAG=planFlag
		s obj1.INCILSpareStkBin=spareStkBin
		s obj1.INCILUSEFLAG=manFlag
		s obj1.INCILZeroStk=ZeroStk
		s obj1.INCILConQty=PurBasQty
		s sc=obj1.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-8,"","表插入失败!")  q
		q:RtnObj.success'=0
		s dINCIL=obj1.%Id()
		s RtnObj=##class(Log).SaveLog("DHC_IncItmLoc","User.DHCIncItmLoc","科室库存附加信息",dINCIL,"","U","",OldJsonStrCh)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// 检索科室库存项目
/// Author：zhwh
/// Date:2012-07-25
/// Argu:
///   Loc           -科室RowId
///   INCI          -库存项RowId
///   SCG           - 类组rowid
///   IncludeNotUse  -包含"不可用"
///   SB             - 货位rowid
///   StkBinDesc     - 货位名称
///   StkQtyType    - 库存类型("-1":负库存,"0":零库存,"1":正库存,"":所有)
///   Lmg           -  管理组RowId
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INCItmLoc","DHCSTLocItm","{""ItmLoc"":""326"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""StkBinReasonId"":"""",""StkGrpId"":""1"",""StockType"":"""",""LocMarReasonId"":"""",""NotUseFlag"":"""",""Incidesc"":"""",""RowId"":"""",""Inci"":""""}")
Query DHCSTLocItm(Params As %String) As Query(ROWSPEC = "incil,inci,code,desc,spec,manf,pUom,pUomDesc,bUom,bUomDesc,maxQty:%Float,minQty:%Float,stkQty:%Float,avaQty:%Float,repQty:%Float,repLev:%Float,incsb,incsbDesc,ChkLockFlag,spStkBin,ChkManFlag,inciLmg,inciLmgDesc,planFlag,NotUseFlag,sp:%Float,wareHouse,wareHouseDesc,ZeroStkFlag,PurBasQty:%Float")
{
}

ClassMethod DHCSTLocItmExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Loc=PJobj.%Get("ItmLoc")
	q:Loc="" $$$OK
	s HospId=PJobj.%Get("gHospId")
	s INCI=PJobj.%Get("Inci")
	s SB=PJobj.%Get("StkBinReasonId")
	S SCG=PJobj.%Get("StkGrpId")
	S IncludeNotUse=PJobj.%Get("NotUseFlag")
	S StkQtyType=PJobj.%Get("StockType")
	s UserId=PJobj.%Get("gUserId")
	s LocMarReasonId=PJobj.%Get("LocMarReasonId")
	s Incidesc=PJobj.%Get("Incidesc")
	s pHospId=..sssHospId(Loc)
	s:pHospId="" pHospId=HospId
	s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),Loc,SCG,pHospId)
	s sql="select %ID incil,"
	_"incil_inci_parref inci,"
	_"incil_incsb_dr incsb,"
	_"incil_incsb_dr->incsb_desc sbDesc,"
	_"incil_inci_parref->inci_code code, "
	_"incil_inci_parref->inci_desc descx,"
	_"incil_availqty avaQty,"
	_"incil_dirtyqty dirtyQty,"
	_"incil_maxqty maxQty,"
	_"incil_minqty minQty,"
	_"incil_repqty repQty,"
	_"incil_replev repLev,"
	_"INCIL_LogQty stkQty,"
	_"INCIL_WareHouse_DR WareHouse,"
	_"INCIL_WareHouse_DR->CTLOC_Desc WareHouseDesc,"
	_"INCIL_INCI_ParRef->INCI_NotUseFlag NotUseFlag,"
	_"INCIL_INCI_ParRef->INCI_CTUOM_Purch_DR pUom,"
	_"INCIL_INCI_ParRef->INCI_CTUOM_Purch_DR->CTUOM_Desc pUomDesc,"
	_"INCIL_INCI_ParRef->INCI_CTUOM_DR bUom,"
	_"INCIL_INCI_ParRef->INCI_CTUOM_DR->CTUOM_Desc bUomDesc"
	_" from inc_itmloc where incil_ctloc_dr="_Loc
	i INCI'="" d
	.s sql=sql_" and incil_inci_parref="_INCI
	i SB'="" d
	.s sql=sql_" and incil_incsb_dr="_SB
	s xrs=##class(%ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s incil=xrs.Data("incil")
		s inci=xrs.Data("inci")
		s grpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s inciScg=$P(grpInfo,"^",5)
		s scgType=$P(grpInfo,"^",3)
		continue:scgType'=..sssCode()
		continue:(SCG'="")&&(("^"_SCG_"^")'[("^"_inciScg_"^"))
		s inciNotUse=xrs.Data("NotUseFlag")
		i inciNotUse="" s inciNotUse="N"
		i IncludeNotUse'="Y" continue:inciNotUse="Y"  //不包含"不可用"
		s incsb=xrs.Data("incsb")
		continue:(SB'="")&&(incsb'=SB)
		s incsbDesc=xrs.Data("sbDesc")
		s code=xrs.Data("code")
		s desc=xrs.Data("descx")
		continue:(Incidesc'="")&&(desc'[Incidesc)
		s avaQty=xrs.Data("avaQty")
		s dirtyQty=xrs.Data("dirtyQty")
		s avaQty=avaQty-dirtyQty  ;可用库存减去占用数
		s maxQty=xrs.Data("maxQty")
		s minQty=xrs.Data("minQty")
		s repQty=xrs.Data("repQty")
		s repLev=xrs.Data("repLev")
		s wareHouse=xrs.Data("WareHouse")
		s wareHouseDesc=xrs.Data("WareHouseDesc")
		i wareHouseDesc'="" s wareHouseDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(wareHouseDesc)
		s stkQty=xrs.Data("stkQty")
		s pUom=xrs.Data("pUom")
		s pUomDesc=xrs.Data("pUomDesc")
		s bUom=xrs.Data("bUom")
		s bUomDesc=xrs.Data("bUomDesc")
		s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
		i +fac=0 s fac=1
		//换算为入库单位
		s:avaQty'="" avaQty=avaQty/fac  
		s:maxQty'="" maxQty=maxQty/fac
		s:minQty'="" minQty=minQty/fac
		s:repQty'="" repQty=repQty/fac
		s:repLev'="" repLev=repLev/fac
		s:stkQty'="" stkQty=stkQty/fac
		s inciLmg ="",lockFlag="",spStkBin="",inciLmgDesc="",planFlag="",ZeroStk="",PurBasQty="",ChkManFlag=""
		&sql(select INCIL_LockFlag,INCIL_SpareStkBin,INCIL_USEFLAG,INCIL_LMGRP_DR,INCIL_LMGRP_DR->LMG_Desc,INCIL_PlanFlag,INCIL_ZeroStk,INCIL_ConQty 
		into :ChkLockFlag,:spStkBin,:ChkManFlag,:inciLmg,:inciLmgDesc,:planFlag,:ZeroStkFlag,:PurBasQty From dhc_incitmloc where INCIL_INCIL_dr=:incil)
		continue:(LocMarReasonId'="")&&(inciLmg="")
		continue:(LocMarReasonId'="")&&(inciLmg'="")&&((","_LocMarReasonId_",")'[(","_inciLmg_","))
		i ChkManFlag=1 s ChkManFlag="Y"
		i ChkManFlag=0 s ChkManFlag="N"
		i StkQtyType="-1" continue:stkQty'<0	//负库存
		i StkQtyType="0" continue:stkQty'=0		// 0库存
		i StkQtyType="1" continue:stkQty'>0		//正库存
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3)
		s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,pUom,pHospId)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(incil,inci,code,desc,spec,manf,pUom,pUomDesc,bUom,bUomDesc,maxQty,minQty,stkQty,avaQty,repQty,repLev,incsb,incsbDesc,ChkLockFlag,spStkBin,ChkManFlag,inciLmg,inciLmgDesc,planFlag,inciNotUse,sp,wareHouse,wareHouseDesc,ZeroStkFlag,PurBasQty)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:发送科室库存上下限信息到平台
/// Creator:    tsr
/// CreatDate:  2019-05-29
ClassMethod SendLocLimit(LocId As %String) As %String
{
	n (LocId)
	q:LocId="" -1
	s err=""
	s del="^"
	s cnt=$l(LocId,del)
	f i=1:1:cnt  d
	.s tmpLocId=$p(LocId,del,i)
	.s ret=##class(web.DHCSTMHUI.ServiceForSCI).getHopLocIncQty(tmpLocId)
	.i +ret'=0 d
	..s err=err_";"_ret
	q err
}

ClassMethod jsAutoSetloclimqty(Params) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..AutoSetloclimqty(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod AutoSetloclimqty(Params) As %String
{
	s inputObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=inputObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","库存项入参解析失败!")
	s loc=inputObj.%Get("FItmLoc")
	s startDate=inputObj.%Get("StartDate")
	s endDate=inputObj.%Get("EndDate")
	s maxlimt=inputObj.%Get("maxlimts")
	s minlimt=inputObj.%Get("minlimts")
	s stkgrp=inputObj.%Get("FStkGrpId")
	s TransType=inputObj.%Get("TransType")
	s:startDate'="" startDate=$zdh(startDate,3)
	s:endDate'="" endDate=$zdh(endDate,3)
	
	s pid=..NewPid()
	s n=0
	k ^TMP("web.DHCSTMHUI.INCItmLoc","AutoSetloclimqty",pid)
	s inci=""
	f  s inci=$o(^INCI("IL_LOC",loc,inci)) q:inci=""  d
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.s Scg=$p(StkGrpInfo,"^",5)
	.q:ScgType'=..sssCode()
	.q:(stkgrp'="")&(stkgrp'=Scg)
	.s transqty=..TotalItmtransqty(inci,startDate,endDate,loc,TransType)
	.q:transqty=0
	.s:transqty<0 transqty=-transqty
	.s maxqty=maxlimt*transqty
	.s minqty=minlimt*transqty
	.s n=n+1
	.s ^TMP("web.DHCSTMHUI.INCItmLoc","AutoSetloclimqty",pid,n)=inci_"^"_loc_"^"_maxqty_"^"_minqty
	s updflag=0
	
	s index=""
	f  s index=$o(^TMP("web.DHCSTMHUI.INCItmLoc","AutoSetloclimqty",pid,index)) q:index=""  d
	.s datastr=^TMP("web.DHCSTMHUI.INCItmLoc","AutoSetloclimqty",pid,index)
	.s inci=$p(datastr,"^",1)
	.s loc=$p(datastr,"^",2)
	.s maxqty=$p(datastr,"^",3)
	.s minqty=$p(datastr,"^",4)
	.
	.s ch=$o(^INCI("IL_LOC",loc,inci,""))
	.q:ch=""
	.s incil=inci_"||"_ch
	.s updflag=..Updlimit(incil,maxqty,minqty)
	
	k ^TMP("web.DHCSTMHUI.INCItmLoc","AutoSetloclimqty",pid)
	i updflag'=0 q RtnObj.Err(-4,"","生成上下限失败！")
	q RtnObj
}

ClassMethod Updlimit(incil As %String, maxQty As %String, minQty As %String) As %String
{
	s obj=##class(User.INCItmLoc).%OpenId(incil,0)	
	s obj.INCILMaxQty=maxQty
	s obj.INCILMinQty=minQty
	s sc=obj.%Save()
	if $$$ISERR(sc) q -1
	q 0
}

ClassMethod TotalItmtransqty(inci As %String, StartDate As %String, EndDate As %String, loc As %String, TransType) As %String
{
	n (inci,StartDate,EndDate,loc,TransType)
	s ch=$o(^INCI("IL_LOC",loc,inci,""))
	q:ch="" 0
	s incil=inci_"||"_ch
	s uom=$p(^INCI(inci,1),"^",10) 
	s types=TransType
	s totalQty=0,trqty=0
	f i=1:1:$l(types,",") d
	.s trType=$p(types,",",i)
	.f dd=StartDate:1:EndDate  d
	..s INTR=""
	..f  s INTR=$o(^DHCINTR(0,"ILTYPEDATE",incil,trType,dd,INTR)) q:INTR=""  d		; get INTR
	...s transom=$p(^DHCINTR(INTR),"^",10)
	...s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(transom,uom)  ; factor 
	...s trqty=$p(^DHCINTR(INTR),"^",6)		;dispensing qty
	...s trqty=trqty*fac
	...s totalQty=$g(totalQty)+$g(trqty)
	q $g(totalQty)
}

/// 根据科室批次ID获取货位码
/// 20220829 lihui
/// w ##class(web.DHCSTMHUI.INCItmLoc).Selectforprint("2||3")
ClassMethod Selectforprint(incil As %String) As %String
{
	n (incil)
	s ^tmpli("incil")=incil
	q:incil="" ""
	
	s itmlocinfo=^INCI(+incil,"IL",$p(incil,"||",2))
	s inci=+incil
	q:'$d(^INCI(inci)) ""
	s incidesc=$p(^INCI(inci,1),"^",2) ;物资名称
	s incicode=$p(^INCI(inci,1),"^",1) ;物资代码
	s locid=$p(itmlocinfo,"^",1)
	s locdesc=$p(^CTLOC(locid),"^",2)
	s StockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,locid,+$h)
	s PurUomId=$p(^INCI(inci,3),"^",6)
	s BUomId=$p(^INCI(inci,1),"^",10)
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s PurStockQty = StockQty / Fac
	s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(locid,inci)
	s IncsbDesc=$p(IncsbDesc,"^",1)
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci) ;规格
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci) ;品牌
	s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci) ;型号
	s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(inci),"^",2) ;厂家
	s (MaxQty,MinQty)=0
	i locid'="" d
	.s chl=$o(^INCI("IL_LOC",locid,inci,""))
	.i +chl>0 d
	..s locitminfo=^INCI(inci,"IL",chl)
	..s MaxQty=$p(locitminfo,"^",7)
	..s MinQty=$p(locitminfo,"^",4) 
	
	s Nincidesc1=$e(incidesc,1,16)
	s Nincidesc2=$e(incidesc,17,$l(incidesc))
	s Nincidesc=Nincidesc1_$c(10)_Nincidesc2
	
	s Nspec1=$e(spec,1,16)
	s Nspec2=$e(spec,17,$l(spec))
	s Nspec=Nspec1_$c(10)_Nspec2
	s type="H"
	s tmpincil=$tr(incil,"||","A")
	s BarcodeStr="{"_$c(34)_"code"_$c(34)_":"_$c(34)_incicode_$c(34)_","_$c(34)_"type"_$c(34)_":"_$c(34)_type_$c(34)_"}"
	s Data1=incidesc_"^"_incicode_"^"_PurchCTUomDesc_"^"_spec_"^"_Brand_"^"_BarcodeStr_"^"_Nincidesc_"^"_Nspec_"^"_Model_"^"_Manf
	s Data2=MinQty_"^"_MaxQty_"^"_tmpincil
	s Data=Data1_"^"_Data2
	s Title="IncDesc^IncCode^PurchCTUomDesc^spec^Brand^BarcodeStr^Nincidesc^Nspec^Model^Manf^MinQty^MaxQty^tmpincil"
	s PrintData=##class(web.DHCSTMHUI.Common.UtilCommon).GetXmlPrintData(Title,Data)
	q PrintData
}

}
