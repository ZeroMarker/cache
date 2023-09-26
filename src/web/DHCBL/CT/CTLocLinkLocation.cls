Import SQLUser

Class web.DHCBL.CT.CTLocLinkLocation Extends %RegisteredObject
{

/// Creator：蔡昊哲
/// CreatDate: 2013-5-31
/// Description：获取关联科室列表
/// Table：User.CTLocLinkLocation
/// Input：rowid(CTLOCRowID),linkrowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocLinkLocation","GetList","2","")
Query GetList(rowid As %String, linkrowid As %String) As %Query(ROWSPEC = "LINKRowId,LINKParRef,LINKCTLOCDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, linkrowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (linkrowid'="")
	{
		s LINKRowId=linkrowid
		s CTLOCRowID=$p(LINKRowId,"||",1)
		s LINKChildsub=$p(LINKRowId,"||",2)
		s LINKParRef=CTLOCRowID
		s LINKCTLOCDR=$p($g(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)),"^",1)
		s:LINKCTLOCDR'="" LINKCTLOCDR=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)       //科室名
		d OutputRow
	}
	else
	{
		if rowid'=""
		{
			s CTLOCRowID=rowid,LINKChildsub=0
			for
			{
				s LINKChildsub=$o(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)) q:LINKChildsub=""
				s LINKRowId=CTLOCRowID_"||"_LINKChildsub
				s LINKParRef=rowid
				s LINKCTLOCDR=$p($g(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)),"^",1)
				s:LINKCTLOCDR'="" LINKCTLOCDR=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)       //科室名
				i (LINKChildsub>0)
				{
					d OutputRow
				}
			}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LINKRowId,LINKParRef,LINKCTLOCDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2013-8-2    
/// w ##class(web.DHCBL.CT.CTLocLinkLocation).Validate("2||1","2","2")
ClassMethod Validate(id As %String, LINKParRef As %String, LINKCTLOCDR As %String) As %String
{


	s flag=0
	s flagd=""
	
	s flagd=$d(^CTLOC(LINKParRef,"LINK",0,"Loc",LINKCTLOCDR))
	if (flagd=0)
	{
		s flag=0 //返回不重复标志
	}
	else{
		if (id="") //增加
		{
			s flag=1  //返回重复标志
		}
		else //修改
		{
			s idd="", LINKCTLOCDR1=""
			s LINKChildsub=0
			for
			{
				s LINKChildsub=$o(^CTLOC(LINKParRef,"LINK",LINKChildsub)) q:LINKChildsub=""
				s idd=LINKParRef_"||"_LINKChildsub
				s LINKCTLOCDR1=$p($g(^CTLOC(LINKParRef,"LINK",LINKChildsub)),"^",1)
				if (idd'=id)&(LINKCTLOCDR1=LINKCTLOCDR)
				{
					s flag=1  //返回重复标志	
				}
			}
		}
	}
	q flag
}

/// Creator:蔡昊哲
/// CreatDate:2013-05-31
/// Description:保存关联科室
/// Table:User.CTLocLinkLocation
/// Input:web.Entity.CT.CTLocLinkLocation
/// Return:成功返回true和id,失败返回false和errorinfo
/// Other: d ##class(web.DHCBL.CT.CTLocLinkLocation).SaveEntity("3||2","3","557")
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocLinkLocation) As %String
{
	;s $zt="ERROE"
	s result=""
	s flag=..Validate(eobj.LINKRowId,eobj.LINKParRef,eobj.LINKCTLOCDR)  //调用重复验证20130603LISEN
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		Ts
		if (eobj.LINKRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.CTLocLinkLocation).%New(eobj.LINKParRef)
			d obj.LINKParRefSetObjectId(eobj.LINKParRef)

		}
		else                     //如果RowId已赋值则修改
		{
			s obj=##class(User.CTLocLinkLocation).%OpenId(eobj.LINKRowId)
			s bobj=##class(web.Entity.CT.CTLocLinkLocation).%New(eobj.LINKParRef)
			s bobj.LINKRowId=eobj.LINKRowId
			s bobj.LINKCTLOCDR=obj.LINKCTLOCDR.%Id()
			s bobj.LINKParRef=obj.LINKParRef.%Id()

		}

		
		
		d:eobj.LINKCTLOCDR'="" obj.LINKCTLOCDRSetObjectId(eobj.LINKCTLOCDR)
		
		s CTLOCDesc1=$p($g(^CTLOC(eobj.LINKParRef)),"^",2)	
		s CTLOCDesc2=$p($g(^CTLOC(eobj.LINKCTLOCDR)),"^",2)	
		
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"         //返回RowId
			d:eobj.LINKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkLocation","User.CTLocLinkLocation","关联科室",id,CTLOCDesc1_"->"_CTLOCDesc2,"U",eobj,bobj)
			d:eobj.LINKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkLocation","User.CTLocLinkLocation","关联科室",id,CTLOCDesc1_"->"_CTLOCDesc2,"A",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("关联科室","web.DHCBL.CT.CTLocLinkLocation","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
		}
	}
	q result
	;ERROE
	;q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2014-2-24
/// Other:d ##class(web.DHCBL.CT.CTLocLinkLocation).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTLocLinkLocation).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocLinkLocation).%New()
	s eobj.LINKRowId = id
	s eobj.LINKParRef =$p(id,"||",1)
	
	if $IsObject(pobj.LINKCTLOCDR){
		s eobj.LINKCTLOCDR = pobj.LINKCTLOCDR.%Id() 
	}
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.CTLocLinkLocation).%New()
	s pobj = ##class(User.CTLocLinkLocation).%OpenId(id)
	s ChildSub=$p($g(id),"||",2) ///判断为第几个孩子
	s ParRef=$p($g(id),"||",1)  
	s LINKCTLOCDR=$p($g(^CTLOC(ParRef,"LINK",ChildSub)),"^",1)
	S eobj.LINKRowId = id
	s eobj.LINKParRef = ParRef
	s eobj.LINKCTLOCDR = LINKCTLOCDR
	s eobj.LINKChildsub = ChildSub


	s:eobj.LINKParRef'="" CTLOCDesc1=$p($g(^CTLOC(eobj.LINKParRef)),"^",2)       //科室名
	s:eobj.LINKCTLOCDR'="" CTLOCDesc2=$p($g(^CTLOC(eobj.LINKCTLOCDR)),"^",2)       //科室名

	s sc = ##class(User.CTLocLinkLocation).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkLocation","User.CTLocLinkLocation","关联科室",id,CTLOCDesc1_"->"_CTLOCDesc2,"D",eobj)
	}
	else 
	{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("关联科室","web.DHCBL.CT.CTLocLinkLocation","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

}
