Class web.DHCAPPJsonObject Extends %Persistent [ LegacyInstanceContext ]
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
	.if $IsObject(value)&&($CLASSNAME(value)="web.DHCAPPJsonObject") set json=value.Json()
	.else  if $IsObject(value) set json = $this.Obj2Json(value,$CLASSNAME(value))
	.else  set json = """"_value_""""
	.quit:(json="""""")||(json="{}")
	.set json=""""_key_""":"_json
	.set rtn=$case(rtn,"":"",:rtn_",")_json	
	quit "["_rtn_"]"
}

/// 不支持属性
ClassMethod ArrayToJson(ArrObj)
{
	Set rtn = ""
	Set key=""
	For  Set value=ArrObj.GetNext(.key) Quit:key=""  d
	.if $IsObject(value)&&($CLASSNAME(value)="web.DHCAPPJsonObject") set json=value.Json()
	.else  if $IsObject(value) set json = ..ObjToJson(value,$CLASSNAME(value))
	.else  set json = """"_value_""""
	.quit:(json="""""")||(json="{}")
	.set json=""""_key_""":"_json
	.set rtn=$case(rtn,"":"",:rtn_",")_json	
	quit "["_rtn_"]"
}

/// 支持属性
Method List2Json(ListObj)
{
	Set rtn = ""
	Set len = ListObj.Count()
	for j=1:1:len d
	.set o = ListObj.GetAt(j)
	.if $IsObject(o)&&($CLASSNAME(o)="web.DHCAPPJsonObject") set json=o.Json()
	.else  if $IsObject(o) set json = $this.Obj2Json(o,$CLASSNAME(o))
	.else  set json = """"_o_""""
	.quit:(json="""""")||(json="{}")
	.set rtn=$case(rtn,"":"",:rtn_",")_json
	quit "["_rtn_"]"
}

/// 不支持属性
ClassMethod ListToJson(ListObj)
{
	Set rtn = ""
	Set len = ListObj.Count()
	for j=1:1:len d
	.set o = ListObj.GetAt(j)
	.if $IsObject(o)&&($CLASSNAME(o)="web.DHCAPPJsonObject") set json=o.Json()
	.else  if $IsObject(o) set json = ..ObjToJson(o,$CLASSNAME(o))
	.else  set json = """"_o_""""
	.quit:(json="""""")||(json="{}")
	.set rtn=$case(rtn,"":"",:rtn_",")_json
	quit "["_rtn_"]"
}

