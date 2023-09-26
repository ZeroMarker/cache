/// 名称: DHCMA.CPW.KB.OrdItemBase
/// 描述: 知识库-医嘱项目库（公有数据）
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.OrdItemBase Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 项目描述
Property OIDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目别名
Property OIAlias As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 分类（备用）
Property OICategory As %String;

/// 是否启用
Property OIIsActive As %String;

/// 操作日期
Property OIActDate As %Date;

/// 操作时间
Property OIActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property OIActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 对描述建立索引
Index IdxofDesc On (OIIsActive As Exact, OIDesc As AlphaUp);

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  根据ID取医嘱项目库记录
/// Table：       DHCMA.CPW.KB.OrdItemBase
/// Input：       aId :  DHCMA.CPW.KB.OrdItemBase.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.OrdItemBase).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.OrdItemBase
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.OrdItemBase).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.OrdItemBase).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  更新医嘱项目库记录
/// Table：       DHCMA.CPW.KB.OrdItemBase
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.OrdItemBase).Update()   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID				= $p(aInputStr,aSeparete,1) 
	Set Desc     		= $p(aInputStr,aSeparete,2)
	Set Alias    		= $p(aInputStr,aSeparete,3)
	Set Category    	= $p(aInputStr,aSeparete,4)
	Set IsActive    	= $p(aInputStr,aSeparete,5)
	Set ActDate    		= $p(aInputStr,aSeparete,6)
	Set:ActDate="" ActDate = +$h
	Set ActTime    		= $p(aInputStr,aSeparete,7)
	Set:ActTime="" ActTime = $p($h,",",2)
	Set ActUserID    	= $p(aInputStr,aSeparete,8)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.KB.OrdItemBase).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.KB.OrdItemBase).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return

	Set obj.OIDesc    		= Desc      //写入数据
	Set obj.OIAlias    		= Alias
	Set obj.OICategory		= Category
	Set obj.OIIsActive		= IsActive
	Set obj.OIActDate		= ActDate			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	Set obj.OIActTime		= ActTime
	Set obj.OIActUserID		= ActUserID
	
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

/// Creator：     yankai
/// CreatDate：   2022-05-13
/// Description:  删除医嘱项目库记录
/// Table：       DHCMA.CPW.KB.OrdItemBase
/// Input：       aId : DHCMA.CPW.KB.OrdItemBase.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.OrdItemBase).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.OrdItemBase).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="OrdItemBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OIDesc</Value>
</Value>
<Value name="3">
<Value>OIAlias</Value>
</Value>
<Value name="4">
<Value>OICategory</Value>
</Value>
<Value name="5">
<Value>OIIsActive</Value>
</Value>
<Value name="6">
<Value>OIActDate</Value>
</Value>
<Value name="7">
<Value>OIActTime</Value>
</Value>
<Value name="8">
<Value>OIActUserID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.CPW.KB.OrdItemBaseD</DataLocation>
<DefaultData>OrdItemBaseDefaultData</DefaultData>
<IdLocation>^CT.MA.CPW.KB.OrdItemBaseD</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.OrdItemBaseI</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.OrdItemBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
