Import SQLUser

/// 名称: 滴速
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-05-23
Class web.DHCBL.KB.DHCPHDrippingSpeed Extends %RegisteredObject
{

/// Description：打开不良反应数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrippingSpeed).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCPHDrippingSpeed).%New()
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
/// Input：web.Entity.KB.DHCPHDrippingSpeed 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrippingSpeed).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDrippingSpeed) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
		s objIns=##class(User.DHCPHInstructions).%New()							
		s objIns.PHINSTText=eobj.PHINSTText
	
		//主索引表必填项
		s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("DrippingSpeed","U"),0))
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
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
		}


		s obj=##class(User.DHCPHDrippingSpeed).%New()
		s obj.DRSPText=eobj.PHINSTText
		s eobj.DRSPInstDr=Insid
		d obj.DRSPInstDrSetObjectId(eobj.DRSPInstDr)
		s eobj.DRSPText=eobj.PHINSTText
		
				
		s sc=obj.%Save()	
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器滴速",Insid,eobj.PHINSTText,"A",eobj)
			
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
/// Input：web.Entity.KB.DHCPHDrippingSpeed 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrippingSpeed).SaveData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHDrippingSpeed) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		Ts			
			//日志
			s bobjIns=##class(web.Entity.KB.DHCPHDrippingSpeed).%New()
			//修改主索引表
			s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.DRSPInstDr)
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
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("DrippingSpeed","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
				
			s scIns=objIns.%Save()	
			d objIns.%Close()
			If $$$ISOK(scIns)
			{
				s Insid = objIns.%Id()
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
			}
			//修改滴速表	
			//通过索引获取不良反应业务表的RowId——DRSPRowId
			s DRSPRowId=$o(^DHCPHDRSP("0","Inst",eobj.DRSPInstDr,0))
			if (DRSPRowId'="")
			{	
				s obj=##class(User.DHCPHDrippingSpeed).%OpenId(DRSPRowId)
				s:obj.DRSPInstDr'="" bobjIns.DRSPInstDr=obj.DRSPInstDr.%Id()
			    s bobjIns.DRSPText=obj.DRSPText
			}
			else
			{
				s obj=##class(User.DHCPHDrippingSpeed).%New()	
			}   
			s obj.DRSPText=eobj.PHINSTText	
			d obj.DRSPInstDrSetObjectId(eobj.DRSPInstDr)
			s eobj.DRSPText=eobj.PHINSTText
			
			s sc=obj.%Save()	
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s id = obj.%Id()
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器滴速",Insid,eobj.PHINSTText,"U",eobj,bobjIns)
			
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
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrippingSpeed","GetList","")
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
		s PHINSTText = $p($g(^DHCPHINSTRUC(DRSPInstDr)),"^",15)  //不良反应、注意事项
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("DrippingSpeed","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""									
			s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)  //不良反应、注意事项
			
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

/// Description:根据id删除
/// Table:User.DHCPHInstructions
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDrippingSpeed).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""	
		s InstDr=id	
		Tstart
		s eobjIns = ##class(web.Entity.KB.DHCPHDrippingSpeed).%New()
		
		s DRSPRowId=$o(^DHCPHDRSP("0","Inst",id,0))
		if (DRSPRowId'=""){
			s obj=##class(User.DHCPHDrippingSpeed).%OpenId(DRSPRowId)
			s:obj.DRSPInstDr'="" eobjIns.DRSPInstDr=obj.DRSPInstDr.%Id()
		    s eobjIns.DRSPText=obj.DRSPText
		    
			s sc=##class(User.DHCPHDrippingSpeed).%DeleteId(DRSPRowId)
			if '$$$ISOK(sc){
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
		s scIns=##class(User.DHCPHInstructions).%DeleteId(id)
		if '$$$ISOK(scIns){
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scIns)_"'}"  //返回错误信息
		}
		if (result["false")
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		else
		{
			TC
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器滴速",InstDr,eobjIns.PHINSTText,"D",eobjIns)	
			s result="{success:'true',info:'删除成功！'}"
		}
		q result
}

/// Description：根据主索引的id获取数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrippingSpeed).GetData("7")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
