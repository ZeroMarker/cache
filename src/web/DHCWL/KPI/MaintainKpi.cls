Class web.DHCWL.KPI.MaintainKpi Extends %RegisteredObject [ Not ProcedureBlock ]
{

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
	//modify by wk~2017-03-03~公司时间控件标准化
	//s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=$zdh(data("updateDate"),3)
	s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(data("updateDate"))
	s:$g(data("dataNode"))'="" kpi.MKPIDataNod=data("dataNode")
	s:$g(data("nodeMark"))'="" kpi.MKPIRemark=data("nodeMark")
	s kpi.MKPIGlobalFlag=$g(data("globalFlag"))
	s kpi.MKPIGetValueType=$g(data("getValueType"))

	s categoryValue=$g(data("category"))
	s sectionValue=$g(data("section"))
	;i $g(data("dimType"))'="" &sql(select ID into :dimId from DHCWL_MKPI.DHCWLMKPIDimType where KDT_Name=:data("dimType"))
	i categoryValue'="" &sql(select ID into :catId from DHCWL_MKPI.DHCWLMKPIFL where MKPIFL_Name=:categoryValue)
	i sectionValue'="" &sql(select ID into :sectId from DHCWL_MKPI.DHCWLSection where Sec_Name=:sectionValue)
	;i (data("dimType"))&&(dimId="")  q "无此维度，请先创建！"
	i (categoryValue'="")&&(catId="")  q "无此类型指标，请先创建！"
	i (sectionValue'="")&&(sectId="")  q "无此区间指标，请先创建！"
	;s:dimId'="" kpi.MKPITypeDr=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimId)
	s:catId'="" kpi.MKPICate=##class(DHCWL.MKPI.MKPIFL).%OpenId(catId)
	s:sectId'="" kpi.MKPISectionFlag=##class(DHCWL.MKPI.Section).%OpenId(sectId)
	s sc=kpi.%Save()
	i sc=1 q "ok"
	e  q "wrong"
}

// add by wk.2016-05-30

// 根据被复制的指标维度为新创建的指标维度赋值

ClassMethod InsertKpiDim(kpiDimID, kpiCode) As %String
{
	n (kpiDimID,kpiCode)
	q:kpiDimID="" "指标维度复制失败！"
	q:kpiCode="" "指标维度复制失败！"
	i '$d(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(kpiCode,"U")))  q "指标创建失败!"
	s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiCode,"DHCWL.MKPI.MKPI")
	s dimOrder=""
	s errorFlag=0
	s kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
	for{
		s dimOrder=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiDimID,dimOrder))
		q:dimOrder=""
		s dimID=$o(^DHCWL.MKPI.MKPIDimensionsI("KPIOrderI",kpiDimID,dimOrder,""))
		s dimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(dimID)
		s dimCode=dimObj.MKPIDimCode
		s dimDes=dimObj.MKPIDimDes
		s dimDimDr=dimObj.MKPIDimDimDr
		s dimDimOrder=dimObj.MKPIDimOrder
		s dimDeli=dimObj.MKPIDimDeli
		s dimNewObj=##class(DHCWL.MKPI.MKPIDimensions).%New()
		s dimNewObj.MKPIDimCode=dimCode
		s dimNewObj.MKPIDimDeli=dimDeli
		s dimNewObj.MKPIDimDes=dimDes
		s dimNewObj.MKPIDimDimDr=dimDimDr
		s dimNewObj.MKPIDimOrder=dimDimOrder
		s dimNewObj.MKPIDr=kpiObj
		s sc=dimNewObj.%Save()
		i sc'=1{
			s errorFlag=1
			q
		}
	}
	if errorFlag=1{
		q "wrong"
	}else{
		q "ok"
	}
}

