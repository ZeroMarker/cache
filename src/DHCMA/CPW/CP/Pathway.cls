/// 名称: DHCMA.CPW.CP.Pathway
/// 描述: 临床路径 出入径记录
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.CP.Pathway Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 申请记录
Relationship ChildApply As DHCMA.CPW.CP.PathwayApply [ Cardinality = children, Inverse = Parref ];

/// 合并症（并发症）
Relationship ChildCompl As DHCMA.CPW.CP.PathwayCompl [ Cardinality = children, Inverse = Parref ];

/// 路径切换
Relationship ChildExec As DHCMA.CPW.CP.PathwayExec [ Cardinality = children, Inverse = Parref ];

/// 路径阶段
Relationship ChildEpis As DHCMA.CPW.CP.PathwayEpis [ Cardinality = children, Inverse = Parref ];

/// 项目执行记录
Relationship ChildImpl As DHCMA.CPW.CP.PathwayImpl [ Cardinality = children, Inverse = Parref ];

/// 病情变异记录
Relationship ChildVar As DHCMA.CPW.CP.PathwayVar [ Cardinality = children, Inverse = Parref ];

/// 就诊ID（DHCMA.Util.EP.Episode.OID）
Property CPEpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 当前（入径、切换）路径指针
Property CPFormDr As DHCMA.CPW.BT.PathForm [ Required ];

/// 当前（入径、切换）阶段指针
Property CPEpisDr As DHCMA.CPW.CP.PathwayEpis;

/// 路径状态（临时T、入径I、出径O、完成C、作废U、预约P、申请A）[门诊路径使用状态：不入径T、入径I、出径O、完成C、作废U]
Property CPStatus As %String(DISPLAYLIST = "TMP,IN,OUT,CLOSE,UN,PRE,APPLY", VALUELIST = ",T,I,O,C,U,P,A");

/// 处置日期
Property CPActDate As %Date;

/// 处置时间
Property CPActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径医生ID（指向DHCMA.Util.EP.CareProv.OID）
Property CPInDocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径日期
Property CPInDate As %Date;

/// 入径时间
Property CPInTime As %Time;

/// 入径人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPInUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径科室ID（指向DHCMA.Util.EP.Location.OID）
Property CPInLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入径病区ID（指向DHCMA.Util.EP.Location.OID）
Property CPInWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出径医生ID（指向DHCMA.Util.EP.CareProv.OID）
Property CPOutDocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出径日期
Property CPOutDate As %Date;

/// 出径时间
Property CPOutTime As %Time;

/// 出径人ID（指向DHCMA.Util.EP.SSUser.OID）
Property CPOutUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出径科室ID（指向DHCMA.Util.EP.Location.OID）
Property CPOutLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出径病区ID（指向DHCMA.Util.EP.Location.OID）
Property CPOutWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 触发入径诊断ICD10(多值以','分隔)
Property CPTrigDiag As %String;

/// 触发入径手术ICD9(多值以','分隔)
Property CPTrigOper As %String;

/// 自动阶段确认模式下是否暂停[1:暂停，0:不暂停]
Property CPRunStatus As %Boolean [ InitialExpression = 0 ];

Index IdxofEpisodeID On CPEpisodeID As Exact;

Index IdxofInLocDate On (CPInLocID As Exact, CPInDate);

Index IdxofInWardDate On (CPInWardID As Exact, CPInDate);

Index IdxofOutLocDate On (CPOutLocID As Exact, CPOutDate);

Index IdxofOutWardDate On (CPOutWardID As Exact, CPOutDate);

