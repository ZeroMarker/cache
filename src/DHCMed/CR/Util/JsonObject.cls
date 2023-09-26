/// @author wanghc
/// @date   2012/4/27
/// 对象与json间转换
Class DHCMed.CR.Util.JsonObject Extends %RegisteredObject [ LegacyInstanceContext ]
{

Property Data As %String [ MultiDimensional, Private ];

Property DateFormat As %String [ InitialExpression = "3" ];

Property TimeFormat As %String [ InitialExpression = "1" ];

/// 生成的json内是不是包含空值的属性
Property ContainNullValue As %String [ InitialExpression = "0" ];

/// @param: 请求串 或 对象 
/// 例如:EMParentCode=NURPRNOrder&EMCode=NURPRNOrderCancel&EMText=%E6%92%A4%E6%B6%88(DC)
/// 	s obj = ##class(websys.ExtMenu).%OpenId(2,0)
/// 	s jsonObj = ##class(ext.util.JsonObject).%New()
/// 	s json = jsonObj.FromObject(obj).Json()
Method FromObject(bean)
{
	s cn = $ZOBJCLASS(bean)
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(cn)
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
	.d:dcd.ClassType="persistent" %this.Put("ID",$ZOBJMETHOD(bean,"%Id"))	
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
	..set value = """"_value_"""" //$s(value?1.N>0:value,1:""""_value_"""")
	..//s json = json_","""_key_""":"_value
	..s json = json_","_key_":"_value
	q "{"_json_"}"
}

Method Bean(className As %String) As %ObjectHandle
{
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(className)
	q:'$IsObject(dcd) "没有找到"_className_"类"

	if ($d(i%Data("ID")) && +i%Data("ID")>0) d
	.s bean = $ZOBJCLASSMETHOD(className,"%OpenId",i%Data("ID"))
	else  d
	.s bean = $ZOBJCLASSMETHOD(className,"%New")
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
	.;Q:('i%ContainNullValue)&&(value="")
	.i $e(type,1)'="%" d
	..d $ZOBJMETHOD(bean,PropertyName_"SetObjectId",value)
	.e  d	
	..i ((type="%Library.Date")||(type="%Date"))&&(value'="") s value=$zdh(value, i%DateFormat)
	..i ((type="%Library.Time")||(type="%Time"))&&(value'="") d
	...s value=$tr(value,"-",":")    //add by wuqk 2012-11-16
	...s value=$zth(value, i%TimeFormat)
	.s $ZOBJPROPERTY(bean,PropertyName)=value	
	d dcd.%Close()
	s dcd = ""
	q bean
}

ClassMethod ObjectFromJSON(jsonstr As %String, className As %String) As %ObjectHandle
{
	
	if jsonstr="{}" Quit ""
	s jsonstrlen=$length(jsonstr)
	s tempstr=$EXTRACT(jsonstr,2,jsonstrlen-1)
	s obj = ##class(DHCMed.CR.Util.JsonObject).%New()
	s len=$length(tempstr,",")
	for i=1:1:len {
		s tempstr1=$P(tempstr,",",i)
		s name=$P(tempstr1,":",1)
		s value=$P(tempstr1,":",2)
		if name["""" s name=$P(name,"""",2)
		if value["""" s value=$P(value,"""",2)
		d obj.Put(name,value)
	}
	Q obj.Bean(className)
}

/// w ##class(ext.util.JsonObject).test()
ClassMethod test()
{
	//#dim obj As DHCMed.CR.Util.JsonObject  //Modified By LiYang 2014-07-10 老版本兼容，不直接声明变量
	s obj = ##class(DHCMed.CR.Util.JsonObject).%New()
	d obj.Put("weight",120).Put("name","wanghc").Put("sex","man")
	w obj.Json(),!
	
	s pm = ##class(User.CTPayMode).%OpenId(2,0)
	d obj.FromObject(pm)
	w obj.Json()
	d obj.%Close()
	s obj = ""
	q ""
}

/// Creator : wuqk
/// CreatDate : 2012-11-12
/// Description : 将json格式的数组转换为对象列表
/// Input : 
///        jsonstr
///        className
/// Return ：list
/// s list=##class(DHCMed.CR.Util.JsonObject).ObjectListFromJSON(s,"Entity.MetaData")
ClassMethod ObjectListFromJSON(jsonstr As %String, className As %String) As %ListOfObjects
{
	q:($e(jsonstr,1,1)'="[") ""
	q:($e(jsonstr,$l(jsonstr),$l(jsonstr))'="]") ""
	s tmpjson=$e(jsonstr,3,$l(jsonstr)-2)
	s list=##class(%ListOfObjects).%New()
	for i=1:1:$l(tmpjson,"},{") {
		s tmpRow=$p(tmpjson,"},{",i)
		s tmpRow="{"_tmpRow_"}"
		s objMetaData=..ObjectFromJSON(tmpRow,className)
		d list.Insert(objMetaData)
		s objMetaData=""
	}
	q list
}

}
