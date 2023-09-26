Class CIS.AN.BL.DeptEquip Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-08-13
/// Description： 	保存麻醉科设备信息
/// Table：        	CF.AN.DeptEquip,CF.AN.EquipCollection
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.DeptEquip).SaveDeptEquip(^tmpzmy(14))
ClassMethod SaveDeptEquip(data As %String) As %String
{
	s ^tmpzmy(14)=data
	tstart
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult=""
	merge ^TMPAN("SaveDeptEquip")=array
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		merge DeptEquip=array(objIndex)
		continue:($g(DeptEquip("ClassName"))'="CF.AN.DeptEquip")
		m DeptEquip("Location")=DeptEquip("RoomLocation")
		b //ccq
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.DeptEquip)
		quit:($piece(saveResult,"^",1)'="S")
		set equipRowId=$piece(saveResult,"^",2),guid=DeptEquip("Guid")
		
		set subIndex=0
		for
		{
			set subIndex=$order(array(subIndex))
			quit:(subIndex="")
			merge EquipCollection=array(subIndex)
			continue:($get(EquipCollection("ClassName"))'="CF.AN.EquipCollection")
			set deptEquipGuid=EquipCollection("DeptEquipGuid")
			continue:(deptEquipGuid'=guid)
			set EquipCollection("Equip")=equipRowId
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.EquipCollection)
			quit:($piece(saveResult,"^",1)'="S")
		}
		quit:($piece(saveResult,"^",1)'="S")
	}	
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult		
	}
	tcommit
	quit "S^"
}

ClassMethod GetMirrorEquipCount(deptId As %String, roomTypePara As %String, equipTypePara As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDeptEquip")
	set sc=rset.Execute(deptId)
	set roomTypePara="^"_$System.SQL.ALPHAUP(roomTypePara)_"^"
	set equipTypePara="^"_equipTypePara_"^"
	set equipCount=0
	while(rset.%Next())
	{
		set equipType=rset.Get("EquipTypeDesc")
		continue:(equipTypePara '[ ("^"_$System.SQL.ALPHAUP(equipType)_"^"))
		set roomType=rset.Get("LocType")
		continue:(roomTypePara '[ ("^"_$System.SQL.ALPHAUP(roomType)_"^"))
		set equipCount=equipCount+1
			
	}
	quit equipCount
}

}
