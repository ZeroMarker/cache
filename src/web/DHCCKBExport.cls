Import sqluser

Class web.DHCCKBExport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 导出与适应症不明确列相关内容
Query ExportTmpData(pid) As websys.Query(ROWSPEC = "genName:%String:通用名（带剂型）,text:%String:原文,Disease:%String:病症,OtherDis:%String:系统疾病,linkSym:%String:症状,otherNoSureDis:%String:与适应症相关的不明确列")
{
}

/* Query ExportTmpData(pid) As websys.Query(ROWSPEC = "genName:%String,text:%String,Disease:%String,OtherDis:%String,linkSym:%String,otherNoSureDis:%String")
{
} */
/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportTmpData",1) 
/// @param: pid 进程号
ClassMethod ExportTmpDataExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	if pid="" set pid=$order(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportData",""),-1)
	quit:pid="" $$$OK

	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportData",pid,index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportData",pid,index))
	.//$c(28)文件分隔符 肉眼不可见，为了在Excel中数据开头是0的可以显示	
	.set ^CacheTemp(repid,ind)=$listfromstring(listData,"[next]")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 导出错误信息
Query ExportDataErrMsg(pid) As websys.Query(ROWSPEC = "f1:%String:序号,f2:%String:错误原因,f3:%String:编码1,f4:%String:药品商品名1,f5:%String:通用名（带剂型）1,f6:%String:英文名称1,f7:%String:成分1,f8:%String:辅料1,f9:%String:剂型1,f10:%String:关系,f11:%String:原文,f12:%String:药品商品名,f13:%String:通用名（含剂型）,f14:%String:同类药物,f15:%String:成分,f16:%String:除外的药品类型,f17:%String:除外的药品成分,f18:%String:药品之外的过敏因素,f19:%String:检验指标,f20:%String:检验指标值,f21:%String:病原体,f22:%String:病原体组,f23:%String:病原体除外,f24:%String:病症,f25:%String:系统疾病,f26:%String:症状,f27:%String:与适应症相关的不明确列,f28:%String:除外病症,f29:%String:除外系统疾病,f30:%String:除外症状,f31:%String:特别推荐,f32:%String:手术时段,f33:%String:人群,f34:%String:年龄,f35:%String:体重,f36:%String:性别,f37:%String:职业,f38:%String:给药途径,f39:%String:溶媒（带剂型的通用名）,f40:%String:溶媒浓度,f41:%String:溶媒体积,f42:%String:溶液（带剂型的通用名）,f43:%String:溶液浓度,f44:%String:溶液体积,f45:%String:给药速度,f46:%String:给药时间,f47:%String:剂量—频次-疗程内用药时长,f48:%String:是否首次,f49:%String:阶梯给药,f50:%String:最大量,f51:%String:极量,f52:%String:疗程,f53:%String:疗程间间隔,f54:%String:连续用药,f55:%String:进一步说明,f56:%String:不合理用药原因说明,f57:%String:提示级别,f58:%String:提示依据,f59:%String:合用类别,f60:%String:警戒类型,f61:%String:前置条件/后置影响")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDataErrMsg",1) 
/// @param: pid 进程号
ClassMethod ExportDataErrMsgExecute(ByRef qHandle As %Binary, pid) As %Status
{
	n (qHandle,pid)
	//f1:%String:序号,f2:%String:错误原因,f3:%String:编码1,f4:%String:药品商品名1,f5:%String:通用名（带剂型）1,f6:%String:英文名称1,f7:%String:成分1,f8:%String:辅料1,f9:%String:剂型1,f10:%String:关系,f11:%String:原文,f12:%String:药品商品名,f13:%String:通用名（含剂型）,f14:%String:同类药物,f15:%String:成分,f16:%String:除外的药品类型,f17:%String:除外的药品成分,f18:%String:药品之外的过敏因素,f19:%String:检验指标,f20:%String:检验指标值,f21:%String:病原体,f22:%String:病原体除外,f23:%String:病症,f24:%String:系统疾病,f25:%String:症状,f26:%String:与适应症相关的不明确列,f27:%String:除外病症,f28:%String:除外系统疾病,f29:%String:除外症状,f30:%String:特别推荐,f31:%String:手术时段,f32:%String:人群,f33:%String:年龄,f34:%String:体重,f35:%String:性别,f36:%String:职业,f37:%String:给药途径,f38:%String:溶媒（带剂型的通用名）,f39:%String:溶媒浓度,f40:%String:溶媒体积,f41:%String:溶液（带剂型的通用名）,f42:%String:溶液浓度,f43:%String:溶液体积,f44:%String:给药速度,f45:%String:给药时间,f46:%String:剂量—频次-疗程内用药时长,f47:%String:是否首次,f48:%String:阶梯给药,f49:%String:最大量,f50:%String:极量,f51:%String:疗程,f52:%String:疗程间间隔,f53:%String:连续用药,f54:%String:进一步说明,f55:%String:不合理用药原因说明,f56:%String:提示级别,f57:%String:提示依据,f58:%String:合用类别,f59:%String:警戒类型,f60:%String:前置条件/后置影响

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	if pid="" set pid=$order(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",""),-1)
	quit:pid="" $$$OK
	b //1
	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,index))
	.set rowData=""
	.d GetListData
	.q:rowData=""
	.set ^CacheTemp(repid,ind)=$listfromstring(rowData,"[next]")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetListData

	s len=$Length(listData,"[next]")
	s outPutObj=..SetOutPutObj()
	f i=1:1:len	d
	.s tmpCol=$p(listData,"[next]",i) // key val  // 定义一个json,作为列头,定义输出的顺序
	.// m中json是按照定义的顺序输出的
	.s key=$p(tmpCol,$c(1),1)
	.s value=$p(tmpCol,$c(1),2)
	.s value=$tr(value,$c(10),$c(2))
	.//q:key="原文"
	.//q:key="进一步说明"
	.//b:key="疗程间间隔"
	.if outPutObj.%IsDefined(key) d outPutObj.%Set(key,value)
	
	s rowData=..GetOutPutData(outPutObj)
	b //333
	quit
}

