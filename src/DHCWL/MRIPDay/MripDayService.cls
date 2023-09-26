Class DHCWL.MRIPDay.MripDayService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     	陈乙
/// CreatDate：    	2014-10-09
/// Description:： 	根据代码获取指标id的串,用","分隔，支持模糊查找
/// Table：       	DHCWL_MKPI.DHCWLMKPI
/// Input：       	codeStr:kpi代码串,用","分隔
/// Output：      
/// Return：      	成功返回kpi id串,否则返回""
/// HowToUse:		d ##class(DHCWL.MRIPDay.MripDayService).GetKPIIdStrByCodeWithLike("1,2")
/// Others：		只能查找指标类型是"出入转"类型的    kpiSelectInfoCfg.csp所用类方法
ClassMethod GetKPIIdStrByCodeWithLike(codeStr) As %String
{
	n (codeStr) 
	q:codeStr="" ""
	s codeLen=$l(codeStr,",")
	s kpiStr=""
	f len=1:1:codeLen d
	.s code=$p(codeStr,",",len)
	.q:code=""
	.s kpiID=0
	.f  s kpiID=$o(^DHCWL.MKPI.MKPID(kpiID)) q:kpiID=""  d
	..s kpiCate=$lg(^DHCWL.MKPI.MKPID(kpiID),9)
	..q:$g(kpiCate)=""
	..s kpiType=$lg(^DHCWL.MKPI.MKPIFLD(kpiCate),2)
	..q:(kpiType'="CRZ")   ;加载工作量指标，待改为出入转约束code
	..s kpiCode=$lg(^DHCWL.MKPI.MKPID(kpiID),2)
	..q:$g(kpiCode)=""
	..q:($zcvt(kpiCode,"U") '[ $zcvt(code,"U"))
	..i kpiStr="" s kpiStr=kpiID
	..e  s kpiStr=kpiStr_","_kpiID
	q kpiStr
}

/// Creator:		陈乙
/// CreatDate:		
/// Description:	根据指标id，取指标的部分数据，改为json数据格式，返回json
/// 					
/// Table:			
/// Input:			kpiIds-指标ID
/// Output:			
/// Return:			
/// HowToUse:		d ##class(DHCWL.MRIPDay.MripDayService).IsNotCfgKpi2("889,890")
/// Other:			用于出入转指标类型统计项提供待选指标集   kpiSelectInfoCfg.csp所用类方法
ClassMethod IsNotCfgKpi2(kpiIds = "") As DHCWL.util.Json
{
	n (kpiIds)
	q:(kpiIds=-1) ""   	;没有对应的kpiID时，直接返回0
	s len=$l(kpiIds,",")
	s num=1
	f i=1:1:len d
	.s id=$p(kpiIds,",",i)
	.s kpiId="" f  s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId)) q:kpiId=""  d
	..;q:(0'=$d(^DHCWL.MKPI.MKPILoginI("MKPIDr",kpiId)))
	..q:(""'=id)&&(id'=kpiId)
	..s kpiCate=$lg(^DHCWL.MKPI.MKPID(kpiId),9)
	..q:$g(kpiCate)="" 
	..s kpiType=$lg(^DHCWL.MKPI.MKPIFLD(kpiCate),2)
	..q:(kpiType'="CRZ")   ;加载工作量指标，待改为出入转约束code
	..s dimDr=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,""))
	..s arrs(num,"ID")=kpiId
	..s arrs(num,"kpiCode")=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..s arrs(num,"kpiName")=$lg(^DHCWL.MKPI.MKPID(kpiId),3)
	..;add by wz.2014-10-13,增加一个指标维度编码.指标维度编码作为界面中的维度编码，
	..;而原来的维度编码dimCode则作为报表类型

	..s MKPIDim=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimKPII",kpiId,dimDr,""))	
	..s arrs(num,"kpiDimCode")=$lg(^DHCWL.MKPI.MKPIDimensionsD(MKPIDim),2)  ;获取维度代码

	..s arrs(num,"dimCode")=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),2)  ;获取维度代码
	..s kpiFlId=$lg(^DHCWL.MKPI.MKPID(kpiId),9)
	..i ((0=+kpiFlId)||('$d(^DHCWL.MKPI.MKPIFLD(kpiFlId)))) s kpiFl=""
	..e  s kpiFl=$lg(^DHCWL.MKPI.MKPIFLD(kpiFlId),3)
	..s arrs(num,"category")=kpiFl
	..s secId=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
	..i ((0=+secId)||('$d(^DHCWL.MKPI.SectionD(secId)))) s section=""
	..e  s section=$lg(^DHCWL.MKPI.SectionD(secId),4)
	..s arrs(num,"section")=section
	..s num=num+1
	if ($d(arrs)) s json=##class(DHCWL.MRIPDay.MripDayService).MetrixToJson(.arrs)
	
	q $g(json)
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	将二维矩阵转换为json数据
/// Table:			
/// Input:			arrs:待转换的二维矩阵
/// return:			json数据
/// HowToUse:		s arr(1,"id")=1,arr(1,"name")="JEFF",arr(1,"nickName")="JEFF",arr(2,"id")=2,arr(2,"name")="JEFF2",arr(2,"nickName")="JEFF23",json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arr)
ClassMethod MetrixToJson(ByRef arrs) As DHCWL.util.Json
{
	n (arrs)
	/// 处理二维矩阵转换为json数据(目前仅支持二维矩阵,对于二维数组尚不能很好支持)
	s tab="", nod="", nod=$o(arrs(nod)), tab=$o(arrs(nod,tab)), tabList="", valueList=""
	k valueArray	//edited by lhh
	while(""'=tab){
			/// 组装json标签列表
			i (""=tabList) s tabList=tab
			e  s tabList=tabList_"^"_tab
			s valueArray(tab)=""
			s tab=$o(arrs(nod,tab))
	}
	/// 用定义的json标准格式初始化json容器
	s json=##class(DHCWL.util.Json).Json(tabList)	
	s tab=$o(arrs(nod,""))
	
	while(""'=nod){
		s valueList="", tab=$o(arrs(nod,""))
		s property="" //edited by lhh20131105
		f {
			s property=$o(valueArray(property))
			q:property=""
			if ('$d(arrs(nod,property))){
				s value=""
			}else{
				s value=arrs(nod,property)
			}
			s:(value ["'") value=##class(DHCWL.MRIPDay.MripDayService).ReplaceStr(value,"'","\'")
			i (""=valueList) s valueList="'"_value_"'"
			e  s valueList=valueList_"^'"_value_"'"
		}
		/*
		while(""'=tab){
			/// 组装json值列表
			i (""=valueList) s valueList="'"_$g(arrs(nod,tab))_"'"
			e  s valueList=valueList_"^'"_$g(arrs(nod,tab))_"'"
			s tab=$o(arrs(nod,tab))
		}
		if (tab=""){
			i (""=valueList) s valueList="''"
			e  s valueList=valueList_"^''"
		}*/
		/// 将组装好的json值列表有序的填充json容器
		d json.Insert(valueList)
		s nod=$o(arrs(nod))
	}
	q json
}

/// Creator：      ban
/// CreatDate：    2012-07-05
/// Description:： 根据代码获取指标id的串,用","分隔
/// Table：       DHCWL_MKPI.DHCWLMKPI
/// Input：       codeStr:kpi代码串,用","分隔
/// Output：      
/// Return：      成功返回kpi id串,否则返回""
/// Others：
ClassMethod GetKPIIdStrByCode(codeStr) As %String
{
	n (codeStr) 
	q:codeStr="" ""
	s codeLen=$l(codeStr,",")
	s kpiStr=""
	f len=1:1:codeLen d
	.s code=$p(codeStr,",",len)
	.s kpiId=..GetKPIByName(code)
	.q:+kpiId=0
	.i kpiStr="" s kpiStr=kpiId
	.e  s kpiStr=kpiStr_","_kpiId
	q kpiStr
}

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 根据代码获取KPI id
/// Table：       DHCWL.MKPI.MKPI
/// Input：       code:kpi代码
/// Output：      
/// Return：      成功返回区间id,否则返回0
/// Others：
ClassMethod GetKPIByName(code) As %String
{
	
	n (code)
	q ##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.MKPI")  //用此方法替代@20130530
	q:code="" 0
	i $d(^DHCWL.MKPI.MKPID(code)) q code
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.MKPI.MKPII("MKPICode"," "_code))&&('$d(^DHCWL.MKPI.MKPII("MKPICode",code))) 0	
	s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode",code,""))
	i kpiId="" s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICode"," "_code,""))
	
	q kpiId
}

/// Creator：      	wz
/// CreatDate：    	2014-10-21
/// Description:： 	得到统计项类型：KPIItem-指标类统计项;CoustomItem-自定义统计项;CalItem-计算类统计项
/// Table：       	DHCWL_MRIPDay.OPTLItem
/// Input：       	RptItemOPTLItemDR: DHCWL_MRIPDay.OPTLItem的ROWID
/// Output：      
/// Return：      	统计项类型
/// Others：
/// d ##class(DHCWL.MRIPDay.MripDayService).GetOPTLItemType("1")
ClassMethod GetOPTLItemType(RptItemOPTLItemDR As %String) As %String
{
	n (RptItemOPTLItemDR)
	s itemType=""
	&sql(select OPTLItem_Type into :itemType from DHCWL_MRIPDay.OPTLItem where OPTLItem_RowID=:RptItemOPTLItemDR)
	
	q itemType
}

/// Creator：      	WZ
/// CreatDate：    	2014-10-21
/// Description:： 	得到统计项对应的KPI和日期敏感度
/// Table：       	DHCWL_MRIPDay.KPIItem
/// Input：       	RptItemOPTLItemDR,rptType
/// Output：      
/// Return：      
/// Others：
/// d ##class(DHCWL.MRIPDay.MripDayService).GetKPIItemKPICode("1","CTLOC","end")
ClassMethod GetKPIItemKPICode(RptItemOPTLItemDR As %String, rptType As %String, ByRef KPICode, ByRef dateSec, ByRef DimCode) As %Integer
{
	
	&sql(select KPIItem_KPICode,KPIItem_DateSec,KPIItem_DimCode into :KPICode,:dateSec,:DimCode from DHCWL_MRIPDay.KPIItem where KPIItem_OPTLItemDR=:RptItemOPTLItemDR and KPIItem_ItemType=:rptType)
	q SQLCODE
	
	/*
	s kpiItemID=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemTypeIndex",RptItemOPTLItemDR,rptType,0))
	s KPICode=$lg(^DHCWL.MRIPDay.KPIItemD(kpiItemID),4)
	s dateSec=$lg(^DHCWL.MRIPDay.KPIItemD(kpiItemID),8)
	*/
}

/// Creator：      	WZ
/// CreatDate：    	2014-10-21
/// Description:： 	根据报表类型和统计项ID得到对应自定义统计项对应的ROWID
/// Table：       	DHCWL_MRIPDay.CustomItem
/// Input：       	RptItemOPTLItemDR:统计项ID,rptType:报表类型
/// Output：      	
/// Return：      	自定义统计项对应的ROWID
/// Others：
ClassMethod GetCustomItemID(RptItemOPTLItemDR As %String, rptType As %String, ByRef CustomItemID) As %Integer
{
	
	&sql(select CustomItem_RowID into :CustomItemID from DHCWL_MRIPDay.CustomItem where CustomItem_OPTLItemDR=:RptItemOPTLItemDR and CustomItem_ItemType=:rptType)
	q SQLCODE
	
	/*
	s kpiItemID=$o(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemTypeIndex",RptItemOPTLItemDR,rptType,0))
	s KPICode=$lg(^DHCWL.MRIPDay.KPIItemD(kpiItemID),4)
	s dateSec=$lg(^DHCWL.MRIPDay.KPIItemD(kpiItemID),8)
	*/
}

/// Creator：      	WZ
/// CreatDate：    	2014-11-08
/// Description:	根据时间敏感区间得到对应的数据集
/// Table：       	DHCWL_MKPI.MMgrDataSetCfg
/// Input：       	treeCode:模块的树形编码；rptMMgrCode：报表的编码；dateSec：时间敏感度
/// Output：      
/// Return：      	数据集的ROWID
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).GetDataset("root.BATJ2","WT4","end")
ClassMethod GetDataset(treeCode As %String, rptMMgrCode As %String, dateSec As %String) As %String
{
	s dsCode=""
	if dateSec="begin" {s dsCode="ds1"}
	elseif dateSec="end" {s dsCode="ds2"}
	elseif dateSec="all" {s dsCode="ds3"}
	
	//Index DatasetMRCodeIdx On (DatasetTreeCode, DatasetRptCode, DatasetCfgCode);
	//q:$d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptMMgrCode,dsCode))=0 ""
	s datasetRowID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptMMgrCode,dsCode,0))
	
	q datasetRowID
}

/// Creator：      WZ
/// CreatDate：    2014-11-08
/// Description:： 删除报表项
/// Table：       
/// Input：       RptItemRptDR:报表DR,RptItemOPTLItemDR:被删除的可选报表项DR,aryRptItemOPTLItemDRs：剩余的需要重新排序的报表项DR
/// Output：      
/// Return：      0：成功；‘=0：失败
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).DelRptItem("2","3","4,6")
ClassMethod DelRptItem(RptItemRptDR As %String, RptItemOPTLItemDR As %String, aryRptItemOPTLItemDRs As %String) As %Integer
{
	s $zt="ErrorReturn"
	s rptMMgrCode=""
	s rptType=""
	&sql(select Rpt_MMgrCode ,Rpt_Type into :rptMMgrCode,:rptType from DHCWL_MRIPDay.Rpt where Rpt_RowID=:RptItemRptDR)

	//1、得到统计项类型：KPIItem-指标类统计项;CoustomItem-自定义统计项;CalItem-计算类统计项

	s OPTLItemType=##class(DHCWL.MRIPDay.MripDayService).GetOPTLItemType(RptItemOPTLItemDR)
	
	//TSTART
	if OPTLItemType="KPIItem" {
		//2、下面处理数据集和指标
		s treeCode="root.CRZZBB"

		//2.1、得到统计项对应的KPI和日期敏感度
		s KPICode=""
		s dateSec=""
		s statue=##class(DHCWL.MRIPDay.MripDayService).GetKPIItemKPICode(RptItemOPTLItemDR,rptType,.KPICode,.dateSec)
	
		//2.2、得到对应的数据集
		s datasetDR=##class(DHCWL.MRIPDay.MripDayService).GetDataset(treeCode,rptMMgrCode,dateSec)
		//2.3、更新数据集的取数规则
		s newRuleList=""	
		if $g(datasetDR)'="" {
			//2.4把取数规则中对应的指标清空
			s ruleList=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(datasetDR),5)
			s count=$l(ruleList,",")
			for i=1:1:count {
				s subRule=$p(ruleList,",",i)
				s kpi=$p(subRule,":",1)
				if kpi'=KPICode {
					if newRuleList'="" s newRuleList=newRuleList_","
					s newRuleList= newRuleList_subRule
				}	
			}
		}
		

		//2.5更新数据集的取数规则
		&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_RuleList=:newRuleList where DatasetCfg_RowID=:datasetDR)
		if SQLCODE'=0 {
			//w "{success:true,tip:'添加失败！',SQLCODE:"_SQLCODE_"}"
			q SQLCODE
		}
	}
		
	//3、删除报表项
	&sql(delete from DHCWL_MRIPDay.RptItem where RptItem_RptDR=:RptItemRptDR and RptItem_OPTLItemDR=:RptItemOPTLItemDR)
	if SQLCODE'=0 {
		//w "{success:true,tip:'添加失败！',SQLCODE:"_SQLCODE_"}"
		q SQLCODE
	}

	//4、删除明细报表
	//DHCWL_MRIPDay.DetailRpt WHERE DetailRpt_OPTLItemDR is NULL AND DetailRpt_RptDR=10
	
	if aryRptItemOPTLItemDRs="" {
		&sql(delete from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:RptItemRptDR)
		q:((+$g(SQLCODE)'=0)&&(+$g(SQLCODE)'=100)) 1

	}else{
		s DetailRptRowID=""
		if $g(RptItemOPTLItemDR)'="" {
			&sql(select DetailRpt_RowID into:DetailRptRowID from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:RptItemRptDR and DetailRpt_OPTLItemDR=:RptItemOPTLItemDR)
		}else{
			&sql(select DetailRpt_RowID into:DetailRptRowID from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:RptItemRptDR and DetailRpt_OPTLItemDR is null)
		}

		if $g(DetailRptRowID)'="" {
			&sql(delete from DHCWL_MRIPDay.DetailRpt where DetailRpt_RowID =:DetailRptRowID)
			if SQLCODE'=0 {
				//w "{success:true,tip:'添加失败！',SQLCODE:"_SQLCODE_"}"
				q SQLCODE
			}
		}
	}

	s successFlag=1
	s count=$l(aryRptItemOPTLItemDRs,",")
	//5、更新报表项的顺序
	for i=1:1:count {
		s OPTLItemDR=$p(aryRptItemOPTLItemDRs,",",i)
		if $g(OPTLItemDR)="" continue
		&sql(update DHCWL_MRIPDay.RptItem set RptItem_Order=:i where RptItem_RptDR=:RptItemRptDR and RptItem_OPTLItemDR=:OPTLItemDR)
		if SQLCODE'=0 {
			//w "{success:true,tip:'添加失败！',SQLCODE:"_SQLCODE_"}"
			s successFlag=0
			q 

		}
	}
	q:successFlag=0 1
	//w "{success:true,tip:'ok',ROWID:"_%ROWID_"}"
	q 0
	
