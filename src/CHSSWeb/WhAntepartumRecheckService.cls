Class CHSSWeb.WhAntepartumRecheckService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:妇女产前检查情况
/// Table：WhAntepartumRecheck
/// Input: WhAntepartumRecheck
/// Output：
/// Return：
/// Others：
ClassMethod List(WomanRowIdParref As %String, start As %Integer, limit As %Integer, sort As %String) As %String
{
      Set WomanRowIdParref=$G(WomanRowIdParref)
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      set RecheckRowId = 0
      Set tmp = ""
      
      
      
      For  Set RecheckRowId=$O(^CHSS.WhAntepartumRecheckI("WomanRowIdParrefIndex",WomanRowIdParref,RecheckRowId)) q:RecheckRowId=""  d
      .
      
      .s tempWhAntepartumRecheck=##class(CHSS.WhAntepartumRecheck).%OpenId(RecheckRowId)
      .
       
      ./// 检查信息
      .
      .s CheckDate = tempWhAntepartumRecheck.CheckDate
      .i CheckDate '= "" d
      ..s CheckDate = $zd(CheckDate,3)

      .s CheckUnit = tempWhAntepartumRecheck.CheckUnit
      
      .s Checker = tempWhAntepartumRecheck.Checker

      .s PreDate = tempWhAntepartumRecheck.PreDate
      .i PreDate '= "" d
      ..s PreDate = $zd(PreDate,3)
      
      
      ./// 孕产检查信息
      .
      .s UrineProtein = tempWhAntepartumRecheck.UrineProtein
            
      .s Hemglobin = tempWhAntepartumRecheck.Hemglobin
            
      .
      .s DangerGradeName = ""
      .s DangerGradeRowId = ""
      .i tempWhAntepartumRecheck.DangerGradeRowId '= "" d
      ..s DangerGradeRowId = tempWhAntepartumRecheck.DangerGradeRowId.%Id()
      ..s DangerGradeName = tempWhAntepartumRecheck.DangerGradeRowId.Description
      
      .s PregWeeks = tempWhAntepartumRecheck.PregWeeks

      .
      .s BPUnitName = ""
      .s BPUnit = ""
      .i tempWhAntepartumRecheck.BPUnit '= "" d
      ..s BPUnit = tempWhAntepartumRecheck.BPUnit.%Id()
      ..s BPUnitName = tempWhAntepartumRecheck.BPUnit.Description
      
      .s HighPressure = tempWhAntepartumRecheck.HighPressure
      .s LowPressure = tempWhAntepartumRecheck.LowPressure
      .s Weight = tempWhAntepartumRecheck.Weight
      .s WombHeight = tempWhAntepartumRecheck.WombHeight
      .s AbdomenGirth = tempWhAntepartumRecheck.AbdomenGirth

      .s FetusPosition = tempWhAntepartumRecheck.FetusPosition
            
      .s FetusCentre = tempWhAntepartumRecheck.FetusCentre
      .s FirstAppear = tempWhAntepartumRecheck.FirstAppear
      .s Gedema = tempWhAntepartumRecheck.Gedema
      
      
      ./// 处理及建议
      .
      .s OtherDeal = tempWhAntepartumRecheck.OtherDeal
      .s OtherCheck = tempWhAntepartumRecheck.OtherCheck
      .s TransferAdvice = tempWhAntepartumRecheck.TransferAdvice
      .s Remark = tempWhAntepartumRecheck.Remark
      
      
      .s Chiefcomplaint = tempWhAntepartumRecheck.Chiefcomplaint
      .s FHR = tempWhAntepartumRecheck.FHR
      .s bClassAbnormity = tempWhAntepartumRecheck.bClassAbnormity
      .s ClassAbnormityInfo = tempWhAntepartumRecheck.ClassAbnormityInfo
      .s bTransfer = tempWhAntepartumRecheck.bTransfer
      .s TransferReason = tempWhAntepartumRecheck.TransferReason
      .s TransferDept = tempWhAntepartumRecheck.TransferDept



      .Set tmp = RecheckRowId_"^"_CheckDate_"^"_CheckUnit_"^"_Checker_"^"_PreDate_"^"_UrineProtein_"^"_Hemglobin_"^"_DangerGradeRowId_"^"_DangerGradeName_"^"_PregWeeks_"^"_BPUnit_"^"_BPUnitName_"^"_HighPressure_"^"_LowPressure_"^"_Weight_"^"_WombHeight_"^"_AbdomenGirth_"^"_FetusPosition_"^"_FetusCentre_"^"_FirstAppear_"^"_Gedema_"^"_OtherDeal_"^"_OtherCheck_"^"_TransferAdvice_"^"_Remark_"^"_Chiefcomplaint_"^"_FHR_"^"_bClassAbnormity_"^"_ClassAbnormityInfo_"^"_bTransfer_"^"_TransferReason_"^"_TransferDept


      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("RecheckRowId^CheckDate^CheckUnit^Checker^PreDate^UrineProtein^Hemglobin^DangerGradeRowId^DangerGradeName^PregWeeks^BPUnit^BPUnitName^HighPressure^LowPressure^Weight^WombHeight^AbdomenGirth^FetusPosition^FetusCentre^FirstAppear^Gedema^OtherDeal^OtherCheck^TransferAdvice^Remark^Chiefcomplaint^FHR^bClassAbnormity^ClassAbnormityInfo^bTransfer^TransferReason^TransferDept",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:添加妇女产前检查情况
/// Table：WhAntepartumRecheck
/// Input: WhAntepartumRecheck
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowIdParref As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, PreDate As %Date, UrineProtein As %Integer, Hemglobin As %Integer, DangerGradeRowId As %Integer, PregWeeks As %Numeric, BPUnit As %Integer, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, WombHeight As %Float, AbdomenGirth As %Float, FetusPosition As %Integer, FetusCentre As %String, FirstAppear As %String, Gedema As %String, OtherDeal As %String, OtherCheck As %String, TransferAdvice As %String, Remark As %String, Chiefcomplaint As %String, FHR As %String, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
      s tempWhAntepartumRecheck=""
      s tempWhAntepartumRecheck=##class(CHSS.WhAntepartumRecheck).%New()
      q:(tempWhAntepartumRecheck="") 0
      
	  
      s WomanRowIdParrefobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowIdParref)
      s tempWhAntepartumRecheck.WomanRowIdParref=WomanRowIdParrefobj
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAntepartumRecheck.CheckDate = CheckDate
      
      s tempWhAntepartumRecheck.CheckUnit = CheckUnit
      
      s tempWhAntepartumRecheck.Checker = Checker
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWhAntepartumRecheck.PreDate = PreDate


      /// 孕产检查信息
      
      s tempWhAntepartumRecheck.UrineProtein = UrineProtein
      
      s tempWhAntepartumRecheck.Hemglobin = Hemglobin
           
      i DangerGradeRowId '= "" d
      .s DangerGradeRowIdobj = ##class(CHSS.DictWomenDangerGrade).%OpenId(DangerGradeRowId)
      .s tempWhAntepartumRecheck.DangerGradeRowId = DangerGradeRowIdobj
      
      s tempWhAntepartumRecheck.PregWeeks = PregWeeks

      i BPUnit '= "" d
      .s BPUnitobj = ##class(CHSS.DictHBPUnit).%OpenId(BPUnit)
      .s tempWhAntepartumRecheck.BPUnit = BPUnitobj
      
      s tempWhAntepartumRecheck.HighPressure = HighPressure
      s tempWhAntepartumRecheck.LowPressure = LowPressure
      s tempWhAntepartumRecheck.Weight = Weight
      s tempWhAntepartumRecheck.WombHeight = WombHeight
      s tempWhAntepartumRecheck.AbdomenGirth = AbdomenGirth

      s tempWhAntepartumRecheck.FetusPosition = FetusPosition
     
      s tempWhAntepartumRecheck.FetusCentre = FetusCentre
      s tempWhAntepartumRecheck.FirstAppear = FirstAppear
      s tempWhAntepartumRecheck.Gedema = Gedema
      
      
      /// 处理及建议
      
      s tempWhAntepartumRecheck.OtherDeal = OtherDeal
      s tempWhAntepartumRecheck.OtherCheck = OtherCheck
      s tempWhAntepartumRecheck.TransferAdvice = TransferAdvice
      s tempWhAntepartumRecheck.Remark = Remark
      
      
      s tempWhAntepartumRecheck.Chiefcomplaint = Chiefcomplaint
      s tempWhAntepartumRecheck.FHR = FHR
      s tempWhAntepartumRecheck.bClassAbnormity = bClassAbnormity
      s tempWhAntepartumRecheck.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAntepartumRecheck.bTransfer = bTransfer
      s tempWhAntepartumRecheck.TransferReason = TransferReason
      s tempWhAntepartumRecheck.TransferDept = TransferDept


        
      s result=""
      s result=tempWhAntepartumRecheck.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWhAntepartumRecheck.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWhAntepartumRecheck.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-06-
/// Description:更新妇女产前检查情况
/// Table：WhAntepartumRecheck
/// Input: WhAntepartumRecheck
/// Output：
/// Return：
/// Others：
ClassMethod Update(RecheckRowId As %Integer, CheckDate As %Date, CheckUnit As %String, Checker As %String, PreDate As %Date, UrineProtein As %Integer, Hemglobin As %Integer, DangerGradeRowId As %Integer, PregWeeks As %Numeric, BPUnit As %Integer, HighPressure As %Numeric, LowPressure As %Numeric, Weight As %Float, WombHeight As %Float, AbdomenGirth As %Float, FetusPosition As %Integer, FetusCentre As %String, FirstAppear As %String, Gedema As %String, OtherDeal As %String, OtherCheck As %String, TransferAdvice As %String, Remark As %String, Chiefcomplaint As %String, FHR As %String, bClassAbnormity As %String, ClassAbnormityInfo As %String, bTransfer As %String, TransferReason As %String, TransferDept As %String) As %String
{
  
      q:($d(RecheckRowId)=0)||(RecheckRowId="")
      
      s tempWhAntepartumRecheck="",result=""
      s tempWhAntepartumRecheck=##class(CHSS.WhAntepartumRecheck).%OpenId(RecheckRowId)
      q:(tempWhAntepartumRecheck="") 0
       
      
      /// 检查信息

      i CheckDate '= "" d
      .s CheckDate=$zdh(CheckDate,3)
      s tempWhAntepartumRecheck.CheckDate = CheckDate
      
      s tempWhAntepartumRecheck.CheckUnit = CheckUnit
      
      s tempWhAntepartumRecheck.Checker = Checker
      
      i PreDate '= "" d
      .s PreDate=$zdh(PreDate,3)
      s tempWhAntepartumRecheck.PreDate = PreDate


      /// 孕产检查信息
      
      s tempWhAntepartumRecheck.UrineProtein = UrineProtein
      
      s tempWhAntepartumRecheck.Hemglobin = Hemglobin
            
      i DangerGradeRowId '= "" d
      .s DangerGradeRowIdobj = ##class(CHSS.DictWomenDangerGrade).%OpenId(DangerGradeRowId)
      .s tempWhAntepartumRecheck.DangerGradeRowId = DangerGradeRowIdobj
      
      s tempWhAntepartumRecheck.PregWeeks = PregWeeks

      i BPUnit '= "" d
      .s BPUnitobj = ##class(CHSS.DictHBPUnit).%OpenId(BPUnit)
      .s tempWhAntepartumRecheck.BPUnit = BPUnitobj
      
      s tempWhAntepartumRecheck.HighPressure = HighPressure
      s tempWhAntepartumRecheck.LowPressure = LowPressure
      s tempWhAntepartumRecheck.Weight = Weight
      s tempWhAntepartumRecheck.WombHeight = WombHeight
      s tempWhAntepartumRecheck.AbdomenGirth = AbdomenGirth

      s tempWhAntepartumRecheck.FetusPosition = FetusPosition
     
      
      s tempWhAntepartumRecheck.FetusCentre = FetusCentre
      s tempWhAntepartumRecheck.FirstAppear = FirstAppear
      s tempWhAntepartumRecheck.Gedema = Gedema
      
      
      /// 处理及建议
      
      s tempWhAntepartumRecheck.OtherDeal = OtherDeal
      s tempWhAntepartumRecheck.OtherCheck = OtherCheck
      s tempWhAntepartumRecheck.TransferAdvice = TransferAdvice
      s tempWhAntepartumRecheck.Remark = Remark
      
      
      s tempWhAntepartumRecheck.Chiefcomplaint = Chiefcomplaint
      s tempWhAntepartumRecheck.FHR = FHR
      s tempWhAntepartumRecheck.bClassAbnormity = bClassAbnormity
      s tempWhAntepartumRecheck.ClassAbnormityInfo = ClassAbnormityInfo
      s tempWhAntepartumRecheck.bTransfer = bTransfer
      s tempWhAntepartumRecheck.TransferReason = TransferReason
      s tempWhAntepartumRecheck.TransferDept = TransferDept

        
      s result=""
      s result=tempWhAntepartumRecheck.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_RecheckRowId_"}"
      .///w "{""success"":""true"",""info"":"_RecheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2009—09-
/// Description:删除妇女产前检查情况
/// Table：WhAntepartumRecheck
/// Input: RecheckRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(RecheckRowId As %String) As %String
{
      &sql(delete from CHSS.WhAntepartumRecheck where %ID=:RecheckRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_RecheckRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="WhAntepartumRecheckServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhAntepartumA66D</DataLocation>
<DefaultData>WhAntepartumRecheckServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhAntepartumA66D</IdLocation>
<IndexLocation>^CHSSWeb.WhAntepartumA66I</IndexLocation>
<StreamLocation>^CHSSWeb.WhAntepartumA66S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
