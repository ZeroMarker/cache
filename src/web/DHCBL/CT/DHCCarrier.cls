/// 名称:配送商
/// 描述:导入配送商保存方法
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2017-09-04
Class web.DHCBL.CT.DHCCarrier Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "DHC_Carrier";

/// Creator:陈莹
/// CreatDate:2020-6-11
/// Description:数据重复验证方法,js调用
/// Table:DHC_Carrier
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.DHCCarrier).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, type As %String, hospid As %String = "") As %String
{
	new (id,code,desc,type,hospid)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^DHCCARR(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			if (idc'=id)
			{
				s CAType=$p($g(^DHCCARR(idc)),"^",3)  //2021-01-04 校验类型
				continue:type'=CAType
				//s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				//continue:showflag="N"
				s flag=1
			}
		}
	}
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
			s idd=$o(^DHCCARR(0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			if (idd'=id)
			{
				s CAType=$p($g(^DHCCARR(idd)),"^",3)  //2021-01-04 校验类型
				continue:type'=CAType
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

/// Creator:陈莹
/// CreatDate:2012-9-4
/// Description:增加/修改配送商
/// Table:User.DHCCarrier
/// Input:web.Entity.CT.DHCCarrier
/// Return:成功返回success:'true'和新增或修改的数据的CARowid;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCCarrier) As %String
{
    new (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.CARowid,eobj.CACode,eobj.CADesc,eobj.CAType,eobj.LinkHospId)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		
		if (eobj.CARowid="")       
		{
			s obj=##class(User.DHCCarrier).%New()
		}
		else                           
		{
			s obj=##class(User.DHCCarrier).%OpenId(eobj.CARowid)
			s bobj=##class(web.Entity.CT.DHCCarrier).%New()
			s bobj.CARowid = eobj.CARowid
			s bobj.CACode = obj.CACode
			s bobj.CADesc = obj.CADesc
			s bobj.CAType = obj.CAType
			s bobj.CAMobile = obj.CAMobile
		}

		s obj.CACode = eobj.CACode
		s obj.CADesc = eobj.CADesc
		s obj.CAType = eobj.CAType
		s obj.CAMobile = eobj.CAMobile
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.CARowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_Carrier","User.DHCCarrier","配送商",id,eobj.CADesc,"A",eobj)
			d:eobj.CARowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_Carrier","User.DHCCarrier","配送商",id,eobj.CADesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("配送商","web.DHCBL.CT.DHCCarrier","SaveEntity",eobj)
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

/// Creator:陈莹
/// CreatDate:2021-12-16
/// Description:清除配送商相关数据
/// Other:d ##class(web.DHCBL.CT.DHCCarrier).ClearData()
ClassMethod ClearData()
{
	n
	k ^DHCCARR,^mdata("DHCCARRIER")
	
	///清除资质信息表
	S Type="Carrier" //(Vendor代表供应商, Manf代表厂商, Carrier代表配送商)
	s CERTID=0
	for  
	{	
		s CERTID=$o(^User.DHCCertDetailD(CERTID)) q:CERTID=""
		s CERTOrgType=$listget($g(^User.DHCCertDetailD(CERTID)),3)
		if (CERTOrgType=Type)
		{
			d ##class(User.DHCCertDetail).%DeleteId(CERTID)
		}
	}
}

}
