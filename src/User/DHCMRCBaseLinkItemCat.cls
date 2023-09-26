/// 名称: User.DHCMRCBaseLinkItemCat
/// 描述: 关联项目大类
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class User.DHCMRCBaseLinkItemCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BLICCode As %String(MAXLEN = 20) [ Required ];

/// 描述
Property BLICDesc As %String(MAXLEN = 100) [ Required ];

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  将对象格式化为字符串
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:BLICCode 3:BLICDesc
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..BLICCode_separete
	set return=return_..BLICDesc_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目大类对象
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       ID:    User.DHCMRCBaseLinkItemCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As User.DHCMRCBaseLinkItemCat
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(User.DHCMRCBaseLinkItemCat).%ExistsId(+id) return
	set obj=##Class(User.DHCMRCBaseLinkItemCat).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目大类信息
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       id: User.DHCMRCBaseLinkItemCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemCat).GetStringById(1)
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
/// CreatDate：   2012-02-08
/// Description:  更新关联项目大类
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:BLICCode 3:BLICDesc 4:SubjectDr
/// w ##Class(User.DHCMRCBaseLinkItemCat).Update("^001^002")
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCBaseLinkItemCat).%New()
	}Else{
		Set obj=##class(User.DHCMRCBaseLinkItemCat).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.BLICCode=$p(InStr,"^",2)
	Set obj.BLICDesc=$p(InStr,"^",3)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {            //检查Save是否成功
		//Do $System.Status.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
	
UpdateErr
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  删除关联项目大类
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(User.DHCMRCBaseLinkItemCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     赵宇
/// CreatDate：   2012-11-30
/// Description:  检查BLICCode是否重复  临床路径维护-关联项目-增加关联项目大类，代码可以重复 192
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       User.DHCMRCBaseLinkItemCat.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(User.DHCMRCBaseLinkItemCat).CheckBLICCode("1","")
ClassMethod CheckBLICCode(argCode As %String, argRowid As %String) As %String
{
	New (argCode,argRowid)
	Set return=0
	Quit:argCode="" return
	
	Set BLICRowid=""
	For {
		Set BLICRowid=$o(^DHCMRC("BLIC",BLICRowid))
		Quit:(BLICRowid="")||(return=1)
		Set objBLIC=..GetObjById(BLICRowid)
		Set Code=objBLIC.BLICCode
		Continue:(argRowid'="")&&(argRowid=BLICRowid)
		Continue:Code'=argCode
		Set return=1
	}
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLICCode</Value>
</Value>
<Value name="3">
<Value>BLICDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BLIC")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BLIC")</IdLocation>
<IndexLocation>^DHCMRCi("BLIC",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseLinkItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
