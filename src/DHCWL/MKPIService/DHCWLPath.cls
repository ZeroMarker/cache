Class DHCWL.MKPIService.DHCWLPath Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(DHCWL.MKPIService.DHCWLPath).UpgradePath110()

/// Creator：      ban
/// CreatDate：    2012-07-11
/// Description:： 升级至版本1.10需要的补丁(新安装不需要此补丁)
/// Table：        
/// Input：        
/// Output：      
/// Return：       
/// Others：   
ClassMethod UpgradePath110() As %Status
{
	n
	
	//1.表DHCWL.MKPI.Months增加索引,需要重新生成索引
	d ##class(DHCWL.MKPI.Months).%BuildIndices()
	//2.表DHCWL.MKPI.MKPI增加字段MKPIDataNod,需要更新默认值为空
	&sql(update DHCWL_MKPI.DHCWLMKPI set MKPI_DataNod="")
	q
}

}
