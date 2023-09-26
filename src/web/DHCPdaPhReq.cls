Import SQLUser

Class web.DHCPdaPhReq Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 110;

ClassMethod GetIpOutRec(ord, itm) As %String
{
  ;根据就诊号取已发药且医嘱已停的记录
	//n (admno,locdr)
	k ^TMP($j,"DISP")
	s i=0
	q:admno="" 0
	s admno=$$ALPHAUP^SSUTIL4(admno)
	s adm=$o(^PAADMi("No",admno,"")) q:adm="" 0
	s visitstatus=$p(^PAADM(adm),"^",20)
	q:visitstatus="D" 0
	s ord=$o(^OEORD(0,"Adm",adm,"")) q:ord="" 0
	s itm=0 
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	. 
	. s recdepdr=$p(^OEORD(ord,"I",itm,3),"^",6) 
	. q:recdepdr'=locdr   ; not the receieve loc
	. s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	. s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	. s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
	. i unit'="" s unit=$p(^CT("UOM",unit),"^",2)
	. s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	. i freq'="" s freq=$p(^PHCFR(freq),"^",1)
	. s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	. s itemcode=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",1)
	. s itemdesc=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",2)
	. s Drcode="",Drname=""
	. s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	. i (doctor'="") d
	. . i $d(^CTPCP(doctor,1)) s Drcode=$p(^CTPCP(doctor,1),"^",1),Drname=$p(^CTPCP(doctor,1),"^",2)
	. s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	. s time=$p(^OEORD(ord,"I",itm,1),"^",17)
	. s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	. 
	. s orditemrowid=ord_"||"_itm
	. s orditmstatus=$p(^OEORD(ord,"I",itm,1),"^",13)
	. i orditmstatus'="" s orditmstatus=$p(^OEC("OSTAT",orditmstatus),"^",1)
	. q:orditmstatus'="D"         ; stoped order item
	. s exe=0  f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:exe=""  d
	. . s dsp=0  f  s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) q:dsp=""  d
	. . . s dspqty=+$p(^(dsp),"^",1),retqty=+$p(^(dsp),"^",7)
	. . . s dspqty=dspqty-retqty
	. . . q:dspqty=0      ;20060713
	. . . s status=$p(^(dsp),"^",6)
	. . . q:status'="C"
	. . . s inclb=$p(^(dsp),"^",2)
	. . . s dsprowid=ord_"||"_itm_"||"_exe_"||"_dsp
	. . . 
	. .	. s buom=$p($g(^INCI(+inclb,1)),"^",10)  ;2007-0406
	. .	. s buomdesc=$p(^CT("UOM",buom),"^",2) ;2007-0406
	. .	. s unit=buomdesc ;2007-0406
	. .	. 
	. .	. s i=i+1
	. .	. s info1=itemcode_"^"_itemdesc_"^"_freq_"^"_dspqty_"^"_unit
	. .	. s info2=doseqty_"^"_prescno_"^"_Drcode_"^"_Drname_"^"_orddate
	. .	. s info3=time_"^"_dsprowid_"^"_orditemrowid_"^"_sttdate_"^"_inclb
	. .	. s info4=arcim_"^"_orditmstatus
	. .	. s ^TMP($j,"DISP",i)=info1_"^"_info2_"^"_info3_"^"_info4
    q i
}

ClassMethod GetPhRet(ord, itm)
{
}

ClassMethod GetPatInfo(oeordId) As %String
{
   n (oeordId)
   	s admId=$p($g(^OEORD(oeordId)),"^",1)
    s papmiId=+^PAADM(admId)
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i curWardId'="" s wardLoc=$p(^PAWARD(curWardId),"^",5)
    
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
   /// s admno=$p(^PAADM(admId),"^",4)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    q admId_"^"_$G(regNo)_"^"_$G(patName)_"^"_$G(DocDes)_"^"_ctlocDesc_"^"_$G(wardDesc)_"^"_$G(bedCode)_"^"_wardLoc_"^"_curWardId_"||"_bedSub_"^"_ctlocId
    
    //$g(admno)_"^"_$g(admloc)_"^"_$g(ward)_"^"_$g(admdoctor)
}

Query GetPhRetDataByRow(OrRowId As %String) As %Query(ROWSPEC = "Rw,RegNo,PatName,adm,ward,Drcode,Drname,bedno,prescno,itmdesc,dspqty,unit,retqty,doseqty,reqqty,count,price,dsprowid,statue,orditmstatus,madeuser,madeDateTime,updateUser,UpdateDateTime,RecLoc")
{
}

