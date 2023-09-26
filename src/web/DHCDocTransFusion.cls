Class web.DHCDocTransFusion Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, queryTypeCode As %String, Filtepaid As %String, FilteOtherUser As %String, startDate As %String, endDate As %String) As %Status
{
	///d ##class(%ResultSet).RunQuery("web.DHCDocTransFusion","FindOrdItem",1896,"@ZLDO","","","2022-08-12","")
 s ^Tempscl("FindOrdItemE")=EpisodeID_","_queryTypeCode_","_Filtepaid_","_FilteOtherUser_","_startDate_","_endDate
 Set repid=$I(^CacheTemp)
 s ind=1
 if EpisodeID=""  Set qHandle=$lb(0,repid,0) quit $$$OK
 if queryTypeCode="" Set qHandle=$lb(0,repid,0) quit $$$OK
 i startDate'="" s startDate=..%ZDH(startDate)
 i endDate'="" s endDate=..%ZDH(endDate)
 s queryTypeCode=$P($G(queryTypeCode),"@",2)
 s info1="",info="",infoSub=""
 i queryTypeCode="SYDO" s InstrucDrGroup="输液单" //^DHCCLNurseExec("VarDef",0,queryTypeCode,"PhcIn") 
 i queryTypeCode="ZSDO" s InstrucDrGroup="注射单" //^DHCCLNurseExec("VarDef",0,queryTypeCode,"PhcIn")
 i queryTypeCode="ZLDO" s InstrucDrGroup="治疗单" //^DHCCLNurseExec("VarDef",0,"ZLDO","OrCat")
 i queryTypeCode="FLDO" s InstrucDrGroup="放料单" //^DHCCLNurseExec("VarDef",0,"FLDO","OrCat")
 s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID,1))
 if OEORDRowId="" Set qHandle=$lb(0,repid,0) quit $$$OK
 s OEORIChildsub="0" f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
 .q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
 .q:$G(^OEORD(OEORDRowId,"I",OEORIChildsub,1))=""
 .q:$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",39)'=""
 .s statcode="V"
 .s TtemStat=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
 .i TtemStat'="" d
 ..s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
 .Q:(statcode'="V")&&(statcode'="E") 
 .s flag=##class(DHCDoc.OPDoc.TreatPrint).GetOrdMenuOEChkMap(OEORDRowId_"||"_OEORIChildsub,InstrucDrGroup)
 .q:flag'=1
 .s info=##class(web.DHCDocTransFusion).GetInfoByRowid(OEORDRowId,OEORIChildsub,queryTypeCode,Filtepaid,FilteOtherUser)
 .s info1=info1_info_$c(12)
 .s infoSub=##class(web.DHCDocTransFusion).GetSubInfoByRowid(OEORDRowId,OEORIChildsub,queryTypeCode,Filtepaid,FilteOtherUser)
 .s info1=info1_infoSub_$c(12)
 s Cutcount=$l(info1,$c(12))
 k OrdItemArr
 s SeqNo=0
 f i=1:1:Cutcount d
 .s Info2=$p(info1,$c(12),i)
 .i Info2'="" d
 ..s oeoriId=$p($g(Info2),"^",1)
 ..s arcimDesc=$p($g(Info2),"^",2)
 ..s doseQtyUnit=$p($g(Info2),"^",5)_$p($g(Info2),"^",6)
 ..s phcfrCode=$p($g(Info2),"^",8) 
 ..s phcinDesc=$p($g(Info2),"^",7)
 ..s phOrdQtyUnit=$p($g(Info2),"^",3)_$p($g(Info2),"^",4)
 ..s orcatDesc=""
 ..s ctcpDesc=$p($g(Info2),"^",11) 
 ..s Durat=$p($g(Info2),"^",12)
 ..s OrderDate=$p($g(Info2),"^",9)
 ..if OrderDate'="" s OrderDate=$ZDH(OrderDate,3)
 ..Q:(OrderDate<startDate)&&(startDate'="")
 ..Q:(OrderDate>endDate)&&(endDate'="")
 ..s updateDateTime=..%ZD(OrderDate)_" "_$p($g(Info2),"^",10)
 ..s prescNo=$p($g(Info2),"^",13)
 ..s price=$p($g(Info2),"^",14)
 ..s OEORIDR=$p($g(Info2),"^",15)
 ..s notes=$p($g(Info2),"^",16)
 ..s Reloc1=$p((Info2),"^",17)
 ..s DoseQty=$p($g(Info2),"^",18)
 ..s GroupSelect="on"
 ..s OEORIBilled=$p($g(Info2),"^",19)
 ..s totalAmount=$p($g(Info2),"^",20)
 ..i (totalAmount<1)&&($p(totalAmount,".")="") s totalAmount="0"_totalAmount
 ..s execStat=$p($g(Info2),"^",21)
 ..s OrdItemArr($p(oeoriId,"||",2),OEORIDR)=$lb(oeoriId,arcimDesc,doseQtyUnit,phcfrCode,phcinDesc,phOrdQtyUnit,orcatDesc,ctcpDesc,Durat,reclocDesc,updateDateTime,prescNo,price,GroupSelect,OEORIDR,notes,Reloc1,DoseQty,OEORIBilled,totalAmount,execStat)
 s id1=0,MasterSeqNo=0
 for {
	 s id1=$o(OrdItemArr(id1))
	 q:id1=""
	 s id2=0,SeqSubNo=0
	 
	 for{
		 s id2=$o(OrdItemArr(id1,id2))
		 q:id2=""
		 s Data=$g(OrdItemArr(id1,id2))
		 if (id1'=id2) {
			 s SeqSubNo=SeqSubNo+1
			 s SeqNo=MasterSeqNo_"."_SeqSubNo
		 }else{
			 s MasterSeqNo=MasterSeqNo+1
			 s SeqNo=MasterSeqNo
		 }
		 s Data=Data_$lb(SeqNo)
		 d OutputRow
	 }
 }
 k OrdItemArr
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdItemExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

ClassMethod GetExecPlan(oeoriId)
{
 s Str=""
 s OeoriRowid=$p(oeoriId,"||",1)
 s OEORIChildsub=$p(oeoriId,"||",2)
 s OEOREChildsub="" f  s OEOREChildsub=$o(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub)) q:OEOREChildsub=""  d
 .s OEOREExStDate=$p(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub),"^",1)
 .q:OEOREExStDate<"60000"
 .s Str=Str_$p($zd(OEOREExStDate,4),"/",1)_"/"_$p($zd(OEOREExStDate,4),"/",2)_" "_"^"_$zd(OEOREExStDate,3)_"#"
 q Str
}

