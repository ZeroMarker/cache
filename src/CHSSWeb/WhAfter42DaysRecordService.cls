Class CHSSWeb.WhAfter42DaysRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:产后42天访视
/// Table：WhAfter42DaysRecord
/// Input: WhAfter42DaysRecord
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
      
      
      
      For  Set VisitRowId=$O(^CHSS.WhAfter42DaysRecordI("WomanRowIdIndex",WomanRowId,VisitRowId)) q:VisitRowId=""  d
      .
      
      .s tempWhAfter42DaysRecord=##class(CHSS.WhAfter42DaysRecord).%OpenId(VisitRowId)
      .
       
      ./// 检查信息
      .
      .s CheckDate = tempWhAfter42DaysRecord.CheckDate
      .i CheckDate '= "" d
      ..s CheckDate = $zd(CheckDate,3)

      .s CheckUnit = tempWhAfter42DaysRecord.CheckUnit
      
      .s Checker = tempWhAfter42DaysRecord.Checker


      ./// 健康检查
      .
      .s GeneralCheck = tempWhAfter42DaysRecord.GeneralCheck
      .s HighPressure = tempWhAfter42DaysRecord.HighPressure
      .s LowPressure = tempWhAfter42DaysRecord.LowPressure
      .s Weight = tempWhAfter42DaysRecord.Weight
      .s Brest = tempWhAfter42DaysRecord.Brest
      .s Uterus = tempWhAfter42DaysRecord.Uterus
      .s Lochia = tempWhAfter42DaysRecord.Lochia
      .s Wound = tempWhAfter42DaysRecord.Wound
      .s OtherCheck = tempWhAfter42DaysRecord.OtherCheck

      ./// 保健指导
      .
      .s GeneralGuid = tempWhAfter42DaysRecord.GeneralGuid
      .s BirthControlGuid = tempWhAfter42DaysRecord.BirthControlGuid
      .s PsychologyGuid = tempWhAfter42DaysRecord.PsychologyGuid
      .s NutritionGuid = tempWhAfter42DaysRecord.NutritionGuid
      .s BreastFeedingGuid = tempWhAfter42DaysRecord.BreastFeedingGuid
      .s Remark = tempWhAfter42DaysRecord.Remark
      
      
      .s Psychologic = tempWhAfter42DaysRecord.Psychologic
      .s bClassAbnormity = tempWhAfter42DaysRecord.bClassAbnormity
      .s ClassAbnormityInfo = tempWhAfter42DaysRecord.ClassAbnormityInfo
      .s bTransfer = tempWhAfter42DaysRecord.bTransfer
      .s TransferReason = tempWhAfter42DaysRecord.TransferReason
      .s TransferDept = tempWhAfter42DaysRecord.TransferDept



      .Set tmp = VisitRowId_"^"_CheckDate_"^"_CheckUnit_"^"_Checker_"^"_GeneralCheck_"^"_HighPressure_"^"_LowPressure_"^"_Weight_"^"_Brest_"^"_Uterus_"^"_Lochia_"^"_Wound_"^"_OtherCheck_"^"_GeneralGuid_"^"_BirthControlGuid_"^"_PsychologyGuid_"^"_NutritionGuid_"^"_BreastFeedingGuid_"^"_Remark_"^"_Psychologic_"^"_bClassAbnormity_"^"_ClassAbnormityInfo_"^"_bTransfer_"^"_TransferReason_"^"_TransferDept


      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("VisitRowId^CheckDate^CheckUnit^Checker^GeneralCheck^HighPressure^LowPressure^Weight^Brest^Uterus^Lochia^Wound^OtherCheck^GeneralGuid^BirthControlGuid^PsychologyGuid^NutritionGuid^BreastFeedingGuid^Remark^Psychologic^bClassAbnormity^ClassAbnormityInfo^bTransfer^TransferReason^TransferDept",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:添加产后42天访视
/// Table：WhAfter42DaysRecord
/// Input: WhAfter42DaysRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowId As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, GeneralCheck As %String, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, Brest As %String, Uterus As %String, Lochia As %String, Wound As %String, OtherCheck As %String, GeneralGuid As %String, BirthControlGuid As %String, PsychologyGuid As %String, NutritionGuid As %String, BreastFeedingGuid As %String, Remark As %String, Psychologic As %String, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
      s tempWhAfter42DaysRecord=""
      s tempWhAfter42DaysRecord=##class(CHSS.WhAfter42DaysRecord).%New()
      q:(tempWhAfter42DaysRecord="") 0
      
	  
      s WomanRowIdobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      s tempWhAfter42DaysRecord.WomanRowId=WomanRowIdobj
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAfter42DaysRecord.CheckDate = CheckDate
      
      s tempWhAfter42DaysRecord.CheckUnit = CheckUnit
      
      s tempWhAfter42DaysRecord.Checker = Checker


      /// 健康检查

      s tempWhAfter42DaysRecord.GeneralCheck = GeneralCheck
      s tempWhAfter42DaysRecord.HighPressure = HighPressure
      s tempWhAfter42DaysRecord.LowPressure = LowPressure
      s tempWhAfter42DaysRecord.Weight = Weight
      s tempWhAfter42DaysRecord.Brest = Brest
      s tempWhAfter42DaysRecord.Uterus = Uterus
      s tempWhAfter42DaysRecord.Lochia = Lochia
      s tempWhAfter42DaysRecord.Wound = Wound
      s tempWhAfter42DaysRecord.OtherCheck = OtherCheck


      /// 保健指导

      s tempWhAfter42DaysRecord.GeneralGuid = GeneralGuid
      s tempWhAfter42DaysRecord.BirthControlGuid = BirthControlGuid
      s tempWhAfter42DaysRecord.PsychologyGuid = PsychologyGuid
      s tempWhAfter42DaysRecord.NutritionGuid = NutritionGuid
      s tempWhAfter42DaysRecord.BreastFeedingGuid = BreastFeedingGuid
      s tempWhAfter42DaysRecord.Remark = Remark
      
      
      s tempWhAfter42DaysRecord.Psychologic = Psychologic
      s tempWhAfter42DaysRecord.bClassAbnormity = bClassAbnormity
      s tempWhAfter42DaysRecord.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAfter42DaysRecord.bTransfer = bTransfer
      s tempWhAfter42DaysRecord.TransferReason = TransferReason
      s tempWhAfter42DaysRecord.TransferDept = TransferDept


        
      s result=""
      s result=tempWhAfter42DaysRecord.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWhAfter42DaysRecord.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWhAfter42DaysRecord.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:更新产后42天访视
/// Table：WhAfter42DaysRecord
/// Input: WhAfter42DaysRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(VisitRowId As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, GeneralCheck As %String, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, Brest As %String, Uterus As %String, Lochia As %String, Wound As %String, OtherCheck As %String, GeneralGuid As %String, BirthControlGuid As %String, PsychologyGuid As %String, NutritionGuid As %String, BreastFeedingGuid As %String, Remark As %String, Psychologic As %String, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
  
      q:($d(VisitRowId)=0)||(VisitRowId="")
      
      s tempWhAfter42DaysRecord="",result=""
      s tempWhAfter42DaysRecord=##class(CHSS.WhAfter42DaysRecord).%OpenId(VisitRowId)
      q:(tempWhAfter42DaysRecord="") 0
       
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAfter42DaysRecord.CheckDate = CheckDate
      
      s tempWhAfter42DaysRecord.CheckUnit = CheckUnit
      
      s tempWhAfter42DaysRecord.Checker = Checker


      /// 健康检查

      s tempWhAfter42DaysRecord.GeneralCheck = GeneralCheck
      s tempWhAfter42DaysRecord.HighPressure = HighPressure
      s tempWhAfter42DaysRecord.LowPressure = LowPressure
      s tempWhAfter42DaysRecord.Weight = Weight
      s tempWhAfter42DaysRecord.Brest = Brest
      s tempWhAfter42DaysRecord.Uterus = Uterus
      s tempWhAfter42DaysRecord.Lochia = Lochia
      s tempWhAfter42DaysRecord.Wound = Wound
      s tempWhAfter42DaysRecord.OtherCheck = OtherCheck

      /// 保健指导

      s tempWhAfter42DaysRecord.GeneralGuid = GeneralGuid
      s tempWhAfter42DaysRecord.BirthControlGuid = BirthControlGuid
      s tempWhAfter42DaysRecord.PsychologyGuid = PsychologyGuid
      s tempWhAfter42DaysRecord.NutritionGuid = NutritionGuid
      s tempWhAfter42DaysRecord.BreastFeedingGuid = BreastFeedingGuid
      s tempWhAfter42DaysRecord.Remark = Remark


      s tempWhAfter42DaysRecord.Psychologic = Psychologic
      s tempWhAfter42DaysRecord.bClassAbnormity = bClassAbnormity
      s tempWhAfter42DaysRecord.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAfter42DaysRecord.bTransfer = bTransfer
      s tempWhAfter42DaysRecord.TransferReason = TransferReason
      s tempWhAfter42DaysRecord.TransferDept = TransferDept

        
      s result=""
      s result=tempWhAfter42DaysRecord.%Save()
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
/// CreatDate：2009-10-
/// Description:删除产后42天访视
/// Table：WhAfter42DaysRecord
/// Input: VisitRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(VisitRowId As %String) As %String
{
      &sql(delete from CHSS.WhAfter42DaysRecord where %ID=:VisitRowId)
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
<Data name="WhAfter42DaysRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhAfter42Day9D8D</DataLocation>
<DefaultData>WhAfter42DaysRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhAfter42Day9D8D</IdLocation>
<IndexLocation>^CHSSWeb.WhAfter42Day9D8I</IndexLocation>
<StreamLocation>^CHSSWeb.WhAfter42Day9D8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
