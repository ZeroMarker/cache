/// 名称:科室授权
/// 描述:个人通讯录HIS科室关联HIS科室
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-02-02
Class web.DHCBL.CT.HCCSLocLinkLoc Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_HCCSLocLinkLoc";

/// Creator：基础数据平台-丁亚男
/// CreatDate: 2021-03-16
/// function:根据左侧HIS科室代码,右侧授权科室代码，判断该医呼通科室和HIS科室是否关联      
/// input:HIS科室代码,授权科室代码
/// Output:返回关联标志（true/false）以及关联rowid
/// w ##class(web.DHCBL.CT.HCCSLocLinkLoc).GetCheckFlagInfo("1","1")
ClassMethod GetCheckFlagInfo(AutHISCode As %String, HISLOCCode As %String) As %String
{
	s flag="false^"
	if (HISLOCCode'="")&&(AutHISCode'="")
	{
		if ($d(^CT("HCCSAUTLOC",0,"HISCode",HISLOCCode,AutHISCode))) 
		{
			s LLLRowId=$o(^CT("HCCSAUTLOC",0,"HISCode",HISLOCCode,AutHISCode,""))
			s flag="true^"_LLLRowId
		}	
	}
	q flag
}

/// Creator：丁亚男		
/// CreatDate: 2021-03-16
/// Description：查询 个人通讯录的HIS科室通讯录
/// Table:User.CTHCCSContactList,User.CTHCCSLocLinkLoc
/// Input:rowid,desc:HIS科室代码或者描述,医院ID:hospid
/// Output:HCCSCLRowId,HCCSCLUserCode,HCCSCLLocCode,HCCSCLVOIPNumber,HCCSCLUser,SSUSRName,checked
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSLocLinkLoc","GetDataForCmb1","","","","1","2","已选")
Query GetDataForCmb1(rowid As %String, desc As %String, LLLHISCode As %String, hospid As %String, CheckFlag As %String = "全部") As %Query(ROWSPEC = "HCCSCLRowId:%String,HCCSCLLocCode:%String,HCCSCLLocDesc:%String,HCCSCLLoc:%String,checked:%Boolean,LLLRowId")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, LLLHISCode As %String, hospid As %String, CheckFlag As %String = "全部") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HCCSCLRowId = rowid
		s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
		s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述HCCSCL_LocCode
		s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
		s checkstr=##class(web.DHCBL.CT.HCCSLocLinkLoc).GetCheckFlagInfo(HCCSCLLocCode,LLLHISCode)
		s checked=$p(checkstr,"^",1)
		s LLLRowId=$p(checkstr,"^",2)
	    
		d OutputRowCmb
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:CheckFlag="已选" CheckFlag="true"
		s:CheckFlag="未选" CheckFlag="false"
		
		s LocCode=0
		for 
		{
			s LocCode=$o(^CT("HCCSCL",0,"Loc",LocCode)) q:LocCode=""
			s HCCSCLRowId=0,OutputFlag=0
			for 
			{
				s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",LocCode,HCCSCLRowId)) q:HCCSCLRowId=""||OutputFlag=1
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSContactList",HCCSCLRowId,hospid)
				continue:showflag="N"
				s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
				s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
				s HCCSCLLoc=HCCSCLLocCode_"-"_HCCSCLLocDesc //科室代码-科室名
				s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLLocDesc)
				
				s checkstr=##class(web.DHCBL.CT.HCCSLocLinkLoc).GetCheckFlagInfo(HCCSCLLocCode,LLLHISCode)
				s checked=$p(checkstr,"^",1)
				s LLLRowId=$p(checkstr,"^",2)
				
				s CheckOutFlag=1
				if ((CheckFlag'="全部")&&(CheckFlag'=checked))
				{
					s CheckOutFlag=0
				}
			
				if ((($ZCONVERT(HCCSCLLocCode,"U")[desc)||($ZCONVERT(HCCSCLLocDesc,"U")[desc)) ||($ZCONVERT(PINYINCODE,"U")[desc))&&(CheckOutFlag=1)
				{
					s OutputFlag=1
					d OutputRowCmb	
				} 	
			}
		 }
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(HCCSCLRowId,HCCSCLLocCode,HCCSCLLocDesc,HCCSCLLoc,checked,LLLRowId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：基础数据平台-丁亚男
/// CreatDate: 2021-03-16
/// function:根据左侧HIS科室代码,右侧授权科室代码，判断该医呼通科室和HIS科室是否关联      
/// input:HIS科室代码,授权科室代码
/// Output:返回关联标志（true/false）以及关联rowid
/// w ##class(web.DHCBL.CT.HCCSLocLinkLoc).GetCheckFlagInfo("1","1")
ClassMethod GetCheckFlag(AutHISCode As %String, HISLOCCode As %String) As %String
{
	s flag="false"
	if (HISLOCCode'="")&&(AutHISCode'="")
	{
		if ($d(^CT("HCCSAUTLOC",0,"HISCode",HISLOCCode,AutHISCode))) 
		{
			s flag="true"
		}	
	}
	q flag
}

/// Creator:丁亚男 
/// CreatDate: 2021-03-16
/// Description：保存 个人通讯录HIS科室关联HIS科室
/// Input: eobj As web.Entity.CT.HCCSLocLinkLoc
/// Table：CT_HCCSLocLinkLoc
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.HCCSLocLinkLoc).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HCCSLocLinkLoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s flag=..GetCheckFlag(eobj.LLLAutHISCode,eobj.LLLHISCode)  //调用重复验证
		if (flag="true")
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.LLLRowId="")
		{
			s obj=##class(User.CTHCCSLocLinkLoc).%New() 
		}
		else
		{
			s obj=##class(User.CTHCCSLocLinkLoc).%OpenId(eobj.LLLRowId)
			s bobj=##class(web.Entity.CT.HCCSLocLinkLoc).%New()
			s bobj.LLLHISCode = obj.LLLHISCode  //HIS代码
			s bobj.LLLHISDesc = obj.LLLHISDesc  //HIS描述
			s bobj.LLLAutHISCode = obj.LLLAutHISCode  
			s bobj.LLLAutHISDesc = obj.LLLAutHISDesc  
			
		}
		s obj.LLLHISCode = eobj.LLLHISCode  //HIS代码
		s obj.LLLHISDesc = eobj.LLLHISDesc  //HIS代码
		s obj.LLLAutHISCode = eobj.LLLAutHISCode  
		s obj.LLLAutHISDesc = eobj.LLLAutHISDesc
		
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.LLLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocLinkLoc","User.CTHCCSLocLinkLoc","个人通讯录HIS科室授权HIS科室",eobj.LLLRowId,eobj.LLLHISDesc,"U",eobj,bobj)
    		d:eobj.LLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocLinkLoc","User.CTHCCSLocLinkLoc","个人通讯录HIS科室授权HIS科室",id,eobj.LLLHISDesc,"A",eobj)
			
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("个人通讯录HIS科室授权HIS科室","web.DHCBL.CT.HCCSLocLinkLoc","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-02-02
/// Description：根据id删除 个人通讯录HIS科室授权HIS科室
/// Table：CT_HCCSLocLinkLoc
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.HCCSLocLinkLoc).DeleteData("5||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s eobj = ##class(User.CTHCCSLocLinkLoc).%OpenId(id)
	s pobj = ##class(web.Entity.CT.HCCSLocLinkLoc).%New()
	s pobj.LLLHISCode=eobj.LLLHISCode	
	s pobj.LLLHISDesc=eobj.LLLHISDesc	
	s pobj.LLLAutHISCode = eobj.LLLAutHISCode  
	s pobj.LLLAutHISDesc = eobj.LLLAutHISDesc 
			
	d eobj.%Close()
	kill eobj
	Tstart
	s sc=##class(User.CTHCCSLocLinkLoc).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocLinkLoc","User.CTHCCSLocLinkLoc","个人通讯录HIS科室授权HIS科室",id,pobj.LLLHISDesc,"D",pobj)
	
		
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("个人通讯录HIS科室授权HIS科室","web.DHCBL.CT.HCCSLocLinkLoc","DeleteData",pobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-02-02
/// Description：右侧关联HIS科室保存方法  
/// Table：CT_HCCSLocLinkLoc
/// Input：HISCode,ChangeIDstr (前台变化的HIS科室id拼串)
/// Return：
/// Other: w ##class(web.DHCBL.CT.HCCSLocLinkLoc).SaveLocLink("ZYMZ001^呼吸内科门诊","3^4")
ClassMethod SaveLocLink(HISCodeDesc As %String, ChangeIDstr As %String) As %String
{
	s result=""
	
	s LLLHISCode=$p(HISCodeDesc,"^",1)
	s LLLHISDesc=$p(HISCodeDesc,"^",2)   
	// 变化的id串
	if (ChangeIDstr'="")
	{
		Ts
		s Changelen=$Length(ChangeIDstr,"^")
		//保存
		for j=1:1:Changelen
		{
		    
		    s HCCSCLRowId=$p(ChangeIDstr,"^",j)
		    s HCCSCLLocCode= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)		//科室代码
			s HCCSCLLocDesc= $p($g(^CT("HCCSCL",HCCSCLRowId)),"^",7)		//科室描述
		    if ('$d(^CT("HCCSAUTLOC",0,"HISCode",LLLHISCode,HCCSCLLocCode))) //判断是否存在,不存在增加
		    {
			   s eobj=##class(web.Entity.CT.HCCSLocLinkLoc).%New()
			   s eobj.LLLHISCode=LLLHISCode
			   s eobj.LLLHISDesc=LLLHISDesc
			   s eobj.LLLAutHISCode=HCCSCLLocCode
			   s eobj.LLLAutHISDesc=HCCSCLLocDesc
			   s resultstr=..SaveEntity(eobj) 
			  
			} 
			else  //存在删除
			{
				
				s id=$o(^CT("HCCSAUTLOC",0,"HISCode",LLLHISCode,HCCSCLLocCode,""))
				s resultstr=..DeleteData(id)
			} 
			
		 
		}
		s:result'="" result=result_","_resultstr
		s:result="" result=resultstr
	}
	if (result["false")
	{
		tro
		s result="{success:'false',info:'保存失败！'}"
	}
	else
	{
		tc
		s result= "{success:'true',info:'保存成功！'}"
	}
	
	q result
}

/// 根据用户工号返回科室授权界面授权的科室信息
/// likefan	2022-11-09
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSLocLinkLoc","GetAutLocByCode","hs01")
Query GetAutLocByCode(code As %String) As %Query(ROWSPEC = "LLLAutHISCode,LLLAutHISDesc")
{
}

ClassMethod GetAutLocByCodeExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s HCCSCLRowId=$o(^CT("HCCSCL",0,"User",code,0))
	if (HCCSCLRowId'="")
	{
		s HCCSCLLocCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",2)
		if (HCCSCLLocCode'="")
		{
			s HISCode=0
			for
			{
				s HISCode=$o(^CT("HCCSAUTLOC",0,"HISCode",HCCSCLLocCode,HISCode)) q:HISCode=""
				s LLLRowId=0
				for
				{
					s LLLRowId=$o(^CT("HCCSAUTLOC",0,"HISCode",HCCSCLLocCode,HISCode,LLLRowId)) q:LLLRowId=""
					s LLLAutHISCode=$p($g(^CT("HCCSAUTLOC",LLLRowId)),"^",3)	//授权his科室代码
					s LLLAutHISDesc=$p($g(^CT("HCCSAUTLOC",LLLRowId)),"^",4)	//授权his科室描述
					d OutputLoc
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLoc
    set Data=$lb(LLLAutHISCode,LLLAutHISDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAutLocByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAutLocByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAutLocByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAutLocByCodeExecute ]
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
