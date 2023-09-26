Import sqluser

/// Descript: 转移\医嘱台账相关
/// Creater: ZhangDongmei
/// CreateDate: 2012-11-12
Class web.DHCSTMHUI.TKPYtransStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.TKPYtransStat","QueryDetail","{""PhaLoc"":""392"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2"",""RecLoc"":""8"",""StartDate"":""2018-10-01"",""EndDate"":""2018-11-12"",""Ways"":"""",""Vendor"":"""",""SourceOfFund"":"""",""ScgStk"":"""",""StkCat"":"""",""Manf"":"""",""InsuType"":"""",""INFOMT"":"""",""OperateOutType"":"""",""PublicBidding"":"""",""INFOPBLevel"":"""",""HvFlag"":"""",""ChargeFlag"":"""",""INFOImportFlag"":"""",""Inci"":"""",""StartTime"":"""",""EndTime"":"""",""InciDesc"":"""",""MinSp"":"""",""MaxSp"":"""",""MinRp"":"""",""MaxRp"":"""",""InvNo"":""""}")
Query QueryDetail(Params As %String(MAXLEN=500)) As Query(ROWSPEC = "TrNo,TrDate,InciCode,InciDesc,PurUomDesc,RecLocDesc,Rp:%Float,Sp:%Float,BatSp:%Float,BatNo,ExpireDate,Manf,FromLocDesc,InsuType,TrQty:%Float,RpAmt:%Float,SpAmt:%Float,BUomDesc,RecLocGrp,StkCat,StkGrp,TrType,Incib,TmpPbLevel,spType,TmpBaFlag,TmpPbFlag,Spec,LocGrpItm,vendor,VenName,IntrId:%Integer,TrRemarks,HVBarCode,IntrUser") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("PhaLoc")
	s RecLoc=PJObj.%Get("RecLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s TransferFlag=PJObj.%Get("Ways")
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:StartDate="" $$$OK			//必选条件
	q:EndDate="" $$$OK
	q:LocId="" $$$OK
	;s StartDate=$zdh(StartDate,3)
	;s EndDate=$zdh(EndDate,3)
	s TKPid=..NewPid()
	s PYPid=..NewPid()
	k ^TMPDHCOUTSTAT(TKPid,"OUTDETAIL")
	k ^TMPDHCOUTSTAT(PYPid,"OUTDETAIL")
	k ^TMPDHCOUTSTAT(TKPid,"TBarcode")

	i TransferFlag=1 d		//只统计TK台帐
	.d ..GetTKDetail(TKPid,Params)
	.d OutputRowOut(TKPid)

	i TransferFlag=2 d		//只统计医嘱台账
	.d ..GetPYDetail(PYPid,Params)
	.d OutputRowOut(PYPid)

	i TransferFlag'=1,TransferFlag'=2 d
	.d ..GetTKDetail(TKPid,Params)
	.d OutputRowOut(TKPid)
	.d ..GetPYDetail(PYPid,Params)
	.d OutputRowPYFH(PYPid)
	;
	k ^TMPDHCOUTSTAT(TKPid,"OUTDETAIL")
	k ^TMPDHCOUTSTAT(PYPid,"OUTDETAIL")
	k ^TMPDHCOUTSTAT(TKPid,"TBarcode")
	Quit $$$OK

OutputRowOut(qPid)
	;按代数值输出
	s num=0
	f  s num=$o(^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num))  q:num=""  d
	.s data=^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num)
	.s TrNo=$p(data,"^",1)
	.s TrDate=$p(data,"^",2)
	.s InciCode=$p(data,"^",3)
	.s InciDesc=$p(data,"^",4)
	.s PurUomDesc=$p(data,"^",5)
	.s LocDesc=$p(data,"^",6)
	.s Rp=$p(data,"^",7)
	.s Sp=$p(data,"^",8)
	.s BatSp=$p(data,"^",9)
	.s BatNo=$p(data,"^",10)
	.s ExpireDate=$p(data,"^",11)
	.s Manf=$p(data,"^",12)
	.s FromLocDesc=$p(data,"^",13)
	.s InsuType=$p(data,"^",14)
	.s TrQty=$p(data,"^",15)
	.s RpAmt=$p(data,"^",16)
	.s SpAmt=$p(data,"^",17)
	.s BUomDesc=$p(data,"^",18)
	.s LocGrp=$p(data,"^",19)
	.s StkCat=$p(data,"^",20)
	.s StkGrp=$p(data,"^",21)
	.s Type=$p(data,"^",22)
	.s Incib=$p(data,"^",23)
	.s TmpPbLevel=$p(data,"^",24)
	.s spType=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s TmpPbFlag=$p(data,"^",27)
	.s LocGrpItm=$p(data,"^",28)
	.s vendor=$p(data,"^",29)
	.s VenName=$p(data,"^",30)
	.s Spec=$p(data,"^",31)
	.s IntrId=$p(data,"^",32)
	.s TrRemarks=$p(data,"^",33)
	.s HVBarCode=$p(data,"^",34)
	.s IntrUser=$p(data,"^",35)
	.;获取出库的条码,特殊情形下仅按出库数据进行过滤(见OutputRowPYFH)
	.i (HVBarCode'="")&&(Type="T") s ^TMPDHCOUTSTAT(TKPid,"TBarcode",HVBarCode)=""
	.s Data=$lb(TrNo,TrDate,InciCode,InciDesc,PurUomDesc,LocDesc,Rp,Sp,BatSp,BatNo,ExpireDate,Manf,FromLocDesc,InsuType,TrQty,RpAmt,SpAmt,BUomDesc,LocGrp,StkCat,StkGrp,Type,Incib,TmpPbLevel,spType,TmpBaFlag,TmpPbFlag,Spec,LocGrpItm,vendor,VenName,IntrId,TrRemarks,HVBarCode,IntrUser)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.
	
	q
	
OutputRowPYFH(qPid)
	;按代数值输出
	s num=0
	f  s num=$o(^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num))  q:num=""  d
	.s data=^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num)
	.s TrNo=$p(data,"^",1)
	.s TrDate=$p(data,"^",2)
	.s InciCode=$p(data,"^",3)
	.s InciDesc=$p(data,"^",4)
	.s PurUomDesc=$p(data,"^",5)
	.s LocDesc=$p(data,"^",6)
	.s Rp=$p(data,"^",7)
	.s Sp=$p(data,"^",8)
	.s BatSp=$p(data,"^",9)
	.s BatNo=$p(data,"^",10)
	.s ExpireDate=$p(data,"^",11)
	.s Manf=$p(data,"^",12)
	.s FromLocDesc=$p(data,"^",13)
	.s InsuType=$p(data,"^",14)
	.s TrQty=$p(data,"^",15)
	.s RpAmt=$p(data,"^",16)
	.s SpAmt=$p(data,"^",17)
	.s BUomDesc=$p(data,"^",18)
	.s LocGrp=$p(data,"^",19)
	.s StkCat=$p(data,"^",20)
	.s StkGrp=$p(data,"^",21)
	.s Type=$p(data,"^",22)
	.s Incib=$p(data,"^",23)
	.s TmpPbLevel=$p(data,"^",24)
	.s spType=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s TmpPbFlag=$p(data,"^",27)
	.s LocGrpItm=$p(data,"^",28)
	.s vendor=$p(data,"^",29)
	.s VenName=$p(data,"^",30)
	.s Spec=$p(data,"^",31)
	.s IntrId=$p(data,"^",32)
	.s TrRemarks=$p(data,"^",33)
	.s HVBarCode=$p(data,"^",34)
	.s IntrUser=$p(data,"^",35)
	.;仅按出库统计的过滤
	.q:(TransferFlag=3)&&(HVBarCode'="")&&'$d(^TMPDHCOUTSTAT(TKPid,"TBarcode",HVBarCode))
	.s Data=$lb(TrNo,TrDate,InciCode,InciDesc,PurUomDesc,LocDesc,Rp,Sp,BatSp,BatNo,ExpireDate,Manf,FromLocDesc,InsuType,TrQty,RpAmt,SpAmt,BUomDesc,LocGrp,StkCat,StkGrp,Type,Incib,TmpPbLevel,spType,TmpBaFlag,TmpPbFlag,Spec,LocGrpItm,vendor,VenName,IntrId,TrRemarks,HVBarCode,IntrUser)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.
	
	q
}

/// Descript:	查询转出明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-12
/// Table:DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂家id^剂型^医保类型^
/// 管制分类^供应商id^出库类型^最低售价^最高售价^最低进价^最高进价^接收科室id^
/// 开始时间^截止时间^科室范围
/// Output:转移明细
/// Return：	
ClassMethod GetTKDetail(pid, Params) As %Library.String
{
	n (pid,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	;
	s LocId=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s StkGrpId=PJObj.%Get("ScgStk")
	s StkCatId=PJObj.%Get("StkCat")
	s InciRowid=PJObj.%Get("Inci")
	s MarkType=PJObj.%Get("INFOMT")			//定价类型
	s ImpFlag=PJObj.%Get("INFOImportFlag")	//进口标志
	s PbFlag=PJObj.%Get("PublicBidding")	//招标标志
	s PbLevel=PJObj.%Get("INFOPBLevel")		//招标级别
	s ManfId=PJObj.%Get("Manf")
	s BatNo=PJObj.%Get("BatNo")				//生产批号
	s InsuType=PJObj.%Get("InsuType")
	s VendorId=PJObj.%Get("Vendor")
	s OutType=PJObj.%Get("OperateOutType")	//出库类型
	s SpFrom=PJObj.%Get("MinSp")
	s SpTo=PJObj.%Get("MaxSp")
	s RpFrom=PJObj.%Get("MinRp")
	s RpTo=PJObj.%Get("MaxRp")
	s RecLocId=PJObj.%Get("RecLoc")
	s HvFlag=PJObj.%Get("HvFlag")
	s StartTime=PJObj.%Get("StartTime")
	s EndTime=PJObj.%Get("EndTime")
	s ChargeFlag=HvFlag=PJObj.%Get("ChargeFlag")
	s:StartTime'="" StartTime=..TH2L(StartTime)
	s:EndTime'="" EndTime=..TH2L(EndTime)
	s:StartTime="86399" StartTime=""
	s:EndTime="86399" EndTime=""
	s InvNo=PJObj.%Get("InvNo")
	
	;s TransRange=$p(Others,"^",26)		;科室范围(0:全部,1:科室组内,2:科室组外)
	s pHospId=..sssHospId(LocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),LocId,StkGrpId,pHospId)
	s LocGrpItems="^"_LocId_"^"
	s LocGrp=","_LocId_","

	k InitiInciInfo,InitiInclbInfo,InitToLocInfo	//"数组",记录库存项相关数据
	s i=0
	s inciid=0
	f  s inciid=$o(^INCI(inciid)) q:inciid=""  d
	.s InLocStr=..CheckIncil(inciid,LocId)	;判断是否在这几个科室内有库存
	.q:InLocStr=0
	.
	.s TmpTrDate=$o(^DHCINTR(0,"INCI",inciid,StartDate-1))
	.q:(TmpTrDate="")||(TmpTrDate>EndDate)	;时间段内没有台帐的,过滤
	.
	.s (InciCode,InciDesc,ChargeFlag,Supervision,InsuId,ofcode,TmpStkGrpId,StkGrpDesc,TmpIncCatId,incscdesc,HV,spID,spType,TmpPbFlagValue,TmpPbFlag,BUomId,PurUomId,PurUomDesc,Fac2,Spec)=""
	.i '$d(InitiInciInfo(inciid)) d
	..s InciCode=$p(^INCI(inciid,1),"^",1)
	..s InciDesc=$p(^INCI(inciid,1),"^",2)
	..s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(inciid)
	..s Supervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(inciid)
	..s InsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInsuCat(inciid)
	..s InsuId=$p(InsuInfo,"^",1)
	..s ofcode=$p(InsuInfo,"^",3)
	..s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
	..s incscdesc=""
	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
	..s hv=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inciid)
	..s spTypeInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(inciid)
	..s spID=$p(spTypeInfo,"^",1)
	..s spType=$p(spTypeInfo,"^",2)
	..s TmpImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(inciid)
	..s TmpPbFlagValue=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(inciid)
	..s TmpPbFlag=""
	..i TmpPbFlagValue="Y" s TmpPbFlag="招标"
	..i TmpPbFlagValue="N" s TmpPbFlag="非招标"
	..s TmpPbLevel=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
	..s TmpBaFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid)		;备案
	..s:TmpBaFlag="Y" TmpBaFlag=1
	..s:TmpBaFlag="N" TmpBaFlag=0
	..
	..s BUomId=$p(^INCI(inciid,1),"^",10)
	..s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s PurUomId=$p(^INCI(inciid,3),"^",6)
	..s PurUomDesc=""
	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inciid)
	..
	..s InitiInciInfo(inciid)=InciCode_"^"_InciDesc_"^"_ChargeFlag_"^"_Supervision_"^"_InsuId_"^"_ofcode_"^"_TmpStkGrpId_"^"_StkGrpDesc_"^"_TmpIncCatId_"^"_incscdesc_"^"_hv_"^"_spID_"^"_spType_"^"_TmpPbFlagValue_"^"_TmpPbFlag_"^"_BUomId_"^"_PurUomId_"^"_PurUomDesc_"^"_Fac2_"^"_Spec
	.e  d
	..s InciInfo=InitiInciInfo(inciid)
	..s incicode=$p(InciInfo,"^",1)
	..s incidesc=$p(InciInfo,"^",2)
	..s ChargeFlag=$p(InciInfo,"^",3)
	..s Supervision=$p(InciInfo,"^",4)
	..s InsuId=$p(InciInfo,"^",5)
	..s ofcode=$p(InciInfo,"^",6)
	..s TmpStkGrpId=$p(InciInfo,"^",7)
	..s StkGrpDesc=$p(InciInfo,"^",8)
	..s TmpIncCatId=$p(InciInfo,"^",9)
	..s incscdesc=$p(InciInfo,"^",10)
	..s hv=$p(InciInfo,"^",11)
	..s spID=$p(InciInfo,"^",12)
	..s spType=$p(InciInfo,"^",13)
	..s TmpPbFlagValue=$p(InciInfo,"^",14)
	..s TmpPbFlag=$p(InciInfo,"^",15)
	..s BUomId=$p(InciInfo,"^",16)
	..s PurUomId=$p(InciInfo,"^",17)
	..s PurUomDesc=$p(InciInfo,"^",18)
	..s Fac2=$p(InciInfo,"^",19)
	..s Spec=$p(InciInfo,"^",20)
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)		;类组不符
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
	.q:(HvFlag'="")&&(HvFlag'=hv)
	.q:(MarkType'="")&&(spID'=MarkType)			;定价类型
	.q:(ImpFlag'="")&&(TmpImpFlag'=ImpFlag)
	.q:(InsuType'="")&&(InsuId'=InsuType)			;医保类型
	.q:(PbFlag'="")&&(TmpPbFlagValue'=PbFlag)		;是否招标
	.q:(PbLevel'="")&&(TmpPbLevel'=PbLevel) 		;招标级别
	.
	.f date=StartDate:1:EndDate d
	..s intrid=""
	..f  s intrid=$o(^DHCINTR(0,"INCI",inciid,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...
	...s TrType=$p(^DHCINTR(intrid),"^",1)
	...q:(TrType'="T")&&(TrType'="K")			;过滤非TK台帐
	...s trTime=$p(^DHCINTR(intrid),"^",3)
	...i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
	...i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
	...
	...s TrDate=..DL2H(date)
	...s trTime=..TL2H(trTime)
	...s TrDateTime=TrDate_" "_trTime
	...s IntrUser=$p(^DHCINTR(intrid),"^",11)
	...s IntrUser=$s(IntrUser'="":$p($g(^SSU("SSUSR",IntrUser)),"^",2),1:"")
	...
	...s pointer=$p(^DHCINTR(intrid),"^",9)
	...s MainId=+pointer
	...s Chl=$p(pointer,"||",2)
	...q:'$d(^DHCINIT(MainId))
	...q:'$d(^DHCINIT(MainId,"ITI",Chl))
	...
	...i TrType="T" d
	....s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
	...e  d
	....s FromLocId=$p(^DHCINIT(MainId),"^",6)
	...;q:FromLocId'=LocId   ;非统计科室
	...q:'##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(LocId,FromLocId,",")
	...
	...i TrType="T" d
	....s ToLocId=$p(^DHCINIT(MainId),"^",6)	;接收科室
	...e  d
	....s ToLocId=$p(^DHCINIT(MainId),"^",5)
	...q:(ToLocId'=RecLocId)					;非接收科室
	...;q:(TrType="K")&&(ToLocId'=RecLocId)
	...
	...s FromLocDesc=$p($g(^CTLOC(FromLocId)),"^",2)
	...i $f(FromLocDesc,"-") s FromLocDesc=$p(FromLocDesc,"-",2)
	...s ToLocDesc=""
	...s:ToLocId'="" ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
	...i $f(ToLocDesc,"-") s ToLocDesc=$p(ToLocDesc,"-",2)
	...s tmpouttype=$p(^DHCINIT(MainId),"^",20)
	...q:(OutType'="")&(tmpouttype'=OutType)			;按出库类型过滤
	...s TrNo=$p(^DHCINIT(MainId),"^",1)
	...
	...s inclbid=$p(^DHCINTR(intrid),"^",7)
	...q:inclbid=""
	...s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	...
	...s inciid=$p(inclbid,"||",1)
	...q:(InciRowid'="")&(InciRowid'=inciid)			;库存项不符
	...q:'$d(^INCI(inciid,1))
	...q:'$d(^INCI(inciid,2))
	...q:'$d(^INCI(inciid,3))
	...
	...i '$d(InitToLocInfo(ToLocId)) d
	....s ToLocGrp=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocItmGrp(ToLocId)
	....s:ToLocGrp="" ToLocGrp="不详"
	....s LocGrpItm=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocGrpItm(ToLocId)
	....s:LocGrpItm="" LocGrpItm="不详"
	....s InLocGrpItems=$s(LocGrpItems[("^"_ToLocId_"^"):"Y",1:"N")
	....s InitToLocInfo(ToLocId)=ToLocGrp_"^"_LocGrpItm_"^"_InLocGrpItems
	...e  d
	....s ToLocGrp=$p(InitToLocInfo(ToLocId),"^",1)
	....s LocGrpItm=$p(InitToLocInfo(ToLocId),"^",2)
	....s InLocGrpItems=$p(InitToLocInfo(ToLocId),"^",3)
	...;q:(TransRange=1)&&(InLocGrpItems="N")		;过滤组外部分
	...;q:(TransRange=2)&&(InLocGrpItems="Y")		;过滤组内部分
	...
	...///Inclb部分
	...s (ApcvmId,VenName,gmanfid,Manf,TmpBatNo,ExpireDate)=""
	...i '$d(InitiInclbInfo(inclbid)) d
	....s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclbid,date)
	....s ApcvmId=$p(VenInfo,"^",1)
	....s VenName=$p(VenInfo,"^",2)
	....s manfinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
	....s gmanfid=$p(manfinfo,"^",1)
	....s Manf=$p(manfinfo,"^",2)
	....s TmpBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclbid)
	....s TmpBatNo=$p(TmpBat,"^",1)
	....s ExpireDate=$p(TmpBat,"^",2)
	....s InitiInclbInfo(inclbid)=ApcvmId_"^"_VenName_"^"_gmanfid_"^"_Manf_"^"_TmpBatNo_"^"_ExpireDate
	...e  d
	....s inclbInfo=InitiInclbInfo(inclbid)
	....s ApcvmId=$p(inclbInfo,"^",1)
	....s VenName=$p(inclbInfo,"^",2)
	....s gmanfid=$p(inclbInfo,"^",3)
	....s Manf=$p(inclbInfo,"^",4)
	....s TmpBatNo=$p(inclbInfo,"^",5)
	....s ExpireDate=$p(inclbInfo,"^",6)
	...q:(VendorId'="")&(ApcvmId'=VendorId)				;按供应商过滤
	...q:(ManfId'="")&(gmanfid'=ManfId)					;生产厂家
	...q:(BatNo'="")&(TmpBatNo'=BatNo)
	...
	...s InitiInfo=^DHCINIT(MainId,"ITI",Chl)
	...s TrUom=$p(InitiInfo,"^",7)
	...s sp=$p(InitiInfo,"^",17)		;售价
	...s rp=$p(InitiInfo,"^",15)		;进价
	...s BatSp=$p(InitiInfo,"^",21)		;批次售价
	...s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...
	...s sp=sp/Fac1*Fac2
	...s rp=rp/Fac1*Fac2
	...s BatSp=BatSp/Fac1*Fac2
	...q:(SpFrom'="")&&(sp<+SpFrom)      ;低于售价范围最小值
	...q:(SpTo'="")&&(sp>+SpTo)
	...q:(RpFrom'="")&&(rp<+RpFrom)
	...q:(RpTo'="")&&(rp>+RpTo)
	...
	...s TrQty=$p(InitiInfo,"^",1)
	...s TrQty=TrQty*Fac1/Fac2
	...s RpAmt=$p(InitiInfo,"^",16)
	...s SpAmt=$p(InitiInfo,"^",18)
	...s BatSpAmt=$p(InitiInfo,"^",22)
	...i TrType="K" d
	....s TrQty=-TrQty
	....s RpAmt=-RpAmt
	....s SpAmt=-SpAmt
	....s BatSpAmt=-BatSpAmt
	...
	...s TrRemarks=""
	...s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,pointer)
	...s i=i+1
	...;
	...s Data1=TrNo_"^"_TrDateTime_"^"_InciCode_"^"_InciDesc_"^"_PurUomDesc_"^"_ToLocDesc_"^"_rp_"^"_sp_"^"_BatSp_"^"_TmpBatNo
	...s Data2=ExpireDate_"^"_Manf_"^"_FromLocDesc_"^"_ofcode_"^"_TrQty_"^"_RpAmt_"^"_SpAmt_"^"_BUomDesc_"^"_ToLocGrp_"^"_incscdesc
	...s Data3=StkGrpDesc_"^"_TrType_"^"_incib_"^"_TmpPbLevel_"^"_spType_"^"_TmpBaFlag_"^"_TmpPbFlag_"^"_LocGrpItm_"^"_ApcvmId_"^"_VenName
	...s Data4=Spec_"^"_intrid_"^"_TrRemarks_"^"_HVBarCode_"^"_IntrUser
	...s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	...s ^TMPDHCOUTSTAT(pid,"OUTDETAIL",i)=Data

	q pid
}

/// Descript:	查询转入明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-12
/// Table:DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂家id^剂型^医保类型^
/// 管制分类^供应商id^出库类型^最低售价^最高售价^最低进价^最高进价^接收科室id^
/// 开始时间^截止时间^科室范围
/// Output:转移明细
/// Return：	
ClassMethod GetPYDetail(pid, Params) As %Library.String
{
	n (pid, Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	;
	s LocId=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s StkGrpId=PJObj.%Get("ScgStk")
	s StkCatId=PJObj.%Get("StkCat")
	s InciRowid=PJObj.%Get("Inci")
	s MarkType=PJObj.%Get("INFOMT")			//定价类型
	s ImpFlag=PJObj.%Get("INFOImportFlag")	//进口标志
	s PbFlag=PJObj.%Get("PublicBidding")	//招标标志
	s PbLevel=PJObj.%Get("INFOPBLevel")		//招标级别
	s ManfId=PJObj.%Get("Manf")
	s BatNo=PJObj.%Get("BatNo")				//生产批号
	;s FormDesc=PJObj.%Get("Loc")
	s InsuType=PJObj.%Get("InsuType")
	s VendorId=PJObj.%Get("Vendor")
	s OutType=PJObj.%Get("OperateOutType")	//出库类型
	s SpFrom=PJObj.%Get("MinSp")
	s SpTo=PJObj.%Get("MaxSp")
	s RpFrom=PJObj.%Get("MinRp")
	s RpTo=PJObj.%Get("MaxRp")
	s RecLocId=PJObj.%Get("RecLoc")
	s HvFlag=PJObj.%Get("HvFlag")
	s StartTime=PJObj.%Get("StartTime")
	s EndTime=PJObj.%Get("EndTime")
	s ChargeFlag=HvFlag=PJObj.%Get("ChargeFlag")
	s:StartTime'="" StartTime=..TH2L(StartTime)
	s:EndTime'="" EndTime=..TH2L(EndTime)
	s:StartTime="86399" StartTime=""
	s:EndTime="86399" EndTime=""
	s InvNo=PJObj.%Get("InvNo")
	;s TransRange=$p(Others,"^",26)		;科室范围(0:全部,1:科室组内,2:科室组外)
	s pHospId=..sssHospId(LocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),LocId,StkGrpId,pHospId)
	s LocGrpItems="^"_LocId_"^"
	s LocGrp=","_LocId_","

	k InitiInciInfo,InitiInclbInfo,InitToLocInfo	//"数组",记录库存项相关数据
	s i=0
	s inciid=0
	f  s inciid=$o(^INCI(inciid)) q:inciid=""  d
	.s InLocStr=..CheckIncil(inciid,LocId)	;判断是否在这几个科室内有库存
	.q:InLocStr=0
	.
	.s tmpTrDate=$o(^DHCINTR(0,"INCI",inciid,StartDate-1))
	.q:(tmpTrDate="")||(tmpTrDate>EndDate)	;时间段内没有台帐的,过滤
	.
	.///Inci部分
	.s (incicode,incidesc,ChargeFlag,Supervision,InsuId,ofcode,TmpStkGrpId,StkGrpDesc,TmpIncCatId,incscdesc,hv,spID,spType,TmpPbFlagValue,TmpPbFlag,BUomId,PurUomId,PurUomDesc,Fac2,Spec)=""
	.i '$d(InitiInciInfo(inciid)) d
	..s incicode=$p(^INCI(inciid,1),"^",1)
	..s incidesc=$p(^INCI(inciid,1),"^",2)
	..s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(inciid)
	..s Supervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(inciid)
	..s InsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInsuCat(inciid)
	..s InsuId=$p(InsuInfo,"^",1)
	..s ofcode=$p(InsuInfo,"^",3)
	..s tmpstkgrp=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
	..s incscdesc=""
	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
	..s hv=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inciid)
	..s spTypeInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(inciid)
	..s spID=$p(spTypeInfo,"^",1)
	..s spType=$p(spTypeInfo,"^",2)
	..s TmpImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(inciid)
	..s TmpPbFlagValue=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(inciid)
	..s TmpPbFlag=""
	..i TmpPbFlagValue="Y" s TmpPbFlag="招标"
	..i TmpPbFlagValue="N" s TmpPbFlag="非招标"
	..s TmpPbLevel=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
	..s TmpBaFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid)		;备案
	..s:TmpBaFlag="Y" TmpBaFlag=1
	..s:TmpBaFlag="N" TmpBaFlag=0
	..
	..s BUomId=$p(^INCI(inciid,1),"^",10)
	..s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s PurUomId=$p(^INCI(inciid,3),"^",6)
	..s PurUomDesc=""
	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inciid)
	..
	..s InitiInciInfo(inciid)=incicode_"^"_incidesc_"^"_ChargeFlag_"^"_Supervision_"^"_InsuId_"^"_ofcode_"^"_TmpStkGrpId_"^"_StkGrpDesc_"^"_TmpIncCatId_"^"_incscdesc_"^"_hv_"^"_spID_"^"_spType_"^"_TmpPbFlagValue_"^"_TmpPbFlag_"^"_BUomId_"^"_PurUomId_"^"_PurUomDesc_"^"_Fac2_"^"_Spec
	.e  d
	..s InciInfo=InitiInciInfo(inciid)
	..s incicode=$p(InciInfo,"^",1)
	..s incidesc=$p(InciInfo,"^",2)
	..s ChargeFlag=$p(InciInfo,"^",3)
	..s Supervision=$p(InciInfo,"^",4)
	..s InsuId=$p(InciInfo,"^",5)
	..s ofcode=$p(InciInfo,"^",6)
	..s TmpStkGrpId=$p(InciInfo,"^",7)
	..s StkGrpDesc=$p(InciInfo,"^",8)
	..s TmpIncCatId=$p(InciInfo,"^",9)
	..s incscdesc=$p(InciInfo,"^",10)
	..s hv=$p(InciInfo,"^",11)
	..s spID=$p(InciInfo,"^",12)
	..s spType=$p(InciInfo,"^",13)
	..s TmpPbFlagValue=$p(InciInfo,"^",14)
	..s TmpPbFlag=$p(InciInfo,"^",15)
	..s BUomId=$p(InciInfo,"^",16)
	..s PurUomId=$p(InciInfo,"^",17)
	..s PurUomDesc=$p(InciInfo,"^",18)
	..s Fac2=$p(InciInfo,"^",19)
	..s Spec=$p(InciInfo,"^",20)
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)		;类组不符
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
	.q:(HvFlag'="")&&(HvFlag'=hv)
	.q:(MarkType'="")&&(spID'=MarkType)			;定价类型
	.q:(ImpFlag'="")&&(TmpImpFlag'=ImpFlag)
	.q:(InsuType'="")&&(InsuId'=InsuType)			;医保类型
	.q:(PbFlag'="")&&(TmpPbFlagValue'=PbFlag)		;是否招标
	.q:(PbLevel'="")&&(TmpPbLevel'=PbLevel) 		;招标级别
	.
	.f date=StartDate:1:EndDate d
	..s intrid=""
	..f  s intrid=$o(^DHCINTR(0,"INCI",inciid,date,intrid)) q:intrid=""  d
	...q:'$d(^DHCINTR(intrid))
	...
	...s TrType=$p(^DHCINTR(intrid),"^",1)
	...q:(TrType'="MP")&&(TrType'="MY")&&(TrType'="MF")&&(TrType'="MH")			;过滤非PYFH台帐
	...s trTime=$p(^DHCINTR(intrid),"^",3)
	...i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
	...i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
	...
	...s TrDate=..DL2H(date)
	...s trTime=..TL2H(trTime)
	...s TrDateTime=TrDate_" "_trTime
	...s IntrUser=$p(^DHCINTR(intrid),"^",11)
	...s IntrUser=$s(IntrUser'="":$p($g(^SSU("SSUSR",IntrUser)),"^",2),1:"")
	...
	...s pointer=$p(^DHCINTR(intrid),"^",9)
	...s MainId=+pointer
	...s Chl=$p(pointer,"||",2)
	...q:'$d(^OEORD(MainId))
	...q:'$d(^OEORD(MainId,"I",Chl))
	...
	...s FromLocId=$p(^OEORD(MainId,"I",Chl,3),"^",6)	;接收科室
	...q:FromLocId'=RecLocId							;接收科室不一致的
	...s FromLocDesc=""
	...s:FromLocId'="" FromLocDesc=$p($g(^CTLOC(FromLocId)),"^",2)
	...i $f(FromLocDesc,"-") s FromLocDesc=$p(FromLocDesc,"-",2)
	...;s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;转入科室
	...;q:ToLocId'=LocId   ;非统计科室
	...
	...;s tmpouttype=$p(^DHCINIT(MainId),"^",20)
	...;q:(OutType'="")&(tmpouttype'=OutType)			;按出库类型过滤
	...s TrNo=$p(^OEORD(MainId,"I",Chl,1),"^",14)		;处方号
	...
	...s inclbid=$p(^DHCINTR(intrid),"^",7)
	...q:inclbid=""
	...s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	...
	...s inciid=$p(inclbid,"||",1)
	...q:(InciRowid'="")&(InciRowid'=inciid)			;库存项不符
	...q:'$d(^INCI(inciid,1))
	...q:'$d(^INCI(inciid,2))
	...q:'$d(^INCI(inciid,3))
	...
	...i '$d(InitToLocInfo(FromLocId)) d
	....s FromLocGrp=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocItmGrp(FromLocId)
	....s:FromLocGrp="" FromLocGrp="不详"
	....s FromLocGrpItm=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocGrpItm(FromLocId)
	....s:FromLocGrpItm="" FromLocGrpItm="不详"
	....s InLocGrpItems=$s(LocGrpItems[("^"_FromLocId_"^"):"Y",1:"N")
	....s InitToLocInfo(FromLocId)=FromLocGrp_"^"_FromLocGrpItm_"^"_InLocGrpItems
	...e  d
	....s FromLocGrp=$p(InitToLocInfo(FromLocId),"^",1)
	....s FromLocGrpItm=$p(InitToLocInfo(FromLocId),"^",2)
	....s InLocGrpItems=$p(InitToLocInfo(FromLocId),"^",3)
	...;q:(TransRange=1)&&(InLocGrpItems="N")		;过滤组外部分
	...;q:(TransRange=2)&&(InLocGrpItems="Y")		;过滤组内部分
	...
	...///Inclb部分
	...s (apcvmid,VenName,gmanfid,Manf,TmpBatNo,ExpireDate)=""
	...i '$d(InitiInclbInfo(inclbid)) d
	....s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclbid,date)
	....s apcvmid=$p(VenInfo,"^",1)
	....s VenName=$p(VenInfo,"^",2)
	....s manfinfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
	....s gmanfid=$p(manfinfo,"^",1)
	....s Manf=$p(manfinfo,"^",2)
	....s TmpBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclbid)
	....s TmpBatNo=$p(TmpBat,"^",1)
	....s ExpireDate=$p(TmpBat,"^",2)
	....s InitiInclbInfo(inclbid)=apcvmid_"^"_VenName_"^"_gmanfid_"^"_Manf_"^"_TmpBatNo_"^"_ExpireDate
	...e  d
	....s inclbInfo=InitiInclbInfo(inclbid)
	....s apcvmid=$p(inclbInfo,"^",1)
	....s VenName=$p(inclbInfo,"^",2)
	....s gmanfid=$p(inclbInfo,"^",3)
	....s Manf=$p(inclbInfo,"^",4)
	....s TmpBatNo=$p(inclbInfo,"^",5)
	....s ExpireDate=$p(inclbInfo,"^",6)
	...q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
	...q:(ManfId'="")&(gmanfid'=ManfId)					;生产厂家
	...q:(BatNo'="")&(TmpBatNo'=BatNo)
	...
	...s InitiInfo=^DHCINTR(intrid)		;医嘱台帐信息
	...s TrUom=$p(InitiInfo,"^",10)
	...s sp=$p(InitiInfo,"^",14)		;售价
	...s rp=$p(InitiInfo,"^",16)		;进价
	...s BatSp=$p(InitiInfo,"^",14)		;批次售价
	...s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	...
	...s sp=sp/Fac1*Fac2
	...s rp=rp/Fac1*Fac2
	...s BatSp=BatSp/Fac1*Fac2
	...q:(SpFrom'="")&&(sp<+SpFrom)      ;低于售价范围最小值
	...q:(SpTo'="")&&(sp>+SpTo)
	...q:(RpFrom'="")&&(rp<+RpFrom)
	...q:(RpTo'="")&&(rp>+RpTo)
	...
	...s TrQty=$p(InitiInfo,"^",6)
	...s TrQty=TrQty*Fac1/Fac2
	...s TrQty=-TrQty
	...s RpAmt=-$p(InitiInfo,"^",17)
	...s SpAmt=-$p(InitiInfo,"^",8)
	...s BatSpAmt=-$p(InitiInfo,"^",8)
	...
	...s (operNo,paNo,paName)=""
	...&sql(select OEORI_PrescNo,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_no,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_name
                into :operNo,:paNo,:paName from oe_orditem where %id=:pointer)
	...s TrRemarks=paNo_" "_paName
	...s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,pointer)
	...s i=i+1
	...;
	...s Data1=TrNo_"^"_TrDateTime_"^"_incicode_"^"_incidesc_"^"_PurUomDesc_"^"_FromLocDesc_"^"_rp_"^"_sp_"^"_BatSp_"^"_TmpBatNo
	...s Data2=ExpireDate_"^"_Manf_"^"_FromLocDesc_"^"_ofcode_"^"_TrQty_"^"_RpAmt_"^"_SpAmt_"^"_BUomDesc_"^"_FromLocGrp_"^"_incscdesc
	...s Data3=StkGrpDesc_"^"_TrType_"^"_incib_"^"_TmpPbLevel_"^"_spType_"^"_TmpBaFlag_"^"_TmpPbFlag_"^"_FromLocGrpItm_"^"_apcvmid_"^"_VenName
	...s Data4=Spec_"^"_intrid_"^"_TrRemarks_"^"_HVBarCode_"^"_IntrUser
	...s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	...s ^TMPDHCOUTSTAT(pid,"OUTDETAIL",i)=Data

	q pid
}

/// 2015-06-11
/// 检查inci在科室串中是否有库存
ClassMethod CheckIncil(Inci, LocStr) As %String
{
	n (Inci, LocStr)
	s ret=0
	q:Inci="" ret
	q:LocStr="" ret
	s len=$l(LocStr,",")
	f i=1:1:len q:ret=1  d
	.s Loc=$p(LocStr,",",i)
	.s il=$o(^INCI("IL_LOC",Loc,Inci,0))
	.s:il'="" ret=1

	q ret
}

}
