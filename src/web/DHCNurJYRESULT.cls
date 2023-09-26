Class web.DHCNurJYRESULT Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetArcDes(Oew, OrdSub) As %String
{
  //医嘱名称
	   s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   s ARCIMRowid=$P(ArcimDR,"||",1)
	   s ARCIMSub=$P(ArcimDR,"||",2) 
	   s ARCIMDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
 
	   q ARCIMDesc
}

ClassMethod GetSeqNo(Oew, OrdSub) As %String
{
 //医嘱序号
       s Seq=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;Oeori_SeqNo
       if $P(Seq,".",2)'="" d
       .s Seq1=$P(Seq,"."),Seq2=$P(Seq,".",2)
       e  s Seq1=$P(Seq,"."),Seq2=0
      q Seq1_"^"_Seq2
}

ClassMethod GetOrdRadiaExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    //Adm As %String, StartDate As %String, EndDate As %String, longtyp As %String, tempTyp As %String
     s adm=$P(Parr,"^",1)
	 s StartDate=$P(Parr,"^",2)
	 s EndDate=$P(Parr,"^",3)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Oew=""  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
    if StartDate="" s StartDate=+$H
    if EndDate=""  s EndDate=+$H
    if StartDate'="" s StartDate=$ZDH(StartDate,3)
    if EndDate'="" s EndDate=$ZDH(EndDate,3)
    f date=StartDate:1:EndDate 
    { 
	    s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",date,Oew,OrdSub)) q:OrdSub=""  d
    	.s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	    .i PriorDR="" q //ypz
	   	.s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	    .s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	    .if OrdTime="" s OrdTime=$P($H,",",2)
        .s PriorDes=$P($G(^OECPR(PriorDR)),"^",2)
	    .s oecprCode=$P($G(^OECPR(PriorDR)),"^",1)
	    .s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	    .i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	    .//i (stop="0")&(OrdStat="停止") q 
        .s PriorDes="^"_PriorDes_"^"
	    .//q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)&(tempTyp'="0")
	    .//q:(^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes)&(longtyp'="0")
	    .s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	    .s ServFlag=..GetServFlag(Oew,OrdSub)
	    .q:ServFlag'="S"
        .if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	    .q:CpTypDR=""
	    .q:'$D(^CT("CPT",CpTypDR))
	    .i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	    .q:CpTyp'="DOCTOR"
	   	.s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	    .//q:Instru'=MethDR&(Instru'="")
        .s Seq=..GetSeqNo(Oew,OrdSub)
	    .s Seq1=$P(Seq,"^",1),Seq2=$P(Seq,"^",2)
	    .s ARCIMDesc(Oew,OrdSub)=..GetArcDes(Oew,OrdSub)  ;ord name   
        .s ORD(OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
        .s DateEx="",TimeEx="" ,CPTEx=""
	    .s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	    .i cl=""  s cl=1
	    .i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	    ..s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	    ..s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	    ..s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	    ..i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2) 
	    .s DateEx(Oew,OrdSub)=DateEx,TimeEx(Oew,OrdSub)=TimeEx,CPTEx(Oew,OrdSub)=CPTEx
	 }
       s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	   ..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	   ...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	   ....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	   .....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	   ......s ARCIMDesc=ARCIMDesc(rw,chl)
	   ......if Seq2'=0  s ARCIMDesc="●"_ARCIMDesc
	   ......s DateEx=DateEx(rw,chl),TimeEx=TimeEx(rw,chl),CPTEx=CPTEx(rw,chl)
	   ......s ORW=rw_"||"_chl
	   ......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)
	   ......d OutPut
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb($ZD(OrdDate,3),$ZT(OrdTime),ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetServFlag(OrderRowid, itemsub) As %String
{
 //取检查标记 //

 s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
 q ServerMaterial
}

ClassMethod GetRadiaNoteOld(oeordrowid) As %String
{
 //报告 web.DHCNurJYRESULT.GetRadiaNote
	s rw=$O(^DHCPACRegInfoi("OEORI",oeordrowid,""))
	if rw="" q ""
	if rw'="" s studno=$P(^DHCPACRegInfo(rw),"^",2)
	s rprw=$O(^DHCRBStudyi("Report","StudyNo",studno,""))
	q:rprw="" ""
	s examdesc=^DHCRBStudy("Report",rprw,"ExamDescEx")  
	s resultdesc=^DHCRBStudy("Report",rprw,"ResultDescEx")
	q examdesc_resultdesc
}

/// 判断检查医嘱是否出了报告 
/// w ##class(web.DHCNurJYRESULT).GetRadiaNote("154||36")
/// panshuai 2015-03-19
ClassMethod GetRadiaNote(oeordrowid) As %String
{
 
	s rw=$O(^DHCPACRegInfoi("OEORI",oeordrowid,""))
	q:rw="" ""
	s studno=$P(^DHCPACRegInfo(rw),"^",2)
	q:studno="" ""
	s RptRowId=$O(^DHCRBStudyi("Report","StudyNo",studno,""))
	q:RptRowId="" ""
	
	s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	q:StatusDR="" ""
	s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	q:StatusCode'="S" ""
	s examdesc=^DHCRBStudy("Report",RptRowId,"ExamDescEx")  
	s resultdesc=^DHCRBStudy("Report",RptRowId,"ResultDescEx")
	q "报告:"_examdesc_resultdesc
}

ClassMethod GetOrdRadiaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdRadiaExecute ]
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

