Import SQLUser

/// 名称: 术前检验维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-丁亚男
/// 编写日期: 2019-11-21
Class web.DHCBL.KB.DHCPreoperLabContr Extends %RegisteredObject
{

/// Description：打开术前检验数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPreoperLabContr).OpenPreoperLabContrData("11731")
ClassMethod OpenPreoperLabContrData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPreoperLabContr).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	;检验指标
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",id,0))
	if (LABIRowId'="")
	{
		s objlab = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
		if $IsObject(objlab.LABILabDr)
		{
			s eobj.LABILabDr = objlab.LABILabDr.%Id()
		}
		s eobj.LABIMinVal=objlab.LABIMinVal
		s eobj.LABIRelation=objlab.LABIRelation
		if $IsObject(objlab.LABIUomDr)
		{
			s eobj.LABIUomDr = objlab.LABIUomDr.%Id()
		}
		
	}
	//通过索引获取年龄业务表的RowId——PDARowId
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",id,0))
	s eobj.PDAAgeDr=""
	if (PDARowId'="")
	{
		s pobjAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
		if $IsObject(pobjAge.PDAAgeDr)
		{
			s eobj.PDAAgeDr =pobjAge.PDAAgeDr.%Id() 
		}
		s eobj.PDAMaxVal=pobjAge.PDAMaxVal
		s eobj.PDAMinVal=pobjAge.PDAMinVal
		if $IsObject(pobjAge.PDAUomDr)
		{
			s eobj.PDAUomDr = pobjAge.PDAUomDr.%Id() 
		}
		d pobjAge.%Close()
		k pobjAge
	}
	
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：保存术前检验
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPreoperLabContr 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPreoperLabContr).SavePreoperLabContrData()
ClassMethod SavePreoperLabContrData(eobj As web.Entity.KB.DHCPreoperLabContr) As %String
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
		s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(eobj.OPERInstLabelCode,"U"),0))
		s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("OPERATION","U"),0))
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
		}
		else
		{	
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
			
		//开始保存到检验指标业务表
		s labobj = ##class(User.DHCLibLabItm).%New() 
		;检验指标
		d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
		s labobj.LABIMinVal=eobj.LABIMinVal
		s labobj.LABIRelation=eobj.LABIRelation
		d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
		d labobj.LABIInstDrSetObjectId(Insid)
		
		
		s labsc=labobj.%Save()
		d labobj.%Close()
		If $$$ISOK(labsc){ 	
			s labid = labobj.%Id()
			s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
		}else{	
			s result ="false"
		}
		//开始保存到年龄业务表
		s objAge=##class(User.DHCPHDiseaseAge).%New()
		d objAge.PDAInstDrSetObjectId(Insid)
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMinVal=eobj.PDAMinVal
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)				
		s scAge=objAge.%Save()		
		d objAge.%Close()
		if $$$ISOK(scAge)
		{			
			s ageId=objAge.%Id()
		}
		else
		{			
			s result = "{success:'false',errorinfo:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
		}
		
		
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_Insid_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-术前检验",Insid,eobj.PHINSTText,"A",eobj)
		}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改术前检验
