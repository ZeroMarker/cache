/// 麻醉记录参数业务逻辑类
Class CIS.AN.BL.RecordPara Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-03-13
/// Description： 	保存麻醉记录参数和参数项
/// Table：        	DHCAN.RecordPara,DHCAN.RecordParaItem
/// Input:			jsonString:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperApplication).SaveOperApplication("")
ClassMethod SaveRecordPara(jsonString As %String) As %String
{
	tstart	
	set sc=##class(CIS.AN.COM.String).ToArray(jsonString,.data)
	// 然后保存监护参数明细项
	set objIndex=0
	for
	{
		set objIndex=$order(data(objIndex))
		quit:(objIndex="")
		kill paraItem
		merge paraItem=data(objIndex)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.paraItem)
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

}
