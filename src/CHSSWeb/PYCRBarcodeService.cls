Class CHSSWeb.PYCRBarcodeService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(YearCheckRowId As %String, PersonRowId As %String, IsExist As %String) As %String
{
	 
	Set YearCheckRowId = $G( YearCheckRowId )
	Set PersonRowId = $G( PersonRowId )

    ;w IsExist,!
     if IsExist="0" d ..InsertBarcode(YearCheckRowId,PersonRowId)  //如果Isprint为0 表示未生成过条形码记录，则先生成记录 
    
    
	Set resultString = ""
	Set json  = ##class(Code.JsonObj).%New()
	Set BarcodeRowId = 0
    Set count=0
     
     
     Set sqlStr = "SELECT C.BARCODETYPE,T.DESCRIPTION, C.BARCODE  FROM CHSS.CHECKUPBARCODERECORD C,CHSS.DICTBARCODETYPE T WHERE C.YEARCHECKROWID='"_YearCheckRowId_"' AND C.BARCODETYPE=T.CODE ORDER BY C.BARCODETYPE"
   
     Set result = ##class(%Library.ResultSet).%New()
	 d result.Prepare(sqlStr)
	  d result.Execute()
	While(result.Next())
	{
     	s BarcodeType = result.Get("BarcodeType")
     	s Description = result.Get("Description")
     	s Barcode = result.Get("Barcode")
     	Set tmp = BarcodeType_"^"_Description_"^"_Barcode
	 
        d json.InsertRowData(tmp)
     	s count=count+1
	}
	d result.Close()    
	 
    
	Set resultString = json.getJsonData("BarcodeType^Description^Barcode",count)
	k json	
	Quit resultString
}

ClassMethod Print(YearCheckRowId As %String) As %String
{
	 Set YearCheckRowId = $G( YearCheckRowId )
	 Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowId)
	i tempCheck.IsPrint'="" do
	 set tempCheck.IsPrint= tempCheck.IsPrint+1
	 e  set tempCheck.IsPrint= 0
	 
	s result=""
    s result=tempCheck.%Save()
    
    i result = "1" d
     .w "{""success"":""true"",""info"":""数据保存出错!""}"
    
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
  q ""
}

