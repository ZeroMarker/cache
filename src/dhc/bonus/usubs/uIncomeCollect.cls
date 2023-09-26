Class dhc.bonus.usubs.uIncomeCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhao liguo
/// CreatDate: 2011-6-11
/// Description: 查询符合条件的记录
/// Table: dhc_bonus_subs.BonusSubIncomeCollect
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).ListRec("13","","","","","",0,25,"2011","01","M")
ClassMethod ListRec(InterLocSetDr, InterMethodDr, searchField, searchValue, sortField, sortDir, start, limit, CycleDr, period, frequency) As %String
{
		n (InterLocSetDr,InterMethodDr,searchField, searchValue, sortField, sortDir, start, limit,CycleDr,period,frequency)
		
			
		s sqlStr="select BonusSubIncomeCollectID,IncomeItemCode , IncomeItemName ,BonusYear, BonusPeriod, MakeBillDeptCode , MakeBillDeptName ,  ExecuteDeptCode ,ExecuteDeptName,"
			_" SickDeptCode , SickDeptName, ChiefDoctorCode, ChiefDoctorName ,MakeBillDoctorCode ,  MakeBillDoctorName , ExecuteDoctorCode ,"
			_"   ExecuteDoctorName,  SickType  ,  ExpensesType ,  IncomeMoney ,  State "
			_" , InterLocMethodID,InterLocMethodID->InterLocMethod_methodDesc ,InterLocMethodID->InterLocSet_rowid->InterLocSet_name,  UpdateDate"
			_" FROM dhc_bonus_subs.BonusSubIncomeCollect "
			
			_" where InterLocMethodID->InterLocSet_rowid='"_InterLocSetDr_"' and BonusYear='"_CycleDr_"' and BonusPeriod='"_frequency_period_"'"
		i InterMethodDr'="" d
		.s sqlStr =sqlStr_" and InterLocMethodID= "_InterMethodDr

 		//w sqlStr,!
		s sortStr=""
		s sortField1=""
		
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="BonusSubIncomeCollectID"
		.i sortField="IncomeItemCode" s sortField1="IncomeItemCode"
		.i sortField="IncomeItemName" s sortField1="IncomeItemName"
		.i sortField="BonusYear" s sortField1="BonusYear"
		.i sortField="BonusPeriod" s sortField1="BonusPeriod"
		
		.i sortField="MakeBillDeptCode" s sortField1="MakeBillDeptCode"
		.i sortField="MakeBillDeptName" s sortField1="MakeBillDeptName"
		.i sortField="ExecuteDeptCode" s sortField1="ExecuteDeptCode"
		
		.i sortField="ExecuteDeptName" s sortField1="ExecuteDeptName"
		.i sortField="SickDeptCode" s sortField1="SickDeptCode"
		.i sortField="SickDeptName" s sortField1="SickDeptName"
		.i sortField="ChiefDoctorCode" s sortField1="ChiefDoctorCode"
		.i sortField="ChiefDoctorName" s sortField1="ChiefDoctorName"
		
		.i sortField="MakeBillDoctorCode" s sortField1="MakeBillDoctorCode"
		.i sortField="MakeBillDoctorName" s sortField1="MakeBillDoctorName"
		.i sortField="ExecuteDoctorCode" s sortField1="ExecuteDoctorCode"
		.i sortField="ExecuteDoctorName" s sortField1="ExecuteDoctorName"
		.i sortField="SickType" s sortField1="SickType"
		
		.i sortField="ExpensesType" s sortField1="ExpensesType"
		.i sortField="IncomeMoney" s sortField1="IncomeMoney"
		.i sortField="State" s sortField1="State"
		.i sortField="methodDesc" s sortField1="InterLocMethodID->InterLocMethod_methodDesc"
		.i sortField="InterLocSetname" s sortField1="InterLocMethodID->InterLocSet_rowid->InterLocSet_name"
		.i sortField="updateDate" s sortField1="updateDate"
		
			
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
		
		s jsonTitle="rowid^IncomeItemCode^IncomeItemName^BonusYear^BonusPeriod^MakeBillDeptCode^MakeBillDeptName^ExecuteDeptCode^ExecuteDeptName^"
			_"SickDeptCode^SickDeptName^ChiefDoctorCode^ChiefDoctorName^MakeBillDoctorCode^MakeBillDoctorName^ExecuteDoctorCode^"
			_"ExecuteDoctorName^SickType^ExpensesType^IncomeMoney^State^InterLocMethodID^UpdateDate^methodDesc^InterLocSetname"
		
		While(result.Next())
		{
							
			s rowid=result.Data("BonusSubIncomeCollectID")
          
            s methodDesc = result.Data("InterLocMethod_methodDesc")
            s InterLocSetname = result.Data("InterLocSet_name")
            
			s IncomeItemCode     =result.Data("IncomeItemCode")    
			s IncomeItemName     =result.Data("IncomeItemName")    
			s BonusYear          =result.Data("BonusYear")         
			s BonusPeriod        =result.Data("BonusPeriod")       
			s MakeBillDeptCode   =result.Data("MakeBillDeptCode")  
			s MakeBillDeptName   =result.Data("MakeBillDeptName")
			s ExecuteDeptCode    =result.Data("ExecuteDeptCode")
			s ExecuteDeptName    =result.Data("ExecuteDeptName")   
			                
			s SickDeptCode       =result.Data("SickDeptCode")      
			s SickDeptName       =result.Data("SickDeptName")      
			s ChiefDoctorCode    =result.Data("ChiefDoctorCode")   
			s ChiefDoctorName    =result.Data("ChiefDoctorName")   
			s MakeBillDoctorCode =result.Data("MakeBillDoctorCode")
			s MakeBillDoctorName =result.Data("MakeBillDoctorName")
			s ExecuteDoctorCode  =result.Data("ExecuteDoctorCode") 
			s ExecuteDoctorName  =result.Data("ExecuteDoctorName") 
			       
			s SickType           =result.Data("SickType")          
			s ExpensesType       =result.Data("ExpensesType")      
			s IncomeMoney        =result.Data("IncomeMoney")       
			s State              =result.Data("State")             
			s InterLocMethodID   =result.Data("InterLocMethodID")  
			s UpdateDate         =result.Data("UpdateDate")   

			
			s ptype =$E(BonusPeriod,1,1)
		
			i ptype="M" s periodType="月"
			i ptype="Q" s periodType="季"
			i ptype="H" s periodType="半年"
			i ptype="Y" s periodType="年"
			s BonusPeriod =$E(BonusPeriod,2,10)
					
			s tmp=rowid_"^"_IncomeItemCode_"^"_IncomeItemName_"^"_BonusYear_"^"_BonusPeriod_"^"_MakeBillDeptCode_"^"_MakeBillDeptName_"^"_ExecuteDeptCode_"^"_ExecuteDeptName_"^"
			_SickDeptCode_"^"_SickDeptName_"^"_ChiefDoctorCode_"^"_ChiefDoctorName_"^"_MakeBillDoctorCode_"^"_MakeBillDoctorName_"^"_ExecuteDoctorCode_"^"
			_ExecuteDoctorName_"^"_SickType_"^"_ExpensesType_"^"_IncomeMoney_"^"_State_"^"_InterLocMethodID_"^"_UpdateDate_"^"_methodDesc_"^"_InterLocSetname

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
	.&sql(delete FROM dhc_bonus_subs.BonusSubIncomeCollect where InterLocMethodID=:MethodID and BonusYear =:BonusYear and BonusPeriod =:BonusPeriod  )
	e  d
	.&sql(delete FROM dhc_bonus_subs.BonusSubIncomeCollect where  BonusYear =:BonusYear and BonusPeriod =:BonusPeriod  and InterLocMethodID->InterLocSet_rowid=:LocSetrowid)

	
	q SQLCODE
}

/// ^dhcbsSubIncomeDataTemp=IncomeItemCode^IncomeItemName^BonusYear^BonusPeriod^MakeBillDeptCode^MakeBillDeptName^ExecuteDeptCode^ExecuteDeptName^SickDeptCode^SickDeptName^ChiefDoctorCode^ChiefDoctorName^MakeBillDoctorCode^MakeBillDoctorName^ExecuteDoctorCode^ExecuteDoctorName^SickType^ExpensesType^IncomeMoney^State^InterLocMethodID^UpdateDate
/// Creator: Zhao LiGuo
/// CreatDate: 2011-8-30
/// Description: 收入数据采集导入
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input:sYear_核算年度,sPeriod_核算期间,sInterMethodID_核算方法ID, globalNode_Golbal节点标识
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).InsertSubIncomeData(4,"income")
ClassMethod InsertSubIncomeData(sYear, sPeriod, sInterMethodID, globalNode)
{
	n (sYear,sPeriod,sInterMethodID,globalNode)

	;k ^dhcbsSubIncomeDataTemp(_globalNode) 
	//"1020^aaa^2011^M01^101^BBB^102^CCC^103^DDD^33^DEEE^55^GFD^56^GGGD^1^1^2000"
	//IncomeItemCode^IncomeItemName^BonusYear^BonusPeriod^MakeBillDeptCode^MakeBillDeptName^ExecuteDeptCode^ExecuteDeptName^SickDeptCode^SickDeptName^ChiefDoctorCode^ChiefDoctorName^MakeBillDoctorCode^MakeBillDoctorName^ExecuteDoctorCode^ExecuteDoctorName^SickType^ExpensesType^IncomeMoney
	s updateflag=$ZD($P($H,",",1),3)_" "_$ZT($P($H,",",2),1)

	s rtnState=0
	s rowid=""
	TSTART
	//插入数据前先删除
	d ..DeleteSubIncomeData(sYear,sPeriod,sInterMethodID)
	
	f  s rowid=$O(^dhcbsSubIncomeDataTemp(globalNode,rowid)) q:((rowid="") || (rtnState>0))  d
	.s IncomeItemCode=$P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",1) //数据状态
	.s IncomeItemName= $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",2)
	.s BonusYear=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",3)
	.s BonusPeriod=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",4)
	.s MakeBillDeptCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",5)
	.s MakeBillDeptName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",6)
	.s ExecuteDeptCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",7)
	.s ExecuteDeptName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",8)
	.s SickDeptCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",9)
	.s SickDeptName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",10)
	.s ChiefDoctorCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",11)
	.s ChiefDoctorName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",12)
	.s MakeBillDoctorCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",13)
	.s MakeBillDoctorName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",14)
	.s ExecuteDoctorCode=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",15)
	.s ExecuteDoctorName=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",16)
	.s SickType=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",17)
	.s ExpensesType=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",18)
	.s IncomeMoney=  $P(^dhcbsSubIncomeDataTemp(globalNode,rowid),"^",19)
	.s State=  0
	.s InterLocMethodID= sInterMethodID
	.s UpdateDate= updateflag

	.&sql(insert into dhc_bonus_subs.BonusSubIncomeCollect(IncomeItemCode,IncomeItemName,BonusYear,BonusPeriod,MakeBillDeptCode,MakeBillDeptName,ExecuteDeptCode,ExecuteDeptName,SickDeptCode,SickDeptName,ChiefDoctorCode,ChiefDoctorName,MakeBillDoctorCode,MakeBillDoctorName,ExecuteDoctorCode,ExecuteDoctorName,SickType,ExpensesType,IncomeMoney,State,InterLocMethodID,UpdateDate) values(:IncomeItemCode,:IncomeItemName,:BonusYear,:BonusPeriod,:MakeBillDeptCode,:MakeBillDeptName,:ExecuteDeptCode,:ExecuteDeptName,:SickDeptCode,:SickDeptName,:ChiefDoctorCode,:ChiefDoctorName,:MakeBillDoctorCode,:MakeBillDoctorName,:ExecuteDoctorCode,:ExecuteDoctorName,:SickType,:ExpensesType,:IncomeMoney,:State,:InterLocMethodID,:UpdateDate))
	.s rtnState= SQLCODE
	;q:rtn'=0 1

	i rtnState>0 d
	.TRollBack
	e  d
	.TCOMMIT
	;k ^dhcbsSubIncomeDataTemp(_globalNode) 
	
	q rtnState
	
GetLogError
  	TRollBack
  	;k ^dhcbsSubIncomeDataTemp(_globalNode) 
	q 1
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-8-31
/// Description: 奖金系统数据采集接口
/// Table：
/// Input:sYear_核算年度, sPeriod_核算期间, InterLocSetDr_接口方法套ID, InterLocMethodDr_接口方法ID
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).IncomeInterMain("2011","M04",4,"")
ClassMethod IncomeInterMain(sYear, sPeriod, InterLocSetDr, InterLocMethodDr)
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
		k ^dhcbsSubIncomeDataTemp(tempGloble)
	
		//获取接口方法参数
		s sPamaName = ##class(dhc.bonus.udata.uInterMain).GetInterMethodParam(sYear, sPeriod,rowid)
			
		//得到接口方法并执行	
		s classMethodName=methodName_sPamaName
		//w "classMethodName:"_classMethodName,!
		d @classMethodName
		d ..InsertSubIncomeData(sYear, sPeriod,rowid,tempGloble)
		
		//当Global中无数据时，将不对其进行取数操作。
		//s sparam = rowid_"^"_sYear_"^"_sPeriod_"^"_updateflag
		//s rtn= ..DeleteCollectTempData(rowid,sYear,sPeriod)
		//对Global取数处理

		
	}
		d result.Close()
	
	q 0
}

