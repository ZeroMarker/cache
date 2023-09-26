/// 名称: DHCHAI.IR.ICULogDtl
/// 描述: ICU三管日志表()的业务封装，定义常用属性和方法
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.ICULogDtl Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property ILEpisodeDr As DHCHAI.DP.PAAdm;

/// 调查科室
Property ILLocDr As DHCHAI.BT.Location;

/// 调查日期
Property ILDate As %Date;

/// 是否使用呼吸机
Property ILIsVAP As %Boolean;

/// 是否脐/中心静脉置管人数
Property ILIsPICC As %Boolean;

/// 是否泌尿道插管
Property ILIsUC As %Boolean;

/// 是否手术患者
Property ILIsOper As %Boolean;

/// 在科状态(入科I、出科O、在科A、转入转出A2)
Property ILStatus As %String;

/// 是否非血透静脉置管人数
Property ILIsCVC As %Boolean;

/// 是否血透静脉置管人数
Property ILIsCRRT As %Boolean;

/// 是否输液港静脉置管人数
Property ILIsPORT As %Boolean;

Index IndexLocDate On (ILLocDr, ILDate);

Index IndexILEpisodeDr On (ILLocDr, ILDate, ILEpisodeDr);

Index IndexDateEpisodeDr On (ILDate, ILEpisodeDr);

Index IndexEpisodeDr On ILEpisodeDr;

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据RowId取医院信息
/// Table：       DHCHAI.IR.ICULogDtl
/// Input：       RowID    DHCHAI.IR.ICULogDtl
/// Return：      返回obj
/// Others：       
ClassMethod GetObjById(RowId As %String) As DHCHAI.IR.ICULogDtl
{
	new (RowId)
	set return=""
	quit:RowId="" return
	quit:'$d(^DHCHAI.IR.ICULogDtlD(+RowId)) return
	set obj=##Class(DHCHAI.IR.ICULogDtl).%OpenId(+RowId)
	quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新
/// Table：       DHCHAI.IR.CCInfItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ICULogDtl).Update("","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	New (InStr,separete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(separete)="" separete=..#SEPARATE
	Set ID         =$p(InStr,separete,1)
	Set ILEpisodeDr=$p(InStr,separete,2)
	Set ILLocDr    =$p(InStr,separete,3)
	Set ILDate     =$p(InStr,separete,4)
	Set ILIsVAP    =$p(InStr,separete,5)
	Set ILIsPICC   =$p(InStr,separete,6)
	Set ILIsUC     =$p(InStr,separete,7)	
	Set ILIsOper   =$p(InStr,separete,8)
	Set ILStatus   =$p(InStr,separete,9)
	Set ILIsCVC    =$p(InStr,separete,10) 
	Set ILIsCRRT   =$p(InStr,separete,11)
	Set ILIsPORT   =$p(InStr,separete,12)
	Quit:(ILEpisodeDr="")||(ILDate="") return
	
	//Set:ILDate["-" ILDate=$zdh(ILDate,3)
	//Set:ILDate["/" ILDate=$zdh(ILDate,1)
	Set:ILDate'="" ILDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ILDate)
	Set:ILDate="" ILDate=+$h
	
	Set objPaadm=##class(DHCHAI.DP.PAAdm).GetObjById(ILEpisodeDr)
	Quit:'$IsObject(objPaadm) return
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(ILLocDr)
	
	//科室+日期+Paadm 唯一处理
	//Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",ILDate,ILEpisodeDr,0))
	Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexILEpisodeDr",ILLocDr,ILDate,ILEpisodeDr,0))
	Set:xID'="" ID=xID
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.ICULogDtl).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.ICULogDtl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ILEpisodeDr= objPaadm
	Set obj.ILLocDr    = objLoc
	Set obj.ILDate     = ILDate
	Set obj.ILIsVAP    = ILIsVAP
	Set obj.ILIsPICC   = ILIsPICC
	Set obj.ILIsUC     = ILIsUC
	Set obj.ILIsOper   = ILIsOper
	Set obj.ILStatus   = ILStatus
	Set obj.ILIsCVC    = ILIsCVC
	Set obj.ILIsCRRT   = ILIsCRRT
	Set obj.ILIsPORT   = ILIsPORT	
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

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除
/// Table：       DHCHAI.IR.ICULogDtl
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCHAI.IR.ICULogDtl).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