/// @param: Object  Obj   要转成json的对象
/// @param: %String  className 不传入默认为$classname(Obj)
/// @param: web.DHCAPPJsonObject 确定Obj转成什么样的Json
ClassMethod ObjToJson(Obj, className As %String = "", jsonObject As web.DHCAPPJsonObject = "")
{
	set jsonObj = ##class(web.DHCAPPJsonObject).%New()
	if $IsObject(jsonObject){
		set jsonObj.ContainNullArray = jsonObject.ContainNullArray
		set jsonObj.ContainNullObject = jsonObject.ContainNullObject
		set jsonObj.ContainNullValue = jsonObject.ContainNullValue
		set jsonObj.DateFormat = jsonObject.DateFormat
		set jsonObj.TimeFormat = jsonObject.TimeFormat
	}
	set json = jsonObj.FromObject(Obj,.className,1).Json()
	do jsonObj.Clear()	
	set jsonObj=""
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
/// 	s jsonObj = ##class(web.DHCAPPJsonObject).%New()
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
	..;s type = propObj.Type		;如果是listofobj,则显示为list内对象的type
	..set runtimeType = propObj.RuntimeType,type=runtimeType
	..if (runtimeType="%Library.CacheObject")&&$IsObject(PropertyValue) set type=$CLASSNAME(PropertyValue) ;$classname(%String)=val
	..s private = propObj.Private
	..q:(private=1)
	..; 指向
	..if $e(type,1)'="%"  set value = $s(isRefValue=0:..ObjToJson(PropertyValue,type,$this),1:$ZOBJMETHOD(bean,PropertyName_"GetObjectId"))
	..else  d
	...if (type["ListOf") set value = ..ListToJson(PropertyValue)
	...if (type["ArrayOf") set value = ..ArrayToJson(PropertyValue)	
	...if value="" s value = PropertyValue			//String , Number
	...if (type["Date")&&(value'="") s value=$zd(value, i%DateFormat)
	...if (type["Time")&&(value'="") s value=$zt(value, i%TimeFormat)
	..;i (type="%Float")&&(value'="")
	..Q:('i%ContainNullValue)&&(value="")
	..Q:('i%ContainNullObject)&&(value="{}")
	..Q:('i%ContainNullArray)&&(value="[]")
	..d %this.Put(PropertyName,value)
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

Method Put(key, value) As JsonObject
{
	q:key="" %this
	if $e(key,1,1)="'",$e(key,$l(key),$l(key))="'"{
		set key = $e(key,2,$l(key)-1) 				;Put("'key'","val")
	}
	if $e(value,1,1)="'",$e(value,$l(value),$l(value))="'"{
		set value = $e(value,2,$l(value)-1)			;Put("key","'val'")
	}
	Set i%Data(key)=value
	q %this
}

Method Json() As %Library.String
{
	Set json=""
	Set key=$order(i%Data(""))
	i key'="" d
	.Set value = i%Data(key)
	.Set len = $l(value)
	.;Set json=""""_key_""""_":"_$s(value?1.N>0:value,1:""""_value_"""")  ;如果数字是以0开头，js会看成是8进制数字\
	.If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = """"_key_""":"_value
	.;If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = "'"_key_"':"_value
	.;else  Set json = "'"_key_"':'"_##class(ext.util.String).EvalJSON(value)_"'"
	.else  Set json = """"_key_""":"""_##class(ext.util.String).EvalJSON(value)_""""
	.For  Set key=$order(i%Data(key)) Quit:key=""  d 
	..set value = i%Data(key)
	..Set len = $l(value)
	..;set value = $s(value?1.N>0:value,1:""""_value_"""")	
	..;If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = json_",'"_key_"':"_value
	..If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = json_","""_key_""":"_value
	..;else  Set json = json_",'"_key_"':'"_##class(ext.util.String).EvalJSON(value)_"'"
	..else  Set json = json_","""_key_""":"""_##class(ext.util.String).EvalJSON(value)_""""
	q "{"_json_"}"
}

/// @param %string className
/// 把该web.DHCAPPJsonObject对象转成对应的classname对象，并返回
Method Bean(className As %String) As %ObjectHandle
{
	s dcd = ##Class(%Dictionary.ClassDefinition).%OpenId(className)
	q:'$IsObject(dcd) "没有找到"_className_"类"

	if ($d(i%Data("ID")) && +i%Data("ID")>0) d
	.s bean = $classmethod(className,"%OpenId",i%Data("ID"))
	else  d
	.s bean = $classmethod(className,"%New")
	s cnt=dcd.Properties.Count()
	f i=1:1:cnt  d
	.s propObj = dcd.Properties.GetAt(i)
	.s PropertyName = propObj.Name
	.q:$e(PropertyName,1)="%"
	.q:propObj.Cardinality="children"
	.s type = propObj.Type
	.s private = propObj.Private
	.q:private=1
	.q:$d(i%Data(PropertyName))=0
	.s value = i%Data(PropertyName)
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

/// @param : %String jsonstr {name:"wanghc",age:1}
/// 把jsonstr转成jsonObject对象.现仅支持一级简单的json
ClassMethod FromJSON(jsonstr As %String) As JsonObject
{
	if jsonstr="{}" Quit ""
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s obj = ##class(web.DHCAPPJsonObject).%New()
	s len=$length(tempstr,",")
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$P(tempstr1,":",2)
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

/// 请空JSON数据
Method Clear()
{
	K i%Data
}

/// w ##class(web.DHCAPPJsonObject).Test()
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
	Set jsonstr = "{name:""wanghc"",age:18}"
	Set jsonObj = ##class(web.DHCAPPJsonObject).FromJSON(jsonstr)
	w "    "_jsonObj.GetValue("name"),!
	w "    "_jsonObj.GetValue("age"),!
}

ClassMethod PutTest()
{
	;;Put方法写入数据
	s obj = ##class(web.DHCAPPJsonObject).%New()
	d obj.Put("weight",120).Put("name","wanghc").Put("sex","man")
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
	s obj = ##class(web.DHCAPPJsonObject).%New() 
	;s obj.ContainNullArray=1
	;s obj.ContainNullObject=1
	;s obj.ContainNullValue=1
	;不建议转关联多的对象
	s pm = ##class(User.PAPatMas).%OpenId(2,0)
	w obj.FromObject(pm).Json(),!
	s pm=""
	d obj.Clear()
	d obj.%Close()
	s obj = ""
	q ""
}

ClassMethod CollTest()
{
	s obj = ##class(web.DHCAPPJsonObject).%New() 
	s jo = ##class(Test.ExtJsonObject).InitData()
	s obj.ContainNullValue=1
	s obj.ContainNullArray=1
	s obj.ContainNullObject=1
	w obj.FromObject(jo).Json(),!
	s jo=""
	d obj.Clear()
	d obj.%Close()
	s obj = ""
	q ""
}

/// Write出Json ,用于直接输出到界面 , 不会超长
/// d ##class(web.DHCAPPJsonObject).ClassQuery2Json("web.SSUser","ListAll",0,10,.total,"")
ClassMethod ClassQuery2Json(ClassName, QueryName, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
	New rs,columns,%sc,i,execute,i,cnt
	New pcount Set pcount=$zutil(141)-5
	Set rs=##class(%Library.ResultSet).%New(ClassName_":"_QueryName)
	Set execute="Set %sc=$method(rs,""Execute"""
	For i=1:1:pcount Set execute=execute_",.p"_i
	Set execute=execute_")"
	;Set ^Temp("web.DHCAPPJsonObject","ClassQuery2Json")=execute
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
		for i=1:1:columns set row = row_$case(i,1:"",:",")_""""_rs.GetColumnName(i)_""":"""_##class(ext.util.String).EvalJSON(rs.GetData(i))_""""
		write $case(displayRows,0:"",:","),"{",row,"}"
		set displayRows = displayRows+1
	}
	Write "]"
	set total = cnt
	quit ""
}

Method JsonNoOp() As %Library.String
{
	Set json=""
	Set key=$order(i%Data(""))
	i key'="" d
	.Set value = i%Data(key)
	.Set len = $l(value)
	.;Set json=""""_key_""""_":"_$s(value?1.N>0:value,1:""""_value_"""")  ;如果数字是以0开头，js会看成是8进制数字\
	.If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = """"_key_""":"_value
	.;If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = "'"_key_"':"_value
	.;else  Set json = "'"_key_"':'"_##class(ext.util.String).EvalJSON(value)_"'"
	.else  Set json = """"_key_""":"""_##class(ext.util.String).Replace(value,"""", "\""")_""""
	.For  Set key=$order(i%Data(key)) Quit:key=""  d 
	..set value = i%Data(key)
	..Set len = $l(value)
	..;set value = $s(value?1.N>0:value,1:""""_value_"""")	
	..;If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = json_",'"_key_"':"_value
	..If (($e(value,1,1)="[")&&($e(value,len,len)="]")) || (($e(value,1,1)="{")&&($e(value,len,len)="}")) Set json = json_","""_key_""":"_value
	..;else  Set json = json_",'"_key_"':'"_##class(ext.util.String).EvalJSON(value)_"'"
	..else  Set json = json_","""_key_""":"""_##class(ext.util.String).Replace(value,"""", "\""")_""""
	q "{"_json_"}"
}

Storage Default
{
<Data name="DHCAPPJsonObjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateFormat</Value>
</Value>
<Value name="3">
<Value>TimeFormat</Value>
</Value>
<Value name="4">
<Value>ContainNullValue</Value>
</Value>
<Value name="5">
<Value>ContainNullObject</Value>
</Value>
<Value name="6">
<Value>ContainNullArray</Value>
</Value>
</Data>
<DataLocation>^web.DHCAPPJsonObjectD</DataLocation>
<DefaultData>DHCAPPJsonObjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCAPPJsonObjectD</IdLocation>
<IndexLocation>^web.DHCAPPJsonObjectI</IndexLocation>
<StreamLocation>^web.DHCAPPJsonObjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
