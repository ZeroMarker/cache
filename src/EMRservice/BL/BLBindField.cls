/// 名称:EMRservice.BL.BLBindField
/// 描述:数据引用服务
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BL.BLBindField Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod DelFieldByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EMRmeta.BindField 
 Where QueryID =:AQueryID )
}

Query SelectAllField() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,QueryID:%String,FieldName:%String,FieldType:%String,Description:%String,DicID:%String,ValueType:%String", SELECTMODE = "RUNTIME") [ SqlName = SPM_BindField_SELECTAllField, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description, DicID,ValueType
 FROM EMRmeta.BindField
 ORDER BY ID
}

Query SelectFieldByQID(AQID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String, QueryID:%String,FieldName:%String,FieldType:%String,Description:%String,DicID:%String,ValueType:%String", SELECTMODE = "RUNTIME") [ SqlName = SPM_BindField_SELECTFieldByQID, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description, DicID,ValueType
 FROM EMRmeta.BindField
 Where QueryID =:AQID 
 ORDER BY ID
}

ClassMethod AddField(ABindField As EMRservice.entity.EBindField) As %String [ WebMethod ]
{
 set objBindField = ##class(EMRmeta.BindField).%New()
 Quit:(objBindField ="") "ERROR" 
 set objBindField.Name = ABindField.Name
 set objBindField.Description = ABindField.Description
 set objBindField.FieldName = ABindField.FieldName
 set objBindField.FieldType = ABindField.FieldType
 set objBindField.QueryID = ABindField.QueryID
 set objBindField.DicID = ABindField.DicID
 set objBindField.ValueType = ABindField.ValueType
 if '(objBindField.%Save())
 {
 Quit 0
 } 
 Quit objBindField.%Id()
}

ClassMethod DelFieldByID(AID As %String) As %Boolean [ WebMethod ]
{
 //B "S"
 set objBindField = ##class(EMRmeta.BindField).%OpenId(AID)
 Quit:(objBindField ="") 0 

 if '(objBindField.%DeleteId(AID))
 {
 Quit 0
 }
 Quit 1
}

ClassMethod GetFieldByID(AID As %String) As EMRservice.entity.EBindField [ WebMethod ]
{
 set objBindQuery = ##class(EMRmeta.BindField).%OpenId(AID)
 q:(objBindQuery="") ""
 set Result = ##class(EMRservice.entity.EBindField).%New()
 set Result.ID = objBindQuery.%Id()
 set Result.Name = objBindQuery.Name
 set Result.FieldName = objBindQuery.FieldName
 set Result.FieldType = objBindQuery.FieldType
 Set Result.QueryID = objBindQuery.QueryID
 set Result.Description = objBindQuery.Description
 set Result.ValueType = objBindQuery.ValueType
 Quit Result
}

ClassMethod UpdateField(ABindField As EMRservice.entity.EBindField) As %String [ WebMethod ]
{
 set objBindField = ##class(EMRmeta.BindField).%OpenId(ABindField.ID)
 Quit:(objBindField ="") "0"

 set objBindField.Name = ABindField.Name
 set objBindField.Description = ABindField.Description
 set objBindField.FieldName = ABindField.FieldName
 set objBindField.FieldType = ABindField.FieldType
 set objBindField.QueryID = ABindField.QueryID
 set objBindField.DicID = ABindField.DicID
 set objBindField.ValueType = ABindField.ValueType

 if '(objBindField.%Save())
 {
 Quit "0"
 } 
 Quit "1"
}

}
