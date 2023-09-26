/// 名称: 奖金用收入数据生成
/// 描述: 根据设定的收入分配方法对HIS收入进行分配并保存
/// 编写者：许立新
/// 编写日期:2010-03-10
Class dhc.ca.cache.udata.DoIncomeDist Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 收入分配入口
/// Table: 
/// Input: intervalDr-核算周期
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).DistStart(1)
ClassMethod DistStart(intervalDr) As %String
{
	n (intervalDr)
	
	//生成临时收入数据
	s result1=##class(dhc.ca.cache.udata.uTmpInData).CreateTmpData(intervalDr)
	//保存临时收入数据
	s result2=##class(dhc.ca.cache.udata.uTmpInData).writeTmpInData()
	//分配临时收入数据
	s result3=..DoDist()
	//保存收入分配数据
	s result4=..DoSave(intervalDr)
	
	q "OK"
}

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 按设定的收入分配方法对收入进行分配
/// Table: dhc.ca.cache.data.InDistMethods
/// Input: 
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).DoDist()
ClassMethod DoDist() As %String
{
	//清除临时数据
	k ^TMPDHCCACALIN("dhc","ca","income")
	//读取收入分配方法
	s priority=""
	f  s priority=$o(^DHCCAINDISTMETHODS(0,"Priority",priority)) q:priority=""  d
	.s method=0
	.f  s method=$o(^DHCCAINDISTMETHODS(0,"Priority",priority,method)) q:method=""  d
	..i $d(^DHCCAINDISTMETHODS(method)) d
	...s filtRuleDr=$p($g(^DHCCAINDISTMETHODS(method)),"^",2)    //过滤规则Dr
	...s distRuleDr=$p($g(^DHCCAINDISTMETHODS(method)),"^",3)    //分配规则Dr
	...i filtRuleDr'="" && distRuleDr'="" d
	....s filtRule=..GetFiltRule(filtRuleDr)
	....s distRule=..GetDistRule(distRuleDr)
	....i filtRule'="" && distRule'="" d
	.....d ..Dist(filtRule,distRule)
	
	q "OK"
}

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 读取收入过滤规则
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: filtRuleDr-收入过滤规则Dr
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).GetFiltRule(1)
ClassMethod GetFiltRule(filtRuleDr) As %String
{
	n (filtRuleDr)
	
	s result=""
	q:filtRuleDr="" result
	//开单1!开单2!开单3^执行1!执行2^病人1!病人2^项目1!项目2!项目3^新项
	
	s fDepts=""
	s tDepts=""
	s patDepts=""
	s items=""
	s newItem=""
	
	//开单科室
	s child=0
	f  s child=$o(^DHCCAINFILTRULE(filtRuleDr,"FDepts",child)) q:child=""  d
	.s fDept=$p($g(^DHCCAINFILTRULE(filtRuleDr,"FDepts",child)),"^",1)
	.i fDept'="" d
	..i fDepts="" s fDepts=fDept
	..e  s fDepts=fDepts_"!"_fDept
	
	//执行科室
	s child=0
	f  s child=$o(^DHCCAINFILTRULE(filtRuleDr,"TDepts",child)) q:child=""  d
	.s tDept=$p($g(^DHCCAINFILTRULE(filtRuleDr,"TDepts",child)),"^",1)
	.i tDept'="" d
	..i tDepts="" s tDepts=tDept
	..e  s tDepts=tDepts_"!"_tDept
	
	//病人科室
	s child=0
	f  s child=$o(^DHCCAINFILTRULE(filtRuleDr,"PatDepts",child)) q:child=""  d
	.s patDept=$p($g(^DHCCAINFILTRULE(filtRuleDr,"PatDepts",child)),"^",1)
	.i patDept'="" d
	..i patDepts="" s patDepts=patDept
	..e  s patDepts=patDepts_"!"_patDept
	
	//收入项
	s child=0
	f  s child=$o(^DHCCAINFILTRULE(filtRuleDr,"Items",child)) q:child=""  d
	.s item=$p($g(^DHCCAINFILTRULE(filtRuleDr,"Items",child)),"^",1)
	.i item'="" d
	..i items="" s items=item
	..e  s items=items_"!"_item
	
	//新项
	s newItem=$p($g(^DHCCAINFILTRULE(filtRuleDr)),"^",4)
	
	s result=fDepts_"^"_tDepts_"^"_patDepts_"^"_items_"^"_newItem
	
	q result
}

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 读取收入分配规则
/// Table: dhc.ca.cache.data.InDistRules
/// Input: distRuleDr-收入分配规则Dr
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).GetDistRule(1)
ClassMethod GetDistRule(distRuleDr) As %String
{
	n (distRuleDr)
	
	s result=""
	q:distRuleDr="" result
	
	s distType=$p($g(^DHCCAINDISTRULE(distRuleDr)),"^",4)
	
	q:distType="" result
	
	s distStr=""

	i distType="LocType" d
	.s child=0
	.f  s child=$o(^DHCCAINDISTRULE(distRuleDr,"InDTRules",child)) q:child=""  d
	..s tmp=$g(^DHCCAINDISTRULE(distRuleDr,"InDTRules",child))
	..s deptType=$p(tmp,"^",1)
	..s deptRate=$p(tmp,"^",2)
	..i deptType'="" && deptRate'="" d
	...i distStr="" s distStr=deptType_":"_deptRate
	...e  s distStr=distStr_"!"_deptType_":"_deptRate
	
	i distType="Locs" d
	.s child=0
	.f  s child=$o(^DHCCAINDISTRULE(distRuleDr,"InDRules",child)) q:child=""  d
	..s tmp=$g(^DHCCAINDISTRULE(distRuleDr,"InDRules",child))
	..s dept=$p(tmp,"^",1)
	..s rate=$p(tmp,"^",2)
	..i dept'="" && rate'="" d
	...i distStr="" s distStr=dept_":"_rate
	...e  s distStr=distStr_"!"_dept_":"_rate
	
	i distType'="" && distStr'="" d
	.s result=distType_"^"_distStr
	
	q result
}

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 分配收入
/// Table: dhc.ca.cache.data.TmpInData
/// Input: filtRule-过滤规则,distRule-分配规则
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).Dist()
ClassMethod Dist(filtRule, distRule) As %String
{
	n (filtRule,distRule)
	
	q:(filtRule="" || distRule="") "Err"
	
	//过滤规则
	s fDepts=$p(filtRule,"^",1)
	s tDepts=$p(filtRule,"^",2)
	s patDepts=$p(filtRule,"^",3)
	s items=$p(filtRule,"^",4)
	s newItem=$p(filtRule,"^",5)
	
	//分配规则
	s distFlag=$p(distRule,"^",1)       //Locs LocType
	s distRule=$p(distRule,"^",2)       //Loc:rate!Loc:rate!Loc:rate
	
	//生成分配数据临时global
	s rowid=0
	f  s rowid=$o(^DHCCATMPINDATA(0,"Flag","N",rowid)) q:rowid=""  d
	.i $d(^DHCCATMPINDATA(rowid)) d
	..s tmp=^DHCCATMPINDATA(rowid)
	..//开单科室Dr^接收科室Dr^病人科室Dr^项目Dr^收费金额^病人类型^标志
	..s fDept=$p(tmp,"^",1)
	..s tDept=$p(tmp,"^",2)
	..s patDept=$p(tmp,"^",3)
	..s item=$p(tmp,"^",4)
	..i newItem'="" s item=newItem
	..s fee=$p(tmp,"^",5)
	..s patType=$p(tmp,"^",6)
	..s fFlag=0
	..s tFlag=0
	..s patFlag=0
	..s itemFlag=0
	..i fDepts'="" d
	...i ..IsIn(fDept, fDepts, "!")="N"  s fFlag=1
	..i tDepts'="" d
	...i ..IsIn(tDept, tDepts, "!")="N"  s tFlag=1
	..i patDepts'="" d
	...i ..IsIn(patDept, patDepts, "!")="N"  s patFlag=1
	..i items'="" d
	...i ..IsIn(item, items, "!")="N"  s itemFlag=1
	..i (fFlag=0)&&(tFlag=0)&&(patFlag=0)&&(itemFlag=0) d 
	...//计算分配结果
	...i distFlag="LocType" d
	....s fRate=$p($p(distRule,"!",1),":",2)
	....s tRate=$p($p(distRule,"!",2),":",2)
	....s patRate=$p($p(distRule,"!",3),":",2)
	....s sumRate=fRate+tRate+patRate
	....i sumRate'=0 d
	.....s fFee=fee*fRate/sumRate
	.....s tFee=fee*tRate/sumRate
	.....s patFee=fee*patRate/sumRate
	.....//累加临时global
	.....i fFee'=0 d
	......i $d(^TMPDHCCACALIN("dhc","ca","income",fDept,"order",patType,item)) s ^TMPDHCCACALIN("dhc","ca","income",fDept,"order",patType,item)=^TMPDHCCACALIN("dhc","ca","income",fDept,"order",patType,item)+fFee
	......e  s ^TMPDHCCACALIN("dhc","ca","income",fDept,"order",patType,item)=fFee
	.....i tFee'=0 d
	......i $d(^TMPDHCCACALIN("dhc","ca","income",tDept,"do",patType,item)) s ^TMPDHCCACALIN("dhc","ca","income",tDept,"do",patType,item)=^TMPDHCCACALIN("dhc","ca","income",tDept,"do",patType,item)+tFee
	......e  s ^TMPDHCCACALIN("dhc","ca","income",tDept,"do",patType,item)=tFee
	.....i patFee'=0 d
	......i $d(^TMPDHCCACALIN("dhc","ca","income",patDept,"pat",patType,item)) s ^TMPDHCCACALIN("dhc","ca","income",patDept,"pat",patType,item)=^TMPDHCCACALIN("dhc","ca","income",patDept,"pat",patType,item)+patFee
	......e  s ^TMPDHCCACALIN("dhc","ca","income",patDept,"pat",patType,item)=patFee
	.....s r=..TmpInUpdate(rowid,"Y") //更新标志
	...i distFlag="Locs" d
	....s sumRate=0
	....f locs=1:1:$l(distRule,"!") d
	.....s sumRate=sumRate+$p($p(distRule,"!",locs),":",2)
	....f locs=1:1:$l(distRule,"!") d
	.....s loc=$p($p(distRule,"!",locs),":",1)
	.....s rate=$p($p(distRule,"!",locs),":",2)/sumRate
	.....s tmpFee=fee*rate
	.....i (locs'="") && (tmpFee'=0) d
	......i $d(^TMPDHCCACALIN("dhc","ca","income",loc,"desig",patType,item)) s ^TMPDHCCACALIN("dhc","ca","income",loc,"desig",patType,item)=^TMPDHCCACALIN("dhc","ca","income",loc,"desig",patType,item)+tmpFee
	......e  s ^TMPDHCCACALIN("dhc","ca","income",loc,"desig",patType,item)=tmpFee
	......s r=..TmpInUpdate(rowid,"Y") //更新标志
	
	q "OK"
}

