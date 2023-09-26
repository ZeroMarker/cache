Import SQLUser

/// 名称: 病症与诊断关联表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2013-11-5
Class web.DHCBL.KB.DHCPHDiseaseItmList Extends %RegisteredObject
{

/// 石萧伟 2018-08-8
/// Description：批量删除关联表的内容
/// Input：ids——要删除的ID串
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteDataStr(ids As %String) As %String
{
	//new (ids)
	s result=""	
	s idsLen=$Length(ids,"^")
	for i=1:1:idsLen   
	{
	  s id=$p(ids,"^",i)  
	  if (id'=""){
		  s rs=..DeleteData(id)
		  if (rs["false")
		  {			  
			 s result=rs		 			  
		  }
	  }
	}
	s:result="" result = "{success:'true',info:'批量删除成功！'}"	
	q result
}

/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseItmList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseItmList).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseItmList).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseItmList).%New()
	s eobj.PHDISLIRowId=id
	s eobj.PHDISLIDisDr=$p(id,"||",1)
	if $IsObject(pobj.PHDISLIICDDr)
	{
		s eobj.PHDISLIICDDr = pobj.PHDISLIICDDr.%Id() 
	}		
	s eobj.PHDISLIType = pobj.PHDISLIType
	s eobj.PHDISLISysFlag = pobj.PHDISLISysFlag
	s:eobj.PHDISLISysFlag="Y" eobj.PHDISLISysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存病症与诊断关联表字典的内容
