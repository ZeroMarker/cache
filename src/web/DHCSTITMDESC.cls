Import SQLUser

Class web.DHCSTITMDESC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindItm(input As %String) As %String
{
	n (input)
	&sql(DECLARE curitm CURSOR FOR
	        select distinct inca_inci_dr from inc_alias where 
	                %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input) )  
	;
	&sql(OPEN curitm)
	;
	n SQLCODE 
	s num=1
	n itmrowid
	f  &sql(fetch curitm into :inci )  q:SQLCODE  d
	   .s ^TMP($j,"Itmrowid",num)=inci
	   .s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	   .s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	   .s tmpuodr=$p(^INCI(inci,1),"^",10)
	   .i tmpuodr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	   .s num=num+1
	   .
	s P5=num-1 
	;   
	&sql(close curitm)
	q P5
}

ClassMethod FindItmByStkGrp(input, stkgrpcode, stkgrptype As %String) As %String
{
	n (input,stkgrpcode,stkgrptype,%session)
	s input=$g(input),stkgrpcode=$g(stkgrpcode),stkgrptype=$g(stkgrptype) 
	s LocID=$g(%session.Data("LOGON.CTLOCID"))
	i $p($g(^CTLOC(LocID)),"^",13)="D" s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(LocID)
	e  s HospString=""
	s num=1
	k ^TMP($j,"Itmrowid"),^TMP($j,"Itmcode"),^TMP($j,"Itmdesc"),^TMP($j,"ItmUO")
	i stkgrpcode'="" d
	.&sql(DECLARE cur CURSOR FOR
	        select distinct inca_inci_dr    from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	.&sql(OPEN cur)
	.f  &sql(fetch cur into :inci)  q:SQLCODE  d
	..q:..CatGrpCode(inci)'=stkgrpcode  ; not belong to the specified cat group 
	..q:'$d(^INCI("IL_LOC",LocID,inci))&(HospString'="") 
	..s ^TMP($j,"Itmrowid",num)=inci
	..s ^TMP($j,"Itmcode",num)=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",1)
	..s ^TMP($j,"Itmdesc",num)=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",2)
	..s uomdr=$p(^INCI(^TMP($j,"Itmrowid",num),1),"^",10)
	..s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	..s num=num+1
	..
	.&sql(close cur)
	e  d
	.i stkgrptype="" d
	..&sql(DECLARE curt CURSOR FOR
	        select distinct inca_inci_dr   from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	..&sql(OPEN curt)
	..f  &sql(fetch curt into :inci)  q:SQLCODE  d
	...q:'$d(^INCI("IL_LOC",LocID,inci))&(HospString'="") 
	...s ^TMP($j,"Itmrowid",num)=inci
	...s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	...s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	...s uomdr=$p(^INCI(inci,1),"^",10)
	...s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	...s num=num+1
	..&sql(close curt)
	.e  d
	..&sql(DECLARE curtt CURSOR FOR
	        select distinct inca_inci_dr from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	..&sql(OPEN curtt)
	..f  &sql(fetch curtt into :inci )  q:SQLCODE  d
	...q:..CatType(inci)'=stkgrptype
	...q:'$d(^INCI("IL_LOC",LocID,inci))&(HospString'="") 
	...s ^TMP($j,"Itmrowid",num)=inci
	...s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	...s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	...s uomdr=$p(^INCI(inci,1),"^",10)
	...s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	...s num=num+1
	..&sql(close curtt)
	s P5=num-1 
	q P5
}

ClassMethod CatGrpCode(inci As %String) As %String
{
	 n (inci)
	q:'$d(^INCI(inci,2)) ""
	s INCSC=$p(^INCI(inci,2),"^",2)
	q:INCSC="" ""
	s SCG=$o(^DHCSCG("STKCAT",+INCSC,"")) q:SCG="" ""
	;s CH=$o(^DHCSCG("STKCAT",INCSC,SCG,"")) q:CH="" ""
	s CATGRPCODE=$P(^DHCSCG(+SCG),"^",1)
	q $g(CATGRPCODE)
}

ClassMethod CatType(inci As %String) As %String
{
 n (inci)
	q:'$d(^INCI(inci,2)) ""
	s INCSC=$p(^INCI(inci,2),"^",2) q:INCSC="" ""
	s SCG=$o(^DHCSCG("STKCAT",+INCSC,"")) q:SCG="" ""
	;s CH=$o(^DHCSCG("STKCAT",INCSC,SCG,"")) q:CH="" ""
	s CATTYPE=$P(^DHCSCG(+SCG),"^",3)
	q $g(CATTYPE)
}

ClassMethod ListItms(i As %Integer) As %String
{
	s a=^TMP($j,"Itmrowid",i)
	s b=^TMP($j,"Itmcode",i)
	s c=^TMP($j,"Itmdesc",i)
	s d=^TMP($j,"ItmUO",i)
	q a_"^"_b_"^"_c_"^"_d
}