/// Creator：     pylian
/// CreatDate：   2019-02-14
/// Description:  删除出院日期后的ICU日志记录
/// w ##class(DHCHAI.IR.ICULogDtl).DeleteByDischDate()
ClassMethod DeleteByDischDate(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set DischDate=objEpisode.PADischDate
	Set DischTime=objEpisode.PADischTime
	Set VisitStatus=objEpisode.PAVisitStatus
	Set AdmDate=objEpisode.PAAdmDate
	Set AdmTime = objEpisode.PAAdmTime
	Set:VisitStatus="C" DischDate=AdmDate 
	Set:VisitStatus="C" DischTime=AdmTime 
	Quit:DischDate="" return
	
	Set xDate=DischDate-1
	For {
		Set xDate=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate))
		Quit:xDate=""
		Continue:xDate=DischDate
				
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate,aEpisodeDr,xID))
			Quit:xID=""
			
			Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xID) 
			Continue:'$IsObject(objDtl)
			Set LocDr = objDtl.ILLocDr.%Id()
			Set LocType = objDtl.ILLocDr.BTTypeDr.BTCode
			
			Do ..DeleteById(xID)  //删除日志明细
			
			//重新生成ICU日志汇总
			Do ##class(DHCHAI.IRS.ICULogSrv).CreateICULogByDay(xDate,xDate,LocDr,LocType)
		}
			
	}
	Set return=1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-10-08
/// Description:  删除等待状态患者ICU日志记录
/// w ##class(DHCHAI.IR.ICULogDtl).DeleteByEpisodeID()
ClassMethod DeleteByEpisodeID(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return=0
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	
	Set VisitStatus=objEpisode.PAVisitStatus
	Quit:VisitStatus'="P" return

	Set xDate=""
	For {
		Set xDate=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate))
		Quit:xDate=""
		Continue:xDate>(+$H)
				
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.ICULogDtlI("IndexDateEpisodeDr",xDate,aEpisodeDr,xID))
			Quit:xID=""
			
			Set objDtl=##class(DHCHAI.IR.ICULogDtl).GetObjById(xID) 
			Continue:'$IsObject(objDtl)
			Set LocDr = objDtl.ILLocDr.%Id()
			Set LocType = objDtl.ILLocDr.BTTypeDr.BTCode
			Do ..DeleteById(xID)  //删除日志明细
			
			//重新生成ICU日志汇总
			Do ##class(DHCHAI.IRS.ICULogSrv).CreateICULogByDay(xDate,xDate,LocDr,LocType)
		}
			
	}
	Set return=1
	Quit return
}

Storage Default
{
<Data name="ICULogDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ILEpisodeDr</Value>
</Value>
<Value name="3">
<Value>ILLocDr</Value>
</Value>
<Value name="4">
<Value>ILDate</Value>
</Value>
<Value name="5">
<Value>ILIsVAP</Value>
</Value>
<Value name="6">
<Value>ILIsPICC</Value>
</Value>
<Value name="7">
<Value>ILIsUC</Value>
</Value>
<Value name="8">
<Value>ILIsOper</Value>
</Value>
<Value name="9">
<Value>ILStatus</Value>
</Value>
<Value name="10">
<Value>ILIsCVC</Value>
</Value>
<Value name="11">
<Value>ILIsCRRT</Value>
</Value>
<Value name="12">
<Value>ILIsPORT</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ICULogDtlD</DataLocation>
<DefaultData>ICULogDtlDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ICULogDtlD</IdLocation>
<IndexLocation>^DHCHAI.IR.ICULogDtlI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ICULogDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
