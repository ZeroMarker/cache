/// 未审核申请单信息
Class web.DHCBldActAppFormUncheck Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S locID=$g(request.Data("locID",1))
	S userCode=$g(request.Data("userCode",1))
	S userGroupID=$g(request.Data("userGroupID",1))
	K ^TMP($zn,$j)
    S appFormInfo=##class(web.DHCBldAppForm).GetAllUncheckAppFormByLoc(locID,userCode,userGroupID)
    S tDeli=$C(2)
    //'rowid','patAdmID','patName','statusCode','statusDesc','applyDate','applyUser','remark'
    S ^TMP($zn,$j,0)="rowid"_tDeli_"patAdmID"_tDeli_"patName"_tDeli_"statusCode"_tDeli_"statusDesc"_tDeli_"applyDate"_tDeli_"applyUserCode"_tDeli_"applyUserDesc"_tDeli_"remark"_tDeli_"formType"
    S index=1
    F i=1:1:$l(appFormInfo,$C(2)) {
	    S fieldVals=$TR($P(appFormInfo,$C(2),i),$C(3),$C(2))
	    I $l(fieldVals) {
		    S ^TMP($zn,$j,index)=fieldVals ,index=index+1
		}
		
	}
	S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
	S ret=jsonStr
	w ret
	
	Q ret
}

Parameter ActionID = "BLD.APPFORM.HISTORY";

Parameter Version = "1.0.0.1";

}