ClassMethod kTmpOutPut() As %String
{
		k ^TMP($j,"Itmrowid")
	 k ^TMP($j,"Itmcode")
	 k ^TMP($j,"Itmdesc") 
	 k ^TMP($j,"ItmUO")
}

ClassMethod GetItmMessage(itm As %String) As %String
{
  n (itm)
	&sql(select inci_ctuom_dr->ctuom_desc,inci_incsc_dr->incsc_desc
	    into :ItmUOdesc,:Itmcatdesc   from inc_itm 
	   where inci_code=:itm )
	s P1=$g(ItmUOdesc),P2=$g(Itmcatdesc)
	q P1_"^"_P2
}

ClassMethod GetItmBat(ItmCode As %String) As %String
{
	s num=1
	&sql(DECLARE bat CURSOR FOR
	        select distinct(inclb_incib_dr),inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate from inc_itmlcbt
	         where inclb_incil_parref->incil_inci_parref->inci_code=:ItmCode and
	               inclb_phyqty>0)        
	&sql(OPEN bat)      
	f  &sql(fetch bat into :btrd,:batno,:exp)  q:SQLCODE  d           
	   .s exp=$zd($p($g(exp),$c(1)),3)
	   .s brd=$p($g(btrd),$c(1))
	   .s PLIST(num)=$g(batno)_"^"_$g(exp)_"^"_$g(btrd)
	   .s num=num+1
	&sql(close bat)
	i SQLCODE=100 set num=0  
	s PLIST=num-1  
	s num=num-1   
	q num
}

ClassMethod GetReqMsgForItm(itmcode As %String, requestNO As %String) As %String
{
	n (itmcode,requestNO)
	&sql(SELECT INRQI_REQQTY,INRQI_CTUOM_DR->CTUOM_DESC INTO :a,:b  FROM IN_REQITM
	     WHERE INRQI_INRQ_PARREF->INRQ_NO=:requestNO AND INRQI_INCI_DR->INCI_CODE=:itmcode )
	i SQLCODE=100 s a="",b=""
	q +$g(a)_"^"_$g(b)
}

ClassMethod GetItmByAlias(alias As %String) As %String
{
	s num=1
	&sql(declare calias cursor for select alias_arcim_dr->arcim_code from arc_alias where alias_text like :alias)
	&sql(open calias)
	f   &sql(fetch calias into :itmmast(num))  q:SQLCODE  d
	        .s x=itmmast(num)
	        .s PLIST(num)=..GetItm(x)
	        .s num=num+1
	&sql(close calias)
	s P5=num-1
	s PLIST=num-1      
	q 0
}

ClassMethod GetItm(mast As %String) As %String
{
	n Result,itmcode,itmdesc
	&sql(select inci_code,inci_desc into :itmcode,:itmdesc from inc_itm where inci_code=:mast)
	s Result=$g(itmcode)_"^"_$g(itmdesc)
	q Result
}

ClassMethod GetItmBatPhyQty(itmcode, ctdesc As %String) As %String
{
	n phyqty
	s phyqty=##class(web.DHCSTSTKQTY).CurQty(itmcode,ctdesc) ; Get current qty 
	;
	q phyqty
}

ClassMethod GetVenDors() As %Integer
{
   n i,VenName
	s i=0
	&sql(DECLARE V CURSOR FOR select APCVM_Name from APC_Vendor order by apcvm_name)
	&sql(OPEN V)
	f   &sql(FETCH V INTO :VenName)  q:SQLCODE  d
	    .s i=i+1
		.s ^TMP($j,"VEN",i)=VenName
	&sql(CLOSE V)
	q i
}

ClassMethod ListVendors(i As %Integer) As %String
{
	i $d(^TMP($j,"VEN",i)) q ^TMP($j,"VEN",i)
	q ""
}

ClassMethod GetUOs(itmcode As %String) As %String
{
	;get the uom and purchase uom of one item by its code
	n (itmcode)
	&sql(select inci_ctuom_dr->ctuom_desc,inci_ctuom_purch_dr->ctuom_desc 
	        into :uoa,:uob from inc_itm where inci_code=:itmcode)
	q $g(uoa)_"^"_$g(uob)
}

ClassMethod GetManfName(itmcode As %String) As %String
{
  	;get the manufecturer NAME( in phc_drugform ) of one item by its code
	n (itmcode)
	&sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
	        into :manf from inc_itm where inci_code = :itmcode)
	q $g(manf)
}

ClassMethod GetManfNameByInci(itmid As %String) As %String
{
  	n (itmid)
	&sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
	        into :manf from inc_itm where inci_RowID = :itmid)
	q $g(manf)
}

ClassMethod GetPhaRowId(itmcode As %String) As %String
{
	;get the drug item ROWID of one item by its code
	n (itmcode)
	&sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_rowid
	        into :phard from inc_itm where inci_code = :itmcode)
	q +$g(phard)
}

