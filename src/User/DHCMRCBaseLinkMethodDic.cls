/// 监控类库暴露的函数
/// 创建者：zhufei
/// 创建日期：2012-02-08
Class User.DHCMRCBaseLinkMethodDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 所属包的ID
Property BLMDPackageID As User.DHCMRCBaseLinkMethodPackage;

/// 函数名称
Property BLMDName As %String [ Required ];

/// 书写格式
Property BLMDClassMethod As %String(MAXLEN = 100);

/// 是否有效
Property BLMDIsActive As %Boolean;

/// 备注
Property BLMDResumeText As %String;

/// 默认返回值
Property BLMDDefaultValue As %String;

Index BLMDPackageIDIndex On BLMDPackageID;

Index BLMDNameIndex On (BLMDName, BLMDPackageID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  将对象格式化为字符串
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:BLMDPackageID 2:Name 3:ClassMethod 4:BLMDIsActive 5:BLMDDefaultValue 6:BLMDResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set BLMDPackageID=""
	if $IsObject(..BLMDPackageID)
	{
		set BLMDPackageID=..BLMDPackageID.%Id()
	}
	set return=return_BLMDPackageID_separete
	set return=return_..BLMDName_separete
	set return=return_..BLMDClassMethod_separete
	set return=return_..BLMDIsActive_separete
	set return=return_..BLMDDefaultValue_separete
	set return=return_..BLMDResumeText_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取监控函数信息
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       ID:   User.DHCMRCBaseLinkMethodDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkMethodDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As User.DHCMRCBaseLinkMethodDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(User.DHCMRCBaseLinkMethodDic).%ExistsId(+id) return
	set obj=##Class(User.DHCMRCBaseLinkMethodDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  根据ID取监控函数信息
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       ID:    User.DHCMRCBaseLinkMethodDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(User.DHCMRCBaseLinkMethodDic).GetStringById(1)
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
/// Description:  根据ID取监控主题信息
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       rowid^BLMDPackageID^BLMDName^BLMDClassMethod^BLMDIsActive^BLMDDefaultValue^BLMDResumeText
/// w ##class(User.DHCMRCBaseLinkMethodDic).Update()
ClassMethod Update(InStr As %String) As %Integer
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	set BLMDPackageID=$p(InStr,"^",2)
	if ID="" {
		set obj=##class(User.DHCMRCBaseLinkMethodDic).%New()
	} else {
		set obj=##class(User.DHCMRCBaseLinkMethodDic).%OpenId(ID)
	}
	set obj.BLMDPackageID=##class(User.DHCMRCBaseLinkMethodPackage).GetObjById(BLMDPackageID)
	set obj.BLMDName=$p(InStr,"^",3)
	set obj.BLMDClassMethod=$p(InStr,"^",4)
	set obj.BLMDIsActive=$s($p(InStr,"^",5)="Y":1,1:0)
	set obj.BLMDResumeText=$p(InStr,"^",6)
	set obj.BLMDDefaultValue=$p(InStr,"^",7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {       //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// 通过方法名称查询类库方法
ClassMethod GetMethodDicByName(BLMDPackageID, BLMDName) As User.DHCMRCBaseLinkMethodDic
{
	n (BLMDPackageID,BLMDName)
	q:(BLMDPackageID="")!(BLMDName="") ""
	s BLMDName=" "_$ZCVT(BLMDName,"U")
	s rowid=$o(^DHCMRCi("BLMD",0,"BLMDNameIndex",BLMDName,BLMDPackageID,""))
	s obj=..GetObjById(rowid)
	q obj
}

/// 查询包函数
Query QueryMethod(aBLMDPackageID As %String, aBLMDName As %String, aBLMDIsActive As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID,BLMDClassMethod,BLMDDefaultValue,BLMDIsActive,BLMDName,BLMDPackageID,BLMDResumeText FROM DHCMRCBaseLinkMethodDic
	WHERE (BLMDPackageID = :aBLMDPackageID AND BLMDName %STARTSWITH :aBLMDName AND BLMDIsActive = :aBLMDIsActive)
	ORDER BY BLMDName
}

/// Creator：     赵宇
/// CreatDate：   2012-11-30
/// Description:  检查BLMDName是否重复  临床路径维护--基础信息维护--函数库-新增时，若【名称】已存在，提示"Key not unique" 182
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       User.DHCMRCBaseLinkItemDic.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(User.DHCMRCBaseLinkMethodDic).CheckBLMDName("CheckEprTemplate","")
ClassMethod CheckBLMDName(argName As %String, argRowid As %String) As %String
{
	New (argName,argRowid)
	Set return=0
	Quit:argName="" return
	
	Set BLMDRowid=""
	For {
		Set BLMDRowid=$o(^DHCMRC("BLMD",BLMDRowid))
		Quit:(BLMDRowid="")||(return=1)
		Set objBLMD=..GetObjById(BLMDRowid)
		Set Name=objBLMD.BLMDName
		Continue:(argRowid'="")&&(argRowid=BLMDRowid)
		Continue:Name'=argName
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
<Value>BLMDPackageID</Value>
</Value>
<Value name="3">
<Value>BLMDName</Value>
</Value>
<Value name="4">
<Value>BLMDClassMethod</Value>
</Value>
<Value name="5">
<Value>BLMDIsActive</Value>
</Value>
<Value name="6">
<Value>BLMDDefaultValue</Value>
</Value>
<Value name="7">
<Value>BLMDResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BLMD")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BLMD")</IdLocation>
<IndexLocation>^DHCMRCi("BLMD",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseLinkMethodDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
