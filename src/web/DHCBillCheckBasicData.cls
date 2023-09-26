Import SQLUser

Class web.DHCBillCheckBasicData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INSERT() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_BillCheckBasicData Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)  
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillCheckBasicData WHERE DHCBCBD_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	&sql(UPDATE DHC_BillCheckBasicData VALUES PLIST() WHERE DHCBCBD_Rowid= :RowId)
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod DELETE(RowId)
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBasicData WHERE DHCBCBD_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod DELETEALL()
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBasicData) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod DELETEBYTYPE(DELETEBYTYPE)
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBasicData WHERE DHCBCBD_Type= :DELETEBYTYPE) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  Set SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  Set SQLCODE=$zu(34)
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCBillCheckBasicData","FindBasicData","","")
Query FindBasicData(BDType As %String = "", BDSubType As %String = "") As websys.Query(ROWSPEC = "错误类型:%String,错误描述:%String,医嘱项名称:%String,医嘱项ID:%String,收费项名称:%String,收费项ID:%String,库存项名称:%String,库存项ID:%String,数据:%String,表ID:%String,HJFlag:%String")
{
}

ClassMethod FindBasicDataExecute(ByRef qHandle As %Binary, BDType As %String = "", BDSubType As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1,count=1
    Kill ^ArrayOrder($j)
    If BDType="" Do
    .Set DHCBDType=""
    .For  Set DHCBDType=$o(^DHCBILLCHECKBASICDATA("0","BDType",DHCBDType)) Quit:DHCBDType=""  d
    ..Quit:DHCBDType=0
    ..Set Rowid=""
    ..For  Set Rowid=$o(^DHCBILLCHECKBASICDATA("0","BDType",DHCBDType,Rowid)) Quit:Rowid=""  Do
    ...Quit:Rowid=0
    ...Do GetData(Rowid)
    Else  Do
    .Set Rowid=""
    .For  Set Rowid=$o(^DHCBILLCHECKBASICDATA("0","BDType",BDType,Rowid)) Quit:Rowid=""  Do
    ..Quit:Rowid=0
    ..Do GetData(Rowid)
    Do OutputRowBD1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetData(Rowid)
    Set (ArcimDesc,TariDesc,InciDesc)=""
    Set DHCBCBDType=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",1)
    Set DHCBCBDSubType=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",2)
    Quit:((BDSubType'="")&(BDSubType'[DHCBCBDSubType))
	Set DHCBCBDText=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",3)
    Set DHCBCBDArcItmDr=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",4)
    If DHCBCBDArcItmDr'="" Set ArcimDesc=$p($g(^ARCIM(+DHCBCBDArcItmDr,$p(DHCBCBDArcItmDr,"||",2),1)),"^",2)
    Set DHCBCBDTariDr=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",5)
    If DHCBCBDTariDr'="" Set TariDesc=$p($g(^DHCTARI(DHCBCBDTariDr)),"^",2)
    Set DHCBCBDInciDr=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",6)
	If DHCBCBDInciDr'="" Set InciDesc=$p(^INCI(DHCBCBDInciDr,1),"^",2)
	Set DHCBCBDData=$p(^DHCBILLCHECKBASICDATA(Rowid),"^",7)
    Set DHCBCBDType=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(DHCBCBDType)
    Set ArcimDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(ArcimDesc)
    Set TariDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(TariDesc)
    Set InciDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(InciDesc)
    Set DHCBCBDData=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(DHCBCBDData)
    Set DHCBCBDText=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(DHCBCBDText)
    
    If DHCBCBDArcItmDr'="" Set DHCBCBDArcItmDr=DHCBCBDArcItmDr_" (ARC_ItmMast.ARCIM_RowId)"
    If DHCBCBDTariDr'="" Set DHCBCBDTariDr=DHCBCBDTariDr_" (DHC_TarItem.TARI_RowId)"
    If DHCBCBDInciDr'="" Set DHCBCBDInciDr=DHCBCBDInciDr_" (INC_Itm.INCI_RowId)"
    
    Set ^ArrayOrder($j,DHCBCBDType,DHCBCBDText,count)=DHCBCBDType_"!@#"_DHCBCBDText_"!@#"_ArcimDesc_"!@#"_DHCBCBDArcItmDr_"!@#"_TariDesc_"!@#"_DHCBCBDTariDr_"!@#"_InciDesc_"!@#"_DHCBCBDInciDr_"!@#"_DHCBCBDData_"!@#"_Rowid
	Set count=count+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBD1
	Set Type=""
	For  Set Type=$o(^ArrayOrder($j,Type)) Quit:Type=""  Do
	.Set Text="",Num2=0
	.For  Set Text=$o(^ArrayOrder($j,Type,Text)) Quit:Text=""  Do
	..Set ID="",Num1=0
	..For  Set ID=$o(^ArrayOrder($j,Type,Text,ID)) Quit:ID=""  Do
	...Set DHCBCBDType=$p(^ArrayOrder($j,Type,Text,ID),"!@#",1)
	...Set DHCBCBDText=$p(^ArrayOrder($j,Type,Text,ID),"!@#",2)
	...Set ArcimDesc=$p(^ArrayOrder($j,Type,Text,ID),"!@#",3)
	...Set DHCBCBDArcItmDr=$p(^ArrayOrder($j,Type,Text,ID),"!@#",4)
	...Set TariDesc=$p(^ArrayOrder($j,Type,Text,ID),"!@#",5)
	...Set DHCBCBDTariDr=$p(^ArrayOrder($j,Type,Text,ID),"!@#",6)
	...Set InciDesc=$p(^ArrayOrder($j,Type,Text,ID),"!@#",7)
	...Set DHCBCBDInciDr=$p(^ArrayOrder($j,Type,Text,ID),"!@#",8)
	...Set DHCBCBDData=$p(^ArrayOrder($j,Type,Text,ID),"!@#",9)
	...Set Rowid=$p(^ArrayOrder($j,Type,Text,ID),"!@#",10)
	...Set Num1=Num1+1
	...Set Num2=Num2+1
	...Set HJFlag=""
	...Do OutputRowBD
	..Set (ArcimDesc,DHCBCBDArcItmDr,TariDesc,DHCBCBDTariDr,InciDesc,DHCBCBDInciDr,DHCBCBDData,Rowid)=""
	..Set DHCBCBDText=DHCBCBDText_"____小计数量:"_Num1_" 条",HJFlag=1
	..Do OutputRowBD
	.Set (ArcimDesc,DHCBCBDText,DHCBCBDArcItmDr,TariDesc,DHCBCBDTariDr,InciDesc,DHCBCBDInciDr,DHCBCBDData,Rowid)=""
	.Set DHCBCBDText=DHCBCBDType_"____合计数量:"_Num2_" 条",HJFlag=2
	.Do OutputRowBD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBD
	Set Data=$lb(DHCBCBDType,DHCBCBDText,ArcimDesc,DHCBCBDArcItmDr,TariDesc,DHCBCBDTariDr,InciDesc,DHCBCBDInciDr,DHCBCBDData,Rowid,HJFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 此方法每日执行，查询计费基础数据有错误的数据及前一日业务有错误的数据，并会对demo发送消息
/// d ##class(web.DHCBillCheckBasicData).AutoCheckBillData()
ClassMethod AutoCheckBillData()
{
	; 检查基础数据
	d ##class(web.DHCBillCheckBasicData).AutoCheckBasicData()
	; 检查业务数据
	d ##class(web.DHCBillCheckBusiData).AutoCheckBusiData()
	
	q
}

/// 此方法每日执行，查询计费基础数据有错误的数据，并会对demo发送消息
/// d ##class(web.DHCBillCheckBasicData).AutoCheckBasicData()
ClassMethod AutoCheckBasicData()
{
	Do ..DELETEALL()
	Set rtn=..GetItmPriceDsHosp()
	Set rtn=..GetItmPriceDs()
	Set rtn=..CheckPriceData()
	Set rtn=..CheckLinkData()
	If $d(^DHCBILLCHECKBASICDATA) Do
	.Set JsonStr="{""link"":""dhcbillcheck.showdata.csp?classname=web.DHCBillCheckBasicData&methodname=FindBasicData&menuparam=,&menuparamnum=2"",""dialogHeight"":""1000px"",""dialogWidth"":""1200px""}"
	.Set Rtn=##class(websys.DHCMessageInterface).Send("费用核查基础数据有误","1057","1","","","1",JsonStr)

	Quit
}

/// Creator:chenxi
/// CreateDate:2014-11-07
/// Table:dhc_taritemprice，药品价格表
/// Function: 检查计费组收费项目价格与药房的价格是否一致(集团化医院根据医院对比)
/// input:空
/// output:记录收费项目rowid到global中
/// 此方法增加为后台任务
/// d ##class(web.DHCIPBillCheckDaily).GetItmPriceDsHosp()
ClassMethod GetItmPriceDsHosp() As %String
{
	///s ^TMPCX(3)="4err"
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE")
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE1")
	s outpriceinfo=""
	s node="DHCST,DHCSTPHCHECKDATA,GetItmPriceDs"
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s code=$p(^INCI(inci,1),"^",1)
	.s code=$$ALPHAUP^SSUTIL4(code)
	.q:'$d(^ARCIM(0,"Code",code))
	.s arcim=$o(^ARCIM(0,"Code",code,""))
	.s version=$o(^ARCIM(0,"Code",code,arcim,""))
	.s arcimrowid=arcim_"||"_version
	.s HOSPRowId="0"
	.f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId))  q:(HOSPRowId="")  d
	..s HospDesc=$p(^CT("HOSP",HOSPRowId),"^",2) 
	..s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$h,"",HOSPRowId)	
	..s ordpriceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimrowid, +$h, "", "", "", HOSPRowId,"")
	..s ordprice=$j($p(ordpriceinfo,"^",1),3,6)
	..s price=$j($p(price,"^",1),3,6)
	..s ArcimCode=$p(^ARCIM(arcim,version,1),"^",1)
	..s ArcimDesc=$p(^ARCIM(arcim,version,1),"^",2)
	..i +price'=+ordprice d
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",arcimrowid)="医嘱项价格与药房调价表价格不一致(arc_itmmast,arcim_rowid)"_"^"_price_"^"_ordprice_"^"_(price-ordprice)_"^"_ArcimCode_"^"_ArcimDesc_"^"_HospDesc     ;药房价格_"^"_收费项目价格
	...;s obj=##class(User.INCItm).%OpenId(inci)
	...k PLIST
	...s PLIST(2)="CheckPriceUnityData",PLIST(3)="HospPriceUnityErr",PLIST(4)="医嘱项价格与药房调价表价格不一致"
	...s PLIST(5)=arcimrowid,PLIST(6)="",PLIST(7)=inci,PLIST(8)="医嘱项价格:"_+ordprice_" ,药房价格:"_+price
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	
	q 0
}

