/// 历史申请单信息
Class web.DHCBldActAppFormHistory Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S ret="{'success':"_"true"_",'info':'保存成功'}"
	S regNo=$g(request.Data("regNo",1))
	S patAdmID=$g(request.Data("patAdmID",1))
	
	K ^TMP($zn,$j)
    S appFormInfo=##class(web.DHCBldAppForm).GetPatAllAppForm(regNo,patAdmID)
    S tDeli=$C(2)
    S ^TMP($zn,$j,0)="rowid"_tDeli_"statusCode"_tDeli_"statusDesc"_tDeli_"lastUpdateTime"_tDeli_"orders"_tDeli_"lastUpdateUserCode"_tDeli_"lastUpdateUserDesc"_tDeli_"remark"_tDeli_"appFormType"_tDeli_"details"
    S index=1
    F i=1:1:$l(appFormInfo,$C(2)) {
	    S fieldVals=$TR($P(appFormInfo,$C(2),i),$C(3),$C(2))
	    I $l(fieldVals) {
		    S ^TMP($zn,$j,index)=fieldVals ,index=index+1
		}
		
	}
	S jsonStr=##class(web.Util.DHCLabUtilJSON).GetStoreJsonData($zn,$j,"",tDeli)
	K ^TMP($zn,$j)
	S ret=jsonStr
	w ret
	Q ret
}

Parameter ActionID = "BLD.APPFORM.HISTORY";

Parameter Version = "1.0.0.1";

}
