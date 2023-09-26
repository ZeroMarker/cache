Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2015-06-23
/// Descript:拆包装
Class web.DHCST.Android.UnPack Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:检查条码是否为东华
ClassMethod CheckBCodeIfDHC(BarCode As %String) As %String
{
	n (BarCode)
	//判断条码是否以DH字符开头
	Q:$EXTRACT(BarCode,1,2)="DH" "1"
	//判断条码是否存在表 DHC_IncBatPack
	//s inbpID=$o(^DHCINBP(0,"BarCode",BarCode,""))
	//q:inbpID="" "0"
	Q 0
}

/// Descript:检查是否重复拆包
ClassMethod CheckIfRepUnPack(barcode As %String, inincib As %String, uomdr As %String) As %String
{
	n (barcode,ininclb,uomdr)
	s quitflag=0
	s InbpID=""
	f  s InbpID=$o(^DHCINBP(0,"BarCode",barcode,InbpID)) q:(InbpID="")||(quitflag=1)  d
	.s incib=$p(^DHCINBP(InbpID),"^",1)
	.q:incib=""
	.q:inincib'=incib
	.s puomdr=$p(^DHCINBP(InbpID),"^",3)  //单位
	.q:(uomdr'=puomdr)
	.s quitflag=1
	Q 1
}

/// Descript:返回条码对应的药品列表
/// SpecialDecalre:此为根据条码获取数据的公共方法,勿动(yunhaibao20150727)
/// 如果类组有值则判断类组,不影响拆包程序
/// w ##class(web.DHCST.Android.UnPack).QueryIncBatPackListNew("123","DH20150625000100030000","")
/// w ##class(web.DHCST.Android.UnPack).QueryIncBatPackList("102","987414997","","")
ClassMethod QueryIncBatPackList(LocId As %String, BarCode As %String, IncCatGrp = "", Type = "") As %GlobalCharacterStream
{
	N (LocId,BarCode,IncCatGrp,Type)
	//s ^yunhaibao("QueryIncBatPackList")=LocId_"^"_BarCode_"^"_IncCatGrp_"^"_Type
	s ListStream=##class(%GlobalCharacterStream).%New()
	s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
	i IncCatGrp="null" s IncCatGrp=""
	S InbpID=$o(^DHCINBP(0,"BarCode",BarCode,""))
	i InbpID="" d 
	.d ListStream.Write(EmptyJson) //输出空的json串
	q:(Type="")&&(InbpID="") ListStream.Read()
	Q:InbpID="" ListStream
	S incib=$p(^DHCINBP(InbpID),"^",1)
	i incib="" d ListStream.Write(EmptyJson)
	q:(Type="")&&(incib="") ListStream.Read()
	Q:incib="" ListStream
	S inci=+incib
	S IL=$o(^INCI("IL_LOC",LocId,inci,""))
	i IL="" d ListStream.Write(EmptyJson)
	q:(Type="")&&(IL="") ListStream.Read()
	Q:IL="" ListStream
    S LB=$o(^INCI("LB_IB",incib,inci,IL,""))
    i LB="" d ListStream.Write(EmptyJson)
	q:(Type="")&&(LB="") ListStream.Read()
	Q:LB="" ListStream
    S inccatgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    S incscg=$p(inccatgrpinfo,"^",5)
    i (IncCatGrp'="")&&(IncCatGrp'=incscg) d ListStream.Write(EmptyJson)
    Q:(IncCatGrp'="")&&(IncCatGrp'=incscg)&&(Type="") ListStream.Read()
    Q:(IncCatGrp'="")&&(IncCatGrp'=incscg) ListStream
    S inclb=inci_"||"_IL_"||"_LB
	S incicode=$p(^INCI(inci,1),"^",1)
	S incidesc=$p(^INCI(inci,1),"^",2)
	S batno=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)   //批号
	S expdate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2) //效期
	S:expdate'="" expdate=$zd(expdate,3)
	//S puomdr=$p(^DHCINBP(InbpID),"^",3)  //单位
	S puomdr=$p(^INCI(inci,3),"^",6)
	S puomdesc=$p(^CT("UOM",puomdr),"^",2)
	S qty=$p(^DHCINBP(InbpID),"^",4)     //数量
	S stkbinstr=##Class(web.DHCST.Android.UnPack).getIncStkBin(inci_"||"_IL)
	S stkbincode=$p(stkbinstr,"^",1)
	S stkbindesc=$p(stkbinstr,"^",2)
	s midfac=""
	i $d(^DHCITMINFO(0,"INCI",inci)) d
	.s itmadd=$o(^DHCITMINFO(0,"INCI",inci,""))
	.s midfac=$p(^DHCITMINFO(itmadd),"^",81)  //中包装到小包装系数
	S ListData=inci_"^"_incicode_"^"_incidesc_"^"_qty_"^"_batno_"^"_expdate_"^"_puomdr_"^"_puomdesc_"^"_BarCode_"^"_inclb_"^"_incib_"^"_stkbindesc_"^"_stkbincode_"^"_midfac
	d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
	S ListTitle="inci^incicode^incidesc^qty^batno^expdate^puomdr^puomdesc^barcode^inclb^incib^stkbindesc^stkbincode^midfac"
	s outputdata=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	d ListStream.Write(outputdata)
	d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
	q:Type="" ListStream.Read()
	q ListStream
}

