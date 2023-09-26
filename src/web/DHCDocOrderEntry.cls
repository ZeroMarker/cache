/// 名称:     web.DHCDocOrderEntry
/// 描述:     医嘱录入的控制类
/// 编写者?  周志强
/// 编写日期: 2009.02.20
/// 适用医院?深圳中医院;沈阳医科大医院;地坛医院;北京妇产医院;衢州人民医院;
/// 珠海人民医院;潍坊人民医院
Class web.DHCDocOrderEntry Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CO29(DoseQty As %String, PHCFRrow As %String, PHCDUrow As %String, Prior As %String, SttDate As %String, EndDate As %String) As %String
{
	 n (DoseQty,PHCFRrow,PHCDUrow,Prior,SttDate,EndDate)
	 s Prior=$g(Prior),PriorCode=$p($g(^OECPR(+Prior)),"^")
	 s SttDate=$g(SttDate),EndDate=$g(EndDate)
	 s Freq=$$FreqFac^aOE14(PHCFRrow) 
	 s Duration=$p($g(^PHCDU(+PHCDUrow)),"^",2)
	 i 'PHCDUrow,SttDate,EndDate s Duration=EndDate-SttDate+1
	 ;$$DuraFac^aOE14(PHCDUrow)
	 s s=$g(^PHCFR(+PHCFRrow))
	 s FreqFactor=$p(s,"^",2),FreqDays=$p(s,"^",5)
	 s:'Duration Duration=1
	 ;因为即刻医嘱会把频率和疗程参数置为1,插入医嘱时会把医嘱项医嘱类别加上
	 ;但在门诊不管医嘱类别?所以把下句注释(参考CO29^at122)
	 ;i " ONE STAT "[(" "_PriorCode_" ") s FreqFactor=1,Duration=1
	 i FreqDays,'FreqFactor s FreqFactor=Duration-1\FreqDays+1,Duration=1
	 S QTY=DoseQty*FreqFactor*Duration
	 q QTY
}

/// Creator?      周志强
/// CreatDate?    2009.02.20
/// Description:? 计算医嘱的基本数量
/// Table?        
/// Input?        DoseQty:剂量      PHCFRrow:频次指针   PHCDUrow?疗程指针
/// Prior:优先级指针  SttDate:开始日期    EndDate:截止日期
/// Return?       返回基本数量
/// Others?
ClassMethod CalDose(uom As %String, drgform As %String, doseqty As %String) As %String
{
	
 n (uom,drgform,doseqty)
 q:(+doseqty=0)!(+uom=0) ""
 s eqUom=""
 i drgform'="" d        ; Pharmacy item is only efiended dose equivilent
 .s drgform1=+drgform,drgform2=$p(drgform,"||",2)
 .q:(drgform1="")!(drgform2="")
 .s bsUOMph=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
 .i uom'=bsUOMph d                                       ;Table - PHC_FormDoseEquiv
 ..s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d  q:eqUom=uom
 ...s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 ...s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 i (+eqUom'=0)&(+uom'=0)&(eqUom=uom) d
 .s qty1=doseqty\eqqty,qty2=(doseqty#eqqty)/eqqty
 .s doseqty=qty1+qty2
 ;*/ 12/11/2000 Grace
 ;原来是进位为整数?现在保留小数
 s DeductPartia=""
 if drgform'="",$D(^PHCD(drgform1,"DF",drgform2,"DHC")) d
 .s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,"DHC")),"^",1)
 ;门诊按一天量计算 
 if DeductPartia'="1" {
	 if (drgform'="") {
		 s ArcimSubscript=$o(^ARCIM(0,"PHCDF",drgform,0))
		 s ArcimVersion=$o(^ARCIM(0,"PHCDF",drgform,ArcimSubscript,0))
		 s ArcimRowid=ArcimSubscript_"||"_ArcimVersion
		 s DHCItmRowid=$o(^DHCItmMast("0","ARCIM",ArcimRowid,0))
		 i DHCItmRowid'="" {
			 ;计算单次剂量的偏好值,规则在字段注释上
		 	 s Partial=$p($g(^DHCItmMast(DHCItmRowid)),"^",9)
		 	 if Partial="H" {
			 	;偏好取半
			 	s PartialValue=0.5
			 	s doseqty=PartialValue*(doseqty\PartialValue)+$s(doseqty#PartialValue:PartialValue,1:0)
			 	q doseqty
		 	 }elseif Partial="FU" {
			 	;偏好向上取整
			 	s PartialValue=1
			 	s doseqty=PartialValue*(doseqty\PartialValue)+$s(doseqty#PartialValue:PartialValue,1:0)
			 	q doseqty
		 	 }elseif Partial="FD"{
			 	;偏好向下取整
			 	s PartialValue=1
			 	s doseqty=PartialValue*(doseqty\PartialValue)
			 	i doseqty<1 s doseqty=1
			 	q doseqty
		 	 }else{
			 	;原始值
			 	q doseqty 
		 	 }
	 	 }else{
		 	 s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
		 }
 	 }else{
	 	s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
	 }
 }
 ;s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,2)),"^",6)
 ;if DeductPartia'="Y" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 q doseqty
}

ClassMethod CalEqDose(uom As %String, drgform As %String, doseqty As %String, Type As %String = "") As %String
{
 ;w ##class(web.DHCDocOrderEntry).CalEqDose(7,"215||1",1)
 n (uom,drgform,doseqty,Type)
 q:(+doseqty=0)!(+uom=0) ""
 s eqUom=""
 i drgform'="" d        ; Pharmacy item is only efiended dose equivilent
 .s drgform1=+drgform,drgform2=$p(drgform,"||",2)
 .q:(drgform1="")!(drgform2="")
 .s bsUOMph=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
 .i uom'=bsUOMph d                                       ;Table - PHC_FormDoseEquiv
 ..s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d  q:eqUom=uom
 ...s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 ...s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 i (+eqUom'=0)&(+uom'=0)&(eqUom=uom) d
 .s qty1=doseqty\eqqty,qty2=(doseqty#eqqty)/eqqty
 .s doseqty=qty1+qty2
 q:Type="BaseUom" doseqty
 s eqqty=1
 s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",0))
 i leq'="" {
 	s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 	s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 }
 s doseqty=doseqty*eqqty
 q doseqty
}

ClassMethod CalDoseByDesc(uomdesc As %String, drgform As %String, doseqty As %String) As %String
{
	
 n (uomdesc,drgform,doseqty)
 q:doseqty="" 1
 &SQL(SELECT CTUOM_Rowid into :uom FROM SQLUser.CT_UOM Where CTUOM_Desc=:uomdesc)
 q:uom="" 1
 q:(+doseqty=0)!(+uom=0) ""
 s eqUom=""
 i drgform'="" d        ; Pharmacy item is only efiended dose equivilent
 .s drgform1=+drgform,drgform2=$p(drgform,"||",2)
 .q:(drgform1="")!(drgform2="")
 .s bsUOMph=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
 .i uom'=bsUOMph d                                       ;Table - PHC_FormDoseEquiv
 ..s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d  q:eqUom=uom
 ...s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
 ...s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
 i (+eqUom'=0)&(+uom'=0)&(eqUom=uom) d
 .s qty1=doseqty\eqqty,qty2=(doseqty#eqqty)/eqqty
 .s doseqty=qty1+qty2
 ;*/ 12/11/2000 Grace
 ;原来是进位为整数?现在保留小数
 s DeductPartia=""
 if $D(^PHCD(drgform1,"DF",drgform2,"DHC")) d
 .s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,"DHC")),"^",1)
 if DeductPartia'="1" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 ;s DeductPartia=$p($g(^PHCD(drgform1,"DF",drgform2,2)),"^",6)
 ;if DeductPartia'="Y" s doseqty=doseqty\1+$s(doseqty#1:1,1:0)
 q doseqty
}

ClassMethod CashierInsertOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String) As %Status
{
	 Set Config=##Class(websys.Configuration).%OpenId(1)
	 Set MEDDATA=Config.DataNamespace
	 Set LABDATA=Config.LabDataNamespace
	 Set CurrentNS=$ZNSPACE
	 ZN MEDDATA		
	 Set Ret=$$INSERT^DHCOrdItem(Adm,OrdItemStr,User,Loc,LABDATA,DocUserId)
	 ZN CurrentNS
	 QUIT Ret
}

ClassMethod CheckConflict(EpisodeID As %String, ArcimRowid As %String, HospId As %String = "") As %String
{
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Q:OrderRowid="" "N"
	s ConflictItems=##class(web.DHCDocConfig).GetConflict(ArcimRowid,HospId)
	Q:ConflictItems="" "N"
	s ConflictItems="^"_ConflictItems_"^" 
	s find="N"
	s ARCIMDesc="",tmpARCIMDesc=""
	;循环取出医嘱 !(find="Y")
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.q:'$d(^OEORD(OrderRowid,"I",itemsub,1))
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.s OrdPriorityDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",8)              ;医嘱优先级
	.q:OrdPriorityDR=""
	.;b ;09323
	.;s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)
	.;q:ISLongOrderPrior'=1
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.b //停互斥医嘱时，当天执行记录全部停止
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    .s ItemCatRowId=+$p($g(^ARCIM(+$g(itemrowid),1,1)),"^",10)
    .s StopAllExecItemCat=..%GetConfig("StopAllExecItemCat",HospId) //$g(^DHCDocConfig("StopAllExecItemCat"))
    .s StopAllExecFlag=0
    .i ("^"_StopAllExecItemCat_"^")[("^"_ItemCatRowId_"^") s StopAllExecFlag=1
    .Q:(($g(statcode)="D")||($g(statcode)="C"))&&(StopAllExecFlag'=1)
    .Q:($g(statcode)="I")||($g(statcode)="U")
    .s CurOrdExecStatusFlag=..CheckCurOrdExecStatus(OrderRowid_"||"_itemsub)
    .Q:(CurOrdExecStatusFlag=0)&&(StopAllExecFlag=1)&&((statcode="D")||(statcode="C"))
    .//------end--------------
	.//Q:(statcode'="V")
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.i itemrowid'="" d
	..i ConflictItems[("^"_itemrowid_"^") d
	...b //45
	...s find="Y"
	...s ARCIMDesc=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1)),"^",2)
	...i (CurOrdExecStatusFlag=1)&&((statcode="D")||(statcode="C"))&&(StopAllExecFlag=1) s ARCIMDesc=ARCIMDesc_"的有效执行记录"
	...Q:(","_tmpARCIMDesc_",")[(","_ARCIMDesc_",")
	...i tmpARCIMDesc="" s tmpARCIMDesc=ARCIMDesc
	...e  s tmpARCIMDesc=tmpARCIMDesc_","_ARCIMDesc
	.//Q:find="Y"
	Q find_"^"_tmpARCIMDesc
}

ClassMethod CheckItemDiagnos(PatientTypeRowid As %String, ItemRowid As %String, MRADMID As %String, HOSPID As %String = "", langid As %String = "") As %String
{
	s HOSPID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HOSPID)
	s Count=0
	s find=0
	s MRCIDDesc=""
	if langid="" Set langid=..%LanguageID()
	s Rowid=0 f  s Rowid=$o(^DHCITMDIAi("PatientTypeItm",HOSPID,PatientTypeRowid,ItemRowid,Rowid)) q:Rowid=""  d
	.Q:'$d(^DHCITMDIA(Rowid))
	.s Count=Count+1       
	.s TempItemDiagnos(Count)=$p(^DHCITMDIA(Rowid),"^",3)
	.//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",TempItemDiagnos(Count),HOSPID)="N"
	.Set objDiagnos=##class(User.MRCICDDx).%OpenId(TempItemDiagnos(Count))
 	.if $IsObject(objDiagnos) d
	..//s MRCIDDesc=MRCIDDesc_$C(13)_$C(10)_objDiagnos.MRCIDDesc
	..s ICDDesc=objDiagnos.MRCIDDesc
	..s ICDDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
	..i MRCIDDesc="" s MRCIDDesc=ICDDesc
	..else  s MRCIDDesc=MRCIDDesc_";"_ICDDesc
	
	Q:Count=0 0
	s find=1
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.for i=1:1:Count  d
	..if CodeRowid=TempItemDiagnos(i) s find=0 quit
	d obj.Close()
	q find_"^"_MRCIDDesc
}

ClassMethod CheckItemInDuration(EpisodeID As %String, BillTypeID As %String, ArcimRowid As %String, CurLogonHosp As %String = "") As %String
{
	///w ##class(web.DHCDocOrderEntry).CheckItemInDuration(76939,12,"1046||1")
	;s ^gry("CheckItemInDuration")=EpisodeID_","_BillTypeID_","_ArcimRowid
	;获得病人一定范围内就诊的ADM号
	Q:BillTypeID="" ""
	s n=0
	s findadm=0
	s findorderitem="",ret="",today=..%SysDate()
	s LimitDurFactor=0
	;s LimitDuratonRowid=..%GetConfig("LimitDuration")
    s LimitDuratonRowid=..%GetConfig1("BillTypeDuration",BillTypeID,CurLogonHosp)
    if LimitDuratonRowid'="" s LimitDurFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(LimitDuratonRowid)
	Q:LimitDurFactor=0 ""
	s PapmiRowid=$p($G(^PAADM(EpisodeID)),"^",1)
	s PaadmRowid=EpisodeID+1 f  s PaadmRowid=$o(^PAPERdr(PapmiRowid,"ADM","O",PaadmRowid),-1) q:(PaadmRowid="")!(findadm=1)!(findorderitem'="")  d        
	.s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
	.;如超出检查范围则退出
	.if (AdmDate+LimitDurFactor<today)!(AdmDate>today) s findadm=1
	.Q:findadm=1 
	.;w PaadmRowid,AdmDate,!
	.s pavisit=$p($g(^PAADM(PaadmRowid)),"^",20)
	.q:pavisit="C"
	.;q:EpisodeID=PaadmRowid
	.s findorderitem=..FindOrderItem(PaadmRowid,ArcimRowid)
	.i findorderitem'="" d
	..s durRowid=$p($g(^OEORD($p(findorderitem,"||",1),"I",$p(findorderitem,"||",2),2)),"^",6)
	..s durfactor="0"
	..i durRowid'="" s durfactor=$p($g(^PHCDU(durRowid)),"^",2)
	..i durfactor="" s durfactor="0"
	.Q:findorderitem'=""
	.s n=n+1
	if findorderitem'="" d
	.i (AdmDate+durfactor-today>0) d  
	..s ret=findorderitem_"^"_durfactor_"^"_..%ZD(AdmDate)_"^"_(AdmDate+durfactor-today)
	q ret
}

ClassMethod CheckOrderItem(OrderItemRowid As %String) As %String
{
	s err="0"
	s Qty=0
	s OrderRowid=+OrderItemRowid
	s Childsub=$P(OrderItemRowid,"||",2)
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",2)
	Q:ArcimRowid="" err
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s Freq=$p($g(^OEORD(OrderRowid,"I",Childsub,2)),"^",4)
	Q:(OrderType="R")&(Freq="") "1"
	i OrderType="R" s Qty=..CheckStockEnough(OrderItemRowid)
	Q:(OrderType="R")&(Qty=0) "2"
	Q err
}

ClassMethod CheckStockEnough(OrderItemRowid As %String) As %String
{
	s OrderRowid=+OrderItemRowid
	s itemsub=$P(OrderItemRowid,"||",2)
	s PackQty=$p($g(^OEORD(OrderRowid,"I",itemsub,9)),"^",4)
	s RecLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	s ItemRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s CheckStockEnoughMethod=##Class(web.DHCOPCashier).CheckStockEnough(ItemRowid,PackQty,RecLoc)
	Q CheckStockEnoughMethod
}

ClassMethod CloseGetAllOrderSetItem(ARCOSRowid As %String)
{
	K ^CacheTemp("ARCOI",$j)
}

ClassMethod FindOrderItem(PAADMRowid As %String, ARCIMRowid) As %String
{
	s findorderitem=""
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAADMRowid)
	s SkinTestInstr=..%GetConfig("SkinTestInstr",AdmHospitalId)
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	q:OrderRowid="" findorderitem
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")!(findorderitem'="")  d
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.Q:(ARCIMRowid'=itemrowid)
	.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:(statcode'="V")
	.s InstrRowid=$P($G(^OEORD(OrderRowid,"I",itemsub,2)),"^",7)
	.q:((InstrRowid'="")&&(SkinTestInstr'="")&&(("^"_SkinTestInstr_"^")[("^"_InstrRowid_"^")))
	.s findorderitem=OrderRowid_"||"_itemsub
	Q findorderitem
}

/// 2020-06-10 判断医嘱项是不是医疗结算医嘱
/// @Param : ArcimRowid   医嘱项rowid
/// @return 0 ------not Discharge Arcim
///         1 ------Discharge Arcim
///         2 ------Death Arcim
ClassMethod IsDischargeOrd(ARCIMRowid As %String, CurLogonHosp As %String) As %String [ ProcedureBlock = 1 ]
{
	s dischargeNeedArcimStr=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.GetDisChargeNeedArcimStr","dischargeNeedArcim", CurLogonHosp)
	s deathDischargeNeedArcimStr=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.GetDisChargeNeedArcimStr","deathDischargeNeedArcim", CurLogonHosp)
	if (("^"_deathDischargeNeedArcimStr_"^")[("^"_ARCIMRowid_"^")){
		Quit 2
	}
	if (("^"_dischargeNeedArcimStr_"^")[("^"_ARCIMRowid_"^")){
		Quit 1
	}
	q 0
}

/// / w ##class(web.DHCDocOrderEntry).FindSameOrderItem($LG(^Wqy("FindSameOrderItem"),1),$LG(^Wqy("FindSameOrderItem"),2),$LG(^Wqy("FindSameOrderItem"),3),$LG(^Wqy("FindSameOrderItem"),4))
ClassMethod FindSameOrderItem(PAADMRowid As %String, ARCIMRowid As %String, CheckOrderPriorRowid As %String, CurLogonHosp As %String = "") As %Boolean
{
	n (PAADMRowid,ARCIMRowid,CheckOrderPriorRowid,CurLogonHosp,%session)
	;s ^Wqy("FindSameOrderItem")=$LB(PAADMRowid,ARCIMRowid,,CheckOrderPriorRowid,CurLogonHosp)
	s FindOrdItemID=""
	s CurLogonHosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	;不需要提示重复的子类
	s NotAlertRepeatItemCat="^"_..%GetConfig("NotAlertRepeatItemCat",CurLogonHosp)_"^"
	;皮试医嘱不提示
	s SkinTestInstr="^"_..%GetConfig("SkinTestInstr",CurLogonHosp)_"^"
	;不同医嘱类型需提示重复的子类
	s NotSamePriorNeedAlertItemCat="^"_..%GetConfig("NotSamePriorNeedAlertItemCat",CurLogonHosp)_"^"
	s PatientID=$P(^PAADM(PAADMRowid),"^",1)
	s PAAdmType=$P(^PAADM(PAADMRowid),"^",2)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowid,CurLogonHosp)
	;出院类医嘱需要判断
	s dischargeNeedArcimStr="^"_##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.ord.GetDisChargeNeedArcimStr","dischargeNeedArcim", CurLogonHosp)_"^"
	if dischargeNeedArcimStr[("^"_ARCIMRowid_"^"){
		for i=1:1:$L(dischargeNeedArcimStr,"^"){
			s ItmMastID=$P(dischargeNeedArcimStr,"^",i)
			d OneItmMast
		}
	}else{
		s ItmMastID=ARCIMRowid
		d OneItmMast
	}
	Q FindOrdItemID
OneItmMast
	Q:ItmMastID=""
	s ItemCatDR=$p(^ARCIM(+ItmMastID,1,1),"^",10)
	Q:(NotAlertRepeatItemCat[("^"_ItemCatDR_"^"))
	s DARCIMRowid=$O(^DHCItmMast("0","ARCIM",ItmMastID,""))
	s RepeatCheckDays=$P($G(^DHCItmMast(+DARCIMRowid)),"^",37)		;重复判断天数
	;门诊毒麻精一 需跨就诊判断当天是否重复
	if (PAAdmType'="I")&&(+RepeatCheckDays=0)&&(" 5 6 8 "[(" "_PHPrescType_" ")){
		s RepeatCheckDays=1
	}
	;配置重复天数 那么跨就诊进行判断
	if RepeatCheckDays>0{
		for AdmType="O","I","E"{
			 s AdmID="" for{
				s AdmID=$o(^PAPERdr(PatientID,"ADM",AdmType,AdmID)) Q:AdmID=""
				d OneAdm
				Q:FindOrdItemID'=""
			 }
			 Q:FindOrdItemID'=""
		}
	}else{
		s AdmID=PAADMRowid
		d OneAdm
	}
	Q
OneAdm
	s Ord=..GetPAADMOrderRowid(AdmID)
	Q:Ord=""
	s SttDate="" for{
		s SttDate=$O(^OEORDi(0,"ARCIM",Ord,ItmMastID,SttDate)) Q:SttDate=""
		continue:(RepeatCheckDays>0)&&(($H-SttDate+1)>RepeatCheckDays)
		s Sub=0 for{
			s Sub=$O(^OEORDi(0,"ARCIM",Ord,ItmMastID,SttDate,Sub)) Q:Sub=""
			d OneOrdItem
			Q:FindOrdItemID'=""
		}
		Q:FindOrdItemID'=""
	}
	Q
OneOrdItem
	s OrdItemID=Ord_"||"_Sub
	s StatusCode=##class(DHCDoc.Order.Common).GetOrdStatusCode(OrdItemID)
	Q:StatusCode'="V"
	s InstrRowid=$P($G(^OEORD(Ord,"I",Sub,2)),"^",7)
	Q:(InstrRowid'="")&&(SkinTestInstr[("^"_InstrRowid_"^"))
	s ORDVLStatCode=""
	///虚拟长期医嘱记录id
	s ORDVLRowID=$O(^DHCDocORDVLi(0,"OrdItemDR",OrdItemID,0))
	if (ORDVLRowID'="") d
	.s ORDVLStatDR=$p($g(^DHCDocORDVL(ORDVLRowID)),"^",2)
	.s ORDVLStatCode=$p($g(^OEC("OSTAT",+ORDVLStatDR)),"^",1)
	Q:(ORDVLStatCode'="")&&(ORDVLStatCode'="V")&&(ORDVLStatCode'="E")
	s PriorID=$p($g(^OEORD(Ord,"I",Sub,1)),"^",8)
	Q:(CheckOrderPriorRowid'="")&&(CheckOrderPriorRowid'=PriorID)&&(NotSamePriorNeedAlertItemCat'[("^"_ItemCatDR_"^"))
	s FindOrdItemID=OrdItemID
	Q
}

/// w ##class(web.DHCDocOrderEntry).FindSameOrderItemFlagMethod("688","1043||1")
ClassMethod FindSameOrderItemFlagMethod(PAADMRowid As %String, ARCIMRowid As %String, CheckOrderPriorRowid As %String, CurLogonHosp As %String = "", langid As %String = "") As %String
{
	if langid="" s langid=..%LanguageID()
	s FindOrdItemID=..FindSameOrderItem(PAADMRowid, ARCIMRowid,CheckOrderPriorRowid,CurLogonHosp)
	if (FindOrdItemID'=""){
		s OrderPriorType=$SELECT(##class(DHCDoc.Order.Common).IsOutOrdItem(FindOrdItemID):"出院带药",
							##class(DHCDoc.Order.Common).IsLongOrdItem(FindOrdItemID):"长期医嘱",
							1:"临时医嘱")
		s SttDate=..%ZD($P(^OEORD(+FindOrdItemID,"I",$P(FindOrdItemID,"||",2),1),"^",9))
		s FindPAADMRowid=$P(^OEORD(+FindOrdItemID),"^",1)
		if FindPAADMRowid'=PAADMRowid{
			s OrdDepDr=$P(^OEORD(+FindOrdItemID,"I",$P(FindOrdItemID,"||",2),1),"^",3)
			s OrdDep=$P(^CTLOC(OrdDepDr),"^",2)
			s OrdDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrdDep,langid)
			s SttDate=SttDate_" "_OrdDep
		}
		Q 1_"^"_OrderPriorType_"^"_SttDate
	}
	Q 0
}

ClassMethod FindSameOutOrderItem(PAADMRowid As %String, ARCIMRowid As %String, ARCIMRowidStr As %String = "") As %Boolean
{
	n (PAADMRowid,ARCIMRowid,ARCIMRowidStr)
	s ^tmpgry("FindSameOutOrderItem")=PAADMRowid_","_ARCIMRowid_","_ARCIMRowidStr
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	s today=..%SysDate()
	s findorderitem=0
	q:OrderRowid="" findorderitem
	s PAAdmType=..GetPAAdmType(PAADMRowid)
	q:PAAdmType'="I" findorderitem
	
	;出院带药医嘱
 	s OutOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORDi(0,"Priority",OrderRowid,OutOrderPriorRowid,itemsub)) q:(itemsub="")!(findorderitem=1)  d
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:(statcode'="V")&&(statcode'="I")
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.q:itemrowid="" 
	.Q:(itemrowid'=ARCIMRowid)
	.s findorderitem=1
	
	;查找本次录入的医嘱中是否有重复的
	;ARCIMRowidStr  PriorityDR_"^"_ARCIMRowid_"!"_PriorityDR_"^"_ARCIMRowid
	s Len=$L(ARCIMRowidStr,"!")
	for i=1:1:(Len-1) {
		s TempStr=$p(ARCIMRowidStr,"!",i)
		s PriorityDR=$p(TempStr,"^",1)
		s ARCIMId=$p(TempStr,"^",2)
		if (ARCIMId="")||(PriorityDR="") continue
		s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
		i ($zcvt(PriorityCode,"U")="OUT")&&(ARCIMId=ARCIMRowid) {
			s findorderitem=1
			Q
		}
	}
	Q findorderitem
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

ClassMethod FormatDate(DateNum As %String) As %String
{
	s Date=$ZD(DateNum,3)
	s Year=$P(Date,"-",1)
	s Month=$P(Date,"-",2)
	s Day=$p(Date,"-",3)
	Q Year_"年"_Month_"月"_Day_"日"
}

ClassMethod FormatPatientNo(PapmiNo As %String) As %String
{
	s len=+$p(^CF("PATCF",1,3),"^",5)
	if $l(PapmiNo)<len d
	.s prelen=len-$l(PapmiNo)
	.for i=1:1:prelen s PapmiNo="0"_PapmiNo
	Q PapmiNo
}

ClassMethod GetARCIMBillClass(ARCIMRowid As %String) As %String
{
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	Q:DrgFormRowid="" ""
	s DrgMastRowid=$p(DrgFormRowid,"||",1)
	s OfficialCode=$p($g(^PHCD(DrgMastRowid,4)),"^",2)
	q OfficialCode
}

ClassMethod GetARCIMBillGrpDesc(ArcimRowid As %String) As %String
{
	s BillsubRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",9)
	q:BillsubRowid="" ""
	s BillGrpDesc=$p(^ARCBG(+BillsubRowid),"^",2)
	q BillGrpDesc
}

ClassMethod GetARCIMDefaultPackQty(ArcimRowid) As %String
{
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s PackQty=1
	i (OrderType="R") d
	.s DrgformRowid=..GetDrgForm(ArcimRowid)
	.Q:DrgformRowid=""
	.s PriorRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",22)
	.s PHCDRowid=$p(DrgformRowid,"||",1)
	.s ChildSub=$p(DrgformRowid,"||",2)
	.s FrequenceRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	.s DurationRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	.s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	.i leq="" d
	..s DoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	..s DoseUOM=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	.e  d
	..s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	..s DoseUOM=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	..if eqdefaultqty'="" s DoseQty=eqdefaultqty
	..e  s DoseQty=eqqty
	.s PackQty=..GetPackqty(ArcimRowid,DrgformRowid, FrequenceRowid , PriorRowid, DurationRowid, DoseQty, DoseUOM)
	.;s ^zhou("tes1")=ArcimRowid_"^"_DrgformRowid_"^"_FrequenceRowid_"^"_PriorRowid_"^"_DurationRowid_"^"_DoseQty_"^"_DoseUOM_"^"_PackQty
	Q PackQty
}

ClassMethod GetARCIMDetail(ArcimRowid As %String) As %String
{
	s BillGrpDesc=""
	s FormDesc=""
	s ItemType=""
	s BillsubRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",9)
	i BillsubRowid'="" s BillGrpDesc=$p(^ARCBG(+BillsubRowid),"^",2)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s DrgformRowid=..GetDrgForm(ArcimRowid)
	i DrgformRowid'="" {
	  s PHCDRowid=$P(DrgformRowid,"||",1)
	  s ChildSub=$P(DrgformRowid,"||",2)
	  s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
	  i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	  i ItemCatRowid'="" d
	  .s CNMedItemCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	  .i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	  .s MedItemCat=..%GetConfig("MedItemCat")
	  .i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	  .s CPMedItemCat=..%GetConfig("CPMedItemCat")
	  .i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	}
	q BillGrpDesc_"^"_FormDesc_"^"_ItemType
}

/// Creator?      周志强
/// CreatDate?    2009.04.14
/// Description:? 得到医嘱的最大整数量限定,最早在DHC_ItmMast.MaxQty定义了一个字段维护?
/// 现在决定迁移到ARC_ItmMast.MaxQty,为了保证各项目的兼容,先找DHC_ItmMast
/// 再去找ARC_ItmMast
/// Table?        DHC_ItmMast,ARC_ItmMast
/// Input?        ARCIMRowid:医嘱项指针
/// Output:         
/// Return?       限定值
ClassMethod GetARCIMMaxQty(ARCIMRowid As %String) As %String
{
	s MaxQty=""
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	i DHCARCIMRowid'="" s MaxQty=$p(^DHCItmMast(DHCARCIMRowid),"^",3)
	i MaxQty="" s MaxQty=$p($G(^ARCIM($p(ARCIMRowid,"||",1),$p(ARCIMRowid,"||",2),9)),"^",38)
	i MaxQty="" s MaxQty="0"
	q $g(MaxQty)
}

ClassMethod GetARCItemSubCatID(ARCIMRowid As %Library.String = "") As %String
{
 s SubCatID=""
 if ARCIMRowid'="" set SubCatID=$p(^ARCIM($p(ARCIMRowid,"||",1),$p(ARCIMRowid,"||",2),1),"^",10)
	 q SubCatID
}

/// 通过医嘱代码得到医嘱RowId
ClassMethod GetARCIMByCode(ARCIMCode As %Library.String = "") As %String
{
	Q:ARCIMCode="" ""
	s ARCIMRowId=""
	s ARCIMCode=$$ALPHAUP^SSUTIL4(ARCIMCode)
 	s Subscript=$O(^ARCIM(0,"Code",ARCIMCode,""),-1)
 	s Version=$O(^ARCIM(0,"Code",ARCIMCode,Subscript,""),-1)
 	s ARCIMRowId=Subscript_"||"_Version
	q ARCIMRowId
}

ClassMethod GetARCItemSubCatIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", ARCIMRowid As %Library.String = "") As %String
{
	s ret=..GetARCItemSubCatID(ARCIMRowid)
	;s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;&javascript<#(retval)#>
	q ret
}

ClassMethod GetAllOrderSetItem(ARCOSRowid As %String, HospID As %String = "")
{
	n (ARCOSRowid,HospID,%session)
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	d ..GetOrderSetItem(ARCOSRowid,ARCOSDateRowid,HospID)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.d ..GetAllOrderSetItem(+s)
	Q 0
}

ClassMethod GetBillItems(pattype As %String, instype As %String, arcim As %String) As %String
{
	s BillItems=""
	s sttdate=..%SysDate()
	s ExecuDate=""
	s ARCIMSub=$p(arcim,"||",1)
	f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) q:ExecuDate=""  d
	.q:ExecuDate>sttdate
	.s OLT=""
	.f  s OLT=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) q:OLT=""  d
	..s EndDate=$p(^DHCOLT(OLT),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+1
	..q:EndDate<sttdate
	..s qty0=$p(^DHCOLT(OLT),"^",3)
	..s Itm=$p(^DHCOLT(OLT),"^",2)
	..s desc=$p($g(^DHCTARI(Itm)),"^",2)
	..s err=##class(web.UDHCJFPRICE).GetItmPrice(Itm,sttdate,instype,pattype,"")
	..s Price=$p(err,"^",1)*qty0
	..s DiscPrice=$p(err,"^",2)*qty0
	..s InsPrice=$p(err,"^",3)*qty0
	..s PatPrice=$p(err,"^",4)*qty0
	..s INCIRowid=..GetINCI(ARCIMSub)
	..s ConFac=1
	..if INCIRowid'="" d
	...s ConFac=..GetConFac(arcim,INCIRowid,"")
	...s Price=$fn(Price*ConFac,"",4)
	...s DiscPrice=$fn(DiscPrice*ConFac,"",4)
	...s InsPrice=$fn(InsPrice*ConFac,"",4)
	...s PatPrice=$fn(PatPrice*ConFac,"",4)
	..i BillItems="" s BillItems=desc_"^"_qty0_"^"_Price
	..e  s BillItems=BillItems_"!"_desc_"^"_qty0_"^"_Price
	Q BillItems
}

ClassMethod GetCHNMedListBroker(JSFunName As %String, Alias As %String, GroupID As %String)
{
	;ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,SubCategoryDesc:%String,Price:%String,BillUOM:%String
	;s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice,billuom)
	Set rset = ##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	// Execute the query
	s Category="",SubCategory=""
	Set rs = rset.Execute(Alias,GroupID,Category,SubCategory, "", "", "", "", "", "", "", "", "", "", "", "")
 While (rset.Next()) {
	 	s Desc=rset.Data("ARCIMDesc")
	 	s Rowid=rset.GetData(2)
	 	s Price=$fn(rset.Data("Price"),"",4)
	 	i $l(Desc,"-")>1 d
	 	.;s mydes=$p(mydes,"-",2)
		s rtnval=JSFunName_"('"_$ZCVT($g(Desc),"O","JS")_"','"_$ZCVT($g(Rowid),"O","JS")_"','"_$ZCVT($g(Price),"O","JS")_"');"
		&javascript<#(rtnval)#>
 }

 d rset.Close()
 q 0
}

ClassMethod GetCNPrescItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCNPrescItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCNPrescItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
 set RowCount=0
 do CheckRowCount3
 if RowCount>0 d
 .&sql(DECLARE CNCursor CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),OEORI_SeqNo,
 OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,
	       OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,oeori_PHFreq_dr->PHCFR_Desc1,
	       OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,
	       OEORI_QtyPackUOM,
	       OEORI_RecDep_DR->CTLOC_Desc,OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,OEORI_BBExtCode
	  INTO :Rowid,:OrderName,:StartDate,:SeqNo,:DoseQty,:DoseUOM,:Priority,:Status,:Frequence,:Instruction,:Duration,:PackQty,:RecDep,:Billed,:ARCIMRowid,:SttDate,:BillType
	  From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and OEORI_ItemStat_DR->OSTAT_Code='V')
	.&sql(OPEN CNCursor)
 .for  &SQL(FETCH CNCursor) QUIT:SQLCODE  do
 	..s PackUOMRowID=$p($g(^OEORD(+Rowid,"I",$P(Rowid,"||",2),"DHC")),"^",13)
	..s:PackUOMRowID="" PackUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,AdmType)
	..s PackUOM=$p(^CT("UOM",PackUOMRowID),"^",2)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s Sum=PackQty*Price
	..i BillType="" s BillTypeDesc="自费"
	..e  s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
	..do OutputRow3
	.&sql(CLOSE CNCursor)
 else  Do
 .do ResetVariables3
 .Do OutputRow3	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	Quit
ResetVariables3
	set (Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc)=""
	quit
CheckRowCount3
 if PrescNo="" s RowCount=0
 else  d
 .&sql(SELECT Count(*) INTO :RowCount From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID)
	quit
}

ClassMethod GetCNPrescItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCNPrescItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCategoryBroker(itmjs As %Library.String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.OECOrderCategory:LookUpCat")
	 do rset.Execute("","","","","")
	 While (rset.Next()) {
		s Desc=rset.GetData(1)
		s value=rset.GetData(2)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

/// modified by xp,2014-05-30,增加协议包装处理 PackUOMRowid
/// modified by tanjishan,2020-10-27 PackUOMRowid修改为为必填项，计价单位目前已弃用
/// --可通过##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowID,AdmType)进行默认值初始化.
ClassMethod GetConFac(ARCIMRowid As %String, INCIRowid As %String, PackUOMRowid As %String) As %String
{
	;s convqty=$$ConvFac^ST02(billuom,baseuom)
	Q:INCIRowid="" 1
	s ConFac=""
	i (PackUOMRowid'="") s Billuom=PackUOMRowid
	e  s Billuom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s Baseuom=$p($g(^INCI(INCIRowid,1)),"^",10)                     ; INCI_CTUOM_DR  库存基本单位
	Q:(Baseuom=Billuom)&&(Billuom'="") 1
	q:(Billuom="") 1
	s ConFacID="" s ConFacID=$O(^CT("CTCF",0,"UOM",Billuom,Baseuom,ConFacID))
	i ConFacID="" s ConFac=0
	e  s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	i +ConFac=0  s ConFac=1
	q ConFac
}

ClassMethod GetDefaultRecloc(EpisodeID As %String, Arcim As %String) As %String
{
	s DefaultRecloc=""
	s DefaultNoOrdLocRecLoc=""
	s DefaultOrdLocRecLoc=""
	s OrdLocRecLoc=""
	s NoOrdLocRecLoc=""
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	if admType="I" do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	
	s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	Q:EpLoc="" ""
	s sub=0  f  s sub= $O(^ARCRL(+Arcim,sub))  Q:(sub="")  d 
	 . s OrdLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 1)
	 . Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	 . s TimeFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 5)
	 . s TimeTo=$P($g(^ARCRL(+Arcim,sub)),"^", 6)
	 . s DateFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 8)
	 . s DateTo=$P($g(^ARCRL(+Arcim,sub)),"^", 9)
	 . Q:(DateTo'="")&&(DateTo<Today)
	 . Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
 	. s Default=$P($g(^ARCRL(+Arcim,sub)),"^", 4)
	. s RecLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 2)
	. i OrdLoc'="" d
	. . i Default="Y" d
	. . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	. . e  d 
	. . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	. e  d
	. . i Default="Y" d
	. . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	. . e  d 
	. . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	;优先级顺序:默认的有就诊科室?有就诊科室?默认无就诊科室?无接受科室
	i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	e  d
	. i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	. e  d
	. . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	. . e  d
	. . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
 Q:DefaultRecloc'="" DefaultRecloc
 ;
 s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
 Q:ItemCat="" ""
 s rl=0  f  s rl=$O(^ARC("IC",ItemCat,"RL",rl)) q:(rl="")  d
 . s OrdLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",2)
 . Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
 . s TimeFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",5)
 . s TimeTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",6)
 . s DateFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",8)
 . s DateTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",9)
 . Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
 . s RecLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",3)
 . s Default=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",4)
 . i OrdLoc'="" d
 . . i Default="Y" d
 . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
 . . e  d 
 . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
 . e  d
 . . i Default="Y" d
 . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
 . . e  d 
 . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
 . ;优先级顺序:默认的有就诊科室?有就诊科室?默认就诊受科室?无接受科室
 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
 e  d
 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
 . e  d
 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
 . . e  d
 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
 Q:DefaultRecloc'="" DefaultRecloc
 ;
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
 s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
 Q:OrderCat="" ""
 s sub=0  f  s sub=$O(^OEC("ORCAT",OrderCat,"RL",sub)) Q:(sub="")  d
 . s OrdLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 2)
 . Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
 . s TimeFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 5)
 . s TimeTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 6)
 . s DateFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 8)
 . s DateTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 9)
 . Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
 . s Default=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 4)
	. s RecLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 3)
	. i OrdLoc'="" d
	. . i Default="Y" d
	. . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	. . e  d 
	. . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	. e  d
	. . i Default="Y" d
	. . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	. . e  d 
	. . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	;优先级顺序:默认的有就诊科室?有就诊科室?默认无就诊科室?无接受科室
	i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	e  d
	. i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	. e  d
	. . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	. . e  d
	. . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	Q DefaultRecloc
}

