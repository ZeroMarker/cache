Import SQLUser

Class web.UDHCJFPRICE Extends BILL.COM.Abstract
{

/// 取指定位数单价的开始日期，主要针对已经上线的项目要修改单价位数
Parameter PriceStartDate = "2010-01-01";

/// Input:  PatType：病人就诊类型，可以为空(PA_Adm表PAADM_Epissubtype_DR->PAC_EpisodeSubType)
/// 		InsType：费别指针，可以为空，为空时按计费组的配置走 
/// 		Arcim：医嘱项指针，不能为空 
/// 		SttDate：计费时间，可以为空，为空时取$h
/// 		Prior：传空（不用） 
/// 		Instr：传空（不用） 
/// 		Linkto：传空（不用）
/// 		OEPrice：自定价金额，自定价医嘱不能空
/// 		HospId：医院指针，多院区时不能为空 
/// 		ExpStr：扩展串，格式：挂号优惠设置^医嘱Id^执行记录Id^就诊Id^医嘱接受科室Id^医嘱项Id^高值条码^库存项Id(预留)^患者Id^就诊类型(挂号时使用)
/// Return：单价_"^"_折扣单价_"^"_记账单价_"^"_自付单价_"^"_错误代码
/// Debug: w ##class(web.UDHCJFPRICE).GetOrderPrice("","4","10808||1",65931,"3","","","","2","^3049||3^^3274^1^^")
ClassMethod GetOrderPrice(PatType As %String, InsType As %String, Arcim As %String, SttDate As %String = "", Prior As %String = "", Instr As %String = "", Linkto As %String = "", OEPrice As %String = "", HospId As %String = "", ExpStr As %String = "") As %String
{
	set ^TMP("GetOrderPrice")=$lb(PatType, InsType, Arcim, SttDate, Prior, Instr, Linkto, OEPrice, HospId, ExpStr)
	set (Price, DiscPrice, InsPrice, PatPrice)=0
	set ErrMsg=""
	
	if (SttDate="") set SttDate=+$h
	set $p(myExpStr,"^",1)=$p(ExpStr,"^",1)
	set $p(myExpStr,"^",2)=$p(ExpStr,"^",2)
	set $p(myExpStr,"^",3)=$p(ExpStr,"^",3)
	set $p(myExpStr,"^",4)=$p(ExpStr,"^",4)
	set $p(myExpStr,"^",5)=$p(ExpStr,"^",5)
	set $p(myExpStr,"^",6)=Arcim
	set $p(myExpStr,"^",7)=$p(ExpStr,"^",7)	      //高值条码
	set $p(myExpStr,"^",9)=$p(ExpStr,"^",9)	      //患者Id
	set $p(myExpStr,"^",10)=$p(ExpStr,"^",10)	  //就诊类型(挂号时使用)
	set $p(myExpStr,"^",11)=$p(ExpStr,"^",8)	  //库存项Id +2023-05-16 ZhYW
	
	set oeitm=$p(ExpStr,"^",2)
	set oeore=$p(ExpStr,"^",3)
	set adm=$p(ExpStr,"^",4)
	
	if (Arcim="") {
		set ErrMsg="ArcimErr"
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
	}
	
	if ((HospId="")&&(adm'="")) set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	if (HospId="") {
		set ErrMsg="HospErr"
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
	}
	
	//2021-07-12 ZhYW 判断医嘱是否已结算，已结算时返回结算的价格
	if (adm'="") {
		set admType=$p(^PAADM(adm),"^",2)
		set itm=$s((admType="I"):oeore,1:oeitm)
		set pboRowId=..GetFstChgPBORowID(itm)
		if (pboRowId'="") {
			set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
			set Price=$p(pboData,"^",7)
			set DiscPrice=$p(pboData,"^",17)
			set InsPrice=$p(pboData,"^",18)
			set PatPrice=$p(pboData,"^",19)
			quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
		}
	}
	
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep="Y") {
		set PriceStr=##class(web.UDHCJFPRICE).GetAppRepOrderPrice(oeitm, SttDate, InsType, PatType, OEPrice, HospId, myExpStr)
		quit PriceStr
	}
	
	set OrdCateType=..GetOrdCateType(Arcim, 0)
	if (OrdCateType="R") {
		set PriceStr=##class(web.UDHCJFPRICE).GetDrugOrderPrice(Arcim, SttDate, InsType, PatType, OEPrice, HospId, myExpStr)
		quit PriceStr
	}
	
	set ExecuDate=""
	while($o(^DHCOLT(0,"ARCIM",Arcim,"Z",ExecuDate))'="") {
		set ExecuDate=$o(^DHCOLT(0,"ARCIM",Arcim,"Z",ExecuDate))
		continue:(ExecuDate>SttDate)
		set OLT=0
		while($o(^DHCOLT(0,"ARCIM",Arcim,"Z",ExecuDate,OLT))'="") {
			set OLT=$o(^DHCOLT(0,"ARCIM",Arcim,"Z",ExecuDate,OLT))
			set OLTData=$g(^DHCOLT(OLT))
			set EndDate=$p(OLTData,"^",5)
			continue:((EndDate'="")&&(EndDate<SttDate))
			set qty0=$p(OLTData,"^",3)
			set Itm=$p(OLTData,"^",2)
			set err=..GetItmPrice(Itm, SttDate, InsType, PatType, OEPrice, HospId, myExpStr)
			set ItmPrice=$p(err,"^",1)
			set ItmDiscPrice=$p(err,"^",2)
			set ItmInsPrice=$p(err,"^",3)
			set ItmPatPrice=$p(err,"^",4)
			set ItmErrMsg=$p(err,"^",5)
			set Price=ItmPrice*qty0+Price
			set DiscPrice=ItmDiscPrice*qty0+DiscPrice
			set InsPrice=ItmInsPrice*qty0+InsPrice
			set PatPrice=ItmPatPrice*qty0+PatPrice
			if (ItmErrMsg'="") set ErrMsg=ItmErrMsg
		}
	}
	
	set Decimal=##class(BILL.Interface.Inside.Invoke).GetFmtSPBill(Arcim, HospId)
	do ..KeepValidDigits(SttDate, .Price, .DiscPrice, .InsPrice, .PatPrice, Decimal)
	
	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
}

/// Input: Itm: 收费项Id
/// 	   StDate：计费时间，可以为空，为空时取$h
/// 	   InsType：费别指针，可以为空，为空时按计费组的配置走
/// 	   PatType：病人就诊类型，可以为空(PA_Adm表PAADM_Epissubtype_DR->PAC_EpisodeSubType)
/// 	   OEPrice：自定价金额，自定价医嘱不能空
/// 	   HospId：医院指针，多院区时不能为空
/// 	   ExpStr：挂号优惠设置^医嘱Id^执行记录Id^就诊Id^接收科室Id^医嘱项Id^高值条码^打包子表Id^患者Id^就诊类型(挂号时使用)^库存项Id
/// Return：单价_"^"_折扣单价_"^"_记账单价_"^"_自付单价_"^"错误代码
/// Debug: w ##class(web.UDHCJFPRICE).GetItmPrice("7997",66519,"11","","","2","2^6821||4^^7488^^")
ClassMethod GetItmPrice(Itm As %String, StDate As %String, InsType As %String, PatType As %String, OEPrice As %String = "", HospId As %String = "", ExpStr As %String = "") As %String
{
	//set ^TMP("GetItmPrice",Itm)=$lb(Itm, StDate, InsType, PatType, OEPrice, HospId, ExpStr)
	set (Price, DiscPrice, InsPrice, PatPrice)=0
	set ErrMsg=""
	
	set RCDRowID=$p(ExpStr,"^",1)    //挂号优惠设置
	set oeitm=$p(ExpStr,"^",2)
	set oeore=$p(ExpStr,"^",3)
	set adm=$p(ExpStr,"^",4)
	set regLoc=$p(ExpStr,"^",5)
	set arcim=$p(ExpStr,"^",6)
	set matBarcode=$p(ExpStr,"^",7)	  //高值条码
	set dspbdr=$p(ExpStr,"^",8)       //打包子表Id
	set patientId=$p(ExpStr,"^",9)    //患者主索引
	set admType=$p(ExpStr,"^",10)     //就诊类型(挂号时使用)
	set inciId=$p(ExpStr,"^",11)      //库存项Id +2023-05-16 ZhYW
	
	if ((+Itm=0)||'$d(^DHCTARI(Itm))) {
		set ErrMsg="ItmErr"_Itm
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
	}
	
	if ((HospId="")&&(adm'="")) set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	if (HospId="") {
		set ErrMsg="HospErr"
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
	}

	if (arcim="") {
		if (oeitm'="") set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
		else  if (oeore'="") set arcim=$p(^OEORD(+oeore,"I",$p(oeore,"||",2),1),"^",2)
	}
	
	if (adm'="") {
		set admType=$p(^PAADM(adm),"^",2)
	}
	set FacAdmType="A"   //就诊类型(急诊、门诊、体检、住院) 默认全部
	if (" E O I H "[(" "_admType_" ")) {
		set FacAdmType=admType
	}

	set Conf=..GetTarParaId(HospId)
	if (+Conf=0) {
		set ErrMsg="ConfErr"
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
	}
	
	if (InsType="") set InsType=$p(^DHCTarC("CF",Conf),"^",3)
	set InsType0=InsType
	//Lid 2014-12-29 临床药理试验修改
	set pilotFlag="N"
	if (oeitm'="") {
		set bbExtCode=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11)),"^",18)	       //OEORI_BBExtCode
		set ordPlilotDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",10)   //存科研项目的指针
		if (ordPlilotDR'="")  set pilotFlag="Y", InsType0=bbExtCode                //科研用药根据医嘱费别取记账系数（注意：医生站开医嘱时一定要修改医嘱的费别，否则不能记账）
	}
	
	//+2019-10-24 TianZJ
	set FixSubRowId=""                         //灵活折扣子表RowId
	set (PkgOrdDRowId, PkgProDRowId)=""        //取订购套餐明细表和优惠券套餐明细表的RowId
	if (admType="I") {
		if (oeore'="") {
			set FixSubRowId=$o(^BILL.PKG.FlexiblediscountSub(0,"OEOREXC",oeore,""))
			set PkgOrdDRowId=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3),"BILL")),"^",23) 
		}
	}else {
		if (oeitm'="") {
			set FixSubRowId=$o(^BILL.PKG.FlexiblediscountSub(0,"OEORD",oeitm,""))
			set PkgOrdDRowId=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"BILL")),"^",15)
			set PkgProDRowId=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"BILL")),"^",17)
		}
	}
	//+2019-11-12 TianZJ 订购类套餐需要取当时订购时的价格，因此修改日期
	if (PkgOrdDRowId'="") {
		set PkgBillDr=$p($g(^BILL.PKG.PatPackage(+PkgOrdDRowId)),"^",1)
		if (PkgBillDr'="") {
			set StDate=$p($g(^BILL.PKG.PatientBill(PkgBillDr)),"^",6)
		}
	}
	
	if (StDate="") set StDate=+$h
	
	//判断是否走批次价
	set batchItm=..IsBatPrice(arcim, HospId, StDate)

	set DiscRate=0, PayorRate=0
	set ItmDiscRateFlag="N", ItmPayorRateFlag="N"
	set DefaultFlag=0

	if (OEPrice'="") {
		set Price=OEPrice
	}elseif (batchItm="Y") {
		set Price=..GetPriceByBatch(Itm, StDate, HospId, ExpStr)
		if (Price<0) {
			set ErrMsg="BatchPriceErr"_Itm
		}
	}else {
		//根据医院和传入费别取价格
		set tp=..GetItmPriceIdByHospInsType(Itm, InsType, StDate, HospId)
		if (tp="") {
			//根据医院和传入费别取不到价格时，根据医院和默认费别取价格取
			set DefaultFlag=1
			set DefInsType=$p(^DHCTarC("CF",Conf),"^",3)
			set tp=..GetItmPriceIdByHospInsType(Itm, DefInsType, StDate, HospId)
		}
		/*
		//按医院取不到价格时，根据传入费别取
		if (tp="") {
			set DefaultFlag=0
			set tp=..GetItmPriceIdByInsType(Itm, InsType, StDate)
		}
		//按费别取不到时，根据默认费别取
		if (tp="") {
			set DefaultFlag=1
			set DefInsType=$p(^DHCTarC("CF",Conf),"^",3)
			set tp=..GetItmPriceIdByInsType(Itm, DefInsType, StDate)
		}
		*/
		if (tp="") {
			set ErrMsg="tpErr"_Itm
			quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
		}
		
		set PriceData=$g(^DHCTARI(Itm,"P",tp))
		set STP=..GetSTP(PatType, StDate, HospId)
		set Price=+$case(STP,"P1":$p(PriceData,"^",14),"P2":$p(PriceData,"^",15),:$p(PriceData,"^",5))  //辅助价格1、辅助价格2、标准价格
		
		set DiscRate=+$p(PriceData,"^",12)
		if (DiscRate'=0) set ItmDiscRateFlag="Y"
		set PayorRate=+$p(PriceData,"^",7)
		if (PayorRate'=0) set ItmPayorRateFlag="Y"
	}
	
	//取儿童加收价格 优先取加收价格 若价格为空则取加收比例 2020-07-28
	set CldAdm=adm                    //2021-08-16 ZhYW 根据医嘱取就诊(规避母婴账单合并时，年龄按母亲计算的错误)
	set DiscPerc="", ExtOrgCode=""    //+2022-10-10 ZhYW 获取第三方系统插入的医嘱的折扣率
	if (oeitm'="") {
		set CldAdm=$p(^OEORD(+oeitm),"^",1)
		set DiscPerc=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),8)),"^",2)	       //OE_OrdItem.OEORI_DiscountPerc
		set ExtOrgCode=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",40)    //OE_OrdItemExt.OEORI_ExtOrgCode
	}elseif (oeore'="") {
		set CldAdm=$p(^OEORD(+oeore),"^",1)
		set DiscPerc=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),8)),"^",2)	       //OE_OrdItem.OEORI_DiscountPerc
		set ExtOrgCode=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"DHC")),"^",40)    //OE_OrdItemExt.OEORI_ExtOrgCode
	}
	/*
	set CldPatientId=$s((+CldAdm'=0):$p($g(^PAADM(CldAdm)),"^",1),1:patientId)
	if (CldPatientId'="") {
		set ExtRateRule=..GetChildExtraRate(CldPatientId, Itm, StDate, HospId)
		set ExtRate=$p(ExtRateRule,"^",1)
		set ExtPrice=$p(ExtRateRule,"^",2)
		set Price=$s((+ExtPrice'=0):(Price+ExtPrice),1:(Price+(Price*ExtRate)))
	}
	*/
	//+2023-02-14 ZhYW 价格优惠
	do ..GetItmPriceExtDisc(CldAdm, oeitm, InsType0, arcim, Itm, HospId, StDate, .Price)

	set Cat=$p(^DHCTARI(Itm),"^",4)
	set TarCate=$s((+Cat'=0):$p($g(^DHCTarC("SC",Cat)),"^",3),1:"")  //收费项目大类
	//根据挂号类型取折扣系数
	set ItmRate="^^", CatRate="^^", TarCatRate="^^"
	if (ExtOrgCode'="") {
		//第三方系统插入的医嘱，折扣优先级最高
		set ItmRate=DiscPerc_"^^"
	}else {
		if ((pilotFlag'="Y")&&(RCDRowID'="")) {
			set ItmRate=..GetItmDiscByRCD(Itm, StDate, RCDRowID, Price, FacAdmType, HospId, arcim)
			set CatRate=..GetCatDiscByRCD(Cat, StDate, RCDRowID, Price, FacAdmType, HospId)
			set TarCatRate=..GetTarCatDiscByRCD(TarCate, StDate, RCDRowID, Price, FacAdmType, HospId)
		}
		if ((+$tr(ItmRate,"^")=0)&&(+$tr(CatRate,"^")=0)&&(+$tr(TarCatRate,"^")=0)) {
			set ItmRate=..GetItmDisc(Itm, StDate, InsType0, Price, FacAdmType, HospId, arcim)
			set CatRate=..GetCatDisc(Cat, StDate, InsType0, Price, FacAdmType, HospId)
			set TarCatRate=..GetTarCatDisc(TarCate, StDate, InsType0, Price, FacAdmType, HospId)
		}
	}
	
	set DiscFlag=$p(^DHCTarC("CF",Conf),"^",4)
	if (DiscFlag="P") {
		//Discount Rate
		if ((DefaultFlag=1) || ((DefaultFlag=0)&&(ItmDiscRateFlag="N"))) {
			set DiscRate=$p(ItmRate,"^",1)
			if (DiscRate="") set DiscRate=$p(CatRate,"^",1)
			if (DiscRate="") set DiscRate=$p(TarCatRate,"^",1)
			;
			set LimitedPrice=$p(ItmRate,"^",3)
			if (+LimitedPrice=0) set LimitedPrice=$p(CatRate,"^",3)
			if (+LimitedPrice=0) set LimitedPrice=$p(TarCatRate,"^",3)
		}
		//Payor Rate
		if ((DefaultFlag=1) || ((DefaultFlag=0)&&(ItmPayorRateFlag="N"))) {
			set PayorRate=$p(ItmRate,"^",2)
			if (PayorRate="") set PayorRate=$p(CatRate,"^",2)
			if (PayorRate="") set PayorRate=$p(TarCatRate,"^",2)
			;
			set LimitedPrice=$p(ItmRate,"^",3)
			if (+LimitedPrice=0) set LimitedPrice=$p(CatRate,"^",3)
			if (+LimitedPrice=0) set LimitedPrice=$p(TarCatRate,"^",3)
		}
	}else {
		if (DefaultFlag=1) {
			set DiscRate=0
			set PayorRate=0
		}
	}
	
	set SpecialFlag=$p(^DHCTARI(Itm),"^",17)
	if (SpecialFlag="Y") {
		set PayorRate=0
		set DiscRate=0
	}

	set DiscPrice=Price*DiscRate
	if ((+LimitedPrice'=0)&&((Price-DiscPrice)>LimitedPrice)) {
		set InsPrice=+LimitedPrice*PayorRate
	}else {
		set InsPrice=(Price-DiscPrice)*PayorRate
	}
	set PatPrice=(Price-DiscPrice)-InsPrice
	
	//取灵活折扣价格
 	if ((batchItm'="Y")&&(FixSubRowId'="")) {
		set FixSubPriceStr=..GetFixSubPrice(FixSubRowId, Itm, StDate, Price, DiscPrice, InsPrice, PatPrice)
		set Price=$p(FixSubPriceStr,"^",1)
		set DiscPrice=$p(FixSubPriceStr,"^",2)
		set InsPrice=$p(FixSubPriceStr,"^",3)
		set PatPrice=$p(FixSubPriceStr,"^",4)
	}
	
	//取订购套餐和优惠券价格
	if ((batchItm'="Y")&&((PkgOrdDRowId'="")||(PkgProDRowId'=""))) {
		if (admType="I") {
			set PkgPriceStr=..GetIPPkgPrice(PkgOrdDRowId, PkgProDRowId, Itm, StDate, Price, DiscPrice, InsPrice, PatPrice, oeitm)
		}else {
			set PkgPriceStr=..GetPkgPrice(PkgOrdDRowId, PkgProDRowId, Itm, StDate, Price, DiscPrice, InsPrice, PatPrice, oeitm)
		}
		set Price=$p(PkgPriceStr,"^",1)
		set DiscPrice=$p(PkgPriceStr,"^",2)
		set InsPrice=$p(PkgPriceStr,"^",3)
		set PatPrice=$p(PkgPriceStr,"^",4)
	}
	
	set Decimal=##class(BILL.Interface.Inside.Invoke).GetFmtSPBill(arcim, HospId)
	do ..KeepValidDigits(StDate, .Price, .DiscPrice, .InsPrice, .PatPrice, Decimal)
	
	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice_"^"_ErrMsg
}

/// Creator: Lid
/// CreatDate: 2014-12-29
/// Description: 取批次价
/// Input: 
/// Return: 
/// Other: 
/// Debug: w ##class(web.UDHCJFPRICE).GetPriceByBatch(5815,63964,1,"","",3,"^^^1795^^14073||1")
ClassMethod GetPriceByBatch(Itm As %String, StDate As %String, HospId As %String = "", ExpStr As %String = "")
{
	set Price=0
	set RCDRowID=$p(ExpStr,"^",1)
	set oeitm=$p(ExpStr,"^",2)
	set oeore=$p(ExpStr,"^",3)
	set adm=$p(ExpStr,"^",4)
	set regLoc=$p(ExpStr,"^",5)
	set arcim=$p(ExpStr,"^",6)
	set matBarcode=$p(ExpStr,"^",7)	  //高值条码
	set dspbdr=$p(ExpStr,"^",8)       //发药子表ID
	set inciId=$p(ExpStr,"^",11)      //库存项Id +2023-05-16 ZhYW
	
	if ((HospId="")&&(adm'="")) set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	if (arcim="") {
		if (oeitm'="") set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
		else  if (oeore'="") set arcim=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),1)),"^",2)
	}
	
	set ordCateType=$s((arcim'=""):..GetOrdCateType(arcim, 0), 1:"")
	if (ordCateType="R") {
		if ((oeitm'="")||(oeore'="")) {
			//医嘱审核后按打包子表取价格
			set Price=##class(web.DHCSTINTERFACE).GetBatchSp(dspbdr, StDate)
		}elseif (regLoc'="") {
			set Price=##class(web.DHCSTINTERFACE).GetNotEmptyINCILSp(HospId, arcim, regLoc, matBarcode)
		}elseif (inciId'="") {
			//+2023-05-16 ZhYW 根据库存项取售价
			set Price=##class(web.DHCSTINTERFACE).GetSp(inciId, StDate, "", HospId)
		}else {
			set Price=##class(web.DHCSTINTERFACE).GetIncibLastSp(HospId, arcim)
		}
	}else {
		if (oeore'="") {
			//取医嘱执行记录售价(批次价格使用,住院按执行取价格)
			set DspID=$o(^DHCOEDISQTY(0,"OEORE",oeore,""))	  //取第一条?
			if (DspID'="") {
				set Price=##class(web.DHCSTINTERFACE).GetDspSp(DspID)
			}
		}elseif (oeitm'="") {
			//取配药批次表中第一个批次售价(门诊按医嘱取价格使用)
			set ordRecLoc=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)
			set Price=##class(web.DHCSTINTERFACE).GetDispBatFirstSp(HospId, oeitm, ordRecLoc)
		}elseif (regLoc'="") {
			//获取有库存药品的批次售价(仅仅开医嘱时取价格显示使用，其它业务不要用)
			set Price=##class(web.DHCSTINTERFACE).GetNotEmptyINCILSp(HospId, arcim, regLoc, matBarcode)
		}else {
			//获取当前药品最后一个批次的当前售价(按医院取当前的批次售价)
			set Price=##class(web.DHCSTINTERFACE).GetIncibLastSp(HospId, arcim)
		}
	}

	quit Price
}

/// Debug: w ##class(web.UDHCJFPRICE).GetSTP(6, 63609, 2)
ClassMethod GetSTP(PatType As %String, StDate As %String, HospId As %String) As %String
{
	set Conf=..GetTarParaId(HospId)
	quit:(Conf="") "P0"
	
	if ((+PatType=0)||(+HospId=0)) {
		set STP=$p(^DHCTarC("CF",Conf),"^",1)
		quit STP
	}
	
	set:(StDate="") StDate=+$h
	set StDate0=StDate+1
	
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarEpisode", HospId)
	set ExeDate=$o(^DHCTAREP(0,"EPHOSP",PatType,GroupHospID,StDate0),-1)
	if (ExeDate="") {
		set STP=$p(^DHCTarC("CF",Conf),"^",1)
		quit STP
	}
	set TEPId=$o(^DHCTAREP(0,"EPHOSP",PatType,GroupHospID,ExeDate,""))   //DHC_TarEpisode
	if (TEPId="") {
		set STP=$p(^DHCTarC("CF",Conf),"^",1)
		quit STP
	}
	set EndDate=$p($g(^DHCTAREP(TEPId)),"^",4)
	if ((EndDate'="")&&(EndDate<StDate)) {
		set STP=$p(^DHCTarC("CF",Conf),"^",1)
		quit STP
	}
	
	set STP=$p(^DHCTAREP(TEPId),"^",2)
	
	quit STP
}

/// 根据收费项目大类取折扣记账系数
ClassMethod GetTarCatDisc(TarCat As %String, StDate As %String, InsType As %String, Price As %String, FacAdmType As %String, HospId As %String) As %String
{
	quit:((TarCat="")||(InsType="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""

	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"TARC",InsType,TarCat,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"TARC",InsType,TarCat,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p(tfData,"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set tCate=$p(tfData,"^",2)
	..quit:(tCate'="")
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate

	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

/// get last record whose enddate is blank or is great than  StDate before  StDate
ClassMethod GetCatDisc(Cat As %String, StDate As %String, InsType As %String, Price As %String, FacAdmType As %String, HospId As %String) As %String
{
	quit:((Cat="")||(InsType="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""
	
	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"TARSC",InsType,Cat,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"TARSC",InsType,Cat,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set Itm=$p(tfData,"^",3)
	..quit:(Itm'="")
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p(tfData,"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate
	
	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

ClassMethod GetItmDisc(Itm As %String, StDate As %String, InsType As %String, Price As %String, FacAdmType As %String, HospId As %String, ArcItmID As %String) As %String
{
	quit:((Itm="")||(InsType="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""

	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"TARI",InsType,Itm,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"TARI",InsType,Itm,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p(tfData,"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set tArcItemDR=$p(tfData,"^",17)
	..quit:((tArcItemDR'="")&&(ArcItmID'="")&&(tArcItemDR'=ArcItmID))
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate
	
	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

/// Debug: w ##class(web.UDHCJFPRICE).GetTarCatDiscByRCD(23,64369,56,4)
ClassMethod GetTarCatDiscByRCD(TarCat As %String, StDate As %String, RCDRowID As %String, Price As %String, FacAdmType As %String, HospId As %String) As %String
{
	quit:((TarCat="")||(RCDRowID="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""

	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"RECDICATE",RCDRowID,TarCat,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"RECDICATE",RCDRowID,TarCat,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set Itm=$p(tfData,"^",3)
	..quit:(Itm'="")
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p(tfData,"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set tCate=$p(tfData,"^",2)
	..quit:(tCate'="")
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate
	
	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

/// 根据挂号优惠配置取折扣
/// Debug: w ##class(web.UDHCJFPRICE).GetTarCatDiscByRCD(23,64369,56,4)
ClassMethod GetCatDiscByRCD(Cat As %String, StDate As %String, RCDRowID As %String, Price As %String, FacAdmType As %String, HospId As %String) As %String
{
	quit:((Cat="")||(RCDRowID="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""

	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"RECDISCATE",RCDRowID,Cat,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"RECDISCATE",RCDRowID,Cat,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set Itm=$p(tfData,"^",3)
	..quit:(Itm'="")
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p(tfData,"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate
	
	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

/// 根据挂号优惠配置取折扣
ClassMethod GetItmDiscByRCD(Itm As %String, StDate As %String, RCDRowID As %String, Price As %String, FacAdmType As %String, HospId As %String, ArcItmID As %String) As %String
{
	quit:((Itm="")||(RCDRowID="")) "^^"
	
	if (FacAdmType="") set FacAdmType="A"
	set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_TarFactor", HospId)
	set DiscRate="", PayorRate="", AlterLevel="", AlterPayorRate=""

	set getf=0
	if (StDate="") set StDate=+$h
	set StDate0=StDate+1
	for  set StDate0=$o(^DHCTARF(0,"RECDISTARI",RCDRowID,Itm,StDate0),-1) quit:((StDate0="")||(getf=1))  do
	.set tf=""
	.for  set tf=$o(^DHCTARF(0,"RECDISTARI",RCDRowID,Itm,StDate0,tf),-1) quit:((tf="")||(getf=1))  do
	..set tfData=$g(^DHCTARF(tf))
	..set EndDate=$p(tfData,"^",5)
	..quit:((EndDate'="")&&(EndDate<StDate))
	..set tAdmType=$p($g(tfData),"^",15)
	..if (tAdmType="") set tAdmType="A"
	..quit:((tAdmType'="A")&&(tAdmType'=FacAdmType))
	..set tHospDR=$p(tfData,"^",16)
	..quit:(tHospDR'=GroupHospID)
	..set tArcItemDR=$p(tfData,"^",17)
	..quit:((tArcItemDR'="")&&(ArcItmID'="")&&(tArcItemDR'=ArcItmID))
	..set DiscRate=$p(tfData,"^",6)
	..set PayorRate=$p(tfData,"^",7)
	..set AlterLevel=$p(tfData,"^",8)
	..set AlterPayorRate=$p(tfData,"^",9)
	..set getf=1
	
	//当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
	if ((Price>AlterLevel)&&(+AlterLevel'=0)) do
	.set DiscRate=+AlterPayorRate

	quit DiscRate_"^"_PayorRate_"^"_AlterLevel
}

/// Creator: Lid
/// CreatDate: 2016-05-25
/// Description: 获取预约检查医嘱的价格
/// Input: oeori:医嘱rowid
/// Return: 单价_"^"_折扣单价_"^"_记账单价_"^"_自付单价
/// Other: DHC_AppRepTarItm
/// Debug: w ##class(web.UDHCJFPRICE).GetAppRepOrderPrice("")
ClassMethod GetAppRepOrderPrice(oeitm As %String, sttDate As %String, insType As %String, patType As %String, oePrice As %String, hospId As %String, expStr As %String) As %String
{
	set (price, discPrice, insPrice, patPrice)=0
	set errMsg=""
	
	set adm=$p(^OEORD(+oeitm),"^",1)
	set admType=$p(^PAADM(adm),"^",2)
	set oeore=$p(expStr,"^",3)
	if (hospId="") set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)

	set lastArtiBillStatus=""
	set lastArtiDr=$o(^DHCAPREPTA(0,"OrdItem",oeitm,""),-1)
	if (lastArtiDr'="") set lastArtiBillStatus=$p($g(^DHCAPREPTA(lastArtiDr)),"^",9)
	
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep'="Y") {
		quit price_"^"_discPrice_"^"_insPrice_"^"_patPrice_"^"_errMsg
	}

	set itmDr=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))) {
		set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))
		set artiDr=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))) {
			set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))
			set artiData=$g(^DHCAPREPTA(artiDr))
			set disc=$p(artiData,"^",4)	         //ARTI_Disc
			set itm=$p(artiData,"^",5)	         //ARTI_Tar_Dr
			set qty=$p(artiData,"^",8)	         //ARTI_Qty
			set billStatus=$p(artiData,"^",9)    //ARTI_Billed
			set ordExec=$p(artiData,"^",10)	     //ARTI_OrdExec
			continue:((admType="I")&&(oeore'="")&&(ordExec'="")&&(ordExec'=oeore))    //当时为何注释掉，没明白，先放开待测试
			continue:(" TB B I P "'[(" "_billStatus_" "))
			continue:((lastArtiBillStatus="I")&&(lastArtiBillStatus'=billStatus))
			continue:((lastArtiBillStatus="P")&&(lastArtiBillStatus'=billStatus))
			continue:((lastArtiBillStatus="B")&&(" TB B "'[(" "_billStatus_" ")))
			continue:((lastArtiBillStatus="TB")&&(" TB B "'[(" "_billStatus_" ")))
			set itmPriceExpStr=expStr
			set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, sttDate, insType, patType, oePrice, hospId, itmPriceExpStr)
			set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
			set price=$p(err0,"^",1)*qty+price
			set discPrice=$p(err0,"^",2)*qty+discPrice
			set insPrice=$p(err0,"^",3)*qty+insPrice
			set patPrice=$p(err0,"^",4)*qty+patPrice
		}
	}
	
	set decimal=##class(BILL.Interface.Inside.Invoke).GetFmtSPBill(arcim, hospId)
	do ..KeepValidDigits(sttDate, .price, .discPrice, .insPrice, .patPrice, decimal)
	
	quit price_"^"_discPrice_"^"_insPrice_"^"_patPrice_"^"_errMsg
}

/// Creator: Lid
/// CreatDate: 2016-05-25
/// Description: 判断是否是预约申请单医嘱
/// Input: oeitm: 医嘱rowid
/// Reutrn: Y:是，N:不是
/// Debug: w ##class(web.UDHCJFPRICE).IsAppRepOrder("111||14")
ClassMethod IsAppRepOrder(oeitm As %String) As %String
{
	quit:(oeitm="") "N"
	quit:$d(^DHCAPREPTA(0,"OrdItem",oeitm)) "Y"
	quit "N"
	;
	;quit ##class(web.DHCAPPRepInterFace).CheckIsBase(oeitm)
}

/// Creator: Lid
/// CreateDate: 2017-09-14
/// Description: 获取药品医嘱价格
/// Input: arcim：医嘱项Id, sttDate:开始日期, insType:费别Id, patType:就诊子类Id oePrice:自定义价格 hospId:医院Id expStr:
/// Return: 收费项目售价
/// Other: 
/// Debug: w ##class(web.UDHCJFPRICE).GetDrugOrderPrice("5251||1","66108","1","","","2","^^^^106^^")
ClassMethod GetDrugOrderPrice(arcim As %String, sttDate As %String, insType As %String, patType As %String, oePrice As %String, hospId As %String, expStr As %String) As %String
{
	set (price, discPrice, insPrice, patPrice)=0
	set errMsg=""
	;
	set oeitm=$p(expStr,"^",2)
	set oeore=$p(expStr,"^",3)
	set ItemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	if (oeore'=""){
		;按执行记录取价格
		set sub="OEORE"
		set ordSub=oeore
	}elseif (oeitm'=""){
		;按医嘱取价格
		set sub="OEORI"
		set ordSub=oeitm
	}else {
		;按医嘱项取价格
		set sub="ARCIM"
		set ordSub=""
	}
	
	if (sub="ARCIM") {
		;存在一对多的情况，只取第一条有效的库存项
		set itmFlag=0
		set inciDr=0
		for  set inciDr=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),inciDr)) quit:((inciDr="")||(itmFlag=1))  do
		.set cltDr=0
		.for  set cltDr=$o(^DHCINCTARi("INCI",inciDr,cltDr)) quit:(cltDr="")  do
		..set cltData=$g(^DHCINCTAR(cltDr))
		..set stDate=$p(cltData,"^",4)
		..set endDate=$p(cltData,"^",5)
		..quit:((sttDate<stDate)||((endDate'="")&&(sttDate>endDate)))
		..set itm=$p(cltData,"^",2)
		..set qty0=$p(cltData,"^",3)
		..set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, sttDate, insType, patType, oePrice, hospId, expStr)
		..set price=$p(err,"^",1)*qty0+price
		..set discPrice=$p(err,"^",2)*qty0+discPrice
		..set insPrice=$p(err,"^",3)*qty0+insPrice
		..set patPrice=$p(err,"^",4)*qty0+patPrice
		..set itmFlag=1
	}else {
		set (ordQty, ordTotal, ordDisc, ordIns, ordPat)=0
    	set dspDr=0
		for  set dspDr=$o(^DHCOEDISQTY(0,sub,ordSub,dspDr)) quit:(dspDr="")  do
		.set dspData=$g(^DHCOEDISQTY(dspDr))
		.set myQty=+$p(dspData,"^",11)
		.set ordQty=ordQty+myQty
		.set dspbSub=0
		.for  set dspbSub=$o(^DHCOEDISQTY(dspDr,"I",dspbSub)) quit:(dspbSub="")  do
		..set dspbData=$g(^DHCOEDISQTY(dspDr,"I",dspbSub))
		..quit:(dspbData="")
		..set dspbDr=dspDr_"||"_dspbSub
		..set qty=$p(dspbData,"^",2)	    //DSPB_Qty
		..set inciDr=$p(dspbData,"^",5)     //DSPB_INCI_DR
		..set price=0, discPrice=0, insPrice=0, patPrice=0
		..set cltDr=0
		..for  set cltDr=$o(^DHCINCTARi("INCI",inciDr,cltDr)) quit:(cltDr="")  do
		...set cltData=$g(^DHCINCTAR(cltDr))
		...set stDate=$p(cltData,"^",4)
		...set endDate=$p(cltData,"^",5)
		...quit:((sttDate<stDate)||((endDate'="")&&(sttDate>endDate)))
		...set itm=$p(cltData,"^",2)      //INCTR_Tari_Dr
		...set qty0=$p(cltData,"^",3)
		...set $p(expStr,"^",8)=dspbDr
		...set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, sttDate, insType, patType, oePrice, hospId, expStr)
		...set price=$p(err,"^",1)*qty0+price
		...set discPrice=$p(err,"^",2)*qty0+discPrice
		...set insPrice=$p(err,"^",3)*qty0+insPrice
		...set patPrice=$p(err,"^",4)*qty0+patPrice
		..set ordTotal=price*qty+ordTotal
		..set ordDisc=discPrice*qty+ordDisc
		..set ordIns=insPrice*qty+ordIns
		..set ordPat=patPrice*qty+ordPat
	    
	    if (+ordQty'=0) {
		    set price=ordTotal/ordQty
		    set discPrice=ordDisc/ordQty
		    set insPrice=ordIns/ordQty
		    set patPrice=ordPat/ordQty
		}
	}
	
	set decimal=##class(BILL.Interface.Inside.Invoke).GetFmtSPBill(arcim, hospId)
	do ..KeepValidDigits(sttDate, .price, .discPrice, .insPrice, .patPrice, decimal)

	set priceStr=price_"^"_discPrice_"^"_insPrice_"^"_patPrice_"^"_errMsg

	quit priceStr
}

/// Creator: Lid
/// CreatDate: 2017-09-13
/// Description: 获取医嘱类型
/// Input: oeitm:医嘱rowid或执行记录rowid或医嘱项rowid
/// 	    flag:0:医嘱项Rowid，1：医嘱rowid(默认)，2：执行记录rowid
/// Return: 医嘱类型(R:药品  N:诊疗  L:检验  P:自定价医嘱  X:检查(与医生站的S区别)  M:材料)
/// Debug: w ##class(web.UDHCJFPRICE).GetOrdCateType("57||12")
ClassMethod GetOrdCateType(oeitm As %String, flag As %String = 1) As %String
{
	if (" 1 2 "[(" "_flag_" ")) {
		set arcimRowID=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	}else {
		set arcimRowID=oeitm
	}
	set arcGrp=$p($g(^ARCIM(+arcimRowID,$p(arcimRowID,"||",2),1)),"^",10)    //医嘱子类
	set ordCateType=$p($g(^ARC("IC",arcGrp)),"^",7)                          //医嘱类型
	quit ordCateType
}

/// Creator: TianZJ
/// CreatDate: 2019-09-21
/// Description: 根据灵活折扣医嘱项单价计费收费项目单价
/// Input:  FixSubRowId：灵活折扣字表rowid
/// 		itm:收费项目表rowid
/// 		sttDate:启用日期
/// 		itmPrice:收费项目单价
ClassMethod GetFixSubPrice(FixSubRowId, itm, stDate, Price, DiscPrice, InsPrice, PatPrice)
{
	/*
		规则：
			1.医嘱项与收费项目1:1,则收费项目价格等于医嘱项目价格
			2.医嘱项与收费项目1:n,如果有误差金额，计算到最后一条收费项目上
	*/
	set FBDData=$g(^BILL.PKG.FlexiblediscountSub(FixSubRowId))
	set FBDSArcimId=$p(FBDData,"^",14)
	set FBDSPrice=$p(FBDData,"^",4)
	set FBDSPatPrice=$p(FBDData,"^",6)
	set FBDSDiscPrice=$p(FBDData,"^",5)
	set discFactor=$p(FBDData,"^",11)   ;折扣率
	//取医嘱项和收费项对照关系
	set tmpPLIST="", tmpDiscPriceSum=""
	set num=0
	set execuDate=""
	for  set execuDate=$o(^DHCOLT(0,"ARCIM",FBDSArcimId,"Z",execuDate)) quit:(execuDate="")  do
	.quit:(execuDate>stDate)
	.set olt=0
	.for  set olt=$o(^DHCOLT(0,"ARCIM",FBDSArcimId,"Z",execuDate,olt)) quit:(olt="")  do
	..set oltData=$g(^DHCOLT(olt))
	..set endDate=$p(oltData,"^",5)
	..quit:((endDate'="")&&(endDate<stDate))
	..set qty0=$p(oltData,"^",3)
	..if (qty0'=1) set num=1
	..set myItm=$p(oltData,"^",2)
	..set num=num+1

	//1:1收费项目的折扣金额等于套餐医嘱项的折扣金额
	quit:(num=0) "0^0^0^0"   //没有对照关系
	quit:(num=1) FBDSPrice_"^"_FBDSDiscPrice_"^"_0_"^"_FBDSPatPrice  //1:1的对照关系
	
	set itmPrice=Price
	set patPrice=PatPrice*discFactor
	set discPrice=itmPrice-patPrice
	set insPrice=InsPrice
	
	quit itmPrice_"^"_discPrice_"^"_insPrice_"^"_patPrice
}

/// Creator: TianZJ
/// CreatDate: 2019-09-21
/// Description: 根据医嘱项单价计费收费项目单价
/// Input: PkgOrdDRowId:订单产品明细表RowId, PkgProDRowId:套餐明细表RowId, itm:收费项目表rowid, sttDate:启用日期, itmPrice:收费项目单价
/// Return: 单价^折扣单价^记账单价^自付单价
ClassMethod GetPkgPrice(PkgOrdDRowId, PkgProDRowId, itm, stDate, Price, DiscPrice, InsPrice, PatPrice, OrdItmRowId)
{
	/*
		规则：
			1.医嘱项与收费项目1:1,则收费项目价格等于医嘱项目价格
			2.医嘱项与收费项目1:n,如果有误差金额，计算到最后一条收费项目上
	*/
	set (PkgPrice, PkgDiscPrice, PkgPatPrice)=0
	if (PkgOrdDRowId'="")  do
	.set odSub=$p(PkgOrdDRowId,"||",2)
	.set PkgData=$g(^BILL.PKG.PatPackage(+PkgOrdDRowId,"OD",odSub))
	.set PkgArcimId=$p(PkgData,"^",2)
	.set PkgPrice=$p(PkgData,"^",7)
	.set PkgPatPrice=$p(PkgData,"^",8)
	.set PkgDiscPrice=$p(PkgData,"^",9)
	//优惠券套餐
	if (PkgProDRowId'="")  do
	.set SharePrice=0
	.set odSub=$p(PkgProDRowId,"||",2)
	.set ProData=$g(^BILL.PKG.Product(+PkgProDRowId,"D",odSub))
	.set PkgArcimId=$p(ProData,"^",1)	
	.set PkgPrice=$p(ProData,"^",4)	
	.set PkgPatPrice=$p(ProData,"^",5)
	.set PkgOrdQty=$p(ProData,"^",2)
	.set OrdQty=..GetPkgOrdQty(OrdItmRowId, PkgArcimId)
	.if (OrdQty>PkgOrdQty)  do
	..set ZkPrice=PkgPrice-PkgPatPrice
	..set Total=PkgPrice*OrdQty
	..set ZkTotal=ZkPrice*PkgOrdQty
	..set OrdTotal=Total-ZkTotal
	..set SharePrice=OrdTotal/OrdQty
	.if (SharePrice'=0) do
	..set PkgPatPrice=SharePrice
	.set PkgDiscPrice=PkgPrice-PkgPatPrice
	quit:(+PkgArcimId=0) Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	
	set discFactor=(PkgPatPrice/PkgPrice)    //折扣率
	//取医嘱项和收费项对照关系
	set tmpPLIST="", tmpDiscPriceSum=""
	set num=0
	set execuDate=""
	for  set execuDate=$o(^DHCOLT(0,"ARCIM",PkgArcimId,"Z",execuDate)) quit:(execuDate="")  do
	.quit:(execuDate>stDate)
	.set olt=0
	.for  set olt=$o(^DHCOLT(0,"ARCIM",PkgArcimId,"Z",execuDate,olt)) quit:(olt="")  do
	..set oltData=$g(^DHCOLT(olt))
	..set endDate=$p(oltData,"^",5)
	..quit:((endDate'="")&&(endDate<stDate))
	..set qty0=$p(oltData,"^",3)
	..if (qty0'=1) set num=1
	..set myItm=$p(oltData,"^",2)
	..set num=num+1
	
	//1:1收费项目的折扣金额等于套餐医嘱项的折扣金额
	quit:(num=0) "0^0^0^0"   //没有对照关系
	quit:(num=1) PkgPrice_"^"_PkgDiscPrice_"^"_0_"^"_PkgPatPrice   //1:1的对照关系

	set itmPrice=Price
	set patPrice=PatPrice*discFactor
	set discPrice=itmPrice-patPrice
	set insPrice=InsPrice
	
	quit itmPrice_"^"_discPrice_"^"_insPrice_"^"_patPrice
}

/// Creator: TianZJ
/// CreatDate: 2019-11-15
/// Description: 根据医嘱取医嘱数量
/// Input: oeitm: 医嘱RowId，arcim:医嘱项Dr
/// Return:	医嘱数量
/// Dbrug: w ##class(web.UDHCJFPRICE).GetPkgOrdQty("2602||5","5668||1")
ClassMethod GetPkgOrdQty(oeitm As %String, arcim As %String)
{
	set itemStat=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",13)    //医嘱状态 OEORI_ItemStat_DR
	set statCode=$s((+itemStat'=0):$p($g(^OEC("OSTAT",itemStat)),"^",1),1:"")
	set itemCat=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)         //医嘱子类
	set pkgQty=##class(web.UDHCJFBILL).GetBillQtyO(oeitm, statCode, itemCat, arcim)
	quit pkgQty
}

/// Creator: Lid
/// CreatDate: 2019-10-30
/// Description: 
/// Debug: w ##class(web.UDHCJFPRICE).KeepValidDigits(65316, 1.3333333, 1.333333, 0, 0, 6)
ClassMethod KeepValidDigits(SttDate As %String, Price As %String, DiscPrice As %String, InsPrice As %String, PatPrice As %String, Decimal As %Integer) As %String
{
	if ((+Price'=0)&&(SttDate>$zdh(..#PriceStartDate,3))) {
		set Price=$fn(Price,"",Decimal)
		set DiscPrice=$fn(DiscPrice,"",Decimal)
		set InsPrice=$fn(InsPrice,"",Decimal)
		set PatPrice=$fn(PatPrice,"",Decimal)
		//对于单价小于0.0001的按0.0001计算，如果有折扣或记账单价，则折扣或记账单价按0计算
		//另外，因为目前医保中心基本都是要求4位有效数字，所以此处只考虑到0.0001，不考虑其它的位数的情况，简化算法。
		if (Price<0.0001) {
			set Price=0.0001, DiscPrice=0, InsPrice=0, PatPrice=0.0001
		}
	}
	
	quit 0
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Description: 获取儿童加收
/// Input: PatientId:患者Id, Itm:收费项目Id, CalDate:年龄计算日期, HospId:医院Id
/// Return: rate^LimitPrice 加收比例^加收金额
/// DeBug: w ##class(web.UDHCJFPRICE).GetChildExtraRate(1,7090,65598,2)
ClassMethod GetChildExtraRate(PatientId As %String, Itm As %String, CalDate As %String, HospId As %String) As %String
{
	set $zt="ERROR"
	set rtn="0^0"
	quit:((+PatientId=0)||(+HospId=0)) rtn
	
	set CfgGroupHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraCharge", HospId)
	quit:'$d(^CF.BILL.CFG.CHIEXTCHARGE(0,"Hosp",CfgGroupHospId,"TarItem",Itm)) rtn
	
	set Age=..GetAgeYear(PatientId, CalDate)
	quit:(Age="") rtn
	
	set RuleGroupHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraChargeRule", HospId)
	set RuleId=""
	set Age0=Age+1
	while(($o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Hosp",RuleGroupHospId,"AgeStart",Age0),-1)'="")&&(RuleId="")) {
		set Age0=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Hosp",RuleGroupHospId,"AgeStart",Age0),-1)
		continue:(Age0>Age)
		set RowId=""
		while($o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Hosp",RuleGroupHospId,"AgeStart",Age0,RowId),-1)&&(RuleId="")) {
			set RowId=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Hosp",RuleGroupHospId,"AgeStart",Age0,RowId),-1)
			set RuleData=$g(^CF.BILL.CFG.CHIEXTCHARGERULE(RowId))
			set DateFrom=$p(RuleData,"^",5)
			continue:((DateFrom'="")&&(DateFrom>CalDate))
			set DateTo=$p(RuleData,"^",6)
			quit:((DateTo'="")&&(DateTo<CalDate))
			set AgeTo=$p(RuleData,"^",4)
			continue:((AgeTo'="")&&(AgeTo<Age))
			set RuleId=RowId
		}
	}
	quit:(+RuleId=0) rtn
	
	set CfgId=$o(^CF.BILL.CFG.CHIEXTCHARGE(0,"Hosp",CfgGroupHospId,"TarItem",Itm,"Rule",RuleId,""))
	quit:(+CfgId=0) rtn
	
	set CfgData=$g(^CF.BILL.CFG.CHIEXTCHARGE(CfgId))
	set DateFrom=$p(CfgData,"^",3)
	quit:(DateFrom'="")&&(DateFrom>CalDate) rtn
	set DateTo=$p(CfgData,"^",4)
	quit:((DateTo'="")&&(DateTo<CalDate)) rtn
	
	set Rate=+$p(CfgData,"^",5)
	set Amt=+$p(CfgData,"^",6)
	set rtn=Rate_"^"_Amt
	quit rtn
ERROR
	set $zt=""
	quit "0^0"
}

/// Creator: ZhYW
/// CreatDate: 2020-07-28
/// Description: 根据病人ID和日期获取患者年龄
/// Input: patientId: PA_PatMas.RowId
/// Return:	年龄-岁
/// Debug: w ##class(web.UDHCJFPRICE).GetAgeYear(12614, +$h)
ClassMethod GetAgeYear(patientId As %String, calDate As %String) As %String
{
	quit:(patientId="") ""
	set birthDate=$p($g(^PAPER(patientId,"ALL")),"^",6)
	quit:(birthDate="") ""
	quit:$d(%GetAgeYear($this,patientId,calDate)) %GetAgeYear($this,patientId,calDate)
	set ageStr=$$CalAge^at182(birthDate, calDate, "", "", "")
	set ageY=$p(ageStr,"|",12)
	set ageM=$p(ageStr,"|",13)
	set ageD=$p(ageStr,"|",14)
	set age=ageY + (ageM/12) + (ageD/($SYSTEM.SQL.DAYOFYEAR($SYSTEM.SQL.YEAR(calDate)_"-12-31")))
	set age=$s((age=$SYSTEM.SQL.FLOOR(age)):age, 1:$fn(age,"",4))
	set %GetAgeYear($this,patientId,calDate)=age
	quit age
}

/// Creator: ZhYW
/// CreatDate: 2020-03-20
/// Description: 取计费系统参数配置
/// Input: hospId: CT_Hospital.RowId
/// Return: cfgId: DHC_TarPara.RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetTarParaId(2)
ClassMethod GetTarParaId(hospId As %String) As %String
{
	quit:$d(%GetTarParaId($this,hospId)) %GetTarParaId($this,hospId)
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(hospId)
	set %GetTarParaId($this,hospId)=cfgId
	quit cfgId
}

/// Creator: TianZJ
/// CreatDate: 2019-09-21
/// Description: 根据医嘱项单价计费收费项目单价
/// Input:  PkgOrdDRowId：订单产品明细表RowId
///         PkgProDRowId: 套餐明细表RowId
/// 		itm:收费项目表rowid
/// 		sttDate:启用日期
/// 		itmPrice:收费项目单价
/// Output: 单价^折扣单价^记账单价^自付单价
ClassMethod GetIPPkgPrice(PkgOrdDRowId, PkgProDRowId, itm, stDate, Price, DiscPrice, InsPrice, PatPrice, OrdItmRowId)
{
	/*
		规则：
			1.医嘱项与收费项目1:1,则收费项目价格等于医嘱项目价格
			2.医嘱项与收费项目1:n,如果有误差金额，计算到最后一条收费项目上
	*/
	set (PkgPrice, PkgDiscPrice, PkgPatPrice)=0
	if (PkgOrdDRowId'="")  do
	.set odSub=$p(PkgOrdDRowId,"||",2)
	.set BalRowID=$o(^BIIL.PKG.OrderIPPriceDivide(0,"ORDD",PkgOrdDRowId,""),-1)
	.set PkgArcimId=$p($g(^BILL.PKG.PatPackage(+PkgOrdDRowId,"OD",odSub)),"^",2)
	.//判断医嘱项与收费项的对应关系
	.set ArmiNum=##class(BILL.PKG.BL.OrderIPPriceDivide).CheckOrdItmNum(PkgArcimId, stDate)
	.if (ArmiNum>1) do
	..//1:n  累计住院套餐价格表价格，根据折扣率重新定家价 BILL_PKG.Pkg_OrderIPPriceDivide
	..set PkgPriceStr=##class(BILL.PKG.BL.OrderIPPriceDivide).GetPkgOrdDRPrice(PkgOrdDRowId, stDate, itm)	
	..set PkgPrice=$p(PkgPriceStr,"^",3)
	..set PkgPatPrice=$p(PkgPriceStr,"^",2)
	..set PkgDiscPrice=$p(PkgPriceStr,"^",1)
	.else  do
	..//1:1  直接取住院套餐价格表数据 BILL_PKG.Pkg_OrderIPPriceDivide
	..set IPPriDivData=$g(^BIIL.PKG.OrderIPPriceDivide(BalRowID))
	..set PkgPrice=$p(IPPriDivData,"^",2)
	..set PkgPatPrice=$p(IPPriDivData,"^",3)
	..set PkgDiscPrice=$p(IPPriDivData,"^",4)
	quit:(+PkgArcimId=0) Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice

	set itmPrice=PkgPrice
	set patPrice=PkgPatPrice
	set discPrice=PkgDiscPrice
	set insPrice=InsPrice
	
	quit itmPrice_"^"_discPrice_"^"_insPrice_"^"_patPrice
}

/// Creator: ZhYW
/// CreatDate: 2021-06-24
/// Description: 判断是否是批次价
/// Input: arcim: ARC_ItmMast.RowId, hospId:CT_Hospital.RowId, prDate:价格日期
/// Return: "Y":是，"N":否
/// Debug: w ##class(web.UDHCJFPRICE).IsBatPrice(2)
ClassMethod IsBatPrice(arcim As %String, hospId As %String, prDate As %String) As %String
{
	set batFlag="N"
	quit:(arcim="") batFlag
	quit:$d(%IsBatPrice($this,hospId,arcim,prDate)) %IsBatPrice($this,hospId,arcim,prDate)
	set ordCateType=..GetOrdCateType(arcim, 0)
	if (ordCateType="R") {
		//set medBatFlag=##class(web.DHCSTINTERFACE).GetRpRule(hospId, prDate)       //药品走批次价配置，从8.3开始，药品取价格都走接口
		set batFlag="Y"
		set %IsBatPrice($this,hospId,arcim,prDate)=batFlag
		quit batFlag
	}
	
	set isMatItm=##class(BILL.Interface.Inside.Invoke).IsMatArcim(arcim)
	if (isMatItm=1) {
		set matBatFlag=##class(BILL.Interface.Inside.Invoke).GetBatSpFlag(hospId, arcim, prDate)     //物资材料走批次价配置
		if (matBatFlag=1) {
			set batFlag="Y"
		}
	}
	set %IsBatPrice($this,hospId,arcim,prDate)=batFlag

	quit batFlag
}

/// Creator: ZhYW
/// CreatDate: 2021-07-12
/// Description: 获取门诊医嘱所在的收费RowId
/// Input: oeitm: 门、急诊，体检传OE_OrdItem.RowId， 住院传OE_OrdExec.RowId
/// Return: DHC_PatBillOrder.RowId
/// Other: 返回第一条结算账单的医嘱账单表RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetFstChgPBORowID("3||2")
ClassMethod GetFstChgPBORowID(oeitm As %String) As %String
{
	set pboRowId=""
	quit:(oeitm="") pboRowId
	
	//+2023-03-21 ZhYW 增加医嘱收费状态
	if ($l(oeitm,"||")=3) {
		set node="OEEXC"
		set itmBilled=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",$p(oeitm,"||",3)),"^",6)  //OEORE_Billed
	}else {
		set node="OEORI"
		set itmBilled=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)    //OEORI_Billed
	}
	quit:(itmBilled'="P") pboRowId
	
	set pb=0
	while($o(^DHCPBi(0,node,oeitm,pb))) {
		set pb=$o(^DHCPBi(0,node,oeitm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag'="P")    //过滤未结算账单
		set refundFlag=$p(pbData,"^",17)
		continue:(refundFlag="R")    //过滤负账单
		set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,0))
		set pboRowId=pb_"||"_pbo
		quit
	}
	
	quit pboRowId
}

/// Creator: ZhYW
/// CreatDate: 2022-05-16
/// Description: 获取收费项目价格表RowId
/// Input: tarItm: DHC_TarItem.RowId, insTypeId:PAC_AdmReason.RowId, stDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: DHC_TarItemPrice.RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetItmPriceIdByHospInsType("3||2")
ClassMethod GetItmPriceIdByHospInsType(tarItm As %String, insTypeId As %String, prDate As %String = {+$h}, hospId As %String) As %String
{
	set itmPriceId=""
	quit:(+tarItm=0) itmPriceId
	
	if ($d(%GetItmPriceId($this,hospId))) {
		set defHospId=%GetItmPriceId($this,hospId)
	}else {
		set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospId)
		set %GetItmPriceId($this,hospId)=defHospId
	}
	
	set stDate=prDate+1
	while($o(^DHCTARIi("HospInsType",tarItm,insTypeId,defHospId,stDate),-1)) {
		set stDate=$o(^DHCTARIi("HospInsType",tarItm,insTypeId,defHospId,stDate),-1)
		set tp=""
		while($o(^DHCTARIi("HospInsType",tarItm,insTypeId,defHospId,stDate,tp),-1)) {
			set tp=$o(^DHCTARIi("HospInsType",tarItm,insTypeId,defHospId,stDate,tp),-1)
			set tpData=$g(^DHCTARI(tarItm,"P",tp))
			set tpStDate=$p(tpData,"^",3)
			set tpEndDate=$p(tpData,"^",4)
			continue:((tpStDate'="")&&(tpStDate>prDate))
			continue:((tpEndDate'="")&&(tpEndDate<prDate))
			set itmPriceId=tp
			quit
		}
		quit:(itmPriceId'="")
	}
	
	quit itmPriceId
}

/// Creator: ZhYW
/// CreatDate: 2022-05-16
/// Description: 获取收费项目价格表RowId
/// Input: tarItm: DHC_TarItem.RowId, insTypeId:PAC_AdmReason.RowId, prDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: DHC_TarItemPrice.RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetItmPriceIdByInsType("3||2")
ClassMethod GetItmPriceIdByInsType(tarItm As %String, insTypeId As %String, prDate As %String = {+$h}) As %String
{
	set itmPriceId=""
	quit:(+tarItm=0) itmPriceId
	
	set stDate=prDate+1
	while($o(^DHCTARIi("TARI",tarItm,insTypeId,stDate),-1)) {
		set stDate=$o(^DHCTARIi("TARI",tarItm,insTypeId,stDate),-1)
		set tp=""
		while($o(^DHCTARIi("TARI",tarItm,insTypeId,stDate,tp),-1)) {
			set tp=$o(^DHCTARIi("TARI",tarItm,insTypeId,stDate,tp),-1)
			set tpData=$g(^DHCTARI(tarItm,"P",tp))
			set tpStDate=$p(tpData,"^",3)
			set tpEndDate=$p(tpData,"^",4)
			continue:((tpStDate'="")&&(tpStDate>prDate))
			continue:((tpEndDate'="")&&(tpEndDate<prDate))
			set itmPriceId=tp
			quit
		}
		quit:(itmPriceId'="")
	}
	
	quit itmPriceId
}

/// Creator: ZhYW
/// CreatDate: 2023-02-14
/// Description: 获取收费项目价格表RowId
/// Input: tarItm: DHC_TarItem.RowId, insTypeId:PAC_AdmReason.RowId, prDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: DHC_TarItemPrice.RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetItmPriceExtDisc("3||2")
ClassMethod GetItmPriceExtDisc(adm As %String, oeitm As %String, insTypeId As %String, arcim As %String, tarItm As %String, hospId As %String, prDate As %String = {+$h}, ByRef price) As %String
{
	quit:(+adm=0) 0
	quit:(+tarItm=0) 0
	
	kill priceDiscAry(adm)
	set priceDiscJsonAry=..GetPriceRule(adm, oeitm, insTypeId, arcim, hospId, prDate)
	set iter=priceDiscJsonAry.%GetIterator()
	while iter.%GetNext(.key, .value) {
		set ruleId=value.RuleId
	    set isRepeat=($zcvt(value.RepeatFlag,"U")="YES")
	    set prior=value.Priority
	    set priceDiscAry(adm,isRepeat,prior,ruleId)=""
   	}
	
	//不可叠加的取优先级最高的一个优惠类型
	set prior=$o(priceDiscAry(adm,0,0))
	if (prior>0) {
		set ruleId=$o(priceDiscAry(adm,0,prior,0))
		if (ruleId>0) {
			do ResetPrice
		}
	}
	//可叠加的多个优惠类型
	set prior=0
	while($o(priceDiscAry(adm,1,prior))) {
		set prior=$o(priceDiscAry(adm,1,prior))
		set ruleId=0
		while($o(priceDiscAry(adm,1,prior,ruleId))) {
			set ruleId=$o(priceDiscAry(adm,1,prior,ruleId))
			do ResetPrice
		}
	}
	
	kill priceDiscAry(adm)
	
	quit 0

ResetPrice
	quit:(+ruleId=0)
	set ratePrice=..GetPriceRuleDetInfo(ruleId, tarItm, prDate)
	set disRate=$p(ratePrice,"^",1)
	set disPrice=$p(ratePrice,"^",2)
	set price=$s((+disPrice'=0):(price+disPrice),1:(price+(price*disRate)))
	quit
}

/// Creator: ZhYW
/// CreatDate: 2023-02-14
/// Description: 
/// Input: tarItm: DHC_TarItem.RowId, insTypeId:PAC_AdmReason.RowId, prDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: DHC_TarItemPrice.RowId
/// Debug: w ##class(web.UDHCJFPRICE).GetPriceRule("")
ClassMethod GetPriceRule(adm As %String, oeitm As %String, insTypeId As %String, arcim As %String, hospId As %String, prDate As %String = {+$h}) As %DynamicArray
{
	set jsonAry=##class(%DynamicArray).%New()
	quit:(+adm=0) jsonAry
	
	//按就诊取规则
	if ($d(%PriceDisc($this,adm))) {
		set priceDiscJsonAry=%PriceDisc($this,adm)
	}else {
		set priceDiscJsonAry=..GetPriceRuleByAdm(adm, insTypeId, hospId, prDate)
		set %PriceDisc($this,adm)=priceDiscJsonAry
	}
	do ConcatAry
	
	//按医嘱取规则
	set tmpNode=$s((oeitm'=""):oeitm,1:arcim)
	quit:(tmpNode="") jsonAry
	if ($d(%PriceDisc($this,adm,tmpNode))) {
		set priceDiscJsonAry=%PriceDisc($this,adm,tmpNode)
	}else {
		set priceDiscJsonAry=..GetPriceRuleByOEORI(adm, oeitm, insTypeId, arcim, hospId, prDate)
		set %PriceDisc($this,adm,tmpNode)=priceDiscJsonAry
	}
	do ConcatAry
	
	quit jsonAry

ConcatAry
	set iter=priceDiscJsonAry.%GetIterator()
	while iter.%GetNext(.key, .value) {
		do jsonAry.%Push(value)
   	}
	quit
}

/// Creator: ZhYW
/// CreatDate: 2023-02-14
/// Description: 获取根据就诊配置的优惠类型
/// Input: adm:PA_Adm.RowId, insTypeId:PAC_AdmReason.RowId, prDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFPRICE).GetPriceRuleByAdm("3||2")
ClassMethod GetPriceRuleByAdm(adm As %String, insTypeId As %String, hospId As %String, prDate As %String = {+$h}) As %DynamicArray
{
	set jsonAry=##class(%DynamicArray).%New()
    quit:(+adm=0) jsonAry
    
	set patientId=$p(^PAADM(adm),"^",1)
    set admDate=$p(^PAADM(adm),"^",6)    //就诊日期
	set admDeptDR=$p(^PAADM(adm),"^",4)             //就诊科室
    set admType=$p(^PAADM(adm),"^",2)               //就诊类型
    //set insTypeId=$p(^PAADM(adm,1),"^",7)         //就诊费别
    set sexDR=$p(^PAPER(patientId,"ALL"),"^",7)     //性别
	set patAge=..GetAgeYear(patientId, admDate)     //按就诊计算年龄

    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_COM.PriceRule", hospId)
        
	set ruleType="AdmRule"
	
    set ruleId=0
    while($o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",defHospId,ruleType,ruleId))) {
	    set ruleId=$o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",defHospId,ruleType,ruleId))
	    set ruleData=$g(^CF.BILL.COM.PriceRuleD(ruleId))
	  	set dateFrom=$lg(ruleData,4)
		set dateTo=$lg(ruleData,5)
		continue:((dateFrom'="")&&(dateFrom>prDate))
	 	continue:((dateTo'="")&&(dateTo<prDate))
	 	set effectRuleId=""
	    set pointId=0
	    while($o(^CF.BILL.COM.PriceRuleAPI("IndexRule",ruleId,pointId))) {
		    set pointId=$o(^CF.BILL.COM.PriceRuleAPI("IndexRule",ruleId,pointId))
		    set pointData=$g(^CF.BILL.COM.PriceRuleAPD(pointId))
		    set dateFrom=$lg(pointData,7)
			set dateTo=$lg(pointData,8)
			continue:((dateFrom'="")&&(dateFrom>prDate))
		 	continue:((dateTo'="")&&(dateTo<prDate))
		 	set pointCode=$lg(pointData,3)
		 	set cfgVal=$lg(pointData,5)
		 	if (pointCode="AdmAge") {
			 	//左闭合区间，左边取等
			 	set minAge=+cfgVal
			 	set maxAge=$p(cfgVal,",",2)
			 	continue:(patAge<minAge)
			  	continue:(patAge>=maxAge)
			}
			continue:((pointCode="AdmType")&&(admType'=cfgVal))    //就诊类型
			continue:((pointCode="AdmLoc")&&(admDeptDR'=cfgVal))   //就诊科室
			continue:((pointCode="AdmReason")&&(insTypeId'=cfgVal))  //就诊费别
			continue:((pointCode="Sex")&&(sexDR'=cfgVal))          //性别
			set effectRuleId=ruleId
			quit
		}
		continue:(effectRuleId="")
		set effectRuleData=$g(^CF.BILL.COM.PriceRuleD(effectRuleId))
	    set json={}
	    set json.RuleId=effectRuleId
	    set json.RuleType=ruleType                  //规则类型
	    set json.RuleCode=$lg(effectRuleData,2)     //优惠类型代码
	   	set json.Priority=$lg(effectRuleData,7)     //优先级
	    set json.RepeatFlag=$lg(effectRuleData,8)   //是否叠加
	    do jsonAry.%Push(json)
	}

    quit jsonAry
}

/// Creator: ZhYW
/// CreatDate: 2023-02-14
/// Description: 获取根据医嘱配置的优惠类型
/// Input: adm:PA_Adm.RowId, oeitm:OE_OrdItem.RowId, insTypeId:PAC_AdmReason.RowId, arcim:ARC_ItmMast.RowId, prDate:取价格日期, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFPRICE).GetPriceRuleByOEORI("3||2")
ClassMethod GetPriceRuleByOEORI(adm As %String, oeitm As %String, insTypeId As %String, arcim As %String, hospId As %String, prDate As %String = {+$h}) As %DynamicArray
{
	set jsonAry=##class(%DynamicArray).%New()
    quit:(+adm=0) jsonAry
    
	set patientId=$p(^PAADM(adm),"^",1)
	set (ordDeptDR, recDeptDR)=""
	if (oeitm'="") {
		set ordDeptDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),7)),"^",2)         //开单科室
		set recDeptDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",6)         //接收科室
	    //set insTypeId=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11)),"^",18)     //医嘱费别
	    //set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)               //医嘱项
	}
	set patAge=..GetAgeYear(patientId, prDate)     //按医嘱计算年龄

    set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_COM.PriceRule", hospId)
    
	set ruleType="OrdRule"
	
    set ruleId=0
    while($o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",defHospId,ruleType,ruleId))) {
	    set ruleId=$o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",defHospId,ruleType,ruleId))
	    set ruleData=$g(^CF.BILL.COM.PriceRuleD(ruleId))
	  	set dateFrom=$lg(ruleData,4)
		set dateTo=$lg(ruleData,5)
		continue:((dateFrom'="")&&(dateFrom>prDate))
	 	continue:((dateTo'="")&&(dateTo<prDate))
	 	set effectRuleId=""
	    set pointId=0
	    while($o(^CF.BILL.COM.PriceRuleAPI("IndexRule",ruleId,pointId))) {
		    set pointId=$o(^CF.BILL.COM.PriceRuleAPI("IndexRule",ruleId,pointId))
		    set pointData=$g(^CF.BILL.COM.PriceRuleAPD(pointId))
		    set dateFrom=$lg(pointData,7)
			set dateTo=$lg(pointData,8)
			continue:((dateFrom'="")&&(dateFrom>prDate))
		 	continue:((dateTo'="")&&(dateTo<prDate))
		 	set pointCode=$lg(pointData,3)
		 	set cfgVal=$lg(pointData,5)
		 	if (pointCode="OrdAge") {
			 	//左闭合区间，左边取等
			 	set minAge=+cfgVal
			 	set maxAge=$p(cfgVal,",",2)
			 	continue:(patAge<minAge)
			  	continue:(patAge>=maxAge)
			}
			continue:((pointCode="Loc")&&(ordDeptDR'=cfgVal))           //开单科室
			continue:((pointCode="RecLoc")&&(recDeptDR'=cfgVal))        //接收科室
			continue:((pointCode="OrdAdmReason")&&(insTypeId'=cfgVal))    //医嘱费别
			continue:((pointCode="ArcItm")&&(arcim'=cfgVal))            //医嘱项目
			set effectRuleId=ruleId
			quit
		}
		continue:(effectRuleId="")
		set effectRuleData=$g(^CF.BILL.COM.PriceRuleD(effectRuleId))
	    set json={}
	    set json.RuleId=effectRuleId
	    set json.RuleType=ruleType                  //规则类型
	    set json.RuleCode=$lg(effectRuleData,2)     //优惠类型代码
	   	set json.Priority=$lg(effectRuleData,7)     //优先级
	    set json.RepeatFlag=$lg(effectRuleData,8)   //是否叠加
	    do jsonAry.%Push(json)
	}

    quit jsonAry
}

/// Creator: ZhYW
/// CreateDate: 2023-02-14
/// Descript: 获取优惠项目明细
/// Table: CF_BILL_COM.PriceRuleConItm
/// Input: ruleId:CF_BILL_COM.PriceRule.RowId, tarItm: DHC_TarItem.RowId, prDate:取价格日期
/// Return: rate_"^"_price
/// Debug: w ##class(web.UDHCJFPRICE).GetPriceRuleDetInfo(3, 7997, 66519)
ClassMethod GetPriceRuleDetInfo(ruleId As %String, tarItm As %String, prDate As %String = {+$h}) As %String
{
	quit:((ruleId="")||(tarItm="")) ""
	
    set effectConId=""
	set conId=0
	while($o(^CF.BILL.COM.PriceRuleConItmI("IndexRuleTarItem",ruleId,"Tar",tarItm,conId))) {
		set conId=$o(^CF.BILL.COM.PriceRuleConItmI("IndexRuleTarItem",ruleId,"Tar",tarItm,conId))
		set conData=$g(^CF.BILL.COM.PriceRuleConItmD(conId))
	    set dateFrom=$lg(conData,4)
	    set dateTo=$lg(conData,5)
	    continue:((dateFrom'="")&&(dateFrom>prDate))
	    continue:((dateTo'="")&&(dateTo<prDate))
	    set isAudited=$lg(conData,9)
	    continue:(isAudited'=1)     //过滤审核未通过的记录
	    set effectConId=conId
	    quit
	}
	quit:(effectConId="") ""
	
	set effectConData=$g(^CF.BILL.COM.PriceRuleConItmD(effectConId))
	set rate=$lg(conData,6)
	set price=$lg(conData,7)
    quit rate_"^"_price
}

}
