/// 名称: 数据导入
/// 描述: 各种数据导入的类方法
/// 编写者：许立新
/// 编写日期:2009-11-29
Class dhc.ca.cache.comm.DataLoad Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

Projection DataLoad As %Projection.Java;

/// Creator：许立新
/// CreatDate：2009-11-30
/// Description: HIS收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetE(1,"demo","load",1)
ClassMethod HISDataSetE(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	
	TSTART
	s remark="HIS急诊收入"
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='O' and IncomeDatas_remark=:remark)
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	
	s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr_"^"_remark
	s job=$j
	//调用HIS收入查询函数
	s doIns=""
	d ..HISTmpDataE(start,end)
	s doIns=##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre(info,job)
	k ^TMPDHCALXY("dhc","ca","hisdata",job)
	i doIns =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q "OK"
}

/// d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetI(1,"demo","load",1)
ClassMethod HISDataSetI(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	
	TSTART
	s remark="HIS住院收入"
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='O' and IncomeDatas_remark=:remark)
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	
	s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr_"^"_remark
	s job=$j
	//调用HIS收入查询函数
	s doIns=""
	d ..HISTmpDataI(start,end)
	s doIns=##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre(info,job)
	k ^TMPDHCALXY("dhc","ca","hisdata",job)
	i doIns =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2009-11-30
/// Description: HIS收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetH(1,"demo","load",1)
ClassMethod HISDataSetH(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	TSTART
	s remark="HIS挂号收入"
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='O' and IncomeDatas_remark=:remark)
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	
	s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr_"^"_remark
	s job=$j
	//调用HIS收入查询函数
	s doIns=""
	.d ..HISTmpDataH(start,end)
	.s doIns=##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre(info,job)
	k ^TMPDHCALXY("dhc","ca","hisdata",job)
	i doIns =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2009-11-30
/// Description: HIS收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetO(1,"demo","load",1)
ClassMethod HISDataSetO(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	TSTART
	s remark="HIS门诊收入"
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='O' and IncomeDatas_remark=:remark)
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	
	s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr_"^"_remark
	s job=$j
	//调用HIS收入查询函数
	s doIns=""
	d ..HISTmpDataO(start,end) 
	s doIns=##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre(info,job)
	k ^TMPDHCALXY("dhc","ca","hisdata",job)
	
	i doIns =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-12-24
