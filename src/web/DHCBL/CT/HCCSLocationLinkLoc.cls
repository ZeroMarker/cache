/// 名称:个人通讯录
/// 描述:医呼通科室关联HIS科室
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-02-02
Class web.DHCBL.CT.HCCSLocationLinkLoc Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_HCCSLocationLinkLoc";

/// Creator：基础数据平台-丁亚男
/// CreatDate: 2021-02-02
/// function:根据HIS科室代码,医呼通科室id，判断该医呼通科室和HIS科室是否关联      
/// input:CTLOCCode(个人通讯录rowid),groupid(群组rowid)
/// Output:返回关联标志（true/false）以及关联rowid
/// w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetCheckFlagInfo("1","1")
ClassMethod GetCheckFlagInfo(CTLOCCode, LOCRowId As %String) As %String
{
	s flag="false^"
	if (CTLOCCode'="")&&(LOCRowId'="")
	{
		if ($d(^CT("HCCSLOC",0,"HISCode",LOCRowId,CTLOCCode))) 
		{
			s LLLRowId=$o(^CT("HCCSLOC",0,"HISCode",LOCRowId,CTLOCCode,""))
			s flag="true^"_LLLRowId
		}	
	}
	q flag
}

/// Creator：丁亚男		
/// CreatDate: 2021-02-02
/// Description：查询 HIS科室通讯录
/// Table:User.CTLoc,User.CTHCCSLocationLinkLoc
/// Input:rowid, desc:HIS科室代码或者描述, CTLOCDepDR:科室组ID,parref:医呼通科室表ID, 医院ID:hospid
/// Output:HCCSCLRowId,HCCSCLUserCode,HCCSCLLocCode,HCCSCLVOIPNumber,HCCSCLUser,SSUSRName,checked
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HCCSLocationLinkLoc","GetDataForCmb1","","","","1","2","已选")
Query GetDataForCmb1(rowid As %String, desc As %String, CTLOCDepDR As %String, parref As %String, hospid As %String, CheckFlag As %String = "全部") As %Query(ROWSPEC = "CTLOCRowID,CTLOCCode,CTLOCDesc,DEPDesc,checked:%Boolean,LLLRowId,LacationDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, CTLOCDepDR As %String, parref As %String, hospid As %String, CheckFlag As %String = "全部") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLOCRowID=rowid
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
        s CTLOCDepDR1=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
        s DEPDesc=""
        s:CTLOCDepDR1'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR1)),"^",2)  //科室部门组描述 
		s checkstr=##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetCheckFlagInfo(CTLOCCode,parref)
		s checked=$p(checkstr,"^",1)
		s LLLRowId=$p(checkstr,"^",2)
		s Lacation= ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode(CTLOCCode)  //获取his科室代码已经关联的医呼通科室
        s LacationDesc=$p(Lacation,"^",3)
	    
		d OutputRowCmb
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:CheckFlag="已选" CheckFlag="true"
		s:CheckFlag="未选" CheckFlag="false"
		
		s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            
            
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc",CTLOCRowID,hospid)
			
			continue:showflag="N"
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        	s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
        	s CTLOCDepDR1=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
        	s DEPDesc=""
        	s:CTLOCDepDR1'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR1)),"^",2)  //科室部门组描述 
        	s Lacation= ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode(CTLOCCode)  //获取his科室代码已经关联的医呼通科室
        	s LacationDesc=$p(Lacation,"^",3)
			s checkstr=##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetCheckFlagInfo(CTLOCCode,parref)		//是否关联	
			s checked=$p(checkstr,"^",1)
			s LLLRowId=$p(checkstr,"^",2)
			
			s CheckOutFlag=1
			if ((CheckFlag'="全部")&&(CheckFlag'=checked))
			{
				s CheckOutFlag=0
			}
			
		
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) // 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc) 
		        }
				if ((($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYINCODE[desc)) ||($ZCONVERT(CTLOCCode,"U")[desc))
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			
			if (CTLOCDepDR'="")           
			{
				;对科室组检索&&((CTLOCDepDR="")||(CTLOCDepDR=CTLOCDepDR1))
				s LocFlag= 0
				if (CTLOCDepDR=CTLOCDepDR1)
				{
					s LocFlag= 1	
				} 
			}
			else
			{
				s LocFlag= 1
			} 
			
			i (AliasFlag=1)&&(CheckOutFlag=1)&&(LocFlag=1)
			{
				d OutputRowCmb
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc,DEPDesc,checked,LLLRowId,LacationDesc)
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
/// CreatDate: 2021-02-02
/// function:根据HIS科室代码,医呼通科室id，判断该医呼通科室和HIS科室是否关联      
/// input:CTLOCCode(个人通讯录rowid),groupid(群组rowid)
/// Output:返回关联标志（true/false）以及关联rowid
/// w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetCheckFlag("1","1")
ClassMethod GetCheckFlag(CTLOCCode, LOCRowId As %String) As %String
{
	s flag="false"
	s Location= ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode(CTLOCCode)
	s LocationID=$P(Location,"^",1)
	if (LocationID'="")&&(LocationID'=LOCRowId)
	{
		s flag="true"
	}
	if (CTLOCCode'="")&&(LOCRowId'="")
	{
		if ($d(^CT("HCCSLOC",0,"HISCode",LOCRowId,CTLOCCode))) 
		{
			s flag="true"
		}	
	}
	
	
	
	q flag
}

/// Creator:丁亚男 
/// CreatDate: 2020-12-25
/// Description：保存 医呼通科室关联HIS科室表
/// Input: eobj As web.Entity.CT.HCCSLocationLinkLoc
/// Table：CT_HCCSLocationLinkLoc
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HCCSLocationLinkLoc) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s flag=..GetCheckFlag(eobj.LLLHISCode,eobj.LLLParRef)  //调用重复验证
		if (flag="true")
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.LLLRowId="")
		{
			s obj=##class(User.CTHCCSLocationLinkLoc).%New(eobj.LLLParRef) 
		}
		else
		{
			s obj=##class(User.CTHCCSLocationLinkLoc).%OpenId(eobj.LLLRowId)
			s bobj=##class(web.Entity.CT.HCCSLocationLinkLoc).%New()
			s bobj.LLLHISCode = obj.LLLHISCode  //HIS代码
			s bobj.LLLHISDesc = obj.LLLHISDesc  //HIS代码
			
		}
		d obj.LLLParRefSetObjectId(eobj.LLLParRef)  //群组id
		s obj.LLLHISCode = eobj.LLLHISCode  //HIS代码
		s obj.LLLHISDesc = eobj.LLLHISDesc  //HIS代码
		
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s HCCSLOCDesc=$p($g(^CT("HCCSLOC",eobj.LLLParRef)),"^",2)  //医呼通名称
			d:eobj.LLLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocationLinkLoc","User.CTHCCSLocationLinkLoc","医呼通科室关联HIS科室",eobj.LLLRowId,HCCSLOCDesc_"-"_eobj.LLLHISDesc,"U",eobj,bobj)
    		d:eobj.LLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocationLinkLoc","User.CTHCCSLocationLinkLoc","医呼通科室关联HIS科室",id,HCCSLOCDesc_"-"_eobj.LLLHISDesc,"A",eobj)
			
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通科室关联HIS科室","web.DHCBL.CT.HCCSLocationLinkLoc","SaveEntity",eobj)
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
/// Description：根据id删除 医呼通科室关联HIS科室
/// Table：CT_HCCSLocationLinkLoc
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).DeleteData("5||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	
	s LLLParRef=$p(id,"||",1)
	s eobj = ##class(User.CTHCCSLocationLinkLoc).%OpenId(id)
	s pobj = ##class(web.Entity.CT.HCCSLocationLinkLoc).%New()
	s pobj.LLLHISCode=eobj.LLLHISCode	//关联HIS科室代码
	s pobj.LLLHISDesc=eobj.LLLHISDesc	//关联HIS科室名称
	
	d eobj.%Close()
	kill eobj
	Tstart
	s sc=##class(User.CTHCCSLocationLinkLoc).%DeleteId(id)
	IF $$$ISOK(sc)
	{
		Tc
		s result="{success:'true',info:'删除成功！'}"
		
		s LLLParRef=$p(id,"||",1)
		s LLLChildsub=$p(id,"||",2)
		s HCCSLOCDesc=$p($g(^CT("HCCSLOC",LLLParRef)),"^",2)  //医呼通科室名称
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSLocationLinkLoc","User.CTHCCSLocationLinkLoc","医呼通科室关联HIS科室",id,HCCSLOCDesc_"-"_pobj.LLLHISDesc,"D",pobj)
	
		
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通科室关联HIS科室","web.DHCBL.CT.HCCSLocationLinkLoc","DeleteData",pobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

/// Creator：丁亚男
/// CreatDate: 2021-02-02
/// Description：右侧关联HIS科室保存方法  
/// Table：CT_HCCSLocationLinkLoc
/// Input：HCCSLOCRowId(科室rowid),ChangeIDstr (前台变化的HIS科室id拼串)
/// Return：
/// Other: w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).SaveLocationLink("1","8")
ClassMethod SaveLocationLink(HCCSLOCRowId As %String, ChangeIDstr As %String) As %String
{
	s result=""
	s resultstr=""
	// 变化的id串
	if (ChangeIDstr'="")
	{
		Ts
		s Changelen=$Length(ChangeIDstr,"^")
		//保存
		for j=1:1:Changelen
		{
		    
		    s HISLocRowId=$p(ChangeIDstr,"^",j)
		    s CTLOCDesc=$p($g(^CTLOC(HISLocRowId)),"^",2)       //科室名
            s CTLOCCode=$p($g(^CTLOC(HISLocRowId)),"^",1)        //科室Code
        	s Location= ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode(CTLOCCode)
        	s LocationID=$p(Location,"^",1)
        	if ('$d(^CT("HCCSLOC",0,"HISCode",HCCSLOCRowId,CTLOCCode))) //判断是否存在,不存在增加
		    {
			   s eobj=##class(web.Entity.CT.HCCSLocationLinkLoc).%New()
			   s eobj.LLLParRef=HCCSLOCRowId
			   s eobj.LLLHISCode=CTLOCCode
			   s eobj.LLLHISDesc=CTLOCDesc
			   s resultstr=..SaveEntity(eobj) 
			} 
			else  //存在删除
			{
				s LLLRowId=$o(^CT("HCCSLOC",0,"HISCode",HCCSLOCRowId,CTLOCCode,""))
				s id=HCCSLOCRowId_"||"_LLLRowId
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

/// Creator：基础数据平台-陈莹
/// CreatDate: 2022-08-25
/// function:根据HIS科室代码返回关联的医呼通科室 rowid^代码^名称   
/// input:CTLOCCode(his科室代码)
/// Output:关联的医呼通科室rowid^代码^名称   
/// w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode("000001")
ClassMethod GetLinkLocationByHISCode(CTLOCCode) As %String
{
	s Location=""
	if (CTLOCCode'="")
	{
		if ($d(^CT("HCCSLOC",0,"HISCode2",CTLOCCode))) 
		{
			s LOCRowId=$o(^CT("HCCSLOC",0,"HISCode2",CTLOCCode,0))
			if LOCRowId'=""
			{
				s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)     //医呼通科室代码
				s LOCDesc= $p($g(^CT("HCCSLOC",LOCRowId)),"^",2)		//医呼通科室名称
				s Location=LOCRowId_"^"_LOCCode_"^"_LOCDesc	
			}
		}	
	}
	q Location
}

/// Creator：基础数据平台-陈莹
/// CreatDate: 2022-09-13
/// function:根据医呼通科室id返回关联的his科室代码 
/// input:CTLOCCode(医呼通科室id)
/// Output:his科室代码1^his科室代码2
/// w ##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetHISCodeByLocationId(5)
ClassMethod GetHISCodeByLocationId(LocationId) As %String
{
	s CTLOCStr=""
	if (LocationId'="")
	{
		s LLLChildsub=0
		for
		{
			s LLLChildsub=$o(^CT("HCCSLOC",LocationId,"LINK",LLLChildsub)) q:LLLChildsub=""
			s LOCCode=$p($g(^CT("HCCSLOC",LocationId,"LINK",LLLChildsub)),"^",1)     //his科室代码
			s LOCDesc=$p($g(^CT("HCCSLOC",LocationId,"LINK",LLLChildsub)),"^",2)     //his科室名称
			continue:LOCCode=""
			if CTLOCStr=""
			{
				s CTLOCStr=LOCCode
			}
			else
			{
				s CTLOCStr=CTLOCStr_"^"_LOCCode
			}
		}
		
	}
	q CTLOCStr
}

}