/// Descript:返回条码对应的药品列表
/// 帐盘数量 台账
/// SpecialDecalre:此为根据条码获取数据的公共方法,huangcq 
/// 如果类组有值则判断类组,不影响拆包程序
/// w ##class(web.DHCST.Android.UnPack).QueryIncBatPackListNew("123","DH20150625000100030000","")
/// w ##class(web.DHCST.Android.UnPack).QueryIncBatPackListi("1302","6927073409483","")
ClassMethod QueryIncBatPackListi(LocId As %String, BarCode As %String, IncCatGrp = "") As %String
{
	N (LocId,BarCode,IncCatGrp)
	//s ^huangchuanqi("CBZ")=LocId_","_BarCode_","_IncCatGrp
	i IncCatGrp="null" s IncCatGrp=""
	S InbpID=$o(^DHCINBP(0,"BarCode",BarCode,""))
	i InbpID="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:InbpID="" ""
	S incib=$p(^DHCINBP(InbpID),"^",1)
	i incib="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	Q:incib="" ""
	S inci=+incib
	S IL=$o(^INCI("IL_LOC",LocId,inci,""))
	i IL="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
    Q:IL="" ""
    S LB=$o(^INCI("LB_IB",incib,inci,IL,""))
    i LB="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
    Q:LB="" ""
    S inccatgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
    S incscg=$p(inccatgrpinfo,"^",5)
    i (IncCatGrp'="")&&(IncCatGrp'=incscg) w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
    Q:(IncCatGrp'="")&&(IncCatGrp'=incscg) ""
    S inclb=inci_"||"_IL_"||"_LB
	S incicode=$p(^INCI(inci,1),"^",1)
	S incidesc=$p(^INCI(inci,1),"^",2)
	S batno=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)   //批号
	S expdate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2) //效期
	S:expdate'="" expdate=$zd(expdate,3)
	//S puomdr=$p(^DHCINBP(InbpID),"^",3)  //单位
	S puomdr=$p(^INCI(inci,3),"^",6)
	S puomdesc=$p(^CT("UOM",puomdr),"^",2)
	S qty=$p(^DHCINBP(InbpID),"^",4)     //数量
    //s instkqty=$p(^INCI(inci,"IL",$p(IL,"||",2),"LB",$p(LB,"||",3)),"^",2) //
	s instkqty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,LocId,+$h)
	s inStkQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(inci,instkqty)      //2016-3-28帐盘数量
	S stkbinstr=##Class(web.DHCST.Android.UnPack).getIncStkBin(inci_"||"_IL)
	S stkbincode=$p(stkbinstr,"^",1)
	S stkbindesc=$p(stkbinstr,"^",2)
	s midfac=""
	i $d(^DHCITMINFO(0,"INCI",inci)) d
	.s itmadd=$o(^DHCITMINFO(0,"INCI",inci,""))
	.s midfac=$p(^DHCITMINFO(itmadd),"^",81)  //中包装到小包装系数
	S ListData=inci_"^"_incicode_"^"_incidesc_"^"_qty_"^"_batno_"^"_expdate_"^"_puomdr_"^"_puomdesc_"^"_BarCode_"^"_inclb_"^"_incib_"^"_stkbindesc_"^"_stkbincode_"^"_midfac_"^"_inStkQty
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1) //输出json前缀串
	S ListTitle="inci^incicode^incidesc^qty^batno^expdate^puomdr^puomdesc^barcode^inclb^incib^stkbindesc^stkbincode^midfac^inStkQty"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	q ""
}