ClassMethod Update(id, ByRef data)
{
	n (id,data)
	q:data("kpiName")="" "指标名称不能为空！"
	s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(id),dimId="",catId="",sectId=""
	i kpi=""  q "不存在该指标，请重选！"
	/*
	s tempKpiId=+##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode($g(data("kpiCode")))
	i (tempKpiId=0)||(tempKpiId'=+id) q "指标编码不允许修改"
	*/
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
	//modify by wk~2017-03-03~公司时间控件标准化
	s data("updateDate")=$p($h,",",1)
	//s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=$zdh(data("updateDate"),3)
	s:+$g(data("updateDate"))'=0 kpi.MKPIUpdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(data("updateDate"))
	s kpi.MKPIRemark=$g(data("nodeMark"))
	s kpi.MKPIDataNod=$g(data("dataNode"))
	s kpi.MKPIGlobalFlag=$g(data("globalFlag"))
	s kpi.MKPIGetValueType=$g(data("getValueType"))
	;s:$g(data("section"))'="" kpi.MKPISectionFlag=data("section")
	s categoryValue=$g(data("category"))
	s sectionValue=$g(data("section"))
	;&sql(select ID into :dimId from DHCWL_MKPI.DHCWLMKPIDimType where KDT_Name=:data("dimType"))
	&sql(select ID into :catId from DHCWL_MKPI.DHCWLMKPIFL where MKPIFL_Name=:categoryValue)
	&sql(select ID into :sectId from DHCWL_MKPI.DHCWLSection where Sec_Name=:sectionValue)
	;i (data("dimType"))&&(dimId="")  q "无此维度，请先创建！"
	i (categoryValue'="")&&(catId="")  q "无此类型指标，请先创建！"
	i (sectionValue'="")&&(sectId="")  q "无此区间指标，请先创建！"
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

ClassMethod Delete(id) As %String
{
	n (id)
	q:id="" "请选择删除已经存在的指标！"
	s kpiCode=$lg(^DHCWL.MKPI.MKPID(id),2)
	&sql(delete from DHCWL_MKPI.DHCWLTaskGroupDetail where DTask_KpiDr=:kpiCode)
	&sql(delete from DHCWL_MKPI.DHCWLCreatDataTask where DTask_KPI_DR=:id)
	&sql(delete from DHCWL_MKPI.DHCWLMKPIDim where MKPI_Dr=:id)
	&sql(delete from DHCWL_MKPI.DHCWLMKPIMeasure where MKPI_KpiDr=:id)
	s sc=##class(DHCWL.MKPI.MKPI).%DeleteId(id)
	i sc=1  q "ok"
	e  q "删除失败！"
}

/// 根据类全名，搜索对应的表信息，返回得到给定范围内的Json数据
/// s json=##class(web.DHCWL.KPI.MaintainKpi).GetObjsByClassName("DHCWL.MKPI.Section",1,6)
ClassMethod GetObjsByClassName(className, st As %Integer, ed As %Integer, ByRef searchCond) As DHCWL.util.Json
{
	n (className,st,ed,searchCond)
	s paraList="",sqlFieldName=""
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	s sqlTableName=cdef.SqlTableName
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

/// s dim("KDTCode")="lhhTest"
/// w ##class(web.DHCWL.KPI.MaintainKpi).AddDimType(.dim)
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
	//modif by wk~2017-03-09~公司标准库时间控件统一
	//s:$g(dim("KDTUpdateDate"))'="" dimObj.KDTUpdateDate=$zdh($g(dim("KDTUpdateDate")),3)
	s:$g(dim("KDTUpdateDate"))'="" dimObj.KDTUpdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical($g(dim("KDTUpdateDate")))
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
	//modify by wk~2017-03-09~公司时间控件标准化
	//s:$g(dim("MKPIFLUpdateDate"))'="" dimObj.MKPIFLUpdateDate=$zdh($g(dim("MKPIFLUpdateDate")),3)
	s:$g(dim("MKPIFLUpdateDate"))'="" dimObj.MKPIFLUpdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(dim("MKPIFLUpdateDate"))
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
	s errorSection=0
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
	i (num>0)&&(parentId=0) s errorSection=1
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
	//s:$g(sec("SecUpdateDate"))'="" secObj.SecUpdateDate=$zdh($g(sec("SecUpdateDate")),3)		//++ modify by wk~2017-03-03~公司时间控件标准化
	s:$g(sec("SecUpdateDate"))'="" secObj.SecUpdateDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical($g(sec("SecUpdateDate")))
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
		i (errorSection=1){
			q "区间只允许一个为最大区间（直接父节点为空）其他区间必须为某一个区间的子区间"
		}
		i (+enforce=0)&&(##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.tempSec)=0) {
			q "指标区间之间的父子关系维护不正确，要像链表一样。"
		}
		q "ok"
	}
	q "维度保存失败！"
}

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
	//e  q "ok"
	i (SQLCODE=0){
		i (##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.tempSec)=0) {
			q "指标区间之间的父子关系维护不正确，要像链表一样。"
		}else{
			q "ok"
		}
	}
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
		//q $zd(+date,3)	//++modify by wk~2017-03-03~公司时间控件标准化
		q ##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(date)
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
	//i type ["%Date" q $zdh(date,3)
	i type ["%Date" q ##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(date)
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

}
