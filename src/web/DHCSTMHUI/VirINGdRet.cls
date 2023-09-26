Import sqluser

/// Descript:虚拟入库相关
/// Creater: XuChao
/// CreateDate: 2018-06-08
Class web.DHCSTMHUI.VirINGdRet Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTVIRIMPORTM";

/// w ##class(web.DHCSTMHUI.VirINGdRet).SaveVirtualImp(^templxt(1),^templxt(2))
ClassMethod SaveVirtualImp(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError() 
	ts
	s RtnObj=..InsMaster(Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s MainId=RtnObj.rowid
	s RtnObj=..InsRecItm(MainId,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=MainId
	q RtnObj.Json()
}

ClassMethod InsMaster(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")

	s Loc=PJObj.%Get("Loc")
	i Loc=""  q RtnObj.Err(-2,"","科室不能为空!","",0)

	s Vendor=PJObj.%Get("Vendor")
	i Vendor="" q RtnObj.Err(-3,"","供应商不能为空!","",0)
	
	s User=PJObj.%Get("gUserId")
	s ScgStk=PJObj.%Get("ScgStk")

	s Date=21550 //1900-01-01
	s StkType=..sssCode()
	s AppName=..%GetParameter("AppName")
	i ..sssLock(AppName)<0  q RtnObj.Err(-4,"","加锁失败!")
	s IngrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,ScgStk,Loc)
	i IngrNo="" d ..sssUnLock(AppName) q RtnObj.Err(-5,"","生成单号失败!")
	
	s Time=$p($h,",",2)
	s PresentFlag="N"
	s ExchangeFlag="N"
	s IngrTypeId=""
	s PurUserId=""
	s PoId=""
	s Complete="Y"
	s AuditFlag="Y"
	s StkType=..sssCode()
	//审核日期时间人员按制单信息保存
	&sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
		 INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
		 INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
		 INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR,
		 INGR_Date,INGR_Time,INGR_SSUSR_DR) 
		 values (:Vendor,:Complete,1,1,0,:IngrNo,:Loc,:User,:Date,:Time,
		 :ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:ScgStk,:AuditFlag,:StkType,:PoId,
		 :Date,:Time,:User))
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"",$ClassName()_".InsMaster:SQLCODE"_SQLCODE_":"_$g(%msg))
	.d ..sssUnLock(AppName)
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock(AppName)
	s RtnObj.rowid=%ROWID
	q RtnObj
}

ClassMethod InsRecItm(MainId As %String, Detail As %String) As RtnObj
{
	n (MainId,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	i MainId="" q RtnObj.Err(-1,"","Id不能为空!","",0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Inclb=Obj.%Get("Inclb")
		s Uom=Obj.%Get("Uom")
		s Qty=Obj.%Get("Qty")
		&sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate 
			into :BatNo,:ExpDate 
			from inc_itmlcbt where inclb_rowid=:Inclb)
		s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
		&sql(SELECT INCIB_Rp, INCIB_RpPuruom, INCIB_PHMNF_Dr, INCIB_SourceOfFund 
			into :Rp,:PRp,:Manf,:Source 
			FROM DHC_IncItmBat WHERE INCIB_INCIB_Dr=:Incib)
		s Inci=+Inclb
		s NewSp=0
		s SxNo=""
		s InvNo=""
		s InvDate=""
		s PoItmId=""
		s Remark=""
		s Remarks=""
		s QualityNo=""
		s MtDr=""
		s BUom=$p(^INCI(Inci,1),"^",10)
		s IncDesc=$p(^INCI(Inci,1),"^",2)
		s Chl=1+$o(^DHCINGR(MainId,"GRI",""),-1)
		s Loc=$p(^DHCINGR(MainId),"^",13)
		s HospId=$p(^CTLOC(Loc),"^",22)
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,Uom,HospId)  ;格式化后的售价
		i Uom=BUom d
		.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,2)
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
		e  d
		.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,1)
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PRp,HospId,1)
		s SpAmt=Sp*Qty
		s RpAmt=Rp*Qty
		s NewSpAmt=NewSp*Qty
		s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
		s NewSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
		s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
		s Margin=NewSp/Rp-1
		s InvAmt=RpAmt
		s Remarks=$lfs(Remarks)
		&sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR, 
			INGRI_CTUOM_DR,INGRI_ExpDate,INGRI_INCLB_DR,INGRI_Margin,INGRI_RecQty, INGRI_StkDesc,initm_INCI_DR, initm_invmoney, 
			initm_invno, initm_phmnf_dr, initm_realprice,initm_realtotal, initm_saleprice, initm_invdate, 
			initm_BatPrice, initm_sxno,initm_newSp, initm_newSpAmt,initm_SpAmt,INGRI_INPOI_DR,initm_Remark,
			INGRI_Remarks,initm_QualityNo,initm_MT_Dr) 
			VALUES(:MainId, :Chl, :BatNo, :Loc,:Uom,:ExpDate,:Inclb,:Margin,:Qty,:IncDesc,
			:Inci, :InvAmt,:InvNo,:Manf,:Rp,:RpAmt,:Sp,:InvDate,:Rp,:SxNo,:NewSp,
			:NewSpAmt,:SpAmt,:PoItmId,:Remark,:Remarks,:QualityNo,:MtDr))
		i SQLCODE'=0  d RtnObj.Err(-3,"",$ClassName()_".InsRecItm:SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		s Ingri=%ROWID
		s RtnObj=..InsTrans(Ingri)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// 生成台帐记录
