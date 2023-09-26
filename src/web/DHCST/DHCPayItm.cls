Import sqluser

Class web.DHCST.DHCPayItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新一条付款单明细表记录(DHC_PayItm)
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///  payI -付款单子表rowid
///  pay-付款单主表rowid(DHC_PAY)
///  data-付款明细数据串("^")
/// Return:
///   付款单子表记录rowid
///   
ClassMethod Update(payI As %String, pay As %String, data As %String) As %String
{
 s pointer=$P(data,"^",1)   //入库明细记录或退货明细记录指针
 s inci=$P(data,"^",2)   //库存项rowid
 s recAmt=$P(data,"^",3)  //入库金额(进价)
 s payAmt=$P(data,"^",4)  //付款金额
 s disc=$P(data,"^",5)  //折扣 
 s type=$P(data,"^",6) // 类型(G-入库,R-退货)
 
 i payI="" d
 .s obj=##class(User.DHCPayItm).%New()
 .d obj.PAYIPAYParrefSetObjectId(pay)
 .s ch=$O(^DHCPAY(pay,"I",""),-1)+1
 .s obj.PAYIChildsub=ch
 e  d
 .s obj=##class(User.DHCPayItm).%OpenId(payI)
 .d obj.%Reload()   
 .
 s type=$s(type="入库":"G",type="退货":"R",1:"")
 i disc'="" s disc=+disc
 s obj.PAYIDiscRate=disc
 d obj.PAYIINCIDRSetObjectId(inci)
 s obj.PAYIINGRIDR=pointer
 s obj.PAYIPayAmt=+payAmt
 s obj.PAYIPayedAmt=..GetPayedAmt(pointer,type)+payAmt   //之前的已付款+本次付款
 s obj.PAYIRecAmt=+recAmt
 s obj.PAYIRecType=type
 
 i $zabs(obj.PAYIPayedAmt)'<$zabs(+recAmt) s obj.PAYIOverFlag="Y"   //自动处理付清标志
 s sc=obj.%Save()
 i $$$ISERR(sc) d $System.Status.DisplayError(sc)
 i $$$ISERR(sc) q ""
 q obj.%Id()
}

/// 检索付款单子表明细记录数据
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///  payI -付款单子表rowid
/// Return:
///  付款单子表明细记录数据串("^"分隔)
ClassMethod Select(payI As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_PayItm where %ID=:payI )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 q result
}

/// 删除付款单子表明细记录 
/// Author:zhwh
/// Date:2012-08-29
/// Argu:
///  payI -付款单子表rowid
/// Return:
///  0 - success
///  <0 -failure
ClassMethod Delete(payI As %String) As %String
{
  n (payI)
  s ret=0
  s pay=+payI
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)<0 -99   //锁定
  q:##class(web.DHCST.DHCPay).AllowDel(pay)<0 -100  //检查是否满足删除条件
  &sql(delete from dhc_payitm where %id=:payI)
  i SQLCODE'=0 s ret=-1 
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCPay).%GetParameter("AppName")_pay)
  q ret
}

/// 根据付款单主表rowid取付款单明细数据串(json)
/// Author:zhwh
/// Date:2012-08-30
/// Argu:
/// pay - 付款单主表rowid
/// Return:
/// 付款单明细数据串(json)
ClassMethod jsDHCPayItm(Start As %String, Limit As %String, pay As %String) As %String
{
	q:pay="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	s result=##class(%ResultSet).%New("web.DHCST.DHCPayItm:DHCPayItm")
	s sc=result.%Execute(pay)  
	i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
	Q ""
}

