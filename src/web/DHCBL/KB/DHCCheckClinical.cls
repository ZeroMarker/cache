Import SQLUser

/// 名称: 临床意义
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2020-07-27
Class web.DHCBL.KB.DHCCheckClinical Extends %RegisteredObject
{

/// Description：打开临床意义数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCCheckClinical).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s eobj = ##class(web.Entity.KB.DHCCheckClinical).%New()
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)	
	s eobj.PHINSTText=pobjIns.PHINSTText

	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存临床意义
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCCheckClinical 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckClinical).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCCheckClinical) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//开始保存到主索引表
		Ts		   				
			s objIns=##class(User.DHCPHInstructions).%New()							
			s objIns.PHINSTText=eobj.PHINSTText
			
			//主索引表必填项
			if (eobj.PHINSTGenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
			{
				s PHEGLibDr=$p($g(^DHCPHEGEN(eobj.PHINSTGenDr)),"^",7)
				s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
				s:PHEGLibDr="" PHLICode=""
				if (PHLICode="RADI") //放射
				{
					s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIClinical","U"),0))
					s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("RADI","U"),0))
				}
				elseif(PHLICode="ULTR")  //超声
				{
					s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRClinical","U"),0))
					s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ULTR","U"),0))	
				}
				elseif(PHLICode="ENDO") //内镜
				{
					s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOClinical","U"),0))
					s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ENDO","U"),0))	
				}
				elseif(PHLICode="ELECT") //心电
				{
					s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTClinical","U"),0))
					s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("ELECT","U"),0))	
				}
				else  //检查
				{
					s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckClinical","U"),0))
					s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("CHECK","U"),0))
				}
			}
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
				//d:eobj.LABCInstDr="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PHINSTText,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_$zconvert(scIns,"O","JS")_"'}"  //返回错误信息
			}
		
	
			s obj=##class(User.DHCLabClinical).%New()
			s obj.LABCCliText=eobj.PHINSTText
			s eobj.LABCInstDr=Insid
			d obj.LABCInstDrSetObjectId(eobj.LABCInstDr)
					
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
				//新增时，日志
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检验项目编辑器—临床意义",Insid,eobj.PHINSTText,"A",eobj)
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

/// Description：修改临床意义
/// Table：User.DHCPHInstructions
/// Input：web.Entity.KB.DHCCheckClinical 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCCheckClinical).SaveData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCCheckClinical) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//修改主索引表
		Ts			
		//日志
	    s bobj = ##class(web.Entity.KB.DHCCheckClinical).%New()
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.LABCInstDr)
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
		//修改临床意义表	
		//通过索引获取临床意义业务表的RowId——LABCRowId
		s LABCRowId=$o(^DHCLABCLI("0","Inst",eobj.LABCInstDr,0))
		if (LABCRowId'=""){	
			s obj=##class(User.DHCLabClinical).%OpenId(LABCRowId)
			s bobj.LABCCliText=obj.LABCCliText
			
		}
		else
		{
			s obj=##class(User.DHCLabClinical).%New()

		}
		s eobj.LABCCliText=eobj.PHINSTText
		s obj.LABCCliText=eobj.LABCCliText
		d obj.LABCInstDrSetObjectId(eobj.LABCInstDr)		
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检查项目编辑器-临床意义",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Description：查询临床意义、注意事项 查询病症业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCCheckClinical","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,LABCRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		s LABCRowId=rowid
		s LABCInstDr=$p($g(^DHCLABCLI(LABCRowId)),"^",1)
		s PHINSTText = $p($g(^DHCPHINSTRUC(LABCInstDr)),"^",15)  //临床意义、注意事项
		d OutputRow
	}
	else
	{
		if (GenDr'="")  //根据通用名的知识库标识来区分放射、超声、内镜
		{
			s PHEGLibDr=$p($g(^DHCPHEGEN(GenDr)),"^",7)
			s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识代码
			s:PHEGLibDr="" PHLICode=""

			if (PHLICode="RADI") //放射
			{
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("RADIClinical","U"),0))
			}
			elseif(PHLICode="ULTR")  //超声
			{
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ULTRClinical","U"),0))
			}
			elseif(PHLICode="ENDO") //内镜
			{
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ENDOClinical","U"),0))
			}
			elseif(PHLICode="ELECT") //心电
			{
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("ELECTClinical","U"),0))
			}
			else  //检查
			{
				s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("CheckClinical","U"),0))
			}
		}
		
		s PHINSTRowId=0
		for
		{
			//s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("LabClinical","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""								
			s LABCRowId=$o(^DHCLABCLI("0","Inst",PHINSTRowId,0))
			s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)  //临床意义、注意事项

			d OutputRow
			

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHINSTRowId,LABCRowId,PHINSTText)
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
/// Other:w ##class(web.DHCBL.KB.DHCCheckClinical).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""		
		s InstDr=id
		Tstart
		s bobj = ##class(web.Entity.KB.DHCCheckClinical).%New()
		s LABCRowId=$o(^DHCLABCLI("0","Inst",InstDr,0))
		if (LABCRowId'=""){
			s obj=##class(User.DHCLabClinical).%OpenId(LABCRowId)
			s bobj.LABCCliText=obj.LABCCliText
				
			s sc=##class(User.DHCLabClinical).%DeleteId(LABCRowId)
			if $$$ISOK(sc){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","检查项目编辑器-临床意义",InstDr,bobj.PHINSTText,"D",bobj)
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
/// Other: w ##class(web.DHCBL.KB.DHCCheckClinical).GetData("7")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