/// w ##class(web.DHCIPBillCheckDaily).CheckPriceData()
ClassMethod CheckPriceData()
{
	///s ^TMPCX(1)="2err"
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData")
	k ^TMP("DHCBill","CheckTarEndDateErr")
	s tari=0,hospflag=0,Uhospflag=0
	f  s tari=$o(^DHCTARI(tari))  q:tari=""  d
	.q:(tari="")||('$d(^DHCOLT(0,"TAR",tari)))
	.s tp=0,tpnum=0,lastendd="",enddate=""
	.s TariDesc=$P(^DHCTARI(tari),"^",2)
	.s TariCode=$P(^DHCTARI(tari),"^",1)
	.s ErrMessage=""
	.s SubCateDr=$p(^DHCTARI(tari),"^",4)
	.s AcctCateDr=$p(^DHCTARI(tari),"^",5)
	.s MRCateDr=$p(^DHCTARI(tari),"^",6)
	.s InpatCateDr=$p(^DHCTARI(tari),"^",14)
	.s OutpatCateDr=$p(^DHCTARI(tari),"^",15)
	.s EMCCateDr=$p(^DHCTARI(tari),"^",16)
	.s NewMRCCateDr=$p(^DHCTARI(tari),"^",30)
	.i TariCode=""  d
	..s ErrMessage="收费项目代码为空"
	.i TariDesc=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目名称为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目名称为空"    
	.i SubCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目收费子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目收费子类为空"
	.i InpatCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目住院费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目住院费用子类为空"
	.i OutpatCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目门诊费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目门诊费用子类为空"
	.i EMCCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目核算费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目核算费用子类为空"
	.i AcctCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目会计费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目会计费用子类为空"
	.i MRCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目病历首页费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目病历首页费用子类为空"
	.i NewMRCCateDr=""  d
	..i ErrMessage=""  d
	...s ErrMessage="收费项目新病历首页费用子类为空"
	..e  d 
	...s ErrMessage=ErrMessage_"; 收费项目新病历首页费用子类为空"
	.;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","TarDataErr",tari)=ErrMessage_"^"_TariCode_"^"_TariDesc 
	.i ErrMessage'="" d
	..;s obj=##class(User.DHCTarItem).%OpenId(tari)
	..;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	..k PLIST
	..s PLIST(2)="CheckPriceData",PLIST(3)="CateErr",PLIST(4)=ErrMessage,PLIST(5)="",PLIST(6)=tari,PLIST(7)="",PLIST(8)=ErrMessage
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	.k ^TMP("DHCBill","CheckTarEndDateErr",tari)
	.f  s tp=$o(^DHCTARI(tari,"P",tp))  q:tp=""   d
	..s enddate=$p(^DHCTARI(tari,"P",tp),"^",4)
	..s stdate=$p(^DHCTARI(tari,"P",tp),"^",3)
	..s price=$p(^DHCTARI(tari,"P",tp),"^",5)
	..s instype=$p(^DHCTARI(tari,"P",tp),"^",13)
	..s hosp=$p(^DHCTARI(tari,"P",tp),"^",16)
	..q:hosp=""
	..///q:enddate=stdate	
	..s ErrMessage=""
	..i (stdate="")||(instype="")||(price="")||(hosp="")   d
	...i stdate=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,开始日期为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,开始日期为空"
	...i instype=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,收费类别为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,收费类别为空"
	...i price=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,价格为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,价格为空"
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","DataErr",tari_"||"_tp)=ErrMessage_"^"_TariCode_"^"_TariDesc
	...i hosp=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项目数据不完整,医院为空"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项目数据不完整,医院为空"
	...;s obj=##class(User.DHCTarItemPrice).%OpenId((tari_"||"_tp))
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckPriceData",PLIST(3)="PriceErr",PLIST(4)=ErrMessage,PLIST(5)="",PLIST(6)=tari,PLIST(7)="",PLIST(8)=ErrMessage
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()

	..q:(stdate="")||(instype="")
	..s hosp2=+hosp
	..s LastTp=$o(^TMP("DHCBill","CheckTarEndDateErr",tari,hosp2,instype,""),-1)
	..s ^TMP("DHCBill","CheckTarEndDateErr",tari,hosp2,instype,tp)=enddate
	..///i (lastendd'="")&(stdate'=(lastendd+1))   d
	..s LastEndDate2=""
	..i +LastTp'=0  d
	...s LastEndDate2=$g(^TMP("DHCBill","CheckTarEndDateErr",tari,hosp2,instype,LastTp)) 
	..i (LastTp'=tp)&(stdate'=(LastEndDate2+1))&(+LastEndDate2'=0)  d
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","PriceDateErr",tari_"||"_tp)="收费项价格日期不衔接(dhc_taritemprice,tp_rowid)"_"^"_TariCode_"^"_TariDesc
	...;s obj=##class(User.DHCTarItemPrice).%OpenId((tari_"||"_tp))
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckPriceData",PLIST(3)="PriceDateErr",PLIST(4)="收费项价格日期不衔接",PLIST(5)="",PLIST(6)=tari,PLIST(7)=""
	...s PLIST(8)="开始日期:"_$zd(stdate,3)_" ,前一条记录结束日期:"_$zd(LastEndDate2,3)
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	..i enddate=""  s tpnum=tpnum+1
	..i hosp'=""  s hospflag=1
	..i hosp=""   s Uhospflag=1
	..s lastendd=enddate
	.s lasttp=$o(^DHCTARI(tari,"P",""),-1)
	.i +lasttp=0   d
	..;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","EmptPrice",tari)="有收费项目,但价格表没有记录(dhc_taritemprice,tari_rowid)"_"^"_TariCode_"^"_TariDesc
	..;s obj=##class(User.DHCTarItem).%OpenId(tari)
	..;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	..k PLIST
	..s PLIST(2)="CheckPriceData",PLIST(3)="PriceErr",PLIST(4)="有收费项目,但价格表没有记录",PLIST(5)="",PLIST(6)=tari,PLIST(7)="",PLIST(8)="有收费项目,但价格表没有记录"
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	.q:+lasttp=0
	.i tpnum=0   d
	..i enddate'=""  d
	...s enddate1=$zd(enddate,3)
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","PriceEnd",tari)="收费项目于 "_$g(enddate1)_" 日停止后就没有维护新价格(dhc_taritemprice,tari_rowid)^"_TariCode_"^"_TariDesc
	...;s obj=##class(User.DHCTarItem).%OpenId(tari)
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckPriceData",PLIST(3)="PriceDateErr",PLIST(4)="收费项目于 "_$g(enddate1)_" 日停止后就没有维护新价格"
	...s PLIST(5)="",PLIST(6)=tari,PLIST(7)="",PLIST(8)="收费项目于 "_$g(enddate1)_" 日停止后就没有维护新价格"
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
    
    i (hospflag=1)&(Uhospflag=1)   d
    .s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckPriceData","HospErr")="收费项目价格表医院指针不对,不是所有收费项价格都维护了医院(dhc_taritemprice)" 
	///k ^TMP("DHCBill","CheckTarEndDateErr")
	q 0
}

/// w ##class(web.DHCBillCheckBasicData).CheckLinkData()
ClassMethod CheckLinkData()
{
	///s ^TMPCX(0)="1err"
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData")
	s olt=0
	f  s olt=$o(^DHCOLT(olt))   q:olt=""   d
	.s arcim=$p(^DHCOLT(olt),"^",1)
	.s tari=$p(^DHCOLT(olt),"^",2)
	.s qty=$p(^DHCOLT(olt),"^",3)
	.s stdate=$p(^DHCOLT(olt),"^",4)
	.s enddate=$p(^DHCOLT(olt),"^",5)
	.s ErrMessage=""
	.i (arcim'["||")&&(+tari'=0)  d
	..s TarCode=$p($g(^DHCTARI(tari)),"^",1)  
	..s TarDesc=$p($g(^DHCTARI(tari)),"^",2)
	..;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData","LinkDataErr",olt)="医嘱项为空,有收费项目(dhc_orderlinktar,olt_rowid)^"_"^"_TarCode_"^"_TarDesc  
	..;s obj=##class(User.DHCOrderLinkTar).%OpenId(olt)
	..;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	..k PLIST
	..s PLIST(2)="CheckLinkData",PLIST(3)="ArcimNull",PLIST(4)="医嘱项为空,有收费项目",PLIST(5)=arcim,PLIST(6)=tari,PLIST(7)="",PLIST(8)="医嘱项为空,有收费项目"
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	.i (arcim["||")||(+tari=0)||(+qty=0)||(stdate="")   d
	..s ArcimCode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
	..s ArcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	..s CatID=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	..i CatID'="" s CatIDDesc=$p(^ARC("IC",CatID),"^",2)
	..i $d(^ARCIM(+arcim,$p(arcim,"||",2),1))=0  d
	...s ErrMessage="医嘱项未找到"  
	..i +tari=0  d
	...i ErrMessage=""  d
	....s ErrMessage="收费项为空,有医嘱项"
	...e  d
	....s ErrMessage=ErrMessage_"; 收费项为空,有医嘱项"
	..e  d
	...i $d(^DHCTARI(tari))=0  d
	....i ErrMessage=""  d
	.....s ErrMessage="收费项未找到"
	....e  d
	.....s ErrMessage=ErrMessage_"; 收费项未找到"
	..i +qty=0  d
	...i ErrMessage'=""  d
	....s ErrMessage=ErrMessage_"; 医嘱与收费项目对应数量为0" 
	...e  d
	....s ErrMessage="医嘱与收费项目对应数量为0"  
	..i stdate=""  d
	...i ErrMessage'=""  d
	....s ErrMessage=ErrMessage_"; 医嘱与收费项目对应开始日期为空" 
	...e  d
	....s ErrMessage="医嘱与收费项目对应开始日期为空"
	..i ErrMessage'=""  d
	...s ErrMessage=ErrMessage
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData","LinkDataErr",olt)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc_"^"_CatIDDesc
	...;s obj=##class(User.DHCOrderLinkTar).%OpenId(olt)
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckLinkData",PLIST(3)="ArcimErr",PLIST(4)=ErrMessage,PLIST(5)=arcim,PLIST(6)=tari,PLIST(7)="",PLIST(8)=ErrMessage
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	.i enddate'=""   d
	..s Tariff="",LinkTarNum=0
	..f  s Tariff=$o(^DHCOLT(0,"ARTTA",arcim,Tariff)) q:Tariff=""  d
	...s Date=""
	...f  s Date=$o(^DHCOLT(0,"ARTTA",arcim,Tariff,Date)) q:Date=""  d
	....s OltRowID=""
	....f  s OltRowID=$o(^DHCOLT(0,"ARTTA",arcim,Tariff,Date,OltRowID)) q:OltRowID=""  d
	.....s OEndDate=$p(^DHCOLT(OltRowID),"^",5)
	.....i +OEndDate=0 d
	......s LinkTarNum=LinkTarNum+1
	..i LinkTarNum=0  d
	...s arcendd=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
	...q:(+arcendd<+$h)&(arcendd'="")
	...s ArcimCode=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",1)
	...s ArcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	...s CatID=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	...i CatID'="" s CatIDDesc=$p(^ARC("IC",CatID),"^",2)
	...i ErrMessage=""  d
	....s ErrMessage="医嘱项无有效收费项对应关系"
	...e  d
	....s ErrMessage=ErrMessage_"; 医嘱项无有效收费项对应关系"
	...i ErrMessage'=""  d
	....s ErrMessage=ErrMessage
	....;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData","OrderLinkErr",olt)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc_"^"_CatIDDesc
	....;s obj=##class(User.DHCOrderLinkTar).%OpenId(olt)
	....;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	....k PLIST
	....s PLIST(2)="CheckLinkData",PLIST(3)="ArcimErr",PLIST(4)=ErrMessage,PLIST(5)=arcim,PLIST(6)=tari,PLIST(7)="",PLIST(8)=ErrMessage
	....s rtn=##class(web.DHCBillCheckBasicData).INSERT()

    s Arcim=0
	f  s Arcim=$o(^ARCIM(Arcim)) q:Arcim=""  d
	.s Version=0
	.f  s Version=$o(^ARCIM(Arcim,Version)) q:Version=""  d
	..i (($d(^ARCIM(Arcim,Version))=0))  d
	...s ErrMessage="医嘱项未找到" 
	..k PLIST
	..s PLIST(2)="CheckLinkData",PLIST(3)="ArcimNull",PLIST(4)="医嘱项未找到",PLIST(5)=Arcim_"||"_Version,PLIST(6)="",PLIST(7)="",PLIST(8)="医嘱项未找到"
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	..q:($d(^ARCIM(Arcim,Version))=0)
	..s arcendd=$p($g(^ARCIM(+Arcim,Version,7)),"^",1)
	..q:+(arcendd<+$h)&(arcendd'="")
	..s LinkTarNum=0
	..s ArcimRowID=Arcim_"||"_Version
	..s ArcimCode=$p(^ARCIM(Arcim,Version,1),"^",1)
	..s ArcimDesc=$p(^ARCIM(Arcim,Version,1),"^",2)
	..s ordpriceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ArcimRowID, +$h, "", "", "", "","")
	..i +$g(ordpriceinfo)<=0 d
	...;s obj=##class(User.ARCItmMast).%OpenId(ArcimRowID)
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckLinkData",PLIST(3)="Price0Err",PLIST(4)="医嘱价格等于0或者小于0",PLIST(5)=ArcimRowID,PLIST(6)="",PLIST(7)="",PLIST(8)="医嘱价格:"_ordpriceinfo
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	..s ErrMessage=""
	..s Tariff=""
	..f  s Tariff=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff)) q:Tariff=""  d
	...s StDate=""
	...f  s StDate=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate)) q:StDate=""  d
	....s OltRowID=""
	....f  s OltRowID=$o(^DHCOLT(0,"ARTTA",ArcimRowID,Tariff,StDate,OltRowID)) q:OltRowID=""  d
	.....s EndDate=$p(^DHCOLT(OltRowID),"^",5)
	.....i +EndDate=0 d
	......s LinkTarNum=LinkTarNum+1
	..i LinkTarNum=0 d
	...i ErrMessage=""  d
	....s ErrMessage="医嘱项无有效对应关系"
	...e  d
	....s ErrMessage=ErrMessage_"医嘱项无有效对应关系"
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData","OrderLinkNull",ArcimRowID)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc
	...;s obj=##class(User.ARCItmMast).%OpenId(ArcimRowID)
	...;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	...k PLIST
	...s PLIST(2)="CheckLinkData",PLIST(3)="ArcimErr",PLIST(4)=ErrMessage,PLIST(5)=ArcimRowID,PLIST(6)="",PLIST(7)="",PLIST(8)=ErrMessage
	...s rtn=##class(web.DHCBillCheckBasicData).INSERT()
    ..i LinkTarNum>1   d
    ...Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))
    ...s ArcimCode=$p(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1),"^",1)
	...s ArcimDesc=$p(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1),"^",2)
	...i inci'=""  d
	....i ErrMessage=""  d
	.....s ErrMessage="库存项不能有多条对应关系"
	....e  d
	.....s ErrMessage=ErrMessage_"; 库存项不能有多条对应关系"
	....;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","CheckLinkData","DrugErr",ArcimRowID)=ErrMessage_"^"_ArcimCode_"^"_ArcimDesc
	....;s obj=##class(User.ARCItmMast).%OpenId(ArcimRowID)
	....;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	....k PLIST
	....s PLIST(2)="CheckLinkData",PLIST(3)="InciErr",PLIST(4)=ErrMessage,PLIST(5)=ArcimRowID,PLIST(6)="",PLIST(7)="",PLIST(8)=ErrMessage
	....s rtn=##class(web.DHCBillCheckBasicData).INSERT()

    q 0
}