/// 检索付款单明细
/// Author:zhwh
/// Date:2012-08-30
/// Argu:
/// pay - 付款单主表rowid
/// Return:
///  付款单明细信息数据(付款明细RowId，入库明细RowId，批次RowId，药品代码，药品名称，规格，厂商，单位，数量，进价，进价金额，售价，售价金额，批号，效期，发票号，发票日期，发票金额，随行单号 )
Query DHCPayItm(pay As %String) As %Query(ROWSPEC = "payi:%String,pointer:%String,TransType:%String,inclb:%String,INCI:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,qty:%String,uomDesc:%String,recAmt:%String,payAmt:%Float,sumPayAmt:%String,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,pp:%String,ppAmt:%String,discpDiff:%String,discAmt:%String,psDiffAmt:%String,invNo:%String,invDate:%String,invAmt:%Float,grNo:%String,insxNo:%String,batNo:%String,ExpDate:%String,OverFlag:%String,VendorIO,payNoIO,payDateIO,payTimeIO,payLocIO,userNameIO,ack1UserNameIO,ack2UserNameIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod DHCPayItmExecute(ByRef qHandle As %Binary, pay As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:pay="" $$$OK
 
 s retStr=##class(web.DHCST.DHCPay).SelectMain(pay)
 s VendorIO=$P(retStr,"^",2) 
 s payNoIO=$P(retStr,"^",1) 
 s payDateIO=$P(retStr,"^",5) 
 s payTimeIO=$P(retStr,"^",6) 
 s payLocIO=$P(retStr,"^",3) 
 s userNameIO=$P(retStr,"^",4) 
 s ack1UserNameIO=$P(retStr,"^",15)   //采购确认
 s ack2UserNameIO=$P(retStr,"^",16)    //会计确认	
 s payloc=$P(^DHCPAY(pay),"^",3)
 s hospid=$P(^CTLOC(payloc),"^",22)
 s HospDescIO=$P(^CT("HOSP",hospid),"^",2)
 // VendorIO,payNoIO,payDateIO,payTimeIO,payLocIO,userNameIO,ack1UserNameIO,ack2UserNameIO,HospDescIO

 s ch=0
 f  s ch=$o(^DHCPAY(pay,"I",ch)) q:ch=""  d
 .s payi=pay_"||"_ch q:payi=""
 .s INCI=$p(^DHCPAY(pay,"I",ch),"^",1)
 .s pointer=$p(^DHCPAY(pay,"I",ch),"^",2)
 .s OverFlag=$p(^DHCPAY(pay,"I",ch),"^",7)
 .s TransType=$p(^DHCPAY(pay,"I",ch),"^",9)
 .
 .s recAmt=$p(^DHCPAY(pay,"I",ch),"^",3)   //入库金额(进价) 
 .s payAmt=$p(^DHCPAY(pay,"I",ch),"^",5)  //本次付款金额
 .s sumPayAmt=$p(^DHCPAY(pay,"I",ch),"^",4)  //累计付款金额
 .s recAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(recAmt,hospid)
 .s payAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(payAmt,hospid)
 .s sumPayAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(sumPayAmt,hospid)
 .s recitm=""
 .i TransType="G" d
 ..s recitm=..SelRecItmInfo(pointer) ; receive info
 .e  d
 ..s recitm=..SelRetItmInfo(pointer) ;return info
 .
 .s batNo=$p(recitm,"^",1)  ; batch no
 .s manf=$p(recitm,"^",2)  ; 
 .s uomDesc=$p(recitm,"^",3)  ; 
 .s qty=$p(recitm,"^",4)  ; 
 .s pp=$p(recitm,"^",5)
 .s rp=$p(recitm,"^",6)
 .s sp=$p(recitm,"^",7)
 .s rp=##Class(web.DHCST.Common.AppCommon).FormatRp(rp,hospid,1,"G","",INCI)
 .s sp=##Class(web.DHCST.Common.AppCommon).FormatSp(sp,hospid,1,"G","",INCI)
 .s ppAmt=$p(recitm,"^",8)
 .s rpAmt=$p(recitm,"^",9)
 .s spAmt=$p(recitm,"^",10)
 .s rpAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,hospid)
 .s spAmt=##Class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,hospid)
 
 .s discpDiff=$p(recitm,"^",11)
 .s discAmt=$p(recitm,"^",12)
 .s psDiffAmt=$p(recitm,"^",13)
 .s invNo=$p(recitm,"^",14)
 .s invDate=$p(recitm,"^",15)
 .s grNo=$p(recitm,"^",16)   //业务单据号
 .s insxNo=$p(recitm,"^",17)  //随行单号
 .s inclb=$p(recitm,"^",18)
 .s ExpDate=$p(recitm,"^",19)
 .s invAmt=$p(recitm,"^",20)	//发票金额
 .s invAmt=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(invAmt,hospid)
 .s inciCode=$p($G(^INCI(INCI,1)),"^",1)
 .s inciDesc=$p($G(^INCI(INCI,1)),"^",2)
 .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",INCI)
 .s TransType=$s(TransType="G":"入库",TransType="R":"退货",1:"未知")
 .d OutPutRow
 .
  
 Quit $$$OK
