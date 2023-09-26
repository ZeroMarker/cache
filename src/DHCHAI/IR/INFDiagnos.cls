/// 名称: DHCHAI.IR.INFDiagnos
/// 描述：医院感染 诊断信息
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.INFDiagnos Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 感染部位/感染诊断
Property IRInfPosDr As DHCHAI.BT.InfPos;

/// 感染分类
Property IRInfSubDr As DHCHAI.BT.InfSub;

/// 感染日期
Property IRInfDate As %Date;

/// 感染科室
Property IRInfLocDr As DHCHAI.BT.Location;

/// 诊断依据
Property IRInfDiagnosisBasis As %String(MAXLEN = 500, TRUNCATE = 1);

/// 感染性疾病病程
Property IRInfDiseaseCourse As %String(MAXLEN = 500, TRUNCATE = 1);

/// 感染转归日期
Property IRInfXDate As %Date;

/// 感染转归/疗效
Property IRInfEffectDr As DHCHAI.BT.Dictionary;

/// 与死亡关系
Property IRDeathRelationDr As DHCHAI.BT.Dictionary;

/// 更新日期
Property IRUpdateDate As %Date;

/// 更新时间
Property IRUpdateTime As %Time;

/// 更新人
Property IRUpdateUserDr As DHCHAI.BT.SysUser;

/// 是否临床上报诊断
Property IRIsReportDiag As %Boolean;

/// 病原体 多个#分割
Property IRBacteria As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否有效
Property IRIsActive As %Boolean;

/// 感染类型（社区感染0、医院感染1）
Property IRInfType As %Integer;

Index IndexPaadm On IREpisodeDr;

Index IndexIRInfDate On IRInfDate;

Index IndexEpisInfDate On (IREpisodeDr, IRInfDate);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据ID取医院感染诊断信息
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       Id : DHCHAI.IR.INFDiagnos.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFDiagnos).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFDiagnos
{
	New (aId)
	Quit:'##class(DHCHAI.IR.INFDiagnos).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.INFDiagnos).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新医院感染诊断信息
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       各属性列表 ^分隔
/// 1 ID 2 IREpisodeDr 3 IRInfPosDr 4 IRInfSubDr 5 IRInfDate 6 IRInfLocDr 7 IRInfXDate 
/// 8 IRInfEffectDr 9 IRUpdateDate 10 IRUpdateTime 11 IRUpdateUserDr
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFDiagnos).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set IREpisodeDr  = $p(aInputStr,aSeparete,2)
	Set IRInfPosDr  = $p(aInputStr,aSeparete,3)
	Set IRInfSubDr    = $p(aInputStr,aSeparete,4)
	Set IRInfDate    = $p(aInputStr,aSeparete,5)
	Set:IRInfDate'="" IRInfDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRInfDate)
	Set IRInfLocDr    = $p(aInputStr,aSeparete,6)
	Set IRInfDiagnosisBasis = $p(aInputStr,aSeparete,7)
	Set IRInfDiseaseCourse = $p(aInputStr,aSeparete,8)
	Set IRInfXDate   = $p(aInputStr,aSeparete,9)
	Set:IRInfXDate'="" IRInfXDate = ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRInfXDate)
	Set IRInfEffectDr   = $p(aInputStr,aSeparete,10)
	Set IRDeathRelationDr = $p(aInputStr,aSeparete,11)
	Set IRUpdateDate    = $p(aInputStr,aSeparete,12)
	Set IRUpdateTime   = $p(aInputStr,aSeparete,13)
	Set IRUpdateUserDr = $p(aInputStr,aSeparete,14)
	Set IsReportDiag   = +$p(aInputStr,aSeparete,15)
	Set IRBacteria =$p(aInputStr,aSeparete,16)
	Set:IRUpdateDate="" IRUpdateDate = +$h
	Set:IRUpdateTime="" IRUpdateTime = +($p($h,",",2))
	Quit:IREpisodeDr="" return
	Set IRIsActive = $p(aInputStr,aSeparete,17)
	Set IRInfType = $p(aInputStr,aSeparete,18)
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.INFDiagnos).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFDiagnos).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr = ##class(DHCHAI.DP.PAAdm).GetObjById(IREpisodeDr)
	Set obj.IRInfPosDr = ##class(DHCHAI.BT.InfPos).GetObjById(IRInfPosDr)
	Set obj.IRInfSubDr = ##class(DHCHAI.BT.InfSub).GetObjById(IRInfSubDr)
	//Set:IRInfDate["-" IRInfDate=$zdh(IRInfDate,3)
	Set:IRInfDate'="" IRInfDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRInfDate)
	Set obj.IRInfDate = IRInfDate
	Set obj.IRInfLocDr = ##class(DHCHAI.BT.Location).GetObjById(IRInfLocDr)
	Set obj.IRInfDiagnosisBasis = IRInfDiagnosisBasis
	Set obj.IRInfDiseaseCourse = IRInfDiseaseCourse
	//Set:IRInfXDate["-" IRInfXDate=$zdh(IRInfXDate,3)
	Set:IRInfXDate'="" IRInfXDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(IRInfXDate)
	Set obj.IRInfXDate =IRInfXDate
	Set obj.IRInfEffectDr = ##class(DHCHAI.BT.Dictionary).GetObjById(IRInfEffectDr)
	Set obj.IRDeathRelationDr = ##class(DHCHAI.BT.Dictionary).GetObjById(IRDeathRelationDr)
	Set obj.IRUpdateDate = +$h
	Set obj.IRUpdateTime = $p($h,",",2)
	Set obj.IRUpdateUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(IRUpdateUserDr)
	Set obj.IRIsReportDiag = IsReportDiag
	Set obj.IRBacteria = IRBacteria
	Set obj.IRIsActive = IRIsActive
	Set obj.IRInfType = IRInfType

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

