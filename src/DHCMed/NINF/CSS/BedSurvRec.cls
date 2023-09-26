/// 名称: DHCMed.NINF.CSS.BedSurvRec
/// 描述: 横断面调查床旁调查生成记录
/// 编写者：maxp
/// 编写日期: 2013-12-02
Class DHCMed.NINF.CSS.BedSurvRec Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 调查编号
Property BSCSurvNumber As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BSC_SurvNumber ];

/// 科室
Property BSCSurvDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BSC_SurvDept ];

/// 病区
Property BSCSurvWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = BSC_SurvWard ];

/// 调查日期
Property BSCSurvDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BSC_SurvDate ];

/// 就诊号
Property BSCEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BSC_EpisodeID ];

/// 感染类型(社区感染/医院感染)
Property BSCInfType As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = BSC_InfType ];

/// 感染部位
Property BSCInfPos As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = BSC_InfPos ];

/// 关联报告
Property BSCLinkReport As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = BSC_LinkReport ];

/// 是否有效
Property BSCIsActive As %Boolean [ SqlColumnNumber = 10, SqlFieldName = BSC_IsActive ];

/// 备注
Property BSCResume As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = BSC_Resume ];

Index SurvNumPaadm On (BSCSurvNumber, BSCEpisodeID As Exact);

