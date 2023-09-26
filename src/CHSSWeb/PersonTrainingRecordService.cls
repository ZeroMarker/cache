Class CHSSWeb.PersonTrainingRecordService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:训练记录
/// Table：PersonTrainingRecord
/// Input: PersonTrainingRecord
/// Output：
/// Return：
/// Others：
ClassMethod List(TrainRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
{
      
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      
      Set tmp = ""
      
      s result = ##class(%Library.ResultSet).%New()
	  s sqlStr = "select RecordRowId from CHSS.PersonTrainingRecord where TrainRowId="_TrainRowId
      
      d result.Prepare(sqlStr)
	  d result.Execute()
      
      
      While(result.Next())
	  {
      
      s RecordRowId = result.Data("RecordRowId")     
                 
      s tempPersonTrainingRecord=##class(CHSS.PersonTrainingRecord).%OpenId(RecordRowId)
      
      ;s TrainRowId = tempPersonTrainingRecord.TrainRowId
            
      s DateOfTrain = tempPersonTrainingRecord.DateOfTrain
      i DateOfTrain '= "" d
      .s DateOfTrain = $zd(DateOfTrain,3)
      
      
      s DateOfNextTrain = tempPersonTrainingRecord.DateOfNextTrain
      i DateOfNextTrain '= "" d
      .s DateOfNextTrain = $zd(DateOfNextTrain,3)
      
      s Doctor = tempPersonTrainingRecord.Doctor
      s TrainContent = tempPersonTrainingRecord.TrainContent
      s TrainInfo = tempPersonTrainingRecord.TrainInfo
      s Remark = tempPersonTrainingRecord.Remark
      
      
      Set tmp = RecordRowId_"^"_DateOfTrain_"^"_DateOfNextTrain_"^"_Doctor_"^"_TrainContent_"^"_TrainInfo_"^"_Remark


      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
	  }
      
      Set resultString = json.getJsonData("RecordRowId^DateOfTrain^DateOfNextTrain^Doctor^TrainContent^TrainInfo^Remark",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:添加训练记录
/// Table：PersonTrainingRecord
/// Input: PersonTrainingRecord
/// Output：
/// Return：
/// Others：
ClassMethod Insert(TrainRowId As %Integer, DateOfTrain As %Date, DateOfNextTrain As %Date, Doctor As %String, TrainContent As %String, TrainInfo As %String, Remark As %String) As %String
{
      s tempPersonTrainingRecord=""
      s tempPersonTrainingRecord=##class(CHSS.PersonTrainingRecord).%New()
      q:(tempPersonTrainingRecord="") 0
      
      
      s TrainRowIdobj=##class(CHSS.PersonDeformityTraining).%OpenId(TrainRowId)
      s tempPersonTrainingRecord.TrainRowId=TrainRowIdobj
      
            
      i DateOfTrain '= "" d
      .s DateOfTrain=$zdh(DateOfTrain ,3)
      s tempPersonTrainingRecord.DateOfTrain=DateOfTrain
            
      i DateOfNextTrain '= "" d
      .s DateOfNextTrain=$zdh(DateOfNextTrain ,3)
      s tempPersonTrainingRecord.DateOfNextTrain=DateOfNextTrain
      
      s tempPersonTrainingRecord.Doctor = Doctor
      s tempPersonTrainingRecord.TrainContent = TrainContent
      s tempPersonTrainingRecord.TrainInfo = TrainInfo
      s tempPersonTrainingRecord.Remark = Remark

 
      s result=""
      s result=tempPersonTrainingRecord.%Save()
      Set resultString = ""
      
           
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempPersonTrainingRecord.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempPersonTrainingRecord.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:更新训练记录
/// Table：PersonTrainingRecord
/// Input: PersonTrainingRecord
/// Output：
/// Return：
/// Others：
ClassMethod Update(RecordRowId As %Integer, DateOfTrain As %Date, DateOfNextTrain As %Date, Doctor As %String, TrainContent As %String, TrainInfo As %String, Remark As %String) As %String
{
  
      q:($d(RecordRowId)=0)||(RecordRowId="")
      
      s tempPersonTrainingRecord="",result=""
      s tempPersonTrainingRecord=##class(CHSS.PersonTrainingRecord).%OpenId(RecordRowId)
      q:(tempPersonTrainingRecord="") 0
       
                        
      i DateOfTrain '= "" d
      .s DateOfTrain=$zdh(DateOfTrain ,3)
      s tempPersonTrainingRecord.DateOfTrain=DateOfTrain
            
      i DateOfNextTrain '= "" d
      .s DateOfNextTrain=$zdh(DateOfNextTrain ,3)
      s tempPersonTrainingRecord.DateOfNextTrain=DateOfNextTrain
      
      
      s tempPersonTrainingRecord.Doctor = Doctor
      s tempPersonTrainingRecord.TrainContent = TrainContent
      s tempPersonTrainingRecord.TrainInfo = TrainInfo
      s tempPersonTrainingRecord.Remark = Remark

        
      s result=""
      s result=tempPersonTrainingRecord.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_RecordRowId_"}"
      .///w "{""success"":""true"",""info"":"_RecordRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:删除训练登记表
/// Table：PersonTrainingRecord
/// Input: RecordRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(RecordRowId As %String) As %String
{
                
      &sql(delete from CHSS.PersonTrainingRecord where %ID=:RecordRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_RecordRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="PersonTrainingRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonTrainiAE3D</DataLocation>
<DefaultData>PersonTrainingRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonTrainiAE3D</IdLocation>
<IndexLocation>^CHSSWeb.PersonTrainiAE3I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonTrainiAE3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
