/// 名称:语音HIS-语音命令集场景命令指令表
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-01-09
Class web.DHCBL.ASR.ASRCommandSetScenesCmd Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：查询语音命令集场景命令指令表的内容
/// Table：ASR_CommandSetScenesCmd
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCommandSetScenesCmd","GetList","1||1||1","closeMsgWindow","1||1")
Query GetList(rowid As %String, desc As %String, parref As %String) As %Query(ROWSPEC = "ASRCID:%String,ASRCIsParamCommand:%String,ASRCCommandName:%String,ASRCExpression:%String,ASRCParamFormat:%String,ASRCParamType:%String,ASRCTriggerType:%String,ASRCTriggerTypeExpression:%String,ASRCCommandParam:%String,ASRCParamDescription:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRCID = rowid
		s ASRSParRef=$p(rowid,"||",1)
		s ASRCParref=$p(rowid,"||",2)
		s ASRCChildSub=$p(rowid,"||",3)
		s ASRCIsParamCommand= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",1)		//是否有参数命令（Y/N）
		s ASRCCommandName= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",2)		//命令名
		s ASRCExpression = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",3)  //命令描述或表达式
		s ASRCParamFormat = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",4)   //参数格式
		s ASRCParamType = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",5)   //参数类型
		s ASRCTriggerType= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",6)		//触发类型
		s ASRCTriggerTypeExpression= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",7)		//触发类型表达式
		s ASRCCommandParam= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",8)		//命令参数
		s ASRCParamDescription= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",9)		//命令参数说明
		d OutputRow
	}
	else
	{
		if parref'=""
		{
			s ASRSParRef=$p(parref,"||",1)
			s ASRCParref=$p(parref,"||",2)
			s ASRCChildSub=0
			for
			{
				s ASRCChildSub=$o(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)) q:ASRCChildSub=""
				s ASRCID=parref_"||"_ASRCChildSub
				s ASRCIsParamCommand= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",1)		//是否有参数命令（Y/N）
				s ASRCCommandName= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",2)		//命令名
				s ASRCExpression = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",3)  //命令描述或表达式
				s ASRCParamFormat = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",4)   //参数格式
				s ASRCParamType = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",5)   //参数类型
				s ASRCTriggerType= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",6)		//触发类型
				s ASRCTriggerTypeExpression= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",7)		//触发类型表达式
				s ASRCCommandParam= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",8)		//命令参数
				s ASRCParamDescription= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",9)		//命令参数说明
				if (desc'="")           
				{
					;需要对描述或者别名进行检索 
					s AliasFlag=0     
					s PINYINFlag=""
					s PINYINCODE=""   
			        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
			        if (PINYINFlag=1)
			        {
			          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRCCommandName) 
			        }
					if ((ASRCCommandName[desc)||(PINYINCODE[desc))  
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
    set Data=$lb(ASRCID,ASRCIsParamCommand,ASRCCommandName,ASRCExpression,ASRCParamFormat,ASRCParamType,ASRCTriggerType,ASRCTriggerTypeExpression,ASRCCommandParam,ASRCParamDescription)
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
/// Table:ASR_CommandSetScenesCmd
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).FormValidate("","1||2","测试")
ClassMethod FormValidate(id As %String, parref As %String, commandname As %String) As %String
{
	s flag=0
	s ASRCParref=$p(parref,"||",1)
	s ASRSID=$p(parref,"||",2)
	s rowid=$p(id,"||",3)
	if ((parref'="")&&(commandname'=""))
	{
		s ASRCID=$o(^CF.DOC.ASR.CommandSetI("CommandName",ASRCParref,ASRSID,commandname,0))
		if (ASRCID'="")&&(ASRCID'=rowid) s flag=1
	}
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-01-09
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：ASR_CommandSetScenesCmd
/// Input：ASRCID
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).OpenData("1||1||1")
ClassMethod OpenData(id As %String) As %String
{
    s str = "" 
	s eobj = ##class(web.Entity.ASR.ASRCommandSetScenesCmd).%New()
	s eobj.ASRCID = id
	s ASRSParRef=$p(id,"||",1)
	s ASRCParref=$p(id,"||",2)
	s ASRCChildSub=$p(id,"||",3)
	s eobj.ASRCParref=ASRSParRef_"||"_ASRCParref
	s eobj.ASRCIsParamCommand= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",1)		//是否有参数命令（Y/N）
	s eobj.ASRCCommandName= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",2)		//命令名
	s eobj.ASRCExpression = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",3)  //命令描述或表达式
	s eobj.ASRCParamFormat = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",4)   //参数格式
	s eobj.ASRCParamType = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",5)   //参数类型
	s eobj.ASRCTriggerType= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",6)		//触发类型
	s eobj.ASRCTriggerTypeExpression= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",7)		//触发类型表达式
	s eobj.ASRCCommandParam= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",8)		//命令参数
	s eobj.ASRCParamDescription= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRCParref,"Cmd",ASRCChildSub)),"^",9)		//命令参数说明
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：根据id删除 查询语音命令集场景命令指令
/// Table：ASR_CommandSetScenesCmd
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.ASRCommandSetScenesCmd).%OpenId(id)
	s eobj = ##class(web.Entity.ASR.ASRCommandSetScenesCmd).%New()
	s eobj.ASRCIsParamCommand = pobj.ASRCIsParamCommand		  //是否有参数命令（Y/N）
	s eobj.ASRCCommandName = pobj.ASRCCommandName		  //命令名
	s eobj.ASRCExpression=pobj.ASRCExpression		  //命令描述或表达式
	s eobj.ASRCParamFormat = pobj.ASRCParamFormat		  //参数格式
	s eobj.ASRCParamType=pobj.ASRCParamType		  //参数类型
	s eobj.ASRCTriggerType = pobj.ASRCTriggerType		  //触发类型
	s eobj.ASRCTriggerTypeExpression=pobj.ASRCTriggerTypeExpression		  //触发类型表达式
	s eobj.ASRCCommandParam=pobj.ASRCCommandParam		  //命令参数
	s eobj.ASRCParamDescription=pobj.ASRCParamDescription		  //命令参数说明
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.ASRCommandSetScenesCmd).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenesCmd","User.ASRCommandSetScenesCmd","语音命令集场景命令指令",id,eobj.ASRCCommandName,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音命令集场景命令指令","web.DHCBL.ASR.ASRCommandSetScenesCmd","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator:杨帆 
/// CreatDate: 2020-01-09
/// Description：保存 查询语音命令集场景命令指令
/// Input: eobj As web.Entity.ASR.ASRCommandSetScenesCmd
/// Table：ASR_CommandSetScenesCmd
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCommandSetScenesCmd) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ASRCIsParamCommand="" eobj.ASRCIsParamCommand="N"
		s flag=..FormValidate(eobj.ASRCID,eobj.ASRCParref,eobj.ASRCCommandName)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRCID="")
		{
			s obj=##class(User.ASRCommandSetScenesCmd).%New(eobj.ASRCParref)
		}
		else
		{
			s obj=##class(User.ASRCommandSetScenesCmd).%OpenId(eobj.ASRCID)
			s bobj=##class(web.Entity.ASR.ASRCommandSetScenesCmd).%New()
			s bobj.ASRCID = eobj.ASRCID		//ASRCID
			s bobj.ASRCIsParamCommand = obj.ASRCIsParamCommand		    //是否有参数命令（Y/N）
			s bobj.ASRCCommandName = obj.ASRCCommandName		//命令名
			s bobj.ASRCExpression=obj.ASRCExpression	//命令描述或表达式
			s bobj.ASRCParamFormat = obj.ASRCParamFormat	//参数格式
			s bobj.ASRCParamType=obj.ASRCParamType	//参数类型
			s bobj.ASRCTriggerType=obj.ASRCTriggerType	//触发类型
			s bobj.ASRCTriggerTypeExpression=obj.ASRCTriggerTypeExpression	//触发类型表达式
			s bobj.ASRCCommandParam=obj.ASRCCommandParam	//命令参数
			s bobj.ASRCParamDescription=obj.ASRCParamDescription	//命令参数说明
		}
		d obj.ASRCParrefSetObjectId(eobj.ASRCParref)
		s obj.ASRCIsParamCommand = eobj.ASRCIsParamCommand		    //是否有参数命令（Y/N）
		s obj.ASRCCommandName = eobj.ASRCCommandName		//命令名
		S obj.ASRCExpression=eobj.ASRCExpression	//命令描述或表达式
		s obj.ASRCParamFormat = eobj.ASRCParamFormat	//参数格式
		s obj.ASRCParamType = eobj.ASRCParamType	//参数类型
		s obj.ASRCTriggerType = eobj.ASRCTriggerType	//触发类型
		s obj.ASRCTriggerTypeExpression = eobj.ASRCTriggerTypeExpression	//触发类型表达式
		s obj.ASRCCommandParam = eobj.ASRCCommandParam	//命令参数
		s obj.ASRCParamDescription = eobj.ASRCParamDescription	//命令参数说明
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ASRCID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenes","User.ASRCommandSetScenesCmd","语音命令集场景命令指令",eobj.ASRCID,eobj.ASRCCommandName,"U",eobj,bobj)
    		d:eobj.ASRCID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenes","User.ASRCommandSetScenesCmd","语音命令集场景命令指令",id,eobj.ASRCCommandName,"A",eobj)
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

