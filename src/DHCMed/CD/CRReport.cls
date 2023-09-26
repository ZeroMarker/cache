/// 名称: DHCMed.CD.CRReport
/// 描述: 报告主卡信息
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-19
Class DHCMed.CD.CRReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 日志
Relationship ChildLOG As DHCMed.CD.CRReportLOG [ Cardinality = children, Inverse = ParRef ];

/// 病人信息
Relationship ChildPAT As DHCMed.CD.CRReportPAT [ Cardinality = children, Inverse = ParRef ];

/// 备注（其他）信息
Relationship ChildBZQT As DHCMed.CD.CRReportBZQT [ Cardinality = children, Inverse = ParRef ];

/// 肿瘤卡
Relationship ChildZLK As DHCMed.CD.CRReportZLK [ Cardinality = children, Inverse = ParRef ];

/// 心脑血管（冠心病、脑卒中）
Relationship ChildXNXG As DHCMed.CD.CRReportXNXG [ Cardinality = children, Inverse = ParRef ];

/// 糖尿病
Relationship ChildTNB As DHCMed.CD.CRReportTNB [ Cardinality = children, Inverse = ParRef ];

/// 高温中暑
Relationship ChildGWZS As DHCMed.CD.CRReportGWZS [ Cardinality = children, Inverse = ParRef ];

/// 农药中毒
Relationship ChildNYZD As DHCMed.CD.CRReportNYZD [ Cardinality = children, Inverse = ParRef ];

/// 疑似职业病
Relationship ChildYSZYB As DHCMed.CD.CRReportYSZYB [ Cardinality = children, Inverse = ParRef ];

/// 非职业一氧化碳中毒
Relationship ChildFZYCO As DHCMed.CD.CRReportFZYCO [ Cardinality = children, Inverse = ParRef ];

/// 伤害卡
Relationship ChildSHK As DHCMed.CD.CRReportSHK [ Cardinality = children, Inverse = ParRef ];

/// 高血压
Relationship ChildGXY As DHCMed.CD.CRReportGXY [ Cardinality = children, Inverse = ParRef ];

/// add by pylian 2016-04-27
/// 苏州慢性病报病卡
Relationship ChildMBBK As DHCMed.CD.CRReportMBBK [ Cardinality = children, Inverse = ParRef ];

/// add by zhufei 2019-12-02
/// 出生缺陷儿报卡
Relationship ChildCSQX As DHCMed.CD.CRReportCSQX [ Cardinality = children, Inverse = ParRef ];

/// add by chenr 2021-10-12
/// 儿童伤害卡
Relationship ChildETSH As DHCMed.CD.CRReportETSH [ Cardinality = children, Inverse = ParRef ];

/// 就诊号
Property CREpisodeID As %String;

/// 报卡类型	(ZLK,XNXG)
Property CRReportType As DHCMed.CD.CRForm;

/// 报卡状态	(RepStatus：1上报2审核3删除)
Property CRReportStatus As DHCMed.SS.Dictionary;

/// 报告科室
Property CRReportLoc As %String;

/// 报告医生
Property CRReportUser As %String;

/// 报告单位
Property CRReportOrgan As %String;

/// 报告日期
Property CRReportDate As %Date;

/// 报告时间
Property CRReportTime As %Time;

/// 修改人
Property CRUpdateUser As %String;

/// 修改日期
Property CRUpdateDate As %Date;

/// 修改时间
Property CRUpdateTime As %Time;

/// 审核标志
Property CRCheckFlag As %Boolean;

/// 审核人
Property CRCheckUser As %String;

/// 审核日期
Property CRCheckDate As %Date;

/// 审核时间
Property CRCheckTime As %Time;

/// 导出标志
Property CRExportFlag As %Boolean;

/// 导出人
Property CRExportUser As %String;

/// 导出日期
Property CRExportDate As %Date;

/// 导出时间
Property CRExportTime As %Time;

/// 备注信息
Property CRResume As %String(MAXLEN = 200);

/// 退回原因
Property CRDelReason As %String;

Index IndexEpisodeID On CREpisodeID;

