Class web.DHCBL.KB.KBaseDefine Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：查询知识库度量定义表内容
/// Table：%IHBI.KBaseDefine
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KBaseDefine","GetList","","","","","")
Query GetList(rowid, desc) As %Query(ROWSPEC = "KBDRowId,KBDCode,KBDName,TableName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s KBDRowId=rowid
		s KBDCode=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),1)  //代码
		s KBDName=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),2)  //名称
		s TableName=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),3)  //数据来源
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s KBDRowId=0
		for  
		{	
			s KBDRowId=$o(^IHBI.KBaseDefineD(KBDRowId)) q:KBDRowId="" 
			
			s KBDCode=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),1)  //代码
			s KBDName=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),2)  //名称
			s KBDNameU=$ZCONVERT(KBDName,"U")
			s TableName=$listget($g(^IHBI.KBaseDefineD(KBDRowId)),3)  //数据来源
		
				i (KBDNameU[desc)   //条件
				{
					d OutputRow
				}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KBDRowId,KBDCode,KBDName,TableName)
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

/// Description:为combobox查询取数据
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KBaseDefine","GetDataForCmb1","InjectionDrug","")
Query GetDataForCmb1(code As %String) As %Query(ROWSPEC = "TableName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, code As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1

		s TableStr=""
		
		if (code="InjectionDrug"){ //注射药品
			s TableStr="PHC_Instruc"
		}
		elseif(code="OralDrug"){ //口服药品
			s TableStr="PHC_Instruc"
		}
		elseif(code="AntiDrug"){ //抗菌药品
			s TableStr="PHC_Poison,PHC_DrgForm"
		}
		elseif(code="LMAntiDrug"){ //限制抗菌药品
			s TableStr="PHC_Poison,PHC_DrgForm"
		}
		elseif(code="SPAntiDrug"){ //特殊抗菌药品
			s TableStr="PHC_Poison,PHC_DrgForm"
		}
		elseif(code="Material"){ //材料
			s TableStr="DHC_TarAC,DHC_TarAcctCate,DHC_TarEC,DHC_TarEMCCate,ARC_BillGrp,ARC_BillSub,OEC_OrderCategory,ARC_ItemCat,DHC_TarCate,DHC_TarSubCate,DHC_TarOC,DHC_TarOutpatCate,DHC_TarIC,DHC_TarInpatCate,DHC_TarMC,DHC_TarMRCate"
		}
		elseif(code="Examination"){ //检查
			s TableStr="DHC_TarAC,DHC_TarAcctCate,DHC_TarEC,DHC_TarEMCCate,ARC_BillGrp,ARC_BillSub,OEC_OrderCategory,ARC_ItemCat,DHC_TarCate,DHC_TarSubCate,DHC_TarOC,DHC_TarOutpatCate,DHC_TarIC,DHC_TarInpatCate,DHC_TarMC,DHC_TarMRCate"
		}
		elseif(code="LabTest"){ //检验
			s TableStr="DHC_TarAC,DHC_TarAcctCate,DHC_TarEC,DHC_TarEMCCate,ARC_BillGrp,ARC_BillSub,OEC_OrderCategory,ARC_ItemCat,DHC_TarCate,DHC_TarSubCate,DHC_TarOC,DHC_TarOutpatCate,DHC_TarIC,DHC_TarInpatCate,DHC_TarMC,DHC_TarMRCate"
		}
		elseif(code="Treatment"){ //治疗
			s TableStr="DHC_TarAC,DHC_TarAcctCate,DHC_TarEC,DHC_TarEMCCate,ARC_BillGrp,ARC_BillSub,OEC_OrderCategory,ARC_ItemCat,DHC_TarCate,DHC_TarSubCate,DHC_TarOC,DHC_TarOutpatCate,DHC_TarIC,DHC_TarInpatCate,DHC_TarMC,DHC_TarMRCate"
		}
		elseif(code="CriticalIll"){ //病危
			s TableStr="ARC_ItmMast"
		}
		elseif(code="SeriousIll"){ //病重
			s TableStr="ARC_ItmMast"
		}
		elseif(code="Rescue"){ //抢救
			s TableStr="ARC_ItmMast"
		}
		s TableLen = $Length(TableStr,",")
		
		for i=1:1:TableLen{
			s TableName = $p(TableStr,",",i)
			d OutputRow
		}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TableName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-2-28    
/// w ##class(web.DHCBL.KB.KBaseDefine).FormValidate("","Material")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=""
	s flagd=""
	s flagd=$d(^IHBI.KBaseDefineI("KBDCodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""	
		s idd=$o(^IHBI.KBaseDefineI("KBDCodeIndex",code,0))
		if ((idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：保存修改内容
/// Table：%IHBI.KBaseDefine
/// Input：web.Entity.KB.KBaseDefine 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.KBaseDefine) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		s flag=..FormValidate(eobj.KBDRowId, eobj.KBDCode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.KBDRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(%IHBI.KBaseDefine).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(%IHBI.KBaseDefine).%OpenId(eobj.KBDRowId)

				s bobj = ##class(web.Entity.KB.KBaseDefine).%New()
				s bobj.KBDRowId = eobj.KBDRowId
				s bobj.KBDCode = obj.KBDCode
				s bobj.KBDName = obj.KBDName
				s bobj.TableName = obj.TableName
			}
	
			s obj.KBDCode = eobj.KBDCode
			s obj.KBDName = eobj.KBDName
			s obj.TableName = eobj.TableName

			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.KBDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KBaseDefine","%IHBI.KBaseDefine","知识库度量定义表",id,eobj.KBDName,"A",eobj)
				d:eobj.KBDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KBaseDefine","%IHBI.KBaseDefine","知识库度量定义表",eobj.KBDRowId,eobj.KBDName,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			}	
		}
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：获取修改时的记录
/// Table：%IHBI.KBaseDefine
/// Other: d ##class(web.DHCBL.KB.KBaseDefine).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.KBaseDefine).%New()
	s pobj = ##class(%IHBI.KBaseDefine).%OpenId(id)
	s eobj.KBDRowId = id
	s eobj.KBDCode = pobj.KBDCode
	s eobj.KBDName = pobj.KBDName
	s eobj.TableName = pobj.TableName	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2015-2-26
/// Description:根据id删除
/// Table:%IHBI.KBaseDefine
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.KBaseDefine).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.KBaseDefine).%New()
		s pobj = ##class(%IHBI.KBaseDefine).%OpenId(id)
		s eobj.KBDRowId = id
		s eobj.KBDCode = pobj.KBDCode
		s eobj.KBDName = pobj.KBDName
		s eobj.TableName = pobj.TableName
	
		s sc=##class(%IHBI.KBaseDefine).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KBaseDefine","%IHBI.KBaseDefine","知识库度量定义表",id,eobj.KBDName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
