Import SQLUser

/// 名称: 炮制作用
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-3-27
Class web.DHCBL.KB.DHCPHProcessingAct Extends %RegisteredObject
{

/// Description：打开炮制作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHProcessingAct).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHProcessingAct).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存炮制作用
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCPHProcessingAct 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHProcessingAct).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHProcessingAct) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ProcessingAct","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
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
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
			}

			s obj=##class(User.DHCPHProcessingAct).%New()
			s obj.PACTText=eobj.PHINSTText
			s obj.PACTOrdNum=eobj.PACTOrdNum
			s eobj.PACTInstDr=Insid
			d obj.PACTInstDrSetObjectId(eobj.PACTInstDr)
		    s eobj.PACTText=eobj.PHINSTText
		   		
			s sc=obj.%Save()	
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			if (result["true")
			{
				Tc
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器炮制作用",Insid,eobj.PHINSTText,"A",eobj)
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

/// Description：修改炮制作用
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCPHProcessingAct 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHProcessingAct).SaveData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHProcessingAct) As %String
{
	s result=""
	if $IsObject(eobj)
	{
			
		Ts			
			//日志
			s bobjIns=##class(web.Entity.KB.DHCPHProcessingAct).%New()
			//修改主索引表
			s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PACTInstDr)
			s bobjIns.PHINSTText=objIns.PHINSTText 
			s:objIns.PHINSTTypeDr'="" bobjIns.PHINSTTypeDr = objIns.PHINSTTypeDr.%Id()
			s bobjIns.PHINSTOrderNum=objIns.PHINSTOrderNum	
			s bobjIns.PHINSTGenDr = objIns.PHINSTGenDr
			s bobjIns.PHINSTPointerDr=objIns.PHINSTPointerDr
			s bobjIns.PHINSTPointerType=objIns.PHINSTPointerType
			s:objIns.PHINSTLibDr'="" bobjIns.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
			s bobjIns.PHINSTActiveFlag=objIns.PHINSTActiveFlag
			s bobjIns.PHINSTSysFlag=objIns.PHINSTSysFlag
			
			s objIns.PHINSTText=eobj.PHINSTText	
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ProcessingAct","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
					
			s scIns=objIns.%Save()	
			d objIns.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = objIns.%Id()
				s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
			}		
			//通过索引获取业务表的RowId——PACTRowId
			s PACTRowId=$o(^DHCPHPACT("0","Inst",eobj.PACTInstDr,0))
			if (PACTRowId'="")
			{			
				s obj=##class(User.DHCPHProcessingAct).%OpenId(PACTRowId)
				s:obj.PACTInstDr'="" bobjIns.PACTInstDr=obj.PACTInstDr.%Id()
			    s bobjIns.PACTText=obj.PACTText
			    s bobjIns.PACTOrdNum=obj.PACTOrdNum
			    s eobj.PACTOrdNum=obj.PACTOrdNum
			} 
			else
			{
				s obj=##class(User.DHCPHProcessingAct).%New()	
			}  
			s obj.PACTText=eobj.PHINSTText
			s eobj.PACTText=eobj.PHINSTText
			d obj.PACTInstDrSetObjectId(eobj.PACTInstDr)
					
			s sc=obj.%Save()	
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			if (result["true")
			{
				Tc
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器炮制作用",Insid,eobj.PHINSTText,"U",eobj,bobjIns)
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

/// Description：查询炮制作用表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProcessingAct","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PACTRowId,PACTCode,PACTText,PACTOrdNum,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s PACTRowId=rowid
		s PACTCode=$p($g(^DHCPHPACT(PACTRowId)),"^",1)
		s PACTText=$p($g(^DHCPHPACT(PACTRowId)),"^",2)
		s PACTOrdNum=$p($g(^DHCPHPACT(PACTRowId)),"^",3)
		s PACTInstDr=$p($g(^DHCPHPACT(PACTRowId)),"^",4)
		s PHINSTText = $p($g(^DHCPHINSTRUC(PACTInstDr)),"^",15)  //炮制作用
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ProcessingAct","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""					
			s PACTRowId=$o(^DHCPHPACT("0","Inst",PHINSTRowId,0))							
			s:PACTRowId'="" PACTCode=$p($g(^DHCPHPACT(PACTRowId)),"^",1)
			s:PACTRowId'="" PACTText=$p($g(^DHCPHPACT(PACTRowId)),"^",2)
			s:PACTRowId'="" PACTOrdNum=$p($g(^DHCPHPACT(PACTRowId)),"^",3)
			
			s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)  //不良反应、炮制作用
			
			d OutputRow
		

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PACTRowId,PACTCode,PACTText,PACTOrdNum,PHINSTText)
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
/// Other:w ##class(web.DHCBL.KB.DHCPHProcessingAct).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""		
		s InstDr=id
		
	Tstart
		//日志
		s eobjIns = ##class(web.Entity.KB.DHCPHProcessingAct).%New()
		
		s PACTRowId=$o(^DHCPHPACT("0","Inst",InstDr,0))
		if (PACTRowId'=""){
			s obj=##class(User.DHCPHProcessingAct).%OpenId(PACTRowId)
			s:obj.PACTInstDr'="" eobjIns.PACTInstDr=obj.PACTInstDr.%Id()
		    s eobjIns.PACTText=obj.PACTText
		    s eobjIns.PACTOrdNum=obj.PACTOrdNum
		    
			s scmha=##class(User.DHCPHProcessingAct).%DeleteId(PACTRowId)
			if $$$ISOK(scmha){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scmha)_"'}"  //返回错误信息
			}
		}
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(InstDr)
		
		s eobjIns.PHINSTText = pobjIns.PHINSTText
		if $IsObject(pobjIns.PHINSTTypeDr){
			 s eobjIns.PHINSTTypeDr=pobjIns.PHINSTTypeDr.%Id()
		}
		/*if $IsObject(pobjIns.PHINSTGenDr){
			s eobjIns.PHINSTGenDr=pobjIns.PHINSTGenDr.%Id()
		}*/
		s eobjIns.PHINSTGenDr=pobjIns.PHINSTGenDr
		if $IsObject(pobjIns.PHINSTLibDr){
			s eobjIns.PHINSTLibDr=pobjIns.PHINSTLibDr.%Id()
		}		
		s eobjIns.PHINSTActiveFlag=pobjIns.PHINSTActiveFlag
		s eobjIns.PHINSTOrderNum=pobjIns.PHINSTOrderNum
		s eobjIns.PHINSTPointerDr=pobjIns.PHINSTPointerDr
		s eobjIns.PHINSTPointerType=pobjIns.PHINSTPointerType
		s eobjIns.PHINSTSysFlag=pobjIns.PHINSTSysFlag          
		
		d pobjIns.%Close()
		k pobjIns
	
		s sc=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		if $$$ISOK(sc){
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器炮制作用",InstDr,eobjIns.PHINSTText,"D",eobjIns)	
		}
		else
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		q result
}

/// Description：保存拖拽的顺序
/// Other: d ##class(web.DHCBL.KB.DHCPHProcessingAct).SaveDragOrder("7^10^11")
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
		s obj=##class(User.DHCPHProcessingAct).%OpenId(rowid)
		s obj.PACTOrdNum=i
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
/// Other: d ##class(web.DHCBL.KB.DHCPHProcessingAct).SaveOrder()
ClassMethod SaveOrder(checkId, changeId) As %String
{
	s $zt="ERROE"
	s result=""

	if ((checkId'="")&(changeId'=""))
	{
		
		//先保存选中行的顺序
		s obj1=##class(User.DHCPHProcessingAct).%OpenId(checkId)
		s obj2=##class(User.DHCPHProcessingAct).%OpenId(changeId)
		s OrderNum1=obj1.PACTOrdNum
		s OrderNum2=obj2.PACTOrdNum
		s obj1.PACTOrdNum=OrderNum2
		s obj2.PACTOrdNum=OrderNum1

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
/// Other: w ##class(web.DHCBL.KB.DHCPHProcessingAct).GetData("7")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