/// Creator: Zhao LiGuo
/// CreatDate: 2011-8-31
/// Description: 删除已经采集的辅助核算数据
/// Table：dhc_bonus_subs.BonusSubIncomeCollect
/// Input:接口方法ID,核算年度,核算期间
/// Output: 
/// Return: 返回
/// Others: w ##class(dhc.bonus.usubs.uIncomeCollect).DeleteSubIncomeData(3,"2011","M01")
ClassMethod DeleteSubIncomeData(BonusYear, BonusPeriod, InterMethodDr)
{
	n (BonusYear, BonusPeriod,InterMethodDr)
	
	&sql(Delete  FROM dhc_bonus_subs.BonusSubIncomeCollect where  BonusYear=:BonusYear AND BonusPeriod=:BonusPeriod AND InterLocMethodID=:InterMethodDr)
		
	q SQLCODE
}

/// w ##class(dhc.bonus.usubs.uIncomeCollect).test("2011","M02")
ClassMethod test(syear, smonth)
{
	n (syear, smonth)
	//w $p($h,",",2)_"^aaa^"_syear_"^"_smonth_"^101^BBB^102^CCC^103^DDD^33^DEEE^55^GFD^56^GGGD^1^1^2000",!
	s ^dhcbsSubIncomeDataTemp("income",$p($h,",",2))=$p($h,",",2)_"^aaa^"_syear_"^"_smonth_"^101^BBB^102^CCC^103^DDD^33^DEEE^55^GFD^56^GGGD^1^1^2000"
    //zw ^dhcbsSubIncomeDataTemp
    q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.us5E4.uIncomeCollectS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
