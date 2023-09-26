Import SQLUser

Class web.DHCSTIMPTOOL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ImpSalePrice(filename, userinitial, inaspno)
{
	//Import the sale price into IN_AdjSalePrice
	;fname : the filename including data
	;   -1-----2-----3------4------
	;   code  desc  uom  saleprice 
	
	;s filename="e:\cv.txt" 
	;s user="demo" 
	;s inaspno="TJ2005083001"
	;
	;get the rowid of the user
	&sql(select ssusr_rowid into :user from ss_user where ssusr_initials=:userinitial)
	q:SQLCODE -1 
	
	s user=$g(user)
 
	q:filename="" -1
	s del="^"
	s sub="INASP"
	;read all records from file
	d ..file(filename,sub)
	d ..locup1(user,inaspno)
	k ^zTSA($j,sub)
	q 0
}

ClassMethod file(file, sub)
{
	 ;process file
	;
	k ^zTSA($j,sub),^TMP($j,sub)
	;directory where files are 
	s del="^"
	s file=file
	;w "File Upload Starting...",!
	d $ZUTIL(68,40,1)
	o file:"RS"
	u file
	f   q:($ZEOF=-1)  d
	. r a
	. s line=$o(^zTSA($j,sub,""),-1)+1
	. q:a=""
	. s ^zTSA($j,sub,0)=line
	. s ^zTSA($j,sub,line)=$tr(a,$c(9),del)
	c file
	;w "File Upload Finished!",!!
	q
}

ClassMethod locup1(user, inaspno)
{
  ;
	;
	;s user="1" 
	;s inaspno="TJ2005083001"
	;
	s sub="INASP",del="^"
	i $o(^zTSA($j,sub,""),-1)<1 q
	;
	s i=0,j=0
	s ind=0,cnt=0 f  s ind=$o(^zTSA($j,sub,ind)) q:ind=""  d
	. ;s s=$tr($tr(s," ",""),"""","")
	. s s=^(ind)
	. s code=$p(s,del,1)
	. s desc=$p(s,del,2)
	. q:code="" ; ;
	. s uom=$p(s,del,3)    ; ; unit of sp
	. s saleprice=+$p(s,del,4)  ; ; sale price
	. i ..InsertAdjSP(user,inaspno,code,uom,saleprice)'=0 d
	. . s j=j+1
	. . s ^TMP($j,"IMPINASP",j)=code_"^"_desc_"^"_uom_"^"_saleprice
	. e  d
	. . s i=i+1
	. . w "."
	. . 
	k ^zTSA($j,sub)
}

ClassMethod InsertAdjSP(user, inaspno, itmcode, uom, spuom)
{
	        
	n (user,inaspno,itmcode,uom,spuom)
    q:inaspno="" -1
	s adjdate=+$h   ;
	s exedate=+$h
	;
	s itmrowid=##class(web.DHCSTCOMMONSRV).ItemCodeToID(itmcode) ;
	q:itmrowid="" -2
	s cat=##class(web.DHCSTITMDESC).GetItmCat(itmcode)
	s basicuo=+$p(^INCI(itmrowid,1),"^",10)     
	;
	s adjuo=##class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
	q:$g(adjuo)="" -3
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(adjuo,basicuo)     ;factor 
	q:$g(fac)="" -4
	s priorsp=0
	q:(+fac<1) -5
	s basicsp=+(spuom/fac)                ;sp of basic uom
	s status="Yes"
	s SQLCODE=0
	&sql(insert into in_adjsaleprice(inasp_date,inasp_executedate,
	      inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,inasp_resultsp,inasp_ssusr_dr,
	     inasp_status,inasp_no,inasp_ctuom_dr,inasp_ctuom_price) 
	     values(:adjdate,:exedate,:itmrowid,:cat,:priorsp,:basicsp,
	            :user,:status,:inaspno,:adjuo,:spuom) )
	q SQLCODE
}

ClassMethod ImpLocDaily(loc As %String) As %Integer
{
	;  s loc="zyyf-住院药房" 
	; s loc="mzxy-门诊西药"
	;  s loc="mzzy-门诊中药"
	  s loc="mzcy-门诊草药"  
	s loc=##class(web.DHCSTCOMMONSRV).LocToRowID(loc)  q:loc="" -1
	n INCI,ILCH,LBCH,CH
	s today=+$h
	s INCI=""
	s i=0
	f  s INCI=$O(^INCI("IL_LOC",loc,INCI)) q:INCI=""  d
	 . s ILCH=0
	 . f  s ILCH=$o(^INCI("IL_LOC",loc,INCI,ILCH)) q:ILCH=""  d
	 . . q:'$d(^INCI(INCI,"IL",ILCH)) 
	 . . s logqty=$p(^INCI(INCI,"IL",ILCH),"^",3)  ; log qty
	 . . s begqty=0,endqty=logqty
	 . . s i=i+1
	 . . &sql(insert into DHC_LocDailytotal (day_itm_dr,day_loc_Dr,day_qtybeg,day_qtyend,day_date)
	                values (:INCI,:loc,:begqty,:endqty,:today) )
	 . . q:SQLCODE'=0
	 . . s MROWID=+%ROWID 
	 . . q:MROWID=""
	 . .  
	 . . s LBCH=0 
	 . . f  s LBCH=$o(^INCI(INCI,"IL",ILCH,"LB",LBCH)) q:LBCH=""  d
	 . . . s phyqty=$p(^INCI(INCI,"IL",ILCH,"LB",LBCH),"^",2)  ; phyqty
	 . . . s INCLB=INCI_"||"_ILCH_"||"_LBCH
	 . . . s lbbegqty=0,lbendqty=phyqty
	 . . . s CH=$o(^DHCBTLOCTOT(MROWID,"I",""),-1)
	 . . . s CH=CH+1
	 . . . &sql(insert into DHC_LocBtDailytotal(
	                        daybt_parref,daybt_childsub,daybt_bat_dr,daybt_qtybeg,daybt_qtyend,daybt_date,daybt_loc_dr)
	                 values (:MROWID,:CH,:INCLB,:lbbegqty,:lbendqty,:today,:loc))
	 . . .q:SQLCODE'=0
	q i
}

ClassMethod CheckDrugTar()
{
	s inci=0
	s n=0
	f  s inci=$o(^INCI(inci))  q:+inci<1  d
	. s incicode=$p(^INCI(inci,1),"^",1)
	. s incidesc=$p(^INCI(inci,1),"^",2)
	. s arcim=$p(^INCI(inci,1),"^",3)
	. s (a,b,c,d)=""
	. i arcim'="" d
	. . &sql(select arcim_code,arcim_desc into :a,:b from arc_itmmast where arcim_rowid=:arcim)
	. . q:SQLCODE
	. . s x2=""
	. . &sql(select olt_tariff_dr into :x2 from DHC_OrderLinkTar where olt_arcim_dr=:arcim)
	. . q:SQLCODE
	. . i x2'="" d
	. . . &sql(select tari_code,tari_desc into :c,:d from dhc_taritem where tari_rowid=:x2)
	. . . 
	. . 
	. s n=n+1
	. s ^TMP($j,"INCIORDERTAR",n)=incicode_"^"_incidesc_"^"_a_"^"_b_"^"_c_"^"_d
	.  
	.  
   q n
}

ClassMethod UpdatePass(usercode, pass) As %String
{
	s pass=$$ENCR^SSUTIL2(pass)
	&sql(update ss_user set ssusr_password=:pass where ssusr_initials=:usercode)
	q SQLCODE
}

}
