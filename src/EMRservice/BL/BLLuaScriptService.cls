/// Desc:        lua脚本服务
/// Creator:     Candy
/// CreateDate:  2016-11-29
Class EMRservice.BL.BLLuaScriptService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       lua脚本执行
/// Creator:    Candy
/// CreateDate: 2016-11-29
/// Input:      argArray 传入参数   
///             argInData 传入数据
///             argOutMessage 返回参数
///             argOutData 返回数据 
ClassMethod DoLuaScript(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s fieldType = argArray.GetAt("params").GetAt("queryparams").GetAt("fieldType")
	if (fieldType = "getoperationlevel")
	{
		//根据手术名称取手术级别
		d ..GetOperationLevel(argArray,argInData,argOutMessage,argOutData)
	}
	elseif (fieldType = "getoperationfee")
	{
		//取手术费/手术材料费/手术用一次性材料费
		d ..GetOperationFee(argArray,argInData,argOutMessage,argOutData)
	}
	elseif (fieldType = "getoperationtype")
	{
		//根据手术编码获取手术类型
		d ..GetOperationType(argArray,argInData,argOutMessage,argOutData)
	}
	elseif (fieldType = "getoperamaincount")
	{
		//根据类型与是否主要判断是否合规
		d ..GetOperationMainCount(argArray,argInData,argOutMessage,argOutData)
	}
	elseif (fieldType = "gettypeadmdatetime")
	{
		//取就诊时间做动态赋值操作
		d ..GetTypeAdmDateTime(argArray,argInData,argOutMessage,argOutData)
	}
	elseif (fieldType = "getSignDateTime")
    {
        //根据质控医师签名带出签名时间
        d ..GetSignDateTime(argArray,argInData,argOutMessage,argOutData)
    }
    elseif (fieldType = "getZipCode")
    {
        //根据“区县^城市” 查找对应的邮政编码
        d ..GetZipCode(argArray,argInData,argOutMessage,argOutData)
    }
	q
}

/// Desc:       根据手术名称取手术级别
/// Creator:    Donglulu
/// CreateDate: 2016-11-30
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetOperationLevel(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	
	s ADefaultConditionValue = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key1")
	s ItemCode = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code")
	s id = ""
	s ADefaultConditionId = ""
	if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
	{
		for {
			s id = $o(^ORC("OPER",id))
			quit:(id = "")
			continue:($p(^ORC("OPER",id),"^",6)'="")
			if ($p(^ORC("OPER",id),"^",1) = ADefaultConditionValue )
			{
				s ADefaultConditionId = id
				quit
			}
		}
	}
	s OPERDefaultCategoryDR = ""
	if (ADefaultConditionId'="")
	{
		s OPERDefaultCategoryDR = $p($g(^ORC("OPER",ADefaultConditionId)),"^",7)
	}
	
	//开始查询
	s rowid = 0
	s levelCode = ""
	s levelDesc = ""
	s levelRowid = ""
	for {
		s rowid=$o(^ORC("CATEG",(rowid)))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列 ^ORC("CATEG",1)	=	"1^1^64203^^
		s CodeValue=$P(^ORC("CATEG",rowid),"^",1)
		s DescValue=$P(^ORC("CATEG",rowid),"^",2)  //$lg(^DHCEMRM.CustomDictionaryD(rowid),2)
		s AliasValue="" 
		
		//是否满足默认查询条件
		if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
		{
			continue:(OPERDefaultCategoryDR '= rowid)
			s levelCode = CodeValue
			s levelDesc = $ZCONVERT(DescValue,"O","UTF8")
			s levelRowid = rowid
			quit
		}
	}
	d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""BindCode"":"""_levelCode_""",""BindDesc"":"""_levelDesc_""",""BindRowID"":"""_levelRowid_"""}}]}")
	d argOutData.Write("NONE")
}

/// Desc:       lua脚本执行
/// Creator:    yhy
/// CreateDate: 2016-11-29
/// Input:      argArray 传入参数   
///             argInData 传入数据
///             argOutMessage 返回参数
///             argOutData 返回数据 ,手术费是20，另一个35,挂号费^0.00
ClassMethod GetOperationFee(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	
	s EpisodeID=""
	s result = "",HisOpsFee="",HisFee="",ret=0,ItemCode="",HisOpsFee2=""
	s EpisodeID = argArray.GetAt("params").GetAt("queryparams").GetAt("EpisodeID")
	s result = ##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(EpisodeID,"")
	s HisFee = $p(result,"!",20)
	s HisOpsFee = $p(HisFee,"^",3)
	s HisFee2 = $p(result,"!",35)
	s HisOpsFee2 = $p(HisFee2,"^",3)
	if ((HisOpsFee2="")||(HisOpsFee2="0")) s HisOpsFee2="0.00"
	if ((HisOpsFee="")||(HisOpsFee="0"))  s HisOpsFee="0.00"
	s:((HisOpsFee'="0.00")||(HisOpsFee2'="0.00")) ret=1
	d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""ret"":"""_ret_"""}}]}")
	d argOutData.Write("NONE")
}

