Import SQLuser

/// 存在系统		：体检系统
/// 关联数据		: DHC_PE_TempExpertDiagnosis
/// 主要功能		：新增医生建议导入维护 
Class web.DHCPE.TempExpertDiagnosis Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindTempExpertDiagnosis(TEDDisplayNamea As %String, TEDResult As %String) As %Query(ROWSPEC = "TED_DisplayName:%String, TED_Result:%String, TED_AddUser_DR:%String, TED_AddDate:%String, TED_AddTime:%String, TED_RowId:%String")
{
}

ClassMethod FindTempExpertDiagnosisExecute(ByRef qHandle As %Binary, aTEDDisplayNamea As %String, aTEDResult As %String) As %Status
{
      Set repid=$I(^CacheTemp)
      s ind=1
      s TEDDisplayName=""
      f  s TEDDisplayName=$o(^User.DHCPETempExpertDiagnosisI("DisplayNameIndex",TEDDisplayName)) q:TEDDisplayName=""  d
      .;w TEDDisplayName,!
      .s rowid="0"
      .f  s rowid=$o(^User.DHCPETempExpertDiagnosisI("DisplayNameIndex",TEDDisplayName,rowid)) q:rowid=""  d
      ..s TEDDisplayNamea=$LG(^User.DHCPETempExpertDiagnosisD(rowid),2)
      ..q:((""'=aTEDDisplayNamea)&((TEDDisplayNamea'[aTEDDisplayNamea)))
      ..s TEDResult=$LG(^User.DHCPETempExpertDiagnosisD(rowid),3)
      ..q:((""'=aTEDResult)&((TEDResult'[aTEDResult)))
      ..s TEDAddUserDR=$LG(^User.DHCPETempExpertDiagnosisD(rowid),4)
      ..s TEDAddDate=$LG(^User.DHCPETempExpertDiagnosisD(rowid),5)
      ..s TEDAddTime=$LG(^User.DHCPETempExpertDiagnosisD(rowid),6)
	  ..Do findPut
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK  
findPut
      set Data=$lb(TEDResult,TEDDisplayNamea,TEDAddUserDR,TEDAddDate,TEDAddTime,rowid)
      Set ^CacheTemp(repid,ind)=Data
      Set ind=ind+1
      quit
}

ClassMethod FindTempExpertDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTempExpertDiagnosisExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod FindTempExpertDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTempExpertDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//删除

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
  s rowId=$p(InString,"^",1)
	 &sql(

		delete from DHC_PE_TempExpertDiagnosis where TED_RowId=:rowId

	     )
	Q SQLCODE
}

}
