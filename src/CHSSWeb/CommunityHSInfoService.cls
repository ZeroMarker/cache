Class CHSSWeb.CommunityHSInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 健康档案建档户数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod FamilyArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
	s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateOfRegister between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(*) As Num from CHSS.FamilyHealthRecord where CommunityCode ='"_CommunityCode_"' "_whereStr
	
			
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
    
    d result.Close()
        
         
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 健康档案建档人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod PersonArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
        
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateRegister between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(*) As Num from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"' "_whereStr
	
			
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
    
    d result.Close()
        
         
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 妇女保健期内活产数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod WomenFetusInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    
    s whereStr = " and DateOfBirth between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select isnull(sum(FetusNum),0) As Num from CHSS.WhBirthRecord where WomanRowId->CommunityCode = '"_CommunityCode_"' "_whereStr
         
  
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
    }
        
    d result.Close()
    

    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 妇女保健建立孕产妇保健手册人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod WomenArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
          
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and WomanRowIdParref->EBTime between "_DateOfStart_" and "_DateOfEnd
   
    s sqlStr = "select count(*) As Num from CHSS.WomenFirstCheck where WomanRowIdParref->CommunityCode = '"_CommunityCode_"' "_whereStr
          
    	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 妇女保健规范产前检查人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod WomenCheckArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    
    s whereStr = " and CheckDate between "_DateOfStart_" and "_DateOfEnd
    
        
    s sqlStr = "select count(*) As Num from (select WomanRowIdParref from (select WomanRowIdParref from CHSS.WomenFirstCheck where WomanRowIdParref->CommunityCode = '"_CommunityCode_"' "_whereStr_" union all select WomanRowIdParref from CHSS.WhAntepartumRecheck where WomanRowIdParref->CommunityCode = '"_CommunityCode_"' "_whereStr_" ) group by WomanRowIdParref having count(*) >= 3 )"
   
       	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 妇女保健产后访视人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod WomenAfterCheckArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    
    s whereStr = " and CheckDate between "_DateOfStart_" and "_DateOfEnd
        
    
    s sqlStr = "select count(distinct WomanRowId) As Num from CHSS.WhAfterBirthVisitRecord where WomanRowId->CommunityCode = '"_CommunityCode_"' "_whereStr
    
        
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 老年人保健登记管理人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ElderArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateOfRecord between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(*) As Num from CHSS.ElerlyBaseInfo where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 老年人保健免费体格检查人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ElderCheckArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(distinct PersonRowId) As Num from CHSS.ElerlyHealthCheckRecord where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 老年人保健免费空腹血糖检查人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ElderBloodSurgeLimosisArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
         
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
    s whereStr = whereStr_" and BloodSurgeLimosis is not Null "
    
    s sqlStr = "select count(distinct PersonRowId) As Num from CHSS.ElerlyHealthCheckRecord where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 老年人保健指导人次数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod ElderCheckCountInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(*) As Num from CHSS.ElerlyHealthCheckRecord where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 康复指导与训练人次数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod TrainingCountInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
          
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateOfTrain between "_DateOfStart_" and "_DateOfEnd
        
    s sqlStr = "select count(*) As Num from CHSS.PersonTrainingRecord where TrainRowId->PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 重性精神疾病管理患者登记人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod SchizoArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
    
    s result = ##class(%Library.ResultSet).%New()
    
    /*
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
    */
    
    s whereStr = " and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '精神病')"
        
    s sqlStr = "select count(*) as Num from CHSS.PersonHealthRecordMain where CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 重性精神疾病管理患者显好人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod SchizoRecoverArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
   
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
    s whereStr = whereStr_" and CureEffect->Description = '好转' or CureEffect->Description = '痊愈' "
        
    s sqlStr = "select count(distinct PersonRowId) As Num from CHSS.SchizoCheckRecord where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description: 重性精神疾病管理规范管理人数
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod SchizoManageArcInfo(CommunityCode As %String, DateOfStart As %Date, DateOfEnd As %Date) As %String
{
   
    s result = ##class(%Library.ResultSet).%New()
    
    
    s DateOfStart=$zdh(DateOfStart,3)
    s DateOfEnd=$zdh(DateOfEnd,3)
    s whereStr = " and DateCheck between "_DateOfStart_" and "_DateOfEnd
    
        
    s sqlStr = "select count(distinct PersonRowId) As Num from CHSS.SchizoCheckRecord where PersonRowId->CommunityCode ='"_CommunityCode_"' "_whereStr
	      
           	
	d result.Prepare(sqlStr)
	d result.Execute()
	s Num = ""
	
	While(result.Next())
	{
	
	    s Num=result.Data("Num")
		   	
    }
        
    d result.Close()
    
      
    Quit Num
}

Storage Default
{
<Data name="CommunityHSInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityHSI8BDD</DataLocation>
<DefaultData>CommunityHSInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityHSI8BDD</IdLocation>
<IndexLocation>^CHSSWeb.CommunityHSI8BDI</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityHSI8BDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
