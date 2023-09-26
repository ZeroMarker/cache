/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 指标权限设置
Class dhc.bonus.udata.uUnitCalculateType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uUnitCalculateType).List("","","","",0,25,"165^790^1^23")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, sParam) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,sParam)

 	s sqlStr="select %ID rowid, BonusUnitID,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName,CalculateTypeID->CalculateTypeName  ,CalculateTypeID->CalculateTypeGroupID->CalculateGroupName"
 		_",CalculateTypeID,CalculateTypeID->CalculateTypeGroupID " 
 		_",BonusUnitID->SuperiorUnitID,BonusUnitID->SuperiorUnitID->BonusUnitCode supUnitCode,BonusUnitID->SuperiorUnitID->BonusUnitName superName"
		_"  from dhc_bonus_data.UnitCalculateType where %id>0 "
 	// SuperiorUnitID,superName
 	//	sParam = supUnitID+"^"+bonusUnitID+"^"+calcTypeGroupID+"^"+calcTypeID
 	s supUnitID = $p(sParam,"^",1)
 	s bonusUnitID = $p(sParam,"^",2)
 	s calcTypeGroupID = $p(sParam,"^",3)
 	s calcTypeID = $p(sParam,"^",4)
 	
 	i supUnitID'="" d 
 	.s sqlStr=sqlStr_" and BonusUnitID->SuperiorUnitID="_supUnitID
  	i bonusUnitID'="" d 
 	.s sqlStr=sqlStr_" and BonusUnitID ="_bonusUnitID
 	
 	i calcTypeGroupID'="" d 
 	.s sqlStr=sqlStr_" and CalculateTypeID->CalculateTypeGroupID ="_calcTypeGroupID
 	i calcTypeID'="" d 
 	.s sqlStr=sqlStr_" and CalculateTypeID ="_calcTypeID
 
 
 	
 	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1=" %ID "
	.i sortField="BonusUnitName" s sortField1=" BonusUnitID->BonusUnitName"
	.i sortField="CalculateTypeName" s sortField1="CalculateTypeID->CalculateTypeName"
	.i sortField="CalculateGroupName" s sortField1=" CalculateTypeID->CalculateTypeGroupID->CalculateGroupName"
	.i sortField="superName" s sortField1=" BonusUnitID->SuperiorUnitID->BonusUnitName superName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

	s sqlStr=sqlStr_sortStr
	//w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^BonusUnitID^BonusUnitName^CalculateTypeID^CalculateTypeName^CalculateTypeGroupID^CalculateGroupName^SuperiorUnitID^superName"
				

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s BonusUnitID  = result.Data("BonusUnitID")
		s BonusUnitCode= result.Data("BonusUnitCode")
		s BonusUnitName = result.Data("BonusUnitName")
		s CalculateTypeID = result.Data("CalculateTypeID")
		s CalculateTypeName = result.Data("CalculateTypeName")
		s CalculateTypeGroupID = result.Data("CalculateTypeGroupID")
		s CalculateGroupName = result.Data("CalculateGroupName")
		s SuperiorUnitID = result.Data("SuperiorUnitID")
		s supUnitCode= result.Data("supUnitCode")
		s superName = result.Data("superName")

			
		s tmp=rowid_"^"_BonusUnitID_"^"_BonusUnitName_"_"_BonusUnitCode_"^"_CalculateTypeID_"^"_CalculateTypeName
		_"^"_CalculateTypeGroupID_"^"_CalculateGroupName_"^"_SuperiorUnitID_"^"_superName_"_"_supUnitCode
		
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusEmpCalculateType).Delete(4)
ClassMethod Delete(rowid, BonusUnitID) As %String
{
	n (rowid,BonusUnitID)
	
	&sql(delete from  dhc_bonus_data.TargetCalculateRate a where a.BonusTargetID in (select b.BonusTargetID from dhc_bonus_data.CalculateTypeTarget b where BonusCalculateTypeID=:rowid  ) and a.BonusUnitID=:BonusUnitID)

	&SQL(DELETE FROM dhc_bonus_data.UnitCalculateType WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uUnitCalculateType).InsertRec(534,4)
ClassMethod InsertRec(supUnitID, BonusUnitID, CalculateTypeID) As %String
{
	
	n (supUnitID,BonusUnitID, CalculateTypeID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusUnitID, CalculateTypeID)
	q:rowid>0 "RepCode"
	
	i BonusUnitID=-1 d
	.&sql(insert into dhc_bonus_data.UnitCalculateType(BonusUnitID, CalculateTypeID) select BonusUnitID,:CalculateTypeID from dhc_bonus_data.BonusUnit where SuperiorUnitID=:supUnitID 	)
	else  d
	.&sql(insert into dhc_bonus_data.UnitCalculateType(BonusUnitID, CalculateTypeID) values(:BonusUnitID,:CalculateTypeID))

	s rtn = SQLCODE
	d ..ChangeUnitCalcRate(supUnitID,BonusUnitID,0, CalculateTypeID)
	q rtn
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uUnitCalculateType).UpdateRec(1113,-1,449,43,44,1)
ClassMethod UpdateRec(rowid, supUnitID, BonusUnitID, OldCalculateTypeID, NewCalculateTypeID, isChangeTarget) As %String
{
	
	n (rowid,supUnitID,BonusUnitID,OldCalculateTypeID,NewCalculateTypeID,isChangeTarget)
	
	s Rowid=0
	s Rowid=..IfRepCode(BonusUnitID, NewCalculateTypeID)
	q:Rowid>0 "RepCode"
	i BonusUnitID=-1 d
	.&sql(update dhc_bonus_data.UnitCalculateType set CalculateTypeID=:NewCalculateTypeID where BonusUnitID->SuperiorUnitID=:supUnitID and CalculateTypeID=:OldCalculateTypeID )
 	else  d
 	.&sql(update dhc_bonus_data.UnitCalculateType set BonusUnitID=:BonusUnitID,CalculateTypeID=:NewCalculateTypeID where %ID=:rowid )
 	
	s rtn= SQLCODE
	
	i isChangeTarget=1 d
	.d ..ChangeUnitCalcRate(supUnitID,BonusUnitID, OldCalculateTypeID,NewCalculateTypeID)
	
	q rtn
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uUnitCalculateType).UpdateInHDate()
ClassMethod UpdateInHDate() As %String
{
	
 	
 	&sql(delete from dhc_bonus_data.UnitCalculateType where CalculateTypeID in (46,47,48,49,50))

	&sql(insert into dhc_bonus_data.UnitCalculateType( BonusUnitID,CalculateTypeID)
	select bonusUnitID,case when DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')<365*6+1 then 46
 	 when DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')>=365*6+1 and DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')<365*11+1 then 47
  	when DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')>=365*11+1 and DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')<365*16+1 then 48
  	when DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')>=365*16+1 and DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')<365*21+1 then 49
  	when DATEDIFF('dd',startdate,year(getdate()) _ '-07-31')>=365*21+1 then 50 else -1 end jj
 	 from dhc_bonus_data.BonusUnit where startdate is not null)

 	&sql(delete from dhc_bonus_data.TargetCalculateRate where BonusTargetID=153)

	&sql(insert into dhc_bonus_data.TargetCalculateRate(BonusUnitID,BonusTargetID,RateType, TargetUnit, TargetDirection, StepSize, AccountBase
	,TargetRate,IsValid ,AuditingState,UpdateDate,BonusSchemeID)
	select BonusUnitID,BonusTargetID,4 RateType,9 TargetUnit, 1 TargetDirection,1  StepSize,0 AccountBase
	,StandardValue TargetRate,1 IsValid ,0 AuditingState,getdate()  UpdateDate,BonusSchemeID
	from dhc_bonus_data.CalculateTypeTarget a,dhc_bonus_data.UnitCalculateType b
	where a.BonusCalculateTypeID =b.CalculateTypeID and CalculateTypeID in (46,47,48,49,50))
	
	s rtn= SQLCODE
	q rtn
}

