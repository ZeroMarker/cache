Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-06-27
/// Descript: 		安全用药智能决策系统监测中心
Class web.DHCCKBIntRevMonitor Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  合理用药审查趋势
/// w ##Class(web.DHCCKBIntRevMonitor).JsIntRevMonTrend()
ClassMethod JsIntRevMonTrend(hospId) As %String
{
	k TmpArr
	s TmpTypeArr(1)="监测总数"
	//s TmpTypeArr(2)="相互作"
	//s TmpTypeArr(3)="禁忌症"
	//s TmpTypeArr(4)="用法用量"
	//s TmpTypeArr(5)="适应症"
	
	d ..GetMonTrend(.TmpArr,hospId)

	//F i=1:1:12  D
	s month=""
	F  s month=$o(TmpArr("month",month))  q:month=""  D
	.s index=""
	.F  s index=$o(TmpTypeArr(index)) Q:index=""  D
	..s TmpArr("Trend",month_index)=month_"月^"_TmpTypeArr(index)_"^"_+$g(TmpArr("month",month))
	.
	
	s ListTitle="name^group^value"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("Trend",index)) Q:index=""  D
	.s ListData=$g(TmpArr("Trend",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Descript:  合理用药审查指标趋势图
/// w ##Class(web.DHCCKBIntRevMonitor).JsIntRevMonProp()
ClassMethod JsIntRevMonProp(hospId = "") As %String
{
	k TmpArr
	/*s TmpArr("Trend",1)="配伍禁忌^"_1
	*/
	d ..GetMonProp(.TmpArr,hospId)
	
	s ListTitle="code^name^value"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("Trend",index)) Q:index=""  D
	.s ListData=$g(TmpArr("Trend",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查趋势数据统计
ClassMethod GetMonTrend(TmpArr, hospId = "") As %String
{
	n (TmpArr,hospId)
	
	s monthList=$lb(1,2,3,4,5,6,7,8,9,10,11,12)
	s stDate=+$h-$zd($h,14)+1	// 当年开始的第一天
	s endDate=+$h
	s count=0
	s hosp = $p($g(^CT("HOSP",+hospId)),"^",2)
	
	f date=stDate:1:endDate  d	
	.s masterID=""
	.f  s masterID=$o(^CKB.PDSS.MonMasterI("CreateDate",date,masterID))  q:masterID=""  d
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(masterID),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..s count=count+1
	..s month=+$zd(date,1)
	..i $listfind(monthList,month)>0 d
	...s TmpArr("month",month)=$g(TmpArr("month",month))+1
	
	s TmpArr("count")=count
		
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查指标趋势图
ClassMethod GetMonProp(TmpArr, hospId = "") As %String
{
	n (TmpArr,hospId)
	
	s stDate=+$h-7 //-$zd($h,14)+1	// 当年开始的第一天
	s endDate=+$h
	s typeList=$lb("InterEach","Taboo","RuleIndic","RuleUsage","RuleContr")
	s count=0
	s hosp = $p($g(^CT("HOSP",+hospId)),"^",2)	
	f date=stDate:1:endDate  d
	.s masterID=""
	.f  s masterID=$o(^CKB.PDSS.MonMasterI("CreateDate",date,masterID))  q:masterID=""  d
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(masterID),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..s queID=""
	..f  s queID=$o(^CKB.PDSS.MonQueListI("Parref",masterID,queID)) q:queID=""  d 
	...s proDr=$lg(^CKB.PDSS.MonQueListD(+queID),4)
	...q:+proDr=0
	...s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proDr)),5)
	...s proDr=$case(+linkDr'=0,1:linkDr,:proDr)
	...s proCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proDr)),2)
	...s proName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proDr)),3)
	...q:proName=""
	...q:$lf(typeList,proCode)=0	// 暂时只加载固定项	
	...s TmpArr("Trend",proDr)=$g(TmpArr("Trend",proDr))+1
	...s count=count+1
	
	s TmpArr("Count")=count
	
	s count=0
	s index=""
	f  s index=$o(TmpArr("Trend",index))  q:index=""  d
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+index)),5)
	.s proID=$case(+linkDr'=0,1:linkDr,:index)
	.s proCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proID)),2)
	.s proName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proID)),3)
	.s num=$g(TmpArr("Trend",index))
	.s TmpArr("Trend",index)=proCode_"^"_proName_"^"_num
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查分类数量统计
/// w ##Class(web.DHCCKBIntRevMonitor).JsTypeTotal()
ClassMethod JsTypeTotal(hospId = "") As %String
{
	n (hospId)
	k TmpArr
	
	d ..GetMonProp(.TmpArr,hospId)
	d ..SetTotal(.TmpArr)	// 统计总数,因为GetMonProp是公共方法，因此统计总数的方法单独写
	
	s ListTitle="code^name^value"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("Trend",index)) Q:index=""  D
	.s ListData=$g(TmpArr("Trend",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		合理用药审查分类数量统计,总数
/// w ##Class(web.DHCCKBIntRevMonitor).JsTypeTotal()
ClassMethod SetTotal(TmpArr) As %String
{
	n (TmpArr)
	
	s count=$g(TmpArr("Count"))	
	s TmpArr("Trend",$o(TmpArr("Trend",""),-1)+1)="Count"_"^"_"总数"_"^"_count
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		各科室审查个数统计
/// w ##Class(web.DHCCKBIntRevMonitor).JsonQryLocRecord()
ClassMethod JsonQryLocRecord(hospId = "")
{
	n (hospId)
	k TmpArr
	
	d ..GetLocRecord(.TmpArr,hospId)	
	
	s ListTitle="xh^LocNum^Loc^InEach^Taboo^Indic^Usage^Contr"

	W "["
	s Num=1
	s index=""
	F  s index=$o(TmpArr("Trend",index),-1) Q:index=""  D
	.q:$g(TmpArr("Trend",index))=""
	.s ListData=Num_"^"_$g(TmpArr("Trend",index))
	.Q:ListData=""
	.s Num=Num+1
	.q:Num>11  //top10
	.I Num=2 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		各科室审查个数统计
/// w ##Class(web.DHCCKBIntRevMonitor).GetLocRecord()
ClassMethod GetLocRecord(TmpArr, hospId = "")
{
	
	n (TmpArr,hospId)
	
	s stDate=+$h-7 //-$zd($h,14)+1	// 当年开始的第一天
	s endDate=+$h
	s typeList=$lb("InterEach","Taboo","RuleIndic","RuleUsage","RuleContr")
	s hosp = $p($g(^CT("HOSP",+hospId)),"^",2)
	
	s count=0
	f date=stDate:1:endDate  d
	.s masterID=""
	.f  s masterID=$o(^CKB.PDSS.MonMasterI("CreateDate",date,masterID))  q:masterID=""  d	
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(masterID),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..s locDesc= $lg(^CKB.PDSS.MonMasterD(+masterID),6)
	..s queID=""
	..f  s queID=$o(^CKB.PDSS.MonQueListI("Parref",masterID,queID)) q:queID=""  d 
	...s proDr=$lg(^CKB.PDSS.MonQueListD(+queID),4)
	...q:+proDr=0
	...s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proDr)),5)
	...s proDr=$case(+linkDr'=0,1:linkDr,:proDr)
	...s proCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+proDr)),2)
	...q:$lf(typeList,proCode)=0	// 暂时只加载固定项
	...s TmpArr("TmpCount",locDesc,proCode)=$g(TmpArr("TmpCount",locDesc,proCode))+1
	...s TmpArr("TmpCount",locDesc)=$g(TmpArr("TmpCount",locDesc))+1
	...s count=count+1
	
	s TmpArr("Count")=count 	// 总数
	
	s count=0
	s loc=""
	f  s loc=$o(TmpArr("TmpCount",loc))  q:loc=""  d
	.s inEachNum=$g(TmpArr("TmpCount",loc,"InterEach"))		// 相互作用
	.s tabooNum=$g(TmpArr("TmpCount",loc,"Taboo"))			// 配伍禁忌
	.s indicNum=$g(TmpArr("TmpCount",loc,"RuleIndic"))		// 适应症
	.s usageNum=$g(TmpArr("TmpCount",loc,"RuleUsage"))		// 用法用量
	.s contrNum=$g(TmpArr("TmpCount",loc,"RuleContr"))		// 禁忌症
	.s locCount=$g(TmpArr("TmpCount",loc))					// 科室中的问题数量
	.s count=count+1
	.s num=##class(web.DHCCKBDiction).GetOrdNum(locCount+count) 
	.s TmpArr("Trend",num)=locCount_"^"_loc_"^"_inEachNum_"^"_tabooNum_"^"_indicNum_"^"_usageNum_"^"_contrNum
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		当天新增指标(药品)
/// w ##Class(web.DHCCKBIntRevMonitor).JsMonIndRule()
ClassMethod JsMonIndRule(hospId = "")
{
	k TmpArr
	
	d ..GetMonIndRule(.TmpArr,hospId)	
	
	s ListTitle="itemCode^itemName^createDate^createTime"
	W "["
	s Num=0
	s index=""
	F  s index=$o(TmpArr("Trend",index)) Q:index=""  D
	.s ListData=$g(TmpArr("Trend",index))
	.Q:ListData=""
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	W "]"
	Q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-19
/// Descript: 		当天新增指标(药品)
/// w ##Class(web.DHCCKBIntRevMonitor).GetMonIndRule()
ClassMethod GetMonIndRule(TmpArr, hospId = "") As %String
{
	n (TmpArr,hospId)
	
	s stDate=+$h-7 //-$zd($h,14)+1	// 当年开始的第一天
	s endDate=+$h
	s typeList=$lb("InterEach","Taboo","RuleIndic","RuleUsage","RuleContr")
	s hosp = $p($g(^CT("HOSP",+hospId)),"^",2)
	
	s count=0
	f date=stDate:1:endDate  d
	.s printDate=$zd(date,3)
	.s masterID=""
	.f  s masterID=$o(^CKB.PDSS.MonMasterI("CreateDate",date,masterID))  q:masterID=""  d
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(masterID),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..s printTime=$lg(^CKB.PDSS.MonMasterD(+masterID),4)
	..s printTime=$zt(printTime)
	..s queID=""
	..f  s queID=$o(^CKB.PDSS.MonQueListI("Parref",masterID,queID)) q:queID=""  d 
	...s itemDr=$lg(^CKB.PDSS.MonQueListD(+queID),3) 
	...q:+itemDr=0
	...s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+itemDr)),5)
	...s itemDr=$case(+linkDr'=0,1:linkDr,:itemDr)
	...s itemCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+itemDr)),2)
	...s itemDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+itemDr)),3)
	...//q:$lf(typeList,itemCode)=0	// 暂时只加载固定项
	...s count=count+1
	...s TmpArr("Trend",itemDesc)=itemCode_"^"_itemDesc_"^"_printDate_"^"_printTime
	
	
	q ""
}

}
