/// Creator    :     wk
/// CreatDate  :     2018-08-23
/// Description:	 出入转报表列维护
Class web.DHCWL.V1.MRIPDay.MRIPDayItemFun Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-08-27
/// Desc      : 获取报表列信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayItemFun","GetRptItem")
Query GetRptItem(filterValue As %String = "", sign As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,type:%String:类型") [ SqlProc ]
{
}

ClassMethod GetRptItemExecute(ByRef qHandle As %Binary, filterValue As %String = "", sign As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$zcvt(filterValue,"U") 
	set sql="select OPTLItem_RowID,OPTLItem_Code,OPTLItem_Desc,OPTLItem_Type from DHCWL_MRIPDay.OPTLItem"			;统计项界面		
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s rowid=rs.Data("OPTLItem_RowID")
		s code=rs.Data("OPTLItem_Code")
		s desc=rs.Data("OPTLItem_Desc")
		s type=rs.Data("OPTLItem_Type")
		continue:((sign="noCal")&&(type="CalItem"))
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(type,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(rowid,code,desc,type)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-28
/// Desc      : 获取指标
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayItemFun","SelectKpis")
Query SelectKpis(kpiCode As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,kpiCode:%String:指标编码,kpiName:%String:指标名称,category:%String:指标类型,dimCode:%String:维度编码,kpiDimCode:%String:报表类型,section:%String:区间") [ SqlProc ]
{
}

ClassMethod SelectKpisExecute(ByRef qHandle As %Binary, kpiCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    
	set array("MKPIDr")=##class(DHCWL.MRIPDay.MripDayService).GetKPIIdStrByCode(kpiCode)  

	s kpiIds=##class(DHCWL.MRIPDay.MripDayService).GetKPIIdStrByCodeWithLike(kpiCode)
	i (($g(kpiIds)="") && (kpiCode'="")) s kpiIds=-1
    
    q:(kpiIds=-1) $$$OK   	;没有对应的kpiID时，直接返回0
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
	..s ^CacheTemp(repid,ind)=$lb(arrs(num,"ID"),arrs(num,"kpiCode"),arrs(num,"kpiName"),arrs(num,"category"),arrs(num,"dimCode"),arrs(num,"kpiDimCode"),arrs(num,"section"))
	..s ind=ind+1
	..s num=num+1
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 获取已经配置的指标类指标
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayItemFun","SearchKPIItem")
Query SearchKPIItem(OPTLItemDR As %String) As websys.Query(ROWSPEC = "ID:%String:ID,rptColID:%String:统计项ID,kpiID:%String:指标ID,kpiCode:%String:指标编码,dimCode:%String:维度编码,type:%String:类型,mripdayType:%String:出入转类别,section:%String:区间") [ SqlProc ]
{
}

ClassMethod SearchKPIItemExecute(ByRef qHandle As %Binary, OPTLItemDR As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1

	Q:OPTLItemDR="" $$$OK
	set sql="select KPIItem_RowID,KPIItem_OPTLItemDR,KPIItem_KPIDR,KPIItem_KPICode,KPIItem_ItemType,KPIItem_DimCode,KPIItem_DetailType,KPIItem_DateSec from DHCWL_MRIPDay.KPIItem where KPIItem_OPTLItemDR='"_OPTLItemDR_"'"

	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()

	While(rs.Next()){

		s rowid=rs.Data("KPIItem_RowID")
		s OPTLItemDR=rs.Data("KPIItem_OPTLItemDR")
		s KPIDR=rs.Data("KPIItem_KPIDR")
		s KPICode=rs.Data("KPIItem_KPICode")
		
		s ItemType=rs.Data("KPIItem_ItemType")
		s DimCode=rs.Data("KPIItem_DimCode")
		s DetailType=rs.Data("KPIItem_DetailType")
		s DateSec=rs.Data("KPIItem_DateSec")
		s ^CacheTemp(repid,ind)=$lb(rowid,OPTLItemDR,KPIDR,KPICode,DimCode,ItemType,DetailType,DateSec)
		s ind=ind+1
	}

	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 获取自定义报表列信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayItemFun","GetCustomItem")
Query GetCustomItem(OPTLItemDR) As websys.Query(ROWSPEC = "ID:%String:ID,rptColID:%String:统计项ID,type:%String:类型,exeCode:%String:执行代码") [ SqlProc ]
{
}

ClassMethod GetCustomItemExecute(ByRef qHandle As %Binary, OPTLItemDR) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
	
	Q:OPTLItemDR="" $$$OK
	set sql="select CustomItem_RowID,CustomItem_OPTLItemDR,CustomItem_ItemType,CustomItem_CustomFun from DHCWL_MRIPDay.CustomItem where CustomItem_OPTLItemDR='"_OPTLItemDR_"'"


	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()

	While(rs.Next()){

		s rowid=rs.Data("CustomItem_RowID")
		s OPTLItemDR=rs.Data("CustomItem_OPTLItemDR")
		s itemType=rs.Data("CustomItem_ItemType")
		s customFun=rs.Data("CustomItem_CustomFun")
		s ^CacheTemp(repid,ind)=$lb(rowid,OPTLItemDR,itemType,customFun)
		s ind=ind+1
	}

	d rs.Close()
    
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 新增指标类型报表配置信息
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).AddKpiItem()
ClassMethod AddKpiItem(optItemID, kpiID, kpiCode, itemtype, dimCode, detailType, section)
{
	s OPTLItemDR=optItemID
	s KPIDR=kpiID
	s KPICode=kpiCode
	s itemType=itemtype
	s dimCode=dimCode
	s detailType=detailType
	s dateSec=section
	if ($d(^DHCWL.MRIPDay.KPIItemI("KPIItemOPTLItemTypeIndex",optItemID,$ZCVT(itemType,"U")))){
		q "该类型统计项已存在，不能重复配置！"
	}
	&sql(insert into DHCWL_MRIPDay.KPIItem (KPIItem_OPTLItemDR,KPIItem_KPIDR,KPIItem_KPICode,KPIItem_ItemType,KPIItem_DimCode,KPIItem_DetailType,KPIItem_DateSec) values (:OPTLItemDR,:KPIDR,:KPICode,:itemType,:dimCode,:detailType,:dateSec))
	i +$g(SQLCODE)=0 q "新增成功"
	e  q "操作失败！"_SQLCODE
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 删除指标类型报表列配置信息
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).DelKPIItem()
ClassMethod DelKPIItem(OPTLItemDR, itemType, rowID)
{
	q:((OPTLItemDR="")||(itemType="")||(rowID="")) "获取删除信息失败,请重新尝试"
	s rptName=""
	//1、查询要删除的指标统计项是否被报表所使用。
	s sql="SELECT Rpt_Desc FROM DHCWL_MRIPDay.Rpt WHERE Rpt_type='"_itemType_"'  AND Rpt_RowID IN (SELECT RptItem_RptDR FROM DHCWL_MRIPDay.RptItem WHERE RptItem_OPTLItemDR='"_OPTLItemDR_"')"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s rptDesc=rs.Data("Rpt_Desc")
		if rptName'="" s rptName=rptName_","
		s rptName=rptName_rptDesc
	}
	d rs.Close()
	//2、要删除的指标统计项被报表所使用就退出
	if rptName'="" {
		 //q rptName
		 q "该报表列被报表："_rptName_" 使用，请先删除该报表！"
	}
	else {
		//3、删除指标统计项
		s rowID=rowID
		&sql(delete from DHCWL_MRIPDay.KPIItem WHERE KPIItem_RowID=:rowID)
		i +$g(SQLCODE)=0 q "删除成功"
		e  q "删除失败"_SQLCODE			
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 新增自定义类型报表列配置
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).AddCustomItem()
ClassMethod AddCustomItem(rptItemDR, DIYFun, type)
{
	s OPTLItemDR=rptItemDR
	s customFun=DIYFun
	s itemType=type
	if ($d(^DHCWL.MRIPDay.CustomItemI("CustomItemOPTLItemDRTypeIndex",OPTLItemDR,$ZCVT(itemType,"U")))){
		q "该类型统计项已存在，不能重复配置！"
	}
	&sql(insert into DHCWL_MRIPDay.CustomItem (CustomItem_OPTLItemDR,CustomItem_ItemType,CustomItem_CustomFun) 
	values (:OPTLItemDR,:itemType,:customFun))
	i +$g(SQLCODE)=0 q "新增成功"
	e  q "新增失败"_SQLCODE
}

/// Creator   : wk
/// CreatDate : 2018-08-29
/// Desc      : 删除自定义类型报表列配置
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).DelCustomItem()
ClassMethod DelCustomItem(OPTLItemDR, itemType, rowID)
{
	q:((OPTLItemDR="")||(itemType="")||(rowID="")) "获取删除信息失败,请重新尝试"
	s rptName=""

	//1、查询要删除的自定义统计项是否被报表所使用。
	s sql="SELECT Rpt_Desc FROM DHCWL_MRIPDay.Rpt WHERE Rpt_type='"_itemType_"'  AND Rpt_RowID IN (SELECT RptItem_RptDR FROM DHCWL_MRIPDay.RptItem WHERE RptItem_OPTLItemDR='"_OPTLItemDR_"')"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s rptDesc=rs.Data("Rpt_Desc")
		if rptName'="" s rptName=rptName_","
		s rptName=rptName_rptDesc
	}
	d rs.Close()
	
	//2、要删除的自定义统计项被报表所使用就退出
	if rptName'="" {
		 //w "{success:true,tip:'ok',rptName:'"_rptName_"'}"
		 //q rptName
		 q "该报表列被报表："_rptName_" 使用，请先删除该报表！"
	}
	else {
		//3、删除自定义统计项
		&sql(delete from DHCWL_MRIPDay.CustomItem WHERE CustomItem_RowID=:rowID)
		i +$g(SQLCODE)=0 q "删除成功"
		e  q "删除失败"_SQLCODE			
	}
}

/// Creator    : wk
/// CreatDate  : 2018-08-29
/// Desc       : 获取计算类报表列配置规则
/// Other      : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).SearchCalItem()
ClassMethod SearchCalItem(rptColID)
{
	s OPTLItemDR=rptColID
	set sql="select CalItem_RowID,CalItem_CalExp from DHCWL_MRIPDay.CalItem where CalItem_OPTLItemDR='"_OPTLItemDR_"'"
	s CalRowID=""
	s CalExp=""

	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s CalRowID=rs.Data("CalItem_RowID")
		s CalExp=rs.Data("CalItem_CalExp")
	}
	d rs.Close()
	q CalRowID_":"_CalExp
	//w "{success:true,tip:'ok',CalRowID:'"_CalRowID_"',CalExp:'"_CalExp_"'}"
}

/// Creator    : wk
/// CreatDate  : 2018-08-29
/// Desc       : 获取计算类报表列配置规则
/// Other      : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).AddCalItem()
ClassMethod AddCalItem(rptColID, exeCode, rowID)
{
	s OPTLItemDR=rptColID
	s calExp=exeCode
	s CalRowID=rowID
	s rptName=""
	//1、查询要删除的计算类统计项是否被报表所使用。
	s sql="SELECT Rpt_Desc FROM DHCWL_MRIPDay.Rpt WHERE Rpt_RowID IN (SELECT RptItem_RptDR FROM DHCWL_MRIPDay.RptItem WHERE RptItem_OPTLItemDR='"_OPTLItemDR_"')"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s rptDesc=rs.Data("Rpt_Desc")
		if rptName'="" s rptName=rptName_","
		s rptName=rptName_rptDesc
	}
	d rs.Close()
	//2、要删除的计算类统计项被报表所使用就退出
	if rptName'="" {
		 //w "{success:true,tip:'ok',rptName:'"_rptName_"'}"
		 q "下面的报表使用了统计项之前的配置："_rptName_"请先删除这些报表！"
	}
	else {
		if CalRowID="" {	//3、新增
			
			&sql(insert into DHCWL_MRIPDay.CalItem (CalItem_OPTLItemDR,CalItem_CalExp) 
			values (:OPTLItemDR,:calExp))
			i +$g(SQLCODE)=0 q "更新成功"
			e  q "更新失败"_SQLCODE			
		}else{		//4、更新
			&sql(update DHCWL_MRIPDay.CalItem set CalItem_CalExp=:calExp where CalItem_RowID=:CalRowID) 
			i +$g(SQLCODE)=0 q "更新成功"
			e  q "更新失败"_SQLCODE			
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 新增报表列
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).AddCalItem()
ClassMethod AddItem(code, desc, type)
{
	s itemCode=code
	s itemDesc=desc
	s itemType=type
	if ($d(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",$ZCVT(code,"U"))))||($d(^DHCWL.MRIPDay.OPTLItemI("OPTLItemCodeIndex",code))){
		q "编码不能重复"
	}			
	//新增
	&sql(insert into DHCWL_MRIPDay.OPTLItem (OPTLItem_Code,OPTLItem_Desc,OPTLItem_Type) values (:itemCode,:itemDesc,:itemType))
	i +$g(SQLCODE)=0 q "新增成功"
	e  q "操作失败！"_SQLCODE
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 修改报表列
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).ModifyItem()
ClassMethod ModifyItem(ID, desc)
{
	s ID=ID
	s itemDesc=desc			
	//更新
	&sql(update DHCWL_MRIPDay.OPTLItem set OPTLItem_Desc=:itemDesc where OPTLItem_RowID=:ID )
	i +$g(SQLCODE)=0 q "操作成功"
	e  q "操作失败！"_SQLCODE
}

/// Creator   : wk
/// CreatDate : 2018-08-30
/// Desc      : 删除报表列
/// Other     : do ##Class(web.DHCWL.V1.MRIPDay.MRIPDayItemFun).DelItem()
ClassMethod DelItem(rptColID)
{
	Q:rptColID="" "获取报表列失败"
	s OPTLItemDR=rptColID
		
	//1、查找该统计项是否被报表使用
	s sql="SELECT Rpt_Desc FROM DHCWL_MRIPDay.Rpt WHERE Rpt_RowID IN (SELECT RptItem_RptDR FROM DHCWL_MRIPDay.RptItem WHERE RptItem_OPTLItemDR='"_OPTLItemDR_"')"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s rptName=""
	While(rs.Next()){
		s rptDesc=rs.Data("Rpt_Desc")
		if rptName'="" s rptName=rptName_","
		s rptName=rptName_rptDesc
	}
	d rs.Close()
	//2、如果统计项被报表使用，返回这些报表的描述
	if rptName'="" {
		 q "该统计项被报表："_rptName_" 使用，请先删除该报表！"
	}
	else {
	//3、删除统计项
		tstart
		s result=##class(DHCWL.MRIPDay.MripDayService).DelOPTLItem(OPTLItemDR)
		if result=0 {
			tcommit
			q "删除成功"
		}else{
			trollback
			q "操作失败！"_SQLCODE
		}
	}
}

}
