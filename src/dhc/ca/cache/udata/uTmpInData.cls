/// 名称: 临时收入数据表
/// 描述: 收入数据分配前保存在此临时收入数据表中
/// 编写者：许立新
/// 编写日期:2010-03-09
Class dhc.ca.cache.udata.uTmpInData Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：许立新
/// CreatDate：2010-03-09
/// Description: 把汇总后的收入数据写入临时收入数据表
/// Table：dhc.ca.cache.data.TmpInData
/// Input：
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.udata.uTmpInData).writeTmpInData()
ClassMethod writeTmpInData() As %String
{
	k ^DHCCATMPINDATA
	
	s flag="N"                              //标志
	
	s DFlag=0
	
	//TSTART                                  //开始事务
	
	s fDeptDr=0
	f  s fDeptDr=$o(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr)) q:fDeptDr=""  d
	.s tDeptDr=0
	.f  s tDeptDr=$o(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr)) q:tDeptDr=""  d
	..s patDeptDr=0
	..f  s patDeptDr=$o(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr)) q:patDeptDr=""  d
	...s itemDr=0
	...f  s itemDr=$o(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr)) q:itemDr=""  d
	....s patType=""
	....f  s patType=$o(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr,patType)) q:patType=""  d
	.....s fee=^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr,patType)
	.....i fee'=0 d      //开单科室Dr^接收科室Dr^病人科室Dr^项目Dr^收费金额^病人类型^标志"
	......s data=fDeptDr_"^"_tDeptDr_"^"_patDeptDr_"^"_itemDr_"^"_fee_"^"_patType_"^"_flag
	......s tmp=..Insert(data)
	......i tmp'=0 s DFlag=1
	
	//i DFlag=0
	//.TCOMMIT
	//.k ^TMPDHCCA("dhc","ca","tmpincome")
	//e  TROLLBACK
	
	k ^TMPDHCCA("dhc","ca","tmpincome")
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-03-09
/// Description: 生成收入数据临时global
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：intervalDr-核算周期
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.udata.uTmpInData).CreateTmpData(1)
ClassMethod CreateTmpData(intervalDr) As %String
{
	n (intervalDr)
	
	k ^TMPDHCCA("dhc","ca","tmpincome")
	
	s rowid=0
	f  s rowid=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,rowid)) q:rowid=""  d
	.i $d(^DHCCAINCOMEDATAS(rowid)) d
	..s tmp=^DHCCAINCOMEDATAS(rowid)
	..s fDeptDr=$p(tmp,"^",11)              //开单科室
	..s tDeptDr=$p(tmp,"^",14)              //接收科室
	..s patDeptDr=$p(tmp,"^",17)            //病人科室
	..s itemDr=$p(tmp,"^",6)                //费用项目
	..s fee=$p(tmp,"^",7)                   //收费金额
	..s patType=$p(tmp,"^",3)               //病人类型
	..i (fDeptDr'="") && (tDeptDr'="") && (patDeptDr'="") &&(itemDr'="") && (patType'="") d
	...s tmpFee=$g(^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr,patType))
	...i tmpFee'="" s ^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr,patType)=tmpFee+fee
	...e  s ^TMPDHCCA("dhc","ca","tmpincome",fDeptDr,tDeptDr,patDeptDr,itemDr,patType)=fee
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-03-09
/// Description: 写入数据到临时数据表
/// Table：dhc.ca.cache.data.TmpInData
/// Input：data-数据字符串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.udata.uTmpInData).Insert("1^2^3^4^100^I^N")
ClassMethod Insert(data) As %String
{
	n (data)
	
	k PLIST
	
	//开单科室Dr^接收科室Dr^病人科室Dr^项目Dr^收费金额^病人类型^标志"
	//s data="11^22^33^44^100^I^N"
	
	s fDeptDr=$p(data,"^",1)                     //开单科室Dr
	i fDeptDr'="" s PLIST(2)=fDeptDr
	
	s tDeptDr=$p(data,"^",2)                     //接收科室Dr
	i tDeptDr'="" s PLIST(3)=tDeptDr
	
	s patDeptDr=$p(data,"^",3)                   //病人科室Dr
	i patDeptDr'="" s PLIST(4)=patDeptDr
	
	s itemDr=$p(data,"^",4)                      //项目Dr
	i itemDr'="" s PLIST(5)=itemDr
	
	s fee=$p(data,"^",5)                         //收费金额
	i fee'="" s PLIST(6)=fee
	
	s patType=$p(data,"^",6)                     //病人类型
	i patType'="" s PLIST(7)=patType
	
	s flag=$p(data,"^",7)                        //标志
	i flag'="" s PLIST(8)=flag
	
	&SQL(INSERT INTO dhc_ca_cache_data.TmpInData VALUES PLIST())
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uTmpInDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
