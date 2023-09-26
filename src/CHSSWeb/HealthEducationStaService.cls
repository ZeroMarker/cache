Class CHSSWeb.HealthEducationStaService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod listChart(CommunityCode, date)
{
	s json = ##class(Code.JsonObj).%New()
	s temp=..listBoard(CommunityCode,date)
	s temp2=..listLecture(CommunityCode,date)
	s temp3=..listMaterial(CommunityCode,date)
	s temp4=..listPlan(CommunityCode,date)
	d json.InsertRowData(temp)
	d json.InsertRowData(temp2)
	d json.InsertRowData(temp3)
	d json.InsertRowData(temp4)
	s resultString = json.getJsonData("name^num",4)
	k json
	q resultString
}

ClassMethod listBoard(CommunityCode, date)
{
	
	s count=0
    
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(date,3)
	s sqlStr = "select count(*) as num from CHSS.HealthEducationBulletinBoard "
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
 
	
	While(result.Next())
	{
		s count=count+1
		s name="健康教育黑板报"
		s num=result.Data("num")
		s tmp=name_"^"_num
	 
    }
   	d result.Close()

    
	q tmp
}

ClassMethod listLecture(CommunityCode, date)
{
	
	s count=0
    
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(date,3)
	s sqlStr = "select count(*) as num from CHSS.HealthEducationLecture "
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
 
	
	While(result.Next())
	{
		s count=count+1
		s name="健康教育讲座"
		s num=result.Data("num")
		s tmp=name_"^"_num
		 
    }
   	d result.Close()
 
	q tmp
}

ClassMethod listMaterial(CommunityCode, date)
{
	
	s count=0
   
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(date,3)
	s sqlStr = "select count(*) as num from CHSS.HealthEducationMaterial "
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
 
	
	While(result.Next())
	{
		s count=count+1
		s name="健康教育材料"
		s num=result.Data("num")
		s tmp=name_"^"_num
		
    }
   	d result.Close()

	q tmp
}

ClassMethod listPlan(CommunityCode, date)
{
	
	s count=0
  
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(date,3)
	s sqlStr = "select count(*) as num from CHSS.HealthEducationPlan "
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
 
	
	While(result.Next())
	{
		s count=count+1
		s name="健康教育计划"
		s num=result.Data("num")
		s tmp=name_"^"_num
		
    }
   	d result.Close()
	
	q tmp
}

Storage Default
{
<Data name="HealthEducationStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HealthEducat9EBD</DataLocation>
<DefaultData>HealthEducationStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HealthEducat9EBD</IdLocation>
<IndexLocation>^CHSSWeb.HealthEducat9EBI</IndexLocation>
<StreamLocation>^CHSSWeb.HealthEducat9EBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
