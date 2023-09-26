Import SQLUser

/// Class Name:	EPRservice.Quality.DataGather.Hospital
/// Description:查询医院列表;
/// Author:		Zuoxiang Xie
/// CreateDate:	2010-04-26
/// Version:
Class EPRservice.Quality.DataGather.Hospital Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:	获取医院列表;
/// Output:	RowId-医院RowId，Code-医院编码，Desc-医院名称
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataGather.Hospital","GetHospitalList")
Query GetHospitalList() As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetHospitalListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s (RowID,Code,Desc) = ""
	s RowID = $o(^CT("HOSP",0))
	While(RowID '= "")
	{
		s Code = $p($g(^CT("HOSP",RowID)),"^",1)		
		s Desc = $p($g(^CT("HOSP",RowID)),"^",2)
		
		s Data = $lb(RowID,Code,Desc)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind+1
		
		s RowID = $o(^CT("HOSP",RowID))
	}
	q $$$OK
}

ClassMethod GetHospitalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalListExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{				
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{			
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetHospitalListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	通过医院id取医院名称
/// Output:	(医院名称)
/// debug: w ##class(EPRservice.HISInterface.PatientInfoAssist).GetHospNameById("2")
ClassMethod GetHospNameById(AId As %String) As %String
{
	s ret=""
	
	s HospOBJ=##Class(User.CTHospital).%OpenId(AId)
	if (HospOBJ'="")
	{
		s ret=HospOBJ.HOSPDesc
	}
	d HospOBJ.%Close()	
	q ret
}

}
