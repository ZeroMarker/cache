Class DHCWL.BaseDataQuery.Util Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
ClassMethod Insert(ByRef data) As %String
{
	n (data)
	q:data("kpiCode")="" "指标代码不能为空！"
	q:data("kpiName")="" "指标名称不能为空！"
	//首先判断指标代码是否已经存在。
	i $d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(data("kpiCode"),"U")))  q "指标代码"_data("kpiCode")_"已经存在!"
	s kpi=##class(DHCWL.MKPI.MKPI).%New(),dimId="",catId="",sectId=""
	s kpi.MKPICode=$g(data("kpiCode"))
	s:$g(data("kpiName"))'="" kpi.MKPIName=$g(data("kpiName"))
	s:$g(data("createUser"))'="" kpi.MKPIUser=data("createUser")
	s:$g(data("kpiDesc"))'="" kpi.MKPIDesc=data("kpiDesc")
	s:$g(data("nodeMark"))'="" kpi.MKPIRemark=$g(data("nodeMark"))
	s:$g(data("kpiExcode"))'="" kpi.MKPIEXCode=data("kpiExcode")
	s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=$zdh(data("updateDate"),3)
	s:$g(data("dataNode"))'="" kpi.MKPIDataNod=data("dataNode")
	s:$g(data("nodeMark"))'="" kpi.MKPIRemark=data("nodeMark")
	s kpi.MKPIGlobalFlag=$g(data("globalFlag"))
	s kpi.MKPIGetValueType=$g(data("getValueType"))

	;i $g(data("dimType"))'="" &sql(select ID into :dimId from DHCWL_MKPI.DHCWLMKPIDimType where KDT_Name=:data("dimType"))
	i $g(data("category"))'="" &sql(select ID into :catId from DHCWL_MKPI.DHCWLMKPIFL where MKPIFL_Name=:data("category"))
	i $g(data("section"))'="" &sql(select ID into :sectId from DHCWL_MKPI.DHCWLSection where Sec_Name=:data("section"))
	;i (data("dimType"))&&(dimId="")  q "无此维度，请先创建！"
	i (data("category"))&&(catId="")  q "无此类型指标，请先创建！"
	i (data("section"))&&(sectId="")  q "无此区间指标，请先创建！"
	;s:dimId'="" kpi.MKPITypeDr=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId)
	s:catId'="" kpi.MKPICate=##class(DHCWL.MKPI.MKPIFL).%OpenId(catId)
	s:sectId'="" kpi.MKPISectionFlag=##class(DHCWL.MKPI.Section).%OpenId(sectId)
	s sc=kpi.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}
*/

/*
ClassMethod Update(id, ByRef data)
{
	n (id,data)
	q:data("kpiName")="" "指标名称不能为空！"
	s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(id),dimId="",catId="",sectId=""
	i kpi=""  q "不存在该指标，请重选！"

	;add by wz.2015-7-5.删除指标时也删除运算关系表达式
	if ((kpi.MKPIGetValueType'=$g(data("getValueType"))) && (kpi.MKPIGetValueType=2)) {
		s result=##class(DHCWL.MKPI.CalExpDef).DelCalExpByKPIIDs(id)
		i result'="ok" {
			w "{success:true,tip:'"_result_"'}"
			s hasError=1
			q
		}
	}
	
	
	if kpi.MKPICode'=$g(data("kpiCode")) q "指标编码不允许修改"
	s kpi.MKPICode=$g(data("kpiCode"))
	s:$g(data("kpiName"))'="" kpi.MKPIName=$g(data("kpiName"))
	s kpi.MKPIUser=$g(data("createUser"))
	s kpi.MKPIDesc=$g(data("kpiDesc"))
	s kpi.MKPIRemark=$g(data("nodeMark"))
	s kpi.MKPIEXCode=$g(data("kpiExcode"))
	s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=$zdh(data("updateDate"),3)
	s kpi.MKPIRemark=$g(data("nodeMark"))
	s kpi.MKPIDataNod=$g(data("dataNode"))
	s kpi.MKPIGlobalFlag=$g(data("globalFlag"))
	s kpi.MKPIGetValueType=$g(data("getValueType"))
	;s:$g(data("section"))'="" kpi.MKPISectionFlag=data("section")
	;&sql(select ID into :dimId from DHCWL_MKPI.DHCWLMKPIDimType where KDT_Name=:data("dimType"))
	&sql(select ID into :catId from DHCWL_MKPI.DHCWLMKPIFL where MKPIFL_Name=:data("category"))
	&sql(select ID into :sectId from DHCWL_MKPI.DHCWLSection where Sec_Name=:data("section"))
	;i (data("dimType"))&&(dimId="")  q "无此维度，请先创建！"
	i (data("category"))&&(catId="")  q "无此类型指标，请先创建！"
	i (data("section"))&&(sectId="")  q "无此区间指标，请先创建！"
	;s:dimId'="" kpi.MKPITypeDr=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId)
	if ((kpi.MKPISectionFlag'="")&&(kpi.MKPISectionFlag.%Id()'=sectId)){
		&sql(select ID into:taskId from DHCWL_MKPI.DHCWLCreatDataTask where DTask_KPI_DR=:id)
		if +$g(taskId)'=0 {
			q "该指标已经设置了指标任务，不能再修改指标区间属性了！"
		}
	}
	s:catId'="" kpi.MKPICate=##class(DHCWL.MKPI.MKPIFL).%OpenId(catId)
	s:sectId'="" kpi.MKPISectionFlag=##class(DHCWL.MKPI.Section).%OpenId(sectId)
	;s:+dimId=0 kpi.MKPITypeDr=""
	s:+catId=0 kpi.MKPICate=""
	s:+sectId=0 kpi.MKPISectionFlag=""
	s sc=kpi.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}
*/

