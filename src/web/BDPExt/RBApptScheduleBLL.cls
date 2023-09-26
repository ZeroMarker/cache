/// 名称: 排班导入
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2020-12-30
Class web.BDPExt.RBApptScheduleBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 排班导入
/// 实体类： web.BDPExt.RBApptScheduleEntity
/// CreateDate: 2020-12-30
/// Creator:   chenying
/// Table:
/// Debug:     w ##class(web.BDPExt.RBApptScheduleBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.RBApptScheduleEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	//安全组ID1	科室名称2	号别代码3	号别名称4	出诊日期5	时段6	挂号职称7	亚专业8	诊室9	正号限额10	预约限额	加号限额	预约起始号	分时段就诊	开始时间	结束时间	间隔分钟	时段号数	预约方式信息（方式|限额|起始号）
	s liststr=Ceobj.GroupID_"^"_Ceobj.LocDesc_"^"_Ceobj.RESCode_"^"_Ceobj.RESDesc_"^"_Ceobj.ScheduleDate
	s liststr=liststr_"^"_Ceobj.TRDesc_"^"_Ceobj.SessionTypeDesc_"^"_Ceobj.CLGRPDesc_"^"_Ceobj.RoomDesc_"^"_Ceobj.SessLoad
	s liststr=liststr_"^"_Ceobj.SessNoApptSlot_"^"_Ceobj.AddtionMax_"^"_Ceobj.SessNumberOfWeeks_"^"_Ceobj.TRFlag_"^"_Ceobj.TRStartTime
	s liststr=liststr_"^"_Ceobj.TREndTime_"^"_Ceobj.TRLength_"^"_Ceobj.TTrtemName_"^"_Ceobj.AppMethodStr
	s ExpStr=Ceobj.LinkHospId 
	//s ^tmpcy("web.BDPExt.RBApptScheduleBLL")=liststr_","_ExpStr
	Ts
	s ret=##Class(DHCDoc.Interface.Outside.ImportData.RBASApptSchedule).ImportRBApptScheduleData(liststr,ExpStr)
	s flag=$p(ret,"^",1)
	if (flag<0)
	{
		s msg=$p(ret,"^",2)
		s ImportResult= "{success:'false',info:'"_msg_"！'}" 
	}
	
	if (ImportResult="")
	{
		Tc
		s rowid=$p(ret,"^",2)
		s JsonStr="{""GroupID"":"""_Ceobj.GroupID_""",""RowId"":"""_rowid_""",""LocDesc"":"""_Ceobj.LocDesc_""",""RESCode"":"""_Ceobj.RESCode_""",""RESDesc"":"""_Ceobj.RESDesc_""",""ScheduleDate"":"""_Ceobj.ScheduleDate_""",""TRDesc"":"""_Ceobj.TRDesc_""",""SessionTypeDesc"":"""_Ceobj.SessionTypeDesc_""",""CLGRPDesc"":"""_Ceobj.CLGRPDesc_""",""RoomDesc"":"""_Ceobj.RoomDesc_""",""SessLoad"":"""_Ceobj.SessLoad_""",""SessNoApptSlot"":"""_Ceobj.SessNoApptSlot_""",""AddtionMax"":"""_Ceobj.AddtionMax_""",""SessNumberOfWeeks"":"""_Ceobj.SessNumberOfWeeks_""",""TRFlag"":"""_Ceobj.TRFlag_""",""TRStartTime"":"""_Ceobj.TRStartTime_""",""TREndTime"":"""_Ceobj.TREndTime_""",""TRLength"":"""_Ceobj.TRLength_""",""TTrtemName"":"""_Ceobj.TTrtemName_""",""AppMethodStr"":"""_Ceobj.AppMethodStr_"""}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("RB_ApptSchedule","User.RBApptSchedule","排班导入",rowid,Ceobj.LocDesc_"-"_Ceobj.RESDesc,"A",JsonStr)
		s ImportResult="{success:'true',id:'"_rowid_"'}" 
	}
	else
	{
		Tro	
	}
	q ImportResult
ERROR
	Q "导入报错"_$ZE
}

}
