/// 描述: 医护人员关联处方权表，增删改查
/// 表名：User.CTCareProvPrescriptSet
/// 编写者：基础数据平台-李可凡
/// 编写日期: 2020年10月19日
Class web.DHCBL.CT.CTCareProvPrescriptSet Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年10月19日
/// Description：根据医护人员查询关联处方权表
/// input: parref(指向父表，医护人员RowId)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProvPrescriptSet","GetPrescriptSet","1")
Query GetPrescriptSet(parref As %String, hospid As %String = "") As %Query(ROWSPEC = "PSRowId,PSDesc,PSLinkFlag")
{
}

ClassMethod GetPrescriptSetExecute(ByRef qHandle As %Binary, parref As %String, hospid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	
	s PSRowId=0
	for
	{
		s PSRowId=$o(^DHCPRESCRIPTSET(PSRowId)) q:PSRowId=""
		s PSDesc=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",2)
		s PSType=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",3)
		s PSActive=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",5)	//是否有效
		s PSHospDr=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",7)	//医院
		continue:PSActive="N"
		continue:(PSHospDr'="")&&(hospid'="")&&(PSHospDr'=hospid)
		s:PSType="CM" PSType="草药"
		s:PSType="XM" PSType="西药"
		//s:PSType'="" PSDesc=PSDesc_"-"_PSType
		s PSLinkFlag="N"
		if (parref'="")
		{
			s CPPSChildsub=0
			for
			{
				s CPPSChildsub=$o(^CTPCP(parref,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
				s CPPSPrescriptSetDR=$p($g(^CTPCP(parref,"CPPS",CPPSChildsub)),"^",1)
				if (CPPSPrescriptSetDR=PSRowId) 
				{
					s PSLinkFlag="Y"
					q
				}
			}
		}
		d Outputrow
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputrow
	set Data=$lb(PSRowId,PSDesc,PSLinkFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrescriptSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescriptSetExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPrescriptSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescriptSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年10月19日
/// Description：医护人员关联处方权表增删
/// Table：User.CTCareProvPrescriptSet
/// Input：parref(医护人员RowId)，prescriptsetids(处方权RowId串)
/// Others：w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).UpdatePrescriptSet("1","1$Y")
ClassMethod UpdatePrescriptSet(parref As %String, prescriptsetids As %String) As %String
{
	q:((parref="")||(prescriptsetids="")) ""
    s result=1
    for i=1:1:$l(prescriptsetids,"^")
	{
		s re=""
    	s str=$p(prescriptsetids,"^",i)
    	s PSRowId=$p(str,"$",1)
    	s PSLinkFlag=$p(str,"$",2)
    	if PSLinkFlag="Y"
    	{
	    	s eobj=##class(web.Entity.CT.CTCareProvPrescriptSet).%New()
			s eobj.CPPSParRef=parref
			s eobj.CPPSPrescriptSetDR=PSRowId
		    s re=..SaveEntity(eobj)
    	}
    	if PSLinkFlag="N"
    	{
	    	s CPPSRowId=""
	    	s CPPSChildsub=0
			for
			{
				s CPPSChildsub=$o(^CTPCP(parref,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
				s CPPSPrescriptSetDR=$p($g(^CTPCP(parref,"CPPS",CPPSChildsub)),"^",1)
				if (CPPSPrescriptSetDR=PSRowId) 
				{
					s CPPSRowId=parref_"||"_CPPSChildsub
					q
				}
			}
			s:CPPSRowId'="" re=..DeleteData(CPPSRowId)
    	}
	}
	q result
}

/// function：医护人员关联处方权表添加数据
/// Creator:李可凡
/// CreatDate:2020年10月19日
/// Table:User.CTCareProvPrescriptSet
/// Input:web.Entity.CT.CTCareProvPrescriptSet
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProvPrescriptSet) As %String
{
	s result=""
	s flag=..FormValidate(eobj.CPPSParRef,eobj.CPPSPrescriptSetDR)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		s obj=##class(User.CTCareProvPrescriptSet).%New(eobj.CPPSParRef)
		if (obj)
		{
			d obj.CPPSParRefSetObjectId(eobj.CPPSParRef)
			d obj.CPPSPrescriptSetDRSetObjectId(eobj.CPPSPrescriptSetDR)
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"
				s CTPCPDesc=$p($g(^CTPCP(eobj.CPPSParRef,1)),"^",2)
				s PSDesc=$p($g(^DHCPRESCRIPTSET(eobj.CPPSPrescriptSetDR)),"^",2)
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_PrescriptSet","User.CTCareProvPrescriptSet","医护人员关联处方权",id,CTPCPDesc_"-"_PSDesc,"A",eobj,"",eobj.CPPSParRef)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联处方权","web.DHCBL.CT.CTCareProvPrescriptSet","AddData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
			}
		}
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年10月19日
/// Description：医护人员关联处方权表数据校验
/// Table：User.CTCareProvPrescriptSet
/// Input：表名table，版本号version，关联数据dataid
/// Output：1：重复		0：不重复
/// Others：w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).FormValidate("1","1")
ClassMethod FormValidate(parref As %String, prescriptsetdr As %String) As %String
{
	q:parref=""
	s flag=0
	s CPPSChildsub=0
	for
	{
		s CPPSChildsub=$o(^CTPCP(parref,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
		s CPPSPrescriptSetDR=$p($g(^CTPCP(parref,"CPPS",CPPSChildsub)),"^",1)
		if (CPPSPrescriptSetDR=prescriptsetdr)
		{
			s flag=1
			q
		}
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年10月19日
/// Description：删除医护人员关联处方权表数据
/// Table：User.CTCareProvPrescriptSet
/// Other: w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).DeleteData("1||3")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj=##class(web.Entity.CT.CTCareProvPrescriptSet).%New()
	s obj=##class(User.CTCareProvPrescriptSet).%OpenId(id)
	if (obj)
	{
		S pobj.CPPSRowId=id
		s pobj.CPPSParRef=obj.CPPSParRef.%Id()
		s pobj.CPPSChildsub=obj.CPPSChildsub
		s:obj.CPPSPrescriptSetDR'="" pobj.CPPSPrescriptSetDR=obj.CPPSPrescriptSetDR.%Id()
		TS
		s sc=##class(User.CTCareProvPrescriptSet).%DeleteId(id)
		if $$$ISOK(sc)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"	
			s CTPCPDesc=$p($g(^CTPCP(pobj.CPPSParRef,1)),"^",2)
			s PSDesc=$p($g(^DHCPRESCRIPTSET(pobj.CPPSPrescriptSetDR)),"^",2)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_PrescriptSet","User.CTCareProvPrescriptSet","医护人员关联处方权",id,CTPCPDesc_"-"_PSDesc,"D",pobj,"",pobj.CPPSParRef)
		}
		else 
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联处方权","web.DHCBL.CT.CTCareProvPrescriptSet","DeleteData",pobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result="{success:'false',info:'对象不存在'}"
	}
	q result
}

/// Creator: 李可凡
/// CreatDate:2020年10月19日
/// Description:根据用户RowId返回关联医护人员DR
/// Table:User.SSUser
/// Return:关联医护人员DR
/// Other: w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetCTPCPDR("14212")
ClassMethod GetCTPCPDR(id As %String) As %String
{
	q:id="" ""
	s SSUSRCareProvDR=$p($g(^SSU("SSUSR",id)),"^",14)      //医护人员DR
	q SSUSRCareProvDR
}

/// Creator: 李可凡
/// CreatDate:2020年11月10日
/// Description:根据医护人员id(CT_CareProv)、处方权id(DHC_PrescriptSet)，返回是否授权该处方权
/// Table:CT_CareProv_PrescriptSet
/// Return:Y/N
/// Other: w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetDoctorPrescript("1","1")
ClassMethod GetDoctorPrescript(doctorid As %String, prescriptid As %String) As %String
{
	q:doctorid="" ""
	q:prescriptid="" ""
	s flag="N"
	s CPPSChildsub=0
	for
	{
		s CPPSChildsub=$o(^CTPCP(doctorid,"CPPS",CPPSChildsub)) q:CPPSChildsub=""
		s CPPSPrescriptSetDR=$p($g(^CTPCP(doctorid,"CPPS",CPPSChildsub)),"^",1)
		if (CPPSPrescriptSetDR=prescriptid) 
		{
			s flag="Y"
			q
		}
	}
	q flag
}

/// Creator: 李可凡
/// CreatDate:2021-01-06
/// Description:根据处方权描述返回处方权id
/// input: 处方权描述，医院id
/// Return:处方权id
/// Other: w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc("中药",2)
ClassMethod GetPrescriptIdByDesc(desc As %String, hospid As %String) As %String
{
	q:desc="" ""
	q:hospid="" ""
	s resultid=""
	s PSRowId=0
	for
	{
		s PSRowId=$o(^DHCPRESCRIPTSET(PSRowId)) q:PSRowId=""
		s PSDesc=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",2)	//描述
		s PSActive=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",5)	//是否有效
		s PSHospDr=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",7)	//医院
		if (PSDesc=desc)&&(PSActive'="N")&&(PSHospDr=hospid)
		{
			s resultid=PSRowId
			q
		}
	}
	q resultid
}

/// Creator: 李可凡
/// CreatDate:2022-09-19
/// Description:根据处方权描述返回处方权id
/// input: 医院描述-处方权描述
/// Return:处方权id
/// Other: w ##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc2("东华标准版数字化口腔医院-草药")
ClassMethod GetPrescriptIdByDesc2(desc As %String) As %String
{
	s resultid=""
	q:desc'["-" ""
	
	s hospdesc=$p(desc,"-",1)
	s prescriptdesc=$p(desc,"-",2)
	q:hospdesc="" ""
	q:prescriptdesc="" ""
	s hospid=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospdesc),0))
	q:hospid="" ""
	
	s PSRowId=0
	for
	{
		s PSRowId=$o(^DHCPRESCRIPTSET(PSRowId)) q:PSRowId=""
		s PSDesc=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",2)	//描述
		s PSType=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",3)	//类型
		s PSActive=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",5)	//是否有效
		s PSHospDr=$p($g(^DHCPRESCRIPTSET(PSRowId)),"^",7)	//医院
		if (PSDesc=prescriptdesc)&&(PSActive'="N")&&(PSHospDr=hospid)
		{
			s resultid=PSRowId
			q
		}
	}
	
	q resultid
}

}
