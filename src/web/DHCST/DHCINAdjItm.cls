Import sqluser

Class web.DHCST.DHCINAdjItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或者更新库存调整单明细
/// Author:zhwh
/// Date:
/// ARgu:
///  adjitm - 
///  adj -
///  data -(批次dr^调整数量^调整单位^进价^售价^进价金额^售价金额^盘点dr)
/// Return:
///   0 -success
///   <0 -failure  
ClassMethod Update(adjitm As %String, adj As %String, data As %String) As %String
{
 n (adjitm,adj,data)
 //s adjitm="349||1",adj=349,data="30||1||2^-8^16^6.2^8^-49.6^-64^"
 i adjitm="" d
 .s objitm=##class(User.DHCINAdjItm).%New()
 .s objitm.INADIINADParRef=##class(User.DHCINAdj).%OpenId(adj,0)
 .s ch=$o(^DHCINAD(adj,"ADI",""),-1)+1
 .s objitm.INADIChildSub=ch
 e   d
 .s objitm=##class(User.DHCINAdjItm).%OpenId(adjitm)
 .d objitm.%Reload()
 s adjreason=$p(^DHCINAD(adj),"^",6)
 s inclb=$p(data,"^",1)   //批次rowid
 s qty=$p(data,"^",2) //调整数量
 s uom=$p(data,"^",3)  //调整单位
 s rp=$p(data,"^",4)   //进价
 s sp=$p(data,"^",5)  //售价
 s rpAmt=$p(data,"^",6)  //进价金额
 s spAmt=$p(data,"^",7)  //售价金额
 s insti=$p(data,"^",8)  //盘点明细表rowid(DHC_INStktkItm)
 s loc=$p($G(^INCI(+inclb,"IL",$p(inclb,"||",2))),"^",1)
 s HospID=$p($g(^CTLOC(loc)),"^",22)
 //yunhaibao20160107,重新计算金额,盘点数据不做处理
 i adjreason'="" d
 .s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,..sssCode(),"")
 .s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,..sssCode(),+$h,"")
 .s spAmt=sp*qty
 .s rpAmt=rp*qty
 .s spAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,HospID)
 .s rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospID)
 s buom=$P(^INCI(+inclb,1),"^",10)
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 s qtybuom=qty*fac 
 s objitm.INADIINCLBDR=##class(User.INCItmLcBt).%OpenId(inclb,0)
 s objitm.INADIQty=+qty
 s objitm.INADICTUOMDR=##class(User.CTUOM).%OpenId(uom,0)
 s objitm.INADICTLOCDR=##class(User.CTLoc).%OpenId(loc,0)
 s objitm.INADIQtyBUom=+qtybuom
 s objitm.INADIRP=+rp
 s objitm.INADIRPAmt=+rpAmt
 s objitm.INADIUCost=+sp
 s objitm.INADISPAmt=+spAmt
 s objitm.INADIINSTIDR=##class(User.DHCInStkTkItm).%OpenId(insti,0)
 
 s sc=objitm.%Save()
 ;b ;sc
 //d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINAdj).%GetParameter("AppName")_adj)
 i $$$ISERR(sc) q -1
 q objitm.%Id()
}

/// 取出库存调整明细记录
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adjitm - 库存调整明细表rowid
/// Return:
///  库存调整明细数据串
///  
ClassMethod Select(adjitm As %String) As %String
{
 n (adjitm)
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_INAdjItm where %ID=:adjitm)
 q:SQLCODE'=0 result 
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=	$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 删除一条库存调整单明细记录
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
/// 	adjitm -  库存调整单明细rowid
/// Return:
///    0 - success
///    <0 - failure
/// 
ClassMethod Delete(adjitm As %String) As %String
{
  n (adjitm)  
  i adjitm="" q -1
  s allowdel=##class(web.DHCST.DHCINAdj).AllowDel(+adjitm)
  q:allowdel<0 allowdel
  q:$d(^DHCINTR(0,"TypePointer","A",adjitm)) -5
  i ##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINAdj).%GetParameter("AppName")_+adjitm)<0  q -99
  &sql(delete from DHC_INAdjItm where %ID=:adjitm)	
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINAdj).%GetParameter("AppName")_+adjitm)
  i SQLCODE'=0 q -4
  q 0
}

