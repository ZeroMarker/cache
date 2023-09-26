Import sqluser

Class web.DHCSTPhaCheckPresc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetInPhaPrescHX(stdate, enddate, ctloc)
{
	 ///Description:构造发退药处方号串(与老HIS处方号串作比较)
	 ///Input: stdate -- 发退药日期   ,  ctloc -- 发退药科室
	 ///Creator:lq 2008-11-12
	 ///Retrun:发退药处方号数量
	 n (stdate, enddate, ctloc) 
	 ;s phl=""
	 ;s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	 ;i phl="" q 0
	 s pid=$I(^DHCSTCHKPRE("Presc"))
	 s phl=ctloc
	 i '$d(^DHCPHAC(0,"PHA",phl)) q 0
	 i stdate'="" s stdate=$zdh(stdate,3)
	 i stdate="" q 0
	 ;q:stdate'>"61335" 0
	 s t=0
	 k ^CACHETMPALLTAILPH
	 ///Description:发药信息
	 s phac=""
	 f  s phac=$o(^DHCPHAC(0,"PHA",phl,"DATE",stdate,phac)) q:phac=""  d
	 .s oeori="",ord="",itm="",arcim="",inci="",incicode="",prescno="",qty=""
	 .s phadate=$p(^DHCPHAC(phac),"^",2)
	 .s tmpdate=phadate
	 .i phadate'="" s phadate=$zd(phadate,4)
	 .s phatime=$p(^DHCPHAC(phac),"^",3)
	 .s tmptime=$zth("18:45",1)
	 .;q:(phatime'="")&(phatime'>tmptime)&(tmpdate="61336")
	 .;s ^lq(phatime,tmptime,tmpdate)=""
	 .i phatime'="" s phatime=$zt(phatime,1)
	 .s dispno=$p(^DHCPHAC(phac),"^",14)
	 .s chl=""
	 .f  s chl=$o(^DHCPHAC(phac,"I",chl)) q:chl=""  d 
	 ..s prescno=$p(^DHCPHAC(phac,"I",chl),"^",5)
	 ..s prescno=prescno_phac
	 ..s qty=$p(^DHCPHAC(phac,"I",chl),"^",6)
	 ..s oeori=$p(^DHCPHAC(phac,"I",chl),"^",7)
	 ..s ord=$p(oeori,"||",1)
     ..s itm=$p(oeori,"||",2)
     ..s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
     ..s inci=..GetINCI(arcim)   
     ..s incicode=$p(^INCI(inci,1),"^",1)
     ..s adm=$P(^OEORD(ord),"^",1)
     ..s data1=..PaInfo(adm)
     ..;s patloc=$p(data1,"^",10)
     ..s patloc=$p(^DHCPHAC(phac,"I",chl),"^",11)
     ..s index="I"_dispno_adm_patloc
     ..
     ..i '$d(^TMP(pid,index)) d
     ...s t=t+1
     ...s ^CACHETMPALLTAILPH(t)="1^"_phac_"^"_index_"^"_phadate_"^"_phatime_"^"_incicode_"^"_qty
     ...;i index="I0812070116242959715" s ^lqq(index)=""
     ...s ^TMP(pid,index)=""
     ...;s ^lq(pid,index)=""
   
     
     ///Description:退药信息
     s pharet=""
     f  s pharet=$o(^PHARET(0,"RECLOC",phl,stdate,pharet)) q:pharet=""  d
     .s retno=$p(^PHARET(pharet),"^",16)
     .i '$d(^TMP(pid,"dhcpha",retno)) d
     ..s ^TMP(pid,"dhcpha",retno)=pharet
     .e  d 
     ..s ^TMP(pid,"dhcpha",retno)=^TMP(pid,"dhcpha",retno)_"^"_pharet
     
     s retno=""
     f  s retno=$o(^TMP(pid,"dhcpha",retno)) q:retno=""  d
     .;i $d(^TMP(pid,"dhcpharet")) k ^TMP(pid,"dhcpharet")
     .s str=^TMP(pid,"dhcpha",retno)
     .s cnt=$l(str,"^")
     .f k=1:1:cnt d
     ..s retRowid=$p(str,"^",k)
     ..
     ..s oeori="",ord="",itm="",arcim="",inci="",incicode="",prescno="",qty="" 
     ..s prescno=$p(^PHARET(retRowid),"^",11)
     ..s phadr=$p(^PHARET(retRowid),"^",23)
     ..s phadr=+phadr
     ..s dispno=$p(^DHCPHAC(phadr),"^",14)
     ..;s prescno="-"_prescno_phadr
     ..s prescno=prescno_phadr
     ..s retdate=$p(^PHARET(retRowid),"^",1)
     ..s tmpdate=retdate
     ..i retdate'="" s retdate=$zd(retdate,3)
     ..s rettime=$p(^PHARET(retRowid),"^",2)
     ..s tmptime=$zth("18:45",1)
     ..;q:(rettime'="")&(rettime'>tmptime)&(tmpdate="61336")
     ..i rettime'="" s rettime=$zt(rettime,1)
     ..s qty= $p(^PHARET(retRowid),"^",12)
     ..s oeori=$p(^PHARET(retRowid),"^",5)
     ..s ord=$p(oeori,"||",1)
     ..s itm=$p(oeori,"||",2)
     ..s adm=$P(^OEORD(ord),"^",1)
     ..s data1=..PaInfo(adm)
     ..;s patloc=$p(data1,"^",10)
     ..s patloc=$p(^PHARET(retRowid),"^",7)
     ..s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
     ..s inci=..GetINCI(arcim)
     ..s incicode=$p(^INCI(inci,1),"^",1)
     ..s index="I"_dispno_adm_patloc_retno
     ..i '$d(^TMP(pid,index)) d
     ...s t=t+1
     ...s ^CACHETMPALLTAILPH(t)="2^"_retno_"^"_index_"^"_retdate_"^"_rettime_"^"_incicode_"^"_qty
     ...s ^TMP(pid,index)=""
     ...;s ^lq(pid,index)=""
     
     
     k ^TMP(pid)
	 q t
}

