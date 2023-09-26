/// 名称: web.DHCEQ.Plat.BussWarnDays
/// 描述: 业务预警设置
/// 编写者：MZY
/// 编写日期: 2020-05-15
/// 产品组：设备管理
Class web.DHCEQ.Plat.BussWarnDays Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:MZY 2020-05-15
/// 目的:保存预警设置
/// 输入: Data:机型名称 ItemDR:设备项rowid
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
ClassMethod SaveData(data)
{
	s $ZT="ERRORBussWarnDays"
	k PLIST,RowID
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBussWarnDays",JsonData,.PLIST)
	s RowID = JsonData.%Get("BWDRowID")
	
	s PLIST(10) = User				;BWD_UpdateUserDR
	s PLIST(11) = Date				;BWD_UpdateDate
	s PLIST(12) = Time				;BWD_UpdateTime
	s PLIST(13) = "N"				;BWD_InvalidFlag
	i (PLIST(8)'="")&&(PLIST(5)>PLIST(8)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-100, "日期设置异常!")	// MZY0072	1797924		2021-04-19
 	TSTART
	if RowID'=""
	{
		&SQL(Update SQLUSER.DHC_EQBussWarnDays Values :PLIST() where BWD_RowID = :RowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBussWarnDays Values :PLIST())
		Set RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORBussWarnDays
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:删除
/// w ##Class(web.DHCEQ.Plat.BussWarnDays).DeleteData()
ClassMethod DeleteData(RowID As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
	Set $ZT="ERRORDelete"
	TSTART		
	
	&SQL(update sqluser.DHC_EQBussWarnDays set BWD_InvalidFlag='Y' where BWD_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORDelete
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.Plat.BussWarnDays).GetOneBussWarnDays(75,"94-1",4)
ClassMethod GetOneBussWarnDays(SourceType As %Library.String = "", SubType As %Library.String = "", BussID As %Library.String = "")
{
	s $ZT="ERRORGetOneBussWarnDays"
	// BWD_RowID	BWD_SourceType	BWD_SubType	BWD_SourceID	BWD_WarnDay	BWD_WarnDaysNum	BWD_OverDueDaysNum	BWD_EndDay
	// BWD_Remark	BWD_UpdateUserDR	BWD_UpdateDate	BWD_UpdateTime	BWD_InvalidFlag
	// BWD_Hold1	BWD_Hold2	BWD_Hold3	BWD_Hold4	BWD_Hold5
	s RowID=$o(^DHCEQBussWarnDays(0,"SourceType","N",SourceType,SubType,BussID, ""))
	i RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, "")
	
	s ObjBussWarnDays=##Class(User.DHCEQBussWarnDays).%OpenId(RowID)
	s BussWarnDaysInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjBussWarnDays)
	d BussWarnDaysInfo.%Set("BWDRowID", RowID)
	// MZY0095	2021-09-15
	d BussWarnDaysInfo.%Set("BWDSourceType_Desc", ##class(web.DHCEQFind).GetBussTypeDesc(ObjBussWarnDays.BWDSourceType))
	d BussWarnDaysInfo.%Set("BWDSubType_Desc", ##class(web.DHCEQFind).GetBussTypeDesc(ObjBussWarnDays.BWDSubType))
		 
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, BussWarnDaysInfo)
ERRORGetOneBussWarnDays
	Set ErrorMsg=$ZE
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// MZY0072	1798336		2021-04-19
/// SourceType	预警类型:
/// 						11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用
/// 						51设备调帐 52设备台帐 61工程管理 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书
/// 						64租赁 65配送 66发票 67公告 71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期 74租赁预警
/// 						75采购合同到货 76计划付款 81维修监控 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
/// 						96产品 A01配件入库 A02配件转移 A03配件退货 A04配件减少
/// SubType		业务类型
/// BussID		来源ID
/// IncludeFlag:是否包含无效资金类型	0:不包含  其他:包含
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组
/// Flag=0可以显示
/// 需要加条件的地方加入q:(##Class(web.DHCEQ.Plat.BussWarnDays).BussWarnDayIsIn(SType,BType,BID))即可
/// w ##Class(web.DHCEQ.Plat.BussWarnDays).BussWarnDayIsIn(75,"94-1",58)
ClassMethod BussWarnDayIsIn(SourceType As %Library.String = "", SubType As %Library.String = "", BussID As %Library.String = "", WarnDaysNum As %Library.String = "30")
{
	n Flag,RowID,WarnDay,EndDay,OverDueDaysNum
	Set Flag=0
	s RowID=$o(^DHCEQBussWarnDays(0,"SourceType","N",SourceType,SubType,BussID, ""))
	s CurDate=+$H
	i RowID=""
	{
		i SourceType'=75 q 1
		i $p($g(^DHCEQContractList(BussID)),"^",10)="" s Flag=1
		i ($p($g(^DHCEQContractList(BussID)),"^",10)-WarnDaysNum)>CurDate s Flag=1
		i $p($g(^DHCEQContractList(BussID)),"^",10)<CurDate s Flag=1
	}
	else
	{
		s EndDay=$p($g(^DHCEQBussWarnDays(RowID)),"^",7)		;完成日期(终止预警)
		i (EndDay'="")&&(CurDate>EndDay) q 1
		s WarnDay=$p($g(^DHCEQBussWarnDays(RowID)),"^",4)
		i WarnDay="" q 1
		i $p($g(^DHCEQBussWarnDays(RowID)),"^",5)'="" s WarnDaysNum=$p($g(^DHCEQBussWarnDays(RowID)),"^",5)
		i (WarnDay-WarnDaysNum)>CurDate s Flag=1
		s OverDueDaysNum=$p($g(^DHCEQBussWarnDays(RowID)),"^",6)		;超期警告天数		!!!空：一直预警!!!
		i (WarnDay+OverDueDaysNum)<CurDate s Flag=1
	}
	Quit Flag
}

/// 描述:业务单结束预警设置
/// w ##Class(web.DHCEQ.Plat.BussWarnDays).SetEndDay()
ClassMethod SetEndDay(SourceType As %Library.String = "", SubType As %Library.String = "", BussID As %Library.String = "")
{
	s RowID=$o(^DHCEQBussWarnDays(0,"SourceType","N",SourceType,SubType,BussID, ""))
	i RowID="" Quit 0
	
	s Date=+$H
	&SQL(update sqluser.DHC_EQBussWarnDays set BWD_EndDay=:Date where BWD_RowID=:RowID)
	Quit SQLCODE
}

}