/// Descript:获取货位描述
ClassMethod getIncStkBin(incil) As %String
{
	N (incil)
	Q:incil="" ""
	S incilb=$o(^DHCINCILB(0,"Loc",incil,""))
	Q:incilb="" ""
	S stkbindr=$p(^DHCINCILB(incilb),"^",2)
	Q:stkbindr="" ""
	S stkbincode=$p(^INC("SB",stkbindr),"^",1)
	S stkbindesc=$p(^INC("SB",stkbindr),"^",2)
	Q stkbincode_"^"_stkbindesc
}

/// Descript:拆包
/// w ##class(web.DHCST.Android.UnPack).UnPack(locdr, inclb, uom, qty, parbarcode) 
ClassMethod UnPack(locdr As %String, inclb As %String, uom As %String, qty As %String, parbarcode As %String) As %String
{
	n (locdr,inclb,uom,qty,parbarcode)
	//s ^yunhaibao("web.DHCST.Android.UnPack","UnPack")=locdr_","_inclb_","_uom_","_qty_","_parbarcode
	s uomdr=##Class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
	q:uomdr="" "-2"
	//s reflag=..CheckIfRepUnPack(parbarcode,inclb,uomdr)
	//q:reflag=1 "-1"
	s checkFlag = ..CheckBCodeIfDHC(parbarcode)
	i checkFlag = 1 d
	.i $EXTRACT(parbarcode,18)'=0 d
	..s barcode=..GetCurMaxNo($EXTRACT(parbarcode,1,18),4)   //东华
	.e  d
	..s barcode=..GetCurMaxNo($EXTRACT(parbarcode,1,14),8)   //东华
	e  d
	.s barcode=..GetCurMaxNo("DH"_$zd($H,8),12)   //第三方

    d ..modIncBatPackQty(parbarcode,-qty)  ///处理条码数量
	s ret = ..InsIncBatPack(inclb,barcode,uomdr,qty,parbarcode,locdr,0)
	q ret
}

/// Descript:Insert DHC_IncBatPack
ClassMethod InsIncBatPack(inclb As %String, barcode As %String, uomdr As %String, qty As %String, parbarcode As %String, locdr As %String, printflag As %String, initi As %String = "") As %String
{
	n (inclb,barcode,uomdr,qty,parbarcode,locdr,printflag,initi)
	&sql(Insert into DHC_IncBatPack(INBP_INCIB_Dr,INBP_BarCode,INBP_Uom_Dr,INBP_Qty,INBP_ParBarCode,INBP_Loc_Dr,INBP_PrintFlag,INBP_INITI_Dr)
		Values(:inclb,:barcode,:uomdr,:qty,:parbarcode,:locdr,:printflag,:initi))
	q SQLCODE
}

/// Descript:update DHC_IncBatPack
ClassMethod updIncBatPack(InbpID, barcode) As %String
{
	n (InbpID,barcode)
	&sql(update DHC_IncBatPack set INBP_BarCode=:barcode where INBP_RowID=:InbpID)
	q SQLCODE
}

/// Descript:保存 DHC_IncBatPack
ClassMethod saveIncBatPack(incib As %String, barcode As %String, parbarcode As %String, locdr As %String, initi As %String, uomdr As %String, qty) As %String
{
	n (incib,barcode,parbarcode,locdr,initi,uomdr,qty)
	i barcode'="" d
	.s inbpid=$o(^DHCINBP(0,"BarCode",barcode,""))
	.i inbpid="" d
	..s inbp=$o(^DHCINBP(0,"INTI",initi,"")) d
	..i inbp'="" d
	...&sql(update DHC_IncBatPack set INBP_INITI_Dr=:null where INBP_RowID=:inbp)
	...s InQty=$p(^DHCINBP(inbp),"^",4) //数量
	...d ..modIncBatPackQty(parbarcode,InQty)
	..d ..InsIncBatPack(incib,barcode,uomdr,qty,parbarcode,locdr,0,initi)
	..d ..modIncBatPackQty(parbarcode,-qty)
	.e  d
	..s InQty=$p(^DHCINBP(inbpid),"^",4) //数量
	..d ..modIncBatPackQty(parbarcode,InQty-qty)
	..d ..modIncBatPackQty(barcode,qty-InQty)
	e  d
	.d ..InsIncBatPackInit(parbarcode,initi)
	q 0
}

ClassMethod InsIncBatPackInit(barcode, initi)
{
	n (barcode,initi)
	&sql(update DHC_IncBatPack set INBP_INITI_Dr=:initi where INBP_BarCode=:barcode)
	q SQLCODE
}