/// 【医呼通接口】语音HIS配置界面配置中，在场景命令中通过命令描述或表达式获取触发类型表达式
/// 基础数据平台-likefan
/// 2022-10-24
/// input: 命令描述或表达式
/// output: 触发类型表达式
/// w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).GetExpressionByDescAll("上一页")
/// w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).GetExpressionByDescAll("下一页")
ClassMethod GetExpressionByDescAll(desc As %String) As %String
{
	q:desc="" ""
	s result=""
	s ParRef=0
	for
	{
		s ParRef=$o(^CF.DOC.ASR.CommandSetD(ParRef)) q:ParRef=""
		s ParRefChild=0
		for
		{
			s ParRefChild=$o(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild)) q:ParRefChild=""
			s ChildSub=0
			for
			{
				s ChildSub=$o(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)) q:ChildSub=""
				s ASRCExpression=$p($g(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)),"^",3)		//命令描述或表达式
				s ASRCTriggerTypeExpression=$p($g(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)),"^",7)	//触发类型表达式
				if (ASRCExpression=desc)
				{
					s result=ASRCTriggerTypeExpression
					q
				}
			}
			q:result'=""
		}
		q:result'=""
	}
	q result
}

/// 【医呼通接口】语音HIS配置界面配置中，在场景命令中通过命令描述或表达式获取触发类型表达式
/// 基础数据平台-likefan
/// 2022-10-24
/// input: 应用名，场景，命令描述或表达式
/// output: 触发类型表达式
/// w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).GetExpressionByDesc("语音录入","病人列表","上一页")
/// w ##class(web.DHCBL.ASR.ASRCommandSetScenesCmd).GetExpressionByDesc("语音录入","HeaderMenu","打开消息")
ClassMethod GetExpressionByDesc(appname As %String, scenes As %String, desc As %String) As %String
{
	q:appname="" ""
	q:scenes="" ""
	q:desc="" ""
	s result=""
	
	s ParRef=$o(^CF.DOC.ASR.CommandSetI("AppName",appname,0))
	q:ParRef="" ""
	s ParRefChild=$o(^CF.DOC.ASR.CommandSetI("Scenes",scenes,ParRef,0))
	q:ParRefChild="" ""
	s ChildSub=0
	for
	{
		s ChildSub=$o(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)) q:ChildSub=""
		s ASRCExpression=$p($g(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)),"^",3)		//命令描述或表达式
		s ASRCTriggerTypeExpression=$p($g(^CF.DOC.ASR.CommandSetD(ParRef,"Scenes",ParRefChild,"Cmd",ChildSub)),"^",7)	//触发类型表达式
		if (ASRCExpression=desc)
		{
			s result=ASRCTriggerTypeExpression
			q
		}
	}
	q result
}

}
