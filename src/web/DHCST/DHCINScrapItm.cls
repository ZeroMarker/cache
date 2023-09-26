Import sqluser

Class web.DHCST.DHCINScrapItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新报损明细信息
/// Creater:    gwj
/// CreateDate: 2012-08-30
/// Table:DHC_INSpItm
/// Input:主表id,
/// 明细id^批次ID^单位RowId^报损数量^进价^进价金额^批价^批价金额^售价^售价金额
/// 明细id^批次ID^单位RowId^报损数量^进价^进价金额^批价^批价金额^售价^售价金额
/// Output:     
/// Return：0：成功，
/// -5:主表id或明细不能为空
/// -6:所有明细保存均失败
/// -7其它：部分明细保存不成功，提示不成功的药品
ClassMethod Save(InscpId As %String, ListData As %String) As %Library.String
{
    n (InscpId,ListData)
    q:InscpId="" -5
    q:ListData="" 0 //没有明细内容
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    i ListData="" s Len=0
    e   s Len=$l(ListData,rowDelim)   // rowDelim:记录数据串分隔字符
    s Count=0
    s Err=""
    f i=1:1:Len  d
    .s Data=$p(ListData,rowDelim,i)
    .s Rowid=$p(Data,"^",1)
    .s Inclb=$p(Data,"^",2)
    .q:Inclb=""
    .s IncDesc=$p(^INCI(+Inclb,1),"^",2)
    .s Detail=$p(Data,"^",2,$l(Data,"^"))
    .;b ;11
    .s Ret=..Update(Rowid,InscpId,Detail)
    .i Ret<0  d
    ..s Err=Err_","_IncDesc
    .e  d
    ..s Count=Count+1
    
    q:Count=0 -6  ;所有明细保存均失败
    q:Err'="" -7_"^"_Err  ;保存失败的药品
    q 0
}

/// 插入或更新报损单明细记录数据
/// Author:zhwh
/// Date: 2012-07-20
/// Argu:
///  inscrapItm - 子表rowid
///  Inscrap  - 父表rowid
///  Data - 子表记录数据串
/// Return:
///  <0 - failure
///  >0
ClassMethod Update(inscrapItm As %String, Inscrap As %String, Data As %String) As %String
{
 i Inscrap="" q -1
 s appName=##class(web.DHCST.DHCINScrap).%GetParameter("AppName")
 s ScrapLoc=$p(^DHCINSP(Inscrap),"^",5)
 s HospID=""
 i ScrapLoc'="" s HospID=$p($g(^CTLOC(ScrapLoc)),"^",22)
 //i ##class(web.DHCST.Common.AppCommon).Lock(appName_Inscrap)<0 q -99
 s inclb=$p(Data,"^",1)  //批次rowid
 s uom=$p(Data,"^",2)   //单位rowid
 s qty=$p(Data,"^",3)  //报损数量
 s rp=$p(Data,"^",4)  //进价
 s rpAmt=$p(Data,"^",5) // 进价金额
 s pp=$p(Data,"^",6) // 批价
 s ppAmt= $p(Data,"^",7) //批价金额
 s sp=$p(Data,"^",8) //售价
 s spAmt=$p(Data,"^",9) // 售价金额
 //yunhaibao,20160107,重新计算金额
 s buomid=$p(^INCI(+inclb,1),"^",10)
 s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uom,HospID,..sssCode(),"")
 s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uom,HospID,..sssCode(),+$h,"")
 s pp=rp
 s spAmt=sp*qty
 s rpAmt=rp*qty
 s spAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spAmt,HospID)
 s rpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpAmt,HospID)
 s ppAmt=rpAmt
 i inscrapItm="" d
 .s obj=##class(User.DHCINSpItm).%New()
 .s obj.INSPIParref=##class(User.DHCINScrap).%OpenId(Inscrap,0)
 .s obj.INSPIChildsub=1+$o(^DHCINSP(Inscrap,"I",""),-1)
 .
 e  d
 .s obj=##class(User.DHCINSpItm).%OpenId(inscrapItm)
 .d obj.%Reload()

 s obj.INSPICTUOMDR=##class(User.CTUOM).%OpenId(uom,0)   //单位 rowid
 s obj.INSPIINCLBDR=##class(User.INCItmLcBt).%OpenId(inclb,0)
 s obj.INSPIQty=+qty
 s obj.INSPIRp=+rp
 s obj.INSPIRpAmt=+rpAmt
 s obj.INSPIPp=+pp
 s obj.INSPIPpAmt=+ppAmt
 s obj.INSPISp=+sp
 s obj.INSPISpAmt=+spAmt
 s bUom=$p(^INCI(+inclb,1),"^",10)
 s puruom=$p(^INCI(+inclb,3),"^",6)  //入库单位 wyx add 2014-04-28
 s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,bUom)
 i uom=bUom s obj.INSPIQtyBUom=+qty
 else  s obj.INSPIQtyBUom=+qty*Fac2
 
 s sc=obj.%Save()
 i $$$ISERR(sc) q -2
 q obj.%Id()
}

