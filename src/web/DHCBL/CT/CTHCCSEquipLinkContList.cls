/// 名称:医呼通设备和个人通讯录关联表
/// 描述:
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-22
Class web.DHCBL.CT.CTHCCSEquipLinkContList Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-12-22
/// Description：设备字典界面-查询医呼通设备和个人通讯录关联表
/// User.CTHCCSEquipLinkContList
/// Input：rowid,equipmentDR,userid,locid
/// Output: ELCLRowId,ELCLUser,ELCLLoc,HCCSCLVOIPNumber,ELCLDateFrom,ELCLDateTo
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipLinkContList","GetList","","","","")
Query GetList(rowid As %String, equipmentDR As %String, userid As %String, locid As %String) As %Query(ROWSPEC = "ELCLRowId:%String,ELCLUser:%String,ELCLLoc:%String,HCCSCLVOIPNumber:%String,ELCLDateFrom:%String,ELCLDateTo:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, equipmentDR As %String, userid As %String, locid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s (SSUSRRowId,SSUSRName,ELCLLoc,CTLOCRowID,CTLOCDesc)=""
		s ELCLRowId = rowid
		s ELCLEquipmentDR= $p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//设备-指针
		s ELCLContactListDR= $p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)		//个人通讯录-指针
		s:ELCLContactListDR'="" ELCLUser=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",1)     //用户代码
		s:ELCLUser'="" SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ELCLUser),0))
		s:SSUSRRowId'="" SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
		s ELCLUser=ELCLUser_"-"_SSUSRName //用户代码-用户名
		s:ELCLContactListDR'="" ELCLLoc= $p($g(^CT("HCCSCL",ELCLContactListDR)),"^",2)		//科室代码
		s:ELCLLoc'="" CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ELCLLoc),0))
		s:CTLOCRowID'="" CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		s ELCLLoc=ELCLLoc_"-"_CTLOCDesc //科室代码-科室名
		s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",ELCLContactListDR)),"^",3)   //VOIP号码
		s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)  //关联开始日期
		s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom) //转换日期格式
		s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)   //关联结束日期
		s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo) //转换日期格式
		
		d OutputRow
	}
	else
	{
		s ELCLRowId=0
		for 
		{
			s ELCLRowId=$o(^CT("HCCSELCL",ELCLRowId)) q:ELCLRowId=""
			s (SSUSRRowId,SSUSRName,ELCLLoc,CTLOCRowID,CTLOCDesc)=""
			s ELCLEquipmentDR= $p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//设备-指针
			continue:(ELCLEquipmentDR'=equipmentDR)&&(equipmentDR'="")
			s ELCLContactListDR= $p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)		//个人通讯录-指针
			s ELCLUser=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",1)     //用户代码
			continue:(ELCLUser'=userid)&&(userid'="")
			s:ELCLUser'="" SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ELCLUser),0))
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s ELCLUser=ELCLUser_"-"_SSUSRName //用户代码-用户名
			s ELCLLoc= $p($g(^CT("HCCSCL",ELCLContactListDR)),"^",2)		//科室代码
			continue:(ELCLLoc'=locid)&&(locid'="")
			s:ELCLLoc'="" CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ELCLLoc),0))
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
			s ELCLLoc=ELCLLoc_"-"_CTLOCDesc //科室代码-科室名
			s HCCSCLVOIPNumber = $p($g(^CT("HCCSCL",ELCLContactListDR)),"^",3)   //VOIP号码
			s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)  //关联开始日期
			s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom) //转换日期格式
			s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)   //关联结束日期
			s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo) //转换日期格式

			d OutputRow
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ELCLRowId,ELCLUser,ELCLLoc,HCCSCLVOIPNumber,ELCLDateFrom,ELCLDateTo)
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

/// Creator：杨帆
/// CreatDate: 2020-12-22
/// Description：个人通讯录界面-设备绑定弹窗-查询医呼通设备和个人通讯录关联表
/// User.CTHCCSEquipLinkContList
/// Input：rowid,equipmentid,contactListid,eqcode,eqid
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipLinkContList","GetList2","","1","")
Query GetList2(rowid As %String, equipmentid As %String, contactListid As %String, eqcode As %String, eqid As %String) As %Query(ROWSPEC = "ELCLRowId,ELCLContactListDR,ELCLEquipmentDR,EQId,ELCLDateFrom,ELCLDateTo")
{
}

