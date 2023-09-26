/// 名称: DHCMA.CPW.CP.PathwayVar
/// 描述: 临床路径 病情变异记录 申请审批也在这个表中
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayVar Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildVar ];

/// 变异原因
Property CPVariatDr As DHCMA.CPW.BT.PathVariat;

/// 变异原因 自定义
Property CPVariatTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 路径阶段指针
Property CPEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 表单项目指针
Property CPImplDr As DHCMA.CPW.CP.PathwayImpl;

/// 执行医嘱指针（指向医嘱表）
/// 医嘱审核前，添加变异原因的时候存储的是医嘱项ID[ARC_ItmMast.RowID],审核后，医嘱ID回插
/// 医嘱项ID相同时，拼接(^)
Property CPOrdDID As %String(MAXLEN = 500, TRUNCATE = 1);

/// 有效标志（当CPOrdDID存储医嘱项ID[ARC_ItmMast.RowID]时，有效性为0）
Property CPIsActive As %Boolean;

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 针对路径外医嘱（CPImplDr为空）
Index IdxofPwEp On (Parref, CPEpisDr As Exact);

Index IdxofPwEpImpl On (Parref, CPEpisDr As Exact, CPImplDr As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       aId : DHCMA.CPW.CP.PathwayVar.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayVar).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayVar
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayVar).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayVar).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayVar).Update("8^^1^test^8||1^8||2^^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set VariatID=$p(aInputStr,aSeparete,3)
	Set VariatTxt=$p(aInputStr,aSeparete,4)
	Set EpisID=$p(aInputStr,aSeparete,5)
	Set ImplID=$p(aInputStr,aSeparete,6)
	Set OrdDID=$p(aInputStr,aSeparete,7)
	Set ActUserID=$p(aInputStr,aSeparete,8)
	Set IsActive=1
	Set:ImplID="" IsActive=0				//路径外医嘱临时数据，医嘱ID回写后值更新为1
	Set aActive=$p(aInputStr,aSeparete,9) 	//如果Active参数不为空，则以传参为准
	Set:aActive'="" IsActive=aActive
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objVariat=##class(DHCMA.CPW.BT.PathVariat).GetObjById(VariatID)
	Quit:(VariatID'="")&&('$IsObject(objVariat)) return
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(EpisID)
	Quit:'$IsObject(objEpis) return
	Set objImpl=##class(DHCMA.CPW.CP.PathwayImpl).GetObjById(ImplID)
	//Quit:'$IsObject(objImpl) return	//给路径外医嘱添加变异原因时，项目为空
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayVar).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayVar).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPVariatDr=objVariat
	Set obj.CPVariatTxt=VariatTxt
	Set obj.CPEpisDr=objEpis
	Set obj.CPImplDr=objImpl
	Set obj.CPOrdDID=OrdDID
	
	Set obj.CPIsActive=IsActive
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Set flg=##class(DHCMA.CPW.CPS.InterfaceSrv).IsAddVar()
	If (flg) {
		//临时数据
		//为避免重复添加变异原因而产生重复数据
		//在添加变异原因时，如果用户没有全部添加,则在关闭页面时删除已添加的数据,并清除此global
		//已全部添加，则在关闭页面时清除此global
		Set ^tmp.DCHMA.CPW.VarOrd=$g(^tmp.DCHMA.CPW.VarOrd)_$lb(return)
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-10-17
/// Description:  路径外医嘱ID回写
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayVar).UpdateVarOrder(1||1)
ClassMethod UpdateVarOrder(aID As %String, aOrdDID As %String) As %String
{
	New (aID,aOrdDID)
	Set return=""
	Quit:(aID="")||(aOrdDID="") return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPOrdDID=$S(obj.CPIsActive:obj.CPOrdDID_"^"_aOrdDID,1:aOrdDID)
	Set obj.CPIsActive=1
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	
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
/// CreatDate：   2018-10-17
/// Description:  添加路径外医嘱（无变异原因）
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayVar).AddVarOrder(1||1)
ClassMethod AddVarOrder(aParrefID As %String, aEpisID As %String, aOrdDID As %String, aUserID As %String) As %String
{
	New (aParrefID,aEpisID,aOrdDID,aUserID)
	Set return=""
	Quit:(aParrefID="")||(aEpisID="")||(aOrdDID="") return
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(aParrefID)
	Quit:'$IsObject(objParref) return
	Set objEpis=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
	Quit:'$IsObject(objEpis) return
	Set obj=##class(DHCMA.CPW.CP.PathwayVar).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPEpisDr=objEpis
	Set obj.CPOrdDID=aOrdDID
	Set obj.CPIsActive=1
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
/// CreatDate：   2018-09-13
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayVar).Invalid("8||2","9!!2")
ClassMethod Invalid(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayVar).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPVariatDr=""
	Set obj.CPVariatTxt=""
	/*If ((obj.CPIsActive=1)&&(obj.CPOrdDID'="")) {
		//医嘱回写后的应把CPOrdDID还原成医嘱项ID
		Set OEItemID=$p(obj.CPOrdDID,"||",2)
		Set OEItmMastID = $p($g(^OEORD(+obj.CPOrdDID,"I",OEItemID,1)),"^",2) // 医嘱项指针 ARC_ItmMast
		Set obj.CPOrdDID=OEItmMastID
	}*/
	Set obj.CPIsActive=1
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
/// Table：       DHCMA.CPW.CP.PathwayVar
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayVar).Delete(1||1)
ClassMethod Delete(aID As %String) As %String
{
	New (aID)
	
	Set sc = ##class(DHCMA.CPW.CP.PathwayVar).%DeleteId(aID)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
	
	Quit return
}

Storage Default
{
<Data name="PathwayVarDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPVariatDr</Value>
</Value>
<Value name="3">
<Value>CPVariatTxt</Value>
</Value>
<Value name="4">
<Value>CPEpisDr</Value>
</Value>
<Value name="5">
<Value>CPFormItemDr</Value>
</Value>
<Value name="6">
<Value>CPOrdDID</Value>
</Value>
<Value name="7">
<Value>CPIsActive</Value>
</Value>
<Value name="8">
<Value>CPActDate</Value>
</Value>
<Value name="9">
<Value>CPActTime</Value>
</Value>
<Value name="10">
<Value>CPActUserID</Value>
</Value>
<Value name="11">
<Value>CPImplDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VAR")</DataLocation>
<DefaultData>PathwayVarDefaultData</DefaultData>
<IdLocation>{%%PARENT}("VAR")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("VAR")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayVarS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
