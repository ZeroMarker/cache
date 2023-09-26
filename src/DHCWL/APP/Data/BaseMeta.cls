Class DHCWL.APP.Data.BaseMeta Extends DHCWL.APP.Data.Meta
{

//d ##class(DHCWL.APP.Data.BaseMeta).Test()

ClassMethod Test()
{
	s meta=##class(DHCWL.APP.Data.BaseMeta).BaseMeta("Person:{Name:%String,Sex:%String,Address:{City:{Name:%String,Where}[],Code:%Integer}[],Mes:%String[]}")
	i +meta=0 {
		w meta,!
		q
	}
	s address=meta.GetProperty("Address")
	i +address=0 {
		w meta,!
		q
	}
	s city=address.GetProperty("City")
	b ;00
}

Property propertyNum As %Integer [ Private ];

Property definedMap [ MultiDimensional, Private ];

ClassMethod BaseMeta(initvalue As %String) As BaseMeta
{
	;s obj=##class(BaseMeta).%New()
	s status= ..initPri(initvalue,.obj)
	q:status'=$$$OK status
	q obj
}

Method GetPropertyCount() As %Integer [ CodeMode = expression ]
{
i%propertyNum
}

Method GetPropertyName(index As %Integer) As %String
{
	q:((index<=0)||(index>i%propertyNum)) ""
	q i%definedMap(..GetClassName(),"Index",index)
}

Method GetAliasName(propertyName As %String) As %String
{
	q:('..CheckValidate(propertyName)) ""
	q i%definedMap(..GetClassName(),"Property",propertyName,"Alias")
}

Method GetPropertyType(propertyName As %String) As %String
{
	q:('..CheckValidate(propertyName)) ""
	if i%definedMap(..GetClassName(),"Property",propertyName,"Complex"){
		q i%definedMap(..GetClassName(),"Property",propertyName,"Type").GetClassName()
	}else{
		q i%definedMap(..GetClassName(),"Property",propertyName,"Type")
	}
}

Method GetPropertyIndex(propertyName As %String) As %Integer
{
	q:('..CheckValidate(propertyName)) 0
	q i%definedMap(..GetClassName(),"Property",propertyName,"Index")
}

Method GetProperty(propertyName As %String) As Meta
{
	q:('..CheckValidate(propertyName)) ""
	if i%definedMap(..GetClassName(),"Property",propertyName,"Complex"){
		q i%definedMap(..GetClassName(),"Property",propertyName,"Type")
	}else{
		q ""
	}
}

Method CanShow(propertyName As %String) As %Boolean
{
	q:('..CheckValidate(propertyName)) 0
	q i%definedMap(..GetClassName(),"Property",propertyName,"Show")
}

Method AvailableShow(propertyName As %String)
{
	q:('..CheckValidate(propertyName))
	s i%definedMap(..GetClassName(),"Property",propertyName,"Show")=1
}

Method DisavailableShow(propertyName As %String)
{
	q:('..CheckValidate(propertyName))
	s i%definedMap(..GetClassName(),"Property",propertyName,"Show")=0
}

Method CopyInstance() As Meta
{
	s copyedObj=##class(BaseMeta).%New()
	s copyedObj.propertyNum=i%propertyNum
	m copyedObj.definedMap=i%definedMap
	q $this
}

Method GetParentMeta() As Meta [ CodeMode = expression ]
{
..definedMap(..GetClassName(),"Parent")
}

Method GetClassName() As %String [ CodeMode = expression ]
{
$o(..definedMap(""))
}

/// <method>GetFullAccessLable</method>得到访问当当前属性的前缀的全访问符
Method GetFullAccessLable() As %String
{
	s access=..GetClassName()
	s meta=..GetParentMeta()
	while(meta){
		s access=meta.GetClassName()_"."_access
		s meta=meta.GetParentMeta()
	}
	q access
}

Method IsArray(propertyName) As %Boolean [ CodeMode = expression ]
{
$d(i%definedMap(..GetClassName(),"Property",propertyName,"Array"))
}

Method ToDefineString() As %String [ CodeMode = expression ]
{
..definedMap(..GetClassName(),"DefineString")
}

/// <method>SetId</method>设置ID字段
Method SetId(propertyList...) As %Status
{
	s idList=""
	f i=1:1:$g(propertyList,0){
		continue:$g(propertyList(i))=""
		if +..GetPropertyIndex(propertyList(i))=0 {
			w propertyList(i)_"属性无效！"
			q
		}
		if idList="" s idList=$g(propertyList(i),"")
		else  s idList=idList_","_$g(propertyList(i),"")
	}
	s ..definedMap(..GetClassName(),"IDDefine")=idList
}

/// <method>GetId</method>取得ID字段
Method GetId() As %Status
{
	if '$d(..definedMap(..GetClassName(),"IDDefine")) q ""
	q ..definedMap(..GetClassName(),"IDDefine")
}

Method CheckValidate(propertyName As %String) As %Boolean [ CodeMode = expression, Private ]
{
$d(i%definedMap(..GetClassName(),"Property",propertyName))
}

/// 根据定义字符串初始化Meta对象，定义字符串格式语法如下：
/// <b>Name1:%Type1,Name2:%Type2[:Head],Name3</b>
/// 注意：<b>名字不能有特殊字符，只能由字母组成</b>
ClassMethod initPri(metaStr = "", Output metObj, parentObj As Meta = "") As %Status [ Private ]
{
	s status=$$$OK
	s classSDeli="{",classEDeli="}",proDeli=",",typeDeli=":",headDeli=":",arraySDeli="[",arrayEDeli="]"
	s classSInd=1,classEInd=0
	s braceSInd=1,braceEInd=0
	s propertyCount=0
	s stack=##class(DHCWL.util.Stack).%New()
	s arrayStack=##class(DHCWL.util.Stack).%New()
	s metaStr=##class(DHCWL.util.StringUtil).Trim(metaStr)
	s metaStrLen=$l(metaStr)
	s preClassInd=1
	s className=""
	f i=1:1:metaStrLen {
		q:status'=$$$OK
		s cur=$e(metaStr,i)
		if (cur=classSDeli) {
			d stack.Push(i)
			s nameEInd=i-1
			while((nameEInd>0)&&($e(metaStr,nameEInd)'=typeDeli)&&($e(metaStr,nameEInd)'=arrayEDeli)){
				s nameEInd=nameEInd-1
			}
			s nameEInd=nameEInd-1
			s nameSInd=nameEInd
			do{
				s tempChar=$e(metaStr,nameSInd)
				q:((tempChar=proDeli)||(tempChar=classSDeli)||(tempChar=arraySDeli))
				s nameSInd=nameSInd-1
			}while(nameSInd>0)
			s nameSInd=nameSInd+1
			if (stack.Size()>1){
				s proName=$e(metaStr,nameSInd,nameEInd)
				s proName=##class(DHCWL.util.StringUtil).Trim(proName)
				if proName="" {
					w "类型名字不能为空",!
					q
				}
				s curDeep=stack.Size()
				f j=i+1:1:metaStrLen {
					s tempChar=$e(metaStr,j)
					if tempChar=classSDeli d stack.Push(i)
					if tempChar=classEDeli {
						if (stack.Size()=curDeep){
							;d stack.Pop()
							q
						}
						d stack.Pop()
					}
				}
				s tempMetaStr=$e(metaStr,nameSInd,j)
				d ..initPri(tempMetaStr,.tempMetaObj,.metObj)
				d stack.Pop()
				s valide=$$ValidName(className)
				if ('valide){
					s status= "名字包括非法字符"
					q
				}
				if ($d(metObj.definedMap(className,"Property",proName))){
					s status= "同一对象下属性名不能相同"
					q
				}
				s metObj.propertyNum=metObj.propertyNum+1
				s metObj.definedMap(className,"Property",proName,"Type")=tempMetaObj
				s metObj.definedMap(className,"Property",proName,"Complex")=1
				s metObj.definedMap(className,"Property",proName,"Index")=metObj.propertyNum
				s metObj.definedMap(className,"Index",metObj.propertyNum)=proName
				f m=j+1:1:metaStrLen {
					s tempChar=$e(metaStr,m)
					q:((tempChar=proDeli)||(tempChar=classSDeli)||(tempChar=classEDeli))
				}
				s arrayStr=$e(metaStr,j+1,m-1)
				s arrayStr=##class(DHCWL.util.StringUtil).Trim(arrayStr)
				if (($e(arrayStr,1)="[")||($e(arrayStr,$l(arrayStr))="]")){
					s metObj.definedMap(className,"Property",proName,"Array")=1 
				}
				s i=m
				continue
			}else{
				s metObj=##class(BaseMeta).%New()
				s className=$e(metaStr,nameSInd,nameEInd)
				s className=##class(DHCWL.util.StringUtil).Trim(className)
				if className="" {
					s status=  "类型名字不能为空"
					q
				}
				s valide=$$ValidName(className)
				if ('valide){
					s status= "名字包括非法字符"
					q
				}
				s metObj.definedMap(className,"Parent")=parentObj
				s metObj.definedMap(className,"DefineString")=metaStr
			}
		}elseif (((cur=proDeli)||(cur=classEDeli))&&(stack.Size()=1)){
			if cur=classEDeli d stack.Pop()
			s proEInd=i-1
			s proSInd=proEInd
			do {
				s tempChar=$e(metaStr,proSInd)
				q:((tempChar=proDeli)||(tempChar=classSDeli)||(tempChar=classEDeli))
				s proSInd=proSInd-1
			}while((proSInd>0))
			continue:proSInd=proEInd
			s proSInd=proSInd+1
			s proDef=$e(metaStr,proSInd,proEInd)
			s proDef=##class(DHCWL.util.StringUtil).Trim(proDef)
			s proName=$p(proDef,headDeli,1)
			s proType=$p(proDef,headDeli,2)
			s:proType="" proType="%String"
			if proName="" {
				s status= "语法错误"
				q
			}
			s valide=$$ValidName(proName)
			if ('valide){
				s status= "名字包括非法字符"
				q
			}
			if ($d(metObj.definedMap(className,"Property",proName))){
				s status= "同一对象下属性名不能相同"
				q
			}
			s arrayStr=$p(proType,"[",2)
			s proType=$p(proType,"[",1)
			if (arrayStr'=""){
				s arrayStr=##class(DHCWL.util.StringUtil).Trim(arrayStr)
				if (arrayStr="]"){
					s metObj.definedMap(className,"Property",proName,"Array")=1 
				}
			}
			s metObj.propertyNum=metObj.propertyNum+1
			s metObj.definedMap(className,"Property",proName,"Type")=proType
			s metObj.definedMap(className,"Property",proName,"Complex")=0
			s metObj.definedMap(className,"Property",proName,"Index")=metObj.propertyNum
			s metObj.definedMap(className,"Index",metObj.propertyNum)=proName
		}
	}
	q status
ValidName(name)
	q 1
	s upName=$SYSTEM.SQL.ALPHAUP(name)
	if $l(upName)'=$l(name) {
		q 0
	}
	if (+$e(name,1)>0) {
		q 0
	}
	q 1
}

}
