/// Class dhc.bonus.usubs.uExpendCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
Class dhc.bonus.usubs.uExpendCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-6-11
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_subs.BonusSubExpendCollect
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).ListRec("","5","","","","",0,25,"2013","03","M","11")
ClassMethod ListRec(InterLocSetDr, InterMethodDr, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency, UnitField = "") As %String
{
		n (InterLocSetDr,InterMethodDr,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency,UnitField)
			
		s sqlStr="select BonusSubExpendCollectID,ExpendItemCode, ExpenItemName , BonusUnitCode, BonusUnitName ,BonusYear, BonusPeriod ,ExecuteDeptCode,"
				_" ExecuteDeptName, CalculateUnit ,  ItemValue ,InterLocMethodID, CollectDate,State "
				_" ,InterLocMethodID->InterLocMethod_methodDesc,InterLocMethodID->InterLocSet_rowid,InterLocMethodID->InterLocSet_rowid->InterLocSet_name "
				_" ,UnitType,DataUpDate "
 				_" FROM dhc_bonus_subs.BonusSubExpendCollect "
				_" where BonusUnitName <> '' and  ExpenItemName <> '' and InterLocMethodID->InterLocSet_rowid='"_InterLocSetDr_"'and BonusYear='"_CycleDr_"' and BonusPeriod='"_frequency_period_"'" 
		i UnitField'=""
		.s sqlStr=sqlStr_"and BonusUnitName='"_UnitField_"'"
		i InterMethodDr'="" d
		.s sqlStr =sqlStr_" and InterLocMethodID= "_InterMethodDr

 		
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusSubExpendCollectID"
		.i sortField="ExpendItemCode" s sortField1="ExpendItemCode"
		.i sortField="ExpenItemName" s sortField1="ExpenItemName"
		.i sortField="BonusYear" s sortField1="BonusYear"
		.i sortField="BonusPeriod" s sortField1="BonusPeriod"
		
		.i sortField="BonusUnitCode" s sortField1="BonusUnitCode"
		.i sortField="BonusUnitName" s sortField1="BonusUnitName"
		.i sortField="ExecuteDeptCode" s sortField1="ExecuteDeptCode"
		.i sortField="ExecuteDeptName" s sortField1="ExecuteDeptName"
		
		.i sortField="CalculateUnit" s sortField1="CalculateUnit"
		.i sortField="ItemValue" s sortField1="ItemValue"
		
		.i sortField="CollectDate" s sortField1="CollectDate"
		.i sortField="State" s sortField1="State"

		.i sortField="methodDesc" s sortField1="InterLocMethodID->InterLocMethod_methodDesc"
		.i sortField="InterLocSetname" s sortField1="InterLocMethodID->InterLocSet_rowid->InterLocSet_name"
		.i sortField="UnitType" s sortField1="UnitType"
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		
		s sqlStr=sqlStr_sortStr
		
	
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
			
		s json=##class(dhc.bonus.comm.JsonObj).%New()
		
		s jsonTitle="rowid^ExpendItemCode^ExpenItemName^BonusYear^BonusPeriod^BonusUnitCode^BonusUnitName^ExecuteDeptCode^ExecuteDeptName^"
			_"CalculateUnit^ItemValue^CollectDate^State^InterLocMethodID^methodDesc^InterLocSetname^UnitType^periodType^InterLocSetID^DataUpDate"

		
		While(result.Next())
		{
			s rowid=result.Data("BonusSubExpendCollectID")
          
            s methodDesc = result.Data("InterLocMethod_methodDesc")
            s InterLocSetname = result.Data("InterLocSet_name")
       		s InterLocSetID = result.Data("InterLocSet_rowid")
            
			s ExpendItemCode     =result.Data("ExpendItemCode")    
			s ExpenItemName     =result.Data("ExpenItemName")    
			s BonusYear          =result.Data("BonusYear")         
			s BonusPeriod        =result.Data("BonusPeriod")       
			s BonusUnitCode   =result.Data("BonusUnitCode")  
			s BonusUnitName   =result.Data("BonusUnitName")
			continue:(UnitField'="")&&(BonusUnitName'=UnitField)
			s UnitType = result.Data("UnitType")
			s sUnitType=""
			i UnitType=1 s sUnitType="开单收入"
			i UnitType=2 s sUnitType="执行收入"
			i UnitType=3 s sUnitType="开单执行"
			i UnitType=4 s sUnitType="工作量"
			i UnitType=5 s sUnitType="支出数据"
			
			
			s ExecuteDeptCode    =result.Data("ExecuteDeptCode")
			s ExecuteDeptName    =result.Data("ExecuteDeptName")
	        s DataUpDate    =result.Data("DataUpDate")
			s CalculateUnit       =result.Data("CalculateUnit")      
			s ItemValue       =result.Data("ItemValue")
			     
			s ItemValue=$fn(ItemValue,",",2) 
			
			s InterLocMethodID    =result.Data("InterLocMethodID")  
			s CollectDate    =result.Data("CollectDate")  
			s State  = result.Data("State")  
			
			
			i State=0 s State="采集完成"
			i State=1 s State="上传完成"
			;i State=2 s State="手工录入"
			;i State=3 s State="手工修改"
			
			s ptype =$E(BonusPeriod,1,1)
		
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s BonusPeriod =$E(BonusPeriod,2,10)

			s tmp=rowid_"^"_ExpendItemCode_"^"_ExpenItemName_"^"_BonusYear_"^"_BonusPeriod_"^"_BonusUnitCode_"^"_BonusUnitName_"^"_ExecuteDeptCode_"^"_ExecuteDeptName_"^"
			_CalculateUnit_"^"_ItemValue_"^"_CollectDate_"^"_State_"^"_InterLocMethodID_"^"_methodDesc_"^"_InterLocSetname_"^"_sUnitType_"^"_ptype_"^"_InterLocSetID_"^"_DataUpDate
			
			
			s count=count+1
			
		
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
			
		}
		
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// w ##class(dhc.bonus.usubs.uExpendCollect).Delete("2011","M02","",14)
ClassMethod Delete(BonusYear, BonusPeriod, LocSetrowid, MethodID) As %String
{
	i MethodID'="" d
	.&sql(delete FROM dhc_bonus_subs.BonusSubExpendCollect where InterLocMethodID=:MethodID and BonusYear =:BonusYear and BonusPeriod =:BonusPeriod  and InterLocMethodID->InterLocSet_rowid=:LocSetrowid)
	e  d
	.&sql(delete FROM dhc_bonus_subs.BonusSubExpendCollect where  BonusYear =:BonusYear and BonusPeriod =:BonusPeriod  and InterLocMethodID->InterLocSet_rowid=:LocSetrowid)

	
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uExpendCollect).Delete("2011","M02","",14)
ClassMethod DeleteByID(rowID) As %String
{
	n (rowID)
	&sql(delete FROM dhc_bonus_subs.BonusSubExpendCollect where %ID=:rowID)

	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-8-30
/// Description: 收入数据采集导入
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input:sYear_核算年度,sPeriod_核算期间,sInterMethodID_核算方法ID, globalNode_Golbal节点标识
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).InsertSubExpendData(4,"expend")
ClassMethod InsertSubExpendData(sYear, sPeriod, LocSetrowID, sInterMethodID, globalNode)
{
	n (sYear,sPeriod,LocSetrowID,sInterMethodID,globalNode)

	k ^dhcbsSubExpendDataTemp(_globalNode) 
	//"1020^检查^320^内科^2011^M01^101^BBB^102^199^188^777^66"
	//^dhcbsSubExpendDataTemp=指标编码^指标名称^科室编码^科室名称^核算年^核算月^执行科编码^执行科名称^单位^数值^科室类别^
	s updateflag=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	s rtnState=0
	s rowid=""
	TSTART
	//插入数据前先删除
	d ..Delete(sYear,sPeriod,LocSetrowID,sInterMethodID)
	f  s rowid=$O(^dhcbsSubExpendDataTemp(globalNode,rowid)) q:((rowid="") || (rtnState>0))  d
	.s ExpendItemCode=$P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",1) //数据状态
	.s ExpenItemName= $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",2)
	.s BonusUnitCode=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",3)
	.s BonusUnitName=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",4)
	.s BonusYear=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",5)
	.s BonusPeriod=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",6)
	.s ExecuteDeptCode=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",7)
	.s ExecuteDeptName=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",8)
	.s CalculateUnit=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",9)
	.s ItemValue=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",10)
	.s State=  1
	.s InterLocMethodID= sInterMethodID
	.s UpdateDate= updateflag

	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ExecuteDeptCode,ExecuteDeptName,CalculateUnit,ItemValue,InterLocMethodID,CollectDate,State) values(:ExpendItemCode,:ExpenItemName,:BonusUnitCode,:BonusUnitName,:BonusYear,:BonusPeriod,:ExecuteDeptCode,:ExecuteDeptName,:CalculateUnit,:ItemValue,:InterLocMethodID,:UpdateDate,:State))
	.s rtnState= SQLCODE
	;q:rtn'=0 1

	i rtnState>0 d
	.TRollBack
	e  d
	.TCOMMIT
	;k ^dhcbsSubExpendDataTemp(_globalNode) 
	
	q rtnState
	