OutPutRow
 s Data=$lb(payi,pointer,TransType,inclb,INCI,inciCode,inciDesc,spec,manf,qty,uomDesc,recAmt,payAmt,sumPayAmt,rp,rpAmt,sp,spAmt,pp,ppAmt,discpDiff,discAmt,psDiffAmt,invNo,invDate,$g(invAmt),grNo,insxNo,batNo,ExpDate,OverFlag,VendorIO,payNoIO,payDateIO,payTimeIO,payLocIO,userNameIO,ack1UserNameIO,ack2UserNameIO,HospDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCPayItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPayItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCPayItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPayItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 取入库明细记录信息
/// Date:2012-08-30
/// Argu:
///   ingri - 入库子表记录rowid
/// Return
///     入库明细记录信息
ClassMethod SelRecItmInfo(ingri) As %String
{
 n (ingri)
 s dhcgri=ingri
 q:dhcgri="" ""
 s DHCINGR=$p(dhcgri,"||",1) q:DHCINGR="" ""
 s DHCINGRCH=$p(dhcgri,"||",2) q:DHCINGRCH="" ""
 q:'$d(^DHCINGR(DHCINGR,"GRI",DHCINGRCH)) ""
 s RecQty=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",4)
 s Uom=+$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10)
 s UomDesc=""
 s:Uom'="" UomDesc=$p(^CT("UOM",Uom),"^",2)
 s inclb=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",1)
 s batno="",ExpDate=""
 i inclb'=""  &sql(select inclb_incib_dr->incib_no,inclb_incib_dr->INCIB_ExpDate into :batno,:ExpDate from inc_itmlcbt where %ID=:inclb)
 s manf=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",29)  ; manf dr
 i manf'="" s manf=$p(^PHMNF(manf),"^",2)  ; manf name
 i $f(manf,"-") s manf=$p(manf,"-",2)
 s pp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)  ; p - price
 s rp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",30)  ; real price
 s sp=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",32)  ; sale price
 s invono=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",27) ;Invo No
 s invodate=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",34)       ;Invo Date
 s:invodate'="" invodate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invodate,"ST")
 s invAmt=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",26)	;Invo Money
 s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+ExpDate,"ST")
 s discpdiff=pp-rp
 s discamt=discpdiff*RecQty //$fn(discpdiff*RecQty,"",2)
 s spamt=sp*RecQty  //$fn(sp*RecQty,"",2)
 s ppamt=pp*RecQty  //$fn(pp*RecQty,"",2)
 s rpamt=rp*RecQty  //$fn(rp*RecQty,"",2)
 s psdiffamt=(sp-rp)*RecQty //$fn((sp-rp)*RecQty,"",2)
 s ingrno=$p(^DHCINGR(DHCINGR),"^",1)
 s insxno=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",38)
 s ret1=$g(batno)_"^"_$g(manf)_"^"_$g(UomDesc)_"^"_$g(RecQty)_"^"_$g(pp)
 s ret2=$g(rp)_"^"_$g(sp)_"^"_$g(ppamt)_"^"_$g(rpamt)_"^"_$g(spamt)
 s ret3=$g(discpdiff)_"^"_$g(discamt)_"^"_$g(psdiffamt)_"^"_$g(invono)_"^"_$g(invodate)
 s ret4=$g(ingrno)_"^"_$g(insxno)_"^"_inclb_"^"_ExpDate_"^"_$g(invAmt)
 s ret=ret1_"^"_ret2_"^"_ret3_"^"_ret4
 q ret
}

