/// Description:全院药房相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-06-30
/// Table:      
Class web.DHCST.ReportForms.AllPharmacyStat Extends (%RegisteredObject, websys.Abstract, PHA.LIB.SYS) [ ClassType = "", ProcedureBlock ]
{

/// 全院发药业务类型
Parameter DispTypeStr [ Final ] = "P^Y^F^H^HC^PH^YH^FH^HH^HHC";

/// 门诊发药业务类型
Parameter OutDispTypeStr [ Final ] = "F^H^HC^FH^HH^HHC";

/// 住院发药业务类型
Parameter InDispTypeStr [ Final ] = "P^Y^PH^YH";

/// 入库业务类型
Parameter RecTypeStr [ Final ] = "G^GC";

/// 退货业务类型
Parameter RetTypeStr [ Final ] = "R^RC";

/// 入库退货业务类型
Parameter RecRetTypeStr [ Final ] = {..#RecTypeStr_"^"_..#RetTypeStr};

/// Description:按类组统计科室发药金额
/// Creator: 	zhaoxinlong
/// CreatDate:	2022-03-08	
/// Input:		inputStr
/// Output:		
/// Debug:		d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","StatDspAmtByGrp","2022-03-01","2022-03-17", 36)
Query StatDspAmtByGrp(startDate As %String, endDate As %String, phLoc As %String, loc As %String = "") As websys.Query(ROWSPEC = "phLocDesc,admlocDesc, stkGrpDesc,spAmt:%Float,rpAmt:%Float") [ SqlProc ]
{
}

ClassMethod StatDspAmtByGrpExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, phLoc As %String, loc As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	q:(phLoc = "")||(startDate = "")||(endDate = "") $$$OK 
	s hospID=$p(^CTLOC(phLoc),"^",22)
	s phLocDesc = $p(^CTLOC(phLoc), "^", 2)
	k ^||TMP("PHA", $classname(), "StatDspAmtByGrp")
	s hospFlag=##class(PHA.FACE.IN.Com).GetHospAut()
	i hospFlag="Y" s hospID=##class(PHA.FACE.IN.Method).GetDefHospIdByTableName("CT_LOC",hospID)
	s typeStr = "F^H^P^Y^FH^HH^PH^YH"
	s startDate = ..%zdh(startDate)
	s endDate = ..%zdh(endDate)
	for date = startDate :1 :endDate {
		for typei = 1 :1 :$l(typeStr, "^")	{
			s type = $p(typeStr, "^", typei)
			s intrID = ""
			for {
				s intrID = $o(^DHCINTR(0,"LOCTYPEDATE", phLoc, type, date, intrID))
				q:(intrID = "")	
				s intrData = ^DHCINTR(intrID)
				s inclb = $p(intrData, "^", 7)
				s inci = +inclb
				s inciObj = ##class(PHA.COM.Data.Drug).%New(inci)
				s stkGrpID = inciObj.StkCatGrpId()
				s baseObj = ##class(PHA.COM.Data.Base).%New()
				s stkType = baseObj.StkCatGrpType(stkGrpID)
				continue:(stkType '= "G")
				s spAmt = -$p(intrData, "^", 8)
				s rpAmt = -$p(intrData, "^", 17)
				s stkGrpDesc = baseObj.StkCatGrpDesc(stkGrpID)
				s pointer = $p(intrData, "^", 9)
				s admLocID = ##class(PHA.IN.STAT.Com).GetAdmLocByTans(pointer, type)
				if (admLocID '= "") { 
					s admlocDesc = $p($g(^CTLOC(admLocID)), "^", 2)
				}else {
					s admlocDesc = ""
				}
				continue:(loc '= "")&&(loc '= admLocID)
				s index = admLocID _","_ stkGrpID
				if '$d(^||TMP("PHA", $classname(), "StatDspAmtByGrp", index)){
					s ^||TMP("PHA", $classname(), "StatDspAmtByGrp", index) = $lb(phLocDesc , admlocDesc , stkGrpDesc , spAmt , rpAmt)
				}else {
					s data = ^||TMP("PHA", $classname(), "StatDspAmtByGrp", index)
					s $list(data, 4) = $list(data, 4) + spAmt
					s $list(data, 5) = $list(data, 5) + rpAmt
					s ^||TMP("PHA", $classname(), "StatDspAmtByGrp", index) = data 
				}
			}
		}	
	}
	s index = ""
	for {
		s index = $o(^||TMP("PHA", $classname(), "StatDspAmtByGrp", index))	
		q:(index = "")
		set ^CacheTemp(repid,ind)= ^||TMP("PHA", $classname(), "StatDspAmtByGrp", index)
		set ind=ind+1
	}
	k ^||TMP("PHA", $classname(), "StatDspAmtByGrp")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:按照科室统计国基省基销售金额和占比
/// Creator: 	power
/// CreatDate:	2018-07-18
/// Table:		
/// Input:		startDate(开始时间),endDate(结束时间)
/// Output:		销售金额、销售金额占比、国基金额、国基金额占国基总金额比例、省基金额、省基金额占省基总金额比例
/// Return:		返回值
/// Others:		其他补充
/// Debug:		d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetDrugSaleRatioByLoc","2019-02-01","2019-02-15")
Query GetDrugSaleRatioByLoc(startDate As %String = "", endDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "docloc:%String,spAmt:%Float,spAmtRatio:%Float,countrySpAmt:%Float,countrySpAmtRatio:%Float,provinceSpAmt:%Float,provinceSpAmtRatio:%Float") [ SqlProc ]
{
}

ClassMethod GetDrugSaleRatioByLocExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", HOSPID As %String = "") As %Status
{
	s startDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(startDate)
	s endDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(endDate)
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s pid=..NewPid()
    d ..ClearTmp("GetDrugSaleRatioByLoc",pid)
    s (spAmtSum,countrySpAmtSum,provinceSpAmtSum)=0
    s typeStr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
    s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.f date=startDate:1:endDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s pointer=$p(^DHCINTR(intr),"^",9)  //pointer
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s ord=+oeori,chl=$P(oeori,"||",2)
	...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",chl))
	...s ordept=$p(^OEORD(ord,"I",chl,7),"^",2)
	...s docloc=$p(^CTLOC(ordept),"^",2)
	...s (spAmt,countrySpAmt,provinceSpAmt)=0
	...s spAmt=-$p(^DHCINTR(intr),"^",8)
	...s spAmtSum=spAmtSum+spAmt
	...s inci=+inclb
	...s (countryFlag,provinceFlag)=""	//国基本药物,省基本药物
	...s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	...//s:(info'="")&&($d(^DHCITMINFO(info))) countryFlag=$p(^DHCITMINFO(info),"^",4)
	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s countryFlag = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",31) //国家基本药物标志
	...s:countryFlag="Y" countrySpAmt=spAmt
	...s countrySpAmtSum=countrySpAmtSum+countrySpAmt
    ...//s:(info'="")&&($d(^DHCITMINFO(info))) provinceFlag=$p(^DHCITMINFO(info),"^",40)
	...s provinceFlag = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",32) //省基本药物标志
	...s:provinceFlag="Y" provinceSpAmt=spAmt
	...s provinceSpAmtSum=provinceSpAmtSum+provinceSpAmt
	...s intrData=docloc_"^"_spAmt_"^"_countrySpAmt_"^"_provinceSpAmt
	...s indextotal=ordept
	...i '$d(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal)) d
	....s ^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal)=intrData
	...e  d
	....s $p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",2)=$p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",2)+spAmt
	....s $p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",3)=$p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",3)+countrySpAmt
	....s $p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",4)=$p(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,indextotal),"^",4)+provinceSpAmt
	...
	..
	.
	s ^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,"-1")="合计"_"^"_spAmtSum_"^"_countrySpAmtSum_"^"_provinceSpAmtSum
	s h=""
	f  s h=$o(^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,h),-1) q:h=""  d
	.s data=^TMP("DHCST",$this,"GetDrugSaleRatioByLoc",pid,h)
	.s docloc=$p(data,"^",1)
	.s spAmt=+$p(data,"^",2)
	.q:spAmt=0
	.s spAmtRatio=0
	.s:+spAmtSum'=0 spAmtRatio=$fn((spAmt/spAmtSum),"",4)
	.s countrySpAmt=+$p(data,"^",3)
	.s countrySpAmtRatio=0
	.s:+countrySpAmtSum'=0 countrySpAmtRatio=$fn((countrySpAmt/spAmtSum),"",4)
	.s provinceSpAmt=+$p(data,"^",4)
	.s provinceSpAmtRatio=0
	.s:+provinceSpAmtSum'=0 provinceSpAmtRatio=$fn((provinceSpAmt/spAmtSum),"",4)
	.s data=$lb(docloc,$fn(spAmt,"",4),spAmtRatio,$fn(countrySpAmt,"",4),countrySpAmtRatio,$fn(provinceSpAmt,"",4),provinceSpAmtRatio)
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	d ..ClearTmp("GetDrugSaleRatioByLoc",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 返回值：姓名，处方数，付数
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryGZYDISP","2023-02-15","2023-03-13","")
Query QueryGZYDISP(CDateSt As %String = "", CDateEnd As %String = "", inoutflag As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "patname:%String,patno:%String,itmdesc:%String,js:%String,jl:%String,orddate:%String,orderqty:%String,orddoseqty:%String") [ SqlProc ]
{
}

ClassMethod QueryGZYDISPExecute(ByRef QHandle As %Binary, CDateSt As %Library.String = "", CDateEnd As %Library.String = "", inoutflag = "", HOSPID As %String = "") As %Status
{
	s CDateSt=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(CDateSt)
	s CDateEnd=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(CDateEnd)
	s inoutflag=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(inoutflag)
 	Set repid=$I(^CacheTemp)
	Set QHandle=$lb(0,repid,0)
	Set ind=1
	q:(CDateSt="")||(CDateEnd="") $$$OK

	s pid=..NewPid()
	d ..ClearTmp("QueryGZYDISP",pid)
	//s ^hlh($h)=$lb(CDateSt,CDateEnd,inoutflag)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s endate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s typestr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	s:inoutflag="O" typestr="F^H^HC^FH^HH^HHC"
	s:inoutflag="I" typestr="P^Y^PH^YH^YC^YHC"
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s inci=+inclb
	...s tmploc=$P(^INCI(inci,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s stkcode=$p(StkGrpInfo,"^",5)
	...q:stkcode'="5"
	...s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	...s gzflag=""
	...s:(info'="")&($d(^DHCITMINFO(info))) gzflag=$p(^DHCITMINFO(info),"^",12)
	...q:gzflag'="Y"
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...i ('$d(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori))) d
	....s ^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori)=$lb(inci, qty)
	...e  d
	....s $LIST(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori), 2)=qty + $LIST(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori),2)

	s oeori=""
	f  s oeori=$o(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori)) q:(oeori="")  d
	.s qty=$lg(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori), 2)
	.// 数量大于0表示退药且发药时间没在统计的时间范围内，等于0表示发药并退药，这两种情况都需要过滤
	.q:(qty>=0)			
	.s inci=$lg(^||TMP("DHCST", $classname(), "QueryGZYDISP", pid, "OEORI", oeori), 1)
	.s ord=$p($g(oeori),"||",1)
    .s chl=$p($g(oeori),"||",2)
    .s adm=$p(^OEORD(ord),"^",1) 
    .s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
	.s patname=$p(^PAPER(patnameid,"ALL"),"^",1)
	.s patno=$p(^PAPER(patnameid,"PAT",1),"^",1)
	.s itmdesc=##class(PHA.COM.Data.Base).InciDesc(inci)
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.s BUom=##class(PHA.COM.Data.Base).UomDesc(BUomId)
	.s orderqty=$p(^OEORD(ord,"I",chl,1),"^",12)      //总剂量=单次剂量*剂数
	.s orderqty=orderqty_BUom
	.s orddoseqty=$p(^OEORD(ord,"I",chl,2),"^",1)   //单次剂量
	.s orddoseqty=orddoseqty_BUom
	.s prescno=$P(^OEORD(ord,"I",chl,1),"^",14)
	.s queid=+$o(^PAQUE1(0,"PrescNo",prescno,""), -1)
	.s durdr=$p($g(^PAQUE1(queid,"DHC")),"^",10)
	.s js=$p($g(^PHCDU(+durdr)),"^",2) ;剂数
    .s jl=$p($g(^PAQUE1(queid,"DHC")),"^",13) ;用量
	.s orddate=$p(^OEORD(ord,"I",chl,3),"^",7) 
	.s:orddate'="" orddate=$zd(orddate,3)
	.d OutputRow

	d ..ClearTmp("QueryGZYDISP",pid)
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK	 

OutputRow
	set Data=$lb(patname,patno,itmdesc,js,jl,orddate,orderqty,orddoseqty)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

/// Description: 按药理统计(query命名有问题)
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","StatByDrugByDrgForm","2019-08-01","2019-8-18")
Query StatByDrugByDrgForm(start = "", end = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "ordCatDesc,phccCode,phccCode1,phccDesc,amount:%Numeric,percentage") [ SqlProc ]
{
}

ClassMethod StatByDrugByDrgFormExecute(ByRef qHandle As %Binary, start = "", end = "", HOSPID As %String = "") As %Status
{
	s start=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(start)
	s end=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(end)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0) 
	q:(start="")!(end="") $$$OK
	s startDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(start)
	s endDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(end)
	s pid=..NewPid()
	d ..ClearTmp("StatByDrugByDrgForm",pid)
	s TotalMoney=0
	f idate=startDate:1:endDate d
	.s typeStr = "P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	.s typel = $l(typeStr,"^") //type长度
	.f itype=1:1:typel d
	..s intrRowId="" 
	..f  s intrRowId=$o(^DHCINTR(0, "TypeDate", $p(typeStr,"^",itype), idate, intrRowId))  q:intrRowId=""  d
	...s dhcIntrData = ^DHCINTR(intrRowId) //获取一条台帐信息
	
	...s inclb=$p(dhcIntrData,"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	
	...s amount =(-1)*(+$p(dhcIntrData,"^",8)) //售价金额
	...s inciDr = $p(dhcIntrData,"^",15) //获取库存项id，
	...s incscDr = $p(^INCI(inciDr,2),"^",2)
	...s incscDesc = $p(^INC("SC",incscDr),"^",3)
	...q:incscDesc'="G"
	...s arcimDr = $p(^INCI(inciDr,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s orcatDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",10)  //医嘱子分类
	...s ordCatDr= $p(^ARC("IC",orcatDr),"^",8)
	...s ordCatDesc = $p(^OEC("ORCAT",ordCatDr),"^",2)  //医嘱大类
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s geneDr=$p(^PHCD(+phcdfDr,4),"^",1)
	...q:geneDr=""
	...s chemDr=$p(^PHCGE("GE",geneDr,"DHC"),"^",3)
	...q:chemDr=""
	...s phccDr=$p(^PHCGE("GE",geneDr,"DHC"),"^",5)
	...q:phccDr=""
	...q:'$d(^DHCPHCC(phccDr))
	...s phccCode = $p(^DHCPHCC(phccDr),"^",1)  //药学code
	...s phccDesc = $p(^DHCPHCC(phccDr),"^",2) //药学分类详细
	...s phccLevel = $p(^DHCPHCC(phccDr),"^",4) // 等级
	...s phccParCatDr =  $p(^DHCPHCC(phccDr),"^",3) //父药学分类
	...f x=1:1:phccLevel d
	.... s phccDesc="..."_phccDesc
	...s phccstr=..GenePHCCatIdAll(phccDr,"")
	...s TotalMoney=TotalMoney+amount
	...s tmpCatDr=0
	...s tmpCatDr=$j(tmpCatDr,10)
	...i $g(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,tmpCatDr))="" d
	....s ^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,tmpCatDr)=amount_"^"_""_"^"_ordCatDesc     //统计大类金额
	...e  d
	....s $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,tmpCatDr),"^",1)=+$p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,tmpCatDr),"^",1)+amount
	...i $g(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr))="" d
	....s ^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr)=amount_"^"_phccCode_"^"_phccDesc
	...e  d
	....s $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr),"^",1)=$p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr),"^",1)+amount
	...f g=1:1:(phccLevel-1) d
	....q:$g(^DHCPHCC(phccDr))=""
	....s phccDr =  $p(^DHCPHCC(phccDr),"^",3) //父药学分类
	....q:$g(^DHCPHCC(phccDr))=""
	....s phccCode = $p(^DHCPHCC(phccDr),"^",1)  //药学code
	....s phccDesc = $p(^DHCPHCC(phccDr),"^",2) //药学分类详细
	....s phccLevelP = $p(^DHCPHCC(phccDr),"^",4) // 等级
	....f k=1:1:phccLevelP d
	..... s phccDesc="..."_phccDesc
	....s phccstr=..GenePHCCatIdAll(phccDr,"")
	....i $g(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr))="" d
	.....s ^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr)=amount_"^"_phccCode_"^"_phccDesc
	....e  d
	.....s $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr),"^",1)=+$p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDr,phccstr),"^",1)+amount
	....
	...
	..
	.	
	i TotalMoney=0 q $$$OK
	s ordCatDesc="" 
	f  s ordCatDesc=$o(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDesc)) q:ordCatDesc=""  d
	.s phccstr="" 
	.f  s phccstr=$o(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDesc,phccstr)) q:phccstr=""  d 
	..s amount = $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDesc,phccstr),"^",1)
	..q:amount=0    ;为0的不要
	..i (amount<1)&&($p(amount,".",1)="") s amount=0_amount
	..s phccCode1 = $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDesc,phccstr),"^",2)
	..s phccDesc = $p(^TEMP("DHCST",$this,"StatByDrugByDrgForm",pid,ordCatDesc,phccstr),"^",3)
	..s percentage=$fn(amount/TotalMoney*100,"",2)_"%"
	..d outputrow
	d ..ClearTmp("StatByDrugByDrgForm",pid)
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data = $lb(ordCatDesc,phccCode,phccCode1,phccDesc,amount,percentage)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","StatByDrugByDrgCat","2019-08-01","2019-8-18")
Query StatByDrugByDrgCat(start = "", end = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "phcfDesc,ordCatDesc,rpAmount:%Numeric,amount:%Numeric") [ SqlProc ]
{
}

ClassMethod StatByDrugByDrgCatExecute(ByRef qHandle As %Binary, start = "", end = "", HOSPID As %String = "") As %Status
{
	s start=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(start)
	s end=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(end)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)														
	q:(start="")!(end="") $$$OK 
	s startDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(start)
	s endDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(end)               
	s pid=..NewPid()
	d ..ClearTmp("StatByDrugByDrgCat",pid)
	f idate=startDate:1:endDate d
	.s typeStr = "P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	.s typel = $l(typeStr,"^") //type长度
	.f itype=1:1:typel d
	..s intrRowId="" 
	..f  s intrRowId=$o(^DHCINTR(0, "TypeDate", $p(typeStr,"^",itype), idate, intrRowId))  q:intrRowId=""  d
	...s dhcIntrData = ^DHCINTR(intrRowId) //获取一条台帐信息
	...s amount = 0-+$p(dhcIntrData,"^",8) //售价金额
	...s rpAmount= 0-+$p(dhcIntrData,"^",17)   //进价金额
	...s inclb= $p(dhcIntrData,"^",7)
	...s loc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...s tmphos=$P(^CTLOC(loc),"^",22)
	...q:(HOSPID'="")&&(HOSPID'=tmphos)
	...s inciDr = $p(dhcIntrData,"^",15) //获取库存项id，
	...s incscDr = $p(^INCI(inciDr,2),"^",2)
	...s incscDesc = $p(^INC("SC",incscDr),"^",3)
	...q:incscDesc'="G"
	...s arcimDr = $p(^INCI(inciDr,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s orcatDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",10)  //医嘱子分类
	...s ordCatDr= $p(^ARC("IC",orcatDr),"^",8)
	...s ordCatDesc = $p(^OEC("ORCAT",ordCatDr),"^",2)  //医嘱大类
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...q:'$d(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),1))
	...s phcfDr = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),1),"^",1)  //药学项子表中，药学剂型dr
	...q:phcfDr=""
	...//S GeneDr=$P(^PHCD(+phcdfDr,4),"^",1)
	...//s phcfDr=$p(^PHCGE("GE",GeneDr,"DHC"),"^",5)   //药学剂型dr
	...//q:phcfDr=""
	...s phcfDesc=$p(^PHCF(phcfDr),"^",2)   //药学剂型dr描述
	
	...i '$D(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc)) d
	....s ^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc)=amount_"^"_rpAmount
	...e  d
	....s $p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",1) = +$p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",1)+ +amount
	....s $p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",2) = +$p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",2)+ +rpAmount
	...
	..
	.
	s phcfDesc="" 
	f  s phcfDesc=$o(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc))  q:phcfDesc=""  d
	.s ordCatDesc="" 
	.f  s ordCatDesc=$o(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc))  q:ordCatDesc=""  d
	..s amount = $p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",1)
	..q:amount=0    ;为0的不要
	..s rpAmount= $p(^TEMP("DHCST",$this,"StatByDrugByDrgCat",pid,phcfDesc,ordCatDesc),"^",2)
	..d outputrow
	d ..ClearTmp("StatByDrugByDrgCat",pid)
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data = $lb(phcfDesc,ordCatDesc,rpAmount,amount)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// Author : MYQ
/// CreatDate :	2017-10-24
/// Description : 全院消耗查询-按照医生科室、处方数汇总
/// 2017-10-01^2017-10-24^^^5^^N^
/// modify by mpf 中药房按剂型统计工作量.20180107
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetPhcformDispStat","2022-06-01^2022-06-17^^^5^^N^^2^N","2")
Query GetPhcformDispStat(input As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "phcform:%String,prescnum:%Integer,prescfacnum:%Integer,presctotalamt:%Float") [ SqlProc ]
{
}

