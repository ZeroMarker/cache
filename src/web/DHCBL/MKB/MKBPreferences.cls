/// 基础数据平台-谢海睿
/// 医生站-知识库授权界面
/// 2019-10-12
Class web.DHCBL.MKB.MKBPreferences Extends %RegisteredObject
{

/// creator: 谢海睿 
/// Description：保存是否允许开例诊断页面的数据
/// Table：MKB_Preferences
/// w ##class(User.MKBPreferences).%OpenId(1)
/// w $o(^User.MKBPreferencesI("SearchIndex"," G"," TEST",0))
/// w $d(^User.MKBPreferencesI("SearchIndex"," G"," TEST"))
/// w ##class(web.DHCBL.MKB.MKBDoctorpermission).SaveEntity("G","test","test","N")
ClassMethod SaveEntity(ObjectType As %String, ObjectReference As %String, ValueType As %String, MKBValue As %String) As %String
{
	s temp=$ZCONVERT(ObjectType,"U")   //转换成大写
	s temp1=$ZCONVERT(ObjectReference,"U") //转换成大写
	s temp2=$ZCONVERT(ValueType,"U") //转换成大写
	s temp=" "_temp
	s temp1=" "_temp1
	s temp2=" "_temp2
	if ($d(^User.MKBPreferencesI("SearchIndex",temp,temp1,temp2)))
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex",temp,temp1,temp2,0))
		s obj=##class(User.MKBPreferences).%OpenId(MKBRowId)	
	}
	else
	{
		s obj= ##class(User.MKBPreferences).%New()
	}
	s obj.ObjectReference=ObjectReference
	s obj.ObjectType=ObjectType
	s obj.ValueType=ValueType
	s obj.MKBValue=MKBValue
	s sc = obj.%Save()
	i $$$ISERR(sc) q $System.Status.GetErrorText(sc)
	Quit $$$OK
}

/// Creator：谢海睿
/// CreatDate: 2019-10-15
/// Description:医生站权限控制
/// Table：User.MKBPreferences
/// 被授权名称：diagnose（开例诊断），knowledge（知识点），Baike（医为百科）,OpenSurgery(开立手术)
/// Input：ObjectType（组别），ObjectReference（组内ID），ValueType（被权限名称）
/// Return:返回MKBValue，
/// w ##class(web.DHCBL.MKB.MKBDoctorpermission).OpenData("G","test","OpenSurgery")
ClassMethod OpenData(ObjectType As %String, ObjectReference As %String, ValueType As %String) As %String
{
	s ObjectType=$ZCONVERT(ObjectType,"U") //转换大写
	s ObjectReference=$ZCONVERT(ObjectReference,"U") //转换大写
	s ObjectType=" "_ObjectType
	s ObjectReference=" "_ObjectReference
	s MKBValue="N"
	if (ValueType="Baike")
	{
		s MKBValue="Y"
	}
	s ValueType=$ZCONVERT(ValueType,"U") //转换大写
	s ValueType=" "_ValueType
	if ($d(^User.MKBPreferencesI("SearchIndex",ObjectType,ObjectReference,ValueType)))
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex",ObjectType,ObjectReference,ValueType,0))
		s:MKBRowId'="" MKBValue=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
	}
	q MKBValue
}

/// Creator：谢海睿
/// CreatDate: 2019-10-15
/// Description:医生站权限控制对外接口
/// Table：User.MKBPreferences
/// 被授权名称：diagnose（开立诊断），knowledge（知识点），Baike（医为百科）,OpenSurgery(开立手术)
/// Input：sessionID
/// Return:返回MKBValue(Y^Y^Y^Y)，返回值的顺序分别是（医为百科^知识点^开立诊断^开立手术)
/// w ##class(web.DHCBL.MKB.MKBPreferences).GetValueDataTwo()
ClassMethod GetValueDataTwo() As %String
{
	s myUserID=$g(%session.Data("LOGON.USERID")) //用户
	s myLocID=$g(%session.Data("LOGON.CTLOCID")) //科室
	s myGroupID=$g(%session.Data("LOGON.GROUPID")) //安全组
	s myUserID=" "_myUserID
	s myLocID=" "_myLocID
	s myGroupID=" "_myGroupID
	//判断医为百科权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," BAIKE",0))
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," BAIKE",0))
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," BAIKE",0))
	}
	if (MKBRowId'="")
	{
		s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
	}	
	else
	{
		s BAIKE="N"
	}
	//判断开立诊断的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," DIAGNOSE",0))
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," DIAGNOSE",0))
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," DIAGNOSE",0))
	}
	if (MKBRowId'="")
	{
		s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
		if (DIAGNOSE="N"){
			
		}
	}	
	else
	{
		s DIAGNOSE="N"
	}
	//判断知识点的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," KNOWLEDGE",0))
	
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," KNOWLEDGE",0))
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," KNOWLEDGE",0))
	}
	if (MKBRowId'="")
	{
		s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
	}	
	else
	{
		s KNOWLEDGE="N"
	}
	//判断开立手术的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," OPENSURGERY",0))
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," OPENSURGERY",0))
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," OPENSURGERY",0))
	}
	if (MKBRowId'="")
	{
		s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
	}	
	else
	{
		s OPENSURGERY="N"
	}
	S MKBValue=BAIKE_"^"_KNOWLEDGE_"^"_DIAGNOSE_"^"_OPENSURGERY
	q MKBValue
}

