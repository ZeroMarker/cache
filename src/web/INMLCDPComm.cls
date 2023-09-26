Class web.INMLCDPComm Extends %RegisteredObject
{

/// 支持自动映射的数据类型
Parameter Location As COSEXPRESSION = "..SetLocation()";

/// 支持自动映射的数据类型
Parameter DataTypeList As COSEXPRESSION = "$lb(""String"",""Date"",""Time"",""CacheObject"",""ListOfDT"",""ListOfObj"",""GlobalCharacter"")";

/// Creator:liwenzhen
/// Createdate:2022-04-19
/// Description:配置编译类Global位置
/// Input:
/// Output:
/// Other:
/// Test: w ##class(web.INMLCDPComm).SetLocation()
ClassMethod SetLocation() As %ListOfDataTypes
{
    s loaction=##class(%ArrayOfDataTypes).%New()
    d loaction.SetAt(21,"GlobalName") // Global名称位置
    d loaction.SetAt(22,"StorageDataName") // 数据存储节点的名称位置
    d loaction.SetAt(25,"IndexName") // 索引名称位置
    d loaction.SetAt(33,"StreamName") // 流名称位置
    ;w ##class(web.INMCommon).Encode(loaction)
    q loaction
}

/// Creator:liwenzhen
/// Createdate:2022-04-28
/// Description:根据类名获取Storage名称
/// Table:
/// Input：类名
/// Output
/// Return:
ClassMethod GetStorageName(className As %String, key As %String) As %String
{
    q $o(^oddCOM(className,"s",""))
}

/// Creator:liwenzhen
/// Createdate:2022-04-28
/// Description:根据类名获取表名
/// Table:
/// Input：类名
/// Output
/// Return:w $CLASSMETHOD("web.INMLCDPComm","GetTableName","%Studio.ProjectItem")
ClassMethod GetTableName(className As %String) As %String
{
    q:className="" ""
    q $g(^oddCOM(className,53))
}

/// Creator:liwenzhen
/// Createdate:2022-05-05
/// Description:判断实例是否存在
/// Table:
/// Input：
/// Output
/// Return:
/// Others: w ##class(web.INMLCDPComm).IsExistGlo("CF.DHCINM.HR.Educate","1")
ClassMethod IsExistGlo(className As %String, id As %String) As %String
{
    s flag=1
    q:(className="")||(id="") 0
    s globalName=..GetGlobalName(className)
    q:globalName="" 0
    s global=$g(@(globalName_"("_$replace(id,"||",",")_")"))
    q:global="" 0
    q flag
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据类名获取Global名称
/// Input:className 类名 
/// Output:GlobalName Global名
/// Other:
/// Test:
ClassMethod GetGlobalName(className As %String) As %String
{
    s storage=..GetStorageName(className)
    q:storage="" ""
    s name=$g(^oddCOM(className,"s",storage,21)) 
    q name
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据类名获取数据存储节点名称
/// Input:className 类名 
/// Output:数据存储节点名称
/// Other:
/// Test:
ClassMethod GetStorageDataName(className As %String) As %String
{
    s storage=..GetStorageName(className)
    q:storage="" ""
    s name=$g(^oddCOM(className,"s",storage,22)) 
    q name
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据类名获取索引名称
/// Input:className 类名 
/// Output:索引名称
/// Other:
/// Test:
ClassMethod GetIndexName(className As %String) As %String
{
    s storage=..GetStorageName(className)
    q:storage="" ""
    s name=$g(^oddCOM(className,"s",storage,25)) 
    q name
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据类名获取流名称
/// Input:className 类名 
/// Output:流名称
/// Other:
/// Test:
ClassMethod GetStreamName(className As %String) As %String
{
    s storage=..GetStorageName(className)
    q:storage="" ""
    s name=$g(^oddCOM(className,"s",storage,33)) 
    q name
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据类名获取字段名对应Global位置
/// Input:className 类名，tmp：临时数组，type:"I"/"P" tmp输出index为下标或字段名为下标
/// Output:
/// Other:
/// Test:d ##class(web.INMLCDPComm).GetProperties("CT.DHCINM.LCDP.MgIndex",.tmp)
ClassMethod GetProperties(className As %String, tmp As %String, type As %String = "P") As %String
{
    k tmp
    s storageName=..GetStorageName(className) // 取出Storage名称
    s dataName=..GetStorageDataName(className) // 取出数据存储节点的名称
    q:(dataName="")||(storageName="") 0
    s keyIndex="" f  s keyIndex=$O(^oddCOM(className,"s",storageName,"D",dataName,"V",keyIndex)) q:keyIndex=""  d
    .s prop=$g(^oddCOM(className,"s",storageName,"D",dataName,"V",keyIndex,21))
    .q:prop=""
    .q:prop["%"
    .i type="P" s tmp(prop)=keyIndex
    .e  d  s tmp(keyIndex)=prop
    q 1
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据下标获取对应字段名
/// Input:className 类名 index：下标
/// Output:PropName 字段名
/// Other:
/// Test:w ##class(web.INMLCDPComm).GetPropName("CT.DHCINM.LCDP.MgIndex",2)
ClassMethod GetPropName(className As %String, index As %Integer) As %String
{
    s storageName=..GetStorageName(className) 
    s dataName=..GetStorageDataName(className) 
    s propName=$g(^oddCOM(className,"s",storageName,"D",dataName,"V",index,21))
    q propName
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据字段名获取对应下标
/// Input:className 类名 PropName 字段名
/// Output:index：下标
/// Other:
/// Test:w ##class(web.INMLCDPComm).GetPropIndex("CT.DHCINM.LCDP.MgIndex","Status")
ClassMethod GetPropIndex(className As %String, propName As %String) As %String
{
    s (index,flag)=0
    s storageName=..GetStorageName(className) // 取出Storage名称
    s dataName=..GetStorageDataName(className) // 取出数据存储节点的名称
    s keyIndex="" f  s keyIndex=$O(^oddCOM(className,"s",storageName,"D",dataName,"V",keyIndex)) q:(keyIndex="")||(flag=1)  d
    .s prop=$g(^oddCOM(className,"s",storageName,"D",dataName,"V",keyIndex,21))
    .i prop=propName d
    ..s flag=1
    ..s index=keyIndex
    q index
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据字段名获取字段类型
/// Input:className 类名 propName 字段名 type:D/R/C D编译时类型 R运行时类型 CacheObject类型
/// Output:数据类型
/// Other:
/// Test:w ##class(web.INMLCDPComm).GetPropDataType("CT.DHCINM.LCDP.MgForm","FormJson","C")
ClassMethod GetPropDataType(className As %String = "", propName As %String = "", type As %String = "R") As %String
{
    q:(className="")||(propName="") ""
    i type="R" d
    .s dataType=$g(^oddCOM(className,"a",propName,40)) // 运行时类型
    .s:dataType'["%" dataType=$g(^oddCOM(className,"a",propName,"m","GetSwizzled",2)) //自定义引用类型转换为%Library.CacheObject
    .s dataType=$p(dataType,".",*)
    .s:dataType="Object" dataType="CacheObject"
    i type="D" d
    .s dataType=$g(^oddCOM(className,"a",propName,5)) 
    i type="C" d
    .s dataType=$g(^oddCOM(className,"a",propName,40))
    q dataType
}

/// Creator:liwenzhen
/// Createdate:2022-7-21
/// Description:根据List字段名获取Listof类型
/// Input:className 类名 propName 字段名 type:D/R D编译时类型 R运行时类型
/// Output:数据类型
/// Other:
/// Test:w ##class(web.INMLCDPComm).GetPropDataType("DHCINM.HB.MgExam","WardLo")
ClassMethod GetListofType(className As %String, propName As %String, type As %String = "D") As %String
{
    q ^oddDEF(className,"a",propName,5)
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:判断类是否存在
/// Input:className 类名 className
/// Output:1：存在 0：不存在
/// Other:
/// Test:w ##class(web.INMLCDPComm).IsExistClass("DHCINM.HB.MgExam")
ClassMethod IsExistClass(className As %String = "") As %String
{
    s flag=1
    s:$d( ^oddCOM(className))=0 flag=0
    q flag
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:获取当前类是否具有关系属性（父表）
/// Input:className 类名 
/// Output:
/// Other:
/// Test:w ##class(web.INMLCDPComm).GetRelationship("CT.DHCINM.DB.MgMOrderSub")
ClassMethod GetRelationship(className As %String = "") As %String
{
    s flag=0
    s shipName=""
    s name="" f  s name=$o(^oddCOM(className,"a",name)) q:(name="")||(shipName'="")  d
    .q:$g(^oddDEF(className,"a",name,36))'=1
    .s shipName=name
    q shipName
}

/// Creator:liwenzhen
/// Createdate:2022-08-16
/// Description:判断是否list
/// Input:list:list类型
/// Output:
/// Other:
/// Test:w ##class(web.INMLCDPComm).IsList()
ClassMethod IsList(list As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}) As %ListOfDataTypes
{
    s flag=1
    q:list="" 0
    s type=$classname(list)
    q:$classname(list)=list 0 //String类型等返回原值
    q:type'="%Library.ListOfDataTypes" 0
    q flag
}

/// Creator:liwenzhen
/// Createdate:2022-08-16
/// Description:list中array转换成字符串
/// Input:list:list类型，delim：分隔符 
/// Output:
/// Other:
/// Test:w ##class(web.INMLCDPComm).FlatList()
ClassMethod StringToListArray(list As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}, propList As %String = "", delim As %String = ",") As %ListOfDataTypes
{
    q:..IsList(list)=0 list
    s propList=$lfs(propList,",")
    f i=1:1:list.Count() d
    .s row=list.GetAt(i)
    .s array=##class(%ArrayOfDataTypes).%New()
    .s rowList=$lfs(row,delim)
    .f m=1:1:$ll(rowList) d
    ..d array.SetAt($lg(rowList,m),$lg(propList,m))
    .d list.SetAt(array,i)
    q list
}

/// Creator:liwenzhen
/// Createdate:2022-08-16
/// Description:list中array转换成字符串
/// Input:list:list类型，delim：分隔符 
/// Output:
/// Other:
/// Test:w ##class(web.INMLCDPComm).FlatList()
ClassMethod ListArrayToString(list As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}, propList As %String = "", delim As %String = ",") As %ListOfDataTypes
{
    q:..IsList(list)=0 list
    s propList=$lfs(propList,",")
    f i=1:1:list.Count() d
    .s data=list.GetAt(i)
    .s str=""
    .s ptr=0 f  s status=$listnext(propList,ptr,item) q:status'=1  d
    ..s str=str_data.GetAt(item)_$s(data.IsDefined(item)&&(item'=$lg(propList,$ll(propList))):delim,1:"")
    .d list.SetAt(str,i)
    q list
}

/// Creator:liwenzhen
/// Createdate:2022-08-16
/// Description:展平List of Datatypes
/// Input:list:list类型，delim：分隔符 
/// Output:
/// Other:
/// Test:w ##class(web.INMLCDPComm).FlatList()
ClassMethod ListToString(list As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}, delim As %String = ",") As %String
{
    q:..IsList(list)=0 list
    s str=""
    f i=1:1:list.Size d
    .s data=list.Data(i)
    .s str=str_$select(str'="":delim,1:"")_data
    q str
}

/// Creator:liwenzhen
/// Createdate:2022-08-16
/// Description:字符串转为List
/// Input:str:字符串类型，delim：分隔符 
/// Output:
/// Other:
/// Test:zw ##class(web.INMLCDPComm).StringToList()
ClassMethod StringToList(str As %String = "", delim As %String = ",") As %ListOfDataTypes
{
    
    s ptr=0
    s strList=$lfs(str,delim)
    s list=##class(%ListOfDataTypes).%New()
    While $listnext(strList,ptr,item) {
        d list.Insert(item)
    }
    q list
}

/// Creator:liwenzhen
/// Createdate:2022-04-28
/// Description:array转换^ret|
/// Table:
/// Input：isOutKey:是否输出key,fDelimiter:前分隔符,bDelimiter:后分隔符
/// Output
/// Return:
ClassMethod ArrayToString(array As %ArrayOfDataTypes, isOutKey As %String = "1", fDelimiter As %String = "^", bDelimiter As %String = "|") As %String
{
    s ret=""
    q:(array="")||(array.Count()=0) ret
    s key="" f  s key=array.Next(key) q:key=""  d
    .s value=array.GetAt(key)
    .s:$ISVALIDNUM(value) value=""_value
    .s:..IsList(value) value=..ListToString(value)
    .i isOutKey=1 d
    ..s ret=ret_$select(ret'="":fDelimiter,1:"")_key_bDelimiter_value
    .e  d
    ..s ret=ret_$select(ret'="":fDelimiter,1:"")_bDelimiter_value
    q ret
}

/// Creator:liwenzhen
/// Createdate:2022-07-26
/// Description:array转换json
/// Table:
/// Input：类名，类型G取global位置，O取属性名称
/// Output
/// Return:w ##class(web.INMLCDPComm).ArrayToJson()
ClassMethod ArrayToJson(array As %ArrayOfDataTypes = "") As %String
{
    q:(array="")||(array.Count()=0) ""
    w "{"
    s key=""
    f{
        s data=array.GetNext(.key)
        q:key=""
        w $c(34)_key_$c(34)_":"
        if $IsObject(data){
            if $classname(data)="%Stream.GlobalCharacter" {
                d data.Rewind()
                w $c(34)
                while('data.AtEnd){
                    w ##Class(web.INMCommon).Escape(data.Read())
                }
                w $c(34)    
            }
        }elseif $ISVALIDNUM(data){
            w data
        }else{
            w $c(34)_##Class(web.INMCommon).Escape(data)_$c(34)
        }
        w:array.Next(key)'="" ","
    }
    w "}"
    q ""
}

/// Creator:liwenzhen
/// Createdate:2022-04-28
/// Description:返回当前类名
/// Table:
/// Input：
/// Output
/// Return:
ClassMethod GetCurClassName() As %String [ CodeMode = objectgenerator ]
{
   Do %code.WriteLine(" Quit """ _ %class.Name _ """")
   Quit $$$OK
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:判断是否为实体类
/// Table: %Dictionary.CompiledProperty
/// Input：类名
/// Output：0:否、1:是、2:其他
/// Return:
/// Others:w ##class(web.INMLCDPComm).IsEntity("CT.DHCINM.LCDP.MgResourceSub")
ClassMethod IsEntity(className As %String = "") As %String
{
    s flag=0
    q:className="" flag
    q:'..IsExistClass(className) flag
    if $d(^oddCOM(className,62))=0 {
        if (className'["web.")||(className["WebService") {
            s flag=2    
        }
    }else{
        s flag=1
    }
    q flag
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:判断是否为实际属性
/// Table: %Dictionary.CompiledProperty
/// Input：类名、属性名、是否导出关系属性
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).IsStoredProp("","")
ClassMethod IsStoredProp(className As %String = "", propName As %String = "", isOutRel As %String = "0") As %String
{
    s flag=0
    q:(className="")||(propName="") flag
    s storable=$g(^oddCOM(className,"a",propName,50),$g(^oddDEF(className,"a",propName,50))) //判断该属性是否存在于数据库中
    s transient=$g(^oddCOM(className,"a",propName,51),$g(^oddDEF(className,"a",propName,51))) //判断该属性是否为临时
    q:(storable'=1)&&(transient'=0) flag
    s cardinality=$g(^oddCOM(className,"a",propName,36),$g(^oddDEF(className,"a",propName,36))) //判断该属性是否为指定关系属性
    q:(cardinality="1")&&(isOutRel=0) flag
    q 1
}

/// Creator:liwenzhen
/// Createdate:2022-11-08
/// Description:判断该索引是否为唯一索引
/// Table:%Dictionary.IndexDefinition
/// Input：类名、索引名
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).IsUniqueIndex("CT.DHCINM.DB.MgQualItem","Code")
ClassMethod IsUniqueIndex(className As %String = "", indexName As %String = "") As %String
{
    q:(className="")||(indexName="") 0
    q $g(^oddDEF(className,"i",indexName,31),0)
}

/// Creator:liwenzhen
/// Createdate:2022-11-08
/// Description:获取建在该索引上的属性
/// Table:%Dictionary.IndexDefinition
/// Input：类名、索引名
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).GetIndexProperties("CT.DHCINM.LCDP.MgResourceSub","Name")
ClassMethod GetIndexProperties(className As %String = "", indexName As %String = "") As %String
{
    q:(className="")||(indexName="") ""
    q $g(^oddDEF(className,"i",indexName,28))
}

/// Creator:liwenzhen
/// Createdate:2022-11-08
/// Description:判断某属性是否唯一
/// Table:CT.DHCINM.LCDP.MgClass
/// Input：各字段键值对
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveUniqueData("CT.DHCINM.LCDP.MgResourceSub",##class(web.INMCommon).Decode(^tmp("SaveUniqueData")),"PropertyName")
ClassMethod IsUniqueData(className As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}, UniqueKey As %String = "") As %String
{
    
    s ^tmp("SaveUniqueData")=##class(web.INMCommon).Encode(array)
    s id=""
    s indexName=..GetIndexByProp(className,UniqueKey,"0","0")
    q:indexName="" id
    s indexPropList=$lfs(..GetIndexProperties(className,indexName))
    s indexValue=""
    s ptr=0 f  s status=$listnext(indexPropList,ptr,prop) q:(status'=1)  d
    .s propValue=array.GetAt(prop)
    .s:..GetPropDataType(className,prop)="String" propValue=" "_$zcvt(propValue,"U")
    .s indexValue=indexValue_","_$c(34)_propValue_$c(34)
    s indexLocation=..GetIndexName(className)
    s indexStr=indexLocation_"("_$c(34)_indexName_$c(34)_indexValue_","_$c(34)_$c(34)_")"
    x ("(id) s id = $o("_indexStr_")",.id)
    s parref=array.GetAt(..GetRelationship(className))
    s:(parref'="")&&(id'="") id=parref_"||"_id
    q id
    ;q ##class(%Library.ConstraintUnique).CheckUnique()
}

/// Creator:liwenzhen
/// Createdate:2022-11-08
/// Description:获取有某属性的索引
/// Table:%Dictionary.IndexDefinition
/// Input：类名、索引名、是否全字匹配、是否唯一索引
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).GetIndexByProp("CT.DHCINM.DB.MgQualItem","QualYear,QualCode,QualType",1)
ClassMethod GetIndexByProp(className As %String = "", propName As %String = "", isMatchWhole As %String = "0", isUnique As %String = "0") As %String
{
    s name=""
    s propList=$lfs(propName,",")
    s indexName="" f  s indexName=$o(^oddDEF(className,"i",indexName)) q:(indexName="")||(name'="")  d
    .q:('..IsUniqueIndex(className,indexName))&&(isUnique=1)
    .s indexProperties=..GetIndexProperties(className,indexName)
    .s indexPropList=$lfs(indexProperties,",")
    .q:$ll(indexPropList)=0
    .s isFind=1
    .s ptr=0 f  s status=$listnext(indexPropList,ptr,item) q:(status'=1)||((isFind=0)&&(isMatchWhole=1))  d
    ..s:'$lf(propList,item) isFind=0
    ..s:$lf(propList,item) isFind=1
    .i isMatchWhole=1 d
    ..s:(isFind=1)&&($ll(propList)=$ll(indexPropList)) name=indexName //One&Only
    .e  d
    ..s:isFind=1 name=indexName
    q name
}

/// Creator:liwenzhen
/// Createdate:2022-11-08
/// Description:保存唯一数据
/// Table:CT.DHCINM.LCDP.MgClass
/// Input：类名、各字段键值对、唯一字段、存在唯一字段时是否覆盖
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveUniqueData("CT.DHCINM.LCDP.MgResourceSub",##class(web.INMCommon).Decode(^tmp("SaveUniqueData")),"PropertyName")
ClassMethod SaveUniqueData(className As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}, UniqueKey As %String = "", IsOverride As %String = "0") As %String
{
    s rowId=..IsUniqueData(className,array,UniqueKey)
    q:(rowId'="")&&(IsOverride=0) 0
    d array.SetAt(rowId,"RowId")
    s flag=..SaveData(className,array)
    q flag
}

/// Creator:liwenzhen
/// Createdate:2022-11-19
/// Description:模拟Query分页输出
/// Input:
/// Output:
/// Other:
/// Test:zw ##class(web.INMLCDPComm).SetRows(,1)
ClassMethod SetRows(rowList As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}, start As %String = "", limit As %String = "") As %String
{
	
	s:'..IsList(rowList) rowList=##class(%ListOfDataTypes).%New()
    s rows=##class(%ArrayOfDataTypes).%New()
    d rows.SetAt(rowList.Size,"results")
    s OrowList=##class(%ListOfDataTypes).%New()
    i (start'="")||(limit'="") {
		i start="" s start=0
    	i limit="" s limit=100000
		f i=start:1:rowList.Size q:(i>(start+limit))  d
		.i i<(start+limit) d OrowList.Insert(rowList.Data(i))
	}else{
		s OrowList=rowList
	}
	d rows.SetAt(OrowList,"rows")
    q rows
}

/// ============================================================================= ///
/// ================================查询单条数据================================= ///
/// ============================================================================= ///
/// Creator:liwenzhen
/// Createdate:2022-01-24
/// Description:根据类名与RowId获取行数据
/// Table:
/// Input：className:类名  rowId:行id  useProp:需要字段(分隔符:",")  filterProp:过滤字段(分隔符:",")
/// Output
/// Return:返回各个字段值
/// Others:s ary=##class(web.INMLCDPComm).GetData("CT.DHCINM.LCDP.MgForm","5")
ClassMethod GetData(className As %String = "", rowId As %String = "", useProps As %String = "", filterProps As %String = "") As %ArrayOfDataTypes [ ProcedureBlock = 0 ]
{
    n (className,rowId,useProps,filterProps)
    s array=##class(%ArrayOfDataTypes).%New()
    q:rowId="" array
    q:'..IsExistGlo(className,rowId) array
    s globalName=..GetGlobalName(className)
    ;x ("(global) s global = $g("_globalName_"("_$replace(rowId,"||",",")_"))",.global)
    s global=$g(@(globalName_"("_$replace(rowId,"||",",")_")")) //等同于x命令
    s suffix="_Desc" //拼接后缀
    s customKey=$lfs("ChildSub,Parref,"_filterProps,",") //设置过滤字段
    s useKey=$lfs(useProps,",") //设置需要字段
    k tmpProp
    d ..GetProperties(className,.tmpProp) //记录各字段global位置
    
    d array.SetAt(rowId,"RowId")
    ;s setFlag=""
    s propName="" f  s propName=$O(tmpProp(propName))  q:propName=""  d
    .q:($ll(useKey)>0)&&('$lf(useKey,propName))
    .q:$lf(customKey,propName)
    .s value=$lg(global,$g(tmpProp(propName)))
    .s realValue=value
    .s setFlag=1
    .s type=..GetPropDataType(className,propName) //获取数据类型
    .i $lf(..#DataTypeList,type) d
    ..s method="Get"_type
    ..d @method
    ..;x "d "_method
    .d:setFlag=1 array.SetAt(realValue,propName)
    q array

GetString //字符串类型
    i ($g(^oddCOM(className,"a",propName,"P","DISPLAYLIST"))'="") d //判断是否可枚举
    .;x ("(Display) s Display = ##class("_className_")."_propName_"LogicalToDisplay("""_value_""")",.Display)
    .s Display=$CLASSMETHOD(className,propName_"LogicalToDisplay",value)
    .d array.SetAt(Display,propName_suffix)
    q
GetDate //日期类型
    s realValue=##class(web.INMHISComm).DateLogicalToHtmlNew(value)
    q
GetTime //时间类型
    s:value'="" realValue=$zt(value,2)
    q
GetCacheObject //对象类型
    d array.SetAt("",propName_suffix)
    q:realValue=""
    s runtimeType=..GetPropDataType(className,propName,"C")
    s globalNum=..GetDescType(runtimeType)
    s propGlo=..GetGlobalName(runtimeType)
    q:propGlo=""
    x ("(objGlobal) s objGlobal = $g("_propGlo_"("_$replace(realValue,"||",",")_"))",.objGlobal)
    s objDesc=$lg(objGlobal,globalNum)
    s:(runtimeType="CF.DHCINM.DB.MgUser")&&(realValue=0) objDesc="超级管理员"
    d array.SetAt(objDesc,propName_suffix)
    q
GetListOfDT //基本数据集合类型
    s objType=..GetListofType(className,propName) // 取list中对象类型
    // string集合
    i objType="%String" s realValue=$lts(value,",",1) //序列化后转成字符串的分隔符为$c(3)
    s realValue=..StringToList(realValue)
    q
GetListOfObj //引用数据集合类型
    s objType=..GetListofType(className,propName)
    s propGlo=..GetGlobalName(objType)
    s globalNum=..GetDescType(objType)
    s tmpID=""
    s tmpDesc=""
    s ptr=0 f  s status=$listnext(value,ptr,idList) q:status'=1  d
    .s ID=""
    .s ptr2=0 f  s status2=$listnext(idList,ptr2,id) q:status2'=1  d //$lb($lb("1"),$lb("2")) ListOfObj为两层
    ..s ID=ID_$select(ID'="":"||",1:"")_id
    .s tmpID=tmpID_$select(tmpID'="":",",1:"")_ID
    .x ("(objGlobal) s objGlobal = $g("_propGlo_"("_$replace(ID,"||",",")_"))",.objGlobal)
    .s objDesc=$lg(objGlobal,globalNum)
    .s tmpDesc=tmpDesc_$select(tmpDesc'="":",",1:"")_objDesc
    s realValue=..StringToList(tmpID)
    d array.SetAt(tmpDesc,propName_suffix)
    q
GetGlobalCharacter //字符流类型
    d array.SetAt(##class(%Stream.GlobalCharacter).%New(),propName)
    s streamGlo=..GetStreamName(className)
    s sID=0 f sID=$o(@streamGlo@(rowId,sID)) q:sID=""  d
    .d array.GetAt(propName).Write($g(@streamGlo@(rowId,sID)))
    s setFlag=0 // 取消最后赋值
    q
}

/// Creator:liwenzhen
/// Createdate:2022-01-24
/// Description:根据类名与RowId获取行数据
/// Table:
/// Input：
/// Output
/// Return:返回各个字段值
/// Others:s ary=##class(web.INMHBComm).GetDataByObj("DHCINM.HB.MgExam","1")
ClassMethod GetDataByObj(className As %String, rowId As %String) As %ArrayOfDataTypes [ Deprecated ]
{
    q:rowId="" ""
    x ("(obj) s obj = ##class("_className_").%OpenId("""_rowId_""")",.obj)
    s array=##class(%ArrayOfDataTypes).%New()
    q:'$IsObject(obj) array
    d array.SetAt(rowId,"RowId")
    s customKey=$LB("ChildSub","Parref")
    s oddCOM = ##Class(%Dictionary.CompiledClass).%OpenId(className)
    q:'$IsObject(oddCOM) array
    s suffix="_Desc" //拼接后缀
    f m=1:1:oddCOM.Properties.Count() d
    .s propObj = oddCOM.Properties.GetAt(m)
    .s propName = propObj.Name
    .q:propName["%"
    .q:propObj.Cardinality="children"
    .q:($LF(customKey,propName)>0)
    .s value=$ZOBJPROPERTY(obj,propName)
    .s realValue=value
    .i realValue'="" d 
    ..s type=propObj.RuntimeType //获取数据类型
    ..s setFlag=1
    ..i (type="%Library.String") d GetString //日期类型
    ..i (type="%Library.Date") d GetDate //日期类型
    ..i (type="%Library.Time") d GetTime //时间类型
    ..i $IsObject(value) d GetCacheObject //判断是否对象，为对象时，type为类名
    ..i (type="%Collection.ListOfDT") d GetListOfDT //基本数据集合类型
    ..i (type="%Collection.ListOfObj") d GetListOfObj //引用数据集合类型
    ..i (type="%Stream.GlobalCharacter") d GetGlobalCharacter //字符流类型
    .d:setFlag=1 array.SetAt(realValue,propName)
    q array
    
GetString
    ;s realValue=$replace(value,"   ","")
    i ($g(^oddCOM(className,"a",propName,"P","DISPLAYLIST"))'="") d //判断是否可枚举
    .x ("(Display) s Display = ##class("_className_")."_propName_"LogicalToDisplay("""_value_""")",.Display)
    .d array.SetAt(Display,propName_suffix)
    q
GetDate
    s realValue=##class(web.INMHISComm).DateLogicalToHtmlNew(value)
    q
GetTime
    s realValue=$zt(value,1)
    q
GetCacheObject
    i ($g(^oddCOM(className,"a",propName,"m","GetSwizzled",2))="%Library.CacheObject") d
    .s realValue=value.%Id()
    .s objType=..GetDescType(type,"O")
    .;x ("(value,objDesc) s objDesc = value."_objType,value,.objDesc)
    .s objDesc=$ZOBJPROPERTY(value,objType)
    .d array.SetAt(objDesc,propName_suffix)
    q 
GetListOfDT
    s objType=propObj.Type // 取list中对象类型
    // string集合
    i objType="%Library.String" s realValue=$lts(value.Serialize(),",",1) //序列化后转成字符串的分隔符为$c(3)
    q
GetListOfObj
    ;s realValue=$tr(value.Serialize(),$c(5,3),",")
    ;s objType=value.ElementType //取list中对象类型
    s objType=propObj.Type
    s prop=..GetDescType(objType,"O")
    s tmpID=""
    s tmpDesc=""
    f i=1:1:value.Count()  d
    .s tmpID=tmpID_","_value.GetObjectIdAt(i)
    .i objType'="" d
    ..;x ("(i,value,tmpDesc) s tmpDesc=tmpDesc_"",""_value.GetAt(i)."_prop,i,value,.tmpDesc)
    ..s tmpDesc=tmpDesc_","_$ZOBJPROPERTY(value.GetAt(i),prop)
    s realValue=tmpID
    d:objType'="" array.SetAt($e(tmpDesc,2,*),propName_suffix)
    s realValue=$e(realValue,2,*) //去除第一个逗号
    q
GetGlobalCharacter
    d array.SetAt(##class(%Stream.GlobalCharacter).%New(),propName)
    x ("(realValue,array) d array.GetAt("""_propName_""").CopyFrom(realValue)",realValue,.array)
    s setFlag=0 // 取消最后赋值
    q
}

/// Creator:liwenzhen
/// Createdate:2022-05-17
/// Description:Json输出行数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others: w ##class(web.INMLCDPComm).GetDataJson("DHCINM.HB.AntiEpidemic","4")
ClassMethod GetDataJson(className As %String = "", id As %String = "", useProp As %String = "", filterProp As %String = "") As %String
{
    
    s array=..GetData(className,id,useProp,filterProp)
    w ##class(web.INMCommon).Encode(array)
    q ""
}

/// ============================================================================= ///
/// ===================================保存====================================== ///
/// ============================================================================= ///
/// Creator:liwenzhen
/// Createdate:2022-01-24
/// Description:根据类名与RowId保存行数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveData(^tmp("className"),##class(web.INMCommon).Decode(^tmp("array")))
ClassMethod SaveData(className As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %String [ ProcedureBlock = 0 ]
{
    n (className,array)
    s ^tmp("className")=className
    s ^tmp("array")=##class(web.INMCommon).Encode(array)
    s $ZT="SaveError"
    q:(array="")||(array.Count()=0) 1
    q:'..IsExistClass(className) 0
    s obj=""
    s RowId=array.GetAt("RowId")
    s relationshipName=..GetRelationship(className)
    s relationshipProp=..GetPropDataType(className,relationshipName,"C")
    s Parref=""
    s:relationshipName'="" Parref=array.GetAt(relationshipName)
    b ;rel1
    q:(relationshipProp'="")&&('..IsExistGlo(relationshipProp,Parref)) 0
    b ;rel2
    i RowId="" d
    .;x ("(obj) s obj = ##class("_className_").%New()",.obj)
    .s obj=$ClassMethod(className,"%New")
    .i (relationshipProp'="")&&(Parref'="") d
    ..x ("(parentObj) s parentObj = ##class("_relationshipProp_").%OpenId("""_Parref_""")",.parentObj)
    ..x ("(parentObj,obj) s obj."_relationshipName_" = parentObj",parentObj,.obj)
    .s Creator=array.GetAt("Creator")
    .s:$O(^oddCOM(className,"a","Status",""))'="" obj.Status = "N"
    .i ($O(^oddCOM(className,"a","Creator",""))'="")&&(Creator'="") d
    ..i ..GetPropDataType(className,"Creator")="CacheObject" d
    ...d obj.CreatorSetObjectId(Creator)
    ..e  d
    ...s $ZOBJPROPERTY(obj,"Creator")=Creator
    i RowId'="" d
    .;x ("(obj) s obj = ##class("_className_").%OpenId("""_tmp("RowId")_""")",.obj)
    .s obj=$ClassMethod(className,"%OpenId",RowId)
    s customKey=$LB("RowId","Creator",relationshipName)
    s propName="" f  s propName=array.Next(propName) q:propName=""  d
    .q:($LF(customKey,propName)>0)
    .q:$O(^oddCOM(className,"a",propName,""))=""
    .s value=array.GetAt(propName)
    .s type=..GetPropDataType(className,propName)
    .s setFlag=1
    .i $lf(..#DataTypeList,type) d
    ..s method="Set"_type
    ..d @method //执行标签只能在NoProcedureBlock下运行
    .s:setFlag=1 $ZOBJPROPERTY(obj,propName)=value
    s sc=obj.%Save()
    b ;save
    i $$$ISOK(sc) q obj.%Id()
    e  q 0
SaveError
    s $zt=""
    q $ze ;w $SYSTEM.Status.DisplayError(sc)
SetString
    ;i ($g(^oddCOM(className,"a",propName,"P","DISPLAYLIST"))'="") d //判断是否可枚举
    ;.x ("(Display) s Display = ##class("_className_")."_propName_"LogicalToDisplay("""_value_""")",.Display)
    ;.s value=$CLASSMETHOD(className,propName_"DisplayToLogical",value)
    q
SetDate
    s value=##class(web.INMHISComm).DateHtmlToLogical(value)
    q
SetTime
    ;s value=##class(websys.Conversions).TimeHtmlToLogical(value)
    s:value'="" value=$zth(value,3)
    q
SetCacheObject
    s runtimeType=..GetPropDataType(className,propName,"C")
    s:'..IsExistGlo(runtimeType,value) value=""
    ;x ("(obj) d obj."_propName_"SetObjectId("""_value_""")",.obj)
    d $method(obj,propName_"SetObjectId",value)
    s setFlag=0
    q 
SetListOfDT
    s objType=..GetListofType(className,propName) // 取list中对象类型
    // string集合
    x ("(obj) d:obj."_propName_".Count()>0 obj."_propName_".Clear()",.obj)
    i objType="%String" d
    .s stringList=$LFS(..ListToString(value),",")
    .x:$ll(stringList)>0 ("(stringList,obj) d obj."_propName_".InsertList(stringList)",stringList,.obj)
    s setFlag=0
    q
SetListOfObj
    s objType=..GetListofType(className,propName)
    x ("(obj) d:obj."_propName_".Count()>0 obj."_propName_".Clear()",.obj)
    s listStr=..ListToString(value)
    f i=1:1:$l(listStr,",")  d
    .s ID=$p(listStr,",",i)
    .q:'..IsExistGlo(objType,ID)
    .;q:$g(@propGlo@(ID))="" 
    .x ("(obj) d obj."_propName_".InsertObjectId("""_ID_""")",.obj)
    s setFlag=0
    q
SetGlobalCharacter
    x ("(obj) d obj."_propName_".Write("_value_")",.obj) //x命令用到的参数需在最前方定义
    s setFlag=0
    q
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:批量保存行数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveAllData(##class(web.INMCommon).Decode(^tmp("SaveAllData")),"CT.DHCINM.LCDP.MgButton")
ClassMethod SaveAllData(list As %ListOfDataTypes = "", className As %String = "", UniqueKey As %String = "", IsOverride As %String = "0") As %String
{
    s flag=1
    q:list="" 1
    s ^tmp("SaveAllData")=##class(web.INMCommon).Encode(list)
    ts
    s $zt="saveError" 
    f i=1:1:list.Count() q:$$$ISERR(flag)  d
    .s array=list.GetAt(i)
    .i UniqueKey'="" d
    ..s flag=..SaveUniqueData(className,array,UniqueKey,"1")
    .e  d
    ..s flag=..SaveData(className,array)
    i $$$ISOK(flag) {
        tc
        q 1
    }else{
        tro
        q 0
         
    }
saveError
    s $zt=""
    tro
    q $ze
}

/// ============================================================================= ///
/// ====================================删除===================================== ///
/// ============================================================================= ///
/// Creator:liwenzhen
/// Createdate:2022-01-24
/// Description:根据类名与RowId删除行数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others: w ##class(web.INMLCDPComm).DeleteData("DHCINM.HB.AntiEpidemic","4")
ClassMethod DeleteData(className As %String, rowId As %String) As %String
{
    q:rowId="" 0
    ;x ("(sc) s sc = ##class("_className_").%DeleteId("""_rowId_""")",.sc)
    s sc=$CLASSMETHOD(className,"%DeleteId",rowId)
    
    q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2022-08-18
/// Description:批量删除行数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others: w ##class(web.INMLCDPComm).DeleteAllData("DHCINM.HB.MgExam","1")
ClassMethod DeleteAllData(className As %String, rowIds As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}) As %String
{
    s size=rowIds.Size
    q:size=0 0
    ;x ("(sc) s sc = ##class("_className_").%DeleteId("""_rowId_""")",.sc)
    s flag=1
    ts
    s $zt="deleteError"
    f i=1:1:size q:flag'=1  d
    .s sc=$CLASSMETHOD(className,"%DeleteId",rowIds.GetAt(i))
    .s flag=$$$ISOK(sc)
    i flag=1 {
        tc
    }else{
        tro
    }
    q flag
deleteError
    tro
}

/// Creator:liwenzhen
/// Createdate:2022-02-12
/// Description:根据类名获取描述字段名或global位置
/// Table:
/// Input：类名，类型G取global位置，O取属性名称
/// Output
/// Return:w ##class(web.INMLCDPComm).GetDescType("CF.DHCINM.HR.Persons")
ClassMethod GetDescType(className As %String, type As %String = "G") As %String
{
    s ret=""
    s resId=$o(^CT.DHCINM.LCDP.MgResourceI("Name"," "_$zcvt(className,"U"),""))
    d:resId="" GetDescTypeByCustom 
    q:ret'="" ret
    q:resId="" ""
	s resSubId=$o(^CT.DHCINM.LCDP.MgResourceSubI("Desc",resId," Y",""))
	s subGlo=$g(^CT.DHCINM.LCDP.MgResourceSubD(resId,resSubId))
	s propertyName=$lg(subGlo,7)
	s globalNum=$lg(subGlo,9)
	s:type="O" ret=propertyName
	s:type="G" ret=globalNum
    q ret
GetDescTypeByCustom //以下是为了适配之前的版本
	i className="CF.DHCINM.DB.MgWard" d
    .s:type="O" ret="WardDesc"
    .s:type="G" ret=4
    i className="CF.DHCINM.HR.Persons" d
    .s:type="O" ret="PerName"
    .s:type="G" ret=2
    i className="CF.DHCINM.DB.MgUser" d
    .s:type="O" ret="UserName"
    .s:type="G" ret=2
    i className="CT.DHCINM.LCDP.MgProperty" d
    .s:type="O" ret="PropertyDesc"
    .s:type="G" ret=4
    i className="CT.DHCINM.DB.MgSetCodeSub" d
    .s:type="O" ret="SubDesc"
    .s:type="G" ret=3
    q
}

/// Creator:liwenzhen
/// Createdate:2022-08-17
/// Description:获取SQL
/// Table:
/// Input：类名、查询条件、查询条件值、登录Id
/// Output
/// Return:w ##class(web.INMLCDPComm).GetSql("CT.DHCINM.LCDP.MgIndex","","","","1","10",.tmp)
ClassMethod GetSql(className As %String = "", conditions As %ArrayOfDataTypes = "", array As %ArrayOfDataTypes = "", nurseid As %String = "", start As %String = "0", end As %String = "10000", ByRef param As %String = "") As %String
{
    
    s sqlTabel=..GetTableName(className)
    q:sqlTabel="" ""
    s:conditions="" conditions=##class(%ListOfDataTypes).%New()
    s where=""
    s param=0
    s index="" f  s index=conditions.Next(index) q:index=""  d
    .s searchArray=conditions.GetAt(index)
    .s prop=searchArray.GetAt("prop")
    .s operator=searchArray.GetAt("operator")
    .s model=array.GetAt((searchArray.GetAt("model")))
    .q:model="" 
    .s value=prop_operator_"?"
    .s where=$select(where'="":where_" And "_value,where="":value)
    .s param=$I(param)
    .s param(param)=model
    s:where'="" where=" Where "_where
    i start<=0 s start=0
    i end=""  s end=100000
    ;s vid=" where %VID Between "_start_" And "_end
    s myQuery = "Select ID From "_sqlTabel_where
    ;s myQuery= "Select ID,%VID From ("_myQuery_")"_vid
    q myQuery
}

/// Creator:liwenzhen
/// Createdate:2022-08-17
/// Description:获取结果集
/// Table:
/// Input：
/// Output
/// Return:
ClassMethod GetResult(sql As %String = "", ByRef param As %String = "") As %SQL.StatementResult
{
    s tResult = ##class(%SQL.StatementResult).%New()
    s tStatement = ##class(%SQL.Statement).%New() 
    s qStatus = tStatement.%Prepare(sql)
    i qStatus'=1 {
        d $System.Status.DisplayError(qStatus) 
        q tResult
    }
    
    s tResult = tStatement.%Execute(param...)
    q tResult
}

/// ============================================================================= ///
/// ====================================Query==================================== ///
/// ============================================================================= ///
/// Creator:liwenzhen
/// Createdate:2022-08-02
/// Description:通用Query方法
/// Input:类名、查询条件、查询条件值、登录Id
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindDataBySql","CT.DHCINM.LCDP.MgResourceSub",##class(web.INMCommon).Decode(^tmpFindDataBySql("conditions")),##class(web.INMCommon).Decode(^tmpFindDataBySql("array")))
Query FindDataBySql(className As %String = "", conditions As %ArrayOfDataTypes = "", array As %ArrayOfDataTypes = "", nurseid As %String = "", start As %String = "0", end As %String = "10000") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDataBySqlExecute(ByRef qHandle As %Binary, className As %String = "", conditions As %ArrayOfDataTypes = "", array As %ArrayOfDataTypes = "", nurseid As %String = "", start As %String = "0", end As %String = "10000") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1    
    s ^tmpFindDataBySql("conditions")=##class(web.INMCommon).Encode(conditions)
    s ^tmpFindDataBySql("array")=##class(web.INMCommon).Encode(array)
    s sqlTabel=..GetTableName(className)
    s rows=##class(%ArrayOfDataTypes).%New()
    s:conditions="" conditions=##class(%ListOfDataTypes).%New()
    i sqlTabel="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s param=0
    s sql=..GetSql(className,conditions,array,nurseid,start,end,.param)
    s tStatement = ##class(%SQL.Statement).%New(1) 
    s qStatus = tStatement.%Prepare(sql)
    i qStatus'=1 {
        d $System.Status.DisplayError(qStatus) 
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
   
    s rset = tStatement.%Execute(param...)
    while rset.%Next() {
            s rowData=..GetData(className,rset.ID)
            s ret=..ArrayToString(rowData)
            d OutRows
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutRows
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-08-17
/// Description:获取table多层级行数据
/// Table:类名、查询条件、查询条件值、登录Id、分页起始值、分页结束值
/// Input：
/// Output
/// Return:s rows=##class(web.INMLCDPComm).FindDataBySqlMultiple("CT.DHCINM.LCDP.MgIndex","","","")
ClassMethod FindDataBySqlMultiple(className As %String = "", conditions As %ArrayOfDataTypes = "", array As %ArrayOfDataTypes = "", nurseid As %String = "", start As %String = "0", end As %String = "10000") As %ArrayOfDataTypes
{
    s rowList=##class(%ListOfDataTypes).%New()
    s rows=##class(%ArrayOfDataTypes).%New()
    d rows.SetAt(rowList,"rows")
    d rows.SetAt(rowList.Size,"results")
    s sql=..GetSql(className,conditions,array,nurseid,start,end,.param)
    q:sql="" rows
    s result=..GetResult(sql,.param)
    
    while result.%Next() {
        s rowData=..GetData(className,result.ID)
        d:(rowData'="")&&(rowData.Count()>0) rowList.Insert(rowData)
        s ret=..ArrayToString(rowData)
    }
    d rows.SetAt(rowList,"rows")
    d rows.SetAt(rowList.Size,"results")
    q rows
}

/// Creator:liwenzhen
/// Createdate:2022-05-06
/// Description:根据类名查询表数据
/// Table:
/// Input：
/// Output
/// Return:
/// Others:d $CLASSMETHOD("web.INMLCDPComm","FindDataBySqlTest")
ClassMethod FindDataBySqlTest() As %String
{
    ;d $SYSTEM.Security.Login("_system","SYS")
    s sqlTabel="DHCINM_HB.NurLinkup"
    s myquery = "SELECT ID FROM "_sqlTabel_" Where LinkupDate<? And LinkupDate>? And WardDR=?" //尽量使用完全限定名称,?占位符
    s tStatement = ##class(%SQL.Statement).%New(1) //参数为1，输出ODBC格式,且查询值也为ODBC格式
    s qStatus = tStatement.%Prepare(myquery)
    i qStatus'=1 {
        w "%Prepare 失败" 
        d $System.Status.DisplayError(qStatus) 
        q ""
    }
    
    // 方式一
    ;s rset = tStatement.%Execute("2022-05-31","2022-05-01","1") //顺序传参
    s param=3 //指示数组长度
    s param(1)="2022-05-31"
    s param(2)="2022-05-01"
    s param(3)=1
    s rset = tStatement.%Execute(param...) //数组方式传值
    // 方式二
    ;s rset=$SYSTEM.SQL.Execute("SELECT * FROM DHCINM_HB.MgExam") //无需创建对象，缓存查询
    // 方式三
    ;s myquery=3
    ;s myquery(1)="SELECT Name,Age,%VID FROM Sample.Person"
    ;s myquery(2)="WHERE Age > ? AND Age < ? ORDER BY Age"
    ;s myquery(3)="AND WHERE %VID BETWEEN ? AND ?" //%VID 用于分页
    ;s rset = ##class(%SQL.Statement).%ExecDirect(,.myquery,12,20,1,5) //准备并执行、无需Prepare
    s rowList=##class(%ListOfDataTypes).%New()
    s rows=##class(%ArrayOfDataTypes).%New()
    while rset.%Next() {
            s array=..GetData("DHCINM.HB.NurLinkup",rset.ID)
            d:(array'="")&&(array.Count()>0) rowList.Insert(array)
            ;w "id:"_rset.ID,! //按属性名或字段名或别名获取,如果属性名重复，返回第一个
            ;d rset.%Print("^") //返回当前行的所有值,"^"为分隔符
            ;w rset.%GetRow(.row,.status),! //方法不存在
            ;w rset.%Get("Exam_Date") //按字段名获取，如果属性名重复，返回最后一个
            ;w rset.%GetData(1) //按列数获取
            ;w rset.%ROWCOUNT,! //行数
    }
    d rows.SetAt(rowList,"rows")
    d rows.SetAt(rowList.Count(),"results")
    w ##class(web.INMCommon).Encode(rows)
    q ""
    ;DO rset.%Display() //输出结果集
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:获取同步数据库数据，类名、属性、索引
/// Table:CT.DHCINM.LCDP.MgClass、CT.DHCINM.LCDP.MgProperty、CT.DHCINM.LCDP.MgIndex
/// Input：
/// Output
/// Return:
/// Others:d $CLASSMETHOD("web.INMLCDPComm","GetSyncData","1",.tmp)
ClassMethod GetSyncData(rowId As %String = "", Output clsDefine As %String = "") As %String
{
    q:rowId="" ""
    s classGlo=$g(^CT.DHCINM.LCDP.MgClassD(rowId))
    q:classGlo="" ""
    k clsDefine
    s createDate=$zd($lg(classGlo,3),3)
    s createTime=$zt($lg(classGlo,4),3)
    s className=$lg(classGlo,6)
    s classDesc=$lg(classGlo,7)
    s clsDefine=className
    s clsDefine("Class",className,"Description")=classDesc
    s clsDefine("Class",className,"createDate")=createDate
    s clsDefine("Class",className,"createTime")=createTime
    
    s tmp("Property","ListProperty","Description")="This is a list property"
    s tmp("Property","ListProperty","Collection")="list"
    s tmp("Property","ListProperty","Type")="%String"

    //获取属性
    s propId="" f  s propId=$o(^CT.DHCINM.LCDP.MgPropertyI("parr",rowId,propId)) q:propId=""  d
    .s propGlo=$g(^CT.DHCINM.LCDP.MgPropertyD(rowId,propId))
    .s propertyName=$lg(propGlo,3)
    .s propertyDesc=$lg(propGlo,4)
    .s propertyType=$lg(propGlo,5)
    .s InitialExpression=$lg(propGlo,9)
    .s sort=$lg(propGlo,8)
    .s collection=$lg(propGlo,11)
    .s maxLen=$lg(propGlo,12)
    .s displayList=$lg(propGlo,13)
    .s valueList=$lg(propGlo,14)
    .s truncate=$case($lg(propGlo,15),"Y":"1","N":"0",:"")
    .s clsDefine("Property",propertyName,"Description")=propertyDesc
    .s clsDefine("Property",propertyName,"Type")=propertyType
    .s clsDefine("Property",propertyName,"Sort")=sort
    .s clsDefine("Property",propertyName,"Collection")=collection
    .i propertyType="%String" d
    ..s:+maxLen>0 clsDefine("Property",propertyName,"Parameters","MAXLEN")=+maxLen
    ..s:displayList'="" clsDefine("Property",propertyName,"Parameters","DISPLAYLIST")=displayList
    ..s:valueList'="" clsDefine("Property",propertyName,"Parameters","VALUELIST")=valueList
    ..s:truncate'="" clsDefine("Property",propertyName,"Parameters","TRUNCATE")=truncate
    .s:propertyType="%Date" clsDefine("Property",propertyName,"InitialExpression")="+$h"
    .s:propertyType="%Time" clsDefine("Property",propertyName,"InitialExpression")="$p($h,"","",2)"
    .s:InitialExpression'="" clsDefine("Property",propertyName,"InitialExpression")=InitialExpression
    //获取索引
    s indexId="" f  s indexId=$o(^CT.DHCINM.LCDP.MgIndexI("parr",rowId,indexId)) q:indexId=""  d
    .s indexGlo=$g(^CT.DHCINM.LCDP.MgIndexD(rowId,indexId))
    .s indexStatus=$lg(indexGlo,2)
    .s indexName=$lg(indexGlo,3)
    .s indexDesc=$lg(indexGlo,4) //备注
    .s indexType=$lg(indexGlo,5) //类型
    .s indexProp=$lg(indexGlo,6) 
    .s propNames=""
    .s ptr=0 f  s status=$listnext(indexProp,ptr,propId) q:status'=1  d
    ..s propRealId=$replace(propId,$c(6,1),"")
    ..s propGlo=$g(^CT.DHCINM.LCDP.MgPropertyD($p(propRealId,"||",1),$p(propRealId,"||",2)))
    ..s propNames=propNames_$select(propNames'="":",",1:"")_$lg(propGlo,3)
    .s clsDefine("Index",indexName,"Properties")=propNames
    .s clsDefine("Index",indexName,"Status")=indexStatus
    .s clsDefine("Index",indexName,"Description")=indexDesc
    .s clsDefine("Index",indexName,"type")=indexType
    q ""
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:同步数据库
/// Table:CT.DHCINM.LCDP.MgClass、CT.DHCINM.LCDP.MgProperty、CT.DHCINM.LCDP.MgIndex
/// Input：
/// Output
/// Return:
/// Others:w $CLASSMETHOD("web.INMLCDPComm","SaveSyncData","7")
ClassMethod SaveSyncData(rowId As %String = "") As %String
{
    d ..GetSyncData(rowId,.clsDefine)
    s sc=..CreateClass(.clsDefine)
    i sc["同步成功" {
        s array=##class(%ArrayOfDataTypes).%New()
        d array.SetAt(rowId,"RowId")
        d array.SetAt("Y","Status")
        s sc=..SaveData("CT.DHCINM.LCDP.MgClass",array)
        q:$$$ISOK(sc) "同步成功"
        q:$$$ISERR(sc) "同步失败"
    }else{
        q "同步失败："_$SYSTEM.Status.GetErrorText(sc)    
    }
}

/// w ##class(web.INMLCDPComm).CreateClass()
ClassMethod CreateClass(ByRef clsDefine As %String = "") As %Status
{
    s sc=..Check(.clsDefine)
    q:sc'=1 sc
    s clsName=clsDefine
    
    //类定义
    i ##class(%Dictionary.ClassDefinition).%ExistsId(clsName) s class=##class(%Dictionary.ClassDefinition).%OpenId(clsName)
    e  d
    .s class=##class(%Dictionary.ClassDefinition).%New(clsName)
    .s class.Super="%Persistent"
    .s class.ProcedureBlock=1
    .s description=clsDefine("Class",clsName,"Description")
    .s createDate=clsDefine("Class",clsName,"createDate")
    .s createTime=clsDefine("Class",clsName,"createTime") 
    .s class.Description="Description: "_description_$c(13,10)_"Date: "_createDate
    s:'class.%Id() sc=class.%Save()
    
    //属性定义
    s property="" f  s property=$o(clsDefine("Property",property)) q:(property="")||(sc'=1)  d
    .i ##class(%Dictionary.PropertyDefinition).%ExistsId(clsName_"||"_property) s propertyObj=##class(%Dictionary.PropertyDefinition).%OpenId(clsName_"||"_property)
    .e  d
    ..s propertyObj=##class(%Dictionary.PropertyDefinition).%New(clsName_":"_property)
    ..s propertyObj.parent=class
    ..s propertyObj.Collection=clsDefine("Property",property,"Description")
    .s sort=+$g(clsDefine("Property",property,"Sort"))
    .s:sort>0 propertyObj.SqlColumnNumber=sort+1
    .s propertyObj.SqlFieldName=property
    .s:sort>0 propertyObj.SequenceNumber=sort //序列号（未知作用）
    .s:$d(clsDefine("Property",property,"Description")) propertyObj.Description=clsDefine("Property",property,"Description")
    .s:$d(clsDefine("Property",property,"Collection")) propertyObj.Collection=clsDefine("Property",property,"Collection")
    .s propertyObj.Type=clsDefine("Property",property,"Type")
    .d propertyObj.Parameters.Clear()
    .i $d(clsDefine("Property",property,"Parameters")) d
    ..s params="" f  s params=$o(clsDefine("Property",property,"Parameters",params)) q:params=""  d
    ...d propertyObj.Parameters.SetAt(clsDefine("Property",property,"Parameters",params),params)
    .s:$d(clsDefine("Property",property,"InitialExpression")) propertyObj.InitialExpression=clsDefine("Property",property,"InitialExpression")
    .s sc=propertyObj.%Save()
    //索引定义
    s rebuildIndexString="",index="" f  s index=$o(clsDefine("Index",index)) q:(index="")||(sc'=1)  d
    .i ##class(%Dictionary.IndexDefinition).%ExistsId(clsName_"||"_index) s indexObj=##class(%Dictionary.IndexDefinition).%OpenId(clsName_"||"_index)
    .e  d
    ..s indexObj=##class(%Dictionary.IndexDefinition).%New(clsName_":"_index)
    ..s indexObj.parent=class
    ..;s sort=+$g(clsDefine("Index",index,"Sort"))
    ..;s:sort>0 indexObj.SequenceNumber=sort
    ..d appendString
    .i indexObj.Properties'=clsDefine("Index",index,"Properties") d
    ..s indexObj.Properties=clsDefine("Index",index,"Properties")
    ..d appendString
    .s sc=indexObj.%Save()
    
    //Storage定义(主要用于解决类名太长global名与类名不一致的问题) iris不适用
#;    i ##class(%Dictionary.StorageDefinition).%ExistsId(clsName_"||Default") s storageObj=##class(%Dictionary.StorageDefinition).%OpenId(clsName_"||Default")
#;    e  s storageObj=##class(%Dictionary.StorageDefinition).%New(clsName_"||Default")
#;    s dataLocation="^"_clsName_"D"
#;    s storageObj.DataLocation=dataLocation
#;    s storageObj.IdLocation=dataLocation
#;    s storageObj.IndexLocation="^"_clsName_"I"
#;    s storageObj.StreamLocation="^"_clsName_"S"
#;    s sc=storageObj.%Save()
        
    //编译全部
    s:sc=1 sc=$SYSTEM.OBJ.Compile(class.Name) // $SYSTEM.OBJ.Compile自动w编译信息
    i (sc=1)&&(rebuildIndexString'="") d
    .s rebuildIndexList=$lfs(rebuildIndexString,",")
    .s sc=$CLASSMETHOD(clsName,"%BuildIndices",rebuildIndexList) //重建索引
    
    i sc=1 s sc=..AddToProject(clsName)
    .;w:$$$ISERR(sc2) $SYSTEM.Status.GetErrorText(sc2)
    
    i sc q "同步成功" 
    e  q "同步失败"
appendString
    s rebuildIndexString=rebuildIndexString_$case(rebuildIndexString,"":"",:",")_index
    q
}

/// w ##class(web.INMLCDPComm).CreateClass("DHCINM.HB.Testa")
ClassMethod AddToProject(clsName As %String = "") As %Status
{
    q:'##class(%Dictionary.ClassDefinition).%ExistsId(clsName) ""
    s sc=1
    i ##class(%Studio.ProjectItem).%ExistsId("DHCINM||"_clsName_"||CLS")'=1 d
    .s projectItem=##class(%Studio.ProjectItem).%New()
    .s projectItem.Project=##class(%Studio.Project).%OpenId("DHCINM")
    .s projectItem.Name=clsName
    .s projectItem.Type="CLS"
    .s sc=projectItem.%Save()
    q $$$ISOK(sc)
}

ClassMethod Check(ByRef clsDefine As %String = "") As %Status
{
    s sc=$$$OK
    i ##class(%Dictionary.CacheClassname).IsValid(clsDefine)'=1 s sc=$$$ERROR("Classname is not valid")
    s property="" f  s property=$o(clsDefine("Property",property)) q:(property="")||(sc'=1)  d
    .i $SYSTEM.SQL.IsReservedWord(property) s sc=$$$ERROR("5529",property,"property") q
    .s propType=$g(clsDefine("Property",property,"Type"))
    .s:$l(propType,".")=1 propType=$replace(propType,"%","%Library.")
    .i (propType="")||('##class(%Dictionary.CompiledClass).%ExistsId(propType)) s sc=$$$ERROR("5373",propType,property) q
    
    s index="" f  s index=$o(clsDefine("Index",index)) q:(index="")||(sc'=1)  d
    .s indexProperties=$g(clsDefine("Index",index,"Properties"))
    .i indexProperties="" s sc=$$$ERROR("5414","") q
    .s indexPropertiesList=$lfs(indexProperties,",")
    .s ptr=0 f  s status=$listnext(indexPropertiesList,ptr,value) q:(status'=1)||(sc'=1)  d
    ..i '$d(clsDefine("Property",value))&&(('##class(%Dictionary.ClassDefinition).%ExistsId(clsDefine))||('##class(%Dictionary.PropertyDefinition).%ExistsId(clsDefine_"||"_property))) s sc=$$$ERROR("5414",value) q
    q sc
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:保存表单设计数据
/// Table:CT.DHCINM.LCDP.MgForm
/// Input：
/// Output
/// Return:
/// Others:d $CLASSMETHOD("web.INMLCDPComm","SaveSyncData","1")
ClassMethod SaveForm(rowId As %String = "", classDR As %String = "", formJson As %String = "") As %String
{
    i rowId="" d
    .s obj=##class(CT.DHCINM.LCDP.MgForm).%New()
    e  d
    .s obj=##class(CT.DHCINM.LCDP.MgForm).%OpenId(rowId)
    d:$d(^CT.DHCINM.LCDP.MgClassD) obj.ClassDRSetObjectId(classDR)
    d obj.FormJson.Write(formJson)
    s sc=obj.%Save()
    q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2022-08-15
/// Description:获取表单设计数据
/// Table:CT.DHCINM.LCDP.MgForm
/// Input：
/// Output
/// Return:
/// Others:w $CLASSMETHOD("web.INMLCDPComm","GetForm","5")
ClassMethod GetForm(classDR As %String = "") As %String
{
    s rowId=$o(^CT.DHCINM.LCDP.MgFormI("ClassDR",classDR,""))
    s obj=..GetData("CT.DHCINM.LCDP.MgForm",rowId)
    q ..ArrayToJson(obj)
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:发布配置化菜单
/// Table:CT.DHCINM.Set.MgMenu
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveLCDPMenu(##class(web.INMCommon).Decode(^tmp("SaveLCDPMenu")))
ClassMethod SaveLCDPMenu(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %String
{
    
    s ^tmp("SaveLCDPMenu")=##class(web.INMCommon).Encode(array)
    q:(array="")||(array.Count()=0) "入参为空"
    s menuCode=array.GetAt("MenuCode")
    s:menuCode="" menuCode="BaseCrudComm"_$g(^CT.DHCINM.Set.MgMenuD,1)
    d array.SetAt(menuCode,"MenuCode")
    s isExist=##class(web.INMSetComm).IsExistMenu(..ArrayToString(array))
    q:isExist=-1 "菜单代码已存在"
    i (array.GetAt("MenuModuleDR")'="")&&(array.GetAt("MenuSort")="") d
    .s maxMenuSort=##class(web.INMSetComm).GetMaxMenuSort(array.GetAt("MenuModuleDR"))
    .d array.SetAt(maxMenuSort,"MenuSort")
    d array.SetAt("N","IsAdvanced")
    d array.SetAt("Y","IsLCDP")
    s menuRouter=array.GetAt("MenuCode")
    d:array.GetAt("MenuRouter")="" array.SetAt($zcvt(menuRouter,"L"),"MenuRouter")
    s menuPath="basicdata"_"/"_"BaseCrudComm"
    d array.SetAt(menuPath,"MenuPath")
    d array.SetAt(array.GetAt("rw"),"RowId")
    d array.RemoveAt("rw")
    s classDR=$p(array.GetAt("MenuParams"),"=",2)
    ts
    s menuId=..SaveData("CT.DHCINM.Set.MgMenu",array)
    if $$$ISERR(menuId) {
        tro
        q "保存失败"
    }
    s sc=1
    s sort="" f  s sort=$o(^CT.DHCINM.LCDP.MgButtonI("Sort",classDR,sort)) q:(sort="")||($$$ISERR(sc))  d
    .s buttonId="" f  s buttonId=$o(^CT.DHCINM.LCDP.MgButtonI("Sort",classDR,sort," Y",buttonId)) q:(buttonId="")||($$$ISERR(sc))  d
    ..s buttonGlo=$g(^CT.DHCINM.LCDP.MgButtonD(classDR,buttonId))
    ..s buttonCode=$tr($lg(buttonGlo,3)," ","")
    ..s buttonDesc=$tr($lg(buttonGlo,4)," ","")
    ..s subId=$O(^CT.DHCINM.Set.MgMenuElementI("Code",menuId," "_$zcvt($tr(buttonCode," ",""),"U"),""))
    ..s buttonAry=##class(%ArrayOfDataTypes).%New()
    ..d buttonAry.SetAt(buttonCode,"ElementCode")
    ..d buttonAry.SetAt(buttonDesc,"ElementDesc")
    ..d buttonAry.SetAt("button","ElementType")
    ..d buttonAry.SetAt(menuId,"Parref")
    ..s elementId=""
    ..s:subId'="" elementId=menuId_"||"_elementId
    ..d buttonAry.SetAt(elementId,"RowId")
    ..s sc=..SaveData("CT.DHCINM.Set.MgMenuElement",buttonAry)
    ..q:$$$ISERR(sc)
    
    if $$$ISOK(sc) {
        tc
        q 1 
    }else{
        tro
        q "保存失败"    
    }
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:查询配置化列表显示字段
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindLCDPTable","")
Query FindLCDPTable(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindLCDPTableExecute(ByRef qHandle As %Binary, array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s classDR=array.GetAt("ClassDR")
    s searchIsDisplay=array.GetAt("IsDisplay")
    i classDR="" s qHandle=$lb(0,repid,0) q $$$OK
    s sort="" f  s sort=$o(^CT.DHCINM.LCDP.MgTableI("Sort",classDR,sort)) q:sort=""  d
    .s isDisplay="" f  s isDisplay=$o(^CT.DHCINM.LCDP.MgTableI("Sort",classDR,sort,isDisplay)) q:isDisplay=""  d 
    ..q:(searchIsDisplay'="")&&(searchIsDisplay'=isDisplay)
    ..s subId="" f  s subId=$o(^CT.DHCINM.LCDP.MgTableI("Sort",classDR,sort,isDisplay,subId)) q:subId=""  d 
    ...s rowData=..GetData("CT.DHCINM.LCDP.MgTable",classDR_"||"_subId)
    ...s ret=..ArrayToString(rowData)
    ...d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-11-16
/// Description:保存查询条件
/// Table:CT.DHCINM.LCDP.MgQuery
/// Input：各字段键值对
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveQuery(##class(web.INMCommon).Decode(^tmp("SaveQuery")))
ClassMethod SaveQuery(list As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}) As %String
{
    s ^tmp("SaveQuery")=##class(web.INMCommon).Encode(list)
    q:($ClassName(list)'="%Library.ListOfDataTypes")||(list.Count()=0) "入参为空"
    f i=1:1:list.Count() d
    .s array=list.GetAt(i)
    .d array.SetAt(..ListArrayToString(array.GetAt("APIParameter"),"Key,Value",$c(63)),"APIParameter")
    q ..SaveAllData(list,"CT.DHCINM.LCDP.MgQuery")
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:查询配置化查询条件显示
/// Input:
/// Output:
/// Other:
/// Test:w ##class(web.INMCommon).Encode(##class(web.INMLCDPComm).FindLCDPQuery(##class(web.INMCommon).Decode(^tmp("FindLCDPQuery")),1,0))
ClassMethod FindLCDPQuery(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}, start As %String = "", limit As %String = "") As %String
{
    s ^tmp("FindLCDPQuery")=##class(web.INMCommon).Encode(array)
    s rowList=##class(%ListOfDataTypes).%New()
	s classDR=array.GetAt("ClassDR")
    s searchIsDisplay=array.GetAt("IsDisplay")
    s sort="" f  s sort=$o(^CT.DHCINM.LCDP.MgQueryI("Sort",classDR,sort)) q:sort=""  d
    .s isDisplay="" f  s isDisplay=$o(^CT.DHCINM.LCDP.MgQueryI("Sort",classDR,sort,isDisplay)) q:isDisplay=""  d 
    ..q:(searchIsDisplay'="")&&(searchIsDisplay'=isDisplay)
    ..s subId="" f  s subId=$o(^CT.DHCINM.LCDP.MgQueryI("Sort",classDR,sort,isDisplay,subId)) q:subId=""  d 
    ...s rowData=..GetData("CT.DHCINM.LCDP.MgQuery",classDR_"||"_subId)
    ...d rowData.SetAt(..StringToListArray(rowData.GetAt("APIParameter"),"Key,Value",$c(63)),"APIParameter")
	...d rowList.Insert(rowData)
    q ..SetRows(rowList,start,limit)
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:查询配置化列表显示字段
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindLCDPButton","")
Query FindLCDPButton(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindLCDPButtonExecute(ByRef qHandle As %Binary, array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s classDR=array.GetAt("ClassDR")
    s searchIsDisplay=array.GetAt("IsDisplay")
    i classDR="" s qHandle=$lb(0,repid,0) q $$$OK
    s sort="" f  s sort=$o(^CT.DHCINM.LCDP.MgButtonI("Sort",classDR,sort)) q:sort=""  d
    .s isDisplay="" f  s isDisplay=$o(^CT.DHCINM.LCDP.MgButtonI("Sort",classDR,sort,isDisplay)) q:isDisplay=""  d 
    ..q:(searchIsDisplay'="")&&(searchIsDisplay'=isDisplay)
    ..s subId="" f  s subId=$o(^CT.DHCINM.LCDP.MgButtonI("Sort",classDR,sort,isDisplay,subId)) q:subId=""  d 
    ...s rowData=..GetData("CT.DHCINM.LCDP.MgButton",classDR_"||"_subId)
    ...s ret=..ArrayToString(rowData)
    ...d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-10-20
/// Description:查询库表设计
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindLCDPClass","")
Query FindLCDPClass(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindLCDPClassExecute(ByRef qHandle As %Binary, array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s className=array.GetAt("ClassName")
    s classDesc=array.GetAt("ClassDesc")
    s searchStatus=array.GetAt("Status")
    s status="" f  s status=$o(^CT.DHCINM.LCDP.MgClassI("Status",status)) q:status=""  d
    .q:(searchStatus'="")&&(searchStatus'=status)
    .s id="" f  s id=$o(^CT.DHCINM.LCDP.MgClassI("Status",status,id)) q:id=""  d 
    ..s rowData=..GetData("CT.DHCINM.LCDP.MgClass",id)
    ..q:(className'="")&&(rowData.GetAt("ClassName")'[className)
    ..q:(classDesc'="")&&(rowData.GetAt("ClassDesc")'[classDesc)
    ..s ret=..ArrayToString(rowData)
    ..d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:保存库表
/// Table:CT.DHCINM.LCDP.MgClass
/// Input：各字段键值对
/// Output
/// Return:
/// Others:d $CLASSMETHOD("web.INMLCDPComm","SaveLCDPClass","1")
ClassMethod SaveLCDPClass(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %String
{
    q:array.Count()=0 "入参为空"
    s className=array.GetAt("ClassName")
    q:$d(^CT.DHCINM.LCDP.MgClassI("ClassName"," "_$zcvt(className,"U")))=10 "类名已存在"
    s sc=..SaveData("CT.DHCINM.LCDP.MgClass",array)
    if $$$ISOK(sc) {
        q 1 
    }else{
        q "保存失败"    
    }
}

/// Creator:liwenzhen
/// Createdate:2022-10-27
/// Description:查询DHCINM项目下所有类
/// Input:type：E:实体类 B:业务类
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindDHCINMClass")
Query FindDHCINMClass(type As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDHCINMClassExecute(ByRef qHandle As %Binary, type As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s searchName=array.GetAt("ClassName")
    s className="" f  s className=$o(^oddPROJECT("DHCINM","Items",className)) q:className=""  d
    .q:(searchName'="")&&(className'[searchName)
    .q:$o(^oddPROJECT("DHCINM","Items",className,""))'="CLS"
    .s classType="E" //实体类
    .s:'..IsEntity(className) classType="B"
    .q:(type'="")&&(type'=classType)
    .s ret="ClassName|"_className
    .d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-10-27
/// Description:查询某类下所有方法与Query
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindProp","CT.DHCINM.DB.MgQualItem",##class(web.INMCommon).Decode(^tmp("FindMethod")))
Query FindProp(className As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPropExecute(ByRef qHandle As %Binary, className As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s ^tmp("FindMethod")=##class(web.INMCommon).Encode(array)
    s searchName=$zcvt(array.GetAt("PropName"),"U")
    s searchDesc=array.GetAt("PropDesc")
    i (className="")||('..IsEntity(className)) Set qHandle=$lb(0,repid,0) Quit $$$OK
    k propTmp
    d ..GetProperties(className,.propTmp)
    s propName="" f  s propName=$o(^oddCOM(className,"a",propName)) q:propName=""  d
    .q:(searchName'="")&&($zcvt(propName,"U")'[searchName)
    .q:'..IsStoredProp(className,propName)
    .s globalNum=$g(propTmp(propName))
    .s description=$g(^oddDEF(className,"a",propName,4))
    .q:(searchDesc'="")&&(description'[searchDesc) 
    .d ExtractStr(.description)
    .s propDesc=$p(description," ",1)
    .s remark=$e(description,$l(propDesc)+1,$l(description))
    .d EscapeStr
    .s ret="GlobalNum|"_globalNum_"^PropertyName|"_propName_"^PropertyDesc|"_propDesc_"^Remark|"_remark
    .d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
EscapeStr
    s propDesc=##class(web.INMCommon).Escape(propDesc)
    s remark=##class(web.INMCommon).Escape(remark)

ExtractStr(str)
    s (strStart,isFind)=0
    s strLen=$l(str)
    f i=1:1:strLen q:isFind=1  d
    .s char=$e(str,i)
    .s strStart=strStart+1
    .s:char'=" " isFind=1
    s str=$e(str,strStart,strLen)
    q str
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-10-27
/// Description:查询某类下所有方法与Query
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMLCDPComm","FindMethod","web.INMLCDPComm","",##class(web.INMCommon).Decode(^tmp("FindMethod")))
Query FindMethod(className As %String = "", type As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindMethodExecute(ByRef qHandle As %Binary, className As %String = "", type As %String = "", array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s ^tmp("FindMethod")=##class(web.INMCommon).Encode(array)
    s searchName=array.GetAt("MethodName")
    s searchFullName=array.GetAt("FullMethodName")
    i className="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s findType("m")="m",findType("q")="q"
    s methodType="" f  s methodType=$o(findType(methodType),-1) q:methodType=""  d
    .q:(type'="")&&(type'=$zcvt(methodType,"U"))
    .s methodName="" f  s methodName=$o(^oddDEF(className,methodType,methodName)) q:methodName=""  d
    ..q:($g(^oddCOM(className,methodType,methodName,72))'="")&&(methodType="m")
    ..q:(searchFullName'="")&&(methodName'=searchFullName)
    ..q:(searchName'="")&&($zcvt(methodName,"U")'[$zcvt(searchName,"U"))
    ..s ret=..GetMethod(className,methodName,methodType)
    ..d ret.RemoveAt("MethodParam")
    ..s ret=..ArrayToString(ret)
    ..d OutList
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutList
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:获取方法
/// Table: %Dictionary.MethodDefinition
/// Input：各字段键值对
/// Output
/// Return:
/// Others:w ##class(web.INMCommon).Encode(##class(web.INMLCDPComm).GetMethod("web.INMLCDPComm","GetMethod","M"))
ClassMethod GetMethod(className As %String = "", methodName As %String = "", methodType As %String = "M") As %ArrayOfDataTypes
{
    s method=##class(%ArrayOfDataTypes).%New()
    
    s methodType=$zcvt(methodType,"L")
    s returnType=$g(^oddDEF(className,methodType,methodName,42)) //返回值类型
    s description=$g(^oddDEF(className,methodType,methodName,4)) //方法备注
    s methodDesc=""
    f i=1:1:$l(description,$c(13,10)) q:methodDesc'=""  d
    .s rowdata=$p(description,$c(13,10),i)
    .q:rowdata=""
    .s rowdata=$tr(rowdata,"：",":")
    .s key=$zcvt($p(rowdata,":",1),"U")
    .q:(key="")||(key'=$zcvt("Description","U"))
    .s methodDesc=$tr($p(rowdata,":",2),$c(32),"")
    s paramDesc=""
    s paramList=##class(%ListOfDataTypes).%New()
    s methodParam=$g(^oddCOM(className,methodType,methodName,60),$g(^oddCOM(className,methodType,methodName,34)))
    s ptr=0 f  s status=$listnext(methodParam,ptr,item) q:status'=1  d
    .s paramArray=##class(%ArrayOfDataTypes).%New()
    .s param=$lg(item,1)
    .s $list(paramDesc,*+1)=param
    .s default=$lg(item,3)
    .d paramArray.SetAt(param,"Key")
    .d paramArray.SetAt(default,"Value")
    .d paramList.Insert(paramArray)
    s paramDesc=$lts(paramDesc)
    d method.SetAt(methodName,"MethodName")
    d method.SetAt(methodDesc,"MethodDesc")
    d method.SetAt($zcvt(methodType,"U"),"MethodType")
    d method.SetAt(paramDesc,"ParamDesc")
    d method.SetAt(className,"ClassName")
    d method.SetAt(paramList,"MethodParam")
    q method
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:保存API
/// Table:CT.DHCINM.LCDP.MgAPI
/// Input：各字段键值对
/// Output
/// Return:
/// Others:w ##class(web.INMLCDPComm).SaveAPI(##class(web.INMCommon).Decode(^tmp("SaveAPI")))
ClassMethod SaveAPI(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %String
{
    q:($ClassName(array)'="%Library.ArrayOfDataTypes")||(array.Count()=0) "入参为空"
    d array.SetAt(..ListArrayToString(array.GetAt("APIParameter"),"Key,Value",$c(63)),"APIParameter")
    d array.SetAt(..ListArrayToString(array.GetAt("ReturnList"),"ReturnDesc,ReturnCode,IsLabel,IsValue",$c(63)),"ReturnList")
    s sc=..SaveData("CT.DHCINM.LCDP.MgAPI",array)
    if $ISVALIDNUM(sc)&&(sc>0) {
        q sc 
    }else{
        q "保存失败"    
    }
}

/// Creator:liwenzhen
/// Createdate:2022-10-16
/// Description:获取单条API
/// Table:CT.DHCINM.LCDP.MgAPI
/// Input：rowid
/// Output
/// Return:
/// Others:w ##class(web.INMCommon).Encode(##class(web.INMLCDPComm).GetAPI(4))
ClassMethod GetAPI(id) As %String
{
    s API=..GetData("CT.DHCINM.LCDP.MgAPI",id)
    d API.SetAt(..StringToListArray(API.GetAt("APIParameter"),"Key,Value",$c(63)),"APIParameter")
    d API.SetAt(..StringToListArray(API.GetAt("ReturnList"),"ReturnDesc,ReturnCode,IsLabel,IsValue",$c(63)),"ReturnList")
    q API
}

/// Creator:liwenzhen
/// Createdate:2022-11-15
/// Description:获取字段可用类型
/// Table:CT.DHCINM.LCDP.MgResource
/// Input：
/// Output
/// Return:
/// Others:w ##class(web.INMCommon).Encode(##class(web.INMLCDPComm).GetRefType())
ClassMethod GetRefType(array As %ArrayOfDataTypes = {##class(%ArrayOfDataTypes).%New()}) As %String
{
    //基本类型
    s basicType=$lb("%String","%Date","%Time","%Stream.GlobalCharacter")
    s basicDesc=$lb("字符串","日期","时间","字符流")
    s list=##class(%ListOfDataTypes).%New()
    s basicArray=##class(%ArrayOfDataTypes).%New()
    d basicArray.SetAt("基本类型","label")
    s basicOptions=##class(%ListOfDataTypes).%New()
    f i=1:1:$ll(basicType) d
    .s optionArray=##class(%ArrayOfDataTypes).%New()
    .d optionArray.SetAt($lg(basicDesc,i),"label")
    .d optionArray.SetAt($lg(basicType,i),"value")
    .d basicOptions.Insert(optionArray)
    d basicArray.SetAt(basicOptions,"options")
    d list.Insert(basicArray)
    
    //自定义类型
    s customArray=##class(%ArrayOfDataTypes).%New()
    d customArray.SetAt("自定义类型","label")
    s customOptions=##class(%ListOfDataTypes).%New()
    s id="" f  s id=$o(^CT.DHCINM.LCDP.MgResourceI("IsRef"," Y",id)) q:id=""  d
    .s global=$g(^CT.DHCINM.LCDP.MgResourceD(id))
    .s stDate=$lg(global,5)
	.q:(stDate'="")&&(stDate>+$h)
    .s endDate=$lg(global,6)
	.q:(endDate'="")&&(endDate<+$h)
    .s optionArray=##class(%ArrayOfDataTypes).%New()
    .d optionArray.SetAt($lg(global,7),"label")
    .d optionArray.SetAt($lg(global,8),"value")
    .d customOptions.Insert(optionArray)
    d customArray.SetAt(customOptions,"options")
    d list.Insert(customArray)

    q list
}

}
