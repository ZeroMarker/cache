Import SQLUser

/// 描述: 病症常用名/别名字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-23
Class web.DHCBL.KB.DHCPHDiseaseComList Extends %RegisteredObject
{

/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseComList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseComList).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseComList).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseComList).%New()
	s eobj.PHDCLRowId=id
	if $IsObject(pobj.PHDCLDisDr)
	{
		s eobj.PHDCLDisDr = pobj.PHDCLDisDr.%Id() 
	}	
	s eobj.PHDCLCode=pobj.PHDCLCode
	s eobj.PHDCLDesc=pobj.PHDCLDesc	
	s eobj.PHDCLType = pobj.PHDCLType
	s keyid=$o(^DHCPHDISKEYi(0,"Dis",eobj.PHDCLType,id,0))
	s eobj.PHDCLKey=""
	s:keyid'="" eobj.PHDCLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)

	s eobj.PHDCLActiveFlag=pobj.PHDCLActiveFlag
	s:eobj.PHDCLActiveFlag="Y" eobj.PHDCLActiveFlag="true"
	s eobj.PHDCLSysFlag = pobj.PHDCLSysFlag
	s:eobj.PHDCLSysFlag="Y" eobj.PHDCLSysFlag="true" 
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHDiseaseComList
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, dis As %String, type As %String, desc As %String) As %String
{
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagd=""
	s:desc'="" flagd=$d(^DHCPHDISCOMLi(0,"Desc",dis,type,desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:desc'="" idd=$o(^DHCPHDISCOMLi(0,"Desc",dis,type,desc,0))
	  	if (desc="")
	  	{
	   		s flag=0 //返回不重复标志
	  	}
	  	else
	  	{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
	  	}
	
	}
	q flag
}

/// createdate:2015-1-14
/// RowId^ALIASText^ALIASParRef # RowId^ALIASText^ALIASParRef
ClassMethod SaveAll(listData As %String) As %String
{
	s result="" 
	s msg=0
	s length=$length($g(listData),"#")
	for i=1:1:length 
	{	
		q:msg'=0  
		s DataStr=$p($g(listData),"#",i)
		s eobj = ##class(web.Entity.KB.DHCPHDiseaseComList).%New()
		s eobj.PHDCLRowId=$p($g(DataStr),"^",1)
		s eobj.PHDCLDesc=$p($g(DataStr),"^",2)
		s eobj.PHDCLDisDr=$p($g(DataStr),"^",3)
		s eobj.PHDCLType=$p($g(DataStr),"^",4)
		s eobj.PHDCLKey=$p($g(DataStr),"^",5)
		s:eobj.PHDCLKey="" eobj.PHDCLKey=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.PHDCLDesc)
		if (eobj.PHDCLRowId="")
		{
			s ret=..SaveData(eobj)
		}
		else
		{
			s ret=..UpdateData(eobj)
		}
		if (ret["false") 
		{
			s msg=1
		}
	}
	if (msg=0) 
	{
		s result= "{success:'true',info:'保存成功！'}"
	}
	else
	{
		s result= "{success:'false',errorinfo:'保存失败！'}"
	}
	
	q result
}

