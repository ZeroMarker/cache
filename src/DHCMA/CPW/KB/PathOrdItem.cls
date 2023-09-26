/// 名称: DHCMA.CPW.KB.PathOrdItem
/// 描述: 国家路径医嘱项目信息
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.PathOrdItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.KB.PathStage [ Cardinality = parent, Inverse = ChildOrdItem ];

/// 项目描述
Property PODesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 医嘱项目子分类为:"长期医嘱"或"临时医嘱"或"其他医嘱"或其他分类
Property POCategory As %String;

/// 项目顺序号
Property POIndNo As %Integer;

/// 是否可选项
Property POIsOption As %Boolean;

/// 是否有效
Property POIsActive As %Boolean;

/// 记录对应医嘱项目库记录ID（医嘱项目：DHCMA.CPW.KB.OrdItemBase）
Property POItemBase As %String;

/// 对项目类别和顺序号设置索引
Index IdxofIndNo On (Parref, POIndNo);

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  根据ID取路径项目
/// Table：       DHCMA.CPW.KB.PathOrdItem
/// Input：       aId :  DHCMA.CPW.KB.PathOrdItem.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.PathOrdItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.PathOrdItem
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.PathOrdItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.PathOrdItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  更新路径项目信息
/// Table：       DHCMA.CPW.KB.PathOrdItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathOrdItem).Update("46||2^^儿科护理常规^B^1^0^1^135")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^", aHospID As %String = "") As %String
{
	New (aInputStr,aSeparete,aHospID)
	Set return=-1
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref			= $p(aInputStr,aSeparete,1)
	Set objParref		= ##class(DHCMA.CPW.KB.PathStage).GetObjById(Parref)
	Quit:'$IsObject(objParref) -2
	Set ChildSub     	= $p(aInputStr,aSeparete,2)  
	Set Desc     		= $p(aInputStr,aSeparete,3)
	Set Category    	= $p(aInputStr,aSeparete,4)
	Set IndNo    		= $p(aInputStr,aSeparete,5)
	Set IsOption    	= $p(aInputStr,aSeparete,6)
	Set IsActive    	= +$p(aInputStr,aSeparete,7)
	Set ItemBase    	= $p(aInputStr,aSeparete,8)
	If ChildSub="" {
		Set obj=##class(DHCMA.CPW.KB.PathOrdItem).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.KB.PathOrdItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref    		= objParref      //写入数据
	Set obj.PODesc    		= Desc
	Set obj.POCategory		= Category
	Set obj.POIndNo			= IndNo
	Set obj.POIsOption		= IsOption
	Set obj.POIsActive		= IsActive
	Set obj.POItemBase		= ItemBase			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	
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
/// CreatDate：   2022-05-12
/// Description:  删除路径项目
/// Table：       DHCMA.CPW.KB.PathOrdItem
/// Input：       aId : DHCMA.CPW.KB.PathOrdItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathOrdItem).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.PathOrdItem).%DeleteId(aId)
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
<Data name="PathOrdItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PODesc</Value>
</Value>
<Value name="3">
<Value>POCategory</Value>
</Value>
<Value name="4">
<Value>POIndNo</Value>
</Value>
<Value name="5">
<Value>POIsOption</Value>
</Value>
<Value name="6">
<Value>POIsActive</Value>
</Value>
<Value name="7">
<Value>POItemBase</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ORDITM")</DataLocation>
<DefaultData>PathOrdItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ORDITM")</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.PathBaseI("ORDITM")</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.PathOrdItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
