/// 名称: 数据导入
/// 描述: 各种数据导入的类方法
/// 编写者：杨旭
/// 编写日期:2010-06-01
Class dhc.ca.cache.comm.DataLoadHS Extends (%SerialObject, %Populate, %XML.Adaptor) [ ClassType = serial, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2010-06-01
/// Description: HIS收入数据导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式,loadRulesDr-导入规则Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).HISDataSet(2,"demo","load",1)
ClassMethod HISDataSet(intervalDr, userCode, inType, loadRulesDr) As %String
{
	n (intervalDr,userCode,inType,loadRulesDr)
	
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数开始运行时间
	k ^TMP("dhc","ca","hisdata")
	k ^TMP("dhc","ca","hisdatazrcl")
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	.s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	.s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	.s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	.s info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr
	.s job=$j
	.//调用HIS收入查询函数
	.d ..HISTmpData(start,end)
	.;d ..HISTmpDataGzhc(start,end)     
	.//调用HIS数据插入函数
	.s doIns=..HISDataPre(info,job)
	.;s doIns=..HISDataPreZrcl(info,job)
	.d ..GetOutECData(intervalDr, userCode, inType)
	//w $zd($p($h,",",1),3)_" "_$zt($p($h,",",2))  //函数结束运行时间
	
	q doIns
}

/// Creator：杨旭
/// CreatDate：2010-06-01
/// Description: HIS收入临时Global生成
/// Table：
/// Input：start-收费起始日期,end-收费终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).HISTmpData("2010-01-01","2010-01-31")
ClassMethod HISTmpData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	
	d OutPutData^DHCWLInPutCAData(start,end,"ORDDATE")
	zn "dhc-app"
	q "OK"
}

ClassMethod HISTmpDataGzhc(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	d OutGzhcData^DHCWLInPutCAData(start,end,"ORDDATE") 
	zn "dhc-app"
	q "OK"
}

/// Creator：杨旭
/// CreatDate：2010-06-01
/// Description: HIS收入数据准备
/// Table：
/// Input：info-相关信息 info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr   ,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre("1^1^load^1^1",270444)
ClassMethod HISDataPre(info, job) As %String
{
	n (info,job)
	TSTART
	s tmpJob=$p($h,",",1)_$p($h,",",2)
	s flag=0
	s result=0
	s num=""
	//^TMP("dhc","ca","hisdata",$j,Num)  ^tempDHCALXY  ^TMPDHCALXY("dhc","ca","hisdata",$j,Num)
	f  s num=$o(^TMPDHCALXY("dhc","ca","hisdata",job,num)) q:num=""  d
	.i $d(^TMPDHCALXY("dhc","ca","hisdata",job,num)) d
	..s flag=0
	..s row=^TMPDHCALXY("dhc","ca","hisdata",job,num)
	..;w row,!
	..q:result'=0
	..s flag=..HISDataInsert(info,row,tmpJob)
	..i flag'=0   s result=flag
	i result=0 TCOMMIT
	e   TROLLBACK
	q result
}

/// Creator：卢晓春
/// CreatDate：2010-08-21
/// Description: 植入材料HIS收入数据准备
/// Table：
/// Input：info-相关信息,job-进程号
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).HISDataPre("1^1^load^1^1",4512)
ClassMethod HISDataPreZrcl(info, job) As %String
{
	n (info,job)
	TSTART
	s tmpJob=$p($h,",",1)_$p($h,",",2)
	s flag=0
	s result=0
	s num=""
	//^TMP("dhc","ca","hisdatazrcl",$j,Num)
	f  s num=$o(^TMP("dhc","ca","hisdatazrcl",job,num)) q:num=""  d
	.i $d(^TMP("dhc","ca","hisdatazrcl",job,num)) d
	..s row=^TMP("dhc","ca","hisdatazrcl",job,num)
	..s flag=..VouchDataInsert(info,row,tmpJob)
	..s result=flag
	..w info,!
	..w row,!
	i result=0 TCOMMIT
	e  TROLLBACK
	q result
}

