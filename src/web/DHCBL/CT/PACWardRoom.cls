Import SQLUser

/// 名称:科室/病区 - 病区床位- 房间分配	
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-5
Class web.DHCBL.CT.PACWardRoom Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2013-10-11
/// Description：根据CTLOCID获取WARDID
/// Table：User.PACWardRoom
ClassMethod GetWardRoomParRef(id As %String) As %String
{
	s result = $o(^PAWARD(0,"WARD_LocationDR",id,0))
	q result
}

/// Creator：李森
/// CreatDate: 2012-8-29
/// Description：查询等候区的内容
/// Table：User.PACWardRoom
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACWardRoom","GetList","5","","")
Query GetList(ROOMParRef As %String, rowid As %String, ROOMRoomDesc As %String) As %Query(ROWSPEC = "ROOMRowId,ROOMRoomDRCode,ROOMRoomDR,ROOMDateFrom,ROOMDateTo,ROOMPositionLeft,ROOMPositionTop,ROOMPositionHeight,ROOMPositionWidth")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ROOMParRef As %String, rowid As %String, ROOMRoomDesc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ROOMRowId=rowid
		s ROOMParRef=$p(rowid,"||",1)
		s Id=$p(rowid,"||",2)
		s ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",1)
		s ROOMRoomDRCode=""
		s:ROOMRoomDR'="" ROOMRoomDRCode=$p($g(^PAROOM(ROOMRoomDR)),"^",1)
		s:ROOMRoomDR'="" ROOMRoomDR=$p($g(^PAROOM(ROOMRoomDR)),"^",2)
		s ROOMDateFrom=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",7)
		s ROOMDateTo=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",8)
		s:ROOMDateFrom'="" ROOMDateFrom=$zd(ROOMDateFrom,1) //转换日期格式
		s:ROOMDateTo'="" ROOMDateTo=$zd(ROOMDateTo,1) //转换日期格式
		s ROOMPositionLeft=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",2)
		s ROOMPositionTop=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",3)
		s ROOMPositionHeight=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",5)
		s ROOMPositionWidth=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",4)
		d OutputRow
	}
	else
	{
		s:ROOMRoomDesc'="" ROOMRoomDesc=$$ALPHAUP^SSUTIL4(ROOMRoomDesc) //转换成大写
		s Id=0
		for
		{
			s Id=$o(^PAWARD(ROOMParRef,"ROOM",Id)) q:Id=""
			s ROOMRowId=ROOMParRef_"||"_Id
			s ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",1)
			s ROOMRoomDRCode=""
			s:ROOMRoomDR'="" ROOMRoomDRCode=$p($g(^PAROOM(ROOMRoomDR)),"^",1)
			s:ROOMRoomDR'="" ROOMRoomDR=$p($g(^PAROOM(ROOMRoomDR)),"^",2)
			s ROOMDateFrom=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",7)
			s ROOMDateTo=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",8)
			s:ROOMDateFrom'="" ROOMDateFrom=$zd(ROOMDateFrom,1) //转换日期格式
			s:ROOMDateTo'="" ROOMDateTo=$zd(ROOMDateTo,1) //转换日期格式
			s ROOMPositionLeft=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",2)
			s ROOMPositionTop=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",3)
			s ROOMPositionHeight=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",5)
			s ROOMPositionWidth=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",4)
			i ($$ALPHAUP^SSUTIL4(ROOMRoomDR)[ROOMRoomDesc)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ROOMRowId,ROOMRoomDRCode,ROOMRoomDR,ROOMDateFrom,ROOMDateTo,ROOMPositionLeft,ROOMPositionTop,ROOMPositionHeight,ROOMPositionWidth)
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

/// Creator：chenying
/// CreatDate: 2013-9-9
/// Description:  根据ctloc获取等候区信息
/// Table：       PACWardRoom
/// Input：       ctloc
/// Return：      返回 等候区要转换的panel信息，按照<$C1>分隔行，用^分隔字段 
/// 1 BEDRowID , 2 ROOM_Room_DR->Desc, 3 ROOMPositionLeft,4 ROOMPositionTop ,5 ROOMPositionHeight ,6 ROOMPositionWidth
/// w ##class(web.DHCBL.CT.PACWardRoom).GetPACWardRoomPanelInfo("22")
ClassMethod GetPACWardRoomPanelInfo(ctloc) As %String
{
	s ROOMParRef = $o(^PAWARD(0,"WARD_LocationDR",ctloc,0))
	k ^CacheTemp("PAC_WardRoom","floor")
	s roomchildsub=0,ret=""
	for
	{
		s roomchildsub=$o(^PAWARD(ROOMParRef,"ROOM",roomchildsub)) q:roomchildsub=""
		s ROOMRowID=ROOMParRef_"||"_roomchildsub
		s ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",roomchildsub)),"^",1)
		s:ROOMRoomDR'="" ROOMRoomDR=$p($g(^PAROOM(ROOMRoomDR)),"^",2)
		s ROOMPositionLeft=$p($g(^PAWARD(ROOMParRef,"ROOM",roomchildsub)),"^",2)
		s ROOMPositionTop=$p($g(^PAWARD(ROOMParRef,"ROOM",roomchildsub)),"^",3)
		s ROOMPositionHeight=$p($g(^PAWARD(ROOMParRef,"ROOM",roomchildsub)),"^",5)
		s ROOMPositionWidth=$p($g(^PAWARD(ROOMParRef,"ROOM",roomchildsub)),"^",4)
		s ^CacheTemp("PAC_WardRoom","floor",ROOMRowID)=ROOMRowID_"^"_ROOMRoomDR_"^"_ROOMPositionLeft_"^"_ROOMPositionTop_"^"_ROOMPositionHeight_"^"_ROOMPositionWidth
		s ret=ret_^CacheTemp("PAC_WardRoom","floor",ROOMRowID)_"<$C1>"  //s ^CacheTemp($zn,$j,portletId)?
	}
	q ret
}

/// Creator：李森
/// CreatDate: 2013-6-4
/// Description：修改时打开的数据
/// Table：User.PACWardRoom
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.CT.PACWardRoom).%New()
	s eobj.ROOMRowId = id
	s ROOMParRef=$p(id,"||",1)
	s Id=$p(id,"||",2)
	s eobj.ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",1)
	s eobj.ROOMDateFrom=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",7)
	s eobj.ROOMDateTo=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",8)
	
	s:eobj.ROOMDateFrom'="" eobj.ROOMDateFrom=$zd(eobj.ROOMDateFrom,1) //转换日期格式
	s:eobj.ROOMDateTo'="" eobj.ROOMDateTo=$zd(eobj.ROOMDateTo,1) //转换日期格式
	s eobj.ROOMPositionLeft=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",2)
	s eobj.ROOMPositionTop=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",3)
	s eobj.ROOMPositionHeight=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",5)
	s eobj.ROOMPositionWidth=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",4)
	
	s str = eobj.JsonS()	
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：李森
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.PACWardRoom
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.PACWardRoom).Validate("","","")
ClassMethod Validate(ROOMParRef As %String, ROOMRowId As %String, ROOMRoomDR As %String) As %String
{
	s flag=0,flagc=""
	
	if (ROOMRowId="") //如果为空,增加时的重复判断
	{
		s flagc=$d(^PAWARD(ROOMParRef,"ROOM",0,"Room",ROOMRoomDR))
		if (flagc>0) s flag=1  //返回重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s ROOMParRef=$p(ROOMRowId,"||",1)
		s flagc=$d(^PAWARD(ROOMParRef,"ROOM",0,"Room",ROOMRoomDR))
		s sub=$o(^PAWARD(ROOMParRef,"ROOM",0,"Room",ROOMRoomDR,0))
		s childsub=$p(ROOMRowId,"||",2)
		if (sub'=childsub)&(flagc>0) s flag=1  //返回重复标志
	}
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2013-8-1
/// Description：保存修改等候区的内容
/// Table：User.PACWardRoom
/// Input：web.Entity.CT.PACWardRoom 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACWardRoom).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACWardRoom) As %String
{
	;s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ROOMDateFrom'="" eobj.ROOMDateFrom=$zdh(eobj.ROOMDateFrom,15) //转换日期
		s:eobj.ROOMDateTo'="" eobj.ROOMDateTo=$zdh(eobj.ROOMDateTo,15)      //转换日期
		s:eobj.ROOMDateFrom="" eobj.ROOMDateFrom=+$h
		
		s flag=..Validate(eobj.ROOMParRef,eobj.ROOMRowId,eobj.ROOMRoomDR)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ROOMRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.PACWardRoom).%New(eobj.ROOMParRef)
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.PACWardRoom).%OpenId(eobj.ROOMRowId)
				s bobj=##class(web.Entity.CT.PACWardRoom).%New(eobj.ROOMParRef)
				s bobj.ROOMRowId=eobj.ROOMRowId
				s bobj.ROOMParRef=obj.ROOMParRef
				s bobj.ROOMRoomDR=obj.ROOMRoomDR
				s bobj.ROOMDateFrom = obj.ROOMDateFrom  
				s bobj.ROOMDateTo = obj.ROOMDateTo    
				s bobj.ROOMPositionLeft = obj.ROOMPositionLeft
				s bobj.ROOMPositionTop = obj.ROOMPositionTop
				s bobj.ROOMPositionHeight = obj.ROOMPositionHeight
				s bobj.ROOMPositionWidth = obj.ROOMPositionWidth
			}
			Ts
			d:eobj.ROOMParRef'="" obj.ROOMParRefSetObjectId(eobj.ROOMParRef)
			d obj.ROOMRoomDRSetObjectId(eobj.ROOMRoomDR)
			s:eobj.ROOMRoomDR'="" ROOMRoomDRCode=$p($g(^PAROOM(eobj.ROOMRoomDR)),"^",1)
			s obj.ROOMDateFrom = eobj.ROOMDateFrom  //修改开始日期
			s obj.ROOMDateTo = eobj.ROOMDateTo      //修改结束日期
			
			
			s obj.ROOMPositionLeft = eobj.ROOMPositionLeft
			s obj.ROOMPositionTop = eobj.ROOMPositionTop
			s obj.ROOMPositionHeight = eobj.ROOMPositionHeight
			s obj.ROOMPositionWidth = eobj.ROOMPositionWidth
				
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				
				
			
				d:eobj.ROOMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_WardRoom","User.PACWardRoom","房间分配",id,ROOMRoomDRCode,"A",eobj)
				d:eobj.ROOMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_WardRoom","User.PACWardRoom","房间分配",eobj.ROOMRowId,ROOMRoomDRCode,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间分配","web.DHCBL.CT.PACWardRoom","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：李森
