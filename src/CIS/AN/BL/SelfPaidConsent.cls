Class CIS.AN.BL.SelfPaidConsent Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-08-28
/// Description： 	保存自费项目数据
/// Table：        	CIS.AN.SelfPaidDrugData,CIS.AN.SelfPaidMaterialData
/// Input:			jsonString:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.SelfPaidConsent).SaveData("")
ClassMethod SaveData(jsonString As %String) As %String
{
	tstart	
	set sc=##class(CIS.AN.COM.String).ToArray(jsonString,.array)
	set objIndex=0
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")

		kill data
		merge data=array(objIndex)
		
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
		quit:($piece(saveResult,"^",1)="E")	
	}	

	if (saveResult [ "E^")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-28
/// Description： 	创建自费药品项目
/// Table：        	CF.AN.SelfPaidDrug
/// Input:			jsonString:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.SelfPaidConsent).AddDrug("")
ClassMethod AddDrug(jsonString As %String) As %String
{
	tstart	
	set sc=##class(CIS.AN.COM.String).ToArray(jsonString,.array)
	set objIndex=1
	kill data
	merge data=array(objIndex)
		
	if ($g(data("ClassName"))'="CF.AN.SelfPaidDrug")
	{
		trollback
		quit "E^数据表名称对应错误"	
	}
	
	set deptID=data("DeptID")
	if (deptID="")
	{
		trollback
		quit "E^科室ID为空"	
	}
	
	set desc=$ZCVT(data("Description"),"U")
	if $o(^CF.AN.SelfPaidDrugI("DeptDesc"," "_deptID," "_desc,""))>0
	{
		trollback
		quit "E^此药品已存在，不能重复添加！"	
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)	

	if (saveResult [ "E^")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-28
/// Description： 	创建一次性自费项目
/// Table：        	CF.AN.SelfPaidMaterial
/// Input:			jsonString:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.SelfPaidConsent).AddMaterial("")
ClassMethod AddMaterial(jsonString As %String) As %String
{
	tstart	
	set sc=##class(CIS.AN.COM.String).ToArray(jsonString,.array)
	set objIndex=1
	kill data
	merge data=array(objIndex)
		
	if ($g(data("ClassName"))'="CF.AN.SelfPaidMaterial")
	{
		trollback
		quit "E^数据表名称对应错误"	
	}
	
	set deptID=data("DeptID")
	if (deptID="")
	{
		trollback
		quit "E^科室ID为空"	
	}
	
	set desc=$ZCVT(data("Description"),"U")
	if $o(^CF.AN.SelfPaidMaterialI("DeptDesc"," "_deptID," "_desc,""))>0
	{
		trollback
		quit "E^此药品已存在，不能重复添加！"	
	}
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
	
	if (saveResult [ "E^")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
}

}
