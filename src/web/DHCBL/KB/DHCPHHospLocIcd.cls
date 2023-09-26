Import SQLUser

/// 名称: 科室与诊断关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2013-11-5
Class web.DHCBL.KB.DHCPHHospLocIcd Extends %RegisteredObject
{

/// Description：保存科室与诊断关联表字典的内容
/// Table：User.DHCPHHospLocIcd
/// Input：web.Entity.KB.DHCPHHospLocIcd 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHHospLocIcd).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHHospLocIcd) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.LOCIICDDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.LOCIICDDr=$p(args,",",i)	
			if (eobj.LOCIRowId="")  //如果RowId未赋值则增加
			{
				//s ICDLength=$d(^DHCPHDISL(0,"ICD",eobj.LOCIICDDr,eobj.LOCILOCDr))
				s ICDLength=$d(^DHCPHHLOCICD(0,"ICD",eobj.LOCIICDDr))
				if (ICDLength=0)
				{
					s obj=##class(User.DHCPHHospLocIcd).%New()
					d obj.LOCILOCDrSetObjectId(eobj.LOCILOCDr)
					d obj.LOCIICDDrSetObjectId(eobj.LOCIICDDr)
					s ICDDesc=$p($g(^DHCEXTICD(eobj.LOCIICDDr)),"^",2)
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc)
					{
						Tcommit
						s id = obj.%Id()
						if (ids="")
						{
						    s ids = id
						}
						else
						{
							s ids = ids_","_id
						}
						s result = "{success:'true',id:'"_ids_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLocIcd","User.DHCPHHospLocIcd","科室与诊断关联表",id,ICDDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室与诊断关联表","web.DHCBL.KB.DHCPHHospLocIcd","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'存在已经被关联的诊断！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s ICDLength=$d(^DHCPHHLOCICD(0,"ICD",eobj.LOCIICDDr,eobj.LOCILOCDr))
				s LOCIRowId=$o(^DHCPHHLOCICD(0,"ICD",eobj.LOCIICDDr,eobj.LOCILOCDr,0))
				if (ICDLength=0)||((ICDLength'=0)&(LOCIRowId=eobj.LOCIRowId))
				{
					s obj=##class(User.DHCPHHospLocIcd).%OpenId(eobj.LOCIRowId)
					s bobj=##class(web.Entity.KB.DHCPHHospLocIcd).%New()
					s bobj.LOCIRowId=eobj.LOCIRowId
					if $IsObject(obj.LOCILOCDr)
					{
						s bobj.LOCILOCDr = obj.LOCILOCDr.%Id() 
					}
					if $IsObject(obj.LOCIICDDr)
					{
						s bobj.LOCIICDDr = obj.LOCIICDDr.%Id() 
					}     
			
					d obj.LOCIICDDrSetObjectId(eobj.LOCIICDDr)
					d obj.LOCILOCDrSetObjectId(eobj.LOCILOCDr)
					
					s ICDDesc=$p($g(^DHCEXTICD(eobj.LOCIICDDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.LOCIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLocIcd","User.DHCPHHospLocIcd","科室与诊断关联表",id,ICDDesc,"A",eobj)
						//修改时，日志
						d:eobj.LOCIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLocIcd","User.DHCPHHospLocIcd","科室与诊断关联表",eobj.LOCIRowId,ICDDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室与诊断关联表","web.DHCBL.KB.DHCPHHospLocIcd","SaveData",eobj)
    					s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
					}
				}
				else
				{
					s result = "{success:'false',errorinfo:'该记录已经存在！'}"
				}
			}	
		}			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室与诊断关联表","web.DHCBL.KB.DHCPHHospLocIcd","SaveData",eobj)
  	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除科室与诊断关联表的内容
/// Table：User.DHCPHHospLocIcd
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHHospLocIcd).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHHospLocIcd).%New()
	s eobj.LOCIRowId = id
	if $IsObject(pobj.LOCILOCDr)
	{
		s eobj.LOCILOCDr=pobj.LOCILOCDr.%Id()
	}
	if $IsObject(pobj.LOCIICDDr)
	{
		s eobj.LOCIICDDr=pobj.LOCIICDDr.%Id()
	}
	s ICDDesc=""
	s:eobj.LOCIICDDr'="" ICDDesc=$p($g(^DHCEXTICD(eobj.LOCIICDDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHHospLocIcd).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHHospLocIcd","User.DHCPHHospLocIcd","科室与诊断关联表",id,ICDDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室与诊断关联表","web.DHCBL.KB.DHCPHHospLocIcd","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Description：查询科室与诊断关联表的内容
/// Table：User.DHCPHHospLocIcd
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHHospLocIcd","GetList","","","")
Query GetList(rowid As %String, parref As %String) As %Query(ROWSPEC = "LOCIRowId:%String,LOCILOCDr:%String,ICDRowId:%String,LOCIICDDr:%String,ICDRowId:%String,ICDOpStatus:%String,ICDRemark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s LOCIRowId=rowid
		s LOCRowId=$p($g(^DHCPHHLOCICD(LOCIRowId)),"^",1)
		s LOCILOCDr=""
		s:LOCRowId'="" LOCILOCDr=$p($g(^DHCPHHLOC(LOCRowId)),"^",2)
		s ICDRowId=$p($g(^DHCPHHLOCICD(DisRowId)),"^",2)
		i ICDRowId'="" 
		{
			s LOCIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
			s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
			s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
		}
		else 
		{
			s LOCIICDDr=""
			s ICDOpStatus=""
			s ICDRemark=""
		}

		d OutputRow
		
	}
	else
	{
		if (parref'="")
		{
		s LOCRowId=parref,LOCIRowId=0
		for {
			S LOCIRowId=$o(^DHCPHHLOCICD(0,"Loc",LOCRowId,LOCIRowId)) q:LOCIRowId=""
			s LOCILOCDr=$p($g(^DHCPHHLOC(LOCRowId)),"^",2)
			s ICDRowId=$p($g(^DHCPHHLOCICD(LOCIRowId)),"^",2)
			i ICDRowId'="" 
			{
				s LOCIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
				s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
			}
			else 
			{
				s LOCIICDDr=""
				s ICDOpStatus=""
				s ICDRemark=""
			}

			d OutputRow
		}
					
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(LOCIRowId,LOCILOCDr,ICDRowId,LOCIICDDr,ICDRowId,ICDOpStatus,ICDRemark)
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

/// Description:科室关联诊断界面取诊断数据
/// Table:User.DHCExtIcdFeild
/// Input:code,desc
/// Return:ICDRowId,ICDCode,ICDDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHHospLocIcd","GetDataForLoc","","","")
Query GetDataForLoc(rowid As %String, code As %String, desc As %String, con As %String) As %Query(ROWSPEC = "ICDRowId:%String,ICDCode:%String,ICDDesc:%String,ConFlag:%String")
{
}

ClassMethod GetDataForLocExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, con As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdFeild).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDRowId=rowid
		s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)	
		d OutputRowLoc
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ConFlag=""
		s conicdstr=##class(web.DHCBL.KB.DHCPHDiseaseItmList).ConICDStr()
		s ICDRowId=0
		for {
			s ICDRowId=$o(^DHCEXTICD(ICDRowId))
			q:ICDRowId=""
			//筛选授权后的数据
			//s strRowId="{ID:"_ICDRowId_"}"
			//if (AuStr[strRowId)||(AuFlag=1) {
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s ICDDesc=$p($g(^DHCEXTICD(ICDRowId)),"^",2)				
				
				if ($d(^DHCPHHLOCICD(0,"ICD",ICDRowId)))
				{
					s ConFlag="Y"			
				}
				else
				{
					s ConFlag="N"
				}
					
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDDesc)
				if ($ZCONVERT(ICDCode,"U")[code)&(($ZCONVERT(ICDDesc,"U")[desc)||(PINYIN[desc))&(ConFlag[con)
				{
					d OutputRowLoc
				}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLoc
    set Data=$lb(ICDRowId,ICDCode,ICDDesc,ConFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForLocExecute ]
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

}
