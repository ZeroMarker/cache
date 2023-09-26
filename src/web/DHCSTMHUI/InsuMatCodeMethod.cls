Class web.DHCSTMHUI.InsuMatCodeMethod Extends %RegisteredObject
{

/// HIS的版本--0：8.3之前版本,1:8.3以及之后版本,2:8.5以及之后版本
/// 老版本所有报表品种通用名的取法：先取化学通用名->原料通用名->处方通用名->库存项名称
Parameter PHAVERSION = 2;

/// 8.1.2.1【3501】商品盘存上传
ClassMethod Method3501(Inst, Pid, OutRowId, ExpDataAry As %DynamicArray)
{
	q:Inst="" ""
	s InstDate=$p(^DHCINST(Inst),"^",2)
	s Instloc=$p(^DHCINST(Inst),"^",5)
	s hospdr=$P(^CTLOC(Instloc),"^",22)
	s invdate=$zd(InstDate,3)
	s fixmedinsStr=..GetfixmedinsStr(.ExpDataAry)
	s fixmedinshilistid=$p(fixmedinsStr,"^",4)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	s fixmedinshilistname=$p(fixmedinsStr,"^",3)						//fixmedins_hilist_name 	定点医药机构目录名称 Y
	s ChiSub=0
	f  s ChiSub=$o(^DHCINST(Inst,"STI",ChiSub)) q:ChiSub=""  d
	.s SubData=^DHCINST(Inst,"STI",ChiSub)
	.s IndexRowId=Inst_"||"_ChiSub
	.q:(OutRowId'="")&&(IndexRowId'=OutRowId)
	.s inclb=$p(SubData,"^",1)
	.s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s invcnt=$p(SubData,"^",5)											//inv_cnt 	库存数量 Y 	
	.s Inci=$p(SubData,"^",18)
	.s IngrSub=..GetIngrtSubByClb(inclb)
	.q:IngrSub=""
	.s prodstoinid =incib   											//prod_stoin_id	商品入库记录主键, 院内惟一		 Y                 
	.s inciStr=..GetInsuInfoByCode(+inclb,hospdr)	
	.s medlistcodg=$p(inciStr,"^",1)
	.s medlistcodg=..GetInciDesc(medlistcodg)
	.s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	.s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	.s fixmedinsbchno=inclb             								//fixmedins_bchno 	批次流水号 
	.s batstr=..GetBatStr(incib)
 	.s manulotnum=$p($g(batstr),"^",1)										 //manu_lotnum 	生产批号		                            		
 	.s expyend=$p($g(batstr),"^",2)											//expy_end 	有效期止			
 	.s manudate=+$p(^DHCINGR(+IngrSub,"GRI",$p(IngrSub,"||",2)),"^",49)		//manu_date 	生产日期
 	.i manudate'="0" s manudate=$zd(manudate,3)
 	.i manudate=0 s manudate=$zd(($p(^DHCINGR(+IngrSub),"^",4)-300),3) 													
	.s pric=$p(SubData,"^",30)						//pric	单价	 Y      							       			
	.s splercode=$p(..GetVendorStr($p(^DHCINGR(+IngrSub),"^",3)),"^",1)                  //spler_code	供应商编码
	.s splername=$p(..GetVendorStr($p(^DHCINGR(+IngrSub),"^",3)),"^",2)                   //spler_name	供应商名称	
	.s rxflag=..GetInciRecFlag(Inci)		
	.s memo=""						//memo 	备注
	.s pric=..AddZero(pric)	
	.s intrData1=medlistcodg_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_rxflag_"^"_invdate
	.s intrData2=invcnt_"^"_manulotnum_"^"_fixmedinsbchno_"^"_manudate_"^"_expyend
	.s intrData3=memo_"^"_IndexRowId
	.s intrData=intrData1_"^"_intrData2_"^"_intrData3
	.s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3501",Pid,Inst,ChiSub)=intrData
	Q Pid
}

/// 101 	调拨入库   K 		105 	销毁  		D
/// 102 	调拨出库   T		106 	其他入库 
/// 103 	盘盈 	   A		107 	其他出库 	R
/// 104 	盘损 	   A		108 	初始化入库	 G
/// 8.1.2.3【3502】商品库存变更(除发药退药)
ClassMethod Method3502(calcuDate, Pid, OutRowId, ExpDataAry As %DynamicArray, ghospid)
{
	s fixmedinsStr=..GetfixmedinsStr(.ExpDataAry)
	s fixmedinshilistid=$p(fixmedinsStr,"^",4)				//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	s fixmedinshilistname=$p(fixmedinsStr,"^",3)			//fixmedins_hilist_name 	定点医药机构目录名称 Y
    s count=0
    s typeStr="A^D^T^K"     ;
    s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate",type,calcuDate,intr)) q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..q:inclb=""
	..s LocID=$$LOC^ST01(inclb)
	..s hospdr=$P(^CTLOC(LocID),"^",22)
	..q:hospdr'=ghospid
	..s IndexRowId=intr
	..q:(OutRowId'="")&&(IndexRowId'=OutRowId)
	..s TmpGrpInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(+inclb)
	..s TmpGrpType=$p(TmpGrpInfo,"^",3)
	..q:TmpGrpType'="M"
	..s pointer=$p(^DHCINTR(intr),"^",9)
	..i type="A"  d
	...s Qty=$p(^DHCINTR(intr),"^",6)
	...i Qty>=0 s invchgtype="103"
	...e  s invchgtype="104"
	..e  i type="D"  d
	...s invchgtype="105"
	..e  i type="T"  d
	...s invchgtype="102"
	..e  i type="K"  d
	...s invchgtype="101"
	..e  i type="G"  d
	...s invchgtype="108"
	..e  i type="R"  d
	...s invchgtype="107"						//inv_chg_type 	库存变更类型 
	..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..s Inci=+inclb
    ..s AuditUserId=$p(^DHCINTR(intr),"^",11)
    ..s AuditUser=""
    ..s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    ..s AuditDate=$p(^DHCINTR(intr),"^",2)
    ..s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    ..s AuditTime=$p(^DHCINTR(intr),"^",3)
    ..s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
    ..s selretncnt=-$p(^DHCINTR(intr),"^",6)						//sel_retn_cnt 	销售/退货数量  Y
	..s selretntime =AuditDate_" "_AuditTime						//sel_retn_time 	销售/退货时间  Y
	..s selretnoptername=AuditUser									//sel_retn_opter_name 	销售/退货经办人姓名  Y			
	..s inciStr=..GetInsuInfoByCode(+inclb)	
	..s medlistcodg=$p(inciStr,"^",1)
	..s fixmedinsbchno=inclb             							//fixmedins_bchno 	批次流水号  (按照台账id取值)
	..s pric=$p(^DHCINTR(intr),"^",16)								//pric	单价
	..s cnt=$p(^DHCINTR(intr),"^",6)   								//cnt 	数量 
	..i cnt<0 s cnt=(-1)*cnt
	..s invchgtime=AuditDate_" "_AuditTime					//inv_chg_time 	库存变更时间 
	..s invchgoptername=AuditUser			//inv_chg_opter_name 	库存变更经办人姓名 
	..s prodstoinid = incib 
	..s rxflag=..GetInciRecFlag(Inci)	
	..s trdnflag="N"
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..i BUomId'=PurUomId s trdnflag="Y"
	..s Uom=$p(^DHCINTR(intr),"^",10)
	..s Fac2=..UOMFac(Uom,BUomId)
	..s cnt=cnt*Fac2
	..s pric=$fn(pric/Fac2,"",6)
	..s pric=..AddZero(pric)	
	..s memo=""						//memo 	备注
	..s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	..s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	..s intrData1=medlistcodg_"^"_invchgtype_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_fixmedinsbchno
	..s intrData2=pric_"^"_cnt_"^"_rxflag_"^"_invchgtime_"^"_invchgoptername
	..s intrData3=memo_"^"_trdnflag_"^"_IndexRowId
	..s intrData=intrData1_"^"_intrData2_"^"_intrData3
	..s count=count+1
	..s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3502",Pid,calcuDate,count)=intrData
	Q Pid
}

/// 8.1.2.4【3503】商品采购
ClassMethod Method3503(Ingr, Pid, OutRowId, ExpDataAry As %DynamicArray, HospId = "")
{
	q:Ingr="" ""
	s fixmedinsStr=..GetfixmedinsStr(.ExpDataAry)
	s fixmedinshilistid=$p(fixmedinsStr,"^",4)				//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	s fixmedinshilistname=$p(fixmedinsStr,"^",3)			//fixmedins_hilist_name 	定点医药机构目录名称 Y
	s AuditDate=$p(^DHCINGR(Ingr),"^",4)
    s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    s AuditTime=$p(^DHCINGR(Ingr),"^",9)
    s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
    s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
    s AuditUser="",AcceptUser=""
    s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
    s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
    s CreateDate=$p(^DHCINGR(Ingr),"^",14)
    s:+CreateDate'=0 CreateDate=..DateLogicalToHtml(CreateDate,"ST")
    s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
    s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
    i AcceptUser="" s AcceptUser=CreateUser
	s ChiSub=""
 	f  s ChiSub=$o(^DHCINGR(Ingr,"GRI",ChiSub)) q:ChiSub=""  d
 	.s SubData=^DHCINGR(Ingr,"GRI",ChiSub)
 	.s IndexRowId=Ingr_"||"_ChiSub
	.q:(OutRowId'="")&&(IndexRowId'=OutRowId)
	.s inclb=$p(SubData,"^",1)
	.s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s Inci=$p(SubData,"^",25)
	.s prodstoinid = incib 			//prod_stoin_id	商品入库记录主键, 院内惟一
	.s inciStr=..GetInsuInfoByCode(Inci,HospId)	
	.s medlistcodg=$p(inciStr,"^",1)
	.s fixmedinsbchno=inclb           //fixmedins_bchno 	批次流水号  
	.s manulotnum=$p(SubData,"^",13)                 //manu_lotnum 	生产批号
	.s aprvno=..GetInciRemark(Inci)			          //aprvno 	批准文号
	.s manudate=+$p(SubData,"^",49) 						
 	.i manudate'="0" s manudate=$zd(manudate,3)
 	.i manudate=0 s manudate=$zd(($p(^DHCINGR(Ingr),"^",4)-300),3)	//manu_date 	生产日期			
	.s expyend=+$p(SubData,"^",9)								//expy_end 	有效期止
 	.i expyend'="0" s expyend=$zd(expyend,3)				
	.s finltrnspric=$p(SubData,"^",32)				//finl_trns_pric 	最终成交单价 
	.s purcretncnt=$p(SubData,"^",4)				//purc_retn_cnt 	采购/退货数量 
	.s UomId=$p(SubData,"^",10)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac2=..UOMFac(UomId,BUomId)
	.s purcretncnt=purcretncnt*Fac2
	.s finltrnspric=$fn(finltrnspric/Fac2,"",6)
	.s finltrnspric=..AddZero(finltrnspric)
	.s rxflag=..GetInciRecFlag(Inci)
	.s purcinvono = $p(SubData,"^",27)
	.i purcinvono="" s purcinvono="-"
	.s purcinvocodg = $p(SubData,"^",27)
	.s:purcinvocodg="" purcinvocodg="-"
	.s purcretncnt=purcretncnt
    .s purcretnstointime=AuditDate_" "_AuditTime										//purc_retn_stointime 	采购/退货入库时间
	.s purcretnoptername=AuditUser														//purc_retn_optername 	采购/退货经办人姓名 
	.s inspperson=AcceptUser															//inspperson	入库验收员
	.s inspdate=CreateDate																//inspdate	入库验收日期
	.s VendorId=$p(^DHCINGR(Ingr),"^",3)
	.s VendorStr=..GetVendorStr(VendorId)
	.s splercode=$p(VendorStr,"^",1)                  									//spler_code	供应商编码
	.s splername=$p(VendorStr,"^",2)                   									//spler_na
	.s splerpmtno=$p(VendorStr,"^",3)												//spler_pmtno 	供应商许可证号
	.s manufacturer=""                  												 //manufacturer	产地
 	.i $p(SubData,"^",29)'="" s manufacturer=$P($g(^PHMNF($p(SubData,"^",29))),"^",2)				
	.s dyntno=$p(SubData,"^",38)														//dynt_no 	随货单号 
	.s prodgeayflag =$p(^DHCINGR(Ingr),"^",31)											//prod_geay_flag 	商品赠送标志 
	.s memo=""	
	.s spec=##class(web.DHCSTM.Common.DrugInfoCommon).GetSpec("",+inclb)
	.s:spec="" spec="-"
	.s buomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s uomDesc=$p(^CT("UOM",UomId),"^",2)																	//memo 	备注
	.s barcode=$p($g(^INCI(Inci,3)),"^",9)                    							//barcode	商品条码
	.s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	.s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	.s intrData1=medlistcodg_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_dyntno_"^"_fixmedinsbchno
	.s intrData2=splername_"^"_splerpmtno_"^"_manulotnum_"^"_manufacturer_"^"_aprvno
	.s intrData3=manudate_"^"_expyend_"^"_finltrnspric_"^"_purcretncnt_"^"_purcinvocodg
	.s intrData4=purcinvono_"^"_rxflag_"^"_purcretnstointime_"^"_purcretnoptername_"^"_prodgeayflag
	.s intrData5=memo_"^"_spec_"^"_buomDesc_"^"_uomDesc_"^"_Fac2_"^"_finltrnspric
	.s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4_"^"_intrData5_"^"_IndexRo
	
	.s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3503",Pid,Ingr,ChiSub)=intrData
	Q Pid
}

/// 8.1.2.5【3504】商品采购退货
ClassMethod Method3504(Ingrt, Pid, OutRowId, ExpDataAry As %DynamicArray, HospId = "")
{
	q:Ingrt="" ""
	s fixmedinsStr=..GetfixmedinsStr(.ExpDataAry)
	s fixmedinshilistid=$p(fixmedinsStr,"^",4)				//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	s fixmedinshilistname=$p(fixmedinsStr,"^",3)			//fixmedins_hilist_name 	定点医药机构目录名称 Y
	s storeStorageCode=$p(^INGRT(Ingrt),"^",1)
	s CreateDate=$p(^INGRT(Ingrt),"^",3)
    s:+CreateDate'=0 CreateDate=..DateLogicalToHtml(CreateDate)
	s CreateTime=$p(^INGRT(Ingrt),"^",4)
    s:+CreateTime'=0 CreateTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CreateTime,"ST")
	s purcretnstointime=CreateDate_" "_CreateTime			//purc_retn_stointime 	采购/退货入库时间
	s AuditDate=$p(^INGRT(Ingrt),"^",9)
    s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    s checkdate=AuditDate									//checkdate	采购退回出库复核日期
    s CreateUserId=$p(^INGRT(Ingrt),"^",5)
    s CreateUser=""
    s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
    s purcretnoptername=CreateUser						//purc_retn_optername 	采购/退货经办人姓名 
    s AuditUserId=$p(^INGRT(Ingrt),"^",8)
    s AuditUser=""
    s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s checkperson=AuditUser								//checkperson	采购退回出库复核人
   
	s ChiSub=""
 	f  s ChiSub=$o(^INGRT(Ingrt,"DHCGRR",ChiSub)) q:ChiSub=""  d
 	.s IngrSub=$p(^INGRT(Ingrt,"DHCGRR",ChiSub),"^",1)
 	.s prodretnid =Ingrt_"||"_ChiSub
 	.s IndexRowId=Ingrt_"||"_ChiSub
	.q:(OutRowId'="")&&(IndexRowId'=OutRowId)
 	.s SubData=^DHCINGR(+IngrSub,"GRI",$P(IngrSub,"||",2))
	.s inclb=$p(SubData,"^",1)
	.s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s Inci=$p(SubData,"^",25)
	.s inciStr=..GetInsuInfoByCode(Inci,HospId)	
	.s medlistcodg=$p(inciStr,"^",1)
	.s fixmedinsbchno=inclb  	//fixmedins_bchno 	批次流水号  
	.s manulotnum=$p(SubData,"^",13)                					 //manu_lotnum 	生产批号
	.s aprvno=..GetInciRemark(Inci)			         					 //aprvno 	批准文号
	.s manudate=+$p(SubData,"^",49) 						
 	.i manudate'="0" s manudate=$zd(manudate,3)
 	.i manudate=0 s manudate=$zd(($p(^DHCINGR(+IngrSub),"^",4)-300),3)	//manu_date 	生产日期			
	.s expyend=+$p(SubData,"^",9)								//expy_end 	有效期止
 	.i expyend'="0" s expyend=$zd(expyend,3)			
	.s finltrnspric =$p(^INGRT(Ingrt,"DHCGRR",ChiSub),"^",8)														//finl_trns_pric 	最终成交单价 
	.s purcretncnt=$p(^INGRT(Ingrt,"DHCGRR",ChiSub),"^",2)	 		//purc_retn_cnt 	采购/退货数量 		
	.s UomId=$p(SubData,"^",3)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s rxflag=..GetInciRecFlag(Inci)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s purcretncnt=purcretncnt*Fac	
	.s finltrnspric=$fn(finltrnspric/Fac,"",6)
	.s finltrnspric=..AddZero(finltrnspric)	
	.s purcinvocodg =$p(^INGRT(Ingrt,"DHCGRR",ChiSub),"^",12)					//purc_invo_codg 	采购发票编码
	.i purcinvocodg="" s purcinvono="-" 
	.s purcinvono=$p(^INGRT(Ingrt,"DHCGRR",ChiSub),"^",12)											//purc_invo_no 	采购发票号 
	.i purcinvono="" s purcinvono="-"
	.s barcode=$p($g(^INCI(Inci,3)),"^",9)                   						 //barcode	商品条码
	.s splercode=$p(..GetVendorStr($p(^DHCINGR(+IngrSub),"^",3)),"^",1)                  //spler_code	供应商编码
	.s splername=$p(..GetVendorStr($p(^DHCINGR(+IngrSub),"^",3)),"^",2)                  //spler_name	供应商名称
	.s splerpmtno=$p(..GetVendorStr($p(^DHCINGR(+IngrSub),"^",3)),"^",3)				//spler_pmtno 	供应商许可证号
	.s manufacturer=""                  										 	//manufacturer	产地
 	.i $p(SubData,"^",29)'="" s manufacturer=$P($g(^PHMNF($p(SubData,"^",29))),"^",2)
	.s memo=""	
	.s:manufacturer="" manufacturer="-"
	.s spec=##class(web.DHCSTM.Common.DrugInfoCommon).GetSpec("",+inclb)
	.s:spec="" spec="-"
	.s buomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s uomDesc=$p(^CT("UOM",UomId),"^",2)																			//memo 	备注
	.s medinsprodpurcno=$p(^DHCINGR(+IngrSub),"^",1)	
	.s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	.s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	.s intrData1=medlistcodg_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_fixmedinsbchno_"^"_splername
	.s intrData2=splerpmtno_"^"_manudate_"^"_expyend_"^"_finltrnspric_"^"_purcretncnt
	.s intrData3=purcinvocodg_"^"_purcinvono_"^"_rxflag_"^"_purcretnstointime_"^"_purcretnoptername
	.s intrData4=memo_"^"_medinsprodpurcno_"^"_spec_"^"_buomDesc_"^"_Fac_"^"_uomDesc_"^"_manufacturer_"^"_finltrnspric
	.s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4_"^"_IndexRowId
	.s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3504",Pid,Ingrt,ChiSub)=intrData
	Q Pid
}

/// 8.1.2.8【3505】商品销售
ClassMethod Method3505(calcuDate, Pid, HospId, OutRowId, ExpDataAry As %DynamicArray)
{
    s count=0
    s prodtype="2"      			//prod_type	商品类型	Y
    s typeStr="P^F^MP^MF"
    s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate",type,calcuDate,intr)) q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..s IndexRowId=intr
	..q:(OutRowId'="")&&(IndexRowId'=OutRowId)
	..q:inclb=""
	..s LocID=$$LOC^ST01(inclb)
	..s hospdr=$P(^CTLOC(LocID),"^",22)
	..q:HospId'=hospdr
	
	..s Incil=$p(inclb,"||",1,2)
	..s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..s Inci=+inclb
	..s TmpGrpInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	..s TmpGrpType=$p(TmpGrpInfo,"^",3)
	..q:TmpGrpType'="M"
    ..s AuditUserId=$p(^DHCINTR(intr),"^",11)
    ..s AuditDate=$p(^DHCINTR(intr),"^",2)
    ..s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    ..s AuditTime=$p(^DHCINTR(intr),"^",3)
    ..s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
	..s prodsalid =intr   											//prod_sal_id	商品销售记录主键, 院内惟一 Y
	..s prodstoinid =incib   										//prod_stoin_id	商品入库记录主键, 院内惟一 Y
	..s inciStr=..GetInsuInfoByCode(Inci)	
	..s medlistcodg=$p(inciStr,"^",1)
	..;s orditm=..GetTransOrdItem(intr)
	..s oeori=$p(^DHCINTR(intr),"^",9) 
	..;q:+orditm=0
	
	..s fixmedinsbchno=inclb    ;intr             					//fixmedins_bchno 	批次流水号   
	..s doctorStr=..OeoriDoctorStr(oeori)
	..s prscdrcerttype=$p(doctorStr,"^",3)								//prsc_dr_cert_type 	开方医师证件类型
	..s prscdrcertno =$p(doctorStr,"^",4)								//prsc_dr_certno 	开方医师证件号码 
	..s prscdrname=$p(doctorStr,"^",2)									//prsc_dr_name 	开方医师姓名   Y
	..s phaStr=..GetPharUserStr(AuditUserId)
	..s pharcerttype =$p(phaStr,"^",3)									//phar_cert_type 	药师证件类型 
	..s pharcertno =$p(phaStr,"^",4)									//phar_certno 	药师证件号码 
	..s pharname=$p(phaStr,"^",1)										//phar_name 	药师姓名	Y
	..s pharpraccertno=$p(phaStr,"^",2)									//phar_prac_cert_no 	药师执业资格证号  Y
	..s AdmDr=$p(^OEORD(+oeori),"^",1)
	..s InsuStr=""  ;##class(INSU.BL.Interface.DataRpUp).GetInsuReportInfoCom(AdmDr,.ExpDataAry)
	..;s fixmedinsStr=##class(INSU.BL.Interface.DataRpUp).GetInsuInfoByOeoriDr(oeori)
	..s fixmedinsStr=""
	..s hifeesetltype=$p(fixmedinsStr,"^",1)							//hi_feesetl_type 	医保费用结算类型
	..s setlid=$p(fixmedinsStr,"^",2)									//setl_id 	结算 ID  
	..s mdtrtsn=$p(fixmedinsStr,"^",3)									//mdtrt_sn 	就医流水号   Y
	..s psnno =$p(fixmedinsStr,"^",4)									//psn_no 	人员编号 
	..s PatInfoStr=..GetPatInfoStr(oeori)
	..s psncerttype=$p(PatInfoStr,"^",2)								//psn_cert_type 	人员证件类型 
	..s certno =$p(PatInfoStr,"^",3)									//certno 	证件号码 
	..s ccorno=""
	..s psnname=$p(PatInfoStr,"^",1)									//psn_name 	人员姓名 
	..;s IngrSub=..GetIngrtSubByClb(inclb)
	..;q:IngrSub=""
	..;s manudate=+$p(^DHCINGR(+IngrSub,"GRI",$p(IngrSub,"||",2)),"^",49)		
 	..;i manudate'="0" s manudate=$zd(manudate,3)
 	..;i manudate=0 s manudate=$zd(($p(^DHCINGR(+IngrSub),"^",4)-300),3)			 //manu_date 	生产日期  Y
 	..s manudate=""
	..s batstr=..GetBatStr(incib)
	..s manulotnum=$p($g(batstr),"^",1)	                						//manu_lotnum 	生产批号  Y												
	..s expyend=$p($g(batstr),"^",2)											//expy_end 	有效期止
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s trdnflag ="N"															//trdn_flag 	拆零标志  Y
	..i PurUomId'=BUomId s trdnflag="Y"
	..s finltrnspric=$p(^DHCINTR(intr),"^",14)															//finl_trns_pric 	最终成交单价 
	..s rxno =$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",14)			//rxno 	处方号
	..s rxcircflag="-"															//rx_circ_flag 	外购处方标志 
	..s rtaldocno="-"															//rtal_docno 	零售单据号  Y
	..s stooutno="-"																//stoout_no 	销售出库单据号  
	..s bchno =incib															//bchno 	批次号 
	..s drugtraccodg="-"														//drug_trac_codg 	药品追溯码 
	..s barcode=$p($g(^INCI(Inci,3)),"^",9) 									//barcode	商品条码
	..s stkbinret=##class(web.DHCSTM.Common.DrugInfoCommon).GetInciBinStr(Incil,",","","") 
    ..s stkchkflag=$p(stkbinret,":",1)
    ..s stkbinstr=$p(stkbinret,":",2)
	..s shelfposi=stkbinstr														//shelf_posi 	货架位 
	..s selretncnt=(-1)*$p(^DHCINTR(intr),"^",6)							//sel_retn_cnt 	销售/退货数量  Y
	..s selretntime =AuditDate_" "_AuditTime								//sel_retn_time 	销售/退货时间  Y
	..s selretnoptername=$p(phaStr,"^",1)											//sel_retn_opter_name 	销售/退货经办人姓名  Y
	..s memo=""																//memo 	备注
	..s rxflag=..GetInciRecFlag(Inci)
	..s Uom=$p(^DHCINTR(intr),"^",10)
	..s Fac2=..UOMFac(Uom,BUomId)
	..s selretncnt=selretncnt*Fac2
	..S finltrnspric=finltrnspric/Fac2
	..s finltrnspric=$fn(finltrnspric,"",6)
	..s finltrnspric=..AddZero(finltrnspric)	
	..s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	..s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	..s spec=##class(web.DHCSTM.Common.DrugInfoCommon).GetSpec("",+inclb)
	..s:spec="" spec="-"
	..s buomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s uomDesc=$p(^CT("UOM",Uom),"^",2)
	..s manfinfo=..GetManfInfoByInclb(inclb)
	..s gmanfid=$p(manfinfo,"^",1)
	..s Manf=$p(manfinfo,"^",2)
	..s:Manf="" Manf="-"
	..s intrData1=medlistcodg_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_fixmedinsbchno_"^"_prscdrcerttype
	..s intrData2=pharcertno_"^"_prscdrname_"^"_pharcerttype_"^"_pharcertno_"^"_pharname
	..s intrData3=pharpraccertno_"^"_hifeesetltype_"^"_setlid_"^"_mdtrtsn_"^"_psnno
	..s intrData4=psncerttype_"^"_certno_"^"_psnname_"^"_manulotnum_"^"_manudate
	..s intrData5=expyend_"^"_rxflag_"^"_trdnflag_"^"_finltrnspric_"^"_rxno
	..s intrData6=rxcircflag_"^"_rtaldocno_"^"_stooutno_"^"_bchno_"^"_drugtraccodg   ;28位置缺少
	..s intrData7=barcode_"^"_shelfposi_"^"_selretncnt_"^"_selretntime_"^"_selretnoptername
	..s intrData8=memo_"^"_spec_"^"_buomDesc_"^"_Fac2_"^"_uomDesc_"^"_Manf_"^"_IndexRowId
	..s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4_"^"_intrData5_"^"_intrData6_"^"_intrData7_"^"_intrData8
	..;w !,intrData
	..s count=count+1
	..s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3505",Pid,calcuDate,count)=intrData
	Q Pid
}

/// 8.1.2.9【3506】商品销售退货
ClassMethod Method3506(calcuDate, Pid, HospId, OutRowId, ExpDataAry As %DynamicArray)
{
    s typeStr="Y^H^MY^MH"
    s count=0
    s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.f date=calcuDate:1:calcuDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,calcuDate,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s IndexRowId=intr
	...q:(OutRowId'="")&&(IndexRowId'=OutRowId)
	...s LocID=$$LOC^ST01(inclb)
	...s hospdr=$P(^CTLOC(LocID),"^",22)
	...q:HospId'=hospdr
	...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	...s Inci=+inclb
	...s TmpGrpInfo=##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	...s TmpGrpType=$p(TmpGrpInfo,"^",3)
	...q:TmpGrpType'="M"
    ...s AuditUserId=$p(^DHCINTR(intr),"^",11)
    ...s AuditUser=""
    ...s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    ...s AuditDate=$p(^DHCINTR(intr),"^",2)
    ...s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    ...s AuditTime=$p(^DHCINTR(intr),"^",3)
    ...s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
	...;s orditm=..GetTransOrdItem(intr)
	...s oeori=$p(^DHCINTR(intr),"^",9) 
	...;q:orditm=""
	...s prodretnid =intr   										//prod_retn_id	商品退货记录主键, 院内惟一 Y
	...s prodstoinid =incib   										//prod_stoin_id	商品入库记录主键, 院内惟一 Y
	...s inciStr=..GetInsuInfoByCode(Inci,HospId)	
	...s medlistcodg=$p(inciStr,"^",1)
	...s mdtrtsn=$p(^OEORD(+oeori),"^",1)							//mdtrt_sn 	就医流水号   Y
	...s fixmedinsbchno=inclb   								     //fixmedins_bchno 	批次流水号 
	...s AdmDr=$p(^OEORD(+oeori),"^",1)
	...s InsuStr=""   ;##class(INSU.BL.Interface.DataRpUp).GetInsuReportInfoCom(AdmDr,.ExpDataAry)
	...;s fixmedinsStr=##class(INSU.BL.Interface.DataRpUp).GetInsuInfoByOeoriDr(oeori)
	...s fixmedinsStr=""
	...s setlid=$p(fixmedinsStr,"^",2)									//setl_id 	结算 ID  
	...s medinsprodselno=$p(fixmedinsStr,"^",3)									//mdtrt_sn 	就医流水号   Y
	...s:medinsprodselno="" medinsprodselno="-"
	...s psnno =$p(fixmedinsStr,"^",4)									//psn_no 	人员编号 
	...s PatInfoStr=..GetPatInfoStr(oeori)
	...s psncerttype=$p(PatInfoStr,"^",2)												//psn_cert_type 	人员证件类型 
	...s certno =$p(PatInfoStr,"^",3)													//certno 	证件号码 
	...s ccorno=""
	...s psnname=$p(PatInfoStr,"^",1)	
	...s manudate=""												//psn_name 	人员姓名 
	...;s IngrSub=..GetIngrtSubByClb(inclb)
	...;q:IngrSub=""
	...;s manudate=+$p(^DHCINGR(+IngrSub,"GRI",$p(IngrSub,"||",2)),"^",49)		
 	...;i manudate'="0" s manudate=$zd(manudate,3)
 	...;i manudate=0 s manudate=$zd(($p(^DHCINGR(+IngrSub),"^",4)-300),3) //manu_date 	生产日期  Y
	...s batstr=..GetBatStr(incib)
	...s manulotnum=$p($g(batstr),"^",1)	                		//manu_lotnum 	生产批号  Y												
	...s expyend=$p($g(batstr),"^",2)								//expy_end 	有效期止
	...s PurUomId=$p(^INCI(Inci,3),"^",6)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s trdnflag ="N"												//trdn_flag 	拆零标志  Y
	...i PurUomId'=BUomId s trdnflag="Y"
	...s finltrnspric=$p(^DHCINTR(intr),"^",14)												//finl_trns_pric 	最终成交单价 
	...s selretncnt=$p(^DHCINTR(intr),"^",6)						//sel_retn_cnt 	销售/退货数量 
	...s selretntime =AuditDate_" "_AuditTime						//sel_retn_time 	销售/退货时间 
	...s selretnoptername=AuditUser									//sel_retn_opter_name 	销售/退货经办人姓名 
	...s memo=""	
	...s rxflag=..GetInciRecFlag(Inci)												//memo 	备注
	...s PurUomId=$p(^INCI(Inci,3),"^",6)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s Uom=$p(^DHCINTR(intr),"^",10)
	...s Fac2=..UOMFac(Uom,BUomId)
	...s selretncnt=selretncnt*Fac2
	...S finltrnspric=finltrnspric/Fac2
	...s finltrnspric=$fn(finltrnspric,"",6)
	...s finltrnspric=..AddZero(finltrnspric)
	...s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)							//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	...s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)					//fixmedins_hilist_name 	定点医药机构目录名称 Y
	...s intrData1=medlistcodg_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_fixmedinsbchno_"^"_setlid
	...s intrData2=psnno_"^"_psncerttype_"^"_certno_"^"_psnname_"^"_manulotnum
	...s intrData3=manudate_"^"_expyend_"^"_rxflag_"^"_trdnflag_"^"_finltrnspric
	...s intrData4=selretncnt_"^"_selretntime_"^"_selretnoptername_"^"_memo_"^"_medinsprodselno_"^"_IndexRowId
	...s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4
	...;w !,intrData
	...s count=count+1
	...s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3506",Pid,calcuDate,count)=intrData
	Q Pid
}