/// Description: 挂号收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetGh(61,"demo","load",1)
ClassMethod HISDataSetGh(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	q
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	.;w "开始日期: "_start,!
	.;w "终止日期: "_end,!
	.s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	.s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	.s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	.s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr
	.s job=$j
	.;s job=569954
	.//调用HIS收入查询函数
	.d ..HISTmpDataGh(start,end)
	.s doIns=##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre(info,job)
	k ^TMPDHCALXY("dhc","ca","hisdata",job)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-7
/// Description: HIS收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期  FlagDate  ORDDATE
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataE("2011-01-01","2011-01-31")
ClassMethod HISTmpDataE(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutData^DHCWLInPutCAData(start,end,"FlagDate","E")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-7
/// Description: HIS收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataI("2011-01-01","2011-01-01")
ClassMethod HISTmpDataI(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutData^DHCWLInPutCAData(start,end,"ORDDATE","I")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-7
/// Description: HIS收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataO("2011-03-18","2011-03-18")
ClassMethod HISTmpDataO(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
 	d OutPutData^DHCWLInPutCAData(start,end,"FlagDate","O")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-12-24
/// Description: 挂号收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataO("2010-01-01","2010-01-01")
ClassMethod HISTmpDataGh(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
 	d OutPutDataGhf^DHCWLInPutCAData(start,end,"ORDDATE","O")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-7
/// Description: HIS收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期
/// Output：
/// Return：综合统计中获得
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataO("2010-01-01","2010-01-01")
ClassMethod HISTmpDataH(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
 	d OutPutData^DHCWLInPutCAData(start,end,"FlagDate","H") 
	zn "DHC-APP"
	
	q "OK"
}

/// 从发票表里取得2011-06-11徐瑜婧
/// d ##class(dhc.ca.cache.comm.DataLoad).HISTmpDataH("2011-01-01","2011-01-31")
ClassMethod HISTmpDataH1(SDate, EDate) As %String
{
   
    k ^TMPINVCAT
    k ^TMPDHCALXY("dhc","ca","hisdata")
    s Num=0
    s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	s OutPutDate=$p($zd(EDate,3),"-",1)_$p($zd(EDate,3),"-",2)
	f OrdDate=SDate:1:EDate d
    .s CurINVID=0,OrdDate=$g(OrdDate)
    .s RPUsrId=0
    .;b ;0
	.f  s RPUsrId=$o(^DHCPEINVPRT(0,"RPDATE",OrdDate,RPUsrId))  q:(RPUsrId="")  d
	..f  s CurINVID=$o(^DHCPEINVPRT(0,"RPDATE",OrdDate,RPUsrId,CurINVID)) q:(CurINVID="")  d
	...s err=##Class(web.DHCPE.DHCPEUSERREPORT).GetCatFee(CurINVID)
	...;b ;1
	s ItemRowid="" 
	f  s ItemRowid=$o(^TMPINVCAT($J,"Fee",ItemRowid)) q:ItemRowid=""  d
	.s Catdesc=$p($g(^DHCTarC("TOC",ItemRowid)),"^",2)
    .s Catcode="TJ"_$p($g(^DHCTarC("TOC",ItemRowid)),"^",1)
	.s FaceFee="",AccFee="",Rebet=0
	.s FaceFee=+$G(^TMPINVCAT($J,"Fee",ItemRowid))
	.s AccFee=+$G(^TMPINVCAT($J,"AccFee",ItemRowid))
	.s Rebet=AccFee-FaceFee
	.s FaceFee=$fn(FaceFee,"",2)
	.s Amount=0
	.s CostPrice=0
    .i Catcode="TJ化验费" d
	..s ^TMPDHCALXY("dhc","ca","hisdata",$j,Num)=OutPutDate_"^"_Catcode_"^"_Catdesc_"^"_Amount_"^"_FaceFee_"^"_CostPrice_"^"_"his291"_"^"_"Imm-移民体检"_"^"_"his294"_"^"_"Lab-化验室"_"^"_"his291"_"^"_"Imm-移民体检"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"H"_"^"_""_"^"_""_"^"_""_"^"_""
	.e  d
    ..i Catcode="TJ放射科" d
    ...s ^TMPDHCALXY("dhc","ca","hisdata",$j,Num)=OutPutDate_"^"_Catcode_"^"_Catdesc_"^"_Amount_"^"_FaceFee_"^"_CostPrice_"^"_"his291"_"^"_"Imm-移民体检"_"^"_"his293"_"^"_"X Ray-X光"_"^"_"his291"_"^"_"Imm-移民体检"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"H"_"^"_""_"^"_""_"^"_""_"^"_""
    ..e  d
    ...s ^TMPDHCALXY("dhc","ca","hisdata",$j,Num)=OutPutDate_"^"_Catcode_"^"_Catdesc_"^"_Amount_"^"_FaceFee_"^"_CostPrice_"^"_"his291"_"^"_"Imm-移民体检"_"^"_"his291"_"^"_"Imm-移民体检"_"^"_"his291"_"^"_"Imm-移民体检"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"H"_"^"_""_"^"_""_"^"_""_"^"_""
    .s Num=Num+1
    q Num
}

/// Creator：许立新
/// CreatDate：2009-12-1
/// Description: HIS收入数据准备
/// Table：
/// Input：info-相关信息,job-进程号
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).V("1^12^load^1^1",1123110)
ClassMethod HISDataPre(info, job) As %String
{
	n (info,job)
	s num=""

	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdata",job,num)) q:num=""  d
	.i $d(^TMPDHCALXY("dhc","ca","hisdata",job,num)) d
	..s row=^TMPDHCALXY("dhc","ca","hisdata",job,num)
	..s result=..HISDataInsert(info,row)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2009-11-29
/// Description: HIS收入数据写入
/// Table：dhc_ca_cache_data.IncomeDatas
/// Input：info-导入需要的信息,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HisDataInsert("1^12^input^1","111^666","61618^E^A0101^挂号费221^0^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科")
ClassMethod HISDataInsert(info, data) As %String
{
	n (info,data)
	
	//info="intervalDr^userDr^inType^deptSetDr^itemSetDr"
	//data="61618^E^A0101^挂号费^221^0^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科"
	
	k PLIST
	
	s deptSetDr=$p(info,"^",4)                     //项目套
	s itemSetDr=$p(info,"^",5)                     //科室套
	
	s intervalDr=$p(info,"^",1)
	i intervalDr'="" s PLIST(2)=intervalDr         //核算区间Dr
	
	s feeDate=$p(data,"^",1)
	i feeDate'="" s PLIST(3)=feeDate               //收费日期
	
	s patType=$p(data,"^",2)
	i patType'="" s PLIST(4)=patType               //病人类型
	
	s itemCode=$p(data,"^",3)
	i itemCode'="" s PLIST(5)=itemCode             //项目代码
	
	s itemName=$p(data,"^",4)
	i itemName'="" s PLIST(6)=itemName             //项目名称
	
	s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
	i itemDr'="" s PLIST(7)=itemDr                 //项目Dr
	
	s fee=$p(data,"^",5)
	i fee'="" s PLIST(8)=fee                       //收费金额
	
	s cost=$p(data,"^",6)
	i cost'="" s PLIST(9)=cost                     //成本金额
	
	s fDeptCode=$p(data,"^",7)
	i fDeptCode'="" s PLIST(10)=fDeptCode          //开单科室代码
	
	s fDeptName=$p(data,"^",8)
	i fDeptName'="" s PLIST(11)=fDeptName          //开单科室名称
	
	s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
	i fDeptDr'="" s PLIST(12)=fDeptDr              //开单科室Dr
	
	s tDeptCode=$p(data,"^",9)
	i tDeptCode'="" s PLIST(13)=tDeptCode          //接收科室代码
	
	s tDeptName=$p(data,"^",10)
	i tDeptName'="" s PLIST(14)=tDeptName          //接收科室名称
	
	s tDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,tDeptCode,patType)
	i tDeptDr'="" s PLIST(15)=tDeptDr              //接收科室Dr
	
	s patDeptCode=$p(data,"^",11)
	i patDeptCode'="" s PLIST(16)=patDeptCode      //病人科室代码
	
	s patDeptName=$p(data,"^",12)
	i patDeptName'="" s PLIST(17)=patDeptName      //病人科室名称
	
	s patDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,patDeptCode,patType)
	i patDeptDr'="" s PLIST(18)=patDeptDr          //病人科室Dr
	
	s inType=$p(info,"^",3)
	i inType'="" s PLIST(19)=inType                //采集方式
	
	s inPersonDr=$p(info,"^",2)
	i inPersonDr'="" s PLIST(20)=inPersonDr        //采集人Dr
	
	s remark=""
	i remark'="" s PLIST(21)=remark                //备注
	
	s inDate=$p($h,",",1)
	i inDate'="" s PLIST(22)=inDate                //采集日期
	
	&SQL(INSERT INTO dhc_ca_cache_data.IncomeDatas VALUES PLIST())
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-2-25
/// Description: 基础数据表数据写入
/// Table：dhc_ca_cache_data.BaseData
/// Input：intervalDr-核算周期Dr,sysDataType-系统数据类别,dataTypeDr-数据类别Dr,operType-操作类别,operDr-操作人,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).BaseDataInsert(1,"cost",2,"load",3,"1^12")
ClassMethod BaseDataInsert(intervalDr, sysDataType, dataTypeDr, operType, operDr, data) As %String
{
	n (intervalDr,sysDataType,dataTypeDr,operType,operDr,data)
	
	q:intervalDr="" "intervalErr"         //核算周期为空
	q:sysDataType="" "sysDataTypeErr"     //系统数据类别为空
	q:dataTypeDr="" "dataTypeDrErr"       //导入数据类别为空
	q:operType="" "operTypeErr"           //操作类别为空
	q:operDr="" "operDrErr"               //操作员为空
	q:data="" "dataErr"                   //准备插入的数据为空
	
	//data="业务日期^数据项代码^数据项名称^服务部门代码^服务部门名称^服务人员代码^服务人员名称^承担部门代码^承担部门名称^承担人员代码^承担人员名称^单价^数量^金额^备注^备注1^备注2"
	//"2010-1-10^数据项代码^数据项名称^服务部门代码^服务部门名称^服务人员代码^服务人员名称^承担部门代码^承担部门名称^承担人员代码^承担人员名称^8^80^640^备注^备注1^备注2"
	
	k PLIST
	
	s PLIST(2)=intervalDr                 //核算区间Dr
	s PLIST(3)=sysDataType                //系统数据类别
	s PLIST(4)=dataTypeDr                 //数据类别Dr
	
	s busDate=$p(data,"^",1)              //业务日期
	i busDate'="" d
	.s busDateStr=$zdh(busDate,3)
	.s PLIST(5)=busDateStr
	
	s itemCode=$p(data,"^",2)             //数据项代码
	i itemCode'="" s PLIST(7)=itemCode
	
	s itemName=$p(data,"^",3)             //数据项名称
	i itemName'="" s PLIST(8)=itemName
	
	s servDeptCode=$p(data,"^",4)         //服务部门代码
	i servDeptCode'="" s PLIST(10)=servDeptCode
	
	s servDeptName=$p(data,"^",5)         //服务部门名称
	i servDeptName'="" s PLIST(11)=servDeptName
	
	s serverCode=$p(data,"^",6)           //服务人员代码
	i serverCode'="" s PLIST(13)=serverCode
	
	s serverName=$p(data,"^",7)           //服务人员名称
	i serverName'="" s PLIST(14)=serverName
	
	s servedDeptCode=$p(data,"^",8)       //承担部门代码
	i servedDeptCode'="" s PLIST(16)=servedDeptCode
	
	s servedDeptName=$p(data,"^",9)       //承担部门名称
	i servedDeptName'="" s PLIST(17)=servedDeptName
	
	s receiverCode=$p(data,"^",10)        //承担人员代码
	i receiverCode'="" s PLIST(19)=receiverCode
	
	s receiverName=$p(data,"^",11)        //承担人员名称
	i receiverName'="" s PLIST(20)=receiverName
	
	s price=$p(data,"^",12)               //单价
	i price'="" s PLIST(21)=price
	s amount=$p(data,"^",13)              //数量
	i amount'="" s PLIST(22)=amount
	
	s fee=$p(data,"^",14)                 //金额
	i fee'="" s PLIST(23)=fee
	
	s PLIST(24)=operType                  //操作类别
	
	s operDate=$p($h,",",1)               //操作日期
	s PLIST(25)=operDate
	
	s PLIST(26)=operDr                    //操作人
	
	s operChild=0
	f  s operChild=$o(^DHCCAUNITPERSONS(operDr,"PersonDepts",operChild)) q:operChild=""  d
	.s deptDr=$p(^DHCCAUNITPERSONS(operDr,"PersonDepts",operChild),"^",1)
	.s ownFlag=$p(^DHCCAUNITPERSONS(operDr,"PersonDepts",operChild),"^",4)
	.i ownFlag="Y" s PLIST(27)=deptDr     //操作部门Dr
	
	s remark=$p(data,"^",15)              //备注
	i remark'="" s PLIST(28)=remark
	
	s remark1=$p(data,"^",16)             //备注1
	i remark1'="" s PLIST(29)=remark1
	
	s remark2=$p(data,"^",17)             //备注2
	i remark2'="" s PLIST(30)=remark2
	
	&SQL(INSERT INTO dhc_ca_cache_data.BaseData VALUES PLIST())
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-2-27
/// Description: 凭证数据表数据写入
/// Table：dhc_ca_cache_data.VouchDatas
/// Input：intervalDr-核算周期Dr,inType-采集方式,operDr-采集人Dr,data-需要写入的凭证数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).VouchDataInsert(5,"load",2,"1")
ClassMethod VouchDataInsert(intervalDr, inType, operDr, data) As %String
{
	n (intervalDr, inType, operDr, data)
	
	q:intervalDr="" "intervalErr"         //核算周期为空
	q:inType="" "inTypeErr"               //导入类别为空
	q:operDr="" "operErr"                 //操作员为空
	q:data="" "dataErr"                   //准备插入的数据为空
	
	//all="核算区间^科室Dr^科目Dr^采集方式^采集人Dr^备注^处理标志^月份^凭证号^凭证日期^摘要^部门代码^部门名称^会计科目代码^会计科目名称^借方^贷方^分录标志"
	//s data="备注^1^2010012218^2010-2-26^摘要^部门代码^部门名称^会计科目代码^会计科目名称^1000^800"
	
	k PLIST
	
	s PLIST(2)=intervalDr                 //核算区间Dr
	s PLIST(5)=inType                     //采集方式
	s PLIST(6)=operDr                     //操作人Dr
	
	s remark=$p(data,"^",1)               //备注
	i remark'="" s PLIST(7)=remark
	
	s PLIST(8)="N"                        //处理标志
	
	s month=$p(data,"^",2)                //月份
	i month'="" s PLIST(9)=month
	
	s vouchNum=$p(data,"^",3)             //凭证号
	i vouchNum'="" s PLIST(10)=vouchNum
	
	s vouchDate=$p(data,"^",4)            //凭证日期
	i vouchDate'="" s PLIST(11)=$zdh(vouchDate,3)
	
	s abstract=$p(data,"^",5)             //摘要
	i abstract'="" s PLIST(12)=abstract
	
	s deptCode=$p(data,"^",6)             //部门代码
	i deptCode'="" s PLIST(13)=deptCode
	
	s deptName=$p(data,"^",7)             //部门名称
	i deptName'="" s PLIST(14)=deptName
	
	s subjCode=$p(data,"^",8)             //科目代码
	i subjCode'="" s PLIST(15)=subjCode
	
	s subjName=$p(data,"^",9)             //科目名称
	i subjName'="" s PLIST(16)=subjName
	
	s debit=$p(data,"^",10)               //借方
	i debit'="" s PLIST(17)=debit
	
	s loans=$p(data,"^",11)               //贷方
	i loans'="" s PLIST(18)=loans
	
	s PLIST(19)="N"                       //分录标志
	
	&SQL(INSERT INTO dhc_ca_cache_data.VouchDatas VALUES PLIST())
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-3-11
/// Description: 数据项写入
/// Table：dhc_ca_cache_data.AllDataItems
/// Input：data-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).AllDataItemInsert("931^")
ClassMethod AllDataItemInsert(data) As %String
{
	n (data)
	
	q:data="" "dataErr"                   //准备插入的数据为空
	
	//all="序号^代码^名称^快捷码^备注^有效标志^单位"
	//s data="931^931A^931B^931A-931B^备注^Y^单位"
	
	k PLIST
	
	s num=$p(data,"^",1)                  //序号
	i num'="" s PLIST(2)=num
	
	s code=$p(data,"^",2)                 //代码
	i code'="" s PLIST(3)=code
	
	s name=$p(data,"^",3)                 //名称
	i name'="" s PLIST(4)=name
	
	s shortcut=$p(data,"^",4)             //快捷键
	i shortcut'="" s PLIST(5)=shortcut
	
	s remark=$p(data,"^",5)               //备注
	i remark'="" s PLIST(6)=remark
	
	s active=$p(data,"^",6)               //有效标志
	i active'="" s PLIST(7)=active
	
	s unit=$p(data,"^",7)                 //单位
	i unit'="" s PLIST(8)=unit
	
	&SQL(INSERT INTO dhc_ca_cache_data.AllDataItems VALUES PLIST())
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-4-30
/// Description: HIS系统可采集参数导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ParamFromHIS(1,"demo","load")
ClassMethod ParamFromHIS(intervalDr, userCode, inType) As %String
{
	n (intervalDr,userCode,inType)
	
	q:intervalDr="" "intervalErr"
	q:userCode="" "userCodeErr"
	q:inType="" "inTypeErr"
	
	//zjw 20151027增加  删除科室人数和科室面积等非HIS参数数据以外的当期历史数据，避免HIS接口数据的重复采集
	TSTART
	
	s startDate=""
	s endDate=""
	s userDr=""
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:intervalDr AND ParamDatas_itemDr not in (SELECT LevelItems_itemDr FROM dhc_ca_cache_data.LevelItems WHERE LevelItems_parRef =37 AND LevelItems_childSub>0))   //37  数据分层套  参数数据（非HIS）Dr
	.s startDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)		 //核算区间起始日期63918
	.s endDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)		 //核算区间终止日期63948                                          
	.s startDate=$zd(start,3)                       //核算区间起始日期yyyy-mm-dd
	.s endDate=$zd(end,3)                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	
	//信息准备
	s info=intervalDr_"^"_userDr_"^"_inType
	s job=$j

	s bedsDataItemDr=495                            //495住院床日数
	s insDataItemDr=494                           	//494门诊人次
	s BedNumsDataItemDr=493                      	//493月末实际床位数
	//s TisTimesDataDr=999 								//999煎药医嘱数
	s ipDataItemDr="^497^500^498^499^s214^496^^^"  	//（空）、497出院人数、500出院患者住院天数、498在院人数、499平均住院日、214病床利用率
	                                              	//496入院人数、死亡人数（空）、空、空
	 
	s ybDataItemDr="501^502^^^^s222^s220^s223^s221^s224^s225" 
	//501门诊医保人次、502住院医保人次^^^^222门诊医保患者费用^220门诊医保患者药费^223住院医保患者费用^221出院医保患者药费^224门诊患者费用（结算时间）^225门诊患者药费（结算时间）
   
   
   
    d ..BedsTmpData(startDate,endDate)                //住院病床日数据生成
    s doIns=..BedsDataPre(info,bedsDataItemDr,job)    //保存住院病床日数据
    
	d ..InsTmpData(startDate,endDate)                   //门诊人次数据生成
	s doIns=..InsDataPre(info,insDataItemDr,job)      //保存门诊人次数据

	d ..IpTmpData(startDate,endDate)                    //、出院人数、出院人数住院天数、在院人数、平均住院日、病床利用率、入院人数、死亡人数、出院患者费用、出院患者药品费用  
	s doIns=..IpDataPre(info,ipDataItemDr,job)        //保存 、出院人数、出院人数住院天数、在院人数数据
    
	d ..MzybTmpData(startDate,endDate)                  //门诊医保人次数据生成 （后台要改）
	s doIns=..MzybDataPre(info,ybDataItemDr,job)      //保存门诊医保人次数据
	
	
	d ..ZyybTmpData(startDate,endDate)                  //住院医保人次数据生成 （后台要改）
	s doIns=..ZyybDataPre(info,ybDataItemDr,job)      //保存住院医保人次数据
	
	d ..BedNumsTmpData(startDate,endDate)                   //月末时实有床位数 数据生成  （后台要改）
	s doIns=..BedNumsDataPre(info,BedNumsDataItemDr,job)      //保存床位数 数据
	
	//d ..TisTimesTmpData(start,end)                   //河北省中医院  煎药医嘱数 数据生成  （后台要改）
	//s doIns=..TisTimesDataPre(info,TisTimesDataDr,job)      //煎药医嘱数 数据
	
	i doIns ="OK" d
  	.TCOMMIT
  	e  d
 	.TROLLBACK

	q "OK"
}

/// Creator：zjw
/// CreatDate：2014-06-10
/// Description: 成本核算系统采集科室总收入导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,itemDr-参数DR
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ParamFromIncomeDatas(1,"demo","487")
ClassMethod ParamFromIncomeDatas(intervalDr, userCode, itemDr) As %String
{
	n (intervalDr,userCode,itemDr)
	;s ^tempDHCCAzjw=intervalDr_"^"_userCode_"^"_itemDr
	q:intervalDr="" "请先选择核算月份！"
	q:itemDr'=399 "请先选出 科室总收入 ！"   //参数科室总收入的DR
	;w itemDr,!
	s today=$p($h,",",1)
	s inType="load"
	s userDr=""
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	q:(userDr="")||(userDr=0) "对不起，您没有成本核算权限！"
	//导入前先删除历史数据,防止重复导入
	&SQL(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:intervalDr AND ParamDatas_itemDr=:itemDr )
	//执行科室
	;&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas(ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servedDeptCode, ParamDatas_servedDeptName, ParamDatas_value,ParamDatas_inType, ParamDatas_inPersonDr, ParamDatas_inDate) SELECT IncomeDatas_intervalDr,:itemDr,IncomeDatas_tDeptCode, IncomeDatas_tDeptName,sum(IncomeDatas_fee),:inType,:userDr,:today FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr GROUP BY IncomeDatas_tDeptCode,IncomeDatas_tDeptName)
	//开单科室
	&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas(ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servedDeptDr, ParamDatas_value,ParamDatas_inType, ParamDatas_inPersonDr, ParamDatas_inDate) SELECT IncomeDatas_intervalDr,:itemDr,IncomeDatas_fDeptDr,sum(Convert(decimal(12,2), IncomeDatas_fee)),:inType,:userDr,:today FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr GROUP BY IncomeDatas_fDeptDr)
	
	;q SQLCODE
	q "OK"
}

/// d ##class(dhc.ca.cache.comm.DataLoad).ParamFromHISlxc(67,"demo","load")
/// 在院人数生成
ClassMethod ParamFromHISlxc(intervalDr, userCode, inType) As %String
{
	n (intervalDr,userCode,inType)
	
	q:intervalDr="" "intervalErr"
	q:userCode="" "userCodeErr"
	q:inType="" "inTypeErr"
	
	//信息准备
	s startDate=""
	s endDate=""
	s userDr=""
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s startDate=$zd(start,3)                       //核算区间起始日期
	.s endDate=$zd(end,3)                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s info=intervalDr_"^"_userDr_"^"_inType
	
	s job=$j
	
	//导入数据项目itemDr准备
	
	s OutZyrs=524                               //在院人数
	
    d ..OutPutZyrs(startDate,endDate)                //在院人数数据生成
    s doIns=..InsDataPre3(info,OutZyrs,job)

    q "OK"
}

/// d ##class(dhc.ca.cache.comm.DataLoad).ParamFromHISlxcycj(66,"demo","load")
/// 人数费用等生成，2011-01-29卢晓春单独导入时用
ClassMethod ParamFromHISlxcycj(intervalDr, userCode, inType) As %String
{
	n (intervalDr,userCode,inType)
	
	q:intervalDr="" "intervalErr"
	q:userCode="" "userCodeErr"
	q:inType="" "inTypeErr"
	
	//信息准备
	s startDate=""
	s endDate=""
	s userDr=""
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s startDate=$zd(start,3)                       //核算区间起始日期
	.s endDate=$zd(end,3)                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s info=intervalDr_"^"_userDr_"^"_inType
	
	s job=$j
	
	s ybDataItemDr="528^529^520^530^535^538^536^539^537^540^541" 
	//528门诊、529住院医保人次、520出院人次、530出院患者费用、535出院患者药品费用
	//538门诊医保患者费用、536门诊医保患者药品费用
	//539住院医保患者费用、537住院医保患者药品费用
	//540门诊患者费用(打发票时间)、541门诊患者药费(打发票时间)
	//导入数据项目itemDr准备
	
	d ..ZyTmpData(startDate,endDate)                  //出院数据生成
	s doIns=..ZyDataPre(info,ybDataItemDr,job)      //保存出院人次数据
    s doIns=..ZyDataPre1(info,ybDataItemDr,job)      //保存出院患者费用数据
    s doIns=..ZyDataPre2(info,ybDataItemDr,job)      //保存出院患者药品费用数据
    
    
	d ..MzybTmpData(startDate,endDate)                  //门诊医保人次数据生成
	s doIns=..MzybDataPre(info,ybDataItemDr,job)      //保存门诊医保人次数据
	s doIns=..MzybDataPre1(info,ybDataItemDr,job)      //保存门诊医保患者费用数据
	s doIns=..MzybDataPre2(info,ybDataItemDr,job)      //保存门诊医保患者药品费用数据
	
	
	d ..ZyybTmpData(startDate,endDate)                  //住院医保人次数据生成
	s doIns=..ZyybDataPre(info,ybDataItemDr,job)      //保存住院医保人次数据
    s doIns=..ZyybDataPre1(info,ybDataItemDr,job)      //保存住院医保患者费用数据
    s doIns=..ZyybDataPre2(info,ybDataItemDr,job)      //保存住院医保患者药品费用数据
    
    
    d ..MzTmpData(startDate,endDate)                  //门诊数据生成，按打发票时间
	;s doIns=..MzDataPre(info,ybDataItemDr,job)      //保存门诊人次数据
	s doIns=..MzDataPre1(info,ybDataItemDr,job)      //保存门诊患者费用数据
	s doIns=..MzDataPre2(info,ybDataItemDr,job)      //保存门诊患者药品费用数据
	
	;s OutZyrs=524                               //在院人数
	
    ;d ..OutPutZyrs(startDate,endDate)                //在院人数数据生成
    ;s doIns=..InsDataPre3(info,OutZyrs,job)

    q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 住院病床日临时Global生成 Loc  Ward
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).BedsTmpData("2010-01-01","2010-01-01")
ClassMethod BedsTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutIP^DHCWLInPutCAData(start,end)
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 住院病床日数据准备
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("6^12^load",880,1409378)
ClassMethod BedsDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdatabed",$j,Num)=OutPutDate_"^"_ipdr_"^"_locdesc_"^"_zyrs
	
	s info=info_"^"_itemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdatabed",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdatabed",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s tmploc=ipdr_"!"_locdesc
	..s zyrs=$p(tmp,"^",4)
	..i (ipdr'="") && (zyrs'="") && (zyrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=zyrs
	...e  s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=tmp1+zyrs
	
	k ^TMPDHCALXY("dhc","ca","hisdatabed",job)
	
	s tmploc=""
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)) q:tmploc=""  d
	.s zyrs=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	.i zyrs'="" d
	..s row=tmploc_"!"_zyrs
	..s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatabed",job)
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2014-5-19
/// Description: 住院病床日数据准备
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("6^12^load",880,1409378)
ClassMethod BedsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	//^TMPDHCALXY("dhc","ca","hisdatabed",$j,locdr)

	s info=info_"^"_itemDr
	
	s locdr=""
	f  s locdr=$o(^TMPDHCALXY("dhc","ca","hisdatabed",job,locdr)) q:locdr=""  d
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s zyrs=$g(^TMPDHCALXY("dhc","ca","hisdatabed",job,locdr))
	.i (zyrs'="")&& (zyrs'=0) d
	..s row="his"_locdr_"!"_locdesc_"!"_zyrs
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCALXY("dhc","ca","hisdatabed",job)
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2014-5-27
/// Description: 床位数临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsTmpData("2013-10-01","2013-10-31")
ClassMethod BedNumsTmpData(start, end) As %String
{
	n (start,end)
	zn "DHC-DATA"
	d OutPutCWS^DHCWLInPutCAData(end)  //按科室Loc取
	;d OutPutCWSW^DHCWLInPutCAData(end) //按病区Ward取
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2014-5-19
/// Description: 床位数 数据准备
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("6^12^load",880,1409378)
ClassMethod BedNumsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	//^TMPDHCALXY("dhc","ca","hisdatabed",$j,locdr)

	s info=info_"^"_itemDr
	
	s locdr=""
	f  s locdr=$o(^TMPDHCALXY("dhc","ca","hisdataCWS",job,locdr)) q:locdr=""  d
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s BedNums=$p($g(^TMPDHCALXY("dhc","ca","hisdataCWS",job,locdr)),"^",4)
	.i (BedNums'="")&& (BedNums'=0) d
	..s row="his"_locdr_"!"_locdesc_"!"_BedNums
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCALXY("dhc","ca","hisdataCWS",job)
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2016-6-8
/// Description: 煎药医嘱数临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期,日期类型(FlagDate:结算时间--收付实现制 ORDDATE：医嘱时间-权责发生制)
/// Output：
/// Return：  
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).TisTimesTmpData("2016-05-01","2016-05-31")
ClassMethod TisTimesTmpData(start, end) As %String
{
	n (start,end)
	zn "DHC-DATA"
	d OutPutJYYZS^DHCWLInPutCAData(start, end,"FlagDate")  
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2016-6-8
/// Description: 煎药医嘱数 数据准备
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).TisTimesDataPre("6^12^load",999,1409378)
ClassMethod TisTimesDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	//^TMPDHCALXY("dhc","ca","hisdataJYYZS",$j,locdr)

	s info=info_"^"_itemDr
	
	s locdr=""
	f  s locdr=$o(^TMPDHCALXY("dhc","ca","hisdataJYYZS",job,locdr)) q:locdr=""  d
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s YZSNums=$p($g(^TMPDHCALXY("dhc","ca","hisdataJYYZS",job,locdr)),"^",4)
	.i (YZSNums'="")&& (YZSNums'=0) d
	..s row="his"_locdr_"!"_locdesc_"!"_YZSNums
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCALXY("dhc","ca","hisdataJYYZS",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 门诊人次临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsTmpData("2013-10-01","2013-10-31")
ClassMethod InsTmpData(start, end) As %String
{
	n (start,end)
	zn "DHC-DATA"
	;w start_"^"_end,!
	d OutPutOP^DHCWLInPutCAData(start,end)
	
	zn "DHC-APP"
	
	q "OK"
}

/*
/// Creator：zbp  zjw
/// CreatDate：2014-1-8
/// Description: 门诊人次临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsTmpData("2013-10-01","2013-10-31")
ClassMethod InsTmpData(start, end) As %String
{
 n (start,end)
 k ^TEMPDHCHS($j,"Loc")
 k ^TMPDHCALXY("dhc","ca","hisdatain",$j)
 ;set sday=$zd(start,3),eday=$zd(end,3)
 set rs=##class(%ResultSet).%New()
 set rs.ClassName="web.RunQianQueryDHCWL"
 set rs.QueryName="GetPaadmRc"
 set Num=0
 set sc=rs.Execute(start,end,"")
 ;w sc,!
 If $$$ISERR(sc) do $System.Status.DisplayError(sc) quit

 while rs.%Next()
  { 
	 s dep=rs.Data("dep")
     ;s doc=rs.Data("doc")
	 s count=rs.Data("outrc")
     s ^TEMPDHCHS($j,"Loc",dep,"Counts")=count+$g(^TEMPDHCHS($j,"Loc",dep,"Counts"))
   }
      s deptdr=0 f  s deptdr=$o(^TEMPDHCHS($j,"Loc",deptdr)) q:deptdr=""  d 
      .s deptsc=$p(^CTLOC(deptdr),"^",2)
      .s ^TMPDHCALXY("dhc","ca","hisdatain",$j,Num)=start_"^"_"his"_deptdr_"^"_deptsc_"^"_$g(^TEMPDHCHS($j,"Loc",deptdr,"Counts"))_"^^"
      .s Num=Num+1

  k ^TEMPDHCHS($j,"Loc") 
 q "OK"
}
*/
/// Creator：卢晓春
/// CreatDate：2010-10-30
/// Description: 门诊医师工作量临时Global生成
ClassMethod InsTmpData1(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutOP^DHCWLInPutCAData(start,end)
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-10-30
/// Description: 住院医师工作量临时Global生成
/// d ##class(dhc.ca.cache.comm.DataLoad).InsTmpData2("2011-01-01","2011-01-31")
ClassMethod InsTmpData2(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutZyDocGzl^DHCWLInPutCAData(start,end,"ORDDATE","I")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 门诊人次数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsDataPre("21^3994^load",879,1224760)
ClassMethod InsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdatain",$j,Num)=日期^病人科室代码^病人科室名称^数量
	
	s info=info_"^"_itemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdatain",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdatain",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s tmpDept=deptCode_"!"_deptName
	..s rc=$p(tmp,"^",4)
	..i (deptCode'="") && (rc'="") && (rc'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=rc
	...e  s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=tmp1+rc
	
	k ^TMPDHCALXY("dhc","ca","hisdatain",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatain",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-10-29
/// Description: 门诊医师工作量数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsDataPre1("63^3994^load",531,553822)
ClassMethod InsDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdatain",$j,Num)=日期^病人科室代码^病人科室名称^数量
	
	s info=info_"^"_itemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdatain",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdatain",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s FdocCode=$p(tmp,"^",5)
	..s FdocName=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName_"!"_FdocCode_"!"_FdocName
	..s rc=$p(tmp,"^",4)
	
	..i (deptCode'="") && (rc'="") && (rc'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=rc
	...e  s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=tmp1+rc
	
	k ^TMPDHCALXY("dhc","ca","hisdatain",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataIn1(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatain",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-10-30
/// Description: 住院医师工作量数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsDataPre2("63^3994^load",531,553822)
ClassMethod InsDataPre2(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdatazydocgzl",$j,Num)=日期^病人科室代码^病人科室名称^数量^开单医师代码^开单医师名称
	
	s info=info_"^"_itemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdatazydocgzl",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdatazydocgzl",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s FdocCode=$p(tmp,"^",5)
	..s FdocName=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName_"!"_FdocCode_"!"_FdocName
	..s rc=$p(tmp,"^",4)
	
	..i (deptCode'="") && (rc'="") && (rc'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatazydocgzl",job,tmpDept))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatazydocgzl",job,tmpDept)=rc
	...e  s ^TMPDHCCA("dhc","ca","hisdatazydocgzl",job,tmpDept)=tmp1+rc
	
	k ^TMPDHCALXY("dhc","ca","hisdatazydocgzl",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdatazydocgzl",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","hisdatazydocgzl",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataIn1(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatazydocgzl",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2011-01-25
/// Description: 在院人数
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).InsDataPre3("63^3994^load",531,553822)
ClassMethod InsDataPre3(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdatazyrs",$j,Num)=日期^病人科室代码^病人科室名称^数量^开单医师代码^开单医师名称
	
	s info=info_"^"_itemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdatazyrs",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdatazyrs",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)

	..s tmpDept=deptCode_"!"_deptName  //_"!"_FdocCode_"!"_FdocName
	..s rc=$p(tmp,"^",4)
	
	..i (deptCode'="") && (rc'="") && (rc'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatazyrs",job,tmpDept))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatazyrs",job,tmpDept)=rc
	...e  s ^TMPDHCCA("dhc","ca","hisdatazyrs",job,tmpDept)=tmp1+rc
	
	k ^TMPDHCALXY("dhc","ca","hisdatazyrs",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdatazyrs",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","hisdatazyrs",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataIn2(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatazyrs",job)
	
	q "OK"
}

/// Creator：许立新OutPutIPWorkload住院天数、在院人数数据生成、平均住院日、病床利用率临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期 Loc Ward
/// Output： 
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).IpTmpData("2010-01-01","2010-01-01")
ClassMethod IpTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutIPWorkload^DHCWLInPutCAData(start,end,"Loc")
	zn "DHC-APP"
	
	q "OK"
}

/// 在院人数 2011-01-25 卢晓春
ClassMethod OutPutZyrs(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutZyrs^DHCWLInPutCAData(start,end,"ORDDATE","I")
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-4
/// Description: 床位数、出院人数、出院人数住院天数、在院人数数据生成、平均住院日、病床利用率数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).IpDataPre("6^3148^load","880^879^123^456^789^222",1409378)
ClassMethod IpDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisdataIP",$j,Num)=日期^病人科室代码^病人科室名称^床位数^出院人数^出院人数住院天数^在院人数^入院人数^死亡人数^出院患者费用
	//^TMPDHCALXY("dhc","ca","hisdataIP",1409378,0)=2010-01-01^1^xxgnk-心血管内科^148^7^42^94
	//zjw 暂用出院人数 item2-tmp-5  和入院人数 item7-tmp-8
	;s item1=$p(itemDr,"^",1) //床位数				zjw	累计实有床位数
	s item2=$p(itemDr,"^",2) //出院人数
	s item3=$p(itemDr,"^",3) //出院人数住院天数		
    s item4=$p(itemDr,"^",4) //在院人数				zjw	在院人数=住院床日
	s item5=$p(itemDr,"^",5) //平均住院日			zjw	出院病人平均住院日=出院人数住院天数/出院人数
	;s item6=$p(itemDr,"^",6) //病床利用率			zjw	=在院人数/累计实有床位数
	s item7=$p(itemDr,"^",7) //入院人数
	;s item8=$p(itemDr,"^",8) //死亡人数
	;s item9=$p(itemDr,"^",9) //出院患者费用
	;s item10=$p(itemDr,"^",10) //出院患者药品费用
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdataIP",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisdataIP",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..;s beds=$p(tmp,"^",4)				//床位数
	..s outIPs=$p(tmp,"^",5)			//出院人数****
	..;s outIPDays=$p(tmp,"^",6)			//出院人数住院天数
	..;s inBeds=$p(tmp,"^",7)			//在院人数
	..s ryrs=$p(tmp,"^",8)				//入院人数****
	..;s swrs=$p(tmp,"^",9)				//死亡人数
	..;s cyhzfy=$p(tmp,"^",10)			//出院患者费用
	..;s cyhzypfy=$p(tmp,"^",11)		//出院患者药品费用
	..s tmpDept=deptCode_"!"_deptName
	..;i (item1'="") && (deptCode'="") && (beds'="") && (beds'=0) d
	..;.s tmp1=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item1,tmpDept))
	..;.s ^TMPDHCCA("dhc","ca","hisdataIP",job,item1,tmpDept)=$g(tmp1)+beds
	..i (item2'="") && (deptCode'="") && (outIPs'="") && (outIPs'=0) d
	...s tmp2=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item2,tmpDept))
	...i tmp2'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item2,tmpDept)=tmp2+outIPs
	...e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item2,tmpDept)=outIPs
	..;i (item3'="") && (deptCode'="") && (outIPDays'="") && (outIPDays'=0) d
	..;.s tmp3=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item3,tmpDept))
	..;.i tmp3'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item3,tmpDept)=tmp3+outIPDays
	..;.e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item3,tmpDept)=outIPDays
	..;i (item4'="") && (deptCode'="") && (inBeds'="") && (inBeds'=0) d  //2011-01-25 卢晓春屏蔽
	..;i (deptCode'="") d
	..;.s tmp4=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item4,tmpDept))
	..;.i tmp4'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item4,tmpDept)=tmp4+inBeds
	..;.e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item4,tmpDept)=inBeds
    
    ..i (item7'="") && (deptCode'="") && (ryrs'="") && (ryrs'=0) d
	...s tmp7=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item7,tmpDept))
	...i tmp7'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item7,tmpDept)=tmp7+ryrs
	...e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item7,tmpDept)=ryrs
	
	;..i (item8'="") && (deptCode'="") && (swrs'="") && (swrs'=0) d
	;...s tmp8=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item8,tmpDept))
	;...i tmp8'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item8,tmpDept)=tmp8+swrs
	;...e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item8,tmpDept)=swrs
	
	;..i (item9'="") && (deptCode'="") && (cyhzfy'="") && (cyhzfy'=0) d
	;...s tmp9=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item9,tmpDept))
	;...i tmp9'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item9,tmpDept)=tmp9+cyhzfy
	;...e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item9,tmpDept)=cyhzfy
	
	;..i (item10'="") && (deptCode'="") && (cyhzypfy'="") && (cyhzypfy'=0) d
	;...s tmp10=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item10,tmpDept))
	;...i tmp10'="" s ^TMPDHCCA("dhc","ca","hisdataIP",job,item10,tmpDept)=tmp10+cyhzypfy
	;...e  s ^TMPDHCCA("dhc","ca","hisdataIP",job,item10,tmpDept)=cyhzypfy
	
	;i item5'="" d
	;.s tmpDept=""
	;.f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdataIP",job,item3,tmpDept)) q:tmpDept=""  d
	;..s outIPbeds=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item3,tmpDept))
	;..s outIPs=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item2,tmpDept))
	;..i (outIPbeds'="") && (outIPs'="") && (outIPs'=0) d
	;...s r=outIPbeds/outIPs     //平均住院日=出院人数住院天数/出院人数
	;...i (r'="") && (r'=0) d
	;....s ^TMPDHCCA("dhc","ca","hisdataIP",job,item5,tmpDept)=r
	
	;i item6'="" d
	;.s tmpDept=""
	;.f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdataIP",job,item4,tmpDept)) q:tmpDept=""  d
	;..s inBeds=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item4,tmpDept))
	;..s beds=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,item1,tmpDept))
	;..i (inBeds'="") && (beds'="") && (beds'=0) d
	;...s r=""   //r=inBeds/beds          //病床利用率=在院人数/床位数
	;...i (r'="") && (r'=0) d
	;....s ^TMPDHCCA("dhc","ca","hisdataIP",job,item6,tmpDept)=r
	
	
	k ^TMPDHCALXY("dhc","ca","hisdataIP",job)

	s tmpItem=""
	f  s tmpItem=$o(^TMPDHCCA("dhc","ca","hisdataIP",job,tmpItem)) q:tmpItem=""  d
	.s tmpInfo=info_"^"_tmpItem
	.s tmpDept=""
	.f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdataIP",job,tmpItem,tmpDept)) q:tmpDept=""  d
	..s value=$g(^TMPDHCCA("dhc","ca","hisdataIP",job,tmpItem,tmpDept))
	..i (value'="") && (value'=0) d
	...s row=tmpDept_"!"_value
	...s result=..DoDataIn(tmpInfo,row)
	
	k ^TMPDHCCA("dhc","ca","hisdataIP",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-5
/// Description: 门诊医保人次临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).MzybTmpData("2010-12-01","2010-12-31")
ClassMethod MzybTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	d OutPutInsurance^DHCWLInPutCAData(start,end,"O","PAADM_AdmDate","2!3!5!6!14!53")  //门诊PAADM_AdmDate zjw 含医保标志DR 表PAC_admreason中字段REA_NationalCode有值时是医保，其他为自费
	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-5
/// Description: 门诊医保人次数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).MzybDataPre("6^3148^load","1164^1165",1409378)
ClassMethod MzybDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s mzItemDr=$p(itemDr,"^",1) //门诊医保人次Dr
	
	s info=info_"^"_mzItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",4)
	..s tmpDept=deptCode_"!"_deptName
	..i (mzItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisInsurance",job)2011-01-28卢晓春屏蔽，在MzybDataPre2中统一处理
	k ^TMPDHCALXY("dhc","ca","hisInsurance",job)
	

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job) 
	
	q "OK"
}

//医保病号总费用卢晓春2011-01-28

ClassMethod MzybDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s mzItemDr=$p(itemDr,"^",6) //门诊医保病号总费用
	
	s info=info_"^"_mzItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",5)
	..s tmpDept=deptCode_"!"_deptName
	..i (mzItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisInsurance",job)2011-01-28卢晓春屏蔽，在MzybDataPre2中统一处理

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job) 
	
	q "OK"
}

