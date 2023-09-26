/// 类名: DtPortal.ND.ND04.ND0405Education
/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询护理部人力资源护士学历数据
Class DtPortal.ND.ND04.ND0405Education Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-14
/// Description: 查询全院各病区当前护士学历分布
/// Return： 
/// 服务编码：ND04.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND04.ND0405Education","ND040501")
Query ND040501() As DtPortal.Query(ROWSPEC = "WardID,WardDesc,total1,total2,valueNull1,valueNull2,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30")
{
}

ClassMethod ND040501Execute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
		
	d ##class(DtPortal.ND.ND04.ND0400Common).GetNurseData()
	
	set typeCodeStr="NurseEducationFirst^NurseEducationFinal"
	k ^||TMPPortalND040501	
	
	set Datatype=""						//有数据的类型
	
	for index=1:1:2
	{
		set typeCode=$p(typeCodeStr,"^",index)
		set subCodeID=""
		for
		{
			set subCodeID=$o(^||TMPPortalND0400Common(typeCode,subCodeID))
			quit:subCodeID=""
			
			set subDesc=$g(^||TMPPortalND0400Common(typeCode,subCodeID))
			
			set aDatatype="^"_Datatype_"^",asubCodeID="^"_subCodeID_"^"
			if aDatatype'[asubCodeID
			{
				set:Datatype'="" Datatype=Datatype_"^"_subCodeID
				set:Datatype="" Datatype=subCodeID
			}
		
			set num=0
			set WardID=""
			for
			{
				set WardID=$o(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
				quit:WardID=""
				
				set locNum=$g(^||TMPPortalND0400Common(typeCode,subCodeID,WardID))
				set ^||TMPPortalND040501(WardID,typeCode,subCodeID)=locNum
			}
		}
	}
	
	
	set WardID=""
	for
	{
		set WardID=$o(^||TMPPortalND040501(WardID))
		quit:WardID=""
		
		set total1=0,total2=0,value1=0,value2=0,value3=0,value4=0,value5=0,value6=0,value7=0,value8=0,value9=0,value10=0,value11=0,value12=0,value13=0,value14=0,value15=0,value16=0,value17=0,value18=0,value19=0,value20=0,value21=0,value22=0,value23=0,value24=0,value25=0,value26=0,value27=0,value28=0,value29=0,value30=0,valueNull1=0,valueNull2=0
		
		//初始学历
		for subIndex=1:1:$l(Datatype,"^")
		{
			set subCodeID=$p(Datatype,"^",subIndex)
			
			set num=0
			set num=+$g(^||TMPPortalND040501(WardID,"NurseEducationFirst",subCodeID))
			set total1=total1+num
			set:subCodeID=100 valueNull1=num
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
		
		
		//最终学历
		for subIndex=1:1:$l(Datatype,"^")
		{
			set subCodeID=$p(Datatype,"^",subIndex)
			
			set num=0
			set num=+$g(^||TMPPortalND040501(WardID,"NurseEducationFinal",subCodeID))
			set total2=total2+num
			set:subCodeID=100 valueNull2=num
			continue:subCodeID=100
			
			set:subIndex=1 value16=num
			set:subIndex=2 value17=num
			set:subIndex=3 value18=num
			set:subIndex=4 value19=num
			set:subIndex=5 value20=num
			set:subIndex=6 value21=num
			set:subIndex=7 value22=num
			set:subIndex=8 value23=num
			set:subIndex=9 value24=num
			set:subIndex=10 value25=num
			set:subIndex=11 value26=num
			set:subIndex=12 value27=num
			set:subIndex=13 value28=num
			set:subIndex=14 value29=num
			set:subIndex=15 value30=num
		}
		
		set WardDesc=$p(^PAWARD(WardID),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		
		set Data=$lb(WardID,WardDesc,total1,total2,valueNull1,valueNull2,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}
	
	k ^||TMPPortalND040501
	k ^||TMPPortalND0400Common
  	q $$$OK
}

}