/// 8.1.2.10【3507】商品信息删除
/// 通过此交易删除某一批次商品信息。
/// 1、交易输入为流式文件。 
/// 2、根据数据类型分别删除对应交易的数据： 
/// a) 1-盘存信息：对应删除【3501】交易数据； 
/// b) 2-库存变更信息：对应删除【3502】、【3568】交易数据； 
/// c) 3-采购信息：对应删除【3503】、【3504】交易数据； 
/// d) 4-销售信息：对应删除【3505】、【3506】交易数据。
/// e) 5-供应商信息：对应删除【3569】交易数据。
/// f) 6-领用信息：对应删除【3570】交易数据。
ClassMethod Method3507(Bchno, Code, HospId, ExpDataAry As %DynamicArray)
{
	s fixmedinsStr=..GetfixmedinsStr(.ExpDataAry)
	s fixmedinshilistid=$p(fixmedinsStr,"^",4)				//fixmedins_hilist_id 	定点医药机构目录编号  Y 
	s fixmedinshilistname=$p(fixmedinsStr,"^",3)			//fixmedins_hilist_name 	定点医药机构目录名称 Y
	s Pid=..NewPid()
	s fixmedinsbchno=Bchno				/// fixmedins_bchno 	定点医药机构批次流水号 
	s invdatatype=Code				/// inv_data_type 	进销存数据类型
	S ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3507",Bchno,Pid,1)=fixmedinsbchno_"^"_invdatatype
	q Pid
}

