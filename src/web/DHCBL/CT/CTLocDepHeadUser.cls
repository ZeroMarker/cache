/// 项目：安徽淮南朝阳，张婷，科主任需要维护多个人
/// 描述: 科主任子表增删改查
/// 表名：CT_LocDepHeadUser
/// 父表：科室病区User.CTLoc
/// 编写者：基础数据平台-likefan
/// 编写日期: 2021-01-06
Class web.DHCBL.CT.CTLocDepHeadUser Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2021-01-06
/// Description：获取科主任列表
/// Table：User.CTLocDepHeadUser
/// Input：parref(CTLOCRowID),rowid
/// output：rowid，科室id，科主任id
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocDepHeadUser","GetList","1","")
Query GetList(parref As %String, rowid As %String) As %Query(ROWSPEC = "CTDHURowId,CTDHUParRef,CTDHUDepHeadUserDR,CTDHUDepHeadUserCode,CTDHUDepHeadUserDesc,CTDHUDateFrom,CTDHUDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s CTDHURowId=rowid
		s CTLOCRowID=$p(CTDHURowId,"||",1)
		s CTDHUChildsub=$p(CTDHURowId,"||",2)
		s CTDHUParRef=CTLOCRowID
		s CTDHUDepHeadUserDR=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",1)
		s CTDHUDepHeadUserCode=""
		s CTDHUDepHeadUserDesc=""
		if (CTDHUDepHeadUserDR'="")
		{
			s CTDHUDepHeadUserCode=$p($g(^SSU("SSUSR",CTDHUDepHeadUserDR)),"^",1)     //科主任工号
			s CTDHUDepHeadUserDesc=$p($g(^SSU("SSUSR",CTDHUDepHeadUserDR)),"^",2)     //科主任姓名
		}
		s CTDHUDateFrom=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",2)	//开始日期
		s CTDHUDateTo=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",3)	//结束日期
		s:CTDHUDateFrom'="" CTDHUDateFrom=$zd(CTDHUDateFrom,3)
		s:CTDHUDateTo'="" CTDHUDateTo=$zd(CTDHUDateTo,3)
		d OutputRow
	}
	else
	{
		s CTLOCRowID=parref,CTDHUChildsub=0
		for
		{
			s CTDHUChildsub=$o(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)) q:CTDHUChildsub=""
			s CTDHURowId=CTLOCRowID_"||"_CTDHUChildsub
			s CTDHUParRef=parref
			s CTDHUDepHeadUserDR=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",1)
			s CTDHUDepHeadUserCode=""
			s CTDHUDepHeadUserDesc=""
			if (CTDHUDepHeadUserDR'="")
			{
				s CTDHUDepHeadUserCode=$p($g(^SSU("SSUSR",CTDHUDepHeadUserDR)),"^",1)     //科主任工号
				s CTDHUDepHeadUserDesc=$p($g(^SSU("SSUSR",CTDHUDepHeadUserDR)),"^",2)     //科主任姓名
			}
			s CTDHUDateFrom=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",2)	//开始日期
			s CTDHUDateTo=$p($g(^CTLOC(CTLOCRowID,"CTDHU",CTDHUChildsub)),"^",3)	//结束日期
			s:CTDHUDateFrom'="" CTDHUDateFrom=$zd(CTDHUDateFrom,3)
			s:CTDHUDateTo'="" CTDHUDateTo=$zd(CTDHUDateTo,3)
			i (CTDHUDepHeadUserDR'="")
			{
				d OutputRow
			}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTDHURowId,CTDHUParRef,CTDHUDepHeadUserDR,CTDHUDepHeadUserCode,CTDHUDepHeadUserDesc,CTDHUDateFrom,CTDHUDateTo)
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
/// Creator:基础数据平台-李可凡
/// CreateDate:2021-01-06    
/// w ##class(web.DHCBL.CT.CTLocDepHeadUser).FormValidate("1||1","1","1")
ClassMethod FormValidate(rowid As %String, parref As %String, headuserdr As %String, dateform As %String, dateto As %String) As %String
{
	s:dateform'="" dateform=$zdh(dateform,3)
	s:dateto'="" dateto=$zdh(dateto,3)
	s flag=0
	s ChildSub=0
	for
	{
		s ChildSub=$o(^CTLOC(parref,"CTDHU",ChildSub)) q:ChildSub=""
		s CTDHUDepHeadUserDR=$p($g(^CTLOC(parref,"CTDHU",ChildSub)),"^",1)
		s CTDHUDateFrom=$p($g(^CTLOC(parref,"CTDHU",ChildSub)),"^",2)	//开始日期
		s CTDHUDateTo=$p($g(^CTLOC(parref,"CTDHU",ChildSub)),"^",3)		//结束日期
		s CTDHURowId=parref_"||"_ChildSub
		continue:(rowid=CTDHURowId)		//跳过自己
		if (headuserdr=CTDHUDepHeadUserDR)
		{
			if (CTDHUDateTo="")
			{
				if (dateform>CTDHUDateFrom)||(dateto>CTDHUDateFrom)
				{
					s flag=1
				}
			}
			else
			{
				s:(dateform>CTDHUDateFrom)&&(dateform<CTDHUDateTo) flag=1
				s:(dateto>CTDHUDateFrom)&&(dateto<CTDHUDateTo) flag=1
			}
		}
	}
	q flag
}

/// Creator：李可凡
/// CreatDate: 2021-01-06
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.CTLocDepHeadUser).Test()
ClassMethod Test()
{
	s eobj=##class(web.Entity.CT.CTLocDepHeadUser).%New()
	s eobj.CTDHUParRef="3"
	s eobj.CTDHURowId="3||1"
	s eobj.CTDHUDepHeadUserDR="7"
	w ..SaveEntity(eobj)
}

/// Creator：李可凡
/// CreatDate: 2021-01-06
/// Description：保存科主任
/// Table：User.CTLocDepHeadUser
/// Input:web.Entity.CT.CTLocDepHeadUser
/// Return:成功返回true和id,失败返回false和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocDepHeadUser) As %String
{
	s result=""
	s flag=..FormValidate(eobj.CTDHURowId,eobj.CTDHUParRef,eobj.CTDHUDepHeadUserDR,eobj.CTDHUDateFrom,eobj.CTDHUDateTo)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'数据重复或日期重复！'}"
	}
	else
	{
		s:eobj.CTDHUDateFrom'="" eobj.CTDHUDateFrom=$zdh(eobj.CTDHUDateFrom,3)
		s:eobj.CTDHUDateTo'="" eobj.CTDHUDateTo=$zdh(eobj.CTDHUDateTo,3)
		if (eobj.CTDHURowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.CTLocDepHeadUser).%New(eobj.CTDHUParRef)
			d obj.CTDHUParRefSetObjectId(eobj.CTDHUParRef)
		}
		else                     //如果RowId已赋值则修改
		{
			s obj=##class(User.CTLocDepHeadUser).%OpenId(eobj.CTDHURowId)
			s bobj=##class(web.Entity.CT.CTLocDepHeadUser).%New(eobj.CTDHUParRef)
			s bobj.CTDHURowId=eobj.CTDHURowId
			s:obj.CTDHUDepHeadUserDR'="" bobj.CTDHUDepHeadUserDR=obj.CTDHUDepHeadUserDR.%Id()
			s:obj.CTDHUParRef'="" bobj.CTDHUParRef=obj.CTDHUParRef.%Id()
			s bobj.CTDHUDateFrom=obj.CTDHUDateFrom
			s bobj.CTDHUDateTo=obj.CTDHUDateTo
		}
		d obj.CTDHUDepHeadUserDRSetObjectId(eobj.CTDHUDepHeadUserDR)
		s obj.CTDHUDateFrom=eobj.CTDHUDateFrom
		s obj.CTDHUDateTo=eobj.CTDHUDateTo
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"         //返回RowId
			s CTLOCDesc=$p($g(^CTLOC(eobj.CTDHUParRef)),"^",2)	
			s CTDHUDesc=$p($g(^SSU("SSUSR",eobj.CTDHUDepHeadUserDR)),"^",2)
			d:eobj.CTDHURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocDepHeadUser","User.CTLocDepHeadUser","科主任",id,CTLOCDesc_"->"_CTDHUDesc,"U",eobj,bobj)
			d:eobj.CTDHURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocDepHeadUser","User.CTLocDepHeadUser","科主任",id,CTLOCDesc_"->"_CTDHUDesc,"A",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科主任","web.DHCBL.CT.CTLocDepHeadUser","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}
	}
	q result
}