ClassMethod GetDiagnosLimitDurFactor(PatientTypeRowid As %String, MRADMID As %String, LogonHospId As %String = "") As %String
{
	q:(PatientTypeRowid="")!(MRADMID="") 0
	i ($g(LogonHospId)="")&&($d(%session)) s LogonHospId=%session.Get("LOGON.HOSPID")
 	s Count=0
 	s MaxDurFactor=0
	s Rowid=0 f  s Rowid=$o(^DHCPADIADuration("0","PatientType",LogonHospId,PatientTypeRowid,Rowid)) q:Rowid=""  d
	.s DiagnoseDR=$p(^DHCPADIADuration(Rowid),"^",2)
	.//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",DiagnoseDR,LogonHospId)="N"
	.s Count=Count+1
	.s DurationRowid=$p(^DHCPADIADuration(Rowid),"^",3)
	.s DurationFactor=1
	.if DurationRowid'="" s DurationFactor=$p($g(^PHCDU(DurationRowid)),"^",2)
	.s DurDiagnoseRowid=$p(^DHCPADIADuration(Rowid),"^",2)
	.s TempDurationRowids(Count)=DurationRowid
	.s TempDurationFactors(Count)=DurationFactor
	.s TempDurDiagnoseRowids(Count)=DurDiagnoseRowid
	Q:Count=0 0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.for i=1:1:Count  d
	..if CodeRowid=TempDurDiagnoseRowids(i) d
	...if (TempDurationFactors(i)>MaxDurFactor) s MaxDurFactor=TempDurationFactors(i)
	d obj.Close()
	q MaxDurFactor
}

ClassMethod GetDrgForm(ARCIMRowid As %String) As %String
{
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	q $g(DrgFormRowid)
}

ClassMethod GetDrgFormPoison(ARCIMRowid As %String) As %String
{
	s DrgFormRowid=..GetDrgForm(ARCIMRowid)
	Q:DrgFormRowid="" ""
	s DrgFormPoison=$p(^PHCD(+DrgFormRowid,1),"^",4)
	if DrgFormPoison=$C(0) s DrgFormPoison=""
	q $g(DrgFormPoison)
}

ClassMethod GetDurationFactor(DurationRowid As %String) As %String
{
	s DurFactor=0
	&SQL(SELECT PHCDU_Factor into :DurFactor FROM SQLUser.PHC_Duration WHERE PHCDU_Rowid=:DurationRowid)
	Q DurFactor
}

ClassMethod GetINCI(ARCIMsub As %String) As %String
{
	n INCIrow
	s ARCIMsub=$p(ARCIMsub,$c(1),1)
	s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
	q $g(INCIrow)
}

ClassMethod GetItemConFac(ArcimRowid As %String) As %String
{
	n billuom,baseuom
	;s baseuom=$$baseuom^CHB02(ArcimRowid)
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimRowid)
	if CheckCHNFlag="Y" q 1
	Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	Quit:inci="" 1
	Set baseuom=$p(^INCI(inci,1),"^",10)
	s billuom=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8),"^",14)
	s convqty=$$ConvFac^ST02(billuom,baseuom),convqty=$p(convqty,$c(1),1)
	;s ^zhou("con",ArcimRowid)= convqty
	Q convqty
}

ClassMethod GetLocICDListBroker(itmjs As %Library.String = "", LocRowid As %Library.String = "") As %String
{
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:GetLocICD")
	d obj.Execute(LocRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("Desc")
	.s Rowid=obj.Data("Rowid")
	.s Code=obj.Data("Code")
	.s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(Rowid,"O","JS")_"','"_$ZCVT(Code,"O","JS")_"');"
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod GetLocRowidbyDescMethod(LocDesc As %String) As %String
{
	&SQL(Select CTLoc_Rowid into :LocRowid From SQLUser.CT_Loc Where CTLoc_Desc=:LocDesc)
	Q:SQLCODE=0 LocRowid
	Q ""
}

ClassMethod GetMRDiagnoseCount(MRADMID As %String) As %String
{
 s DiagnoseCount=0
	&sql(Select Count(*) into :DiagnoseCount From SQLUser.MR_Diagnos Where MRDIA_MRADM_Parref=:MRADMID)
	Q DiagnoseCount
}

ClassMethod GetCMMRDiagnoseCount(MRADMID As %String) As %String
{
   ;Q ..GetDiagCount(MRADMID,"中医")
	 Q ..GetDiagCount(MRADMID,..%Translate("diagnosentry.v8.csp","中医"))
}

ClassMethod GetMMDiagnoseCount(MRADMID As %String) As %String
{
   ;Q ..GetDiagCount(MRADMID,"西医")
	 Q ..GetDiagCount(MRADMID,..%Translate("diagnosentry.v8.csp","西医"))
}

ClassMethod GetDiagCount(MRADMID, DiagCat = "")
{
	s DiagnoseCount=0
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  d
	.s Rowid=obj.Data("ID")
	.s Cat=##class(DHCDoc.Diagnos.Common).GetDiagnosCat(Rowid,"")
	.;q:Cat="证型"	;证型不算条数
	.q:Cat=..%Translate("diagnosentry.v8.csp","证型")
	.if (DiagCat="")||(Cat=DiagCat) d
	..s DiagnoseCount=DiagnoseCount+1
	Q DiagnoseCount
}

ClassMethod GetMRNo(PatientID As %String) As %String
{
	s MRNo=""
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
	if HospitalCode="BJDTYY" {
		//北京地坛医院优先选择门诊病历号
		s objPAPatmas=##Class(User.PAPatMas).%OpenId(PatientID)
		if $IsObject(objPAPatmas) d
		.s MRNo=objPAPatmas.PAPMIGovernCardNo
		.i MRNo="" d
		..s objPAPerson=##Class(User.PAPatMas).%OpenId(PatientID)
		..if $IsObject(objPAPerson) d
		...s MRNo=objPAPerson.PAPMIMedicare
		...i MRNo="" d
		....s objPAPerson=##Class(User.PAPerson).%OpenId(PatientID)
	    ....s MRNo=objPAPerson.PAPEREmployeeNo
	}else{
		s objPAPatmas=##Class(User.PAPatMas).%OpenId(PatientID)
		if $IsObject(objPAPatmas) d
		.s MRNo=objPAPatmas.PAPMIMedicare
		.i MRNo="" d
		..s objPAPerson=##Class(User.PAPerson).%OpenId(PatientID)
		..if $IsObject(objPAPerson) d
		...s MRNo=objPAPerson.PAPERGovernCardNo
		...i MRNo="" d
	 	....s MRNo=objPAPerson.PAPEREmployeeNo
	}
	Q MRNo
}

ClassMethod GetOrderItemDetail(PatType As %String, InsType As %String, OEORIRowid As %String) As %String
{
	s QtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEORIRowid)
	s PackQty=$P(QtyInfo,"^",1)
	s PackQtyUom=$P(QtyInfo,"^",2)
	s PackQtyUomID=$P(QtyInfo,"^",3)

	s par=+OEORIRowid
	s sub=$p(OEORIRowid,"||",2)
	s OEORERowId=""
	s AdmId=$p($g(^OEORD(par)),"^",1)
	s EpissubtypeDR=$p(^PAADM(AdmId,1),"^",6)
	s AdmReasonDR=$p(^PAADM(AdmId,1),"^",7)
	
	s ArcimId=$p($g(^OEORD(par,"I",sub,1)),"^",2)
	s SttDate=$p($g(^OEORD(par,"I",sub,1)),"^",9)
	s PriorityDR=$p($g(^OEORD(par,"I",sub,1)),"^",8)
	s InstrDR=$p($g(^OEORD(par,"I",sub,2)),"^",7)
	s OEORIRecDepDR=$p($g(^OEORD(par,"I",sub,3)),"^",6)
	s LinkTo=""
	s OEORIPrice=$p($g(^OEORD(par,"I",sub,3)),"^",25)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	s ProtocolPackUOMDR=$p($g(^OEORD(par,"I",sub,"DHC")),"^",13)
	s admloc=$p(^PAADM(AdmId),"^",4)
	s AdmLocHospDr=$p($g(^CTLOC(admloc)),"^",22)
	s GetPriceExpStr=par_"||"_sub_"^"_OEORERowId_"^"_AdmId_"^"_OEORIRecDepDR_"^"_AdmLocHospDr
	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeDR,AdmReasonDR,ArcimId,SttDate,PriorityDR,InstrDR,LinkTo,OEORIPrice,OEORIRecDepDR,PAADMRegConDisDR,PackQtyUomID,GetPriceExpStr)

	;s retPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(OEORIRowid)
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s Sum=Price*PackQty
	s InsSum=InsPrice*PackQty
	s DiscSum=DiscPrice*PackQty
	s PatSum=PatPrice*PackQty
	;w retPrice,!
	Q $fn(Sum,"",4)_"^"_$fn(DiscSum,"",4)_"^"_$fn(InsSum,"",4)_"^"_$fn(PatSum,"",4)_"^"_retPrice_"^"_PackQty_"^"_PackQtyUomID_"^"_PackQtyUom
}

ClassMethod GetOrderItemPackQty(OrderItemRowid As %String) As %String
{
	s PackQty=0
	s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",2)
	s ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i (OrderType="R") d
	.i '$d(^OEORD(OrderRowid,"I",Childsub,9)) s PackQty=0
	.e  s PackQty=$p(^OEORD(OrderRowid,"I",Childsub,9),"^",4)
	.if $d(^OEORD(OrderRowid,"I",Childsub,2)) d
	..s FrequenceRowid=$p($G(^OEORD(OrderRowid,"I",Childsub,2)),"^",4)
	..s DurationRowid=$p($g(^OEORD(OrderRowid,"I",Childsub,2)),"^",6)
	..s DoseQty=$p($g(^OEORD(OrderRowid,"I",Childsub,2)),"^",1)
	..s DosUOM=$p($g(^OEORD(OrderRowid,"I",Childsub,2)),"^",3)
	.s DrgformRowid=..GetDrgForm(ArcimRowid)
	.;s PackQty=..GetPackqty(ArcimRowid,DrgformRowid, FrequenceRowid , PriorRowid, DurationRowid, DoseQty, DosUOM)
	e  s PackQty=$p($g(^OEORD(OrderRowid,"I",Childsub,1)),"^",12)
	Q PackQty
}

ClassMethod GetOrderItemsBroker(itmjs As %Library.String = "", EpisodeID As %String, IsPhamacy As %String) As %Library.String
{
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:GetOrderItems")
	do rset.Execute(EpisodeID,IsPhamacy)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	q 1
}

ClassMethod GetOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, IsPhamacy As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
 set RowCount=0
 ;if IsPhamacy="1" s OrderType="R"
 s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
 do CheckRowCount
 if RowCount>0 d
 .&sql(DECLARE EmpCursor CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),OEORI_SeqNo,
 OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,
	    OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,oeori_PHFreq_dr->PHCFR_Desc1,
	    OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,
	    OEORI_QtyPackUOM,
	    OEORI_RecDep_DR->CTLOC_Desc,OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,
	    OEORI_BBExtCode,OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
 INTO :Rowid,:OrderName,:StartDate,:SeqNo,:DoseQty,:DoseUOM,:Priority,:Status,:Frequence,:Instruction,:Duration,:PackQty,:RecDep,:Billed,:ARCIMRowid,:SttDate,:BillType,:OrderType
 From SQLUser.OE_OrdItem 
 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and OEORI_ItemStat_DR->OSTAT_Code='V'   Order By OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR desc)
	 .;and OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType=:OrderType)
 .&sql(OPEN EmpCursor)
 .for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
	..s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	..s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	..s orcatdesc=""
	..i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
	..q:(orcatdesc="消耗材料")
	..s PackUOMRowID=$p($g(^OEORD(+Rowid,"I",$P(Rowid,"||",2),"DHC")),"^",13)
	..s:PackUOMRowID="" PackUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,AdmType)
 	..s PackUOM=$p(^CT("UOM",PackUOMRowID),"^",2)
	..;lxz EpisodeID
	..s OrderRecDepRowid=$P($G(^OEORD(+Rowid,"I",$P(Rowid,"||",2),3)),"^",6) ;OEORI_RecDep_DR
	..s ProtocolPackUOMDR=$p($g(^OEORD(+Rowid,"I",$P(Rowid,"||",2),"DHC")),"^",13)
	..s ExpStrIn=Rowid_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStrIn)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s Sum=PackQty*Price
	..i BillType="" s BillTypeDesc="自费"
	..e  s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
	..s PackUOM=$p(PackUOM,"(",1)
	..do OutputRow2
	.&sql(CLOSE EmpCursor)
 else  Do
 .do ResetVariables2
 .Do OutputRow2	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
 set Data=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,OrderType)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables2
	set (Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,OrderType)=""
	quit
CheckRowCount
 if EpisodeID="" s RowCount=0
 else  d
 .&sql(SELECT Count(*) INTO :RowCount From SQLUser.OE_OrdItem 
	 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID)
 ;and OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType=:OrderType)
 Quit
}

ClassMethod GetOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOrderPrice(PatType As %String, InsType As %String, ARCIMRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String, PAADMRegConDisDR As %String = "", OrderPackUOMRowid As %String = "", ExpStrIn As %String = "") As %String
{
	s ARCIMSub=$p(ARCIMRowid,"||",1)
	q:(+ARCIMSub=0) ""
	if SttDate="" s SttDate=..%SysDate()
	s OrdDr=$P(ExpStrIn,"^",1) ;医嘱ID
	s OEOrdExec=$P(ExpStrIn,"^",2) ;执行记录ID
	s AdmID=$P(ExpStrIn,"^",3) ;就诊ID
	s ReLocID=$P(ExpStrIn,"^",4) ;接收科室ID
	s CurLogonHosp=$P(ExpStrIn,"^",5) ;登陆医院ID
	s OrderMaterialBarCode=$P(ExpStrIn,"^",7)
	s ExpStr=PAADMRegConDisDR_"^"_OrdDr_"^"_OEOrdExec_"^"_AdmID_"^"_ReLocID_"^^"_OrderMaterialBarCode
	;挂号优惠设置^医嘱Rowid^执行记录Rowid^就诊Rowid^医嘱接受科室Rowid^
	s ^tempqujian("GetOrderPrice",ARCIMRowid)=PatType_","_InsType_","_ARCIMRowid_","_SttDate_","_PriorRowid_","_InstrRowid_","_LinkTo_","_OEPrice_","_CurLogonHosp_","_ExpStr
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,CurLogonHosp,ExpStr)
	s Price=$fn($P(retPrice,"^",1),"",4)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s INCIRowid=..GetINCI(ARCIMSub)
	s ConFac=1
	if INCIRowid'="" {
		s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
		if ((CNMedItemFlag="1")&&(OrdDr=""))||(CNMedItemFlag'="1"){
			s ConFac=..GetConFac(ARCIMRowid,INCIRowid,OrderPackUOMRowid)
			s Price=$fn(Price*ConFac,"",4)
			s DiscPrice=$fn(DiscPrice*ConFac,"",6)
			s InsPrice=$fn(InsPrice*ConFac,"",6)
			s PatPrice=$fn(PatPrice*ConFac,"",6)
		}
	}
	Q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ConFac
}

