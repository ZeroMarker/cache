Class CHSSWeb.PYCAService Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock ]
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
	Set AccessoryRowId = 0
	
	For  Set AccessoryRowId = $O(^CHSS.PersonYearCheckAccessoryI("YearCheckRowIdParrefIndex",CheckRowId,AccessoryRowId)) q:AccessoryRowId=""  d
	
	.Set tempCheck = ##class(CHSS.PersonYearCheckAccessory).%OpenId(AccessoryRowId)
	
	.Set HB = tempCheck.HB
	.Set WBC = tempCheck.WBC
	.Set PLT = tempCheck.PLT
	.Set CBCOther = tempCheck.CBCOther
	.Set UrineProtein =  tempCheck.UrineProtein
	.Set UrineSugar = tempCheck.UrineSugar
	.Set KET =  tempCheck.KET
	.Set OccultBlood =  tempCheck.OccultBlood
	.Set UrineRoutineOther =  tempCheck.UrineRoutineOther
	
	.Set FecalOccultBlood = ""
	.Set FecalOccultBloodId = ""
	.if tempCheck.FecalOccultBlood '= "" do
	.. Set FecalOccultBlood = tempCheck.FecalOccultBlood.Description
	.. Set FecalOccultBloodId = tempCheck.FecalOccultBlood.%Id()
	
	.Set ALT =   tempCheck.ALT
	.Set AST = tempCheck.AST
	.Set ALB = tempCheck.ALB
	.Set TBIL = tempCheck.TBIL
	.Set DBIL = tempCheck.DBIL
	.Set Globulin = tempCheck.Globulin
	.Set GGT = tempCheck.GGT
	.Set ARP = tempCheck.ARP
	.Set Scr =   tempCheck.Scr
	.Set BUN =  tempCheck.BUN
	.Set CHO = tempCheck.CHO
	.Set TG = tempCheck.TG
	
	.Set LDLC = tempCheck.LDLC
	.Set HDLC = tempCheck.HDLC
	.Set FPG = tempCheck.FPG
	.Set PBG = tempCheck.PBG
	.Set Eyeground =   tempCheck.Eyeground
	
	.Set HBsAg = ""
	.Set HBsAgId = ""
	.if tempCheck.HBsAg '= "" do
	..Set HBsAg = tempCheck.HBsAg.Description
	..Set HBsAgId = tempCheck.HBsAg.%Id()
	
	.Set HbsAb = ""
	.Set HbsAbId = ""
	.if tempCheck.HbsAb '= "" do
	..Set HbsAb = tempCheck.HbsAb.Description
	..Set HbsAbId = tempCheck.HbsAb.%Id()
	
	
	.Set HbAlc = tempCheck.HbAlc
	.Set EyegroundInfo = tempCheck.EyegroundInfo
	.Set Cardiogram =  tempCheck.Cardiogram
	
	.Set CardiogramInfo =   tempCheck.CardiogramInfo
	.Set Sternum = tempCheck.Sternum
	
	.Set SternumSource = ""
	.Set SternumSourceId = ""
	.if tempCheck.SternumSource '= "" do
	..Set SternumSource = tempCheck.SternumSource.Description
	..Set SternumSourceId = tempCheck.SternumSource.%Id()
	
	.Set SternumInfo = tempCheck.SternumInfo
	.Set XRays = tempCheck.XRays
	.Set XRaysInfo =  tempCheck.XRaysInfo
	.Set ImageCheck =  tempCheck.ImageCheck
	.Set Cholesterin = tempCheck.Cholesterin
	.Set OtherCheck = tempCheck.OtherCheck
	.Set PH = tempCheck.PH
	.Set CEA = tempCheck.CEA
	.Set AFP = tempCheck.AFP
	
	.Set tmp= AccessoryRowId_"^"_HB_"^"_WBC_"^"_PLT_"^"_CBCOther_"^"_UrineProtein_"^"_UrineSugar_"^"_KET_"^"_OccultBlood_"^"_UrineRoutineOther_"^"_FecalOccultBlood_"^"_FecalOccultBloodId_"^"_ALT_"^"_AST_"^"_ALB_"^"_TBIL_"^"_DBIL_"^"_Globulin_"^"_GGT_"^"_ARP_"^"_Scr_"^"_BUN_"^"_CHO_"^"_TG _"^"_LDLC_"^"_HDLC_"^"_FPG_"^"_PBG_"^"_Eyeground_"^"_HBsAg_"^"_HBsAgId_"^"_HbsAb_"^"_HbsAbId_"^"_HbAlc_"^"_EyegroundInfo_"^"_Cardiogram_"^"_CardiogramInfo_"^"_Sternum_"^"_SternumSource_"^"_SternumSourceId_"^"_SternumInfo_"^"_XRays_"^"_XRaysInfo_"^"_ImageCheck_"^"_Cholesterin_"^"_OtherCheck_"^"_PH_"^"_CEA_"^"_AFP
	.Set count=count+1
	.If (count>start)&(count<=end) d
    ..d json.InsertRowData(tmp)
	Set resultString = json.getJsonData("AccessoryRowId^HB^WBC^PLT^CBCOther^UrineProtein^UrineSugar^KET^OccultBlood^UrineRoutineOther^FecalOccultBlood^FecalOccultBloodId^ALT^AST^ALB^TBIL^DBIL^Globulin^GGT^ARP^Scr^BUN^CHO^TG ^LDLC^HDLC^FPG^PBG^Eyeground^HBsAg^HBsAgId^HbsAb^HbsAbId^HbAlc^EyegroundInfo^Cardiogram^CardiogramInfo^Sternum^SternumSource^SternumSourceId^SternumInfo^XRays^XRaysInfo^ImageCheck^Cholesterin^OtherCheck^PH^CEA^AFP",count)
	k json
	 	
	Quit resultString
}

