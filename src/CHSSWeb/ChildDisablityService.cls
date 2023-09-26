Class CHSSWeb.ChildDisablityService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, CommunityCode)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select a.PersonName as PersonName,a.IDCard as IDCard,a.SexDr->CTSEX_Desc as SexDr,a.Address as Address,a.LinkManPhone as LinkManPhone,c.ItemAssortName as ItemAssortName from CHSS.PersonHealthDiagnose c ,CHSS.ChildBaseInfo b,CHSS.personhealthrecordmain a where c.personrowidparref  =b.personrowid and a.personrowid=b.personrowid    and c.ItemdCode=14 and a.communityCode="_CommunityCode
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		
		s PersonName = result.Get("PersonName")
		
		s IDCard = result.Get("IDCard")
	 
	 	 
	    s SexName= result.Get("SexDr")
	    
	    
	  
	    s Address= result.Get("Address")
	    
	    s LinkManPhone= result.Get("LinkManPhone")
	   
	   
	    s ItemAssortName=result.Get("ItemAssortName")
	    
	    
		s tmp=PersonName_"^"_IDCard_"^"_SexName_"^"_Address_"^"_LinkManPhone_"^"_ItemAssortName
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("PersonName^IDCard^SexName^Address^LinkManPhone^ItemAssortName",count)
	k json
	q resultString
}

Storage Default
{
<Data name="ChildDisablityServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildDisablityServiceD</DataLocation>
<DefaultData>ChildDisablityServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildDisablityServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ChildDisablityServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ChildDisablityServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
