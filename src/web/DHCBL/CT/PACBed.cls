Import SQLUser

/// 名称:科室/病区 - 病区床位	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-5
Class web.DHCBL.CT.PACBed Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：蔡昊哲
/// CreatDate: 2013-8-27
/// Description：根据CTLOCID获取WARDID
/// Table：User.PACBed
ClassMethod GetWARDParRef(id As %String) As %String
{
	s result = $o(^PAWARD(0,"WARD_LocationDR",id,0))
	q result
}

/// Creator：李森
/// CreatDate: 2013-6-03
/// Description：查询病区床位的内容
/// Table：User.PACBed
/// Input：rowid,code,desc
/// D ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBed","GetList","1","","","","")
Query GetList(ParRef As %String, rowid As %String, bedcode As %String, room As %String, bedrcflag As %String) As %Query(ROWSPEC = "BEDRowID,BEDRoomDR,BEDCode,BEDBedTypeDR,BEDRcFlag,BEDPositionLeft,BEDPositionTop,BEDPositionHeight,BEDPositionWidth,BEDDateFrom,BEDDateTo,CTLOCDesc,BEDORGZDesc,BEDSequence")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, rowid As %String, bedcode As %String, room As %String, bedrcflag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录20130603LISEN
	{
		s BEDRowID=rowid
		s ParRef=$p(rowid,"||",1)
		s rowid=$p(rowid,"||",2)
		s BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",3)
		s:BEDRoomDR'="" BEDRoomDR=$p($g(^PAROOM(BEDRoomDR)),"^",2)
		s BEDCode=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",1)
		s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",2)
		s:BEDBedTypeDR'="" BEDBedTypeDR=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",2)
		s BEDRcFlag=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",4)
		s BEDPositionLeft=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",15)
		s BEDPositionTop=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",16)
		s BEDPositionHeight=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",17)
		s BEDPositionWidth=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",18)
		s BEDDateFrom=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",21)
		s BEDDateTo=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",22)
		s BEDSequence=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",24)
		s:BEDDateFrom'="" BEDDateFrom=$zd(BEDDateFrom,1) //转换日期格式
		s:BEDDateTo'="" BEDDateTo=$zd(BEDDateTo,1) //转换日期格式
		
		s EXPLocDR = $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",1)
		s EXPBedOrganizationDR = $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",2)
			
		s:EXPLocDR'="" CTLOCDesc = $p($g(^CTLOC(EXPLocDR)),"^",2) 
		s:EXPLocDR="" CTLOCDesc=""
		s:EXPBedOrganizationDR'="" BEDORGZDesc = $p($g(^PAC("BEDORGZ",EXPBedOrganizationDR)),"^",2)
		s:EXPBedOrganizationDR="" BEDORGZDesc="" 
			
		d OutputRow
	}
	else
	{
		if ParRef'=""
		{
			//按排序输出 lkf 2020年2月20日
			s:bedcode'="" bedcode=$$ALPHAUP^SSUTIL4(bedcode) //转换成大写
			s:room'="" room=$$ALPHAUP^SSUTIL4(room) //转换成大写
			s Sequence=0,flag0=0
			for
			{
				s Sequence=$o(^PAWARD(0,"Sequence",ParRef,Sequence))
				q:flag0=1
				if (Sequence="")	//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
				{
					s flag0=1
					s Sequence=0
				}
				s BEDChildsub=0
				for
				{
					s BEDChildsub=$o(^PAWARD(0,"Sequence",ParRef,Sequence,BEDChildsub))
					q:BEDChildsub=""
					s BEDRowID=ParRef_"||"_BEDChildsub
					s BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",3)
					s:BEDRoomDR'="" BEDRoomDR=$p($g(^PAROOM(BEDRoomDR)),"^",2)
					s BEDCode=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",1)
					s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",2)
					s:BEDBedTypeDR'="" BEDBedTypeDR=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",2)
					s BEDRcFlag=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",4)
					s BEDPositionLeft=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",15)
					s BEDPositionTop=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",16)
					s BEDPositionHeight=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",17)
					s BEDPositionWidth=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",18)
					s BEDDateFrom=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",21)
					s BEDDateTo=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",22)
					s BEDSequence=$p($g(^PAWARD(ParRef,"BED",BEDChildsub)),"^",24)
					s:BEDDateFrom'="" BEDDateFrom=$zd(BEDDateFrom,1) //转换日期格式
					s:BEDDateTo'="" BEDDateTo=$zd(BEDDateTo,1) //转换日期格式
					s EXPLocDR = $p($g(^PAWARDA(ParRef,"BED",BEDChildsub,"EXP",1)),"^",1)
					s EXPBedOrganizationDR = $p($g(^PAWARDA(ParRef,"BED",BEDChildsub,"EXP",1)),"^",2)
					s:EXPLocDR'="" CTLOCDesc = $p($g(^CTLOC(EXPLocDR)),"^",2) 
					s:EXPLocDR="" CTLOCDesc=""
					s:EXPBedOrganizationDR'="" BEDORGZDesc = $p($g(^PAC("BEDORGZ",EXPBedOrganizationDR)),"^",2)
					s:EXPBedOrganizationDR="" BEDORGZDesc="" 
					i ($$ALPHAUP^SSUTIL4(BEDCode)[bedcode)&($$ALPHAUP^SSUTIL4(BEDRoomDR)[room)&((BEDRcFlag=bedrcflag)||(bedrcflag=""))
					{
						d OutputRow
					}
				}
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDRowID,BEDRoomDR,BEDCode,BEDBedTypeDR,BEDRcFlag,BEDPositionLeft,BEDPositionTop,BEDPositionHeight,BEDPositionWidth,BEDDateFrom,BEDDateTo,CTLOCDesc,BEDORGZDesc,BEDSequence)
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

/// Creator：李森
/// CreatDate: 2013-6-3
/// Description：修改时打开的数据
/// Table：User.PACBed
/// Input：id
///  w ##class(web.DHCBL.CT.PACBed).OpenData("5||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.CT.PACBed).%New()
	s eobj.BEDRowID = id
	s ParRef=$p(id,"||",1)
	s rowid=$p(id,"||",2)
	s eobj.BEDWARDParRef=ParRef
	s eobj.BEDCode=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",1)
	s eobj.BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",2)
	s eobj.BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",3)
	s eobj.BEDRcFlag=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",4)
	s eobj.BEDPositionLeft=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",15)
	s eobj.BEDPositionTop=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",16)
	s eobj.BEDPositionHeight=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",17)
	s eobj.BEDPositionWidth=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",18)
	s eobj.BEDDateFrom=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",21)
	s eobj.BEDDateTo=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",22)
	s eobj.BEDSequence=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",24)
	;s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=$zd(eobj.BEDDateFrom,1) //转换日期格式
	;s:eobj.BEDDateTo'="" eobj.BEDDateTo=$zd(eobj.BEDDateTo,1) //转换日期格式
	s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDDateFrom) 
	s:eobj.BEDDateTo'="" eobj.BEDDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.BEDDateTo) 
	s:eobj.BEDRcFlag="Y" eobj.BEDRcFlag="true"
	
	s eobj.EXPLocDR= $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",1)
	s eobj.EXPBedOrganizationDR = $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",2)
	
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：李森
/// CreatDate: 2013-6-3
/// Description：数据重复验证方法
/// Table：User.PACBed
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(ParentRowId As %String, id As %String, code As %String) As %String
{
	s flag=""
	if (id="") //添加时id为空，ParentRowId不为空20130603LISEN
	{
		s cid=0
		for
		{
			s cid=$o(^PAWARD(ParentRowId,"BED",cid))
			q:cid=""
			s BEDCode=$p($g(^PAWARD(ParentRowId,"BED",cid)),"^",1)
			if (BEDCode=code)
			{
				s flag=1  //返回重复标志
				q
			}
			else
			{
				s flag=0 //返回不重复标志
				continue
			}
		}		
	}
	else //修改时ParentRowId为空，id不为空20130603LISEN
	{
		s ParRef=$p(id,"||",1)
		s cid=0
		for
		{
			s cid=$o(^PAWARD(ParRef,"BED",cid)) q:cid=""
			continue:(ParRef_"||"_cid)=id
			s BEDCode=$p($g(^PAWARD(ParRef,"BED",cid)),"^",1)
			if (BEDCode=code)
			{
				s flag=1  //返回重复标志
				q
			}
			else
			{
				s flag=0 //返回不重复标志
				continue
			}
		}
	}
	q flag
}

/// Creator：李森
/// CreatDate: 2013-6-3
/// Updater：2016年5月10日 - 蔡昊哲
/// Description：保存修改床位的内容
/// Table：User.PACBed
/// Input：web.Entity.CT.PACBed 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACBed).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBed) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.BEDRcFlag="" eobj.BEDRcFlag="N"
		;s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=$zdh(eobj.BEDDateFrom,15) //转换日期
		;s:eobj.BEDDateTo'="" eobj.BEDDateTo=$zdh(eobj.BEDDateTo,15)      //转换日期
		s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDDateFrom)
		s:eobj.BEDDateTo'="" eobj.BEDDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDDateTo)     
		s:eobj.BEDDateFrom="" eobj.BEDDateFrom=+$h
		if eobj.BEDRowID'="" s eobj.BEDWARDParRef=$p(eobj.BEDRowID,"||",1)
		if (eobj.BEDRowID'="") && ((eobj.BEDRcFlag'="Y")||(eobj.BEDDateTo'="")) //判断禁用床位时，床位上是否有患者
		{
			s flagAdm=..IfCanDelete(eobj.BEDRowID)
			if (flagAdm=1)
			{
				q "{success:'false',errorinfo:'该床位上有病人，无法修改状态！'}"	
			}
			//2022-11-21
			s flagOccupy=##Class(Nur.Interface.OutSide.Ward).checkBedValid(eobj.BEDRowID)
			if (flagOccupy'="")
			{
				q "{success:'false',errorinfo:'该床位正在被占用，无法停用！'}"	
			}
		}
		/*	2022-07-13	去掉同一个房间只能在一个病区维护的限制
		if (eobj.BEDRoomDR'="") && (eobj.BEDWARDParRef'="") //判断选择房间时，是否被其他病区使用
		{
			s flagroom=..ReflagRoom(eobj.BEDRoomDR,eobj.BEDWARDParRef)
			if ($p(flagroom,"^",1)=1)
			{
				q "{success:'false',errorinfo:'该房间已被"_$p(flagroom,"^",2)_"病区使用！'}"	
			}
		}
		*/
		s flag=..Validate(eobj.BEDWARDParRef,eobj.BEDRowID,eobj.BEDCode)  //调用重复验证20130603LISEN
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.BEDRowID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.PACBed).%New(eobj.BEDWARDParRef)
				
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.PACBed).%OpenId(eobj.BEDRowID)
				s bobj=##class(web.Entity.CT.PACBed).%New(eobj.BEDWARDParRef)
				s bobj.BEDRowID=eobj.BEDRowID
				s bobj.BEDWARDParRef=obj.BEDWARDParRef.%Id()
				s bobj.BEDCode = obj.BEDCode
				s:obj.BEDBedTypeDR'="" bobj.BEDBedTypeDR = obj.BEDBedTypeDR.%Id()

				s:obj.BEDRoomDR'="" bobj.BEDRoomDR = obj.BEDRoomDR.%Id()
				s bobj.BEDRcFlag = obj.BEDRcFlag
				s bobj.BEDPositionLeft = obj.BEDPositionLeft
				s bobj.BEDPositionTop = obj.BEDPositionTop
				s bobj.BEDPositionHeight = obj.BEDPositionHeight
				s bobj.BEDPositionWidth = obj.BEDPositionWidth
				s bobj.BEDDateFrom = obj.BEDDateFrom
				s bobj.BEDDateTo = obj.BEDDateTo
				s bobj.BEDSequence = obj.BEDSequence
				

				//s eobj.BEDRowID = id
				//s ParRef=$p(id,"||",1)
				//s rowid=$p(id,"||",2)
				//s bobj.EXPLocDR= $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",1)
				//s bobj.EXPBedOrganizationDR = $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",2)
				s ParRef=$p(eobj.BEDRowID,"||",1)
				s rowid=$p(eobj.BEDRowID,"||",2)
				s vfalg = $d(^PAWARDA(ParRef,"BED",rowid,"EXP"))
				if (vfalg = 0)  //扩展表是否存在该数据,不存在的情况
				{
				}
				else 
				{
					s BedExprowid = $o(^PAWARDA(ParRef,"BED",rowid,"EXP",0))
					//s ^tmpc1=BedExprowid
					s Expobj=##class(User.PACBedExp).%OpenId(eobj.BEDRowID_"||"_BedExprowid)
					//d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
					s:Expobj.EXPBedOrganizationDR'="" bobj.EXPBedOrganizationDR = Expobj.EXPBedOrganizationDR.%Id()  //.EXPBedOrganization.%Id()
					s:Expobj.EXPLocDR'="" bobj.EXPLocDR = Expobj.EXPLocDR.%Id()	
					//s ^tmpc2=bobj.EXPLocDR
					d Expobj.%Close()
				}
			}
			Ts
			d:eobj.BEDWARDParRef'="" obj.BEDWARDParRefSetObjectId(eobj.BEDWARDParRef)
			s obj.BEDCode = eobj.BEDCode
			d obj.BEDBedTypeDRSetObjectId(eobj.BEDBedTypeDR)
			d obj.BEDRoomDRSetObjectId(eobj.BEDRoomDR)
			s obj.BEDRcFlag = eobj.BEDRcFlag
				
			s obj.BEDPositionLeft = eobj.BEDPositionLeft
			s obj.BEDPositionTop = eobj.BEDPositionTop
			s obj.BEDPositionHeight = eobj.BEDPositionHeight
			s obj.BEDPositionWidth = eobj.BEDPositionWidth
			s obj.BEDSequence = eobj.BEDSequence
			
			s obj.BEDDateFrom = eobj.BEDDateFrom
			s obj.BEDDateTo = eobj.BEDDateTo
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				if (eobj.BEDRowID="")&((eobj.EXPLocDR'="")||(eobj.EXPBedOrganizationDR'=""))  //如果RowId未赋值则增加
				{
					s Expobj=##class(User.PACBedExp).%New(id)
					d Expobj.EXPParRefSetObjectId(id)
					d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
					d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
					s Expsc=Expobj.%Save()	
					d Expobj.%Close()
				}
				elseif (eobj.BEDRowID'="")
				{
					//s BEDRowID=rowid
					s ParRef=$p(eobj.BEDRowID,"||",1)
					s rowid=$p(eobj.BEDRowID,"||",2)
					s vfalg = $d(^PAWARDA(ParRef,"BED",rowid,"EXP"))
					if (vfalg = 0)  //扩展表是否存在该数据,不存在的情况
					{
						s Expobj=##class(User.PACBedExp).%New(eobj.BEDRowID)
						d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
						d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
						d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
						s Expsc=Expobj.%Save()	
						d Expobj.%Close()
					}
					else 
					{
						s BedExprowid = $o(^PAWARDA(ParRef,"BED",rowid,"EXP",0))
						s Expobj=##class(User.PACBedExp).%OpenId(eobj.BEDRowID_"||"_BedExprowid)
						//d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
						d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
						d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
						s Expsc=Expobj.%Save()	
						d Expobj.%Close()
					}				
	
				}
				
				
				s result= "{success:'true',id:'"_id_"'}"         //返回RowId
				d:eobj.BEDRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",eobj.BEDRowID,eobj.BEDCode,"U",eobj,bobj)
				d:eobj.BEDRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",id,eobj.BEDCode,"A",eobj)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
			}
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze 
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：李森
/// CreatDate: 2013-6-3
/// Description：根据ID删除床位的内容
/// Table：User.PACBed
/// Input：w ##class(web.DHCBL.CT.PACBed).test("1")
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod test(id) As %String
{
	s result=""
	s Expobj=##class(User.PACBedExp).%OpenId(id)
	//d Expobj.EXPParRefSetObjectId(id)
	d Expobj.EXPLocDRSetObjectId("5")
	d Expobj.EXPBedOrganizationDRSetObjectId("6")
	s Expsc=Expobj.%Save()	

	d Expobj.%Close()
	If $$$ISOK(Expsc)
	{
	}
	else
	{
		s result= "{success:'false',errorinfo:'"_$zconvert(Expsc,"O","JS")_"'}"    //返回错误信息
	}
	q result
}

/// Creator：李森
/// CreatDate: 2013-6-3
/// Description：根据ID删除床位的内容
/// Table：User.PACBed
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s Refresult=..GetRefFlag(id)
	if ($p(Refresult,"^",1)=1)		//判断是否被其他表引用	20200428	lkf
	{
		q "{success:'false',info:'"_$p(Refresult,"^",2)_"'}"	
	}
	
	s flagAdm=..IfCanDelete(id)
	if (flagAdm=1)
	{
		q "{success:'false',info:'该床位上有病人！无法删除！'}"	
	}
	
	s eobj = ##class(web.Entity.CT.PACBed).%New()
	s eobj.BEDRowID = id
	s ParRef=$p(id,"||",1)
	s rowid=$p(id,"||",2)
	s eobj.BEDCode=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",1)
	s eobj.BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",2)
	s eobj.BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",3)
	s eobj.BEDRcFlag=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",4)
	s eobj.BEDPositionLeft=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",15)
	s eobj.BEDPositionTop=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",16)
	s eobj.BEDPositionHeight=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",17)
	s eobj.BEDPositionWidth=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",18)
	s eobj.BEDDateFrom=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",21)
	s eobj.BEDDateTo=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",22)
	s eobj.BEDSequence=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",24)
	s sc=##class(User.PACBed).%DeleteId(id)
	if $$$ISOK(sc)
	{
		s result= "{success:'true',info:'删除成功！'}"	
		d:eobj.BEDRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",id,eobj.BEDCode,"D",eobj)
	}
	else 
	{
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：chenying
/// CreatDate: 2013-9-3
/// Description:  根据ctloc获取病区床位信息
/// Table：       PACBed
/// Input：       ctloc
/// Return：      返回床位要转换的panel信息，按照<$C1>分隔行，用^分隔字段 
/// 1 BEDRowID , 2 BEDRoomDR->Desc_"->"_BEDCode,  3 BEDRcFlag 
/// 4 BEDPositionLeft, 5 BEDPositionTop ,6 BEDPositionHeight ,7 BEDPositionWidth
/// w ##class(web.DHCBL.CT.PACBed).GetPACBedPanelInfo("22")
ClassMethod GetPACBedPanelInfo(ctloc) As %String
{
	s BEDParRef = $o(^PAWARD(0,"WARD_LocationDR",ctloc,0))
	k ^CacheTemp("PAC_Bed","floor")
	s bedchildsub=0,ret=""
	for
	{
		s bedchildsub=$o(^PAWARD(BEDParRef,"BED",bedchildsub)) q:bedchildsub=""
		s BEDRowID=BEDParRef_"||"_bedchildsub
		s BEDRoomDR=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",3)
		s:BEDRoomDR'="" BEDRoomDR=$p($g(^PAROOM(BEDRoomDR)),"^",2) //Desc
		s BEDCode=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",1)
		s BEDRcFlag=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",4)
		s BEDPositionLeft=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",15)
		s BEDPositionTop=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",16)
		s BEDPositionHeight=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",17)
		s BEDPositionWidth=$p($g(^PAWARD(BEDParRef,"BED",bedchildsub)),"^",18)
		s ^CacheTemp("PAC_Bed","floor",BEDRowID)=BEDRowID_"^"_BEDRoomDR_"->"_BEDCode_"^"_BEDRcFlag_"^"_BEDPositionLeft_"^"_BEDPositionTop_"^"_BEDPositionHeight_"^"_BEDPositionWidth
		s ret=ret_^CacheTemp("PAC_Bed","floor",BEDRowID)_"<$C1>" 
	}
	q ret
}

/// Creator：chenying
/// CreatDate: 2013-9-3 update2020-01-19
/// Description: 
/// Table：       PACBed，PACWardRoom   //BEDYGap行间距,BEDXGap列间距
/// Input：       ctloc
/// Return：      返回床位要转换的panel信息，按照<$C1>分隔行，用^分隔字段 
/// "52","高度160","宽度80","初始X20","初始Y10","每行个数1","左右间距5","上下间距15")
/// w ##class(web.DHCBL.CT.PACBed).QuickSetPACBedFloorInfo("52","160","80","20","10","1","5","15")
ClassMethod QuickSetPACBedFloorInfo(BEDWARDParRef, BEDHeight, BEDWidth, BEDX, BEDY, BEDNumber, BEDXGap, BEDYGap) As %String
{
	s:BEDX="" BEDX=5
	s:BEDY="" BEDY=5
	s:BEDNumber="" BEDNumber=5
	s:BEDYGap="" BEDYGap=5
	s:BEDXGap="" BEDXGap=5
	s WaitingRoomWidth=BEDWidth		
	k ^CacheTemp("PAC_Bed","QuickSetfloor")
	s ^CacheTemp("PAC_Bed","QuickSetfloor")=BEDWARDParRef_"^"_BEDHeight_"^"_BEDWidth_"^"_BEDX_"^"_BEDY_"^"_BEDNumber_"^"_BEDXGap_"^"_BEDYGap
	
	/*
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	k ^TMPSORT("QuickSetPACBed",mySysID,BEDWARDParRef)
	s bedchildsub=0
	for
	{
		s bedchildsub=$o(^PAWARD(BEDWARDParRef,"BED",bedchildsub)) q:bedchildsub=""
		s BEDRcFlag=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",4)
		if BEDHeight="" s BEDHeight=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",17)
		if BEDWidth="" s BEDWidth=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",18)
		if BEDRcFlag="Y"       //看有多少个激活的床位
		{
			s BEDSequence=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",24)
			///先根据序号排序，然后生成坐标
			s:BEDSequence="" BEDSequence=" "
			s ^TMPSORT("QuickSetPACBed",mySysID,BEDWARDParRef,BEDSequence,bedchildsub)=""
		}
	}
	
	if BEDHeight="" s BEDHeight=120
	if BEDWidth="" s BEDWidth=160
	s WaitingRoomPositionX=0,WaitingRoomPositionY=BEDY,WaitingRoomHeight=0,WaitingRoomWidth=BEDWidth
	s int=0,ret="",result=""
	
	//按排序输出
	s Sort=0
	for
	{
		s Sort=$o(^TMPSORT("QuickSetPACBed",mySysID,BEDWARDParRef,Sort)) q:Sort=""
		s bedchildsub=0
		for
		{
			s bedchildsub=$o(^TMPSORT("QuickSetPACBed",mySysID,BEDWARDParRef,Sort,bedchildsub))  q:bedchildsub=""
			s BEDRowID=BEDWARDParRef_"||"_bedchildsub
			s int=int+1,BEDRowID=BEDWARDParRef_"||"_bedchildsub
			///, ret=ret_BEDRowID_"<$C1>"
			
			s chu=int\BEDNumber //  整除
			s yu=int#BEDNumber // 余数
			if (yu=0){
				//y坐标
				s BEDPositionTop=((BEDHeight+BEDYGap)*(chu-1))+BEDY
				//x坐标
				s BEDPositionLeft=((BEDWidth+BEDXGap)*(BEDNumber-1))+BEDX
			}
			if (yu>0) {
				//y坐标
				s BEDPositionTop=((BEDHeight+BEDYGap)*chu)+BEDY
			 	//x坐标
				s BEDPositionLeft=((BEDWidth+BEDXGap)*(yu-1))+BEDX
			}
			//s bedrowid=$p(ret,"<$C1>",j)
			//s BEDParRef=$p(bedrowid,"||",1),bedchildsub=$p(bedrowid,"||",2)
			s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",15)=BEDPositionLeft
			s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",16)=BEDPositionTop
			s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",17)=BEDHeight
			s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",18)=BEDWidth
			if Sort>0
			{
				s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",24)=Sort
			}
			else
			{
				s $p(^PAWARD(BEDWARDParRef,"BED",bedchildsub),"^",24)=int
			}
		}
	}
	k ^TMPSORT("QuickSetPACBed",mySysID)
	*/
	
	/*******************************lkf**20200220**排序改用索引********************************/
	s WaitingRoomPositionX=0,WaitingRoomPositionY=BEDY,WaitingRoomHeight=0
	s int=0,ret="",result=""
	//按排序输出
	s Sequence=0,flag0=0
	for
	{
		s Sequence=$o(^PAWARD(0,"Sequence",BEDWARDParRef,Sequence))
		q:flag0=1
		if (Sequence="")		//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
		{
			s flag0=1
			s Sequence=0
		}
		s bedchildsub=0
		for
		{
			s bedchildsub=$o(^PAWARD(0,"Sequence",BEDWARDParRef,Sequence,bedchildsub))
			q:bedchildsub=""
			
			s BEDRcFlag=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",4)
			if BEDHeight="" s BEDHeight=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",17)
			if BEDWidth="" s BEDWidth=$p($g(^PAWARD(BEDWARDParRef,"BED",bedchildsub)),"^",18)
			if BEDRcFlag="Y"       //看有多少个激活的床位
			{
				if BEDHeight="" s BEDHeight=120
				if BEDWidth="" s BEDWidth=160
				s WaitingRoomWidth=BEDWidth
				s WaitingRoomHeight=BEDHeight
				s BEDRowID=BEDWARDParRef_"||"_bedchildsub
				s int=int+1,BEDRowID=BEDWARDParRef_"||"_bedchildsub
				///, ret=ret_BEDRowID_"<$C1>"
				
				s chu=int\BEDNumber //  整除
				s yu=int#BEDNumber // 余数
				if (yu=0){
					//y坐标
					s BEDPositionTop=((BEDHeight+BEDYGap)*(chu-1))+BEDY
					//x坐标
					s BEDPositionLeft=((BEDWidth+BEDXGap)*(BEDNumber-1))+BEDX
				}
				if (yu>0) {
					//y坐标
					s BEDPositionTop=((BEDHeight+BEDYGap)*chu)+BEDY
				 	//x坐标
					s BEDPositionLeft=((BEDWidth+BEDXGap)*(yu-1))+BEDX
				}
				//s bedrowid=$p(ret,"<$C1>",j)
				//s BEDParRef=$p(bedrowid,"||",1),bedchildsub=$p(bedrowid,"||",2)
				s BEDRowID=BEDWARDParRef_"||"_bedchildsub
				s obj=##class(User.PACBed).%OpenId(BEDRowID)
				s obj.BEDPositionLeft = BEDPositionLeft
				s obj.BEDPositionTop = BEDPositionTop
				s obj.BEDPositionHeight = BEDHeight
				s obj.BEDPositionWidth = BEDWidth
				if Sequence>0
				{
					s obj.BEDSequence = Sequence
				}
				else
				{
					s obj.BEDSequence = int
				}
				s sc=obj.%Save()
				d obj.%Close()
				
			}
		}
	}
	/*************************************lkf**20200220*****************************************/
	
	//等候区高度
	s jchu=int\BEDNumber ///除法 取整
	s jyu=int#BEDNumber  ///取余数
	if (jyu=0){ s WaitingRoomHeight=((BEDHeight+BEDYGap)*(jchu-1))+BEDHeight}
	else{  s WaitingRoomHeight=((BEDHeight+BEDYGap)*jchu)+BEDHeight}
	//20为等候区与床位的间距，可根据不同的医院要求修改 ->BEDXGap
	s WaitingRoomPositionX=((BEDWidth+BEDXGap)*(BEDNumber-1))+BEDX+BEDWidth+BEDXGap
		
	
	//设置等候区坐标，注:暂时 默认只有一个等候区 
	s roomchildsub=0 
	s roomchildsub=$o(^PAWARD(BEDWARDParRef,"ROOM",roomchildsub))
	if (roomchildsub) {
		s $p(^PAWARD(BEDWARDParRef,"ROOM",roomchildsub),"^",2)=WaitingRoomPositionX
		s $p(^PAWARD(BEDWARDParRef,"ROOM",roomchildsub),"^",3)=WaitingRoomPositionY
		s $p(^PAWARD(BEDWARDParRef,"ROOM",roomchildsub),"^",5)=WaitingRoomHeight
		s $p(^PAWARD(BEDWARDParRef,"ROOM",roomchildsub),"^",4)=WaitingRoomWidth
		s ^CacheTemp("PAC_Bed","QuickSetfloor","ROOM")=WaitingRoomPositionX_"^"_WaitingRoomPositionY_"^"_WaitingRoomHeight_"^"_WaitingRoomWidth
	}
	s result= "{success:'true',info:'一键设置床位图成功！'}"	
	q result
}

/// Creator：chenying
/// CreatDate: 2013-9-3
/// Description: 
/// Table： PACBed，PACWardRoom
/// Input： PanelInfo("PACBed^52||8"),NewPanelX, NewPanelY
/// 		PanelInfo("PACWardRoom^7||1"),NewPanelX, NewPanelY
/// Return：     1
/// w ##class(web.DHCBL.CT.PACBed).UpdatePanelPositionByDrag("PACBed^52||8","130","129")
ClassMethod UpdatePanelPositionByDrag(PanelInfo, NewPanelX, NewPanelY) As %String
{
	s ^CacheTemp("PAC_Bed","position")=PanelInfo_"^"_NewPanelX_"^"_NewPanelY
	//判断是床位还是房间
	s PanelStyle=$p(PanelInfo,"^",1)
	if (PanelStyle="PACBed"){ //床位
		s BEDRowID=$p(PanelInfo,"^",2)
		s parref=$p(BEDRowID,"||",1),childsub=$p(BEDRowID,"||",2)
		s $p(^PAWARD(parref,"BED",childsub),"^",15)=NewPanelX
		s $p(^PAWARD(parref,"BED",childsub),"^",16)=NewPanelY
		//s $p(^PAWARD(parref,"BED",childsub),"^",17)=BEDHeight
		//s $p(^PAWARD(parref,"BED",childsub),"^",18)=BEDWidth  //panel如果做拖动大小	
	}
	if (PanelStyle="PACWardRoom"){ //房间分配
		s ROOMRowId=$p(PanelInfo,"^",2)
		s ROOMparref=$p(ROOMRowId,"||",1),ROOMchildsub=$p(ROOMRowId,"||",2)
		s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",2)=NewPanelX
		s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",3)=NewPanelY
		//s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",5)=BEDHeight
		//s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",4)=BEDWidth  //panel如果做拖动大小	
	}
	q 1
}

/// 保存床位宽高
/// 2013-11-05 by lisen
ClassMethod UpdatePanelSizeByDrag(PanelInfo As %String, NewPanelW As %String, NewPanelH As %String) As %String
{
	//判断是床位还是房间
	s PanelStyle=$p(PanelInfo,"^",1)
	if (PanelStyle="PACBed"){ //床位
		s BEDRowID=$p(PanelInfo,"^",2)
		s parref=$p(BEDRowID,"||",1),childsub=$p(BEDRowID,"||",2)
		s $p(^PAWARD(parref,"BED",childsub),"^",17)=NewPanelH
		s $p(^PAWARD(parref,"BED",childsub),"^",18)=NewPanelW  //panel如果做拖动大小	
	}
	if (PanelStyle="PACWardRoom"){ //房间分配
		s ROOMRowId=$p(PanelInfo,"^",2)
		s ROOMparref=$p(ROOMRowId,"||",1),ROOMchildsub=$p(ROOMRowId,"||",2)
		s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",5)=NewPanelH
		s $p(^PAWARD(ROOMparref,"ROOM",ROOMchildsub),"^",4)=NewPanelW  //panel如果做拖动大小	
	}
	q 1
}

/// 批量修改床位类型
/// 2014-3-5 by lisen
ClassMethod batchUpBedType(str As %String) As %String
{
	s result=""
	s BedType = $p(str,"#",1)
	s BedIds = $p(str,"#",2)
	for i=1:1:$length(BedIds,"^")-1 {
		s id=""
		s id=$p(BedIds,"^",i)
		Ts
		s obj=##class(User.PACBed).%OpenId(id)
		d obj.BEDBedTypeDRSetObjectId(BedType)
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s result= "{success:'true',info:'删除成功！'}"
			//保存日志
			s eobj = ##class(web.Entity.CT.PACBed).%New()
			s eobj.BEDRowID = id
			s ParRef=$p(id,"||",1)
			s rowid=$p(id,"||",2)
			s eobj.BEDCode=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",1)
			s eobj.BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",2)
			s eobj.BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",3)
			s eobj.BEDRcFlag=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",4)
			s eobj.BEDPositionLeft=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",15)
			s eobj.BEDPositionTop=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",16)
			s eobj.BEDPositionHeight=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",17)
			s eobj.BEDPositionWidth=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",18)
			s eobj.BEDDateFrom=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",21)
			s eobj.BEDDateTo=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",22)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",id,eobj.BEDCode,"U",eobj)
			d eobj.%Close()
		}
		else
		{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","batchUpBedType",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}
	}
	
	q result
}

/// 批量添加床位
/// 2014-03-07 by lisen
/// w ##class(web.DHCBL.CT.PACBed).batchAddBed("1^3^386^true^2020-01-17^^30^5^160^120^5^5^5^5")
ClassMethod batchAddBed(str As %String) As %String
{
	s result=""
	s ParentId=$p(str,"^",1) 	//床位父表id
	s BEDTypeDR=$p(str,"^",2) 	//床位类型
	s BEDRoomDR=$p(str,"^",3) 	//房间
	s BEDRcFlag=$p(str,"^",4) 	//是否激活
	s BEDDateFrom=$p(str,"^",5) //开始日期
	s BEDDateTo=$p(str,"^",6) 	//结束日期
	s BEDCount=$p(str,"^",7) 	//添加床位个数
	s BEDNumber=$p(str,"^",8) 	//每行床位个数
	s BEDWidth=$p(str,"^",9) 	//床宽
	s BEDHeight=$p(str,"^",10) 	//床高
	s BEDX=$p(str,"^",11) 		//起始坐标X
	s BEDY=$p(str,"^",12) 		//起始坐标Y
	s BEDYGap=$p(str,"^",13) 	//行间距
	s BEDXGap=$p(str,"^",14) 	//列间距
	s BEDDigits=$p(str,"^",15)	//床代码位数
	s BEDSuffix=$p(str,"^",16)	//床代码后缀
	
	if (BEDRcFlag="true"){
		s BEDRcFlag="Y"
	}else{
		s BEDRcFlag=""
	}
	;s:BEDDateFrom'="" BEDDateFrom=$zdh(BEDDateFrom,15) //转换日期
	;s:BEDDateTo'="" BEDDateTo=$zdh(BEDDateTo,15)      //转换日期
	
	for i=1:1:BEDCount
	{
		s eobj=##class(web.Entity.CT.PACBed).%New()
		s eobj.BEDWARDParRef=ParentId
		s eobj.BEDRowID=""
		s BEDCode=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(i,BEDDigits)_BEDSuffix		//床代码补零，并拼上后缀
		s eobj.BEDCode=BEDCode
		s eobj.BEDBedTypeDR=BEDTypeDR
		
		s chu=i\BEDNumber 	//整除
		s yu=i#BEDNumber 	//余数
		if (yu=0) {
			s eobj.BEDPositionTop=((BEDHeight+BEDYGap)*(chu-1))+BEDY
			s eobj.BEDPositionLeft=((BEDWidth+BEDXGap)*(BEDNumber-1))+BEDX
		}
		if (yu>0) {
			s eobj.BEDPositionTop=((BEDHeight+BEDYGap)*chu)+BEDY
			s eobj.BEDPositionLeft=((BEDWidth+BEDXGap)*(yu-1))+BEDX
		}
		
		s eobj.BEDPositionHeight=BEDHeight
		s eobj.BEDPositionWidth=BEDWidth
		s eobj.BEDRoomDR=BEDRoomDR
		s eobj.BEDRcFlag=BEDRcFlag
		s eobj.BEDDateFrom=BEDDateFrom
		s eobj.BEDDateTo=BEDDateTo
		s eobj.BEDSequence=i
		s result=..SaveEntity(eobj)
		d eobj.%Close()
	}
	
	q result
}

/// 批量添加时，判断库里是否有数据，如果有禁止批量添加
/// yes:可以添加   no:不可以添加
/// w ##class(web.DHCBL.CT.PACBed).IfBedExist("70")
/// 2014-03-10 by lisen
ClassMethod IfBedExist(ParentId As %String) As %String
{
	q:ParentId="" ""
	s result="",count=0
	
	s ChildID=0
	for {
		s ChildID=$o(^PAWARD(ParentId,"BED",ChildID))
		q:ChildID=""
		q:count=1
		if ($d(^PAWARD(ParentId,"BED",ChildID))=1) {
			s count=count+1
		}
	}
	
	if (count=0) {
		s result="yes"
	}else {
		s result="no"
	}
	q result
}

/// Creator: caihz
/// CreatDate: 2015-03-26
/// Description: 判断床位是否能被删除、禁用。
/// Table：PAC_BedAdm ,  PAC_BedStatusChange
/// Input：bedId: 床位表ID
/// Return：输出ret   0 可以  1 不能被删除
/// w ##class(web.DHCADTTransaction).IfCanDelete("23||4")
/// 
ClassMethod IfCanDelete(bedId) As %String
{
	q:bedId="" 0
	s wardId=+bedId
	s bedSub=$p(bedId,"||",2)
	s nowDateTime=+$h*100000+$p($h,",",2)
	s ret=0
	s statSub="" f  s statSub=$O(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub),-1) q:(statSub="")!(ret=1)  d
	.s statDateTo=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub)),"^",5)
	.s statTimeTo=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub)),"^",6)
	.s statDateTimeTo=statDateTo*100000+statTimeTo
	.s statDateFrom=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub)),"^",1)
	.s statTimeFrom=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub)),"^",2)
	.s statDateTimeFrom=statDateFrom*100000+statTimeFrom
	.q:nowDateTime<statDateTimeFrom
	.q:(statDateTimeTo'=0)&(nowDateTime>statDateTimeTo)
	.s statusId=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",statSub)),"^",7)
	.i statusId'="" s statusDesc=$p($g(^PAC("RNAV",statusId)),"^",2)
	.e  s statusDesc=""
	.q:statusDesc'["包床"
	.s ret=1  //包床
	q:ret=1 ret
	s admSub=$o(^PAWARDA(wardId,"BED",bedSub,"ADM",0))
	s:admSub'="" ret=1  //占床
	q ret
}

