/// 类名: DtPortal.ND.ND04.ND0402NurseType
/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询护理部人力资源护士工作类型数据
Class DtPortal.ND.ND04.ND0402NurseType Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询全院各病区当前护士工作类型分布
/// Return： 
/// 服务编码：ND04.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND04.ND0402NurseType","ND040201")
Query ND040201() As DtPortal.Query(ROWSPEC = "wardLocID,WardDesc,total,NurseType1,NurseType2,valueNull")
{
}

ClassMethod ND040201Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
		
	d ##class(DtPortal.ND.ND04.ND0400Common).GetNurseData()
	
	set typeCode="NurseType"
	set subTypeStr="临床^非临床"			
	
	set wardLocID=""
	for
	{
		set wardLocID=$o(^||TMPPortalND0400Common(wardLocID))
		quit:wardLocID=""
		
		set data="",total=0,NurseType1="",NurseType2=""
		set total=$g(^||TMPPortalND0400Common(wardLocID,typeCode))
		
		set NurseType1=+$g(^||TMPPortalND0400Common(wardLocID,typeCode,"临床"))
		set NurseType2=+$g(^||TMPPortalND0400Common(wardLocID,typeCode,"非临床"))
		set valueNull=+$g(^||TMPPortalND0400Common(wardLocID,typeCode,"无"))
		
		set total=NurseType1+NurseType2
		set WardDesc=$p(^CTLOC(wardLocID),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		
		set Data=$lb(wardLocID,WardDesc,total,NurseType1,NurseType2,valueNull)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
	k ^||TMPPortalND0400Common
  	q $$$OK
}

}
