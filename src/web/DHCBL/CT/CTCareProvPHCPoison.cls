/// 描述: 医护人员关联管制药品分类表，增删改查
/// 表名：User.CTCareProvPHCPoison
/// 编写者：基础数据平台-李可凡
/// 编写日期: 2020年3月23日
Class web.DHCBL.CT.CTCareProvPHCPoison Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月23日
/// Description：根据医护人员查询关联管制药品分类表
/// input: parref(指向父表，医护人员RowId)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProvPHCPoison","GetPHCPoison","1")
Query GetPHCPoison(parref As %String) As %Query(ROWSPEC = "PHCPORowId,PHCPODesc,LinkFlag")
{
}

ClassMethod GetPHCPoisonExecute(ByRef qHandle As %Binary, parref As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	
	s PHCPORowId=0
	for
	{
		s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""
		s PHCPOCode=$p($g(^PHCPO(PHCPORowId)),"^",1)
		s PHCPODesc=$p($g(^PHCPO(PHCPORowId)),"^",2)
		continue:(PHCPODesc["抗菌")
		continue:(PHCPODesc["辅助用药")
		continue:(PHCPOCode="ATD1")||(PHCPOCode="ATD2")
		s LinkFlag="N"
		if (parref'="")
		{
			s CPPChildsub=0
			for
			{
				s CPPChildsub=$o(^CTPCP(parref,"CPP",CPPChildsub)) q:CPPChildsub=""
				s CPPPHCPoisonDR=$p($g(^CTPCP(parref,"CPP",CPPChildsub)),"^",1)
				if (CPPPHCPoisonDR=PHCPORowId) 
				{
					s LinkFlag="Y"
					q
				}
			}
		}
		d Outputrow
	}
	
	
	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputrow
	set Data=$lb(PHCPORowId,PHCPODesc,LinkFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPHCPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPHCPoisonExecute ]
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

ClassMethod GetPHCPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPHCPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月23日
/// Description：医护人员关联管制药品分类表增删
/// Table：User.CTCareProvPHCPoison
/// Input：parref(医护人员RowId)，poisonids(管制药品分类RowId串)
/// Others：w ##class(web.DHCBL.CT.CTCareProvPHCPoison).UpdatePoison("1","1$Y")
ClassMethod UpdatePoison(parref As %String, poisonids As %String) As %String
{
	q:((parref="")||(poisonids="")) ""
    s result=1
    for i=1:1:$l(poisonids,"^")
	{
		s re=""
    	s str=$p(poisonids,"^",i)
    	s PHCPORowId=$p(str,"$",1)
    	s LinkFlag=$p(str,"$",2)
    	if LinkFlag="Y"
    	{
	    	s eobj=##class(web.Entity.CT.CTCareProvPHCPoison).%New()
			s eobj.CPPParRef=parref
			s eobj.CPPPHCPoisonDR=PHCPORowId
		    s re=..SaveEntity(eobj)
    	}
    	if LinkFlag="N"
    	{
	    	s CPPRowId=""
	    	s CPPChildsub=0
			for
			{
				s CPPChildsub=$o(^CTPCP(parref,"CPP",CPPChildsub)) q:CPPChildsub=""
				s CPPPHCPoisonDR=$p($g(^CTPCP(parref,"CPP",CPPChildsub)),"^",1)
				if (CPPPHCPoisonDR=PHCPORowId) 
				{
					s CPPRowId=parref_"||"_CPPChildsub
					q
				}
			}
			s:CPPRowId'="" re=..DeleteData(CPPRowId)
    	}
	}
	q result
}

/// function：医护人员关联管制药品分类表添加数据
/// Creator:李可凡
/// CreatDate:2020年3月25日
/// Table:User.CTCareProvPHCPoison
/// Input:web.Entity.CT.CTCareProvPHCPoison
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProvPHCPoison) As %String
{
	s result=""
	s flag=..FormValidate(eobj.CPPParRef,eobj.CPPPHCPoisonDR)
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		s obj=##class(User.CTCareProvPHCPoison).%New(eobj.CPPParRef)
		if (obj)
		{
			d obj.CPPParRefSetObjectId(eobj.CPPParRef)
			d obj.CPPPHCPoisonDRSetObjectId(eobj.CPPPHCPoisonDR)
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result= "{success:'true',id:'"_id_"'}"
				s CTPCPDesc=$p($g(^CTPCP(eobj.CPPParRef,1)),"^",2)
				s PHCPODesc=$p($g(^PHCPO(eobj.CPPPHCPoisonDR)),"^",2)
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_PHCPoison","User.CTCareProvPHCPoison","医护人员关联管制药品分类",id,CTPCPDesc_"-"_PHCPODesc,"A",eobj,"",eobj.CPPParRef)
			}
			else
			{
				Trollback
				s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联管制药品分类","web.DHCBL.CT.CTCareProvPHCPoison","AddData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
			}
		}
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月23日
/// Description：医护人员关联管制药品分类表数据校验
/// Table：User.CTCareProvPHCPoison
/// Input：表名table，版本号version，关联数据dataid
/// Output：1：重复		0：不重复
/// Others：w ##class(web.DHCBL.CT.CTCareProvPHCPoison).FormValidate("1","1")
ClassMethod FormValidate(parref As %String, poisondr As %String) As %String
{
	q:parref=""
	s flag=0
	s CPPChildsub=0
	for
	{
		s CPPChildsub=$o(^CTPCP(parref,"CPP",CPPChildsub)) q:CPPChildsub=""
		s CPPPHCPoisonDR=$p($g(^CTPCP(parref,"CPP",CPPChildsub)),"^",1)
		if (CPPPHCPoisonDR=poisondr)
		{
			s flag=1
			q
		}
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月23日
/// Description：删除医护人员关联管制药品分类表数据
/// Table：User.CTCareProvPHCPoison
/// Other: w ##class(web.DHCBL.CT.CTCareProvPHCPoison).DeleteData("1||3")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj=##class(web.Entity.CT.CTCareProvPHCPoison).%New()
	s obj=##class(User.CTCareProvPHCPoison).%OpenId(id)
	if (obj)
	{
		S pobj.CPPRowId=id
		s pobj.CPPParRef=obj.CPPParRef.%Id()
		s pobj.CPPChildsub=obj.CPPChildsub
		s:obj.CPPPHCPoisonDR'="" pobj.CPPPHCPoisonDR=obj.CPPPHCPoisonDR.%Id()
		TS
		s sc=##class(User.CTCareProvPHCPoison).%DeleteId(id)
		if $$$ISOK(sc)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"	
			s CTPCPDesc=$p($g(^CTPCP(pobj.CPPParRef,1)),"^",2)
			s PHCPODesc=$p($g(^PHCPO(pobj.CPPPHCPoisonDR)),"^",2)
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv_PHCPoison","User.CTCareProvPHCPoison","医护人员关联管制药品分类",id,CTPCPDesc_"-"_PHCPODesc,"D",pobj,"",pobj.CPPParRef)
		}
		else 
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联管制药品分类","web.DHCBL.CT.CTCareProvPHCPoison","DeleteData",pobj)
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
/// CreatDate:2020年4月9日
/// Description:根据用户RowId返回关联医护人员DR
/// Table:User.SSUser
/// Return:关联医护人员DR
/// Other: w ##class(web.DHCBL.CT.CTCareProvPHCPoison).GetCTPCPDR("14212")
ClassMethod GetCTPCPDR(id As %String) As %String
{
	q:id="" ""
	s SSUSRCareProvDR=$p($g(^SSU("SSUSR",id)),"^",14)      //医护人员DR
	q SSUSRCareProvDR
}

/// Creator: 李可凡
/// CreatDate:2020年11月10日
/// Description:根据医护人员id(CT_CareProv)、管制药品id(PHC_Poison)，返回是否授权
/// Table: CT_CareProv_PHCPoison
/// Input：医护人员id(CT_CareProv)、管制药品id(PHC_Poison)
/// Return:Y/N
/// Other: w ##class(web.DHCBL.CT.CTCareProvPHCPoison).GetDoctorPoison("1","1")
ClassMethod GetDoctorPoison(doctorid As %String, poisonid As %String) As %String
{
	q:doctorid="" ""
	q:poisonid="" ""
	s flag="N"
	s CPPChildsub=0
	for
	{
		s CPPChildsub=$o(^CTPCP(doctorid,"CPP",CPPChildsub)) q:CPPChildsub=""
		s CPPPHCPoisonDR=$p($g(^CTPCP(doctorid,"CPP",CPPChildsub)),"^",1)
		if (CPPPHCPoisonDR=poisonid) 
		{
			s flag="Y"
			q
		}
	}
	q flag
}

}
