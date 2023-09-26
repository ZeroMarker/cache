Import SQLUser

/// 名称: 推导目录明细维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-04-19
Class web.DHCBL.KB.DHCPHDisLabelItm Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：修改时打开的数据
/// Table：User.DHCPHDisLabelItm
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDisLabelItm).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDisLabelItm).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelItm).%New()
	s eobj.PDLIRowId=id
	
	/*if $IsObject(pobj.PDLIKeyWord)
	{
		s eobj.PDLIKeyWord = pobj.PDLIKeyWord.%Id() 
	}*/
	s eobj.PDLIKeyWord = pobj.PDLIKeyWord
	
	if $IsObject(pobj.PDLIId)
	{
		s eobj.PDLIId = pobj.PDLIId.%Id() 
	}
	if $IsObject(pobj.PDLIGenDr)
	{
		s eobj.PDLIGenDr = pobj.PDLIGenDr.%Id() 
	}
	s eobj.PDLIVal=pobj.PDLIVal
	s eobj.PDLIOperator=pobj.PDLIOperator
	s eobj.PDLIResultText=pobj.PDLIResultText
	s eobj.PDLIRelation=pobj.PDLIRelation
	s eobj.PDLISysFlag=pobj.PDLISysFlag 
	s:eobj.PDLISysFlag="" eobj.PDLISysFlag="Y"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：修改时打开的数据
