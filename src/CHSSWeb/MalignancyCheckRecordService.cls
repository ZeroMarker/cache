Class CHSSWeb.MalignancyCheckRecordService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: zwp
/// CreatDate：2010-04-09
/// Description:恶性肿瘤随访信息列表
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod List(Start, Limit, id)
{
      Set PersonRowId=$G(id)
      Set start=$G(start)
      Set limit=$G(limit)
      Set count=0
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CheckRowId from CHSS.MalignancyCheckRecord where PersonRowId="_PersonRowId_""
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s count=count+1
		s CheckRowId = result.Data("CheckRowId")
		s MalignancyCheck = ##class(CHSS.MalignancyCheckRecord).%OpenId(CheckRowId)
		
		
		s DateCheck=MalignancyCheck.DateCheck
	    i DateCheck '= "" d
        .s DateCheck = $zd(DateCheck,3)
        
        s CheckType=""
        s CheckTypeName=""
        i MalignancyCheck.CheckType'="" d
        .s CheckType =MalignancyCheck.CheckType.%Id()
        .s CheckTypeName =MalignancyCheck.CheckType.Description
       	
       	s CheckAdd = MalignancyCheck.CheckAdd
       	
       	s Symptom=""
        s SymptomName = MalignancyCheck.Symptom

    
        s OtherSymptom=MalignancyCheck.OtherSymptom
        s CheckDoctor = MalignancyCheck.CheckDoctor
        s nHighPressure =MalignancyCheck.nHighPressure
        s nLowPressure =MalignancyCheck.nLowPressure
        s HeartRate =MalignancyCheck.HeartRate
        s OtherCheck=MalignancyCheck.OtherCheck
        s Weight=MalignancyCheck.Weight
        s Height =MalignancyCheck.Height
        s BMI =MalignancyCheck.BMI
        
        s CureSituation=""
        s CureSituationName=""
        i MalignancyCheck.CureSituation'="" d 
        .s CureSituation=MalignancyCheck.CureSituation.%Id()
        .s CureSituationName=MalignancyCheck.CureSituation.Description
        
        s bRelapse=MalignancyCheck.bRelapse
        s RelapseNum=MalignancyCheck.RelapseNum
        s bTransfer=MalignancyCheck.bTransfer
        s TransferPart=MalignancyCheck.TransferPart
        s CurrentSymptom=MalignancyCheck.CurrentSymptom
        s bSmoke =MalignancyCheck.bSmoke
        
        s Guide=""
        s GuideName=""
        i MalignancyCheck.Guide'="" d 
        .s Guide=MalignancyCheck.Guide.%Id()
        .s GuideName=MalignancyCheck.Guide.Description
        
        s KPS=""
        s KPSName=""
        i MalignancyCheck.KPS'="" d
        .s KPS= MalignancyCheck.KPS.%Id()
        .s KPSName= MalignancyCheck.KPS.Description
        
        s Remark= MalignancyCheck.Remark
        
		s tmp=CheckRowId
		s tmp=tmp_"^"_DateCheck_"^"_CheckType_"^"_CheckTypeName
		s tmp=tmp_"^"_CheckAdd
		s tmp= tmp_"^"_Symptom_"^"_SymptomName_"^"_OtherSymptom_"^"_CheckDoctor_"^"_nHighPressure
		s tmp=tmp_"^"_nLowPressure_"^"_HeartRate_"^"_OtherCheck_"^"_Weight
		s tmp=tmp_"^"_Height_"^"_BMI_"^"_CureSituation_"^"_CureSituationName
		s tmp=tmp_"^"_bRelapse_"^"_RelapseNum_"^"_bTransfer_"^"_TransferPart
		s tmp=tmp_"^"_CurrentSymptom_"^"_bSmoke_"^"_Guide_"^"_GuideName_"^"_KPS
		s tmp=tmp_"^"_KPSName_"^"_Remark
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("CheckRowId^DateCheck^CheckType^CheckTypeName^CheckAdd^Symptom^SymptomName^OtherSymptom^CheckDoctor^nHighPressure^nLowPressure^HeartRate^OtherCheck^Weight^Height^BMI^CureSituation^CureSituationName^bRelapse^RelapseNum^bTransfer^TransferPart^CurrentSymptom^bSmoke^Guide^GuideName^KPS^KPSName^Remark",count)
    k json
	q resultString
}

