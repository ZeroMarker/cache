/// 名称:	EMR.DOC.BL.EMRTSchemeType
/// 描述:	展现方案表 业务类
/// 编写者：Ningyanghong
/// 编写日期: 2021-9-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTScheme Extends EMR.DOC.COM.ActionBase
{

/// 初始化
/// Debug:d ##Class(EMR.DOC.BL.EMRTScheme).InitData()
ClassMethod InitData()
{
	d ##Class(EMR.DOC.BL.EMRTScheme).AddData("YS01","住院方案",1,1)
	d ##Class(EMR.DOC.BL.EMRTScheme).AddData("YS01","门急诊在院方案",2,2)
	d ##Class(EMR.DOC.BL.EMRTScheme).AddData("YS01","病历归档方案",3,3)
}

ClassMethod AddData(user As %String, name As %String, shecmeType As %String, sequence As %String)
{
	s objType=##class(CF.EMR.DOC.EMRTSchemeType).%OpenId(shecmeType)
	s obj = ##Class(CF.EMR.DOC.EMRTScheme).%New()
	s obj.SchemeType = objType
	s obj.SchemeName = name
	s obj.Sequence=$zcvt(sequence,"u")
	s obj.CreateDate = $ZDATEH($ZDATE($h))
 	s obj.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
 	s obj.CreateUserID=user
	s sc = obj.%Save()
}

/// Desc:       添加展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-09-29
/// Input:      argArray  	命令参数 
/// 									{
/// 										"action":"ADD_SCHEME_DATA",
/// 										"params":
/// 												{
/// 													schemeType："",
/// 													schemeName:"",
/// 													sequence:"" 
/// 												},
/// 										"product":"GlobalEMR"
/// 									}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod AddSchemeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = ""
	s objScheme =##class(EMR.DOC.DTO.EMRTScheme).%New()
	s objScheme.SchemeType=argInJson.params.schemeType
	s objScheme.SchemeName= argInJson.params.schemeName
	s objScheme.Sequence=argInJson.params.sequence
	s Auser=argInJson.params.userCode
	s strRes=##Class(EMR.DOC.BL.EMRTScheme).AddSchemeDataJson(objScheme,Auser)
	
	
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","方案类型不存在",2)
	}
	elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","方案类型重复",2)
	}
	
	
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-09-29
/// Input:      argArray  	命令参数 
/// 									{
/// 										"action":"DELETE_SCHEME_DATA",
/// 										"params":
/// 												{
/// 													schemeID：""
/// 												},
/// 										"product":"GlobalEMR"
/// 									}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：返回错误信息
ClassMethod DeleteSchemeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = ""
	s AID = argInJson.params.schemeID
	
	s strRes = ##Class(EMR.DOC.BL.EMRTScheme).DeleteSchemeDataJson(AID)
	
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","导航方案不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
	
Error
	Trollback
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取所有展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-10-08
/// Input:      argArray  	命令参数 {"action":"GET_SCHEME_DATA","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
///                            {
/// 									"id":"", // 方案id
/// 									"schemeName":"", // 方案名称
/// 									"sequence":"",  //排序
/// 									"createDate":"", // 创建日期
/// 									"createTime":"", // 创建时间
/// 									"createUser":"", // 创建用户
/// 									"schemeType":"", // 方案类型
///                            }
ClassMethod GetSchemeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s jArrScheme = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.EMRTScheme).GetSchemeDatasJson(jArrScheme)
	if (strRes = "1")
	{ 
		d jArrScheme.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取所有展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-10-08
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTScheme).GetSchemeDatasJson()
ClassMethod GetSchemeDatasJson(ByRef jArrScheme As %DynamicArray) As %String
{
	s strRes = "1"
	;s jsonArr = ##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTScheme:GetSchemeData")
	d result.Execute()
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.id =result.GetDataByName("ID")
     	s jsonItem.schemeName =result.GetDataByName("Name")
     	s jsonItem.sequence=result.GetDataByName("Sequence")
     	s jsonItem.createDate=$zd(result.GetDataByName("Date"),3)
     	s jsonItem.createTime=$zt(result.GetDataByName("Time"))
     	s jsonItem.createUser=result.GetDataByName("User")
     	s type=result.GetDataByName("Type")
     	s objType=##class(CF.EMR.DOC.EMRTSchemeType).%OpenId(type)
     	s jsonItem.schemeType=objType.Code
     	d jArrScheme.%Push(jsonItem)
	}					
	;d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-10-08
/// Input:      argArray  	命令参数 {"action":"ADD_SCHEME_DATA","params":{schemeType:"",schemeName:"",sequence:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod AddSchemeDataJson(AScheme As EMR.DOC.DTO.EMRTScheme, user As %String)
{
	q:(AScheme.SchemeType = "")||(AScheme.SchemeName = "")||(AScheme.Sequence="") "-100"
	
	s rowId = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_$zcvt(AScheme.SchemeType,"u"),""))
	
	q:(rowId="") "-101"
	s objType = ##class(CF.EMR.DOC.EMRTSchemeType).%OpenId(rowId)
	s count=0
	&sql(SELECT COUNT(*) into :count  FROM CF_EMR_DOC.EMRTScheme WHERE SchemeType = :rowId)
	q:(count = 1) "-102"
	s obj = ##Class(CF.EMR.DOC.EMRTScheme).%New()
	s obj.SchemeType = objType
	s obj.SchemeName = AScheme.SchemeName
	s obj.Sequence=$zcvt(AScheme.Sequence,"u")
	s obj.CreateDate = $ZDATEH($ZDATE($h))
 	s obj.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
 	s obj.CreateUserID=user
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
}

