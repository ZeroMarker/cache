/// Creator: 杨旭
/// CreatDate: 2010-04-09
/// Description: 收入梳理规则维护
Class dhc.ca.cache.udata.uInDataCardRule Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-04-09
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDataCardRule
/// Input: parRef-收入数据梳理Dr, itemDr-项目DR, srDeptDr-源科室Dr, deDeptDr-目标科室Dr
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others:W ##class(dhc.ca.cache.udata.uInDataCardRule).InsertRec("2", "322", "I", "","321")
ClassMethod InsertRec(parRef, srDeptDr, PatTypeCode, itemDr, deDeptDr) As %String
{
	n (parRef, srDeptDr, PatTypeCode, itemDr, deDeptDr)
	//w parRef_"^"_itemDr_"^"_srDeptDr_"^"_deDeptDr,!
	
	//zjw 20160120  
	s info="",childSub="",parRefcode=""
	s info=..IfRepeat(parRef,srDeptDr,PatTypeCode,itemDr)
	s parRefcode=$p(^DHCCAINDATACARDING(parRef),"^",2)
	;w info,!
	//针对已添加的规则，指出已指向的目标科室
	i (info="RepSrDept")&&(parRefcode="01") s info="SrDeptExist"
	
	i (info="RepSrDept")&&(parRefcode="02") d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDeptDr",parRef,srDeptDr,childSub))
	.;w info_"^"_childSub,!
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)   //取已存在的目标科室名称
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	
	i info="RepSrDeptPatType" d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDrPatType",parRef,srDeptDr,PatTypeCode,childSub))
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	i info="RepSrDeptPatTypeItem" d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDrPattypeItemDr",parRef,srDeptDr,PatTypeCode,itemDr,childSub))
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	
	q:info'="" info
	
	k PLIST
	q:parRef=0 "-100"
	s PLIST(0)=parRef
	i itemDr'=""  s PLIST(3)=itemDr
	i srDeptDr'="" s PLIST(4)=srDeptDr     
	i deDeptDr'="" s PLIST(5)=deDeptDr 
	i PatTypeCode'="" s PLIST(6)=PatTypeCode 
	&SQL(INSERT INTO dhc_ca_cache_data.InDataCardRule VALUES PLIST())
	q SQLCODE
}

