Class CHSSWeb.Pharmacy.OutReturnPha Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-21
/// description: 读取卡信息
/// input:  CardType(卡类型)  CardNo(卡号)
/// output: String 
/// others:
ClassMethod GetAccInfoFromCardNo(CardType As %Library.String, CardNo As %Library.String) As %Library.String
{
	SET resultString = ##class(CHSSWeb.DTHealthCommon).GetPatInfoFromCardNo(CardType,CardNo)
	SET CFPAPMINo = $P(resultString, "^", 2)
	if CFPAPMINo="" D
	.w "{""success"":""false"",""info"":""没有查询结果!""}"
	ELSE  D
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	Q ""
}

/// creator:zhangyong
/// date:2011-10-21
/// description: 读取卡信息
/// input:  PapmiNo(登记号)
/// output: String 
/// others:
ClassMethod GetAccInfoFromPapmiNo(PapmiNo As %Library.String) As %Library.String
{
	SET resultString = ##class(CHSSWeb.DTHealthCommon).GetPatInfoFromPapmiNo(PapmiNo)
	if resultString="" D
	.w "{""success"":""false"",""info"":""没有查询结果!""}"
	ELSE  D
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	Q ""
}

/// creator:zhangyong
/// date:2011-10-21
/// description: 病患收据列表
/// input:  ctloc(药房)  CDate(收费日期)  CPmiNo(登记号)
/// output: String  PrtInv^PapmiName^PhaData^PrtInvRowId^PhaPrescNo^PrtInvNewRowId^ctloc
/// others:
ClassMethod QueryPRT(ctloc As %Library.String = "", CDate As %Library.String = "", CPmiNo As %Library.String = "") As %Library.String
{
	Set json = ##class(Code.JsonObj).%New()
	Set count=0
	
	Set resultString = "{""success"":""false"",""info"":""没有查询结果!""}"
	s phl="",stdate=""
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s basphl="",basloc=""
	s basphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phl)
	s basloc=+$p(^DHCPHLOC(basphl),"^",1)
	Quit:phl="" resultString
	Quit:CPmiNo="" resultString
	if CDate'="" s stdate=$zdh(CDate,3)
	s pmi="",m=0,pername="",lzero=""
	s pmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(CPmiNo),""))
	s pername=$p(^PAPER(pmi,"ALL"),"^",1)
	s phd="0"
	f  s phd=$o(^DHCPHDISPi("PAPMI",pmi,phd)) q:(phd="")!(phd="0")   d
	.s prt="",phdphl="",newprt=""
	.q:'$d(^DHCPHDISP(phd))
	.s prt=+$p(^DHCPHDISP(phd),"^",2)
    .s phdphl=+$p(^DHCPHDISP(phd,1),"^",1)
	.s phdbasphl=""
    .s phdbasphl=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phdphl)
    .q:phdbasphl'=basphl
	.q:'$d(^DHCINVPRT(prt))
    .s fyflag=$p(^DHCPHDISP(phd),"^",4)
    .q:fyflag'="1"
	.s newprt=..GetNewPrt(prt)
	.i newprt=""  s newprt=prt
    .s prtdate="",phdl="",prescno=""
    .s prtdate=+$p(^DHCINVPRT(newprt),"^",5)
    .q:(prtdate'=stdate)&(stdate'="")
    .s phdsub="",ph=0
    .f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdsub)) q:(phdsub="")!(ph=1)  d
    ..s dispqty=0,retqty=0,cyqty=0
    ..s dispqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
    ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",6)
    ..s cyqty=dispqty-retqty
    ..q:cyqty=0
    ..s ph=ph+1
    .q:ph=0
    .s prtdate=$zd(prtdate,3)
    .s prescno=$p(^DHCPHDISP(phd,2),"^",1)
    .s prtinv=""
    .s prtinv=$p(^DHCINVPRT(newprt),"^",14)
	.Set tmp = prtinv_"^"_pername_"^"_prtdate_"^"_prt_"^"_prescno_"^"_newprt_"^"_ctloc
	.Set count = count + 1
	.Do json.InsertRowData(tmp)
	Set resultString = json.getJsonData("PrtInv^PapmiName^PhaData^PrtInvRowId^PhaPrescNo^PrtInvNewRowId^ctloc",count)
	Kill json
	WRITE resultString
	Quit resultString
}