ClassMethod GetOrdRadiaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdRadiaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOrdRadia(Parr As %String) As %Query(ROWSPEC = "OrdDate,OrdTime,ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR,sel")
{
}

ClassMethod GetLabNoExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if Adm="" Quit $$$OK

    s Oew=0 f  s Oew=$o(^OEORD(0,"Adm",Adm,Oew)) q:Oew=""  d
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub),-1)  q:(OrdSub="")||(OrdSub=0)  d
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;要求执行日期?
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	..s StDateTime=$E($ZD(StDate,3),6,10)_" "_$ZT(StTime,2)
	..s OrdStatusDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
	..s dispstat=""
	..s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",2)
	..q:OrdStat="停止"
	..s LabEpisodeNo=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",20)
	..q:LabEpisodeNo=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
    ..s testcode=..GetExCode(ArcimDR)
    ..q:testcode=""
    ..//w !,testcode,"-",LabEpisodeNo
	..s labstat=..IflabnoVer(LabEpisodeNo,testcode)
	..//s labstat="df^d^d"
	..s LabCpt=$P(labstat,"^",1)
	..s LabDate=$E($P(labstat,"^",2),6,10)
	..s LabTime=$P(labstat,"^",3)
    ..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2)  
	..s ARCIMDes=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	..s RowId=Oew_"||"_OrdSub
	..i $G(LabNo(ARCIMDes,testcode))="" s LabNo(ARCIMDes,testcode)=LabEpisodeNo
	..e  s LabNo(ARCIMDes,testcode)=LabNo(ARCIMDes,testcode)_"||"_LabEpisodeNo
	..s TEM(ARCIMDes,testcode)=$lb(ARCIMDes,LabNo(ARCIMDes,testcode),StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
	..//s TEM(testcode,OrdSub)=$lb(ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
	..
	//s code=""  f  s code=$O(TEM(code)) q:code=""  d
	//.s sub=""  f  s sub=$O(TEM(code,sub)) q:sub=""  d
	//..s a=TEM(code,sub)
	//..d OutPut
	s arcimDesc=""  f  s arcimDesc=$O(TEM(arcimDesc)) q:arcimDesc=""  d
	.s testCode="" f  s testCode=$O(TEM(arcimDesc,testCode)) q:testCode=""  d
	..s a=TEM(arcimDesc,testCode)
	..d OutPut
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	set Data=a //$lb(ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLabNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabNoExecute ]
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

ClassMethod GetLabNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetLabNo(Adm As %String) As %Query(ROWSPEC = "ARCIMDes,LabEpisodeNo,StDateTime,RowId,testcode,LabCpt,LabDate,LabTime")
{
}

ClassMethod IflabnoVer(labno As %String = "", testc As %String = "") As %String
{
 ///检查是否核实
  // n (labno,testc)
   q:testc="" ""
     s status=$P($g(^["LABDATA"]TEPI(labno,1,testc,1)),"\",31)
     if status'="A"  q ""
     s ^TMP(labno,testc)=""
     s author=$p(^["LABDATA"]TEPI(labno,1,testc,1),"\",3)
     i (author'="") {
	     if ($D(^["LABDATA"]SSU("SSUSR",1,author))){
	     s author=$p(^["LABDATA"]SSU("SSUSR",1,author),"^",2) 
	     }
	     else{
		       s author=""
	     }
     }
     else 
     { 
     s author=""
     }
     s Adate=$zd($p($G(^["LABDATA"]TEPI(labno,1,testc,1)),"\",1),3)
     s Atime=$zt($p($G(^["LABDATA"]TEPI(labno,1,testc,1)),"\",2)*60)
     s ret=author_"^"_Adate_"^"_Atime
     i $P(ret,"^",2)="" s ret=""
     q ret
}

ClassMethod GetTestSetDataExecute(ByRef qHandle As %Binary, labnum As %String, testc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	if labnum="" Quit $$$OK
	    // s rw="",des="序号"
	     s ^TMP(labnum)=""
         s sex=$P($g(^["LABDATA"]TEPI(labnum)),"\",3)
         s age=$P($g(^["LABDATA"]TEPI(labnum)),"\",25)
         s i=0 
         s count="" f  s count=$O(^["LABDATA"]TEPI(labnum,1,testc,count)) q:count=""  d
         .//s author=$p(^["LABDATA"]TEPI(labnum,1,testc,count),"\",3)
         .//i author'="" s author=$p(^["LABDATA"]SSU("SSUSR",1,author),"^",2) 
         .//e  s author=""
         .//s Adate=$zd($p(^["LABDATA"]TEPI(labnum,1,testc,1),"\",1),3)
         .//s Atime=$zt($p(^["LABDATA"]TEPI(labnum,1,testc,1),"\",2)*60)
         .s code="" f  s code=$O(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code)) q:code=""  d
         ..s intyp=$P(^["LABDATA"]TTAB("TC",code),"\",3)
         ..s itemname=$P(^["LABDATA"]TTAB("TC",code),"\",1)
         ..//i (code="A0111")!(code="A0112") s itemname=itemname_"."  ;镜检 尿红细胞，尿白细胞
         ..i intyp="S" d  ;standard comment------------------------------------------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s standcom=""
         ...f b1=1:1:$g(^["LABDATA"]TTAB("TC",code,2,data,0))  d
         ....s standcom=standcom_$g(^["LABDATA"]TTAB("TC",code,2,data,b1))
         ...s data=standcom
         ..i intyp="X" d  ;free text--------------------------------------------------
         ...//s cmm=""
         ...//f b1=1:1:$g(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code,"REM",0)) d
         ...//.s cmm=cmm_$g(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code,"REM",b1))
         ...//s data=cmm
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ..i intyp["N" d  ;numeric---------------------------------------------------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s unit=$P(^["LABDATA"]TTAB("TC",code),"\",2)
         ...i unit["~" s unit="*"_unit
         ...s value=..standdata(code,sex,age)
         ...//w !,value
         ...//s data=data_"@"_unit_"@"_value
         ..i intyp="V" d  ;micro Pathogen ct_bugs ^TTAB("BUG",{CTBUG_Code})-----------
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...s ttres=$P($g(^["LABDATA"]TTAB("BUG",data)),"\",1)
         ...s ant=..gettestdata(labnum,testc,code,i)
         ...s ansum=$P(ant,"^")
         ...s antidesc=$P(ant,"^",2)
         ...i $G(ansum)'=0 s data=ttres_" "_antidesc
         ...e  s data=ttres
         ..i intyp="B2" d
         ...s data=$P(^["LABDATA"]TEPI(labnum,1,testc,count,"DATA",code),"\",1)
         ...i data'="" s data=$P(^["LABDATA"]TTAB("BB-BG",data),"\",1)
         ...s unit=$P(^["LABDATA"]TTAB("TC",code),"\",2)
         ...i unit["~" s unit="*"_unit
         ..s labstat=..IflabnoVer(labnum,testc)
         ..s LabDate=$E($P(labstat,"^",2),6,10)
         ..d OutPutData
         //..i '$D(result)  s result=itemname_"##"_data
         //..e  s result=result_"!!"_itemname_"##"_data
         //.s i=i+1
         //.s PLIST(i)=author_"**"_Adate_"**"_Atime_"**"_result

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutData
	set Data=$lb(itemname,data,$G(unit),$G(value),$G(LabDate))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTestSetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestSetDataExecute ]
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

ClassMethod GetTestSetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestSetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTestSetData(LabNum, TestC) As %Query(ROWSPEC = "itemname,data,unit,value,LabDate")
{
}

ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	//n (ArcimRowid)
	s arcsub=$p(ArcimRowid,"||",2)
	q:arcsub="" ""
	s ExCode=""
	s chl="" f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.q:(fromd'="")&(fromd>+$h)
	.q:(tod'="")&(tod<+$h)
	.s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	q ExCode
}

ClassMethod gettestdata(labno, testcode, itemcode, i)
{
	//n (labno, testcode, itemcode, i)
	;EP_VisitTestSetDataAntibiotics ^TEPI({EP_VisitNumber.EPVIS_VisitNumber},1,{EP_VisitTestSet.VISTS_TestSet_DR},{EP_VisitTestSet.VISTS_TestSetCounter},"DATA",{EP_VisitTestSetData.VISTD_TestCode_DR},"ANT",{VISTA_Antibiotic_DR})
	s antidesc="",des="",sensi="" ; f  q:('$d(^["LABDATA"]TTAB("TS",testcode,0,zzz))) 
	s ans="",r=""  
	s ansum=0
	f  s des=$O(^["LABDATA"]TEPI(labno,1,testcode,i,"DATA",itemcode,"ANT",des))  q:des=""  d
	.s ansum=ansum+1 
	.s sensi=$P(^["LABDATA"]TEPI(labno,1,testcode,i,"DATA",itemcode,"ANT",des),"\",1)
	.s ans=$P(^["LABDATA"]TTAB("ANT",des),"\",1)
	.s r=$P(^["LABDATA"]TTAB("SENS",sensi),"\",1)
	.s antidesc=antidesc_" "_ans_"["_r_"]"
	q ansum_"^"_antidesc
}

ClassMethod standdata(itmcode, sex, age)
{
  ;求正常值 
 // n (itmcode,sex,age)
  i sex="" s sex="M"
  s itmcode=$g(itmcode) 
  s value=""
  s tvalue=..ranges(itmcode,age,sex,"",0,"","")
  s lowvalue=$p(tvalue,$c(1),1)
  s hvalue=$p(tvalue,$c(1),2)
  i $tr(tvalue,$c(1))'="" d
  .s value="{"_lowvalue_"-"_hvalue_"}"
  .s value=$tr(value,$c(1))
  q value
}

ClassMethod ranges(tc, age, spec, pregn, ptype, date, cond)
{
 //n (tc,age,spec,pregn,ptype,date,cond)
 // n j,x,xf,age0,type,PLIST,exist,result
  s tc=$g(tc),age=$g(age),spec=$g(spec),pregn=$g(pregn),ptype=$g(ptype),date=$g(date),cond=$g(cond),result=""
  i '$l(date) s date=+$h
  i '$d(^["LABDATA"]TTAB("TC",tc,4,date)) s date=$o(^["LABDATA"]TTAB("TC",tc,4,date),-1)
  ;i '$l(age)  s age=0
  i $l(date) d
  .f type=ptype,$e(ptype) i $d(^["LABDATA"]TTAB("TC",tc,4,date,type)) d  q
  ..i $l(age) d
  ...k xf s x="" f  s x=$o(^["LABDATA"]TTAB("TC",tc,4,date,type,x)) q:x=""  d  q:$l(result)
  ....i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
  ....i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
  ....i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
  ....i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
  ....s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23))),xf(xf,x)=^(x)
  ..e  d
  ...s age=0
  ...k xf s x="" f  s x=$o(^["LABDATA"]TTAB("TC",tc,4,date,type,x)) q:x=""  d  q:$l(result)
  ....i $l($p(^(x),"\",22)),$l($p(^(x),"\",23)),$p(^(x),"\",22)=spec,$p($p(^(x),"\",23),"-",2)=age d
  .....s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23))),xf(xf,x)=^(x)
  ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
  ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
  ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
  ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
  ....i 'exist s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
  ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
  f j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $e(x)="." s $p(result,$c(1),j)=0_x
  q result
}

//w ##Class(web.DHCDocPDAJYRESULT).GetLabItemdata("113734||118376||123985","F009")

ClassMethod GetLabItemdata(Labno As %String, testc As %String) As %String
{
	s QueryName="web.DHCNurJYRESULT:GetTestSetData"
	Set rset = ##class(%ResultSet).%New(QueryName)
	Set columns = rset.GetColumnCount()
	k tem,colData
	s ret=""
	s QueryName=$TR(QueryName,":","&")
	//s ret=$P(QueryName,"&",2)_"&"
	s rows=0
	s len=$L(Labno,"||")
	f h=1:1:len
	{
		s no=$P(Labno,"||",h)
		q:no=""
		s sc = rset.Execute(no,testc)
		s i=1
		While (rset.Next()) {
			i (i=1){
				i (ret=""){
					f col = 1:1:columns {
            			s ret=ret_rset.GetColumnName(col)_"&"
					}
				}
			}
			s itemName=rset.GetData(1)
			s colData(itemName)=""
			For col = 1:1:columns {
				if col=2 
		        {
					s tem(itemName,col)=$G(tem(itemName,col))_rset.GetData(5)_"/"_rset.GetData(col)_$C(1)
					s colData(itemName)=$G(colData(itemName))_tem(itemName,col)_"^"  //rset.GetData(col)
			    }else
			    {
	            	s colData(itemName)=$G(colData(itemName))_rset.GetData(col)_"^"
				}
        	}
			s i=i+1
			if i>300  q  
		}
		Do rset.Close()
		
	}
	
	s itemName1=$O(colData(""))
	s itemName=""
	f  s itemName=$O(colData(itemName)) q:itemName=""  d
	.i $G(colData(itemName))'="" d
	..i itemName=itemName1 s ret=ret_"$"_$G(colData(itemName))_"&"
	..e  s ret=ret_$G(colData(itemName))_"&"

	i ret="" s ret="-1"
	e  s ret=$P(QueryName,"&",2)_"&"_ret
	q ret
}

}