ClassMethod existYearCheckRowId(YearCheckRowIdParref As %String) As %String
{
	q:YearCheckRowIdParref="" "-1"
	//s YearCheckRowIdParref =" "_YearCheckRowIdParref
	q:$d(^CHSS.PersonYearCheckAccessoryI("YearCheckRowIdParrefIndex",YearCheckRowIdParref)) "1"
	q "0"
}

ClassMethod Insert(YearCheckRowIdParrefId As %String, HB As %String, WBC As %String, PLT As %String, CBCOther As %String, UrineProtein As %String, UrineSugar As %String, KET As %String, OccultBlood As %String, UrineRoutineOther As %String, ALT As %String, AST As %String, ALB As %String, TBIL As %String, DBIL As %String, Globulin As %String, GGT As %String, ARP As %String, Scr As %String, BUN As %String, FPG As %Float, HBsAgId As %String, HbsAbId As %String, CHO As %String, TG As %String, LDLC As %String, HDLC As %String, Eyeground As %String, EyegroundInfo As %String, Cardiogram As %String, CardiogramInfo As %String, Sternum As %String, SternumInfo As %String, SternumSourceId As %String, FecalOccultBloodId As %String, OtherCheck As %String) As %String
{
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckAccessory).%New()
	q:(tempCheck = "" ) 0
	Set ReturnId = ..existYearCheckRowId(YearCheckRowIdParrefId)
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""相关辅助体检已存在!""}"
	e  d
	.Set tempCheck.YearCheckRowIdParref = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowIdParrefId)
	
	.Set tempCheck.HB  = HB 
	.Set tempCheck.WBC  = WBC 
	.Set tempCheck.PLT  = PLT 
	.Set tempCheck.CBCOther  = CBCOther 
	.Set tempCheck.UrineProtein   = UrineProtein  
	.Set tempCheck.UrineSugar  = UrineSugar 
	.Set tempCheck.KET  = KET
	.Set tempCheck.OccultBlood   = OccultBlood 
	.Set tempCheck.UrineRoutineOther   = UrineRoutineOther  
	.Set tempCheck.ALT   = ALT  
	.Set tempCheck.AST   = AST  
	.Set tempCheck.ALB   = ALB  
	.Set tempCheck.TBIL   = TBIL  
	.Set tempCheck.DBIL  = DBIL 
	.Set tempCheck.Globulin  = Globulin 
	.Set tempCheck.GGT  = GGT 
	.Set tempCheck.ARP  = ARP 
	.Set tempCheck.Scr   = Scr  
	.Set tempCheck.BUN   = BUN 
	.Set tempCheck.FPG    = FPG   
	.Set tempCheck.HBsAg = ##class(CHSS.DictHBVTag).%OpenId(HBsAgId)
	.Set tempCheck.HbsAb = ##class(CHSS.DictHBVTag).%OpenId(HbsAbId)
	.Set tempCheck.CHO   = CHO  
	.Set tempCheck.TG    = TG
	.Set tempCheck.LDLC   = LDLC   
	.Set tempCheck.HDLC    = HDLC    
	.Set tempCheck.Eyeground    = Eyeground  
	.Set tempCheck.EyegroundInfo  = EyegroundInfo 
	.Set tempCheck.Cardiogram   = Cardiogram 
	.Set tempCheck.CardiogramInfo  = CardiogramInfo  
	.Set tempCheck.Sternum   = Sternum  
	.Set tempCheck.SternumSource = ##class(CHSS.DictSternumSource).%OpenId(SternumSourceId)
	.Set tempCheck.SternumInfo   = SternumInfo  
	.Set tempCheck.FecalOccultBlood   = ##class(CHSS.DictFecalOccultBlood).%OpenId(FecalOccultBloodId)
	.Set tempCheck.OtherCheck   = OtherCheck  
	.
	.s result=""
    .s result=tempCheck.%Save()
    
    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
}