ClassMethod GetPhcformDispStatExecute(ByRef qHandle As %Binary, input As %String = "", HOSPID As %String = "") As %Status
{
	//tro
	//s ^PHATMP("MYQ", $this, "GetPhcformDispStat") = $lb(input, HOSPID)
	s input=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(input)
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1 
    q:input="" $$$OK
    s phalocdr=$p(input,"^",3)
    i phalocdr="" d		//如果没有选择药房科室，则取所有的药房
    .s locstr=""
    .s ctlocdr=""
    .f  s ctlocdr=$o(^CTLOC(0,"LocType","D",ctlocdr)) q:ctlocdr=""  d
    ..i locstr="" d
    ...s locstr=ctlocdr
    ..e  d
    ...s locstr=locstr_","_ctlocdr
    .s $p(input,"^",3)=locstr 
    s stdate=$p(input,"^",1)
	q:stdate="" $$$OK
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s endate=$p(input,"^",2)
	q:endate="" $$$OK
	s endate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endate)
	s typestr="P^F"
	s pid=..NewPid()
	d ..ClearTmp("GetPhcformDispStat",pid)
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(phalocdr)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s parinci=$p(input,"^",4)
	s parfindtyp=$p(input,"^",5)
	s doclocin=$p(input,"^",6) //医生科室
	s basicFlagI=$p(input,"^",7) //基本药物标记
	s iotype=$p(input,"^",8)  //门诊住院标记
	s DMJDrugFlag=$p(input,"^",10)  //毒麻精药品标记
	i iotype="I" s typestr="P"
	e  i iotype="O" s typestr="F"
	s n=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s DrgForminfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm($p(inclb,"||",1))
	...s DrgFormID=$p(DrgForminfo,"^",3)
	...s DrgForm=$p(DrgForminfo,"^",1)
	...s:DrgForm="" DrgForm="未知"
	...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	...q:(phalocdr'="")&&((","_phalocdr_",")'[(","_LocID_","))	//判断药房科室
	...s inci=+inclb
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s catgrptype=$p(StkGrpInfo,"^",3) 
	...q:catgrptype'="G"
	...s catgrpcode=$p(StkGrpInfo,"^",5)
	...q:catgrpcode'="5" 
	...q:(parinci'="")&&(parinci'=inci)
	...s basicflag=""
	...s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	...s:(info'="")&($d(^DHCITMINFO(info))) basicflag=$p(^DHCITMINFO(info),"^",4)
	...q:(basicflag'="")&&(basicFlagI="Y")&&(basicflag'="Y")
	...q:(basicflag'="")&&(basicFlagI="N")&&(basicflag="Y")
	...s poisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
	...s poisonDesc=$p(poisonStr,"^",1)
	...q:(DMJDrugFlag="Y")&&(poisonDesc'["毒")&&(poisonDesc'["麻醉")&&(poisonDesc'["精")
	...s doclocdr=##class(web.DHCST.ReportForms.ReportCommon).GetTransDocLoc(intr)
	...q:(doclocin'="")&&(doclocdr'=doclocin) //过滤医生科室
	...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	...q:prescno=""
	...s spamt=$p(^DHCINTR(intr),"^",8)
	...i (spamt="") d
	....s amt=##class(web.DHCST.ReportForms.ReportCommon).GetAmt(type,pointer,intr)
	....s spamt=$p(amt,"^",2)
	...s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
	...s StkTypeDesc=$P(CatGrpStr,"^",4)
	...s Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
	...s spamt=$zabs(spamt)
	...//s spamt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spamt,Perv,"FmtSA",1)
	...s n=n+1
	...s ^TMP("DHCST",$this,"GetPhcformDispStat",pid,DrgForm,prescno,n)=spamt
    ..
    .
    q:n=0 $$$OK
    s DrgForm=""
    f  s DrgForm=$o(^TMP("DHCST",$this,"GetPhcformDispStat",pid,DrgForm)) q:DrgForm=""  d
    .s prescno="",prescnum=0,presctotalamt=0,prescfacnum=0		//处方数量,处方金额,处方付数
    .f  s prescno=$o(^TMP("DHCST",$this,"GetPhcformDispStat",pid,DrgForm,prescno)) q:prescno=""  d
    ..s prescnum=prescnum+1
    ..s que=##class(PHA.COM.Order).GetPaQueInfo(prescno)
    ..s factor=+$p(que,"^",2)		//草药付数
    ..s:+factor=0 factor=1
    ..s prescfacnum=prescfacnum+factor
    ..s num=""
    ..f  s num=$o(^TMP("DHCST",$this,"GetPhcformDispStat",pid,DrgForm,prescno,num)) q:num=""  d
    ...s spamt=$g(^TMP("DHCST",$this,"GetPhcformDispStat",pid,DrgForm,prescno,num))
    ...s presctotalamt=presctotalamt+spamt
    .d OutRowDocLocPresc  
    d ..ClearTmp("GetPhcformDispStat",pid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowDocLocPresc
	set Data=$lb(DrgForm,prescnum,prescfacnum,presctotalamt)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// Author : MYQ
/// CreatDate : 2017-10-31
/// Description : 统计时间段内入库和发药数据(按照供应商、药品汇总)
/// Input : StartDate - 开始日期 , EndDate - 截止日期 , BasicFlag - 基本药物标记 , PublicFlag - 招标标记
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryGDispData","2019-2-01","2019-2-18","","") 
Query QueryGDispData(StartDate As %String = "", EndDate As %String = "", BasicFlag As %String = "", PublicFlag As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "GeneName:%String,spec:%String,puomdesc:%String,ManfDesc:%String,vendordesc:%String,GQtySum:%Float,GSpAmtSum:%Float,DispQtySum:%Float,DispSpAmtSum:%Float") [ SqlProc ]
{
}

ClassMethod QueryGDispDataExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", BasicFlag As %String = "", PublicFlag As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s BasicFlag=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(BasicFlag)
	s PublicFlag=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(PublicFlag)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(StartDate="")||(EndDate="") $$$OK			//必选条件
	s npid=..NewPid()
	d ..ClearTmp("QueryGDispData",npid)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s IntrTypeStr = ..#DispTypeStr_"^"_..#RecRetTypeStr	//默认统计入库、住院发药和门诊发药
	s dispTypeStr = "^"_..#DispTypeStr_"^"
	s CustID=""
	s counter=0
	s TypeLen=$l(IntrTypeStr,"^")
	f TypeNum=1:1:TypeLen d
	.s type=$p(IntrTypeStr,"^",TypeNum)
	.f Date=StartDate:1:EndDate d
 	..s intrid="" //遍历台账表 DHC_INTRANS
 	..f  s intrid=$o(^DHCINTR(0,"TypeDate",type,Date,intrid)) q:intrid=""  d
 	...q:'$d(^DHCINTR(intrid))
 	...s inclb=$p(^DHCINTR(intrid),"^",7)		//批次
 	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
 	...s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(+inclb)
	...S GrpType=$p(tmpstkgrp,"^",3)
	...q:GrpType'="G"
 	...i CustID=""  d
 	....s LocID=$$LOC^ST01(inclb)
 	....s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocID)
	....s CustID=$p(CustStr,"^",1)
 	...s incib=$p($g(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3))),"^",1)
 	...q:incib=""
 	...s ingrid=$o(^DHCINGR(0,"GRI_INCIB",incib,""),-1)
 	...s vendorid=$s(ingrid'="":$p(^DHCINGR(ingrid),"^",3),1:"空")		//供应商
 	...s inci=+inclb
 	...s pbflag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inci)
 	...q:(PublicFlag="Y")&&(pbflag'=1)		//过滤招标标记
 	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s tmpbflag = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",31) //国家基本药物标志
 	...q:(BasicFlag="Y")&&(tmpbflag'="Y")	//过滤基本药物
 	...s buomid=$p(^INCI(inci,1),"^",10)		//基本单位
 	...s spamt=$p(^DHCINTR(intrid),"^",8)		//业务售价金额
	...s intrqty=$p(^DHCINTR(intrid),"^",6)		//业务数量
	...s intruomid=$p(^DHCINTR(intrid),"^",10)	//台账单位
	...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(intruomid,buomid)
	...s bqty=intrqty*fac		//基本单位对应数量
	...s gqty=0,dispqty=0,gspamt=0,dispspamt=0
	...i (dispTypeStr [ ("^"_type_"^")) d
	....s dispqty=bqty		//发药数量
	....s dispspamt=spamt
	...e  d
	....s gqty=bqty			//入库数量
	....s gspamt=spamt
	...s counter=counter+1
	...s ^TMP("DHCST",$this,"QueryGDispData",npid,inci,vendorid,counter)=dispqty_"^"_dispspamt_"^"_gqty_"^"_gspamt
	..
	.
	q:counter=0 $$$OK
	s inciid=""
	f  s inciid=$o(^TMP("DHCST",$this,"QueryGDispData",npid,inciid)) q:inciid=""  d
	.s GeneStr=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid)	//取通用名
	.s GeneName=$p(GeneStr,"^",2)
	.s InciDesc=$p(^INCI(inciid,1),"^",2)
	.s:GeneName="" GeneName=InciDesc
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid)		//规格
	.s puomid=$p(^INCI(inciid,3),"^",6)
	.s puomdesc=$s(puomid'="":$p(^CT("UOM",puomid),"^",2),1:"")
	.s buomid=$p(^INCI(inciid,1),"^",10)
	.s pbfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomid,buomid)
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inciid) 	//厂商
	.s ManfDesc=$p(ManfInfo,"^",3)
	.s vendor=""
	.f  s vendor=$o(^TMP("DHCST",$this,"QueryGDispData",npid,inciid,vendor)) q:vendor=""  d
	..s vendordesc=$s(+vendor'="0":$p(^APC("APCVM",vendor),"^",3),1:"")
	..s cnum=0,GQtySum=0,GSpAmtSum=0,DispQtySum=0,DispSpAmtSum=0
	..f  s cnum=$o(^TMP("DHCST",$this,"QueryGDispData",npid,inciid,vendor,cnum)) q:cnum=""  d
	...s tmpdata=$g(^TMP("DHCST",$this,"QueryGDispData",npid,inciid,vendor,cnum))
	...s sgqty=$p(tmpdata,"^",3)
	...s sgspamt=$p(tmpdata,"^",4)
	...s sdispqty=$p(tmpdata,"^",1)
	...s sdispspamt=$p(tmpdata,"^",2)
	...s GQtySum=GQtySum+sgqty 
	...s GSpAmtSum=GSpAmtSum+sgspamt
	...s DispQtySum=DispQtySum+sdispqty
	...s DispSpAmtSum=DispSpAmtSum+sdispspamt
	..q:((GQtySum=0) && (DispQtySum=0))
	..s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inciid)
	..s StkTypeDesc=$P(CatGrpStr,"^",4)
	..s Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
	..s GQtySum=+(GQtySum/pbfac)
	..s GQtySum=##Class(web.DHCSTCOMMPARA).GetNumbDec(GQtySum,Perv,"FmtSQ",1)
	..s DispQtySum=+(DispQtySum/pbfac)
	..s DispQtySum=##Class(web.DHCSTCOMMPARA).GetNumbDec(DispQtySum,Perv,"FmtSQ",1)
 	..d OutputGDisp
 	.
 	d ..ClearTmp("QueryGDispData",npid)
 	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputGDisp   
	s Data=$lb(GeneName,spec,puomdesc,ManfDesc,vendordesc,GQtySum,GSpAmtSum,DispQtySum,DispSpAmtSum)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1	
	q
}

/// Descript:   咸阳财务报表-科室药品消耗汇总统计
/// Creator:    hulihua
/// CreateDate: 2014-03-29
/// Input:      开始时间^结束时间
/// Output:     开单科室 西药金额 中药金额 总金额
/// LastUpdate:yunhaibao,按开单科室,类组,金额输出
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","DispStatForLoc","2017-08-03","2018-08-03")
Query DispStatForLoc(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Tdocloc:%String,Tgrpdesc:%String,Tgrpamt:%Double") [ SqlProc ]
{
}

ClassMethod DispStatForLocExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s HOSPID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(HOSPID)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1	
	q:(StartDate="")||(EndDate="") $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H^HC^PH^YH^FH^HH"
	s pid=..NewPid()
	d ..ClearTmp("DispStatForLoc",pid)
	s len=$l(strType,"^")
	f j=1:1:len  d
	.s type=$p(strType,"^",j)
	.f date=StartDate:1:EndDate  d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclbid=$p(^DHCINTR(intr),"^",7)
	...q:inclbid=""
	...s inciloc=$p($g(^INCI(+inclbid,"IL",+$p(inclbid,"||",2))),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$p($g(^CTLOC(+inciloc)),"^",22))
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...q:$g(inci)=""
	...s tamt=$p(^DHCINTR(intr),"^",8) ;总金额
	...s tamt=(-1)*(tamt)
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s catgrpdesc=$p(StkGrpInfo,"^",2) 
	...s catgrptype=$p(StkGrpInfo,"^",3) 
	...q:catgrptype'="G"
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	...s recloc=$p(^OEORD(Ord,"I",Chl,3),"^",6)
	...s docloc=$p(^CTLOC(ordept),"^",2)
	...q:docloc=""
	...i '$d(^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",docloc,catgrpdesc)) d
	....s ^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",docloc,catgrpdesc)=tamt
	...e  d
	....s $p(^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",docloc,catgrpdesc),"^",1)=$p(^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",docloc,catgrpdesc),"^",1)+tamt
	...
	..
	.
	s outputdocdesc=""
	f  s outputdocdesc=$o(^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",outputdocdesc))  q:outputdocdesc=""  d
	.s Tdocdesc=$s($F(outputdocdesc,"-"):$p(outputdocdesc,"-",2),1:outputdocdesc)
	.s outputgrp=""
	.f  s outputgrp=$o(^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",outputdocdesc,outputgrp))  q:outputgrp=""  d
	..s data=^TMP("DHCST",$this,"DispStatForLoc",pid,"ForLOC",outputdocdesc,outputgrp)
	..s Tgrpamt=+$p(data,"^",1)
	..q:Tgrpamt=0
	..d OutputRow
	d ..ClearTmp("DispStatForLoc",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK  
OutputRow   
	s Data=$lb(Tdocdesc,outputgrp,Tgrpamt)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Descript:    全院药品使用前十名分类排序(四川自贡三院)
/// Creator：    hulihua
/// CreateDate:  2014-07-23
/// Table:       DHC_INTRANS
/// Input:       StartDate 开始日期, EndDate 截止日期, ordertype排序方式, uomtype单位方式, rank前多少名
/// Output:      药品名称^规格^单位^使用数量^单价^金额^供应商
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryAllDrugOrder","2018-01-01","2018-04-28","qty","puom","20")
Query QueryAllDrugOrder(StartDate As %String = "", EndDate As %String = "", ordertype As %String = "", uomtype As %String = "", rank As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Inci:%String,TInciDesc:%String,TSpec:%String,TUom:%String,TPrice:%Float,TQty:%Float,TAmt:%Float,Tvenname:%String") [ SqlProc ]
{
}

ClassMethod QueryAllDrugOrderExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", ordertype As %String = "", uomtype As %String = "", rank As %String = "", HOSPID As %String = "") As %Status
{
	// tro
	// s ^PHATMP("MYQ", $this, "QueryAllDrugOrder") = $lb(StartDate, EndDate, ordertype, uomtype, rank, HOSPID)
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s ordertype=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(ordertype)
	s uomtype=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(uomtype)
	s rank=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(rank)
	s HOSPID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(HOSPID)
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Q:(StartDate="")||(EndDate="") $$$OK
	q:rank'=+rank $$$OK
	//s ^hlh($h)=$lb(StartDate,EndDate,ordertype,uomtype,rank,HOSPID)
	s pid=..NewPid()
	d ..ClearTmp("QueryAllDrugOrder",pid)
	s m=rank
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H^HC^PH^YH^FH^HH^HHC" //统计全院
	s len=$l(strType,"^")
	f i=1:1:len  d
	.s type=$p(strType,"^",i)
	.f date=sd:1:ed d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inci=$p(^DHCINTR(intr),"^",15)
	...q:inci=""
	...q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",3)'="G"
	...s itmdesc=$p(^INCI(inci,1),"^",2)
	...s inclbid=$p(^DHCINTR(intr),"^",7)
	...q:inclbid=""
	...s inciloc=$p($g(^INCI(+inclbid,"IL",+$p(inclbid,"||",2))),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$p($g(^CTLOC(+inciloc)),"^",22))
	...s tuom=$p(^DHCINTR(intr),"^",10)
	...s uomdesc=$P(^CT("UOM",tuom),"^",2) 
	...s tqty=-$p(^DHCINTR(intr),"^",6)
	...s ctuom=$p(^INCI(inci,1),"^",10)   	; basic uom
	...s puom=$p(^INCI(inci,3),"^",6)     ; purchase uom
	...s tamt=$p(^DHCINTR(intr),"^",8)
	...s tamt=-tamt
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s sprice=$p(^DHCINTR(intr),"^",14) //单价
	...i uomtype="puom"  d
	....s:puom="" puom=ctuom  
	....s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(tuom,ctuom)    ;factor between trans uom and basic uom
	....s tqty=tqty*fac
	....s sprice=sprice/fac
	....s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,ctuom)   ;factor between trans uom and basic uom
	....s tqty=tqty/fac2
	....s sprice=sprice*fac2
	....s uomdesc=$P(^CT("UOM",puom),"^",2)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	...s docloc=$p(^CTLOC(ordept),"^",2)
	...i $f(docloc,"-") s docloc=$P(docloc,"-",2)
	...s venname=$p(##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclbid,date),"^",2)    //BS用
	...//s venname=$p(##class(web.DHCSTCOMMONSRV).GetInclbVend(inclbid,date),"^",2)             //CS用
	...s:$f(venname,"-") venname=$p(venname,"-",2)
	...i $d(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci)) d
	....s $P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci),"^",5)=$P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci),"^",5)+tqty
	....s $P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci),"^",6)=$P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci),"^",6)+tamt
	...e  d
	....s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	....s ^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",inci)=itmdesc_"^"_spec_"^"_uomdesc_"^"_sprice_"^"_tqty_"^"_tamt_"^"_venname_"^"_inci
	...
	..
	.
	s incirowid=""
	f  s incirowid=$o(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",incirowid)) q:incirowid=""  d
	.s qty=$P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",incirowid),"^",5)
	.s:ordertype="qty" mqty=$P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",incirowid),"^",5)
	.s:ordertype="amt" mqty=$P(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",incirowid),"^",6)
	.s ^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCIQTY",mqty,incirowid)=^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCI",incirowid)
	s nn=0 //只查找前m个
	s qtytotal=""
	f  s qtytotal=$O(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCIQTY",qtytotal),-1) q:(qtytotal="")!(nn=m)  d
	.s in=""
	.f  s in=$O(^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCIQTY",qtytotal,in)) q:(in="")!(nn=m)  d
	..s nn=nn+1
	..s tmpdata=^TMP("DHCST",$this,"QueryAllDrugOrder",pid,"INCIQTY",qtytotal,in)
	..s itmdesc=$P(tmpdata,"^",1)
	..s spec=$P(tmpdata,"^",2)
	..s uomdesc=$P(tmpdata,"^",3)
	..s sprice=$P(tmpdata,"^",4)
	..s tqty=$P(tmpdata,"^",5) q:tqty=0
	..s tamt=$P(tmpdata,"^",6) 
	..s venname=$P(tmpdata,"^",7)
	..s inci=$P(tmpdata,"^",8)
	..set Data=$lb(inci,itmdesc,spec,uomdesc,sprice,tqty,tamt,venname)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	.
	d ..ClearTmp("QueryAllDrugOrder",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:    全院药品使用前十名科室分布情况(四川自贡三院)
/// Creator：    hulihua
/// CreateDate:  2014-07-23
/// Table:       DHC_INTRANS
/// Input:       StartDate 开始日期, EndDate 截止日期, ordertype 分布方式, uomtype单位方式, rank前多少名
/// Output:      药品名称^使用数量^开单科室^金额
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryAllDrugForLoc","2018-01-16","2018-04-18","qty","","20","")
Query QueryAllDrugForLoc(StartDate As %String = "", EndDate As %String = "", ordertype As %String = "", uomtype As %String = "", rank As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TInciDesc:%String,TOrderQty:%Float,Tdocloc:%String,Tnn:%String") [ SqlProc ]
{
}

ClassMethod QueryAllDrugForLocExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", ordertype As %String = "", uomtype As %String = "", rank As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s ordertype=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(ordertype)
	s uomtype=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(uomtype)
	s rank=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(rank)
	s HOSPID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(HOSPID)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^hlh($h)=$lb(StartDate,EndDate,ordertype,uomtype,rank,HOSPID)
	Q:(StartDate="")||(EndDate="") $$$OK
	q:+rank'=rank $$$OK
	s pid=..NewPid()
	d ..ClearTmp("QueryAllDrugForLoc",pid)
	s m=rank
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H^HC^PH^YH^FH^HH^HHC" //统计全院
	s len=$l(strType,"^")
	f i=1:1:len  d
	.s type=$p(strType,"^",i)
	.f date=sd:1:ed d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...q:+intr=0
	...s DHCINTR=^DHCINTR(intr)
	...s inci=$p(DHCINTR,"^",15)
	...q:inci=""
	...q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",3)'="G"
	...s inclbid=$p(DHCINTR,"^",7)
	...q:inclbid=""
	...s inciloc=$p($g(^INCI(+inclbid,"IL",+$p(inclbid,"||",2))),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$p($g(^CTLOC(+inciloc)),"^",22))
	...s itmdesc=$p(^INCI(inci,1),"^",2)
	...s tuom=$p(DHCINTR,"^",10) 
	...s tqty=$p(DHCINTR,"^",6)
	...s tamt=$p(DHCINTR,"^",8)
	...s ctuom=$p(^INCI(inci,1),"^",10)   	; basic uom
	...s puom=$p(^INCI(inci,3),"^",6)     ; purchase uom
	...i uomtype="puom"  d
	....s:puom="" puom=ctuom  
	....s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(tuom,ctuom)    ;factor between trans uom and basic uom
	....s tqty=tqty*fac
	....s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,ctuom)   ;factor between trans uom and basic uom
	....s tqty=tqty/fac2
	...s pointer=$p(DHCINTR,"^",9)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori="" 
	...s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	...s docloc=$p(^CTLOC(ordept),"^",2)
	...s tamt=tamt
	...s tqty=-tqty
	...s tamt=-tamt
	...i $d(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc)) d  //加个科室的节点
	....s $P(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc),"^",2)=$P(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc),"^",2)+tqty
	....s $P(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc),"^",4)=$P(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc),"^",4)+tamt
	...e  d
	....s ^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",inci,docloc)=itmdesc_"^"_tqty_"^"_docloc_"^"_tamt
	...
	..
	.
	s incirowid=""  //仅全院排序
	f  s incirowid=$o(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",incirowid)) q:incirowid=""  d
	.s count="",totalqty=0,sumtotaltamt=0,sumtotalqty=0
	.f  s count=$o(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",incirowid,count)) q:count=""  d
	..s qty=$P((^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",incirowid,count)),"^",2)
	..s tamt=$P((^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",incirowid,count)),"^",4)
	..s sumtotalqty=+sumtotalqty+qty
	..s sumtotaltamt=+sumtotaltamt+tamt
	.s:(ordertype="qty")!(ordertype="") totalqty=sumtotalqty
	.s:ordertype="amt" totalqty=sumtotaltamt
	.s ^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCIQTY",totalqty,incirowid)=totalqty 

	s nn=0 //只查找前10个
	s qtytotal=""
	f  s qtytotal=$O(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCIQTY",qtytotal),-1) q:(qtytotal="")!(nn=m)  d
	.s in=""
	.f  s in=$O(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCIQTY",qtytotal,in)) q:(in="")!(nn=m)  d
	..s nn=nn+1
	..s doclocdr=""
	..f  s doclocdr=$o(^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",in,doclocdr)) q:doclocdr=""  d
	...;上边是按总的量排序，找到排名前10的药就行，下边根据上方记录过的临时global直接取出各科室的用药
	...s tmpdata=^||TMP("DHCST",$this,"QueryAllDrugForLoc",pid,"INCI",in,doclocdr)
	...s itmdesc=$P(tmpdata,"^",1)
	...s tqty=$P(tmpdata,"^",2)
	...s docloc=$P(tmpdata,"^",3)
	...s tamt=$P(tmpdata,"^",4)
	...q:(tqty=0)&&(tamt=0)
	...s:$f(docloc,"-") docloc=$p(docloc,"-",2)
	...s orderqty=0
	...s:(ordertype="qty")!(ordertype="") orderqty=tqty 
	...s:ordertype="amt" orderqty=tamt
	...set Data=$lb(itmdesc,orderqty,docloc,nn)
	...Set ^CacheTemp(repid,ind)=Data	
	...Set ind=ind+1
	..
	.
	d ..ClearTmp("QueryAllDrugForLoc",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:    全院药品金额使用前十名医生分布情况(四川自贡三院)
/// Creator：    hulihua
/// CreateDate:  2014-07-30
/// Table:       DHC_INTRANS
/// Input:       StartDate 开始日期, EndDate 截止日期, InciName 药品名称
/// Output:      药品名称^使用数量^开单科室^金额
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryAllDrugForDoc","2023-02-20","2023-03-02","816","","2")
Query QueryAllDrugForDoc(StartDate As %String = "", EndDate As %String = "", InciName As %String = "", HOSPID As %String = "", gHospId As %String = "") As websys.Query(ROWSPEC = "TInciDesc:%String,TSpec:%String,TUom:%String,TDoctor:%String,TQty:%Float,TAmt:%Float") [ SqlProc ]
{
}

ClassMethod QueryAllDrugForDocExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", InciName As %String = "", HOSPID As %String = "", gHospId As %String = "") As %Status
{
	//tro
	//s ^PHATMP("MYQ", $this, "QueryAllDrugForDoc") = $lb(StartDate, EndDate, InciName, HOSPID, gHospId)
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s InciName=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(InciName)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Q:(StartDate="")||(EndDate="")||(InciName="") $$$OK
	s pid=..NewPid()
	d ..ClearTmp("QueryAllDrugForDoc",pid)
	s inciRowid=InciName
	q:inciRowid="" $$$OK
	if (HOSPID = ""){
		s HOSPID = gHospId
	}
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H^HC^PH^YH^FH^HH^HHC" //统计全院
	f date=sd:1:ed d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"INCI",inciRowid,date,intr)) q:(intr="")  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..q:inclb=""
	..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	..s Intrtype=$p(^DHCINTR(intr),"^",1)
	..q:##class(web.DHCST.Common.UtilCommon).FindInList(strType,Intrtype,"^")=0
	..s inci=$p(^DHCINTR(intr),"^",15)
	..s itmdesc=$p(^INCI(inci,1),"^",2)
	..s tuom=$p(^DHCINTR(intr),"^",10) 
	..s tqty=(-1)*$p(^DHCINTR(intr),"^",6)
	..s uomdesc=$P(^CT("UOM",tuom),"^",2)
	..s tamt=$p(^DHCINTR(intr),"^",8)
	..s tamt=(-1)*tamt
	..s pointer=$p(^DHCINTR(intr),"^",9)
	..s price=$p(^DHCINTR(intr),"^",14) //单价
	..s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,Intrtype)
	..q:oeori=""
	..s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	..q:Ord=""
	..q:'$d(^OEORD(Ord))
	..q:'$d(^OEORD(Ord,"I",Chl))
	..s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	..s docloc=$p(^CTLOC(ordept),"^",2)
	..i $f(docloc,"-") s docloc=$P(docloc,"-",2)
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	..s orduser=+$p($g(^OEORD(Ord,"I",Chl,7)),"^",1)
	..s doctor=$p(^SSU("SSUSR",orduser),"^",2)
	..s orddoctco=+$p($g(^OEORD(Ord,"I",Chl,1)),"^",11)
	..s:orddoctco'=0 doctor=$p(^CTPCP(orddoctco,1),"^",2)
	..s:doctor="" doctor="未知"
	..i $d(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor)) d
	...s $P(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor),"^",5)=$P(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor),"^",5)+tqty
	...s $P(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor),"^",6)=$P(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor),"^",6)+tamt
	..e  d
	...s ^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inci,"DOCTOR",doctor)=itmdesc_"^"_spec_"^"_uomdesc_"^"_price_"^"_tqty_"^"_tamt
	..
	.
	s doctorrowid=""
	f  s doctorrowid=$o(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inciRowid,"DOCTOR",doctorrowid)) q:doctorrowid=""  d
	.s tamt=$P(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inciRowid,"DOCTOR",doctorrowid),"^",6)
	.s ^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCIQTY",tamt,"INCI",inciRowid,doctorrowid)=^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCI",inciRowid,"DOCTOR",doctorrowid)
	s nn=0 //只查找前10位医生
	s qtytotal=""
	f  s qtytotal=$O(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCIQTY",qtytotal),-1) q:(qtytotal="")!(nn=10)  d
	.s in=""
	.f  s in=$O(^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCIQTY",qtytotal,"INCI",inciRowid,in)) q:(in="")!(nn=10)  d
	..s nn=nn+1
	..s tmpdata=^TMP("DHCST",$this,"QueryAllDrugForDoc",pid,"INCIQTY",qtytotal,"INCI",inciRowid,in)
	..s itmdesc=$P(tmpdata,"^",1)
	..s spec=$P(tmpdata,"^",2)
	..s uomdesc=$P(tmpdata,"^",3)
	..s price=$P(tmpdata,"^",4)
	..s tqty=$P(tmpdata,"^",5) q:tqty=0
	..s tamt=$P(tmpdata,"^",6)
	..set Data=$lb(itmdesc,spec,uomdesc,in,tqty,tamt)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	.
	d ..ClearTmp("QueryAllDrugForDoc",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:    全院药品使用前十名医生分布明细情况(山西长治人民)
/// Creator：    hulihua
/// CreateDate:  2015-11-25
/// Table:       DHC_INTRANS
/// Input:       StartDate 开始日期, EndDate 截止日期, DoctorName 医生名称,InciRowid 库存项ID
/// Output:      医生姓名，病人登记号，病人姓名，病人科室，药品名称，规格，数量，单位，金额，医嘱时间，诊断
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryDrugForDocDetail","2018-01-01","2018-04-28","医生01","1301")
Query QueryDrugForDocDetail(StartDate As %String = "", EndDate As %String = "", DoctorName As %String = "", InciRowid As %String = "", HOSPID As %String = "", gHospId As %String = "") As websys.Query(ROWSPEC = "TDoctor:%String,TPatNo:%String,TPatName:%String,TDocloc:%String,TItmdesc:%String,TSpec:%String,Tqty:%Float,TUomdesc:%String,Tamt:%Float,TOrddate:%String,TDiagnose:%String") [ SqlProc ]
{
}

ClassMethod QueryDrugForDocDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", DoctorName As %String = "", InciRowid As %String = "", HOSPID As %String = "", gHospId As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s DoctorName=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(DoctorName)
	s InciRowid=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(InciRowid)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^hlh($h)=$lb(StartDate,EndDate,DoctorName,InciRowid)
	Q:(StartDate="")||(EndDate="")||(InciRowid="")||(DoctorName="") $$$OK
	if (HOSPID = ""){
		s HOSPID = gHospId
	}
	s pid=..NewPid()
	d ..ClearTmp("QueryDrugForDocDetail",pid)
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H^HC^PH^YH^FH^HH^HHC" //统计全院
	f date=sd:1:ed d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"INCI",InciRowid,date,intr)) q:(intr="")  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..q:inclb=""
	..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	..s Intrtype=$p(^DHCINTR(intr),"^",1)
	..q:##class(web.DHCST.Common.UtilCommon).FindInList(strType,Intrtype,"^")=0
	..s inci=$p(^DHCINTR(intr),"^",15)
	..s itmdesc=$p(^INCI(inci,1),"^",2)
	..s tuom=$p(^DHCINTR(intr),"^",10) 
	..s tqty=(-1)*$p(^DHCINTR(intr),"^",6)
	..s uomdesc=$P(^CT("UOM",tuom),"^",2)
	..s tamt=(-1)*$p(^DHCINTR(intr),"^",8)
	..s tamt=tamt
	..s pointer=$p(^DHCINTR(intr),"^",9)
	..s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,Intrtype)
	..q:oeori=""
	..s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	..q:Ord=""
	..q:'$d(^OEORD(Ord))
	..q:'$d(^OEORD(Ord,"I",Chl))
	..s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	..s docloc=$p(^CTLOC(ordept),"^",2)
	..s orduser=+$p($g(^OEORD(Ord,"I",Chl,7)),"^",1)
	..s doctor=$p(^SSU("SSUSR",orduser),"^",2)
	..s orddoctco=+$p($g(^OEORD(Ord,"I",Chl,1)),"^",11)
	..s:orddoctco'=0 doctor=$p(^CTPCP(orddoctco,1),"^",2)
	..s:doctor="" doctor="未知"
	..q:DoctorName'=doctor
	..s Ord=+oeori,Chl=$P(oeori,"||",2)
	..s AdmDr=$p(^OEORD(Ord),"^",1)
	..s PapmiId=$p(^PAADM(AdmDr),"^",1) 
	..s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	..s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1) 
	..s Diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(AdmDr,",") //诊断
	..i $f(docloc,"-") s docloc=$P(docloc,"-",2)
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	..s orddate=$p(^OEORD(Ord,"I",Chl,1),"^",9)
	..i orddate'="" s orddate=$zd(orddate,3)
	..s Data1=doctor_"^"_PatNo_"^"_PatName_"^"_docloc_"^"_itmdesc
	..s Data2=spec_"^"_tqty_"^"_uomdesc_"^"_tamt_"^"_orddate
	..s Data3=Diagnose 
	..s Data=Data1_"^"_Data2_"^"_Data3 
	..i $d(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori)) d
	...s $P(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori),"^",7)=$P(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori),"^",7)+tqty
	...s $P(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori),"^",9)=$P(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori),"^",9)+tamt
	..e  d
	...s ^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori)=Data
	..
	.
	s PatNo=""
	f  s PatNo=$o(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo)) q:PatNo=""  d
	.s oeori=""
	.f  s oeori=$O(^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori)) q:oeori=""  d
	..s Data=^TMP("DHCST",$this,"QueryDrugForDocDetail",pid,"PatNo",PatNo,oeori)
	..s Doctor=$P(Data,"^",1)
	..s PatNo=$P(Data,"^",2)
	..s PatName=$P(Data,"^",3)
	..s Docloc=$P(Data,"^",4)
	..s Itmdesc=$P(Data,"^",5)
	..s Spec=$P(Data,"^",6)
	..s Tqty=$P(Data,"^",7) q:Tqty=0
	..s Uomdesc=$P(Data,"^",8)
	..s Tamt=$P(Data,"^",9)
	..s Orddate=$P(Data,"^",10)
	..s Diagnose=$P(Data,"^",11)
	..set Data=$lb(Doctor,PatNo,PatName,Docloc,Itmdesc,Spec,Tqty,Uomdesc,Tamt,Orddate,Diagnose)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	.
	d ..ClearTmp("QueryDrugForDocDetail",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:    全院药品使用排名之科室排名(山西长治人民)
/// Creator：    hulihua
/// CreateDate:  2015-11-25
/// Table:       DHC_INTRANS
/// Input:       StartDate 开始日期, EndDate 截止日期, InciRowid 库存项ID
/// Output:      开单科室，药品名称，规格，数量，单位，金额
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryDrugForLocRank","2018-01-01","2018-04-28","1301","")
Query QueryDrugForLocRank(StartDate As %String = "", EndDate As %String = "", InciRowid As %String = "", UomType As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TDocloc:%String,TItmdesc:%String,TSpec:%String,Tqty:%Float,TUomdesc:%String,Tamt:%Float") [ SqlProc ]
{
}

ClassMethod QueryDrugForLocRankExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", InciRowid As %String = "", UomType As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s UomType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(UomType)
	s InciRowid=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(InciRowid)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^hlh($h)=$lb(StartDate, EndDate, InciRowid,UomType)
	Q:(InciRowid="")||(StartDate="")||(EndDate="") $$$OK
	s pid=..NewPid()
	d ..ClearTmp("QueryDrugForLocRank",pid)
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s strType="P^Y^F^H" //统计全院
	f date=sd:1:ed d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"INCI",InciRowid,date,intr)) q:(intr="")  d
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..q:inclb=""
	..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	..s type=$p(^DHCINTR(intr),"^",1)
	..q:##class(web.DHCST.Common.UtilCommon).FindInList(strType,type,"^")=0
	..s inci=$p(^DHCINTR(intr),"^",15)
	..s itmdesc=$p(^INCI(inci,1),"^",2)
	..s tuom=$p(^DHCINTR(intr),"^",10) 
	..s tqty=(-1)*$p(^DHCINTR(intr),"^",6)
	..s ctuom=$p(^INCI(inci,1),"^",10)   	; basic uom
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(tuom,ctuom)
	..s tqty=tqty*fac
	..s uom=ctuom  
	..i UomType="puom"  d
	...s puom=$p(^INCI(inci,3),"^",6)     ; purchase uom
	...s:puom="" puom=ctuom     
	...s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,ctuom)  
	...s tqty=tqty/fac2
	...s uom=puom
	..s uomdesc=$P(^CT("UOM",uom),"^",2)
	..s tamt=$p(^DHCINTR(intr),"^",8)
	..s tamt=(-1)*tamt
	..s pointer=$p(^DHCINTR(intr),"^",9)
	..s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	..q:oeori=""
	..s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	..q:Ord=""
	..q:'$d(^OEORD(Ord))
	..q:'$d(^OEORD(Ord,"I",Chl))
	..s ordept=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	..s docloc=$p(^CTLOC(ordept),"^",2) 
	..i $f(docloc,"-") s docloc=$P(docloc,"-",2)
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	..s Data1=docloc_"^"_itmdesc_"^"_spec_"^"_tqty_"^"_uomdesc
	..s Data2=tamt
	..s Data=Data1_"^"_Data2 
	..i $d(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc)) d
	...s $P(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc),"^",4)=$P(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc),"^",4)+tqty
	...s $P(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc),"^",6)=$P(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc),"^",6)+tamt
	..e  d
	...s ^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc)=Data
	..
	.
	s docloc=""
	f  s docloc=$o(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc)) q:docloc=""  d
	.s tamt=$P(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc),"^",6)
	.s ^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"INCIQTY",tamt,docloc)=^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"Docloc",docloc)
	s nn=0 //只查找前10位科室
	s tamt=""
	f  s tamt=$o(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"INCIQTY",tamt),-1) q:(tamt="")!(nn=10)  d
	.s docloc=""
	.f  s docloc=$O(^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"INCIQTY",tamt,docloc)) q:(docloc="")!(nn=10)  d
	..s nn=nn+1
	..s Data=^TMP("DHCST",$this,"QueryDrugForLocRank",pid,"INCIQTY",tamt,docloc)
	..s Docloc=$P(Data,"^",1)
	..s Itmdesc=$P(Data,"^",2)
	..s Spec=$P(Data,"^",3)
	..s Tqty=$P(Data,"^",4) q:Tqty=0
	..s Uomdesc=$P(Data,"^",5)
	..s Tamt=$P(Data,"^",6)
	..set Data=$lb(Docloc,Itmdesc,Spec,Tqty,Uomdesc,Tamt)
	..Set ^CacheTemp(repid,ind)=Data	
	..Set ind=ind+1
	.
	d ..ClearTmp("QueryDrugForLocRank",pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description：聊城财务报表-科室药品消耗（门诊发退药、住院发退药）类组汇总统计
/// Creator：    hulihua
/// CreatDate：  2015-07-20
/// Table：      DHC_INTRANS-台帐表
/// Input：      StartDate-开始日期,EndDate-结束日期,LocId-科室ID,StkGrpId-类组ID,StartTime-开始时间,EndTime-截至时间,PhaLocId-药房ID,ReportFormat-报表格式
/// Output：	 输出科室、类组描述、进价金额、售价金额  	 	     
/// Return：	 	       
/// Others：
/// Debug：		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","DispStatForDoc","2018-01-01","2018-01-10","","","","","P^Y^F^H-全部","docloc")
Query DispStatForDoc(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", StkGrpId As %String = "", StartTime As %String = "", EndTime As %String = "", strType As %String = "", StatType As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TOutloc:%String,TStkGrpdesc:%String,TRpAmt:%Float,TSpAmt:%Float") [ SqlProc ]
{
}

ClassMethod DispStatForDocExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", StkGrpId As %String = "", StartTime As %String = "", EndTime As %String = "", strType As %String = "", StatType As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s LocId=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(LocId)
	s StkGrpId=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StkGrpId)
	s StartTime=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartTime)
	s EndTime=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndTime)
	s strType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(strType)
	s StatType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StatType)
	s LocId=$tr(LocId,",","")  //因为润乾下拉数据集传入入参时后面会带一个，逗号，特做处理  2020-03-26 yangsj
	s StkGrpId=$tr(StkGrpId,",","")
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	//s ^hlh($h)=$lb(StartDate,EndDate,LocId,StkGrpId,StartTime,EndTime,strType,StatType)
	q:(StartDate="")||(EndDate="") $$$OK
	s StartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s:StartTime'="" StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s:EndTime'="" EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s:LocId="全部" LocId=""
	s:StkGrpId="全部" StkGrpId=""
	s strType=$p(strType,"-",1)
	s:strType="" strType="P^Y^F^H^HC^PH^YH^FH^HH"
	s pid=..NewPid()
	d ..ClearTmp("DispStatForDoc",pid,"ForDoc")
	s len=$l(strType,"^")
	f j=1:1:len  d
	.s type=$p(strType,"^",j)
	.f date=StartDate:1:EndDate  d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...q:'$d(^DHCINTR(intr))
	...s trTime=$p(^DHCINTR(intr),"^",3)
	...i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
	...i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
	...s inci=$p(^DHCINTR(intr),"^",15)
	...q:'$d(^INCI(inci,1))
	...s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...S GrpType=$p(tmpstkgrp,"^",3)
	...q:GrpType'="G"
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s LocID=$$LOC^ST01(inclb)
	...q:(LocId'="")&(LocId'=LocID)
	...s TmpStkGrpId=$p(tmpstkgrp,"^",5)
	...q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)                                    ;类组不符
	...s StkGrpdesc=$p(tmpstkgrp,"^",2)                                            ;类组名称
	...s RpAmt=(-1)*$p($G(^DHCINTR(intr)),"^",17)                                  ;进价金额
	...s SpAmt=(-1)*$p(^DHCINTR(intr),"^",8)                            			;售价金额
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s Ord=$p(oeori,"||",1),Chl=$p(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...s ordept=$p(^OEORD(Ord,"I",Chl,3),"^",6)
	...s deptloc=$p(^CTLOC(ordept),"^",2)
	...s fromloc=$p(^OEORD(Ord,"I",Chl,7),"^",2)
	...s docloc=$p(^CTLOC(fromloc),"^",2)
	...s Ordept=$p(^CTLOC(ordept),"^",2)
	...s Outloc=""
	...s:StatType="Ordept" Outloc=Ordept
	...s:StatType="docloc" Outloc=docloc
	...s:$f(Outloc,"-") Outloc=$p(Outloc,"-",2)
	...s index=Outloc_","_StkGrpdesc
	...i '$d(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index))  d
	....s Data=Outloc_"^"_StkGrpdesc_"^"_RpAmt_"^"_SpAmt
	....s ^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index)=Data
	...e  d
	....s $p(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index),"^",3)=$p(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index),"^",3)+RpAmt
	....s $p(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index),"^",4)=$p(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index),"^",4)+SpAmt
	...
	..
	.
	s index=""
	f  s index=$o(^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index))  q:index=""  d
	.s data=^TMP("DHCST",$this,"DispStatForDoc",pid,"ForDoc",index)
	.s SumRpAmt=$p(data,"^",3)
	.s SumSpAmt=$p(data,"^",4)
	.q:(SumRpAmt=0)&&(SumSpAmt=0)
	.d OutputRow
	d ..ClearTmp("DispStatForDoc",pid,"ForDoc")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutputRow
	Set Data=$LISTFROMSTRING(data,"^")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// Description:医生科室药品消耗统计