/// 医保病号药品总费用卢晓春2011-01-28
ClassMethod MzybDataPre2(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s mzItemDr=$p(itemDr,"^",7) //门诊医保病号药品总费用
	
	s info=info_"^"_mzItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName
	..i (mzItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	k ^TMPDHCALXY("dhc","ca","hisInsurance",job)

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-5
/// Description: 住院医保人次临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ZyybTmpData("2010-12-01","2010-12-31")
ClassMethod ZyybTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	
  	d OutPutInsurance^DHCWLInPutCAData(start,end,"I","DischDate","2!3!5!6!14!53")      //住院 DischDate  zjw 含医保标志DR 表PAC_admreason中字段REA_NationalCode有值时是医保，其他为自费
	zn "DHC-APP"
	
	q "OK"
}

/// 2011-01-28卢晓春出院患者人次、费用生成
ClassMethod ZyTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	
  	d OutPutCyrs^DHCWLInPutCAData(start,end,"I","DischDate")      //住院
	zn "DHC-APP"
	
	q "OK"
}

/// 2011-02-12卢晓春门诊费用信息生成
ClassMethod MzTmpData(start, end) As %String
{
	n (start,end)
	
	zn "DHC-DATA"
	
  	d OutPutMZXX^DHCWLInPutCAData(start,end,"PAADM_AdmDate")      //门诊
  	
  	zn "DHC-APP"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-6
/// Description: 住院医保人次数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ZyybDataPre("6^3148^load","1164^1165",1409378)
ClassMethod ZyybDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s zyItemDr=$p(itemDr,"^",2) //住院医保人次Dr
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",4)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisInsurance",job)2011-01-28卢晓春屏蔽，在ZyybDataPre2中统一处理
	k ^TMPDHCALXY("dhc","ca","hisInsurance",job)

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job)
	
	q "OK"
}