ClassMethod GetPhRetDataByRowExecute(ByRef qHandle As %Binary, OrRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	 s ord=+OrRowId
 	 s patinfo=..GetPatInfo(ord)
 	 s PatName=$P(patinfo,"^",3)
 	 s RegNo=$P(patinfo,"^",2)
 	 s ward=$P(patinfo,"^",6)
 	 s bedNo=$P(patinfo,"^",7)
 	 s adm=$P(patinfo,"^",1)
 	 s doc=$P(patinfo,"^",4)
 	 s itm=$P(OrRowId,"||",2)
     s recdepdr=$p(^OEORD(ord,"I",itm,3),"^",6) 
     if recdepdr'="" s RecLoc=$P(^CTLOC(recdepdr),"^",2)
	 //q:recdepdr'=locdr   ; not the receieve loc
	 s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	 s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	// s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
	// i unit'="" s unit=$p(^CT("UOM",unit),"^",2)
	 s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	 i freq'="" s freq=$p(^PHCFR(freq),"^",1)
	 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	 s itemcode=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",1)
	 s itemdesc=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",2)
	 s Drcode="",Drname=""
	 s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	 i (doctor'="") d
	 . i $d(^CTPCP(doctor,1)) s Drcode=$p(^CTPCP(doctor,1),"^",1),Drname=$p(^CTPCP(doctor,1),"^",2)
	 s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	 s time=$p(^OEORD(ord,"I",itm,1),"^",17)
	 s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	 s orditemrowid=ord_"||"_itm
	 s orditmstatus=$p(^OEORD(ord,"I",itm,1),"^",13)
	 i orditmstatus'="" s orditmstatus=$p(^OEC("OSTAT",orditmstatus),"^",1)
	 if orditmstatus'="D"  Quit $$$OK      ; stoped order item
	 s exe=0  f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:exe=""  d
	 . s dsp=0  f  s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) q:dsp=""  d
	 .. s dspqty=+$p(^(dsp),"^",1),retqty=+$p(^(dsp),"^",7)
	 .. s spqty=dspqty-retqty
	 .. q:spqty=0      ;20060713
	 .. s status=$p(^(dsp),"^",6)
	 .. q:status'="C"
	 .. s inclb=$p(^(dsp),"^",2)
	 .. s inci=+inclb
	 .. s dsprowid=ord_"||"_itm_"||"_exe_"||"_dsp
	 .. s par=ord_"||"_itm_"||"_exe_"||"_dsp
	 .. s buom=$p($g(^INCI(+inclb,1)),"^",10)  ;2007-0406
	 .. s buomdesc=$p(^CT("UOM",buom),"^",2) ;2007-0406
	 .. s unit=buomdesc ;2007-0406
     .. s ret=..GetStatPh(par)
	 .. if ret="false" d GetReqData(par)
	 .. q:ret="false"  //等于false时 已申请过
	 .. s price=##class(web.DHCSTCOMMONSRV).GetPrice(inci,+$h,"","")
	 .. s count=0
	 .. s reqqty=0
	 .. s statue="Prove"
	 .. b
	 .. s rw=""
	 .. d OutRowtyp
	 Quit $$$OK

GetReqData(disp)
   s rw=""  f  s rw=$O(^RETRQ(0,"OEDIS",disp,rw)) q:rw=""  d
   .q:'$D(^RETRQ(rw))
   .s reqqty=$P(^RETRQ(rw),"^",11)
   .s price=$P(^RETRQ(rw),"^",12)
   .s count=$P(^RETRQ(rw),"^",13)
   .s statue=$P(^RETRQ(rw),"^",14)
   .q:statue'="Prove"
   .s OperUser=$P(^RETRQ(rw),"^",15)
   .if OperUser'="" s OperUser=$P(^SSU("SSUSR",OperUser),"^",2)
   .s OperDatTime=$ZD($P(^RETRQ(rw),"^",16),4)_" "_(+$ZT($P(^RETRQ(rw),"^",17),2))
   .s UpdateUser=$P(^RETRQ(rw),"^",18)
   .if UpdateUser'="" s UpdateUser=$P(^SSU("SSUSR",UpdateUser),"^",2)
   .s UpDatTim=$ZD($P(^RETRQ(rw),"^",19),4)_" "_(+$ZT($P(^RETRQ(rw),"^",20),2))
   .d OutRowtyp

 Quit $$$OK
OutRowtyp
	set Data=$lb(rw,RegNo,$g(PatName),adm,ward,Drcode,Drname,bedno,prescno,itemdesc,dspqty,unit,retqty,doseqty,reqqty,count,price,dsprowid,statue,orditmstatus,OperUser,OperDatTime,UpdateUser,UpDatTim,RecLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhRetDataByRowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhRetDataByRowExecute ]
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

ClassMethod GetPhRetDataByRowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhRetDataByRowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetStatPh(disp) As %String
{
 //不存在 或 存在且被取消,或部分退
	s ret="false"
	i $D(^RETRQ(0,"OEDIS",disp)) d
	.s rw=$O(^RETRQ(0,"OEDIS",disp,""),-1)
	.s stat=$P(^RETRQ(rw),"^",14)
	.b
	.if (stat="Ignore")!(stat="Execute") s ret="true"
	.else  s ret="false"
    e  s ret="true"
    q ret
}

ClassMethod GetDrugTypeByDsprowid(dsprowid As %String) As %String
{
                               ;根据发药rowid取类型
    //&sql(select phaci_phac_parref->dhc_phacollect_rowid,
       //               phaci_phac_parref->dhc_phaordtype
     //                 into  :crowid,:type
      //       from SQLUser.dhc_phacollectitm where phaci_oedis_dr=:dsprowid )  
   q $g(type)
}

ClassMethod GetOldReqno(DspDR As %String) As %String
{
   n (DspDR)
   s patinfo=..GetPatInfo(+DspDR)
   s ward=$p(patinfo,"^",8)
   s ord=$p(DspDR,"||",1),itm=$p(DspDR,"||",2),exe=$p(DspDR,"||",3),dsp=$p(DspDR,"||",4)
   s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
   s date=+$H
   
   s rw="" f  s rw=$O(^RETRQ(0,"Date",date,rw)) q:rw=""  d
   .s statue=$P(^RETRQ(rw),"^",14)
   .q:statue'="Prove"
   .s wardId=$P(^RETRQ(rw),"^",7)
   .q:wardId'=ward
   .s RecLocId=$P(^RETRQ(rw),"^",2)
   .q:RecLocId'=recloc
   .s ReqNo=$P(^RETRQ(rw),"^",1)
	//s ctlocDR=##class(web.DHCSTCOMMONSRV).LocToRowID(ctloc)
	//s reclocDR=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
	//&sql(select  max(retrq_reqno) into :rrno from dhc_pharetrequest where retrq_status="Prove"
   //and  retrq_dept_dr =:ward  and  retrq_recloc_dr=:reclocDR
	//    and  retrq_drugform =:drugsort)
	if $G(ReqNo)="" s ReqNo="-1"
	q $G(ReqNo)
}

ClassMethod GetMaxRetReqNo() As %String
{
	n xx 
	s xx=..GetRetReqNo1("PDA")   ;the word like "TJ" must be two-char length0796138
	q xx
}

ClassMethod GetRetReqNo1(prefix As %String) As %String
{
	s no=$I(^DHCSTPHARMACY("RETREQUEST"))
	s P0=prefix_$tr($j(no,8)," ","0")
	q P0
}

ClassMethod UpdateQty(rowid, qty, user As %String) As %String
{
	n (rowid, qty, user)
	q:rowid="" -1
	s updatedate=+$h,updatetime=$p($h,",",2)
	s SQLCODE=0
	s stat="Prove"
	&sql(update dhc_pharetrequest set retrq_qty=:qty,retrq_updateuser_dr=:user,
	            retrq_updatedate=:updatedate,retrq_updatetime=:updatetime
	             where retrq_rowid=:rowid and retrq_status=:stat)
	q:SQLCODE -2
	q 0
}

ClassMethod ChangeStat(rowid As %String, Stat As %String, user As %String) As %String
{
	n (rowid, Stat, user)
	q:rowid="" -1
	s updatedate=+$h,updatetime=$p($h,",",2)
	s SQLCODE=0
	&sql(update dhc_pharetrequest set retrq_status=:Stat,retrq_updateuser_dr=:user,
	            retrq_updatedate=:updatedate,retrq_updatetime=:updatetime
	             where retrq_rowid=:rowid )
	q:SQLCODE -2
	q 0
}

ClassMethod InsDetail2(sdata As %String) As %String
{
	n (sdata)
	//"PDA00000002^2787387^2534435||1006||1||1^I080128000001^1^3.43^2"
	//s sdata="PDA00000002^2787387^2534435||1006||1||1^I080128000001^1^3.43^2"
	s ReqNO=$p(sdata,"^",1)
	s adm=$P(sdata,"^",2)
	s DspDR=$P(sdata,"^",3)
	s ord=$p(DspDR,"||",1),itm=$p(DspDR,"||",2),exe=$p(DspDR,"||",3),dsp=$p(DspDR,"||",4)
	s DspDR=ord_"||"_itm_"||"_exe_"||"_dsp
	s PrescNo=$p(sdata,"^",4)       
	s RetQty=$p(sdata,"^",5)
	s DoctorDR=$p(^OEORD(ord,"I",itm,1),"^",11)
	s Status="Prove"
	s RecLocDR=$p(^OEORD(ord,"I",itm,3),"^",6) 
	s OperDR=$p(sdata,"^",7)
	s OperDate=+$h
	s OperTime=$p($h,",",2)
	s patinfo=..GetPatInfo(ord)
	
	//q admId_"^"_$G(regNo)_"^"_$G(patName)_"^"_$G(DocDes)_"^"_ctlocDesc_"^"_$G(wardDesc)_"^"_$G(bedCode)_"^"_curWardId_"^"_bedSub_"^"_ctlocId
    s PaNo=$p(patinfo,"^",2)
	s WardLocDR=$p(patinfo,"^",8)
	s BedDR=$p(patinfo,"^",9)
	s AdmDR=adm
	s AdmLocDR=$p(patinfo,"^",10)
	;
	s AdmNo=$p(^PAADM(AdmDR),"^",81)  ;adm no
	;
	s ModifiedDR=OperDR              ;same as oper
	s ModifiedDate=OperDate
	s ModifiedTime=OperTime
	;
	;s ^TMP("xxxxxxxx")=sdata
	s reasondr=""  ;退药原因
	
	
	s INCLB=$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",2)  ; inclb
	s dspdate=+$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",4) ; dispensing date
	s inci=+INCLB
	;s Sp=+$$GetPrice^DHCSTCOMMONSRV(inci,dspdate,"","")
	s Sp=##class(web.DHCSTCOMMONSRV).GetPrice(inci,+$h,"","")
	s Amount=+(Sp*RetQty)
	//,RETRQ_REASON_DR:reasondr
	&sql(insert into dhc_pharetrequest(retrq_reqno,retrq_recloc_dr,retrq_pano,retrq_adm_no,
	       retrq_paadm_dr,retrq_dept_dr,retrq_bed_dr,retrq_oedis_dr,retrq_prescno,
	       retrq_qty,retrq_sprice,retrq_samount,retrq_status,retrq_operuser_dr,retrq_operdate,
	       retrq_opertime,retrq_updateuser_dr,retrq_updatedate,retrq_updatetime,retrq_admloc_dr,
	       retrq_sprice,retrq_samount) 
	       values(:ReqNO,:RecLocDR,:PaNo,:AdmNo,:AdmDR,
	       :WardLocDR,:BedDR,:DspDR,:PrescNo,:RetQty,:Sp,:Amount,:Status,:OperDR,
	       :OperDate,:OperTime,:ModifiedDR,:ModifiedDate,:ModifiedTime,:AdmLocDR,
	        :Sp,:Amount))
	s ^RETRQ(0,"OperDate",OperDate,$g(%ROWID))=""
	s ^RETRQ(0,"Paadm",AdmDR,$g(%ROWID))=""
	q $g(%ROWID)
}

ClassMethod GetReqData(Disp As %String) As %String
{
 n (Disp)
 //RegNo,$g(PatName),adm,ward,Drcode,Drname,bedno,prescno,itemdesc,dspqty,unit,retqty,doseqty,reqqty,count,price,dsprowid,statue,orditmstatus
   s rw=""  f  s rw=$O(^RETRQ(0,"OEDIS",Disp,rw)) q:rw=""  d
   .s ReqNum=$P(^RETRQ,"^",11)
   .s Price=$P(^RETRQ,"^",12)
   .s Amount=$P(^RETRQ,"^",13)
   .s statu=$P(^RETRQ,"^",14)
   .s OperUser=$P(^RETRQ,"^",15)
   .s OperDatTime=$ZD($P(^RETRQ,"^",16),4)_" "_$ZT($P(^RETRQ,"^",17),3)
   .s UpdateUser=$P(^RETRQ,"^",18)
   .s UpDatTim=$ZD($P(^RETRQ,"^",19),4)_" "_$ZT($P(^RETRQ,"^",20),3)
   q ReqNum_"^"_Price_"^"_Amount_"^"_statu_"^"_OperUser_"^"_OperDatTime_"^"_UpdateUser_"^"_UpDatTim
}

Storage Default
{
<Data name="DHCPdaPhReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPdaPhReqD</DataLocation>
<DefaultData>DHCPdaPhReqDefaultData</DefaultData>
<IdLocation>^web.DHCPdaPhReqD</IdLocation>
<IndexLocation>^web.DHCPdaPhReqI</IndexLocation>
<StreamLocation>^web.DHCPdaPhReqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
