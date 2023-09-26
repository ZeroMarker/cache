/// 名称: User.DHCMRCBaseLinkItemSubCat
/// 描述: 关联项目子类
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class User.DHCMRCBaseLinkItemSubCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BLISCCode As %String(MAXLEN = 20) [ Required ];

/// 描述
Property BLISCDesc As %String(MAXLEN = 100) [ Required ];

/// 大类
Property BLISCCatDr As User.DHCMRCBaseLinkItemCat;

Index BLISCCodeIndex On (BLISCCatDr, BLISCCode) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  将对象格式化为字符串
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:BLISCCode 3:BLISCDesc 4:BLISCCatDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	set return=..%Id()_separete
	set return=return_..BLISCCode_separete
	set return=return_..BLISCDesc_separete
	set BLISCCatDr=""
	if $IsObject(..BLISCCatDr)
	{
		set BLISCCatDr=..BLISCCatDr.%Id()
	}
	set return=return_BLISCCatDr
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目子类信息
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       ID:    User.DHCMRCBaseLinkItemSubCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemSubCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As User.DHCMRCBaseLinkItemSubCat
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(User.DHCMRCBaseLinkItemSubCat).%ExistsId(+id) return
	set obj=##Class(User.DHCMRCBaseLinkItemSubCat).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目子类信息
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       ID:    User.DHCMRCBaseLinkItemSubCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemSubCat).GetStringById(1)
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
/// Description:  更新关联项目子类
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:BLISCCode 3:BLISCDesc 4:BLISCCatDr
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set $ZT="UpdateErr"
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(User.DHCMRCBaseLinkItemSubCat).%New()
	} else {
		set obj=##class(User.DHCMRCBaseLinkItemSubCat).%OpenId(ID)
	}
	set obj.BLISCCode=$p(InStr,"^",2)
	set obj.BLISCDesc=$p(InStr,"^",3)
	set obj.BLISCCatDr=##class(User.DHCMRCBaseLinkItemCat).GetObjById($p(InStr,"^",4))
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {   //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
UpdateErr
	quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  删除关联项目子类
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       ContentDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set ret=0
	//set $ZT="DeleteByIdErr"
	set sc = ##class(User.DHCMRCBaseLinkItemSubCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
DeleteByIdErr
	quit -1
}

/// Creator：     赵宇
/// CreatDate：   2012-11-30
/// Description:  检查BLISCCode是否重复  临床路径维护-关联项目-增加代码重复的关联项目子类，提示"更新失败"，建议给出明确提示 191
/// Table：       User.DHCMRCBaseLinkItemSubCat
/// Input：       User.DHCMRCBaseLinkItemSubCat.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(User.DHCMRCBaseLinkItemSubCat).CheckBLISCCode("001","")
ClassMethod CheckBLISCCode(argCode As %String, argRowid As %String) As %String
{
	New (argCode,argRowid)
	Set return=0
	Quit:argCode="" return
	
	Set BLISCRowid=""
	For {
		Set BLISCRowid=$o(^DHCMRC("BLISC",BLISCRowid))
		Quit:(BLISCRowid="")||(return=1)
		Set objBLISC=..GetObjById(BLISCRowid)
		Set Code=objBLISC.BLISCCode
		Continue:(argRowid'="")&&(argRowid=BLISCRowid)
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
<Value>BLISCCode</Value>
</Value>
<Value name="3">
<Value>BLISCDesc</Value>
</Value>
<Value name="4">
<Value>BLISCCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BLISC")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BLISC")</IdLocation>
<IndexLocation>^DHCMRCi("BLISC",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseLinkItemSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
