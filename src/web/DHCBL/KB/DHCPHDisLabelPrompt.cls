/// 名称: 推导目录提示维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-04-21
Class web.DHCBL.KB.DHCPHDisLabelPrompt Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:石萧伟
/// CreatDate:2017-04-19
/// Description：查询推导目录提示的内容
/// Table：User.DHCPHDisLabelPrompt
/// Return:PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLabelPrompt","GetList","","","")
Query GetNewList(rowid As %String, lastid As %String, labeldr As %String) As %Query(ROWSPEC = "PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc,PDPLabelDrF,PDPPromptF,PDPLabelDrFF,PDPSysFlagF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid As %String, lastid As %String, labeldr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDPRowId=rowid
		s PDPLastId=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",1) //提示代码
		s:PDPLastId'="" PDTDesc=$p($g(^DHCPHDISTR(PDPLastId)),"^",2)  //诊断逻辑推导目录
		s:PDPLastId="" PDTDesc=""
		s PDPLabelDrF=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",2) //提示目录
		s PDPLabelDrFF=PDPLabelDrF
		s PDPPromptF=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",3) //提示目录id
		
		s PDPPromptVal=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",4) //提示目录值
		s PDPPrompt=PDPPromptVal
		s PDPSysFlag=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",5) //是否系统标识
		s:PDPSysFlag="" PDPSysFlag="Y"
		
		s:PDPLabelDrF'="" PDPLabelDrDesc=$p($g(^DHCPHGULA(PDPLabelDrF)),"^",2)  //提示目录描述
		s PDPSysFlagF=""
		s:PDPLabelDrF="" PDPLabelDrDesc=""
		s PDPLabelDr=PDPLabelDrDesc
		s PDPPrompt=""
		s PDPPromptDesc=""
		if PDPLabelDrF'=""
		{
			if PDPLabelDrDesc["症状" s PDPPromptDesc=$p($g(^DHCPHKW(PDPPromptF)),"^",2)
			if PDPLabelDrDesc["检验" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPromptF)),"^",2)
			if PDPLabelDrDesc["检查" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPromptF)),"^",2)
			if PDPLabelDrDesc["诊断" s PDPPromptDesc=$p($g(^DHCPHDISL(PDPPromptF)),"^",2)
			s PDPPrompt=PDPPromptDesc
		}
		d OutputNewRow		
	}
	else
	{ 
		if lastid'=""
		{
			s PDPRowId=0
			for 
			{
				S PDPRowId=$o(^DHCPHDISLPROi(0,"LastId",lastid,PDPRowId)) q:PDPRowId=""
				s PDPPromptF=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",3) //提示目录id
				s PDPLastId=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",1) //提示代码
				s:PDPLastId'="" PDTDesc=$p($g(^DHCPHDISTR(PDPLastId)),"^",2)  //诊断逻辑推导目录
				s:PDPLastId="" PDTDesc=""
				s PDPPromptVal=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",4) //提示目录值
				s PDPLabelDrF=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",2) //提示目录
				s PDPLabelDrFF=PDPLabelDrF
				s PDPSysFlag=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",5) //是否系统标识
				s:PDPSysFlag="" PDPSysFlag="Y"
				s PDPSysFlagF=""
				s:PDPLabelDrF'="" PDPLabelDrDesc=$p($g(^DHCPHGULA(PDPLabelDrF)),"^",2)  //提示目录描述
				s:PDPLabelDrF="" PDPLabelDrDesc=""
				s PDPLabelDr=PDPLabelDrDesc
				s PDPPromptDesc=""
				s PDPPrompt=""
				if PDPLabelDrF'=""
				{
					if PDPLabelDrDesc["症状" s PDPPromptDesc=$p($g(^DHCPHKW(PDPPromptF)),"^",2)
					if PDPLabelDrDesc["检验" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPromptF)),"^",2)
					if PDPLabelDrDesc["检查" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPromptF)),"^",2)
					if PDPLabelDrDesc["诊断" s PDPPromptDesc=$p($g(^DHCPHDISL(PDPPromptF)),"^",2)
					s PDPPrompt=PDPPromptDesc
				}
				if ((PDPLastId=lastid)||(lastid=""))&&((PDPLabelDrF=labeldr)||(labeldr=""))
				{
					d OutputNewRow
				}
			
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc,PDPLabelDrF,PDPPromptF,PDPLabelDrFF,PDPSysFlagF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewListExecute ]
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

/// Creator:石萧伟
/// CreatDate: 2018-08-16
/// Description：修改时打开的数据
/// Table：User.DHCPHDisLabelPrompt
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDisLabelPrompt).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDisLabelPrompt).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelPrompt).%New()
	s eobj.PDPRowId=id
	if $IsObject(pobj.PDPLastId)
	{
		s eobj.PDPLastId = pobj.PDPLastId.%Id() 
	}
	if $IsObject(pobj.PDPLabelDr)
	{
		s eobj.PDPLabelDr = pobj.PDPLabelDr.%Id() 
	}
	s eobj.PDPPrompt = pobj.PDPPrompt
	s eobj.PDPPromptVal=pobj.PDPPromptVal
	s eobj.PDPSysFlag=pobj.PDPSysFlag 
	s:eobj.PDPSysFlag="" eobj.PDPSysFlag="Y"	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate: 2017-04-21