ClassMethod GetExecSum(oeoriId)
{
 s Sum=0
 s Str=""
 s OeoriRowid=$p(oeoriId,"||",1)
 s OEORIChildsub=$p(oeoriId,"||",2)
 s OEOREChildsub="" f  s OEOREChildsub=$o(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub)) q:OEOREChildsub=""  d
 .s OEOREExStDate=$p(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub),"^",1)
 .q:OEOREExStDate<"60000"
 .s Str=Str_$p($zd(OEOREExStDate,4),"/",1)_"/"_$p($zd(OEOREExStDate,4),"/",2)_" "_"^"_$zd(OEOREExStDate,3)_"#"
 .s Sum=Sum+1
 q Sum
}

ClassMethod GetGroup(OeoriId)
{
 S EORDRowId=$p(OeoriId,"||",1)
 s OEORIChildsub=$p(OeoriId,"||",2)
 i $P(^OEORD(EORDRowId,"I",OEORIChildsub,11),"^",39)'="" s Group="1"
 e  s Group="0"	
 q Group
}

ClassMethod GetInfoByRowid(OEORDRowId, OEORIChildsub, queryTypeCode, Filtepaid, FilteOtherUser) As %String
{
 s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 s Subscript=$p(ItmMastrowid,"||",1)
 s Version=$p(ItmMastrowid,"||",2)
 s Phcdfdr=$p(^ARCIM(Subscript,Version,1),"^",12)
 s OEORIPrice=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",25)
 ;单价取批次价
 s AdmRowID=$P($G(^OEORD(OEORDRowId)),"^",1)
 s PAADMRegConDisDR=$P($G(^PAADM(AdmRowID,"DHC")),"^",25)
 s ProtocolPackUOMDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",13)
 s ReLocRowid="" s ReLocRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6) //接收科室 
 s ExpStr=OEORDRowId_"||"_OEORIChildsub_"^"_""_"^"_AdmRowID_"^"_ReLocRowid
 s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ItmMastrowid, "", "", "", "", OEORIPrice,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr) 
 s UnitPrice=$p(UnitPrice,"^",1)
 s UserID=%session.Get("LOGON.USERID")
 s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 s BillingUOMdr=$p(^ARCIM(Subscript,Version,8),"^",14) //整包装单位
 s packuom=""
 i BillingUOMdr'="" s packuom=$p(^CT("UOM",BillingUOMdr),"^",2)
 s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 s QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,9)),"^",4) //整包装数量
 s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
 s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
 i +QtyPackUOM=0,OrderType="R" {
	 s BaseUomInfo=##class(web.DHCDocOrderCommon).GetBaseUom(ItmMastrowid)
	 s BaseUOMDesc=$p(BaseUomInfo,"^",2)
	 i FrequenceRowid'="" s FreqFactor=$P(^PHCFR(FrequenceRowid),"^",2)
	 e  s FreqFactor=1
	 i DurationRowid'="" s DuraFactor=$P(^PHCDU(DurationRowid),"^",2)
	 e  s DuraFactor=1
	 s packuom=BaseUOMDesc
 }
 
 
 s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ItmMastrowid)
 s Pqty=""
 i INCIRowid'="" d
 .s oeori=OEORDRowId_"||"_OEORIChildsub
 .s dis=$O(^DHCOEDISQTY(0,"OEORI",oeori,0))
 .q:dis=""
 .q:'$d(^DHCOEDISQTY(dis))
 .s Pqty=$p(^DHCOEDISQTY(dis),"^",2)
 e  d
 .s pqty=0,pbrowid=0
 .f  s pbrowid=$o(^DHCPBi(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,pbrowid)) q:pbrowid=""  d
 ..q:$d(^DHCPB(pbrowid))=10 ;add hujunbin 15.2.5
 ..q:$d(^DHCPB(pbrowid))=0 ;add hujunbin 15.2.5
 ..s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
 ..s pb=pbrowid  ;+2015-3-19 hujunbin 底下获取账单的时候+pb就等于0了
 ..s pbosub=0
 ..f  s pbosub=$o(^DHCPBi(0,"OEORI",OEORDRowId_"||"_OEORIChildsub,pbrowid,pbosub)) q:pbosub=""  d
 ...q:$d(^DHCPB(pbrowid,"O",pbosub))=10
 ...s pbo=^DHCPB(pbrowid,"O",pbosub)
 ...s pbbillqty=$p(pbo,"^",5)
 ...s pbrefundqty=$p(pbo,"^",6)
 ...s pqty=pqty+pbbillqty+pbrefundqty
 .i +pqty'=0 s Pqty=pqty
 .e  s Pqty=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",12)
 s QtyPackUOM=Pqty
 i (OrderType="R") d
 .s OrdMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(OEORDRowId_"||"_OEORIChildsub)
 .s QtyPackUOM=+$P(OrdMesage,"^",12)
 
 
 ;协议单位
 s ProtocolPackUOMDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DHC")),"^",13)
 i ProtocolPackUOMDR'="" d
 . s BillingUOMDR=ProtocolPackUOMDR
 . s packuom=$p($g(^CT("UOM",BillingUOMDR)),"^",2)
 ;--end--
 s DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEORDRowId_"||"_OEORIChildsub) //$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",1) //数量
 s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
 s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 s UpdateDate=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",4)
 s UpdateTime=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",5)
 s OEORIBilled=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",5)
 q:((Filtepaid="on")&(OEORIBilled="P")) ""        
 s DoctorDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
 i DoctorDR'="" s DoctorDesc=$p($g(^CTPCP(DoctorDR,1)),"^",2) e  s DoctorDesc=""
 s UserAdd="" s UserAdd=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,7)),"^",1) e  s UserAdd="" 
 q:((FilteOtherUser="on")&(UserAdd'=UserID)) ""
 s DepProcNotes=""
 s DepProcNotes=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DEP",1)) ;$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DEP")),"^",1)
 s OEORIDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",39)
 if OEORIDR'="" s ARCIMDesc="____"_ARCIMDesc
 if OEORIDR="" s OEORIDR=OEORDRowId_"||"_OEORIChildsub
 i FrequenceRowid'="" s PHCFRDesc=$p($G(^PHCFR(FrequenceRowid)),"^",1)
 s DoseUOM="" s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 i InstructionRowid'="" s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",2) //用法
 s DurationFactor=1
 i DurationRowid'="" d
 .s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
 .s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 s CTUOMDesc=""
 i DoseUOM'="" s CTUOMDesc=$p($g(^CT("UOM",DoseUOM)),"^",2) //剂量单位
 /*s PHCFRDesc=""
 i FrequenceRowid'="" {
	 s PHCFRDesc=$p($g(^PHCFR(FrequenceRowid)),"^",3) //名称
	 s WeekFlag=$P($g(^PHCFR(FrequenceRowid)),"^",9)
	 if (WeekFlag="Y"){
		 s OrderFreqWeek=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,"DHC")),"^",55)
		 s PHCFRDesc=PHCFRDesc_"-"_$TR(OrderFreqWeek,"|","")
	 }
 }*/
 s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OEORDRowId_"||"_OEORIChildsub,"-")
 s PHCFRDesc=$List(OrdFreqInfo,2)
	
 s ReLoc="" s ReLoc=$p($g(^CTLOC(ReLocRowid)),"^",2) s ReLoc=##class(web.DHCOPAdmReg).LocDescFormate(ReLoc)
 s OrderPrescNo=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",14)
 i ((queryTypeCode="SYDO")||(queryTypeCode="ZSDO")) s DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEORDRowId_"||"_OEORIChildsub) //$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",1)
 s OrderStr=##class(web.DHCDocOrderCommon).GetOrderMesage(OEORDRowId_"||"_OEORIChildsub)
 s PriceSum=$P(OrderStr,"^",3) ;总价
 s execStat=$P(OrderStr,"^",10) ;医嘱状态E 执行
 s execStat=$P(execStat,",",1)
 s OrderPrice=$P(OrderStr,"^",8)
 s PriceSum=OrderPrice*(+QtyPackUOM)
 S:execStat'="E" execStat=""
 s info=OEORDRowId_"||"_OEORIChildsub_"^"_$g(ARCIMDesc)_"^"_$g(QtyPackUOM)_"^"_$g(packuom) _"^"_$g(DoseQty)
 s info=info_"^"_$g(CTUOMDesc)_"^"_$g(PHCINDesc)_"^"_$g(PHCFRDesc)_"^"_$zd($g(UpdateDate),3)_"^"_..%ZT($g(UpdateTime),3)
 s info=info_"^"_$g(DoctorDesc)_"^"_$g(DurationDesc)_"^"_OrderPrescNo_"^"_$g(UnitPrice)_"^"_$g(OEORIDR)
 s info=info_"^"_$g(DepProcNotes)_"^"_$g(ReLoc)_"^"_$g(DoseQty)_"^"_OEORIBilled_"^"_PriceSum_"^"_execStat
 q info
}

