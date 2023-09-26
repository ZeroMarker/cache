Import sqluser

Class web.DHCST.DHCPayStat Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 供应商未付款汇总统计(按供应商汇总)
/// Author:zhwh
/// Date:2012-09-02
/// Argu:
///  StartDate - 起始日期
///  EndDate-截止日期
///  Loc-科室RowId
///  Vendor-应商RowId
/// Return:
///   供应商名称,入库无发票未付金额,入库有发票未付金额,入库合计未付金额,退货未付金额,合计未付金额
Query SumVendorNotPay(StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Query(ROWSPEC = "vendorName:%String,invAmt1:%String,invAmt2:%String,recUnPayAmt:%String,retUnPayAmt:%String,sumUnpayAmt:%String")
{
}

ClassMethod SumVendorNotPayExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Loc="" $$$OK
 i EndDate="" s EndDate=+$h
 i StartDate="" s StartDate=+$h
  ;
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 q:EndDate<StartDate $$$OK
 
 k ^TMP($zn,$J,"NOTPAY")
 //统计入库
 s vendor=0,n=0
 s type="G"
 f dd=StartDate:1:EndDate  d 
 .S INTR=0 
 .f  s INTR=$o(^DHCINTR(0,"TypeDate",type,dd,INTR)) q:INTR=""  d
 ..s INGRI=$P(^DHCINTR(INTR),"^",9)
 ..s INCLB=$p(^DHCINTR(INTR),"^",7)
 ..s tmpLoc=$p(^INCI(+INCLB,"IL",$p(INCLB,"||",2)),"^",1) 
 ..i Loc'="" q:tmpLoc'=Loc ; not for the Loc 
 ..s ingr=$p(INGRI,"||",1)
 ..s ingch=$p(INGRI,"||",2)
 ..s vendor=$p(^DHCINGR(ingr),"^",3)
 ..i Ven'="" q:vendor'=Ven
 ..s invno=$p(^DHCINGR(ingr,"GRI",ingch),"^",27) 
 ..s realAmt=$p(^DHCINGR(ingr,"GRI",ingch),"^",31) 
 ..s payOver="",payedAmt=0
 ..s payinfo=..PayInfo(INGRI,type)
 ..s payedAmt=$p(payinfo,"^",1)
 ..s payOver=$p(payinfo,"^",2) q:payOver="Y" ;已付清的不统计
 ..s unPayAmt=realAmt-payedAmt
 ..s invAmt1=0,invAmt2=0
 ..i invno="" d
 ...s invAmt1=unPayAmt
 ..e  d
 ...s invAmt2=unPayAmt
 ..
 ..s invAmt1=$fn(invAmt1,"",2)
 ..s invAmt2=$fn(invAmt2,"",2)
 ..s recUnPayAmt=invAmt1+invAmt2
 ..
 ..i '$D(^TMP($zn,$J,"NOTPAY",vendor)) d
 ...s ^TMP($zn,$J,"NOTPAY",vendor)=invAmt1_"^"_invAmt2_"^"_recUnPayAmt
 ..e  d
 ...s $P(^TMP($zn,$J,"NOTPAY",vendor),"^",1)=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",1)+invAmt1
 ...s $P(^TMP($zn,$J,"NOTPAY",vendor),"^",2)=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",2)+invAmt2
 ...s $P(^TMP($zn,$J,"NOTPAY",vendor),"^",3)=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",3)+recUnPayAmt
 .

 // 统计退货
 s INGR="",i=0
 s retUnPayRpAmt=0
 s type="R"
 f dd=StartDate:1:EndDate  d 
 .s INTR="" 
 .f  s INTR=$o(^DHCINTR(0,"TypeDate",type,dd,INTR)) q:INTR=""  d
 ..s INCLB=$p(^DHCINTR(INTR),"^",7)
 ..s tmpLoc=$p(^INCI(+INCLB,"IL",$p(INCLB,"||",2)),"^",1) 
 ..i Loc'="" q:tmpLoc'=Loc ; not for the Loc 
 ..s INGRTI=$p(^DHCINTR(INTR),"^",9) ; pointer to RETURN itm
 ..;w INGRTI,!
 ..s INGRT=+INGRTI
 ..s vendor=$p(^INGRT(INGRT),"^",2)       ; vendor
 ..i Ven'="" q:vendor'=Ven
 ..s payinfo=..PayInfo(INGRTI,type)
 ..s payOver=$p(payinfo,"^",2) q:payOver="Y" ;已付清的不统计
 ..s payedAmt=$p(payinfo,"^",1)  //此值若不为空，应为负值
 ..
 ..s DHCINGRT=$P(INGRTI,"||",1)
 ..s DHCChild=$P(INGRTI,"||",2)
 ..s retAmt=-$p($G(^INGRT(DHCINGRT,"DHCGRR",DHCChild)),"^",4)  //取负值
 ..s retUnPayRpAmt=retUnPayRpAmt+(retAmt-payedAmt)
 ..s retUnPayRpAmt=$fn(retUnPayRpAmt,"",2)
 ..
 ..i '$d(^TMP($zn,$J,"NOTPAY",vendor)) d
 ...s ^TMP($zn,$J,"NOTPAY",vendor)="^^^"_retUnPayRpAmt
 ..e  d
 ...s $P(^TMP($zn,$J,"NOTPAY",vendor),"^",4)=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",4)+retUnPayRpAmt
 // 
 s vendor=""
 f  s vendor=$o(^TMP($zn,$J,"NOTPAY",vendor)) q:vendor=""  d
 .s vendorName=$p($G(^APC("APCVM",vendor)),"^",3)
 .s invAmt1=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",1)
 .s invAmt2=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",2)
 .s recUnPayAmt=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",3)
 .s retUnPayAmt=$P(^TMP($zn,$J,"NOTPAY",vendor),"^",4)
 .s sumUnpayAmt=recUnPayAmt+retUnPayAmt
 .d OutPutRow1
 .
 k ^TMP($zn,$J,"NOTPAY")
 Quit $$$OK
 
OutPutRow1
 s Data=$lb(vendorName,invAmt1,invAmt2,recUnPayAmt,retUnPayAmt,sumUnpayAmt)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod SumVendorNotPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SumVendorNotPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SumVendorNotPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SumVendorNotPayExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 入库(或退货)明细记录是否付清
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
///  Pointer - 入库(或退货)明细rowid
///  Type - 类型代码(入库-G或退货-R)
/// Return:
///  付款信息(已付款金额^付清标志)
ClassMethod PayInfo(Pointer, Type)
{
 n (Pointer,Type)
 s i=0
 s payedAmt=0
 s payOverFlag=""
 s PAY=$o(^DHCPAY(0,"TYPEGR",Type,Pointer,""),-1)   
 i PAY'="" d
 .s PayCh=$o(^DHCPAY(0,"TYPEGR",Type,Pointer,PAY,""),-1)   //查找最后一条
 .i PayCh'="" d
 ..i '$d(^DHCPAY(PAY,"I",PayCh)) q 
 ..s payedAmt= $P(^DHCPAY(PAY,"I",PayCh),"^",4)
 ..s payOverFlag=$P(^DHCPAY(PAY,"I",PayCh),"^",7)
 ..
 q payedAmt_"^"_payOverFlag
}

/// 供应商未付款明细统计
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
///   StartDate-起始日期
///   EndDate-截止日期
///   Loc-科室rowid
///   Ven-供应商rowid
///   IncludeRet-包括退货
/// Return:
///   入库(退货)明细rowid,入库(退货)单号,供应商名称，入库(退货)日期，代码，名称，单位，数量，进价，进价金额，售价，售价金额，规格，厂商，批号，效期，发票号，发票日期，发票金额，随行单号
Query SumVendorNotPayItm(StartDate As %String, EndDate As %String, Loc As %String, Ven As %String, IncludeRet As %String) As %Query(ROWSPEC = "ingri:%String,ingrNo:%String,ingrDate:%String,vendorName:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,qty:%String,uomDesc:%String,invNo:%String,invDate:%String,invAmt:%String,sxNo:%String,rp:%String,rpAmt:%String,sp:%String,spAmt:%String,unPayAmt:%String,batNo:%String,expDate:%String,trType:%String")
{
}

ClassMethod SumVendorNotPayItmExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String, Ven As %String, IncludeRet As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 
 k ^TMP($zn,$j,"SumVendorNotPayItm")
 //统计入库
 s trType="G"
 s n=0
 f dd=StartDate:1:EndDate  d 
 .s INTR="" 
 .f  s INTR=$o(^DHCINTR(0,"TypeDate",trType,dd,INTR)) q:INTR=""  d
 ..s INCLB=$p(^DHCINTR(INTR),"^",7) 
 ..s pointer=$p(^DHCINTR(INTR),"^",9 )
 ..s ingri=pointer
 ..s payInfo=..PayInfo(ingri,trType)
 ..s payOver=$P(payInfo,"^",2)
 ..q:payOver="Y"   //已经付清
 ..s payedAmt=$P(payInfo,"^",1)
 ..
 ..s qty=$p(^DHCINTR(INTR),"^",6) 
 ..s uom=$p(^DHCINTR(INTR),"^",10) 
 ..i uom'="" s uomDesc=$p(^CT("UOM",uom),"^",2)
 ..
 ..s ingr=+ingri
 ..s ch=$P(ingri,"||",2)
 ..s vendor=$P(^DHCINGR(ingr),"^",3)
 ..s vendorName=$p(^APC("APCVM",vendor),"^",3)
 ..q:Loc'=$p(^INCI(+INCLB,"IL",$P(INCLB,"||",2)),"^",1)
 ..i Ven'="" q:vendor'=Ven
 ..s ingrNo=$p(^DHCINGR(ingr),"^",1)
 ..s ingrDate=$p(^DHCINGR(ingr),"^",4)
 ..i ingrDate'="" s ingrDate=$zd(ingrDate,3)
 ..s inci=+INCLB
 ..s inciCode=$p(^INCI(inci,1),"^",1)
 ..s inciDesc=$p(^INCI(inci,1),"^",1)
 ..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ..s manf=$P(^DHCINGR(ingr,"GRI",ch),"^",29)
 ..s rp=$P(^DHCINGR(ingr,"GRI",ch),"^",30)
 ..s rpAmt=$P(^DHCINGR(ingr,"GRI",ch),"^",31)
 ..s sp=$P(^DHCINGR(ingr,"GRI",ch),"^",32)
 ..s spAmt=$P(^DHCINGR(ingr,"GRI",ch),"^",50)
 ..s upPanAmt=rpAmt-payedAmt
 ..s batNo="",expDate=""
 ..&sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate into :batNo,:expDate from inc_itmlcbt where %ID=:INCLB)
 ..i expDate'="" s expDate=$zd(expDate,3)
 ..s invNo=$P(^DHCINGR(ingr,"GRI",ch),"^",27)
 ..s invDate=$P(^DHCINGR(ingr,"GRI",ch),"^",34)
 ..i invDate'="" s invDate=$zd(invDate,3)
 ..s invAmt=$P(^DHCINGR(ingr,"GRI",ch),"^",26)
 ..s sxNo=$P(^DHCINGR(ingr,"GRI",ch),"^",38)
 ..s n=n+1
 ..s ^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo,ingri,n)=$lb(ingri,ingrNo,ingrDate,vendorName,inci,inciCode,inciDesc,spec,manf,qty,uomDesc,invNo,invDate,invAmt,sxNo,rp,rpAmt,sp,spAmt,unPayAmt,batNo,expDate,trType)
 ..

 i IncludeRet'="1" d PopulateRow Quit $$$OK  //是否统计退货
 
 //统计退货
 s trType="R"
 s n=0
 f dd=StartDate:1:EndDate  d 
 .s INTR="" 
 .f  s INTR=$o(^DHCINTR(0,"TypeDate",trType,dd,INTR)) q:INTR=""  d
 ..s INCLB=$p(^DHCINTR(INTR),"^",7) 
 ..s pointer=$p(^DHCINTR(INTR),"^",9 )
 ..s ingrti=pointer
 ..s payInfo=..PayInfo(ingrti,trType)
 ..s payOver=$P(payInfo,"^",2)
 ..q:payOver="Y"   //已经付清
 ..s payedAmt=$P(payInfo,"^",1)
 ..s inci=+INCLB
 ..s inciCode=$p(^INCI(inci,1),"^",1)
 ..s inciDesc=$p(^INCI(inci,1),"^",1)
 ..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ..s ingrt=+ingrti
 ..s ch=$p(ingrti,"||",2)
 ..s ingrtNo=$P(^INGRT(ingrt),"^",1)
 ..s ingrtDate=$P(^INGRT(ingrt),"^",9)
 ..i ingrtDate'="" s ingrtDate=$zd(ingrtDate,3)
 ..s ingri=$P(^INGRT(ingrt,"DHCGRR",ch),"^",1)
 ..s ingr=+ingri
 ..s ingrCh=$p(ingri,"||",2)
 ..s manf=""
 ..s manfid=$P(^DHCINGR(ingr,"GRI",ingrCh),"^",29)
 ..i manfid'="" s manf=$P($G(^PHMNF(manfid)),"^",2)
 ..s batNo="",expDate=""
 ..&sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate into :batNo,:expDate from inc_itmlcbt where %ID=:INCLB)
 ..i expDate'="" s expDate=$zd(expDate,3)
 ..s invNo=$P(^INGRT(ingrt,"DHCGRR",ch),"^",12)
 ..s invAmt=$P(^INGRT(ingrt,"DHCGRR",ch),"^",13)
 ..s invDate=$P(^INGRT(ingrt,"DHCGRR",ch),"^",14)
 ..i invDate'="" s invDate=$zd(invDate,3)
 ..s sxNo=$P(^INGRT(ingrt,"DHCGRR",ch),"^",18)
 ..s qty=$p(^DHCINTR(INTR),"^",6) 
 ..s uomDesc=""
 ..s uom=$p(^DHCINTR(INTR),"^",10) 
 ..i uom'="" s uomDesc=$p(^CT("UOM",uom),"^",2)
 ..s rp= $p(^DHCINTR(INTR),"^",16 )
 ..s rpAmt= $p(^DHCINTR(INTR),"^",17 )
 ..s sp=$P(^INGRT(ingrt,"DHCGRR",ch),"^",14)
 ..s spAmt=$P(^INGRT(ingrt,"DHCGRR",ch),"^",8)
 ..s unPayAmt=rpAmt-payedAmt
 ..
 ..s n=n+1
 ..s ^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo,ingri,n)=$lb(ingrti,ingrtNo,ingrtDate,vendorName,inci,inciCode,inciDesc,spec,manf,qty,uomDesc,invNo,invDate,invAmt,sxNo,rp,rpAmt,sp,spAmt,unPayAmt,batNo,expDate,trType)
  
 d PopulateRow
 k ^TMP($zn,$j,"SumVendorNotPayItm")
 Quit $$$OK
