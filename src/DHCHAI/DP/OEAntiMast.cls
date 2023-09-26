/// 名称: DHCHAI.DP.OEAntiMast
/// 描述: 医嘱-抗菌药物字典
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.OEAntiMast Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// ATC代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 中文名
Property BTName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 英文名
Property BTName1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗菌药物分类
Property BTCatDr As DHCHAI.DP.OEAntiCat;

/// 有效标志
Property BTIsActive As %Boolean [ Required ];

/// 是否重点药物
Property BTIsKeyDrugs As %Boolean;

/// 抗菌药物分类索引
Index IndexCatDr On BTCatDr;

/// ATC代码索引
Index IndexCode On BTCode As Exact;

/// 中文名索引
Index IndexName On BTName As Exact;

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取抗菌药物字典
/// Table：       DHCHAI.DP.OEAntiMast
/// Input：       ID:    DHCHAI.DP.OEAntiMast.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiMast).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.OEAntiMast
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.OEAntiMast).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.OEAntiMast).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  根据Code取抗菌药物字典
/// Table：       DHCHAI.DP.OEAntiMast
/// Input：       aCode:    DHCHAI.DP.OEAntiMast.Code
/// Return：      返回Object
/// w ##class(DHCHAI.DP.OEAntiMast).GetObjByCode(1)
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.DP.OEAntiMast
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set id=$o(^DHCHAI.DP.OEAntiMastI("IndexCode",aCode,0))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新抗菌药物字典
/// Table：       DHCHAI.DP.OEAntiMast
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.OEAntiMast).Update("^Code^Name^Name1^1^1")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set Code		= $p(InStr,aSeparete,2)
	Set Name		= $p(InStr,aSeparete,3)
	Set Name1		= $p(InStr,aSeparete,4)
	Set CatDr		= $p(InStr,aSeparete,5)
	Set IsActive	= $p(InStr,aSeparete,6)
	Set IsKeyDrugs  = +$p(InStr,aSeparete,7)
	Quit:(Code="")||(Name="")||(IsActive="") return
	Set Name = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Name) //去掉特殊字符
	
	//代码唯一性
	Set tID =$o(^DHCHAI.DP.OEAntiMastI("IndexCode",Code,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	//中文名唯一性
	Set tID =$o(^DHCHAI.DP.OEAntiMastI("IndexName",Name,0)) 
	Quit:(tID'="")&(ID'=tID) -100
	
	Set objCat = ##class(DHCHAI.DP.OEAntiCat).GetObjById(CatDr)
	if ID="" {
		Set obj=##class(DHCHAI.DP.OEAntiMast).%New()
	}else{
		Set obj=##class(DHCHAI.DP.OEAntiMast).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode		= Code
	Set obj.BTName		= Name
	Set obj.BTName1		= Name1
	Set obj.BTCatDr		= objCat
	Set obj.BTIsActive	= IsActive
	Set obj.BTIsKeyDrugs=IsKeyDrugs
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
/// Description:  删除抗菌药物字典
/// Table：       DHCHAI.DP.OEAntiMast
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.DP.OEAntiMast")
	Quit:Flg'=1 -777


	Set sc = ##class(DHCHAI.DP.OEAntiMast).%DeleteId(+Id)
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
<Value>BTName</Value>
</Value>
<Value name="4">
<Value>BTName1</Value>
</Value>
<Value name="5">
<Value>BTCatDr</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTIsKeyDrugs</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.OEAntiMastD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.OEAntiMastD</IdLocation>
<IndexLocation>^DHCHAI.DP.OEAntiMastI</IndexLocation>
<StreamLocation>^DHCHAI.DP.OEAntiMastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
