/// 函数包
/// 创建者：zhufei
/// 创建日期：2012-02-08
Class User.DHCMRCBaseLinkMethodPackage Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BLMPCode As %String;

/// 名称
Property BLMPName As %String [ Required ];

/// 是否有效
Property BLMPIsActive As %Boolean;

/// 备注
Property BLMPResumeText As %String;

Index BLMPCodeIndex On BLMPCode [ Unique ];

Index BLMPNameIndex On BLMPName [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  将对象格式化为字符串
/// Table：       User.DHCMRCBaseLinkMethodPackage
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:BLMPCode 2:BLMPName 3:BLMPIsActive 4:Resume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..BLMPCode_separete
	set return=return_..BLMPName_separete
	set return=return_..BLMPIsActive_separete
	set return=return_..BLMPResumeText_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID获取函数包信息
/// Table：       User.DHCMRCBaseLinkMethodPackage
/// Input：       ID:   User.DHCMRCBaseLinkMethodPackage.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkMethodPackage).GetObjById(1)
ClassMethod GetObjById(id As %String) As User.DHCMRCBaseLinkMethodPackage
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(User.DHCMRCBaseLinkMethodPackage).%ExistsId(+id) return
	set obj=##Class(User.DHCMRCBaseLinkMethodPackage).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取函数包信息
/// Table：       User.DHCMRCBaseLinkMethodPackage
/// Input：       ID:    User.DHCMRCBaseLinkMethodPackage.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkMethodPackage).GetStringById(1)
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
/// Description:  更新函数包信息
/// Table：       User.DHCMRCBaseLinkMethodPackage
/// Input:        rowid^BLMPCode^BLMPName^BLMPIsActive^BLMPResumeText
/// Return：      
/// w ##Class(User.DHCMRCBaseLinkMethodPackage).Update()
ClassMethod Update(InStr As %String) As %Integer
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(User.DHCMRCBaseLinkMethodPackage).%New()
		} 
	else {
		set obj=##class(User.DHCMRCBaseLinkMethodPackage).%OpenId(ID)
		}
	set obj.BLMPCode=$p(InStr,"^",2)
	set obj.BLMPName=$p(InStr,"^",3)
	set obj.BLMPIsActive=$s($p(InStr,"^",4)="Y":1,1:0)
	set obj.BLMPResumeText=$p(InStr,"^",5)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     赵宇
/// CreatDate：   2013-04-28
/// Description:  检查BLMPCode是否重复  临床路径维护-函数库-包名维护，代码重复，保存界面报错Key not unique 250
/// Table：       User.DHCMRCBaseLinkMethodPackage
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(User.DHCMRCBaseLinkMethodPackage).CheckBLMPCode("")
ClassMethod CheckBLMPCode(argStr As %String) As %String
{
	New (argStr)
	Set return=0
	Set argStr=$g(argStr),argRowid=$p(argStr,"^",1),argCode=$p(argStr,"^",2)
	Quit:(argStr="")||(argCode="") return
	// ^DHCMRC("BLMP",1
	Set BLMPRowid=""
	For {
		Set BLMPRowid=$o(^DHCMRC("BLMP",BLMPRowid))
		Quit:(BLMPRowid="")||(return=1)
		Continue:(argRowid'="")&&(argRowid=BLMPRowid)
		Set objBLMP=..GetObjById(BLMPRowid)
		Set BLMPCode=objBLMP.BLMPCode
		Continue:BLMPCode'=argCode
		Set return=1
	}
	Quit return
}

/// 通过类库包的名称查找包信息
ClassMethod GetPackageByName(PackageName) As User.DHCMRCBaseLinkMethodPackage
{
	n (PackageName)
	q:PackageName="" ""
	s PackageName=" "_$ZCVT(PackageName,"U")
	s rowid=$o(^DHCMRCi("BLMP",0,"BLMPNameIndex",PackageName,""))
	q:rowid="" "" //没找到~~
	s objPackage=..GetObjById(rowid)
	q objPackage
}

/// 查询包列表
Query QueryPackage(BLMPIsActive As %Boolean) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,BLMPCode,BLMPIsActive,BLMPName,BLMPResumeText FROM DHCMRCBaseLinkMethodPackage
 WHERE (BLMPIsActive = :BLMPIsActive)
 ORDER BY BLMPName
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BLMPCode</Value>
</Value>
<Value name="3">
<Value>BLMPName</Value>
</Value>
<Value name="4">
<Value>BLMPIsActive</Value>
</Value>
<Value name="5">
<Value>BLMPResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BLMP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BLMP")</IdLocation>
<IndexLocation>^DHCMRCi("BLMP",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseLinkMethodPackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