/// 取库存调整单明细数据串(json)
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj - 库存调整单主表rowid
/// Return:
///   json数据串
/// w ##class(web.DHCST.DHCINAdjItm).jsDHCINAdjD(0,11,Adj)
ClassMethod jsDHCINAdjD(Start As %String, Limit As %String, adj As %String) As %String
{
	n (Start,Limit,adj)
	s pid=##class(web.DHCSTKUTIL).NewPid("web.DHCST.DHCINAdjItm","ST")
	s $zt="ErrorjsDHCINAdjD"
	q:adj="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINAdjItm:DHCINAdjD")	
	s sc=result.Execute(adj)
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	s count = 0
	s end = Start+Limit
	s Start=Start+1
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST",$this,"jsDHCINAdjD",pid,countrecords)=ret
	}
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	i end>countrecords s end=countrecords
	s outputi=""
	f  s outputi=$o(^TMP("DHCST",$this,"jsDHCINAdjD",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST",$this,"jsDHCINAdjD",pid,outputi)
	.s count = count+1
	.q:count<Start
	.q:count>end
	.i count=Start d
	..w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	..w retstring
	.e  d
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
	..w ","_retstring
	q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	w "]}"
	k ^TMP("DHCST",$this,"jsDHCINAdjD",pid)
	q ""
ErrorjsDHCINAdjD
	k ^TMP("DHCST",$this,"jsDHCINAdjD",pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 检索库存调整单明细的Query
/// Author:zhwh
/// Date:2012-07-10
/// Argu
///  adj - 库存调整单主表rowid
/// Return:
///  adjitm- 库存调整明细记录rowid
///  inclb -批次rowid
///  inci - 库存项rowid
///  code - 代码
///  desc - 描述
///  spec - 规格
///  manf - 厂家
///  batNo   - 批号
///  expDate - 效期
///   qty - 调整数量
///  uom -  调整单位
///  qtyBUOM -  调整数量(基本单位)
///  rp - 进价
///  rpAmt- 进价金额
///   sp-  售价
///   spAmt - 售价金额
///  insti - 盘点调整明细dr
///  D ##class(%ResultSet).RunQuery("web.DHCST.DHCINAdjItm","DHCINAdjD","19",11189,257,2) //45
Query DHCINAdjD(adj As %String, InadjUserIO As %String = "", InadjLocIO As %String = "", HospDescIO As %String = "") As %Query(ROWSPEC = "adjitm:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,batNo:%String,expDate:%String,qty:%String,uom:%String,uomDesc:%String,qtyBUOM:%String,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,insti:%String,Inclbqty:%String,confac:%String,buom:%String,InclbAvaQty,InadjUserIO,InadjLocIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod DHCINAdjDExecute(ByRef qHandle As %Binary, adj As %String, InadjUserIO As %String = "", InadjLocIO As %String = "", HospDescIO As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
	
 i adj="" q $$$OK	
 s ^YSJTMP("DHCINAdjD")=$LB(adj,InadjUserIO,InadjLocIO,HospDescIO)
 // InadjUserIO,InadjLocIO,HospDescIO
 s:InadjLocIO'="" InadjLocIO=$p(^CTLOC(InadjLocIO),"^",2)
 s:InadjUserIO'="" InadjUserIO=$p(^SSU("SSUSR",InadjUserIO),"^",2)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
 
 s sql="select %ID adjitm,"
 s sql=sql_"inadi_inclb_dr inclb,"
 s sql=sql_"inadi_inclb_dr->inclb_incib_dr->incib_no batNo,"
 s sql=sql_"inadi_inclb_dr->inclb_incib_dr->incib_expdate expDate,"  
 s sql=sql_"inadi_qty qty,"
 s sql=sql_"inadi_ctuom_dr uom ,"
 s sql=sql_"inadi_ucost sp ,"
 s sql=sql_"inadi_rp rp,"
 s sql=sql_"inadi_rpamt rpAmt,"
 s sql=sql_"inadi_spamt spAmt,"
 s sql=sql_"inadi_qtybuom qtyBUOM,"
 s sql=sql_"inadi_insti_dr insti"
 s sql=sql_" from dhc_inadjitm where inadi_inad_parref="_adj
 ;w sql,!
 s xRS=##class(%Library.ResultSet).%New()
 d xRS.Prepare(sql)
 s sc=xRS.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xRS.Next())
 {
    s adjitm=xRS.Data("adjitm")
    s inclb=xRS.Data("inclb")
    s qty=xRS.Data("qty")
    s uom=xRS.Data("uom")
    s uomDesc=$p($G(^CT("UOM",uom)),"^",2)
    s rp=xRS.Data("rp")
    s sp=xRS.Data("sp")
    s rpAmt=xRS.Data("rpAmt")
    s spAmt=xRS.Data("spAmt")
    s qtyBUOM=xRS.Data("qtyBUOM")
	s insti= xRS.Data("insti")
	s batNo= xRS.Data("batNo")
	s expDate= xRS.Data("expDate")
	i expDate'="" d
	.i (expDate["-")||(expDate["/") d
	..s expDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(expDate)
	.s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	s Inclbqty = ##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLBURid(inclb,uom)
	s InclbAvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,uom)
	s batNo=batNo_"~"_expDate
	s inci=+inclb
	s code=$p($G(^INCI(+inclb,1)),"^",1)
	s desc=$p($G(^INCI(+inclb,1)),"^",2)
	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",+inclb)
	s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
	s puom=$p(^INCI(+inclb,3),"^",6)
	s buom=$p(^INCI(+inclb,1),"^",10)
	s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	d OutPutRow
 }
 Quit $$$OK
OutPutRow
 s Data=$lb(adjitm,inclb,inci,code,desc,spec,manf,batNo,expDate,qty,uom,uomDesc,qtyBUOM,rp,rpAmt,sp,spAmt,insti,Inclbqty,confac,buom,InclbAvaQty,InadjUserIO,InadjLocIO,HospDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINAdjDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINAdjDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINAdjDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINAdjDExecute ]
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

/// 保存库存调整单明细数据
/// Author:zhwh
/// Date:2012-07-12
/// Argu:
/// 	  adj-库存调整单主表rowid
/// 	  rows - 明细记录数据串
/// Return:
///    0 - success
///    <0 - failure
ClassMethod Save(adj As %String, rows As %String) As %String
{
  q:adj="" -1
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINAdj).%GetParameter("AppName")_adj)<0 -99
  s err=0
  s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()  //数据行的分隔符
  i rows="" s rowcnt=0
  e   s rowcnt=$l(rows,rowDelim)    
  ts
  f i=1:1:rowcnt  q:err<0  d
  .s row=$P(rows,rowDelim,i)
  .s adjItm=$P(row,"^",1)  //明细rowid
  .s data=$P(row,"^",2,$L(row,"^"))
  .s err=+..Update(adjItm,adj,data)
  .i err<0 tro
  .q:err<0
  i err>=0  tc
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINAdj).%GetParameter("AppName")_adj)
  q err
}

}
