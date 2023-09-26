Class CHSSWeb.PYCSService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(CheckRowId As %String) As %String
{
	
	Set CheckRowId = $G( CheckRowId )
	Set start = 0
	Set limit = 1
	Set end   = start + limit 
	Set count = 0
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()
	Set SpecialRowId = 0
	
	For  Set SpecialRowId = $O(^CHSS.PersonYearCheckSpecialI("YearCheckRowIdParrefIndex",CheckRowId,SpecialRowId)) q:SpecialRowId=""  d
	
	.Set tempCheck = ##class(CHSS.PersonYearCheckSpecial).%OpenId(SpecialRowId)
	
	.Set DorsumArteriopalums  = tempCheck.DorsumArteriopalums
	.Set GlycosylatedHemoglobin  = tempCheck.GlycosylatedHemoglobin 
	
	.Set FPG  =  tempCheck.FPG 
	.Set K  = tempCheck.K 
	.Set Na  =  tempCheck.Na 
	
	.Set Cough  = ""
	.Set CoughId = ""
	.if tempCheck.Cough  '= "" do
	.. Set Cough  = tempCheck.Cough.Description
	.. Set CoughId = tempCheck.Cough.%Id()
	
	.Set Phlegm  = ""
	.Set PhlegmId = ""
	.if tempCheck.Phlegm '= "" do
	.. Set Phlegm = tempCheck.Phlegm.Description
	.. Set PhlegmId = tempCheck.Phlegm.%Id()
	
	.Set Dyspnea  = ""
	.Set DyspneaId = ""
	.if tempCheck.Dyspnea '= "" do
	.. Set Dyspnea = tempCheck.Dyspnea.Description
	.. Set DyspneaId = tempCheck.Dyspnea.%Id()
	
	.Set CyanOticLips  = tempCheck.CyanOticLips 
	.Set JugularVein  = tempCheck.JugularVein 
	
	.Set WheezingRale  = ""
	.Set WheezingRaleId = ""
	.if tempCheck.WheezingRale '= "" do
	.. Set WheezingRale = tempCheck.WheezingRale.Description
	.. Set WheezingRaleId = tempCheck.WheezingRale.%Id()
	
	.Set WalkDistanceInSix  = tempCheck.WalkDistanceInSix 
	.Set SaO2  =   tempCheck.SaO2 
	.Set FEV1toFVC  =  tempCheck.FEV1toFVC 
	.Set FEV1  = tempCheck.FEV1 
	.Set SGRQ  = tempCheck.SGRQ 
	
	.Set tmp= SpecialRowId_"^"_DorsumArteriopalums_"^"_GlycosylatedHemoglobin_"^"_FPG_"^"_K_"^"_Na_"^"_Cough_"^"_CoughId_"^"_Phlegm_"^"_PhlegmId_"^"_Dyspnea_"^"_DyspneaId_"^"_CyanOticLips_"^"_JugularVein_"^"_WheezingRale_"^"_WheezingRaleId_"^"_WalkDistanceInSix_"^"_SaO2_"^"_FEV1toFVC_"^"_FEV1_"^"_SGRQ
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	Set resultString = json.getJsonData("SpecialRowId^DorsumArteriopalums^GlycosylatedHemoglobin^FPG^K^Na^Cough^CoughId^Phlegm^PhlegmId^Dyspnea^DyspneaId^CyanOticLips^JugularVein^WheezingRale^WheezingRaleId^WalkDistanceInSix^SaO2^FEV1toFVC^FEV1^SGRQ",count)
	k json
	 	
	Quit resultString
}

ClassMethod existYearCheckRowId(YearCheckRowIdParref As %String) As %String
{
	q:YearCheckRowIdParref="" "-1"
	//s YearCheckRowIdParref =" "_YearCheckRowIdParref
	q:$d(^CHSS.PersonYearCheckSpecialI("YearCheckRowIdParrefIndex",YearCheckRowIdParref)) "1"
	q "0"
}