/// Descript:更新父记录中的数量
ClassMethod modIncBatPack(initi As %String, qty As %String, barcode As %String) As %String
{
	n (initi,qty,barcode)
	&sql(update DHC_IncBatPack set INBP_BarCode=:barcode, INBP_Qty=:qty where INBP_INITI_Dr=:InbpID)
	q SQLCODE
}

/// Descript:获取单位
ClassMethod getUomList(inci As %String) As %String
{
	n (inci)
	q:'$d(^INCI(inci)) "-1"
	s ListData=""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	//i infoid'="" d
	s uomdr=$p(^INCI(inci,1),"^",10)
	s uomdesc=$p(^CT("UOM",uomdr),"^",2)
	s puomdr=$p(^INCI(inci,3),"^",6)
	s puomdesc=$p(^CT("UOM",puomdr),"^",2)
	Q puomdesc_"^"_uomdesc
}

/// Descript:获取最大码
ClassMethod GetCurMaxNo(Prefix, NoLen)
{
	N (Prefix,NoLen)
	S NextNo=""
	L +^DHCSTINCBATPACK("DHCSTSUPCHAUNPACK",Prefix):10 E  Q -100
	S PreLen=$L(Prefix)
	S MinSuffix=1
	F i=1:1:NoLen-1 S MinSuffix="0"_MinSuffix
	S MinNo=Prefix_MinSuffix	//最小码
	S CurLen=PreLen+NoLen		//条码长度
	
	S CurrMaxNo=..GetMaxCodeByCode(Prefix) ///DHC_IncBatPack 表里记录的最大码
	S CurPrefix=$E(CurrMaxNo,1,PreLen)
	S CurrNo=$E(CurrMaxNo,PreLen+1,PreLen+4)
	S Suffix=CurrNo+1
	S slen=$L(Suffix)
	S flen=4-slen
	F i=1:1:flen S Suffix="0"_Suffix

	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix=Suffix_"0"
	
	S NextNo=Prefix_Suffix
	L -^DHCSTINCBATPACK("DHCSTSUPCHAUNPACK",Prefix)
	Q NextNo
}

/// Descript:当前最大条码
ClassMethod GetMaxCodeByCode(Code)
{
	N (Code)
	q:Code="" ""
	s itmcode=""
	&sql(select max(INBP_BarCode) into :itmcode from DHC_IncBatPack Where INBP_BarCode %STARTSWITH %ALPHAUP :Code)
	q itmcode
}