/// Creator：杨旭
/// CreatDate：2010-06-01
/// Description: HIS收入数据写入
/// Table：dhc_ca_cache_data.IncomeDatas
/// Input：info-导入需要的信息,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：w ##class(dhc.ca.cache.comm.DataLoadHS).HISDataInsert("6^12^input^1","201003^121^CT费^1^170^0^1192^SJWK-神经外科^1170^FSK-放射科^1192^SJWK-神经外科^1179^A-A区^^^I^SWYZ^神外一组")
ClassMethod HISDataInsert(info, data, tmpJob) As %String
{
	n (info,data,tmpJob)
	
	//s info="1^1^load^1^" info=intervalDr_"^"_userDr_"^"_inType_"^"_deptSetDr_"^"_itemSetDr
	//s data="201003^O^西药^西药费^170.1^1192^SJWK-神经外科^1125^zyyf-住院药房^1119^SSS-手术中心手术室"
	//OutPutDate_"^"_admtype_"^"_Catcode_"^"_Catdesc_"^"_Price_"^"_PatLoc_"^"_PatDesc_"^"_RecLoc_"^"_RecDesc_"^"_ResLoc_"^"_ResDesc
	//s tmpJob=$p($h,",",1)_$p($h,",",2)
	k PLIST
	;s deptSetDr=$p(info,"^",4)                     //科室套
	;s itemSetDr=$p(info,"^",5)                     //项目套
	;s itemType=$p(info,"^",6) 
	
	s intervalDr=$p(info,"^",1)
	i intervalDr'="" s PLIST(2)=intervalDr         //核算区间Dr
	
	;s feeDate=$p(data,"^",1)
	;i feeDate'="" s PLIST(3)=feeDate               //收费日期
	
	s patType=$p(data,"^",2)						//病人类型
	i patType'="" s PLIST(4)=patType
	
	s itemCode=$p(data,"^",3)
	i itemCode'="" s PLIST(5)=itemCode               //核算子类代码
	
	s itemName=$p(data,"^",4)
	i itemName'="" s PLIST(6)=itemName             //核算子类名称
		
	s fee=$p(data,"^",5)
	i fee'="" s PLIST(8)=fee                       //收费金额
	
	;s cost=$p(data,"^",6)
	;i cost'="" s PLIST(9)=cost                     //成本金额

	s fDeptCode=$p(data,"^",6)
	i fDeptCode'="" s PLIST(10)=fDeptCode          //开单科室代码
	
	s fDeptName=$p(data,"^",7)
	i fDeptName'="" s PLIST(11)=fDeptName          //开单科室名称
	
	
	s tDeptCode=$p(data,"^",8)
	i tDeptCode'="" s PLIST(13)=tDeptCode          //接收科室代码
	
	s tDeptName=$p(data,"^",9)
	i tDeptName'="" s PLIST(14)=tDeptName          //接收科室名称
	
	
	s patDeptCode=$p(data,"^",10)
	i patDeptCode'="" s PLIST(16)=patDeptCode      //病人科室代码
	
	s patDeptName=$p(data,"^",11)
	i patDeptName'="" s PLIST(17)=patDeptName      //病人科室名称
	
	s inType=$p(info,"^",3)
	i inType'="" s PLIST(19)=inType                //采集方式
	
	s inPersonDr=$p(info,"^",2)
	i inPersonDr'="" s PLIST(20)=inPersonDr        //采集人Dr
	
	s remark=$p(info,"^",6)
	i remark'="" s PLIST(21)=inPersonDr        //采集人Dr
	;s PLIST(21)=tmpJob
	
	s inDate=$p($h,",",1)
	i inDate'="" s PLIST(22)=inDate                //采集日期
	
		
	&SQL(INSERT INTO dhc_ca_cache_data.IncomeDatas VALUES PLIST())
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2010-06-01
/// Description: 凭证数据导入
/// Table：dhc_ca_cache_data.IncomeDatas
/// Input：info-导入需要的信息,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).VouchDataInsert("1^12^input^1","111^666","61618^E^A0101^挂号费221^0^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科^急诊内科^jznk-急诊内科")
ClassMethod VouchDataInsert(info, data, tmpJob) As %String
{
	n (info, data, tmpJob)
	
	//s info="1^1^load^1^"
	//s data="201003^149^西药^21^170.1^110.25^1192^SJWK-神经外科^1125^zyyf-住院药房^1119^SSS-手术中心手术室^1179^A-A区^^^I^SWYZ^神外一组"
	
	//s tmpJob=$p($h,",",1)_$p($h,",",2)
   //OutPutDate_"^"_Catcode_"^"_Catdesc_"^"_Amount_"^"_Price_"^"_CostPrice_"^"_ResLoc_"^"_ResDesc_"^"_RecLoc_"^"_RecDesc_"^"_ResLoc_"^"_ResDesc_"^"_PatWard_"^"_PatWardDesc_"^"_""_"^"_""_"^"_admtype_"^"_docdr_"^"_docDesc   //lxc100801修改	
	k PLIST
	
	s deptSetDr=$p(info,"^",4)                     //科室套
	s itemSetDr=$p(info,"^",5)                     //项目套
	s itemType=$p(info,"^",6) 
	
	s intervalDr=$p(info,"^",1)
	i intervalDr'="" s PLIST(2)=intervalDr         //核算区间Dr
	
	s feeDate=$p(data,"^",1)
	i feeDate'="" s PLIST(9)=feeDate               //收费日期
	
	s patType=$p(data,"^",17)						//病人类型
	
	s itemCode=$p(data,"^",2)
	i itemCode'="" s PLIST(15)=itemCode               //核算子类代码
	
	s itemName=$p(data,"^",3)
	
	i itemName'="" s PLIST(16)=itemName             //核算子类名称
	
	i itemSetDr'="" d
	.s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
	.i itemDr'="" s PLIST(4)=itemDr                 //项目Dr
	
	i itemType'="" d
	.s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemByTypeRelation(itemType,itemCode)
	.i itemDr'="" s PLIST(4)=itemDr 
	       
	
	s cost=$p(data,"^",6)
	i cost'="" s PLIST(17)=cost                     //成本金额
	
	s fDeptCode=$p(data,"^",7)
	i fDeptCode'="" s PLIST(13)=fDeptCode          //开单科室代码
	
	s fDeptName=$p(data,"^",8)
	i fDeptName'="" s PLIST(14)=fDeptName          //开单科室名称
	
	s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
	i fDeptDr'="" s PLIST(3)=fDeptDr              //开单科室Dr
	
	s intype=$p(info,"^",3)
	s PLIST(5)=intype
	s PLIST(19)="N"                                //分路标志
	
	s inPersonDr=$p(info,"^",2)
	i inPersonDr'="" s PLIST(6)=inPersonDr        //采集人Dr
	
	//s remark=""
	//i remark'="" s PLIST(8)=remark                //备注
	s PLIST(7)= tmpJob
	s PLIST(8)="N" //处理标志
	
	s inDate=$p($h,",",1)
	i inDate'="" s PLIST(11)=inDate                //采集日期
	
	&SQL(INSERT INTO dhc_ca_cache_data.VouchDatas VALUES PLIST())
	
	q SQLCODE
}

/// Creator：许立新
/// CreatDate：2010-6-11
/// Description: HIS系统可采集参数导入入口
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).ParamFromHIS(1,"demo","load")
ClassMethod ParamFromHIS(intervalDr, userCode, inType) As %String
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
	s rqftDataItemDr=269    //燃气分摊
	s bedsDataItemDr=127    //床日数
	s ryrsDataItemDr=267    //入院人数  
	s cyrsDataItemDr=128    //出院人数                        
	s insDataItemDr=126     //门诊人次
	s incomDataItemDr=131      //门诊科室收入
	s cailDataItemDr=164    //材料组领用
	s zxgyDataItemDr=165    //中心供应室领用
	s ADataItemDr=152      //A区服务 
	s BDataItemDr=153      //B区服务
	s CDataItemDr=154      //C区服务
	s DDataItemDr=155      //D区服务
	s EDataItemDr=156      //E区服务
	s FDataItemDr=157      //F区服务
	s HDataItemDr=158      //H区服务
	s icuADataItemDr=159      //ICU(A)区服务
	s icuBDataItemDr=160      //ICU(B)区服务
	s JDataItemDr=161      //J区服务
	s KDataItemDr=162      //K区服务
	s GDataItemDr=163      //G区服务

   ;d ..BedsTmpData(startDate,endDate,"loc")          
    d ..BedsTmpData(startDate,endDate)                 //住院病床日数据生成(医生组)
    s doIns=..BedsDataPre(info,bedsDataItemDr,job)    //保存住院病床日数据(医生组)
    
    ;d ..cyrsTmpData(startDate,endDate)             //出院人数生成(医生组) 注意:上一项已经生成 
    s doIns=..cyrsDataPre(info,cyrsDataItemDr,job)    //保存出院人数(医生组)
    
    ;d ..ryrsTmpData(startDate,endDate)                 //入院人数生成(医生组)
    s doIns=..ryrsDataPre(info,ryrsDataItemDr,job)    //保存入院人数(医生组)
       
    d ..BedsTmpDataward(startDate,endDate)      //住院病床日数据生成(病区)
    s doIns=..BedsDataPreward(info,rqftDataItemDr,job)    //用于燃气分摊依据
	
	d ..InsTmpData(startDate,endDate)                   //门诊人次数据生成
	s doIns=..InsDataPre(info,insDataItemDr,job)      //保存门诊人次数据

	;d ..shebTmpData(intervalDr,shebDataItemDr)         //设备折旧数据生成
	;s doIns=..shebDataPre(info,shebDataItemDr,job)      //保存设备折旧数据
	
	d ..incomTmpData(intervalDr,incomDataItemDr)         //门诊科室收入数据生成
	s doIns=..incomDataPre(info,incomDataItemDr,job)      //保存门诊科室收入数据
	
	s loc=""
	f loc=164:1:165  d
	.d ..cailGetTmpECData(startDate,endDate,loc)     //材料领用数据生成
	.s doIns=..ECDataPrePara(info,loc,job)          //保存材料领用数据
	
	s i=""
	f i=152:1:163  d
	.d ..BedsTmpData(startDate,endDate)                 //A区服务出院人数生成(医生组)
    .s doIns=..BedsDataPreA(info,i,job)                 //保存A区服务出院人数(医生组)
  
    /*
    d ..BedsTmpData(startDate,endDate)                 //B区服务出院人数生成(医生组)
    s doIns=..BedsDataPreB(info,BDataItemDr,job)    //保存B区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //C区服务出院人数生成(医生组)
    s doIns=..BedsDataPreC(info,CDataItemDr,job)    //保存C区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //D区服务出院人数生成(医生组)
    s doIns=..BedsDataPreD(info,DDataItemDr,job)    //保存D区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //E区服务出院人数生成(医生组)
    s doIns=..BedsDataPreE(info,EDataItemDr,job)    //保存E区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //F区服务出院人数生成(医生组)
    s doIns=..BedsDataPreF(info,FDataItemDr,job)    //保存F区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //H区服务出院人数生成(医生组)
    s doIns=..BedsDataPreH(info,HDataItemDr,job)    //保存H区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //ICU(A)区服务出院人数生成(医生组)
    s doIns=..BedsDataPreIcuA(info,icuADataItemDr,job)    //保存ICU(A)区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //ICU(B)区服务出院人数生成(医生组)
    s doIns=..BedsDataPreIcuB(info,icuBDataItemDr,job)    //保存ICU(B)区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //J区服务出院人数生成(医生组)
    s doIns=..BedsDataPreJ(info,JDataItemDr,job)    //保存J区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //K区服务出院人数生成(医生组)
    s doIns=..BedsDataPreK(info,KDataItemDr,job)    //保存K区服务出院人数(医生组)
    d ..BedsTmpData(startDate,endDate)                 //G区服务出院人数生成(医生组)
    s doIns=..BedsDataPreG(info,GDataItemDr,job)    //保存G区服务出院人数(医生组)
    */
    q "OK"
}

