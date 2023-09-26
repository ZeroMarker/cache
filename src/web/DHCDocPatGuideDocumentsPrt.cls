Class web.DHCDocPatGuideDocumentsPrt Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetOrderItems(EpisodeID As %String, IsPhamacy As %String, IncludePrinted As %String = "", IncludePaid As %String = "", IncludeOtherDoc As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,Priority:%String,Status:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String,OrderType:%String,Spec:%String,UserAddName:%String,LabEpisodeNo:%String,orcat:%String,orcatdesc:%String,RecDepAdress:%String,DepProcNotes:%String,StatusCode:%String,ExecuteTime:%String,Spec1:%String,ProcessingNotes:%String,CTNationName:%String,SkinTest:%String")
{
}

ClassMethod GetOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, IsPhamacy As %String, IncludePrinted As %String = "", IncludePaid As %String = "", IncludeOtherDoc As %String = "") As %Status
{
	s ^RP("EpisodeID")=EpisodeID_"^"_IsPhamacy_"^"_IncludePrinted_"^"_IncludePaid_"^"_IncludeOtherDoc
 // d ##class(%ResultSet).RunQuery("web.DHCDocPatGuideDocumentsPrt","GetOrderItems",364,"","on","","")
 s Hospital=..%GetConfig("CurrentHospital")
 i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
 e  s HospitalCode=""
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo="",Spec1="",RecDepRowid=""
 s UserDR=%session.Get("LOGON.USERID")
 set RowCount=0
 s OrderType="L"
 s IsPhamacy=0
 s ShowSkinOrder=0
 s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
 if HospitalCode="SCSFY" d
 .s ShowSkinOrder=1
 ;if IsPhamDepProcNotesacy='1' s OrderType='R'
 i EpisodeID'="" d
 .&sql(DECLARE EmpCursor CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'yyyy-mm-dd'),
	    OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,OEORI_Itemstat_dr->OSTAT_Code,
	    OEORI_QtyPackUOM,
	    OEORI_RecDep_DR->CTLOC_Desc,$LIST(OEORI_RecDep_DR->ctloc_address,1),OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,
	    OEORI_BBExtCode,OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
	    OEORI_UserAdd->SSUSR_Name,OEORI_LabEpisodeNo,OEORI_DepProcNotes,OEORI_ItmMast_DR->ARCIM_ProcessingNotes,OEORI_AdministerSkinTest,OEORI_RecDep_DR
 INTO :Rowid,:ArcimRowid,:OrderName,:StartDate,:Priority,:Status,:StatusCode,:PackQty,:RecDep,:RecDepAdress,
 :Billed,:ARCIMRowid,:SttDate,:BillType,:OrderType,:OrderCatType,:UserAddName,:LabEpisodeNo,
 :DepProcNotes,:ProcessingNotes,:SkinTest,:RecDepRowid
 From SQLUser.OE_OrdItem 
 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and (OEORI_ItemStat_DR->OSTAT_Code='V' or OEORI_ItemStat_DR->OSTAT_Code='E')	
 Order By OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR desc)
 .&sql(OPEN EmpCursor)
 .for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
	..s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	..s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	..s orcatdesc=""  
    ..i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)  
    ..;q:$g(^DHCDocConfig("ItemCat",subcat))'=1 //踢出不需要打印的子类，走走导诊单维护配置
    ..q:$g(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",subcat))'=1
    ..s OrderBilled=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),3)),"^",5) 	
    ..q:(IncludePaid'="on")&&(OrderBilled'="TB") ;&&(OrderBilled'="B")	
    ..s UserAdd=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),7)),"^",1)	
    ..q:(IncludeOtherDoc'="on")&&(UserAdd'=UserDR)	
    ..s OrdPrtFlag=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),"DHC")),"^",32)
    ..q:(IncludePrinted'="on")&&(OrdPrtFlag=1)
    ..i $g(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",RecDepRowid))'="" s RecDepAdress=$g(^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",RecDepRowid)) //科室位置 走导诊单维护配置
	..s RecDepDesc=$p(RecDep,"-",2)
	..i RecDepDesc'="" s RecDep=RecDepDesc
	..s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(Rowid)
	..s PackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	..i BillingUOMDR'="" d
	...i PackQty'="" d
	....i PackQty<1 s PackQty="0"_$number(PackQty)
	....s ExpStr=Rowid_"^"_""_"^"_EpisodeID_"^"_RecDepRowid
	....s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	..else  d
	...s ExpStr=PAADMRegConDisDR_"^"_Rowid_"^"_""_"^"_EpisodeID_"^"_RecDepRowid
	...s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType,InsType,ARCIMRowid,SttDate,PriorRowid, InstrRowid, LinkTo, OEPrice,"",ExpStr)
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s ^yjy(222)= EpisodeID _"^"_IsPhamacy
	..s Sum=PackQty*Price
	..i BillType="" s BillTypeDesc="自费"
	..e  s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
	..s DoseqtySum=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),1)),"^",12)
	..s DepProcNotes=$G(^OEORD(+Rowid,"I",$p(Rowid,"||",2),"DEP",1))
	..;i DepProcNotesRowid'="" s DepProcNotes=^OEORD(+Rowid,"I",$p(Rowid,"||",2),"DEP",DepProcNotesRowid)
	..s PackQty=DoseqtySum
	..s PackUOM=$p(PackUOM,"(",1)
	..s Sum=PackQty*Price
	..s Spec=..GetLabSpec(Rowid)
	..s Spec1=Spec
	..s ARCItemExcID=0,TSCode=0
	..f  s ARCItemExcID=$O(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID)) q:ARCItemExcID=""  d
	...s DateFrom=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",1)
	...s DateTo=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",2)
	...Q:(DateTo<(+$H))&&(DateTo'="")
	...s TSCode=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",4)
	..s CTNationName=""
	..i $D(^|"LabData"|TTAB("TS",TSCode)) s CTNationName=$P(^|"LabData"|TTAB("TS",TSCode),"\",33)
	..;i Spec'="" s Spec1=$p($g(Spec),"-",2)
	..;s ExecuteTime=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"RB",1))
	..;s ExecuteTime=$P(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9),"^",14)
	..s ExecuteTime=""
	..s OrderStr=##class(web.DHCDocOrderCommon).GetOrderMesage(Rowid)
	..s Sum=$P(OrderStr,"^",11)
	..s Price=$P(OrderStr,"^",8)
	..s PackQty=$P(OrderStr,"^",4) 
	..;lxz 地理位置值显示改成和设置中判断顺序一致          
	..s OrdDep=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),7)),"^",2) ;下医嘱科室
	..if ProcessingNotes'="" s RecDepAdress=ProcessingNotes              
	..//医嘱项有维护明细优先走医嘱项明细
    ..i (($g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",+subcat))=1)&&($g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",OrdDep))'=""))  d
    ...s RecDepAdress=$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",OrdDep))                  //特定子类走开单科室接收位置	
    ..if (Spec'="")  d
    ...i $g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",Spec))'="" s RecDepAdress=$g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",Spec))   //标本有维护位置优先走标本位置	
	..do OutputRow4
	.&sql(CLOSE EmpCursor)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow4
 set Data=$lb(Rowid,OrderName,StartDate,Priority,Status,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,OrderType,Spec,UserAddName,LabEpisodeNo,orcat,orcatdesc,RecDepAdress,DepProcNotes,StatusCode,ExecuteTime,Spec1,ProcessingNotes,CTNationName,SkinTest)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables4
	set (Rowid,OrderName,StartDate,Priority,Status,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,OrderType,Spec,UserAddName,LabEpisodeNo,orcat,orcatdesc,RecDepAdress,DepProcNotes,StatusCode,ExecuteTime,CTNationName,SkinTest)=""
	quit
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

