/// 名称:厂商表
/// 编写者:基础数据平台-likefan
/// 编写日期: 2020-09-24
Class web.DHCBL.ASR.ASRCompany Extends %RegisteredObject
{

/// Creator：likefan
/// CreatDate: 2020-09-24
/// Description：查询厂商表的内容
/// Table：ASR_Company
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCompany","GetList","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "ASRCID:%String,ASRCAppName:%String,ASRCCompanyName:%String,ASRCAppVersion:%String,ASRCProtocolVersion:%String,ASRCCompany:%String,ASRCCompanyCmd:%String,ASRCStartDate:%String,ASRCEndDate:%String,ASRCServicePath:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRCID = rowid
		s ASRCAppName= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",1)		//应用名
		s ASRCCompanyName= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",2)		//公司名
		s ASRCAppVersion = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",3)  //应用版本
		s ASRCProtocolVersion = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",4)   //通信模块协议版本
		s ASRCCompany = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",5)   //产商
		s ASRCCompanyCmd= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",6)		//产商初始化命令串
		s ASRCStartDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",7)		//开始日期
		s:ASRCStartDate'="" ASRCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCStartDate) //转换日期格式
		s ASRCEndDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",8)		//结束日期
		s:ASRCEndDate'="" ASRCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCEndDate) //转换日期格式
		s ASRCServicePath= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",9)		//服务路径
		d OutputRow
	}
	else
	{
		s ASRCID=0
		for 
		{
			s ASRCID=$o(^CF.DOC.ASR.CompanyD(ASRCID)) q:ASRCID=""
			s ASRCAppName= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",1)		//应用名
			s ASRCCompanyName= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",2)		//公司名
			s ASRCAppVersion = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",3)  //应用版本
			s ASRCProtocolVersion = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",4)   //通信模块协议版本
			s ASRCCompany = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",5)   //产商
			s ASRCCompanyCmd= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",6)		//产商初始化命令串
			s ASRCStartDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",7)		//开始日期
			s:ASRCStartDate'="" ASRCStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCStartDate) //转换日期格式
			s ASRCEndDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",8)		//结束日期
			s:ASRCEndDate'="" ASRCEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ASRCEndDate) //转换日期格式
			s ASRCServicePath= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",9)		//服务路径
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRCCompany) 
		        }
				if ((ASRCCompany[desc)||(PINYINCODE[desc))  
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
    set Data=$lb(ASRCID,ASRCAppName,ASRCCompanyName,ASRCAppVersion,ASRCProtocolVersion,ASRCCompany,ASRCCompanyCmd,ASRCStartDate,ASRCEndDate,ASRCServicePath)
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

/// Creator：likefan
/// CreatDate: 2020-09-25
/// Description：查询厂商,提供给下拉框
/// Table：ASR_Company
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCompany","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "ASRCID:%String,ASRCCompany:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRCID = rowid
		s ASRCCompany = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",5)   //产商
		d OutputRow
	}
	else
	{
		s ASRCID=0
		for 
		{
			s ASRCID=$o(^CF.DOC.ASR.CompanyD(ASRCID)) q:ASRCID=""
			s ASRCCompany = $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",5)   //产商
			s ASRCStartDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",7)		//开始日期
			s ASRCEndDate= $p($g(^CF.DOC.ASR.CompanyD(ASRCID)),"^",8)		//结束日期
			continue:(ASRCStartDate'="")&&(ASRCStartDate>+$h)
            continue:(ASRCEndDate'="")&&(ASRCEndDate<+$h)
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRCCompany) 
		        }
				if ((ASRCCompany[desc)||(PINYINCODE[desc))  
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
    set Data=$lb(ASRCID,ASRCCompany)
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

/// Creator:likefan 
/// CreatDate:2020-09-24
/// Description:数据重复验证方法,js调用
/// Table:ASR_Company
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCompany).FormValidate("","")
ClassMethod FormValidate(id As %String, company As %String) As %String
{
	s flag=0
	if (company'="")
	{
		s ASRCID=$o(^CF.DOC.ASR.CompanyI("Company",company,0))
		if (ASRCID'="")&&(ASRCID'=id) s flag=1	
	}
	q flag
}

/// Creator：likefan 
/// CreatDate: 2020-09-24
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：ASR_Company
/// Input：ASRPID
/// Other: w ##class(web.DHCBL.ASR.ASRCompany).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.ASRCompany).%OpenId(id) 
	s eobj = ##class(web.Entity.ASR.ASRCompany).%New() 
	s eobj.ASRCID = id
	s eobj.ASRCAppName = pobj.ASRCAppName		  //应用名
	s eobj.ASRCCompanyName = pobj.ASRCCompanyName		  //公司名
	s eobj.ASRCAppVersion=pobj.ASRCAppVersion		  //应用版本
	s eobj.ASRCProtocolVersion = pobj.ASRCProtocolVersion		  //通信模块协议版本
	s eobj.ASRCCompany=pobj.ASRCCompany		  //产商
	s eobj.ASRCCompanyCmd=pobj.ASRCCompanyCmd		  //产商初始化命令串
	s eobj.ASRCStartDate = pobj.ASRCStartDate		  //开始日期
	s:pobj.ASRCStartDate'="" eobj.ASRCStartDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASRCStartDate)
	s eobj.ASRCEndDate = pobj.ASRCEndDate		  //结束日期
	s:pobj.ASRCEndDate'="" eobj.ASRCEndDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.ASRCEndDate)
	s eobj.ASRCServicePath = pobj.ASRCServicePath		  //服务路径
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：likefan
/// CreatDate: 2020-09-24
/// Description：根据id删除 厂商
/// Table：ASR_Company
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.ASR.ASRCompany).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.ASR.ASRCompany).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s ASRSParRef=$p(id,"||",1)
	if (RefFlag=0){
		s pobj = ##class(User.ASRCompany).%OpenId(id)
		s eobj = ##class(web.Entity.ASR.ASRCompany).%New()
		s eobj.ASRCAppName = pobj.ASRCAppName		  //应用名
		s eobj.ASRCCompanyName = pobj.ASRCCompanyName		  //公司名
		s eobj.ASRCAppVersion=pobj.ASRCAppVersion		  //应用版本
		s eobj.ASRCProtocolVersion = pobj.ASRCProtocolVersion		  //通信模块协议版本
		s eobj.ASRCCompany=pobj.ASRCCompany		  //产商
		s eobj.ASRCCompanyCmd=pobj.ASRCCompanyCmd		  //产商初始化命令串
		s eobj.ASRCStartDate = pobj.ASRCStartDate		  //开始日期
		s eobj.ASRCEndDate = pobj.ASRCEndDate		  //结束日期
		s eobj.ASRCServicePath = pobj.ASRCServicePath		  //服务路径
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.ASRCompany).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_Company","User.ASRCompany","厂商",id,eobj.ASRCAppName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("厂商","web.DHCBL.ASR.ASRCompany","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	q result
}

/// Other:w ##class(web.DHCBL.ASR.ASRCompany).test()
ClassMethod test() As %String
{
	s re=""
	s eobj=##class(web.Entity.ASR.ASRCompany).%New()
	s eobj.ASRCID = ""		//RowID
	s eobj.ASRCCompanyName = "DD科技公司"		//公司名
	s eobj.ASRCCompany= "DD科技"		//产商
	s eobj.ASRCStartDate = "2020-09-24"	//开始日期
	s re = ##class(web.DHCBL.ASR.ASRCompany).SaveEntity(eobj)
	q re
}

/// Creator:likefan 
/// CreatDate: 2020-09-24
/// Description：保存 厂商
/// Input: eobj As web.Entity.ASR.CommandParams
/// Table：ASR_Company
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.ASR.ASRCompany).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCompany) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ASRCStartDate'="" eobj.ASRCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASRCStartDate) //转换日期
		s:eobj.ASRCEndDate'="" eobj.ASRCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.ASRCEndDate) //转换日期
		if (eobj.ASRCEndDate'="")
		{
			if (eobj.ASRCStartDate>eobj.ASRCEndDate) q "{success:'false',errorinfo:'开始日期不能大于结束日期！'}"
		}
		s flag=..FormValidate(eobj.ASRCID,eobj.ASRCCompany)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRCID="")
		{
			s obj=##class(User.ASRCompany).%New()
		}
		else
		{
			s obj=##class(User.ASRCompany).%OpenId(eobj.ASRCID)
			s bobj=##class(web.Entity.ASR.ASRCompany).%New()
			s bobj.ASRCID = eobj.ASRCID		//RowID
			s bobj.ASRCAppName = obj.ASRCAppName		    //应用名
			s bobj.ASRCCompanyName = obj.ASRCCompanyName		//公司名
			s bobj.ASRCAppVersion=obj.ASRCAppVersion	//应用版本
			s bobj.ASRCProtocolVersion = obj.ASRCProtocolVersion	//通信模块协议版本
			s bobj.ASRCCompany=obj.ASRCCompany		//产商
			s bobj.ASRCCompanyCmd = obj.ASRCCompanyCmd	//产商初始化命令串
			s bobj.ASRCStartDate = obj.ASRCStartDate	//开始日期
			s bobj.ASRCEndDate = obj.ASRCEndDate	//结束日期
			s bobj.ASRCServicePath = obj.ASRCServicePath	//服务路径
		}
		s obj.ASRCAppName = eobj.ASRCAppName		    //应用名
		s obj.ASRCCompanyName = eobj.ASRCCompanyName		//公司名
		S obj.ASRCAppVersion=eobj.ASRCAppVersion	//应用版本
		s obj.ASRCProtocolVersion = eobj.ASRCProtocolVersion	//通信模块协议版本
		s obj.ASRCCompany=eobj.ASRCCompany		//产商
		s obj.ASRCCompanyCmd=eobj.ASRCCompanyCmd		//产商初始化命令串
		s obj.ASRCStartDate=eobj.ASRCStartDate		//开始日期
		s obj.ASRCEndDate=eobj.ASRCEndDate		//结束日期
		s obj.ASRCServicePath=eobj.ASRCServicePath		//服务路径
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ASRCID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_Company","User.ASRCompany","厂商",eobj.ASRCID,eobj.ASRCAppName,"U",eobj,bobj)
    		d:eobj.ASRCID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_Company","User.ASRCompany","厂商",id,eobj.ASRCAppName,"A",eobj)
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

/// Creator:李可凡
/// CreatDate:2020-10-12
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.ASR.ASRCompany).GetRefFlag("1||2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s ASRCCID=0
	for 
	{
		s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyD(ASRCCID)) q:ASRCCID=""
		s ASRCCCompanyDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",2)		//厂商
		if (ASRCCCompanyDR=id)
		{
			s myInfo=myInfo_"<场景关联厂商表>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

}