/// Creator：许立新
/// CreatDate：2010-6-10
/// Description: 住院病床日临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期,type-科室(loc),病区(ward)
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).BedsTmpData("2010-03-01","2010-03-15","loc")
ClassMethod BedsTmpData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	;d OutPutIP^DHCWLInPutCAData(start,end,type)
	d GetPatInHosDay^DHCWLInPutCAData(start,end)
	zn "dhc-app"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-26
/// Description: 住院病床日临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期,type-科室(loc),病区(ward)
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).BedsTmpData("2010-03-01","2010-03-15","loc")
ClassMethod BedsTmpDataward(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	d OutPutIPward^DHCWLInPutCAData(start,end)
	zn "dhc-app"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 出院人数临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期,type-科室(loc),病区(ward)
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).BedsTmpData("2010-03-01","2010-03-15","loc")
ClassMethod cyrsTmpData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	;d OutPutIP^DHCWLInPutCAData(start,end,type)
	d GetPatInHosDay^DHCWLInPutCAData(start,end)
	zn "dhc-app"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 入院人数临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期,type-科室(loc),病区(ward)
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).BedsTmpData("2010-03-01","2010-03-15","loc")
ClassMethod ryrsTmpData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	
	d GetPatInHosDay^DHCWLInPutCAData(start,end)
	zn "dhc-app"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-6-10
/// Description: 住院病床日数据准备
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("1^1^load",127,5296)
/// d ##class(%ResultSet).RunQuery("web.RunqianQuery","test","27","4")
ClassMethod BedsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdatabed",2992,0)=2010-01-31^2779^神外一组^185^A区^16

	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdatabed",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdatabed",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)
	..s fwdesc=$p(tmp,"^",5)
	..s tmploc=ipdr_"!"_locdesc_"!"_fwdr_"!"_fwdesc
	..s zyrs=$p(tmp,"^",6)
	..i (ipdr'="") && (zyrs'="") && (zyrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=zyrs
	...e  s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=tmp1+zyrs
	
	k ^TMP("dhc","ca","hisdatabed",job)
	
	s tmploc=""     //^TMPDHCCA("dhc","ca","hisdatabed",2992,"1192!SJWK-神经外科")=9386
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)) q:tmploc=""  d
	.s zyrs=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	.i zyrs'="" d
	..s row=tmploc_"!"_zyrs
	..;s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatabed",job)
	
	q "OK"
}

//利用床日数作为燃气费分摊依据卢晓春0826

ClassMethod BedsDataPreward(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdatabedward",2992,0)=2010-01-31^2779^神外一组^185^A区^16

	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdatabedward",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdatabedward",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)
	..s fwdesc=$p(tmp,"^",5)
	..s tmploc=ipdr_"!"_locdesc_"!"_fwdr_"!"_fwdesc
	..s zyrs=$p(tmp,"^",6)
	..i (ipdr'="") && (zyrs'="") && (zyrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatabedward",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatabedward",job,tmploc)=zyrs
	...e  s ^TMPDHCCA("dhc","ca","hisdatabedward",job,tmploc)=tmp1+zyrs
	
	k ^TMP("dhc","ca","hisdatabedward",job)
	
	s tmploc=""     //^TMPDHCCA("dhc","ca","hisdatabedward",2992,"1192!SJWK-神经外科")=9386
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdatabedward",job,tmploc)) q:tmploc=""  d
	.s zyrs=$g(^TMPDHCCA("dhc","ca","hisdatabedward",job,tmploc))
	.i zyrs'="" d
	..s row=tmploc_"!"_zyrs
	..;s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatabedward",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 出院人数数据准备(加了所在病区)
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("6^12^load",127,2992)
ClassMethod cyrsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdatacyrs",2992,0)=2010-01-31^2779^神外一组^185^A区^6
	
	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdatacyrs",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdatacyrs",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)
	..s fwdesc=$p(tmp,"^",5)
	..s tmploc=ipdr_"!"_locdesc_"!"_fwdr_"!"_fwdesc
	..s cyrs=$p(tmp,"^",6)
	..i (ipdr'="") && (cyrs'="") && (cyrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatacyrs",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatacyrs",job,tmploc)=cyrs
	...e  s ^TMPDHCCA("dhc","ca","hisdatacyrs",job,tmploc)=tmp1+cyrs
	
	k ^TMP("dhc","ca","hisdatacyrs",job)
	
	s tmploc=""  //^TMPDHCCA("dhc","ca","hisdatacyrs",2992,"1192!SJWK-神经外科")=9386
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdatacyrs",job,tmploc)) q:tmploc=""  d
	.s cyrs=$g(^TMPDHCCA("dhc","ca","hisdatacyrs",job,tmploc))
	.i cyrs'="" d
	..s row=tmploc_"!"_cyrs
	..;s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatacyrs",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-25
/// Description: 入院人数数据准备(加了所在病区)
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPre("6^12^load",127,2992)
ClassMethod ryrsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdataryrs",2992,0)=2010-01-31^2779^神外一组^185^A区^6
	
	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdataryrs",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdataryrs",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)
	..s fwdesc=$p(tmp,"^",5)
	..s tmploc=ipdr_"!"_locdesc_"!"_fwdr_"!"_fwdesc
	..s ryrs=$p(tmp,"^",6)
	..i (ipdr'="") && (ryrs'="") && (ryrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdataryrs",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdataryrs",job,tmploc)=ryrs
	...e  s ^TMPDHCCA("dhc","ca","hisdataryrs",job,tmploc)=tmp1+ryrs
	
	k ^TMP("dhc","ca","hisdataryrs",job)
	
	s tmploc=""  //^TMPDHCCA("dhc","ca","hisdataryrs",2992,"1192!SJWK-神经外科")=9386
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdataryrs",job,tmploc)) q:tmploc=""  d
	.s ryrs=$g(^TMPDHCCA("dhc","ca","hisdataryrs",job,tmploc))
	.i ryrs'="" d
	..s row=tmploc_"!"_ryrs
	..;s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdataryrs",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 病区服务床日人数数据准备(加了所在病区)