ClassMethod GetPrescItemCount(EpisodeID As %String, PrescNo As %String) As %Integer
{
 &SQL(Select Count(*) Into :OrderItemCount From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and OEORI_ItemStat_DR->OSTAT_Code='V' and OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='R')
 Quit OrderItemCount
}

ClassMethod GetPrescItemsBroker(itmjs As %Library.String = "", EpisodeID As %String, PrescNo As %String) As %Library.String
{
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescItems")
	do rset.Execute(EpisodeID,PrescNo)
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
	Q 1
}

ClassMethod GetPrescItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetLabSpec(OrderItemRowid As %String) As %String
{
 s SpecStr=""
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
 s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 . s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 . s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 . i SpecStr="" s SpecStr=SpecDesc
 . e  s SpecStr=SpecStr+","+SpecDesc
 Q SpecStr

 n (Ord, Sub,OrderItemRowid)
 s Ord=+OrderItemRowid
 s Sub=$P(OrderItemRowid,"||",2)
 s retno=""
 q:Ord="" retno
 q:'$d(^OEORD(Ord,"I",Sub,1)) retno
 s ItmMastDR=$p(^OEORD(Ord,"I",Sub,1),"^",2)
 q:ItmMastDR="" retno
 s arcsub=$p(ItmMastDR,"||",2)
 q:arcsub="" retno
 s excode=""
 s chl="" f  s chl=$o(^ARCIM(+ItmMastDR,arcsub,"EXT",chl)) q:chl=""  d
 .s tod=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",2)
 .q:(tod'="")&(tod<+$h)
 .s excode=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",4)
 q:excode="" retno
	s contdr=$o(^TTAB("TS",excode,"SC",""))
	q:contdr="" retno
	s specdr=$o(^TTAB("TS",excode,"SC",contdr,""))
	q:specdr="" retno  
	s specdesc=$p($G(^TTAB("SPEC",specdr)),"\",1)
	q specdesc
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到医嘱大类串
/// Table:        
/// Input:       
/// Return:       大类描述_$C(1)_大类ID字符串_$C(1)_0
/// Others:       
ClassMethod GetOrdCat()
{
	s ret=""
	s OrdCatRowID=""
	s OrdCatDesc=""
	f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	.s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	.q:(OrdCatDesc="")&&(OrdCatRowID=0)
	.i ret=""  d
	..s ret=OrdCatDesc_$C(1)_OrdCatRowID_$C(1)_0
	.e  d
	..s ret=ret_$C(2)_OrdCatDesc_$C(1)_OrdCatRowID_$C(1)_0
	q ret
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到名字不需要显示的医嘱大类串
/// Table:        
/// Input:       
/// Return:       大类描述_$C(1)_大类ID字符串_$C(1)_显示标志
/// Others:       
ClassMethod GetHideOrdCat()
{
	s ret=""
	s OrdCatRowID=""
	s OrdCatDesc=""
	s flag=0
	f  s OrdCatRowID=$O(^OEC("ORCAT",OrdCatRowID)) q:OrdCatRowID=""  d
	.s OrdCatDesc=$p(^OEC("ORCAT",OrdCatRowID),"^",2)
	.q:(OrdCatDesc="")&&(OrdCatRowID=0)
	.i $d(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID))  d
	..s flag=^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCatRowID)
	.i ret=""  d
	..s ret=OrdCatDesc_$C(1)_OrdCatRowID_$C(1)_flag
	.e  d
	..s ret=ret_$C(2)_OrdCatDesc_$C(1)_OrdCatRowID_$C(1)_flag
	q ret
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到医嘱子类串
/// Table:        
/// Input:       
/// Return:       子类描述_$C(1)_子类ID字符串_$C(1)_0
/// Others:       
ClassMethod GetItemCat(OrdCatID As %String)
{
	s ret=""
	s ItemCatRowID=""
	s ItemCatDesc=""
	s flag=0
	f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	.s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	.q:(ItemCatDesc="")&&(ItemCatRowID=0)
	.i $d(^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID))  d
	..s flag=^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCatRowID)
	.i ret=""  d
	..s ret=ItemCatDesc_$C(1)_ItemCatRowID_$C(1)_flag
	.e  d
	..s ret=ret_$C(2)_ItemCatDesc_$C(1)_ItemCatRowID_$C(1)_flag	
	q ret
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到接受位置走开单科室的医嘱子类串
/// Table:        
/// Input:       
/// Return:       子类描述_$C(1)_子类ID字符串_$C(1)_0
/// Others:       
ClassMethod GetAdmDepItemCat(OrdCatID As %String)
{
	s ret=""
	s ItemCatRowID=""
	s ItemCatDesc=""
	s flag=0
	f  s ItemCatRowID=$O(^ARC("IC",0,"OrdCat",OrdCatID,ItemCatRowID)) q:ItemCatRowID=""  d
	.s ItemCatDesc=$p(^ARC("IC",ItemCatRowID),"^",2)
	.q:(ItemCatDesc="")&&(ItemCatRowID=0)
	.i $d(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID))  d
	..s flag=^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID)
	.i ret=""  d
	..s ret=ItemCatDesc_$C(1)_ItemCatRowID_$C(1)_flag
	.e  d
	..s ret=ret_$C(2)_ItemCatDesc_$C(1)_ItemCatRowID_$C(1)_flag	
	q ret
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到标本串
/// Table:        
/// Input:       
/// Return:       标本描述_$C(1)_标本Code_$C(1)_0
/// Others:       
ClassMethod GetSpec()
{
	s ret=""
	i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
	i $d(^DHCLISBSVersion(1)) {
	    s HospitalCode=$g(HospitalCode)
		s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
		i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
		i $l(HospitalDR) {
			s SPECstr=""
			s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
			.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
			.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
			.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
			.i ret=""  d
		    ..s ret=SPECDesc_$C(1)_SpecimenDR_$C(1)_0
		    .e  d
		    ..s ret=ret_$C(2)_SPECDesc_$C(1)_SpecimenDR_$C(1)_0
		}
    }else{
	    s SpecRowid=""
		s SpecDesc=""
		f  s SpecRowid=$O(^TTAB("SPEC",SpecRowid)) q:SpecRowid=""  d
		.s SpecDesc=$p(^TTAB("SPEC",SpecRowid),"\",1)
		.q:(SpecDesc="")&&(SpecRowid=0)
		.i ret=""  d
		..s ret=SpecDesc_$C(1)_SpecRowid_$C(1)_0
		.e  d
		..s ret=ret_$C(2)_SpecDesc_$C(1)_SpecRowid_$C(1)_0
	}
	q ret
}

/*ClassMethod GetRecDep()
{
	s ret=""
	s DepRowid=""
	s DepDesc=""
	f  s DepRowid=$O(^CTLOC(DepRowid)) q:DepRowid=""  d
	.s DepDesc=$p(^CTLOC(DepRowid),"^",2)
	.q:(DepDesc="")&&(DepRowid=0)
	.s DepDesc=$p(DepDesc,"-",2)
	.i ret=""  d
	..s ret=DepDesc_$C(1)_DepRowid_$C(1)_0
	.e  d
	..s ret=ret_$C(2)_DepDesc_$C(1)_DepRowid_$C(1)_0
	q ret
}*/
/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到科室串
/// Table:        
/// Input:       
/// Return:       科室描述_$C(1)_科室ID_$C(1)_0
/// Others:       
/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  得到医院串
/// Table:        
/// Input:       
/// Return:       医院描述_$C(1)_医院ID_$C(1)_0
/// Others:       
ClassMethod GetHospital()
{
	s ret=""
	s HospRowid=""
	s HospDesc=""
	f  s HospRowid=$O(^CT("HOSP",HospRowid)) q:HospRowid=""  d
	.s HospDesc=$p(^CT("HOSP",HospRowid),"^",2)
	.q:(HospDesc="")&&(HospRowid=0)	
	.i ret=""  d
	..s ret=HospDesc_$C(1)_HospRowid_$C(1)_0
	.e  d
	..s ret=ret_$C(2)_HospDesc_$C(1)_HospRowid_$C(1)_0
	q ret
}

ClassMethod SaveConfig1(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
	i ((Node'="")&&(Node1'=""))  d
	.s ^DHCDocConfig("PatGuideDocumentsPrt",Node,Node1)=NodeValue
	i ((Node'="")&&(Node1=""))  d
	.s ^DHCDocConfig(Node)=NodeValue
	q 0
}

ClassMethod GetConfig(Node As %String, Node1 As %String) As %String
{
	s ret=""
	i ((Node'="")&&(Node1'=""))  d
	.s ret=$g(^DHCDocConfig("PatGuideDocumentsPrt",Node,Node1))
	i ((Node'="")&&(Node1=""))  d
	.s ret=$g(^DHCDocConfig(Node))
	q ret
}

/// zlj------------2013-02-28--------add 对导诊单上已打印过的医嘱存储打印标记
ClassMethod SetOrdPrtFlag() As %String
{
	i $d(^TempOrdCat("PrtFlag"))  d
	.s OrdCount=$L(^TempOrdCat("PrtFlag"),"^")
	.f i=1:1:OrdCount  d
	..s OrdRowid=$p(^TempOrdCat("PrtFlag"),"^",i)
	..s $p(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),"DHC"),"^",32)=1
	q 0
}

ClassMethod GetPatGuideSum(rowid As %String) As %String
{
	s ret=""
	i $d(^TempOrdCat("Sum",rowid))  d
	.s ret=^TempOrdCat("Sum",rowid)
	q ret
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  查找科室
/// Table:        
/// Input:       
/// Return:       
/// Others:       
ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocPatGuideDocumentsPrt","FindLoc","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$O(^CTLOC(rowid)) q:rowid=""  d	
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.s CTContactNameTem=""
	.i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2,$L(CTDesc,"-"))
	.s CTDesc=$TR(CTDesc,"-")
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.i CTContactName="" s CTContactName=CTContactNameTem	
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLoc(Loc As %String) As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

// w ##class(web.DHCDocPatGuideDocumentsPrt).GetOPDeptStr("3144")

ClassMethod GetOPDeptStr(Desc As %String = "") As %String
{
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCDocPatGuideDocumentsPrt:FindLoc")
	do rset.Execute(Desc)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s LocID=rset.GetData(3)		
		set ret=LocID_$C(1)_rset.GetData(1)_"-"_rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

/// Creator:      张立军
/// CreatDate:    2013-02-26
/// Description:  对前台得到的打印参数进行处理，分类，再合并
/// Global:       ^TempOrdCat(OecCat,RecDep):对打印数据进行分类，大类和科室相同的为一类打印打一张单子上，
///                                          其他的按照子类划分并分开打印
///               ^TempOrdCat("ID",rowid)：用来记录^TempOrdCat(OecCat,RecDep)索引和可是对应的医院名，并且rowid的个数表示要打印的单子数
///               ^TempOrdCat("Print",rowid):用于记录每张单子的实体内容  
///               ^TempOrdCat("PrtFlag"):存储需要置打印标记的医嘱ID
///               ^TempOrdCat("Sum",rowid):用于存储每张单子上的总金额，已付和未付金额
/// Input:       
/// Return:       需要打印的字符串
/// Others:       XML中列间距完全由cls中的空格来控制，^TempOrdCat("ID",rowid)，^TempOrdCat("Print",rowid)，^TempOrdCat("Sum",rowid)共用一个rowid
ClassMethod GetPatGuideList(PatGuideInfo As %String, RePrintFlag As %String) As %String
{
	k ^TempOrdCat	
	s PatGuideList=""
	s rowid=0
	s OrdInfoCount=$L(PatGuideInfo,$c(2))
	s ^TempzongHYHH=PatGuideInfo
	//对数据进行分类
	f i=1:1:OrdInfoCount  d
	.s OrdInfo=$p(PatGuideInfo,$c(2),i)
	.q:OrdInfo=""
	.s OrdRowid=$p(OrdInfo,"^",1)
	.s RecDepDR=$p(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),3),"^",6)
	.s HospitalRowid=$p(^CTLOC(RecDepDR),"^",22)
	.s RecDep=$p(OrdInfo,"^",16)
	.s OecCat=$p(OrdInfo,"^",18)
	.s OecCatDesc=$p(OrdInfo,"^",19)
	.i '$d(^TempOrdCat(OecCat,RecDep))  d
	..s rowid=rowid+1
	..s ^TempOrdCat("ID",rowid)=OecCat_"^"_RecDep_"^"_HospitalRowid
	..s ^TempOrdCat(OecCat,RecDep)=OrdInfo
	.e  d	
	..s ^TempOrdCat(OecCat,RecDep)=^TempOrdCat(OecCat,RecDep)_$c(2)_OrdInfo
	//循环对每类数据编辑打印内容
	s subcatflag=0	
	s rowid=""
	f  s rowid=$o(^TempOrdCat("ID",rowid))  q:rowid=""  d
	.s OrdSum=0
	.s PaidSum=0
	.s OecCatID=$p(^TempOrdCat("ID",rowid),"^",1)
	.s RecDepDesc=$p(^TempOrdCat("ID",rowid),"^",2)
	.s OrdInfoCount=$L(^TempOrdCat(OecCatID,RecDepDesc),$c(2))
	.i OrdInfoCount=1  d
	..s subcatflag=1
	.f i=1:1:OrdInfoCount  d	
	..s OrdInfo=$p(^TempOrdCat(OecCatID,RecDepDesc),$c(2),i)
	..q:OrdInfo=""
	..s OrdRowid=$p(OrdInfo,"^",1)
	..;s OrdPrtFlag=$p($g(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),"DHC")),"^",32)
	..;q:(OrdPrtFlag=1) ;&(RePrintFlag'=1)
	..d recordord(OrdRowid)
	..s ArcimRowid=$p(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),1),"^",2)
	..s subcat=$p($g(^ARCIM(+ArcimRowid,1,1)),"^",10)
	..s subcatdesc=$p($g(^ARC("IC",subcat)),"^",2)
	..s OrderName=$p(OrdInfo,"^",2)	
	..s Billed=$p(OrdInfo,"^",3)
	..s BillType=$p(OrdInfo,"^",4)
	..s UserAddName=$p(OrdInfo,"^",5)
	..s Spec=$p(OrdInfo,"^",6)
	..s PackQty=$p(OrdInfo,"^",7)
	..s PackUOM=$p(OrdInfo,"^",8)
	..s Price=$p(OrdInfo,"^",9)
	..s Price=$j(Price,3,2)               //单价 保留两位小数
	..s Sum=$p(OrdInfo,"^",10)
	..s OrdSum=OrdSum+Sum
	..i Billed="Paid"  d
	...s PaidSum=PaidSum+Sum
	..s OrderNotes=$p(OrdInfo,"^",11)
	..s ProcessingNotes=$p(OrdInfo,"^",12)
	..s SkinTest=$p(OrdInfo,"^",13)
	..s LabRecDepDesc=$p(OrdInfo,"^",14)
	..s LabEpisodeNo=$p(OrdInfo,"^",15)
	..s Location=$p(OrdInfo,"^",17)
	..s EpisodeID=$p(OrdInfo,"^",20)	
	..;s AdmDepDR=$p(^PAADM(EpisodeID),"^",4)
	..s AdmDepDR=$p($g(^OEORD(+OrdRowid,"I",$p(OrdRowid,"||",2),7)),"^",2)  ;改为医嘱录入的科室
    ..i ProcessingNotes="" s ProcessingNotes=Location                                         //医嘱项有维护明细优先走医嘱项明细
    ..i (($g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",subcat))=1)&&($g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",AdmDepDR))'=""))  d
    ...s ProcessingNotes=$g(^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",AdmDepDR))                  //特定子类走开单科室接收位置	
    ..i $g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",Spec))'="" s ProcessingNotes=$g(^DHCDocConfig("PatGuideDocumentsPrt","Spec",Spec))   //标本有维护位置优先走标本位置	
	..s RecDep=$p(OrdInfo,"^",16)
	..s OecCat=$p(OrdInfo,"^",18)
	..s OecCatDesc=$p(OrdInfo,"^",19)
	..s PackUOM=$tr(PackUOM," ")
	..i PackUOM'="" s PackQty=PackQty_PackUOM
	..i subcatflag=1  d
	...s OecCatDesc=subcatdesc		
	..i '$d(^TempOrdCat("Print",rowid))  d
	...d setPatGuideTitle(OecCat,OecCatDesc,RecDep,Location)
	...d setPatGuideBody(OecCat,OecCatDesc,OrderName,Price,PackQty,Sum,Billed,ProcessingNotes)	
	..e  d
	...d setPatGuideBody(OecCat,OecCatDesc,OrderName,Price,PackQty,Sum,Billed,ProcessingNotes)	
	.s ToPaidSum=OrdSum-PaidSum
	.s ^TempOrdCat("Sum",rowid)=OrdSum_"^"_PaidSum_"^"_ToPaidSum
	s PrintDate=..%SysDate()
	s PrintDate=$zd(PrintDate,3)
	s PrintTime=..%SysTime()
	s PrintTime=..%ZT(PrintTime)
	s OrdCatRowid=""
	f  s OrdCatRowid=$o(^TempOrdCat("Print",OrdCatRowid)) q:OrdCatRowid=""  d
	.s HospitalRowid=$p(^TempOrdCat("ID",OrdCatRowid),"^",3)
	.s ^TempOrdCat("Print",OrdCatRowid)=^TempOrdCat("Print",OrdCatRowid)_"________________"_"^"_"_____________"_"^"_"_______________"_"^"_"_____________________"_"^"_"______________________"_"^"_"___________________"	
	.s ^TempOrdCat("Print",OrdCatRowid)=^TempOrdCat("Print",OrdCatRowid)_$c(2)_"打印时间:"_PrintDate_" "_PrintTime_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	.i HospitalRowid'=""  d
	..s ^TempOrdCat("Print",OrdCatRowid)=^TempOrdCat("Print",OrdCatRowid)_$c(2)_$g(^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",HospitalRowid))_"^"_"  "_"^"_"  "_"^"_"  "_"^"_"  "_"^"_"  "
	.i PatGuideList=""  d
	..s PatGuideList=^TempOrdCat("Print",OrdCatRowid)
	.e  d
	..s PatGuideList=PatGuideList_"||"_^TempOrdCat("Print",OrdCatRowid)		
	q PatGuideList
setPatGuideTitle(OecCat,OecCatDesc,RecDep,Location)    
    s ^TempOrdCat("Print",rowid)=OecCatDesc_"^"_"         接收科室:"_RecDep_"^"_"      "_"^"_"             "_"^"_""_"^"_""_$c(2)
	s ^TempOrdCat("Print",rowid)=^TempOrdCat("Print",rowid)_"医嘱名称"_"^"_"         单价"_"^"_"   数量"_"^"_"   金额"_"^"_"    计费状态 "_"^"_"     位置"_$c(2)
setPatGuideBody(OecCat,OecCatDesc,OrderName,Price,PackQty,Sum,Billed,ProcessingNotes)
    i Billed="To Bill"  d
    .s Billed="未计费"
    i Billed="Paid"  d
    .s Billed="已计费"
    i $g(^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OecCat))=1  d
	.;不显示医嘱名称
	.s OrderName=OecCatDesc
	i (($l(OrderName)>15)||($l(ProcessingNotes)>25))  d
	.;医嘱名称或医嘱备注过长进行拆分
	.s OrderNameFirst=$e(OrderName,1,15)
	.s OrderNameLast=$e(OrderName,16,$l(OrderName))
	.s OrderNotesFirst=$e(ProcessingNotes,1,25)
	.s OrderNotesLast=$e(ProcessingNotes,16,50)
	.i $l(ProcessingNotes)>50
	..s OrderNotesLast=OrderNotesLast_"*"
	.s ^TempOrdCat("Print",rowid)=^TempOrdCat("Print",rowid)_OrderNameFirst_"^"_"         "_Price_"^"_"    "_PackQty_"^"_"   "_Sum_"^"_"    "_Billed_"^"_"     "_OrderNotesFirst_$c(2)_OrderNameLast_"^"_"         "_" "_"^"_"    "_" "_"^"_"   "_" "_"^"_"    "_" "_"^"_"     "_OrderNotesLast_$c(2)
	e  d
	.s ^TempOrdCat("Print",rowid)=^TempOrdCat("Print",rowid)_OrderName_"^"_"         "_Price_"^"_"    "_PackQty_"^"_"   "_Sum_"^"_"    "_Billed_"^"_"     "_ProcessingNotes_$c(2)
recordord(OrdRowid)
    i '$d(^TempOrdCat("PrtFlag"))  d
	.s ^TempOrdCat("PrtFlag")=OrdRowid
	e  d
	.s ^TempOrdCat("PrtFlag")=^TempOrdCat("PrtFlag")_"^"_OrdRowid
	
	q
}

}
