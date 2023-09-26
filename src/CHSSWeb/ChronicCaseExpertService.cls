Class CHSSWeb.ChronicCaseExpertService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:慢病病例记录
/// Table：ChronicCaseExpert
/// Input: ChronicCaseExpert
/// Output：
/// Return：
/// Others： 
ClassMethod List(start As %Integer, limit As %Integer, sort As %String, chronicType As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CaseRowId, ControlRowIdParref, ControlRowIdParref->Situation As Situation, DealRowIdParref, DealRowIdParref->Deal As Deal, CheckRowId, CheckRowId->Content As Content, bHistory, ChronicType from CHSS.ChronicCaseExpert where ChronicType="_chronicType
    
        
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
			
	s CaseRowId = result.Data("CaseRowId")
	s ControlRowIdParref = result.Data("ControlRowIdParref")	
	s Situation = result.Data("Situation")
	s DealRowIdParref = result.Data("DealRowIdParref")
	s Deal = result.Data("Deal")
	s CheckRowId = result.Data("CheckRowId")	
	s Content= result.Data("Content")	
			
	s bHistory = result.Data("bHistory")
		
	s ChronicType = result.Data("ChronicType")
	s ChronicTypeName = ""
	i ChronicType '= "" d
	.i ChronicType = 1 d
	..s ChronicTypeName = "高血压"
	.e  i ChronicType = 2 d
	..s ChronicTypeName = "糖尿病"
	
			
	s tmp=CaseRowId_"^"_ControlRowIdParref_"^"_Situation_"^"_DealRowIdParref_"^"_Deal_"^"_CheckRowId_"^"_Content_"^"_bHistory_"^"_ChronicType_"^"_ChronicTypeName
			
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("CaseRowId^ControlRowIdParref^Situation^DealRowIdParref^Deal^CheckRowId^Content^bHistory^ChronicType^ChronicTypeName",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:添加慢病病例记录
/// Table：ChronicCaseExpert
/// Input: ChronicCaseExpert
/// Output：
/// Return：
/// Others： 
ClassMethod Insert(ControlRowIdParref As %Integer, DealRowIdParref As %Integer, CheckRowId As %Integer, bHistory As %String, ChronicType As %Integer) As %String
{
    
	&sql(insert into CHSS.ChronicCaseExpert (ControlRowIdParref, DealRowIdParref, CheckRowId, bHistory, ChronicType) values(:ControlRowIdParref,:DealRowIdParref,:CheckRowId,:bHistory,:ChronicType))
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s RowId=%ROWID
    .s resultString = "{""success"":""true"",""info"":"_RowId_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:更新慢病病例记录
/// Table：ChronicCaseExpert
/// Input: CaseRowId
/// Output：
/// Return：
/// Others：
ClassMethod Update(CaseRowId As %Integer, ControlRowIdParref As %Integer, DealRowIdParref As %Integer, CheckRowId As %Integer, bHistory As %String, ChronicType As %Integer) As %String
{
	&sql(update CHSS.ChronicCaseExpert set ControlRowIdParref=:ControlRowIdParref, DealRowIdParref=:DealRowIdParref, CheckRowId=:CheckRowId, bHistory=:bHistory, ChronicType=:ChronicType  where %ID=:CaseRowId)
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_CaseRowId_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:删除慢病病例记录
/// Table：ChronicCaseExpert
/// Input: CaseRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(CaseRowId As %String) As %String
{
	&sql(delete from CHSS.ChronicCaseExpert where %ID=:CaseRowId)
    s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_CaseRowId_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
    q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:检索血糖血压控制情况
/// Table：ChronicControl
/// Input: ChronicControl
/// Output：
/// Return：
/// Others：
ClassMethod ListChronicControl(start As %Integer, limit As %Integer, chronicType As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ControlRowId,Situation,ChronicType FROM CHSS.ChronicControl where ChronicType="_chronicType
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s ControlRowId = result.Data("ControlRowId")
	s Situation= result.Data("Situation")
	s ChronicType= result.Data("ChronicType")
	Set tmp=ControlRowId_"^"_Situation_"^"_ChronicType
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("ControlRowId^Situation^ChronicType",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:检索慢性病随访处理情况
/// Table：ChronicDeal
/// Input: ChronicDeal
/// Output：
/// Return：
/// Others：
ClassMethod ListChronicDeal(start As %Integer, limit As %Integer, chronicType As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DealRowId,Deal,ChronicType,NextCheck FROM CHSS.ChronicDeal where ChronicType="_chronicType
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s DealRowId = result.Data("DealRowId")
	s Deal= result.Data("Deal")
	s ChronicType= result.Data("ChronicType")
	s NextCheck= result.Data("NextCheck")
	Set tmp=DealRowId_"^"_Deal_"^"_ChronicType_"^"_NextCheck
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("DealRowId^Deal^ChronicType^NextCheck",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: lyy
/// CreatDate：2010—04-
/// Description:检索血糖血压监测满意情况
/// Table：ChronicPressureSugerSituation
/// Input: ChronicPressureSugerSituation
/// Output：
/// Return：
/// Others：
ClassMethod ListChronicPressureSuger(start As %Integer, limit As %Integer, chronicType As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CheckRowId,Content,ChronicType FROM CHSS.ChronicPressureSugerSituation where ChronicType="_chronicType
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s CheckRowId = result.Data("CheckRowId")
	s Content= result.Data("Content")
	s ChronicType= result.Data("ChronicType")
	Set tmp=CheckRowId_"^"_Content_"^"_ChronicType
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("CheckRowId^Content^ChronicType",count)
	
	k json
	d result.Close()
	q resultString
}

Storage Default
{
<Data name="ChronicCaseExpertServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChronicCaseE98BD</DataLocation>
<DefaultData>ChronicCaseExpertServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChronicCaseE98BD</IdLocation>
<IndexLocation>^CHSSWeb.ChronicCaseE98BI</IndexLocation>
<StreamLocation>^CHSSWeb.ChronicCaseE98BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