/// 8.1.2.2【3568】商品库存信息
ClassMethod Method3568(Date, Type, HospId)
{

	s Pid=..NewPid()
	s date=$zdh(Date,3)
	s memo =""						//memo 	备注	
	s barcode=""                    //barcode	商品条码
	s ordno=""   					//ord_no	订单号
	s Inci=""
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.s stkCat=$p($g(^INCI(Inci,2)),"^",2)
	.q:stkCat=""
	.q:$p($G(^INC("SC",stkCat)),"^",3)'="G"
	.s Sub=0
	.f  s Sub=$o(^INCI(Inci,"IL",Sub)) q:Sub=""  d
	..s Incil=Inci_"||"_Sub
	..q:$p($g(^INCI(Inci,"IL",Sub)),"^",1)=""
	..s PhaLoc=$p(^INCI(Inci,"IL",Sub),"^",1)
	..q:PhaLoc=""
	..s hosdr=$p(^CTLOC(PhaLoc),"^",22)
	..q:HospId'=hosdr
	..s PhaLocDesc=$P(^CTLOC(PhaLoc),"^",2)
	..i PhaLocDesc["-" s PhaLocDesc=$p(PhaLocDesc,"-",2)
	..s PhaLocType=$P(^CTLOC(PhaLoc),"^",13)
	..q:PhaLocType'="D"	
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Fac=..UOMFac(PurUomId,BUomId)
	..s LB=0
	..f  s LB=$o(^INCI(Inci,"IL",Sub,"LB",LB))  q:LB=""  d
	...s inclb=Inci_"||"_Sub_"||"_LB
    ...s incib=$P(^INCI(Inci,"IL",Sub,"LB",LB),"^",1)
    ...s Chl=$p(incib,"||",2)	
    ...s IngrSub=..GetIngrtSubByClb(inclb)
	...q:IngrSub=""
    ...s invcnt=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,Date)
    ...q:invcnt=0
	...s prodstoinid =incib   			//prod_stoin_id品入库记录主键, 院内惟一
	...s prodtype="1"      				//prod_type	商品类型
	...s fixmedinshilistid =$p(^INCI(Inci,1),"^",1)     	//fixmedins_hilist_id 	定点医药机构目录编号
	...s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)        //fixmedins_hilist_name 	定点医药机构目录名称
	...s inciStr=..GetInsuInfoByCode(Inci)	
	...s inciCode=$p(inciStr,"^",1)
	...s inciDesc=$p(inciStr,"^",2)
	...s:inciCode'="" fixmedinshilistid=inciCode
	...s:inciDesc'="" fixmedinshilistname=inciDesc
	...s fixmedinshilistname=..GetInciDesc(fixmedinshilistname)
	...s fixmedinsbchno =inclb            //fixmedins_bchno 	批次流水号  
	...;s invcnt=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,Date)						//inv_cnt	库存数量 
    ...s pric=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,PurUomId,HospId,"G",date,"")							//pric 	单价 
	...i +pric=0 s pric=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,date,PurUomId,HospId,"G","")
	...;s pric=..AddZero(pric)
	...s Ingr=+IngrSub,ChiSub=$p(IngrSub,"||",2)
	...s AuditDate=$p(^DHCINGR(Ingr),"^",4)
    ...s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
	...s AuditTime=$p(^DHCINGR(Ingr),"^",9)
    ...s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
	...s indate=AuditDate_" "_AuditTime						//indate	入库时间 
	...s indaynum=+$h-($p(^DHCINGR(Ingr),"^",4))		//indaynum	在库天数
	...s manulotnum=$p(^DHCINGR(Ingr,"GRI",ChiSub),"^",13)						 //manu_lotnum 	生产批号
 	...s expyend=+$p(^DHCINGR(Ingr,"GRI",ChiSub),"^",9)							
 	...i expyend'="0" s expyend=$zd(expyend,3)						//expy_end 	有效期止
 	...s manudate=+$p(^DHCINGR(Ingr,"GRI",ChiSub),"^",49)					
 	...i manudate'="0" s manudate=$zd(manudate,3)
 	...i manudate=0 s manudate=$zd(($p(^DHCINGR(Ingr),"^",4)-300),3)			//manu_date 	生产日期      							          
	...s splercode=$p($g(^APC("APCVM",$p(^DHCINGR(Ingr),"^",3))),"^",2)                 	//spler_code	供应商编码
	...s splername=$p($g(^APC("APCVM",$p(^DHCINGR(Ingr),"^",3))),"^",3)                  //spler_name	供应商名称
	...s storageroomname=PhaLocDesc			//storageroomname	库房名称
	...i invcnt>0 s stockstatus=1				//stockstatus	库存状态
	...e  s stockstatus=0
	...s invcnt=invcnt/Fac
	...s invcnt=$fn(invcnt,"",2)
	...s intrData1=prodstoinid_"^"_prodtype_"^"_fixmedinshilistid_"^"_fixmedinshilistname_"^"_ordno
	...s intrData2=fixmedinsbchno_"^"_invcnt_"^"_pric_"^"_indate_"^"_indaynum
	...s intrData3=expyend_"^"_manudate_"^"_manulotnum_"^"_barcode_"^"_splercode
	...s intrData4=splername_"^"_storageroomname_"^"_stockstatus_"^"_memo
	...s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4
	...;w !,intrData
	...s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3568",Date,Pid,inclb)=intrData
	q Pid
}