Index IndexDateLoc On (CRReportDate, CRReportLoc);

// w ##class(DHCMed.CD.CRReport).%BuildIndices()

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReport
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReport).%ExistsId(+id) return
	set obj=##Class(DHCMed.CD.CRReport).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CREpisodeID_separete
	Set return=return_..CRReportType_separete	//1
	Set return=return_..CRReportStatus_separete
	
	Set ReportLocID=..CRReportLoc
	set DescStr=$p($g(^CTLOC(+ReportLocID)),"^",2)
	set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	if (Languages="EN"){
		Set DescStr = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,DescStr)
	}else{
		Set DescStr = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","EN",DescStr)
	}
	
	Set return=return_ReportLocID_separete_DescStr_separete	//3
	
	Set ReportUser=..CRReportUser
	Set ReportType=..CRReportType
	// 肿瘤卡存得时用户ID，其余是描述
	if ((ReportUser'="")&&(ReportType.CRFCode="ZLK")){
		set objReportUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
		if ($IsObject(objReportUser)){
			if (Languages="EN"){
				Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,objReportUser.Name)
			}else{
				Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTCareProv","CTPCPDesc","EN",objReportUser.Name)
			}
			set ReportUserDesc=objReportUser.Rowid_","_RepUserName
		}else{
			set ReportUserDesc=""
		}
	}else{
		if (Languages="EN"){
			Set ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,ReportUser)
		}else{
			Set ReportUser = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTCareProv","CTPCPDesc","EN",ReportUser)
		}
		Set ReportUserDesc = ReportUser
	}
	set return=return_ReportUserDesc_separete	//9
	if (Languages="EN"){
		Set ReportOrgan = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,..CRReportOrgan)
	}else{
		Set ReportOrgan = ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTHospital","HOSPDesc","EN",..CRReportOrgan)
	}
	Set return=return_ReportOrgan_separete	//6
	
	Set ReportDate=..CRReportDate
	;set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set return=return_ReportDate_separete
	
	Set ReportTime=..CRReportTime
	set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	Set return=return_ReportTime_separete
	
	Set UpdateUser=..CRUpdateUser
	Set UpdateUserDesc = ""
	if (UpdateUser'=""){
		set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+UpdateUser)
		if ($IsObject(objUser)){
			set UpdateUserDesc=objUser.Name
		}else{
			set UpdateUserDesc=""
		}
	}
	set return=return_UpdateUserDesc_separete	//9
	
	Set return=return_..CRUpdateDate_separete
	Set return=return_..CRUpdateTime_separete
	Set return=return_..CRCheckFlag_separete
	Set return=return_..CRCheckUser_separete
	Set return=return_..CRCheckDate_separete
	Set return=return_..CRCheckTime_separete
	Set return=return_..CRExportFlag_separete
	Set return=return_..CRExportUser_separete
	Set return=return_..CRExportDate_separete
	Set return=return_..CRExportTime_separete
	Set return=return_..CRResume_separete
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).GetStringById(1)
ClassMethod GetStringById(id As %String) As %String
{
	new (id,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCMed.CD.CRReport).GetObjById(+id)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReport).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set ID=$p(aInput,separete,1)
	If (ID="") {
		Set obj=##class(DHCMed.CD.CRReport).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReport).%OpenId(+ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CREpisodeID=$p(aInput,separete,2)
	Set RepTypeCode=$p(aInput,separete,3)
	Set obj.CRReportType=##class(DHCMed.CD.CRForm).GetObjByCode(RepTypeCode)
	Set ReportStatus=$p(aInput,separete,4)
	Set obj.CRReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",ReportStatus,1)
	Set obj.CRReportLoc=$p(aInput,separete,5)
	Set obj.CRReportUser=$p(aInput,separete,6)
	Set obj.CRReportOrgan=$p(aInput,separete,7)
	Set RReportDate=$p(aInput,separete,8)
	;Set:RReportDate["-" RReportDate=$zdh(RReportDate,3)
	Set:RReportDate'="" RReportDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RReportDate)
	Set obj.CRReportDate=RReportDate
	Set obj.CRReportTime=$p($h,",",2)	//$p(aInput,separete,9)
	Set obj.CRUpdateUser=$p(aInput,separete,10)
	Set obj.CRUpdateDate=+$H			//$p(aInput,separete,11)
	Set obj.CRUpdateTime=$p($h,",",2)	//$p(aInput,separete,12)
	Set obj.CRCheckFlag=$p(aInput,separete,13)
	Set obj.CRCheckUser=$p(aInput,separete,14)
	Set obj.CRCheckDate=$p(aInput,separete,15)
	Set obj.CRCheckTime=$p(aInput,separete,16)
	Set obj.CRExportFlag=$p(aInput,separete,17)
	Set obj.CRExportUser=$p(aInput,separete,18)
	Set obj.CRExportDate=$p(aInput,separete,19)
	Set obj.CRExportTime=$p(aInput,separete,20)
	Set obj.CRResume=$p(aInput,separete,21)
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-28
/// Description:  审核报告
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).CheckReport(1)
ClassMethod CheckReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.CRReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",ReportStatus,1)
	Set obj.CRCheckFlag=1
	Set obj.CRCheckUser=$p(aInput,separete,3)
	Set obj.CRCheckDate=+$H
	Set obj.CRCheckTime=$p($H,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_""
		Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-28
/// Description:  打印、导出报告
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).PrintReport(1)
ClassMethod ExportReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set obj.CRExportFlag=1
	Set obj.CRExportUser=$p(aInput,separete,2)
	Set obj.CRExportDate=+$H
	Set obj.CRExportTime=$p(+$H,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.CRReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,2)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-28
/// Description:  删除报告
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).DeleteReport(1)
ClassMethod DeleteReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.CRReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",ReportStatus,1)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.CRReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,5)
		Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenr
/// CreatDate：   2020-02-24
/// Description:  取消审核
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).CanCheckReport(1)
ClassMethod CanCheckReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.CRReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",ReportStatus,1)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.CRReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,5)
		Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenr
/// CreatDate：   2022-03-29
/// Description:  退回报告
/// Table：       DHCMed.CD.CRReport
/// Input：       ID:    DHCMed.CD.CRReport.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReport).ReturnReport(1)
ClassMethod ReturnReport(aInput As %String, separete As %String, aReason As %String) As %String
{
	new (aInput,separete,aReason)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.CD.CRReport).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.CRReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("CRReportStatus",ReportStatus,1)
	Set obj.CRDelReason = aReason
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.CRReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,5)
		Set retlog=##class(DHCMed.CD.CRReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CREpisodeID</Value>
</Value>
<Value name="3">
<Value>CRReportType</Value>
</Value>
<Value name="4">
<Value>CRReportStatus</Value>
</Value>
<Value name="5">
<Value>CRReportLoc</Value>
</Value>
<Value name="6">
<Value>CRReportUser</Value>
</Value>
<Value name="7">
<Value>CRReportOrgan</Value>
</Value>
<Value name="8">
<Value>CRReportDate</Value>
</Value>
<Value name="9">
<Value>CRReportTime</Value>
</Value>
<Value name="10">
<Value>CRUpdateUser</Value>
</Value>
<Value name="11">
<Value>CRUpdateDate</Value>
</Value>
<Value name="12">
<Value>CRUpdateTime</Value>
</Value>
<Value name="13">
<Value>CRCheckFlag</Value>
</Value>
<Value name="14">
<Value>CRCheckUser</Value>
</Value>
<Value name="15">
<Value>CRCheckDate</Value>
</Value>
<Value name="16">
<Value>CRCheckTime</Value>
</Value>
<Value name="17">
<Value>CRExportFlag</Value>
</Value>
<Value name="18">
<Value>CRExportUser</Value>
</Value>
<Value name="19">
<Value>CRExportDate</Value>
</Value>
<Value name="20">
<Value>CRExportTime</Value>
</Value>
<Value name="21">
<Value>CRResume</Value>
</Value>
<Value name="22">
<Value>CRDelReason</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CD.CRReportD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CD.CRReportD</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