ClassMethod SetOutPutObj(key, value) As %String
{
	s keyObj={}
	
	// 输出顺序  与输出的表格顺序一致
	//(ROWSPEC = "f1:%String:序号,f2:%String:错误原因,f3:%String:编码1,f4:%String:药品商品名1,f5:%String:通用名（带剂型）1,f6:%String:英文名称1,f7:%String:成分1,f8:%String:辅料1,f9:%String:剂型1,f10:%String:关系,f11:%String:原文,f12:%String:药品商品名,f13:%String:通用名（含剂型）,f14:%String:同类药物,f15:%String:成分,f16:%String:除外的药品类型,f17:%String:除外的药品成分,f18:%String:药品之外的过敏因素,f19:%String:检验指标,f20:%String:检验指标值,f21:%String:病原体,f22:%String:病原体组,f23:%String:病原体除外,f24:%String:病症,f25:%String:系统疾病,f26:%String:症状,f27:%String:与适应症相关的不明确列,f28:%String:除外病症,f29:%String:除外系统疾病,f30:%String:除外症状,f31:%String:特别推荐,f32:%String:手术时段,f33:%String:人群,f34:%String:年龄,f35:%String:体重,f36:%String:性别,f37:%String:职业,f38:%String:给药途径,f39:%String:溶媒（带剂型的通用名）,f40:%String:溶媒浓度,f41:%String:溶媒体积,f42:%String:溶液（带剂型的通用名）,f43:%String:溶液浓度,f44:%String:溶液体积,f45:%String:给药速度,f46:%String:给药时间,f47:%String:剂量—频次-疗程内用药时长,f48:%String:是否首次,f49:%String:阶梯给药,f50:%String:最大量,f51:%String:极量,f52:%String:疗程,f53:%String:疗程间间隔,f54:%String:连续用药,f55:%String:进一步说明,f56:%String:不合理用药原因说明,f57:%String:提示级别,f58:%String:提示依据,f59:%String:合用类别,f60:%String:警戒类型,f61:%String:前置条件/后置影响")

	d keyObj.%Set("num","").%Set("errMsg","").%Set("编码1","").%Set("药品商品名1","")
	d keyObj.%Set("通用名（带剂型）1","").%Set("英文名称1","").%Set("成分1","").%Set("辅料1","")  //8
	d keyObj.%Set("剂型1","").%Set("关系","").%Set("原文","").%Set("药品商品名","")
	d keyObj.%Set("通用名（含剂型）","").%Set("同类药物","").%Set("成分","").%Set("除外的药品类型","")
	d keyObj.%Set("除外的药品成分","").%Set("药品之外的过敏因素","").%Set("检验指标","").%Set("检验指标值","")
	d keyObj.%Set("病原体","").%Set("病原体组","").%Set("病原体除外","").%Set("病症","")
	d keyObj.%Set("系统疾病","").%Set("症状","").%Set("与适应症相关的不明确列","").%Set("除外病症","")
	d keyObj.%Set("除外系统疾病","").%Set("除外症状","").%Set("特别推荐","").%Set("手术时段","")
	d keyObj.%Set("人群","").%Set("年龄","").%Set("体重","").%Set("性别","")
	d keyObj.%Set("职业","").%Set("给药途径","").%Set("溶媒（带剂型的通用名）","").%Set("溶媒浓度","")
	d keyObj.%Set("溶媒体积","").%Set("溶液（带剂型的通用名）","").%Set("溶液浓度","").%Set("溶液体积","")
	d keyObj.%Set("给药速度","").%Set("给药时间","").%Set("剂量,频次,疗程内用药时长","").%Set("是否首次","")
	d keyObj.%Set("阶梯给药","").%Set("最大量","").%Set("极量","").%Set("疗程","")
	d keyObj.%Set("疗程间间隔","").%Set("连续用药","").%Set("进一步说明","").%Set("不合理用药原因说明","")
	d keyObj.%Set("提示级别","").%Set("提示依据","").%Set("合用类别","").%Set("警戒类型","")
	d keyObj.%Set("前置条件/后置影响","")
	
	q keyObj
}

ClassMethod SetOutPutObjNew(keyList) As %String
{
	s keyObj={}
	
	// 输出顺序  与输出的表格顺序一致
	//(ROWSPEC = "f1:%String:序号,f2:%String:错误原因,f3:%String:编码1,f4:%String:药品商品名1,f5:%String:通用名（带剂型）1,f6:%String:英文名称1,f7:%String:成分1,f8:%String:辅料1,f9:%String:剂型1,f10:%String:关系,f11:%String:原文,f12:%String:药品商品名,f13:%String:通用名（含剂型）,f14:%String:同类药物,f15:%String:成分,f16:%String:除外的药品类型,f17:%String:除外的药品成分,f18:%String:药品之外的过敏因素,f19:%String:检验指标,f20:%String:检验指标值,f21:%String:病原体,f22:%String:病原体组,f23:%String:病原体除外,f24:%String:病症,f25:%String:系统疾病,f26:%String:症状,f27:%String:与适应症相关的不明确列,f28:%String:除外病症,f29:%String:除外系统疾病,f30:%String:除外症状,f31:%String:特别推荐,f32:%String:手术时段,f33:%String:人群,f34:%String:年龄,f35:%String:体重,f36:%String:性别,f37:%String:职业,f38:%String:给药途径,f39:%String:溶媒（带剂型的通用名）,f40:%String:溶媒浓度,f41:%String:溶媒体积,f42:%String:溶液（带剂型的通用名）,f43:%String:溶液浓度,f44:%String:溶液体积,f45:%String:给药速度,f46:%String:给药时间,f47:%String:剂量—频次-疗程内用药时长,f48:%String:是否首次,f49:%String:阶梯给药,f50:%String:最大量,f51:%String:极量,f52:%String:疗程,f53:%String:疗程间间隔,f54:%String:连续用药,f55:%String:进一步说明,f56:%String:不合理用药原因说明,f57:%String:提示级别,f58:%String:提示依据,f59:%String:合用类别,f60:%String:警戒类型,f61:%String:前置条件/后置影响")
	f i=1:1:$l(keyList,$c(1))	d
	.s key=$p(keyList,$c(1),i)
	.d keyObj.%Set(key,"")
	/*
	s keyList="num"_$c(1)_"errMsg"_$c(1)_""
	d keyObj.%Set("num","").%Set("errMsg","").%Set("编码1","").%Set("药品商品名1","")
	d keyObj.%Set("通用名（带剂型）1","").%Set("英文名称1","").%Set("成分1","").%Set("辅料1","")  //8
	d keyObj.%Set("剂型1","").%Set("关系","").%Set("原文","").%Set("药品商品名","")
	d keyObj.%Set("通用名（含剂型）","").%Set("同类药物","").%Set("成分","").%Set("除外的药品类型","")
	d keyObj.%Set("除外的药品成分","").%Set("药品之外的过敏因素","").%Set("检验指标","").%Set("检验指标值","")
	d keyObj.%Set("病原体","").%Set("病原体组","").%Set("病原体除外","").%Set("病症","")
	d keyObj.%Set("系统疾病","").%Set("症状","").%Set("与适应症相关的不明确列","").%Set("除外病症","")
	d keyObj.%Set("除外系统疾病","").%Set("除外症状","").%Set("特别推荐","").%Set("手术时段","")
	d keyObj.%Set("人群","").%Set("年龄","").%Set("体重","").%Set("性别","")
	d keyObj.%Set("职业","").%Set("给药途径","").%Set("溶媒（带剂型的通用名）","").%Set("溶媒浓度","")
	d keyObj.%Set("溶媒体积","").%Set("溶液（带剂型的通用名）","").%Set("溶液浓度","").%Set("溶液体积","")
	d keyObj.%Set("给药速度","").%Set("给药时间","").%Set("剂量,频次,疗程内用药时长","").%Set("是否首次","")
	d keyObj.%Set("阶梯给药","").%Set("最大量","").%Set("极量","").%Set("疗程","")
	d keyObj.%Set("疗程间间隔","").%Set("连续用药","").%Set("进一步说明","").%Set("不合理用药原因说明","")
	d keyObj.%Set("提示级别","").%Set("提示依据","").%Set("合用类别","").%Set("警戒类型","")
	d keyObj.%Set("前置条件/后置影响","")
	*/
	q keyObj
}

ClassMethod GetOutPutData(dataObj) As %String
{
	n (dataObj)
	
	s ret=""
	s itr=dataObj.%GetIterator()	
	while(itr.%GetNext(.key,.val)){
		
		if (ret="") {
			s ret = val
		}else{
			
			s ret = ret_"[next]"_val
		}
	}	
	
	q ret
}

/// Description:	获取导入失败的药品列表信息
/// Creator:		QuNianpeng
/// CreateDate:		2019-10-18
/// Input:			代码^描述
/// return:			药品信息串
/// other:			
/// w ##class(web.DHCCKBExport).QueryDrugList("20","1","")
ClassMethod QueryDrugList(rows As %String = 20, page As %String = 1, params As %String) As %String
{
		
	n (rows,page,params)	

	s end = page*rows
	s start=(page-1)*rows+1
	s pid=$p(params,"^",1)
	q:pid="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:(pid'="")&&'$d(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid)) ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) // 输出json结尾符
		
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()	// 输出json前缀串
	s count=0
	s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"
	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBRuleExport","ExportDataErrMsg",pid,index))
	.q:listData=""
	.s listObj=##class(web.DHCCKBRuleImport).StrToObj(listData)
	.s tmpData=listObj.%Get("num")_"^"_listObj.%Get("itmCode")_"^"_listObj.%Get("itmProName")_"^"_listObj.%Get("itmGeneName")
	.s tmpData=tmpData_"^"_listObj.%Get("itmIngre")_"^"_listObj.%Get("itmExcipient")_"^"_listObj.%Get("itmForm")_"^"_listObj.%Get("itmLibary")
	.s tmpData=tmpData_"^"_listObj.%Get("errMsg")
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	
	q ""
}

