Class CHSSWeb.WhAfterBirthVisitRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:孕妇产后访视记录
/// Table：WhAfterBirthVisitRecord
/// Input: WhAfterBirthVisitRecord
/// Output：
/// Return：
/// Others：
ClassMethod List(WomanRowId As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set WomanRowId=$G(WomanRowId)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set VisitRowId = 0
      Set tmp = ""
      
      
      
      For  Set VisitRowId=$O(^CHSS.WhAfterBirthVisitRecordI("WomanRowIdIndex",WomanRowId,VisitRowId)) q:VisitRowId=""  d
      .
      
      .s tempWhAfterBirthVisitRecord=##class(CHSS.WhAfterBirthVisitRecord).%OpenId(VisitRowId)
      .
       
      ./// 检查信息
      .
      .s CheckDate = tempWhAfterBirthVisitRecord.CheckDate
      .i CheckDate '= "" d
      ..s CheckDate = $zd(CheckDate,3)

      .s CheckUnit = tempWhAfterBirthVisitRecord.CheckUnit
      
      .s Checker = tempWhAfterBirthVisitRecord.Checker


      ./// 健康检查
      .
      .s GeneralCheck = tempWhAfterBirthVisitRecord.GeneralCheck
      .s HighPressure = tempWhAfterBirthVisitRecord.HighPressure
      .s LowPressure = tempWhAfterBirthVisitRecord.LowPressure
      .s Weight = tempWhAfterBirthVisitRecord.Weight
      .s Brest = tempWhAfterBirthVisitRecord.Brest
      .s Uterus = tempWhAfterBirthVisitRecord.Uterus
      .s Lochia = tempWhAfterBirthVisitRecord.Lochia
      .s Wound = tempWhAfterBirthVisitRecord.Wound
      .s OtherCheck = tempWhAfterBirthVisitRecord.OtherCheck

      ./// 保健指导
      .
      .s GeneralGuid = tempWhAfterBirthVisitRecord.GeneralGuid
      .s PsychologyGuid = tempWhAfterBirthVisitRecord.PsychologyGuid
      .s NutritionGuid = tempWhAfterBirthVisitRecord.NutritionGuid
      .s BreastFeedingGuid = tempWhAfterBirthVisitRecord.BreastFeedingGuid
      .s Remark = tempWhAfterBirthVisitRecord.Remark


      .s Temperature = tempWhAfterBirthVisitRecord.Temperature
      .s Psychologic = tempWhAfterBirthVisitRecord.Psychologic
      
      .s PreDate = tempWhAfterBirthVisitRecord.PreDate
      .i PreDate '= "" d
      ..s PreDate = $zd(PreDate,3)
      
      
      .s bClassAbnormity = tempWhAfterBirthVisitRecord.bClassAbnormity
      .s ClassAbnormityInfo = tempWhAfterBirthVisitRecord.ClassAbnormityInfo
      .s bTransfer = tempWhAfterBirthVisitRecord.bTransfer
      .s TransferReason = tempWhAfterBirthVisitRecord.TransferReason
      .s TransferDept = tempWhAfterBirthVisitRecord.TransferDept


      .Set tmp = VisitRowId_"^"_CheckDate_"^"_CheckUnit_"^"_Checker_"^"_GeneralCheck_"^"_HighPressure_"^"_LowPressure_"^"_Weight_"^"_Brest_"^"_Uterus_"^"_Lochia_"^"_Wound_"^"_OtherCheck_"^"_GeneralGuid_"^"_PsychologyGuid_"^"_NutritionGuid_"^"_BreastFeedingGuid_"^"_Remark_"^"_Temperature_"^"_Psychologic_"^"_PreDate_"^"_bClassAbnormity_"^"_ClassAbnormityInfo_"^"_bTransfer_"^"_TransferReason_"^"_TransferDept


      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("VisitRowId^CheckDate^CheckUnit^Checker^GeneralCheck^HighPressure^LowPressure^Weight^Brest^Uterus^Lochia^Wound^OtherCheck^GeneralGuid^PsychologyGuid^NutritionGuid^BreastFeedingGuid^Remark^Temperature^Psychologic^PreDate^bClassAbnormity^ClassAbnormityInfo^bTransfer^TransferReason^TransferDept",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:添加孕妇产后访视记录
/// Table：WhAfterBirthVisitRecord
/// Input: WhAfterBirthVisitRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowId As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, GeneralCheck As %String, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, Brest As %String, Uterus As %String, Lochia As %String, Wound As %String, OtherCheck As %String, GeneralGuid As %String, PsychologyGuid As %String, NutritionGuid As %String, BreastFeedingGuid As %String, Remark As %String, Temperature As %Float, Psychologic As %String, PreDate As %Date, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
      s tempWhAfterBirthVisitRecord=""
      s tempWhAfterBirthVisitRecord=##class(CHSS.WhAfterBirthVisitRecord).%New()
      q:(tempWhAfterBirthVisitRecord="") 0
      
	  
      s WomanRowIdobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      s tempWhAfterBirthVisitRecord.WomanRowId=WomanRowIdobj
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAfterBirthVisitRecord.CheckDate = CheckDate
      
      s tempWhAfterBirthVisitRecord.CheckUnit = CheckUnit
      
      s tempWhAfterBirthVisitRecord.Checker = Checker


      /// 健康检查

      s tempWhAfterBirthVisitRecord.GeneralCheck = GeneralCheck
      s tempWhAfterBirthVisitRecord.HighPressure = HighPressure
      s tempWhAfterBirthVisitRecord.LowPressure = LowPressure
      s tempWhAfterBirthVisitRecord.Weight = Weight
      s tempWhAfterBirthVisitRecord.Brest = Brest
      s tempWhAfterBirthVisitRecord.Uterus = Uterus
      s tempWhAfterBirthVisitRecord.Lochia = Lochia
      s tempWhAfterBirthVisitRecord.Wound = Wound
      s tempWhAfterBirthVisitRecord.OtherCheck = OtherCheck


      /// 保健指导

      s tempWhAfterBirthVisitRecord.GeneralGuid = GeneralGuid
      s tempWhAfterBirthVisitRecord.PsychologyGuid = PsychologyGuid
      s tempWhAfterBirthVisitRecord.NutritionGuid = NutritionGuid
      s tempWhAfterBirthVisitRecord.BreastFeedingGuid = BreastFeedingGuid
      s tempWhAfterBirthVisitRecord.Remark = Remark
      
      
      s tempWhAfterBirthVisitRecord.Temperature = Temperature
      s tempWhAfterBirthVisitRecord.Psychologic = Psychologic
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWhAfterBirthVisitRecord.PreDate = PreDate
      
      s tempWhAfterBirthVisitRecord.bClassAbnormity = bClassAbnormity
      s tempWhAfterBirthVisitRecord.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAfterBirthVisitRecord.bTransfer = bTransfer
      s tempWhAfterBirthVisitRecord.TransferReason = TransferReason
      s tempWhAfterBirthVisitRecord.TransferDept = TransferDept


        
      s result=""
      s result=tempWhAfterBirthVisitRecord.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWhAfterBirthVisitRecord.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWhAfterBirthVisitRecord.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:更新孕妇产后访视记录
/// Table：WhAfterBirthVisitRecord
/// Input: WhAfterBirthVisitRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(VisitRowId As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, GeneralCheck As %String, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, Brest As %String, Uterus As %String, Lochia As %String, Wound As %String, OtherCheck As %String, GeneralGuid As %String, PsychologyGuid As %String, NutritionGuid As %String, BreastFeedingGuid As %String, Remark As %String, Temperature As %Float, Psychologic As %String, PreDate As %Date, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
  
      q:($d(VisitRowId)=0)||(VisitRowId="")
      
      s tempWhAfterBirthVisitRecord="",result=""
      s tempWhAfterBirthVisitRecord=##class(CHSS.WhAfterBirthVisitRecord).%OpenId(VisitRowId)
      q:(tempWhAfterBirthVisitRecord="") 0
       
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAfterBirthVisitRecord.CheckDate = CheckDate
      
      s tempWhAfterBirthVisitRecord.CheckUnit = CheckUnit
      
      s tempWhAfterBirthVisitRecord.Checker = Checker


      /// 健康检查

      s tempWhAfterBirthVisitRecord.GeneralCheck = GeneralCheck
      s tempWhAfterBirthVisitRecord.HighPressure = HighPressure
      s tempWhAfterBirthVisitRecord.LowPressure = LowPressure
      s tempWhAfterBirthVisitRecord.Weight = Weight
      s tempWhAfterBirthVisitRecord.Brest = Brest
      s tempWhAfterBirthVisitRecord.Uterus = Uterus
      s tempWhAfterBirthVisitRecord.Lochia = Lochia
      s tempWhAfterBirthVisitRecord.Wound = Wound
      s tempWhAfterBirthVisitRecord.OtherCheck = OtherCheck

      /// 保健指导

      s tempWhAfterBirthVisitRecord.GeneralGuid = GeneralGuid
      s tempWhAfterBirthVisitRecord.PsychologyGuid = PsychologyGuid
      s tempWhAfterBirthVisitRecord.NutritionGuid = NutritionGuid
      s tempWhAfterBirthVisitRecord.BreastFeedingGuid = BreastFeedingGuid
      s tempWhAfterBirthVisitRecord.Remark = Remark
      
      
      s tempWhAfterBirthVisitRecord.Temperature = Temperature
      s tempWhAfterBirthVisitRecord.Psychologic = Psychologic
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWhAfterBirthVisitRecord.PreDate = PreDate
      
      s tempWhAfterBirthVisitRecord.bClassAbnormity = bClassAbnormity
      s tempWhAfterBirthVisitRecord.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAfterBirthVisitRecord.bTransfer = bTransfer
      s tempWhAfterBirthVisitRecord.TransferReason = TransferReason
      s tempWhAfterBirthVisitRecord.TransferDept = TransferDept

        
      s result=""
      s result=tempWhAfterBirthVisitRecord.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_VisitRowId_"}"
      .///w "{""success"":""true"",""info"":"_VisitRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-10-16
/// Description:删除孕妇产后访视记录
/// Table：WhAfterBirthVisitRecord
/// Input: VisitRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(VisitRowId As %String) As %String
{
      &sql(delete from CHSS.WhAfterBirthVisitRecord where %ID=:VisitRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_VisitRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="WhAfterBirthVisitRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhAfterBirthBE9D</DataLocation>
<DefaultData>WhAfterBirthVisitRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhAfterBirthBE9D</IdLocation>
<IndexLocation>^CHSSWeb.WhAfterBirthBE9I</IndexLocation>
<StreamLocation>^CHSSWeb.WhAfterBirthBE9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
