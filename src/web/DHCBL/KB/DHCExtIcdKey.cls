Import SQLUser

/// 名称: 诊断关键字维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.DHCBL.KB.DHCExtIcdKey Extends %RegisteredObject
{

/// 石萧伟	
/// Description：修改时打开的数据
/// Table：User.DHCExtIcdKey
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCExtIcdKey).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCExtIcdKey).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCExtIcdKey).%New()
	s eobj.ICDKRowId=id
	s eobj.ICDKText = pobj.ICDKText
	s eobj.ICDKSysFlag = pobj.ICDKSysFlag
	s:eobj.ICDKSysFlag'="N" eobj.ICDKSysFlag="Y" 
	if $IsObject(pobj.ICDKICDDr){
		s eobj.ICDKICDDr = pobj.ICDKICDDr.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Description：修改时打开的数据
/// Table：User.DHCExtIcdKey
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCExtIcdKey).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s pobj = ##class(User.DHCExtIcdKey).%OpenId(id)
	s eobj = ##class(web.Entity.KB.DHCExtIcdKey).%New()
	s eobj.ICDKRowId=id
	s eobj.ICDKText = pobj.ICDKText
	s eobj.ICDKSysFlag = pobj.ICDKSysFlag
	s:eobj.ICDKSysFlag="Y" eobj.ICDKSysFlag="true" 
	if $IsObject(pobj.ICDKICDDr){
		s eobj.ICDKICDDr = pobj.ICDKICDDr.%Id() 
		}
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// CreateDate:2015-2-8 
/// w ##class(web.DHCBL.KB.DHCExtIcdKey).FormValidate("","4","1")
ClassMethod FormValidate(id As %String, icd As %String, text As %String) As %String
{
	s flag=""
	s flagd=""
	s:text'="" text=$ZCONVERT(text,"U") //转换成大写
	if (icd'="")&(text'=""){
		s flagd=$d(^DHCEXTICDKi(0,"ICDText",icd,text))
		if (id="") //如果为空，增加时的重复判断
		{
			if (flagd>0)
			{
				s flag=1  //返回重复标志
			}
			else
			{
				s flag=0 //返回不重复标志
			}
		}
		else //如果不为空，修改时的重复判断
		{
			s idd=""	
			s idd=$o(^DHCEXTICDKi(0,"ICDText",icd,text,0))
			if ((idd'=id)&(flagd>0))
			{
				s flag=1  //返回重复标志
			}
			else
			{
				s flag=0 //返回不重复标志
			}
		}
	}
	q flag
}

/// Description：保存诊断关键字字典的内容
/// Table：User.DHCExtIcdKey
/// Input：web.Entity.KB.DHCExtIcdKey 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCExtIcdKey).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCExtIcdKey) As %String
{
	s $zt="ERROE"
	s result = ""
	s flag=..FormValidate(eobj.ICDKRowId,eobj.ICDKICDDr,eobj.ICDKText)  //调用重复验证
 	if (flag=1)
 	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  	}
  	else{
		if $IsObject(eobj)
		{	
				if (eobj.ICDKRowId="")  //如果RowId未赋值则增加
				{
					s obj=##class(User.DHCExtIcdKey).%New()
				}
				else                     //如果RowId已赋值则修改
				{
					s obj=##class(User.DHCExtIcdKey).%OpenId(eobj.ICDKRowId)
					s bobj=##class(web.Entity.KB.DHCExtIcdKey).%New()
					s bobj.ICDKRowId=eobj.ICDKRowId
					if $IsObject(obj.ICDKICDDr){
						s bobj.ICDKICDDr = obj.ICDKICDDr.%Id() 
					}
					s bobj.ICDKText = obj.ICDKText          //修改描述
					s bobj.ICDKSysFlag = obj.ICDKSysFlag
				}
				d obj.ICDKICDDrSetObjectId(eobj.ICDKICDDr)
				s obj.ICDKText = eobj.ICDKText          //修改描述
				s:eobj.ICDKSysFlag="" eobj.ICDKSysFlag ="N" 
				s obj.ICDKSysFlag = eobj.ICDKSysFlag	
				Ts					
				s sc=obj.%Save()
				d obj.%Close()
				If $$$ISOK(sc)
				{
					Tc
					s id = obj.%Id()
					s result = "{success:'true',id:'"_id_"'}"  //返回RowId
					//新增时，日志
					d:eobj.ICDKRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdKey","User.DHCExtIcdKey","诊断关键字字典",id,eobj.ICDKText,"A",eobj)
					//修改时，日志
					d:eobj.ICDKRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdKey","User.DHCExtIcdKey","诊断关键字字典",eobj.ICDKRowId,eobj.ICDKText,"U",eobj,bobj)
				}
				else
				{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断关键字字典","web.DHCBL.KB.DHCExtIcdKey","SaveData",eobj)
    				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}			
		}
		else
		{
			s result = "{success:'false',errorinfo:'对象不存在！'}"
		}
  	}
	q result
ERROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断关键字字典","web.DHCBL.KB.DHCExtIcdKey","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：根据ID删除诊断关键字字典的内容
/// Table：User.DHCExtIcdKey
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.KB.DHCExtIcdKey).%New()
	s eobj.ICDKRowId = id
	s eobj.ICDKICDDr=$p($g(^DHCEXTICDK(id)),"^",1)
	s eobj.ICDKText=$p($g(^DHCEXTICDK(id)),"^",2)
	s eobj.ICDKSysFlag=$p($g(^DHCEXTICDK(id)),"^",3)
	Tstart
	s sc=##class(User.DHCExtIcdKey).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tc
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ExtIcdKey","User.DHCExtIcdKey","诊断关键字字典",id,eobj.ICDKText,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("诊断关键字字典","web.DHCBL.KB.DHCExtIcdKey","DeleteData",eobj)
    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Description：查询诊断关键字字典的内容
/// Table：User.DHCExtIcdKey
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCExtIcdKey","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICDKRowId:%String,ICDKICDDr:%String,ICDKText:%String,ICDKSysFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权
	s AuStr=##class(web.DHCBL.Authorize.DHCExtIcdKey).DHCGetDataByDefaultSession()
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICDKRowId=rowid
		s ICDRowId=$p($g(^DHCEXTICDK(ICDKRowId)),"^",1)
		s ICDKText=$p($g(^DHCEXTICDK(ICDKRowId)),"^",2)
		s ICDKSysFlag=$p($g(^DHCEXTICDK(ICDKRowId)),"^",3)
		s:ICDKSysFlag="" ICDKSysFlag="Y"
		i ICDRowId'="" {
			s ICDKICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
		}
		else {
			s ICDKICDDr=""
		}
	
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ICDKRowId=0
		for {
			s ICDKRowId=$o(^DHCEXTICDK(ICDKRowId))
			q:ICDKRowId=""
			//筛选授权后的数据
			s strRowId="{ID:"_ICDKRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) {
				s ICDRowId=$p($g(^DHCEXTICDK(ICDKRowId)),"^",1)
				i ICDRowId'="" {
					s ICDKICDDr=$p($g(^DHCEXTICD(ICDRowId)),"^",2)
				}
				else {
					s ICDKICDDr=""
				}
				s ICDKText=$p($g(^DHCEXTICDK(ICDKRowId)),"^",2)
				s ICDKSysFlag=$p($g(^DHCEXTICDK(ICDKRowId)),"^",3)
				s:ICDKSysFlag="" ICDKSysFlag="Y"
				s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICDKText)
				if ((ICDRowId=code)||(code=""))&(($ZCONVERT(ICDKText,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ICDKRowId,ICDKICDDr,ICDKText,ICDKSysFlag)
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

}