/// Creator：     pylian
/// CreatDate：   2019-06-17
/// Description:  修改感染类型
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：                
/// Return：      返回String
/// w ##class(DHCHAI.IR.INFDiagnos).CheckInfType(111,1)
ClassMethod CheckInfType(aID As %String, aInfType As %String) As %String
{
	New (aID,aInfType)
	Set return=0
	Quit:(aID="")||(aInfType="") return
	
	Set obj=##class(DHCHAI.IR.INFDiagnos).%OpenId(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.IRInfType = aInfType
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

/// Creator：     pylian
/// CreatDate：   2019-07-01
/// Description:  修改感染信息有效性
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：                
/// Return：      返回String
/// w ##class(DHCHAI.IR.INFDiagnos).UpdateActive(1)
ClassMethod UpdateActive(aID As %String, aIsActive As %String = 1) As %String
{
	New (aID,aIsActive)
	Set return=0
	Quit:(aID="") return
	
	Set obj=##class(DHCHAI.IR.INFDiagnos).%OpenId(aID)
	Quit:'$IsObject(obj) return
	
	Set obj.IRIsActive = aIsActive
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

/// Creator：     pylian
/// CreatDate：   2019-12-11
/// Description:  处理感染科室问题（新版院感报告不保存科室，民科导出有问题，感染科室按感染日期归属处理）
/// Table：       DHCHAI.IR.INFReport、DHCHAI.IR.INFDiagnos
/// Input：                
/// Return：      返回String
/// w ##class(DHCHAI.IR.INFDiagnos).SynRepInfLoc()
ClassMethod SynRepInfLoc() As %String
{
	Set return=""
	Set Count=0
   
    Set xID=""
    For {
		Set xID=$o(^DHCHAI.IR.INFReportD(xID))
	   	Quit:xID=""
	   	
	   	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xID)
	   	Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
	   	Continue:(objRep.IRRepType'=1)
	   	Set EpisodeDr =objRep.IREpisodeDr.%Id()
	   	Set LinkDiags = objRep.GetRepLinkIDs("DHCHAI.IR.INFDiagnos")
	    Continue:LinkDiags=""
	    Continue:$l(LinkDiags,",")>1  //新版之前的不处理
	    
    	Set objDiag = ##class(DHCHAI.IR.INFDiagnos).GetObjById(LinkDiags)
		Continue:'$IsObject(objDiag)
	    Set DiagID = objDiag.%Id()
		Continue:objDiag.IRInfLocDr'=""  //新版之前的不处理
		
		Set InfDate = objDiag.IRInfDate
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,InfDate,"")
		Set TransLocID = $p(TransInfo,"^",1)
		
		Set obj=##class(DHCHAI.IR.INFDiagnos).%OpenId(DiagID)
		Continue:'$IsObject(obj) 
		
		Set obj.IRInfLocDr =##class(DHCHAI.BT.Location).GetObjById(TransLocID) 
		Set sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
			Do $system.OBJ.DisplayError(sc)
			Set return=-1
		}else{
			Set return=obj.%Id()
		}
		Do obj.%Close()
		Set Count = Count+1
		
    }
    Set return =Count
    
	Quit return
}