/// Description：修改时打开的数据
/// Table：User.DHCPHDisLabelPrompt
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDisLabelPrompt).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDisLabelPrompt).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelPrompt).%New()
	s eobj.PDPRowId=id
	if $IsObject(pobj.PDPLastId)
	{
		s eobj.PDPLastId = pobj.PDPLastId.%Id() 
	}
	if $IsObject(pobj.PDPLabelDr)
	{
		s eobj.PDPLabelDr = pobj.PDPLabelDr.%Id() 
	}
	s eobj.PDPPrompt = pobj.PDPPrompt
	s eobj.PDPPromptVal=pobj.PDPPromptVal
	s eobj.PDPSysFlag=pobj.PDPSysFlag 
	s:eobj.PDPSysFlag="Y" eobj.PDPSysFlag="true"	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate:2017-04-24
/// Description：校验数据是否重复
/// Table：User.DHCPHDisLabelPrompt
/// Input：
/// Other: w ##class(web.DHCBL.KB.DHCPHDisLabelPrompt).FormValidate("1","4","1","1")
ClassMethod FormValidate(id, lastid, labeldr, prompt) As %String
{
	n (id,lastid,labeldr,prompt)
	q:(lastid="")||(labeldr="")||(prompt="") 0
	S flag=0
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHDISLPROi(0,"Label",lastid,labeldr,RowId)) q:RowId=""
		s PDPPrompt=$p($g(^DHCPHDISLPRO(RowId)),"^",3)
		if (prompt=PDPPrompt)&((id="")||((id'=RowId)&(id'="")))
		{
		
			S flag=1
		}
	
	}
	q flag
}

