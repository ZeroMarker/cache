Import SQLUser

/// 名称: 检验结果辅助诊断
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-3-23
Class web.DHCBL.KB.DHCPHLibResultDiag Extends %RegisteredObject
{

/// Description：打开检验结果辅助诊断数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHLibResultDiag).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	
	s eobj = ##class(web.Entity.KB.DHCPHLibResultDiag).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText
	s PLRDRowId=$o(^DHCPHLRD("0","Inst",id,0))
	if (PLRDRowId'=""){
		s pobj=##class(User.DHCPHLibResultDiag).%OpenId(PLRDRowId)	
		s eobj.PLRDNormal=pobj.PLRDNormal
		s eobj.PLRDHigh=pobj.PLRDHigh
		s eobj.PLRDLow=pobj.PLRDLow
		s eobj.PLRDNegative=pobj.PLRDNegative
		s eobj.PLRDPositive=pobj.PLRDPositive
		s eobj.PLRDOther=pobj.PLRDOther
		d pobj.%Close()
		k pobj
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存检验结果辅助诊断
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCPHLibResultDiag 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHLibResultDiag).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHLibResultDiag) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("LabResultDiag","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("LAB","U"),0))	
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
				//d:eobj.PLRDInstDr="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
			}
		
	
			s obj=##class(User.DHCPHLibResultDiag).%New()
			s obj.PLRDNormal=eobj.PLRDNormal
			s obj.PLRDHigh=eobj.PLRDHigh
			s obj.PLRDLow=eobj.PLRDLow
			s obj.PLRDNegative=eobj.PLRDNegative
			s obj.PLRDPositive=eobj.PLRDPositive
			s obj.PLRDOther=eobj.PLRDOther
			s eobj.PLRDInstDr=Insid
			d obj.PLRDInstDrSetObjectId(eobj.PLRDInstDr)
					
			s sc=obj.%Save()	
			d obj.%Close()
			If $$$ISOK(sc)
			{
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			}
			
			if (result["true")
			{
				Tc
				//新增时，日志
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器—检验结果辅助诊断",Insid,eobj.PHINSTText,"A",eobj)
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

/// Description：修改检验结果辅助诊断
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCPHLibResultDiag 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHLibResultDiag).SaveData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHLibResultDiag) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//修改主索引表
		Ts			
		//日志
	    s bobj = ##class(web.Entity.KB.DHCPHLibResultDiag).%New()
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PLRDInstDr)
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
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
		//修改检验结果辅助诊断表	
		//通过索引获取检验结果辅助诊断业务表的RowId——PLRDRowId
		s PLRDRowId=$o(^DHCPHLRD("0","Inst",eobj.PLRDInstDr,0))
		if (PLRDRowId'=""){	
			s obj=##class(User.DHCPHLibResultDiag).%OpenId(PLRDRowId)
			s bobj.PLRDNormal=obj.PLRDNormal
			s bobj.PLRDHigh=obj.PLRDHigh
			s bobj.PLRDLow=obj.PLRDLow
			s bobj.PLRDNegative=obj.PLRDNegative
			s bobj.PLRDPositive=obj.PLRDPositive
			s bobj.PLRDOther=obj.PLRDOther
		}
		else
		{
			s obj=##class(User.DHCPHLibResultDiag).%New()
		}
			
		s obj.PLRDNormal=eobj.PLRDNormal
		s obj.PLRDHigh=eobj.PLRDHigh
		s obj.PLRDLow=eobj.PLRDLow
		s obj.PLRDNegative=eobj.PLRDNegative
		s obj.PLRDPositive=eobj.PLRDPositive
		s obj.PLRDOther=eobj.PLRDOther	
		d obj.PLRDInstDrSetObjectId(eobj.PLRDInstDr)
		
		s sc=obj.%Save()	
		d obj.%Close()
		If $$$ISOK(sc)
		{
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"  //返回RowId
		}
		else
		{
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
		
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检查项目编辑器-检查结果辅助诊断",Insid,eobj.PHINSTText,"U",eobj,bobj)
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

/// Description：查询检验结果辅助诊断
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibResultDiag","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PLRDRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s PLRDRowId=rowid
		s PLRDInstDr=$p($g(^DHCPHLRD(PLRDRowId)),"^",1)
		s PHINSTText = $p($g(^DHCPHINSTRUC(PLRDInstDr)),"^",15)  //检验结果辅助诊断
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("LabResultDiag","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""								
			s PLRDRowId=$o(^DHCPHLRD("0","Inst",PHINSTRowId,0))
			s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)  //检验结果辅助诊断
			
			d OutputRow
			

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,PLRDRowId,PHINSTText)
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
/// Other:w ##class(web.DHCBL.KB.DHCPHLibResultDiag).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""		
		s InstDr=id
		Tstart
		s bobj = ##class(web.Entity.KB.DHCPHLibResultDiag).%New()
		s PLRDRowId=$o(^DHCPHLRD("0","Inst",InstDr,0))
		if (PLRDRowId'=""){
			s obj=##class(User.DHCPHLibResultDiag).%OpenId(PLRDRowId)
			s bobj.PLRDNormal=obj.PLRDNormal
			s bobj.PLRDHigh=obj.PLRDHigh
			s bobj.PLRDLow=obj.PLRDLow
			s bobj.PLRDNegative=obj.PLRDNegative
			s bobj.PLRDPositive=obj.PLRDPositive
			s bobj.PLRDOther=obj.PLRDOther
				
			s sc=##class(User.DHCPHLibResultDiag).%DeleteId(PLRDRowId)
			if $$$ISOK(sc){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			}
		}
		 
		s objIns=##class(User.DHCPHInstructions).%OpenId(InstDr)
		s bobj.PHINSTText=objIns.PHINSTText
		
		s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr=objIns.PHINSTTypeDr.%Id()
		s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum 
		s bobj.PHINSTGenDr=objIns.PHINSTGenDr 
		s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
		s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr=objIns.PHINSTLibDr.%Id() 
		s bobj.PHINSTPointerType=objIns.PHINSTPointerType
		s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag 
		s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag 
			
		s scIns=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		if $$$ISOK(scIns){
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			s result= "{success:'false',info:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
		}
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检查项目编辑器-检查结果辅助诊断",InstDr,bobj.PHINSTText,"D",bobj)
		}
		else
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		q result
}

/// Description：根据主索引的id获取数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHLibResultDiag).GetData("7")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
