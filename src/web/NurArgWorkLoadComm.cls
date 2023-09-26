/// 
/// 
/// 护理月报工作量登记表公共类
Class web.NurArgWorkLoadComm Extends %RegisteredObject
{

ClassMethod GetQualItems(ward As %String, month As %String) As %String
{
	w "[{""parent"":""护理质量控制"",""ParentId"":""11"",""num"":"""
	s num=0
	s row="" f  s row=$o(^DHCNMG.DB.MgQualItemD(row)) q:row=""  d
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(row)
	.s num=num+1
	w num_""",""children"":["
	s count=0
	s row="" f  s row=$o(^DHCNMG.DB.MgQualItemD(row)) q:row=""  d
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(row)
	.s itm=obj.QualDesc
	.s count=count+1
	.s sum=0,n=0,avg=0
	.s scoreid="" f  s scoreid=$O(^DHCNMG.CHK.MgCheckRoomI("Qual"," "_row," "_ward,$zdh(month,3),scoreid)) q:scoreid=""  d
	..s scoreobj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(scoreid)
	..s sum=sum+scoreobj.CheckScore
	..s n=n+1
	.i n'=0 s avg=$fn(sum/n,"",2)
	.i count=1 w "{""qualitm"":"""_itm_""",""CheckItmId"":"""_row_""",""CheckNum"":"""_n_""",""Total"":"""_sum_""",""Avge"":"""_avg_"""}"
	.e  w ",{""qualitm"":"""_itm_""",""CheckItmId"":"""_row_""",""CheckNum"":"""_n_""",""Total"":"""_sum_""",""Avge"":"""_avg_"""}"
	w "]}]"
	q ""
}

ClassMethod SaveReportItem(parr As %String, user As %String) As %String
{
	;s ^TMP("SaveReportItem")=parr_"%"_user
	q:parr="" ""
	s id=$p(parr,"^",2)
	s itmtype=$p(parr,"^",1)
	s sort=$p(parr,"^",3)
	s ward=$p(parr,"^",4)
	i id="" s obj=##class(DHCNMG.DB.MgReportItem).%New()
	e  s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(id)
	s obj.ReportType=$zcvt($tr(itmtype," ",""),"U")
	s obj.ReportSort=sort
	s obj.ReportUser=user
	s obj.ReportWard=ward
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetReportSort() As %String
{
	s flag=0
	s sort=$O(^DHCNMG.DB.MgReportItemI("Sort",""),-1)
	s flag=sort+1
	q flag
}

/// Creator:guozj
/// Description:查询护理工作量项目类型
/// Date:2018-07-16
/// Table: DHCNMG.DB.MgReportItem
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindReportType","1")
Query FindReportType(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindReportTypeExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s ^TMP("FindReportType")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.DB.MgReportItemI("Sort",sort)) q:sort=""  d
	.s row="" f  s row=$O(^DHCNMG.DB.MgReportItemI("Sort",sort,row)) q:row=""  d
	..s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(row)
	..s reportType=obj.ReportType
	..q:((input'="")&&(reportType'[input))
	..s reportSort=obj.ReportSort
	..s reportUser=obj.ReportUser
	..s reportWard=""
	..i obj.ReportWard'="" d
	...s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ReportWard)
	...s reportWard=wardobj.WardDesc
	..s ret="reportType|"_reportType_"^reportSort|"_reportSort_"^RowID|"_row_"^reportUser|"_reportUser_"^reportWard|"_reportWard
	..do OutputReportData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReportData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReportTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReportTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindReportTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReportTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MoveReportSort(rowid As %String, type As %String) As %String
{
	;s ^TMP("MoveReportSort")=rowid_"%"_type
	q:rowid="" ""
	s ret=0
	s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(rowid)
	s sort=obj.ReportSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.ReportSort=sort-1
		.s row=$O(^DHCNMG.DB.MgReportItemI("Sort",sort-1,""))
		.s bobj=##class(DHCNMG.DB.MgReportItem).%OpenId(row)
		.s bobj.ReportSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.DB.MgReportItemI("Sort",""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.ReportSort=sort+1
		.s row=$O(^DHCNMG.DB.MgReportItemI("Sort",sort+1,""))
		.s bobj=##class(DHCNMG.DB.MgReportItem).%OpenId(row)
		.s bobj.ReportSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

ClassMethod GetReportData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(id)
	q:'$IsObject(obj) ""
	s ReportType=obj.ReportType
	s ReportSort=obj.ReportSort
	s ReportWard=obj.ReportWard
	s ret="ReportType|"_ReportType_"^ReportSort|"_ReportSort_"^RowID|"_id_"^ReportWard|"_ReportWard
	q ret
}

/// 
/// 保存护理月报工作量项目明细
ClassMethod SaveDetailItem(parr As %String, user As %String) As %String
{
	q:parr="" "" //1^高危药物外渗的发生率（%）或例次^静脉使用高危药物发生外渗的例数^静脉使用高风险药物人数
	s Par=$tr($p(parr,"^",1)," ","") //父表ID
	s DetailItem=$tr($p(parr,"^",2)," ","") //项目
	s DetailMolecular=$tr($p(parr,"^",3)," ","") //分子
	s DetailDenominator=$tr($p(parr,"^",4)," ","") //分母
	s RowID=$tr($p(parr,"^",5)," ","") //子表ID
	i RowID="" d
	.s obj=##class(DHCNMG.DB.MgReportItemSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgReportItem).%OpenId(Par)
	e  s obj=##class(DHCNMG.DB.MgReportItemSub).%OpenId(Par_"||"_RowID)
	s obj.DetailItem=DetailItem
	s obj.DetailMolecular=DetailMolecular
	s obj.DetailDenominator=DetailDenominator
	s obj.DetailCreator=user
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询护理工作量项目明细
/// Date:2018-07-16
/// Table: DHCNMG.DB.MgReportItemSub
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindDetailList","1")
Query FindDetailList(Par As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindDetailListExecute(ByRef qHandle As %Binary, Par As %String, input As %String = "") As %Status
{
	;s ^TMP("FindDetailList")=Par
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s Rw="" f  s Rw=$o(^DHCNMG.DB.MgReportItemSubD(Par,Rw)) q:Rw=""  d
	.s Obj=##class(DHCNMG.DB.MgReportItemSub).%OpenId(Par_"||"_Rw)
	.s detailItem=Obj.DetailItem
	.s detailMolecular=Obj.DetailMolecular
	.s detailDenominator=Obj.DetailDenominator
	.s ret="detailItem|"_detailItem_"^detailMolecular|"_detailMolecular_"^detailDenominator|"_detailDenominator_"^Par|"_Par_"^Rw|"_Rw
	.do OutputDetailData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDetailData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDetailListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetails(Par As %String, Rw As %String) As %String
{
	;s ^TMP("GetDetails")=Par_"%"_Rw
	q:((Par="")!(Rw="")) ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgReportItemSub).%OpenId(Par_"||"_Rw)
	s DetailItem=obj.DetailItem
	s DetailMolecular=obj.DetailMolecular
	s DetailDenominator=obj.DetailDenominator
	s ret="DetailItem|"_DetailItem_"^DetailMolecular|"_DetailMolecular_"^DetailDenominator|"_DetailDenominator_"^RowID|"_Rw
	q ret
}

/// 
/// 临床护理质量指标
ClassMethod GetReportItem(ward As %String, month As %String) As %String
{
	w "["
	s n=0
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgReportItemD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(RowID)
	.s parent=obj.ReportType
	.s parentid=RowID
	.s num=..GetReportParentNum(RowID)
	.q:((ward'="")&&(obj.ReportWard'=ward)&&(obj.ReportWard'=""))
	.s n=n+1
	.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_"2"_RowID_""",""num"":"""_num_""",""children"":["
	.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_"2"_RowID_""",""num"":"""_num_""",""children"":["
	.s count=0
	.s Rw="" f  s Rw=$O(^DHCNMG.DB.MgReportItemSubD(RowID,Rw)) q:Rw=""  d
	..s SubObj=##class(DHCNMG.DB.MgReportItemSub).%OpenId(RowID_"||"_Rw)
	..s checkItem=SubObj.DetailItem
	..s checkItemId=RowID_"||"_Rw
	..s molecular=SubObj.DetailMolecular
	..s denominator=SubObj.DetailDenominator
	..s count=count+1
	..i count=1 w "{""checkItem"":"""_checkItem_""",""CheckItmId"":"""_checkItemId_""",""molecular"":"""_molecular_""",""denominator"":"""_denominator_""",""MoleNum"":""0"",""DenoNum"":""0"",""Rate"":""0""}"
	..e  w ",{""checkItem"":"""_checkItem_""",""CheckItmId"":"""_checkItemId_""",""molecular"":"""_molecular_""",""denominator"":"""_denominator_""",""MoleNum"":""0"",""DenoNum"":""0"",""Rate"":""0""}"
	.w "]}"
	w "]"
	q ""
}

/// 计算全院的在院患者
ClassMethod GetAllInHosPatSum(stDate As %String, endDate As %String, ward As %String) As %String
{
	q:((stDate="")||(endDate="")||(ward="")) ""
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	s tmp="",ret=""
}

/// 
/// 临床护理质量指标
ClassMethod GetReportItem1(ward As %String, month As %String) As %String
{
	s monthDay=$p(month,"-",2)+1
	s lastMonthDay=$zd($zdh(($p(month,"-",1)_"-"_monthDay_"-01"),3)-1,3)
	w "["
	s n=0
	s tmp=""
	s reportDataSum=..GetReportDataOfMonth(month,lastMonthDay,ward,.tmp)
	s bradenNum=..GetBradenNum(ward,month,lastMonthDay) //获取braden评分且评分小于12分的人
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgReportItemD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgReportItem).%OpenId(RowID)
	.s parent=obj.ReportType
	.s parentid=RowID
	.s num=..GetReportParentNum(RowID)
	.q:((ward'="")&&(obj.ReportWard'=ward)&&(obj.ReportWard'=""))
	.s n=n+1
	.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_"2"_RowID_""",""num"":"""_num_""",""children"":["
	.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_"2"_RowID_""",""num"":"""_num_""",""children"":["
	.s count=0
	.s AllInHosPatSum=0
	.//取所有在院患者
	.;s AllInHosPatSum=..GetAllInHosPatSum(month,lastMonthDay,ward)
	.s Rw="" f  s Rw=$O(^DHCNMG.DB.MgReportItemSubD(RowID,Rw)) q:Rw=""  d
	..s SubObj=##class(DHCNMG.DB.MgReportItemSub).%OpenId(RowID_"||"_Rw)
	..s checkItem=SubObj.DetailItem
	..s checkItemId=RowID_"||"_Rw
	..s molecular=SubObj.DetailMolecular //分子
	..s denominator=SubObj.DetailDenominator ///分母
	..s MoleNum=0,DenoNum=0,Rate=0
	..i checkItem="高危药物外渗的发生率（%）或例次" d
	...i $g(tmp(ward,1))'="" s MoleNum=$g(tmp(ward,1))
	...i $g(tmp(ward,2))'="" s DenoNum=$g(tmp(ward,2))
	...i (MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0)
	..i checkItem="输液反应例次" d
	...i $g(tmp(ward,3))'="" s MoleNum=$g(tmp(ward,3))
	..i checkItem="输血反应例次" d
	...i $g(tmp(ward,4))'="" s MoleNum=$g(tmp(ward,4))
	..i checkItem="非计划拔管发生率（‰）或例次1" d
	...i $g(tmp(ward,8))'="" s MoleNum=$g(tmp(ward,8))
	...s DenoNum=$fn($fn($g(tmp(ward,11)),"",2)+$fn($g(tmp(ward,12)),"",2)+$fn($g(tmp(ward,13)),"",2)+$fn($g(tmp(ward,14)),"",2)+$fn($g(tmp(ward,15)),"",2)+$fn($g(tmp(ward,16)),"",2)+$fn($g(tmp(ward,17)),"",2),"",2)
	...i ((MoleNum'="")&&(MoleNum'=0)&&(DenoNum'="")&&(DenoNum'=0))
	..i checkItem="非计划拔管发生率（‰）或例次2" d
	...s MoleNum=$fn($g(tmp(ward,6)),"",2)+$fn($g(tmp(ward,7)),"",2)+$fn($g(tmp(ward,9)),"",2)
	...s DenoNum=$fn($fn($g(tmp(ward,11)),"",2)+$fn($g(tmp(ward,12)),"",2)+$fn($g(tmp(ward,13)),"",2)+$fn($g(tmp(ward,14)),"",2)+$fn($g(tmp(ward,15)),"",2)+$fn($g(tmp(ward,16)),"",2)+$fn($g(tmp(ward,17)),"",2),"",2)
	...i ((MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0))
	..i checkItem="非计划拔管发生率（‰）或例次3" d
	...s MoleNum=$fn($g(tmp(ward,6)),"",2)+$fn($g(tmp(ward,7)),"",2)+$fn($g(tmp(ward,8)),"",2)+$fn($g(tmp(ward,9)),"",2)
	...s DenoNum=$fn($fn($g(tmp(ward,11)),"",2)+$fn($g(tmp(ward,12)),"",2)+$fn($g(tmp(ward,13)),"",2)+$fn($g(tmp(ward,14)),"",2)+$fn($g(tmp(ward,15)),"",2)+$fn($g(tmp(ward,16)),"",2)+$fn($g(tmp(ward,17)),"",2),"",2)
	...i ((MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0))
	..i checkItem="患者入院前已有压疮率（‰）" d
	...i $g(tmp(ward,41))'="" s MoleNum=$g(tmp(ward,41))
	..i checkItem="压疮高风险患者评估率（%）" d
	...i $g(tmp(ward,40))'="" s MoleNum=$g(tmp(ward,40))
	...s DenoNum=bradenNum
	...i ((MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0)) //计算Rate
	..i checkItem="住院患者或高风险患者压疮发生率（‰）" d
	...
	..i checkItem="住院患者手术室压疮发生率（‰）" d
	...
	..i checkItem="排便失禁患者失禁性皮炎发生率（‰）" d
	...
	..i checkItem="跌倒高风险患者评估率（%）" d
	...i $g(tmp(ward,47))'="" s MoleNum=$g(tmp(ward,47))
	...i $g(tmp(ward,49))'="" s DenoNum=$g(tmp(ward,49))
	...i ((MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0)) //计算Rate
	..i checkItem="住院患者跌倒发生率（%）1" d
	...i $g(tmp(ward,48))'="" s MoleNum=$g(tmp(ward,48))
	...i $g(tmp(ward,47))'="" s DenoNum=$g(tmp(ward,47))
	...i ((MoleNum'="")&&(DenoNum'="")&&(DenoNum'=0)) //计算Rate
	..i checkItem="住院患者跌倒发生率（%）2" d
	...i $g(tmp(ward,48))'="" s MoleNum=$g(tmp(ward,48))
	...//计算住院患者人数
	..i checkItem="高风险患者跌倒人次" d
	...i $g(tmp(ward,49))'="" s MoleNum=$g(tmp(ward,49))
	..i checkItem="住院患者或高风险患者误吸发生率（‰）1" d
	...i $g(tmp(ward,50))'="" s MoleNum=$g(tmp(ward,50))
	...//计算住院患者人数
	..i checkItem="住院患者或高风险患者误吸发生率（‰）2" d
	...i $g(tmp(ward,50))'="" s MoleNum=$g(tmp(ward,50))
	...// 计算护理组长或护士长审核确定为误吸高风险患者人次  【没有误吸评估单】
	..i checkItem="住院患者误吸高风险评估率（%）" d
	...//【没有误吸评估单】
	..i checkItem="首次误吸并发窒息发生率（‰）" d
	...i $g(tmp(ward,56))'="" s MoleNum=$g(tmp(ward,56))
	...//w误吸并发生窒息 没有单据评估
	..i checkItem="两次或以上误吸并发窒息发生率（%）" d
	...i $g(tmp(ward,57))'="" s MoleNum=$g(tmp(ward,57))
	...//误吸并发生窒息 没有单据评估
	..i checkItem="误吸并发肺炎发生率（‰）" d
	...//取不到数据
	..i checkItem="患者走失发生率（‰）" d
	...i $g(tmp(ward,60))'="" s MoleNum=$g(tmp(ward,60))
	...//住院患者
	..i checkItem="患者走失高风险患者评估率（%）" d
	...//没有单据取不到数据
	..i checkItem="患者足下垂的发生率（‰）" d
	...i $g(tmp(ward,63))'="" s MoleNum=$g(tmp(ward,63))
	...//住院患者人数
	..i checkItem="使用药物错误的发生率（‰）或发生例数（例）" d
	...i $g(tmp(ward,70))'="" s MoleNum=$g(tmp(ward,70))
	...//住院患者人数
	..i checkItem="急救设备器材及药品完好不合格率（%）" d
	...//获取不到数据
	..s count=count+1
	..i count=1 w "{""checkItem"":"""_checkItem_""",""CheckItmId"":"""_checkItemId_""",""molecular"":"""_molecular_""",""denominator"":"""_denominator_""",""MoleNum"":"""_MoleNum_""",""DenoNum"":"""_DenoNum_""",""Rate"":"""_Rate_"""}"
	..e  w ",{""checkItem"":"""_checkItem_""",""CheckItmId"":"""_checkItemId_""",""molecular"":"""_molecular_""",""denominator"":"""_denominator_""",""MoleNum"":"""_MoleNum_""",""DenoNum"":"""_DenoNum_""",""Rate"":"""_Rate_"""}"
	.w "]}"
	w "]"
	q ""
}

/// 
/// 获取Braden评分小于12分的人数
ClassMethod GetBradenNum(ward As %String, month As %String, lastMonthDay As %String) As %String
{
	s month=$zdh(month,3)
	s lastMonthDay=$zdh(lastMonthDay,3)
	s num=0
	s episode="" f  s episode=$o(^Nur.DHCMoudDataI("EmrCode"," DHCNURPGD_BDY5SYCFXPGHLD",episode)) q:episode=""  d
	.s rowId="" f  s rowId=$o(^Nur.DHCMoudDataI("EmrCode"," DHCNURPGD_BDY5SYCFXPGHLD",episode,rowId)) q:rowId=""  d
	..;s obj=##class(Nur.DHCMoudData).%OpenId(rowId)
	..s flag=0
	..s sub="" f  s sub=$o(^Nur.DHCMoudDataD(rowId,"ChildRec",sub)) q:(sub=""||flag=1)  d
	...s obj=##class(Nur.DHCMoudDataSub).%OpenId(rowId_"||"_sub)
	...
	...q:obj.RecLoc=""
	...q:(obj.RecLoc'=ward)
	...q:((month'="")&&(obj.Item10'="")&&($zdh(obj.Item10,3)<month))
	...q:((lastMonthDay'="")&&(obj.Item10'="")&&($zdh(obj.Item10,3)>lastMonthDay))
	...q:(obj.Item29'="")&&(obj.Item29>12)
	...s num=num+1
	...s flag=1
	q num
}

/// 
/// 获取住院患者数
ClassMethod GetInHosPatNum() As %String
{
}

/// 
/// 按天查询计算出月的工作量临床护理质量指标数据
/// 按照指标对应的WorkSort 提取
ClassMethod GetReportDataOfMonth(firstMonthDay, lastMonthDay, ward, tmp) As %String
{
	q:((firstMonthDay="")||(lastMonthDay="")||(ward="")) ""
	s firstMonthDay=$zdh(firstMonthDay,3)
	s lastMonthDay=$zdh(lastMonthDay,3)
	s tmp="",ret=""
	f date=firstMonthDay:1:lastMonthDay
	{
		s WorkSort="" f  s WorkSort=$o(^DHCNMG.Arg.MgArgDayWorkI("Date",date,ward,WorkSort)) q:WorkSort=""  d
		.s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArgDayWorkI("Date",date,ward,WorkSort,RowID)) q:RowID=""  d
		..s obj=##class(DHCNMG.Arg.MgArgDayWork).%OpenId(RowID)
		..i $g(tmp(ward,WorkSort))="" s tmp(ward,WorkSort)=$fn(obj.WorkNum,"",2)
		..e  s tmp(ward,WorkSort)=$fn(tmp(ward,WorkSort)+$fn(obj.WorkNum,"",2),"",2)
	}
	b ;01
	q tmp
}

ClassMethod GetReportParentNum(Par As %String) As %String
{
	s num=0
	s Rw="" f  s Rw=$O(^DHCNMG.DB.MgReportItemSubD(Par,Rw)) q:Rw=""  d
	.s num=num+1
	q num
}

ClassMethod SaveClinicalItem(parr As %String, user As %String) As %String
{
	s ^TMP("SaveClinicalItem")=parr_"%"_user
	q:parr="" ""
	s id=$p(parr,"^",2)
	s itmtype=$p(parr,"^",1)
	i id="" s obj=##class(DHCNMG.DB.MgClinicalType).%New()
	e  s obj=##class(DHCNMG.DB.MgClinicalType).%OpenId(id)
	s obj.ClinicalType=$zcvt($tr(itmtype," ",""),"U")
	s obj.ClinicalUser=user
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetClinicData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgClinicalType).%OpenId(id)
	q:'$IsObject(obj) ""
	s ClinicalType=obj.ClinicalType
	s ret="ClinicalType|"_ClinicalType_"^RowID|"_id
	q ret
}

/// Creator:guozj
/// Description:查询护理临床工作项目类型
/// Date:2018-07-16
/// Table: DHCNMG.DB.MgClinicalType
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindClincalType","1")
Query FindClincalType(parr As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindClincalTypeExecute(ByRef qHandle As %Binary, parr As %String, input As %String = "") As %Status
{
	s ^TMP("FindClincalType")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s row="" f  s row=$O(^DHCNMG.DB.MgClinicalTypeD(row)) q:row=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalType).%OpenId(row)
	.s clinicalType=obj.ClinicalType
	.q:((input'="")&&(clinicalType'[input))
	.s clinicalUser=obj.ClinicalUser
	.s ret="clinicalType|"_clinicalType_"^RowID|"_row_"^clinicalUser|"_clinicalUser
	.do OutputClinicalData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputClinicalData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindClincalTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClincalTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindClincalTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClincalTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// 保存护理临床工作量项目明细
ClassMethod SaveClinicalDetail(parr As %String, user As %String) As %String
{
	q:parr="" ""
	s Par=$tr($p(parr,"^",1)," ","") //父表ID
	s DetailItem=$tr($p(parr,"^",2)," ","") //项目
	s RowID=$tr($p(parr,"^",3)," ","") //子表ID
	i RowID="" d
	.s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgClinicalType).%OpenId(Par)
	e  s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(Par_"||"_RowID)
	s obj.DetailItem=DetailItem
	s obj.DetailCreator=user
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetClinicDetails(Par As %String, Rw As %String) As %String
{
	;s ^TMP("GetDetails")=Par_"%"_Rw
	q:((Par="")!(Rw="")) ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(Par_"||"_Rw)
	s DetailItem=obj.DetailItem
	s ret="DetailItem|"_DetailItem_"^RowID|"_Rw
	q ret
}

/// Creator:guozj
/// Description:查询护理工作量项目明细
/// Date:2018-07-16
/// Table: DHCNMG.DB.MgClinicalTypeSub
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindClinicDetail","1")
Query FindClinicDetail(Par As %String, input As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindClinicDetailExecute(ByRef qHandle As %Binary, Par As %String, input As %String = "") As %Status
{
	;s ^TMP("FindClinicDetail")=Par
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",Par,sort)) q:sort=""  d
	.s Rw="" f  s Rw=$o(^DHCNMG.DB.MgClinicalTypeSubI("Sort",Par,sort,Rw)) q:Rw=""  d
	..s Obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(Par_"||"_Rw)
	..s detailItem=Obj.DetailItem
	..s ret="detailItem|"_detailItem_"^Par|"_Par_"^Rw|"_Rw
	..do OutputDetailData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDetailData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindClinicDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClinicDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindClinicDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClinicDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatNumForInstruc(stDate As %String, endDate As %String, ward As %String) As %String
{
	
	q ""
}

/// 
/// 获取护理临床工作项目
ClassMethod GetOtherItems(ward As %String, month As %String) As %String
{
	s ^TMP("GetOtherItems")=ward_"%"_month
	s monthDay=$p(month,"-",2)+1
	s lastMonthDay=$zd($zdh(($p(month,"-",1)_"-"_monthDay_"-01"),3)-1,3)
	w "["
	s n=0
	;s otherItemSum=..GetPatCareLevel(month,lastMonthDay,ward)
	s otherItemSum=..GetNumsForOrderOrInstruc(month,ward)
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgClinicalTypeD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalType).%OpenId(RowID)
	.s parent=obj.ClinicalType
	.s parentid=RowID
	.s num=..GetOtherParentNum(RowID)
	.;q:((ward'="")&&(obj.ReportWard'=ward)&&(obj.ReportWard'=""))
	.s n=n+1
	.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_"3"_RowID_""",""num"":"""_num_""",""children"":["
	.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_"3"_RowID_""",""num"":"""_num_""",""children"":["
	.s count=0
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",RowID,sort)) q:sort=""  d
	..s Rw="" f  s Rw=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",RowID,sort,Rw)) q:Rw=""  d
	...s SubObj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(RowID_"||"_Rw)
	...s checkitm=SubObj.DetailItem
	...s checkitmid=RowID_"||"_Rw
	...s count=count+1
	...s checkItemNum=0
	...i checkitm="病危" s checkItemNum=$p(otherItemSum,"^",1)
	...e  i checkitm="病重" s checkItemNum=$p(otherItemSum,"^",2)
	...e  i checkitm="一级护理" s checkItemNum=$p(otherItemSum,"^",3)
	...e  i checkitm="二级护理" s checkItemNum=$p(otherItemSum,"^",4)
	...e  i checkitm="科内手术" s checkItemNum=$p(otherItemSum,"^",5)
	...e  i checkitm="手术" s checkItemNum=..GetOprationsCounts(month,lastMonthDay,ward)
	...e  i checkitm="压疮护理"  s checkItemNum=$p(otherItemSum,"^",6)
	...e  i checkitm="换药" s checkItemNum=$p(otherItemSum,"^",7)
	...e  i checkitm="换引流瓶（袋）" s checkItemNum=$p(otherItemSum,"^",8)
	...e  i checkitm="口腔护理" s checkItemNum=$p(otherItemSum,"^",9)
	...e  i checkitm="雾化吸入" s checkItemNum=$p(otherItemSum,"^",10)
	...e  i checkitm="床边洗头" s checkItemNum=$p(otherItemSum,"^",11)
	...e  i checkitm="床上浴" s checkItemNum=$p(otherItemSum,"^",12)
	...e  i checkitm="剪指（趾）甲" s checkItemNum=$p(otherItemSum,"^",13)
	...e  i checkitm="导尿" s checkItemNum=$p(otherItemSum,"^",14)
	...e  i checkitm="会阴擦洗（冲洗）" s checkItemNum=$p(otherItemSum,"^",15)
	...e  i checkitm="膀胱冲洗" s checkItemNum=$p(otherItemSum,"^",16)
	...e  i checkitm="灌肠" s checkItemNum=$p(otherItemSum,"^",17)
	...e  i checkitm="各种注射" s checkItemNum=$p(otherItemSum,"^",18)
	...e  i checkitm="静脉抽血" s checkItemNum=$p(otherItemSum,"^",19)
	...e  i checkitm="动脉抽血" s checkItemNum=$p(otherItemSum,"^",20)
	...e  i checkitm="测微量血糖" s checkItemNum=$p(otherItemSum,"^",21)
	...i count=1 w "{""checkitm"":"""_checkitm_""",""CheckItmId"":"""_checkitmid_""",""CheckNum"":"""_checkItemNum_"""}"
	...e  w ",{""checkitm"":"""_checkitm_""",""CheckItmId"":"""_checkitmid_""",""CheckNum"":"""_checkItemNum_"""}"
	.w "]}"
	w "]"
	q ""
}

ClassMethod GetOtherItems1(ward As %String, month As %String) As %String
{
	s monthDay=$p(month,"-",2)+1
	s lastMonthDay=$zd($zdh(($p(month,"-",1)_"-"_monthDay_"-01"),3)-1,3)
	w "["
	s n=0
	s tmp=""
	s otherItemSum=..GetWardNumsOfMonth(month,lastMonthDay,ward,.tmp)
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgClinicalTypeD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalType).%OpenId(RowID)
	.s parent=obj.ClinicalType
	.s parentid=RowID
	.s num=..GetOtherParentNum(RowID)
	.;q:((ward'="")&&(obj.ReportWard'=ward)&&(obj.ReportWard'=""))
	.s n=n+1
	.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_"3"_RowID_""",""num"":"""_num_""",""children"":["
	.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_"3"_RowID_""",""num"":"""_num_""",""children"":["
	.s count=0
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",RowID,sort)) q:sort=""  d
	..s Rw="" f  s Rw=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",RowID,sort,Rw)) q:Rw=""  d
	...s SubObj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(RowID_"||"_Rw)
	...s checkitm=SubObj.DetailItem
	...s checkitmid=RowID_"||"_Rw
	...s count=count+1
	...s checkItemNum=0
	...i $g(tmp(ward,checkitm))'="" s checkItemNum=tmp(ward,checkitm)
	...e  s tmp(ward,checkitm)=0
	...i count=1 w "{""checkitm"":"""_checkitm_""",""CheckItmId"":"""_checkitmid_""",""CheckNum"":"""_checkItemNum_"""}"
	...e  w ",{""checkitm"":"""_checkitm_""",""CheckItmId"":"""_checkitmid_""",""CheckNum"":"""_checkItemNum_"""}"
	.w "]}"
	w "]"
	q ""
}

ClassMethod GetWardNumsOfMonth(firstMonthDay, lastMonthDay, ward, tmp) As %String
{
	q:((firstMonthDay="")||(lastMonthDay="")||(ward="")) ""
	s firstMonthDay=$zdh(firstMonthDay,3)
	s lastMonthDay=$zdh(lastMonthDay,3)
	s tmp="",ret=""
	f date=firstMonthDay:1:lastMonthDay
	{
		s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgClinicDayWorkI("date",date," "_ward,RowID)) q:RowID=""  d
		.s obj=##class(DHCNMG.Arg.MgClinicDayWork).%OpenId(RowID)
		.i $g(tmp(ward,"病危"))="" s tmp(ward,"病危")=obj.ClinicCriticaly
		.e  s tmp(ward,"病危")=tmp(ward,"病危")+obj.ClinicCriticaly
		.i $g(tmp(ward,"病重"))="" s tmp(ward,"病重")=obj.ClinicSick
		.e  s tmp(ward,"病重")=tmp(ward,"病重")+obj.ClinicSick
		.i $g(tmp(ward,"一级护理"))="" s tmp(ward,"一级护理")=obj.ClinicFirstCare
		.e  s tmp(ward,"一级护理")=tmp(ward,"一级护理")+obj.ClinicFirstCare
		.i $g(tmp(ward,"二级护理"))="" s tmp(ward,"二级护理")=obj.ClinicSecondCare
		.e  s tmp(ward,"二级护理")=tmp(ward,"二级护理")+obj.ClinicSecondCare
		.i $g(tmp(ward,"手术"))="" s tmp(ward,"手术")=obj.ClinicSurgery
		.e  s tmp(ward,"手术")=tmp(ward,"手术")+obj.ClinicSurgery
		.i $g(tmp(ward,"科内手术"))="" s tmp(ward,"科内手术")=obj.ClinicInSurgery
		.e  s tmp(ward,"科内手术")=tmp(ward,"科内手术")+obj.ClinicInSurgery
		.i $g(tmp(ward,"压疮护理"))="" s tmp(ward,"压疮护理")=obj.ClinicPressCare
		.e  s tmp(ward,"压疮护理")=tmp(ward,"压疮护理")+obj.ClinicPressCare
		.i $g(tmp(ward,"换药"))="" s tmp(ward,"换药")=obj.ClinicDresse
		.e  s tmp(ward,"换药")=tmp(ward,"换药")+obj.ClinicDresse
		.i $g(tmp(ward,"换引流瓶（袋）"))="" s tmp(ward,"换引流瓶（袋）")=obj.ClinicDrainage
		.e  s tmp(ward,"换引流瓶（袋）")=tmp(ward,"换引流瓶（袋）")+obj.ClinicDrainage
		.i $g(tmp(ward,"口腔护理"))="" s tmp(ward,"口腔护理")=obj.ClinicOralCare
		.e  s tmp(ward,"口腔护理")=tmp(ward,"口腔护理")+obj.ClinicOralCare
		.i $g(tmp(ward,"雾化吸入"))="" s tmp(ward,"雾化吸入")=obj.ClinicInhalation
		.e  s tmp(ward,"雾化吸入")=tmp(ward,"雾化吸入")+obj.ClinicInhalation
		.i $g(tmp(ward,"床边洗头"))="" s tmp(ward,"床边洗头")=obj.ClinicShampoo
		.e  s tmp(ward,"床边洗头")=tmp(ward,"床边洗头")+obj.ClinicShampoo
		.i $g(tmp(ward,"床上浴"))="" s tmp(ward,"床上浴")=obj.ClinicBedBath
		.e  s tmp(ward,"床上浴")=tmp(ward,"床上浴")+obj.ClinicBedBath
		.i $g(tmp(ward," 剪指（趾）甲"))="" s tmp(ward," 剪指（趾）甲")=obj.ClinicCutNail
		.e  s tmp(ward," 剪指（趾）甲")=tmp(ward," 剪指（趾）甲")+obj.ClinicCutNail
		.i $g(tmp(ward,"导尿"))="" s tmp(ward,"导尿")=obj.ClinicCatherize
		.e  s tmp(ward,"导尿")=tmp(ward,"导尿")+obj.ClinicCatherize
		.i $g(tmp(ward,"会阴擦洗（冲洗）"))="" s tmp(ward,"会阴擦洗（冲洗）")=obj.ClinicScrub
		.e  s tmp(ward,"会阴擦洗（冲洗）")=tmp(ward,"会阴擦洗（冲洗）")+obj.ClinicScrub
		.i $g(tmp(ward,"膀胱冲洗"))="" s tmp(ward,"膀胱冲洗")=obj.ClinicBladderClean
		.e  s tmp(ward,"膀胱冲洗")=tmp(ward,"膀胱冲洗")+obj.ClinicBladderClean
		.i $g(tmp(ward,"灌肠"))="" s tmp(ward,"灌肠")=obj.ClinicClyster
		.e  s tmp(ward,"灌肠")=tmp(ward,"灌肠")+obj.ClinicClyster
		.i $g(tmp(ward,"各种注射"))="" s tmp(ward,"各种注射")=obj.ClinicInjection
		.e  s tmp(ward,"各种注射")=tmp(ward,"各种注射")+obj.ClinicInjection
		.i $g(tmp(ward,"静脉抽血"))="" s tmp(ward,"静脉抽血")=obj.ClinicVenousBlood
		.e  s tmp(ward,"静脉抽血")=tmp(ward,"静脉抽血")+obj.ClinicVenousBlood
		.i $g(tmp(ward,"动脉抽血"))="" s tmp(ward,"动脉抽血")=obj.ClinicArterialBlood
		.e  s tmp(ward,"动脉抽血")=tmp(ward,"动脉抽血")+obj.ClinicArterialBlood
		.i $g(tmp(ward,"测微量血糖"))="" s tmp(ward,"测微量血糖")=obj.ClinicBloodSugar
		.e  s tmp(ward,"测微量血糖")=tmp(ward,"测微量血糖")+obj.ClinicBloodSugar
		
	}
	q tmp
}

/// Creator:gzj
/// CreateDate:2018-08-04
/// Descrpiton:按照护理单元获取开始日期和结束日期之内的病危、病重、一级护理、二级护理、手术申请的医嘱个数
/// Table:
/// Input:
/// Output:
/// Return:
ClassMethod GetPatCareLevel(stDate As %String, endDate As %String, wardID As %String) As %String
{
	q:((stDate="")!(endDate="")) ""
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardID)
	q:'$IsObject(wardObj) ""
	s locId=wardObj.CTLocDR.%Id()
	q:locId="" ""
	s locObj=##class(User.CTLoc).%OpenId(locId)
	q:'$IsObject(locObj) ""
	s locCode=locObj.CTLOCCode
	s departId=$o(^CTLOC(0,"Code",$E(locCode,2,$l(locCode)),""))
	q:departId="" ""
	s ill=0,sick=0,firstCare=0,secondCare=0,surgery=0
	s tmp("病危")=0,tmp("病重")=0,tmp("一级护理")=0,tmp("二级护理")=0,tmp("科室手术")=0
	f date=stDate:1:endDate
	{
		s orderParref="" f  s orderParref=$o(^OEORDi(0,"ItemDate",date,orderParref)) q:orderParref=""  d
		.s orderId="" f  s orderId=$o(^OEORDi(0,"ItemDate",date,orderParref,orderId)) q:orderId=""  d
		..s ordState=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",13)
		..s stateCode=$p($g(^OEC("OSTAT",ordState)),"^",1)
		..q:"VED"'[stateCode
		..s ordDept=$p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
		..q:ordDept'=departId
		..s itmMastDr=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",2)
		..//病危 14504||1 病重 14503||1 一级护理5200||1  二级护理 5201||1 手术申请16950||1
		..s tmp("病危")=..GetItmCount(..GetClinicItemMast(1,"病危"),itmMastDr,tmp("病危"))
		..s tmp("病重")=..GetItmCount(..GetClinicItemMast(1,"病重"),itmMastDr,tmp("病重"))
		..s tmp("一级护理")=..GetItmCount(..GetClinicItemMast(1,"一级护理"),itmMastDr,tmp("一级护理"))
		..s tmp("二级护理")=..GetItmCount(..GetClinicItemMast(1,"二级护理"),itmMastDr,tmp("二级护理"))
		..s tmp("科室手术")=..GetLocOperateNum(orderParref,orderId,..GetClinicItemMast(1,"科室手术"),itmMastDr,tmp("科室手术"))
		..;i itmMastDr="14504||1" s ill=ill+1
		..;i itmMastDr="14503||1" s sick=sick+1
		..;i itmMastDr="5200||1" s firstCare=firstCare+1
		..;i itmMastDr="5201||1" s secondCare=secondCare+1
		..;i itmMastDr="16950||1" s surgery=surgery+1 //手术申请不再使用 获取手术的人数根据做手术的日期获取
	}
	s ill=tmp("病危")
	s sick=tmp("病重")
	s firstCare=tmp("一级护理")
	s secondCare=tmp("二级护理")
	s surgery=tmp("科室手术")
	s ret="病危|"_tmp("病危")_"^病重|"_tmp("病重")_"^一级护理|"_tmp("一级护理")_"^二级护理|"_tmp("二级护理")_"^科室手术|"_tmp("科室手术")
	q ill_"^"_sick_"^"_firstCare_"^"_secondCare_"^"_surgery
}

/// 根据医嘱项或者用法获取数量
ClassMethod GetNumsForOrderOrInstruc(month As %String, ward As %String) As %String
{
	s monthDay=$p(month,"-",2)+1
	s lastMonthDay=$zd($zdh(($p(month,"-",1)_"-"_monthDay_"-01"),3)-1,3)
	s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	q:'$IsObject(wardObj) ""
	s ret=""
	s locId=wardObj.CTLocDR.%Id()
	q:locId="" ""
	s locObj=##class(User.CTLoc).%OpenId(locId)
	q:'$IsObject(locObj) ""
	s locCode=locObj.CTLOCCode
	s departId=$o(^CTLOC(0,"Code",$E(locCode,2,$l(locCode)),""))
	q:departId="" ""
	s tmp("病危")=0,tmp("病重")=0,tmp("一级护理")=0,tmp("二级护理")=0,tmp("科室手术")=0
	s tmp("压疮护理")=0,tmp("换药")=0,tmp("换引流瓶（袋）")=0,tmp("口腔护理")=0,tmp("雾化吸入")=0
	s tmp("床边洗头")=0,tmp("床上浴")=0,tmp("剪指（趾）甲")=0,tmp("导尿")=0,tmp("会阴擦洗（冲洗）")=0,tmp("膀胱冲洗")=0
	s tmp("灌肠")=0,tmp("各种注射")=0,tmp("静脉抽血")=0,tmp("动脉抽血")=0,tmp("测微量血糖")=0
	f date=$zdh(month,3):1:$zdh(lastMonthDay,3)
	{
		s orderParref="" f  s orderParref=$o(^OEORDi(0,"ItemDate",date,orderParref)) q:orderParref=""  d
		.s orderId="" f  s orderId=$o(^OEORDi(0,"ItemDate",date,orderParref,orderId)) q:orderId=""  d
		..s ordState=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",13)
		..s stateCode=$p($g(^OEC("OSTAT",ordState)),"^",1)
		..q:"VED"'[stateCode
		..s ordDept=$p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
		..q:ordDept'=departId
		..s itmMastDr=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",2) //获取医嘱项
		..s instrDr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",7) //获取用法
		..s tmp("病危")=..GetItmCount(..GetClinicItemMast(1,"病危"),itmMastDr,tmp("病危"))
		..s tmp("病危")=..GetItmCount(..GetClinicInstruc(1,"病危"),instrDr,tmp("病危"))
		..s tmp("病重")=..GetItmCount(..GetClinicItemMast(1,"病重"),itmMastDr,tmp("病重"))
		..s tmp("病重")=..GetItmCount(..GetClinicInstruc(1,"病重"),instrDr,tmp("病重"))
		..s tmp("一级护理")=..GetItmCount(..GetClinicItemMast(1,"一级护理"),itmMastDr,tmp("一级护理"))
		..s tmp("一级护理")=..GetItmCount(..GetClinicInstruc(1,"一级护理"),instrDr,tmp("一级护理"))
		..s tmp("二级护理")=..GetItmCount(..GetClinicItemMast(1,"二级护理"),itmMastDr,tmp("二级护理"))
		..s tmp("二级护理")=..GetItmCount(..GetClinicInstruc(1,"二级护理"),instrDr,tmp("二级护理"))
		..s tmp("科室手术")=..GetLocOperateNum(orderParref,orderId,..GetClinicItemMast(1,"科室手术"),itmMastDr,tmp("科室手术"))
		..s tmp("压疮护理")=..GetItmCount(..GetClinicItemMast(2,"压疮护理"),itmMastDr,tmp("压疮护理"))
		..s tmp("压疮护理")=..GetItmCount(..GetClinicInstruc(2,"压疮护理"),instrDr,tmp("压疮护理"))
		..s tmp("换药")=..GetItmCount(..GetClinicItemMast(2,"换药"),itmMastDr,tmp("换药"))
		..s tmp("换药")=..GetItmCount(..GetClinicInstruc(2,"换药"),instrDr,tmp("换药"))
		..s tmp("换引流瓶（袋）")=..GetItmCount(..GetClinicItemMast(2,"换引流瓶（袋）"),itmMastDr,tmp("换引流瓶（袋）"))
		..s tmp("换引流瓶（袋）")=..GetItmCount(..GetClinicInstruc(2,"换引流瓶（袋）"),instrDr,tmp("换引流瓶（袋）"))
		..s tmp("口腔护理")=..GetItmCount(..GetClinicItemMast(2,"口腔护理"),itmMastDr,tmp("口腔护理"))
		..s tmp("口腔护理")=..GetItmCount(..GetClinicInstruc(2,"口腔护理"),instrDr,tmp("口腔护理"))
		..s tmp("雾化吸入")=..GetItmCount(..GetClinicItemMast(2,"雾化吸入"),itmMastDr,tmp("雾化吸入"))
		..s tmp("雾化吸入")=..GetItmCount(..GetClinicInstruc(2,"雾化吸入"),instrDr,tmp("雾化吸入"))
		..s tmp("床边洗头")=..GetItmCount(..GetClinicItemMast(2,"床边洗头"),itmMastDr,tmp("床边洗头"))
		..s tmp("床边洗头")=..GetItmCount(..GetClinicInstruc(2,"床边洗头"),instrDr,tmp("床边洗头"))
		..s tmp("床上浴")=..GetItmCount(..GetClinicItemMast(2,"床上浴"),itmMastDr,tmp("床上浴"))
		..s tmp("床上浴")=..GetItmCount(..GetClinicInstruc(2,"床上浴"),instrDr,tmp("床上浴"))
		..s tmp("剪指（趾）甲")=..GetItmCount(..GetClinicItemMast(2,"剪指（趾）甲"),itmMastDr,tmp("剪指（趾）甲"))
		..s tmp("剪指（趾）甲")=..GetItmCount(..GetClinicInstruc(2,"剪指（趾）甲"),instrDr,tmp("剪指（趾）甲"))
		..s tmp("导尿")=..GetItmCount(..GetClinicItemMast(2,"导尿"),itmMastDr,tmp("导尿"))
		..s tmp("导尿")=..GetItmCount(..GetClinicInstruc(2,"导尿"),instrDr,tmp("导尿"))
		..s tmp("会阴擦洗（冲洗）")=..GetItmCount(..GetClinicItemMast(2,"会阴擦洗（冲洗）"),itmMastDr,tmp("会阴擦洗（冲洗）"))
		..s tmp("会阴擦洗（冲洗）")=..GetItmCount(..GetClinicInstruc(2,"会阴擦洗（冲洗）"),instrDr,tmp("会阴擦洗（冲洗）"))
		..s tmp("膀胱冲洗")=..GetItmCount(..GetClinicItemMast(2,"膀胱冲洗"),itmMastDr,tmp("膀胱冲洗"))
		..s tmp("膀胱冲洗")=..GetItmCount(..GetClinicInstruc(2,"膀胱冲洗"),instrDr,tmp("膀胱冲洗"))
		..s tmp("灌肠")=..GetItmCount(..GetClinicItemMast(2,"灌肠"),itmMastDr,tmp("灌肠"))
		..s tmp("灌肠")=..GetItmCount(..GetClinicInstruc(2,"灌肠"),instrDr,tmp("灌肠"))
		..s tmp("各种注射")=..GetItmCount(..GetClinicItemMast(2,"各种注射"),itmMastDr,tmp("各种注射"))
		..s tmp("各种注射")=..GetItmCount(..GetClinicInstruc(2,"各种注射"),instrDr,tmp("各种注射"))
		..s tmp("静脉抽血")=..GetItmCount(..GetClinicItemMast(2,"静脉抽血"),itmMastDr,tmp("静脉抽血"))
		..s tmp("静脉抽血")=..GetItmCount(..GetClinicInstruc(2,"静脉抽血"),instrDr,tmp("静脉抽血"))
		..s tmp("动脉抽血")=..GetItmCount(..GetClinicItemMast(2,"动脉抽血"),itmMastDr,tmp("动脉抽血"))
		..s tmp("动脉抽血")=..GetItmCount(..GetClinicInstruc(2,"动脉抽血"),instrDr,tmp("动脉抽血"))
		..s tmp("测微量血糖")=..GetItmCount(..GetClinicItemMast(2,"测微量血糖"),itmMastDr,tmp("测微量血糖"))
		..s tmp("测微量血糖")=..GetItmCount(..GetClinicInstruc(2,"测微量血糖"),instrDr,tmp("测微量血糖"))
	}
	s ret=tmp("病危")_"^"_tmp("病重")_"^"_tmp("一级护理")_"^"_tmp("二级护理")_"^"_tmp("科室手术")
	_"^"_tmp("压疮护理")_"^"_tmp("换药")_"^"_tmp("换引流瓶（袋）")_"^"_tmp("口腔护理")_"^"_tmp("雾化吸入")
	_"^"_tmp("床边洗头")_"^"_tmp("床上浴")_"^"_tmp("剪指（趾）甲")_"^"_tmp("导尿")_"^"_tmp("会阴擦洗（冲洗）")
	_"^"_tmp("膀胱冲洗")_"^"_tmp("灌肠")_"^"_tmp("各种注射")_"^"_tmp("静脉抽血")_"^"_tmp("动脉抽血")_"^"_tmp("测微量血糖")
	
	q ret
}

/// 获取用法的关联项
ClassMethod GetClinicInstruc(par As %String, desc As %String) As %String
{
	s ret=""
	s rw=$o(^DHCNMG.DB.MgClinicalTypeSubI("Item",par," "_$zcvt($tr(desc," ",""),"U"),""))
	q:rw="" ""
	s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicalLinkI("parref"," Y",par_"||"_rw,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(RowID)
	.s itmMast=obj.LinkItmMask
	.s itmInstruc=obj.LinkInstruc
	.q:itmInstruc=""
	.i ret="" s ret=itmInstruc
	.e  s ret=ret_"^"_itmInstruc
	q ret
}

/// 按照医嘱项计算数量
ClassMethod GetClinicItemMast(par As %String, desc As %String) As %String
{
	s ret=""
	s rw=$o(^DHCNMG.DB.MgClinicalTypeSubI("Item",par," "_$zcvt($tr(desc," ",""),"U"),""))
	q:rw="" ""
	s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicalLinkI("parref"," Y",par_"||"_rw,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(RowID)
	.s itmMast=obj.LinkItmMask
	.q:itmMast=""
	.i ret="" s ret=itmMast
	.e  s ret=ret_"^"_itmMast
	q ret
}

/// 按照医嘱项或用法获取数量 病危 病重 一级护理 二级护理
ClassMethod GetItmCount(itmList, itmMastDr, sum) As %String
{
	f i=1:1:$l(itmList,"^")
	{
		s itm=$p(itmList,"^",i)
		i itm="" continue
		i itm=itmMastDr s sum=sum+1
	}
	q sum
}

/// 按照手术日期获取手术的例数
ClassMethod GetOprationsCounts(stDate As %String, endDate As %String, ctLocId As %String) As %String
{
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(ctLocId)
	q:'$IsObject(wardObj) ""
	q:'$IsObject(wardObj.CTLocDR) ""
	s locId=wardObj.CTLocDR.%Id()
	q:locId="" ""
	s locObj=##class(User.CTLoc).%OpenId(locId)
	q:'$IsObject(locObj) ""
	s locCode=locObj.CTLOCCode
	;标版
	s departId=$O(^CTLOC(locId,"LINK",0,"Loc",""))
	;南方医院版
	;s departId=$o(^CTLOC(0,"Code",$E(locCode,2,$l(locCode)),""))
	q:departId="" ""
	s opcount=0
	f date=stDate:1:endDate
	{
		s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.q:$p(^DHCANOPArrange(opaId),"^",27)="D"
		.s adm=$p(^DHCANOPArrange(opaId),"^",1)
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:departId'=appLocId
		.s opcount=opcount+1
	}
	q opcount
}

ClassMethod GetOtherParentNum(Par As %String) As %String
{
	s num=0
	s Rw="" f  s Rw=$O(^DHCNMG.DB.MgClinicalTypeSubD(Par,Rw)) q:Rw=""  d
	.s num=num+1
	q num
}

ClassMethod GetWardDesc(ward As %String = "") As %String
{
	q:ward="" ""
	s ret=""
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	q:'$IsObject(obj) ""
	s ret=obj.WardDesc
	q ret
}

ClassMethod SaveMonthData(parr As %String, WardQuestion As %String, WardMeasure As %String, qualparr As %String, reportparr As %String, otherparr As %String) As %String
{
	s ^TMP("SaveMonthData")=parr_"%"_WardQuestion_"%"_WardMeasure_"%"_qualparr_"%"_reportparr_"%"_otherparr
	s ward=$p(parr,"^",1)
	s month=$p(parr,"^",2)
	s create=$p(parr,"^",3)
	s checkuser=$p(parr,"^",4)
	s wardheader=$p(parr,"^",5)
	s RecStatus=$p(parr,"^",6)
	s row=$O(^DHCNMG.Arg.MgArgMonthWorkI("status"," Y",$zdh(month,3)," "_ward,""))
	i row="" s obj=##class(DHCNMG.Arg.MgArgMonthWork).%New()
	e  s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(row)
	s obj.WorkMonth=$zdh(month,3)
	s obj.WorkWard=ward
	s obj.RecStatus=RecStatus
	i RecStatus="Y" d
	.s obj.SubmitUser=create
	.s obj.SubmitDate=+$h
	s obj.WardQuestion=$replace($tr(WardQuestion," ",""),$c(10),"")
	s obj.WardMeasure=$replace($tr(WardMeasure," ",""),$c(10),"")
	s obj.CheckUsers=checkuser
	d obj.CheckUsers.Clear()
	//1813,1812,1811
	s count=$l(checkuser,",")
	f ll=1:1:count
	{
		s llitm=$p(checkuser,",",ll)
		i llitm="" continue
		d obj.CheckUsers.Insert(llitm)
	}
	s obj.NurHeader=wardheader
	s obj.CreateUser=create
	s obj.Status="Y"
	TS
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1
	{
		s flag1=1
		s delRow="" f  s delRow=$O(^DHCNMG.Arg.MgArgMonthWorkSubD(obj.%Id(),delRow)) q:delRow=""  d
		.s delObj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%OpenId(obj.%Id()_"||"_delRow)
		.s delsc=delObj.%DeleteId(obj.%Id()_"||"_delRow)
		.s flag1=($$$ISOK(delsc)&&flag1)
		
		s len1=$l(qualparr,"^")
		f i=1:1:len1
		{
			s itm=$p(qualparr,"^",i)
			s ParentId=$p($p(itm,"「",1),"|",2)
			s items=$p(itm,"「",2,$L(itm,"「"))
			f j=1:1:$L(items,"「")
			{
				s subitems=$p(items,"「",j)
				s tmp=""
				//CheckItmId|1ˇCheckNum|1ˇTotal|97ˇAvge|97.00
				d ##class(web.NurMgVueComm).SplitStr(subitems,"ˇ","|",.tmp)
				s SubObj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%New()
				s SubObj.Parref=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(obj.%Id())
				s SubObj.Avge=$g(tmp("Avge"))
				s SubObj.CheckItmId=$g(tmp("CheckItmId"))
				s SubObj.CheckNum=$g(tmp("CheckNum"))
				s SubObj.DenoNum=$g(tmp("DenoNum"))
				s SubObj.MoleNum=$g(tmp("MoleNum"))
				s SubObj.ParentId=ParentId
				s SubObj.Rate=$g(tmp("Rate"))
				s SubObj.Total=$g(tmp("Total"))
				s subc=SubObj.%Save()
				s flag1=($$$ISOK(subc)&&flag1)
			}
			
		}
		s len2=$l(reportparr,"^")
		f m=1:1:len2
		{
			s mitm=$p(reportparr,"^",m)
			s ParentId=$p($p(mitm,"「",1),"|",2)
			s mitems=$p(mitm,"「",2,$l(mitm,"「"))
			f k=1:1:$l(mitems,"「")
			{
				s submitems=$p(mitems,"「",k)
				s tmp=""
				d ##class(web.NurMgVueComm).SplitStr(submitems,"ˇ","|",.tmp)
				s SubObj1=##class(DHCNMG.Arg.MgArgMonthWorkSub).%New()
				s SubObj1.Parref=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(obj.%Id())
				s SubObj1.Avge=$g(tmp("Avge"))
				s SubObj1.CheckItmId=$g(tmp("CheckItmId"))
				s SubObj1.CheckNum=$g(tmp("CheckNum"))
				s SubObj1.DenoNum=$g(tmp("DenoNum"))
				s SubObj1.MoleNum=$g(tmp("MoleNum"))
				s SubObj1.ParentId=ParentId
				s SubObj1.Rate=$g(tmp("Rate"))
				s SubObj1.Total=$g(tmp("Total"))
				s subc1=SubObj1.%Save()
				s flag1=($$$ISOK(subc1)&&flag1)
			}
		}
		s len3=$l(otherparr,"^")
		f l1=1:1:len3
		{
			s oitm=$p(otherparr,"^",l1)
			s ParentId=$p($p(oitm,"「",1),"|",2)
			s oitems=$P(oitm,"「",2,$l(oitm,"「"))
			f l2=1:1:$l(oitems,"「")
			{
				s suboitems=$p(oitems,"「",l2)
				s tmp=""
				d ##class(web.NurMgVueComm).SplitStr(suboitems,"ˇ","|",.tmp)
				s SubObj2=##class(DHCNMG.Arg.MgArgMonthWorkSub).%New()
				s SubObj2.Parref=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(obj.%Id())
				s SubObj2.Avge=$g(tmp("Avge"))
				s SubObj2.CheckItmId=$g(tmp("CheckItmId"))
				s SubObj2.CheckNum=$g(tmp("CheckNum"))
				s SubObj2.DenoNum=$g(tmp("DenoNum"))
				s SubObj2.MoleNum=$g(tmp("MoleNum"))
				s SubObj2.ParentId=ParentId
				s SubObj2.Rate=$g(tmp("Rate"))
				s SubObj2.Total=$g(tmp("Total"))
				s subc2=SubObj2.%Save()
				s flag1=($$$ISOK(subc2)&&flag1)
			}
		}
		s flag=(flag&&flag1)
		i flag1=1
		{
			TC
		}
		else
		{
			Tro
		}
	}
	else
	{
		Tro
	}
	q flag
}

/// Creator:guozj
/// Description:查询护理工作量登记记录
/// Date:2018-07-16
/// Table: DHCNMG.Arg.MgArgMonthWork
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindWorkList","2018-08-01^2018-08-01^1","0","0")
Query FindWorkList(parr As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWorkListExecute(ByRef qHandle As %Binary, parr As %String, role As %String, nurseid As %String) As %Status
{
	s ^TMP("FindWorkList")=parr_"%"_role_"%"_nurseid
	//2018-08-01^2018-08-01^1%0%0
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^",1)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",2)
	i enddate'="" s enddate=$zdh(enddate,3)
	s wardparam=$p(parr,"^",3)
	s ret="",ret1=""
	s tmp=""
	f date=stdate:1:enddate
	{
		i role=0
		{
			s ward="" f  s ward=$O(^DHCNMG.Arg.MgArgMonthWorkI("status"," Y",date,ward)) q:ward=""  d
			.s row="" f  s row=$O(^DHCNMG.Arg.MgArgMonthWorkI("status"," Y",date,ward,row)) q:row=""  d
			..s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(row)
			..i obj.WorkMonth'="" s WorkMonth=$p($zd(obj.WorkMonth,3),"-",1,2)
			..e  s WorkMonth=""
			..q:((wardparam'="")&&(obj.WorkWard'=wardparam))
			..s WorkWard=""
			..i obj.WorkWard'="" d
			...s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.WorkWard)
			...q:'$IsObject(WardObj)
			...s WorkWard=WardObj.WardDesc
			..i obj.RecStatus="N" s RecStatus="保存" //以保存状态
			..e  i obj.RecStatus="Y" s RecStatus="提交"
			..e  i obj.RecStatus="G" s RecStatus="提交到护士长"
			..e  i obj.RecStatus="B" s RecStatus="驳回"
			..e  s RecStatus=""
			..s NurHeader=obj.NurHeader
			..s CheckUsers=""
			..s len1=obj.CheckUsers.Count()
			..f k=1:1:len1 d
			...s checkuser=obj.CheckUsers.GetAt(k)
			...q:checkuser=""
			...s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(checkuser)
			...q:'$IsObject(perobj)
			...i CheckUsers="" s CheckUsers=perobj.PerName
			...e  s CheckUsers=CheckUsers_","_perobj.PerName
			..s CreateUser=""
			..i obj.CreateUser="" s CreateUser=""
			..e  i ((obj.CreateUser'="")&&(obj.CreateUser=0)) s CreateUser="超级管理员"
			..e  i ((obj.CreateUser'="")&&(obj.CreateUser'=0)) d
			...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CreateUser)
			...q:'$IsObject(PerObj)
			...s CreateUser=PerObj.PerName
			..s CreateDate=""
			..i obj.CreateDate'="" s CreateDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
			..s SubmitUser="",SubmitDate=""
			..i ((obj.SubmitUser'="")&&(obj.SubmitUser=0)) s SubmitUser="超级管理员"
			..e  i ((obj.SubmitUser'="")&&(obj.SubmitUser'=0)) d
			...s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.SubmitUser)
			...q:'$IsObject(NurObj)
			...s SubmitUser=NurObj.PerName
			..i obj.SubmitDate'="" s SubmitDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubmitDate)
			..s BackDate=""
			..i obj.BackDate'="" s BackDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.BackDate)
			..s BackTime=""
			..i obj.BackTime'="" s BackTime=$zt(obj.BackTime,1)
			..s BackUser=""
			..i ((obj.BackUser'="")&&(obj.BackUser=0)) s BackUser="超级管理员"
			..e  i (obj.BackUser'="")&&(obj.BackUser'=0) d
			...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.BackUser)
			...q:'$IsObject(perObj)
			...s BackUser=perObj.PerName
			..s BackContent=obj.BackContent
			..s ret1="workWard|"_WorkWard_"^recStatus|"_RecStatus_"^workMonth|"_WorkMonth_"^nurHeader|"_NurHeader_"^checkUsers|"_CheckUsers_"^createUser|"_CreateUser_"^createDate|"_CreateDate_"^submitUser|"_SubmitUser_"^submitDate|"_SubmitDate_"^RowID|"_row_"^wardCode|"_obj.WorkWard_"^backDate|"_BackDate_"^backTime|"_BackTime_"^backUser|"_BackUser_"^backContent|"_BackContent
			..s tmp(row)=ret1
			..;do OutputWorkData
		}
		else
		{
			s rolelen=$l(role,"^")
			f j=1:1:rolelen
			{
				s roleitm=$p(role,"^",j)
				s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleitm)
				s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,rolerw)) q:rolerw=""  d
				.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
				..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
				..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=roledepobj.SubWard)
				....s row="" f  s row=$O(^DHCNMG.Arg.MgArgMonthWorkI("status"," Y",date," "_id,row)) q:row=""  d
				.....s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(row)
				.....i obj.WorkMonth'="" s WorkMonth=$p($zd(obj.WorkMonth,3),"-",1,2)
				.....e  s WorkMonth=""
				.....q:((wardparam'="")&&(obj.WorkWard'=wardparam))
				.....s WorkWard=""
				.....i obj.WorkWard'="" d
				......s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.WorkWard)
				......q:'$IsObject(WardObj)
				......s WorkWard=WardObj.WardDesc
				.....i obj.RecStatus="N" s RecStatus="保存" //以保存状态
				.....e  i obj.RecStatus="Y" s RecStatus="已提交"
				.....e  i obj.RecStatus="G" s RecStatus="提交到护士长"
				.....e  i obj.RecStatus="B" s RecStatus="驳回"
				.....e  s RecStatus=""
				.....q:(((rolecode="manager"||rolecode="hlb"||rolecode="hlbnurmanager"||rolecode="hlbmanager"))&&(obj.RecStatus="G"||obj.RecStatus="N"))
				.....s NurHeader=obj.NurHeader
				.....s CheckUsers=""
				.....s len1=obj.CheckUsers.Count()
				.....f k=1:1:len1 d
				......s checkuser=obj.CheckUsers.GetAt(k)
				......q:checkuser=""
				......s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(checkuser)
				......q:'$IsObject(perobj)
				......i CheckUsers="" s CheckUsers=perobj.PerName
				......e  s CheckUsers=CheckUsers_","_perobj.PerName
				.....s CreateUser=""
				.....i obj.CreateUser="" s CreateUser=""
				.....e  i ((obj.CreateUser'="")&&(obj.CreateUser=0)) s CreateUser="超级管理员"
				.....e  i ((obj.CreateUser'="")&&(obj.CreateUser'=0)) d
				......s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CreateUser)
				......q:'$IsObject(PerObj)
				......s CreateUser=PerObj.PerName
				.....s CreateDate=""
				.....i obj.CreateDate'="" s CreateDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
				.....s SubmitUser="",SubmitDate=""
				.....i ((obj.SubmitUser'="")&&(obj.SubmitUser=0)) s SubmitUser="超级管理员"
				.....e  i ((obj.SubmitUser'="")&&(obj.SubmitUser'=0)) d
				......s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.SubmitUser)
				......q:'$IsObject(NurObj)
				......s SubmitUser=NurObj.PerName
				.....i obj.SubmitDate'="" s SubmitDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubmitDate)
				......s BackDate=""
				......i obj.BackDate'="" s BackDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.BackDate)
				......s BackTime=""
				......i obj.BackTime'="" s BackTime=$zt(obj.BackTime,1)
				......s BackUser=""
				......i ((obj.BackUser'="")&&(obj.BackUser=0)) s BackUser="超级管理员"
				......e  i (obj.BackUser'="")&&(obj.BackUser'=0) d
				.......s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.BackUser)
				.......q:'$IsObject(perObj)
				.......s BackUser=perObj.PerName
				.....s BackContent=obj.BackContent
				.....s ret1="workWard|"_WorkWard_"^recStatus|"_RecStatus_"^workMonth|"_WorkMonth_"^nurHeader|"_NurHeader_"^checkUsers|"_CheckUsers_"^createUser|"_CreateUser_"^createDate|"_CreateDate_"^submitUser|"_SubmitUser_"^submitDate|"_SubmitDate_"^RowID|"_row_"^wardCode|"_obj.WorkWard_"^backDate|"_BackDate_"^backTime|"_BackTime_"^backUser|"_BackUser_"^backContent|"_BackContent
				.....s tmp(row)=ret1
				.....;do OutputWorkData
			}
		}
	}
	s RowID="" f  s RowID=$O(tmp(RowID)) q:RowID=""  d
	.s ret=tmp(RowID)
	.do OutputWorkData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWorkData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 
/// 
/// 获取护士工作月报登记表信息
ClassMethod GetEditWorkData(id As %String, ward As %String) As %String
{
	s ^TMP("GetEditWorkData")=id_"%"_ward
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(id)
	q:'$IsObject(obj) ""
	w "["
	s ward=obj.WorkWard
	s ParentIdTmp=""
	f j=1:1:4
	{
		i j=1
		{
			w "{""Child"":["
			s parent="护理质量控制"
			s ParentId="11"
			s num=..GetEditItmNum(id,ParentId)
			w "{""parent"":"""_parent_""",""ParentId"":"""_ParentId_""",""num"":"""_num_""",""children"":["
			s l=0
			s SubRow="" f  s SubRow=$O(^DHCNMG.Arg.MgArgMonthWorkSubD(id,SubRow)) q:SubRow=""  d
			.s SubObj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%OpenId(id_"||"_SubRow)
			.q:SubObj.ParentId'=ParentId
			.s CheckItmId=SubObj.CheckItmId
			.s Total=SubObj.Total
			.s CheckNum=SubObj.CheckNum
			.s Avge=SubObj.Avge 
			.s qualitm=..GetEditItmDesc(CheckItmId,"1")
			.s l=l+1
			.i l=1 w "{""CheckItmId"":"""_CheckItmId_""",""Total"":"""_Total_""",""CheckNum"":"""_CheckNum_""",""Avge"":"""_Avge_""",""qualitm"":"""_qualitm_"""}"
			.e  w ",{""CheckItmId"":"""_CheckItmId_""",""Total"":"""_Total_""",""CheckNum"":"""_CheckNum_""",""Avge"":"""_Avge_""",""qualitm"":"""_qualitm_"""}"
			w "]}"
			w "]}"
		}
		elseif j=2
		{
			w ",{""Child"":["
			s parent=""
			s n=0
			s itmid="" f  s itmid=$O(^DHCNMG.DB.MgReportItemD(itmid)) q:itmid=""  d
			.s itmobj=##class(DHCNMG.DB.MgReportItem).%OpenId(itmid)
			.s parent=itmobj.ReportType
			.s num=..GetEditItmNum(id,j_itmid)
			.q:((ward'="")&&(itmobj.ReportWard'=ward)&&(itmobj.ReportWard'=""))
			.s n=n+1
			.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_j_itmid_""",""num"":"""_num_""",""children"":["
			.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_j_itmid_""",""num"":"""_num_""",""children"":["
			.s count=0
			.s SubRow="" f  s SubRow=$O(^DHCNMG.Arg.MgArgMonthWorkSubD(id,SubRow)) q:SubRow=""  d
			..s SubObj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%OpenId(id_"||"_SubRow)
			..q:SubObj.ParentId'=(j_itmid)
			..s CheckItmId=SubObj.CheckItmId
			..s MoleNum=SubObj.MoleNum
			..s DenoNum=SubObj.DenoNum
			..s Rate=SubObj.Rate 
			..s ret=..GetEditItmDesc(CheckItmId,j)
			..s checkItem=$p(ret,"^",1)
			..s denominator=$p(ret,"^",2)
			..s molecular=$p(ret,"^",3)
			..s count=count+1
			..i count=1 w "{""CheckItmId"":"""_CheckItmId_""",""MoleNum"":"""_MoleNum_""",""DenoNum"":"""_DenoNum_""",""Rate"":"""_Rate_""",""checkItem"":"""_checkItem_""",""denominator"":"""_denominator_""",""molecular"":"""_molecular_"""}"
			..e  w ",{""CheckItmId"":"""_CheckItmId_""",""MoleNum"":"""_MoleNum_""",""DenoNum"":"""_DenoNum_""",""Rate"":"""_Rate_""",""checkItem"":"""_checkItem_""",""denominator"":"""_denominator_""",""molecular"":"""_molecular_"""}"
			.w "]}"
			w "]}"
		}
		elseif j=3
		{
			w ",{""Child"":["
			s parent=""
			s n=0
			s itmid="" f  s itmid=$O(^DHCNMG.DB.MgClinicalTypeD(itmid)) q:itmid=""  d
			.s itmobj1=##class(DHCNMG.DB.MgClinicalType).%OpenId(itmid)
			.s parent=itmobj1.ClinicalType
			.s n=n+1
			.s num=..GetEditItmNum(id,j_itmid)
			.i n=1 w "{""parent"":"""_parent_""",""ParentId"":"""_j_itmid_""",""num"":"""_num_""",""children"":["
			.e  w ",{""parent"":"""_parent_""",""ParentId"":"""_j_itmid_""",""num"":"""_num_""",""children"":["
			.s k=0
			.s SubRow="" f  s SubRow=$O(^DHCNMG.Arg.MgArgMonthWorkSubD(id,SubRow)) q:SubRow=""  d
			..s SubObj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%OpenId(id_"||"_SubRow)
			..q:SubObj.ParentId'=(j_itmid)
			..s CheckItmId=SubObj.CheckItmId
			..s CheckNum=SubObj.CheckNum
			..s checkitm=..GetEditItmDesc(CheckItmId,j)
			..s k=k+1
			..i k=1 w "{""CheckItmId"":"""_CheckItmId_""",""CheckNum"":"""_CheckNum_""",""checkitm"":"""_checkitm_"""}"
			..e  w ",{""CheckItmId"":"""_CheckItmId_""",""CheckNum"":"""_CheckNum_""",""checkitm"":"""_checkitm_"""}"
			.w "]}"
			w "]}"
		}
		elseif j=4
		{
			s checkUsers=""
			s len=obj.CheckUsers.Count()
			f k=1:1:len
			{
				s itm=obj.CheckUsers.GetAt(k)
				i itm="" continue
				i checkUsers="" s checkUsers=itm
				e  s checkUsers=checkUsers_","_itm
			}
			w ",{""checkuser"":"""_checkUsers_""",""wardheader"":"""_obj.NurHeader_""",""backRecConten"":"""_obj.BackContent_""","
			w """Child"":["
			s parent=""
			s parent="持续改进"
            s parentid="41"
            s num=2
            w "{""parent"":"""_parent_""",""parentid"":"""_parentid_""",""num"":"""_num_""",""children"":["
            w "{""checkitm"":""本月科室检查不足方面"",""content"":"""_obj.WardQuestion_"""},{""checkitm"":""科室改进措施"",""content"":"""_obj.WardMeasure_"""}"
            w "]}"
            w "]}"
		}
	}
	w "]"
	q ""
}

ClassMethod GetEditItmNum(id As %String, ParentId As %String) As %String
{
	s n=0
	s row="" f  s row=$O(^DHCNMG.Arg.MgArgMonthWorkSubD(id,row)) q:row=""  d
	.s obj=##class(DHCNMG.Arg.MgArgMonthWorkSub).%OpenId(id_"||"_row)
	.q:((obj.ParentId'="")&&(ParentId'="")&&(obj.ParentId'=ParentId))
	.s n=n+1
	q n
}

ClassMethod GetEditItmDesc(id As %String, parent As %String) As %String
{
	s desc=""
	i parent="1"
	{
		s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(id)
		q:'$IsObject(obj) ""
		s desc=obj.QualDesc
	}
	i parent="2"
	{
		s obj1=##class(DHCNMG.DB.MgReportItemSub).%OpenId(id)
		q:'$IsObject(obj1)
		s checkItem=obj1.DetailItem
		s denominator=obj1.DetailDenominator
		s molecular=obj1.DetailMolecular
		s desc=checkItem_"^"_denominator_"^"_molecular
	}
	i parent="3"
	{
		s obj2=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(id)
		q:'$IsObject(obj2) ""
		s checkitm=obj2.DetailItem
		s desc=checkitm
	}
	q desc
}

ClassMethod Test(id, ward, j) As %String
{
 	q 0
}

ClassMethod CheckIsExist(ward As %String, month As %String) As %String
{
	s date=$zdh(month,3)
	s row=$O(^DHCNMG.Arg.MgArgMonthWorkI("status"," Y",date," "_ward,""))
	q row
}

ClassMethod CheckStatus(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s flag=obj.RecStatus
	q flag
}

ClassMethod DelWorkRec(id As %String) As %String
{
	q:id="" ""
	s flag=1
	s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.Status="N"
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	q flag
}

ClassMethod BackWorkRec(id As %String, parr As %String, BackUser As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.RecStatus="B"
	s obj.BackContent=$replace($Tr(parr," ",""),$c(10),"")
	s obj.BackUser=BackUser
	s obj.BackDate=+$h
	s obj.BackTime=$p($h,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod ClinicItmSort(rowid As %String, type As %String) As %String
{
	s ^TMP("MoveWardSort")=rowid_"%"_type
	q:rowid="" ""
	s ret=0
	s par=$p(rowid,"||",1)
	s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(rowid)
	s sort=obj.DetailSort
	i type="up"
	{
		i sort="1" s ret=0
		e  d
		.s ret=sort-1
		.s obj.DetailSort=sort-1
		.s row=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",par,sort-1,""))
		.s bobj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(par_"||"_row)
		.s bobj.DetailSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	}
	elseif type="down"
	{
		s maxSort=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",par,""),-1)
		i sort=maxSort s ret=1
		e  d
		.s ret=sort+1
		.s obj.DetailSort=sort+1
		.s row=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",par,sort+1,""))
		.s bobj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(par_"||"_row)
		.s bobj.DetailSort=sort
		.d bobj.%Save()
		.d obj.%Save()
	} 
	q ret
}

/// 获取临床工作项目的顺序号
ClassMethod GetClinicItmSort(Par As %String) As %String
{
	s ^TMP("GetClinicItmSort")=Par
	s n=1
	s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",Par,sort)) q:sort=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgClinicalTypeSubI("Sort",Par,sort,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(Par_"||"_rw)
	..i obj.DetailSort'="" s n=n+1
	q n
}

ClassMethod GetWardHeader(wardid As %String) As %String
{
	s ^TMP("GetWardHeader")=wardid
	q:wardid="" ""
	s headers=""
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_wardid,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgPostDutyI("ssid",rowid,rw)) q:rw=""  d
	..s PostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(rw)
	..q:'$IsObject(PostObj)
	..q:PostObj.PostEndDate'=""
	..i PostObj.PostDuty'="" d
	...s PostStr=##class(web.NurMgPersonComm).GetCommCode(PostObj.PostDuty)
	...q:PostStr'="护士长"
	...i headers="" s headers=obj.PerName
	...e  s headers=headers_","_obj.PerName
	q headers
}

/// 获获取科室手术
ClassMethod GetLocOperateNum(orderPar, orderId, itmList, itmMastDr, sum) As %String
{
	s BillFlag=$p($g(^OEORD(orderPar,"I",orderId,"DHC")),"^",39)
	q:BillFlag="Y" sum
	
	s ArcItmCatDR=$p(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1),"^",10) //获取医嘱项的子类
	s ArcItmDesc=$p(^ARC("IC",ArcItmCatDR),"^",2)
	i ArcItmDesc="科室手术" s sum=sum+1
	q sum
}

ClassMethod GetClinicItemDesc(par As %String) As %String
{
	s ret=""
	s sort="" f  s sort=$o(^DHCNMG.DB.MgClinicalTypeSubI("Sort",par,sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicalTypeSubI("Sort",par,sort,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(par_"||"_RowID)
	..q:obj.DetailItem=""
	..i ret="" s ret=obj.DetailItem_","_par_"||"_RowID
	..e  s ret=ret_"^"_obj.DetailItem_","_par_"||"_RowID
	q ret
}

ClassMethod GetClinicalWordItems(stDate As %String, endDate As %String, wardID As %String) As %String
{
}

/// Description:获取所有医嘱项目
/// Date:2018-08-10
/// Creator:gzj
ClassMethod GetOrderItems() As %String
{
	w "["
	s n=0
	s code="" f  s code=$o(^ARCIM(0,"Code",code)) q:code=""  d
	.s subScript="" f  s subScript=$o(^ARCIM(0,"Code",code,subScript)) q:subScript=""  d
	..s version="" f  s version=$o(^ARCIM(0,"Code",code,subScript,version)) q:version=""  d
	...s ItmDesc=$p(^ARCIM(subScript,version,1),"^",2)
	...s ItmDesc=$replace(ItmDesc,"\","|")
	...;s ItmDesc=$replace(ItmDesc,"/"," /")
	...s ItmDesc=$replace(ItmDesc,"%","% ")
	...s ItmDesc=$replace(ItmDesc,"""","")
	...s ItmDesc=$replace(ItmDesc," ","")
	...s ItmDesc=$replace(ItmDesc,$c(9),"")
	...s ItmSpell=##class(web.NurMgVueComm).ToChineseSpell(ItmDesc)
	...s n=n+1
	...i n=1 w "{""label"":"""_ItmDesc_""",""value"":"""_subScript_"||"_version_"""}"
	...e  w ",{""label"":"""_ItmDesc_""",""value"":"""_subScript_"||"_version_"""}"
	w "]"
	q ""
}

ClassMethod GetInstructItems() As %String
{
	w "["
	s n=0
	s RowID="" f  s RowID=$o(^PHCIN(RowID)) q:RowID=""  d
	.s desc=$p(^PHCIN(RowID),"^",2)
	.s n=n+1
	.i n=1 w "{""label"":"""_desc_""",""value"":"""_RowID_"""}"
	.e  w ",{""label"":"""_desc_""",""value"":"""_RowID_"""}"
	w "]"
	q ""
}

/// Creator:guozj
/// Description:查询医嘱项目
/// Date:2018-08-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindOrderItems","")
Query FindOrderItems(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrderItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	//2018-08-01^2018-08-01^1%0%0
	s repid=$I(^CacheTemp)
	s ind=1
	
	s code="" f  s code=$o(^ARCIM(0,"Code",code)) q:code=""  d
	.s subScript="" f  s subScript=$o(^ARCIM(0,"Code",code,subScript)) q:subScript=""  d
	..s version="" f  s version=$o(^ARCIM(0,"Code",code,subScript,version)) q:version=""  d
	...s ItmDesc=$p(^ARCIM(subScript,version,1),"^",2)
	...;s ItmDesc=$replace(ItmDesc,"""","")
	...s ItmSpell=##class(web.NurMgVueComm).ToChineseSpell(ItmDesc)
	...s ret="ItmDesc|"_ItmDesc_"^ItmSpell|"_ItmSpell_"^RowID|"_subScript_"||"_version
	...do OutputOrderItmData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputOrderItmData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveOrderItem(par As %String, itmMastID As %String, type As %String) As %String
{
	s ^TMP("SaveOrderItem")=par_"%"_itmMastID 
	//1||1%14503||1
	s flag=0
	s flag=..HasItems(par,itmMastID,type)
	q:flag=1 "此项目已经存在"
	s obj=##class(DHCNMG.DB.MgClinicalLink).%New()
	s obj.LinkParref=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(par)
	s obj.LinkItmMask=itmMastID
	s obj.LinkStatus="Y"
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

ClassMethod DelOrderItem(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.LinkStatus="N"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod SaveInstrucItem(par As %String, instrucID As %String, type As %String) As %String
{
	s flag=0
	s flag=..HasItems(par,instrucID,type)
	
	q:flag=1 "此用法已经存在"
	s obj=##class(DHCNMG.DB.MgClinicalLink).%New()
	s obj.LinkParref=##class(DHCNMG.DB.MgClinicalTypeSub).%OpenId(par)
	s obj.LinkInstruc=instrucID
	s obj.LinkStatus="Y"
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod HasItems(par As %String, item As %String, type As %String) As %String
{
	q:par="" ""
	s flag=0
	s RowID="" f  s RowID=$O(^DHCNMG.DB.MgClinicalLinkD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:obj.LinkStatus'="Y"
	.s parref=obj.LinkParref.%Id()
	.q:((par'="")&&(parref'=par))
	.s orderItem=obj.LinkItmMask
	.s phcInstruc=obj.LinkInstruc
	.i ((type=1)&&(item=orderItem)) s flag=1
	.i ((type=2)&&(item=phcInstruc)) s flag=1
	q flag
}

/// Creator:guozj
/// Description:查询关联医嘱项目
/// Date:2018-08-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindOrderItemList","")
Query FindOrderItemList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindOrderItemListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TMP("FindOrderItemList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s itmMask="" f  s itmMask=$o(^DHCNMG.DB.MgClinicalLinkI("Mask"," Y"," "_$tr(itmMask," ",""))) q:$tr(itmMask," ","")=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicalLinkI("Mask"," Y"," "_$tr(itmMask," ",""),RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(RowID)
	..q:((parr'="")&&(obj.LinkParref.%Id()'=parr))
	..s orderItmMast=""
	..i obj.LinkItmMask'="" d
	...s MaskObj=##class(User.ARCItmMast).%OpenId(obj.LinkItmMask)
	...q:'$IsObject(MaskObj)
	...s orderItmMast=MaskObj.ARCIMDesc
	..s ret="orderItmMast|"_orderItmMast_"^RowID|"_RowID
	..do OutputOrderItmList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputOrderItmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindOrderItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderItemListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrderItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:查询关联用法
/// Date:2018-08-10
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindInstructList","")
Query FindInstructList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindInstructListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TMP("FindInstructList")=parr
	
	s repid=$I(^CacheTemp)
	s ind=1
	s instruc="" f  s instruc=$o(^DHCNMG.DB.MgClinicalLinkI("Instruc"," Y"," "_$tr(instruc," ",""))) q:$tr(instruc," ","")=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgClinicalLinkI("Instruc"," Y"," "_$tr(instruc," ",""),RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgClinicalLink).%OpenId(RowID)
	..q:((parr'="")&&(obj.LinkParref.%Id()'=parr))
	..s instruct=""
	..i obj.LinkInstruc'="" d
	...s InstrucObj=##class(User.PHCInstruc).%OpenId(obj.LinkInstruc)
	...q:'$IsObject(InstrucObj)
	...s instruct=InstrucObj.PHCINDesc1
	..s ret="instruc|"_instruct_"^RowID|"_RowID
	..do OutputOrderItmList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputOrderItmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindInstructListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstructListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindInstructListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstructListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveClinicItems(parr As %String) As %String
{
	s ^TEMP("SaveClinicItems")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" d 
	.s obj=##class(DHCNMG.DB.MgClinicItems).%New()
	.s sort=$O(^DHCNMG.DB.MgClinicItemsI("sort",""),-1)
	.s:sort="" sort=0
	.s sort=sort+1
	.s obj.ClinicSort=sort
	e  s obj=##class(DHCNMG.DB.MgClinicItems).%OpenId(id)
	s obj.ClinicCode=$zcvt($tr($g(tmp("CinicCode"))," ",""),"U")
	s obj.ClinicDesc=$zcvt($tr($g(tmp("CinicDesc"))," ",""),"U")
	s obj.ClinicArcimCode=$zcvt($tr($g(tmp("ClinicArcim"))," ",""),"U")
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

ClassMethod GetClinicSort() As %String
{
	s flag=0
	s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicItemsI("sort",sort,RowID)) q:RowID=""  d
	..s flag=flag+1
	
	q (flag+1)
}

/// Creator:guozj
/// Description:查询日报指标项目
/// Date:2018-08-12
/// Table: 
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindClinicItems","")
Query FindClinicItems(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindClinicItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TMP("FindClinicItems")=parr
	
	s repid=$I(^CacheTemp)
	s ind=1
	s sort="" f  s sort=$o(^DHCNMG.DB.MgClinicItemsI("sort",sort)) q:sort=""  d
	.s RowID="" f  s RowID=$o(^DHCNMG.DB.MgClinicItemsI("sort",sort,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.DB.MgClinicItems).%OpenId(RowID)
	..s clinicDesc=obj.ClinicDesc
	..s clinicCode=obj.ClinicCode
	..s clinicArcimCode=obj.ClinicArcimCode
	..s clinicSort=obj.ClinicSort
	..q:(parr'="")&&(clinicDesc'[$zcvt($tr(parr," ",""),"U"))
	..s ret="clinicDesc|"_clinicDesc_"^clinicCode|"_clinicCode_"^clinicArcimCode|"_clinicArcimCode_"^clinicSort|"_clinicSort_"^RowID|"_RowID
	..do OutputOrderItmList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputOrderItmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindClinicItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClinicItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindClinicItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClinicItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///  creator: lulin
///  createdate: 2018-08-23
///  description: 未按时提交月报
///  table: DHCNMG.Arg.MgArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindNotCurrentWorkList","2017-10","",0,0)
Query FindNotCurrentWorkList(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNotCurrentWorkListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s Selectmonth=$p(parr,"^")
	s:Selectmonth'="" Selectmonth=Selectmonth_"-01"
	s:Selectmonth["-" Selectmonth=$zdh(Selectmonth,3)
#;	s tmpWard=""
#;	s isAll=0
#;	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s ret=""
	s id=""  f  s id=$O(^DHCNMG.Arg.MgArgMonthWorkD(id))  q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgArgMonthWork).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.Status="N"
	.q:obj.WorkMonth=""
	.q:((Selectmonth'="")&&(obj.WorkMonth'=Selectmonth))
	.q:((obj.SubmitDate="")||(obj.SubmitDate<(obj.WorkMonth+10)))
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.WorkWard)
	.q:'$IsObject(WardObj)
	.s workWard=WardObj.WardDesc
	.s submitDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SubmitDate)
	.s workMonth=$E($zd(obj.WorkMonth,8),1,6)
	.s submitUser=""
	.i obj.SubmitUser'="" d
	..i obj.SubmitUser=0 s submitUser="超级管理员"
	..e  d
	...s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.SubmitUser)
	...s:$IsObject(perObj) submitUser=perObj.PerName
	.s ret="workWard|"_workWard_"^submitDate|"_submitDate_"^workMonth|"_workMonth_"^submitUser|"_submitUser
	.d OutNotCurrentWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNotCurrentWork
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNotCurrentWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNotCurrentWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNotCurrentWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNotCurrentWorkListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:wangpf
/// CreatDate: 2019-09-06
/// Description: 保存Kpi考核记录
/// Table：DHCNMG.CHK.MgKpiCheck
/// Input：
/// Return：成功返回id
/// other: w ##class(web.NurArgWorkLoadComm).SaveKpiCheck("loginID|0^KpiItem|1^KpiGroup|2^CheckDate|2019-09^RowID|")
ClassMethod SaveKpiCheck(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:($g(tmp("KpiItem"))="")||($g(tmp("KpiGroup"))="")||($g(tmp("CheckDate"))="")||($g(tmp("loginID"))="") "信息不完整"
	s id=$g(tmp("RowID"))
	s CheckYear=$p(tmp("CheckDate"),"-")
	s CheckMonth=$p(tmp("CheckDate"),"-",2)
	s createFailed=0
	s isExist=0
	i id'="" d
	.s obj=##class(DHCNMG.CHK.MgKpiCheck).%OpenId(id)
	e  d
	.s:$o(^DHCNMG.CHK.MgKpiCheckI("CheckDate",tmp("KpiGroup")," "_CheckYear," "_CheckMonth,"")) isExist=1
	.s obj=##class(DHCNMG.CHK.MgKpiCheck).%New()
	.i '$IsObject(obj) s createFailed=1 q
	.s obj.CreateDate=+$h
	.i tmp("loginID") d
	..s userObj=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("loginID"))
	..i '$IsObject(userObj) s createFailed=1 q
	..s obj.CreateUser=userObj
	q:isExist "该分组已存在相同月份的考核记录"
	q:createFailed "考核项目创建失败"
	q:'$IsObject(obj) "考核项目不存在"
	q:obj.Status="Y" "考核项目已打分,不可修改"
	s KpiItemObj=##class(DHCNMG.DB.MgKpiItem).%OpenId(tmp("KpiItem"))
	q:'$IsObject(KpiItemObj) "Kpi项目不存在"
	s KpiGroupObj=##class(DHCNMG.DB.MgKpiGroup).%OpenId(tmp("KpiGroup"))
	q:'$IsObject(KpiGroupObj) "组别不正确"
	s obj.KpiItemDR=KpiItemObj
	s obj.CheckGroupDR=KpiGroupObj
	s obj.CheckYear=CheckYear
	s obj.CheckMonth=CheckMonth
	s sc=obj.%Save()
	i sc=1
	{
		q obj.%Id()
	}
	else
	{
		q "保存失败:"_$System.Status.DisplayError(sc)
	}
}

/// Creator:wangpf
/// Description:删除Kpi考核记录
/// Date:2019-09-07
/// Table:DHCNMG.DB.MgKpiCheck
/// Input:
/// Output:
/// Return: -1:已打分 0:失败 1:成功
/// other: w ##class(web.NurArgWorkLoadComm).DeleteKpiCheck(1)
ClassMethod DeleteKpiCheck(id As %String = "") As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.CHK.MgKpiCheck).%OpenId(id)
	q:'$IsObject(obj) 0
	q:obj.Status'="N" -1
	s flag=1
	ts
	i ##class(DHCNMG.CHK.MgKpiCheck).%DeleteId(id) d
	.s checkSubId="" f  s checkSubId=$o(^DHCNMG.CHK.MgKpiCheckSubI("parr",id,checkSubId)) q:(checkSubId="")||(flag=0)  d
	..s flag=##class(DHCNMG.CHK.MgKpiCheckSub).%DeleteId(id)
	e  s flag=0
	i flag=0 tro
	e  tc
	q flag
}

/// Creator:wangpf
/// Description:获取Kpi考核记录
/// Date:2019-09-06
/// Table: DHCNMG.DB.MgKpiItem
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurArgWorkLoadComm).GetKpiCheck(1)
ClassMethod GetKpiCheck(id As %String, returnId As %Boolean = 0) As %String
{
	s ^TMP("GetKpiCheck")=id
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgKpiCheck).%OpenId(id)
	q:'$IsObject(obj) ""
	i returnId s KpiItem=obj.KpiItemDR.%Id(),CheckGroup=obj.CheckGroupDR.%Id(),Status=obj.Status
	e  d
	.s KpiItem=obj.KpiItemDR.KpiDesc,CheckGroup=obj.CheckGroupDR.GroupDesc
	.i obj.Status="N" s Status="未考核"
	.e  s Status="已考核"
	s CheckScore=obj.CheckScore
	s CheckMonth=obj.CheckYear_"-"_obj.CheckMonth
	s CreateDate=$zd(obj.CreateDate,3)
	i obj.Status="N" s SubmitDate=$zd(+$h,3)
	e  s SubmitDate=$zd(obj.SubmitDate,3)
	i obj.CreateUser="" s CreateUser="管理员"
	e  s CreateUser=obj.CreateUser.PerName
	s CheckTransformScore=obj.CheckTransformScore
	q "Status|"_Status_"^KpiItem|"_KpiItem_"^CheckGroup|"_CheckGroup_"^CheckScore|"_CheckScore
	_"^CheckMonth|"_CheckMonth_"^CreateDate|"_CreateDate_"^SubmitDate|"_SubmitDate_"^CreateUser|"_CreateUser
	_"^CheckTransformScore|"_CheckTransformScore_"^RowId|"_id
}

/// creator: wangpf
/// createDate: 2019-09-06
/// description: 获取Kpi考核记录列表
/// table: DHCNMG.CHK.MgKpiCheck
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindKpiCheckList","")
Query FindKpiCheckList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiCheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindKpiCheckList")=parr
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemDR=$g(tmp("KpiItem"))
	s KpiGroupDR=$g(tmp("KpiGroup"))
	s CheckDateYear=$p($g(tmp("CheckDate")),"-")
	s CheckDateMonth=$p($g(tmp("CheckDate")),"-",2)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgKpiCheckD(rowid)) q:rowid=""  d
	.q:(KpiGroupDR'="")&&(KpiGroupDR'=$lg(^DHCNMG.CHK.MgKpiCheckD(rowid),2))
	.q:(CheckDateYear'="")&&(CheckDateYear'=$lg(^DHCNMG.CHK.MgKpiCheckD(rowid),3))
	.q:(CheckDateMonth'="")&&(CheckDateMonth'=$lg(^DHCNMG.CHK.MgKpiCheckD(rowid),4))
	.q:(KpiItemDR'="")&&(KpiItemDR'=$lg(^DHCNMG.CHK.MgKpiCheckD(rowid),7))
	.s ret=..GetKpiCheck(rowid)
	.q:ret=""
	.do OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiCheckListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// CreatDate: 2019-09-07
/// Description: 保存Kpi考核子表
/// Table：DHCNMG.CHK.MgKpiCheckSub
/// Input：
/// Return：1:成功
/// other: w ##class(web.NurArgWorkLoadComm).SaveKpiCheckSub("SubScore|1__7@2,2,2#1__8@2,2,2#1__9@5,5,5#1__10@5,5,5^CheckScore|14,14,14^CheckId|5")
ClassMethod SaveKpiCheckSub(parr As %String) As %String
{
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:$g(tmp("SubScore"))="" "数据错误"
	q:$g(tmp("CheckScore"))="" "数据错误"
	q:$g(tmp("CheckId"))="" "数据错误"
	s checkObj=##class(DHCNMG.CHK.MgKpiCheck).%OpenId(tmp("CheckId"))
	q:'$IsObject(checkObj) "数据错误"
	ts
	s flag=1
	s kpiItemObj=##class(DHCNMG.DB.MgKpiItem).%OpenId(+tmp("SubScore"))
	s:'$IsObject(kpiItemObj) flag=0
	f i=1:1:$l(tmp("SubScore"),"#") q:'flag  d
	.s subData=$p(tmp("SubScore"),"#",i)
	.s kpiItemSubId=$tr($p(subData,"@"),"__","||")
	.s kpiItemSubScore=$p(subData,"@",2)
	.i kpiItemSubId="" s flag=0 q
	.s kpiItemSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(kpiItemSubId)
	.i '$IsObject(kpiItemSubObj) s flag=0 q
	.s checkChildSub=$o(^DHCNMG.CHK.MgKpiCheckSubI("par",tmp("CheckId"),kpiItemSubId,""))
	.i checkChildSub s obj=##class(DHCNMG.CHK.MgKpiCheckSub).%OpenId(tmp("CheckId")_"||"_checkChildSub)
	.e  s obj=##class(DHCNMG.CHK.MgKpiCheckSub).%New()
	.i '$IsObject(obj) s flag=0 q
	.s obj.Parref=checkObj
	.s obj.KpiItemSubDR=kpiItemSubObj
	.s obj.CheckItemScore=kpiItemSubScore
	.s flag=obj.%Save()
	.q:flag'=1
	.f k=1:1:$l(kpiItemSubScore,",") d
	..i $p(kpiItemSubScore,",",k)<kpiItemSubObj.SubScore d
	...s questionObj=##class(DHCNMG.CHK.MgKpiQustion).%New()
	...i '$IsObject(questionObj) s flag=0 q
	...s questionObj.QuesKpiItemSubDR=kpiItemSubObj
	...s questionObj.QuesKpiGroupDR=checkObj.CheckGroupDR
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(checkObj.CheckGroupDR.GroupWardDR.GetAt(k))
	...i '$IsObject(wardObj) s flag=0 q
	...s questionObj.QuesWardDR=wardObj
	...s questionObj.QuesScore=$p(kpiItemSubScore,",",k)
	...s questionObj.QuesKpiCheckDR=obj.Parref
	...s flag=questionObj.%Save()
	
	i flag d
	.s checkObj.CheckScore=tmp("CheckScore")
	.s checkObj.Status="Y"
	.s checkObj.SubmitDate=+$h
	.s checkTransformScore=""
	.f j=1:1:$l(tmp("CheckScore"),",") d
	..i checkTransformScore="" s checkTransformScore=$p(tmp("CheckScore"),",",j)/kpiItemObj.KpiScore*100
	..e  s checkTransformScore=checkTransformScore_","_($p(tmp("CheckScore"),",",j)/kpiItemObj.KpiScore*100)
	.s checkObj.CheckTransformScore=checkTransformScore
	.s flag=checkObj.%Save()
	i flag=1
	{
		tc
		q 1
	}
	else
	{
		tro
		q "保存失败:"_$System.Status.DisplayError(flag)
	}
}

/// Creator:wangpf
/// Description:获取Kpi考核评分项
/// Date:2019-09-07
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindKpiCheckSubList","3")
Query FindKpiCheckSubList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiCheckSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindKpiCheckSubList")=parr
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgKpiItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan,rw1")=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw2)
	...q:'$IsObject(obj2)
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	b //1111
	s obj=##class(DHCNMG.DB.MgKpiItem).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgKpiItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.s canbenegative=obj1.SubCanBeNegative
	.i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..s realscore=obj1.SubScore
	..s sort=obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...s realscore=obj2.SubScore
	...s sort=obj2.SubSort
	...s canbenegative=obj2.SubCanBeNegative
	...i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr))  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s realscore=obj3.SubScore
	.....s sort=obj3.SubSort
	.....s canbenegative=obj3.SubCanBeNegative
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree_"^canbenegative|"_canbenegative
	.....//s isShow1=0,isShow2=0
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..//s:sort2=0 TwoIsShow=0
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreData
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiCheckSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiCheckSubListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiCheckSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiCheckSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:
/// Date:2019-09-08
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindScoreLists","4","12")
Query FindScoreLists(parr As %String, parr2 As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreListsExecute(ByRef qHandle As %Binary, parr As %String, parr2 As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindScoreLists")=parr_"^"_parr2
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgKpiItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan,rw1")=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw2)
	...q:'$IsObject(obj2)
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	b //1111
	s obj=##class(DHCNMG.DB.MgKpiItem).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgKpiItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..;wangpf start
	..;s realscore=obj1.SubScore
	..s checksubrw1=$o(^DHCNMG.CHK.MgKpiCheckSubI("par",parr2,obj1.%Id(),""))
	..s checksubObj=##class(DHCNMG.CHK.MgKpiCheckSub).%OpenId(parr2_"||"_checksubrw1)
	..i '$IsObject(checksubObj) s realscore=obj1.SubScore
	..e  s realscore=checksubObj.CheckItemScore
	..s canbenegative=obj1.SubCanBeNegative
	..;wangpf end
	..s sort=obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative //wangpf
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_obj1.SubScore_"^realScore|"_realscore_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...;wangpf start
	...;s realscore=obj2.SubScore
	...s checksubrw2=$o(^DHCNMG.CHK.MgKpiCheckSubI("par",parr2,obj2.%Id(),""))
	...s checksubObj2=##class(DHCNMG.CHK.MgKpiCheckSub).%OpenId(parr2_"||"_checksubrw2)
	...i '$IsObject(checksubObj2) s realscore=obj2.SubScore
	...e  s realscore=checksubObj2.CheckItemScore
	...s canbenegative=obj2.SubCanBeNegative
	...;wangpf end
	...s sort=obj2.SubSort
	...i '$d(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr))  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative //wangpf
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_obj2.SubScore_"^realScore|"_realscore_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|^canbenegative|"_canbenegative //wangpf
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgKpiItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....;wangpf start
	.....;s realscore=obj3.SubScore
	.....s checksubrw3=$o(^DHCNMG.CHK.MgKpiCheckSubI("par",parr2,obj3.%Id(),""))
	.....s checksubObj3=##class(DHCNMG.CHK.MgKpiCheckSub).%OpenId(parr2_"||"_checksubrw3)
	.....i '$IsObject(checksubObj3) s realscore=obj3.SubScore
	.....e  s realscore=checksubObj3.CheckItemScore
	.....s canbenegative=obj3.SubCanBeNegative
	.....;wangpf end
	.....s sort=obj3.SubSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_obj3.SubScore_"^realScore|"_realscore_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree_"^canbenegative|"_canbenegative //wangpf
	.....//s isShow1=0,isShow2=0
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..//s:sort2=0 TwoIsShow=0
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreLists
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreLists
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreLists
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreListsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindScoreListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:获取Kpi问题汇总记录
/// Date:2019-09-17
/// Table: DHCNMG.DB.MgKpiQustion
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurArgWorkLoadComm).GetKpiQuestion(1)
ClassMethod GetKpiQuestion(id As %String) As %String
{
	s ^TMP("GetKpiQuestion")=id
	q:id="" ""
	s obj=##class(DHCNMG.CHK.MgKpiQustion).%OpenId(id)
	q:'$IsObject(obj) ""
	//问题来源
	s KpiItemId=obj.QuesKpiItemSubDR.Parref.%Id()
	s KpiItemDesc=obj.QuesKpiItemSubDR.Parref.KpiDesc
	//考核组别
	s CheckGroupId=obj.QuesKpiGroupDR.%Id()
	s CheckGroupDesc=obj.QuesKpiGroupDR.GroupDesc
	//考核病区
	s WardId=obj.QuesWardDR.%Id()
	s WardDesc=obj.QuesWardDR.WardDesc
	//实际分值
	s QuesScore=obj.QuesScore
	//考核日期
	s CheckMonth=obj.QuesKpiCheckDR.CheckYear_"-"_obj.QuesKpiCheckDR.CheckMonth
	//问题描述
	s QuesDesc=obj.QuesKpiItemSubDR.SubDesc
	//扣分标准
	s SubStandard=obj.QuesKpiItemSubDR.SubStandard
	//标准分值
	s StandardScore=obj.QuesKpiItemSubDR.SubScore
	q "CheckMonth|"_CheckMonth_"^CheckGroupId|"_CheckGroupId_"^CheckGroupDesc|"_CheckGroupDesc
	_"^WardId|"_WardId_"^WardDesc|"_WardDesc_"^KpiItemId|"_KpiItemId_"^KpiItemDesc|"_KpiItemDesc
	_"^QuesDesc|"_QuesDesc_"^QuesScore|"_QuesScore_"^StandardScore|"_StandardScore_"^SubStandard|"_SubStandard
	_"^RowId|"_id
}

/// creator: wangpf
/// createDate: 2019-09-17
/// description: 获取Kpi问题汇总列表
/// table: DHCNMG.DB.MgKpiQustion
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindKpiQuestionList","")
Query FindKpiQuestionList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiQuestionListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindKpiQuestionList")=parr
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemDR=$g(tmp("KpiItem"))
	s KpiGroupDR=$g(tmp("KpiGroup"))
	s WardDR=$g(tmp("KpiWard"))
	s CheckDateYear=$p($g(tmp("KpiCheckDate")),"-")
	s CheckDateMonth=$p($g(tmp("KpiCheckDate")),"-",2)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgKpiQustionD(rowid)) q:rowid=""  d
	.s kpiQuesObj=##class(DHCNMG.CHK.MgKpiQustion).%OpenId(rowid)
	.q:'$IsObject(kpiQuesObj)
	.q:(KpiGroupDR'="")&&(KpiGroupDR'=kpiQuesObj.QuesKpiGroupDR.%Id())
	.q:(CheckDateYear'="")&&(CheckDateYear'=kpiQuesObj.QuesKpiCheckDR.CheckYear)
	.q:(CheckDateMonth'="")&&(CheckDateMonth'=kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	.q:(KpiItemDR'="")&&(KpiItemDR'=kpiQuesObj.QuesKpiItemSubDR.Parref.%Id())
	.q:(WardDR'="")&&(WardDR'=kpiQuesObj.QuesWardDR.%Id())
	.s ret=..GetKpiQuestion(rowid)
	.q:ret=""
	.do OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiQuestionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiQuestionListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiQuestionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiQuestionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:获取Kpi问题汇总记录
/// Date:2019-09-17
/// Table: DHCNMG.CHK.MgKpiCheck
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurArgWorkLoadComm).GetKpiQuesColumn()
ClassMethod GetKpiQuesColumn() As %String
{
	s ret=""
	s checkItemId="" f  s checkItemId=$o(^DHCNMG.CHK.MgKpiCheckI("CheckItem",checkItemId)) q:checkItemId=""  d
	.i ret="" s ret="[{""KpiItemId"":"_checkItemId_",""KpiItemDesc"":"""_##class(DHCNMG.DB.MgKpiItem).%OpenId(checkItemId).KpiDesc_"""}"
	.e  s ret=ret_",{""KpiItemId"":"_checkItemId_",""KpiItemDesc"":"""_##class(DHCNMG.DB.MgKpiItem).%OpenId(checkItemId).KpiDesc_"""}"
	q ret_"]"
}

/// creator: wangpf
/// createDate: 2019-09-18
/// description: 获取Kpi得分列表
/// table: DHCNMG.CHK.MgKpiCheck
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindKpiCheckScoreList","")
Query FindKpiCheckScoreList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiCheckScoreListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindKpiCheckScoreList")=parr
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemDR=$g(tmp("KpiItem"))
	s KpiGroupDR=$g(tmp("KpiGroup"))
	s WardDR=$g(tmp("KpiWard"))
	s CheckDateYear=$p($g(tmp("KpiCheckDate")),"-")
	s CheckDateMonth=$p($g(tmp("KpiCheckDate")),"-",2)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgKpiCheckI("CheckStatus"," Y",rowid)) q:rowid=""  d
	.s kpiCheckObj=##class(DHCNMG.CHK.MgKpiCheck).%OpenId(rowid)
	.q:'$IsObject(kpiCheckObj)
	.q:(KpiItemDR'="")&&(KpiItemDR'=kpiCheckObj.KpiItemDR.%Id())
	.q:(KpiGroupDR'="")&&(KpiGroupDR'=kpiCheckObj.CheckGroupDR.%Id())
	.q:(CheckDateYear'="")&&(CheckDateYear'=kpiCheckObj.CheckYear)
	.q:(CheckDateMonth'="")&&(CheckDateMonth'=kpiCheckObj.CheckMonth)
	.q:(WardDR'="")&&(kpiCheckObj.CheckGroupDR.GroupWardDR.Find(WardDR)="")
	.s CheckMonth=kpiCheckObj.CheckYear_"-"_kpiCheckObj.CheckMonth
	.s CheckGroupDesc=kpiCheckObj.CheckGroupDR.GroupDesc
	.s KpiItemDesc=kpiCheckObj.KpiItemDR.KpiDesc
	.i WardDR="" d
	..f i=1:1:kpiCheckObj.CheckGroupDR.GroupWardDR.Count() d
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(kpiCheckObj.CheckGroupDR.GroupWardDR.GetAt(i))
	...q:'$IsObject(wardObj)
	...s WardDesc=wardObj.WardDesc
	...s CheckScore=$p(kpiCheckObj.CheckScore,",",i)
	...s CheckTransformScore=$p(kpiCheckObj.CheckTransformScore,",",i)
	...s ret="CheckMonth|"_CheckMonth_"^CheckGroupDesc|"_CheckGroupDesc_"^KpiItemDesc|"_KpiItemDesc_"^WardDesc|"_WardDesc_"^CheckScore|"_CheckScore_"^CheckTransformScore|"_CheckTransformScore
	...do OutKpiData
	.e  d
	..f i=1:1:kpiCheckObj.CheckGroupDR.GroupWardDR.Count() d
	...q:WardDR'=kpiCheckObj.CheckGroupDR.GroupWardDR.GetAt(i)
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(kpiCheckObj.CheckGroupDR.GroupWardDR.GetAt(i))
	...q:'$IsObject(wardObj)
	...s WardDesc=wardObj.WardDesc
	...s CheckScore=$p(kpiCheckObj.CheckScore,",",i)
	...s CheckTransformScore=$p(kpiCheckObj.CheckTransformScore,",",i)
	...s ret="CheckMonth|"_CheckMonth_"^CheckGroupDesc|"_CheckGroupDesc_"^KpiItemDesc|"_KpiItemDesc_"^WardDesc|"_WardDesc_"^CheckScore|"_CheckScore_"^CheckTransformScore|"_CheckTransformScore
	...do OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiCheckScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiCheckScoreListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiCheckScoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiCheckScoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: wangpf
/// createDate: 2019-09-18
/// description: 获取Kpi问题频次列表
/// table: DHCNMG.DB.MgKpiQustion
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurArgWorkLoadComm","FindKpiQuesTimeList","")
Query FindKpiQuesTimeList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindKpiQuesTimeListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindKpiQuesTimeList")=parr
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemDR=$g(tmp("KpiItem"))
	s KpiGroupDR=$g(tmp("KpiGroup"))
	s WardDR=$g(tmp("KpiWard"))
	s CheckDateStYear=$p($g(tmp("KpiCheckStDate")),"-")
	s CheckDateStMonth=$p($g(tmp("KpiCheckStDate")),"-",2)
	s CheckDateEndYear=$p($g(tmp("KpiCheckEndDate")),"-")
	s CheckDateEndMonth=$p($g(tmp("KpiCheckEndDate")),"-",2)
	s CheckMonth="",KpiItemDesc="",QuesDesc="",WardDesc="",QuesTime=""
	s kpiSubId="" f  s kpiSubId=$O(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiSubId)) q:kpiSubId=""  d
	.q:(KpiItemDR'="")&&(KpiItemDR'=+kpiSubId)
	.s kpiSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(kpiSubId)
	.q:'$IsObject(kpiSubObj)
	.s KpiItemDesc=kpiSubObj.Parref.KpiDesc
	.s QuesDesc=kpiSubObj.SubDesc
	.s wardId="" f  s wardId=$O(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiSubId,wardId)) q:wardId=""  d
	..q:(WardDR'="")&&(WardDR'=wardId)
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
	..q:'$IsObject(wardObj)
	..s WardDesc=wardObj.WardDesc
	..s QuesTime=0
	..s kpiQuesId="" f  s kpiQuesId=$O(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiSubId,wardId,kpiQuesId)) q:kpiQuesId=""  d
	...s kpiQuesObj=##class(DHCNMG.CHK.MgKpiQustion).%OpenId(kpiQuesId)
	...q:'$IsObject(kpiQuesObj)
	...q:(KpiGroupDR'="")&&(KpiGroupDR'=kpiQuesObj.QuesKpiGroupDR.%Id())
	...q:(CheckDateStYear'="")&&(+CheckDateStYear>+kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateStMonth'="")&&(+CheckDateStMonth>+kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...q:(CheckDateEndYear'="")&&(+CheckDateEndYear<+kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateEndMonth'="")&&(+CheckDateEndMonth<+kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...s CheckGroupDesc=kpiQuesObj.QuesKpiGroupDR.GroupDesc
	...s QuesTime=QuesTime+1
	..q:QuesTime=0
	..s ret="KpiItemDesc|"_KpiItemDesc_"^CheckGroupDesc|"_CheckGroupDesc_"^QuesDesc|"_QuesDesc_"^WardDesc|"_WardDesc_"^QuesTime|"_QuesTime
	..d OutKpiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutKpiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindKpiQuesTimeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindKpiQuesTimeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindKpiQuesTimeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindKpiQuesTimeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangpf
/// Description:获取Kpi扣分问题比例
/// Date:2019-09-18
/// Table: DHCNMG.CHK.MgKpiQustion
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurArgWorkLoadComm).GetKpiQuesScale("")
ClassMethod GetKpiQuesScale(parr As %String) As %String
{
	s ^TMP("GetKpiQuesScale")=parr
	k tmp
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemId=$g(tmp("KpiItem"))
	s CheckDateStYear=$p($g(tmp("KpiCheckStDate")),"-")
	s CheckDateStMonth=$p($g(tmp("KpiCheckStDate")),"-",2)
	s CheckDateEndYear=$p($g(tmp("KpiCheckEndDate")),"-")
	s CheckDateEndMonth=$p($g(tmp("KpiCheckEndDate")),"-",2)
	q:KpiItemId="" "[]"
	s ret="["
	s kpiItemSubId="" f  s kpiItemSubId=$o(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiItemSubId)) q:kpiItemSubId=""  d
	.q:KpiItemId'=+kpiItemSubId
	.s kpiItemSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(kpiItemSubId)
	.q:'$IsObject(kpiItemSubObj)
	.s name=kpiItemSubObj.SubDesc
	.s count=0
	.s wardId="" f  s wardId=$o(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiItemSubId,wardId)) q:wardId=""  d
	..s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
	..q:'$IsObject(wardObj)
	..s kpiQuesId="" f  s kpiQuesId=$o(^DHCNMG.CHK.MgKpiQustionI("KpiItemSubTimesIndex",kpiItemSubId,wardId,kpiQuesId)) q:kpiQuesId=""  d
	...s kpiQuesObj=##class(DHCNMG.CHK.MgKpiQustion).%OpenId(kpiQuesId)
	...q:'$IsObject(kpiQuesObj)
	...q:(CheckDateStYear'="")&&(CheckDateStYear>kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateStMonth'="")&&(CheckDateStMonth>kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...q:(CheckDateEndYear'="")&&(CheckDateEndYear<kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateEndMonth'="")&&(CheckDateEndMonth<kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...s count=count+1
	.q:count=0
	.i ret="[" s ret=ret_"{""name"":"_""""_name_""",""data"":"_count_"}"
	.e  s ret=ret_",{""name"":"_""""_name_""",""data"":"_count_"}"
	q ret_"]"
}

/// Creator:wangpf
/// Description:获取Kpi扣分病区比例
/// Date:2019-09-18
/// Table: DHCNMG.CHK.MgKpiQustion
/// Input:
/// Output：
/// Return:
/// other: w ##class(web.NurArgWorkLoadComm).GetKpiWardScale("")
ClassMethod GetKpiWardScale(parr As %String) As %String
{
	s ^TMP("GetKpiWardScale")=parr
	k tmp
	s tmp=""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s KpiItemId=$g(tmp("KpiItem"))
	s CheckDateStYear=$p($g(tmp("KpiCheckStDate")),"-")
	s CheckDateStMonth=$p($g(tmp("KpiCheckStDate")),"-",2)
	s CheckDateEndYear=$p($g(tmp("KpiCheckEndDate")),"-")
	s CheckDateEndMonth=$p($g(tmp("KpiCheckEndDate")),"-",2)
	q:KpiItemId="" "[]"
	s ret="["
	s wardId="" f  s wardId=$o(^DHCNMG.CHK.MgKpiQustionI("WardTimesIndex",wardId)) q:wardId=""  d
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
	.q:'$IsObject(wardObj)
	.s name=wardObj.WardDesc
	.s count=0
	.s kpiItemSubId="" f  s kpiItemSubId=$o(^DHCNMG.CHK.MgKpiQustionI("WardTimesIndex",wardId,kpiItemSubId)) q:kpiItemSubId=""  d
	..q:KpiItemId'=+kpiItemSubId
	..s kpiItemSubObj=##class(DHCNMG.DB.MgKpiItemSub).%OpenId(kpiItemSubId)
	..q:'$IsObject(kpiItemSubObj)
	..s kpiQuesId="" f  s kpiQuesId=$o(^DHCNMG.CHK.MgKpiQustionI("WardTimesIndex",wardId,kpiItemSubId,kpiQuesId)) q:kpiQuesId=""  d
	...s kpiQuesObj=##class(DHCNMG.CHK.MgKpiQustion).%OpenId(kpiQuesId)
	...q:'$IsObject(kpiQuesObj)
	...q:(CheckDateStYear'="")&&(CheckDateStYear>kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateStMonth'="")&&(CheckDateStMonth>kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...q:(CheckDateEndYear'="")&&(CheckDateEndYear<kpiQuesObj.QuesKpiCheckDR.CheckYear)
	...q:(CheckDateEndMonth'="")&&(CheckDateEndMonth<kpiQuesObj.QuesKpiCheckDR.CheckMonth)
	...s count=count+1
	.q:count=0
	.i ret="[" s ret=ret_"{""name"":"_""""_name_""",""data"":"_count_"}"
	.e  s ret=ret_",{""name"":"_""""_name_""",""data"":"_count_"}"
	q ret_"]"
}

}
