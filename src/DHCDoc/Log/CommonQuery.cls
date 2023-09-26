Class DHCDoc.Log.CommonQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCDoc.Log.CommonQuery","FindCommonLog","2020-02-29","2020-07-13") 
Query FindCommonLog(Stdate As %String, EndDate As %String, CallClass As %String = "", CallMeth As %String = "", LogDesc As %String = "", LogKey As %String = "", LogValue As %String = "") As %Query(ROWSPEC = "ID:%String,FInsType:%String,FCallClass:%String,FCallMethod:%String,FLogDesc:%String,FLogKey:%String,FLogValue:%String,FInsertDate:%String,FInsertTime:%String,FLastUpdateDate:%String,FLastUpdateTime:%String")
{
}

ClassMethod FindCommonLogExecute(ByRef qHandle As %Binary, Stdate As %String, EndDate As %String, CallClass As %String = "", CallMeth As %String = "", LogDesc As %String = "", LogKey As %String = "", LogValue As %String = "") As %Status
{
		Set repid=$I(^CacheTemp)
 		s ind=1
 		s Stdate=##class(websys.Conversions).DateHtmlToLogical(Stdate)
 		s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 		if ((Stdate'="")&&(EndDate'="")){
			&SQL(DECLARE EmpCommonLog CURSOR FOR
				SELECT ID,InsType,CallClass,CallMethod,LogDesc,LogKey,LogValue,InsertDate,InsertTime ,LastUpdateDate,LastUpdateTime
				into :ID,:FInsType,:FCallClass,:FCallMethod,:FLogDesc,:FLogKey,:FLogValue,:FInsertDate,:FInsertTime,:FLastUpdateDate,:FLastUpdateTime
				FROM DHCDoc_Log.Common 
				WHERE InsertDate>=:Stdate
				AND InsertDate<=:EndDate
				ORDER BY ID desc) 
			 &SQL(OPEN EmpCommonLog)
			 for  &SQL(FETCH EmpCommonLog) QUIT:SQLCODE  do
			 .Q:((CallClass'="")&&(FCallClass'[CallClass))
			 .Q:((CallMeth'="")&&(FCallMethod'[CallMeth))
			 .Q:((LogKey'="")&&(FLogKey'[LogKey))
			 .Q:((LogValue'="")&&(FLogValue'[LogValue))
			 .Q:((LogDesc'="")&&(FLogDesc'[LogDesc))
			 .s:FInsertDate'="" FInsertDate=##Class(websys.Conversions).DateLogicalToHtml(FInsertDate)
			 .s:FInsertTime'="" FInsertTime=$ZT(FInsertTime,1)
			 .s:FLastUpdateDate'="" FLastUpdateDate=##Class(websys.Conversions).DateLogicalToHtml(FLastUpdateDate)
			 .s:FLastUpdateTime'="" FLastUpdateTime=$ZT(FLastUpdateTime,1)
			 .s FInsType=$case(FInsType,"I":"插入","U":"更新",:FInsType)
			 .Do OutputFindCommonLog()
			 &sql(close EmpCommonLog)
 		}
    	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
OutputFindCommonLog()
	set Data=$lb(ID,FInsType,FCallClass,FCallMethod,FLogDesc,FLogKey,FLogValue,FInsertDate,FInsertTime,FLastUpdateDate,FLastUpdateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCommonLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommonLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCommonLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommonLogExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