/// w ##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.CSS.BedSurvRec
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.CSS.BedSurvRec).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.CSS.BedSurvRec).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// input: InStr="ID^BSCSurvNumber^BSCSurvDept^BSCSurvWard^BSCSurvDate^BSCEpisodeID^BSCInfType^BSCInfPos^BSCLinkReport^BSCIsActive^BSCResume"
/// w ##Class(DHCMed.NINF.CSS.BedSurvRec).Update("")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set return=0
	quit:InStr="" return
	
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.NINF.CSS.BedSurvRec).%New()
	} else {
		set obj=##class(DHCMed.NINF.CSS.BedSurvRec).%OpenId(ID)
	}
 	
	set obj.BSCSurvNumber=$p(InStr,"^",2)
	set obj.BSCSurvDept=$p(InStr,"^",3)
	set obj.BSCSurvWard=$p(InStr,"^",4)
	set SurvDate=$p(InStr,"^",5)
	set:SurvDate["-" SurvDate=$zdh(SurvDate,3)
	set obj.BSCSurvDate=SurvDate
	set obj.BSCEpisodeID=$p(InStr,"^",6)
	set obj.BSCInfType=$p(InStr,"^",7)
	set obj.BSCInfPos=$p(InStr,"^",8)
	set obj.BSCLinkReport=$p(InStr,"^",9)
	set obj.BSCIsActive=+$p(InStr,"^",10)
	set obj.BSCResume=$p(InStr,"^",11)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     maxp
/// CreatDate：   2013-12-02
/// Description:  删除
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.CSS.BedSurvRec).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// 独立开发模式的横断面程序
/// w ##Class(DHCMed.NINF.CSS.BedSurvRec).UpdateCSSInfo()
ClassMethod UpdateCSSInfo(aBedSurvID As %String, aReportID As %String) As %String
{
	New (aBedSurvID,aReportID)
	Set return=0
	Quit:aBedSurvID="" return
	
	Set $ZT="UpdateCSSInfoErr"
	
	Set objBedSurv=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(aBedSurvID)
	Quit:'$IsObject(objBedSurv) return
	Set EpisodeID=objBedSurv.BSCEpisodeID
	Set SurvNumber=objBedSurv.BSCSurvNumber
	Quit:(SurvNumber="")||(EpisodeID="") return
	
	Set CSSRepID=$o(^DHCMed.NINF.CSSi("REP","IndexEpisodeID"," "_SurvNumber," "_EpisodeID,1,0))
	Quit:CSSRepID="" return
	Set objCSSRep=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(CSSRepID)
	Quit:'$IsObject(objCSSRep) return
	/*
	Set InfPos1=objCSSRep.CRInfPos1
	Set InfPos2=objCSSRep.CRInfPos2
	Set InfPos3=objCSSRep.CRInfPos3
	Set InfPos=""
	Set:InfPos1'="" InfPos=InfPos_","_InfPos1
	Set:InfPos2'="" InfPos=InfPos_","_InfPos2
	Set:InfPos3'="" InfPos=InfPos_","_InfPos3
	Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
	*/
	//fix bug 112134 by pylian 20150625 横断面调查个案登记-维护了社区感染且填写了社区感染部位的记录不显示感染部位 
	Set CRInfCategory=objCSSRep.CRInfCategory  // 感染分类
	Set CRIsInfection=objCSSRep.CRIsInfection  // 是否感染
	Set InfPos=""
	If (CRIsInfection["存在") {
		If CRInfCategory["医院感染" {
			Set InfPos1=objCSSRep.CRInfPos1
			Set InfPos2=objCSSRep.CRInfPos2
			Set InfPos3=objCSSRep.CRInfPos3
			Set:InfPos1'="" InfPos=InfPos_","_InfPos1
			Set:InfPos2'="" InfPos=InfPos_","_InfPos2
			Set:InfPos3'="" InfPos=InfPos_","_InfPos3
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
		} Else {
			Set InfPos1=objCSSRep.CRComInfPos1
			Set InfPos2=objCSSRep.CRComInfPos2
			Set InfPos3=objCSSRep.CRComInfPos3
			Set:InfPos1'="" InfPos=InfPos_","_InfPos1
			Set:InfPos2'="" InfPos=InfPos_","_InfPos2
			Set:InfPos3'="" InfPos=InfPos_","_InfPos3
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))	
		}
	}
	
	Set obj=##Class(DHCMed.NINF.CSS.BedSurvRec).%OpenId(aBedSurvID)
	Quit:'$IsObject(obj) return
	Set obj.BSCInfType    = CRIsInfection
	Set obj.BSCInfPos     = InfPos
	Set obj.BSCLinkReport = CSSRepID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {    //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdateCSSInfoErr
	Quit return
}

/* update by zf 20140506
/// 自定义表单模式的横断面程序
/// w ##Class(DHCMed.NINF.CSS.BedSurvRec).UpdateCSSInfo()
ClassMethod UpdateCSSInfo(aBedSurvID As %String,aReportID As %String) As %String
{
	New (aBedSurvID,aReportID)
	Set return=0
	Quit:(aBedSurvID="")||(aReportID="") return
	
	Set $ZT="UpdateCSSInfoErr"
	
	Set objBedSurv=##class(DHCMed.NINF.CSS.BedSurvRec).GetObjById(aBedSurvID)
	Quit:'$IsObject(objBedSurv) return
	Set EpisodeID=objBedSurv.BSCEpisodeID
	Set SurvNumber=objBedSurv.BSCSurvNumber
	Quit:(SurvNumber="")||(EpisodeID="") return
	
	Set objData=##class(DHCMed.CR.PO.Data).GetObjById(aReportID)
	Quit:'$IsObject(objData) return
	Set FormID=objData.FormVerDR
	Quit:FormID="" return
	Set objForm=##class(DHCMed.CR.PO.Form).GetObjById(+FormID)
	Quit:'$IsObject(objForm) return
	Set ClassName=objForm.GetClassName()
	Set tmpExp="Set objCSSRep=##Class(ClassName).%OpenId(aReportID)"
	X tmpExp
	Quit:'$IsObject(objCSSRep) return
	Set InfType=objCSSRep.InfType
	Set InfPos=""
	If (objCSSRep.IsInfection="Y") {
		If InfType=1 {
			Set InfPos1=objCSSRep.HosInfPos1
			Set InfPos2=objCSSRep.HosInfPos2
			Set InfPos3=objCSSRep.HosInfPos3
			Set:InfPos1'="" InfPos=InfPos_","_InfPos1
			Set:InfPos2'="" InfPos=InfPos_","_InfPos2
			Set:InfPos3'="" InfPos=InfPos_","_InfPos3
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
			Set InfType="医院感染"
		} Else {
			Set InfPos1=objCSSRep.CommuInfPos1
			Set InfPos2=objCSSRep.CommuInfPos2
			Set InfPos3=objCSSRep.CommuInfPos3
			Set:InfPos1'="" InfPos=InfPos_","_InfPos1
			Set:InfPos2'="" InfPos=InfPos_","_InfPos2
			Set:InfPos3'="" InfPos=InfPos_","_InfPos3
			Set:InfPos'="" InfPos=$e(InfPos,2,$l(InfPos))
			Set InfType="社区感染"
		}
	} Else {
		Set InfType=""
	}
	
	Set obj=##Class(DHCMed.NINF.CSS.BedSurvRec).%OpenId(aBedSurvID)
	Quit:'$IsObject(obj) return
	Set obj.BSCInfType    = InfType
	Set obj.BSCInfPos     = InfPos
	Set obj.BSCLinkReport = aReportID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {    //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
	
UpdateCSSInfoErr
	Quit return
}
*/
Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BSCSurvNumber</Value>
</Value>
<Value name="3">
<Value>BSCSurvDept</Value>
</Value>
<Value name="4">
<Value>BSCSurvWard</Value>
</Value>
<Value name="5">
<Value>BSCSurvDate</Value>
</Value>
<Value name="6">
<Value>BSCEpisodeID</Value>
</Value>
<Value name="7">
<Value>BSCInfType</Value>
</Value>
<Value name="8">
<Value>BSCInfPos</Value>
</Value>
<Value name="9">
<Value>BSCLinkReport</Value>
</Value>
<Value name="10">
<Value>BSCIsActive</Value>
</Value>
<Value name="11">
<Value>BSCResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.CSS("BSR")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.CSS("BSR")</IdLocation>
<IndexLocation>^DHCMed.NINF.CSSi("BSR")</IndexLocation>
<StreamLocation>^DHCMed.NINF.CSS.BedSurvRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
