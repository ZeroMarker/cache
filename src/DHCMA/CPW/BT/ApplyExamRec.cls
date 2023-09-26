/// 名称: DHCMA.CPW.BT.ApplyExamRec
/// 描述: 表单审核记录类
/// 编写者：yankai
/// 编写日期: 2021-11-26
Class DHCMA.CPW.BT.ApplyExamRec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 审核明细
Relationship ChildDtl As DHCMA.CPW.BT.ApplyExamRecDtl [ Cardinality = children, Inverse = Parref ];

/// 申请表单指针
Property BTPathFormDr As DHCMA.CPW.BT.PathForm [ Required ];

/// 审核类型（新路径发布申请New,版本迭代申请Modify）
Property BTExamType As %String(DISPLAYLIST = "New,Modify", VALUELIST = ",N,M") [ Required ];

/// 当前申请是否最终通过(-1:申请中，1：申请通过，0：申请未通过）
Property BTExamFinResult As %String;

/// 本次申请有角色未通过时，该角色优先级(申请有角色不通过时更新该字段)
Property BTRolePrior As %String;

/// 申请医院（取路径所属医院，非登录医院）(指向DHCMA.Util.EP.Hospital.OID)
Property BTApplyHosp As %String;

/// 申请人登录科室(指向DHCMA.Util.EP.Location.OID)
Property BTApplyLoc As %String(MAXLEN = 50, TRUNCATE = 1);

/// 申请人（指向DHCMA.Util.EP.SSUser.OID）
Property BTApplyUser As %String(MAXLEN = 50, TRUNCATE = 1);

/// 申请日期
Property BTApplyDate As %Date;

/// 申请时间
Property BTApplyTime As %Time;

Index IdxofFormDrType On (BTPathFormDr, BTExamType As Exact);

Index IdxofFormDr On BTPathFormDr As Exact;

Index IdxofHospFinResult On (BTApplyHosp As Exact, BTExamFinResult As Exact);

/// Creator：     yankai
/// CreatDate：   2021-11-26
/// Description:  获取对象
/// Table：       DHCMA.CPW.BT.ApplyExamRec
/// Input：       aId :  DHCMA.CPW.BT.ApplyExamRec.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.ApplyExamRec).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.ApplyExamRec
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.ApplyExamRec).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.ApplyExamRec).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2021-11-26
/// Description:  更新信息
/// Table：       DHCMA.CPW.BT.ApplyExamRec
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.ApplyExamRec).Update("^84^N^^334!!1^9!!1^^")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set ID       		= $p(aInputStr,aSeparete,1)		//ID
	Set PathFormDr		= $p(aInputStr,aSeparete,2)		//申请表单
	Set ExamType     	= $p(aInputStr,aSeparete,3)		//审核类型
	Set ExamFinResult   = $p(aInputStr,aSeparete,4)		//申请最终结果
	Set:ExamFinResult="" ExamFinResult=-1
	Set BTApplyLoc		= $p(aInputStr,aSeparete,5)		//申请科室
	Set ApplyUser		= $p(aInputStr,aSeparete,6)		//申请人
	Set ApplyDate		= $p(aInputStr,aSeparete,7)		//申请日期
	Set:ApplyDate="" ApplyDate=+$h
	Set ApplyTime		= $p(aInputStr,aSeparete,8)		//申请时间
	Set:ApplyTime="" ApplyTime=$p($h,",",2)
	Set RolePrior		= $p(aInputStr,aSeparete,9)		//未通过角色优先级
	Set ApplyHosp		= $p(aInputStr,aSeparete,10)
	
	Set objPathForm=##class(DHCMA.CPW.BT.PathForm).GetObjById(PathFormDr)
	Quit:'$IsObject(objPathForm) -2
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.BT.ApplyExamRec).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.ApplyExamRec).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTPathFormDr	= objPathForm
	Set obj.BTExamType		= $zcvt(ExamType,"U")
	Set obj.BTExamFinResult	= ExamFinResult
	Set obj.BTApplyLoc		= BTApplyLoc
	Set obj.BTApplyUser		= ApplyUser
	Set obj.BTApplyDate		= ApplyDate
	Set obj.BTApplyTime		= ApplyTime
	Set obj.BTRolePrior		= RolePrior
	Set obj.BTApplyHosp		= ApplyHosp
	
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
/// CreatDate：   2021-11-26
/// Description:  删除申请记录
/// Table：       DHCMA.CPW.BT.ApplyExamRec
/// Input：       aId :  DHCMA.CPW.BT.ApplyExamRec.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.ApplyExamRec).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.BT.ApplyExamRec")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.BT.ApplyExamRec).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     yankai
/// CreatDate：   2021-11-26
/// Description:  更新申请结果
/// Table：       DHCMA.CPW.BT.ApplyExamRec
/// Input：       aId :  DHCMA.CPW.BT.ApplyExamRec.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.ApplyExamRec).SetFinResult(3,1)
ClassMethod SetFinResult(aID As %String, aVal As %String, aRolePrior As %String) As %String
{
	New (aID,aVal,aRolePrior)
	Set return=""
	Quit:(aID="")||((aVal'=1)&&(aVal'=0)) return
	
	Set obj=##class(DHCMA.CPW.BT.ApplyExamRec).%OpenId(aID)
	Set obj.BTExamFinResult=aVal
	Set:aRolePrior'=-1 obj.BTRolePrior = aRolePrior
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
<Data name="ApplyExamRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTPathFormDr</Value>
</Value>
<Value name="3">
<Value>BTExamType</Value>
</Value>
<Value name="4">
<Value>BTExamFinResult</Value>
</Value>
<Value name="5">
<Value>BTApplyUser</Value>
</Value>
<Value name="6">
<Value>BTApplyDate</Value>
</Value>
<Value name="7">
<Value>BTApplyTime</Value>
</Value>
<Value name="8">
<Value>BTApplyLoc</Value>
</Value>
<Value name="9">
<Value>BTRolePrior</Value>
</Value>
<Value name="10">
<Value>BTApplyHosp</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.ApplyExamRecD</DataLocation>
<DefaultData>ApplyExamRecDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.ApplyExamRecD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.ApplyExamRecI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.ApplyExamRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
