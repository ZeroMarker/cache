Import SQLUser

Class web.DHCVISWarning Extends %RegisteredObject
{

/// YangJia2020-01-15
/// 基础数据维护楼层
ClassMethod InsertFloor(FloorCode As %String = "", FloorName As %String = "")
{
    q:(FloorCode="")||(FloorName="") "入参不完整,所有填写数据均不能为空"
    q:$O(^DHCVISFloori(0,"FloorName",FloorName,""),-1)'="" "此楼层已存在!"
    s DHCVISFloorObj=##class(User.DHCVISFloor).%New()
	s DHCVISFloorObj.VISFloorCode=FloorCode
	s DHCVISFloorObj.VISFloorName=FloorName
	s FloorId=DHCVISFloorObj.%Save()
	d DHCVISFloorObj.%Close()
	i $$$ISERR(FloorId)
	{
		d $System.Status.DisplayError(FloorId)
	}else{
		s FloorId="0"
	}
	q FloorId
}

ClassMethod UpdateFloor(RowId As %String = "", FloorCode As %String = "", FloorName As %String = "")
{
    q:RowId="" "请选中需要更新的记录"
	q:(RowId="")||(FloorCode="")||(FloorName="") "入参不完整,所有填写数据均不能为空"
    s DHCVISFloorObj=##class(User.DHCVISFloor).%OpenId(RowId)
	i FloorCode'="" s DHCVISFloorObj.VISFloorCode=FloorCode
	i FloorName'="" s DHCVISFloorObj.VISFloorName=FloorName
	s FloorId=DHCVISFloorObj.%Save()
	d DHCVISFloorObj.%Close()
	i $$$ISERR(FloorId)
	{
		d $System.Status.DisplayError(FloorId)
	}else{
		s FloorId="0"
	}
	q FloorId
}

ClassMethod DeleteFloor(RowId As %String = "")
{
	q:RowId="" "请选中需要删除的记录"
	&SQL(delete DHC_VIS_Floor where VIS_FloorId=:RowId)
	q SQLCODE
}

/// 基础数据维护楼号
ClassMethod InsertBuilding(BuildCode As %String = "", BuildName As %String = "")
{
    q:(BuildCode="")||(BuildName="") "入参不完整,所有填写数据均不能为空"
    q:$O(^DHCVISBuildi(0,"BuildName",BuildName,""),-1)'="" "此楼号已存在!"
    s DHCVISBuildObj=##class(User.DHCVISBuilding).%New()
	s DHCVISBuildObj.VISBuildCode=BuildCode
	s DHCVISBuildObj.VISBuildName=BuildName
	s BuildId=DHCVISBuildObj.%Save()
	d DHCVISBuildObj.%Close()
	i $$$ISERR(BuildId)
	{
		d $System.Status.DisplayError(BuildId)
	}else{
		s BuildId="0"
	}
	q BuildId
}

ClassMethod UpdateBuilding(RowId As %String = "", BuildCode As %String = "", BuildName As %String = "")
{
    q:RowId="" "请选中需要更新的记录"
	q:(RowId="")||(BuildCode="")||(BuildName="") "入参不完整,所有填写数据均不能为空"
    s DHCVISBuildObj=##class(User.DHCVISBuilding).%OpenId(RowId)
	i BuildCode'="" s DHCVISBuildObj.VISBuildCode=BuildCode
	i BuildName'="" s DHCVISBuildObj.VISBuildName=BuildName
	s BuildId=DHCVISBuildObj.%Save()
	d DHCVISBuildObj.%Close()
	i $$$ISERR(BuildId)
	{
		d $System.Status.DisplayError(BuildId)
	}else{
		s BuildId="0"
	}
	q BuildId
}

ClassMethod DeleteBuilding(RowId As %String = "")
{
	q:RowId="" "请选中需要删除的记录"
	&SQL(delete DHC_VIS_Building where VIS_BuildId=:RowId)
	q SQLCODE
}

/// 基础数据维护诊区
ClassMethod InsertClinical(ClinicalCode As %String = "", ClinicalName As %String = "")
{
    q:(ClinicalCode="")||(ClinicalName="") "入参不完整,所有填写数据均不能为空"
    q:$O(^DHCVISClinicali(0,"ClinicalName",ClinicalName,""),-1)'="" "此诊区已存在!"
    s DHCVISClinicalObj=##class(User.DHCVISClinical).%New()
	s DHCVISClinicalObj.VISClinicalCode=ClinicalCode
	s DHCVISClinicalObj.VISClinicalName=ClinicalName
	s ClinicalId=DHCVISClinicalObj.%Save()
	d DHCVISClinicalObj.%Close()
	i $$$ISERR(ClinicalId)
	{
		d $System.Status.DisplayError(ClinicalId)
	}else{
		s ClinicalId="0"
	}
	q ClinicalId
}

ClassMethod UpdateClinical(RowId As %String = "", ClinicalCode As %String = "", ClinicalName As %String = "")
{
    q:RowId="" "请选中需要更新的记录"
	q:(RowId="")||(ClinicalCode="")||(ClinicalName="") "入参不完整,所有填写数据均不能为空"
    s DHCVISClinicalObj=##class(User.DHCVISClinical).%OpenId(RowId)
	i ClinicalCode'="" s DHCVISClinicalObj.VISClinicalCode=ClinicalCode
	i ClinicalName'="" s DHCVISClinicalObj.VISClinicalName=ClinicalName
	s ClinicalId=DHCVISClinicalObj.%Save()
	d DHCVISClinicalObj.%Close()
	i $$$ISERR(ClinicalId)
	{
		d $System.Status.DisplayError(ClinicalId)
	}else{
		s ClinicalId="0"
	}
	q ClinicalId
}

ClassMethod DeleteClinical(RowId As %String = "")
{
	q:RowId="" "请选中需要删除的记录"
	&SQL(delete DHC_VIS_Clinical where VIS_ClinicalId=:RowId)
	q SQLCODE
}

/// 基础数据维护诊室
ClassMethod InsertRoom(RoomCode As %String = "", RoomName As %String = "")
{
    q:(RoomCode="")||(RoomName="") "入参不完整,所有填写数据均不能为空"
    q:$O(^DHCVISRoomi(0,"RoomName",RoomName,""),-1)'="" "此诊间已存在!"
    s DHCVISRoomObj=##class(User.DHCVISRoom).%New()
	s DHCVISRoomObj.VISRoomCode=RoomCode
	s DHCVISRoomObj.VISRoomName=RoomName
	s RoomId=DHCVISRoomObj.%Save()
	d DHCVISRoomObj.%Close()
	i $$$ISERR(RoomId)
	{
		d $System.Status.DisplayError(RoomId)
	}else{
		s RoomId="0"
	}
	q RoomId
}

ClassMethod UpdateRoom(RowId As %String = "", RoomCode As %String = "", RoomName As %String = "")
{
    q:RowId="" "请选中需要更新的记录"
	q:(RowId="")||(RoomCode="")||(RoomName="") "入参不完整,所有填写数据均不能为空"
    s DHCVISRoomObj=##class(User.DHCVISRoom).%OpenId(RowId)
	i RoomCode'="" s DHCVISRoomObj.VISRoomCode=RoomCode
	i RoomName'="" s DHCVISRoomObj.VISRoomName=RoomName
	s RoomId=DHCVISRoomObj.%Save()
	d DHCVISRoomObj.%Close()
	i $$$ISERR(RoomId)
	{
		d $System.Status.DisplayError(RoomId)
	}else{
		s RoomId="0"
	}
	q RoomId
}

ClassMethod DeleteRoom(RowId As %String = "")
{
	q:RowId="" "请选中需要删除的记录"
	&SQL(delete DHC_VIS_Room where VIS_RoomId=:RowId)
	q SQLCODE
}

/// 预警信息维护
ClassMethod InsertWarning(WarnComputerName As %String = "", WarnHospitalId As %String = "", WarnBuildId As %String = "", WarnFloorId As %String = "", WarnClinicalId As %String = "", WarnRoomId As %String = "", WarnLocId As %String = "", WarnSendAddress As %String = "", WarnSendToComputerName As %String = "")
{
    s ^YJ("InsertWarning")=$LB(WarnComputerName,WarnHospitalId, WarnBuildId, WarnFloorId, WarnClinicalId, WarnRoomId, WarnLocId, WarnSendAddress,WarnSendToComputerName)
    q:(WarnComputerName="")||(WarnHospitalId="")||(WarnBuildId="")||(WarnFloorId="")||(WarnClinicalId="") "入参不完整,所有填写数据均不能为空"
    q:(WarnRoomId="")||(WarnLocId="")||(WarnSendAddress="")||(WarnSendToComputerName="") "入参不完整,所有填写数据均不能为空"
    s WarnComputerName=$tr($$upper^SSUTIL4(WarnComputerName)," ")
    s WarnSendToComputerName=$tr($$upper^SSUTIL4(WarnSendToComputerName)," ")
    q:$O(^DHCVISWarni(0,"WarnComputerName",WarnComputerName,""),-1)'="" "此客户端已存在!"
    s DHCVISWarnObj=##class(User.DHCVISWarning).%New()
	s DHCVISWarnObj.VISWarnComputerName=WarnComputerName
	s DHCVISWarnObj.VISWarnHospitalId=WarnHospitalId
	s DHCVISWarnObj.VISWarnBuildId=WarnBuildId
	s DHCVISWarnObj.VISWarnFloorId=WarnFloorId
	s DHCVISWarnObj.VISWarnClinicalId=WarnClinicalId
	s DHCVISWarnObj.VISWarnRoomId=WarnRoomId
	s DHCVISWarnObj.VISWarnLocId=WarnLocId
	s DHCVISWarnObj.VISWarnSendAddress=WarnSendAddress
	s DHCVISWarnObj.VISWarnSendToComputerName=WarnSendToComputerName
	s WarnId=DHCVISWarnObj.%Save()
	d DHCVISWarnObj.%Close()
	i $$$ISERR(WarnId)
	{
		d $System.Status.DisplayError(WarnId)
	}else{
		s WarnId="0"
	}
	q WarnId
}

ClassMethod UpdateWarning(RowId As %String = "", WarnComputerName As %String = "", WarnHospitalId As %String = "", WarnBuildId As %String = "", WarnFloorId As %String = "", WarnClinicalId As %String = "", WarnRoomId As %String = "", WarnLocId As %String = "", WarnSendAddress As %String = "", WarnSendToComputerName As %String = "")
{
    q:RowId="" "请选中需要更新的记录"
	s ^YJ("UpdateWarning")=$LB(WarnComputerName,WarnHospitalId, WarnBuildId, WarnFloorId, WarnClinicalId, WarnRoomId, WarnLocId, WarnSendAddress,WarnSendToComputerName)
	q:(RowId="")||(WarnComputerName="")||(WarnHospitalId="")||(WarnBuildId="")||(WarnFloorId="")||(WarnClinicalId="")||(WarnRoomId="")||(WarnLocId="")||(WarnSendAddress="")||(WarnSendToComputerName="") "入参不完整,所有填写数据均不能为空"
    s WarnId=$O(^DHCVISWarni(0,"WarnComputerName",WarnComputerName,""),-1)
    q:(WarnId'=RowId)&(WarnId'="") "此电脑名已存在不允许修改电脑名"
    i WarnComputerName'="" s WarnComputerName=$tr($$upper^SSUTIL4(WarnComputerName)," ")
    i WarnSendToComputerName'="" s WarnSendToComputerName=$tr($$upper^SSUTIL4(WarnSendToComputerName)," ")
    s DHCVISWarnObj=##class(User.DHCVISWarning).%OpenId(RowId)
	i WarnComputerName'="" s DHCVISWarnObj.VISWarnComputerName=WarnComputerName
	i WarnHospitalId'="" s DHCVISWarnObj.VISWarnHospitalId=WarnHospitalId
	i WarnBuildId'="" s DHCVISWarnObj.VISWarnBuildId=WarnBuildId
	i WarnFloorId'="" s DHCVISWarnObj.VISWarnFloorId=WarnFloorId
	i WarnClinicalId'="" s DHCVISWarnObj.VISWarnClinicalId=WarnClinicalId
	i WarnRoomId'="" s DHCVISWarnObj.VISWarnRoomId=WarnRoomId
	i WarnLocId'="" s DHCVISWarnObj.VISWarnLocId=WarnLocId
	i WarnSendAddress'="" s DHCVISWarnObj.VISWarnSendAddress=WarnSendAddress
	i WarnSendToComputerName'="" s DHCVISWarnObj.VISWarnSendToComputerName=WarnSendToComputerName
	s WarnId=DHCVISWarnObj.%Save()
	d DHCVISWarnObj.%Close()
	i $$$ISERR(WarnId)
	{
		d $System.Status.DisplayError(WarnId)
	}else{
		s WarnId="0"
	}
	q WarnId
}

ClassMethod DeleteWarning(RowId As %String = "")
{
	q:RowId="" "请选中需要删除的记录"
	&SQL(delete DHC_VIS_Warn where VIS_WarnId=:RowId)
	q SQLCODE
}

/// 导入程序入口
ClassMethod ImportData(typeFlag As %String = "", data1 As %String = "", data2 As %String = "", data3 As %String = "", data4 As %String = "", data5 As %String = "", data6 As %String = "", data7 As %String = "", data8 As %String = "", data9 As %String = "", num As %String = "")
{
	q:(typeFlag="")||(data1="")||(data2="") "0^0"
	s ImportIndex=$I(^ImportData(+$H,typeFlag,"ImportData"))
	s ret=""
	s ^DHCVISWarnImport(+$h,"ImportData",ImportIndex)=$lb(typeFlag,data1,data2,data3,data4,data5,data6,data7,data8,data9)
	i (typeFlag="Floor") d
	.s ret=..InsertFloor(data1,data2)
	i (typeFlag="Build") d
	.s ret=..InsertBuilding(data1,data2)
	i (typeFlag="Clinical") d
	.s ret=..InsertClinical(data1,data2)
	i (typeFlag="Room") d
	.s ret=..InsertRoom(data1,data2)
	i (typeFlag="Warn") d
	.s ret=..ImportWarning(data1,data2,data3,data4,data5,data6,data7,data8,data9)
	q:(ret'=0) "-1^第"_num_"行数据有误 "_ret
	q "0^0"
}

/// 导入报警客户端
ClassMethod ImportWarning(WarnComputerName As %String = "", WarnHospitalName As %String = "", WarnBuildName As %String = "", WarnFloorName As %String = "", WarnClinicalName As %String = "", WarnRoomName As %String = "", WarnLocName As %String = "", WarnSendAddress As %String = "", WarnSendToComputerName As %String = "")
{
    q:(WarnComputerName="")||(WarnHospitalName="")||(WarnBuildName="")||(WarnFloorName="")||(WarnClinicalName="") "入参不完整"
    q:(WarnRoomName="")||(WarnLocName="")||(WarnSendAddress="")||(WarnSendToComputerName="") "入参不完整"
    s WarnHospitalName=$$ALPHAUP^SSUTIL4(WarnHospitalName)
    s WarnHospitalId=$O(^CT("HOSP",0,"Desc",WarnHospitalName,""),-1)
    s WarnBuildId=$O(^DHCVISBuildi(0,"BuildName",WarnBuildName,""),-1)
    s WarnFloorId=$O(^DHCVISFloori(0,"FloorName",WarnFloorName,""),-1)
    s WarnClinicalId=$O(^DHCVISClinicali(0,"ClinicalName",WarnClinicalName,""),-1)
    s WarnRoomId=$O(^DHCVISRoomi(0,"RoomName",WarnRoomName,""),-1)
    i WarnLocName'="" s WarnLocName=$$upper^SSUTIL4(WarnLocName)
    s WarnLocId=$O(^CTLOC(0,"Desc",WarnLocName,""),-1)
    s WarnComputerName=$$upper^SSUTIL4(WarnComputerName)
    s WarnSendToComputerName=$$upper^SSUTIL4(WarnSendToComputerName)
    q:$O(^DHCVISWarni(0,"WarnComputerName",WarnComputerName,""),-1) "此客户端已存在"
    i WarnSendToComputerName["，" s WarnSendToComputerName=$tr(WarnSendToComputerName," ，",",")
    q:WarnHospitalId="" "院区信息有误!"
    q:WarnBuildId="" "楼宇信息有误!"
    q:WarnFloorId="" "楼层信息有误!"
    q:WarnClinicalId="" "诊区信息有误!"
    q:WarnRoomId="" "房间信息有误!"
    q:WarnLocId="" "科室信息有误!"
    s insertFlag="Y"
    i (WarnHospitalId="")||(WarnBuildId="")||(WarnFloorId="")||(WarnClinicalId="")||(WarnRoomId="")||(WarnLocId="") d
    .s insertFlag="N"
    .s ^ImportWarning(+$h,"YJErr",WarnComputerName)=$lb(WarnComputerName,WarnHospitalName,WarnBuildName,WarnFloorName,WarnClinicalName,WarnRoomName,WarnLocName,WarnSendAddress,WarnSendToComputerName)
    q:insertFlag'="Y" "参数有误"
    s DHCVISWarnObj=##class(User.DHCVISWarning).%New()
	s DHCVISWarnObj.VISWarnComputerName=WarnComputerName
	s DHCVISWarnObj.VISWarnHospitalId=WarnHospitalId
	s DHCVISWarnObj.VISWarnBuildId=WarnBuildId
	s DHCVISWarnObj.VISWarnFloorId=WarnFloorId
	s DHCVISWarnObj.VISWarnClinicalId=WarnClinicalId
	s DHCVISWarnObj.VISWarnRoomId=WarnRoomId
	s DHCVISWarnObj.VISWarnLocId=WarnLocId
	s DHCVISWarnObj.VISWarnSendAddress=WarnSendAddress
	s DHCVISWarnObj.VISWarnSendToComputerName=WarnSendToComputerName
	s WarnId=DHCVISWarnObj.%Save()
	d DHCVISWarnObj.%Close()
	i $$$ISERR(WarnId)
	{
		d $System.Status.DisplayError(WarnId)
	}else{
		s WarnId="0"
	}
	q WarnId
}

/// 清除配置数据谨慎操作
/// w ##class(web.DHCVISWarning).DeleteWarnData()
ClassMethod DeleteWarnData()
{
	&SQL(delete from DHC_VIS_Room)
	&SQL(delete from DHC_VIS_Floor)
	&SQL(delete from DHC_VIS_Building)
	&SQL(delete from DHC_VIS_Clinical)
	&SQL(delete from DHC_VIS_Warn)
	q ""
}

/// 清除业务数据谨慎操作
/// w ##class(web.DHCVISWarning).DeleteWarnMessage()
ClassMethod DeleteWarnMessage()
{
	&SQL(delete from DHC_VIS_VoiceMessage)
	q ""
}

/// w ##class(web.DHCVISWarning)GetImportPath()
ClassMethod GetImportPath()
{
	//下载路径设置
	//路径为服务器实际路径
	//s ^DHCVISWarn("ImportWarn","http")="D:/dthealth/app/dthis/web/dhcvis"
	s path=$g(^DHCVISWarn("ImportWarn","http"))
	s systemVesion=$zv
	i systemVesion["Linux" s path="/dthealth/app/dthis/med/Results/Template/dhcvis"
	q path
}

}
