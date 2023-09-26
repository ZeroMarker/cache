Class web.Util.DHCLabUtilJSON Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	将一个表格类型的数据转化为JSON格式的数据
/// Table:        	无
/// Input:        	fieldKeys:字段名,dataObj:数据对象,dataType:数据对象类型，A-数组,G-Global,L-List,deli:数据字段分割符
/// Output:       	无
/// Return:       	成功:JSON数据,失败:空
/// Others:       	dataType默认为G,deli默认为^
ClassMethod ParseData(fieldKeys As %String, ByRef dataObj As %ObjectHandle, dataType As %String = "G", deli As %String = "^") As %String
{
	S jsonStr=""
	//Q:$$$NULLOREF=$g(tableDataObj) jsonStr
	
	
	
	
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	将一个表格类型的数据转化为JSON格式的数据
/// Table:        	无
/// Input:        	fieldKeys:字段名,dataObj:数据对象,deli:数据字段分割符
/// Output:       	无
/// Return:       	成功:JSON数据,失败:空
/// Others:       	dataType默认为G,deli默认为^
ClassMethod ParseGlobalData(fieldKeys As %String, ByRef dataObj As %ObjectHandle, deli As %String = "^", fieldDeli As %String = "") As %String
{
	S jsonStr=""
	Q:('$l(fieldKeys))&&($$$NULLOREF=$g(dataObj)) jsonStr
	
	//如果字段名为空，则取数据第一行为字段名
	I '$l(fieldKeys),$$$NULLOREF'=$g(dataObj) {
		S index=$O(dataObj(""))
		I $l(index) {
			S fieldKeys=$g(dataObj(index))
			}
	}
	Q:('$l(fieldKeys))&&($$$NULLOREF'=$g(dataObj)) jsonStr
	
	//如果字段不为空，而数据为空，则返回有Key而没有值的JSON字符串
	I $l(fieldKeys),$$$NULLOREF=$g(dataObj) {
		S jsonStr="{"
		F i=1:1:$l(fieldKeys,deli) {
			S fieldKey=$P(fieldKeys,deli,i)
			I $l(fieldKey) {
				S jsonStr=jsonStr_..FormatFieldKeyVal(fieldKey,"")_","
			}
		}
		
		I $E(jsonStr,$l(jsonStr))=","{
			S jsonStr=$E(jsonStr,1,$l(jsonStr)-1)
		}
		S jsonStr=jsonStr_"}"
		S:jsonStr="{}" jsonStr=""
	}
	
	Q:('$l(jsonStr))&($l(fieldKeys))&($$$NULLOREF=$g(dataObj)) jsonStr
	
	Q:$$$NULLOREF=$g(dataObj) jsonStr
	K ^TMP($zn,$j,"rows")
	//S rows=""
	//Xecute "M rows="_dataObj
	Xecute "M ^TMP($zn,$j,""rows"")="_dataObj
	//M ^DEBUG($zn,1)=^TMP($zn,$j,"rows")
	b
	S ^TMP("DEBUG",1)=dataObj
	S index=""
	S jsonStr=""
	F {
		//S index=$O(rows(index))
		S index=$O(^TMP($zn,$j,"rows",index))
		Q:index=""
		S fieldDatas=$g(^TMP($zn,$j,"rows",index))
		continue:'$l(fieldDatas)
		
		S jsonRecordStr="{"
		F i=1:1:$l(fieldDatas,deli) {
			S fieldVal=$P(fieldDatas,deli,i)
			S fieldValType=""
			I $l(fieldDeli),fieldVal[fieldDeli {
				S fieldVal=$P(fieldVal,fieldDeli,1)
				S fieldValType=$P(fieldVal,fieldDeli,2)
			}
			
			S fieldKey=$P(fieldKeys,deli,i)
			I $l(fieldKey){
				S jsonRecordStr=jsonRecordStr_..FormatFieldKeyVal(fieldKey,fieldVal,fieldValType)_","
			}
		}
		
		I $E(jsonRecordStr,$l(jsonRecordStr))=","{
			S jsonRecordStr=$E(jsonRecordStr,1,$l(jsonRecordStr)-1)
		}
		
		S jsonRecordStr=jsonRecordStr_"}"
		S:jsonRecordStr="{}" jsonRecordStr=""
		I jsonRecordStr'=""{
			S jsonStr=jsonStr_jsonRecordStr_","
		}
			
	}
	//K ^TMP($zn,$j,"rows")
	
	I $E(jsonStr,$l(jsonStr))=","{
		S jsonStr=$E(jsonStr,1,$l(jsonStr)-1)
	}
	S jsonStr=jsonStr_""
	I jsonStr="{}" {
		S jsonStr=""	
	}
	
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	将字段和值转换为JSON格式
/// Table:        	无
/// Input:        	fieldKeys:字段名,fieldVal:字段值
/// Output:       	无
/// Return:       	成功:JSON数据,失败:空
/// Others:       	对字段值true和false需要特殊处理
ClassMethod FormatFieldKeyVal(fieldKey As %String, fieldVal As %String, fieldType As %String = "", mdlFlag As %String = "") As %String
{
	S jsonStr="",spChr="'"
	Q:'$l(fieldKey) jsonStr
	S flag=""
	S:(fieldVal="true")||(fieldVal="false") spChr=""
	S:fieldType="O" spChr=""""
	S:$E(fieldVal,1)="""" spChr=""
	S:(fieldType="STORE")&(mdlFlag="R") flag="T"
	S:(fieldType="STORE")&(spChr="") flag=""""

	S jsonStr=""_fieldKey_":"_spChr_..StrToJsonStr(fieldVal,flag)_spChr
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20120425
/// Description: 	转化特殊字符
/// Table:        	无
/// Input:        	fieldKeys:字段名,fieldVal:字段值
/// Output:       	无
/// Return:       	成功:JSON数据,失败:空
/// Others:       	对字段值true和false需要特殊处理
ClassMethod StrToJsonStr(str As %String, flag As %String = "") As %String
{
	N (str,flag)
	S jsonStr=$G(str),flag=$G(flag)
	Q:'$l(str) jsonStr
	
	//替换回车换行符
	
	//S jsonStr=..Raplace(jsonStr,$C(10),"\n")  //\n
	//S jsonStr=..Raplace(jsonStr,$C(13),"\r")  //\r
	S jsonStr=..DelInvisibleChar(jsonStr,"")
	//替换单引号
	S:flag="" jsonStr=..Raplace(jsonStr,"'","\\'")
	S:flag="" jsonStr=..Raplace(jsonStr,"""","\""")
	S:flag="T" jsonStr=..Raplace(jsonStr,"'","\'")
	S:flag="T" jsonStr=..Raplace(jsonStr,"""","\""")
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20120425
/// Description: 	格式化属性数据
/// Table:        	无
/// Input:        	str:待处理数据
/// Output:       	无
/// Return:       	处理完数据
/// Others:       	无
ClassMethod StrToPropertyStr(str As %String) As %String
{
	N (str)
	S newStr=$G(str)
	Q:'$l(str) newStr
	Q newStr
	//替换所有不可见字符
	S newStr=..DelInvisibleChar(newStr,"")
	
	//替换单引号
	//S newStr=..Raplace(newStr,"'","")
	//去掉双引号
	S newStr=..Raplace(newStr,"""","")
	Q newStr
}

/// Creator:      	wwh
/// CreatDate:    	20120425
/// Description: 	格式化属性数据
/// Table:        	无
/// Input:        	str:待处理数据
/// Output:       	无
/// Return:       	处理完数据
/// Others:       	无
ClassMethod StrToValueStr(str As %String) As %String
{
	N (str)
	S newStr=$G(str)
	Q:'$l(str) newStr
	 
	//替换所有不可见字符
	S newStr=..DelInvisibleChar(newStr,"")
	
	//替换单引号
	S newStr=..Raplace(newStr,"'","\\'")
	//去掉双引号
	S newStr=..Raplace(newStr,"""","\""")
	Q newStr
}

/// Creator:      	wwh
/// CreatDate:    	20120425
/// Description: 	删除不可见字符
/// Table:        	无
/// Input:        	str:待处理数据
/// Output:       	无
/// Return:       	处理完数据
/// Others:       	无
ClassMethod DelInvisibleChar(str As %String, flag As %String = "") As %String
{
	N (str)
	S newStr=$G(str)
	Q:'$l(str) newStr
	F i=0:1:31 {
		S newStr=..Raplace(newStr,$C(i),"")	
	}
	S newStr=..Raplace(newStr,$C(127),"")
	Q newStr
}

/// Creator：		wwh
/// CreateDate：		2010-06-01
/// Description：	替换字符串
/// Table：			无
/// Input：			oStr:源字符串,fStr:查找的字符串,rStr:替换的字符串
/// Output：			无
/// Return：			ret:字符串
/// Others：			无
ClassMethod Raplace(oStr As %String, fStr As %String, rStr As %String) As %String
{
	N (oStr,fStr,rStr)
    S oStr=$g(oStr),fStr=$g(fStr),rStr=$g(rStr)
    S ret=oStr
    Q:('$l(oStr))||('$l(fStr)) ret
    Q:oStr'[fStr ret
    S tmpStr=oStr,newStr=""
    While tmpStr[fStr {
	    S newStr=newStr_$P(tmpStr,fStr,1)_rStr
		S tmpStr=$P(tmpStr,fStr,2,$l(tmpStr,fStr))   
	}
    S newStr=newStr_tmpStr
    Q newStr
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取Combo的JSON字符串
/// Table:        	无
/// Input:        	nameValueList:数据
/// Output:       	无
/// Return:       	成功:JSON数据,失败:"[]"
/// Others:       	返回字符串格式为：[{name:'testN1',value:'testV1'},{name:'testNn',value:'testVn'}]
ClassMethod GetComboJsonData(nameValueList As %String, dataDeli As %String = "^", fieldDeli As %String = "|") As %String
{
	S jsonStr="[]"
	Q:'$l(nameValueList) jsonStr
	
	S ^DEBUG($zn,$H)=nameValueList
	S jsonStr="["
	F i=1:1:$l(nameValueList,dataDeli) {
		S nameValue=$P(nameValueList,dataDeli,i)
		S name=$P(nameValue,fieldDeli,1)
		S value=$P(nameValue,fieldDeli,2)
		I $l(name) {
			S jsonStr=jsonStr_"{name:'"_..StrToJsonStr(name)_"',value:'"_..StrToJsonStr(value)_"'},"
		}
	}
	I $E(jsonStr,$l(jsonStr))="," {
		S jsonStr=$E(jsonStr,1,$l(jsonStr)-1)
	}
	S jsonStr=jsonStr_"]"
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取Checkbox的JSON字符串
/// Table:        	无
/// Input:        	labelNameValList:数据
/// Output:       	无
/// Return:       	成功:JSON数据,失败:"[]"
/// Others:       	返回字符串格式为：[{boxLabel:'testL1',name:'testN1',checked:false},{boxLabel:'testLn',name:'testNn',checked:true}]
ClassMethod GetCheckboxJsonData(labelNameValList As %String, dataDeli As %String = "^", fieldDeli As %String = "|") As %String
{
	S jsonStr="[]"
	Q:'$l(labelNameValList) jsonStr
	
	S jsonStr="["
	F i=1:1:$l(labelNameValList,dataDeli) {
		S labNameVal=$P(labelNameValList,dataDeli,i)
		S label=$P(labNameVal,fieldDeli,1)
		S name=$P(labNameVal,fieldDeli,2)
		S checked=$P(labNameVal,fieldDeli,3)
		S:checked'="true" checked="false"
		I $l(name) {
			S jsonStr=jsonStr_"{boxLabel:'"_label_"',name:'"_name_"',checked:"_checked_"},"
		}
	}
	I $E(jsonStr,$l(jsonStr))="," {
		S jsonStr=$E(jsonStr,1,$l(jsonStr)-1)
	}
	S jsonStr=jsonStr_"]"
	Q jsonStr
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取Grid的JSON字符串
/// Table:        	无
/// Input:        	labelNameValList:数据
/// Output:       	无
/// Return:       	成功:JSON数据,失败:"[]"
/// Others:       	返回字符串格式为：[{boxLabel:'testL1',name:'testN1',checked:false},{boxLabel:'testLn',name:'testNn',checked:true}]
ClassMethod GetStoreJsonData(nodeID As %String, jobID As %String, fieldKeys As %String = "", fieldDeli As %String = "^", mdlFlag As %String = "") As %String
{
	S jsonStr=""
	Q:'$l(nodeID) jsonStr
	
	S:'$l(jobID) jobID=$j
	
	I '$l(fieldKeys) {
		S firstIndex=$O(^TMP(nodeID,jobID,""))
		I $l(firstIndex) {
			S fieldKeys=$g(^TMP(nodeID,jobID,firstIndex))
			K ^TMP(nodeID,jobID,firstIndex)
		}
	}
	
	Q:'$l(fieldKeys) jsonStr
	
	S index="",rows="[",resutls=0
	F {
		S index=$O(^TMP(nodeID,jobID,index))	
		Q:index=""
		S data=$g(^TMP(nodeID,jobID,index))
		continue:'$l(data)
	
		S row="{"
		F i=1:1:$l(fieldKeys,fieldDeli) {
			S fieldKey=$P(fieldKeys,fieldDeli,i)
			S fieldVal=$P(data,fieldDeli,i)
			S fieldValType="STORE"
			continue:'$l(fieldKey)
			S row=row_..FormatFieldKeyVal(fieldKey,fieldVal,fieldValType,mdlFlag)_","
		}
		
		I $E(row,$l(row))="," {
			S row=$E(row,1,$l(row)-1)
		}
		S row=row_"}"
		I row'="{}" {
			S resutls=resutls+1
			S rows=rows_row_","
		}
	}
	
	I $E(rows,$l(rows))="," {
		S rows=$E(rows,1,$l(rows)-1)
	}
	
	S rows=rows_"]"
	
	S:rows="[]" rows="[{}]"
	
	S jsonStr="{resutls:"_resutls_",rows:"_rows_"}"
	K ^TMP(nodeID,jobID)
	Q jsonStr
}

}