ClassMethod GetPatientInfo(EpisodeID, CTLOCID)
{
 s PrintTime=$ZDATETIME($HOROLOG,3)
 s Papmi=$p(^PAADM(EpisodeID),"^",1)
 s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
 s AdmReason=$P(^PAADM(EpisodeID,1),"^",7) ;--就诊原因
 s AdmReasonDesc=$P(^PAC("ADMREA",AdmReason),"^",2)
 s AdmReasonStr=AdmReason_":"_AdmReasonDesc
 s info=##Class(web.DHCDocOrderEntry).GetPatientByRowid(Papmi)
 s PapmiRowid=$P(info,"^",1)
 s PapmiNo=$P(info,"^",2)
 s PatientName=$P(info,"^",3)
 s PatientSex=$P(info,"^",4)
 s AgeDesc=$P(info,"^",5)
 s PatientBirthday=$P(info,"^",6)
 s Pattype=$P(info,"^",7)
 s PatientSocialStausDR=$P(info,"^",8)
 s PatientSexDr=$P(info,"^",9)
 s PatientDOB=$P(info,"^",10)
 s PatientCompany=$P(info,"^",11)
 s AgeYear=$P(info,"^",12)
 s AgeMonth=$P(info,"^",13)
 s AgeDay=$P(info,"^",14)
 s PatientComAdd=$P(info,"^",15)
 s EmployeeNO=$P(info,"^",16)
 s PatientMarital=$P(info,"^",17)
 s PatCategoryRowid=$P(info,"^",18)
 s Medcare=$P(info,"^",19)
 s RealName=$P(info,"^",20)
 s RealCard=$P(info,"^",21)
 s SupplyName=$P(info,"^",22)
 s SupplyCard=$P(info,"^",23)
 s GovernCardNo=$P(info,"^",24)
 s Tel=$P(info,"^",25)
 s ALLERGY=$P(info,"^",26)
 s Nation=$P(info,"^",27)
 s Occupation=$P(info,"^",28)
 s PapmiName3=$P(info,"^",29)
 s CardNo=$P(info,"^",30)
 s PersonID=$P(info,"^",31)
 s MrNoE=$P(info,"^",32)
 s ret=PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc
 s ret=ret_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr
 s ret=ret_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay
 s ret=ret_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid
 s ret=ret_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo
 s ret=ret_"^"_$g(Tel)_"^"_$G(ALLERGY)_"^"_$g(Nation)_"^"_$g(Occupation)_"^"_PapmiName3
 s ret=ret_"^"_$g(CardNo)_"^"_$g(PersonID)_"^"_MrNoE
 s CTLOCName=$p(^CTLOC(CTLOCID),"^",2) //$p($p(^CTLOC(CTLOCID),"^",2),"-",2)
 s CTLOCName=##class(web.DHCOPAdmReg).LocDescFormate(CTLOCName)
 Set PAAdmNo=""
 Set PAAdmNo=$P($g(^PAADM(EpisodeID)),"^",81)    ///就诊号 zlj  add
 s HospRowId=$p(^CTLOC(CTLOCID),"^",22)
 s HospName=""
 i HospRowId'="" s HospName=$p(^CT("HOSP",HospRowId),"^",2)
 s info=ret_"^"_CTLOCName_"^"_PrintTime_"^"_PAADMType_"^"_AdmReasonStr_"^"_PAAdmNo_"^"_HospName
 q info
}

