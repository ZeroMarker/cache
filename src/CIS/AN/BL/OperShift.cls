Class CIS.AN.BL.OperShift Extends %RegisteredObject
{

ClassMethod SaveShift(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		kill shift
		m shift=array(objIndex)
		set shiftDateTime=$g(shift("ShiftDateTime"))
		set shiftDate=$p(shiftDateTime," ",1)
		set shiftTime=$p(shiftDateTime," ",2)
		if shiftDateTime'=""
		{
			set shift("ShiftDate")=##class(CIS.AN.COM.DateTime).ConvertToDateH(shiftDate)
			set shift("ShiftTime")=##class(CIS.AN.COM.DateTime).ConvertToTimeH(shiftTime)
		}
		set shift("UpdateUser")=userId
		set shift("UpdateDate")=+$h
		set shift("UpdateTime")=$p($h,",",2)
		set shift("ClassName")="CIS.AN.OperShift"
		
		if $g(shift("isRemoved"))="Y" set saveResult=##class(CIS.AN.COM.DataService).DelData(shift("ClassName"),shift("RowId"))
		else  set saveResult=##class(CIS.AN.COM.DataService).SaveData(.shift)
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

/// Creator：      	雍阳
/// CreatDate：    	2020-6-18
/// Description： 	组合交接班人员
/// Table：        	CIS.AN.OperShift
/// Input:			opsId:手术ID，shiftType:交接班类型，careprovListStr:已有人员字符串
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.Shift).CompleteCareProv("7","A","侯代亮,王湘东")
ClassMethod CompleteCareProv(opsId, shiftType, careprovListStr) As %String
{
	set ret=""
	set careprovList=$listFromString(careprovListStr,",")
	kill careprovDic,careprovDicList
	for i=1:1:$ll(careprovList)
	{
		set careprovDic("i_"_i)=$lg(careprovList,i)
		set:careprovDic("i_"_i)'="" careprovDicList(careprovDic("i_"_i))="i_"_i
	}

	set query=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindOperShift")
	set sc=query.Execute(opsId,"",shiftType)
	while(query.%Next()){
		set RowId=query.Get("RowId")
		set HandOverUser=query.Get("ShiftCareProvID")
		set HandOverUserName=query.Get("ShiftCareProvDesc")
		set TakeOverUser=query.Get("ReliefCareProvID")
		set TakeOverUserName=query.Get("ReliefCareProvDesc")
		
		if $d(careprovDicList(HandOverUserName))
		{
			continue:TakeOverUserName=""
			if '$d(careprovDicList(TakeOverUserName))
			{
				set index=careprovDicList(HandOverUserName)
				set index=index_"1"
				set careprovDic(index)=TakeOverUserName
				set careprovDicList(TakeOverUserName)=index
			}
		}
		else
		{
			if $d(careprovDicList(TakeOverUserName))
			{
				set index=careprovDicList(TakeOverUserName)
				set index=$o(careprovDic(index),-1)
				set index=index_"1"
				set careprovDic(index)=HandOverUserName
				set careprovDicList(HandOverUserName)=index
			}
			else
			{
				set index=$o(careprovDic(""),-1)
				set index=index_"1"
				set careprovDic(index)=HandOverUserName
				set careprovDicList(HandOverUserName)=index
				set index=index_"1"
				set careprovDic(index)=TakeOverUserName
				set careprovDicList(TakeOverUserName)=index
			}
		}
	}
	
	set index="",newCareProvList=""
	for
	{
		set index=$o(careprovDic(index))
		quit:index=""
		
		set newCareProvList=newCareProvList_$lb(careprovDic(index))
	}
	
	set result=$ListToString(newCareProvList,",")
	
	quit result
}

}