ClassMethod GetList2Execute(ByRef qHandle As %Binary, rowid As %String, equipmentid As %String, contactListid As %String, eqcode As %String, eqid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:equipmentid'="" equipmentid=$ZCONVERT(equipmentid,"U") //转换成大写
	s:contactListid'="" contactListid=$ZCONVERT(contactListid,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ELCLRowId = rowid
		s ELCLEquipment=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)     //设备-指针
		s ELCLEquipmentDR=$p($g(^CT("HCCSEQ",ELCLEquipment)),"^",1)     //设备代码
		s:ELCLEquipment'="" EQId= $p($g(^CT("HCCSEQ",ELCLEquipment)),"^",2)		//设备ID
		//s ELCLEquipmentDR=EQCode_"-"_EQId
		s ELCLContactListDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)     //个人通讯录-指针
		s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)  //关联开始日期
		s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom) //转换日期格式
		s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)   //关联结束日期
		s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo) //转换日期格式
		
		d OutputRow2
	}
	else
	{
		s:eqcode'="" eqcode=$ZCONVERT(eqcode,"U") //转换成大写
	    s:eqid'="" eqid=$ZCONVERT(eqid,"U") //转换成大写
		s ELCLRowId=0
		for 
		{
			s ELCLRowId=$o(^CT("HCCSELCL",ELCLRowId)) q:ELCLRowId=""
			s ELCLEquipment=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)     //设备-指针
			s ELCLEquipmentDR=$p($g(^CT("HCCSEQ",ELCLEquipment)),"^",1)     //设备代码
			s:ELCLEquipment'="" EQId= $p($g(^CT("HCCSEQ",ELCLEquipment)),"^",2)		//设备ID
			continue:(ELCLEquipment'=equipmentid)&&(equipmentid'="")
			//s ELCLEquipmentDR=EQCode_"-"_EQId
			s ELCLContactListDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)     //个人通讯录-指针
			continue:(ELCLContactListDR'=contactListid)&&(contactListid'="")
			s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)  //关联开始日期
			s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom) //转换日期格式
			s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)   //关联结束日期
			s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo) //转换日期格式
			if ($ZCONVERT(ELCLEquipmentDR,"U")[eqcode)&&(($ZCONVERT(EQId,"U")[eqid))
			{
				d OutputRow2
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
    set Data=$lb(ELCLRowId,ELCLContactListDR,ELCLEquipmentDR,EQId,ELCLDateFrom,ELCLDateTo)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetList2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetList2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetList2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetList2Execute ]
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

/// Creator:杨帆 
/// CreatDate:2020-12-12
/// Description:数据重复验证方法,js调用
/// Table:User.CTHCCSEquipLinkContList
/// Input:id, equipmentDR, contactListDR
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).FormValidate("1","7","3","2021-02-04")
ClassMethod FormValidate(id As %String, equipmentDR As %String, contactListDR As %String, ELCLDateFrom As %String) As %String
{
	q:equipmentDR="" ""
	q:contactListDR="" ""
	s ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(ELCLDateFrom) 
	s flag=0
	if (id="")
	{
		s LinkRowId=0
		for
		{
			s LinkRowId=$o(^CT("HCCSELCL",0,"Equipment",equipmentDR,LinkRowId)) q:LinkRowId=""
			s ELCLContactListDR=$p($g(^CT("HCCSELCL",LinkRowId)),"^",2)		//个人通讯录-指针
			s ELCLDateTo=$p($g(^CT("HCCSELCL",LinkRowId)),"^",4)  //绑定设备的结束日期
			if ((ELCLDateTo="")||((ELCLDateTo'="")&&(ELCLDateFrom<=ELCLDateTo)))
			{
				s flag=1
				q
			}
		}
	}
	else
	{
		s LinkRowId=0
		for
		{
			s LinkRowId=$o(^CT("HCCSELCL",0,"Equipment",equipmentDR,LinkRowId)) q:LinkRowId=""
			s ELCLContactListDR=$p($g(^CT("HCCSELCL",LinkRowId)),"^",2)		//个人通讯录-指针
			s ELCLDateTo=$p($g(^CT("HCCSELCL",LinkRowId)),"^",4)  //绑定设备的结束日期	
			if (id'=LinkRowId)&&((ELCLDateTo="")||((ELCLDateTo'="")&&(ELCLDateFrom<=ELCLDateTo)))
			{
				s flag=1
				q
			}
		}
	}
	
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-12-22
/// Description：新增，修改时打开Form，根据RowId查询
/// Table:User.CTHCCSEquipLinkContList
/// Input：id
/// Other: w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).OpenData("2")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.CTHCCSEquipLinkContList).%OpenId(id) 
	s eobj = ##class(web.Entity.CT.CTHCCSEquipLinkContList).%New() 
	s eobj.ELCLRowId = id
	s:pobj.ELCLEquipmentDR'="" eobj.ELCLEquipmentDR = pobj.ELCLEquipmentDR.%Id()  //设备指针
	s:pobj.ELCLContactListDR'="" eobj.ELCLContactListDR = pobj.ELCLContactListDR.%Id()  //通讯录指针
	s:eobj.ELCLEquipmentDR'="" eobj.EQId=$p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
	s eobj.ELCLDateFrom=pobj.ELCLDateFrom  //关联开始日期
	s:pobj.ELCLDateFrom'="" eobj.ELCLDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ELCLDateFrom)
	s eobj.ELCLDateTo = pobj.ELCLDateTo  //关联结束日期
	s:pobj.ELCLDateTo'="" eobj.ELCLDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ELCLDateTo)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆 
/// CreatDate: 2020-12-22
/// Description：保存 医呼通设备和个人通讯录关联表
/// Input: eobj As web.Entity.CT.CTHCCSEquipLinkContList
/// Table：User.CTHCCSEquipLinkContList
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSEquipLinkContList) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ELCLDateFrom'="" eobj.ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ELCLDateFrom) //转换日期
		s:eobj.ELCLDateFrom="" eobj.ELCLDateFrom=+$h
		s:eobj.ELCLDateTo'="" eobj.ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ELCLDateTo) //转换日期
		if (eobj.ELCLDateTo'="")
		{
			if (eobj.ELCLDateFrom>eobj.ELCLDateTo) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		/* //改成前台校验了
		s flag=..FormValidate(eobj.ELCLRowId,eobj.ELCLEquipmentDR,eobj.ELCLContactListDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}*/
		if (eobj.ELCLRowId="")
		{
			s obj=##class(User.CTHCCSEquipLinkContList).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(eobj.ELCLRowId)
			s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
			s bobj.ELCLRowId = eobj.ELCLRowId		//ELCLRowId
			if $IsObject(obj.ELCLEquipmentDR)
			{
				s bobj.ELCLEquipmentDR = obj.ELCLEquipmentDR.%Id() //设备-指针
			}
			if $IsObject(obj.ELCLContactListDR)
			{
				s bobj.ELCLContactListDR = obj.ELCLContactListDR.%Id() //个人通讯录-指针
			}
			s bobj.ELCLDateFrom=obj.ELCLDateFrom	//关联开始日期
			s bobj.ELCLDateTo = obj.ELCLDateTo	//关联结束日期
		}
		d obj.ELCLEquipmentDRSetObjectId(eobj.ELCLEquipmentDR) //设备-指针
		d obj.ELCLContactListDRSetObjectId(eobj.ELCLContactListDR) //个人通讯录-指针
		S obj.ELCLDateFrom=eobj.ELCLDateFrom	//关联开始日期
		s obj.ELCLDateTo = eobj.ELCLDateTo	//关联结束日期
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.ELCLContactListDR)),"^",1)     //用户代码
			s EQId= $p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
			d:eobj.ELCLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备和个人通讯录关联表",eobj.ELCLRowId,HCCSCLUserCode_"-"_EQId,"U",eobj,bobj)
    		d:eobj.ELCLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备和个人通讯录关联表",id,HCCSCLUserCode_"-"_EQId,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备和个人通讯录关联","web.DHCBL.CT.CTHCCSEquipLinkContList","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：杨帆
/// CreatDate: 2020-12-22
/// Description：根据id删除 医呼通设备和个人通讯录关联表
/// Table：User.CTHCCSEquipLinkContList
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	if $IsObject(pobj.ELCLEquipmentDR)
	{
		s eobj.ELCLEquipmentDR = pobj.ELCLEquipmentDR.%Id() //设备-指针
	}
	if $IsObject(pobj.ELCLContactListDR)
	{
		s eobj.ELCLContactListDR = pobj.ELCLContactListDR.%Id() //个人通讯录-指针
	}
	s eobj.ELCLDateFrom = pobj.ELCLDateFrom  //关联开始日期
	s eobj.ELCLDateTo = pobj.ELCLDateTo  //关联结束日期
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.CTHCCSEquipLinkContList).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.ELCLContactListDR)),"^",1)     //用户代码
		s EQId= $p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备和个人通讯录关联表",id,HCCSCLUserCode_"-"_EQId,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备和个人通讯录关联表","web.DHCBL.CT.CTHCCSEquipLinkContList","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：杨帆
