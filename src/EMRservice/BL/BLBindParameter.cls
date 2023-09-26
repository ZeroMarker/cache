/// 名称:EMRservice.BL.BLBindParameter
/// 描述:数据引用服务
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BL.BLBindParameter Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod DelParameterByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EMRmeta.BindParameter 
 Where QueryID =:AQueryID )
}

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SPM_BindParameter_SELECTALLQuery, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EMRmeta.BindParameter
 ORDER BY ID
}

Query SelectParameterByQueryID(AQuetyID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SPM_BindParameter_SelectParameterByQueryID, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EMRmeta.BindParameter
 Where QueryID= :AQuetyID
 ORDER BY ID
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLBindParameter","SelectDistinctParameter")
Query SelectDistinctParameter() As %Query(ROWSPEC = "ParameterName:%String")
{
}

ClassMethod SelectDistinctParameterExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s ParamName = ""
	for {
		s ParamName = $o(^DHCEMRM.BindParameterI("IdxParameterName",ParamName))
		q:(ParamName = "")
		
		s RowID = $o(^DHCEMRM.BindParameterI("IdxParameterName",ParamName,""))
		continue:(RowID = "")
		
		//s objParameter = $g(^DHCEMRM.BindParameterD(RowID))
		//s ParameterName = $list(objParameter,3)
		s objParameter = ##Class(EMRmeta.BindParameter).%OpenId(RowID)
		s ParameterName = objParameter.ParameterName
		s Data=$lb(ParameterName)
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
	}
		
	q $$$OK
}

ClassMethod SelectDistinctParameterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDistinctParameterExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectDistinctParameterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDistinctParameterExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod AddParameter(ABindParameter As EMRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 set objBindParameter = ##class(EMRmeta.BindParameter).%New()
 Quit:(objBindParameter ="") "ERROR" 
 set objBindParameter.Name = ABindParameter.Name
 set objBindParameter.Description = ABindParameter.Description
 set objBindParameter.ParameterName = ABindParameter.ParameterName
 set objBindParameter.ParameterType = ABindParameter.ParameterType
 set objBindParameter.QueryID = ABindParameter.QueryID
 //EMRmeta.BindParameter

 if '(objBindParameter.%Save())
 {
 Quit 0
 } 
 Quit objBindParameter.%Id()
}

ClassMethod DelParameterByID(AID As %String) As %Boolean [ WebMethod ]
{
 set objBindParameter = ##class(EMRmeta.BindParameter).%OpenId(AID)
 Quit:(objBindParameter ="") 0 

 if '(objBindParameter.%DeleteId(AID))
 {
 Quit 0
 }
 Quit 1
}

ClassMethod GetParameterByID(AID As %String) As EMRservice.entity.EBindParameter [ WebMethod ]
{
 set objBindParameter = ##class(EMRmeta.BindParameter).%OpenId(AID)
 q:(objBindParameter="") ""
 set Result = ##class(EMRservice.entity.EBindParameter).%New()
 set Result.ID = objBindQuery.%Id()
 set Result.ParameterName = objBindParameter.ParameterName
 set Result.ParameterType = objBindParameter.ParameterType
 Set Result.Name = objBindParameter.Name
 Set Result.Description = objBindParameter.Description
 set Result.QueryID = objBindParameter.QueryID
 Quit Result
}

ClassMethod UpdateParameter(ABindParameter As EMRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 set objBindParameter = ##class(EMRmeta.BindParameter).%OpenId(ABindParameter.ID)
 Quit:(objBindParameter ="") "0"
 set objBindParameter.Name = ABindParameter.Name
 set objBindParameter.Description = ABindParameter.Description
 set objBindParameter.ParameterName = ABindParameter.ParameterName
 set objBindParameter.ParameterType = ABindParameter.ParameterType
 set objBindParameter.QueryID = ABindParameter.QueryID


 if '(objBindParameter.%Save())
 {
 Quit "0"
 } 
 Quit "1"
}

}