ClassMethod ZyybDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s zyItemDr=$p(itemDr,"^",8) //住院医保患者费用
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",5)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisInsurance",job)2011-01-28卢晓春屏蔽，在ZyybDataPre2中统一处理

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job)
	
	q "OK"
}

ClassMethod ZyybDataPre2(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMPDHCALXY("dhc","ca","hisInsurance",$j,Num)=日期^病人科室代码^病人科室名称^数量
	//^TMPDHCALXY("dhc","ca","hisInsurance",1409378,0)=2010-01-01^2^xxgnk-门诊心血管内科^15
	
	s zyItemDr=$p(itemDr,"^",9) //住院医保药品费用
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisInsurance",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisInsurance",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)=tmp+value
	
	k ^TMPDHCALXY("dhc","ca","hisInsurance",job)

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisInsurance",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisInsurance",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2011-1-28
/// Description: 住院人次数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ZyDataPre("6^3148^load","1164^1165",1409378)
ClassMethod ZyDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	

	s zyItemDr=$p(itemDr,"^",3) //出院人次Dr
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisCyrs",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisCyrs",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",4)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisCyrs",job)2011-01-28卢晓春屏蔽,在ZyDataPre2中统一处理

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisCyrs",job)
	
	q "OK"
}

ClassMethod ZyDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
		
	s zyItemDr=$p(itemDr,"^",4) //出院患者费用
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisCyrs",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisCyrs",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",5)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisCyrs",job)2011-01-28卢晓春屏蔽，在ZyDataPre2中统一处理

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisCyrs",job)
	
	q "OK"
}

