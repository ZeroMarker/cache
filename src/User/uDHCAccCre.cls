Class User.uDHCAccCre Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uDHCAccCre).Insert("DHCOPB002","aaa","","I","02/01/1841",1 ,"Y",1,1,"Y","","IPFee","","","","")
ClassMethod Insert(creCode, creDesc, creDataSource, crePatType, creDate, creTime, creActiveFlag, creStartDate, creEndDate, crePrePrtFlag, creIncluAbort, creModeCode, creBusiType, creNote1, creNote2, creNote3) As %String
{
	n (creCode, creDesc, creDataSource, crePatType, creDate, creTime, creActiveFlag, creStartDate, creEndDate, crePrePrtFlag, creIncluAbort, creModeCode, creBusiType, creNote1, creNote2, creNote3)
	
	i creDate'="" d
	.s creDate=$zdh(creDate,3)
	i creTime'="" d
	.s creTime=$zth(creTime,1)
	i creStartDate'="" d
	.s creStartDate=$zdh(creStartDate,3)
	i creEndDate'="" d
	.s creEndDate=$zdh(creEndDate,3)
	
	&sql(insert into DHC_AccCre (Cre_Code, Cre_Desc, Cre_DataSource, Cre_PatType, Cre_Date, Cre_Time, Cre_ActiveFlag, Cre_StartDate, Cre_EndDate, Cre_PrePrtFlag, Cre_IncluAbort, Cre_ModeCode, Cre_BusiType, Cre_Note1, Cre_Note2, Cre_Note3 ) values(:creCode, :creDesc, :creDataSource, :crePatType, :creDate, :creTime, :creActiveFlag, :creStartDate, :creEndDate, :crePrePrtFlag, :creIncluAbort, :creModeCode, :creBusiType, :creNote1, :creNote2, :creNote3))
	q SQLCODE
}

/// w ##class(User.uDHCAccCre).Update(3,"DHCOPB002","aaa","","I","02/01/1842",1 ,"Y",1,1,"Y","","IPFee","","","","")
ClassMethod Update(rowid, creCode, creDesc, creDataSource, crePatType, creDate, creTime, creActiveFlag, creStartDate, creEndDate, crePrePrtFlag, creIncluAbort, creModeCode, creBusiType, creNote1, creNote2, creNote3) As %String
{
	n (rowid,creCode, creDesc, creDataSource, crePatType, creDate, creTime, creActiveFlag, creStartDate, creEndDate, crePrePrtFlag, creIncluAbort, creModeCode, creBusiType, creNote1, creNote2, creNote3)

	i creDate'="" d
	.s creDate=$zdh(creDate,3)
	i creTime'="" d
	.s creTime=$zth(creTime,1)
	i creStartDate'="" d
	.s creStartDate=$zdh(creStartDate,3)
	i creEndDate'="" d
	.s creEndDate=$zdh(creEndDate,3)
	
	&sql(update DHC_AccCre set Cre_Code=:creCode,Cre_Desc=:creDesc,Cre_DataSource=:creDataSource,Cre_PatType=:crePatType,Cre_Date=:creDate,Cre_Time=:creTime,Cre_ActiveFlag=:creActiveFlag,Cre_StartDate=:creStartDate,Cre_EndDate=:creEndDate,Cre_PrePrtFlag=:crePrePrtFlag,Cre_IncluAbort=:creIncluAbort,Cre_ModeCode=:creModeCode,Cre_BusiType=:creBusiType,Cre_Note1=:creNote1,Cre_Note2=:creNote2,Cre_Note3=:creNote3 where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uDHCAccCre).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM DHC_AccCre WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uDHCAccCre).List()
ClassMethod List() As %String
{
	s sqlStr="select * from DHC_AccCre"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^creCode^creDesc^creDataSource^crePatType^creDate^creTime^creActiveFlag^creStartDate^creEndDate^crePrePrtFlag^creIncluAbort^creModeCode^creBusiType^creNote1^creNote2^creNote3"
	
	While(result.Next())
	{
		//Cre_Code, Cre_Desc, Cre_DataSource, 
		//Cre_PatType, Cre_Date, Cre_Time, Cre_ActiveFlag, 
		//Cre_StartDate, Cre_EndDate, Cre_PrePrtFlag, 
		//Cre_IncluAbort, Cre_ModeCode, Cre_BusiType, 
		//Cre_Note1, Cre_Note2, Cre_Note3 
		
		// rowid,creCode, creDesc, creDataSource, 
		// crePatType, creDate, creTime, creActiveFlag, 
		// creStartDate, creEndDate, crePrePrtFlag, 
		// creIncluAbort, creModeCode, creBusiType, 
		// creNote1, creNote2, creNote3
		
		s rowid = result.Data("Cre_RowID")
		s creCode = result.Data("Cre_Code")
		s creDesc = result.Data("Cre_Desc")
		s creDataSource = result.Data("Cre_DataSource")
		s crePatType = result.Data("Cre_PatType")
		s creDate = result.Data("Cre_Date")
		i creDate'="" d
		.s creDate=$zd(creDate,3)
		s creTime = result.Data("Cre_Time")
		i creTime'="" d
		.s creTime=$zt(creTime,1)
		s creActiveFlag = result.Data("Cre_ActiveFlag")
		s creStartDate = result.Data("Cre_StartDate")
		i creStartDate'="" d
		.s creStartDate=$zd(creStartDate,3)		
		s creEndDate = result.Data("Cre_EndDate")
		i creEndDate'="" d
		.s creEndDate=$zd(creEndDate,3)		
		s crePrePrtFlag = result.Data("Cre_PrePrtFlag")
		s creIncluAbort = result.Data("Cre_IncluAbort")
		s creModeCode = result.Data("Cre_ModeCode")
		s creBusiType = result.Data("Cre_BusiType")
		s creNote1 = result.Data("Cre_Note1")
		s creNote2 = result.Data("Cre_Note2")
		s creNote3 = result.Data("Cre_Note3")

		s tmp=rowid_"^"_creCode_"^"_creDesc_"^"_creDataSource_"^"_crePatType_"^"_creDate_"^"_creTime_"^"_creActiveFlag_"^"_creStartDate_"^"_creEndDate_"^"_crePrePrtFlag_"^"_creIncluAbort_"^"_creModeCode_"^"_creBusiType_"^"_creNote1_"^"_creNote2_"^"_creNote3
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^User.uDHCAccCreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
