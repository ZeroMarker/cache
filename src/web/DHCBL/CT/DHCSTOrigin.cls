/// 名称:产地	
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2017-8-16
Class web.DHCBL.CT.DHCSTOrigin Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "DHC_STOrigin";

/// Creator:陈莹
/// CreatDate:2017-8-16
/// Description:数据重复验证方法,js调用
/// Table:User.DHCSTOrigin
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.DHCSTOrigin).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, type As %String, hospid As %String = "") As %String
{
	new (id,code,desc,type,hospid)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCSTORI(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			s OrigType=$p($g(^DHCSTORI(idc)),"^",3)
			continue:(OrigType'=type)
			if (idc'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
			s idd=$o(^DHCSTORI(0,"Name",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			s OrigType=$p($g(^DHCSTORI(idd)),"^",3)
			continue:(OrigType'=type)
			if (idd'=id)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
				
			}
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-7
/// Description:增加/修改 产地
/// Table:User.DHCSTOrigin
/// Input:web.Entity.CT.DHCSTOrigin
/// Return:成功返回success:'true'和新增或修改的数据的OrigRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCSTOrigin) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		if eobj.OrigName="" s eobj.OrigName=eobj.OrigCode
		s flag=..FormValidate(eobj.OrigRowId,eobj.OrigCode,eobj.OrigName,eobj.OrigType,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		if (eobj.OrigRowId="")       
		{
			s obj=##class(User.DHCSTOrigin).%New()
		}
		else                           
		{
			s obj=##class(User.DHCSTOrigin).%OpenId(eobj.OrigRowId)
			s bobj=##class(web.Entity.CT.DHCSTOrigin).%New()
			s bobj.OrigRowId = eobj.OrigRowId
			s bobj.OrigCode = obj.OrigCode
			s bobj.OrigName = obj.OrigName
			s bobj.OrigType = obj.OrigType
			/*if $IsObject(obj.OrigHospDr){
					s bobj.OrigHospDr = obj.OrigHospDr.%Id() 
				}*/
			s bobj.OrigAlias=obj.OrigAlias
		}

		s obj.OrigCode = eobj.OrigCode
		s obj.OrigName = eobj.OrigName
		s obj.OrigType=eobj.OrigType
		//d obj.OrigHospDrSetObjectId(eobj.OrigHospDr)
		s obj.OrigAlias=eobj.OrigAlias
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.OrigRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_STOrigin","User.DHCSTOrigin","产地",id,eobj.OrigName,"A",eobj)
			d:eobj.OrigRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_STOrigin","User.DHCSTOrigin","产地",id,eobj.OrigName,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("产地","web.DHCBL.CT.DHCSTOrigin","SaveEntity",eobj)
	   		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}

	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

}