ClassMethod GetOrderPriceBroker(itmjs As %Library.String = "", itmpara As %Library.String = "", PatType As %String, InsType As %String, OrderType As %String, ItemRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
 if OrderType="ARCIM" d
	.s retPrice=..GetOrderPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	e  d
	.s retPrice=..GetOrderSetPrice(PatType, InsType, ItemRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	.;s ^CacheTemp("zzq")=PatType_"^"_InsType_"^"_ItemRowid_"^"_SttDate_"^"_PriorRowid_"^"_InstrRowid_"^"_LinkTo_"^"_OEPrice
	Q retPrice
}

ClassMethod GetOrderSetDate(ARCOSRowid As %String) As %String
{
	n drow
	s DATE=$g(DATE) s:'DATE DATE=..%SysDate()
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q drow
}

ClassMethod GetOrderSetItem(ARCOSRowid As %String, ARCOSDateRowid As %String, HospID As %String = "") As %String
{
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:ARCIMRowid=""
	.q:..ValARCItem(ARCIMRowid)
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	.s ItemDoseUOMRowid=$p(s,"^",10)
	.s ItemBillUOMRowid=$p(s,"^",23)
	.s ARCIMPHCDFDR=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",12)
	.s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid,HospID)
	.if CNMedItemFlag'=1 d
	..s ARCOSItemQty=$p(s,"^",2)
	..s ITMFreqTimeDoseQtyStr=$p($G(^ARCOS(+ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",10)
	..if (ITMFreqTimeDoseQtyStr'="") d
	...s ARCOSItemDoseQty=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(ITMFreqTimeDoseQtyStr)
	...s BaseDoseQty=0
	...f itemi=1:1:$l(ARCOSItemDoseQty,"-") d
	....s BaseDoseQty=BaseDoseQty+##Class(web.DHCDocOrderEntry).CalDose(ItemDoseUOMRowid,ARCIMPHCDFDR,$p(ARCOSItemDoseQty,"-",itemi))
	...if INCIRowid'="" s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ARCIMRowid,INCIRowid,ItemBillUOMRowid),ARCOSItemQty=BaseDoseQty/ConFac
	.s:CNMedItemFlag=1 ARCOSItemQty=$p(s,"^",13)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.s count=$I(^CacheTemp("ARCOI",$j))	//$o(^TMP("ARCOI",$j,""),-1)+1
	.s ^CacheTemp("ARCOI",$j,count,item)=ARCIMRowid_"^"_ARCOSItemQty_"^"_ItemBillUOMRowid
	.;w ^CacheTemp("ARCOI",$j,count,item),!
	Q 0
}

ClassMethod GetOrderSetItemQty(ARCOSRowid As %String, ARCIMRowid As %String) As %String
{
	s ARCOSItemQty=0
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ItemRowid=$p(s,"^",1)
	.q:ItemRowid'=ARCIMRowid
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=0  
	Q ARCOSItemQty
}

ClassMethod GetOrderSetPrice(PatType As %String, InsType As %String, ARCOSRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String) As %String
{
	s ARCOSPrice=0
	s ARCOSDiscPrice=0
	s ARCOSInsPrice=0
	s ARCOSPatPrice=0
	do ..OpenGetAllOrderSetItem(ARCOSRowid)
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
 	..s ARCIMRowid=$p(s,"^",1)
	..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMSub=$p(ARCIMRowid,"||",1)
	..s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
	..s ARCOSDiscPrice=ARCOSDiscPrice+$fn(DiscPrice*ARCOSItemQty,"",4)
	..s ARCOSInsPrice=ARCOSInsPrice+$fn(InsPrice*ARCOSItemQty,"",4)
	..s ARCOSPatPrice=ARCOSPatPrice+$fn(PatPrice*ARCOSItemQty,"",4)
	;w ARCOSPrice_"^"_ARCOSDiscPrice_"^"_ARCOSInsPrice_"^"_ARCOSPatPrice
	Q ARCOSPrice_"^"_ARCOSDiscPrice_"^"_ARCOSInsPrice_"^"_ARCOSPatPrice
}

ClassMethod GetPAADMOrderRowid(EpisodeID As %String) As %String
{
	Q $o(^OEORD(0,"Adm",+EpisodeID,""))
}

ClassMethod GetPAAdmType(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	Q $p($g(^PAADM(EpisodeID)),"^",2)
}

ClassMethod GetPackqty(ArcimRowid As %String, DrgformRowid As %String, FrequenceRowid As %String, PriorRowid As %String, DurationRowid As %String, OrderQty As %String, OrderUOM As %String, PackUOMRowid As %String = "") As %String
{
	s OrdParamArr("EpisodeID")=""
    s OrdParamArr("OrderPriorRowid")=PriorRowid
    s OrdParamArr("OrderARCIMRowid")=ArcimRowid
    s OrdParamArr("OrderDoseQty")=OrderQty
    s OrdParamArr("OrderDoseUOMRowid")=OrderUOM
    s OrdParamArr("OrderFreqRowid")=FrequenceRowid
    s OrdParamArr("OrderDurRowid")=DurationRowid
    s OrdParamArr("OrderPackQty")=""
    s OrdParamArr("OrderPackUOMRowid")=PackUOMRowid
    s OrdParamArr("OrderStartDate")=""
    s OrdParamArr("OrderMultiDate")=""
    s OrdParamArr("OrderPrice")=""
    s OrdParamArr("LinkedMasterOrderPriorRowid")=""
    s OrdParamArr("OrderFreqDispTimeStr")=""
    s OrdParamArr("OrderFirstDayTimes")=""
    s OrdParamArr("IsNotChangeFirstDayTimeFlag")=""
    s OrdParamArr("IsNotNeedChangeFlag")=""
    s OrdParamArr("OrderFreqTimeDoseStr")=""
    s OrdParamArr("OrderRecDepRowid")=""
    s OrdParamArr("SessionStr")=""
    s OrderMasterSeqNo=""
    s OrdParamArr("OrderMasterARCIMRowid")=""
    s OrdParamArr("OrderVirtualtLong")=""
    s OrdParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.OrdParamArr)
    s CalPackQtyJson=##Class(web.DHCOEOrdItemView).CalPackQty(OrdParamJson)
    k CalPackQtyArr
    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(CalPackQtyJson,.CalPackQtyArr)
	Q $G(CalPackQtyArr("OrderPackQty"))
}

ClassMethod GetPapmiRowidByNo(PapmiNo As %String) As %String
{
	s PapmiNo=..FormatPatientNo(PapmiNo)
	s PatRowid=""
	s PapmiRowid=0 f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PapmiRowid)) q:PapmiRowid=""  d
	.s PatRowid=PapmiRowid
	Q PatRowid
}

ClassMethod GetPateintIDMethod(Adm As %String) As %String
{
	Set PapmiDr=$P(^PAADM(Adm),"^",1)
	Set MainMRADM=$P(^PAADM(Adm),"^",61)
	q PapmiDr_"^"_MainMRADM
}

ClassMethod GetPatientAgeDesc(PatientID As %String) As %String
{
	q:PatientID="" "" 
	s PatientDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	s AgeDesc=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"")
	Q AgeDesc
}

ClassMethod GetPatientByNo(PapmiNo As %String) As %String
{
 s ret=""
	s PapmiRowid=..GetPapmiRowidByNo(PapmiNo)
	if PapmiRowid'="" s ret=..GetPatientByRowid(PapmiRowid)
	Q ret
}

ClassMethod GetPatientByNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegNo As %Library.String = "")
{
	 Set ret=..GetPatientByNo(RegNo)
	 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 取得病人信息
/// Table:        PA_Person,PA_PatMas
/// Input:        PapmiRowidy:病人指针
/// Return:       病人信息串
/// Others:		  处方打印程序用 UDHCPrescript.Print,
/// 更新程序注意?地坛所需的医保号位置变了
ClassMethod GetPatientByRowid(PapmiRowid As %String, EpisodeID As %String = "") As %String
{
 s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
 q:PapmiRowid="" ""
 Set langid=..%LanguageID()
 if (EpisodeID'=""){
 	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
 }else{
	s PAAdmType="O"
 }
 s PapmiOPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2)
 s PapmiIPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",1)
 ;s PapmiNo=$$CO2^at84(PapmiIPNo,PapmiOPNo)
 s PapmiNo=##Class(web.PAPatMas).GetRegistration(PapmiRowid)
 s PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
 s PatientDOB=$P($G(^PAPER(PapmiRowid,"ALL")),"^",6)
 s PatientBirthday=$ZD($G(PatientDOB),3)
 ;
 s PatientSexDr=$P($G(^PAPER(PapmiRowid,"ALL")),"^",7)
 if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
 else  s PatientSex=""
 s PatientSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatientSex,langid)
 ;
 s Pattype=""
 s PatientSocialStausDR=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10)
 i PatientSocialStausDR'=""  d
 .s Pattype=$p(^CT("SS",PatientSocialStausDR),"^",2)
 ;
 s PatientCompany=$g(^PAPER(PapmiRowid,"PER","ADD",1))
 s PatientComAdd=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
 s EmployeeNO=$P($G(^PAPER(PapmiRowid,"EMP")),"^",5)
 s PatientMaritalDr=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",3)
 if PatientMaritalDr'="" s PatientMarital= $P($G(^CT("MAR",PatientMaritalDr)),"^",2)
 e  s PatientMarital="未知"
 s PatCategoryRowid=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",8)
 s Medcare=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiRowid,PAAdmType)
 
 s Tel=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11)
 s PapmiName3=$P($G(^PAPER(PapmiRowid,"ALL")),"^",19)  //医保(卡/手册)号
 s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
 s AgeYear=$P(Age,"|",12)
 s AgeMonth=$P(Age,"|",13)
 s AgeDay=$P(Age,"|",14)
 s AgeDesc=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PapmiRowid,EpisodeID,HospID)

 s ALLERGY=""
 s ALLERGY=$G(^PAPER(PapmiRowid,"ALLERGY",1))
 S NationDR=""
 s NationDR=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",1)
 s Nation=""
 if NationDR'="" s Nation=$p($g(^CT("NAT",NationDR)),"^",2)
 s Nation=$p(Nation,"-",2)
 s OccupationDR="",Occupation=""
 s OccupationDR=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",6)
 if OccupationDR'="" s Occupation=$p($g(^CT("OCC",OccupationDR)),"^",2)
 s Occupation=$p(Occupation,"-",2)

 ;RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard
 s RealName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",21)
 s RealCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",22)
 s SupplyName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",23)
 s SupplyCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",24)
 s GovernCardNo=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiRowid,"O") ;门诊病案号
 //s:GovernCardNo="" GovernCardNo=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4)
 s MrNoE=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiRowid,"E") ;急诊病案号
 s PersonID=""
 s PersonID=$P($G(^PAPER(PapmiRowid,"ALL")),"^",9)   ;身份证
 s CFRowId="",CardNo="",find=0,FindCFTypeDesc=""
 for {
	s CFRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,CFRowId),-1)
	q:((CFRowId="")!(find=1))
	s CardNo=$p($g(^DHCCARD("CF",CFRowId)),"^",2)
	s CardActived=$p($g(^DHCCARD("CF",CFRowId)),"^",10)
	set FindCFType=$P(^DHCCARD("CF",CFRowId),"^",16)
	set:FindCFType'="" FindCFTypeDesc=$P(^DHCCARDTYPEDef(FindCFType),"^",2)
	i CardActived="N" s find=1
 }
 ;死亡标志
 s IsDeceased=##Class(web.PAPerson).CheckDeceased(PapmiRowid)


 s ret= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc
 s ret=ret_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr
 s ret=ret_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay
 s ret=ret_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid
 s ret=ret_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo
 s ret=ret_"^"_$g(Tel)_"^"_$G(ALLERGY)_"^"_$g(Nation)_"^"_$g(Occupation)_"^"_PapmiName3
 s ret=ret_"^"_$g(CardNo)_"^"_$g(PersonID)_"^"_MrNoE_"^"_IsDeceased_"^"_FindCFTypeDesc
 Q ret
}

ClassMethod GetPatientCompany(PapmiRowid As %String) As %String
{
	;&SQL(select PAPER_StNameLine1,PAPER_StName into :PatientCompany1,:PatientCompany from pa_person where paper_rowid=1)
	;s a=$g(^PAPER(PapmiRowid,"PER","ADD",1))
	i $d(^PAPER(PapmiRowid,"PER","ADD",1)) s addr=^PAPER(PapmiRowid,"PER","ADD",1)
	s a=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
	i a="" s a=addr
	s b=$l(a,2)
	q $ZCVT(a,"O","JS")
	;Q PatientCompany
}

ClassMethod GetPkInciQty(type As %String, frdate As %String, todate As %String, locdr As %String, inci As %String) As %String
{
 ;s type="P",frdate=..%SysDate()-2,todate=$h,locdr="1359",inci="173"
 n intr,date,pointer,dstatus,ord,orditm,ex,dsp,reploc,stype
 n inclb,qty,num,rqty
 s date=frdate-1,num=0,rqty=0
 f  s date=$o(^INTR(0,"INCI",inci,date)) q:(date>todate)!(date="")  d
 . s intr=""     ;,rqty=0
 . f  s intr=$o(^INTR(0,"INCI",inci,date,intr)) q:intr=""  d
 .. s stype=""
 .. s stype=$p(^INTR(intr),"^",1)
 .. q:stype'=type
 .. s pointer=""
 .. s pointer=$p(^INTR(intr),"^",9)
 .. s ord="",orditm="",ex="",dsp=""
 .. s ord=$p(pointer,"||",1),orditm=$p(pointer,"||",2),ex=$p(pointer,"||",3),dsp=$p(pointer,"||",4)
 .. q:(ord="")!(orditm="")!(ex="")!(dsp="")
 .. q:'$d(^OEORD(ord,"I",orditm)) 
 .. s reploc="",reploc=$p(^OEORD(ord,"I",orditm,3),"^",6)  ;医嘱接收位置
 .. q:reploc'=locdr
 .. s oeflag="",oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",orditm,1),"^",13)),"^",1) ;医嘱核实?未核实?停止状态
 .. q:oeflag="D"
 .. q:'$d(^OEORD(ord,"I",orditm,"X",ex,"D",dsp))
 .. q:$p(^OEORD(ord,"I",orditm,1),"^",8)=""       ;优先级不存在 -2006-05-27
 .. s priority=$p(^OECPR($p(^OEORD(ord,"I",orditm,1),"^",8)),"^",1) 
 .. q:priority="OM" ;自备药即刻
 .. q:priority="OMST" ;自备药长期
 .. s dstatus=""
 .. s dstatus=$p(^OEORD(ord,"I",orditm,"X",ex,"D",dsp),"^",6)
 .. q:$g(dstatus)'="P"   ;只取打包的  
 .. ;s inclb=$p(^OEORD(ord,"I",orditm,"X",ex,"D",dsp),"^",2)
 .. s qty=$p(^OEORD(ord,"I",orditm,"X",ex,"D",dsp),"^",1)        ;发药数量
 .. s rqty=rqty+qty
 .. s num=num+1
 q rqty
}

ClassMethod GetRealInciQty(inci As %String, loc As %String) As %String
{
	;ret value :
	; <0 - error occurs
	s dd=..%SysDate()
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

ClassMethod GetRealStock(EpisodeID As %String, Arcim As %String) As %String
{
	s inci=..GetINCI(+Arcim)
	q:inci="" 0
	s loc=..GetDefaultRecloc(EpisodeID,Arcim)
	q:loc="" 0
	if (EpisodeID'=""){
		s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s StockRetStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(Arcim,loc,PAAdmType)
		s qty=$P(StockRetStr,"^",9)
	}else{
		s realqty=..GetRealInciQty(inci,loc)
		s convqty=..GetItemConFac(Arcim)
		s qty=realqty/convqty
	}
	q qty
}

ClassMethod GetRecLocCount(ARCIMRowid As %String, EpisodeID As %String) As %String
{
	 set Count=0
	 Set rset=##class(%ResultSet).%New("web.CTLoc:LookUpReceiving")
	 do rset.Execute(ARCIMRowid,EpisodeID,"","","")
	 While (rset.Next()) {
		 s Count=Count+1
	 }
	 d rset.Close()
	 Quit Count
}

ClassMethod GetResIncQty(INCIrow As %String, CTLOCrow As %String) As %String
{
	q:INCIrow="" 0
	q:CTLOCrow="" 0
	n LocQty,SQLCODE,DUMMY,ResQty
	;
	&SQL(SELECT INCIL_LogQty,INCIL_ReservedQty INTO :LocQty,:ResQty FROM SQLUser.INC_ItmLoc WHERE  INCIL_INCI_ParRef=:INCIrow AND INCIL_CTLOC_DR=:CTLOCrow)
	i SQLCODE d  q 0
	q ($g(ResQty))
}

ClassMethod GetSessionData(Name As %String) As %String
{
	 q $Get(%session.Data(Name))
}

ClassMethod GetStockQty(EpisodeID As %String, Arcim As %String, OrderDepRowId As %String = "", DefaultRecLoc As %String = "", ByRef INCIItemLocked As %String = "N") As %String
{
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentHospitalCode()
	s ItemCatRowid=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	;药品库存不足不自动切换药房
	s CFNotAutoChangeRecloc=..%GetConfig("NotAutoChangeRecloc")
	;非药品库存不足不自动切换药房
	if (OrderType'="R") { //s CFNotAutoChangeRecloc=1
		 s CFNotAutoChangeRecloc=..%GetConfig("NotDrugNotAutoChangeRecloc")
	}
	s today=..%SysDate()
	s fdate=today-2
	s inci=..GetINCI(+Arcim)
	q:inci="" "0^0^0"
	s qty=0,qty1=1,qty2=1
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	i OrderDepRowId'="" s ret1=##class(web.DHCDocOrderCommon).GetLocRecLoc(OrderDepRowId,Arcim)
	e  s ret1=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,Arcim)
	//默认接收可是有库存优先显示默认接收科室库存
	if DefaultRecLoc'="" {
		;判断药品是否被药房锁定，demo->科室药品信息维护
		s INCIItemLocked=##Class(web.DHCSTCOMMONSRV).GetIncItmLockFlag(DefaultRecLoc,inci,PAAdmType)
		//返回当前库存数^可用库存数^医嘱占用数^库存业务占用数
		s retStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(Arcim,DefaultRecLoc,PAAdmType)
		s qty=$P(retStr,"^",9)
		s qty1=$P(retStr,"^",12)
		s qty2=$P(retStr,"^",11)
		;Q:+qty'=0 qty_"^"_qty1_"^"_qty2
		;库存不足时不自动切换药房,有库存时才返回当前默认接受科室的库存
		i (CFNotAutoChangeRecloc=1)||(qty>0){
			s qty=##class(DHCDoc.Util.Base).FormateNumber(qty)
			s qty1=##class(DHCDoc.Util.Base).FormateNumber(qty1)
			s qty2=##class(DHCDoc.Util.Base).FormateNumber(qty2)
			q qty_"^"_qty1_"^"_qty2
		}
	}
	s RecLocCount=$LENGTH(ret1,$C(2))
	For j=1:1:RecLocCount {
	 	S RecLocStr=$P(ret1,$C(2),j)
	 	s loc=$P(RecLocStr,$C(1),1)
		//s realqty=..GetRealInciQty(inci,loc)
		//i realqty=0 continue
		//返回当前库存数^可用库存数^医嘱占用数^库存业务占用数
		s retStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(Arcim,loc,PAAdmType)
		s qty=+$P(retStr,"^",9)
		continue:qty=0
		s qty1=$P(retStr,"^",12)
		s qty2=$P(retStr,"^",11)
		/*
		s packedqty=..GetPkInciQty("P",fdate,today,loc,inci)
		s convqty=..GetItemConFac(Arcim)
		s resqty=..GetResIncQty(inci,loc)
		s qty=realqty/convqty
		s qty1=packedqty/convqty
		s qty2=resqty/convqty
		*/
		Quit
	}
	s qty=##class(DHCDoc.Util.Base).FormateNumber(qty)
	s qty1=##class(DHCDoc.Util.Base).FormateNumber(qty1)
	s qty2=##class(DHCDoc.Util.Base).FormateNumber(qty2)
	q qty_"^"_qty1_"^"_qty2
}

ClassMethod GetSubCategoryBroker(itmjs As %Library.String = "", CatID As %String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpSubCat")
	 do rset.Execute(CatID,"","","")
	 While (rset.Next()) {
		s Desc=rset.GetData(1)
		s value=rset.GetData(2)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

ClassMethod GetToBillSum(PAADMRowid As %String) As %String
{
	s ToBillSum=0
	s ToBillPatSum=0
	s ToBillDiscSum=0
	s ToBillInsSum=0
	s PatType=""
	s InsType="1"
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	q:OrderRowid="" $fn(ToBillSum,"",4)_"^"_$fn(ToBillDiscSum,"",4)_"^"_$fn(ToBillInsSum,"",4)_"^"_$fn(ToBillPatSum,"",4)
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	.q:(billed="P")
	.;如果医嘱未核实则为退出
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..;s statdesc=$p($g(^OEC("OSTAT",itemstat)),"^",2)
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.;trakcare先开的医嘱是inactive
	.Q:($g(statcode)'="V")
	.s OEORIRowid=OrderRowid_"||"_itemsub
	.s OEORIDetail=..GetOrderItemDetail(PatType,InsType,OEORIRowid)
	.s OEORISum=$p(OEORIDetail,"^",1)
	.s OEORIDiscSum=$p(OEORIDetail,"^",2)
	.s OEORIInsSum=$p(OEORIDetail,"^",3)
	.s OEORIPatSum=$p(OEORIDetail,"^",4)
	.;w ToBillSum_"^"_OEORISum,!
	.s ToBillSum=ToBillSum+OEORISum
	.s ToBillInsSum=ToBillInsSum+OEORIDiscSum
	.s ToBillDiscSum=ToBillDiscSum+OEORIDiscSum
	.s ToBillPatSum=ToBillPatSum+OEORIPatSum
	Q $fn(ToBillSum,"",4)_"^"_$fn(ToBillDiscSum,"",4)_"^"_$fn(ToBillInsSum,"",4)_"^"_$fn(ToBillPatSum,"",4)
}

ClassMethod GetTodayDepAdm(PapmiRowid As %String, AdmDepRowid As %String) As %String
{
 s n=0
 s today=..%SysDate()
 s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(PapmiRowid,"ADM","O",PaadmRowid)) q:PaadmRowid=""  d        
 .s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 .q:AdmDate'=today
 .s pavisit=$p($g(^PAADM(PaadmRowid)),"^",20)
 .q:pavisit="C"
 .s CreateUser=$p($g(^PAADM(PaadmRowid)),"^",43)
 .q:CreateUser=""
 .s AdmDateDesc=$ZD($G(AdmDate),3)
 .s admdep=$p($g(^PAADM(PaadmRowid)),"^",4)
 .;如果就诊科室参数为空则得到这个病人当天所有的就诊记录
 .;如果就诊科室参数不为空则得到这个病人当天该科室所有的就诊记录
 .q:(AdmDepRowid'="")&(AdmDepRowid'=admdep)
 .s admdepdesc=$p($g(^CTLOC(admdep)),"^",2)
 .s admdocdesc=""
 .s admdoc=$p($g(^PAADM(PaadmRowid)),"^",9)
 .if admdoc'="" s admdocdesc=$p($g(^CTPCP(admdoc,1)),"^",2)
 .s admdepdesc1=$p(admdepdesc,"-",2)_admdocdesc
 .if admdepdesc1="" s admdepdesc1=admdepdesc_admdocdesc
 .s MradmRowid=$p($g(^PAADM(PaadmRowid)),"^",61)
 .s admreason=$p($g(^PAADM(PaadmRowid,1)),"^",7)
 .s admreasondesc=""
 .i admreason'="" s admreasondesc=$p($g(^PAC("ADMREA",admreason)),"^",2)
 .s n=n+1
 .s ^TMP($j,"OPToDayDepAdm",n)=admdepdesc1_"||"_PaadmRowid_"||"_MradmRowid_"||"_AdmDateDesc_"||"_admdep_"||"_admdoc_"||"_admdocdesc_"||"_admreason_"||"_admreasondesc
 .;w ^TMP($j,"OPToDayDepAdm",n)
 .;s PLIST(n)=AdmDateDesc_"||"_admdepdesc1_"||"_PaadmRowid_"||"_admdep_"||"_admdoc_"||"_admdocdesc
	 Q n
}

ClassMethod GetTodayDepAdmBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiRowid As %Library.String = "", AdmDepRowid As %String = "")
{
	 Set n=..GetTodayDepAdm(PapmiRowid,AdmDepRowid)
	 for i=1:1:n {
		 if i=1 s ret=^TMP($j,"OPToDayDepAdm",i)
		 else  s ret=ret_"^"_^TMP($j,"OPToDayDepAdm",i)
	 }
	 if n=0 s ret=""
	 s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
}

ClassMethod GetUomConvFactor(ARCIM As %String) As %String
{
	Set inci=$o(^INCI(0,"ARCIM_DR",+ARCIM,""))
	Quit:inci="" 1
	Set BaseUom=$p(^INCI(inci,1),"^",10)
	Set BillUom=$p(^ARCIM(+ARCIM,1,8),"^",14)
	Quit:(BaseUom="")!(BillUom="") 1
	Set ConvDr=$o(^CT("CTCF",0,"UOM",BillUom,BaseUom,""))
	Quit:ConvDr="" 1
	Set Conv=+$p(^CT("CTCF",ConvDr),"^",3)
	q Conv
}

ClassMethod LookUpDoseUOMBroker(itmjs As %Library.String = "", ARCIMRowid As %String = "") As %String
{
	s retval=""
	s DrgFormRowid=..GetDrgForm(ARCIMRowid)
	i DrgFormRowid'="" d        ; Pharmacy item is only efiended dose equivilent
	.s drgform1=+DrgFormRowid,drgform2=$p(DrgFormRowid,"||",2)
	.q:(drgform1="")!(drgform2="")
	.s bsUOM=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
	.s bsUOMDesc=$p($g(^CT("UOM",bsUOM)),"^",2)
	.s retval=itmjs_"('"_$ZCVT(bsUOMDesc,"O","JS")_"','"_$ZCVT(bsUOM,"O","JS")_"');"
	.&javascript<#(retval)#>
	.s retval=bsUOM_$C(1)_bsUOMDesc
	.s leq=0 f  s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq)) q:leq=""  d
	..s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
	..s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
	..s eqUomDesc=$p($g(^CT("UOM",eqUom)),"^",2)
	..s retval=itmjs_"('"_$ZCVT(eqUomDesc,"O","JS")_"','"_$ZCVT(eqUom,"O","JS")_"');"
	..&javascript<#(retval)#>
}