/// Table：User.DHCPHDisLabelItm
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDisLabelItm).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDisLabelItm).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelItm).%New()
	s eobj.PDLIRowId=id
	
	/*if $IsObject(pobj.PDLIKeyWord)
	{
		s eobj.PDLIKeyWord = pobj.PDLIKeyWord.%Id() 
	}*/
	s eobj.PDLIKeyWord = pobj.PDLIKeyWord
	
	if $IsObject(pobj.PDLIId)
	{
		s eobj.PDLIId = pobj.PDLIId.%Id() 
	}
	if $IsObject(pobj.PDLIGenDr)
	{
		s eobj.PDLIGenDr = pobj.PDLIGenDr.%Id() 
	}
	s eobj.PDLIVal=pobj.PDLIVal
	s eobj.PDLIOperator=pobj.PDLIOperator
	s eobj.PDLIResultText=pobj.PDLIResultText
	s eobj.PDLIRelation=pobj.PDLIRelation
	s eobj.PDLISysFlag=pobj.PDLISysFlag 
	s:eobj.PDLISysFlag="Y" eobj.PDLISysFlag="true"
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：保存推导目录明细字典的内容
/// Table：User.DHCPHDisLabelItm
/// Input：web.Entity.KB.DHCPHDisLabelItm 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDisLabelItm).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDisLabelItm) As %String
{
	n (eobj,%session)
	s result=""
	s:eobj.PDLISysFlag="" eobj.PDLISysFlag="N"
	if $IsObject(eobj)
	{
		s Desc=eobj.PDLIGenDr
		if (eobj.PDLIRowId="")  //如果RowId未赋值则增加
		{
			s args=eobj.PDLIGenDr
			s argsLen=$Length(args,",")
			s ids = ""
			for i=1:1:argsLen
			{
				s eobj.PDLIGenDr=$p(args,",",i)	
				if eobj.PDLIGenDr'=""
				{	
					s Desc=$p($g(^DHCPHEGEN(eobj.PDLIGenDr)),"^",2)
					s GenDrd=$d(^DHCPHDISLITMi(0,"GenDr",eobj.PDLIId,+eobj.PDLIGenDr))
					if (GenDrd'=0)
					{
						s result = "{success:'false',errorinfo:'该记录已经存在！'}"
						continue
					}
					
				}
				
				if eobj.PDLIKeyWord'=""
				{
					s Desc=$p($g(^DHCPHKW(eobj.PDLIKeyWord)),"^",2)
					s KeyWordd=$d(^DHCPHDISLITMi(0,"KeyWord",eobj.PDLIId,+eobj.PDLIKeyWord))
					if (KeyWordd'=0)
					{
						s result = "{success:'false',errorinfo:'该记录已经存在！'}"
						continue
					}
				}
				
			
				
				s obj=##class(User.DHCPHDisLabelItm).%New() 
				///d obj.PDLIKeyWordSetObjectId(eobj.PDLIKeyWord)
				s obj.PDLIKeyWord=eobj.PDLIKeyWord
				d obj.PDLIIdSetObjectId(eobj.PDLIId)
				d obj.PDLIGenDrSetObjectId(eobj.PDLIGenDr)
				s obj.PDLIVal=eobj.PDLIVal
				s obj.PDLIOperator=eobj.PDLIOperator
				s obj.PDLIResultText=eobj.PDLIResultText
				s obj.PDLIRelation=eobj.PDLIRelation
				s obj.PDLISysFlag=eobj.PDLISysFlag
				
			
		
				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc)
				{
					Tcommit
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelItm","User.DHCPHDisLabelItm","推导目录明细",id,Desc,"A",eobj)
				}
				else
				{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录明细","web.DHCBL.KB.DHCPHDisLabelItm","SaveData",eobj)
 					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
			}
		}
		else                     //如果RowId已赋值则修改
		{
			if eobj.PDLIGenDr'=""
			{	
				s Desc=$p($g(^DHCPHEGEN(eobj.PDLIGenDr)),"^",2)
				s GenDrd=$d(^DHCPHDISLITMi(0,"GenDr",eobj.PDLIId,+eobj.PDLIGenDr))
				s GenDrID=$o(^DHCPHDISLITMi(0,"GenDr",eobj.PDLIId,eobj.PDLIGenDr,0))
			
				if (GenDrID'="")&&(GenDrd>0)&&(GenDrID'=eobj.PDLIRowId)
				{
					Q "{success:'false',errorinfo:'该记录已经存在！'}"
				
				}
				
			}
			
			if eobj.PDLIKeyWord'=""
			{
				s Desc=$p($g(^DHCPHKW(eobj.PDLIKeyWord)),"^",2)
				s KeyWordd=$d(^DHCPHDISLITMi(0,"KeyWord",eobj.PDLIId,+eobj.PDLIKeyWord))
				s KeyWordID=$o(^DHCPHDISLITMi(0,"KeyWord",eobj.PDLIId,eobj.PDLIKeyWord,0))
			
				if (KeyWordID'="")&&(KeyWordd>0)&&(KeyWordID'=eobj.PDLIRowId)
				{
					Q "{success:'false',errorinfo:'该记录已经存在！'}"
				
				}
				
			}
			s obj=##class(User.DHCPHDisLabelItm).%OpenId(eobj.PDLIRowId)
			s bobj=##class(web.Entity.KB.DHCPHDisLabelItm).%New()
			s bobj.PDLIRowId=eobj.PDLIRowId

			/*if $IsObject(obj.PDLIKeyWord)
			{
				s bobj.PDLIKeyWord = obj.PDLIKeyWord.%Id() 
			}*/
			s bobj.PDLIKeyWord = obj.PDLIKeyWord
			
			if $IsObject(obj.PDLIId)
			{
				s bobj.PDLIId = obj.PDLIId.%Id() 
			}
			if $IsObject(obj.PDLIGenDr)
			{
				s bobj.PDLIGenDr = obj.PDLIGenDr.%Id() 
			}
			s bobj.PDLIVal=obj.PDLIVal
			s bobj.PDLIOperator=obj.PDLIOperator
			s bobj.PDLIResultText=obj.PDLIResultText
			s bobj.PDLIRelation=obj.PDLIRelation
			s bobj.PDLISysFlag=obj.PDLISysFlag     
	
			
			
			//d obj.PDLIKeyWordSetObjectId(eobj.PDLIKeyWord)
			s obj.PDLIKeyWord=eobj.PDLIKeyWord
			d obj.PDLIIdSetObjectId(eobj.PDLIId)
			d obj.PDLIGenDrSetObjectId(eobj.PDLIGenDr)
			s obj.PDLIVal=eobj.PDLIVal
			s obj.PDLIOperator=eobj.PDLIOperator
			s obj.PDLIResultText=eobj.PDLIResultText
			s obj.PDLIRelation=eobj.PDLIRelation
			s obj.PDLISysFlag=eobj.PDLISysFlag
				     	
			Ts					
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//修改时，日志
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelItm","User.DHCPHDisLabelItm","推导目录明细",eobj.PDLIRowId,Desc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录明细","web.DHCBL.KB.DHCPHDisLabelItm","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
/// CreatDate:2017-04-19
/// Description：根据ID删除推导目录明细的内容
/// Table：User.DHCPHDisLabelItm
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDisLabelItm).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDisLabelItm).%New()
	s eobj.PDLIRowId = id

	/*if $IsObject(pobj.PDLIKeyWord)
	{
		s eobj.PDLIKeyWord = pobj.PDLIKeyWord.%Id() 
	}*/
	s eobj.PDLIKeyWord = pobj.PDLIKeyWord
	
	if $IsObject(pobj.PDLIId)
	{
		s eobj.PDLIId = pobj.PDLIId.%Id() 
	}
	if $IsObject(pobj.PDLIGenDr)
	{
		s eobj.PDLIGenDr = pobj.PDLIGenDr.%Id() 
	}
	s eobj.PDLIVal=pobj.PDLIVal
	s eobj.PDLIOperator=pobj.PDLIOperator
	s eobj.PDLIResultText=pobj.PDLIResultText
	s eobj.PDLIRelation=pobj.PDLIRelation
	s eobj.PDLISysFlag=pobj.PDLISysFlag  
	s Desc=eobj.PDLIGenDr
	if eobj.PDLIGenDr'=""
	{	
		s Desc=$p($g(^DHCPHEGEN(eobj.PDLIGenDr)),"^",2)	
	}
	if eobj.PDLIKeyWord'=""
	{
		s Desc=$p($g(^DHCPHKW(eobj.PDLIKeyWord)),"^",2)
	}
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDisLabelItm).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDisLabelItm","User.DHCPHDisLabelItm","推导目录明细",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("推导目录明细","web.DHCBL.KB.DHCPHDisLabelItm","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：查询推导目录明细的内容
/// Table：User.DHCPHDisLabelItm
/// Return:PDLIRowId,PDLIId,PDLIGenDr,PHEGDesc,PDLIVal,PDLIOperator,PDLIResultText,PDLIKeyWord,PHKWDesc,PDLIRelation,PDLISysFlag
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDisLabelItm","GetList","","","")
Query GetList(rowid As %String, pdliid As %String, gendr As %String, keyword As %String) As %Query(ROWSPEC = "PDLIRowId,PDLIId,PDLIGenDr,PHEGDesc,PDLIVal,PDLIOperator,PDLIResultText,PDLIKeyWord,PHKWDesc,PDLIRelation,PDLISysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, pdliid As %String, gendr As %String, keyword As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDLIRowId=rowid
		s PDLIId=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",1) //推导目录
		s PDLIGenDr=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",2) //通用名字典
		s:PDLIGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PDLIGenDr)),"^",2)  //通用名描述
		s:PDLIGenDr="" PHEGDesc=""
		s PDLIVal=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",3)   //检验值
		s PDLIOperator=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",4)  //运算符
		s PDLIResultText=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",5) //结果
		s PDLIKeyWord=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",6) //关键字
		s PDLIRelation=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",7) //逻辑
		s PDLISysFlag=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",8) //是否系统标识	
		s:PDLISysFlag="" PDLISysFlag="Y"		
		
		
		s PDLLabelDrID="",LabelDrDesc=""
		s:PDLIId'="" PDLLabelDrID=$p($g(^DHCPHDISLILA(PDLIId)),"^",1)
		s:PDLLabelDrID'="" LabelDrDesc=$p($g(^DHCPHGULA(PDLLabelDrID)),"^",2)		
		if PDLIKeyWord'=""
		{
			if LabelDrDesc["症状" s PHKWDesc=$p($g(^DHCPHKW(PDLIKeyWord)),"^",2)  //知识库关键字描述
			if LabelDrDesc["诊断" s PHKWDesc=$p($g(^DHCPHDISL(PDLIKeyWord)),"^",2)   ///病症描述
			
		}
		else
		{
			s PHKWDesc=""
		}
		d OutputRow		
	}
	else
	{
		s PDLIRowId=0
		for 
		{
			S PDLIRowId=$o(^DHCPHDISLITMi(0,"LinkLabel",pdliid,PDLIRowId)) q:PDLIRowId=""
			s PDLIId=pdliid //推导目录
			s PDLIGenDr=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",2) //通用名字典
			s:PDLIGenDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PDLIGenDr)),"^",2)  //通用名描述
			s:PDLIGenDr="" PHEGDesc=""
			s PDLIVal=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",3)   //检验值
			s PDLIOperator=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",4)  //运算符
			s PDLIResultText=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",5) //结果
			s PDLIKeyWord=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",6) //关键字
			s PDLLabelDrID="",LabelDrDesc=""
			s:PDLIId'="" PDLLabelDrID=$p($g(^DHCPHDISLILA(PDLIId)),"^",1)
			s:PDLLabelDrID'="" LabelDrDesc=$p($g(^DHCPHGULA(PDLLabelDrID)),"^",2)		
			if PDLIKeyWord'=""
			{
				if LabelDrDesc["症状" s PHKWDesc=$p($g(^DHCPHKW(PDLIKeyWord)),"^",2)  //知识库关键字描述
				if LabelDrDesc["诊断" s PHKWDesc=$p($g(^DHCPHDISL(PDLIKeyWord)),"^",2)   ///病症描述
			
			}
			else
			{
				s PHKWDesc=""
			}
			
			s PDLIRelation=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",7) //逻辑
			s PDLISysFlag=$p($g(^DHCPHDISLITM(PDLIRowId)),"^",8) //是否系统标识
			s:PDLISysFlag="" PDLISysFlag="Y"

			if ((PDLIGenDr=gendr)||(gendr=""))&&((PDLIKeyWord=keyword)||(keyword=""))
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDLIRowId,PDLIId,PDLIGenDr,PHEGDesc,PDLIVal,PDLIOperator,PDLIResultText,PDLIKeyWord,PHKWDesc,PDLIRelation,PDLISysFlag)
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

/// d ##class(web.DHCBL.KB.DHCPHDisLabelItm).DeleteDataAll()
ClassMethod DeleteDataAll(PDLIId As %String) As %String
{
	s PDLIRowId=0
	s count=0
	for 
	{
		s PDLIRowId=$o(^DHCPHDISLITMi(0,"LinkLabel",PDLIId,PDLIRowId)) q:PDLIRowId=""
		s count=count+1
		s rtn = ..DeleteData(PDLIRowId)
	}
	s:count=0 rtn="{success:'true',info:'删除成功！'}"
	q rtn
}

}
