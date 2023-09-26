Class web.DHCOPAdmFind3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ///大同三院专用
ClassMethod AdmQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmQueryExecute ]
{
	Set repid=$LIST(qHandle,2) 
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AdmQueryExecute(ByRef qHandle As %Binary, StDate As %String, DateTo As %String, PatientID As %String, PatName As %String, LocRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	b
	;d ##class(%ResultSet).RunQuery("web.DHCOPAdmFind","AdmQuery","60333","","","","")
	i StDate="" set StDate=+$H			;Set qHandle=$lb(0,repid,0)	Quit $$$OK
	i DateTo="" Set DateTo=+$H			;Set qHandle=$lb(0,repid,0)	Quit $$$OK
	;
	f pdate=StDate:1:DateTo  d
	.s PAADMRowID="" f  s PAADMRowID=$o(^PAADMi("PAADM_AdmDate",pdate,PAADMRowID)) q:PAADMRowID=""  d
	..s PAADMType=$p(^PAADM(PAADMRowID),"^",2)
	..q:(PAADMType'="O")&((PAADMType'="E"))
	..Set VisitStatus=$p($g(^PAADM(PAADMRowID)),"^",20)
	..Quit:VisitStatus="C"
	..s CrUserDR=$p($g(^PAADM(PAADMRowID)),"^",43)
	..q:CrUserDR=""
	..s PAPMIDR=$p(^PAADM(PAADMRowID),"^",1)
	..s PapmiNo=##Class(web.PAPatMas).GetRegistration(PAPMIDR)
	..If PatientID'="" s PatientID=##Class(web.DHCDocOrderEntry).FormatPatientNo($g(PatientID))
	..q:(PatientID'="")&(PapmiNo'=PatientID)
	..s PatientName=$P($G(^PAPER(PAPMIDR,"ALL")),"^",1)
	..q:(PatName'="")&(PatientName'=PatName)
	..s PatDetail=##Class(web.DHCDocOrderEntry).GetPatientByRowid(PAPMIDR)
	..s PatSex=$p(PatDetail,"^",4)
	..s PatAge=$p(PatDetail,"^",5)
	..s admdep=$p($g(^PAADM(PAADMRowID)),"^",4)
	..q:(admdep'=LocRowId)&(LocRowId'="")
	..s admdepdesc=$p($g(^CTLOC(admdep)),"^",2)
	..s admdocdesc=""
	..s admdoc=$p($g(^PAADM(PAADMRowID)),"^",9)
	..if admdoc'="" s admdocdesc=$p($g(^CTPCP(admdoc,1)),"^",2)
	..s admdepdesc1=$p(admdepdesc,"-",2)_admdocdesc
	..s admreason=$p($g(^PAADM(PAADMRowID,1)),"^",7)
	..;Set AdmBillSum=##Class(web.DHCDocOrderEntry).GetToBillSum(PAADMRowID)
	..Set AdmTotal=""	;$p(AdmBillSum,"^",1)
	..Set PatShare=""	;$p(AdmBillSum,"^",4)
	..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(PapmiNo,PatientName,$ZD(pdate,3),admdepdesc1,PAADMRowID,PatSex,PatAge,admreason,AdmTotal,PatShare,PAPMIDR)
	Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod AdmQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetADMOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetADMOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetADMOrderExecute(ByRef qHandle As %Binary, PAADMRowid As %String, AdmInsType As %String, unBillStr As %String, gLoc As %String, UloadDR As %String) As %Status
{
	;s ^TMPZCZdddd=PAADMRowid_"As %String"_AdmInsType_"^"_gLoc_"^"_UloadDR
	;;;gLoc As %String, UloadDR As %String
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	Set QuitFlag=0
	;PAADMRowid, AdmInsType, unBillStr, gLoc, UloadDR
	;d ##class(%ResultSet).RunQuery("web.DHCOPAdmFind","GetADMOrder","857","9","^^",118,23298)
	i PAADMRowid="" {d addblankRowOrd s QuitFlag=1}
	Quit:QuitFlag=1 $$$OK		
	;w "---------",!
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	i OrderRowid=""  {
		;w OrderRowid_"--------------------",!
		d addblankRowOrd
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
		} 
	;取出门诊结算费用配置  
	s myRecLocStr=""
	if ((gLoc'="")&&(UloadDR'="")) d
	.s myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(gLoc,UloadDR)
	
	;循环取出医嘱
	s BillFlag=1
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s BillFlag=1    ;结帐标志
	.i (("^"_unBillStr_"^")[("^"_OrderRowid_"||"_itemsub_"^")) d  s BillFlag=0
	.s mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OrderRowid_"||"_itemsub)
	.i mySkinFlag="Y" d  s BillFlag=0				;判断皮试标志
	.s myLOrdFlag=mySkinFlag
	.s billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	.q:(billed="P")!(billed="I")
	.;如果医嘱未核实则为退出
	.;s InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemsub,11),"^",18) ;OEORI_BBExtCode
	.;Quit:(AdmReason'="")&(InsTypeDR'=AdmReason)
	.s statcode=""
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:((statcode'="V")&(statcode'="E"))
	.s InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemsub,11),"^",18) ;OEORI_BBExtCode
	.Set JfCF=$o(^DHCTarC("CF",""))
	.If (InsTypeDR="")&(JfCF'="") Set InsTypeDR=$P(^DHCTarC("CF",JfCF),"^",3)
	.Quit:((AdmInsType'="")&(AdmInsType'=InsTypeDR))
	.s OEORIRowid=OrderRowid_"||"_itemsub
	.s ArcimRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.s SttDate=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)
	.s SttDate=+$h				;医嘱日期变为当前日期
	.s PackQty=$p($g(^OEORD(OrderRowid,"I",itemsub,9)),"^",4)
	.;i PackQty="" s PackQty=1
	.s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) ;ARC_ItmMast->ARCIM_ItemCat_DR
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  ;ARC_ItemCat->ARCIC_OrderType
	.s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",2) ;名称
	.s ItemGroup=$p($g(^OEORD(+OrderRowid,"I",itemsub,6)),"^",1) ;组别
	.s PackUOMRowid=$p($g(^ARCIM(+ArcimRowid,1,8)),"^",14) ;整包装单位
	.s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s PackUOM=""
	.i PackUOMRowid'=""  d
	..s PackUOM=$p(^CT("UOM",PackUOMRowid),"^",2)
	.s BillPrice=##class(web.UDHCJFPRICE).GetOrderPrice("",InsTypeDR,ArcimRowid,SttDate,"","","",OEPrice)
	.s Price=$P(BillPrice,"^",1)
	.s OrdDiscPrice=$P(BillPrice,"^",2)
	.s OrdInsPrice=$P(BillPrice,"^",3)
	.s OrdPatPrice=$P(BillPrice,"^",4)
	.;get the factor calculate;
	.s INCI=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))		;INC_Itm->RowID
	.If INCI'="" Do 
	..Set INCIUOM=$p(^INCI(INCI,1),"^",10)   ;INC_Itm->INCI_CTUOM_DR
	..Set ConFacDr=$o(^CT("CTCF",0,"UOM",PackUOMRowid,INCIUOM,""))
	..If ConFacDr="" Set ConFac=1
	..Else  Set ConFac=$P(^CT("CTCF",ConFacDr),"^",3)
	.Else  Set ConFac=1
	.;s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(ArcimRowid)
	.;i INCIRowid'=""  d
	.;,OrdDiscPrice,OrdInsPrice,OrdPatPrice
	.;.s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimRowid,INCIRowid)
	.s refundqty=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",23)		;;OE_OrdItem->OEORI_RefundQty
	.i refundqty'="" d
	..s refundqty=refundqty/ConFac		;部分退药数量转换为整包装?
	.else  d
	..s refundqty=0		;
	.s Price=$fn(Price*ConFac,"",6)		;4--->6
	.s OrdDiscPrice=$fn(OrdDiscPrice*ConFac,"",6)		;4--->6
	.s OrdInsPrice=$fn(OrdInsPrice*ConFac,"",6)			;4--->6
	.s OrdPatPrice=$fn(OrdPatPrice*ConFac,"",6)			;4--->6
	.s Doseqty=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)		;OEORI_PhQtyOrd
	.i (OrderType="R")&(PackQty="") s PackQty=1
	.;药品去整包装单位数量OEORI_QtyPackUOM而非药品取OEORI_PHQtyOrd;
	.i ((OrderType="R")&(PackQty'="")) d
	..;s Doseqty=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)
	..;s PackQty=Doseqty
	.e  d 
	..s PackQty=Doseqty
	.s PackQty= PackQty-refundqty		;减去退的数量?
	.;s Amount=$fn(Price*PackQty,"",2)
	.s Amount=$fn(OrdPatPrice*PackQty,"",2)    ;价格改成患者支付  zhaocz
	.s recdepdesc=""
	.s recdepcode=$p($g(^OEORD(+OrderRowid,"I",+itemsub,3)),"^",6) ;接收科室
	.i recdepcode'=""  d
	..s recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	..i ($l(recdepdesc,"-")>1) d  s recdepdesc=$p(recdepdesc,"-",2)
	.q:((myRecLocStr'="")&&(myRecLocStr'[("^"_recdepcode_"^")))
	.s BillSubDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",9) 
	.s ORCATDesc=$p(^ARCBG($p(BillSubDR,"||",1)),"^",2)
	.s Prescno=$p($g(^OEORD(+OrderRowid,"I",itemsub,1)),"^",14) ;处方号
	.s InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemsub,11),"^",18) ;OEORI_BBExtCode
	.s InsTypeDesc="" ;
	.i InsTypeDR="" d
	..s InsTypeDR=$p(^PAADM(PAADMRowid,1),"^",7)     ;PA_ADM->PAADM_AdmReason_DR
	.i InsTypeDR'="" d
	..s InsTypeDesc=$p(^PAC("ADMREA",InsTypeDR),"^",2)  ;PAC_AdmReason->REA_Desc
	.s OrdNo=ind
	.;s myGrpOEFlag="组"
	.s myGrpInfo=##class(web.UDHCOEORDOPIF).ReadOEGrpFlag(+OrderRowid_"||"_itemsub)
	.s myGrpOEFlag=$p(myGrpInfo,"^",1)
	.s myOEORIDR=$p(myGrpInfo,"^",2)
	.Do OutputRowOrd
	d addblankRowOrd
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowOrd
	set Data=$lb(ItemGroup,ArcimDesc,PackUOM,Price,PackQty,Amount,recdepdesc,ORCATDesc,Prescno,OEORIRowid,recdepcode,OrdDiscPrice,OrdInsPrice,OrdPatPrice,OrderType,InsTypeDR,InsTypeDesc,BillFlag,ArcimRowid,OrdNo,myLOrdFlag,myGrpOEFlag, myOEORIDR)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariablesOrd
	set (ItemGroup,ArcimDesc,PackUOM,Price,PackQty,Amount,recdepdesc,ORCATDesc,Prescno,OEORIRowid,recdepcode,OrdDiscPrice,OrdInsPrice,OrdPatPrice,OrderType,InsTypeDR,InsTypeDesc, myGrpOEFlag, myOEORIDR)=""
	s myLOrdFlag=""		;限制医嘱标志
	s BillFlag=0
	s ArcimRowid=""
	s (ArcimRowid,OrdNo)=""
	quit
