/// 名称: DHCHAI.IR.PDCARepLoc
/// 描述: PDCA报告-整改科室
/// 编写者：ShenC
/// 编写日期: 2022-09-14
Class DHCHAI.IR.PDCARepLoc Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.PDCARep [ Cardinality = parent, Inverse = ChildLoc ];

/// P-整改科室/病区
Property PAPlanLocDr As DHCHAI.BT.Location;

/// P-整改科室/病区负责人
Property PAPlanLocUser As DHCHAI.BT.SysUser;

/// P-院感科负责人
Property PAPlanAdminUser As DHCHAI.BT.SysUser;

/// P-描述
Property PAPlanData As %String(MAXLEN = 500, TRUNCATE = 1);

/// D-整改实际开始日期
Property PADoASttDate As %Date;

/// D-整改预计结束日期
Property PADoPEndDate As %Date;

/// D-提交人
Property PADoUser As DHCHAI.BT.SysUser;

/// D-描述
Property PADoData As %String(MAXLEN = 500, TRUNCATE = 1);

/// D-整改实际结束日期
Property PADoAEndDate As %Date;

/// D-科室自评
Property PADoLocAssess As %String(MAXLEN = 500, TRUNCATE = 1);

/// C-检查日期
Property PACheckDate As %Date;

/// C-检查人
Property PACheckUser As %String;

/// A-效果评价
Property PAAssess As DHCHAI.BT.Dictionary;

/// A-持续改进
Property PAAssessIMP As %String(MAXLEN = 500, TRUNCATE = 1);

/// 报告状态
Property PAStatusDr As DHCHAI.BT.Dictionary;

/// 是否有效
Property PAIsActive As %Boolean;

