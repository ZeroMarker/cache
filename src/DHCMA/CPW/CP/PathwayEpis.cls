/// 名称: DHCMA.CPW.CP.PathwayEpis
/// 描述: 临床路径 路径阶段
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.PathwayEpis Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.CP.Pathway [ Cardinality = parent, Inverse = ChildEpis ];

/// 路径阶段指针
Property CPFormEpDr As DHCMA.CPW.BT.PathFormEp;

/// 顺序号
Property CPIndNo As %Integer;

/// 阶段参考天数（例：2天或3-5天，允许一天多个阶段）
Property CPEpDays As %String(MAXLEN = 50, TRUNCATE = 1);

/// 确认标志
Property CPIsConfirm As %Boolean;

/// 开始日期（新阶段开始日期可以修改，但是不能早于上一阶段开始日期）
Property CPSttDate As %Date;

/// 开始时间
Property CPSttTime As %Time;

/// 结束日期（确认当前阶段结束日期，新阶段开始日期默认+1）
Property CPEndDate As %Date;

/// 结束时间
Property CPEndTime As %Time;

/// 有效标志
Property CPIsActive As %Boolean;

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.CPW.EP.SSUser.OID）
Property CPActUserID As %String;

/// 签名医生ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPSignDocID As %String;

/// 签名日期
Property CPSignDocDate As %Date;

/// 签名时间
Property CPSignDocTime As %Time;

/// 签名护士ID
Property CPSignNurID As %String;

/// 签名日期
Property CPSignNurDate As %Date;

/// 签名时间
Property CPSignNurTime As %Time;

Index IdxofParRef On (Parref, CPFormEpDr As Exact);

Index IdxofParIndNo On (Parref, CPIndNo);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aId : DHCMA.CPW.CP.PathwayEpis.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayEpis
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayEpis).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayEpis).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-13
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set FormEpID=$p(aInputStr,aSeparete,3)
	Set IndNo=$p(aInputStr,aSeparete,4)
	Set EpDays=$p(aInputStr,aSeparete,5)
	Set ActUserID=$p(aInputStr,aSeparete,6)
	Set IsActive=1
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.CP.Pathway).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objFormEp=##class(DHCMA.CPW.BT.PathFormEp).GetObjById(FormEpID)
	Quit:'$IsObject(objFormEp) return
	
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayEpis).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayEpis).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.CPFormEpDr=objFormEp
	Set obj.CPIndNo=IndNo
	Set obj.CPEpDays=EpDays
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
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-15
/// Description:  签名操作
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Sign(1||1)
ClassMethod Sign(aEpisID As %String, aUserID As %String, aUserType) As %String
{
	New (aEpisID,aUserID,aUserType)
	Set return=""
	Quit:(aEpisID="")||(aUserType="")||(aUserID="") return
	
	Set obj=..GetObjById(aEpisID)
	Quit:'$IsObject(obj) return
	
	If (aUserType="D") {
		Set obj.CPSignDocDate=+$H
		Set obj.CPSignDocTime=$p($H,",",2)
		Set obj.CPSignDocID=aUserID
	} Else {
		Set obj.CPSignNurDate=+$H
		Set obj.CPSignNurTime=$p($H,",",2)
		Set obj.CPSignNurID=aUserID
	}
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
/// Description:  撤销签名操作
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).UnSign(1||1)
ClassMethod UnSign(aEpisID As %String, aUserType As %String) As %String
{
	New (aEpisID,aSttDate,aUserType)
	Set return=""
	Quit:(aEpisID="")||(aUserType="") return
	
	Set obj=..GetObjById(aEpisID)
	Quit:'$IsObject(obj) return
	
	If (aUserType="D") {
		Set obj.CPSignDocDate=""
		Set obj.CPSignDocTime=""
		Set obj.CPSignDocID=""
	} Else {
		Set obj.CPSignNurDate=""
		Set obj.CPSignNurTime=""
		Set obj.CPSignNurID=""
	}
	
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
/// Description:  确定操作
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Confirm(1||1)
ClassMethod Confirm(aEpisID As %String, aSttDate As %String, aEndDate As %String, aUserID As %String) As %String
{
	New (aEpisID,aSttDate,aEndDate,aUserID)
	Set return=""
	Quit:(aEpisID="")||(aSttDate="")||(aEndDate="")||(aUserID="") return
	
	Set obj=..GetObjById(aEpisID)
	Quit:'$IsObject(obj) return
	Set obj.CPIsConfirm=1
	Set obj.CPSttDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical($p(aSttDate," ",1))
	Set obj.CPSttTime=##class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical($p(aSttDate," ",2))
	Set obj.CPEndDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical($p(aEndDate," ",1))
	Set obj.CPEndTime=##class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical($p(aEndDate," ",2))
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

/// Creator：     dengshaopeng
/// CreatDate：   2020-07-15
/// Description:  阶段撤销操作
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Revoke(1||1)
ClassMethod Revoke(aEpisID As %String, aUserID As %String) As %String
{
	New (aEpisID,aUserID)
	Set return=""
	Quit:(aEpisID="")||(aUserID="") return
	
	Set obj=..GetObjById(aEpisID)
	Quit:'$IsObject(obj) return
	Set obj.CPIsConfirm=0
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	Set DocSign = ..UnSign(aEpisID,"D")
	//Set NurSign = ..UnSign(aEpisID,"")
	
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
/// Description:  作废数据
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Invalid(1||1)
ClassMethod Invalid(aEpisID As %String, aUserID As %String = "") As %String
{
	New (aEpisID,aUserID)
	Set return=""
	Quit:aEpisID="" return
	
	Set obj=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(aEpisID)
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
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpis).Delete(1||1)
ClassMethod Delete(aID As %String) As %String
{
	New (aID)
	
	Set sc = ##class(DHCMA.CPW.CP.PathwayEpis).%DeleteId(aID)
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
<Data name="PathwayEpisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPFormEpDr</Value>
</Value>
<Value name="3">
<Value>CPIndNo</Value>
</Value>
<Value name="4">
<Value>CPEpDays</Value>
</Value>
<Value name="5">
<Value>CPIsConfirm</Value>
</Value>
<Value name="6">
<Value>CPSttDate</Value>
</Value>
<Value name="7">
<Value>CPEndDate</Value>
</Value>
<Value name="8">
<Value>CPIsActive</Value>
</Value>
<Value name="9">
<Value>CPActDate</Value>
</Value>
<Value name="10">
<Value>CPActTime</Value>
</Value>
<Value name="11">
<Value>CPActUserID</Value>
</Value>
<Value name="12">
<Value>CPSignDocID</Value>
</Value>
<Value name="13">
<Value>CPSignType</Value>
</Value>
<Value name="14">
<Value>CPIsSign</Value>
</Value>
<Value name="15">
<Value>CPSignDate</Value>
</Value>
<Value name="16">
<Value>CPSignTime</Value>
</Value>
<Value name="17">
<Value>CPSignUserID</Value>
</Value>
<Value name="18">
<Value>CPSignDocDate</Value>
</Value>
<Value name="19">
<Value>CPSignDocTime</Value>
</Value>
<Value name="20">
<Value>CPSignNurID</Value>
</Value>
<Value name="21">
<Value>CPSignNurDate</Value>
</Value>
<Value name="22">
<Value>CPSignNurTime</Value>
</Value>
<Value name="23">
<Value>CPSttTime</Value>
</Value>
<Value name="24">
<Value>CPEndTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EPIS")</DataLocation>
<DefaultData>PathwayEpisDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EPIS")</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI("EPIS")</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayEpisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