/// 8.1.2.6【3569】商品企业信息
ClassMethod Method3569(RowIdStr)
{
	s Pid=..NewPid()
	s entptype="" 						//entp_type	企业类别
  	s busilicperson=""					//busilicperson	法人代表
  	s manage=""							//manager	负责人
  	s telephone=""						//telephone	联系电话
  	s regaddress=""						//regaddress	注册地址
  	s address=""						//address	仓库地址
  	s province=""						//province	所属省份
  	s city=""							//city	所属地市
  	s county=""							//county	所属县城
  	s forgflag=""						//forg_flag	境外标志
  	s cityflag=""						//city_flag	是否本市标志
  	s openingbank=""					//openingbank	开户行
  	s accountnumber=""					//accountnumber	银行账号
  	s taxcode=""						//taxcode	税号
  	s sreceipttype=""					//isreceipttype	是否一般纳税人
  	s uscc=""							//uscc	统一社会信用代码
  	s busilicissue=""					//busilicissue	执照发照机关
  	s busilicexp=""						//busilicexp	营业执照效期
  	s busilicissuedate=""				//busilicissuedate	执照发照日期
  	s busiliccheckdate=""				//busiliccheckdate	执照年度报告效期
  	s businessscope=""					//businessscope	营业执照经营范围
  	s qaexpdate=""						//qaexpdate	质保协议有效期
  	s qcmanager=""						//qcmanager	质量负责人
  	s licence=""						//licence	许可证编号
  	s licenceexp=""						//licenceexp	许可证效期
  	s licenceissue=""					//licenceissue	许可证发证机关
  	s licencescope=""					//licencescope	许可证认证范围
  	s licenceissuedate=""				//licenceissuedate	许可证发证日期
	s Code=""
	f  s Code=$o(^PHMNF(0,"Code",Code))  q:Code=""  d
	.s RowId=""
	.f  s RowId=$o(^PHMNF(0,"Code",Code,RowId))  q:RowId=""  d
	..s ManfAdd=$o(^DHCMANF(0,"MANF",RowId,""))
	..s ManfType=$p(^DHCMANF(ManfAdd),"^",7)
	..q:ManfType="M"
	..s fixmedinshilistid=RowId 				//fixmedins_hilist_id 	定点医药机构目录编号
	..s entpcode=$p(^PHMNF(RowId),"^",1)   					//entp_code	企业编码
  	..s entpname=$p(^PHMNF(RowId),"^",2)  						//entp_name	企业名称
  	..s intrData1=fixmedinshilistid_"^"_entpcode_"^"_entpname_"^"_entptype_"^"_busilicperson
  	..s intrData2=manage_"^"_telephone_"^"_regaddress_"^"_address_"^"_province
  	..s intrData3=city_"^"_county_"^"_forgflag_"^"_cityflag_"^"_openingbank
  	..s intrData4=accountnumber_"^"_taxcode_"^"_sreceipttype_"^"_uscc_"^"_busilicissue
  	..s intrData5=busilicexp_"^"_busilicissuedate_"^"_busiliccheckdate_"^"_businessscope_"^"_qaexpdate
  	..s intrData6=qcmanager_"^"_licence_"^"_licenceexp_"^"_licenceissue_"^"_licencescope
  	..s intrData7=licenceissuedate
  	..s intrData=intrData1_"^"_intrData2_"^"_intrData3_"^"_intrData4_"^"_intrData5_"^"_intrData6_"^"_intrData7
  	..;w !,intrData
  	..s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3569",RowIdStr,Pid,RowId)=intrData
  	q 0
}

