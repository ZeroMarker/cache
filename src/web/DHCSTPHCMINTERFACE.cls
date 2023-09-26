Import SQLUser

/// Descript:  知识库与电子病历接口表
/// 
/// 电子病历取字典表内容接口
/// D ##Class(web.DHCSTPHCMINTERFACE).GetTypeDicContent()
/// 
/// 电子病历调用保存病历内容接口
/// D ##Class(web.DHCSTPHCMINTERFACE).InsPhPatBaseCont()
/// 
Class web.DHCSTPHCMINTERFACE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   取字典表内容
/// InPut:      argInMessage - [{"type":"A"}]
/// OutPut:     [{"ID":字典ID,"Code":字典代码,"Desc":字典描述},{"ID":字典ID,"Code":字典代码,"Desc":字典描述}]
/// w ##Class(web.DHCSTPHCMINTERFACE).GetTypeDicContent("")
ClassMethod GetTypeDicContent(argInMessage As %GlobalBinaryStream) As %GlobalBinaryStream
{
	//定义错误处理函数
	//s $zt="DicConErrMsg"
	//解析json参数      
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s OutBinStream=##Class(%GlobalBinaryStream).%New()
	d OutBinStream.Write("[")
	s total=array.Count()
	for i=1:1:total
	{
		 s strType = array.GetAt(i).GetAt("type")
		 /// 类型
		 if (strType = "A")
		 {
			 /// 病症字典表
			 d ..GetPatDisDic(OutBinStream)
		 }
		 elseif (strType = "B")       
		 {
			 /// 既往史字典表And关键字表
		 	 d ..GetPatDisHis(OutBinStream)
		 }
		 elseif (strType = "C")       
		 {
			 /// 手术表
		 	 d ..GetDisKeyWord(1,OutBinStream)
		 }
		 elseif (strType = "D")       
		 {
			 /// 症状表
		 	 d ..GetDisKeyWord(0,OutBinStream)
		 }
	}
	d OutBinStream.Write("]")
	Q OutBinStream
DicConErrMsg
	Q ..GetInsResStream("-99",$zerror)
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   病症字典表
/// OutPut:     病症字典表json数据
/// w ##Class(web.DHCSTPHCMINTERFACE).GetPatDisDic("")
ClassMethod GetPatDisDic(ByRef OutStream As %GlobalBinaryStream) As %String
{
	n (OutStream)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select PHDISL_RowId as DicID, PHDISL_DiseaCode as DicCode, PHDISL_DiseaDesc as DicDesc from DHC_PHDiseaseList"
    d result.Prepare(sqlStr)
    d result.Execute()
	s count = 0
	//d OutStream.Write("[")
	While(result.Next())
	{	
		s ID = result.Data("DicID")
		s Code = result.Data("DicCode")
		s Desc = result.Data("DicDesc")
		s tmp=ID_"^"_Code_"^"_Desc
		s count = count+1
		I count=1 d
		.s ListData=##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
		e  d
		.s ListData=","_##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
		d OutStream.Write(ListData)
	}
	//d OutStream.Write("]")
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2017-05-02
/// Descript:   既往史字典表
/// OutPut:     既往史字典表json数据
/// w ##Class(web.DHCSTPHCMINTERFACE).GetPatDisHis("")
ClassMethod GetPatDisHis(ByRef OutStream As %GlobalBinaryStream) As %String
{
	n (OutStream)
	s count = 0
	s result = ##class(%Library.ResultSet).%New()
	s ID=""
	F  s ID=$o(^DHCDISHISF(ID)) Q:ID=""  D
	.s Code=$p(^DHCDISHISF(ID),"^",1)
	.s Desc=$p(^DHCDISHISF(ID),"^",2)
	.Q:$p(^DHCDISHISF(ID),"^",4)'="Y"
	.s tmp=ID_"^"_Code_"^"_Desc
	.s count = count+1
	.I count=1 d
	..s ListData=##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
	.e  d
	..s ListData=","_##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
	.d OutStream.Write(ListData)
	.s keyWordI=""	/// 关键字
	.F  s keyWordI=$o(^DHCDISHISKi(0,"Key",ID,keyWordI)) Q:keyWordI=""  D
	..s keyID=""
	..F  s keyID=$o(^DHCDISHISKi(0,"Key",ID,keyWordI,keyID)) Q:keyID=""  D
	...s keyWord=$p(^DHCDISHISK(keyID),"^",2)
	...s tmp=ID_"^"_keyWord_"^"_keyWord
	...s ListData=","_##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
	...d OutStream.Write(ListData)
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   知识库关键字表
/// OutPut:     知识库关键字表json数据
/// w ##Class(web.DHCSTPHCMINTERFACE).GetDisKeyWord("")
ClassMethod GetDisKeyWord(TypeFlag As %String, ByRef OutStream As %GlobalBinaryStream) As %String
{
	n (TypeFlag, OutStream)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select PHKW_RowId, PHKW_Code, PHKW_Desc from DHC_PHKeyWord"
	s sqlStr=sqlStr_" where PHKW_TypeFlag="_TypeFlag_" and PHKW_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
    d result.Execute()
	s count = 0
	//d OutStream.Write("[")
	While(result.Next())
	{	
		s ID = result.Data("PHKW_RowId")
		s Code = result.Data("PHKW_Code")
		s Desc = result.Data("PHKW_Desc")
		s tmp=ID_"^"_Code_"^"_Desc
		s count = count+1
		I count=1 d
		.s ListData=##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
		e  d
		.s ListData=","_##Class(web.DHCSTPHCMCOMMON).getJsonData("ID^Code^Desc",tmp)
		d OutStream.Write(ListData)
	}
	//d OutStream.Write("]")
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   病人数据中心表
/// Table:      DHC_PHLibDataPooL
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCSTPHCMINTERFACE).InsPatDicPool("")
ClassMethod InsPatDicPool(argArray As %ArrayOfDataTypes) As %String
{
	n (argArray)
	s EpisodeID = argArray.GetAt("ADM") 	/// 就诊ID
	s InsType = argArray.GetAt("Type")	    /// 类型
	s KeyWord = argArray.GetAt("KeyWord")   /// 关键字KeyWord
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)  /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	 /// 病人登记号
	s ItemCode=""
	s ItemVal=""
	s KeyWord=..GetKnBasDicKey(InsType,KeyWord)
	s CreateDate=+$H
	s CreateTime=$p($H,",",2)
	&SQL(insert into DHC_PHLibDataPooL(PHLDP_Date,PHLDP_Time,PHLDP_PatId,PHLDP_Adm,PHLDP_ItemCode,PHLDP_Val,PHLDP_Type,PHLDP_KeyWord)
		values(:CreateDate,:CreateTime,:PatNo,:EpisodeID,:ItemCode,:ItemVal,:InsType,:KeyWord))
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   取知识库字典表ID
/// w ##Class(web.DHCSTPHCMINTERFACE).GetKnBasDicKey("")
ClassMethod GetKnBasDicKey(InsType As %String, KeyWord As %String) As %String
{
	n (InsType, KeyWord)
	s KeyWordID=""
	if (InsType = "A")
	{
		/// 病症字典表
		s KeyWordID=..GetPatDisDicID(KeyWord)
	}
	elseif (InsType = "B")       
	{
		/// 既往史字典表
		s KeyWordID=..GetPatDisHisID(KeyWord)
	}
	elseif (InsType = "C")       
	{
		/// 手术字典表
		s KeyWordID=..GetPatDisKeyWordID(1,KeyWord)
	}
	elseif (InsType = "D")       
	{
		/// 症状字典表
		s KeyWordID=..GetPatDisKeyWordID(0,KeyWord)
	}
	Q KeyWordID
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   知识库关键字典表
/// Table:      DHC_PHDiseaseList
/// w ##Class(web.DHCSTPHCMINTERFACE).GetPatDisKeyWordID(1,"失眠")
ClassMethod GetPatDisKeyWordID(TypeFlag As %String, KeyWord As %String) As %String
{
	n (TypeFlag, KeyWord)
	s ID=$o(^DHCPHKWi(0,"Desc",TypeFlag,$$ALPHAUP^SSUTIL4(KeyWord),""))
	Q ID
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   病症字典表
/// Table:      DHC_PHDiseaseList
/// w ##Class(web.DHCSTPHCMINTERFACE).GetPatDisDicID("心源性哮喘")
ClassMethod GetPatDisDicID(KeyWord As %String) As %String
{
	n (KeyWord)
	s ID=$o(^DHCPHDISL(0,"Desc",$$ALPHAUP^SSUTIL4(KeyWord),""))
	Q ID
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   既往史字典表
/// Table:      DHC_DisHistoryFeild
/// w ##Class(web.DHCSTPHCMINTERFACE).GetPatDisDicID("心源性哮喘")
ClassMethod GetPatDisHisID(KeyWord As %String) As %String
{
	n (KeyWord)
	s ID=$o(^DHCDISHISFi(0,"Desc",$$ALPHAUP^SSUTIL4(KeyWord),""))
	Q:ID'="" ID
	s ID=$o(^DHCDISHISKi(0,"KEYDHDR",$$ALPHAUP^SSUTIL4(KeyWord),""))
	Q ID
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   插入病人病情相关内容
/// InPut:      argInData - [{ADM:就诊ID,Type:类型,KeyWord:关键字内容},{ADM:就诊ID,Type:类型,KeyWord:关键字内容}]
/// OutPut:     ErrCode-99失败，0-成功 [{"ErrCode":0,"ErrMsg":""}]
/// w ##Class(web.DHCSTPHCMINTERFACE).InsPhPatBaseCont("")
ClassMethod InsPhPatBaseCont(argInData As %GlobalBinaryStream) As %GlobalBinaryStream
{
	//定义错误处理函数
	s $zt="PatConErrMsg"
	//解析json参数
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInData)
	s total=array.Count()
	s Err=0
	TS
	for i=1:1:total
	{
		 /// 病症字典表
		 s Err=..InsPatDicPool(array.GetAt(i))
	}
	i Err'=0 Tro
	Q:Err'=0 ..GetInsResStream(Err,"Failure")
	TC
	Q ..GetInsResStream(0,"Success")
PatConErrMsg
	Tro
	Q ..GetInsResStream("-99",$zerror)
}

/// Descript:  取结果数据流
ClassMethod GetInsResStream(ErrCode As %String, ErrMsg As %String) As %GlobalBinaryStream
{
	n (ErrCode, ErrMsg)
	s OutBinStream=##Class(%GlobalBinaryStream).%New()
	d OutBinStream.Write(..GetJsonErrCode(ErrCode, ErrMsg))
	Q OutBinStream
}

/// Descript:返回错误Json串符
/// w ##Class(web.DHCSTPHCMINTERFACE).GetJsonErrCode("")
ClassMethod GetJsonErrCode(ErrCode As %String, ErrMsg As %String) As %String
{
	n (ErrCode, ErrMsg)
	s del=""""
	q "[{"_del_"ErrCode"_del_":"_ErrCode_","_del_"ErrMsg"_del_":"_ErrMsg_"}]"
}

/// Creator:    bianshuai
/// CreateDate: 2017-03-27
/// Descript:   测试方法
/// debugger:  d ##Class(web.DHCSTPHCMINTERFACE).test()
ClassMethod test()
{
	/// 插入数据
	s argInData =##class(%FileCharacterStream).%New()
	s argInData.Filename = "d:\33.txt"
	B ///mmm
	s argOutData=..InsPhPatBaseCont(argInData)

	/// 取字典表数据
	//s argInData =##class(%FileCharacterStream).%New()
	//s argInData.Filename = "d:\22.txt"
	//s argOutData =##class(%GlobalBinaryStream).%New()
	//s argOutData=..GetTypeDicContent(argInData)
	B ///aaa
	//d argOutData.OutputToDevice()
	s AStream=##Class(%FileCharacterStream).%New()
	s AStream.Filename="D:\666.txt"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	Q ""
}

/// 检验结果辅助诊断
/// Creator:qunianpeng
/// CreateDate:2017-03-31
/// Input:adm,检验项目通用名code,检验项目标准码,标本,检查结果(用$c(2)分割，第一个是结果，第二个是异常值)
/// return:Lib检验结果
/// other:
/// w ##class(web.DHCSTPHCMINTERFACE).GetLibHelpDisInfo(adm,检验项目通用名code,检验项目标准码,标本代码,检查结果(用$c(2)分割，第一个是结果，第二个是异常值))
ClassMethod GetLibHelpDisInfo(adm, libHisCode, genextHisCode, pointerHisCode, lisResult) As %String
{
	n (adm, libHisCode, genextHisCode, pointerHisCode,lisResult)
	s rtnMsg=""
	s rtnMsg=##class(web.DHCSTPHCMPASS).GetLibHelpDisInfo(adm, libHisCode, genextHisCode, pointerHisCode,lisResult)
	q rtnMsg
}

}
