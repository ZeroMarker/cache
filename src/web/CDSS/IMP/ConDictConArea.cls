/// 名称:实施综合管理平台-字典对照-对接方字典关联院区表V2.0
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2022-12-14
Class web.CDSS.IMP.ConDictConArea Extends %RegisteredObject
{

/// Creator:胡宜良
/// CreatDate:2022-12-14
/// Description：保存对接方字典关联院区表V2.0
/// Table:CT.WDT.CDSS.ConDictConArea 对接方字典关联院区表V2.0
/// Input: eobj As web.CDSSEntity.IMP.ConDictConArea
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.CDSS.IMP.ConDictConArea).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.CDSSEntity.IMP.ConDictConArea) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s flag=..FormValidate(eobj.ID,eobj.ConDictType,eobj.InterDictDR,eobj.HospAreaDR)  //调用重复验证
		if (flag=1)	//校验重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")	//新增
		{	
	        s obj=##class(CT.WDT.CDSS.ConDictConArea).%New()
	        
		}
		else	//修改
		{
			s obj=##class(CT.WDT.CDSS.ConDictConArea).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New()
			s bobj.ID = eobj.ID
			
			s:obj.HospAreaDR'="" bobj.HospAreaDR = obj.HospAreaDR.%Id()	//院区指针
			s bobj.ConDictType=obj.ConDictType			//对接方字典类型
			s bobj.InterDictDR=obj.InterDictDR			//对接方字典DR
		}

		d:eobj.HospAreaDR'="" obj.HospAreaDRSetObjectId(eobj.HospAreaDR)		//院区指针
		d:eobj.HospAreaDR="" obj.HospAreaDRSetObjectId("")	
			
		s obj.ConDictType=eobj.ConDictType			
		s obj.InterDictDR=eobj.InterDictDR			//对接方字典DR
			
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区表V2.0",id,eobj.HospAreaDR_"-"_eobj.ConDictType_"-"_eobj.InterDictDR,"A",eobj)
		    d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区表V2.0",id,eobj.HospAreaDR_"-"_eobj.ConDictType_"-"_eobj.InterDictDR,"U",eobj,bobj)
			
		}
		else
		{
			Trollback
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方字典关联院区表V2.0","web.CDSS.IMP.ConDictConArea","SaveEntity",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:胡宜良 
/// CreatDate:2022-12-14
/// Description:数据重复验证方法,js调用
/// Table:CT.WDT.CDSS.ConDictConArea 保存对接方字典关联院区表V2.0
/// Input:id, 
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.IMP.ConDictConArea).FormValidate("","检验医嘱","39185","31||11")
ClassMethod FormValidate(id As %String, condicttype As %String, interdictDR As %String, hospareaDR As %String) As %String
{
	s flag=""
	s flagc=""
	//ConDictType,InterDictDR,HospAreaDR
	s:((condicttype'="")&&(interdictDR'="")&&(hospareaDR'="")) flagc=$d(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",condicttype,interdictDR,hospareaDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0)
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
		s idc=""
		s:((condicttype'="")&&(interdictDR'="")&&(hospareaDR'="")) idc=$o(^CT.WDT.CDSS.ConDictConAreaI("ConAreaIndex",condicttype,interdictDR,hospareaDR,0))
		if (idc'="")&(idc'=id)&(flagc>0)
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

/// d ##class(web.CDSS.IMP.ConDictConArea).SaveData("","11",237156,"16||13")
ClassMethod SaveData(id, ConDictType, InterDictDR, HospAreaDR)
{
	s result=""
	if (ConDictType'="")  //如果入参数据类型不为空
	{	
		//如果入参是标准的类型名称，则通过对接方字典分类表的名称索引取id			
		s type=$case(ConDictType,"1":"诊断","2":"检查检验","3":"检查检验","4":"药品","5":"手术","6":"护理","7":"频率","8":"体征信息","9":"检验标本","10":"用法","11":"单位","12":"科室","13":"检查检验","14":"输血品","15":"中药","16":"中医诊断","17":"中医证型",:"")
		//如果入参不是标准的类型名称,则单独处理
		s:type="" type=$case(ConDictType,"诊断":"诊断","药品":"药品","药物":"药品","手术":"手术","检查":"检查检验","检验项目":"检查检验","体征":"体征信息","检验医嘱":"检查检验","输血":"输血品","护理":"护理","频率":"频率","体征信息":"体征信息","检验标本":"检验标本","用法":"用法","单位":"单位","科室":"科室","输血品":"输血品","中药":"中药","中医诊断":"中医诊断","中医证型":"中医证型",:"")
	 	
	}
	q:(HospAreaDR="") "false"			
	s eobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New()
	s eobj.ID = id
	s eobj.ConDictType= type		//对照类型
	s eobj.InterDictDR=InterDictDR		//对接方字典代码
	s eobj.HospAreaDR=HospAreaDR		//对接方字典描述	
	s linkresult=##class(web.CDSS.IMP.ConDictConArea).SaveEntity(eobj)
	if (linkresult["false")		//保存失败
	{
		s result="false"
		
	}
	else	//保存成功
	{
		s result="true"
	}
	q result
}

/// Creator:胡宜良 
/// CreatDate:2022-12-14
/// Description:数据删除方法
/// Table：CT.WDT.CDSS.ConDictConArea
/// Input: id 
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.IMP.ConDictConArea).DeleteData("14")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(CT.WDT.CDSS.ConDictConArea).%OpenId(id) 
	s eobj = ##class(web.CDSSEntity.IMP.ConDictConArea).%New() 
	s eobj.ConDictType=pobj.ConDictType
	s eobj.InterDictDR=pobj.InterDictDR          //修改描述	
	s eobj.HospAreaDR=pobj.HospAreaDR

	d pobj.%Close()
	Quit:id="" result="{success:'false',info:'删除失败,入参为空！'}"  
	Ts
	s sc=##class(CT.WDT.CDSS.ConDictConArea).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.ConDictConArea","CT.WDT.CDSS.ConDictConArea","对接方字典关联院区表V2.0",id,eobj.HospAreaDR_"-"_eobj.ConDictType_"-"_eobj.InterDictDR,"D",eobj)
	}
	else
	{
		Tro
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
	    s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("对接方字典关联院区表V2.0","web.CDSS.IMP.ConDictConArea","DeleteData",eobj)
	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
	}
	Quit result
}

/// Creator:谷雪萍
/// CreatDate:2023-03-16
/// Description:删除对接方关联院区数据
/// Table：CT.WDT.CDSS.ConDictConArea
/// Input: ConDictType-类型，InterDictDR-对接方字典ID
/// Return:删除成功返回{success:'true',info:'删除成功！'}，失败返回{success:'false',info:""}
/// others:w ##class(web.CDSS.IMP.ConDictConArea).DelHospArea(ConDictType,InterDictDR)
ClassMethod DelHospArea(ConDictType As %String, InterDictDR As %String) As %String
{
	s result=""
	TS
	s ConAreaID=0
	for
	{
		s ConAreaID=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",ConDictType,InterDictDR,ConAreaID))
		q:ConAreaID=""
		s result=..DeleteData(ConAreaID)
		if (result["false")
		{
			q
		}
	}
	if (result["false")
	{
		tro
	}
	else
	{
		tc
		s result = "{success:'true',info:'删除成功！'}"	
	}
	q result
}

/*// others:w ##class(web.CDSS.IMP.ConDictConArea).DelHospArea(ConDictType,InterDictDR)
ClassMethod DelHospArea(ConDictType As %String, InterDictDR As %String) As %String
{
	s result=""
	s id=$o(^CT.WDT.CDSS.ConDictConAreaI("InterDictDRIndex",ConDictType,InterDictDR,0))
	if (id'=""){
		s result=..DeleteData(id)
	}
	q result
}*/
}
