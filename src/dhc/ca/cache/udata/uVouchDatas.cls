/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 凭证数据表维护
Class dhc.ca.cache.udata.uVouchDatas Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).InsertRec(1,"1","2","load","1","test",10,0)
ClassMethod InsertRec(intervalDr, deptDr, itemDr, inType, personDr, remark, debit, loans) As %String
{
	n (intervalDr, deptDr, itemDr, inType, personDr, remark, debit, loans)
	s inDate=+$h
	;&SQL(INSERT INTO dhc_ca_cache_data.VouchDatas (VouchDatas_intervalDr,VouchDatas_deptDr,VouchDatas_itemDr,VouchDatas_inType,VouchDatas_personDr,VouchDatas_remark,VouchDatas_dealFlag,VouchDatas_month,VouchDatas_num,VouchDatas_date,VouchDatas_abstract,VouchDatas_deptCode,VouchDatas_deptName,VouchDatas_subjCode,VouchDatas_subjName,VouchDatas_debit,VouchDatas_loans,VouchDatas_entryFlag) VALUES (:intervalDr, :deptDr, :itemDr, :inType, :personDr, :remark, :dealFlag, :month, :num, :inDate, :abstract, :deptCode, :deptName, :subjCode, :subjName, :debit, :loans, 'N'))
	//以上的SQL也能执行，待研究，简化如下，zjw  20160130
	&SQL(INSERT INTO dhc_ca_cache_data.VouchDatas (VouchDatas_intervalDr,VouchDatas_deptDr,VouchDatas_itemDr,VouchDatas_inType,VouchDatas_personDr,VouchDatas_remark,VouchDatas_date,VouchDatas_debit,VouchDatas_loans,VouchDatas_entryFlag) VALUES (:intervalDr, :deptDr, :itemDr, :inType, :personDr, :remark, :inDate, :debit, :loans, 'N'))
	
	q SQLCODE
}

/// Creator: zbp
/// CreatDate: 2013-09-25
/// Description: 更新记录
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: rowid-数据行号,deptCode-科室代码,deptName-科室名称,subjCode-科目代码,subjName-科目名称,remark-备注;debit-借方;loans-贷方,userDr-编辑人;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uVouchDatas).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, deptCode, deptName, subjCode, subjName, remark, debit, loans, userDr) As %String
{
                  
	n (rowid, deptCode, deptName,subjCode,subjName,remark,debit,loans, userDr)
    s editdate=$p($H,",",1)
    s PLIST(11)=editdate //编辑日期
    s PLIST(13)=deptCode
    s PLIST(14)=deptName
    s PLIST(15)=subjCode
    s PLIST(16)=subjName
    s PLIST(7)=remark
    s PLIST(17)=debit
    s PLIST(18)=loans
    s PLIST(6)=userDr
    s deptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation("1",deptCode,"")
    s PLIST(3)=deptDr
    s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation("1",subjCode)
    s PLIST(4)=itemDr
	&SQL(UPDATE dhc_ca_cache_data.VouchDatas VALUES PLIST() where %ID=:rowid)
	q SQLCODE
}

