/// 类名: DtPortal.ND.ND04.ND0402NurseType
/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询护理部人力资源护士工作年限数据
Class DtPortal.ND.ND04.ND0403NurseWorkYear Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询全院各病区当前护士工作年限分布
/// Return： 
/// 服务编码：ND04.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND04.ND0403NurseWorkYear","ND040301")
Query ND040301() As DtPortal.Query(ROWSPEC = "wardLocID,WardDesc,total,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,valueNull")
{
}

ClassMethod ND040301Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
		
	d ##class(DtPortal.ND.ND04.ND0400Common).GetNurseData()
	
	k ^||TMPPortalND040301
	set typeCode="NurseWorkYear"
	k ^||TMPPortalND040301	
	
	set Datatype=""						//有数据的类型
	
	set subCodeID=""
	for
	{
		set subCodeID=$o(^||TMPPortalND0400Common(typeCode,subCodeID))
		quit:subCodeID=""
		
		set subDesc=$g(^||TMPPortalND0400Common(typeCode,subCodeID))
		
		set:Datatype'="" Datatype=Datatype_"^"_subCodeID
		set:Datatype="" Datatype=subCodeID
		set num=0
		set WardID=""
		for
		{
			set WardID=$o(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
			quit:WardID=""
			
			set locNum=$g(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
			set ^||TMPPortalND040301(WardID,subCodeID)=locNum
		}
	}
	
	set WardID=""
	for
	{
		set WardID=$o(^||TMPPortalND040301(WardID))
		quit:WardID=""
		
		set total=0,value1=0,value2=0,value3=0,value4=0,value5=0,value6=0,value7=0,value8=0,value9=0,value10=0,value11=0,value12=0,value13=0,value14=0,value15=0,valueNull=0

		for subIndex=1:1:$l(Datatype,"^")
		{
			set subCodeID=$p(Datatype,"^",subIndex)
			
			set num=0
			set num=+$g(^||TMPPortalND040301(WardID,subCodeID))
			set:subCodeID=100 valueNull=num
			set total=total+num
			continue:subCodeID=100
			set:subIndex=1 value1=num
			set:subIndex=2 value2=num
			set:subIndex=3 value3=num
			set:subIndex=4 value4=num
			set:subIndex=5 value5=num
			set:subIndex=6 value6=num
			set:subIndex=7 value7=num
			set:subIndex=8 value8=num
			set:subIndex=9 value9=num
			set:subIndex=10 value10=num
			set:subIndex=11 value11=num
			set:subIndex=12 value12=num
			set:subIndex=13 value13=num
			set:subIndex=14 value14=num
			set:subIndex=15 value15=num
			
		}
		set WardDesc=$p(^PAWARD(WardID),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		
		set Data=$lb(WardID,WardDesc,total,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,valueNull)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
	k ^||TMPPortalND040301
	k ^||TMPPortalND0400Common
  	q $$$OK
}

}