ClassMethod ZyDataPre2(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	
	s zyItemDr=$p(itemDr,"^",5) //出院患者药品费用
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisCyrs",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisCyrs",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)=tmp+value
	
	k ^TMPDHCALXY("dhc","ca","hisCyrs",job)

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisCyrs",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisCyrs",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2011-2-12
/// Description: 门诊费用数据准备，按照打发票时间
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// 
ClassMethod MzDataPre1(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
		
	s zyItemDr=$p(itemDr,"^",10) //门诊患者费用，按照打发票时间
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisMZXX",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisMZXX",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",5)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)=tmp+value
	
	;k ^TMPDHCALXY("dhc","ca","hisMZXX",job)2011-01-28卢晓春屏蔽，在ZyDataPre2中统一处理

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisMZXX",job)
	
	q "OK"
}

ClassMethod MzDataPre2(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	
	s zyItemDr=$p(itemDr,"^",11) //门诊患者药品费用，按照打发票时间
	
	s info=info_"^"_zyItemDr
	
	s num=""
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisMZXX",job,num)) q:num=""  d
	.s tmp=$g(^TMPDHCALXY("dhc","ca","hisMZXX",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s value=$p(tmp,"^",6)
	..s tmpDept=deptCode_"!"_deptName
	..i (zyItemDr'="") && (deptCode'="") && (value'="") && (value'=0) d
	...s tmp=$g(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept))
	...i tmp="" s ^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)=value
	...e  s ^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)=tmp+value
	
	k ^TMPDHCALXY("dhc","ca","hisMZXX",job)

	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept)) q:tmpDept=""  d
	.s value=$g(^TMPDHCCA("dhc","ca","hisMZXX",job,tmpDept))
	.i (value'="") && (value'=0) d
	..s row=tmpDept_"!"_value
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisMZXX",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-5-7
/// Description: 文件参数数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).DoDataIn(info,row)
ClassMethod ParamDataInsert(info, row) As %String
{
	n (info,row)
	
	//info=interval+"^"+itemDr+"^"+type+"^"+user;
	s interval=$p(info,"^",1)
	s itemDr=$p(info,"^",2)
	s type=$p(info,"^",3)
	s user=$p(info,"^",4)
	
	//row=科室编码^科室名称^金额
	s deptCode=$p(row,"^",1)
	s deptName=$p(row,"^",2)
	s fee=$p(row,"^",3)
	
	s today=$p($h,",",1)
	
	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^"_deptCode_"^"_deptName_"^^"_fee_"^"_type_"^"_user_"^^"_today
	
	s result=..ParamDatasInsert(data)
	
	q result
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 参数数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).DoDataIn(info,row)
ClassMethod DoDataIn(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服务部门Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!病床日数"
	
	s intervalDr=$p(info,"^",1)
	s userDr=$p(info,"^",2)
	s inType=$p(info,"^",3)
	s itemDr=$p(info,"^",4)
	
	s servedDeptCode=$p(row,"!",1)
	s servedDeptName=$p(row,"!",2)
	s value=$p(row,"!",3)
	
	s today=+$h
	;s today=$p($h,",",1)
	;s today=$zdt($h,3)
	;s today=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2))

	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^"_servedDeptCode_"^"_servedDeptName_"^^"_value_"^"_inType_"^"_userDr_"^^"_today
	
	s result=..ParamDatasInsert(data)
	
	q result
}

