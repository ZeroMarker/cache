Class CHSSWeb.Pharmacy.OutReturnPhaQuery Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-11-8
/// description: 门诊药房退药查询列表
/// input:  StartDate(起始日期)  EndDate(截止日期)  ctloc(药房)    CPmiNo(登记号)    
/// output: String  papmino^patname^retdate^rfrdesc^retmoney^username^retrow^phddate^ghlocdesc^ldoctorname
/// others: 
ClassMethod QueryGRETDJCX(StartDate As %Library.String = "", EndDate As %Library.String = "", ctloc As %Library.String = "", CPmiNo As %Library.String = "") As %Library.String
{
  Set json = ##class(Code.JsonObj).%New()
  s resultString = ""
  s ind=0
  s rtmoney=0,rtcount=0
  s stdate="",enddate=""
  i StartDate="" Quit resultString 
  i EndDate="" Quit resultString
  s stdate=$ZDH(StartDate,3)
  s enddate=$ZDH(EndDate,3)
  s phl=""
  i ctloc=""  Quit resultString
  s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
  i phl=""  Quit resultString
  s phretdate = "",ret=0,t=0,l=0
  f  s phretdate=$o(^DHCPHRETi(phretdate)) q:phretdate=""  d
          .s retrow = ""
          .q:phretdate<stdate
          .q:phretdate>enddate
          .f  s retrow=$o(^DHCPHRETi(phretdate,phl,retrow)) q:retrow=""  d
            ..s retdate=""
            ..s retdate=$zd(phretdate,3)
            ..s prt="",retmoney=0,retuser="",username=""
            ..s prt=+$p(^DHCPHRET(retrow),"^",9)
            ..q:'$d(^DHCINVPRT(prt))
            ..s papmi="",papmino="",patname=""
            ..s papmi=+$p(^DHCINVPRT(prt),"^",15)
            ..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
            ..s papmino=$p(^PAPER(papmi,"PAT",1),"^",2)
            ..s retmoney=+$p(^DHCPHRET(retrow),"^",11)
            ..s retuser=+$p(^DHCPHRET(retrow),"^",8)
            ..s username=$p(^DHCPHPER(retuser),"^",2)
            ..i username["#" s username=$p(username,"#",2)
            ..s phdrow="",phddate=""
            ..s phdrow=+$p(^DHCPHRET(retrow),"^",6)
            ..s phddate=$p(^DHCPHDISP(phdrow,1),"^",5)
            ..s phddate=$zd(phddate,3)
            ..s rfr="",rfrdesc="",ghloc="",ghlocdesc="",ldoctor="",ldoctorname=""
            ..s rfr=+$p(^DHCPHRET(retrow),"^",13)
            ..i rfr'="0" s rfrdesc=$p(^BLC("RFR",rfr),"^",2)
            ..s retsub=""
            ..f  s retsub=$o(^DHCPHRTI(retrow,"RTI",retsub)) q:retsub=""  d
               ...s rmoney=0,retqty=0,retunit="",retoeori=""
               ...s rmoney=+$p(^DHCPHRTI(retrow,"RTI",retsub),"^",1)
               ...s retmoney=retmoney+rmoney
               ...s retqty=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",3)
               ...s retqty=$p(retqty,$c(1),1)
               ...s retunit=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",4)
               ...s retunit=$p(retunit,$c(1),1)
               ...s retoeori=$p(^DHCPHRTI(retrow,"RTI",retsub),"^",2)
               ...s ord="",itm="",itmmast="",inci=""
               ...s ord=$p(retoeori,"||",1)
               ...s itm=$p(retoeori,"||",2)
               ...s adm=""
               ...s adm=+$p(^OEORD(ord),"^",1)
               ...s ghloc=+$p(^PAADM(adm),"^",4)
               ...s ldoctor=+$p(^OEORD(ord,"I",itm,1),"^",11)
               ...i ghloc'=0 s ghlocdesc=$p(^CTLOC(ghloc),"^",2)
               ...i ghlocdesc["-" s ghlocdesc=$p(ghlocdesc,"-",2)
               ...i ldoctor'=0 s ldoctorname=$p(^CTPCP(ldoctor,1),"^",2)
               ...s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
               ...s itmmastid="",itmmastver=""
               ...s itmmastid=$p(itmmast,"||",1)
               ...s itmmastver=$p(itmmast,"||",2)
               ...s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
               ...s inci=$p(inci,$c(1),1)
               ...i '$d(^TMPRETPH(phl,inci))  d
                   ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",1)=retmoney
                   ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",2)=retqty
                   ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",3)=retunit
               ...e  d
                   ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",1)=$p(^TMPRETPH(phl,inci),"^",1)+retmoney
                   ....s $p(^DHCPHTMPRETPHhz($j,phl,inci),"^",2)=$p(^TMPRETPH(phl,inci),"^",2)+retqty
           ..q:(papmino'=CPmiNo)&(CPmiNo'="")
           ..q:(retmoney=0)
           
           ..s rtmoney=rtmoney+retmoney
           ..s rtcount=rtcount+1
 	       ..Set tmp = papmino_"^"_patname_"^"_retdate_"^"_rfrdesc_"^"_retmoney_"^"_username_"^"_retrow_"^"_phddate_"^"_ghlocdesc_"^"_ldoctorname
 	       ..Set ind=ind+1
 	       ..Do json.InsertRowData(tmp)
 	
 	Set tmp = "合计"_"^"_rtcount_"条"_"^^^"_rtmoney_"^^^^^"
 	Set ind=ind+1
 	Do json.InsertRowData(tmp)
 	
 	Set resultString = json.getJsonData("papmino^patname^retdate^rfrdesc^retmoney^username^retrow^phddate^ghlocdesc^ldoctorname",ind)
	Kill json
	WRITE resultString
	Quit resultString
}

/// creator:zhangyong
/// date:2011-11-9
/// description: 退药明细
/// input:  ret(退药RowID) 
/// output: String phdesc^newunitdesc^qty^retmoney^ind
/// others: 
ClassMethod QueryGRetPh(ret As %Library.String = "") As %Status
{
	Set json = ##class(Code.JsonObj).%New()
    s resultString = ""
    i ret=""  Quit resultString
    s ind=0
    s retsub=""
    f  s retsub=$o(^DHCPHRTI(ret,"RTI",retsub)) q:retsub=""  d
    .s oeori="",retmoney=0,retqty=0,retunit=""
    .s oeori=$p(^DHCPHRTI(ret,"RTI",retsub),"^",2)
    .s retmoney=$p(^DHCPHRTI(ret,"RTI",retsub),"^",1)
    .s retmoney=$p(retmoney,$c(1),1)
    .s retqty=$p(^DHCPHRTI(ret,"RTI",retsub),"^",3)
    .s retqty=$p(retqty,$c(1),1)
    .s retunit=$p(^DHCPHRTI(ret,"RTI",retsub),"^",4)
    .s retunit=$p(retunit,$c(1),1)
    .s ord="",itm="",itmmast="",inci="",phdesc="",uomdesc=""
    .s ord=$p(oeori,"||",1)
    .s itm=$p(oeori,"||",2)
    .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    .s itmmastid="",itmmastver=""
    .s itmmastid=$p(itmmast,"||",1)
    .s itmmastver=$p(itmmast,"||",2)
    .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci)) 
    .s inci=$p(inci,$c(1),1)  
    .s phuomid=""
    .s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
    .q:phuomid=""
    .s puruom="",puruomdesc="",basuom="",basuomdesc=""
    .s puruom=+$p(^INCI(inci,3),"^",6)
    .s puruomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
    .s basuom=+$p(^INCI(inci,1),"^",10)
    .s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
    .s confac=1,conrow=""
    .i phuomid=retunit  s confac=1
    .e  d
        ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
        ..s confac=+$p(^CT("CTCF",conrow),"^",3)       
    .s phdesc=$p(^INCI(inci,1),"^",2)
    .i phdesc["-" s phdesc=$p(phdesc,"-",2)
    .i retunit'="" s uomdesc=$p(^CT("UOM",retunit),"^",2)
    .s qty=0,newunit="",getnum=0,newunitdesc="",newprice=0
    .s getnum=$p((retqty/confac),".",1)
    .i getnum="" s getnum=0
    .i getnum=(retqty/confac) d
        ..s newunit=phuomid
        ..s newunitdesc=puruomdesc
	    ..s qty=getnum
	.e  d
	    ..s newunit=basuom
	    ..s newunitdesc=basuomdesc
	    ..s qty=retqty
	.s retmoney=$j(retmoney,12,2)
	
 	.Set tmp = phdesc_"^"_newunitdesc_"^"_qty_"^"_retmoney_"^"_ind
 	.Set ind=ind+1
 	.Do json.InsertRowData(tmp)
	
 	Set resultString = json.getJsonData("phdesc^newunitdesc^qty^retmoney^ind",ind)
	Kill json
	WRITE resultString
	Quit resultString
}

}
