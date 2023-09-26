Import SQLUser

/// 名称: 溶媒量维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期:  2016-11-23
Class web.DHCBL.KB.DHCPHMenstruumQty Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2016-11-23
/// Description：查询溶媒量业务表内容
/// Input：TypeDr=&GenDr=16&PointerType=Form&PointerDr=2
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHMenstruumQty","GetList","","","16","Form","2")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHINSTRowId=rowid
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)	//溶媒量描述
		/*
		s PHMQRowId=$o(^DHCPHMQ(0,"Inst",PHINSTRowId,0))
		s PHMQCatDr=$p($g(^DHCPHMQ(PHMQRowId)),"^",2)
		s:PHMQCatDr'="" PHINSTText=$p($g(^DHCPHMCT(PHMQCatDr)),"^",1) //溶媒分类
		s:PHMQCatDr="" PHINSTText=""
		*/	
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Menstruum","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
			s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) //溶媒量描述
			/*
			s PHMQRowId=$o(^DHCPHMQ(0,"Inst",PHINSTRowId,0))
			s PHMQCatDr=$p($g(^DHCPHMQ(PHMQRowId)),"^",2)
			s:PHMQCatDr'="" PHINSTText=$p($g(^DHCPHMCT(PHMQCatDr)),"^",1) //溶媒分类
			s:PHMQCatDr="" PHINSTText=""
			*/
			d OutputRow

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTText)
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