/// -114 保存台帐失败; -115 更新台帐时间失败
ClassMethod InsTrans(dhcingri As %String) As RtnObj
{
	n (dhcingri)
	s RtnObj=##class(RtnObj).%New()
	q:dhcingri="" RtnObj
	
	s DHCINGR=$p(dhcingri,"||",1)
	s CH=$p(dhcingri,"||",2)
	s type="G"
	s grno=$p(^DHCINGR(DHCINGR),"^",1)
	s inclb=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",1)
	s recqty=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",4)
	s recuom=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",10)
	s inci=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",25)
	s incicode=$P(^INCI(inci,1),"^",1)
	s sprice=$p(^DHCINGR(DHCINGR,"GRI",CH),"^",32)
	s auditUser=$p(^DHCINGR(DHCINGR),"^",8)
	s detRowid=dhcingri
	s transData=type_"^"_grno_"^"_inclb_"^"_recqty_"^"_recuom_"^"_sprice_"^"_auditUser_"^"_detRowid_"^"_"0"_"^"_"0"_"^"_"0"
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(transData)
	q:RtnObj.success'=0 RtnObj
	s IntrRowId=RtnObj.rowid
	//由于上述函数的日期使用的是当前日期,以下修改为入库日期
	s ingrdate=21550 //1900-01-01
	i IntrRowId>0 d
	. &sql(update dhc_intrans set intr_date=:ingrdate where intr_rowid=:IntrRowId)
	. i SQLCODE<0 d RtnObj.Err(-3,RowId,"更新台账日期失败")
	
	q RtnObj
}

