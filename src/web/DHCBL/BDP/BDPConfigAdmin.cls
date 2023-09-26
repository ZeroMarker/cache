Class web.DHCBL.BDP.BDPConfigAdmin Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：
/// CreatDate: 2014-9-1
/// Description：修改时打开的数据
/// Table：User.BDPCONFIG
/// Input：id
/// Other: w ##class(web.DHCBL.BDP.BDPConfigAdmin).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.BDP.BDPConfigAdmin).%New()
	s eobj.ID = id
	s eobj.ConfigCode=$listget($g(^User.BDPConfigD(id)),1)
	s eobj.ConfigDesc=$listget($g(^User.BDPConfigD(id)),2)
	s eobj.ConfigValue=$listget($g(^User.BDPConfigD(id)),3)
	s eobj.ConfigType=$listget($g(^User.BDPConfigD(id)),4)
	s eobj.ConfigExplain=$listget($g(^User.BDPConfigD(id)),5)
	s eobj.ConfigActive=$listget($g(^User.BDPConfigD(id)),6)
	s eobj.ConfigEdit=$listget($g(^User.BDPConfigD(id)),7)
	s eobj.ConfigInitialvalue=$listget($g(^User.BDPConfigD(id)),8)
	s:eobj.ConfigActive="Y" eobj.ConfigActive="true"
	s:eobj.ConfigEdit="Y" eobj.ConfigEdit="true"
	if ((eobj.ConfigType="C")&&(eobj.ConfigValue="Y")){
		s eobj.ConfigValue="true"
	}
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：
/// CreatDate: 2014-9-2
/// Description：根据ID删除基础配置的内容
/// Table：User.BDPConfig2
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.Entity.BDP.BDPConfigAdmin).%New()
	s eobj.ID = id
	s eobj.ConfigCode=$listget($g(^User.BDPConfigD(id)),1)
	s eobj.ConfigDesc=$listget($g(^User.BDPConfigD(id)),2)
	s eobj.ConfigValue=$listget($g(^User.BDPConfigD(id)),3)
	s eobj.ConfigType=$listget($g(^User.BDPConfigD(id)),4)
	s eobj.ConfigExplain=$listget($g(^User.BDPConfigD(id)),5)
	s eobj.ConfigActive=$listget($g(^User.BDPConfigD(id)),6)
	s eobj.ConfigEdit=$listget($g(^User.BDPConfigD(id)),7)
	s eobj.ConfigInitialvalue=$listget($g(^User.BDPConfigD(id)),8)
	Tstart
	s sc=##class(User.BDPConfig).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPCONFIG","User.BDPConfig","基础配置组内应用",id,eobj.ConfigDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础配置组内应用","web.DHCBL.BDP.BDPConfigAdmin","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator：
/// CreatDate: 2014-9-1
/// Description：数据重复验证方法，由js调用
/// Table：User.BDPConfig
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.DHCBL.BDP.BDPConfigAdmin).FormValidate("10","001","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^User.BDPConfigI("ConfigCodeI"," "_code))
	s:desc'="" flagd=$d(^User.BDPConfigI("ConfigDescI"," "_desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^User.BDPConfigI("ConfigCodeI"," "_code,0))
		s:desc'="" idd=$o(^User.BDPConfigI("ConfigDescI"," "_desc,0))
		if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator：
/// CreatDate: 2014-8-25
/// Description：保存基础配置的内容
/// Table：User.BDPConfig
/// Input：web.Entity.BDP.BDPConfigAdmin
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.BDP.BDPConfigAdmin).SaveData()
ClassMethod SaveData(eobj As web.Entity.BDP.BDPConfigAdmin) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ID,eobj.ConfigCode,eobj.ConfigDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.BDPConfig).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(User.BDPConfig).%OpenId(eobj.ID)
				s bobj=##class(web.Entity.BDP.BDPConfigAdmin).%New()
				s bobj.ID=eobj.ID
				s bobj.ConfigCode=obj.ConfigCode
				s bobj.ConfigDesc=obj.ConfigDesc
				s bobj.ConfigType=obj.ConfigType
				s bobj.ConfigValue=obj.ConfigValue
				s bobj.ConfigExplain=obj.ConfigExplain
				s bobj.ConfigActive=obj.ConfigActive
				s bobj.ConfigEdit=obj.ConfigEdit
				s bobj.ConfigInitialvalue=obj.ConfigInitialvalue
			}
			
			s obj.ConfigCode = eobj.ConfigCode         //修改代码
			s obj.ConfigDesc = eobj.ConfigDesc         //修改描述
			if ((eobj.ConfigType="D")&&(eobj.ConfigValue'="")){
				s eobj.ConfigValue=$zdh(eobj.ConfigValue,15)  
			}  
			if ((eobj.ConfigType="C")&&(eobj.ConfigValue="")){
				s eobj.ConfigValue="N"
			}
			s obj.ConfigValue = eobj.ConfigValue   //修改值
			s obj.ConfigExplain = eobj.ConfigExplain  
			s obj.ConfigType = eobj.ConfigType
			s:eobj.ConfigActive="true" eobj.ConfigActive="Y"
			s:eobj.ConfigActive="" eobj.ConfigActive="N" 
			s obj.ConfigActive = eobj.ConfigActive 
			
			s:eobj.ConfigEdit="true" eobj.ConfigEdit="Y"
			s:eobj.ConfigEdit="" eobj.ConfigEdit="N"    
			s obj.ConfigEdit = eobj.ConfigEdit
			s obj.ConfigInitialvalue=eobj.ConfigInitialvalue
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPConfig","User.BDPConfig","基础配置组内应用",id,eobj.ConfigDesc,"A",eobj)
				//修改时，日志
				d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPConfig","User.BDPConfig","基础配置组内应用",eobj.ID,eobj.ConfigDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础配置组内应用","web.DHCBL.BDP.BDPConfigAdmin","SaveData",eobj)
     			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础配置组内应用","web.DHCBL.BDP.BDPConfigAdmin","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：