GetLogError
  	TRollBack
  	;k ^dhcbsSubExpendDataTemp(_globalNode) 
	q 1
}

//				ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,CalculateUnit,ItemValue,InterLocMethodID

/// w ##class(dhc.bonus.usubs.uExpendCollect).Delete("2011","M02","",14)
ClassMethod IfExistData(BonusYear, BonusPeriod, LocMethodID, UnitCode, ItemCod, UnitType) As %String
{
		//LocMethodID,UnitCode,ItemCod,UnitType
		s sqlstr="SELECT %ID rowID FROM dhc_bonus_subs.BonusSubExpendCollect"
		 _" where BonusYear ='"_BonusYear_"' and BonusPeriod ='"_BonusPeriod_"' and InterLocMethodID='"_LocMethodID_"'"
		 _" and  BonusUnitCode='"_UnitCode_"' and ExpendItemCode='"_ItemCod_"' and UnitType ='"_UnitType_"'"
		
		//w sqlstr,!
		s ^zlgtemp= sqlstr
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlstr)
		d result.Execute()
		s rowid=-1
		
		While(result.Next())
		{
			s rowid=result.Data("rowID")
		}
		q rowid
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-10-26
/// Description: 支出数据录入
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input: sData =指标编码^指标名称^科室编码^科室名称^核算年^核算月^单位^数值^接口方法^
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).Insert("HG000261^HG000261_SJ液体石蜡 北京^516^检验科__尿常规^2014^M01^人^55^1^2")
ClassMethod Insert(sData)
{
	n (sData)

	s updateflag=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	;s ^zlgtemp=sData
	
	//插入数据前先删除
	;d ..Delete(sYear,sPeriod,LocSetrowID,sInterMethodID)
	/***
	20140926为解决“奖金核算系统-奖金数据采集-奖金数据采集-添加数据时，
	系统提示添加成功，但查询时，无法查出该数据” 修改	
	s ExpenItemName = $P(sData,"^",2)
	s BonusUnitCode =$P($P(sData,"^",4),"_",1)  
	s BonusUnitName = $P($P(sData,"^",4),"_",2)
	为下面代码，并修改s State=  1为s State=  0因为数据页面显示状态不对。
	刘小伟
	***/
  
	s ExpendItemCode= $P(sData,"^",1) //数据状态
	s ExpenItemName = $p($P(sData,"^",2),"_",2)
	s BonusUnitCode = $P(sData,"^",3)   
	s BonusUnitName = $P($P(sData,"^",4),"__",2)
	 
	s BonusYear  = $P(sData,"^",5)
	s BonusPeriod= $P(sData,"^",6)
	;s ExecuteDeptCode= null
	;s ExecuteDeptName= null
	s CalculateUnit=  $P(sData,"^",7)
	s ItemValue    =  $P(sData,"^",8)
	s State=  0
	s InterLocMethodID= $P(sData,"^",9)
	s UnitType= $P(sData,"^",10)
	
	s UpdateDate= updateflag

	//IfExistData(BonusYear,BonusPeriod,LocMethodID,UnitCode,ItemCod,UnitType) As %String
	s rowid= ..IfExistData(BonusYear,BonusPeriod,InterLocMethodID,BonusUnitCode,ExpendItemCode,UnitType)
	q:rowid>0 "RecordExist"
	
	&sql(insert into dhc_bonus_subs.BonusSubExpendCollect (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,CalculateUnit,ItemValue,InterLocMethodID,CollectDate,State,UnitType) values(:ExpendItemCode,:ExpenItemName,:BonusUnitCode,:BonusUnitName,:BonusYear,:BonusPeriod,:CalculateUnit,:ItemValue,:InterLocMethodID,:UpdateDate,:State,:UnitType))
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-10-26
/// Description: 支出数据录入
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input: sData =指标编码^指标名称^科室编码^科室名称^核算年^核算月^单位^数值^接口方法^
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).Update("zc26^供暖费^4^0102_胸外科^2011^01^分^4433^4")
ClassMethod Update(rowid, sData)
{
	n (rowid,sData)
	s updateflag=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)
	
	s ExpendItemCode=$P(sData,"^",1) //数据状态
	s ExpenItemName= $P(sData,"^",2)
	s BonusUnitCode=  $P($P(sData,"^",4),"_",1)
	s BonusUnitName= $P($P(sData,"^",4),"_",2)
	
	s BonusYear=  $P(sData,"^",5)
	s BonusPeriod=  $P(sData,"^",6)
	;s ExecuteDeptCode= null
	;s ExecuteDeptName= null
	s CalculateUnit=  $P(sData,"^",7)
	s ItemValue=  $P(sData,"^",8)
	s State=  3
	s InterLocMethodID= $P(sData,"^",9)
	s UpdateDate= updateflag
	s UnitType= $P(sData,"^",10)

	&sql(update dhc_bonus_subs.BonusSubExpendCollect set ExpendItemCode=:ExpendItemCode,ExpenItemName=:ExpenItemName,BonusUnitCode=:BonusUnitCode,BonusUnitName=:BonusUnitName,BonusYear=:BonusYear	,BonusPeriod=:BonusPeriod,CalculateUnit=:CalculateUnit,ItemValue=:ItemValue,InterLocMethodID=:InterLocMethodID,CollectDate=:UpdateDate,State=:State,UnitType=:UnitType where %ID=:rowid) 
	q SQLCODE
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-10-11
/// Description: 工作量数据采集导入——中医院
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input:sYear_核算年度,sPeriod_核算期间,sInterMethodID_核算方法ID, globalNode_Golbal节点标识
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).InsertSubExpendData(4,"expend")
ClassMethod InsertSubExpendDataZyy(sYear, sPeriod, LocSetrowID, sInterMethodID, globalNode)
{
	n (sYear,sPeriod,LocSetrowID,sInterMethodID,globalNode)

	k ^dhcbsSubExpendDataTemp(_globalNode) 

	//^dhcbsSubExpendDataTemp=指标编码^指标名称^科室编码^科室名称^核算年^核算月^执行科编码^执行科名称^单位^数值^科室类别^
	//^dhcbsSubExpendDataTemp("WorkScore",2192)="23204^Y80706001^8^Rec"
	
	s globalNode="WorkScore"
	s updateflag=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	s rtnState=0
	s rowid=""
	TSTART
	//插入数据前先删除
	d ..Delete(sYear,sPeriod,LocSetrowID,sInterMethodID)
	f  s rowid=$O(^dhcbsSubExpendDataTemp(globalNode,rowid)) q:((rowid="") || (rtnState>0))  d
	.s ExpendItemCode=$P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",1) //数据状态
	.s ExpenItemName= $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",2)
	.s BonusUnitCode=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",3)
	.s BonusUnitName=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",4)
	.s BonusYear=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",5)
	.s BonusPeriod=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",6)
	.s ExecuteDeptCode=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",7)
	.s ExecuteDeptName=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",8)
	.s CalculateUnit=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",9)
	.s ItemValue=  $P(^dhcbsSubExpendDataTemp(globalNode,rowid),"^",10)
	.s State=  0
	.s InterLocMethodID= sInterMethodID
	.s UpdateDate= updateflag

	.&sql(insert into dhc_bonus_subs.BonusSubExpendCollect (ExpendItemCode,ExpenItemName,BonusUnitCode,BonusUnitName,BonusYear,BonusPeriod,ExecuteDeptCode,ExecuteDeptName,CalculateUnit,ItemValue,InterLocMethodID,CollectDate,State) values(:ExpendItemCode,:ExpenItemName,:BonusUnitCode,:BonusUnitName,:BonusYear,:BonusPeriod,:ExecuteDeptCode,:ExecuteDeptName,:CalculateUnit,:ItemValue,:InterLocMethodID,:UpdateDate,:State))
	.s rtnState= SQLCODE
	;q:rtn'=0 1

	i rtnState>0 d
	.TRollBack
	e  d
	.TCOMMIT
	;k ^dhcbsSubExpendDataTemp(_globalNode) 
	
	q rtnState
	
GetLogError1
  	TRollBack
  	;k ^dhcbsSubExpendDataTemp(_globalNode) 
	q 1
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-4-14
/// Description: 奖金系统数据采集接口
/// Table：
/// Input:sYear_核算年度, sPeriod_核算期间, InterLocSetDr_接口方法套ID, InterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).DataCollectMain("2014","01",1)
ClassMethod DataCollectMain(sYear, sPeriod, LocMethodDr)
{
	n (sYear, sPeriod,LocMethodDr)
	d ##class(dhc.bonus.uinter.uInterMain).InterMain(sYear, sPeriod,LocMethodDr)
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-8-31
/// Description: 奖金系统数据采集接口
/// Table：
/// Input:sYear_核算年度, sPeriod_核算期间, InterLocSetDr_接口方法套ID, InterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).ExpendInterMain("2011","M04",5,"")
ClassMethod ExpendInterMain(sYear, sPeriod, InterLocSetDr, InterLocMethodDr)
{
	n (sYear, sPeriod, InterLocSetDr,InterLocMethodDr)
	
	s updateflag=$p($h,",",1)_"_"_$p($h,",",2)
	
	s sqlStr="SELECT * FROM dhc_bonus_inter.InterLocMethod"_
	" WHERE %ID>0 AND InterLocSet_rowid="_InterLocSetDr_" and InterLocMethod_active='Y'"
	i InterLocMethodDr'="" d
	 .s sqlStr = sqlStr_" and InterLocMethod_rowid="_InterLocMethodDr
	s sqlStr = sqlStr_"order by InterLocMethod_order" 
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("InterLocMethod_rowid")
		s methodName = result.Data("InterLocMethod_methodName")
		s globalType = result.Data("InterLocMethod_ReturnType")
		
		s tempGloble = result.Data("InterLocMethod_ReturnName")
		k ^dhcbsSubExpendDataTemp(tempGloble)
	
		//获取接口方法参数
		s sPamaName = ##class(dhc.bonus.udata.uInterMain).GetInterMethodParam(sYear, sPeriod,rowid)
			
		//得到接口方法并执行	
		s classMethodName=methodName_sPamaName
		//w "classMethodName:"_classMethodName,!
		d @classMethodName
		d ..InsertSubExpendData(sYear, sPeriod,InterLocSetDr,rowid,tempGloble)
		
		//当Global中无数据时，将不对其进行取数操作。
		//s sparam = rowid_"^"_sYear_"^"_sPeriod_"^"_updateflag
		//s rtn= ..DeleteCollectTempData(rowid,sYear,sPeriod)
		//对Global取数处理

		
	}
		d result.Close()
	
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2013-4-14
/// Description: 医务收入数据上传
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input: sData =
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).InterDataUp("2014","M02","1")
/// Others: w ##class(dhc.bonus.usubs.uExpendCollect).InterDataUp("2014","M02","1")
ClassMethod InterDataUp(sYear, sMonth, MethodID)
{
	n (sYear,sMonth,MethodID)

	&sql(delete from dhc_bonus_data.BonusTargetCollect where InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth)

	
	i (MethodID=1) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'ywsrDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
	where a.ExpendItemCode=b.BonusTargetCode and 'H'||a.BonusUnitCode =c.BonusUnitCode AND c.BonusUnitTypeID=3 
	and   InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth
	group by BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource
	)
	
	//科室支出数据上传
	i (MethodID=3) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'ywsrDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c,dhc_bonus_subs.BonusSubItem d
	where  b.BonusTargetCode in ('04010','04020','04030','04040','04050','04090')
 	and a.BonusUnitCode =c.BonusUnitCode and SuperiorUnitID>0
 	and a.ExpendItemCode=d.SubItemCode
 	and d.SuperiorItemID->SubItemCode = b.BonusTargetCode
	and   InterLocMethodID=:MethodID and BonusYear=:sYear and BonusPeriod=:sMonth
	group by SuperiorUnitID,BonusTargetID,InterLocMethodID,BonusYear,BonusPeriod, DataSource
	)
	
	//挂号数据上传
	/*i (MethodID=4) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'regDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
	where  b.BonusTargetCode ="02020"
 	and a.BonusUnitCode =c.BonusUnitCode and SuperiorUnitID>0
 	and a.ExpendItemCode=b.BonusTargetCode
	and   InterLocMethodID=:MethodID and BonusYear=:sYear and BonusPeriod=:sMonth
	group by c.SuperiorUnitID,b.BonusTargetID,a.InterLocMethodID,a.BonusYear,a.BonusPeriod
	)*/
	
	//门诊人次
	i (MethodID=5 ) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'ywsrDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
	where a.ExpendItemCode=b.BonusTargetCode and 'H'||a.BonusUnitCode =c.BonusUnitCode and b.BonusTargetCode in ('05010')
	and   InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth
	group by BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource
	)
	
	// 期内入院人数,出院人数总计,实际开放总床日数,实际占用总床日数,出院者占用总床日数
	
	i (MethodID=6 ) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'ywsrDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
	where a.ExpendItemCode=b.BonusTargetCode and 'H'||a.BonusUnitCode =c.BonusUnitCode and b.BonusTargetCode in ('05020','05040','05050','05051','05052','05010')
	and   InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth
	group by BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource
	)
	
	//绩效考核分上传
	i (MethodID=7 ) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,ItemValue TargetValue,getDate() UpdateDate,'ywsrDept' Remark
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
	where a.ExpendItemCode=b.BonusTargetCode and a.BonusUnitCode =c.BonusUnitCode and b.BonusTargetCode in ('01050')
	and   InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth)
	
	//按医生统计挂号数据上传
	i (MethodID=8) d
	.&sql(insert into dhc_bonus_data.BonusTargetCollect(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,TargetValue, UpdateDate, Remark)
	select BonusTargetID, SuperiorUnitID,InterLocMethodID,BonusYear,BonusPeriod, DataSource,sum(ItemValue) TargetValue,getDate() UpdateDate,'regDept' Remark
    from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusTarget b ,dhc_bonus_data.BonusUnit c
    where  b.BonusTargetCode ="02020"
    and a.ExecuteDeptCode =c.BonusUnitCode and SuperiorUnitID>0
    and a.ExpendItemCode=b.BonusTargetCode
    and   InterLocMethodID=:MethodID and BonusYear=:sYear and BonusPeriod=:sMonth and a.BonusUnitCode is not null and a.BonusUnitName is not null
    group by c.SuperiorUnitID,b.BonusTargetID,a.InterLocMethodID,a.BonusYear,a.BonusPeriod
    )
    i (MethodID=9) d
    .&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,DataSource,TargetValue,UpdateDate,Remark)
	select c.BonusTargetID,b.SuperiorUnitID,a.InterLocMethodID,a.BonusYear,a.BonusPeriod,1 DataSource,sum(a.ItemValue),getDate(),'tjzxDept'
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusTarget c
	where a.BonusUnitCode=b.BonusUnitCode and a.InterLocMethodID=:MethodID and a.BonusYear=:sYear
	and a.BonusPeriod=:sMonth and a.ExpendItemCode=c.BonusTargetCode and a.ExpendItemCode='06010'
	group by b.SuperiorUnitID,a.BonusPeriod	
    )
    .&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,DataSource,TargetValue,UpdateDate,Remark)
	select c.BonusTargetID,58,a.InterLocMethodID,a.BonusYear,a.BonusPeriod,1 DataSource,sum(a.ItemValue),getDate(),'tjkdDept'
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusTarget c
	where a.BonusUnitCode=b.BonusUnitCode and a.InterLocMethodID=:MethodID and a.BonusYear=:sYear
	and a.BonusPeriod=:sMonth and a.ExpendItemCode=c.BonusTargetCode and a.ExpendItemCode='06011'
	group by 58,a.BonusPeriod	
    )
    .&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,DataSource,TargetValue,UpdateDate,Remark)
	select c.BonusTargetID,b.SuperiorUnitID,a.InterLocMethodID,a.BonusYear,a.BonusPeriod,1 DataSource,sum(a.ItemValue),getDate(),'tjzxDept'
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusTarget c
	where a.BonusUnitCode=b.BonusUnitCode and a.InterLocMethodID=:MethodID and a.BonusYear=:sYear
	and a.BonusPeriod=:sMonth and a.ExpendItemCode=c.BonusTargetCode and a.ExpendItemCode='06013'
	group by b.SuperiorUnitID,a.BonusPeriod	
    )
    .&sql(insert into dhc_bonus_data.BonusTargetCollect
	(BonusTargetID,BonusUnitID,InterLocMethodID,BonusYear,BonusPeriod,DataSource,TargetValue,UpdateDate,Remark)
	select c.BonusTargetID,58,a.InterLocMethodID,a.BonusYear,a.BonusPeriod,1 DataSource,sum(a.ItemValue),getDate(),'tjkdDept'
	from dhc_bonus_subs.BonusSubExpendCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusTarget c
	where a.BonusUnitCode=b.BonusUnitCode and a.InterLocMethodID=:MethodID and a.BonusYear=:sYear
	and a.BonusPeriod=:sMonth and a.ExpendItemCode=c.BonusTargetCode and a.ExpendItemCode='06012'
	group by 58,a.BonusPeriod	
    )
	
	&sql(update dhc_bonus_subs.BonusSubExpendCollect set State =1,DataUpDate=getdate() where InterLocMethodID=:MethodID AND BonusYear=:sYear and BonusPeriod=:sMonth)
	;&sql(update dhc_bonus_subs.BonusSubExpendCollect set State =1,DataUpDate=getdate() where InterLocMethodID=10 AND BonusYear=:sYear and BonusPeriod=:sMonth)
	q SQLCODE
}

