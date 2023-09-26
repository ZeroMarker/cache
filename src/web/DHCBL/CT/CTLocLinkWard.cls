Import SQLUser

Class web.DHCBL.CT.CTLocLinkWard Extends %RegisteredObject
{

/// Creator：杨本庆
/// CreatDate: 2018-6-19
/// Description：获取关联病区列表
/// Table：User.CTLocLinkWard
/// Input：rowid(CTLOCRowID),linkrowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocLinkWard","GetList","2","")
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
		s:LINKCTLOCDR'="" LINKCTLOCDR=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)       //病区名
		d OutputRow
	}
	else
	{
		s CTLOCRowID=rowid,LINKChildsub=0
		for
		{
			s LINKChildsub=$o(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)) q:LINKChildsub=""
			s LINKRowId=CTLOCRowID_"||"_LINKChildsub
			s LINKParRef=rowid
			s LINKCTLOCDR=$p($g(^CTLOC(CTLOCRowID,"LINK",LINKChildsub)),"^",1)
			s:LINKCTLOCDR'="" LINKCTLOCDR=$p($g(^CTLOC(LINKCTLOCDR)),"^",2)       //病区名
			i (LINKChildsub>0)
			{
				d OutputRow
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
/// Creator:基础数据平台组 杨本庆
/// CreateDate:2018-6-19
/// w ##class(web.DHCBL.CT.CTLocLinkWard).Validate("2||1","2","2")
ClassMethod Validate(id As %String, LINKParRef As %String, LINKCTLOCDR As %String) As %String
{


	s flag=0
	s flagd=""
	
	s flagd=$d(^CTLOC(LINKParRef,"LINKWARD",0,"Ward",LINKCTLOCDR))
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
				s LINKChildsub=$o(^CTLOC(LINKParRef,"LINKWARD",LINKChildsub)) q:LINKChildsub=""
				s idd=LINKParRef_"||"_LINKChildsub
				s LINKCTLOCDR1=$p($g(^CTLOC(LINKParRef,"LINKWARD",LINKChildsub)),"^",1)
				if (idd'=id)&(LINKCTLOCDR1=LINKCTLOCDR)
				{
					s flag=1  //返回重复标志	
				}
			}
		}
	}
	q flag
}

