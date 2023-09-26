Class web.DHCBL.KB.DHCPHMenstruumItm Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2016-11-22
/// Description：获取修改时的记录
/// Table：User.DHCPHMenstruumItm
/// Other: d ##class(web.DHCBL.KB.DHCPHMenstruumItm).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHMenstruumItm).%New()
	s pobj = ##class(User.DHCPHMenstruumItm).%OpenId(id)
	s eobj.PHMIRowId = id
	s:pobj.PHMIDrugDr'="" eobj.PHMIDrugDr = pobj.PHMIDrugDr.%Id()
	s:pobj.PHMIMentDr'="" eobj.PHMIMentDr = pobj.PHMIMentDr.%Id()

	s str = eobj.JsonS()	
	//s str = "{data:["_str_"]}"
	q str
}

/// Creator：高姗姗
/// CreatDate: 2016-11-22
/// Description：查询溶媒分类明细表内容
/// Table：User.DHCPHMenstruumItm
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHMenstruumItm","GetList","268,267,","","")
Query GetList(rowid, drug, ment) As %Query(ROWSPEC = "PHMIRowId,PHMIDrugDr,PHNDesc,PHMIMentDr,PHMCDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, drug, ment) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHMenstruumItm).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHMIRowId=rowid
		s PHMIDrugDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",1)  //药品名Dr
		s:PHMIDrugDr'="" PHNDesc=$p($g(^DHCPHPNA(PHMIDrugDr)),"^",2) //药品名名称 
		
		s PHMIMentDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",2)  //溶媒Dr
		s:PHMIMentDr'="" PHMCDesc=$p($g(^DHCPHMCT(PHMIMentDr)),"^",2) //溶媒名称 
			
		d OutputRow			
	}
	else
	{
		s PHMIRowId=0
		for  
		{	
			s PHMIRowId=$o(^DHCPHMIT(PHMIRowId)) q:PHMIRowId="" 
			s strRowId = "{ID:"_PHMIRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s PHMIDrugDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",1)  //药品名Dr
				s:PHMIDrugDr'="" PHNDesc=$p($g(^DHCPHPNA(PHMIDrugDr)),"^",2) //药品名名称 
				s:PHMIDrugDr="" PHNDesc=""
				
				s PHMIMentDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",2)  //溶媒Dr
				s:PHMIMentDr'="" PHMCDesc=$p($g(^DHCPHMCT(PHMIMentDr)),"^",2) //溶媒名称  
				s:PHMIMentDr="" PHMCDesc=""
				
				i ((PHMIMentDr=ment)||(ment=""))&((PHMIDrugDr=drug)||(drug=""))   //条件
				{
					d OutputRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHMIRowId,PHMIDrugDr,PHNDesc,PHMIMentDr,PHMCDesc)
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
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2016-11-22 
/// w ##class(web.DHCBL.KB.DHCPHMenstruumItm).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, drug As %String, ment As %String) As %String
{
	s flag=""
	s flagd=""
	s flagd=$d(^DHCPHMITi(0,"DrugMent",drug,ment))
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
		s idd=$o(^DHCPHMITi(0,"DrugMent",drug,ment,0))
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

/// Creator：高姗姗
/// CreatDate: 2016-11-22
/// Description：保存修改内容
/// Table：User.DHCPHMenstruumItm
/// Input：web.Entity.KB.DHCPHMenstruumItm 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHMenstruumItm) As %String
{
	
 s result = ""

	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.PHMIRowId,eobj.PHMIDrugDr,eobj.PHMIMentDr)  //调用重复验证
 		if (flag=1)
  		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  		}
  		else
  		{
			if (eobj.PHMIRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHMenstruumItm).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHMenstruumItm).%OpenId(eobj.PHMIRowId)
				s bobj = ##class(web.Entity.KB.DHCPHMenstruumItm).%New()
				s bobj.PHMIRowId = eobj.PHMIRowId
				s:obj.PHMIDrugDr'="" bobj.PHMIDrugDr = obj.PHMIDrugDr.%Id()
				s:obj.PHMIMentDr'="" bobj.PHMIMentDr = obj.PHMIMentDr.%Id()
			}
			d:eobj.PHMIDrugDr'="" obj.PHMIDrugDrSetObjectId(eobj.PHMIDrugDr)
			d:eobj.PHMIDrugDr="" obj.PHMIDrugDrSetObjectId("")
			d:eobj.PHMIMentDr'="" obj.PHMIMentDrSetObjectId(eobj.PHMIMentDr)
			d:eobj.PHMIMentDr="" obj.PHMIMentDrSetObjectId("")
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHMIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHMenstruumItm","User.DHCPHMenstruumItm","溶媒分类明细表",id,eobj.PHMIMentDr,"A",eobj)
				d:eobj.PHMIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHMenstruumItm","User.DHCPHMenstruumItm","溶媒分类明细表",eobj.PHMIRowId,eobj.PHMIMentDr,"U",eobj,bobj)
			}
			else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("溶媒分类明细表","web.DHCBL.KB.DHCPHMenstruumItm","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			}
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2016-11-22
/// Description：获取修改时的记录
/// Table：User.DHCPHMenstruumItm
/// Other: d ##class(web.DHCBL.KB.DHCPHMenstruumItm).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHMenstruumItm).%New()
	s pobj = ##class(User.DHCPHMenstruumItm).%OpenId(id)
	s eobj.PHMIRowId = id
	s:pobj.PHMIDrugDr'="" eobj.PHMIDrugDr = pobj.PHMIDrugDr.%Id()
	s:pobj.PHMIMentDr'="" eobj.PHMIMentDr = pobj.PHMIMentDr.%Id()

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2016-11-22
/// Description:根据id删除
/// Table:User.DHCPHMenstruumItm
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHMenstruumItm).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s pobj = ##class(User.DHCPHMenstruumItm).%OpenId(id)
		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHMenstruumItm).%New()
		
		s eobj.PHMIRowId = id
		s:pobj.PHMIDrugDr'="" eobj.PHMIDrugDr = pobj.PHMIDrugDr.%Id()
		s:pobj.PHMIMentDr'="" eobj.PHMIMentDr = pobj.PHMIMentDr.%Id()
	
		s sc=##class(User.DHCPHMenstruumItm).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHMenstruumItm","User.DHCPHMenstruumItm","溶媒分类明细表",id,eobj.PHMIMentDr,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("溶媒分类明细表","web.DHCBL.KB.DHCPHMenstruumItm","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}