/// "1020^检查^320^内科^2011^M01^101^BBB^102^199^188^777^66"
/// w ##class(dhc.bonus.usubs.uExpendCollect).test("2011","M02")
ClassMethod test(syear, smonth)
{
	n (syear, smonth)
	s ^dhcbsSubExpendDataTemp("expend",$p($h,",",2))=$p($h,",",2)_"^检查^320^内科^"_syear_"^"_smonth_"^101^BBB^102^199^188^777^66"
    q 0
}

/// w ##class(dhc.bonus.usubs.uExpendCollect).testhello("hello")
/// w ##class(dhc.bonus.usubs.uExpendCollect).testhello("athadjfklsadf")
ClassMethod testhello(what)
{
	n (what)
	w "what is that"
	q what
}

/// Description: 下拉框选择核算单元
/// Table：dhc_bonus_data.SchemeTarget
/// others:w ##class(dhc.bonus.usubs.uExpendCollect).getUnitList(0,10,"")
ClassMethod getUnitList(start, limit, str) As %String
{
    n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	
	
	s sqlStr = "SELECT distinct BonusUnitName FROM dhc_bonus_subs.BonusSubExpendCollect"
	s whereStr=" WHERE %ID>0"
	i str'="" s whereStr = whereStr_" and (BonusUnitName LIKE '%"_str_"%')"
	
	s sqlStr=sqlStr_whereStr_" order by BonusUnitName"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	
	
	While(result.Next()){	
	s BonusUnitCode = result.Data("BonusUnitName")
	s BonusUnitName = result.Data("BonusUnitName")
	
	
	s tmp=BonusUnitCode_"^"_BonusUnitName
	
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	;w tmp
	d result.Close()
	s resultString = json.getJsonData("code^name",count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.us5E4.uExpendCollectS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
