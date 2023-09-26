/// 名称: DHCHAI.DP.PhraseType
/// 描述: 常用短语分类
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.PhraseType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 分类名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 对照字典 指向DHCHAI.BT.DicType.BTCode
Property BTDicType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 代码索引
Index IndexCode On BTCode [ Unique ];

/// 名称索引
Index IndexDesc On BTDesc;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取短语分类
/// Table：       DHCHAI.DP.PhraseType
/// Input：       ID:    DHCHAI.DP.PhraseType.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PhraseType).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.PhraseType
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.PhraseType).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.PhraseType).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-17
/// Description:  根据代码、名称取短语分类
/// Table：       DHCHAI.DP.PhraseType
/// Input：       aCode:    分类代码
/// 			  aDesc:    分类名称
/// Return：      返回Object
/// w ##class(DHCHAI.DP.PhraseType).GetObjByCodeDesc("","")
ClassMethod GetObjByCodeDesc(aCode As %String, aDesc As %String) As DHCHAI.DP.PhraseType
{
	New (aCode,aDesc)
	Set return=""
	Quit:((aCode="")&&(aDesc=""))||((aCode'="")&&(aDesc'="")) return
	
	Set id=""
	Set:aCode'="" id = $o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aCode,"U"),0))
	Set:aDesc'="" id = $o(^DHCHAI.DP.PhraseTypeI("IndexDesc"," "_$zcvt(aDesc,"U"),0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新短语分类
/// Table：       DHCHAI.DP.PhraseType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.PhraseType).Update("^NNISLevel^NNISLevel^NNISLevel")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID	   = $p(InStr,aSeparete,1)
	Set Code   = $p(InStr,aSeparete,2)
	Set Desc   = $p(InStr,aSeparete,3)
	Set DicType= $p(InStr,aSeparete,4)

	Quit:(Code="")||(Desc="")||(DicType="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(Code,"U"),0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	//名称唯一性
	Set tID =$o(^DHCHAI.DP.PhraseTypeI("IndexDesc"," "_$zcvt(Desc,"U"),0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.PhraseType).%New()
	}else{
		Set obj=##class(DHCHAI.DP.PhraseType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTDesc		= Desc
	Set obj.BTDicType	= DicType
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除短语分类
/// Table：       DHCHAI.DP.PhraseType
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.PhraseType).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTDicType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.PhraseTypeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.PhraseTypeD</IdLocation>
<IndexLocation>^DHCHAI.DP.PhraseTypeI</IndexLocation>
<StreamLocation>^DHCHAI.DP.PhraseTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