ClassMethod GetINCI(arcim As %String) As %String
{
 ///Description:根据医嘱项rowid取得库存项目的rowid
 n (arcim)
 s ARCIMsub=$p(arcim,"||",1)
 s ARCIMsub=$p(ARCIMsub,$c(1))
 s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
 q $g(INCIrow)
}

ClassMethod PaInfo(adm) As %String
{
 //取病人的相关信息
 n (adm)
 q:adm="" ""
 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
 s admtype=$p($g(^PAADM(adm)),"^",2) 
 s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
 s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",2)
 ;s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 ;s age=+$h-dob   ;days of age
 s age=##class(web.DHCSTKUTIL).GetAge(papmidr) ;PA_PatMas PAPMI_RowId 
 s ward=$p($g(^PAADM(adm)),"^",70)
 s bed=$p($g(^PAADM(adm)),"^",73)
 s wardcode="",warddesc="",bedno=""
 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2)
 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1)  
 s padocno=$P(^PAPER(papmidr,"PAT",3),"^",4) ;登记号
 s deptdr=$p($g(^PAADM(adm)),"^",4) 
 ;
 s result=pano_"^"_adm_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_admtype_"^"_deptdr
 q result
}

ClassMethod ReSendInPha(phdrowids As %String) As %String
{
	///Description:重新发送发退药信息至老HIS for 华西
	///Creator: lq
	q:phdrowids="" "0"
	s itmp=""
	f i=1:1:$l(phdrowids,"^")
	{
		s phdrowidstr=$p(phdrowids,"^",i)
		i phdrowidstr'=""
		{

			s phdtype=$p(phdrowidstr,"||",1)
			s phdrowid=$p(phdrowidstr,"||",2)
			NEW $ESTACK
			SET $ZTRAP="OnReSendPhaError"

		 	s PHAPrescnoStrings=""
		 	s itmp="1"
			d doReSendPha(phdtype,phdrowid)
		}
	}
	if itmp="1"
	{
		hang 5
	}
	q "0"
doReSendPha(phdtype,phdrowid)

    s err=##class(web.DHCSTInPhaInterFace).PutMessagePharmacy(phdtype,phdrowid)
	Quit
OnReSendPhaError
	Quit
}

}