/// CreatDate: 2012-8-29
/// Description：根据ID删除等候区的内容
/// Table：User.PACWardRoom
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
	s result=""
	s eobj = ##class(web.Entity.CT.PACWardRoom).%New()
	s eobj.ROOMRowId = id
	s ROOMParRef=$p(id,"||",1)
	s Id=$p(id,"||",2)
	s eobj.ROOMRoomDR=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",1)
	s ROOMRoomDRCode=""
	s:eobj.ROOMRoomDR'="" ROOMRoomDRCode=$p($g(^PAROOM(eobj.ROOMRoomDR)),"^",1)
	s eobj.ROOMDateFrom=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",7)
	s eobj.ROOMDateTo=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",8)
	s eobj.ROOMPositionLeft=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",2)
	s eobj.ROOMPositionTop=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",3)
	s eobj.ROOMPositionHeight=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",5)
	s eobj.ROOMPositionWidth=$p($g(^PAWARD(ROOMParRef,"ROOM",Id)),"^",4)
	s sc=##class(User.PACWardRoom).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result= "{success:'true',info:'删除成功！'}"	
		
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_WardRoom","User.PACWardRoom","房间分配",id,ROOMRoomDRCode,"D",eobj)
	}
	else 
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("房间分配","web.DHCBL.CT.PACWardRoom","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
