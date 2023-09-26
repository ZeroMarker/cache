/// 名称: User.DHCMRCBaseLinkItemDic
/// 描述: 关联项目字典
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class User.DHCMRCBaseLinkItemDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联项目代码
Property BLIDCode As %String(MAXLEN = 20) [ Required ];

/// 关联项目描述
Property BLIDDesc As %String(MAXLEN = 100) [ Required ];

/// 子分类 
Property BLIDSubCatDr As User.DHCMRCBaseLinkItemSubCat;

/// 监控表达式
Property BLIDExpression As %String(MAXLEN = 500) [ Required ];

/// 特殊说明
Property BLIDResume As %String(MAXLEN = 100);

Index BLIDSubCatDrIndex On BLIDSubCatDr;

Index IndexSubCatCode On (BLIDSubCatDr, BLIDCode) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  将对象格式化为字符串
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:BLIDCode 3:BLIDDesc 4:BLIDSubCatDr 5:BLIDExpression 6:BLIDResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..BLIDCode_separete
	set return=return_..BLIDDesc_separete
	set BLIDSubCatDr=""
	if $IsObject(..BLIDSubCatDr) {
		set BLIDSubCatDr=..BLIDSubCatDr.%Id()
	}
	set return=return_BLIDSubCatDr_separete
	set return=return_..BLIDExpression_separete
	set return=return_..BLIDResume
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目字典信息
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       ID:    User.DHCMRCBaseLinkItemDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As User.DHCMRCBaseLinkItemDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(User.DHCMRCBaseLinkItemDic).%ExistsId(+id) return
	set obj=##Class(User.DHCMRCBaseLinkItemDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取关联项目字典信息
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       ID:    User.DHCMRCBaseLinkItemDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkItemDic).GetStringById(1)
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
/// Description:  更新关联项目字典
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:BLIDCode 3:BLIDDesc 4:BLIDSubCatDr 5:BLIDExpression 6:IDRange 7:BLIDResume
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(User.DHCMRCBaseLinkItemDic).%New()
	}else{
		set obj=##class(User.DHCMRCBaseLinkItemDic).%OpenId(ID)
	}
	set obj.BLIDCode=$p(InStr,"^",2)
	set obj.BLIDDesc=$p(InStr,"^",3)
	set obj.BLIDSubCatDr=##class(User.DHCMRCBaseLinkItemSubCat).GetObjById($p(InStr,"^",4))
	set obj.BLIDExpression=$p(InStr,"^",5)
	set obj.BLIDResume=$p(InStr,"^",6)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  删除关联项目
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       ItemDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(User.DHCMRCBaseLinkItemDic).%DeleteId(+Id)
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
/// Description:  检查BLIDCode是否重复  基础信息维护--关联项目--添加的代码重复的监控项目时，提示信息不明确 211
/// Table：       User.DHCMRCBaseLinkItemDic
/// Input：       User.DHCMRCBaseLinkItemDic.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(User.DHCMRCBaseLinkItemDic).CheckBLIDCode("001","")
ClassMethod CheckBLIDCode(argCode As %String, argRowid As %String) As %String
{
	New (argCode,argRowid)
	Set return=0
	Quit:argCode="" return
	
	Set BLIDRowid=""
	For {
		Set BLIDRowid=$o(^DHCMRC("BLID",BLIDRowid))
		Quit:(BLIDRowid="")||(return=1)
		Set objBLID=..GetObjById(BLIDRowid)
		Set Code=objBLID.BLIDCode
		Continue:(argRowid'="")&&(argRowid=BLIDRowid)
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
<Value>BLIDCode</Value>
</Value>
<Value name="3">
<Value>BLIDDesc</Value>
</Value>
<Value name="4">
<Value>BLIDSubCatDr</Value>
</Value>
<Value name="5">
<Value>BLIDExpression</Value>
</Value>
<Value name="6">
<Value>BLIDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BLID")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BLID")</IdLocation>
<IndexLocation>^DHCMRCi("BLID",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseLinkItemDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
