Import sqluser

Class web.DHCSTMHUI.HVMatOrdItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "HVMatOrdItm";

/// 插入或更新一条提取表DHC_HVMat_OrdItm记录
/// Author:zhwh
/// Date:2013-05-12
/// Argu:
///   data - 数据串
/// Return:
///   >0 - rowid of DHC_HVMat_OrdItm
///   <0 - 插入失败
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).Update()
ClassMethod Update(data As %String) As %String
{
	n (data)
	s hvm=$p(data,"^",1)
	s oeori=$p(data,"^",2)
	s feeamt=$p(data,"^",7)
	s feestatus=$p(data,"^",6)
	s admLoc=$p(data,"^",8)
	s vendor=$p(data,"^",13)
	s manf=$p(data,"^",12)
	s uom=$p(data,"^",14)
	s qty=$p(data,"^",15)
	s rp=$p(data,"^",16)
	s rpamt=rp*qty
	s sp=$p(data,"^",17)
	s spamt=sp*qty
	s batno=$p(data,"^",11)
	s expdate=$p(data,"^",19)
	i expdate'=""  s expdate=$zdh(expdate,3)
	s dateofmanu=""
	s barcode=$p(data,"^",18)
	s canceled=$p(data,"^",20)
	s invno=$p(data,"^",21)
	s invdate=$p(data,"^",22)
	i invdate'="" s invdate=$zdh(invdate,3)
	s invamt=$p(data,"^",23)
	s inci=$p(data,"^",24)
	s user=$p(data,"^",9)
	s remark=$p(data,"^",25)
	s ingri=$p(data,"^",26)  //入库明细rowid
	s objORI=##class(User.OEOrdItem).%OpenId(oeori)
	s oridate=objORI.OEORIDate  ; 医嘱日期
	s oritime=objORI.OEORITimeOrd ;医嘱时间
	s oriuseradd=objORI.OEORIUserAddGetObjectId()
	s arcim=objORI.OEORIItmMastDRGetObjectId()
	s oeoriRecLoc=objORI.OEORIRecDepDRGetObjectId()
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s SCG=$P(ScgInfo,"^",5)

	s mainLoc="",CurrentLoc=""
	i barcode'="" d
	.s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	.q:dhcit=""
	.s CurrentLoc=$p(^DHCIT(dhcit),"^",6)		//暂存库调拨时,修改DHCIT_CurrentLoc
	i CurrentLoc'="" d
	.s mainLocInfo=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(CurrentLoc)
	.s mainLoc=$p(mainLocInfo,"^",1)			//存在暂存库调拨的,以调拨后的暂存库支配科室为准
	i (mainLoc="") {
		i (ingri'="") d
		.s ingr=$p(ingri,"||",1)
		.q:(ingr="")||'$d(^DHCINGR(ingr))
		.s ingrLoc=$p(^DHCINGR(ingr),"^",13)
		.s mainLocInfo=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(ingrLoc)
		.s mainLoc=$p(mainLocInfo,"^",1)
		.s:mainLoc="" mainLoc=ingrLoc		//支配科室为空的,取ingrLoc
		e  d	//取医嘱接收科室的支配科室
		.s mainLocInfo=##class(web.DHCSTMHUI.Common.UtilCommon).MLoc(oeoriRecLoc)
		.s mainLoc=$p(mainLocInfo,"^",1)
		.i mainLoc="" d
		..s hvori=$o(^DHCHVMORI(0,"OEORI",oeori,0))	;医嘱包提取表ID
		..s:hvori'="" mainLoc=$p(^DHCHVMORI(hvori,1),"^",42)
	}
	s IfPreAuditFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("HVMatOrdItm","IfPreAudit","")
	s AuditFlag="Y"
	i IfPreAuditFlag="Y" s AuditFlag="N"
	
	i hvm="" d
	.s obj=##class(User.DHCHVMatOrdItm).%New()
	e  d
	.s obj=##class(User.DHCHVMatOrdItm).%OpenId(hvm)
	.d obj.%Reload()
	d obj.ORIINCIDRSetObjectId(inci)
	d obj.ORIOEORIDRSetObjectId(oeori)
	d obj.ORIAdmLocDRSetObjectId(admLoc)
	d obj.ORIAPCVMDRSetObjectId(vendor)
	s obj.ORIBarCode=barcode
	s obj.ORIBatNo=batno
	s obj.ORIExpDate=expdate
	s obj.ORIDateOfManu=dateofmanu
	s obj.ORIFeeAmt=feeamt
	s obj.ORIFeeStatus=feestatus
	s obj.ORIInvAmt=invamt
	s obj.ORIInvDate=invdate
	s obj.ORIInvNo=invno
	d obj.ORIMANFDRSetObjectId(manf)
	s obj.ORIOEORIDate=oridate
	s obj.ORIOEORITime=oritime
	d obj.ORIOEORIUserAddSetObjectId(oriuseradd)
	s obj.ORIQty=qty
	d obj.ORIUnitDRSetObjectId(uom)
	s obj.ORIRp=rp
	s obj.ORIRpAmt=rpamt
	s obj.ORISp=sp
	s obj.ORISpAmt=spamt
	d obj.ORISCGDRSetObjectId(SCG)
	s obj.ORIRemark=remark
	d obj.ORISSUSRDRSetObjectId(user)
	s obj.ORIDate=+$h   //提取日期
	s obj.ORITime=$p($h,",",2)  //提取时间
	d obj.ORIINGRIDRSetObjectId(ingri)  //入库明细rowid
	d obj.ORIMainLocDRSetObjectId(mainLoc)		//补录入库科室id
	s obj.ORIAuditFlag=AuditFlag  //补录预审标志
	s obj.ORICanceled=canceled
	i canceled="Y" d
	.s obj.ORIDateCanceled=+$h
	.s obj.ORITimeCanceled=$p($h,",",2)
	.d obj.ORIUserCanceledDRSetObjectId(user)
	e   d 
	.s obj.ORIDateCanceled=""
	.s obj.ORITimeCanceled=""
	.d obj.ORIUserCanceledDRSetObjectId("")
	s sc=obj.%Save()
	i $$$ISERR(sc) q -1
	q obj.%Id()
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HVMatOrdItm","HVMatOrdItems",^tmpltx(9091))
Query HVMatOrdItems(Params As %Text) As Query(ROWSPEC = "RowId,InvNo,InvDate,InvAmt:%Float,InciCode,InciDesc,DoctorDr,Doctor,OrdDate,OrdTime,Qty:%Float,UomDr,UomDesc,PaNo,PaName,Ward,Bed,PrescNo,Oeori,VendorDr,ManfDr,Vendor,Manf,Rp:%Float,BatNo,ExpDate,Sp:%Float,OrdStatus,FeeStatus,FeeAmt:%Float,AdmLocDr,AdmLoc,Date,Time,User,IngNo,DateOfManu,Canceled,DateCanceled,TimeCanceled,IngrtNo,Inci,IngrFlag,dhcit,VendorDr,SpecDesc,OriginalCode,IngriModify,IngriModifyNo,Ingri,InitRecLoc,BarCode,MainLoc,MainLocDesc,Spec,Ingr,Init,Initi,IngrModify,InvCode,Adm,MatInsuCode,MatInsuDesc,IngrModifyDate,Medicare,InitModifyDate,ScgDesc") [ SqlProc ]
{
}

ClassMethod HVMatOrdItemsExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s FromDate=PJobj.%Get("FromDate")
	s ToDate=PJobj.%Get("ToDate")
	s FromDate=..DH2L(FromDate)
	s ToDate=..DH2L(ToDate)
	s pInci=PJobj.%Get("Inci")
	s pVendor=PJobj.%Get("Vendor")
	s pScgStk=PJobj.%Get("ScgStk")
	s pLocId=PJobj.%Get("Loc")	//补录科室
	s UserId=PJobj.%Get("gUserId")
	s gHospId=PJobj.%Get("gHospId")
	s HospId=..sssHospId(pLocId)
	s:HospId="" HospId=gHospId
	s StkGrpIds=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,"M",pLocId,pScgStk,HospId)
	s pIngrFlag=PJobj.%Get("INGRFlag")	//补录标志（0全部,1已补录,2未补录）
	s pOrdLocId=PJobj.%Get("OrdLoc")	//医嘱接收科室
	s pPaAdmNo=PJobj.%Get("PaAdmNo")			;登记号
	s pPatName=PJobj.%Get("PatName")			;病人姓名
	s pInciDesc=PJobj.%Get("InciDesc")			;物资名称
	s pTableFlag=PJobj.%Get("TableFlag")
	s pAuditFlag=PJobj.%Get("AuditFlag")	//预审标志(Y/N)
	s:pAuditFlag="" pAuditFlag="N"
	s GroupId=PJobj.%Get("gGroupId")
	s UserId=PJobj.%Get("gUserId")
	s HospId=PJobj.%Get("gHospId")
	
	s AppParams=GroupId_"^"_pLocId_"^"_UserId_"^"_HospId
	//s AppName=..%GetParameter("AppName")
	//s IfReapricale=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"IfReapricale",AppParams)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from DHC_HVMat_OrdItm where ORI_OEORI_Date BETWEEN "_FromDate_" AND "_ToDate
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	d result.Execute()
	While(result.Next())
	{
		s OriRowId = result.Data("ORI_RowId")
		
		s BarCode=result.Data("ORI_BarCode")
		continue:BarCode=""
		
		s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
		s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
		continue:dhcit=""
		
		s dhcitDR=$p(^DHCIT(dhcit),"^",28)
		continue:dhcitDR'=""		;重生成条码,不进行补录处理
		
		s AuditFlag = result.Data("ORI_AuditFlag") //预审标志
		s:AuditFlag="" AuditFlag="N"
		continue:((pTableFlag'="Y")&&(pAuditFlag'=AuditFlag))	//跟台清点界面不需要判断预审标志
		
		s Oeori = result.Data("ORI_OEORI_DR")
		continue:'$d(^OEORD(+Oeori,"I",$p(Oeori,"||",2)))
		
		s OeoriRecLoc = $p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6)
		continue:(pOrdLocId'="")&&(OeoriRecLoc'=pOrdLocId)	;医嘱接收科室
		
		s Scg = result.Data("ORI_SCG_DR")
		continue:(StkGrpIds'="")&&(("^"_StkGrpIds_"^")'[("^"_Scg_"^"))
		
		s Ingri = result.Data("ORI_INGRI_DR")
		continue:(pTableFlag="Y")&&(Ingri'="")				;TableFlag="Y",仅检索跟台高值
		
		s Ingr=$p(Ingri,"||",1)
		continue:(Ingr'="")&&'$d(^DHCINGR(Ingr))
		
		s (IngNo,IngrLoc)=""
		i Ingr'="" d
		.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
		.s IngNo=$p(^DHCINGR(Ingr),"^",1)
		continue:(Ingr'="")&&(IngrLoc=pLocId)	;ORI_INGRI_DR非空,本科室入库的不再补录(医嘱包条码关联时可能没有Ingri,这些不过滤)
		
		s MainLoc=result.Data("ORI_MainLoc_DR")
		s MainLocDesc=$s(MainLoc'="":$p(^CTLOC(MainLoc),"^",2),1:"")
		continue:(pLocId'="")&&(MainLoc'=pLocId)
		continue:(Ingr'="")&&(MainLoc=IngrLoc)
		
		s VendorDr = result.Data("ORI_APCVM_DR")
		continue:(pVendor'="")&&(VendorDr'=pVendor)
		
		s Inci = result.Data("ORI_INCI_DR")
		continue:(pInci'="")&&(pInci'=Inci)
		
		s InciCode=$p(^INCI(Inci,1),"^",1) ;物资名称
		s InciDesc=$p(^INCI(Inci,1),"^",2) ;物资名称
		continue:(pInciDesc'="")&&(InciDesc'[pInciDesc)
		
		s PackChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(Inci)
		continue:PackChargeFlag="Y"   //过滤包
		
		s OrdDate = result.Data("ORI_OEORI_Date")
		s:OrdDate'="" OrdDate=..DL2H(OrdDate)
		s OrdTime = result.Data("ORI_OEORI_Time")
		s:OrdTime'="" OrdTime=..TL2H(OrdTime)
		s FeeStatus = result.Data("ORI_FeeStatus")
		s FeeAmt = result.Data("ORI_FeeAmt")
		s AdmLocDr = result.Data("ORI_AdmLoc_DR")
		s Date = result.Data("ORI_Date")
		s Time = result.Data("ORI_Time")
		s Date=..DL2H(Date)
		s Time=..TL2H(Time)
		s UserDr = result.Data("ORI_SSUSR_DR")
		s BatNo = result.Data("ORI_BatNo")
		s ExpDate = result.Data("ORI_ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s DateOfManu = result.Data("ORI_DateOfManu")
		s:DateOfManu'="" DateOfManu=..DL2H(DateOfManu)
		s ManfDr = result.Data("ORI_MANF_DR")
		s UomDr = result.Data("ORI_Unit_DR")
		s Qty = result.Data("ORI_Qty")
		s Rp = result.Data("ORI_Rp")
		s Sp = result.Data("ORI_Sp")
		s RpAmt = result.Data("ORI_RpAmt")
		s SpAmt = result.Data("ORI_SpAmt")
		s BarCode = result.Data("ORI_BarCode")
		s Canceled = result.Data("ORI_Canceled")
		s UserCanceled = result.Data("ORI_UserCanceled_DR")
		s DateCanceled = result.Data("ORI_DateCanceled")
		s TimeCanceled = result.Data("ORI_TimeCanceled")
		s:DateCanceled'="" DateCanceled=..DL2H(DateCanceled)
		s:TimeCanceled'="" TimeCanceled=..TL2H(TimeCanceled)
		s IngrtNo = result.Data("ORI_INGRTI_DR")
		s:IngrtNo'="" IngrtNo=$p(^INGRT(+IngrtNo),"^",1)
		s InvCode = result.Data("ORI_InvCode")
		s InvNo = result.Data("ORI_InvNo")
		s InvDate = result.Data("ORI_InvDate")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s InvAmt = result.Data("ORI_InvAmt")
		s Inclb=$p(^DHCIT(dhcit),"^",12)
		s IngriModify=result.Data("ORI_Ingri_Modify_DR")
		s Adm=$p(^OEORD(+Oeori),"^",1)
		s Painfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(Adm)
		s PaNo=Painfo.PatNo
		s PaName=Painfo.PatName
		s Medicare=Painfo.MrNo
		s Adminfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(Adm)
		s Ward=Adminfo.WardDesc
		s Bed=Adminfo.BedNo
		s OrderInfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetOeoriData(Oeori)
		s DoctorDr=OrderInfo.DoctorId
		s Doctor=OrderInfo.Doctor
		s OrdStatus=OrderInfo.StatCode
		continue:(pPaAdmNo'="")&&(PaNo'=pPaAdmNo)
		continue:(pPatName'="")&&(pPatName'=PaName)
		
		//已作废或停止的医嘱，如果补录过也进行展示
		s IngrFlag = result.Data("ORI_IngrFlag")
		i ((OrdStatus="C")||(OrdStatus="U")||(OrdStatus="D")) d
		.s MPdhcit=$o(^DHCITD(0,"Type","MP","Pointer",Oeori,""),-1)
		.q:MPdhcit=""
		.s MPdhcitCh=$o(^DHCITD(0,"Type","MP","Pointer",Oeori,MPdhcit,""),-1)
		.q:MPdhcitCh=""
		.s MPdhciti=MPdhcit_"||"_MPdhcitCh
		.s Ret=..CheckIngr(MPdhciti)
		.q:Ret'=1
		.s IngrFlag="Y"	//已经作废或停止的医嘱曾经补录过
		continue:(pIngrFlag=1)&&(IngrFlag'="Y")
		continue:(pIngrFlag=2)&&(IngrFlag="Y")
		continue:(IngrFlag'="Y")&&((OrdStatus="C")||(OrdStatus="U")||(OrdStatus="D"))	;未补录时撤销,作废,停止的医嘱不再处理,已补录不判断医嘱状态
		//补录信息
		s InitRecLocId=..GetHVInitLocByOeori(Oeori,pLocId)	//按参数配置取补录出库单的接收科室
		s (IngriModifyNo,IngrModify,Init,Initi,InitRecLocId,IngrModifyDate,InitModify,InitModifyDate)=""	//补录信息
		i +IngriModify'=0  d
		.s IngriModifyNo=$p($g(^DHCINGR(+IngriModify)),"^",1)	;补录入库单单号
		.s IngrModify=+IngriModify
		.s IngrModifyDate=$p($g(^DHCINGR(IngrModify)),"^",4)
		.s:IngrModifyDate'="" IngrModifyDate=$zd(IngrModifyDate,3)
		.s IngrModifych=$p(IngriModify,"||",2)
		.s Initi=$p($g(^DHCINGR(IngrModify,"GRI",IngrModifych)),"^",44) //补录出库明细id
		.s:Initi'="" Init=+Initi
		.s:Init'="" InitRecLocId=$p(^DHCINIT(Init),"^",6)	//实际补录接收科室
		.s:Init'="" InitModifyDate=$p($g(^DHCINIT(Init)),"^",9)
		.s:InitModifyDate'="" InitModifyDate=$zd(InitModifyDate,3)
		s InitRecLoc=$s(InitRecLocId'="":$p(^CTLOC(InitRecLocId),"^",2),1:"")
		
		s Rp=..GetRp(OriRowId,AppParams)
		s RpAmt=Rp*Qty
		s:InvAmt="" InvAmt=RpAmt			;缺省
		
		s (Manf,Vendor,AdmLoc,User,UserCanceled,UomDesc)=""
		s:ManfDr'="" Manf=$p($g(^PHMNF(ManfDr)),"^",2)
		s:VendorDr'="" Vendor=$p($g(^APC("APCVM",VendorDr)),"^",3)
		i AdmLocDr'="" s AdmLoc=$p(^CTLOC(AdmLocDr),"^",2),AdmLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(AdmLoc) 
		i UserDr'="" s User=$p($g(^SSU("SSUSR",UserDr)),"^",2 )
		i UserCanceled'="" s UserCanceled=$p($g(^SSU("SSUSR",UserDr)),"^",2 )
		i UomDr'="" s UomDesc=$p($g(^CT("UOM",UomDr)),"^",2)
		s SpecDesc=$P(^DHCIT(dhcit),"^",19)
		s OriginalCode=$P(^DHCIT(dhcit),"^",13)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
		s MatInsuCode=$p(MatInsuInfo,"^",1)
		s MatInsuDesc=$p(MatInsuInfo,"^",2)
		s ScgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",2)
		d OutPutRowS
	}
	Quit $$$OK

OutPutRowS
	s Data=$lb(OriRowId,InvNo,InvDate,InvAmt,InciCode,InciDesc,DoctorDr,Doctor,OrdDate,OrdTime,
		Qty,UomDr,UomDesc,PaNo,PaName,Ward,Bed,PrescNo,Oeori,VendorDr,
		ManfDr,Vendor,Manf,Rp,BatNo,ExpDate,Sp,OrdStatus,FeeStatus,FeeAmt,
		AdmLocDr,AdmLoc,Date,Time,User,IngNo,DateOfManu,Canceled,DateCanceled,TimeCanceled,
		IngrtNo,Inci,IngrFlag,dhcit,VendorDr,SpecDesc,OriginalCode,IngriModify,IngriModifyNo,Ingri,
		InitRecLoc,BarCode,MainLoc,MainLocDesc,Spec,Ingr,Init,Initi,IngrModify,InvCode,Adm,MatInsuCode,
		MatInsuDesc,IngrModifyDate,Medicare,InitModifyDate,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.HVMatOrdItm).Pa
ClassMethod Pa(pano As %String) As %String
{
	n (pano)
	q:pano="" ""
	s name="",sex=""
	s pano=$$FormatPaNo(pano)
	s pano=$$ALPHAUP^SSUTIL4(pano)
	s papmidr=$o(^PAPERi("PAPMI_PatNo",pano,"") )
	q:papmidr="" ""
	s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
	s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
	s sex=""
	i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",2)
	
	s Data=pano_"^"_name_"^"_sex
	q $TR(Data,$c(13,10))
FormatPaNo(pano)
	n (pano)
	s len=$l(pano)
	f i=1:1:(10-len) d
	.s pano="0"_pano
	q pano
}

/// xuchao
/// 退货时子表rowid  barcode
/// 记录退货
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).IngretNO()
ClassMethod IngretNO(barcodes As %String, ingretitm As %String) As %String
{
	n (barcodes,ingretitm)
	s cnt=$l(barcodes,"^")
	s ret=0
	f i=1:1:cnt d
	.s barcode=$p(barcodes,"^",i)
	.s date=+$h
	.&sql(update DHC_HVMat_OrdItm set  ORI_INGRTI_DR=:ingretitm where ORI_BarCode=:barcode)
	.i SQLCODE<0 s ret=-1
	.q:ret<0
	q ret
}

ClassMethod jsSaveInvInfo(ListData As %String) As %Library.String
{
	n (ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..SaveInvInfo(ListData)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description:修改DHC_HVMat_OrdItm发票信息
/// Creator:	houshanchuan
/// Input:		
/// Output:		RtnObj.Json()
ClassMethod SaveInvInfo(ListData As %String) As RtnObj
{
	n (ListData)
	s RtnObj=##class(RtnObj).%New()
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	q:Sc'=0 RtnObj.Err(-1,"","明细入参解析失败!")
	
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s OriId=ItmObj.%Get("RowId")
		s InvCode=ItmObj.%Get("InvCode")
		s InvNo=ItmObj.%Get("InvNo")
		s InvDate=ItmObj.%Get("InvDate")
		s InvAmt=ItmObj.%Get("InvAmt")
		s Vendor=ItmObj.%Get("VendorDr")
		s InvDate=..DH2L(InvDate)
		s Ingri=$p(^DHCHVMORI(OriId,1),"^",12)
		s IngriModify=$p(^DHCHVMORI(OriId,1),"^",36)
		
		s obj=##class(User.DHCHVMatOrdItm).%OpenId(OriId)
		s obj.ORIInvCode=InvCode
		s obj.ORIInvNo=InvNo
		s obj.ORIInvDate=InvDate
		s obj.ORIInvAmt=InvAmt
		;仅ORI_INGRI_DR为空的(不是入虚库的),允许修改供应商
		i Ingri="" d obj.ORIAPCVMDRSetObjectId(Vendor)
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-6,"","保存信息失败!") 
		q:RtnObj.success'=0
		
		i Ingri'="" d
		.s IngriObj1=##class(User.DHCINGdRecItm).%OpenId(Ingri)
		.s IngriObj1.initmInvCode=InvCode
		.s IngriObj1.initminvno=InvNo
		.s IngriObj1.initminvdate=InvDate
		.s IngriObj1.initminvmoney=InvAmt
		.s sc=IngriObj1.%Save()
		.i $$$ISERR(sc) s Sc=RtnObj.Err(-6,"","同步入库单发票信息失败!") 
		q:RtnObj.success'=0
		
		;联动修改补录入库单上的发票信息
		i IngriModify'="" d
		.s IngriObj2=##class(User.DHCINGdRecItm).%OpenId(IngriModify)
		.s IngriObj2.initmInvCode=InvCode
		.s IngriObj2.initminvno=InvNo
		.s IngriObj2.initminvdate=InvDate
		.s IngriObj2.initminvmoney=InvAmt
		.s sc=IngriObj2.%Save()
		.i $$$ISERR(sc) s Sc=RtnObj.Err(-6,"","同步补录入库单发票信息失败!") 
		q:RtnObj.success'=0
	}
	
	q RtnObj
}

/// Description:修改DHC_HVMat_OrdItm批号效期等信息
/// 	ps:跟台高值清点记录界面使用
/// Creator:	wangjiabin
/// CreateDate:	2018-11-05
/// Input:		
/// Output:		RtnObj.Json()
ClassMethod SaveHvmInfo(ListData As %String) As %String
{
	n (ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		
		s OriId=ItmObj.%Get("RowId")
		s dhcit=ItmObj.%Get("dhcit")
		i (OriId="")||(dhcit="") d RtnObj.Err(-10,"","参数错误!")
		continue:RtnObj.success<0
		
		s InvNo=ItmObj.%Get("InvNo")
		s InvDate=ItmObj.%Get("InvDate")
		s InvAmt=ItmObj.%Get("InvAmt")
		s Vendor=ItmObj.%Get("VendorDr")
		i Vendor="" d RtnObj.Err(-1,OriId,"供应商必须填写!","",0)
		continue:RtnObj.success'=0
		s InvDate=..DH2L(InvDate)
		s BatchNo=ItmObj.%Get("BatNo")
		s ExpDate=ItmObj.%Get("ExpDate")
		s ExpDate=..DH2L(ExpDate)
		s SpecDesc=ItmObj.%Get("SpecDesc")
		s OriginalCode=ItmObj.%Get("OriginalCode")
		s Rp=ItmObj.%Get("Rp")
		s MainLoc=ItmObj.%Get("MainLoc")
		;if MainLoc="" s MainLoc=IngrLoc
		i OriginalCode'="" d
		.s ITId=$o(^DHCIT(0,"LABEL",OriginalCode,0))
		.s:ITId="" ITId=$o(^DHCIT(0,"ORIGINALCODE",OriginalCode,0))
		e  d
		.s ITId=""
		i (ITId'="")&&(ITId'=dhcit) d RtnObj.Err(-11,OriId,"自带条码"_OriginalCode_"重复!")
		continue:RtnObj.success<0
		
		s Ingri=$p(^DHCHVMORI(OriId,1),"^",12)
		s IngrFlag=$p(^DHCHVMORI(OriId,1),"^",35)
		i IngrFlag="Y" d RtnObj.Err(-12,OriId,"已补录入库,不可修改!","",0)
		continue:RtnObj.success'=0
		
		s Date=$h
		s obj=##class(User.DHCHVMatOrdItm).%OpenId(OriId)
		s obj.ORIBatNo=BatchNo
		s obj.ORIExpDate=ExpDate
		s obj.ORIRp=Rp
		s obj.ORIDate=+Date
		s obj.ORITime=$p(Date,",",2)
#;		s obj.ORIInvNo=InvNo
#;		s obj.ORIInvDate=InvDate
#;		s obj.ORIInvAmt=InvAmt
		;仅ORI_INGRI_DR为空的(不是入虚库的),允许修改供应商
		i Ingri="" d obj.ORIAPCVMDRSetObjectId(Vendor)
		i MainLoc'="" d obj.ORIMainLocDRSetObjectId(MainLoc)		
		s sc=obj.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-20,OriId,"保存失败!")
		continue:RtnObj.success'=0
		
		s dhcitObj=##class(User.DHCItmTrack).%OpenId(dhcit)
		s dhcitObj.DHCITBatchNo=BatchNo
		s dhcitObj.DHCITExpDate=ExpDate
		s dhcitObj.DHCITSpecList=SpecDesc
		s dhcitObj.DHCITOriginalCode=OriginalCode
		s sc=dhcitObj.%Save()
		i $$$ISERR(sc) s ret=-30
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 发送短信
/// Author:XuChao
/// Date:2015-07-31
/// 
ClassMethod Sms(vendorstr As %String, user As %String, loc As %String) As %String
{
	n (vendorstr,user,loc)
	s locdesc=$p(^CTLOC(loc),"^",2)
	i $f(locdesc,"-") d
	.s locdesc=$p(locdesc,"-",2)
	s sendId=$p(^SSU("SSUSR",user),"^",1)
	s sendName=$p(^SSU("SSUSR",user),"^",2)
	s rowdelim="," 
	s d=+$h
	s zd=$zd(d,3)
	s cnt=$l(vendorstr,rowdelim)
	s ret=0
	f i=1:1:cnt d
	.s vendor=$p(vendorstr,rowdelim,i)
	.q:vendor=""
	.s vendordesc=$p(^APC("APCVM",vendor),"^",2)
	.s STV=$o(^DHCSTV(0,vendor,""))
	.q:STV=""
	.s Mobile=$p(^DHCSTV(STV),"^",40) ;配送手机号
	.q:Mobile=""
	.s msg="接到本通知的供应商,请2日内到"_locdesc_"领取专业库发票信息,并于5日内卡发票交医工库房."
	.s result=sendId_"^"_sendName_"^"_Mobile_"^"_msg_"^"_zd
	.i $d(^$R("^web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS.1")) d
	..d ##class(web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS).SendPurchaseInfoToSMS(result)
	q ret
}

/// 生成高值入库单, 挂任务不需要填写参数
/// Input:		DateStr-要处理的日期(YYYY-mm-dd)
/// d ##class(web.DHCSTMHUI.HVMatOrdItm).NightRunCreateRecHV()
/// d ##class(web.DHCSTMHUI.HVMatOrdItm).NightRunCreateRecHV("2022-08-10")
ClassMethod NightRunCreateRecHV(DateStr = "")
{
	n (DateStr)
	//任务从前一天开始，防止医嘱在任务之后，有漏补录现象
	i DateStr'="" d
	.s Date=$zdh(DateStr,3)
	.s StartDate=Date-1
	.s EndDate=Date
	e  d
	.s StartDate=+$h-1
	.s EndDate=+$h
	
	s RtnObj=##class(RtnObj).%New()
	s Pid=..NewPid()
	k ^TMP(Pid,"NightRunCreateRecHV")
	
	s SourceOfFund=""

	s hvm=0
	f da=StartDate:1:EndDate d
	.f  s hvm=$o(^DHCHVMORI(0,"DATE",da,hvm)) q:hvm=""  d
	..s HvmInfo1=^DHCHVMORI(hvm,1)
	..s oeori=$p(HvmInfo1,"^",1)
	..s ord=+oeori,chl=$p(oeori,"||",2)
	..q:(ord="")!(chl="")
	..
	..s ostat=$p(^OEORD(ord,"I",chl,1),"^",13)	;医嘱状态id
	..s oeflag=$p(^OEC("OSTAT",ostat),"^",1)
	..q:(oeflag="C")||(oeflag="U")||(oeflag="D")	;撤销,作废,停止 的医嘱不再处理
	..
	..s barcode=$p(HvmInfo1,"^",24)
	..q:barcode=""
	..
	..s AuditFlag=$p(HvmInfo1,"^",43) //预审标志
	..q:AuditFlag'="Y"
	..
	..s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	..s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	..q:dhcit=""
	..
	..s dhcitDR=$p(^DHCIT(dhcit),"^",28)
	..q:dhcitDR'=""		;重生成条码,不进行补录处理
	..
	..s IngrFlag=$p(HvmInfo1,"^",35)
	..s IngriModify=$p(HvmInfo1,"^",36)
	..q:(IngrFlag="Y")	;已经补录的,不再处理
	..
	..s ingri=$p(HvmInfo1,"^",12)
	..s mainloc=$p(HvmInfo1,"^",42)
	..q:mainloc=""
	..
	..s ingrloc=""
	..i ingri'="" d
	...s INGR=$p(ingri,"||",1)
	...s ingrloc=$p($g(^DHCINGR(INGR)),"^",13)
	..q:(ingrloc'="")&&(ingrloc=mainloc)
	..
	..s inci=$p(HvmInfo1,"^",34)
	..s uom=$p(HvmInfo1,"^",18)
	..s bUomid=$p(^INCI(inci,1),"^",10)
	..q:bUomid'=uom   ;跟台高值 使用未补录时候 修改了单位
	..
	..s apcvm=$p(HvmInfo1,"^",17)
	..s user=$p(HvmInfo1,"^",10)
	..s manf=$p(HvmInfo1,"^",16)
	..s admloc=$p(HvmInfo1,"^",7)
	..s scg=$p(HvmInfo1,"^",11)
	..s qty=$p(HvmInfo1,"^",19)
	..s rp=$p(HvmInfo1,"^",20)
	..s sp=$p(HvmInfo1,"^",21)
	..s rpamt=$p(HvmInfo1,"^",22)
	..s spamt=$p(HvmInfo1,"^",23)
	..s batno=$p(HvmInfo1,"^",13)
	..s expdate=$p(HvmInfo1,"^",14)
	..s:expdate'="" expdate=..DL2H(expdate)
	..s invcode=$p(HvmInfo1,"^",46)
	..s invno=$p(HvmInfo1,"^",31)
	..s invdate=$p(HvmInfo1,"^",32)
	..s:invdate'="" invdate=..DL2H(invdate)
	..
	..;根据参数获取补录出库单的接收科室
	..s Inclb=$p(^DHCIT(dhcit),"^",12)
	..s AppParams="^"_mainloc_"^^"
	..s rp=..GetRp(hvm,AppParams)
	..s admloc=..GetHVInitLocByOeori(oeori,mainloc)
	..q:admloc=""
	..s admInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(inci)
	..s admNo=$p(admInfo,"^",1)
	..//s PaAdm=$p(^OEORD(+oeori),"^",1)
	..//s Papmi=$p(^PAADM(PaAdm),"^",1)
	..//s PaAdmNo="" ;病人登记号
	..//&sql(select papmi_no into :PaAdmNo from pa_patmas where %id=:Papmi)
	..//q:PaAdmNo=""
	..s SpecDesc=""
	..i Inclb'="" d
	...s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	..//组织数据
	..s newDetailObj={}
	..s newDetailObj.RowId=""
	..s newDetailObj.IncId=inci
	..s newDetailObj.BatchNo=batno
	..s newDetailObj.ExpDate=expdate
	..s newDetailObj.ManfId=manf
	..s newDetailObj.IngrUomId=uom
	..s newDetailObj.Rp=rp
	..s newDetailObj.HVBarCode=""
	..s newDetailObj.RecQty=qty
	..s newDetailObj.NewSp=sp
	..s newDetailObj.SxNo=""
	..s newDetailObj.InvNo=invno
	..s newDetailObj.InvCode=invcode
	..s newDetailObj.InvDate=invdate
	..s newDetailObj.Inpoi=""
	..s newDetailObj.Remark=""
	..s newDetailObj.Remarks=""
	..s newDetailObj.QualityNo=""
	..s newDetailObj.MtDr=""
	..s newDetailObj.SterilizedNo=""
	..s newDetailObj.AdmNo=admNo
	..s newDetailObj.AdmExpdate=""
	..s newDetailObj.InvMoney=""
	..s newDetailObj.SpecDesc=SpecDesc
	..s newDetailObj.OrderDetailSubId=""
	..s newDetailObj.reqLocId=admloc
	..s newDetailObj.Sp=sp
	..s newDetailObj.Tax=""
	..s nDetailObj=newDetailObj.%ToJSON()
	..
	..s SubStr=mainloc_"^"_apcvm_"^"_admloc_"^"_scg_"^"_SourceOfFund_"^"_user
	..s ^TMP(Pid,"NightRunCreateRecHV",SubStr,hvm)=nDetailObj
	q:'$d(^TMP(Pid,"NightRunCreateRecHV"))
	
	s user=""
	s RtnObj=..CreateRecHV(Pid,user,"Y")
	
	k ^TMP(Pid,"NightRunCreateRecHV")
	q
}

/// 把明细信息已供应商不进行分单 生成入库单
/// 2015-06-16
/// 生成入库单
/// hvm^发票号^发票日期^发票金额^供应商_$c(1)_...
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).Create(^templxt("Create1"),^templxt("Create2"))
ClassMethod Create(MainInfo As %String, ListDetail As %String) As %String
{
	n (MainInfo,ListDetail,%session)
	s RtnObj=##class(RtnObj).%New()
	s $ZT="CreateError"
	s Pid=..NewPid()
	k ^TMP(Pid,"NightRunCreateRecHV")

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(MainInfo)
	q:Sc'=0 Sc=RtnObj.Err(-1,"","参数解析失败!").Json()
	
	s MainLocId=PJobj.%Get("Loc")
	s SourceOfFund=PJobj.%Get("SourceCombo")
	s gGroup=PJobj.%Get("gGroupId")
	s gUser=PJobj.%Get("gUserId")
	s gHospId=PJobj.%Get("gHospId")
	s AppParams=gGroup_"^"_MainLocId_"^"_gUser_"^"_gHospId
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(ListDetail)
	q:Sc'=0 Sc=RtnObj.Err(-1,"","明细参数解析失败!").Json()
	
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s hvm=ItmObj.%Get("RowId")
		s InvCode=ItmObj.%Get("InvCode")
		s InvNo=ItmObj.%Get("InvNo")
		s InvDate=ItmObj.%Get("InvDate")
		s InvDate=..DH2L(InvDate)

		s HvmInfo1=^DHCHVMORI(hvm,1)
		s HvmInfo2=^DHCHVMORI(hvm,2)
		s IngrFlag=$p(HvmInfo1,"^",35)
		continue:IngrFlag="Y"								;已经补录单据的,过滤
		
		s oeori=$p(HvmInfo1,"^",1)
		s ord=+oeori,chl=$p(oeori,"||",2)
		continue:(ord="")!(chl="")
		
		s ostat=$p(^OEORD(ord,"I",chl,1),"^",13)	;医嘱状态id
		s oeflag=$p(^OEC("OSTAT",ostat),"^",1)
		continue:(oeflag="C")||(oeflag="U")||(oeflag="D")	;撤销,作废,停止 的医嘱不再处理
		
		s HVMainLocId=$p(HvmInfo1,"^",42)
		continue:HVMainLocId=""
		continue:(MainLocId'="")&&(MainLocId'=HVMainLocId)
		
		s Ingr=$p($p(HvmInfo1,"^",12),"||",1)
		s IngrLoc=""
		i Ingr'="" d
		.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
		continue:(Ingr'="")&&(HVMainLocId=IngrLoc)
		
		//加锁
		s LockRet=..sssLock("User.DHCHVMatOrdItm"_hvm)
		i LockRet'=0 d RtnObj.Err(-99,"","加锁失败!") q
		
		s inci=$p(HvmInfo1,"^",34)
		s uom=$p(HvmInfo1,"^",18)
		s barcode=$p(HvmInfo1,"^",24)
		s apcvm=$p(HvmInfo1,"^",17)
		s oriuser=$p(HvmInfo1,"^",10)
		s manf=$p(HvmInfo1,"^",16)
		s admloc=$p(HvmInfo1,"^",7)
		s scg=$p(HvmInfo1,"^",11)
		s qty=$p(HvmInfo1,"^",19)
		s rp=$p(HvmInfo1,"^",20)
		s sp=$p(HvmInfo1,"^",21)
		s rpamt=$p(HvmInfo1,"^",22)
		s spamt=$p(HvmInfo1,"^",23)
		s batno=$p(HvmInfo1,"^",13)
		s expdate=$p(HvmInfo1,"^",14)
		s:expdate'="" expdate=..DL2H(expdate)
		s HVInvCode=$p(HvmInfo1,"^",46)
		s HVInvNo=$p(HvmInfo1,"^",31)
		s InvAmt=$p(HvmInfo1,"^",33)
		
		s bUomid=$p(^INCI(inci,1),"^",10)
		i bUomid'=uom d RtnObj.Err(-4,"","单位不等于基本单位","",0) q
		
		s reqloc=..GetHVInitLocByOeori(oeori,MainLocId)
		i reqloc="" d RtnObj.Err(-4,"","取出库科室错误") q

		s dhcit=$o(^DHCIT(0,"LABEL",barcode,""),-1)
		s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""),-1)
		i dhcit="" d RtnObj.Err(-3,"","取条码信息错误") q
		
		s Inclb=$p(^DHCIT(dhcit),"^",12)
		s rp=..GetRp(hvm,AppParams)
		s rpamt=rp*qty
		s:InvAmt="" InvAmt=rpamt			;缺省
		s SpecDesc=""
		i Inclb'="" d
		.s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		
		//保存发票信息
		i ((InvCode'="")||(InvNo'=""))&&((HVInvCode'=InvCode)||(HVInvNo'=InvNo)) d
		.s InvDetail="[{""RowId"":"""_hvm_""",""InvNo"":"""_InvNo_""",""InvDate"":"""_InvDate_""",""InvAmt"":"""_InvAmt_""",""VendorDr"":"""_apcvm_""",""InvCode"":"""_InvCode_"""}]"		
		.s RtnObj=..SaveInvInfo()
		q:RtnObj.success'=0
		
		//组织数据
		s newDetailObj={}
		s newDetailObj.RowId=""
		s newDetailObj.IncId=inci
		s newDetailObj.BatchNo=batno
		s newDetailObj.ExpDate=expdate
		s newDetailObj.ManfId=manf
		s newDetailObj.IngrUomId=uom
		s newDetailObj.Rp=rp
		s newDetailObj.HVBarCode=""
		s newDetailObj.RecQty=qty
		s newDetailObj.NewSp=sp
		s newDetailObj.SxNo=""
		s newDetailObj.InvNo=InvNo
		s newDetailObj.InvCode=InvCode
		s newDetailObj.InvDate=InvDate
		s newDetailObj.Inpoi=""
		s newDetailObj.Remark=""
		s newDetailObj.Remarks=""
		s newDetailObj.QualityNo=""
		s newDetailObj.MtDr=""
		s newDetailObj.SterilizedNo=""
		s newDetailObj.AdmNo=""
		s newDetailObj.AdmExpdate=""
		s newDetailObj.InvMoney=""
		s newDetailObj.SpecDesc=SpecDesc
		s newDetailObj.OrderDetailSubId=""
		s newDetailObj.reqLocId=reqloc
		s newDetailObj.Sp=sp
		s newDetailObj.Tax=""
		s nDetailObj=newDetailObj.%ToJSON()
		
		s SubStr=MainLocId_"^"_apcvm_"^"_reqloc_"^"_scg_"^"_SourceOfFund
		s ^TMP(Pid,"NightRunCreateRecHV",SubStr,hvm)=nDetailObj
	}
	
	i RtnObj.success'=0 k ^TMP(Pid,"NightRunCreateRecHV") lock  q RtnObj.Json()
	i ('$d(^TMP(Pid,"NightRunCreateRecHV"))) lock  q RtnObj.Json()
	
	ts
	s RtnObj=..CreateRecHV(Pid,gUser,"N")
	i RtnObj.success'=0 d
	.tro
	.lock
	.k ^TMP(Pid,"NightRunCreateRecHV") 
	q:RtnObj.success'=0 RtnObj.Json()
	
	tc
	lock
	k ^TMP(Pid,"NightRunCreateRecHV") 
	q RtnObj.Json()
	
CreateError
	lock	;解锁
	trollback
	k ^TMP(Pid,"NightRunCreateRecHV")
	d RtnObj.Err(-100,"","程序发生错误！")
	q RtnObj.Json()
}

ClassMethod CreateRecHV(Pid, User, NightFlag = "") As RtnObj
{
	n (Pid,User,NightFlag)
	s RtnObj=##class(RtnObj).%New()
	
	s:NightFlag="" NightFlag="N"	//夜间任务报错执行下一条，页面提取报错退出
	s AppName=..%GetParameter("AppName")
	s OeriRecflag="Y"  ;高值入库补录标志
	s TodayDate=+$h
	s InGrRemarks="高值材料补录"
	i User="" d
	.s demo="demo"
	.&sql(select %id into :User from ss_user where SSUSR_Initials = :demo)
	s ingrStr="",initStr=""
	
	s SubStr=""
	f  s SubStr=$o(^TMP(Pid,"NightRunCreateRecHV",SubStr)) q:(SubStr="")||((RtnObj.success'=0)&&(NightFlag="N"))  d
	.ts
	.//入库主单
	.s mainloc=$p(SubStr,"^",1)
	.s apcvm=$p(SubStr,"^",2)
	.s admloc=$p(SubStr,"^",3)
	.s scg=$p(SubStr,"^",4)
	.s SourceOfFund=$p(SubStr,"^",5)
	.s Params="^"_mainloc_"^^"
	.
	.s newMainInfo={}
	.s newMainInfo.IngrId=""
	.s newMainInfo.ApcvmDr=apcvm
	.s newMainInfo.RecLoc=mainloc
	.s newMainInfo.gUserId=User
	.s newMainInfo.GiftFlag=""
	.s newMainInfo.AdjCheque=""
	.s newMainInfo.IngrTypeId=""
	.s newMainInfo.PurchaseUser=""
	.s newMainInfo.StkGrpId=scg
	.s newMainInfo.PoId=""
	.s newMainInfo.InGrRemarks=InGrRemarks
	.s newMainInfo.SourceOfFund=SourceOfFund
	.s newMainInfo.ReqLocId=admloc
	.s newMainInfo.SynBarcode=""
	.s newMainInfo.InitId=""
	.s newMainInfo.AcceptUserId=""
	.s newMainInfo.OeriRecflag=OeriRecflag
	.s nMainInfo=newMainInfo.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Insert(nMainInfo)  //创建主表记录
	.i RtnObj.success'=0 tro 1 q
	.s ingr=RtnObj.rowid
	.i ingrStr="" d
	..s ingrStr=ingr
	.e  d
	..s ingrStr=ingrStr_","_ingr
	.//入库明细
	.s hvm=""
	.f  s hvm=$o(^TMP(Pid,"NightRunCreateRecHV",SubStr,hvm)) q:(hvm="")||(RtnObj.success'=0)  d
	..s listData=^TMP(Pid,"NightRunCreateRecHV",SubStr,hvm)  //明细数据
	..s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	..s Sc=DetailObj.%FromJSON(listData)
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).Update(ingr,DetailObj)  //创建入库单明细表记录
	..i RtnObj.success'=0 q
	..s ingri=RtnObj.rowid
	..&sql(update dhc_hvmat_orditm set ORI_Ingri_Modify_DR=:ingri,ORI_IngrFlag='Y',ORI_DateOfManu=:TodayDate where ori_rowid=:hvm)
	..i SQLCODE'=0 s sc=RtnObj.Err(-8,"","更新医嘱提取表错误")
	..i RtnObj.success'=0 q
	.i RtnObj.success'=0 tro 1 q
	.//入库完成
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(ingr,nMainInfo,"Y")	//2014-06-25 添加第3,4参数
	.i RtnObj.success'=0 tro 1 q
	.//是否自动审核
	.s IfAutoAuditRecInit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"IfAutoAuditRecInit",Params)
	.i IfAutoAuditRecInit="Y" d	//不进行入库审核和出库
	..//入库审核
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(ingr,nMainInfo,"Y")			//2014-06-25 添加第3,4参数
	..i RtnObj.success'=0 q
	..//出库制单
	..s RtnObj=..CreateTransferByIngr(ingr,admloc,Params)  //自动出库
	..i RtnObj.success'=0 q
	..s init=RtnObj.rowid
	..i initStr="" d
	...s initStr=init
	..e  d
	...s initStr=initStr_","_init
	..//出库审核
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(init,User,"","N")
	..i RtnObj.success'=0 q
	..//出库接收
	..s status=31
	..&sql(update DHC_InIsTrf set INIT_State=:status where %id=:init)
	..i SQLCODE<0 s sc=RtnObj.Err(-13,"","更新出库接收失败")
	..i RtnObj.success'=0 q
	...&sql(update DHC_InIsTrfItm set DHCITI_State=:status where INITI_INIT_ParRef=:init)
	..i SQLCODE<0 s sc=RtnObj.Err(-13,"","更新出库明细接收失败")
	..i RtnObj.success'=0 q
	..;跟台高值进行自动接收
	..s ret=..TransInForHVTable(init,User)
	..i ret<0 s sc=RtnObj.Err(-14,"","跟台高值进行自动接收失败")
	..i RtnObj.success'=0 q
	..;补录入库出库跟踪日志的记录
	..s ret=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordIngr(ingr)
	..i ret<0 s sc=RtnObj.Err(-15,"","补录入库出库跟踪日志的记录失败")
	..i RtnObj.success'=0 q
	.i RtnObj.success'=0 tro 1 q
	.tc
	
	i RtnObj.success=0 s RtnObj.rowid=ingrStr_"^"_initStr
	q RtnObj
}

ClassMethod CreateTransferByIngr(ingr As %String, recLoc As %String, params As %String = "") As %String
{
	n (ingr,recLoc,params,%session)
	s RtnObj=##class(RtnObj).%New()
	q:'$d(^DHCINGR(ingr)) RtnObj.Err(-1,"","入库单不存在!","",0) 
	q:recLoc="" RtnObj.Err(-2,"","出库接收科室不存在!","",0)
	
	s supplyLoc=$p(^DHCINGR(ingr),"^",13)
	s userId=$p(^DHCINGR(ingr),"^",16)
	s scg=$p(^DHCINGR(ingr),"^",28)
	s OperDesc="正常出库",OperStkType="OM"
	s HospId=..sssHospId(recLoc)
	s operType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OperDesc,"DHC_OperateType",HospId,OperStkType)
	s operType=$g(operType)
	s status=11		;出库单状态
	s stkType=..sssCode()
	s ch=$o(^DHCINGR(ingr,"GRI",0))
	s inci=$p(^(ch),"^",25)
	s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	s remark="低值材料补录"
	i hvFlag="Y" d
	.s remark="高值材料补录"
	
	s mainObj={}
	s mainObj.InitFrLoc=supplyLoc
	s mainObj.InitToLoc=recLoc
	s mainObj.OperateType=operType
	s mainObj.InitComp="Y"
	s mainObj.InitState=status
	s mainObj.InitUser=userId
	s mainObj.scg=scg
	s mainObj.stkType=stkType
	s mainObj.InitRemarks=remark
	s mainObj.InitIngr=ingr
	s mainObj.gGroupId=$p(params,"^",1)
	s mainObj.gLocId=$p(params,"^",2)
	s mainObj.gUserId=$p(params,"^",3)
	s mainObj.RowId=""
	s mainData=mainObj.%ToJSON()
	s ch=0,count=0
	s detailData="["
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
	.s inclb=$p(^(ch),"^",1)
	.s recQty=$p(^(ch),"^",4)
	.s uomDr=$p(^(ch),"^",10)
	.s Sp=$p(^(ch),"^",32)
	.s ingri=ingr_"||"_ch
	.s initiRemark=ingri		//2014-07-18 夜间处理部分,备注保存对应的ingri
	.s detailObj={}
	.s detailObj.RowId=""
	.s detailObj.Inclb=inclb
	.s detailObj.Qty=recQty
	.s detailObj.UomId=uomDr
	.s detailObj.Inrqi=""
	.s detailObj.Remark=initiRemark
	.s detailObj.Ingri=ingri
	.s detailObj.Sp=Sp
	.s detail=detailObj.%ToJSON()
	.i count=0 d
	..s detailData=detailData_detail
	.e  d
	..s detailData=detailData_","_detail
	.s count=count+1
	s detailData=detailData_"]"
	
	s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(mainData,detailData)
	q:RtnObj.success'=0 RtnObj
	
	s init=RtnObj.rowid
	s ch=0
	f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:(ch="")||(RtnObj.success'=0)  d
	.s initi=init_"||"_ch
	.s ingri=$p(^DHCINIT(init,"ITI",ch),"^",24)
	.//将initi保存到initm_Remark中. initi_remarks暂时保留
	.&sql(update DHC_INGdRecItm set initm_Remark=:initi where %id=:ingri)
	.i SQLCODE'=0 d RtnObj.Err(-3,Dsri,"将出库信息绑定到入库明细失败")
	
	q RtnObj
}

/// Descript:	补录时出库单的自动接收(仅处理跟台高值)
/// Creator:	wangjiabin
/// CreateDate:	2018-03-21
/// Input:		init
/// Output:	
/// Return:		
ClassMethod TransInForHVTable(init As %String, user As %String) As %String
{
	n (init,user)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s err=0
	s ch=0
	f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:(ch="")!(err'=0)  d
	.s initi=init_"||"_ch
	.s InitiInfo=^DHCINIT(init,"ITI",ch)
	.s qty=$p(InitiInfo,"^",1)
	.s inclb=$p(InitiInfo,"^",3)
	.s uom=$p(InitiInfo,"^",7)
	.s rp=$p(InitiInfo,"^",15)
	.s rpAmt=$p(InitiInfo,"^",16)
	.s sp=$p(InitiInfo,"^",17)
	.s spAmt=$p(InitiInfo,"^",18)
	.
	.s inci=$p(inclb,"||",1)
	.q:inci=""
	.s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	.q:TableFlag'="Y"
	.
	.s ingri=$p(InitiInfo,"^",26)
	.q:ingri=""
	.s hvm=$o(^DHCHVMORI(0,"INGRIModify",ingri,0))
	.q:hvm=""
	.
	.s HVBarCode=$p(^DHCHVMORI(hvm,1),"^",24)
	.q:HVBarCode=""
	.s DHCIT=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	.s:DHCIT="" DHCIT=$o(^DHCIT(0,"ORIGINALCODE",HVBarCode,0))
	.q:DHCIT=""
	.
	.s oeori=$p(^DHCHVMORI(hvm,1),"^",1)
	.s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	.q:(ord="")||(itm="")||'$d(^OEORD(ord,"I",itm))
	.s presc=$p(^OEORD(ord,"I",itm,1),"^",14)			;处方号
	.s OrdUserId=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	.s:OrdUserId'="" OrdUserId=$o(^SSU("SSUSR",0,"CTPCP",OrdUserId,0))
	.
	.;1.跟台高值,自动接收(K台帐)
	.s ret=##class(web.DHCSTMHUI.PCHCOLLSRela).TransInAuditYesItm(initi,user)
	.i ret'=0 s err=-1 q
	.
	.;2.跟台高值,接收后生成医嘱消减台帐
	.s qty=-qty,rpAmt=-rpAmt,spAmt=-spAmt
	.s KIntrId=$o(^DHCINTR(0,"TypePointer","K",initi,0))
	.i KIntrId'>0 s err=-2 q
	.s KInclb=$p(^DHCINTR(KIntrId),"^",7)
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(KInclb,qty)
	.i +ret<0 s err=-8 q
	.
	.s IntrTypeInfo=..sssOeoriTrType(oeori)
	.s IntrType=$p(IntrTypeInfo,"^",1)
	.s IntrData=IntrType_"^"_presc_"^"_KInclb_"^"_qty_"^"_uom_"^"_sp_"^"_OrdUserId_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(IntrData)
	.i RtnObj.success'=0 s err=-9 q
	.s OeoriIntrId=RtnObj.rowid
	.
	.;3.跟台高值,在dhc_itmtrackdetail上记录台帐id
	.s ret=##class(web.DHCSTMHUI.DHCItmTrack).UpdateDhcitIntrID(DHCIT,OeoriIntrId,IntrType,oeori)
	.s:ret'=0 err=-9 q
	.
	i err<0 q err
	q 0
}

/// Description:按参数配置取补录出库单的接收科室
/// Creator:	wangjiabin
/// CreateDate: 2017-7-31
/// Input:		医嘱rowid, 库房LocId
/// Return:		补录出库单的接收科室id
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).GetHVInitLocByOeori("3||140",153)
ClassMethod GetHVInitLocByOeori(Oeori As %String, LocId As %String) As %Library.String
{
	n (Oeori,LocId)
	s Oeord=$p(Oeori,"||",1),OeoriCh=$p(Oeori,"||",2)
	q:(Oeord="")||(OeoriCh="")||'$d(^OEORD(Oeord,"I",OeoriCh)) ""
	
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	s Param="^^^"_HospId
	s AppName=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	s RecAdmLocParam=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"RecAdmLoc",Param)
	i RecAdmLocParam=1 d
	.s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,9),"^",2)		;OEORI_AdmLoc_DR 病人就诊科室(就诊病房)
	e  i RecAdmLocParam=2  d
	.s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,7),"^",2)		;OEORI_UserDepartment_DR 医嘱录入科室
	e  i RecAdmLocParam=3  d
	.s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,1),"^",3)		;OEORI_OrdDept_DR 下医嘱科室(医生科室?)
	e  d
	.s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,3),"^",6)		;OEORI_RecDep_DR 医嘱接收科室

	q InitRecLocId
}

/// Descript:   保存/更新入库单信息(Js调用)
/// Creater:    lihui
/// CreateDate: 20180904
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).jsCancelMatRecStr(^litmp("jsCancelMatRecStr"))
ClassMethod jsCancelMatRecStr(hvmatids As %String) As %Library.String
{
	n (hvmatids)
	s $ZT=..sssError()
	ts
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelMatRecStr(hvmatids)
	i RtnObj.success'=0 tro  q RtnObj.Json() 
	tc
	q RtnObj.Json()
}

/// 批量撤销补录
/// Author: lihui
/// Date: 20171124
/// Return:	总数量,成功数量
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).CancelMatRecStr(296,541)
ClassMethod CancelMatRecStr(hvmatids As %String) As RtnObj
{
	n (hvmatids)
	s RtnObj=##class(RtnObj).%New()
	s ClientDoFlag="Y"  ;前台撤销补录不判断医嘱是否撤销lihui20180203
	s err=0
	s len=$l(hvmatids,"^")
	f i=1:1:len q:(RtnObj.success'=0)  d
	.s hvmatid=$p(hvmatids,"^",i)
	.q:'$d(^DHCHVMORI(hvmatid))
	.s oeori=$p(^DHCHVMORI(hvmatid,1),"^",1)
	.s barcode=$p(^DHCHVMORI(hvmatid,1),"^",24)
	.s OrdStatus=$p(##class(PHA.COM.Order).OeoriStat(oeori),"^",1)
	.i ((OrdStatus="C")||(OrdStatus="U")||(OrdStatus="D")) d RtnObj.Err(-1,"",oeori_"医嘱已停止或作废，不能撤销","",0) q
	.s err=##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo(oeori,barcode,ClientDoFlag)
	.i err'=0 d RtnObj.Err(-1,"撤销补录失败")
	q RtnObj
}

/// w ##class(web.DHCSTMHUI.HVMatOrdItm).GetRp(^templxt("GetRp1"),^templxt("GetRp2"))
ClassMethod GetRp(hvm, AppParams)
{
	n (hvm,AppParams)
	s LocId=$p(AppParams,"^",2)
	s HospId=$p(AppParams,"^",4)
	s:HospId="" HospId=..sssHospId(LocId)
	s AppName=..%GetParameter("AppName")
	s IfReapricale=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"IfReapricale",AppParams)
	s HvmInfo1=^DHCHVMORI(hvm,1)
	s UomDr=$p(HvmInfo1,"^",18)
	s Ingri=$p(HvmInfo1,"^",12)
	s IngrFlag = $p(HvmInfo1,"^",35)
	s IngriModify=$p(HvmInfo1,"^",36)
	s Date=$p(HvmInfo1,"^",8)
	
	
	s Barcode=$p(HvmInfo1,"^",24)
	s dhcit=$o(^DHCIT(0,"LABEL",Barcode,""),-1)
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""),-1)
	q:dhcit="" 0
	s Inclb=$p(^DHCIT(dhcit),"^",12)
	s inci=$p(^DHCIT(dhcit),"^",1)
	///按跟台开的医嘱按开医嘱价格补录20221010
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	s OeoriTableFlag="N"
	i (Ingri="")||(OriginalStatus="Table") s OeoriTableFlag="Y"
	s Rp=0
	i IngrFlag="Y" d	//已补录进价
	.s Ingr=+IngriModify
	.s IngrCh=$p(IngriModify,"||",2)
	.s Rp=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",30)
	.s IngrUomDr=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngrUomDr,UomDr)
	.s Rp=Rp/Fac
	e  i (IfReapricale=3)&&(OeoriTableFlag'="Y") d	//最新调价表进价
	.i Inclb'="" d
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inclb,+$h,UomDr,HospId)
	.e  d
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(inci,+$h,UomDr,HospId)
	e  i ((IfReapricale=2)&&(Ingri'="")) d //虚库入库进价
	.s Ingr=+Ingri
	.s IngrCh=$p(Ingri,"||",2)
	.s Rp=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",30)
	.s IngrUomDr=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(IngrUomDr,UomDr)
	.s Rp=Rp/Fac
	e  i ((IfReapricale=1)&&(OeoriTableFlag'="Y")) d //计费时调价表进价
	.i Inclb'="" d
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inclb,Date,UomDr,HospId)
	.e  d
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(inci,Date,UomDr,HospId)
	e  d				
	.s Rp=$p(HvmInfo1,"^",20)
	
	q Rp
}

/// Descript:	预审
/// 对象类型数据
ClassMethod jsAudit(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	s $ZT=..sssError()
	ts
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Audit(Main,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	预审
/// Creator:	lxt
/// CreateDate:	2020-04-21
/// Table:		DHCHVMatOrdItm
/// Input:		RowId
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).Audit("{""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}","[{""RowId"":""27"",""InvNo"":""123"",""InvDate"":""24/01/2019"",""InvAmt"":""340"",""Vendor"":""AEKTLXKJYXGS-阿尔卡特朗讯科技有限公司""}]")
ClassMethod Audit(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainPJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s UserId=MainPJObj.%Get("gUserId")
	s HospId=MainPJObj.%Get("gHospId")
	s GroupId=MainPJObj.%Get("gGroupId")
	s LodId=MainPJObj.%Get("gLocId")
	s AuditDate=+$h
	s AuditFlag="Y"

	While (RtnObj.success=0) {
		s ItmObj=PJObj.%Pop()
		q:ItmObj=""
		s RowId=ItmObj.%Get("RowId")
		&sql(update DHC_HVMat_OrdItm set ORI_AuditFlag=:AuditFlag, ORI_AuditUserDR=:UserId, ORI_AuditDate=:AuditDate where ORI_RowId=:RowId)
		i SQLCODE<0 d RtnObj.Err(-2,"","审核失败")
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// Descript:	跟台高值清点清单数据
/// Creator:	lh
/// CreateDate:	20201111
/// Table:		DHCHVMatOrdItm
/// Input:		RowId串
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.HVMatOrdItm","HVMatOrdPrint","4,5,6")
Query HVMatOrdPrint(OriIdStr As %String) As Query(ROWSPEC = "RowId,InvNo,InvDate,InvAmt:%Float,InciCode,InciDesc,DoctorDr,Doctor,OrdDate,OrdTime,Qty:%Float,UomDr,UomDesc,PaNo,PaName,Ward,Bed,PrescNo,Oeori,VendorDr,ManfDr,Vendor,Manf,Rp:%Float,BatNo,ExpDate,Sp:%Float,OrdStatus,FeeStatus,FeeAmt:%Float,AdmLocDr,AdmLoc,Date,Time,User,IngNo,DateOfManu,Canceled,DateCanceled,TimeCanceled,IngrtNo,Inci,IngrFlag,dhcit,VendorDr,SpecDesc,OriginalCode,IngriModify,IngriModifyNo,Ingri,InitRecLoc,BarCode,MainLoc,MainLocDesc,Spec,Ingr,Init,Initi,IngrModify,Model") [ SqlProc ]
{
}

ClassMethod HVMatOrdPrintExecute(ByRef qHandle As %Binary, OriIdStr As %String) As %Status
{
	n (qHandle,OriIdStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:OriIdStr="" $$$OK
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from DHC_HVMat_OrdItm where ORI_RowId in ("_OriIdStr_")"
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	d result.Execute()
	While(result.Next())
	{
		s OriRowId = result.Data("ORI_RowId")
		s BarCode=result.Data("ORI_BarCode")
		s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
		s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
		s dhcitDR=$p(^DHCIT(dhcit),"^",28)	
		s Oeori = result.Data("ORI_OEORI_DR")
		s OeoriRecLoc = $p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6)
		s Scg = result.Data("ORI_SCG_DR")
		s Ingri = result.Data("ORI_INGRI_DR")
		s Ingr=$p(Ingri,"||",1)
		s (IngNo,IngrLoc)=""
		i Ingr'="" d
		.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
		.s IngNo=$p(^DHCINGR(Ingr),"^",1)
		s MainLoc=result.Data("ORI_MainLoc_DR")
		s MainLocDesc=$s(MainLoc'="":$p(^CTLOC(MainLoc),"^",2),1:"")
		s VendorDr = result.Data("ORI_APCVM_DR")
		s Inci = result.Data("ORI_INCI_DR")
		s InciCode=$p(^INCI(Inci,1),"^",1) ;物资名称
		s InciDesc=$p(^INCI(Inci,1),"^",2) ;物资名称
		s PackChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(Inci)
		s IngrFlag = result.Data("ORI_IngrFlag")
		s OrdDate = result.Data("ORI_OEORI_Date")
		s:OrdDate'="" OrdDate=..DL2H(OrdDate)
		s OrdTime = result.Data("ORI_OEORI_Time")
		s:OrdTime'="" OrdTime=..TL2H(OrdTime)
		s FeeStatus = result.Data("ORI_FeeStatus")
		s FeeAmt = result.Data("ORI_FeeAmt")
		s AdmLocDr = result.Data("ORI_AdmLoc_DR")
		s Date = result.Data("ORI_Date")
		s Time = result.Data("ORI_Time")
		s Date=..DL2H(Date)
		s Time=..TL2H(Time)
		s UserDr = result.Data("ORI_SSUSR_DR")
		s BatNo = result.Data("ORI_BatNo")
		s ExpDate = result.Data("ORI_ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s DateOfManu = result.Data("ORI_DateOfManu")
		s:DateOfManu'="" DateOfManu=..DL2H(DateOfManu)
		s ManfDr = result.Data("ORI_MANF_DR")
		s UomDr = result.Data("ORI_Unit_DR")
		s Qty = result.Data("ORI_Qty")
		s Rp = result.Data("ORI_Rp")
		s Sp = result.Data("ORI_Sp")
		s RpAmt = result.Data("ORI_RpAmt")
		s SpAmt = result.Data("ORI_SpAmt")
		s BarCode = result.Data("ORI_BarCode")
		s Canceled = result.Data("ORI_Canceled")
		s UserCanceled = result.Data("ORI_UserCanceled_DR")
		s DateCanceled = result.Data("ORI_DateCanceled")
		s TimeCanceled = result.Data("ORI_TimeCanceled")
		s:DateCanceled'="" DateCanceled=..DL2H(DateCanceled)
		s:TimeCanceled'="" TimeCanceled=..TL2H(TimeCanceled)
		s IngrtNo = result.Data("ORI_INGRTI_DR")
		s:IngrtNo'="" IngrtNo=$p(^INGRT(+IngrtNo),"^",1)
		s InvCode = result.Data("ORI_InvCode")
		s InvNo = result.Data("ORI_InvNo")
		s InvDate = result.Data("ORI_InvDate")
		s:InvDate'="" InvDate=..DL2H(InvDate)
		s InvAmt = result.Data("ORI_InvAmt")
		s Inclb=$p(^DHCIT(dhcit),"^",12)
		s IngriModify=result.Data("ORI_Ingri_Modify_DR")
		
		s Adm=$p(^OEORD(+Oeori),"^",1)
		s Painfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(Adm)
		s PaNo=Painfo.PatNo
		s PaName=Painfo.PatName
		s Adminfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(Adm)
		s Ward=Adminfo.WardDesc
		s Bed=Adminfo.BedNo
		s OrderInfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetOeoriData(Oeori)
		s DoctorDr=OrderInfo.DoctorId
		s Doctor=OrderInfo.Doctor
		s OrdStatus=OrderInfo.StatCode
		
		//补录信息
		s InitRecLocId=..GetHVInitLocByOeori(Oeori,MainLoc)	//按参数配置取补录出库单的接收科室
		s (IngriModifyNo,IngrModify,Init,Initi,InitRecLocId)=""	//补录信息
		i +IngriModify'=0  d
		.s IngriModifyNo=$p($g(^DHCINGR(+IngriModify)),"^",1)	;补录入库单单号
		.s IngrModify=+IngriModify
		.s IngrModifych=$p(IngriModify,"||",2)
		.s Initi=$p($g(^DHCINGR(IngrModify,"GRI",IngrModifych)),"^",44) //补录出库明细id
		.s:Initi'="" Init=+Initi
		.s:Init'="" InitRecLocId=$p(^DHCINIT(Init),"^",6)	//实际补录接收科室
		s InitRecLoc=$s(InitRecLocId'="":$p(^CTLOC(InitRecLocId),"^",2),1:"")
		
		//依据配置进价取值
		s AppParams="^"_MainLoc_"^^"
		s Rp=..GetRp(OriRowId,AppParams)
		s RpAmt=Rp*Qty
		s:InvAmt="" InvAmt=RpAmt			;缺省
		
		s (Manf,Vendor,AdmLoc,User,UserCanceled,UomDesc)=""
		s:ManfDr'="" Manf=$p(^PHMNF(ManfDr),"^",2)
		s:VendorDr'="" Vendor=$p(^APC("APCVM",VendorDr),"^",3)
		i AdmLocDr'="" s AdmLoc=$p(^CTLOC(AdmLocDr),"^",2),AdmLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(AdmLoc) 
		i UserDr'="" s User=$p($g(^SSU("SSUSR",UserDr)),"^",2 )
		i UserCanceled'="" s UserCanceled=$p($g(^SSU("SSUSR",UserDr)),"^",2 )
		i UomDr'="" s UomDesc=$p($g(^CT("UOM",UomDr)),"^",2)
		s SpecDesc=$P(^DHCIT(dhcit),"^",19)
		s OriginalCode=$P(^DHCIT(dhcit),"^",13)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
		
		d OutPutRowHvMat
	}
	Quit $$$OK
OutPutRowHvMat
	s Data=$lb(OriRowId,InvNo,InvDate,InvAmt,InciCode,InciDesc,DoctorDr,Doctor,OrdDate,OrdTime,
		Qty,UomDr,UomDesc,PaNo,PaName,Ward,Bed,PrescNo,Oeori,VendorDr,
		ManfDr,Vendor,Manf,Rp,BatNo,ExpDate,Sp,OrdStatus,FeeStatus,FeeAmt,
		AdmLocDr,AdmLoc,Date,Time,User,IngNo,DateOfManu,Canceled,DateCanceled,TimeCanceled,
		IngrtNo,Inci,IngrFlag,dhcit,VendorDr,SpecDesc,OriginalCode,IngriModify,IngriModifyNo,Ingri,
		InitRecLoc,BarCode,MainLoc,MainLocDesc,Spec,Ingr,Init,Initi,IngrModify,Model)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	退货取消审核时恢复数据
/// Creator:	wxj
/// CreateDate:	20211203
ClassMethod CancelIngretNO(barcodes As %String) As %String
{
 n (barcodes)
 s cnt=$l(barcodes,"^")
 s ret=0
 f i=1:1:cnt d
 .s barcode=$p(barcodes,"^",i)
 .s date=+$h
 .&sql(update DHC_HVMat_OrdItm set  ORI_INGRTI_DR=null where ORI_BarCode=:barcode)
 .i SQLCODE<0  d 
 ..s ret=+ret-1
 q ret
}

/// Descript:	检查医嘱是否有补录入库记录
/// Creator:	wxj
/// CreateDate:	20220921
/// w ##class(web.DHCSTMHUI.HVMatOrdItm).CheckIngr("118||1")
ClassMethod CheckIngr(Dhciti As %String) As %String
{
 n (Dhciti)
 s ret=0
 s dhcita=""
 f  s dhcita=$o(^DHCITD(0,"DHCITD",Dhciti,"")) q:(dhcita="")||(ret=1)  d
 .s Type=$p(^DHCITD("IA",dhcita),"^",2)
 .s:Type="SG" ret=1
 q ret
}

}
