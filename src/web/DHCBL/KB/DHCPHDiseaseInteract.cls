Import SQLUser

/// 名称: (相互作用)相互作用业务表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.DHCBL.KB.DHCPHDiseaseInteract Extends %RegisteredObject
{

/// Description：打开相互作用数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseInteract).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)	
	s eobj = ##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
	s eobj.PDINTRowId=id
	if $IsObject(pobj.PDINTInstDr){
		s eobj.PDINTInstDr = pobj.PDINTInstDr.%Id() 
	}
	s eobj.PDINTType=pobj.PDINTType
	s eobj.PDINTFlag=pobj.PDINTFlag
	if $IsObject(pobj.PDINTGenDr){
		s eobj.PDINTGenDr = pobj.PDINTGenDr.%Id() 
	}
	if $IsObject(pobj.PDINTDrugDr){
		s eobj.PDINTDrugDr = pobj.PDINTDrugDr.%Id() 
	}
	s eobj.PDINTManage=pobj.PDINTManage
	
	s pobjIns = ##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
	s eobj.PHINSTMode=pobjIns.PHINSTMode
	s eobj.PHINSTText=pobjIns.PHINSTText
	
	//通过索引获取分类业务表的RowId——CATIRowId
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
	s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
	if $IsObject(pobjCat.CATICatDr){
		s eobj.PDINTCatDr =pobjCat.CATICatDr.%Id() 
		}

	d pobj.%Close()
	d pobjIns.%Close()
	k pobj
	k pobjIns
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Description：保存相互作用
/// Table：User.DHCPHDiseaseInteract
/// Input：web.Entity.KB.DHCPHDiseaseInteract 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseInteract).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseInteract) As %String
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
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("InterEach","U"),0))
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
				//新增时，日志
				//d:eobj.PDINTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","主索引表",Insid,eobj.PDINTGenDr,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			
		//开始保存到相互作用业务表

			s obj=##class(User.DHCPHDiseaseInteract).%New()				
			s eobj.PDINTInstDr=Insid
			d obj.PDINTInstDrSetObjectId(eobj.PDINTInstDr)
			s eobj.PDINTType="I"
			s obj.PDINTType = eobj.PDINTType
			s obj.PDINTFlag = eobj.PDINTFlag 	 		
			s obj.PDINTManage=eobj.PHINSTMode //管控级别与主索引表的相同
			d obj.PDINTGenDrSetObjectId(eobj.PDINTGenDr)
			d obj.PDINTDrugDrSetObjectId(eobj.PDINTDrugDr)
			
			
							
			s scDis=obj.%Save()
			d obj.%Close()
			if $$$ISOK(scDis){
				s id=obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				
				//新增时，日志
				//d:eobj.PDINTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseInteract","User.DHCPHDiseaseInteract","相互作用业务表",id,eobj.PDINTGenDr,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		
		//开始保存到分类业务表

			s objCat=##class(User.DHCLibCatItm).%New()
			d objCat.CATIInstDrSetObjectId(Insid)
			d objCat.CATICatDrSetObjectId(eobj.PDINTCatDr)
			
		
			s scCat=objCat.%Save()
		
			d objCat.%Close()
			if $$$ISOK(scCat){
				s catId=objCat.%Id()
				s result = "{success:'true',id:'"_catId_"'}"  //返回RowId
				//s str="{PDAInstDr:'"_Insid_"',PDAAgeDr:'"_eobj.PDAAgeDr_"'}"
				//新增时，日志
				//d:eobj.PDINTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_LibCatItm","User.DHCLibCatItm","分类业务表",catId,eobj.PDINTCatDr,"A",eobj)
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scCat)_"'}"  //返回错误信息
			}
		
			if (result["true")
			{
				Tc
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器相互作用",Insid,eobj.PHINSTText,"A",eobj)
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

/// Description：修改相互作用
/// Table：User.DHCPHDiseaseInteract
/// Input：web.Entity.KB.DHCPHDiseaseInteract 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseInteract).UpdateData()
ClassMethod UpdateData(eobj As web.Entity.KB.DHCPHDiseaseInteract) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s eobj.PDINTInstDr=$p($g(^DHCPHDINTER(eobj.PDINTRowId)),"^",1)
		//修改相互作用业务表
		Ts
			//日志
			s bobj=##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
			
			s obj=##class(User.DHCPHDiseaseInteract).%OpenId(eobj.PDINTRowId) 
			s:obj.PDINTGenDr'="" bobj.PDINTGenDr=obj.PDINTGenDr.%Id()
			s:obj.PDINTDrugDr'="" bobj.PDINTDrugDr=obj.PDINTDrugDr.%Id()
			s bobj.PHINSTMode=obj.PDINTManage
			s bobj.PDINTFlag=obj.PDINTFlag
			s bobj.PDINTType=obj.PDINTType
			     
			d obj.PDINTGenDrSetObjectId(eobj.PDINTGenDr)
			d obj.PDINTDrugDrSetObjectId(eobj.PDINTDrugDr)
			s obj.PDINTManage=eobj.PHINSTMode
			s obj.PDINTFlag=eobj.PDINTFlag
			s eobj.PDINTType="I"
			
			s scDis=obj.%Save()
			d obj.%Close()
			if $$$ISOK(scDis){
				s id=obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		
			//修改主索引表		
			s objIns=##class(User.DHCPHInstructions).%OpenId(eobj.PDINTInstDr)
			s bobj.PHINSTMode=objIns.PHINSTMode
			s bobj.PHINSTText=objIns.PHINSTText
			
			s:objIns.PHINSTTypeDr'="" bobj.PHINSTTypeDr = objIns.PHINSTTypeDr.%Id()
			s bobj.PHINSTOrderNum=objIns.PHINSTOrderNum	
			s bobj.PHINSTGenDr = objIns.PHINSTGenDr
			s bobj.PHINSTPointerDr=objIns.PHINSTPointerDr
			s bobj.PHINSTPointerType=objIns.PHINSTPointerType
			s:objIns.PHINSTLibDr'="" bobj.PHINSTLibDr = objIns.PHINSTLibDr.%Id()
			s bobj.PHINSTActiveFlag=objIns.PHINSTActiveFlag
			s bobj.PHINSTSysFlag=objIns.PHINSTSysFlag
			
			s eobj.PHINSTTypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("InterEach","U"),0))
			s eobj.PHINSTLibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT("DRUG","U"),0))	
			s objIns.PHINSTMode=eobj.PHINSTMode	
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
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			
			//修改分类业务表
			//通过索引获取分类业务表的RowId——CATIRowId
			s CATIRowId=$o(^DHCLIBCATI("0","Inst",eobj.PDINTInstDr,0))
			if (CATIRowId'="")
			{
				s objCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
				s:objCat.CATICatDr'="" bobj.PDINTCatDr=objCat.CATICatDr.%Id()
			}
			else
			{
				s objCat = ##class(User.DHCLibCatItm).%New()
			}
			
			d objCat.CATICatDrSetObjectId(eobj.PDINTCatDr)
			d objCat.CATIInstDrSetObjectId(eobj.PDINTInstDr)
			s scCat=objCat.%Save()
			d objCat.%Close()
			if $$$ISOK(scCat){
				s catId=objCat.%Id()
				s result = "{success:'true',id:'"_catId_"'}"  //返回RowId
			}
			else
			{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
			
			if (result["true")
			{
				Tc
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器相互作用",Insid,eobj.PHINSTText,"U",eobj,bobj)
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
/// Description：查询相互作用业务表内容
/// Input：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseInteract","GetList","")
Query GetList(rowid, TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PDINTRowId,PHINSTMode,PDINTGenDr,PDINTCatDr,PDINTDrugDr,PHINSTText")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		
	if (rowid'="") //根据rowid返回该条记录
	{
		//相互作用业务表^DHCPHDINTER，通用名字典表^DHCPHEGEN
		s PDINTRowId=rowid
		s PDINTGenDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",2)  //通用名指针
		s:PDINTGenDr'="" PDINTGenDr=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
		s PDINTType=$p($g(^DHCPHDINTER(PDINTRowId)),"^",4)
		s PDINTFlag=$p($g(^DHCPHDINTER(PDINTRowId)),"^",5)
		s PDINTDrugDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",6)
		s:PDINTDrugDr'="" PDINTDrugDr=$p($g(^DHCPHPNA(PDINTDrugDr)),"^",2)
				
		//主索引表^DHCPHINSTRUC：PHINSTMode14 PHINSTSex9 PHINSTDocUseTips11 PHINSTNote 12
		s PHINSTRowId=$p($g(^DHCPHDINTER(PDINTRowId)),"^",1)
		s PHINSTText= $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
		s PHINSTMode= $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14)
		s:PHINSTMode="W" PHINSTMode="警示"
		s:PHINSTMode="C" PHINSTMode="管控"
		s:PHINSTMode="S" PHINSTMode="统计"
		
		//分类业务表
		s CATIRowId=$o(^DHCLIBCATI("0","Inst",PHINSTRowId,0))
		s PDINTCatDr=""
		s:CATIRowId'="" PDINTCatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
		s:PDINTCatDr'="" PDINTCatDr=$LISTGET($G(^User.DHCPHLibCatD(PDINTCatDr)),3) //分类标识名称

		d OutputRow
	}
	else
	{
	
		s PHINSTRowId=0
		for
		{
			s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT("InterEach","U"),0))
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PHINSTRowId)) q:PHINSTRowId=""	
			
				//相互作用业务表^DHCPHDINTER，通用名字典表^DHCPHEGEN
				s PDINTRowId=$o(^DHCPHDINTER("0","Inst",PHINSTRowId,0))
				//s PDINTInstDr=PHINSTRowId //主索引表指针
				s PDINTGenDr="",PDINTType="",PDINTCatDr="",PDINTFlag=""
				s:PDINTRowId'="" PDINTGenDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",2)  //通用名指针
				s:PDINTGenDr'="" PDINTGenDr=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
				s:PDINTRowId'="" PDINTType=$p($g(^DHCPHDINTER(PDINTRowId)),"^",4)
				s:PDINTRowId'="" PDINTFlag=$p($g(^DHCPHDINTER(PDINTRowId)),"^",5)
				s:PDINTRowId'="" PDINTDrugDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",6)
				s:PDINTDrugDr'="" PDINTDrugDr=$p($g(^DHCPHPNA(PDINTDrugDr)),"^",2)
				
				
				//主索引表^DHCPHINSTRUC：PHINSTMode14 PHINSTSex9 PHINSTDocUseTips11 PHINSTNote 12
				s PHINSTText= $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
				s PHINSTMode= $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14)
				s:PHINSTMode="W" PHINSTMode="警示"
				s:PHINSTMode="C" PHINSTMode="管控"
				s:PHINSTMode="S" PHINSTMode="统计"
				
				//分类业务表^DHCLIBCATI
				s CATIRowId=$o(^DHCLIBCATI("0","Inst",PHINSTRowId,0))
				s PDINTCatDr=""
				s:CATIRowId'="" PDINTCatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
				s:PDINTCatDr'="" PDINTCatDr=$LISTGET($G(^User.DHCPHLibCatD(PDINTCatDr)),3) //分类标识名称


				if (PDINTType="I"){
					d OutputRow
				}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDINTRowId,PHINSTMode,PDINTGenDr,PDINTCatDr,PDINTDrugDr,PHINSTText)
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

/// Description:根据id删除 相互作用业务表
/// Table:User.DHCPHDiseaseInteract
/// Input:id 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHDiseaseInteract).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
		s result=""			
		s InstDr=$p($g(^DHCPHDINTER(id)),"^",1)
	Tstart
		s eobj = ##class(web.Entity.KB.DHCPHDiseaseInteract).%New()
		s pobj = ##class(User.DHCPHDiseaseInteract).%OpenId(id)
		s eobj.PDINTRowId=id
		s:pobj.PDINTInstDr'="" eobj.PDINTInstDr=pobj.PDINTInstDr.%Id()
		s:pobj.PDINTGenDr'="" eobj.PDINTGenDr=pobj.PDINTGenDr.%Id()
		s:pobj.PDINTDrugDr'="" eobj.PDINTDrugDr=pobj.PDINTDrugDr.%Id()
		s eobj.PDINTManage=pobj.PDINTManage
		s eobj.PDINTType=pobj.PDINTType
		s eobj.PDINTFlag=pobj.PDINTFlag
			
		s sc=##class(User.DHCPHDiseaseInteract).%DeleteId(id)
		if $$$ISOK(sc){
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		
		s pobjIns = ##class(User.DHCPHInstructions).%OpenId(InstDr)
		s eobj.PHINSTText=pobjIns.PHINSTText
		s eobj.PHINSTMode=pobjIns.PHINSTMode
		if $IsObject(pobjIns.PHINSTTypeDr){
			 s eobj.PHINSTTypeDr=pobjIns.PHINSTTypeDr.%Id()
		}
		
		s eobj.PHINSTGenDr=pobjIns.PHINSTGenDr
		if $IsObject(pobjIns.PHINSTLibDr){
			s eobj.PHINSTLibDr=pobjIns.PHINSTLibDr.%Id()
		}		
		s eobj.PHINSTActiveFlag=pobjIns.PHINSTActiveFlag
		s eobj.PHINSTOrderNum=pobjIns.PHINSTOrderNum
		s eobj.PHINSTPointerDr=pobjIns.PHINSTPointerDr
		s eobj.PHINSTPointerType=pobjIns.PHINSTPointerType
		s eobj.PHINSTSysFlag=pobjIns.PHINSTSysFlag
		
			
		s scInst=##class(User.DHCPHInstructions).%DeleteId(InstDr)
		
		if $$$ISOK(scInst){
			s result="{success:'true',info:'删除成功！'}"
		}
		else{
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
		
		s CATIRowId=$o(^DHCLIBCATI("0","Inst",InstDr,0))
		if (CATIRowId'="")
		{
			s pobjCat = ##class(User.DHCLibCatItm).%OpenId(CATIRowId)
			s:pobjCat.CATICatDr'="" eobj.PDINTCatDr=pobjCat.CATICatDr.%Id()

			if $IsObject(pobjCat.CATIInstDr){
				s eobj.PDINTInstDr=pobjCat.CATIInstDr
			}
			
			s scAge=##class(User.DHCLibCatItm).%DeleteId(CATIRowId)
			if $$$ISOK(scAge){
				s result="{success:'true',info:'删除成功！'}"
			}
			else{
				s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			}
		}
		
		if (result["true")
		{
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","药品说明书编辑器相互作用",InstDr,eobj.PHINSTText,"D",eobj)	
		}
		else
		{
			Trollback
			s result = "{success:'false',info:'删除失败！'}"
		}
		q result
}

/// Description：文本说明框
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseInteract).GetText("9")
ClassMethod GetText(gen As %String, cat As %String) As %String
{
		s printText="",PDINTGenDesc="",PDINTCatDesc=""
		s:gen'="" PDINTGenDesc=$p($g(^DHCPHEGEN(gen)),"^",2)
		s:cat'="" PDINTCatDesc=$LISTGET($G(^User.DHCPHLibCatD(cat)),3) //分类标识名称
		s printText="{PDINTGenDesc:'"_PDINTGenDesc_"',PDINTCatDesc:'"_PDINTCatDesc_"'}"
		q printText
}

/// Description：根据主索引的id获取相互作用数据
/// Input：Instid
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseInteract).GetData("9")
ClassMethod GetData(InstId As %String) As %String
{
		/*s str=""
		//相互作用业务表^DHCPHDINTER，通用名字典表^DHCPHEGEN
		s PDINTRowId=$o(^DHCPHDINTER("0","Inst",InstId,0))
		s PDINTGenDr=$p($g(^DHCPHDINTER(PDINTRowId)),"^",2)  //通用名指针
		s:PDINTGenDr'="" PDINTGenDr=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
		if (PDINTGenDr'=""){
			s str=str_"【相互作用】"_PDINTGenDr
		}	
		q str*/
		s PHINSTText=""
		s PHINSTText=$p($g(^DHCPHINSTRUC(InstId)),"^",15)
		q PHINSTText
}

}