/// Creator:	likaijie
/// CreateDate: 2017-11-15
/// Table: 		DHC_INTRANS，
/// input:		StartDate 开始日期 EndDate 结束日期   库存类组
/// output：
/// Debug:		d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetDispStatData","2020-08-02","2021-09-07","","2")
Query GetDispStatData(StartDate As %String = "", EndDate As %String = "", StkCat As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "n:%Integer,rpamt:%Float,spamt:%Float,docloc:%String,Profit:%Float,StkCatDesc:%String") [ SqlProc ]
{
}

ClassMethod GetDispStatDataExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", StkCat As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s StkCat=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StkCat)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	q:(StartDate="")||(EndDate="") $$$OK
	s StartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s typestr="P^F^Y^H^HC^PH^FH^YH^HH^HHC"
	s pid=..NewPid()
	d ..ClearTmp("GetDispStatData",pid)
	s n=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=StartDate:1:EndDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s intrtime=$p(^DHCINTR(intr),"^",3)
	...s inci=+inclb
	...s ScgId=$P(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",5)		//获取类组信息
	...q:(StkCat'="")&&(ScgId'=StkCat)
	...s pointer=$p(^DHCINTR(intr),"^",9)  			;pointer
	...s spamt=(-1)*(+$p(^DHCINTR(intr),"^",8))
	...s rpamt=(-1)*(+$p(^DHCINTR(intr),"^",17))
	...s Profit=spamt-rpamt
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s ord=+oeori,chl=$P(oeori,"||",2)
	...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",chl))
	...s doclocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
	...s docloc=$p($g(^CTLOC(doclocdr)),"^",2)  //医生科室
	...s n=n+1
	...i '$D(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr)) d
	....s data=docloc_"^"_rpamt_"^"_spamt_"^"_Profit
	....s ^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr)=data
	...e  d
	....s $p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",2)=$p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",2)+rpamt 
	....s $p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",3)=$p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",3)+spamt
	....s $p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",4)=$p(^TMP("DHCST",$this,"GetDispStatData",pid,doclocdr),"^",4)+Profit
	....
	...
	..
	.
	;用于界面的类组显示
	s:n=0 ^TMP("DHCST",$this,"GetDispStatData",pid,n)="^^^^^"
	s StkCatDesc=$s(StkCat'="":$p(^DHCSCG(StkCat),"^",2),1:"") 
	s num=0,h=""
	f  s h=$o(^TMP("DHCST",$this,"GetDispStatData",pid,h)) q:h=""  d
    .s data=^TMP("DHCST",$this,"GetDispStatData",pid,h)
    .s docloc=$p(data,"^",1)
    .s:$f(docloc,"-") docloc=$p(docloc,"-",2)
    .s rpamt=$p(data,"^",2)
    .s spamt=$p(data,"^",3)
    .q:(rpamt=0)&&(spamt=0)
    .s Profit=$p(data,"^",4)
    .s num=$s(n'=0:num+1,1:"")
    .d OutRowItm
    d ..ClearTmp("GetDispStatData",pid)
    s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(num,rpamt,spamt,docloc,Profit,StkCatDesc)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// Description:统计一段时间内全院药房的处方数(O-门诊，I-住院，H-体检，E-急诊)
/// Creator:	likaijie
/// CreateDate: 2017-11-07
/// Table: 		PA_QUE1,DHC_PHACollected ,DHC_PHACollectItm,DHC_PHDISPEN,
/// input:		StartDate 开始日期 EndDate 结束日期
/// output：
/// Modified by MaYuqiang 2020-08-07
/// note : 一个处方中即有西药又有中成药时按照第一条医嘱的类组类型统计
/// 		仅统计门诊处方+住院草药处方+住院毒麻
/// 
/// Debug:		d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","PrescNoSum","2023-03-20","2023-03-23")
Query PrescNoSum(StartDate As %String, EndDate As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "phaLocDesc:%String,XYPrescNum:%Integer,ZYPrescNum:%Integer,ZCYPrescNum:%Integer,XYPrescAmt:%Float,ZYPrescAmt:%Float,ZCYPrescAmt:%Float") [ SqlProc ]
{
}

ClassMethod PrescNoSumExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (StartDate="")||(EndDate="") q $$$OK
	s StartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	k prescNoInfo
	
	s typeStr = ..#DispTypeStr
	for i = 1 : 1 : $l(typeStr, "^") {
		s type = $p(typeStr, "^", i)
		f fyDate = StartDate : 1 : EndDate {
			s intrId = ""
			for{
				s intrId = $o(^DHCINTR(0, "TypeDate", type, fyDate, intrId)) 
				q:(intrId = "")
				s spAmt = $p(^DHCINTR(intrId), "^", 8)
				s pointer = $p(^DHCINTR(intrId), "^", 9)
				s intrNo = $p(^DHCINTR(intrId), "^", 13)
				s inci = $p(^DHCINTR(intrId), "^", 15)
				s inclb = $p(^DHCINTR(intrId), "^", 7)
				s phaLocId = $p(^INCI(+inclb, "IL", $p(inclb,"||",2)), "^", 1)
				s hospdr = $P(^CTLOC(phaLocId), "^", 22)
				continue:((HOSPID '= "") && (HOSPID '= hospdr))
				if (intrNo '= ""){
					s prescNo = intrNo
				} else {
					s prescNo = ##class(web.DHCST.ReportForms.ReportCommon).GetPrescNo(pointer, type)
				}
				continue:(prescNo = "")
				s tmpstkgrp = ##class(PHA.COM.Drug).GetStkCatGrp(inci)
				s stkGrpDesc = $lg(tmpstkgrp,3)
				s prescNoInfo("phaLocPresc", phaLocId, stkGrpDesc, prescNo) = spAmt + $g(prescNoInfo("phaLocPresc", phaLocId, stkGrpDesc, prescNo))
			}
		}
	}
	s locId = ""
	for {
		s locId = $o(prescNoInfo("phaLocPresc", locId))
		q:(locId = "")
		s (XYPrescNum,ZYPrescNum,ZCYPrescNum,XYPrescAmt,ZYPrescAmt,ZCYPrescAmt) = 0
		s scgDesc = ""
		for {
			s scgDesc = $o(prescNoInfo("phaLocPresc", locId, scgDesc))
			q:(scgDesc = "")
			s (pNum,amt) = 0
			s prescNo = ""
			for {
				s prescNo = $o(prescNoInfo("phaLocPresc", locId, scgDesc, prescNo))
				q:(prescNo = "")
				s spAmt = $g(prescNoInfo("phaLocPresc", locId, scgDesc, prescNo))
				continue:(spAmt = 0)
				s pNum = pNum + 1
				s amt = amt + spAmt
			}
			if (scgDesc [ "西药"){
				s XYPrescNum = pNum
				s XYPrescAmt = amt
			} elseif (scgDesc [ "中成药"){
				s ZYPrescNum = pNum
				s ZYPrescAmt = amt
			} else {
				s ZCYPrescNum = pNum
				s ZCYPrescAmt = amt
			}
		}
		s phaLocDesc = ##class(PHA.COM.Data.Base).LocDesc(locId)
		s data = $lb(phaLocDesc, XYPrescNum, ZYPrescNum, ZCYPrescNum, XYPrescAmt, ZYPrescAmt, ZCYPrescAmt)
		set ^CacheTemp(repid, ind) = data
		set ind = ind + 1
	}
	k prescNoInfo
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:	当前季度抗菌药物占比
/// Creater:	wwl
/// CreateDate:	2017-06-28
/// Input:		StDate-开始日期,EndDate-结束日期,Phl-药房,StTime-开始时间,EndTime-结束时间
/// d ##Class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetDispStatAntibiotic","2019","1","ALL","Loc","2")
Query GetDispStatAntibiotic(Year As %String = "", InputQuarter As %String = "", ParType As %String = "", ParTypeo As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "n,Type:%String,Amt:%Numeric,AnAmt:%Numeric,Pro:%Float,TAdmType:%String") [ SqlProc ]
{
}

ClassMethod GetDispStatAntibioticExecute(ByRef qHandle As %Binary, Year As %String = "", InputQuarter As %String = "", ParType As %String = "", ParTypeo As %String = "", HOSPID As %String = "") As %Status
{
	s Year=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(Year)
	s InputQuarter=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(InputQuarter)
	s ParType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(ParType)
	s ParTypeo=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(ParTypeo)
	s HOSPID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(HOSPID)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    Q:Year="" $$$OK
    Q:(ParType="")&&(ParTypeo="") $$$OK
    s StDate=$s(InputQuarter=1:Year_"-01-01",InputQuarter=2:Year_"-04-01",InputQuarter=3:Year_"-07-01",InputQuarter=4:Year_"-10-01",1:Year_"01-01")
    s EndDate=$s(InputQuarter=1:Year_"-03-31",InputQuarter=2:Year_"-06-30",InputQuarter=3:Year_"-09-30",InputQuarter=4:Year_"-12-31",1:+$h)
    s stDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s enDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate) 
	s typeStr="P^Y^F^H^HC^PH^FH^YH^HH^HHC"
	s pid=..NewPid()
	d ..ClearTmp("GetDispStatAntibiotic",pid)  
	s n=0
	s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.f date=stDate:1:enDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s LocID=$$LOC^ST01(inclb)
	...s hospdr=$P(^CTLOC(LocID),"^",22)
	...q:(HOSPID'="")&&(HOSPID'=hospdr)
	...s inci=+inclb
	...s admTypeStr=##class(web.DHCST.ReportForms.ReportCommon).GetTransAdmType(intr)
	...s admType=$p(admTypeStr,"^",1)
	...s ordDept=$p(admTypeStr,"^",2)
	...q:ordDept=""
	...s ordDesc=$p(^CTLOC(ordDept),"^",2)
	...s:$f(ordDesc,"-") ordDesc=$p(ordDesc,"-",2)
	...q:(ParType'="ALL")&&(admType'=ParType)
	...s spAmt=$p(^DHCINTR(intr),"^",8)
	...s PhcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
	...s AntibioticFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PhcdfId)  
	...s anAmt=$s(AntibioticFlag="Y":+spAmt,1:"")
	...s n=n+1
	...s data=spAmt_"^"_anAmt_"^"_admType
	...i ParTypeo="Loc" s indexTotal=ordDesc
	...e  s indexTotal=admType
	...
	...i $D(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal)) d
	....s $p(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal),"^",1)=$p(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal),"^",1)+spAmt
	....s $p(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal),"^",2)=$p(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal),"^",2)+anAmt 
	...e   d
	....s ^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,indexTotal)=data
	...
	..
	.    
    s admType="",n=0
    f   s admType=$o(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType)) q:admType=""  d
    .s h=""
    .f  s h=$o(^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,h)) q:h=""  d
    ..s data=^TMP("DHCST",$this,"GetDispStatAntibiotic",pid,admType,h)
    ..s amt=+$p(data,"^",1)
    ..q:amt=0
    ..s anAmt=+$p(data,"^",2)
    ..s pro=$s(amt'=0:anAmt/amt,1:0)
    ..s tmpType=h
    ..s tmpType=$s(h="E":"急诊",h="O":"门诊",h="I":"住院",h="H":"体检",1:h)
    ..s n=n+1
    ..d OutRowItm
    .
	d ..ClearTmp("GetDispStatAntibiotic",pid)	   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(n,tmpType,-amt,-anAmt,pro,admType)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// Description：按医嘱大类通过台账统计各科室各医生不通类型的处方数量(这里只统计门诊发药和住院发药业务)
/// Creator：WangYaJun
/// CreateDate：2017-12-25
/// Input：开始日期、结束日期、就诊类型:  门诊：O   住院：I   全部：All
/// OutPut：
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryDispPrescType","2018-07-01","2018-08-02","I")
Query QueryDispPrescType(StDate As %String = "", EndDate As %String = "", AdmType As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Loc:%String,User:%String,LocDesc:%String,DocDesc:%String,XYNum:%String,ZCHYNum:%String,ZCYNum:%String,XCHYNum:%String,ZZYNum:%String,CountPresc:%String,ZSJNum:%String,KJYNum:%String,DocCode:%String") [ SqlProc ]
{
}

ClassMethod QueryDispPrescTypeExecute(ByRef QHandle As %Binary, StDate As %String = "", EndDate As %String = "", AdmType As %String = "", HOSPID As %String = "") As %Status
{
	s StDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s AdmType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(AdmType)
    Set repid=$I(^CacheTemp)
    Set QHandle=$lb(0,repid,0)
    s ind=1
    //s ^hlh($h)=$lb(StDate,EndDate,AdmType)
	s StDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    
    s pid=..NewPid()
    d ..ClearTmp("QueryDispPrescType",pid)
    s TypeStr="F^P^FH^HH"
    s:AdmType="O" TypeStr="F^FH"
    s:AdmType="I" TypeStr="P^HH"
    s Len=$l(TypeStr,"^")
    f i=1:1:Len d
    .s Type=$p(TypeStr,"^",i)
    .f IntrDate=StDate:1:EndDate d
    ..s Intr=""
    ..f  s Intr=$o(^DHCINTR(0,"TypeDate",Type,IntrDate,Intr)) q:Intr=""  d
    ...s inclb=$p(^DHCINTR(Intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤 
    ...s XYFlag=0,ZCHYFlag=0,ZCYFlag=0,ZZYFlag=0,XCHYFlag=0,Count=0,ZSJFlag=0,KJYFlag=0
    ...s Pointer=$p(^DHCINTR(Intr),"^",9)
    ...s Inci=$p(^DHCINTR(Intr),"^",15)
    ...s PrescNo=##class(web.DHCST.ReportForms.ReportCommon).GetPrescNo(Pointer,Type)
    ...q:PrescNo=""
    ...q:$d(^TMP("DHCST",$this,"QueryDispPrescType",pid,"PrescNo",PrescNo))
    ...s RetStr=..GetDepLocDocByPrescNo(PrescNo)
    ...s ^TMP("DHCST",$this,"QueryDispPrescType",pid,"PrescNo",PrescNo)=""    ;标记此处方已处理过
    ...s DocId=$p(RetStr,"^",1)
    ...s DocName=$p(RetStr,"^",2)
    ...s DepId=$p(RetStr,"^",3)
    ...s DepDesc=$p(RetStr,"^",4)
    ...s PrescType=$p(RetStr,"^",5)
    ...s ZSJflag=$p(RetStr,"^",6)
    ...s KJYflag=$p(RetStr,"^",7)
    ...s Count=1
    ...s:PrescType="西药" XYFlag=1        
    ...s:PrescType="中成药" ZCHYFlag=1
    ...s:PrescType="中草药" ZCYFlag=1
    ...s:PrescType="西成药" XCHYFlag=1
    ...s:PrescType="自制药" ZZYFlag=1
    ...s:ZSJflag=1 ZSJFlag=1       ;注射剂
    ...s:KJYflag=1 KJYFlag=1       ;抗菌药标记
    ...s DataStr=XYFlag_"^"_ZCHYFlag_"^"_ZCYFlag_"^"_XCHYFlag_"^"_ZZYFlag_"^"_Count_"^"_ZSJFlag_"^"_KJYFlag
    ...i '$d(^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",DepId,DocId)) d
    ....s ^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",DepId,DocId)=DataStr
    ...e  d
    ....s SS=$g(^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",DepId,DocId))
    ....s $p(SS,"^",1)=$p(SS,"^",1)+XYFlag
    ....s $p(SS,"^",2)=$p(SS,"^",2)+ZCHYFlag
    ....s $p(SS,"^",3)=$p(SS,"^",3)+ZCYFlag
    ....s $p(SS,"^",4)=$p(SS,"^",4)+XCHYFlag
    ....s $p(SS,"^",5)=$p(SS,"^",5)+ZZYFlag
    ....s $p(SS,"^",6)=$p(SS,"^",6)+Count
    ....s $p(SS,"^",7)=$p(SS,"^",7)+ZSJFlag
    ....s $p(SS,"^",8)=$p(SS,"^",8)+KJYFlag
    ....s ^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",DepId,DocId)=SS
    s Loc=""
    f  s Loc=$o(^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",Loc)) q:Loc=""  d
    .s User=""
    .f  s User=$o(^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",Loc,User)) q:User=""  d
    ..s OutStr=$g(^TMP("DHCST",$this,"QueryDispPrescType",pid,"DocLoc",Loc,User)) 
    ..s LocDesc=$p(^CTLOC(Loc),"^",2)
    ..s:$F(LocDesc,"-") LocDesc=$p(LocDesc,"-",2)
    ..s DocDesc=$p(^SSU("SSUSR",User),"^",2)
    ..s DocCode=$p(^SSU("SSUSR",User),"^",1)   ;医生工号
    ..s XYNum=$p(OutStr,"^",1)
    ..s ZCHYNum=$p(OutStr,"^",2)
    ..s ZCYNum=$p(OutStr,"^",3)
    ..s XCHYNum=$p(OutStr,"^",4)
    ..s ZZYNum=$p(OutStr,"^",5)
    ..s CountPresc=$p(OutStr,"^",6)
    ..s ZSJNum=$p(OutStr,"^",7)
    ..s KJYNum=$p(OutStr,"^",8)
    ..s Data=$lb(Loc,User,LocDesc,DocDesc,XYNum,ZCHYNum,ZCYNum,XCHYNum,ZZYNum,CountPresc,ZSJNum,KJYNum,DocCode)
    ..d OutPutRow
    .
 	d ..ClearTmp("QueryDispPrescType",pid)
    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit $$$OK
}

/// Description：住院门诊业务工作量统计
/// Creator:WangYaJun
/// CreatDate：2017-12-20
/// Updater		zhaozhiduan
/// UpdateDate	2021.09.07
/// InPut：开始日期、结束日期、药房科室ID
/// OutPut：
/// Other： d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","InAndOutWorkStat","2023-01-06","2023-02-06","183","")
Query InAndOutWorkStat(StDate As %String = "", EndDate As %String = "", Loc As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "UserName:%String,PInci:%Integer,YInci:%Integer,FInci:%Integer,HInci:%Integer,PPresc:%Integer,YPresc:%Integer,FPresc:%Integer,HPresc:%Integer,PAmt:%Float,YAmt:%Float,FAmt:%Float,HAmt:%Float,PFactor:%Integer,YFactor:%Integer,FFactor:%Integer,HFactor:%Integer") [ SqlProc ]
{
}

ClassMethod InAndOutWorkStatExecute(ByRef QHandle As %Binary, StDate As %String = "", EndDate As %String = "", Loc As %String = "", HOSPID As %String = "") As %Status
{
	//tro
	//s ^PHATMP("MYQ", $this, "InAndOutWorkStat") = $lb(StDate, EndDate, Loc, HOSPID)
    Set repid=$I(^CacheTemp)
    Set QHandle=$lb(0,repid,0)
	q:((StDate="")||(EndDate="")||(Loc="")) $$$OK
	s StDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s Loc=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(Loc)
    s ind=1
    s pid=..NewPid()
    d ..ClearTmp("InAndOutWorkStat",pid)
	s StDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s TypeStr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
    s Len=$l(TypeStr,"^")
    s PrescNum=0
    f i=1:1:Len d
    .s Type=$p(TypeStr,"^",i)
    .f IntrDate=StDate:1:EndDate d
    ..s Intr=""
    ..f  s Intr=$o(^DHCINTR(0,"LOCTYPEDATE",Loc,Type,IntrDate,Intr)) q:Intr=""  d
    ...s inclb=$p(^DHCINTR(Intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
    ...s PInci=0,YInci=0,FInci=0,HInci=0      ;品种数
    ...s PPresc=0,YPresc=0,FPresc=0,HPresc=0  ;处方数
    ...s PAmt=0,YAmt=0,FAmt=0,HAmt=0          ;金额
    ...s PFactor=0,YFactor=0,FFactor=0,HFactor=0
    ...s Inci=$p(^DHCINTR(Intr),"^",15)
    ...s User=$p(^DHCINTR(Intr),"^",11)
    ...s Pointer=$p(^DHCINTR(Intr),"^",9)
    ...s IntrAmt=$p(^DHCINTR(Intr),"^",8)    ;售价金额 
    ...s prescNo=##class(web.DHCST.ReportForms.ReportCommon).GetPrescNo(Pointer,Type)
    ...i User="" s User="*"
    ...i prescNo="" s prescNo="*"
    ...s (prescNum,incNum,cyFactor)=0
    ...i '$d(^TMP("DHCST",$this,"InAndOutWorkStat",pid,Type_"Presc",User,prescNo)) d
    ....s quitFlag=0
    ....i Type="H" d
    .....s cancleDate=$p(^DHCPHRET(+Pointer),"^",20)
    .....i (cancleDate>=StDate)&&(cancleDate<=EndDate) s quitFlag=1
    ....i Type="HC" d
    .....s retDate=$p(^DHCPHRET(+Pointer),"^",2)
    .....i (retDate>=StDate)&&(retDate<=EndDate) s quitFlag=1
    ....q:quitFlag=1
    ....s ^TMP("DHCST",$this,"InAndOutWorkStat",pid,Type_"Presc",User,prescNo)=""
    ....s prescNum=1
    ....s cyFactor=##class(web.DHCST.ReportForms.ReportCommon).GetZCYFactor(prescNo)
    ...i '$d(^TMP("DHCST",$this,"InAndOutWorkStat",pid,Type_"Inci",User,+Pointer,Inci)) d
    ....s ^TMP("DHCST",$this,"InAndOutWorkStat",pid,Type_"Inci",User,+Pointer,Inci)=""
    ....s incNum=1
    ...
    ...i (Type="P")||(Type="PH") d
    ....s PPresc=prescNum
    ....s PInci=incNum
    ....s PAmt=(-1)*IntrAmt
    ....s PFactor=cyFactor
    ...i (Type="Y")||(Type="YH") d
    ....s YPresc=prescNum
    ....s YInci=incNum
    ....s YAmt=IntrAmt
    ....s YFactor=cyFactor
    ...i (Type="F")||(Type="FH") d
    ....s FPresc=prescNum
    ....s FInci=incNum
    ....s FAmt=(-1)*IntrAmt
    ....s FFactor=cyFactor
    ...i (Type="H")||(Type="HC")||(Type="HH") d
    ....i Type="HC" d
    .....s HPresc=prescNum*(-1)
    .....s HInci=incNum*(-1)
    .....s HAmt=IntrAmt
    .....s HFactor=cyFactor*(-1)
    ....e  d
    .....s HPresc=prescNum
    .....s HInci=incNum
    .....s HAmt=IntrAmt
    .....s HFactor=cyFactor
    ...//w Type_","_Pointer_","_prescNo_","_Intr_","_prescNum,!
    ...s UserName=$p($g(^SSU("SSUSR",+User)),"^",2)
    ...i '$d(^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",User)) d
    ....s statData=$lb(PInci,YInci,FInci,HInci,PPresc,YPresc,FPresc,HPresc,PAmt,YAmt,FAmt,HAmt,PFactor,YFactor,FFactor,HFactor)
    ....s ^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",User)=statData
    ...e  d
    ....s statData=$lb(PInci,YInci,FInci,HInci,PPresc,YPresc,FPresc,HPresc,PAmt,YAmt,FAmt,HAmt,PFactor,YFactor,FFactor,HFactor)
    ....s gloData=^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",User)
    ....s gloDataLen=$ll(gloData)
    ....f gloDataI=1:1:gloDataLen d
    .....s $list(gloData,gloDataI)=$list(gloData,gloDataI)+$list(statData,gloDataI)
    ....s ^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",User)=gloData	//statData
    ....
	..
	.   
    s UserId=""
    f  s UserId=$o(^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",UserId)) q:UserId=""  d
    .s OutStr=$g(^TMP("DHCST",$this,"InAndOutWorkStat",pid,"User",UserId))
    .s userName="空"
    .i +UserId'=0 s userName=$p($g(^SSU("SSUSR",+UserId)),"^",2)
    .s Data=$lb(userName)_OutStr
    .d OutRow
    d ..ClearTmp("InAndOutWorkStat",pid)
    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetAllDispStatData","1/8/2018^21/8/2018^^^1^^N^^2")
Query GetAllDispStatData(input As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "n,incicode,incidesc,qty:%Double,rp:%Double,sp:%Double,rpamt:%Double,spamt:%Double,docloc,ward,puomqty:%Double,packuomqty,buomdesc,puomdesc,vendor,vendordesc,gene,spec") [ SqlProc ]
{
}

ClassMethod GetAllDispStatDataExecute(ByRef qHandle As %Binary, input = "", HOSPID As %String = "") As %Status
{
	s input=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(input)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:input="" $$$OK
    s HOSPID=$p(input,"^",9)
    s perv="^^^Drug^"_HOSPID_"^DHC"
    s ret=..DispStatAll(input,HOSPID)    
    s pid=$p(ret,"^",1)
    s cnt=$p(ret,"^",2)    
    s n=0
    s h=""
    f  s h=$o(^TMP("DHCST",$this,"DispStatAll",pid,h)) q:h=""  d
    .s data=^TMP("DHCST",$this,"DispStatAll",pid,h)
    .s incicode=$p(data,"^",1)
    .s incidesc=$p(data,"^",2)
    .s qty=$p(data,"^",3) q:qty=0
    .s rp=$p(data,"^",4)
    .s sp=$p(data,"^",5)
    .s rpamt=$p(data,"^",6)
    .s spamt=$p(data,"^",7)
    .s docloc=$p(data,"^",8)
    .i $f(docloc,"-") s docloc=$p(docloc,"-",2)
    .s ward=$p(data,"^",9)
    .s packfac=$p(data,"^",10)
    .s inci=$p(data,"^",11)
    .s puomqty=qty/packfac
    .s packuomqty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
    .s buomdesc=$p(data,"^",12)
    .s puomdesc=$p(data,"^",13)
    .s vendor=$p(data,"^",14)
    .s vendordesc=$p(data,"^",15)
    .// 价格转换仅用于显示,输出时转换,遍历台账时不转换,严重影响速度
    .s sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(sp,perv,"FmtRP",1)
    .s rp=##Class(web.DHCSTCOMMPARA).GetNumbDec(rp,perv,"FmtRP",1)
    .s geneStr=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
    .s gene=$p(geneStr,"^",2)
    .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
    .s n=n+1
    .d OutRowItm
    d ..ClearTmp("DispStatAll",pid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(n,incicode,incidesc,qty,rp,sp,rpamt,spamt,docloc,ward,puomqty,packuomqty,buomdesc,puomdesc,vendor,vendordesc,gene,spec)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// Description	基本药物在销售里面的比例
/// Creator		zhaozhiduan
/// CreatDate	2014-07-16
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetDispStat","1/2/2019^18/2/2019^^^4^^N^^2")
Query GetDispStat(input As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "n,code,rpamt:%Double,spamt:%Double,basicrptotal:%Double,basicsptotal:%Double,rpratio:%Double,spratio:%Double") [ SqlProc ]
{
}

ClassMethod GetDispStatExecute(ByRef qHandle As %Binary, input = "", HOSPID As %String = "") As %Status
{
	s input=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(input)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1 
    q:input="" $$$OK
    s hospId=$p(input,"^",9)
    s perv="^^^Drug^"_hospId_"^DHC"
    s ret=..StatBasicInDrugALL(input,HOSPID)    
    s pid=$p(ret,"^",1)
    s cnt=$p(ret,"^",2)    
    s n=0
    s h=""
    f  s h=$o(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,h)) q:h=""  d
    .s data=^TMP("DHCST",$this,"StatBasicInDrugALL",pid,h)
    .s code=$p(data,"^",1)
    .i code["-" s code=$p(code,"-",2)
    .s rptotal=$p(data,"^",2)
    .s sptotal=$p(data,"^",3)
    .// 价格转换仅用于显示,输出时转换,遍历台账时不转换,严重影响速度
    .s sptotal=##Class(web.DHCSTCOMMPARA).GetNumbDec(sptotal,perv,"FmtRP",1)
    .s rptotal=##Class(web.DHCSTCOMMPARA).GetNumbDec(rptotal,perv,"FmtRP",1)
    .q:sptotal=0
    .s basicrptotal=$p(data,"^",4)
    .s basicsptotal=$p(data,"^",5)
    .i +rptotal'=0  s rpratio=$fn((basicrptotal/rptotal),"",4)
    .e  i +basicrptotal=0  s rpratio=0
    .e  s rpratio=1
    .i +sptotal'=0 s spratio=$fn((basicsptotal/sptotal),"",4)
    .e  i +basicsptotal=0  s spratio=0
    .e  s spratio=1
    .s n=n+1
    .d OutRowItm
    d ..ClearTmp("StatBasicInDrugALL",pid)
    //i ind=1 d OutRowItmOne
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(n,code,rptotal,sptotal,basicrptotal,basicsptotal,rpratio,spratio)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
OutRowItmOne
    set Data=$lb("","",0,0,0,0,0,0)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// description:牡丹江患者处方统计,可多选剂型,科室,以及药学分类
/// creator:	yunhaibao
/// createdate:	20140725
/// Output:		药物金额是抗菌,抗肿瘤,处方张数,药物使用人数,处方使用率,处方金额,药物金额,金额率
/// Return:		
/// Others:		处方比率综合查询
/// othser:
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryTypeDrugList","2020-05-22","2020-06-22","","","")
Query QueryTypeDrugList(startdate As %String = "", enddate As %String = "", locstr As %Text = "", jxstr As %Text = "", phccatstr As %Text = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "oitype:%String,presccount:%String,anticount:%String,countperc:%String,prescamount:%String,antiamount:%String,amountperc:%String") [ SqlProc ]
{
}

ClassMethod QueryTypeDrugListExecute(ByRef QHandle As %Binary, startdate As %String = "", enddate As %String = "", locstr As %Text = "", jxstr As %Text = "", phccatstr As %Text = "", HOSPID As %String = "") As %Status
{
	s startdate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(startdate)
	s enddate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(enddate)
	s locstr=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(locstr)
	s jxstr=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(jxstr)
	s phccatstr=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(phccatstr)
	//s ^YSJTMP("QueryTypeDrugList")=$LB(startdate , enddate, locstr , jxstr , phccatstr,HOSPID)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	//s ^hlh($h)=$lb(startdate,enddate,locstr,jxstr,phccatstr)
	s loclist=$lfs(locstr)
	s jxlist=$lfs(jxstr)
	s PhcCatAll=$p(phccatstr,",")
	s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startdate)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s pid=..NewPid()
	d ..ClearTmp("QueryTypeDrugList",pid)
	//s typestr=..#DispTypeStr	//"F^P^FH^PH"  //门诊发药,住院发药
	s allTypestr=..#OutDispTypeStr_"-"_..#InDispTypeStr
	s tpresccount=0,tprescamount=0,tanticount=0,tantiamount=0
	s date=""
	f j=1:1:$l(allTypestr,"-") d
	.s presccount=0,prescamount=0,anticount=0,antiamount=0
	.s typestr=$p(allTypestr,"-",j)
	.f x=1:1:$l(typestr,"^") d
	..s intrtype=$p(typestr,"^",x)
	..f date=startdate:1:enddate d
	...s intr=""
	...f  s intr=$o(^DHCINTR(0,"TypeDate",intrtype,date,intr)) q:intr=""  d
	....s inclb=$p(^DHCINTR(intr),"^",7)
	....q:inclb=""
	....s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	....q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	....s inci=$p(^DHCINTR(intr),"^",15)
	....s inclb=$p(^DHCINTR(intr),"^",7)
	....s pointer=$p(^DHCINTR(intr),"^",9)
	....s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,intrtype)
	....q:oeori=""
	....s qty=-$p(^DHCINTR(intr),"^",6)
	....s cost=-$p(^DHCINTR(intr),"^",8)
	....s dept=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",3)
	....q:(locstr'="")&&($lf(loclist,dept)=0)
	....s retflag=""
	....i PhcCatAll'="" d
	.....s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inci)
	.....s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.....s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.....s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	....q:(PhcCatAll'="")&&(retflag=0) 
	....s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
	....;剂型DR
	....s dosagedr=""
	....s:jxstr'="" dosagedr=$p(##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(Phcdf),"^",3)
	....q:(jxstr'="")&&($lf(jxlist,dosagedr)=0)
	....s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	....s posion=$p(##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci),"^",3)
	....s PHCDFAntibioticFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(Phcdf)
	....i '$d(^TMP("DHCST",$this,"QueryTypeDrugList",pid,prescno)) d
	.....s presccount=presccount+1  ;处方张数
	.....s prescamount=prescamount+cost  ;处方金额
	.....s tpresccount=tpresccount+1   ;合计
	.....s tprescamount=tprescamount+cost  ;合计
	.....i PHCDFAntibioticFlag="Y" d 
	......s ^TMP("DHCST",$this,"QueryTypeDrugList","PHCDFAntibioticFlag",pid,prescno)=""
	......s anticount=anticount+1 ;抗菌的张数
	......s antiamount=antiamount+cost  ;抗菌金额
	......s tanticount=tanticount+1   ;抗菌的张数合计
	......s tantiamount=tantiamount+cost  ;抗菌金额合计
	......
	....e  d
	.....s prescamount=prescamount+cost  ;处方金额
	.....s tprescamount=tprescamount+cost  ;合计
	.....
	.....i PHCDFAntibioticFlag="Y" d 
	......s antiamount=antiamount+cost  ;抗菌金额
	......s tantiamount=tantiamount+cost  ;抗菌金额合计
	......i '$d(^TMP("DHCST",$this,"QueryTypeDrugList","PHCDFAntibioticFlag",pid,prescno)) d
	.......s anticount=anticount+1 ;抗菌的张数
	.......s tanticount=tanticount+1   ;抗菌的张数合计
	......
	.....
	....s ^TMP("DHCST",$this,"QueryTypeDrugList",pid,prescno)=""  
	.i (j=1)&(presccount'=0)&(prescamount'=0) d  //门诊
	..s Data=$lb("门诊",presccount,anticount,$fn((anticount/presccount)*100,"",2)_"%",prescamount,antiamount,$fn((antiamount/prescamount)*100,"",2)_"%")   
	..S ^CacheTemp(repid,ind)=Data	
	..S ind=ind+1
	.i (j=2)&(presccount'=0)&(prescamount'=0) d  //住院
	..s Data=$lb("住院",presccount,anticount,$fn((anticount/presccount)*100,"",2)_"%",prescamount,antiamount,$fn((antiamount/prescamount)*100,"",2)_"%")   
	..S ^CacheTemp(repid,ind)=Data	
	..S ind=ind+1
	i (tpresccount'=0)&(tprescamount'=0) d
	.s Data=$lb("合计",tpresccount,tanticount,$fn((tanticount/tpresccount)*100,"",2)_"%",tprescamount,tantiamount,$fn((tantiamount/tprescamount)*100,"",2)_"%")   
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	d ..ClearTmp("QueryTypeDrugList",pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------Start-------//////
/// Description：管制药品处方登记表
/// Creator：Yanbl
/// CreateDate：2019-08-15
/// Input：开始日期、结束日期、科室、管制分类、药品
/// OutPut：发药日期	处方编号	患者姓名	数量	批号	备注	
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryPoisonDetail","2019-10-01","2019-11-02","162","3","")
Query QueryPoisonDetail(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Poison As %String = "", IncRowid As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "OutDate:%String,InciDesc:%String,Spec:%String,PurchCTUomDesc:%String,PrescNo:%String,PatName:%String,Qty:%String,BatNo:%String") [ SqlProc ]
{
}

ClassMethod QueryPoisonDetailExecute(ByRef QHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Poison As %String = "", IncRowid As %String = "", HOSPID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set QHandle=$lb(0,repid,0)
    s ind=1
    
	s StartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	q:LocId="" $$$OK
	q:Poison="" $$$OK
	s TransTypeStr="P,Y,F,H,HC,PH,YH,FH,HH,HHC"
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.q:(IncRowid'="")&&(IncRowid'=Inci)
	.s Ch=$o(^INCI("IL_LOC",LocId,Inci,""))
	.q:Ch=""     ; not find the item in this loc
	.s PoisonInci=$p(##class(web.DHCSTCOMMONSRV).getPoisonByInci(Inci),"^",1)
	.q:Poison'=PoisonInci
	.s Incil=Inci_"||"_Ch
	.f date=StartDate:1:EndDate  d
	..s intr="" 
 	..f  s intr=$o(^DHCINTR(0,"INCI",Inci,date,intr)) q:intr=""  d
 	...q:'$d(^DHCINTR(intr))
 	...s Inclb=$p(^DHCINTR(intr),"^",7)
 	...q:Inclb=""
	...s tmploc=$P(^INCI(+Inclb,"IL",$P(Inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
 	...s TmpIncil=$p(Inclb,"||",1,2)
 	...q:Incil'=TmpIncil 
 	...s type=$p(^DHCINTR(intr),"^",1)
 	...q:TransTypeStr'[type
 	...s pointer=$p(^DHCINTR(intr),"^",9)  //pointer
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s ord=+oeori,chl=$P(oeori,"||",2)
	...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",chl))
	...s Incib=$p(^INCI(Inci,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	...s BatNo=""
	...i Incib'=""  d
 	....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	...s PatName=$p(..GetOrdInfo(oeori),"^",1) 
	...s PrescNo=$p(..GetOrdInfo(oeori),"^",2)
	...s Qty=$p(^DHCINTR(intr),"^",6)
	...s Uom=$p(^DHCINTR(intr),"^",10)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uom,BUomId)
	...s Qty=Qty*Fac
	...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	...s PurUomId=$p(^INCI(Inci,3),"^",6)
	...s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	...s InciDesc = $p(^INCI(Inci,1),"^",2)
	...s Qty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,Qty)    
	...s OutDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
	...s Data=$lb(OutDate,InciDesc,Spec,PurchCTUomDesc,PrescNo,PatName,Qty,BatNo)
	...d OutPutRow

    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit $$$OK
}

/// Description：管制药品统计
/// Creator：Yanbl
/// CreateDate：2019-08-15
/// Input：开始日期、结束日期、科室、管制分类、药品
/// OutPut：日期 药品名称 规格 单位 入库数量 消耗数量 日结数
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryPoisonStat","2018-07-01","2019-11-02","162","3","")
Query QueryPoisonStat(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Poison As %String = "", IncRowid As %String = "") As websys.Query(ROWSPEC = "OutDate:%String,InciDesc:%String,Spec:%String,PurchCTUomDesc:%String,TrfQty:%String,DispQty:%String,EndQty:%String") [ SqlProc ]
{
}

ClassMethod QueryPoisonStatExecute(ByRef QHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Poison As %String = "", IncRowid As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set QHandle=$lb(0,repid,0)
    s ind=1
    
	s StartDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	q:LocId="" $$$OK
	q:Poison="" $$$OK
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	i LocDesc["库"  d
	.s TrfStr="G,R"
	.s DispStr="T,K"
	e  d
	.s TrfStr="T,K"
	.s DispStr="P,Y,F,H,HC,PH,YH,FH,HH"
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.q:(IncRowid'="")&&(IncRowid'=Inci)
	.s Ch=$o(^INCI("IL_LOC",LocId,Inci,""))
	.q:Ch=""     ; not find the item in this loc
	.s PoisonInci=$p(##class(web.DHCSTCOMMONSRV).getPoisonByInci(Inci),"^",1)
	.q:Poison'=PoisonInci
	.s Incil=Inci_"||"_Ch
	.f date=StartDate:1:EndDate  d
	..s TrfQty=-##class(web.DHCST.INPurPlanAuxByConsume).CalcLocItmDispQty(Incil,date,date,TrfStr)
	..s DispQty=-##class(web.DHCST.INPurPlanAuxByConsume).CalcLocItmDispQty(Incil,date,date,DispStr)
	..q:(TrfQty=0)&&(DispQty=0)
	..s EndQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,LocId,date)
	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s InciDesc = $p(^INCI(Inci,1),"^",2)
	..s TrfQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,TrfQty)  
	..s DispQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,DispQty)  
	..s EndQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,EndQty)  
	..s OutDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date)
	..s Data=$lb(OutDate,InciDesc,Spec,PurchCTUomDesc,TrfQty,DispQty,EndQty)
	..d OutPutRow

    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit $$$OK
}

/// 门诊基本药物比例
/// 入参 时间
/// 出参 就诊人数 基本药物使用人数 占比 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetOutStatData","2020-06-01","2020-06-12",2)
Query GetOutStatData(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "admnum:%Double,basicnum:%Double,ratio:%Double") [ SqlProc ]
{
}

ClassMethod GetOutStatDataExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	//s ^YSJTMP("GetOutStatDataExecute")=$LB(StartDate,EndDate)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    i StartDate=""  q $$$OK
	i EndDate=""   q $$$OK
	
    s Str=..StatData(StartDate,EndDate,"O",HOSPID)
    s admnum=$P(Str,"^",1)
    s basicnum=$P(Str,"^",2)
    i basicnum=0 s ratio=0
    e  s ratio=basicnum/admnum
	set Data=$lb(admnum,basicnum,ratio)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit $$$OK
}

/// 住院基本药物比例
/// 入参 时间
/// 出参 出院总人数 基本药物使用人数 占比 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetPhaStatData","2019-10-01","2019-10-09")
Query GetPhaStatData(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "admnum:%Double,basicnum:%Double,ratio:%Double") [ SqlProc ]
{
}

ClassMethod GetPhaStatDataExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	//s ^hlh($h)=$lb(input)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    i StartDate=""  q $$$OK
	i EndDate=""   q $$$OK
    s Str=..StatData(StartDate,EndDate,"I",HOSPID)
    s admnum=$P(Str,"^",1)
    s basicnum=$P(Str,"^",2)
    i basicnum=0 s ratio=0
    e  s ratio=basicnum/admnum
	set Data=$lb(admnum,basicnum,ratio)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit $$$OK
}

/// w ##class(web.DHCST.ReportForms.AllPharmacyStat).StatData("2020-06-01","2020-06-12","I",2)
ClassMethod StatData(StartDate As %String, EndDate As %String, Flag As %String, HOSPID = "")
{
	i StartDate=""  q $$$OK
	i EndDate=""   q $$$OK
	i Flag=""   q $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 	s PhaLocStr=##Class(web.DHCST.ReportForms.ReportCommon).GetPhaLocStr(HOSPID)
 	s OutLocStr=##Class(web.DHCST.ReportForms.ReportCommon).GetOutLocStr(HOSPID)
 	s admnum=0,basicnum=0
 	i Flag="O" d
 	.s LocStr=OutLocStr
 	.s indexcode="PAADM_AdmDate"
 	i Flag="I" d
 	.s LocStr=PhaLocStr
 	.s indexcode="DischDate"
 	
 	f date=StartDate:1:EndDate d
	.s adm=""
	.f  s adm=$o(^PAADMi(indexcode,date,adm)) q:adm=""  d
	..s admtype=$p(^PAADM(adm),"^",2)
	..s deploc=$P(^PAADM(adm),"^",4)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(deploc),"^",22))
    ..q:(Flag="I")&&(admtype'="I")
    ..q:(Flag="O")&&(admtype="I")
	..s ord=$o(^OEORD(0,"Adm",adm,""))
	..q:ord=""
	..q:LocStr=""
	..s exit=0
	..f i=1:1:$l(LocStr,"^") d
	...s recdpdr=$p(LocStr,"^",i)
	...s chl=""
	...f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:(chl="")||(exit=1)  d
	....s orditm=ord_"||"_chl
    ....s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
    ....q:qty=0
    ....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s arcVer=$p(arcimid,"||",1)
	....s arcSub=$p(arcimid,"||",2)
	....s arcItmCatId=$p($g(^ARCIM(arcVer,arcSub,1)),"^",10)
 	....q:$p($g(^ARC("IC",+arcItmCatId)),"^",7)'="R"
 	....s phcdfId=$p(^ARCIM(arcVer,arcSub,1),"^",12)
 	....s phcdId=+phcdfId
	....s tmpinci=$o(^INCI(0,"ARCIM_DR",arcVer,"") ) 
	....q:tmpinci=""  //医嘱名称
	....s basflag=""
	....;s infor=$o(^DHCITMINFO(0,"INCI",tmpinci,""))
	....;i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	....s basflag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf(phcdfId)		// 基本药物
	....i basflag="Y" s exit=1
	..s admnum=admnum+1
	..s basicnum=basicnum+exit
	
	q admnum_"^"_basicnum
}

/// /////-------
Query StatIngdRec(stdate As %String = "", eddate As %String = "", grpid As %String = "", PhaLoc As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "goodName,geneName,spec,facQty,PurUom,from,inst,qty:%Integer,rp,RpAmt:%Float,Manf,vend,QtyInclb:%Integer,Incib,Index,incicode") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec","2020-06-01","2020-06-10","","","2")
/// zhaoxinlong 统计入库数据,合理用药统计和药库采购上报表通用
/// input:科室。类组 开始日期，结束日期
/// / tips----//存在四舍五入的问题，所有误差较大，不建议和其他报表做数据对比
ClassMethod StatIngdRecExecute(ByRef qHandle As %Binary, stdate As %String = "", eddate As %String = "", grpid As %String = "", PhaLoc As %String = "", HOSPID As %String = "") As %Status
{
	//s ^zhxl("StatIngdRecExecute")=$lb(stdate,eddate,grpid,PhaLoc,HOSPID)

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s pid=..NewPid()
    k ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid)
    Q:(stdate="")||(eddate="") $$$OK
   	s stdate=$zdh(stdate,3)
   	s eddate=$zdh(eddate,3)
   	s:grpid'="" grpid="^"_grpid_"^"
   	i PhaLoc="" s locStr=..GetLocStrByHosp(HOSPID)  //HOSPID
    e  s locStr=PhaLoc
    

   	s type="G"
   	f date=stdate:1:eddate  d
   	.f i=1:1:$l(locStr,"^")  d
   	..s loc=$p(locStr,"^",i) 
   	..q:loc=""  
   	..s intr=""
   	..f  s intr=$o(^DHCINTR(0,"LOCTYPEDATE",loc,type,date,intr))  Q:intr=""  d
   	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s inciloc=$p($g(^INCI(+inclb,"IL",+$p(inclb,"||",2))),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$p($g(^CTLOC(+inciloc)),"^",22))
   	...s Inci=+inclb
   	...s INStkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
   	...s StkGrpId=$p(INStkGrpStr,"^",5)
   	...s StkGrpType=$p(INStkGrpStr,"^",3)
   	...q:StkGrpType'="G"
   	...s StkGrpId="^"_StkGrpId_"^"
   	...Q:'$f(grpid,StkGrpId)&&(grpid'="")
   	...s qty=$p(^DHCINTR(intr),"^",6)
   	...;s pointer=$p(^DHCINTR(intr),"^",9)
   	...s rp=$p(^DHCINTR(intr),"^",16)  //入库单位进价
   	...s uomid=$p(^DHCINTR(intr),"^",10)  //入库单位
   	...s rpAmt=$p(^DHCINTR(intr),"^",17) 
   	...s incib=$p(^INCI(Inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
   	...s PurUomId=$p(^INCI(Inci,3),"^",6)
   	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PurUomId,uomid)
   	...s rp=rp*fac
   	...s qty=qty/fac 
   	...i '$d(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci))   d
   	....s ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci)=qty_"^"_rp_"^"_rpAmt
   	...e  d
   	....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci),"^",1)= $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci),"^",1)+qty
   	....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci),"^",3)= $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci),"^",3)+rpAmt

	//未入库但有库存的单独统计
	f i=1:1:$l(locStr,"^")  d
   	.s loc=$p(locStr,"^",i) 
   	.s Inci=0
	.f  s Inci=$o(^INCI("IL_LOC",loc,Inci))  q:Inci=""  d
	
	..s INStkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
   	..s StkGrpId=$p(INStkGrpStr,"^",5)
   	..s StkGrpType=$p(INStkGrpStr,"^",3)
   	..q:StkGrpType'="G"
   	..s StkGrpId="^"_StkGrpId_"^"
   	..Q:'$f(grpid,StkGrpId)&&(grpid'="")

	..q:$d(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci)) 
	..s sub=""
	..f  s sub=$o(^INCI("IL_LOC",loc,Inci,sub))   q:sub=""  d
	...s incil= Inci_"||"_sub
	...s PurUomId=$p(^INCI(Inci,3),"^",6)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
   	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PurUomId,BUomId)
	...s qty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,loc,eddate)
	...q:qty'>0
	...s rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,eddate,PurUomId,HOSPID,"G","")
	...s rp=rp*fac
	...s rpAmt=rp*qty
	...s ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Inci)=0_"^"_rp_"^"_rpAmt
	
	s Incib=""
   	f  s Incib=$o(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Incib))  Q:Incib=""  d
   	.s qty=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Incib),"^",1)
   	.s rp=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Incib),"^",2)
   	.s RpAmt=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid,Incib),"^",3)
	.d output
	
	k ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","StatIngdRec",pid)
	Set qHandle=$lb(0,repid,0)
	Q $$$OK