ClassMethod GetPhysicTitle(OeoriId)
{
 S EORDRowId=$p(OeoriId,"||",1)
 s OEORIChildsub=$p(OeoriId,"||",2)	
 S ItmMastDr=$P(^OEORD(EORDRowId,"I",OEORIChildsub,1),"^",2)
 s ARCIMSubscript=$p(ItmMastDr,"||",1)
 s ARCIMVersion=$p(ItmMastDr,"||",2)
 s ARCIMAbbrev=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",3)
 q ARCIMAbbrev
}

ClassMethod GetSubInfoByRowid(OEORDRowId, OEORIChildsub, queryTypeCode, Filtepaid, FilteOtherUser) As %String
{
 s info2="",sum=1,infoSub=""
 s OEORIChildsub1="0" f  s OEORIChildsub1=$o(^OEORD(OEORDRowId,"I",OEORIChildsub1)) q:OEORIChildsub1=""  d
 .q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub1))
 .q:$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub1,11)),"^",39)=""
 .s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub1,1)),"^",13)
 .q:ItemStat="4"
 .i $p($p($G(^OEORD(OEORDRowId,"I",OEORIChildsub1,11)),"^",39),"||",2)=OEORIChildsub d
 ..s infoSub=##Class(web.DHCDocTransFusion).GetInfoByRowid(OEORDRowId,OEORIChildsub1,queryTypeCode,Filtepaid,FilteOtherUser)
 ..s info2=info2_infoSub_$c(12)
 q info2
}