ClassMethod Insert(YearCheckRowIdParrefId As %String, DorsumArteriopalums As %String, GlycosylatedHemoglobin As %String, FPG As %String, K As %String, Na As %String, CoughId As %String, PhlegmId As %String, DyspneaId As %String, CyanOticLips As %String, JugularVein As %String, WheezingRaleId As %String, WalkDistanceInSix As %Integer, SaO2 As %Float, FEV1toFVC As %Float, FEV1 As %Float, SGRQ As %Float) As %String
{
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckSpecial).%New()
	q:(tempCheck = "" ) 0
	Set ReturnId = ..existYearCheckRowId(YearCheckRowIdParrefId)
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""相关特殊体检已存在!""}"
	e  d
	.Set tempCheck.YearCheckRowIdParref = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowIdParrefId)
	.Set tempCheck.DorsumArteriopalums   = DorsumArteriopalums  
	.Set tempCheck.GlycosylatedHemoglobin    = GlycosylatedHemoglobin   
	.Set tempCheck.FPG   = FPG  
	.Set tempCheck.K  = K
	.Set tempCheck.Na   = Na  
	.Set tempCheck.Cough   = ##class(CHSS.DictChogh).%OpenId(CoughId ) 
	.Set tempCheck.Phlegm   = ##class(CHSS.DictExpectoration).%OpenId(PhlegmId  ) 
	.Set tempCheck.Dyspnea  = ##class(CHSS.DictDyspnea).%OpenId(DyspneaId  ) 
	.Set tempCheck.CyanOticLips  = CyanOticLips  
	.Set tempCheck.JugularVein   = JugularVein   
	.Set tempCheck.WheezingRale  = ##class(CHSS.DictWheezingRale).%OpenId(WheezingRaleId )
	.Set tempCheck.WalkDistanceInSix   = WalkDistanceInSix  
	.Set tempCheck.SaO2   = SaO2   
	.Set tempCheck.FEV1toFVC    = FEV1toFVC   
	.Set tempCheck.FEV1    = FEV1   
	.Set tempCheck.SGRQ    = SGRQ   
	
	.s result=""
    .s result=tempCheck.%Save()
    
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod Update(SpecialRowId As %String, YearCheckRowIdParrefId As %String, DorsumArteriopalums As %String, GlycosylatedHemoglobin As %String, FPG As %String, K As %String, Na As %String, CoughId As %String, PhlegmId As %String, DyspneaId As %String, CyanOticLips As %String, JugularVein As %String, WheezingRaleId As %String, WalkDistanceInSix As %Integer, SaO2 As %Float, FEV1toFVC As %Float, FEV1 As %Float, SGRQ As %Float) As %String
{

	q:($d(YearCheckRowIdParrefId)=0)||(YearCheckRowIdParrefId="")
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckSpecial).%OpenId(SpecialRowId)
	q:(tempCheck = "" ) 0
	
	Set tempCheck.YearCheckRowIdParref = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowIdParrefId)
	
	Set tempCheck.DorsumArteriopalums   = DorsumArteriopalums  
	Set tempCheck.GlycosylatedHemoglobin    = GlycosylatedHemoglobin   
	Set tempCheck.FPG   = FPG  
	Set tempCheck.K  = K
	Set tempCheck.Na   = Na  
	Set tempCheck.Cough   = ##class(CHSS.DictChogh).%OpenId(CoughId ) 
	Set tempCheck.Phlegm   = ##class(CHSS.DictExpectoration).%OpenId(PhlegmId  ) 
	Set tempCheck.Dyspnea  = ##class(CHSS.DictDyspnea).%OpenId(DyspneaId  ) 
	Set tempCheck.CyanOticLips  = CyanOticLips  
	Set tempCheck.JugularVein   = JugularVein   
	Set tempCheck.WheezingRale  = ##class(CHSS.DictWheezingRale).%OpenId(WheezingRaleId )
	Set tempCheck.WalkDistanceInSix   = WalkDistanceInSix  
	Set tempCheck.SaO2   = SaO2   
	Set tempCheck.FEV1toFVC    = FEV1toFVC   
	Set tempCheck.FEV1    = FEV1   
	Set tempCheck.SGRQ    = SGRQ    
	
	s result=""
    s result=tempCheck.%Save()
    
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

Storage Default
{
<Data name="PYCSServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PYCSServiceD</DataLocation>
<DefaultData>PYCSServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PYCSServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PYCSServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PYCSServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
