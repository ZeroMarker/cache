Import SQLUser

/// 名称: 溶媒维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期:  2016-10-11
Class web.DHCBL.KB.DHCPHDrgSolvent Extends %RegisteredObject
{

/// Description：打开溶媒数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgSolvent).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHDrgSolvent).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PDINTRowId=$o(^DHCPHDST("0","Inst",id,0))
	if (PDINTRowId'=""){	
		s pobj = ##class(User.DHCPHDrgSolvent).%OpenId(PDINTRowId)
		s eobj.PDINTRowId=PDINTRowId
		if $IsObject(pobj.PDINTInstDr){
			s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
			}
		if $IsObject(pobj.PDINTDrgDr){
			s eobj.PDINTDrgDr = pobj.PDINTDrgDr.%Id() 
			}
		if $IsObject(pobj.PDINTMustUomDr){
			s eobj.PDINTMustUomDr = pobj.PDINTMustUomDr.%Id() 
			}
		s eobj.PDINTRelation=pobj.PDINTRelation
		s eobj.PDINTManage=pobj.PDINTManage
		s eobj.PDINTDosage=pobj.PDINTDosage
		s eobj.PDINTDosageMax=pobj.PDINTDosageMax
		s eobj.PDINTDosageMin=pobj.PDINTDosageMin
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存溶媒
/// Table：User.DHCPHDrgSolvent
/// Input：web.Entity.KB.DHCPHDrgSolvent 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrgSolvent).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDrgSolvent) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTMode=eobj.PHINSTMode
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Solvent","U"),0))
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
			
		//开始保存到溶媒业务表

			s obj=##class(User.DHCPHDrgSolvent).%New()				
			s eobj.PDINTInstDr=Insid
			d obj.PDINTInstDrSetObjectId(eobj.PDINTInstDr)	 		
			s obj.PDINTManage=eobj.PHINSTMode //管控级别与主索引表的相同
			s obj.PDINTDosage=eobj.PDINTDosage 
			d obj.PDINTDrgDrSetObjectId(eobj.PDINTDrgDr)	
			d obj.PDINTMustUomDrSetObjectId(eobj.PDINTMustUomDr)		
			s obj.PDINTRelation=eobj.PDINTRelation	
			s obj.PDINTDosageMax=eobj.PDINTDosageMax
			s obj.PDINTDosageMin=eobj.PDINTDosageMin	
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
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-浓度",Insid,eobj.PHINSTText,"A",eobj)
			}
		
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改溶媒
/// Table：User.DHCPHDrgSolvent
/// Input：web.Entity.KB.DHCPHDrgSolvent 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrgSolvent).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHDrgSolvent) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//修改溶媒业务表
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHDrgSolvent).%New()	
		//修改主索引表	
		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
		s bobj.PDINTInstDr = eobj.PDINTInstDr
		s bobj.PHINSTMode=objIns.PHINSTMode
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
		s bobj.PHINSTGenDr = objIns.PHINSTGenDr
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
		s bobj.PHINSTText=objIns.PHINSTText
		
		
		s objIns.PHINSTMode=eobj.PHINSTMode	
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
		
		s PDINTRowId=$o(^DHCPHDST("0","Inst",eobj.PDINTInstDr,0))	
		if (PDINTRowId'="")
		{	
			s obj=##class(User.DHCPHDrgSolvent).%OpenId(PDINTRowId)
			s:obj.PDINTInstDr'="" bobj.PDINTInstDr = obj.PDINTInstDr.%Id()
			s:obj.PDINTDrgDr'="" bobj.PDINTDrgDr = obj.PDINTDrgDr.%Id()
			s bobj.PDINTManage=obj.PDINTManage
			s bobj.PDINTDosage=obj.PDINTDosage	
			s:obj.PDINTMustUomDr'="" bobj.PDINTMustUomDr = obj.PDINTMustUomDr.%Id()
			s bobj.PDINTRelation = obj.PDINTRelation
			s bobj.PDINTDosageMax=obj.PDINTDosageMax
			s bobj.PDINTDosageMin=obj.PDINTDosageMin
		}
		else
		{
			s obj=##class(User.DHCPHDrgSolvent).%New()
		}
		
		d obj.PDINTDrgDrSetObjectId(eobj.PDINTDrgDr)
		s obj.PDINTManage=eobj.PHINSTMode
		s obj.PDINTDosage=eobj.PDINTDosage	
		d obj.PDINTMustUomDrSetObjectId(eobj.PDINTMustUomDr)		
		s obj.PDINTRelation=eobj.PDINTRelation
		s obj.PDINTDosageMax=eobj.PDINTDosageMax
		s obj.PDINTDosageMin=eobj.PDINTDosageMin
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-浓度",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Description：查询溶媒业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrgSolvent","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		//溶媒业务表^DHCPHDST，通用名字典表^DHCPHPNA
		s PHINSTRowId=rowid
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)		
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Solvent","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
			s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)

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

/// Description:根据id删除 溶媒业务表
/// Table:User.DHCPHDrgSolvent
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDrgSolvent).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
	Tstart
		//删除溶媒业务表
		s bobj = ##class(web.Entity.KB.DHCPHDrgSolvent).%New()
		s PDINTRowId=$o(^DHCPHDST("0","Inst",id,0))
		if (PDINTRowId'=""){
			s obj=##class(User.DHCPHDrgSolvent).%OpenId(PDINTRowId)
			s:obj.PDINTDrgDr'="" bobj.PDINTDrgDr = obj.PDINTDrgDr.%Id()
			s bobj.PDINTManage=obj.PDINTManage
			s bobj.PDINTDosage=obj.PDINTDosage	
			s:obj.PDINTMustUomDr'="" bobj.PDINTMustUomDr = obj.PDINTMustUomDr.%Id()
			s bobj.PDINTRelation = obj.PDINTRelation
			s bobj.PDINTDosageMax=obj.PDINTDosageMax
			s bobj.PDINTDosageMin=obj.PDINTDosageMin
					
			s sc=##class(User.DHCPHDrgSolvent).%DeleteId(PDINTRowId)
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
		s bobj.PHINSTMode=objIns.PHINSTMode
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-浓度",id,bobj.PHINSTText,"D",bobj)
		}
		
		q result
}

/// Description：根据主索引的id获取溶媒数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgSolvent).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
