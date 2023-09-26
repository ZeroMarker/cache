Class CIS.AN.BL.AnaestMethod Extends %RegisteredObject
{

/// Creator：      	yongyang
/// CreatDate：    	2021-05-14
/// Description： 	保存麻醉方法相关插管项目可见性配置
/// Table：        	CT.AN.AnaMethodPermission
/// Input:			data:数据参数
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.AnaestMethod).SavePermissions("")
ClassMethod SavePermissions(data As %String) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set index=0,saveResult="S^"
	for
	{
		set index=$order(array(index))
		quit:(index="")
		kill PLIST
		m PLIST=array(index)
		set PLIST("ClassName")="CT.AN.AnaMethodPermission"
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.PLIST)
		quit:($piece(saveResult,"^",1)'="S")
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

}
