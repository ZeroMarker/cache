/// Creator: 赵立国
/// CreatDate: 2012-08-8
/// Description: 奖金项目类别
Class dhc.bonus.udata.uImpUnitMainTmp Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：赵立国
/// CreatDate：2012-08-8
/// Description: 查询
/// Table：dhc.bonus.data.BonusItemType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uImpUnitMainTmp).List("","","","fhq",0,25)
ClassMethod List(fileID, sdate, edate, userCode, start, limit) As %String
{
	n (fileID,sdate,edate,userCode, start, limit)
	//SQL
	s sqlStr="select ImpUnitMainTmpID,OnloadFileID,OnloadFileID->FileTypeName, ImpTitle,ImpFileDesc,ImpUserCode,ImpDatetime,ImpFlag, FileName"
	_" from dhc_bonus_temp.ImpUnitMainTmp where %ID>0 "
	_" AND OnloadFileID in (select OnloadFileTypeID from dhc_bonus_data.PersonOnloadFile where %ID>0 AND BonusEmployeeID->EmployeeCode='"_userCode_"')"
	
	i fileID'="" d
	.s sqlStr=sqlStr_" AND OnloadFileID='"_fileID_"'"
	i sdate'="" d
	.s sqlStr=sqlStr_" AND ImpDatetime>'"_sdate_"' "
	i edate'="" d
	.s sqlStr=sqlStr_" and ImpDatetime<'"_edate_"'"
	;w sqlStr,!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^ImpTitle^ImpFileDesc^ImpUserCode^ImpDatetime^ImpFlag^FileTypeName^OnloadFileID"

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("ImpUnitMainTmpID")
		s ImpTitle = result.Data("ImpTitle")
		s ImpFileDesc = result.Data("ImpFileDesc")
		s ImpUserCode = result.Data("ImpUserCode")
		s OnloadFileID = result.Data("OnloadFileID")
		
		s ImpDatetime = result.Data("ImpDatetime")
		s ImpFlag = result.Data("ImpFlag")
		i ImpFlag="0" d
		.s ImpFlag="未上传"
		i ImpFlag="1" d
		.s ImpFlag="已上传"
		
		s FileTypeName = result.Data("FileTypeName")
		
		
		s tmp=rowid_"^"_ImpTitle_"^"_ImpFileDesc_"^"_ImpUserCode_"^"_ImpDatetime_"^"_ImpFlag_"^"_FileTypeName_"^"_OnloadFileID

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-18
/// Description: 奖金核算明细动态标题
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uImpUnitMainTmp).GetGridTitle(4)
ClassMethod GetGridTitle(fileTypeID) As %String
{
	n (fileTypeID)
	s rowid= 0
	
	s sqlStr=" select 'Index'_ CalculateGroupID as  IndexName,CalculateGroupID->CalculateGroupName  title"
		_" from dhc_bonus_data.ImpEmpConfig WHERE OnloadFileTypeID='"_fileTypeID_"' and CalculateGroupID>0"

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^IndexName^title"
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	
	d json.InsertRowData("-4^supUnitCode^科室编码")
	d json.InsertRowData("-3^supUnitName^科室名称")
	d json.InsertRowData("-2^unitCode^人员编码")
	d json.InsertRowData("-1^unitName^人员名称")
	d json.InsertRowData("0^joinDate^入职日期")
	// 
	While(result.Next()){
		s rowid =rowid+1
		s dataIndex=result.Data("IndexName")
		s title=result.Data("title")
		
		s tmp = rowid_"^"_dataIndex_"^"_title
		d json.InsertRowData(tmp)
		s count=count+1	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2011-01-18
/// Description: 奖金核算明细动态数据
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码,BonusYear-核算年度,BonusPeriod-核算期间
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uImpUnitMainTmp).GetImpEmpDetail("370",0,5)
ClassMethod GetImpEmpDetail(ImpUnitMainID, start, limit) As %String
{
	n (ImpUnitMainID, start, limit)
	s rowid= 0
	
	
	s sqlStr="select ImpUnitDetailTmpID , ImpUnitMainID,TmpUnitCode,TmpUnitName,SupUnitCode,SupUnitName,CalGroupID,CalGroupValue,ColNum,OnloadFileID,JoinDate"
	_" from dhc_bonus_temp.ImpUnitDetailTmp where ImpUnitMainID='"_ImpUnitMainID_"'"
	_" order by TmpUnitCode"
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	//s jsonTitle="supUnitCode^supUnitName^unitCode^unitName^joinDate"
	
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s sTitle =""
	s sValue =""
	s unittmp=""
	
	s count=0
	s resultString=""
	s end=start+limit-1
	s hj=0

	While(result.Next()){
		
		s rowid =rowid+1
		//w rowid,!
		s dataIndex="Index"_result.Data("CalGroupID")
		s title=result.Data("CalGroupValue")
		s BonusValue=result.Data("CalGroupValue")
		
		s supUnitCode=result.Data("SupUnitCode")
		s supUnitName=result.Data("SupUnitName")
		s unitCode=result.Data("TmpUnitCode")
		s unitname=result.Data("TmpUnitName")
		s joinDate=result.Data("JoinDate")
		
		if unittmp="" {
			s unittmp=unitCode
			s sTitle ="supUnitCode^supUnitName^unitCode^unitName^joinDate"
			s sValue =supUnitCode_"^"_supUnitName_"^"_unitCode_"^"_unitname_"^"_joinDate
			}
		if unittmp=unitCode
		{
			s unittmp=unitCode
			s sTitle =sTitle_"^" _dataIndex
			s sValue = sValue_"^" _BonusValue

		}else{
			i (count>=start)&(count<=end) d
			.d json.InsertRowData(sValue)
			s count=count+1	
			
			s hj=1
			s unittmp=unitCode
			s sTitle ="supUnitCode^supUnitName^unitCode^unitName^joinDate^"_dataIndex
			s sValue =supUnitCode_"^"_supUnitName_"^"_unitCode_"^"_unitname_"^"_joinDate_"^"_BonusValue	
	
			}
		}
	
	
		i sValue="" d
		.s sValue =" ^"
		
		i sTitle="" d 
		.s sTitle="supUnitCode^supUnitName^unitCode^unitName^joinDate"
		i (count>=start)&(count<=end) d
		.;w sValue,!
		.d json.InsertRowData(sValue)
	s count=count+1

	d result.Close()
	s resultString = json.getJsonData(sTitle,count)
 	k json
	q resultString
}

/// Creator: zhao liguo
/// CreatDate: 2012-08-16
/// Description: 上传导入的科室人员数据
/// Table: dhc.bonus.data.BonusScheme
/// Input: SchemeCode-奖金方案编码,BonusYear-核算年度,BonusPeriod-核算期间
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.bonus.udata.uImpUnitMainTmp).upImpEmp(370)
ClassMethod upImpEmp(MainID) As %String
{
	n (MainID)
	//修改存在的科室人员信息
	&sql(update dhc_bonus_data.BonusUnit  set SuperiorUnitID=
		(select supBonusUnitID from (select distinct BonusUnitID supBonusUnitID,TmpUnitCode
		from dhc_bonus_data.BonusUnit a,dhc_bonus_temp.ImpUnitDetailTmp b
		where a.BonusUnitCode = b.supUnitCode and ImpUnitMainID=370) as jj where bonusUnitCode =TmpUnitCode  )
		where  spell=388 and BonusUnitCode  in
		(select distinct TmpUnitCode   from dhc_bonus_data.BonusUnit a,dhc_bonus_temp.ImpUnitDetailTmp b
		where a.BonusUnitCode = b.TmpUnitCode and a.SuperiorUnitID->BonusUnitCode<> b.supUnitCode and ImpUnitMainID=:MainID
	))
	//增加新的科室人员信息
	&sql(insert into dhc_bonus_data.BonusUnit(BonusUnitCode,BonusUnitName, UnitFlag,SuperiorUnitID,UnitLevel,LastStage,UpdateDate,IsValid,BonusUnitTypeID,EmployeeNo,SumUnitID,StartDate)
	select distinct TmpUnitCode,TmpUnitName,3 UnitFlag,a.BonusUnitID SuperiorUnitID,3 UnitLevel,1 LastStage,
	getDate() UpdateDate,1 IsValid,10 BonusUnitTypeID,TmpUnitCode EmployeeNo,BonusUnitID SumUnitID,JoinDate StartDate
	from  dhc_bonus_data.BonusUnit a,dhc_bonus_temp.ImpUnitDetailTmp b
	where a.BonusUnitCode = b.supUnitCode and  ImpUnitMainID=:MainID
	and b.TmpUnitCode not in (select BonusUnitCode from dhc_bonus_data.BonusUnit where  LastStage=1 and IsValid=1)
	)
	//更新主表信息
	&sql(update dhc_bonus_temp.ImpUnitMainTmp set ImpFlag=1,UpDatetime=getdate() where %ID=:MainID
	)
	//删除固定指标信息
	&sql(
	Delete from dhc_bonus_data.TargetCalculateRate r where r.BonusUnitID IN
	(select distinct BonusUnitID   from dhc_bonus_temp.ImpUnitDetailTmp a,dhc_bonus_data.BonusUnit b ,dhc_bonus_data.CalculateTypeTarget c
	where a.TmpUnitCode =b.BonusUnitCode and c.BonusCalculateTypeID->CalculateTypeName =a.CalGroupValue
	and c.BonusCalculateTypeID->CalculateTypeGroupID= a.CalGroupID
	and r.BonusTargetID=c.BonusTargetID and  ImpUnitMainID=:MainID)
	)
	//添加新的固定指标信息
	&sql(insert into dhc_bonus_data.TargetCalculateRate(BonusUnitID,BonusTargetID,RateType, TargetUnit, TargetDirection, StepSize,
 	AccountBase ,TargetRate,IsValid ,AuditingState,UpdateDate,BonusSchemeID)
	select distinct b.BonusUnitID,c.BonusTargetID,4 RateType,4 TargetUnit,1 TargetDirection,1 StepSize,
 	0 AccountBase ,c.StandardValue TargetRate,1 IsValid ,0 AuditingState,getdate() UpdateDate,1 BonusSchemeID
 	from dhc_bonus_temp.ImpUnitDetailTmp a,dhc_bonus_data.BonusUnit b ,dhc_bonus_data.CalculateTypeTarget c
	where a.TmpUnitCode =b.BonusUnitCode and c.BonusCalculateTypeID->CalculateTypeName =a.CalGroupValue
	and c.BonusCalculateTypeID->CalculateTypeGroupID= a.CalGroupID and  ImpUnitMainID=:MainID)
	//删除人员属性信息
	&sql(
	delete from dhc_bonus_data.UnitCalculateType c
	where BonusUnitID in(
	select distinct BonusUnitID    from dhc_bonus_temp.ImpUnitDetailTmp a,dhc_bonus_data.BonusUnit b
	where a.TmpUnitCode =b.BonusUnitCode and c.CalculateTypeID->CalculateTypeGroupID= a.CalGroupID
	and c.CalculateTypeID->CalculateTypeName =a.CalGroupValue and  ImpUnitMainID=:MainID))
	//添加人员属性信息
	&sql(insert into dhc_bonus_data.UnitCalculateType(BonusUnitID,CalculateTypeID)
	select distinct BonusUnitID ,c.%ID CalculateTypeID   from dhc_bonus_temp.ImpUnitDetailTmp a,dhc_bonus_data.BonusUnit b ,dhc_bonus_data.BonusCalculateType c
	where a.TmpUnitCode =b.BonusUnitCode and CalculateTypeName =a.CalGroupValue
	and c.CalculateTypeGroupID= a.CalGroupID AND ImpUnitMainID=:MainID	)
	
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uImpUnitMain5F1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