ClassMethod GetSumGroup(OeoriId) As %Integer
{
 &sql(select count(oeori_oeori_dr) INTO :OeoriIdcount from SQLUser.oe_orditem where oeori_oeori_dr=:OeoriId)
 s Sum=0
 s Str=""
 s OeoriRowid=$p(OeoriId,"||",1)
 s OEORIChildsub=$p(OeoriId,"||",2)
 s OEOREChildsub="" f  s OEOREChildsub=$o(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub)) q:OEOREChildsub=""  d
 .s OEOREExStDate=$p(^OEORD(OeoriRowid,"I",OEORIChildsub,"X",OEOREChildsub),"^",1)
 .q:OEOREExStDate<"60000"
 .s Str=Str_$p($zd(OEOREExStDate,4),"/",1)_"/"_$p($zd(OEOREExStDate,4),"/",2)_" "_"^"_$zd(OEOREExStDate,3)_"#"
 .s Sum=Sum+1
 q OeoriIdcount_"^"_Sum
}

ClassMethod GetWYInstr(OeoriId)
{
	 q:OeoriId=""
	 s OEORIUserDepDR=$p($g(^OEORD(+OeoriId,"I",+$p(OeoriId,"||",2),7)),"^",2)
	 s OEORIUserHospDr=$p($g(^CTLOC(OEORIUserDepDR)),"^",22)
	 s flag=2
	 s OeoriRowid=$p(OeoriId,"||",1)
	 s OEORIChildsub=$p(OeoriId,"||",2)
	 s InstrucDr=$p($G(^OEORD(OeoriRowid,"I",OEORIChildsub,2)),"^",7) 
	 s WYInstr=..%GetConfig("WYInstr",OEORIUserHospDr) //^DHCDocConfig("WYInstr")
	 s varCount=$l(WYInstr,"^")
	 f i=1:1:varCount d
	 .s pat=$p(WYInstr,"^",i)
	 .i pat=InstrucDr s flag=1  
	 .q:flag'=1
	 q flag
}