/// Description：保存病症与诊断关联表字典的内容
/// Table：User.DHCPHDiseaseComList
/// Input：web.Entity.KB.DHCPHDiseaseComList 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseComList).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseComList) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{
			
		s flag=..Validate(eobj.PHDCLRowId,eobj.PHDCLDisDr,eobj.PHDCLType,eobj.PHDCLDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{

			s obj=##class(User.DHCPHDiseaseComList).%New()		
			
			s obj.PHDCLCode = eobj.PHDCLCode
			s obj.PHDCLDesc = eobj.PHDCLDesc          //修改描述
			d obj.PHDCLDisDrSetObjectId(eobj.PHDCLDisDr)
			s obj.PHDCLType=eobj.PHDCLType
			s:eobj.PHDCLActiveFlag="" eobj.PHDCLActiveFlag ="N" 
			s obj.PHDCLActiveFlag = eobj.PHDCLActiveFlag 
			s:eobj.PHDCLSysFlag="" eobj.PHDCLSysFlag ="N" 
			s obj.PHDCLSysFlag = eobj.PHDCLSysFlag	
			Ts		
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s result="Y"_result
				s id = obj.%Id()
				if (eobj.PHDCLKey'="")
				{
					s objkey=##class(User.DHCPHDiseaseKey).%New()

					s objkey.PHDKDesc=eobj.PHDCLKey
					s objkey.PHDKDisDr=id
					s objkey.PHDKType=eobj.PHDCLType
				
					s sckey=objkey.%Save()
					d objkey.%Close()
			
					If $$$ISOK(sckey)
					{
						s result="Y"_result
					}
					else
					{
						s result="N"_result
					}
				}
			}
			else
			{
				s result="N"_result
			}
			
				
			If result["N"
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息

			}
			else
			{
				Tc				
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseComList","User.DHCPHDiseaseComList","病症通用名/别名字典",id,eobj.PHDCLDesc,"A",eobj)

			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：保存病症与诊断关联表字典的内容
/// Table：User.DHCPHDiseaseComList
/// Input：web.Entity.KB.DHCPHDiseaseComList 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseComList)UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHDiseaseComList) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{
			
		s flag=..Validate(eobj.PHDCLRowId,eobj.PHDCLDisDr,eobj.PHDCLType,eobj.PHDCLDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{

			s obj=##class(User.DHCPHDiseaseComList).%OpenId(eobj.PHDCLRowId)
			s bobj=##class(web.Entity.KB.DHCPHDiseaseComList).%New()	
			
			s bobj.PHDCLRowId=eobj.PHDCLRowId
			s bobj.PHDCLDesc = obj.PHDCLDesc          //修改描述	
			
			s obj.PHDCLDesc = eobj.PHDCLDesc          //修改描述
			TS
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s result="Y"_result
				s id = obj.%Id()
		
				s keyid=$o(^DHCPHDISKEYi(0,"Dis",eobj.PHDCLType,id,0))
				if ((keyid="")&(eobj.PHDCLType'=""))
				{
					s objkey=##class(User.DHCPHDiseaseKey).%New()
				}
				if (keyid'="")
				{
					s objkey=##class(User.DHCPHDiseaseKey).%OpenId(keyid)
				}
				if (objkey){
				s objkey.PHDKDesc=eobj.PHDCLKey
				s objkey.PHDKDisDr=id
				s objkey.PHDKType=eobj.PHDCLType
			
				s sckey=objkey.%Save()
				d objkey.%Close()
			
				s sckey=objkey.%Save()
				d objkey.%Close()
		
				If $$$ISOK(sckey)
				{
					s result="Y"_result
				}
				else
				{
					s result="N"_result
				}
				}
			
			}
			else
			{
				s result="N"_result
			}
			
				
			If result["N"
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息

			}
			else
			{
				Tc				
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseComList","User.DHCPHDiseaseComList","病症通用名/别名字典",eobj.PHDCLRowId,eobj.PHDCLDesc,"U",eobj,bobj)
				//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseComList","User.DHCPHDiseaseComList","病症通用名/别名字典",id,eobj.PHDCLDesc,"A",eobj)

			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除病症与诊断关联表的内容
/// Table：User.DHCPHDiseaseComList
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDiseaseComList).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseComList).%New()
	s eobj.PHDCLRowId = id
	s eobj.PHDCLCode=pobj.PHDCLCode
	s eobj.PHDCLDesc=pobj.PHDCLDesc
	if $IsObject(pobj.PHDCLDisDr)
	{
		s eobj.PHDCLDisDr=pobj.PHDCLDisDr.%Id()
	}
	s eobj.PHDCLType=pobj.PHDCLType
	s eobj.PHDCLSysFlag=pobj.PHDCLSysFlag
	s eobj.PHDCLActiveFlag=pobj.PHDCLActiveFlag
	Tstart
	s keyid=$o(^DHCPHDISKEYi(0,"Dis",eobj.PHDCLType,id,0))
	if (keyid'="")
	{
		s sckey=##class(User.DHCPHDiseaseKey).%DeleteId(keyid)
	}
	d pobj.%Close()
	k pobj
	
	s sc=##class(User.DHCPHDiseaseComList).%DeleteId(id)
	if ($$$ISOK(sc)&$$$ISOK(sckey))
	{
		Tcommit		
		s result = "{success:'true',info:'删除成功！'}"
		
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseComList","User.DHCPHDiseaseComList","病症通用名/别名字典",id,eobj.PHDCLDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

/// Description：查询病症与诊断关联表的内容
/// Table：User.DHCPHDiseaseComList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseComList","GetList","","","")
Query GetList(rowid As %String, dis As %String, type As %String) As %Query(ROWSPEC = "PHDCLRowId:%String,PHDCLDisDr:%String,PHDCLDesc:%String,PHDCLKey:%String,PHDCLType:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, dis As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{

		s PHDCLRowId=rowid

		s PHDCLDisDr=$p($g(^DHCPHDISCOML(PHDCLRowId)),"^",1)
		s PHDCLDesc=$p($g(^DHCPHDISCOML(PHDCLRowId)),"^",3)
		s PHDCLType=type
		s keyid=$o(^DHCPHDISKEYi(0,"Dis",PHDCLType,PHDCLRowId,0))
		s PHDCLKey=""
		s:keyid'="" PHDCLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)

		d OutputRow
		
	}
	else
	{
		s PHDCLRowId=0
		for 
		{
			S PHDCLRowId=$o(^DHCPHDISCOMLi(0,"Dis",dis,type,PHDCLRowId)) q:PHDCLRowId=""
			s PHDCLDisDr=dis
			s PHDCLType=type
			s PHDCLDesc=$p($g(^DHCPHDISCOML(PHDCLRowId)),"^",3)
			s keyid=$o(^DHCPHDISKEYi(0,"Dis",PHDCLType,PHDCLRowId,0))
			s PHDCLKey=""
			s:keyid'="" PHDCLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)

			d OutputRow
			
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHDCLRowId,PHDCLDisDr,PHDCLDesc,PHDCLKey,PHDCLType)
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

}