output
	s inci=+Incib
	s incicode=$p(^INCI(inci,1),"^",1)
	s incidesc=$p(^INCI(inci,1),"^",2)
	s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(inci)  //商品名
	s:goodName="" goodName=incidesc
	//s geneName=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
	s geneName=##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inci)
	s geneName=$p(geneName,"^",2)
	s:geneName="" geneName=incidesc
	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	s formStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci)
	s from=$p(formStr,"^",2)
	s buomId=$p(^INCI(inci,1),"^",10)
	s PurUomId=$p(^INCI(inci,3),"^",6)
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PurUomId,buomId)
	;s qty=qty/fac  //大单位数量   先汇总，再转大单位减小误差 
	;s rp=rp*fac
	s PurUom=$p(^CT("UOM",PurUomId),"^",2)
	s:$f(PurUom,"(") PurUom=$p(PurUom,"(",1)
	s Buom=$p(^CT("UOM",buomId),"^",2)
	s phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
	s instStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(phcdf)
	s inst=$p(instStr,"^",2)
	s Manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(Incib),"^",3) 
	s vend=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPbVendor(Incib),"^",2)
	i vend="" s vend=##class(web.DHCST.Common.DrugStkCommon).GetLastVen(Incib)
	i vend["^" s vend=$p(vend,"^",2)
	s facQty=fac_Buom
	//s qty=$fn(qty,"",0)  //_$p(PurUom,"(",1)
	s RpAmt=qty*rp  //存在四舍五入的问题，所有误差较大，不建议和其他报表做数据对比
	//s QtyIncib=..GetIncibQty(Incib,eddate,PhaLoc )  //批次库存
	//s QtyIncib=QtyIncib/fac   //大单位数量 
	s QtyIncib=##class(web.DHCST.Common.DrugStkCommon).IL(Incib,loc,eddate)
	s QtyIncib=QtyIncib/fac
	//s:QtyIncib>0 QtyIncib=$fn(QtyIncib,"",0)  //_$p(PurUom,"(",1)
	s Index=geneName_spec_PurUom_Manf_vend_rp
	set Data=$lb(goodName,geneName,spec,facQty,PurUom,from,inst,qty,rp,RpAmt,Manf,vend,QtyIncib,Incib,Index,incicode)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	q
}