ClassMethod GetBaseUoByCode(itm As %String) As %String
{
	;get UOM_DR of one item by its code
	n (itm)
	&sql(SELECT INCI_CTUOM_DR into :uo FROM INC_ITM  WHERE INCI_CODE=:itm)
	q +$g(uo)
}

ClassMethod GetBaseUoDescByCode(itm As %String) As %String
{
	;get UOM_Desc  of one item by its code
	n (itm)
	&sql(SELECT INCI_CTUOM_DR->CTUOM_DESC into :uodesc FROM INC_ITM  WHERE INCI_CODE=:itm)
	q $g(uodesc)
}

ClassMethod GetItmCat(itmcode As %String) As %String
{
	;get item cat rowid of one item by its code
	n QQ
	&sql(select inci_incsc_dr into :QQ from inc_itm  where inci_code=:itmcode)
	q +($g(QQ))
}

ClassMethod GetItmCatCode(itmcode As %String) As %String
{
	n QQ       
	&sql(select inci_incsc_dr->incsc_code into :QQ from inc_itm  where inci_code=:itmcode)
	q $g(QQ)
}

ClassMethod GetItmCatDesc(itmcode As %String) As %String
{
	n QQ
	&sql(select inci_incsc_dr->incsc_desc into :QQ from inc_itm  where inci_code=:itmcode)
	q $g(QQ)
}

ClassMethod GetItmRowid(itmcode As %String) As %String
{
	;get rowid of one item by its code
	q ..ItemCodeToID(itmcode)
}

ClassMethod ItemCodeToID(Tmp As %String) As %String
{
	;get rowid of one item by its code
	n QQ                
	&sql(SELECT INCI_ROWID INTO :QQ FROM INC_ITM  WHERE INCI_CODE=:Tmp)
	q $p($g(QQ),$c(1))
}

ClassMethod GetItmCurtPrice(Code As %String) As %String
{
	s tmpUo=..GetUOs(Code)
	;s UOM=PLIST(1)
	;s PURUOM=PLIST(2)
	s UOM=$p(PURUOM,"^",1),PURUOM=$p(PURUOM,"^",2)
	;
	s PRICE=##class(web.DHCSTCOMMONSRV).GetItemSp(Code)
	S P2=UOM
	S P3=PURUOM
	s PRICE=$p(PRICE,"^",1)
	q PRICE
}

ClassMethod GetPoison() As %String
{
	s i=0
	&sql(DECLARE pois CURSOR FOR
	   select phcpo_desc from phc_poison )
	&sql(OPEN pois)
	f  &sql(FETCH pois INTO :poison)  q:SQLCODE  d
	.s i=i+1
	.s PLIST(i)=poison
	&sql(CLOSE pois)
	s PLIST=i
	s P0=i
	q 0
}

ClassMethod GetVendorCode(vendorname As %String) As %String
{
	  n (vendorname)
	  &sql(select apcvm_code into :code  from apc_vendor 
	       where apcvm_name=:vendorname)
	  q $g(code)
}

ClassMethod GetReqUser(reqno As %String) As %String
{
	n (reqno)
	&sql(select INRQ_SSUSR_DR->ssusr_name into :reqer  from in_request 
	   where inrq_no=:reqno)
	q $g(reqer)
}

ClassMethod GetDefaultDept(initials As %String) As %String
{
	n dept
	&sql(select ssusr_defaultdept_dr into :dept  from ss_user 
	   where ssusr_initials=:initials)
	q $p($g(dept),$c(1))
}

ClassMethod GetUserRd(initial As %String) As %String
{
	n urd
	&sql(select ssusr_rowid into :urd  from ss_user 
	   where ssusr_initials=:initial)
	q $p($g(urd),$c(1))
}

ClassMethod GetLocRd(locname As %String) As %String
{
	  n (locname)
	  s P7=##class(web.DHCSTCOMMONSRV).LocToRowID(locname)
	  q P7
}

ClassMethod GetRetReason() As %String
{
   s i=0
   &sql(DECLARE retreason CURSOR FOR
       select ret_desc from inc_reasonforreturn)
   &sql(OPEN retreason)
   f  &sql(FETCH retreason INTO :reason)  q:SQLCODE  d
   .s i=i+1
   .s PLIST(i)=reason
   &sql(CLOSE retreason)
   s PLIST=i
   s P0=i
   q 0
}

ClassMethod GetLateDate(desc As %String) As %String
{
	n maxdate
	&sql(select max(ingr_date) into :maxdate from in_gdrec where in_gdrecitm->ingri_inclb_dr->inclb_incil_parref->incil_inci_parref->inci_code=:desc)
	q $g(maxdate)
}

ClassMethod GetItmBatMnf(ibt As %String) As %String
{
	;s ibt=$g(ibt)
	;q:ibt="" ""
	;s mnf=""
	;&sql(select initm_phmnf_dr->phmnf_name into :mnf from ingritmad  where initm_ingri_dr->ingri_inclb_dr->inclb_incib_dr=:ibt)
	;q $g(mnf)	
	q ""
}

}