/// Creator: zwp
/// CreatDate：2010-04-09
/// Description:恶性肿瘤随访信息添加
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod insert(PersonRowId, DateCheck, CheckDoctor, CheckAdd, CheckType, nHighPressure, nLowPressure, Symptom, OtherSymptom, Height, Weight, BMI, HeartRate, OtherCheck, bSmoke, bRelapse, RelapseNum, bTransfer, TransferPart, CureSituation, CurrentSymptom, Guide, KPS, Remark)
{
	     s MalignancyCheckRecord=""
         s MalignancyCheckRecord=##class(CHSS.MalignancyCheckRecord).%New()
         q:(MalignancyCheckRecord="") 0
                 
	  
        i PersonRowId '= "" d
        .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
        .s MalignancyCheckRecord.PersonRowId=PersonRowIdobj
      
         i DateCheck '= "" d
         .s DateCheck=$zdh(DateCheck ,3)
         s MalignancyCheckRecord.DateCheck=DateCheck
      
         s MalignancyCheckRecord.CheckDoctor=CheckDoctor
         s MalignancyCheckRecord.CheckAdd=CheckAdd
       
         i CheckType'="" d
         .s MalignancyCheckRecord.CheckType=##class(CHSS.DictCheckType).%OpenId(CheckType)
       
       
         s MalignancyCheckRecord.nHighPressure=nHighPressure
         s MalignancyCheckRecord.nLowPressure=nLowPressure
         
         s MalignancyCheckRecord.Symptom=Symptom
      
      
      
          s MalignancyCheckRecord.OtherSymptom=OtherSymptom
          s MalignancyCheckRecord.Height=Height
          s MalignancyCheckRecord.Weight=Weight
          s MalignancyCheckRecord.BMI=BMI
          s MalignancyCheckRecord.HeartRate=HeartRate
          s MalignancyCheckRecord.OtherCheck=OtherCheck
          s MalignancyCheckRecord.bSmoke=bSmoke
          s MalignancyCheckRecord.bRelapse=bRelapse
          s MalignancyCheckRecord.RelapseNum=RelapseNum
          s MalignancyCheckRecord.bTransfer=bTransfer
          s MalignancyCheckRecord.TransferPart=TransferPart
          i CureSituation'="" d
          .s MalignancyCheckRecord.CureSituation=##class(CHSS.DictCureSituation).%OpenId(CureSituation)
          s MalignancyCheckRecord.CurrentSymptom=CurrentSymptom
          i Guide'="" d
          .s MalignancyCheckRecord.Guide=##class(CHSS.DictGuide).%OpenId(Guide)
          s MalignancyCheckRecord.Guide=Guide
          i KPS'="" d
          .s MalignancyCheckRecord.KPS=##class(CHSS.DictKPS).%OpenId(KPS)
          s MalignancyCheckRecord.Remark=Remark
          
      s result=""
      s result=MalignancyCheckRecord.%Save()
      
     Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_MalignancyCheckRecord.%Id()_"}"
      e  d
       .s resultString = "{""success"":""failed"",""info"":""error""}"
      q resultString
}

/// Creator: zwp
/// CreatDate：2010-04-13
/// Description:恶性肿瘤随访信息编辑
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod edit(CheckRowId, DateCheck, CheckDoctor, CheckAdd, CheckType, nHighPressure, nLowPressure, Symptom, OtherSymptom, Height, Weight, BMI, HeartRate, OtherCheck, bSmoke, bRelapse, RelapseNum, bTransfer, TransferPart, CureSituation, CurrentSymptom, Guide, KPS, Remark)
{
         s MalignancyCheckRecord=""
         s MalignancyCheckRecord=##class(CHSS.MalignancyCheckRecord).%OpenId(CheckRowId)
         q:(MalignancyCheckRecord="") 0
                
         i DateCheck '= "" d
         .s DateCheck=$zdh(DateCheck ,3)
         s MalignancyCheckRecord.DateCheck=DateCheck
      
         s MalignancyCheckRecord.CheckDoctor=CheckDoctor
         s MalignancyCheckRecord.CheckAdd=CheckAdd
       
         i CheckType'="" d
         .s MalignancyCheckRecord.CheckType=##class(CHSS.DictCheckType).%OpenId(CheckType)
       
       
         s MalignancyCheckRecord.nHighPressure=nHighPressure
         s MalignancyCheckRecord.nLowPressure=nLowPressure
         
         s MalignancyCheckRecord.Symptom=Symptom
      
      
      
          s MalignancyCheckRecord.OtherSymptom=OtherSymptom
          s MalignancyCheckRecord.Height=Height
          s MalignancyCheckRecord.Weight=Weight
          s MalignancyCheckRecord.BMI=BMI
          s MalignancyCheckRecord.HeartRate=HeartRate
          s MalignancyCheckRecord.OtherCheck=OtherCheck
          s MalignancyCheckRecord.bSmoke=bSmoke
          s MalignancyCheckRecord.bRelapse=bRelapse
          s MalignancyCheckRecord.RelapseNum=RelapseNum
          s MalignancyCheckRecord.bTransfer=bTransfer
          s MalignancyCheckRecord.TransferPart=TransferPart
          i CureSituation'="" d
          .s MalignancyCheckRecord.CureSituation=##class(CHSS.DictCureSituation).%OpenId(Guide)
          s MalignancyCheckRecord.CurrentSymptom=CurrentSymptom
          i Guide'="" d
          .s MalignancyCheckRecord.Guide=##class(CHSS.DictGuide).%OpenId(Guide)
          s MalignancyCheckRecord.Guide=Guide
          i KPS'="" d
          .s MalignancyCheckRecord.KPS=##class(CHSS.DictKPS).%OpenId(KPS)
          s MalignancyCheckRecord.Remark=Remark
          
      s result=""
      s result=MalignancyCheckRecord.%Save()
      
     Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_MalignancyCheckRecord.%Id()_"}"
      e  d
       .s resultString = "{""success"":""failed"",""info"":""error""}"
      q resultString
}

/// Creator: zwp
/// CreatDate：2010-04-09
/// Description:恶性肿瘤随访信息删除
/// Table：ElerlyHealthCheckRecord
/// Input: ElerlyHealthCheckRecord
/// Output：
/// Return：
/// Others：
ClassMethod delete(CheckRowid)
{
	s MalignancyCheckRecord=""
    s MalignancyCheckRecord=##class(CHSS.MalignancyCheckRecord).%OpenId(CheckRowid)
    q:(MalignancyCheckRecord="") 0
    s result=MalignancyCheckRecord.%DeleteId(CheckRowid)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="MalignancyCheckRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.MalignancyChB11D</DataLocation>
<DefaultData>MalignancyCheckRecordServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.MalignancyChB11D</IdLocation>
<IndexLocation>^CHSSWeb.MalignancyChB11I</IndexLocation>
<StreamLocation>^CHSSWeb.MalignancyChB11S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
