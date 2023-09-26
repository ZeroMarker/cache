Class CHSSWeb.PersonCommonObservationService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ItemRowId from CHSS.PersonCommonObservation"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s count=count+1
		s ItemRowId = result.Data("ItemRowId")
		s PersonCommon = ##class(CHSS.PersonCommonObservation).%OpenId(ItemRowId)
		s ItemAssortName=PersonCommon.ItemAssortName
		s ItemAssortCode=PersonCommon.ItemAssortCode
		s ItemdCode=PersonCommon.ItemdCode
		s ItemName=PersonCommon.ItemName
		s TableType=PersonCommon.TableType
		s RecordType=PersonCommon.RecordType
		s TableName=PersonCommon.TableName
		s RecordRowIdDR=PersonCommon.RecordRowIdDR
		s tmp=ItemRowId_"^"_ItemAssortName_"^"_ItemAssortCode_"^"_ItemdCode_"^"_ItemName_"^"_TableType_"^"_RecordType_"^"_TableName
		If (count>start)&(count<=end) d
        .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ItemRowId^ItemAssortName^ItemAssortCode^ItemdCode^ItemName^TableType^RecordType^TableName",count)
    k json
	q resultString
}

ClassMethod insert(ItemAssortName, ItemAssortCode, ItemdCode, ItemName, TableType, RecordType, TableName)
{
	 s PersonCommon=""
     s PersonCommon=##class(CHSS.PersonCommonObservation).%New()
     q:(PersonCommon="") 0
     s PersonCommon.ItemAssortName=ItemAssortName
	 s PersonCommon.ItemAssortCode=ItemAssortCode
	 s PersonCommon.ItemdCode=ItemdCode
	 s PersonCommon.ItemName=ItemName
	 s PersonCommon.TableType=TableType
	 s PersonCommon.RecordType=RecordType
	 s PersonCommon.TableName=TableName
	 s result=""
     s result=PersonCommon.%Save()
     Set resultString = ""
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCommon.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(ItemRowId, ItemAssortName, ItemAssortCode, ItemdCode, ItemName, TableType, RecordType, TableName)
{
     s PersonCommon=""
     s PersonCommon=##class(CHSS.PersonCommonObservation).%OpenId(ItemRowId)
     q:(PersonCommon="") 0
     s PersonCommon.ItemAssortName=ItemAssortName
	 s PersonCommon.ItemAssortCode=ItemAssortCode
	 s PersonCommon.ItemdCode=ItemdCode
	 s PersonCommon.ItemName=ItemName
	 s PersonCommon.TableType=TableType
	 s PersonCommon.RecordType=RecordType
	 s PersonCommon.TableName=TableName
	 s result=""
     s result=PersonCommon.%Save()
     Set resultString = ""
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCommon.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(ItemRowId)
{
	s PersonCommon=""
    s PersonCommon=##class(CHSS.PersonCommonObservation).%OpenId(ItemRowId)
    q:(PersonCommon="") 0
	s result=PersonCommon.%DeleteId(ItemRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

ClassMethod insertTest()
{
 s ItemAssortName="1"
 s ItemAssortCode="2"
 s ItemdCode="3"
 s ItemName="4"
 s TableType="5"
 s RecordType=6
 s TableName="7"
 d ..insert(ItemAssortName,ItemAssortCode,ItemdCode,ItemName,TableType,RecordType,TableName)
 w "OK"
}

ClassMethod editTest()
{
 s ItemRowId=1
  s ItemAssortName="11"
 s ItemAssortCode="22"
 s ItemdCode="33"
 s ItemName="44"
 s TableType="55"
 s RecordType=66
 s TableName="77"
 d ..edit(ItemRowId,ItemAssortName,ItemAssortCode,ItemdCode,ItemName,TableType,RecordType,TableName)
}

Storage Default
{
<Data name="PersonCommonObservationServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonCommonC3DD</DataLocation>
<DefaultData>PersonCommonObservationServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PersonCommonC3DD</IdLocation>
<IndexLocation>^CHSSWeb.PersonCommonC3DI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonCommonC3DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