/// Desc:       根据手术编码获取手术类型
/// Creator:    
/// CreateDate: 
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetOperationType(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s ADefaultConditionValue = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key1")
	s ItemCode = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code")
	s id = ""
	s ADefaultConditionId = ""
	if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
	{
		for {
			s id = $o(^ORC("OPER",id))
			quit:(id = "")
			if ($p(^ORC("OPER",id),"^",1) = ADefaultConditionValue )
			{
				s ADefaultConditionId = id
				quit
			}
		}
	}
	
	//开始查询
	s levelCode = ""
	s levelDesc = ""
	s levelRowid = ""
	
	if (ADefaultConditionId'="")
	{
		s tmpOPeratype = $P($G(^ORC("OPER",ADefaultConditionId,"DHC")),"^",11)
		s ^TMPCache("tmpOPeratype")=tmpOPeratype
		if (tmpOPeratype="D") {s levelCode="2",levelDesc="诊断性操作"}
		elseif (tmpOPeratype="T") {s levelCode="1",levelDesc="治疗性操作"}
		elseif (tmpOPeratype="N") {s levelCode="0",levelDesc="手术"}
	}
	
	s levelDesc = $ZCONVERT(levelDesc,"O","UTF8")
	d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""BindCode"":"""_levelCode_""",""BindDesc"":"""_levelDesc_""",""BindRowID"":"""_levelRowid_"""}}]}")
	//s ^TMPcache("123")=ItemCode_"^"_levelCode_"^"_levelDesc_"^"_levelRowid
	d argOutData.Write("NONE")
}

/// Desc:       根据类型与是否主要判断是否合规 ---类型为“手术”，只能有一个主要手术。类型为“诊断”和“治疗”，只能有一个主要操作。
/// Creator:    
/// CreateDate: 
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetOperationMainCount(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s count1="",limint1="",count2="",limint2="",ret="",ItemCode=""
	s Ismain(1) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code1"),"I","UTF8")
	s Ismain(2) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code2"),"I","UTF8")
	s Ismain(3) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code3"),"I","UTF8")
	s Ismain(4) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code4"),"I","UTF8")
	s Ismain(5) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code5"),"I","UTF8")
	
	s type(1) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key1"),"I","UTF8")
	s type(2) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key2"),"I","UTF8")
	s type(3) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key3"),"I","UTF8")
	s type(4) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key4"),"I","UTF8")
	s type(5) = $ZCONVERT(argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key5"),"I","UTF8")

	for i=1:1:5
	{
		if type(i)="手术"
		{
			s count1=count1+1
			if Ismain(i)="是"
			{
				s limint1=limint1+1
			}
		}
		elseif ((type(i)="治疗性操作")||(type(i)="诊断性操作"))
		{
			s count2=count2+1
			if Ismain(i)="是"
			{
				s limint2=limint2+1
			}
			
		}
	}
	if ((limint1>1)||(limint2>1)){ s ret = 1}
	
	d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""ret"":"""_ret_"""}}]}")
	d argOutData.Write("NONE")
}

/// Desc:       lua脚本执行
/// Creator:    
/// CreateDate: 
/// Input:      argArray 传入参数   
///             argInData 传入数据
///             argOutMessage 返回参数
///             argOutData 返回数据 ,就诊时间,格式为2016-11-11 11:11:11
ClassMethod GetTypeAdmDateTime(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	
	s EpisodeID=""
	s result = "",ret="",ItemCode=""
	s EpisodeID = argArray.GetAt("params").GetAt("queryparams").GetAt("EpisodeID")
	s result = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID,"")
	s ret = $zd($p($g(result),",",1),3)_" "_$zt($p($g(result),",",2),1)
	s ret = $ZCONVERT(ret,"O","UTF8")
	d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""ret"":"""_ret_"""}}]}")
	d argOutData.Write("NONE")
}