/*

ClassMethod Delete(id) As %String
{
	n (id)
	q:id="" "请选择删除已经存在的指标！"
	&sql(delete from DHCWL_MKPI.DHCWLCreatDataTask where DTask_KPI_DR=:id)
	&sql(delete from DHCWL_MKPI.DHCWLMKPIDim where MKPI_Dr=:id)
	s sc=##class(DHCWL.MKPI.MKPI).%DeleteId(id)
	i sc=1  q "ok"
	e  q "删除失败！"
}
*/

/*
ClassMethod GetObjsByClassName(className, st As %Integer, ed As %Integer, ByRef searchCond) As DHCWL.util.Json
{
	n (className,st,ed,searchCond)
	s paraList="",sqlFieldName=""

	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	
	s sqlTableName=cdef.SqlTableName
	if $g(sqlTableName)="" {
		s len=$l(className,".")
		s sqlTableName=$p(className,".",len)
	}

 	Set count = cdef.Properties.Count()
 	s deli="&",TF=""  //TF标示属性和字段的对应关系//add by lhh@20130221
 	For i = 1:1:count-1 d
	.s paraList=paraList_cdef.Properties.GetAt(i).Name_deli
	.s PV(cdef.Properties.GetAt(i).SqlFieldName)=cdef.Properties.GetAt(i).Type
	.s sqlFieldName=sqlFieldName_cdef.Properties.GetAt(i).SqlFieldName_","
	.s TF(cdef.Properties.GetAt(i).Name)=cdef.Properties.GetAt(i).SqlFieldName //add by lhh@20130221
	s paraList=paraList_cdef.Properties.GetAt(count).Name
	s sqlFieldName=sqlFieldName_cdef.Properties.GetAt(count).SqlFieldName
	s TF(cdef.Properties.GetAt(count).Name)=cdef.Properties.GetAt(count).SqlFieldName
	s PV(cdef.Properties.GetAt(count).SqlFieldName)=cdef.Properties.GetAt(count).Type
	s json=##class(DHCWL.util.Json).Json("ID"_deli_paraList,"totalNums","root",deli)
	s pageSize=ed-st
	//add by lhh@20130221
	s sqlSearch="  ",flagNum=0
	i (1=1)||($o(searchCond(""))'="") d
	.s tempF="" f  s tempF=$o(searchCond(tempF)) q:tempF=""  d
	..i ($g(TF(tempF))'="")&&($g(searchCond(tempF))'="") d
	...s flagNum=flagNum+1
	...s sqlSearch=sqlSearch_$case(flagNum,1:" ",:" and ")_" "_TF(tempF)_" like '%"_..FormateDateh(PV(TF(tempF)),searchCond(tempF))_"%'"
	i flagNum>0 s sqlSearch=" where "_sqlSearch
	s sqlStr="select ID,"_sqlFieldName_"  from "_..GetSchema(className)_"."_sqlTableName_sqlSearch
	;q sqlStr
	;s sqlStr="select KDT_Code,KDT_Desc,KDT_EXCode,KDT_Name,KDT_Remark,KDT_UpdateDate,KDT_User  from DHCWL_MKPI.DHCWLMKPIDimType where     KDT_Code like '%Doc%' and  KDT_Desc like '%医生%' and  KDT_EXCode like '%GetDocName^DHCWLBuildDimData%' and  KDT_Name like '%医生%' and  KDT_User like '%卢晓春%'"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sqlStr)
	d rs.Execute()
	s num=0
	While(rs.Next()){
		s num=num+1
		i (st+pageSize'=0)&&(num<(st)) continue
		i (st+pageSize'=0)&&((st+pageSize)<num) continue
		s temp=""
		f i=1:1:count-1 d
		.s para=$p(sqlFieldName,",",i)
		.s mark=..IsString(PV(para))
		.s temp=temp_mark_..FormateDate(PV(para),rs.Data(para))_mark_deli
		s para=$p(sqlFieldName,",",count)
		s mark=..IsString(PV(para))
		s temp=temp_mark_..FormateDate(PV(para),rs.Data(para))_mark
		s temp=rs.Data("ID")_deli_temp
		d json.Insert(temp)
	}
	d json.SetTotalNum(num)
	q json
}
*/

