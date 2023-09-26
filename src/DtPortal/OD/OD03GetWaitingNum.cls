Class DtPortal.OD.OD03GetWaitingNum Extends %RegisteredObject
{

/// 名称:DtPortal.OD.OD03GetWaitingNum
/// CreatDate： 2019-01-28
/// Description: 查询检查科室的人数信息
/// Input：          
/// Return： 
/// 服务代码 OD03.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.OD.OD03GetWaitingNum","OD030101","")
Query OD030101(hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "winDesc,outWinDr,waitingNum,locDesc,phLocDr,desc")
{
}

ClassMethod OD030101Execute(ByRef qHandle As %Binary, hospitalId As %String = "") As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

	//Set obj=##class(%ResultSet).%New("web.DHCPHACOM.ComInterface.FaceOutToDHC:GetPhwinWaitNum")
	//调用药库组提供的接口
	Set obj=##class(PHA.FACE.OUT.Com).GetPhwinWaitNum(hospitalId)
	d obj.Execute(hospitalId)
	For  Quit:'obj.Next()  Do
	.;窗口描述，窗口ID，等候数量，药房描述，药房科室ID
	.s (winDesc,outWinDr,waitingNum,locDesc,phLocDr)=""
	.s winDesc=obj.Data("TWinDesc")
	.s outWinDr=obj.Data("TOutWinDr")
	.s waitingNum=obj.Data("TWaitNum")
	.s locDesc=obj.Data("TLocDesc")
	.s phLocDr=obj.Data("TPhLocDr")
	.s desc=locDesc_"-"_winDesc
	.d OD030101
	d obj.Close()
	
	
	q $$$OK
	

  
OD030101
    s Data=$lb(winDesc,outWinDr,waitingNum,locDesc,phLocDr,desc)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