ClassMethod Insert(PersonRowIdParref As %String, DateCheck As %Date, CheckDoctor As %String, Symptom As %String, Temperature As %Float, Pulse As %Integer, Breath As %Integer, nHighPressure As %Integer, nLowPressure As %Integer, Height As %Float, Weight As %Float, BMI As %Float, WaistlineStern As %Float, OlderCongnizeId As %String, OlderCongnizeScore As %String, OlderSensibilityId As %String, LiveQuality As %String, OlderSensibilityScore As %String, LeftEyesight As %Float, RightEyesight As %Float, LeftCorrectEyesight As %Float, RightCorrectEyesight As %Float, HearingId As %String, MovementId As %String, SkinId As %String, ScrofulaId As %String, ScrofulaOther As %String, bBarrelChestId As %String, BreathSounds As %String, BreathSoundsInfo As %String, Rale As %String, RaleInfo As %String, HeartRate As %String, CardiacRhythmId As %String, Souffle As %String, SouffleInfo As %String, Tenderness As %String, TendernessInfo As %String, EnclosedMass As %String, EnclosedMassInfo As %String, Hepatauxe As %String, HepatauxeInfo As %String, Splenomegaly As %String, SplenomegalyInfo As %String, ShiftingDullness As %String, ShiftingDullnessInfo As %String, EdemaOfLimbsId As %String, AnusId As %String, AnusOther As %String, ProstateId As %String, ProstateInfo As %String, Other As %String) As %String
{
	Set tempCheck = ""
	Set tempCheck = ##class(CHSS.PersonYearCheckRecord).%New()
	q:(tempCheck = "" ) 0
	
	Set ReturnId = ..existPersonRowId(PersonRowIdParref)
	
	i (ReturnId'="0") d
	.w "{""success"":""false"",""info"":""个人编码: "_ReturnId_" 已存在! 请重新输入!""}"
	e  d
	.Set tempCheck.PersonRowIdParref = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	

	.i DateCheck '= "" do
	..Set tempCheck.DateCheck = $zdh(DateCheck,3)
	.Set tempCheck.CheckDoctor = CheckDoctor
	.Set tempCheck.Symptom = Symptom
	.Set tempCheck.Temperature = Temperature
	.Set tempCheck.Pulse = Pulse
	.Set tempCheck.Breath  = Breath 
	.Set tempCheck.nHighPressure = nHighPressure
	.Set tempCheck.nLowPressure = nLowPressure
	.Set tempCheck.Height  = Height 
	.Set tempCheck.Weight = Weight
	.Set tempCheck.BMI  = BMI
	.Set tempCheck.WaistlineStern  = WaistlineStern
	.Set tempCheck.OlderCongnize = ##class(CHSS.DictCognitiveAbility).%OpenId(OlderCongnizeId)
	.Set tempCheck.OlderCongnizeScore  = OlderCongnizeScore 
	.Set tempCheck.OlderSensibility  = ##class(CHSS.DictAffectiveState).%OpenId(OlderSensibilityId) 
	.Set tempCheck.OlderSensibilityScore  = OlderSensibilityScore 
	.Set tempCheck.LiveQuality  = LiveQuality 
	.Set tempCheck.LeftEyesight   = LeftEyesight  
	.Set tempCheck.RightEyesight   = RightEyesight  
	.Set tempCheck.LeftCorrectEyesight  = LeftCorrectEyesight 
	.Set tempCheck.RightCorrectEyesight   = RightCorrectEyesight 
	.Set tempCheck.Hearing = ##class(CHSS.DictHearing).%OpenId(HearingId)
	.Set tempCheck.Movement  = ##class(CHSS.DictMotorFunction).%OpenId(MovementId) 

	.Set tempCheck.Skin = ##class(CHSS.DictSkin).%OpenId(SkinId)
	.Set tempCheck.Scrofula  = ##class(CHSS.DictLymphNodes).%OpenId(ScrofulaId) 
	.Set tempCheck.ScrofulaOther  = ScrofulaOther 
	.Set tempCheck.bBarrelChest   =  ##class(CHSS.DictBarrelChest).%OpenId(bBarrelChestId)  
	.Set tempCheck.BreathSounds  = BreathSounds 
	.Set tempCheck.BreathSoundsInfo   = BreathSoundsInfo 	
	
	.Set tempCheck.Rale  = Rale 
	.Set tempCheck.RaleInfo   = RaleInfo 
	.Set tempCheck.HeartRate  = HeartRate 
	.Set tempCheck.CardiacRhythm   = ##class(CHSS.DictCardiacRhythm).%OpenId(CardiacRhythmId)  
	.Set tempCheck.Souffle   = Souffle   
	.Set tempCheck.SouffleInfo    = SouffleInfo   
	.Set tempCheck.Tenderness   = Tenderness 
	.Set tempCheck.TendernessInfo    = TendernessInfo 
	.Set tempCheck.EnclosedMass   = EnclosedMass 
	.Set tempCheck.EnclosedMassInfo    = EnclosedMassInfo  
	.Set tempCheck.Hepatauxe   = Hepatauxe  
	.Set tempCheck.HepatauxeInfo    = HepatauxeInfo   
	.Set tempCheck.Splenomegaly    = Splenomegaly    
	.Set tempCheck.SplenomegalyInfo     = SplenomegalyInfo    
	.Set tempCheck.ShiftingDullness    = ShiftingDullness  
	.Set tempCheck.ShiftingDullnessInfo     = ShiftingDullnessInfo 	
	.Set tempCheck.EdemaOfLimbs    = ##class(CHSS.DictLowerExtremityEdema).%OpenId(EdemaOfLimbsId)  
	.Set tempCheck.Anus     = ##class(CHSS.DictAnus).%OpenId(AnusId)   
	.Set tempCheck.AnusOther    = AnusOther   
	.Set tempCheck.Prostate    = ##class(CHSS.DictProstate).%OpenId(ProstateId )
	.Set tempCheck.ProstateInfo     = ProstateInfo
	.Set tempCheck.Other = Other
	.s result=""
    .s result=tempCheck.%Save()

    .i result = "1" d
    ..w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
    /*
	.Set tempCheck.Dentition = ##class(CHSS.DictDentition).%OpenId(DentitionId)
	.Set tempCheck.PharyngealCheck  = PharyngealCheck 
	.Set tempCheck.WaistlineStern  = WaistlineStern 	
	.Set tempCheck.LiveQuality  = LiveQuality  
	     
	
	.if BookingDate '= "" d
	..Set BookingDate  = $zdh(BookingDate ,3) 
	.Set tempCheck.BookingDate = BookingDate
	
	.Set tempCheck.bBooking      = bBooking     
	.Set tempCheck.BloodSurgeLimosis     = BloodSurgeLimosis   
	.Set tempCheck.Cholesterin      = Cholesterin 
	 
	.Set tempCheck.MentalityAdjust    = MentalityAdjust  
	.Set tempCheck.CheckResult     = CheckResult   
	.Set tempCheck.Deal    = Deal   
	.Set tempCheck.StaffInput     = ##class(User.SSUser).%OpenId(StaffInputId)    
	.Set tempCheck.Other    = Other    
	*/
}

//添加 条形码记录

/**
（1）调查表     0
（2）机读卡     0
（3）检验单     0
（4）采血管     0
（5）血浆0.5    1
（6）血浆1.5    1
（7）白细胞     2
（8）备用       0
    结核        3  
 
21        23      01      01        09       1       1           00001   
省邮编  县邮编  镇邮编  村编号      年份  随访次数  样品类型  个体编号  

**/
ClassMethod InsertBarcode(YearCheckRowId As %String, PersonRowId As %String) As %String
{
 
	 s temPersonInfo = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	 s FamilyRowId= temPersonInfo.FamilyRowId
	 s Birthdate= temPersonInfo.Birth
	 s ProvinceCode = "00"
	 s SectionCode = "00"
	 s StreetCode = "00"
	 s VillageCode = "00"
	 i FamilyRowId '= "" d
	  .//s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	  .i FamilyRowId.ProvinceDR '= "" d
	   ..s ProvinceCode = ProvinceCode_FamilyRowId.ProvinceDR.Code
	   ..s ProvinceCode =$E(ProvinceCode,$L(ProvinceCode)-1,$L(ProvinceCode))
	  .i FamilyRowId.SectionDR '= "" d
	   ..s SectionCode = SectionCode_FamilyRowId.SectionDR.Code
	   ..s SectionCode =$E(SectionCode,$L(SectionCode)-1,$L(SectionCode))
	  .i FamilyRowId.StreetDR '= "" d
	   ..s StreetCode = StreetCode_FamilyRowId.StreetDR.Code
	   ..s StreetCode = $E(StreetCode,$L(StreetCode)-1,$L(StreetCode))
	  .i FamilyRowId.VillageDR '= "" d
	   ..s VillageCode = VillageCode_FamilyRowId.VillageDR.Code
	   ..s VillageCode = $E(VillageCode,$L(VillageCode)-1,$L(VillageCode))
	 ;前八位编码
	 s zonecode = ProvinceCode_SectionCode_StreetCode_VillageCode
	 
	 ;年份 
	 s DateCheck = ##class(CHSS.PersonYearCheckRecord).%OpenId(YearCheckRowId).DateCheck
	 s year = $E($ZD(DateCheck,8),3,4)
	 ;随访次数 
	 s result = ##class(%Library.ResultSet).%New()
	 s sqlStr = " select count(*) as count from CHSS.PersonYearCheckRecord a where   a.PersonRowIdParref= '"_PersonRowId_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
     	s times = result.GetData(1)
	}
	d result.Close()
	 
	 ;个体编号
	 s personcode = ##class(CHSSWeb.SystemIdService).GetSystemId3(zonecode,"PersonYearCheckRecord")

     s barcode = zonecode_year_times
    
	Set $ZT="ERROR"	
	TSTART			
    ;0	调查表1
    ;BarcodeType 为CHSS.dictBarcodeType表的code字段，不是主键
     &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'1',:barcode_'0'_:personcode))
 	i SQLCODE TROLLBACK
	;0	机读卡2
	 &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'2',:barcode_'0'_:personcode))
     i SQLCODE TROLLBACK
	;0	检验单3
	 &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'3',:barcode_'0'_:personcode))
 	i SQLCODE TROLLBACK
	;0	采血管4
	 &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'4',:barcode_'0'_:personcode))
 	i SQLCODE TROLLBACK
  	;1	血浆0.5 5
     &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'5',:barcode_'1'_:personcode))
 	 i SQLCODE TROLLBACK
	 ;1	血浆1.5 6   
	  &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'6',:barcode_'1'_:personcode)) 
  	  i SQLCODE TROLLBACK
  	  ;7	白细胞7   
	  &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'7',:barcode_'2'_:personcode)) 
  	  i SQLCODE TROLLBACK
  	  ;0	备用8   
	  &sql(insert into CHSS.CheckUpBarcodeRecord (YearCheckRowId,PersonRowId,BarcodeType,Barcode) values(:YearCheckRowId,:PersonRowId,'8',:barcode_'0'_:personcode)) 
  	  i SQLCODE TROLLBACK
	 TCOMMIT
	 q "1"	
ERROR	 	          
 	TROLLBACK		       
 	Quit "-1"
}

ClassMethod existPersonRowId(PersonRowId As %String) As %String
{
	q:PersonRowId="" "-1"
	s PersonRowId=" "_PersonRowId
	q:$d(^CHSS.PersonYearCheckRecordI("PersonRowIdParrefIndex",PersonRowId)) "1"
	q "0"
}

ClassMethod Delete(CheckRowId As %String) As %String
{
	&sql(delete from CHSS.PersonYearCheckRecord where YearCheckRowId= :CheckRowId)
	;w SQLCODE
	q "0"
}

Storage Default
{
<Data name="PYCRBarcodeServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PYCRBarcodeServiceD</DataLocation>
<DefaultData>PYCRBarcodeServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PYCRBarcodeServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PYCRBarcodeServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PYCRBarcodeServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