/// Creator: 许立新
/// CreatDate: 2010-03-15
/// Description: 修改临时收入数据表标志
/// Table: dhc.ca.cache.data.TmpInData
/// Input: rowid-行号,falg-标志
/// Output: 
/// Return: SQLCode
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).TmpInUpdate("Y")
ClassMethod TmpInUpdate(rowid, flag) As %String
{
	n (rowid,flag)
	
	&SQL(UPDATE dhc_ca_cache_data.TmpInData SET TmpInData_flag=:flag WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2010-03-13
/// Description: 执行收入数据保存
/// Table: 
/// Input: intervalDr-核算周期
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).DoSave(5)
ClassMethod DoSave(intervalDr) As %String
{
	n (intervalDr)
	
	s result="OK"
	
	q:intervalDr="" "SaveErr"
	
	//循环数据 ^TMPDHCCACALIN("dhc","ca","income",tDept,"pat",patType,item)
	//intervalDr^flag^deptDr^itemDr^fee^inType^remark
	s dept=0
	f  s dept=$o(^TMPDHCCACALIN("dhc","ca","income",dept)) q:dept=""  d
	.s flag=""
	.f  s flag=$o(^TMPDHCCACALIN("dhc","ca","income",dept,flag)) q:flag=""  d
	..s type=""
	..f  s type=$o(^TMPDHCCACALIN("dhc","ca","income",dept,flag,type)) q:type=""  d
	...s item=0
	...f  s item=$o(^TMPDHCCACALIN("dhc","ca","income",dept,flag,type,item)) q:item=""  d
	....s fee=^TMPDHCCACALIN("dhc","ca","income",dept,flag,type,item)
	....i (fee'="") && (fee'=0) d
	.....s data=intervalDr_"^"_flag_"^"_dept_"^"_item_"^"_fee_"^"_type
	.....s res=..Insert(data)                  //调用插入数据函数
	.....i res'=0 s result="Err"
	
	k ^TMPDHCCACALIN("dhc","ca","income")
	
	q result
}

/// Creator: 许立新
/// CreatDate: 2010-03-13
/// Description: 保存分配好的收入数据
/// Table: dhc.ca.cache.data.InDistData
/// Input: data-收入数据
/// Output: 
/// Return: SQLCode
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).Insert("a^b^c")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataErr"                   //准备插入的数据为空返回
	
	//all="intervalDr^flag^deptDr^itemDr^fee^inType^remark"
	
	k PLIST
	
	s intervalDr=$p(data,"^",1)                  //核算月
	i intervalDr'="" s PLIST(2)=intervalDr
	
	s flag=$p(data,"^",2)                        //收入归属标志
	i flag'="" s PLIST(3)=flag
	
	s deptDr=$p(data,"^",3)                      //科室
	i deptDr'="" s PLIST(4)=deptDr
	
	s itemDr=$p(data,"^",4)                      //项目
	i itemDr'="" s PLIST(5)=itemDr
	
	s fee=$p(data,"^",5)                         //费用
	i fee'="" s PLIST(6)=fee
	
	s inType=$p(data,"^",6)                      //收入类别
	i inType'="" s PLIST(7)=inType
	
	s remark=$p(data,"^",7)                      //备注
	i remark'="" s PLIST(8)=remark
	
	&SQL(INSERT INTO dhc_ca_cache_data.InDistData VALUES PLIST())
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2010-03-10
/// Description: 判断字符串1是否包含在字符串2中
/// Table: 
/// Input: str1-字符串1,str2-字符串2,sep-分割符
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.DoIncomeDist).IsIn("A","A^B^C","^")
ClassMethod IsIn(str1, str2, sep) As %String
{
	n (str1,str2,sep)
	
	s result="N"
	
	f i=1:1:$l(str2,sep) d
	.s tmp=$p(str2,sep,i)
	.i tmp=str1 s result="Y"
	
	q result
}

Storage Default
{
<StreamLocation>^dhc.ca.c.DoIncomeDistS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
