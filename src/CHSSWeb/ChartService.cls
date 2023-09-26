Class CHSSWeb.ChartService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-03-
/// Description: 社区卫生诊断统计信息
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetStatInfo(CommunityCode As %String, StatType As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
    Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit  
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
    
    s AllArcNum=0
    s result = ##class(%Library.ResultSet).%New()
    
    ;s sqlStr="select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where CommunityCode ="_CommunityCode
    
    
    if StatType="DocimialTypeDR" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where DocimialTypeDR is not null and CommunityCode ="_CommunityCode
	e  i StatType="NationDR" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where NationDR is not null and CommunityCode ="_CommunityCode
	e  i StatType="Age" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where Birth is not null and CommunityCode ="_CommunityCode
    e  i StatType="SexDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where SexDR is not null and CommunityCode ="_CommunityCode
    e  i StatType="EducationDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where EducationDR is not null and CommunityCode ="_CommunityCode
    e  i StatType="ProfessionDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where ProfessionDR is not null and CommunityCode ="_CommunityCode
    e  i StatType="MarriageDR" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where MarriageDR is not null and CommunityCode ="_CommunityCode
    e  i StatType="ChronicDisease" d
    .s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where CommunityCode ="_CommunityCode
    
    
    
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s AllArcNum=result.Data("Num")
    }
    
    d result.Close()
    
    
    
    set StatName=0
    set ArcNum=0
    set PerNum=0
	
    s result = ##class(%Library.ResultSet).%New()
    
    /*
    if StatType="DocimialTypeDR" d
	.s sqlStr = "select DocimialTypeDR->Description As StatName, count(DocimialTypeDR->Description) ArcNum, ROUND(100*count(DocimialTypeDR->Description)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where DocimialTypeDR is not null  and CommunityCode ="_CommunityCode_" group by DocimialTypeDR->Description"
	e  i StatType="NationDR" d
	.s sqlStr = "select NationDR->CTNAT_Desc As StatName, count(NationDR->CTNAT_Desc) ArcNum, ROUND(100*count(NationDR->CTNAT_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where NationDR is not null  and CommunityCode ="_CommunityCode_" group by NationDR->CTNAT_Desc"
	e  i StatType="Age" d
    .s sqlStr = "select DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)},0,'0-9',1,'10-19',2,'20-29',3,'30-39',4,'40-49',5,'50-59',6,'60-69',7,'70-79','80以上') As StatName, count(*) As ArcNum, round(100*count(*)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain p where Birth is not Null and CommunityCode="_CommunityCode_"  group by DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)},0,'0-9',1,'10-19',2,'20-29',3,'30-39',4,'40-49',5,'50-59',6,'60-69',7,'70-79','80...')"
    e  i StatType="SexDR" d
	.s sqlStr = "select SexDR->CTSEX_Desc As StatName, count(SexDR->CTSEX_Desc) ArcNum, ROUND(100*count(SexDR->CTSEX_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where SexDR is not null  and CommunityCode ="_CommunityCode_" group by SexDR->CTSEX_Desc"
	e  i StatType="EducationDR" d
	.s sqlStr = "select EducationDR->EDU_Desc As StatName, count(EducationDR->EDU_Desc) ArcNum, ROUND(100*count(EducationDR->EDU_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where EducationDR is not null  and CommunityCode ="_CommunityCode_" group by EducationDR->EDU_Desc"
	e  i StatType="ProfessionDR" d
	.s sqlStr = "select ProfessionDR->CTOCC_Desc As StatName, count(ProfessionDR->CTOCC_Desc) ArcNum, ROUND(100*count(ProfessionDR->CTOCC_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where ProfessionDR is not null  and CommunityCode ="_CommunityCode_" group by ProfessionDR->CTOCC_Desc"
	e  i StatType="MarriageDR" d
	.s sqlStr = "select MarriageDR->CTMAR_Desc As StatName, count(MarriageDR->CTMAR_Desc) ArcNum, ROUND(100*count(MarriageDR->CTMAR_Desc)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthRecordMain where MarriageDR is not null  and CommunityCode ="_CommunityCode_" group by MarriageDR->CTMAR_Desc"
	e  i StatType="ChronicDisease" d
    .s sqlStr = "select ItemAssortName As StatName, count(*) As ArcNum, ROUND(100*count(*)/"_AllArcNum_",2)||'%' As PerNum from CHSS.PersonHealthDiagnose where PersonRowIdParref in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode="_CommunityCode_" ) and ItemdCode = '22' group by ItemAssortName"
   
     
			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s StatName=result.Data("StatName")
		s ArcNum=result.Data("ArcNum")
		s PerNum=result.Data("PerNum")
		
		Set tmp = StatName_"^"_ArcNum_"^"_PerNum
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }
    */
    
    
    if StatType="DocimialTypeDR" d
	.s sqlStr = "select DocimialTypeDR->Description As StatName, count(DocimialTypeDR->Description) ArcNum, 100*count(DocimialTypeDR->Description)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where DocimialTypeDR is not null  and CommunityCode ="_CommunityCode_" group by DocimialTypeDR->Description"
	e  i StatType="NationDR" d
	.s sqlStr = "select NationDR->CTNAT_Desc As StatName, count(NationDR->CTNAT_Desc) ArcNum, 100*count(NationDR->CTNAT_Desc)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where NationDR is not null  and CommunityCode ="_CommunityCode_" group by NationDR->CTNAT_Desc"
	e  i StatType="Age" d
    .s sqlStr = "select DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)},0,'0-9',1,'10-19',2,'20-29',3,'30-39',4,'40-49',5,'50-59',6,'60-69',7,'70-79','80以上') As StatName, count(*) As ArcNum, 100*count(*)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain p where Birth is not Null and CommunityCode="_CommunityCode_"  group by DECODE({fn Floor(DATEDIFF('dd', Birth, GETDATE())/365/10)},0,'0-9',1,'10-19',2,'20-29',3,'30-39',4,'40-49',5,'50-59',6,'60-69',7,'70-79','80...')"
    e  i StatType="SexDR" d
	.s sqlStr = "select SexDR->CTSEX_Desc As StatName, count(SexDR->CTSEX_Desc) ArcNum, 100*count(SexDR->CTSEX_Desc)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where SexDR is not null  and CommunityCode ="_CommunityCode_" group by SexDR->CTSEX_Desc"
	e  i StatType="EducationDR" d
	.s sqlStr = "select EducationDR->EDU_Desc As StatName, count(EducationDR->EDU_Desc) ArcNum, 100*count(EducationDR->EDU_Desc)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where EducationDR is not null  and CommunityCode ="_CommunityCode_" group by EducationDR->EDU_Desc"
	e  i StatType="ProfessionDR" d
	.s sqlStr = "select ProfessionDR->CTOCC_Desc As StatName, count(ProfessionDR->CTOCC_Desc) ArcNum, 100*count(ProfessionDR->CTOCC_Desc)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where ProfessionDR is not null  and CommunityCode ="_CommunityCode_" group by ProfessionDR->CTOCC_Desc"
	e  i StatType="MarriageDR" d
	.s sqlStr = "select MarriageDR->CTMAR_Desc As StatName, count(MarriageDR->CTMAR_Desc) ArcNum, 100*count(MarriageDR->CTMAR_Desc)/"_AllArcNum_" As PerNum from CHSS.PersonHealthRecordMain where MarriageDR is not null  and CommunityCode ="_CommunityCode_" group by MarriageDR->CTMAR_Desc"
	e  i StatType="ChronicDisease" d
    .s sqlStr = "select ItemAssortName As StatName, count(*) As ArcNum, 100*count(*)/"_AllArcNum_" As PerNum from CHSS.PersonHealthDiagnose where PersonRowIdParref in (select PersonRowId from CHSS.PersonHealthRecordMain where CommunityCode="_CommunityCode_" ) and ItemdCode = '22' group by ItemAssortName"
   
     
			
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s StatName=result.Data("StatName")
		s ArcNum=result.Data("ArcNum")
		s PerNum=$FNUMBER(result.Data("PerNum"),"",2)_"%"
		
		Set tmp = StatName_"^"_ArcNum_"^"_PerNum
    
     	Set count=count+1
     	If (count>start)&(count<=end) d
     	.d json.InsertRowData(tmp)
    }

    
    
    
    d result.Close()
    
    
     
    Set resultString = json.getJsonData("StatName^ArcNum^PerNum",count)
    k json
      
    Quit resultString
}

Storage Default
{
<Data name="ChartServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChartServiceD</DataLocation>
<DefaultData>ChartServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChartServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ChartServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ChartServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