/// Table：
/// Input：info-相关信息,itemDr-项目Dr,job-进程号
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoad).BedsDataPreA("6^12^load",127,2992)
ClassMethod BedsDataPreA(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdatabed",2992,0)=2010-01-31^2779^神外一组^185^A区^16

	s info=info_"^"_itemDr
	s beizhu=$P(^DHCCAALLDATAITEMS(itemDr),"^",5)
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdatabed",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdatabed",job,num))
	.i tmp'="" d
	..s ipdr=$p(tmp,"^",2)
	..s locdesc=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)  q:fwdr'=beizhu
	..s fwdesc=$p(tmp,"^",5)
	..s tmploc=ipdr_"!"_locdesc_"!"_fwdr_"!"_fwdesc
	..s zyrs=$p(tmp,"^",6)
	..i (ipdr'="") && (zyrs'="") && (zyrs'=0) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=zyrs
	...e  s ^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)=tmp1+zyrs
	
	k ^TMP("dhc","ca","hisdatabed",job)
	
	s tmploc=""     //^TMPDHCCA("dhc","ca","hisdatabed",2992,"1192!SJWK-神经外科")=9386
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc)) q:tmploc=""  d
	.s zyrs=$g(^TMPDHCCA("dhc","ca","hisdatabed",job,tmploc))
	.i zyrs'="" d
	..s row=tmploc_"!"_zyrs
	..;s info=info_"^"_itemDr
	..s result=..DoDataIn(info,row)
	
	k ^TMPDHCCA("dhc","ca","hisdatabed",job)
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 设备折旧临时Global生成   开单收入临时Global生成 
/// Table：
/// Input：
/// Output：
/// Return：
/// Others：
ClassMethod shebTmpData(intervalDr, shebDataItemDr) As %String
{
	n (intervalDr,shebDataItemDr)
	;zn "dhc-app"
	d GetVouPara^DHCCAFunction(intervalDr,shebDataItemDr)
	;zn "dhc-app"
	
	q "OK"
}

ClassMethod incomTmpData(intervalDr, incomDataItemDr) As %String
{
	n (intervalDr,incomDataItemDr)
	;zn "dhc-app"
	d GetIncomePara^DHCCAFunction(intervalDr,incomDataItemDr)
	;zn "dhc-app"
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 门诊人次临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).InsTmpData("2010-03-1","2010-03-15")
ClassMethod InsTmpData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	d OutPutOP^DHCWLInPutCAData(start,end)
	zn "dhc-app"
	
	q "OK"
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 设备折旧数据准备  开单收入数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).InsDataPre("6^12^load",126,2992)
ClassMethod shebDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
  
	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","shebdata",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","shebdata",job,num))
	.i tmp'="" d
	..s deptdr=$p(tmp,"^",2)
	..s tmpDept=deptdr
	..s rc=$p(tmp,"^",7)
	..i ((deptdr'="")&(rc'="")&(rc'=0)) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","shebdata",job,tmpDept))
	...i tmp1="" d  s ^TMPDHCCA("dhc","ca","shebdata",job,tmpDept)=rc
	...e  d  s ^TMPDHCCA("dhc","ca","shebdata",job,tmpDept)=tmp1+rc
	
	k ^TMP("dhc","ca","shebdata",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","shebdata",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","shebdata",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataInvou(info,row)
     
	k ^TMPDHCCA("dhc","ca","shebdata",job)
	
	q "OK"
}

ClassMethod incomDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
  
	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","incomdata",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","incomdata",job,num))
	.i tmp'="" d
	..s deptdr=$p(tmp,"^",2)
	..s tmpDept=deptdr
	..s rc=$p(tmp,"^",7)
	..i ((deptdr'="")&(rc'="")&(rc'=0)) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","incomdata",job,tmpDept))
	...i tmp1="" d  s ^TMPDHCCA("dhc","ca","incomdata",job,tmpDept)=rc
	...e  d  s ^TMPDHCCA("dhc","ca","incomdata",job,tmpDept)=tmp1+rc
	
	k ^TMP("dhc","ca","incomdata",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","incomdata",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","incomdata",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataInvou(info,row)
     
	k ^TMPDHCCA("dhc","ca","incomdata",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 门诊人次数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).InsDataPre("6^12^load",126,2992)
ClassMethod InsDataPre(info, itemDr, job) As %String
{
	n (info,itemDr,job)
	
	//^TMP("dhc","ca","hisdatain",2992,0)=2010-03-01^1104^DMZPFK-D门诊皮肤科^49
	
	s info=info_"^"_itemDr
	s tmp=""
	s tmp1=""
	s num=""
	f  s num=$o(^TMP("dhc","ca","hisdatain",job,num)) q:num=""  d
	.s tmp=$g(^TMP("dhc","ca","hisdatain",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",2)
	..s deptName=$p(tmp,"^",3)
	..s fwdr=$p(tmp,"^",4)
	..s fwdesc=$p(tmp,"^",5)
	..s tmpDept=deptCode_"!"_deptName_"!"_fwdr_"!"_fwdesc
	..s rc=$p(tmp,"^",6)
	..i ((deptCode'="")&(rc'="")&(rc'=0)) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	...i tmp1="" d  s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=rc
	...e  d  s ^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)=tmp1+rc
	
	
	k ^TMP("dhc","ca","hisdatain",job)
	
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept)) q:tmpDept=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","hisdatain",job,tmpDept))
	.i rc'="" d
	..s row=tmpDept_"!"_rc
	..s result=..DoDataIn(info,row)

	k ^TMPDHCCA("dhc","ca","hisdatain",job)
	
	q "OK"
}

/// Creator：许立新
/// CreatDate：2010-3-30
/// Description: 参数数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).DoDataIn(info,row)
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
	s serveDeptCode=$p(row,"!",3)
	s serveDeptName=$p(row,"!",4)
	s value=$p(row,"!",5)
	
	s today=$p($h,",",1)
	
	
	
	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^"_servedDeptCode_"^"_servedDeptName_"^"_"^"_serveDeptCode_"^"_serveDeptName_"^"_"^"_value_"^"_inType_"^"_userDr_"^^"_today
	
	s result=..ParamDatasInsert(data)
	
	q result
}

/// Creator：卢晓春
/// CreatDate：2010-8-4
/// Description: 参数数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).DoDataIn(info,row)
ClassMethod DoDataInvou(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服务部门Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!病床日数"
	//1^6^^^^^6729.4
	s intervalDr=$p(info,"^",1)
	s userDr=$p(info,"^",2)
	s inType=$p(info,"^",3)
	s itemDr=$p(info,"^",4)
	
	s servedDeptdr=$p(row,"!",1)
	s value=$p(row,"!",2)
	
	s today=$p($h,",",1)
		
	
	//组装数据
	s data=intervalDr_"^^^"_itemDr_"^^^^^^"_servedDeptdr_"^^^^"_value_"^"_inType_"^"_userDr_"^^"_today
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
	
	//data=核算区间Dr^项目代码^项目名称^项目Dr^服务部门代码^服务部门名称^服部门务Dr^被服务部门代码^被服务部门名称^被服务部门Dr^参数数值^采集方式^采集人Dr^备注^采集日期
	//s data="3^4^项目名称^5^6^服务部门名称^7^8^被服务部门名称^9^10^导入/录入^11^备注^61815"
	//1^^^127^^^^3399^神外九组^195^K区^21^load^1^^61942
	
	k PLIST
	
	s intervalDr=$p(data,"^",1)                  //核算区间Dr
	i intervalDr'="" s PLIST(2)=intervalDr
	
	s itemCode=$p(data,"^",2)                    //项目代码
	i itemCode'="" s PLIST(3)=itemCode
	
	s itemName=$p(data,"^",3)                    //项目名称
	i itemName'="" s PLIST(4)=itemName
	
	s itemDr=$p(data,"^",4)                      //项目Dr
	i itemDr'="" s PLIST(5)=itemDr
	
	s servDeptCode=$p(data,"^",11)                //服务部门代码
	i servDeptCode'="" s PLIST(6)=servDeptCode
	
	s servDeptName=$p(data,"^",12)                //服务部门名称
	i servDeptName'="" s PLIST(7)=servDeptName
	
	s servDeptDr=$p(data,"^",13)                  //服务部门Dr
	i servDeptDr'="" s PLIST(8)=servDeptDr
	
	s servedDeptCode=$p(data,"^",8)              //被服务部门代码
	i servedDeptCode'="" s PLIST(9)=servedDeptCode
	
	s servedDeptName=$p(data,"^",9)              //被服务部门名称
	i servedDeptName'="" s PLIST(10)=servedDeptName
	
	s servedDeptDr=$p(data,"^",10)               //被服务部门Dr
	i servedDeptDr'="" s PLIST(11)=servedDeptDr
	
	s value=$p(data,"^",14)                      //参数数值
	i value'="" s PLIST(12)=value
	
	s inType=$p(data,"^",15)                     //导入/录入
	i inType'="" s PLIST(13)=inType
	
	s inPersonDr=$p(data,"^",16)                 //采集人
	i inPersonDr'="" s PLIST(14)=inPersonDr
	
	s remark=$p(data,"^",17)                     //备注
	i remark'="" s PLIST(15)=remark
	
	s inDate=$p(data,"^",18)                     //采集日期
	i inDate'="" s PLIST(16)=inDate
	
	&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas VALUES PLIST())
	
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2010-6-11
/// Description: 全院出库记录导入到凭证数据
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).GetOutECData(1,"demo","load")
ClassMethod GetOutECData(intervalDr, userCode, inType) As %String
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
	s info=intervalDr_"^"_userDr_"^"_"2"_"^"_inType
	
	s job=$j
	
	d ..GetTmpECData(startDate,endDate)                   //数据生成
	s doIns=..ECDataPre(info,job)      //保存数据
	
    
    q "OK"
}

/// Creator：YI YU FENG
/// CreatDate：2011-5-24
/// Description: 全院出库记录导入到凭证数据
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).GetOutECDataZJS(3,"trak","load")
ClassMethod GetOutECDataZJS(intervalDr, userCode, inType) As %String
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
	.;w endDate,!
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s info=intervalDr_"^"_userDr_"^"_inType
	
	s job=$j
	
	d ..GetTmpECDataZJS(startDate,endDate)                   //数据生成
	s doIns=..ECDataPreZJS(info,job)      //保存数据
	
    
    q "OK"
}