/*
ClassMethod AddDimType(ByRef dim) As %String
{
	n (dim)
	s dimCode=$g(dim("KDTCode"))
	i dimCode="" q "维度代码不能为空！"
	i $g(dim("KDTName"))="" q "维度名称不能为空！"
	s postId=$g(dim("ID"))
	s id=..GetDimIdByCode(dimCode)
	i (postId'="")&&(+id'=+postId) q "维度代码不能修改！"
	i (postId="")&&(+id'=0) q "维度代码不能重复！"
	if (+id=0) {
		s dimObj=##class(DHCWL.MKPI.MKPIDimType).%New()
	}else {
		s dimObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(id)
	}
	i (postId'="")&&(dimObj.KDTCode'=dimCode) q "维度代码不能修改！"
	s dimObj.KDTCode=$g(dimCode)
	s dimObj.KDTName=$g(dim("KDTName"))
	s dimObj.KDTDesc=$g(dim("KDTDesc"))
	s dimObj.KDTExeCode=$g(dim("KDTExeCode"))
	s dimObj.KDTRemark=$g(dim("KDTRemark"))
	s:$g(dim("KDTUpdateDate"))'="" dimObj.KDTUpdateDate=$zdh($g(dim("KDTUpdateDate")),3)
	s dimObj.KDTUser=$g(dim("KDTUser"))
	s sc=dimObj.%Save()
	i sc=1 q "ok"
	q "维度保存失败！"
}

ClassMethod DeleteDimType(dimCode) As %String
{
	n (dimCode)
	s id=..GetDimIdByCode(dimCode)
	i +id=0 q "ok"
	s sc=##class(DHCWL.MKPI.MKPIDimType).%DeleteId(id)
	i sc=1 q "ok"
	q "维度删除失败！"
}

/// s dim("KDTCode")="lhhTest"
/// w ##class(web.DHCWL.KPI.MaintainKpi).AddKpifl(.dim)
ClassMethod AddKpifl(ByRef dim) As %String
{
	n (dim)
	s MKPIFLCode=$g(dim("MKPIFLCode"))
	i MKPIFLCode="" q "分类代码不能为空！"
	i $g(dim("MKPIFLName"))="" q "维度分类名称不能为空！"
	s postId=$g(dim("ID"))
	s id=..GetKpiflByCode(MKPIFLCode)
	i (postId'="")&&(+id'=+postId) q "指标分类代码不能修改！"
	i (postId="")&&(+id'=0) q "指标分类代码不能重复！"
	//存在就打开表示更新，不存在表示是新建。
	if (+id=0) {
		s dimObj=##class(DHCWL.MKPI.MKPIFL).%New()
	}else {
		s dimObj=##class(DHCWL.MKPI.MKPIFL).%OpenId(id)
	}
	i (postId'="")&&(dimObj.MKPIFLCode'=MKPIFLCode) q "指标分类代码不能修改！"
	s dimObj.MKPIFLCode=$g(MKPIFLCode)
	s dimObj.MKPIFLName=$g(dim("MKPIFLName"))
	s dimObj.MKPIFLDesc=$g(dim("MKPIFLDesc"))
	s dimObj.MKPIFLUser=$g(dim("MKPIFLUser"))
	s dimObj.MKPIFLRemark=$g(dim("MKPIFLRemark"))
	s:$g(dim("MKPIFLUpdateDate"))'="" dimObj.MKPIFLUpdateDate=$zdh($g(dim("MKPIFLUpdateDate")),3)
	s sc=dimObj.%Save()
	i sc=1 q "ok"
	q "维度保存失败！"
}

ClassMethod AddKpiSec(ByRef sec) As %String
{
	n (sec)
	s SecCode=$g(sec("SecCode"))
	i SecCode="" q "区间代码不能为空！"
	s enforce=$g(sec("enforce"))
	s postId=$g(sec("ID"))
	i $g(sec("SecName"))="" q "指标区间名称不能为空！"
	s id=..GetKpiSecByCode(SecCode)
	i (postId'="")&&(+id'=+postId) q "指标区间代码不能修改！"
	i (+postId=0)&&(+id'=0) q "指标区间代码不能重复！"
	s canTId=+$g(sec("SecDirectParent"))
	i canTId=0  s parentId=..GetKpiSecByCode($g(sec("SecDirectParent")))
	e  s parentId=canTId
	i (+parentId>0)&&('$d(^DHCWL.MKPI.SectionD(parentId))) s parentId=0
	s num=0
	s secId=""  f  s secId=$o(^DHCWL.MKPI.SectionD(secId)) q:secId=""  d
	.s tempParentId=$lg(^DHCWL.MKPI.SectionD(secId),8,"")
	.i +tempParentId=0 s num=num+1   //找根节点的个数
	i (+enforce=1)&&(num>0)&&(parentId=0) q "区间只允许一个为最大区间（直接父节点为空）其他区间必须为某一个区间的子区间"
	//存在就打开表示更新，不存在表示是新建。
	if (+id=0) {
		s secObj=##class(DHCWL.MKPI.Section).%New()
	}else {
		s secObj=##class(DHCWL.MKPI.Section).%OpenId(id)
	}
	i (+postId'=0)&&((secObj.SecCode)'=SecCode)  q "id="_id_"指标区间代码不能修改！code="_SecCode_"id="_secObj.%Id()
	s:+postId=0 secObj.SecCode=$g(SecCode)
	s:$g(sec("SecName"))'="" secObj.SecName=$g(sec("SecName"))
	;s:$g(sec("SecDesc"))'="" secObj.SecDesc=$g(sec("SecDesc"))			;-- modify by wz.处理BUG34
	;s:$g(sec("SecUser"))'="" secObj.SecUser=$g(sec("SecUser"))			;-- modify by wz.处理BUG34
	;s:$g(sec("SecRemark"))'="" secObj.SecRemark=$g(sec("SecRemark"))	;-- modify by wz.处理BUG34
	s secObj.SecUser=$g(sec("SecUser"))			;++ modify by wz.处理BUG34
	s secObj.SecRemark=$g(sec("SecRemark"))		;++ modify by wz.处理BUG34	
	s secObj.SecDesc=$g(sec("SecDesc"))			;++ modify by wz.处理BUG34
	s:$g(sec("SecUpdateDate"))'="" secObj.SecUpdateDate=$zdh($g(sec("SecUpdateDate")),3)
	i parentId>0 s secObj.SecDirectParent=##class(DHCWL.MKPI.Section).%OpenId(parentId)
	e  s secObj.SecDirectParent=""
	s sc=secObj.%Save()
	i (+enforce=1)&&(##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.tempSec)=0) {
		s secObj.SecDirectParent=""
		d secObj.%Save()
		i +postId=0 {
			s newId=..GetKpiSecByCode(SecCode)
			d:+newId>0 ##class(DHCWL.MKPI.Section).%DeleteId(newId)
		}
		q "指标区间之间的父子关系维护不正确，要像链表一样。"
	}
	i sc=1 {
		s id=secObj.%Id(),code=$g(sec("SecDesc"))
		&sql(update DHCWL_MKPI.DHCWLCreatDataTask set DTask_Section_DR=:id where DTask_MonthExcuteCode=:code )
		q "ok"
	}
	q "维度保存失败！"
}
*/

