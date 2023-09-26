Class CHSSWeb.ReportCommunityInit Extends %Persistent
{

//初始化 ReportCommunityFPCount ，ReportCommunityPYCCount

//在晚上无人时执行此方法 很慢

//只执行此方法

ClassMethod InitFamilyAndPerson()
{
	//delete from  CHSS.ReportCommunityFPCount
 	s sqlStr="select p.communitycode as comp,p.DateRegister as datep,count(communitycode) as p  from chss.personhealthrecordmain p where communitycode <>'' and DateRegister<>'' group by  p.communitycode,p.DateRegister"
	Set result = ##class(%Library.ResultSet).%New() 
  	d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{		 
		  set comp = result.Get("comp")
		  set datep = result.Get("datep")
		  set p = result.Get("p") 
		  set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  s tmpComm.CommunityCode=comp		  
		  s tmpComm.DateOfRegister= datep
		  s tmpComm.PersonCount=p
		  s re=tmpComm.%Save()
		  i re'=1 w re 		  
		}
    s sqlStr="select f.communitycode as comf,f.DateOfRegister as datef,count(*) as f  from chss.familyhealthrecord f where communitycode <>'' and DateOfRegister<>''  group by  f.communitycode,f.DateOfRegister"
	Set result = ##class(%Library.ResultSet).%New() 
    d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{	
		  set comf = result.Get("comf")
		  set datef = result.Get("datef")
		  set f = result.Get("f") 	
		 
	      s rowid=0
		  s rowidN=""
		 f  s rowid=$O(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_comf,datef,rowid)) q:rowid=""  d
		 
		 .s rowidN=rowid
		 i rowidN'=""  d
		 .s tmpR1=##class(CHSS.ReportCommunityFPCount).%OpenId(rowidN)
		 .i tmpR1="" w rowidN_"cao",!
		  
		 .s tmpR1.FamilyCount=f
		 .s re=tmpR1.%Save()
		 .i re'=1 w "1="_re 
		 e  d
		 .set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  .s tmpComm.CommunityCode=comf		  
		  .s tmpComm.DateOfRegister= datef
		  .s tmpComm.FamilyCount=f
		  .s re=tmpComm.%Save()
		  .i re'=1 w "2="_re  
		 }
		d ..initReportTotal()
		d ..InitPYC()
}

ClassMethod initReportTotal()
{
	//delete from  CHSS.ReportCommunityFPCount
 	s sqlStr="select CommunityCode,sum(familycount) as FamilyCount,sum(personcount)as PersonCount from CHSS.ReportCommunityFPCount a where a.DateOfRegister<>'1840-12-31' group by communitycode"
	Set result = ##class(%Library.ResultSet).%New() 
  	d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{		 
		  set CommunityCode = result.Get("CommunityCode") 
		  set FamilyCount = result.Get("FamilyCount") 
		   set PersonCount = result.Get("PersonCount") 
		  
		  set tmpComm =##class(CHSS.ReportCommunityFPCount).%New()
		  s tmpComm.CommunityCode=CommunityCode		  
		  s tmpComm.DateOfRegister= 0
		  s tmpComm.FamilyCount=FamilyCount
		  s tmpComm.PersonCount=PersonCount
		  s re=tmpComm.%Save()
		  i re'=1 w "1="_re 
		  
		}
}

ClassMethod InitPYC()
{
	//delete from  CHSS.reportcommunitypyccount
	s sqlStr="Select CommunityCode,DateCheck ,count(DateCheck) as A from CHSS.PersonYearCheckRecord  where CommunityCode is not null and DateCheck is not null and Mark='NOTNULL' group by CommunityCode,DateCheck"
	Set result = ##class(%Library.ResultSet).%New()    
  	d result.Prepare(sqlStr)
    d result.Execute()
		While(result.Next())
		{		 
		  set CommunityCode = result.Get("CommunityCode")
		  set DateCheck = result.Get("DateCheck")
		  set count = result.Get("A") 
		 s tmp=##class(CHSS.ReportCommunityPYCCount).%New()
		 s tmp.CommunityCode=CommunityCode
		 s tmp.Date=DateCheck
		 s tmp.CheckCount=count
		 s re=tmp.%Save()
		 i re'=1 w "1="_re		 
	 }
 s sqlStr="Select CommunityCode,FillDate ,count(FillDate) as A from CHSS.PersonYearCheckRecord  where CommunityCode is not null and FillDate is not null  and Mark='NOTNULL' group by CommunityCode,FillDate"
     Set result = ##class(%Library.ResultSet).%New() 
     d result.Prepare(sqlStr)
     d result.Execute()
		While(result.Next())
		{		 
		  set CommunityCode = result.Get("CommunityCode")
		  set FillDate = result.Get("FillDate")
		  set count = result.Get("A") 
		  s RowId=0
         s RowIdN=""  
		 f  s RowId = $O(^CHSS.ReportCommunityPYCCountI("CommunityAndDateIndex"," "_CommunityCode,FillDate,RowId)) q:RowId=""  d
		 .s RowIdN=RowId 
		 i RowIdN'=""  d
		 .s tmpR=##class(CHSS.ReportCommunityPYCCount).%OpenId(RowIdN)
 		 .s tmpR.FillCount=count
		 .s re=tmpR.%Save()  
		 .i re'=1 w "2="_re		 
	  e  d
		  .set tmpComm =##class(CHSS.ReportCommunityPYCCount).%New()
		  .s tmpComm.CommunityCode=CommunityCode		  
		  .s tmpComm.Date= FillDate	 
		  .s tmpComm.FillCount=count
		  .s re=tmpComm.%Save() 
		   .i re'=1 w "3="_re		 		 
	 }
}

Storage Default
{
<Data name="ReportCommunityInitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportCommunityInitD</DataLocation>
<DefaultData>ReportCommunityInitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportCommunityInitD</IdLocation>
<IndexLocation>^CHSSWeb.ReportCommunityInitI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportCommunityInitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