/// 检索一条报损子表记录数据串
/// Author:zhwh
/// Date: 2012-07-23
/// Argu:
///  inscrapItm - 子表rowid
/// Return:
///   子表记录数据串
///  
ClassMethod Select(inscrpItm As %String) As %String
{
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_INSpItm where %ID=:inscrpItm)
 q:SQLCODE result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 是否允许删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrpItm - 报损单子表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod Delete(inscrpItm As %String) As %String
{
  s inscrap=+inscrpItm
  s allowdel=..AllowDel(inscrap)
  q:allowdel<0 allowdel
  s appName=##class(web.DHCST.DHCINScrap).%GetParameter("AppName")
  q:##class(web.DHCST.Common.AppCommon).Lock(appName_inscrap)<0 -1
  ts
  &sql(delete from DHC_INSpItm where %ID=:inscrpItm)
  d ##class(web.DHCST.Common.AppCommon).UnLock(appName_inscrap)
  i SQLCODE'=0  tro  q -4
  tc
  q 0
}

/// 是否允许删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrpItm - 报损单子表rowid
/// Return:
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(inscrpItm As %String) As %String
{
 n (inscrpItm)
 s inscrap=+inscrpItm
 s obj=##class(User.DHCINScrap).%OpenId(inscrap,0)
 d obj.%Reload()    
 s comp=obj.INSCPCompleted
 q:comp="Y" -1
 s chkFlag=obj.INSCPChkFlag
 q:chkFlag="Y" -2
 q 0
}