/// creator:zhaoxinlong 20190628 
/// description:统计门诊处方、住院医嘱用药信息，用于合理用药监测上报数据
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","DispStat","2020-08-01","2020-08-7","224","P",2)
/// input:stdate,eddate,loc,type
Query DispStat(stdate As %String = "", eddate As %String = "", loc As %String = "", type As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "cardNo,sex,patage,AdmReason,admLoc,doctor,doctorPt,ICDCode,padiagnose,prescno,ordDate,inciCode,geneName,goodName,spec,facQty,PurUom,from,inst,Manf,doseqtywithUom,freq,qty:%Float,sp:%Float,spAmt:%Float,fyUser,pyUser,pameno,admNum,duration,priDesc,Buom") [ SqlProc ]
{
}

ClassMethod DispStatExecute(ByRef qHandle As %Binary, stdate As %String = "", eddate As %String = "", loc As %String = "", type As %String = "", HOSPID As %String = "") As %Status
{
	
	//s ^YSJTMP("DispStat")=$LB(stdate , eddate , loc , type)
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	Q:(stdate="")||(eddate="")||(loc="") $$$OK
	Q:(type'="P")&&(type'="F") $$$OK
   	s stdate=$zdh(stdate,3)
   	s eddate=$zdh(eddate,3)
   	f date=stdate:1:eddate  d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"LOCTYPEDATE",loc,type,date,intr)) q:intr=""  d
	..s pointer=$p(^DHCINTR(intr),"^",9)
	..s inclb=$p(^DHCINTR(intr),"^",7)
	..q:inclb=""
	..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	..s qty=$p(^DHCINTR(intr),"^",6) 
	..s sp =$p(^DHCINTR(intr),"^",14) 
	..s spAmt=$p(^DHCINTR(intr),"^",8) 
	..s inci=+inclb
	..s incib=$p(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..i type="F"  d
	...s phd=+pointer
	...s oeori=$p(^DHCPHDI(phd,"PHDI",$p(pointer,"||",2)),"^",5)
	...s ord=+oeori
	...s itm=$p(oeori,"||",2)
	...s adm=$P(^OEORD(ord),"^",1)
	...s prescno=$P(^DHCPHDISP(phd,2),"^",1)
	...s papmi=$P(^DHCPHDISP(phd),"^",7)
	...s cardRef=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""))
	...s cardNo=$p(	^DHCCARD("CF",cardRef),"^",2)
	...s patage=##class(PHA.FACE.IN.Com).GetAge(papmi,adm)
	...s sexDr=$p(^PAPER(papmi,"ALL"),"^",7)
	...s sex=$p(^CT("SEX",sexDr),"^",2)
	...s AdmReasonDr=$p(^PAADM(adm,1),"^",7) ;费别
	...s:AdmReasonDr'="" AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
	...s admLocDr=$P(^OEORD(ord,"I",itm,7),"^",2)   //docloc
	...s admLoc=$p(^CTLOC(admLocDr),"^",2)
	...s:$f(admLoc,"-") admLoc=$P(admLoc,"-",2)
	...s ICDCode=..GetICDCode(adm)
	...s padiagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(adm,",") //诊断 
	...s fydr=$p(^DHCPHDISP(phd,1),"^",2)
	...s pydr=$p(^DHCPHDISP(phd,1),"^",3)
	...s fyUserId=$p(^DHCPHPER(fydr),"^",5)
	...s PyUserId=$p(^DHCPHPER(pydr),"^",5)
	...s fyUser=$p(^SSU("SSUSR",fyUserId),"^",1)
	...s pyUser=$p(^SSU("SSUSR",PyUserId),"^",1)
	..e  d
	...s pha=+pointer
	...s adm=$p(^DHCPHAC(pha,"I",$P(pointer,"||",2)),"^",3)
	...s pameno=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(adm,"I") //病历号
	...s admLocDr=$p(^DHCPHAC(pha,"I",$P(pointer,"||",2)),"^",11)
	...s admLoc=$P(^CTLOC(admLocDr),"^",2)
	...s:$f(admLoc,"-") admLoc=$P(admLoc,"-",2)
	...s papmi=$p(^PAADM(adm),"^",1)
	...s admNum=..calAdm(papmi,"I")
	...s oeori=$p(^DHCPHAC(pha,"I",$P(pointer,"||",2)),"^",7)
	...s ord=+oeori
	...s itm=$p(oeori,"||",2)
	...s fydr=$p(^DHCPHAC(pha),"^",5)
	...s fyUser=""
	...s:fydr'="" fyUser=$p(^SSU("SSUSR",fydr),"^",1)
	..d GetoeoriInfo
	..s data=$lb($g(cardNo),$g(sex),$g(patage),$g(AdmReason),admLoc,$g(doctor),$g(doctorPt),$g(ICDCode),$g(padiagnose),$g(prescno),$g(ordDate),$g(inciCode),$g(geneName),$g(goodName),$g(spec),$g(facQty),$g(PurUom),$g(from),$g(inst),$g(Manf),$g(doseqtywithUom),$g(freq),qty,sp,spAmt,fyUser,$g(pyUser),$g(pameno),$g(admNum),$g(duration),$g(priDesc),$g(Buom))
	..set ^CacheTemp(repid,ind)=data
	..set ind=ind+1
	s qHandle=$lb(0,repid,0)
	Quit $$$OK

