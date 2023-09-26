Class CIS.AN.BL.Request Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	//set userId=%session.Get("LOGON.USERID")
	//w "test"
	set userId="1"
	//zw %request
	set action=%request.Get("action")
	//set ^TMPCCQ("action")=action
	set node="",param=##class(%DynamicObject).%New()
	for
	{
		set node=$o(%request.Data(node))
		quit:(node="")
		do param.%Set(node,%request.Data(node,1))	
	}
	set ret=..RunAction(action,param,userId)
	write ret
	Quit $$$OK
}

ClassMethod RunAction(action As %String, param As %DynamicObject, userId As %String = "") As %String
{
	set $zt="Error"
	set methodType="",log="",note=""
	set dictId=""
	&sql(select RowId into :dictId from CT_AN.Dictionary where Code='Routes')
	&sql(select Description,Score,Uom into :note,:log,:methodType from CT_AN.DictData where Dictionary=:dictId and Code=:action)	
	set ret=""
	if (methodType="M")
	{
		set ret=..RunClassMethod(action,param)	
	}
	elseif (methodType="Q")
	{
		set ret=..RunQuery(action,param)	
	}
	
	if (log="Y")&(methodType="M")
	{
		do ..SaveLog(action,param,ret,userId,note)	
	}
	quit ret
Error
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.Request).RunClassMethod("AN/OPS",{"opsId":"4620"})
/// w ##class(CIS.AN.BL.Request).RunClassMethod("AN/OPSList",{"action":"AN/OPSList","endDate":"2020-11-09","startDate":"2020-11-09","statusCode":"DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^Decline","userDeptID":"236"})
/// w ##class(CIS.AN.BL.Request).RunClassMethod("AN/SaveMsgTemplate",^TMPCCQ("RunClassMethod"))
ClassMethod RunClassMethod(action As %String, param As %DynamicObject) As %String
{
	set ^TMPCCQ("RunClassMethod")=param.%ToJSON()
	set dictId=""
	&sql(select RowId into :dictId from CT_AN.Dictionary where Code='Routes')
	if (##class(CT.AN.Dictionary).%ExistsId(dictId))
	{
		set dictDataId="",className="",methodName="",ret="",methodType=""
		&sql(select DataItem1,DataItem2,Uom into :className,:methodName,:methodType from CT_AN.DictData where Dictionary=:dictId and Code=:action)
		set ^TMPCCQ("RunClassMethod",1)=dictId_"||"_className_"||"_methodName_"||"_methodType_"||"_action
		set formalSpec="",methodId=className_"||"_methodName,exeStr=""
		&sql(select FormalSpecParsed into :formalSpec from %Dictionary.CompiledMethod where %ID=:methodId)
		set paramCount=$ll(formalSpec)
		set exeStr="set result=##class("_className_")."_methodName_"("
		for i=1:1:paramCount
		{
			set paramStr=$li(formalSpec,i)
			set paramName=$li(paramStr,1)
			set paramType=$li(paramStr,2)
			set defValue=$li(paramStr,4)
			set:(param.%IsDefined(paramName)) defValue=param.%Get(paramName)
			set:(i>1) exeStr=exeStr_","
			set:(paramType'="%Library.DynamicObject")&(paramType'="%Library.DynamicArray") exeStr=exeStr_""""_defValue_""""
			if (paramType="%Library.DynamicObject")!(paramType="%Library.DynamicArray")
			{
				try{
					set ^TMPCCQ("RunClassMethod","DefValue")=defValue_"|||"_paramName
					//b //ccq
					set paramObject=##class(%DynamicAbstractObject).%FromJSON(defValue)
					
					set exeStr=exeStr_paramObject.%ToJSON()
				} catch ex {
					set exeStr=exeStr_param.%ToJSON()
				}
			}
		}
		set exeStr="(result) "_exeStr_")"
		x (exeStr,.ret)
		quit ret
			
	}
	else
	{
		quit "E^未找到类方法"	
	}
}

ClassMethod RunQuery(action As %String, param As %DynamicObject) As %String
{
	set ^TMPCCQ("RunQuery")=param.%ToJSON()
	set dictId=""
	&sql(select RowId into :dictId from CT_AN.Dictionary where Code='Routes')
	if (##class(CT.AN.Dictionary).%ExistsId(dictId))
	{
		set dictDataId="",className="",methodName="",ret="",methodType=""
		&sql(select DataItem1,DataItem2,Uom into :className,:methodName,:methodType from CT_AN.DictData where Dictionary=:dictId and Code=:action)
		set ^TMPCCQ("RunClassMethod",1)=dictId_"||"_className_"||"_methodName_"||"_methodType_"||"_action
		set formalSpec="",methodId=className_"||"_methodName,exeStr=""
		&sql(select FormalSpecParsed into :formalSpec from %Dictionary.CompiledQuery where %ID=:methodId)
		set paramCount=$ll(formalSpec)
		set rs=##class(%ResultSet).%New(className_":"_methodName)
		set exeStr="do rs.Execute("
		for i=1:1:paramCount
		{
			set paramStr=$li(formalSpec,i)
			set paramName=$li(paramStr,1)
			set paramType=$li(paramStr,2)
			set defValue=$li(paramStr,4)
			set:(param.%IsDefined(paramName)) defValue=param.%Get(paramName)
			set:(i>1) exeStr=exeStr_","
			set:(paramType'="%Library.DynamicObject") exeStr=exeStr_""""_defValue_""""
			set:(paramType="%Library.DynamicObject") exeStr=exeStr_param.%ToJSON()
		}
		set exeStr=exeStr_")"
		x exeStr
		set page=+param.page,rows=+param.rows,startIndex=0,endIndex=0
		if (page>0)&(rows>0)
		{
			set startIndex=(page-1)*rows+1,endIndex=page*rows
			w "{""rows"":["	
		}
		else
		{
			w "["	
		}
		set colCount=rs.GetColumnCount()
		set rowCount=0,findCount=0
		while(rs.%Next())
		{
			set rowCount=rowCount+1
			continue:(startIndex>0)&(rowCount<startIndex)
			continue:(endIndex>0)&(rowCount>endIndex)
			set findCount=findCount+1
			w:(findCount>1) ","
			set rowData=##class(%DynamicObject).%New()
			for colIndex=1:1:colCount
			{
				set colName=rs.GetColumnName(colIndex)
				set currentData=rs.GetData(colIndex)
				continue:(colName="_parentId")&(currentData="")
				set value=rs.GetData(colIndex)
				set value=$replace(value,"\","\\")
				set value=$replace(value,$c(10),"\n")
				set value=$replace(value,$c(0),"")
				set value=$replace(value,"""","\""")
				do rowData.%Set(colName,value)	
			}	
			w rowData.%ToJSON()
			set rowData=""
		}
		if (page>0)&(rows>0)
		{
			w "],""total"":"_rowCount_"}"	
		}
		else
		{
			w "]"	
		}
			
	}
	quit ""
}

ClassMethod SaveLog(action As %String, param As %DynamicObject, ret As %String, userId As %String, note As %String = "") As %String
{
	set log=##class(CIS.AN.Log).%New()
	set log.BSCode=action
	set log.InParam=param.%ToJSON()
	set log.LogUser=userId
	set log.OutParam=ret
	set log.Note=note
	set sc=log.%Save()
	set log=""
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

}