/// Description:	获取药学分类导入失败的信息列表
/// Creator:		QuNianpeng
/// CreateDate:		2019-11-05
/// Input:			代码^描述
/// return:			药品信息串
/// other:			
/// w ##class(web.DHCCKBExport).QueryDrugCatList("20","1","1^drugcat")
ClassMethod QueryDrugCatList(rows As %String = 20, page As %String = 1, params As %String) As %String
{
		
	n (rows,page,params)	

	s end = page*rows
	s start=(page-1)*rows+1
	s pid=$p(params,"^",1)
	s type=$p(params,"^",2)

	q:'$d(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid)) ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) // 输出json结尾符
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()	// 输出json前缀串
	
	s count=0
	s title="num^firstCode^firstName^secondCode^secondName^thirdCode^thirdName^fourthCode^fourthName^fifthCode^fifthName"
	s title=title_"^itmCode^itmName^proName^itmFactory^errMsg"
	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,index))
	.q:listData=""
	.s listObj=##class(web.DHCCKBComImport).StrToObj(listData,type)
	.s tmpData=listObj.%Get("num")_"^"_listObj.%Get("firstCode")_"^"_listObj.%Get("firstName")_"^"_listObj.%Get("secondCode")_"^"_listObj.%Get("secondName")
	.s tmpData=tmpData_"^"_listObj.%Get("thirdCode")_"^"_listObj.%Get("thirdName")_"^"_listObj.%Get("fourthCode")_"^"_listObj.%Get("fourthName")
	.s tmpData=tmpData_"^"_listObj.%Get("fifthCode")_"^"_listObj.%Get("fifthName")_"^"_listObj.%Get("itmCode")_"^"_listObj.%Get("itmName")
	.s tmpData=tmpData_"^"_listObj.%Get("proName")_"^"_listObj.%Get("itmFactory")_"^"_listObj.%Get("errMsg")
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,tmpData,"^")	
	
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	
	q ""
}

/// 导出药学分类错误信息
Query ExportDrugCatErrMsg(pid, type) As websys.Query(ROWSPEC = "f1:%String:一级编码,f2:%String:一级,f3:%String:二级编码,f4:%String:二级,f5:%String:三级编码,f6:%String:三级,f7:%String:四级编码,f8:%String:四级,f9:%String:五级编码,f10:%String:五级,f11:%String:通用名,f12:%String:通用名称（含剂型）,f13:%String:编码,f14:%String:商品名,f15:%String:厂家")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugCatErrMsg",1,"drugcat") 
/// @param: pid 进程号
ClassMethod ExportDrugCatErrMsgExecute(ByRef qHandle As %Binary, pid, type) As %Status
{
	n (qHandle,pid,type)
	//"f1:%String:一级编码,f2:%String:一级,f3:%String:二级编码,f4:%String:二级,f5:%String:三级编码,f6:%String:三级,f7:%String:四级编码,f8:%String:四级,f9:%String:五级编码,:f10:%String:五级,f11::%String:通用名,f12:%String:通用名称（含剂型）,f13:%String:编码,f14:%String:商品名,f15:%String:厂家"

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	if pid="" set pid=$order(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",""),-1)
	quit:pid="" $$$OK

	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg",pid,type,index))
	.set rowData=""
	.d GetDrugCatListData
	.q:rowData=""
	.set ^CacheTemp(repid,ind)=$listfromstring(rowData,"[next]")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetDrugCatListData

	s len=$Length(listData,"[next]")
	s keyListr="一级编码"_$c(1)_"一级"_$c(1)_"二级编码"_$c(1)_"二级"_$c(1)_"三级编码"_$c(1)_"三级"_$c(1)_"四级编码"_$c(1)_"四级"_$c(1)_"五级编码"_$c(1)_"五级"_$c(1)_"通用名"_$c(1)_"通用名称（含剂型）"_$c(1)_"编码"_$c(1)_"商品名"_$c(1)_"厂家"
	s outPutObj=..SetOutPutObjNew(keyListr)
	f i=1:1:len	d
	.s tmpCol=$p(listData,"[next]",i) // key val  // 定义一个json,作为列头,定义输出的顺序
	.// m中json是按照定义的顺序输出的
	.s key=$p(tmpCol,$c(1),1)
	.s value=$p(tmpCol,$c(1),2)
	.s value=$c(28)_value
	.s value=$tr(value,$c(10),$c(2))
	.if outPutObj.%IsDefined(key) d outPutObj.%Set(key,value)
	
	s rowData=..GetOutPutData(outPutObj)

	quit
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-07
/// Description:  将规则中引用了医嘱项(医药)字典下面的数据，替换成带通用名字典下面对应的数据,并记录
/// Input:		  检索条件,登录信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportReplaceData")
/// w ##Class(websys.Query).ToExcel("CKB_Excel","web.DHCCKBExport","ExportReplaceData")
Query ExportReplaceData() As websys.Query(ROWSPEC = "ruleID:%String:规则组号,ruleDataID:%String:规则序号,dicID:%String:字典id,newDicID:%String:新带剂型通用名字典id,status:%String:更新状态")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportTmpData",1) 
/// @param: pid 进程号
ClassMethod ExportReplaceDataExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	d ..QueryReplaceData(.TmpArr)

	k TmpRetArr
	s flag=..UpdateRuleDicID(.TmpArr,.TmpRetArr)
	
	Set index=""	
	for  set index=$order(TmpRetArr(index)) quit:index=""  do
	.set listData=$get(TmpRetArr(index))
	.set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-07
/// Description:  将规则中引用了医嘱项(医药)字典下面的数据，替换成带通用名字典下面对应的数据
ClassMethod QueryReplaceData(TmpArr)
{
	n (TmpArr)
	

	s parref=##class(web.DHCCKBCommon).GetDrugData()
	s genDataID=##class(web.DHCCKBCommon).GetGeneralFromData() // GeneralFromData

	s rightType="Constant",h=0
	s rightDic=""
	f  s rightDic=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic))	q:rightDic=""  d
	.q:rightDic=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	.q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",parref,rightDic))	// 不再药品字典(医嘱项字典)内
	.s rightCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),2)
	.s rightDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)	
	.
	.// 用代码和描述,在带剂型的通用名字典表中查出对应的药品
	.s markNewID=""
	.s newID=""	
	.f  s newID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",genDataID,newID)) q:newID=""   d
	..s newCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(newID)),2)
	..s newDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(newID)),3)
	..q:newCode'=rightCode
	..q:newDesc'=rightDesc
	..s markNewID=newID
	.
	.q:+markNewID=0	
	.s rule=""
	.f  s rule=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,rule))  q:rule=""  d
	..s ruleDataID=""
	..f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,rule,ruleDataID))	q:ruleDataID=""  d
	...// 记录规则明细表的id
	...s h=h+1
	...s TmpArr(h)=ruleDataID_"^"_rule_"^"_rightDic_"^"_markNewID
	

	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-07
