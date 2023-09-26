Class CHSSWeb.WhBirthRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:孕妇分娩情况
/// Table：WhBirthRecord
/// Input: WhBirthRecord
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
      set BirthRowId = 0
      Set tmp = ""
      
      
      
      For  Set BirthRowId=$O(^CHSS.WhBirthRecordI("WomanRowIdIndex",WomanRowId,BirthRowId)) q:BirthRowId=""  d
      .
      
      .s tempWhBirthRecord=##class(CHSS.WhBirthRecord).%OpenId(BirthRowId)
      .
       
      ./// 检查信息
      .

      .s DateOfBirth = tempWhBirthRecord.DateOfBirth
      .i DateOfBirth '= "" d
      ..s DateOfBirth = $zd(DateOfBirth,3)


      .s BirthGW = tempWhBirthRecord.BirthGW
      .s BirthPlace = tempWhBirthRecord.BirthPlace

      .
      .s BirthTypeName = ""
      .s BirthType = ""
      .i tempWhBirthRecord.BirthType '= "" d
      ..s BirthType = tempWhBirthRecord.BirthType.%Id()
      ..s BirthTypeName = tempWhBirthRecord.BirthType.Description

      .s BirthComp = tempWhBirthRecord.BirthComp
      .s BirthParity = tempWhBirthRecord.BirthParity
      
      .s TotalStage = tempWhBirthRecord.TotalStage
      .s CaesareanReason = tempWhBirthRecord.CaesareanReason
      
      .
      .s PlacentaFallModeName = ""
      .s PlacentaFallMode = ""
      .i tempWhBirthRecord.PlacentaFallMode '= "" d
      ..s PlacentaFallMode = tempWhBirthRecord.PlacentaFallMode.%Id()
      ..s PlacentaFallModeName = tempWhBirthRecord.PlacentaFallMode.Description
      
      .
      .s DystociaName = ""
      .s Dystocia = ""
      .i tempWhBirthRecord.Dystocia '= "" d
      ..s Dystocia = tempWhBirthRecord.Dystocia.%Id()
      ..s DystociaName = tempWhBirthRecord.Dystocia.Description
      
      .s ODFDName = ""
      .s ODFD = ""
      .i tempWhBirthRecord.ODFD '= "" d
      ..s ODFD = tempWhBirthRecord.ODFD.%Id()
      ..s ODFDName = tempWhBirthRecord.ODFD.Description
      
      .s SplitTypeName = ""
      .s SplitType = ""
      .i tempWhBirthRecord.SplitType '= "" d
      ..s SplitType = tempWhBirthRecord.SplitType.%Id()
      ..s SplitTypeName = tempWhBirthRecord.SplitType.Description
      
      
      .s OuterFissureNum = tempWhBirthRecord.OuterFissureNum
      .s Complication = tempWhBirthRecord.Complication
      .s OtherComplication = tempWhBirthRecord.OtherComplication
      .s BleedNum = tempWhBirthRecord.BleedNum
      
      .s BleedReasonName = ""
      .s BleedReason = ""
      .i tempWhBirthRecord.BleedReason '= "" d
      ..s BleedReason = tempWhBirthRecord.BleedReason.%Id()
      ..s BleedReasonName = tempWhBirthRecord.BleedReason.Description
           
      .s BleedReasonDes = tempWhBirthRecord.BleedReasonDes
      .s FetusNum = tempWhBirthRecord.FetusNum
      
      .s LeaveDate = tempWhBirthRecord.LeaveDate
      .i LeaveDate '= "" d
      ..s LeaveDate = $zd(LeaveDate,3)
      
      .s Suggestion = tempWhBirthRecord.Suggestion


      .Set tmp = BirthRowId_"^"_DateOfBirth_"^"_BirthGW_"^"_BirthPlace_"^"_BirthType_"^"_BirthTypeName_"^"_BirthComp_"^"_BirthParity_"^"_TotalStage_"^"_CaesareanReason_"^"_PlacentaFallMode_"^"_PlacentaFallModeName_"^"_Dystocia_"^"_DystociaName_"^"_ODFD_"^"_ODFDName_"^"_SplitType_"^"_SplitTypeName_"^"_OuterFissureNum_"^"_Complication_"^"_OtherComplication_"^"_BleedNum_"^"_BleedReason_"^"_BleedReasonName_"^"_BleedReasonDes_"^"_FetusNum_"^"_LeaveDate_"^"_Suggestion


      .Set count=count+1
      .If (count>start)&(count<=end) d
      ..d json.InsertRowData(tmp)
      .
      .
      
      Set resultString = json.getJsonData("BirthRowId^DateOfBirth^BirthGW^BirthPlace^BirthType^BirthTypeName^BirthComp^BirthParity^TotalStage^CaesareanReason^PlacentaFallMode^PlacentaFallModeName^Dystocia^DystociaName^ODFD^ODFDName^SplitType^SplitTypeName^OuterFissureNum^Complication^OtherComplication^BleedNum^BleedReason^BleedReasonName^BleedReasonDes^FetusNum^LeaveDate^Suggestion",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:添加孕妇分娩情况
/// Table：WhBirthRecord
/// Input: WhBirthRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowId As %Integer, DateOfBirth As %Date, BirthGW As %Float, BirthPlace As %String, BirthType As %Integer, BirthComp As %String, BirthParity As %String, TotalStage As %Numeric, CaesareanReason As %String, PlacentaFallMode As %Integer, Dystocia As %Integer, ODFD As %Integer, SplitType As %Integer, OuterFissureNum As %Numeric, Complication As %String, OtherComplication As %String, BleedNum As %Float, BleedReason As %Integer, BleedReasonDes As %String, FetusNum As %Numeric, LeaveDate As %Date, Suggestion As %String) As %String
{
      s tempWhBirthRecord=""
      s tempWhBirthRecord=##class(CHSS.WhBirthRecord).%New()
      q:(tempWhBirthRecord="") 0
      
	  
      s WomanRowIdobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      s tempWhBirthRecord.WomanRowId=WomanRowIdobj
      

      /// 检查信息

      i DateOfBirth '= "" d
      .s DateOfBirth=$zdh(DateOfBirth,3)
      s tempWhBirthRecord.DateOfBirth = DateOfBirth

      s tempWhBirthRecord.BirthGW = BirthGW
      s tempWhBirthRecord.BirthPlace = BirthPlace
      
      i BirthType '= "" d
      .s BirthTypeobj = ##class(CHSS.DictBirthType).%OpenId(BirthType)
      .s tempWhBirthRecord.BirthType = BirthTypeobj
      
      s tempWhBirthRecord.BirthComp = BirthComp
      s tempWhBirthRecord.BirthParity = BirthParity
      
      s tempWhBirthRecord.TotalStage = TotalStage
      s tempWhBirthRecord.CaesareanReason = CaesareanReason
      
      i PlacentaFallMode '= "" d
      .s PlacentaFallModeobj = ##class(CHSS.DictPlacentaFallMode).%OpenId(PlacentaFallMode)
      .s tempWhBirthRecord.PlacentaFallMode = PlacentaFallModeobj
      
      i Dystocia '= "" d
      .s Dystociaobj = ##class(CHSS.DictDystocia).%OpenId(Dystocia)
      .s tempWhBirthRecord.Dystocia = Dystociaobj
      
      i ODFD '= "" d
      .s ODFDobj = ##class(CHSS.DictODFD).%OpenId(ODFD)
      .s tempWhBirthRecord.ODFD = ODFDobj
      
      i SplitType '= "" d
      .s SplitTypeobj = ##class(CHSS.DictSplitType).%OpenId(SplitType)
      .s tempWhBirthRecord.SplitType = SplitTypeobj
      
     
      s tempWhBirthRecord.OuterFissureNum = OuterFissureNum
      s tempWhBirthRecord.Complication = Complication
      s tempWhBirthRecord.OtherComplication = OtherComplication
      s tempWhBirthRecord.BleedNum = BleedNum
      
      i BleedReason '= "" d
      .s BleedReasonobj = ##class(CHSS.DictBleedReason).%OpenId(BleedReason)
      .s tempWhBirthRecord.BleedReason = BleedReasonobj
           
      s tempWhBirthRecord.BleedReasonDes = BleedReasonDes
      s tempWhBirthRecord.FetusNum = FetusNum
      
      i LeaveDate '= "" d
      .s LeaveDate=$zdh(LeaveDate,3)
      s tempWhBirthRecord.LeaveDate = LeaveDate

            
      s tempWhBirthRecord.Suggestion = Suggestion

        
      s result=""
      s result=tempWhBirthRecord.%Save()
      Set resultString = ""
      
           
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWhBirthRecord.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWhBirthRecord.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:更新孕妇分娩情况
/// Table：WhBirthRecord
/// Input: WhBirthRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(BirthRowId As %Integer, DateOfBirth As %Date, BirthGW As %Float, BirthPlace As %String, BirthType As %Integer, BirthComp As %String, BirthParity As %String, TotalStage As %Numeric, CaesareanReason As %String, PlacentaFallMode As %Integer, Dystocia As %Integer, ODFD As %Integer, SplitType As %Integer, OuterFissureNum As %Numeric, Complication As %String, OtherComplication As %String, BleedNum As %Float, BleedReason As %Integer, BleedReasonDes As %String, FetusNum As %Numeric, LeaveDate As %Date, Suggestion As %String) As %String
{
  
      q:($d(BirthRowId)=0)||(BirthRowId="")
      
      s tempWhBirthRecord="",result=""
      s tempWhBirthRecord=##class(CHSS.WhBirthRecord).%OpenId(BirthRowId)
      q:(tempWhBirthRecord="") 0
       
      
      /// 检查信息

      i DateOfBirth '= "" d
      .s DateOfBirth=$zdh(DateOfBirth,3)
      s tempWhBirthRecord.DateOfBirth = DateOfBirth

      s tempWhBirthRecord.BirthGW = BirthGW
      s tempWhBirthRecord.BirthPlace = BirthPlace
      
      i BirthType '= "" d
      .s BirthTypeobj = ##class(CHSS.DictBirthType).%OpenId(BirthType)
      .s tempWhBirthRecord.BirthType = BirthTypeobj
      
      s tempWhBirthRecord.BirthComp = BirthComp
      s tempWhBirthRecord.BirthParity = BirthParity
      
      s tempWhBirthRecord.TotalStage = TotalStage
      s tempWhBirthRecord.CaesareanReason = CaesareanReason
      
      i PlacentaFallMode '= "" d
      .s PlacentaFallModeobj = ##class(CHSS.DictPlacentaFallMode).%OpenId(PlacentaFallMode)
      .s tempWhBirthRecord.PlacentaFallMode = PlacentaFallModeobj
      
      i Dystocia '= "" d
      .s Dystociaobj = ##class(CHSS.DictDystocia).%OpenId(Dystocia)
      .s tempWhBirthRecord.Dystocia = Dystociaobj
      
      i ODFD '= "" d
      .s ODFDobj = ##class(CHSS.DictODFD).%OpenId(ODFD)
      .s tempWhBirthRecord.ODFD = ODFDobj
      
      i SplitType '= "" d
      .s SplitTypeobj = ##class(CHSS.DictSplitType).%OpenId(SplitType)
      .s tempWhBirthRecord.SplitType = SplitTypeobj
      
     
      s tempWhBirthRecord.OuterFissureNum = OuterFissureNum
      s tempWhBirthRecord.Complication = Complication
      s tempWhBirthRecord.OtherComplication = OtherComplication
      s tempWhBirthRecord.BleedNum = BleedNum
      
      i BleedReason '= "" d
      .s BleedReasonobj = ##class(CHSS.DictBleedReason).%OpenId(BleedReason)
      .s tempWhBirthRecord.BleedReason = BleedReasonobj
           
      s tempWhBirthRecord.BleedReasonDes = BleedReasonDes
      s tempWhBirthRecord.FetusNum = FetusNum
      
      i LeaveDate '= "" d
      .s LeaveDate=$zdh(LeaveDate,3)
      s tempWhBirthRecord.LeaveDate = LeaveDate

            
      s tempWhBirthRecord.Suggestion = Suggestion

        
      s result=""
      s result=tempWhBirthRecord.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_BirthRowId_"}"
      .///w "{""success"":""true"",""info"":"_BirthRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="WhBirthRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhBirthRecordServiceD</DataLocation>
<DefaultData>WhBirthRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhBirthRecordServiceD</IdLocation>
<IndexLocation>^CHSSWeb.WhBirthRecordServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.WhBirthRecordServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
