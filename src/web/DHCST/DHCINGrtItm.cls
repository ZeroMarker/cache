Import sqluser

Class web.DHCST.DHCINGrtItm Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新一条退货单明细记录(DHC_INGRTITM)
/// Author:zhwh
/// Date :2012-07-05
/// Argu:
///   reti - 退货单明细记录rowid
///   ret - 退货单主表rowid
///   dataInfo - 退货明细数据串(以"^"分割)
/// Return:
///  >0 - 更新或插入成功
///  <0 - 失败
///  
ClassMethod Update(reti As %String, ret As %String, dataInfo As %String) As %String
{
 n (reti,ret,dataInfo)
 //s reti="14||12"
 //s ret=14
 //s dataInfo="182||4^168^85^176.16^29594.8989^202.58^34033.44^176.16^29594.88^202.58^34033.44^3551^61248^^^^"
 
 if +reti=0  d
 .s obj=##class(User.DHCINGRTITM).%New()
 .s obj.INGRTIINGRTParref=##class(User.DHCINGDRET).%OpenId(ret,0)
 .s ch=$o(^INGRT(ret,"DHCGRR",""),-1)+1
 .s obj.INGRTIChildSub=ch
 .
 e  d
 .s obj=##class(User.DHCINGRTITM).%OpenId(reti)
 .d obj.%Reload()
 s ingri=$p(dataInfo,"^",1)    //INGRI DR - DHC_INGdRecItm
 s Qty=$p(dataInfo,"^",2)   //数量
 s Uom=$p(dataInfo,"^",3)   //单位
 s rp=$p(dataInfo,"^",4)    //进价
 s rpAmt=$p(dataInfo,"^",5)  //进价金额
 s sp=$p(dataInfo,"^",6)     //售价
 s spAmt=$p(dataInfo,"^",7)   //售价金额
 s pp=$p(dataInfo,"^",8)   //批价 
 s ppAmt=$p(dataInfo,"^",9)   //批价金额
 s oldSp=$p(dataInfo,"^",10)    //批次售价
 s oldSpAmt=$p(dataInfo,"^",11)   //批次售价金额
 s invNo=$p(dataInfo,"^",12)     //发票号
 s invDate=$p(dataInfo,"^",13)   //发票日期
 s invAmt=$p(dataInfo,"^",14)    //发票金额
 s sxNo=$p(dataInfo,"^",15)   //随行单
 s reason=$p(dataInfo,"^",16)   //退货原因
 s aspa=$p(dataInfo,"^",17)   //退货调价金额
 
 s obj.INGRTIAspAmt=+aspa
 s obj.INGRTIInvAmt=+invAmt
 i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(invDate)
 s obj.INGRTIInvDate=invDate
 s obj.INGRTIInvNo=invNo
 s obj.INGRTIOldSp=+oldSp
 s obj.INGRTIOldSpAmt=+oldSpAmt
 s obj.INGRTIRealPrice=+rp
 s obj.INGRTIRetAmount=+rpAmt
 s obj.INGRTIPpAmt=+ppAmt
 s obj.INGRTIRetQty=+Qty
 s obj.INGRTIRetUomDR=##class(User.CTUOM).%OpenId(Uom,0)
 s obj.INGRTISalePrice=+sp
 s obj.INGRTISpAmt=+spAmt
 s obj.INGRTIPurPrice=+pp
 s obj.INGRTIPpAmt=+ppAmt
 s obj.INGRTISxno=sxNo
 s ingriObj=##class(User.DHCINGdRecItm).%OpenId(ingri,0)
 s obj.INGRTIINGRIDR=ingriObj
 s obj.INGRTIRetReasDR=##class(User.INCReasonForReturn).%OpenId(reason,0)
 s obj.INGRTIMEDRTITMDR=ingriObj.INGRIINCLBDR    //.%Id()
 s status=obj.%Save()
 ;b ;s
 i $$$ISERR(status)	  q -1
 q obj.%Id()
 ;q 0
}

