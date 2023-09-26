/// 名称:语音HIS-语音命令集场景参数
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-01-09
Class web.DHCBL.ASR.ASRCommandParams Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：查询语音命令集场景参数表的内容
/// Table：ASR_CommandParams
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCommandParams","GetList","1","","1||1")
Query GetList(rowid As %String, desc As %String, scenesdr As %String) As %Query(ROWSPEC = "ASRPID:%String,ASRPScenesDR:%String,ASRPCustomCommandName:%String,ASRPCustomCommandType:%String,ASRPCustomCommandTypeValue:%String,ASRPRemark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, scenesdr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRPID = rowid
		s ASRPScenesDR=scenesdr
		s ASRPCustomCommandName= $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",2)		//自定义命令名
		s ASRPCustomCommandType = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",3)  //自定义命令类型
		s ASRPCustomCommandTypeValue = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",4)   //自定义命令类型值
		s ASRPRemark = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",5)   //备注说明
		
		d OutputRow
	}
	else
	{
		if scenesdr'=""
		{
			s ASRPID=0
			for 
			{
				s ASRPID=$o(^CF.DOC.ASR.CommandParamsD(ASRPID)) q:ASRPID=""
				s ASRPScenesDR= $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",1)		//场景关联DR
				continue:(ASRPScenesDR'=scenesdr)	//过滤
				s ASRSParRef=$p(ASRPScenesDR,"||",1)
				s ASRSChildSub=$p(ASRPScenesDR,"||",2)
				s:ASRPScenesDR'="" ASRPScenesDR=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",1)	//场景关联
				s ASRPCustomCommandName= $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",2)		//自定义命令名
				s ASRPCustomCommandType = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",3)  //自定义命令类型
				s ASRPCustomCommandTypeValue = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",4)   //自定义命令类型值
				s ASRPRemark = $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",5)   //备注说明
				if (desc'="")           
				{
					;需要对描述或者别名进行检索 
					s AliasFlag=0     
					s PINYINFlag=""
					s PINYINCODE=""   
			        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
			        if (PINYINFlag=1)
			        {
			          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRPCustomCommandName) 
			        }
					if ((ASRPCustomCommandName[desc)||(PINYINCODE[desc))  
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
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ASRPID,ASRPScenesDR,ASRPCustomCommandName,ASRPCustomCommandType,ASRPCustomCommandTypeValue,ASRPRemark)
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
/// Table:ASR_CommandParams
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCommandParams).FormValidate("1","1||2","p1")
ClassMethod FormValidate(id As %String, scenesdr As %String, customcommandname As %String) As %String
{
	s flag=0
	if ((scenesdr'="")&&(customcommandname'=""))
	{
		s ASRPID=$o(^CF.DOC.ASR.CommandParamsI("ScenesCmd",scenesdr,customcommandname,0))
		if (ASRPID'="")&&(ASRPID'=id) s flag=1
	}
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-01-09
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：ASR_CommandParams
/// Input：ASRPID
/// Other: w ##class(web.DHCBL.ASR.ASRCommandParams).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(User.ASRCommandParams).%OpenId(id) 
	s eobj = ##class(web.Entity.ASR.ASRCommandParams).%New() 
	s eobj.ASRPID = id
	s:pobj.ASRPScenesDR'="" eobj.ASRPScenesDR = pobj.ASRPScenesDR.%Id()		  //场景关联
	s eobj.ASRPCustomCommandName = pobj.ASRPCustomCommandName		  //自定义命令名
	s eobj.ASRPCustomCommandType=pobj.ASRPCustomCommandType		  //自定义命令类型
	s eobj.ASRPCustomCommandTypeValue = pobj.ASRPCustomCommandTypeValue		  //自定义命令类型值
	s eobj.ASRPRemark=pobj.ASRPRemark		  //备注说明
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：根据id删除 语音命令集场景参数
/// Table：ASR_CommandParams
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.ASR.ASRCommandParams).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.ASRCommandParams).%OpenId(id)
	s eobj = ##class(web.Entity.ASR.ASRCommandParams).%New()
	s eobj.ASRPScenesDR = pobj.ASRPScenesDR		  //场景关联
	s eobj.ASRPCustomCommandName = pobj.ASRPCustomCommandName		  //自定义命令名
	s eobj.ASRPCustomCommandType=pobj.ASRPCustomCommandType		  //自定义命令类型
	s eobj.ASRPCustomCommandTypeValue = pobj.ASRPCustomCommandTypeValue		  //自定义命令类型值
	s eobj.ASRPRemark=pobj.ASRPRemark		  //备注说明
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.ASRCommandParams).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandParams","User.ASRCommandParams","语音命令集场景参数",id,eobj.ASRPCustomCommandName,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音命令集场景参数","web.DHCBL.ASR.ASRCommandParams","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:杨帆 
/// CreatDate: 2020-01-09
/// Description：保存 语音命令集场景参数
/// Input: eobj As web.Entity.ASR.ASRCommandParams
/// Table：ASR_CommandParams
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.ASR.ASRCommandParams).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCommandParams) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ASRPID,eobj.ASRPScenesDR,eobj.ASRPCustomCommandName)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRPID="")
		{
			s obj=##class(User.ASRCommandParams).%New()
		}
		else
		{
			s obj=##class(User.ASRCommandParams).%OpenId(eobj.ASRPID)
			s bobj=##class(web.Entity.ASR.ASRCommandParams).%New()
			s bobj.ASRPID = eobj.ASRPID		//RowID
			s:obj.ASRPScenesDR'="" bobj.ASRPScenesDR = obj.ASRPScenesDR.%Id()		    //场景关联
			s bobj.ASRPCustomCommandName = obj.ASRPCustomCommandName		//自定义命令名
			s bobj.ASRPCustomCommandType=obj.ASRPCustomCommandType	//自定义命令类型
			s bobj.ASRPCustomCommandTypeValue = obj.ASRPCustomCommandTypeValue	//自定义命令类型值
			s bobj.ASRPRemark=obj.ASRPRemark		//备注说明
		}
		d obj.ASRPScenesDRSetObjectId(eobj.ASRPScenesDR)		    //场景关联
		s obj.ASRPCustomCommandName = eobj.ASRPCustomCommandName		//自定义命令名
		S obj.ASRPCustomCommandType=eobj.ASRPCustomCommandType	//自定义命令类型
		s obj.ASRPCustomCommandTypeValue = eobj.ASRPCustomCommandTypeValue	//自定义命令类型值
		s obj.ASRPRemark=eobj.ASRPRemark		//备注说明
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ASRPID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandParams","User.ASRCommandParams","语音命令集场景参数",eobj.ASRPID,eobj.ASRPCustomCommandName,"U",eobj,bobj)
    		d:eobj.ASRPID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandParams","User.ASRCommandParams","语音命令集场景参数",id,eobj.ASRPCustomCommandName,"A",eobj)
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

}
