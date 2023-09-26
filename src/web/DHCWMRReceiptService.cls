Import SQLUser

Class web.DHCWMRReceiptService Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

//Create By LiYang 2009-4-2

//复兴需求：

//病案历史数据不全，导入后，有部分Medtrak中的就诊未导入，且未将papmi与MrMain建立关联。造成的问题是：1、住院次数统计不准确；2、可能有一些病案号的分配有问题。

//计划在住院登记接诊时，先检查历次paadm，如果发现存在未接诊的paadm（卷信息中不存在且历史卷信息中无当天的记录），先接诊（状态设置为工作流程的最后一个状态），累计住院次数。

//增加设置，通过状态判断该病案类型在接诊时是否需要先处理历史paadm，处理那类paadm（O、I、E）。

//运行命令参考：w ##class(web.DHCWMRReceiptService).DataImport("I",7,2040)

//

//

//参数：AdmType：paadm的类型I，O，E

//      MrType:病案类型RowID

//      UserID：接诊用户的RowID

ClassMethod DataImport(AdmType, MrType, UserID)
{
		n (AdmType, MrType)
		s cnt=0
		s StatusDr=..GetWorkFlow(MrType)
		q "没有找到对应的流程项目~~~~~"
		s admID=""  f  s admID=$o(^PAADMi("PAADM_Type",AdmType,admID)) q:(admID="")!(cnt>100)  d
		.i $d(^DHCWMRVOL(0,"VolAdm",admID))=0  d
		..w !,"处理Paadm"_admID
		..s result=..Receipt(MrType,admID,StatusDr,UserID)
		..i result<0  d
		...w "    失败，错误代码："_result
		..e  d
		...w "    成功！" 
		..s cnt=cnt+1  //<-------------------------------正式运行时将此行注释掉！！！！
		..w !,cnt
		q "完成啦~"
}

ClassMethod ErrorHandle(paadm)
{
		w !,paadm
		q 0
}

//获取最后一个流项目

ClassMethod GetWorkFlow(MrType)
{
    n (MrType)
    s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
    s ItemDr=""
    q:sFlow="" ItemDr
    s sTmp=$p(sFlow,$c(1),$l(sFlow,$c(1)))
    s ItemDr=$p(sTmp,"^",3)
    q ItemDr
}

ClassMethod Receipt(MrType, admID, Status, UserId)
{
	n (MrType,admID, Status,UserId)
	q:admID="" -1
	s adm=$g(^PAADM(admID)) 
	q:adm="" -2
	s PatientID=$p(adm,"^",1)
	q:$d(^DHCWMRMAIN(0,"PAPMI",PatientID))=0 -3 //没有找到匹配的病案记录
	s result=-3.1
	s MainID=""  f  s MainID=$o(^DHCWMRMAIN(0,"PAPMI",PatientID,MainID)) q:MainID=""  d
	.s Main=$g(^DHCWMRMAIN(MainID))
	.q:($p(Main,"^",1)'=MrType)!($p(Main,"^",6)="N") //非活动或者类型不对
	.s result=$$CreateVol(MainID,PatientID,admID,Status,UserId)
	q result
	
CreateVol(MainRowid,papmi,paadm,ItemDr,UserId)
	n (MainRowid,papmi,paadm,ItemDr,UserId)
	Tstart
	s ret=-3
	//建立卷
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=..GetIPCount("",MainRowid)
	s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	q:+VolRowid<0 ret

	s ret=-4
	;生成卷就诊列表信息   DHC_WMR_VolAdm
	s sVolAdm=""
    s $p(sVolAdm,"^",1)=VolRowid
    s $p(sVolAdm,"^",3)=paadm
	s VolAdmRowid=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
	i +VolAdmRowid<0 TRollBack
	q:+VolAdmRowid<0 ret
	
	s ret=-5
	;生成卷状态信息   DHC_WMR_VolStatus
	s sVolStatus=""
	s $p(sVolStatus,"^",1)=VolRowid
	s $p(sVolStatus,"^",3)=ItemDr
	s $p(sVolStatus,"^",4)=UserId
	s $p(sVolStatus,"^",7)=UserId
	s VolStatusRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sVolStatus)
	i +VolStatusRowid<0 TRollBack
	q:+VolStatusRowid<0 ret
	
	s ret=-6
	;生成卷信息   DHC_WMR_VolInfo
	s sVolInfo=##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(papmi,"")
	s $p(sVolInfo,"^",3)=""  //NameSpell
	s $p(sVolInfo,"^",26)=VolRowid
	s VolInfoRowid=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(sVolInfo)
	i +VolInfoRowid<0 TRollBack
	q:+VolInfoRowid<0 ret	

	q VolRowid
}

/// 取住院次数
/// w ##Class(web.DHCWMRReceipt).GetIPCount(IPCount,MainRowid)
ClassMethod GetIPCount(IPCount, MainRowid)
{
    n (IPCount,MainRowid)
    if +IPCount>0 d      ;如果录入第几次住院，取录入的数据
    .s IPCount=+IPCount
    e  d
    .;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})   ;未录入，且无历史，默认为首次住院
    .if '$d(^DHCWMRVOL(0,"Main",+MainRowid)) s IPCount=1
    .e  d
    ..s VolRowid=0,IPCount=0      ;未录入，取所有卷中第一次住院中最大数，加1
    ..f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid))  q:VolRowid=""  d
    ...s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    ...q:Active'="Y"
    ...s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    ...s:IPCount<Count IPCount=Count
    ..s IPCount=IPCount+1
    
    q IPCount
}

}