ErrorReturn
	//trollback
	q 1
}

/// Creator：      	WZ
/// CreatDate：    	2014-11-7
/// Description:： 	根据报表的ID,得到所有报表项描述
/// Table：       	DHCWL.MKPI.MKPI
/// Input：       	rptRowID：报表的ID
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).GetRptItemDesc("8")
ClassMethod GetRptItemDesc(rptRowID As %String) As %String
{
	s rptItemDesc=""
	s rptItemRowID=0
	f {
		s rptItemRowID=$o(^DHCWL.MRIPDay.RptItemI("RptItemRptDRIndex",rptRowID,rptItemRowID))
		q:rptItemRowID=""
		s desc=$lg(^DHCWL.MRIPDay.RptItemD(rptItemRowID),3)
		if rptItemDesc'="" s rptItemDesc=rptItemDesc_";"
		s rptItemDesc=rptItemDesc_desc
	}
	q rptItemDesc
}

/// Creator：      WZ
/// CreatDate：    2014-11-7
/// Description:： 根据报表的ID得到对应的明细报表的描述
/// Table：       
/// Input：       rptRowID：报表的ID
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).GetDetailRptDesc("8")
ClassMethod GetDetailRptDesc(rptRowID As %String) As %String
{
	s DetailRptOPTLItemDR=""
	s detailRptDesc=""
	f {
		s DetailRptOPTLItemDR=$o(^DHCWL.MRIPDay.DetailRptI("RptOPTLItem",rptRowID,DetailRptOPTLItemDR))
		q:DetailRptOPTLItemDR=""
		s detailRptRowID=""
		f {
			s detailRptRowID=$o(^DHCWL.MRIPDay.DetailRptI("RptOPTLItem",rptRowID,DetailRptOPTLItemDR,detailRptRowID))
			q:detailRptRowID=""
			s desc=$lg(^DHCWL.MRIPDay.DetailRptD(detailRptRowID),3)
			if desc="" continue
			if detailRptDesc'="" s detailRptDesc=detailRptDesc_";"
			s detailRptDesc=detailRptDesc_desc
		}
	
	}
	q detailRptDesc
}

