Import SQLUser

/// 名称: 重复用药维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-高姗姗
/// 编写日期:  2017-3-15
Class web.DHCBL.KB.DHCPHRepeatItm Extends %RegisteredObject
{

/// Description：打开重复用药数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHRepeatItm).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
		
	s eobj = ##class(web.Entity.KB.DHCPHRepeatItm).%New()
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(id)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	
	s PHRIRowId=0
	for
	{
		s PHRIRowId=$o(^DHCPHRITM("0","Inst",id,PHRIRowId)) q:PHRIRowId=""

		s PHRIProDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2)
		if (PHRIProDr'="") 
		{
			if (eobj.PHRIProDr'="")
			{
				s eobj.PHRIProDr =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)_","_eobj.PHRIProDr
			}
			else
			{
				s eobj.PHRIProDr =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)
			}
		} 
		s pobj = ##class(User.DHCPHRepeatItm).%OpenId(PHRIRowId)
		s eobj.PHRIRowId=PHRIRowId
		if $IsObject(pobj.PHRIInstDr){
			s eobj.PHRIInstDr = pobj.PHRIInstDr.%Id() 
			}
		s eobj.PHRIManage=pobj.PHRIManage
		if $IsObject(pobj.PHRIRuleDr){
			s eobj.PHRIRuleDr = pobj.PHRIRuleDr.%Id() 
			}
		s eobj.PHRIDateRange=pobj.PHRIDateRange
		s eobj.PHRIUnit=pobj.PHRIUnit
		
		d pobj.%Close()
		k pobj
	
	}
	d pobjIns.%Close()
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存重复用药
/// Table：User.DHCPHRepeatItm
/// Input：web.Entity.KB.DHCPHRepeatItm 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHRepeatItm).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHRepeatItm) As %String
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
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Repeat","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
			d objIns.PHINSTTypeDrSetObjectId(eobj.PHINSTTypeDr)		
			s objIns.PHINSTOrderNum=eobj.PHINSTOrderNum
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
			
			//开始保存到重复用药业务表
			s args=eobj.PHRIProDr
			if (args'="")
			{
				s PHDALDrgDrs=""
				s argsLen=$Length(args,",")
				for i=1:1:argsLen
				{
	                  
					s eobj.PHRIProDr=$p(args,",",i)
					s PHNDesc=$p($g(^DHCPHPNA(eobj.PHRIProDr)),"^",2) //商品名描述
					s:PHDALDrgDrs'="" PHDALDrgDrs=PHDALDrgDrs_"、"_PHNDesc	
					s:PHDALDrgDrs="" PHDALDrgDrs=PHNDesc
					
					s obj=##class(User.DHCPHRepeatItm).%New()				
					s eobj.PHRIInstDr=Insid
					d obj.PHRIInstDrSetObjectId(eobj.PHRIInstDr)	 		
					s obj.PHRIManage=eobj.PHINSTMode //管控级别与主索引表的相同
					d obj.PHRIProDrSetObjectId(eobj.PHRIProDr)
					d obj.PHRIRuleDrSetObjectId(eobj.PHRIRuleDr)
					//s obj.PHRIDateRange=eobj.PHRIDateRange
					//s obj.PHRIUnit=eobj.PHRIUnit	
										
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
			else{ //商品名为空，规则不为空
				if (eobj.PHRIRuleDr'="")
				{
					s obj=##class(User.DHCPHRepeatItm).%New()				
					s eobj.PHRIInstDr=Insid
					d obj.PHRIInstDrSetObjectId(eobj.PHRIInstDr)	 		
					s obj.PHRIManage=eobj.PHINSTMode //管控级别与主索引表的相同
					//d obj.PHRIProDrSetObjectId(eobj.PHRIProDr)
					d obj.PHRIRuleDrSetObjectId(eobj.PHRIRuleDr)
					//s obj.PHRIDateRange=eobj.PHRIDateRange
					//s obj.PHRIUnit=eobj.PHRIUnit
											
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
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-重复用药",Insid,eobj.PHINSTText,"A",eobj)
			
			}
	}	
				
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Description：修改重复用药
/// Table：User.DHCPHRepeatItm
/// Input：web.Entity.KB.DHCPHRepeatItm 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHRepeatItm).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHRepeatItm) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//修改重复用药业务表
		Ts
		//日志
		s bobj = ##class(web.Entity.KB.DHCPHRepeatItm).%New()
		//修改主索引表		
		s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PHRIInstDr)
		s bobj.PHRIInstDr = eobj.PHRIInstDr
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
		
		s PHRIInstDr=eobj.PHRIInstDr
		//修改商品名业务表(先删除所有的商品名)
		s OPHDALDrgDrs=""
		s PHRIRowId=0
		for
		{
			s PHRIRowId=$o(^DHCPHRITM("0","Inst",PHRIInstDr,PHRIRowId)) q:PHRIRowId=""
			s PHRIProDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2) //商品名DR
			if (PHRIProDr'="")  //谷雪萍 2020-04-20 重复用药修改报错
			{
				s PHNDesc=$p($g(^DHCPHPNA(PHRIProDr)),"^",2) //商品名描述
				if (PHNDesc'="")
				{
				s:OPHDALDrgDrs'="" OPHDALDrgDrs=OPHDALDrgDrs_"、"_PHNDesc	
				s:OPHDALDrgDrs="" OPHDALDrgDrs=PHNDesc
				}
			}
			s obj=##class(User.DHCPHRepeatItm).%OpenId(PHRIRowId)
			s bobj.PHRIInstDr=PHRIInstDr	 		
			s bobj.PHRIManage=obj.PHRIManage //管控级别与主索引表的相同
			s:obj.PHRIProDr'="" bobj.PHRIProDr=obj.PHRIProDr.%Id()
			s:obj.PHRIRuleDr'="" bobj.PHRIRuleDr=obj.PHRIRuleDr.%Id()
					
		}
		s bobj.PHDALDrgDrs = OPHDALDrgDrs
		 //商品名多选
		s args=eobj.PHRIProDr
		if (args'="")
		{
			s PHDALDrgDrs=""
			s argsLen=$Length(args,",")
			for i=1:1:argsLen
			{ 
	               
				s eobj.PHRIProDr=$p(args,",",i)
				s PHNDesc=$p($g(^DHCPHPNA(eobj.PHRIProDr)),"^",2) //商品名描述
			    s:PHDALDrgDrs'="" PHDALDrgDrs=PHDALDrgDrs_"、"_PHNDesc	
			    s:PHDALDrgDrs="" PHDALDrgDrs=PHNDesc
			    
				s obj=##class(User.DHCPHRepeatItm).%New()				
				s eobj.PHRIInstDr=PHRIInstDr
				d obj.PHRIInstDrSetObjectId(eobj.PHRIInstDr)	 		
				s obj.PHRIManage=eobj.PHINSTMode //管控级别与主索引表的相同
				d obj.PHRIProDrSetObjectId(eobj.PHRIProDr)
				d obj.PHRIRuleDrSetObjectId(eobj.PHRIRuleDr)
				//s obj.PHRIDateRange=eobj.PHRIDateRange
				//s obj.PHRIUnit=eobj.PHRIUnit					
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
			if (eobj.PHRIRuleDr'="")
			{
				s obj=##class(User.DHCPHRepeatItm).%New()				
				s eobj.PHRIInstDr=Insid
				d obj.PHRIInstDrSetObjectId(eobj.PHRIInstDr)	 		
				s obj.PHRIManage=eobj.PHINSTMode //管控级别与主索引表的相同
				//d obj.PHRIProDrSetObjectId(eobj.PHRIProDr)
				d obj.PHRIRuleDrSetObjectId(eobj.PHRIRuleDr)
				//s obj.PHRIDateRange=eobj.PHRIDateRange
				//s obj.PHRIUnit=eobj.PHRIUnit						
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-重复用药",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Description：查询重复用药业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHRepeatItm","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHINSTRowId,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		//重复用药业务表^DHCPHRITM，商品名字典表^DHCPHPNA
		s PHINSTRowId=rowid
		s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)		
		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("Repeat","U"),0))
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

/// Description:根据id删除 重复用药业务表
/// Table:User.DHCPHRepeatItm
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHRepeatItm).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
	Tstart
		s bobj = ##class(web.Entity.KB.DHCPHRepeatItm).%New()
		//删除重复用药业务表
		s PHRIRowId=0
		s OPHDALDrgDrs=""
		for
		{
			s PHRIRowId=$o(^DHCPHRITM("0","Inst",id,PHRIRowId)) q:PHRIRowId=""	

			s PHRIProDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2) //商品名DR
			if (PHRIProDr'="") //谷雪萍 2020-04-20 重复用药删除报错
			{
				s PHNDesc=$p($g(^DHCPHPNA(PHRIProDr)),"^",2) //商品名描述
				if (PHNDesc'="")
				{
					s:OPHDALDrgDrs'="" OPHDALDrgDrs=OPHDALDrgDrs_"、"_PHNDesc	
					s:OPHDALDrgDrs="" OPHDALDrgDrs=PHNDesc
				}
			}
			s obj=##class(User.DHCPHRepeatItm).%OpenId(PHRIRowId)
			s bobj.PHRIInstDr=id	 		
			s bobj.PHRIManage=obj.PHRIManage //管控级别与主索引表的相同
			s:obj.PHRIProDr'="" bobj.PHRIProDr=obj.PHRIProDr.%Id()
			s:obj.PHRIRuleDr'="" bobj.PHRIRuleDr=obj.PHRIRuleDr.%Id()
			
			s sc=##class(User.DHCPHRepeatItm).%DeleteId(PHRIRowId)
			if $$$ISOK(sc)
			{
				s result=result_"^"_1
			}
			else
			{
				s result=result_"^"_0
			}
			
		}
		s bobj.PHDALDrgDrs = OPHDALDrgDrs
		
		//删除主索引表			
		s objIns=##class(User.DHCPHInstructions).%OpenId(id)
		s bobj.PHRIInstDr = id
		s bobj.PHINSTMode=objIns.PHINSTMode
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
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器-重复用药",id,bobj.PHINSTText,"D",bobj)
		}
		
		q result
}

/// Description：根据主索引的id获取重复用药数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHRepeatItm).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

/// Description：获取用法用量中已选商品名的串
/// Other: w ##class(web.DHCBL.KB.DHCPHRepeatItm).GetGenericDr(67)
ClassMethod GetGenericDr(InstId As %String) As %String
{
 s str=""
 if (InstId'="")
 {
	s PHRIRowId=0
	for
	{
		s PHRIRowId=$o(^DHCPHRITM(0,"Inst",InstId,PHRIRowId)) q:PHRIRowId=""
		s PHRIProDr=$p(^DHCPHRITM(PHRIRowId),"^",2) //商品名Dr
		s PHNCode=$p($g(^DHCPHPNA(PHRIProDr)),"^",1) //商品名代码 
		s str="<"_PHNCode_">^"_str
	}
 }
 q str
}

/// 查询重复用药中商品名已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHRepeatItm","GetGenericList","857")
Query GetGenericList(InstId) As %Query(ROWSPEC = "PHRIRowId,PHRIProDr,PHNCode,PHNDesc")
{
}

ClassMethod GetGenericListExecute(ByRef qHandle As %Binary, InstId) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (InstId'="")
	{
		s PHRIRowId=0
		for
		{
			s PHRIRowId=$o(^DHCPHRITM(0,"Inst",InstId,PHRIRowId)) q:PHRIRowId=""
			s PHRIProDr=$p(^DHCPHRITM(PHRIRowId),"^",2) //商品名Dr
			s PHNCode="",PHNDesc=""
			if (PHRIProDr'="") 
			{
				s PHNCode=$p($g(^DHCPHPNA(PHRIProDr)),"^",1) //商品名代码 
			 	s PHNDesc=$p($g(^DHCPHPNA(PHRIProDr)),"^",2) //商品名描述			
				d OutputRowDis
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDis
    set Data=$lb(PHRIRowId,PHRIProDr,PHNCode,PHNDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGenericListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGenericListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGenericListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGenericListExecute ]
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

/// Description:根据商品名id删除商品名
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHRepeatItm).DeleteGenericData("121")
ClassMethod DeleteGenericData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s sc=##class(User.DHCPHRepeatItm).%DeleteId(id)
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

/// Description：查询未选商品名字典的列表内容
/// Table：User.DHCPHGenericseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHRepeatItm","GetUnSelGenericList","34")
Query GetUnSelGenericList(InstId As %String, GenericStr As %String, desc As %String) As %Query(ROWSPEC = "PHNRowId:%String,PHNCode:%String,PHNDesc:%String")
{
}

ClassMethod GetUnSelGenericListExecute(ByRef qHandle As %Binary, InstId As %String, GenericStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s selectStr = ##class(web.DHCBL.KB.DHCPHRepeatItm).GetGenericDr(InstId)
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s PHNRowId=0
		for {
			s PHNRowId=$o(^DHCPHPNA(PHNRowId))
			q:PHNRowId=""
				s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)
				s Code = "<"_PHNCode_">"
				s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)
				s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3) //是否可用 2018-02-06
				continue:PHNActiveFlag="N"
				s PHNDescU=$ZCONVERT(PHNDesc,"U")
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHNDesc)
				if ('(selectStr[Code))&('(GenericStr[Code))&((PHNDescU[desc)||(PINYIN[desc)) 
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

ClassMethod GetUnSelGenericListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelGenericListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelGenericListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelGenericListExecute ]
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