/// 取一条退货明细记录的数据
/// Author ：zhwh
/// Date:2012-0-7-05
/// Argu:
///   reti  -退货单明细rowid
/// Return:
///   退货明细记录串
///    w ##class(web.DHCST.DHCINGrtItm).Select("171||1")
ClassMethod Select(reti As %String) As %String
{
 n (reti)	
 q:reti="" ""
 k PLIST
 s result=""
 &sql(select * into :PLIST() from DHC_INGRTITM where %ID=:reti)
 q:SQLCODE ""
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$G(PLIST(i))
 .e  s result=result_"^"_$G(PLIST(i))
 q result
}

/// 删除一条退货明细记录
/// Author ：zhwh
/// Date:2012-0-7-05
/// Argu:
///   reti  -退货单明细rowid
/// Return:
///  0 - success
///  <0 - failure
///     
ClassMethod Delete(reti As %String) As %String
{
  n (reti)
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_reti)<0 -99
  q:##class(web.DHCST.DHCINGdRet).AllowDel(+reti)<0 -100
  &sql(Delete From DHC_INGrtItm Where INGRTI_RowId=:reti)
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINGdRet).%GetParameter("AppName")_reti)
  q:SQLCODE'=0 -1
  q 0
}

/// 退货单明细数据记录（json）
/// Author:zhwh
/// Date:2012-07-10
/// 
/// Argu:
///  INGRT - 退货主表Rowid
/// Return:
///  JSON格式的数据串 
///  
ClassMethod jsDHCINGdRetItm(Start As %String, Limit As %String, Sort As %String, Dir As %String, INGRT As %String) As %String
{
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINGrtItm:DHCINGdRetItm")
 s loc = $P(^INGRT(INGRT), "^", 7)
 s hospId = $P(^CTLOC(loc), "^", 22)
 s jsSort=Sort	
 s qPar=Sort_"^"_Dir
 s sc=result.Execute(qPar,INGRT)
 s countrecords = 0
 s pid=..NewPid()
 k ^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid)
 s $zt="ErrorjsDHCINGdRetItm"
 While(result.Next())
 { 
	s ingrti=result.Data("ingrti")   //退货子表rowid(DHC_INGRtItm)
	s ingri=result.Data("ingri")    //入库子表rowid(DHC_INGdRecItm)
	s manf=result.Data("manf")   //厂家 
	s inclb=result.Data("inclb")   //批次DR(INC_ItmLcBt)
	s inci = +inclb
	s uom=result.Data("uom")    //单位名称
	s qty=result.Data("qty")      //数量
	s rp=result.Data("rp")    //进阶
	s rpAmt=result.Data("rpAmt")   //进阶金额
	s sp=result.Data("sp")   //售价
	s spAmt=result.Data("spAmt")   //售价金额
	s invNo=result.Data("invNo")    //发票号
	s invDate=result.Data("invDate")  //发票日期
	s invAmt=result.Data("invAmt")    //发票金额
	s sxNo=result.Data("sxNo")    //随行单号
	s oldSp=result.Data("oldSp")   //批次售价
	s oldSpAmt=result.Data("oldSpAmt")   //批次售价金额
	s aspAmt=result.Data("aspAmt")     //退货调价
	s code=result.Data("code")     //代码 
	s desc=result.Data("desc")   //描述
	s spec =result.Data("spec")   //规格
	s batNo=result.Data("batNo")   //批号
	s expDate=result.Data("expDate")   //效期
	s retReason=result.Data("retReason")   //退货原因
	s reasonId=result.Data("retReasonId")
	s stkqty=result.Data("stkQty")
	s:uom'="" uomDesc=$p(^CT("UOM",uom),"^",2)
	s buom=$p(^INCI(+inclb,1),"^",10)
	s purUom=$p(^INCI(+inclb,3),"^",6)
	s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(purUom,buom)
	s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inci, hospId)
	s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inci, hospId)
	s tmp=ingrti_"^"_ingri_"^"_inclb_"^"_code_"^"_desc_"^"_spec_"^"_batNo_"^"_expDate_"^"_manf_"^"_qty_"^"_uom_"^"_rp_"^"_rpAmt_"^"_sp_"^"_spAmt_"^"_oldSp_"^"_oldSpAmt_"^"_invNo_"^"_invDate_"^"_invAmt_"^"_sxNo_"^"_retReason_"^"_reasonId_"^"_stkqty_"^"_$g(uomDesc)_"^"_buom_"^"_confac_"^"_InsuCode_"^"_InsuDesc
	s countrecords = countrecords+1	
	/*i jsSort="code" s index=code
	e  i jsSort="desc" s index=desc
	e  i jsSort="batNo" s index=batNo
	e  i jsSort="expDate" s index=expDate
	e  i jsSort="rpAmt" s index=rpAmt
	e  i jsSort="spAmt" s index=spAmt*/
	s index=1  //预留节点
	s ^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid,index,countrecords)=tmp	
 }
 q:countrecords=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s End = Start+Limit
 s Start=Start+1
 s count=0
 s Title="ingrti^ingri^inclb^code^desc^spec^batNo^expDate^manf^qty^uom^rp^rpAmt^sp^spAmt^oldSp^oldSpAmt^invNo^invDate^invAmt^sxNo^retReason^reasonId^stkqty^uomDesc^buom^confac^InsuCode^InsuDesc"
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i Dir="DESC" s orderflag="-1"
 e  s orderflag="1"
 s outputi=""
 f  s outputi=$o(^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid,outputi),orderflag) q:outputi=""  d
 .s outputj=""
 .f  s outputj=$o(^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid,outputi,outputj),orderflag) q:outputj=""  d
 ..s count = count+1
 ..q:count<Start
 ..q:count>End
 ..s outputdata=^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid,outputi,outputj)
 ..i count=Start d
 ...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(countrecords)
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
 ...w retstring
 ..e  d
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
 ...w ","_retstring
 w "]}"
 k ^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid)
 Q ""
