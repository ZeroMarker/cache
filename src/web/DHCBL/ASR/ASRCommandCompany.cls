/// 名称:应用场景关联厂商表
/// 描述:包含增删改查等功能
/// 编写者:基础数据平台-likefan
/// 编写日期: 2020-9-25
Class web.DHCBL.ASR.ASRCommandCompany Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-25
/// Description：查询场景关联厂商表
/// Table：User.ASRCommandCompany
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCommandCompany","GetList","","","")
Query GetList(rowid As %String, scenesdr As %String, companydr As %String) As %Query(ROWSPEC = "ASRCCID,ASRCCScenesDR,ASRCCCompanyDR,ASRCCDateFrom,ASRCCDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, scenesdr As %String, companydr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	if (rowid'="")
	{
		s ASRCCID=rowid
		s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",1)		//应用场景
		s ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",2)		//厂商
		s ASRCCDateFrom=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",3)		//开始日期
		s ASRCCDateTo=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",4)		//结束日期
		if (ASRCCScenesDR'="")
		{
			s ASRSParRef=$p(ASRCCScenesDR,"||",1)
			s ASRSChildSub=$p(ASRCCScenesDR,"||",2)
			s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2)		//应用场景名称
		}
		s:ASRCCCompanyDR'="" ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CompanyD(ASRCCCompanyDR)),"^",5)   //产商名称
		s:ASRCCDateFrom'="" ASRCCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCCDateFrom) //转换日期格式
		s:ASRCCDateTo'="" ASRCCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCCDateTo) //转换日期格式
		d OutputRow
	}
	else
	{
		s ASRCCID=0
		for
		{
			s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyD(ASRCCID)) q:ASRCCID=""
			s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",1)		//应用场景
			s ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",2)		//厂商
			s ASRCCDateFrom=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",3)		//开始日期
			s ASRCCDateTo=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",4)		//结束日期
			s textASRCCScenesDR=ASRCCScenesDR
			s textASRCCCompanyDR=ASRCCCompanyDR
			if (ASRCCScenesDR'="")
			{
				s ASRSParRef=$p(ASRCCScenesDR,"||",1)
				s ASRSChildSub=$p(ASRCCScenesDR,"||",2)
				s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2)		//应用场景名称
			}
			s:ASRCCCompanyDR'="" ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CompanyD(ASRCCCompanyDR)),"^",5)   //产商名称
			s:ASRCCDateFrom'="" ASRCCDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCCDateFrom) //转换日期格式
			s:ASRCCDateTo'="" ASRCCDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCCDateTo) //转换日期格式
			if ((textASRCCScenesDR=scenesdr)||(scenesdr=""))&&((textASRCCCompanyDR=companydr)||(companydr=""))
			{
				d OutputRow
			}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ASRCCID,ASRCCScenesDR,ASRCCCompanyDR,ASRCCDateFrom,ASRCCDateTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：Form表单查询场景关联厂商表
/// Table：User.ASRCommandCompany
/// Input：id
/// Others：w ##class(web.DHCBL.ASR.ASRCommandCompany).OpenData("2")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.ASRCommandCompany).%OpenId(id)
	 s eobj = ##class(web.Entity.ASR.ASRCommandCompany).%New()
	 s eobj.ASRCCID = id							// ASRCCID
	 s:obj.ASRCCScenesDR'="" eobj.ASRCCScenesDR=obj.ASRCCScenesDR.%Id()			// 应用场景
	 s:obj.ASRCCCompanyDR'="" eobj.ASRCCCompanyDR=obj.ASRCCCompanyDR.%Id()			// 厂商
	 s eobj.ASRCCDateFrom=obj.ASRCCDateFrom			// 开始日期
	 s eobj.ASRCCDateTo=obj.ASRCCDateTo				// 结束日期
	 s:eobj.ASRCCDateFrom'="" eobj.ASRCCDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ASRCCDateFrom)
	 s:eobj.ASRCCDateTo'="" eobj.ASRCCDateTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.ASRCCDateTo)
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：删除场景关联厂商表
/// Table：User.ASRCommandCompany
/// Others：w ##class(web.DHCBL.ASR.ASRCommandCompany).DeleteData(4)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj = ##class(User.ASRCommandCompany).%OpenId(id)
		s pobj = ##class(web.Entity.ASR.ASRCommandCompany).%New()
		s pobj.ASRCCID = id							// ASRCCID
		s:obj.ASRCCScenesDR'="" pobj.ASRCCScenesDR=obj.ASRCCScenesDR.%Id()		// 应用场景
		s:obj.ASRCCCompanyDR'="" pobj.ASRCCCompanyDR=obj.ASRCCCompanyDR.%Id()	// 厂商
		s pobj.ASRCCDateFrom=obj.ASRCCDateFrom		// 开始日期
		s pobj.ASRCCDateTo=obj.ASRCCDateTo			// 结束日期
		TSTART
		s sc=##class(User.ASRCommandCompany).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			s ASRCCScenesDR="",ASRCCCompanyDR=""
			if (pobj.ASRCCScenesDR'="")
			{
				s ASRSParRef=$p(pobj.ASRCCScenesDR,"||",1)
				s ASRSChildSub=$p(pobj.ASRCCScenesDR,"||",2)
				s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2)		//应用场景名称
			}
			s:pobj.ASRCCCompanyDR'="" ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CompanyD(pobj.ASRCCCompanyDR)),"^",5)   //产商名称
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandCompany","User.ASRCommandCompany","场景关联厂商",id,ASRCCScenesDR_"-"_ASRCCCompanyDR,"D",pobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-18
/// Description：数据重复校验
/// Table：User.ASRCommandCompany
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCommandCompany).FormValidate("1","1","1")
ClassMethod FormValidate(id As %String, scenesdr As %String, companydr As %String) As %String
{
	s flag=0
	if (scenesdr'="")&&(companydr'="")
	{
		s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyI("ScenesCompany",scenesdr,companydr,0))
		s:(ASRCCID'="")&&(ASRCCID'=id) flag=1
	}
	q flag
}