/*
/// w ##class(web.DHCWL.KPI.MaintainKpi).DeleteKpiSec("test")
ClassMethod DeleteKpiSec(secCode, flag = 0) As %String
{
	n (secCode,flag)
	s id=..GetKpiSecByCode(secCode)
	i +id=0 q "不存在该区间！"
	i $d(^DHCWL.MKPI.CreatDataTaskI("Section",id)) {
		q "该任务区间下已经存在该区间，删除后会影响指标任务，请进行更新操作！"
	}
	q:+flag=0 "ok"
	&sql(update DHCWL_MKPI.DHCWLSection set Sec_DirectParent='' where Sec_DirectParent=:id)
	&sql(update DHCWL_MKPI.DHCWLMKPI set MKPI_SectionFlag='' where MKPI_SectionFlag=:id)
	&sql(delete from DHCWL_MKPI.DHCWLSection where ID=:id)
	;q SQLCODE
	s sc=1
	;s sc=##class(DHCWL.MKPI.Section).%DeleteId(id)
	i SQLCODE'=0 q "区间删除失败！"_SQLCODE
	e  q "ok"
}

ClassMethod DeleteKpiSecWidthTask(secCode) As %String
{
	n (secCode)
	s id=..GetKpiSecByCode(secCode)
	i +id=0 q "不存在该区间！"
	&sql(delete from DHCWL_MKPI.DHCWLCreatDataTask where DTask_Section_DR=:id)
	;&sql(update DHCWL_MKPI.DHCWLCreatDataTask set  DTask_Section_DR='' where DTask_Section_DR=:id)
	i SQLCODE'=0 q "任务删除失败！"_SQLCODE
	&sql(update DHCWL_MKPI.DHCWLMKPI set MKPI_SectionFlag='' where MKPI_SectionFlag=:id)
	&sql(update DHCWL_MKPI.DHCWLSection set Sec_DirectParent='' where Sec_DirectParent=:id)
	&sql(delete from DHCWL_MKPI.DHCWLSection where ID=:id)
	;q SQLCODE
	;s sc=1
	;s sc=##class(DHCWL.MKPI.Section).%DeleteId(id)
	i SQLCODE'=0 q "区间删除失败！"_SQLCODE
	e  q "ok"
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetKpiSecByCode("test")
ClassMethod DeleteKpifl(dimCode) As %String
{
	n (dimCode)
	s id=..GetKpiflByCode(dimCode)
	i +id=0 q "ok"
	s sc=##class(DHCWL.MKPI.MKPIFL).%DeleteId(id)
	i sc=1 q "ok"
	q "维度删除失败！"
}

ClassMethod GetKpiflByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.MKPI.MKPIFLI("FLCode",$SYSTEM.SQL.ALPHAUP(code),""))
	q id
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetKpiSecByCode("Q")
ClassMethod GetKpiSecByCode(code) As %String
{
	
	n (code)
	q:code="" ""
	q:'$d(^DHCWL.MKPI.SectionI("SecCode",$zcvt(code,"U"))) ""
	s id=$o(^DHCWL.MKPI.SectionI("SecCode",$zcvt(code,"U"),""))
	q id
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetMonthIdOfTask("16","D")
ClassMethod GetMonthIdOfTask(kpiId, sec) As %String
{
	n (kpiId,sec)
	q:(sec="")||(kpiId="") ""
	i '$d(^DHCWL.MKPI.MKPID(kpiId)) s kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiId)
	s monId=""
	s secId=..GetKpiSecByCode(sec)
	if '$d(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId)) q 0
	s active=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,""))
	s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("SectionKPI",secId,kpiId,active,""))
	s exCode=$li(^DHCWL.MKPI.CreatDataTaskD(taskId),3)
	q:exCode="" "null"
	s exCode="s monId=$$"_exCode_"()"
	;q exCode
	x exCode
	q monId
}

ClassMethod GetKpiData(kpiId As %Text, monthId As %Text, isReal, colNames, deli) As DHCWL.util.Json
{
	n (kpiId,monthId,isReal,colNames,deli)
	i (+monthId=0)||(kpiId="") q ""
	s rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:QueryKpiById",kpiId,monthId,isReal)
	s id=1,cols=rs.GetColumnCount()
	s colNum=$l(colNames,deli),title=""
	f i=1:1:colNum d
	.s cols(i,$p($p(colNames,deli,i),":",1))=$p($p(colNames,deli,i),":",2)
	.s title=title_$p($p(colNames,deli,i),":",1)_deli
	s json=##class(DHCWL.util.Json).Json($e(title,1,$l(title)-1),"result","root",deli) ;*-1),"result","root",deli)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s queryData("data")=""
		;s col="" f  s col=$o(cols(col)) q:col=""  d
		s col=""
		f i=1:1:colNum d
		.s col=$o(cols(i,""))
		.s queryData("data")=queryData("data")_$$TypeString(cols(i,col))_$case(rs.Data(col),"":0,:rs.Data(col))_$$TypeString(cols(i,col))_deli
		.;b ;001
		d json.Insert(queryData("data"))
	}
	q json
TypeString(type)
	i ($g(type)="") ||($g(type) [ "%String") q "'"
	q ""
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetDimIdByCode("Loc")
ClassMethod GetDimIdByCode(dimCode)
{
	n (dimCode)
	s id=0
	f {
		s id=$o(^DHCWL.MKPI.MKPIDimTypeD(id))
		q:id=""
		i $zcvt($list(^DHCWL.MKPI.MKPIDimTypeD(id),2),"U")=$zcvt(dimCode,"U")  q
	}
	q id
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).GetSchema("web.DHCWL.KPI.MaintainKpi")
ClassMethod GetSchema(className) As %String
{
	n (className)
	s pn=$l(className,"."),schema=""
	i pn<2 d
	.s schema="SQLUser"
	e  d
	.s temp=$p(className,".",1,pn-1)
	.f i=1:1:$l(temp) d
	..i $e(temp,i)="."  d
	...s schema=schema_"_"
	..e  d
	...s schema=schema_$e(temp,i)
	q schema
}

/// w ##class(web.DHCWL.KPI.MaintainKpi).IsString("%String")
ClassMethod IsString(type) As %String
{
	n (type)
	q "'"
	i (type[ "String")||(type [ "%Date")||(type [ "DHCWL" )  q "'"
	e  q ""
}

ClassMethod FormateDate(type, date) As %String
{
	n (type,date)
	i type ["%Date" {
		q $zd(+date,3)
	}elseif type [ "Section" {
		i (+$g(date)'=0)&&($d(^DHCWL.MKPI.SectionD(date))) {
			i 'type [ "DHCWL.MKPI" s type="DHCWL.MKPI."_type
			s exe="s exeObj=##class("_type_").%OpenId("_$g(date)_")"
			x "  "_exe
			i $g(exeObj)'="" q exeObj.SecCode
			else  q date
		}else {
			q $g(date)
		}
	}else {
		 q date
	}
}

ClassMethod FormateDateh(type, date) As %String
{
	n (type,date)
	i type ["%Date" q $zdh(date,3)
	e  q date
}

/// w ##class(lhh.util.UniteQueryDate).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:QueryMKPIByDate",)
ClassMethod GetQueryDateRef(query, paras... As %List) As %ResultSet
{
	n (query,paras)
	;s queryData=""
	set rs=##class(%ResultSet).%New(query)  ;("Sample.Person:ByName")
	s paraStr="" f i = 1 : 1 : $GET(paras, 0) d
	.s paraStr=paraStr_""""_$g(paras(i))_""","
	s paraStr=$e(paraStr,1,$l(paraStr)-1),sc=""  ;*-1),sc=""
	s str="set sc=rs.Execute("_paraStr_")"
	xecute str
	i $$$ISERR(sc) q 0
	q rs
}
*/
/// 根据类全名，搜索对应的表信息，返回得到给定范围内的Json数据
/// s json=##class(web.DHCWL.KPI.MaintainKpi).GetObjsByClassName("DHCWL.MKPI.Section",1,6)
/// s dim("KDTCode")="lhhTest"
/// w ##class(web.DHCWL.KPI.MaintainKpi).AddDimType(.dim)
ClassMethod GetErrorText(st)
{
	n (st)
	s errorText=""
	Do DecomposeStatus^%apiOBJ(st,.err,"-d") 
	For i=1:1:err {
		i errorText'="" s errorText=errorText_","_err(i)
		e  s errorText=err(i)
	}	
	q errorText
	
	//$System.Status.GetErrorText(st)
}