/// Creator: zjw
/// CreatDate: 2016-01-21
/// Description: 判定重复信息
/// Table: dhc.ca.cache.data.InDataCardRule
/// Input: CardRuleId-收入梳理规则Dr, itemDr-项目DR, srDeptDr-源科室Dr, deDeptDr-目标科室Dr
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: W ##class(dhc.ca.cache.udata.uInDataCardRule).IfRepeat("2", "322", "", "")
ClassMethod IfRepeat(parRef, srDeptDr, PatTypeCode, itemDr) As %String
{
	  n (parRef,itemDr, srDeptDr,PatTypeCode)
	  s info=""
	
	//取出原有的系统数据个数
	s numSr=0,numSrPat=0,numSrPatItem=0
	
	s childSubSr=0	f  s childSubSr=$o(^DHCCAINDATACARDING(0,"SrDeptDr",parRef,srDeptDr,childSubSr)) q:childSubSr=""  d
	.s numSr=numSr+1 					//取原有规则中含有srDeptDr的个数numSr
	.s PatType="" f  s PatType=$o(^DHCCAINDATACARDING(0,"SrDrPatType",parRef,srDeptDr,PatType)) q:PatType=""  d
	..s numSrPat=numSrPat+1 			//取原有规则中含有PatType的个数numSrPat
	..s PatTypeItemDr="" f  s PatTypeItemDr=$o(^DHCCAINDATACARDING(0,"SrDrPattypeItemDr",parRef,srDeptDr,PatType,PatTypeItemDr)) q:PatTypeItemDr=""  d
	...s numSrPatItem=numSrPatItem+1	//取原有规则中含有PatTypeItem的个数numSrPatItem

	;w numSr_"^"_numSrPat_"^"_numSrPatItem,!
	;b
	
	s numSrPat2=0,numSrPatItem2=0,numSrPat3=0
	i PatTypeCode="" d  //收入类型为空，则项目必为空 :判断是否源科室重复【01、02】、源科室已有收入类型规则【02】
	.i (numSr=1)&&(numSrPat=0) 			s info="RepSrDept"		//(源科室独立)规则重复
	.i (numSrPat>=1)&&(numSrPatItem=0)	s info="PatTypeExist"	//源科室已存在含有收入类型的规则
	.i (numSrPatItem>=1) 				s info="ItemExist"		//源科室已存在含有收入项目的规则
	e  d				//收入类型不为空
	.s childSubSrPat=0 f  s childSubSrPat=$o(^DHCCAINDATACARDING(0,"SrDrPatType",parRef,srDeptDr,PatTypeCode,childSubSrPat)) q:childSubSrPat=""  d
	..s numSrPat2=numSrPat2+1				//取规则中含有新加收入类型的个数numSrPat
	.s PatTypeItem="" f  s PatTypeItem=$o(^DHCCAINDATACARDING(0,"SrDrPattypeItemDr",parRef,srDeptDr,PatTypeCode,PatTypeItem)) q:PatTypeItem=""  d
	..s numSrPatItem2=numSrPatItem2+1		//判断新添加的收入类型规则下的收入项目之个数
	.i itemDr=""  d		//收入类型不为空，项目为空时：判断该规则是否重复【02】、是否已存在收入类型为空即源科室独立规则【02】、是否已存在该收入类型的含项目规则【02】
	..i (numSr=1)&&(numSrPat=0)				s info="SrDeptExist"  		//源科室已存在独立规则
	..i (numSrPat2=1)&&(numSrPatItem2=0)	s info="RepSrDeptPatType"	//(源科室&&收入类型)规则重复
	..i (numSrPatItem2>=1) 					s info="ItemExist"			//已存在同收入类型(源科室&&收入类型&&收入项目)的规则

	.e  d				//收入类型、项目均有值：判断该规则是否重复【02】、是否已存在源科室独立规则【02】、是否已存在同收入类型独立规则【02】	
	..i (numSr=1)&&(numSrPat=0) 			s info="SrDeptExist"  	//源科室已存在独立规则
	..i (numSrPat2>=1)&&(numSrPatItem2=0)	s info="PatTypeExist"	//(源科室&&收入类型)规则已存在
	..i $d(^DHCCAINDATACARDING(0,"SrDrPattypeItemDr",parRef,srDeptDr,PatTypeCode,itemDr))  s info="RepSrDeptPatTypeItem"	//(源科室&&收入类型&&收入项目)规则重复
	
	;w numSrPat_"^"_numSrPatItem_"^"_numSrPat2_"^"_numSrPatItem2_"^"_info,!
	;b
	
	q info
}