/// CreatDate: 2014-8-25
/// Description：查询基础配置的内容
/// Table：User.BDPCONFIG
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPConfigAdmin","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ConfigCode:%String,ConfigDesc:%String,ConfigValue:%String,ConfigType:%String,ConfigExplain:%String,ConfigActive:%String,ConfigEdit:%String,ConfigInitialvalue:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s ConfigCode=$listget($g(^User.BDPConfigD(ID)),1)
		s ConfigDesc=$listget($g(^User.BDPConfigD(ID)),2)
		s ConfigValue=$listget($g(^User.BDPConfigD(ID)),3)
		s ConfigType=$listget($g(^User.BDPConfigD(ID)),4)
		s ConfigExplain=$listget($g(^User.BDPConfigD(ID)),5)
		s ConfigActive=$listget($g(^User.BDPConfigD(ID)),6)
		s ConfigEdit=$listget($g(^User.BDPConfigD(ID)),7)
		if (ConfigType="D"){
			s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
		}
		if (ConfigType="CB"){
			s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
		}
		s ConfigInitialvalue=$listget($g(^User.BDPConfigD(ID)),8)
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ID=0
		for {
			s ID=$o(^User.BDPConfigD(ID))
			q:ID=""
			s ConfigCode=$listget($g(^User.BDPConfigD(ID)),1)
			s ConfigDesc=$listget($g(^User.BDPConfigD(ID)),2)
			s ConfigValue=$listget($g(^User.BDPConfigD(ID)),3)
			s ConfigType=$listget($g(^User.BDPConfigD(ID)),4)
			s ConfigExplain=$listget($g(^User.BDPConfigD(ID)),5)
			s ConfigActive=$listget($g(^User.BDPConfigD(ID)),6)
			s ConfigEdit=$listget($g(^User.BDPConfigD(ID)),7)
			if (ConfigType="D"){
				s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
			}
			if (ConfigType="CB"){
				s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
			}
			s ConfigInitialvalue=$listget($g(^User.BDPConfigD(ID)),8)
			if ($ZCONVERT(ConfigCode,"U")[code)&($ZCONVERT(ConfigDesc,"U")[desc)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ConfigCode,ConfigDesc,ConfigValue,ConfigType,ConfigExplain,ConfigActive,ConfigEdit,ConfigInitialvalue)
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

/// Creator：谷雪萍
/// CreatDate: 2017-9-18
/// Description：数据重复验证方法，由js调用
/// Table：User.BDPConfig
/// Input：id
/// Return：配置值
/// Other: w ##class(web.DHCBL.BDP.BDPConfigAdmin).GetConfigValue()
ClassMethod GetConfigValue(id As %String) As %String
{
	q:id="" ""
	s ConfigValue=$listget($g(^User.BDPConfigD(id)),3)
	q ConfigValue
}

}
