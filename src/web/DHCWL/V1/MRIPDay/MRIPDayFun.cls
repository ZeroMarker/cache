/// Creator    :     wk
/// CreatDate  :     2018-08-23
/// Description:	 出入转相关内容维护
Class web.DHCWL.V1.MRIPDay.MRIPDayFun Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2018-08-09
/// Description:   获取出入转报表信息 
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","GetRptInfor")
Query GetRptInfor(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,rptCode:%String:编码,rptDesc:%String:描述,rptModuleCode:%String:模块报表代码,rptDim:%String:维度,rptDimPro:%String:维度属性") [ SqlProc ]
{
}

ClassMethod GetRptInforExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$zcvt(filterValue,"U")
 	
	s sql="select Rpt_RowID,Rpt_Code,Rpt_Desc,Rpt_MMgrCode,Rpt_Type,Rpt_DimProCodes from DHCWL_MRIPDay.Rpt"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("Rpt_RowID")
		s rptCode=rs.Data("Rpt_Code")
		s rptDesc=rs.Data("Rpt_Desc")
		s mmgrCode=rs.Data("Rpt_MMgrCode")
		s dim=rs.Data("Rpt_Type")
		s dimPro=rs.Data("Rpt_DimProCodes")
		continue:(filterValue'="")&&($zcvt(rptCode,"U")'[filterValue)&&($zcvt(rptDesc,"U")'[filterValue)&&($zcvt(mmgrCode,"U")'[filterValue)&&($zcvt(dim,"U")'[filterValue)&&($zcvt(dimPro,"U")'[filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,rptCode,rptDesc,mmgrCode,dim,dimPro)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2018-08-23
/// Description:   获取报表下报表列信息 
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","GetRptColInfor")
Query GetRptColInfor(rptID As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,colCode:%String:编码,colDesc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetRptColInforExecute(ByRef qHandle As %Binary, rptID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
 	Q:rptID="" $$$OK
	s sql="select OPTLItem_RowID,OPTLItem_Code,OPTLItem_Desc from DHCWL_MRIPDay.OPTLItem t1, DHCWL_MRIPDay.RptItem t2 where t1.OPTLItem_RowID = t2.RptItem_OPTLItemDR  AND t2.RptItem_RptDR="_rptID_"    ORDER BY t2.RptItem_Order"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("OPTLItem_RowID"),rs.Data("OPTLItem_Code"),rs.Data("OPTLItem_Desc"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-23
/// Desc      : 根据维度编码获取维度属性信息
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","GetDimProQuery")
Query GetDimProQuery(dimCode As %String = "") As websys.Query(ROWSPEC = "code:%String:属性编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetDimProQueryExecute(ByRef qHandle As %Binary, dimCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
 	Q:dimCode="" $$$OK
 	s dimID=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$zcvt(dimCode,"U"),""))
 	Q:dimID="" $$$OK
	s sql="SELECT DimPro_Code,DimPro_Name FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_DimDr="_dimID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("DimPro_Code"),rs.Data("DimPro_Name"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-08-24
/// Desc       : 保存报表项内容
/// Other      : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).AddRPT()
ClassMethod AddRPT(rptCode, rptDesc, rptDim, rptDimPro)
{
	//添加或更新报表
	s RptCode=rptCode
	s RptDesc=rptDesc
	s RptType=rptDim
	s RptDimProCode=rptDimPro
	if ($d(^DHCWL.MRIPDay.RptI("RptCodeIndex",RptCode))){
		q "当前编码已存在,请重新填写"
	}
	TSTART
	s parentModuleCode="root.CRZZBB"	//默认的模块与报表的报表编码
	//1.1、在模块与报表中插入报表数据
	&sql(insert into DHCWL_MKPI.MMgrRptCfg (rptCfg_code,rptCfg_desc,RptCfg_TreeCode,RptCfg_Name) values (:RptCode,:RptDesc,:parentModuleCode,:RptDesc))
	if SQLCODE'=0 {
		q "操作失败,"_SQLCODE
		Trollback
	}else {
		//1.2、向报表中插入数据
		&sql(insert into DHCWL_MRIPDay.Rpt (Rpt_Code,Rpt_Desc,Rpt_MMgrCode,Rpt_Type,Rpt_DimProCodes) 
		values (:RptCode,:RptDesc,:RptCode,:RptType,:RptDimProCode))
		i SQLCODE'=0	{
			Trollback
			q "操作失败,"_SQLCODE
		}else {
			i $l(RptDimProCode,";")>3 {
				Trollback
				q "操作失败:维度属性最大不能超过3个！"
			}else{
				TCOMMIT
				q "操作成功"
			}
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-24
/// Desc      : 报表项的修改
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).ModifyRPT()
ClassMethod ModifyRPT(ID, rptCode, rptDesc, rptDim, rptDimPro)
{
	
	//添加或更新报表
	s ID=ID
	s RptCode=rptCode
	s RptDesc=rptDesc
	s RptType=rptDim
	s RptDimProCode=rptDimPro

	TSTART
	s parentModuleCode="root.CRZZBB"
	//2.1、更新模块与报表中的报表的描述
	s sqlFlag=0
	&sql(update DHCWL_MKPI.MMgrRptCfg set rptCfg_desc=:RptDesc,RptCfg_Name=:RptDesc where RptCfg_Code=:RptCode and RptCfg_TreeCode=:parentModuleCode)
	i SQLCODE'=0 s sqlFlag=1
	//2.2、根据新的维度、维度属性，更新数据集中的取数规则  成功返回0
	s flag=##class(DHCWL.MRIPDay.MripDayService).UpdateRulelist(parentModuleCode,RptCode,RptType,RptDimProCode)
	i flag'=0 s sqlFlag=1
	if sqlFlag'=0 {	
		q "操作失败"_SQLCODE
		Trollback
	}else {
		//2.3、更新报表的描述，维度属性
		&sql(update DHCWL_MRIPDay.Rpt set Rpt_Desc=:RptDesc,Rpt_DimProCodes=:RptDimProCode where Rpt_RowID=:ID) 
		i SQLCODE'=0	{
			Trollback
			q "操作失败"_SQLCODE
		}else {
			i $l(RptDimProCode,";")>3 {
				Trollback
				q "操作失败:维度属性最大不能超过3个！"
			}else{
				TCOMMIT
				q "修改成功"
			}
			
		}
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-24
/// Desc      : 报表项的删除
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).DeleteRPT()
ClassMethod DeleteRPT(rptDR)
{
	tstart
	s rptDR=rptDR
	if $d(^DHCWL.MRIPDay.RptItemI("RptOPTLIndex",rptDR)){
		q "请先删除对应的报表列后再进行操作"
	}
	s result=##class(DHCWL.MRIPDay.MripDayService).DelRpt(rptDR)
	if result=0 {
		tcommit
		q "删除成功"
	}else{
		trollback
		q "删除失败"_SQLCODE
	}
}

/// Creator   : wk
/// CreatDate ：2018-08-24
/// Desc      : 待选报表列表格数据
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","OptionalRptItem")
Query OptionalRptItem(rptID As %String) As websys.Query(ROWSPEC = "ID:%String:ID,rptItemCode:%String:报表列编码,rptItemDesc:%String:报表列描述,rptItemType:%String:报表列类型") [ SqlProc ]
{
}

ClassMethod OptionalRptItemExecute(ByRef qHandle As %Binary, rptID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s sql="select OPTLItem_RowID,OPTLItem_Code,OPTLItem_Desc,OPTLItem_Type from DHCWL_MRIPDay.OPTLItem where  OPTLItem_RowID NOT IN (SELECT rptitem_optlitemdr FROM DHCWL_MRIPDay.RptItem WHERE RptItem_RptDR="_rptID_")"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("OPTLItem_RowID"),rs.Data("OPTLItem_Code"),rs.Data("OPTLItem_Desc"),rs.Data("OPTLItem_Type"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate ：2018-08-24
/// Desc      : 已选报表列表格数据
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","SelectedRptItem")
Query SelectedRptItem(rptID As %String) As websys.Query(ROWSPEC = "ID:%String:ID,selectedCode:%String:报表列编码,selectedDesc:%String:报表列描述") [ SqlProc ]
{
}

ClassMethod SelectedRptItemExecute(ByRef qHandle As %Binary, rptID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    set sql="select OPTLItem_RowID,OPTLItem_Code,OPTLItem_Desc from DHCWL_MRIPDay.OPTLItem t1, DHCWL_MRIPDay.RptItem t2 where t1.OPTLItem_RowID = t2.RptItem_OPTLItemDR  AND t2.RptItem_RptDR="_rptID_"ORDER BY t2.RptItem_Order"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("OPTLItem_RowID"),rs.Data("OPTLItem_Code"),rs.Data("OPTLItem_Desc"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-08-24
/// Desc       : 更新报表列排序值
/// Other      : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).UpdateItemOrder()
ClassMethod UpdateItemOrder(rptID, rptItemList)
{
	s RptItemRptDR=rptID
	s aryRptItemOPTLItemDRs=rptItemList
	
	s successFlag=1
	TSTART
	s count=$l(aryRptItemOPTLItemDRs,",")

	//更新报表项的顺序
	for i=1:1:count {
		s OPTLItemDR=$p(aryRptItemOPTLItemDRs,",",i)
		&sql(update DHCWL_MRIPDay.RptItem set RptItem_Order=:i where RptItem_RptDR=:RptItemRptDR and RptItem_OPTLItemDR=:OPTLItemDR)
		if SQLCODE'=0 {
			Trollback
			//w "{success:true,tip:'操作失败！',SQLCODE:"_SQLCODE_"}"
			s successFlag=0
			q 

		}
	}
	
	if successFlag=1 {
		tcommit
		//w "{success:true,tip:'ok',ROWID:"_%ROWID_"}"
		q "更新成功"
	}else{
		q "更新失败"
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-24
/// Desc      : 新增报表列
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).AddRptItem()
ClassMethod AddRptItem(rptItemID, rptID, rptItemCode, rptItemDesc, rptItemIDS)
{
	s RptItemOPTLItemDR=rptItemID
	s RptItemRptDR=rptID
	s RptItemCode=rptItemCode
	s RptItemDesc=rptItemDesc
	s aryRptItemOPTLItemDRs=rptItemIDS
	s rptMMgrCode=""
	s rptType=""
	s dimProCodes=""
	//1、同一报表下，不允许有报表项编码相同的多个报表项。不过这一步似乎有些多余。前台页面
	//		不会传入与已有报表项编码相同的报表项编码
	s rptItemDR=$o(^DHCWL.MRIPDay.RptItemI("RptItemRptDRCodeIndex",RptItemRptDR,RptItemCode,""))
	;w rptItemDR
	;i rptItemDR'="" d
	.;w "{success:true,tip:'操作失败！',SQLCODE:''}"
	q:rptItemDR'="" "操作失败"_SQLCODE
	//2、得到报表的树形编码，报表类型，报表维度属性代码。这3个数据用来生成模块与报表中的数据集
	&sql(select Rpt_MMgrCode ,Rpt_Type,Rpt_DimProCodes into :rptMMgrCode,:rptType,:dimProCodes from DHCWL_MRIPDay.Rpt where Rpt_RowID=:RptItemRptDR)
	TSTART
	//3、向插入报表项数据
	&sql(insert into DHCWL_MRIPDay.RptItem (RptItem_Code,RptItem_Desc,RptItem_RptDR,RptItem_OPTLItemDR)	values (:RptItemCode,:RptItemDesc,:RptItemRptDR,:RptItemOPTLItemDR))
	if SQLCODE'=0 {
		trollback
		;w "{success:true,tip:'操作失败！',SQLCODE:"_SQLCODE_"}"
		q "操作失败"_SQLCODE
	}
	else {
		s successFlag=1

		s count=$l(aryRptItemOPTLItemDRs,",")
		
		//4、更新报表项的顺序
		for i=1:1:count {
			s OPTLItemDR=$p(aryRptItemOPTLItemDRs,",",i)
			if $g(OPTLItemDR)="" continue
			&sql(update DHCWL_MRIPDay.RptItem set RptItem_Order=:i where RptItem_RptDR=:RptItemRptDR and RptItem_OPTLItemDR=:OPTLItemDR)
			if SQLCODE'=0 {
				Trollback
				//w "{success:true,tip:'操作失败！',SQLCODE:"_SQLCODE_"}"
				s successFlag=0
				q 
				
			}
		}
		q:successFlag=0 "操作失败"_SQLCODE
		if successFlag=1 {
			//5、下面处理数据集和指标
			s treeCode="root.CRZZBB"		//默认模块树形编码
	
			//得到统计项类型：KPIItem-指标类统计项;CoustomItem-自定义统计项;CalItem-计算类统计项
			s OPTLItemType=##class(DHCWL.MRIPDay.MripDayService).GetOPTLItemType(RptItemOPTLItemDR)
			
			if OPTLItemType="KPIItem" {
				//5.1、得到统计项对应的KPI和日期敏感度，维度
				s KPICode=""
				s dateSec=""
				s dimCode=""
				//判断指标统计项是否配置完整
				s statue=##class(DHCWL.MRIPDay.MripDayService).GetKPIItemKPICode(RptItemOPTLItemDR,rptType,.KPICode,.dateSec,.dimCode)
				if statue=100 {
					;w "{success:true,tip:'ok',TipMSG:'被操作的统计项配置信息不完整，请先在 统计项配置 中配置信息！'}"	
					trollback
					q "被操作的统计项配置信息不完整，请先在 报表列配置 中配置信息！"
				}
				//5.2、得到对应的数据集
				s datasetDR=##class(DHCWL.MRIPDay.MripDayService).GetDataset(treeCode,rptMMgrCode,dateSec)
				//5.3、写数据集的取数规则
				if $g(datasetDR)="" {
					//5.3.1添加	
					s dsCode=""
					if dateSec="begin" {s dsCode="ds1"}
					elseif dateSec="end" {s dsCode="ds2"}
					elseif dateSec="all" {s dsCode="ds3"}

					s dimProRule=""
					s proCount=$l(dimProCodes,";")
					for proIndex=1:1:proCount {
						s proCode=$p(dimProCodes,";",proIndex)
						s proCode=dimCode_"."_proCode
						if dimProRule'="" s dimProRule= dimProRule_"^"
						s dimProRule=dimProRule_proCode
					}
					
					s ruleList=KPICode
					if dimProRule'="" s ruleList=ruleList_":"_dimProRule
					s ruleList=$TRANSLATE(ruleList,"^","%")
					
					&sql(insert into DHCWL_MKPI.MMgrDatasetCfg (DatasetCfg_Code,DatasetCfg_desc,DatasetCfg_TreeCode,DatasetCfg_RptCode,DatasetCfg_RuleList) values (:dsCode,:dsCode,:treeCode,:rptMMgrCode,:ruleList))
					i +$g(SQLCODE)=0 {
						;w "{success:true,tip:'ok',ROWID:"_%ROWID_"}"
						TCOMMIT
						q "操作成功"
					}
					else  {
						;w "{success:true,tip:'操作失败',SQLCODE:"_SQLCODE_"}"	
						trollback
						q "操作失败"_SQLCODE
					}	
				}else{
					//5.3.2更新
					s ruleList=$lg(^DHCWL.MKPI.MMgrDataSetCfgD(datasetDR),5)
					if ruleList'="" s ruleList=ruleList_","
					
					
					s dimProRule=""
					s proCount=$l(dimProCodes,";")
					for proIndex=1:1:proCount {
						s proCode=$p(dimProCodes,";",proIndex)
						s proCode=dimCode_"."_proCode
						if dimProRule'="" s dimProRule= dimProRule_"^"
						s dimProRule=dimProRule_proCode
					}
					
					s ruleList=ruleList_KPICode
					if dimProRule'="" s ruleList=ruleList_":"_dimProRule
					s ruleList=$TRANSLATE(ruleList,"^","%")
					&sql(update DHCWL_MKPI.MMgrDatasetCfg set DatasetCfg_RuleList=:ruleList where DatasetCfg_RowID=:datasetDR)
					i +$g(SQLCODE)=0 {
						;w "{success:true,tip:'ok',ROWID:"_%ROWID_"}"
						tcommit
						q "操作成功"
					}
					else {
						 ;w "{success:true,tip:'操作失败!',SQLCODE:"_SQLCODE_"}"
						 trollback
						 q "操作失败"_SQLCODE
					}		
				
				}
			
			}elseif OPTLItemType="CustomItem" {
				//判断自定义统计项是否配置完整
				s statue=##class(DHCWL.MRIPDay.MripDayService).GetCustomItemID(RptItemOPTLItemDR,rptType,.customItemID)
				if statue=100 {
					;w "{success:true,tip:'ok',TipMSG:'被操作的统计项配置信息不完整，请先在 统计项配置 中配置信息！'}"	
					trollback
					q "被操作的统计项配置信息不完整，请先在 报表列配置 中配置信息！"
				}else{
					tcommit	
					;w "{success:true,tip:'ok'}"
					q "操作成功"
				}					

			}else{
				//计算类统计项。
				tcommit	
				;w "{success:true,tip:'ok'}"
				q "操作成功"
			}
			
		}
	
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-24
/// Desc      : 报表列的移除
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).DelRptItem()
ClassMethod DelRptItem(rptItemID, rptID, rptItemIDList)
{
	s RptItemOPTLItemDR=rptItemID
	s RptItemRptDR=rptID
	s aryRptItemOPTLItemDRs=rptItemIDList
	TSTART
	//删除报表项
	s result=##class(DHCWL.MRIPDay.MripDayService).DelRptItem(RptItemRptDR,RptItemOPTLItemDR,aryRptItemOPTLItemDRs)
	if result=0 {
		tcommit
		q "删除成功"
		//w "{success:true,tip:'ok',ROWID:''}"
	}else{
		trollback
		//w "{success:true,tip:'操作失败！',SQLCODE:''}"
		q "删除失败"
	}
}

/// Creator   : wk
/// CreatDate : 2018-08-27
/// Desc      : 获取待选明细
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","GetOPTLDetailQuery")
Query GetOPTLDetailQuery(rptID As %String, exceptRptDR As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,optionalCode:%String:明细编码,optionalDesc:%String:明细描述") [ SqlProc ]
{
}

ClassMethod GetOPTLDetailQueryExecute(ByRef qHandle As %Binary, rptID As %String, exceptRptDR As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
	s itemType="KPIDetailItem"	
	s rptDR=rptID	
	;s exceptRptDR=exceptRptDR
		
	s OPTLDetailItems=""
	
	//1、从明细报表中得到明细项
	if $g(exceptRptDR)="" {
		&sql(SELECT DetailRpt_OPTLDetailItems into :OPTLDetailItems FROM DHCWL_MRIPDay.DetailRpt WHERE DetailRpt_RptDR=:rptDR AND DetailRpt_OPTLItemDR is null)	
	}else {
		&sql(SELECT DetailRpt_OPTLDetailItems into :OPTLDetailItems FROM DHCWL_MRIPDay.DetailRpt WHERE DetailRpt_RptDR=:rptDR AND DetailRpt_OPTLItemDR=:exceptRptDR)	
	}		

	//2、得到明细项的ID，编码，描述，类型
	set sql="SELECT OPTLDetailItem_RowID,OPTLDetailItem_Code,OPTLDetailItem_Desc,OPTLDetailItem_Type FROM DHCWL_MRIPDay.OPTLDetailItem  WHERE OPTLDetailItem_Type='"_itemType_"'"
	
	if OPTLDetailItems'="" s sql=sql_" AND OPTLDetailItem_RowID NOT IN ("_OPTLDetailItems_")"

	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
    
	While(rs.Next()){
		s rowID=rs.Data("OPTLDetailItem_RowID")
		s code=rs.Data("OPTLDetailItem_Code")
		s desc=rs.Data("OPTLDetailItem_Desc")
		s ^CacheTemp(repid,ind)=$lb(rowID,code,desc)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-27
/// Desc      : 获取明细已选明细
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRIPDay.MRIPDayFun","GetDetailRptItem")
Query GetDetailRptItem(rptID As %String, OPTLItem As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,selectedCode:%String:编码,selectedDesc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetDetailRptItemExecute(ByRef qHandle As %Binary, rptID As %String, OPTLItem As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    
	s itemType="KPIDetailItem"	
	s rptDR=rptID	
	;s OPTLItem=""
	//1、从明细报表中得到明细项
	s OPTLDetailItems=""	
	if OPTLItem'=""	&sql(SELECT DetailRpt_OPTLDetailItems into :OPTLDetailItems FROM DHCWL_MRIPDay.DetailRpt WHERE DetailRpt_RptDR=:rptDR AND DetailRpt_OPTLItemDR=:OPTLItem)	
	e  &sql(SELECT DetailRpt_OPTLDetailItems into :OPTLDetailItems FROM DHCWL_MRIPDay.DetailRpt WHERE DetailRpt_RptDR=:rptDR AND DetailRpt_OPTLItemDR is NULL)	
	set sql="SELECT OPTLDetailItem_RowID,OPTLDetailItem_Code,OPTLDetailItem_Desc,OPTLDetailItem_Type FROM DHCWL_MRIPDay.OPTLDetailItem  WHERE OPTLDetailItem_Type='"_itemType_"'"
	
	s sql=sql_" AND OPTLDetailItem_RowID IN ("_OPTLDetailItems_")"
	//2、得到明细项的ID，编码，描述，类型
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=","
        	
    s json=##class(DHCWL.util.Json).Json("ID"_deli_"detailCode"_deli_"detailDesc","result","root",deli)

	s lstRpt = ##Class(%ArrayOfObjects).%New()
	While(rs.Next()){
		
		s aryRec = ##Class(%ArrayOfDataTypes).%New()
		s rowID=rs.Data("OPTLDetailItem_RowID")
		s code=rs.Data("OPTLDetailItem_Code")
		s desc=rs.Data("OPTLDetailItem_Desc")
		//3、为了能按顺序显示明细统计项，需要先把数据保存到ArrayOfObjects
		d aryRec.SetAt(rowID,"rowID")
		d aryRec.SetAt(code,"code")
		d aryRec.SetAt(desc,"desc")
		d lstRpt.SetAt(aryRec,rowID)
	}

	d rs.Close()
	
	//4、按配置顺序组装拼接返回数据
	s recCnt=$l(OPTLDetailItems,",")
	for recInx=1:1:recCnt {
		s detailItemDR=$p(OPTLDetailItems,",",recInx)
		
		if (detailItemDR="") continue
		s rec=lstRpt.GetAt(detailItemDR)
		if (rec="") continue
		
		s rowID=rec.GetAt("rowID")
		s code=rec.GetAt("code")
		s desc=rec.GetAt("desc")
		d json.Insert(""_rowID_""_deli_"'"_code_"'"_deli_"'"_desc_"'")
		s ^CacheTemp(repid,ind)=$lb(rowID,code,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-08-24
/// Desc      : 报表列的移除
/// Other     : do ##class(web.DHCWL.V1.MRIPDay.MRIPDayFun).AddDetailRptItem()
ClassMethod AddDetailRptItem(itemID, rptID, itemDesc, itemList)
{
	s OPTLItemDR= itemID
	s rptDR=rptID
	s itemDesc=itemDesc
	s aryOPTLDetailItemDRs=itemList
	s detailRptRowID=""
	s DetailRptDesc="默认明细"
	if itemDesc'="" s DetailRptDesc=itemDesc_"明细"
	if aryOPTLDetailItemDRs="" {
		if OPTLItemDR'="" {
			&sql(delete from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:rptDR and DetailRpt_OPTLItemDR=:OPTLItemDR)
		}else{
			&sql(delete from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:rptDR and DetailRpt_OPTLItemDR is null)
		}
		
		i ((+$g(SQLCODE)=0)||(+$g(SQLCODE)=100)) q "更新成功"
		e  q "更新失败"_SQLCODE 
			
	}else{
	
		i OPTLItemDR'="" {
			&sql(select DetailRpt_RowID into :detailRptRowID from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:rptDR and DetailRpt_OPTLItemDR=:OPTLItemDR)
		}else {
			&sql(select DetailRpt_RowID into :detailRptRowID from DHCWL_MRIPDay.DetailRpt where DetailRpt_RptDR=:rptDR and DetailRpt_OPTLItemDR is NULL)
		}
	
		if detailRptRowID="" {
			&sql(insert into DHCWL_MRIPDay.DetailRpt (DetailRpt_RptDR,DetailRpt_OPTLItemDR,DetailRpt_OPTLDetailItems,DetailRpt_Desc)
			 values (:rptDR,:OPTLItemDR,:aryOPTLDetailItemDRs,:DetailRptDesc))
			i +$g(SQLCODE)=0 q "更新成功" 
			e  q "更新失败"_SQLCODE  	
		
		}else {
			&sql(update DHCWL_MRIPDay.DetailRpt set DetailRpt_OPTLDetailItems=:aryOPTLDetailItemDRs where DetailRpt_RowID=:detailRptRowID)
			i +$g(SQLCODE)=0 q "更新成功"  
			e  q "更新失败"_SQLCODE  	
		}
		
	}
}

}