/// Creator：卢晓春
/// CreatDate：2010-10-30
/// Description: 门诊医师工作量|住院医师工作量参数数据写入
ClassMethod DoDataIn1(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服务部门Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!病床日数"
	
	s intervalDr=$p(info,"^",1)
	s userDr=$p(info,"^",2)
	s inType=$p(info,"^",3)
	s itemDr=$p(info,"^",4)
	
	s servedDeptCode=$p(row,"!",1)
	s servedDeptName=$p(row,"!",2)
	s value=$p(row,"!",5)
	
	s today=$p($h,",",1)
	
	s FdocCode=$p(row,"!",3)
	s FdocName=$p(row,"!",4)
		
	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^"_servedDeptCode_"^"_servedDeptName_"^^"_value_"^"_inType_"^"_userDr_"^^"_today_"^"_FdocCode_"^"_FdocName
	
	s result=..ParamDatasInsert(data)
	
	q result
}

/// Creator：卢晓春
/// CreatDate：2011-01-25
/// Description: 在院人数参数数据写入
ClassMethod DoDataIn2(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	

	s intervalDr=$p(info,"^",1)
	s userDr=$p(info,"^",2)
	s inType=$p(info,"^",3)
	s itemDr=$p(info,"^",4)
	
	s servedDeptCode=$p(row,"!",1)
	s servedDeptName=$p(row,"!",2)
	s value=$p(row,"!",3)
	
	s today=$p($h,",",1)
	

	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^"_servedDeptCode_"^"_servedDeptName_"^^"_value_"^"_inType_"^"_userDr_"^^"_today
	
	s result=..ParamDatasInsert(data)
	
	q result
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 参数数据写入
/// Table：dhc_ca_cache_data.ParamDatas
/// Input：data-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ParamDatasInsert(3)
ClassMethod ParamDatasInsert(data) As %String
{
	n (data)
	
	q:data="" "dataErr"                   //准备插入的数据为空
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服务部门Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//s data="3^4^项目名称^5^6^服务部门名称^7^8^被服务部门名称^9^10^导入/录入^11^备注^61815"
	
	k PLIST
	
	s intervalDr=$p(data,"^",1)                  //核算区间Dr
	i intervalDr'="" s PLIST(2)=intervalDr
	
	s itemCode=$p(data,"^",2)                    //项目代码
	i itemCode'="" s PLIST(3)=itemCode
	
	s itemName=$p(data,"^",3)                    //项目名称
	i itemName'="" s PLIST(4)=itemName
	
	s itemDr=$p(data,"^",4)                      //项目Dr
	i itemDr'="" s PLIST(5)=itemDr
	
	s servDeptCode=$p(data,"^",5)                //服务部门代码
	i servDeptCode'="" s PLIST(6)=servDeptCode
	
	s servDeptName=$p(data,"^",6)                //服务部门名称
	i servDeptName'="" s PLIST(7)=servDeptName
	
	s servDeptDr=$p(data,"^",7)                  //服务部门Dr
	i servDeptDr'="" s PLIST(8)=servDeptDr
	
	s servedDeptCode=$p(data,"^",8)              //被服务部门代码
	i servedDeptCode'="" s PLIST(9)=servedDeptCode
	
	s servedDeptName=$p(data,"^",9)              //被服务部门名称
	i servedDeptName'="" s PLIST(10)=servedDeptName
	
	s servedDeptDr=$p(data,"^",10)               //被服务部门Dr
	i servedDeptDr'="" s PLIST(11)=servedDeptDr
	
	s value=$p(data,"^",11)                      //参数数值
	i value'="" s PLIST(12)=value
	
	s inType=$p(data,"^",12)                     //导入/录入
	i inType'="" s PLIST(13)=inType
	
	s inPersonDr=$p(data,"^",13)                 //采集人
	i inPersonDr'="" s PLIST(14)=inPersonDr
	
	s remark=$p(data,"^",14)                     //备注
	i remark'="" s PLIST(15)=remark
	
	s inDate=$p(data,"^",15)                     //采集日期
	i inDate'="" s PLIST(16)=inDate
	
	s FdocCode=$p(data,"^",16)                     //开单医师代码
	i FdocCode'="" s PLIST(17)=FdocCode
	
	s FdocName=$p(data,"^",17)                     //开单医师名称
	i FdocName'="" s PLIST(18)=FdocName
	
	&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas VALUES PLIST())
	
	q SQLCODE
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 航创HIS可采集参数导入入口
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).ParamFromHIS(13,"demo","load")
ClassMethod ParamFromHISHC(intervalDr, userCode, inType) As %String
{
	n (intervalDr,userCode,inType)
	
	q:intervalDr="" "intervalErr"
	q:userCode="" "userCodeErr"
	q:inType="" "inTypeErr"
	
	
	//zjw 20151027增加  删除科室人数和科室面积以外的当期历史数据，避免HIS接口数据的重复采集
	TSTART
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:intervalDr AND ParamDatas_itemDr not in (SELECT LevelItems_itemDr FROM dhc_ca_cache_data.LevelItems WHERE LevelItems_parRef =37 AND LevelItems_childSub>0))   //37  数据分层套  参数数据（非HIS）Dr
	.s startDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)		 //核算区间起始日期
	.s endDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)		 //核算区间终止日期                                          
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	//信息准备
	;s startDate=""
	;s endDate=""     
	;s userDr="" 
	;i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	;.s startDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)	 //核算区间起始日期
	;.s endDate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)	 //核算区间终止日期                           
	;s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s info=intervalDr_"^"_userDr_"^"_inType
	s job=$j
	
	//导入数据项目itemDr准备

	s ipDataItemDr="142^141^146^143^400^144^147"  //住院床日、门诊人次、门诊医保人次、出院人数、出院医保人数、入院人数、入院医保人数
	 
     d ..ZycrTmpData(startDate,endDate)                		//住院病床日生成
     s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",1),job)      //保存住院病床日数据
	
 	 d ..MzrcTmpData(startDate,endDate)                		//门诊人次生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",2),job)       //保存门诊人次数据
	
	 d ..MzYbrcTmpData(startDate,endDate)              		//门诊医保人次生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",3),job)       //保存门诊医保人次数据

 	 d ..CyrsTmpData(startDate,endDate)                		//出院人数生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",4),job)       //保存出院人数数据

 	 d ..CyYbrsTmpData(startDate,endDate)                		//出院医保人数生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",5),job)       //保存门诊医保人次数据

 	 d ..RyrsTmpData(startDate,endDate)                		//入院人数生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",6),job)       //保存入院人数数据

 	 d ..RyYbrsTmpData(startDate,endDate)                		//入院医保人数生成
 	 s doIns=..HCInsDataPre(info,$P(ipDataItemDr,"^",7),job)       //保存入院医保人数
 	 
 	 i doIns ="OK" d
  	.TCOMMIT
  	e  d
 	.TROLLBACK
	
    q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 住院病床日数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).ZycrTmpData(start,end)