/// w ##class(web.DHCST.DHCINScrapItm).jsDHCINSpD(1,11,16)
ClassMethod jsDHCINSpD(Start As %String, Limit As %String, inscrap As %String) As %String
{
	s pid=##class(web.DHCSTKUTIL).NewPid("web.DHCST.DHCINScrapItm","ST")
	s $zt="ErrorjsDHCINSpD"
	q:inscrap="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINScrapItm:DHCINSpD")  
	s sc=result.Execute(inscrap)
	i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
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
		s countrecords=countrecords+1
		s ^TMP("DHCST",$this,"jsDHCINSpD",pid,countrecords)=ret
	}
	i countrecords=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:countrecords=0 ""
	i end>countrecords s end=countrecords
	s outputi=""
	f  s outputi=$o(^TMP("DHCST",$this,"jsDHCINSpD",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST",$this,"jsDHCINSpD",pid,outputi)
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
	k ^TMP("DHCST",$this,"jsDHCINSpD",pid)
	q ""
ErrorjsDHCINSpD
	k ^TMP("DHCST",$this,"jsDHCINSpD",pid)
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// D ##class(%ResultSet).RunQuery("web.DHCST.DHCINScrapItm","DHCINSpD",7)
Query DHCINSpD(inscrap As %String) As %Query(ROWSPEC = "inspi:%String,inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,uom:%String,uomDesc:%String,qty:%Float,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,pp:%Float,ppAmt:%Float,batNo:%String,expDate:%String,inclbQty:%Float,avalbQty:%Float,confac:%Float,buom:%String,locDescIO,scgDescIO,userNameIO,chkUserNameIO,reasonIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod DHCINSpDExecute(ByRef qHandle As %Binary, inscrap As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:inscrap="" $$$OK
 
 s (locid,locDescIO,scgDescIO,userNameIO,chkUserNameIO,reasonIO)=""
 &SQL(select inscp_ctloc_dr,inscp_ctloc_dr->ctloc_desc,inscp_scg_dr->scg_desc ,inscp_ssusr_dr->ssusr_name ,inscp_chkusr_dr->ssusr_name ,
 inscp_reason->REASON_ScrapDesc into :locid,:locDescIO,:scgDescIO,:userNameIO,:chkUserNameIO,:reasonIO from dhc_inscrap where INSCP_RowID=:inscrap )
 s hospid=$P(^CTLOC(locid),"^",22)
 s HospDescIO=$P(^CT("HOSP",hospid),"^",2)
 
 s sql="select %ID inspi,"
 s sql=sql_"inspi_inclb_dr inclb,"
 s sql=sql_"inspi_ctuom_dr uom,"    
 s sql=sql_"inspi_ctuom_dr->ctuom_desc uomDesc,"    
 s sql=sql_"inspi_qty qty," 
 s sql=sql_"inspi_rp rp,"   
 s sql=sql_"inspi_rpamt rpAmt," 
 s sql=sql_"inspi_sp sp,"   
 s sql=sql_" inspi_spamt spAmt,"    
 s sql=sql_"inspi_pp pp,"   
 s sql=sql_"inspi_ppamt ppAmt " 
 s sql=sql_" from dhc_inspitm"
 s sql=sql_" where inspi_parref="_inscrap
 s xrs=##class(%Library.ResultSet).%New()
 //w sql,!
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 while (xrs.Next())
 {
  s inspi=xrs.Data("inspi")
  s inclb=xrs.Data("inclb")
  s uom=xrs.Data("uom")
  s uomDesc=xrs.Data("uomDesc")
  s qty=xrs.Data("qty")
  s rp=xrs.Data("rp")
  s rpAmt=xrs.Data("rpAmt")
  s sp=xrs.Data("sp")
  s spAmt=xrs.Data("spAmt")
  s pp=xrs.Data("pp")
  s ppAmt=xrs.Data("ppAmt")
  
  s inci=+inclb
  s code=$p(^INCI(+inclb,1),"^",1)
  s desc=$p(^INCI(+inclb,1),"^",2)
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",+inclb)
  s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
 
  s xObj=##class(User.INCItmLcBt).%OpenId(inclb,0)
  d xObj.%Reload()
  s batNo=xObj.INCLBINCIBDR.INCIBNo
  s expDate=xObj.INCLBINCIBDR.INCIBExpDate
  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
  s batNo=batNo_"~"_expDate  //zhwh 2013-01-16
  s avalbQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQtyUom(inclb,uomDesc) //可用数量
  s inclbQty = ##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLBURid(inclb,uom)
  s buom=$p(^INCI(+inclb,1),"^",10)
  s puom=$p(^INCI(+inclb,3),"^",6)
  s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
  d OutPutRow
 }
 
 Quit $$$OK
OutPutRow
 s Data=$lb(inspi,inclb,inci,code,desc,spec,manf,uom,uomDesc,qty,rp,rpAmt,sp,spAmt,pp,ppAmt,batNo,expDate,inclbQty,avalbQty,confac,buom,locDescIO,scgDescIO,userNameIO,chkUserNameIO,reasonIO,HospDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINSpDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINSpDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINSpDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINSpDExecute ]
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

}
