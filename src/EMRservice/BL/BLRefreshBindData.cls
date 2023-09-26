Class EMRservice.BL.BLRefreshBindData Extends %RegisteredObject
{

/// Creator:    DongLulu
/// CreateDate: 2016-06-13
/// Desc:       存病历的InstanceID和是否弹出提示框的状态SyncDialogVisible
/// Input:      InstanceID: 当前病历InstanceID
///             SyncDialogVisible：是否弹出提示框 True/False
/// return:     
/// Debug:  	d ##Class(EMRservice.BL.BLRefreshBindData).InputData("279||629","True")
ClassMethod InputData(InstanceID As %String, SyncDialogVisible As %String) As %String
{
	q:((InstanceID = "")||(SyncDialogVisible = ""))
	s objRefBindDataID = ""
	s objRefBindDataID = $o(^DHCEMRI.plugin.RefreshBindDataI("IdxInstanceID"," "_InstanceID,objRefBindDataID))	
    if (objRefBindDataID = "")
    {
	    s objRefBindData = ##Class(EMRinstance.plugin.RefreshBindData).%New()
	    s objRefBindData.InstanceID = InstanceID 
    }
    else
    {
	    s objRefBindData = ##Class(EMRinstance.plugin.RefreshBindData).%OpenId(objRefBindDataID)
	    q:(objRefBindData = "")
    }
    s objRefBindData.SyncDialogVisible = SyncDialogVisible
    d objRefBindData.%Save()
    d objRefBindData.%Close()	
	k objRefBindData
	q ""
}

/// Creator:    DongLulu
/// CreateDate: 2016-06-13
/// Desc:       获取该病历的是否弹出提示框的状态SyncDialogVisible
/// Input:      InstanceID 
/// return:     SyncDialogVisible 是否弹出绑定数据提示框
/// 								  True:弹出提示框 / False：不弹出提示框
/// Debug:	   d ##Class(EMRservice.BL.BLRefreshBindData).getBindDataSyncDialogVisible("279||629")
ClassMethod getBindDataSyncDialogVisible(InstanceID As %String = "") As %String
{
	s SyncDialogVisible = "True"
	q:(InstanceID = "") SyncDialogVisible
	s objRefBindDataID = ""
	s objRefBindDataID = $o(^DHCEMRI.plugin.RefreshBindDataI("IdxInstanceID"," "_InstanceID,objRefBindDataID))	
    if (objRefBindDataID '= "")
    {
	    s objRefBindData = ##Class(EMRinstance.plugin.RefreshBindData).%OpenId(objRefBindDataID)
	    q:(objRefBindData = "") 
	    s SyncDialogVisible = objRefBindData.SyncDialogVisible
    }
    q SyncDialogVisible
}

}