/// 取退货明细记录信息
/// Date:2012-08-30
/// Argu:
///   ingrti - 退货子表记录rowid
/// Return
///     退货明细记录信息
ClassMethod SelRetItmInfo(ingrti)
{
 q:ingrti="" ""
 n (ingrti)
 s retamt=0,invono="",invodate=""
 s DHCINGRT=$p(ingrti,"||",1)
 s DHCChild=$p(ingrti,"||",2)
 s RETNO=$p(^INGRT(DHCINGRT),"^",1)
 s retdate=$p(^INGRT(DHCINGRT),"^",9)   ; return date
 s:retdate'="" retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate,"ST")
 s ven=$p(^INGRT(DHCINGRT),"^",2)
 s:ven'="" ven=$p($g(^APC("APCVM",ven)),"^",3)
 s retqty=-1*$P(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",2)  ; returned qty
 s retuom=$P(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",3)
 s retuomdesc=""
 i retuom'="" s retuomdesc=$p($g(^CT("UOM",retuom)),"^",2) ;ret ctuom desc
 s invono=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",12)
 s invAmt=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",13)
 s invodate=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",14)
 s:invodate'="" invodate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invodate,"ST")
 s rp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",7)
 s retamt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",4)
 s pp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",10)
 s retppamt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",11)
 s sp=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",8)
 s spamt=-$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",9)
 s inclb=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",6)  //该字段(INGRTI_MEDRTITM_DR)现在存放库存批次
 s DHCGRI=$p(^INGRT(DHCINGRT,"DHCGRR",DHCChild),"^",1)
 s batno="",ExpDate=""
 i inclb'=""  &sql(select inclb_incib_dr->incib_no,inclb_incib_dr->INCIB_ExpDate into :batno,:ExpDate from inc_itmlcbt where %ID=:inclb)
 s DHCINGR=$p(DHCGRI,"||",1)
 s DHCINGRCH=$p(DHCGRI,"||",2)
 s manf=+$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",29)
 i manf>0 s manf=$p($g(^PHMNF(manf)),"^",2)
 e  s manf=""
 s discpdiff=pp-rp
 s discamt=retppamt-retamt
 s psdiffamt=spamt-retamt
 s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 s insxno=$P($G(^INGRT(DHCINGRT,"DHCGRR",DHCChild)),"^",18)   //退货发票
 s ret1=$g(batno)_"^"_$g(manf)_"^"_$g(retuomdesc)_"^"_$g(retqty)_"^"_$g(pp)
 s ret2=$g(rp)_"^"_$g(sp)_"^"_$g(retppamt)_"^"_$g(retamt)_"^"_$g(spamt)
 s ret3=$g(discpdiff)_"^"_$g(discamt)_"^"_$g(psdiffamt)_"^"_invono_"^"_invodate
 s ret4=RETNO_"^"_insxno_"^"_inclb_"^"_ExpDate_"^"_$g(invAmt)
 s ret=ret1_"^"_ret2_"^"_ret3_"^"_ret4
 q ret
}

/// Descript:   保存/更新付款明细信息
/// Creater:    gwj
/// CreateDate: 2012-10-8
/// Table:DHC_PayItm
/// Input:主表id,
/// 明细id^库存项^入库/退货RowId^库存项RowId^入库金额^付款金额^已付款金额^折扣率^结清标志^类型,
/// 明细id^库存项^入库/退货RowId^库存项RowId^入库金额^付款金额^已付款金额^折扣率^结清标志^类型,
/// Output:     
/// Return：0：成功，
///  -5:主表id或明细不能为空
///  -6:所有明细保存均失败
///  -7其它：部分明细保存不成功，提示不成功的药品
ClassMethod Save(PayId As %String, ListData As %String) As %Library.String
{
    n (PayId,ListData)
    q:PayId="" -5
    q:ListData="" -5
    s err=0
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)  //记录数
    s Count=0
    f i=1:1:Len q:err'=0  d
    .s data=$p(ListData,rowDelim,i)
    .
    .s payi=$p(data,"^",1)
    .s data=$p(data,"^",2,$l(data,"^"))
    .
    .s Ret=..Update(payi,PayId,data)
    .
    .i Ret="" d
    ..s err=-7
    .e  d
    ..s Count=Count+1
    q:err'=0 err
    q:Count=0 -6
    q 0
}

/// 计算已经付款的金额
/// Author:zhwh
/// Date:2012-12-12
/// Argu:
///  pointer
///  type
/// Return:
///      已付款金额
ClassMethod GetPayedAmt(pointer As %String, type As %String) As %String
{
 n (pointer,type)
 s payedAmt=0
 s pay=$o(^DHCPAY(0,"TYPEGR",type,pointer,""),-1)  q:pay="" payedAmt
 s ch=$o(^DHCPAY(0,"TYPEGR",type,pointer,pay,""),-1) q:ch="" payedAmt 
 s payedAmt=$P($G(^DHCPAY(pay,"I",ch)),"^",4)
 q payedAmt
}

/// creator:    yunhaibao
/// createdate: 2017-11-01
/// description:付款制单,选择入库\退货单明细的保存
ClassMethod UpdatePay(pay, dataStr As %Text)
{
  n (pay,dataStr)
  q:pay="" "-1^"_..Trans("付款单主表Id为空")
  q:dataStr="" "-1^"_..Trans("明细数据为空")
  s dataLen=$l(dataStr,"!!")
  s failCnt=0
  s dataI=1
  f dataI=1:1:dataLen d
  .s iData=$p(dataStr,"!!",dataI)
  .q:iData=""
  .s iRet=..Update("",pay,iData)
  .i +iRet'>0 s failCnt=failCnt+1
  q:failCnt=0 0
  s delPay=##class(web.DHCST.DHCPay).Delete(pay)
  q "-1^"_failCnt_..Trans("条明细数据保存失败")
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.pay.csp",Text)
}

}