PopulateRow
 s vendorName="" 
 f  s vendorName=$o(^TMP($zn,$j,"SumVendorNotPayItm",vendorName)) q:vendorName=""  d
 .s trType="" f  s trType=$o(^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType)) q:trType=""  d
 ..s ingrNo=""  f  s ingrNo=$o(^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo)) q:ingrNo=""  d
 ...s ingri=""   f  s ingri=$o(^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo,ingri))  q:ingri=""  d
 ....s n=0   f  s n=$o(^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo,ingri,n)) q:n=""  d
 .....s dataList=^TMP($zn,$j,"SumVendorNotPayItm",vendorName,trType,ingrNo,ingri,n)
 .....d OutPutRow2
 q
OutPutRow2
 s Data=dataList
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod SumVendorNotPayItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SumVendorNotPayItmExecute ]
{
 
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SumVendorNotPayItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SumVendorNotPayItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 供应商付款单汇总统计
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
///  StartDate-起始日期
///  EndDate-截止日期
///  Loc-科室RowId
///  Ven-供应商RowId=””
/// Return: 
///   供应商名称,付款单号,付款金额,入库(退货)进价金额 ,入库(退货)售价金额,进销差价金额 
///   
Query SumVendorPay(StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Query(ROWSPEC = "vendorName:%String,payNoStr:%String,payAmtSum:%String,rpAmtSum:%String,spAmtSum:%String,rpspDiffAmt:%String")
{
}

ClassMethod SumVendorPayExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 
 k ^TMP($zn,$j,"SumVendorPay")
 f dd=StartDate:1:EndDate d
 .s vendor=""
 .f  s vendor=$o(^DHCPAY(0,"DateLocVen",dd,Loc,vendor)) q:vendor=""  d
 ..i Ven'="" q:vendor'=Ven
 ..s vendorName=$p(^APC("APCVM",vendor),"^",3)
 ..s payNoStr="",payAmtSum=0,rpAmtSum=0,spAmtSum=0,rpspDiffAmtSum=0
 ..s pay=0 
 ..f  s pay=$O(^DHCPAY(0,"DateLocVen",dd,Loc,vendor,pay)) q:pay=""  d
 ...s payNo=$P(^DHCPAY(pay),"^",1)
 ...
 ...i payNoStr="" s payNoStr=payNo
 ...e  s payNoStr=payNoStr_","_payNo
 ...
 ...s ch=0 
 ...f  s ch=$O(^DHCPAY(pay,"I",ch))  q:ch=""  d
 ....s payi=pay_"||"_ch
 ....s type=$p(^DHCPAY(pay,"I",ch),"^",9)
 ....s pointer=$p(^DHCPAY(pay,"I",ch),"^",2)
 ....s amt=..GetTransAmt(pointer,type)
 ....s rpAmt=$p(amt,"^",1)
 ....s spAmt=$p(amt,"^",2)
 ....s rpAmtSum=rpAmtSum+rpAmt
 ....s spAmtSum=spAmtSum+spAmt
 ....s payAmt=$p(^DHCPAY(pay,"I",ch),"^",5)
 ....s payAmtSum=payAmtSum+payAmt
 ..s rpspDiffAmtSum=spAmtSum-rpAmtSum
 ..s ^TMP($zn,$j,"SumVendorPay",vendorName)=$lb(vendorName,payNoStr,payAmtSum,rpAmtSum,spAmtSum,rpspDiffAmt)
 
 s vendorName="" 
 f  s vendorName=$o(^TMP($zn,$j,"SumVendorPay",vendorName)) q:vendorName=""  d
 .s Data=^TMP($zn,$j,"SumVendorPay",vendorName)
 .d OutPutRow3
 
 k ^TMP($zn,$j,"SumVendorPay")
 Quit $$$OK
 
OutPutRow3
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod SumVendorPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SumVendorPayExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SumVendorPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SumVendorPayExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 供应商付款单汇总统计(明细)
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
///  StartDate-起始日期
///  EndDate-截止日期
///  Loc-科室RowId
///  Ven-供应商RowId=””
///  Inci-药品RowId=””
/// Return:
///   付款单号,供应商名称,制单日期,制单人,药品名称,药品代码,规格,厂家,入库金额 ,付款金额,批号,效期,发票号,发票金额,发票日期,随行单号 
Query SumVendorPayItm(StartDate As %String, EndDate As %String, Loc As %String, Ven As %String, Inci As %String) As %Query(ROWSPEC = "payNo:%String,vendorName:%String,payDate:%String,payUserName:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,rpAmt:%String,payAmt:%String,batNo:%String,expDate:%String,invNo:%String,invAmt:%String,invDate:%String,sxNo:%String")
{
}

ClassMethod SumVendorPayItmExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String, Ven As %String, Inci As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 s n=0
 k ^TMP($zn,$j,"SumVendorPayItm")
 f dd=StartDate:1:EndDate d
 .s vendor=""
 .f  s vendor=$o(^DHCPAY(0,"DateLocVen",dd,Loc,vendor)) q:vendor=""  d
 ..i Ven'="" q:vendor'=Ven
 ..s vendorName=$p(^APC("APCVM",vendor),"^",3)
 ..s payNoStr="",payAmtSum=0,rpAmtSum=0,spAmtSum=0,rpspDiffAmtSum=0
 ..s pay=0 
 ..f  s pay=$O(^DHCPAY(0,"DateLocVen",dd,Loc,vendor,pay)) q:pay=""  d
 ...s payNo=$P(^DHCPAY(pay),"^",1)
 ...s payDate=$P(^DHCPAY(pay),"^",5)
 ...i payDate'="" s payDate=$zd(payDate,3)
 ...s payUserName="",payUser=$P(^DHCPAY(pay),"^",4)
 ...i payUser'="" s payUserName=$p($G(^SSU("SSUSR",payUser)),"^",2)
 ...s ch=0 
 ...f  s ch=$O(^DHCPAY(pay,"I",ch))  q:ch=""  d
 ....s payi=pay_"||"_ch
 ....s inci=$p(^DHCPAY(pay,"I",ch),"^",1)
 ....s inciCode=$p(^INCI(inci,1),"^",1)
 ....s inciDesc=$p(^INCI(inci,1),"^",2)
 ....s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ....
 ....s type=$p(^DHCPAY(pay,"I",ch),"^",9)
 ....s pointer=$p(^DHCPAY(pay,"I",ch),"^",2)
 ....s amt=..GetTransAmt(pointer,type)
 ....s rpAmt=$p(amt,"^",1)
 ....s spAmt=$p(amt,"^",2)
 ....s inclb=$p(amt,"^",3)
 ....s invNo=$p(amt,"^",4)
 ....s invDate=$p(amt,"^",5)
 ....s invAmt=$p(amt,"^",6)
 ....
 ....s batNo="",expDate=""
 ....&sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate into :batNo,:expDate from inc_itmlcbt where %id=:inclb)
 ....i expDate'="" s expDate=$zd(expDate,3)
 ....s payAmt=$p(^DHCPAY(pay,"I",ch),"^",5)
 ....
 ....s n=n+1
 ....s ^TMP($zn,$j,"SumVendorPayItm",vendorName,payNo,n)=$lb(payNo,vendorName,payDate,payUserName,inci,inciCode,inciDesc,spec,manf,rpAmt,payAmt,batNo,expDate,invNo,invAmt,invDate,sxNo)
 ....
 
 s vendorName=""
 f  s vendorName=$o(^TMP($zn,$j,"SumVendorPayItm",vendorName)) q:vendorName=""  d
 .s payNo="" f  s payNo=$o(^TMP($zn,$j,"SumVendorPayItm",vendorName,payNo)) q:payNo=""  d
 ..s n=0 f  s n=$o(^TMP($zn,$j,"SumVendorPayItm",vendorName,payNo,n)) q:n=""  d
 ...s Data=^TMP($zn,$j,"SumVendorPayItm",vendorName,payNo,n) 
 ...d OutPutRow4
 k ^TMP($zn,$j,"SumVendorPayItm")
 Quit $$$OK
 
OutPutRow4
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod SumVendorPayItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SumVendorPayItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SumVendorPayItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SumVendorPayItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 供应商付款发票汇总统计
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
/// StartDate-起始日期
/// EndDate-截止日期
/// Loc-科室rowid
/// Ven-供应商rowid
/// Return: 
///  发票号,供应商,付款金额 ,入库金额
/// 
Query PaySumByVendorInv(StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Query(ROWSPEC = "invNo:%String,vendorName:%String,payAmt:%String,rpAmt:%String,spAmt:%String")
{
}

ClassMethod PaySumByVendorInvExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String, Ven As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 s n=0
 k ^DHCSTTMP($zn,$j,"V")
 f dd=StartDate:1:EndDate d
 .s vendor=""
 .f  s vendor=$o(^DHCPAY(0,"DateLocVen",dd,Loc,vendor)) q:vendor=""  d
 ..i Ven'="" q:vendor'=Ven
 ..s vendorName=$p(^APC("APCVM",vendor),"^",3)
 ..s payNoStr="",payAmtSum=0,rpAmtSum=0,spAmtSum=0,rpspDiffAmtSum=0
 ..s pay=0 
 ..f  s pay=$O(^DHCPAY(0,"DateLocVen",dd,Loc,vendor,pay)) q:pay=""  d
 ...s ch=0 
 ...f  s ch=$O(^DHCPAY(pay,"I",ch))  q:ch=""  d
 ....
 ....s pointer=$p(^DHCPAY(pay,"I",ch),"^",2)
 ....s type=$p(^DHCPAY(pay,"I",ch),"^",9)
 ....s payAmt=$p(^DHCPAY(pay,"I",ch),"^",5)
 ....
 ....s amt=..GetTransAmt(pointer,type)
 ....s invNo=$p(amt,"^",4)
 ....s rpAmt=$p(amt,"^",1)
 ....s spAmt=$p(amt,"^",2)
 ....i invNo="" s invNo="ELSE"
 ....
 ....i '$d(^DHCSTTMP($zn,$j,"V",invNo,vendorName)) d
 .....s ^DHCSTTMP($zn,$j,"V",invNo,vendorName)=payAmt_"^"_rpAmt_"^"_spAmt
 ....e  d
 .....s $p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",1)=$p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",1)+payAmt
 .....s $p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",2)=$p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",2)+rpAmt
 .....s $p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",3)=$p(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",3)+spAmt

 s invNo=""
 f  s invNo=$o(^DHCSTTMP($zn,$j,"V",invNo)) q:invNo=""  d
 .s vendorName=""
 .f  s vendorName=$o(^DHCSTTMP($zn,$j,"V",invNo,vendorName)) q:vendorName=""  d
 ..s payAmt=$P(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",1)
 ..s rpAmt=$P(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",2)
 ..s spAmt=$P(^DHCSTTMP($zn,$j,"V",invNo,vendorName),"^",3)
 ..d OutPutRow5
 ..
 k ^DHCSTTMP($zn,$j,"V")
 Quit $$$OK
 
OutPutRow5
 s Data=$lb(invNo,vendorName,payAmt,rpAmt,spAmt)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod PaySumByVendorInvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PaySumByVendorInvExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PaySumByVendorInvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PaySumByVendorInvExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 取某业务(入库\退货)记录的的进价金额与售价金额
/// Author:
/// Date:2012-09-04
/// Argu:
///  pointer-指针
///  type-业务类型
/// Return:
///    进价金额^售价金额^批次rowid^发票号^发票日期^发票金额
ClassMethod GetTransAmt(pointer As %String, type As %String) As %String
{
  n (pointer,type)
  s intr=$O(^DHCINTR(0,"TypePointer",type,pointer,""))
  q:intr="" ""
  s rpAmt=$P($g(^DHCINTR(intr)),"^",17)
  s spAmt=$P($g(^DHCINTR(intr)),"^",8)
  s inclb=$P($g(^DHCINTR(intr)),"^",7)
  s invNo="",invDate="",invAmt=0,sxNo=""
  i type="G" d 
  .&sql(select initm_invno,initm_invdate,initm_invmoney,initm_sxno into :invNo,:invDate,:invAmt,:sxNo from dhc_ingdrecitm where %id=:pointer)
  i type="R" d 
  .&sql(select ingrti_invno,ingrti_invdate,ingrti_invamt,ingrti_sxno into :invNo,:invDate,:invAmt,:sxNo from dhc_ingrtitm where %id=:pointer)
  
  i invDate'="" s invDate=$zd(invDate,3)
  q rpAmt_"^"_spAmt_"^"_inclb_"^"_invNo_"^"_invDate_"^"_invAmt_"^"_sxNo
}

/// 取供应商未付汇总统计数据(json)
/// Author:zhwh
/// Date:2012-09-05
/// Argu:
///  Start-起始行号
///  Limit-行数
///  QueryData-查询条件(起始日期^截止日期^科室rowid^供应商rowid)
/// Return:
///  供应商未付汇总统计数据串(json)
ClassMethod jsSumVendorNotPay(Start As %String, Limit As %String, QueryData As %String) As %String
{
 s StartDate=$p(QueryData,"^",1)
 s EndDate=$p(QueryData,"^",2)
 s Loc=$p(QueryData,"^",3)
 s Ven=$p(QueryData,"^",4)
 s result=##class(%ResultSet).%New("web.DHCST.DHCPayStat:SumVendorNotPay")
 s sc=result.Execute(StartDate,EndDate,Loc,Ven)
 i $$$ISERR(sc) q $$$OK
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取供应商未付明细统计数据(json)
/// Author:zhwh
/// Date:2012-09-05
/// Argu:
///  Start-起始行号
///  Limit-行数
///  QueryData-查询条件(起始日期^截止日期^科室rowid^供应商rowid^包含退货)
/// Return:
///  供应商未付明细统计数据串(json)
ClassMethod jsSumVendorNotPayItm(Start As %String, Limit As %String, QueryData As %String) As %String
{
 s StartDate=$p(QueryData,"^",1)
 s EndDate=$p(QueryData,"^",2)
 s Loc=$p(QueryData,"^",3)
 s Ven=$p(QueryData,"^",4)
 s IncludeRet=$p(QueryData,"^",4)
 //
 s result=##class(%ResultSet).%New("web.DHCST.DHCPayStat:SumVendorNotPayItm")	
 s sc=result.Execute(StartDate,EndDate,Loc,Ven,IncludeRet)
 i $$$ISERR(sc) q $$$OK
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取供应商付款统计数据(json)
/// Author:zhwh
/// Date:2012-09-05
/// Argu:
///  Start-起始行号
///  Limit-行数
///  QueryData-查询条件(起始日期^截止日期^科室rowid^供应商rowid)
/// Return:
///  供应商付款统计数据串(json)
ClassMethod jsSumVendorPay(Start As %String, Limit As %String, QueryData As %String) As %String
{
 s StartDate=$p(QueryData,"^",1)
 s EndDate=$p(QueryData,"^",2)
 s Loc=$p(QueryData,"^",3)
 s Ven=$p(QueryData,"^",4)
 s result=##class(%ResultSet).%New("web.DHCST.DHCPayStat:SumVendorPay")	
 s sc=result.Execute(StartDate,EndDate,Loc,Ven)
 i $$$ISERR(sc) q $$$OK
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取供应商付款明细数据(json)
/// Author:zhwh
/// Date:2012-09-05
/// Argu:
///  Start-起始行号
///  Limit-行数
///  QueryData-查询条件(起始日期^截止日期^科室rowid^供应商rowid^库存项rowid)
/// Return:
///  供应商未付明细数据串(json)
ClassMethod jsSumVendorPayItm(Start As %String, Limit As %String, QueryData As %String) As %String
{
	
 s StartDate=$p(QueryData,"^",1)
 s EndDate=$p(QueryData,"^",2)
 s Loc=$p(QueryData,"^",3)
 s Ven=$p(QueryData,"^",4)
 s Inci=$p(QueryData,"^",5)	
 ;
 s result=##class(%ResultSet).%New("web.DHCST.DHCPayStat:SumVendorPayItm")	
 s sc=result.Execute(StartDate,EndDate,Loc,Ven,Inci)
 i $$$ISERR(sc) q $$$OK
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取供应商付款按发票统计数据(json)
/// Author:zhwh
/// Date:2012-09-05
/// Argu:
///  Start-起始行号
///  Limit-行数
///  QueryData-查询条件(起始日期^截止日期^科室rowid^供应商rowid)
/// Return:
///  供应商付款按发票统计数据串(json)
ClassMethod jsPaySumByVendorInv(Start As %String, Limit As %String, QueryData As %String) As %String
{
 s StartDate=$p(QueryData,"^",1)
 s EndDate=$p(QueryData,"^",2)
 s Loc=$p(QueryData,"^",3)
 s Ven=$p(QueryData,"^",4)
 s result=##class(%ResultSet).%New("web.DHCST.DHCPayStat:PaySumByVendorInv")	
 s sc=result.Execute(StartDate,EndDate,Loc,Ven)
 i $$$ISERR(sc) q $$$OK
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 //w colNameStr,!
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

}