/// 8.1.2.7【3570】商品领用信息
ClassMethod Method3570(InitId)
{
	q:InitId="" ""
	s Pid=..NewPid()
	s PhaLoc=$p(^DHCINIT(InitId),"^",6)
	s PhaLocType=$P(^CTLOC(PhaLoc),"^",13)
	q:PhaLocType="D" ""
	s AuditDate=$p(^DHCINIT(InitId),"^",15)
    s:+AuditDate'=0 AuditDate=..DateLogicalToHtml(AuditDate,"ST")
    s AuditUserId=$p(^DHCINIT(InitId),"^",17)
    s AuditUser=""
    s:AuditUserId="" AuditUserId=$p(^DHCINIT(InitId),"^",8)
    s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s AuditTime=$p(^DHCINIT(InitId),"^",16)
    s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
	s receivedeptcode=$P(^CTLOC(PhaLoc),"^",1) 				//receivedeptcode	领用科室编码
	s receivedeptname=$P(^CTLOC(PhaLoc),"^",2) 				//receivedeptname	领用科室
	s receiveusername=AuditUser 				//receiveusername	领用人
	s receivetime=AuditDate_" "_AuditTime  					//receivetime	领用时间
	s prodtype="1" 						//prod_type	商品类型
	s prodreceiveid=$p(^DHCINIT(InitId),"^",1) 					//prod_receive_id	商品领用记录主键, 院内惟一
	s ChiSub=0
 	f  s ChiSub=$o(^DHCINIT(InitId,"ITI",ChiSub)) q:ChiSub=""  d
 	.s inclb=$p(^DHCINIT(InitId,"ITI",ChiSub),"^",3)
 	.s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
 	.s Inci=+inclb
 	.s pack=$p(^DHCINIT(InitId,"ITI",ChiSub),"^",7)		
 	.s storageQuantity=$fn($p(^DHCINIT(InitId,"ITI",ChiSub),"^",1),"",2)		
 	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pack,BUomId)
	.s receiveno=storageQuantity								//receiveno	领用数量
	.s prodstoinid=incib 										//prod_stoin_id	商品入库记录主键, 院内惟一
	.s fixmedinshilistid=$p(^INCI(Inci,1),"^",1)    				//fixmedins_hilist_id	定点医药机构目录编号
	.s fixmedinshilistname=$p(^INCI(Inci,1),"^",2)    			//fixmedins_hilist_name	定点医药机构目录名称
	.s inciStr=..GetInsuInfoByCode(Inci)	
	.s inciCode=$p(inciStr,"^",1)
	.s inciDesc=$p(inciStr,"^",2)
	.s:inciCode'="" fixmedinshilistid=inciCode
	.s:inciDesc'="" fixmedinshilistname=inciDesc
	.s fixmedinshilistname=..GetInciDesc(fixmedinshilistname)					
	.s intrData1=prodstoinid_"^"_prodreceiveid_"^"_prodtype_"^"_fixmedinshilistid_"^"_fixmedinshilistname
	.s intrData2=receivedeptcode_"^"_receivedeptname_"^"_receiveusername_"^"_receivetime_"^"_receiveno
	.s intrData=intrData1_"^"_intrData2
	.;w !,intrData
	.s ^TMP("DHCSTM","web.DHCSTMService.InsuMatCodeUpload","Method3570",InitId,Pid,ChiSub)=intrData
	q Pid
}

