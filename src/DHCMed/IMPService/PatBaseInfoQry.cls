/// 创建者：李阳
/// 名称：DHCMed.IMPService.PatBaseInfoQry
/// 作用：病人诊断、手术、辅助检查、抗生素医嘱的查询
/// 创建时间：2010-04-17
Class DHCMed.IMPService.PatBaseInfoQry Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 查询病人疾病信息
Query GetMrDiagnose(paadm As %String) As %Query(ROWSPEC = "ICD:%String,DiseaseName:%String,Type:%String")
{
}

ClassMethod GetMrDiagnoseExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
        s MrAdm=+$p($g(^PAADM(+paadm)),"^",61)
        s s=""
        q:'$d(^MR(+MrAdm,"DIA")) $$$OK
        
        ;^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
        s Childsub=0
        f  s Childsub=$o(^MR(+MrAdm,"DIA",Childsub)) q:Childsub=""  d
        .s tmp=$$BuildDisInfo(+MrAdm,Childsub)
        .s s=s_tmp_$c(1)
        q $$$OK
        
BuildDisInfo(MRADM,MRDIAChildsub)
     ;n (MRADM,MRDIAChildsub)
     s sDIA=$g(^MR(+MRADM,"DIA",MRDIAChildsub))
     s ICDDR=$p(sDIA,"^",1)
     s ICDDoctorDR=$p(sDIA,"^",4)
     s ICDDate=$zd(+$p(sDIA,"^",7),3)
     s ICDTime=$zt(+$p(sDIA,"^",8))
     s ICDType=$g(^MR(+MRADM,"DIA",MRDIAChildsub,"TYP","1"))
     
     s:ICDDR'="" ICDDR=ICDDR_"/"_$p($g(^MRC("ID",ICDDR)),"^",4)_"/"_$p($g(^MRC("ID",ICDDR)),"^",2)
     ;s:ICDDoctorDR'=0 ICDDoctorDR=ICDDoctorDR_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR)),"^",2)
     
     ;s:ICDDoctorDR'=0 ICDDoctorDR=$$GetSSUSERByCode^DHCMedBase($p($g(^CTPCP(ICDDoctorDR,1)),"^",1))_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",1)_"/"_$p($g(^CTPCP(ICDDoctorDR,1)),"^",2)
     
     s:ICDDoctorDR'="" ICDDoctorDR=$$GetUserByCTCP(ICDDoctorDR)
     ;GetSSUSERByCode
     s:ICDType'="" ICDType=ICDType_"/"_$p($g(^MRC("DTYP",ICDType)),"^",1)_"/"_$p($g(^MRC("DTYP",ICDType)),"^",2)
     
     s paadm=+$p($g(^MR(+MRADM,"PRO",1)),"^",9)
     s paadmtype=$p($g(^PAADM(paadm)),"^",2)
     s ctloc=$p($g(^PAADM(paadm)),"^",4)
     s LocDesc=ctloc_"/"_$p(^CTLOC(+ctloc),"^",2)
     s s=paadm_$c(2)_paadmtype_$c(2)_LocDesc_$c(2)_MRADM_"||"_MRDIAChildsub_$c(2)_ICDDR_$c(2)_ICDDoctorDR_$c(2)_ICDType_$c(2)_ICDDate_$c(2)_ICDTime
     s data=$lb("")
     s $li(data,1)=$p($g(^MRC("ID",ICDDR)),"^",4)
     s $li(data,2)=$p($g(^MRC("ID",ICDDR)),"^",2)
     s $li(data,3)=$p($g(^MRC("DTYP",ICDType)),"^",2)
     q ^CacheTemp(repid,ind)=data
     s ind=ind+1
     
GetUserByCTCP(CTCPDR)       ;CT_CareProv
    q:'$d(^CTPCP(CTCPDR)) ""
 s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
 s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
 s ssusr=$$GetSSUSERByCode(Code)
 s s=ssusr_"/"_Code_"/"_Desc
 q s

GetSSUSERByCode(SSUSRInitials)
   ;n (SSUSRInitials)
   q:SSUSRInitials="" ""
   ;^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId})
   ;s SSUSRInitials=$ZCVT(SSUSRInitials,"U")
   s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials)) ""
   s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
   q ssusr 
     

	Quit $$$OK
}

ClassMethod GetMrDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMrDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMrDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMrDiagnoseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 查询手术列表
Query QueryOperation(paadm As %String) As %Query(ROWSPEC = "OrderID:%String,OperationName:%String,StartDate:%String,StartTime:%String,Status:%String")
{
}

