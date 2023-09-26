Class CHSSWeb.ReportDoctorWorkloadService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod DoctorWorkloadList(start As %Integer, limit As %Integer, CommunityCode As %String, BeginDate As %Date, EndDate As %Date) As %String
{
		 
		Set start=$G(start)
		Set limit=$G(limit)
		set BeginDate = $zdh(BeginDate,3)
		set EndDate = $zdh(EndDate,3)
		
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
	    s result = ##class(%Library.ResultSet).%New() 
       s countperson=0
       s countfamily=0
		s sqlStr=" select cc.DoctorRegister  as UserName,pp.countp,mm.countf from"
		s sqlStr=sqlStr_" (select p.DoctorRegister as operator,count(*) as countp from chss.personhealthrecordmain p"
		s sqlStr=sqlStr_" where p.communitycode="_CommunityCode_" and p.DateInput>='"_BeginDate_"' and p.DateInput<='"_EndDate_"'"
		s sqlStr=sqlStr_" group by p.DoctorRegister )as pp"
		s sqlStr=sqlStr_" right join"
		s sqlStr=sqlStr_" ( select tt.DoctorRegister as DoctorRegister from"
		s sqlStr=sqlStr_" (select t.DoctorRegister as DoctorRegister from chss.personhealthrecordmain t"
		s sqlStr=sqlStr_" where t.communitycode="_CommunityCode_" and t.DateInput>='"_BeginDate_"' and t.DateInput<='"_EndDate_"'"
		s sqlStr=sqlStr_" union"
		s sqlStr=sqlStr_" select c.Doctor as DoctorRegister from chss.familyhealthrecord c"
		s sqlStr=sqlStr_" where c.communitycode="_CommunityCode_" and c.DateOfRegister>='"_BeginDate_"' and c.DateOfRegister<='"_EndDate_"' ) tt ) as cc"
		s sqlStr=sqlStr_" on pp.operator=cc.DoctorRegister"
		s sqlStr=sqlStr_" left join"
		s sqlStr=sqlStr_" (select f.Doctor as operator,count(*) as countf from chss.familyhealthrecord f"
		s sqlStr=sqlStr_" where f.communitycode="_CommunityCode_" and f.DateOfRegister>='"_BeginDate_"' and f.DateOfRegister<='"_EndDate_"'"
		s sqlStr=sqlStr_" group by f.Doctor)as mm on cc.DoctorRegister= mm.operator"
       ; w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{		 
		  set UserName = result.Get("UserName")
		  set Countp = result.Get("countp")
		  i (Countp'="")&& (Countp'="0") d
		  .s countperson=countperson+Countp
		  
		  set Countf = result.Get("countf")
		  i (Countf'="")&& (Countf'="0") d
		  .s countfamily=countfamily+Countf
	      Set tmp= UserName_"^"_Countf_"^"_Countp	    
	      Set count=count+1
	      If (count>start)&(count<=end) d
		  .d json.InsertRowData(tmp)
		}
		d json.InsertRowData("合&nbsp;&nbsp;计"_"^"_countfamily_"^"_countperson)		
	    Set resultString = json.getJsonData("UserName^Countf^Countp",count)
	 	k json	 	
		Quit resultString
}

Storage Default
{
<Data name="ReportDoctorWorkloadServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportDoctorAFBD</DataLocation>
<DefaultData>ReportDoctorWorkloadServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportDoctorAFBD</IdLocation>
<IndexLocation>^CHSSWeb.ReportDoctorAFBI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportDoctorAFBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
