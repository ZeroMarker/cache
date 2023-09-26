Class web.DHCBL.BDP.BDPConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description：打开数据
/// Table：User.BDPCONFIG
/// Input：id
/// Other: w ##class(web.DHCBL.BDP.BDPConfig).OpenData("29")
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
  s:eobj.ConfigActive="Y" eobj.ConfigActive="true"
  s:eobj.ConfigEdit="Y" eobj.ConfigEdit="true"
  if ((eobj.ConfigType="C")&&(eobj.ConfigValue="Y")){
    s eobj.ConfigValue="true"
  }
  if ((eobj.ConfigType="D")){
    s:eobj.ConfigValue'="" eobj.ConfigValue=$zd(eobj.ConfigValue,3)
  }
  if ((eobj.ConfigType="CB")){
    s:eobj.ConfigValue'="" eobj.ConfigValue=$p($g(^SSU("SSGRP",eobj.ConfigValue)),"^",1) //获取用户安全组描述
  }
  if (eobj.ConfigCode="BDPPassWord") //2021-01-08
  {
	  s eobj.ConfigValue="******"  
  }
  s str = eobj.JsonS()  
  d eobj.%Close()
  s str = "{list:["_str_"]}"
  q str
}

/// Function:保存修改
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).SaveData()
ClassMethod SaveData(args As %String) As %String
{
	s result=""
	Ts
	s argsLen=$Length(args,";")
	for i=1:1:argsLen   
	{

		s BDPConfig=$p(args,";",i)  
		s ConfigCode=$p(BDPConfig,"^",1)
		s ConfigValue=$p(BDPConfig,"^",2)
		s ConfigType=$p(BDPConfig,"^",3)
		if ((ConfigType="datefield")&&(ConfigValue'=""))
		{
			s ConfigValue=$zdh(ConfigValue,15)  
		}
		s id=$o(^User.BDPConfigI("ConfigCodeI"," "_$ZCONVERT(ConfigCode,"U"),0))
		if (id'="")
		{
			if ($List(^User.BDPConfigD(id),3)'=ConfigValue)
			{
				s obj=##class(User.BDPConfig).%OpenId(id)
				
				//修改前bobj
				s bobj=##class(web.Entity.BDP.BDPConfigAdmin).%New()
				s bobj.ID=id
				s bobj.ConfigCode=obj.ConfigCode
				s bobj.ConfigDesc=obj.ConfigDesc
				s bobj.ConfigType=obj.ConfigType
				s bobj.ConfigValue=obj.ConfigValue
				s bobj.ConfigExplain=obj.ConfigExplain
				s bobj.ConfigActive=obj.ConfigActive
				s bobj.ConfigEdit=obj.ConfigEdit        
				if (ConfigCode="BDPPassWord") //2021-01-08
				{
					s bobj.ConfigValue="******"
				}
				
				//新数据eobj
				s eobj=##class(web.Entity.BDP.BDPConfigAdmin).%New()
				s eobj.ID=id
				s eobj.ConfigCode=obj.ConfigCode
				s eobj.ConfigDesc=obj.ConfigDesc
				s eobj.ConfigType=obj.ConfigType
				s eobj.ConfigExplain=obj.ConfigExplain
				s eobj.ConfigActive=obj.ConfigActive
				s eobj.ConfigEdit=obj.ConfigEdit
				
				if (ConfigCode="BDPPassWord") //2021-01-08
				{
					if (ConfigValue="******")
					{
						s eobj.ConfigValue="******"
					}
					else
					{
						s ConfigValue = ##Class(web.SSUser).Encrypt(ConfigValue)	 //加密
						s eobj.ConfigValue = "******"
						s $List(^User.BDPConfigD(id),3)=ConfigValue
						//修改时，日志
						d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPConfig","User.BDPConfig","平台配置",eobj.ID,eobj.ConfigDesc,"U",eobj,bobj)
				
					}
				}
				else
				{
					s eobj.ConfigValue=ConfigValue
					s $List(^User.BDPConfigD(id),3)=ConfigValue  
					//修改时，日志
					d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPConfig","User.BDPConfig","平台配置",eobj.ID,eobj.ConfigDesc,"U",eobj,bobj)
				}
				s result = result_"^"_1
			}
		}
		else
		{
			s result = result_"^"_0
		} 
	}
	if (result[0)
	{   
		Trollback
		s result = "{success:'false',errorinfo:'配置项的值不能为空！'}"     
	}
	else
	{
		Tc
		s result = "{success:'true',info:'修改成功！'}"  
	}
	

	q result
}

/// Function:返回最后一条数据的id
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).FindIdStr()
ClassMethod FindIdStr() As %String
{
  s IdStr=""
  s ID=0
  for {
    s ID=$o(^User.BDPConfigD(ID)) 
    q:ID=""
    s IdStr=IdStr_"^"_ID
  }
  set result="{IdStr:'"_IdStr_"'}"
  q result
}

/// Function:恢复默认
/// update@2020-09-28
ClassMethod RestoreData(args As %String) As %String
{
	s result=""
	if (args="") //通过表里的初始值列来恢复。
	{
		s ID=0
		for {
			s ID=$o(^User.BDPConfigD(ID)) q:ID=""
			s $List(^User.BDPConfigD(ID),3)=$listget($g(^User.BDPConfigD(ID)),8)
		}
		
	}
	else  //保留原来的方法
	{
		s argsLen=$Length(args,"^")
		for i=1:1:argsLen   
		{

			s BDPConfig=$p(args,"^",i)  
			s ConfigCode=$p(BDPConfig,":",1)
			s:ConfigCode'="" ConfigCode=$ZCONVERT(ConfigCode,"U")
			s ConfigValue=$p(BDPConfig,":",2)
			s id=$o(^User.BDPConfigI("ConfigCodeI"," "_ConfigCode,0))
			s $List(^User.BDPConfigD(id),3)=ConfigValue

		}  
	} 
	s result = "{success:'true',info:'恢复成功！'}"
	k ^User.BDPCDSSDeptUserAutD,^User.BDPCDSSDeptUserAutI  //清除CDSS科室用户授权
	q result
}

/// Function:获取密码
/// Others:d ##class(web.DHCBL.BDP.BDPConfig).GetPassword()
ClassMethod GetPassword() As %String
{
  s id=$o(^User.BDPConfigI("ConfigCodeI"," BDPPASSWORD",0))
  if (id=""){
    set result="{success:'false'}"
  }else{
    s password=$Listget($g(^User.BDPConfigD(id)),3)
    if (password'=""){
      set result="{success:'true',password:'"_password_"'}"     
    }else{
      set result="{success:'false'}"
    }
  }
  q result
}

/// Function:是根据配置code 查询到配置的值
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel")
ClassMethod GetConfigValue(code As %String) As %String
{
  s ConfigCode=""
  s ConfigValue=""
  s:code'="" ConfigCode=$ZCONVERT(code,"U")
  s Configid=$o(^User.BDPConfigI("ConfigCodeI"," "_ConfigCode,0))
  if (Configid'=""){
    s ConfigValue=$listget($g(^User.BDPConfigD(Configid)),3)
  }else{
    s ConfigValue=""
  }
  q ConfigValue
}

/// 获取版本号
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).GetBDPVersion()
ClassMethod GetBDPVersion() As %String
{
  s id=""
  s id=$o(^User.BDPVersionD(""),-1)
  q:id="" ""  
  s BDPVersion=" R"_$listget($g(^User.BDPVersionD(id)),3)_"."_$listget($g(^User.BDPVersionD(id)),4)_"."_$listget($g(^User.BDPVersionD(id)),5)
  q BDPVersion
}

/// 保存标准编码字段
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).GetBDPVersion()
ClassMethod SaveNationalData(str) As %String
{
  s result=""
  s ConfigCode="BDPNationalDataShow"
  s ConfigCode=$ZCONVERT(ConfigCode,"U")
  s id=$o(^User.BDPConfigI("ConfigCodeI"," "_ConfigCode,0))
  if (id'="")
  {
    s $List(^User.BDPConfigD(id),3)=str
    s result="true"
  }
  else
  {
    s result="false"
  }
  q result
}

/// Function:判断是否开启了自定义快捷键功能
/// Creator: sunfengchao
/// w ##class(web.DHCBL.BDP.BDPConfig).IfOneKeyMap()
ClassMethod IfOneKeyMap()
{
  s ID=0,value=""
  if ($d(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAP"))>0)
  {
    s ID=$o(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAP",0))
    s value=$listget($g(^User.BDPConfigD(ID)),3)
  }
  q value
}

/// Function:保存快捷键信息
/// Creator: sunfengchao
/// w ##class(web.DHCBL.BDP.BDPConfig).SaveKeyMapData("shift+A^shift+U^shift+D+^shift+H")
ClassMethod SaveKeyMapData(datalist As %String)
{
   s result="false",id=0
   if ($d(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAPDATA"))>0){
    s id=$o(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAPDATA",0))
    q:id="" "false"
    s obj=##class(User.BDPConfig).%OpenId(id)
  }
  else
  {
    s obj=##class(User.BDPConfig).%New()
  }
  s obj.ConfigCode="BDPKeyMapData"
  s obj.ConfigDesc="快捷键配置值"
  s obj.ConfigValue=datalist
  s sc=obj.%Save()
  if (sc=1){
    s flag="true"  
  }
  q result
}

/// Function:显示快捷键
/// Creator: sunfengchao
/// w ##class(web.DHCBL.BDP.BDPConfig).ShowKeyMapValue()
ClassMethod ShowKeyMapValue()
{
  s id=0,configData=""
  if ($d(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAPDATA"))>0)
  {
    s id=$o(^User.BDPConfigI("ConfigCodeI"," BDPKEYMAPDATA",0))
    q:id="" ""
    s configData=$listget($g(^User.BDPConfigD(id)),3)
  }
  q configData
}

/// Function:获取是否禁用全部Code字段值
/// Creator: ybq
/// w ##class(web.DHCBL.BDP.BDPConfig).StopOrActiveCode()
ClassMethod StopOrActiveCode()
{
	q "true"
}

/// Function:获取是否开启根据分辨率设置显示条数
/// Creator: ybq
/// w ##class(web.DHCBL.BDP.BDPConfig).StopOrActivePageSize()
ClassMethod StopOrActivePageSize()
{
	s id=0,configData=""
  	if ($d(^User.BDPConfigI("ConfigCodeI"," CONFIGPAGESIZE"))>0)
  	{
    	s id=$o(^User.BDPConfigI("ConfigCodeI"," CONFIGPAGESIZE",0))
    	q:id="" ""
    	s configData=$listget($g(^User.BDPConfigD(id)),3)
  	}
  	q configData
}

/// 2020-01-20 HIS语音配置按科室开启语音功能
/// Function:获取按科室开启语音功能的科室信息
/// Creator:chenying 
/// CreatDate:2020-01-20
/// w ##class(web.DHCBL.BDP.BDPConfig).GetBDPHISASRLocData("")
ClassMethod GetBDPHISASRLocData(desc)
{
	s configData= ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHISASRLocData")
	w "{data:["
	s Count=0
	if configData'=""
	{
		s str=""
		s desc=$ZCONVERT(desc,"U")
		s length=$l(configData,"^")
		for i=1:1:length
		{
			s CTLOCRowId=$p(configData,"^",i)
			continue:CTLOCRowId=""
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowId)),"^",2)
			s CTLOCDesc=$tr(CTLOCDesc,"""","”")
			s PINYIN=""
			if desc'="" s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
			if (CTLOCDesc[desc)||(PINYIN[desc)
			{
				s Count=Count+1
				if Count>1
				{
					w ","
				}
				w "{""ID"":"""_CTLOCRowId_""",""Name"":"""_CTLOCDesc_"""}"

			}
		}
	
	}
	w "], success:true, total:"_Count_"}"
	q ""
}

/// 2020-01-20 HIS语音配置按科室开启语音功能
/// Function:获取未开启语音功能的科室信息
/// Creator:chenying 
/// CreatDate:2020-01-20
/// w ##class(web.DHCBL.BDP.BDPConfig).GetNonBDPHISASRLocData("")
ClassMethod GetNonBDPHISASRLocData(desc)
{
	s desc=$ZCONVERT(desc,"U")
	s configData= ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHISASRLocData")
	s configData="^"_configData_"^"
	w "{data:["
	s Count=0
	if configData'=""
	{
		s CTLOCRowId=0
		for
		{
			s CTLOCRowId=$o(^CTLOC(CTLOCRowId)) q:CTLOCRowId=""
			
			s str="^"_CTLOCRowId_"^"
			if configData[str continue ///过滤掉已经开启的科室信息
			
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowId)),"^",2)
			s CTLOCDesc=$tr(CTLOCDesc,"""","”")
			s PINYIN=""
			if desc'="" s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
			if (CTLOCDesc[desc)||(PINYIN[desc)
			{
				s Count=Count+1
				if Count>1
				{
					w ","
				}
				w "{""ID"":"""_CTLOCRowId_""",""Name"":"""_CTLOCDesc_"""}"

			}
		}
	
	}
	w "], success:true, total:"_Count_"}"
	q ""
}

/// Creator:chenying 
/// CreatDate:2020-01-20
/// Function:根据code,修改对应的配置值
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).SaveConfigValue("BDPHISASRLocData","1^2^8")
ClassMethod SaveConfigValue(code As %String, Value As %String) As %String
{
	s str=""
	s id=$o(^User.BDPConfigI("ConfigCodeI"," "_$ZCONVERT(code,"U"),0))
	if (id'=""){
		s obj=##class(User.BDPConfig).%OpenId(id)
		s obj.ConfigValue=Value
		s sc=obj.%Save()
		if (sc=1){
			s str="{success:'true'}"
		}
	}
	else
	{
		
		s str="{success:'false'}"
	}
	q str
}

/// Creator:chenying 
/// CreatDate:2020-01-20
/// Function:判断科室是否开启语音功能
/// Others:s ret= ##class(web.DHCBL.BDP.BDPConfig).GetHisASRConfig(1)
/// Y开启语音功能，N关闭语音功能
ClassMethod GetHisASRConfig(CTLOCRowId) As %String
{
	s ret="N"
	s Flag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHISASRCommand")  //全局开启语音功能
	if Flag="Y"   //开启
	{
		s LocFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHISASRLoc") //按照科室开启语音功能
		if LocFlag="Y" 
		{
			s configData= ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHISASRLocData")
			s configData="^"_configData_"^"
			s str="^"_CTLOCRowId_"^"
			if configData[str 
			{
				s ret="Y"   //全局开启，并开启按照科室开启，配置过的科室才开启，未配置的不开启
			}
			else
			{
				
				s ret="N"
			}
			
		}
		else
		{
			s ret="Y"  //全局开启，未按照科室开启，则默认所有科室都开启
		}
	}
	else
	{
		s ret="N"
	}
	Q ret
}

/// CreatDate：2020-09-27
/// Function:判断密码是否匹配
/// Input:密码
/// Return:0匹配，-1不匹配
/// Others:w ##class(web.DHCBL.BDP.BDPConfig).MatchPassword()
ClassMethod MatchPassword(password) As %String
{
	s id=$o(^User.BDPConfigI("ConfigCodeI"," BDPPASSWORD",0))
	s result=-1
	if (id'=""){
		s Syspassword=$Listget($g(^User.BDPConfigD(id)),3)
		s password=##Class(web.SSUser).Encrypt(password)
		if (Syspassword=password){
			set result=0    
		}
	}
	else
	{
		if (password="admin"){
			set result=0
		}
	}
	q result
}

}