ClassMethod QueryOperationExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK       
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
       
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s OrdCat=+$p($g(^ARC("IC",+ItmCat)),"^",8)
    .s OrdCatDesc=$p($g(^OEC("ORCAT",OrdCat)),"^",2)
    .q:OrdCatDesc'["手术"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s sttTime=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",10)
    ...s oeori=oeord_"||"_oeoriSub
    ...s data=$lb("")
    ...s $li(data,1)=oeori
    ...s $li(data,2)=arcimDesc
    ...s $li(data,3)=$zd(sttDate,3)
    ...s $li(data,4)=$zt(sttTime,1)
    ...s $li(data,5)=OrderStatusDesc
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1   
	Quit $$$OK
}

ClassMethod QueryOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOperationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// 查询辅助检查列表
Query QueryLab(paadm As %String) As %Query(ROWSPEC = "OrderID:%String,OrderName:%String,StartDate:%String,LabTestNo:%String,OrderStatus:%String")
{
}

ClassMethod QueryLabExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK   
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
    //  s aNum=$$BuildCurrDepArcim(paadm)
    s arcim="" f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .;w:Type="L" !,"arcimDesc="_arcimDesc_"   Type="_Type
    .q:Type'="L"
    .s flag=""
    .s:$d(^CacheTemp($zn,$j,"ARCIM",arcim)) flag="1"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,"    oeori="_oeord_"||"_oeoriSub_"  "_OrderStatus_"  "_OrderStatusDesc
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...;s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s labtestsetrow=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",35)
    ...;w !," oeori="_oeord_"||"_oeoriSub_"    labtestsetrow="_labtestsetrow
    ...s oeori=oeord_"||"_oeoriSub
    ...s data=$lb("")
    ...s $li(data,1)=oeori
    ...s $li(data,2)=arcimDesc
    ...s $li(data,3)=$zd(sttDate,3)
    ...s $li(data,4)=labtestsetrow
    ...s $li(data,5)=OrderStatusDesc
    ...s ^CacheTemp(repid,ind)=data
    ...s ind=ind+1
    ...;s TMP=oeori_$c(2)_arcimDesc_$c(2)_$zd(sttDate,3)_$c(2)_flag_$c(2)_labtestsetrow_$c(2)_OrderStatusDesc
    ...;s s=s_TMP_$c(1)
    k ^CacheTemp($zn,$j,"ARCIM")
    q $$$OK
}

ClassMethod QueryLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryOrder(paadm As %String) As %Query(ROWSPEC = "arcim:%String,arcimDesc:%String,startDate:%String,endDate:%String,days:%String")
{
}

ClassMethod QueryOrderExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
       s num=0,s=""
       q:'$d(^OEORD(0,"Adm",+paadm)) $$$OK
       s DrugFlag=""
       s oeord=$o(^OEORD(0,"Adm",+paadm,""))
       
       s arcim=""
       f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
       .;q:$$CheckOrderType(arcim,OrderType)=0
       .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
       .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
       .q:Type'="R"
       .s phccat=$$GetPhcCat(+arcim)
       .q:(DrugFlag'="")&((phccat'["抗感染")&(phccat'["抗生素")&(phccat'["抗微生物"))    ;by wuqk 2008-05-12
       .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
       .s sttDate="",endDate="",Days=0,TMP=""
       .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
       ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
       ...s oeori=oeord_"||"_oeoriSub
       ...;q:$$CheckOrderStatus(oeori)<0
       ...s TsttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
       ...s DuratDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",6),DuratDays=1
       ...s:DuratDR>0 DuratDays=+$p($g(^PHCDU(DuratDR)),"^",2)
       ...s TendDate=TsttDate+DuratDays-1
       ...s:sttDate="" sttDate=TsttDate
       ...s endDate=TendDate
       ...;q:$$CheckOrderStatus(oeori)<0
       ...s Days=Days+DuratDays
       .s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
       .;s:sttDate'="" sttDate=$zd(sttDate,3)
       .;s:endDate'="" endDate=$zd(endDate,3)
       .s data=$lb("")
       .s $li(data,1)=arcim
       .s $li(data,2)=arcimDesc
       .s $li(data,3)=sttDate
       .s $li(data,4)=endDate
       .s $li(data,5)=Days
       .s ^CacheTemp(repid,ind)=data
       .s ind=ind+1
       q $$$OK
       
GetPhcCat(arcim)
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

ClassMethod QueryOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
