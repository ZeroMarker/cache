/// 名称:  DtPortal.MD.MD01Focus.MD0102CriticalValue
/// 描述: 查询全院危急值信息
/// 编写者：程鹏
/// 编写日期:2018-12-18
Class DtPortal.MD.MD01Focus.MD0102CriticalValue Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator    :  程鹏
/// date       :  2018-12-18
/// description:  危急值未响应
/// debug      :  w ##class(DtPortal.MD.MD01Focus.MD0102CriticalValue).GetUndoCVNum("")
ClassMethod GetUndoCVNum(HospitalId As %String = "") As %String
{
	set $zt="ErrSendMessage"
	
	
	//取配置,取危急值相应超时时间
	set Undotime=##Class(DtPortal.Common.PublicService).getValueByCode("UNDOCVTIME")
	Set return=0
	
	set num=0
	
	f reporttype=1:1:6
	{
		set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		d obj.Execute(+$h,+$h,"","C","",reporttype)
		
		While (obj.Next()) {
			set AmdLoc=obj.Data("AmdLoc")
			set hospID=$p($g(^CTLOC(AmdLoc)),"^",22)
			i HospitalId'=""  continue:hospID'=HospitalId
			set ReportTime=obj.Data("ReportTime")
			continue:(+$p($h,",",2)-ReportTime)<(Undotime*60)
			set adm=obj.Data("adm")
			continue:adm=""
			set admType=$p($g(^PAADM(adm)),"^",2)
			continue:admType=""
			continue:admType="H"
			Set num=num+1
		}
	}
	
	Quit num
	
ErrSendMessage

	Quit -1
}

}
