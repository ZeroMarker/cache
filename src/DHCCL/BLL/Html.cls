Class DHCCL.BLL.Html Extends %RegisteredObject
{

Parameter LibPath = "../service/dhcanop/";

/// dhcclinic:easyui
ClassMethod Easyui()
{
	write "<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/easyui.css"" />"
	write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/icon.css"" />"
	write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.min.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/jquery.easyui.min.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/easyui-lang-zh_cn.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhccl.framework.js"" ></script>"
}

/// dhcclinic:head
ClassMethod Head()
{
	set locId=%session.Get("LOGON.CTLOCID")
	set locDesc=##class(DHCCL.BLL.String).GetDescByID("User.CTLoc","CTLOCDesc",locId)
	set moduleCode=%request.Get("moduleCode")
	set opsId=%request.Get("opsId")
	set recordSheetId=##class(DHCAN.BLL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,%session.Get("LOGON.USERID"))
	set moduleID=##class(DHCAN.BLL.DataModule).GetDataModuleID(moduleCode)
	set userCode=%session.Get("LOGON.USERCODE")
	set careprovID=##class(DHCCL.BLL.Admission).GetCareProvFromCode(userCode)
	set userId=%session.Get("LOGON.USERID")
	set editable=##class(DHCAN.BLL.RecordSheet).CanEdit(recordSheetId,userId)
	set isPrinted="N"
	if recordSheetId'=""
	{
		set recordSheet=##class(DHCAN.Model.RecordSheet).%OpenId(recordSheetId)
		set isPrinted=$s(recordSheet.PrintDate>0:"Y",1:"N")
	}
	write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/iconan.css"" />"
	write !,"<link rel=""stylesheet"" type=""text/css"" href="""_..#LibPath_"css/custom.css"" />"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhcan.constant.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhcan.datetime.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/dhccl.framework.js"" ></script>"
	write !,"<script type=""text/javascript"" src="""_..#LibPath_"js/systemsettings.js"" ></script>"
	write "<script type=""text/javascript"">"
	write !,"	var session={};"
	write !,"	session.UserID="""_%session.Get("LOGON.USERID")_""";"
	write !,"	session.UserName="""_%session.Get("LOGON.USERNAME")_""";"
	write !,"	session.UserCode="""_%session.Get("LOGON.USERCODE")_""";"
	write !,"	session.CareProvID="""_careprovID_""";"
	write !,"	session.DeptID="""_%session.Get("LOGON.CTLOCID")_""";"
	write !,"	session.DeptDesc="""_locDesc_""";"
	write !,"	session.GroupID="""_%session.Get("LOGON.GROUPID")_""";"
	write !,"	session.GroupDesc="""_%session.Get("LOGON.GROUPDESC")_""";"
	write !,"	session.TimeOut="""_%session.Get("LOGON.TIMEOUT")_""";"
	write !,"	session.HospID="""_%session.Get("LOGON.HOSPID")_""";"
	write !,"	session.ModuleCode="""_moduleCode_""";"
	write !,"	session.OPSID="""_opsId_""";"
	write !,"	session.RecordSheetID="""_recordSheetId_""";"
	write !,"	session.ModuleID="""_moduleID_""";"
	write !,"	session.ModuleCode="""_moduleCode_""";"
	write !,"	session.Editable="_$s(editable="Y":"true",1:"false")_";"
	write !,"	session.Printed="_$s(isPrinted="Y":"true",1:"false")_";"
	write !,"</script>"
}

}
