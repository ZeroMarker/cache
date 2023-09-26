Class dhc.ca.cache.comm.CommMethod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-11-12
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: userCode-用户代码;
/// Output:
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).CheckUser(1)
ClassMethod CheckUser(userCode) As %String
{
	n (userCode)

	q:userCode="" ""
	s userDr = 0
	s userDr=$o(^DHCCAUSERS(0,"Loginname",userCode,userDr))
	s personDr=""
	i userDr>0 d
	.s personDr=$p($g(^DHCCAUSERS(userDr)),"^",4)
	s flag="N"
	i personDr>0 d
	.s flag=$p($g(^DHCCAUNITPERSONS(personDr)),"^",18)
	i flag="" s flag="N"
	i flag="N" s personDr=""
	
	q personDr
}

/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查找内部科室与外部科室对照
/// Table: dhc.ca.cache.data.UnitDepts
/// Input: deptSetDr-部门套Dr; deptCode-外部部门Code;patType-病人类型
/// Output:
/// Return: 返回内部科室Dr
/// Others: w ##class(dhc.ca.cache.comm.CommMethod).DeptRelation(1,197,"")
ClassMethod DeptRelation(deptSetDr, deptCode, patType) As %String
{
	n (deptSetDr, deptCode, patType)
	
	s tmpId=""
	s inDeptDr=""
	
	q:deptCode=""
	
	f  s tmpId=$o(^DHCCAINDEPTSETS(0,"Outcode",deptSetDr,deptCode,tmpId)) q:tmpId=""   d
	.i ..CheckpatType(deptSetDr, deptCode, patType)="" d
	..s inDeptDr=$p($g(^DHCCAINDEPTSETS(deptSetDr,"InDepts",tmpId)),"^",2)
	.e  d
	..i $d(^DHCCAINDEPTSETS(0,"OutCodePattype",deptSetDr,deptCode,tmpId,patType)) d
	...s inDeptDr=$p($g(^DHCCAINDEPTSETS(deptSetDr,"InDepts",tmpId)),"^",2)
	q inDeptDr
}

/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查看是否存在此病人类型的数据
/// Table: dhc.ca.cache.data.UnitDepts
/// Input: deptSetDr-部门套Dr; deptCode-外部部门Code;patType-病人类型
/// Output:
/// Return: 返回内部科室Dr
/// Others: w ##class(dhc.ca.cache.comm.CommMethod).CheckpatType(1,197,"O")
ClassMethod CheckpatType(deptSetDr, deptCode, patType) As %String
{
	n (deptSetDr, deptCode, patType)
	
	q:patType="" ""
	
	s tmpId=""
	s inDeptDr=""
	f  s tmpId=$o(^DHCCAINDEPTSETS(0,"Outcode",deptSetDr,deptCode,tmpId)) q:tmpId=""  d
	.i tmpId'="" d
	..i $d(^DHCCAINDEPTSETS(0,"OutCodePattype",deptSetDr,deptCode,tmpId,patType)) d
	...s inDeptDr=$p($g(^DHCCAINDEPTSETS(deptSetDr,"InDepts",tmpId)),"^",2)
	q inDeptDr
}

