Import SQLUser

/// 名称: 单独用药维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期:  2016-11-3
Class web.DHCBL.KB.DHCPHDrgAlone Extends %RegisteredObject
{

/// Description：打开单独用药数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgAlone).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHDrgAlone).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	s PHDALRowId=0
	for
	{
		s PHDALRowId=$o(^DHCPHDAL("0","Inst",id,PHDALRowId)) q:PHDALRowId=""

		s PHDALDrgDr=$p($g(^DHCPHDAL(PHDALRowId)),"^",1)
		if (PHDALDrgDr'="") 
		{
			if (eobj.PHDALDrgDr'="")
			{
				s eobj.PHDALDrgDr =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)_","_eobj.PHDALDrgDr
			}
			else
			{
				s eobj.PHDALDrgDr =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)
			}
		} 
		s pobj = ##class(User.DHCPHDrgAlone).%OpenId(PHDALRowId)
		s eobj.PHDALRowId=PHDALRowId
		if $IsObject(pobj.PHDALInstDr){
			s eobj.PHDALInstDr = pobj.PHDALInstDr.%Id() 
			}
		s eobj.PHDALManage=pobj.PHDALManage
		if $IsObject(pobj.PHDALCatDr){
			s eobj.PHDALCatDr = pobj.PHDALCatDr.%Id() 
			}
		s eobj.PHDALGrpNo=pobj.PHDALGrpNo
		d pobj.%Close()
		k pobj
	
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存单独用药
/// Table：User.DHCPHDrgAlone
/// Input：web.Entity.KB.DHCPHDrgAlone 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrgAlone).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDrgAlone) As %String
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
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("DrgAlone","U"),0))
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
			
			//开始保存到单独用药业务表
			s args=eobj.PHDALDrgDr
			if (args'="")
			{
				s PHDALDrgDrs=""
				s argsLen=$Length(args,",")
				for i=1:1:argsLen
				{
	                  
					s eobj.PHDALDrgDr=$p(args,",",i)
					s PHNDesc=$p($g(^DHCPHPNA(eobj.PHDALDrgDr)),"^",2) //商品名描述
					s:PHDALDrgDrs'="" PHDALDrgDrs=PHDALDrgDrs_"、"_PHNDesc	
					s:PHDALDrgDrs="" PHDALDrgDrs=PHNDesc
					
					s obj=##class(User.DHCPHDrgAlone).%New()				
					s eobj.PHDALInstDr=Insid
					d obj.PHDALInstDrSetObjectId(eobj.PHDALInstDr)	 		
					s obj.PHDALManage=eobj.PHINSTMode //管控级别与主索引表的相同
					d obj.PHDALDrgDrSetObjectId(eobj.PHDALDrgDr)
					d obj.PHDALCatDrSetObjectId(eobj.PHDALCatDr)		
					s obj.PHDALGrpNo=eobj.PHDALGrpNo				
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
				s eobj.PHDALDrgDrs=PHDALDrgDrs
			}
			else{ //病症为空，溶媒分类不为空
				if (eobj.PHDALCatDr'="")
				{
					s obj=##class(User.DHCPHDrgAlone).%New()				
					s eobj.PHDALInstDr=Insid
					d obj.PHDALInstDrSetObjectId(eobj.PHDALInstDr)	 		
					s obj.PHDALManage=eobj.PHINSTMode //管控级别与主索引表的相同
					//d obj.PHDALDrgDrSetObjectId(eobj.PHDALDrgDr)
					d obj.PHDALCatDrSetObjectId(eobj.PHDALCatDr)		
					s obj.PHDALGrpNo=eobj.PHDALGrpNo				
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
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-可配伍药品",Insid,eobj.PHINSTText,"A",eobj)
			}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改单独用药
/// Table：User.DHCPHDrgAlone
/// Input：web.Entity.KB.DHCPHDrgAlone 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDrgAlone).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHDrgAlone) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//修改单独用药业务表
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHDrgAlone).%New()
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PHDALInstDr)
		s bobj.PHDALInstDr = eobj.PHDALInstDr
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
		
		s PHDALInstDr=eobj.PHDALInstDr
		//修改商品名业务表(先删除所有的商品名)
		s OPHDALDrgDrs=""
		s PHDALRowId=0
		for
		{
			s PHDALRowId=$o(^DHCPHDAL("0","Inst",PHDALInstDr,PHDALRowId)) q:PHDALRowId=""
			s PHDALDrgDr=$p($g(^DHCPHDAL(PHDALRowId)),"^",1) //商品名DR
			s PHNDesc=""
			s:PHDALDrgDr'="" PHNDesc=$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2) //商品名描述
			s:OPHDALDrgDrs'="" OPHDALDrgDrs=OPHDALDrgDrs_"、"_PHNDesc	
			s:OPHDALDrgDrs="" OPHDALDrgDrs=PHNDesc
			s obj=##class(User.DHCPHDrgAlone).%OpenId(PHDALRowId)
			s bobj.PHDALInstDr=PHDALInstDr	 		
			s bobj.PHDALManage=obj.PHDALManage //管控级别与主索引表的相同
			s:obj.PHDALDrgDr'="" bobj.PHDALDrgDr=obj.PHDALDrgDr.%Id()
			s:obj.PHDALCatDr'="" bobj.PHDALCatDr=obj.PHDALCatDr.%Id()		
			s bobj.PHDALGrpNo=obj.PHDALGrpNo
			s scphda=##class(User.DHCPHDrgAlone).%DeleteId(PHDALRowId)
		}
		s bobj.PHDALDrgDrs = OPHDALDrgDrs
		 //商品名多选
		s args=eobj.PHDALDrgDr
		if (args'="")
		{
			s argsLen=$Length(args,",")
			s PHDALDrgDrs=""
			for i=1:1:argsLen
			{ 
	               
				s eobj.PHDALDrgDr=$p(args,",",i)
				s PHNDesc=$p($g(^DHCPHPNA(eobj.PHDALDrgDr)),"^",2) //商品名描述
			    s:PHDALDrgDrs'="" PHDALDrgDrs=PHDALDrgDrs_"、"_PHNDesc	
			    s:PHDALDrgDrs="" PHDALDrgDrs=PHNDesc
			    
				s obj=##class(User.DHCPHDrgAlone).%New()				
				s eobj.PHDALInstDr=PHDALInstDr
				d obj.PHDALInstDrSetObjectId(eobj.PHDALInstDr)	 		
				s obj.PHDALManage=eobj.PHINSTMode //管控级别与主索引表的相同
				d obj.PHDALDrgDrSetObjectId(eobj.PHDALDrgDr)
				d obj.PHDALCatDrSetObjectId(eobj.PHDALCatDr)		
				s obj.PHDALGrpNo=eobj.PHDALGrpNo			
				s scDis=obj.%Save()
				d obj.%Close()
				if $$$ISOK(scDis)
				{			
					s id=obj.%Id()
					s result=result_"^"_1	
				}
				else
				{
					s result=result_"^"_0	
				}
			}
			s:OPHDALDrgDrs'="" PHDALDrgDrs=OPHDALDrgDrs_"、"_PHDALDrgDrs	
			s:OPHDALDrgDrs="" PHDALDrgDrs=PHDALDrgDrs
			s eobj.PHDALDrgDrs=PHDALDrgDrs
			
		}
		else{ //商品名为空，溶媒分类不为空
			if (eobj.PHDALCatDr'="")
			{
				s obj=##class(User.DHCPHDrgAlone).%New()				
				s eobj.PHDALInstDr=Insid
				d obj.PHDALInstDrSetObjectId(eobj.PHDALInstDr)	 		
				s obj.PHDALManage=eobj.PHINSTMode //管控级别与主索引表的相同
				//d obj.PHDALDrgDrSetObjectId(eobj.PHDALDrgDr)
				d obj.PHDALCatDrSetObjectId(eobj.PHDALCatDr)		
				s obj.PHDALGrpNo=eobj.PHDALGrpNo				
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-可配伍药品",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Description：查询单独用药业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrgAlone","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		//单独用药业务表^DHCPHDAL，通用名字典表^DHCPHPNA
		s PHINSTRowId=rowid
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)		
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("DrgAlone","U"),0))
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

/// Description:根据id删除 单独用药业务表
/// Table:User.DHCPHDrgAlone
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDrgAlone).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
	Tstart
		s bobj = ##class(web.Entity.KB.DHCPHDrgAlone).%New()
		//删除单独用药业务表
		s PHDALRowId=0
		s OPHDALDrgDrs=""
		for
		{
			s PHDALRowId=$o(^DHCPHDAL("0","Inst",id,PHDALRowId)) q:PHDALRowId=""	
			if (PHDALRowId'=""){
				s PHDALDrgDr=$p($g(^DHCPHDAL(PHDALRowId)),"^",1) //商品名DR
				s PHNDesc=""
				s:PHDALDrgDr'="" PHNDesc=$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2) //商品名描述
				s:OPHDALDrgDrs'="" OPHDALDrgDrs=OPHDALDrgDrs_"、"_PHNDesc	
				s:OPHDALDrgDrs="" OPHDALDrgDrs=PHNDesc
				s obj=##class(User.DHCPHDrgAlone).%OpenId(PHDALRowId)
				s bobj.PHDALInstDr=id	 		
				s bobj.PHDALManage=obj.PHDALManage //管控级别与主索引表的相同
				s:obj.PHDALDrgDr'="" bobj.PHDALDrgDr=obj.PHDALDrgDr.%Id()
				s:obj.PHDALCatDr'="" bobj.PHDALCatDr=obj.PHDALCatDr.%Id()		
				s bobj.PHDALGrpNo=obj.PHDALGrpNo	
					
				s sc=##class(User.DHCPHDrgAlone).%DeleteId(PHDALRowId)
				if $$$ISOK(sc)
				{
					s result=result_"^"_1
				}
				else
				{
					s result=result_"^"_0
				}
			}
		}
		s bobj.PHDALDrgDrs = OPHDALDrgDrs
		
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-可配伍药品",id,bobj.PHINSTText,"D",bobj)
		}
		
		q result
}