/// CreatDate: 2020-12-22
/// Description：设备绑定新增窗口-通过设备rowid获取设备ID级联方法
/// Table：User.CTHCCSEquipLinkContList
/// Input：rowid(设备rowid)
/// Return：EQId(设备Id)
/// Other: w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).GetEQID("")
ClassMethod GetEQID(rowid) As %String
{
	s EQId=""
	if (rowid'="")
	{
		s EQId= $p($g(^CT("HCCSEQ",rowid)),"^",2)		//设备ID
		q EQId
	}
	q EQId
}

/// Creator：杨帆
/// CreatDate: 2020-12-22
/// Description：设备绑定-新增前判定用户设备1对1绑定关系
/// Table：User.CTHCCSEquipLinkContList
/// Input：contactlistdr(个人通讯录rowid)
/// Return：1(当前用户已绑定一个有效设备),0(当前用户无有效设备绑定)
/// Other: w ##class(web.DHCBL.CT.CTHCCSEquipLinkContList).GetBandFlag("")
ClassMethod GetBandFlag(contactlistdr) As %String
{
	s flag=0
	if (contactlistdr'="")
	{
		s ELCLRowId=0
		for
		{
			s ELCLRowId=$o(^CT("HCCSELCL",0,"CL",contactlistdr,ELCLRowId)) q:ELCLRowId=""
			s:ELCLRowId'="" ELCLDateTo=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)   //关联结束日期
			if ((ELCLRowId'="")&&(ELCLDateTo="")) 
			{
				s flag=1
			}
		}
	}
	q flag
}

}