/// Description:  更新规则中的药品id
ClassMethod UpdateRuleDicID(TmpArr, TmpRetArr)
{
	n (TmpArr,TmpRetArr)
	
	ts
	s existFlag=0
	s index=""
	f  s index=$o(TmpArr(index)) 	q:(index="")||(existFlag=1)  d
	.s listData=$g(TmpArr(index))	// ruleDataID_"^"_rule_"^"_rightDic_"^"_markNewID
	.s ruleDataID=$p(listData,"^",1)
	.s markNewID=$p(listData,"^",4)
	.&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:markNewID where RD_RowID=:ruleDataID)
	.s:SQLCODE'=0 existFlag = 1
	.s TmpRetArr(index)=listData_"^"_"更新成功"
	
	if existFlag=1 tro
	e  tc
	
	q existFlag
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-07
/// Description:  复制医嘱项(西药)字典数据到带剂型的通用名字典下
/// w ##class(web.DHCCKBExport).CopyDrugData()
ClassMethod CopyDrugData()
{

	s drugData = ##class(web.DHCCKBCommon).GetDrugData()
	s generFormData = ##class(web.DHCCKBCommon).GetGeneralFromData()
	
	ts
	s existFlag=0
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",drugData,id))  q:(id="")||(existFlag=1)  d
	.s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.q:(code="")||(desc="")
	.
	.// 保存字典
	.s str="^"_code_"^"_desc_"^"_generFormData
	.s ret=##class(web.DHCCKBDiction).SaveDic(str)
	.s:ret<=0 existFlag=1
	.q:ret<=0
	.
	.s admin="11874"
	.// 保存日志
	.s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","113.140.81.66","log")
	.s:accFlag'=0 existFlag=1
	.q:accFlag'=0
	.
	.// 保存授权
	.s hospId=2
	.s acc=##class(web.DHCCKBConfig).SaveAloneAcc(ret,hospId,admin)
	.s:acc'=0 existFlag=1
	.q:acc'=0
	i existFlag=1 tro
	e  tc
	
	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-16
/// Description:  导出药品,通用名,规格,厂家,类型,是否有规则
/// Input:		  检索条件,登录信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData")
/// w ##Class(websys.Query).ToExcel("CKB_Excel药品目录20210520","web.DHCCKBExport","ExportDrugInfoData") 
/// s TmpArr(ID)=$lb(Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval)
Query ExportDrugInfoData() As websys.Query(ROWSPEC = "f0:%String:药品唯一码,f1:%String:代码,f2:%String:描述,f3:%String:通用名,f4:%String:规格,f5:%String:厂家,f6:%String:类型,f7:%String:是否有规则,f8:%String:商品名,f9:%String:剂型,f10:%String:大类,f11:%String:批准文号,f12:%String:药品单位")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData") 
ClassMethod ExportDrugInfoDataExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	//d ..QueryDrugInfoData(.TmpArr)
	// 西药
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	d ..QueryDrugInfoDataByParref(DrugData,.TmpArr)
	
	// 中成药
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	d ..QueryDrugInfoDataByParref(ChineseDrugData,.TmpArr)
	
	// 中药饮片
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	d ..QueryDrugInfoDataByParref(ChineseHMData,.TmpArr)

	Set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataByParref(Parref, TmpArr)
{
	n (Parref,TmpArr)
	q:+Parref=0
	s ID=""
	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,ID)) q:ID=""  d
	.s IsEnabled=##class(web.DHCCKBCommon).IsEnabled(ID)
	.q:IsEnabled=0
	.d ..QueryDrugInfoDataTemp(ID,.TmpArr,Parref)
	
	q ""
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataTemp(ID, TmpArr, Parref = "")
{
	
	n (ID,TmpArr,Parref)
	
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	s Code=$tr(Code,",",".")
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	s Desc=$tr(Desc,",",".")
	q:(Desc["作废")||(Desc["复制") ""
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	s:Parref'=0 Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),3)
	
	/* 是否有规则 */
	s HasRuleFlag=##class(web.DHCCKBCommon).IsExistRule(ID)
	s HasRuleFlag=$case(HasRuleFlag,1:"有",:"无")
	
	/* 规格  */
	s SpecificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	s Spec=..QueryAttrValueByCode(ID,SpecificationProp)
	
	/* 带剂型的通用名 */
	s GenerNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	s GeneralName=..QueryAttrValueByCode(ID,GenerNameFormProp)	
	
	/* 厂家 */
	s ManfStr=""
	s ManfID=##class(web.DHCCKBCommon).GetDrugManf()
	s ManfStr=..QueryAttrValueByCode(ID,ManfID)
	
	/* 商品名 */
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名
	s ProName = ..QueryAttrValueByCode(ID,proNameProp)
	
	/* 剂型 */	
	s FromProp = ##class(web.DHCCKBCommon).GetDrugForm() // 剂型
	s From = ..QueryAttrValueByCode(ID,FromProp)
	
	/* 大类 */
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s Type = $select(Parref=DrugData:"西药",Parref=ChineseDrugData:"中成药",Parref=ChineseHMData:"中药饮片",1:"")	
		
	/* 批准文号 */
	s ApprovalProp = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Approval = ..QueryAttrValueByCode(ID,ApprovalProp)
	
	/* 药品单位  - 取等效单位的第一列 */
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s DrugUnit = ..QueryEqFromUnit(ID,eqFromUnitProp)
	
	/* 药品唯一编码 */
	s Identity = ..QueryIdentity(ID)
	
	s TmpArr(ID)=$lb(Identity,Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval,DrugUnit)
	
	q ""
}

/// w ##class(web.DHCCKBExport).QueryAttrValueByCode(150,74529)
ClassMethod QueryAttrValueByCode(ID, AttrDr)
{
	
	n (ID,AttrDr)
	
	s AttrValue=##class(web.DHCCKBEditProp).QueryAttrValue(ID,AttrDr)
	i AttrValue=""  d
	.s ExitFlag = 0
	.s NewAttrDr = ""
	.f  s NewAttrDr=$o(^CT.CKB.PDSS.CommonDictionI("Link",AttrDr,NewAttrDr))	q:(NewAttrDr="")||(ExitFlag=1)  d
	..s AttrValue = ##class(web.DHCCKBEditProp).QueryAttrValue(ID,NewAttrDr)
	..i AttrValue'="" s ExitFlag=1
	
	i AttrValue'="" s AttrValue=$tr(AttrValue,",","、")	
	q AttrValue
}

/// w ##class(web.DHCCKBExport).QueryEqFromUnit(150,74529)
ClassMethod QueryEqFromUnit(ID, AttrDr)
{
	
	n (ID,AttrDr)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ID,AttrDr)) ""
	s linkID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ID,AttrDr,""))
	s value = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),4)
	s value = $lg($g(^CT.CKB.PDSS.CommonDictionD(+value)),3)
	q value
}

/// w ##class(web.DHCCKBExport).QueryIdentity(150)
ClassMethod QueryIdentity(ID)
{
	
	n (ID,AttrDr)
	q:'$d(^CKB.PDSS.ComDictionExtI("IndexDicID",ID)) ""
	s indentity = $o(^CKB.PDSS.ComDictionExtI("IndexDicID",ID,""))
	q $tr(indentity," ","")
}