/// Description：根据主索引的id获取单独用药数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgAlone).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

/// Description：获取用法用量中已选病症的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDrgAlone).GetDiseaDr(67)
ClassMethod GetDiseaDr(InstId As %String) As %String
{
 s str=""
 if (InstId'="")
 {
	s PHDALRowId=0
	for
	{
		s PHDALRowId=$o(^DHCPHDAL(0,"Inst",InstId,PHDALRowId)) q:PHDALRowId=""
		s PHDALDrgDr=$p(^DHCPHDAL(PHDALRowId),"^",1) //病症Dr
		s PHNCode=$p($g(^DHCPHPNA(PHDALDrgDr)),"^",1) //病症代码 
		s str="<"_PHNCode_">^"_str
	}
 }
 q str
}

/// 查询适应症中病症已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrgAlone","GetDiseaList","37")
Query GetDiseaList(InstId) As %Query(ROWSPEC = "PHDALRowId,PHDALDrgDr,PHNCode,PHNDesc")
{
}

ClassMethod GetDiseaListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'="")
	{
		s PHDALRowId=0
		for
		{
			s PHDALRowId=$o(^DHCPHDAL(0,"Inst",InstId,PHDALRowId)) q:PHDALRowId=""
			s PHDALDrgDr=$p(^DHCPHDAL(PHDALRowId),"^",1) //病症Dr
			s PHNCode="",PHNDesc=""
			if (PHDALDrgDr'="") 
			{
				s PHNCode=$p($g(^DHCPHPNA(PHDALDrgDr)),"^",1) //病症代码 
			 	s PHNDesc=$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2) //病症描述			
				d OutputRowDis
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDis
    set Data=$lb(PHDALRowId,PHDALDrgDr,PHNCode,PHNDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseaListExecute ]
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

/// Description:根据病症id删除病症
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDrgAlone).DeleteDiseaData("121")
ClassMethod DeleteDiseaData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s sc=##class(User.DHCPHDrgAlone).%DeleteId(id)
		if $$$ISOK(sc)
		{
			s result="{success:'true',info:'删除成功！'}"
		}
		else
		{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'没有选中行'}"  //返回错误信息
	}
	q result
}

/// Description：查询未选病症字典的列表内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDrgAlone","GetUnSelDiseaList","34")
Query GetUnSelDiseaList(InstId As %String, diseaStr As %String, desc As %String) As %Query(ROWSPEC = "PHNRowId:%String,PHNCode:%String,PHNDesc:%String")
{
}

ClassMethod GetUnSelDiseaListExecute(ByRef qHandle As %Binary, InstId As %String, diseaStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s selectStr = ##class(web.DHCBL.KB.DHCPHDrgAlone).GetDiseaDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHNRowId=0
		for {
			s PHNRowId=$o(^DHCPHPNA(PHNRowId))
			q:PHNRowId=""
				s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)
				s Code = "<"_PHNCode_">"
				s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)
				s PHNDescU=$ZCONVERT(PHNDesc,"U")
				s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3) //是否可用 2018-02-06
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHNDesc)
				if ('(selectStr[Code))&('(diseaStr[Code))&((PHNDescU[desc)||(PINYIN[desc)) & (PHNActiveFlag'="N") //2016-08-09
				{
					d OutputRowUn
				}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUn
    set Data=$lb(PHNRowId,PHNCode,PHNDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
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

}
