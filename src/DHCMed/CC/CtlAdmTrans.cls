/// 名称: DHCMed.CC.CtlAdmTrans
/// 描述: 目标性监测 科室住院记录
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.CC.CtlAdmTrans Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// EpisodeID 指向Pa_Adm
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 最新记录 指向PA_AdmTransaction
Property TransID As %String;

/// 转入科室 指向CT_Loc
Property TransLoc As %String(TRUNCATE = 1) [ Required ];

/// 转入日期
Property TransInDate As %Date;

/// 转出日期
Property TransOutDate As %Date;

/// 转科类型
Property TransType As %String(TRUNCATE = 1) [ Required ];

/// 完成标志
Property IsFinish As %String(TRUNCATE = 1) [ Required ];

/// 关联记录 指向DHCMed.CC.CtlAdmTrans
Property LinkID As %String(TRUNCATE = 1);

/// 完成标记索引
Index IndexNoFinishAdm On (TransType As Exact, IsFinish As Exact, EpisodeID As Exact);

/// 时间科室索引
Index IndexInDateLoc On (TransInDate As Exact, TransLoc As Exact, EpisodeID As Exact);

Index IndexOutDateLoc On (TransOutDate As Exact, TransLoc As Exact, EpisodeID As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  取目标性监测 科室住院记录
/// Table：       DHCMed.CC.CtlAdmTrans
/// Input：       DHCMed.CC.CtlAdmTrans.ID
/// Return：      返回obj
/// w ##class(DHCMed.CC.CtlAdmTrans).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.CC.CtlAdmTrans
{
	New (aId)
	Set obj=##Class(DHCMed.CC.CtlAdmTrans).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  更新目标性监测 科室住院记录
/// Table：       DHCMed.CC.CtlAdmTrans
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.CC.CtlAdmTrans).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.CC.CtlAdmTrans).%New()
	} Else {
		Set obj=##class(DHCMed.CC.CtlAdmTrans).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=$p(aInput,aSeparate,2)
	Set obj.TransID=$p(aInput,aSeparate,3)
	Set obj.TransLoc=$p(aInput,aSeparate,4)
	Set obj.TransInDate=$p(aInput,aSeparate,5)
	Set obj.TransOutDate=$p(aInput,aSeparate,6)
	Set obj.TransType=$p(aInput,aSeparate,7)
	Set obj.IsFinish=$p(aInput,aSeparate,8)
	Set obj.LinkID=$p(aInput,aSeparate,9)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  删除目标性监测 科室住院记录
/// Table：       DHCMed.CC.CtlAdmTrans
/// Input：       DHCMed.CC.CtlAdmTrans.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.CC.CtlAdmTrans).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// 处理转科记录
/// w ##Class(DHCMed.CC.CtlAdmTrans).ProAdmTrans("2013-06-30","2013-07-31")
ClassMethod ProAdmTrans(aFromDate As %String, aToDate As %String) As %String
{
	New (aFromDate,aToDate)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	//在院患者列表
	Set WardID="",Count=0
	For {
		Set WardID=$o(^PAADMi("CurrWard",WardID))
		Quit:WardID=""
		Set RoomID=""
		For {
			Set RoomID=$o(^PAADMi("CurrWard",WardID,RoomID))
			Quit:RoomID=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("CurrWard",WardID,RoomID,Paadm))
				Quit:Paadm=""
				
				Set AdmInfo=$g(^PAADM(Paadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
				
				//Continue:$p(AdmInfo,"^",6)>aToDate   //就诊时间过滤
				//upadte by pylian 2016-02-18 修改入院时间取值方式
    			Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
    			Continue:$p(AdmDateTime,"^",1)>aToDate   //就诊时间过滤
				Set Count=Count+1
				
				Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"W")
				Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"E")
				//w "Paadm="_Paadm,!
			}
		}
	}
	
	//出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aFromDate:1:CurrDate {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,xDate,Paadm))
			Quit:Paadm=""
			
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			//Continue:$p(AdmInfo,"^",6)>aToDate   //就诊时间过滤
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
    		Continue:$p(AdmDateTime,"^",1)>aToDate   //就诊时间过滤
			Set Count=Count+1
			
			Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"W")
			Set flg=##class(DHCMed.CCService.Feedback.CtlAdmTransSrv).UpdateTrans(Paadm,"E")
			//w "Paadm="_Paadm,!
		}
	}
	
	Set return=Count
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>TransID</Value>
</Value>
<Value name="4">
<Value>TransLoc</Value>
</Value>
<Value name="5">
<Value>TransInDate</Value>
</Value>
<Value name="6">
<Value>TransOutDate</Value>
</Value>
<Value name="7">
<Value>TransType</Value>
</Value>
<Value name="8">
<Value>IsFinish</Value>
</Value>
<Value name="9">
<Value>LinkID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.CtlResultD("AdmTrans")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.CtlResultD("AdmTrans")</IdLocation>
<IndexLocation>^DHCMed.CC.CtlResultI("AdmTrans",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.CtlAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