/// Description：打开溶媒量数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHMenstruumQty).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHMenstruumQty).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTText=pobjIns.PHINSTText
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	
	s PHMQRowId=$o(^DHCPHMQ(0,"Inst",id,0))
	if (PHMQRowId'=""){	
		s pobj = ##class(User.DHCPHMenstruumQty).%OpenId(PHMQRowId)
		s eobj.PHMQRowId=PHMQRowId
		if $IsObject(pobj.PHMQInstDr){
			s eobj.PHMQInstDr = pobj.PHMQInstDr.%Id() 
			}
		if $IsObject(pobj.PHMQCatDr){
			s eobj.PHMQCatDr = pobj.PHMQCatDr.%Id() 
			}
		s eobj.PHMQCatQtyMin=pobj.PHMQCatQtyMin
		s eobj.PHMQCatQtyMax=pobj.PHMQCatQtyMax
		if $IsObject(pobj.PHMQCatQtyUomDr){
			s eobj.PHMQCatQtyUomDr = pobj.PHMQCatQtyUomDr.%Id() 
			}
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存溶媒量
/// Table：User.DHCPHMenstruumQty
/// Input：web.Entity.KB.DHCPHMenstruumQty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHMenstruumQty).SaveAll()
ClassMethod SaveAll(eobj As web.Entity.KB.DHCPHMenstruumQty) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s length=$Length(eobj.PHMQCat,",")
		for i=1:1:length
		{
			s eobj.PHMQCatDr=$p(eobj.PHMQCat,",",i)
		
		//开始保存到主索引表
			;Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			s objIns.PHINSTMode=eobj.PHINSTMode
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Menstruum","U"),0))
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
				s result=result_"^"_1
			}
			else
			{
				s result =result_"^"_0
			}
			
		//开始保存到溶媒量业务表

			s obj=##class(User.DHCPHMenstruumQty).%New()				
			s eobj.PHMQInstDr=Insid
			d obj.PHMQInstDrSetObjectId(eobj.PHMQInstDr)	 
			d obj.PHMQCatDrSetObjectId(eobj.PHMQCatDr)	 		
			s obj.PHMQCatQtyMin=eobj.PHMQCatQtyMin 
			s obj.PHMQCatQtyMax=eobj.PHMQCatQtyMax 
			d obj.PHMQCatQtyUomDrSetObjectId(eobj.PHMQCatQtyUomDr)		
	
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc){
				s id=obj.%Id()
				s result=result_"^"_1
			}
			else
			{
				s result=result_"^"_0
			}
		}
		if (result[0)
		{
			;Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			;Tc
			s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
		}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：保存溶媒量
/// Table：User.DHCPHMenstruumQty
/// Input：web.Entity.KB.DHCPHMenstruumQty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHMenstruumQty).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHMenstruumQty) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			s objIns.PHINSTMode=eobj.PHINSTMode
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Menstruum","U"),0))
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
				s result=result_"^"_1
			}
			else
			{
				s result =result_"^"_0
			}
			
		//开始保存到溶媒量业务表

			s obj=##class(User.DHCPHMenstruumQty).%New()				
			s eobj.PHMQInstDr=Insid
			d obj.PHMQInstDrSetObjectId(eobj.PHMQInstDr)	 
			d obj.PHMQCatDrSetObjectId(eobj.PHMQCatDr)	 		
			s obj.PHMQCatQtyMin=eobj.PHMQCatQtyMin 
			s obj.PHMQCatQtyMax=eobj.PHMQCatQtyMax 
			d obj.PHMQCatQtyUomDrSetObjectId(eobj.PHMQCatQtyUomDr)		
	
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc){
				s id=obj.%Id()
				s result=result_"^"_1
			}
			else
			{
				s result=result_"^"_0
			}
			
			if (result[0)
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"
			}
			else
			{
				Tc
				s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-溶媒量",Insid,eobj.PHINSTText,"A",eobj)
			}
		
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改溶媒量
/// Table：User.DHCPHMenstruumQty
/// Input：web.Entity.KB.DHCPHMenstruumQty 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHMenstruumQty).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHMenstruumQty) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//修改溶媒量业务表
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHMenstruumQty).%New()
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PHMQInstDr)
		s bobj.PHMQInstDr = eobj.PHMQInstDr
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		s bobj.PHINSTMode=objIns.PHINSTMode	
		
		s objIns.PHINSTText=eobj.PHINSTText
		s objIns.PHINSTMode=eobj.PHINSTMode
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
			s result=result_"^"_1	
		}
		else
		{
			s result=result_"^"_0	
		}
		
		s PHMQRowId=$o(^DHCPHMQ(0,"Inst",eobj.PHMQInstDr,0))	
		if (PHMQRowId'="")
		{	
			s obj=##class(User.DHCPHMenstruumQty).%OpenId(PHMQRowId)
			s:obj.PHMQInstDr'="" bobj.PHMQInstDr=obj.PHMQInstDr.%Id()	 
			s:obj.PHMQCatDr'="" bobj.PHMQCatDr=obj.PHMQCatDr.%Id()		
			s bobj.PHMQCatQtyMin=obj.PHMQCatQtyMin
			s bobj.PHMQCatQtyMax=obj.PHMQCatQtyMax 
			s:obj.PHMQCatQtyUomDr'="" bobj.PHMQCatQtyUomDr=obj.PHMQCatQtyUomDr.%Id()	
		}
		else
		{
			s obj=##class(User.DHCPHMenstruumQty).%New()	
		}
		
		d obj.PHMQInstDrSetObjectId(eobj.PHMQInstDr)	
		d obj.PHMQCatDrSetObjectId(eobj.PHMQCatDr)	 		
		s obj.PHMQCatQtyMin=eobj.PHMQCatQtyMin 
		s obj.PHMQCatQtyMax=eobj.PHMQCatQtyMax 
		d obj.PHMQCatQtyUomDrSetObjectId(eobj.PHMQCatQtyUomDr)	
		s sc=obj.%Save()	
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s result=result_"^"_1	
		}
		else
		{
			s result=result_"^"_0	
		}
		
		if (result[0)
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_Insid_"'}"  //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-溶媒量",Insid,eobj.PHINSTText,"U",eobj,bobj)
		}
	
		
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description:根据id删除 溶媒量业务表
/// Table:User.DHCPHMenstruumQty
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHMenstruumQty).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
	Tstart
		//删除溶媒量业务表
		s bobj = ##class(web.Entity.KB.DHCPHMenstruumQty).%New()
		s PHMQRowId=$o(^DHCPHMQ(0,"Inst",id,0))
		if (PHMQRowId'=""){		
			s obj=##class(User.DHCPHMenstruumQty).%OpenId(PHMQRowId)
			s:obj.PHMQInstDr'="" bobj.PHMQInstDr=obj.PHMQInstDr.%Id()
			s:obj.PHMQCatDr'="" bobj.PHMQCatDr=obj.PHMQCatDr.%Id()		
			s bobj.PHMQCatQtyMin=obj.PHMQCatQtyMin
			s bobj.PHMQCatQtyMax=obj.PHMQCatQtyMax 
			s:obj.PHMQCatQtyUomDr'="" bobj.PHMQCatQtyUomDr=obj.PHMQCatQtyUomDr.%Id()
			
			s sc=##class(User.DHCPHMenstruumQty).%DeleteId(PHMQRowId)
			if $$$ISOK(sc)
			{
				s result=result_"^"_1
			}
			else
			{
				s result=result_"^"_0
			}
		}

		
		//删除主索引表			
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr = objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		s bobj.PHINSTMode=objIns.PHINSTMode
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
		if $$$ISOK(scInst)
		{
			s result=result_"^"_1
		}
		else
		{
			s result=result_"^"_0
		}
		if (result[0)
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-溶媒量",id,bobj.PHINSTText,"D",bobj)
		}
		
		q result
}

/// Description：根据主索引的id获取溶媒量数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHMenstruumQty).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
