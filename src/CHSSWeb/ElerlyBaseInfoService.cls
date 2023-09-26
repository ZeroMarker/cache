Class CHSSWeb.ElerlyBaseInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-10-
/// Description:老年人档案信息
/// Table：ElerlyBaseInfo
/// Input: ElerlyBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowId As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set PersonRowId=$G(PersonRowId)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set ElerlyRowId = 0
      Set tmp = ""
      
      
      
      ///For  Set ElerlyRowId=$O(^CHSS.ElerlyBaseInfoI("PersonRowIdIndex",PersonRowId,ElerlyRowId)) q:ElerlyRowId=""  d
      For  Set ElerlyRowId=$O(^CHSS.ElerlyBaseInfoI("PersonRowIdIndex",PersonRowId,ElerlyRowId)) q:ElerlyRowId=""  d
      .
      
      .s tempElerlyBaseInfo=##class(CHSS.ElerlyBaseInfo).%OpenId(ElerlyRowId)
      .
      
      ./// 老年人档案信息
      
      .s ElerlyGrade = tempElerlyBaseInfo.ElerlyGrade
      .s LifeSupport = tempElerlyBaseInfo.LifeSupport
      .set Nursing = tempElerlyBaseInfo.Nursing
      
      .set EyesightName = ""
      .set Eyesight = ""
      .i tempElerlyBaseInfo.Eyesight '= "" d
      ..s Eyesight = tempElerlyBaseInfo.Eyesight.%Id()
      ..s EyesightName = tempElerlyBaseInfo.Eyesight.Description

      .set ToothDeformityName = ""
      .set ToothDeformity = ""
      .i tempElerlyBaseInfo.ToothDeformity '= "" d
      ..s ToothDeformity = tempElerlyBaseInfo.ToothDeformity.%Id()
      ..s ToothDeformityName = tempElerlyBaseInfo.ToothDeformity.Description

      .s Informant = tempElerlyBaseInfo.Informant
      .s Inquirer = tempElerlyBaseInfo.Inquirer
      .s Recorder = tempElerlyBaseInfo.Recorder

      .set DateOfSign = tempElerlyBaseInfo.DateOfSign
      .i DateOfSign '= "" d
      ..s DateOfSign = $zd(DateOfSign,3)

      .set DateOfInquire = tempElerlyBaseInfo.DateOfInquire
      .i DateOfInquire '= "" d
      ..s DateOfInquire = $zd(DateOfInquire,3)

      .set DateOfRecord = tempElerlyBaseInfo.DateOfRecord
      .i DateOfRecord '= "" d
      ..s DateOfRecord = $zd(DateOfRecord,3)

      
      
      .Set tmp = ElerlyRowId_"^"_ElerlyGrade_"^"_LifeSupport_"^"_Nursing_"^"_Eyesight_"^"_EyesightName_"^"_ToothDeformity_"^"_ToothDeformityName_"^"_Informant_"^"_Inquirer_"^"_Recorder_"^"_DateOfSign_"^"_DateOfInquire_"^"_DateOfRecord

      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("ElerlyRowId^ElerlyGrade^LifeSupport^Nursing^Eyesight^EyesightName^ToothDeformity^ToothDeformityName^Informant^Inquirer^Recorder^DateOfSign^DateOfInquire^DateOfRecord",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2009-10-
/// Description:添加老年人档案信息
/// Table：ElerlyBaseInfo
/// Input: ElerlyBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, ElerlyGrade As %String, LifeSupport As %String, Nursing As %String, Eyesight As %Integer, ToothDeformity As %Integer, Informant As %String, Inquirer As %String, Recorder As %String, DateOfSign As %Date, DateOfInquire As %Date, DateOfRecord As %Date) As %String
{
      s tempElerlyBaseInfo=""
      s tempElerlyBaseInfo=##class(CHSS.ElerlyBaseInfo).%New()
      q:(tempElerlyBaseInfo="") 0
                 
	  
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempElerlyBaseInfo.PersonRowId=PersonRowIdobj
      

      /// 老年人档案信息
      
      s tempElerlyBaseInfo.ElerlyGrade = ElerlyGrade
      
     
      s tempElerlyBaseInfo.LifeSupport=LifeSupport
           
      s tempElerlyBaseInfo.Nursing=Nursing
      
      i Eyesight '= "" d
      .s Eyesightobj=##class(CHSS.DictEyesight).%OpenId(Eyesight)
      .s tempElerlyBaseInfo.Eyesight=Eyesightobj
      
      i ToothDeformity '= "" d
      .s ToothDeformityobj=##class(CHSS.DictToothDeformity).%OpenId(ToothDeformity)
      .s tempElerlyBaseInfo.ToothDeformity=ToothDeformityobj
      
      s tempElerlyBaseInfo.Informant = Informant
      s tempElerlyBaseInfo.Inquirer = Inquirer
      s tempElerlyBaseInfo.Recorder = Recorder

      i DateOfSign '= "" d
      .s DateOfSign=$zdh(DateOfSign ,3)
      s tempElerlyBaseInfo.DateOfSign=DateOfSign

      i DateOfInquire '= "" d
      .s DateOfInquire=$zdh(DateOfInquire ,3)
      s tempElerlyBaseInfo.DateOfInquire=DateOfInquire

      i DateOfRecord '= "" d
      .s DateOfRecord=$zdh(DateOfRecord ,3)
      s tempElerlyBaseInfo.DateOfRecord=DateOfRecord
        
      s result=""
      s result=tempElerlyBaseInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempElerlyBaseInfo.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempElerlyBaseInfo.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-10-
/// Description:更新老年人档案信息
/// Table：ElerlyBaseInfo
/// Input: ElerlyBaseInfo
/// Output：
/// Return：
/// Others：
ClassMethod Update(ElerlyRowId As %Integer, ElerlyGrade As %String, LifeSupport As %String, Nursing As %String, Eyesight As %Integer, ToothDeformity As %Integer, Informant As %String, Inquirer As %String, Recorder As %String, DateOfSign As %Date, DateOfInquire As %Date, DateOfRecord As %Date) As %String
{
  
      q:($d(ElerlyRowId)=0)||(ElerlyRowId="")
      
      s tempElerlyBaseInfo="",result=""
      s tempElerlyBaseInfo=##class(CHSS.ElerlyBaseInfo).%OpenId(ElerlyRowId)
      q:(tempElerlyBaseInfo="") 0
       
      
      /// 老年人档案信息
      
      s tempElerlyBaseInfo.ElerlyGrade = ElerlyGrade
      
      s tempElerlyBaseInfo.LifeSupport=LifeSupport
           
      s tempElerlyBaseInfo.Nursing=Nursing
      
      i Eyesight '= "" d
      .s Eyesightobj=##class(CHSS.DictEyesight).%OpenId(Eyesight)
      .s tempElerlyBaseInfo.Eyesight=Eyesightobj
      
      i ToothDeformity '= "" d
      .s ToothDeformityobj=##class(CHSS.DictToothDeformity).%OpenId(ToothDeformity)
      .s tempElerlyBaseInfo.ToothDeformity=ToothDeformityobj
      
      s tempElerlyBaseInfo.Informant = Informant
      s tempElerlyBaseInfo.Inquirer = Inquirer
      s tempElerlyBaseInfo.Recorder = Recorder

      i DateOfSign '= "" d
      .s DateOfSign=$zdh(DateOfSign ,3)
      s tempElerlyBaseInfo.DateOfSign=DateOfSign

      i DateOfInquire '= "" d
      .s DateOfInquire=$zdh(DateOfInquire ,3)
      s tempElerlyBaseInfo.DateOfInquire=DateOfInquire

      i DateOfRecord '= "" d
      .s DateOfRecord=$zdh(DateOfRecord ,3)
      s tempElerlyBaseInfo.DateOfRecord=DateOfRecord
        
        
      s result=""
      s result=tempElerlyBaseInfo.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_ElerlyRowId_"}"
      .///w "{""success"":""true"",""info"":"_ElerlyRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="ElerlyBaseInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ElerlyBaseInfoServiceD</DataLocation>
<DefaultData>ElerlyBaseInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ElerlyBaseInfoServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ElerlyBaseInfoServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ElerlyBaseInfoServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