/*
ClassMethod getItemByQryName(ByRef inParam, ByRef outParam) As %String
{
	n (inParam,outParam)
	s $zt="SQLErr"
	k outParam
	s ret=""
	s objName=inParam("qryObjName")
	s itemType=$g(inParam("itemType"))
	s Sql=""
	if itemType="" {
		s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"'"
	}else{
		if itemType="dim"	//查询维度统计项
		{
			s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"' AND (Type ='维度' OR Type IS NULL)"
		}
		if itemType="measure"	//查询度量统计项
		{
			s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"' AND Type ='度量'"
		}
	}
	//w !,Sql
	s Rs=##class(%Library.ResultSet).%New()
	s st=Rs.Prepare(Sql) 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	s st=Rs.Execute() 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	
	while(Rs.Next()) {
		s ID=Rs.Data("ID")
		s name=Rs.Data("Name")
		s descript=Rs.Data("Descript")
		s dimCode=Rs.Data("LinkDimCode")
		s outParam(ID)=name_"^"_descript_"^"_dimCode
	}
	d Rs.Close()
	q ret
		
SQLErr
	if ret="" s ret="getItemByQryName:未知错误!"
	q ret
}
*/
ClassMethod getItemByQryName(ByRef inParam, ByRef outParam) As %String
{
	n (inParam,outParam)
	s $zt="SQLErr"
	k outParam
	s ret=""
	s objName=inParam("qryObjName")
	s itemType=$g(inParam("itemType"))
	
	
	s Sql=""
	if itemType="" {
		s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"'"
	}else{
		if itemType="dim"	//查询维度统计项
		{
			s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"' AND (Type ='维度' OR Type IS NULL)"
		}
		if itemType="measure"	//查询度量统计项
		{
			s Sql="SELECT ID, Name, ifnull(Descript,Name,Descript) AS Descript, LinkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName ='"_objName_"' AND Type ='度量'"
		}
	}
	//w !,Sql
	s Rs=##class(%Library.ResultSet).%New()
	s st=Rs.Prepare(Sql) 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	s st=Rs.Execute() 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	
	while(Rs.Next()) {
		s ID=Rs.Data("ID")
		s name=Rs.Data("Name")
		s descript=Rs.Data("Descript")
		s dimCode=Rs.Data("LinkDimCode")
		s outParam(ID)=name_"^"_descript_"^"_dimCode
	}
	d Rs.Close()
	q ret
		
SQLErr
	if ret="" s ret="getItemByQryName:未知错误!"
	q ret
}