ClassMethod Select(Ingr As %String) As %String
{
	n (Ingr)
	q:+Ingr=0 ""
	
	s StkType=$p(^DHCINGR(Ingr),"^",30)
	q:StkType'=..sssCode() ""
	
	S InGrNo =$p(^DHCINGR(Ingr),"^",1)
	S ApcvmDr =$p(^DHCINGR(Ingr),"^",3)
	s (Vendor,AuditUser,PoNo,LocDesc,CreateUser,IngrType,PurUser,ReqLoc,AcceptUser,TreasureUser,StkGrp)=""
	s:ApcvmDr'="" Vendor=$p(^APC("APCVM",ApcvmDr),"^",3)
	s AuditDate=$p(^DHCINGR(Ingr),"^",4)
	s AuditDate=..DL2H(AuditDate)
	s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
	s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
	s AuditTime=$p(^DHCINGR(Ingr),"^",9)
	s AuditTime=..TL2H(AuditTime)
	s PoId=$p(^DHCINGR(Ingr),"^",11)
	s:PoId'="" PoNo=$p(^INPO(PoId),"^",1)
	s Complete=$p(^DHCINGR(Ingr),"^",12)
	s LocId=$p(^DHCINGR(Ingr),"^",13)
	s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
	s CreateDate=$p(^DHCINGR(Ingr),"^",14)
	s CreateDate=..DL2H(CreateDate)
	s CreateTime=$p(^DHCINGR(Ingr),"^",15)
	s CreateTime=..TL2H(CreateTime)
	s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
	s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
	s PayAllowed=$p(^DHCINGR(Ingr),"^",22)   ;是否允许付款
	s IngrTypeId=$p(^DHCINGR(Ingr),"^",23)
	s:IngrTypeId'="" IngrType=$p(^DHCOPTYPE(IngrTypeId),"^",2)
	s PurUserId=$p(^DHCINGR(Ingr),"^",24)
	s:PurUserId'="" PurUser=$p(^SSU("SSUSR",PurUserId),"^",2)
	s ReqLocId=$p(^DHCINGR(Ingr),"^",25)
	s:ReqLocId'="" ReqLoc=$p(^CTLOC(ReqLocId),"^",2)
	s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
	s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
	s TreasureUserId=$p(^DHCINGR(Ingr),"^",27)
	s:TreasureUserId'="" TreasureUser=$p(^SSU("SSUSR",TreasureUserId),"^",2)
	s StkGrpId=$p(^DHCINGR(Ingr),"^",28)
	s StkGrp=""
	s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
	s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	s GiftFlag=$p(^DHCINGR(Ingr),"^",31)
	s AdjCheque=$p(^DHCINGR(Ingr),"^",32)
	s Data1=InGrNo_"^"_ApcvmDr_"^"_Vendor_"^"_AuditDate_"^"_AuditUserId_"^"_AuditUser
	s Data2=AuditTime_"^"_PoId_"^"_PoNo_"^"_Complete_"^"_LocId_"^"_LocDesc
	s Data3=CreateDate_"^"_CreateTime_"^"_CreateUserId_"^"_CreateUser_"^"_PayAllowed_"^"_IngrTypeId
	s Data4=IngrType_"^"_PurUserId_"^"_PurUser_"^"_ReqLocId_"^"_ReqLoc_"^"_AcceptUserId
	s Data5=AcceptUser_"^"_TreasureUserId_"^"_TreasureUser_"^"_StkGrpId_"^"_StkGrp_"^"_AuditFlag
	s Data6=GiftFlag_"^"_AdjCheque
	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
	
	s Title1="No^Vendor^VendorDesc^AuditDate^AuditUserId^AuditUser"
	s Title2="AuditTime^PoId^PoNo^Complete^Loc^LocDesc"
	s Title3="Date^Time^User^UserName^PayAllowed^IngrTypeId"
	s Title4="IngrType^PurUserId^PurUser^ReqLocId^ReqLoc^AcceptUserId"
	s Title5="AcceptUser^TreasureUserId^TreasureUser^ScgStk^StkGrp^AuditFlag"
	s Title6="GiftFlag^AdjCheque"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6
	
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

Query QueryIngri(Ingr As %String) As Query(ROWSPEC = "RowId,BatNo,Uom,UomDesc,ExpDate,Inclb,Inpoi,Margin,Qty,Remarks,Inci,Code,Description,InvMoney,InvNo,PayNo,ManfId,Manf,Rp,RpAmt,Sp,SpAmt,InvDate,BatRp,QualityNo,SxNo,Remark,NewSp,NewSpAmt,MtDr,MtDesc,PubBL,PubDesc,BUomId,ConFac,CheckPort,CheckRepNo,CheckRepDate,AdmNo,AdmExpdate,CheckPack,Spec,InclbQty,BatExp") [ SqlProc ]
{
}

ClassMethod QueryIngriExecute(ByRef qHandle As %Binary, Ingr As %String) As %Status
{
	n (qHandle,Ingr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Ingr="" $$$OK
	
	s StrSql = "SELECT INGRI_Rowid as RowId, INGRI_BatchNo, INGRI_CTUOM_DR, INGRI_ExpDate,"
		_"INGRI_INCLB_DR, INGRI_INPOI_DR, INGRI_Margin, INGRI_RecQty,INGRI_Remarks, "
		_"initm_INCI_DR,initm_INCI_DR->INCI_Code as IncCode,initm_INCI_DR->INCI_Desc as IncDesc,"
		_"initm_invmoney, initm_invno, initm_payno, initm_phmnf_dr,initm_phmnf_dr->PHMNF_Name as ManfDesc,"
		_"initm_realprice,initm_realtotal,initm_saleprice, initm_SpAmt, initm_invdate, initm_BatPrice,"
		_"initm_QualityNo,initm_sxno,initm_Remark,initm_newSp,initm_newSpAmt,initm_MT_Dr,initm_PubBL, "
		_"initm_CheckPort,initm_CheckRepNo,initm_CheckRepDate,initm_AdmNo,initm_AdmExpdate,initm_CheckPack "
		_"FROM DHC_INGdRecItm WHERE INGRI_INGR_ParRef= "_Ingr
		
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s (UomDesc,BatExp,MtDesc,PubDesc)=""
		s Ingri = result.Data("RowId")
		s BatNo = result.Data("INGRI_BatchNo")
		s Uom = result.Data("INGRI_CTUOM_DR")
		s UomDesc=""
		s:Uom'="" UomDesc=$p(^CT("UOM",Uom),"^",2)
		s ExpDate=result.Data("INGRI_ExpDate")
		s ExpDate=..DL2H(ExpDate)
		i (BatNo'="") s BatExp=BatNo
		s BatExp=BatExp_"~"_ExpDate 
		s Inclb=result.Data("INGRI_INCLB_DR")
		s Inpoi=result.Data("INGRI_INPOI_DR")
		s RecQty = result.Data("INGRI_RecQty")
		s Remarks = result.Data("INGRI_Remarks")
		s Remarks=$LTS(Remarks)
		s Inci = result.Data("initm_INCI_DR")
		s Code = result.Data("IncCode")
		s Description = result.Data("IncDesc")
		s InvMoney = result.Data("initm_invmoney")
		s InvNo = result.Data("initm_invno")
		s PayNo = result.Data("initm_payno")
		s Manf = result.Data("initm_phmnf_dr")
		s ManfDesc = result.Data("ManfDesc")
		s Rp = result.Data("initm_realprice")
		s RpAmt = result.Data("initm_realtotal")
		s Sp = result.Data("initm_saleprice")
		s SpAmt = result.Data("initm_SpAmt")
		s Margin=SpAmt-RpAmt
		s InvDate = result.Data("initm_invdate")
		s InvDate=..DL2H(InvDate)
		s BatRp = result.Data("initm_BatPrice")
		s QualityNo = result.Data("initm_QualityNo")
		s SxNo = result.Data("initm_sxno")
		s Remark = result.Data("initm_Remark")     ;摘要
		s NewSp = result.Data("initm_newSp")
		s NewSpAmt = result.Data("initm_newSpAmt")
		s MtDr = result.Data("initm_MT_Dr")      ;定价类型
		s MtDesc=""
		s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
		s PubBL = result.Data("initm_PubBL")            ;招标轮次
		s CheckPort=result.Data("initm_CheckPort")      ;检测口岸
		s CheckRepNo=result.Data("initm_CheckRepNo")    ;检测报告
		s CheckRepDate=result.Data("initm_CheckRepDate")    ;报告日期
		s CheckRepDate=..DL2H(CheckRepDate)
		s AdmNo=result.Data("initm_AdmNo")                  ;注册证号
		s AdmExpdate=result.Data("initm_AdmExpdate")        ;注册证有效期
		s AdmExpdate=..DL2H(AdmExpdate)
		s CheckPack=result.Data("initm_CheckPack")          ;包装合格
		s PubDesc=""
		s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s PurUomId=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)  
		s InclbQty=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
		d OutPutRow 
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(Ingri,BatNo,Uom,UomDesc,ExpDate,Inclb,Inpoi,Margin,RecQty,Remarks,Inci,Code,Description,InvMoney,InvNo,PayNo,Manf,ManfDesc,Rp,RpAmt,Sp,SpAmt,InvDate,BatRp,QualityNo,SxNo,Remark,NewSp,NewSpAmt,MtDr,MtDesc,PubBL,PubDesc,BUomId,ConFac,CheckPort,CheckRepNo,CheckRepDate,AdmNo,AdmExpdate,CheckPack,Spec,InclbQty,BatExp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