/// Creator:      qunianpeng
/// CreatDate:    2020-12-29
/// Description:  导出药品说明书内容(西药)
/// w ##class(web.DHCCKBExport).CopyDrugData()
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInstructions")
/// w ##Class(websys.Query).ToExcel("药品说明书(西药)-带剂型通用名","web.DHCCKBExport","ExportDrugInstructions")
Query ExportDrugInstructions() As websys.Query(ROWSPEC = "f-1:%String:药品id,f0:%String:药品名称,f1:%String:警告,f2:%String:通用名（含剂型）,f3:%String:商品名,f4:%String:英文名称,f5:%String:通用名,f6:%String:成分,f7:%String:适应症,f8:%String:辅料,f9:%String:汉语拼音,f10:%String:性状,f11:%String:规格,f12:%String:用法用量,f13:%String:不良反应,f14:%String:禁忌,f15:%String:禁忌症,f16:%String:注意事项,f17:%String:药物相互作用,f18:%String:相互作用,f19:%String:孕妇及哺乳期妇女用药,f20:%String:儿童用药,f21:%String:老年用药,f22:%String:药物过量,f23:%String:临床试验,f24:%String:药理毒理,f25:%String:药理作用,f26:%String:药代动力学,f27:%String:贮藏,f28:%String:包装,f29:%String:有效期,f30:%String:执行标准,f31:%String:批准文号,f32:%String:核准日期,f33:%String:修改日期,f34:%String:生产厂家,f35:%String:药学分类,f36:%String:剂型,f37:%String:配伍禁忌,f38:%String:FDA妊娠药物分级,f39:%String:等效单位,f40:%String:是否OTC,f41:%String:注册证号,f42:%String:哺乳期分级,f43:%String:进口许可证号,f44:%String:进口药品注册证号,f45:%String:专科分类,f46:%String:皮试药品,f47:%String:高危药品标志,f48:%String:国家基本药物")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInstructions") 
ClassMethod ExportDrugInstructionsExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k generalArr
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()	// 西药	
	s dicID = ""
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugData,dicID))  q:(dicID="")||(ind>10000)  d
	.//q:dicID'=292
	.s dicName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	.s dicName = $tr(dicName,$c(10),"")
	.s dicName = $tr(dicName,$c(10,10),"")
	.s dicName = $tr(dicName,$c(10,13),"")
	.s dicName = $tr(dicName,$c(13),"")
	.q:dicName["复制"
	.k TmpArr
	.s entityID=##class(web.DHCCKBCommon).GetDrug()	// 西药实体
	.d ..QueryDrugInstructions(.TmpArr,entityID_"^"_dicID) // 一个药品
	.s listData=..DealDrugColumn(.TmpArr)	// 将纵向列转换成横向列
	.s tmpListData = $listtostring(listData)	
    .s tmpListData = $tr(tmpListData,",","")
    .q:tmpListData=""
    .s generalFrom = ##class(web.DHCCKBCommon).GetGeneralFrom(dicID,0)	// 带计型的通用名
    .s generalFrom = $listtostring(generalFrom)
    .q:(generalFrom'="")&&($d(generalArr(generalFrom)))
    .s:generalFrom'="" generalArr(generalFrom)=dicID
	.s listData = dicID_","_dicName_","_$listtostring(listData)
	.s listData = $listfromstring(listData)
	.set ^CacheTemp(repid,ind)=listData 
	.set ind=ind+1	
	.w ind,!
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description:	查询药品说明书(所有属性)
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-10	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBEditProp).QueryDrugInstructions("1000","1","^150")
ClassMethod QueryDrugInstructions(TmpArr, params) As %String
{
	n (TmpArr,params)

	s dicID=$p(params,"^",1)		  	//实体ID
	s EntyId=$p(params,"^",2)
	if dicID=""  s dicID=##class(web.DHCCKBCommon).GetDrug()		// 默认显示药品字典数据
	q:dicID="" ""
				
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时globalD
    
    s linkPropID=##class(web.DHCCKBRangeCat).GetAttrLink(dicID,"LinkProp")  //##class(web.DHCCKBCommon).GetLinkProp()	// 属性关联id
    s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()		// 是否需要维护属性值
    s dataTypeID=##class(web.DHCCKBCommon).GetDataType()					// 数据展现类型
	Q:linkPropID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
   	s h=0,linkRowID="" 
	for  s linkRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,linkPropID,linkRowID)) Q:linkRowID=""  d
	.s attrparref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性集合
	.d ##class(web.DHCCKBDiction).SortAttrByOrd(attrparref,pid,0)			//sufan 2020-04-08 排序
	.s Index=""
	.f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))  q:Index=""  d
	..s attrID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))
	..s tmpAttrID=attrID
	..s attrLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	..i attrLinkDr'="" s tmpAttrID=attrLinkDr	// 没有属性值，属性值link其他属性 
	..// 判断是否需要维护属性值
	..s tmpLinkID="",AddValueId="",AddValueFlag=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID,""))
	..i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	..q:$g(AddValueFlag)="N"
	..//数据展现形式
	..s tmpLinkID=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID))  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID,""))
	..s dataTypeDr=""
	..i tmpLinkID'="" s dataTypeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s dataType=""
	..i dataTypeDr'="" s dataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataTypeDr)),2)	// 具体属性的数据类型
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),2)
	..s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),3)
	..//取维护的属性值
	..s AttrValue=..QueryAttrValue(EntyId,attrID)
	..///取值结束
	..s h=h+1
	..s AttrValue = $replace(AttrValue,$c(10,10),"<br/>")
	..s AttrValue = $replace(AttrValue,$c(10),"<br/>")
	..s AttrValue = $replace(AttrValue,$c(13),"<br/>")
	..s AttrValue = $replace(AttrValue,$c(10,13),"<br/>")
	..s AttrValue = $replace(AttrValue,",","，") // 文本中的逗号替换成中文的逗号
	..s data=attrID_"^"_attrCode_"^"_attrDesc_"^"_dataType_"^"_AttrValue
	..s TmpArr(h)=data
	
	q ""
}

/// Description:	将纵向的药品信息转换成横向列
/// Creator:		QuNianpeng 
/// CreateDate:		2020-12-29
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBEditProp).QueryDrugInstructions("1000","1","^150")
ClassMethod DealDrugColumn(TmpArr) As %String
{
	n (TmpArr)
	s dataList = ""
	Set index = ""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData = $get(TmpArr(index))
	.set value = $p(listData,"^",5)
	.set $list(dataList,*+1) = value
	
	q dataList
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).QueryAttrValue(1936,38)
ClassMethod QueryAttrValue(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	s Ret=..GetAttrValue(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrValue(EntyId,LinkId)			//取本身
	Q Ret
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).GetAttrValue(1936,38)
ClassMethod GetAttrValue(EntyId, AttrCodeId)
{
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId))  Q:AttrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	...s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:DicLinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3)
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s:ListData'="" GroupArr(GroupFlag)=GroupArr(GroupFlag)_"-"_ListData
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)	
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:LinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_";"_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData

	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_";"_data
	k GroupArr
	Q QuitList
}

/// Creator:      qunianpeng
/// CreatDate:    2020-12-29
/// Description:  导出药品说明书内容(中成药)
/// w ##class(web.DHCCKBExport).CopyDrugData()
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportChDrugInstructions")
/// w ##Class(websys.Query).ToExcel("药品说明书(中成药)","web.DHCCKBExport","ExportChDrugInstructions")
Query ExportChDrugInstructions() As websys.Query(ROWSPEC = "f0:%String:药品名称,f1:%String:通用名（含剂型）,f2:%String:通用名,f3:%String:商品名,f4:%String:用药指导,f5:%String:汉语拼音,f6:%String:成分,f7:%String:辅料,f8:%String:性状,f9:%String:功能主治,f10:%String:规格,f11:%String:用法用量,f12:%String:不良反应,f13:%String:禁忌,f14:%String:注意事项,f15:%String:药物相互作用,f16:%String:药理毒理,f17:%String:药理作用,f18:%String:贮藏,f19:%String:包装,f20:%String:有效期,f21:%String:执行标准,f22:%String:批准文号,f23:%String:核准日期,f24:%String:修改日期,f25:%String:生产厂家,f26:%String:药代动力学,f27:%String:剂型,f28:%String:是否OTC,f29:%String:适应症,f30:%String:禁忌症,f31:%String:相互作用,f32:%String:临床试验,f33:%String:药学分类,f34:%String:配伍禁忌,f35:%String:警告,f36:%String:药物过敏,f37:%String:用法,f38:%String:配药方法,f39:%String:等效单位,f40:%String:专科分类,f41:%String:高危标志,f42:%String:皮试药品")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportChDrugInstructions") 
ClassMethod ExportChDrugInstructionsExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1

	s drugData = ##class(web.DHCCKBCommon).GetChineseDrugData() // 中西药	
	s dicID = ""
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugData,dicID))  q:dicID=""  d
	.//q:dicID'=81694
	.s dicName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	.s dicName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	.s dicName = $tr(dicName,$c(10),"")
	.s dicName = $tr(dicName,$c(10,10),"")
	.s dicName = $tr(dicName,$c(10,13),"")
	.s dicName = $tr(dicName,$c(13),"")
	.q:dicName["复制"
	.k TmpArr
	.s entityID=##class(web.DHCCKBCommon).GetChineseDrug()	// 西药实体
	.d ..QueryDrugInstructions(.TmpArr,entityID_"^"_dicID) // 一个药品
	.s listData=..DealDrugColumn(.TmpArr)	// 将纵向列转换成横向列
	.s tmpListData = $listtostring(listData)
    .s tmpListData = $tr(tmpListData,",","")
    .q:tmpListData=""
	.s listData = dicName_","_$listtostring(listData)
	.s listData = $listfromstring(listData)
	.set ^CacheTemp(repid,ind)=listData 
	.set ind=ind+1	
	.w ind,!
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	

	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)
}