/// Creator：杨旭
/// CreatDate：2010-6-11
/// Description: 全院出库记录临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).InsTmpData("2010-03-1","2010-03-15")
ClassMethod GetTmpECData(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	d GetOutECData^DHCSTINTERFACEEC(start,end,$LB(224,4,105)) //224 器械卫生材料库，4 保管室,105:公用药房

	zn "dhc-app"
	
	q "OK"
}

ClassMethod GetTmpECData1(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	
	;d GetOutECData^DHCSTINTERFACEEC(start,end,$LB(469,507)) //507 后勤物资仓库，469 材料物资仓库,595制剂室仓库
	d GetOutECRKHZData^DHCSTINTERFACEECrkhz(start,end,$LB(507))
	zn "dhc-app"
	
	q "OK"
}

/// Creator：YI YU FENG 
/// CreatDate：2011-5-25
/// Description: 全院出库记录临时Global生成
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).GetTmpECDataZJS("2011-03-1","2011-03-31")
ClassMethod GetTmpECDataZJS(start, end) As %String
{
	n (start,end)
	
	zn "dhc-data"
	;zn "dhc-app"
	;d GetOutECData^DHCSTINTERFACEEC(start,end,$LB(1122,1125,1138,1244,1210,1225))
	d GetOutECData^DHCSTINTERFACEECForZJS(start,end,$LB(595)) //507 后勤物资仓库，469 材料物资仓库,595制剂室仓库
	zn "dhc-app"
	
	q "OK"
}

//lxc 20100806

ClassMethod cailGetTmpECData(start, end, loc) As %String
{
	n (start,end,loc)
	s beizhu=$P(^DHCCAALLDATAITEMS(loc),"^",5)
	;zn "MEDDATA"
	zn "dhc-data"
	;d GetOutECData^DHCSTINTERFACEEC(start,end,$LB(1122,1125,1138,1244,1210,1225))
	d GetOutECData^DHCSTINTERFACEEC(start,end,$LB(beizhu))
	zn "dhc-app"
	
	q "OK"
}

/// Creator：杨旭
/// CreatDate：2010-6-11
/// Description: 全院出库记录数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output： 
/// Return：                                   //("1^1^load^1^1",4568)
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).ECDataPre("1^1^load^1^1",4568)
ClassMethod ECDataPre(info, job) As %String
{
	n (info,job)
	
	//^TMP("dhc","ca","hisdatain",2992,0)=2010-03-01^1104^DMZPFK-D门诊皮肤科^49
	
	s info=info
	s amount=0     
	s num=""
	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEEC","ECC",job,num)) q:num=""  d
	.s tmp=$g(^TMP("DHCST","DHCSTINTERFACEEC","ECC",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",6)
	..s deptName=$p(tmp,"^",7)
	..s itemCode=$p(tmp,"^",2)
	..s itemName=$p(tmp,"^",3)
	..s tmpItem=itemCode_"!"_itemName
	..s tmpDept=deptCode_"!"_deptName
	..s count=$p(tmp,"^",4)
	..s rc=$p(tmp,"^",5)
	..i ((deptCode'="")&(rc'="")&(rc'=0)&(itemCode'=0)) d
	...s amount=amount+rc
	...s tmp1=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept,tmpItem))
	...i tmp1="" d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept,tmpItem)=count_"!"_rc
	...e  d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept,tmpItem)=($P(tmp1,"!",1)+count)_"!"_($P(tmp1,"!",2)+rc)
	
	
	k ^TMP("DHCST","DHCSTINTERFACEEC","ECC",job)
	s amount=0
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept)) q:tmpDept=""  d
	.s tmpItem=""
	.f  s tmpItem=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept,tmpItem)) q:tmpItem=""  d
	..s rc=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job,tmpDept,tmpItem))
	..i rc'="" d
	...s row=tmpItem_"!"_tmpDept_"!"_rc
	...//w row,!
	...s amount=amount+$p(rc,"!",2)
	..s result=..DoECDataIn(info,row)
	//w amount,!
	k ^TMPDHCCA("DHCST","DHCSTINTERFACEEC","ECC",job)
	
	q "OK"
}