/// Creator：      WZ
/// CreatDate：    2014-11-7
/// Description:： 删除报表
/// Table：       
/// Input：       rptDR:报表DR
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).DelRpt("2")
ClassMethod DelRpt(rptDR As %String) As %String
{
	
	s $zt="ErrorDel"
	s treeCode="root.CRZZBB"
	s OPTLItemDR=""
	s resultFlag=0
	//1、删除报表项
	f {
		s OPTLItemDR=$o(^DHCWL.MRIPDay.RptItemI("RptOPTLIndex",rptDR,OPTLItemDR))
		q:OPTLItemDR=""
		
		s result=..DelRptItem(rptDR,OPTLItemDR,"")
		if result'=0 {
			s resultFlag=1
			q	
		}
	}
	q:resultFlag=1 resultFlag
	//2、删除模块中的报表
	s rptMMgrCode=$lg(^DHCWL.MRIPDay.RptD(rptDR),4)

	s Sql="delete from DHCWL_MKPI.MMgrRptCfg where RptCfg_TreeCode='"_treeCode_"' and RptCfg_Code in ('"_rptMMgrCode_"')"
	s Rs=##class(%Library.ResultSet).%New()
	s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
	s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
	d Rs.Close()


	s Sql="delete from DHCWL_MKPI.MMgrDatasetCfg where DatasetCfg_TreeCode='"_treeCode_"' and DatasetCfg_RptCode in ('"_rptMMgrCode_"')"
	s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
	s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
	d Rs.Close()
	
	s Sql="delete from DHCWL_MKPI.MMgrKPICfg where KPICfg_TreeCode='"_treeCode_"' and KPICfg_RptCode in ('"_rptMMgrCode_"')"
	s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
	s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
	d Rs.Close()


	//3、删除DHCWL.MRIPDay.Rpt中的记录
	s Sql="DELETE FROM DHCWL_MRIPDay.Rpt where Rpt_RowID="_rptDR
	s st=Rs.Prepare(Sql)  if ($$$ISERR(st)) goto ErrorDel
	s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
	d Rs.Close()
	//&sql(delete from DHCWL_MRIPDay.Rpt where Rpt_RowID=:rptDR)
	//if SQLCODE'=0 goto ErrorDel
	q 0
	
