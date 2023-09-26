Class CHSSWeb.PersonStatService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-01-
/// Description: 社区档案统计信息
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetStatInfo(CommunityCode As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct VillageName from CHSS.FamilyHealthRecord where VillageName is not null and CommunityCode ="_CommunityCode
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
    Set tmp = ""
	
	k ^TMPStatVillage

	While(result.Next())
	{
		s ^TMPStatVillage(result.Data("VillageName")) = ""
    }
    
    d result.Close()
              
    set VillageName=0
    set PersonRecordAllNum=0
    set WomanArcAllNum=0
    set ElderArcAllNum=0
    set HBPArcAllNum=0
    set DiabeteArcAllNum=0
    set SchizoArcAllNum=0
    set ChildArcAllNum=0
    set HandicappedArcAllNum=0
    
    
    For  {
	 Set VillageName=$O(^TMPStatVillage(VillageName))
	 q:VillageName=""
     s sqlStr = "select PersonRowId from CHSS.PersonHealthRecordMain where FamilyRowId->VillageName='"_VillageName_"' and CommunityCode ="_CommunityCode  
     ;w sqlStr
     ;q:"1=1"
     s result = ##class(%Library.ResultSet).%New()
     d result.Prepare(sqlStr)
	 d result.Execute()
	 
	 s PersonRecordNum=0
	 set personRowIds=""
	 set char=""
	 
	 While(result.Next()){
 	  
 	  s personRowIds=personRowIds_char_result.Data("PersonRowId")
 	  s char=", "
 	  s PersonRecordNum=PersonRecordNum+1
 	 }
 	 
 	 d result.Close()
 	 	 
	 if personRowIds'="" d
	 .s WomanArcNum=..GetArcNum(personRowIds, "Woman")
	 .s ElderArcNum=..GetArcNum(personRowIds, "Elder")
	 .s HBPArcNum=..GetArcNum(personRowIds, "HBP")
	 .s DiabeteArcNum=..GetArcNum(personRowIds, "Diabete")
	 .s SchizoArcNum=..GetArcNum(personRowIds, "Schizo")
	 .s ChildArcNum=..GetArcNum(personRowIds, "Child")
	 .s HandicappedArcNum=..GetArcNum(personRowIds, "Handicapped")
	 e  d
	 .s WomanArcNum=0
	 .s ElderArcNum=0
	 .s HBPArcNum=0
	 .s DiabeteArcNum=0
	 .s SchizoArcNum=0
	 .s ChildArcNum=0
	 .s HandicappedArcNum=0
	 
	 
     s PersonRecordAllNum=PersonRecordAllNum+PersonRecordNum
     s WomanArcAllNum=WomanArcAllNum+WomanArcNum
     s ElderArcAllNum=ElderArcAllNum+ElderArcNum
     s HBPArcAllNum=HBPArcAllNum+HBPArcNum
     s DiabeteArcAllNum=DiabeteArcAllNum+DiabeteArcNum
     s SchizoArcAllNum=SchizoArcAllNum+SchizoArcNum
     s ChildArcAllNum=ChildArcAllNum+ChildArcNum
     s HandicappedArcAllNum=HandicappedArcAllNum+HandicappedArcNum
     
     
     Set tmp = VillageName_"^"_PersonRecordNum_"^"_WomanArcNum_"^"_ElderArcNum_"^"_HBPArcNum_"^"_DiabeteArcNum_"^"_SchizoArcNum_"^"_ChildArcNum_"^"_HandicappedArcNum
    
     Set count=count+1
     If (count>start)&(count<=end) d
     .d json.InsertRowData(tmp)
    }
    
    
    Set tmp = "合计"_"^"_PersonRecordAllNum_"^"_WomanArcAllNum_"^"_ElderArcAllNum_"^"_HBPArcAllNum_"^"_DiabeteArcAllNum_"^"_SchizoArcAllNum_"^"_ChildArcAllNum_"^"_HandicappedArcAllNum
    
    Set count=count+1
    If (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
         
    Set resultString = json.getJsonData("VillageName^PersonRecordNum^WomanArcNum^ElderArcNum^HBPArcNum^DiabeteArcNum^SchizoArcNum^ChildArcNum^HandicappedArcNum",count)
    k json
      
    Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-01-
/// Description: 健康档案建档数量
/// Table：
/// Input: 
/// Output：
/// Return：
/// Others：
ClassMethod GetArcNum(PersonRowIds As %String, ArcType As %String) As %Integer
{
      
    s result = ##class(%Library.ResultSet).%New()
    if ArcType="Woman" d
	.s sqlStr = "select count(distinct PersonRowIdParref) as Num from CHSS.WomenBaseInfo where PersonRowIdParref in ("_PersonRowIds_") "
	e  i ArcType="Elder" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.ElerlyBaseInfo where PersonRowId in ("_PersonRowIds_") "
	e  i ArcType="HBP" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where PersonRowId in ("_PersonRowIds_") and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '高血压')"
	e  i ArcType="Diabete" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where PersonRowId in ("_PersonRowIds_") and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '糖尿病')"
	e  i ArcType="Schizo" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where PersonRowId in ("_PersonRowIds_") and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '22' and ItemAssortName = '精神病')"
	e  i ArcType="Child" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.ChildBaseInfo where PersonRowId in ("_PersonRowIds_") "
	e  i ArcType="Handicapped" d
	.s sqlStr = "select count(distinct PersonRowId) as Num from CHSS.PersonHealthRecordMain where PersonRowId in ("_PersonRowIds_") and PersonRowId in (select PersonRowIdParref from CHSS.PersonHealthDiagnose where ItemdCode = '14')"
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next())
	{
		s ArcNum=result.Data("Num")
    }
    
    d result.Close()
    
    Quit ArcNum
}

Storage Default
{
<Data name="PersonStatServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonStatServiceD</DataLocation>
<DefaultData>PersonStatServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonStatServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonStatServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonStatServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
