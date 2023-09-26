Import SQLUser

/// 名称: 成分浓度维护(整组浓度含量)
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期:  2016-11-23
Class web.DHCBL.KB.DHCPHEleCon Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2016-11-23
/// Description：查询成分浓度业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHEleCon","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText,PHECPHExtIngr,PHEINGDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHINSTRowId=rowid
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)	
		s PHECRowId=$o(^DHCPHEC(0,"Inst",PHINSTRowId,0))
		s:PHECRowId'="" PHECPHExtIngr=$p($g(^DHCPHEC(PHECRowId)),"^",2)
		s:PHECRowId="" PHECPHExtIngr=""
		s:PHECPHExtIngr'="" PHEINGDesc=$listget($g(^User.DHCPHExtIngrD(PHECPHExtIngr)),3)
		s:PHECPHExtIngr="" PHEINGDesc=""
			
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("EleCon","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
			s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
			s PHECRowId=$o(^DHCPHEC(0,"Inst",PHINSTRowId,0))
			s:PHECRowId'="" PHECPHExtIngr=$p($g(^DHCPHEC(PHECRowId)),"^",2)
			s:PHECRowId="" PHECPHExtIngr=""
			s:PHECPHExtIngr'="" PHEINGDesc=$listget($g(^User.DHCPHExtIngrD(PHECPHExtIngr)),3)
			s:PHECPHExtIngr="" PHEINGDesc=""
			
			d OutputRow

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PHINSTText,PHECPHExtIngr,PHEINGDesc)
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

/// Description：打开成分浓度数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHEleCon).OpenData("809")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHEleCon).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHECRowId=$o(^DHCPHEC(0,"Inst",id,0))
	if (PHECRowId'=""){	
		s pobj = ##class(User.DHCPHEleCon).%OpenId(PHECRowId)
		s eobj.PHECRowId=PHECRowId
		if $IsObject(pobj.PHECInstDr){
			s eobj.PHECInstDr = pobj.PHECInstDr.%Id() 
			}
		if $IsObject(pobj.PHECPHExtIngr){
			s eobj.PHECPHExtIngr = pobj.PHECPHExtIngr.%Id() 
			}
		s eobj.PHECIngrQty=pobj.PHECIngrQty
		if $IsObject(pobj.PHECUomDr){
			s eobj.PHECUomDr = pobj.PHECUomDr.%Id() 
			}
		s eobj.PHECRelation=pobj.PHECRelation
		s eobj.PHECTotalQty=pobj.PHECTotalQty
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存成分浓度
/// Table：User.DHCPHEleCon
/// Input：web.Entity.KB.DHCPHEleCon 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHEleCon).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHEleCon) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("EleCon","U"),0))
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
			
		//开始保存到成分浓度业务表

			s obj=##class(User.DHCPHEleCon).%New()				
			s eobj.PHECInstDr=Insid
			d obj.PHECInstDrSetObjectId(eobj.PHECInstDr)
			d obj.PHECPHExtIngrSetObjectId(eobj.PHECPHExtIngr)	 		
			s obj.PHECIngrQty=eobj.PHECIngrQty 
			d obj.PHECUomDrSetObjectId(eobj.PHECUomDr)		
			s obj.PHECRelation=eobj.PHECRelation
			s obj.PHECTotalQty=eobj.PHECTotalQty		
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
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-成分含量",Insid,eobj.PHINSTText,"A",eobj)
			}
		
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改成分浓度
/// Table：User.DHCPHEleCon
/// Input：web.Entity.KB.DHCPHEleCon 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHEleCon).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHEleCon) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//修改成分浓度业务表
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHEleCon).%New()
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PHECInstDr)
		s bobj.PHECInstDr = eobj.PHECInstDr
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		
		s objIns.PHINSTText=eobj.PHINSTText
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
		
		s PHECRowId=$o(^DHCPHEC(0,"Inst",eobj.PHECInstDr,0))	
		if (PHECRowId'="")
		{	
			s obj=##class(User.DHCPHEleCon).%OpenId(PHECRowId)
			s:obj.PHECInstDr'="" bobj.PHECInstDr=obj.PHECInstDr.%Id()	
			s:obj.PHECPHExtIngr'="" bobj.PHECPHExtIngr=obj.PHECPHExtIngr.%Id()		
			s bobj.PHECIngrQty=obj.PHECIngrQty 
			s:obj.PHECUomDr'="" bobj.PHECUomDr=obj.PHECUomDr.%Id()	
			s bobj.PHECRelation=obj.PHECRelation
			s bobj.PHECTotalQty=obj.PHECTotalQty
		}
		else
		{
			s obj=##class(User.DHCPHEleCon).%New()
		}
		d obj.PHECInstDrSetObjectId(eobj.PHECInstDr)
		d obj.PHECPHExtIngrSetObjectId(eobj.PHECPHExtIngr)	 		
		s obj.PHECIngrQty=eobj.PHECIngrQty 
		d obj.PHECUomDrSetObjectId(eobj.PHECUomDr)		
		s obj.PHECRelation=eobj.PHECRelation
		s obj.PHECTotalQty=eobj.PHECTotalQty	
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-成分含量",Insid,eobj.PHINSTText,"U",eobj,bobj)
		}
	
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description:根据id删除 成分浓度业务表
/// Table:User.DHCPHEleCon
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHEleCon).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
	Tstart
		//删除成分浓度业务表
		s bobj = ##class(web.Entity.KB.DHCPHEleCon).%New()
		s PHECRowId=$o(^DHCPHEC(0,"Inst",id,0))
		if (PHECRowId'=""){	
			s obj=##class(User.DHCPHEleCon).%OpenId(PHECRowId) 
			s:obj.PHECInstDr'="" bobj.PHECInstDr=obj.PHECInstDr.%Id()
			s:obj.PHECPHExtIngr'="" bobj.PHECPHExtIngr=obj.PHECPHExtIngr.%Id()		
			s bobj.PHECIngrQty=obj.PHECIngrQty 
			s:obj.PHECUomDr'="" bobj.PHECUomDr=obj.PHECUomDr.%Id()	
			s bobj.PHECRelation=obj.PHECRelation
			s bobj.PHECTotalQty=obj.PHECTotalQty
				
			s sc=##class(User.DHCPHEleCon).%DeleteId(PHECRowId)
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-成分含量",id,bobj.PHINSTText,"D",bobj)
		
		}
		
		q result
}

/// Description：根据主索引的id获取成分浓度数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHEleCon).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
