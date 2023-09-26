Class CIS.AN.BL.DataConfiguration Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-03-07
/// Description： 	获取下一个手术过程(扫描登记号)
/// Table：        	DHCAN.SurgicalProcedure
/// Input:			regNo:登记号,operDate:手术日期,userDeptID:用户科室ID
/// Return：       	JSON
/// w ##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
ClassMethod GetValueByKey(key As %String) As %String
{
	set result=""
	set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDataConfigurations")
	set sc=query.Execute(key)
	while(query.%Next())
	{
		set result=query.Get("DataValue")	
	}	
	quit result
}

/// w ##class(CIS.AN.BL.DataConfiguration).AddPermission("53","N")
ClassMethod AddPermission(configGroupID As %String, clearPermission As %String = "N") As %String
{
	quit:(configGroupID="") "E^配置权限安全组ID不能为空"
	set $zt="Error"
	tstart
	if (clearPermission="Y")
	{
		merge ^DHCANCDBak("MODP")=^CF.AN.ModulePermissionD
		merge ^DHCANCIBak("MODP")=^CF.AN.ModulePermissionI
		kill ^CF.AN.ModulePermissionD
		kill ^CF.AN.ModulePermissionI
	}
	set moduleCode="ModulePermission",parentModuleCode="SystemConfiguration"
	set query=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDataModule")
	set sc=query.Execute("","",moduleCode)
	set moduleRowId="",parentModuleId=""
	while(query.%Next())
	{
		set moduleRowId=query.Get("RowId")	
	}	
	set sc=query.Execute("","",parentModuleCode)
	while(query.%Next())
	{
		set parentModuleId=query.Get("RowId")	
	}
	//b //ccq
	set modulePermission=##class(CF.AN.ModulePermission).%New()
	set modulePermission.GroupID=configGroupID
	set modulePermission.DataModule=##class(CT.AN.DataModule).%OpenId(moduleRowId)
	set modulePermission.Active="Y"
	set sc=modulePermission.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc,"zh-cn")	
	}
	
	set modulePermission=##class(CF.AN.ModulePermission).%New()
	set modulePermission.GroupID=configGroupID
	set modulePermission.DataModule=##class(CT.AN.DataModule).%OpenId(parentModuleId)
	set modulePermission.Active="Y"
	set sc=modulePermission.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc,"zh-cn")	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SaveConfig(para As %String) As %String
{
	set configId=""
}

/// 保存安全组菜单授权记录
ClassMethod SaveMenuPermissions(paraStr As %String) As %String
{
	set saveResult=""
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(paraStr,.array)
    set objIndex=0
    for
    {
        set objIndex=$order(array(objIndex))
        quit:(objIndex="")
        k singleData
        set popNode="",singleData=""

				// 对于某个安全组，同一个菜单不能有两条授权记录
				set groupID=$g(array(objIndex,"RoleGroup"))
				set menuItemID=$g(array(objIndex,"MenuItem"))
				set permissionID=""
				&sql(select RowId into :permissionID from CF_AN.MenuPermission where RoleGroup=:groupID and MenuItem=:menuItemID)
				set:(permissionID>0) array(objIndex,"RowId")=permissionID
        
				for 
        {
            set popNode=$order(array(objIndex,popNode))
            quit:(popNode="")
            
            set singleData(popNode)=array(objIndex,popNode)
        }
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.singleData)
        quit:($piece(saveResult,"^",1)="E")
    }
    if ($piece(saveResult,"^",1)="E")
    {
        trollback
        quit saveResult 
    }
    tcommit 
    quit "S^"
}

}