ErrorDel
	q 1
}

/// Creator：      	WZ
/// CreatDate：    	2014-11-7
/// Description: 	删除统计项
/// Table：       
/// Input：       	OPTLItemDR:可选统计项DR
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).DelRptItem("2")
ClassMethod DelOPTLItem(OPTLItemDR) As %String
{
	s OPTLItemType=""
	&sql(SELECT OPTLItem_Type into :OPTLItemType FROM DHCWL_MRIPDay.OPTLItem  WHERE OPTLItem_RowID=:OPTLItemDR )
	
	///1、删除统计项
	s Sql="DELETE FROM DHCWL_MRIPDay.OPTLItem  WHERE OPTLItem_RowID="_OPTLItemDR
	s Rs=##class(%Library.ResultSet).%New()
	s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
	s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
	d Rs.Close()
	
	//2、删除指标类统计项
	if OPTLItemType="KPIItem" {
		s Sql="DELETE FROM DHCWL_MRIPDay.KPIItem  WHERE KPIItem_OPTLItemDR="_OPTLItemDR
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()	
	}elseif OPTLItemType="CalItem" {
	//3、删除运算类统计项
		s Sql="DELETE FROM DHCWL_MRIPDay.CalItem  WHERE CalItem_OPTLItemDR="_OPTLItemDR
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()	
	}elseif OPTLItemType="CustomItem" {
	//4、删除自定义类统计项
		s Sql="DELETE FROM DHCWL_MRIPDay.CustomItem  WHERE CustomItem_OPTLItemDR="_OPTLItemDR
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()
	}
	q 0
}

/// Creator：      WZ
/// CreatDate：    2014-11-7
/// Description:： 得到明细报表的描述
/// Table：       
/// Input：      	OPTLDetailItemRowid:明细统计项DR
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService)FindDetailRptDescByDtlID("2")
ClassMethod FindDetailRptDescByDtlID(OPTLDetailItemRowid) As %String
{
		s Sql="SELECT detailRpt_rptDR->Rpt_desc || "_"':'"_" || detailRpt_desc AS rptDesc , DetailRpt_OPTLDetailItems from dhcwl_mripday.detailrpt"
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		s ret=""
		While(Rs.Next()){

	
			s IDs=Rs.Data("DetailRpt_OPTLDetailItems")
			s IDCnt=$l(IDs,",")
			f i=1:1:IDCnt {
				s ID=$p(IDs,",",i)
				q:$G(ID)=""
				if ID=OPTLDetailItemRowid {
					if ret'="" s ret=ret_","
					s rptDesc=Rs.Data("rptDesc")
					s ret=ret_rptDesc
				}
			}
		}		
		d Rs.Close()
		
		q ret
}

/// Creator：      WZ
/// CreatDate：    2014-11-7
/// Description:： 删除明细统计项
/// Table：       
/// Input：       OPTLDetailItemRowid:明细报表项的ID
/// Output：      
/// Return：      
/// Others：d ##class(DHCWL.MRIPDay.MripDayService).DelRptItem("2")
ClassMethod DelDtlRpt(OPTLDetailItemRowid)
{
		s Sql="DELETE FROM dhcwl_mripday.OPTLDetailItem WHERE OPTLDetailItem_RowID="_OPTLDetailItemRowid
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()
		

		s Sql="DELETE FROM DHCWL_MRIPDay.KPIDetailItem WHERE KPIDetailItem_OPTLDetailItemDR="_OPTLDetailItemRowid
		s Rs=##class(%Library.ResultSet).%New()
		s st=Rs.Prepare(Sql) if ($$$ISERR(st)) goto ErrorDel
		s st=Rs.Execute() if ($$$ISERR(st)) goto ErrorDel
		d Rs.Close()

		q 0
}

/// Creator：      chenyi
/// CreatDate：    2014-11-14
/// Description:： 根据新的维度、维度属性，更新数据集中的取数规则  成功返回0
/// Table：       
/// Input：        parentModuleCode:模块与报表根目录,RptCode：报表code,RptType：维度（报表类型code）,RptDimProCode：维度属性
/// Output：      
/// Return：      
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).UpdateRulelist("2")
ClassMethod UpdateRulelist(parentModuleCode, RptCode, RptType, RptDimProCode)
{
		n (parentModuleCode,RptCode,RptType,RptDimProCode)
		s ret=0   ;更新失败置为1
		s ^cy("2016-03-07_start")=parentModuleCode_"^"_RptCode_"^"_RptType_"^"_RptDimProCode
		f ds="ds1","ds2","ds3" d
		.s datasetRowID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",parentModuleCode,RptCode,ds,0))
		.q:$g(datasetRowID)=""
		.s ruleListOld="",ruleListNew=""
		.s ruleListOld=$li(^DHCWL.MKPI.MMgrDataSetCfgD(datasetRowID),5)
		.q:ruleListOld=""
		.f i=1:1:$l(ruleListOld,",") d
		..s itemInfo=$p(ruleListOld,",",i)
		..s kpiCode=$p(itemInfo,":",1)
		..i ruleListNew="" s ruleListNew=kpiCode
		..e  s ruleListNew=ruleListNew_","_kpiCode
		..i $g(RptDimProCode)="" s ruleListNew=ruleListNew_":"_RptType
		..e  d
		...s ruleStr=""
		...f j=1:1:$l(RptDimProCode,";") d
		....i ruleStr="" s ruleStr=RptType_"."_$p(RptDimProCode,";",j)
		....e  s ruleStr=ruleStr_"%"_RptType_"."_$p(RptDimProCode,";",j)
		...s ruleListNew=ruleListNew_":"_ruleStr
		.&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_RuleList=:ruleListNew where DatasetCfg_RowID=:datasetRowID)
		.i SQLCODE'=0 S ret=1,^cy("2016-03-07")=ruleListNew_"^"_datasetRowID
		q ret
}