/// 根据质控医师签名，带出签名时间
ClassMethod GetSignDateTime(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    
    // 取lua脚本中传递进来的参数“区县描述^城市描述”
    s ADefaultConditionValue = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key1")
    // 备用参数便于理解代码，可以不用
    s ItemCode = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code")
    // 对参数进行编码转换(解决从lua传参到M语言中的乱码问题)
    s ADefaultConditionValue = $ZCONVERT(ADefaultConditionValue,"I","UTF8")
    s ItemCode = $ZCONVERT(ItemCode,"I","UTF8")
    
    s DictDesc = ""
    //if (ADefaultConditionValue'="")
    //{
        //当前日期时间
	 	s CurDate="",CurTime="",CurDatetime=""
	 	s CurDate=$zd($p($h,",",1),3)
	 	//s CurTime=$zt($p($h,",",2),2)
	 	s DictDesc=CurDate_" "_CurTime
    //}
    //s DictDesc="2020-07-14"
    // 解决因中文而导致objResultItems:getSize()为空，前台不处理数据的问题
    s DictDesc = $ZCONVERT(DictDesc,"O","UTF8")
    d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""BindDesc"":"""_DictDesc_"""}}]}")
    d argOutData.Write("NONE")
}

/// Desc:        根据“区县^城市” 查找对应的邮政编码（优先根据区县名称去匹配相应的邮政编码，如果取不到就找其上级——城市名称对应的邮政编码）
/// Creator:    wep
/// CreateDate: 2019-5-11
/// Input:    argArray    命令参数
///             实际数据处理时的入参：ADefaultConditionValue
/// OutPut:    argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod GetZipCode(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    
    // 取lua脚本中传递进来的参数“区县描述^城市描述”
    s ADefaultConditionValue = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("key1")
    // 备用参数便于理解代码，可以不用
    s ItemCode = argArray.GetAt("params").GetAt("queryparams").GetAt("items").GetAt(1).GetAt("code")
    // 对参数进行编码转换(解决从lua传参到M语言中的乱码问题)
    s ADefaultConditionValue = $ZCONVERT(ADefaultConditionValue,"I","UTF8")
    s ItemCode = $ZCONVERT(ItemCode,"I","UTF8")
    
    // 初始化 数据若处理的是字符类型的数据，则只需对DictDesc赋值即可，DictRowID、DictCode为空即可
    // 字典数据的RowID
    s DictRowID = ""
    // 字典数据的Code
    s DictCode = ""
    // 字典数据的Desc
    s DictDesc = ""
    
    s CTZipRowID = ""
    if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0))&&(ADefaultConditionValue'=$c(94)))
    {
        // 区县名称
        s CityAreaDesc = $P(ADefaultConditionValue,"^",1)
        s CityAreaDesc = ..HZToPin(CityAreaDesc)_CityAreaDesc
        
        // 城市名称
        s CityDesc = $P(ADefaultConditionValue,"^",2)
        s CityDesc = ..HZToPin(CityDesc)_CityDesc
        
        // 根据“区县名称”查找对应的邮政编码
        s:(CityAreaDesc'="") CTZipRowID = $o(^CT("ZIP",0,"CityAreaDesc",CityAreaDesc,""))
        s:(CTZipRowID '="") DictDesc = $P($g(^CT("ZIP",CTZipRowID)),"^",1)
        s CTZipRowID = ""    // 进行第一次查询后 将CTZipRowID 初始化，不影响二度查询
        if (DictDesc="")
        {
            // 根据“城市名称”查找对应的邮政编码
            s:(CityDesc'="") CTZipRowID = $o(^CT("ZIP",0,"CityDesc",CityDesc,""))
            s:(CTZipRowID '="") DictDesc = $P($g(^CT("ZIP",CTZipRowID)),"^",1)
        }
    }
    
    // 解决因中文而导致objResultItems:getSize()为空，前台不处理数据的问题
    s DictRowID = $ZCONVERT(DictRowID,"O","UTF8")
    s DictCode = $ZCONVERT(DictCode,"O","UTF8")
    s DictDesc = $ZCONVERT(DictDesc,"O","UTF8")
    d argOutMessage.Write("{""params"":{""result"": ""OK""},""items"":[{""Code"":"""_ItemCode_""",""Values"":{""BindCode"":"""_DictCode_""",""BindDesc"":"""_DictDesc_""",""BindRowID"":"""_DictRowID_"""}}]}")
    d argOutData.Write("NONE")
}

/// 汉字转换拼音的函数
/// w ##class(EMRservice.BL.BLLuaScriptService).HZToPin("孙毅")
ClassMethod HZToPin(HZ As %String) As %String
{
    s Pin=""
    s count=$l(HZ)
    for i=1:1:count d
    .s perHZ=$e(HZ,i)
    .s perPin=$E($g(^RISHZPYK(perHZ)),1,1)
    .s Pin=Pin_perPin
    .s Pin=$ZCONVERT(Pin,"U")
    q Pin
}

}
