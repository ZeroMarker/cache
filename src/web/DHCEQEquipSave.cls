Class web.DHCEQEquipSave Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 125;

// 台帐查询保存

/// Modified by jdl 2013-7-16 JDL0133 优化台帐导出效率，增加参数每次获取行数信息
/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetList(node As %Library.String = "", job, gnum, rows As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s str=^DHCEQTemp("EquipList",curuser,job,gnum)       //Modified by JYP0019 台账添加job对多用户进行限制
	s str=^DHCEQTemp("EquipList",+$h,job,curuser,gnum)       //modify by lmm 2020-05-09
	if rows'=""
	{
		for i=1:1:rows-1
		{
			//modify by lmm 2020-05-09
			//s str=str_$c(2)_^DHCEQTemp("EquipList",curuser,job,gnum+i)        //Modified by JYP0019 台账添加job对多用户进行限制
			s str=str_$c(2)_^DHCEQTemp("EquipList",+$h,job,curuser,gnum+i)        //modify by lmm 2020-05-09
		}
	}
 	//s str=^DHCEQTemp("Equip",+$H,$j,gnum)
  	q str
}

/// Modified by jdl 2011-10-28 JDL0099 与web.DHCEQCommon统一方法参数
ClassMethod GetNum(node As %Library.String = "", job)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s gnum=$o(^DHCEQTemp("EquipList",curuser,job,""),-1)       //Modified by JYP0019 台账添加job对多用户进行限制
	s gnum=$o(^DHCEQTemp("EquipList",+$h,job,curuser,""),-1)       //modify by lmm 2020-05-09
 	//s gnum=$o(^DHCEQTemp("Equip",+$H,$j,""),-1)
  	q gnum
}

/// Modified by JYP0019 台账添加job对多用户进行限制
/// Modified by ZY0198 修改附属设备台账显示规则
/// 创建：zc0037 2018-09-30
/// 描述：hisui改造在jQuery页面标签显示合计信息
/// 输入：node：临时global的节点名称 
/// 输出：台账合计信息
/// Modified by WY 2022-3-31 WY0099增加入参vType 0或"" 设备台帐，1简易台帐
/// w ##Class(web.DHCEQEquipSave).GetEquipSumInfo()
ClassMethod GetEquipSumInfo(node As %Library.String = "", Ejob As %Library.String = "", vType As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	//add by zx 2019-06-11 附属设备数量合计处理 增加变量ConfigCount
	s (Count,TotalFee,TotalNetFee,TotalDepreFee,ConfigCount)=0
	s nrowid=0
	//Begin Modified by JYP0019 台账添加job对多用户进行限制
	//modify by lmm 2020-05-09
	//f  s nrowid=$o(^DHCEQTemp("EquipList",curuser,Ejob,nrowid)) q:nrowid=""  d
	f  s nrowid=$o(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)) q:nrowid=""  d
	.q:$p($g(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)),"^",64)=""  //add by zx 2019-07-24 合计行RowID为空,此处不作计算
	.//Modified by ZY0198 修改附属设备台账显示规则,附属设备不统计
	.i $p($g(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)),"^",87)="Y"  d
	..s ConfigCount=ConfigCount+1
	.e  d
	..s Count=Count+1
	..;add by zx 2019-06-14 调整台账合计显示 Bug ZX0067
	..s TotalFee=TotalFee+$p($g(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)),"^",22)
	..s TotalNetFee=TotalNetFee+$p($g(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)),"^",23)
	..s TotalDepreFee=TotalDepreFee+$p($g(^DHCEQTemp("EquipList",+$h,Ejob,curuser,nrowid)),"^",29)
	//End Modified by JYP0019 台账添加job对多用户进行限制
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	s TotalNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
	s TotalDepreFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreFee,"")
  	s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;原值:"_TotalFee_"&nbsp;&nbsp;&nbsp;净值:"_TotalNetFee_"&nbsp;&nbsp;&nbsp;累计折旧:"_TotalDepreFee
  	i ##class(web.DHCEQCommon).GetSysInfo("990079")=1 s info=info_"&nbsp;&nbsp;&nbsp;附属:"_ConfigCount		// Mozy003002	2020-03-18	附属设备统计信息
  	if vType=1 s info="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;原值:"_TotalFee
  	q info
}

}
