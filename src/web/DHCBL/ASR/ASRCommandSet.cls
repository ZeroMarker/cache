/// 名称:语音HIS-语音命令集表
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-01-09
Class web.DHCBL.ASR.ASRCommandSet Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：查询语音命令集表的内容
/// Table：ASR_CommandSet
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCommandSet","GetList","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "ASRID:%String,ASRAppName:%String,ASRCompanyName:%String,ASRAppVersion:%String,ASRProtocolVersion:%String,ASRCompany:%String,ASRCompanyCmd:%String,ASRStartDate:%String,ASREndDate:%String,ASRServicePath:%String,ASRVoiceprintScore:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRID = rowid
		s ASRAppName= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",1)		//应用名
		s ASRCompanyName= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",2)		//公司名
		s ASRAppVersion = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",3)  //应用版本
		s ASRProtocolVersion = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",4)   //通信模块协议版本
		s ASRCompany = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",5)   //产商
		s ASRCompanyCmd= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",6)		//产商初始化命令串
		s ASRStartDate= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",7)		//开始日期
		s:ASRStartDate'="" ASRStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRStartDate) //转换日期格式
		s ASREndDate= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",8)		//结束日期
		s:ASREndDate'="" ASREndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASREndDate) //转换日期格式
		s ASRServicePath= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",9)		//服务路径
		s ASRVoiceprintScore= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",10)		//声纹认证分值
		d OutputRow
	}
	else
	{
		s ASRID=0
		for 
		{
			s ASRID=$o(^CF.DOC.ASR.CommandSetD(ASRID)) q:ASRID=""
			s ASRAppName= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",1)		//应用名
			s ASRCompanyName= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",2)		//公司名
			s ASRAppVersion = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",3)  //应用版本
			s ASRProtocolVersion = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",4)   //通信模块协议版本
			s ASRCompany = $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",5)   //产商
			s ASRCompanyCmd= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",6)		//产商初始化命令串
			s ASRStartDate= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",7)		//开始日期
			s:ASRStartDate'="" ASRStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRStartDate) //转换日期格式
			s ASREndDate= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",8)		//结束日期
			s:ASREndDate'="" ASREndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASREndDate) //转换日期格式
			s ASRServicePath= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",9)		//服务路径
			s ASRVoiceprintScore= $p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",10)		//声纹认证分值
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRAppName) 
		        }
				if ((ASRAppName[desc)||(PINYINCODE[desc))  
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i (AliasFlag=1) //包含)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ASRID,ASRAppName,ASRCompanyName,ASRAppVersion,ASRProtocolVersion,ASRCompany,ASRCompanyCmd,ASRStartDate,ASREndDate,ASRServicePath,ASRVoiceprintScore)
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

/// Creator:杨帆 
/// CreatDate:2020-01-09
/// Description:数据重复验证方法,js调用
/// Table:ASR_CommandSet
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSet).FormValidate("","云知声","语音录入","1.1")
ClassMethod FormValidate(id As %String, company As %String, appname As %String, appversion As %String) As %String
{
	s flag=0
	if ((company'="")&&(appname'="")&&(appversion'=""))
	{
		s RowId=$o(^CF.DOC.ASR.CommandSetI("Company",$ZCONVERT(company,"U"),$ZCONVERT(appname,"U"),appversion,0))
		if (RowId'="")&&(RowId'=id) s flag=1	
	}
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-01-09
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：ASR_CommandSet
/// Input：ASRPID
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSet).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.ASRCommandSet).%OpenId(id) 
	s eobj = ##class(web.Entity.ASR.ASRCommandSet).%New() 
	s eobj.ASRID = id
	s eobj.ASRAppName = pobj.ASRAppName		  //应用名
	s eobj.ASRCompanyName = pobj.ASRCompanyName		  //公司名
	s eobj.ASRAppVersion=pobj.ASRAppVersion		  //应用版本
	s eobj.ASRProtocolVersion = pobj.ASRProtocolVersion		  //通信模块协议版本
	s eobj.ASRCompany=pobj.ASRCompany		  //产商
	s eobj.ASRCompanyCmd=pobj.ASRCompanyCmd		  //产商初始化命令串
	s eobj.ASRStartDate = pobj.ASRStartDate		  //开始日期
	s:pobj.ASRStartDate'="" eobj.ASRStartDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASRStartDate)
	s eobj.ASREndDate = pobj.ASREndDate		  //结束日期
	s:pobj.ASREndDate'="" eobj.ASREndDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASREndDate)
	s eobj.ASRServicePath = pobj.ASRServicePath		  //服务路径
	s eobj.ASRVoiceprintScore = pobj.ASRVoiceprintScore		  //声纹认证分值
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：根据id删除 语音命令集
/// Table：ASR_CommandSet
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSet).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.ASRCommandSet).%OpenId(id)
	s eobj = ##class(web.Entity.ASR.ASRCommandSet).%New()
	s eobj.ASRAppName = pobj.ASRAppName		  //应用名
	s eobj.ASRCompanyName = pobj.ASRCompanyName		  //公司名
	s eobj.ASRAppVersion=pobj.ASRAppVersion		  //应用版本
	s eobj.ASRProtocolVersion = pobj.ASRProtocolVersion		  //通信模块协议版本
	s eobj.ASRCompany=pobj.ASRCompany		  //产商
	s eobj.ASRCompanyCmd=pobj.ASRCompanyCmd		  //产商初始化命令串
	s eobj.ASRStartDate = pobj.ASRStartDate		  //开始日期
	s eobj.ASREndDate = pobj.ASREndDate		  //结束日期
	s eobj.ASRServicePath = pobj.ASRServicePath		  //服务路径
	s eobj.ASRVoiceprintScore = pobj.ASRVoiceprintScore		  //声纹认证分值
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.ASRCommandSet).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSet","User.ASRCommandSet","语音命令集",id,eobj.ASRAppName,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音命令集","web.DHCBL.ASR.ASRCommandSet","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:杨帆 
/// CreatDate: 2020-01-09
/// Description：保存 语音命令集
/// Input: eobj As web.Entity.ASR.CommandParams
/// Table：ASR_CommandSet
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSet).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCommandSet) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ASRStartDate'="" eobj.ASRStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASRStartDate) //转换日期
		s:eobj.ASREndDate'="" eobj.ASREndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASREndDate) //转换日期
		if (eobj.ASREndDate'="")
		{
			if (eobj.ASRStartDate>eobj.ASREndDate) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		s flag=..FormValidate(eobj.ASRID,eobj.ASRCompany,eobj.ASRAppName,eobj.ASRAppVersion)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRID="")
		{
			s obj=##class(User.ASRCommandSet).%New()
		}
		else
		{
			s obj=##class(User.ASRCommandSet).%OpenId(eobj.ASRID)
			s bobj=##class(web.Entity.ASR.ASRCommandSet).%New()
			s bobj.ASRID = eobj.ASRID		//RowID
			s bobj.ASRAppName = obj.ASRAppName		    //应用名
			s bobj.ASRCompanyName = obj.ASRCompanyName		//公司名
			s bobj.ASRAppVersion=obj.ASRAppVersion	//应用版本
			s bobj.ASRProtocolVersion = obj.ASRProtocolVersion	//通信模块协议版本
			s bobj.ASRCompany=obj.ASRCompany		//产商
			s bobj.ASRCompanyCmd = obj.ASRCompanyCmd	//产商初始化命令串
			s bobj.ASRStartDate = obj.ASRStartDate	//开始日期
			s bobj.ASREndDate = obj.ASREndDate	//结束日期
			s bobj.ASRServicePath = obj.ASRServicePath	//服务路径
			s bobj.ASRVoiceprintScore = obj.ASRVoiceprintScore	//声纹认证分值
		}
		s obj.ASRAppName = eobj.ASRAppName		    //应用名
		s obj.ASRCompanyName = eobj.ASRCompanyName		//公司名
		S obj.ASRAppVersion=eobj.ASRAppVersion	//应用版本
		s obj.ASRProtocolVersion = eobj.ASRProtocolVersion	//通信模块协议版本
		s obj.ASRCompany=eobj.ASRCompany		//产商
		s obj.ASRCompanyCmd=eobj.ASRCompanyCmd		//产商初始化命令串
		s obj.ASRStartDate=eobj.ASRStartDate		//开始日期
		s obj.ASREndDate=eobj.ASREndDate		//结束日期
		s obj.ASRServicePath=eobj.ASRServicePath		//服务路径
		s obj.ASRVoiceprintScore=eobj.ASRVoiceprintScore		//声纹认证分值
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ASRID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSet","User.ASRCommandSet","语音命令集",eobj.ASRID,eobj.ASRAppName,"U",eobj,bobj)
    		d:eobj.ASRID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSet","User.ASRCommandSet","语音命令集",id,eobj.ASRAppName,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:likefan 
/// CreatDate: 2020-11-04
/// Description：根据应用名获取服务路径和声纹认证分值
/// Input: ASRAppName
/// Table：ASR_CommandSet
/// Return:json格式出参
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSet).GetDataByAppName("HIS")
ClassMethod GetDataByAppName(appname) As %String
{
	s outJson=""
	s ASRID=0
	for 
	{
		s ASRID=$o(^CF.DOC.ASR.CommandSetD(ASRID)) q:ASRID=""
		s ASRAppName=$p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",1)		//应用名
		q:ASRAppName=appname
	}
	if (ASRID'="")
	{
		s ASRServicePath=$p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",9)		//服务路径
		s ASRVoiceprintScore=$p($g(^CF.DOC.ASR.CommandSetD(ASRID)),"^",10)		//声纹认证分值
		s outJson="{ASRServicePath:'"_ASRServicePath_"',ASRVoiceprintScore:'"_ASRVoiceprintScore_"'}"
	}
	q outJson
}

}