/// Creator:yyx,liangqiang
/// CreateDate:2014-08-02
/// Table:dhc_taritemprice，药品价格表
/// Function: 检查计费组收费项目价格与药房的价格是否一致
/// input:空
/// output:记录收费项目rowid到global中
/// 此方法增加为后台任务
/// d ##class(web.DHCIPBillCheckDaily).GetItmPriceDs()
ClassMethod GetItmPriceDs() As %String
{
	///s ^TMPCX(2)="3err"
	k ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE")
	s outpriceinfo=""
	s node="DHCST,DHCSTPHCHECKDATA,GetItmPriceDs"
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	s inci=""
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s code=$p(^INCI(inci,1),"^",1)
	.s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(inci,+$h,"")
	.s code=$$ALPHAUP^SSUTIL4(code)
	.q:'$d(^ARCIM(0,"Code",code))
	.s arcim=$o(^ARCIM(0,"Code",code,""))
	.s version=$o(^ARCIM(0,"Code",code,arcim,""))
	.s arcimrowid=arcim_"||"_version
	.s ordpriceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimrowid, +$h, "", "", "", "","")
	.s ordprice=$j($p(ordpriceinfo,"^",1),7,6)
	.s price=$j($p(price,"^",1),3,6)
	.s ArcimCode=$p(^ARCIM(arcim,version,1),"^",1)
	.s ArcimDesc=$p(^ARCIM(arcim,version,1),"^",2)
	.i +price'=+ordprice d
	..;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIDRUGPRICE",arcimrowid)="医嘱项价格与药房调价表价格不一致(arc_itmmast,arcim_rowid)"_"^"_price_"^"_ordprice_"^"_(price-ordprice)_"^"_ArcimCode_"^"_ArcimDesc     ;药房价格_"^"_收费项目价格
	..;s obj=##class(User.INCItm).%OpenId(inci)
	..;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	..k PLIST
	..s PLIST(2)="CheckPriceUnityData",PLIST(3)="PriceUnityErr",PLIST(4)="医嘱项价格与药房调价表价格不一致"
	..b ;11
	..s PLIST(5)=arcimrowid,PLIST(6)="",PLIST(7)=inci,PLIST(8)="医嘱项价格:"_+ordprice_" ,药房价格:"_+price
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	q 0
}

