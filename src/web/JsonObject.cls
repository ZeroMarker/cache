/// @author wanghc
/// @date   2012/4/27
/// 对象与json间转换
Class web.JsonObject Extends %RegisteredObject [ LegacyInstanceContext ]
{

Property Data As %String [ MultiDimensional, Private ];

Property DateFormat As %String [ InitialExpression = "3" ];

Property TimeFormat As %String [ InitialExpression = "1" ];

/// 生成的json内是不是包含空值的属性
Property ContainNullValue As %String [ InitialExpression = "0" ];

/// @param: 请求串 或 对象 
/// 例如:EMParentCode=NURPRNOrder&EMCode=NURPRNOrderCancel&EMText=%E6%92%A4%E6%B6%88(DC)
/// 	s obj = ##class(websys.ExtMenu).%OpenId(2,0)
/// 	s jsonObj = ##class(web.JsonObject).%New()
/// 	s json = jsonObj.FromObject(obj).Json()
Method FromObject(bean)
{
	s cn = $CLASSNAME(bean)
	s dcd = ##Class(%Dictionary.ClassDefinition).%OpenId(cn)
	i $IsObject(dcd) d
	.s cnt=dcd.Properties.Count()
	.f i=1:1:cnt  d
	..s propObj = dcd.Properties.GetAt(i)
	..s PropertyName = propObj.Name
	..q:$e(PropertyName,1)="%"
	..q:propObj.Cardinality="children"
	..s type = propObj.Type
	..s private = propObj.Private
	..q:(private=1)  d	
	..i $e(type,1)'="%" d
	...s value = $ZOBJMETHOD(bean,PropertyName_"GetObjectId")
	..e  d	
	...s value = $ZOBJPROPERTY(bean,PropertyName)
	...i ((type="%Library.Date")||(type="%Date"))&&(value'="") s value=$zd(value, i%DateFormat)
	...i ((type="%Library.Time")||(type="%Time"))&&(value'="") s value=$zt(value, i%TimeFormat)
	..;i ((type="%Float")||(type="%Float"))&&(value'="")
	..Q:('i%ContainNullValue)&&(value="")
	..d %this.Put(PropertyName,value)
	..d dcd.%Close()
	.d %this.Put("ID",$ZOBJMETHOD(bean,"%Id"))	
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
	Set i%Data(key)=value
	q %this
}

Method Json() As %Library.String
{
	Set json=""
	Set key=$order(i%Data(""))
	i key'="" d
	.Set value = i%Data(key)
	.Set json=""""_key_""""_":"_$s(value?1.N>0:value,1:""""_value_"""")
	.For  Set key=$order(i%Data(key)) Quit:key=""  d 
	..set value = i%Data(key)
	..set value = $s(value?1.N>0:value,1:""""_value_"""")
	..s json = json_","""_key_""":"_value
	q "{"_json_"}"
}

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

ClassMethod test()
{
	#dim obj As ext.websys.JsonObject
	s obj = ##class(ext.websys.JsonObject).%New()
	d obj.Put("weight",120).Put("name","wanghc").Put("sex","man")
	s pm = ##class(User.CTPayMode).%OpenId(2)
	d obj.fromObject(pm)
	q obj.Json()
}

}