/// Creator:      qunianpeng
/// CreatDate:    2021-05-07
/// Description:  导出当前各项目已对照上的药品列表;根据知识库名称去重后，按照药品中所含规则发布时间给药品排序（以最早发布的那条规则时间为准）
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportConstDrugUserDate")
/// w ##Class(websys.Query).ToExcel("CKB_Excelch","web.DHCCKBExport","ExportConstDrugUserDate")
/// libCode_"^"_libDesc_"^"_extCode_"^"_extDesc_"^"_typeDesc_"^"_hosptial_"^"_datetime_"^"_ruleFlag
Query ExportConstDrugUserDate() As websys.Query(ROWSPEC = "f0:%String:系统代码,f1:%String:系统名称,f2:%String:his代码,f3:%String:his名称,f4:%String:大类,f5:%String:医院,f6:%String:规则时间,f7:%String:是否有规则(1有0无),f8:%String:备注")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportChDrugInstructions") 
ClassMethod ExportConstDrugUserDateExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	k TmpArr,TmpOutArr
	/* 查询所有的对照药品(多个项目) */	
	d ..QueryAllConstDrug(.TmpArr)
	
	/* 药品根据规则发布时间排序 */
	d ..SortByRuleDate(.TmpArr,.TmpOutArr)
	
	s index = ""
	f  s index = $o(TmpOutArr(index))  q:index=""  d
	.s count = ""
	.f  s count = $o(TmpOutArr(index,count)) q:count=""  d
	..s listData = $g(TmpOutArr(index,count))
	..s ^CacheTemp(repid,ind)=listData 
	..s ind=ind+1
	w !	
	w ind,!
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      qunianpeng
/// CreatDate:    2021-05-07
/// Description:  查询所有的对照药品(多个项目)
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportConstDrugUserDate")
/// w ##Class(websys.Query).ToExcel("CKB_Excelch","web.DHCCKBExport","ExportConstDrugUserDate")
ClassMethod QueryAllConstDrug(TmpArr) As %String
{
	n (TmpArr)
	s index = 0
	s hospId = ""
	f  s hospId = $o(^CKB.PDSS.ExtDictionI("Type",hospId))	q:hospId=""   d
	.q:(hospId=2)||(+hospId<=0)||(hospId=103)	//103 武汉一院旧条目
	.s hosptial = $p($g(^CT("HOSP",+hospId)),"^",2)
	.//s typeList = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	.s typeList = $lb("DrugData") // 暂时只要西药
	.f i=1:1:$listlength(typeList)  d
	..s type = $lg(typeList,i)
	..s typeId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	..s typeDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+typeId)),3)
	..s extRowId = ""
	..f  s extRowId = $o(^CKB.PDSS.ExtDictionI("Type",hospId,type,extRowId)) q:extRowId=""  d
	...s extData = $g(^CKB.PDSS.ExtDictionD(extRowId))
	...s extCode = $lg(extData,2)
	...s extDesc = $lg(extData,3)
    ...s extDesc = $p(extDesc,"||",1)
    ...s constStr = ##class(web.DHCCKBComContrast).GetSysConst(extCode,extDesc,typeId) // 获取对照的系统数据
    ...s libCode = $p(constStr,"^",1)
    ...s libDesc = $p(constStr,"^",2)
    ...q:(libCode="")||(libDesc="")
    ...s index = index + 1
    ...s TmpArr(index) = libCode_"^"_libDesc_"^"_extCode_"^"_extDesc_"^"_typeDesc_"^"_hosptial
    
    q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2021-05-07
/// Description:  对照药品排序(多个项目)
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportConstDrugUserDate")
/// w ##Class(websys.Query).ToExcel("CKB_Excelch","web.DHCCKBExport","ExportConstDrugUserDate")
ClassMethod SortByRuleDate(TmpArr, TmpOutArr) As %String
{
	n (TmpArr,TmpOutArr)
	
	s count = 0 
	s index = ""
	f  s index = $o(TmpArr(index)) q:index=""  d
	.s listData = $g(TmpArr(index))
    .s libCode = $p(TmpArr(index),"^",1)
    .s libDesc = $p(TmpArr(index),"^",2)
    .s parrefDesc = $p(TmpArr(index),"^",5)
    .s parref = ##class(DHCCKBCommon).GetDicIdByDesc(parrefDesc)
    .s dicID = ##class(web.DHCCKBCommon).GetDicIDByCodeDesc(libCode,libDesc,parref)
    .q:dicID=0
    ./* 遍历规则,找到最早的规则发布时间 以第一条规则的发布时间为准即可*/
    .s isExistRule = ##class(web.DHCCKBCommon).IsExistRule(dicID)
    .s exitFlag = 0, ruleEarliestDate=""
    .s ruleDicID = ""
    .f  s ruleDicID = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))	q:(ruleDicID="")||(exitFlag=1)  d
    ..s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),2)
    ..q:rule=0
    ..s ruleDate = ..GetReleaseRuleDate(rule)
    ..i ruleDate'="" d
    ...s exitFlag=1
   	...s ruleEarliestDate = ruleDate
   	./* 按照规则发不时间排序 */
   	.i isExistRule = 0 s ruleEarliestDate=0
   	.s content = ""
   	.i (ruleEarliestDate="")&(isExistRule=1) s content="规则全部取消发布状态"
   	.i ruleEarliestDate="" s ruleEarliestDate=0   
   	.s count = count + 1
   	.s dateTime = "" 
   	.i ruleEarliestDate'=0 s dateTime=$zd(ruleEarliestDate)_$zt($p(ruleEarliestDate,",",2))
   	.s listData = listData_"^"_dateTime_"^"_isExistRule_"^"_content
   	.s listData = $tr(listData,",",".")
   	.s TmpOutArr($tr(ruleEarliestDate,",",""),count)=$listfromstring(listData,"^")
   	
    q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2021-05-07
/// Description:  获取规则的发布时间
/// Input：		  rule
/// Other:       w ##Class(web.DHCCKBExport).GetReleaseRuleDate(134875)
ClassMethod GetReleaseRuleDate(rule) As %String
{
	n (rule)
	
	s status = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	q:status'="Release" ""
	
	s ruleDateTime = "",exitFlag=0
	s ruleLog = ""
	f  s ruleLog = $o(^CKB.PDSS.RuleLogI("Rule",rule,ruleLog))  	q:(ruleLog="")||(exitFlag=1)  d
	.s logData = $g(^CKB.PDSS.RuleLogD(ruleLog))
	.s ruleDate = $lg(logData,4) 
	.s ruleTime = $lg(logData,5)
	.//s ruleDate = $zdh(ruleDate,3)
	.//s ruleTime = $zth(ruleTime,3) // 范围0~86399
	.s ruleTime = ..ChangeStr(ruleTime)
	.s ruleDateTime = ruleDate_","_ruleTime
	.i ruleDateTime'="" s exitFlag = 1

	q ruleDateTime
}

