/// @author wanghc
/// @date   2012/4/27
/// 对象与json间转换
/// update 2018-11-09 调用的EvalJSON方法改为调用EvalJSONNew 按标准JSON转义
/// 2020-2-11 增加对象转成JSON流功能 ##class(ext.util.JsonObject).ObjToJsonStream(Obj)
/// 
Class ext.util.JsonObject Extends %RegisteredObject [ LegacyInstanceContext ]
{

Property Data As %String [ MultiDimensional, Private ];

Property DateFormat As %String [ InitialExpression = "3" ];

Property TimeFormat As %String [ InitialExpression = "1" ];

/// 生成的json内是不是包含空值, 'name':''
Property ContainNullValue As %String [ InitialExpression = "0" ];

/// 生成的json内是不是包含空对象 'dr':{}
Property ContainNullObject As %String [ InitialExpression = "1" ];

/// 生成的json内是不是包含空对象 'child':[]
Property ContainNullArray As %String [ InitialExpression = "1" ];

/// 生成的json内Boolean类型属性1|0转成true|false
/// = true|false 默认为0|1
Property BooleanFormat As %String;

ClassMethod CLASSNAME(%c)
{
}

ClassMethod MethodFun() As %String
{
}

/// 成员方法，支持属性
Method Array2Json(ArrObj)
{
}

/// 不支持属性
ClassMethod ArrayToJson(ArrObj)
{
}

/// 支持属性
Method List2Json(ListObj)
{
}

/// $lb("a","b")==>["a","b"]
ClassMethod LibListToJson(LibListObj)
{
}

/// 不支持属性
ClassMethod ListToJson(ListObj)
{
}

ClassMethod ListToStream(ListObj) As %GlobalCharacterStream
{
}

/// @param: Object  Obj   要转成json的对象
/// @param: %String  className 不传入默认为$classname(Obj)
/// @param: ext.util.JsonObject 确定Obj转成什么样的Json(如ContainNullArray,ContainNullObject,ContainNullValue,DateFormat,TimeFormat)
/// 返回json流
ClassMethod ObjToJsonStream(Obj, cn As %String = "", jo As ext.util.JsonObject = "") As %GlobalCharacterStream
{
}

/// @param: Object  Obj   要转成json的对象
/// @param: %String  className 不传入默认为$classname(Obj)
/// @param: ext.util.JsonObject 确定Obj转成什么样的Json(如ContainNullArray,ContainNullObject,ContainNullValue,DateFormat,TimeFormat)
ClassMethod ObjToJson(Obj, cn As %String = "", jo As ext.util.JsonObject = "")
{
}

/// 对象转成json,成员方法可以设置属性
Method Obj2Json(Obj, cn As %String = "")
{
}

/// @param: %String|Object  bean  请求串String 或 Cache对象 
/// @param: %String   [className] 默认为空, 可选参数
/// @param: %Boolean  isRefValue  默认为0, 1时取指向的值, 0时取指向的json
/// @param: %String   outData     默认为%this.Data() , 把对象属性及值放到此节点下
/// 把各种数据结构的数据 存入 多维数组中，且不可拼串(防字符串超长)
/// 
/// 例如:
/// Set Obj = ##class(ext.util.JsonObject).%New();
/// Obj.FromObject("EMParentCode=NURPRNOrder&EMCode=NURPRNOrderCancel&EMText=%E6%92%A4%E6%B6%88(DC)").Json()
/// Obj.FromObject( ##class(websys.ExtMenu).%OpenId(2,0) ).Json()
/// Obj.FromObject( ListObj )
Method FromObject(bean, ByRef className = "", isRefValue As %Integer = 0, outData = "%this.Data()")
{
}

/// @desc 可以为当前对象设置多层json
/// obj.Puts("rs","total",10)==>{"rs":{"total":10}}
Method Puts(K1, K2, K3, K4, K5, K6, K7, K8, K9, K10)
{
}

/// @param key 键
/// @param value 值
/// @param valueType %Boolean/%Integer/%Float/%String
Method Put(key, value, isRealValue = "") As JsonObject
{
}

/// jsonObj.Put("RegNo",1112).Put("PatName","病人乙")
/// jsonObj.GetPrintData()   //==> RegNo$c(2)1112^PatName$(2)病人乙
/// 组合成xml打印文本区格式
Method GetPrintData() As %Library.String
{
}

Method IsArrayOrObjStr(value)
{
}

/// jsonObj.Put("PatientID",12).Put("EpisodeID",12)
/// jsonObj.ToGetParam()   //==> EpisodeID=12&PatientID=12
/// 排序输出URLParam
Method ToGetParam() As %Library.String
{
}

Method JsonStream() As %GlobalCharacterStream
{
}

ClassMethod GetMaxLen()
{
}

/// 从JSON流中获得字符
Method Json() As %Library.String
{
}

/// @param %string className
/// 把该ext.util.JsonObject对象转成对应的classname对象，并返回
Method Bean(className As %String) As %ObjectHandle
{
}

/// @param : %String jsonstr  指向字段传入Id就成 	{ID:2,PAADMPAPMIDR:1,...}
/// @param : %String className
/// 把jsonstr转成className类的对象
ClassMethod ObjectFromJSON(jsonstr As %String, className As %String) As %ObjectHandle
{
}

/// @param : %String jsonstr  指向字段传入Id就成 	[{ID:2,PAADMPAPMIDR:1,..},{}]
/// @param : %String className
/// 把jsonstr转成Array类的对象
/// 
ClassMethod ArrayFromJSON(jsonstr As %String, className As %String) As %ArrayOfObjects
{
}

/// @param : %String jsonstr  指向字段传入Id就成 [	{ID:2,PAADMPAPMIDR:1,...},{}]
/// @param : %String className
/// 把jsonstr转成list类的对象
ClassMethod ListFromJSON(jsonstr As %String, className As %String) As %ListOfObjects
{
}

/// d ##class(ext.util.JsonObject).FromJson2Global()
Method FromJsonMutil(json, nextisname, inarray)
{
}

/// @param : %String jsonstr {name:"wang:hc",age:1}
/// 把jsonstr转成jsonObject对象. 现仅支持一级简单的json
ClassMethod FromJSON(jsonstr As %String) As JsonObject
{
}

/// W ##class(ext.util.JsonObject).GetJsonByCN("PAPatMas",2)
ClassMethod GetJsonByCN(UserCls, ObjId)
{
}

/// 拿到jsonObject的Key对应的值
Method GetValue(Key)
{
}

/// {rows:[{patname:"xxx"},{patname:"www"}]}====Get("rows",0,"patname")
/// {name:"www"}==Get("name")
/// {data:{total:12,rows:[{},{}]}}==Get("data","total")
Method Get(K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13, K14, K15, K16)
{
}

Method DoData(ByRef PData)
{
}

/// 请空JSON数据
Method Clear()
{
}

/// w ##class(ext.util.JsonObject).Test()
ClassMethod Test()
{
}

ClassMethod GetValueTest()
{
}

ClassMethod PutTest()
{
}

ClassMethod RefTest()
{
}

ClassMethod CollTest()
{
}

/// w ##class(ext.util.JsonObject).URLTest()
ClassMethod ArrTest()
{
}

/// 测试URL转成JSON
/// w ##class(ext.util.JsonObject).URLTest()
ClassMethod URLTest()
{
}

ClassMethod GetTestRecord(ConditionID, TableID)
{
}

/// Write出Array ,用于直接输出到界面 , 不会超长,数组会节省一半空间
/// d ##class(ext.util.JsonObject).ClassQuery2Array("web.SSUser","ListAll",0,10,.total,"")
/// open fileName:"WS"
/// use fileName w "hellow"
/// close fileName
ClassMethod ClassQuery2Array(cn, qn, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
}

/// Write出Json ,用于直接输出到界面 , 不会超长
/// d ##class(ext.util.JsonObject).ClassQuery2Json("web.SSUser","ListAll",0,10,.total,"")
/// open fileName:"WS"
/// use fileName w "hellow"
/// close fileName
/// 3 %Float DOUBLE
/// 4 %CSP.Session/User.SSUser HANDLE
/// 5 %Integer INTEGER
/// 10 %String varchar
/// 16 %Boolean BOOLEAN
ClassMethod ClassQuery2Json(cn, qn, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18) [ ProcedureBlock = 0 ]
{
}

/// Quit出Json , 用于方法调用,拿到返回串,可能超长,可通过入参控制
/// d ##class(ext.util.JsonObject).ClassQuery2Json("web.cqtest.DHCStudent","LookUp",0,10,.total,1)
ClassMethod ClassQuery2JsonQ(ClassName, QueryName, start As %Integer = 0, limit As %Integer = 100, ByRef total, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) [ ProcedureBlock = 0 ]
{
}

/// @author Lid
/// @date   2017-07-28
/// @param: Object  pStream  要转换成对象的json数据流
/// @param: %RegisteredObject pObject 要转换的对象
/// @param: %String  pClass	要转换的对象的类名，不传入默认为$classname(pObject)
/// JSON流转为对象
ClassMethod JSONStreamToObject(pStream, Output pObject As %RegisteredObject, pClass As %String = "") As %Status
{
}

/// @author Lid
/// @date   2017-07-28
/// @param: Object  pObject  要转换成JSON流的对象
/// @param: %GlobalCharacterStream  pStream	JSON流
/// @param: %String  pClass 不传入默认为$classname(Obj)
/// @param: ext.util.JsonObject jsonObject 确定Obj转成什么样的Json
/// 对象转JSON流
/// Other:存在的问题，如果json传超长，可能会报“字符串超长”的错误
ClassMethod ObjectToJSONStream(pObject As %RegisteredObject, ByRef pStream, pClass As %String = "", jsonObject As ext.util.JsonObject = "") As %Status
{
}

ClassMethod ParseJSON(pJSON As %String, pClass As %String = "", Output pObject As %RegisteredObject, Output pCharsProcessed As %Integer, pLevel As %Integer = 1, pFirstChar As %String = "", pIgnoreUnknownProps As %Boolean = 0) As %Status [ Internal ]
{
}

}
