/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 奖金指标类别维护
Class dhc.bonus.udata.uCalculateTypeTarget Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 代码是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uCalculateTypeTarget).IfRepRow(3,33)
ClassMethod IfRepRow(calaTypeID, TargetID) As %String
{
	new (calaTypeID,TargetID)
	s rowid=0
	s rowid=$o(^dhcbsCalcTypeTargetI("idxCaluTypeTarget",calaTypeID,TargetID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 名称是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uCalculateTypeTarget).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	s rowid=$o(^dhcbsCalculateTypeGroupI("Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 查询
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uCalculateTypeTarget).List(1,0,25)
ClassMethod List(CalcTypeID, start, limit) As %String
{
	n (CalcTypeID, start, limit)
	//SQL
	s sqlStr="select %ID rowid,BonusCalculateTypeID,BonusCalculateTypeID->CalculateTypeName,BonusTargetID,BonusTargetID->BonusTargetName,StandardValue,IsValid"
	_",BonusSchemeID,BonusSchemeID->BonusSchemeName"
			 _" from dhc_bonus_data.CalculateTypeTarget where IsValid=1 "
	i CalcTypeID'="" d
	.s sqlStr=sqlStr_ " and BonusCalculateTypeID='"_CalcTypeID_"'"
	s sqlStr=sqlStr_ " order by BonusCalculateTypeID->CalculateTypeCode"

	//w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^svalue^targetID^targetName^ctypeID^cTypeName^BonusSchemeID^SchemeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		
		s svalue = result.Data("StandardValue")
		s targetID = result.Data("BonusTargetID")
		s targetName = result.Data("BonusTargetName")
		
		s ctypeID = result.Data("BonusCalculateTypeID")
		s cTypeName = result.Data("CalculateTypeName")
		s SchemeName = result.Data("BonusSchemeName")	
		s BonusSchemeID = result.Data("BonusSchemeID")			
		s tmp=rowid_"^"_svalue_"^"_targetID_"^"_targetName_"^"_ctypeID_"^"_cTypeName_"^"_BonusSchemeID_"^"_SchemeName
				
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
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
/// Others:w ##class(dhc.bonus.udata.uCalculateTypeTarget).ChangeUnitCalcRate(776,20)
ClassMethod ChangeUnitCalcRate(BonusUnitID, CalcTypeID) As %String
{
	n (BonusUnitID,CalcTypeID)
	s sqlStr="select a.BonusUnitID,b.BonusTargetID,4 RateType,b.BonusTargetID->CalUnitID TargetUnit,"
	_" 1 TargetDirection ,1 StepSize ,0 AccountBase,StandardValue TargetRate,1 IsValid,getdate() UpdateDate"
	_" from dhc_bonus_data.UnitCalculateType a,dhc_bonus_data.CalculateTypeTarget b"
    _" where a.CalculateTypeID= b.BonusCalculateTypeID"
   _" and BonusUnitID='"_BonusUnitID_"' and CalculateTypeID='"_CalcTypeID_"'"
    
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
		
		s TargetDirection = result.Data("TargetDirection")
		s StepSize = result.Data("StepSize")
		s TargetRate = result.Data("TargetRate")
		s AccountBase =1  
		s IsValid=1
		s AuditingState =0
		s UpdateDate = result.Data("UpdateDate")

		&sql(delete from  dhc_bonus_data.TargetCalculateRate where BonusUnitID=:BonusUnitID and BonusTargetID=:BonusTargetID)
	
		&sql(insert into dhc_bonus_data.TargetCalculateRate(BonusUnitID,BonusTargetID,RateType, TargetUnit, TargetDirection, StepSize, AccountBase ,TargetRate,IsValid ,AuditingState,UpdateDate) values(:BonusUnitID,:BonusTargetID,:RateType, :TargetUnit, :TargetDirection, :StepSize, :AccountBase ,:TargetRate,:IsValid ,:AuditingState,:UpdateDate))


	}
		
	d result.Close()

	q 0
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.TargetType
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uCalculateTypeTarget).InsertRec("","")
ClassMethod InsertRec(targetID, CalcTypeID, StandardValue, schemeID) As %String
{
	
	n (targetID, CalcTypeID,StandardValue,schemeID)
	/*
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	*/
	s rowid=0
	s rowid=..IfRepRow(CalcTypeID,targetID)
	q:rowid>0 "RepCode"
	
	
	set isValid =1

	&sql(insert into dhc_bonus_data.CalculateTypeTarget(BonusCalculateTypeID,BonusTargetID,StandardValue,BonusSchemeID,IsValid) values(:CalcTypeID,:targetID,:StandardValue,:schemeID,:isValid))
	q SQLCODE
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-15
/// Description: 更新记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uCalculateTypeTarget).UpdateRec(1,1,1,45,17)
ClassMethod UpdateRec(rowid, CalcTypeID, targetID, svalue, schemeID) As %String
{
	
	n (rowid, CalcTypeID,targetID, svalue,schemeID)
	
	//w rowid_":"_CalcTypeID_":"_targetID,!
	s tmpRowid=0
	s tmpRowid=..IfRepRow(CalcTypeID,targetID)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"

	&sql(UPDATE dhc_bonus_data.CalculateTypeTarget SET BonusTargetID=:targetID,StandardValue=:svalue,BonusSchemeID=:schemeID WHERE %ID=:rowid)
	
	&sql(update dhc_bonus_data.TargetCalculateRate set  TargetRate =:svalue where BonusSchemeID=:schemeID and BonusTargetID=:targetID
	and BonusUnitID IN ( select BonusUnitID from dhc_bonus_data.UnitCalculateType where CalculateTypeID=:CalcTypeID))
	q SQLCODE
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-15
/// Description: 删除记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uCalculateTypeTarget).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.CalculateTypeTarget set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

/// Creator：zhaoliguo
/// CreatDate：2011-2-14
/// Description: 获取奖金指标
/// Table：dhc.bonus.data.BonusUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效单位字符串
/// Others：w ##class(dhc.bonus.udata.uCalculateTypeTarget).BonusTarget(0,10,"")
ClassMethod BonusTarget(start, limit, targetname) As %String
{
	n (start, limit, targetname)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "  select BonusTargetID ,BonusTargetCode,BonusTargetName from dhc_bonus_data.BonusTarget  where  IsValid=1 and DataSource=4"
	i targetname'="" s sqlStr = sqlStr_" and BonusTargetName like '"_targetname_"%'"

	
	s sqlStr=sqlStr_" order by TargetTypeID,Cast(BonusTargetCode as int)"
	//w sqlStr,!
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.bonus.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("BonusTargetID")
		s code = result.Data("BonusTargetCode")
		s name = result.Data("BonusTargetName")

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
/// CreatDate：2012-01-20
/// Description: 查询
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uCalculateTypeTarget).ListUT(176,1,0,25)
ClassMethod ListUT(UnitID, CalcTypeID, start, limit) As %String
{
	n (UnitID,CalcTypeID, start, limit)

	s sqlStr="select a.%ID rowid,BonusCalculateTypeID,BonusCalculateTypeID->CalculateTypeName,a.BonusTargetID"
	_" ,a.BonusTargetID->BonusTargetName,b.TargetRate StandardValue,a.IsValid,a.BonusSchemeID,a.BonusSchemeID->BonusSchemeName"
	_" from dhc_bonus_data.CalculateTypeTarget a,dhc_bonus_data.TargetCalculateRate b"
	_" where  a.BonusTargetID = b.BonusTargetID and a.BonusSchemeID = b.BonusSchemeID and a.IsValid=1 "
	_" and b.BonusUnitID ='"_UnitID_"'  AND a.BonusCalculateTypeID='"_CalcTypeID_"'"
	
	s sqlStr=sqlStr_ " order by a.BonusSchemeID->BonusSchemeCode,BonusCalculateTypeID->CalculateTypeCode"

	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^svalue^targetID^targetName^ctypeID^cTypeName^BonusSchemeID^SchemeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		
		s svalue = result.Data("StandardValue")
		s targetID = result.Data("BonusTargetID")
		s targetName = result.Data("BonusTargetName")
		
		s ctypeID = result.Data("BonusCalculateTypeID")
		s cTypeName = result.Data("CalculateTypeName")
		s SchemeName = result.Data("BonusSchemeName")	
		s BonusSchemeID = result.Data("BonusSchemeID")			
		s tmp=rowid_"^"_svalue_"^"_targetID_"^"_targetName_"^"_ctypeID_"^"_cTypeName_"^"_BonusSchemeID_"^"_SchemeName
				
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
<StreamLocation>^dhc.bonus.u5C1.uCalculateTy80CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