/// CreatDate: 2009-10-13
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串  ^^rowid^DESC^0^25^3^^^^
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).ListRec("","","rowid","DESC",0,25,3,"","","","")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, deptDr, itemDr, inType, personDr)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_intervalDr_"^"_deptDr_"^"_itemDr_"^"_inType_"^"_personDr
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, deptDr, itemDr, inType, personDr)
	
	s sqlStr="SELECT VouchDatas_rowid,VouchDatas_intervalDr,VouchDatas_deptDr,VouchDatas_itemDr,VouchDatas_inType,VouchDatas_personDr,VouchDatas_remark,VouchDatas_dealFlag,VouchDatas_month,VouchDatas_num,VouchDatas_date,VouchDatas_abstract,VouchDatas_deptCode,VouchDatas_deptName,VouchDatas_subjCode,VouchDatas_subjName,VouchDatas_debit,VouchDatas_loans FROM dhc_ca_cache_data.VouchDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND VouchDatas_intervalDr='"_intervalDr_"' "
	i deptDr'="" s whereStr=whereStr_"AND VouchDatas_deptDr='"_deptDr_"' "
	i itemDr'="" s whereStr=whereStr_"AND VouchDatas_itemDr='"_itemDr_"' "
	i inType'="" s whereStr=whereStr_"AND VouchDatas_inType='"_inType_"' "
	i personDr'="" s whereStr=whereStr_"AND VouchDatas_personDr='"_personDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="VouchDatas_rowid"
	.i sortField="tDeptName" s sortField1="VouchDatas_deptDr"
	.i sortField="itemName" s sortField1="VouchDatas_itemDr"
	.i sortField="inType" s sortField1="VouchDatas_inType"
	.i sortField="personName" s sortField1="VouchDatas_personDr"
	.i sortField="remark" s sortField1="VouchDatas_remark"
	
	.i sortField="nDate" s sortField1="VouchDatas_date"
	.i sortField="num" s sortField1="VouchDatas_num"
	.i sortField="abstract" s sortField1="VouchDatas_abstract"
	.i sortField="deptCode" s sortField1="VouchDatas_deptCode"
	.i sortField="deptName" s sortField1="VouchDatas_deptName"
	.i sortField="subjCode" s sortField1="VouchDatas_subjCode"
	.i sortField="subjName" s sortField1="VouchDatas_subjName"
	.i sortField="debit" s sortField1="VouchDatas_debit"
	.i sortField="loans" s sortField1="VouchDatas_loans"
	.i sortField="dealFlag" s sortField1="VouchDatas_dealFlag"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^intervalDr^intervalName^deptDr^tDeptName^unitDr^unitName^unitTypeDr^unitTypeName^unitDr^itemDr^itemName^inType^personDr^personName^remark^dealFlag^month^num^nDate^abstract^deptCode^deptName^subjCode^subjName^debit^loans"
	
	While(result.Next())
	{
		s rowid=result.Data("VouchDatas_rowid")
		s intervalDr=result.Data("VouchDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s deptDr=result.Data("VouchDatas_deptDr")
		s tDeptName=""
		s unitDr=""
		s unitName=""
		s unitTypeDr=""
		s unitTypeName=""
		i deptDr'="" d
		.s tDeptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.s unitDr=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",8)
		.i unitDr'="" d
		..s unitName=$p($g(^DHCCAUNITS(unitDr)),"^",2)
		..s unitTypeDr=$p($g(^DHCCAUNITS(unitDr)),"^",8)
		..i unitTypeDr'="" d
		...s unitTypeName=$p($g(^DHCCAUNITTYPES(unitTypeDr)),"^",2)
		
		s itemDr=result.Data("VouchDatas_itemDr")
		s itemName="" 
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s inType=result.Data("VouchDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="EXCEL上传"
		i inType="P"   s inType="药品导入"
        i inType="M"   s inType="物资导入"	
        i inType="divide" s inType="拆分导入"	
		s personDr=result.Data("VouchDatas_personDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("VouchDatas_remark")

		s dealFlag=result.Data("VouchDatas_dealFlag")
		s month=result.Data("VouchDatas_month")
		s num=result.Data("VouchDatas_num")
		s date=result.Data("VouchDatas_date")
		i date'="" d
		.s date=$zd(date,3)
		s abstract=result.Data("VouchDatas_abstract")
		s deptCode=result.Data("VouchDatas_deptCode")
		s deptName=result.Data("VouchDatas_deptName")
		
		s subjCode=result.Data("VouchDatas_subjCode")
		s subjName=result.Data("VouchDatas_subjName")
		s debit=result.Data("VouchDatas_debit")
		s loans=result.Data("VouchDatas_loans")

		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_deptDr_"^"_tDeptName_"^"_unitDr_"^"_unitName_"^"_unitTypeDr_"^"_unitTypeName_"^"_unitDr_"^"_itemDr_"^"_itemName_"^"_inType_"^"_personDr_"^"_personName_"^"_remark_"^"_dealFlag_"^"_month_"^"_num_"^"_date_"^"_abstract_"^"_deptCode_"^"_deptName_"^"_subjCode_"^"_subjName_"^"_debit_"^"_loans
		
		i searchValue'="" d
		.q:(searchField="tDeptName")&(tDeptName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="inType")&(inType'[searchValue)
		.q:(searchField="personName")&(personName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="num")&(num'[searchValue)
		.q:(searchField="abstract")&(abstract'[searchValue)
		.q:(searchField="deptCode")&(deptCode'[searchValue)
		.q:(searchField="deptName")&(deptName'[searchValue)
		.q:(searchField="subjCode")&(subjCode'[searchValue)
		.q:(searchField="subjName")&(subjName'[searchValue)
		.q:(searchField="debit")&(debit'[searchValue)
		.q:(searchField="loans")&(loans'[searchValue)
		.q:(searchField="date")&(date'[searchValue)
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
/// CreatDate: 2009-10-13
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).CheckUser(1)
ClassMethod CheckUser(userCode) As %String
{
	n (userCode)
	
	q:userCode="" 0
	s userDr =0
	s userDr=$o(^DHCCAUNITPERSONS(0,"Code", userCode, userDr))
	s flag="N"
	i userDr>0 d
	.s flag=$p($g(^DHCCAUNITPERSONS(userDr)),"^",18)
	i flag="" s flag="N"
	i flag="N" s userDr=0
	q userDr
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.VouchDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.Users).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
   
   q:rowid="" 

   s dealFlag=$p(^DHCCAVOUCHDATAS(rowid),"^",7)
   q:dealFlag="Y" "数据已处理，无法删除!"
   &SQL(DELETE FROM dhc_ca_cache_data.VouchDatas WHERE %ID=:rowid)
   q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-11-10
/// Description: 返回当前日期是否在指定核算区间内
/// Table：dhc.ca.cache.data.VouchDatas
/// Input：monthID-核算月ID
/// Output：
/// Return：Y-是,N-否
/// Others：
ClassMethod getDayActive(monthID) As %String
{
	q:monthID="" "N"
	
	n (monthID)
	
	s result="N"
	s today=$p($h,",",1)
	
	i $d(monthID) d
	.s startDay=$p(^DHCCAACCOUNTMONTHS(monthID),"^",4)
	.s endDay=$p(^DHCCAACCOUNTMONTHS(monthID),"^",5)
	.i (today>=startDay)&&(today<=endDay) d
	..s result="Y"
	
	q result
}

/// Creator: 杨旭
/// CreatDate: 2010-3-4
/// Description: 刷新对应数据的部门与项目
/// Table: dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间;deptSetDr-部门接口套ID;dataTypeDr-业务类别ID;
/// Output: 
/// Return: 0为成功
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).RefreshRec(3,1)
ClassMethod RefreshRec(intervalDr, deptSetDr) As %String
{
	
	n (intervalDr,deptSetDr)
	TSTART
	s flag=0
	
	s sqlStr="SELECT VouchDatas_rowid,VouchDatas_intervalDr,VouchDatas_deptDr,VouchDatas_itemDr,VouchDatas_inType,VouchDatas_personDr,VouchDatas_remark,VouchDatas_dealFlag,VouchDatas_month,VouchDatas_num,VouchDatas_date,VouchDatas_abstract,VouchDatas_deptCode,VouchDatas_deptName,VouchDatas_PatWardCode,VouchDatas_PatWardName,VouchDatas_PatDocCode,VouchDatas_PatDocName,VouchDatas_subjCode,VouchDatas_subjName,VouchDatas_debit,VouchDatas_loans FROM dhc_ca_cache_data.VouchDatas"
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND VouchDatas_intervalDr='"_intervalDr_"' "
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("VouchDatas_rowid")
		s itemCode=result.Data("VouchDatas_subjCode") q:itemCode=""
		
		s patType=""

	    S itemSetDr=1   //成本项目分类
	  
		i (itemCode'="") s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
		;i (itemCode'="") s itemDr=..ItemRelation(itemTypeDr,itemCode)
		i itemDr'="" s PLIST(4)=itemDr  
				
		s fDeptCode=""
		s fDeptDr=""
		s fDeptCode=result.Data("VouchDatas_deptCode")
          
		i (fDeptCode'="")&(deptSetDr'="") d
		.s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
		i (fDeptCode'="")&(deptSetDr="") d
		.s fDeptDr=##class(dhc.ca.cache.udata.uOtherData).GetDept(fDeptCode)
		i fDeptDr'="" s PLIST(3)=fDeptDr
		
		s PatWardCode=""
		s PatWardDr=""
		s PatWardCode=result.Data("VouchDatas_PatWardCode")
		
		i PatWardCode'="" s PatWardDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,PatWardCode,patType)
		i PatWardDr'="" s PLIST(22)=PatWardDr
		
	    s PatDocCode=""
		s PatDocDr=""
		s PatDocCode=result.Data("VouchDatas_PatDocCode")
		
		i PatDocCode'=""  s PatDocDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,PatDocCode,patType)
		i PatDocDr'="" s PLIST(25)=PatDocDr
				
		&SQL(UPDATE dhc_ca_cache_data.VouchDatas VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 s flag=SQLCODE
	}
	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q flag
}

/// Creator：杨旭
/// CreatDate：2010-01-5
/// Description: 按业务项类别对照项目
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：TypeItemDr-业务项类别;ItemCode-需要对照的业务项CODE
/// Output：
/// Return：Y-是,N-否
/// Others：w ##class(dhc.ca.cache.udata.uIncomeDatas).ItemRelation(7,"233")
ClassMethod ItemRelation(TypeItemDr, ItemCode) As %String
{
	q:TypeItemDr="" ""
	q:ItemCode="" ""
	n (TypeItemDr,ItemCode)
	s Rs=""
	s tmpItemDr=""
	f  s tmpItemDr=$o(^DHCCADATAITEMCORRES(0,"TypeItem",TypeItemDr,tmpItemDr)) q:(tmpItemDr="")!(Rs'="")  d
	.s tmpItemCode=$p($g(^DHCCAALLDATAITEMS(tmpItemDr)),"^",2)
	.i tmpItemCode=ItemCode s Rs=tmpItemDr
	q Rs
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 删除记录
/// Table: dhc.ca.cache.data.BaseData
/// Input：intervalDr-月份
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).DelRec(3)
ClassMethod DelAllRec(intervalDr) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.VouchDatas WHERE VouchDatas_intervalDr=:intervalDr )  //and (VouchDatas_itemdr!='124' and VouchDatas_itemdr!='125' and VouchDatas_itemdr!='126') and vouchdatas_intype is null)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 删除记录
/// Table: dhc.ca.cache.data.BaseData
/// Input：remark-备注
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).DelRec(3)
ClassMethod DelRecByRemark(remark) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.VouchDatas WHERE VouchDatas_remark=:remark)
	q SQLCODE
}

/// Creator：zbp
/// CreatDate：2013-09-24
/// Description: 检测是否已导入数据
/// Table：dhc.ca.cache.data.vouchdatas
/// Input：intervalDr-核算月ID
/// Output：
/// Return：0-不存在,非0-存在
/// Others：w ##class(dhc.ca.cache.udata.uVouchDatas).CheckRec(5,"M")
ClassMethod CheckRec(intervalDr, type) As %String
{
	q:intervalDr="" "N"
	
	n (intervalDr,type)
	s result=0

	s rowId=0 f  s rowId=$o(^DHCCAVOUCHDATAS(0,"Interval",intervalDr,rowId)) q:rowId=""  d 
	.s intype=$p(^DHCCAVOUCHDATAS(rowId),"^",4)
	.i type=intype  s result=rowId
	q result
}

/// Creator: zjw
/// CreatDate: 2015-05-06
/// Description: 查询符合条件的记录
/// Table: dhc_ca_cache_data.VouchDatas 
/// Input: Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串start=0&limit=25&monthDr=1
/// Others:w ##class(dhc.ca.cache.udata.uVouchDatas).listCost(1,0,25)
ClassMethod listCost(intervalDr, start, limit)
{
	;q intervalDr_"^"_start_"^"_limit
	n (intervalDr, start, limit)
	

	s sqlStr="SELECT VouchDatas_inType,count(VouchDatas_rowid) as counts,sum(VouchDatas_debit) as fees FROM dhc_ca_cache_data.VouchDatas "
			_" WHERE  VouchDatas_intervalDr='"_intervalDr_"'"_" GROUP BY VouchDatas_inType"
			_"	UNION SELECT  'all', count(VouchDatas_rowid) as counts, sum(VouchDatas_debit) as fees FROM dhc_ca_cache_data.VouchDatas "
			_"	WHERE  VouchDatas_intervalDr='"_intervalDr_"'"_" GROUP BY VouchDatas_intervalDr"
	
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
   
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="patType^counts^fees"
	
	While(result.Next())
	{
		s patType=result.Data("VouchDatas_inType")
		i patType="input" s patType="录入"
		i patType="load" s patType="上传"
		i patType="all" s patType="总计"
		s counts=result.Data("counts")
		s fees=result.Data("fees")
		s fees=$Num(fees,2)
		
		s tmp=patType_"^"_counts_"^"_fees
		
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uVouchDatasS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