/// Creator：谢海睿
/// CreatDate: 2019-10-15
/// Description:医生站权限控制对外接口
/// Table：User.MKBPreferences
/// 被授权名称：diagnose（开立诊断），knowledge（知识点），Baike（医为百科）,OpenSurgery(开立手术)
/// Input：sessionID
/// Return:返回MKBValue(Y^Y^Y^Y)，返回值的顺序分别是（医为百科^知识点^开立诊断^开立手术)
/// w ##class(web.DHCBL.MKB.MKBPreferences).GetValueData()
ClassMethod GetValueData() As %String
{
	s myUserID=$g(%session.Data("LOGON.USERID")) //用户
	s myLocID=$g(%session.Data("LOGON.CTLOCID")) //科室
	s myGroupID=$g(%session.Data("LOGON.GROUPID")) //安全组
	s myUserID=" "_myUserID
	s myLocID=" "_myLocID
	s myGroupID=" "_myGroupID
	//判断医为百科权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," BAIKE",0))
	if (MKBRowId'="")
	{
		s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
		if (BAIKE="N")
		{
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," BAIKE",0))
			if (MKBRowId'="")
			{
				s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				if (BAIKE="N")
				{
					s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," BAIKE",0))
					if (MKBRowId'="")
					{
						s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
					}
					else
					{
						s BAIKE="Y"
					}
					
				}
			}
			else
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," BAIKE",0))
				if (MKBRowId'="")
				{
					s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s BAIKE="Y"
				}
			}
		}
		
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myGroupID," BAIKE",0))
		if (MKBRowId'="")
		{
			s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			if (BAIKE="N")
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," BAIKE",0))
				if (MKBRowId'="")
				{
					s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s BAIKE="Y"
				}
				
			}
		}
		if (MKBRowId="")
		{
			
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," BAIKE",0))
			if (MKBRowId'="")
			{
				s BAIKE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			}
			else
			{
				s BAIKE="Y"
			}
				
			
		}
	}
	//判断开立诊断的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," DIAGNOSE",0))
	if (MKBRowId'="")
	{
		s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
		if (DIAGNOSE="N")
		{
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," DIAGNOSE",0))
			if (MKBRowId'="")
			{
				s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				if (DIAGNOSE="N")
				{
					s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," DIAGNOSE",0))
					if (MKBRowId'="")
					{
						s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
					}
					else
					{
						s DIAGNOSE="N"
					}
					
				}
			}
			else
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," DIAGNOSE",0))
				if (MKBRowId'="")
				{
					s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s DIAGNOSE="N"
				}
			}
		}
		
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myGroupID," DIAGNOSE",0))
		if (MKBRowId'="")
		{
			s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			if (DIAGNOSE="N")
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," DIAGNOSE",0))
				if (MKBRowId'="")
				{
					s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s DIAGNOSE="N"
				}
				
			}
		}
		if (MKBRowId="")
		{
			
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," DIAGNOSE",0))
			if (MKBRowId'="")
			{
				s DIAGNOSE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			}
			else
			{
				s DIAGNOSE="N"
			}
				
			
		}
	}
	
	//判断知识点的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," KNOWLEDGE",0))
	if (MKBRowId'="")
	{
		s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
		if (KNOWLEDGE="N")
		{
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," KNOWLEDGE",0))
			if (MKBRowId'="")
			{
				s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				if (KNOWLEDGE="N")
				{
					s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," KNOWLEDGE",0))
					if (MKBRowId'="")
					{
						s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
					}
					else
					{
						s KNOWLEDGE="N"
					}
					
				}
			}
			else
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," KNOWLEDGE",0))
				if (MKBRowId'="")
				{
					s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s KNOWLEDGE="N"
				}
			}
		}
		
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myGroupID," KNOWLEDGE",0))
		if (MKBRowId'="")
		{
			s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			if (KNOWLEDGE="N")
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," KNOWLEDGE",0))
				if (MKBRowId'="")
				{
					s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s KNOWLEDGE="N"
				}
				
			}
		}
		if (MKBRowId="")
		{
			
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," KNOWLEDGE",0))
			if (MKBRowId'="")
			{
				s KNOWLEDGE=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			}
			else
			{
				s KNOWLEDGE="N"
			}
				
			
		}
	}
	
	//判断开立手术的权限
	s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," U",myUserID," OPENSURGERY",0))
	
	if (MKBRowId'="")
	{
		s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
		if (OPENSURGERY="N")
		{
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myLocID," OPENSURGERY",0))
			if (MKBRowId'="")
			{
				s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				if (OPENSURGERY="N")
				{
					s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," OPENSURGERY",0))
					if (MKBRowId'="")
					{
						s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
					}
					else
					{
						s OPENSURGERY="N"
					}
					
				}
			}
			else
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," OPENSURGERY",0))
				if (MKBRowId'="")
				{
					s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s OPENSURGERY="N"
				}
			}
		}
		
	}
	if (MKBRowId="")
	{
		s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," L",myGroupID," OPENSURGERY",0))
		if (MKBRowId'="")
		{
			s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			if (OPENSURGERY="N")
			{
				s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," OPENSURGERY",0))
				if (MKBRowId'="")
				{
					s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
				}
				else
				{
					s OPENSURGERY="N"
				}
				
			}
		}
		if (MKBRowId="")
		{
			
			s MKBRowId=$o(^User.MKBPreferencesI("SearchIndex"," G",myGroupID," OPENSURGERY",0))
			if (MKBRowId'="")
			{
				s OPENSURGERY=$LISTGET($G(^User.MKBPreferencesD(MKBRowId)),5)
			}
			else
			{
				s OPENSURGERY="N"
			}
				
			
		}
	}
	S MKBValue=BAIKE_"^"_KNOWLEDGE_"^"_DIAGNOSE_"^"_OPENSURGERY
	q MKBValue
}

}