GetoeoriInfo

	s inciCode=$P(^INCI(inci,1),"^",1)
	s incidesc=$p(^INCI(inci,1),"^",2)
   	s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(inci)  //商品名
   	s:goodName="" goodName=incidesc
   	//s geneName=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
   	s geneName=##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inci)
   	s geneName=$p(geneName,"^",2)
   	s:geneName="" geneName=incidesc
   	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
   	s formStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci)
   	s from=$p(formStr,"^",2)
   	s buomId=$p(^INCI(inci,1),"^",10)
   	s PurUomId=$p(^INCI(inci,3),"^",6)
   	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PurUomId,buomId)
   	//s qty=qty/fac  
   	//s sp=sp*fac
   	s PurUom=$p(^CT("UOM",PurUomId),"^",2)
   	s:$f(PurUom,"(") PurUom=$p(PurUom,"(",1)
   	s Buom=$p(^CT("UOM",buomId),"^",2)
   	s phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
   	s instStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(phcdf)
   	s inst=$p(instStr,"^",2)
   	s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib) 
   	s Manf=$p(VendManf,"^",4)
   	s:$f(Manf,"-") Manf=$P(Manf,"-",2)
   	s facQty=fac_Buom
   	s doseqtywithUom=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)  //s doseqtywithUom=##class(web.DHCSTPCHCOLLDSPPRN).getPackUomDoseQty(ord,itm)
	s freq=$p(##class(PHA.COM.Order).OeoriFreq(oeori), "^", 4)
	s doctor=$P(^OEORD(ord,"I",itm,7),"^",1)
	s doctor=$p(^SSU("SSUSR",doctor),"^",1) //工号
	s doctorProvId=$P(^OEORD(ord,"I",itm,1),"^",11)
	s CarPrtTPId=$p(^CTPCP(doctorProvId,1),"^",4)
	s doctorPt=$p(^CT("CPT",CarPrtTPId),"^",2)  //医生职称	
	s ordDate=$P(^OEORD(ord,"I",itm,3),"^",7)
	s ordDate=$zd(ordDate,3)
	s ordTime=$P(^OEORD(ord,"I",itm,3),"^",15)
	s ordTime=$zt(ordTime)
	s ordDate=ordDate_" "_ordTime
	s duration=$p(^OEORD(ord,"I",itm,2),"^",6)
	i duration'="" s duration=$p(^PHCDU(+duration),"^",3)
	s pri=$p(^OEORD(ord,"I",itm,1),"^",8)
	s priDesc=$p(^OECPR(pri),"^",2)
	q
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------End-------//////
/// //================报表整理====yangsj====2019-10-31======Start==================/////////
/// 发药金额统计(开单科室)
/// 如果要取，发药科室或病区，修改...s ordlocId = ##class(web.DHCSTDISPSTAT).GetDocLoc(orditm)  //开单科室
/// 				为  +..GetWardOrLocByOrd(orditm)   //发药科室
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetDispAmt","2019-12-01","2020-02-23","08:00:00","08:00:00","")
Query GetDispAmt(start As %String = "", end As %String = "", startTime As %String = "", endTime As %String = "", typeStr As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "ordlocDesc,spAmt:%Double,ypAmt:%Double,zjAmt:%Double,cyAmt:%Double,xyAmt:%Double,type") [ SqlProc ]
{
}

ClassMethod GetDispAmtExecute(ByRef qHandle As %Binary, start As %String = "", end As %String = "", startTime As %String = "", endTime As %String = "", typeStr As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	s qHandle=$lb(0,repid,0) 
	q:start="" $$$OK
	q:end="" $$$OK
	;s ^wzl("GetDispAmt")=$lb(start,end,startTime,endTime,typeStr)
	s start=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(start)
    s end=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(end)
    s:typeStr="" typeStr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	s typel=$l(typeStr,"^")
	i startTime'="" s startTime = ##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(startTime)
	i endTime'="" s endTime =##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(endTime)
	s startDate = start
	s endDate = end
	s pid=..NewPid()
	f idate=startDate:1:endDate d
	.f itype=1:1:typel d
	..s type=$p(typeStr,"^",itype)
	..s intrRowId="" f  s intrRowId=$o(^DHCINTR(0, "TypeDate", type, idate, intrRowId))  q:intrRowId=""  d
	...s dhcIntrData=^DHCINTR(intrRowId)
	...s inclb=$p(^DHCINTR(intrRowId),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s tmpTime=$p(dhcIntrData,"^",3)  //台帐时间
	...q:(tmpTime<startTime)&&(startTime'="")&&(idate=startDate)
	...q:(tmpTime>endTime)&&(endTime'="")&&(idate=endDate)	
	...s inci = $p(dhcIntrData,"^",15) //获取库存项id，
	...s stkCat = $p(^INCI(inci,2),"^",2)			//库存分类
	...s stkCatGrp=$o(^DHCSCG("STKCAT",stkCat,""))  //类组
	...s stkCatDesc = $p(^INC("SC",stkCat),"^",1)  //库存分类描述
	...s stkCatGrpDesc =$p(^DHCSCG(stkCatGrp),"^",2)
	...s stkCatDesc1=$p(^INC("SC",stkCat),"^",3)
	...q:stkCatDesc1'="G"  //只统计药品
	...s dhcIntrData = ^DHCINTR(intrRowId) //获取一条台帐信息
	...s spAmt = +$p(dhcIntrData,"^",8)*-1 //售价金额
	...s rpAmt= +$p(dhcIntrData,"^",17)*-1   //进价金额	
	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...s pointer = $p(dhcIntrData,"^",9)
	...s inclb=$p(dhcIntrData,"^",7)
	...s incib = $p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)  //批次
	...s orditm=..GetOrdItmByPointer(pointer,type)
	...q:orditm=""
	...s ordlocId = ##class(web.DHCSTDISPSTAT).GetDocLoc(orditm)  //开单科室
	...s ordlocDesc=$P(^CTLOC(ordlocId),"^",2)
	...i ordlocDesc["-" s ordlocDesc=$p(ordlocDesc,"-",2)
	...s (ypAmt,zjAmt,cyAmt,xyAmt)=0
	...s inciRcpi=$O(^INCI(inci,"REC","")) //只要存在制剂表中则默认为是制剂 2020-03-16 yangsj
	...i inciRcpi'="" s zjAmt=spAmt 
	...e  i stkCatGrpDesc["西药" s xyAmt=spAmt
	...e  i stkCatGrpDesc["草药" s ypAmt =spAmt
	...e  i stkCatGrpDesc["成药" s cyAmt=spAmt
	...//i stkCatDesc["制剂"	s zjAmt=spAmt
	...i ((type="P")||(type="Y")||(type="PH")||(type="YH")) s typestr1="住院"
	...e  i ((type="F")||(type="H")||(type="FH")||(type="HH")||(type="HC")||(type="HHC"))  s typestr1="门诊"
	...e  s typestr1="未知"
	...s index=ordlocId_"^"_typestr1
	...
	...i '$d(^temp($this,"GetDispAmt",pid,index)) s ^temp($this,"GetDispAmt",pid,index)=ordlocDesc_"^"_spAmt_"^"_ypAmt_"^"_zjAmt_"^"_cyAmt_"^"_xyAmt_"^"_$g(typestr1)
	...e  d
	....s $p(^temp($this,"GetDispAmt",pid,index),"^",2)=$p(^temp($this,"GetDispAmt",pid,index),"^",2)+spAmt
	....s $p(^temp($this,"GetDispAmt",pid,index),"^",3)=$p(^temp($this,"GetDispAmt",pid,index),"^",3)+ypAmt
	....s $p(^temp($this,"GetDispAmt",pid,index),"^",4)=$p(^temp($this,"GetDispAmt",pid,index),"^",4)+zjAmt
	....s $p(^temp($this,"GetDispAmt",pid,index),"^",5)=$p(^temp($this,"GetDispAmt",pid,index),"^",5)+cyAmt
	....s $p(^temp($this,"GetDispAmt",pid,index),"^",6)=$p(^temp($this,"GetDispAmt",pid,index),"^",6)+xyAmt
	
	s index="" f  s index=$o(^temp($this,"GetDispAmt",pid,index)) q:index=""  d
	.s tmpdata=^(index)
	.q:tmpdata["0^0^0^0^0"
	.s data = $lfs(tmpdata,"^")
	.set ^CacheTemp(repid,ind)=data
	.set ind=ind+1
	k ^temp($this,"GetDispAmt",pid)
	set qHandle=$lb(0,repid,0)
	q $$$OK
}

/// Description :住院药房退药情况统计报表
/// Creator		:GuoFa
/// CreateDate	:2019-07-04
/// Input		:StartDate:开始日期、StartTime:开始时间、EndDate:结束日期、EndTime:结束时间、RetLocId:退药科室、RetReasonId:退药原因
/// Output		:退药时间、退药科室、医生姓名、患者姓名、药品名称、规格、数量、单位、退药率
/// Table		:
/// Others		:退药率=退药药品数量/发药总数量
/// Debug		:D ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetPhaReturn","2023-05-05","00:00:00","2023-05-05","23:59:59","6","1","2") 
Query GetPhaReturn(StartDate As %String = "", StartTime As %String = "", EndDate As %String = "", EndTime As %String = "", RetLocId As %String = "", RetReasonId As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "time:%String,deptLoc:%String,doctor:%String,patName:%String,inciDesc:%String,spec:%String,retqty:%String,buom:%String,reason:%String,retPersent:%String") [ SqlProc ]
{
}

ClassMethod GetPhaReturnExecute(ByRef qHandle As %Binary, StartDate As %String = "", StartTime As %String = "", EndDate As %String = "", EndTime As %String = "", RetLocId As %String = "", RetReasonId As %String = "", HOSPID As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:HOSPID="" $$$OK
 q:(StartDate="")||(EndDate="") $$$OK			//必选条件
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 q:StartDate>EndDate $$$OK
 s:StartTime'="" StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 s:EndTime'="" EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 s typeStr="Y^YH"
 s typel=$l(typeStr,"^")
 f idate=StartDate:1:EndDate d
 .f itype=1:1:typel d
 ..s type=$p(typeStr,"^",itype)
 ..s intrRowId="" 
 ..f  s intrRowId=$o(^DHCINTR(0, "TypeDate", type, idate, intrRowId))  q:intrRowId=""  d
 ...s dhcIntrData=^DHCINTR(intrRowId)
 ...s inclb=$p(^DHCINTR(intrRowId),"^",7)
 ...q:inclb=""
 ...s tmpTime=$p(dhcIntrData,"^",3)  //台帐时间
 ...q:(tmpTime<StartTime)&&(StartTime'="")&&(idate=StartDate)
 ...q:(tmpTime>EndTime)&&(EndTime'="")&&(idate=EndDate)
 ...s retTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tmpTime)
 ...s phaRDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(idate)	
 ...s time=phaRDate_" "_retTime
 ...s inci = $p(dhcIntrData,"^",15) //获取库存项id
 ...s pointer = $p(dhcIntrData,"^",9)
 ...s inciDesc=$P(^INCI(inci,1),"^",2)
 ...s infoId=$O(^DHCITMINFO(0,"INCI",inci,""))
 ...s spec=$P(^DHCITMINFO(infoId),"^",27)
 ...s buomStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(inci)
 ...s buom=$P(buomStr,"^",2) 
 ...s reasonId=""
 ...s oeori=""
 ...i (type = "Y") d
 ....s phaRId = +pointer
 ....s phaRSub = $p(pointer,"||",2) 
 ....s phaRData=$G(^PHARET(phaRId))  //退药记录主
 ....s deptLocId=$P(phaRData,"^",6)
 ....q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(deptLocId),"^",22))  //按院区过滤
 ....q:(RetLocId'="")&&(RetLocId'=deptLocId)
 ....s deptLoc=$P(^CTLOC(deptLocId),"^",2)  //退药科室
 ....s RetItmData=$G(^PHARET(phaRId,"I",phaRSub))  //退药记录子表
 ....s oeori=$P(RetItmData,"^",1)
 ....s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori) 
 ....s retqty=$P(RetItmData,"^",2)
 ....s retqty =$fn(retqty, "N")
 ....s paadmId=$P(RetItmData,"^",8) 
 ....s patMasId=$P(^PAADM(paadmId),"^",1)
 ....s patName=$P(^PAPER(patMasId,"ALL"),"^",1)
 ....s reasonId=$P(RetItmData,"^",6)
 ...i (type = "YH") d  //草药数据
 ....s herbId = +pointer
 ....s herbSub = $p(pointer,"||",2) 
 ....s deptLocId=$lg(^BS.PHA.HERB.RETURND(herbId), 10)
 ....q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(deptLocId),"^",22))  //按院区过滤
 ....q:(RetLocId'="")&&(RetLocId'=deptLocId)
 ....s deptLoc=$P(^CTLOC(deptLocId),"^",2)  //退药科室
 ....s oeori=$lg(^BS.PHA.HERB.RETURND(herbId, "I", herbSub), 2)
 ....s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori) 
 ....s retqty=$lg(^BS.PHA.HERB.RETURND(herbId, "I", herbSub), 3)
 ....s retqty =$fn(retqty, "N")
 ....s paadmId=$lg(^BS.PHA.HERB.RETURND(herbId), 11) 
 ....s patMasId=$P(^PAADM(paadmId),"^",1)
 ....s patName=$P(^PAPER(patMasId,"ALL"),"^",1)
 ....s reasonId=$lg(^BS.PHA.HERB.RETURND(herbId, "I", herbSub), 12)
 ...q:(oeori="")
 ...q:(RetReasonId'="")&&(RetReasonId'=reasonId)
 ...s:reasonId="" reason=""
 ...s:reasonId'="" reason=$P(^BLC("RFR",reasonId),"^",2)
 ...s dspQty = 0
 ...d GetTotalDispQty
 ...q:dspQty=0 
 ...s retPersent=retqty/dspQty
 ...i retPersent["." s retPersent=$fn(retPersent,"",4)
 ...s retPersent=retPersent*100_"%"
 ...d OutputRow
 Quit $$$OK
 
GetTotalDispQty
 s dspId=""
 s dspQty=0
 f  s dspId=$O(^DHCOEDISQTY(0,"OEORI",oeori,dspId)) q:dspId=""  d
 .s dspData=$G(^DHCOEDISQTY(dspId))
 .s dspStatus=$P(dspData,"^",7)
 .q:dspStatus'="C"
 .s dspDate=$P(dspData,"^",8)
 .s dspTime=$P(dspData,"^",9)
 .q:(StartTime'="")&&(EndTime'="")&&(((dspDate=StartDate)&&(dspTime<StartTime))||((dspDate=EndDate)&&(dspTime>EndTime)))
 .s Qty=$P(dspData,"^",5)
 .s dspQty=dspQty+Qty
 q dspQty
  
OutputRow
 s Data=$lb(time,deptLoc,doctor,patName,inciDesc,spec,retqty,buom,reason,retPersent)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 	Description:药房药品使用量异常增涨提示图(增加率大于等于：20%)
/// 	Creator: 	power
/// 	CreatDate:	2019-04-22
/// 	Table:		
/// 	Input:		upStartDate(上一周期开始时间),upEndDate(上一周期结束时间),downStartDate(下一周期开始时间),downEndDate(下一周期结束时间),loc(药房名称)
/// 	Output:		药房名称，药品名称，上一周期使用量，当前周期使用量，增长率
/// 	Return:		返回值
/// 	Others:		其他补充
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetuseAmountByLoc","2019-08-01","2019-9-30","","2019-08-01","2019-11-30")
Query GetuseAmountByLoc(upStartDate As %String, upEndDate As %String, loc As %String, downStartDate As %String, downEndDate As %String, HOSPID As %String = "") As websys.Query(ROWSPEC = "locDesc:%String,inciDesc:%String,uomDesc:%String,upQty:%Float,upAmt:%Float,downQty:%Float,downAmt:%Float,GrowthRates:%Float") [ SqlProc ]
{
}

ClassMethod GetuseAmountByLocExecute(ByRef qHandle As %Binary, upStartDate As %String, upEndDate As %String, loc As %String, downStartDate As %String, downEndDate As %String, HOSPID As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	q:upStartDate="" $$$OK
	q:upEndDate="" $$$OK
	q:downStartDate="" $$$OK
	q:downEndDate="" $$$OK
	//s ^power($this)=$lb(upStartDate,upEndDate,loc,downStartDate,downEndDate)
	s:upStartDate["-" upStartDate=$zdh(upStartDate,3)
	s:upEndDate["-" upEndDate=$zdh(upEndDate,3)
	s:downStartDate["-" downStartDate=$zdh(downStartDate,3)
	s:downEndDate["-" downEndDate=$zdh(downEndDate,3)
	s pid=..NewPid()
	s upRet=..UseAmount(pid,loc,upStartDate,upEndDate,0,HOSPID)
	s downRet=..UseAmount(pid,loc,downStartDate,downEndDate,1,HOSPID)
    q:(upRet+downRet)=0 $$$OK
	
	s h=""
	f  s h=$o(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",h)) q:h=""  d
	.s data=^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",h)
	.s loc=$p(h,",",1)
	.s inci=$p(h,",",2)
	.s upQty=$p(data,"^",4)
	.s downQty=$p(data,"^",6)
	.s GrowthRates=1	//增长率
	.i (upQty=0)&&(downQty=0) s GrowthRates=0
	.i upQty'=0 s GrowthRates=(downQty-upQty)/upQty
	.e  i (downQty<0) s GrowthRates=-1
	.s GrowthRates=+$fn(GrowthRates,"N",2)
	.s ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"GrowthRates",loc,GrowthRates,inci)=data
	
	
	s loc=""
	f  s loc=$o(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"GrowthRates",loc)) q:loc=""  d
	.s GrowthRates=""
	.f  s GrowthRates=$o(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"GrowthRates",loc,GrowthRates),-1) q:GrowthRates=""  d
	..q:GrowthRates<0.2 //只保留增加率大于等于：20%
	..s inci=""
	..f  s inci=$o(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"GrowthRates",loc,GrowthRates,inci)) q:inci=""  d
	...s data=^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"GrowthRates",loc,GrowthRates,inci)
	...s locType=$p(^CTLOC(loc),"^",13)
	...q:(locType '= "D")
	...s locDesc=$p(data,"^",1)
	...s inciDesc=$p(data,"^",2)
	...s uomDesc=$p(data,"^",3)
	...s upQty=$p(data,"^",4)
	...s upAmt=$p(data,"^",5)
	...s downQty=$p(data,"^",6)
	...s downAmt=$p(data,"^",7)
	...s data=$lb(locDesc,inciDesc,uomDesc,upQty,$fn(upAmt,"",4),downQty,$fn(downAmt,"",4),GrowthRates)
	...set ^CacheTemp(repid,ind)=data
	...set ind=ind+1

	k ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid)
	set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Input:	ctloc (发药科室), CDateSt (开始时间), CDateEnd (结束时间), CStTime (开始时间), CEndTime(结束时间), jeFlag(精二标识)
/// 统计列:
/// 发药金额 +非正常发药金额 ^ 发药量(品种数) + 非正常发药量(品种数) ^ 发药处方数 ^发药草药付数 ^ 配药金额 ^ 配药品种数 ^ 配药处方数 _
/// 退药金额 + 非正常退药金额 ^ 退药量(品种数) + 非正常退药量(品种数) ^ 退药处方数 ^ 退药草药付数 
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","QueryZCYGZL","904","01/08/2019","27/11/2019","00:00","23:59")
/// zw ^TMP("DHCST","web.DHCOutPhRetrieve","QueryZCYGZL")
ClassMethod QueryZCYGZLExecute(ByRef QHandle As %Binary, ctloc As %String = "", CDateSt As %String = "", CDateEnd As %String = "", CStTime As %String = "", CEndTime As %String = "", jeFlag As %String = "", HOSPID As %String = "") As %Status
{
	
	 //s ^YSJTMP("QueryZCYGZLExecute")=$LB(ctloc,CDateSt,CDateEnd,CStTime,CEndTime,jeFlag)
     Set repid=$I(^CacheTemp)
	 s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	 s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	 s CStTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CStTime)
	 s CEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CEndTime)
	 s ind=1
	 i ctloc="" Set QHandle=$lb(0, repid,0) Quit $$$OK
	 s phloc=""
	 s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	 i phloc=""  Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s stdate="",enddate=""
	 s sttime="",endtime=""
	 s sttime=CStTime,endtime=CEndTime
	 i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	 s stdate=CDateSt,enddate=CDateEnd
	 i stdate>enddate Set QHandle=$lb(0,repid,0) Quit $$$OK
	 s cyflag=""
	 s cyflag=$p(^DHCPHLOC(phloc),"^",6)
	 s pid=##class(web.DHCSTKUTIL).NewPid($this,"OP")
	 
	 //门诊发药
	 f intrdate=stdate:1:enddate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","F",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:intrloc'=ctloc
	 ..s phdclb=$p(^DHCINTR(intr),"^",9)
	 ..s phdrow=$p(phdclb,"||",1)
	 ..s phdi=$p(phdclb,"||",2)
	 ..s phwrow=""
	 ..q:'$d(^DHCPHDISP(phdrow,1))
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s intrtime=$p(^DHCINTR(intr),"^",3)
	 ..q:(intrdate=stdate)&(intrtime<sttime)&(sttime'="")
	 ..q:(intrdate=enddate)&(intrtime>endtime)&(endtime'="")
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdfydr=+$p(^DHCPHDISP(phdrow,1),"^",2)
	 ..q:'$d(^DHCPHDI(phdrow,"PHDI",phdi))
	 
	 ..//s cyfs=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ..s prescno=$P(^DHCPHDISP(phdrow,2),"^",1)
	 ..s cyfs=$P(##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescno),"^",2)
	 	 
	 
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
	 ..//s oeori=..GetORI(phdclb) 
	 ..q:oeori=""
	 ..s ord=+oeori,chl=$P(oeori,"||",2)
	 ..q:ord=""
	 ..q:'$d(^OEORD(ord))
	 ..q:'$d(^OEORD(ord,"I",chl))
	 ..s (ordept,docloc)=""
	 ..i $d(^OEORD(ord,"I",chl,1)) d
	 ...s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	 ...s docloc=$p(^CTLOC(ordept),"^",2)
	 ..i $D(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)) d
	 ...s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",1)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",1)+amt //发药金额
	 ...i '$d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhdi",phdrow,phdi)) d
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",2)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",2)+1   //发药量(品种数)
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhdi",phdrow,phdi)=""
	 ...i '$D(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,presc)) d
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",3)=+($p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",3))+1  //发药处方数
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",4)=+($p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",4))+cyfs  //草药付数
	 ....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,presc)=""
	 ..e  d
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,presc)=""
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhdi",phdrow,phdi)=""
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)=amt_"^"_"1"_"^"_"1"_"^"_cyfs_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_docloc
	 ..
     //配药
     f phddate=stdate:1:enddate  d
	 .s phdrow=""
	 .f  s phdrow=$o(^DHCPHDISPi(phddate,phloc,phdrow)) q:phdrow=""  d
	 ..s phwrow=""
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s phdpyflag="",phdfyflag=""
	 ..s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	 ..s phdpyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	 ..s phdpydr="",phdfydr="",phdtime=""
	 ..s phdtime=+$p(^DHCPHDISP(phdrow,1),"^",7)
	 ..q:(phddate=stdate)&(phdtime<sttime)&(sttime'="")
	 ..q:(phddate=enddate)&(phdtime>endtime)&(endtime'="")
	 ..s presc="",prescrow="",jytype=""
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..s phdpydr=+$p(^DHCPHDISP(phdrow,1),"^",3)
	 ..s phdi="0",cyfs=1,phdmoney=0
	 ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	 ...s phdimoney=0
	 ...s phdimoney=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
	 ...s cyfs=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ...s phdimoney=$p(phdimoney,$c(1),1)
	 ...s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
	 ...q:oeori=""
	 ...s ord=+oeori,chl=$P(oeori,"||",2)
	 ...q:ord=""
	 ...q:'$d(^OEORD(ord))
	 ...q:'$d(^OEORD(ord,"I",chl))
	 ...s (ordept,docloc)=""
	 ...i $d(^OEORD(ord,"I",chl,1)) d
	 ....s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	 ....s docloc=$p(^CTLOC(ordept),"^",2)
	 ...//s phdmoney=phdmoney+phdimoney  
	 ...i $d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept))  d
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",5)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",5)+phdimoney //配药金额
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",7)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",7)+1  //配药品种数
	 ....i '$d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"py",presc))  d 
	 .....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",6)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",6)+1  //配药处方数
	 .....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",12)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",12)+cyfs  //配药处方数
	 .....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"py",presc)=""
	 ....
	 ...e  d
	 ....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"py",presc)=""
	 ....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)=0_"^"_0_"^"_0_"^"_0_"^"_phdimoney_"^"_1_"^"_1 _"^"_0_"^"_0_"^"_0_"^"_0_"^"_cyfs_"^"_docloc
	 	 
     //门诊退药 
    f intrdate=stdate:1:enddate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","H",intrdate,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:intrloc'=ctloc
    ..s phreti=$p(^DHCINTR(intr),"^",9)
    ..s phretrow=+phreti
    ..q:'$d(^DHCPHRET(phretrow))
    ..s retper=+$p(^DHCPHRET(phretrow),"^",8)
    ..s phrettime=+$p(^DHCINTR(intr),"^",3)
    ..q:(sttime'="")&(intrdate=stdate)&(phrettime<sttime)
    ..q:(sttime'="")&(intrdate=enddate)&(phrettime>endtime)
    ..s phretchid=$p(phreti,"||",2)
    ..q:'$d(^DHCPHRTI(phretrow,"RTI",phretchid))
    ..s retori=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",2)
    ..s phretmoney=$p(^DHCINTR(intr),"^",8)
    ..s phdi=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",7)
    ..s phd=$p(phdi,"||",1)
    ..s phdsub=$p(phdi,"||",2)
	..s cyfs=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",9)
	..// yunhaibao 20180211,草药退药付数修改
	..s retQty=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",3)
	..s phdQty=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
	..//i cyfs'=0 s cyfs=(phdQty/cyfs)*retQty
	..s presc=$p(^DHCPHDISP(phd,2),"^",1)
	..s oeori=""
	..s oeori=..GetRetORI(phreti)
	..q:oeori=""
	..s ord=+oeori,chl=$P(oeori,"||",2)
	..q:ord=""
	..q:'$d(^OEORD(ord))
	..q:'$d(^OEORD(ord,"I",chl))
	..s (ordept,docloc)=""
	..i $d(^OEORD(ord,"I",chl,1)) d
	...s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	...s docloc=$p(^CTLOC(ordept),"^",2)
    ..i $D(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)) d
	...s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",8)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",8)+phretmoney //退药金额
	...i '$d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhReti",phretrow,phretchid)) d
	....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",9)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",9)+1   //退药量(品种数),yunhaibao20170109,一个明细算1,并非品种数
	...i '$D(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ret",presc)) d
	....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",10)=+($p($g(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)),"^",10))+1  //退药处方数
	....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",11)=+($p($g(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)),"^",11))+cyfs  //退药草药付数
	....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhReti",phretrow,phretchid)=""
	..e  d
	...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ExistPhReti",phretrow,phretchid)=""
	...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_phretmoney_"^"_1_"^"_1_"^"_cyfs_"^"_0_"^"_docloc
     
 
   	 //住院发药
	 f intrdate=stdate:1:enddate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","P",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:intrloc'=ctloc
	 ..s pointer=$p(^DHCINTR(intr),"^",9)
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..s oeori=..GetPHPORI(pointer)
	 ..s str=##class(web.DHCSTDISPSTAT).GetZYYPFac(+pointer)
	 ..s (num3,num4)=0
	 ..s num3=$p(str,"^",3) ; 处方张数
	 ..s num4=$p(str,"^",4)  ;处方剂数
	 ..q:oeori=""
	 ..s ord=+oeori,chl=$P(oeori,"||",2)
	 ..q:ord=""
	 ..q:'$d(^OEORD(ord))
	 ..q:'$d(^OEORD(ord,"I",chl))
	 ..s (ordept,docloc,presc)=""
	 ..i $d(^OEORD(ord,"I",chl,1)) d
	 ...s presc=$p(^OEORD(ord,"I",chl,1),"^",14)
	 ...s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	 ...s docloc=$p(^CTLOC(ordept),"^",2)
	 ..i $d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept))  d
	 ...s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",1)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",1)+amt //发药金额
	 ...i '$d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"pha",+pointer)) d
	 ....//w ordept_"@@@"_presc_"@@"_$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",3),!
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",3)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",3)+num3 //处方张数
	 ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",4)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",4)+num4 //处方剂数
	 ....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"pha",+pointer)=""
	 ..e  d
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"pha",+pointer)=""
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)=amt_"^"_"1"_"^"_num3_"^"_num4_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_docloc
	 
	 
	 //住院退药
	 f intrdate=stdate:1:enddate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","Y",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:intrloc'=ctloc
	 ..s pointer=$p(^DHCINTR(intr),"^",9)
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..s oeori=..GetPHYORI(pointer)
	 ..q:oeori=""
	 ..s ord=+oeori,chl=$P(oeori,"||",2)
	 ..q:ord=""
	 ..q:'$d(^OEORD(ord))
	 ..q:'$d(^OEORD(ord,"I",chl))
	 ..s (ordept,docloc)=""
	 ..s FacNum=0 ;处方剂数
	 ..i $d(^OEORD(ord,"I",chl,1)) d
	 ...s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	 ...s docloc=$p(^CTLOC(ordept),"^",2)
	 ...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	 ...
	 ...s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	 ...i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d 
     ....s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
     ....s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
     ....s FacNum=facotor
	 ..i $d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept))  d
     ...s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",8)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",8)+amt //退药金额	
     ...i '$d(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"inRet",presc)) d 
     ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",10)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",10)+1 //处方张数 
     ....s $p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",11)=+$p(^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept),"^",11)+FacNum //处方剂数 
     ....s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"inRet",presc)=""
     ..e  d
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept,"inRet",presc)=""
	 ...s ^TMP("DHCST",$this,"QueryZCYGZL",pid,ordept)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_amt_"^"_1_"^"_1_"^"_FacNum_"^"_0_"^"_docloc
     
     //合计输出
    
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s phdper=""
	 f  s phdper=$o(^TMP("DHCST",$this,"QueryZCYGZL",pid,phdper)) q:phdper=""  d
     .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
     .q:phdper=0
     .s jyfs=0,jycf=0
     .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
     .s phaInfo=^TMP("DHCST",$this,"QueryZCYGZL",pid,phdper)
     .s phwpyrc=$p(phaInfo,"^",6)  //配药处方
     .s phwpyje=$p(phaInfo,"^",5)  //配药金额
     .s phwfyrc=$p(phaInfo,"^",3)  //发药处方
     .s phwfyje=$p(phaInfo,"^",1)  //发药金额
     .s phwpycount=$p(phaInfo,"^",7) //配药量
     .s phwfycount=$p(phaInfo,"^",2) //发药量
     .s tyrc=$p(phaInfo,"^",10) //退药处方数
     .s tyje=$p(phaInfo,"^",8) //退药金额
     .s tyl=$p(phaInfo,"^",9)  //退药量
     .s pyfs=+$p(phaInfo,"^",12) //配药付数
     .s fyfs=+$p(phaInfo,"^",4)  //发药付数
     .s tyfs=+$p(phaInfo,"^",11)  //退药付数
     .s docloc=$p(phaInfo,"^",13)	//下医嘱科室
     .s jyfs="0"
     .s jycf="0"
     .
     .s hjpyrc=hjpyrc+phwpyrc
     .s hjfyrc=hjfyrc+phwfyrc
     .s hjpyje=hjpyje+phwpyje
     .s hjfyje=hjfyje+phwfyje
     .s hjpyl=hjpyl+phwpycount
     .s hjfyl=hjfyl+phwfycount
     .s hjtyrc=hjtyrc+tyrc
     .s hjtyje=hjtyje+tyje
     .s hjtyl=hjtyl+tyl
     .s hjpyfs=hjpyfs+pyfs
     .s hjfyfs=hjfyfs+fyfs
     .s hjtyfs=hjtyfs+tyfs
     .s hjjyfs=hjjyfs+jyfs
     .s hjjycf=hjjycf+jycf
     .s phwdesc="",phdpname=""
     .s phdpname=$p($g(^DHCPHPER(phdper)),"^",2)
     .i phdpname["#" s phdpname=$p(phdpname,"#",2)
     .set Data=$lb(docloc,phwpyrc,phwfyrc,phwpyje,phwfyje,phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     if ind>1 d
     .set Data=$lb("合计",hjpyrc,hjfyrc,hjpyje,hjfyje,hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     k ^TMP("DHCST",$this,"QueryZCYGZL",pid)
     Set QHandle=$lb(0,repid,0)
     Quit $$$OK
}

Query QueryZCYGZL(ctloc As %String = "", CDateSt As %String = "", CDateEnd As %String = "", CStTime As %String = "", CEndTime As %String = "", jeFlag As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TDocLoc:%String,TPYRC:%String,TFYRC:%String,TPYJE:%String,TFYJE:%String,TPYL:%String,TFYL:%String,TRetPresc:%String,TRetMoney:%String,TRetYL:%String,TPyFS:%String,TFyFS:%String,TTyFS:%String,TJYFS:%String,TJYCF:%String") [ SqlProc ]
{
}

/// Creator:LKJ
/// CreateDate: 2019-07-08
/// Descipt:  门诊药房工作量统计
/// Table: 
/// input:StartDate 开始日期 EndDate 结束日期 
/// output：
/// 			
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetOutLocWorkLoadAll","2019-07-15","2019-11-15")				 
Query GetOutLocWorkLoadAll(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TLocDesc:%String,TPYRC:%String,TFYRC:%String,TPYJE:%String,TFYJE:%String,TPYL:%String,TFYL:%String,TRetPresc:%String,TRetMoney:%String,TRetYL:%String,TPyFS:%String,TFyFS:%String,TTyFS:%String,TJYFS:%String,TJYCF:%String") [ SqlProc ]
{
}

ClassMethod GetOutLocWorkLoadAllExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK


	//s ^LKJ($THIS,"GetOutLocWorkLoadAll")=$LB(StartDate,EndDate)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	
	s pid=##class(web.DHCSTKUTIL).NewPid($this,"OP")
	 
	 //门诊发药
	 f intrdate=StartDate:1:EndDate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","F",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..q:inclb=""
	 ..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..s phdclb=$p(^DHCINTR(intr),"^",9)
	 ..s phdrow=$p(phdclb,"||",1)
	 ..s phdi=$p(phdclb,"||",2)
	 ..s phwrow=""
	 ..q:'$d(^DHCPHDISP(phdrow,1))
	 ..s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ..s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ..q:'$d(^DHCPHDI(phdrow,"PHDI",phdi))
	 ..s cyfs=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) d
	 ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)+amt //发药金额
	 ...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phdrow,phdi)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2)+1   //发药量(品种数)
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phdrow,phdi)=""
	 ...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3))+1  //发药处方数
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4))+cyfs  //草药付数
	 ....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)=""
	 ..e  d
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phdrow,phdi)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=amt_"^"_"1"_"^"_"1"_"^"_cyfs_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	 ..
     //门诊配药
     f phddate=StartDate:1:EndDate  d
     .S Phl=""
	 .F  S Phl=$o(^DHCPHDISPi(phddate,Phl)) Q:(Phl="")  D
	 ..s phdrow=""
	 ..f  s phdrow=$o(^DHCPHDISPi(phddate,Phl,phdrow)) q:phdrow=""  d
	 ...s phwrow=""
	 ...s phwrow=+$p(^DHCPHDISP(phdrow,1),"^",4)
	 ...s phdpyflag="",phdfyflag=""
	 ...s phdfyflag=$p(^DHCPHDISP(phdrow),"^",4)
	 ...s phdpyflag=$p(^DHCPHDISP(phdrow,1),"^",6)
	 ...s intrloc=""
	 ...S intrloc=$P(^DHCPHLOC(Phl),"^",1)
	 ...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(intrloc),"^",22))  //按院区过滤
	 ...s presc="",prescrow="",jytype=""
	 ...s presc=$p(^DHCPHDISP(phdrow,2),"^",1)
	 ...s phdi="0",cyfs=1,phdmoney=0
	 ...f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:(phdi="")!(phdi="0")  d
	 ....s phdimoney=0
	 ....s phdimoney=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",3)
	 ....s cyfs=+$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",9)
	 ....s phdimoney=$p(phdimoney,$c(1),1)
	 ....//s phdmoney=phdmoney+phdimoney  
	 ....i $d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc))  d
	 .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",5)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",5)+phdimoney //配药金额
	 .....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",7)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",7)+1  //配药品种数
	 .....i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"py",presc))  d 
	 ......s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",6)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",6)+1  //配药处方数
	 ......s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",12)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",12)+cyfs  //配药处方数
	 ......s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"py",presc)=""
	 .....
	 ....e  d
	 .....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"py",presc)=""
	 .....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=0_"^"_0_"^"_0_"^"_0_"^"_phdimoney_"^"_1_"^"_1 _"^"_0_"^"_0_"^"_0_"^"_0_"^"_cyfs
	 	 
     //门诊退药 
    f intrdate=StartDate:1:EndDate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","H",intrdate,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(intrloc),"^",22))  //按院区过滤
    ..s phreti=$p(^DHCINTR(intr),"^",9)
    ..s phretrow=+phreti
    ..q:'$d(^DHCPHRET(phretrow))
    ..s phretchid=$p(phreti,"||",2)
    ..q:'$d(^DHCPHRTI(phretrow,"RTI",phretchid))
    ..s retori=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",2)
    ..s phretmoney=$p(^DHCINTR(intr),"^",8)
    ..s phdi=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",7)
    ..s phd=$p(phdi,"||",1)
    ..s phdsub=$p(phdi,"||",2)
	..s cyfs=+$p(^DHCPHDI(phd,"PHDI",phdsub),"^",9)
	..// yunhaibao 20180211,草药退药付数修改
	..s retQty=$p(^DHCPHRTI(phretrow,"RTI",phretchid),"^",3)
	..s phdQty=$p(^DHCPHDI(phd,"PHDI",phdsub),"^",4)
	..//i cyfs'=0 s cyfs=(phdQty/cyfs)*retQty
	..s presc=$p(^DHCPHDISP(phd,2),"^",1)
    ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) d
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8)+phretmoney //退药金额
	...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",phretrow,phretchid)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)+1   //退药量(品种数),yunhaibao20170109,一个明细算1,并非品种数
	...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",10)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)),"^",10))+1  //退药处方数
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",11)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)),"^",11))+cyfs  //退药草药付数
	....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",phretrow,phretchid)=""
	..e  d
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",phretrow,phretchid)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_phretmoney_"^"_1_"^"_1_"^"_cyfs
     
   
     //合计输出
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s intrloc=""
	 f  s intrloc=$o(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) q:intrloc=""  d
     .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
     .q:intrloc=0
     .s jyfs=0,jycf=0
     .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
     .s phwpyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",6)  //配药处方
     .s phwpyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",5)  //配药金额
     .s phwfyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3)  //发药处方
     .s phwfyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)  //发药金额
     .s phwpycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",7) //配药量
     .s phwfycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2) //发药量
     .s tyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",10) //退药处方数
     .s tyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8) //退药金额
     .s tyl=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)  //退药量
     .s pyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",12) //配药付数
     .s fyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4)  //发药付数
     .s tyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",11)  //退药付数
     .s jyfs="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",15)
     .s jycf="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",16)

     .s hjpyrc=hjpyrc+phwpyrc
     .s hjfyrc=hjfyrc+phwfyrc
     .s hjpyje=hjpyje+phwpyje
     .s hjfyje=hjfyje+phwfyje
     .s hjpyl=hjpyl+phwpycount
     .s hjfyl=hjfyl+phwfycount
     .s hjtyrc=hjtyrc+tyrc
     .s hjtyje=hjtyje+tyje
     .s hjtyl=hjtyl+tyl
     .s hjpyfs=hjpyfs+pyfs
     .s hjfyfs=hjfyfs+fyfs
     .s hjtyfs=hjtyfs+tyfs
     .s hjjyfs=hjjyfs+jyfs
     .s hjjycf=hjjycf+jycf
    
     .S LocDesc=""
     .S LocDesc=$P(^CTLOC(intrloc),"^",2)
     .set Data=$lb(LocDesc,phwpyrc,phwfyrc,phwpyje,phwfyje,phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     if ind>1 d
     .set Data=$lb("合计",hjpyrc,hjfyrc,hjpyje,hjfyje,hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     k ^TMP("DHCST",$this,"QueryGZLNew",pid)
     Set QHandle=$lb(0,repid,0)
     Quit $$$OK
}

// Creator:LKJ

/// CreateDate: 2019-07-08
/// Descipt:  住院药房工作量统计
/// Table: 
/// input:StartDate 开始日期 EndDate 结束日期 
/// output：
/// 			
/// 				 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","GetIntLocWorkLoadAll","2019-08-15","2019-12-07")
Query GetIntLocWorkLoadAll(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TLocDesc:%String,TPYRC:%String,TFYRC:%String,TPYJE:%String,TFYJE:%String,TPYL:%String,TFYL:%String,TRetPresc:%String,TRetMoney:%String,TRetYL:%String,TPyFS:%String,TFyFS:%String,TTyFS:%String,TJYFS:%String,TJYCF:%String") [ SqlProc ]
{
}

ClassMethod GetIntLocWorkLoadAllExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK

	//s ^LKJ($THIS,"GetIntLocWorkLoadAll")=$LB(StartDate,EndDate)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	
	s pid=##class(web.DHCSTKUTIL).NewPid($this,"OP")
	 
	 //住院发药
	 f intrdate=StartDate:1:EndDate  d
	 .s intr=""
	 .f  s intr=$o(^DHCINTR(0,"TypeDate","P",intrdate,intr)) q:intr=""  d
	 ..s inclb=$p(^DHCINTR(intr),"^",7)
	 ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
	 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(intrloc),"^",22))  //按院区过滤
	 ..s Point=$p(^DHCINTR(intr),"^",9)
	 ..s phac=$p(Point,"||",1)
	 ..s ch=$p(Point,"||",2)
	 ..q:'$d(^DHCPHAC(phac,"I",ch))
	 ..s presc=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
	 ..s cyfs=""
	 ..s amt=$p(^DHCINTR(intr),"^",8)
	 ..i amt<0 s amt=-amt
	 ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) d
	 ...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)+amt //发药金额
	 ...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phac,ch)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2)+1   //发药量(品种数)
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phac,ch)=""
	 ...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)) d
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3))+1  //发药处方数
	 ....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4)=+($p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4))+cyfs  //草药付数
	 ....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)=""
	 ..e  d
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,presc)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhdi",phac,ch)=""
	 ...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=amt_"^"_"1"_"^"_"1"_"^"_cyfs_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	 ..
     //住院配药
   
	 //s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"py",presc)=""
	 //s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0 _"^"_0_"^"_0_"^"_0_"^"_0_"^"_0
	 	 
     //住院退药 
    f intrdate=StartDate:1:EndDate  d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","Y",intrdate,intr)) q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..s intrloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(intrloc),"^",22))  //按院区过滤
    ..s Point=$p(^DHCINTR(intr),"^",9)
    ..s pharId=+Point
    ..q:'$d(^PHARET(pharId))
    ..s pharSub=$p(Point,"||",2)
    ..q:'$d(^PHARET(pharId,"I",pharSub))
    ..s pharmoney=$p(^DHCINTR(intr),"^",8)
    ..s RerrqID=$p(^PHARET(pharId,"I",pharSub),"^",7)
    ..q:RerrqID=""
    ..s RETRQID=$p(RerrqID,"||",1)
    ..s RETRQISub=$p(RerrqID,"||",2)
    ..S PhacPoint=$P(^RETRQ(RETRQID,"I",RETRQISub),"^",15)
    ..q:PhacPoint=""
    ..s phac=$p(PhacPoint,"||",1)
	..s ch=$p(PhacPoint,"||",2)
	..q:'$d(^DHCPHAC(phac,"I",ch))
	..s presc=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
	..s cyfs=""

	..//s presc=$p(^DHCPHDISP(phd,2),"^",1)
    ..i $D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) d
	...s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8)+pharmoney //退药金额
	...i '$d(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",pharId,pharSub)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)+1   //退药量(品种数),yunhaibao20170109,一个明细算1,并非品种数
	...i '$D(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)) d
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",10)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)),"^",10))+1  //退药处方数
	....s $p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",11)=+($p($g(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)),"^",11))+cyfs  //退药草药付数
	....s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",pharId,pharSub)=""
	..e  d
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ExistPhReti",pharId,pharSub)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc,"ret",presc)=""
	...s ^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_pharmoney_"^"_1_"^"_1_"^"_cyfs
     
   
     //合计输出
	 s phw=""
	 s n=0
	 s hjpyrc=0,hjfyrc=0,hjpyje=0,hjfyje=0,hjpyl=0,hjfyl=0
	 s hjtyrc=0,hjtyje=0,hjtyl=0,hjfyfs=0,hjpyfs=0,hjtyfs=0
	 s hjjyfs=0,hjjycf=0
     s intrloc=""
	 f  s intrloc=$o(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc)) q:intrloc=""  d
     .s phwfyrc=0,phwpyrc=0,phwfyje=0,phwpyje=0,phwpycount=0,phwfycount=0
     .q:intrloc=0
     .s jyfs=0,jycf=0
     .s tyrc=0,tyje=0,tyl=0,pyfs=0,fyfs=0,tyfs=0
     .s phwpyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",6)  //配药处方
     .s phwpyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",5)  //配药金额
     .s phwfyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",3)  //发药处方
     .s phwpyrc=phwfyrc				// MaYuqiang 20220725 默认配药处方量与发药处方量一致
     .s phwfyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",1)  //发药金额
     .s phwpycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",7) //配药量
     .s phwfycount=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",2) //发药量
     .s phwpycount = phwfycount		// MaYuqiang 20220725 默认配药量与发药量一致
     .s tyrc=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",10) //退药处方数
     .s tyje=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",8) //退药金额
     .s tyl=$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",9)  //退药量
     .s pyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",12) //配药付数
     .s fyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",4)  //发药付数
     .s tyfs=+$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",11)  //退药付数
     .s jyfs="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",15)
     .s jycf="0" //$p(^TMP("DHCST",$this,"QueryGZLNew",pid,intrloc),"^",16)

     .s hjpyrc=hjpyrc+phwpyrc
     .s hjfyrc=hjfyrc+phwfyrc
     .s hjpyje=hjpyje+phwpyje
     .s hjfyje=hjfyje+phwfyje
     .s hjpyl=hjpyl+phwpycount
     .s hjfyl=hjfyl+phwfycount
     .s hjtyrc=hjtyrc+tyrc
     .s hjtyje=hjtyje+tyje
     .s hjtyl=hjtyl+tyl
     .s hjpyfs=hjpyfs+pyfs
     .s hjfyfs=hjfyfs+fyfs
     .s hjtyfs=hjtyfs+tyfs
     .s hjjyfs=hjjyfs+jyfs
     .s hjjycf=hjjycf+jycf
    
     .S LocDesc=""
     .S LocDesc=$P(^CTLOC(intrloc),"^",2)
     .set Data=$lb(LocDesc,phwpyrc,phwfyrc,phwpyje,phwfyje,phwpycount,phwfycount,tyrc,tyje,tyl,pyfs,fyfs,tyfs,jyfs,jycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     if ind>1 d
     .set Data=$lb("合计",hjpyrc,hjfyrc,hjpyje,hjfyje,hjpyl,hjfyl,hjtyrc,hjtyje,hjtyl,hjpyfs,hjfyfs,hjtyfs,hjjyfs,hjjycf)
     .Set ^CacheTemp(repid,ind)=Data	
     .Set ind=ind+1
     k ^TMP("DHCST",$this,"QueryGZLNew",pid)
     Set QHandle=$lb(0,repid,0)
     Quit $$$OK
}