/// Desc:       修改展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-10-08
/// Input:      argArray  	命令参数 
/// 								{
/// 									"action":"UPDATE_SCHEME_DATA",
/// 									"params":
/// 											{
/// 												schemeType:"",
/// 												schemeName:"",
/// 												sequence:""
/// 											},
/// 									"product":"GlobalEMR"
/// 								}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod UpDateSchemeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
		s $zt = "Error"
	s objScheme =##class(EMR.DOC.DTO.EMRTScheme).%New()
	s objScheme.ID = argInJson.params.id
	s objScheme.SchemeType = argInJson.params.schemeType
	s objScheme.SchemeName = argInJson.params.schemeName
    s strRes = ##Class(EMR.DOC.BL.EMRTScheme).UpSchemeDataJson(objScheme)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","方案不存在",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","方案类型不存在",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","方案类型重复",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       修改展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-10-08
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.BL.EMRTScheme).UpSchemeDataJson()
ClassMethod UpSchemeDataJson(AScheme As EMR.DOC.DTO.EMRTScheme) As %String
{
	s strRes = "-200"
	q:(AScheme.SchemeName="")||(AScheme.ID="")||(AScheme.SchemeType="") strRes
	
	s strRes="-102"
	s typeId = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_$zcvt(AScheme.SchemeType,"u"),""))
	if (typeId="")
	{
		q strRes
	}
	s strRes="-301"
	s rowId = $o(^CF.EMR.DOC.EMRTSchemeI("IdxSchemeType",typeId,""))
	if (rowId'="") && (rowId '=AScheme.ID)
	{
		q strRes
	}else
	{
		s strRes = "-101"
		s objScheme = ##class(CF.EMR.DOC.EMRTScheme).%OpenId(AScheme.ID)
		q:(objScheme="") strRes
		s objType = ##class(CF.EMR.DOC.EMRTSchemeType).%OpenId(typeId)
		s objScheme.SchemeType=objType
		s objScheme.SchemeName=AScheme.SchemeName
	    s sc = objScheme.%Save()
	    s:($$$ISOK(sc)) strRes = "1"
	    q strRes
	}
}

/// Desc:       删除展现方案
/// Creator:    ningyanghong
/// CreateDate: 2021-12-06
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.BL.EMRTScheme).DeleteSchemeDataJson()
ClassMethod DeleteSchemeDataJson(ID As %String) As %String
{
	s strRes = "-200"
	q:(ID = "") strRes
	s objScheme=##class(CF.EMR.DOC.EMRTScheme).%OpenId(ID)
	q:(objScheme="") "-201"
	s strSeq=objScheme.Sequence
	
	d ##class(CF.EMR.DOC.EMRTScheme).%DeleteId(ID)
	
	s maxSeq=""
	&sql(select max(sequence) into :maxSeq from CF_EMR_DOC.EMRTScheme)
	for i=strSeq+1:1:maxSeq
	{
		s newSeq=i-1
		&SQL(update CF_EMR_DOC.EMRTScheme set Sequence =:newSeq where Sequence= :i )
	}
	q "1"
}

/// Desc:       展现方案排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-11
/// Input:      argArray  	命令参数 
/// 									{
/// 										"action":"UPDATE_SCHEME_SEQUENCE",
/// 										"params":
/// 												{
/// 													id:"",
/// 													sequence:""
/// 												},
/// 										"product":"GlobalEMR"
/// 									}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：返回错误信息
ClassMethod UpDateSchemeSeqData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART
	s objScheme =##class(EMR.DOC.DTO.EMRTScheme).%New()
	s objScheme.ID = argInJson.params.id
	s objScheme.Sequence = argInJson.params.sequence
    s strRes = ##Class(EMR.DOC.BL.EMRTScheme).UpSchemeSeqDataJson(objScheme)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","方案不存在",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	TROLLBACK
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       展现方案排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-11
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.BL.EMRTScheme).UpSchemeSeqDataJson()
ClassMethod UpSchemeSeqDataJson(AScheme As EMR.DOC.DTO.EMRTScheme) As %String
{
	s strRes = "-200"
	q:(AScheme.Sequence="")||(AScheme.ID="") strRes
	s strRes = "-101"
	s objScheme = ##class(CF.EMR.DOC.EMRTScheme).%OpenId(AScheme.ID)
	q:(objScheme="") strRes
	s oldSeq=objScheme.Sequence
	/// 前移
	if (oldSeq>AScheme.Sequence)
	{
		for i=(oldSeq-1):-1:AScheme.Sequence
		{
			s newSeq=i+1
			&SQL(update CF_EMR_DOC.EMRTScheme set Sequence =:newSeq where Sequence= :i )
		}
		
	}else
	{
		for i=(oldSeq+1):1:AScheme.Sequence
		{
			s newSeq=i-1
			&SQL(update CF_EMR_DOC.EMRTScheme set Sequence =:newSeq where Sequence= :i )
		}
	}
	s objScheme.Sequence=AScheme.Sequence
	s sc = objScheme.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
	}
	TCOMMIT
	q:($$$ISOK(sc)) "1"
}

Query GetSchemeData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Type:%String,Name:%String,User:%String,Date:%String,Time:%String,Sequence:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeData, SqlProc ]
{
	select ID,SchemeType,SchemeName,CreateUserID,CreateDate,CreateTime,Sequence from CF_EMR_DOC.EMRTScheme order by Sequence
}

}