ClassMethod getPropertys(ByRef inParam, ByRef outParam) As %String
{
	n (inParam,outParam)
	s ret=""
	//1、通过查询对象得到主题标识
	
	//2.1、循环访问统计项表(DHCWL_BaseDataQuery.Item)记录。
	//	取出ID,Name,Descript
	
	
	//2.2、根据主题标识，主题维表编码取到主维对象GetDimId(themeId, code)
	
	//2.3、根据主维对象，取到基础维度GetLinkDim
	
	//2.4、把基础维度ID赋值给LinkDimCode字段	
	s itemName=inParam("itemName")
	s qryObjName=inParam("qryObjName")
	//1、通过查询对象名称和统计项名称得到统计项对象
	s itemObj=##class(DHCWL.BaseDataQuery.Item).GetItem(qryObjName,itemName)
	s baseDimPath=itemObj.LinkDimCode	//基础维度的path
	//2、得到基础维度对象
	s baseDimObj=##class(DHCWL.DM.T.DimBase).GetByPath(baseDimPath)
	//s baseDimID=##class(DHCWL.DM.T.DimBase).GetIdByPath(baseDimPath)
	s baseDimID=baseDimObj.%Id()
	//3、得到基础维度属性列表
	s lstPros=baseDimObj.GetProperties()
	s lstCnt=lstPros.Count()
	f pos=1:1:lstCnt {
		
		s Code=lstPros.GetAt(pos).Code	//属性编码
		s Name=lstPros.GetAt(pos).Name	//属性名称
		s ID=lstPros.GetAt(pos).%Id()
		s outParam(ID)=itemName_"^"_Code_"^"_Name
	}
	
	q ret
	//s $zt="SQLErr"
	/*
	k outParam
	s ret=""
	s itemName=inParam
	s Sql="SELECT t2.Name AS itemName ,t1.ID,t1.DimPro_Code,t1.DimPro_Name FROM DHCWL_MKPI.DHCWLDimProperty t1 ," 
 	s Sql=Sql_"DHCWL_BaseDataQuery.Item t2 WHERE t1.dimpro_dimdr->KDT_CODE = t2.LinkDimCode AND t2.LinkDimType='标准维度'"
 	s Sql=Sql_"AND t2.Name='"_itemName_"'"
 	s Sql=Sql_" UNION "
 	s Sql=Sql_"SELECT t2.Name AS itemName ,t1.ID,t1.proCode AS DimPro_Code ,t1.proName AS DimPro_Name FROM DHCWL_BaseDataQuery.QryobjPro t1,"
	s Sql=Sql_"DHCWL_BaseDataQuery.Item t2 WHERE t1.BaseObjName=t2.QueryObjName AND t2.LinkDimType='对象维度'"
 	s Sql=Sql_"AND t2.Name='"_itemName_"'"
 	
 	//w !,Sql
	s Rs=##class(%Library.ResultSet).%New()
	s st=Rs.Prepare(Sql) 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	s st=Rs.Execute() 
	
	If $$$ISERR(st) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	
	while(Rs.Next()) {
		s itemName=Rs.Data("itemName")
		s ID=Rs.Data("ID")
		s DimProCode=Rs.Data("DimPro_Code")
		s DimProName=Rs.Data("DimPro_Name")
		s outParam(ID)=itemName_"^"_DimProCode_"^"_DimProName
	}
	d Rs.Close()
	q ret
	
	
SQLErr
	if ret="" s ret="getItemByQryName:未知错误!"
	q ret
	*/
}

ClassMethod GetBDQObjFields(sqlTableName As %String, pros As %String) As DHCWL.util.Json
{
	n (sqlTableName,pros)
	//w !,sqlTableName
	//w !,pros
	s tempPros=""
	s deli="&"
	f i=$l(pros):-1:1 {
		i $e(pros,i)="," s tempPros=deli_tempPros
		e  s tempPros=$e(pros,i)_tempPros
	}
	s nums=0
	s json=##class(DHCWL.util.Json).Json(tempPros,,,deli)
	
	Set Rs = ##class(%ResultSet).%New()
	s Sql="SELECT TOP 1* FROM "_sqlTableName
	//w !,Sql
	s st=Rs.Prepare(Sql) 

	Set columns = Rs.GetColumnCount()
	//s value=Name,Descript,ItemType,DimType,DimCode
	s tValue="&''&''&''&''"
	For col = 1:1:columns {
		s colName= Rs.GetColumnName(col)
		s colType= Rs.GetColumnType(col)
		s value="'"_colType_"'&'"_colName_"'"_tValue
		d json.Insert(value)
		s nums=nums+1
	}

	Do Rs.Close()

	d:json json.SetTotalNum(nums)
	q json
}