ErrorjsDHCINGdRetItm
 k ^TMP("DHCST","DHCINGrtItm","jsDHCINGdRetItm",pid)
 q $ze
}

/// 退货单明细
/// Author:zhwh
/// Date:2012-07-04
/// Argu:
///   qPar - 查询结果排序串(排序字段^排序方向)
///   INGRT - 退货单主表RowId
/// Columns:
/// 子表RowId，
/// 入库明细RowId，
/// 退货药品批次RowId，
/// 药品代码
/// 名称，
/// 规格
/// 批号
/// 效期
/// 厂商，
/// 退货数，
/// 退货单位，
/// 进价，
/// 进价金额
/// 售价，
/// 售价金额，
/// 发票号，
/// 发票日期，
/// 发票金额，
/// 随行单号
/// 
Query DHCINGdRetItm(qPar As %String, INGRT As %String, vendorIO As %String = "", ingrtLocIO As %String = "", ingrtUserIO As %String = "", HospDescIO As %String = "") As %Query(ROWSPEC = "ingrti:%String,ingri:%String,inclb:%String,code:%String,desc:%String,spec:%String,batNo:%String,expDate:%String,manf:%String,qty:%Float,uom:%String,uomDesc:%String,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,oldSp:%Float,oldSpAmt:%Float,invNo:%String,invDate:%String,invAmt:%Float,sxNo:%String,retReason:%String,retReasonId:%String,aspAmt:%Float,stkQty:%Float,vendorIO,ingrtLocIO,ingrtUserIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod DHCINGdRetItmExecute(ByRef qHandle As %Binary, qPar As %String, INGRT As %String, vendorIO As %String = "", ingrtLocIO As %String = "", ingrtUserIO As %String = "", HospDescIO As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:INGRT="" $$$OK
 
 //vendorIO,ingrtLocIO,ingrtUserIO,HospDescIO
 s:vendorIO'="" vendorIO=$p(^APC("APCVM",vendorIO),"^",3)
 s:ingrtLocIO'="" ingrtLocIO=$p(^CTLOC(ingrtLocIO),"^",2)
 s:ingrtUserIO'="" ingrtUserIO=$p(^SSU("SSUSR",ingrtUserIO),"^",2)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 //排序字段
 s orderFieldName=""
 s:Sort="ingrti" orderFieldName="ingrti"
 s:Sort="InvNo" orderFieldName="ingrti_invNo"
 s:Sort="sxNo" orderFieldName="ingrti_sxno"
 s:Sort="manf" orderFieldName="manf"
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s sql="select %ID ingrti,"
 s sql=sql_"ingrti_ingri_dr ingri,"
 s sql=sql_"ingrti_ingri_dr->initm_phmnf_dr->phmnf_name manf,"
 s sql=sql_"INGRTI_MEDRTITM_DR inclb,"
 s sql=sql_"ingrti_retuom_dr uom,"
 s sql=sql_"ingrti_retuom_dr->ctuom_desc uomDesc,"
 s sql=sql_"ingrti_retqty qty,"
 s sql=sql_"ingrti_realprice rp,"
 s sql=sql_"ingrti_retamount rpAmt,"
 s sql=sql_"ingrti_saleprice sp,"
 s sql=sql_"ingrti_spamt spAmt,"
 s sql=sql_"ingrti_invNo invNo,"
 s sql=sql_"ingrti_invDate invDate,"
 s sql=sql_"ingrti_invAmt invAmt,"
 s sql=sql_"ingrti_sxno sxNo,"
 s sql=sql_"ingrti_oldSp oldSp,"
 s sql=sql_"ingrti_oldSpAmt oldSpAmt,"
 s sql=sql_"ingrti_retreas_dr reasonDr,"
 s sql=sql_"ingrti_retreas_dr->RET_Desc reason,"
 s sql=sql_"ingrti_aspamt aspAmt"
 s sql=sql_" from DHC_INGRTITM "
 s sql=sql_" where INGRTI_INGRT_ParRef="_INGRT 
 i orderFieldName'="" d
 . s sql=sql_" order by "_orderFieldName_" "_Dir 
 
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s err=$$$ISERR(sc)
 i err q ""
 while (xrs.Next())
 {
 s ingrti=xrs.Data("ingrti")
 s ingri=xrs.Data("ingri")
 s manf=xrs.Data("manf")
 s inclb=xrs.Data("inclb")
 s uom=xrs.Data("uom")
 s uomDesc=xrs.Data("uomDesc")
 s qty=xrs.Data("qty")
 s rp=xrs.Data("rp")
 s rpAmt=xrs.Data("rpAmt")
 s sp=xrs.Data("sp")
 s spAmt=xrs.Data("spAmt")
 s invNo=xrs.Data("invNo")
 s invDate=xrs.Data("invDate")
 i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
 s invAmt=xrs.Data("invAmt")
 s sxNo=xrs.Data("sxNo")
 s oldSp=xrs.Data("oldSp")
 s oldSpAmt=xrs.Data("oldSpAmt")
 s retReason=xrs.Data("reason")
 s reasonId=xrs.Data("reasonDr")
 s aspAmt=xrs.Data("aspAmt")  
  
 s inci=+inclb
 s code=$p($G(^INCI(inci,1)),"^",1)
 s desc=$p($G(^INCI(inci,1)),"^",2)
 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 
 s inclbObj=##class(User.INCItmLcBt).%OpenId(inclb,0)
 s batNo=inclbObj.INCLBINCIBDR.INCIBNo
 s expDate=inclbObj.INCLBINCIBDR.INCIBExpDate
 i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
 s stkqty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,uom)   ;当前可用库存
 d OutPutRow
 
 }
 q $$$OK
