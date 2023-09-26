/// 名称: DHCMA.CPW.CP.PathwayImpl
/// 描述: 临床路径 项目执行记录
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayImpl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildImpl ];

/// 关联医嘱
Relationship ChildOrd As DHCMA.CPW.CP.PathwayOrd [ Cardinality = children, Inverse = Parref ];

/// 路径阶段指针/合并症记录当前执行阶段
Property CPEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 路径项目指针/合并症路径项目指针
Property CPFormItemDr As DHCMA.CPW.BT.PathFormItem;

/// 指向合并症关联记录指针PathCompl
Property CPPathwayComplDr As DHCMA.CPW.CP.PathwayCompl;

/// 执行医嘱指针（指向医嘱表）
/// 相同医嘱，拼起来(^)
/// 废除2018-12-13
Property CPOrdDID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 执行标志
Property CPIsImp As %Boolean;

/// 系统标志（系统自动关联记录1、手工操作关联记录0、标记执行234）
Property CPIsSystem As %String;

/// 有效标志
Property CPIsActive As %Boolean;

/// 备注
Property CPNode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 相关就诊
Property CPEpisodeID As %String;

Index IdxofParRef On (Parref, CPEpisDr As Exact);

Index IdxofParFormItem On (Parref, CPFormItemDr) [ Unique ];

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       aId : DHCMA.CPW.CP.PathwayImpl.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayImpl
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayImpl).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayImpl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  更新数据(同步)
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayImpl).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set $ZE="UpdateImplError"
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set EpisID=$p(aInputStr,aSeparete,3)
	Set FormItemID=$p(aInputStr,aSeparete,4)
	Set OrdDID=$p(aInputStr,aSeparete,5)
	Set IsSystem=$p(aInputStr,aSeparete,6)
	Set ActUserID=$p(aInputStr,aSeparete,7)
	Set EpisodeID=$p(aInputStr,aSeparete,8)
	Set PwayComplID=$p(aInputStr,aSeparete,9)
	Set IsImp=$p(aInputStr,aSeparete,10)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(EpisID)
	Quit:'$IsObject(objEpis) return
	Set objFormItem=##class(DHCMA.CPW.BT.PathFormItem).GetObjById(FormItemID)
	Quit:'$IsObject(objFormItem) return
	Set objPwayCompl=##class(DHCMA.CPW.CP.PathwayCompl).GetObjById(PwayComplID)
	Quit:(objPwayCompl'="")&&('$IsObject(objPwayCompl)) return
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayImpl).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayImpl).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPEpisDr=objEpis
	Set obj.CPFormItemDr=objFormItem
	Set obj.CPOrdDID=OrdDID
	Set obj.CPIsSystem=+IsSystem
	
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPEpisodeID=EpisodeID
	Set obj.CPPathwayComplDr=objPwayCompl
	Set obj.CPIsImp=IsImp
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdateImplError
	Quit -999
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-15
/// Description:  项目执行、撤销操作
/// 			  在医嘱审核后，由医生站调用接口回插数据
/// 			  一个项目关联多个不同医嘱时，插入相应的多条记录
/// 			  一个项目有多个相同医嘱时（如葡萄糖），只插入一条记录且OrderDID拼起来(^)
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayImpl).ExecuteItem("8","6","","9!!2","1","0")
ClassMethod ExecuteItem(aPathwayID As %String, aItemID As %String, aOrdID As %String, aUserID As %String, aIsImpl As %String, aIsSystem As %String) As %String
{
	New (aPathwayID,aItemID,aOrdID,aUserID,aIsImpl,aIsSystem)
	Set return=""
	Quit:(aPathwayID="")||(aItemID="") return
	
	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aPathwayID_"||"_aItemID)
	Quit:'$IsObject(objImpl) return
	
	Set objImpl.CPIsSystem=aIsSystem
	Set objImpl.CPOrdDID=""
	Set objImpl.CPIsImp=aIsImpl
	
	Set objImpl.CPActDate=+$H
	Set objImpl.CPActTime=$p($H,",",2)
	Set objImpl.CPActUserID=aUserID
	Set objImpl.CPIsActive=1
	Set sc=objImpl.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=objImpl.%Id()
	}
	Do objImpl.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayImpl).Invalid(1||1)
ClassMethod Invalid(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPIsActive=0
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  删除数据
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayImpl).Delete(1||1)
ClassMethod Delete(aID As %String) As %String
{
	New (aID)
	
	Set sc = ##class(DHCMA.CPW.CP.PathwayImpl).%DeleteId(aID)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
	
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2022-8-16
/// Description:  保存备注
/// Table：       DHCMA.CPW.CP.PathwayImpl
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayImpl).UpdateNode(1||1)
ClassMethod UpdateNode(aID As %String, aText As %String, aUserID As %String) As %String
{
	New (aID,aText,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPNode=aText
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	
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

Storage Default
{
<Data name="PathwayImplDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPEpisDr</Value>
</Value>
<Value name="3">
<Value>CPFormItemDr</Value>
</Value>
<Value name="4">
<Value>CPOrdDID</Value>
</Value>
<Value name="5">
<Value>CPIsSystem</Value>
</Value>
<Value name="6">
<Value>CPIsActive</Value>
</Value>
<Value name="7">
<Value>CPActDate</Value>
</Value>
<Value name="8">
<Value>CPActTime</Value>
</Value>
<Value name="9">
<Value>CPActUserID</Value>
</Value>
<Value name="10">
<Value>CPIsImp</Value>
</Value>
<Value name="11">
<Value>CPEpisodeID</Value>
</Value>
<Value name="12">
<Value>CPPathwayComplDr</Value>
</Value>
<Value name="13">
<Value>CPNode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IMPL")</DataLocation>
<DefaultData>PathwayImplDefaultData</DefaultData>
<IdLocation>{%%PARENT}("IMPL")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("IMPL")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayImplS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