/// Creator：李可凡
/// CreatDate: 2021-01-06
/// Description：删除科主任
/// Table：User.CTLocDepHeadUser
/// Input：id
/// Return:成功返回true和id,失败返回false和errorinfo
/// Other: w ##class(web.DHCBL.CT.CTLocDepHeadUser).DeleteData("3||1")
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.CTLocDepHeadUser).%New()
	s pobj = ##class(User.CTLocDepHeadUser).%OpenId(id)
	s ParRef=$p($g(id),"||",1)  
	s ChildSub=$p($g(id),"||",2)
	S eobj.CTDHURowId = id
	s eobj.CTDHUParRef = ParRef
	s eobj.CTDHUChildsub = ChildSub
	s:pobj.CTDHUDepHeadUserDR'="" eobj.CTDHUDepHeadUserDR = pobj.CTDHUDepHeadUserDR.%Id()
	s eobj.CTDHUDateFrom=pobj.CTDHUDateFrom
	s eobj.CTDHUDateTo=pobj.CTDHUDateTo

	TSTART
	s sc = ##class(User.CTLocDepHeadUser).%DeleteId(id)
	if $$$ISOK(sc)
	{
		TCOMMIT
		s result = "{success:'true',info:'删除成功！'}"	
		s CTLOCDesc=$p($g(^CTLOC(eobj.CTDHUParRef)),"^",2)       //科室名
		s CTDHUDesc=$p($g(^SSU("SSUSR",eobj.CTDHUDepHeadUserDR)),"^",2)       //科主任名
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocDepHeadUser","User.CTLocDepHeadUser","科主任",id,CTLOCDesc_"->"_CTDHUDesc,"D",eobj)
	}
	else 
	{
		TROLLBACK
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科主任","web.DHCBL.CT.CTLocDepHeadUser","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:李可凡
/// CreatDate:2021-01-06
/// description：双击修改获取数据
/// Table：User.CTLocDepHeadUser
/// Input：id
/// Return:rowid，科室id，科主任id
/// Other:w ##class(web.DHCBL.CT.CTLocDepHeadUser).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTLocDepHeadUser).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocDepHeadUser).%New()
	s eobj.CTDHURowId = id
	s eobj.CTDHUParRef =$p(id,"||",1)
	s eobj.CTDHUChildsub =$p(id,"||",2)
	s:pobj.CTDHUDepHeadUserDR'="" eobj.CTDHUDepHeadUserDR = pobj.CTDHUDepHeadUserDR.%Id() 
	s eobj.CTDHUDateFrom=pobj.CTDHUDateFrom
	s eobj.CTDHUDateTo=pobj.CTDHUDateTo
	s:eobj.CTDHUDateFrom'="" eobj.CTDHUDateFrom=$zd(eobj.CTDHUDateFrom,3)
	s:eobj.CTDHUDateTo'="" eobj.CTDHUDateTo=$zd(eobj.CTDHUDateTo,3)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-3-27
/// Description:查询 用户 
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocDepHeadUser","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "SSUSRRowId,SSUSRInitials,SSUSRName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s SSUSRRowId=rowid
		s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)		//人事ID
		s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s SSUSRName=SSUSRInitials_"-"_SSUSRName
		d OutputRowCmb
	}
	else
	{
		s SSUSRRowId=0
		for
		{
			s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId="" 
			
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s SSUSRInitials=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)		//人事ID
			s SSUSRName=SSUSRInitials_"-"_SSUSRName
			s SSUSRActive=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活
			s SSUSRDateFrom=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",96)  //开始日期
			s SSUSRDateTo=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",97)  //结束日期
			continue:SSUSRActive="N"
			continue:(SSUSRDateFrom'="")&&(SSUSRDateFrom>+$h)
			continue:(SSUSRDateTo'="")&&(SSUSRDateTo<+$h)
			
			d OutputRowCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(SSUSRRowId,SSUSRInitials,SSUSRName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：李可凡
/// CreatDate: 2022-05-30
/// Description：获取默认及其他科主任
/// Input：科室rowid
/// output：用户rowid，用户工号，用户姓名，是否默认科主任
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocDepHeadUser","GetDepHeadUserQuery","1")
Query GetDepHeadUserQuery(locid As %String) As %Query(ROWSPEC = "HeadUserId,HeadUserCode,HeadUserDesc,DefFlag")
{
}

ClassMethod GetDepHeadUserQueryExecute(ByRef qHandle As %Binary, locid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (locid'="")
	{
		s HeadUserId=$p($g(^CTLOC(locid)),"^",54)     //默认科主任DR
		if (HeadUserId'="")
		{
			s UserDRArray(HeadUserId)="1"
			s HeadUserCode=$p($g(^SSU("SSUSR",HeadUserId)),"^",1)     //默认科主任工号
			s HeadUserDesc=$p($g(^SSU("SSUSR",HeadUserId)),"^",2)     //默认科主任姓名
			s DefFlag="Y"	//默认标识
			d DepHeadUserOutput
		}
		
		s CTDHUChildsub=0
		for
		{
			s CTDHUChildsub=$o(^CTLOC(locid,"CTDHU",CTDHUChildsub)) q:CTDHUChildsub=""
			s HeadUserId=$p($g(^CTLOC(locid,"CTDHU",CTDHUChildsub)),"^",1)
			continue:HeadUserId=""
			s HeadUserCode=$p($g(^SSU("SSUSR",HeadUserId)),"^",1)     //科主任工号
			s HeadUserDesc=$p($g(^SSU("SSUSR",HeadUserId)),"^",2)     //科主任姓名
			s CTDHUDateFrom=$p($g(^CTLOC(locid,"CTDHU",CTDHUChildsub)),"^",2)	//开始日期
			s CTDHUDateTo=$p($g(^CTLOC(locid,"CTDHU",CTDHUChildsub)),"^",3)		//结束日期
			continue:(CTDHUDateFrom>+$h)
			continue:(CTDHUDateTo'="")&&(CTDHUDateTo<+$h)
			continue:$d(UserDRArray(HeadUserId))=1		//科主任去重
			s UserDRArray(HeadUserId)=""
			s DefFlag="N"
			d DepHeadUserOutput
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DepHeadUserOutput
    set Data=$lb(HeadUserId,HeadUserCode,HeadUserDesc,DefFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDepHeadUserQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepHeadUserQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepHeadUserQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepHeadUserQueryExecute ]
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

/// 根据科室取所有科主任
/// 基础数据平台-likefan
/// 2021-01-06
/// input: 科室id
/// output: 用户id^用户id^用户id
/// w ##class(web.DHCBL.CT.CTLocDepHeadUser).GetDepHeadUser("1")
ClassMethod GetDepHeadUser(id) As %String
{
	q:id="" ""
	s result=""
	s CTLOCDepartmentHeadUserDR=$p($g(^CTLOC(id)),"^",54)     //默认科主任DR
	s:CTLOCDepartmentHeadUserDR'="" UserDRArray(CTLOCDepartmentHeadUserDR)="Def"	//默认标识
	s result=CTLOCDepartmentHeadUserDR
	s CTDHUChildsub=0
	for
	{
		s CTDHUChildsub=$o(^CTLOC(id,"CTDHU",CTDHUChildsub)) q:CTDHUChildsub=""
		s CTDHUDepHeadUserDR=$p($g(^CTLOC(id,"CTDHU",CTDHUChildsub)),"^",1)		//其他科主任DR
		//s:CTDHUDepHeadUserDR'="" CTDHUDepHeadUserDR=$p($g(^SSU("SSUSR",CTDHUDepHeadUserDR)),"^",2)     //科主任名
		s CTDHUDateFrom=$p($g(^CTLOC(id,"CTDHU",CTDHUChildsub)),"^",2)	//开始日期
		s CTDHUDateTo=$p($g(^CTLOC(id,"CTDHU",CTDHUChildsub)),"^",3)	//结束日期
		continue:CTDHUDepHeadUserDR=""
		continue:(CTDHUDateFrom>+$h)
		continue:(CTDHUDateTo'="")&&(CTDHUDateTo<+$h)
		continue:$d(UserDRArray(CTDHUDepHeadUserDR))=1	//科主任去重
		s UserDRArray(CTDHUDepHeadUserDR)=""
		s:result'="" result=result_"^"
		s result=result_CTDHUDepHeadUserDR
	}
	b ;UserDRArray
	q result
}

/// 批量同步原科主任数据到关联科主任子表
/// 基础数据平台-likefan
/// 2021年5月24日
/// debug：w ##class(web.DHCBL.CT.CTLocDepHeadUser).SyncCTLocDepHeadUser()
ClassMethod SyncCTLocDepHeadUser()
{
	s CTLOCRowID=0
	for  
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		
		s CTLOCDepartmentHeadUserDR=$p($g(^CTLOC(CTLOCRowID)),"^",54)     //科主任DR
		if (CTLOCDepartmentHeadUserDR'="")
		{
			//s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		    //s SSUSRName=$p($g(^SSU("SSUSR",CTLOCDepartmentHeadUserDR)),"^",2)	//用户名
		    //w CTLOCDesc_","_SSUSRName,!
		    
		    s eobj=##class(web.Entity.CT.CTLocDepHeadUser).%New()
			s eobj.CTDHUParRef=CTLOCRowID
			s eobj.CTDHUDepHeadUserDR=CTLOCDepartmentHeadUserDR
			s eobj.CTDHUDateFrom=$zd(+$h,3)
			w ..SaveEntity(eobj)
			w !
		}
	}
	q "ok"
}

}
