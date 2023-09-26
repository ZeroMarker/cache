/// Description: 交接单打印
Class web.DHCSTPIVAS.PrintWardBat Extends %RegisteredObject
{

/// Description: 获取打印数据
/// Input:		 pMethodName 调用的汇总数据方法
/// Debug: 		 w ##class(web.DHCSTPIVAS.PrintWardBat).GetData("{""pogsNoArr"":[""S10P20211102001""],""loc"":""89"",""rePrint"":""Y"",""printType"":""Total""}")
/// 			 w ##class(web.DHCSTPIVAS.PrintWardBat).GetData("{""pogsNoArr"":[""S10P20211102001""],""loc"":""89"",""rePrint"":""Y"",""printType"":""Total""}")
ClassMethod GetData(pJsonStr)
{
	s retJsonArr = []
	s pJson = ##class(web.DHCSTPIVAS.Util).DataToJson(pJsonStr)
	s pogsNoArr = pJson.pogsNoArr
	s loc = pJson.loc
	s printType = pJson.printType
	s methodName = "GetWardBat" _ printType
	s rePrint = $s(pJson.rePrint = "Y" : "（补）", 1 : "")
	
	q:'$IsObject(pogsNoArr) retJsonArr.%ToJSON() 
	s len = pogsNoArr.%Size()
	for i = 0 : 1 : (len - 1) {
		s pogsNo = pogsNoArr.%Get(i)
		continue:(pogsNo = "")
		s pogArr = ..GetPogArrByPogsNo(loc, pogsNo, "")
		s row = $ClassMethod(, methodName, pogArr, pogsNo)
		s row.rePrint = rePrint
		d retJsonArr.%Push(row)
	}
	q retJsonArr.%ToJSON()
}

/// Description: 根据单号获取所有POG
/// Input: 		 packFlag P: 取打包数据, N: 取非打包数据, : 取所有
ClassMethod GetPogArrByPogsNo(loc, pogsNo, packFlag = "") As %DynamicArray
{
	s ret = []
	q:(loc = "")||(pogsNo = "") ret
	s pog = 0
	for {
		s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog)) q:(pog = "")
		s pogData = $g(^PIVA(pog))
		continue:($p(pogData, "^", 7) '= loc)
		if (packFlag '= ""){
			s mDsp = $p(pogData, "^", 1)
			s pogPack = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
			continue:(packFlag = "P")&&(pogPack '= "P")
			continue:(packFlag = "N")&&(pogPack = "P")
		}
		d ret.%Push(pog)		
	}
	q ret
}

/// Description: 病区批次合计, 一般用于配液或者总数
ClassMethod GetWardBatTotal(pogArr, pogsNo) As %DynamicObject
{
	s ret = {}
	s (packCnt, pivasCnt, cnt) = 0
	
	s len = pogArr.%Size() - 1
	for i = 0 : 1 : len {
		s pog = pogArr.%Get(i)
		continue:(pog = "")
		s pogData = $g(^PIVA(pog))
		s batNo = $p(pogData, "^", 3)
		s mDsp =  $p(pogData, "^", 1)
		s doseDate = $p(pogData, "^", 4)
		s mOeori = $p(^DHCOEDISQTY(mDsp), "^", 1)
		s adm = $p(^OEORD(+mOeori), "^", 1)
		s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
		if (packFlag = "P"){
			s packCnt = packCnt + 1
		}else{
			s pivasCnt = pivasCnt + 1
		}
		s cnt = cnt + 1
		s calcData("batNo", batNo) = $g(calcData("batNo", batNo)) + 1
		s calcData("doseDate", doseDate) = ""
	}
	q:(cnt = 0) ret
	d ..AddTitle(ret, pogArr.%Get(0))
	s ret.cnt = cnt
	s ret.batNoCntStr = $$GetBatNoCntStr()
	s ret.packCnt = packCnt
	s ret.pivasCnt = pivasCnt
	s ret.pogsNo= pogsNo
	s doseStDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($o(calcData("doseDate", "")))
	s doseEdDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($o(calcData("doseDate", ""), -1))
	s ret.doseDateRange = doseStDate _ " 至 " _ doseEdDate
	q ret
GetBatNoCntStr()
	s batNoCntStr = "", batNo = ""
	for {
		s batNo = $o(calcData("batNo", batNo), 1, batNoCnt) q:(batNo = "")
		s batNoDesc = $s(batNo '[ "批" : batNo _ "批" , 1 : batNo) 
		s batNoData = batNoDesc _ "：" _ batNoCnt
		s batNoCntStr = $s(batNoCntStr = "" : batNoData, 1 : batNoCntStr _ "；" _ batNoData)
	}
	q batNoCntStr
}

/// Description: 病区批次药品, 一般用于打包药品
/// 
ClassMethod GetWardBatInci(pogArr, pogsNo) As %DynamicObject
{
	s ret = {"rows": []}
	s len = pogArr.%Size() - 1
	for i = 0 : 1 : len {
		s pog = pogArr.%Get(i)
		continue:(pog = "")
		s pogData = $g(^PIVA(pog))
		s batNo = $p(pogData, "^", 3)
		s doseDate = $p(pogData, "^", 4)
		s calcData("batNo", batNo) = $g(calcData("batNo", batNo)) + 1
		s calcData("doseDate", doseDate) = ""
		s itm = 0
		for {
			s itm = $o(^PIVA(pog, "I", itm), 1, itmData) q:(itm = "")
			s dsp = $p(itmData, "^", 1)
			s dspData = ^DHCOEDISQTY(dsp)
			s oeori = $p(dspData, "^", 1)
			continue:(##class(web.DHCSTPIVAS.Common).OeoriPriority(oeori) [ "OM")
			s qty = $p(dspData, "^", 5)
			s arcim = $p($g(^OEORD(+oeori, "I", $p(oeori, "||", 2), 1)), "^", 2)
			s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
			s index = 1
			s calcData("INCI", index, inci) = $g(calcData("INCI", index, inci)) + qty
		}
		
	}
	s rows = []
	d rows.%Push({
		"inciDesc": "药品名称",
		"qty": "数量",
		"spec": "规格",
		"manfDesc": "生产企业",
		"uomDesc": "单位"
		
	})
	s index = ""
	for {
		s index = $o(calcData("INCI", index)) q:(index = "")
		s inci = ""
		for {
			s inci = $o(calcData("INCI", index, inci), 1, data) q:(inci = "")
			s row = {}
			s row.inciDesc = $p(^INCI(inci, 1), "^", 2)
			s row.qty = +data
			s row.spec = ##class(web.DHCST.Common.DrugInfoCommon).GetSpec( ,inci)
			s row.manfDesc = $p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci), "^", 3)
			s row.uomDesc = $p(^CT("UOM", $p(^INCI(inci, 1), "^", 10)), "^", 2)
			d rows.%Push(row)
		}
	}
	d ..AddTitle(ret, pogArr.%Get(0))
	s ret.pogsNo = pogsNo
	s ret.rows = rows
	s ret.batNoCntStr = $$GetBatNoCntStr()
	s doseStDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($o(calcData("doseDate", "")))
	s doseEdDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($o(calcData("doseDate", ""), -1))
	s ret.doseDateRange = doseStDate _ " 至 " _ doseEdDate	
	q ret
GetBatNoCntStr()
	s batNoCntStr = "", batNo = ""
	for {
		s batNo = $o(calcData("batNo", batNo), 1, batNoCnt) q:(batNo = "")
		s batNoDesc = $s(batNo '[ "批" : batNo _ "批" , 1 : batNo) 
		s batNoData = batNoDesc _ "：" _ batNoCnt
		s batNoCntStr = $s(batNoCntStr = "" : batNoData, 1 : batNoCntStr _ "；" _ batNoData)
	}
	q batNoCntStr
}

/// w ##class(web.DHCSTPIVAS.PrintWardBat).GetWardBatData("S50P20211029037").%ToJSON()
ClassMethod GetWardBatData(pogsNo) As %DynamicObject
{
	s firstPog = $o(^PIVA(0, "PogsNo", pogsNo, 0))
	s mDsp = $p($g(^PIVA(firstPog)), "^", 1)
	s wardLoc = $p(^DHCOEDISQTY(mDsp), "^", 22)
	s recLoc = $p(^DHCOEDISQTY(mDsp), "^", 24)
	s wardLocDesc = $p(^CTLOC(wardLoc), "^", 2)
	s recLocDesc = $p(^CTLOC(recLoc), "^", 2)
	s patCnt = 0, pivasCnt = 0, packCnt = 0, totalCnt = 0
	
	s poli = 0 
	for {
		s poli = $o(^POLI(poli), 1, poliData) q:(poli = "")
		s poliDesc = $p(poliData, "^", 5)
		s calcData("ordCat", poliDesc) = 0
	}
	
	s pog = 0
	for {
		s pog = $o(^PIVA(0, "PogsNo", pogsNo, pog)) q:(pog = "")
		s pogData = $g(^PIVA(pog))
		s batNo = $p(pogData, "^", 3)
		s mDsp =  $p(pogData, "^", 1)
		s mOeori = $p(^DHCOEDISQTY(mDsp), "^", 1)
		s adm = $p(^OEORD(+mOeori), "^", 1)
		s ordCatStr = ##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(mOeori)
		s ordCatDesc = $p(ordCatStr, "^", 3)
		s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
		if (packFlag = "P"){
			s packCnt = packCnt + 1
		}else{
			s pivasCnt = pivasCnt + 1
		}
		s totalCnt = totalCnt + 1
		if (packFlag '= "P"){
			s calcData("ordCat", ordCatDesc) = $g(calcData("ordCat", ordCatDesc)) + 1
		}
		if ('$d(calcData("adm", adm))){
			s patCnt = patCnt + 1
			s calcData("adm", adm) = ""
		}
		s calcData("batNo", batNo) = ""	
	}
	s ret = {}
	s ret.totalCnt = totalCnt
	s ret.pivasCnt = pivasCnt
	s ret.packCnt = packCnt
	s ret.patCnt = patCnt
	s ret.pogsNo = pogsNo
	s ret.wardLocDesc = wardLocDesc
	s ret.recLocDesc = recLocDesc
	s batNoStr = "", batNo = ""
	for {
		s batNo = $o(calcData("batNo", batNo)) q:(batNo = "")
		s batNoStr = $s(batNoStr = "" : batNo, 1 : batNoStr _ "; " _batNo)
	}
	s ret.batNoStr = batNoStr
	s ret.catRows = []
	s ordCatDesc = ""
	for {
		s ordCatDesc = $o(calcData("ordCat", ordCatDesc), 1, ordCatCnt) q:(ordCatDesc = "")
		s row = {}
		s row.description = ordCatDesc
		s row.cnt = ordCatCnt
		d ret.catRows.%Push(row)
	}
	
	q ret
}

/// Description: 给主数据, 同一单号的一般是同一病区\科室
ClassMethod AddTitle(prtJson, pog)
{
	s mDsp = $p($g(^PIVA(pog)), "^", 1)
	s wardLoc = $p(^DHCOEDISQTY(mDsp), "^", 22)
	s recLoc = $p(^DHCOEDISQTY(mDsp), "^", 24)
	s wardLocDesc = $p(^CTLOC(wardLoc), "^", 2)
	s recLocDesc = $p(^CTLOC(recLoc), "^", 2)
	s hosp=$p(^CTLOC(wardLoc), "^", 22)
	s prtJson.wardDesc = wardLocDesc
	s prtJson.recLocDesc = recLocDesc
	s prtJson.hospDesc = $p(^CT("HOSP", hosp), "^", 2)
	s prtJson.printUserName = ""
	if ($d(%session)){
		s prtJson.printUserName = %session.Data("LOGON.USERNAME")
	}
	s prtJson.printDateTime = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p($h, ",", 1)) _ " " _ ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h, ",", 2))
	q prtJson
}

}