ClassMethod ECDataPre1(info, job) As %String
{
	n (info,job)
	
	//^TMP("dhc","ca","hisdatain",2992,0)=2010-03-01^1104^DMZPFK-D门诊皮肤科^49
	
	s info=info
	s amount=0     
	s num=""
	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEECrkhz","ECC",job,num)) q:num=""  d
	.s tmp=$g(^TMP("DHCST","DHCSTINTERFACEECrkhz","ECC",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",6)
	..s deptName=$p(tmp,"^",7)
	..s itemCode=$p(tmp,"^",2)
	..s itemName=$p(tmp,"^",3)
	..s tmpItem=itemCode_"!"_itemName
	..s tmpDept=deptCode_"!"_deptName
	..s count=$p(tmp,"^",4)
	..s rc=$p(tmp,"^",5)
	..//s amount=amount+rc
	..i ((deptCode'="")&(rc'="")&(rc'=0)&(itemCode'=0)) d
	...s amount=amount+rc
	...s tmp1=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept,tmpItem))
	...i tmp1="" d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept,tmpItem)=count_"!"_rc
	...e  d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept,tmpItem)=($P(tmp1,"!",1)+count)_"!"_($P(tmp1,"!",2)+rc)
	
	k ^TMP("DHCST","DHCSTINTERFACEECrkhz","ECC",job)

	s amount=0
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept)) q:tmpDept=""  d
	.s tmpItem=""
	.f  s tmpItem=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept,tmpItem)) q:tmpItem=""  d
	..s rc=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job,tmpDept,tmpItem))
	..i rc'="" d
	...s row=tmpItem_"!"_tmpDept_"!"_rc

	...s amount=amount+$p(rc,"!",2)
	..s result=..DoECDataIn(info,row)

	k ^TMPDHCCA("DHCST","DHCSTINTERFACEECrkhz","ECC",job)
	
	q "OK"
}

//YYF

/// Creator：YI YU FENG 
/// CreatDate：2010-6-11
/// Description: 全院出库记录数据准备
/// Table：
/// Input：info-相关信息,job-进程号,itemDr-项目Dr
/// Output： 
/// Return：                                   //("1^1^load^1^1",4568)
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).ECDataPreZJS("1^1^load^1^1",4568)
ClassMethod ECDataPreZJS(info, job) As %String
{
	n (info,job)
	
	//^TMP("dhc","ca","hisdatain",2992,0)=2010-03-01^1104^DMZPFK-D门诊皮肤科^49
	
	s info=info
	s amount=0     
	s num=""
	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEECForZJS","ECC",job,num)) q:num=""  d
	.s tmp=$g(^TMP("DHCST","DHCSTINTERFACEECForZJS","ECC",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",6)
	..s deptName=$p(tmp,"^",7)
	..s itemCode=$p(tmp,"^",2)
	..s itemName=$p(tmp,"^",3)
	..s tmpItem=itemCode_"!"_itemName
	..s tmpDept=deptCode_"!"_deptName
	..s count=$p(tmp,"^",4)
	..s rc=$p(tmp,"^",5)
	..s abstract=$p(tmp,"^",8)
	..//s amount=amount+rc
	..i ((deptCode'="")&(rc'="")&(rc'=0)&(itemCode'=0)) d
	...s amount=amount+rc
	...s tmp1=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem))
	...i tmp1="" d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem)=count_"!"_rc
	....//w ^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem)_"A",!
	...e  d  
	....s ^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem)=($P(tmp1,"!",1)+count)_"!"_($P(tmp1,"!",2)+rc)
	....//w ^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem)_"B",!
	
	
	k ^TMP("DHCST","DHCSTINTERFACEECForZJS","ECC",job)
	//w amount,!
	//b
	s amount=0
	s tmpDept=""
	f  s tmpDept=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept)) q:tmpDept=""  d
	.s tmpItem=""
	.f  s tmpItem=$o(^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem)) q:tmpItem=""  d
	..s rc=$g(^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job,tmpDept,tmpItem))
	..i rc'="" d
	...s row=tmpItem_"!"_tmpDept_"!"_rc
	...//w row,!
	...s amount=amount+$p(rc,"!",2)
	..s result=..DoECDataIn(info,row)
	//w amount,!
	k ^TMPDHCCA("DHCST","DHCSTINTERFACEECForZJS","ECC",job)
	
	q "OK"
}

ClassMethod ECDataPrePara(info, loc, job) As %String
{
	n (info,loc,job)
  	s beizhu=$P(^DHCCAALLDATAITEMS(loc),"^",5)
	s info=info_"^"_loc
	s amount=0     
	s num=""
	f  s num=$o(^TMP("DHCST","DHCSTINTERFACEEC","ECC",job,num)) q:num=""  d
	.s tmp=$g(^TMP("DHCST","DHCSTINTERFACEEC","ECC",job,num))
	.i tmp'="" d
	..s deptCode=$p(tmp,"^",6)
	..s deptName=$p(tmp,"^",7)
	
	..s tmploc=deptCode_"!"_deptName_"!"_beizhu_"!"_""
	..s rc=$p(tmp,"^",5)
	..i ((deptCode'="")&(rc'="")&(rc'=0)) d
	...s tmp1=$g(^TMPDHCCA("dhc","ca","cailiaocr",job,tmploc))
	...i tmp1="" s ^TMPDHCCA("dhc","ca","cailiaocr",job,tmploc)=rc
	...e  s ^TMPDHCCA("dhc","ca","cailiaocr",job,tmploc)=tmp1+rc
	
	k ^TMP("DHCST","DHCSTINTERFACEEC","ECC",job)
	s tmploc=""
	f  s tmploc=$o(^TMPDHCCA("dhc","ca","cailiaocr",job,tmploc)) q:tmploc=""  d
	.s rc=$g(^TMPDHCCA("dhc","ca","cailiaocr",job,tmploc))
	.i rc'="" d
	..s row=tmploc_"!"_rc
	..s result=..DoDataIn(info,row)
	k ^TMPDHCCA("dhc","ca","cailiaocr",job)
	
	q "OK"
}

/// Creator：杨旭	
/// CreatDate：2010-6-11
/// Description: 凭证数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).DoDataIn(info,row)
ClassMethod DoECDataIn(info, row) As %String
{
	n (info,row)
	
	q:info="" "infoErr"
	q:row="" "rowErr"
	s itemCode=$p(row,"!",1)
	s itemName=$p(row,"!",2)
	s servedDeptCode=$p(row,"!",3)
	s servedDeptName=$p(row,"!",4)
	
	s count=$p(row,"!",5)
	s fee=$p(row,"!",6)
	
	s today=$p($h,",",1)
	
	//组装数据
	//data="业务日期^数据项代码^数据项名称^服务部门代码^服务部门名称^服务人员代码^服务人员名称^承担部门代码^承担部门名称^承担人员代码^承担人员名称^单价^数量^金额^备注^备注1^备注2"
	//s data="201003^30^CT费^1^170^212121^111^SJWK-神经外科^111^FSK-放射科^111^SJWK-神经外科^1179^A-A区^^^I^111^神外一组"
	;s data=intervalDr_"^"_itemCode_"^"_itemName_"^^^^"_servedDeptCode_"^"_servedDeptName_"^^^"_count_"^"_fee_"^^^"
	s data=servedDeptCode_"^"_servedDeptName_"^"_itemCode_"^"_itemName_"^"_fee
	s result=..BaseDataInsert(info, data)
	s result="" s result=0
	q result
}

//yyf

/// Creator：YI YU FENG 
/// CreatDate：2011-5-24
/// Description: 凭证数据写入
/// Table：
/// Input：info-公共信息,row-需要插入的数据
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).DoDataIn(info,row)
ClassMethod DoECDataInZJS(info, row) As %String
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
	
	s itemCode=$p(row,"!",1)
	s itemName=$p(row,"!",2)
	s servedDeptCode=$p(row,"!",3)
	s servedDeptName=$p(row,"!",4)
	
	s count=$p(row,"!",5)
	s fee=$p(row,"!",6)
	
	s today=$p($h,",",1)
	
	//组装数据
	//data="业务日期^数据项代码^数据项名称^服务部门代码^服务部门名称^服务人员代码^服务人员名称^承担部门代码^承担部门名称^承担人员代码^承担人员名称^单价^数量^金额^备注^备注1^备注2"
	//s data="201003^30^CT费^1^170^212121^111^SJWK-神经外科^111^FSK-放射科^111^SJWK-神经外科^1179^A-A区^^^I^111^神外一组"
	s data=intervalDr_"^"_itemCode_"^"_itemName_"^^^^"_servedDeptCode_"^"_servedDeptName_"^^^"_count_"^"_fee_"^^^"
	s tmpJob=$p($h,",",1)_$p($h,",",2)
	s result=..VouchDataInsertTwo(info, data, tmpJob)
	s result="" s result=0
	q result
}