/*
/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查找内部项目与外部项目对照
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: itemSetDr-项目套ID, itemCode-外部项目代码
/// Output:
/// Return: 返回内部项目ID
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).ItemRelation(1,"0102")
ClassMethod ItemRelation(itemSetDr, itemCode) As %String
{
	n (itemSetDr, itemCode)
	s outItemDr=""
	s outItemDr=$o(^DHCCAALLDATAITEMS(0,"Code",itemCode,outItemDr))
	s tmpId=""
	s inItemDr=""
	s tmpInDr=""
	f  s tmpInDr=$o(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr)) q:tmpInDr=""  d
	.i $d(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr,outItemDr)) s tmpId=tmpInDr
	i tmpId'="" d
	.s inItemDr=$p($g(^DHCCAINITEMSETS(itemSetDr,"InItems",tmpId)),"^",2)
	q inItemDr
}
*/
/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查找内部项目与外部项目对照
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: itemSetDr-项目套ID, itemCode-外部项目代码
/// Output:
/// Return: 返回内部项目ID
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).ItemRelation(1,"0102")
ClassMethod ItemRelation(itemSetDr, itemCode) As %String
{
 q:itemSetDr="" ""
 q:itemCode="" ""
 
 n (itemSetDr, itemCode)
 s outItemDr=""
 s outItemDr=$o(^DHCCAALLDATAITEMS(0,"Code",itemCode,outItemDr))
 s tmpId=""
 s inItemDr=""
 s tmpInDr=""
 f  s tmpInDr=$o(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr)) q:tmpInDr=""  d
 .q:outItemDr=""
 .i $d(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr,outItemDr)) s tmpId=tmpInDr
 i tmpId'="" d
 .s inItemDr=$p($g(^DHCCAINITEMSETS(itemSetDr,"InItems",tmpId)),"^",2)
 q inItemDr
}

/// Creator: 王赢赢
/// CreatDate: 2010-10-29
/// Description: 查找内部医生与外部医生对照
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: itemSetDr-项目套ID, itemCode-外部项目代码
/// Output:
/// Return: 返回内部项目ID
/// Others: w ##class(dhc.ca.cache.comm.CommMethod).UnitPersonsRelation("2634")
ClassMethod UnitPersonsRelation(outPerCode) As %String
{
 q:outPerCode="" ""
 n (outPerCode)
 s unitPerDr=""
 s outPerDr=$o(^DHCCAOUTPERSON(0,"OutCode",outPerCode,""))
 i outPerDr'="" d
 .s inPerDr=$p($g(^DHCCAOUTPERSON(outPerDr)),"^",6)
 .s unitPerDr=$p($g(^DHCCAINPERSON(inPerDr)),"^",3)
 q unitPerDr
 ;s unitPerCodeDr=$o(^DHCCAUNITPERSONS(0,"Code",unitPerCode,""))
 ;q unitPerCodeDr
}

/// Creator: ZJW
/// CreatDate: 2016-04-27  中国医大用（indeptsets=3）
/// Description: 根据his科室ID 获取 映射的核算科室ID和科室名称 
/// Table: ct_loc dhc.ca.cache.data.unitdepts dhc.ca.cache.data.indepts dhc.ca.cache.data.outdepts
/// Input: CtlocDR —— his科室ID;
/// Output: CBHSDeptDr_"^"_CBHSDeptName —— 核算科室ID^科室名称
/// Return: 
/// Others: w ##class(dhc.ca.cache.comm.CommMethod).CheckCtlocDept(1)
ClassMethod CheckCtlocDept(CtlocDR) As %String
{
	n (CtlocDR)

	q:CtlocDR="" "DR is NULL."
	s CtlocCode=$p(^CTLOC(CtlocDR),"^",1)
	s InDeptschildSub="",output="",num=1
	//可能根据病人类型有两个科室
	f  s InDeptschildSub=$o(^DHCCAINDEPTSETS(0,"Outcode",3,CtlocCode,InDeptschildSub)) q:InDeptschildSub=""  d
	.;s OutDeptschildSub=$o(^DHCCAINDEPTSETS(0,"Outcode",3,CtlocCode,InDeptschildSub,OutDeptschildSub))   //Only one
	.s CBHSDeptDr=$p($g(^DHCCAINDEPTSETS(3,"InDepts",InDeptschildSub)),"^",2)
	.s CBHSDeptName=$p($g( ^DHCCAUNITDEPTS(CBHSDeptDr)),"^",2)
	.;s output=output_"^"_num_"^"_CBHSDeptDr_"^"_CBHSDeptName
	.;s num=num+1
	.s output=CBHSDeptDr_"^"_CBHSDeptName
	
	q:output'="" output
	q:output="" "This CTDept isn't mapped in CBHS. "
}

Storage Default
{
<StreamLocation>^dhc.ca.c.CommMethodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