/// Creator:LKJ
/// CreateDate: 2019-06-10
/// Descipt:  医生基本药物使用金额占比
/// Table: 
/// input:StartDate 开始日期 EndDate 结束日期 
/// output：
/// 			
/// 				 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","DoctorBasicAmtUsageRate","2022-08-01","2022-08-29")
Query DoctorBasicAmtUsageRate(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "LocID,Loc,DoctorDr,Doctor,outAdmNum:%Float,outBasicNum:%Float,INAdmNum:%Float,INBasicNum:%Float") [ SqlProc ]
{
}

ClassMethod DoctorBasicAmtUsageRateExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)

	s n=0
	S TypeStr=..#DispTypeStr
	S TypeLen=$L(TypeStr,"^")
	F i=1:1:TypeLen  D
	.S Type=$P(TypeStr,"^",i)
	.F Date=StartDate:1:EndDate  D
	..S IntrID=""
	..F  S IntrID=$o(^DHCINTR(0,"TypeDate",Type,Date,IntrID)) Q:(IntrID="")  D
	...s inclb=$p(^DHCINTR(IntrID),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...S Pointer=$P(^DHCINTR(IntrID),"^",9)
	...s ordItem=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(Pointer,Type)
	...q:ordItem=""
	...S Ord=+ordItem
	...s Chl=+$P(ordItem,"||",2)
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...S Adm=$p(^OEORD(Ord),"^",1)
	...;s admType= $p($g(^PAADM(Adm)),"^",2) 
	...s bizType=##class(web.DHCST.ReportForms.ReportCommon).GetDispBizType(Type)
	...q:((bizType = "I")&&(##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(Adm)'=0))
	...s DoctorStr=##class(PHA.COM.Order).OeoriDoctor(ordItem)
	...s OrdDoctorDr=$p(DoctorStr, "^", 4)
	...s OrdDoctor=$p(DoctorStr, "^", 2)
	...s OrdDocLoc = ##class(PHA.COM.Order).GetOrdDocLoc(ordItem)  	//开单科室
	...s OrdLocId = $p(OrdDocLoc, "^", 1)
	...s OrdLocDesc = $p(OrdDocLoc, "^", 2)
	...s SpAmt=-$p(^DHCINTR(IntrID),"^",8)
	...s inci=+inclb
	...s BasicFlag=""	//基本药物
	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s BasicFlag = ##class(PHA.COM.Data.Drug).%New(inci).BaseDrug() //$p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",31) //国家基本药物标志

	...S Index=OrdLocId_","_OrdLocDesc_","_OrdDoctorDr_","_OrdDoctor

	...S BasicSpAmt = 0
	...I (BasicFlag = "Y")  D
	....S BasicSpAmt = SpAmt
	...I ('$d(Tmp("LocUsageRate", Index)))  D
	....I (bizType '= "I") D
	.....S Tmp("LocUsageRate", Index) = SpAmt_"^"_BasicSpAmt
	....E  d
	.....S Tmp("LocUsageRate", Index) = "^^"_SpAmt_"^"_BasicSpAmt
	...E  D
	....I (bizType '= "I") D
	.....S $P(Tmp("LocUsageRate", Index),"^", 1) =  SpAmt + $P(Tmp("LocUsageRate", Index),"^", 1)
	.....S $P(Tmp("LocUsageRate", Index),"^", 2) =  BasicSpAmt + $P(Tmp("LocUsageRate", Index),"^", 2)
	....E  d
	.....S $P(Tmp("LocUsageRate", Index),"^", 3) =  SpAmt + $P(Tmp("LocUsageRate", Index),"^", 3)
	.....S $P(Tmp("LocUsageRate", Index),"^", 4) =  BasicSpAmt + $P(Tmp("LocUsageRate", Index),"^", 4)

	
	S Index=""  
	F  S Index=$o(Tmp("LocUsageRate",Index)) Q:Index=""  D
	.S LocID=$p(Index,",",1)
	.S Loc=$p(Index,",",2)
	.S DoctorDr=$p(Index,",",3)
	.S Doctor=$p(Index,",",4)
	.S tmpData=Tmp("LocUsageRate",Index)
	.S outAdmNum=$fn($p(tmpData,"^",1), "N")
	.S outBasicNum=$fn($p(tmpData,"^",2), "N")
	.S INAdmNum=$fn($p(tmpData,"^",3), "N")
	.S INBasicNum=$fn($p(tmpData,"^",4), "N")
	.s loccode=$P(^CTLOC(LocID),"^",1)
	.s doccode=$P(^SSU("SSUSR",DoctorDr),"^",1)

	.S data=$lb(loccode,Loc,doccode,Doctor,outAdmNum,outBasicNum,INAdmNum,INBasicNum)
	.D output11
	
	K Tmp("LocUsageRate")
	Quit $$$OK	 

output11
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// Creator:	 LKJ
/// CreateDate:  2019-06-10
/// Descipt:     科室基本药物使用金额占比
/// Table: 
/// input:       startDate 开始日期 endDate 结束日期 
/// output：
/// 			
/// 				 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","BasicDrugAmtUsageRate","2023-03-01","2023-03-20")
Query BasicDrugAmtUsageRate(startDate As %String = "", endDate As %String = "", hospID As %String = "") As websys.Query(ROWSPEC = "LocID,Loc,outAdmNum:%Float,outBasicNum:%Float,INAdmNum:%Float,INBasicNum:%Float") [ SqlProc ]
{
}

ClassMethod BasicDrugAmtUsageRateExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", hospID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s startDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate =##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s pid = ..NewPid()

	s typeStr = ..#DispTypeStr
	for i = 1 : 1 : $l(typeStr, "^"){
		s type = $p(typeStr, "^", i)
		for date = startDate : 1 : endDate {
			s intrId = ""
			for {
				s intrId = $o(^DHCINTR(0, "TypeDate", type, date, intrId))
				q:(intrId = "")
				s inclb = $p(^DHCINTR(intrId), "^", 7)
				s pointer = $p(^DHCINTR(intrId), "^", 9)
				s tmploc=$P(^INCI(+inclb, "IL", $P(inclb, "||", 2)), "^", 1)
				q:((hospID '= "") && (hospID '= $P(^CTLOC(tmploc),"^",22)))  //按院区过滤
				s oeori = ##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer, type)
				continue:(oeori ="")
				s ord=$p(oeori, "||", 1)
				S chl=$p(oeori, "||", 2)
				;s adm = $p(^OEORD(ord), "^", 1) 
				;s admType = $P(^PAADM(adm), "^",2 ) 
				s ordDocLoc = ##class(PHA.COM.Order).GetOrdDocLoc(oeori)  	//开单科室
				s ordLocId = $p(ordDocLoc, "^", 1)
				s ordLocDesc = $p(ordDocLoc, "^", 2)
				s spAmt = $p(^DHCINTR(intrId), "^", 8)	
				s bizType=##class(web.DHCST.ReportForms.ReportCommon).GetDispBizType(type)
				s inci = +inclb
				s basicDrugFlag = ##class(PHA.COM.Data.Drug).%New(inci).BaseDrug()
				s index = ordLocId_","_ordLocDesc
				s outTotalAmt = 0
				s outBasicAmt = 0
				s inTotalAmt = 0
				s inBasicAmt = 0
				if (bizType '= "I"){
					s outTotalAmt = spAmt
					s:(basicDrugFlag = "Y") outBasicAmt = spAmt
				} else {
					s inTotalAmt = spAmt
					s:(basicDrugFlag = "Y") inBasicAmt = spAmt
				}
				if ('$d(allLoc("Loc", index))){
					s allLoc("Loc", index) = outTotalAmt _"^"_ outBasicAmt _"^"_ inTotalAmt _"^"_ inBasicAmt
				} else {
					s $p(allLoc("Loc", index), "^", 1) = outTotalAmt + $p(allLoc("Loc", index), "^", 1)
					s $p(allLoc("Loc", index), "^", 2) = outBasicAmt + $p(allLoc("Loc", index), "^", 2)
					s $p(allLoc("Loc", index), "^", 3) = inTotalAmt + $p(allLoc("Loc", index), "^", 3)
					s $p(allLoc("Loc", index), "^", 4) = inBasicAmt + $p(allLoc("Loc", index), "^", 4)
				}
			}
		}
	}

	S Index=""  
	F  S Index=$o(allLoc("Loc",Index)) Q:Index=""  D
	.s LocID=$p(Index,",",1)
	.s Loc=$p(Index,",",2)
	.s tmpData=allLoc("Loc",Index)
	.s outAdmNum=$fn($p(tmpData,"^",1), "N", 2)
	.s outBasicNum=$fn($p(tmpData,"^",2), "N", 2)
	.s INAdmNum=$fn($p(tmpData,"^",3), "N", 2)
	.s INBasicNum=$fn($p(tmpData,"^",4), "N", 2)
	.s loccode=$P(^CTLOC(LocID),"^",1)
	.S data=$lb(loccode,Loc,outAdmNum,outBasicNum,INAdmNum,INBasicNum)
	.d output10
	
	K allLoc("Loc")
	Quit $$$OK	 

output10
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// Creator:LKJ
/// CreateDate: 2019-06-10
/// Descipt:  进退货汇总表
/// Table: 
/// input:StartDate 开始日期 EndDate 结束日期 
/// output：
/// 			
/// 				 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.AllPharmacyStat","IngdRecTatal","2019-11-01","2019-11-07","2")
Query IngdRecTatal(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Apcv,ScgDesc,IngdAmt:%Float,IngdRAmt:%Float") [ SqlProc ]
{
}

ClassMethod IngdRecTatalExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	

	//s ^LKJ("GetPhaDetail")=$LB(StartDate,EndDate,HosId)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Pid=..NewPid()
	s n=0
	S TypeStr="G^R"
	S TypeLen=$L(TypeStr,"^")
	F j=1:1:TypeLen  D
	.S Type=$P(TypeStr,"^",j)
	.F Date=StartDate:1:EndDate  D
	..S IntrID=""
	..//F  S IntrID=$o(^DHCINTR(0,"LOCTYPEDATE",LocID,Type,Date,IntrID)) Q:(IntrID="")  D
	..F  S IntrID=$o(^DHCINTR(0,"TypeDate",Type,Date,IntrID)) Q:(IntrID="")  D
	...S IngdAmt=0,IngdrAmt=0
	...S Pointer=$P(^DHCINTR(IntrID),"^",9)
	...S Inclb=$P(^DHCINTR(IntrID),"^",7)
	...s loc="",stktype=""
	...i Type="G"  d
	....s LocID=$P(^DHCINGR(+Pointer),"^",13)
	....s stktype=$P(^DHCINGR(+Pointer),"^",30)
	...i Type="R"  d
	....s LocID=$P(^INGRT(+Pointer),"^",7)
	....s stktype=$P(^INGRT(+Pointer),"^",16)
	...q:LocID=""
	...q:stktype'="G"
	...s tmphos=$P(^CTLOC(LocID),"^",22)
	...q:(HOSPID'="")&&(HOSPID'=tmphos)
	...Q:(Type="G")&&('$D(^DHCINGR(+Pointer)))
	...Q:(Type="R")&&('$D(^INGRT(+Pointer)))
	...S:Type="G" ApcvDr=$P(^DHCINGR(+Pointer),"^",3)         //供应商
	...S:Type="R" ApcvDr=$P(^INGRT(+Pointer),"^",2)
	...S ScgCode=$P(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(+Inclb),"^",3)
	...Q:ScgCode'="G"
	...S ScgDesc=$P(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(+Inclb),"^",2)
	...S RpAmt=$P(^DHCINTR(IntrID),"^",17)
	...I Type="G" D
	....S IngdAmt=RpAmt
	...E  D
	....S IngdrAmt=RpAmt
	...S Data=ApcvDr_"^"_LocID_"^"_IngdAmt_"^"_IngdrAmt
	...I $D(^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc)) D
	....S TmpData=^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc)
	....I Type="G" D
	.....S $P(TmpData,"^",3)=$P(TmpData,"^",3)+IngdAmt
	....E  D
	.....S $P(TmpData,"^",4)=$P(TmpData,"^",4)+IngdrAmt
	....S ^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc)=TmpData
	...E  D
	....S ^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc)=Data
	
	
	S ApcvDr=""  
	F  S ApcvDr=$o(^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr)) Q:ApcvDr=""  D
	.S ScgDesc="" 
	.F  S ScgDesc=$o(^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc)) Q:ScgDesc=""  D
	..S Apcv=$P(^APC("APCVM",ApcvDr),"^",3)
	..S IngdAmt=$P(^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc),"^",3)
	..S IngdRAmt=$P(^TMP("DHCST",$THIS,"IngdRecTatal",Pid,ApcvDr,ScgDesc),"^",4)
	..S data=$lb(Apcv,ScgDesc,IngdAmt,IngdRAmt)
	..D output13
	K ^TMP("DHCST",$THIS,"IngdRecTatal",Pid)

	Quit $$$OK	 

output13
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// //================报表整理====yangsj====2019-10-31======End==================/////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// 实时统计发药消耗量
ClassMethod DispStatAll(input, HOSPID = "") As %String
{
	s stdate=$p(input,"^",1)
	q:stdate="" 0
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s endate=$p(input,"^",2)
	q:endate="" 0
	s endate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endate)
	s phalocdr=$p(input,"^",3)
	s parinci=$p(input,"^",4)
	s parfindtyp=$p(input,"^",5)
	s doclocin=$p(input,"^",6) //医生科室
	s basicFlagI=$p(input,"^",7) //基本药物标记
	s iotype=$p(input,"^",8)  //门诊住院标记
	s DMJDrugFlag=$p(input,"^",10)  //毒麻精药品标记
	s typestr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	i iotype="I" s typestr="P^Y^PH^YH"
	e  i iotype="O" s typestr="F^H^HC^FH^HH^HHC"
	s pid=..NewPid()
	d ..ClearTmp("DispStatAll",pid)
	s n=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s catgrptype=$p(StkGrpInfo,"^",3) 
	...q:catgrptype'="G"
	...q:(parinci'="")&(parinci'=inci)
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s LocID=$$LOC^ST01(inclb)
	...q:(phalocdr'="")&&(phalocdr'=LocID)
	...s incib=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	...s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib) //查找批次供应商及厂家 
	...s vendor=$p(VendManf,"^",1)
	...s vendordesc=$p(VendManf,"^",2)
	...s:$F(vendordesc,"-") vendordesc=$p(vendordesc,"-",2)
	...s:vendor="" vendor="buxiang",vendordesc="不详"
	...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s baseuom=$p(^INCI(inci,1),"^",10) ;baseuom
	...s puomdr=$p(^INCI(inci,3),"^",6)
	...s qty=$p(^DHCINTR(intr),"^",6)     ;qty for transaction
	...s uom=$p(^DHCINTR(intr),"^",10)    ;uom
	...//*20141203 zhouyg 修改 Start*/
	...s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uom,baseuom)
	...s packfac=##class(web.DHCSTCOMMONSRV).UOMFac(puomdr,baseuom)
	...s qty=qty*fac
	...s sp=$p(^DHCINTR(intr),"^",14)
	...s spamt=$p(^DHCINTR(intr),"^",8)
	...s rp=$p(^DHCINTR(intr),"^",16)
	...s rpamt=$p(^DHCINTR(intr),"^",17)
	...i sp'="" d
	....s sp=sp*packfac/fac
	...e  d
	....s sp=##class(web.DHCSTPRICE).GetSp(inclb,date,puomdr,HOSPID,"")
	...i rp'="" d
	....s rp=rp*packfac/fac
	...e  d
	....s rp=##Class(web.DHCSTPRICE).GetRp(inclb,date,puomdr,HOSPID,"")
	...i (spamt="")!(rpamt="") d
	....s amt=##class(web.DHCST.ReportForms.ReportCommon).GetAmt(type,pointer,intr)
	...i rpamt="" s rpamt=$p(amt,"^",1)
	...i spamt="" s spamt=$p(amt,"^",2)
	...//*20141203 zhouyg 修改 End*/
	...s doclocdr=##class(web.DHCST.ReportForms.ReportCommon).GetTransDocLoc(intr)
	...q:(doclocin'="")&&(doclocdr'=doclocin) //过滤医生科室
	...s docloc=$p($g(^CTLOC(doclocdr)),"^",2)  //医生科室
	...s warddr=##class(web.DHCST.ReportForms.ReportCommon).GetTransWardDr(intr) //病区
	...s basicflag=""
	...s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	...//s:(info'="")&($d(^DHCITMINFO(info))) basicflag=$p(^DHCITMINFO(info),"^",4)
	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s basicflag = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",31) //国家基本药物标志
	...q:(basicFlagI="Y")&&(basicflag'="Y")
	...s poisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
	...s poisonDesc=$p(poisonStr,"^",1)
	...q:(DMJDrugFlag="Y")&&(poisonDesc'["毒")&&(poisonDesc'["麻醉")&&(poisonDesc'["精")
	...s warddr=+warddr
	...s ward=$p($g(^CTLOC(doclocdr)),"^",2)
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...s baseuom=$p(^CT("UOM",baseuom),"^",2)
	...s puruom=$p(^CT("UOM",puomdr),"^",2)
	...s n=n+1
	...s data=incicode_"^"_incidesc_"^"_qty_"^"_rp_"^"_sp_"^"_rpamt_"^"_spamt_"^"_docloc_"^"_ward_"^"_packfac_"^"_inci_"^"_baseuom_"^"_puruom_"^"_vendor_"^"_vendordesc
	...i parfindtyp="1" s indextotal=inci 
	...i parfindtyp="2" s indextotal=doclocdr_","_ inci
	...i parfindtyp="3" s indextotal=vendor
	...i '$D(^TMP("DHCST",$this,"DispStatAll",pid,indextotal)) d
	....s ^TMP("DHCST",$this,"DispStatAll",pid,indextotal)=data
	...e  d
	....s $p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",3)=$p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",3)+qty
	....s $p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",6)=$p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",6)+rpamt 
	....s $p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",7)=$p(^TMP("DHCST",$this,"DispStatAll",pid,indextotal),"^",7)+spamt
	....
	...
	..
	.
	q pid_"^"_n
}