OutPutRow
 s Data=$lb(ingrti,ingri,inclb,code,desc,spec,batNo,expDate,manf,qty,uom,uomDesc,rp,rpAmt,sp,spAmt,oldSp,oldSpAmt,invNo,invDate,invAmt,sxNo,retReason,reasonId,aspAmt,stkqty,vendorIO,ingrtLocIO,ingrtUserIO,HospDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINGdRetItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINGdRetItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINGdRetItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINGdRetItmExecute ]
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

/// 根据退货主表的Id查询退货单号
/// Author:zhwh
/// Date:2012-07-16
/// Argu:RowId - 退货主表记录rowid
/// Return:退货单号
ClassMethod GetOrderByRowId(RowId As %String) As %String
{
  n (RowId)
  
  q:RowId="" ""
  q ##class(User.DHCINGDRET).%OpenId(RowId,0).INGRTNO
}

/// w ##class(web.DHCST.DHCINGrtItm).jsDHCINGdRecItm("0","999","ingri","desc","423")
ClassMethod jsDHCINGdRecItm(Start As %String, Limit As %String, Sort As %String, Dir As %String, INGRT As %String) As %String
{
 //s ^YSJTMP("jsDHCINGdRecItm") = $LB(Start, Limit, Sort, Dir, INGRT)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINGrtItm:DHCINGdRecItm")	
 s qPar=Sort_"^"_Dir
 s loc = $P(^DHCINGR(INGRT), "^", 13)
 s hospId = $P(^CTLOC(loc), "^", 22)
 s sc=result.Execute(qPar,INGRT)
 
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
  ;s ingrti=result.Data("ingrti")   //退货子表rowid(DHC_INGRtItm)
  s ingri=result.Data("ingri")    //入库子表rowid(DHC_INGdRecItm)
  s manf=result.Data("manf")   //厂家 
  s inclb=result.Data("inclb")   //批次DR(INC_ItmLcBt)
  s inci = +inclb
  s uom=result.Data("uom")    //单位名称
  s qty=result.Data("qty")      //数量
  s rp=result.Data("rp")    //进阶
  s rpAmt=result.Data("rpAmt")   //进阶金额
  s sp=result.Data("sp")   //售价
  s spAmt=result.Data("spAmt")   //售价金额
  s invNo=result.Data("invNo")    //发票号
  s invDate=result.Data("invDate")  //发票日期
  s invAmt=result.Data("invAmt")    //发票金额
  s sxNo=result.Data("sxNo")    //随行单号
  s oldSp=result.Data("oldSp")   //批次售价
  s oldSpAmt=result.Data("oldSpAmt")   //批次售价金额
  s aspAmt=result.Data("aspAmt")     //退货调价
  s code=result.Data("code")     //代码 
  s desc=result.Data("desc")   //描述
  s spec =result.Data("spec")   //规格
  s batNo=result.Data("batNo")   //批号
  s expDate=result.Data("expDate")   //效期
  s retReason=result.Data("retReason")   //退货原因
  s reasonId=result.Data("retReasonId")
  s stkqty=result.Data("stkQty")
  s:uom'="" uomDesc=$p(^CT("UOM",uom),"^",2)
  s buom=$p(^INCI(+inclb,1),"^",10)
  s purUom=$p(^INCI(+inclb,3),"^",6)
  s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(purUom,buom)
  s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inci, hospId)
  s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inci, hospId)
  s tmp = ""_"^"_ingri_"^"_inclb_"^"_code_"^"_desc_"^"_spec_"^"_batNo_"^"_expDate_"^"_manf_"^"_qty_"^"_uom_"^"_rp_"^"_rpAmt_"^"_sp_"^"_spAmt_"^"_oldSp_"^"_oldSpAmt_"^"_invNo_"^"_invDate_"^"_invAmt_"^"_sxNo_"^"_retReason_"^"_reasonId_"^"_stkqty_"^"_$g(uomDesc)_"^"_buom_"^"_confac_"^"_InsuCode_"^"_InsuDesc
  s count = count+1

  CONTINUE:count<(Start+1)
  CONTINUE:count>end			
	
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData("ingrti^ingri^inclb^code^desc^spec^batNo^expDate^manf^qty^uom^rp^rpAmt^sp^spAmt^oldSp^oldSpAmt^invNo^invDate^invAmt^sxNo^retReason^reasonId^stkqty^uomDesc^buom^confac^InsuCode^InsuDesc",count)
 k json
 Q resultString
}