/// w ##class(web.DHCBL.ASR.ASRCommandCompany).Save()
ClassMethod Save() As %String
{
	s re=""
	s eobj=##class(web.Entity.ASR.ASRCommandCompany).%New()
	s eobj.ASRCCScenesDR="1||2"
	s eobj.ASRCCCompanyDR="2"
	s eobj.ASRCCDateFrom="2020-09-24"
	s eobj.ASRCCDateTo="2020-09-30"
	s re=##class(web.DHCBL.ASR.ASRCommandCompany).SaveEntity(eobj)
	q re
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-25
/// function:场景关联厂商表的新增修改
/// Table：User.ASRCommandCompany
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCommandCompany) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ASRCCDateFrom'="" eobj.ASRCCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASRCCDateFrom) //转换日期
		s:eobj.ASRCCDateTo'="" eobj.ASRCCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASRCCDateTo) //转换日期
		s:eobj.ASRCCDateFrom="" eobj.ASRCCDateFrom=+$h
		s flag=..FormValidate(eobj.ASRCCID,eobj.ASRCCScenesDR,eobj.ASRCCCompanyDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRCCID="")
		{
			s obj=##class(User.ASRCommandCompany).%New()
		}
		else
		{
			s obj=##class(User.ASRCommandCompany).%OpenId(eobj.ASRCCID)
			s bobj=##class(web.Entity.ASR.ASRCommandCompany).%New()
		    s bobj.ASRCCID=eobj.ASRCCID			// ASRCCID
		    s:obj.ASRCCScenesDR'="" bobj.ASRCCScenesDR=obj.ASRCCScenesDR.%Id()			// 应用场景
			s:obj.ASRCCCompanyDR'="" bobj.ASRCCCompanyDR=obj.ASRCCCompanyDR.%Id()		// 厂商
			s bobj.ASRCCDateFrom=obj.ASRCCDateFrom		// 开始日期
			s bobj.ASRCCDateTo=obj.ASRCCDateTo			// 结束日期
		}
		d obj.ASRCCScenesDRSetObjectId(eobj.ASRCCScenesDR)			// 应用场景
		d obj.ASRCCCompanyDRSetObjectId(eobj.ASRCCCompanyDR)		// 厂商
		s obj.ASRCCDateFrom=eobj.ASRCCDateFrom		// 开始日期
		s obj.ASRCCDateTo=eobj.ASRCCDateTo			// 结束日期
		TSTART
		s sc=obj.%Save()
		d obj.%Close()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s ASRCCScenesDR="",ASRCCCompanyDR=""
			if (eobj.ASRCCScenesDR'="")
			{
				s ASRSParRef=$p(eobj.ASRCCScenesDR,"||",1)
				s ASRSChildSub=$p(eobj.ASRCCScenesDR,"||",2)
				s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2)		//应用场景名称
			}
			s:eobj.ASRCCCompanyDR'="" ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CompanyD(eobj.ASRCCCompanyDR)),"^",5)   //产商名称
			d:eobj.ASRCCID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandCompany","User.ASRCommandCompany","场景关联厂商",id,ASRCCScenesDR_"-"_ASRCCCompanyDR,"U",eobj,bobj)
			d:eobj.ASRCCID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandCompany","User.ASRCommandCompany","场景关联厂商",id,ASRCCScenesDR_"-"_ASRCCCompanyDR,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		k obj
		k eobj
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-27
/// function:应用系统及场景数据json串
/// Table：User.ASRCommandSetScenes
/// input: 厂商id
/// w ##class(web.DHCBL.ASR.ASRCommandCompany).GetJsonDataForCmb(1)
ClassMethod GetJsonDataForCmb(asrcid) As %String
{
	w "["
	s ASRID=0
	s count1=0
	for		//查询应用系统
	{
		s ASRID=$o(^CF.DOC.ASR.CommandSetD(ASRID)) q:ASRID=""
		s ASRAppName=$p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",1)		//应用名
		w:count1'=0 ","
		w "{""id"":"""_ASRID_""",""text"":"""_ASRAppName_""",""state"":""open"""
		s count1=count1+1
		if $d(^CF.DOC.ASR.CommandSetD(ASRID,"Scenes"))
		{
			w ",""children"":["
			s ASRSChildSub=0
			s count2=0
			for
			{
				s ASRSChildSub=$o(^CF.DOC.ASR.CommandSetD(ASRID,"Scenes",ASRSChildSub)) q:ASRSChildSub=""
				s ASRSID=ASRID_"||"_ASRSChildSub
				s ASRSScenesCommandName=$p($g(^CF.DOC.ASR.CommandSetD(ASRID,"Scenes",ASRSChildSub)),"^",2)		//场景命令名
				s checked=..GetCheckFlag(asrcid,ASRSID)		//是否关联
				s:checked=1 checked="true"
				s:checked=0 checked="false"
				w:count2'=0 ","
				w "{""id"":"""_ASRSID_""",""text"":"""_ASRSScenesCommandName_""",""checked"":"_checked_"}"
				s count2=count2+1
			}
			w "]"
		}
		w "}"
	}
	w "]"
	q ""
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-27
/// function:根据厂商id、场景id，判断该场景和厂商是否关联
/// input:厂商id，场景id
/// w ##class(web.DHCBL.ASR.ASRCommandCompany).GetCheckFlag("","")
ClassMethod GetCheckFlag(asrcid, asrsid)
{
	s flag=0
	if (asrcid'="")&&(asrsid'="")
	{
		s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyI("ScenesCompany",asrsid,asrcid,0))
		s:ASRCCID'="" flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-9-27
/// function:保存场景和厂商的关联关系
/// input:厂商id，场景id，是否勾选
/// w ##class(web.DHCBL.ASR.ASRCommandCompany).SaveLinkScenes("1","1||5","true")
ClassMethod SaveLinkScenes(asrcid, asrsid, checked)
{
	s result=""
	q:asrcid="" ""
	q:asrsid="" ""
	if ($p(asrsid,"||",2)'="")	//点击子节点
	{
		if (checked="true")||(checked=1)		//保存关联
		{
			s eobj=##class(web.Entity.ASR.ASRCommandCompany).%New()
			s eobj.ASRCCScenesDR=asrsid
			s eobj.ASRCCCompanyDR=asrcid
			s result=..SaveEntity(eobj)
		}
		if (checked="false")||(checked=0)	//删除关联
		{
			s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyI("ScenesCompany",asrsid,asrcid,0))
			s:ASRCCID'="" result=..DeleteData(ASRCCID)
		}
	}
	else	//点击父节点
	{
		s ASRSChildSub=0
		for
		{
			s ASRSChildSub=$o(^CF.DOC.ASR.CommandSetD(asrsid,"Scenes",ASRSChildSub)) q:ASRSChildSub=""
			s ASRSID=asrsid_"||"_ASRSChildSub
			s result=..SaveLinkScenes(asrcid,ASRSID,checked)
		}
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-10-29
/// function:厂商数据json串，提供给语音HIS配置界面关联场景树
/// Table：ASR_CommandSetScenes
/// input: 厂景id
/// w ##class(web.DHCBL.ASR.ASRCommandCompany).GetJsonDataForTree("1||1")
ClassMethod GetJsonDataForTree(asrsid) As %String
{
	w "["
	//w "{""id"":"""_0_""",""text"":""厂商"",""state"":""open"",""children"":["
	s ASRCID=0
	s count1=0
	for 
	{
		s ASRCID=$o(^CF.DOC.ASR.CompanyD(ASRCID)) q:ASRCID=""
		s ASRCCompany = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",5)   //产商
		s ASRCStartDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",7)		//开始日期
		s ASRCEndDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",8)		//结束日期
		continue:(ASRCStartDate'="")&&(ASRCStartDate>+$h)
        continue:(ASRCEndDate'="")&&(ASRCEndDate<+$h)
		w:count1'=0 ","
		s checked=..GetCheckFlag(ASRCID,asrsid)		//是否关联	input:厂商id,场景id
		s:checked=1 checked="true"
		s:checked=0 checked="false"
		w "{""id"":"""_ASRCID_""",""text"":"""_ASRCCompany_""",""checked"":"_checked_"}"
		s count1=count1+1
	}
	//w "]}"
	w "]"
	q ""
}

}