/// Table：User.DHCPHDrugDisease
/// Input：web.Entity.KB.DHCPreoperLabContr 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPreoperLabContr).SavePreoperLabContrData()
ClassMethod UpdatePreoperLabContrData(eobj As web.Entity.KB.DHCPreoperLabContr) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCPreoperLabContr).%New()
		
		
		//修改主索引表
		s PHDDInstDr=eobj.PHDDInstDr		
		s objIns=##class(User.DHCPHInstructions).%OpenId(PHDDInstDr)
		s bobj.PHINSTMode=objIns.PHINSTMode
		s bobj.PHINSTText=objIns.PHINSTText 
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		
		s objIns.PHINSTMode=eobj.PHINSTMode	
		s objIns.PHINSTText=eobj.PHINSTText	
		s scIns=objIns.%Save()	
		d objIns.%Close()
		If $$$ISOK(scIns)
		{
			s Insid = objIns.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
	
		//修改检验业务表		
		//通过索引获取检验业务表DHC_LibLabItm的RowId——LABIRowId
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHDDInstDr,0))
		if (LABIRowId'="")
		{
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" bobj.LABILabDr = labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIRelation=labobj.LABIRelation
			s:labobj.LABIUomDr'="" bobj.LABIUomDr = labobj.LABIUomDr.%Id()
			
					
			;检验指标
			d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
			s labobj.LABIMinVal=eobj.LABIMinVal
			s labobj.LABIRelation=eobj.LABIRelation
			d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
			
			s labsc=labobj.%Save()
			d labobj.%Close()
			If $$$ISOK(labsc){ 	
				s labid = labobj.%Id()
				s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
			}else{	
				s result ="false"
			}
		}
		elseif (LABIRowId="")&(eobj.LABILabDr'="")
		{
			//开始保存到检验指标业务表
			s labobj = ##class(User.DHCLibLabItm).%New() 
			;检验指标
			d:eobj.LABILabDr'="" labobj.LABILabDrSetObjectId(eobj.LABILabDr)
			s labobj.LABIMinVal=eobj.LABIMinVal
			s labobj.LABIRelation=eobj.LABIRelation
			d:eobj.LABIUomDr'="" labobj.LABIUomDrSetObjectId(eobj.LABIUomDr)
			d labobj.LABIInstDrSetObjectId(Insid)
			
			
			s labsc=labobj.%Save()
			d labobj.%Close()
			If $$$ISOK(labsc){ 	
				s labid = labobj.%Id()
				s:eobj.LABILabDr'="" $p(^DHCPHEGEN(eobj.LABILabDr),"^",9)="Y" //设置检验项目通用名数据池标识
			}else{	
				s result ="false"
			}
		}	
		//修改年龄业务表
	
		//通过索引获取年龄业务表的RowId——PDARowId
		s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHDDInstDr,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
		}
		else
		{
			s objAge=##class(User.DHCPHDiseaseAge).%New()
		}
		d objAge.PDAInstDrSetObjectId(PHDDInstDr)
		d objAge.PDAAgeDrSetObjectId(eobj.PDAAgeDr)
		s objAge.PDAMaxVal=eobj.PDAMaxVal
		s objAge.PDAMinVal=eobj.PDAMinVal
		d objAge.PDAUomDrSetObjectId(eobj.PDAUomDr)
		s scAge=objAge.%Save()
		d objAge.%Close()
		
		if $$$ISOK(scAge)
		{
			s ageId=objAge.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
		}
	
		
		if (result["false")
		{
			Trollback
			s result = "{success:'false',errorinfo:'保存失败'}"
			
		}
		else
		{
			Tc
			s result = "{success:'true',id:'"_PHDDInstDr_"'}" //返回RowId
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-术前检验",PHDDInstDr,eobj.PHINSTText,"U",eobj,bobj)

		}
			
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator：丁亚男
/// CreatDate: 2019-11-21
/// Description：查询术前检验内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPreoperLabContr","GetList","","","124","Form","2")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr, OPERInstLabelCode) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr, OPERInstLabelCode) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(OPERInstLabelCode,"U"),0))
	s PHINSTRowId=0
	for
	{
		s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		d OutputRow
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

/// Description:根据id删除 术前检验业务表
/// Table:User.DHCPHDrugDisease
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPreoperLabContr).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""
		TS
		//日志
		s bobj = ##class(web.Entity.KB.DHCPreoperLabContr).%New()	
		
		//删除主索引表			
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHINSTText=objIns.PHINSTText 
		
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
		
		s scInst=##class(User.DHCPHInstructions).%DeleteId(id)
		if '$$$ISOK(scInst)
		{
			s result= "{success:'false',info:'"_$zconvert(scInst,"O","JS")_"'}"  //返回错误信息
		}
		s LABIRowId=$o(^DHCLIBLABI(0,"Inst",id,0))
		if (LABIRowId'="") 
		{
			s labobj = ##class(User.DHCLibLabItm).%OpenId(LABIRowId)
			s:labobj.LABILabDr'="" bobj.LABILabDr = labobj.LABILabDr.%Id()
			s bobj.LABIMinVal=labobj.LABIMinVal
			s bobj.LABIRelation=labobj.LABIRelation
			s:labobj.LABIUomDr'="" bobj.LABIUomDr = labobj.LABIUomDr.%Id()
		
			s sclab=##class(User.DHCLibLabItm).%DeleteId(LABIRowId)
			if '$$$ISOK(sclab)
			{
				s result ="false"
			}

		}
		
		//删除年龄业务表
		s PDARowId=$o(^DHCPHDISAGE("0","Inst",id,0))
		if (PDARowId'="")
		{
			s objAge = ##class(User.DHCPHDiseaseAge).%OpenId(PDARowId)
			s:objAge.PDAAgeDr'="" bobj.PDAAgeDr=objAge.PDAAgeDr.%Id()
			s bobj.PDAMinVal=objAge.PDAMinVal
			s bobj.PDAMaxVal=objAge.PDAMaxVal
			s:objAge.PDAUomDr'="" bobj.PDAUomDr=objAge.PDAUomDr.%Id()
			
			s scAge=##class(User.DHCPHDiseaseAge).%DeleteId(PDARowId)
			if '$$$ISOK(scAge)
			{
				s result= "{success:'false',info:'"_$zconvert(scAge,"O","JS")_"'}"  //返回错误信息
			}
		}
	
		if (result["false")
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		else
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","手术项目编辑器-术前检验",id,bobj.PHINSTText,"D",bobj)
		}
		q result
}

/// Description：根据主索引的id获取术前检验数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPreoperLabContr).GetPreoperLabContrData("4")
ClassMethod GetData(InstId As %String) As %String
{

		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