ClassMethod Update(AccessoryRowId As %String, YearCheckRowIdParrefId As %String, HB As %String, WBC As %String, PLT As %String, CBCOther As %String, UrineProtein As %String, UrineSugar As %String, KET As %String, OccultBlood As %String, UrineRoutineOther As %String, ALT As %String, AST As %String, ALB As %String, TBIL As %String, DBIL As %String, Globulin As %String, GGT As %String, ARP As %String, Scr As %String, BUN As %String, FPG As %Float, HBsAgId As %String, HbsAbId As %String, CHO As %String, TG As %String, LDLC As %String, HDLC As %String, Eyeground As %String, EyegroundInfo As %String, Cardiogram As %String, CardiogramInfo As %String, Sternum As %String, SternumInfo As %String, SternumSourceId As %String, FecalOccultBloodId As %String, OtherCheck As %String) As %String
{
	q:($d(YearCheckRowIdParrefId)=0)||(YearCheckRowIdParrefId="")
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckAccessory).%OpenId(AccessoryRowId)
	q:(tempCheck = "" ) 0
	
	Set tempCheck.YearCheckRowIdParref = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowIdParrefId)
	
	Set tempCheck.HB  = HB 
	Set tempCheck.WBC  = WBC 
	Set tempCheck.PLT  = PLT 
	Set tempCheck.CBCOther  = CBCOther 
	Set tempCheck.UrineProtein   = UrineProtein  
	Set tempCheck.UrineSugar  = UrineSugar 
	Set tempCheck.KET  = KET
	Set tempCheck.OccultBlood   = OccultBlood 
	Set tempCheck.UrineRoutineOther   = UrineRoutineOther  
	Set tempCheck.ALT   = ALT  
	Set tempCheck.AST   = AST  
	Set tempCheck.ALB   = ALB  
	Set tempCheck.TBIL   = TBIL  
	Set tempCheck.DBIL  = DBIL 
	Set tempCheck.Globulin  = Globulin 
	Set tempCheck.GGT  = GGT 
	Set tempCheck.ARP  = ARP 
	Set tempCheck.Scr   = Scr  
	Set tempCheck.BUN   = BUN 
	Set tempCheck.FPG    = FPG   

	Set tempCheck.HBsAg = ##class(CHSS.DictHBVTag).%OpenId(HBsAgId)
	Set tempCheck.HbsAb = ##class(CHSS.DictHBVTag).%OpenId(HbsAbId)
	Set tempCheck.CHO   = CHO  
	Set tempCheck.TG    = TG
	Set tempCheck.LDLC   = LDLC   
	Set tempCheck.HDLC    = HDLC    
	Set tempCheck.Eyeground    = Eyeground  
	Set tempCheck.EyegroundInfo  = EyegroundInfo 
	Set tempCheck.Cardiogram   = Cardiogram 
	Set tempCheck.CardiogramInfo  = CardiogramInfo  
	Set tempCheck.Sternum   = Sternum  
	Set tempCheck.SternumSource = ##class(CHSS.DictSternumSource).%OpenId(SternumSourceId)
	Set tempCheck.SternumInfo   = SternumInfo  
	Set tempCheck.FecalOccultBlood   = ##class(CHSS.DictFecalOccultBlood).%OpenId(FecalOccultBloodId)
	Set tempCheck.OtherCheck   = OtherCheck    
	
	s result=""
    s result=tempCheck.%Save()
    
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
}

Storage Default
{
<Data name="PYCAServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PYCAServiceD</DataLocation>
<DefaultData>PYCAServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PYCAServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PYCAServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PYCAServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
