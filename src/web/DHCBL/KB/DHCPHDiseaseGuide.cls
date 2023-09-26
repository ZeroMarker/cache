/// 名称: 确诊病症指南维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-04-19
Class web.DHCBL.KB.DHCPHDiseaseGuide Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:石萧伟
/// CreatDate:2018-08-14
/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseGuide
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseGuide).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseGuide).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseGuide).%New()
	s eobj.PDGRowId=id
	if $IsObject(pobj.PDGDisDr)
	{
		s eobj.PDGDisDr = pobj.PDGDisDr.%Id() 
	}
	if $IsObject(pobj.PDGLabelDr)
	{
		s eobj.PDGLabelDr = pobj.PDGLabelDr.%Id() 
	}
	s eobj.PDGId = pobj.PDGId
	
	s eobj.PDGText=pobj.PDGText
	s eobj.PDGSysFlag=pobj.PDGSysFlag 
	s:eobj.PDGSysFlag="" eobj.PDGSysFlag="Y"	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseGuide
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseGuide).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s pobj = ##class(User.DHCPHDiseaseGuide).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseGuide).%New()
	s eobj.PDGRowId=id
	if $IsObject(pobj.PDGDisDr)
	{
		s eobj.PDGDisDr = pobj.PDGDisDr.%Id() 
	}
	if $IsObject(pobj.PDGLabelDr)
	{
		s eobj.PDGLabelDr = pobj.PDGLabelDr.%Id() 
	}
	s eobj.PDGId = pobj.PDGId
	
	s eobj.PDGText=pobj.PDGText
	s eobj.PDGSysFlag=pobj.PDGSysFlag 
	s:eobj.PDGSysFlag="Y" eobj.PDGSysFlag="true"	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：校验数据是否重复
