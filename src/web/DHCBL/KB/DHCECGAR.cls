Import SQLUser

/// 名称: 不良反应 -- 注意事项
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCECGAR Extends %RegisteredObject
{

/// Description：打开不良反应数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCECGAR).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCECGAR).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存不良反应
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCECGAR 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCECGAR).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCECGAR) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTAdvRea","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ELECT","U"),0))	
			d objIns.PHINSTTypeDrSetObjectId(eobj.PHINSTTypeDr)		
			s objIns.PHINSTOrderNum=eobj.PHINSTOrderNum
			//d objIns.PHINSTGenDrSetObjectId(eobj.PHINSTGenDr)
			s objIns.PHINSTGenDr=eobj.PHINSTGenDr
			s objIns.PHINSTPointerDr=eobj.PHINSTPointerDr
			s objIns.PHINSTPointerType=eobj.PHINSTPointerType	
			d objIns.PHINSTLibDrSetObjectId(eobj.PHINSTLibDr)		
			s objIns.PHINSTActiveFlag=eobj.PHINSTActiveFlag
			s objIns.PHINSTSysFlag=eobj.PHINSTSysFlag
					
			s scIns=objIns.%Save()	
			d objIns.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = objIns.%Id()
				s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
				//新增时，日志
				//d:eobj.PDAIInstDr="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
			}
		
	
			s obj=##class(User.DHCPHAddInfo).%New()
								
			//s obj.PDAICode=eobj.PDAICode
			s obj.PDAIText=eobj.PHINSTText
			s obj.PDAIOrdNum=eobj.PDAIOrdNum
			s eobj.PDAIInstDr=Insid
			d obj.PDAIInstDrSetObjectId(eobj.PDAIInstDr)
					
			s sc=obj.%Save()	
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				//d:eobj.PHINSTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			
			if (result["true")
			{
				Tc
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-不良反应",Insid,eobj.PHINSTText,"A",eobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"
			}
	
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改不良反应
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCECGAR 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCECGAR).SaveData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCECGAR) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//修改主索引表
		Ts	
		//日志
		s bobj = ##class(web.Entity.KB.DHCECGAR).%New()		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PDAIInstDr)
		s bobj.PHINSTText=objIns.PHINSTText 
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		
		s objIns.PHINSTText=eobj.PHINSTText		
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
			s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
			//修改时，日志
			//d:eobj.PDAIInstDr'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"U",eobj,bobjIns)
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
		//修改不良反应表	
		//通过索引获取不良反应业务表的RowId——PDAIRowId
		s PDAIRowId=$o(^DHCPHADDI("0","Inst",eobj.PDAIInstDr,0))
		if (PDAIRowId'="")
		{	
			s obj=##class(User.DHCPHAddInfo).%OpenId(PDAIRowId)
			s bobj.PDAIText=obj.PDAIText
			s eobj.PDAIOrdNum=$p($g(^DHCPHADDI(PDAIRowId)),"^",3)
		}
		else
		{
			s obj=##class(User.DHCPHAddInfo).%New()
		}
				
		s eobj.PDAIText=eobj.PHINSTText
		s obj.PDAIText=eobj.PDAIText
		s obj.PDAIOrdNum=eobj.PDAIOrdNum
		d obj.PDAIInstDrSetObjectId(eobj.PDAIInstDr)
					
		s sc=obj.%Save()	
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			//修改时，日志
			//d:eobj.PHINSTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"U",eobj,bobjIns)
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-不良反应",Insid,eobj.PHINSTText,"U",eobj,bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}							
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2014-12-4
/// Description：查询不良反应、注意事项 查询病症业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCECGAR","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PDAIRowId,PDAICode,PDAIText,PDAIOrdNum,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s PDAIRowId=rowid
		s PDAICode=$p($g(^DHCPHADDI(PDAIRowId)),"^",1)
		s PDAIText=$p($g(^DHCPHADDI(PDAIRowId)),"^",2)
		s PDAIOrdNum=$p($g(^DHCPHADDI(PDAIRowId)),"^",3)
		s PDAIInstDr=$p($g(^DHCPHADDI(PDAIRowId)),"^",4)
		s PHINSTText = $p($g(^DHCPHINSTRUC(PDAIInstDr)),"^",15)  //不良反应、注意事项
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTAdvRea","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""								
			s PDAIRowId=$o(^DHCPHADDI("0","Inst",PHINSTRowId,0))
										
			s:PDAIRowId'="" PDAICode=$p($g(^DHCPHADDI(PDAIRowId)),"^",1)
			s:PDAIRowId'="" PDAIText=$p($g(^DHCPHADDI(PDAIRowId)),"^",2)
			s:PDAIRowId'="" PDAIOrdNum=$p($g(^DHCPHADDI(PDAIRowId)),"^",3)
			
			s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)  //不良反应、注意事项
			
			d OutputRow
			

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PDAIRowId,PDAICode,PDAIText,PDAIOrdNum,PHINSTText)
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

