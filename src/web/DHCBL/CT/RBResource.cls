Import SQLUser

/// 名称: 关联科室维护功能	
/// 描述: 关联科室维护，包含增删改查等功能
/// 编写者：基础数据平台组 、蔡昊哲
/// 编写日期: 2012-9-1
Class web.DHCBL.CT.RBResource Extends %RegisteredObject
{

/// Creator：蔡昊哲
/// CreatDate: 2013-5-22
/// Description：查询关联科室内容
/// Table：User.RBResource
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.RBResource","GetList","","jzz","")
Query GetList(rowid, Code, LOCDR) As %Query(ROWSPEC = "RESRowId1,RESCTLOCDR,RESCTPCPDR,CTLOCDesc,CTPCPDesc,RESCode,RESDesc,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, Code, LOCDR) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s RESRowId1=rowid
		s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1)       //科室ID
		s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
		s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
		s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)	
		s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3)
		s RESCode = $$CO07^at8038a(RESCTPCPDR,RESEQDR)     //Code(1809,"")
		s RESDesc=$p($g(^RB("RES",RESRowId1)),"^",17)     //描述
		s RESScheduleRequired=$p($g(^RB("RES",RESRowId1)),"^",6)
		s RESMRRequest=$p($g(^RB("RES",RESRowId1)),"^",7)
		s RESAdmittingRights=$p($g(^RB("RES",RESRowId1)),"^",20)
		s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
		s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)

		s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1) //转换日期格式
		s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1) //转换日期格式
		d OutputRow
	}
	else
	{
		s RESRowId1=0
		for
		{  
			s RESRowId1=$o(^RB("RES",RESRowId1)) q:RESRowId1=""  
			s RESCTLOCDR=$p($g(^RB("RES",RESRowId1)),"^",1)       //科室ID
			s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
			s:RESCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(RESCTLOCDR)),"^",2)
			s:RESCTLOCDR="" CTLOCDesc=""
			s:RESCTPCPDR'="" CTPCPDesc=$p($g(^CTPCP(RESCTPCPDR,1)),"^",2)	
			s:RESCTPCPDR="" CTPCPDesc=""
			s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3)
			s RESCode = $$CO07^at8038a(RESCTPCPDR,RESEQDR)     //Code
			s RESDesc=$p($g(^RB("RES",RESRowId1)),"^",17)     //描述
			s RESScheduleRequired=$p($g(^RB("RES",RESRowId1)),"^",6)
			s RESMRRequest=$p($g(^RB("RES",RESRowId1)),"^",7)
			s RESAdmittingRights=$p($g(^RB("RES",RESRowId1)),"^",20)
			s RESDateActiveFrom=$p($g(^RB("RES",RESRowId1)),"^",22)
			s RESDateActiveTo=$p($g(^RB("RES",RESRowId1)),"^",23)

			s:RESDateActiveFrom'="" RESDateActiveFrom=$zd(RESDateActiveFrom,1) //转换日期格式
			s:RESDateActiveTo'="" RESDateActiveTo=$zd(RESDateActiveTo,1) //转换日期格式
		
			i ((RESCode=Code)||(Code=""))&((RESCTLOCDR=LOCDR)||(LOCDR=""))  //条件
			{
				d OutputRow
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RESRowId1,RESCTLOCDR,RESCTPCPDR,CTLOCDesc,CTPCPDesc,RESCode,RESDesc,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo)
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

/// Creator：蔡昊哲
/// CreatDate: 2012-12-25
/// Description：获取修改时的记录
/// Table：User.RBResource
/// Input：Id(User.RBResource的rowid)
ClassMethod OpenData(RowId As %String) As %String
{
	;d ##(web.DHCBL.CT.CTCareProv).OpenData("")
	
	s str=""	
	;RESCTLOCDR,RESScheduleRequired,RESMRRequest,RESAdmittingRights,RESDateActiveFrom,RESDateActiveTo
	s eobj = ##class(web.Entity.CT.RBResource).%New()
	s pobj = ##class(User.RBResource).%OpenId(RowId)
	s eobj.RESRowId1 = RowId
	s eobj.RESMRRequest = pobj.RESMRRequest
	
	s:pobj.RESCTPCPDR'="" eobj.RESCTPCPDR = pobj.RESCTPCPDR.%Id()
	s:pobj.RESCTLOCDR'="" eobj.RESCTLOCDR = pobj.RESCTLOCDR.%Id()
	s eobj.RESScheduleRequired = pobj.RESScheduleRequired
	s eobj.RESAdmittingRights = pobj.RESAdmittingRights	
	;s:pobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom = $zd(pobj.RESDateActiveFrom,1)
	;s:pobj.RESDateActiveTo'="" eobj.RESDateActiveTo = $zd(pobj.RESDateActiveTo,1)
	s:pobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RESDateActiveFrom)
	s:pobj.RESDateActiveTo'="" eobj.RESDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.RESDateActiveTo)
	
	d pobj.%Close()	
	k pobj	
	
	s:eobj.RESMRRequest="Y" eobj.RESMRRequest="true"
	s:eobj.RESScheduleRequired="Y" eobj.RESScheduleRequired="true"	
	s:eobj.RESAdmittingRights="Y" eobj.RESAdmittingRights="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2013-1-5    
