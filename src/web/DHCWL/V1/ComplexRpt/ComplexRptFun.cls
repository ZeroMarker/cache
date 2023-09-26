/// Creator   : wk
/// CreatDate : 2018-09-04
/// Desc      : 收入报表配置后台维护
Class web.DHCWL.V1.ComplexRpt.ComplexRptFun Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-04
/// Desc      : 统计模式表格数据获取
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetStatMode",)
Query GetStatMode(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,exeCode:%String:执行代码,activeFlag:%String:有效标识") [ SqlProc ]
{
}

ClassMethod GetStatModeExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
    s sql="SELECT ID,StMode_Code,StMode_Desc,StMode_ExcCode,StMode_Flag,StMode_UpdateDate FROM DHCWL_ComplexRpt.StatMode order by ID"
 	s rs=##class(%Library.ResultSet).%New()
 	d rs.Prepare(sql)
 	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("StMode_Code")
		s desc=rs.Data("StMode_Desc")
		s excCode=rs.Data("StMode_ExcCode")
		s update=rs.Data("StMode_UpdateDate")
		s StModeFlag=rs.Data("StMode_Flag")
		i StModeFlag="Y" s StModeFlag="是"
		i StModeFlag="N" s StModeFlag="否"
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(excCode,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc,excCode,StModeFlag)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-05
/// Desc      : 新增统计模式
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).AddMode()
ClassMethod AddMode(code, desc, exeCode, flag)
{
	s dim("ModeCode")=code
	s dim("ModeDesc")=desc
	s dim("ModeExcCode")=exeCode
	s dim("ModeFlag")=flag
	s dim("ModeUpdateDate")=+$h
	s result=##class(DHCWL.ComplexRptData.SaveData).AddStatMode(.dim)
	s:result="ok" result="新增成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-09-05
/// Desc      : 修改统计模式
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).UpdateMode()
ClassMethod UpdateMode(ID, code, desc, exeCode, flag)
{
	s dim("ID")=ID
	s dim("ModeCode")=code
	s dim("ModeDesc")=desc
	s dim("ModeExcCode")=exeCode
	s dim("ModeFlag")=flag
	s dim("ModeUpdateDate")=+$h
	s result=##class(DHCWL.ComplexRptData.SaveData).UpdateStatMode(.dim)
	s:result="ok" result="修改成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-09-05
/// Desc      : 获取统计项、统计内容
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetStatItem",)
Query GetStatItem(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,exeCode:%String:执行代码,type:%String:类型,WLValueDr:%String:wl字段值Dr,dimDr:%String:维度Dr,flag:%String:有效标识,creatDate:%String:更新日期,WLValue:%String:wl字段值,dim:%String:维度,typeFlag:%String:分类标识") [ SqlProc ]
{
}

ClassMethod GetStatItemExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	 s repid=$I(^CacheTemp)
	 k ^CacheTemp(repid)
	 s qHandle=$lb(0,repid,0)
	 s ind=1
	 s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	 s dhcwlArray=##class(DHCWL.ComplexRptData.SaveData).SetObjsByClassName("User","DHCWorkLoad")
	 s sql="SELECT ID,St_Code,St_Desc,St_ExcCode,St_Type,St_WorkLoad,St_DimDr,St_Flag,St_UpdateDate,St_StatisListFlag FROM DHCWL_ComplexRpt.StatItem order by ID"
	 s rs=##class(%Library.ResultSet).%New()
	 d rs.Prepare(sql)
	 d rs.Execute()
	 While(rs.Next()){
		s date=rs.Data("St_UpdateDate")
		s:date'="" date=##class(websys.Conversions).DateLogicalToHtml(+date)
		s stType=rs.Data("St_Type")
		i stType="S" s stType="统计项"
		i stType="C" s stType="统计内容"
		s stFlag=rs.Data("St_Flag")
		i stFlag="Y" s stFlag="是"
		i stFlag="N" s stFlag="否"
		s stSort=rs.Data("St_StatisListFlag")
		i stSort="stat" s stSort="统计项"
		i stSort="list" s stSort="列表项"
		s dimDr=rs.Data("St_DimDr")
		s dimDesc=##class(DHCWL.ComplexRptData.SaveData).GetDimDescByID(dimDr)
		;&sql(SELECT KDT_Name INTO :dimDr FROM DHCWL_MKPI.DHCWLMKPIDimType WHERE KDT_Code=:dimDr)
		s dhcwl=rs.Data("St_WorkLoad")
		i +dhcwl=0 s wlDesc=""
		e  s wlDesc=dhcwlArray.GetAt(dhcwl)
		continue:((filterValue'="")&&($zcvt(rs.Data("St_Code"),"U") '[ filterValue)&&($zcvt(rs.Data("St_Desc"),"U") '[ filterValue)&&($zcvt(rs.Data("St_ExcCode"),"U") '[ filterValue)&&($zcvt(wlDesc,"U") '[ filterValue)&&($zcvt(dimDesc,"U") '[ filterValue)&&($zcvt(stType,"U") '[ filterValue)&&($zcvt(stSort,"U") '[ filterValue))
	 	s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("St_Code"),rs.Data("St_Desc"),rs.Data("St_ExcCode"),stType,dhcwl,dimDr,stFlag,date,wlDesc,dimDesc,stSort)
		s ind=ind+1
	 }
	 Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-05
/// Desc      : 获取WL字段值
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetWLValue","User",)
Query GetWLValue(packageName As %String = "", className As %String = "", q As %String = "") As websys.Query(ROWSPEC = "serialNum:%String:序号,WLValue:%String:字段值") [ SqlProc ]
{
}

ClassMethod GetWLValueExecute(ByRef qHandle As %Binary, packageName As %String = "", className As %String = "", q As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s filter=q
	s:packageName="" packageName="User"
	s:className="" className="DHCWorkLoad"
	s dhcwlArray=##class(DHCWL.ComplexRptData.SaveData).SetObjsByClassName(packageName,className,filter)
	s i=dhcwlArray.Next()
	s ^CacheTemp(repid,ind)=$lb("","")
	s ind=ind+1
	while(i)
	{	
		s propertyField=dhcwlArray.GetAt(i)
		s ^CacheTemp(repid,ind)=$lb(i,propertyField)
		s ind=ind+1
		s i=dhcwlArray.Next(i)
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-06
/// Desc      : 新增统计项、统计内容
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).AddStat()
ClassMethod AddStat(code, desc, exeCode, type, WLValue, dimID, flag, sort)
{
	s dim("StatCode")=code
	s dim("StatDesc")=desc
	s dim("StatExcCode")=exeCode
	s dim("StatType")=type
	s dim("StatWorkLoad")=WLValue
	s dim("StatDimDr")=dimID
	s dim("StatFlag")=flag
	s dim("StatSort")=sort
	s result=##class(DHCWL.ComplexRptData.SaveData).AddStatItem(.dim)
	s:result="ok" result="新增成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-09-06
/// Desc      : 修改统计项、统计内容
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).UpdateStatItem("7","PatLoc","病人科室","N","stat")
ClassMethod UpdateStatItem(ID, code, desc, flag, itemType)
{
	s id=ID
	q:'$d(^DHCWL.ComplexRpt.StatItemD(id)) "请选择要更新的行！"
	s statCode=code
	s oldStatCode=$lg(^DHCWL.ComplexRpt.StatItemD(id),2) ;更新前code
	q:oldStatCode'=statCode "编码不能修改！"
	s tempType=$lg(^DHCWL.ComplexRpt.StatItemD(id),4)
	s oldTempFlag=$lg(^DHCWL.ComplexRpt.StatItemD(id),8)
	if ((oldTempFlag="Y")&(flag="N")){
		if (tempType="C"){
			s numValue=0
			&sql(select count(*) into :numValue from DHCWL_ComplexRpt.RowsColCfg where RC_Content = :statCode)
			if (numValue > 0){
				q "当前统计内容已经使用,不能作废"
			}
		}
		if (tempType="S"){
			s numValue=0
			s filterStatCode="%"_statCode_"%"
			&sql(select count(*) into :numValue from DHCWL_ComplexRpt.RowsColCfg where RC_RowExp like :filterStatCode or RC_ColExp  like :filterStatCode or RC_FilterExp like :filterStatCode)
			if (numValue > 0){
				q "当前统计项已经使用,不能作废"
			}
		}
	}
	s statObj=##class(DHCWL.ComplexRpt.StatItem).%OpenId(id)
	s statObj.StDesc=desc
	s statObj.StFlag=flag
	s statObj.StUpdateDate=+$h
	s statObj.StStatisFlag=itemType
	s sc=statObj.%Save()
	i sc=1  d
	.s result="更新成功"
	e  d
	.s result="更新失败！"
	q result
}

/// Creator    : wk
/// CreatDate  : 2018-09-06
/// Desc       : 获取指标池指标信息
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetPoolKPI")
Query GetPoolKPI(filterValue As %String) As websys.Query(ROWSPEC = "kpiCode:%String:指标编码,statContent:%String:统计内容,statModal:%String:统计模式,KPIDim:%String:指标维度串") [ SqlProc ]
{
}

ClassMethod GetPoolKPIExecute(ByRef qHandle As %Binary, filterValue As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT MKpi_KpiDr,MKpi_Mode,MKpi_Content,MKpi_DimStr FROM DHCWL_ComplexRpt.MKpi order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s poolKpi=rs.Data("MKpi_KpiDr")
		&sql(SELECT MKPI_Code INTO :poolCode FROM DHCWL_MKPI.DHCWLMKPI WHERE ID=:poolKpi)
		continue:$g(poolCode)="" ;指标不存在时，指标池中不显示
		s poolCont=rs.Data("MKpi_Content")
		&sql(SELECT St_Desc INTO :pCont FROM DHCWL_ComplexRpt.StatItem WHERE St_Code=:poolCont)
		s poolMode=rs.Data("MKpi_Mode")
		&sql(SELECT StMode_Desc INTO :pMode FROM DHCWL_ComplexRpt.StatMode WHERE StMode_Code=:poolMode)
		s poolDimStr=rs.Data("MKpi_DimStr")
		s pDimStr=##class(DHCWL.ComplexRptData.RptKpiPoolService).GetKpiDimDescStr(poolDimStr)
		continue:((filterValue'="")&&($zcvt(poolCode,"U") '[ filterValue)&&($zcvt(pCont,"U") '[ filterValue)&&($zcvt(pMode,"U") '[ filterValue)&&($zcvt(pDimStr,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(poolCode,pCont,pMode,pDimStr)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-06
/// Desc      : 获取指标对应的报表
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetRptByKPI")
Query GetRptByKPI(kpiCode) As websys.Query(ROWSPEC = "rptCode:%String:报表编码,rptName:%String:报表名称") [ SqlProc ]
{
}

ClassMethod GetRptByKPIExecute(ByRef qHandle As %Binary, kpiCode) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:kpiCode="" $$$OK
	s sql="SELECT Rpt_Code,Rpt_Name FROM DHCWL_ComplexRpt.RptCfg"
	s orderSql=" order by ID",condSql="",noCond=""
	s rptCode=kpiCode
	i $g(rptCode)="" {
		i $g(rptCode)=""{
			q $$$OK
		}
	}else{
		&sql(SELECT ID INTO :kpi FROM DHCWL_MKPI.DHCWLMKPI WHERE MKPI_Code=:rptCode)
		i $g(kpi)=""{
			q $$$OK
		}
		&sql(SELECT ID into :poolkpi FROM DHCWL_ComplexRpt.MKpi where MKpi_KpiDr=:kpi)
		i $g(poolkpi)=""{
			q $$$OK
		}
		s searcheSql="SELECT RptLink_Rpt FROM DHCWL_ComplexRpt.RptLinkMkpi WHERE RptLink_Kpi = "_poolkpi
		s condRs=##class(%Library.ResultSet).%New()
		d condRs.Prepare(searcheSql)
		d condRs.Execute()
		While(condRs.Next()){
			s RptLink(condRs.Data("RptLink_Rpt"))=""
		}
		d condRs.Close()
		s ids="",tempId="" f  s tempId=$o(RptLink(tempId)) q:tempId=""  d
		.s ids=ids_tempId_","
		s ids=$e(ids,1,$l(ids)-1)
		s condSql=" where ID in ("_ids_")"
	}
	s sql=sql_" "_condSql_orderSql
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	//读入可选项结束
	While(rs.Next()){
		//插入一个json对象格式
		s ^CacheTemp(repid,ind)=$lb(rs.Data("Rpt_Code"),rs.Data("Rpt_Name"))
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-07
/// Desc      : 获取报表数据
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetRptTable")
Query GetRptTable(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,name:%String:名称,desc:%String:描述,type:%String:报表分类,updateDate:%String:更新日期,remark:%String:备注") [ SqlProc ]
{
}

ClassMethod GetRptTableExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT ID,Rpt_Code,Rpt_Name,Rpt_Desc,Rpt_FL,Rpt_UpdateDate,Rpt_Remark FROM DHCWL_ComplexRpt.RptCfg order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s date=rs.Data("Rpt_UpdateDate")
		s:date'="" date=##class(websys.Conversions).DateLogicalToHtml(+date)
		s rptFL=rs.Data("Rpt_FL")
		s ID = rs.Data("ID")
		s code = rs.Data("Rpt_Code")
		s name = rs.Data("Rpt_Name")
		s desc = rs.Data("Rpt_Desc")
		s remark = rs.Data("Rpt_Remark")
		continue:(filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(name,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(rptFL,"U") '[ filterValue)&&($zcvt(remark,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,code,name,desc,rptFL,date,remark)
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-07
/// Desc      : 获取报表下可配置指标
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetAllKPI")
Query GetAllKPI(rptCode As %String) As websys.Query(ROWSPEC = "group:%String:组,ID:%String:指标ID,name:%String:编码,value:%String:描述,dim:%String:维度") [ SqlProc ]
{
}

ClassMethod GetAllKPIExecute(ByRef qHandle As %Binary, rptCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s statParentNO="root"
	s jsonDatas=""
	i rptCode=""{
		q $$$OK
	}
	s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"),""))
	i rptId=""{
		q $$$OK
	}
	s rptCfgId=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
	i rptCfgId=""{
		q $$$OK
	}
	s rptMode=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),3)
	s rptContent=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),4)
	s rptRow=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),5)
	s rptCol=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),6)
	s rptFilter=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptCfgId),7)
	s dimArray=##class(DHCWL.ComplexRptData.RptCfgService).ResovleFilterRule(rptFilter)
	;生成规则指标维度串
	s dimStr=##class(DHCWL.ComplexRptData.RptCfgService).StructureKpiDim(rptRow,rptCol,.dimArray)
	s len=$l(rptContent,",")
	f i=1:1:len{
		s contentCode=$P(rptContent,",",i)
		s numBase=1
		&sql(SELECT St_Desc INTO :pCont FROM DHCWL_ComplexRpt.StatItem WHERE St_Code=:contentCode)
		s statNO=contentCode_numBase
		s numBase=numBase+1
		s jsonData="{""code"":"""_contentCode_""""_",""className"":"""_"DHCWL.ComplexRpt.StatItem"_""""
		s jsonData=jsonData_",""parentNO"":"""_statParentNO_""""_",""NO"":"""_contentCode_""""_",""id"":"""_contentCode_""""
		s jsonData=jsonData_",""text"":"""_pCont_"""}"
		i jsonDatas="" s jsonDatas=jsonData
		e  s jsonDatas=jsonDatas_","_jsonData
		s comRptKpiDr=0
		f {
			s comRptKpiDr=$o(^DHCWL.ComplexRpt.MKpiI("ModeConKpi",rptMode,contentCode,comRptKpiDr))
			q:comRptKpiDr=""
			;s rptLinkDr=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,comRptKpiDr,"")) ;报表关联指标表的ID
			s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(comRptKpiDr),2) ;指标
			continue:'$d(^DHCWL.MKPI.MKPID(+mkpi)) ;过滤掉指标池存在但是指标系统不存在的指标
			s kpiDesc=$lg(^DHCWL.MKPI.MKPID(mkpi),3) ;指标描述
			s kpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2) ;指标代码
			s comDimStr=$lg(^DHCWL.ComplexRpt.MKpiD(comRptKpiDr),5) ;维度串
			s rs=##class(DHCWL.ComplexRptData.RptCfgService).MatchKpiDimString(comDimStr,dimStr)
			continue:rs'=1
			s proNo="RPTKPI"_numBase
			s numBase=numBase+1
			s jsonData="{""code"":"""_comDimStr_""""_",""className"":"""_"DHCWL.ComplexRpt.MKpi"_""""
			s jsonData=jsonData_",""parentNO"":"""_contentCode_""""_",""NO"":"""_comRptKpiDr_""""_",""id"":"""_kpiCode_""""
			s jsonData=jsonData_",""text"":"""_kpiDesc_"""}"
			s jsonDatas=jsonDatas_","_jsonData
			s ^CacheTemp(repid,ind)=$lb(contentCode_":"_pCont,comRptKpiDr,kpiCode,kpiDesc,comDimStr)
			s ind=ind+1
			
		}
	}	
	
	q $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-10
/// Desc      : 生成报表数据
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).CreatRptKpiData()
ClassMethod CreatRptKpiData(kpis, startDate, endDate)
{
	s kpis=kpis ;指标串
	s startDate=startDate ;开始时间
	s endDate=endDate ;结束时间
	s sd=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
	s ed=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
	if (sd>ed){
		q "开始日期不能大于结束日期"
	}
	// 1、通过报表编码获得关联指标串
	// 2、调用指标数据接口生成指标数据
	s rs=##class(DHCWL.ComplexRptData.RptService).CreateKpiData(kpis,startDate,endDate,1)
	i rs=1{
		q "数据生成成功"
	}else{
		q "数据生成失败！"
	}
}

/// Creator   : wk
/// CreatDate : 2018-09-10
/// Desc      : 新增报表
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).AddRpt()
ClassMethod AddRpt(code, name, desc, fl, remark)
{
	s dim("RptCode")=code
	s dim("RptName")=name
	s dim("RptDesc")=desc
	s dim("RptFL")=fl
	s dim("RptUpdateDate")=+$h
	s dim("RptRemark")=remark
	s result=##class(DHCWL.ComplexRptData.SaveData).AddRptDef(.dim)
	s:result="ok" result="新增成功"
	q result
}

/// Creator     : wk
/// CreatDate   : 2018-09-10
/// Desc        : 更新报表
/// Other       : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).UpdateRpt()
ClassMethod UpdateRpt(ID, code, name, desc, type, remark)
{
	s dim("ID")=ID
	s dim("RptCode")=code
	s dim("RptName")=name
	s dim("RptDesc")=desc
	s dim("RptFL")=type
	s dim("RptUpdateDate")=+$h
	s dim("RptRemark")=remark
	s result=##class(DHCWL.ComplexRptData.SaveData).UpdateRptDef(.dim)
	s:result="ok" result="更新成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-09-10
/// Desc      : 删除报表
/// Other     : do ##class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).DeleteRpt()
ClassMethod DeleteRpt(rptID)
{
	s id=rptID
	s result=##class(DHCWL.ComplexRptData.OperateRptData).DeleteRptCfg(id)
	s:result="ok" result="删除成功"
	q result
}

/// Creator   : wk
/// CreatDate : 2018-09-11
/// Desc      : 获取统计内容与统计项树
/// Other     :	do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetContentAndItem")
Query GetContentAndItem() As websys.Query(ROWSPEC = "id:%String:id,parentId:%String:父节点,name:%String:名称") [ SqlProc ]
{
}

ClassMethod GetContentAndItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	k dimList
	
	s ^CacheTemp(repid,ind)=$lb("0","-1","统计项")
	s ind=ind+1
	s statId="" 
	f {
		s statId=$o(^DHCWL.ComplexRpt.StatItemD(statId)) 
		q:statId=""
		s flag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),8) ;有效标识
		s statOrCon=$lg(^DHCWL.ComplexRpt.StatItemD(statId),4) ;统计内容或统计项
		s statSortFlag=$lg(^DHCWL.ComplexRpt.StatItemD(statId),10) ;统计项分类
		continue:(statOrCon="C")!(flag="N")
		continue:statSortFlag'="stat" ;此处的stat为收入综合查询的统计项
		s statCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),2)
		s statName=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
		s statDimCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
		continue:statDimCode="" ;统计项如果没有关联维度则不显示
		s dimList(statCode)=""
		s ^CacheTemp(repid,ind)=$lb(statCode,"0",statCode_":"_statName)
		s ind=ind+1
	}
		
		
	q:($o(dimList(""))="")
	s statCode=""
	for {
		s statCode=$o(dimList(statCode))
		q:statCode=""
		s statId=##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode(statCode)
		q:statId=""
		s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3) ;描述
		s kpiDimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
		q:kpiDimDr=""
		s kpiDimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(kpiDimDr),2)
		s rs=##class(%ResultSet).%New("DHCWL.CodeCfgData.FunctionModule:GetGrpListByDimCode")
		s dimProCode="",numBase=0
		f {
			s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDr,dimProCode))
			q:$g(dimProCode)=""
			s dimProID=""
			f {
				s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",kpiDimDr,dimProCode,dimProID))
				q:$g(dimProID)="" ;维度属性ID为空退出
				s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
				continue:proCode="ItemSubGrp"
				s proDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
				s numBase=numBase+1
				s proNo=proCode_numBase
				;统计大组和统计子组单独处理
				;flag的值为"dimProGrp"：表示为报表行列条件配置界面使用
				if flag="dimProGrp" s className="DHCWL.ComplexRpt.StatItem"
				else  s className="DHCWL.MKPI.DimProperty"
				if proCode="ItemGrp"{
					s proCodeNo=statCode_"."_proCode
					//s proDesc=statDesc_"."_proDesc
					s ^CacheTemp(repid,ind)=$lb(proCodeNo,statCode,proCode_":"_proDesc)
					s ind=ind+1
					;统计大组
					if (flag="dimProGrp"){
						s sc=rs.Execute(kpiDimCode,"G")
						s i=0
						While rs.Next(.sc){
							s i=i+1
							s grpDr=$g(rs.Data("id"))
							s grpCode=$g(rs.Data("Code")) 
							s grpDesc=$g(rs.Data("Desc"))
							s itemGrpNo=grpCode_i
							s ^CacheTemp(repid,ind)=$lb(proCodeNo_"("_grpCode_")",proCodeNo,grpCode_":"_grpDesc)
							s ind=ind+1
						}
					}
				}
				elseif((proCode="ItemSubGrpCode")!(proCode="ItemSubGrpDesc")!(proCode="ItemSubGrpOrder")){
					;统计子组:代码(ItemSubGrpCode)、描述(ItemSubGrpDesc)、顺序(ItemSubGrpSort)
					s proCodeNo=statCode_"."_proCode
					//s proDesc=statDesc_"."_proDesc
					s ^CacheTemp(repid,ind)=$lb(proCodeNo,statCode,proCode_":"_proDesc)
					s ind=ind+1
					s sc=rs.Execute(kpiDimCode,"SG")
					s i=0
					While rs.Next(.sc){
						s i=i+1
						s grpDr=$g(rs.Data("id"))
						s grpCode=$g(rs.Data("Code")) 
						s grpDesc=$g(rs.Data("Desc"))
						s itemGrpNo=grpCode_i
						s ^CacheTemp(repid,ind)=$lb(proCodeNo_"("_grpCode_")",proCodeNo,grpCode_":"_grpDesc)
						s ind=ind+1
					}
				}
				else{
					s proCodeNo=statCode_"."_proCode
					s ^CacheTemp(repid,ind)=$lb(proCodeNo,statCode,proCode_":"_proDesc)
					s ind=ind+1
				}
			}
		}
	}
	
	s ^CacheTemp(repid,ind)=$lb("1","-1","统计内容")
	s ind=ind+1
	s sql="SELECT St_Code,St_Desc FROM DHCWL_ComplexRpt.StatItem WHERE St_Type='C' AND St_Flag='Y'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("St_Code"),1,rs.Data("St_Code")_":"_rs.Data("St_Desc"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-13
/// Desc      : 获取选中的统计项值
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetDimProValueName","","")
Query GetDimProValueName(grpCode As %String, filterStr As %String = "") As websys.Query(ROWSPEC = "dimCode:%String,dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetDimProValueNameExecute(ByRef qHandle As %Binary, grpCode As %String, filterStr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterStr'="" filterStr=$zcvt(filterStr,"U")
	s statCode = $p(grpCode,".",1)
	s dimProCode = $p(grpCode,".",2)
	s orgDimFlag = 0
	if dimProCode="" {
		s orgDimFlag = 1
		s dimProCode=##class(DHCWL.ComplexRptData.SaveData).GetDimProCodeByStatCode(statCode) ;默认维度属性
	}
	q:(statCode="")!(dimProCode="") $$$OK
	s dim=+##class(DHCWL.ComplexRptData.SaveData).GetDimByStatCode(statCode)
	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dim),2)
	q:dimCode="" $$$OK
	if dimProCode="ItemGrp" {
		s rs=##class(%ResultSet).%New("DHCWL.CodeCfgData.FunctionModule:GetGrpListByDimCode")
		s sc=rs.Execute(dimCode,"G")
		While rs.Next(.sc){
			s dimType=dimCode
			s dimIDV=$g(rs.Data("Code")) 
			s dimProV=$g(rs.Data("Desc"))
			continue:(dimProV'[filterStr)
    		s ^CacheTemp(repid,ind)=$lb(dimType,dimIDV,dimProV)
 			s ind=ind+1
		}
	}else{
		s dimCodeStr=dimCode_":"_dimProCode
		s rs=##class(%ResultSet).%New("DHCWL.Interface.MkpiData:QryDimValuesByDimType")
		s sc=rs.Execute(dimCodeStr)
		While rs.Next(.sc){
			s dimType=$g(rs.Data("dimType"))
			s dimIDV=$g(rs.Data("dimIDV")) 
			s dimProV=$g(rs.Data("dimProV"))
			continue:(dimProV'[filterStr)
			s:orgDimFlag=1 dimProV=dimIDV
    		s ^CacheTemp(repid,ind)=$lb(dimType,dimIDV,dimProV)
 			s ind=ind+1
		}
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-13
/// Desc      : 获取统计项BS代码维护列表
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetSubGrpListByCode","ItemSubGrpCode","MRGrpDep")
Query GetSubGrpListByCode(grpCode As %String, filter As %String = "") As websys.Query(ROWSPEC = "dimValue:%String,dimProValue:%String") [ SqlProc ]
{
}

ClassMethod GetSubGrpListByCodeExecute(ByRef qHandle As %Binary, grpCode As %String, filter As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filter'="" filter=$zcvt(filter,"U")
	q:grpCode="" $$$OK
	s flag=$p($p(grpCode,".",2),"(",1)
	s subGrpCode = $p($p(grpCode,"(",2),")",1)
	s grpId=0,subGrpStr=""
	f {
		s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(subGrpCode,"U"),grpId))
		q:grpId=""
		s subgrpId=0
		f {
			s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId))
			q:subgrpId=""
			s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
			s subgrpDesc=value.SGrpDesc
			s subgrpCode=value.SGrpCode
			s subgrpSort=value.SGrpSort
			s subGrpStr=$case(flag,"ItemSubGrpCode":subgrpCode,"ItemSubGrpDesc":subgrpDesc,"ItemSubGrpOrder":subgrpSort,:subgrpDesc)
			continue:(subGrpStr'[filter)
    		s ^CacheTemp(repid,ind)=$lb(subgrpId,subGrpStr)
    		s ind=ind+1
		}
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-14
/// Desc      : 获取过滤规则
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetRptFilter")
Query GetRptFilter(rptCode As %String) As websys.Query(ROWSPEC = "calSymbol:%String:运算符,dimRule:%String:维度规则,filterFun:%String:过滤函数,filterValue:%String:过滤值,calSymboxRight:%String:右运算符") [ SqlProc ]
{
}

ClassMethod GetRptFilterExecute(ByRef qHandle As %Binary, rptCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	k filterList
	q:rptCode="" $$$OK
	s rptCode=rptCode
	s rptID=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rptCode,"U"),""))   //获取报表ID
	q:rptID="" $$$OK
	s rowColID=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptID,""))    //获取rowCol表的ID
	q:rowColID="" $$$OK
	s filterRule=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rowColID),7)     //获取过滤规则
	do ##Class(web.DHCWL.V1.Util.Util).ResoleFilterRule(filterRule,.filterList)
	s index=""
	for{
		s index=$o(filterList(index))
		q:index=""
		s ^CacheTemp(repid,ind)=filterList(index)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-18
/// Desc      : 保存报表
/// Other     : do ##Class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).AddRptCfg()
ClassMethod AddRptCfg(rptMode, rptContext, rptRow, rptCol, rptFilter, rptCode)
{
	s dim("Mode")=rptMode
	s dim("Content")=rptContext
	s dim("Row")=rptRow
	s dim("Col")=rptCol
	s dim("Filter")=rptFilter
	s rptCode=rptCode
	s rptId=##class(DHCWL.ComplexRptData.SaveData).GetRptDefidByCode(rptCode)
	i (rptId=""){
		q "报表保存失败！"
	}
	s dim("RptId")=rptId
	s rs=##class(DHCWL.ComplexRptData.RptCfgService).CreateKpiByRptId(.dim)
	i rs=2{
		q "报表维度个数不能查过5个！"
	}elseif rs=0{
		q "保存成功"
	}else{
		q "报表保存失败！"
	}
}

/// Creator    : wk
/// CreatDate  : 2018-09-18
/// Desc       : 获取已配置报表统计模式信息
/// Other      : do ##Class(web.DHCWL.V1.ComplexRpt.ComplexRptFun).GetRptCfgMode()
ClassMethod GetRptCfgMode(rptCode)
{
	&sql(SELECT ID into :rptIDs FROM DHCWL_ComplexRpt.RptCfg WHERE Rpt_Code=:rptCode)
	s sqla="SELECT RC_Mode FROM DHCWL_ComplexRpt.RowsColCfg WHERE RC_RptDr IN ("_rptIDs_")"
	s sql="SELECT StMode_Code,StMode_Desc FROM DHCWL_ComplexRpt.StatMode WHERE StMode_Code IN ("_sqla_")"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=",",str=""
	While(rs.Next()){
		//s str=str_"{""modeCode"":"""_rs.Data("StMode_Code")_""""_"},{""modeDesc"":"""_rs.Data("StMode_Desc")_""""_"},"
		s modeCode=rs.Data("StMode_Code")
	}
	d rs.Close()
	q $g(modeCode)
}

/// Creator   : wk
/// CreatDate : 2018-12-25
/// Desc      : 获取统计模式
/// Other     : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","GetStatModel")
Query GetStatModel() As websys.Query(ROWSPEC = "modeCode:%String:模式编码,modeDesc:%String:模式描述") [ SqlProc ]
{
}

ClassMethod GetStatModelExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s sql="select StMode_Code,StMode_Desc from DHCWL_ComplexRpt.StatMode where StMode_Flag='Y'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ^CacheTemp(repid,ind)=$lb(rs.Data("StMode_Code"),rs.Data("StMode_Desc"))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：     	hetong
/// CreatDate：    	2015-11-27
/// Description：	按照区间和报表配置条件查找值
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RowsColCfg,DHCWL_MKPI.DHCWLDeptKPIData
/// Input：       
/// Output：  		monId:%String:区间id,rptCode:%String:报表名称,kpiId:%String:指标id
/// 				rowDesc:%String:行条件,colDesc:%String:列条件,value:%String:值
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.ComplexRpt.ComplexRptFun","QueryReportData",15,,"2012-10-01","2012-10-05",,"O")
Query QueryReportData(rpt As %String, content As %String = "", startDate, endDate, choiceType = "freeDateChoice", isRealData = "") As websys.Query(ROWSPEC = "monId:%String,monDesc:%String,rptCode:%String,rptName:%String,rptContent:%String,kpiId:%String,dimId:%String,rowDesc:%String,colDesc:%String,value:%Float") [ SqlProc ]
{
}

ClassMethod QueryReportDataExecute(ByRef qHandle As %Binary, rpt As %String, content As %String = "", startDate, endDate, choiceType = "freeDateChoice", isRealData = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
    s ind=1
	q:(rpt="")!(startDate="")!(endDate="") $$$OK
	s startDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
	s startDate=$zd(startDate,3)
	s endDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
	s endDate=$zd(endDate,3)
	k ContentLoop
	/// 标记行列条件，并按照规则形成标准Query的入参
	i $d(^DHCWL.ComplexRpt.RptCfgD(rpt)){
		s rptId=rpt
		s rptCode=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),2) ;报表代码
	}else{
		q:'$d(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"))) $$$OK
		s rptCode=rpt
		s rptId=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(rpt,"U"),""))
		q:rptId="" $$$OK
	}
	s rptName=$lg(^DHCWL.ComplexRpt.RptCfgD(rptId),3) ;报表名称
	s rptcfg=$o(^DHCWL.ComplexRpt.RowsColCfgI("RCRptDr",rptId,""))
	q:rptcfg="" $$$OK
	s rptRow=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),5) ;行条件
	s rptCol=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),6) ;列条件
	s rptFilter=$lg(^DHCWL.ComplexRpt.RowsColCfgD(rptcfg),7) ;过滤条件
	s poolDr=0,kpiFilter="",mkpiCodeStr=""
	f {
		s poolDr=$o(^DHCWL.ComplexRpt.RptLinkMkpiI("LinkRptKpi",rptId,poolDr))
		q:poolDr=""
		s rptContent=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),4) ;统计内容
		continue:(content'="")&&(rptContent'=rptContent)
		s mkpi=$lg(^DHCWL.ComplexRpt.MKpiD(poolDr),2) ;指标ID
		continue:'$d(^DHCWL.MKPI.MKPID(+mkpi))
		s ContentLoop(mkpi)=rptContent
		s mkpiCode=$lg(^DHCWL.MKPI.MKPID(mkpi),2) ;指标代码
		i mkpiCodeStr=""  s mkpiCodeStr=mkpiCode
		e  s mkpiCodeStr=mkpiCodeStr_","_mkpiCode
		///形成过滤条件
		s filter=$Case(rptFilter,"":"",:mkpiCode_":("_rptFilter_")")
		i kpiFilter=""  s kpiFilter=filter
		e  s kpiFilter=kpiFilter_$Case(filter,"":"",:","_filter)
	}
	q:mkpiCodeStr="" $$$OK
	d ##class(DHCWL.ComplexRptData.RptService).SetTransDimPos(mkpiCodeStr,rptRow,rptCol,.dim,.kpiStr)
	////调用指标标准Query
	s rs=##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate")
	s sc=rs.Execute(kpiStr,startDate,endDate,choiceType,isRealData,kpiFilter)
	While rs.Next(.sc){
		/// monId,monDesc,kpiId,kpiCode,kpiDesc,dimId,dimDesc,value
		s monId=$g(rs.Data("monId"))
		s monDesc=$g(rs.Data("monDesc"))
		s kpiId=$g(rs.Data("kpiId"))
		s statContent=$g(ContentLoop(kpiId))
		s statContentDesc=##class(DHCWL.ComplexRptData.RptService).GetContentDesc(statContent)
		s kpiCode=$g(rs.Data("kpiCode"))
		s kpiDesc=$g(rs.Data("kpiDesc"))
		s dimId=$g(rs.Data("dimId"))
		s value=$g(rs.Data("value"))
		s dimDescStr=$g(rs.Data("dimDesc"))
		s rowDimDesc=$P(dimDescStr,",",1,$l(rptRow,","))
		d ##class(DHCWL.ComplexRptData.RptService).GetTransDim(kpiCode,dimDescStr,rptCol,.dim,.colDimDesc)
		d OutPutRow
	}
	Quit $$$OK
	
OutPutRow
	/// monId,monDesc,rptCode,kpiId,dimId,rowDesc,colDesc,value
	s Data=$lb(monId,monDesc,rptCode,rptName,statContentDesc,kpiId,dimId,rowDimDesc,colDimDesc,value)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

}