/// creator:zhangyong
/// date:2011-10-21
/// description: 根据收据号取得新的RowId
/// input:  prt(收据号)
/// output: String  RowId
/// others:
ClassMethod GetNewPrt(prt) As %Library.String
{
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                 
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

/// creator:zhangyong
/// date:2011-10-24
/// description: 取得退药信息
/// input:  ctloc(药房)  CPrt(收据号ID)  CPrescNo(处方签号)  CurrReqNo
/// output: String  RowId
/// others:
ClassMethod QueryRetPh(ctloc As %Library.String = "", CPrt As %Library.String = "", CPrescNo As %Library.String = "", CurrReqNo As %Library.String = "") As %Library.String
{
 	Set json = ##class(Code.JsonObj).%New()
	Set count=0
 	Set resultString = "{""success"":""false"",""info"":""没有查询结果!""}"
 	s HospitalCode=""
	s str=$g(^DHCDocConfig("CurrentHospital"))
	s HospitalCode=$p(str,"^",1)
	s HospitalCode="ZGYDYY"
	s ind=1
	s phl=""
	s ^TANGD=ctloc_"^"_CPrt_"^"_CPrescNo_"^"_CurrReqNo
	i (ctloc="")&(HospitalCode'="ZGYDYY")  Quit resultString
	i (CPrt="")&(HospitalCode'="ZGYDYY") Quit resultString
	i (ctloc'="") s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	i (phl="")&(HospitalCode'="ZGYDYY") Quit resultString
	s pmi="",m=0,pername="",lzero=""
    s phd="",prt=""
    i (HospitalCode="ZGYDYY")&(CPrt="") 
    {
 	 S count=count+1
    }
    else
    {
	  s prt=CPrt
	;modify by tang 2008-07-31
	s phglrow="",twoloc="",chgroup=""
	s twoloc=##class(web.DHCOutPhAdd).GetBasLoc(ctloc)
	s chgroup=##class(web.DHCOutPhAdd).CheckGroupLoc(ctloc)
	f  s phglrow=$o(^DHCPHGLi(twoloc,phglrow)) q:phglrow=""  d
	  .s newphl=""
	  .s newphl=+$p(^DHCPHGL(phglrow),"^",5)
	  .s phld=""
      .f  s phld=$o(^DHCPHDISPi("PRT",newphl,prt,phld)) q:phld=""  d
      ..s prescno=""
      ..s prescno=$p(^DHCPHDISP(phld,2),"^",1)
      ..q:prescno'=CPrescNo
      ..s phd=phld
     i chgroup="0"  d
      .s phld=""
      .f  s phld=$o(^DHCPHDISPi("PRT",phl,prt,phld)) q:phld=""  d
      ..s prescno=""
      ..s prescno=$p(^DHCPHDISP(phld,2),"^",1)
      ..q:prescno'=CPrescNo
      ..s phd=phld
    i (phd="")&(twoloc'="") Quit resultString
   
    s phdi="",fyflag=""
	s fyflag=$p(^DHCPHDISP(phd),"^",4)
	i fyflag'="1"  Quit resultString
	f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
	 .s oeori="",payamount="",retqty="",qty="",price=0
	 .s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
	 .s payamount=$p(^DHCPHDI(phd,"PHDI",phdi),"^",3)
	 .s payamount=$p(payamount,$c(1),1)
	 .s qty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",4)
	 .;s price=payamount/qty
	 .s price=##CLASS(web.DHCOutPhDisp).GetBasPrice(prt,oeori)
	 .s retqty=$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
	 .i retqty="" s retqty=0
	 .s retqty=$p(retqty,$c(1),1)
	 .s qty=qty-retqty
	 .;q:retqty>0
	 .q:qty=0
	 .s ord="",itm=""
	 .s ord=$p(oeori,"||",1)
	 .s itm=$p(oeori,"||",2)
	 .s seqno=""
	 .s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
	 .s itmmast="",itmmastid="",itmmastver="",phdesc=""
	 .s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	 .s phuomid="",phuomdesc=""
	 .s itmmastid=$p(itmmast,"||",1)
	 .s itmmastver=$p(itmmast,"||",2)
	 .s phuomid=+$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	 .s inci="",incode=""
	 .s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
	 .q:inci=""
	 .s inci=$p(inci,$c(1),1)
	 .s itmcost=0,taruom=""
	 .s puruom="",puruomdesc="",phgg=""
	 .;s phgg=$p(^INCI(inci,3),"^",9)
	 .s phgg=##class(web.DHCSTKUTIL).GetSpec(inci)  
	 .s puruom=+$p(^INCI(inci,3),"^",6)
	 .s basuom="",basuomdesc=""
	 .s basuom=+$p(^INCI(inci,1),"^",10)
	 .s puruomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	 .s basuomdesc=$p($g(^CT("UOM",basuom)),"^",2)
	 .s confac=1,conrow=""
	 .i phuomid=basuom s confac=1
	 .e  d
	    ..s conrow=$o(^CT("CTCF",0,"UOM",phuomid,basuom,conrow))
	    ..s confac=+$p(^CT("CTCF",conrow),"^",3)
	 .s newqty=0,newunit="",getnum=0,newunitdesc="",newprice=0
	 .s getnum=$p((qty/confac),".",1)
	 .i getnum="" s getnum=0
	 .i getnum=(qty/confac) d
	   ..s newunit=puruom
	   ..s newunitdesc=puruomdesc 
	   ..s newqty=getnum
	   ..s newprice=price*confac
	 .e  d  
	   ..s newunit=basuom
	   ..s newunitdesc=basuomdesc 
	   ..s newqty=qty
	   ..s newprice=price
	 .s phdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  
	 .q:phdesc=""                                           ;INCI_DESC
	 .s phdirow=""
	 .s phdirow=phd_"||"_phdi
	  .s inclb="",phdclb=""
	  .f  s phdclb=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb)) q:(phdclb="")!(inclb'="")  d
	  ..s inclb=$p(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdclb),"^",3) 
	  .s incbatdr="",batcode=""
	  .s incbatdr=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	  .s batcode=$p( ^INCI($p(incbatdr,"||",1),"IB",$p(incbatdr,"||",2)),"^",1)

	 .s dispmoney=0
	 .s dispmoney=newprice*newqty
	 .s newprice=$j(newprice,12,4)
	 .s dispmoney=$j(dispmoney,12,2)
	 .i HospitalCode["BJYKYZLYY"  d
	      ..i phdesc["(" s phdesc=$p(phdesc,"(",1)
	      ..i phdesc["[" s phdesc=$p(phdesc,"[",1)
	 
	 .s tmp=phdesc_"^"_newunitdesc_"^"_newprice_"^"_newqty_"^"_dispmoney_"^"_""_"^"_""_"^"_phdirow_"^"_newunit_"^"_phgg_"^"_seqno_"^"_batcode_"^"_batcode
 	 .S count=count+1
 	 .Do json.InsertRowData(tmp)
 	 .s phdesc="",phuomdesc="",qty=0,retqty=0,phdirow=""
	   }
	set resultString = json.getJsonData("Phdesc^PhUom^Price^DispQty^DispMoney^RetQty^RetMoney^PhdItm^PhUomid^Phgg^SeqNo^IncDispBatCode^ReturnBatCode",count)
	Kill json
	WRITE resultString
	Quit resultString
}

/// creator:zhangyong
/// date:2011-10-21
/// description: 判断退药数量
/// input:  phditmList(药品编码列表)  qtyList(退药数量列表)  descList(药品名称列表)  count(退药笔数)
/// output: String 
/// others:
ClassMethod CheckRetQty(phditmList, qtyList, descList, count) As %Library.String
{
	
	SET desc = ""
	FOR i=1:1:count quit:desc'=""  D
	.SET phditm = $P(phditmList, "^", i)
	.SET qty = $P(qtyList, "^", i)
	.SET resultString =  ##class(web.DHCOutPhReturn).CheckRetQty(phditm, qty)
	.if resultString'="0" D
	..SET desc = $P(descList, "^", i)_","_desc 
	if (desc = "") d
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	else  d
	.w "{""success"":""false"",""info"":"""_desc_"""}"
	Q ""
}

/// creator:zhangyong
/// date:2011-10-26
/// description: 退药
/// input:  ctloc(退药药房)  userid(退药人员)  phditm(药品编码)  rfr(退药原因)  newprt(新收据号)  winpos  reqrow  RetInf(退药信息)
/// output: String 
/// others:
ClassMethod DoReturn(ctloc As %Library.String = "", userid As %Library.String = "", phditm As %Library.String = "", rfr As %Library.String = "", newprt As %Library.String = "", winpos As %Library.String = "", reqrow As %Library.String = "", RetInf As %Library.String = "") As %Library.String
{
	set userid = $P(^DHCPHPER(userid), "^", 5)
	SET resultString =  ##class(web.DHCOutPhReturn).DoReturn(ctloc,userid,phditm,rfr,newprt,winpos,reqrow,RetInf)
	if (resultString >= 0) d
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	else  d
	.w "{""success"":""false"",""info"":"""_resultString_"""}"
	Q ""
}

/// creator:zhangyong
/// date:2011-10-27
/// description: 退费
/// input:  ctloc(退药药房)  userid(退药人员)  groupid(安全组)  newprt(新收据号)  retrow(退药行RowId)  card(卡号)
/// output: String 
/// others:
ClassMethod RetMoney(ctloc As %String = "", userid As %String, groupid As %String, newprt As %String, retrow As %String, card As %String) As %Library.String
{
	set userid = $P(^DHCPHPER(userid), "^", 5)
	SET resultString =  ##class(web.DHCOutPhReturn).RetMoney(ctloc, userid, groupid, newprt, retrow, card)
	if (resultString '= "300") d
	.w "{""success"":""true"",""info"":"""_resultString_"""}"
	else  d
	.w "{""success"":""false"",""info"":"""_resultString_"""}"
	Q ""
}

Storage Default
{
<Data name="OutReturnPhaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Pharmacy.OutReturnPhaD</DataLocation>
<DefaultData>OutReturnPhaDefaultData</DefaultData>
<IdLocation>^CHSSWeb.Pharmacy.OutReturnPhaD</IdLocation>
<IndexLocation>^CHSSWeb.Pharmacy.OutReturnPhaI</IndexLocation>
<StreamLocation>^CHSSWeb.Pharmacy.OutReturnPhaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
