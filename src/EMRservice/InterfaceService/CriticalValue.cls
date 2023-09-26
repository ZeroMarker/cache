/// Desc:       危机值事件接口
/// Creator:    Lina
/// CreateDate: 2019-4-26
Class EMRservice.InterfaceService.CriticalValue Extends %RegisteredObject
{

/// Desc:       根据危急值记录获取所创建危急值病历的创建日期
/// Creator:    Lina
/// CreateTime: 2019-5-5
/// Input：     AEpisodeId 就诊号
///             ALabNo 危急值唯一标示符
/// Debug:      w ##Class(EMRservice.InterfaceService.CriticalValue).GetInstanceCreateDateByLabNo("95336","5||1")
ClassMethod GetInstanceCreateDateByLabNo(AEpisodeId As %String, ALabNo As %String) As %String
{
    s createDate = ""
    q:(AEpisodeId = "")||(ALabNo = "") createDate
    s rowId = $o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIDLabNo"," "_AEpisodeId," "_ALabNo,""))
    q:(rowId = "") createDate
    s InstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_AEpisodeId," "_$zcvt("CriticalValue","U")," "_rowId,""))
    q:(InstanceId = "") createDate
    s tempInstanceId = $tr(InstanceId," ","")
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
    q:($zcvt(objInstance.Status,"U") '= "SAVE") createDate
    s createDate = objInstance.CreateDate
    k objInstance
    q createDate
}

}