/// 实时统计基本药物在发药消耗中比例量
ClassMethod StatBasicInDrugALL(input, HOSPID = "") As %String
{
      
	s stdate=$p(input,"^",1)
	q:stdate="" 0
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s endate=$p(input,"^",2)
	q:endate="" 0
	s endate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endate)
	s phalocdr=$p(input,"^",3)
	s parinci=$p(input,"^",4)
	s parfindtyp=$p(input,"^",5)
	s doclocin=$p(input,"^",6) //医生科室
	s iotype=$p(input,"^",8)  //门诊住院标记
	s DMJDrugFlag=$p(input,"^",10)  //毒麻精药品标记
	s typestr="P^Y^F^H^HC^PH^YH^FH^HH^HHC"
	i iotype="I" s typestr="P^Y^PH^YH"
	e  i iotype="O" s typestr="F^H^HC^FH^HH^HHC"
	s pid=..NewPid()
	d ..ClearTmp("StatBasicInDrugALL",pid)
	s n=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s catgrptype=$p(StkGrpInfo,"^",3) 
	...q:catgrptype'="G"
	...q:(parinci'="")&(parinci'=inci)
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s LocID=$$LOC^ST01(inclb)
	...q:(phalocdr'="")&&(phalocdr'=LocID)
	...s loc=$p(^CTLOC(LocID),"^",2)
	...s:$F(loc,"-") loc=$p(loc,"-",2)
	...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s (BasicRpAmt,BasicSpAmt,rpamt,spamt)=0
	...s amt=##class(web.DHCST.ReportForms.ReportCommon).GetAmt(type,pointer,intr)
	...s rpamt=$p(amt,"^",1)
	...s spamt=$p(amt,"^",2)
	...s doclocdr=##class(web.DHCST.ReportForms.ReportCommon).GetTransDocLoc(intr)
	...q:(doclocin'="")&&(doclocdr'=doclocin) //过滤医生科室
	...s docloc=$p($g(^CTLOC(doclocdr)),"^",2)  //医生科室
	...s basicflag=""
	...s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	...//s:(info'="")&($d(^DHCITMINFO(info))) basicflag=$p(^DHCITMINFO(info),"^",4)
	...s arcimDr = $p(^INCI(inci,1),"^",3)  //医嘱项id
	...q:$g(arcimDr)=""
	...s phcdfDr = $p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",12)  //药学项子表ID
	...q:$g(phcdfDr)=""
	...s poisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
	...s poisonDesc=$p(poisonStr,"^",1)
	...q:(DMJDrugFlag="Y")&&(poisonDesc'["毒")&&(poisonDesc'["麻醉")&&(poisonDesc'["精")
	...s basicflag = $p(^PHCD(+phcdfDr,"DF",$P(phcdfDr,"||",2),"DHC"),"^",31) //国家基本药物标志
	...s:basicflag="Y" BasicRpAmt=rpamt,BasicSpAmt=spamt
	...i parfindtyp="4" s loc=docloc
	...s data=loc_"^"_rpamt_"^"_spamt_"^"_BasicRpAmt_"^"_BasicSpAmt
	...s indextotal=loc q:indextotal=""
	...i '$D(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal))   d  
	....s ^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal)=data
	...e  d
	....s $p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",2)=$p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",2)+rpamt
	....s $p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",3)=$p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",3)+spamt 
	....s $p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",4)=$p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",4)+BasicRpAmt
	....s $p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",5)=$p(^TMP("DHCST",$this,"StatBasicInDrugALL",pid,indextotal),"^",5)+BasicSpAmt
	...
	..
	.
	q pid_"^"_n
}

/// Description：根据处方获取开方医生和科室信息和处方类型
/// Creator：WangYaJun
/// CreateDate：2017-12-25
/// InPut:处方号
/// OutPut：医生ID、医生名称、科室ID、科室名称、处方类型
/// w ##class(web.DHCSTDISPSTAT).GetDepLocDocByPrescNo("I171210000014")
ClassMethod GetDepLocDocByPrescNo(PrescNo)
{
    q:PrescNo="" ""
    s UserAdd=""
    s PType=""
    s XYFlag=0,ZChYFlag=0,ZCYFlag=0,JZYFlag=0,ZSJFlag=0,KJYFlag=0  ;西药,中成药,中草药,自制药,注射剂,抗菌药物标记
    s Ord=""
    f  s Ord=$o(^OEORD(0,"PrescNo",PrescNo,Ord)) q:(Ord="")  d
    .s Chl=""
    .f  s Chl=$o(^OEORD(0,"PrescNo",PrescNo,Ord,Chl)) q:(Chl="")  d
    ..s UserAdd=$p(^OEORD(Ord,"I",Chl,7),"^",1)    ;医生ID
    ..s UserDep=$p(^OEORD(Ord,"I",Chl,7),"^",2)    ;医生科室ID
    ..s DocName=$p(^SSU("SSUSR",UserAdd),"^",2)
    ..s DocLocdesc=$p(^CTLOC(UserDep),"^",2)
    ..s ItmMast=$p(^OEORD(Ord,"I",Chl,1),"^",2)
    ..s Inci=$o(^INCI(0,"ARCIM_DR",$p(ItmMast,"||",1),0))
    ..q:Inci=""
    ..s From=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci),"^",2)    ;剂型  GetAntiFlagByInci
    ..s PhcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(Inci)
	..s KJFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PhcdfId)
    ..s ItmCat=$p(^ARCIM(+ItmMast,$p(ItmMast,"||",2),1),"^",10)   ;医嘱子类
    ..s DurgCat=$p(^ARC("IC",ItmCat),"^",8)      ;医嘱大类
    ..s CatDesc=$p(^OEC("ORCAT",DurgCat),"^",2)  ;医嘱大类描述
    ..s:$f(CatDesc,"西药") XYFlag=1
    ..s:$f(CatDesc,"中成") ZChYFlag=1
    ..s:$f(CatDesc,"中草药") ZCYFlag=1
    ..s:$f(CatDesc,"自制") JZYFlag=1
    ..s:$f(From,"注射剂") ZSJFlag=1
    ..s:KJFlag="Y" KJYFlag=1
    i (XYFlag=1)&(ZChYFlag=0)&(ZCYFlag=0)&(JZYFlag=0) s PType="西药"
    i (XYFlag=0)&(ZChYFlag=1)&(ZCYFlag=0)&(JZYFlag=0) s PType="中成药"
    i (XYFlag=0)&(ZChYFlag=0)&(ZCYFlag=1)&(JZYFlag=0) s PType="中草药"
    i (XYFlag=1)&(ZChYFlag=1)&(ZCYFlag=0)&(JZYFlag=0) s PType="西成药"
    i (XYFlag=0)&(ZChYFlag=0)&(ZCYFlag=0)&(JZYFlag=1) s PType="自制药"
    s RetValue=UserAdd_"^"_DocName_"^"_UserDep_"^"_DocLocdesc_"^"_PType_"^"_ZSJFlag_"^"_KJYFlag
    q RetValue
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).NewPid()
ClassMethod NewPid() As %String
{
  	Q $I(^DHCSTPID("DHCST",$this))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).ClearTmp()
ClassMethod ClearTmp(MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCST",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCST",$this,MethodName,pid,PAR)
	.K ^||TMP("DHCST",$this,MethodName,pid,PAR)
	.K ^||TEMP("DHCST",$this,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCST",$this,MethodName,pid)
	.K ^TEMP("DHCST",$this,MethodName,pid)
	.K ^||TMP("DHCST",$this,MethodName,pid)
	.K ^||TEMP("DHCST",$this,MethodName,pid)
	Q ""
}

/// Description: 获取药学分类ID完整Id串,用于统计排序
/// Input:		 PHCCatId(药学分类Id)
/// Return:		 
/// w ##class(web.DHCST.ReportForms.AllPharmacyStat).GenePHCCatIdAll(2,"")
ClassMethod GenePHCCatIdAll(PHCCatId, AllId = "") As %String
{
	q:+PHCCatId=0 AllId
	i AllId="" s tmpId=PHCCatId d FmtId
	s parId=+$p(^DHCPHCC(PHCCatId),"^",3)
	i parId'=0 s tmpId=parId d FmtId
	q:parId=0 AllId
	s all=..GenePHCCatIdAll(parId,AllId)
	q all
FmtId
	s tmpId=$j(tmpId,10)
	i AllId="" s AllId=tmpId
	e  d
	.s AllId=tmpId_AllId
	q
}

/// / description :取某日期某科室所有库存数(基本单位) zhaoxinlong
ClassMethod GetIncibQty(incib, date, Loc) As %String
{

	s inci=+incib
	s TatolQty=0
	s sub=0
	f  s sub=$o(^INCI("LB_IB",incib,inci,sub))  Q:(sub="")!(sub=0)  d
	.s loc=$p($g(^INCI(inci,"IL",sub)),"^",1)
	.q:loc=""
	.q:(loc'=Loc)&&(Loc'="")
	.s chilsub=0
	.f  s chilsub=$o(^INCI("LB_IB",incib,inci,sub,chilsub))  Q:(chilsub="")!(chilsub=0)  d
	..s inclb=inci_"||"_sub_"||"_chilsub
	..s qty=..QtyINCLB(inclb,date)
	..s TatolQty=TatolQty+qty
	
	Q TatolQty
}

/// 取某批次某日期的库存
/// Date:20120-07-19
/// Argu:
/// INCLB - 库存批次rowid
/// DA - 日期 (可以是:内部格式，格式3，格式4)
/// Return：
/// 库存数量(基本单位)
/// 
ClassMethod QtyINCLB(INCLB As %String, DA As %String) As %String
{
 ; DA : date is "3" format

 s qty=""
 i DA["-" s DA=$zdh(DA,3)  //YYYY-MM-DD格式
 i DA["/" s DA=$zdh(DA,4)  //YYYY-MM-DD格式

 s DA=DA+1 q:DA="" 0
 s DD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DA),-1) q:DD="" 0
 s LCBTD=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,""),-1)  q:LCBTD="" 0
 s LCBTCH=$o(^DHCBTLOCTOT(0,"INCLBDATE",INCLB,DD,LCBTD,""),-1) q:LCBTCH="" 0
 s qty=$p(^DHCBTLOCTOT(LCBTD,"I",LCBTCH),"^",3)
 q qty
}

/// Description获取诊断编码 by zhxl
ClassMethod GetICDCode(admId)
{
 q:$g(admId)="" ""
 q:'$d(^PAADM(admId)) ""
 s admMainDR=$p(^PAADM(admId),"^",61)
 q:$g(admMainDR)="" ""
 q:'$d(^MR(admMainDR,"DIA")) ""
 s docId=""
 s mrcidCode=""
 s mrcidCodeStr=""
 s mrdiaSub=0 
 f  s mrdiaSub=$o(^MR(admMainDR,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
 .s mrdiaIcdCode=$p(^MR(admMainDR,"DIA",mrdiaSub),"^",1)
 .i mrdiaIcdCode'=""  d
 ..i $d(^MRC("ID",mrdiaIcdCode))  d
 ...s mrcidCode=$p($g(^MRC("ID",mrdiaIcdCode)),"^",4)
 ...s mrcidCodeStr=$S(mrcidCodeStr="":mrcidCode,1:mrcidCodeStr_","_mrcidCode)
 
 q mrcidCodeStr
}

/// 计算患者就诊次数 zhxl
ClassMethod calAdm(Papmi, AdmType)
{
	s num=0
	s adm=""
	f  s adm=$O(^PAPERdr(Papmi,"ADM",AdmType,adm))  q:adm=""  d
	.s num=num+1
	q num
}

ClassMethod GetLocStrByHosp(HOSPID)
{
	s str=""
	s loc=""
	f  s loc=$o(^CTLOC(0,"LocType","D",loc))  Q:loc=""    d
	.s hospDr=$p(^CTLOC(loc),"^",22)
	.q:(HOSPID'=hospDr)
	.i str="" s str=loc
	.e  s str=str_"^"_loc
	
	q str
}

/// Descript:取医嘱信息
/// Creater:	Yanbl
/// CreateDate:	2019-10-17
/// Table:
/// Input:OE_OrdItem表id
/// Output:
/// Return：病人姓名^处方号
/// Others:
ClassMethod GetOrdInfo(Oeori) As %Library.String
{
	q:Oeori="" ""
 	s Ord=$p(Oeori,"||",1)
 	s Chl=$p(Oeori,"||",2)
 	s Adm=$p(^OEORD(Ord),"^",1)
 	s PatName=""
	s PrescNo=""
 	i $g(Adm)'="" d
 	.s PaPmi=$p(^PAADM(Adm),"^",1)
 	.s PatName=$p(^PAPER(PaPmi,"ALL"),"^",1)   ;病人就诊号（处理人）
 	i $d(^OEORD(Ord,"I",Chl,1)) d
 	.s PrescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)   ;处理号
 	.
 	q PatName_"^"_PrescNo
}

/// Description:根据台帐表pointer和台帐类型获取orditm
/// Input:pointer业务表id，type 台帐类型
/// Output:orditm  oe_ordItm 的id
/// Creator:wzl
/// CreateDate:2018-12-24
/// w ##class(web.DHCST.ReportForms.AllPharmacyStat).GetOrdItmByPointer("1||2","P")
ClassMethod GetOrdItmByPointer(pointer, type) As %Library.String
{
	s orditm=""
	i type="P" d
	.s orditm = $p($g(^DHCPHAC(+pointer,"I",$p(pointer,"||",2))),"^",7)
	i type="F" d
	.s orditm = $p($g(^DHCPHDI(+pointer,"PHDI",$p(pointer,"||",2))),"^",5)
	i type="Y" d
	.q:'$d(^PHARET(+pointer,"I",$p(pointer,"||",2)))
	.s orditm=$p($g(^PHARET(+pointer,"I",$p(pointer,"||",2))),"^",1)
	i ((type = "H") || (type = "HC")) d
	.q:'$d(^DHCPHRTI($p(pointer, "||", 1), "RTI", $p(pointer, "||", 2)))
	.s orditm = $p(^DHCPHRTI($p(pointer, "||", 1), "RTI", $p(pointer, "||", 2)), "^", 2)
	i ((type="FH") || (type="PH")) d
	.q:'$d(^BS.PHA.HERB.DISPEND($p(pointer, "||", 1), "I", $p(pointer, "||", 2)))
	.s orditm = $lg(^BS.PHA.HERB.DISPEND($p(pointer, "||", 1), "I", $p(pointer, "||", 2)), 3)
	i ((type="HH") || (type="YH") || (type="HHC")) d
	.q:'$d(^BS.PHA.HERB.RETURND($p(pointer, "||", 1), "I", $p(pointer, "||", 2)))
	.s orditm = $lg(^BS.PHA.HERB.RETURND($p(pointer, "||", 1), "I", $p(pointer, "||", 2)), 2)
	q orditm
}

/// Creator:wzl
/// CreatDate:2019-10-22
/// Description:取病人发药的科室，住院取病区或者医生科室，门诊取科室
/// input:orditm:医嘱明细id
/// output: 科室id  ^  科室名称
/// w ##Class(web.DHCST.ReportForms.AllPharmacyStat).GetWardOrLocByOrd()
ClassMethod GetWardOrLocByOrd(orditm)
{
	s ret="^"
	q:orditm="" ret
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	q:dsp="" ret
	s adm=$p(^OEORD(+orditm),"^",1)
	s admType= $p($g(^PAADM(adm)),"^",2) 
	i admType="I" d
	.i ##class(web.DHCSTKUTIL).Linked(orditm)=1 d
	..s ret=##class(web.DHCSTCOMMONORDER).OeoriDocLoc(orditm)     //医生科室
	.e  d
	..s dsplocId= $p(^DHCOEDISQTY(dsp),"^",22)  	//病区
	..s dsplocDesc=$P(^CTLOC(dsplocId),"^",2)
	..s ret=dsplocId_"^"_dsplocDesc
	e  d
	.s ordlocId= $p(^DHCOEDISQTY(dsp),"^",22)  	//科室
	.s ordlocDesc=$P(^CTLOC(ordlocId),"^",2)
	.s ret=ordlocId_"^"_ordlocDesc
	q ret
}

ClassMethod UseAmount(pid, loc, startDate, endDate, compared = "", HOSPID = "")
{
	q:startDate="" ""
	q:endDate="" ""
	s spAmtSum=0,sum=0
	s typeStr=..#DispTypeStr	//"P^Y^F^H"
    s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.f date=startDate:1:endDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s intrInfo=^DHCINTR(intr)
	...s inclb=$p(intrInfo,"^",7)
	...q:inclb=""
	...s locID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	...q:(loc'="")&&(loc'=locID)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(locID),"^",22))  //按院区过滤
	...s locDesc=$p(^CTLOC(locID),"^",2)
	...//i $f(locDesc,"-") s locDesc=$P(locDesc,"-",2)
	...s pointer=$p(intrInfo,"^",9)  //pointer
	...s oeori=""
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s ord=+oeori,chl=$P(oeori,"||",2)
	...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",chl))
	...s (ordept,docloc)=""
	...i $d(^OEORD(ord,"I",chl,1)) d
	....s ordept=$p(^OEORD(ord,"I",chl,1),"^",3)
	....s docloc=$p(^CTLOC(ordept),"^",2)
	...//i $f(docloc,"-") s docloc=$P(docloc,"-",2)
 	...s inci=$p(intrInfo,"^",15)
 	...s itmdesc=$p(^INCI(inci,1),"^",2)
	...s bUomStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(inci)
	...s bUom="",uomDesc=""
	...i bUomStr'="" d
	....s bUom=$P(bUomStr,"^",1)
	....s uomDesc=$P(bUomStr,"^",2) 		//基本单位
 	...s tuom=$p(intrInfo,"^",10)
	...s qty=(-1)*$p(intrInfo,"^",6)  			//数量
	...s factor=##class(web.DHCSTCOMMONSRV).UOMFac(tuom,bUom)
	...s qty=qty*factor					//基本单位数量
 	...s spAmt=0
	...s spAmt=(-1)*$p(intrInfo,"^",8)
	...s spAmtSum=spAmtSum+spAmt
	...i compared=1 s intrData=locDesc_"^"_itmdesc_"^"_uomDesc_"^"_0_"^"_0_"^"_qty_"^"_spAmt_"^"_0
	...e  s intrData=locDesc_"^"_itmdesc_"^"_uomDesc_"^"_qty_"^"_spAmt_"^"_0_"^"_0_"^"_0	
	...s indextotal=locID_","_inci
	...i '$d(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal)) d
	....s ^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal)=intrData
	...e  d
	....i compared=1 d 
	.....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",6)=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",6)+qty
	.....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",7)=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",7)+spAmt
	....e  d
	.....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",4)=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",4)+qty
	.....s $p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",5)=$p(^TMP("DHCST","web.DHCST.ReportForms.AllPharmacyStat","UseAmount",pid,"qty",indextotal),"^",5)+spAmt
	...s sum=sum+1
	q sum
}

/// 门诊发药
ClassMethod GetORI(PHDISPEN)
{
 q:PHDISPEN="" ""        
 s mmm=$P(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
 q:'$d(^DHCPHDI(mmm,"PHDI",ddd)) ""
 s oeori=$p(^DHCPHDI(mmm,"PHDI",ddd),"^",5)
 q oeori
}

/// 门诊退药
ClassMethod GetRetORI(PHRetI)
{
      
 q:PHRetI="" ""        
 s mmm=$P(PHRetI,"||",1),ddd=$P(PHRetI,"||",2)
 q:'$d(^DHCPHRTI(mmm,"RTI",ddd)) ""
 s oeori=$p(^DHCPHRTI(mmm,"RTI",ddd),"^",2)
 q oeori
}

/// 住院发药
ClassMethod GetPHPORI(PHDISPEN)
{
 q:PHDISPEN="" ""
 s mmm=$p(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
 q:ddd="" ""
 q:'$d(^DHCPHAC(mmm,"I",ddd)) ""
 s oeori=$p(^DHCPHAC(mmm,"I",ddd),"^",7)
 q oeori
}

/// 住院退药
ClassMethod GetPHYORI(PHRetI)
{
 q:PHRetI="" ""
 /* //安徽省立无子表
 s mmm=$P(PHRetI,"||",1)
 q:'$d(^PHARET(mmm)) ""
 s oeori=$p(^PHARET(mmm),"^",5)
 */
 s mmm=$P(PHRetI,"||",1),ddd=$P(PHRetI,"||",2)
 q:'$d(^PHARET(mmm,"I",ddd)) ""
 s oeori=$p(^PHARET(mmm,"I",ddd),"^",1)
 q oeori
}

ClassMethod GetZYYPFac(phac)
{
	//中草药代煎总剂数(某人熬了多少锅) lq 2008-04-24
	q:phac="" ""
	k ^TMP($j,"dhcpha","GetZYYPFac")
	s ch=""
	s num=0    ;代煎处方张数
	s num1=0   ;处方张数
	s num2=0   ;处方剂数
	s facsum=0 ;代煎剂数
    s ws=0     ;统计味数
    s numoutque=0 ;出院带药张数
    s numoutfac=0 ;出院带药剂数
    ;s sumoutamt=0    ;出院带药金额
	f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
	.s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
	.s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	.q:queid=""     
	.q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
	.s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
    .s ws=ws+1
    .q:$d(^TMP($j,"dhcpha","GetZYYPFac",prescno))
    .s num1=num1+1
    .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    .s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    .s num2=facotor+num2
    .
    .s priority=$p(^OECPR($p(^OEORD(+oedis,"I",$p(oedis,"||",2),1),"^",8)),"^",1)
    .i priority="OUT" d
    ..s numoutfac=numoutfac+facotor
    ..s numoutque=numoutque+1
    ..s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
    ..s price=$p(^DHCPHAC(phac,"I",ch),"^",9)
    ..s amtout=qty*price
    ..;s sumoutamt=$g(sumoutamt)+amtout ;出院带药金额
    .
    .s cookmode=$p(^PAQUE1(queid,"DHC"),"^",15)
    .i cookmode ["代煎" d
    ..s num=num+1
    ..s facsum=facsum+facotor
    .
    .s ^TMP($j,"dhcpha","GetZYYPFac",prescno)=""
	q facsum_"^"_num_"^"_num1_"^"_num2_"^"_ws_"^"_numoutque_"^"_numoutfac
}

/// MaYuqiang 20220803
/// 获取住院处方在日期范围内的发药金额
/// Input :		PrescNo - 处方号，StartDate - 查询开始日期，EndDate - 查询截止日期
/// Output :	发药金额
/// 
/// w ##class(web.DHCST.ReportForms.AllPharmacyStat).GetIPPrescAmt("MJ22080300001", "", "")
ClassMethod GetIPPrescAmt(PrescNo, StartDate, EndDate)
{
	s spAmtTotal = 0
	if (StartDate = ""){
		s StartDate = +$h	
	}
	if (EndDate = ""){
		s EndDate = +$h	
	}
	
	s ordId = 0
	for {
		s ordId = $o(^OEORD(0, "PrescNo", PrescNo, ordId))
		q:(ordId="")	
		s ordItm = ""
		for {
			s ordItm = $o(^OEORD(0, "PrescNo", PrescNo, ordId, ordItm))
			q:(ordItm = "")	
			s oeori = ordId _"||"_ ordItm
			s arcItmId = $p(^OEORD(ordId, "I", ordItm, 1), "^", 2)
			s arcCatId = $p($g(^ARCIM(+arcItmId, $p(arcItmId, "||", 2), 1)), "^", 10)
			s arcCatType = $p($g(^ARC("IC", +arcCatId)), "^", 7)
    		continue:(arcCatType '= "R")		// 过滤-非药品
    		s dspId=""
    		for {
	    		s dspId = $o(^DHCOEDISQTY(0, "OEORI", oeori, dspId))	
	    		q:(dspId = "")
	    		s dspData = $g(^DHCOEDISQTY(dspId))
	    		s dspStatus = $p(dspData, "^", 7)
				continue:(dspStatus '= "C")
				s dspDate = $p(dspData, "^", 8)
				continue:((dspDate > EndDate)||(dspDate < StartDate))
				s pointer = $p(dspData, "^", 14)
				s pmain = +pointer
				s pitm = +$p(pointer, "||", 2)
				s spAmt = 0
				s lbSub = ""
				for {
					s lbSub = $o(^DHCPHAC(pmain, "I", pitm,"B", lbSub))
					q:(lbSub = "")
					s lbData = $g(^DHCPHAC(pmain, "I", pitm,"B", lbSub))
					s spAmt = spAmt + $p(lbData, "^", 6)
				}
				s spAmtTotal=spAmtTotal+spAmt
	    	}
		}
	}
	
	q spAmtTotal
}

}
