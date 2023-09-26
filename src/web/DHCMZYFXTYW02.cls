Import SQLUser

Class web.DHCMZYFXTYW02 Extends %Library.RegisteredObject
{

Parameter BUILD = 47;

ClassMethod GetDMWin(recploc)
{
  s recphl="",recphw="",dmphw=""
  s recphl=$o(^DHCPHLOCi("LOC",recploc,""))
  i recphl="" q ""
  f  s recphw=$o(^DHCPHWINi(recphl,recphw)) q:recphw=""  d
    .q:$p(^DHCPHWIN(recphw),"^",4)=1
    .s wintype=$g(^DHCPHWINTYPE(recphw))
    .i wintype="2"  d
	..s dmphw=recphw
  q dmphw
}

ClassMethod CheckDM(win)
{
  s ret="",wintype=""
  s wintype=$g(^DHCPHWINTYPE(win))
  i wintype="2"  s ret="1"
  q ret
}

ClassMethod CheckWinLoc(win)
{
	q ..CheckLocWin(win) //yunhaibao20170602修正,下方global未发现数据来源
	s phwl="",m=0
	f  s phwl=$o(^DHCPHWINLOCi("WIN",win,phwl)) q:phwl=""  d
	.s m=m+1
    q m
}

ClassMethod CheckOpenWin(argwin)
{
 	s phlrow="",openflag=""
 	i argwin="" q 0
 	s phlrow=+$p(^DHCPHWIN(argwin),"^",2)
 	q:$p(^DHCPHWIN(argwin),"^",4)=1 0 //无效
 	;^DHCPHWPi("WINDOW",{PHWP_PHL_DR},{PHWP_PHW_DR}
 	s phwprow=""
 	s phwprow=$o(^DHCPHWPi("WINDOW",phlrow,argwin,""))
 	i phwprow="" q 0
 	s openflag=$p(^DHCPHWP(phwprow),"^",1)
 	i openflag="" s openflag="0"
 	q openflag
}

ClassMethod GetNewCurrWinOLd(ctloc)
{
	 s ctloc=$g(ctloc)
	 s ret=""
	 s phloc="",mathflag="",commit="",currdate="",tjflag=""
	 s currdate=$p($h,",",1)
	 s ll=0
	 s phlrow=""
	 f  s phlrow=$o(^DHCPHLOCi("LOC",ctloc,phlrow)) q:phlrow=""  d
	.s ll=ll+1
	.s mathflag=$p(^DHCPHLOC(phlrow),"^",4)
	.s tjflag=$p(^DHCPHLOC(phlrow),"^",5)
	.s phloc=phlrow
	 s ctlocdesc=""
	 s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	 i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	 i ll=0 q -1     
	 s ww=0,cuwin="",case=0
	 s phwrow=""
	 s phwin="",phwpid="",phwpnextid="",phwindesc="",phnextwin="",phqrwin=""
	 f  s phwrow=$o(^DHCPHWINi("WIN",phloc,phwrow)) q:(phwrow="")!(case=1)  d
	.s ww=ww+1
	   .s okflag="",useflag=""
	   .s useflag=$p(^DHCPHWIN(phwrow),"^",4)
	   .s okflag=$p(^DHCPHWIN(phwrow),"^",3)
	   .q:okflag'="1"
	   .q:useflag="1"
	   .s phwintype=$g(^DHCPHWINTYPE(phwrow))
	   .q:(phwintype=2)!(phwintype=4)
	   .s case=case+1
	   .s phqrwin=phwrow
	 i tjflag'="1"  d
	  .s phwin=phqrwin
	 e  d
	  .i mathflag="1"  d
		..s dd=0
		..s phwprow=""
		..f  s phwprow=$o(^DHCPHWPi(phloc,phwprow)) q:phwprow=""  d
		...s doflag="",ztflag=""
		...s doflag=$p(^DHCPHWP(phwprow),"^",1)
		...q:(doflag'="1")
		...s dd=dd+1
		..i dd=0  d
		...s phwin=phqrwin
		..e  d
		...&sql(select nvl(phcw_phw_dr,'0') into :cuwin from SQLUser.dhc_phcurrwin where phcw_phl_dr=:phloc)
		...s cuwin=$p(cuwin,$c(1),1)
		...i (cuwin="")!(cuwin="0")  d
		....s cuwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc) 
		....s cuwin=$p(cuwin,$c(1),1) 
		....s phwin=cuwin
		....&sql(insert into SQLUser.dhc_phcurrwin(phcw_phw_dr,phcw_phl_dr) values(:cuwin,:phloc)) 
		...e  d
		....s p=0,cuwprow=""
		....f  s cuwprow=$o(^DHCPHWPi("WINDOW",phloc,cuwin,cuwprow)) q:cuwprow=""  d
		.....s doflag="",ztflag=""
		.....s doflag=$p(^DHCPHWP(cuwprow),"^",1)
		.....q:(doflag'="1")
		.....s p=p+1
		....i p=0  d
		.....s phwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc)
		....e  d
		.....s phwin=cuwin 
		...s phnextwin=##CLASS(DHCMZYFXTYW02).GnextWin(phloc,phwin) 
		...&sql(update SQLUser.dhc_phcurrwin set phcw_phw_dr=:phnextwin where phcw_phl_dr=:phloc)
		.e  d
		..s phwpwindr="",n=0,hh=0
	       ..s phwrow=""
	       ..f  s phwrow=$o(^DHCPHWPi("WINDOW",phloc,phwrow)) q:phwrow=""  d
	         ...s phwprow=""
	         ...f  s phwprow=$o(^DHCPHWPi("WINDOW",phloc,phwrow,phwprow)) q:phwprow=""  d
	           ....s phwpl="",phwpdo="",phwpzt=""
	           ....s pp=0
	           ....s phwpl=+$p(^DHCPHWP(phwprow),"^",2)
	           ....q:phwpl'=phloc
	           ....s phwpdo=$p(^DHCPHWP(phwprow),"^",1)
	           ....s phwpzt=$p(^DHCPHWP(phwprow),"^",6)
	           ....q:phwpdo'="1"
	           ....q:phwpzt="1"
	           ....s phwpwindr=$p(^DHCPHWP(phwprow),"^",5)
	           ....s phwpwindr=$p(phwpwindr,$c(1),1)
	           ....s n=n+1
	           ....s pharow=""
	           ....;^DHCPHARWi({PHA_DATE},{PHA_PHL_DR},{PHA_ROWID}) 
	           ....f  s pharow=$o(^DHCPHARWi(currdate,phloc,pharow)) q:pharow=""  d
	             .....s fin="",nouse=""
	             .....s fin=$p(^DHCPHARW(pharow),"^",6)
	             .....s nouse=$p(^DHCPHARW(pharow),"^",7)
	             .....q:fin="1"
	             .....q:nouse="1"
	             .....s pp=pp+1
	         ....i n=1  s hh=pp
	         ....i pp'>hh  d
	           .....s hh=pp,phwin=phwpwindr
	    
	    q phwin
}

ClassMethod GetCurrWin(ctloc)
{
	 s ctloc=$g(ctloc)
	 s ret=""
	 s phloc="",mathflag="",commit="",currdate="",tjflag=""
	 s currdate=$p($h,",",1)
	 s ll=0
	 s phlrow=""
	 f  s phlrow=$o(^DHCPHLOCi("LOC",ctloc,phlrow)) q:phlrow=""  d
	   .s ll=ll+1
	   .s mathflag=$p(^DHCPHLOC(phlrow),"^",4)
	   .s tjflag=$p(^DHCPHLOC(phlrow),"^",5)
	   .s phloc=phlrow
	 s ctlocdesc=""
	 s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	 i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	 i ll=0 q -1     
	 s ww=0,cuwin="",case=0
	 s phwrow=""
	 s phwin="",phwpid="",phwpnextid="",phwindesc="",phnextwin="",phqrwin=""
	 f  s phwrow=$o(^DHCPHWINi("WIN",phloc,phwrow)) q:(phwrow="")!(case=1)  d
	   .s ww=ww+1
	   .s okflag="",useflag=""
	   .s useflag=$p(^DHCPHWIN(phwrow),"^",4)
	   .s okflag=$p(^DHCPHWIN(phwrow),"^",3)
	   .q:okflag'="1"
	   .q:useflag="1"
	   .s case=case+1
	   .s phqrwin=phwrow
	 i tjflag'="1"  d
	  .s phwin=phqrwin
	 e  d
	  .i mathflag="1"  d
	     ..s dd=0
	     ..s phwprow=""
	     ..f  s phwprow=$o(^DHCPHWPi(phloc,phwprow)) q:phwprow=""  d
	         ...s doflag="",ztflag="",usflag="",wpwin=""
	         ...s doflag=$p(^DHCPHWP(phwprow),"^",1)
	         ...q:(doflag'="1")
	         ...s wpwin=$p(^DHCPHWP(phwprow),"^",5)
	         ...s usflag=$p(^DHCPHWIN(wpwin),"^",4)
	         ...q:usflag="1"
	         ...s dd=dd+1
	     ..i dd=0  d
	        ...s phwin=phqrwin
	     ..e  d
	        ...&sql(select nvl(phcw_phw_dr,'0') into :cuwin from SQLUser.dhc_phcurrwin where phcw_phl_dr=:phloc)
	        ...s cuwin=$p(cuwin,$c(1),1)
	        ...i (cuwin="")!(cuwin="0")  d
	          ....s cuwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc) 
	          ....s cuwin=$p(cuwin,$c(1),1) 
	          ....s phwin=cuwin
	          ....&sql(insert into SQLUser.dhc_phcurrwin(phcw_phw_dr,phcw_phl_dr) values(:cuwin,:phloc)) 
	        ...e  d
	          ....s p=0,cuwprow=""
	          ....f  s cuwprow=$o(^DHCPHWPi("WINDOW",phloc,cuwin,cuwprow)) q:cuwprow=""  d
	              .....s doflag="",ztflag=""
	              .....s doflag=$p(^DHCPHWP(cuwprow),"^",1)
	              .....q:(doflag'="1")
	              .....s p=p+1
	          ....i p=0  d
	              .....s phwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc)
	          ....e  d
	             .....s phwin=cuwin 
	        ...s phnextwin=##CLASS(DHCMZYFXTYW02).GnextWin(phloc,phwin) 
	        ...&sql(update SQLUser.dhc_phcurrwin set phcw_phw_dr=:phnextwin where phcw_phl_dr=:phloc)
	     .e  d
	       ..s phwpwindr="",n=0,hh=0
	       ..s phwrow=""
	       ..f  s phwrow=$o(^DHCPHWPi("WINDOW",phloc,phwrow)) q:phwrow=""  d
	         ...s phwprow=""
	         ...f  s phwprow=$o(^DHCPHWPi("WINDOW",phloc,phwrow,phwprow)) q:phwprow=""  d
	           ....s phwpl="",phwpdo="",phwpzt=""
	           ....s pp=0
	           ....s phwpl=+$p(^DHCPHWP(phwprow),"^",2)
	           ....q:phwpl'=phloc
	           ....s phwpdo=$p(^DHCPHWP(phwprow),"^",1)
	           ....s phwpzt=$p(^DHCPHWP(phwprow),"^",6)
	           ....q:phwpdo'="1"
	           ....q:phwpzt="1"
	           ....s phwpwindr=$p(^DHCPHWP(phwprow),"^",5)
	           ....s phwpwindr=$p(phwpwindr,$c(1),1)
	           ....s n=n+1
	           ....s pharow=""
	           ....;^DHCPHARWi({PHA_DATE},{PHA_PHL_DR},{PHA_ROWID}) 
	           ....f  s pharow=$o(^DHCPHARWi(currdate,phloc,pharow)) q:pharow=""  d
	             .....s fin="",nouse=""
	             .....s fin=$p(^DHCPHARW(pharow),"^",6)
	             .....s nouse=$p(^DHCPHARW(pharow),"^",7)
	             .....q:fin="1"
	             .....q:nouse="1"
	             .....s pp=pp+1
	         ....i n=1  s hh=pp
	         ....i pp'>hh  d
	           .....s hh=pp,phwin=phwpwindr
	    s code=0
	    s phwindesc=$p(^DHCPHWIN(phwin),"^",1)
	    s ret=phloc_"^"_phwin_"^"_ctlocdesc_phwindesc_"^"_"0"
	    q ret
}

ClassMethod CurChWin(phl)
{
	      s t=0,curwin=""
	      s prow=""
	      f  s prow=$o(^DHCPHWPi(phl,prow)) q:(prow="")!(t=1)  d
	       .s doflag="",ztflag="",prowwin=""
	       .s doflag=$p(^DHCPHWP(prow),"^",1)
	       .q:(doflag'="1")
	       .s prowwin=+$p(^DHCPHWP(prow),"^",5)
	       .q:'$d(^DHCPHWIN(prowwin))
	       .q:$p($g(^DHCPHWIN(prowwin)),"^",4)=1
	       .s dmflag=..CheckDM(prowwin)
	       .//q:dmflag="1"
	       .s cyflag=..CheckCY(prowwin)
	       .q:cyflag="1"
	       .//s phwintype=$g(^DHCPHWINTYPE(prowwin))
	       .//q:phwintype="4"
	       .s winlocflag=..CheckWinLoc(prowwin)
	       .q:winlocflag>0
	       .s t=t+1
	       .i t=1  s curwin=prowwin 
	   q curwin
}

/// w ##CLASS(web.DHCMZYFXTYW02).GnextWin(2,2) 
ClassMethod GnextWin(phl, cwin)
{
	    s aa=0,win="",cpwinrow=""
	    s nextwindr=""
	    s cpwinrow=$o(^DHCPHWPi("WINDOW",phl,cwin,cpwinrow))
	    s winrow=cpwinrow
	    f  s winrow=$o(^DHCPHWPi(phl,winrow)) q:(winrow="")!(nextwindr'="")  d
	       .s doflag="",ztflag=""
	       .s doflag=$p(^DHCPHWP(winrow),"^",1)
	       .s ztflag=$p(^DHCPHWP(winrow),"^",6)
	       .q:(doflag'="1")!(ztflag="1")
	       .s windr=""
	       .s windr=+$p(^DHCPHWP(winrow),"^",5)
	       .q:'$d(^DHCPHWIN(windr))
	       .s dmflag=..CheckDM(windr)
	       .//q:dmflag="1"
	       .s winlocflag=..CheckWinLoc(windr)
	       .q:winlocflag>0
	       .s phwintype=""
	       .s phwintype=$g(^DHCPHWINTYPE(windr))
	       .//q:(phwintype="2")!(phwintype="4")
	       .q:phwintype=4
	       .
	       .s usflag=""
	       .s usflag=$p(^DHCPHWIN(windr),"^",4)
	       .q:usflag="1"
	       .s nextwindr=windr
	   i nextwindr=""  d
	     .s wprow=""
	     .f  s wprow=$o(^DHCPHWPi(phl,wprow)) q:(wprow="")!(nextwindr'="")  d
	       ..s doflag="",ztflag=""
	       ..s doflag=$p(^DHCPHWP(wprow),"^",1)
	       ..s ztflag=$p(^DHCPHWP(wprow),"^",6)
	       ..q:(doflag'="1")!(ztflag="1")
	       ..s windr=""
	       ..s windr=+$p(^DHCPHWP(wprow),"^",5)
	       ..q:'$d(^DHCPHWIN(windr))
	       ..s dmflag=..CheckDM(windr)
	       ..//q:dmflag="1"
	       ..s winlocflag=..CheckWinLoc(windr)
	       ..q:winlocflag>0
	       ..s phwintype=""
	       ..s phwintype=$g(^DHCPHWINTYPE(windr))
	       ..//q:(phwintype="2")!(phwintype=4)
	       ..q:phwintype=4
	       ..s usflag=""
	       ..s usflag=$p(^DHCPHWIN(windr),"^",4)
	       ..q:usflag="1"
	       ..s nextwindr=windr
	    q nextwindr
}

ClassMethod GetTSWin(phl)
{
	s phlwin="",retphwin=""
	f  s phlwin=$o(^DHCPHWINi(phl,phlwin)) q:phlwin=""  d
	  .s phwintype=""
	  .s phwintype=$g(^DHCPHWINTYPE(phlwin))
	  .q:phwintype'="2"
	  .s retphwin=phlwin
	q retphwin
}

/// 计费组-打印导诊单会调用,last update by yunhaibao 20170215
/// w ##class(web.DHCMZYFXTYW02).GetPrtPrescWin("100000ddd069","O17021500001")
ClassMethod GetPrtPrescWin(prt, presc)
{
	s pha="",retwin="",retwindesc=""
	f  s pha=$o(^DHCPHARi("PRT",prt,pha)) q:pha=""  d
	.s phapresc=""
	.s phapresc=$p(^DHCPHARW(pha),"^",16)
	.q:phapresc'=presc
	.s phaphl="",phaphw=""
	.s phaphl=+$p(^DHCPHARW(pha),"^",3)
	.s phaphw=+$p(^DHCPHARW(pha),"^",4)
	.s retwin=phaphw
	i +retwin'="0" s retwindesc=$p($g(^DHCPHWIN(+retwin)),"^",1)
	q:retwindesc'="" retwindesc
	q:presc="" retwindesc
	s pha=$o(^DHCPHARi("PRESCNO",presc,""),-1)
	q:pha="" retwindesc
	s phafinal=+$p(^DHCPHARW(pha),"^",6)
	i +phafinal>0 d
	.s retwin=+$p(^DHCPHARW(pha),"^",4)
	.i retwin'="0" s retwindesc=$p($g(^DHCPHWIN(+retwin)),"^",1)
	q retwindesc
}

/// 取草药窗口
ClassMethod GetCYWin(phl)
{
	s phlwin="",retphwin=""
	f  s phlwin=$o(^DHCPHWINi(phl,phlwin)) q:phlwin=""  d
	  .q:$p(^DHCPHWIN(phlwin),"^",4)=1
	  .s phwintype=$g(^DHCPHWINTYPE(phlwin))
	  .q:phwintype'="4"
	  .s retphwin=phlwin
	q retphwin
}

ClassMethod CheckCY(win)
{
  s ret="",wintype=""
  s wintype=$g(^DHCPHWINTYPE(win))
  i wintype="4"  s ret="1"
  q ret
}

/// 药学分类
ClassMethod GetPhcCatDesc(arcim As %String) As %String
{
 q:arcim="" ""
 s sub=$p(arcim,"||",1) q:sub="" ""
 s ver=$p(arcim,"||",2)  q:ver="" ""
 s drgfrm=$p(^ARCIM(sub,ver,1),"^",12) q:drgfrm="" ""
 s drg=$P(drgfrm,"||",1) q:drg="" ""
 s subcat=$p(^PHCD(drg,1),"^",3) q:subcat="" ""
 s cat=$P(subcat,"||",1),sub=$p(subcat,"||",2)
 Q:cat="" ""
 Q:'$D(^PHCC(cat)) ""
 s catdesc=$p(^PHCC(cat),"^",2)
 q catdesc
}

/// 调用分配新窗口
/// prescinf="O11092100001"_$c(1)_"O11092100002"
/// LiangQiang 2012-03-23
/// w ##class(web.DHCMZYFXTYW02).GetCurrWinNew("O171229000001")
ClassMethod GetCurrWinNew(prescinf)
{
    s ^tmphlh($this,"GetCurrWinNew")=$lb(prescinf)
    s len=0,i=0,x=0
	s pid=..NewPid() 
    s dex=""
    f  s dex=$o(^DHCTMPPharmacyWin(+$h),-1) q:dex=""  d
    .k ^DHCTMPPharmacyWin(dex)     
    s allretwin=""
	s len=$l(prescinf,$c(1))	
	for i=1:1:len
	{
			s currpresc="",ord="0"
			s currpresc=$p(prescinf,$c(1),i)
			s ord=$o(^OEORD(0,"PrescNo",currpresc,"")) 
			s itm="",recloc="",adm="",itmmast="",admloc="",argwin="", windesc=""
			s itm=$o(^OEORD(0,"PrescNo",currpresc,ord,"")) 
			s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)      ;arc_itmmast                     	
			s adm=$p(^OEORD(ord),"^",1)
			s admloc=+$p(^PAADM(adm),"^",4)
	        s dmflag=0,admflag=0,dsyflag=0
	        s mwin=""
		    s recloc=$p(^OEORD(ord,"I",itm,3),"^",6)
		    s phl=$o(^DHCPHLOCi("LOC",recloc,""))
		    continue:phl=""		
		    s cyflag="",tswin="",tsflag="",cywin=""
		    i phl'="" s cyflag=$p(^DHCPHLOC(phl),"^",6)	
		    s reclocdesc=$p(^CTLOC(recloc),"^",2)
		    i reclocdesc["-"  s reclocdesc=$p(reclocdesc,"-",2)
		    s adm=+$p(^OEORD(ord),"^",1)
		    s pmi=""
		    s pmi=+$p(^PAADM(adm),"^",1)		    
		    ///当天已分配窗口
		    i i=1 d
		    .i $D(^DHCTMPPharmacyWin(+$h,phl,pmi)) d     
            ..s tmpwin=^DHCTMPPharmacyWin(+$h,phl,pmi)
            ..s checkopwin=..CheckOpenWin(tmpwin)
	        ..i checkopwin'=1  d
	        ...k ^DHCTMPPharmacyWin(+$h,phl,pmi)
	        ..i ..GetPhWinDispStatusnew(pmi,phl)=1 d  //只判断当天
	        ...k ^DHCTMPPharmacyWin(+$h,phl,pmi)
	
		    s dmflag=..GetPrescType(currpresc)
		    s getadmwin=..GetAdmWin(phl,admloc)
	        i getadmwin'="" s admflag=1  
            i (dmflag=1)&&(..GetDMWin(recloc)'="")  s ^TMP("OutWin",pid,phl,"DM")=""
		    i admflag=1 s ^TMP("OutWin",pid,phl,"ADM")=""
		    
            ///毒麻精指定窗口
		    i $D(^TMP("OutWin",pid,phl,"DM")) d
		    .s ^TMP("OutWin",pid,phl,"Priority")=1
		    e  d
		    .///就诊科室指定窗口
		    .i ($D(^TMP("OutWin",pid,phl,"ADM"))&&(admflag=1)) d
		    ..s ^TMP("OutWin",pid,phl,"Priority")=2
		    .///即有科室指定窗口又有普通
		    .i ($D(^TMP("OutWin",pid,phl,"ADM"))&&(admflag'=1)) d
		    ..s ^TMP("OutWin",pid,phl,"Priority")=10
		    .///普通
		    .i '$D(^TMP("OutWin",pid,phl,"ADM")) d
		    ..s ^TMP("OutWin",pid,phl,"Priority")=10
		    .
	        s ^TMP("OutPrescNo",pid,currpresc,phl)=""   

         
	}

	s presc=""
	s len=$l(prescinf,$c(1))
	f i=1:1:len d
	.s presc=$p(prescinf,$c(1),i)
	.s phl=""
	.f  s phl=$o(^TMP("OutPrescNo",pid,presc,phl)) q:phl=""  d
	..s mwin=""
	..s ord=$o(^OEORD(0,"PrescNo",presc,""))
	..s adm=$p(^OEORD(ord),"^",1)
	..s pmi=+$p(^PAADM(adm),"^",1)
	..s reclocdr=$p(^DHCPHLOC(phl),"^",1)
	..s reclocdesc=$p(^CTLOC(reclocdr),"^",2)
	..i reclocdesc["-"  s reclocdesc=$p(reclocdesc,"-",2)
	..s admloc=+$p(^PAADM(adm),"^",4)
	..
	..s pri=^TMP("OutWin",pid,phl,"Priority")
	..
	..i (pri=10)&&(mwin="")&&($d(^DHCTMPPharmacyWin(+$h,phl,pmi))) d
	...s mwin=^DHCTMPPharmacyWin(+$h,phl,pmi)
	..i (pri=1)&&(mwin="") d
	...s mwin=..GetDMWin(reclocdr)  //属于毒麻
	...s ^DHCTMPPharmacyWin(+$h,phl,pmi)=mwin    
	..i (pri=2)&&(mwin="") d
	...s mwin=..GetAdmWin(phl,admloc)
	..///指定的草药窗口
	..s itm=$o(^OEORD(0,"PrescNo",presc,ord,""))
	..s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2) 
	..s phccat=..GetPhcCatDesc(itmmast)	//药学分类
	..s cyflag=""
	..i phccat="中草药" s cyflag="1"
	..i cyflag="1" d
	...s cywin=..GetCYWin(phl)
	...s winopen=..CheckOpenWin(cywin)
	...i winopen'=1 d
	....s mwin=""
	...e  d
	....s mwin=cywin 
	..i (pri=10)&&(mwin="") d
	...s mwin=..GetNewCurrWin(reclocdr)
	...s ^DHCTMPPharmacyWin(+$h,phl,pmi)=mwin
	..s checkopwin=..CheckOpenWin(mwin)
	..i checkopwin'=1  d
	...s mwin=..GetNewCurrWin(reclocdr)
	...s ^DHCTMPPharmacyWin(+$h,phl,pmi)=mwin
	..s ret=..GoToUpdCurrWinWork(phl,mwin,presc)
	..s windesc=$s(mwin'="":$p(^DHCPHWIN(mwin),"^",1),1:"")
	..
	..i allretwin=""  d
    ...s allretwin=phl_"^"_mwin_"^"_reclocdesc_windesc_"^"_0
    ..e  d
    ...s allretwin=allretwin_$c(1)_phl_"^"_mwin_"^"_reclocdesc_windesc_"^"_0
    ...
    
    k ^TMP("OutWin",pid)
    k ^TMP("OutPrescNo",pid)
	
	q allretwin
}

/// 获取指定科室窗口，liangqiang
ClassMethod GetAdmWin(recphl, admloc)
{
	s retwin=""
	s phw=""
	f  s phw=$o(^DHCPHWINi("WIN",recphl,phw)) q:phw=""  d
	.s phwl=""
	.f  s phwl=$o(^DHCPHWINL(phw,"I",phwl)) q:phwl=""  d
	..s ctlocdr=$p(^DHCPHWINL(phw,"I",phwl),"^",1)
	..q:ctlocdr'=admloc
	..s retwin=phw
	q retwin
}

/// 按算法分配窗口
/// w ##class(web.DHCMZYFXTYW02).GetNewCurrWin(100)
ClassMethod GetNewCurrWin(ctloc)
{
	 s ctloc=$g(ctloc)
	 s ret=""
	 s phloc="",mathflag="",commit="",currdate="",tjflag=""
	 s currdate=$p($h,",",1)
	 s ll=0
	 s phlrow=""
	 f  s phlrow=$o(^DHCPHLOCi("LOC",ctloc,phlrow)) q:phlrow=""  d
	 .s ll=ll+1
	 .s mathflag=$p(^DHCPHLOC(phlrow),"^",4)
	 .s tjflag=$p(^DHCPHLOC(phlrow),"^",5)
	 .s phloc=phlrow
	 s ctlocdesc=""
	 s ctlocdesc=$p(^CTLOC(ctloc),"^",2)
	 i ctlocdesc["-" s ctlocdesc=$p(ctlocdesc,"-",2)
	 i ll=0 q -1     
	 s ww=0,cuwin="",case=0
	 s phwrow=""
	 s phwin="",phwpid="",phwpnextid="",phwindesc="",phnextwin="",phqrwin=""
	 f  s phwrow=$o(^DHCPHWINi("WIN",phloc,phwrow)) q:(phwrow="")!(case=1)  d
	 .s ww=ww+1
	 .s okflag="",useflag=""
	 .s useflag=$p(^DHCPHWIN(phwrow),"^",4)
	 .s okflag=$p(^DHCPHWIN(phwrow),"^",3)
	 .q:okflag'="1"
	 .q:useflag="1"
	 .s case=case+1
	 .s phqrwin=phwrow
	 i tjflag'="1"  d
	 .///不是提前配药,只找一个即可 lq
	 .s phwin=phqrwin
	 e  d
	 .i mathflag="1"  d
	 ..//按顺序,提前配 lq
	 ..s dd=0
	 ..s phwprow=""
	 ..f  s phwprow=$o(^DHCPHWPi(phloc,phwprow)) q:phwprow=""  d
	 ...s doflag="",ztflag=""
	 ...s doflag=$p(^DHCPHWP(phwprow),"^",1)
	 ...q:(doflag'="1")
	 ...s dd=dd+1
	 ..i dd=0  d
	 ...s phwin=phqrwin
	 ..e  d
	 ...&sql(select nvl(phcw_phw_dr,'0') into :cuwin from SQLUser.dhc_phcurrwin where phcw_phl_dr=:phloc)
	 ...s cuwin=$p(cuwin,$c(1),1)
	 ...i (cuwin="")!(cuwin="0")  d
	 ....///第一个窗口开始 lq
	 ....
	 ....s cuwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc)
	 ....s cuwin=$p(cuwin,$c(1),1) 
	 ....s phwin=cuwin
	 ....&sql(insert into SQLUser.dhc_phcurrwin(phcw_phw_dr,phcw_phl_dr) values(:cuwin,:phloc)) 
	 ...e  d
	 ....///查看窗口状态 lq
	 ....s p=0,cuwprow=""
	 ....f  s cuwprow=$o(^DHCPHWPi("WINDOW",phloc,cuwin,cuwprow)) q:cuwprow=""  d
	 .....s doflag="",ztflag=""
	 .....s doflag=$p(^DHCPHWP(cuwprow),"^",1)
	 .....q:(doflag'="1")
	 .....s p=p+1
	 ....i p=0  d
	 .....s phwin=##CLASS(DHCMZYFXTYW02).CurChWin(phloc)
	 ....e  d
	 .....s phwin=cuwin 
	 ...///取一下个窗口 lq
	 ...q:phwin=""
	 ...s phnextwin=##CLASS(DHCMZYFXTYW02).GnextWin(phloc,phwin) 
	 ...&sql(update SQLUser.dhc_phcurrwin set phcw_phw_dr=:phnextwin where phcw_phl_dr=:phloc)
	 ...s phwin=phnextwin
	 ...
	 ..s:phwin="" phwin=..GetDefuWin(phloc) 
	 .e  d
	 ..//按工作量
	 ..//s phwin=..GetWinWork(phloc)
	 ..s phwin=..GetWinByWorkLoad(phloc,ctloc)     //hulihua 2016-04-19 按照工作量分窗口采用新的计算方法！   
	 q phwin
}

/// 按窗口工作量来分配窗口
/// Creator:Liang Qiang
/// CreatDate:2011-03-11
/// Input:科室id
/// Output:分配的窗口
ClassMethod GetWinWork(phloc)
{
 s curdate=+$h
 ///检测试是否存在新增窗口
 s phw=""
 f  s phw=$o(^DHCPHWINi(phloc,phw)) q:phw=""  d
 .q:$d(^DHCPHCWSi(0,"PHLDATE",phloc,curdate,phw))
 .s PLIST(1)=""
 .s PLIST(2)=phloc
 .s PLIST(3)=curdate
 .s PLIST(4)=phw
 .s PLIST(5)=0
 .&sql(INSERT INTO DHC_PHCURRWINSUM VALUES PLIST())
 ///更新工作量
 s exit=0
 s currnum="",retwin=""
 l +^DHCST("OutPh","GetWinWork",phloc):10  E  Q ""
 f  s currnum=$o(^DHCPHCWSi(0,"PHLSUM",phloc,curdate,currnum)) q:(currnum="")!(exit=1)  d
 .s phcws=""
 .f  s phcws=$o(^DHCPHCWSi(0,"PHLSUM",phloc,curdate,currnum,phcws)) q:(phcws="")!(exit=1)  d
 ..s phwin=$p(^DHCPHCWS(phcws),"^",3)
 ..s checkopwin=..CheckOpenWin(phwin)
 ..q:checkopwin'=1
 ..s phwintype=$g(^DHCPHWINTYPE(phwin))
 ..q:phwintype="2"
 ..q:phwintype="4"
 ..s phwpID=$o(^DHCPHWPi("WINDOW",phloc,phwin,""))
 ..q:phwpID=""
 ..s phwpzt=$p(^DHCPHWP(phwpID),"^",6)
 ..q:phwpzt=1
 ..s winlocflag=..CheckWinLoc(phwin)
 ..q:winlocflag>0
 ..//s err=##class(web.DHCMZYFXTYW02).UpdCurrWinWork(phloc,phwin,1)
 ..//i err=0 s exit=1
 ..s exit=1
 ..s retwin=phwin
 l -^DHCST("OutPh","GetWinWork",phloc)
 q:retwin'="" retwin
 //如果没有开放窗口,取默认窗口
 s defuWin=..GetDefuWin(phloc)
 q:defuWin="" defuWin
 s retwin=defuWin
 //s err=##class(web.DHCMZYFXTYW02).UpdCurrWinWork(phloc,defuWin,1)
 //q:err=0 defuWin
 q retwin
}

/// 更新科室窗口处方工作量
/// Creator:Liang Qiang
/// CreatDate:2011-03-11
/// Input:科室,窗口,更新数
/// Output: 0成功 非0失败
ClassMethod UpdCurrWinWork(phl, phw, qty)
{
 q:phw="" 0
 s CurrDate=+$h
 q:'$d(^DHCPHCWSi(0,"PHLDATE",phl)) 0
 s phcws=$o(^DHCPHCWSi(0,"PHLDATE",phl,CurrDate,phw,""))
 q:phcws="" 0
 q:'$d(^DHCPHCWS(phcws)) 0
 ;
 l +^DHCST("OutPh","UPDCURWINSUM",phl,phw):10  E  Q -9
 s CurrNum=+$p(^DHCPHCWS(phcws),"^",4)+qty
 i CurrNum<0 s CurrNum=0
 &sql(update DHC_PHCURRWINSUM set PHCWS_PrescNoSum=:CurrNum where PHCWS_ROWID=:phcws )
 l -^DHCST("OutPh","UPDCURWINSUM",phl,phw)
 q:SQLCODE'=0 -100
 q 0
}

/// 获取处方的接收科室
ClassMethod GetPrescType(prescno)
{
    s dmflag=0
    s ord=0
    f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
    .s chl=""
    .s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    .s tprescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    .q:tprescno'=prescno
 	.s itmmast=$p(^OEORD(ord,"I",chl,1),"^",2)      ;arc_itmmast  
 	.s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(itmmast)
 	.//w !,ord_"||"_chl
	.i PoisonRowid'="" d
	..s PoisonClass=$p($g(^PHCPO(PoisonRowid)),"^",2)
	..i PoisonClass["精一" s dmflag="1"
	..i PoisonClass["一类精" s dmflag="1"
	..i PoisonClass["毒" s dmflag="1"
	..i PoisonClass["麻" s dmflag="1"
	q dmflag
}

/// Descript:取默认窗口
/// Creater：zhouyg
/// CreateDate：2011-10-20
ClassMethod GetDefuWin(phl)
{
	s phlwin="",retphwin=""
	f  s phlwin=$o(^DHCPHWINi(phl,phlwin)) q:(phlwin="")!(retphwin'="")  d
	.q:+$p(^DHCPHWIN(phlwin),"^",4)'=0	//无效窗口
	.q:+$p(^DHCPHWIN(phlwin),"^",3)=0
	.s retphwin=phlwin
	q retphwin
}

/// Descript:检查原窗口是否已发完药
/// Creater：LiangQiang
/// CreateDate：2011-03-23
/// 0 -未发 1 已发,此处同时交费会有问题,如为第一次为多个处方均认为为未发药,yunhaibao20160107
ClassMethod GetPhWinDispStatus(papmi, phl)
{
	s ret=0
	s phdr=""
	f  s phdr=$o(^DHCPHDISPi("PAPMI",papmi,phdr)) q:phdr=""  d
	.s tmpphl=$p(^DHCPHDISP(phdr,1),"^",1)
	.q:phl'=tmpphl
	.s phfydr=$p(^DHCPHDISP(phdr,1),"^",2)
	.q:phfydr=""
	.s ret=1
	q ret
}

/// Descript:按处方更新窗口工作量
/// CreateDate：2011-03-23
/// 
ClassMethod GoToUpdCurrWinWork(phl, mwin, presc)
{
	s ret=0
	s mathflag=$p(^DHCPHLOC(phl),"^",4)
	s tjflag=$p(^DHCPHLOC(phl),"^",5)
	i (tjflag=1)&(mathflag'=1) d
	.//i '$d(^DHCPHARWi("PRESCNO",presc)) d
	.s ret=##class(web.DHCMZYFXTYW02).UpdCurrWinWork(phl,mwin,1)
	q:ret'=0 -1
	q 0
}

/// Descript:检查原窗口是否已发完药(判断中间表dhc_pharwin)
/// Creater：liangjiaquan
/// CreateDate：2014-05-04
/// 0 -未发 1 已发
ClassMethod GetPhWinDispStatusnew(papmi, phl)
{
 s ret=1
 s phar=""
 f  s phar=$o(^DHCPHARWi(+$h,phl,phar))  q:(phar="")!(ret=0)  d
 .s nouse=$p(^DHCPHARW(phar),"^",7)
 .q:nouse=1   //过滤已作废发票
 .s fyflag=$p(^DHCPHARW(phar),"^",6)
 .q:fyflag="1"   //过滤已发药处方
 .s prt=$p(^DHCPHARW(phar),"^",1)
 .//q:'$d(^DHCINVPRT(0,"PAPMI",papmi,prt))
 .s pmi=$p(^DHCINVPRT(prt),"^",15)
 .q:pmi'=papmi
 .s ret=0
 q ret
}

/// 从第三方厂商取窗口
ClassMethod GetPhWinFromManf(prescinf) As %String
{
	b //xxxx
	Q:prescinf="" ""
	s pp="st"_"^"_prescinf
	;s ^lqwinmanf("a",$h,pp)=""
	s pid=$I(^TMPOUTPHA("GETNEWWIN"))
	s allretwin=""
	s len=$l(prescinf,$c(1))
    f i=1:1:len d
	.s currpresc=$p(prescinf,$c(1),i)
	.q:currpresc="" //非药品
	.s ord=$o(^OEORD(0,"PrescNo",currpresc,"")) 
	.s itm=$o(^OEORD(0,"PrescNo",currpresc,ord,"")) 
    .s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    .s reclocdesc=$p(^CTLOC(reclocdr),"^",2)
    .s phl=$o(^DHCPHLOCi("LOC",reclocdr,""))
    .q:phl=""
    .s ^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"PhlPresc",phl,currpresc)=""
    //交互
    s phl=""
    f  s phl=$o(^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"PhlPresc",phl)) q:phl=""  d
    .s tmpstr=""
    .s prescno=""
    .f  s prescno=$o(^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"PhlPresc",phl,prescno)) q:prescno=""  d
    ..s basewin=""
    ..s basflag=##class(web.DHCOutPhCommon).ChkOrdBaseMed(prescno)
    ..i basflag=1 d
    ...s basewin=..GetOrdBaseMedWin(phl,prescno)
    ...s ^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"Win",prescno)=basewin
    ..q:basflag=1  //基数窗口不和厂商交互
    ..i tmpstr="" d
    ...s tmpstr=prescno
    ..e  d
    ...s tmpstr=tmpstr_"^"_prescno
    .i tmpstr'="" d
    ..s win=##class(web.DHCSTInterfacePH).GetMachineWin(phl,tmpstr)
    ..s cnt=$l(tmpstr,"^")
	..f h=1:1:cnt d
	...s prescno=$p(tmpstr,"^",h)
    ...s ^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"Win",prescno)=win
    //传出
    s len=$l(prescinf,$c(1))
    f i=1:1:len d
	.s prescno=$p(prescinf,$c(1),i)
	.q:prescno=""
	.s ord=$o(^OEORD(0,"PrescNo",currpresc,"")) 
	.s itm=$o(^OEORD(0,"PrescNo",currpresc,ord,"")) 
    .s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    .s reclocdesc=$p(^CTLOC(reclocdr),"^",2)
    .s phl=$o(^DHCPHLOCi("LOC",reclocdr,""))
    .q:phl=""
	.s windesc=""
	.s win=$g(^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid,"Win",prescno))
	.i win'="" s windesc=$p(^DHCPHWIN(win),"^",1)
	.i allretwin=""  d
    ..s allretwin=phl_"^"_win_"^"_reclocdesc_windesc_"^"_prescno
    .e  d
    ..s allretwin=allretwin_$c(1)_phl_"^"_win_"^"_reclocdesc_windesc_"^"_prescno
    
    k ^TMP("DHCOutPh","DHCMZYFXTYW02","GetPhWinFromManf",pid)
    
    ;s ^lqwinmanf("b",$h,pp)=allretwin
    q allretwin
}

/// Descriprtion:取处方对应的基数药窗口
/// Input:phaloc -药房科室, prescno -处方号
/// Output: 基数药窗口
/// Creator:Liang Qiang
/// CreatDate:2012-07-30
ClassMethod GetOrdBaseMedWin(phl, prescno) As %String
{
	s flag=##class(web.DHCOutPhCommon).ChkOrdBaseMed(prescno)
	q:flag'=1 ""
	s win=..GetBaseMedWin(phl)
	q win
}

/// Descriprtion:取基数药窗口
/// Input:phaloc -药房科室, prescno -处方号,prt - 发票ID
/// Output: win -  发药窗口
/// Creator:Liang Qiang
/// CreatDate:2012-07-30
ClassMethod GetBaseMedWin(phl) As %String
{

	s phlwin="",retphwin=""
	f  s phlwin=$o(^DHCPHWINi(phl,phlwin)) q:phlwin=""  d
	.q:$p(^DHCPHWIN(phlwin),"^",4)=1
	.s phwintype=$g(^DHCPHWINTYPE(phlwin))
	.q:phwintype'="5"
	.s retphwin=phlwin
	q retphwin
}

/// Description:按窗口工作量来分配窗口（榆林二院）
/// Creator:	hulihua
/// CreateDate:	2016-04-18
/// Table:      DHC_PHDISPEN,DHC_PHWINDOW,DHC_PHWINLOC,DHC_PHWPER,DHC_PHPERSON
/// Input:      药房ID，药房科室ID
/// Output:
/// Return：    分配的窗口
/// w ##class(web.DHCMZYFXTYW02).GetWinByWorkLoad("2","100")
ClassMethod GetWinByWorkLoad(phloc, ctloc)
{
 s retwin=""
 s curdate=+$h
 ///检测试是否存在新增窗口
 s phwin="",retcurrnum=""
 f  s phwin=$o(^DHCPHWINi(phloc,phwin)) q:phwin=""  d
 .s checkopwin=..CheckOpenWin(phwin)
 .q:checkopwin'=1
 .s phwintype=$g(^DHCPHWINTYPE(phwin))
 .q:phwintype="2"
 .q:phwintype="4"
 .s phwpID=$o(^DHCPHWPi("WINDOW",phloc,phwin,""))
 .q:phwpID=""
 .s phwpzt=$p(^DHCPHWP(phwpID),"^",6)
 .q:phwpzt=1
 .s dispotherflag=$p(^DHCPHWIN(phwin),"^",6)
 .s winlocflag=..CheckLocWin(phwin)  //科室指定窗口不分
 .q:winlocflag>0
 .s currnum=..GetWorkLoad(phloc,phwin,curdate,ctloc)
 .i retcurrnum="" d
 ..s retcurrnum=currnum
 ..s retwin=phwin
 .e  d
 ..i currnum<retcurrnum d
 ...s retcurrnum=currnum
 ...s retwin=phwin
 ..
 q:retwin'="" retwin
 //如果没有开放窗口,取默认窗口
 s defuWin=..GetDefuWin(phloc)
 q:defuWin="" defuWin
 s retwin=defuWin
 q retwin
}

/// Description:判断该窗口是否有指定科室窗口（榆林二院）
/// Creator:	hulihua
/// CreateDate:	2016-04-18
/// Table:      DHC_PHWINDOW,DHC_PHWINLOC
/// Input:      窗口ID
/// Output:
/// Return：    1-有，0-否
/// w ##class(web.DHCMZYFXTYW02).CheckLocWin("21")
ClassMethod CheckLocWin(phw)
{
	s phwl="",locwinnum=0
	f  s phwl=$o(^DHCPHWINL(phw,"I",phwl)) q:(phwl="")||(locwinnum'=0)  d
	.s ctlocdr=$p(^DHCPHWINL(phw,"I",phwl),"^",1)
	.q:ctlocdr=""
	.s locwinnum=locwinnum+1
	q locwinnum
}

/// Description:获取药房窗口在配置时间段类未发的处方量（榆林二院）
/// Creator:	hulihua
/// CreateDate:	2016-04-18
/// Table:      DHC_PHDISPEN
/// Input:      药房ID，窗口ID，开始判断日期，药房科室ID
/// Output:
/// Return：    该窗口未发的处方量
/// w ##class(web.DHCMZYFXTYW02).GetWorkLoad("2","2","64247","100")
ClassMethod GetWorkLoad(phl, phw, curdate, ctloc)
{
	s outphaconfig=##class(web.DHCOutPhCommon).GetParamProp("",ctloc,"")
	s configmtime=$p(outphaconfig,"^",3)
	s workloadway=$p(outphaconfig,"^",4)
	s:configmtime="" configmtime=24*60
	s configtime=configmtime*60
	s nowtime=$p($h,",",2)
	s stpytime=nowtime-configtime,fycurrnum=0,fyflag="0"
	s pytime=stpytime-1  
	i workloadway=2 d //缴费未发
	.s pharid="",pharquit=""
	.f  s pharid=$o(^DHCPHARi("WIN",phw,curdate,pharid),-1) q:(pharid="")||(pharquit'="")  d
	..q:'$d(^DHCPHARW(pharid)) 
	..s phardata=^DHCPHARW(pharid)
	..s pharfyflag=$p(phardata,"^",6)
	..q:pharfyflag>0 
	..s phartime=$p(phardata,"^",5)
	..i phartime<pytime s pharquit=1
	..s pharprt=$p(phardata,"^",1)
	..s pharprescno=$p(phardata,"^",16)
	..s chkerr=##class(web.DHCOutPhDisp).CheckNotUse(pharprt,phl,pharprescno)
	..q:chkerr=1 
	..s fycurrnum=fycurrnum+1
	e  d //已打未发
	.f  s pytime=$o(^DHCPHDISPi(0,"PhlPydtFyflag",fyflag,phl,phw,curdate,pytime))  q:pytime=""  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi(0,"PhlPydtFyflag",fyflag,phl,phw,curdate,pytime,phd))  q:phd=""  d
	...q:$p(^DHCPHDISP(phd),"^",4)>0
	...s prescno=$p(^DHCPHDISP(phd,2),"^",1)
	...s prt=$p(^DHCPHDISP(phd),"^",2)
	...s chkerr=##class(web.DHCOutPhDisp).CheckNotUse(prt,phl,prescno)
	...q:chkerr=1 
	...s fycurrnum=fycurrnum+1
	q +fycurrnum
}

ClassMethod GetServiceWin(phl)
{
 ///Descriprtion:取综合服务窗口</Description>

	s phlwin="",retphwin=""
	f  s phlwin=$o(^DHCPHWINi(phl,phlwin)) q:phlwin=""  d
	.q:$p(^DHCPHWIN(phlwin),"^",4)=1
	.s phwintype=$g(^DHCPHWINTYPE(phlwin))
	.q:phwintype'="1"
	.s retphwin=phlwin
	q retphwin
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