/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// Description:过滤掉药品名称中的无用信息
/// Creator:	hulihua
/// CreateDate:	2019-11-29
/// Table: 		
/// Input: 		
/// Output:			
/// Return：
/// Debug：		w ##class(PHA.FACE.OUT.PASSREP).GetInciDesc("1")
ClassMethod GetInciDesc(Incidesc As %String) As %String
{
	q:Incidesc="" ""
	s newDesc=""
	s:$F(Incidesc,"(") newDesc=$p(Incidesc,"(",1)
	s:$F(Incidesc,"[") newDesc=$p(Incidesc,"[",1)
	s:newDesc="" newDesc=Incidesc
  	q newDesc
}

/// 批准文号
ClassMethod GetInciRemark(InciId)
{
	q:InciId="" "-"
	s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
	q:Info="" "-"
	s Remark=$p(^DHCITMINFO(Info),"^",10)
	i $p(Remark,"-",2)="undefined" s Remark="-"
	i Remark="" s Remark="-"
	i Remark'["-" s Remark=Remark_"-"
	q Remark
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations，DHC_StkCatGroup
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
ClassMethod GetIncStkCatGrp(inci) As %Library.String
{
	Q:inci="" ""
	Q:'$d(^INCI(inci,2)) ""
	s inccat=$p(^INCI(inci,2),"^",2)
	q:inccat="" ""
	s scg=$o(^DHCSCG("STKCAT",inccat,""))
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=""
	S scgtypeDesc=..stktypeDesc(scgtype)
	s phaVersion=..#PHAVERSION	
	i phaVersion=0 d
	.s scgset=$s(scgcode="ZCY":"GC",1:"")
	e  d
	.s scgset=$p(^DHCSCG(scg),"^",5)
	s scgstrumodeflag=$p(^DHCSCG(scg),"^",7)
	q $g(scgcode)_"^"_$g(scgdesc)_"^"_$g(scgtype)_"^"_scgtypeDesc_"^"_scg_"^"_scgset_"^"_$g(scgstrumodeflag)
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String
{
	I scgtype="G" q "Drug"
	I scgtype="M" q "Material"
	q "Other"
}

/// Descript:	根据两个传入单位取得转换率
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		fr, to
/// Output:		Return
/// Return：	转换率
/// Others: w ##class(PHA.FACE.OUT.PASSREP).UOMFac(14,26)
ClassMethod UOMFac(fr, to)
{
	q:fr=to 1    ;if from-uom is as same as to-uom then return 1
	s rowid=""
	s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
	i rowid'="" d       
	.s fac=$p(^CT("CTCF",rowid),"^",3)
	.s fac=$p(fac,$c(1))
	e  d
	.s fac=1
	q $g(fac)
}

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr)
{
	S ArcimDr=..GetArcim(InciDr)
	Q:ArcimDr="" ""
	S Phcdf=..GetPhcdfByArcim(ArcimDr)
	Q Phcdf
}

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid 
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr)
{
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S ArcimDr=$P(^INCI(InciDr,1),"^",3)
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	Q Arcsub_"||"_Arcver
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr)
{
	Q:ArcimDr="" ""
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
	Q Phcdf
}

/// 根据Inclb取入库子表id
/// /// w ##class(PHA.FACE.OUT.WFYPSCBASE).GetIngrtSubByClb("1","1")
ClassMethod GetIngrtSubByClb(inclb) As %Library.String
{
	q:$g(inclb)="" ""
	s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	s IngrtSub=""
	s Ingrt=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
 	i Ingrt d
 	.s ChiSub=$o(^DHCINGR(0,"GRI_INCIB",incib,Ingrt,""))
	.s IngrtSub=Ingrt_"||"_ChiSub
	e  d
	.s incib=##Class(web.DHCSTCOMINC).GetLastIncib(+incib,2,+$h)
	.s Ingrt=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
	.q:Ingrt=""
	.s ChiSub=$o(^DHCINGR(0,"GRI_INCIB",incib,Ingrt,""))
	.s IngrtSub=Ingrt_"||"_ChiSub
	q IngrtSub
}

