/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 标准值维护
Class web.DHCWL.V1.CheckFun.CheckFunCfg Extends %RegisteredObject
{

/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 方案表格数据
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetProGram")
Query GetProGram(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述,section:%String:区间,dim:%String:维度,dimPro:%String:维度属性,kpiFlag:%String:已维护考核指标,date:%String:日期") [ SqlProc ]
{
}

ClassMethod GetProGramExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U") 
	s sql="select ID,CheckSet_Code,CheckSet_Desc,CheckSet_SectionType,CheckSet_ObjType,CheckSet_ObjDim,CheckSet_UpdateDate,CheckSet_UpdateUser from DHCWL_CheckFun.DHCWLCheckSet order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s code=rs.Data("CheckSet_Code")
		s desc=rs.Data("CheckSet_Desc")
		s section=rs.Data("CheckSet_SectionType")
		s setUpdateDate=rs.Data("CheckSet_UpdateDate")
		s setObjType=rs.Data("CheckSet_ObjType")
		s objDesc=$list(^DHCWL.MKPI.MKPIDimTypeD(setObjType),5)
		s setObjDim=rs.Data("CheckSet_ObjDim")
		s objDimDesc=""
		i setObjDim'="" s objDimDesc=$list(^DHCWL.MKPI.DimPropertyD(setObjDim),4)
		s id=rs.Data("ID")
		i $d(^DHCWL.CheckFun.SetKpiReI("Set",id)) s kpiFlag="是"
		e  s kpiFlag="否"
	    i setUpdateDate'="" s setUpdateDate=##class(websys.Conversions).DateLogicalToHtml(setUpdateDate)
	    continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(section,"U") '[ filterValue)&&($zcvt(objDesc,"U") '[ filterValue)&&($zcvt(objDimDesc,"U") '[ filterValue)&&($zcvt(kpiFlag,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(id,code,desc,section,objDesc,objDimDesc,kpiFlag,setUpdateDate)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-09-30
/// Desc      : 新增方案
/// Other     : do ##Class(web.DHCWL.V1.CheckFun.CheckFunCfg).AddCheckFunSet()
ClassMethod AddCheckFunSet(code, desc, section, dim, dimPro)
{
	q:((code="")||(desc="")||(section="")||(dim="")||(dimPro="")) "信息不全无法保存"
	q:$d(^DHCWL.CheckFun.CheckSetI("Code",$zcvt(code,"U"))) "编码重复啦,不能保存"
	s creator=$g(%session.Data("LOGON.USERNAME"))
	s updateDate=+$h
	&sql(INSERT INTO DHCWL_CheckFun.DHCWLCheckSet(CheckSet_Code,CheckSet_Desc,CheckSet_SectionType,CheckSet_ObjType,CheckSet_ObjDim,CheckSet_UpdateDate,CheckSet_UpdateUser) values(:code,:desc,:section,:dim,:dimPro,:updateDate,:creator))
	if (SQLCODE'=0){
		q "新增失败"_SQLCODE
	}
	q "新增成功"
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 方案修改
/// Other     : do ##Class(web.DHCWL.V1.CheckFun.CheckFunCfg).UpdateCheckFunSet()
ClassMethod UpdateCheckFunSet(ID, desc)
{
	q:'$d(^DHCWL.CheckFun.CheckSetD(ID)) "修改方案不存在"
	s SetUpdateDate=+$h
	s creator=$g(%session.Data("LOGON.USERNAME"))
	&sql(update DHCWL_CheckFun.DHCWLCheckSet set CheckSet_Desc=:desc,CheckSet_UpdateDate=:SetUpdateDate,CheckSet_UpdateUser=:creator where ID=:ID )
	if (SQLCODE'=0){
		q "更新失败"_SQLCODE
	}
	q "更新成功"
}

/// Creator   : wk
/// CreatDate : 2018-10-10
/// Desc      : 方案删除
/// Other     : do ##Class(web.DHCWL.V1.CheckFun.CheckFunCfg).DeleteCheckFunSet()
ClassMethod DeleteCheckFunSet(ID)
{
	q:$d(^DHCWL.CheckFun.StandardValSetI("Set",ID)) "方案下维护有标准值,不能删除"
	q:$d(^DHCWL.CheckFun.SetKpiReI("Set",ID)) "方案下维护有方案指标,不能删除"
	q:'$d(^DHCWL.CheckFun.CheckSetD(ID)) "方案获取失败"
	&sql(delete from DHCWL_CheckFun.DHCWLCheckSet where ID=:ID)
	if (SQLCODE'=0){
		q "保存失败"_SQLCODE
	}else{
		q "保存成功"
	}
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 所有指标展示
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetAllKPI")
Query GetAllKPI(checkFunID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetAllKPIExecute(ByRef qHandle As %Binary, checkFunID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
	s sql="select ID,CheckKPI_Code,CheckKPI_Desc from DHCWL_CheckFun.DHCWLCheckKPI a WHERE CheckKPI_Flag='Y' AND a.ID NOT IN (SELECT SetKpiRe_Kpi_Dr FROM DHCWL_CheckFun.DHCWLSetKpiRe WHERE SetKpiRe_Set_Dr="_checkFunID_") order by ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s code=rs.Data("CheckKPI_Code")
		s desc=rs.Data("CheckKPI_Desc")
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,code,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 获取方案指标
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetSelectKPI")
Query GetSelectKPI(checkFunID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,kpiID:%String:指标ID,code:%String:编码,desc:%String:描述") [ SqlProc ]
{
}

ClassMethod GetSelectKPIExecute(ByRef qHandle As %Binary, checkFunID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="SELECT a.ID,a.SetKpiRe_Kpi_Dr,b.CheckKPI_Code,b.CheckKPI_Desc FROM DHCWL_CheckFun.DHCWLSetKpiRe a,DHCWL_CheckFun.DHCWLCheckKPI b WHERE a.SetKpiRe_Kpi_Dr=b.ID AND a.SetKpiRe_Set_Dr="_checkFunID_" ORDER BY a.ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s kpiID=rs.Data("SetKpiRe_Kpi_Dr")
		s code=rs.Data("CheckKPI_Code")
		s desc=rs.Data("CheckKPI_Desc")
		continue:((filterValue'="")&&($zcvt(code,"U") '[ filterValue)&&($zcvt(desc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,kpiID,code,desc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 方案指标新增
/// Other     : do ##class(web.DHCWL.V1.CheckFun.CheckFunCfg).AddCheckFunRel()
ClassMethod AddCheckFunRel(kpiID, checkFunID)
{
	s dim("setId")=checkFunID
	s dim("relkpiId")=kpiID
	s dim("relUpdateUser")=$g(%session.Data("LOGON.USERNAME"))
	s tip=##class(DHCWL.CheckFunData.SaveData).AddCheckFunRel(.dim)
	if (tip="ok"){
		q "新增成功"
	}else{
		q "新增失败"_SQLCODE
	}
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 删除方案指标
/// Other     : do ##class(web.DHCWL.V1.CheckFun.CheckFunCfg).DeleteCheckFunRel()
ClassMethod DeleteCheckFunRel(ID)
{
	 s id=ID
     q:'$d(^DHCWL.CheckFun.SetKpiReD(id)) "请选择要删除的行"
	 s result="failure"
	 s kpiId=$list(^DHCWL.CheckFun.SetKpiReD(id),3)
	 s setId=$list(^DHCWL.CheckFun.SetKpiReD(id),2)
	 s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunStandValue(setId,kpiId)
	 q:result1'="ok" result
	 s staValueObj=##class(DHCWL.CheckFun.SetKpiRe).%OpenId(id)
	 s sc=##class(DHCWL.CheckFun.SetKpiRe).%DeleteId(id)
	 q:sc'=1 
	 s result="ok"
	 q result
}

/// Creator   : wk
/// CreatDate : 2018-10-08
/// CreatDesc : 标准值获取
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetEValue")
Query GetEValue(checkFunID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,value:%String:标准值,effDate:%String:生效日期,code:%String:指标编码,desc:%String:指标描述") [ SqlProc ]
{
}

ClassMethod GetEValueExecute(ByRef qHandle As %Binary, checkFunID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	s sql="select a.ID AS checkfunID,StandardValSet_KPI_Dr,StandardValSet_Value,StandardValSet_Date,b.CheckKPI_Code,b.CheckKPI_Desc from DHCWL_CheckFun.DHCWLStandardValSet a,DHCWL_CheckFun.DHCWLCheckKPI b where StandardValSet_Set_Dr ="_checkFunID_" AND a.StandardValSet_KPI_Dr=b.ID order by a.ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID = rs.Data("checkfunID")
		//s kpiID = rs.Data("StandardValSet_KPI_Dr")
		s value = rs.Data("StandardValSet_Value")
		s effDate = rs.Data("StandardValSet_Date")
		s kpiCode = rs.Data("CheckKPI_Code")
		s kpiDesc = rs.Data("CheckKPI_Desc")
		continue:((filterValue'="")&&($zcvt(value,"U") '[ filterValue)&&($zcvt(effDate,"U") '[ filterValue)&&($zcvt(kpiCode,"U") '[ filterValue)&&($zcvt(kpiDesc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(ID,value,effDate,kpiCode,kpiDesc)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-10
/// Desc      : 获取生效日期列表
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","EffectDateName")
Query EffectDate(checkfunID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "monID:%String:日期ID,monDesc:%String:日期描述") [ SqlProc ]
{
}

ClassMethod EffectDateExecute(ByRef qHandle As %Binary, checkfunID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	q:checkfunID="" $$$OK
	s secType=$list(^DHCWL.CheckFun.CheckSetD(checkfunID),4)
	s secId="" f  s secId=$o(^DHCWL.MKPI.SectionI("SecName",secType,secId)) q:secId=""  d
	.s monId="" f  s monId=$o(^DHCWL.MKPI.MonthsI("SectionFlag",secId,monId)) q:monId=""  d
	..s monDesc=$list(^DHCWL.MKPI.MonthsD(monId),2)
	..q:((filterValue'="")&&($zcvt(monId,"U") '[ filterValue)&&($zcvt(monDesc,"U") '[ filterValue))
	..s ^CacheTemp(repid,ind)=$lb(monId,monDesc)
	..s ind=ind+1
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 保存标准值
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","AddStandardValue")
ClassMethod AddStandardValue(checkfunID, kpiID, value, activeDate)
{
	s setId=checkfunID
	s kpiId=kpiID
	s nvalue=value
	s medate=activeDate
	q:('$d(^DHCWL.MKPI.MonthsI("Code",medate))) "生效日期非法,只能选择下拉框内容保存"
	s updateDate=+$h
	s updateUser=$g(%session.Data("LOGON.USERNAME"))
	q:((setId="")||(kpiId="")||(nvalue="")||(medate="")) "保存信息不全,无法保存"
	s edate=$g(medate)
	s edate=" "_edate
	q:$d(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,edate)) "当前配置信息已存在"
	&sql(INSERT INTO DHCWL_CheckFun.DHCWLStandardValSet(StandardValSet_Set_Dr,StandardValSet_KPI_Dr,StandardValSet_Value,StandardValSet_Date,StandardValSet_UpdateDate,StandardValSet_UpdateUser) values(:setId,:kpiId,:nvalue,:medate,:updateDate,:updateUser))
	if (SQLCODE'=0){
		q "保存失败"_SQLCODE
	}else{
		q "保存成功"
	}
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 更新标准值
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","UpdateStandardValue")
ClassMethod UpdateStandardValue(id, value)
{
	q:(id="")||(value="") "保存信息不能为空"
	s nvalue=value
	s updateDate=+$h
	s updateUser=$g(%session.Data("LOGON.USERNAME"))
	q:'$d(^DHCWL.CheckFun.StandardValSetD(id)) "请选择要更新的行"
	&sql(update DHCWL_CheckFun.DHCWLStandardValSet set StandardValSet_Value=:nvalue,StandardValSet_UpdateDate=:updateDate,StandardValSet_UpdateUser=:updateUser where ID=:id)
	if (SQLCODE'=0){
		q "更新失败"_SQLCODE
	}
	q "更新成功"
}

/// Creator   : wk
/// CreatDate : 2018-10-10
/// Desc      : 删除标准值
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","DeleteStandardValue")
ClassMethod DeleteStandardValue(id)
{
	q:'$d(^DHCWL.CheckFun.StandardValSetD(id)) "请选择要删除的行"
	q:$d(^DHCWL.CheckFun.ExceptValSetI("Stand",id)) "请先删除对应的例外值后再进行操作"
	&sql(delete from DHCWL_CheckFun.DHCWLStandardValSet where ID=:id)
	if (SQLCODE'=0){
		q "更新失败"_SQLCODE
	}
	q "更新成功"
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 获取例外值
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetExceptValue")
Query GetExceptValue(checkfunID As %String = "", standID As %String = "", filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,obj:%String:对象,excepValue:%String:例外值") [ SqlProc ]
{
}

ClassMethod GetExceptValueExecute(ByRef qHandle As %Binary, checkfunID As %String = "", standID As %String = "", filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:((checkfunID="")||(standID="")) $$$OK
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(checkfunID)
	s sql="SELECT ID,ExpValSet_Obj_Dr,ExpValSet_Value FROM DHCWL_CheckFun.DHCWLExceptValSet WHERE ExpValSet_Std_Dr="_standID
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s ID=rs.Data("ID")
		s objDr=rs.Data("ExpValSet_Obj_Dr")
		s value=rs.Data("ExpValSet_Value")
		s desc=$g(^TEMPDHCWL("objId",objDr))
		continue:(filterValue'="")&&($zcvt(desc,"U") '[ filterValue)&&($zcvt(value,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,desc,value)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 获取考核对象
/// Other     : d ##class(%ResultSet).RunQuery("web.DHCWL.V1.CheckFun.CheckFunCfg","GetAssessObj")
Query GetAssessObj(checkfunID As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,objDesc:%String:考核对象描述") [ SqlProc ]
{
}

ClassMethod GetAssessObjExecute(ByRef qHandle As %Binary, checkfunID As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:checkfunID="" ""
	s:filterValue'="" filterValue=$zcvt(filterValue,"U")
	d ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(checkfunID,"")
	s ID=0
	for {
		s ID=$o(^TEMPDHCWL("objId",ID))
		q:ID=""
		s ItemDesc=$g(^TEMPDHCWL("objId",ID))
		i ItemDesc[$c(13,10) s ItemDesc=$tr(ItemDesc,$c(13,10),"")
		continue:(filterValue'="")&&(ID '[ filterValue)&&($zcvt(ItemDesc,"U") '[ filterValue)
		s ^CacheTemp(repid,ind)=$lb(ID,ItemDesc)
		s ind=ind+1
	}
	k ^TEMPDHCWL("objId")
	Quit $$$OK
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 获取方案指标
/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 保存例外值
/// Other     : do ##class(web.DHCWL.V1.CheckFun.CheckFunCfg).AddexceptValue()
ClassMethod AddexceptValue(standID, objID, value)
{
	s dim("extraId")=standID
	s dim("value")=value
	s dim("objId")=objID
	s dim("extradateUser")=$g(%session.Data("LOGON.USERNAME"))
	s tip=##class(DHCWL.CheckFunData.SaveData).AddexceptValue(.dim)
	q:tip="ok" "保存成功"
	q tip
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 更新例外值
/// Other     : do ##class(web.DHCWL.V1.CheckFun.CheckFunCfg).UpdateExceptValue()
ClassMethod UpdateExceptValue(value, exceptID)
{
	q:((value="")||(exceptID="")) "保存信息不完整,无法保存"
	s extraUpdateDate=+$h
	s extradateUser=$g(%session.Data("LOGON.USERNAME"))
	&sql(update DHCWL_CheckFun.DHCWLExceptValSet set ExpValSet_Value=:value,ExpValSet_UpdateDate=:extraUpdateDate,ExpValSet_UpdateUser=:extradateUser where ID=:exceptID)
	if (SQLCODE'=0){
		q "更新失败"_SQLCODE
	}else{
		q "更新成功"
	}
}

/// Creator   : wk
/// CreatDate : 2018-10-09
/// Desc      : 删除例外值
/// Other     : do ##class(web.DHCWL.V1.CheckFun.CheckFunCfg).DeleteexceptValue()
ClassMethod DeleteexceptValue(exceptID)
{
	s dim("ID")=exceptID
	s tip=##class(DHCWL.CheckFunData.SaveData).DeleteExceptValue(.dim)
	if (tip="ok"){
		q "删除成功"
	}else{
		q tip
	}
}

}