ClassMethod filtrateHLD(EpisodeID, itemrowid)
{
 if EpisodeID="" quit
 s info="",info1="",info2="", flag=0
 s RowID="" f  s RowID=$o(^DHCPAADMS(RowID)) q:RowID=""  d  
 .q:RowID=""
 .q:$p(^DHCPAADMS(RowID),"^",1)'=EpisodeID
 .s k=^DHCPAADMS(RowID,"I",0)
 .f i=1:1:k d
 ..s info2=^DHCPAADMS(RowID,"I",i)
 ..i info2=itemrowid s flag=1
 q flag
}

Query FindOrdItem(EpisodeID As %String, queryTypeCode As %String, Filtepaid As %String, FilteOtherUser As %String, startDate As %String, endDate As %String) As %Query(ROWSPEC = "oeoriId:%String,arcimDesc:%String,doseQtyUnit:%String,phcfrCode:%String,phcinDesc:%String,phOrdQtyUnit:%String,orcatDesc:%String,ctcpDesc:%String,Durat:%String,reclocDesc:%String,updateDateTime:%String,prescNo:%String,price:%String,GroupSelect:%String,OEORIDR:%String,notes:%String,ReLoc:%String,DoseQty:%String,OEORIBilled:%String,totalAmount:%String,execStat:%String,seqNo:%String")
{
}

ClassMethod saveTemptype(Sel)
{
	s ^DHCDocTransFusion("Type")=Sel
	Q 0
}

ClassMethod killTemptype()
{
	k ^DHCDocTransFusion("Type")
	Q 0
}

ClassMethod getTemptype()
{
	Q $g(^DHCDocTransFusion("Type"))
}

}