/// 根据库存项代码或RowID取得规格
ClassMethod GetSpec(inci) As %Library.String
{
	q:$g(inci)="" "null"
	s spec=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" "null"
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
}

/// 根据库存项目ID获取YPID
/// DHC_ItmAddionInfo 
/// INFO_PurPlanCode
ClassMethod GetInciPurPlanCode(inci) As %Library.String
{
	q:inci="" ""
	s PurPlanCode=""
	s add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	q:add="" ""
	s PurPlanCode=$p($G(^DHCITMINFO(add)),"^",56)
	q $g(PurPlanCode)
}

/// 根据库存项目ID获取处方购药标识
/// PHC_DrgFormExt 
/// PHCDF_OTC
ClassMethod GetInciRecFlag(inci) As %Library.String
{
	q:inci="" "N"
	s Phcdf=..GetPhcdf(inci)
	q:Phcdf="" "N"
	s RecFlag=$p($g(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),"DHC")),"^",35)		;处方购药
	s RecFlag=$s(RecFlag="处方药":"Y",1:"N")
	q RecFlag
}

/// creator:yunhaibao
/// createdate:2015-12-03
/// description:根据库存项,日期,单位获取指定单位的全院库存,默认基本单位
/// input:库存项id,日期,单位id,院区
/// w ##class(web.DHCST.Common.DrugStkCommon).QtyHospInc(886,"","","")
ClassMethod QtyHospInc(Inci As %String, Hospital As %String = "", date As %String = "", UomDr As %String = "") As %String
{
 i date="" s date=+$h
 e  s date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
 s Inci=+Inci
 q:Inci="0" 0 
 s BUOM=$p(^INCI(Inci,1),"^",10) q:Inci="" 0
 i UomDr="" s UomDr=BUOM
 s hospincqty=0
 s incich=""
 f  s incich=$o(^INCI(Inci,"IL",incich)) q:incich=""  d
 .q:+incich=0
 .q:$p($g(^INCI(Inci,"IL",incich)),"^",1)=""
 .s locrowid=$p(^INCI(Inci,"IL",incich),"^",1)
 .q:+locrowid=0
 .s hospid=$p($g(^CTLOC(locrowid)),"^",22)
 .q:(Hospital'="")&&(Hospital'=hospid)
 .s incilocqty=..IL(Inci, locrowid, date)
 .s hospincqty=hospincqty+incilocqty
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BUOM)
 s hospincqty=+hospincqty/fac
 q hospincqty
}

/// Descript: 根据库存项的ID、药房及开始时间取基本单位数量
/// Creater: Zhouyg
/// CreateDate: 20100302
/// Input: 	inci,loc,dd
/// Output: 	Return
/// Return： 基本单位数量
ClassMethod IL(inci, loc, dd)
{
 ;ret value :
 ; <0 - error occurs
 q:inci="" 0
 q:loc="" 0
 q:dd="" 0
 s nextdate=dd+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$p(^DHCLOCTOT(rr),"^",4)
 q qty
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2018-08-14
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(PHA.FACE.OUT.PASSREP).NewPid()
ClassMethod NewPid() As %String
{
	Q $I(^DHCSTPID("DHCST",$THIS))
}

ClassMethod GetBatStr(Incib)
{
	s Inci=+Incib
    s Chl=$p(Incib,"||",2)
    s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	i ExpDate'=0  d
 	.s Expire=$zd(ExpDate,3)
 	e  d
 	.s Expire=""
 	q BatNo_"^"_Expire
}

/// 根据INCI和Loc取货位码
ClassMethod StkBin(inci As %String, locDr As %String) As %String
{
  q:inci="" ""
  q:locDr="" ""
  s incilch=$o(^INCI("IL_LOC",locDr,inci,"")) q:incilch="" ""
  q $p(..GetInciBinStr(inci_"||"_incilch),":",2)
}

ClassMethod GetInciBinStr(incil, del = "", sbrowid = "", desc = "")
{
	s chkflag=0
	s ret=""
	s incilb=""
	f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
	.s stkbindr=$p(^DHCINCILB(incilb),"^",2)
	.s stkbin=$p(^INC("SB",stkbindr),"^",2)
	.i ret="" d
	..s ret=stkbin
	.e  d
	..s ret=ret_del_stkbin
	.q:(stkbin'[desc)&(desc'="")
	.q:(stkbindr'=sbrowid)&(stkbindr'="")
	.s chkflag=1
	q chkflag_":"_ret
}

/// 根据库存项代码获取医保对照代码、名称
/// W ##class(PHA.FACE.TPS.HisDrugToGJYB).GetInsuInfoByCode(1005,2)
ClassMethod GetInsuInfoByCode(InciId, hospdr = "")
{
	q:InciId="" ""
	s InsuStr= ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciId,hospdr)
	i +InsuStr="" d
	.s InsuStr=..GetInsuNew(InciId,hospdr)
	q InsuStr
}

ClassMethod GetTARI(Inci) As %String
{
	q:Inci="" ""
	s Arcim=$P(^INCI(Inci,1),"^",3)
	q:Arcim="" ""
	
	s TarItmId=..GetTARIByArcim(Arcim)
	q TarItmId
}

/// Descript:	根据医嘱项ID获取有效计费项ID
ClassMethod GetTARIByArcim(Arcim) As %String
{
	q:Arcim="" ""
	
	s TarItmId=""
	s Tariff=""
	f  s Tariff=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff)) q:(Tariff="")||(TarItmId'="")  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,StartDate)) q:(StartDate="")||(TarItmId'="")  d
	..q:(StartDate="")||(StartDate>+$h)
	..s LinkId=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,StartDate,""))
	..q:LinkId=""
	..s EndDate=$p(^DHCOLT(LinkId),"^",5)
	..q:(EndDate'="")&&(EndDate<+$h)
	..s TarItmId=Tariff
	
	q TarItmId
}

/// 获取台帐中的医嘱ID
ClassMethod GetTransOrdItem(intr) As %String
{
	s orditm=""
	s type=$p(^DHCINTR(intr),"^",1)
	s pointer=$p(^DHCINTR(intr),"^",9) 
	i type="P" d
	.q:'$d(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHAC($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",7)
	i type="Y" d
	.q:'$d(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)))
	.s orditm=$p(^PHARET($p(pointer,"||",1),"I",$p(pointer,"||",2)),"^",1)
	i type="F" d
	.q:'$d(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHDI($p(pointer,"||",1),"PHDI",$p(pointer,"||",2)),"^",5)
	i type="H" d
	.q:'$d(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)))
	.s orditm=$p(^DHCPHRTI($p(pointer,"||",1),"RTI",$p(pointer,"||",2)),"^",2)
	q orditm
}

/// description: 医生科室
ClassMethod OeoriDocLoc(oeori As %String) As %String
{
	s docLocId=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",2)
	q:docLocId="" ""
	s docLocDesc=$p($g(^CTLOC(+docLocId)),"^",2)
	q docLocDesc
}

ClassMethod GetPatInfoStr(oeori As %String) As %String
{
	q:oeori="" ""
	s admId = $p(^OEORD(+oeori),"^",1)
	s papmi=$p(^PAADM(admId),"^",1)
	s papmi=+papmi
	s patName=$p(^PAPER(papmi,"ALL"),"^",1)															//姓名
	s patDVAnumber=$p(^PAPER(papmi,"PAT",3),"^",6)							//证件号	
	s patType=$p(^PAPER(papmi,"PAT",3),"^",7)							//证件类型
	s patTypeCode="01"
	s:patType'="" patTypeCode=$p(^PAC("CARD",patType),"^",1)	
	s:patDVAnumber="" patDVAnumber="-"
	q patName_"^"_patTypeCode_"^"_patDVAnumber
}

/// description: 开单医生
/// W ##class(PHA.FACE.TPS.HisDrugToGJYB).OeoriDoctorStr("84||203")
ClassMethod OeoriDoctorStr(oeori As %String) As %String
{
	S doctor=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11)
	Q:doctor="" ""
	s docTextOne=$P($g(^CTPCP(doctor,3)),"^",11)
	S doctorName=$P($g(^CTPCP(doctor,1)),"^",2)
	s UserId=$o(^SSU("SSUSR",0,"CTPCP",doctor,""))
	s CardNo=""
	s:UserId'="" CardNo=$p(^SSU("SSUSR",UserId),"^",122)
	Q doctorName_"^"_docTextOne_"^"_"01"_"^"_CardNo
}