/// Table：User.DHCPHDiseaseItmList
/// Input：web.Entity.KB.DHCPHDiseaseItmList 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseItmList).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseItmList) As %String
{
	s $zt="ERROE"
	s result=""
	if $IsObject(eobj)
	{
		s args=eobj.PHDISLIICDDr
		s argsLen=$Length(args,",")
		s ids = ""
		for i=1:1:argsLen
		{
			s eobj.PHDISLIICDDr=$p(args,",",i)	
			if (eobj.PHDISLIRowId="")  //如果RowId未赋值则增加
			{
				//s ICDLength=$d(^DHCPHDISL(0,"ICD",eobj.PHDISLIICDDr,eobj.PHDISLIDisDr))
				s ICDLength=$d(^DHCPHDISL(0,"ICD",eobj.PHDISLIICDDr))
				if (ICDLength=0)
				{
					s obj=##class(User.DHCPHDiseaseItmList).%New(eobj.PHDISLIDisDr)
					d obj.PHDISLIDisDrSetObjectId(eobj.PHDISLIDisDr)
					d obj.PHDISLIICDDrSetObjectId(eobj.PHDISLIICDDr)
					s obj.PHDISLIType=eobj.PHDISLIType
					s:eobj.PHDISLISysFlag="" eobj.PHDISLISysFlag ="N" 
					s obj.PHDISLISysFlag=eobj.PHDISLISysFlag
					s ICDDesc=$p($g(^DHCEXTICD(eobj.PHDISLIICDDr)),"^",2)
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
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseItmList","User.DHCPHDiseaseItmList","病症与诊断关联表",id,ICDDesc,"A",eobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症与诊断关联表","web.DHCBL.KB.DHCPHDiseaseItmList","SaveData",eobj)
    				 	s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
					}
				}
				else
				{
					//s result = "{success:'false',errorinfo:'该记录已经存在！'}"
					s result = "{success:'false',errorinfo:'存在已经被关联的诊断！'}"
				}
			}
			else                     //如果RowId已赋值则修改
			{
				s ICDLength=$d(^DHCPHDISL(0,"ICD",eobj.PHDISLIICDDr,eobj.PHDISLIDisDr))
				s PHDISLIChildsub=$p(eobj.PHDISLIRowId,"||",2)
				s TempChildsub=$o(^DHCPHDISL(0,"ICD",eobj.PHDISLIICDDr,eobj.PHDISLIDisDr,0))
				if (ICDLength=0)||((ICDLength'=0)&(PHDISLIChildsub=TempChildsub))
				{
					s obj=##class(User.DHCPHDiseaseItmList).%OpenId(eobj.PHDISLIRowId)
					s bobj=##class(web.Entity.KB.DHCPHDiseaseItmList).%New()
					s bobj.PHDISLIRowId=eobj.PHDISLIRowId
					s bobj.PHDISLIDisDr=$p(eobj.PHDISLIRowId,"||",1)
					if $IsObject(obj.PHDISLIICDDr)
					{
						s bobj.PHDISLIICDDr = obj.PHDISLIICDDr.%Id() 
					}
					s bobj.PHDISLIType = obj.PHDISLIType          
					s bobj.PHDISLISysFlag = obj.PHDISLISysFlag       
			
					d obj.PHDISLIICDDrSetObjectId(eobj.PHDISLIICDDr)
					d obj.PHDISLIDisDrSetObjectId(eobj.PHDISLIDisDr)
					s obj.PHDISLIType = eobj.PHDISLIType          //修改描述
					s:eobj.PHDISLISysFlag="" eobj.PHDISLISysFlag ="N" 
					s obj.PHDISLISysFlag = eobj.PHDISLISysFlag
					
					s ICDDesc=$p($g(^DHCEXTICD(eobj.PHDISLIICDDr)),"^",2)	          	
					Ts					
					s sc=obj.%Save()
					d obj.%Close()
					If $$$ISOK(sc)
					{
						Tc
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"  //返回RowId
						//新增时，日志
						d:eobj.PHDISLIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseItmList","User.DHCPHDiseaseItmList","病症与诊断关联表",id,ICDDesc,"A",eobj)
						//修改时，日志
						d:eobj.PHDISLIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseItmList","User.DHCPHDiseaseItmList","病症与诊断关联表",eobj.PHDISLIRowId,ICDDesc,"U",eobj,bobj)
					}
					else
					{
						Trollback
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
						s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症与诊断关联表","web.DHCBL.KB.DHCPHDiseaseItmList","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症与诊断关联表","web.DHCBL.KB.DHCPHDiseaseItmList","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除病症与诊断关联表的内容
/// Table：User.DHCPHDiseaseItmList
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDiseaseItmList).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseItmList).%New()
	s eobj.PHDISLIRowId = id
	s eobj.PHDISLIDisDr=$p(id,"||",1)
	if $IsObject(pobj.PHDISLIICDDr)
	{
		s eobj.PHDISLIICDDr=pobj.PHDISLIICDDr.%Id()
	}
	s eobj.PHDISLIType=pobj.PHDISLIType
	s eobj.PHDISLISysFlag=pobj.PHDISLISysFlag
	s ICDDesc=$p($g(^DHCEXTICD(eobj.PHDISLIICDDr)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDiseaseItmList).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseItmList","User.DHCPHDiseaseItmList","病症与诊断关联表",id,ICDDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症与诊断关联表","web.DHCBL.KB.DHCPHDiseaseItmList","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
	}
	q result
}

/// Description：查询病症与诊断关联表的内容
/// Table：User.DHCPHDiseaseItmList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseItmList","GetList","","","")
Query GetList(rowid As %String, parref As %String, icd As %String) As %Query(ROWSPEC = "PHDISLIRowId:%String,PHDISLIDisDr:%String,ICDRowId:%String,PHDISLIICDDr:%String,PHDISLIType:%String,PHDISLISysFlag:%String,ICDRowId:%String,ICDOpStatus:%String,ICDRemark:%String,ICDCode:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, parref As %String, icd As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	//s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseItmList).DHCGetDataByDefaultSession()
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s idLen=$Length(rowid,",")
		for i=1:1:idLen
		{
			s PHDISLIRowId=$p(rowid,",",i)
			s DisRowId=$p(PHDISLIRowId,"||",1)
			s PHDISLIChildsub=$p(PHDISLIRowId,"||",2)
			s PHDISLIDisDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			s ICDRowId=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",1)
			s PHDISLIType=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",2)
			s PHDISLISysFlag=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",3)
			s:PHDISLISysFlag="" PHDISLISysFlag="Y"
			i ICDRowId'="" 
			{
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s PHDISLIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
				s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
			}
			else 
			{
				s ICDCode=""
				s PHDISLIICDDr=""
				s ICDOpStatus=""
				s ICDRemark=""
			}
	
			d OutputRow
		}
	}
	else
	{
		s DisRowId=parref,PHDISLIChildsub=0
		for {
			S PHDISLIChildsub=$o(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)) q:PHDISLIChildsub=""
			s PHDISLIRowId=DisRowId_"||"_PHDISLIChildsub
			s PHDISLIDisDr=$p($g(^DHCPHDISL(DisRowId)),"^",2)
			s ICDRowId=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",1)
			s PHDISLIType=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",2)
			s PHDISLISysFlag=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",3)
			s:PHDISLISysFlag="" PHDISLISysFlag="Y"
			i ICDRowId'="" 
			{
				s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
				s PHDISLIICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				s ICDOpStatus=$p($g(^DHCEXTICD(ICDRowId)),"^",6)
				s ICDRemark=$p($g(^DHCEXTICD(ICDRowId)),"^",7)
			}
			else 
			{
				s ICDCode=""
				s PHDISLIICDDr=""
				s ICDOpStatus=""
				s ICDRemark=""
			}
			if (PHDISLIChildsub>0)&((ICDRowId=icd)||(icd=""))
			{
				d OutputRow
			}
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHDISLIRowId,PHDISLIDisDr,ICDRowId,PHDISLIICDDr,PHDISLIType,PHDISLISysFlag,ICDRowId,ICDOpStatus,ICDRemark,ICDCode)
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

/// Description：根据ICD诊断的描述返回icd诊断的rowId
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseItmList).ReturnICDRowId("q1")
ClassMethod ReturnICDRowId(desc As %String) As %String
{
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s:desc'="" idd=$o(^DHCEXTICD(0,"Desc",desc,0))
	q idd
}

/// Description：已经关联的诊断拼串
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseItmList).ConICDStr()
ClassMethod ConICDStr() As %String
{
	s ICDStr=""
	s DisRowId=0
	for 
	{
		s DisRowId=$o(^DHCPHDISL(DisRowId)) q:DisRowId=""	
		s PHDISLIChildsub=0
		for 
		{
			S PHDISLIChildsub=$o(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)) q:PHDISLIChildsub=""

			s ICDRowId=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",1)
			s:ICDStr'="" ICDStr="{"_ICDRowId_"}"_"^"_ICDStr
			s:ICDStr="" ICDStr="{"_ICDRowId_"}"
		}
	}

	q ICDStr
}

}
