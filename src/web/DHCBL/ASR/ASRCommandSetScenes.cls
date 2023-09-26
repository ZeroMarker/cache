/// 名称:语音HIS-语音命令集场景表
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-01-09
Class web.DHCBL.ASR.ASRCommandSetScenes Extends %RegisteredObject
{

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：查询语音命令集场景表的内容
/// Table：ASR_CommandSetScenes
/// Input：rowid,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.ASR.ASRCommandSetScenes","GetList","","qcj","1")
Query GetList(rowid As %String, desc As %String, parref As %String) As %Query(ROWSPEC = "ASRSID:%String,ASRSScenes:%String,ASRSScenesCommandName:%String,ASRSActiveFlag:%String,ASRSRemark:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String, parref As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ASRSID=rowid
		s ASRSParRef=$p(rowid,"||",1)
		s ASRSChildSub=$p(rowid,"||",2)
		s ASRSScenes= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",1)		//场景
		s ASRSScenesCommandName= $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2)		//场景命令名
		s ASRSActiveFlag = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",3)  //有效标识（Y/N）
		s:ASRSActiveFlag="" ASRSActiveFlag="Y"
		s ASRSRemark = $p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",4)   //备注说明
		s ASRSRemark = ##class(web.DHCBL.BDP.FunLib).EvalJSON(ASRSRemark)
		
		d OutputRow
	}
	else
	{
		if parref'=""
		{
			s ASRSChildSub=0
			for
			{
				s ASRSChildSub=$o(^CF.DOC.ASR.CommandSetD(parref,"Scenes",ASRSChildSub)) q:ASRSChildSub=""
				s ASRSID=parref_"||"_ASRSChildSub
				s ASRSScenes= $p($g(^CF.DOC.ASR.CommandSetD(parref,"Scenes",ASRSChildSub)),"^",1)		//场景
				s ASRSScenesCommandName= $p($g(^CF.DOC.ASR.CommandSetD(parref,"Scenes",ASRSChildSub)),"^",2)		//场景命令名
				s ASRSActiveFlag = $p($g(^CF.DOC.ASR.CommandSetD(parref,"Scenes",ASRSChildSub)),"^",3)  //有效标识（Y/N）
				s:ASRSActiveFlag="" ASRSActiveFlag="Y"
				s ASRSRemark = $p($g(^CF.DOC.ASR.CommandSetD(parref,"Scenes",ASRSChildSub)),"^",4)   //备注说明
				s ASRSRemark = ##class(web.DHCBL.BDP.FunLib).EvalJSON(ASRSRemark)
			
				if (desc'="")           
				{
					;需要对描述或者别名进行检索 
					s AliasFlag=0     
					s PINYINFlag=""
					s PINYINCODE=""
					s PINYIN=""   
			        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
			        if (PINYINFlag=1)
			        {
			          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRSScenes)
			          s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ASRSScenesCommandName) 
			        }
					if ((ASRSScenes[desc)||(ASRSScenesCommandName[desc)||(PINYINCODE[desc)||(PINYIN[desc))
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
    set Data=$lb(ASRSID,ASRSScenes,ASRSScenesCommandName,ASRSActiveFlag,ASRSRemark)
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
/// Table:ASR_CommandSetScenes
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenes).FormValidate("1||1","全场景","1")
ClassMethod FormValidate(id As %String, scenes As %String, parref As %String) As %String
{
	s flag=0
	s rowid=$p(id,"||",2)  //子表rowid
	if ((scenes'="")&&(parref'=""))
	{
		s ASRSID=$o(^CF.DOC.ASR.CommandSetI("Scenes",scenes,parref,0))
		if (ASRSID'="")&&(ASRSID'=rowid) s flag=1
	}
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2020-01-09
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：ASR_CommandSetScenes
/// Input：id
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSetScenes).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
    s str = "" 
	s eobj = ##class(web.Entity.ASR.ASRCommandSetScenes).%New() 
	s eobj.ASRSID = id
	s ASRSParRef=$p(id,"||",1)
	s ASRSChildSub=$p(id,"||",2)
	s eobj.ASRSParRef=ASRSParRef
	s eobj.ASRSScenes=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",1) //场景
	s eobj.ASRSScenesCommandName=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",2) //场景命令名
	s eobj.ASRSActiveFlag=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",3) //有效标识（Y/N）
	s:eobj.ASRSActiveFlag="" eobj.ASRSActiveFlag="Y"
	s eobj.ASRSRemark=$p($g(^CF.DOC.ASR.CommandSetD(ASRSParRef,"Scenes",ASRSChildSub)),"^",4) //备注说明
	s eobj.ASRSRemark = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.ASRSRemark)
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆
/// CreatDate:2020-01-09
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSetScenes).GetRefFlag("1||2")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s ASRPID=0
	for 
	{
		s ASRPID=$o(^CF.DOC.ASR.CommandParamsD(ASRPID))
		q:ASRPID=""
		s ASRPScenesDR= $p($g(^CF.DOC.ASR.CommandParamsD(ASRPID)),"^",1)
		if (ASRPScenesDR=id)
		{
			s myInfo=myInfo_"<语音命令集场景参数表>"
			q
		}
	}
	//场景关联厂商表User.ASRCommandCompany
	s ASRCCID=0
	for 
	{
		s ASRCCID=$o(^CF.DOC.ASR.CommandCompanyD(ASRCCID)) q:ASRCCID=""
		s ASRCCScenesDR=$p($g(^CF.DOC.ASR.CommandCompanyD(ASRCCID)),"^",1)		//应用场景
		if (ASRCCScenesDR=id)
		{
			s myInfo=myInfo_"<场景关联厂商表>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2020-01-09
/// Description：根据id删除 场景
/// Table：ASR_CommandSetScenes
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.ASR.ASRCommandSetScenes).DeleteData("1||6")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s re=##class(web.DHCBL.ASR.ASRCommandSetScenes).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s ASRSParRef=$p(id,"||",1)
	if (RefFlag=0){
		s pobj = ##class(User.ASRCommandSetScenes).%OpenId(id)
		s eobj = ##class(web.Entity.ASR.ASRCommandSetScenes).%New()
		s eobj.ASRSScenes = pobj.ASRSScenes		  //场景
		s eobj.ASRSScenesCommandName = pobj.ASRSScenesCommandName		  //场景命令名
		s eobj.ASRSActiveFlag=pobj.ASRSActiveFlag		  //有效标识（Y/N）
		s eobj.ASRSRemark = pobj.ASRSRemark		  //备注说明
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(User.ASRCommandSetScenes).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenes","User.ASRCommandSetScenes","语音命令集场景",id,eobj.ASRSScenes,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("语音命令集场景","web.DHCBL.ASR.ASRCommandSetScenes","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:杨帆 
/// CreatDate: 2020-01-09
/// Description：保存 语音命令集场景
/// Input: eobj As web.Entity.ASR.ASRCommandSetScenes
/// Table：ASR_CommandSetScenes
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenes).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.ASR.ASRCommandSetScenes) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.ASRSActiveFlag="" eobj.ASRSActiveFlag="N"
		
		s flag= ..FormValidate(eobj.ASRSID,eobj.ASRSParRef,eobj.ASRSScenes)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ASRSID="")
		{
			s obj=##class(User.ASRCommandSetScenes).%New(eobj.ASRSParRef)
		}
		else
		{
			s obj=##class(User.ASRCommandSetScenes).%OpenId(eobj.ASRSID)
			s bobj=##class(web.Entity.ASR.ASRCommandSetScenes).%New()
			s bobj.ASRSScenes = obj.ASRSScenes		    //场景
			s bobj.ASRSScenesCommandName = obj.ASRSScenesCommandName		//场景命令名
			s bobj.ASRSActiveFlag=obj.ASRSActiveFlag	//有效标识（Y/N）
			s bobj.ASRSRemark = obj.ASRSRemark	//备注说明
		}
		d obj.ASRSParRefSetObjectId(eobj.ASRSParRef)
		s obj.ASRSScenes = eobj.ASRSScenes		    //场景
		s obj.ASRSScenesCommandName = eobj.ASRSScenesCommandName		//场景命令名
		S obj.ASRSActiveFlag=eobj.ASRSActiveFlag	//有效标识（Y/N）
		s obj.ASRSRemark = eobj.ASRSRemark	//备注说明
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ASRSID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenes","User.ASRCommandSetScenes","语音命令集场景",eobj.ASRSID,eobj.ASRSScenes,"U",eobj,bobj)
    		d:eobj.ASRSID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ASR_CommandSetScenes","User.ASRCommandSetScenes","语音命令集场景",id,eobj.ASRSScenes,"A",eobj)
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

/// Creator:杨帆 
/// CreatDate: 2020-01-30
/// Description：根据场景代码获取父表的id
/// Input: code
/// Table：ASR_CommandSetScenes
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenes).GetParRefData()
ClassMethod GetParRefData(code As %String) As %String
{
	s result=""
	s ASRID=$o(^CF.DOC.ASR.CommandSetI("Scenes",code,0))
	if (ASRID'="")
	{
		s ASRSChildSub=0
		for
		{
			s ASRSChildSub=$o(^CF.DOC.ASR.CommandSetD(ASRID,"Scenes",ASRSChildSub)) q:ASRSChildSub=""
			s ASRSActiveFlag=$p($g(^CF.DOC.ASR.CommandSetD(ASRID,"Scenes",ASRSChildSub)),"^",3)
			if (ASRSActiveFlag="Y")
			{
				s result=ASRID
				q
			}
		}
	}
	q result
}

/// Creator:杨帆 
/// CreatDate:2020-01-09
/// Description:删除数据验证方法,js调用
/// Table：ASR_CommandSetScenes
/// Input:id
/// Return:"1"
/// Other:w ##class(web.DHCBL.ASR.ASRCommandSetScenes).DelValidate("1||2")
ClassMethod DelValidate(id As %String) As %String
{
	s flag=0
	s ASRSID=id
	s ASRSParRef=$p(id,"||",1)
	s ASRSChildSub=$p(id,"||",2)
	if (id'="")
	{
		s ASRCCommandName=$o(^CF.DOC.ASR.CommandSetI("CommandName",ASRSParRef,ASRSChildSub,0))
		if (ASRCCommandName'="") s flag=1
	}
	q flag
}

}