addblankRowOrd
	;Add a Blank;
	d ResetVariablesOrd
	d OutputRowOrd
	quit
}

ClassMethod GetADMOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetADMOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {			
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDocUserIdBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %String) As %String
{
	If $g(UserCode)'="" {
		s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserCode,"U"),""))
		If UserId'="" Set UserName=$p(^SSU("SSUSR",UserId),"^",2),RetCode=1
		else  Set RetCode=0
	}  else { Set RetCode=1}	
	Set ret=$g(UserId)_"^"_$g(UserName)
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	Q RetCode
}

ClassMethod GetPAADMOrderRowid(EpisodeID As %String) As %String
{
	Q $o(^OEORD(0,"Adm",+EpisodeID,""))
}

ClassMethod GetPatientByNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %String) As %String
{
 s ret=""
	s PapmiRowid=##class(web.DHCDocOrderEntry).GetPapmiRowidByNo(PapmiNo)
	if PapmiRowid'="" s ret=..GetPatientByRowid(PapmiRowid)
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
 ;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
 &javascript<#(retval)#>
	Q ret
}

ClassMethod GetPatientByRowid(PapmiRowid As %String)
{
 //;获得病人个人信息

 s PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
 s ret= PapmiRowid_"^"_PatientName
 q ret
}

ClassMethod ReadByPCSC(PCSCID As %String) As %String
{
	;;^DHCFactPat(0,"PCSCardNo",{FatCP_PCSCardNo},{FatCP_Rowid})
	;w ##class(web.DHCOPAdmFind).ReadByPCSC("")
	;web.DHCOPAdmFind.ReadByPCSC
	q:PCSCID="" ""
	s myrid=""
	s mypatno=""
	q:'$d(^DHCFactPat(0,"PCSCardNo",PCSCID)) ""
	f  s myrid=$o(^DHCFactPat(0,"PCSCardNo",PCSCID,myrid)) q:myrid=""  d
	.s mypatno=$p(^DHCFactPat(myrid),"^",3)
	
	quit mypatno
}

