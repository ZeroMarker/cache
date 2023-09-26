Class CHSSWeb.ReportChildServices Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod HeightWeightList(ChildRowId As %String) As %String
{

	 	Set sqlStr = "select t.CheckMonth ,t.Height,t.Weight ,"
		Set sqlStr =sqlStr _" st.childhigha,st.childhighb,st.childhighc,st.childhighd,"
		Set sqlStr =sqlStr _" st.childweigha,st.childweighb,st.childweighc,st.childweighd  from ("
		Set sqlStr =sqlStr _" SELECT c.CheckMonth ,c.Height,c.Weight,(select b.sex from chss.ChildBaseInfo b"
		Set sqlStr =sqlStr _" where b.ChildRowId=c.ChildRowId)as sex FROM CHSS.CHILDCHECKRECORD c WHERE CHILDROWID='"_ChildRowId_"' ) t ,"
		Set sqlStr =sqlStr _" (select aa.childsex as childsex,aa.childage as childage,aa.childhigh as childhigha,bb.childhigh as childhighb,cc.childhigh as childhighc,dd.childhigh as childhighd,"
		Set sqlStr =sqlStr _" aa.childweigh as childweigha,bb.childweigh as childweighb,cc.childweigh as childweighc,dd.childweigh as childweighd from"
		Set sqlStr =sqlStr _" (select  a.childsex as childsex,a.childage as childage,a.childhigh as childhigh,a.childweigh as childweigh from chss.ChildGrowthStandard a where a.childid='1') aa,"
		Set sqlStr =sqlStr _" (select b.childsex as childsex,b.childage as childage,b.childhigh as childhigh,b.childweigh as childweigh from chss.ChildGrowthStandard b where b.childid='2') bb,"
		Set sqlStr =sqlStr _" (select c.childsex as childsex,c.childage as childage,c.childhigh as childhigh,c.childweigh as childweigh from chss.ChildGrowthStandard c where c.childid='3') cc,"
		Set sqlStr =sqlStr _" (select d.childsex as childsex,d.childage as childage,d.childhigh as childhigh,d.childweigh as childweigh from chss.ChildGrowthStandard d where d.childid='4')dd"
		Set sqlStr =sqlStr _" where aa.childage=bb.childage and aa.childage=cc.childage and aa.childage=dd.childage and aa.childsex=bb.childsex and aa.childsex=cc.childsex and aa.childsex=dd.childsex) st"
		Set sqlStr =sqlStr _" where t.CheckMonth=st.childage and t.sex = st.childsex"
	 
		Set count =0
	    Set resultString = ""	 
		Set json = ##class(Code.JsonObj).%New()
		Set result = ##class(%Library.ResultSet).%New()
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		Set Checkmonth = result.Get("CheckMonth")
		Set Height = result.Get("Height")
		Set Weight = result.Get("Weight") 
		Set Heighta = result.Get("childhigha")
		Set Heightb = result.Get("childhighb")
		Set Heightc = result.Get("childhighc")
		Set Heightd = result.Get("childhighd")
		Set Weighta = result.Get("childweigha")
		Set Weightb = result.Get("childweighb")
		Set Weightc = result.Get("childweighc")
		Set Weightd = result.Get("childweighd") 
	    Set tmp= Checkmonth_"^"_Height_"^"_Weight_"^"_Heighta_"^"_Heightb_"^"_Heightc_"^"_Heightd_"^"_Weighta_"^"_Weightb_"^"_Weightc_"^"_Weightd
	    
	    Set count=count+1
		d json.InsertRowData(tmp)
		}		
	    Set resultString = json.getJsonData("Checkmonth^Height^Weight^Heighta^Heightb^Heightc^Heightd^Weighta^Weightb^Weightc^Weightd",count)
	 	k json	 	
		Quit resultString
}

Storage Default
{
<Data name="ReportChildServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportChildServicesD</DataLocation>
<DefaultData>ReportChildServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportChildServicesD</IdLocation>
<IndexLocation>^CHSSWeb.ReportChildServicesI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportChildServicesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
