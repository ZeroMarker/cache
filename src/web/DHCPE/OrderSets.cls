/// web.DHCPE.OrderSets
/// create by zhongricheng
/// 体检医嘱套
Class web.DHCPE.OrderSets Extends %RegisteredObject
{

/// 医嘱套是否有早餐  入参是医嘱ID
/// w ##class(web.DHCPE.OrderSets).OutOrdSetsDeitFlag("Y^1782")
ClassMethod OutOrdSetsDeitFlag(InString As %Library.String = "") As %String
{
	s Flag=$p($g(InString),"^",1)
	s RowId=$p($g(InString),"^",2)
	q:RowId="" "没有选择套餐"
	s:Flag="" ^DHCPESetting("DHCPEBaseData","PEARCOS",RowId)="N"
    s:Flag'="" ^DHCPESetting("DHCPEBaseData","PEARCOS",RowId)=Flag
    q 0
}

/// 医嘱套等级选择  复选框
/// d ##class(web.DHCPE.OrderSets).OutOrdSetsVIPID("88","2")
ClassMethod OutOrdSetsVIPID(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="120"
	s checked=""
	s:DefaultValue="" DefaultValue=..GetDefVIP(1)
	s DefaultValue=$P(DefaultValue,"^",1)
	
    w "<fieldset style='border:1px solid;width:450 px;'>",! 
    w "<legend>套餐等级选择（可多选）</legend>",!
    w "<ul id='OrdSetsVIPID' style='list-style-type:none;height:24px;display:inline;padding-left:20px;'>",!

	s VipId=0
	f  s VipId=$o(^DHCPEVIPLevel("VIP",VipId)) q:VipId=""  d
	.q:"N"=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",4)  // 不使用的过滤
	.q:$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",9)=" "  // 客户VIP中 若体检编码为空则q
	.s:DefaultValue=VipId checked="checked"
	.s:DefaultValue'=VipId checked=""
	.s Value=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",8)
	.q:Value=" "  // 客户VIP中 若套餐代码码为空则q
	.s ID="VipId"_VipId
	.//下拉列表
	.w "<li style='float:left;display:inline;'><input name='OrdSetsVIPList' type='checkbox' value='"_Value_"' id='"_ID_"' "_checked_" /><label for="_ID_">"_$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",2)_"&nbsp;&nbsp;&nbsp;&nbsp;</label></li>",!
	w "</ul>",!
	w "</fieldset>",!
	
	Quit $$$OK
}

/// 医嘱套等级  ShowFlag 1 返回ID 用于传值   0 返回详情 用于页面显示
/// w ##class(web.DHCPE.OrderSets).OutOrdSetsVIPByCode("PESVasderd",1)
ClassMethod OutOrdSetsVIPByCode(Code As %String, ShowFlag As %String) As %String
{
	
	q:Code="" ""
	q:ShowFlag="" ""
	s VipId=0,ret=""
	f  s VipId=$o(^DHCPEVIPLevel("VIP",VipId)) q:VipId=""  d
	.q:"N"=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",4)  // 不使用的过滤
	.s PreCode=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",8)
	.q:Code'[PreCode
	.s Desc=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",2)
	.i ShowFlag=1 d
	..s:ret'="" ret=ret_"^"_VipId
	..s:ret="" ret=VipId
	
	.i ShowFlag=0 d
	..s:ret'="" ret=ret_"^"_Desc
	..s:ret="" ret=Desc
	q ret
}

/// 获取默认客户等级ID及Code ShowFlag 1 返回ID 用于传值   0 返回套餐代码 用于医嘱套默认添加的前缀
/// w ##class(web.DHCPE.OrderSets).GetDefVIP(1)
ClassMethod GetDefVIP(ShowFlag As %String) As %String
{
	q:ShowFlag="" ""
	s VipId=0,ret=""
	f  s VipId=$o(^DHCPEVIPLevel("VIP",VipId)) q:(VipId="")||(ret'="")  d    // 多个默认只返回第一个，若有值则退出
	.q:"N"=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",5)  // Y为默认
	.s PreCode=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",8)
	.s:ShowFlag=1 ret=VipId
	.s:ShowFlag=0 ret=PreCode
	q ret
}

/// 医嘱套条件
/// d ##class(web.DHCPE.OrderSets).OutConditiones("88","")
ClassMethod OutConditiones(ContrlWidth As %String = "", DefaultValue As %String = "1") As %String
{
	s:(""=ContrlWidth) ContrlWidth="120"
	s (selected,User,CTLoc,Hosp)=""
	s DefaultValue=$P(DefaultValue,"^",1)
	s:DefaultValue="" selected=" selected"
	s:DefaultValue="1" User=" selected"
	s:DefaultValue="2" CTLoc=" selected"
	s:DefaultValue="3" Hosp=" selected"
	
	//下拉列表
	w "<select name='Conditiones' id='Conditiones' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value='' "_selected_"></option>",!
	w "<option value='1' "_User_">个人</option>",!
	w "<option value='2' "_CTLoc_">科室</option>",!
	//w "<option value='3' "_Hosp_">全院</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 获取检验项目对应的默认标本 调用医生站方法 w ##class(web.DHCDocOrderCommon).GetLabSpec("2521||1")
/// w ##class(web.DHCPE.OrderSets).GetDefLabSpecId("2521||1")
ClassMethod GetDefLabSpecId(ArcimRowId As %String)
{
	q:ArcimRowId=""
	s SpecNames = ##class(web.DHCDocOrderCommon).GetLabSpec(ArcimRowId)
	s SpecNamelen = $l($g(SpecNames),$c(2))
	q:(SpecNamelen=1)||(SpecNamelen="") ""
	s num=0
	for i=1:1:(SpecNamelen-1) {
		s SpecName=$p($g(SpecNames),$c(2),i)
		if $p($g(SpecName),$c(3),5)="Y" {
			s ret=$p($g(SpecName),$c(3),1)
			break
		}
	}
	q:ret="" $p($g(SpecName),$c(3),1)
	q ret
}

/// 获取接收科室和单位
/// w ##class(web.DHCPE.OrderSets).GetItemLocIdAndUOMId("2521||1")
ClassMethod GetItemLocIdAndUOMId(ArcimRowId As %String)
{
	q:ArcimRowId=""
	// 单位
	s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s:ArcimBillUOMRowid="" ArcimBillUOMRowid=63
	
	// 接收科室
	s LocId=""
	s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ArcimRowId)
	s LenR=$L(ReturnMesag,$c(2))
	for J=1:1:LenR{
		s SUStr=$P(ReturnMesag,$c(2),J)
		s SRowID=$P(SUStr,$C(1),1)
		Continue:SRowID=""
		s SDesc=$P(SUStr,$C(1),2)
		s Default=$P(SUStr,$C(1),3)
		s:Default="Y" LocId=SRowID
	}
	s ret=ArcimBillUOMRowid_"^"_LocId
	q ret
}

/// 判断医嘱套中是否存在该医嘱  1 存在   0 不存在
/// w ##class(web.DHCPE.OrderSets).IsHaveItemInOrdSets(4188,"2521||1")
ClassMethod IsHaveItemInOrdSets(ARCOSRowid As %String, ArcimRowId As %String)
{
	q:(ARCOSRowid="")||(ArcimRowId="")
	s flag=0
	s ItmSub=0
	f  s ItmSub = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)) q:ItmSub=""  d
	.s ItmRowId=$p($g(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)), "^", 1)
	.s:ItmRowId=ArcimRowId flag=1
	q flag
}