Method ToString(aSeparete As %String) As %String
{
	Set (EpisodeDr,InfPosDr,InfSubDr,InfLocDr,InfEffectDr,DeathRelationDr,UpdateUserDr)=""
	Set:$IsObject(..IREpisodeDr) EpisodeDr=..IREpisodeDr.%Id()
	Set:$IsObject(..IRInfPosDr) InfPosDr=..IRInfPosDr.%Id()
	Set:$IsObject(..IRInfSubDr) InfSubDr=..IRInfSubDr.%Id()
	Set:$IsObject(..IRInfLocDr) InfLocDr=..IRInfLocDr.%Id()
	Set:$IsObject(..IRInfEffectDr) InfEffectDr=..IRInfEffectDr.%Id()
	Set:$IsObject(..IRDeathRelationDr) DeathRelationDr=..IRDeathRelationDr.%Id()
	Set:$IsObject(..IRUpdateUserDr) UpdateUserDr=..IRUpdateUserDr.%Id()
	Set return=..%Id()_aSeparete
	Set return=return_EpisodeDr_aSeparete
	Set return=return_InfPosDr_aSeparete
	Set return=return_InfSubDr_aSeparete
	Set return=return_..IRInfDate_aSeparete
	Set return=return_InfLocDr_aSeparete
	Set return=return_..IRInfDiagnosisBasis_aSeparete
	Set return=return_..IRInfDiseaseCourse_aSeparete
	Set return=return_..IRInfXDate_aSeparete
	Set return=return_InfEffectDr_aSeparete
	Set return=return_DeathRelationDr_aSeparete
	Set return=return_..IRUpdateDate_aSeparete
	Set return=return_..IRUpdateTime_aSeparete
	Set return=return_UpdateUserDr_aSeparete
	Set return=return_..IRIsReportDiag_aSeparete
	Set return=return_..IRBacteria_aSeparete
	Set return=return_..IRIsActive_aSeparete
	Set return=return_..IRInfType_aSeparete
	quit return
}

/// Creator：     pylian
/// CreatDate：   2019-07-22
/// Description:  根据ID取医院感染诊断信息
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       ID:    DDHCHAI.IR.INFDiagnos.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.INFDiagnos).GetStringById(1)
ClassMethod GetStringById(aID As %String, aSeparete As %String = "^") As %String
{
	New (aID,aSeparete)
	Set return=0
	Quit:aID="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	
	Set obj=##Class(DHCHAI.IR.INFDiagnos).GetObjById(+aID)
	If $IsObject(obj){
		Set return=obj.ToString(aSeparete)
	}
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除医院感染诊断信息
/// Table：       DHCHAI.IR.INFDiagnos
/// Input：       Id : DHCHAI.IR.INFDiagnos.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFDiagnos).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	//监测是否存在报告关联
	//存在则不可以删除 ^DHCHAI.IR.INFReportI("EXT","IndexObjectID"," DHCHAI.IR.INFDIAGNOS"," 9"
	Set:$d(^DHCHAI.IR.INFReportI("EXT","IndexObjectID"," DHCHAI.IR.INFDiagnos"," "_aId)) return = -2
	Set sc = ##class(DHCHAI.IR.INFDiagnos).%DeleteId(aId)
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
<Data name="INFDiagnosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRInfPosDr</Value>
</Value>
<Value name="4">
<Value>IRInfSubDr</Value>
</Value>
<Value name="5">
<Value>IRInfDate</Value>
</Value>
<Value name="6">
<Value>IRInfLocDr</Value>
</Value>
<Value name="7">
<Value>IRInfXDate</Value>
</Value>
<Value name="8">
<Value>IRInfEffectDr</Value>
</Value>
<Value name="9">
<Value>IRUpdateDate</Value>
</Value>
<Value name="10">
<Value>IRUpdateTime</Value>
</Value>
<Value name="11">
<Value>IRUpdateUserDr</Value>
</Value>
<Value name="12">
<Value>IRInfDiagnosisBasis</Value>
</Value>
<Value name="13">
<Value>IRInfDiseaseCourse</Value>
</Value>
<Value name="14">
<Value>IRDeathRelationDr</Value>
</Value>
<Value name="15">
<Value>IRIsReportDiag</Value>
</Value>
<Value name="16">
<Value>IRBacteria</Value>
</Value>
<Value name="17">
<Value>IRIsActive</Value>
</Value>
<Value name="18">
<Value>IRInfType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.INFDiagnosD</DataLocation>
<DefaultData>INFDiagnosDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.INFDiagnosD</IdLocation>
<IndexLocation>^DHCHAI.IR.INFDiagnosI</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