/// Creator: zjw
/// CreatDate: 2016-01-21
/// Description: 更改记录
/// Table: dhc.ca.cache.data.InDataCardRule
/// Input: CardRuleId-收入梳理规则Dr, itemDr-项目DR, srDeptDr-源科室Dr, deDeptDr-目标科室Dr
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: W ##class(dhc.ca.cache.udata.uInDataCardRule).UpdateRec(CardRuleId,itemDr, srDeptDr, deDeptDr,PatTypeCode)
ClassMethod UpdateRec(CardRuleId, srDeptDr, PatTypeCode, itemDr, deDeptDr) As %String
{
	n (CardRuleId,itemDr, srDeptDr, deDeptDr,PatTypeCode)
	  //w parRef_"^"_itemDr_"^"_srDeptDr_"^"_deDeptDr,!
	  
	  
	S childSub=$p(CardRuleId,"||",2)
	q:childSub=0 "-100"
	s parRef=$p(CardRuleId,"||",1),info=""
	 
	//将原CardRuleId对应各值求出来
	s PLIST3=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",1)	//itemDr
	s PLIST4=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",2)	//srDeptDr
	s PLIST5=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)	//deDeptDr
	s PLIST6=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",4)	//PatTypeCode

	//将CardRuleId自身刨除后与其他对比 
	&SQL(UPDATE dhc_ca_cache_data.InDataCardRule SET InDataCardRule_itemDr=NULL ,InDataCardRule_srDeptDr=NULL,InDataCardRule_deDeptDr=NULL,InDataCardRule_pattype=NULL where InDataCardRule_rowid=:CardRuleId )
	s info=..IfRepeat(parRef, srDeptDr,PatTypeCode,itemDr)
	
	//若刨除后对比仍然有重复值，则恢复原状
	i info'="" d
	.&SQL(update dhc_ca_cache_data.InDataCardRule set InDataCardRule_itemDr=:PLIST3,InDataCardRule_srDeptDr=:PLIST4,InDataCardRule_deDeptDr=:PLIST5,InDataCardRule_pattype=:PLIST6 where InDataCardRule_rowid=:CardRuleId )
	
	//针对已添加的规则，指出已指向的目标科室
	
	s parRefcode=$p(^DHCCAINDATACARDING(parRef),"^",2)
	
	s childSub=""
	i (info="RepSrDept")&&(parRefcode="01") s info="SrDeptExist"
	i (info="RepSrDept")&&(parRefcode="02") d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDeptDr",parRef,srDeptDr,childSub))
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)   //取已存在的目标科室名称
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	i info="RepSrDeptPatType" d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDrPatType",parRef,srDeptDr,PatTypeCode,childSub))
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	i info="RepSrDeptPatTypeItem" d
	.s childSub=$o(^DHCCAINDATACARDING(0,"SrDrPattypeItemDr",parRef,srDeptDr,PatTypeCode,itemDr,childSub))
	.s info=$p(^DHCCAINDATACARDING(parRef,"Rule",childSub),"^",3)
	.s info=$p(^DHCCAUNITDEPTS(info),"^",2)		//取科室名称
	
	
	q:(info'="") info
	
	&sql(update dhc_ca_cache_data.InDataCardRule set InDataCardRule_itemDr=:itemDr,InDataCardRule_srDeptDr=:srDeptDr,InDataCardRule_deDeptDr=:deDeptDr,InDataCardRule_pattype=:PatTypeCode where InDataCardRule_rowid=:CardRuleId )
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-04-09
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDataCardRule
/// Input: parRef-收入数据梳理Dr,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDataCardRule).ListRec("","","rowid","DESC","0",10,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_parRef
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InDataCardRule_rowid,InDataCardRule_itemDr,InDataCardRule_srDeptDr,InDataCardRule_deDeptDr,InDataCardRule_pattype FROM dhc_ca_cache_data.InDataCardRule"
	
	s whereStr=" WHERE InDataCardRule_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND InDataCardRule_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDataCardRule_childSub"
	.i sortField="itemName" s sortField1="InDataCardRule_itemDr"
	.i sortField="srDeptName" s sortField1="InDataCardRule_srDeptDr"
	.i sortField="deDeptName" s sortField1="InDataCardRule_deDeptDr"
	.i sortField="itemCode" s sortField1="InDataCardRule_itemDr"
	.i sortField="srDeptCode" s sortField1="InDataCardRule_srDeptDr"
	.i sortField="deDeptCode" s sortField1="InDataCardRule_deDeptDr"
	.i sortField="PatTypeName" s sortField1="InDataCardRule_pattype"
	
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InDataCardRule_childSub DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^itemDr^itemCode^itemName^srDeptDr^srDeptCode^srDeptName^deDeptDr^deDeptCode^deDeptName^PatTypeName"
	
	While(result.Next())
	{
		s rowid=result.Data("InDataCardRule_rowid")
		s itemDr=result.Data("InDataCardRule_itemDr")
		s itemCode=""
		s itemName="" 
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		..s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		
		
		s srDeptDr=result.Data("InDataCardRule_srDeptDr")
		s srDeptName=""
		s srDeptCode=""
		i srDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(srDeptDr)) d
		..s srDeptName=$p($g(^DHCCAUNITDEPTS(srDeptDr)),"^",2)
		..s srDeptCode=$p($g(^DHCCAUNITDEPTS(srDeptDr)),"^",1)
		
		s deDeptDr=result.Data("InDataCardRule_deDeptDr")
		s deDeptName=""
		s deDeptCode=""
		i deDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(deDeptDr)) d
		..s deDeptName=$p($g(^DHCCAUNITDEPTS(deDeptDr)),"^",2)
		..s deDeptCode=$p($g(^DHCCAUNITDEPTS(deDeptDr)),"^",1)
		
		s PatTypeName=result.Data("InDataCardRule_pattype")
		i PatTypeName'="" d
		.s:PatTypeName="O" PatTypeName="门诊"
		.s:PatTypeName="I" PatTypeName="住院"
		.s:PatTypeName="H" PatTypeName="体检"	

		s tmp=rowid_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_srDeptDr_"^"_srDeptCode_"^"_srDeptName_"^"_deDeptDr_"^"_deDeptCode_"^"_deDeptName_"^"_PatTypeName
		
		i searchValue'="" d
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="srDeptCode")&(srDeptCode'[searchValue)
		.q:(searchField="deDeptCode")&(deDeptCode'[searchValue)
		.q:(searchField="srDeptName")&(srDeptName'[searchValue)
		.q:(searchField="deDeptName")&(deDeptName'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-04-09
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDataCardRule
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInDataCardRule).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDataCardRule WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator：zbp
/// CreatDate：2013-08-01
/// Description: 按规则进行对照
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：intervalDr-月份ID;deptType-转换部门类型
/// Output：
/// Return：0为成功,否则为错误代码
/// Others：w ##class(dhc.ca.cache.udata.uInDataCardRule).InnerDeptControl(37,11,"01","02","03")
ClassMethod InnerDeptControl(intervalDr) As %String
{
	TSTART

	q:intervalDr="" "emptyIntervalDr"
	n (intervalDr)
	s Rs=0
	s priority=""
	f  s priority=$o(^DHCCAINDATACARDING(0,"Pri",priority)) q:priority=""  d  //优先级InDataCarding_priority
	.s cardingDr=""
	.f  s cardingDr=$o(^DHCCAINDATACARDING(0,"Pri",priority,cardingDr)) q:cardingDr=""  d	//InDataCarding_rowid=InDataCardRule_parRef
	..s cardingCode=""
	..s cardingCode=$p($g(^DHCCAINDATACARDING(cardingDr)),"^",2)
	..s Active=$p($g(^DHCCAINDATACARDING(cardingDr)),"^",6)
	..q:Active="N"  //20160120  zjw 无效之收入数据梳理
	..i cardingCode="01" d              //用病人科室替换开单科室
	...s cardRuleDr=0
	...f  s cardRuleDr=$o(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr))  q:cardRuleDr=""  d   //InDataCardRule_childSub
	....s srDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",2) //源科室
	....s tmpIncomeDr="" f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",intervalDr, srDeptDr,tmpIncomeDr)) q:tmpIncomeDr=""  d 
	.....s patDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",17)
	.....s PLIST(12)=patDeptDr   //开单科室
	.....&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	.....i SQLCODE'=0 s Rs=SQLCODE	
	..i cardingCode="02" d             //非临床开单科室转换为指定科室
	...s cardRuleDr=0 
	...f  s cardRuleDr=$o(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr))  q:cardRuleDr=""  d
	....s srDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",2) //源科室
	....s ItemDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",1) //源核算项目DR
	....s PatType=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",4) //源收入类型
	....s deDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",3) //目标科室
	....i PatType=""  d	//若指定收入类型为空
	.....s tmpIncomeDr="" f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",intervalDr, srDeptDr,tmpIncomeDr)) q:tmpIncomeDr=""  d 
	......s PLIST(12)=deDeptDr	//目标科室替换开单科室
	......;s PLIST(18)=deDeptDr	//目标科室替换病人科室
	......&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	....e  d  			//若指定收入类型不为空
	.....i ItemDr=""  d		//若指定收入类型不为空  指定核算项目为空
	......s tmpIncomeDr="" f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"IntervalTypeFdept",intervalDr,PatType,srDeptDr,tmpIncomeDr)) q:tmpIncomeDr=""  d 
	.......s PLIST(12)=deDeptDr		//目标科室替换开单科室
	.......;s PLIST(18)=deDeptDr	//目标科室替换病人科室
	.......&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	.....e  d				//若指定收入类型和核算项目均不为空
	......s tmpIncomeDr="" f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"IntervalTypeFdeptItem",intervalDr,PatType,srDeptDr,ItemDr,tmpIncomeDr)) q:tmpIncomeDr=""  d 
	.......s PLIST(12)=deDeptDr		//目标科室替换开单科室
	.......;s PLIST(18)=deDeptDr	//目标科室替换病人科室
	.......&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)	
	
	
	i Rs'=0 TROLLBACK
	
	e  TCOMMIT

	q Rs
}

