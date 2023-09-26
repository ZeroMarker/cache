/// 名称: DHCMA.CPW.KB.PathClinItem
/// 描述: 国家路径诊疗项目信息
/// 编写者：yankai
/// 编写日期: 2022-05-12
Class DHCMA.CPW.KB.PathClinItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.KB.PathStage [ Cardinality = parent, Inverse = ChildClinItem ];

/// 项目描述
Property PCDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 项目子类:"主要诊疗工作"(固定取值)
Property PCCategory As %String;

/// 项目顺序号
Property PCIndNo As %Integer;

/// 是否可选项
Property PCIsOption As %Boolean;

/// 是否有效
Property PCIsActive As %Boolean;

/// 记录对应诊疗项目库记录ID（DHCMA.CPW.KB.ClinItemBase）
Property PCItemBase As %String;

/// 对项目类别和顺序号设置索引
Index IdxofIndNo On (Parref, PCIndNo);

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  根据ID取路径项目
/// Table：       DHCMA.CPW.KB.PathClinItem
/// Input：       aId :  DHCMA.CPW.KB.PathClinItem.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.KB.PathClinItem).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.KB.PathClinItem
{
	New (aId)
	Quit:'##class(DHCMA.CPW.KB.PathClinItem).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.KB.PathClinItem).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2022-05-12
/// Description:  更新路径项目信息
/// Table：       DHCMA.CPW.KB.PathClinItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathClinItem).Update("46||2^^儿科护理常规^B^1^0^1^135")   
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
		Set obj=##class(DHCMA.CPW.KB.PathClinItem).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.CPW.KB.PathClinItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref    		= objParref      //写入数据
	Set obj.PCDesc    		= Desc
	Set obj.PCCategory		= Category
	Set obj.PCIndNo			= IndNo
	Set obj.PCIsOption		= IsOption
	Set obj.PCIsActive		= IsActive
	Set obj.PCItemBase		= ItemBase			//直接按传值赋值（会覆盖原值），需保留原值时另写保存方法
	
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
/// Table：       DHCMA.CPW.KB.PathClinItem
/// Input：       aId : DHCMA.CPW.KB.PathClinItem.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.KB.PathClinItem).DeleteById(1)
ClassMethod DeleteById(aId As %String, aHospID As %String = "") As %String
{
	New (aId,aHospID)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.KB.PathMast")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.KB.PathClinItem).%DeleteId(aId)
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
<Data name="PathClinItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCDesc</Value>
</Value>
<Value name="3">
<Value>PCCategory</Value>
</Value>
<Value name="4">
<Value>PCIndNo</Value>
</Value>
<Value name="5">
<Value>PCIsOption</Value>
</Value>
<Value name="6">
<Value>PCIsActive</Value>
</Value>
<Value name="7">
<Value>PCItemBase</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("CLINITM")</DataLocation>
<DefaultData>PathClinItemDefaultData</DefaultData>
<IdLocation>{%%PARENT}("CLINITM")</IdLocation>
<IndexLocation>^CT.MA.CPW.KB.PathBaseI("CLINITM")</IndexLocation>
<StreamLocation>^CT.MA.CPW.KB.PathClinItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
