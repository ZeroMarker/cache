/// 名称: DHCMed.CR.PO.Form
/// 描述: 自定义表单
/// 编写者：wuqk
/// 编写日期: 2012-11-22
Class DHCMed.CR.PO.Form Extends (%Persistent, %XML.Adaptor) [ Owner = {}, Not ProcedureBlock ]
{

/// 中文名称
Property CName As %String(TRUNCATE = 1);

/// 英文名称（即数据库类名）
Property EName As %String(TRUNCATE = 1) [ Required ];

/// 类型  -- DHCMed
Property ESchema As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 类型  -- 产品代码
Property Type As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 业务相关性  -- DHCMed.SS.Dictionary code="CRBusiness"
Property Business As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 状态
Property Status As %String(MAXLEN = 20, TRUNCATE = 1);

/// 状态：1：已经创建，其他：未创建
Property IsCreate As %String(MAXLEN = 2, TRUNCATE = 1);

//Property htmlLayout As %Library.GlobalCharacterStream;

//Property djLayout As %Library.GlobalCharacterStream;

Index IndexTypeName On (ESchema, Type, EName) [ Unique ];

/// 当前发布版本ID
Property CurrentVerID As %String;

Relationship Versions As DHCMed.CR.PO.FormVer [ Cardinality = children, Inverse = Form ];

/// 状态列表
Relationship StatusList As DHCMed.CR.PO.FormStatus [ Cardinality = children, Inverse = Form ];

Query QueryQll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CName,EName,ESchema,Type FROM Form
}

/*
Query QueryQll1() As %SQLQuery(CONTAINID = 1)
{
	SELECT ESchema _"."_ Type _"."_ EName AS Code, CName,EName,ESchema,Type FROM Form where CurrentVerID is not null
}
*/
/// d ##class(%ResultSet).RunQuery("DHCMed.CR.PO.Form","QueryQll1")
Query QueryQll1() As %Query(ROWSPEC = "Code:%String, CName:%String,EName:%String,ESchema:%String,Type:%String")
{
}

ClassMethod QueryQll1Execute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^DHCMed.CR.PO.FormD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CR.PO.Form).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.CurrentVerID=""
	.s $li(data,1)=obj.ESchema_"."_obj.Type_"."_obj.EName
	.s $li(data,2)=obj.CName
	.s $li(data,3)=obj.EName
	.s $li(data,4)=obj.ESchema
	.s $li(data,5)=obj.Type
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QueryQll1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryQll1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryQll1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryQll1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Method GetClassName() As %String
{
	quit i%ESchema_"."_i%Type_"."_i%EName
}

/// Creator：     zhufei
/// CreatDate：   2013-12-18
/// Description:  根据ID取类名
/// Table：       DHCMed.CR.PO.Form
/// Input：       ID:    DHCMed.CR.PO.Form.ID
/// Return：      返回string
/// w ##class(DHCMed.CR.PO.Form).GetClassNameById(1)
ClassMethod GetClassNameById(aId) As %String
{
	new (aId)
	set return=""
	quit:aId="" return
	
	set obj=##class(DHCMed.CR.PO.Form).GetObjById(aId)
	quit:'$IsObject(obj) return
	set return=obj.GetClassName()
	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2012-12-18
/// Description:  根据ID取表单信息
/// Table：       DHCMed.CR.PO.Form
/// Input：       ID:    DHCMed.CR.PO.Form.ID
/// Return：      返回obj
/// w ##class(DHCMed.CR.PO.Form).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CR.PO.Form
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.Form).%ExistsId(+id) return
	set obj=##Class(DHCMed.CR.PO.Form).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     mxp
/// CreatDate：   2012-12-21
/// Description:  根据ID获取表单信息
/// Table：       DHCMed.CR.PO.Dic
/// Input：       ID:    表单ID
///               separete: 指定的分隔符
/// Return：      字符串形式的表单信息
/// w ##class(DHCMed.CR.PO.Form).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	set:$g(separete)="" separete="^"
	if $IsObject(obj){
		set return=obj.%Id()_separete
		set return=return_obj.CName_separete
		set return=return_obj.EName_separete
		set return=return_obj.ESchema_separete
		set return=return_obj.Type_separete
		set return=return_obj.Business_separete
		;set return=return_obj.Status_separete
		;set return=return_obj.IsCreate_separete
		;set return=return_obj.CurrentVerID
		;set return=obj.ToString($g(separete))
	}	
	quit return
}

///  Creator：     mxp
///  CreatDate：   2012-12-21
///  Description:  保存表单对象
///  Table：       DHCMed.CR.PO.Dic
///  Input：       各属性列表 ^分隔
///  Return：      成功：返回id，失败：返回<0的代码
///  d ##class(DHCMed.CR.PO.Form).Update()
ClassMethod Update(InStr)
{
	New (InStr)
	Set return=0
	Quit:InStr="" return
	
	Set separete="^"
	Set ID=$p(InStr,separete,1)
	
	If ID="" {
		Set obj=##class(DHCMed.CR.PO.Form).%New()
	}Else{
		Set obj=##class(DHCMed.CR.PO.Form).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CName=$p(InStr,separete,2)
	Set obj.EName=$p(InStr,separete,3)
	Set obj.ESchema=$p(InStr,separete,4)
	Set obj.Type=$p(InStr,separete,5)
	Set obj.Business=$p(InStr,separete,6)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     mxp
/// CreatDate：   2012-12-21
/// Description:  获取表单业务相关性信息
/// Table：       DHCMed.SS.Dictionary
/// w ##class(DHCMed.CR.PO.Form).GetBusiness()
ClassMethod GetBusiness() As %String
{
	s return=""
	s Rowid=""
	s argType="CRBusiness"  //实际数据字典代码， 217上是"CRFFormType"
	f{
		s data="["
		s Rowid=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT(argType,"U"),Rowid))
		Quit:Rowid=""
		Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(Rowid)
		;if objDic.Active d
		s data=data_objDic.Code_",'"_objDic.Description_"']"
		;s data=data_"'"_objDic.Code_"','"_objDic.Description_"']"  //217
		s:return'="" return=return_","
		s return=return_data
		d objDic.%Close()
	}
	q "["_return_"]"
}

/// 通过表单代码来获取表单信息
/// Add By LiYang 2013-11-11
/// 参数：
/// FormCode:表单代码，格式为ESchema.Type.EName
/// 返回：String
ClassMethod GetByFormCode(FormCode As %String)
{
	n (FormCode)
	Set ESchema=" "_$ZConvert($p(FormCode,".",1),"U")
	Set Type=" "_$ZConvert($p(FormCode,".",2),"U")
	Set EName=" "_$ZConvert($p(FormCode,".",3),"U")
		
	Set FrmID=$o(^DHCMed.CR.PO.FormI("IndexTypeName",ESchema,Type,EName,""))
	Quit:FrmID="" ""
	Set ret=##class(DHCMed.CR.PO.Form).GetStringById(FrmID)
	Quit ret
}

Storage Default
{
<Data name="FormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>EName</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>IsCreate</Value>
</Value>
<Value name="7">
<Value>djFile</Value>
</Value>
<Value name="8">
<Value>htmlFile</Value>
</Value>
<Value name="9">
<Value>htmlLayout</Value>
</Value>
<Value name="10">
<Value>djLayout</Value>
</Value>
<Value name="11">
<Value>ESchema</Value>
</Value>
<Value name="12">
<Value>CurrentVerID</Value>
</Value>
<Value name="13">
<Value>Business</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.FormD</DataLocation>
<DefaultData>FormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.FormD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.FormI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.FormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
