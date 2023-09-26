/// Creator:基础数据平台组-李得原
/// CreatDate:2019-10-08
/// Description：全局化诊断词表的引用表对应的方法
/// Table：User.MKBGlobalReference
Class web.DHCBL.MKB.MKBGlobalReference Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2019-10-08
/// Description：保存全局化词表对数据的引用
/// Input：flag:新增、修改  Datas:  1.被引用数据id (全局化词表) 2.发起引用的数据标识 3.发起引用的数据id
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBGlobalReference).SaveData("A",20414,"T",16384)
ClassMethod SaveData(flag As %String, Datas... As %String)
{
	if flag="A"    //新增引用
	{
		if ($d(Datas(3))=0)
		{
			q "error,入参不准确"
		}
		
		s InitaFlag=Datas(2)
		s InitaId=Datas(3)
		s PassiveId=Datas(1)
		
		
		if ((..FlagValid(InitaFlag)=0))
		{
			q "error,传入的标识错误"
		}
		
		if ((..IDValid(InitaFlag,InitaId)=0)||(..IDValid("",PassiveId)=0))
		{
			q "error,原ID无此数据"
		}
		
		s obj=##class(User.MKBGlobalReference).%New()
		s obj.InitiativeFlag=InitaFlag
		s obj.InitiativeID=InitaId
		s obj.PassiveID=PassiveId
		
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			s result="success,保存成功"
		}
		else
		{
			s result="error,保存失败"_$system.OBJ.DisplayError(sc)
		}
	}
	if flag="U"   //修改引用
	{
		if ($d(Datas(6))=0)
		{
			q "error,入参不准确"
		}
		s OldInitaFlag=Datas(2)
		s OldInitaId=Datas(3)
		s OldPassiveId=Datas(1)
		s NewInitaFlag=Datas(5)
		s NewInitaId=Datas(6)
		s NewPassiveId=Datas(4)
		
		if ((..FlagValid(OldInitaFlag)=0)||(..FlagValid(NewInitaFlag)=0))
		{
			q "error,传入的标识错误"
		}
		
		if ((..IDValid(OldInitaFlag,OldInitaId)=0)||(..IDValid("",OldPassiveId)=0)||(..IDValid(NewInitaFlag,NewInitaId)=0)||(..IDValid("",NewPassiveId)=0))
		{
			q "error,ID无此数据"
		}
		
		s MKBGRRowid=$o(^User.MKBGlobalReferenceI("AllIndex",OldInitaFlag,OldInitaId,OldPassiveId,0))
		
		if MKBGRRowid'=""
		{
			s obj=##class(User.MKBGlobalReference).%OpenId(MKBGRRowid)
			s obj.InitiativeFlag=NewInitaFlag
			s obj.InitiativeID=NewInitaId
			s obj.PassiveID=NewPassiveId
			s sc=obj.%Save()
			if $$$ISOK(sc)
			{
				s result="success,保存成功"
			}
			else
			{
				s result="error,保存失败"_$system.OBJ.DisplayError(sc)
			}
		}
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-10-08
/// Description：判断传入的标识是否正确
/// OutPut: 1 存在  0 不存在
ClassMethod FlagValid(flag As %String)
{
	s result=1
	if ((flag'="T" )&&(flag'="D")) 
	{
		s result=0
	}
	q result
}

/// 1 代表存在  0代表不存在
ClassMethod IDValid(flag As %String, id As %String)
{
	s result=1
	if ((flag="T")&&($d(^User.MKBTermD(id))=0))
	{
		s result=0
	}
	if ((flag="")&&($d(^User.MKBGlobalD(id))=0))
	{
		s result=0
	}
	q result
}

/// Creator：李得原
/// CreatDate: 2019-10-09
/// Description：获取被引用的列表
/// Input：MKBReferFlag 要删除数据的表 Flag 要删除数据的ID
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBReference","GetReferedList","T","14626")
Query GetReferedList(Id) As %Query(ROWSPEC = "InitiativeFlag,InitiativeID,RederedStr")
{
}

ClassMethod GetReferedListExecute(ByRef qHandle As %Binary, Flag, Id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

	if (Id="")
	{
		q ""
	}
	if ($D(^User.MKBGlobalReferenceI("InverAllIndex",Id))'=0)
	{
		s InitiativeFlag=""
		for
		{
			s InitiativeFlag = $O(^User.MKBGlobalReferenceI("InverAllIndex",Id,InitiativeFlag))	
			q:InitiativeFlag=""
			
			s InitiativeID=0
			for
			{
				s InitiativeID=$o(^User.MKBGlobalReferenceI("InverAllIndex",Id,InitiativeFlag,InitiativeID))		
				q:InitiativeID=""
				
				s RederedStr = "被"_..GetResult(InitiativeFlag,InitiativeID)_"所引用"
				d OutputReferdRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReferdRow
    set Data=$lb(InitiativeFlag,InitiativeID,RederedStr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetReferedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReferedListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetReferedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReferedListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetResult(flag, id)
{
	s result=""
	
	if flag="T"
	{
		s TermDesc=$lg($g(^User.MKBTermD(id)),3)
		s Base=$lg($g(^User.MKBTermD(id)),4)
		s BaseDesc=$lg($g(^User.MKBTermBaseD(Base)),3)
		s result = BaseDesc_" 的 "_TermDesc
	}
	
	if flag="D"
	{
		s DetDesc = $LG($G(^User.MKBTermProDetailD(id)),3)
		s ProDR = $LG($G(^User.MKBTermProDetailD(id)),6)
		s ProType = $LG($G(^User.MKBTermPropertyD(ProDR)),4)
		s ProDesc = $LG($G(^User.MKBTermPropertyD(ProDR)),3)
		s TermDR = $LG($G(^User.MKBTermPropertyD(ProDR)),6)
		s TermDesc = $LG($G(^User.MKBTermD(TermDR)),3)
		s BaseDR = $LG($G(^User.MKBTermD(TermDR)),4)
		s BaseDesc = $LG($G(^User.MKBTermBaseD(BaseDR)),3)
		s result = BaseDesc_" 的 "_TermDesc_" 的 "_ProDesc
	}
	

	q result
}

}