ClassMethod ZycrTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMZYCR(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMZYCR(HISParamID),"^",4)_"HCZY"
	..s DeptName=$p(^HISPARAMZYCR(HISParamID),"^",5)
	..i DeptName="" s DeptName="其他住院" 
	..s value=$p(^HISPARAMZYCR(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMZYCR(HISParamID),"^",9)
	..q:datastate'="1"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 门诊人次数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).MzrcTmpData(start,end)
ClassMethod MzrcTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMMZRC(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMMZRC(HISParamID),"^",4)_"MZ"
	..s DeptName=$p(^HISPARAMMZRC(HISParamID),"^",5)
	..i DeptName="" s DeptName="其他门诊"  
	..s value=$p(^HISPARAMMZRC(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMMZRC(HISParamID),"^",9)
	..q:datastate'="1"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 门诊医保人次数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).MzYbrcTmpData(start,end)
ClassMethod MzYbrcTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMMZRC(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMMZRC(HISParamID),"^",4)_"MZ"
	..s DeptName=$p(^HISPARAMMZRC(HISParamID),"^",5)
	..i DeptName="" s DeptName="其他门诊" 
	..s value=$p(^HISPARAMMZRC(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMMZRC(HISParamID),"^",9)
	..q:datastate'="1"
	..s HealthCare=$p(^HISPARAMMZRC(HISParamID),"^",10)
	..q:HealthCare'="Y"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 出院人数数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).CyrsTmpData(start,end)
ClassMethod CyrsTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMCYRS(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMCYRS(HISParamID),"^",4)_"HCZY"
	..s DeptName=$p(^HISPARAMCYRS(HISParamID),"^",5) 
	..i DeptName="" s DeptName="其他住院"
	..s value=$p(^HISPARAMCYRS(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMCYRS(HISParamID),"^",9)
	..q:datastate'="1"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 出院医保人数数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).CyYbrsTmpData(start,end)
ClassMethod CyYbrsTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMCYRS(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMCYRS(HISParamID),"^",4)_"HCZY"
	..s DeptName=$p(^HISPARAMCYRS(HISParamID),"^",5)
	..i DeptName="" s DeptName="其他住院" 
	..s value=$p(^HISPARAMCYRS(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMCYRS(HISParamID),"^",9)
	..q:datastate'="1"
	..s HealthCare=$p(^HISPARAMCYRS(HISParamID),"^",10)
	..q:HealthCare'="Y"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 入院人数数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).RyrsTmpData(start,end)
ClassMethod RyrsTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMRYRS(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMRYRS(HISParamID),"^",4)_"HCZY"
	..s DeptName=$p(^HISPARAMRYRS(HISParamID),"^",5)
	..i DeptName="" s DeptName="其他住院" 
	..s value=$p(^HISPARAMRYRS(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMRYRS(HISParamID),"^",9)
	..q:datastate'="1"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 入院医保人数数据准备
/// Table：
/// Input：开始日期  结束日期 $zdh("2015-03-01",3) 63612  63642
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).RyYbrsTmpData(start,end)
ClassMethod RyYbrsTmpData(start, end) As %String
{
	n (start,end)

	k ^TMPDHCCA("dhc","ca","hisparamHC")
	k ^TMPDHCALXY("dhc","ca","hisparamHC")

	s HISParamID="",i=""
	f i=start:1:end d
	.f  s HISParamID=$o(^HISPARAMRYRS(0,"YearMonth",i,HISParamID)) q:HISParamID=""  d
	..s DeptCode=$p(^HISPARAMRYRS(HISParamID),"^",4)_"HCZY"
	..s DeptName=$p(^HISPARAMRYRS(HISParamID),"^",5) 
	..i DeptName="" s DeptName="其他住院"
	..s value=$p(^HISPARAMRYRS(HISParamID),"^",8)
	..s datastate=$p(^HISPARAMRYRS(HISParamID),"^",9)
	..q:datastate'="1"
	..s HealthCare=$p(^HISPARAMRYRS(HISParamID),"^",10)
	..q:HealthCare'="Y"
	..s ^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName)=$g(^TMPDHCCA("dhc","ca","hisparamHC",$j,DeptCode,DeptName))+value
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 保存航创参数数据
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).ZycrTmpData(info,start,end)
ClassMethod HCInsDataPre(info, ItemDr, job) As %String
{
	n (info,ItemDr,job)
	s HCDeptCode=""
	s info=info_"^"_ItemDr
	f  s HCDeptCode=$o(^TMPDHCCA("dhc","ca","hisparamHC",job,HCDeptCode)) q:HCDeptCode=""  d
	.s HCDeptName="" f  s HCDeptName=$o(^TMPDHCCA("dhc","ca","hisparamHC",job,HCDeptCode,HCDeptName)) q:HCDeptName=""  d
	..s dataValue=$g(^TMPDHCCA("dhc","ca","hisparamHC",job,HCDeptCode,HCDeptName))
	..q:dataValue=0
	..s row=HCDeptCode_"!"_HCDeptName_"!"_dataValue
	..//s info=info_"^"_ItemDr
	..s result=..HCDoDataIn(info,row)

	k ^TMPDHCCA("dhc","ca","hisparamHC",job)
	k ^TMPDHCALXY("dhc","ca","hisparamHC",job)
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 参数数据整理
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HCDoDataIn(info,row)
ClassMethod HCDoDataIn(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服务部门Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!数值"
	
	s intervalDr=$p(info,"^",1)
	s userDr=$p(info,"^",2)
	s inType=$p(info,"^",3)
	s itemDr=$p(info,"^",4)
	s rowid=""
	s servedDeptCode=$p(row,"!",1)
	s servedDeptName=$p(row,"!",2)
	s value=$p(row,"!",3)
	
	s today=$p($h,",",1)
    
	s servedDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(1,servedDeptCode,"")
	//组装数据
	s data=intervalDr_"^"_itemDr_"^"_servedDeptCode_"^"_servedDeptName_"^"_servedDeptDr_"^"_value_"^"_inType_"^"_userDr_"^"_today     
	
	s result=..HCParamDatasInsert(data)
	
	q result
}

/// Creator：zjw
/// CreatDate：2015-04-22
/// Description: 参数数据写入
/// Table：dhc_ca_cache_data.ParamDatas
/// Input：data-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HCParamDatasInsert(3)
ClassMethod HCParamDatasInsert(data) As %String
{
	n (data)
	
	q:data="" "dataErr"                   //准备插入的数据为空
	
	//data=核算区间Dr^项目Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^采集日期
	
	k PLIST
	
	s intervalDr=$p(data,"^",1)                  //核算区间Dr
	i intervalDr'="" s PLIST(2)=intervalDr
	
	s itemDr=$p(data,"^",2)                      //项目Dr
	i itemDr'="" s PLIST(5)=itemDr
	
	s servedDeptCode=$p(data,"^",3)              //被服务部门代码
	i servedDeptCode'="" s PLIST(9)=servedDeptCode
	
	s servedDeptName=$p(data,"^",4)              //被服务部门名称
	i servedDeptName'="" s PLIST(10)=servedDeptName
	
	s servedDeptDr=$p(data,"^",5)               //被服务部门Dr
	i servedDeptDr'="" s PLIST(11)=servedDeptDr
	
	s value=$p(data,"^",6)                      //参数数值
	i value'="" s PLIST(12)=value
	
	s inType=$p(data,"^",7)                     //导入/录入
	i inType'="" s PLIST(13)=inType
	
	s inPersonDr=$p(data,"^",8)                 //采集人
	i inPersonDr'="" s PLIST(14)=inPersonDr
	
	s inDate=$p(data,"^",9)                     //采集日期
	i inDate'="" s PLIST(16)=inDate

	&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas VALUES PLIST())
	
	q SQLCODE
}

/// Creator：zjw
/// CreatDate：2015-01-15
/// Description: 航创HIS门诊收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetO(13,"demo","load",1)
ClassMethod HISDataSetHCO(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	TSTART
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='O')
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	s OperatDate=+$h
	s SqlStr="SELECT  MakeBillDeptCode, MakeBillDeptName, ExecuteDeptCode, ExecuteDeptName, SickDeptCode, SickDeptName, SickType, ExpensesType, ItemName ,sum(IncomeMoney) as sumincome FROM  herp_inter_data.HisChargeDataO WHERE ChargeDate BETWEEN '"_start_"' AND '"_end_" 23:59:59' GROUP BY  MakeBillDeptCode, MakeBillDeptName, ExecuteDeptCode, ExecuteDeptName, SickDeptCode, SickDeptName, SickType, ExpensesType, ItemName "
	
	s ResultString=0
	s Result= ##class(%Library.ResultSet).%New()
	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		
		//w $zt($p($h,",",2),1),!
		s fDeptCode=Result.Data("MakeBillDeptCode")_"HCMZ"
		s fDeptName=Result.Data("MakeBillDeptName")
		i fDeptName="" s fDeptName="其他门诊"
		
		s tDeptCode=Result.Data("ExecuteDeptCode")_"HCMZ"
		s tDeptName=Result.Data("ExecuteDeptName")
		i tDeptName="" s tDeptName="其他门诊"
		
		s patDeptCode=Result.Data("SickDeptCode")_"HCMZ"
		s patDeptName=Result.Data("SickDeptName")
		i patDeptName="" s patDeptName="其他门诊"
		
		s ItemName=Result.Data("ItemName")
		s sumincome=Result.Data("sumincome")
		
		s tmpFlag=0
	    s tmpFlag=..InsertHCRec(intervalDr,"O",ItemName,sumincome,fDeptCode,fDeptName,tDeptCode,tDeptName,patDeptCode,patDeptName,userDr,OperatDate)
	    i tmpFlag'=0 s ResultString=tmpFlag
	    q:ResultString'=0
		
	}
	d Result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2015-01-15
/// Description: 航创HIS住院收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoad).HISDataSetI(1,"demo","load",1)
ClassMethod HISDataSetHCI(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	TSTART
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_patType='I')
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	s OperatDate=+$h
	s SqlStr="SELECT  MakeBillDeptCode, MakeBillDeptName, ExecuteDeptCode, ExecuteDeptName, SickDeptCode, SickDeptName, SickType, ExpensesType, ItemName ,sum(IncomeMoney) as sumincome FROM  herp_inter_data.HisChargeDataI WHERE ChargeDate BETWEEN '"_start_"' AND '"_end_" 23:59:59' GROUP BY  MakeBillDeptCode, MakeBillDeptName, ExecuteDeptCode, ExecuteDeptName, SickDeptCode, SickDeptName, SickType, ExpensesType, ItemName "
	
	s ResultString=0
	s Result= ##class(%Library.ResultSet).%New()
	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		
		//w $zt($p($h,",",2),1),!
		s fDeptCode=Result.Data("MakeBillDeptCode")_"HCZY"
		s fDeptName=Result.Data("MakeBillDeptName")
		i fDeptName="" s fDeptName="其他住院"
		
		s tDeptCode=Result.Data("ExecuteDeptCode")_"HCZY"
		s tDeptName=Result.Data("ExecuteDeptName")
		i tDeptName="" s tDeptName="其他住院"
		
		s patDeptCode=Result.Data("SickDeptCode")_"HCZY"
		s patDeptName=Result.Data("SickDeptName")
		i patDeptName="" s patDeptName="其他住院"
		
		s ItemName=Result.Data("ItemName")
		s sumincome=Result.Data("sumincome")
		
		s tmpFlag=0
	    s tmpFlag=..InsertHCRec(intervalDr,"I",ItemName,sumincome,fDeptCode,fDeptName,tDeptCode,tDeptName,patDeptCode,patDeptName,userDr,OperatDate)
	    i tmpFlag'=0 s ResultString=tmpFlag
		q:ResultString'=0
	}
	d Result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q "OK"
}

/// Creator: zjw
/// CreatDate: 2015-01-15
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.comm.DataLoad).InsertHCRec(1,"1","2","load","1","test",10,0)
ClassMethod InsertHCRec(intervalDr, PatType, ItemName, sumincome, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName, userDr, OperatDate) As %Text
{
	n (intervalDr,PatType,ItemName,sumincome,fDeptCode,fDeptName,tDeptCode,tDeptName,patDeptCode,patDeptName,userDr,OperatDate)
	q:sumincome=0 0  //zjw 20151030  收入为0则退出返回0值
	&SQL(INSERT INTO dhc_ca_cache_data.IncomeDatas (IncomeDatas_intervalDr,IncomeDatas_patType,IncomeDatas_itemCode, IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_fDeptCode, 
		IncomeDatas_fDeptName,IncomeDatas_tDeptCode, IncomeDatas_tDeptName,IncomeDatas_patDeptCode, IncomeDatas_patDeptName,IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_inDate)
	VALUES (:intervalDr, :PatType, :ItemName, :ItemName, :sumincome, :fDeptCode, :fDeptName, :tDeptCode, :tDeptName, :patDeptCode, :patDeptName,"load", :userDr, :OperatDate))
	
	q SQLCODE
}