/// d ##class(web.DHCBL.CT.RBResource).Validate("","","")
ClassMethod Validate(id As %String, CTPCP As %String, CTLOC As %String) As %String
{


	s flag=""
	s flagd=""
	
	s flagd=$d(^RB("RES",0,"CTPCP",CTPCP,CTLOC))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""	
		s idd=$o(^RB("RES",0,"CTPCP",CTPCP,CTLOC,0))
		if ((idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-25
/// Description：医护人员关联科室
/// Table：User.RBResource
/// Input：web.Entity.CT.RBResource 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod RelevanceDp(eobj As web.Entity.CT.RBResource) As %String
{
	s $zt="EEROE"
	
	s result=""
	s flag=..Validate("",eobj.RESCTPCPDR,eobj.RESCTLOCDR)  //调用重复验证
    if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该医护人员已经关联！'}"
	}
	else
	{
	    if $IsObject(eobj)
		{ 
			s cobj=##class(User.CTCareProv).%OpenId(eobj.RESCTPCPDR)			
			s obj=##class(User.RBResource).%New()
			s obj.RESCode = cobj.CTPCPCode 
			s obj.RESDesc = cobj.CTPCPDesc
			d obj.RESCTLOCDRSetObjectId(eobj.RESCTLOCDR)
			d obj.RESCTPCPDRSetObjectId(eobj.RESCTPCPDR)
			s obj.RESAdmittingRights="Y"
			s obj.RESMRRequest = "N"
			Ts
			s sc=obj.%Save()
			s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)
			s CTPCPDesc=$p($g(^CTPCP(eobj.RESCTPCPDR,1)),"^",2)	
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"         //返回RowId
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","医护人员关联科室",id,CTPCPDesc_"->"_CTLOCDesc,"A",eobj)
				
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联科室","web.DHCBL.CT.RBResource","RelevanceDp",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}
		else
		{
			s result = "{success:'false',errorinfo:'对象不存在！'}"
		}		
	}
	q result
EEROE
	q "{success:'false',errorinfo:'关联失败！'}"
}

/// Creator：蔡昊哲
/// CreatDate: 2012-7-27
/// Description：医护人员关联维护功能
/// Table：User.RBResource
/// Input：web.Entity.CT.RBResource 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.RBResource) As %String
{
	s result=""
	
    s:eobj.RESMRRequest="" eobj.RESMRRequest = "N"
    s:eobj.RESAdmittingRights="" eobj.RESAdmittingRights = "N"
    s:eobj.RESScheduleRequired="" eobj.RESScheduleRequired = "N"
    ;s:eobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom=$zdh(eobj.RESDateActiveFrom,15)  //转换日期
	;s:eobj.RESDateActiveTo'="" eobj.RESDateActiveTo=$zdh(eobj.RESDateActiveTo,15)      //转换日期
	s:eobj.RESDateActiveFrom'="" eobj.RESDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveFrom)  //转换日期
	s:eobj.RESDateActiveTo'="" eobj.RESDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.RESDateActiveTo)      //转换日期
	s:eobj.RESDateActiveFrom="" eobj.RESDateActiveFrom=+$h
	
    s flag=..Validate(eobj.RESRowId1,eobj.RESCTPCPDR,eobj.RESCTLOCDR)  //调用重复验证
    if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该科室已经和该医护人员关联，无法重复关联！'}"
	}
	else
	{
		
		
		//增加
		if (eobj.RESRowId1="")
		{	
			s obj=##class(User.RBResource).%New()
			s cobj=##class(User.CTCareProv).%OpenId(eobj.RESCTPCPDR)			
			s obj.RESCode = cobj.CTPCPCode 
			s obj.RESDesc = cobj.CTPCPDesc
			
		}
		else  //修改
		{
	    	s obj=##class(User.RBResource).%OpenId(eobj.RESRowId1)
	    	s bobj=##class(web.Entity.CT.RBResource).%New()
	    	s bobj.RESRowId1=eobj.RESRowId1
	    	s:obj.RESCTPCPDR'="" bobj.RESCTPCPDR = obj.RESCTPCPDR.%Id()
	    	s:obj.RESCTLOCDR'="" bobj.RESCTLOCDR = obj.RESCTLOCDR.%Id()
	    	s bobj.RESCode=obj.RESCode
	    	s bobj.RESDesc=obj.RESDesc
	    	s bobj.RESAdmittingRights=obj.RESAdmittingRights
	    	s bobj.RESScheduleRequired=obj.RESScheduleRequired
	    	s bobj.RESMRRequest=obj.RESMRRequest
	    	s bobj.RESDateActiveTo=obj.RESDateActiveTo
	    	s bobj.RESDateActiveFrom=obj.RESDateActiveFrom
	    	
		}	   	
		d obj.RESCTPCPDRSetObjectId(eobj.RESCTPCPDR)
		if (obj.RESCTPCPDR'=eobj.RESCTPCPDR)
		{
			d obj.RESCTLOCDRSetObjectId(eobj.RESCTLOCDR)
			s cobj=##class(User.CTCareProv).%OpenId(eobj.RESCTPCPDR)
			s obj.RESCode = cobj.CTPCPCode 
			s obj.RESDesc = cobj.CTPCPDesc
		}	
		s obj.RESAdmittingRights = eobj.RESAdmittingRights   //管理
		s obj.RESScheduleRequired = eobj.RESScheduleRequired //需要排班
		s obj.RESMRRequest = eobj.RESMRRequest      //需要病历
		s obj.RESDateActiveFrom = eobj.RESDateActiveFrom
		s obj.RESDateActiveTo = eobj.RESDateActiveTo
		
		s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)
		s CTPCPDesc=$p($g(^CTPCP(eobj.RESCTPCPDR,1)),"^",2)
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"          //返回RowId
			if (eobj.RESRowId1="")
			{
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","医护人员关联科室",id,CTPCPDesc_"->"_CTLOCDesc,"A",eobj,"",eobj.RESCTPCPDR)
			}
			else
			{
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","医护人员关联科室",id,CTPCPDesc_"->"_CTLOCDesc,"U",eobj,bobj,eobj.RESCTPCPDR)
			}
			
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联科室","web.DHCBL.CT.RBResource","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}		
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2013-7-1
/// Description:根据id删除关联科室
/// Table:User.RBResource
/// Input:id(RBResource的RESRowId1) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.RBResource).DeleteData("546")
ClassMethod DeleteData(id As %String) As %String
{
	s result="",AsChildSub=0,flag=0
	f  s AsChildSub=$o(^RBAS(id,AsChildSub))  q:AsChildSub=""  d
	.s:($d(^RBAS(id,AsChildSub,"APPT"))'=0)&($o(^RBAS(id,AsChildSub,"APPT",0))'="") flag=1
	i (flag=1){
		s result="{success:'false',info:'该条数据已被引用，无法删除！'}"
	}
	else{
		Tstart
		s eobj = ##class(web.Entity.CT.RBResource).%New()
		s pobj = ##class(User.RBResource).%OpenId(id)
		s eobj.RESRowId1 = id
		s eobj.RESMRRequest = pobj.RESMRRequest
		s:pobj.RESCTPCPDR'="" eobj.RESCTPCPDR = pobj.RESCTPCPDR.%Id()
		s:pobj.RESCTLOCDR'="" eobj.RESCTLOCDR = pobj.RESCTLOCDR.%Id()
		s eobj.RESScheduleRequired = pobj.RESScheduleRequired
		s eobj.RESAdmittingRights = pobj.RESAdmittingRights	
		s sc=##class(User.RBResource).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			
			s CTPCPDesc="",CTLOCDesc=""
			if eobj.RESCTLOCDR'=""
			{
				s CTLOCDesc=$p($g(^CTLOC(eobj.RESCTLOCDR)),"^",2)
			}
			if eobj.RESCTPCPDR'=""
			{
				s CTPCPDesc=$p($g(^CTPCP(eobj.RESCTPCPDR,1)),"^",2)	
			}
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","医护人员关联科室",id,CTPCPDesc_"->"_CTLOCDesc,"D",eobj,"",eobj.RESCTPCPDR)
			s result="{success:'true',info:'删除成功！'}"		
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联科室","web.DHCBL.CT.RBResource","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

}
