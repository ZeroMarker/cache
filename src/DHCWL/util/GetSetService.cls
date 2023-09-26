Class DHCWL.util.GetSetService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// s cod=##class(DHCWL.util.GetSetService).SetPropertyByStr("DHCWL.MKPI.DimProperty","Code=Code&Name=取维度Code&Desc=取维度Code&ExcuteCode22=GetDesc^Test&DefaultFlag=N&DimDr=1",,"I"," where ID =2")
ClassMethod SetPropertyByStr(className, pros, deli = "&", operate = "I", whereState = "")
{
	n (className,pros,deli,operate,whereState)
	q:(className="")||(pros="")
	s proLen=$l(pros,deli)
	q:proLen<1
	k temppv
	f i=1:1:proLen {
		s pv=$p(pros,deli,i)
		s p=$p(pv,"=",1),v=$p(pv,"=",2,$l(pv,"="))
		s:p'="" temppv(p)=v
	}
	q ..SetObjValue(className,.temppv,operate,whereState)
}

/// s cod=##class(DHCWL.util.GetSetService).SetObjValue2("DHCWL.MKPI.Test","ID=2&Name=Mary12&action=insert",,"I"," where ID =2")
ClassMethod SetObjValue2(className, ByRef PV, operate = "I", whereStat = "") As %String
{
	n (className,PV,operate,whereStat)
	s operate=$zcvt(operate,"U")
	i $d(PV("ID")) s id=PV("ID")
	e  s id=0
	;s $et="do error"
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	Set count = cdef.Properties.Count(),wrongFlag=0
	k sqlPV,sqlPV2
	s serNum=0,sqlTableName=cdef.SqlTableName,schemaName=..GetSchema(className)
	
	if sqlTableName="" s sqlTableName=$p(className,".",$l(className,"."))
	f i=1:1:count {
		s pro=cdef.Properties.GetAt(i).Name
		s type=cdef.Properties.GetAt(i).Type
		w pro_"  "_type,!
		s deli=..GetSqlDeliByType(type)
		s sqlPV2(pro)=type
		s sqlFieldName=cdef.Properties.GetAt(i).SqlFieldName
		i sqlFieldName="" s sqlFieldName=pro
		s sqlPV2(pro,"F")=sqlFieldName
	}
	q
	s objExeStr="",objOpen="",obj="",sc=""
	s sqlPV2("ID")="Integer",sqlPV2("ID","F")="ID"
	s wrongFlag=0,pro="" f  s pro=$o(PV(pro)) q:(pro="")  d
	.i wrongFlag=1 d
	..k sqlPV2(killPro)
	..s wrongFlag=0
	.if (pro'="ID")&&('$d(sqlPV2(pro))) d
	..s wrongFlag=1,killPro=pro
	.q:wrongFlag=1
	.s type=sqlPV2(pro)
	.i type [ "String" s deli=""""
	.e  s deli=""
	.i objExeStr="" s objExeStr="s obj."_pro_"="_deli_PV(pro)_deli
	.e  s objExeStr=objExeStr_",obj."_pro_"="_deli_..ConvertValue(type,PV(pro))_deli
	if (operate="I") {
		s objOpen="s obj=##class("_className_").%New()"
	}elseif (operate="U") {
		s id=PV("ID")
		s:id'="" objOpen="s obj=##class("_className_").%OpenId("_id_")"
	}
	if (objOpen'="")&&(objExeStr'="") {
		xecute objOpen
		xecute objExeStr
		xecute "s sc=obj.%Save()"
	}
	q "wrong status="_sc
}

ClassMethod SetObjValue(className, ByRef PV, operate = "I", whereStat = "") As %String
{
	n (className,PV,operate,whereStat)
	s operate=$zcvt(operate,"U")
	;s $et="do error"
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	Set count = cdef.Properties.Count(),wrongFlag=0
	k sqlPV,sqlPV2
	s serNum=0,sqlTableName=cdef.SqlTableName,schemaName=..GetSchema(className)
	s sqlRowIdName=cdef.SqlRowIdName
	i sqlRowIdName="" s sqlRowIdName="ID"
	i $d(PV(sqlRowIdName)) s id=PV(sqlRowIdName)
	e  s id=0
	if sqlTableName="" s sqlTableName=$p(className,".",$l(className,"."))
	f i=1:1:count {
		s pro=cdef.Properties.GetAt(i).Name
		s type=cdef.Properties.GetAt(i).Type
		s deli=..GetSqlDeliByType(type)
		s sqlPV2(pro)=type
		s sqlFieldName=cdef.Properties.GetAt(i).SqlFieldName
		i sqlFieldName="" s sqlFieldName=pro
		s sqlPV2(pro,"F")=sqlFieldName
	}
	s sqlPV2(sqlRowIdName)="String",sqlPV2(sqlRowIdName,"F")=sqlRowIdName
	s wrongFlag=0,pro="" f  s pro=$o(PV(pro)) q:(pro="")  d
	.i wrongFlag=1 d
	..k sqlPV2(killPro)
	..s wrongFlag=0
	.if (pro'=sqlRowIdName)&&('$d(sqlPV2(pro))) d
	..s wrongFlag=1,killPro=pro
	.q:(wrongFlag=1)||(pro=sqlRowIdName)
	.s type=sqlPV2(pro)
	.s deli=..GetSqlDeliByType(type)
	.s serNum=serNum+1
	.s sqlPV(serNum,sqlPV2(pro,"F"))=deli_..ConvertValue(type,PV(pro))_deli
	;i wrongFlag q "class "_className_" not defined property "_pro
	if (+id>0)&&(operate'="I"){
		s tempObj=""
		s exStr="s tempObj=##class("_className_").%OpenId("_id_")"
		x exStr
		if (tempObj="") s wrongFlag2=1
	}
	i $g(wrongFlag2)=1 q "class "_className_"  don't contain id="_id
	s canExe=0
	if (operate="I") {
		s sqlP="",sqlV=""
		f i=1:1:serNum {
			s canExe=1
			s p=$o(sqlPV(i,""))
			s v=sqlPV(i,p)
			continue:(v="")||(v=$c(0))
			i sqlP="" s sqlP=p
			e  s sqlP=sqlP_","_p
			//s v=sqlPV(i,p)
			i sqlV="" s sqlV=v
			e  s sqlV=sqlV_","_v
		}
		s sql="insert into "_schemaName_"."_sqlTableName_"("_sqlP_")values("_sqlV_")"
	}elseif (operate="U") {
		s sqlUpdate=""
		f i=$o(sqlPV(""),-1):-1:1 {
			s canExe=1
			s p=$o(sqlPV(i,""))
			continue:(sqlPV(i,p)="")||(sqlPV(i,p)=$c(0))
			i sqlUpdate="" s sqlUpdate=p_"="_sqlPV(i,p)
			e  s sqlUpdate=sqlUpdate_","_p_"="_sqlPV(i,p)
		}
		s tempWhere="where ID="_id
		if whereStat'="" s tempWhere=whereStat
		s sql="update "_schemaName_"."_sqlTableName_" set "_sqlUpdate_" "_tempWhere
	}
	;w "sql="_sql,!
	
	s state=0
	if (canExe) {
		//s tStatement = ##class(%SQL.Statement).%New()
  		//s tStatus = tStatement.%Prepare(sql)
  		//s rset = tStatement.%Execute()
  		//s state=rset.%SQLCODE
  		s rs=##class(%Library.ResultSet).%New()
		d rs.Prepare(sql)
		s sc= rs.Execute()
		s state=sc ;rs.%SQLCODE
	}
	if state=1 q "ok"
	q "wrong SQLCODE="_state
error
	q "can not find class named"_className_",please check it"
}

/// s j=##class(DHCWL.util.GetSetService).GetJsonBySQL("select * from DHCWL_MKPI.DHCWLDimProperty",1,10)
ClassMethod GetJsonBySQL(sql, start As %Integer = 0, end As %Integer = 0, pros = "", replaceValue... As %List) As DHCWL.util.Json
{
	n (sql,start,end,pros,replaceValue)
	i $Get(replaceValue, 0)=0 s replaceValue=""
	s sql=..ReplaceSQLValue(sql,.replaceValue)
	;w "sql="_sql
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s cols=rs.GetColumnCount()
	s colNames="",deli="&",ind=0
	k FA
	f i=1:1:cols {
		s name=rs.GetColumnHeader(i)
		i colNames'="" s colNames=colNames_","_name
		e  s colNames=name
		i name="" continue
		s ind=ind+1
		s FA("DEF",name)=rs.GetColumnType(i)
		s FA("PAR",ind,name)=""
	}
	s:$g(pros)="" pros=colNames
	s tempPros=""
	f i=$l(pros):-1:1 {
		i $e(pros,i)="," s tempPros=deli_tempPros
		e  s tempPros=$e(pros,i)_tempPros
	}
	s nums=0
	s json=##class(DHCWL.util.Json).Json(tempPros,,,deli)
	s ignore=1
	i (start=0)&&(end=0) s ignore=0
	While(rs.Next()){
		s i=0
		s nums=nums+1
		i (ignore)&&(nums<(start)) continue
		i (ignore)&&((end)<nums) continue
		s values=""
		f {
			s i=$o(FA("PAR",i))
			q:i=""
			s field=$o(FA("PAR",i,""))
			s v=rs.Data(field)
			s v=$REPLACE(v,$C(13),"")	//add by wz . replace CR .
			s v=$REPLACE(v,$C(10),"")	//add by wz . replace LF .
			s type=FA("DEF",field)
			s v=..ConvertToViewType(type,v)
			s:(v=$c(0)) v=""
			i values'="" s values=values_deli_"'"_v_"'"
			else  s values="'"_v_"'"
		}
		d json.Insert(values)
	}
	d:json json.SetTotalNum(nums)
	d rs.Close()
	q json
}

ClassMethod ConvertToViewType(type, value)
{
	n (type,value)
	q:(value="")||(value=$c(0)) ""
	i type=2 {
		q $zd(value,3)
	}
	q value
}

ClassMethod ConvertValue(type, value)
{
	n (type,value)
	i type [ "Date" {
		q $zdh(value,3)
	}
	q value
}

ClassMethod GetSqlDeliByType(type)
{
	n (type)
	q:type="" ""
	if (type [ "String"){
		q "'"
	}else {
		q ""
	}
}

/// w ##class(DHCWL.util.GetSetService).MapFildFromClassProByStr("DHCWL.MKPI.ExecuteCode","ExeCodeWrite,ExeCodeCall,ExeCodeVersion,ExcCodeCUDate,ExeCodeCreator,ExcCodeApplicable,ExcCodeDescription")
ClassMethod MapFildFromClassProByStr(className, pros, deli = ",") As %String
{
	n (className,pros,deli)
	k tempP
	s proLen=$l(pros,deli)
	f i=1:1:proLen {
		s tempP(i,$p(pros,deli,i))=""
	}
	q ..MapFildFromClassPro(className,.tempP)
}

ClassMethod MapFildFromClassPro(className, ByRef PV) As %String
{
	n (className,PV,sqlPV)
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	Set count = cdef.Properties.Count(),wrongFlag=0
	k sqlPV,sqlPV2
	s serNum=0,sqlTableName=cdef.SqlTableName,schemaName=..GetSchema(className)
	f i=1:1:count {
		s pro=cdef.Properties.GetAt(i).Name
		s type=cdef.Properties.GetAt(i).Type
		s deli=..GetSqlDeliByType(type)
		s sqlPV2(pro)=type
		s sqlPV2(pro,"F")=cdef.Properties.GetAt(i).SqlFieldName
	}
	s sqlPV2("ID")="Integer",sqlPV2("ID","F")="ID",i=0
	s i=0 f  s i=$o(PV(i)) q:(+i=0)||(wrongFlag)  d
	.s pro=$o(PV(i,""))
	.if ('$d(sqlPV2(pro))) d
	..s wrongFlag=1
	..q
	.;s i=i+1
	.s type=sqlPV2(pro)
	.s deli=..GetSqlDeliByType(type)
	.s sqlPV(i,sqlPV2(pro,"F"))=deli
	.s sqlPV(i,sqlPV2(pro,"F"),"TYPE")=type
	i wrongFlag k sqlPV
	s sqlFields=""
	s i=0 f  {
		s i=$o(sqlPV(i))
		q:i=""
		i sqlFields'="" s sqlFields=sqlFields_","_$o(sqlPV(i,""))
		e  s sqlFields=$o(sqlPV(i,""))
	}
	q sqlFields
}

ClassMethod GetTableName(className) As %String
{
	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	Set count = cdef.Properties.Count()
	s sqlTableName=cdef.SqlTableName
	if sqlTableName'="" q ..GetSchema(className)_"."_sqlTableName
	e  q ""
}

/// w ##class(DHCWL.util.GetSetService).GetSchema("DHCWL.util.GetSetService")
ClassMethod GetSchema(className) As %String
{
	n (className)
	s pn=$l(className,"."),schema=""
	i pn<2 d
	.s schema="SQLUser"
	e  d
	.s temp=$p(className,".",1,pn-1)
	.f i=1:1:$l(temp) d
	..i $e(temp,i)="."  d
	...s schema=schema_"_"
	..e  d
	...s schema=schema_$e(temp,i)
	q schema
}

/// w ##class(DHCWL.util.GetSetService).RequestDataToStr()
ClassMethod RequestDataToStr(arr, deli = ",") As %String
{
	n (arr,deli)
	s result=""
	s val="" f  s val=$o(arr(val)) q:val=""  d
	.s ind="" f  s ind=$o(arr(val,ind)) q:ind=""  d
	..i result'="" s result=result_deli_$g(arr(val,ind))
	.e  s result=$g(arr(val,ind))
	q result
}

/// w ##class(DHCWL.util.GetSetService).ReplaceSQLValue()
ClassMethod ReplaceSQLValue(sql, ByRef replaceValue) As %String
{
	n (sql,replaceValue)
	if ($l(sql,"?")>1) {
		s sql2="",repNum=1
		f i=1:1:$l(sql) {
			if ($e(sql,i)="?"){
				s value=$get(replaceValue(repNum))
				s repNum=repNum+1
				s sql2=sql2_value
			}else{
				s sql2=sql2_$e(sql,i)
			}
		}
		s sql=sql2
	}
	q sql
}

ClassMethod trim(str) As %String
{
	n (str)
	q:str=""
	s rs="",len=$l(str)
	f i=1:1:len {
		if ((($ASCII($e(str,i))>47)&&($ASCII($e(str,i))<58))||(($ASCII($e(str,i))>64)&&($ASCII($e(str,i))<91))||(($ASCII($e(str,i))>96)&&($ASCII($e(str,i))<123))) {
			s start=i
			q
		}else {
			continue
		}
	}
	f i=len:-1:1 {
		if ((($ASCII($e(str,i))>47)&&($ASCII($e(str,i))<58))||(($ASCII($e(str,i))>64)&&($ASCII($e(str,i))<91))||(($ASCII($e(str,i))>96)&&($ASCII($e(str,i))<123))) {
			s end=i
			q
		}else {
			continue
		}
	}
	q $e(str,start,end)
}

}