/// Creator: zhaoliguo
/// CreatDate: 2011-11-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uEmployeeTarget).IfRepCode(1,2)
ClassMethod IfRepCode(BonusUnitID, CalculateTypeID) As %String
{
	new (BonusUnitID, CalculateTypeID)
	s rowid=0
	s rowid=$o(^dhcbsUnitCalculateTypeI("UnitCalcType",BonusUnitID, CalculateTypeID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：zhaoliguo
/// CreatDate：2011-11-17
/// Description: 获取奖金指标
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uBonusEmpCalculateType).CalculateType(0,10,"6","")
ClassMethod CalculateType(start, limit, CalculateTypeGroupID, CalculateTypeName) As %String
{
	n (start, limit, CalculateTypeGroupID, CalculateTypeName)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select BonusCalculateTypeID rowid ,CalculateTypeCode code , CalculateTypeName name from dhc_bonus_data.BonusCalculateType"
			_"  where %ID>0 and IsValid= 1 and  CalculateTypeGroupID ="_CalculateTypeGroupID

	;i CalculateTypeName'="" s sqlStr = sqlStr_" and CalculateTypeName like '"_CalculateTypeName_"%'"
	s sqlStr=sqlStr_" order by CalculateTypeCode"
	
	//w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("rowid")
		s code = result.Data("code")
		s name = result.Data("name")

		s tmp=rowid_"^"_code_"_"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-28
/// Description: 单元核算类型指标处理
/// Table：dhc.bonus.data.TargetType
/// Input：
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uUnitCalculateType).ChangeUnitCalcRate(1474,35,36)
ClassMethod ChangeUnitCalcRate(supUnitID, BonusUnitID, OldCalcTypeID, NewCalcTypeID) As %String
{
	n (supUnitID,BonusUnitID,OldCalcTypeID,NewCalcTypeID)
	
	q:BonusUnitID="" "DataEmpty"
	q:OldCalcTypeID="" "DataEmpty"
	q:NewCalcTypeID="" "DataEmpty"
	
	s sqlStr=""
	i BonusUnitID=-1 d
	.&sql(delete from  dhc_bonus_data.TargetCalculateRate a where a.BonusTargetID in (select b.BonusTargetID from dhc_bonus_data.CalculateTypeTarget b where BonusCalculateTypeID=:OldCalcTypeID  ) and a.BonusUnitID->SuperiorUnitID=:supUnitID)
	.s sqlStr="select CalculateTypeID,a.BonusUnitID,b.BonusTargetID,4 RateType,b.BonusTargetID->CalUnitID TargetUnit,"
	.s sqlStr=sqlStr_" 1 TargetDirection ,1 StepSize ,0 AccountBase,StandardValue TargetRate,1 IsValid,getdate() UpdateDate,BonusSchemeID"
	.s sqlStr=sqlStr_" from dhc_bonus_data.UnitCalculateType a,dhc_bonus_data.CalculateTypeTarget b"
    .s sqlStr=sqlStr_" where a.CalculateTypeID= b.BonusCalculateTypeID"
    .s sqlStr=sqlStr_" and BonusUnitID->SuperiorUnitID='"_supUnitID_"' and  CalculateTypeID='"_NewCalcTypeID_"'"
	else  d
	.&sql(delete from  dhc_bonus_data.TargetCalculateRate a where a.BonusTargetID in (select b.BonusTargetID from dhc_bonus_data.CalculateTypeTarget b where BonusCalculateTypeID=:OldCalcTypeID  ) and a.BonusUnitID=:BonusUnitID)
	.s sqlStr="select CalculateTypeID,a.BonusUnitID,b.BonusTargetID,4 RateType,b.BonusTargetID->CalUnitID TargetUnit,"
	.s sqlStr=sqlStr_" 1 TargetDirection ,1 StepSize ,0 AccountBase,StandardValue TargetRate,1 IsValid,getdate() UpdateDate,BonusSchemeID"
	.s sqlStr=sqlStr_" from dhc_bonus_data.UnitCalculateType a,dhc_bonus_data.CalculateTypeTarget b"
    .s sqlStr=sqlStr_" where a.CalculateTypeID= b.BonusCalculateTypeID"
    .s sqlStr=sqlStr_" and BonusUnitID='"_BonusUnitID_"' and  CalculateTypeID='"_NewCalcTypeID_"'"

	q:((SQLCODE'=0) && (SQLCODE'=100)) "DataError"

	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s resultString=""

	//取结构 
	While(result.Next()){
		
		s BonusUnitID = result.Data("BonusUnitID")
		
		s BonusTargetID = result.Data("BonusTargetID")
		s RateType = result.Data("RateType")
		s TargetUnit = result.Data("TargetUnit")
		s CalculateTypeID=result.Data("CalculateTypeID")
		
		s TargetDirection = result.Data("TargetDirection")
		s StepSize = result.Data("StepSize")
		s TargetRate = result.Data("TargetRate")
		s AccountBase =1  
		s IsValid=1
		s AuditingState =0
		s UpdateDate = result.Data("UpdateDate")
		s BonusSchemeID=result.Data("BonusSchemeID")

		&sql(insert into dhc_bonus_data.TargetCalculateRate(BonusUnitID,BonusTargetID,RateType, TargetUnit, TargetDirection, StepSize, AccountBase ,TargetRate,IsValid ,AuditingState,UpdateDate,BonusSchemeID) 
		values(:BonusUnitID,:BonusTargetID,:RateType, :TargetUnit, :TargetDirection, :StepSize, :AccountBase ,:TargetRate,:IsValid ,:AuditingState,:UpdateDate,:BonusSchemeID))
	}
		
	d result.Close()

	q 0
}

/// Creator：zhao liguo
/// CreatDate：2011-3-18
/// Description: 查询发放奖金的科室人员
/// Table：dhc_bonus_data.BonusUnit
/// Input：sUnitID-核算单元ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uUnitCalculateType).GetUnit("大",0,25)
ClassMethod GetUnit(str, start, limit) As %String
{
	n (str, start, limit)
	//SQL select BonusEmployeeID,EmployeeCode,EmployeeName
	//
	k ^zlgtemp
	s ^zlgtemp=str
	
	s sqlStr="  select BonusUnitID , BonusUnitCode ,BonusUnitName  from  dhc_bonus_data.BonusUnit    where  IsValid=1 and LastStage=0 "
	i str'="" d
	.s sqlStr=sqlStr_" and (BonusUnitCode like '%"_str_"%' or BonusUnitName like '%"_str_"%')"
	
     s sqlStr=sqlStr_" order by BonusUnitTypeID,SuperiorUnitID,bonusUnitCode "

	;w sqlStr,!		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString = ""
	s end = start+limit
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	
	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		s tmp=rowid_"^"_code_"_"_name
		

		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uUnitCalcula745S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