/// w ##class(web.DHCBL.CT.PACBed).ReflagRoom(53,91)
ClassMethod ReflagRoom(id, wdid) As %String
{
	s flag=0,rs=0,WARDRowID=0
	f
	{
		s WARDRowID=$o(^PAWARD(WARDRowID)) 
		q:WARDRowID=""
		s bed=0
		f
		{
			s bed=$o(^PAWARD(WARDRowID,"BED",bed))
			q:bed=""
			s room=^PAWARD(WARDRowID,"BED",bed)
			s warddesc=$p($g(^PAWARD(WARDRowID)),"^",2)
			s roomid=$p($g(room),"^",3)
			i (roomid=id)&&(roomid'="")&&(wdid'=WARDRowID) s flag=1 q
		}
		;b
		i (flag=1)
		{
			s rs=1_"^"_warddesc
			q
		}
	}
	q rs
}

/// 描述：批量设置床位序号
/// 编写人：基础数据平台-李可凡
/// 编写日期：2020年4月14日
/// Debug：w ##class(web.DHCBL.CT.PACBed).AutoSetBedSequence()
ClassMethod AutoSetBedSequence() As %String
{
	s total=0
	s BEDWARDParRef=0
	for
	{
		s BEDWARDParRef=$o(^PAWARD(BEDWARDParRef)) q:BEDWARDParRef=""
		s BEDSequence=0
		s BEDChildsub=0
		for
		{
			s BEDChildsub=$o(^PAWARD(BEDWARDParRef,"BED",BEDChildsub)) q:BEDChildsub=""
			s total=total+1
			s BEDRowID=BEDWARDParRef_"||"_BEDChildsub
			s obj=##class(User.PACBed).%OpenId(BEDRowID)
			s BEDSequence=BEDSequence+1
			s obj.BEDSequence=BEDSequence	//如果要清空序号就在这里赋值为""
			s sc=obj.%Save()
			d obj.%Close()
		}
		if (BEDSequence'=0)
		{
			w "BEDWARDParRef:"_BEDWARDParRef_",total:"_BEDSequence
			w !
		}
	}
	q "over,total:"_total
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年4月28日
/// function：删除时判断该床位在表PA_AdmTransaction是否已被引用
/// Input：床位表RowId
/// Output: flag^reason		flag:0 未被引用可删除	1 被引用，无法删除
/// Debug：w ##class(web.DHCBL.CT.PACBed).GetRefFlag("6||2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s result=""
	s RefFlag=$d(^PAADMi("TransBed",id))
	if (RefFlag=0)
	{
		s result="0^未被引用可删除！"
	}
	else
	{
		s result="1^该床位在 PA_AdmTransaction 表中被引用，无法删除！"
	}
	q result
}

/// Creator：李可凡
/// CreatDate: 2020年6月2日
/// Description：根据床位id保存激活标识
/// Table：User.PACBed
/// w ##class(web.DHCBL.CT.PACBed).SaveBedActiveFlag("1||5","N")
ClassMethod SaveBedActiveFlag(id As %String, rcflag As %String) As %String
{
	s result=""
	q:'((rcflag="Y")||(rcflag="N")) "-1^激活标识只能是Y/N"
	q:(id="") "-1^床位id不能为空"
	if ((id'="")&&(rcflag'="Y")) //判断禁用床位时，床位上是否有患者
	{
		s flagAdm=..IfCanDelete(id)
		if (flagAdm=1)
		{
			q "{success:'false',errorinfo:'该床位上有病人，无法修改状态！'}"	
		}
	}
	s obj=##class(User.PACBed).%OpenId(id)
	if (obj)
	{
		s obj.BEDRcFlag=rcflag
		TS
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			TC
			s result="0^保存成功"
		}
		else
		{
			TRO
			s result="-1^保存失败！"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result="-1^床位不存在"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月1日
/// Description：批量修改床位激活标识
/// Table：User.PACBed
/// Input：idstr("BEDRowID^BEDRowID^...")
///  w ##class(web.DHCBL.CT.PACBed).BatchUpdateActiveFlag("1||1^1||2^1||3","Y")
ClassMethod BatchUpdateActiveFlag(idstr As %String, flag As %String) As %String
{
	q:idstr="" ""
	s ret=1
    for i=1:1:$l(idstr,"^")
	{
		s BEDRowID=$p(idstr,"^",i)
    	if (BEDRowID)
    	{
	    	if ((BEDRowID'="")&&(flag'="Y")) //判断禁用床位时，床位上是否有患者
			{
				s flagAdm=..IfCanDelete(BEDRowID)
				if (flagAdm=1)
				{
					s ret=0	
					continue
				}
			}
	    	s obj=##class(User.PACBed).%OpenId(BEDRowID)
	    	s obj.BEDRcFlag=flag
	    	s sc=obj.%Save()
	    }
	}
	q ret
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月27日
/// Description：批量修改床位的房间号
/// w ##class(web.DHCBL.CT.PACBed).BatchUpdateRoom("76||1^76||2^76||3","1")
ClassMethod BatchUpdateRoom(idstr As %String, roomdr As %String) As %String
{
	q:idstr="" ""
	s re=""
    for i=1:1:$l(idstr,"^")
	{
		s BEDRowID=$p(idstr,"^",i)
		s BEDWARDParRef=$p(BEDRowID,"||",1)
		if (roomdr'="") && (BEDWARDParRef'="") //判断选择房间时，是否被其他病区使用
		{
			s flagroom=..ReflagRoom(roomdr,BEDWARDParRef)
			b ;1
			if ($p(flagroom,"^",1)=1)
			{
				s re="该房间已被‘"_$p(flagroom,"^",2)_"’病区使用！"	
				q
			}
		}
	}
	q:re'="" re
	//所有床位校验通过才保存
	for i=1:1:$l(idstr,"^")
	{
		s BEDRowID=$p(idstr,"^",i)
    	if (BEDRowID)
    	{
	    	s obj=##class(User.PACBed).%OpenId(BEDRowID)
			d obj.BEDRoomDRSetObjectId(roomdr)
	    	s sc=obj.%Save()
	    	d obj.%Close()
	    }
	}
	q "1"
}

/// Description: 根据科室id，获取病区床位信息，按序号排序输出
/// Creator：likefan 2021-01-25
/// Table：PAC_Bed
/// Input：科室rowid
/// Return：返回按序号排序的床位床位信息信息，按照<$C1>分隔行，用^分隔字段
/// w ##class(web.DHCBL.CT.PACBed).GetPACBedInfoAsSeq("376")
ClassMethod GetPACBedInfoAsSeq(ctloc) As %String
{
	s BEDParRef=$o(^PAWARD(0,"WARD_LocationDR",ctloc,0))
	q:BEDParRef="" ""
	s result=""
	s Sequence=0,flag0=0
	for
	{
		s Sequence=$o(^PAWARD(0,"Sequence",BEDParRef,Sequence)) q:flag0=1
		//先查询有序号的数据(0节点之后)，再查询没有序号(0节点)的数据
		if (Sequence="")
		{
			s flag0=1
			s Sequence=0
		}
		s BEDChildsub=0
		for
		{
			s BEDChildsub=$o(^PAWARD(0,"Sequence",BEDParRef,Sequence,BEDChildsub)) q:BEDChildsub=""
			s BEDRowID=BEDParRef_"||"_BEDChildsub
			s BEDRoomDR=$p($g(^PAWARD(BEDParRef,"BED",BEDChildsub)),"^",3)	//房间DR
			s:BEDRoomDR'="" BEDRoomDR=$p($g(^PAROOM(BEDRoomDR)),"^",2)		//房间描述
			s BEDCode=$p($g(^PAWARD(BEDParRef,"BED",BEDChildsub)),"^",1)	//床代码
			s BEDBedTypeDR=$p($g(^PAWARD(BEDParRef,"BED",BEDChildsub)),"^",2)	//床类型
			s:BEDBedTypeDR'="" BEDBedTypeDR=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",2)	//床类型描述
			s BEDRcFlag=$p($g(^PAWARD(BEDParRef,"BED",BEDChildsub)),"^",4)	//是否激活
			s:result'="" result=result_"<$C1>"
			//s result=result_BEDRowID_"^"_BEDRoomDR_"->"_BEDCode_"^"_BEDRcFlag
			s result=result_BEDRowID_"^"_BEDCode_"<br/>"_BEDRoomDR_"<br/>"_BEDBedTypeDR_"^"_BEDRcFlag
		}
	}
	q result
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2021-04-07
/// Description：批量删除床位
/// Table：User.PACBed
/// Input：idstr("BEDRowID^BEDRowID^...")
/// Output: 0:都失败	1:都成功	2:有成功有失败
/// w ##class(web.DHCBL.CT.PACBed).batchDelete("76||4^76||5")
ClassMethod batchDelete(idstr As %String) As %String
{
	//s ^templkf(1)=idstr
	q:idstr="" ""
	s resultFlag=0
	s successFlag=0
	s errorFlag=0
    for i=1:1:$l(idstr,"^")
	{
		s BEDRowID=$p(idstr,"^",i)
    	if (BEDRowID'="")
    	{
	    	s re=..DeleteData(BEDRowID)
	    	s:(re["success:'true'") successFlag=1	//有成功的
	    	s:(re["success:'false'") errorFlag=1	//有失败的
	    }
	}
	if (successFlag=1)
	{
		s resultFlag=1	//都成功
		s:(errorFlag=1) resultFlag=2	//有成功有失败
	}
	q resultFlag
}

}