/// Creator:杨本庆
/// CreatDate:2018-6-19
/// Description:保存关联病区
/// Table:User.CTLocLinkWard
/// Input:web.Entity.CT.CTLocLinkWard
/// Return:成功返回true和id,失败返回false和errorinfo
/// Other: d ##class(web.DHCBL.CT.CTLocLinkWard).SaveEntity("3||2","3","557")
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocLinkWard) As %String
{
	;s $zt="ERROE"
	s result=""
	s WARDDesc=$p($g(^PAWARD(eobj.LINKPACWardDR)),"^",2)
	s LINKCTLOCDR=$p($g(^PAWARD(eobj.LINKPACWardDR)),"^",5)
	//判断是否在关联科室存在
	s flag=##class(web.DHCBL.CT.CTLocLinkLocation).Validate(eobj.LINKRowId,eobj.LINKWardParRef,LINKCTLOCDR)  //调用重复验证20130603LISEN
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'"_WARDDesc_"已经在关联科室存在！'}"
	}
	else
	{
		Ts
		if (eobj.LINKRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.CTLocLinkWard).%New(eobj.LINKWardParRef)
			d obj.LINKWardParRefSetObjectId(eobj.LINKWardParRef)

		}
		else                     //如果RowId已赋值则修改
		{
			s obj=##class(User.CTLocLinkWard).%OpenId(eobj.LINKRowId)
			s bobj=##class(web.Entity.CT.CTLocLinkWard).%New(eobj.LINKWardParRef)
			s bobj.LINKRowId=eobj.LINKRowId
			s bobj.LINKPACWardDR=obj.LINKPACWardDR
			s bobj.LINKWardParRef=obj.LINKWardParRef

		}

		
		
		d:eobj.LINKPACWardDR'="" obj.LINKPACWardDRSetObjectId(eobj.LINKPACWardDR)
		
		s CTLOCDesc1=$p($g(^CTLOC(eobj.LINKWardParRef)),"^",2)	
		s CTLOCDesc2=$p($g(^CTLOC(eobj.LINKPACWardDR)),"^",2)	
		
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"         //返回RowId
			d:eobj.LINKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkWard","User.CTLocLinkWard","关联病区",id,CTLOCDesc1_"->"_CTLOCDesc2,"U",eobj,bobj)
			d:eobj.LINKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkWard","User.CTLocLinkWard","关联病区",id,CTLOCDesc1_"->"_CTLOCDesc2,"A",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("关联病区","web.DHCBL.CT.CTLocLinkWard","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
		}
	}
	q result
	;ERROE
	;q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.CTLocLinkWard).%New()
	s pobj = ##class(User.CTLocLinkWard).%OpenId(id)
	s ChildSub=$p($g(id),"||",2) ///判断为第几个子
	s ParRef=$p($g(id),"||",1)  
	s LINKPACWardDR=$p($g(^CTLOC(ParRef,"LINKWARD",ChildSub)),"^",1)
	S eobj.LINKRowId = id
	s eobj.LINKWardParRef = LINKWardParRef
	s eobj.LINKPACWardDR = LINKPACWardDR
	s eobj.LINKChildsub = ChildSub


	s:eobj.LINKWardParRef'="" CTLOCDesc1=$p($g(^CTLOC(eobj.LINKWardParRef)),"^",2)       //病区名
	s:eobj.LINKPACWardDR'="" CTLOCDesc2=$p($g(^CTLOC(eobj.LINKPACWardDR)),"^",2)       //病区名

	s sc = ##class(User.CTLocLinkWard).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocLinkWard","User.CTLocLinkWard","关联病区",id,CTLOCDesc1_"->"_CTLOCDesc2,"D",eobj)
	}
	else 
	{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("关联病区","web.DHCBL.CT.CTLocLinkWard","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// w ##class(web.DHCBL.CT.CTLocLinkWard).GetAllData(1,"")
ClassMethod GetAllData(ParRef, desc, hospid As %String = "") As %String
{
	s CTLocRowId=0
	s str=""
	s Count=0
	s desc=$ZCONVERT(desc,"U")
	for
	{
		s CTLocRowId=$o(^CTLOC(0,"LocType","W",CTLocRowId))
		q:CTLocRowId=""
		
		//根据医院过滤	20200523	likefan
		if (hospid'="")
		{
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLocRowId)),"^",22)
			continue:((CTLOCHospitalDR'="")&&(CTLOCHospitalDR'=hospid))
		}
		s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",CTLocRowId,0))
		s flag=$d(^CTLOC(ParRef,"LINKWARD",0,"Ward",WARDRowID))
		continue:flag>0
		s WARDDesc=$p($g(^PAWARD(WARDRowID)),"^",2)
		s WARDDesc1=$ZCONVERT(WARDDesc,"U")
		s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(WARDDesc1)
		;b
		if (WARDDesc1[desc)||(PINYIN[desc)
		{
			s:str'="" str=str_",{""ID"":"""_WARDRowID_""",""Name"":"""_WARDDesc_"""}"
			s:str="" str="{""ID"":"""_WARDRowID_""",""Name"":"""_WARDDesc_"""}"
			s Count=Count+1
		}
	}
	q "{data:["_str_"], success:true, total:"_Count_"}"
}

/// w ##class(web.DHCBL.CT.CTLocLinkWard).GetData(1)
ClassMethod GetData(ParRef, desc) As %String
{
	s WARDRowID=0
	s Count=0
	s str=""
	s desc=$ZCONVERT(desc,"U")
	for
	{
		s WARDRowID=$o(^CTLOC(ParRef,"LINKWARD",0,"Ward",WARDRowID))
		q:WARDRowID=""
		s WARDDesc=$p($g(^PAWARD(WARDRowID)),"^",2)
		s WARDDesc1=$ZCONVERT(WARDDesc,"U")
		s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(WARDDesc1)
		if (WARDDesc1[desc)||(PINYIN[desc)
		{
			s:str'="" str=str_",{""ID"":"""_WARDRowID_""",""Name"":"""_WARDDesc_"""}"
			s:str="" str="{""ID"":"""_WARDRowID_""",""Name"":"""_WARDDesc_"""}"
			s Count=Count+1

		}
	}
	q "{data:["_str_"], success:true, total:"_Count_"}"
}

/// w ##class(web.DHCBL.CT.CTLocLinkWard).SaveAll()
ClassMethod SaveAll(str) As %String
{
	s errorflag=0
	s erroinfo=""
	
	s i=0
	s len=$l(str,"#")
	s result=""
	s ParRef=$p($p(str,"#",1),"^",1)
	k ^CTLOC(ParRef,"LINKWARD")
	q:$p($p(str,"#",1),"^",2)="" "{success:'true',info:'保存成功！'}"
	for
	{
		s i=i+1
		q:i>=len
		s item=$p(str,"#",i)
		s eobj=##class(web.Entity.CT.CTLocLinkWard).%New(ParRef)
		s eobj.LINKPACWardDR=$p(item,"^",2)
		s eobj.LINKWardParRef=ParRef
		
		s result=..SaveEntity(eobj)
		if (result["success:'false'")
		{
			s errorflag=1
			s:erroinfo'="" erroinfo=erroinfo_","
			s erroinfo=erroinfo_$p($p(result,":",3),"'",2)
		}
	}
	if (errorflag=1) 
	{
		q "{success:'false',erroinfo:'"_erroinfo_"'}"
	}
	else
	{
		q "{success:'true',info:'保存成功！'}"
	}
}

}
