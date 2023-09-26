/// 名称: DtPortal.DD.DD10TwiceOpration
/// 描述: 查询科室二次手术
/// 编写者：程鹏
/// 编写日期:2019-81-29
/// 
Class DtPortal.DD.DD10TwiceOpration Extends %RegisteredObject [ ProcedureBlock ]
{

// DD10.01.01按月查询科二次手术的患者信息  	

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD10TwiceOpration","DD100101","2019-01-01","2019-01-31","110")

Query DD100101(StartDate As %String, EndDate As %String, LocGroupId As %String) As DtPortal.Query(ROWSPEC = "bedCode,patName,sex,age,medicareNo,admReason,regNo,docDesc,wardDesc,diagnoseDesc,inDay,inDateTime,OPNum,OPName1,OPDateTime1,OPName2,OPDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2") [ SqlProc ]
{
}

ClassMethod DD100101Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocGroupId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set LocStr=##class(DtPortal.DD.DD00PublicService).getDDloc(LocGroupId,"I")
	
	for index=1:1:$l(LocStr,"^")
	{
		set locID=$p(LocStr,"^",index)
		continue:locID=""
		Set rset = ##class(%ResultSet).%New("DtPortal.MD.MD16TwiceOpration:MD160102")
		Do rset.Execute(StartDate,EndDate,locID)
		While (rset.Next()) {
			set bedCode=rset.Data("bedCode")
			set patName=rset.Data("name")
			set sex=rset.Data("sex")
			set age=rset.Data("age")
			set medicareNo=rset.Data("medicareNo")
			set admReason=rset.Data("admReason")
			set regNo=rset.Data("regNo")
			set docDesc=rset.Data("docDesc")
			set wardDesc=rset.Data("wardDesc")
			set diagnoseDesc=rset.Data("diagnoseDesc")
			set inDay=rset.Data("inDay")
			set inDateTime=rset.Data("inDateTime")
			set OPNum=rset.Data("OPNum")
			set OPName1=rset.Data("OPName1")
			set OPDateTime1=rset.Data("OPDateTime1")
			set OPName2=rset.Data("OPName2")
			set OPDateTime2=rset.Data("OPDateTime2")
			set EpisodeId=rset.Data("EpisodeId")
			set OpNameAndTime1=rset.Data("OpNameAndTime1")
			set OpNameAndTime2=rset.Data("OpNameAndTime2")
			
			set ^||CacheTemp(repid,ind)=$lb(bedCode,patName,sex,age,medicareNo,admReason,regNo,docDesc,wardDesc,diagnoseDesc,inDay,inDateTime,OPNum,OPName1,OPDateTime1,OPName2,OPDateTime2,EpisodeId,OpNameAndTime1,OpNameAndTime2)
			set ind=ind+1	

		}
	}
	
	

	Quit $$$OK
}

}
