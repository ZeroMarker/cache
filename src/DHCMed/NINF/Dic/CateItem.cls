/// 名称: DHCMed.NINF.Dic.CateItem
/// 描述: 院感字典分类项目，存储各种多级分类下的字典项目
/// 编写者：zhufei
/// 编写日期: 2013-06-22
Class DHCMed.NINF.Dic.CateItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// Code 代码
Property Code As %Library.String(TRUNCATE = 1);

/// Desc 描述
Property Description As %Library.String(TRUNCATE = 1);

/// Category 分类
Property Category As %Library.String(TRUNCATE = 1);

/// Active 是否有效
Property Active As %Boolean;

/// ResumeText  备注
Property ResumeText As %Library.String(TRUNCATE = 1);

/// 以类型、代码为索引
Index IndexTypeCode On (Category, Code) [ Unique ];

/// 以类型、描述为索引
Index IndexTypeDesc On (Category, Description);

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Description 4:Category 5:Active 7:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..Category_separete
	set return=return_..Active_separete
	set return=return_..ResumeText_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// Description:  根据ID取分类项目对象
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       ID:    DHCMed.NINF.Dic.CateItem.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.CateItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Dic.CateItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Dic.CateItem).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Dic.CateItem).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// Description:  根据ID取分类项目信息
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       ID:    DHCMed.NINF.Dic.CateItem.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.NINF.Dic.CateItem).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// Description:  更新分类项目字典
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Description 4:Category 5:Active 7:ResumeText
/// w ##class(DHCMed.NINF.Dic.CateItem).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID=$p(InStr,separete,1)
	Set Code=$p(InStr,separete,2)
	Set Desc=$p(InStr,separete,3)
	Set Category=$p(InStr,separete,4)
	
	//特殊处理,主要是针对重复导数据问题
	Set:ID="" ID=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$ZCVT(Category,"U")," "_$ZCVT(Code,"U"),0))
	
	If ID="" {
		Set obj=##class(DHCMed.NINF.Dic.CateItem).%New()
	}Else{
		Set obj=##class(DHCMed.NINF.Dic.CateItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Code=Code
	Set obj.Description=Desc
	Set obj.Category=Category
	Set obj.Active=+$p(InStr,separete,5)
	Set obj.ResumeText=$p(InStr,separete,6)
	
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

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// Description:  删除分类项目
/// Table：       DHCMed.NINF.Dic.CateItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Dic.CateItem).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2013-06-22
/// 功能：通过字典的类别、代码查询字典项目
/// 参数描述：
/// Type:字典类别
/// Code:字典项目代码
/// set obj = ##class(DHCMed.NINF.Dic.CateItem).GetByTypeCode(type,code)
ClassMethod GetByTypeCode(argType As %String, argCode As %String, argIsActive As %String = "") As DHCMed.NINF.Dic.CateItem
{
	New (argType,argCode,argIsActive)
	Set return=""
	Set argType=$ZCVT(argType,"U")
	Set argCode=$ZCVT(argCode,"U")
	Quit:(argType="")||(argCode="") return
	Quit:'$d(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_argType," "_argCode)) return
	Set Rowid=""
	For {
		Set Rowid=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_argType," "_argCode,Rowid))
		Quit:Rowid=""
		Set objDic=##class(DHCMed.NINF.Dic.CateItem).%OpenId(Rowid)
		Continue:'$IsObject(objDic)
		Do objDic.%Close()
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(IsActive'=argIsActive)
		Set return=objDic
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-02-26
/// 查询分类项目
/// D ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.CateItem","QueryByCate","MDRPY","")
Query QueryByCate(aDicTypeID As %String, aDicTypeCode As %String, aIsActive As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Description:%String,Category:%String,IsActive:%String,ResumeText:%String") [ SqlProc ]
{
}

ClassMethod QueryByCateExecute(ByRef qHandle As %Binary, aDicTypeID As %String, aDicTypeCode As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	if aDicTypeID'="" {
	 	set objDicType=##class(DHCMed.NINF.Dic.Cate).GetObjById(aDicTypeID)
	 	if $d(objDicType) {
		 	set aDicTypeCode=objDicType.Code
		}
	}
 	
 	set code = ""
 	for {
		set code=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aDicTypeCode,"U"),code))
		quit:code=""
		set rowid=0
		for {
		 	set rowid=$o(^DHCMed.NINFDi("CateItem",0,"IndexTypeCode"," "_$zcvt(aDicTypeCode,"U"),code,rowid))
		 	quit:rowid=""
		 	
		 	set objCate=..GetObjById(rowid)
		 	if $IsObject(objCate) {
			 	set Code=objCate.Code
			 	set Description=objCate.Description
			 	set Category=objCate.Category
			 	set Active=objCate.Active
			 	set ResumeText=objCate.ResumeText
			 	set Data=$lb(rowid,Code,Description,Category,Active,ResumeText)
			 	set ^CacheTemp(repid,ind)=Data
			 	set ind=ind+1
		 	}
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByCateExecute ]
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Category</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("CateItem")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("CateItem")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("CateItem",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.CateItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
