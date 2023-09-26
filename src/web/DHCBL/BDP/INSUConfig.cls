/// 国家医保编码取值配置表
/// 基础数据平台-李可凡
/// 2021-11-08
/// sqldbx select: CF_BDP_BD.INSUConfig
Class web.DHCBL.BDP.INSUConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// 国家医保编码取值配置表保存
/// 基础数据平台-李可凡
/// 2021-11-08
/// input: 医院id^表名#取值配置^表名#取值配置^表名#取值配置^...
/// w ##class(web.DHCBL.BDP.INSUConfig).SaveData("")
ClassMethod SaveData(datastr As %String) As %String
{
	q:datastr="" ""
	s hospid=$p(datastr,"^",1)
	q:hospid="" "{success:'false',info:'医院不能为空！'}"
	s result=""
	s len=$l(datastr,"^")
	for i=2:1:len
	{
		s data=$p(datastr,"^",i)
		s table=$p(data,"#",1)
		continue:table=""
		s value=$p(data,"#",2)
		s re=""
		if (value'="")	//新增或修改
		{
			s eobj=##class(web.Entity.BDP.INSUConfig).%New()
			s eobj.HospitalDR=hospid
			s eobj.ConfigTable=table
			s eobj.ConfigValue=value
			s re=..SaveEntity(eobj)		//保存数据
			if (re["success:'false'")	//将失败的表名拼起来
			{
				s:result'="" result=result_"^"_table
				s:result="" result=table
			}
		}
	}
	if (result="")
	{
		s result="{success:'true'}"
	}
	else
	{
		s result="{success:'false',info:'"_result_" error'}"
	}
	q result
}

/// 国家医保编码取值配置表实际保存
/// 基础数据平台-李可凡
/// 2021-11-08
/// w ##class(web.DHCBL.BDP.INSUConfig).SaveEntity("")
ClassMethod SaveEntity(eobj As web.Entity.BDP.INSUConfig) As %String
{
	if (eobj.HospitalDR="")||(eobj.ConfigTable="")
	{
		q "{success:'false',info:'医院或表名错误'}"
	}
	s eobj.ID=$o(^CF.BDP.BD.INSUConfigI("ConfigIndex",eobj.HospitalDR,eobj.ConfigTable,0))
	if (eobj.ID="")
	{
		s obj=##class(CF.BDP.BD.INSUConfig).%New()
	}
	else
	{
		s obj=##class(CF.BDP.BD.INSUConfig).%OpenId(eobj.ID)
		s bobj=##class(web.Entity.BDP.INSUConfig).%New()
	    s bobj.ID=eobj.ID
	    s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR.%Id()
	    s bobj.ConfigTable=obj.ConfigTable
		s bobj.ConfigValue=obj.ConfigValue
	}
	d obj.HospitalDRSetObjectId(eobj.HospitalDR)	//医院
	s obj.ConfigTable=eobj.ConfigTable				//取值配置表
	s obj.ConfigValue=eobj.ConfigValue				//取值配置
	TS
	s sc=obj.%Save()
	if (sc=1)
	{
		TC
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s logdesc=""
		if eobj.HospitalDR'=""
		{
			s logdesc=$p($g(^CT("HOSP",eobj.HospitalDR)),"^",2)
			s logdesc=logdesc_"->"_eobj.ConfigTable
		}
		d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CF_BDP_BD.INSUConfig","CF.BDP.BD.INSUConfig","国家医保编码取值配置",eobj.ID,logdesc,"U",eobj,bobj)
		d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CF_BDP_BD.INSUConfig","CF.BDP.BD.INSUConfig","国家医保编码取值配置",id,logdesc,"A",eobj)
	}
	else
	{
		TRO
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

/*
/// Creator：基础数据平台-李可凡
/// CreatDate: 2021-11-08
/// Description：删除某医院下的某个表的配置
/// Table：CF_BDP_BD.INSUConfig
/// Others：w ##class(web.DHCBL.BDP.INSUConfig).DeleteData(3)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(CF.BDP.BD.INSUConfig).%OpenId(id)
		s pobj = ##class(web.Entity.BDP.INSUConfig).%New()
		s pobj.ID = id
		s:obj.HospitalDR'="" pobj.HospitalDR=obj.HospitalDR.%Id()
	    s pobj.ConfigTable=obj.ConfigTable
		s pobj.ConfigValue=obj.ConfigValue
		
		TS
		s sc=##class(CF.BDP.BD.INSUConfig).%DeleteId(id)
		if (sc=1)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			s logdesc=""
			if pobj.HospitalDR'=""
			{
				s logdesc=$p($g(^CT("HOSP",pobj.HospitalDR)),"^",2)
				s logdesc=logdesc_"->"_pobj.ConfigTable
			}
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CF_BDP_BD.INSUConfig","CF.BDP.BD.INSUConfig","国家医保编码取值配置",id,logdesc,"D",pobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}
*/
/// 根据医院rowid和表名，返回配置信息
/// 基础数据平台-李可凡
/// 2021-11-08
/// input: 医院id，表名（收费项DHC_TarItem、手术ORC_Operation、诊断MRC_ICDDx）
/// output: 配置信息 BDP、INSU,默认为BDP
/// w ##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId("2","DHC_TarItem")
ClassMethod GetConfigByHospId(hospid As %String, table As %String) As %String
{
	q:table="" "BDP"
	i (##class(websys.Conversions).IsValidMethodName("web.DHCBL.BDP.BDPMappingHOSP","GetDataType"))
    {
    	s DataType=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(table)	 //获取数据公有私有类型
    }
    else
    {
	    s DataType = "G"
	}
	if (DataType="G")
	{
		if (hospid="") s hospid=$o(^CT("HOSP",0))
	}
	q:hospid="" "BDP"
	s ID=$o(^CF.BDP.BD.INSUConfigI("ConfigIndex",hospid,table,0))
	q:ID="" "BDP"
	s Config=$lg($g(^CF.BDP.BD.INSUConfigD(ID)),4)
	s:Config="" Config="BDP"
	q Config
}

}