ClassMethod GetProValue(col As %String, ByRef Rs, inPam As %String = "") As %String
{

	n (col,Rs,inPam)
	s $zt="SQLErrGetProValue"
	s itemName=$p(col,"->",1)
	s itemValue=Rs.GetDataByName(itemName)
	s excStr=^||TEMPDHCWL("BDQ","SEARCHCOLPROS",col)
	q:$g(excStr)="" ""
	s proValue=""
	
	if $g(inPam)'="" {
		s excStr="s proValue=$$"_excStr_"("""_itemValue_"~"_inPam_""")"
	}
	else {
		
		s excStr="s proValue=$$"_excStr_"("""_itemValue_""")"
	}
	x excStr
	q proValue
SQLErrGetProValue
	q "NULL"
}

/// Creator：      	王峥
/// CreatDate：    	2017-01-25
/// Description:：  得到过滤结果
/// Table：       	无
/// Input：         Rs：结果集对象			
/// Output：        无。
/// Return：        1：当前记录符合过滤条件
/// Return：        0：当前记录符合不过滤条件
/// Others
ClassMethod GetFilterResult(Rs) As %Integer
{
	n (Rs)
	s ret=1
	s col=""
	f {
		s col=$o(^||TEMPDHCWL("BDQ","FILTERPROS",col))
		q:col=""
		
		s inPam=$g(^||TEMPDHCWL("BDQ","FILTERINPAM",col))
		s proValue=##CLASS(DHCWL.BaseDataQuery.Util).GetProValue(col,Rs,inPam)	//得到属性值
		//s proValue=$tr(proValue,"!=","'=")
 		//s excStr="proValue"_^||TEMPDHCWL("BDQ","FILTERPROS",col)
 		s excStr="proValue"_$tr(^||TEMPDHCWL("BDQ","FILTERPROS",col),"!=","'=")
 		s excStr="s ret=("_excStr_")"
 		//w !,excStr
 		//s excStr="s ret=(proValue=""传染科门诊"")"
 		x excStr
 		q:ret=0
	}
	q ret
}

ClassMethod GetQryDetailMeasureParam(ByRef inParam) As %String
{
	//inParam("paramMeasure")
	n (inParam)
	s measure=""
	s qryobjName=inParam("qryObjName")
	s cnt=$l(inParam("paramCols"),",")
	f inx=1:1:cnt {
		s name=$p(inParam("paramCols"),",",inx)
		continue:$g(name)=""
		s itemID=$o(^DHCWL.BaseDataQuery.ItemI("QueryObjNameIndex",qryobjName,name,0))
		continue:$g(itemID)=""
		s type=$lg(^DHCWL.BaseDataQuery.ItemD(itemID),5)
		
		if type="度量" {
			if measure'="" s measure=measure_","
			s measure=measure_name
			s $p(inParam("paramCols"),",",inx)=""
			s $p(inParam("inPamCols"),",",inx)=""
		}
		
	}
	s inParam("paramMeasure")=measure
	q ""
}

ClassMethod GetBDQRptItemDesc(baseObjName, rptItem, type = "", subID) As %String
{
	n (baseObjName,rptItem,type,subID)
	
	s subObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSubByID(subID)
	s itemDesc=subObj.Name
	q itemDesc
	
	
	/*
	if (type="colcustomMeasure") {
		s subObj=##class(DHCWL.BaseDataQuery.ReportCfgSub).GetSubByID(subID)
		s itemDesc=subObj.Name
		q itemDesc
		
	}else{
		if (type="filter") {
			s rptItem=$p(rptItem,"^",2)
		}
		if (type="colOrder") {
			s rptItem=$p(rptItem,"^",1)
		}
		
		s rptItem=$p(rptItem,"(",1)
		s itemName=$p(rptItem,"->",1)
		s pro=$p(rptItem,"->",2)
		
	
		s itemDesc=""
		s linkDimCode=""
		&sql(SELECT ifnull(Descript,Name,Descript),LinkDimCode into :itemDesc,:linkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName= :baseObjName and Name=:itemName)
		if SQLCODE'=0 q ""
		//if SQLCODE'=0 q "-无数据-"
		if linkDimCode="" || (pro="") q itemDesc
		s prodesc=""
		//从powerCube里面取数属性
		s baseDimobj=##class(DHCWL.DM.T.DimBase).GetByPath(linkDimCode)
		s proObj=baseDimobj.GetProperty(pro)
		s prodesc=proObj.Name
		q itemDesc_"->"_prodesc
	}
	*/
}

ClassMethod GetBDQRptColDesc(ByRef inParam, rptItem) As %String
{
	//n (baseObjName,rptItem,type,outParam)
	n (inParam, rptItem)
	s baseObjName=inParam("qryObjName")
	s type=inParam("colType",rptItem)
	if (type="colcustomMeasure") {
		s rptId=inParam("rptID")
		s itemDesc=""
		&sql(SELECT Name into:itemDesc FROM DHCWL_BaseDataQuery.ReportCfgSub WHERE RptID =:rptId AND Item=:rptItem)
		q itemDesc
	}else{
		s rptItem=$p(rptItem,"(",1)
		s itemName=$p(rptItem,"->",1)
		s pro=$p(rptItem,"->",2)
	
	
		s itemDesc=""
		s linkDimCode=""
		&sql(SELECT ifnull(Descript,Name,Descript),LinkDimCode into :itemDesc,:linkDimCode FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName= :baseObjName and Name=:itemName)
		if SQLCODE'=0 q "-无数据-"
		if linkDimCode="" || (pro="") q itemDesc
		s prodesc=""
		if linkDimCode="对象属性" {
			&sql(SELECT proDesc into :prodesc FROM DHCWL_BaseDataQuery.QryobjPro where proCode= :pro and BaseObjName= :baseObjName)
			q itemDesc_"->"_prodesc
		}else{
			&SQL(SELECT DimPro_Desc into :prodesc FROM DHCWL_MKPI.DHCWLDimProperty WHERE DimPro_Code=:pro AND dimpro_dimdr->KDT_CODE=:linkDimCode )
			q itemDesc_"->"_prodesc
		}
	}
}

/// 导出表记录
/// 
/// d ##class(DHCWL.BaseDataQuery.Util).ExpClassObj2Global("DHCWL.BaseDataQuery.ReportCfg")
ClassMethod ExpClassObj2Global(className, qryCondition) As %String
{
	n (className, qryCondition)	
	
	k ^||TEMPDHCWL("EXPCLASSOBJ")
	k ^DHCWL.ExpClassObj(className)
	s ret=""
	s classObj = ##class(%Dictionary.CompiledClass).%OpenId(className)	

	s properties=classObj.Properties
	Set key = ""
	Do {
		Set propertyObj = properties.GetNext(.key)
		If (propertyObj '= "") {
			s intenalF=propertyObj.Internal
			continue:intenalF
			s proName=propertyObj.Name
			s sqlFieldName=propertyObj.SqlFieldName
			s ^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)=sqlFieldName
			s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=proName
		}
	} While (key '= "")	
	//得到class对应的表名称。
	s sqlQualifiedName=classObj.SqlQualifiedNameQ
	/*
	s storageStrategy=classObj.StorageStrategy
	s storageID=className_"||"_storageStrategy
	s storageObj= ##class(%Dictionary.CompiledStorage).%OpenId(storageID)
	*/	
	s storageObj= classObj.Storages.GetNext("")
	
	
	
	Set key = ""
	s storageDataObj=storageObj.Data.GetNext(.key)
	if $ISOBJECT(storageDataObj) {		//StorageStrategy:Default
		s storageDataValueObjs=storageDataObj.Values
	
		s valueCnt=storageDataValueObjs.Count()
		f i=1:1:valueCnt {
			s proName=storageDataValueObjs.GetAt(i).Value
			s position=storageDataValueObjs.GetAt(i).Name
				
			if $d(^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)) {
				s sqlFieldName=^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)
				s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=position
			}		
		}
	}else{
		Set key = ""
		s storageSqlMapObj=storageObj.SQLMaps.GetNext(.key)
		if $ISOBJECT(storageSqlMapObj) {		//StorageStrategy:SQLStorage
			s storageSqlMapDataObjs=storageSqlMapObj.Data
	
			s dataCnt=storageSqlMapDataObjs.Count()
			f i=1:1:dataCnt {
				s sqlFieldName=storageSqlMapDataObjs.GetAt(i).Name
				s position=storageSqlMapDataObjs.GetAt(i).Piece 
				s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=position		
			}
		}
	}
	
	s sql="SELECT * FROM "_sqlQualifiedName
	if $g(qryCondition)'="" s sql=sql_" WHERE "_qryCondition
	s Rs=##class(%Library.ResultSet).%New()
	s Rs.RuntimeMode=1	//ODBC显示模式
	s st=Rs.Prepare(sql) 
	if ($$$ISERR(st)) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	
	s st=Rs.Execute() 
	if ($$$ISERR(st)) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
		q ret
	}
	
	k ^DHCWL.ExpClassObj(className)
	s recCnt=0
	while(Rs.Next()){
		s recCnt=recCnt+1
		s data=""
		s sqlFieldName=""	
		f {	
			s sqlFieldName=$o(^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName))
			q:$g(sqlFieldName)=""
			s fieldValue=Rs.Data(sqlFieldName)
			s pos=^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)
			s $p(data,"^",pos)=fieldValue
		}
		s ^DHCWL.ExpClassObj(className,"record",recCnt)=data
	}	

	q ret
}

/// 导入表记录
/// 
/// d ##class(DHCWL.BaseDataQuery.Util).ExpClassObj2Global("DHCWL.BaseDataQuery.ReportCfg")
ClassMethod ImpClassObj2Global(className) As %String
{
	n (className, qryCondition)	
	
	k ^||TEMPDHCWL("EXPCLASSOBJ")
	
	s ret=""
	s classObj = ##class(%Dictionary.CompiledClass).%OpenId(className)	

	s properties=classObj.Properties
	Set key = ""
	Do {
		Set propertyObj = properties.GetNext(.key)
		If (propertyObj '= "") {
			s intenalF=propertyObj.Internal
			continue:intenalF
			s proName=propertyObj.Name
			s sqlFieldName=propertyObj.SqlFieldName
			s ^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)=sqlFieldName
			s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=proName
		}
	} While (key '= "")	
	//得到class对应的表名称。
	s sqlQualifiedName=classObj.SqlQualifiedNameQ
	
	s storageObj= classObj.Storages.GetNext("")
	
	
	
	Set key = ""
	s storageDataObj=storageObj.Data.GetNext(.key)
	if $ISOBJECT(storageDataObj) {		//StorageStrategy:Default
		s storageDataValueObjs=storageDataObj.Values
	
		s valueCnt=storageDataValueObjs.Count()
		f i=1:1:valueCnt {
			s proName=storageDataValueObjs.GetAt(i).Value
			s position=storageDataValueObjs.GetAt(i).Name
				
			if $d(^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)) {
				s sqlFieldName=^||TEMPDHCWL("EXPCLASSOBJ","PROPERTY-FIELDNAME",proName)
				s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=position
			}		
		}
	}else{
		Set key = ""
		s storageSqlMapObj=storageObj.SQLMaps.GetNext(.key)
		if $ISOBJECT(storageSqlMapObj) {		//StorageStrategy:SQLStorage
			s storageSqlMapDataObjs=storageSqlMapObj.Data
	
			s dataCnt=storageSqlMapDataObjs.Count()
			f i=1:1:dataCnt {
				s sqlFieldName=storageSqlMapDataObjs.GetAt(i).Name
				s position=storageSqlMapDataObjs.GetAt(i).Piece 
				s ^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)=position		
			}
		}
	}
	
	
	
	
	s recInx=""
	f {
		s recInx=$o(^DHCWL.ExpClassObj(className,"record",recInx))
		q:+$g(recInx)=""	
		s data=^DHCWL.ExpClassObj(className,"record",recInx)
		
		s fields=""
		s values=""
		
		s sqlFiledName=""
		f {
			s sqlFieldName=$o(^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName))	
			q:$g(sqlFieldName)=""
			
			s pos=^||TEMPDHCWL("EXPCLASSOBJ","FIELDNAME",sqlFieldName)
			if fields'="" s fields=fields_","
			s fields=fields_sqlFieldName
			
			if values'="" s values=values_","
			s val=$p(data,"^",pos)
			s values=values_val
		}
		
		s sql="INSERT INTO "_sqlQualifiedName_" ("_fields_") VALUES ("_values_")"
		s Rs=##class(%Library.ResultSet).%New()
		s Rs.RuntimeMode=1	//ODBC显示模式
		s st=Rs.Prepare(sql) 
		if ($$$ISERR(st)) {
			s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
			q
		}
	
		s st=Rs.Execute() 
		if ($$$ISERR(st)) {
			s ret="新建查询对象失败:"_$System.Status.GetErrorText(st)
			w !,sql
			w !,$System.Status.GetErrorText(st)
			continue
		}
	}

	
	if ret="" k ^DHCWL.ExpClassObj(className)
	q ret
}

ClassMethod GetItemsByType(ByRef inParam, ByRef outParam)
{
	n (inParam,outParam)
	s rs=##class(%Library.ResultSet).%New()
	s sql="SELECT Name, Descript FROM DHCWL_BaseDataQuery.Item WHERE QueryObjName='"_inParam("qryObjName")_"' AND Type='"_inParam("itemType")_"'"
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){
		s Name=rs.Data("Name")
		s Descript=rs.Data("Descript")
		s outParam(Name)=Descript
	}
	d rs.Close()
}

}
