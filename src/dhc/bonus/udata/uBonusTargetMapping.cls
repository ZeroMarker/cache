/// Creator: 李明忠
/// CreatDate: 2011-12-26
/// Description: 混合核算方案所涉及指标映射类
Class dhc.bonus.udata.uBonusTargetMapping Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 查询
/// Table：dhc.bonus.data.BonusTargetMapping
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusTargetMapping).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="select BonusTargetMappingID,BonusSchemID,BonusTargetID,MappedBonusTargetID,IsValid,comeFlag from dhc_bonus_data.BonusTargetMapping"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusTargetMappingID"
	.i sortField="schemName" s sortField1="BonusSchemID"
	.i sortField="targetName" s sortField1="BonusTargetID"
	.i sortField="mappingTargetName" s sortField1="MappedBonusTargetID"
	.i sortField="valid" s sortField1="IsValid"
	.i sortField="comeFlagName" s sortField1="comeFlag"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^schemID^schemName^targetId^targetName^mappingTargetId^mappingTargetName^valid^comeFlag^comeFlagName"
	

	//取结构
	While(result.Next()){
		s schemName="错误方案",targetName="错误涉及指标",mappingTargetName="错误映射指标或项目"
		
		s rowid = result.Data("BonusTargetMappingID")
		s schemID = result.Data("BonusSchemID")
		i schemID'="" d
		.i $D(^dhcbsBonusSchemeD(schemID)) d
		..i $G(^dhcbsBonusSchemeD(schemID))'="" d
		...s schemName = $List(^dhcbsBonusSchemeD(schemID),3)
		
		s targetId = result.Data("BonusTargetID")
		i targetId'="" d
		.i $D(^dhcbsBonusTargetD(targetId)) d
		..i $G(^dhcbsBonusTargetD(targetId))'="" d
		...s targetName=$List(^dhcbsBonusTargetD(targetId),3)
		
		s comeFlag = result.Data("comeFlag")
		i comeFlag=1 s comeFlagName="奖金指标"
		i comeFlag=2 s comeFlagName="奖金项目"
		
		s mappingTargetId = result.Data("MappedBonusTargetID")
		
		i comeFlag=1 d //属指标
		.i mappingTargetId'="" d
		..i $D(^dhcbsBonusTargetD(mappingTargetId)) d
		...i $G(^dhcbsBonusTargetD(mappingTargetId))'="" d
		....s mappingTargetName=$List(^dhcbsBonusTargetD(mappingTargetId),3)
		e  d //属奖金项目
		.i mappingTargetId'="" d
		..i $D(^dhcbsBonusSchemeItemD(mappingTargetId)) d
		...i $G(^dhcbsBonusSchemeItemD(mappingTargetId))'="" d
		....s mappingTargetName=$List(^dhcbsBonusSchemeItemD(mappingTargetId),4)
		
		s valid = result.Data("IsValid")
					
		s tmp=rowid_"^"_schemID_"^"_schemName_"^"_targetId_"^"_targetName_"^"_mappingTargetId_"^"_mappingTargetName_"^"_valid_"^"_comeFlag_"^"_comeFlagName
		
		i searchValue'="" d
		.q:(searchField = "schemName")&(schemName'[searchValue)
		
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

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 查询方案
/// Table：dhc.bonus.data.BonusScheme
/// Input：str-模糊查询字段;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusTargetMapping).GetSchem(0,25,"")
ClassMethod GetSchem(start, limit, str) As %String
{
	n (start,limit,str)

	s sqlStr="select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where IsValid =1 and SchemeType=2 and CalculateFlag=2"
	i str'="" s sqlStr = sqlStr_" and BonusSchemeCode LIKE '%"_str_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()

	//取结构
	While(result.Next()){
		s schemName="错误方案"
		
		s schemID = result.Data("BonusSchemeID")
		s schemName = result.Data("BonusSchemeName")
		s tmp=schemID_"^"_schemName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData("schemID^schemName",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 查询指标
/// Table：dhc.bonus.data.BonusTarget
/// Input：str-模糊查询字段;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusTargetMapping).GetTarget(0,25,"")
ClassMethod GetTarget(start, limit, str) As %String
{
	n (start,limit,str)

	s sqlStr="select BonusTargetID,BonusTargetName from dhc_bonus_data.BonusTarget where IsValid =1 and calFlag=1"
	i str'="" s sqlStr = sqlStr_" and BonusTargetCode LIKE '%"_str_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()

	//取结构
	While(result.Next()){
		s targetName="错误方案"
		
		s targetID = result.Data("BonusTargetID")
		s targetName = result.Data("BonusTargetName")
		s tmp=targetID_"^"_targetName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData("targetID^targetName",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 查询映射指标
/// Table：dhc.bonus.data.BonusTarget
/// Input：str-模糊查询字段;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusTargetMapping).GetMappedTarget(0,25,"",1)
ClassMethod GetMappedTarget(start, limit, str, comeId) As %String
{
	n (start,limit,str,comeId)

	s sqlStr=""
	
	i comeId=1 d //指标
	.s sqlStr="select BonusTargetID,BonusTargetName from dhc_bonus_data.BonusTarget where IsValid =1 and calFlag is null"
	.i str'="" s sqlStr = sqlStr_" and BonusTargetCode LIKE '%"_str_"%'"
	
	i comeId=2 d //奖金项目
	.s sqlStr="select BonusSchemeItemID,SchemeItemName from dhc_bonus_data.BonusSchemeItem where BonusSchemeID in (select BonusSchemeID from dhc_bonus_data.BonusScheme where SchemeType=1)"
	.i str'="" s sqlStr = sqlStr_" and SchemeItemCode LIKE '%"_str_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()

	//取结构
	While(result.Next()){
		s mappedTargetID=0,mappedTargetName="错误指标或项目"
		i comeId=1 d
		.s mappedTargetID = result.Data("BonusTargetID")
		.s mappedTargetName = result.Data("BonusTargetName")
		e  d
		.s mappedTargetID = result.Data("BonusSchemeItemID")
		.s mappedTargetName = result.Data("SchemeItemName")
		s tmp=mappedTargetID_"^"_mappedTargetName
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData("mappedTargetID^mappedTargetName",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusTargetMapping
/// Input：schemId-方案Id;targetId-方案指标ID;mappedTargetId-映射指标ID;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusTargetMapping).IfRepRecord(5,1)
ClassMethod IfRepRecord(schemId, targetId) As %String
{
	n (schemId,targetId)
	
	s rowid=0
	s rowid=$o(^dhc.bonus.d54C.BonusTargetM73AI("SchemTarget",schemId,targetId,rowid))
	i rowid="" d  s rowid=0
	
	q rowid
}

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusTargetMapping
/// Input：schemId-方案Id;targetId-方案指标ID;mappedTargetId-映射指标ID;comeId-数据来源:1-指标,2-奖金项目
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusTargetMapping).Insert(5,1,1,1)
ClassMethod Insert(schemId, targetId, mappedTargetId, comeId) As %String
{
	n (schemId,targetId,mappedTargetId,comeId)
	
	s rowid=0
	s rowid=..IfRepRecord(schemId,targetId)
	q:rowid>0 "RepRecord"
	
	s isValid =1

	&sql(insert into dhc_bonus_data.BonusTargetMapping(BonusSchemID,BonusTargetID,MappedBonusTargetID,IsValid,comeFlag) values(:schemId,:targetId,:mappedTargetId,:isValid,:comeId))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2011-12-26
/// Description: 更新记录
/// Table：dhc.bonus.data.BonusTargetMapping
/// Input：rowId-所在行号;schemId-方案Id;targetId-方案指标ID;mappedTargetId-映射指标ID;isValid-是否有效;comeId-数据来源:1-指标,2-奖金项目
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusTargetMapping).Update(1,"","","",1,1)
ClassMethod Update(rowId, schemId, targetId, mappedTargetId, isValid, comeId) As %String
{
	
	n (rowId,schemId,targetId,mappedTargetId,isValid,comeId)
	
	s tmpRowid=0
	s tmpRowid=..IfRepRecord(schemId,targetId)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepRecord"
	
	&sql(update dhc_bonus_data.BonusTargetMapping set BonusSchemID=:schemId,BonusTargetID=:targetId,MappedBonusTargetID=:mappedTargetId,IsValid=:isValid,comeFlag=:comeId where %ID=:rowId)
	q SQLCODE
}

/// Creator: 李明忠
/// CreatDate: 2011-12-26
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusTargetMapping
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusTargetMapping).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(delete from dhc_bonus_data.BonusTargetMapping where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusTarget7AFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