/// Creator：杨旭
/// CreatDate：2010-06-09
/// Description: 凭证数据导入
/// Table：dhc_ca_cache_data.IncomeDatas
/// Input：info-导入需要的信息,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(test.ttt).VouchDataInsert("6^demo^load","6^11^西药^^^^1128^JYK-校验科^^^50^8^^^")
ClassMethod VouchDataInsertTwo(info, data, tmpJob) As %String
{
	n (info,data,tmpJob)
	
	//s info="6^12^input^1^4^4"
	//s data="^^^^83^^市场部^scb-市场部^^^^设备"

	k PLIST
	//s tmpJob=$p($h,",",1)_$p($h,",",2)
	s deptSetDr=$p(info,"^",4)                     //项目套
	s itemSetDr=$p(info,"^",5)                     //科室套
	s itemType=$p(info,"^",6) 
	
	s intervalDr=$p(info,"^",1)
	i intervalDr'="" s PLIST(2)=intervalDr         //核算区间Dr
	
	s itemCode=$p(data,"^",2)
	i itemCode'="" s PLIST(15)=itemCode               //核算子类代码
	
	s itemName=$p(data,"^",3)
	i itemName'="" s PLIST(16)=itemName             //核算子类名称
	
	i itemSetDr'="" d
	.s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
	.i itemDr'="" s PLIST(4)=itemDr                 //项目Dr
	
	i itemType'="" d
	.s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemByTypeRelation(itemType,itemCode)
	.i itemDr'="" s PLIST(4)=itemDr 
	       
	i ((itemType="")&(itemSetDr="")) d
	.s itemDr=$p(data,"^",5)
	.i itemDr'="" s PLIST(4)=itemDr 
	
	s cost=$p(data,"^",12)
	i cost'="" s PLIST(17)=cost                     //成本金额
	
	s fDeptCode=$p(data,"^",7)
	i fDeptCode'="" s PLIST(13)=fDeptCode          //开单科室代码
	s fDeptName=$p(data,"^",8)
	i fDeptName'="" s PLIST(14)=fDeptName          //开单科室名称
	
	s itemcode=$p(data,"^",9)
	i itemcode'="" s PLIST(15)=itemcode          //项目代码
	s intype=$p(info,"^",3)
	s PLIST(5)=intype
	s PLIST(19)="N"                                //分路标志
	
	s inPersonDr=$p(info,"^",2)
	i inPersonDr'="" s PLIST(6)=inPersonDr        //采集人Dr
	
	//s remark=""
	//i remark'="" s PLIST(8)=remark                //备注
	s PLIST(7)= tmpJob
	s PLIST(8)="N" //处理标志
	s inDate=$p($h,",",1)
	i inDate'="" s PLIST(11)=inDate                //采集日期
	&SQL(INSERT INTO dhc_ca_cache_data.VouchDatas VALUES PLIST())
	//b
	q SQLCODE
}

//-------

