/// 类名: DtPortal.ND.ND01.ND0105NowPatList
/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询护理部重点关注当前在院患者列表
Class DtPortal.ND.ND01.ND0105NowPatList Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询全院各病区当前在院人数
/// Input：  Date      
/// Return： 
/// 服务编码：ND01.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0105NowPatList","ND010501")
Query ND010501() As DtPortal.Query(ROWSPEC = "WardDesc,PatNum,WardID")
{
}

ClassMethod ND010501Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	k ^||TMPPortalND010501($j)
	s wardID=0
	for{
		s wardID=$o(^PAWARD(wardID))
		quit:wardID=""
		s admStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",wardID,"true")
		continue:admStr=""
		set ^||TMPPortalND010501($j,wardID)=$l(admStr,"^")
	}

	
	
		
	set WardID=""	
	for
	{
		set WardID=$o(^||TMPPortalND010501($j,WardID))
		quit:WardID=""
		
		set PatNum=$g(^||TMPPortalND010501($j,WardID))
		set WardDesc=$p(^PAWARD(WardID),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
    	
    	set Data=$lb(WardDesc,PatNum,WardID)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}

  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询某病区当前在院人数详情
/// Input：  WardId      病区ID    
/// Return： 
/// 服务编码：ND01.05.02
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0105NowPatList","ND010502","1")
Query ND010502(WardId As %String) As DtPortal.Query(ROWSPEC = "BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag")
{
}

ClassMethod ND010502Execute(ByRef qHandle As %Binary, WardId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	
	
	
	s admStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",WardId,"true")
	q:admStr="" $$$OK
	if (admStr'="") {
		for index=1:1:$l(admStr,"^")
		{
			set PAAdm=$p(admStr,"^",index)
			continue:PAAdm=""
			d getPadmInfo
		}
	}
	

  	q $$$OK
  	
getPadmInfo
	set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	set BedCode=$p(patInfoStr,"^",1)
	set Name=$p(patInfoStr,"^",2)
	set Sex=$p(patInfoStr,"^",3)
	set Age=$p(patInfoStr,"^",4)
	set MedicareNo=$p(patInfoStr,"^",5)   //病案号
	set AdmReason=$p(patInfoStr,"^",6)    //费用类型
	set Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)
	
	set Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag)
 	set ^||CacheTemp(repid,ind)=Data	
 	set ind=ind+1
}

}