Query AdmQuery(StDate As %String, DateTo As %String, PatientID As %String, PatName As %String, LocRowId As %String) As %Query(ROWSPEC = "TPatID:%String,TName:%String,TAdmDate:%String,TAdmLoc:%String,TRowid:%String,TPatSex:%String,TPatAge:%String,TAdmReason:%String,TTotal:%String,TPatShare:%String,TPatDr:%String")
{
}

Query GetADMOrder(PAADMRowid As %String, AdmInsType As %String, unBillStr As %String, gLoc As %String, UloadDR As %String) As %Query(ROWSPEC = "TGroup:%String,OPOrdItemDesc:%String,OPOrdUnit:%String,OPOrdPrice:%String,OPOrdQty:%String,OPOrdBillSum:%String,OPOrdItemRecLoc:%String,TOrdSubCat:%String,PrescriptionNo:%String,OrdRowId:%String,OPOrdItemRecLocRID:%String,OPOrdDiscPrice:%String,OPOrdInsPrice:%String,OPOrdPatPrice:%String,OPOrdType:%String,OPOrdInsRowId:%String,OPOrdInsType:%String,OPOrdBillFlag:%String,OPOrdItemRowID:%String,OrdNo:%String,LimitItmFlag:%String,GrpOEFlag:%String,OEORIDR:%String")
{
}

}
