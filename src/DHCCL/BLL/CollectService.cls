Class DHCCL.BLL.CollectService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "AnInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://111.111.116.2/Dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 电子病历接口
ClassMethod GetLocOperPatInfo(stdate As %String, enddate As %String, EpisodeID As %String, ctlocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,EpisodeID,ctlocId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-09-13
/// Description： 	保存数据到数据采集记录表中
/// Table：        	DHCAN.Model.CollectData
/// Input：        	opaId手术安排ID,icuaId重症监护安排ID,eqId设备ID,userId;
///                 para：分两级，第一级"^",第二级"#"条记录的数据。
/// 			   	chanalNo_"#"_sttDate_"#"_sttTime_"#"_ancoType(医嘱类型)_"#"_anoQty_"%"_anoQty2_"%"_anoQty3_"#"_ctuomId_"#"_icuoId_"#"_ancvcId_"#"_oeoriId"^"....
/// Output：       
/// Return：       	0-正常，其他-异常返回信息
ClassMethod InsertANOrder(opaId As %String = "", icuaId As %String = "", equipId As %String = "", anoSource As %String = "", userId As %String = "", dataPara As %String = "", status As %String = "", ext1 As %String = "", ext2 As %String = "", ext3 As %String = "") As %String [ WebMethod ]
{
	set $ZT="ERROR"
	
	set userId=""
	set source=anoSource
	set extInfo=userId
	if source="" quit "source is null"
	if equipId="" quit "equipId is null"
	
	set dStr=$zd($p($h,",",1))
	set iDate=+($p(dStr,"/",2))
	set time=$p($h,",",2)
	set hour=time\3600
	set min=(time-(hour*3600))\60
	set sec=time-(hour*3600)-(min*60)
	set i=$O(^DHCCL.CollectDebug("InsertData",equipId,iDate,hour,min,sec,""),-1)+1
	set ^DHCCL.CollectDebug("InsertData",equipId,iDate,hour,min,sec,i)=$zt(time)_"=>"_opaId_","_icuaId_","_equipId_","_source_","_extInfo_","_status_","_dataPara

	set retStr="InvalidSource"
	set retStr=##class(DHCAN.BLL.CollectData).AddData(equipId,dataPara,extInfo)
	set ^DHCCL.CollectDebug("InsertData",equipId,iDate,hour,min,sec,i,"res")=retStr
	quit "<![CDATA["_retStr_"]]>"
ERROR	
	set retStr=$ZERROR
	set ^DHCCL.CollectDebug("InsertData",equipId,iDate,hour,min,sec,i,"res")=retStr
	quit "<![CDATA["_retStr_"]]>"
}

/// 插入手术排班信息
ClassMethod InsertANOpArrange(opaStr As %String, anaStr As %String, anaopStr As %String, assDocStr As %String, arrStr As %String, operStr As %String) As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).InsertAnopApply(opaStr,anaStr,anaopStr,assDocStr,arrStr,operStr)
}

/// 手术排班通用接口
ClassMethod GetANOperation(stdate As %String, enddate As %String, EpisodeID As %String = "", ctlocId As %String = "", opastatus As %String = "", operLocCodeOrDesc As %String = "", opId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,EpisodeID,ctlocId,opastatus,operLocCodeOrDesc,opId)
}

ClassMethod GetANOperCRFInfo(opaId As %String, inputKey As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetAnOpCRFInfo(opaId,inputKey)
}

ClassMethod GetPatInfo(pId As %String = "", type = "") As %String [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetPatInfo(pId,type)
}

/// 获取当日手术间内手术:MD2704.01.01
ClassMethod GetOperDetailsByRoomId(opRoomId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOperDetailsByRoomId(opRoomId)
}

/// 通过手术执行室Id查询当日手术信息:MD2703.01.01
ClassMethod GetOperDetailsByAppLocId(OperLocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOperDetailsBySSSLocId(OperLocId)
}

/// 查询当日手术间占用信息:MD2701.01.01
ClassMethod GetOpRoomStat(hospitalId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetOpRoomStat(hospitalId)
}

/// 查询所有手术室信息:MD2702.01.01
ClassMethod GetAllOperDept(hospitalId As %String = "") As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetAllOperDept(hospitalId)
}

/// +MD2702.01.02+查询某手术室当天手术及手术间情况
ClassMethod GetDeptOperInfo(operCurLocId As %String) As %GlobalCharacterStream [ WebMethod ]
{
	Quit ##class(web.DHCANAdaptor).GetDeptOperInfo(operCurLocId)
}

}
