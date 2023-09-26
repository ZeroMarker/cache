Import SQLUser

/// 名称:系统管理  - 安全组子表 医嘱状态
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期:2014-3-12
Class web.DHCBL.CT.SSGroupOrderStatus Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-3-12
/// Description:查询 医嘱状态
/// Table:User.web.DHCBL.CT.SSGroupOrderStatus
/// Input:ssgrprowid(父表SSGroup的id),rowid
/// Return:OSTATParRef,OSTATRowId,OSTATOrdStatDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupOrderStatus","GetList","1","","")
Query GetList(ssgrprowid As %String, rowid As %String, ordstatdr As %String) As %Query(ROWSPEC = "OSTATParRef:%String,OSTATRowId:%String,OSTATOrdStatDR:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ssgrprowid As %String, rowid As %String, ordstatdr As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s SSGRPRowId=$p(rowid,"||",1)
		s OSTATChildsub=$p(rowid,"||",2)
		s OSTATRowId=rowid
		s OSTATParRef=SSGRPRowId
		s OrdStatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)),"^",1)
		i OrdStatDR'="" {
			s OSTATOrdStatDR = $p($g(^OEC("OSTAT",OrdStatDR)),"^",2)
		}
		else {
			s OSTATOrdStatDR=""
		}
		d OutputRow
	}
	else
	{
		if (ssgrprowid)
		{
		s SSGRPRowId=ssgrprowid,OSTATChildsub=0
		for
		{
			s OSTATChildsub=$o(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)) q:OSTATChildsub=""
			s OSTATRowId=SSGRPRowId_"||"_OSTATChildsub
			s OSTATParRef=ssgrprowid
			s OrdStatDR=$P($g(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)),"^",1)
			i OrdStatDR'="" {
				s OSTATOrdStatDR = $p($g(^OEC("OSTAT",OrdStatDR)),"^",2)
			}
			else {
				s OSTATOrdStatDR=""
			}
			i (OSTATChildsub>0)&((OrdStatDR=ordstatdr)||(ordstatdr="")) 
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(OSTATParRef,OSTATRowId,OSTATOrdStatDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2014-3-12
/// Description:双击修改时,从后台取数据
/// Table:User.SSGroupOrderStatus
/// Input:id
/// Return:Json格式的字符串str={list:[OSTATParRef,OSTATRowId,OSTATOrdStatDR]}
/// Other:w ##class(web.DHCBL.CT.SSGroupOrderStatus).OpenData("1||7")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.SSGroupOrderStatus).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderStatus).%New()
	s eobj.OSTATRowId = id
	s eobj.OSTATParRef = $p(id,"||",1)
	if $IsObject(pobj.OSTATOrdStatDR){
		s eobj.OSTATOrdStatDR = pobj.OSTATOrdStatDR.%Id() 
		}
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.SSGroupOrderStatus).SaveTest()
	s eobj = ##class(web.Entity.CT.SSGroupOrderStatus).%New()
	s eobj.OSTATParRef=1
	s eobj.OSTATOrdStatDR="1"
	w ..SaveEntity(eobj)
}

/// Creator:陈莹
/// CreatDate:2014-3-12
/// Description:增加/修改 医嘱状态
/// Table:User.SSGroupOrderStatus
/// Input:web.Entity.CT.SSGroupOrderStatus
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroupOrderStatus) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//如果RowId未赋值则增加
		if (eobj.OSTATRowId="")
		{
			s SSGRPRowId=0,flag=0
			for{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				s OSTATChildsub=0
				for{
					s OSTATChildsub=$o(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)) q:OSTATChildsub=""
					s OSTATRowId=SSGRPRowId_"||"_OSTATChildsub
					s OSTATParRef=SSGRPRowId
					s OSTATOrdStatDR=$p($g(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)),"^",1)
					i ((eobj.OSTATParRef=OSTATParRef)&(eobj.OSTATOrdStatDR=OSTATOrdStatDR)&(OSTATChildsub>0))
					{
						s flag=1 //flag=1 有重复
					}
				}
			}
			if (flag'=1) {
				s obj = ##class(User.SSGroupOrderStatus).%New(eobj.OSTATParRef)
			}
			else{
				q "{success:'false',errorinfo:'该记录已经存在！'}"
			}
		}
		//如果RowId已赋值则修改
		else           
		{
			s SSGRPRowId=0,flag=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
				s OSTATChildsub=0
				for
				{
					s OSTATChildsub=$o(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)) q:OSTATChildsub=""
					s OSTATRowId=SSGRPRowId_"||"_OSTATChildsub
					s OSTATParRef=SSGRPRowId
					s OSTATOrdStatDR=$p($g(^SSU("SSGRP",SSGRPRowId,"OSTAT",OSTATChildsub)),"^",1)
					i ((eobj.OSTATParRef=OSTATParRef)&(eobj.OSTATOrdStatDR=OSTATOrdStatDR)&(eobj.OSTATRowId'=OSTATRowId)&(OSTATChildsub>0))
					{
						s flag=1 //flag=1 有重复
					}
				}
			}
			if (flag'=1) {
				s obj = ##class(User.SSGroupOrderStatus).%OpenId(eobj.OSTATRowId)
				s bobj = ##class(web.Entity.CT.SSGroupOrderStatus).%New()
				s bobj.OSTATRowId=eobj.OSTATRowId
				s bobj.OSTATParRef=$p(eobj.OSTATRowId ,"||",1)
				if $IsObject(obj.OSTATOrdStatDR){
					s bobj.OSTATOrdStatDR = obj.OSTATOrdStatDR.%Id() 
				}
				
			}
			else{
				q "{success:'false',errorinfo:'该记录已经存在！'}"
			}	
		}
		
		
		d obj.OSTATParRefSetObjectId(eobj.OSTATParRef)
		d obj.OSTATOrdStatDRSetObjectId(eobj.OSTATOrdStatDR)
		s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.OSTATParRef)),"^",1)
		s OSTATDesc = $p($g(^OEC("OSTAT",eobj.OSTATOrdStatDR)),"^",2)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.OSTATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderStatus","User.SSGroupOrderStatus","安全组-医嘱状态",id,SSGRPDesc_"->"_OSTATDesc,"A",eobj)
			d:eobj.OSTATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderStatus","User.SSGroupOrderStatus","安全组-医嘱状态",id,SSGRPDesc_"->"_OSTATDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱状态","web.DHCBL.CT.SSGroupOrderStatus","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹
/// CreatDate: 2014-3-12
/// Description：根据id删除 医嘱状态
/// Table：User.SSGroup
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.SSGroupOrderStatus).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderStatus).%New()
	s eobj.OSTATRowId = id
	s eobj.OSTATParRef = $p(id,"||",1)
	if $IsObject(pobj.OSTATOrdStatDR){
		s eobj.OSTATOrdStatDR = pobj.OSTATOrdStatDR.%Id() 
	}
	s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.OSTATParRef)),"^",1)
	s OSTATDesc = $p($g(^OEC("OSTAT",eobj.OSTATOrdStatDR)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.SSGroupOrderStatus).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderStatus","User.SSGroupOrderStatus","安全组-医嘱状态",id,SSGRPDesc_"->"_OSTATDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱状态","web.DHCBL.CT.SSGroupOrderStatus","DeleteData",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

}
