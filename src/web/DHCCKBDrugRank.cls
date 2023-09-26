/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-23
/// Descript: 		药品排行统计类
Class web.DHCCKBDrugRank Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  合理用药全院审查趋势
/// w ##Class(web.DHCCKBDrugRank).JsIntRevMonTrend("2020-11-10","2020-11-25","quarter")
ClassMethod JsIntRevMonTrend(stDate, endDate, type) As %String
{
	n (stDate,endDate,type)
	
	s retObj=..GetMonTrend(stDate,endDate,type)
	q:retObj="" ""
	
	w retObj.ToJSON()
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查趋势数据统计
/// w ##Class(web.DHCCKBDrugRank).GetMonTrend()
ClassMethod SetMonTrendNum(date, labelId, pid) As %String
{
	n (date,labelId,pid)
	
	i $d(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date)) d
	.s ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date)=$g(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date))+1
	e  d
	.s ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date)=1
	q ""
	
	/*
	s month = $SYSTEM.SQL.MONTH($zd(date,3))	// 返回月份(数字)	
	i $d(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,month)) d
	.s ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,month)=$g(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,month))+1
	e  d
	.s ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,month)=1
	*/
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查趋势数据统计
/// w ##Class(web.DHCCKBDrugRank).GetMonTrend()
ClassMethod GetMonTrend(stDate, endDate, type) As %String
{
	n (stDate,endDate,type)
	
	s pid = $o(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",""),-1)	
	s outObj = ##class(DHCNewPro.COM.Object).%New()
	s titleArr = ##class(DHCNewPro.COM.Array).%New()
	s titleCodeArr = ##class(DHCNewPro.COM.Array).%New()
	s dateNumList = ""
	
	s labelId = ""
	f  s labelId=$o(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId))  q:labelId=""  d
	.q:+labelId=0
	.s labelCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+labelId)),2) 
	.s labelDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+labelId)),3) 
	.q:(labelCode="")||(labelDesc="")
	.d titleCodeArr.Push(labelCode)
	.d titleArr.Push(labelDesc)	// 目录数组
	.s labelNum=##class(DHCNewPro.COM.Array).%New()
	.k TmpArr(type)
	.s date = ""
	.f  s date=$o(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date))  q:date=""  d
	..s num = $g(^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid,labelId,date))
	..q:(type="quarter")&($SYSTEM.SQL.YEAR($zd(date,3))'=$SYSTEM.SQL.YEAR(endDate)) // 季度不可跨年(只统计最后一年)
	..q:(type="month")&($SYSTEM.SQL.YEAR($zd(date,3))'=$SYSTEM.SQL.YEAR(endDate)) 	// 月份不可跨年
	..q:(type="week")&($SYSTEM.SQL.YEAR($zd(date,3))'=$SYSTEM.SQL.YEAR(endDate))&(($SYSTEM.SQL.MONTH($zd(date,3))'=$SYSTEM.SQL.MONTH(endDate))) 	// 周不可跨月
	..s dateNum = ""
	..i type ="year"  d
	...s dateNum = $SYSTEM.SQL.YEAR($zd(date,3))
	..e  i type = "quarter"  d
	...s dateNum =$SYSTEM.SQL.QUARTER($zd(date,3))		
	...s dateNum = dateNum_"季度"
	..e  i type = "month"  d
	...s dateNum =$SYSTEM.SQL.MONTH($zd(date,3))		
	...s dateNum = dateNum_"月"
	..e  i type = "week"  d
	...s dateNum =$SYSTEM.SQL.WEEK($zd(date,3))		
	...s dateNum = dateNum_"周"
	..e  i type = "day"  d
	...s dateNum =$zd(date,3)		
	...s dateNum = dateNum
	..q:dateNum=""		
	..s TmpArr(type,dateNum)=$g(TmpArr(type,dateNum))+num	// 记录数量
	..i $lf(dateNumList,dateNum)=0 s $list(dateNumList,*+1)=dateNum	// 记录年份
	..
	.
	.f k=1:1:$listlength(dateNumList)  d
	..s index = $listget(dateNumList,k)
	..i $d(TmpArr(type,index)) d
	...s num = $g(TmpArr(type,index))
	...d labelNum.Push(num)		// 所有年份的数量 // 若需要不显示,可以用 '-' 或者 null 或者 undefined 或者 NaN 表示。
	..e  d
	...d labelNum.Push(0)	
	.
	.d outObj.Set(labelCode,labelNum)
	
	d outObj.Set("title",titleArr)
	d outObj.Set("titleCode",titleCodeArr)		
	s xstateArr = ##class(DHCNewPro.COM.Array).%New()
	s dateNumList = $listtostring(dateNumList)
	s dateNumList = "["_dateNumList_"]"	
	d outObj.Set("xState",xstateArr.FromJSON(dateNumList))	// x轴
	
	q outObj
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查趋势数据统计(按年)
/// w ##Class(web.DHCCKBDrugRank).GetMonTrend()
ClassMethod GetMonTrendByYear(type) As %String
{
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-11-25
/// Descript: 		
/// w ##Class(web.DHCCKBDrugRank).KillTmpGlobal()
ClassMethod KillTmpGlobal(pid = "") As %String
{
	n (pid)

	if pid="" d
	.k ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum")
	else  d
	.k ^TMP("DHCCKB","web.DHCCKBDrugRank","SetMonTrendNum",pid)

	q ""
}

}
