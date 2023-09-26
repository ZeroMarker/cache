/// 名称: 排班模板导入
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2018-11-25
Class web.BDPExt.RBResEffDateSessionBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 排班模板导入
/// 实体类： web.BDPExt.RBResEffDateSessionEntity
/// CreateDate: 2018-11-25
/// Creator:   chenying
/// Table:RB_ResEffDate,RB_ResEffDateSession,DHC_RBResEffDateSessAppQty
/// Debug:     w ##class(web.BDPExt.RBResEffDateSessionBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.RBResEffDateSessionEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	//班次1	科室名称2	号别代码3	号别名称4	出诊时间(星期)5	时段6	挂号职称7	亚专业8	诊室9	正号限额10	预约限额	加号限额	预约起始号	分时段就诊	开始时间	结束时间	间隔分钟	时段号数	预约方式信息（方式|限额|起始号）  医院
	s liststr=Ceobj.RSLDesc_"^"_Ceobj.LocDesc_"^"_Ceobj.RESCode_"^"_Ceobj.RESDesc_"^"_Ceobj.WeekNum
	s liststr=liststr_"^"_Ceobj.TRDesc_"^"_Ceobj.SessionTypeDesc_"^"_Ceobj.CLGRPDesc_"^"_Ceobj.RoomDesc_"^"_Ceobj.SessLoad
	s liststr=liststr_"^"_Ceobj.SessNoApptSlot_"^"_Ceobj.AddtionMax_"^"_Ceobj.SessNumberOfWeeks_"^"_Ceobj.TRFlag_"^"_Ceobj.TRStartTime
	
	s liststr=liststr_"^"_Ceobj.TREndTime_"^"_Ceobj.TRLength_"^"_Ceobj.TTrtemName_"^"_Ceobj.AppMethodStr
	s ExpStr=Ceobj.LinkHospId  //2020-06-13入参增加医院
	//s ^tmpcy("web.BDPExt.RBResEffDateSessionBLL")=liststr
	///"通用班次^120急救中心^cy^陈莹^2^上午^普通号^^zs^40^40^5^1^Y^8:00^12:00^60^^窗口预约|20|1&电话预约|20|21^2",2
	Ts
	//s ret= ##class(DHCDoc.DHCDocCure.RBCResPlan).ImportRBResSessData(liststr,ExpStr)  //>0 - rowid,<0 - 失败
	s ret= ##class(DHCDoc.Interface.Outside.ImportData.RBASTemplate).ImportRBResSessData(liststr,ExpStr)  //20200623调用新接口
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
		s JsonStr="{RSLDesc:"""_Ceobj.RSLDesc_""",LocDesc:"""_Ceobj.LocDesc_""",RESCode:"""_Ceobj.RESCode_""",RESDesc:"""_Ceobj.RESDesc_""",WeekNum:"""_Ceobj.WeekNum_""",TRDesc:"""_Ceobj.TRDesc_""",RoomDesc:"""_Ceobj.RoomDesc_""",SessLoad:"""_Ceobj.SessLoad_""",SessNoApptSlot:"""_Ceobj.SessNoApptSlot_""",AddtionMax:"""_Ceobj.AddtionMax_""",SessNumberOfWeeks:"""_Ceobj.SessNumberOfWeeks_""",TRFlag:"""_Ceobj.TRFlag_""",TRStartTime:"""_Ceobj.TRStartTime_""",TREndTime:"""_Ceobj.TREndTime_""",TRLength:"""_Ceobj.TRLength_""",TRRegNum:"""_Ceobj.TRRegNum_""",AppMethodStr:"""_Ceobj.AppMethodStr_"""}"     
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("RB_ResEffDateSession","User.RBResEffDateSession","排班模板",rowid,Ceobj.LocDesc_"-"_Ceobj.RESDesc,"A",JsonStr)
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

/// Creator:陈莹
/// CreatDate:2020-04-14
/// Description:新装排班模板时，要清掉排班模板原来的global
/// Table:RB_ResEffDate,RB_ResEffDateSession,DHC_RBResEffDateSessAppQty
/// Other:d ##class(web.BDPExt.RBResEffDateSessionBLL).ClearData()
ClassMethod ClearData()
{
	n
	s RESRowId=0
	for
	{
		s RESRowId=$o(^RB("RES",RESRowId))  q:RESRowId=""
		s DATEChildsub=0
		for
		{
			s DATEChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildsub))  q:DATEChildsub=""
			s SESSChildsub=0
			for
			{
				s SESSChildsub=$o(^RB("RES",RESRowId,"DATE",DATEChildsub,"SESS",SESSChildsub))  q:SESSChildsub=""
				S RowId=RESRowId_"||"_DATEChildsub_"||"_SESSChildsub
				d ##class(User.RBResEffDateSession).%DeleteId(RowId)
			}
			d ##class(User.RBResEffDate).%DeleteId(RESRowId_"||"_DATEChildsub)
		}
		k ^RB("RES",RESRowId,"DATE")  //RB_ResEffDate,RB_ResEffDateSession
		k ^RB("RES",RESRowId,"Date")  //DHC_RBResEffDateSessAppQty
	}
}

}