/// Descript:获取科室待接收转移单单号列表
/// W ##Class(web.DHCST.Android.UnPack).getTransferNoList(7)
ClassMethod getTransferNoList(LocID As %String) As %String
{
	N (LocID)
	Q:LocID="" "[{}]"
	s count = 0
	w "["
	S init=""
	F  S init=$o(^DHCINIT(init),-1) Q:init=""  D
	.Q:init=0
	.S transNo=$p(^DHCINIT(init),"^",1) //单号
	.S recLoc=$p(^DHCINIT(init),"^",6)  //接收科室
	.Q:$p(^DHCINIT(init),"^",14)'="21"
	.Q:recLoc'=LocID
	.S tmp=init_"^"_transNo
	.S count = count+1
	.Q:count>8
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("init^transno",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("init^transno",tmp)
	w "]"
	Q ""
}

/// Descript:库存转移接收
ClassMethod TransInAuditPart(init As %String, barcode As %String, UserId As %String) As %String
{
	n (init,barcode,UserId)
	s InbpID=$o(^DHCINBP(0,"BarCode",barcode,""))
	q:InbpID="" "-1"
	s initi=$p(^DHCINBP(InbpID),"^",9) //转移ID
	s ch=$p(initi,"||",2)
	q:$p(^DHCINIT(init,"ITI",ch),"^",23)'="21" "-2"
	s ret=##class(web.DHCST.DHCINIsTrf).TransInAuditYesPart(init,UserId,initi)
	q ret
}

/// 取库存转移单明细记录的数据串(json)
/// Author:zhwh
/// Date:2012-07-16
/// Argu: 
///     init- -库存转移单主表rowid
/// Return:
///    数据串(json格式)
ClassMethod jsDHCINIsTrfD(Start As %String, Limit As %String, initi As %String) As %String
{
 s result=##class(%Library.ResultSet).%New("web.DHCST.Android.UnPack:DHCINIsTrfD")
 s sc=result.Execute(initi)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

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

Query DHCINIsTrfD(initi As %String) As %Query(ROWSPEC = "initi:%String,inclb:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,manfName:%String,uom:%String,qty:%Float,inrqi:%String,rp:%Float,rpAmt:%Float,pp:%Float,ppAmt:%Float,sp:%Float,spAmt:%Float,newSp:%Float,newSpAmt:%Float,status:%String,remark:%String,form:%String,gene:%String,stkbin:%String,inclbQty:%String,inclbDirtyQty:%String,inclbAvaQty:%String,reqLocStkQty:%String,BUomId:%String,ConFac:%String,reqQty:%Float,batNo:%String,expDate:%String,TrUomDesc:%String,dirtyQty:%String,goodName:%String") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfDExecute(ByRef qHandle As %Binary, initiID As %String) As %Status
{
	n (qHandle,initiID)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:initiID="" $$$OK
 s init=+initiID
 s sql= "select %ID initi,"
 s sql=sql_"initi_inclb_dr inclb,"
 s sql=sql_"initi_inclb_dr->inclb_incib_dr->incib_no batNo,"
 s sql=sql_"initi_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
 s sql=sql_"initi_ctuom_dr uom,"
 s sql=sql_"initi_qty qty,"
 s sql=sql_"initi_inrqi_dr  inrqi,"
 s sql=sql_"dhciti_realprice rp,"
 s sql=sql_"dhciti_rpamount rpAmt,"
 s sql=sql_"dhciti_purprice pp,"
 s sql=sql_"dhciti_ppamount ppAmt,"
 s sql=sql_"dhciti_saleprice sp,"
 s sql=sql_"dhciti_spamount spAmt,"
 s sql=sql_"dhciti_newsp newSp,"
 s sql=sql_"dhciti_newspamt newSpAmt,"
 s sql=sql_"dhciti_state status,"
 s sql=sql_"dhciti_remark remark"
 s sql=sql_" from dhc_inistrfitm"
 s sql=sql_" where initi_init_parref="_init
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK
 while ( xrs.Next())
 {
   s initi=xrs.Data("initi")
   continue:($p(initiID,"||",2)'="")&(initi'=initiID)
   s inclb=xrs.Data("inclb")
   s uom=xrs.Data("uom")
   s:uom'="" uomDesc=$p(^CT("UOM",uom),"^",2)
   s qty=xrs.Data("qty")
   s inrqi=xrs.Data("inrqi")
   s rp=xrs.Data("rp")
   s rpAmt=xrs.Data("rpAmt")
   s pp=xrs.Data("pp")
   s ppAmt=xrs.Data("ppAmt")
   s sp=xrs.Data("sp")
   s spAmt=xrs.Data("spAmt")
   s newSp=xrs.Data("newSp")
   s newSpAmt=xrs.Data("newSpAmt")
   s status=xrs.Data("status")
   s remark=xrs.Data("remark")
  
   s batNo=xrs.Data("batNo")
   s expDate=xrs.Data("expDate")
   i ((expDate'="")&&(expDate'["-")) d	;防止润乾报表在sql中将日期转换为Y-m-d格式造成的错误
   .s expDate=$zd(expDate,3)

   s batexp=batNo_"~"_expDate 
   s inci=+inclb
   s inciCode=$P(^INCI(inci,1),"^",1)
   s inciDesc=$P(^INCI(inci,1),"^",2)
   s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
   s manfInfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
   s manf=$P(manfInfo,"^",1)
   s manfName=$P(manfInfo,"^",2)
   ;zdm,2012-07-19,增加下述信息
   s formInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci)
   s formDesc=$p(formInfo,"^",2)
   s geneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
   s geneDesc=$p(geneInfo,"^",2)
   s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(inci)	;商品名
   s proLocId=$p(^DHCINIT(+initi),"^",5)
   s reqLocId=$p(^DHCINIT(+initi),"^",6)
   s initDate=$p(^DHCINIT(+initi),"^",2)
   s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(proLocId,inci)
   s stkbin=$p(stkbin,"^",1)
   s inclbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBUom(inclb,uom,+$h)  ;当前库存
   s inclbDirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(inclb,uom)  ;当前占用库存
   s inclbAvaQty=inclbQty-inclbDirtyQty   ;当前可用库存
   s dirtyQty=0
   //s status=$p(^DHCINIT(init),"^",14)
   i (status'=21)!(status'=31) s dirtyQty=qty   ;本次占用数量
   continue:status'="31"
   s:status="31" status="已接收"
   s reqLocStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci, reqLocId, uom, +$h)
   s BUomId=$p(^INCI(inci,1),"^",10)
   s PurUomId=$p(^INCI(inci,3),"^",6)
   s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
   s reqQty=""
   i inrqi'=""  d
   .s reqQty=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",3)
   .s reqUom=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",5)
   .s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(reqUom,BUomId)
   .s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,BUomId)
   .s reqQty=reqQty*fac1/fac2
   
  d OutPurRow
 }
 
 Quit $$$OK
OutPurRow
 
 s Data=$lb(initi,inclb,inci,inciCode,inciDesc,spec,manf,manfName,uom,qty,inrqi,rp,rpAmt,pp,ppAmt,sp,spAmt,newSp,newSpAmt,status,remark,formDesc,geneDesc,stkbin,inclbQty,inclbDirtyQty,inclbAvaQty,reqLocStkQty,BUomId,ConFac,reqQty,batNo,expDate,uomDesc,dirtyQty,goodName)
 ;s Data=$lb(initi,inclb,inci,inciCode,inciDesc,spec,manf,manfName,uom,qty,inrqi,rp,rpAmt,pp,ppAmt,sp,spAmt,newSp,newSpAmt,status,remark,formDesc,geneDesc,stkbin,inclbQty,inclbDirtyQty,inclbAvaQty,reqLocStkQty,BUomId,ConFac,reqQty,batexp,uomDesc,dirtyQty,goodName)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINIsTrfDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINIsTrfDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINIsTrfDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINIsTrfDExecute ]
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

