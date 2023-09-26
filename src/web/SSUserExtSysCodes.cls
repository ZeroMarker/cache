/// Aji 9/9/03 - Log Number: 37591
Class web.SSUserExtSysCodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 137;

Parameter SQLDATEFROM = "EXT_DateFrom";

Parameter SQLDATETO = "EXT_DateTo";

Parameter SQLCODE = "EXT_RowId";

Parameter SQLDESCRIPTION = "EXT_RowId";

Parameter SQLROWID = "EXT_RowId";

/// wanghc
/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	i ##class(web.SSUser).IsValidUser(%request.Get("UserCode"),%request.Get("PIN"))>0 q 1
	e  d msg.AddItem("E",$g(t("PIN"),"密码"),"输入错误!",+$e(compref,2,),"PIN") q 0	;用户或密码不正确
}

/// wanghc
ClassMethod websysSaveExtSysCodes(compref As %Library.String, id As %Library.String, PARREF As %Library.String)
{
 n compid,status,new,j,oktosave,save,value,parref,oldval
 s compid=1876,oktosave=1,save=0
 i id'="",'##Class(websys.Lock).Lock($lb(id,"User.SSUserExtSysCodes"),%session.SessionId,%session.Get("LOGON.USERID"),.status) d  q 0
 . d msg.AddItem("E","LOCKED",status,compid) s oktosave=0
 i '##Class(web.SSUserExtSysCodes).websysBeforeSave(compref,.id) q 0
 s new=id=""
 s:id'="" obj=##Class(User.SSUserExtSysCodes).%OpenId(id)
 if id="" d
 . s parref=$g(%request.Data("PARREF",1))
 .s ^Temp("wanghc","parref")=parref
 . i parref="" s obj=##Class(User.SSUserExtSysCodes).%New()
 . i parref'="" s obj=##Class(User.SSUserExtSysCodes).%New(parref) d obj.EXTParRefSetObjectId(parref)
 i $d(%request.Data("EXTCTLOCDR",1)) d
 . s (val,oldval)=$g(%request.Data("EXTCTLOCDR",1)) s:$l($g(val)) val=##Class(web.CTLoc).GetIdFromCodeOrDescription($g(val)) d obj.EXTCTLOCDRSetObjectId($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTCTLOCDR"),"科室"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTCTLOCDR") s oktosave=0
 i $d(%request.Data("EXTChildsub",1)) d
 . s (val,oldval)=$g(%request.Data("EXTChildsub",1)) s obj.EXTChildsub=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTChildsub"),"Childsub"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTChildsub") s oktosave=0
 i $d(%request.Data("EXTCode",1)) d
 . s (val,oldval)=$g(%request.Data("EXTCode",1)) s obj.EXTCode=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTCode"),"代码"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTCode") s oktosave=0
 i $d(%request.Data("EXTDateFrom",1)) d
 . s (val,oldval)=$g(%request.Data("EXTDateFrom",1)) s obj.EXTDateFrom=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTDateFrom"),"开始日期"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTDateFrom") s oktosave=0
 i $d(%request.Data("EXTDateTo",1)) d
 . s (val,oldval)=$g(%request.Data("EXTDateTo",1)) s obj.EXTDateTo=##Class(websys.Conversions).DateHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTDateTo"),"结束日期"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTDateTo") s oktosave=0
 i $d(%request.Data("EXTHospitalDR",1)) d
 . s (val,oldval)=$g(%request.Data("EXTHospitalDR",1)) s val=##class(CTHospital).GetIdFromCodeOrDescription(val) d obj.EXTHospitalDRSetObjectId(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTHospitalDR"),"医院"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTHospitalDR") s oktosave=0
 d
 . s (val,oldval)=$g(%request.Data("EXTDefaultSend",1)) s obj.EXTDefaultSend=##Class(websys.Conversions).YesNoHtmlToLogical($g(val))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTDefaultSend"),"定义为默认发送"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTDefaultSend") s oktosave=0
 i $d(%request.Data("EXTInterface",1)) d
 . s (val,oldval)=$g(%request.Data("EXTInterface",1)) s obj.EXTInterface=$g(val)
 . i oldval'="",val="" d msg.AddItem("E",$g(t("EXTInterface"),"External System"),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTInterface") s oktosave=0
 ;i $d(%request.Data("EXTParRef",1)) d
 ;. s (val,oldval)=$g(%request.Data("EXTParRef",1)) s:$l($g(val)) val=##Class(web.SSUser).GetIdFromCodeOrDescription($g(val)) d obj.EXTParRefSetObjectId($g(val))
 ;. i oldval'="",val="" d msg.AddItem("E",$g(t("EXTParRef"),""),oldval_" "_$g(t("XINVALID")," is invalid"),1876,"EXTParRef") s oktosave=0
 i 'oktosave,'$g(msg.Count("E")),$g(%request.Data("TOVERRIDE",1)) s oktosave=1
 s ^Temp("Upgrade","save^DTGCOM3517.S1.MAC",1)=oktosave
 i oktosave d
 . s save=obj.%Save(0)
 . s ^Temp("Upgrade","save^DTGCOM3517.S1.MAC",2)=$system.Status.GetErrorText(save)
 . i $d(msg) d msg.Status(save,1876)
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""
 s idnew=id
 d:save ##Class(web.SSUserExtSysCodes).websysAfterSave(compref,id,new)
 i 'new d ##Class(websys.Lock).LockClear($lb(id,"User.SSUserExtSysCodes"),%session.SessionId)
 q save
}

Query FindExtCodes(PARREF As %String) As %Library.SQLQuery(ROWSPEC = "id:%String,dateFrom:%Date,dateTo:%Date,code:%String,location:%String,extSystem:%String,defaultSend:%String,hosp:%String")
{
   SELECT EXT_RowId, EXT_DateFrom, EXT_DateTo, EXT_Code, EXT_CTLOC_DR->CTLOC_Desc, EXT_Interface, EXT_DefaultSend,EXT_Hospital_DR->HOSP_Desc
   FROM SQLUser.SS_UserExtSysCodes
   WHERE EXT_ParRef = :PARREF
}

/// wanghc
/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
	i ##class(web.SSUser).IsValidUser(%request.Get("UserCode"),%request.Get("PIN"))>0 d
	.&sql(DELETE FROM SQLUser.SS_UserExtSysCodes WHERE EXT_RowId=:id)
	e  d msg.AddItem("E",$g(t("PIN"),"密码"),"输入错误!",1876,"PIN") q 0	;用户或密码不正确
}

}