/// 获取医嘱套明细   flag 为值
/// w ##class(web.DHCPE.OrderSets).GetItemDesc(4188)
ClassMethod GetItemDesc(ARCOSRowid As %String)
{
	q:(ARCOSRowid="")
	s ret=""
	s ItmSub=0
	f  s ItmSub = $o(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)) q:ItmSub=""  d
	.s flag=0
	.s ItmRowId=$p($g(^ARCOS(ARCOSRowid,"DATE",1,"ITM",ItmSub)), "^", 1)
	.s ItemDesc=$p($g(^ARCIM(+ItmRowId,$p(ItmRowId,"||",2),1)),"^",2)
	.s:ItemDesc'="" flag=1
	.s:ret'="" ret=ret_$c(1)_ItemDesc_$c(2)_flag
	.s:ret="" ret=ItemDesc_$c(2)_flag
	q ret
}

/// 医嘱套对应的使用科室维护  flag  1 增加   0 删除
/// w ##class(web.DHCPE.OrderSets).OrdSetsSetLoc("44^1810",1)
ClassMethod OrdSetsSetLoc(InString As %String = "", flag As %String)
{
   q:flag=""
   s LocId=$p($g(InString),"^",1)
   s RowId=$p($g(InString),"^",2)
   s:flag=1 ^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",LocId)=0
   k:flag=0 ^DHCPEDataEx("DHCPEBaseData","PEARCOS",RowId,"LOC",LocId)
   q 0
}

ClassMethod UpdateOrdSetsCode(ARCOSCode As %String, ARCOSRowId)
{
	&SQL(update SQLUser.ARC_OrdSets set ARCOS_Code=:ARCOSCode where ARCOS_RowId1 =:ARCOSRowId )
	q SQLCODE
}

/// 医嘱套对应的使用科室
/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderSets","OrdSetsLocs",1810)
Query OrdSetsLocs(ARCOSRowId As %String) As websys.Query(ROWSPEC = "LocDesc:%String,LocId:%String")
{
}

