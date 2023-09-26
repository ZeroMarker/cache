/// Creator：陈莹 基础数据平台
/// CreatDate: 2015-9-21
/// Description：保存用户习惯
/// Table：User.BDPUserHabit
Class web.DHCBL.BDP.BDPUserHabit Extends %RegisteredObject
{

/// 保存用户习惯
/// w ##class(web.DHCBL.BDP.BDPUserHabit).SaveData("1","User.CTCity","move^2^4")
ClassMethod SaveData(userid, tablename, index) As %String
{
	s result=""		
	s obj=##class(User.BDPUserHabit).%New()	
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

/// Creator：谷雪萍  基础数据平台
/// CreatDate: 2015-9-22
/// Function:展示用户习惯
/// Others:w ##class(web.DHCBL.BDP.BDPUserHabit).ShowUserHabit(1,"User.CTCity")
ClassMethod ShowUserHabit(userid, table) As %String
{
	q:userid="" ""
	s infoStr=""
	s date=""
	s count=0
	for
	{
		s date=$o(^User.BDPUserHabitI("Index",userid,table,date)) q:date=""
		s time=""
		for
		{
			s time=$o(^User.BDPUserHabitI("Index",userid,table,date,time)) q:time=""
			s str=""
			for
			{
				s str=$o(^User.BDPUserHabitI("Index",userid,table,date,time,str)) q:str=""
				
				s type=$p(str,"^",1)
				if type="hidden"
				{
					s prop=$p(str,"^",2)
					s propflag=$p(str,"^",3)
					s TMPBDPHIEEND(prop)=propflag
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

/// Creator：谷雪萍 基础数据平台
/// CreatDate: 2016-3-1
/// Function:清除某个界面的用户习惯
/// Others:w ##class(web.DHCBL.BDP.BDPUserHabit).ClearUserHabit(1,"User.CTCity")
ClassMethod ClearUserHabit(userid, table) As %String
{
	s date="",id="",result=""
	TS
	for{
		s date=$o(^User.BDPUserHabitI("Index",userid,table,date)) q:date=""
		s time=""
		for{
			s time=$o(^User.BDPUserHabitI("Index",userid,table,date,time)) q:time=""
			s str=""
			for{
				s str=$o(^User.BDPUserHabitI("Index",userid,table,date,time,str)) q:str=""
				s id=$o(^User.BDPUserHabitI("Index",userid,table,date,time,str,0))
				s sc=##class(User.BDPUserHabit).%DeleteId(id)
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

}
