/// 字符串处理公共类
Class CIS.AN.COM.String Extends %RegisteredObject
{

ClassMethod GetDescBySplitChar(originalDesc As %String, splitChar As %String, locIndex As %Integer) As %String [ SqlProc ]
{
	Set result=originalDesc
	Set descCount=$LENGTH(originalDesc,splitChar)
	If (descCount>=locIndex)
	{
		Set result=$PIECE(originalDesc,splitChar,locIndex)
	}	
	Quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	根据ID获取名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.COM.String).GetDescByID("User.SSGroup","SSGRPDesc","1")
ClassMethod GetDescByID(className As %String, descProperty As %String, rowId As %Integer, original As %String = "N", defaultValue As %String = "") As %String [ SqlProc ]
{
	Set $ZTRAP="Error",result=""
	If (##class(%ClassDefinition).%ExistsId(className))
	{
		If ($CLASSMETHOD(className,"%ExistsId",rowId))
		{
			Set instance=$CLASSMETHOD(className,"%OpenId",rowId)
			Set result=$PROPERTY(instance,descProperty)
			//Set result=..GetTransDesc(className,descProperty,result) //多语言改造翻译后台数据 YL 20221027
			//Set result="rtn=##class("_className_")."_GetTranByDesc_"("_descProperty_","_result_","_langid_")"
		}	
	}
	Quit:(original="Y")&(result="") rowId
	Quit:(original="N")&(result="") defaultValue
	Quit result
Error
	Set $ZTRAP=""
	Quit "E^"_$ZERROR
}

/// Creator：      	陈长青
/// CreatDate：    	2016-12-29
/// Description： 	根据ID获取名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.COM.String).GetDescByIDStr("DHCAN.OperStatus","Description","1,2,3,4",",")
ClassMethod GetDescByIDStr(className As %String, descProperty As %String, rowIdStr As %Integer, splitChar As %String = ",", original As %String = "N") As %String [ SqlProc ]
{
	Set $ZTRAP="Error",result=""
	If (##class(%ClassDefinition).%ExistsId(className))
	{
		Set rowIdCount=$LENGTH(rowIdStr,splitChar)
		For i=1:1:rowIdCount
		{
			Set rowId=$PIECE(rowIdStr,splitChar,i)
			Set:(i>1) result=result_splitChar
			If ($CLASSMETHOD(className,"%ExistsId",rowId))
			{
				Set instance=$CLASSMETHOD(className,"%OpenId",rowId)
				Set propValue=$PROPERTY(instance,descProperty)
				Set:(propValue="")&(original="Y") propValue=rowId	
				Set result=result_propValue
			}		
		}
		
	}
	Quit result
Error
	Set $ZTRAP=""
	Quit "E^"_$ZERROR
}

ClassMethod ToArray(data As %String, ByRef array As %String) As %Status
{
	Set result=$$$OK
	Set objSplitChar=$CHAR(2),propertySplitChar=$CHAR(1),valueSplitChar=$CHAR(0)
	Set objCount=$LENGTH(data,objSplitChar)
		For objIndex=1:1:objCount
		{
			Set objectString=$PIECE(data,objSplitChar,objIndex)
			Set propertyCount=$LENGTH(objectString,propertySplitChar)
			For propertyIndex=1:1:propertyCount
			{
				Set propertyString=$PIECE(objectString,propertySplitChar,propertyIndex)
				Set propertyName=$PIECE(propertyString,valueSplitChar,1)
				Set propertyValue=$PIECE(propertyString,valueSplitChar,2)
				Set array(objIndex,propertyName)=propertyValue	
			}
		}	
	
	Quit result
}

ClassMethod ToJson(data As %String) As %String
{
	Set node="",result="",objIndex=""
	For
	{
		Set objIndex=$ORDER(data(objIndex))
		Quit:(objIndex="")
		Set node="",singleResult=""
		For
		{
			Set node=$ORDER(data(objIndex,node))
			Quit:(node="")
			Set dataType=$GET(data(objIndex,node,"Type"))
			Set:(singleResult'="") singleResult=singleResult_","
			If (dataType="JSON")
			{
				Set singleResult=singleResult_""""_node_""""_":"_data(objIndex,node)	
			}
			Else
			{
				Set singleResult=singleResult_""""_node_""""_":"_""""_data(objIndex,node)_""""	
			}
					
		}
		Set singleResult="{"_singleResult_"}"
		Set:(result'="") result=result_","
		Set result=result_singleResult
	}
	Set result="["_result_"]"
	Quit result
}

ClassMethod ToJsonCopy(data As %String) As %String
{
	Set node="",result="",objIndex=""
	For
	{
		Set objIndex=$ORDER(data(objIndex))
		Quit:(objIndex="")
		Set node="",singleResult=""
		For
		{
			Set node=$ORDER(data(objIndex,node))
			Quit:(node="")
			Set dataType=$GET(data(objIndex,node,"Type"))
			Set:(singleResult'="") singleResult=singleResult_","
			If (dataType="JSON")
			{
				Set singleResult=singleResult_""""_node_""""_":"_data(objIndex,node)	
			}
			Else
			{
				Set singleResult=singleResult_""""_node_""""_":"_""""_data(objIndex,node)_""""	
			}
					
		}
		Set singleResult="{"_singleResult_"}"
		Set:(result'="") result=result_","
		Set result=result_singleResult
	}
	Break //ccq3
	Set result="["_result_"]"
	Quit result
}

ClassMethod ObjectToJSON(data As CIS.AN.COM.DataObject) As %String
{
	Set result=""
	For i=1:1:data.KeyValuePairs.Size
	{
		Set kvPair=data.KeyValuePairs.GetAt(i)
		Set:(result'="") result=result_","
		Set result=result_""""_kvPair.Key_""""_":"_""""_kvPair.Value_""""	
	}	
	Set result="{"_result_"}"
	Quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-10
/// Description： 	返回不为空的字段值
/// Table：        	
/// Input:			
/// Return：       	String
/// d ##class(%ResultSet).RunQuery("CIS.AN.COM.String","AlterDesc")
ClassMethod AlterDesc(desc1, desc2) As %String [ SqlProc ]
{
	If desc1'="" Quit desc1
	
	Quit desc2
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-10
/// Description： 	返回不为空的字段值
/// Table：        	
/// Input:			
/// Return：       	String
/// d ##class(%ResultSet).RunQuery("CIS.AN.COM.String","PatchFloat")
ClassMethod PatchFloat(value) As %String [ SqlProc ]
{
	If (value<1) && (value>0) Quit "0"_value
	
	Quit value
}

/// Creator：      	陈长青
/// CreatDate：    	2019-1-7
/// Description： 	将query结果转换成json字符串
/// Table：        	
/// Input:			className:query所在类的类名，queryName:query名称，args:执行query的参数
/// Return：       	String
/// w ##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.OEOrder","FindDoseEquiv","1257||1")
ClassMethod QueryToJSON(className, queryName, args...) As %String
{
	Set rsetParam=className_":"_queryName
	Set rset=##class(%ResultSet).%New(rsetParam)
	Set argCnt=+$GET(args)
	If (argCnt=0)
	{
		Set sc=rset.Execute()	
	}
	Else
	{
		Set sc=rset.Execute(args...)	
	}
	Set colCount=rset.GetColumnCount()
	Set ret=""
	While(rset.%Next())
	{
		Set:(ret'="") ret=ret_","
		Set ret=ret_"{"
		For colIndex=1:1:colCount
		{
			Set colName=rset.GetColumnName(colIndex)
			Set colValue=rset.Get(colName)
			Set colValue=$REPLACE(colValue,"\","\\")
			Set colValue=$REPLACE(colValue,$CHAR(10),"\n")
			Set colValue=$REPLACE(colValue,$CHAR(0),"")
			Set colValue=$REPLACE(colValue,"""","\""")
			Set:(colIndex>1) ret=ret_","
			Set ret=ret_""""_colName_""":"_""""_colValue_""""	
		}	
		Set ret=ret_"}"
	}
	Set ret="["_ret_"]"
	Quit ret
}

ClassMethod QueryToArray(ByRef array As %String, className As %String, queryName As %String, args...) As %String
{
	Set rsetParam=className_":"_queryName
	Set rset=##class(%ResultSet).%New(rsetParam)
	Set argCnt=+$GET(args)
	If (argCnt=0)
	{
		Set sc=rset.Execute()	
	}
	Else
	{
		Set sc=rset.Execute(args...)	
	}
	
	Set colCount=rset.GetColumnCount()
	Set ret="",rowIndex=1
	While(rset.%Next())
	{
		Set:(ret'="") ret=ret_","
		Set ret=ret_"{"
		For colIndex=1:1:colCount
		{
			Set colName=rset.GetColumnName(colIndex)
			Set colValue=rset.Get(colName)
			Set array(rowIndex,colName)=colValue
		}
		Set rowIndex=rowIndex+1
	}
	Quit ""
}

ClassMethod StreamToString(dataStream As %Library.GlobalStreamAdaptor) As %String
{
	Do dataStream.Rewind()
	Set ret=""
	While(dataStream.AtEnd=0)
	{
		Set len=100
		Set ret=ret_dataStream.Read(.len)	
	}	
	Quit ret
}

/// w ##class(CIS.AN.COM.String).GetDescBySQL("SQLUser.RB_Resource","RES_CTPCP_DR->CTPCP_OtherName","4495")
ClassMethod GetDescBySQL(tableName As %String, fieldName As %String, rowId As %String) As %String [ SqlProc ]
{
	Set result=""
	Set sql="select "_fieldName_" as result from "_tableName_" where %ID="_rowId
	Set tStatement=##class(%SQL.Statement).%New()
	Set tStatus=tStatement.%Prepare(sql)
	Set rs=tStatement.%Execute()
	While(rs.%Next())
	{
		Set result=rs.result
	}
	
	Quit result
}

ClassMethod GetRowIdByExt(tableName As %String, extId As %String) As %String [ SqlProc ]
{
	Set result=""
	Set sql="select %ID as result from "_tableName_" where ExternalID="_"'"_extId_"'"
	Set tStatement=##class(%SQL.Statement).%New()
	Set tStatus=tStatement.%Prepare(sql)
	Set rs=tStatement.%Execute()
	While(rs.%Next())
	{
		Set result=rs.result
	}
	
	Quit result
}

ClassMethod GetRowIdStrByExt(tableName As %String, extIdStr As %String, splitChar As %String = ",") As %String [ SqlProc ]
{
	Set extIdCount=$PIECE(extIdStr,splitChar),result=""
	For i=1:1:extIdCount
	{
		Set extId=$PIECE(extIdStr,splitChar,i)
		Set curResult=..GetRowIdByExt(tableName,extId)
		Set:(result'="") result=result_splitChar
		Set result=result_curResult 
	}
	
	Quit result
}

ClassMethod GetRemark() As %String
{
	Set desc=$$FindDesc^%occName("CIS.AN.OperSchedule",$$$cCLASSproperty,"EpisodeID")
	Quit desc
}

/// Unicode字符串转为中文字符串
/// w ##class(CIS.AN.COM.String).Unicode2Chinese("\u8bf7\u6c42\u8d85\u65f6")
ClassMethod Unicode2Chinese(codeStr As %String) As %String
{
	Set splitChar="\u"
	Set letterCount=$LENGTH(codeStr,splitChar)
	Set ret=""
	For i=1:1:letterCount
	{
		Set letter=$PIECE(codeStr,splitChar,i)
		Continue:(letter="")
		Set decimal=$ZHEX(letter)
		Set chinese=$CHAR(decimal)
		Set ret=ret_chinese	
	}	
	Quit ret
}

/// w ##class(CIS.AN.COM.String).GetTransDesc("CT.AN.OperStatus","Description","申请")
ClassMethod GetTransDesc(className As %String, propName As %String, propValue As %String) As %String [ SqlProc ]
{
	Set methodName="GetTranByDesc"
	Set lang="20",sessionLang=""
	Set:($DATA(%session)) sessionLang=$GET(%session.Data(1,"LOGON.LANGID"))
	Set:(sessionLang'="") lang=sessionLang
	Set ret=$CLASSMETHOD(className,methodName,propName,propValue,lang)
	Quit ret
}

/// Creator：      	元琳
/// CreatDate：    	2020-12-25
/// Description： 	根据DEMO配置转换日期格式
ClassMethod ParseDateFormat(date As %String) As %String [ SqlProc ]
{
	Quit:date="" ""
	Set dateFormat=##class(web.DHCClinicCom).GetDateFormat()
	If (dateFormat="j/n/Y") Set date=$ZDATE(date,4)
	Else  Set date=$ZDATE(date,3)
	Quit date
}

/// w ##class(CIS.AN.COM.String).AESEncrypt("SYS")
ClassMethod AESEncrypt(plainText As %String) As %String
{
  Set key="a9b1c0d8e2f5g3m7"
	Set text=$ZCONVERT(plainText,"O","UTF8")
  Set encryptStr=##class(%SYSTEM.Encryption).AESCBCEncrypt(plainText,key)
	Set ciphertext=$SYSTEM.Encryption.Base64Encode(encryptStr)
  Quit ciphertext
}

/// w ##class(CIS.AN.COM.String).AESDecrypt("")
ClassMethod AESDecrypt(encryptStr As %String) As %String
{
  Set key="a9b1c0d8e2f5g3m7"
	Set text=$SYSTEM.Encryption.Base64Decode(encryptStr)
  Set decryptStr=##class(%SYSTEM.Encryption).AESCBCDecrypt(text,key)
	Set plaintext=$ZCONVERT(decryptStr,"I","UTF8")
  Quit plaintext
}

ClassMethod QueryToJSONWithOrderField(className, queryName, orderFieldName, args...) As %String
{
	Set rsetParam=className_":"_queryName
	Set rset=##class(%ResultSet).%New(rsetParam)
	Set argCnt=+$GET(args)
	If (argCnt=0)
	{
		Set sc=rset.Execute()	
	}
	Else
	{
		Set sc=rset.Execute(args...)	
	}
	
	Set colCount=rset.GetColumnCount()
	Set ret=""
	Set list=[]
	Set index=1
	While(rset.%Next())
	{
		Set:(ret'="") ret=ret_","
		set obj={}
		set seqNo=0
		For colIndex=1:1:colCount
		{
			Set colName=rset.GetColumnName(colIndex)
			
			Set colValue=rset.Get(colName)
			
			Set colValue=$REPLACE(colValue,"\","\\")
			Set colValue=$REPLACE(colValue,$CHAR(10),"\n")
			Set colValue=$REPLACE(colValue,$CHAR(0),"")
			Set colValue=$REPLACE(colValue,"""","\""")
			Set:(colIndex>1) ret=ret_","

            do obj.%Set(colName,colValue)
            if (colName=orderFieldName)
            {
	            set seqNo=+colValue
            }
		}	
		//do list.%Push(obj)
		set Array(seqNo,index)=obj
		set index=index+1
	}
	set seqNo=""
	for
	{
		set seqNo=$O(Array(seqNo))
		quit:seqNo=""
		set index=""
		for
		{
			set index=$O(Array(seqNo,index))
			quit:index=""
			set obj=Array(seqNo,index)
			do list.%Push(obj)
		}
	}
	
	Quit list.%ToJSON()
}

/// Creator：      	元琳
/// CreatDate：    	2023-01-13
/// Description： 	通过Id获取描述并按照HIS基础数据中维护的翻译显示字段名称
/// Table：        	
/// Input:			className:实体类名称，descProperty:名称(描述)字段名，rowId:对象ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.COM.String).GetTranslationByBDP("CF.AN.Location","Description",1)
ClassMethod GetTranslationByBDP(className As %String, descProperty As %String, rowId As %String) As %String [ SqlProc ]
{
    Set $ZTRAP="Error",result=""
	If (##class(%ClassDefinition).%ExistsId(className))
	{
		If ($CLASSMETHOD(className,"%ExistsId",rowId))
		{
			Set instance=$CLASSMETHOD(className,"%OpenId",rowId)
			Set result=$PROPERTY(instance,descProperty)
			Set result=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(className,descProperty,"",result)
		}
		else
		{
			Set result=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc(className,descProperty,"",rowId)
		}	
	}
	Quit:(result="") rowId
	Quit result
Error
	Set $ZTRAP=""
	Quit "E^"_$ZERROR
}

}