/// 索引 整改科室/病区
Index IndexPlanLoc On (Parref, PAIsActive);

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  根据ID取'PDCA报告-整改科室'对象
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aID : DHCHAI.IR.PDCARepLoc.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCARepLoc).GetObjById(1)
ClassMethod GetObjById(aID As %String) As DHCHAI.IR.PDCARepLoc
{
	New (aID)
	Quit:'##class(DHCHAI.IR.PDCARepLoc).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCARepLoc).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  更新'PDCA报告-整改科室'
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLoc).Update("1^^3^3^2^<p>34</p>^^^^^^^^^^^0^1^1^2")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref       	= $p(aInputStr,aSeparete,1)		
	Set ChildSub     	= $p(aInputStr,aSeparete,2)
	Set PlanLocDr    	= $p(aInputStr,aSeparete,3)
	Set PlanLocDr = ##class(DHCHAI.BT.Location).GetObjById(PlanLocDr)
	Set PlanLocUser  	= $p(aInputStr,aSeparete,4)
	Set PlanLocUser = ##class(DHCHAI.BT.SysUser).GetObjById(PlanLocUser)
	Set PlanAdminUser	= $p(aInputStr,aSeparete,5)
	Set PlanAdminUser = ##class(DHCHAI.BT.SysUser).GetObjById(PlanAdminUser)
	Set PlanData   		= $p(aInputStr,aSeparete,6)
	Set DoASttDate 		= $p(aInputStr,aSeparete,7)
	Set:DoASttDate'="" DoASttDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoASttDate)
	Set DoPEndDate 		= $p(aInputStr,aSeparete,8)
	Set:DoPEndDate'="" DoPEndDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoPEndDate)
	Set DoUser 			= $p(aInputStr,aSeparete,9)
	Set DoUser = ##class(DHCHAI.BT.SysUser).GetObjById(DoUser)
	Set DoData 			= $p(aInputStr,aSeparete,10)
	Set DoAEndDate		= $p(aInputStr,aSeparete,11)
	Set:DoAEndDate'="" DoAEndDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoAEndDate)
	Set DoLocAssess		= $p(aInputStr,aSeparete,12)
	Set CheckDate		= $p(aInputStr,aSeparete,13)
	Set:CheckDate'="" CheckDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
	Set CheckUse		= $p(aInputStr,aSeparete,14)
	Set CheckUse = ##class(DHCHAI.BT.SysUser).GetObjById(CheckUse)
	Set AssessID			= $p(aInputStr,aSeparete,15)
	Set objAssess = ##class(DHCHAI.BT.Dictionary).GetObjById(AssessID)
	Set AssessIMP		= $p(aInputStr,aSeparete,16)
	Set IsActive			= $p(aInputStr,aSeparete,17)
	Set:IsActive="" IsActive=0			//不允许为空
	Set Index			= $p(aInputStr,aSeparete,18)
	//报告状态
	Set StatusCode		= $p(aInputStr,aSeparete,19)
	Set StatusID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("PDCAStatus",StatusCode,"1")
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjById(StatusID)
	Quit:'$ISObject(objStatus) return
	
	Quit:Parref="" return
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         	= objParref
	Set obj.PAPlanLocDr    	= PlanLocDr    
	Set obj.PAPlanLocUser  	= PlanLocUser     
	Set obj.PAPlanAdminUser	= PlanAdminUser  
	Set obj.PAPlanData   	= PlanData  
	Set obj.PADoASttDate 	= DoASttDate
	Set obj.PADoPEndDate 	= DoPEndDate
	Set obj.PADoUser 		= DoUser
	Set obj.PADoData 		= DoData
	Set obj.PADoAEndDate	= DoAEndDate
	Set obj.PADoLocAssess	= DoLocAssess
	Set obj.PACheckDate		= CheckDate
	Set obj.PACheckUser		= CheckUse
	Set obj.PAAssess		= Assess
	Set obj.PAAssessIMP		= AssessIMP
	Set obj.PAIsActive		= IsActive
	Set obj.PAIndex			= Index 
	Set obj.PAStatusDr		= objStatus
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  更新'PDCA报告-整改科室'[P-计划]
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLoc).UpdateP("")
ClassMethod UpdateP(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
    Set Parref       	= $p(aInputStr,aSeparete,1)
	Set ChildSub     	= $p(aInputStr,aSeparete,2)
	Set PlanLocID    	= $p(aInputStr,aSeparete,3)
	Set PlanLocDr 		= ##class(DHCHAI.BT.Location).GetObjById(PlanLocID)
	Set PlanLocUserID  	= $p(aInputStr,aSeparete,4)
	Set PlanLocUser 	= ##class(DHCHAI.BT.SysUser).GetObjById(PlanLocUserID)
	Set PlanAdminUserID	= $p(aInputStr,aSeparete,5)
	Set PlanAdminUser	= ##class(DHCHAI.BT.SysUser).GetObjById(PlanAdminUserID)
	Set PlanData   		= $p(aInputStr,aSeparete,6)
	Set StatusCode		= $p(aInputStr,aSeparete,7)
	
	Set StatusID		=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("PDCAStatus",StatusCode,"1")
	Set objStatus		=##class(DHCHAI.BT.Dictionary).GetObjById(StatusID)
	Quit:'$ISObject(objStatus) return
	Set IsActive		= $p(aInputStr,aSeparete,8)
	Quit:IsActive="" return
	
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         	= objParref
	Set obj.PAPlanLocDr    	= PlanLocDr    
	Set obj.PAPlanLocUser  	= PlanLocUser     
	Set obj.PAPlanAdminUser	= PlanAdminUser  
	Set obj.PAPlanData   	= PlanData 
	Set obj.PAStatusDr		= objStatus
	Set obj.PAIsActive		= IsActive
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  更新'PDCA报告-整改科室'[Do 执行]
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLoc).UpdateDo("")
ClassMethod UpdateDo(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref       	= $p(aInputStr,aSeparete,1)
	Set ChildSub     	= $p(aInputStr,aSeparete,2)
	Set DoASttDate 		= $p(aInputStr,aSeparete,3)
	Set:DoASttDate'="" DoASttDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoASttDate)
	Set DoPEndDate 		= $p(aInputStr,aSeparete,4)
	Set:DoPEndDate'="" DoPEndDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoPEndDate)
	Set DoUser 			= $p(aInputStr,aSeparete,5)
	Set DoUser = ##class(DHCHAI.BT.SysUser).GetObjById(DoUser)
	Set DoData 			= $p(aInputStr,aSeparete,6)
	Set DoAEndDate		= $p(aInputStr,aSeparete,7)
	Set:DoAEndDate'="" DoAEndDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DoAEndDate)
	Set DoLocAssess		= $p(aInputStr,aSeparete,8)
	//报告状态
	Set StatusCode		= $p(aInputStr,aSeparete,9)
	Set StatusID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("PDCAStatus",StatusCode,"1")
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjById(StatusID)
	Quit:'$ISObject(objStatus) return
	
	Quit:Parref="" return
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         	= objParref
	Set obj.PADoASttDate 	= DoASttDate
	Set obj.PADoPEndDate 	= DoPEndDate
	Set obj.PADoUser 		= DoUser
	Set obj.PADoData 		= DoData
	Set obj.PADoAEndDate	= DoAEndDate
	Set obj.PADoLocAssess	= DoLocAssess
	Set obj.PAStatusDr		= objStatus
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  更新'PDCA报告-整改科室'[CA-检查评价]
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLoc).UpdateCA("1^2^^223^1084^332^10^1")
ClassMethod UpdateCA(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref       	= $p(aInputStr,aSeparete,1)
	Set ChildSub     	= $p(aInputStr,aSeparete,2)
	Set CheckDate		= $p(aInputStr,aSeparete,3)
	Set:CheckDate'="" CheckDate=##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CheckDate)
	Set:CheckDate="" CheckDate=+$h
	Set CheckUser		= $p(aInputStr,aSeparete,4)
	//Set CheckUser = ##class(DHCHAI.BT.SysUser).GetObjById(CheckUser)
	Set AssessID			= $p(aInputStr,aSeparete,5)
	Set objAssess = ##class(DHCHAI.BT.Dictionary).GetObjById(AssessID)
	Set AssessIMP		= $p(aInputStr,aSeparete,6)
	
	//报告状态
	Set StatusCode		= $p(aInputStr,aSeparete,7)
	Set StatusID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("PDCAStatus",StatusCode,"1")
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjById(StatusID)
	Quit:'$ISObject(objStatus) return
	
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepLoc).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         	= objParref
	Set obj.PACheckDate		= CheckDate
	Set obj.PACheckUser		= CheckUser
	Set obj.PAAssess		= objAssess
	Set obj.PAAssessIMP		= AssessIMP
	Set obj.PAStatusDr		= objStatus
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

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  删除'PDCA报告-整改科室'
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aID : DHCHAI.IR.PDCARepLoc.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLoc).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCARepLoc).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  设置IsActive
/// Table：       DHCHAI.IR.PDCARepLoc
/// Input：       aID : DHCHAI.IR.PDCARepLoc.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCARepLoc).SetIsActive("17||1",1)
ClassMethod SetIsActive(aID As %String, aIsActive As %String) As %String
{
	New (aID,aIsActive)
	Quit:'##class(DHCHAI.IR.PDCARepLoc).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCARepLoc).%OpenId(aID)
	
	Set objParref		=obj.Parref         	
	Set PlanLocDr 		=obj.PAPlanLocDr    	  
	Set PlanLocUser  	=obj.PAPlanLocUser  	   
	Set PlanAdminUser  	=obj.PAPlanAdminUser	
	Set PlanData 		=obj.PAPlanData   	
	Set IsActive		=obj.PAIsActive		
	Set Index 			=obj.PAIndex			 
	//原始记录置为无效
	Set obj.PAIsActive	= aIsActive
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do:obj'="" obj.%Close()
	//新增记录
	Set objNew=##class(DHCHAI.IR.PDCARepLoc).%New()
	Quit:'$IsObject(objNew) return
	
	Set objNew.Parref         	= objParref
	Set objNew.PAPlanLocDr    	= PlanLocDr    
	Set objNew.PAPlanLocUser  	= PlanLocUser     
	Set objNew.PAPlanAdminUser	= PlanAdminUser  
	Set objNew.PAPlanData   	= PlanData 
	Set objNew.PAIsActive		= "1"
	//默认回退到'提交并审核状态'
	Set StatusID=##Class(DHCHAI.BTS.DictionarySrv).GetIDByCode("PDCAStatus",2,"1")
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjById(StatusID)
	Quit:'$ISObject(objStatus) return
	Set objNew.PAStatusDr		= objStatus
	Set sc=objNew.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=objNew.%Id()
	}
	Do obj.%Close()
	
	Quit aID
}