/// Creator:      qunianpeng
/// CreatDate:    2021-05-07
/// Description:  时间补零
/// Input：		  time
/// Other:        w ##Class(web.DHCCKBExport).ChangeStr(21245)
ClassMethod ChangeStr(time) As %String
{
	n (time)
	
	q:$length(time)=5 time
	
	s curNum = 5-$length(time)
	f i=1:1:curNum  d
	.s time = "0"_time
	
	q time
}

/// Creator:      qunianpeng
/// CreatDate:    2020-04-16
/// Description:  导出药品,通用名,规格,厂家,类型,是否有规则
/// Input:		  检索条件,登录信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData")
/// w ##Class(websys.Query).ToExcel("CKB_Excel药品目录20210524-公共+哈医大","web.DHCCKBExport","ExportDrugInfoData1") 
/// s TmpArr(ID)=$lb(Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval)
Query ExportDrugInfoData1() As websys.Query(ROWSPEC = "f0:%String:药品唯一码,f1:%String:代码,f2:%String:描述,f3:%String:通用名,f4:%String:规格,f5:%String:厂家,f6:%String:类型,f7:%String:是否有规则,f8:%String:商品名,f9:%String:剂型,f10:%String:大类,f11:%String:批准文号,f12:%String:药品单位")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData") 
ClassMethod ExportDrugInfoData1Execute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	// 西药
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	d ..QueryDrugInfoDataByParref1(DrugData,.TmpArr,"DrugData")

	// 中成药
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	d ..QueryDrugInfoDataByParref1(ChineseDrugData,.TmpArr,"ChineseDrugData")
	
	
	Set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataByParref1(Parref, TmpArr, type)
{
	n (Parref,TmpArr,type)
	q:+Parref=0
	s ID=""
	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,ID)) q:ID=""  d
	.s IsEnabled=##class(web.DHCCKBCommon).IsEnabled(ID)
	.q:IsEnabled=0
	.d ..QueryDrugInfoDataTemp1(ID,.TmpArr,Parref)
	
	/*
	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,ID)) q:ID=""  d
	.s IsEnabled=##class(web.DHCCKBCommon).IsEnabled(ID)
	.q:IsEnabled=0
	.d ..QueryDrugInfoDataTemp2(ID,.TmpArr,Parref)
	*/
	d ..QueryDrugInfoDataParref(.TmpArr,94,type)
	d ..QueryDrugInfoDataParref(.TmpArr,94,type)
	//d ..QueryDrugInfoDataParref(.TmpArr,95)
	/*
	f  s ID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,ID)) q:ID=""  d
	.s IsEnabled=##class(web.DHCCKBCommon).IsEnabled(ID)
	.q:IsEnabled=0
	.d ..QueryDrugInfoDataTemp3(ID,.TmpArr,Parref)
	*/
	q ""
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataTemp1(ID, TmpArr, Parref = "")
{
	
	n (ID,TmpArr,Parref)
	
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	//s Code=$tr(Code,",",".")
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	//s Desc=$tr(Desc,",",".")
	q:(Desc["作废")||(Desc["复制") ""
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	s:Parref'=0 Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),3)
	
	/* 是否有规则 */
	s HasRuleFlag=##class(web.DHCCKBCommon).IsExistRule(ID)
	s HasRuleFlag=$case(HasRuleFlag,1:"有",:"无")
	s exitFlag = -1
	s hisCode = ""
	f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode))  q:(hisCode="")||(exitFlag=0)  d
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode,constID))  q:(constID="")||(exitFlag=0)  d
	..s hisDesc = $lg(^CKB.PDSS.ComContrastD(+constID),5)
	..s hosptial = $lb(94,95,96,97,98,99,100,101,102)
	..f i=1:1:$listlength(hosptial)  d
	...s hosp = $listget(hosptial,i)
	...s flag = ##class(web.DHCCKBComContrast).CheckFlag(hisCode,hisDesc,hosp)
	...i flag=0 s exitFlag=0
	...i flag=1 s exitFlag=1

	q:exitFlag<=0 ""
	s ^TMP("DHCCKB","Export",ID)=ID
	s Code=$tr(Code,",",".")
	s Desc=$tr(Desc,",",".")
	/* 规格  */
	s SpecificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	s Spec=..QueryAttrValueByCode(ID,SpecificationProp)
	
	/* 带剂型的通用名 */
	s GenerNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	s GeneralName=..QueryAttrValueByCode(ID,GenerNameFormProp)	
	
	/* 厂家 */
	s ManfStr=""
	s ManfID=##class(web.DHCCKBCommon).GetDrugManf()
	s ManfStr=..QueryAttrValueByCode(ID,ManfID)
	
	/* 商品名 */
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名
	s ProName = ..QueryAttrValueByCode(ID,proNameProp)
	
	/* 剂型 */	
	s FromProp = ##class(web.DHCCKBCommon).GetDrugForm() // 剂型
	s From = ..QueryAttrValueByCode(ID,FromProp)
	
	/* 大类 */
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s Type = $select(Parref=DrugData:"西药",Parref=ChineseDrugData:"中成药",Parref=ChineseHMData:"中药饮片",1:"")	
		
	/* 批准文号 */
	s ApprovalProp = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Approval = ..QueryAttrValueByCode(ID,ApprovalProp)
	
	/* 药品单位  - 取等效单位的第一列 */
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s DrugUnit = ..QueryEqFromUnit(ID,eqFromUnitProp)
	
	/* 药品唯一编码 */
	s Identity = ..QueryIdentity(ID)
	
	s TmpArr(ID)=$lb(Identity,Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval,DrugUnit)
	
	q ""
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataTemp2(ID, TmpArr, Parref = "")
{
	
	n (ID,TmpArr,Parref)
	
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	//s Code=$tr(Code,",",".")
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	//s Desc=$tr(Desc,",",".")
	q:(Desc["作废")||(Desc["复制") ""
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	s:Parref'=0 Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),3)
	
	/* 是否有规则 */
	s HasRuleFlag=##class(web.DHCCKBCommon).IsExistRule(ID)
	s HasRuleFlag=$case(HasRuleFlag,1:"有",:"无")
	s exitFlag = -1
	s hisCode = ""
	f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode))  q:(hisCode="")||(exitFlag=0)  d
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode,constID))  q:(constID="")||(exitFlag=0)  d
	..s hisDesc = $lg(^CKB.PDSS.ComContrastD(+constID),5)
	..s hosptial = $lb(94)
	..f i=1:1:$listlength(hosptial)  d
	...s hosp = $listget(hosptial,i)
	...s flag = ##class(web.DHCCKBComContrast).CheckFlag(hisCode,hisDesc,hosp)
	...i flag=0 s exitFlag=0
	...i flag=1 s exitFlag=1

	q:exitFlag<=0 ""
	q:$d(TmpArr(ID)) ""
	s Code=$tr(Code,",",".")
	s Desc=$tr(Desc,",",".")
	/* 规格  */
	s SpecificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	s Spec=..QueryAttrValueByCode(ID,SpecificationProp)
	
	/* 带剂型的通用名 */
	s GenerNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	s GeneralName=..QueryAttrValueByCode(ID,GenerNameFormProp)	
	
	/* 厂家 */
	s ManfStr=""
	s ManfID=##class(web.DHCCKBCommon).GetDrugManf()
	s ManfStr=..QueryAttrValueByCode(ID,ManfID)
	
	/* 商品名 */
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名
	s ProName = ..QueryAttrValueByCode(ID,proNameProp)
	
	/* 剂型 */	
	s FromProp = ##class(web.DHCCKBCommon).GetDrugForm() // 剂型
	s From = ..QueryAttrValueByCode(ID,FromProp)
	
	/* 大类 */
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s Type = $select(Parref=DrugData:"西药",Parref=ChineseDrugData:"中成药",Parref=ChineseHMData:"中药饮片",1:"")	
		
	/* 批准文号 */
	s ApprovalProp = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Approval = ..QueryAttrValueByCode(ID,ApprovalProp)
	
	/* 药品单位  - 取等效单位的第一列 */
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s DrugUnit = ..QueryEqFromUnit(ID,eqFromUnitProp)
	
	/* 药品唯一编码 */
	s Identity = ..QueryIdentity(ID)
	
	s TmpArr(ID)=$lb(Identity,Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval,DrugUnit)
	
	q ""
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataTemp3(ID, TmpArr, Parref = "")
{
	
	n (ID,TmpArr,Parref)
	
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	//s Code=$tr(Code,",",".")
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	//s Desc=$tr(Desc,",",".")
	q:(Desc["作废")||(Desc["复制") ""
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	s:Parref'=0 Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),3)
	
	/* 是否有规则 */
	s HasRuleFlag=##class(web.DHCCKBCommon).IsExistRule(ID)
	s HasRuleFlag=$case(HasRuleFlag,1:"有",:"无")
	s exitFlag = -1
	s hisCode = ""
	f  s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode))  q:(hisCode="")||(exitFlag=0)  d
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(Code),hisCode,constID))  q:(constID="")||(exitFlag=0)  d
	..s hisDesc = $lg(^CKB.PDSS.ComContrastD(+constID),5)
	..s hosptial = $lb(95)
	..f i=1:1:$listlength(hosptial)  d
	...s hosp = $listget(hosptial,i)
	...s flag = ##class(web.DHCCKBComContrast).CheckFlag(hisCode,hisDesc,hosp)
	...i flag=0 s exitFlag=0
	...i flag=1 s exitFlag=1

	q:exitFlag<=0 ""
	q:$d(TmpArr(ID)) ""
	s Code=$tr(Code,",",".")
	s Desc=$tr(Desc,",",".")
	/* 规格  */
	s SpecificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	s Spec=..QueryAttrValueByCode(ID,SpecificationProp)
	
	/* 带剂型的通用名 */
	s GenerNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	s GeneralName=..QueryAttrValueByCode(ID,GenerNameFormProp)	
	
	/* 厂家 */
	s ManfStr=""
	s ManfID=##class(web.DHCCKBCommon).GetDrugManf()
	s ManfStr=..QueryAttrValueByCode(ID,ManfID)
	
	/* 商品名 */
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名
	s ProName = ..QueryAttrValueByCode(ID,proNameProp)
	
	/* 剂型 */	
	s FromProp = ##class(web.DHCCKBCommon).GetDrugForm() // 剂型
	s From = ..QueryAttrValueByCode(ID,FromProp)
	
	/* 大类 */
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s Type = $select(Parref=DrugData:"西药",Parref=ChineseDrugData:"中成药",Parref=ChineseHMData:"中药饮片",1:"")	
		
	/* 批准文号 */
	s ApprovalProp = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Approval = ..QueryAttrValueByCode(ID,ApprovalProp)
	
	/* 药品单位  - 取等效单位的第一列 */
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s DrugUnit = ..QueryEqFromUnit(ID,eqFromUnitProp)
	
	/* 药品唯一编码 */
	s Identity = ..QueryIdentity(ID)
	
	s TmpArr(ID)=$lb(Identity,Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval,DrugUnit)
	
	q ""
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataParref(TmpArr, hosp, type)
{
	n (TmpArr,hosp,type)

	s count =0
	s extID = ""
	f  s extID = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extID)) q:extID=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extID)) 
	.s extCode = $lg(extData,2)
	.s extDesc = $lg(extData,3)
	.s constID = ""
	.f  s constID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode),constID))	q:constID=""  d
	..s libCode = $lg(^CKB.PDSS.ComContrastD(constID),2)
	..s count = count + 1
	..s ID = ##class(DHCCKBCommon).GetDicIdByCode(libCode,"105")
	..q:+ID=0
	..//s count = count + 1
	..d ..QueryDrugInfoDataTemp4(ID,.TmpArr,105)
	
	w "一共："_count,!
}