/// Creator：      wangzheng 
/// CreatDate：    2014-12-11
/// Description:： 创建默认统计项及明细统计项数据。在实施过程中调用。
/// Table：       
/// Input：        rebuild：本次导入的默认统计项及明细统计项的编码在系统中已存在，本次执行时，是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildDefMripdayData(0)
ClassMethod BuildDefMripdayData(rebuild = 0)
{
	n (rebuild)
	s $zt="ErrorReturn2"
	k ^DHCWLMKPIMripdayConf
	//1.判断是否已存在报表项
	//如果系统已存在报表项或数据集的取数规则不为空，那么创建默认统计项及明细统计项数据
	//时，会影响已建立的报表。所以，在创建默认统计项及明细统计项数据时，不允许有报表项
	s ret=..IsExistRptItem()
	i ret=1 {
		w !,"delete all report Items and try again!"
		q	
	}
	//2.配置global
	d ..ConfigGbl() 
	//3.重建索引
	d ..rebuildInx()
	tstart
	//4、建立默认明细统计项
 	s ret=..BuildOPTLDetailItem(rebuild) i ret=1 goto ErrorReturn2
 	//5、建立默认明细统计项（KPI类型）
	s ret=..BuildKPIDetailItem(rebuild) i ret=1 goto ErrorReturn2
	//6、建立默认统计项
	s ret=..BuildOPTLItem(rebuild) i ret=1 goto ErrorReturn2
	//7、建立默认统计项（指标类）
	s ret=..BuildKPIItem(rebuild) i ret=1 goto ErrorReturn2
	//8、建立默认统计项（计算类）
	s ret=..BuildCalItem(rebuild) i ret=1 goto ErrorReturn2
	//9、建立默认统计项（自定义类）
	s ret=..BuildCustomItem(rebuild) i ret=1 goto ErrorReturn2
	tcommit
	q
ErrorReturn2
	trollback
	q
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 判断是否已存在报表项或数据集中是否存在取数规则
/// 					如果系统已存在报表项或数据集的取数规则不为空，那么创建默认统计项及明细统计项数据
/// 					时，会影响已建立的报表。所以，在创建默认统计项及明细统计项数据时，不允许有报表项
/// Table：       
/// Input：        
/// 				           
/// 							
/// Output：      
/// Return：      	ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).IsExistRptItem
ClassMethod IsExistRptItem() As %Integer
{
	n

	s ret=0
	
	//1.判断报表项是否存在
	S rptItemID=$o(^DHCWL.MRIPDay.RptItemD(""))
	if rptItemID'="" {
		s ret=1
		q ret
	}
	//2.判断数据集中是否存在取数规则
	s dsTreeCode="root.CRZZBB"
	s dsRptCode=""
	f {
		s dsRptCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",dsTreeCode,dsRptCode))
		q:dsRptCode=""
		s dsCode=""
		f {
			s dsCode=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",dsTreeCode,dsRptCode,dsCode))
			q:dsCode=""
			s dsID=""
			f {
				s dsID=$o(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",dsTreeCode,dsRptCode,dsCode,dsID))
				q:dsID=""
				s dsData=^DHCWL.MKPI.MMgrDataSetCfgD(dsID)
				s ruleStr=$lg(dsData,5)
				if ruleStr'="" {
					s ret=1	
					q
				}

			}
			q:ret=1
		}
		q:ret=1	
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 重建出入转相关表的索引
/// 					
/// 					
/// Table：       
/// Input：        
/// 				           
/// 							
/// Output：      
/// Return：      
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).rebuildInx()
ClassMethod rebuildInx()
{

	k ^DHCWL.MRIPDay.KPIDetailItemI
	d ##class(DHCWL.MRIPDay.KPIDetailItem).%BuildIndices()
	
	k ^DHCWL.MRIPDay.RptI
	d ##class(DHCWL.MRIPDay.Rpt).%BuildIndices()
	
	k ^DHCWL.MRIPDay.RptItemI
	d ##class(DHCWL.MRIPDay.RptItem).%BuildIndices()

	k ^DHCWL.MRIPDay.OPTLItemI
	d ##class(DHCWL.MRIPDay.OPTLItem).%BuildIndices()

	k ^DHCWL.MRIPDay.OPTLDetailItemI
	d ##class(DHCWL.MRIPDay.OPTLDetailItem).%BuildIndices()

	k ^DHCWL.MRIPDay.KPIItemI
	d ##class(DHCWL.MRIPDay.KPIItem).%BuildIndices()

	k ^DHCWL.MRIPDay.KPIDetailItemI
	d ##class(DHCWL.MRIPDay.KPIDetailItem).%BuildIndices()

	k ^DHCWL.MRIPDay.DetailRptI
	d ##class(DHCWL.MRIPDay.DetailRpt).%BuildIndices()

	k ^DHCWL.MRIPDay.CustomItemI
	d ##class(DHCWL.MRIPDay.CustomItem).%BuildIndices()

	k ^DHCWL.MRIPDay.CustomDetailItemI
	d ##class(DHCWL.MRIPDay.CustomDetailItem).%BuildIndices()

	k ^DHCWL.MRIPDay.CalItemI
	d ##class(DHCWL.MRIPDay.CalItem).%BuildIndices()
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认自定义类统计项
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildCustomItem()
ClassMethod BuildCustomItem(rebuild) As %Integer
{
	n (rebuild)
	s ret=0
	s customItemInx=0

	f {
		//1.从global：^DHCWLMKPIMripdayConf中取出数据
		s customItemInx=$o(^DHCWLMKPIMripdayConf("CustomItem",customItemInx))
		q:customItemInx=""
		s cfgdata=^DHCWLMKPIMripdayConf("CustomItem",customItemInx)
		s OPTLItemCode=$lg(cfgdata,1)
		s OPTLItemDR=$o(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",OPTLItemCode,""))
		s itemType=$lg(cfgdata,2)
		s customFun=$lg(cfgdata,3)
		//2.判断要建立的数据是否已存在
		i $d(^DHCWL.MRIPDay.CustomItemI("CustomItemOPTLItemDRTypeIndex",OPTLItemDR,itemType)) {
			//2.1如果要建立的数据已存在并且需要重建，那么把global的数据更新到系统中
			if rebuild=1 {
				&sql(update DHCWL_MRIPDay.CustomItem set CustomItem_CustomFun=:customFun where CustomItem_OPTLItemDR=:OPTLItemDR and CustomItem_ItemType=:itemType )
				i +$g(SQLCODE)'=0 {
					s ret=1
					q
				}
				
			}else{
			//2.2如果要建立的数据已存在并且不需要重建，那么跳过
				continue
			}
		}else{
			//2.3如果要建立的数据不存在，则直接插入数据
			&sql(insert into DHCWL_MRIPDay.CustomItem (CustomItem_OPTLItemDR,CustomItem_ItemType,CustomItem_CustomFun) 
			values (:OPTLItemDR,:itemType,:customFun))
			i +$g(SQLCODE)'=0 {
				s ret=1
				q
			}
		}
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认计算类统计项
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// 				           
/// 							
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildCalItem()
ClassMethod BuildCalItem(rebuild) As %Integer
{
	//程序的结构同BuildCustomItem一样，请大家移步查看
	n (rebuild)
	s ret=0
	s calItemInx=0
	f {
		s calItemInx=$o(^DHCWLMKPIMripdayConf("CalItem",calItemInx))
		q:calItemInx=""
		s cfgdata=^DHCWLMKPIMripdayConf("CalItem",calItemInx)
		s OPTLItemCode=$lg(cfgdata,1)
		s OPTLItemDR=$o(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",OPTLItemCode,""))
		s calExp=$lg(cfgdata,2)
		
		i $d(^DHCWL.MRIPDay.CalItemI("CalItemOPTLItemDRIndex",OPTLItemDR)) {
			if rebuild=1 {
				&sql(update DHCWL_MRIPDay.CalItem set CalItem_CalExp=:calExp where CalItem_OPTLItemDR=:OPTLItemDR)
				i +$g(SQLCODE)'=0 {
					s ret=1
					q	
				}	
			}else{
				continue
			}
			
		}else{
			&sql(insert into DHCWL_MRIPDay.CalItem (CalItem_OPTLItemDR,CalItem_CalExp) 
			values (:OPTLItemDR,:calExp))
			i +$g(SQLCODE)'=0 {
				s ret=1
				q	
			}	
			
		}
	}
	
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认指标类统计项
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildKPIItem()
ClassMethod BuildKPIItem(rebuild) As %Integer
{
	//程序的结构同BuildCustomItem一样，请大家移步查看
	n (rebuild)
	s ret=0
	s KPIItemInx=0
	f {
		s KPIItemInx=$o(^DHCWLMKPIMripdayConf("KPIItem",KPIItemInx))
		q:KPIItemInx=""
		s cfgdata=^DHCWLMKPIMripdayConf("KPIItem",KPIItemInx)
		s OPTLItemCode=$lg(cfgdata,1)
		s OPTLItemDR=$o(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",OPTLItemCode,""))
		s KPICode=$lg(cfgdata,2)
		s KPIDR=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(KPICode,"DHCWL.MKPI.MKPI") 
		s itemType=$lg(cfgdata,3)
		s dimCode=$lg(cfgdata,4)
		s dtlType=$lg(cfgdata,5)
		s dateSec=$lg(cfgdata,6)
		
		i $d(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemTypeIndex",OPTLItemDR,itemType)) {
			if rebuild=1 {
				&sql(update DHCWL_MRIPDay.KPIItem set KPIItem_KPIDR=:KPIDR,KPIItem_KPICode=:KPICode,
				KPIItem_ItemType=:itemType,KPIItem_DimCode=:dimCode,KPIItem_DetailType=:dtlType,KPIItem_DateSec=:dateSec 
				where KPIItem_OPTLItemDR=:OPTLItemDR and KPIItem_ItemType=:itemType)
				if +$g(SQLCODE)'=0 {
					s ret=1
					q
				}
					
			}else{
				continue	
			}
			
		}else{
			&sql(insert into DHCWL_MRIPDay.KPIItem (KPIItem_OPTLItemDR,KPIItem_KPIDR,KPIItem_KPICode,
			KPIItem_ItemType,KPIItem_DimCode,KPIItem_DetailType,KPIItem_DateSec) 
			values (:OPTLItemDR,:KPIDR,:KPICode,:itemType,:dimCode,:dtlType,:dateSec))
			if +$g(SQLCODE)'=0 {
				s ret=1
				q	
				
			}
		}
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认统计项
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildOPTLItem()
ClassMethod BuildOPTLItem(rebuild) As %Integer
{
	//程序的结构同BuildCustomItem一样，请大家移步查看
	n (rebuild)
	s ret=0
	s OPTLItemCode=""
	f {
		s OPTLItemCode=$o(^DHCWLMKPIMripdayConf("OPTLItem",OPTLItemCode))
		q:$g(OPTLItemCode)=""
		
		s cfgdata=^DHCWLMKPIMripdayConf("OPTLItem",OPTLItemCode)
		s desc=$lg(cfgdata,1)
		s type=$lg(cfgdata,2)
		
		if $d(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",OPTLItemCode)) {
			
			if rebuild=1 {
				&sql(update DHCWL_MRIPDay.OPTLItem set OPTLItem_Desc=:desc,OPTLItem_Type=:type where OPTLItem_Code=:OPTLItemCode)
				if +$g(SQLCODE)'=0 {
					s ret=1
					q	
				}
			}else{
				continue	
			}
			
			
		}else{
			&sql(insert into DHCWL_MRIPDay.OPTLItem (OPTLItem_Code,OPTLItem_Desc,OPTLItem_Type)
			 values (:OPTLItemCode,:desc,:type))
			if +$g(SQLCODE)'=0 {
				s ret=1
				q	
			}
		}
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认明细统计项（指标类）
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildKPIDetailItem()
ClassMethod BuildKPIDetailItem(rebuild) As %Integer
{
	//程序的结构同BuildCustomItem一样，请大家移步查看
	n (rebuild)
	s ret=0

	//判读维度属性是否存在
	s code="MRIPDetail"
	s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(code,"DHCWL.MKPI.MKPIDimType") 
	q:id="" 1	
	
	s dimProCode=""
	f {
		s dimProCode=$o(^DHCWLMKPIMripdayConf("KPIDetailItem",dimProCode)) 
		q:dimProCode=""
		//s dimProCode="MRIPDetail"_"||"_dimProCode
		s cfgdata=^DHCWLMKPIMripdayConf("KPIDetailItem",dimProCode)
		s OPTLDetailItemCode=$lg(cfgdata,1)
		
		s OPTLDetailItemDR=$o(^DHCWL.MRIPDay.OPTLDetailItemI("OPTLDetailItemCodeIndex",OPTLDetailItemCode,""))
		continue:$g(OPTLDetailItemDR)=""
		
		s dimProID=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode("MRIPDetail"_"||"_dimProCode,"DHCWL.MKPI.DimProperty") 

		if $g(dimProID)="" {
			&sql(delete from DHCWL_MRIPDay.OPTLDetailItem where OPTLDetailItem_Code=:OPTLDetailItemCode)
			continue
		}
		
		if $d(^DHCWL.MRIPDay.KPIDetailItemI("KPIDtlItemOPTLDtlItemDRIndex",OPTLDetailItemDR)) {
			if rebuild=1 {
				/*
				&sql(delete from DHCWL_MRIPDay.KPIDetailItem where KPIDetailItem_OPTLDetailItemDR=:OPTLDetailItemDR)
				if ((SQLCODE'=0) && (SQLCODE'=100)) {
					s ret=1
					q
				}
				&sql(insert into DHCWL_MRIPDay.KPIDetailItem 
				(KPIDetailItem_OPTLDetailItemDR,KPIDetailItem_DimProDR,KPIDetailItem_DimProCode) 
				values (:OPTLDetailItemDR,:dimProID,:dimProCode))
				*/
				&sql(update DHCWL_MRIPDay.KPIDetailItem set KPIDetailItem_DimProDR=:dimProID,
				KPIDetailItem_DimProCode=:dimProCode where KPIDetailItem_OPTLDetailItemDR=:OPTLDetailItemDR)
				i +$g(SQLCODE)'=0 {
					s ret=1
					q
				}				
			}else{
				continue
			}
		}else{
			&sql(insert into DHCWL_MRIPDay.KPIDetailItem 
			(KPIDetailItem_OPTLDetailItemDR,KPIDetailItem_DimProDR,KPIDetailItem_DimProCode) 
			values (:OPTLDetailItemDR,:dimProID,:dimProCode))
			i +$g(SQLCODE)'=0 {
				s ret=1
				q
			}
			
		}
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 建立默认明细统计项
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      ret-0:成功；1：失败
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).BuildOPTLDetailItem()
ClassMethod BuildOPTLDetailItem(rebuild) As %Integer
{
	//程序的结构同BuildCustomItem一样，请大家移步查看
	n (rebuild)
	s ret=0
	s code=""
	f {
		s code=$o(^DHCWLMKPIMripdayConf("OPTLDetailItem",code)) 
		q:code=""

		s cfgdata=^DHCWLMKPIMripdayConf("OPTLDetailItem",code)
		s desc=$lg(cfgdata,1)
		s type=$lg(cfgdata,2)
		
		if $d(^DHCWL.MRIPDay.OPTLDetailItemI("OPTLDetailItemCodeIndex",code)) {
			if rebuild=1 {
				&sql(update DHCWL_MRIPDay.OPTLDetailItem set OPTLDetailItem_Desc=:desc ,OPTLDetailItem_Type=:type where OPTLDetailItem_Code=:code)
				i +$g(SQLCODE)'=0 {
					s ret=1
					q
				}
			}else{
				continue
			}	
		}else{
				&sql(insert into DHCWL_MRIPDay.OPTLDetailItem (OPTLDetailItem_Desc,OPTLDetailItem_Type,OPTLDetailItem_Code) values (:desc ,:type,:code))
				i +$g(SQLCODE)'=0 {
					s ret=1
					q
				}
		}
		
	}
	q ret
}

/// Creator：      wangzheng
/// CreatDate：    2014-12-11
/// Description:： 配置建立默认统计项和明细统计项需要的global
/// 					
/// 					
/// Table：       
/// Input：        rebuild：本次导入的默认统计项(或明细统计项)的编码在系统中已存在时，本次执行是否
/// 				            强制更新。
/// 							1:更新；0:不更新
/// Output：      
/// Return：      
/// Others：	   d ##class(DHCWL.MRIPDay.MripDayService).ConfigGbl()
ClassMethod ConfigGbl()
{
	//明细统计项
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","HZXM")= $lb("患者姓名","KPIDetailItem")    
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","CWH") = $lb("床位号","KPIDetailItem")      
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","BFMC") = $lb("病房名称","KPIDetailItem")   
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","DJH") = $lb("登记号","KPIDetailItem")      
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","RYLB") = $lb("人员类别","KPIDetailItem")   
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","XB") = $lb("性别","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","NL") = $lb("年龄","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","TS") = $lb("天数","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","RYRQ") = $lb("入院日期","KPIDetailItem")   
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","RQ") = $lb("日期","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","BZ") = $lb("备注","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","LX") = $lb("类型","KPIDetailItem")         
	s ^DHCWLMKPIMripdayConf("OPTLDetailItem","KSBQ") = $lb("科室、病区","KPIDetailItem") 

	//KPI明细统计项
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P001") = $lb("HZXM") 
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P002") = $lb("CWH")
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P003") = $lb("BFMC") 
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P004") = $lb("DJH")
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P005") = $lb("RYLB") 
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P006") = $lb("XB")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P007") = $lb("NL")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P008") = $lb("TS")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P010") = $lb("RYRQ") 
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P011") = $lb("RQ")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P012") = $lb("BZ")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P013") = $lb("LX")  
	s ^DHCWLMKPIMripdayConf("KPIDetailItem","P009") = $lb("KSBQ") 
	
	//统计项
	s ^DHCWLMKPIMripdayConf("OPTLItem","CYRS")=$lb("出院人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","SJZYZCR")=$lb("实际占用总床日","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","SJKFZCR")=$lb("实际开放总床日","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","ZCRS")=$lb("转出人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","ZRRS")=$lb("转入人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","XYRS")=$lb("现有人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","RYRS")=$lb("入院人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","TYRS")=$lb("退院人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","YYRS")=$lb("原有人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","SWRS2")=$lb("死亡人数2","CustomItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","SWRS")=$lb("死亡人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","CYZZYZCRS")=$lb("出院者占用总床日数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","PJKFCS")=$lb("平均开放床数","CalItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","TJSD")=$lb("统计时间段","CustomItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","BCZZCS")=$lb("病床周转次数","CalItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","PJZYR")=$lb("平均住院日","CalItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","SYCW")=$lb("实有床位","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","BWRC")=$lb("病危人次","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","BZRC")=$lb("病重人次","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","YRBRRC")=$lb("一日病人人次","KPIItem")	
	s ^DHCWLMKPIMripdayConf("OPTLItem","BEDRS")=$lb("在床人数","KPIItem")	
	s ^DHCWLMKPIMripdayConf("OPTLItem","ZYZCBD")=$lb("在院在床比对","CalItem")
	//add by chenyi.2016-03-23 The next 8 rows
	s ^DHCWLMKPIMripdayConf("OPTLItem","HLRS1")=$lb("一级护理人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","HLRS2")=$lb("二级护理人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","HLRS3")=$lb("三级护理人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","HLRS3")=$lb("三级护理人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","TJHLRS")=$lb("特级护理人数","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","DQJ")=$lb("大抢救","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","ZQJ")=$lb("中抢救","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","XQJ")=$lb("小抢救","KPIItem")
	s ^DHCWLMKPIMripdayConf("OPTLItem","BCSYL")=$lb("病床使用率","CalItem")
	
		//KPI统计项
	s ^DHCWLMKPIMripdayConf("KPIItem",6)=$lb("CYRS","K0008","CTLOC","CTLOC","CYRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",7)=$lb("CYRS","K0027","WARD","WARD","CYRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",8)=$lb("ZRRS","K0006","CTLOC","CTLOC","ZRKS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",9)=$lb("ZRRS","K0025","WARD","WARD","ZRKS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",10)=$lb("ZCRS","K0007","CTLOC","CTLOC","ZCKS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",11)=$lb("ZCRS","K0026","WARD","WARD","ZCKS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",15)=$lb("YYRS","K0004","CTLOC","CTLOC","OTHER","begin")
	s ^DHCWLMKPIMripdayConf("KPIItem",17)=$lb("TYRS","K0009","CTLOC","CTLOC","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",18)=$lb("TYRS","K0028","WARD","WARD","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",22)=$lb("SJZYZCR","K0010","CTLOC","CTLOC","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",23)=$lb("SJZYZCR","K0029","WARD","WARD","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",25)=$lb("SJKFZCR","K0021","WARD","WARD","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",26)=$lb("YYRS","K0023","WARD","WARD","OTHER","begin")
	s ^DHCWLMKPIMripdayConf("KPIItem",27)=$lb("XYRS","K0010","CTLOC","CTLOC","ZYRS","end")
	s ^DHCWLMKPIMripdayConf("KPIItem",28)=$lb("XYRS","K0029","WARD","WARD","ZYRS","end")
	s ^DHCWLMKPIMripdayConf("KPIItem",29)=$lb("RYRS","K0005","CTLOC","CTLOC","RYRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",30)=$lb("RYRS","K0024","WARD","WARD","RYRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",34)=$lb("SWRS","K0011","CTLOC","CTLOC","SWRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",35)=$lb("SWRS","K0030","WARD","WARD","SWRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",38)=$lb("SJKFZCR","K0002","CTLOC","CTLOC","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",41)=$lb("CYZZYZCRS","K0012","CTLOC","CTLOC","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",42)=$lb("CYZZYZCRS","K0031","WARD","WARD","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",43)=$lb("SYCW","K0002","CTLOC","CTLOC","OTHER","end")
	s ^DHCWLMKPIMripdayConf("KPIItem",44)=$lb("SYCW","K0021","WARD","WARD","OTHER","end")
	s ^DHCWLMKPIMripdayConf("KPIItem",45)=$lb("BWRC","K0773","CTLOC","CTLOC","BWRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",46)=$lb("BWRC","K0774","WARD","WARD","BWRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",47)=$lb("BZRC","K0775","CTLOC","CTLOC","BZRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",48)=$lb("BZRC","K0776","WARD","WARD","BZRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",49)=$lb("YRBRRC","K0777","CTLOC","CTLOC","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",50)=$lb("YRBRRC","K0778","WARD","WARD","OTHER","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",51)=$lb("BEDRS","K0737","WARD","WARD","BEDRS","end")
	s ^DHCWLMKPIMripdayConf("KPIItem",52)=$lb("BEDRS","K0736","CTLOC","CTLOC","BEDRS","end")
	//add by chenyi.2016-03-23 The next 14 rows
	s ^DHCWLMKPIMripdayConf("KPIItem",53)=$lb("HLRS1","K0824","WARD","WARD","HLRS1","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",54)=$lb("HLRS1","K0825","CTLOC","CTLOC","HLRS1","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",55)=$lb("HLRS2","K0826","WARD","WARD","HLRS2","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",56)=$lb("HLRS2","K0827","CTLOC","CTLOC","HLRS2","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",57)=$lb("HLRS3","K0828","WARD","WARD","HLRS3","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",58)=$lb("HLRS3","K0829","CTLOC","CTLOC","HLRS3","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",59)=$lb("TJHLRS","K0830","WARD","WARD","TJHLRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",60)=$lb("TJHLRS","K0831","CTLOC","CTLOC","TJHLRS","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",61)=$lb("DQJ","K0832","WARD","WARD","DQJ","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",62)=$lb("DQJ","K0833","CTLOC","CTLOC","DQJ","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",63)=$lb("ZQJ","K0834","WARD","WARD","ZQJ","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",64)=$lb("ZQJ","K0835","CTLOC","CTLOC","ZQJ","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",65)=$lb("XQJ","K0836","WARD","WARD","XQJ","all")
	s ^DHCWLMKPIMripdayConf("KPIItem",66)=$lb("XQJ","K0837","CTLOC","CTLOC","XQJ","all")
	
	//计算类统计项
	s ^DHCWLMKPIMripdayConf("CalItem",12)=$lb("PJKFCS","<SJKFZCR>/<TJSD>")             
	s ^DHCWLMKPIMripdayConf("CalItem",14)=$lb("BCZZCS","<CYRS>/(<SJKFZCR>/<TJSD>)")    
	s ^DHCWLMKPIMripdayConf("CalItem",15)=$lb("PJZYR","<CYZZYZCRS>/<CYRS>")  
	s ^DHCWLMKPIMripdayConf("CalItem",16)=$lb("ZYZCBD","<XYRS>-<BEDRS>") 
	//add by chenyi.2016-03-23 The next 1 rows
	s ^DHCWLMKPIMripdayConf("CalItem",17)=$lb("BCSYL","<XYRS>/<SJKFZCR>*100")  
	
	
	//自定义类统计项
	s ^DHCWLMKPIMripdayConf("CustomItem",8)=$lb("SWRS2","CTLOC","GetDeceasedKS^DHCWLBuildCRZData")        
	s ^DHCWLMKPIMripdayConf("CustomItem",9)=$lb("SWRS2","WARD","GetDeceasedBQ^DHCWLBuildCRZData")         
	s ^DHCWLMKPIMripdayConf("CustomItem",10)=$lb("TJSD","CTLOC","GetStatTimePeriodKS^DHCWLBuildCRZData")  
	s ^DHCWLMKPIMripdayConf("CustomItem",12)=$lb("TJSD","WARD","GetStatTimePeriodBQ^DHCWLBuildCRZData")
}

}