/// Description:根据id删除
/// Table:User.DHCPHInstructions
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCECGAR).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""		
		s InstDr=id
		Tstart
		//日志
		s bobj = ##class(web.Entity.KB.DHCCheckAR).%New()
		
		s PDAIRowId=$o(^DHCPHADDI("0","Inst",InstDr,0))
		if (PDAIRowId'=""){
			s obj=##class(User.DHCPHAddInfo).%OpenId(PDAIRowId)
			s bobj.PDAIText=obj.PDAIText
			
			s sc=##class(User.DHCPHAddInfo).%DeleteId(PDAIRowId)
			if $$$ISOK(sc){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}

		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(InstDr)
		s bobj.PHINSTText = pobjIns.PHINSTText 
		if $IsObject(pobjIns.PHINSTTypeDr){
			 s bobj.PHINSTTypeDr=pobjIns.PHINSTTypeDr.%Id()
		}
		/*if $IsObject(pobjIns.PHINSTGenDr){
			s bobj.PHINSTGenDr=pobjIns.PHINSTGenDr.%Id()
		}*/
		s bobj.PHINSTGenDr=pobjIns.PHINSTGenDr
		if $IsObject(pobjIns.PHINSTLibDr){
			s bobj.PHINSTLibDr=pobjIns.PHINSTLibDr.%Id()
		}		
		s bobj.PHINSTActiveFlag=pobjIns.PHINSTActiveFlag
		s bobj.PHINSTOrderNum=pobjIns.PHINSTOrderNum
		s bobj.PHINSTPointerDr=pobjIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=pobjIns.PHINSTPointerType
		s bobj.PHINSTSysFlag=pobjIns.PHINSTSysFlag                   

		d pobjIns.%Close()
		k pobjIns
	
		s scIns=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		if $$$ISOK(scIns){
			s result="{success:'true',info:'删除成功！'}"
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",InstDr,eobjIns.PHINSTText,"D",eobjIns)
		}
		else{
			s result= "{success:'false',info:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","心电项目编辑器-不良反应",id,bobj.PHINSTText,"D",bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		q result
}

/// Description：保存知识库目录字典拖拽的顺序
/// Other: d ##class(web.DHCBL.KB.DHCPHInstLabel).SaveOrder("2","")
ClassMethod SaveDragOrder(order) As %String
{
	s $zt="ERROE"
	s result=""
	Ts
	s argsLen=$Length(order,"^")
	for i=1:1:argsLen		
	{
		s rowid=$p(order,"^",i)
		//选中行的顺序
		s obj=##class(User.DHCPHAddInfo).%OpenId(rowid)
		s obj.PDAIOrdNum=i
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s result = "{success:'true'}"  
		}
		else
		{
			s result = "{success:'false'}"  //返回错误信息
		}
	}
	if (result["true")
	{
		Tc
	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'保存失败'}"
	}
	
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：保存知识库目录字典上移下移的顺序
/// Other: d ##class(web.DHCBL.KB.DHCPHInstLabel).SaveOrder()
ClassMethod SaveOrder(checkId, changeId) As %String
{
	s $zt="ERROE"
	s result=""

	if ((checkId'="")&(changeId'=""))
	{
		
		//先保存选中行的顺序
		s obj1=##class(User.DHCPHAddInfo).%OpenId(checkId)
		s obj2=##class(User.DHCPHAddInfo).%OpenId(changeId)
		s OrderNum1=obj1.PDAIOrdNum
		s OrderNum2=obj2.PDAIOrdNum
		s obj1.PDAIOrdNum=OrderNum2
		s obj2.PDAIOrdNum=OrderNum1

		TS
		s sc1=obj1.%Save()
		s sc2=obj2.%Save()
		d obj1.%Close()
		d obj2.%Close()
		s sc=sc1&sc2
		If $$$ISOK(sc)
		{
			Tc
			s result = "{success:'true'}"  
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}	 
	else
	{
		s result = "{success:'true'}"
	}
	q result
ERROE
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据主索引的id获取数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCECGAR).GetData("7")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