/// w ##class(web.DHCCKBExport).QueryDrugInfoDataTemp(150)
ClassMethod QueryDrugInfoDataTemp4(ID, TmpArr, Parref = "")
{
	
	n (ID,TmpArr,Parref)
		
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),2)
	//s Code=$tr(Code,",",".")
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(ID)),3)
	//s Desc=$tr(Desc,",",".")
	q:(Desc["作废")||(Desc["复制") ""
	s Parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ID)),4)
	s:Parref'=0 Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),3)
	
	/* 是否有规则 */
	s HasRuleFlag=##class(web.DHCCKBCommon).IsExistRule(ID)
	s HasRuleFlag=$case(HasRuleFlag,1:"有",:"无")
	
	q:$d(TmpArr(ID)) ""
	s Code=$tr(Code,",",".")
	s Desc=$tr(Desc,",",".")
	/* 规格  */
	s SpecificationProp=##class(web.DHCCKBCommon).GetSpecificationProp()	// 规格
	s Spec=..QueryAttrValueByCode(ID,SpecificationProp)
	
	/* 带剂型的通用名 */
	s GenerNameFormProp=##class(web.DHCCKBCommon).GetGeneralFromProp()	// 带剂型通用名
	s GeneralName=..QueryAttrValueByCode(ID,GenerNameFormProp)	
	
	/* 厂家 */
	s ManfStr=""
	s ManfID=##class(web.DHCCKBCommon).GetDrugManf()
	s ManfStr=..QueryAttrValueByCode(ID,ManfID)
	
	/* 商品名 */
	s proNameProp=##class(web.DHCCKBCommon).GetProNameProp()	// 商品名
	s ProName = ..QueryAttrValueByCode(ID,proNameProp)
	
	/* 剂型 */	
	s FromProp = ##class(web.DHCCKBCommon).GetDrugForm() // 剂型
	s From = ..QueryAttrValueByCode(ID,FromProp)
	
	/* 大类 */
	s DrugData = ##class(web.DHCCKBCommon).GetDrugData()
	s ChineseDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s ChineseHMData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s Type = $select(Parref=DrugData:"西药",Parref=ChineseDrugData:"中成药",Parref=ChineseHMData:"中药饮片",1:"")	
		
	/* 批准文号 */
	s ApprovalProp = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Approval = ..QueryAttrValueByCode(ID,ApprovalProp)
	
	/* 药品单位  - 取等效单位的第一列 */
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s DrugUnit = ..QueryEqFromUnit(ID,eqFromUnitProp)
	
	/* 药品唯一编码 */
	s Identity = ..QueryIdentity(ID)
	
	s TmpArr(ID)=$lb(Identity,Code,Desc,GeneralName,Spec,ManfStr,Parref,HasRuleFlag,ProName,From,Type,Approval,DrugUnit)
	
	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2022-03-16
/// Description:  导出错误的icd诊断
/// Input:		 
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportErrIcd")
/// w ##Class(websys.Query).ToExcel("问题icd诊断","web.DHCCKBExport","ExportErrIcd")
Query ExportErrIcd() As websys.Query(ROWSPEC = "code:%String:编码,desc:%String:名称,id:%String:id")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportErrIcd") 
/// @param: pid 进程号
ClassMethod ExportErrIcdExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	
	Set index=""	
	for  set index=$order(^TMPDHCCKB("DHCCKB","web.DHCCKBService",index)) quit:index=""  do
	.set listData=$get(^TMPDHCCKB("DHCCKB","web.DHCCKBService",index))
	.set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