Query DHCINGdRecItm(qPar As %String, INGRI As %String) As %Query(ROWSPEC = "ingrti:%String,ingri:%String,inclb:%String,code:%String,desc:%String,spec:%String,batNo:%String,expDate:%String,manf:%String,qty:%Float,uom:%String,uomDesc:%String,rp:%Float,rpAmt:%Float,sp:%Float,spAmt:%Float,oldSp:%Float,oldSpAmt:%Float,invNo:%String,invDate:%String,invAmt:%Float,sxNo:%String,retReason:%String,retReasonId:%String,aspAmt:%Float,stkQty:%Float") [ SqlProc ]
{
}

ClassMethod DHCINGdRecItmExecute(ByRef qHandle As %Binary, qPar As %String, INGRI As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:INGRI="" $$$OK
 
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 
 //排序字段
 s orderFieldName=""
 s:Sort="ingri" orderFieldName="ingri"
 s:Sort="InvNo" orderFieldName="ingrti_invNo"
 s:Sort="sxNo" orderFieldName="ingrti_sxno"
 s:Sort="manf" orderFieldName="manf"
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s sql="select %ID ingri,"
 ;s sql=sql_"ingrti_ingri_dr ingri,"
 s sql=sql_"initm_phmnf_dr->phmnf_name manf,"
 s sql=sql_"INGRI_INCLB_DR inclb,"
 s sql=sql_"INGRI_CTUOM_DR uom,"
 s sql=sql_"INGRI_CTUOM_DR->ctuom_desc uomDesc,"
 s sql=sql_"INGRI_RecQty qty,"
 s sql=sql_"initm_realprice rp,"
 s sql=sql_"initm_realtotal rpAmt,"
 s sql=sql_"initm_saleprice sp,"
 s sql=sql_"initm_SpAmt spAmt,"
 s sql=sql_"initm_invno invNo,"
 s sql=sql_"initm_invdate invDate,"
 s sql=sql_"initm_invmoney invAmt,"
 s sql=sql_"initm_sxno sxNo,"
 s sql=sql_"initm_newSp oldSp,"
 s sql=sql_"initm_newSpAmt oldSpAmt"
 ;s sql=sql_"ingrti_retreas_dr reasonDr,"
 ;s sql=sql_"ingrti_retreas_dr->RET_Desc reason,"
 ;s sql=sql_"ingrti_aspamt aspAmt"
 s sql=sql_" from DHC_INGdRecItm"
 s sql=sql_" where INGRI_INGR_ParRef="_INGRI 
 ;i orderFieldName'="" d
 ;. s sql=sql_" order by "_orderFieldName_" "_Dir 
 
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 s err=$$$ISERR(sc)
 i err q ""
 while (xrs.Next())
 {
 ;s ingrti=xrs.Data("ingrti")
 s ingri=xrs.Data("ingri")
 s manf=xrs.Data("manf")
 s inclb=xrs.Data("inclb")
 s uom=xrs.Data("uom")
 s uomDesc=xrs.Data("uomDesc")
 s qty=xrs.Data("qty")
 s rp=xrs.Data("rp")
 s rpAmt=xrs.Data("rpAmt")
 s sp=xrs.Data("sp")
 s spAmt=xrs.Data("spAmt")
 s invNo=xrs.Data("invNo")
 s invDate=xrs.Data("invDate")
 i invDate'="" s invDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate,"ST")
 s invAmt=xrs.Data("invAmt")
 s sxNo=xrs.Data("sxNo")
 s oldSp=xrs.Data("oldSp")
 s oldSpAmt=xrs.Data("oldSpAmt")
 ;s retReason=xrs.Data("reason")
 ;s reasonId=xrs.Data("reasonDr")
 ;s aspAmt=xrs.Data("aspAmt")  
 s inci=+inclb
 s code=$p($G(^INCI(inci,1)),"^",1)
 s desc=$p($G(^INCI(inci,1)),"^",2)
 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 
 s inclbObj=##class(User.INCItmLcBt).%OpenId(inclb,0)
 s batNo=inclbObj.INCLBINCIBDR.INCIBNo
 s expDate=inclbObj.INCLBINCIBDR.INCIBExpDate
 i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
 s stkqty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,uom)   ;当前可用库存
 
 d OutPutRow1
 
 }
 q $$$OK
OutPutRow1
 s Data=$lb("",ingri,inclb,code,desc,spec,batNo,expDate,manf,qty,uom,uomDesc,rp,rpAmt,sp,spAmt,oldSp,oldSpAmt,invNo,invDate,invAmt,sxNo,"","","",stkqty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINGdRecItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINGdRecItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINGdRecItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINGdRecItmExecute ]
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

ClassMethod NewPid()
{
	q $i(^DHCSTPID("DHCINGrtItm"))
}

}
