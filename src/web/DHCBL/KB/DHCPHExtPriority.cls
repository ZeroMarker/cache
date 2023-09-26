Class web.DHCBL.KB.DHCPHExtPriority Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-12-8
/// Description：查询医嘱优先级表内容
/// Table：User.DHCPHExtPriority
/// Input：rowid, code, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtPriority","GetList","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHEPRowId,PHEPCode,PHEPDesc,PHEPPriority")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEPRowId=rowid
		s PHEPCode=$p($g(^DHCPHEP(PHEPRowId)),"^",1)  //代码
		s PHEPDesc=$p($g(^DHCPHEP(PHEPRowId)),"^",2)  //描述
		s PHEPPriority=$p($g(^DHCPHEP(PHEPRowId)),"^",3)  //优先级
		
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHEPRowId=0
		for  
		{	
			s PHEPRowId=$o(^DHCPHEP(PHEPRowId)) q:PHEPRowId="" 
			s strRowId = "{ID:"_PHEPRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHEPCode=$p($g(^DHCPHEP(PHEPRowId)),"^",1)  //代码
				s PHEPCodeU=$ZCONVERT(PHEPCode,"U")
				s PHEPDesc=$p($g(^DHCPHEP(PHEPRowId)),"^",2)  //描述
				s PHEPDescU=$ZCONVERT(PHEPDesc,"U")
				s PHEPPriority=$p($g(^DHCPHEP(PHEPRowId)),"^",3)  //优先级
				s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEPDescU))
				i (PHEPCodeU[code)&((PHEPDescU[desc)||(PINYIN[desc))   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHEPRowId,PHEPCode,PHEPDesc,PHEPPriority)
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
/// CreateDate:2015-12-8    
/// w ##class(web.DHCBL.KB.DHCPHExtPriority).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^DHCPHEPi(0,"Code",code))
	s:desc'="" flagd=$d(^DHCPHEPi(0,"Desc",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^DHCPHEPi(0,"Code",code,0))
		s:desc'="" idd=$o(^DHCPHEPi(0,"Desc",desc,0))
		if (desc="")
		{
			if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
		elseif (code="")
		{
			if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
			else  s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2015-12-8
/// Description：保存修改内容
/// Table：User.DHCPHExtPriority
/// Input：web.Entity.KB.DHCPHExtPriority 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtPriority) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.PHEPRowId,eobj.PHEPCode,eobj.PHEPDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.PHEPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHExtPriority).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHExtPriority).%OpenId(eobj.PHEPRowId)
				
				s re=##class(web.DHCBL.KB.DHCPHExtPriority).GetRefFlag(eobj.PHEPRowId)
				s RefFlag=$p(re,"^",1)
				s str=$p(re,"^",2)
				if (RefFlag=1)&(str["<医嘱优先级对照>"){
					s result = "{success:'false',errorinfo:'在医嘱优先级对照中被引用，不能修改!'}"  //返回错误信息
					q result
				}
				
				s bobj = ##class(web.Entity.KB.DHCPHExtPriority).%New()
				s bobj.PHEPRowId = eobj.PHEPRowId
				s bobj.PHEPCode = obj.PHEPCode
				s bobj.PHEPDesc = obj.PHEPDesc
				s bobj.PHEPPriority= obj.PHEPPriority
			}
	
			s obj.PHEPCode = eobj.PHEPCode
			s obj.PHEPDesc = eobj.PHEPDesc
			s obj.PHEPPriority = eobj.PHEPPriority
			
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHEPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPriority","User.DHCPHExtPriority","医嘱优先级",id,eobj.PHEPDesc,"A",eobj)
				d:eobj.PHEPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPriority","User.DHCPHExtPriority","医嘱优先级",eobj.PHEPRowId,eobj.PHEPDesc,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
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
/// CreatDate: 2015-12-8
/// Description：获取修改时的记录
/// Table：User.DHCPHExtPriority
/// Other: d ##class(web.DHCBL.KB.DHCPHExtPriority).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHExtPriority).%New()
	s pobj = ##class(User.DHCPHExtPriority).%OpenId(id)
	s eobj.PHEPRowId = id
	s eobj.PHEPCode = pobj.PHEPCode
	s eobj.PHEPDesc = pobj.PHEPDesc
	s eobj.PHEPPriority = pobj.PHEPPriority

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHExtPriority).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="", myInfo=""
	s PDPRowId=0,flag=0
	for
	{
		s PDPRowId=$o(^DHCPHDISPR(PDPRowId)) q:(PDPRowId="")||(flag=1)  d
		s PDPPriorityDR=$p($g(^DHCPHDISPR(PDPRowId)),"^",2)
		i PDPPriorityDR=id
		{
			s flag=1
			s myInfo=myInfo_"<医嘱优先级业务表>"
		}
	}	
	
	s flag=0
	s PHEPCode=$p($g(^DHCPHEP(id)),"^",1) 
	s PHPCTRowId=0
	for  
	{	
		s PHPCTRowId=$o(^DHCPHPRCON(PHPCTRowId)) q:PHPCTRowId=""||(flag=1)  d 
		s PHPCTCode=$p($g(^DHCPHPRCON(PHPCTRowId)),"^",1)  //his代码
		i (PHPCTCode=PHEPCode){
			s flag=1
			s myInfo=myInfo_"<医嘱优先级对照>"	
		}	
	}
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"里被引用,不能删除!"
 	q return
}

/// Creator:高姗姗
/// CreatDate:2015-12-8
/// Description:根据id删除
/// Table:User.DHCPHExtPriority
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtPriority).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	s re=##class(web.DHCBL.KB.DHCPHExtPriority).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHExtPriority).%New()
		s pobj = ##class(User.DHCPHExtPriority).%OpenId(id)
		s eobj.PHEPRowId = id
		s eobj.PHEPCode = pobj.PHEPCode
		s eobj.PHEPDesc = pobj.PHEPDesc
		s eobj.PHEPPriority = pobj.PHEPPriority
	
		s sc=##class(User.DHCPHExtPriority).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPriority","User.DHCPHExtPriority","医嘱优先级",id,eobj.PHEPDesc,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	q result
}

}