ClassMethod OrdSetsLocsExecute(ByRef qHandle As %Binary, ARCOSRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LocId=0
    f  s LocId=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",ARCOSRowId,"LOC",LocId)) q:LocId=""  d
    .s LocDesc=$p(^CTLOC(LocId),"^",2)
 	.d SearchOut
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(LocDesc,LocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

/// 获取体检医嘱套 医嘱子类ID 若无体检医嘱套 则获取医嘱套 的医嘱子类ID  返回医嘱子类详情^医嘱子类ID^医嘱大类ID
/// w ##class(web.DHCPE.OrderSets).GetARCItemCatID()
ClassMethod GetARCItemCatID(ARCItemCatID As %String = "")
{
      if ARCItemCatID="" d
      .s ARCItemCatDesc="体检医嘱套"
      .s ARCItemCatID=$o(^ARC("IC",0,"Desc",ARCItemCatDesc,0))
      .i ARCItemCatID="" d
      ..s ARCItemCatDesc="医嘱套"
      ..s ARCItemCatID=$o(^ARC("IC",0,"Desc",ARCItemCatDesc,0))
      else  d
      .s ARCItemCatDesc=$p($g(^ARC("IC",ARCItemCatID)), "^", 2)
      S ARCIOrdCatDR=""
      i ARCItemCatID'="" s ARCIOrdCatDR=$p($g(^ARC("IC",ARCItemCatID)), "^", 8)
      q ARCItemCatDesc_"^"_ARCItemCatID_"^"_ARCIOrdCatDR
}

/// 输出套餐价格
/// w ##class(web.DHCPE.OrderSets).outAmount("1800")
ClassMethod outAmount(ARCOSRowId As %String)
{
   q:ARCOSRowId="" "请选择医嘱套"
 
   s (Index,Amount,Count) = 0
   f  s Index = $o(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)) q:Index=""  d
   .s ARCIMRowId = $p($g(^ARCOS(ARCOSRowId,"DATE",1,"ITM",Index)),"^",1)
   .s UnitPrice = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(ARCIMRowId,"","","","","","","","","")
   .s Amount = Amount + UnitPrice
   .s Count=Count+1
   s ARCOSPrice=##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ARCOSRowId)
   s:ARCOSPrice="" ARCOSPrice=0
   w "<span>&nbsp;&nbsp;总价为：<font size='4' color='brown'>"_Amount_"</font>&nbsp;元，销售金额为：<font size='4' color='red'>"_ARCOSPrice_"</font>&nbsp;元，共&nbsp;<font size='4' color='blue'>"_Count_"</font>&nbsp;个项目</span>"
   w "<input type='hidden' id='ARCOSAmount' value='"_Amount_"'>"
   q $$$OK
}

/// 增加医嘱套的包装价格
/// w ##class(web.DHCPE.OrderSets).UpdateARCOSPrice("1800","2018-01-01","2018-01-01")
ClassMethod UpdateARCOSPrice(ARCOSRowid As %String = "", DateFrom As %String = "", DateTo As %String = "", Price As %String = "", Hospital As %String = "") As %String
{
	q:ARCOSRowid=""
 	s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
    s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
 	q:DateFrom>DateTo "开始时间大于截止时间"
	s DateTo=$replace(DateTo," ","")
	
	if (DateFrom="")&&(DateTo="")&&(Price="") d
	.&sql(DELETE FROM sqluser.ARC_OrdSetPrice WHERE PRICE_ParRef=:ARCOSRowid)
	e  d
	.s Tariff=0
	.f  s Tariff=$o(^ARC("TAR",Tariff)) q:(Tariff="")||($p($g(^ARC("TAR",Tariff)),"^",2)["体检")  d
	.s:Tariff="" Tariff=$o(^ARC("TAR",0))
	.if $o(^ARCOS(ARCOSRowid,"PRICE",0))="" d
	..&sql(INSERT INTO sqluser.ARC_OrdSetPrice (PRICE_ParRef,PRICE_DateFrom,PRICE_DateTo,PRICE_Tariff_DR,PRICE_Price) VALUES (:ARCOSRowid,:DateFrom,:DateTo,:Tariff,:Price))
	.e  d
	..&sql(UPDATE sqluser.ARC_OrdSetPrice SET PRICE_DateFrom=:DateFrom,PRICE_DateTo=:DateTo,PRICE_Tariff_DR=:Tariff,PRICE_Price=:Price WHERE PRICE_ParRef=:ARCOSRowid)
	s rtn=SQLCODE

	q rtn
}

/// 医嘱套价格
/// d ##class(%ResultSet).RunQuery("web.DHCPE.OrderSets","OrdSetsPrice",1804)
Query OrdSetsPrice(ARCOSRowid As %String) As websys.Query(ROWSPEC = "ARCOSRowid:%String,ARCOSDesc:%String,Date:%String,Price:%String")
{
}

ClassMethod OrdSetsPriceExecute(ByRef qHandle As %Binary, ARCOSRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	q:ARCOSRowid="" "请选择医嘱套"
 	s sub=0
    f  s sub=$o(^ARCOS(ARCOSRowid,"PRICE",sub)) q:sub=""  d
    .s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
    .s Date=$p(^ARCOS(ARCOSRowid,"PRICE",sub),"^",2)
    .;s Tariff=$p(^ARCOS(ARCOSRowid,"PRICE",sub),"^",3)
    .s Price=$p(^ARCOS(ARCOSRowid,"PRICE",sub),"^",4)
 	.d SearchOut
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(ARCOSRowid,ARCOSDesc,$zd(Date,3),Price)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

}