/// description: 开单医生
ClassMethod OeoriDoctor(oeori As %String) As %String
{
	S doctor=$P($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",11)
	Q:doctor="" ""
	S doctorName=$P($g(^CTPCP(doctor,1)),"^",2)
	Q doctorName
}

/// description: 药师
/// W ##class(PHA.FACE.TPS.HisDrugToGJYB).GetPharUserStr(18985)
ClassMethod GetPharUserStr(UserId As %String) As %String
{
	Q:UserId="" ""
	s CardNo="",PhaName="",phaTextOne=""
	s:UserId'="" CardNo=$p(^SSU("SSUSR",UserId),"^",122)
	s:UserId'="" PhaName=$p(^SSU("SSUSR",UserId),"^",2)
	s userCPId=##class(web.SSUser).GetDefaultCareProvider(UserId)
	s:userCPId'="" phaTextOne=$P($g(^CTPCP(userCPId,3)),"^",11)
	Q PhaName_"^"_phaTextOne_"^"_"01"_"^"_CardNo
}

ClassMethod AddZero(number)
{
	s number=$fn(number,"",2)
	q:$F(number,".")=0 number
	q:(number'<1)||(number'>-1) number
	q:$p(number,".")'="" number
	s newnumber=$fn(number,"",$l($p(number,".",2)))
	q newnumber
}

ClassMethod DateLogicalToHtml(date, type = "")
{
	Q:date="" ""
	s date = $zd(date,3)
	q date
}

ClassMethod GetfixmedinsStr(ExpDataAry As %DynamicArray)
{
	s (mdtrtId,setlId,fixmedinsName,fixmedinsCode,hiSetlLv,hiNo,insutype,insuAdmdvs,mdtrtareaAdmvs,psnno)=""
    if ($IsObject(ExpDataAry))
    {
	   //--按照医保接口文档字段命名
	   s mdtrtId=ExpDataAry.GetAt("mdtrt_id")                   //mdtrt_id	        就诊ID(非HIS就诊ID)  
	   s setlId = ExpDataAry.GetAt("setl_id")                    //setl_id	        结算ID
       s psnno = ExpDataAry.GetAt("psn_no")                 //psn_no	人员编号
	   s fixmedinsName = ExpDataAry.GetAt("fixmedins_name")     //fixmedins_name	定点医药机构名称	
	   s fixmedinsCode = ExpDataAry.GetAt("fixmedins_code")     //fixmedins_code	定点医药机构编号
	   s hiSetlLv = ExpDataAry.GetAt("hi_setl_lv")              //hi_setl_lv	    医保结算等级
	   s hiNo = ExpDataAry.GetAt("hi_no")                       //hi_no	            医保编号	
	   s insutype = ExpDataAry.GetAt("insutype")                //insutype	        险种类型  
	   s insuAdmdvs = ExpDataAry.GetAt("insu_admdvs")           //insu_admdvs	    参保所属医保区划
	   s mdtrtareaAdmvs = ExpDataAry.GetAt("mdtrtarea_admvs")   //mdtrtarea_admvs	就医地医保区划	
	   
	 }
	 
	 s Data=mdtrtId_"^"_setlId_"^"_fixmedinsName_"^"_fixmedinsCode_"^"_hiSetlLv
	 s Data=Data_"^"_hiNo_"^"_insutype_"^"_insuAdmdvs_"^"_mdtrtareaAdmvs_"^"_psnno
	 q Data
}

/// 根据供应商Id获取供应商代码名称许可证号
/// w ##class(PHA.FACE.TPS.HisDrugToGJYB).GetVendorStr("490")
ClassMethod GetVendorStr(VendorId)
{
	q:VendorId="" "-^-^-^"
	s (VenCode,VenDesc,VenLic)="-"
	s:VendorId'="" VenCode=$p(^APC("APCVM",VendorId),"^",2)
	s:VendorId'="" VenDesc=$p(^APC("APCVM",VendorId),"^",3)
	s phaVersion=..#PHAVERSION	
	i phaVersion=2  d
	.s DHCTVid=$o(^DHCSTV(0,VendorId,""))
	.i DHCTVid'="" s VenLic=$p(^DHCSTV(DHCTVid),"^",51)
	e  d
	.s DHCTVid=$o(^DHCSTV(0,VendorId,""))
	.i DHCTVid'="" s VenLic=$p(^DHCSTV(DHCTVid),"^",4)
	s:VenLic="" VenLic="-"
	s Str=VenCode_"^"_VenDesc_"^"_VenLic
	q Str
}

ClassMethod GetPbManf(Inci) As %Library.String
{
    q:Inci="" ""
    s (ManfId,ManfDesc)=""
    s Add=$o(^DHCITMINFO(0,"INCI",Inci,""))
    q:Add="" "-"
    s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
    
    s:ManfId'="" ManfDesc=$P($g(^PHMNF(ManfId)),"^",2)
    s:ManfDesc="" ManfDesc="-"
    q ManfDesc
}

/// w ##class(web.DHCSTMService.InsuMatCodeMethod).GetInsuMatCode(23170,"")
ClassMethod GetInsuNew(inci As %String, HospDr As %String = "")
{
	s DHCTarid=..GetTARI(inci)
	q:DHCTarid="" ""
	s TarConid="",ConStr="",InsuStr=""
	s GroupHospital=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_TarContrast",HospDr) //+ DingSH 20200521
	q:DHCTarid="" ConStr
	s Type="00A"   ;housc 写死，固定值
	q:$d(^DHCINTCT("0","Type_Date",DHCTarid,Type))=0 ConStr
	s ActDate=+$h+1
	s ActDateCon=""
	s ConFlag=0 
	;if DHCTarid="32733" b ;5999999
	f  s ActDateCon=$o(^DHCINTCT("0","Type_Date",DHCTarid,Type,ActDateCon),-1)  q:(ActDateCon="")||(ConFlag=1)  d
	.q:ActDateCon=""
	.q:ActDateCon>ActDate
	.f  s TarConid=$o(^DHCINTCT("0","Type_Date",DHCTarid,Type,ActDateCon,TarConid),-1) q:(TarConid="")||(ConFlag=1)  d
	..s sCon=$g(^DHCINTCT(TarConid))
	..s DataHospital=$p(sCon,"^",27)   //+ DingSH 20200521
    ..q:GroupHospital'=DataHospital    //+ DingSH 20200521
	..s INTCTExpiryDate=$p(sCon,"^",20)    
	..q:(INTCTExpiryDate'="")&(ActDate>INTCTExpiryDate)       //增加对照失效日期判断 add by lilizhi 2013-03-27
	..s InsuDr=$p(sCon,"^",4)
	..q:+InsuDr=0
	..q:$d(^DHCINTIM(InsuDr))=0
	..s INTIMExpiryDate=$p(^DHCINTIM(InsuDr),"^",44)
	..q:(INTIMExpiryDate'="")&(ActDate>INTIMExpiryDate)       //增加目录失效日期判断 add by lilizhi 2013-03-27
	..s ConStr=ConStr_"!"_TarConid
	..s ConFlag=1
	q:ConStr="" ""
	s ContId=$p(ConStr,"!",2)
	s InsuId=$p($g(^DHCINTCT(ContId)),"^",4)    
	i InsuId'="" d
	.s InsuString=$g(^DHCINTIM(InsuId))
	.s InsuCode=$p(InsuString,"^",3)
	.s InsuDesc=$p(InsuString,"^",4)
	.s InsuStr=InsuCode_"^"_InsuDesc
	q InsuStr
}

ClassMethod GetManfInfoByInclb(inclb) As %Library.String
{
	q:inclb="" ""
	s inci=+inclb
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
	q:incib="" ""
	s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	q:dhcincib="" ""
	s manfid=$p($g(^DHCINCIB(dhcincib)),"^",7)
	;批次表里没存的话取入库子表
	i manfid=""  d
	.s dhcingr=""
	.f  s dhcingr=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr),-1)  q:(dhcingr="")!(manfid'="")  d
	..s chl=""
	..f  s chl=$o(^DHCINGR(0,"GRI_INCIB",incib,dhcingr,chl),-1)  q:(chl="")!(manfid'="")  d
	...s manfid=$p(^DHCINGR(dhcingr,"GRI",chl),"^",29)
	..
	.
	s manf=""
	s:manfid'="" manf=$p($g(^PHMNF(manfid)),"^",2)
	q manfid_"^"_manf
}

}