/// Creator: zjw
/// CreatDate: 2016-05-10
/// Description: 根据ct_loc科室获取对应的成本核算科室代码和名称
/// Table: dhc.ca.cache.data.InDepts、dhc.ca.cache.data.OutDepts
/// Input: CtlocDR-ct_loc科室ID
/// Output: 核算科室代码^核算科室名称
/// Others: w ##class(dhc.ca.cache.comm.DataLoad).CheckCtlocDept(116)
ClassMethod CheckCtlocDept(CtlocDR) As %String
{
	;n (CtlocDR)

	q:CtlocDR="" "DR is NULL."
	;s CtlocCode=$p($g(^CTLOC(CtlocDR)),"^",1)
	;q:CtlocCode="" ""
	s InDeptschildSub="",output="",num=1
	/*
	//获取最大的内部部门套设置DR
	&sql(SELECT max(InDepts_parRef) into:maxInDeptsparRef FROM dhc_ca_cache_data.inDepts )

	s InDeptsparRef=""
	f InDeptsparRef=3:1:maxInDeptsparRef d
	.f  s InDeptschildSub=$o(^DHCCAINDEPTSETS(0,"Outcode",InDeptsparRef,CtlocDR,InDeptschildSub)) q:InDeptschildSub=""  d
	..q:InDeptschildSub=0
	..s CBHSDeptDr=$p($g(^DHCCAINDEPTSETS(InDeptsparRef,"InDepts",InDeptschildSub)),"^",2)
	..s CBHSDeptCode=$p($g( ^DHCCAUNITDEPTS(CBHSDeptDr)),"^",1)
	..s CBHSDeptName=$p($g( ^DHCCAUNITDEPTS(CBHSDeptDr)),"^",2)
	..;s output=output_"^"_num_"^"_CBHSDeptDr_"^"_CBHSDeptName
	..;s num=num+1
	..s output=CBHSDeptCode_"^"_CBHSDeptName
	*/

	s InDeptsparRef=4
	f  s InDeptschildSub=$o(^DHCCAINDEPTSETS(0,"Outcode",InDeptsparRef,CtlocDR,InDeptschildSub)) q:InDeptschildSub=""  d
	.q:InDeptschildSub=0
	.s CBHSDeptDr=$p($g(^DHCCAINDEPTSETS(InDeptsparRef,"InDepts",InDeptschildSub)),"^",2)
	.s CBHSDeptCode=$p($g( ^DHCCAUNITDEPTS(CBHSDeptDr)),"^",1)
	.s CBHSDeptName=$p($g( ^DHCCAUNITDEPTS(CBHSDeptDr)),"^",2)
	.s output=CBHSDeptCode_"^"_CBHSDeptName
	q:output'="" output
	q:output="" "This CTDept isn't mapped in CBHS. "
}

/// Creator：zjw
/// CreatDate：2016-07-18
/// Description: 粤北财务收入冲销分解导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).ImportCXDataRec(26,"demo")
ClassMethod ImportCXDataRec(intervalDr, userCode) As %String
{
	n (intervalDr,userCode)
	TSTART
	
	s remark="冲销额拆解",SumBeforeWrite=0
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s OperatDate=+$h
	
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_remark=:remark)			//删除历史冲销拆解额
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	
	k ^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS")
	s Itemfee=0,ResultString=0
	s ItemDr="" f  s ItemDr=$o(^DHCCABUDGETDATA(0,"IndexIntItem",intervalDr,ItemDr)) q:ItemDr=""  d
	.&sql(SELECT sum(BudgetData_fee) into:Itemfee FROM dhc_ca_cache_data.BudgetData WHERE BudgetData_intervalDr=:intervalDr AND BudgetData_itemDr=:ItemDr)			//获取该项目的总冲销额
	.&sql(SELECT sum(IncomeDatas_fee) into:ItemSumfee FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_itemDr=:ItemDr)	//获取HIS该项目的当月收入总额
	.//组装当月该项目的各科室收入
	.s IncomedatasDr="" f  s IncomedatasDr=$o(^DHCCAINCOMEDATAS(0,"IntervalItemdr",intervalDr,ItemDr,IncomedatasDr)) q:IncomedatasDr=""  d
	..s fee=$p(^DHCCAINCOMEDATAS(IncomedatasDr),"^",7)
	..s patType=$p(^DHCCAINCOMEDATAS(IncomedatasDr),"^",3)
	..s fdeptDr=$p(^DHCCAINCOMEDATAS(IncomedatasDr),"^",11)
	..s tdeptDr=$p(^DHCCAINCOMEDATAS(IncomedatasDr),"^",14)
	..s patdeptDr=$p(^DHCCAINCOMEDATAS(IncomedatasDr),"^",17)
	..s Depts=patType_"*"_fdeptDr_"*"_tdeptDr_"*"_patdeptDr
	..;w Depts_"^"_fee,!
	..s ^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS",ItemDr,Depts)=$g(^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS",ItemDr,Depts))+fee
	.s PatTypeDepts="" f  s PatTypeDepts=$o(^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS",ItemDr,PatTypeDepts))	q:PatTypeDepts=""  d  //  收入类型、开单、执行与病人科室的组合
	..s DeptsFee=$g(^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS",ItemDr,PatTypeDepts))	//该项目对应的收入类型、开单、执行与病人科室的组合金额
	..s Fee=DeptsFee/ItemSumfee*Itemfee*(-1)													//该项目对应的收入类型、开单、执行与病人科室的组合拆解冲销金额
	..s PatType=$p(PatTypeDepts,"*",1)
	..s FDeptDr=$p(PatTypeDepts,"*",2)
	..s TDeptDr=$p(PatTypeDepts,"*",3)
	..s PatDeptDr=$p(PatTypeDepts,"*",4)
	..s tmpFlag=0
	..s tmpFlag=..InsertWriteOffRec(intervalDr,PatType,ItemDr,$num(Fee,4),FDeptDr,TDeptDr,PatDeptDr,remark,userDr,OperatDate)
	..i tmpFlag'=0 s ResultString=tmpFlag
	k ^tempIncomeItem(0,$j,"IncomedatasDr","ItemDr","CBHS")
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	q:ResultString'=0 ResultString
	
	q "OK"
}

/// Creator: zjw
/// CreatDate: 2016-07-18
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: 
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.comm.DataLoad).InsertWriteOffRec(1,"1","2","load","1","test",10,0)
ClassMethod InsertWriteOffRec(intervalDr, PatType, ItemDr, Fee, FDeptDr, TDeptDr, PatDeptDr, remark, userDr, OperatDate) As %Text
{
	n (intervalDr,PatType,ItemDr,Fee,FDeptDr,TDeptDr,PatDeptDr,remark,userDr,OperatDate)
	q:Fee=0 0  //zjw 20151030  收入为0则退出返回0值
	&SQL(INSERT INTO dhc_ca_cache_data.IncomeDatas (IncomeDatas_intervalDr,IncomeDatas_patType,IncomeDatas_itemDr, IncomeDatas_fee,IncomeDatas_fDeptDr,IncomeDatas_tDeptDr,IncomeDatas_patDeptDr,IncomeDatas_remark,IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_inDate)
	VALUES (:intervalDr, :PatType, :ItemDr, :Fee, :FDeptDr, :TDeptDr, :PatDeptDr, :remark,"load", :userDr, :OperatDate))
	
	q SQLCODE
}

/// Creator: zjw
/// CreatDate: 2016-07-20
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.comm.DataLoad).ImportCXExamRec(26,"demo")
ClassMethod ImportCXExamRec(intervalDr, userCode) As %String
{
	n (intervalDr,userCode)
	//判断权限
	s userDr=""
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	q:(userDr<=0)||(userDr="") "对不起，您不是成本核算系统用户，无权操作！"
	//判断是否维护冲销额
	s ItemDrs="" s ItemDrs=$o(^DHCCABUDGETDATA(0,"IndexIntItem",intervalDr,ItemDrs))
	q:ItemDrs="" "请先维护项目冲销额再试！"
	
	//判断该月是否维护有收入数据
	s Nums=0
	&SQL(SELECT count(*) into:Nums FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr)
	q:Nums<=0 "该月的收入数据尚未维护，请维护后再试！"
	
	//判断是否已完成数据对照
	s NullNum=0
	&SQL(SELECT count(*) into:NullNum FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr
		AND( IncomeDatas_itemDr IS NULL OR IncomeDatas_fDeptDr IS NULL  OR IncomeDatas_tDeptDr IS NULL OR IncomeDatas_patDeptDr IS NULL ))
	q:NullNum>0 "请先到收入维护页面完成该月的数据对照再试！"
	
	
	//判断待冲销的收入项是否在当月收入项中存在
	s ItemDrNums="",flag=0
	s ItemDr="" f  s ItemDr=$o(^DHCCABUDGETDATA(0,"IndexIntItem",intervalDr,ItemDr)) q:(ItemDr="")||(ItemDrNums=0)  d
	.&sql(SELECT count(*) into:ItemDrNums FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:intervalDr and IncomeDatas_itemDr=:ItemDr )
	.i ItemDrNums=0 s flag=ItemDr
	
	i flag >0 d
	.s intervalDrName=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",2)
	.s ItemName=$p(^DHCCAALLDATAITEMS(flag),"^",3)
	q:flag>0 "收入维护中"_intervalDrName_"该月无"_ItemName_"的收入数据，请核对修改后再试！"
	q flag
}

ClassMethod test() As %String
{
	q "test"
}

Storage Default
{
<StreamLocation>^dhc.ca.c.DataLoadS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
