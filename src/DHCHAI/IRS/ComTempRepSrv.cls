/// 名称: DHCHAI.IRS.ComTempRepSrv
/// 描述: 公共模板相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-10-24
Class DHCHAI.IRS.ComTempRepSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-10-24
/// Description:  查询扩展表明细
/// Table：       DHCHAI.IR.ComTempRep
/// Input:        报告ID
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ComTempRepSrv","QryExpExtInfo","1")
Query QryExpExtInfo(aRepID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,Code:%String,Desc:%String,ItemDesc:%String,DataType:%String,ResultID:%String,ResultCode:%String,ResultDesc:%String,ResultList:%String,ResultListCode:%String,ResultListDesc:%String,ResultTxt:%String,ActDate:%String,ActTime:%String,ActUserID:%String,ActUserCode:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryExpExtInfoExecute(ByRef qHandle As %Binary, aRepID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aRepID="" $$$OK
	
	Set xSubID = ""
	For {
		Set xSubID =$o(^MA.HAI.IR.ComTempRepI("IndexComRelateDr",aRepID,xSubID))
		Quit:xSubID=""
		
		Set ComData=$g(^MA.HAI.IR.ComTempRepD(xSubID))
		Continue:ComData=""
		
		Set ComItemDr = $li(ComData,4)
		Set ItemData  = $g(^CT.MA.HAI.IR.ComTemplateDefD($p(ComItemDr,"||",1),"EXT",$p(ComItemDr,"||",2)))
		Set Code      = $li(ItemData,2)
		Set Desc      = $li(ItemData,3)
		Set ItemDesc  = $li(ComData,5)
		Set DataType  = $li(ComData,6)  
		Set ResultID  = $li(ComData,7)
		Set ResultCode="",ResultDesc=""
		If ResultID'="" {
			Set ResultData = $g(^DHCHAI.BT.DictionaryD(ResultID))
			If (ResultData'=""){
				Set ResultCode = $li(ResultData,2)
				Set ResultDesc = $li(ResultData,3)
			}
		}
		Set ResultList = $li(ComData,8)
		Set ResultListID="",ResultListCode="",ResultListDesc=""
		For indx = 1:1:$ll(ResultList){
			Set RstIDs  = $li(ResultList,indx)
			Set RstID   = $li(RstIDs,1)
			Set RstData = $g(^DHCHAI.BT.DictionaryD(RstID))
			If (RstData'=""){
				Set ListCode = $li(RstData,2)
				Set ListDesc = $li(RstData,3)
			}
			Set ResultListID=ResultListID_","_RstID
			Set ResultListCode=ResultListCode_","_ListCode
			Set ResultListDesc=ResultListDesc_","_ListDesc
		} 
		Set:ResultListID'="" ResultListID=$e(ResultListID,2,$l(ResultListID))
		Set:ResultListCode'="" ResultListCode=$e(ResultListCode,2,$l(ResultListCode))
		Set:ResultListDesc'="" ResultListDesc=$e(ResultListDesc,2,$l(ResultListDesc))
		
		Set ResultTxt  = $li(ComData,9)
		Set ActDate	   = $li(ComData,10)
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)  	  
		Set ActTime	   = $li(ComData,11)
		Set:ActTime'="" ActTime=$zt(ActTime,1)	  
		Set ActUserID = $li(ComData,12) 
        Set ActUserCode="",ActUserDesc=""
		If ActUserID'="" {
			Set UserData = $g(^DHCHAI.BT.SysUserD(ActUserID))
			If (UserData'=""){
				Set ActUserCode = $li(UserData,2)
				Set ActUserDesc = $li(UserData,3)
			}
		}	   	
	
		Set Data=$lb(aRepID,xSubID,Code,Desc,ItemDesc,DataType,ResultID,ResultCode,ResultDesc,ResultListID,ResultListCode,ResultListDesc,ResultTxt,ActDate,ActTime,ActUserID,ActUserCode,ActUserDesc)  
	    Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryExpExtInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryExpExtInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpExtInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