/// Descript:保存转移数据
ClassMethod saveTransfer(InitId As %String, InListData As %String) As %String
{
	n (InitId,InListData)
    s Len=$l(InListData,$c(1))
    s LocId=$p(^DHCINIT(InitId),"^",5)
    s ListData=""
    f i=1:1:Len  q:Err'=0  d
    .s Data=$p(InListData,$c(1),i)
    .s Incib=$p(Data,"^",2)
    .s IL=$o(^INCI("IL_LOC",LocId,+Incib,""))
    .q:IL=""
    .s LB=$o(^INCI("LB_IB",Incib,+Incib,IL,""))
    .s inclb=+Incib_"||"_IL_"||"_LB
    .i ListData'="" s ListData=Data
    .e  s ListData=ListData_$c(1)_Data
	s ret=##Class(web.DHCST.DHCINIsTrfItm).Save(InitId, ListData)
	q ret
}

/// Descript:保存出库单
ClassMethod saveTransferOut(InitId As %String, ListData As %String, barcode As %String, parbarcode As %String) As %String
{
	n (InitId,ListData,barcode,parbarcode)
	q:+InitId=0 "-1"
	q:$p(^DHCINIT(+InitId),"^",14)=21 "-2"
	q:ListData="" "-3"
    s initi=$p(ListData,"^",1)
    s Inclb=$p(ListData,"^",2)
    s Qty=$p(ListData,"^",3)
    s UomId=$p(ListData,"^",4)
    s LocId=$p(^DHCINIT(InitId),"^",5)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId,"G","")
    s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId,"G",+$h,"")
    s NewSp=##class(web.DHCST.Common.PriceCommon).BatSpUom(Inclb,UomId,HospId)
    s SpAmt=Sp*Qty
    s RpAmt=Rp*Qty
    s NewSpAmt=NewSp*Qty
    s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
    s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    s ListData1=Inclb_"^"_Qty_"^"_UomId_"^"_""_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt
    s ListData2=Rp_"^"_RpAmt_"^"_NewSp_"^"_NewSpAmt_"^"_""
    s ListData=ListData1_"^"_ListData2
	s initiID=##Class(web.DHCST.DHCINIsTrfItm).Update(initi,InitId,ListData)
	q:+initiID<0 "-4"
	s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	s retVal=0
	s retVal = ..saveIncBatPack(incib,barcode,parbarcode,LocId,initiID,UomId,Qty)
	q retVal
}

/// Descript:处理条码数量
ClassMethod modIncBatPackQty(pLabel As %String, qty As %String) As %String
{
	n (pLabel,qty)
    s InbpID=$o(^DHCINBP(0,"BarCode",pLabel,""))
	q:InbpID="" "-1"
	s InQty=$p(^DHCINBP(InbpID),"^",4) //数量
	s $p(^DHCINBP(InbpID),"^",4)=InQty+qty
	q 0
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCST.Android.UnPack","QueryIncBatPackList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("web.DHCST.Android.UnPack"))
}

}
