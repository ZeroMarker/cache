Class web.DHCPdaLongTimeOrd Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod GetPackUom(Oew, OrdSub)
{
	   s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   s ARCIMRowid=$P(ArcimDR,"||",1)
	   s ARCIMSub=$P(ArcimDR,"||",2) 
	   s packUomId=$p($g(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	   s packuom=$P(^CT("UOM",packUomId),"^",2)
	   q packuom
}

ClassMethod GetArcimBasinfo(Oew, OrdSub, exchl = "") As %String
{
  	s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	e  s PriorDes=""
	s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	s Doctor=$p($g(^CTPCP(DoctorDr,1)),"^",2)
	s OrdType=##class(web.DHCPdaNurComm).GetOrdType(Oew,OrdSub)
	s Notes=""
	f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	.i $G(Notes)="" s Notes=""
	s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	i (PHFreqDR'="") d
	.if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	.e  s PHFreq=""
	e  s PHFreq=""  ;table       PHC_Freq
	s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	e  s UOM="" 
	s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)
	if PackNum'="" s Pack=PackNum_""_..GetPackUom(Oew,OrdSub)
	e  s Pack=""
	s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
	s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	e   s Meth=""
	s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
	e  s During=""  ;           period of treatment
	s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	s Recloc=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)
	if Recloc'="" s RecDesc=$P(^CTLOC(Recloc),"^",2)
	s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	e  s OrdStat=""  ;ord status
	s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)
	i XDate'="" s XDate=$ZD(XDate,3)
	s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)
	i XTime'="" s XTime=$ZT(XTime,2)
	s XCpt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",29)
	i XCpt'="" s XCpt=$P(^CTPCP(XCpt,1),"^",2)
	s SeqNo=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4) 
	if exchl="" 
	{
	s exchl=0 s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl))
	}
	if exchl'="" s exeinfo=##class(web.DHCPdaNurComm).GetExcuteNur(Oew,OrdSub,exchl)
    s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    if abnorm="N" s abnorm=" (-)"
    if abnorm="Y" s abnorm=" (+)"
	s Str=$G(Str)_SeqNo_"^"_..GetArcDes(Oew,OrdSub)_abnorm_"^"_$ZD(OrdDate,3)_" "_$ZT(OrdTime)_"^"_$ZD(StDate,3)_" "_$ZT(StTime)_"^"_Doctor_"^"_PHFreq_"^"_Meth_"^"_DoseQty_UOM_"^"_During_"^"_OrdStat_"^"_Notes_"^"_OrdType_"^"_Pack_"^"_PhQtyOrd_"^"_PriorDes_"^"_$G(exeinfo)_"^"_$P($G(RecDesc),"-",2)_"^"_XDate_"^"_XTime_"^"_XCpt
	q Str
}