ClassMethod LookUpDurationBroker(itmjs As %Library.String = "", desc As %String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpDuration")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Desc=rset.GetData(2)
		s value=rset.GetData(1)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

ClassMethod LookUpFrequenceBroker(itmjs As %Library.String = "", desc As %String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpFrequence")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Desc=rset.GetData(2)
		s value=rset.GetData(1)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

ClassMethod LookUpInstructionBroker(itmjs As %Library.String = "", desc As %String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpInstruction")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Desc=rset.GetData(2)
		s value=rset.GetData(1)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItem","fhwssp","28","","","","","3","3641","","","17331","","","80","","^^1")
/// lhn 注射 袋装,29,,,,,5,124,,,4634,29||1,,110,,
ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	New repid, index
	s ^tempscl("LookUpItemExecute")=$LB(Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	///do ResetVariables
	kill ^||tmpLookUpItem,^||tmpItemArr
	Set repid=$I(^CacheTemp)
	s CurLogonDep=$p(Form,$c(3),1)
	s CurLogonHosp=$p(Form,$c(3),2)
	i CurLogonDep'="" {
		s LogonLocID=CurLogonDep
	}else {
		s LogonLocID=%session.Get("LOGON.CTLOCID")
		s:UserRowId="" UserRowId=%session.Get("LOGON.USERID")
	}
	i CurLogonHosp="" s CurLogonHosp=$p(^CTLOC(LogonLocID),"^",22)
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",CurLogonHosp)
	Set langid=..%LanguageID()
	s NoLimitPageRows=0
	s OrderOpenForAllHosp=0
	if (Route'=""){
		s NoLimitPageRows=+$p(Route,"^",2)
		s OrderOpenForAllHosp=+$p(Route,"^",3)
		s Route=$p(Route,"^",1)
	}
	s (Page,PageRows,PageStart,PageLimit)=""
	if $D(%request)&&(NoLimitPageRows=0){
		//--新版控件
		s Page=$G(%request.Data("page",1)) //lookup 显示第几页
		s PageRows=$G(%request.Data("rows",1)) //lookup 一页显示的数量
		//--老版控件
		s PageStart=$G(%request.Data("start",1)) //lookup 显示的起始数量-1
		s PageLimit=$G(%request.Data("limit",1)) //lookup 一页显示的数量
	}
	s index=1,Num=0
	s RowCountIndex=0
	s EntryQueryLimit=+..%GetConfig("EntryQueryLimit",CurLogonHosp)
	s Item=##class(web.DHCOPCommonFunLib).Trim(Item)
	s len1=$l(Item)
  	s control=$e(Item,len1)
  	i (control="#") s Item=$e(Item,1,len1-1) s len2=$l(Item)
  	;精确或者模糊查询
	s findmode=0
	/*if $e(Item,1,1)="%" {
		s findmode=1
		s Item=$e(Item,2,$l(Item))
	} */ 
	if ($e(Item,$l(Item))=".")||($e(Item,$l(Item))="。"){
		s findmode=1
		s Item=$e(Item,1,len1-1)
	}
	s Item2=""
	;空格分割 多项匹配
	if (Item[" ") s Item2=Item,Item=$p(Item," ",1) //$$ALPHAUP^SSUTIL4($p(Item," ",2,$l(Item," ")))
	if (Item="")&&(Category="")&&(SubCategory=""){
		Set QHandle=$lb(0,repid,0)
 		Quit $$$OK
	}
	s CMFlag=""
	if (NonFormulary["^"){
		s CMFlag=$p(NonFormulary,"^",2)
		s NonFormulary=$p(NonFormulary,"^",1)
	}
	;不显示零库存项目
	s NotDisplayZeroStockItem=..%GetConfig("NotDisplayZeroStockItem",CurLogonHosp)
	;不判断库存
	s NotCheckStock=..%GetConfig("NotCheckStock",CurLogonHosp)
	;不显示未定义接收科室的医嘱项
	s NotDisplayNoRecLoc=..%GetConfig("NotDisplayNoRecLoc",CurLogonHosp)
	;不显示被药房锁定的医嘱项
	s NotDisplayLockedItem=..%GetConfig("NotDisplayLockedItem",CurLogonHosp)
	
	s AdmReason="",EpisodeType="",EpLoc="",PatientNo="",PACWardLocId=""
	s PAADMRegConDisDR=""
	i EpisodeID'="" {
		s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
		s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
		s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
		s EpLoc=##class(web.DHCDocOrderCommon).GetEpLoc(EpisodeID,OrderDepRowId)
		s PatientID=$P(^PAADM(EpisodeID),"^",1)
		s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
		s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		s:(PACWardID'="") PACWardLocId=$P($g(^PAWARD(PACWardID)),"^",5)
	}
    s OrdSubCateGoryStr=""
	i OrdCatGrp'="" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(OrdCatGrp,CurLogonHosp)
	//s ^tmpscl("OrdSubCateGoryStr")=OrdCatGrp_"##"_OrdSubCateGoryStr
	if Category'="" {
		s Category=$$ALPHAUP^SSUTIL4(Category)
		s CategoryID=$O(^OEC("ORCAT",0,"Desc",Category,0))
		i CategoryID'="" s Category=CategoryID
	}
	i SubCategory'="" {
		s SubCategory=$$ALPHAUP^SSUTIL4(SubCategory)
		s SubCategoryID=$O(^ARC("IC",0,"Desc",SubCategory,0))
		i SubCategoryID'="" s SubCategory=SubCategoryID
	}
	
	s (OrderPriorCode,OrderRemarkCode)=""
	s OriginalPriorRowId=OrderPriorRowId
	if OrderPriorRowId'="" {
		s SplitOrderPriorStr=##class(web.DHCOEOrdItemView).SplitOrderPriorRowid(OrderPriorRowId)
		s OrderPriorRowId=$P(SplitOrderPriorStr,"^",1)
		s OrderRemarkCode=$P(SplitOrderPriorStr,"^",3)
		s OrderPriorCode=$P($G(^OECPR(OrderPriorRowId)),"^",1)
	}	
	if (Category'="")&(SubCategory="") d
	.;维护医嘱模板时选择大类时
	.i $$valordcat(GroupID,Category) d
	..s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	...set retval=$$open(SubCategory,Item,GroupID)
	...for  s retval=$$fetch(SubCategory,Item,GroupID) q:(retval="100")  d
 	.... do RecordSortTmpData
	...set retval=$$close()
	else  if (OrdCatGrp'="")&&(Category="") d
	.;医嘱录入界面选择检索分类时
	.Q:OrdSubCateGoryStr=""
	.for m=1:1:$l(OrdSubCateGoryStr,"^") d
	..s SubCategory=$p(OrdSubCateGoryStr,"^",m)
	..set retval=$$open(SubCategory,Item,GroupID)
	..for  s retval=$$fetch(SubCategory,Item,GroupID) q:(retval="100")  d
 	... Do RecordSortTmpData
	..set retval=$$close()
	e  d
	.;医嘱录入大部分情况下使用
	.set retval=$$open(SubCategory,Item,GroupID)
	.for  s retval=$$fetch(SubCategory,Item,GroupID) q:(retval="100")  d
 	.. do RecordSortTmpData
	.set retval=$$close()
	do OutputRecordSortData
	
	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRecordSortData
	s OutPutCount=1
	;代码表数据使用次数排序
	s RecordCount=""
	for {
		s RecordCount=$o(^||tmpLookUpItem(RecordCount),-1) Quit:(RecordCount="")||((OutPutCount>EntryQueryLimit)&&(EntryQueryLimit'=0))
		s Num=0
		for {
			s Num=$o(^||tmpLookUpItem(RecordCount,Num)) Quit:(Num="")||((OutPutCount>EntryQueryLimit)&&(EntryQueryLimit'=0))
			s id=0
			for {
				s id=$o(^||tmpLookUpItem(RecordCount,Num,id)) Quit:(id="")||((OutPutCount>EntryQueryLimit)&&(EntryQueryLimit'=0))
				s type=$G(^||tmpLookUpItem(RecordCount,Num,id))
				
				///
				//取医嘱项价格、别名串改为输出时调用,只处理当前页的数据,减少请求时间
				//可能造成的问题：当前输出的总页数可能和实际页数不相符,翻页时可能会发生总页数变动
				//if (OutPutCount>=(PageRows*(page-1)+1))&&(OutPutCount<=(PageRows*page)){
				if (PageRows'="")&&(Page'=""){
					if (OutPutCount>(PageRows*Page)){
						s Data=$Lb("")
						s $List(Data,50)=""
						s OutPutCount=OutPutCount+1
						do OutputRow
						continue
					}
				}elseif (PageStart'="")&&(PageLimit'=""){
					if (OutPutCount>(PageStart+PageLimit)){
						s Data=$Lb("")
						s $List(Data,50)=""
						s OutPutCount=OutPutCount+1
						do OutputRow
						continue
					}
				}
				i type["ARCIM" s err=$$selectarcim(id) continue:err
				i type["ARCOS" s err=$$selectarcos(id) continue:err
				;非药品和无库存医嘱的StockQty=""
				continue:(EpisodeID'="")&&(NotDisplayZeroStockItem="1")&($p(StockQty,"(")=0)&(OrderRemarkCode'="OM")&&(OrderRemarkCode'="ZT")&&(type="ARCIM")&&(ItemStockHave="")
				continue:(subcatcode="R")&(Recloc="")&(EpisodeID'="")&(NotDisplayNoRecLoc=1)
				;药品加锁
				continue:($g(INCI)'="")&&($g(DefaultRecLoc)'="")&&(NotDisplayLockedItem="1")&&($g(INCIItemLocked)="Y")
				s OutPutCount=OutPutCount+1
				do OutputRow
			}
		}
	}
	q 0
RecordSortTmpData
	Set OutRecordId=ROW1
	quit:$d(^||tmpItemArr(OutRecordId)) 
    s RowCountIndex=RowCountIndex+1
	Set Num=Num+1
	if type["ARCIM"{
		s TableName="User.ARCItmMast"
	}else{
		s TableName="User.ARCOrdSets"	
	}
	Set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,OutRecordId,UserRowId,"U")
	Set ^||tmpLookUpItem(RecordCount,Num,OutRecordId)=type
	Set ^||tmpItemArr(OutRecordId)=1
	quit
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0
	i findmode=0 s TEXT0=TEXT
	e  s TEXT0=0 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i findmode=0,$l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT g it1	 
	 i $ZCVT(TEXT0,"U")'[TEXT g it1 ;q 100
	 ;i $ZCVT(TEXT0,"U")'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 
	 s boolean=1
	 i Item2'="" d
     .f tmpindex=1:1:$l(Item2," ") do
     ..s tmpItem2=$ZCVT($p(Item2," ",tmpindex),"U")
     ..Q:(tmpItem2="")||(TEXT0="")||(DESC="")
     ..Q:($ZCVT(TEXT0,"U")[(tmpItem2))||($ZCVT(DESC,"U")[(tmpItem2))
     ..s boolean=0
     i boolean=0 g it1
     
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",Route="" g it3  //独立医嘱标志
	 //i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 s OrderType=""
	 if subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 // 医嘱类为：出院带药、自备药长期、取药医嘱、自备药即刻时，只显示药品医嘱
	 i ((OrderPriorCode="OUT")||(OrderPriorCode="OMST")||(OrderPriorCode="ONE")||(OrderPriorCode="OM")||(OrderRemarkCode="OM"))&&(OrderType'="R")&&(type="ARCIM") g it3
	 // 统一走医生站设置-医嘱/药学项设置-仅可开临嘱医嘱设置
	 //i (OrderPriorCode'="")&&(OrderPriorCode'="NORM")&&(type="ARCIM")&&((OrderType="L")||(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ROW1)=1)) g it3
	 i '##Class(DHCDoc.DHCDocConfig.ItemPrior).CheckItemPriorAllow(ROW1,OriginalPriorRowId,DefHospId) g it3
	 //i (TYPE'="")&&(OrderType'=TYPE) g it3
	 i (TYPE="L^SERVICE")&&(type="ARCOS") g it3
	 i (TYPE="L^SERVICE")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ROW1)'=1)&&(OrderType'="L") g it3
	 i (TYPE'="")&&(TYPE'="L^SERVICE")&&(OrderType'=TYPE) g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ROW1,DefHospId)="N" g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 //完全匹配模式下，强制验证通用名
	 i (control="#") {
		s getcontrol=$p(flag,"-",1) 
	 	s len3=$l(getcontrol)
	 	s getcontrol=$$ALPHAUP^SSUTIL4(getcontrol)
	 	//g:len3'=len2 it3
  	 	g:getcontrol'=$$ALPHAUP^SSUTIL4(TEXT) it3
	 }
	 
	 q "Success"
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 //i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 i findmode=0,$l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT g it11	 
	 i $ZCVT(TEXT0,"U")'[TEXT g it11 
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 s boolean=1
	 i Item2'="" d
     .f tmpindex=1:1:$l(Item2," ") do
     ..s tmpItem2=$ZCVT($p(Item2," ",tmpindex),"U")
     ..Q:(tmpItem2="")||(TEXT0="")||(DESC="")
     ..Q:($ZCVT(TEXT0,"U")[(tmpItem2))||($ZCVT(DESC,"U")[(tmpItem2))
     ..s boolean=0
     i boolean=0 g it11
     
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 s OrderType=""
	 i subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 i (TYPE'="")&&(OrderType'=TYPE) g it31
	 i type="ARCIM",##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ROW1,DefHospId)="N" g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 //i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 g:err it31 
	 ;s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() k UserCat,TEXT,TEXT0
	 k ^TMP($zn,$j)
	 q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			$LIST(ARCIM_OEMessage),ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_PHCDF_DR->PHCDF_CTUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_DerFeeRules_DR->DFR_Desc 
	   INTO :rowid,:desc,:code,:code1,:drgform,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatcode,:ordcatid,:oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,:generic,:subcatdesc,
	        :DerFeeRules
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	s desc=##class(web.DHCDocOrderCommon).GetFormateOrderName(rowid,CurLogonHosp)
	s ItemPrice=0
	s StockQty=""
	s PackedQty=""
	s rowid=$p(rowid,$c(1))
	s SttDate=..%SysDate()
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s ExpStrin="^^"_EpisodeID_"^"_""_"^"_CurLogonHosp
	s billuomDR=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(rowid,EpisodeType)
	s billuom=##class(web.DHCDocOrderCommon).GetUOMDesc(billuomDR)
	s retPrice=..GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,billuomDR,ExpStrin)
	s ItemPrice=$fn($P(retPrice,"^",1),"",4)
	s Recloc=""
	//获取医嘱默认接收科室。查看默认接收科室的库存情况
	s RecLocStrGet=""
	if (EpisodeID'=""){
		i (OrderType="R"){
			s RecLocStrGet=##class(web.DHCDocOrderCommon).GetHolidaysRecLoc(EpisodeID,OrderDepRowId,rowid,OrderOpenForAllHosp)
		}
		if (RecLocStrGet=""){
			i OrderDepRowId'="" s RecLocStrGet=##class(web.DHCDocOrderCommon).GetLocRecLoc(OrderDepRowId,rowid,OrderOpenForAllHosp)
			e  s RecLocStrGet=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,rowid,OrderOpenForAllHosp)
		}
	}else{
		s StockQty=..%Translate("oeorder.oplistcustom.new.csp","有",langid)
		i OrderDepRowId'="" s RecLocStrGet=##class(web.DHCDocOrderCommon).GetLocRecLoc(OrderDepRowId,rowid,OrderOpenForAllHosp)
	}
	s DefaultRecLoc=$$GetDefalocID(RecLocStrGet) //默认接收科室ID
	;无库存医嘱或者自备药也不去查找库存
	s AllowOrderWOStockCheck=$p($G(^ARCIM(+rowid,$p(rowid,"||",2),8)),"^",11)
	s INCI=..GetINCI(+rowid)
	s INCIItemLocked="N"
	//i (subcatcode="R")&(EpisodeID'="")&(AllowOrderWOStockCheck'="Y")&&(OrderPriorCode'[("OM")) d
	i (INCI'="")&(AllowOrderWOStockCheck'="Y")&&(OrderPriorCode'[("OM")){
		;按照就诊或登录科室取库存,目前优先登录科室(不为空的前提),Modify 202104324
		if (EpisodeID'="")!(OrderDepRowId'=""){
			s Recloc=##class(web.DHCDocOrderCommon).GetReclocDescStr(EpisodeID,rowid,"/",OrderDepRowId,OrderOpenForAllHosp)
			s NewRecLoc=""
			For col = 1:1:$l(Recloc,"/") {
				s OneRecLocDesc=$p(Recloc,"/",col)
				s OneRecLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OneRecLocDesc,langid)
				if (NewRecLoc=""){s NewRecLoc=OneRecLocDesc}else{ s NewRecLoc=NewRecLoc_"/"_OneRecLocDesc}
			}
			if NewRecLoc'="" s Recloc=NewRecLoc
			s ret=..GetStockQty(EpisodeID,rowid,OrderDepRowId,DefaultRecLoc,.INCIItemLocked)
			s StockQty=$P(ret,"^",1)
			s INCIbaseuom=$p(^INCI(INCI,1),"^",10) //库存基本单位
			s INCIbaseuomDesc=""
			i INCIbaseuom'="" s INCIbaseuomDesc=$p($g(^CT("UOM",INCIbaseuom)),"^",2)
			s INCIbaseuomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",INCIbaseuomDesc,langid)
			i INCIbaseuomDesc'="" s StockQty=StockQty_"("_INCIbaseuomDesc_")"
			s PackedQty=$P(ret,"^",2)
			s ResQty=$P(ret,"^",3)
		}
	}
	///获取接收科室是否存在可用的库存 -是否只判断默认接收科室按照是否自动切换判断
	s CFNotAutoChangeRecloc=..%GetConfig("NotAutoChangeRecloc",CurLogonHosp)
	s ItemStockHave=""
	i (INCI'="") {
		s DeLocID=""
		s RecLocCount=$L(RecLocStrGet,$C(2))
		F iLoc=1:1:RecLocCount {
			s RecLocStr=$P(RecLocStrGet,$C(2),iLoc)
			s ReclocRowId=$P(RecLocStr,$C(1),1)
			s Defaut=$P(RecLocStr,$C(1),3)
			Continue:ReclocRowId=""
			Continue:(CFNotAutoChangeRecloc=1)&&(Defaut'="Y")
			s Rtn=##class(web.DHCDocOrderCommon).CheckBeforeUpdate(rowid,1,ReclocRowId,EpisodeType,EpisodeID_"^"_LogonLocID_"^^^"_OrderOpenForAllHosp)
			if (+Rtn=1){
				s ItemStockHave="Y"
			}
		}
	}
	s generic=""
	;s desc=flag_desc
	s desc=desc //_"-"_$p(flag,"-",1)			
	s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(rowid)
	;医保组从2010.3.3号起统一到了web.DHCINSUPort里面了
	//s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(rowid,AdmReason,CurLogonHosp)
	;医保类别(甲,乙,丁等)
	s InsurClass=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,"",6)
	//..GetArcimLinkInsuInfo(ItmMastDR,OrderAdmReason,sessionHospId,NowDate,5)
	if (drgform'="")&&(InsurClass="") {
		//s InsurClass=$P($g(^PHCD(+drgform,4)),"^",2)
	}
    i InsurClass="-1" s InsurClass=""
	;自负比例
	s InsurSelfPay=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,"",7)
	;国家医保编码
	s InsuNationCode=""
	s InsuNationName=""
	s NowDate=..%ZD(+$H)
	//s InstrStr=##class(web.DHCINSUPort).ArcimLinkInsuList(rowid,AdmReason,CurLogonHosp,NowDate)
	s InsuNationCode=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,NowDate,13)
	s InsuNationName=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,CurLogonHosp,NowDate,14)
	
	// 基本药物标志,是/否
	s BasicDrugFlag=""
	s inci=..GetINCI(+rowid)
	i inci'=""  d
	/*.s AddInfoDR=$O(^DHCITMINFO(0,"INCI",inci,0))
	.i AddInfoDR'=""  d
	..;国家
	..s BasicDrugFlag=$p($g(^DHCITMINFO(AddInfoDR)),"^",4)
	..s BasicDrugFlag=$case(BasicDrugFlag,"Y":"是(国)","N":"否",:"")
	..;省
	..s BasicDrugPrv=$p($g(^DHCITMINFO(AddInfoDR)),"^",40)
	..i BasicDrugPrv=1 s BasicDrugFlag="是(省)"
	..;市
	..s BasicDrugCity=$p($g(^DHCITMINFO(AddInfoDR)),"^",41)
	..i BasicDrugCity=1 s BasicDrugFlag="是(市)"
	..;区
	..s BasicDrugArea=$p($g(^DHCITMINFO(AddInfoDR)),"^",42)
	..i BasicDrugArea=1 s BasicDrugFlag="是(区)"*/
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(rowid)
	if DrgFormRowid'="" {
		s Phcd=+DrgFormRowid,Chl=$p(DrgFormRowid,"||",2)
		s BasicDrug=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",31)		;国家基本药物
		s BasicDrugFlag=$case(BasicDrug,"Y":"是(国)","N":"否",:"")
		
	 	s Drugbase2=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",32)		;省基本药物
	 	i Drugbase2="Y" s BasicDrugFlag="是(省)"
	 	
	 	s PDrugbase1=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",33)		;市基本药物
	 	i PDrugbase1="Y" s BasicDrugFlag="是(市)"
	 	
	 	s PDrugbase2=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",34)		;区县基本药物
	 	i PDrugbase2="Y" s BasicDrugFlag="是(区)"
	 	;剂型
	  	s FormRowid=$p($g(^PHCD(Phcd,"DF",Chl,1)),"^",1)
	  	i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	}
	;输出别名串
	s AliasStr=##class(web.DHCDocOrderCommon).GetAliasByItem("ARCIM",rowid)
	s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
	s subcatdesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",subcatdesc,langid)
	s FormDesc=##class(User.PHCForm).GetTranByDesc("PHCFDesc",$g(FormDesc),langid)
	s BasicDrugFlag=..%Translate("oeorder.oplistcustom.new.csp",BasicDrugFlag)
	s DrugIconStr=##Class(DHCDoc.Interface.Inside.Invoke).GetDrugIconsByArcim(rowid,CurLogonHosp)
	
	s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice,BasicDrugFlag,billuom,StockQty,PackedQty,GenericName,ResQty,DerFeeRules,InsurClass,InsurSelfPay,Recloc,arcimcode,ItemStockHave,AliasStr,INCIItemLocked,$g(FormDesc),InsuNationCode,InsuNationName,DrugIconStr)
	q
selectarcos(RowID)	k PLIST
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_Code,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:labsetrowid,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM SQLUser.ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM SQLUser.ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_code_$c(2)_$p($g(prior),$c(1))_$c(1)_$p($g(^OECPR(+$g(prior))),"^",2)
	;s PLIST=$o(PLIST(""),-1)
	s StockQty=""
	s desc=$TR(desc,$C(13),"")
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$C(4),1)
	//s OSItemIDs=""
	s OSPrice=$fn($p(retval,$C(4),2),"",4)
	//s desc=flag_desc
	s subcatcode=""
	s Recloc=""
	;输出别名串
	s AliasStr=##class(web.DHCDocOrderCommon).GetAliasByItem("ARCOS",rowid)
	s subcatdesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",subcatdesc,langid)
	s Data=$lb(desc,rowid,"",type,TEXT0,"",$p(ordcatid,$C(1)),"","","","","","","",OSItemIDs,"","",subcatdesc,OSPrice,"","","","","","","","","","",code,"",AliasStr)
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1,EpisodeType,EpLoc,UserRowId,CurLogonDep,EpisodeID,NonFormulary,Route,CMFlag,CurLogonHosp,DefHospId,PatientNo,PACWardLocId)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 Q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2),subcat=$p(s,"^",3)
	 Q:(subcat'="")&&(("!"_subcat_"!")'[("!"_subCATEG_"!")) 0
	 s CNMedSubCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr(CurLogonHosp)
	 ;如果是医嘱常用模板维护中检索医嘱,则草药,西药都需要查找
	 if NonFormulary="" {
	 	s UseCNMedEntry=..%GetConfig("UseCNMedEntry",CurLogonHosp)
	 	Q:(UseCNMedEntry="1")&(CNMedSubCat'="")&&(("^"_CNMedSubCat_"^")[("^"_subCATEG_"^")) 0
	 }else{
		 Q:(CMFlag="CM")&&(("^"_CNMedSubCat_"^")'[("^"_subCATEG_"^")) 0
		 Q:(CMFlag="XY")&&(("^"_CNMedSubCat_"^")[("^"_subCATEG_"^")) 0
	 }
	 i type="ARCOS",os'="Y" Q 0
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",Route="" Q 0
	 s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserRowId)
	 i type="ARCIM"{
		 if (CMFlag="CM") s checkType="CM"
		 else  s checkType="XM"
	 	s AllowArcItemValue=##class(DHCDoc.DHCDocConfig.PrescriptSet).CheckForAllowArcItem(DoctorID,ROW1,CurLogonHosp,checkType)
	 	if (AllowArcItemValue=0) Q 0
	 }
	 ;lxz 修改门诊、住院、急诊用药医嘱项设置应用
	 ;s RestrictIP=$p($g(^ARCIM(+ROW1,1,10)),"^",13)
	 ;s RestrictOP=$p($g(^ARCIM(+ROW1,1,10)),"^",14)
	 ;if (RestrictIP'="Y")!(RestrictOP'="Y") {
	 ;	if (RestrictIP="Y")&&(EpisodeType'="I") Q 0
	 ;	if (RestrictOP="Y")&&(EpisodeType'="O") Q 0
	 ;}
	
	 ;根据科室,医生,职称判断医嘱项的可开的权限
	 if type="ARCIM" {
		;临床药理,可以显示,仅控制不可录入.这里控制不住,需要加入药理RowId的判断,如果这样判断这个就诊就不能开药理以外的医嘱了
		;s CheckPilotCat=##class(web.DHCDocOrderCommon).CheckPilotCat(EpisodeID,ROW1)
		;Q:CheckPilotCat'="Y" 0
		s Restrict=##class(web.DHCDocOrderCommon).CheckArcimType(ROW1,"",EpisodeType)
	 	if Restrict'="" Q 0
	 	s ItemAuth=##class(web.DHCDocOrderCommon).CheckArcimAuthorize(ROW1,CurLogonDep,UserRowId)
	 	i ItemAuth=0 Q 0
	 	s ItmHosipital=$$ChecArcimkHosipital(ROW1,DefHospId)
	 	if 'ItmHosipital Q 0
	 	s CareProvDR=$P(^SSU("SSUSR",UserRowId),"^",14)
	 	if (CareProvDR'="") s CareProvTP=$P($G(^CTPCP(+CareProvDR,1)),"^",4)
	 	if (EpisodeID'="") {
		 	s AdmDepId=$P($G(^PAADM(EpisodeID)),"^",4) //EpLoc
		 	if (EpisodeType="I") s PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
		}
		;s ItemAuth=##Class(PHA.FACE.OUT.Com).GetCombCtrlLevel(ROW1,CurLogonHosp,"",CurLogonDep,$g(AdmDepId),PACWardLocId,$g(CareProvTP),UserRowId,EpisodeType,$g(PAADMInsType),PatientNo,"")
	 	;Q:ItemAuth'="允许" 0
	 	;Q:ItemAuth.CtrlLevel="BAN" 0
	 	;判断设否有医嘱项可开权限
	 	s IncludeContinueFlag=0
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",1)
	 	.q:(s-CATEG)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCATEG)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm)) q:Itm=""  q:IncludeContinueFlag  d
	 	..s ItmData=$g(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=(+ROW1_"||1") s found=1
	 	...e  s IncludeContinueFlag=1,found=0
	 	..e  d
	 	...i ItmId=(+ROW1_"||1") s found=1
	 	//s ^TMPgry("ARCIM",ROW1)=found_","_IncludeContinueFlag_","_user_","_UserRowId_","_CurLogonDep
	 	//科室医嘱录入权限控制:科室/病区->医嘱限制,可限制科室哪些医嘱不能开立
	 	s ItemLocAuth=##class(web.DHCBL.CT.CTLocOrderLimit).GetOrderLimtFlag(CurLogonDep,ROW1)
		i ItemLocAuth=1 Q 0
		s ItemPoisonAuth=..CheckDrgFormPoisonAuthorize(ROW1,UserRowId)
		Q:ItemPoisonAuth=0 0
		// 过滤医嘱项服务组为挂号服务组的医嘱
		s RegServiceGroup=##class(web.DHCOPRegConfig).GetSpecConfigNode("RegServiceGroup",CurLogonHosp)
		if (RegServiceGroup'="") {
			Q:$d(^ARCIM(0,"SERGRP",RegServiceGroup,+ROW1,$p(ROW1,"||",2))) 0
		}
	 	i found=1 Q 0
	 }
	 if type="ARCOS" {
		s find=0
	 	s FavRowid=0
	 	for {
		 	s FavRowid=$O(^DHCFavItems(0,"ItemRowid",+ROW1,FavRowid)) q:FavRowid=""
		 	;医嘱套使用院区,非本院区不可见
		 	s FavUseHospDr=$p($g(^DHCFavItems(FavRowid)),"^",11)
		 	i (FavUseHospDr'=CurLogonHosp) s find=1 Q	 
		 	;个人医嘱套,只对个人可见
		 	s FavUserDr=$p($g(^DHCFavItems(FavRowid)),"^",2)
		 	i (FavUserDr'="")&(UserRowId'=FavUserDr) s find=1 Q
		 	;科室医嘱套,只对科室可见
		 	s FavDepDr=$p($g(^DHCFavItems(FavRowid)),"^",4)
		 	i (FavDepDr'="")&(CurLogonDep'=FavDepDr) s find=1 Q
            ;全院医嘱套,只对医院可见
            s FavHospDr=$p($g(^DHCFavItems(FavRowid)),"^",9)
            i FavHospDr=0 s FavHospDr=""
		 	i (FavHospDr'="")&(CurLogonHosp'=FavHospDr) s find=1 Q	 	
	 	}
	 	s ItmHosipital=$$CheckArcosHosipital(ROW1,CurLogonHosp)
	 	if 'ItmHosipital s find=1
	 	if find=1 Q 0
	 	;判断设否有医嘱套可开权限
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",1)
	 	.q:(s-CATEG)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+user,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCATEG)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm)) q:Itm=""  d
	 	..s ItmData=$g(^SSU("SSGRP",+user,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=+ROW1 s found=1
	 	..e  d
	 	...i ItmId=+ROW1 s found=1
	 	i found=1 Q 0
	 } 
	 Q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
valordcat(user,CATEG)
	 ;1-valid,0-invalid
	 s found=0
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos,user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos,user)
	 s grp=$p($g(^SSU("SSUSR",+user)),"^",5)
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+grp,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	 s err=$$getall^MVBARCOI(arcos_"^ALL")
	 s found=0,ind=0
	 f  s ind=$o(PLIST(ind)) q:ind=""  q:found  d
	 .s arcim=$p(PLIST(ind),$c(2))
	 .s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
	 .s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	 .i '$d(UserCat(+orcat)) s found=61
	 q found
subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;if order subcategory is blank, index can be :
	; Desc - all order items, order sets
	; DescI - all order items,no order sets
	; DescVI - visible order items, no order sets
	; DescVIOS - visible order items, order sets
	;if order subcategory is not blank, index can be :
	; OrderCat-Desc - all order items, order sets
	; OrderCat-DescI - all order items,no order sets
	; OrderCat-DescVI - visible order items, no order sets
	; OrderCat-DescVIOS - visible order items, order sets
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	s CurLogonHosp=$p($g(^CTLOC(LogonLocID)),"^",22)
	do ..OpenGetAllOrderSetItem(ARCOSRowid,CurLogonHosp)
	s ExpStrIn="^"_CurLogonHosp
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=..%SysDate()
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
	..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..;s retPrice=..GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,"","",ExpStrIn)
	..s ItemBillUOMRowid=$p(s,"^",3)
	..i ItemBillUOMRowid="" s ItemBillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,EpisodeType)
	..s retPrice=##class(web.DHCDocOrderCommon).GetOrderPriceConUom(EpisodeID,InsType,OrderDepRowId,ARCIMRowid,"",ItemBillUOMRowid,"",ExpStrIn)
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
	..s n=n+1
	..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
	..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
	i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
	q OSItemIDs
OutputRow
	;w Data,!
	;s RowCountIndex=RowCountIndex+1
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
ChecArcimkHosipital(ROW1,CTLocHosi)
	;医院医嘱项目可用性
	s HosipitalStr=..ArcimCanUserHosipital(ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
CheckArcosHosipital(ROW1,CTLocHosi)
	;医院医嘱套可用性
	s HosipitalStr=..ArcosCanUserHosipital(+ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S RecLocStrSub=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(RecLocStrSub,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(RecLocStrSub,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
		
	}
	Q DeLocID
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpSubCatBroker(itmjs As %String = "", itmjsex As %String = "", Category As %String = "", SubCategory As %String = "", EpisodeID As %String = "", OrdCatGrp As %String = "") As %Library.Boolean
{
	&SQL(SELECT ARCIC_Desc,ARCIC_RowId,ARCIC_Code into :desc,:rowid,:code FROM SQLUser.ARC_ItemCat
	WHERE ((ARCIC_OrdCat_DR->ORCAT_RowId =:Category) OR (:Category IS NULL))
	AND (ARCIC_Code =:SubCategory))
	if SQLCODE d 
	.s desc="",rowid="",code=""
	s txt=desc_"^"_rowid_"^"_code
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(txt,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod OpenGetAllOrderSetItem(ARCOSRowid As %String, HospID As %String = "")
{
	;不应该直接调用GetAllOrderSetItem?因为它没有删除^CacheTemp("ARCOI",$j)
	d ..CloseGetAllOrderSetItem(ARCOSRowid)
	d ..GetAllOrderSetItem(ARCOSRowid,HospID)
}

ClassMethod SetArrivedStatus(Adm As %String, DocDr As %String, LocId As %String, UserId As %String) As %Status
{
	;s ^Tempzong("SetArrivedStatus")=Adm_"^"_DocDr_"^"_LocId_"^"_UserId
	Set sc=0
	s LoginDocId=DocDr
	Quit:$g(Adm)="" sc
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s admLoc=$P($g(^PAADM(Adm)),"^",4)
	;Quit:(LocId'=admLoc) sc //传入科室和就诊科室不一致,不做任何处理
	if DocDr="" d 
	.s DocDr=$P(^SSU("SSUSR",UserId),"^",14)
	.if DocDr=""  s DocDr=$P(^SSU("SSUSR",UserId),"^",9)
	s CTCPTInternalType=""
	i DocDr'="" d
	.s CTPCPCarPrvTpDR=$P(^CTPCP(DocDr,1),"^",4)
	.s CTCPTInternalType=$P(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	Quit:CTCPTInternalType="NURSE" sc
	
	Q:PAADMType="I" sc
	if PAADMType="E" {
		;Set sc1=##class(web.DHCDocEmergencyPatientList).SetArrivedStatus(Adm,DocDr,LocId,UserId)
		Set sc1=##class(web.DHCEMDocMainOutPat).SetArrivedStatus(Adm,DocDr,LocId,UserId)
		Q sc
	}
	&SQL(SELECT ID into :PerStateDr FROM sqluser.dhcPerstate where persname='到达')
	Set QueConsultFlag="N"
	;Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(Adm,DocDr)
	If QueRowId'="" Do
	.Set oref=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set PAAdmPriority=oref.QueFirstDr.FirstcName
	.Set Status=oref.QueStateDr.PersCode
	.//未报到是否可就诊
	.Set ExabNoCheckinDocCanRecAdm=oref.QueExabDr.ExabNoCheckinDocCanRecAdm
	.If (Status="01")!(Status="02")!(Status="03")!((ExabNoCheckinDocCanRecAdm="Y")&&(Status="07")) Do
	..Set QueDoc=oref.QueDocDrGetObjectId()
	..;存在大量叫号?过号但是不点到达的现象;这句如不屏蔽,则大量的医生工作量算不上
	..;可能存在问题:一个医生叫过的号,如果未诊疗,则仍可被其他医生诊疗算做自己工作量
	..;加设置决定 2009.03.19
	..s CFSetArriveByCallDoc=..%GetConfig("SetArriveByCallDoc")
	..Quit:(QueDoc'="")&(QueDoc'=DocDr)&(CFSetArriveByCallDoc=1)
	..If QueDoc="" do oref.QueDocDrSetObjectId(DocDr)
	..;
	..Do oref.QueStateDrSetObjectId(PerStateDr)
	..Set oref.QueCompDr=""
	..Set oref.QueStateDate=..%SysDate()
	..Set oref.QueStateTime=..%SysTime()
	..Do oref.OperuseridSetObjectId(UserId)
	..Set sc = oref.%Save()
	..Set QueConsultFlag=oref.QueConsultFlag
	 .Do oref.%Close()
	 Quit:(QueRowId'="")&(sc'=1) sc
	 if QueConsultFlag'="Y" {
	 	Set sc1=##class(web.DHCDocOutPatientList).SetAdmDocId(Adm,LoginDocId,LocId,UserId)
	 	If 'sc1 Set sc1=1
		i $G(UserId)="" s UserId=%session.Get("LOGON.USERID")
		i (UserId'="") {
			;i $G(^DHCDocCall(+$h,UserId))="" s ^DHCDocCall(+$h,UserId)=0
			if $g(^DHCDocCall(+$h,UserId,"Frist"))=Adm {
				s ^DHCDocSetArrive(UserId,+$H,"Arrive")=^DHCDocOutPatientList("WartInd",Adm)
			}
		}
	 }
	 Quit:QueRowId="" sc1
	 Quit sc
}

ClassMethod SetSessionData(Name As %String, Value As %String)
{
	 set %session.Data(Name)=Value
	 ;set ^DocBenchTemp(Name)=Value
}

ClassMethod SetSessionObject(ip, sql)
{
	;s $ZT="ERROR^SSERR"
	;s ip="192.192.70.106"
	;s sql="insert into tab_jiaohao (context,zs,bz,updatetime,createtime) values ('349-00000007-5-封平1-口腔正畸-李天侠-正畸主任医师号-1',1,0,2006-7-8,2006-7-8)"
	s usr="cydf"
	s pwd="cydf"
	;s ^zhou("jh")=ip_"^"_sql
 if '$Data(objdbConn) d
	.s objdbConn=##class(Activate.ADODB.Connection).%New()
	.s dsn="Driver={MySQL ODBC 3.51 Driver};SERVER="_ip_";UID="_usr_";PWD="_pwd_";DATABASE=ahsl_jiaohao"
	.d objdbConn.Open(dsn)
 e  d
 .;s ^zhou(1)=objdbConn
 .i objdbConn="" d
	..s objdbConn=##class(Activate.ADODB.Connection).%New()
	..s dsn="Driver={MySQL ODBC 3.51 Driver};SERVER="_ip_";UID="_usr_";PWD="_pwd_";DATABASE=ahsl_jiaohao"
	..d objdbConn.Open(dsn)
	;s ^zhou("1")=sql
 s rs=objdbConn.Execute(sql)
 d objdbConn.Close()
 d objdbConn.%Close()
 ;s objdbConn=""
	;s objdbConn=Null
	Q 0
}

ClassMethod TestQuery()
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItem","aspl","")
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry.LookUpItem")
	d rset.Execute("aspl",139,"","", "", "", "", "", "", "", "", "","", "","","")
	Set columns = rset.GetColumnCount()
	 While (rset.Next()) {
	     Write "------------------------",!
	         // loop over columns
	        For col = 1:1:columns {
	            Write rset.GetColumnName(col),":"
	            Write rset.GetData(col),!
	        }
	 }
	 d rset.Close()
	 ;do ##class(web.DHCDocOrderEntry).TestQuery();
	 ;web.OECOrderCategory
	 ;d ##class(%ResultSet).RunQuery("web.OEOrdItem",LooupItem,"","4","","216")
	 ;("", "4", "","251", "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
}

ClassMethod UpdateOrderItem(OrderItemRowid As %String, PackQty As %String, DoseQty As %String, DoseUOMDR As %String, FrequenceDR As %String, DurationDR As %String, InstructionDR As %String) As %String
{
	s OrderRowid=$P(OrderItemRowid,"||",1)
	s Childsub=$P(OrderItemRowid,"||",2)
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i (OrderType="R") d
	.if PackQty'="" s $P(^OEORD(OrderRowid,"I",Childsub,9),"^",4)=PackQty
	.if DoseQty'="" d
	..s $P(^OEORD(OrderRowid,"I",Childsub,2),"^",1)=DoseQty
	..s $P(^OEORD(OrderRowid,"I",Childsub,2),"^",3)=DoseUOMDR
	.if FrequenceDR'="" s $P(^OEORD(OrderRowid,"I",Childsub,2),"^",4)=FrequenceDR
	.if DurationDR'="" s $P(^OEORD(OrderRowid,"I",Childsub,2),"^",6)=DurationDR
	.if InstructionDR'="" s $P(^OEORD(OrderRowid,"I",Childsub,2),"^",7)=InstructionDR
	e  d
	.if PackQty'="" s $P(^OEORD(OrderRowid,"I",Childsub,1),"^",12)=PackQty
}

ClassMethod UpdateOrderItemBillType(OrderItemRowid As %String, BillTypeID As %String) As %String
{
	&sql(update SQLUser.oe_orditem set OEORI_BBExtCode=:BillTypeID Where OEORI_Rowid=:OrderItemRowid)
	Q SQLCODE
}

ClassMethod UpdateOrderItemField(OrderItemRowid As %String, FieldName As %String, FieldValue As %String) As %String
{
	if FieldName="PhSpecInstr" d
	.&sql(update SQLUser.oe_orditem set OEORI_PhSpecInstr=:FieldValue Where OEORI_Rowid=:OrderItemRowid)
	Q SQLCODE
}

ClassMethod UpdateOrderItemPackQty(OrderItemRowid) As %String
{
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i '$d(^OEORD(OrderRowid,"I",Childsub,9)) s PackQty=0
	e  s PackQty=$p(^OEORD(OrderRowid,"I",Childsub,9),"^",4)
	i (OrderType="R")&&((PackQty=0)!(PackQty="")) d
	.s PriorRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",8)
	.s FrequenceRowid=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",4)
	.s DurationRowid=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",6)
	.s DoseQty=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",1)
	.s DrgformRowid=..GetDrgForm(ArcimRowid)
	.s DosUOM=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",3)
	.s ARCOSItemQty=0
	.i $d(^OEORD(OrderRowid,"I",Childsub,3)) d
	..s ARCOSRowid=$p(^OEORD(OrderRowid,"I",Childsub,3),"^",10)
	..i ARCOSRowid'="" d
	...s ARCOSItemQty=..GetOrderSetItemQty(ARCOSRowid,ArcimRowid)
	.i ARCOSItemQty'=0 s PackQty=ARCOSItemQty
	.e  s PackQty=..GetPackqty(ArcimRowid,DrgformRowid, FrequenceRowid , PriorRowid, DurationRowid, DoseQty, DosUOM)
	.s MaxQty=..GetARCIMMaxQty(ArcimRowid)
	.i (MaxQty>0)&(PackQty>MaxQty) s PackQty=MaxQty  
	.s $p(^OEORD(OrderRowid,"I",Childsub,9),"^",4)=PackQty
	Q PackQty
}

ClassMethod UpdateOrderItemPackQty1(OrderItemRowid) As %String
{
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",2)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i '$d(^OEORD(OrderRowid,"I",Childsub,9)) s PackQty=0
	e  s PackQty=$p(^OEORD(OrderRowid,"I",Childsub,9),"^",4)
	i (OrderType="R")&&((PackQty=0)!(PackQty="")) d
	.s PriorRowid=$p(^OEORD(OrderRowid,"I",Childsub,1),"^",8)
	.s FrequenceRowid=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",4)
	.s DurationRowid=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",6)
	.s DrgformRowid=..GetDrgForm(ArcimRowid)
	.s DrgformChild=$p(DrgformRowid,"||",2)
	.s FormDesc=""
	.s FormRowid=$p($G(^PHCD(+DrgformRowid,"DF",DrgformChild,1)),"^",1)
	.i FormRowid'="" s FormDesc=$p($G(^PHCF(FormRowid)),"^",2)
	.i (FormDesc="滴鼻剂")||(FormDesc="滴眼剂") d
	..s EQChildsub=$O(^PHCD(+DrgformRowid,"DF",DrgformChild,"EQ",0))
	..i EQChildsub'="" d
	...s EQ=$g(^PHCD(+DrgformRowid,"DF",DrgformChild,"EQ",EQChildsub))
	...s PHCDoseUOM=$p(EQ,"^",1)
	...s PHCDoseQty=$p(EQ,"^",3)
	...i PHCDoseQty="" s PHCDoseQty=1
	...i PHCDoseUOM'="" d
	....s $p(^OEORD(OrderRowid,"I",Childsub,2),"^",3)=PHCDoseUOM
	....s $p(^OEORD(OrderRowid,"I",Childsub,2),"^",1)=PHCDoseQty
	.s DoseQty=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",1)
	.s DosUOM=$p(^OEORD(OrderRowid,"I",Childsub,2),"^",3)
	.s ARCOSItemQty=0
	.i $d(^OEORD(OrderRowid,"I",Childsub,3)) d
	..s ARCOSRowid=$p(^OEORD(OrderRowid,"I",Childsub,3),"^",10)
	..i ARCOSRowid'="" d
	...s ARCOSItemQty=..GetOrderSetItemQty(ARCOSRowid,ArcimRowid)
	.i ARCOSItemQty'=0 s PackQty=ARCOSItemQty
	.e  s PackQty=..GetPackqty(ArcimRowid,DrgformRowid, FrequenceRowid , PriorRowid, DurationRowid, DoseQty, DosUOM)
	.s MaxQty=..GetARCIMMaxQty(ArcimRowid)
	.i (MaxQty>0)&(PackQty>MaxQty) s PackQty=MaxQty  
	.s $p(^OEORD(OrderRowid,"I",Childsub,9),"^",4)=PackQty
	Q PackQty
}

ClassMethod UpdateOrderItemUserDep(OrderItemRowid, LocRowid)
{
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
	s $p(^OEORD(OrderRowid,"I",Childsub,7),"^",2)=LocRowid
	s UserID=%session.Get("LOGON.USERID")
	i UserID'="" d
	.s DocID=$p(^SSU("SSUSR",UserID),"^",14)
	.s $p(^OEORD(OrderRowid,"I",Childsub,1),"^",11)=DocID
}

ClassMethod UpdatePerInfo(PatientID As %String, RealName As %String, RealCard As %String, SupplyName As %String, SupplyCard As %String) As %String
{
	//lgl + 毒麻处方的患者信息
	&sql(update SQLUser.PA_PatMas set papmi_name5=:RealName,papmi_name6=:RealCard,papmi_name7=:SupplyName,papmi_name8=:SupplyCard where papmi_rowid=:PatientID)
	q SQLCODE
}

ClassMethod UpdatePAPMSID(PatientID As %String, PAID As %String) As %String
{
	s myrtn=0
	Q:PatientID="" "-100"
	s PatObj=##class(User.PAPatMas).%OpenId(PatientID)
	if $IsObject(PatObj) {
		TS
		;身份证字段更新
		s PatPersonObj=##class(User.PAPerson).%OpenId(PatientID)
		if $IsObject(PatPersonObj)
		{	
			s PatPersonObj.PAPERID=PAID
			s sc=PatPersonObj.%Save()
			if $$$ISERR(sc) {
				TRO
				s myrtn="-104"
				Q myrtn
			}
		}
		;身份证索引更新
		d ##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdatePAPMSID(PatientID,PAID)
		;证件号更新
		s PAPMIDVAnumber=PatObj.PAPMIDVAnumber
		if PAPMIDVAnumber="" {
			s PatObj.PAPMIDVAnumber=PAID
			s sc=PatObj.%Save()
			if $$$ISERR(sc) {
				TRO
				s myrtn="-104"


				Q myrtn
			}
		}
		TC
	}
	
	q myrtn
}

ClassMethod ValARCItem(ARCIMRowid As %String, AdmID As %String = "") As %String
{
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	;增加性别年龄判断
	s Active=0
	if AdmID'="" d
	.s Active=..ValARCItemAgeLimit(ARCIMRowid,AdmID)
	i Active=1 q 1
	
	q 0
}

ClassMethod ValARCOS(ARCOSRowid As %String) As %String
{
	n (ARCOSRowid)
	s datefrom=$p($g(^ARCOS(+ARCOSRowid)),"^",15)
	s dateto=$p($g(^ARCOS(+ARCOSRowid)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod ValOrdcat(GroupRowId, CatRowId, subCatRowId As %String = "") As %String
{
	/*
	 ;0-valid,1-invalid
	 s found=1
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  q:'found  s s=^(ord) d
	 .i '(s-CatRowId) s found=0
	 q found
	 */
	k UserCat
	s found=1 
	s ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	
	i '$d(UserCat(CatRowId)) q found
	s found=0
	s s=UserCat(+CatRowId)
	s subcat=$p(s,"^",3)
	i (subcat'="")&&(subCatRowId'="")&&(("!"_subcat_"!")'[("!"_subCatRowId_"!")) s found=1 
	Q found
}

/// 判断开医嘱/医嘱套权限,同LookUpItemExecute下的valord,修改此方法要同步修改LookUpItemExecute下的valord
/// w ##class(web.DHCDocOrderEntry).ValOrd("ARCIM",103,"1350||1","","",3880,85)
ClassMethod ValOrd(type, GroupRowId, ROW1, EpisodeType, EpLoc, UserRowId, CurLogonDep, CNMEDEntryFlag As %String = "", ARCOSRowId As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
	;1-valid,0-invalid
	 n (type,GroupRowId,ROW1,EpisodeType,EpLoc,UserRowId,CurLogonDep,CNMEDEntryFlag,ARCOSRowId,PatientID,EpisodeID,%session)
	 s ^TMPgry("ValOrd")=type_","_GroupRowId_","_ROW1_","_EpisodeType_","_EpLoc_","_UserRowId_","_CurLogonDep
	 Q:'UserRowId 1
	 Q:'ROW1 1
	 s PatientNo=""
	 if (PatientID'="") {
		 s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	 }
	 if (EpisodeID'="") {
		s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		s:(PACWardID'="") PACWardLocId=$P($g(^PAWARD(PACWardID)),"^",5)
		if ($g(EpisodeType)="I") s PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
	 }
	 s UseCNMedEntry=..%GetConfig("UseCNMedEntry")
	 s CNMedSubCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	 
	 s CTLocHosi=""
	 s:CurLogonDep'="" CTLocHosi=$P($G(^CTLOC(CurLogonDep)),"^",22)
	 s CTLocHosi=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CTLocHosi)
	 s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",CTLocHosi)
	 k UserCat
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  d
		.s s=^(ord)
		.s sssubcat=$p(s,"^",5)
		.s ondischarge=$p(s,"^",2)
		.;q:ondischarge'="Y"
		.if '$d(UserCat(+s)) d
		..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
		.e  d
		..s UserCat(+s)=UserCat(+s)_"!"_sssubcat

	 ;根据科室,医生,职称判断医嘱项的可开的权限
	 if type="ARCIM" {
		;医护人员-医嘱分类管控设置
		s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserRowId)
		if (CNMEDEntryFlag="CNMEDEntry") s checkType="CM"
		else  s checkType="XM"
	 	s AllowArcItemValue=##class(DHCDoc.DHCDocConfig.PrescriptSet).CheckForAllowArcItem(DoctorID,ROW1,CTLocHosi,checkType)
	 	if (AllowArcItemValue=0) Q 0
	 	
		s found=1
		s CatRowId=0
		s subCatRowId=$p($g(^ARCIM(+ROW1,$P(ROW1,"||",2),1)),"^",10)
		i subCatRowId'="" s CatRowId=$P($g(^ARC("IC",subCatRowId)),"^",8)
		Q:(UseCNMedEntry="1")&(CNMedSubCat'="")&&(("^"_CNMedSubCat_"^")[("^"_subCatRowId_"^"))&&(CNMEDEntryFlag'="CNMEDEntry") 0
		if (+GroupRowId'=0){
			i '$d(UserCat(CatRowId)) q 0
			s s=UserCat(+CatRowId)
			s subcat=$p(s,"^",3)
			i (subcat'="")&&(subCatRowId'="")&&(("!"_subcat_"!")'[("!"_subCatRowId_"!")) Q 0
		}
		i $p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",+ARCOSRowId="0" Q 0
		s Restrict=##class(web.DHCDocOrderCommon).CheckArcimType(ROW1,"",EpisodeType)
	    if Restrict'="" Q 0
		
		;毒麻可开权限控制,精一精二处方权 管制分类表PHC_Poison、
		;CT_CareProv_PHCPoison是医护人员授权的管制类型关联表
		s ItemPoisonAuth=..CheckDrgFormPoisonAuthorize(ROW1,UserRowId)
		Q:ItemPoisonAuth=0 0
		
	 	s ItemAuth=##class(web.DHCDocOrderCommon).CheckArcimAuthorize(ROW1,CurLogonDep,UserRowId)
	 	i ItemAuth=0 Q 0
	 	s ItmHosipital=$$CheckArcimHosipital1(ROW1,DefHospId)
	 	if 'ItmHosipital Q 0
	 	s CareProvDR=$P(^SSU("SSUSR",UserRowId),"^",14)
	 	if (CareProvDR'="") s CareProvTP=$P($G(^CTPCP(+CareProvDR,1)),"^",4)
	 	;s ItemAuth=##Class(PHA.FACE.OUT.Com).GetCombCtrlLevel(ROW1,CTLocHosi,"",CurLogonDep,EpLoc,$g(PACWardLocId),$g(CareProvTP),UserRowId,EpisodeType,$g(PAADMInsType),PatientNo,"")
	 	;Q:ItemAuth'="允许" 0
	 	;Q:ItemAuth.CtrlLevel="BAN" 0
	 	;判断设否有医嘱项可开权限
	 	s IncludeContinueFlag=0
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+GroupRowId,"SSORD",ord)),"^",1)
	 	.q:(s-CatRowId)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+GroupRowId,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCatRowId)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord,"ITM",Itm)) q:Itm=""  q:IncludeContinueFlag  d
	 	..s ItmData=$g(^SSU("SSGRP",+GroupRowId,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=(+ROW1_"||1") s found=1
	 	...e  s IncludeContinueFlag=1,found=0
	 	..e  d
	 	...i ItmId=(+ROW1_"||1") s found=1
	 	//科室医嘱录入权限控制:科室/病区->医嘱限制,可限制科室哪些医嘱不能开立
	 	s ItemLocAuth=##class(web.DHCBL.CT.CTLocOrderLimit).GetOrderLimtFlag(CurLogonDep,ROW1)
		i ItemLocAuth=1 Q 0
		// 过滤医嘱项服务组为挂号服务组的医嘱
		s RegServiceGroup=##class(web.DHCOPRegConfig).GetSpecConfigNode("RegServiceGroup",CTLocHosi)
		if (RegServiceGroup'="") {
			Q:$d(^ARCIM(0,"SERGRP",RegServiceGroup,+ROW1,$p(ROW1,"||",2))) 0
		}
	 	i found=1 Q 0
	 }
	 if type="ARCOS" {
		s found=1
		;i type="ARCOS",os'="Y" Q 0
		s CatRowId=$p($g(^ARCOS(+ROW1)),"^",8)
		s subCatRowId=$p($g(^ARCOS(+ROW1)),"^",9)
		
		i '$d(UserCat(CatRowId)) q 0
		s s=UserCat(+CatRowId)
		s os=$p(s,"^",2)
		i type="ARCOS",os'="Y" Q 0
		s subcat=$p(s,"^",3)
		i (subcat'="")&&(subCatRowId'="")&&(("!"_subcat_"!")'[("!"_subCatRowId_"!")) Q 0
		
		s ArcHosipital=$$CheckArcosHosipital1(ROW1,CTLocHosi)
	 	if 'ArcHosipital Q 0
		
		s find=0
	 	s FavRowid=0
	 	;s ^TMPgry("ARCOS",ROW1)=ROW1_","_UserRowId_","_CurLogonDep
	 	for {
		 	s FavRowid=$O(^DHCFavItems(0,"ItemRowid",+ROW1,FavRowid)) q:FavRowid=""
		 	;医嘱套使用院区,非本院区不可见
		 	s FavUseHospDr=$p($g(^DHCFavItems(FavRowid)),"^",11)
		 	i (FavUseHospDr'=CTLocHosi) s find=1 Q	 
		 	;个人医嘱套,只对个人可见
		 	s FavUserDr=$p($g(^DHCFavItems(FavRowid)),"^",2)
		 	i (FavUserDr'="")&(UserRowId'=FavUserDr) s find=1 Q
		 	;科室医嘱套,只对科室可见
		 	s FavDepDr=$p($g(^DHCFavItems(FavRowid)),"^",4)
		 	i (FavDepDr'="")&(CurLogonDep'=FavDepDr) s find=1 Q
			Set ARCOSEffDateTo=$p($g(^ARCOS(+ROW1)),"^",16) 	
		 	if (ARCOSEffDateTo'="")&&(ARCOSEffDateTo<+$h) s find=1 Q
	 	}
	 	if find=1 Q 0
	 	;判断设否有医嘱套可开权限
	 	s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  q:found  d
	 	.s s=$p($g(^SSU("SSGRP",+GroupRowId,"SSORD",ord)),"^",1)
	 	.q:(s-CatRowId)
	 	.s subItemCat=$p($g(^SSU("SSGRP",+GroupRowId,"SSORD",ord)),"^",5)
	 	.q:(subItemCat'="")&&(subItemCat-subCatRowId)
	 	.s Itm=0 f  s Itm=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord,"ITM",Itm)) q:Itm=""  d
	 	..s ItmData=$g(^SSU("SSGRP",+GroupRowId,"SSORD",ord,"ITM",Itm))
	 	..s ItmId=$p(ItmData,"^",1)
	 	..q:ItmId=""
	 	..s ItmNeedAuth=$p(ItmData,"^",2)
	 	..s ItmType=$p(ItmData,"^",3)
	 	..i ItmType="I" d
	 	...i ItmId'=+ROW1 s found=1
	 	..e  d
	 	...i ItmId=+ROW1 s found=1
	 	i found=1 Q 0
	 } 
	 Q 1
CheckArcimHosipital1(ROW1,CTLocHosi)
	;医院医嘱项目可用性
	s HosipitalStr=..ArcimCanUserHosipital(ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
CheckArcosHosipital1(ROW1,CTLocHosi)
	;医院医嘱项目可用性
	s HosipitalStr=..ArcosCanUserHosipital(+ROW1)
	Q:((CTLocHosi="")||(HosipitalStr="")) 1
	Q:("^"_HosipitalStr_"^")'[("^"_CTLocHosi_"^") 0
	Q 1
}

/// 判断开医嘱权限
/// 判断开医嘱权限
ClassMethod valordcatByArcim(GroupRowId, ArcimRowid, EpisodeType As %String = "", UserRowId As %String = "", CurLogonDep As %String = "") As %String
{
	 ;1-valid,0-invalid
	 ;w ##class(web.DHCDocOrderEntry).valordcatByArcim(314,"18414||1","I",3879,1595)
	s ^TMPgry("valordcatByArcim")=GroupRowId_","_ArcimRowid_","_EpisodeType_","_UserRowId_","_CurLogonDep
	s found=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GroupRowId,ArcimRowid,EpisodeType,"",UserRowId,CurLogonDep)
	q found
	
	k UserCat
	s found=1
	q:ArcimRowid="" found
	s CatRowId=0
	s subCatRowId=$p($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1)),"^",10)
	i subCatRowId'="" s CatRowId=$P($g(^ARC("IC",subCatRowId)),"^",8)
	 
	s ord=0 f  s ord=$o(^SSU("SSGRP",+GroupRowId,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.s ondischarge=$p(s,"^",2)
	.;q:ondischarge'="Y"
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	
	i '$d(UserCat(CatRowId)) q found
	s found=1
	s s=UserCat(+CatRowId)
	s subcat=$p(s,"^",3)

	i (subcat'="")&&(subCatRowId'="")&&(("!"_subcat_"!")'[("!"_subCatRowId_"!")) s found=0
	Q found
}

ClassMethod caculateduration(ArcimRowid, DrgformRowid, FrequenceRowid, PackQty, OrderQty, OrderUOM) As %String
{
 s find="N"
 s DurationDesc=""
 s DurationRowid1=""
 s Doseqty=..CalDose(OrderUOM,DrgformRowid,OrderQty)
 s convqty=..GetItemConFac(ArcimRowid)
 s DoseqtySum=PackQty*convqty
 s s=$g(^PHCFR(+FrequenceRowid))
 s FreqFactor=$p(s,"^",2),FreqDays=$p(s,"^",5)
 i 'FreqDays,FreqFactor d
 .s DurationFactor2=DoseqtySum/(FreqFactor*Doseqty)
 .s DurationFactor1=DurationFactor2\1+$s(DurationFactor2#1:1,1:0)
 e  d
 .s DurationFactor2=DoseqtySum/(Doseqty)
 .s DurationFactor1=(DurationFactor2\1+$s(DurationFactor2#1:1,1:0))*FreqDays
 ;
 s DurationRowid=0 f  s DurationRowid=$o(^PHCDU(DurationRowid)) q:(DurationRowid="")!(find="Y")  d
 .s DurationFactor=$P($g(^PHCDU(DurationRowid)),"^",2)
 .i DurationFactor=DurationFactor1 d
 ..s find="Y"
 ..s DurationRowid1=DurationRowid
 ..s DurationDesc=$P($g(^PHCDU(DurationRowid)),"^",3)
 .q:find="Y"_"^^^"_DurationFactor1
 q find_"^"_DurationRowid1_"^"_DurationDesc_"^"_DurationFactor1
}

ClassMethod getPatEpisLoc(EpisodeID As %String) As %String
{
	s AdmDep=$P($G(^PAADM(EpisodeID)),"^",4)
	Q $P($G(^CTLOC(AdmDep)),"^",2)
}

// 加入医嘱类型

ClassMethod LookUpDHCDocOrderTypeBroker(itmjs As %Library.String = "", desc As %String = "") As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpDHCDocOrderType")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Desc=rset.GetData(2)
		s value=rset.GetData(1)
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

/// creator:李相宗
/// date:2012-02-11
/// desc:根据OrderItemRowid取相关的信息串
/// input:OrderItemRowid
/// w ##class(web.DHCDocConfig).GetItmMessageById()
ClassMethod GetItmMessageById(ItemRowid As %String) As %String
{
   	s Str=""
 	s ARCIMDesc="",UOMDesc="",ARCIMUOMDR="",OrderPackUOM="",OrderPackUOMRowid="",RICDesc=""

	s ItemFreq="",ARCIMRMFrequencyDR="",ItemFreqFactor="",ItemFreqInterval=""
	s ItemInstr="",ItemInstrRowid=""
	s ItemDur="",ARCIMRMDurationDR="",ItemFreqFactor="" s ItemDurFactor=""
	s ARCIMSubscript=$P(ItemRowid,"||",1)
	s ARCIMVersion=$P(ItemRowid,"||",2)
	s ARCIMCode=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",1) //代码
	s ARCIMDesc=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)	//描述
	//---------------------------检查是否停用
	//s ItemStatus=##Class(web.DHCDocOrderEntry).ValARCItem(OrderItemRowid)
	//i ItemStatus=1 s ItemStatus="停用"
	//e  s ItemStatus=""
	s ARCIMDoseType=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",5)
	//---------------------------- 基本单位
	s ArcimbaseuomId=""
	s inci=..GetINCI(ARCIMSubscript)
	if inci'="" {
		s ArcimbaseuomId=$p(^INCI(inci,1),"^",10)
		i ArcimbaseuomId'="" s UOMDesc=$P(^CT("UOM",ArcimbaseuomId),"^",2)
	}

	///---------------------------- 单位 (盒、瓶)
	s ARCIMBillingUOMDr=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)
	if ARCIMBillingUOMDr'=""  d
	.s OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOMDr),"^",2)
	.s ItemDur=$P($G(^PHCDU(ARCIMBillingUOMDr)),"^",3)
	.s OrderPackUOMRowid=ARCIMBillingUOMDr
	
	///---------------------PHC_Freq 药品频次
	s ARCIMRMFrequencyDR=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",17)
	if ARCIMRMFrequencyDR'="" d
	.s ItemFreq=$P($G(^PHCFR(ARCIMRMFrequencyDR)),"^",3)
	.s ItemFreqFactor=$P($g(^PHCFR(ARCIMRMFrequencyDR)),"^",2)
	.s ItemFreqInterval=$P($g(^PHCFR(ARCIMRMFrequencyDR)),"^",5)

	s ARCIMRMDurationDR=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",16)
	if ARCIMRMDurationDR'=""  d
	.s ItemDur=$P($G(^PHCDU(ARCIMRMDurationDR)),"^",3)
	.s ItemDurFactor=$P($g(^PHCDU(ARCIMRMDurationDR)),"^",2)

	s ItemDoseQty=""
	//---------------------------
	//医嘱子分类
	s ARCIMItemCatDR=$P(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)
	s ARCICDesc=$P(^ARC("IC",ARCIMItemCatDR),"",2) 
	s ItemOrderType=$P(^ARC("IC",ARCIMItemCatDR),"^",7)
	if (ItemOrderType="R")&&(ItemDurFactor="") s ItemDurFactor=1

	s RICRowId=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",17)
	if RICRowId'=""  d
	.s RICDesc=$P(^DTC("RIC",RIC_RowId),"^",2)
	
	s ItemInstr="" s ItemInstrRowid=""
	s Str=ARCIMDesc_"^"_UOMDesc_"^"_ArcimbaseuomId_"^"_OrderPackUOM_"^"_OrderPackUOMRowid
	s Str=Str_"^"_ItemFreq_"^"_ARCIMRMFrequencyDR_"^"_ItemFreqFactor_"^"_ItemFreqInterval
	s Str=Str_"^"_ItemInstr_"^"_ItemInstrRowid
	s Str=Str_"^"_ItemDur_"^"_ARCIMRMDurationDR_"^"_ItemDurFactor

	q Str
}

/// creator:郭荣勇
/// date:2012-08-11
/// desc:根据安全组得到开始菜单
/// input:StartTMENU 开始菜单
/// w ##class(web.DHCDocOrderEntry).GetStartTMENU()
ClassMethod GetStartTMENU(GroupID As %String) As %String
{
	n (GroupID)
	s StartTMENU=""
	s StartWFRowid=##class(epr.GroupSettings).GetStartPage(GroupID)
    s MainMenuRowid=##class(epr.GroupSettings).GetMainMenu(GroupID)
    if (StartWFRowid'="")&(MainMenuRowid'="") {
	    s Obj=##class(websys.WorkFlow).%OpenId(StartWFRowid)
	    ;s FirstItemDesc=$p(Obj.NamesGet(),"|")
	    s WorkFlowItemID=Obj.WorkFlowItems.GetAt(1).ItemGetObjectId()
	    d Obj.%Close()
	    if WorkFlowItemID'="" {
		    s WFIObj=##class(websys.WorkFlowItemDefinition).%OpenId(WorkFlowItemID)
		    s ComponentID=WFIObj.ComponentGetObjectId()
		    s Url=WFIObj.Url
		    d WFIObj.%Close()
		    if ComponentID'="" {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    s WorkFlowID=LMObj.WorkFlowGetObjectId()
				    d LMObj.%Close()
				    ;1.按菜单关联的组件找
				    if ComponentID=LinkComponentID s StartTMENU=LoopMenu Q
				    ;2.如菜单未关联组件,按配置的工作流下的组件找
				    if (WorkFlowID'="") {
					    s SubWFObj=##class(websys.WorkFlow).%OpenId(WorkFlowID)
					    s SubFirstWFI=SubWFObj.WorkFlowItems.GetAt(1)
					    if $IsObject(SubFirstWFI) {
					    	if ComponentID=SubFirstWFI.Item.ComponentGetObjectId() s StartTMENU=LoopMenu Q
					    }
				    }
			    }
		    }
		    ;w ",StartTMENU1="_StartTMENU_",Url="_Url_",ComponentID="_ComponentID_",MainMenuRowid="_MainMenuRowid
		    if (StartTMENU="")&&(Url'="") {
			    s LoopMenu=0
			    for {
				    s LoopMenu=$O(^websys.MenuI("SubMenuOf1",MainMenuRowid,LoopMenu))
				    q:LoopMenu=""
				    s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
				    s LinkComponentID=LMObj.LinkComponentGetObjectId()
				    s LinkUrl=LMObj.LinkUrl
				    d LMObj.%Close()
				    if Url=LinkUrl s StartTMENU=LoopMenu Q
			    }
		    }
	    }
    }
    
    Q StartTMENU
}

ClassMethod GetValueExpressionByMenuId(LoopMenu As %String) As %String
{
	s LMObj=##class(websys.Menu).%OpenId(LoopMenu)
    s ValueExpression=LMObj.ValueExpression
    d LMObj.%Close()
    Q ValueExpression
}

Query LookUpDHCDocOrderType(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
	
	SELECT OECPR_RowId,OECPR_Desc, OECPR_Code
	FROM SQLUser.OEC_Priority
	WHERE (OECPR_Desc %STARTSWITH  :desc or OECPR_Code %STARTSWITH  :desc) and (OECPR_RowId not in (select OECPR_RowId from SQLUser.OEC_Priority where OECPR_Priority=0))
}

Query FindPAADMByPADate(PatientID As %Library.String, AdmDate As %Library.String) As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,PAADM_DEPCode_DR,PAADM_DEPCode_DR,PAADM_AdmDocCodeDR,PAADM_AdmDocCodeDR FROM SQLUser.PA_ADM Where PAADM_PAPMI_DR=:PatientID and PAADM_ADMDate=:AdmDate
}

Query GetCNPrescItems(EpisodeID As %String, PrescNo As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,SeqNo:%String,DoseQty:%String,DoseUOM:%String,Priority:%String,Status:%String,Frequence:%String,Instruction:%String,Duration:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String")
{
}

Query GetItems(EpisodeID As %String, dfrom As %String, dto As %String, OrderItemRowid As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "StartDate:%String,StartTime:%String,SeqNo:%String,OrderName:%String,HIDDEN:%String,num:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT Todate(OEORI_SttDat,'dd/mm/yyyy'),SUBSTR(CAST(OEORI_SttTim As TIMESTAMP),12),OEORI_SeqNo,OEORI_ItmMast_DR->ARCIM_Desc,OEORI_Rowid,"","",
	 OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),oeori_PHFreq_dr->PHCFR_Desc1,
	 OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,oeori_PHFreq_dr->PHCFR_Factor,OEORI_Durat_dr->PHCDU_Factor
	 from SQLUser.OE_OrdItem Where OEORI_OEORD_Parref->OEORD_ADM_DR=:EpisodeID and
	  OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='R' and OEORI_SttDat>=:dfrom and OEORI_Rowid<>:OrderItemRowid
}

Query GetLocICD(LocRowid As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Rowid:%String,Code:%String")
{
	Select LOC_ParRef->MRCID_Desc,LOC_ParREf,LOC_ParRef->MRCID_Code From SQLUser.MRC_ICDLocation Where LOC_CTLOC_DR=:LocRowid
}

Query GetOrderItems(EpisodeID As %String, IsPhamacy As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,SeqNo:%String,DoseQty:%String,DoseUOM:%String,Priority:%String,Status:%String,Frequence:%String,Instruction:%String,Duration:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String,OrderType:%String")
{
}

Query GetPrescItemsSQL(EpisodeID As %String, PrescNo As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,SeqNo:%String,DoseQty:%String,DoseUOM:%String,Priority:%String,Status:%String,Frequence:%String,Instruction:%String,Duration:%String,PackQty:%String,RecDep:%String,Billed:%String")
{
	SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),OEORI_SeqNo,OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,
	 OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,oeori_PHFreq_dr->PHCFR_Desc1,
	 OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,OEORI_QtyPackUOM,OEORI_RecDep_DR->CTLOC_Desc,OEORI_Billed
	 from SQLUser.OE_OrdItem Where OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID
}

Query LookUpCat(Category As %Library.String, SSGRP As %Library.String, FilterBy As %Library.String, EpisideID As %Library.String, OrdCatGrp As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "catDesc:%String,HIDDEN:%String,Code:%String")
{
	SELECT ORCAT_Desc,ORCAT_RowId,ORCAT_Code FROM SQLUser.OEC_OrderCategory	Where (ORCAT_Code=:Category) OR (ORCAT_DESC %STARTSWITH :Category) OR (:Category is null)
}

Query LookUpDuration(desc As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
	SELECT PHCDU_Rowid,PHCDU_Desc1,PHCDU_Code FROM SQLUser.PHC_Duration
	WHERE   PHCDU_Desc1  %STARTSWITH  :desc
}

Query LookUpFrequence(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Rowid,Desc,Code,HIDDEN:%String,HIDDEN:%String")
{
	SELECT PHCFR_Rowid,PHCFR_Desc1, PHCFR_Code, PHCFR_Factor,PHCFR_Days
	FROM SQLUser.PHC_Freq
	WHERE   PHCFR_Desc1  %STARTSWITH  :desc and PHCFR_ActiveFlag<>'N'
	ORDER   BY PHCFR_Desc1
}

Query LookUpInstruction(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
	SELECT PHCIN_Rowid,PHCIN_Desc1, PHCIN_Code
	FROM SQLUser.PHC_Instruc
	WHERE (PHCIN_Desc1  %STARTSWITH  :desc or PHCIN_Code %STARTSWITH  :desc) 
	and PHCIN_ActiveFlag<>'N'
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String:医嘱名称,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,subcatdesc:%String:子类,ItemPrice:%String:价格,BasicDrugFlag:%String:基本药物,billuom:%String:计价单位,StockQty:%String:库存数,PackedQty:%String:打包数,GenericName:%String:通用名,ResQty:%String:在途数,DerFeeRules:%String:收费规定,InsurClass:%String:医保类别,InsurSelfPay:%String:自付比例,Recloc:%String:接收科室,arcimcode:%String:代码,HIDDEN:%String,HIDDEN:%String,INCIItemLocked:%String,FormDesc:%String:剂型,InsuNationCode:%String:国家医保编码,InsuNationName:%String:国家医保名称,DrugIconStr:%String:药品图标")
{
}

Query LookUpSubCat(Category As %Library.String, SubCategory As %Library.String, EpisodeID As %Library.String, OrdCatGrp As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "subCatDesc:%String,subCatRowID:%String,subCatCode:%String")
{
	SELECT ARCIC_Desc,ARCIC_RowId,ARCIC_Code FROM SQLUser.ARC_ItemCat
	WHERE ((ARCIC_OrdCat_DR->ORCAT_RowId =:Category) OR (:Category IS NULL))
	AND ((ARCIC_Desc %STARTSWITH :SubCategory) OR (ARCIC_Code = :SubCategory) OR(:SubCategory IS NULL))
}

/// creator:郭荣勇 at 协和医院
/// date:2011-11-01
/// desc:判断开医嘱权限
/// input:安全组Rowid output:DIV的innerHTML的串
/// w ##class(web.DHCDocOrderEntry).GetOtherMenuDIV(100)
ClassMethod GetOtherMenuDIV(GroupRowId As %String) As %String
{
	s $zt="Error"
	;四个权限级别 SetSaveForGroup(安全组),SetSaveForSite(站点),SetSaveForUser(用户),SetSaveForLocation(科室),SetSaveForHospital(医院)
	s myDIVHTML="",myDIVHTML1="",myMenuStr=""
	
	s myDIVHTML="<div id='OtherMenu1' class='OtherMenu1'> </div>"
	s myDIVHTML1="<div id='OtherMenu1_2' class='OtherMenu1_2'> </div>"
	
	s myMenuStr="var menu = ["
	s myMenuStr=myMenuStr_"{ id: 1, parent: 0, html: '其他功能', hover: 'on1_2', rank: 1, property: { onclick: function(){ websys_cancel(); } }}"
	;s myMenuStr=myMenuStr_",{ id: 11, parent: 1, html: '保存到用户常用', hover: 'on1_2', property: { onclick: function(){ SetSaveForUserClickHandler(); } }}"
	;s myMenuStr=myMenuStr_",{ id: 12, parent: 1, html: '保存到科室常用', hover: 'on1_2', property: { onclick: function(){ SetSaveForLocationClickHandler(); } }}"
    s Num=1
	&SQL(DECLARE OtherMenu CURSOR FOR
    SELECT ID,Name INTO :ID,:Name
    From websys.Menu
    WHERE Name like '%System.OEOrder.OrgFav.Save%')
    &SQL(OPEN OtherMenu)
    For  &SQL(FETCH OtherMenu) QUIT:SQLCODE  do
    .q:$g(ID)=""
	.s MenuSecFlag=##class(ext.websys.Menu).GetMenuSecurity($g(ID))
	.;s MenuSecFlag=1
	.q:MenuSecFlag'=1
	.q:Name["SetSaveForSite"
	.s FunDesc=""
	.;i Name["SetSaveForGroup" s FunDesc="保存到安全组常用"
	.i Name["SetSaveForUser"  s FunDesc="保存到用户常用"
	.i Name["SetSaveForLocation" s FunDesc="保存到科室常用"
	.;i Name["SetSaveForHospital" s FunDesc="保存到医院常用"
	.q:FunDesc=""
	.s FunName=$p(Name,".",$l(Name,"."))
	.s Menuid=FunName_"OtherMenu"
	.s FunClick=FunName_"ClickHandler()"
	.s myMenuStr=myMenuStr_",{ id: 1"_Num_", parent: 1, html: '"_FunDesc_"', hover: 'on1_2', property: { onclick: function(){ "_FunClick_"; } }}"
    .s Num=Num+1
    &SQL(CLOSE OtherMenu)
    s myMenuStr=myMenuStr_"]"
    
	q myDIVHTML_"^"_myDIVHTML1_"^"_myMenuStr
Error
	q ""
}

/// creator:王锴
/// date:2013-03-07
/// desc:护士补录医嘱界面通过医嘱字典录入医嘱时的判断。
ClassMethod AddControl(ACRIM As %String, GroupID As %String) As %String
{
	n (ACRIM,GroupID)
	Q:+ACRIM=0 0 
	s ItemCatDR=$p(^ARCIM(+ACRIM,$p(ACRIM,"||",2),1),"^",10)
	s OrderCatDr=$P(^ARC("IC",ItemCatDR),"^",8)
	s UserCateDR=""
	s flag=1
	s SSORDGroupRowId=0 f  s SSORDGroupRowId=$o(^SSU("SSGRP",GroupID,"SSORD",SSORDGroupRowId)) Q:(SSORDGroupRowId="")  D
	.s UserCatDr=$p($g(^SSU("SSGRP",GroupID,"SSORD",SSORDGroupRowId)),"^",1)
	.i UserCatDr'=OrderCatDr q
	.e  d
	..s SSCat=$p($g(^SSU("SSGRP",GroupID,"SSORD",SSORDGroupRowId)),"^",5)
	..s UserCate=UserCatDr_"@"_SSCat
	..s UserCateDR=UserCate_"^"_UserCateDR
	
	i UserCateDR'="" d
	.s lenght=$L($g(UserCateDR),"^")
	.f len=1:1:lenght d
	..s UCateDr=$p(UserCateDR,"^",len)
	..s UCate=$p(UCateDr,"@",2)
	..i ((ItemCatDR=UCate)!(UCate=""))  d 
	...s flag=0
	...q
	q flag
}

/// desc 计算可用天数
/// input ArcimId-医嘱项RowID  FreqRowid-频次ID  
/// 		DurRowid-疗程ID  qtyPackUom-整包装数量  DoseQty-单次计量  
/// 		unitUomId-单次计量单位  PACKUomRowID--整包装单位。协议包装
/// w ##class(web.DHCDocOrderEntry).CalcDurByArcim("2223||1","16","1","1","1","2","30","","")
ClassMethod CalcDurByArcim(ArcimId As %String, FreqRowid As %String, DurRowid As %String, qtyPackUom As %String, DoseQty As %String, unitUomId As %String, PACKUomRowID As %String = "", OrderFreqDispTimeStr As %String = "", OrderFreqTimeDoseStr As %String = "") As %String
{
  n (ArcimId,FreqRowid,DurRowid,qtyPackUom,DoseQty,unitUomId,PACKUomRowID,OrderFreqDispTimeStr,OrderFreqTimeDoseStr)
  s ^tmpgry("CalcDurByArcim")=$LB(ArcimId,FreqRowid,DurRowid,qtyPackUom,DoseQty,unitUomId,PACKUomRowID,OrderFreqDispTimeStr,OrderFreqTimeDoseStr)
  s durfactor=0
  q:ArcimId="" durfactor
  //频次 Freqfactor
  s Freqfactor=1,Freqdays="",WeekFlag="N",FreeTimeFreqFlag="N"
  i FreqRowid'="" {
	  s Freqfactor=$p($g(^PHCFR(FreqRowid)),"^",2)
	  s Freqdays=$p($g(^PHCFR(FreqRowid)),"^",5)
	  s WeekFlag=$P(^PHCFR(FreqRowid),"^",9)
	  s FreeTimeFreqFlag=$P(^PHCFR(FreqRowid),"^",13)
	  s IntervalUnit=$P($g(^PHCFR(FreqRowid)),"^",14)	;间隔单位
	  i IntervalUnit="H"{
		  s Freqfactor=24/Freqdays
		  s:Freqfactor#1>0 Freqfactor=Freqfactor\1+1
		  s Freqdays=Freqdays\24
	  }
	  s:+Freqdays=0 Freqdays=1
  }
  i Freqfactor="" s Freqfactor=1
  s Weekfactor=1
  if (WeekFlag="Y"){
	 s Freqdays=7
	 s OrderFreqWeekStr=##Class(web.DHCOEOrdItem).GetOrderFreqWeekStr(OrderFreqDispTimeStr)
	 if (OrderFreqWeekStr'=""){
		s Weekfactor=$L(OrderFreqWeekStr,"|")
 	 }
  }
  if (FreeTimeFreqFlag="Y")&&(OrderFreqDispTimeStr'="") {
	  s OrderFreqFreeTimeInfo=##Class(web.DHCOEOrdItem).GetOrderFreqFreeTimeInfo(FreqRowid,OrderFreqDispTimeStr)
	  s OrderFreqFreeTimeStr=$P(OrderFreqFreeTimeInfo,"^",1)
	  s Freqfactor=$L(OrderFreqFreeTimeStr,"|")
  }
  //疗程
  s Durfactor=""
  i DurRowid'="" s Durfactor=$p($g(^PHCDU(DurRowid)),"^",2)
  i 'DurRowid s Durfactor=1

  ;门诊不计算整包装的剂型,返回医生录入的疗程
  s PHCFormStr=..%GetConfig("NotCalcPackQtyPHCForm")
  s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimId)
  s FormRowid=""
  i DrgformRowid'="" s FormRowid=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),1)),"^",1)
  q:("^"_PHCFormStr_"^")[("^"_FormRowid_"^") +$p($g(^PHCDU(+DurRowid)),"^",2)
  //总取药量  qtyPackUom  
  q:+qtyPackUom=0 durfactor	
  //单次剂量 DoseQty 
  q:(+DoseQty=0)&&(OrderFreqTimeDoseStr="") Durfactor
  s PackFactor=$$CalcPackfac1(ArcimId,unitUomId,PACKUomRowID)
  s factor=$p(PackFactor,"^",2) //基本单位和整包装单位转化系数
  s eqQty=$p(PackFactor,"^",3)  //基本单位和剂量单位转换系数
  if (OrderFreqTimeDoseStr'="") {
  	  s Len=$l(OrderFreqTimeDoseStr,"!")
      for i=1:1:Len{
        s OneFreqDispTimeDose=$p(OrderFreqTimeDoseStr,"!",i)
        s OneDoseQty=$p(OneFreqDispTimeDose,"$",2)
        s OneBaseDoseQty = +##Class(web.DHCDocOrderEntry).CalDose(unitUomId, DrgformRowid, OneDoseQty)
        s DoseQty=DoseQty+OneBaseDoseQty
      }
	  s DoseQty=DoseQty*eqQty
  }else{
	  if $p(PackFactor,"^",1)'=1 {   //按一日剂量计算总量
		  s DoseQtyBase=..CalDose(unitUomId,DrgformRowid,DoseQty)
		  s DoseQty=DoseQtyBase*eqQty
	  }
  }
  s InsuConvFactor=$$CalcInsuConvFactor(ArcimId,unitUomId,FreqRowid,PACKUomRowID)
  if (OrderFreqTimeDoseStr'="") {
	  s durfactor=(qtyPackUom*InsuConvFactor)/(DoseQty)
  }else{
  	  s durfactor=(qtyPackUom*InsuConvFactor)/(DoseQty*Freqfactor)
  }
  if (durfactor[".") s durfactor=$p(durfactor,".",1)+1
  s durfactor=durfactor\Weekfactor
  i durfactor'<1 {
	  ;先计算间隔天数,后取值
	  i Freqdays'="" s durfactor=durfactor*Freqdays
	  s durfactor=$p(durfactor,".",1)
  }else{
	  ;先取值,再计算间隔天数
	  i Freqdays'="" {
		  s durfactor=durfactor*Freqdays
	  	  s durfactor=$p(durfactor,".",1)
	  }
	  i durfactor<1 s durfactor=1
  }
  q durfactor
CalcPackfac1(arcimId,unitUomId,PACKUomRowID)
	n (arcimId,unitUomId,PACKUomRowID)
  //计算一个医嘱项的转换系数 Packfactor
  s Packfactor=1  
  q:arcimId="" Packfactor  
  s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
  q:+phcdfId<1 Packfactor
  ;协议包装单位
  i PACKUomRowID'="" s packUomId=PACKUomRowID
  e  s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14) //计价单位
  
  q:+packUomId=0 Packfactor
  s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
  s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)	//基本单位
  q:+baseUomId=0 Packfactor
  s factor=1
  i packUomId'="" d
  .i baseUomId'=packUomId d
  ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
  ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
  
  ;得到基本单位和计价单位的转换系数  add by gry
  ;s factor=..GetItemConFac(arcimId)

  q:+unitUomId=0 Packfactor
  s eqQty=1
  i baseUomId'=unitUomId d
  .s eqId=0,eqQty=1
  .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
  ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
  ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
  s phcdPack=$p($g(^PHCD(phcdId,"DF",phcdfSub,"DHC")),"^",1)
  q +$g(phcdPack)_"^"_factor_"^"_eqQty
  
CalcInsuConvFactor(arcimId,unitUomId,FreqRowid,PACKUomRowID)
	n (arcimId,unitUomId,FreqRowid,PACKUomRowID)
    s InsuConvFactor=1
	//频次 Freqfactor
    s Freqfactor=1,Freqdays=""
    i FreqRowid'="" s Freqfactor=$p($g(^PHCFR(FreqRowid)),"^",2),Freqdays=$p($g(^PHCFR(FreqRowid)),"^",5)
    i Freqfactor="" s Freqfactor=1
	s PackFactor=$$CalcPackfac1(arcimId,unitUomId,PACKUomRowID)
	s factor=$p(PackFactor,"^",2) //基本单位和整包装单位转化系数
    s eqQty=$p(PackFactor,"^",3)  //基本单位和剂量单位转换系数
    ;草药不换算
    s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(arcimId)
    if CNMedItemFlag=1 {
	    s InsuConvFactor=factor
    }else{
	    s InsuConvFactor=factor*eqQty
    }
    i InsuConvFactor=0 s InsuConvFactor=1

    q InsuConvFactor
}

/// W ##class(web.DHCDocOrderEntry).CalcDur("6939||31")
ClassMethod CalcDur(oeoriId As %String) As %String
{
  n (oeoriId,%session)
  s durfactor=0
  q:oeoriId="" durfactor
  s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
  
  ;草药直接传疗程,不通过频次反算
  s CNMedItemCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
  i CNMedItemCat'="" s CNMedItemCat="^"_CNMedItemCat_"^"
  
  //频次 Freqfactor
  s FreqRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
  s Freqfactor=1,Freqdays="",WeekFlag="N",FreeTimeFreqFlag="N"
  i FreqRowid'="" {
	  s Freqfactor=$p($g(^PHCFR(FreqRowid)),"^",2)
	  s Freqdays=$p($g(^PHCFR(FreqRowid)),"^",5)
	  s WeekFlag=$P(^PHCFR(FreqRowid),"^",9)
	  s FreeTimeFreqFlag=$P(^PHCFR(FreqRowid),"^",13)
	  s IntervalUnit=$P($g(^PHCFR(FreqRowid)),"^",14)	;间隔单位
	  i IntervalUnit="H"{
		  s Freqfactor=24/Freqdays
		  s:Freqfactor\1>0 Freqfactor=Freqfactor\1+1
		  s Freqdays=Freqdays\24
	  }
	  s:+Freqdays=0 Freqdays=1
  }
  i Freqfactor="" s Freqfactor=1
  s Weekfactor=1
  if (WeekFlag="Y"){
	 s Freqdays=7
	 s OrderFreqWeekStr=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",55)
	 if (OrderFreqWeekStr'=""){
		s Weekfactor=$L(OrderFreqWeekStr,"|")
 	 }
  }
  if (FreeTimeFreqFlag="Y") {
	  s OrderFreqFreeTimeStr=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",68)
	  if (OrderFreqFreeTimeStr'="") s Freqfactor=$L(OrderFreqFreeTimeStr,"|")
  }
  //疗程
  s Durfactor=""
  s DurRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
  i DurRowid'="" s Durfactor=$p($g(^PHCDU(DurRowid)),"^",2)
  i DurRowid s Durfactor=1
  ;门诊不计算整包装的剂型,返回医生录入的疗程
  s ArcimRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
  s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
  s PHCFormStr=..%GetConfig("NotCalcPackQtyPHCForm")
  s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
  s FormRowid=""
  i DrgformRowid'="" s FormRowid=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),1)),"^",1)
  q:("^"_PHCFormStr_"^")[("^"_FormRowid_"^") +$p($g(^PHCDU(+DurRowid)),"^",2)
  
  //取实际发药量  qtyPackUom
  ;s qtyPackUom=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
  s qtyPackUom=..GetActiveDrugQty(oeoriId)
  q:+qtyPackUom=0 durfactor	
  if (CNMedItemCat[("^"_ItemCatDR_"^")){
	   s durfactor=+$p($g(^PHCDU(+DurRowid)),"^",2)
	   ;s durfactor=durfactor/Freqfactor 草药目前是应该不能和分发频率走
	   if (durfactor[".") s durfactor=$p(durfactor,".",1)+1
	   Q durfactor
  }
  s OrderFreqTimeDoseStr=$p($g(^OEORD(+oeordId,"I",oeoriSub,"DHC")),"^",59)
  s SameFreqDifferentDosesFlag="N"
  //单次剂量 DoseQty 
  s DoseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
  q:(+DoseQty=0)&&(OrderFreqTimeDoseStr="") Durfactor
  s PackFactor=..CalcPackfac(oeoriId)
  s factor=$p(PackFactor,"^",2) //基本单位和整包装单位转化系数
  s eqQty=$p(PackFactor,"^",3)  //基本单位和剂量单位转换系数
  s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
  i $p(PackFactor,"^",1)'=1 d   //按一日剂量计算总量(此设置针对基本单位)
  .s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
  .s DoseQtyBase=..CalDose(unitUomId,DrgformRowid,DoseQty)
  .s DoseQty=DoseQtyBase*eqQty
  
  if (OrderFreqTimeDoseStr'="") {
	  s SameFreqDifferentDosesFlag="Y"
	  s DoseQtyStrLen=$l(OrderFreqTimeDoseStr,"!")
	  s DoseQty=0
	  for m=1:1:DoseQtyStrLen {
		  s OrderDoseQtyStr=$p(OrderFreqTimeDoseStr,"!",m)
		  s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
		  s DoseQtyBase=..CalDose(unitUomId,DrgformRowid,OrderDoseQty)
		  if ($p(PackFactor,"^",1)'=1) {
		  	  s DoseQty=DoseQty+(DoseQtyBase*eqQty)
		  }else{
			  s DoseQty=DoseQty+DoseQtyBase
		  }
	  }
  }
  s InsuConvFactor=..CalcInsuConvFactor(oeoriId)
  if (SameFreqDifferentDosesFlag="Y"){
  	 s durfactor=(qtyPackUom*InsuConvFactor)/DoseQty
  }else{
	  s durfactor=(qtyPackUom*InsuConvFactor)/(DoseQty*Freqfactor)
  }
  if (durfactor[".") s durfactor=$p(durfactor,".",1)+1
  s durfactor=durfactor\Weekfactor
  i durfactor'<1 {
	  i Freqdays'="" s durfactor=durfactor*Freqdays
	  s durfactor=$p(durfactor,".",1)
  }else{
	  i Freqdays'="" {
		  s durfactor=durfactor*Freqdays
	  	  s durfactor=$p(durfactor,".",1)
	  }
	  i durfactor<1 s durfactor=1
  }
  q durfactor
}

/// 得到实际发药量
/// w ##class(web.DHCDocOrderEntry).GetActiveDrugQty("37744||34")
ClassMethod GetActiveDrugQty(oeoriId As %String) As %String
{
	n (oeoriId)
	;k P1 s P1=0
	s Ord=$p(oeoriId,"||",1)
	s Sub=$p(oeoriId,"||",2)
    
    s ActiveDrugQty=0
    s arcimId=$p($g(^OEORD(Ord,"I",Sub,1)),"^",2)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s dspId=0,DSPQtyTot=0,DSPReturnQtyTot=0,QtyUOMDr=""
	for {
		s dspId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,dspId)) q:dspId=""
		s ConfirmQty=$p(^DHCOEDISQTY(dspId),"^",11)
		s QtyUOMDr=$p(^DHCOEDISQTY(dspId),"^",6)
		s Status=$p(^DHCOEDISQTY(dspId),"^",7)
		i (Status="C")||(Status="TC") s DSPQtyTot=DSPQtyTot+ConfirmQty
		i Status="R" s DSPReturnQtyTot=DSPReturnQtyTot+ConfirmQty
	}
	s ActiveDrugQty=DSPQtyTot-DSPReturnQtyTot
	i (packUomId'=QtyUOMDr)&&(QtyUOMDr'="") {
		;得到基本单位和计价单位的转换系数
		s factor=..GetItemConFac(arcimId)
		i +factor=0 s factor=1
		s ActiveDrugQty=ActiveDrugQty/factor
	}

	q ActiveDrugQty
}

ClassMethod CalcPackfac(oeoriId As %String) As %String
{
  //计算一个医嘱项的转换系数 Packfactor
  n (oeoriId)
  s Packfactor=1  
  q:oeoriId="" Packfactor
  s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
  s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
  q:arcimId="" Packfactor  
  s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
  q:+phcdfId<1 Packfactor
  s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14) //计价单位
  q:+packUomId=0 Packfactor
  s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
  s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)	//基本单位
  q:+baseUomId=0 Packfactor
  s factor=1
  i packUomId'="" d
  .i baseUomId'=packUomId d
  ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
  ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
  
  ;得到基本单位和计价单位的转换系数  add by gry
  ;s factor=..GetItemConFac(arcimId)

  s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3) //剂量单位
  q:+unitUomId=0 Packfactor
  s eqQty=1
  i baseUomId'=unitUomId d
  .s eqId=0,eqQty=1
  .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
  ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
  ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
  s phcdPack=$p($g(^PHCD(phcdId,"DF",phcdfSub,"DHC")),"^",1)
  
  ;b ;2
  q +$g(phcdPack)_"^"_factor_"^"_eqQty
}

/// 得到医保换算系数
ClassMethod CalcInsuConvFactor(oeoriId As %String) As %String
{
	n (oeoriId)
	s InsuConvFactor=1
	q:oeoriId="" InsuConvFactor
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	//频次 Freqfactor
	s ArcimRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s FreqRowid=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    s Freqfactor=1,Freqdays=""
    i FreqRowid'="" s Freqfactor=$p($g(^PHCFR(FreqRowid)),"^",2),Freqdays=$p($g(^PHCFR(FreqRowid)),"^",5)
    i Freqfactor="" s Freqfactor=1
	s PackFactor=..CalcPackfac(oeoriId)
	s factor=$p(PackFactor,"^",2) //基本单位和整包装单位转化系数
    s eqQty=$p(PackFactor,"^",3)  //基本单位和剂量单位转换系数
    ;w qtyPackUom_"^"_Freqfactor_"^"_DoseQty_"^"_PackFactor,!
    ;草药不换算
    s CNMedItemFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimRowid)
    if CNMedItemFlag=1 {
	    s InsuConvFactor=factor
    }else{
	    s InsuConvFactor=factor*eqQty
    }
    i InsuConvFactor=0 s InsuConvFactor=1
    
    q InsuConvFactor
}

/// 获取医嘱项目可以使用的医?
/// input ArcimID 医嘱项RowID
/// OutPut ""-空所有医院都可使用    Hosipital1^Hosipital2 返回可使用医院串以^分割
/// User:ARC_ItemHosp
/// w ##class(web.DHCDocOrderEntry).ArcimCanUserHosipital("9998||1")
ClassMethod ArcimCanUserHosipital(ArcimID As %String) As %String
{
	n (ArcimID)
	Q:ArcimID="" ""
	s RtnHosiStr=""
	s Sub=0
	f  s Sub=$O(^ARCIM(+ArcimID,$P(ArcimID,"||",2),"HOSP",Sub)) Q:Sub=""  d
	.s HosiDr=$P($G(^ARCIM(+ArcimID,$P(ArcimID,"||",2),"HOSP",Sub)),"^",1)
	.Q:HosiDr=""
	.if RtnHosiStr="" s RtnHosiStr=HosiDr
	.else  s RtnHosiStr=RtnHosiStr_"^"_HosiDr
	Q RtnHosiStr
}

/// 获取医嘱套可以使用的医院
/// input ArcosRowID 医嘱套RowID
/// OutPut ""-空所有医院都可使用    Hosipital1^Hosipital2 返回可使用医院串以^分割
/// User:ARC_OrdSetsHosp
/// w ##class(web.DHCDocOrderEntry).ArcimCanUserHosipital("9998||1")
ClassMethod ArcosCanUserHosipital(ArcosRowID As %String) As %String
{
	n (ArcosRowID)
	Q:ArcosRowID="" ""
	s RtnHosiStr=""
	s Sub=0
	f  s Sub=$O(^ARCOS(ArcosRowID,"HOSP",Sub)) Q:Sub=""  d
	.s HosiDr=$P($G(^ARCOS(ArcosRowID,"HOSP",Sub)),"^",1)
	.Q:HosiDr=""
	.if RtnHosiStr="" s RtnHosiStr=HosiDr
	.else  s RtnHosiStr=RtnHosiStr_"^"_HosiDr
	Q RtnHosiStr
}

/// 获取身份证号用于毒麻交验
ClassMethod FindPAPMIID(PatientID As %String) As %String
{
 
    Q:PatientID="" ""
    s PAPMIDVAnumber=$P($G(^PAPER(PatientID,"ALL")),"^",9)  ;身份证 证件类型
    if PAPMIDVAnumber=""  d
 	.s myCredTypeDesc=""
 	.s myCredTypeID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
 	.s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
 	.//if myCredTypeDesc["身份证"  d
 	.s PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
 	Q PAPMIDVAnumber
}

ClassMethod SetUserUnSaveData(AdmId As %String, UserId As %String, CtlocId As %String, UnSaveInc As %String, UnsaveData As %String) As %String
{
	q:(AdmId="")||(UserId="")||(CtlocId="")||(+UnSaveInc=0) 0
	i UnsaveData="" {
		k ^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,+UnSaveInc)
	}else{
		s ^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,+UnSaveInc)=UnsaveData //_"^"_+$h_"^"_..%SysTime()
		s ^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,+UnSaveInc,"SaveDateTime")=..%SysDate()_"^"_..%SysTime()
	}
	Q 0
}

ClassMethod GetUserUnSaveData(AdmId As %String, UserId As %String, CtlocId As %String, UnSaveInc As %String) As %String
{
	q:'$d(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,+UnSaveInc)) ""
	q $g(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,+UnSaveInc))
}

ClassMethod GetUserUnSaveCount(AdmId As %String, UserId As %String, CtlocId As %String) As %String
{
	s UnSaveCount=0
	q:'$d(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId)) UnSaveCount
	s Count=0
	for {
		s Count=$O(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,Count))
		q:Count=""
		i UnSaveCount<Count {
			s UnSaveCount=Count
		}else{
			s UnSaveCount=UnSaveCount+1
		}
	}
	//判断是否超出数据保留时长
	s Data=$g(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount))
	Q:'$d(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount,"SaveDateTime"))=1 UnSaveCount  // 兼容未存储缓存时间的历史数据
	//Q:$l(Data,"^")=1 UnSaveCount  // 兼容未存储缓存时间的历史数据
	s CurLogonHosp=$p(^CTLOC(CtlocId),"^",22)
	s UnSaveOrdDataKeepTime=##Class(web.DHCDocConfig).GetConfigNodeNew2("UnSaveOrdDataKeepTime",CurLogonHosp)
	if (UnSaveOrdDataKeepTime'=""){
		s Data=$g(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount))
		s SavedDateTime=$g(^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount,"SaveDateTime"))
		s SavedDate=$p(SavedDateTime,"^",1)
		s SavedTime=$p(SavedDateTime,"^",2)
		s DifferTime=(+$h-SavedDate-1)*24+((..%SysTime()+86400-SavedTime)/3600)
		i DifferTime>UnSaveOrdDataKeepTime {
			// 超出保留时长后清除缓存数据
			k ^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount)
			k ^DHCDOCUNSAVEDATANEW(AdmId,UserId,CtlocId,UnSaveCount,"SaveDateTime")
			s UnSaveCount=0
		}
	}
	q UnSaveCount
}

ClassMethod ClearUserUnSaveData(AdmId As %String, UserId As %String, CtlocId As %String)
{
	s UnSaveCount=..GetUserUnSaveCount(AdmId,UserId,CtlocId)
	for i=1:1:UnSaveCount{
		d ..SetUserUnSaveData(AdmId,UserId,CtlocId,i,"")
	}
	Q 0
}

/// creator:郭荣勇
/// date:2015-11-25
/// desc:得到出院条件,拷贝原护理组调用的web.PACDischCondit类下的同名Query
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpByLocationType","","I")
Query LookUpByLocationType(desc As %String, admType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,RowId:%String,Code:%String,DeadFlag:%String")
{
SELECT DISCON_Desc, DISCON_RowId, DISCON_Code,DISCON_DeadFlag
FROM SQLUser.PAC_DischCondit
WHERE (%ALPHAUP DISCON_Desc %STARTSWITH %ALPHAUP :desc)
AND (((DISCON_EpisodeType=:admType) OR (DISCON_EpisodeType IS NULL)) OR (:admType IS NULL))
AND (((DISCON_DateFrom <= CURRENT_DATE) OR (DISCON_DateFrom IS NULL)) AND ((DISCON_DateTo >= CURRENT_DATE) OR (DISCON_DateTo IS NULL)))
AND ((DISCON_DeadFlag IS NULL) OR (DISCON_DeadFlag ='InPatientAdmission') OR (DISCON_DeadFlag ='Waiting List') OR (DISCON_DeadFlag ='Appointment') OR (DISCON_DeadFlag ='Transfer'))
ORDER BY DISCON_Code
}

Query LookUpByLocationTypeNew(desc As %String, admType As %String) As %Query(CONTAINID = 0, ROWSPEC = "Description:%String,RowId:%String,Code:%String,DeadFlag:%String")
{
}

ClassMethod LookUpByLocationTypeNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpByLocationTypeNewExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpByLocationTypeNew","","I")
ClassMethod LookUpByLocationTypeNewExecute(ByRef QHandle As %Binary, desc As %String, admType As %String) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	Set index=1
	s RowId=""
	Set langid=..%LanguageID()
	s DATE=..%SysDate()
	for {
		s RowId=$O(^PAC("DISCON",RowId))
		q:RowId=""
		s Description=$P(^PAC("DISCON",RowId),"^",2)
		s Description=##class(User.PACDischCondit).GetTranByDesc("DISCONDesc",Description,langid)
		continue:Description=""
		continue:((desc'="")&&(Description'[desc))
		s Code=$P(^PAC("DISCON",RowId),"^",1)
		s DeadFlag=$P(^PAC("DISCON",RowId),"^",3)
		s EpisodeType=$P(^PAC("DISCON",RowId),"^",7)
		continue:((admType'="")&&(admType'=EpisodeType)&&(EpisodeType'=""))
		s DateFrom=$P(^PAC("DISCON",RowId),"^",4)
		s DateTo=$P(^PAC("DISCON",RowId),"^",5)
		continue:(DateFrom>DATE)&&(DateFrom'="")
		continue:(DATE>DateTo)&&(DateTo'="")
		continue:(DeadFlag'="")&&(DeadFlag'="InPatientAdmission")&&(DeadFlag'="Waiting List")&&(DeadFlag'="Appointment")&&(DeadFlag'="Transfer")
		Set ^CacheTemp(repid,index)=$lb(Description,RowId,Code,DeadFlag)
		Set index=index+1
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpByLocationTypeNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpByLocationTypeNewExecute ]
{
	New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetARCItemSubCatDesc(ARCIMRowid As %Library.String = "") As %String
{
   s SubCatID=""
   if ARCIMRowid'="" set SubCatID=$p(^ARCIM($p(ARCIMRowid,"||",1),$p(ARCIMRowid,"||",2),1),"^",10)
   q:SubCatID="" ""
   s ARCICDesc=$p($g(^ARC("IC",SubCatID)),"^",2)
   q ARCICDesc
}

ClassMethod GetARCItemCode(ARCIMRowid As %Library.String = "") As %String
{
	q:ARCIMRowid="" ""
	s ARCIMCode=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",1)
	q ARCIMCode
}

ClassMethod FindSameGenericNameOrderItem(PAADMRowid As %String, GenericName As %String) As %Boolean
{
	n (PAADMRowid,GenericName)
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	s today=..%SysDate()
	s findorderitem=0
	q:OrderRowid="" findorderitem
	//s PAAdmType=..GetPAAdmType(PAADMRowid)
	//s NotAlertRepeatItemCat=..%GetConfig("NotAlertRepeatItemCat")
	//i NotAlertRepeatItemCat'="" s NotAlertRepeatItemCat="^"_NotAlertRepeatItemCat_"^"
	
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")!(findorderitem=1)  d
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:(statcode'="V")
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.q:itemrowid="" 
	.s OneGenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(itemrowid)
	.Q:(OneGenericName'=GenericName)
	.//s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.//s ItemCatDR=$p(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
	.//Q:(ItemCatDR'="")&&(NotAlertRepeatItemCat[("^"_ItemCatDR_"^"))
	.//Q:((PAAdmType="I")!(PAAdmType="E"))&(sttdate'=today)
	.//Q:(itemrowid'=ARCIMRowid)
	.s findorderitem=1
	Q findorderitem
}

/// //------------------------------
Query LookUpItemNew(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "OrdInfo:%String,OrdDesc:%String:医嘱名称,子类:%String,价格:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String,ArcimDr:%String")
{
}

ClassMethod LookUpItemNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItemNew","pttzs",29,"14#","","","","",67,"","",3009,"","",185,"","")
/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItemNew","ptt",29,"","","","","",69,"","",1259,"","",188,"","")
ClassMethod LookUpItemNewExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	New repid, index
	///do ResetVariables
	s ^tempscl("sd")=Item_","_GroupID_","_Category_","_SubCategory_","_TYPE_","_OrderDepRowId_","_OrderPriorRowId_","_EpisodeID_","_BillingGrp_","_BillingSubGrp_","_UserRowId_","_OrdCatGrp_","_NonFormulary_","_Form_","_Strength_","_Route
	kill ^||tmpLookUpItemNew
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d obj.Execute(Item,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	Set repid=$I(^CacheTemp)
	Set index=1,Num=0
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		///OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,HIDDEN:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String
		s OrdName=obj.GetData(1)
		s OrdName=##class(web.DHCDocUtil).EvalJSON(OrdName)
		s OrdInfo=OrdName
		For col = 2:1:columns {
			s tmpOrdName=##class(web.DHCDocUtil).EvalJSON(obj.GetData(col))
			 i col="15" {
				 s tmpOrdName=$replace(tmpOrdName,$c(14),"")
				 s tmpOrdName=$replace(tmpOrdName,$c(12),"")
			 }
			 
	         s OrdInfo=OrdInfo_"^"_tmpOrdName
	    }
	    
		Set Data=$lb(OrdInfo,OrdName,obj.GetData(18),obj.GetData(19),obj.GetData(21),obj.GetData(27),obj.GetData(28),obj.GetData(29),obj.GetData(31),obj.GetData(32),+obj.GetData(2))
		//i Data'="" s ^tempscl("OrdInfo1",Data)=1
		do RecordSortTmpDataNew
	}
	
	s RecordCount=""
	for {
		s RecordCount=$o(^||tmpLookUpItemNew(RecordCount),-1) Quit:RecordCount=""
		s Num=0
		for {
			s Num=$o(^||tmpLookUpItemNew(RecordCount,Num)) Quit:Num=""
			s id=0
			for {
				s id=$o(^||tmpLookUpItemNew(RecordCount,Num,id)) Quit:id=""
				s Data=^||tmpLookUpItemNew(RecordCount,Num,id)
				;s ^tmpLookUpItemNewlog(RecordCount,Num,id)=Data
				do OutputRowItemNew
			}
		}
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
RecordSortTmpDataNew
	Set Num=Num+1
	Set OutRecordId=obj.GetData(2)
	if OutRecordId["||"{
		s TableName="User.ARCItmMast"
	}else{
		s TableName="User.ARCOrdSets"	
	}
	Set RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,OutRecordId,UserRowId,"U")
	Set ^||tmpLookUpItemNew(RecordCount,Num,OutRecordId)=Data
	quit
OutputRowItemNew
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod LookUpItemNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemNewExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断长期医嘱当天及以后的执行记录是否存在未停止执行的执行记录
/// 1 存在 0 不存在
ClassMethod CheckCurOrdExecStatus(OEORIRowId As %String) As %String
{
	s ExistUnStopExecFlag=0
	s OEOREExStDate=..%SysDate()-1
	f  s OEOREExStDate=$o(^OEORDi(0,"OrdItem",+OEORIRowId,$p(OEORIRowId,"||",2),OEOREExStDate)) q:(OEOREExStDate="")||(ExistUnStopExecFlag=1)  d
	.s OEOREChildsub=0
	.f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",+OEORIRowId,$p(OEORIRowId,"||",2),OEOREExStDate,OEOREChildsub)) q:(OEOREChildsub="")||(ExistUnStopExecFlag=1)  d
	..s OEOREOrderStatusDR=$p(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),"X",OEOREChildsub),"^",16)
	..s STATCode=""
	..i OEOREOrderStatusDR'="" s STATCode=$p(^OEC("STAT",OEOREOrderStatusDR),"^",1)
	..q:STATCode="D"
	..s ExistUnStopExecFlag=1
	q ExistUnStopExecFlag
}

/// 得到是否需要弹出检查资源预约界面
ClassMethod GetExamItemBook(OrdItemStr As %String) As %String
{
	s ExamItemBookFlag=0
	f k=1:1:$l(OrdItemStr,"^")-1 {
		s newOrdIdDR=$p($p(OrdItemStr,"^",k),"*",2)
		i newOrdIdDR="" continue
     	s OpenBookWinFlag=##Class(web.DHCAPPInterface).IsOpenBookWin(newOrdIdDR)
		i OpenBookWinFlag="Y" s ExamItemBookFlag=1 quit
    }
    
    Q ExamItemBookFlag
}

ClassMethod GetExamItemBookUrl(OrdItemStr As %String, EpisodeID As %String, HospId As %String) As %String
{
	s Url=""
	f k=1:1:$l(OrdItemStr,"^")-1 {
		s newOrdIdDR=$p($p(OrdItemStr,"^",k),"*",2)
		i newOrdIdDR="" continue
     	s ArReqID=$o(^DHCAPREP(0,"OrdItem",newOrdIdDR,""))
		if (ArReqID'=""){
			s Url=##Class(DHCDoc.DHCApp.BasicConfig).SentAppionmentAd(EpisodeID, ArReqID, HospId)
		}
		q:Url'=""
    }
    
    Q Url
}

ClassMethod SaveOrderTimeLog(UserId As %String, PageTimeLogData As %String) As %String
{
	kill ^DHCOrderTimeLog(UserId)
	for i=1:1:$l(PageTimeLogData,$c(10,13)) {
		s oneItem=$p(PageTimeLogData,$c(10,13),i)
		s Index=$i(^DHCOrderTimeLog(UserId))
		s ^DHCOrderTimeLog(UserId,Index)=oneItem
	}
	q 0
}

/// //------------------------------
Query LookUpARCOS(ARCOS As %String, EditAuthFlag = "") As %Query(CONTAINID = 0, ROWSPEC = "OrdInfo:%String,ARCOSName:%String:医嘱名称,ARCOSSubCate:%String:子类,Price:%String:价格,BillUom:%String:计价单位,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String,ArcimDr:%String")
{
}

ClassMethod LookUpARCOSClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpARCOSExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItemNew","pttzs",29,"14#","","","","",67,"","",3009,"","",185,"","")
/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpARCOS","zkcs")
ClassMethod LookUpARCOSExecute(ByRef QHandle As %Binary, ARCOS As %String = "", EditAuthFlag = "") As %Status
{
	New repid, index
	///do ResetVariables
	///"zkcs","134","15","","","","1","","","","79","","","6","",""
	
	s GroupID=""
	s Category=$o(^OEC("ORCAT",0,"Desc","医嘱套",0))
	s SubCategory=""
	s TYPE=""
	s OrderDepRowId=""
	s OrderPriorRowId=""
	s EpisodeID=""
	s BillingGrp=""
	s BillingSubGrp=""
	s UserRowId=""
	s OrdCatGrp=""
	s NonFormulary=""
	s Form="" 
	s Strength=""
	s Route=""
	s UserRowId=%session.Get("LOGON.USERID")
	s GroupID=%session.Get("LOGON.GROUPID")
	s Form=%session.Get("LOGON.CTLOCID")
	s HospARCOSAuthority=+##class(DHCDoc.Order.Sets).GetHospAuth()
	s LocARCOSAuthority=+##class(DHCDoc.Order.Sets).GetLocAuth()
	//s UserRowId=79
	//s GroupID=134
	//s Form=6
	s ^zhangkui("LookUpARCOSExecute")=ARCOS_","_GroupID_","_Category_","_SubCategory_","_TYPE_","_OrderDepRowId_","_OrderPriorRowId_","_EpisodeID_","_BillingGrp_","_BillingSubGrp_","_UserRowId_","_OrdCatGrp_","_NonFormulary_","_Form_","_Strength_","_Route
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d obj.Execute(ARCOS,GroupID,Category,SubCategory,TYPE,OrderDepRowId,OrderPriorRowId,EpisodeID,BillingGrp,BillingSubGrp,UserRowId,OrdCatGrp,NonFormulary,Form,Strength,Route)
	Set repid=$I(^CacheTemp)
	Set index=1
	Set columns = obj.GetColumnCount()
	While (obj.Next()) {
		///OrdInfo:%String,医嘱名称:%String,子类:%String,价格:%String,HIDDEN:%String,计价单位:%String,医保类别:%String,自付比例:%String,接收科室:%String,支付限额:%String,控制类型:%String
		if (EditAuthFlag){
			s ARCOSRowid=obj.GetData(2)
			s FavType=##class(web.DHCUserFavItems).GetARCOSType(ARCOSRowid)
			continue:'LocARCOSAuthority&&(FavType="Loc")
			continue:'HospARCOSAuthority&&(FavType="Hosp")
		}
		s OrdName=obj.GetData(1)
		s OrdName=##class(web.DHCDocUtil).EvalJSON(OrdName)
		s OrdInfo=OrdName
		For col = 2:1:columns {
			s tmpOrdName=##class(web.DHCDocUtil).EvalJSON(obj.GetData(col))
			 i col="15" {
				 s tmpOrdName=$replace(tmpOrdName,$c(14),"")
				 s tmpOrdName=$replace(tmpOrdName,$c(12),"")
			 }
			 
	         s OrdInfo=OrdInfo_"^"_tmpOrdName
	    }
		
		/*s Name15=$replace(obj.GetData(15),$c(14),"")
		s Name15=$replace(Name15,$c(12),"")
		s Name15=##class(web.DHCDocUtil).EvalJSON(Name15)
		s Name9=obj.GetData(9)
		s Name9=##class(web.DHCDocUtil).EvalJSON(Name9)
		s $p(OrdInfo,"^",9)=Name9
		s $p(OrdInfo,"^",15)=Name15*/
		//s OrdInfo=OrdName_"^"_obj.GetData(2)_"^"_obj.GetData(3)_"^"_obj.GetData(4)_"^"_obj.GetData(5)_"^"_obj.GetData(6)_"^"_obj.GetData(7)_"^"_obj.GetData(8)_"^"_Name9_"^"_obj.GetData(10)_"^"_obj.GetData(11)_"^"_obj.GetData(12)_"^"_obj.GetData(13)_"^"_obj.GetData(14)_"^"_Name15_"^"_obj.GetData(16)_"^"_obj.GetData(17)_"^"_obj.GetData(18)_"^"_obj.GetData(19)_"^"_obj.GetData(20)_"^"_obj.GetData(21)_"^"_obj.GetData(22)_"^"_obj.GetData(23)_"^"_obj.GetData(24)_"^"_obj.GetData(25)_"^"_obj.GetData(26)_"^"_obj.GetData(27)_"^"_obj.GetData(28)_"^"_obj.GetData(29)_"^"_obj.GetData(30)_"^"_obj.GetData(31)_"^"_obj.GetData(32)
		s Data=$lb(OrdInfo,OrdName,obj.GetData(18),obj.GetData(19),obj.GetData(21),obj.GetData(27),obj.GetData(28),obj.GetData(29),obj.GetData(31),obj.GetData(32),+obj.GetData(2))
		//i Data'="" s ^tempscl("OrdInfo1",Data)=1
		d OutputRowItemARCOS
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemARCOS
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod LookUpARCOSFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpARCOSExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckSameItem(EpisodeID, ArcitmID, CurLogonHosp As %String = "") As %String
{
	Q:(EpisodeID="")!(ArcitmID="") ""
	s NotAlertRepeatItemCat=..%GetConfig("NotAlertRepeatItemCat",CurLogonHosp)
	i NotAlertRepeatItemCat'="" s NotAlertRepeatItemCat="^"_NotAlertRepeatItemCat_"^"
	s CurrentDate=..%SysDate()
	s PAPMI=+^PAADM(EpisodeID)
	s OrdDep=""
	f AdmType="O","E" d
	.s AdmId=0
	.f  s AdmId=$O(^PAPERdr(PAPMI,"ADM",AdmType,AdmId)) q:(AdmId="")!(OrdDep'="")  d
	..q:'$D(^PAADMi("PAADM_AdmDate",CurrentDate,AdmId))
	..q:AdmId=EpisodeID
	..s ord=$O(^OEORD(0,"Adm",AdmId,0))
	..q:ord=""
	..s SttDat=0
	..f  s SttDat=$O(^OEORDi(0,"ARCIM",ord,ArcitmID,SttDat)) q:(SttDat="")!(OrdDep'="")  d
	...s sub=0
	...f  s sub=$O(^OEORDi(0,"ARCIM",ord,ArcitmID,SttDat,sub)) q:(sub="")!(OrdDep'="")  d
	....s StatusDr=$P(^OEORD(ord,"I",sub,1),"^",13)
	....s StatusCode=$P($G(^OEC("OSTAT",+StatusDr)),"^",1)
	....q:(StatusCode'="E")&(StatusCode'="V")
	....s ItemCatDR=$p(^ARCIM(+ArcitmID,$p(ArcitmID,"||",2),1),"^",10)
	....Q:(ItemCatDR'="")&&(NotAlertRepeatItemCat[("^"_ItemCatDR_"^"))
	....s OrdDepDr=$P(^OEORD(ord,"I",sub,1),"^",3)
	....s OrdDep=$P(^CTLOC(OrdDepDr),"^",2)
	....s:OrdDep["-" OrdDep=$P(OrdDep,"-",2)
	Q OrdDep
}

/// / w ##class(web.DHCDocOrderEntry).GetSameOrdDoseQty("688","1043||1")
ClassMethod GetSameOrdDoseQty(PAADMRowid As %String, ARCIMRowid As %String) As %Boolean
{
	n (PAADMRowid,ARCIMRowid)
	s SameOrdDoseQtySum=0
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	q:OrderRowid="" SameOrdDoseQtySum
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	s PAAdmType=..GetPAAdmType(PAADMRowid)
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.Q:'$d(^OEORD(OrderRowid,"I",itemsub,1))
	.s itemrowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.Q:(itemrowid'=ARCIMRowid)
	.s ARCIMItemCatDR=$P(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
	.s ItemOrderType=$P(^ARC("IC",ARCIMItemCatDR),"^",7)
	.Q:ItemOrderType'="R"
	.s OEORIPriorityDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",8)
	.s OECPRCode=$p(^OECPR(OEORIPriorityDR),"^",1)
	.s OECPRCode=$$ALPHAUP^SSUTIL4(OECPRCode)
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:(statcode'="V")&&(statcode'="E")
	.s OrderDoseUOMRowid=$P($G(^OEORD(OrderRowid,"I",itemsub,2)),"^",3) ;OEORI_Unit_DR
	.s OrderDoseQty=$P($G(^OEORD(OrderRowid,"I",itemsub,2)),"^",1) ;OEORI_DoseQty
	.Q:(+OrderDoseQty=0)||(OrderDoseUOMRowid="")
	.s EqDoseQty=..CalEqDose(OrderDoseUOMRowid,DrgformRowid,OrderDoseQty,"BaseUom")
	.s FreqRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,2)),"^",4)
    .s Freqfactor=1
    .i FreqRowid'="" s Freqfactor=$p($g(^PHCFR(FreqRowid)),"^",2)
	.s SameOrdDoseQtySum=SameOrdDoseQtySum+(EqDoseQty*Freqfactor)
	Q SameOrdDoseQtySum
	/*.s Count=0
	.s OEOREChildsub=0
	.f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",OrderRowid,itemsub,CheckDate,OEOREChildsub)) q:OEOREChildsub=""  d
	..s OEOREOrderStatusDR=$p($g(^OEORD(OrderRowid,"I",itemsub,"X",OEOREChildsub)),"^",16)
	..s STATCode=""
	..i OEOREOrderStatusDR'="" s STATCode=$p($g(^OEC("STAT",OEOREOrderStatusDR)),"^",1)
	..Q:(STATCode="C")||(STATCode="D")
	..s Count=Count+1*/
}

/// / w ##class(web.DHCDocOrderEntry).GetSameOrdDoseQtyPerDay("688","1043||1")
ClassMethod GetSameOrdDoseQtyPerDay(PAADMRowid As %String, ARCIMRowid As %String) As %Boolean
{
	n (PAADMRowid,ARCIMRowid)
	s SameOrdDoseQtySum=0
	s OrderRowid=..GetPAADMOrderRowid(PAADMRowid)
	q:OrderRowid="" SameOrdDoseQtySum
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	s PAAdmType=..GetPAAdmType(PAADMRowid)
	s itemsub=0
	for {
		s itemsub=$O(^OEORDi(0,"DateARCIM",+$H,ARCIMRowid,OrderRowid,itemsub))
		q:(itemsub="")
		s PriorRowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",8)
		s PriorCode=$P($G(^OECPR(+PriorRowid)),"^",1)
		continue:PriorCode="ONE"	;取药医嘱不判断
		s exesub=0
		for {
			s exesub=$O(^OEORDi(0,"DateARCIM",+$H,ARCIMRowid,OrderRowid,itemsub,exesub))
			q:(exesub="")
			s StatusDR=$p(^OEORD(OrderRowid,"I",itemsub,"X",exesub),"^",16)
			s STATCode=""
			i StatusDR'="" s STATCode=$p(^OEC("STAT",StatusDR),"^",1)
			continue:STATCode="D"
			s QtyAdmin=$p($g(^OEORD(OrderRowid,"I",itemsub,"X",exesub)),"^",4)
			s QtyUom=$P($G(^OEORD(OrderRowid,"I",itemsub,2)),"^",3) 
			s EqDoseQty=##class(web.DHCDocOrderEntry).CalEqDose(QtyUom,DrgformRowid,QtyAdmin,"BaseUom")
			s SameOrdDoseQtySum=SameOrdDoseQtySum+EqDoseQty
		}
	}
	Q SameOrdDoseQtySum
}

/// modify:guorongyong
/// date:20170908
/// desc:药品：得到医嘱项目和库存项目 门/急诊转换系数(与药学项基本单位转换)
ClassMethod GetOPConFac(ARCIMRowid As %String, INCIRowid As %String, AdmType As %String = "", AdmHospitalId As %String = "") As %String
{
	s ConFac=""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	i DrgformRowid'="" {
		s PHCDRowid=$P(DrgformRowid,"||",1)
	  	s ChildSub=$P(DrgformRowid,"||",2)
		;药学项基本单位
		s BaseuomId=##class(web.DHCDocOrderCommon).GetPhDispUom(ARCIMRowid,AdmType,AdmHospitalId)
		i BaseuomId="" s BaseuomId=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		;库存项门诊最小发药单位
		s UOMOutPatDR=$p($g(^INCI(INCIRowid,1)),"^",12)    
		Q:(BaseuomId=UOMOutPatDR)&&(BaseuomId'="") 1
		s ConFacID="" s ConFacID=$O(^CT("CTCF",0,"UOM",UOMOutPatDR,BaseuomId,ConFacID))
		i ConFacID="" s ConFac=0
		e  s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	}
	i +ConFac=0  s ConFac=1
	q ConFac
}

/// modify:guorongyong
/// date:20170908
/// desc:药品：得到医嘱项目和库存项目 住院或留观诊转换系数(与药学项基本单位转换)
ClassMethod GetIPConFac(ARCIMRowid As %String, INCIRowid As %String, AdmType As %String = "", AdmHospitalId As %String = "") As %String
{
	s ^tmpgry("GetIPConFac")=ARCIMRowid_","_INCIRowid
	s ConFac=""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	i DrgformRowid'="" {
		s PHCDRowid=$P(DrgformRowid,"||",1)
	  	s ChildSub=$P(DrgformRowid,"||",2)
		;药学项基本单位
		s BaseuomId=##class(web.DHCDocOrderCommon).GetPhDispUom(ARCIMRowid,AdmType,AdmHospitalId)
		i BaseuomId="" s BaseuomId=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		;库存项住院最小发药单位
		s UOMOutPatDR=$p($g(^INCI(INCIRowid,1)),"^",13)    
		Q:(BaseuomId=UOMOutPatDR)&&(BaseuomId'="") 1
		s ConFacID="" s ConFacID=$O(^CT("CTCF",0,"UOM",UOMOutPatDR,BaseuomId,ConFacID))
		i ConFacID="" s ConFac=0
		e  s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
	}
	i +ConFac=0  s ConFac=1
	q ConFac
}

/// w ##class(web.DHCDocOrderEntry).CheckOrderStartDateByZKAdm(396,"20/03/2019 09:46:54","25/02/2019 09:46:54",95)
ClassMethod CheckOrderStartDateByZKAdm(Adm As %String, OrderStartDateStr As %String, OrderDateStr As %String, CTLOC As %String) As %String
{
	s ^tmpscl("CheckOrderStartDateByZKAdm")=Adm_","_OrderStartDateStr_","_OrderDateStr_","_CTLOC
	q:Adm="" ""
	s ret=0
	s StartDate=$p(OrderStartDateStr," ",1)
	s StartTime=$p(OrderStartDateStr," ",2)
	s OrderDate=$p(OrderDateStr," ",1)
	s OrderTime=$p(OrderDateStr," ",2)
	if StartDate'="" s StartDate=$zdh(StartDate,4)
	if StartTime'="" s StartTime=..%ZTH(StartTime)
	if OrderDate'="" s OrderDate=$zdh(OrderDate,4)
	if OrderTime'="" s OrderTime=..%ZTH(OrderTime)
	s WardID=$p(^PAADM(Adm),"^",70)
	s ZKDateTime=##class(Nur.Interface.OutSide.Patient).getTransDatelast(Adm,WardID)

	if ZKDateTime="" q 0
	s ZKDate=$p(ZKDateTime,"^",1)
	if ZKDate["-" s ZKDate=$zdh(ZKDate,3)
	s ZKTime=$p(ZKDateTime,"^",2)
	if ZKTime'="" s ZKTime=..%ZTH(ZKTime)
	if StartDate<ZKDate q "-1^医嘱开始时间不能早于入院/转科时间"_..%ZD(ZKDate)_" "_..%ZT(ZKTime)
	if (StartDate=ZKDate)&&(StartTime<ZKTime) q "-1^医嘱开始时间不能早于入院/转科时间"_..%ZD(ZKDate)_" "_..%ZT(ZKTime)
	
	if OrderDate<ZKDate q "-2^开医嘱时间不能早于入院/转科时间"_..%ZD(ZKDate)_" "_..%ZT(ZKTime)
	if (OrderDate=ZKDate)&&(OrderTime<ZKTime) q "-2^开医嘱时间不能早于入院/转科时间"_..%ZD(ZKDate)_" "_..%ZT(ZKTime)
	q ret
}

/// //------------------------------
Query GetArcimNotesList(ArcimRowIdStr As %String) As %Query(CONTAINID = 0, ROWSPEC = "ArcimId:%String,ArcimDesc:%String:医嘱名称,OrderMsg:%String:子类")
{
}

ClassMethod GetArcimNotesListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetArcimNotesListExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpARCOS","zkcs")
ClassMethod GetArcimNotesListExecute(ByRef QHandle As %Binary, ArcimRowIdStr As %String = "") As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	Set index=1
	Set langid=..%LanguageID()
	if (ArcimRowIdStr="") Q $$$OK
	kill ^TempArcimRowIdStr($j)
	for i=1:1:$l(ArcimRowIdStr,"^"){
		s ArcimId=$p(ArcimRowIdStr,"^",i)
		continue:ArcimId=""
		continue:$d(^TempArcimRowIdStr($j,ArcimId))
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		s OrderMsg=##class(web.DHCDocOrderCommon).GetARCIMOrderMsg(ArcimId)
		continue:OrderMsg=""
		s ^TempArcimRowIdStr($j,ArcimId)=1
		d OutputRowArcimNotesList
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowArcimNotesList
	Set ^CacheTemp(repid,index)=$lb(ArcimId,ArcimDesc,OrderMsg)
	Set index=index+1
	quit
}

ClassMethod GetArcimNotesListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcimNotesListExecute ]
{
	New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SetUserCMUnSaveData(Name As %String, Value As %String)
{
	 set ^DHCDOCCMUNSAVEDATANEW(Name)=Value
	 q 0
}

ClassMethod GetUserCMUnSaveData(Name As %String) As %String
{
	 q $Get(^DHCDOCCMUNSAVEDATANEW(Name))
}

/// 验证用户是否有药品管制分类权限
ClassMethod CheckDrgFormPoisonAuthorize(ARCIMRowid As %String, UserRowId As %String) As %String
{
	s CareProvDR=$P(^SSU("SSUSR",UserRowId),"^",14)
	Q:CareProvDR="" 1
	s DrgFormPoison=..GetDrgFormPoison(ARCIMRowid)
	Q:DrgFormPoison="" 1
	
	s DrgFormPoisonCode=$p($g(^PHCPO(DrgFormPoison)),"^",1)
	s PHCPODesc=$p($g(^PHCPO(DrgFormPoison)),"^",2)
	Q:(PHCPODesc["抗菌") 1
	Q:(PHCPODesc["辅助用药") 1
	/*if (" DX MZ J1 J2 ")'[(" "_DrgFormPoisonCode_" "){
		q 1
	}*/
	s CPPChildsub=$o(^CTPCP(+CareProvDR,"CPP",0,"Poison",DrgFormPoison,""))
	Q:CPPChildsub="" 0
	Q 1
}

ClassMethod GetDischargeMethod(langid = "")
{
 	s:langid="" langid=..%LanguageID()
	s CurDate=..%SysDate()
	s obj=##class(DHCDoc.Util.QueryToJSON).%New("web.DHCBL.CT.DischargeMethod","GetList","","","")
	s rows=obj.ToArray()
	for i=rows.%Size():-1:1{
		s row=rows.%Get(i-1)
		s DateFrom=..%ZDH(row.CTDMDateFrom)
		s DateTo=..%ZDH(row.CTDMDateTo)
		if (DateFrom="")||(DateFrom>CurDate)||((DateTo'="")&&(DateTo<=CurDate)){
			d rows.%Remove(i-1)
			continue
		}
		s row.CTDMDesc=##class(CT.BDP.CT.DischargeMethod).GetTranByDesc("CTDMDesc",row.CTDMDesc,langid)
	}
	Q rows
}

/// Desc: 校验患者是否符合医嘱项的性别年龄限制
/// Input: ARCIMRowid:医嘱项ID、AdmID:就诊ID
/// Output: 0/1:有效/无效
/// w ##class(web.DHCDocOrderEntry).ValARCItemAgeLimit("1||1","39",.a)
ClassMethod ValARCItemAgeLimit(ARCIMRowid As %String, AdmID As %String, ByRef Msg As %String = "") As %String
{
	n (ARCIMRowid,AdmID,Msg)
	s Active=0
	Q:+AdmID=0 Active
	s PatID=$p(^PAADM(AdmID),"^",1)
	s SexID=$p($g(^PAPER(PatID,"ALL")),"^",7)
	
	s ArcimID=$p(ARCIMRowid,"||",1)
	s SubID=$p(ARCIMRowid,"||",2)
	s Child=""
	for {
		s Child=$o(^ARCIM(ArcimID,SubID,"AGE",Child))
		Q:(Child="")||(Active'=0)
		s ArcimAgeInfo=$g(^ARCIM(ArcimID,SubID,"AGE",Child))
		s LSexID=$p(ArcimAgeInfo,"^",1)
		Continue:SexID'=LSexID
		s LAgeF=$p(ArcimAgeInfo,"^",2)
		s LAgeT=$p(ArcimAgeInfo,"^",3)
		s LAgeFType=$p(ArcimAgeInfo,"^",4)
		s LAgeTType=$p(ArcimAgeInfo,"^",5)
		s LimitStr=..CheckPatAgeLimit(PatID,LAgeF,LAgeT,LAgeFType,LAgeTType)
		s Active=$p(LimitStr,"^",1)
		s:Active=1 Msg=$p(LimitStr,"^",2)
	}
	Q Active
}

/// Desc: 校验患者的年龄是否在限制年龄范围内(默认按照岁数判断)
/// Input: PatID:患者ID、AgeF:开始年龄、AgeT:截至年龄、
/// 	    AgeFType:开始年龄类型(Y/M/D:岁/月/日)、AgeTType:截至年龄类型
/// Output: 0/1^限制描述:有效/无效^描述
/// w ##class(web.DHCDocOrderEntry).CheckPatAgeLimit(2,"","")
ClassMethod CheckPatAgeLimit(PatID, AgeF, AgeT, AgeFType = "Y", AgeTType = "Y")
{
	n (PatID,AgeF,AgeT,AgeFType,AgeTType)
	s PatDob=$p($g(^PAPER(PatID,"ALL")),"^",6)
	Q:PatDob="" "0^缺少出生日期信息"
	s:AgeFType="" AgeFType="Y"			
	s:AgeTType="" AgeTType="Y"
	
	;因为基础数据可维护为40月到2岁，所以此处计算患者实际年月日
	s PatDobStr=$$CalAge^at182(PatDob,+$H,"","","")
	s AgeYear=+$p(PatDobStr,"|",12)						;实际岁数
	s AgeMonth=AgeYear*12+$p(PatDobStr,"|",13)			;实际月数
	s AgeDay=$SYSTEM.SQL.DATEDIFF("dd",PatDob,+$H)		;实际天数
	
	s (LimitStr,AgeFromDesc,AgeToDesc)=""
	if (AgeF'=""){
		s Age=$case(AgeFType,"D":AgeDay,"M":AgeMonth,"Y":AgeYear,:"")
		s AgeDesc=$case(AgeFType,"D":"天","M":"月","Y":"岁")
		s AgeFromDesc=AgeF_AgeDesc
		if Age<AgeF s LimitStr="限制年龄是:"_AgeFromDesc_"以上"
	}
	if (AgeT'=""){
		s Age=$case(AgeTType,"D":AgeDay,"M":AgeMonth,"Y":AgeYear,:"")
		s AgeDesc=$case(AgeTType,"D":"天","M":"月","Y":"岁")
		s AgeToDesc=AgeT_AgeDesc
		if Age>AgeT s LimitStr="限制年龄是:"_AgeToDesc_"以下"
	}
	if (LimitStr'="")&&(AgeFromDesc'="")&&(AgeToDesc'="") s LimitStr="限制年龄是:"_AgeFromDesc_" 到 "_AgeToDesc
	Q:LimitStr'="" "1^"_LimitStr
	Q "0^有效"
}

}
