/// desc CDSS结构化数据表逻辑处理类
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BL.BLCDSSConfig Extends %RegisteredObject
{

/// desc 将CDSS结构化数据字典集中维护的数据，按照特定的格式导出来
/// w #class(EMRservice.BL.BLCDSSConfig).getData()
ClassMethod getData()
{
	s Id = ""
	s str = ""
	s count=0
	for
	{
		s Id = $O(^DHCEMRM.CDSSConfigD(Id))
		q:Id=""
		s obj = ##class(EMRmeta.CDSS.CDSSConfig).%OpenId(Id)
		s action = obj.Action
		s active = obj.Active
		s:(active=1) active = "I"
		s:(active=2) active = "O"
		s:(active=3) active = "ALL"
  		s cdssKey = obj.CDSSKey
		s cdssKeyType = obj.CDSSKeyType
		s cdssKeyLevel = obj.CDSSKeyLevel
		s cdssKeyValue = obj.CDSSKeyValue
		s cdssTool = obj.CDSSTool
		s result=action_"^"_active_"^"_cdssKey_"^"_cdssKeyLevel_"^"_cdssKeyType_"^"_cdssKeyValue_"^"_cdssTool
		s:count>0 str=str_"&"
		s str=str_result
		s count=count+1
	}
	q str
}

/// desc 初始化CDSS结构化数据表
/// w ##class(EMRservice.BL.BLCDSSConfig).InitData(data)
ClassMethod InitData(data As %String = "", cdssTool As %String = "")
{
	s $ZT="ERROR"
	s (active,action,cdssKey,cdssKeyLevel,cdssKeyType,cdssKeyValue)=""
	s count=0  
	s len= $L(data,"&")
	//TRUNCATE TABLE
	//检查表中是否有数据 如果有 清除数据
	&SQL(SELECT Count(*) into :count FROM EMRmeta_CDSS.CDSSConfig) 
	if (count>0){
		&SQL(TRUNCATE TABLE EMRmeta_CDSS.CDSSConfig) 
	}
	for i=1:1:len{
		s item = $P(data,"&",i)
		s action=$P(item,"^",1)
		s active=$P(item,"^",2)
		s:active=1 active = "I"
		s:active=2 active = "O"
		s:active=3 active = "ALL"
		s cdssKey=$P(item,"^",3)
		s cdssKeyLevel=$P(item,"^",4)
		s cdssKeyType=$P(item,"^",5)
		s cdssKeyValue=$P(item,"^",6)
		s cdssToolValue = $P(item,"^",7)
		s:cdssToolValue'="" cdssTool = cdssToolValue
		&SQL(INSERT INTO EMRmeta_CDSS.CDSSConfig (Active,Action,CDSSKey,CDSSKeyLevel,CDSSKeyType,CDSSKeyValue,CDSSTool) VALUES(:active,:action,:cdssKey,:cdssKeyLevel,:cdssKeyType,:cdssKeyValue,:cdssTool))	
	}
	q "success"
ERROR
	q "err"
}

/// desc CDSS结构化数据格式化接口(EMRmeta.CDSS.CDSSConfig)
/// debug w ##class(EMRservice.BL.BLCDSSConfig).clearCDSSConfig()
ClassMethod clearCDSSConfig(argFile)
{
	k ^DHCEMRM.CDSSConfigD
	k ^DHCEMRM.CDSSConfigI
	q "数据已清空"
}

/// desc CDSS结构化数据初始化接口(EMRmeta.CDSS.CDSSConfig)
/// debug w ##class(EMRservice.BL.BLCDSSConfig).initCDSSConfig("D:\configDataCDSSHM.txt")
ClassMethod initCDSSConfig(argFile)
{
	s $ZT="ERROR"
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s count=0
	While 'Stream.AtEnd {
		s Line = Stream.ReadLine()
		continue:Line=""
		s action = $P(Line,$C(9),1)
		s active = $P(Line,$C(9),2)
		s cdssKey=$P(Line,$C(9),3)
		s cdssKeyLevel=$P(Line,$C(9),4)
		s cdssKeyType=$P(Line,$C(9),5)
		s cdssKeyValue=$P(Line,$C(9),6)
		s cdssTool =$P(Line,$C(9),7)
		s hdsdCode =$P(Line,$C(9),8)
		&SQL(INSERT INTO EMRmeta_CDSS.CDSSConfig (Active,Action,CDSSKey,CDSSKeyLevel,CDSSKeyType,CDSSKeyValue,CDSSTool,HDSDCode) VALUES(:active,:action,:cdssKey,:cdssKeyLevel,:cdssKeyType,:cdssKeyValue,:cdssTool,:hdsdCode))	
		s count = count+1
	}
	q "初始化CDSS结构化数据成功:"_count
ERROR
	q "接口错误:"_$zerror
}

}