Index IdxofActDateStatus On (CPStatus As Exact, CPActDate);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       aId : DHCMA.CPW.CP.Pathway.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.Pathway).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.Pathway
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.Pathway).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.Pathway).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-09-12
/// Description:  生成一条记录
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).Update(1)
ClassMethod Update(aEpisodeID As %String, aFormID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aFormID,aUserID)
	Set return=""
	Quit:(aEpisodeID="")||(aFormID="") return
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.CPEpisodeID=aEpisodeID
	Set obj.CPFormDr=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(obj.CPFormDr) return
	
	Set obj.CPStatus="T"
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
/// CreatDate：   2018-09-12
/// Description:  入径操作
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).GetInCPW(1)
ClassMethod GetInCPW(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set EpisodeID=$p(aInputStr,aSeparete,2)
	Set FormID=$p(aInputStr,aSeparete,3)
	Set EpisID=$p(aInputStr,aSeparete,4)
	Set Status="I"
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=$p(aInputStr,aSeparete,5)
	Set InDocID=$p(aInputStr,aSeparete,6)
	Set InDate=+$H
	Set InTime=$p($H,",",2)
	Set InUserID=$p(aInputStr,aSeparete,5)
	Set InLocID=$p(aInputStr,aSeparete,7)
	Set InWardID=$p(aInputStr,aSeparete,8)
	Set TrigDiag=$p(aInputStr,aSeparete,9)
	Set:TrigDiag'="" TrigDiag=$tr(TrigDiag,"!",",")
	Set TrigOper=$p(aInputStr,aSeparete,10)
	Set:TrigOper'="" TrigOper=$tr(TrigOper,"!",",")
	Set ARStatus=$p(aInputStr,aSeparete,11)
	Set:ARStatus="" ARStatus=0
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.CP.Pathway).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.Pathway).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CPEpisodeID=EpisodeID
	Set obj.CPFormDr=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
	Quit:'$IsObject(obj.CPFormDr) return
	Set obj.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(EpisID)
	Quit:'$IsObject(obj.CPEpisDr) return
	Set obj.CPStatus=Status
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPInDocID=InDocID
	Set obj.CPInDate=InDate
	Set obj.CPInTime=InTime
	Set obj.CPInUserID=InUserID
	Set obj.CPInLocID=InLocID
	Set obj.CPInWardID=InWardID
	Set obj.CPTrigDiag=TrigDiag
	Set obj.CPTrigOper=TrigOper
	Set obj.CPRunStatus=ARStatus
	
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
/// CreatDate：   2018-09-12
/// Description:  出径操作
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).GetOutCPW(1)
ClassMethod GetOutCPW(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Quit:ID="" return
	Set Status="O"
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=$p(aInputStr,aSeparete,2)
	Set OutDocID=$p(aInputStr,aSeparete,3)
	Set OutDate=+$H
	Set OutTime=$p($H,",",2)
	Set OutUserID=$p(aInputStr,aSeparete,2)
	Set OutLocID=$p(aInputStr,aSeparete,4)
	Set OutWardID=$p(aInputStr,aSeparete,5)
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPStatus=Status
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPOutDocID=OutDocID
	Set obj.CPOutDate=OutDate
	Set obj.CPOutTime=OutTime
	Set obj.CPOutUserID=OutUserID
	Set obj.CPOutLocID=OutLocID
	Set obj.CPOutWardID=OutWardID
	
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

/// Creator：     zqy
/// CreatDate：   2022-4-27
/// Description:  作废操作
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).GetUCanCPW(1)
ClassMethod GetUCanCPW(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Quit:ID="" return
	Set Status="U"
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=$p(aInputStr,aSeparete,2)
	Set OutDocID=$p(aInputStr,aSeparete,3)
	Set OutDate=+$H
	Set OutTime=$p($H,",",2)
	Set OutUserID=$p(aInputStr,aSeparete,2)
	Set OutLocID=$p(aInputStr,aSeparete,4)
	Set OutWardID=$p(aInputStr,aSeparete,5)
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPStatus=Status
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPOutDocID=OutDocID
	Set obj.CPOutDate=OutDate
	Set obj.CPOutTime=OutTime
	Set obj.CPOutUserID=OutUserID
	Set obj.CPOutLocID=OutLocID
	Set obj.CPOutWardID=OutWardID
	
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
/// CreatDate：   2018-09-12
/// Description:  完成操作
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).CloseCPW(1)
ClassMethod CloseCPW(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Quit:ID="" return
	Set Status="C"
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=$p(aInputStr,aSeparete,2)
	Set OutDocID=$p(aInputStr,aSeparete,3)
	Set OutDate=+$H
	Set OutTime=$p($H,",",2)
	Set OutUserID=$p(aInputStr,aSeparete,2)
	Set OutLocID=$p(aInputStr,aSeparete,4)
	Set OutWardID=$p(aInputStr,aSeparete,5)
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPStatus=Status
	Set obj.CPActDate=ActDate
	Set obj.CPActTime=ActTime
	Set obj.CPActUserID=ActUserID
	Set obj.CPOutDocID=OutDocID
	Set obj.CPOutDate=OutDate
	Set obj.CPOutTime=OutTime
	Set obj.CPOutUserID=OutUserID
	Set obj.CPOutLocID=OutLocID
	Set obj.CPOutWardID=OutWardID
	
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
/// CreatDate：   2018-09-12
/// Description:  切换路径
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).SwitchCPW(1)
ClassMethod SwitchCPW(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Quit:ID="" return
	
	Set EpisodeID=$p(aInputStr,aSeparete,2)
	Set ActUserID=$p(aInputStr,aSeparete,3)
	Set FormID=$p(aInputStr,aSeparete,4)
	Set EpisID=$p(aInputStr,aSeparete,5)
	Set ExecNote=$p(aInputStr,aSeparete,6)
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).GetObjById(ID)
	Quit:'$IsObject(obj) return
	
	Set ParrefID=ID
	Set ChildID=""
	Set OFormID=obj.CPFormDr.%Id()
	Set OEpisID=obj.CPEpisDr.%Id()
	
	Set ExecStr=ParrefID_"^"_ChildID_"^"_EpisodeID_"^"_OFormID_"^"_OEpisID_"^"_ExecNote_"^"_ActUserID_"^"_FormID_"^"_EpisID
	Set flg=##class(DHCMA.CPW.CP.PathwayExec).Update(ExecStr,"^")
	Quit:+flg<1 "-2"
	
	Set obj.CPFormDr=##class(DHCMA.CPW.BT.PathForm).GetObjById(FormID)
	Quit:'$IsObject(obj.CPFormDr) return
	Set obj.CPEpisDr=##class(DHCMA.CPW.CP.PathwayEpis).GetObjById(EpisID)
	Quit:'$IsObject(obj.CPEpisDr) return
	
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
/// CreatDate：   2018-09-12
/// Description:  作废记录
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).InvalidCPW(1)
ClassMethod InvalidCPW(aID As %String, aUserID As %String) As %String
{
	New (aID,aUserID)
	Set return=""
	Quit:aID="" return
	
	Set Status="U"
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	Set ActUserID=aUserID
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).GetObjById(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPStatus=Status
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
/// CreatDate：   2018-09-12
/// Description:  不入径申请
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).NotInApply(1)
ClassMethod NotInApply(aEpisodeID As %String, aFormID As %String, aLocID As %String, aWardID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aFormID,aLocID,aWardID,aUserID)
	Set return=""
	Quit:(aEpisodeID="")||(aFormID="") return
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%New()
	Quit:'$IsObject(obj) return
	
	Set obj.CPEpisodeID=aEpisodeID
	Set obj.CPFormDr=##class(DHCMA.CPW.BT.PathForm).GetObjById(aFormID)
	Quit:'$IsObject(obj.CPFormDr) return
	
	Set obj.CPStatus="T"
	Set obj.CPActDate=+$H
	Set obj.CPActTime=$p($H,",",2)
	Set obj.CPActUserID=aUserID
	Set obj.CPInLocID=aLocID
	Set obj.CPInWardID=aWardID
	
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
/// CreatDate：   2023-05-6
/// Description:  修改自动阶段确认状态
/// Table：       DHCMA.CPW.CP.Pathway
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.Pathway).UpdateARStatus()
ClassMethod UpdateARStatus(aPathwayID As %String, aARStatus As %String) As %String
{
	New (aPathwayID,aARStatus)
	Set return=""
	Quit:(aPathwayID="")||(aARStatus="") return
	Quit:(aARStatus'=1)&&(aARStatus'=0) return
	
	Set obj=##class(DHCMA.CPW.CP.Pathway).%OpenId(aPathwayID)
	Quit:'$IsObject(obj) return
	
	Set obj.CPRunStatus=aARStatus
	
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
<Data name="PathwayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPEpisodeID</Value>
</Value>
<Value name="3">
<Value>CPFormDr</Value>
</Value>
<Value name="4">
<Value>CPEpisDr</Value>
</Value>
<Value name="5">
<Value>CPStatus</Value>
</Value>
<Value name="6">
<Value>CPActDate</Value>
</Value>
<Value name="7">
<Value>CPActTime</Value>
</Value>
<Value name="8">
<Value>CPActUserID</Value>
</Value>
<Value name="9">
<Value>CPInDocID</Value>
</Value>
<Value name="10">
<Value>CPInDate</Value>
</Value>
<Value name="11">
<Value>CPInTime</Value>
</Value>
<Value name="12">
<Value>CPInUserID</Value>
</Value>
<Value name="13">
<Value>CPInLocID</Value>
</Value>
<Value name="14">
<Value>CPInWardID</Value>
</Value>
<Value name="15">
<Value>CPOutDocID</Value>
</Value>
<Value name="16">
<Value>CPOutDate</Value>
</Value>
<Value name="17">
<Value>CPOutTime</Value>
</Value>
<Value name="18">
<Value>CPOutUserID</Value>
</Value>
<Value name="19">
<Value>CPOutLocID</Value>
</Value>
<Value name="20">
<Value>CPOutWardID</Value>
</Value>
<Value name="21">
<Value>CPTrigDiag</Value>
</Value>
<Value name="22">
<Value>CPTrigOper</Value>
</Value>
<Value name="23">
<Value>CPRunStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.CP.PathwayD</DataLocation>
<DefaultData>PathwayDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.CP.PathwayD</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayI</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