ClassMethod GetLongOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLongOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLongOrdExecute(ByRef qHandle As %Binary, Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    s adm=Adm
    s ret=stop
    s stop=$P(ret,"^",1)
    s ant=$P(ret,"^",2)
    //s ^TMP("stop",ant)=""
    
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Oew=""  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
       if StartDate="" s StartDate=+$H
       if EndDate=""  s EndDate=+$H
       if StartDate'="" s StartDate=$ZDH(StartDate,3)
       if EndDate'="" s EndDate=$ZDH(EndDate,3)
       if ChangeDate="0" s StartDate="",EndDate=""
	   s OrdSub="0"  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:(OrdSub="")!(OrdSub="0")  d
       .s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	   .i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	   .e  q     ///PriorDR --10--自备药长期医嘱
	   .s PriorDes="^"_PriorDes_"^"
	   .q:^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes
	   .s OID=##class(web.DHCLONGTIMEORD).GETOID(Oew,OrdSub)
	   .s phtyp=##class(web.DHCPdaLongTimeOrd).Getphtyp(Oew,OrdSub)
	   .q:(phtyp'="抗生素")&(ant'="0")
	   .s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	   .s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
       .s XSTR=##class(web.DHCLONGTIMEORD).PRX(Oew,OrdSub) ;求医生停止医嘱日期时间
       .i OID'="" d 
	   ..s Ow=$P(OID,",",1)
	   ..s cl=$P(OID,",",2)
	   ..if $G(XSTR)'="" d
	   ...s ^TMP("XDATE",Ow,cl,OrdDate,OrdTime)=XSTR
	   ...s XDate(Ow,cl)=$ZD(OrdDate,3),XTime(Ow,cl)=$P(XSTR,"|",2),XCpt(Ow,cl)=$P(XSTR,"|",3)
	   .e  d
	   ..i ($G(XDate(Oew,OrdSub))="")&($P(XSTR,"|",1)'="") d
	   ...s XDate(Oew,OrdSub)=$ZD(OrdDate,3),XTime(Oew,OrdSub)=$P(XSTR,"|",2),XCpt(Oew,OrdSub)=$P(XSTR,"|",3) 
	   ...s ^TMP("XDATE",Oew,OrdSub,OrdDate,OrdTime)=XSTR
	   .s ODate=$P($G(^OEORD(Oew,"I",OrdSub,8)),"^",14) ;长期医嘱开医嘱日期
       .q:ODate'=""	
       .s Seq=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;Oeori_SeqNo
       .if $P(Seq,".",2)'="" d
       ..s Seq1=$P(Seq,"."),Seq2=$P(Seq,".",2)
       .e  s Seq1=$P(Seq,"."),Seq2=0
       .s ARCIMDesc(Oew,OrdSub)=..GetArcDes(Oew,OrdSub)
       .s ORD(OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
       .
       .

	   s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	   ..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	   ...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	   ....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	   .....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	   ......s XCpt=""
	   ......s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
	   ......if XCpt'=""  d
	   .......s xstr=##class(web.DHCLONGTIMEORD).GetXDate(rw,chl)
	   .......s XDate=$E($P(xstr,"|",1),6,10),XTime=$P(xstr,"|",2),XCpt=$P(xstr,"|",3)
	   ......q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
       ......s ARCIMDesc=ARCIMDesc(rw,chl)
       ......if XCpt'="" s ARCIMDesc="¤¤¤"_ARCIMDesc
       ......if Seq2'="0"  s ARCIMDesc="●"_ARCIMDesc
	   ......s ORW=rw_"||"_chl
	   ......s ^TMP=stop
	   ......if ($G(stop)="0")&($G(XCpt)'="") q
	   ......s SDate=$P($G(^OEORD(rw,"I",chl,1)),"^",9)
	   ......i SDate'="" s SDate=$E($ZD(SDate,3),6,10)
	   ......s STime=$P($G(^OEORD(rw,"I",chl,1)),"^",10)
	   ......i STime'="" s STime=$ZT(STime,2)
	   ......s CptDr=$P($G(^OEORD(rw,"I",chl,1)),"^",11)
       ......if CptDr'="" s Cpt= $P(^CTPCP(CptDr,1),"^",4)
	   ......e  s Cpt=""
	   ......d OutPut
           

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb(ARCIMDesc,ORW,SDate,STime,Cpt,XDate,XTime,XCpt)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod Getphtyp(Oew, OrdSub) As %String
{
  //       s a=##class(web.DHCPdaLongTimeOrd).Getphtyp(894,2)

  	   s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   s ARCIMRowid=$P(ArcimDR,"||",1)
	   s ARCIMSub=$P(ArcimDR,"||",2) 
	   s phm=$p($g(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",12)
	   q:phm="" ""
       s phsub=$P(^PHCD(+phm,1),"^",3)
       s phcat=$P(^PHCC(+phsub),"^",2)
       q phcat
}

ClassMethod GetLongOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLongOrdExecute ]
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

Query GetLongOrd(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %Query(ROWSPEC = "ARCIMDesc,ORW,SDate,STime,Cpt,XDate,XTime,XCpt")
{
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

ClassMethod GetOrdLongData(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %String
{
  // n (Adm, StartDate, EndDate, ChangeDate, stop)
   s QueryName="web.DHCPdaLongTimeOrd:GetLongOrd"
   //q "web.DHCNURPDAQUEXCUTE:GetPatOrdItem"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Adm, StartDate, EndDate, ChangeDate, stop)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>100  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

}