/// /................基础数据错误检查..............
/// Creator:yyx
/// CreateDate:2014-08-02
/// Table:dhc_taritem(收费项目基础数据表),dhc_taritemprice(收费项目价格表)
/// Function:计费组收费项目核查
///         基础dhc_taritemprice数据错误检查,开始日期为空，费别为空，医院id为0，数据均为不正常数据
/// input:空
/// output:记录收费项目rowid到global中
/// 此方法增加为后台任务
/// w ##class(web.DHCIPBillCheckDaily).GetTaritemErr()
ClassMethod GetTaritemErr()
{
	s tari="",HospStr="",HospNum=0
	k TMPHOSP
	s StDateStr="",PatTypeStr=""
	f  s tari=$o(^DHCTARI(tari)) q:tari=""  d
	.q:$l(tari,"||")>1
	.s tp="0"
	.f  s tp=$o(^DHCTARI(tari,"P",tp)) q:tp=""  d
	..s StDate=$p(^DHCTARI(tari,"P",tp),"^",3)
	..s HospID=$p(^DHCTARI(tari,"P",tp),"^",16)
	..s PatType=$p(^DHCTARI(tari,"P",tp),"^",13)
	..s TPRowID=tari_"||"_tp
	..s TPCode=$p(^DHCTARI(tari),"^",1)
	..s TPDesc=$p(^DHCTARI(tari),"^",2)
	..q:'((+PatType="0")!(+StDate=0)!(+$g(HospID)="0"))
	..s obj=##class(User.DHCTarItemPrice).%OpenId(TPRowID)
	..s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	..k PLIST
	..s PLIST(2)="CheckPriceData",PLIST(3)="",PLIST(4)=tari,PLIST(5)="",PLIST(6)=jsonStr
	..i +PatType="0" d
	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",1,TPRowID)="费别为空"_"^"_$H_"^"_TPCode_"^"_TPDesc
	...s PLIST(7)="费别为空"
	..i +StDate=0 d
   	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",2,TPRowID)="日期为空"_"^"_$H_"^"_TPCode_"^"_TPDesc
	...s PLIST(7)="开始日期为空"
	..i +$g(HospID)=0 d
   	...;s ^DHCIPBILLCHECKERR("DHCIPBillCheckDaily","TARIPRICE",3,TPRowID)="医院指针为0"_"^"_$H_"^"_TPCode_"^"_TPDesc
	...s PLIST(7)="医院指针为0"
	..s rtn=##class(web.DHCBillCheckBasicData).INSERT()
	
	q
}

}
