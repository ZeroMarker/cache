/// 名称: DHCHAI.DP.UserHabit
/// 描述: 院感用户习惯表
/// 编写者: ShenC
/// 编写日期: 2022-07-01
Class DHCHAI.DP.UserHabit Extends (%Persistent, User.Abstract)
{

/// 用户ID
Property UserID As %String [ Required ];

/// 界面名称
Property TableName As %String [ Required ];

/// 列代码名称
Property IndexInfo As %String [ Required ];

/// 更新日期
Property UpdateDate As %String [ Required ];

/// 更新时间
Property UpdateTime As %String [ Required ];

Index Index On (UserID As Exact, TableName As Exact, UpdateDate As Exact, UpdateTime As Exact, IndexInfo As Exact);

/// Creator：     ShenC
/// CreatDate：   2022-07-01
/// Description:  保存用户习惯
/// Table：       DHCHAI.DP.UserHabit
/// Input：       
/// Return：      返回ID
/// w ##class(DHCHAI.DP.UserHabit).SaveData("1","User.CTCity","move^2^4")
ClassMethod SaveData(userid, tablename, index) As %String
{
	s result=""		
	s obj=##class(DHCHAI.DP.UserHabit).%New()	
	Ts	        		        	
	s obj.UserID = userid
	s obj.TableName = tablename
	s obj.IndexInfo =index
	s obj.UpdateDate=$p($h,",",1)
	s obj.UpdateTime=$p($h,",",2)
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "true"
	}
	else
	{
		Trollback
		s result = "false"
	}
		

	q result
}

/// Creator：     ShenC
/// CreatDate：   2022-07-01
/// Description:  展示用户习惯
/// Table：       DHCHAI.DP.UserHabit
/// Input：       
/// Return：      返回ID
/// Others:w ##class(DHCHAI.DP.UserHabit).ShowUserHabit(1,"User.BDPSpecialService")
ClassMethod ShowUserHabit(userid, table) As %String
{
	q:userid="" ""
	s infoStr=""
	s date=""
	k TMPBDPHIEEND
	s count=0
	for
	{
		s date=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date),-1) q:(date="")||(date=0)
		s time=""
		for
		{
			s time=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date,time),-1) q:(time="")||(time=0)
			s str=0
			for
			{
				s str=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date,time,str)) q:str=""
				s type=$p(str,"^",1)
				if type="hidden"
				{
					
					s prop=$p(str,"^",2)
					s propflag=$p(str,"^",3)
					if $d(TMPBDPHIEEND(prop))=0 s TMPBDPHIEEND(prop)=propflag
					
				}
				else
				{
					s count=count+1
					if (infoStr="")
					{
						s infoStr=str
					}
					else
					{
						s infoStr=str_","_infoStr
					}
				}
			}
		
		}
	}
	if $d(TMPBDPHIEEND)
	{
		s prop=0
		for
		{
			s prop=$o(TMPBDPHIEEND(prop)) q:prop=""
			if (infoStr="")
			{
				s infoStr="hidden"_"^"_prop_"^"_$g(TMPBDPHIEEND(prop))   //hidden false 为隐藏，true 为显示
			}
			else
			{
				s infoStr="hidden"_"^"_prop_"^"_$g(TMPBDPHIEEND(prop))_","_infoStr
			}
		}
		
	}
	q infoStr
}

/// Creator：     ShenC
/// CreatDate：   2022-07-01
/// Description:  清除某个界面的用户习惯
/// Table：       DHCHAI.DP.UserHabit
/// Input：       
/// Return：      返回ID
/// Others:w ##class(DHCHAI.DP.UserHabit).ClearUserHabit(1,"User.CTCity")
ClassMethod ClearUserHabit(userid, table) As %String
{
	s date="",id="",result=""
	TS
	for{
		s date=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date)) q:date=""
		s time=""
		for{
			s time=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date,time)) q:time=""
			s str=""
			for{
				s str=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date,time,str)) q:str=""
				s id=$o(^MA.HAI.DP.UserHabitI("Index",userid,table,date,time,str,0))
				s sc=##class(DHCHAI.DP.UserHabit).%DeleteId(id)
				if $$$ISOK(sc)
				{   
				  s result = result_"Y"
				}
				else
				{
				   s result = result_"N"
				}
			}
		
		}
	}
	if (result["N")
	{
		Trollback	
		s result = "{success:'false',errorinfo:'删除失败'}"
	}
	else
	{
		Tc
		s result = "{success:'true',errorinfo:'删除成功'}"
	}
	q result
}

Storage Default
{
<Data name="UserHabitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>IndexInfo</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.UserHabitD</DataLocation>
<DefaultData>UserHabitDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.UserHabitD</IdLocation>
<IndexLocation>^MA.HAI.DP.UserHabitI</IndexLocation>
<StreamLocation>^MA.HAI.DP.UserHabitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