/// Creator：ZJW
/// CreatDate：2016-03-24
/// Description: 凭证数据导入
/// Table：dhc_ca_cache_data.BaseDatas
/// Input：info-导入需要的信息,data-需要写入的数据串
/// Output：
/// Return：SQLCODE
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).BaseDataInsert("6^demo^load","6^11^西药^^^^1128^JYK-校验科^^^50^8^^^")
ClassMethod BaseDataInsert(info, data) As %String
{
	n (info,data)
    s itemSetDr=1  //接口项目套
    s deptSetDr=1  //接口部门套
    s patType=""
	k PLIST
	s intervalDr=$p(info,"^",1)                    //核算区间
	q:intervalDr="" "intervalErr"
	s PLIST(2)=intervalDr 
	s PLIST(3)="cost"
	
	s inPersonDr=$p(info,"^",2)                     //采集人
    q:inPersonDr="" "userErr"
    s PLIST(26)=inPersonDr  

    s dataType=$p(info,"^",3)                          //数据类别
    q:dataType="" "dataTypeErr"               
   	s PLIST(4)=dataType
   	
    s inType=$p(info,"^",4)                        //操作类别
    q:inType="" "inTypeErr"
	s PLIST(24)=inType
			       
	s remark=$p(info,"^",5)                        //成本备注BaseData_remark
	i remark'=""  	s PLIST(28)=remark
	
	s inDate=$p($h,",",1)
	i inDate'="" s PLIST(25)=inDate                //采集日期
	
	q:data="" "DataErr"                             //数据
	s DeptCode=$p(data,"^",7)                      //科室代码
	i DeptCode'="" s PLIST(16)=DeptCode     
	  
	s DeptName=$p(data,"^",8)                      //科室名称
	i DeptName'="" s PLIST(17)=DeptName            
	s DeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,DeptCode,patType)
	i DeptDr'="" s PLIST(15)=DeptDr               //内部开单科室Dr
	
	s itemcode=$p(data,"^",9)                      //项目代码
	i itemcode'="" s PLIST(7)=itemcode     
	
	i ((itemcode'="")&(itemSetDr'="")) s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemcode)
    s PLIST(6)=itemDr
	                    
	s itemname=$p(data,"^",10)                      //项目名称
	i itemname'=""  s PLIST(8)=itemname           
   	
   	s cost=$p(data,"^",12)                          //成本金额
    i cost'="" s PLIST(23)=cost                     
    q:cost=0 0	//成本为零的不取
	&SQL(INSERT INTO dhc_ca_cache_data.BaseData VALUES PLIST())
    
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2010-07-06
/// Description: 折旧信息录入
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoadHS).getDepreciation("1","demo")
ClassMethod getDepreciation(intervalDr, userCode) As %String
{
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!病床日数"
	//维修费ID:235,折旧费ID:253.
	q:intervalDr="" "emptyIntervalDr"
	q:userCode="" "emptyUserCode"
	TSTART
	n (intervalDr, userCode)
	
	k ^TMP("dhc","ca","Depreciation")
	k ^TMP("dhc","ca","MaintFee")
	
	
	s start=""
	s end=""
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	.s start=$zd(start,3)                                       //核算区间起始日期
	.s end=$zd(end,3)                                           //核算区间终止日期
	.s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	.//s deptSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",4)
	.//s itemSetDr=$p(^DHCCALOADRULES(loadRulesDr),"^",5)
	.s info=intervalDr_"^"_userDr_"^"_"Z"_"^^"
	//s start="2009-12-01"
	//s end="2009-12-31"
	q:end="" "emptyEnd"
	q:start="" "emptyStart"
	s start=$zdh(start,3)
	s end=$zdh(end,3)
	d ##class(web.DHCEQForCA).getDepreciation(start,end)
	
	s flag=0
	s job=$p($h,",",1)_$p($h,",",2)
	s tmpJob=""
	f  s tmpJob=$o(^TMP("dhc","ca","Depreciation",tmpJob)) q:tmpJob=""  d
	.s tmpNow=""
	.f  s tmpNow=$o(^TMP("dhc","ca","Depreciation",tmpJob,tmpNow)) q:tmpNow=""  d
	..s data=$g(^TMP("dhc","ca","Depreciation",tmpJob,tmpNow))
	..s data="^^"_$p(data,"^",5)_"^^^^"_$P(data,"^",2)_"^"_$P(data,"^",3)_"^"_"sbzj"_$p(data,"^",4)_"^^^"_$P(data,"^",6)    //342为专用设备折旧rowid
	..s tmpRs=""
	..s tmpRs=..VouchDataInsertTwo(info, data, job)
	..i tmpRs'="" s flag=tmpRs
	/* 取设备维修
	s tmpJob=""
	f  s tmpJob=$o(^TMP("dhc","ca","MaintFee",tmpJob)) q:tmpJob=""  d
	.s tmpNow=""
	.f  s tmpNow=$o(^TMP("dhc","ca","MaintFee",tmpJob,tmpNow)) q:tmpNow=""  d
	..s data=$g(^TMP("dhc","ca","MaintFee",tmpJob,tmpNow))
	..s data="^^^^235^^"_$P(data,"^",2)_"^"_$P(data,"^",3)_"^wxf^^^"_$P(data,"^",6)  //235为设备维修rowid
	..s tmpRs=""
	..s tmpRs=..VouchDataInsertTwo(info, data, job)
	..i tmpRs'="" s flag=tmpRs
	*/
	i flag=0 TCOMMIT
	e  TROLLBACK
	q flag
}

/// Creator:zbp
/// CreatDate：2013-8-12
/// Description: 接口程序入口函数
/// Table：
/// Input：intervalDr-核算区间,userCode-导入人,inType-导入方式
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.comm.DataLoadHS).BuildCostDatas(1,"demo","2","P")
ClassMethod BuildCostDatas(intervalDr, userCode, dataType, inType) As %String
{
	n (intervalDr,userCode,dataType,inType)
	
	q:intervalDr="" "intervalErr"
	q:userCode="" "userCodeErr"
	q:inType="" "inTypeErr"
	s start=""
	s end=""
	s userDr=""
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	s info=intervalDr_"^"_userDr_"^"_inType_"^"_"1"_"^"_"1"_"^"
	s job=$j
	k ^temp("dhccahs",job)
	i dataType=2 d   //导入成本数据 
	.zn "dhc-data"
	.s start=$zd(start,3),end=$zd(end,3)
	.d GetCostDatas^DHCHSInterFace(start,end,inType)  //调接口程序生成数据存放在临时global
	.zn "dhc-app"                      
	s result1=..ReadTmpData(info,job)
	i result1="ok" d      
	.s result=..GetPreDatas(info,job)        
    k ^temp("dhccahs",job)
  
    q result
}

/// Creator:zbp
/// CreatDate：2013-8-12
/// Description: 读取接口生成的临时global数据并汇总之
/// Input：info-相关信息,job-进程号
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).ReadTmpData("1^1312^cost^load",7516)
ClassMethod ReadTmpData(info, job) As %String
{
	n (info,job)	   
	s num=""
	s mname="DHCHSInterFace"
	f  s num=$o(^TEMPDHCAHS(mname,"dhccahs",job,num)) q:num=""  d 
	.s tmp=$g(^TEMPDHCAHS(mname,"dhccahs",job,num))
	.s deptCode=$p(tmp,"^",1)
	.s deptName=$p(tmp,"^",2)
	.s itemCode=$p(tmp,"^",3)
	.s itemName=$p(tmp,"^",4)
	.s value=$p(tmp,"^",5)
	.s price=$p(tmp,"^",6)
	.s amount=$p(tmp,"^",7)
	.i $d(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName)) d 
    ..s value=$p(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName),"^",1)+value
    ..s amount=$p(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName),"^",3)+amount
    ..s ^temp("dhccahs",job,deptCode,deptName,itemCode,itemName)=value_"^"_price_"^"_amount
    .e  d 
    ..s ^temp("dhccahs",job,deptCode,deptName,itemCode,itemName)=value_"^"_price_"^"_amount    
    k ^TEMPDHCAHS(mname,"dhccahs",job)
    q "ok"
}

/// Creator:zbp
/// CreatDate：2013-8-16
/// Description: 取临时global数据并调用写入函数
/// Input：info-相关信息,job-进程号
/// Others：d ##class(dhc.ca.cache.comm.DataLoadHS).ReadTmpData("1^1312^cost^load",7516)
ClassMethod GetPreDatas(info, job) As %String
{
	n (info,job)	   
	TSTART
	s flag=0,result=0
	s deptCode="" f  s deptCode=$o(^temp("dhccahs",job,deptCode)) q:deptCode=""  d 
	.s deptName="" f  s deptName=$o(^temp("dhccahs",job,deptCode,deptName)) q:deptName=""  d 
	..s itemCode="" f  s itemCode=$o(^temp("dhccahs",job,deptCode,deptName,itemCode)) q:itemCode=""  d 
	...s itemName="" f  s itemName=$o(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName)) q:itemName=""  d
	....s value=$p(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName),"^",1)
	....s price=$p(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName),"^",2)
	....s amount=$p(^temp("dhccahs",job,deptCode,deptName,itemCode,itemName),"^",3)
	....;s data=deptCode_"^"_deptName_"^"_itemCode_"^"_itemName_"^"_value_"^"_price_"^"_amount
	....s data="^"_itemCode_"^"_itemName_"^^^"_value_"^"_deptCode_"^"_deptName
	....;s result=..BaseDataInsert(info, data)

	....s result=..VouchDataInsert(info, data,"")
    ....i result'=0  s flag=result
    i flag=0  TCOMMIT  
    e  TROLLBACK
   
    q flag
}

Storage Default
{
<StreamLocation>^dhc.ca.c.DataLoadHSS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