Storage Default
{
<Data name="PDCARepLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAPlanLocDr</Value>
</Value>
<Value name="3">
<Value>PAPlanLocUser</Value>
</Value>
<Value name="4">
<Value>PAPlanAdminUser</Value>
</Value>
<Value name="5">
<Value>PAPlanData</Value>
</Value>
<Value name="6">
<Value>PADoASttDate</Value>
</Value>
<Value name="7">
<Value>PADoPEndDate</Value>
</Value>
<Value name="8">
<Value>PADoUser</Value>
</Value>
<Value name="9">
<Value>PADoData</Value>
</Value>
<Value name="10">
<Value>PADoAEndDate</Value>
</Value>
<Value name="11">
<Value>PADoLocAssess</Value>
</Value>
<Value name="12">
<Value>PACheckDate</Value>
</Value>
<Value name="13">
<Value>PACheckUser</Value>
</Value>
<Value name="14">
<Value>PAAssess</Value>
</Value>
<Value name="15">
<Value>PAAssessIMP</Value>
</Value>
<Value name="16">
<Value>PAStatusDr</Value>
</Value>
<Value name="17">
<Value>PAIsActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Loc")</DataLocation>
<DefaultData>PDCARepLocDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Loc")</IdLocation>
<IndexLocation>^MA.HAI.IR.PDCARepI("Loc")</IndexLocation>
<StreamLocation>^MA.HAI.IR.PDCARepLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
