/// 自定义Html标签
Class CIS.AN.COM.Html Extends %RegisteredObject
{

Parameter LibPath = "../service/dhcanop/";

/// dhcclinic:easyui
ClassMethod Easyui()
{
	set debug=0
    set hisuiPath="../service/dhcanop/lib/hisui/dist/"
    ;write "<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/easyui.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/icon.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.easyui.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/easyui-lang-zh_cn.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhccl.framework.js"" ></script>"
    Set Ver = ##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")
    if (Ver="lite")
    {
	    //极简
	    write "<link rel=""stylesheet"" type=""text/css"" href="""_hisuiPath_"css/hisui.lite.css"" />"
	}
	else
	{
		//炫彩
		write "<link rel=""stylesheet"" type=""text/css"" href="""_hisuiPath_"css/hisui.css"" />"
	}
    
    if (debug)
    {
	    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.js"" ></script>"
	    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.cookie.min.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.js"" ></script>"
	}
    else
    {
		write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.min.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.min.js"" ></script>"    
	}
    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/locale/hisui-lang-zh_CN.js"" ></script>"
}

/// dhcclinic:head
ClassMethod Head()
{
    set locId=%session.Get("LOGON.CTLOCID")
    set locDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",locId)
    set deptId=locId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",locId)
    set deptDesc=locDesc //##class(CIS.AN.COM.String).GetDescByID("CF.AN.Department","Description",deptId)
    
    
    
    set userId=%session.Get("LOGON.USERID")
    set careProvId=##class(CIS.AN.BL.Admission).GetCareProv(userId)
    set careProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",careProvId)
    set SSUserId=userId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.SSUser",userId)
    //set SSUser=##class(User.SSUser).%OpenId(SSUserId) //##class(CF.AN.SSUser).%OpenId(SSUserId)
    set SSUserDesc="",ANCareProvId="",SSUserCode=""
    &sql(select SSUSR_Name,SSUSR_Initials,SSUSR_CareProv_DR into :SSUserDesc,:SSUserCode,:ANCareProvId from SQLUser.SS_User where %ID=:SSUserId)
    //set:(SSUser'="") SSUserDesc=SSUser.SSUSRName,SSUserCode=SSUser.SSUSRInitials
    //set:(SSUser'="")&($isobject(SSUser.SSUSRCareProvDR)) ANCareProvId=SSUser.SSUSRCareProvDR.%Id()
    
    set groupId=%session.Get("LOGON.GROUPID")
    set groupDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSGroup","SSGRPDesc",groupId)
    set SSGroupId=groupId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.SSGroup",groupId)
    //set SSGroup=##class(CF.AN.SSGroup).%OpenId(SSGroupId)
    set SSGroupDesc=groupDesc //SSGroup.Description
    //set SSGroupDesc=##class(CIS.AN.COM.String).GetDescByID("CF.AN.SSGroup","Description",groupId)
    
    set hospId=%session.Get("LOGON.HOSPID")
    set hospName=##class(CIS.AN.BL.Admission).GetHospital(hospId)
    set ANHospId=hospId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Hospital",hospId)
    //set ANHosp=##class(CF.AN.Hospital).%OpenId(ANHospId)
    set ANHospDesc=hospName  //ANHosp.Description
    set ANHosp=""
    //set ANHospDesc=##class(CIS.AN.COM.String).GetDescByID("CF.AN.Hospital","Description",hospId)
    
    set moduleCode=%request.Get("moduleCode")
    set menuCode=%request.Get("menuCode")
    set opsId=%request.Get("opsId")
    set opaId=%request.Get("opaId")
    if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
    {
		set opsId=##class(CIS.AN.SRV.OperService).GetOpsIdByExt(opaId)    
	}
	set:(opaId="") opaId=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(opsId)
    set EpisodeID=%request.Get("EpisodeID")
    set recordSheetId=%request.Get("recordSheetId")
    set:(recordSheetId="") recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,SSUserId)
    //set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,SSUserId)
    set moduleID=##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
    set moduleDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.DataModule","Description",moduleID)
    
    set %session.Data("AN.ModuleID")=moduleID
    set clientIP=$System.Process.ClientIPAddress()
    set dateFormat=##class(web.DHCClinicCom).GetDateFormat()
    set archiveServerIP=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerIP")
    set archiveServerPort=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerPort")
    set canEdit=##class(CIS.AN.BL.RecordSheet).CanEdit(recordSheetId,userId)
    
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/iconan.css"" />"
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    write !,"<script type=""text/javascript"" src=""../scripts/websys.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.Constant.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.DateTime.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.Framework.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CIS.AN.SystemConfig.js"" ></script>"
    ;d ##class(CA.DigitalSignatureService).OutPutSecXCommon()
    write !,"<script type=""text/javascript"">"
    write !,"   var session={};"
    write !,"   session.UserID="""_SSUserId_""";"
    write !,"   session.UserName="""_SSUserDesc_""";"
    write !,"   session.UserCode="""_SSUserCode_""";"
    
    write !,"   session.ExtUserID="""_%session.Get("LOGON.USERID")_""";"
    write !,"   session.ExtUserName="""_%session.Get("LOGON.USERNAME")_""";"
    write !,"   session.ExtUserCode="""_%session.Get("LOGON.USERCODE")_""";"
    
    write !,"   session.CareProvID="""_ANCareProvId_""";"
    write !,"   session.CareProvDesc="""_careProvDesc_""";"
    write !,"   session.ExtCareProvID="""_careProvId_""";"
    
    write !,"   session.DeptID="""_deptId_""";"
    write !,"   session.DeptDesc="""_deptDesc_""";"
    write !,"   session.ExtDeptID="""_%session.Get("LOGON.CTLOCID")_""";"
    write !,"   session.ExtDeptDesc="""_locDesc_""";"
    
    write !,"   session.GroupID="""_SSGroupId_""";"
    write !,"   session.GroupDesc="""_SSGroupDesc_""";"
    write !,"   session.ExtGroupID="""_%session.Get("LOGON.GROUPID")_""";"
    write !,"   session.ExtGroupDesc="""_%session.Get("LOGON.GROUPDESC")_""";"
    
    write !,"   session.HospID="""_ANHospId_""";"
    write !,"   session.HospDesc="""_ANHospDesc_""";"
    write !,"   session.ExtHospID="""_%session.Get("LOGON.HOSPID")_""";"
    write !,"   session.ExtHospDesc="""_hospName_""";"
    
    write !,"   session.TimeOut="""_%session.Get("LOGON.TIMEOUT")_""";"
    write !,"   session.EpisodeID="""_EpisodeID_""";"
    write !,"   session.OPSID="""_opsId_""";"
    
    write !,"   session.RecordSheetID="""_recordSheetId_""";"
    write !,"   session.ModuleID="""_moduleID_""";"
    write !,"   session.ModuleCode="""_moduleCode_""";"
    write !,"   session.ModuleDesc="""_moduleDesc_""";"
    write !,"   session.ClientIP="""_clientIP_""";"
    write !,"   session.MenuCode="""_menuCode_""";"
    write !,"   session.DateFormat="""_dateFormat_""";"
    write !,"   session.ArchiveServerIP="""_archiveServerIP_""";"
    write !,"   session.ArchiveServerPort="""_archiveServerPort_""";"
    write !,"   session.Editable="_$s(canEdit="N":"false",1:"true")_";"
    write !,"</script>"
}

ClassMethod HISUI()
{
	set debug=0
    set hisuiPath="../lib/hisui/dist/"
    ;write "<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/easyui.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/icon.css"" />"
    ;write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.easyui.min.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/easyui-lang-zh_cn.js"" ></script>"
    ;write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhccl.framework.js"" ></script>"
    
    write "<link rel=""stylesheet"" type=""text/css"" href="""_hisuiPath_"css/hisui.css"" />"
    if (debug)
    {
	    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.js"" ></script>"
	}
    else
    {
		write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery-1.11.3.min.js"" ></script>"
    	write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/jquery.hisui.min.js"" ></script>"    
	}
    write !,"<script type=""text/javascript"" src="""_hisuiPath_"js/locale/hisui-lang-zh_CN.js"" ></script>"
    
    
    set hisPath="../../.."
    set aisPath="../"
    set locId=%session.Get("LOGON.CTLOCID")
    set locDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",locId)
    set deptId=locId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",locId)
    set deptDesc=locDesc //##class(CIS.AN.COM.String).GetDescByID("CF.AN.Department","Description",deptId)
    
    
    
    set userId=%session.Get("LOGON.USERID")
    set careProvId=##class(CIS.AN.BL.Admission).GetCareProv(userId)
    set careProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",careProvId)
    set SSUserId=userId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.SSUser",userId)
    //set SSUser=##class(User.SSUser).%OpenId(SSUserId) //##class(CF.AN.SSUser).%OpenId(SSUserId)
    set SSUserDesc="",ANCareProvId="",SSUserCode=""
    &sql(select SSUSR_Name,SSUSR_Initials,SSUSR_CareProv_DR into :SSUserDesc,:SSUserCode,:ANCareProvId from SQLUser.SS_User where %ID=:SSUserId)
    //set:(SSUser'="") SSUserDesc=SSUser.SSUSRName,SSUserCode=SSUser.SSUSRInitials
    //set:(SSUser'="")&($isobject(SSUser.SSUSRCareProvDR)) ANCareProvId=SSUser.SSUSRCareProvDR.%Id()
    
    set groupId=%session.Get("LOGON.GROUPID")
    set groupDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSGroup","SSGRPDesc",groupId)
    set SSGroupId=groupId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.SSGroup",groupId)
    //set SSGroup=##class(CF.AN.SSGroup).%OpenId(SSGroupId)
    set SSGroupDesc=groupDesc //SSGroup.Description
    //set SSGroupDesc=##class(CIS.AN.COM.String).GetDescByID("CF.AN.SSGroup","Description",groupId)
    
    set hospId=%session.Get("LOGON.HOSPID")
    set hospName=##class(CIS.AN.BL.Admission).GetHospital(hospId)
    set ANHospId=hospId //##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Hospital",hospId)
    //set ANHosp=##class(CF.AN.Hospital).%OpenId(ANHospId)
    set ANHospDesc=hospName  //ANHosp.Description
    set ANHosp=""
    //set ANHospDesc=##class(CIS.AN.COM.String).GetDescByID("CF.AN.Hospital","Description",hospId)
    
    set moduleCode=%request.Get("moduleCode")
    set menuCode=%request.Get("menuCode")
    set opsId=%request.Get("opsId")
    set opaId=%request.Get("opaId")
    if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
    {
		set opsId=##class(CIS.AN.SRV.OperService).GetOpsIdByExt(opaId)    
	}
	set:(opaId="") opaId=##class(CIS.AN.SRV.OperService).GetOpaIdByOpsId(opsId)
    set EpisodeID=%request.Get("EpisodeID")
    set recordSheetId=%request.Get("recordSheetId")
    set:(recordSheetId="") recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,SSUserId)
    set moduleID=##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
    set moduleDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.DataModule","Description",moduleID)
    set %session.Data("AN.ModuleID")=moduleID
    set clientIP=$System.Process.ClientIPAddress()
    set dateFormat=##class(web.DHCClinicCom).GetDateFormat()
    set archiveServerIP=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerIP")
    set archiveServerPort=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerPort")
    set canEdit=##class(CIS.AN.BL.RecordSheet).CanEdit(recordSheetId,userId)
    
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/iconan.css"" />"
    write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
    write !,"<script type=""text/javascript"" src="""_hisPath_"/scripts/websys.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_aisPath_"js/CIS.AN.Constant.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_aisPath_"js/CIS.AN.DateTime.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_aisPath_"js/CIS.AN.Framework.js"" ></script>"
    write !,"<script type=""text/javascript"" src="""_aisPath_"js/CIS.AN.SystemConfig.js"" ></script>"
    d ##class(CA.DigitalSignatureService).OutPutSecXCommon()
    write !,"<script type=""text/javascript"">"
    write !,"   var session={};"
    write !,"   session.UserID="""_SSUserId_""";"
    write !,"   session.UserName="""_SSUserDesc_""";"
    write !,"   session.UserCode="""_SSUserCode_""";"
    
    write !,"   session.ExtUserID="""_%session.Get("LOGON.USERID")_""";"
    write !,"   session.ExtUserName="""_%session.Get("LOGON.USERNAME")_""";"
    write !,"   session.ExtUserCode="""_%session.Get("LOGON.USERCODE")_""";"
    
    write !,"   session.CareProvID="""_ANCareProvId_""";"
    write !,"   session.CareProvDesc="""_careProvDesc_""";"
    write !,"   session.ExtCareProvID="""_careProvId_""";"
    
    write !,"   session.DeptID="""_deptId_""";"
    write !,"   session.DeptDesc="""_deptDesc_""";"
    write !,"   session.ExtDeptID="""_%session.Get("LOGON.CTLOCID")_""";"
    write !,"   session.ExtDeptDesc="""_locDesc_""";"
    
    write !,"   session.GroupID="""_SSGroupId_""";"
    write !,"   session.GroupDesc="""_SSGroupDesc_""";"
    write !,"   session.ExtGroupID="""_%session.Get("LOGON.GROUPID")_""";"
    write !,"   session.ExtGroupDesc="""_%session.Get("LOGON.GROUPDESC")_""";"
    
    write !,"   session.HospID="""_ANHospId_""";"
    write !,"   session.HospDesc="""_ANHospDesc_""";"
    write !,"   session.ExtHospID="""_%session.Get("LOGON.HOSPID")_""";"
    write !,"   session.ExtHospDesc="""_hospName_""";"
    
    write !,"   session.TimeOut="""_%session.Get("LOGON.TIMEOUT")_""";"
    write !,"   session.EpisodeID="""_EpisodeID_""";"
    write !,"   session.OPSID="""_opsId_""";"
    
    write !,"   session.RecordSheetID="""_recordSheetId_""";"
    write !,"   session.ModuleID="""_moduleID_""";"
    write !,"   session.ModuleCode="""_moduleCode_""";"
    write !,"   session.ModuleDesc="""_moduleDesc_""";"
    write !,"   session.ClientIP="""_clientIP_""";"
    write !,"   session.MenuCode="""_menuCode_""";"
    write !,"   session.DateFormat="""_dateFormat_""";"
    write !,"   session.ArchiveServerIP="""_archiveServerIP_""";"
    write !,"   session.ArchiveServerPort="""_archiveServerPort_""";"
    write !,"   session.Editable="_$s(canEdit="N":"false",1:"true")_";"
    write !,"</script>"
}

/// dhcclinic:ca
ClassMethod CA()
{
	set configId=##class(CIS.AN.CA.SignService).GetDefaultSignConfigId()
	if (##class(CF.AN.CASignConfig).%ExistsId(configId))
	{
		set query=##class(%ResultSet).%New("CIS.AN.CA.SignService:FindCASignScript")
        set sc=query.Execute(configId)
        while(query.%Next())
        {
            set JScriptPath=query.Get("JScriptPath")
            write !,"<script type=""text/javascript"" src="""_JScriptPath_"""></script>"
        }
        
        set obj=##class(CF.AN.CASignConfig).%OpenId(configId)
        set VenderCode=obj.VenderCode
        set SignType=obj.SignType
        write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CA/CIS.AN.CA."_VenderCode_"."_SignType_".js""></script>"
	}
	else
	{
		set VenderCode="Mediway"
        set SignType="Pin"
        write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/CA/CIS.AN.CA."_VenderCode_"."_SignType_".js""></script>"
	}
}

ClassMethod Get(item As %String) As %String
{
	if (##class(%Dictionary.CompiledMethod).%OpenId("locale.Chinese||Get",0))
	{
		return ##class(locale.Chinese).Get(item)
	}
	else
	{
		return item
	}
}

}