/*
/// Creator：杨旭
/// CreatDate：2010-04-12
/// Description: 按规则进行对照
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：intervalDr-月份ID;deptType-转换部门类型;ruleOne-规则1code;ruleTwo-规则2code;ruleThree-规则3code;
/// Output：
/// Return：0为成功,否则为错误代码
/// Others：w ##class(dhc.ca.cache.udata.uInDataCardRule).InnerDeptControl(7,11,"02","03","01")
ClassMethod InnerDeptControl(intervalDr, deptType, ruleOne, ruleTwo, ruleThree) As %String
{
	TSTART

	q:intervalDr="" "emptyIntervalDr"
	q:deptType="" "emptyDeptType"
	n (intervalDr, deptType, ruleOne, ruleTwo, ruleThree)
	s Rs=0
	s priority=""
	f  s priority=$o(^DHCCAINDATACARDING(0,"Pri",priority)) q:priority=""  d 
	.s cardingDr=""
	.f  s cardingDr=$o(^DHCCAINDATACARDING(0,"Pri",priority,cardingDr)) q:cardingDr=""  d
	..s cardingCode=""
	..s cardingCode=$p($g(^DHCCAINDATACARDING(cardingDr)),"^",2)
	..i cardingCode=ruleOne d              //开单=执行=指定科室的，用病人科室替换开单科室
	...;w "ruleOne",!-02
	...s tmpIncomeDr=""
	...f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,tmpIncomeDr)) q:tmpIncomeDr=""  d
	....i $d(^DHCCAINCOMEDATAS(tmpIncomeDr)) d
	.....s servDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",11)
	.....s servedDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",14)
	.....s patDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",17)
	.....s itemDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",6)
	.....;i servDeptDr=servedDeptDr d    //开单科室=执行科室，卢晓春20110416屏蔽
	.....s cardRuleDr=""
	.....f  s cardRuleDr=$o(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)) q:cardRuleDr=""  d
	......k PLIST
	......s srDeptDr=""
	......s srDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",2)
	......i srDeptDr=servDeptDr d
	.......s PLIST(12)=patDeptDr
	......&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	......i SQLCODE'=0 s Rs=SQLCODE
	..e  i cardingCode=ruleTwo d          //某收入项为指定项目时，把开单与执行科室用指定科室替换
	
	...//w "rule2",!-03
	...s tmpIncomeDr=""
	...f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,tmpIncomeDr)) q:tmpIncomeDr=""  d
	....i $d(^DHCCAINCOMEDATAS(tmpIncomeDr)) d
	.....s servDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",11)
	.....s servedDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",14)
	.....s patDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",17)
	.....s itemDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",6)
	....s cardRuleDr=""
	....f  s cardRuleDr=$o(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)) q:cardRuleDr=""  d
	.....k PLIST
	.....s carItemDr=""
	.....s carItemDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",1)
	.....s deDeptDr=""
	.....s deDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",3)
	.....i carItemDr=itemDr d
	......i deDeptDr'=""  d
	.......;s PLIST(12)=deDeptDr         //卢晓春20110416屏蔽,某收入项为指定项目时，只把执行科室用指定科室替换
	.......s PLIST(15)=deDeptDr
	......&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	......i SQLCODE'=0 s Rs=SQLCODE
	
	..e  i cardingCode=ruleThree d
	...//w "rule3",!-01
	...s tmpIncomeDr=""
	...f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,tmpIncomeDr)) q:tmpIncomeDr=""  d
	....i $d(^DHCCAINCOMEDATAS(tmpIncomeDr)) d
	.....s servDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",deptType)
	.....s patDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",17) ///////////////////////////// by wyy
	....s cardRuleDr=""
	....f  s cardRuleDr=$o(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)) q:cardRuleDr=""  d
	.....k PLIST
	.....s srDeptDr=""
	.....s srDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",2)
	.....s deDeptDr=""
	.....s deDeptDr=$p($g(^DHCCAINDATACARDING(cardingDr,"Rule",cardRuleDr)),"^",3)
	.....i srDeptDr=servDeptDr d
	......s PLIST(deptType+1)=deDeptDr
	.....i srDeptDr=patDeptDr d ///////////////////////////// by wyy
	......s PLIST(18)=deDeptDr  ///////////////////////////// by wyy
	.....&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	.....i SQLCODE'=0 s Rs=SQLCODE

	i Rs'=0 TROLLBACK
	
	e  TCOMMIT
	
	//4.执行科室没在科室分层套的直接医疗类科室或医技类科室里；//转开单科室lxc20110417
	s tDept="" 
	s tDepts=""         
	s tDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s tDepts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s tDept= ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(5)
	s tDepts=tDepts_","_##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	
	
	s sqlStr="SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_tDeptDr not in("_tDepts_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_tDeptDr=incomedatas_fDeptDr where IncomeDatas_rowid=:rowid)	
	}
	q Rs
}
*/
Storage Default
{
<StreamLocation>^dhc.ca.c.uInDataCardRuleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