/// Table：User.DHCPHDiseaseGuide
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseGuide).FormValidate("1","2169","1","1")
ClassMethod FormValidate(id, disdr, labeldr, pdgid) As %String
{
	n (id,disdr,labeldr,pdgid)
	q:(disdr="")||(labeldr="")||(pdgid="") 0
	S flag=0
	s RowId=0
	for
	{
		s RowId=$o(^DHCPHDISGUi(0,"Label",disdr,labeldr,RowId)) q:RowId=""
		s PDGId=$p($g(^DHCPHDISGU(RowId)),"^",3)
		if (pdgid=PDGId)&((id="")||((id'=RowId)&(id'="")))
		{
		
			S flag=1
		}
	
	}
	q flag
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：保存确诊病症指南字典的内容
/// Table：User.DHCPHDiseaseGuide
/// Input：web.Entity.KB.DHCPHDiseaseGuide 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseGuide).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseGuide) As %String
{
	n (eobj,%session)
	s result=""

	if $IsObject(eobj)
	{
		if (eobj.PDGDisDr="")||(eobj.PDGLabelDr="")||(eobj.PDGId="") q "{success:'false',errorinfo:'数据不合理，请查看！'}"
		s:eobj.PDGSysFlag="" eobj.PDGSysFlag="N"
		s flag= ##class(web.DHCBL.KB.DHCPHDiseaseGuide).FormValidate(eobj.PDGRowId,eobj.PDGDisDr,eobj.PDGLabelDr,eobj.PDGId)
		if flag=1
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s Desc=$p($g(^DHCPHDISL(eobj.PDGDisDr)),"^",2)_"-"_$p($g(^DHCPHGULA(eobj.PDGLabelDr)),"^",2)
		if (eobj.PDGRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.DHCPHDiseaseGuide).%New()
		}
		else                     //如果RowId已赋值则修改
		{
			s obj=##class(User.DHCPHDiseaseGuide).%OpenId(eobj.PDGRowId)
			s bobj=##class(web.Entity.KB.DHCPHDiseaseGuide).%New()
			s bobj.PDGRowId=eobj.PDGRowId
			if $IsObject(obj.PDGDisDr)
			{
				s bobj.PDGDisDr = obj.PDGDisDr.%Id() 
			}
			if $IsObject(obj.PDGLabelDr)
			{
				s bobj.PDGLabelDr = obj.PDGLabelDr.%Id() 
			}
			s bobj.PDGId = obj.PDGId
			s bobj.PDGText=obj.PDGText
			s bobj.PDGSysFlag=obj.PDGSysFlag     
	
		}
		d obj.PDGDisDrSetObjectId(eobj.PDGDisDr)
		d obj.PDGLabelDrSetObjectId(eobj.PDGLabelDr)
		s obj.PDGId=eobj.PDGId
		s obj.PDGText=eobj.PDGText
		s obj.PDGSysFlag=eobj.PDGSysFlag
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc)
		{
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.PDGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseGuide","User.DHCPHDiseaseGuide","确诊病症指南",id,Desc,"A",eobj)
			d:eobj.PDGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseGuide","User.DHCPHDiseaseGuide","确诊病症指南",eobj.PDGRowId,Desc,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("确诊病症指南","web.DHCBL.KB.DHCPHDiseaseGuide","SaveData",eobj)
			s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
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
/// Description：根据ID删除确诊病症指南的内容
/// Table：User.DHCPHDiseaseGuide
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	n (id,%session)
	s result = ""
	//new Entity对象，用于保存日志
	s pobj=##class(User.DHCPHDiseaseGuide).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseGuide).%New()
	s eobj.PDGRowId = id
	if $IsObject(pobj.PDGDisDr)
	{
		s eobj.PDGDisDr = pobj.PDGDisDr.%Id() 
	}
	if $IsObject(pobj.PDGLabelDr)
	{
		s eobj.PDGLabelDr = pobj.PDGLabelDr.%Id() 
	}
	s eobj.PDGId = pobj.PDGId
	
	s eobj.PDGText=pobj.PDGText
	s eobj.PDGSysFlag=pobj.PDGSysFlag 	
	
	s Desc=eobj.PDGDisDr_"-"_eobj.PDGLabelDr
	if (eobj.PDGDisDr'="")&&(eobj.PDGLabelDr'="") s Desc=$p($g(^DHCPHDISL(eobj.PDGDisDr)),"^",2)_"-"_$p($g(^DHCPHGULA(eobj.PDGLabelDr)),"^",2)
	
	
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCPHDiseaseGuide).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseGuide","User.DHCPHDiseaseGuide","确诊病症指南",id,Desc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("确诊病症指南","web.DHCBL.KB.DHCPHDiseaseGuide","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:chenying
/// CreatDate:2017-04-19
/// Description：查询确诊病症指南的内容
/// Table：User.DHCPHDiseaseGuide
/// Return:PDGRowId,PDGId,PDGDisDr,PHDISLDiseaDesc,PDGText,PDGLabelDr,PDGLabelDrDesc,PDGSysFlag
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseGuide","GetList","","2334","")
Query GetList(rowid As %String, disdr As %String, labeldr As %String) As %Query(ROWSPEC = "PDGRowId,PDGId,PDGIdDesc,PDGDisDr,PHDISLDiseaDesc,PDGLabelDr,PDGLabelDrDesc,PDGText,PDGSysFlag,PDGLabelDrF,PDGIdF,PDGTextF,PDGLabelDrFF,PDGSysFlagF,PDGTextF")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, disdr As %String, labeldr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDGRowId=rowid
		s PDGIdF=$p($g(^DHCPHDISGU(PDGRowId)),"^",3) //关联id
		s PDGDisDr=$p($g(^DHCPHDISGU(PDGRowId)),"^",1) //关联病症
		s PHDISLDiseaDesc=""
		s:PDGDisDr'="" PHDISLDiseaDesc=$p($g(^DHCPHDISL(PDGDisDr)),"^",2)  //病症描述
		s PDGText=$p($g(^DHCPHDISGU(PDGRowId)),"^",4) //文本
		s PDGLabelDrF=$p($g(^DHCPHDISGU(PDGRowId)),"^",2) //关联目录
		s PDGLabelDrFF=PDGLabelDrF
		//s PDGLabelDrF=PDGLabelDr
		s PDGSysFlag=$p($g(^DHCPHDISGU(PDGRowId)),"^",5) //是否系统标识
		s:PDGSysFlag="" PDGSysFlag="Y"
		
		s PDGLabelDrDesc=""
		s:PDGLabelDr'="" PDGLabelDrDesc=$p($g(^DHCPHGULA(PDGLabelDr)),"^",2)  //关联目录描述
		s PDGSysFlagF=""
		s PDGTextF=""
		s PDGLabelDr=PDGLabelDrDesc
		s PDGIdDesc=""
		s PDGId=""
		if PDGLabelDrF'=""
		{
			if PDGLabelDrDesc["症状" s PDGIdDesc=$p($g(^DHCPHKW(PDGIdF)),"^",2)
			if PDGLabelDrDesc["检验" s PDGIdDesc=$p($g(^DHCPHEGEN(PDGIdF)),"^",2)
			if PDGLabelDrDesc["检查" s PDGIdDesc=$p($g(^DHCPHEGEN(PDGIdF)),"^",2)
			if PDGLabelDrDesc["诊断" s PDGIdDesc=$p($g(^DHCPHDISL(PDGIdF)),"^",2)
			s PDGId=PDGIdDesc
		}
		d OutputRow		
	}
	else
	{ 
		if disdr'=""
		{
			
			
			s PDGRowId=0
			for 
			{
				S PDGRowId=$o(^DHCPHDISGUi(0,"Dis",disdr,PDGRowId)) q:PDGRowId=""
				s PDGIdF=$p($g(^DHCPHDISGU(PDGRowId)),"^",3) //关联id
				//s PDGIdF=PDGId
				s PDGDisDr=$p($g(^DHCPHDISGU(PDGRowId)),"^",1) //关联病症
				s PHDISLDiseaDesc=""
				s:PDGDisDr'="" PHDISLDiseaDesc=$p($g(^DHCPHDISL(PDGDisDr)),"^",2)  //病症描述
				
				s PDGText=$p($g(^DHCPHDISGU(PDGRowId)),"^",4) //关联结果
				s PDGTextF=PDGText
				s PDGLabelDrF=$p($g(^DHCPHDISGU(PDGRowId)),"^",2) //关联目录
				s PDGLabelDrFF=PDGLabelDrF
				//s PDGLabelDrF=PDGLabelDr
				s PDGSysFlag=$p($g(^DHCPHDISGU(PDGRowId)),"^",5) //是否系统标识
				s:PDGSysFlag="" PDGSysFlag="Y"
				s PDGLabelDrDesc=""
				s:PDGLabelDrF'="" PDGLabelDrDesc=$p($g(^DHCPHGULA(PDGLabelDrF)),"^",2)  //关联目录描述
				s PDGSysFlagF=""
				s PDGTextF=""				
				s PDGLabelDr=PDGLabelDrDesc
				s PDGIdDesc=""
				s PDGId=""
				if (PDGLabelDrF'="")&(PDGIdF'="")
				{
					if PDGLabelDrDesc["症状" s PDGIdDesc=$p($g(^DHCPHKW(PDGIdF)),"^",2)
					if PDGLabelDrDesc["检验" s PDGIdDesc=$p($g(^DHCPHEGEN(PDGIdF)),"^",2)
					if PDGLabelDrDesc["检查" s PDGIdDesc=$p($g(^DHCPHEGEN(PDGIdF)),"^",2)
					if PDGLabelDrDesc["诊断" s PDGIdDesc=$p($g(^DHCPHDISL(PDGIdF)),"^",2)
					s PDGId=PDGIdDesc
					
				}
				if ((PDGDisDr=disdr)||(disdr=""))&&((PDGLabelDrF=labeldr)||(labeldr=""))      
				{
					d OutputRow
				}
			
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDGRowId,PDGId,PDGIdDesc,PDGDisDr,PHDISLDiseaDesc,PDGLabelDr,PDGLabelDrDesc,PDGText,PDGSysFlag,PDGLabelDrF,PDGIdF,PDGTextF,PDGLabelDrFF,PDGSysFlagF,PDGTextF)
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

/// Creator:谷雪萍
/// CreatDate:2017-04-13
/// Description:查询 2017-4-13
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseGuide","GetIDDataForCmb","","")
Query GetIDDataForCmb(rowid As %String, desc As %String, labeldr As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetIDDataForCmbExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, labeldr As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if labeldr'=""
	{
		s PDGLabelDrDesc=$p($g(^DHCPHGULA(labeldr)),"^",2)
		if (rowid'="") //根据rowid返回该条记录
		{

			s RowId=rowid
			s Desc=""
			if PDGLabelDrDesc["检验" s Desc=$p($g(^DHCPHEGEN(RowId)),"^",2)
			if PDGLabelDrDesc["检查" s Desc=$p($g(^DHCPHEGEN(RowId)),"^",2)
			if PDGLabelDrDesc["诊断" s Desc=$p($g(^DHCPHDISL(RowId)),"^",2)
			if PDGLabelDrDesc["症状" s Desc=$p($g(^DHCPHKW(RowId)),"^",2)
			d OutputRowCmb	
		}
		else
		{ 
			if PDGLabelDrDesc["症状"
			{
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHKW(RowId)) q:RowId="" 
					s Desc=$p($g(^DHCPHKW(RowId)),"^",2)
					s PHKWTypeFlag=$p($g(^DHCPHKW(RowId)),"^",5)  //分类标识
					continue:PHKWTypeFlag'="0"
					s PINYIN=""
					if (desc'="") s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					i ((Desc[desc)||(PINYIN[desc))
					{
						d OutputRowCmb
					}
					
					
				}
			}
			elseif PDGLabelDrDesc["检查"
			{
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHEGEN(RowId)) q:RowId="" 
					s Desc=$p($g(^DHCPHEGEN(RowId)),"^",2)
					s PHEGLibDr=$p($g(^DHCPHEGEN(RowId)),"^",7)  //知识库标识DR
					s PHLICode=""
					s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
					s:PHLICode'="" PHLICode=$ZCONVERT(PHLICode,"U") 
					continue:PHLICode'="CHECK"
					s PINYIN=""
					if (desc'="") s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					i ((Desc[desc)||(PINYIN[desc))
					{
						d OutputRowCmb
					}
					
				}
			}
			elseif PDGLabelDrDesc["检验"
			{
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHEGEN(RowId)) q:RowId="" 
					s Desc=$p($g(^DHCPHEGEN(RowId)),"^",2)
					s PHEGLibDr=$p($g(^DHCPHEGEN(RowId)),"^",7)  //知识库标识DR
					s PHLICode=""
					s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
					s:PHLICode'="" PHLICode=$ZCONVERT(PHLICode,"U") 
					continue:PHLICode'="LAB"
					s PINYIN=""
					if (desc'="") s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					i ((Desc[desc)||(PINYIN[desc))
					{
						d OutputRowCmb
					}
					
				}
			}
			elseif PDGLabelDrDesc["诊断"
			{
				s RowId=0
				for  
				{	
					s RowId=$o(^DHCPHDISL(RowId)) q:RowId="" 
					s Desc=$p($g(^DHCPHDISL(RowId)),"^",2)
					s PINYIN=""
					if (desc'="") s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
					i ((Desc[desc)||(PINYIN[desc))
					{
						d OutputRowCmb
					}
					
					
				}
			}
			
		}
	
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetIDDataForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIDDataForCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetIDDataForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIDDataForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