/// Creator:chenying
/// CreatDate: 2017-04-21
/// Description：保存推导目录提示字典的内容
/// Table：User.DHCPHDisLabelPrompt
/// Input：web.Entity.KB.DHCPHDisLabelPrompt 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLabelPrompt).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDisLabelPrompt) As %String
{
	n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.PDPSysFlag="" eobj.PDPSysFlag="N"
		if (eobj.PDPLastId="")||(eobj.PDPLabelDr="")||(eobj.PDPPrompt="") q "{success:'false',errorinfo:'数据不合理，请查看！'}"
		s flag= ##class(web.DHCBL.KB.DHCPHDisLabelPrompt).FormValidate(eobj.PDPRowId,eobj.PDPLastId,eobj.PDPLabelDr,eobj.PDPPrompt)
		if flag=1
		{
			s result ="{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
		
			s Desc=$p($g(^DHCPHDISTR(eobj.PDPLastId)),"^",2)_"-"_$p($g(^DHCPHGULA(eobj.PDPLabelDr)),"^",2)
			if (eobj.PDPRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHDisLabelPrompt).%New()
			
			}
			else                     //如果RowId已赋值则修改
			{
			
			
				s obj=##class(User.DHCPHDisLabelPrompt).%OpenId(eobj.PDPRowId)
				s bobj=##class(web.Entity.KB.DHCPHDisLabelPrompt).%New()
				s bobj.PDPRowId=eobj.PDPRowId
				if $IsObject(obj.PDPLastId)
				{
					s bobj.PDPLastId = obj.PDPLastId.%Id() 
				}
				if $IsObject(obj.PDPLabelDr)
				{
					s bobj.PDPLabelDr = obj.PDPLabelDr.%Id() 
				}
				s bobj.PDPPrompt = obj.PDPPrompt
				s bobj.PDPPromptVal=obj.PDPPromptVal
				s bobj.PDPSysFlag=obj.PDPSysFlag     
			}	
			
			d obj.PDPLastIdSetObjectId(eobj.PDPLastId)
			d obj.PDPLabelDrSetObjectId(eobj.PDPLabelDr)
			s obj.PDPPrompt=eobj.PDPPrompt
			s obj.PDPPromptVal=eobj.PDPPromptVal
			s obj.PDPSysFlag=eobj.PDPSysFlag
		
	

			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc)
			{
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.PDPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelPrompt","User.DHCPHDisLabelPrompt","推导目录提示",id,Desc,"A",eobj)
				d:eobj.PDPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelPrompt","User.DHCPHDisLabelPrompt","推导目录提示",eobj.PDPRowId,Desc,"U",eobj,bobj)
		
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录提示","web.DHCBL.KB.DHCPHDisLabelPrompt","SaveData",eobj)
				s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
			
		}			
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:chenying
/// CreatDate: 2017-04-21
/// Description：根据ID删除推导目录提示的内容
/// Table：User.DHCPHDisLabelPrompt
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDisLabelPrompt).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelPrompt).%New()
	s eobj.PDPRowId = id
	if $IsObject(pobj.PDPLastId)
	{
		s eobj.PDPLastId = pobj.PDPLastId.%Id() 
	}
	if $IsObject(pobj.PDPLabelDr)
	{
		s eobj.PDPLabelDr = pobj.PDPLabelDr.%Id() 
	}
	s eobj.PDPPrompt = pobj.PDPPrompt
	
	s eobj.PDPPromptVal=pobj.PDPPromptVal
	s eobj.PDPSysFlag=pobj.PDPSysFlag 	
	
	s Desc=eobj.PDPLastId_"-"_eobj.PDPLabelDr
	if (eobj.PDPLastId'="")&&(eobj.PDPLabelDr'="") s Desc=$p($g(^DHCPHDISTR(eobj.PDPLastId)),"^",2)_"-"_$p($g(^DHCPHGULA(eobj.PDPLabelDr)),"^",2)
	
	
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDisLabelPrompt).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelPrompt","User.DHCPHDisLabelPrompt","推导目录提示",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录提示","web.DHCBL.KB.DHCPHDisLabelPrompt","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：查询推导目录提示的内容
/// Table：User.DHCPHDisLabelPrompt
/// Return:PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLabelPrompt","GetList","","","")
Query GetList(rowid As %String, lastid As %String, labeldr As %String) As %Query(ROWSPEC = "PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, lastid As %String, labeldr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDPRowId=rowid
		s PDPLastId=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",1) //提示代码
		s:PDPLastId'="" PDTDesc=$p($g(^DHCPHDISTR(PDPLastId)),"^",2)  //诊断逻辑推导目录
		s:PDPLastId="" PDTDesc=""
		s PDPLabelDr=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",2) //提示目录
		s PDPPrompt=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",3) //提示目录id
		
		s PDPPromptVal=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",4) //提示目录值
		
		s PDPSysFlag=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",5) //是否系统标识
		s:PDPSysFlag="" PDPSysFlag="Y"
		
		s:PDPLabelDr'="" PDPLabelDrDesc=$p($g(^DHCPHGULA(PDPLabelDr)),"^",2)  //提示目录描述
		s:PDPLabelDr="" PDPLabelDrDesc=""
		
		s PDPPromptDesc=""
		if PDPLabelDr'=""
		{
			if PDPLabelDrDesc["症状" s PDPPromptDesc=$p($g(^DHCPHKW(PDPPrompt)),"^",2)
			if PDPLabelDrDesc["检验" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPrompt)),"^",2)
			if PDPLabelDrDesc["检查" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPrompt)),"^",2)
			if PDPLabelDrDesc["诊断" s PDPPromptDesc=$p($g(^DHCPHDISL(PDPPrompt)),"^",2)
			
		}
		d OutputRow		
	}
	else
	{ 
		if lastid'=""
		{
			s PDPRowId=0
			for 
			{
				S PDPRowId=$o(^DHCPHDISLPROi(0,"LastId",lastid,PDPRowId)) q:PDPRowId=""
				s PDPPrompt=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",3) //提示目录id
				s PDPLastId=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",1) //提示代码
				s:PDPLastId'="" PDTDesc=$p($g(^DHCPHDISTR(PDPLastId)),"^",2)  //诊断逻辑推导目录
				s:PDPLastId="" PDTDesc=""
				s PDPPromptVal=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",4) //提示目录值
				s PDPLabelDr=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",2) //提示目录
				s PDPSysFlag=$p($g(^DHCPHDISLPRO(PDPRowId)),"^",5) //是否系统标识
				s:PDPSysFlag="" PDPSysFlag="Y"
				s:PDPLabelDr'="" PDPLabelDrDesc=$p($g(^DHCPHGULA(PDPLabelDr)),"^",2)  //提示目录描述
				s:PDPLabelDr="" PDPLabelDrDesc=""
				s PDPPromptDesc=""
				if PDPLabelDr'=""
				{
					if PDPLabelDrDesc["症状" s PDPPromptDesc=$p($g(^DHCPHKW(PDPPrompt)),"^",2)
					if PDPLabelDrDesc["检验" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPrompt)),"^",2)
					if PDPLabelDrDesc["检查" s PDPPromptDesc=$p($g(^DHCPHEGEN(PDPPrompt)),"^",2)
					if PDPLabelDrDesc["诊断" s PDPPromptDesc=$p($g(^DHCPHDISL(PDPPrompt)),"^",2)
					
				}
				if ((PDPLastId=lastid)||(lastid=""))&&((PDPLabelDr=labeldr)||(labeldr=""))
				{
					d OutputRow
				}
			
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDPRowId,PDPPrompt,PDPLastId,PDTDesc,PDPPromptVal,PDPLabelDr,PDPLabelDrDesc,PDPSysFlag,PDPPromptDesc)
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
