Class web.DHCENS.STBLL.DICTNew.METHOD.Common Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext ]
{

Property Data As %String [ MultiDimensional, Private ];

Property DateFormat As %String [ InitialExpression = "3" ];

Property TimeFormat As %String [ InitialExpression = "1" ];

/// 生成的json内是不是包含空值, 'name':''
Property ContainNullValue As %String [ InitialExpression = "0" ];

/// 生成的json内是不是包含空对象 'dr':{}
Property ContainNullObject As %String [ InitialExpression = "0" ];

/// 生成的json内是不是包含空对象 'child':[]
Property ContainNullArray As %String [ InitialExpression = "0" ];

/// 支持属性
Method Array2Json(ArrObj)
{
	Set rtn = ""
	Set key=""
	For  Set value=ArrObj.GetNext(.key) Quit:key=""  d
	.if $IsObject(value)&&($CLASSNAME(value)="web.DHCENS.STBLL.DICTNew.METHOD.Common") set json=value.Json()
	.else  if $IsObject(value) set json = $this.Obj2Json(value,$CLASSNAME(value))
	.else  set json = """"_value_""""
	.quit:(json="""""")||(json="{}")
	.set json=""""_key_""":"_json
	.set rtn=$case(rtn,"":"",:rtn_",")_json	
	quit "{"_rtn_"}"
}

/// 不支持属性
ClassMethod ArrayToJson(ArrObj)
{
	Set rtn = ""
	Set key=""
	For  Set value=ArrObj.GetNext(.key) Quit:key=""  d
	.if $IsObject(value)&&($CLASSNAME(value)="web.DHCENS.STBLL.DICTNew.METHOD.Common") set json=value.Json()
	.else  if $IsObject(value) set json = ..ObjToJson(value,$CLASSNAME(value))
	.else  set json = """"_value_""""
	.quit:(json="""""")||(json="{}")
	.set json=""""_key_""":"_json
	.set rtn=$case(rtn,"":"",:rtn_",")_json	
	quit "{"_rtn_"}"
}

/// 支持属性
Method List2Json(ListObj)
{
	Set rtn = ""
	Set len = ListObj.Count()
	for j=1:1:len d
	.set o = ListObj.GetAt(j)
	.if $IsObject(o)&&($CLASSNAME(o)="web.DHCENS.STBLL.DICTNew.METHOD.Common") set json=o.Json()
	.else  if $IsObject(o) set json = $this.Obj2Json(o,$CLASSNAME(o))
	.else  set json = """"_o_""""
	.quit:(json="""""")||(json="{}")
	.set rtn=$case(rtn,"":"",:rtn_",")_json
	quit "["_rtn_"]"
}

ClassMethod LibListToJson(LibListObj)
{
	Set rtn = ""
	Set len = $LL(LibListObj)
	for j=1:1:len d
	.set item = $LG(LibListObj,j)
	.if rtn="" Set rtn = """"_##class(ext.util.String).EvalJSON(item)_""""
	.else  Set rtn = rtn_","""_##class(ext.util.String).EvalJSON(item)_""""
	quit "["_rtn_"]"
}

/// 不支持属性
ClassMethod ListToJson(ListObj)
{
	Set rtn = ""
	Set len = ListObj.Count()
	for j=1:1:len d
	.set o = ListObj.GetAt(j)
	.if $IsObject(o)&&($CLASSNAME(o)="web.DHCENS.STBLL.DICTNew.METHOD.Common") set json=o.Json()
	.else  if $IsObject(o) set json = ..ObjToJson(o,$CLASSNAME(o))
	.else  set json = """"_o_""""
	.quit:(json="""""")||(json="{}")
	.set rtn=$case(rtn,"":"",:rtn_",")_json
	quit "["_rtn_"]"
}

ClassMethod ListToStream(ListObj) As %GlobalCharacterStream
{
	#dim CharStream As %GlobalCharacterStream
	Set CharStream = ##class(%GlobalCharacterStream).%New()
	do CharStream.Write("[")
	Set rtn = ""
	Set len = ListObj.Count()
	for j=1:1:len d
	.set o = ListObj.GetAt(j)
	.if $IsObject(o)&&($CLASSNAME(o)="web.DHCENS.STBLL.DICTNew.METHOD.Common") set json=o.Json()
	.else  if $IsObject(o) set json = ..ObjToJson(o,$CLASSNAME(o))
	.else  set json = """"_o_""""
	.;quit:(json="""""")||(json="{}")
	.if j'=1 do CharStream.Write(",")
	.do CharStream.Write(json)
	.;set rtn=$case(rtn,"":"",:rtn_",")_json
	do CharStream.Write("]")
	quit CharStream
}

/// @param: Object  Obj   要转成json的对象
/// @param: %String  className 不传入默认为$classname(Obj)
/// @param: web.DHCENS.STBLL.DICTNew.METHOD.Common 确定Obj转成什么样的Json(如ContainNullArray,ContainNullObject,ContainNullValue,DateFormat,TimeFormat)
ClassMethod ObjToJson(Obj, className As %String = "", jsonObject As web.DHCENS.STBLL.DICTNew.METHOD.Common = "")
{
	set jsonObj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New()
	if $IsObject(jsonObject){
		set jsonObj.ContainNullArray = jsonObject.ContainNullArray
		set jsonObj.ContainNullObject = jsonObject.ContainNullObject
		set jsonObj.ContainNullValue = jsonObject.ContainNullValue
		set jsonObj.DateFormat = jsonObject.DateFormat
		set jsonObj.TimeFormat = jsonObject.TimeFormat
	}
	if ($CLASSNAME(Obj)["ListOf"){
		set json = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ListToJson(Obj)
	}elseif ($CLASSNAME(Obj)["ArrayOf"){
		set json = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ArrayToJson(Obj)
	}else{
		set json = jsonObj.FromObject(Obj,.className,1).Json()
		do jsonObj.Clear()	
		set jsonObj=""
	}
	q json
}

/// 对象转成json,成员方法可以设置属性
Method Obj2Json(Obj, className As %String = "")
{
	set json = $this.FromObject(Obj,.className,1).Json()
	q json
}

/// @param: 请求串String 或 Cache对象 
/// @param: %String className 
/// @param: %Boolean isRefValue    1时取指向的值, 0时取指向的json
/// 例如:EMParentCode=NURPRNOrder&EMCode=NURPRNOrderCancel&EMText=%E6%92%A4%E6%B6%88(DC)
/// 	s obj = ##class(websys.ExtMenu).%OpenId(2,0)
/// 	s jsonObj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New()
/// 	s json = jsonObj.FromObject(obj).Json()
Method FromObject(bean, ByRef className, isRefValue As %Integer = 0)
{
	q:bean="" %this
	if $g(className)="" s cn = $CLASSNAME(bean)
	else  s cn=className
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(cn)
	i $IsObject(dcd) d
	.s cnt=dcd.Properties.Count()
	.f i=1:1:cnt  d	
	..s propObj = dcd.Properties.GetAt(i)
	..s value=""
	..s PropertyName = propObj.Name
	..q:$e(PropertyName,1)="%"
	..q:propObj.Cardinality="children"
	..set PropertyValue = $ZOBJPROPERTY(bean,PropertyName)
	..;set:PropertyValue["[" PropertyValue =$replace(PropertyValue,"[",""""_"[")
	..;set:PropertyValue["]" PropertyValue =$replace(PropertyValue,"]","]"_"""")
	..;s type = propObj.Type		;如果是listofobj,则显示为list内对象的type
	..set runtimeType = propObj.RuntimeType,type=runtimeType
	..if (runtimeType="%Library.CacheObject")&&$IsObject(PropertyValue) set type=$CLASSNAME(PropertyValue) ;$classname(%String)=val
	..s private = propObj.Private
	..q:(private=1)
	..; 指向
	..if $e(type,1)'="%"  d
	...if isRefValue=0 set value=..ObjToJson(PropertyValue,type,$this)
	...else  d
	....Try{set value = $ZOBJMETHOD(bean,PropertyName_"GetObjectId")}catch(e){Set value=""} //持久类有GetObjectId方法
	....if value="" set value=..ObjToJson(PropertyValue,type,$this) //注册类没有GetObjectId方法
	...;set value = $s(isRefValue=0:..ObjToJson(PropertyValue,type,$this),1:$ZOBJMETHOD(bean,PropertyName_"GetObjectId"))
	..else  d
	...if (type["%Library.List") set value = ..LibListToJson(PropertyValue)
	...if (type["ListOf") set value = ..ListToJson(PropertyValue)
	...if (type["ArrayOf") set value = ..ArrayToJson(PropertyValue)	
	...if value="" s value = PropertyValue			//String , Number
	...if (type["Date")&&(value'="") s value=$zd(value, i%DateFormat)
	...if (type["Time")&&(value'="") s value=$zt(value, i%TimeFormat)
	...;if (type="%Float")&&(value'="")
	..Q:('i%ContainNullValue)&&(value="")
	..Q:('i%ContainNullObject)&&(value="{}")
	..Q:('i%ContainNullArray)&&(value="[]")
	..Set XMLPropertyName = PropertyName	//增加XMLNAME参数配置 2018-3-28 by wanghc
	..Set XMLNAME = propObj.Parameters.GetAt("XMLNAME")  
	..IF XMLNAME'="" Set XMLPropertyName=XMLNAME
	..if ((type["Boolean")||(type["Int")||(type["Float"))&&(value'="") d %this.Put(XMLPropertyName,value,type) 
	..else  d %this.Put(XMLPropertyName,value)
	.d dcd.%Close()
	.if ##class(%Dictionary.CompiledMethod).%ExistsId(cn_"||%Id") d %this.Put("ID",$ZOBJMETHOD(bean,"%Id"))	
	else  d
	.s jsn = bean
	.s len=$l(jsn,"&")
	.f i=1:1:len d
	..s jsnitem = $p(jsn,"&",i)
	..d %this.Put($p(jsnitem,"="),$ZCVT($zcvt($p(jsnitem,"=",2),"I","URL"),"I","UTF8"))
	s dcd=""
	Q %this
}

/// @param key 键
/// @param value 值
/// @param valueType %Boolean/%Integer/%Float/%String
Method Put(key, value, isRealValue = "") As Common
{
	if $e(key,1,1)="'",$e(key,$l(key),$l(key))="'"{
		set key = $e(key,2,$l(key)-1) 				;Put("'key'","val")
	}
	if $e(value,1,1)="'",$e(value,$l(value),$l(value))="'"{
		set value = $e(value,2,$l(value)-1)			;Put("key","'val'")
	}
	Set i%Data(key)=value
	if (isRealValue["Boolean")||(isRealValue["Int")||(isRealValue["Float") Set i%Data(key,1)=isRealValue
	q %this
}

/// 组合成xml打印文本区格式
Method GetPrintData() As %Library.String
{
	Set rtn=""
	Set key=""
	For {
		Set key = $o(i%Data(key))
		quit:key=""
		Set val = i%Data(key)
		if (rtn="") {
			Set rtn=key_$c(2)_val
		}else{
			Set rtn=rtn_"^"_key_$c(2)_val
		}
	}
	Quit rtn
}

Method IsArrayOrObjStr(value)
{
	q:($e(value,1,1)="[")&&($e(value,$l(value),$l(value))="]") 1
	q:(($e(value,1,1)="{")&&($e(value,$l(value),$l(value))="}")) 1
	q 0
}

Method Json() As %Library.String
{
	Set json=""
	Set key=""
	For {
		Set key=$order(i%Data(key)) 
		Quit:key=""
		Set value = i%Data(key)
		Set len = $l(value)
		If ..IsArrayOrObjStr(value) {
			if json="" Set json = """"_key_""":"_value
			else  Set json = json_","""_key_""":"_value 
		}elseif($g(i%Data(key,1))'=""){
			If json="" Set json = """"_key_""":"_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)
			Else  Set json = json_","""_key_""":"_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)
		}else{
			If json="" Set json = """"_key_""":"""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)_""""
			Else  Set json = json_","""_key_""":"""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)_""""
		}
	}
	q "{"_json_"}"
	
	Set json=""
	Set key=$order(i%Data(""))
	i key'="" d
	.Set value = i%Data(key)
	.Set len = $l(value)
	.;Set json=""""_key_""""_":"_$s(value?1.N>0:value,1:""""_value_"""")  ;如果数字是以0开头，js会看成是8进制数字\
	.if ..IsArrayOrObjStr(value) Set json = """"_key_""":"_value 
	.else  d
	..if $g(i%Data(key,1))'="" Set json = """"_key_""":"_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value) 
	..else  Set json = """"_key_""":"""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)_""""
	.For  Set key=$order(i%Data(key)) Quit:key=""  d 
	..set value = i%Data(key)
	..Set len = $l(value)
	..;set value = $s(value?1.N>0:value,1:""""_value_"""")	
	..If ..IsArrayOrObjStr(value) Set json = json_","""_key_""":"_value 
	..else  d
	...if $g(i%Data(key,1))'="" Set json = ","""_key_""":"_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value) 
	...else  Set json = json_","""_key_""":"""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(value)_""""
	q "{"_json_"}"
}

/// @param %string className
/// 把该web.DHCENS.STBLL.DICTNew.METHOD.Common对象转成对应的classname对象，并返回
Method Bean(className As %String) As %ObjectHandle
{
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(className)
	q:'$IsObject(dcd) "没有找到"_className_"类"
	if ($d(i%Data("ID")) && +i%Data("ID")>0) {
		s bean = $classmethod(className,"%OpenId",i%Data("ID"))
	}elseIf ($d(i%Data("PARREF")) && (+i%Data("PARREF")>0)) {
		s bean = $classmethod(className,"%New",i%Data("PARREF"))
	}else{
		s bean = $classmethod(className,"%New")
	}
	/*
	if ($d(i%Data("ID")) && +i%Data("ID")>0) {
		s bean = $zobjclassmethod(className,"%OpenId",i%Data("ID"))
	}elseif($d(i%Data("PARREF")) && +i%Data("PARREF")>0) {
		s bean = $zobjclassmethod(className,"%New",i%Data("PARREF"))
	}else {
		s bean = $zobjclassmethod(className,"%New")
	}
	*/
	s cnt=dcd.Properties.Count()
	f i=1:1:cnt  d
	.s propObj = dcd.Properties.GetAt(i)
	.s PropertyName = propObj.Name
	.S XMLNAME = propObj.Parameters.GetAt("XMLNAME")
	.q:$e(PropertyName,1)="%"
	.q:propObj.Cardinality="children"
	.s type = propObj.Type
	.s private = propObj.Private
	.q:private=1
	.set value=""
	.;q:($d(i%Data(PropertyName))=0)
	.if $d(i%Data(PropertyName))#2 set value = i%Data(PropertyName)
	.if (XMLNAME'=""),$d(i%Data(XMLNAME))#2 set value = i%Data(XMLNAME)  //支持XMLNAME参数配置 20180328 by wanghc
	.q:value=""
	.Q:('i%ContainNullValue)&&(value="")
	.i $e(type,1)'="%" d
	..d $ZOBJMETHOD(bean,PropertyName_"SetObjectId",value)
	.e  d	
	..i ((type="%Library.Date")||(type="%Date"))&&(value'="") s value=$zdh(value, i%DateFormat)
	..i ((type="%Library.Time")||(type="%Time"))&&(value'="") s value=$zth(value, i%TimeFormat)
	.s $ZOBJPROPERTY(bean,PropertyName)=value	
	d dcd.%Close()
	s dcd = ""
	q bean
}

/// @param : %String jsonstr  指向字段传入Id就成 	{ID:2,PAADMPAPMIDR:1,...}
/// @param : %String className
/// 把jsonstr转成className类的对象
ClassMethod ObjectFromJSON(jsonstr As %String, className As %String) As %ObjectHandle
{
	Q ..FromJSON(jsonstr).Bean(className)
}

/// @param : %String jsonstr  指向字段传入Id就成 	[{ID:2,PAADMPAPMIDR:1,..},{}]
/// @param : %String className
/// 把jsonstr转成Array类的对象
/// 
ClassMethod ArrayFromJSON(jsonstr As %String, className As %String) As %ArrayOfObjects
{
	if jsonstr="[]" Quit ""
	Set jsonstr=$e(jsonstr,2,$l(jsonstr)-1) ;去掉[ 与 ]
	Set Arr = ##class(%ArrayOfObjects).%New()
	Set SplitStr = "},{"
	for i=1:1:$l(jsonstr,SplitStr){
		Set itemJsonStr = $p(jsonstr,SplitStr,i)
		if $e(itemJsonStr,1)'="{" Set itemJsonStr="{"_itemJsonStr
		if $e(itemJsonStr,$l(itemJsonStr))'="}" Set itemJsonStr=itemJsonStr_"}"
		Set obj = ..FromJSON(itemJsonStr).Bean(className)
		do Arr.SetAt(obj,i)
	}
	Quit Arr
}

/// @param : %String jsonstr  指向字段传入Id就成 [	{ID:2,PAADMPAPMIDR:1,...},{}]
/// @param : %String className
/// 把jsonstr转成list类的对象
ClassMethod ListFromJSON(jsonstr As %String, className As %String) As %ListOfObjects
{
	if jsonstr="[]" Quit ""
	Set jsonstr=$e(jsonstr,2,$l(jsonstr)-1) ;去掉[ 与 ]
	Set List = ##class(%ListOfObjects).%New()
	Set SplitStr = "},{"
	for i=1:1:$l(jsonstr,SplitStr){
		Set itemJsonStr = $p(jsonstr,SplitStr,i)
		if $e(itemJsonStr,1)'="{" Set itemJsonStr="{"_itemJsonStr
		if $e(itemJsonStr,$l(itemJsonStr))'="}" Set itemJsonStr=itemJsonStr_"}"
		set obj = ..FromJSON(itemJsonStr).Bean(className)
		do List.Insert(obj)
	}
	Quit List
}

/// @param : %String jsonstr {name:"wang:hc",age:1}
/// 把jsonstr转成jsonObject对象.现仅支持一级简单的json
ClassMethod FromJSON(jsonstr As %String) As Common
{
	if jsonstr="{}" Quit ""
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s obj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New()
	s len=$length(tempstr,",")
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$E(tempstr1,$l(name)+2,$l(tempstr1)) 
		//$P(tempstr1,":",2,$l())
		if name["""" s name=$P(name,"""",2)
		if value["""" s value=$P(value,"""",2)
		d obj.Put(name,value)
	}
	Q obj
}

/// 拿到jsonObject的Key对应的值
Method GetValue(Key)
{
	Quit $g(i%Data(Key))
}

Method Get(Key)
{
	Quit $g(i%Data(Key))
}

/// 请空JSON数据
Method Clear()
{
	K i%Data
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).Test()
ClassMethod Test()
{
	d ..GetValueTest()
	d ..PutTest()
	w !
	d ..RefTest()
	w !
	d ..CollTest()
	q ""
}

ClassMethod GetValueTest()
{
	W "jsonObj.GetValue(""name""):",!
	Set jsonstr = "{name:""wang:hc"",age:18}"
	w jsonstr,!
	Set jsonObj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).FromJSON(jsonstr)
	w "    "_jsonObj.GetValue("name"),!
	w "    "_jsonObj.GetValue("age"),!
}

ClassMethod PutTest()
{
	;;Put方法写入数据
	s obj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New()
	d obj.Put("weight",120,"Integer").Put("name","wanghc").Put("sex","man")
	d obj.Put("akc-021",123)
	w "obj.Json():",!
	w "    "_obj.Json(),!,!
	w "obj.GetValue(name):",!
	w "    name:"_obj.GetValue("name"),!,!
	d obj.Clear()
	
	;;对象方式写入数据.  (实体对象,注册对象都可以)
	s pm = ##class(User.CTPayMode).%OpenId(2,0)
	s obj.ContainNullValue = 1
	w "obj.FromObject(pm).Json():",!
	w "    "_obj.FromObject(pm).Put("AddInfo","附加信息").Json(),!,!
	d obj.Clear()
	w "obj.ObjToJson(pm):",!
	w "    "_obj.ObjToJson(pm),!
	d obj.Clear()
	
	d obj.%Close()
	s obj = ""
	q ""
}

ClassMethod RefTest()
{
	;;PAPMI_RowID=2的对象转换
	;{ 
	;   'ID':'2',
	;   'PAPMIUserUpdate':{
	;        'ID':'7',
	;        'SSUSRDefaultDeptDR':'131',	;第三级对象只显示Id的值
	;		 ...
	;    },
	;    ...
	;}
	s obj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New() 
	;s obj.ContainNullArray=1
	;s obj.ContainNullObject=1
	;s obj.ContainNullValue=1
	;不建议转关联多的对象
	s pm = ##class(User.PAPatMas).%OpenId(2,0)
	w obj.FromObject(pm).Json(),!
	s pm=""
	d obj.Clear()
	//d obj.%Close()
	//s obj = ""
	w "系统配置"
	
	s pm1 = ##class(websys.Configuration).%OpenId(1,0)
	w obj.FromObject(pm1).Json(),!
	s pm1=""
	d obj.Clear()
	d obj.%Close()
	s obj = ""
	q ""
}

ClassMethod CollTest()
{
	s obj = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).%New() 
	s jo = ##class(Test.ExtJsonObject).InitData()
	s obj.ContainNullValue=1
	s obj.ContainNullArray=1
	s obj.ContainNullObject=1
	w obj.FromObject(jo).Json(),!
	s jo=""
	d obj.Clear()
	d obj.%Close()
	s obj = ""
	
	Set str = "[{""DiskName"":""c:"",""DiskTotalSpace"":""50.01""}"_
	",{""DiskName"":""e:"",""DiskTotalSpace"":""100.01""}]"
	#dim List As %ListOfObjects
	Set List = ..ListFromJSON(str,"websys.MonitorDisk")
	W !,List.GetNext(.key)	
	W !,List.GetNext(.key)	
	For {
	   Set disObj = List.GetNext(.key)
	   Quit:'$IsObject(disObj)
	   Set DiskName =disObj.DiskName
	   Set DiskTotalSpace = disObj.DiskTotalSpace
	   Set DiskFreeSpace = disObj.DiskFreeSpace
	   Set DiskUsePer = disObj.DiskUsePer
	   Set Summary="总空间"_DiskTotalSpace_"G,可用"_DiskFreeSpace_"G,使用率"_DiskUsePer
	}
}

ClassMethod ArrTest()
{
	Set str = "[{""DiskName"":""c:"",""DiskTotalSpace"":""50.01""}"_
	",{""DiskName"":""e:"",""DiskTotalSpace"":""100.01""}]"
	Set Arr = ..ArrayFromJSON(str,"websys.MonitorDisk")	
	W Arr.GetAt(1).DiskName
}

/// Write出Array ,用于直接输出到界面 , 不会超长,数组会节省一半空间
/// d ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ClassQuery2Array("web.SSUser","ListAll",0,10,.total,"")
/// open fileName:"WS"
/// use fileName w "hellow"
/// close fileName
ClassMethod ClassQuery2Array(ClassName, QueryName, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
	New rs,columns,%sc,i,execute,i,cnt
	New pcount Set pcount=$zutil(141)-5
	Set rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	;Set ^Temp("web.DHCENS.STBLL.DICTNew.METHOD.Common","ClassQuery2Json")=execute
	Xecute execute
	Set myjsonstr=""
	Quit:'##class(websys.Conversions).IsValidResultSet(rs) "Not Vaild ResultSet"
	Set cnt=0
	Set displayRows=0
	Write "["
	Set columns=rs.GetColumnCount()
	Set end=start+limit
	while(rs.Next()){
		set cnt = cnt + 1
		continue:(cnt<=start)
		continue:(cnt>end)
		set row = ""
		for i=1:1:columns {
			set isString = $Case(rs.GetColumnType(i),3:0,5:0,16:0,:1)
			if (isString){
				set row = row_$case(i,1:"",:",")_""""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(rs.GetData(i))_""""
			}else{
				set row = row_$case(i,1:"",:",")_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(rs.GetData(i))
			}
		}
		write $case(displayRows,0:"",:","),"[",row,"]"
		set displayRows = displayRows+1
	}
	Write "]"
	set total = cnt
	quit ""
}

/// Write出Json ,用于直接输出到界面 , 不会超长
/// d ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ClassQuery2Json("web.SSUser","ListAll",0,10,.total,"")
/// open fileName:"WS"
/// use fileName w "hellow"
/// close fileName
/// 3 %Float DOUBLE
/// 4 %CSP.Session/User.SSUser HANDLE
/// 5 %Integer INTEGER
/// 10 %String varchar
/// 16 %Boolean BOOLEAN
ClassMethod ClassQuery2Json(ClassName, QueryName, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
	New rs,columns,%sc,i,execute,i,cnt,ZRowList,SortColumnIsString
	New pcount Set pcount=$zutil(141)-5
	Set Sort = $g(%request.Data("sort",1)) 	;LogonTime 2018-08-18
	Set Order = $g(%request.Data("order",1)) ;asc desc 2018-08-18
	kill TotalFieldsDataList //合计数据, 外层方法得使用
	Set ReqTotalFields = $g(%request.Data("totalFields",1))  ;需求总计的列名2018-09-19
	If ReqTotalFields'="" Set ReqTotalFields = ","_ReqTotalFields_","
	//totalColField=Amt,unitcost // & avgColField=unitcost

	Set SortColumnIsNumber=0 				 ;排序列默认为字符串
	Set rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	;Set ^Temp("web.DHCENS.STBLL.DICTNew.METHOD.Common","ClassQuery2Json")=execute
	Xecute execute
	Set myjsonstr=""
	Quit:'##class(websys.Conversions).IsValidResultSet(rs) "Not Vaild ResultSet"
	Set cnt=0
	Set displayRows=0
	Write "["
	Set columns=rs.GetColumnCount()
	Set end=start+limit
	while(rs.Next()){
		set cnt = cnt + 1		
		continue:(cnt<=start)&&(Sort="")&&(ReqTotalFields="")
		continue:(cnt>end)&&(Sort="")&&(ReqTotalFields="")
		set row = ""
		Set hiddenIndex=""
		for i=1:1:columns {
			Set columnName = rs.GetColumnName(i) ;2018-2-7 hidden,hidden,hidden转成hidden,hidden1,hidden2 与websys.Query.cls中ColumnToJson对应
			Set val = ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(rs.GetData(i))
			if (ReqTotalFields[(","_columnName_",")){
				Set TotalFieldsDataList(columnName) = val+$G(TotalFieldsDataList(columnName))
			}
			set isString = $Case(rs.GetColumnType(i),16:0,:1) //增加字符串判断,如果为Boolean则不加双引号3:0,5:0,Float,Integer,
			if (columnName=Sort),((rs.GetColumnType(i)=3)||(rs.GetColumnType(i)=5)){ //Number
				Set SortColumnIsNumber=1
			}
			if (rs.GetColumnType(i)=16){ //Boolean
				if (val="true"){
					Set val = "true"
				}elseif (val>0){
					Set val = "true"
				}elseif (val="Y") {
					Set val = "true"
				}elseif (val="是"){
				 	Set val = "true"
				}elseif (val="on"){
					Set val = "true"
				}else{
					Set val = "false"
				}
			}
			If $zcvt(columnName,"U")="HIDDEN" {
				Set columnName=columnName_hiddenIndex
				Set hiddenIndex=hiddenIndex+1
			}
			if (isString){
				set row = row_$case(i,1:"",:",")_""""_columnName_""":"""_val_""""
			}else{
				set row = row_$case(i,1:"",:",")_""""_columnName_""":"_val
			}
		}
		if Sort=""{
			if (cnt>start)&&(cnt<=end){
				write $case(displayRows,0:"",:","),"{",row,"}"
				set displayRows = displayRows+1
			}
		}else{
			if (SortColumnIsNumber){
				Set ZRowList(+rs.GetDataByName(Sort),cnt)="{"_row_"}"
			}else{
				Set ZRowList(" "_rs.GetDataByName(Sort),cnt)="{"_row_"}"
			}
		}
	}
	set total = cnt
	if (Sort'=""){
		If Order="desc" Set Order=-1
		else  Set Order=1
		Set displayRows=0,currRowNum=0
		Set SortValue = "" for {
			Set SortValue = $O(ZRowList(SortValue),Order)
			Quit:(SortValue="")
			set SortInd="" for {
				Set SortInd = $O(ZRowList(SortValue,SortInd),Order)
				Quit:SortInd=""
				set currRowNum = currRowNum + 1
				continue:(currRowNum<=start)
				Quit:(currRowNum>end)
				Write $case(displayRows,0:"",:","), ZRowList(SortValue,SortInd) 	
				set displayRows = displayRows+1
			}
		}
	}
	Write "]"
	set total = cnt
	quit ""
}

/// Quit出Json , 用于方法调用,拿到返回串,可能超长,可通过入参控制
/// d ##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ClassQuery2Json("web.cqtest.DHCStudent","LookUp",0,10,.total,1)
ClassMethod ClassQuery2JsonQ(ClassName, QueryName, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
	New rs,columns,%sc,i,execute,i,cnt,rtn,displayRows
	New pcount Set pcount=$zutil(141)-5
	Set rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	;Set ^Temp("web.DHCENS.STBLL.DICTNew.METHOD.Common","ClassQuery2JsonQ")=execute
	Xecute execute
	Set myjsonstr=""
	Quit:'##class(websys.Conversions).IsValidResultSet(rs) "Not Vaild ResultSet"
	Set cnt=0,rtn=""
	Set displayRows=0
	Set columns=rs.GetColumnCount()
	Set end=start+limit
	while(rs.Next()){
		set cnt = cnt + 1
		continue:(cnt<=start)
		continue:(cnt>end)
		set row = ""
		for i=1:1:columns {
			set isString = $Case(rs.GetColumnType(i),3:0,5:0,16:0,:1)
			if (isString){
				set row = row_$case(i,1:"",:",")_""""_rs.GetColumnName(i)_""":"""_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(rs.GetData(i))_""""
			}else{
				set row = row_$case(i,1:"",:",")_""""_rs.GetColumnName(i)_""":"_##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).EvalJSONNew(rs.GetData(i))
			}
		}
		Set rtn = rtn_$case(displayRows,0:"",:",")_"{"_row_"}"
		set displayRows = displayRows+1
	}
	set total = cnt
	quit "["_rtn_"]"
}

/// @author Lid
/// @date   2017-07-28
/// @param: Object  pStream  要转换成对象的json数据流
/// @param: %RegisteredObject pObject 要转换的对象
/// @param: %String  pClass	要转换的对象的类名，不传入默认为$classname(pObject)
/// JSON流转为对象
ClassMethod JSONStreamToObject(pStream, Output pObject As %RegisteredObject, pClass As %String = "") As %Status
{
	if $g(pClass)="" s cn = $CLASSNAME(pObject)
	set tSC=..ParseJSON(pStream,pClass,.pObject)
	quit tSC
}

/// @author Lid
/// @date   2017-07-28
/// @param: Object  pObject  要转换成JSON流的对象
/// @param: %GlobalCharacterStream  pStream	JSON流
/// @param: %String  pClass 不传入默认为$classname(Obj)
/// @param: web.DHCENS.STBLL.DICTNew.METHOD.Common jsonObject 确定Obj转成什么样的Json
/// 对象转JSON流
/// Other:存在的问题，如果json传超长，可能会报“字符串超长”的错误
ClassMethod ObjectToJSONStream(pObject As %RegisteredObject, ByRef pStream, pClass As %String = "", jsonObject As web.DHCENS.STBLL.DICTNew.METHOD.Common = "") As %Status
{
	set tSC = $$$OK
	set pStream=##class(%GlobalCharacterStream).%New()
	set tSC=pStream.Write(##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(pObject,pClass,jsonObject))
	quit tSC
}

ClassMethod ParseJSON(pJSON As %String, pClass As %String = "", Output pObject As %RegisteredObject, Output pCharsProcessed As %Integer, pLevel As %Integer = 1, pFirstChar As %String = "", pIgnoreUnknownProps As %Boolean = 0) As %Status [ Internal ]
{
#define WHITESPACE(%c) (((%c)=" ")||((%c)=$C(10))||((%c)=$C(13))||((%c)=$C(9)))
#define MATCHHEXCHARS(%hex,%n) (%hex ? %n(1N,1(1"A",1"B",1"C",1"D",1"E",1"F",1"a",1"b",1"c",1"d",1"e",1"f")))

	Set tSC = $$$OK
	Try {
		Set tOrigClass = pClass
		Set tClass = $S(pClass="":"%ZEN.proxyObject",1:pClass)
		Set pObject = ""
		Set pCharsProcessed = 0

		Set p = 1
		Set tToken = ""
		Set tProperty = ""
		Set tValue = ""
		Set tState = 0
		Set tInArray = 0
		Set tArrayType = ""
		Set tArrayState = "value"
		Set tArrayKey = ""
		Set tIsString = 0
		Set tQuote = ""
		Set tPropQuoted = 0
		Set tUnicodeHex = ""
		Set tHex = ""
		Set tJSONArray = 0
		While ($$$ISOK(tSC)) {
			// test end condition; get next character
			If ($IsObject(pJSON)) {
				If (pFirstChar'="") {
					Set ch = pFirstChar
					Set pFirstChar = ""
				}
				Else {
	 				If (pJSON.AtEnd) Quit
					Set ch = pJSON.Read(1,.tSC)
					If $$$ISERR(tSC) Quit
				}
			}
			Else {
 				If (p > $L(pJSON)) Quit
				Set ch = $E(pJSON,p)
			}

			Set p = p + 1
			Set pCharsProcessed = pCharsProcessed + 1
			If (tState = 0) {
				If (ch = "{") {
					// start of object
					// we will hold the property values in here until the end
					Kill tPropValues	
					Set pObject = ""
					Set tState = 1
				}
				ElseIf (ch = "[") {
					Set tJSONArray = 1
					Kill tPropValues
					Set pObject = ""
					Set tCollectionClass = $select((pClass '= "")&&$classmethod(pClass,"%Extends","%Collection.AbstractList"): pClass, 1 :"")
					// start of list/array-valued property
					Set tInArray = 1
					Set tArrayType = "list"
					Kill tArray
					Set tArrayIndex = 0
					Set tToken = ""
					Set tIsString = 0
					Set tState = 5
					Set tArrayState = "value"
				}
				ElseIf '$$$WHITESPACE(ch) {
					Set tSC = $$$ERROR($$$GeneralError,"Expected { at start of JSON text.")
					Quit
				}
			}
			ElseIf (tState = 1) {
				If (ch = "}") {
					// end of object
					// create object, stuff properties into it
					Set pClass = $G(tPropValues("_class"),pClass)
					Set tClass = $G(tPropValues("_class"),tClass)
					Set pObject = $classmethod(tClass,"%New")
					Set p = $O(tPropValues(""))
					While (p'="") {
						If (p '= "_class") && (p '= "_id") {
							Try {
								// test for stream property
								Set tStream = $property(pObject,p)
								If ($IsObject(tStream) && (tStream.%Extends("%Stream.Object") || tStream.%Extends("%IO.I.Stream"))) {
									Do tStream.Rewind()
									Do tStream.Write($G(tPropValues(p)))
								}
								Else {
									Set $property(pObject,p) = $G(tPropValues(p))
								}
							}
							Catch ex {
								If $case(ex.Name, "<CANNOT SET THIS PROPERTY>" : 0, "<PROPERTY DOES NOT EXIST>": 'pIgnoreUnknownProps, :1) Throw ex
							}
						}
						Set p = $O(tPropValues(p))
					}
					Quit
				}
				ElseIf (ch = """") && ('tPropQuoted) {
					Set tPropQuoted = 1
				}
				ElseIf ('$$$WHITESPACE(ch) && (ch'="")) {
					// start of property name
					Set tToken = ch
					Set tState = 2
				}
			}
			ElseIf (tState = 2) {
				// property name
				If (ch = "\") {
					Set tState = "2a"
				}
				ElseIf (tPropQuoted) {
					If (ch = """") {
						Set tPropQuoted = 0
					}
					Else {
						Set:'$IsObject(tToken) tToken = tToken _ ch
					}
				}
				Else {
					If (ch = ":") {
						Set tProperty = tToken
						#; Set tProperty = $select($IsObject(tToken): tToken, 1: ..%UnescapeJSONString(tToken))
						Set tToken = ""
						Set tState = 3
						Set tIsString = 0
					}
					ElseIf ('$$$WHITESPACE(ch)) {
						Set:'$IsObject(tToken) tToken = tToken _ ch
					}
				}
			}
			// NOTE: States 2a, 2b and 2c are defined as the last few states as we expect escaped property names to be very rare
			ElseIf (tState = 3) {
				// value
				If (ch = ",") {
					// end of value
					If (tIsString || $IsObject(tToken)) {
						Set tValue = tToken
					}
					Else {
						Set tValue = $Case(tToken,"null":"","true":1,"false":0,:+tToken)
					}
					If (tProperty '= "") {
						Set tPropValues(tProperty) = tValue
					}
					Set pClass = $G(tPropValues("_class"),pClass)
					Set tToken = ""
					Set tValue = ""
					Set tState = 1
				}
				ElseIf (ch = "}") {
					// end of value and object
					If (tIsString || $IsObject(tToken)) {
						Set tValue = tToken
					}
					Else {
						Set tValue = $Case(tToken,"null":"","true":1,"false":0,:+tToken)
					}
					If (tProperty '= "") {
						Set tPropValues(tProperty) = tValue
					}

					// create object, stuff properties into it
					Set pClass = $G(tPropValues("_class"),pClass)
					Set tClass = $G(tPropValues("_class"),tClass)
					Set pObject = $classmethod(tClass,"%New")

					Set p = $O(tPropValues(""))
					While (p'="") {
						If (p '= "_class") && (p '= "_id") {
							Try {
								// test for stream property
								Set tStream = $property(pObject,p)
								If ($IsObject(tStream) && (tStream.%Extends("%Stream.Object") || tStream.%Extends("%IO.I.Stream"))) {
									Do tStream.Rewind()
									Do tStream.Write($G(tPropValues(p)))
								}
								Else {
									Set $property(pObject,p) = $G(tPropValues(p))
								}
							}
							Catch ex {
								If $case(ex.Name, "<CANNOT SET THIS PROPERTY>": 0, "<PROPERTY DOES NOT EXIST>": 'pIgnoreUnknownProps, :1) Throw ex
							}
						}
						Set p = $O(tPropValues(p))
					}
					Set tToken = ""
					Set tValue = ""
					Quit
				}
				ElseIf (ch = "{") {
					// start of object-valued property
					Set pClass = $G(tPropValues("_class"),pClass)

					If ((pClass="")||(tProperty="")) {
						Set tChildClass = ""
						Set tCollection = ""
					}
					Else {
						// lookup type in meta data
						Set tChildClass = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
						Set tCollection = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPcollection)
					}
					// Note: This if block assumes pClass and tProperty are defined when tCollection '= ""
					If (tCollection = "array") {
						// start of array-valued property
						Set tArrayType = "array"
						Set tArrayKey = ""
						Set tInArray = 1
						Kill tArray
						Set tToken = ""
						Set tIsString = 0
						Set tState = 5
						Set tArrayState = "name"

						// look up the runtime type of the array
						// set tCollectionClass to the runtime type if the runtime type is not in %Library or %Collection
						Set tCollectionClass = ""
						Set tArrayRuntimeType = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPruntimetype)
						If (tArrayRuntimeType '= "") {
							Set tArrayRuntimePackage = $piece(tArrayRuntimeType,".",1)
							If (tArrayRuntimePackage '= "%Library") && (tArrayRuntimePackage '= "%Collection") {
								Set tCollectionClass = tArrayRuntimeType
							}
						}
					}
					Else {
						If ($IsObject(pJSON)) {
							Set tSubJSON = pJSON
							Set tPoke = ch  // simulate stream unwind
						}
						Else {
							Set tSubJSON = $E(pJSON,p-1,*)
							Set tPoke = ""
						}
						Set tSC = ..ParseJSON(tSubJSON,tChildClass,.tToken,.tChars,pLevel+1,tPoke,pIgnoreUnknownProps)
						If $$$ISERR(tSC) Quit
						Set p = p + tChars - 1
						Set pCharsProcessed = pCharsProcessed + tChars - 1
					}
				}
				ElseIf (ch = "[") {
					Set tCollectionClass = ""
					If ((pClass'="")&&(tProperty'="")) {
						// lookup type in meta data
						// we could have a normal collection: List Of PropType
						// OR
						// the proptype could be a subclass of a collection
						Set tCollectionClass = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
						If (tCollectionClass '= "") && (($$$comClassKeyGet(tCollectionClass,$$$cCLASSclasstype)="datatype") || '$classmethod(tCollectionClass,"%Extends","%Collection.AbstractIterator")) {
							// use "built-in" collection
							Set tCollectionClass = ""
						}
					}

					// start of list/array-valued property
					Set tInArray = 1
					Set tArrayType = "list"
					Kill tArray
					Set tArrayIndex = 0
					Set tToken = ""
					Set tIsString = 0
					Set tState = 5
					Set tArrayState = "value"
				}
				ElseIf ((ch = """")||(ch = "'")) {
					// start of string
					Set tToken = ""
					Set tIsString = 1
					Set tQuote = ch
					Set tState = 4
				}
				ElseIf ('$$$WHITESPACE(ch)) {
					// must be a numeric value, or true,false,or null
					Set:'$IsObject(tToken) tToken = tToken _ ch
				}
			}
			ElseIf (tState = 4) {
				// string literal
				If (ch = "\") {
					// escape?
					Set tState = "4a"
				}
				ElseIf (ch = tQuote) {
					// end of string
					If (tInArray) {
						Set tState = 5
					}
					Else {
						Set tState = 3
					}
				}
				Else {
					Set:'$IsObject(tToken) tToken = tToken _ ch
				}
			}
			// NOTE: States 4a, 4b and 4c are defined *after* state 5 as we expect escaped text less often than arrays (state 5)
			ElseIf (tState = 5) {
				// array items
				If (ch = ",") {
					// end of array item
					If (tArrayType = "list") {
						Set tArrayIndex = tArrayIndex + 1
					}
					If (tIsString || $IsObject(tToken)) {
						Set tValue = tToken
					}
					Else {
						Set tValue = $Case(tToken,"null":"","true":1,"false":0,:+tToken)
					}
					If (tArrayType = "list") {
						Set tArray(tArrayIndex) = tValue
					}
					ElseIf (tArrayKey'="") {
						Set tArray(tArrayKey) = tValue
					}
					Set tToken = ""
					Set tArrayKey = ""
					Set tIsString = 0
					If (tArrayType = "list") {
						Set tArrayState = "value"
					}
					Else {
						Set tArrayState = "name"
					}
				}
				ElseIf ((tArrayType="list")&&(ch = "]")) {
					// end of list array
					If (tToken '= "") {
						Set tArrayIndex = tArrayIndex + 1
						If (tIsString || $IsObject(tToken)) {
							Set tValue = tToken
						}
						Else {
							Set tValue = $Case(tToken,"null":"","true":1,"false":0,:+tToken)
						}
						Set tArray(tArrayIndex) = tValue
					}

					If ($G(tCollectionClass)'="") {
						Set tListObj = $classmethod(tCollectionClass,"%New")
					}
					Else {
						#; Look for first non-"" value to determine whether the list contains objects or datatypes
						Set tUseObjectArray = 1
						Set n = $O(tArray(""))
						While n {
							If $IsObject($G(tArray(n))) Quit
							If ($G(tArray(n)) '= "") {
								Set tUseObjectArray = 0
								Quit
							}
							Set n = $O(tArray(n))
						}
						Set tListObj = $select(tUseObjectArray: ##class(%Library.ListOfObjects).%New(), 1: ##class(%Library.ListOfDataTypes).%New())
					}
					Set tCollectionClass = ""
					Set n = $O(tArray(""))
					While (n'="") {
						Do tListObj.Insert(tArray(n))
						Set n = $O(tArray(n))
					}

					Set tToken = tListObj
					Set tListObj = ""
					Set tInArray = 0
					Kill tArray
					Set tArrayIndex = 0
					Set tState = 3
					If tJSONArray {
						Set pObject = tToken
						Set tJSONArray = 0
						Quit
					}
				}
				ElseIf ((tArrayType="array")&&(ch = "}")) {
					// end of array
					If (tToken '= "") {
						If (tIsString || $IsObject(tToken)) {
							Set tValue = tToken
						}
						Else {
							Set tValue = $Case(tToken,"null":"","true":1,"false":0,:+tToken)
						}
						If (tArrayKey'="") {
							Set tArray(tArrayKey) = tValue
						}
					}

					If ($G(tCollectionClass)'="") {
						Set tArrayObj = $classmethod(tCollectionClass,"%New")
					}
					Else {
						Set tUseObjectArray = 1
						Set n = $O(tArray(""))
						While n '= "" {
							If $IsObject($G(tArray(n))) Quit
							If ($G(tArray(n)) '= "") {
								Set tUseObjectArray = 0
								Quit
							}
							Set n = $O(tArray(n))
						}
						Set tArrayObj = $select(tUseObjectArray: ##class(%Library.ArrayOfObjects).%New(), 1: ##class(%Library.ArrayOfDataTypes).%New())
					}
					Set tCollectionClass = ""

					Set n = $O(tArray(""))
					While (n'="") {
						Do tArrayObj.SetAt(tArray(n),n)
						Set n = $O(tArray(n))
					}

					Set tToken = tArrayObj
					Set tArrayObj = ""
					Set tInArray = 0
					Kill tArray
					Set tArrayIndex = 0
					Set tArrayKey = ""
					Set tState = 3
				}
				ElseIf (ch = "{") {
					// object-valued item: token is the object
					If (pClass'="") && (tProperty="") && $classmethod(pClass,"%Extends","%Library.ListOfObjects") {
						Set tPropElementType = $parameter(pClass,"ELEMENTTYPE")
						Set tChildClass = $select(tPropElementType = "%RegisteredObject": "", 1: tPropElementType)
					}
					ElseIf ((pClass="")||(tProperty="")) {
						Set tChildClass = ""
					}
					Else {
						// lookup type in meta data
						If (tCollectionClass="") {
							// property types tells us the type of items in the collection
							Set tChildClass = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
						}
						Else {
							// we have to get the element type from the collection class
							Set tChildClass = $parameter(tCollectionClass,"ELEMENTTYPE")
						}
					}
					If ($IsObject(pJSON)) {
						Set tSubJSON = pJSON
						Set tPoke = ch  // simulate stream unwind
					}
					Else {
						Set tSubJSON = $E(pJSON,p-1,*)
						Set tPoke = ""
					}
						
					Set tSC = ..ParseJSON(tSubJSON,tChildClass,.tToken,.tChars,pLevel+1,tPoke,pIgnoreUnknownProps)
					If $$$ISERR(tSC) Quit
					Set p = p + tChars - 1
					Set pCharsProcessed = pCharsProcessed + tChars - 1
				}
				ElseIf (ch = "[") {
					If ((pClass="")||(tProperty="")) {
						Set tChildCollectionClass = ""
					}
					Else {
						Set tChildCollectionClass = $$$comMemberKeyGet(pClass,$$$cCLASSproperty,tProperty,$$$cPROPtype)
						If (tChildCollectionClass '= "") && (($$$comClassKeyGet(tCollectionClass,$$$cCLASSclasstype)="datatype") || '$classmethod(tCollectionClass,"%Extends","%Collection.AbstractIterator")) {
							// use "built-in" collection
							Set tChildCollectionClass = ""
						}
					}
					If ($IsObject(pJSON)) {
						Set tSubJSON = pJSON
						Set tPoke = ch  // simulate stream unwind
					}
					Else {
						Set tSubJSON = $E(pJSON,p-1,*)
						Set tPoke = ""
					}
					Set tSC = ..ParseJSON(tSubJSON,tChildCollectionClass,.tToken,.tChars,pLevel+1,tPoke,pIgnoreUnknownProps)
					If $$$ISERR(tSC) Quit
					Set p = p + tChars - 1
					Set pCharsProcessed = pCharsProcessed + tChars - 1
				}
				ElseIf ((ch = """")||(ch = "'")) {
					// start of string
					Set tToken = ""
					Set tIsString = 1
					Set tQuote = ch
					Set tState = 4
				}
				ElseIf ((tArrayType="array")&&(ch=":")) {
					// end of name
					If (tArrayState = "name") {
						Set tArrayState = "value"
						Set tArrayKey = tToken
						Set tToken = ""
					}
				}
				ElseIf ('$$$WHITESPACE(ch)) {
					// literal
					Set:'$IsObject(tToken) tToken = tToken _ ch
				}
			}
			// NOTE: States 4a, 4b and 4c precede states 2a, 2b and 2c as we expect literal strings to need escaping more often than property names
			ElseIf (tState = "4a") {
				// \ in string
				If (ch = "u") {
					Set tUnicodeHex = ""
					Set tState = "4b"
				}
				// add special case support for \xNN escape sequences that are valid in Javascript
				ElseIf (ch = "x") {
					Set tHex = ""
					Set tState = "4c"
				}
				Else {
					// Support escape sequences defined in RFC 4627, as well as \'
					Set tToken = tToken _ $Case(ch, "\": "\", "'": "'", """": """", "/": "/", "b": $char(8), "f": $char(12), "n": $char(10), "r": $char(13), "t": $char(9), : "\" _ ch)
					Set tState = 4
				}
			}
			ElseIf (tState = "4b") {
				// in \uXXXX escape sequence
				Set tUnicodeHex = tUnicodeHex _ ch
				If ($length(tUnicodeHex) = 4) {
					// Check that we do actually have a Hex value
					If $$$MATCHHEXCHARS(tUnicodeHex,4) {
						Set tUnicodeDecimal = $zhex(tUnicodeHex)
						Set tToken = tToken _ $char(tUnicodeDecimal)
					}
					Else {
						Set tToken = tToken _ "\u" _ tUnicodeHex
					}
					Set tState = 4
				}
			}
			ElseIf (tState = "4c") {
				// in \xNN escape sequence
				Set tHex = tHex _ ch
				If ($length(tHex) = 2) {
					// Check that we do actually have a Hex value
					If $$$MATCHHEXCHARS(tHex,2) {
						Set tCodeDecimal = $zhex(tHex)
						Set tToken = tToken _ $char(tCodeDecimal)
					}
					Else { // Not a hex escape
						Set tToken = tToken _ "\x" _ tHex
					}
					Set tState = 4
				}
			}
			ElseIf (tState = "2a") {
				// \ in property name
				If (ch = "u") {
					Set tUnicodeHex = ""
					Set tState = "2b"
				}
				// add special case support for \xNN escape sequences that are valid in Javascript
				ElseIf (ch = "x") {
					Set tHex = ""
					Set tState = "2c"
				}
				Else {
					// Support escape sequences defined in RFC 4627, as well as \'
					Set tToken = tToken _ $Case(ch, "\": "\", "'": "'", """": """", "/": "/", "b": $char(8), "f": $char(12), "n": $char(10), "r": $char(13), "t": $char(9), : "\" _ ch)
					Set tState = 2
				}
			}
			ElseIf (tState = "2b") {
				// in \uXXXX escape sequence
				Set tUnicodeHex = tUnicodeHex _ ch
				If ($length(tUnicodeHex) = 4) {
					#; Check that we do actually have a Hex value
					If $$$MATCHHEXCHARS(tUnicodeHex,4) {
						Set tUnicodeDecimal = $zhex(tUnicodeHex)
						Set tToken = tToken _ $char(tUnicodeDecimal)
					}
					Else {
						Set tToken = tToken _ "\u" _ tUnicodeHex
					}
					Set tState = 2
				}
			}
			ElseIf (tState = "2c") {
				// in \xNN escape sequence
				Set tHex = tHex _ ch
				If ($length(tHex) = 2) {
					#; Check that we do actually have a Hex value
					If $$$MATCHHEXCHARS(tHex,2) {
						Set tCodeDecimal = $zhex(tHex)
						Set tToken = tToken _ $char(tCodeDecimal)
					}
					Else { // Not a hex escape
						Set tToken = tToken _ "\x" _ tHex
					}
					Set tState = 2
				}
			}
		}
	}
	Catch ex {
		// Do ..%WriteJSONToFile(pJSON,"jsonout.txt")
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// 按标准JSON来处理字符转义
ClassMethod EvalJSONNew(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr
	s mystr = ..Replace(mystr,"\", "\\")
	s mystr = ..Replace(mystr,"""", "\""")
	s mystr = ..Replace(mystr,$c(8), "\b") 			// 退格(BS)
	s mystr = ..Replace(mystr,$c(9), "\t")
	s mystr = ..Replace(mystr,$c(10), "\n")
	s mystr = ..Replace(mystr,$c(12), "") // FF(NP from feed, new page)
	s mystr = ..Replace(mystr,$c(13), "\r")
	s mystr = ..Replace(mystr,$c(14), "") //SO(shift out)  
	s mystr = ..Replace(mystr,$c(0), "")
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

}
