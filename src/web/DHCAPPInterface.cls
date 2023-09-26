Import SQLUser

Class web.DHCAPPInterface Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:  通过医嘱ID设置检查申请部位执行状态(供PAC组调用)
/// Input:     OrdItem-医嘱ID,PartID-部位ID,ExeStatus-执行状态,userCode-用户工号
/// 		   ExpStr:执行时间^执行科室
/// Output:    0 - 成功；其他 - 失败；(-1:医嘱或执行状态代码为空、-2:工号为空或his中无此用户)
/// w ##Class(web.DHCAPPInterface).SetExaReqExeStatus("178||96","","E","ris")
ClassMethod SetExaReqExeStatus(oeori As %String, PartID As %String, ExStatCode As %String, userCode As %String, ExpStr As %String = "") As %String
{
	n (oeori,PartID,ExStatCode, userCode,ExpStr)
	Q:(oeori="")||(ExStatCode="") "-1"
	s userID=..GetUserID(userCode)
	//Q:userID="" "-2"
	//执行时间
	s ExecuteDateStr=$P(ExpStr,"^",1)
	//执行科室
	s ExecCTLocDr=$P(ExpStr,"^",2)
	s Err=0
	i +PartID'=0  D
	.s Err=..SetExaReqStat(oeori,PartID,ExStatCode,userID,ExpStr)
	E  D
	.s Err=..SetOeoriStat(oeori,ExStatCode,userID)
	b //
	/*/// 登记有部位的检查项目时调用账单程序
	i (+PartID'=0)&(ExStatCode="E") D
	.D ..InvBillNo(oeori,PartID)*/
	Q Err
}

/// Descript:  根据医嘱获取申请单部位表ID
/// ##Class(web.DHCAPPInterface).GetUserID("")
ClassMethod GetUserID(userCode As %String) As %String
{
	n (userCode)
	Q:userCode="" ""
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	Q userID
}

/// Descript:  根据医嘱获取申请单部位表ID
/// ##Class(web.DHCAPPInterface).GetExaReqPartID("")
ClassMethod GetExaReqPartID(Oeori As %String, PartID As %String) As %String
{
	n (Oeori, PartID)
	Q:Oeori="" ""
	/// 检查申请ID
	s ID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))
	Q:ID="" ""
    /// 检查申请医嘱项Child
	s CH=$o(^DHCAPREP(0,"OrdItem",Oeori,ID,""))
	Q:CH="" ""
	/// 检查申请部位表Child
	s Sub=$o(^DHCAPREP(0,"Part",PartID,ID,CH,""))
	Q:Sub="" ""
	s arPartID=ID_"||"_CH_"||"_Sub
	Q arPartID
}

/// Descript:  设置检查申请部位执行状态
/// 			ExpStr:执行时间^执行科室
ClassMethod SetExaReqStat(oeori As %String, PartID As %String, ExStatCode As %String, userID As %String, ExpStr As %String = "") As %String
{
	n (oeori, PartID, ExStatCode, userID,ExpStr)
	//执行时间
	s ExecuteDateStr=$P(ExpStr,"^",1)
	//执行科室
	s ExecCTLocDr=$P(ExpStr,"^",2)
	/// 根据医嘱获取申请单部位表ID
	s arPartID=..GetExaReqPartID(oeori,PartID)
	Q:arPartID="" "-11"

	TS
	/// 修改部位执行状态 DHC_AppRepPart->AR_ExeStatus
	s Err=..SetExaReqPartStat(arPartID,ExStatCode)
	i Err'=0 tro
	q:Err'=0 Err

	/// 修改医嘱执行状态 OE_OrdItem->OEORI_ItemStat_DR,并插入医嘱状态变化表OE_OrdStatus
	s OeoriFlag=0
	s oeStatus=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(oeori)    /// 医嘱状态
	s reqFlag=##Class(web.DHCAPPInterface).GetExaReqItmStat(arPartID,"") /// 是否存在已执行部位
	i ((ExStatCode="E")&(oeStatus'="E"))||(reqFlag'=1) D
	.s Err=..SetOeoriStat(oeori,ExStatCode,userID)
	.s OeoriFlag=1
	i Err'=0 tro
	q:Err'=0 Err
	
	/// 修改医嘱执行表状态 
	s Err=..SetOrdExecExt(oeori,PartID,ExStatCode,OeoriFlag,userID,ExecuteDateStr,ExecCTLocDr)
	i Err'=0 tro
	q:Err'=0 Err

	/// 设置打折系数
	s Err=..modTarItmDisc(oeori,PartID,ExStatCode,arPartID)
	i Err'=0 tro
	q:Err'=0 Err
	
	TC
	Q 0
}

/// Descript:  设置医嘱状态
ClassMethod SetOeoriStat(oeori As %String, OeStatus As %String, userID As %String) As %String
{
	n (oeori, OeStatus, userID)
	s OrdStatID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OeStatus),""))
	Q:OrdStatID="" "-1"
	
	Q ##class(appcom.OEOrdItem).UpdateStatus(oeori,userID,OrdStatID,"","")
	/*s CurDate=..%SysDate()   				/// 日期
	s CurTime=..%SysTime()   		/// 时间
	s OrdStatID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OeStatus),""))
	Q:OrdStatID="" "-1"
    &SQL(update OE_OrdItem set OEORI_ItemStat_DR=:OrdStatID where OEORI_RowId=:oeori)
    i SQLCODE'=0 Q SQLCODE
    
	&SQL(Insert Into OE_OrdStatus(ST_ParRef,ST_Date,ST_Time,ST_Status_DR,ST_User_DR) 
		values(:oeori,:CurDate,:CurTime,:OrdStatID,:userID))
    Q SQLCODE*/
}

/// Descript:  设置医嘱执行记录扩展表状态
/// 			ExpStr:执行时间^执行科室
ClassMethod SetExecExtStat(OrdExecID As %String, exeStatus As %String, UserRowId As %String, ExpStr As %String = "") As %String
{
	n (OrdExecID, exeStatus, UserRowId,ExpStr)
	//执行时间
	s ExecuteDateStr=$P(ExpStr,"^",1)
	//执行科室
	s ExecCTLocDr=$P(ExpStr,"^",2)
	s exeStatID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(exeStatus),""))
	Q:exeStatID="" "-1"
	s CurDate=..%SysDate(), CurTime=..%SysTime()
	if (exeStatus="E") {
		&SQL(update OE_OrdExecExt set OEORE_OrderStatus_DR=:exeStatID, OEORE_OrderStatusDate=:CurDate, 
		OEORE_OrderStatusTime=:CurTime,OEORE_OrderStatusCancelDate=NULL,OEORE_OrderStatusCancelTime=NULL
		where OEORE_RowId=:OrdExecID)
	}else{
		&SQL(update OE_OrdExecExt set OEORE_OrderStatus_DR=:exeStatID, OEORE_OrderStatusDate=NULL, 
		OEORE_OrderStatusTime=NULL,OEORE_OrderStatusCancelDate=:CurDate,OEORE_OrderStatusCancelTime=:CurTime
		where OEORE_RowId=:OrdExecID)
	}
	do ##class(User.OEOrdExecOrdStatus).Save(OrdExecID_"^"_exeStatID_"^"_UserRowId_"^^^^")
	if (exeStatus="E") s NewExecStatCode="F"
	else  if (exeStatus="V") s NewExecStatCode="C"
	if ($g(NewExecStatCode)'="") {
		;医生站设置-常规设置-检查医嘱执行/撤销执行(接口),同步更新护士执行数据
		s EpisodeID=$p(^OEORD(+OrdExecID),"^",1)
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
		if (##class(appcom.OEOrdItem).GetOrdStausChangeAutoUpdateExecFlag(AdmHospitalId)=1) {
			s err=##class(appcom.OEOrdExec).DelaWithExec(OrdExecID,UserRowId,NewExecStatCode,ExecuteDateStr_"^"_ExecCTLocDr)
			if err Q err
		}
	}
    Q SQLCODE
}

/// Descript:  设置部位执行状态
ClassMethod SetExaReqPartStat(adrPartID As %String, ExeStatus As %String) As %String
{
	n (adrPartID,ExeStatus)
	&SQL(update DHC_AppRepPart set AR_ExeStatus=:ExeStatus where AR_RowID=:adrPartID)
	Q SQLCODE
}

/// Descript:  修改执行扩展表的ID
ClassMethod SetOrdExecExt(oeori As %String, PartID As %String, StatCode As %String, OeoriFlag As %String, userID As %String, ExecuteDateStr As %String = "", ExecCTLocDr As %String = "") As %String
{
	n (oeori, PartID, StatCode, OeoriFlag,userID,ExecuteDateStr,ExecCTLocDr)
	s Err=0
	;已撤销的部位不再处理
	s arPartID=..GetExaReqPartID(oeori,PartID)
	if (arPartID'="") {
		s PartExeStatus=$p($g(^DHCAPREP(+arPartID,"AR",$p(arPartID,"||",2),"PA",$p(arPartID,"||",3))),"^",2)
		Q:PartExeStatus="D" Err
	}
	s oeStatus=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(oeori)    /// 医嘱状态
	s TarId=""
	f  s TarId=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarId)) Q:(TarId="")||(Err'=0)  D
	.s Billed=$p(^DHCAPREPTA(TarId),"^",9)      /// 计费状态
	.;多部位重复登记-取消登记会改变Billed，此处不再做过滤
	.;Q:(Billed="I")||(Billed="R")
	.s TarType=$p(^DHCAPREPTA(TarId),"^",3)     /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarId),"^",1)   /// Pointor
	.Q:(TarType'="P")&(OeoriFlag'=1)
	.Q:(TarType="P")&(TarPartID'=PartID)
	.s OrdExecID=$p(^DHCAPREPTA(TarId),"^",10)  /// 执行记录ID
	.if (StatCode="E") d
	..&SQL(update SQLUser.OE_OrdExec set OEORE_Billed="I" where OEORE_RowId=:OrdExecID and OEORE_Billed='R')  /// 计费状态 OE_OrdExec
	..s ARTIRowId=$o(^DHCAPREPTA(0,"IndexOrdExec",OrdExecID,""),-1)
	..&SQL(update SQLUser.DHC_APPRepTarItm set ARTI_Billed="TB" WHERE ARTI_RowId=:ARTIRowId and ARTI_Billed<>'P')
	.else  if (StatCode="V") d
	..//&SQL(update SQLUser.OE_OrdExec set OEORE_Billed="I" where OEORE_RowId=:OrdExecID and OEORE_Billed='B')
	..//&SQL(update SQLUser.DHC_APPRepTarItm set ARTI_Billed="I" WHERE ARTI_OrdExec=:OrdExecID)
	.s Err=..SetExecExtStat(OrdExecID,StatCode,userID,ExecuteDateStr_"^"_ExecCTLocDr)
	Q Err
}

/// Descript:  设置执行记录表计费状态
ClassMethod SetExecBilled(OrdExecID As %String, ExeFlag As %String) As %String
{
	n (OrdExecID, ExeFlag)
	i ExeFlag="E" D
	.s ExeFlag="F"
	.s ExeID=$o(^OEC("STAT",0,"Code",$$ALPHAUP^SSUTIL4(ExeFlag),""))
	E  D
	.s ExeID=""
	//Q:ExeID="" "-1"
	&SQL(update OE_OrdExec set OEORE_Order_Status_DR=:ExeID where OEORE_RowId=:OrdExecID)
	Q SQLCODE
}

/// Descript:  获取检查申请单部位状态
/// W ##Class(web.DHCAPPInterface).GetExaReqItmStat("85727||1","")
ClassMethod GetExaReqItmStat(arReqItmID As %String, PartID As %String) As %String
{
	n (arReqItmID, PartID)
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	s Err=0
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	.s sPartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	.Q:(PartID'="")&(PartID'=sPartID)
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)    /// 执行状态
	.Q:(ExeStat="V")||(ExeStat="D")
	.s Err=1
	Q Err
}

/// Descript:  获取检查申请医嘱总费用(供医生站调用)
/// Input:     itmmastid-医嘱项ID,PartIDList-部位ID^部位ID,EpisodeID-病人就诊ID
/// w ##Class(web.DHCAPPInterface).GetExaReqCost("2729||1","43","")
ClassMethod GetExaReqCost(itmmastid As %String, mPartList As %String, EpisodeID As %String, mDispID As %String, IPid As %String) As %String
{
	n (itmmastid,mPartList,EpisodeID,mDispID,IPid)
	s PartNum=0     /// 部位数
	s ItemNum=0     /// 记录数
	s ExaReqCost=0  /// 总金额
	s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
	s HospId=$p(^CTLOC(AdmDepId),"^",22)
	/// 计费点为执行计费
	s FeePoint=##Class(web.DHCAPPExaRepCom).GetFeePoint(itmmastid,EpisodeID)
	s TarFlag=##Class(web.DHCAPPExaRepCom).GetItemTarFlag(itmmastid,HospId) /// 多部位只收取一个部位价钱
	F i=1:1:$L(mPartList,"^") D
	.s mPartID=$p(mPartList,"^",i)
	.s PartID=+$p(mPartID,"$$",1)  /// 部位
	.s mPosiID=$p(mPartID,"$$",2)  /// 体位
	.s ItemNum=ItemNum+1
	.s PartQty=1
	.i PartID'=0 s PartQty=$p(^DHCAPPART(PartID),"^",7)
	.i TarFlag="N" s PartQty=1     /// 多部位只收取一个部位价钱时,不按部位数量计算收费项目
	.s TPartQty=1   		       /// 临时部位数量
	.F m=1:1:PartQty  D
	..s PartNum=PartNum+1
	..i (PartNum>1)&(TarFlag="N") s TPartQty=0   /// 多部位只收取一个部位价钱
	..s TmpPartNum=PartNum
	..i FeePoint=1 s TmpPartNum=1,ItemNum=1
	../// 医嘱项对应收费项目
	..s itmCost=..GetTarItmByArcTar(itmmastid,EpisodeID,TmpPartNum,PartID,TPartQty,IPid)
	..s ExaReqCost=ExaReqCost+itmCost
	.
	./// 部位绑定收费项目
	.s itmCost=..GetTarItmByArcItm(itmmastid,EpisodeID,ItemNum,PartID,TPartQty,IPid)
	.s ExaReqCost=ExaReqCost+itmCost
	.
	./// 部位绑定体位收费项目
	.s itmCost=..GetTarItmByPosi(itmmastid,EpisodeID,ItemNum,PartID,mPosiID,IPid)
	.s ExaReqCost=ExaReqCost+itmCost
	.
	./// 检查项目后处理收费项目
	.s itmCost=..GetTarItmByDisp(itmmastid,EpisodeID,ItemNum,PartID,mDispID,IPid)
	.i i=1 D
	..s ExaReqCost=ExaReqCost+itmCost
	.
	./// 医嘱项对应收费项目 加收项目
	.s itmCost=..GetTarItmByArc(itmmastid,EpisodeID,PartID,IPid,i)
	.i i=1 D
	..s ExaReqCost=ExaReqCost+itmCost
	.
	Q ExaReqCost
}

/// Descript:  取医嘱项目对应收费项目
ClassMethod GetTarItmByArc(arcimid As %String, EpisodeID As %String, PartID As %String, IPid As %String, PartSeq As %String = "") As %String
{
	n (arcimid, EpisodeID, PartID, IPid,PartSeq)
	s itemCost=0
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:StartDate=""  D
	.Q:StartDate>+$H
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:LkTarID=""   D
	..s EndDate=$p(^DHCOLT(LkTarID),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+31
	..Q:EndDate<+$H
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)
	..s TarQty=$p(^DHCOLT(LkTarID),"^",3)   	 /// 收费项目数量
	..s TarQty=TarQty
	..s BillOnceFlag=$p(^DHCOLT(LkTarID),"^",9)  /// 不按部位计价标示
	..Q:BillOnceFlag'="Y"
	..s TarPrice=..GetTarPrice(TarId,EpisodeID)	 /// 取收费项价格
	..s itemCost=itemCost+(TarPrice*TarQty)
	../// 准备收费明细
	..i PartSeq'=1 s TarQty=0
	..i IPid'="" d
	...D ..InsCostDetail(EpisodeID, arcimid, PartID, TarId, TarQty, 1, IPid)
	..
	Q itemCost
}

/// Descript:  获取体位对应收费项目
ClassMethod GetTarItmByPosi(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, mPosiID As %String, IPid As %String) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, mPosiID, IPid)
	Q:arcimid="" ""
	s itemCost=0
	f i=1:1:$L(mPosiID,",")  d
	.s PosiID=$p(mPosiID,",",i)
	.s itmCost=..GetTarItmByPosiItm(arcimid, EpisodeID, PartNum, PartID, PosiID, IPid)
	.s itemCost=itemCost+itmCost
	Q itemCost
}

/// Descript:  获取后处理对应收费项目
ClassMethod GetTarItmByDisp(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, mDispID As %String, IPid As %String) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, mDispID, IPid)
	Q:arcimid="" ""
	s itemCost=0
	f i=1:1:$L(mDispID,"@")  d
	.s DispID=$p(mDispID,"@",i)
	.s itmCost=..GetTarItmByDispItm(arcimid, EpisodeID, PartNum, PartID, DispID, IPid)
	.s itemCost=itemCost+itmCost
	Q itemCost
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod GetTarItmByArcItm(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, PartQty As %String, IPid As %String) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, PartQty, IPid)
	Q:arcimid="" ""
	s itemCost=0
	s Err=0
	s TarId=""
	f  s TarId=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId)) q:(TarId="")||(Err'=0)  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate)) q:(StartDate="")||(Err'=0)  d
	..Q:StartDate>+$H
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate,LinkID)) q:(LinkID="")||(Err'=0)  d
	...s EndDate=+$p(^DHCAPARCLTA(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+$H)
	...s LPartID=+$p(^DHCAPARCLTA(LinkID),"^",12)  /// 部位
	...Q:LPartID'=PartID
	...s TarQty=+$p(^DHCAPARCLTA(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...s TarDisc=1   /// 系数
	...s TarPrice=..GetTarPrice(TarId,EpisodeID)   /// 取收费项价格
	...i PartQty=0 s TarQty=0    				   /// 部位数为0,绑定项目也为0
	...s BasFlag=$p(^DHCAPARCLTA(LinkID),"^",11)   /// 基价标志
	...s itemCost=itemCost+(TarPrice*TarQty*TarDisc)
	.../// 准备收费明细
	...i IPid'="" d
	....D ..InsCostDetail(EpisodeID, arcimid, PartID, TarId, TarQty, TarDisc, IPid)
	...

	Q itemCost
}

/// Descript:  插入仅医嘱项目对应收费项目
ClassMethod GetTarItmByArcTar(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, PartQty As %String, IPid) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, PartQty, IPid)
	s itemCost=0
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:StartDate=""  D
	.Q:StartDate>+$H
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:LkTarID=""  D
	..s EndDate=$p(^DHCOLT(LkTarID),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+31
	..Q:EndDate<+$H
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)    /// 收费项目ID
	..s TarQty=$p(^DHCOLT(LkTarID),"^",3)   /// 收费项目数量
	..s TarQty=TarQty*PartQty
	..s TarPrice=..GetTarPrice(TarId,EpisodeID)	   /// 取收费项价格
	..s TarDisc=1   /// 系数
	..s BillOnceFlag=$p(^DHCOLT(LkTarID),"^",9)    /// 不按部位计价标示
	..Q:BillOnceFlag="Y"
	..s BasFlag=$p(^DHCOLT(LkTarID),"^",8) 		   /// 基价标志
	..i BasFlag="Y" d
	...s TarDisc=..GetTarDisc(arcimid, PartNum, EpisodeID)
	..s itemCost=itemCost+(TarPrice*TarQty*TarDisc)
	../// 准备收费明细
	..i IPid'="" d
	...D ..InsCostDetail(EpisodeID, arcimid, PartID, TarId, TarQty, TarDisc, IPid)
	..

	Q itemCost
}

/// Descript:  插入仅体位对应收费项目
ClassMethod GetTarItmByPosiItm(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, PosiID As %String, IPid As %String) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, PosiID, IPid)
	Q:+PosiID=0 ""
	s itemCost=0
	s Err=0
	s TarId=""
	f  s TarId=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId)) q:TarId=""  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId,StartDate)) q:StartDate=""  d
	..Q:StartDate>+$H
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPPOSTAR(0,"Pos",PosiID,TarId,StartDate,LinkID)) q:LinkID=""  d
	...s EndDate=+$p(^DHCAPPOSTAR(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+$H)
	...s TarQty=+$p(^DHCAPPOSTAR(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...s TarPrice=..GetTarPrice(TarId,EpisodeID)   /// 取收费项价格
	...s TarDisc=1   /// 系数
	...s itemCost=itemCost+(TarPrice*TarQty*TarDisc)
	.../// 准备收费明细
	...i IPid'="" d
	....D ..InsCostDetail(EpisodeID, arcimid, PartID, TarId, TarQty, TarDisc, IPid)
	..

    Q itemCost
}

/// Descript:  插入仅后处理对应收费项目
ClassMethod GetTarItmByDispItm(arcimid As %String, EpisodeID As %String, PartNum As %String, PartID As %String, DispID As %String, IPid As %String) As %String
{
	n (arcimid, EpisodeID, PartNum, PartID, DispID, IPid)
	Q:+DispID=0 ""
	s itemCost=0
	s TarId=""
	f  s TarId=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId)) q:TarId=""  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId,StartDate)) q:StartDate=""  d
	..Q:StartDate>+$H
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPMEDTAR(0,"Med",DispID,TarId,StartDate,LinkID)) q:LinkID=""  d
	...s EndDate=+$p(^DHCAPMEDTAR(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+$H)
	...s TarQty=+$p(^DHCAPMEDTAR(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...s TarPrice=..GetTarPrice(TarId,EpisodeID)   /// 取收费项价格
	...s TarDisc=1   /// 系数
	...s itemCost=itemCost+(TarPrice*TarQty*TarDisc)
	.../// 准备收费明细
	...i IPid'="" d
	....D ..InsCostDetail(EpisodeID, arcimid, PartID, TarId, TarQty, TarDisc, IPid)
	..

    Q itemCost
}

/// Descript:  取收费项价格
/// w ##Class(web.DHCAPPInterface).GetTarPrice("6313","302","602")
ClassMethod GetTarPrice(TarId As %String, EpisodeID As %String) As %String
{
	n (TarId, EpisodeID)
	s InsType=$P(^PAADM(EpisodeID,1),"^",7)  /// 费别指针
	s PatType=$p(^PAADM(EpisodeID,1),"^",6)  /// 就诊类型
	s admLocID=$p(^PAADM(EpisodeID),"^",4) 	 /// 就诊科室
	s HospID=$p(^CTLOC(admLocID),"^",22) 	 /// 医院ID
	s ExpStr="^^^"_EpisodeID_"^"_"" ///recLocID_"^"_arcimid
	s TarPrice=##Class(web.UDHCJFPRICE).GetItmPrice(TarId,+$H,InsType,PatType,"",HospID,ExpStr)
	s TarPrice=+$p(TarPrice,"^",1)
	Q TarPrice
}

/// Descript:  临时费用明细项目
ClassMethod InsCostDetail(EpisodeID As %String, arcimid As %String, PartID As %String, TarId As %String, TarQty As %String, TarDisc As %String, IPid As %String) As %String
{
	n (EpisodeID, arcimid, PartID, TarId, TarQty, TarDisc, IPid)
	s index=arcimid_"^"_PartID, index2=TarId
	s TarPrice=..GetTarPrice(TarId, EpisodeID)	/// 取收费项价格
	i '$d(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2)) D
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2)=TarId_"^"_(TarPrice*TarQty)_"^"_(TarPrice*TarQty*TarDisc)_"^"_TarQty_"^"_TarPrice
	E  D
	.s $p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",2)=$p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",2)+(TarPrice*TarQty)
	.s $p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",3)=$p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",3)+(TarPrice*TarQty*TarDisc)
	.s $p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",4)=$p(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid,index,index2),"^",4)+TarQty
	Q ""
}

/// Descript: 获取系数
/// w ##Class(web.DHCAPPInterface).GetTarDisc("10446||1","","491")
ClassMethod GetTarDisc(arcimid As %String, PartNum As %String, EpisodeID As %String) As %String
{
	n (arcimid, PartNum, EpisodeID)
	s admtype=$p(^PAADM(EpisodeID),"^",2)
	q:admtype="" 1	
	s ret=##Class(web.DHCAPPRepTarItm).GetDiscByType(arcimid,PartNum,2)
	s flag=$p(ret,"^",2)
	q:(flag=1) +ret
	s ret=##Class(web.DHCAPPRepTarItm).GetDiscByType(arcimid,PartNum,$case(admtype,"I":1,:0))
	s flag=$p(ret,"^",2)
	q:(flag=1) +ret
	//q +ret
	s ret=##Class(web.DHCAPPInterface).GetLastDiscByType(arcimid,PartNum,EpisodeID)
	Q +ret
}

/// Descript: 获取部位最近折扣系数
/// w ##Class(web.DHCAPPInterface).GetLastDiscByType("10445||1","","491")
ClassMethod GetLastDiscByType(arcimid As %String, PartNum As %String, EpisodeID As %String) As %String
{
	n (arcimid, PartNum, EpisodeID)
	s admtype=$p(^PAADM(EpisodeID),"^",2)
	Q:admtype="" 1	
	s flag=0
	s ret="1^0"
	F TmpNum=PartNum:-1:1 Q:flag=1  D
	.s ret=##Class(web.DHCAPPRepTarItm).GetDiscByType(arcimid,TmpNum,2)
	.s flag=$p(ret,"^",2)
	.Q:flag=1
	.s ret=##Class(web.DHCAPPRepTarItm).GetDiscByType(arcimid,TmpNum,$case(admtype,"I":1,:0))
	.s flag=$p(ret,"^",2)
	.
	Q ret
}

/// Descript:  获取检查申请医嘱总费用(供PAC调用)
/// Input:     oeori-医嘱ID,PartID-部位ID
/// OutPut:    折后费用^费用
/// w ##Class(web.DHCAPPInterface).GetExaReqPartCost("566||14","")
ClassMethod GetExaReqPartCost(oeori As %String, PartID As %String, IPid As %String = "") As %String
{
	n (oeori,PartID,IPid)
	s TarDiscCost=0,TarCost=0
	s EpisodeID=$p(^OEORD(+oeori),"^",1)	/// 就诊ID
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)      /// 类型
	.s TarPartID=+$p(^DHCAPREPTA(TarID),"^",1)   /// 部位ID
	.Q:(PartID'="")&(TarPartID'=PartID)&(TarType'="D")          /// 筛选部位
	.s TarItmID=$p(^DHCAPREPTA(TarID),"^",5)      /// 收费项ID
	.s TarPrice=..GetTarPrice(TarItmID,EpisodeID) /// 取收费项价格
	.s TarDisc=$p(^DHCAPREPTA(TarID),"^",4)       /// 打折系数
	.s TarQty=$p(^DHCAPREPTA(TarID),"^",8)        /// 数量
	.s TarDiscCost=TarDiscCost+(TarPrice*TarDisc*TarQty)
	.s TarCost=TarCost+(TarPrice*TarQty)
	./// 准备收费明细
	.i IPid'="" d
	..s arcimid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	..if TarType="D" s TarPartID=0
	..s ARRowID=$o(^DHCAPREP(0,"OrdItem",oeori,""))
	..if ARRowID'="" d
	...s CH=$o(^DHCAPREP(0,"OrdItem",oeori,ARRowID,""))
	...s arcimid=ARRowID_"||"_CH
	..D ..InsCostDetail(EpisodeID, arcimid, TarPartID, TarItmID, TarQty, TarDisc, IPid)
	;修复多部位和非多部位医嘱同时发送申请时，非多部位医嘱价格显示为0
	if ('$d(^DHCAPREPTA(0,"OrdItem",oeori)))&&(IPid'="") {
		s arcimid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
		s TarCost=##Class(web.DHCAPPInterface).GetExaReqCost(arcimid,"",EpisodeID,"",IPid)
		s ItemQty=1
		s ARRowID=$o(^DHCAPREP(0,"OrdItem",oeori,""))
		if ARRowID'="" d
		.s CH=$o(^DHCAPREP(0,"OrdItem",oeori,ARRowID,""))
		.s ItemQty=$p(^DHCAPREP(ARRowID,"AR",CH),"^",15) 		//数量
		s TarDiscCost=(TarCost*ItemQty)
	}
	Q TarDiscCost_"^"_TarCost
}

/// Descript:  获取医嘱项对应部位列表(供医生站调用)
/// Input:     itmmastid-医嘱项ID
/// w ##Class(web.DHCAPPInterface).GetItmPartList("医嘱项ID")
ClassMethod GetItmPartList(itmmastid As %String) As %String
{
	n (itmmastid)
	s ListData=""
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) Q:TraID=""  D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:CH=""  D
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)     /// 部位ID
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)         /// 部位描述
	..s LastPartID=$p(^DHCAPPART(PartID),"^",3)       /// 上级部位ID
	..s LastPartDesc=""
	..i +LastPartID'=0 s LastPartDesc=$p(^DHCAPPART(LastPartID),"^",2) /// 大部位描述
	..i ListData="" s ListData=LastPartDesc_"^"_PartDesc
	..e  s ListData=ListData_"||"_LastPartDesc_"^"_PartDesc
	.
	Q ListData
}

/// Descript:  通过医嘱ID获取检查申请内容(供集成平台、PAC调用)
/// Input:     oeori-医嘱ID
/// OutPut：   申请单号^申请日期^申请时间^申请人工号^接收科室描述^加急标志^检查目的^病人ID^就诊ID
///            登记号^姓名^诊断^现病史^体征^主诉^医嘱项代码^医嘱项描述^部位描述^后处理描述
/// w ##Class(web.DHCAPPInterface).GetExaReqContent("2495||5")
ClassMethod GetExaReqContent(oeori As %String) As %String
{
	n (oeori)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s arReqNo=$p(^DHCAPREP(arReqID),"^",1)           /// 单号
	s arReqData=$p(^DHCAPREP(arReqID),"^",2)         /// 报告日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData)
	s arReqTime=$p(^DHCAPREP(arReqID),"^",3)         /// 报告时间
	s:arReqTime'="" arReqTime=..%ZT(arReqTime,1)
	s arUserCode=""
	s arUserID=$p(^DHCAPREP(arReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",1)
	s arUserCode=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUserCode) /// 去掉英文字母
	s arRepExLoc=""
	s arExLocID=$p(^DHCAPREP(arReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)         /// 执行科室
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	     /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	s arPurpose=$g(^DHCAPREP(arReqID,"Purpose"))    /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(arReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"1",1:"0")
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",arReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"REQ",arReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s arExaReqSym=""
	s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",arReqID,""))
	i arExaReqSymID'="" s arExaReqSym=$G(^DHCAPPATSY(arExaReqSymID,"Symptom")) /// 主诉
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)      /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)         ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	s arPartDesc=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	.Q:PartID=""
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:ExeStat="D"
	.s PartCode=$p(^DHCAPPART(PartID),"^",1) 				 ///部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 ///部位
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	.i arPartDesc'="" s arPartDesc=arPartDesc_"@@"_PartDesc
	.E  s arPartDesc=PartDesc
	
	s arDispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(arReqID_"||"_CH) ///后处理
	
	s ListData=arReqNo_"^"_arReqData_"^"_arReqTime_"^"_arUserCode_"^"_arRepExLoc_"^"_arEmgFlag_"^"_arPurpose_"^"_PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName
	s ListData=ListData_"^"_PatDiag_"^"_arHisDesc_"^"_arSigDesc_"^"_arExaReqSym_"^"_arcitmcode_"^"_arcitmdesc_"^"_arPartDesc_"^"_arDispDesc
	
	Q ListData
}

/// Descript:  通过医嘱ID获取检查申请内容Html(供集成平台调用)
/// Input:     arReqID-申请单ID
/// w ##Class(web.DHCAPPInterface).GetExaReqHtmlContent("")
ClassMethod GetExaReqHtmlContent(arReqID As %String) As %String
{
	n (arReqID)

	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" ""
	s arReqNo=$p(^DHCAPREP(arReqID),"^",1)           /// 单号
	s arReqData=$p(^DHCAPREP(arReqID),"^",2)         /// 报告日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //$zd(arReqData,3)
	s arReqTime=$p(^DHCAPREP(arReqID),"^",3)         /// 报告时间
	s:arReqTime'="" arReqTime=..%ZT(arReqTime,1)
	s arUserCode=""
	s arUserID=$p(^DHCAPREP(arReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",2)
	s arUserCode=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUserCode)
	s arRepExLoc=""
	s arExLocID=$p(^DHCAPREP(arReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)         /// 执行科室
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	     /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	//s arPurpose=$p(^DHCAPREP(arReqID),"^",20)        /// 检查目的
	s arPurpose=$g(^DHCAPREP(arReqID,"Purpose"))    /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(arReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"1",1:"0")
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",arReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"REQ",arReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)      /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)        /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)     ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			 /// 就诊科室
	s:PatLocID'="" PatLoc=$p($p(^CTLOC(PatLocID),"^",2),"-",2)
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s itemdesc=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)         ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)     	   ///医嘱ID
	.s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.Q:ItemStat="D"
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	..Q:PartID=""
	..s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	..Q:ExeStat="D"
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				  ///部位
	..s arPartID=arReqID_"||"_CH_"||"_Sub
	..s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	..i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	..i PartList'="" s PartList=PartList_"、"_PartDesc
	..E  s PartList=PartDesc
	.	
	.s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(arReqID_"||"_CH) ///后处理
	.
	.s ItemLabel=arcitmdesc
	.i DispDesc'="" s ItemLabel=ItemLabel_" + "_DispDesc
	.i PartList'="" s ItemLabel=ItemLabel_" ["_PartList_"]"
	.
	.i itemdesc="" s itemdesc=ItemLabel
	.E  s itemdesc=itemdesc_"<br>"_ItemLabel

	s mListData=PatNo_"^"_PatName_"^"_PatAge_"^"_PatLoc_"^"_PatSex_"^"_arHisDesc_"^"_arSigDesc_"^"_PatDiag
	s mListData=mListData_"^"_itemdesc_"^"_arRepExLoc_"^"_arReqTime_"^"_arUserCode_"^"_arReqNo
	
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID)

	i arExaReqCode="CT" D ..GetExaReqHtmlContentCT(arReqID)  /// CT
	i arExaReqCode="CS" D ..GetExaReqHtmlContentCS(arReqID,mListData)  /// 超声
	i arExaReqCode="HC" D ..GetExaReqHtmlContentHC(arReqID,mListData)  /// 核磁
	i arExaReqCode="WJ" D ..GetExaReqHtmlContentWJ(arReqID,mListData)  /// 胃镜
	i arExaReqCode="XD" D ..GetExaReqHtmlContentXD(arReqID,mListData)  /// 心电
	Q ""
}

/// / Descript:  超声模板
ClassMethod GetExaReqHtmlContentCS(arReqID As %String, mListData As %String) As %String
{
	n (arReqID, mListData)
	
	s PatNo=$p(mListData,"^",1) 	  /// 登记号
	s PatName=$p(mListData,"^",2) 	  /// 姓名
	s PatAge=$p(mListData,"^",3) 	  /// 年龄
	s PatLoc=$p(mListData,"^",4) 	  /// 就诊科室
	s PatSex=$p(mListData,"^",5) 	  /// 性别
	s arHisDesc=$p(mListData,"^",6)   /// 现病史
	s arSigDesc=$p(mListData,"^",7)   /// 体征信息
	s PatDiag=$p(mListData,"^",8) 	  /// 诊断
	s itemdesc=$p(mListData,"^",9) 	  /// 检查项目
	s arRepExLoc=$p(mListData,"^",10) /// 执行科室
	s arReqTime=$p(mListData,"^",11)  /// 申请时间
	s arUserCode=$p(mListData,"^",12) /// 申请人
	s arReqNo=$p(mListData,"^",13)    /// 申请单号
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID,1)
	
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>检查申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:950px; height:640px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>河南省人民医院</h2>"
	s ListData=ListData_"<h1 style='padding: 0; margin: 0; line-height: 30px; font-weight: bold; font-size: 36px; font-weight: bold;'>"_arExaReqCode_"&nbsp;检查申请单</h1>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>病&nbsp;&nbsp;历&nbsp;&nbsp;号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"_PatLoc_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>医保手册号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床症状、体征及实验室检查:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_arHisDesc_"、"_arSigDesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床诊断:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_PatDiag_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>检查项目:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_itemdesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>特殊病史、检查异常:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	
	s OTNum=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"<div style='padding-bottom:5px;'>"
	.s ListData=ListData_"<span style='margin-left:60px;'>"_itemdesc_"：</span><span style='margin-left:10px;'>"_itemval_"</span>"
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"</div>"
	.s OTNum=OTNum+1

	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	s ListData=ListData_"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>上机技师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:30%;margin:0px 10px; display:inline-block;'>上机医师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:20%;margin:0px 10px; display:inline-block;'>检查时间：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"_arRepExLoc_"</span></span>"
	s ListData=ListData_"<span style='width:30%; margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"_arReqTime_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>申请医生：<span style='padding-left:10px;'>"_arUserCode_"</span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin-top:0px; padding-left:20px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div><span>各位患者请注意：</span></div>"
	s ListData=ListData_"<div><span>1.肝脏、胆囊、胆道系统、胰腺、门静脉血流检测等超声检查时，需空腹(8-12小时)。</span></div>"
	s ListData=ListData_"<div><span>2.妇科(子宫及附件)疾患、早孕、前置胎盘、膀胱等经腹超声检查时，需要充盈膀胱。</span></div>"
	s ListData=ListData_"<div><span>3.做过胆系造影、钡剂检查、增强CT检查的患者，需3天后空腹才能做超声检查。</span></div>"
	s ListData=ListData_"<div><span>&nbsp;&nbsp;若胃镜和超声同一天检查，需先做超声后做胃镜。</span></div>"
	s ListData=ListData_"<div><span>4.检查时请携带病历及X线片(平片及造影)、既往超声等检查结果。</span></div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"</body>"
	s ListData=ListData_"</html>"
	s ^DHCAPREPHTML("DHCAPP","web.DHCAPPInterface","GetExaReqHtmlContent",arReqNo)=ListData
}

/// / Descript:  核磁模板
ClassMethod GetExaReqHtmlContentHC(arReqID As %String, mListData As %String) As %String
{
	n (arReqID, mListData)
	
	s PatNo=$p(mListData,"^",1) 	  /// 登记号
	s PatName=$p(mListData,"^",2) 	  /// 姓名
	s PatAge=$p(mListData,"^",3) 	  /// 年龄
	s PatLoc=$p(mListData,"^",4) 	  /// 就诊科室
	s PatSex=$p(mListData,"^",5) 	  /// 性别
	s arHisDesc=$p(mListData,"^",6)   /// 现病史
	s arSigDesc=$p(mListData,"^",7)   /// 体征信息
	s PatDiag=$p(mListData,"^",8) 	  /// 诊断
	s itemdesc=$p(mListData,"^",9) 	  /// 检查项目
	s arRepExLoc=$p(mListData,"^",10) /// 执行科室
	s arReqTime=$p(mListData,"^",11)  /// 申请时间
	s arUserCode=$p(mListData,"^",12) /// 申请人
	s arReqNo=$p(mListData,"^",13)    /// 申请单号
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID,1)
	
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>检查申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:950px; height:640px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>河南省人民医院</h2>"
	s ListData=ListData_"<h1 style='padding: 0; margin: 0; line-height: 30px; font-weight: bold; font-size: 36px; font-weight: bold;'>"_arExaReqCode_"&nbsp;检查申请单</h1>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>病&nbsp;&nbsp;历&nbsp;&nbsp;号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"_PatLoc_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>医保手册号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床症状、体征及实验室检查:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_arHisDesc_"、"_arSigDesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床诊断:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_PatDiag_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>检查项目:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_itemdesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>特殊病史、检查异常:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	
	s OTNum=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"<div style='padding-bottom:5px;'>"
	.s ListData=ListData_"<span style='margin-left:60px;'>"_itemdesc_"：</span><span style='margin-left:10px;'>"_itemval_"</span>"
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"</div>"
	.s OTNum=OTNum+1

	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	s ListData=ListData_"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>上机技师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:30%;margin:0px 10px; display:inline-block;'>上机医师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:20%;margin:0px 10px; display:inline-block;'>检查时间：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"_arRepExLoc_"</span></span>"
	s ListData=ListData_"<span style='width:30%; margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"_arReqTime_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>申请医生：<span style='padding-left:10px;'>"_arUserCode_"</span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin-top:0px; padding-left:20px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div><span>各位患者请注意：</span></div>"
	s ListData=ListData_"<div><span>1.头颈部检查的患者请于检查前一天洗头，不要使用任何护发用品。腹部检查者(肝、胆、胰、脾及泌尿系脏器)检查前禁食4小时。</span></div>"
	s ListData=ListData_"<div><span>2.检查时请携带病历及X线片(平片及造影)、超声、CT等检查结果。</span></div>"
	s ListData=ListData_"<div><span>3.患者须向工作人员说明有无手术史，有无金属或磁性物质植入体内，包括宫内节育器、义齿、电子耳等，有无药物过敏史。</span></div>"
	s ListData=ListData_"<div><span>4.检查时不要穿戴有金属物质的内衣裤，除去体表金属饰物，如项链、耳环、手表、戒指等，除去脸上化妆品及义齿、义眼、眼镜等。</span></div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"</body>"
	s ListData=ListData_"</html>"
	s ^DHCAPREPHTML("DHCAPP","web.DHCAPPInterface","GetExaReqHtmlContent",arReqNo)=ListData
}

/// / Descript:  胃镜模板
ClassMethod GetExaReqHtmlContentWJ(arReqID As %String, mListData As %String) As %String
{
	n (arReqID, mListData)
	
	s PatNo=$p(mListData,"^",1) 	  /// 登记号
	s PatName=$p(mListData,"^",2) 	  /// 姓名
	s PatAge=$p(mListData,"^",3) 	  /// 年龄
	s PatLoc=$p(mListData,"^",4) 	  /// 就诊科室
	s PatSex=$p(mListData,"^",5) 	  /// 性别
	s arHisDesc=$p(mListData,"^",6)   /// 现病史
	s arSigDesc=$p(mListData,"^",7)   /// 体征信息
	s PatDiag=$p(mListData,"^",8) 	  /// 诊断
	s itemdesc=$p(mListData,"^",9) 	  /// 检查项目
	s arRepExLoc=$p(mListData,"^",10) /// 执行科室
	s arReqTime=$p(mListData,"^",11)  /// 申请时间
	s arUserCode=$p(mListData,"^",12) /// 申请人
	s arReqNo=$p(mListData,"^",13)    /// 申请单号
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID,1)
	
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>检查申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:950px; height:640px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>河南省人民医院</h2>"
	s ListData=ListData_"<h1 style='padding: 0; margin: 0; line-height: 30px; font-weight: bold; font-size: 36px; font-weight: bold;'>"_arExaReqCode_"&nbsp;检查申请单</h1>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>病&nbsp;&nbsp;历&nbsp;&nbsp;号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"_PatLoc_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>医保手册号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床症状、体征及实验室检查:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_arHisDesc_"、"_arSigDesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床诊断:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_PatDiag_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>检查项目:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_itemdesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>特殊病史、检查异常:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	
	s OTNum=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"<div style='padding-bottom:5px;'>"
	.s ListData=ListData_"<span style='margin-left:60px;'>"_itemdesc_"：</span><span style='margin-left:10px;'>"_itemval_"</span>"
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"</div>"
	.s OTNum=OTNum+1

	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	s ListData=ListData_"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>上机技师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:30%;margin:0px 10px; display:inline-block;'>上机医师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:20%;margin:0px 10px; display:inline-block;'>检查时间：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"_arRepExLoc_"</span></span>"
	s ListData=ListData_"<span style='width:30%; margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"_arReqTime_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>申请医生：<span style='padding-left:10px;'>"_arUserCode_"</span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin-top:0px; padding-left:20px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div><span>各位患者请注意：</span></div>"
	s ListData=ListData_"<div><span>1.检查前12小时内禁食有形食物，可饮无色液体(水或饮料)。</span></div>"
	s ListData=ListData_"<div><span>2.检查前半小时内勿饮水。</span></div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"</body>"
	s ListData=ListData_"</html>"
	s ^DHCAPREPHTML("DHCAPP","web.DHCAPPInterface","GetExaReqHtmlContent",arReqNo)=ListData
}

/// / Descript:  心电模板
ClassMethod GetExaReqHtmlContentXD(arReqID As %String, mListData As %String) As %String
{
	n (arReqID, mListData)
	
	s PatNo=$p(mListData,"^",1) 	  /// 登记号
	s PatName=$p(mListData,"^",2) 	  /// 姓名
	s PatAge=$p(mListData,"^",3) 	  /// 年龄
	s PatLoc=$p(mListData,"^",4) 	  /// 就诊科室
	s PatSex=$p(mListData,"^",5) 	  /// 性别
	s arHisDesc=$p(mListData,"^",6)   /// 现病史
	s arSigDesc=$p(mListData,"^",7)   /// 体征信息
	s PatDiag=$p(mListData,"^",8) 	  /// 诊断
	s itemdesc=$p(mListData,"^",9) 	  /// 检查项目
	s arRepExLoc=$p(mListData,"^",10) /// 执行科室
	s arReqTime=$p(mListData,"^",11)  /// 申请时间
	s arUserCode=$p(mListData,"^",12) /// 申请人
	s arReqNo=$p(mListData,"^",13)    /// 申请单号
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID,1)
	
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>检查申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:950px; height:640px; font-family: "_"黑体"_";font-size: 16px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>河南省人民医院</h2>"
	s ListData=ListData_"<h1 style='padding: 0; margin: 0; line-height: 30px; font-weight: bold; font-size: 36px; font-weight: bold;'>"_arExaReqCode_"&nbsp;检查申请单</h1>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>病&nbsp;&nbsp;历&nbsp;&nbsp;号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"_PatLoc_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>医保手册号：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床症状、体征及实验室检查:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_arHisDesc_"、"_arSigDesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床诊断:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_PatDiag_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>检查项目:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_itemdesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>特殊病史、检查异常:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	
	s OTNum=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"<div style='padding-bottom:5px;'>"
	.s ListData=ListData_"<span style='margin-left:60px;'>"_itemdesc_"：</span><span style='margin-left:10px;'>"_itemval_"</span>"
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"</div>"
	.s OTNum=OTNum+1

	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	s ListData=ListData_"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>上机技师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:30%;margin:0px 10px; display:inline-block;'>上机医师：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"<span style='width:20%;margin:0px 10px; display:inline-block;'>检查时间：<span style='padding-left:10px;'></span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"_arRepExLoc_"</span></span>"
	s ListData=ListData_"<span style='width:30%; margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"_arReqTime_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>申请医生：<span style='padding-left:10px;'>"_arUserCode_"</span></span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"</body>"
	s ListData=ListData_"</html>"
	s ^DHCAPREPHTML("DHCAPP","web.DHCAPPInterface","GetExaReqHtmlContent",5)=ListData
}

/// Descript:  CT模板
ClassMethod GetExaReqHtmlContentCT(arReqID As %String) As %String
{
    n (arReqID)
	
	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID)) ""
	s arReqNo=$p(^DHCAPREP(arReqID),"^",1)           /// 单号
	s arReqData=$p(^DHCAPREP(arReqID),"^",2)         /// 报告日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //$zd(arReqData,3)
	s arReqTime=$p(^DHCAPREP(arReqID),"^",3)         /// 报告时间
	s:arReqTime'="" arReqTime=..%ZT(arReqTime,1)
	s arReqTime=arReqData_" "_arReqTime
	s arUserCode=""
	s arUserID=$p(^DHCAPREP(arReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",2)
	s arUserCode=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUserCode)
	s arRepExLoc=""
	s arExLocID=$p(^DHCAPREP(arReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)         /// 执行科室
	s arRepExLocFlor=$p(^CTLOC(arExLocID),"^",16)     /// 接收科室地址
	s arRepExLocAdrr=$g(^CTLOC(arExLocID,"ADDR",1))   /// 接收科室楼层
	s arRepExLocAdrr=arRepExLocAdrr_arRepExLocFlor
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	     /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	//s arPurpose=$p(^DHCAPREP(arReqID),"^",20)        /// 检查目的
	s arPurpose=$g(^DHCAPREP(arReqID,"Purpose"))    /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(arReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"1",1:"0")
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",arReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"REQ",arReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s arExaReqSym=""
	s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",arReqID,""))
	i arExaReqSymID'="" s arExaReqSym=$G(^DHCAPPATSY(arExaReqSymID,"Symptom")) /// 主诉
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)      /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)        /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)     ///年龄
	s PatLoc="",HospDesc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			 /// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	i PatLoc["-" s PatLoc=$p(PatLoc,"-",2)
	i PatLocID'="" D
	.s HospID=+$p(^CTLOC(PatLocID),"^",22)  /// 医院ID
	.s HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s itemdesc=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)         ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)     	    ///医嘱ID
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	..Q:PartID=""
	..s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	..Q:ExeStat="D"
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				  ///部位
	..s arPartID=arReqID_"||"_CH_"||"_Sub
	..s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	..i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	..i PartList'="" s PartList=PartList_"、"_PartDesc
	..E  s PartList=PartDesc
	.
	.s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(arReqID_"||"_CH) ///后处理
	.
	.s ItemLabel=arcitmdesc
	.i DispDesc'="" s ItemLabel=ItemLabel_" + "_DispDesc
	.i PartList'="" s ItemLabel=ItemLabel_"【"_PartList_"】"
	.
	.i itemdesc="" s itemdesc=ItemLabel
	.E  s itemdesc=itemdesc_"<br>"_ItemLabel
	
	s PatType=$p(^PAADM(EpisodeID),"^",2)        /// 就诊类型
	i arExaReqSym'="" s arExaReqSym="主诉："_arExaReqSym_"；"
    i arHisDesc'="" s arHisDesc="现病史："_arHisDesc_"；"
    i arSigDesc'="" s arSigDesc="体征："_arSigDesc
    s PatSymInfo=arExaReqSym_""_arHisDesc_""_arSigDesc
    s PatSymInfo=$E(PatSymInfo,1,260)
    
	s CardNo=##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID) //卡号
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arReqID,1)
	s ExaReqNoCost=##Class(web.DHCAPPExaReportQuery).GetExaReqNoCost(arReqID)  /// 申请单总金额
	s PatCardMoney=##Class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID) /// 获取卡余额
	s ExaReqTitle=HospDesc_$s(PatType="I":"住院",PatType="E":"急诊",1:"门诊")_"检查申请单"
	
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>检查申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:900px; height:640px; font-family: "_"宋体"_";font-size: 14px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>"_ExaReqTitle_"</h2>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>登&nbsp;记&nbsp;号：<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='width:15%; margin:0px 10px; display:inline-block;'> 姓&nbsp;&nbsp;名：<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='width:15%; margin:0px 10px; display:inline-block;'>年&nbsp;&nbsp;龄：<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='width:15%; margin:0px 10px; display:inline-block;'>性&nbsp;&nbsp;别：<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='width:20%; margin:0px 10px; display:inline-block;'>卡&nbsp;&nbsp;号：<span style='padding-left:10px;'>"_CardNo_"</span></span>"
	s ListData=ListData_"</div>"
	

	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:37%; margin:0px 10px; display:inline-block;'>就诊科室：<span style='padding-left:10px;'>"_PatLoc_"</span></span>"
	s ListData=ListData_"<span style='width:30%; margin:0px 10px; display:inline-block;'>接收科室：<span style='padding-left:10px;'>"_arRepExLoc_"</span></span>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>主诉、临床症状、体征及实验室结果:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:80px;padding-left:40px;'>"
	s ListData=ListData_"<p style='padding:0px;margin:0px;padding-top:3px;'>"_PatSymInfo_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>临床诊断:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_PatDiag_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>检查项目:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	s ListData=ListData_"<p>"_itemdesc_"</p>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<div>"
	s ListData=ListData_"<span style='padding-left:20px;'>特殊病史:</span>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='height:40px;padding-left:40px;'>"
	
	s OTNum=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"<div style='padding-bottom:5px;'>"
	.s ListData=ListData_"<span style='margin-left:60px;'>"_itemdesc_"：</span><span style='margin-left:10px;'>"_itemval_"</span>"
	.i (OTNum'=0)&(OTNum#4=0) s ListData=ListData_"</div>"
	.s OTNum=OTNum+1

	
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"<div style='margin:10px 5px;'>"
	s ListData=ListData_"<span style='width:50%;padding-left:20px; display:inline-block;'>开单医生：<span style='padding-left:10px;'>"_arUserCode_"</span></span>"
	s ListData=ListData_"<span style='width:30%;margin:0px 10px; display:inline-block;'>申请时间：<span style='padding-left:10px;'>"_arReqTime_"</span></span>"
	s ListData=ListData_"</div>"
	
	
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"<div style='margin-top:0px; padding-left:20px; font-family: "_"宋体"_";font-size: 16px;'>"
	s ListData=ListData_"<div style='margin:10px 5px;'><span>检查地点:</span>"_arRepExLocAdrr_"</div>"
	s ListData=ListData_"<div style='margin:10px 5px;'><span>温馨提示:</span><span style='width:40%; margin:0px 10px; display:inline-block;'>此申请单金额：<span style='padding-left:10px;'>"_ExaReqNoCost_"</span></span><span style='width:30%; margin:0px 10px; display:inline-block;'>您卡中现有金额：<span style='padding-left:10px;'>"_PatCardMoney_"</span></span></div>"
	s ListData=ListData_"</div>"
	
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"

	s ListData=ListData_"</body>"
	s ListData=ListData_"</html>"
	//s ^DHCAPREPHTML("DHCAPP","web.DHCAPPInterface","GetExaReqHtmlContent",arReqNo)=ListData
	Q ListData
}

/// Descript:  发送医嘱ID到供集成平台(集成平台)
/// Input:     arReqID-检查申请ID
/// w ##Class(web.DHCAPPInterface).SendExaReqIDToPlat("检查申请ID")
ClassMethod SendExaReqIDToPlat(arreqid As %String) As %String
{
	n (arreqid)
	s EpisodeID=$p(^DHCAPREP(arreqid),"^",6)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:AdmType'="I" 0
	s OeoriList=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arreqid,"AR",CH)) Q:CH=""  D
	.s oeori=$p(^DHCAPREP(arreqid,"AR",CH),"^",3)   /// 检查申请医嘱ID
	.i OeoriList="" s OeoriList=oeori
	.E  s OeoriList=OeoriList_"^"_oeori
	/// 调用集成平台
	s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDRISAPPBILLINFO",OeoriList)
	Q 0
}

/// Creator :  QQA
/// Descript:  修改检查检验病理的申请状态调用集成平台方法:用于申请单界面发送时调用
/// Input:     StatusCode：状态代码  Arreqid：申请单ID
/// w ##Class(web.DHCAPPInterface).UpdExaReqStatus("AP","341")
ClassMethod UpdExaReqStatus(StatusCode As %String, Arreqid As %String, UserID As %String) As %String
{
	n (Arreqid ,StatusCode,UserID)
	s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s DataList=[]
	s CH=""
	f  s CH=$o(^DHCAPREP(Arreqid,"AR",CH)) Q:CH=""  D
	.s Oeori=$p(^DHCAPREP(Arreqid,"AR",CH),"^",3)   /// 检查申请医嘱ID
	.s OrdDeptId = $p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),7)),"^",2)	;
	.s DeptCode="",DeptDesc=""
	.if OrdDeptId'="" s DeptCode=$P($G(^CTLOC(+OrdDeptId)),"^",1)
	.if OrdDeptId'="" s DeptDesc=$P($G(^CTLOC(+OrdDeptId)),"^",2)
	.s Position="",Sub=""                           /// 拼接部位串
	.f  s Sub = $o(^DHCAPREP(Arreqid,"AR",CH,"PA",Sub)) q:Sub=""  d
	..s PartID = $p(^DHCAPREP(Arreqid,"AR",CH,"PA",Sub),"^",1)
	..s PartDesc = $p(^DHCAPPART(PartID),"^",2)
	..s:Position'="" Position =Position_"@@"_PartDesc
	..s:Position="" Position =PartDesc
	.s StudyNo = $p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3)),"^",20)
	.s DymObj={}
	.s DymObj.OEOrdItemID =Oeori
	.s DymObj.Position =Position
	.s DymObj.ExamID =StudyNo
	.s DymObj.Status =StatusCode
	.s DymObj.UserID =UserCode
	.s DymObj.UserName =UserName
	.s DymObj.UpDateTime =$zd(+$h,3)_" "_..%ZT(..%SysTime(),2)
	.s DymObj.SourceSystem ="HIS"
	.s DymObj.OperateDeptCode =DeptCode
	.s DymObj.OperateDept =DeptDesc
	.d DataList.%Push(DymObj)
	b ;ddd
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Steam)
	Q 0
}

/// Creator :  qqa 
/// Descript:  修改检查检验病理的申请状态调用集成平台方法
/// Input:     StatusCode：状态代码  ArReqItmId：申请单子表ID  InPartID：部位ID  LgParam：UserID
/// w ##Class(web.DHCAPPInterface).UpdExaReqItmStatus("OCA","295||1","",4634)
ClassMethod UpdExaReqItmStatus(StatusCode, ArReqItmId, InPartID, UserID) As %String
{
	n (StatusCode, ArReqItmId,InPartID,UserID)
	s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s Arreqid = +ArReqItmId
	s CH = $p(ArReqItmId,"||",2)
	s DataList=[]
	s Oeori=$p(^DHCAPREP(Arreqid,"AR",CH),"^",3)   /// 检查申请医嘱ID
	s StudyNo = $p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3)),"^",20)
	s:StudyNo="" StudyNo = ##class(web.DHCAPPInterface).GetStudyNoByORORIAndPart(Oeori,InPartID)
	s Position="",Sub=""                           /// 拼接部位串
	s OrdDeptId = $p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),7)),"^",2)	;
	s DeptCode="",DeptDesc=""
	if OrdDeptId'="" s DeptCode=$P($G(^CTLOC(+OrdDeptId)),"^",1)
	if OrdDeptId'="" s DeptDesc=$P($G(^CTLOC(+OrdDeptId)),"^",2)
	f  s Sub = $o(^DHCAPREP(Arreqid,"AR",CH,"PA",Sub)) q:Sub=""  d
	.s PartID = $p(^DHCAPREP(Arreqid,"AR",CH,"PA",Sub),"^",1)
	.q:(InPartID'="")&&(InPartID'=PartID)
	.s PartDesc = $p(^DHCAPPART(PartID),"^",2)
	.s:Position'="" Position =Position_"@@"_PartDesc
	.s:Position="" Position =PartDesc
	s DymObj={}
	s DymObj.OEOrdItemID =Oeori
	s DymObj.Position =Position
	s DymObj.ExamID =StudyNo
	s DymObj.Status =StatusCode
	s DymObj.UserID =UserCode
	s DymObj.UserName =UserName
	s DymObj.UpDateTime =$zd(+$h,3)_" "_..%ZT(..%SysTime(),2)
	s DymObj.OperateDeptCode =DeptCode
	s DymObj.OperateDept =DeptDesc
	s DymObj.SourceSystem ="HIS"
	d DataList.%Push(DymObj)
	
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Steam)
	Q 0
}

/// Creator :  qqa 
/// Descript:  获取当前检查病理当前状态
/// Input: OEOrdItemID:医嘱ID   ExamID: 检查号
/// w ##Class(web.DHCAPPInterface).GetExaReqItmStatus("119||95","","颅颈交界")
ClassMethod GetExaReqItmStatus(OEOrdItemID, ExamID, Position = "") As %String
{
	n (OEOrdItemID,ExamID,Position)
	s DataList=[]
	s DymObj={}
	s DymObj.OEOrdItemID =OEOrdItemID
	s DymObj.ExamID =ExamID
	s DymObj.Position= Position
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s RetSteam = ##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",Steam)
	s RetString = RetSteam.Read()
	q:$find(RetString,"ResultCode") ""
	s RetArr =[]
	s RetArr = RetArr.%FromJSON(RetString)
	s RetObj = RetArr.%Get(0)
	s RetStatus = RetObj.Status
	Q RetStatus
}

/// Creator :  qqa 
/// Descript:  获取当前检查病理当前状态对象
/// Input: OEOrdItemID:医嘱ID   ExamID: 检查号
/// w ##Class(web.DHCAPPInterface).GetExaReqItmStatus("257||39","")
ClassMethod GetExaReqItmStatusObj(OEOrdItemID, ExamID) As %String
{
	n (OEOrdItemID,ExamID)
	s DataList=[]
	s DymObj={}
	s DymObj.OEOrdItemID =OEOrdItemID
	s DymObj.ExamID =ExamID
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s RetSteam = ##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",Steam)
	s RetString = RetSteam.Read()
	q:$find(RetString,"ResultCode") ""
	s RetArr =[]
	s RetArr = RetArr.%FromJSON(RetString)
	s RetObj = RetArr.%Get(0)
	;s RetStatus = RetObj.Status
	Q RetObj
}

/// Creator :  qqa 
/// Descript:  修改检查检验病理的申请状态调用集成平台方法
/// Input:     StatusCode：状态代码  ArReqItmId：申请单子表ID  InPartID：部位ID  LgParam：UserID
/// w ##Class(web.DHCAPPInterface).UpdExaReqItmStatus("OCA","295||1","",4634)
ClassMethod UpdExaReqItmStatusOrd(StatusCode, OrdItmID, InPartID, UserID) As %String
{
	n (StatusCode, OrdItmID,InPartID,UserID)
	s Ret=""
	s ArReqID=$o(^DHCAPREP(0,"OrdItem",OrdItmID,""))    /// 检查申请ID
	Q:ArReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",OrdItmID,ArReqID,"")) /// 检查申请医嘱项Child
	Q:CH="" ""
	s ArRepItmID = ArReqID_"||"_CH
	s Ret = ##Class(web.DHCAPPInterface).UpdExaReqItmStatus(StatusCode,ArRepItmID,InPartID,UserID)
	q Ret
}

/// /w ##class(web.DHCAPPInterface).GetStudyNoByORORIAndPart("4||4","")
ClassMethod GetStudyNoByORORIAndPart(OEORIId, PartID)
{
	n (OEORIId,PartID)
	s StudyNo=""
	s RegInfoDr=""
	f  s RegInfoDr=$o(^DHCPACRegInfoi("OEORI",OEORIId,RegInfoDr)) q:RegInfoDr=""  d
	.s:PartID="" StudyNo = $p(^DHCPACRegInfo(RegInfoDr),"^",2) 
	.q:StudyNo'=""
	.s ChildSub=""
	.f  s ChildSub =  $o(^DHCPACRegInfoBD("BODYPARTS",0,RegInfoDr,ChildSub)) q:(ChildSub="")||(StudyNo'="")  d
	..s PartDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,RegInfoDr,ChildSub),"^",1)
	..q:PartID'=PartDr
	..s StudyNo = $p(^DHCPACRegInfo(RegInfoDr),"^",2)
	q StudyNo
}

/// Descript:  通过检查申请单现病史、生命体征、检查目的(PAC组调用)
/// Input:     oeori-医嘱ID
/// OutPut:    检查目的^现病史^生命体征
/// w ##Class(web.DHCAPPInterface).GetExaReqDesDet("39||160")
ClassMethod GetExaReqDesDet(OrdItem As %String) As %String
{
	n (OrdItem)
	Q:OrdItem="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",OrdItem,""))     /// 检查申请ID
	Q:arReqID="" ""
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)            /// 就诊ID
	s arExaReqPurp=$g(^DHCAPREP(arReqID,"Purpose")) //$p(^DHCAPREP(arReqID),"^",20)        /// 检查目的
	s arPatHis=""
	s arPatHisID=$o(^DHCAPPREH(0,"ADM",EpisodeID,""),-1)
	i arPatHisID '= "" d
	.s arPatHis=$g(^DHCAPPREH(arPatHisID,"History")) //$p(^DHCAPPREH(arPatHisID),"^",2)         /// 现病史
	s arPatSigns=""
	s arPatSignsID=$o(^DHCAPPATSI(0,"ADM",EpisodeID,""),-1)
	i arPatSignsID '= "" d
	.s arPatSigns=$g(^DHCAPPATSI(arPatSignsID,"Sings")) //$p(^DHCAPPATSI(arPatSignsID),"^",2)     /// 体征
	Q arExaReqPurp_"^"_arPatHis_"^"_arPatSigns
}

/// Descript:  获取检查申请的预约状态(医嘱是否需要预约)(调用PAC组接口)
/// Input:     arReqID-检查申请报告ID
/// OutPut:    
/// w ##Class(web.DHCAPPInterface).GetExaReqAppFlag("85426")
ClassMethod GetExaReqAppFlag(arReqID As %String) As %String
{
	n (arReqID)
	s OeoriList=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)   /// 检查申请医嘱ID
	.i OeoriList="" s OeoriList=oeori
	.E  s OeoriList=OeoriList_"@"_oeori
	/// 医嘱rowid串(用@分隔)
	s RetFlag=##class(web.DHCRisResApptSchudleSystem).IsOpenBookWin(OeoriList)
	Q RetFlag
}

/// Descript:  获取检查申请的结果状态(是否有报告)(调用PAC组接口)
/// Input:     医嘱rowid串(用@分隔)
/// OutPut:    
/// w ##Class(web.DHCAPPInterface).GetExaReqRetFlag("")
ClassMethod GetExaReqRetFlag(arReqID As %String) As %String
{
	n (arReqID)
	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" ""
	s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)   /// 检查申请医嘱ID
	Q:oeori="" ""
	s RetFlag=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(RetFlag="IM")  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) /// 部位ID
	.s RetFlag=##class(web.DHCRisResourceApptSchudleInterface).IsHaveReport(oeori,PartID)
	.
	Q RetFlag
}

/// Descript:  获取检查申请的结果状态(是否有报告)(调用PAC组接口)
/// Input:     医嘱rowid串(用@分隔)
/// OutPut:    
/// w ##Class(web.DHCAPPInterface).GetOeoriRetFlag("")
ClassMethod GetOeoriRetFlag(arReqID As %String, CH As %String) As %String
{
	n (arReqID, CH)
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s $ZT="RetErrMsg"
	s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3) /// 项目医嘱ID
	s RetFlag=""
	i $o(^DHCAPREP(arReqID,"AR",CH,"PA","")) D
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(RetFlag="IM")  D
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) /// 部位ID
	..;s RetFlag=##class(web.DHCRisResourceApptSchudleInterface).IsHaveReport(oeori,PartID)
	..s PartItmDesc = $p($g(^DHCAPPART(PartID)),"^",2) 
	..s apStatus = ##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,"",PartItmDesc)
	..i apStatus="RP" s RetFlag="IM"
	.
	E  D
	.;s RetFlag=##class(web.DHCRisResourceApptSchudleInterface).IsHaveReport(oeori,"")
	.s apStatus = ##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,"","")
	.i apStatus="RP" s RetFlag="IM"
	.
	Q RetFlag
RetErrMsg
 	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-17
/// Descript:     检验医嘱是否出报告
/// InPut:        Oeori - 医嘱ID
/// W ##Class(web.DHCAPPInterface).GetOeLabRepFlag("92||3")
ClassMethod GetOeLabRepFlag(Oeori As %String) As %String
{
	n (Oeori)
	//报告ID
	s LabTestSetRow=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",35)
	s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	s LabEpisode=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",20) 
	Q:LabEpisode="" "N"
	s VisitnumberReportDR="",AuthDate="",AuthTime=""
	s OutPutReportDR=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode)
	Q:OutPutReportDR="" "N"
	Q "Y"
	/*i $l(LabTestSetRow) s VisitnumberReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),11)
	Q:VisitnumberReportDR="" "N"
	s SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),44)
	Q:SplitStatus="2" "N"
	Q "Y"*/
}

/// Descript:  取医嘱是否需要预约(调用PAC组接口)
/// Input:     医嘱rowid串(用@分隔)
/// w ##Class(web.DHCAPPInterface).IsOpenBookWin("")
ClassMethod IsOpenBookWin(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s Adm=$p(^OEORD(+oeori),"^",1)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s ShowFlag=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("OpenAppionment",AdmHospitalId)
	q:ShowFlag="OpenAppionmentN" ""
	/*s $ZT="BookErrMsg"
	s IsFlag=##class(web.DHCRisResApptSchudleSystem).IsOpenBookWin(oeori)*/
	s XMlStr="<Request>"
	s XMlStr=XMlStr_"<Header>"
	s XMlStr=XMlStr_"<SourceSystem>SYS0001</SourceSystem>"
	s XMlStr=XMlStr_"<MessageID></MessageID>"
	s XMlStr=XMlStr_"</Header>"
	s XMlStr=XMlStr_"<Body>"
	s XMlStr=XMlStr_"<OpenBookWinRt>"
	s XMlStr=XMlStr_"<OEORIOrderItemID>"_oeori_"</OEORIOrderItemID>"
	s XMlStr=XMlStr_"<UpdateUserCode></UpdateUserCode>"
	s XMlStr=XMlStr_"<UpdateDate></UpdateDate>"
	s XMlStr=XMlStr_"<UpdateTime></UpdateTime>"
	s XMlStr=XMlStr_"</OpenBookWinRt>"
	s XMlStr=XMlStr_"</Body>"
	s XMlStr=XMlStr_"</Request>"
	s reXml=##class(web.DHCENS.EnsHISService).DHCHisInterface("IsOpenBookWin",XMlStr)
	s reXml=$P(reXml,"<LogoFlag>",2)
	s reXml=$P(reXml,"</LogoFlag>",1)
	b ;333
	s IsFlag=reXml
	Q IsFlag
BookErrMsg
 	Q ""
}

/// Descript:  查询医嘱的申请状态和预约详情(调用PAC组接口)
/// Input:     医嘱id和身体部位id  (每次传数据只能是1条医嘱加1个部位)
/// OutPut:    
/// w ##Class(web.DHCAPPInterface).GetItemAppStatus("282||3","")
ClassMethod GetItemAppStatus(Oeori As %String, PartCode As %String) As %String
{
	n (Oeori,PartCode)
	s ret=##Class(web.DHCRisResourceApptSchudleInterface).GetItemAppStatusInterface(Oeori,PartCode)
	Q ret
}

/// Descript: 检查医嘱项目是否存在部位(供医生站组调用)(弹出部位选择框)
/// OutPut:   1-是，0-否
/// w ##Class(web.DHCAPPInterface).isExistPart("12627||1")
ClassMethod isExistPart(itmmastid As %String) As %String
{
	n (itmmastid)
	Q:itmmastid="" ""
	s retflag=0
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) Q:(TraID="")||(retflag=1)  D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:(CH="")||(retflag=1)  D
	..s PardID=+$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:PardID=0
	..s retflag=1
	Q retflag
}

/// Descript: 检查医嘱项目是否存在于检查分类树项目(供医生站组调用)(生成申请单)
/// OutPut:   1-是，0-否
/// w ##Class(web.DHCAPPInterface).isExistCheckTree("12627||1")
ClassMethod isExistCheckTree(itmmastid As %String) As %String
{
	n (itmmastid)
	Q:itmmastid="" "0"
	Q:$o(^DHCAPPTRA(0,"Arc",itmmastid,"")) "1"
	Q 0
}

/// Descript:  插入检查申请单(供医生站组调用)
/// Input:     mListData = 就诊ID^申请医生id^开单科室id
///            mListData = mListData!是否加急标志^执行科室ID^开始日期（YYYY-MM-DD）^医嘱项ID^记录唯一标识^部位^后处理^标本@是否加急标志^执行科室ID^开始日期（YYYY-MM-DD）^医嘱项ID^记录唯一标识^部位^后处理^标本
/// OutPut:    申请记录子表RowId^医嘱项ID^记录唯一标识@申请记录子表RowId^医嘱项ID^记录唯一标识-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).InsExaReqNo("369^81^^^838^^^^^N#11035||1^^0^^2!!369^83^^^838^^^^^N#10387||1^^0^^1"
ClassMethod InsExaReqNo(ListData As %String) As %String
{
	n (ListData)
	
	/// 处理数据，同一接收科室合并为一个申请单
	s ListData=##Class(web.DHCAPPInterface).dealInsListData(ListData)
	
	s mdata=""
	s Err = 0
	TS
	s Len = $L(ListData,"!!")   		 /// 检查分类数目
	f i=1:1:Len Q:Err'=0  D
	.s sListData=$p(ListData,"!!",i)
	.s mListData = $p(sListData,"#",1)   /// 申请表主信息
	.s aListData = $p(sListData,"#",2)   /// 医嘱项关联信息
	.s ret=..InsertDoc(mListData, aListData)
	.i +ret<0 s Err=ret
	.q:+ret<0 
	.s mdata=$s(mdata'="":mdata_"@"_ret,1:ret)  ///申请表ID串
	.
	i Err'=0 tro
	q:Err'=0 Err

	TC
	Q mdata
}

/// Descript: 插入检查申请记录
ClassMethod InsertDoc(mListData As %String, aListData As %String) As %String
{
	N (mListData, aListData)

	s Err=0
	s mdata=""
	TS

	/// 检查报告
	s arReqID=##Class(web.DHCAPPExaReport).InsAppRep(mListData)
	i arReqID<0 tro
	q:arReqID<0 arReqID

	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s ret=##Class(web.DHCAPPExaReport).InsArcItemDoc(arReqID,arcListData)
	.i +ret<0 s Err="-1"
	.q:+ret<0
	.s mdata=$s(mdata'="":mdata_"@"_ret,1:ret)
	.
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 现病史
	i $p(mListData,"^",6)'="" d
	.s Err=##Class(web.DHCAPPExaReport).InsPreHis(mListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 体征
	i $p(mListData,"^",7)'="" d
	.s Err=##Class(web.DHCAPPExaReport).InsPatSigns(mListData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 主诉
	i $p(mListData,"^",9)'="" d
	.s Err = ##Class(web.DHCAPPExaReport).InsPatSymptom(mListData)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/// 插入收费项
	s Err = ##Class(web.DHCAPPExaReport).InsExaReqTarItem(arReqID)
	q:Err'=0 "-16"
	
	TC
	Q mdata
}

/// Descript: 插入检查申请记录
/// mPatSymData = 就诊号 _$C(4)_ 现病史 _$C(4)_ 体征 _$C(4)_ 主诉_$C(4)_检查目的;
/// LgParams :用户User
/// ListData = OneListData_$C(1)_OneListData_...
/// OneListData=检查分类项目ID_$C(2)_就诊号_"^"_接收科室ID_"^"_是否加急_"^"_检查目的_"^"_用户ID_"^^^"_用户科室_"^^Y^"_诊断_"^"_慢特病ID_"^"_慢特病诊断
/// OneListData=OneListData_$C(2)_医嘱ID_"^"_体位ID_"^"_部位ID_"^"_后处理ID_"^"_备注_"^^^"_费别ID_"^"_是否加急_"^"_是否医保
ClassMethod Insert(LgParams As %String, ListData As %String, mPatSymData As %String) As %String
{
	N (LgParams, ListData,mPatSymData)

	s Err=0
	s Err=##class(web.DHCAPPExaReport).save("", ListData, mPatSymData, LgParams)
	Q Err
	/*
	/// 检查报告
	s arReqID=##Class(web.DHCAPPExaReport).InsAppRep(mListData)
	i arReqID<0 tro
	q:arReqID<0 arReqID

	/// 医嘱项目
	f i=1:1:$L(aListData,"&&") q:Err'=0  d
	.s arcListData=$p(aListData,"&&",i)
	.s Err=##Class(web.DHCAPPInterface).InsArcItem(arReqID,arcListData)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 现病史
	i $p(mListData,"^",6)'="" d
	.s Err=##Class(web.DHCAPPExaReport).InsPreHis(mListData)
	i Err'=0 tro
	q:Err'=0 "-12"

	/// 体征
	i $p(mListData,"^",7)'="" d
	.s Err=##Class(web.DHCAPPExaReport).InsPatSigns(mListData)
	i Err'=0 tro
	q:Err'=0 "-13"
	
	/// 主诉
	i $p(mListData,"^",9)'="" d
	.s Err = ##Class(web.DHCAPPExaReport).InsPatSymptom(mListData)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	/// 插入收费项目
	s Err =##Class(web.DHCAPPExaReport).InsExaReqTarItem(arReqID)
	i Err'=0 tro
	q:Err'=0 "-14"
	*/
	//D ##Class(web.DHCAPPExaReport).InvokInterface(arReqID)  /// 调用其他相关接口
	Q Err
}

/// Descript:  插入医嘱ID
ClassMethod InsOeori(arReqID As %String, aListData As %String) As %String
{
	n (arReqID, aListData)
	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" "-1"
	s arReqArcID=arReqID_"||"_CH
	s oeori=$p(aListData,"^",5)
	Q:oeori="" "-2"
	&SQL(update DHC_AppRepArc set AR_OrdItem=:oeori where AR_RowID=:arReqArcID)
	Q SQLCODE
}

/// Descript: 保存检查医嘱项信息
ClassMethod InsArcItem(arReqID As %String, arListData As %String) As %String
{
	N (arReqID, arListData)
	
	/// 医嘱项,体位
	s arReqArcID=..InsRepArc(arReqID,arListData)
	q:arReqArcID<0 arReqArcID

	/// 部位
	s arPartListData=$p(arListData,"^",3)
	f i=1:1:$L(arPartListData,"@") q:Err'=0  d
	.s arPartData=$p(arPartListData,"@",i)
	.s Err=##Class(web.DHCAPPExaReport).InsRepPartItem(arReqArcID,arPartData)
	q:Err'=0 "-12"

	/// 后处理
	s arDispListData=$p(arListData,"^",4)
	s Err=##Class(web.DHCAPPExaReport).InsRepDisp(arReqArcID,arDispListData)
	q:Err'=0 "-13"

	q 0
}

/// Descript: 检查报告医嘱项记录表
ClassMethod InsRepArc(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s arItmmastID=$p(ListData,"^",1)     ///医嘱项ID
	s arPosiID="" //$p(ListData,"^",2)   ///体位
	s oeori=$p(ListData,"^",5)           ///医嘱ID
	s arChildSub=$o(^DHCAPREP(arParref,"AR",""),-1)+1

	&SQL(Insert Into DHC_AppRepArc(AR_ParRef_Dr,AR_ChildSub,AR_Arc_Dr,AR_Pos_Dr,AR_OrdItem)
		values(:arParref,:arChildSub,:arItmmastID,:arPosiID,:oeori))
	i SQLCODE'=0  q SQLCODE
	q $p(%ROWID,$C(1))
}

/// Descript:  合并相同检查项目
/// 		   规则:1、按照接收科室分组，一个接收科室一个申请单；
/// W ##Class(web.DHCAPPInterface).dealInsListData("")
ClassMethod dealInsListData(ListData As %String) As %String
{
	n (ListData)
	
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    k itmExaPurp
    s armListData = $p(ListData,"!",1)   /// 申请表主信息
	s itmListData = $p(ListData,"!",2)   /// 医嘱项关联信息
	s Len = $L(itmListData,"@")   		 /// 检查项目数
	f i=1:1:Len  d
	.s arcListData=$p(itmListData,"@",i)
	.s EpisodeID=$p(armListData,"^",1)     /// EpisodeID
	.s arReqDocID=$p(armListData,"^",2)    /// 申请医生ID
	.s arEmgFlag=$p(arcListData,"^",1)     /// 加急标志
	.s arExecLocID=$p(arcListData,"^",2)   /// 执行科室
	.s arReqDate=$p(arcListData,"^",3)     /// 医嘱日期
	.s arItmmastID=$p(arcListData,"^",4)   /// 医嘱项ID
	.s uniqueID=$p(arcListData,"^",5)      /// 唯一标识
	.s arPartID=$p(arcListData,"^",6)      /// 部位
	.s arDispID=$p(arcListData,"^",7)      /// 后处理
	.s arSpecimen=$p(arcListData,"^",8)    /// 标本
	.s itemExaPurp="" //$p(armListData,"^",8)   /// 检查目的
	.s itemCatID=##Class(web.DHCAPPExaReportQuery).GetArcCat(arItmmastID)
	.s index=arExecLocID_"^"_itemCatID_"^"_arReqDate   /// 分单规则
	.
	.i '$d(itmExaPurp(index)) s itmExaPurp(index)=itemExaPurp   /// 重新合并检查目的
	.E  s itmExaPurp(index)=itmExaPurp(index)_"、"_itemExaPurp
	.
	.i (arEmgFlag="Y")&'$d(itmExaEmgFlag(index)) s itmExaEmgFlag(index)="Y"     /// 加急标志
	.s index2=arItmmastID_"^"_arDispID_"^"_uniqueID_"^"_arSpecimen
	.i arPartID="" s arPartID=0
	.s index3=arPartID
	.s mListData=EpisodeID_"^"_arExecLocID_"^^^"_arReqDocID_"^^^^^N" /// 单据主信息
	.s ^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index)=mListData
	.s ^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index,index2)=""
	.s ^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index,index2,index3)=""
	.

	s ListData=""
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index)) Q:index=""  D
	.s itmExaArcList=""
	.s mListData=$g(^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index))
	.s $p(mListData,"^",3)=$g(itmExaEmgFlag(index))   /// 设置加急标志
	.s $p(mListData,"^",4)=$g(itmExaPurp(index))      /// 设置检查目的
	.s index2=""
	.f  s index2=$o(^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index,index2)) Q:index2=""  D
	..s itmmmastid=$p(index2,"^",1)    /// 医嘱项ID
	..s itemExaDispID=$p(index2,"^",2) /// 后处理
	..s itemUniqueID=$p(index2,"^",3)  /// 唯一标识
	..s itemSpecimen=$p(index2,"^",4)  /// 标本
	..s itemExaPartID=""
	..s index3=""   /// index3 - PartID_"^"_arPosiList
	..f  s index3=$o(^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid,index,index2,index3)) Q:index3=""  D
	...i itemExaPartID="" s itemExaPartID=index3
	...E  s itemExaPartID=itemExaPartID_"@"_index3
	..s itmmastList=itmmmastid_"^"_""_"^"_itemExaPartID_"^"_itemExaDispID_"^^"_itemUniqueID_"^"_itemSpecimen
	../// 组织申请单项目串
	..i itmExaArcList="" s itmExaArcList=itmmastList
	..E  s itmExaArcList=itmExaArcList_"&&"_itmmastList
	.
	.i ListData="" s ListData=mListData_"#"_itmExaArcList
	.E  s ListData=ListData_"!!"_mListData_"#"_itmExaArcList
	.
	d ..killTmpGlobal(pid) //k掉临时global
	Q ListData
}

/// Descript:  更新申请单状态和收费项目表(供医生站组调用)
/// Input:     oeori = 医嘱ID,PartID=部位ID,UserID=用户
/// OutPut:    0-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).StopOrderInvExaReqNo("51||158","","4634")
ClassMethod StopOrderInvExaReqNo(Oeori As %String, PartID As %String, UserID As %String) As %String
{
	n (Oeori, PartID, UserID)
	/// 医嘱项ID
	s arcimid=##Class(web.DHCAPPPisInterface).GetArcimID(Oeori)
	Q:arcimid="" ""
	/// 检查分类类型 P - 病理，E - 检查
	s Type=##Class(web.DHCAPPExaReportQuery).GetTraType(arcimid)
	Q:Type="" ""
	
	///修改申请单状态
	s Err=0
	i Type="P" D
	.s Err=..revPisNo(Oeori, UserID)
	E  D
	.s Err=..revExaNo(Oeori, PartID, UserID)
	///平台方法修改状态
	i Type="P" D
	.s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	.s Ret = ##Class(web.DHCAPPPisInterface).UpdExaReqItmStatusOrd("OCA",Oeori,UserID)
	E  D
	.s Ret = ##Class(web.DHCAPPInterface).UpdExaReqItmStatusOrd("OCA",Oeori,PartID,UserID)
	
	Q Err
	
#;	/// 注释 增加停止调用病理申请 bianshuai
#;	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
#;	Q:arReqID="" ""
#;	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,"")) /// 检查申请医嘱项Child
#;	Q:CH="" ""
#;	s Err=0
#;	
#;	TS
#;	s Sub=""
#;	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
#;	.s arItmPartID=arReqID_"||"_CH_"||"_Sub
#;	.s sPartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
#;	.Q:(PartID'="")&(PartID'=sPartID)
#;	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)    /// 执行状态
#;	.Q:ExeStat'="V"
#;	.s Err=##Class(web.DHCAPPExaReport).SetExaReqPartStat(arItmPartID,"D",UserID)  /// 设置部位状态
#;	.
#;	i Err'=0 tro
#;	Q:Err'=0 "-11"
#;	
#;	s Err=##Class(web.DHCAPPExaReport).SetExaReqTarItm(arReqID_"||"_CH,PartID)     /// 重新计算费用
#;	i Err'=0 tro
#;	Q:Err'=0 "-12"
#;	TC
#;	
#;	Q Err
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-19
/// Descript:     更新申请单状态和收费项目表(供医生站组调用)
/// Input:        oeori = 医嘱ID,PartID=部位ID,UserID=用户
/// OutPut:       0-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).revExaNo("oeori","PartID","UserID")
ClassMethod revExaNo(Oeori As %String, PartID As %String, UserID As %String)
{
	n (Oeori, PartID, UserID)
	
	s arReqID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))    /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",Oeori,arReqID,"")) /// 检查申请医嘱项Child
	Q:CH="" ""
	s Err=0
	
	TS
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	.s arItmPartID=arReqID_"||"_CH_"||"_Sub
	.s sPartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	.Q:(PartID'="")&(PartID'=sPartID)
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)    /// 执行状态
	.Q:ExeStat'="V"
	.s Err=##Class(web.DHCAPPExaReport).SetExaReqPartStat(arItmPartID,"D",UserID)  /// 设置部位状态
	.
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	s Err=##Class(web.DHCAPPExaReport).SetExaReqTarItm(arReqID_"||"_CH,PartID)     /// 重新计算费用
	i Err'=0 tro
	Q:Err'=0 "-12"
	TC
	
	Q Err
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-19
/// Descript:     撤销病理申请单(供医生站组调用)
/// Input:        oeori = 医嘱ID,PartID=部位ID,UserID=用户
/// OutPut:       0-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).revPisNo("oeori","UserID")
ClassMethod revPisNo(Oeori As %String, UserID As %String)
{
	n (Oeori, UserID)
	s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	Q:PisID="" ""
	Q:'$D(^DHCAPPPM(PisID)) "-2"
	s SendPisFlag=##Class(web.DHCAppPisMasterQuery).GetSendPisFlag(PisID)
	Q:SendPisFlag=1 "-3"
	TS
	/// 更新申请单状态
	s Err=##Class(web.DHCAppPisMaster).UpdPisMasStatus(PisID, UserID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
#;	/// 调用停医嘱接口
#;	s Err=..InvPisStopOrder(PisID, UserID)
#;	i Err'=0 tro
#;	q:Err'=0 "-12"
	TC

	Q Err
}

/// Creator：  bianshuai
/// CreatDate：2016-07-26
/// Descript:  获取检查申请单部位数据(供PAC调用)
/// Table:     DHC_AppReport,DHC_AppRepArc,DHC_AppRepPart
/// Input:     oeori = 医嘱ID
/// OutPut:    部位列表
/// w ##Class(web.DHCAPPInterface).GetExaReqPart("2495||5")
ClassMethod GetExaReqPart(oeori As %String) As %String
{
	n (oeori)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))     /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:ExeStat="D"
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s arPosi=..GetPartConsPosi(arPartID)
	.if ($G(ArrExaReq(PartID))="") s ArrExaReq(PartID)=arPosi
	.e  s ArrExaReq(PartID)=$G(ArrExaReq(PartID))_","_arPosi
	s ListData=""
	s PartID=""
	for {
		s PartID=$o(ArrExaReq(PartID))
		q:PartID=""
		if ListData="" s ListData=PartID_"#"_$g(ArrExaReq(PartID))
		E  s ListData=ListData_"^"_PartID_"#"_$g(ArrExaReq(PartID))
		}
	Q ListData
}

/// Descritp:	部位关联体位ID
/// W ##Class(web.DHCAPPInterface).GetPartConsPosi("4||1||1")
ClassMethod GetPartConsPosi(arPartID As %String) As %String
{
	n (arPartID)
	s tempPosi=""
	s arPosiID=""
	f  s arPosiID=$o(^DHCAPREPO(0,"RepPart",arPartID,arPosiID)) Q:arPosiID=""  D
	.s PosiID=$p(^DHCAPREPO(arPosiID),"^",2)
	.Q:PosiID=""
	.i tempPosi = "" s tempPosi=PosiID
	.e  s tempPosi=tempPosi_","_PosiID
	Q tempPosi
}

/// Creator：  bianshuai
/// CreatDate：2016-07-26
/// Descript:  获取检查申请单单部位执行状态(供PAC调用)
/// Table:     DHC_AppReport,DHC_AppRepArc,DHC_AppRepPart
/// Input:     oeori - 医嘱ID, PartID - 部位ID
/// OutPut:    状态代码
/// w ##Class(web.DHCAPPInterface).GetExaReqPartExeStatus("3||94","200")
ClassMethod GetExaReqPartExeStatus(oeori As %String, PartID As %String) As %String
{
	n (oeori, PartID)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ExeStatCode=""
	i +PartID'=0 D
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s InPartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	..Q:PartID'=InPartID
	..s adrPartID=arReqID_"||"_CH_"||"_Sub
	..s ExeStatCode=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	E  D
	.s ItemStatID=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
	.Q:ItemStatID=""
	.s ExeStatCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
	Q ExeStatCode
}

/// Creator：  bianshuai
/// CreatDate：2016-07-26
/// Descript:  通过医嘱获取申请单号(供PAC调用)
/// Table:     DHC_AppReport
/// Input:     oeori - 医嘱ID
/// OutPut:    申请单号
/// w ##Class(web.DHCAPPInterface).GetExaReqNo("3||68")
ClassMethod GetExaReqNo(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,"")) /// 检查申请ID
	Q:arReqID="" ""
	s ExaReqNo=$p($G(^DHCAPREP(arReqID)),"^",1)       /// 申请单号
	Q ExaReqNo
}

///  CreateDate：bianshuai
///  CreatDate： 2016-07-26
///  Descript:   获取报告医嘱项目信息(供其他组调用、PAC登记界面使用)
///  InPut:      医嘱ID
///  OutPut：    医嘱项ID:医嘱项目描述^体位ID:体位描述^部位1ID:部位1描述!部位2ID:部位2描述^后处理1ID:后处理1描述!后处理2ID:后处理2描述
///  w ##Class(web.DHCAPPInterface).GetExaReqPartItm("2495||5")
ClassMethod GetExaReqPartItm(orditem As %String) As %String
{
	n (orditem)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",orditem,""))
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",orditem,arReqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	
	s PosiDesc=""
	s PosiID=$p(^DHCAPREP(arReqID,"AR",CH),"^",2)     	   ///体位ID
	s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	   ///体位
	
	s PartList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) /// 部位ID
	.Q:PartID=0
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:ExeStat="D"
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 		     /// 部位
	.i PartList'="" s PartList=PartList_"^"_PartID_":"_PartDesc
	.E  s PartList=PartID_":"_PartDesc
	
	s DispMList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispMID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1)      ///后处理ID
	.Q:DispMID=""
	.s DispMDesc=$p($g(^DHCAPDIM(DispMID)),"^",2) 				  ///后处理描述
	.i DispMList'="" s DispMList=DispMList_"!"_DispMID_":"_DispMDesc
	.E  s DispMList=DispMID_":"_DispMDesc
	
	s ListData=arcimid_":"_arcitmdesc_"^"_PosiID_":"_PosiDesc_"^"_PartList_"^"_DispMList
	Q ListData
}

///  CreateDate：bianshuai
///  CreatDate： 2016-07-26
///  Descript:   取医嘱项目对应部位(医嘱界面使用)
///  InPut:      医嘱ID
///  OutPut：    部位1 + 部位2 + 部位2 
///  w ##Class(web.DHCAPPInterface).GetExaReqPartDesc("30152||81")
ClassMethod GetExaReqPartDesc(oeori As %String) As %String
{
	n (oeori,%session)
	Q:oeori="" ""
	Set langid=..%LanguageID()
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:ExeStat="D"
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 		     /// 部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.i ListData'="" s ListData=ListData_" + "_PartDesc
	.E  s ListData=" "_PartDesc

	Q ListData
}

///  CreateDate：bianshuai
///  CreatDate： 2016-07-26
///  Descript:   取医嘱项目名称(提供给其他组调用)
///  InPut:      医嘱ID
///  OutPut：    医嘱名称 + 后处理 【 部位1(体位) 、部位2 、部位2】 
///  w ##Class(web.DHCAPPInterface).GetExaReqItemDesc("751||606","","12690||3||1")
ClassMethod GetExaReqItemDesc(oeori As %String, PartFlag As %String = "") As %String
{
	n (oeori, PartFlag,%session)
	Set langid=..%LanguageID()
	Q:oeori="" ""
	Q:'$d(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)) ""
	s arcimid=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2) /// 医嘱项ID
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	s reqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      	  /// 检查申请ID
	Q:reqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,reqID,""))        /// 检查申请医嘱项Child
	Q:CH="" ""
	
	s TmpPartDesc=""
	s Sub=""
	F  s Sub=$o(^DHCAPREP(reqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	.Q:PartID=""
	.s ExeStat=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:(ExeStat="D")&(PartFlag="")
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 			   ///部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.s arPartID=reqID_"||"_CH_"||"_Sub						
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	.i TmpPartDesc'="" s TmpPartDesc=TmpPartDesc_"、"_PartDesc
	.E  s TmpPartDesc=PartDesc
	s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(reqID_"||"_CH) ///后处理
	i DispDesc'="" s arcitmdesc=arcitmdesc_" + "_DispDesc
	i TmpPartDesc'="" s arcitmdesc=arcitmdesc_"【"_TmpPartDesc_"】"

	Q arcitmdesc
}

ClassMethod GetExaReqItemDescNoOrder(oeori As %String, PartFlag As %String = "") As %String
{
	n (oeori, PartFlag,%session)
	Set langid=..%LanguageID()
	Q:oeori="" ""
	Q:'$d(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)) ""
	s arcimid=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2) /// 医嘱项ID
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	//s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	s arcitmdesc=""
	s reqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      	  /// 检查申请ID
	Q:reqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,reqID,""))        /// 检查申请医嘱项Child
	Q:CH="" ""
	
	s TmpPartDesc=""
	s Sub=""
	F  s Sub=$o(^DHCAPREP(reqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	.Q:PartID=""
	.s ExeStat=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	.Q:(ExeStat="D")&(PartFlag="")
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 			   ///部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.s arPartID=reqID_"||"_CH_"||"_Sub						
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	.i TmpPartDesc'="" s TmpPartDesc=TmpPartDesc_"、"_PartDesc
	.E  s TmpPartDesc=PartDesc
	s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(reqID_"||"_CH) ///后处理
	i DispDesc'="" s arcitmdesc=arcitmdesc_DispDesc
	i TmpPartDesc'="" s arcitmdesc=arcitmdesc_"【"_TmpPartDesc_"】"

	Q arcitmdesc
}

///  CreateDate：bianshuai
///  CreatDate： 2016-07-26
///  Descript:   医嘱备注(保存医嘱时使用)
///  InPut:      申请单ID
///  w ##Class(web.DHCAPPInterface).GetExaReqPartNote("331||1")
ClassMethod GetExaReqPartNote(arReqItmID As %String) As %String
{
	n (arReqItmID)
	s arReqID=$p(arReqItmID,"||",1)
	s CH=$p(arReqItmID,"||",2)
	Q:arReqID="" ""
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""

	s PartList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	.Q:PartID=0
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 /// 部位
	.s arPartID=arReqID_"||"_CH_"||"_Sub
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.i PartList'="" s PartList=PartList_"+"_PartDesc_"["_PosiDesc_"]"
	.E  s PartList=PartDesc_"["_PosiDesc_"]"
	
	s DispMList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1)   /// 后处理ID
	.Q:DispID=""
	.s DispDesc=$p(^DHCAPDIM(DispID),"^",2) 				  /// 后处理描述
	.i DispMList'="" s DispMList=DispMList_"、"_DispDesc
	.E  s DispMList=DispDesc
	
	s ListData=PartList_" "_DispMList
	Q ListData
}

/// Descript:  获取检查申请医嘱对应部位计费状态(供PAC调用)
/// Input:     oeori-医嘱ID,PartID-部位ID
/// OutPut:    计费状态
/// w ##Class(web.DHCAPPInterface).GetExaReqPartBilled("2||1","")
ClassMethod GetExaReqPartBilled(oeori As %String, PartID As %String) As %String
{
	n (oeori,PartID)
	s PartTarBilled=""
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:(TarID="")||(PartTarBilled'="")  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)    /// 部位ID
	.//Q:(PartID'="")&(TarPartID'=PartID)        /// 筛选部位
	.Q:TarPartID'=PartID          				 /// 筛选部位
	.s PartTarBilled=TarBilled
	.
	Q PartTarBilled
}

/// Descript: 发送数据到PAC接口
/// w ##Class(web.DHCAPPInterface).SendExaReqNoToPAC("11975")
ClassMethod SendExaReqNoToPAC(arReqID As %String) As %String
{
	n (arReqID)
	s OrdListData=""
	s CH="",PartFlag="Y"
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s PartFlag="Y"
	.s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)   /// 检查申请医嘱ID
	.i $o(^DHCAPREP(arReqID,"AR",CH,"PA","")) s PartFlag="N"
	.s ExaReqNoXml=##Class(web.DHCAPPInterface).GetExaReqNoXml(arReqID,oeori) /// 申请单内容XML串
	.d ##Class(RISService.InvokeRISService).InsertAppPACS(oeori,ExaReqNoXml,PartFlag)
	q ""
}

/// Descript:  获取检查申请XML串
/// w ##Class(web.DHCAPPInterface).GetExaReqNoXml("3029")
ClassMethod GetExaReqNoXml(ExaReqID, moeori = "") As %String
{
	n (ExaReqID, moeori)
	s $zt="ErrorMsg"
	s Xml=""
	s ExaReqNoObj=##class(web.DHCAPPExaReqModelPAC).%New()
	
	s arReqData=$p(^DHCAPREP(ExaReqID),"^",2)         /// 申请日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //hxy 2017-04-01 $zd(arReqData,3)
	s arExLocID=$p(^DHCAPREP(ExaReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)          /// 执行科室
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s arPurpose=$g(^DHCAPREP(ExaReqID,"Purpose"))        /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(ExaReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"1",1:"0")
	s arUser=""
	s arUserID=$p(^DHCAPREP(ExaReqID),"^",4)          /// 申请人
	s:arUserID'="" arUser=$p(^SSU("SSUSR",arUserID),"^",2)
	s arUser=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUser) /// 去掉英文字母
	/*s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"ADM",EpisodeID,""))   /// 现病史
	i arHisID'="" s arHisDesc=$p(^DHCAPPREH(arHisID),"^",2)
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"ADM",EpisodeID,""))  /// 体征
	i arSigID '= "" s arSigDesc=$p(^DHCAPPATSI(arSigID),"^",2)
	s arSymDesc=""
	s arSymID=$o(^DHCAPPATSY(0,"ADM",EpisodeID,""))  /// 主诉
	i arSymID '= "" s arSymDesc=$p(^DHCAPPATSY(arSymID),"^",2)*/
	s arHisDesc="",arSigDesc="",arSymDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",ExaReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigID=$o(^DHCAPPATSI(0,"REQ",ExaReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",ExaReqID,""))
	i arExaReqSymID'="" s arSymDesc=$G(^DHCAPPATSY(arExaReqSymID,"Symptom")) /// 主诉
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)      /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s InPatNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg)  /// 住院号
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s CardNo=##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID)
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)        /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)   /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //$zd(PatBDay,3)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s MedicareNo=InPatNo ;##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)  ///病案号
	s PatType=$p(^PAADM(EpisodeID),"^",2)        /// 就诊类型
	s PatType=$s(PatType="I":"住院",PatType="O":"门诊",PatType="E":"急诊",1:"")
	s PatWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	s PatHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) //身高
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) //病区
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2)
	s PatBed=""
	s PatBedID=$p(^PAADM(EpisodeID),"^",73) //床号
	i PatBedID'="" s PatBed=$p(^PAWARD($p(PatBedID,"||",1),"BED",$p(PatBedID,"||",2)),"^",1)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) //科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	s HospID=""
	i PatLocID'="" s HospID=+$p(^CTLOC(PatLocID),"^",22)  /// 医院ID
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	s PatAddress=$g(^PAPER(PatientID,"PER","ADD",1)) /// 家庭住址
	
	s arItemDesc="",OeoriList=""
	s CH=""
	f  s CH=$o(^DHCAPREP(ExaReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",1)         ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s Oeori=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",3)     	    ///医嘱ID
	.Q:(moeori'="")&(Oeori'=moeori)
	.i OeoriList="" s OeoriList=Oeori
	.E  s OeoriList=OeoriList_"@"_Oeori
	.s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.Q:(ItemStat="D")||(ItemStat="C")   /// 临嘱 住院为撤销、门诊为停止
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(ExaReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPREP(ExaReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	..Q:PartID=""
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				   ///部位
	..s arPartID=ExaReqID_"||"_CH_"||"_Sub
	..s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	..i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	..i PartList'="" s PartList=PartList_"、"_PartDesc
	..E  s PartList=PartDesc
	.
	.s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(ExaReqID_"||"_CH) ///后处理
	.
	.s ItemLabel=arcitmdesc
	.i DispDesc'="" s ItemLabel=ItemLabel_" + "_DispDesc
	.i PartList'="" s ItemLabel=ItemLabel_" ["_PartList_"]"
	.
	.i arItemDesc="" s arItemDesc=ItemLabel
	.E  s arItemDesc=arItemDesc_","_ItemLabel
	
	s ExaReqNoCost=##Class(web.DHCAPPExaReportQuery).GetExaReqNoCost(ExaReqID) /// 申请单总金额
	
	s ExaTypeDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ExaReqID,1,HospID)

	s ExaReqNoObj.MedicareNo=MedicareNo ///  病案号
	s ExaReqNoObj.CardNo=CardNo    		///  卡号
	s ExaReqNoObj.InsuranceNo=""     	///  医保卡号
	s ExaReqNoObj.RegNo=PatNo    		///  登记号
	s ExaReqNoObj.Name=PatName    		///  姓名
	s ExaReqNoObj.Sex=PatSex            ///  性别
	s ExaReqNoObj.DOB=PatBDay           ///  生日
	s ExaReqNoObj.Age=PatAge            ///  年龄
	s ExaReqNoObj.PWeight=PatWeight     ///  体重
	s ExaReqNoObj.PHeight=PatHeight     ///  身高
	s ExaReqNoObj.Ward=PatWard          ///  病房
	s ExaReqNoObj.BedNo=PatBed          ///  床号
	s ExaReqNoObj.InLoc=PatLoc          ///  申请科室
	s ExaReqNoObj.AppDoc=arUser         ///  开单医生
	s ExaReqNoObj.RecLoc=arRepExLoc     ///  执行科室
	s ExaReqNoObj.AppDate=arReqData     ///  申请日期
	s ExaReqNoObj.TelNo=PatTelH         ///  电话
	s ExaReqNoObj.address=PatAddress    ///  住址
	s ExaReqNoObj.OrdName=arItemDesc    ///  医嘱名称
	s ExaReqNoObj.price=ExaReqNoCost    ///  总价格
	s ExaReqNoObj.TypeDesc=PatType      ///  病人类型
	s ExaReqNoObj.PatLevel=""           ///  病人等级
	s ExaReqNoObj.EncryptLevel=""       ///  秘密等级
	s ExaReqNoObj.OEorditemID=OeoriList ///  医嘱Rowid
	s ExaReqNoObj.ungent=arEmgFlag      ///  是否加急
	s ExaReqNoObj.PatientNow="现病史:"_arHisDesc_" 主诉:"_arSymDesc_" 体征:"_arSigDesc  ///  病史及临床所见
	s ExaReqNoObj.MainDiagose=PatDiag   ///  主诊断
	s ExaReqNoObj.purpose=arPurpose     ///  检查目的
	s ExaReqNoObj.HopeDate=..%SysDate()          ///  期望日期
	s ExaReqNoObj.Content10=InPatNo     ///  住院号
	s ExaReqNoObj.Content11=ExaTypeDesc ///  检查类型

	S Status=ExaReqNoObj.XMLExportToString(.Xml)
	Q Xml
	
ErrorMsg
	q "-99^"_"程序异常"
}

/// Descript:  更新检查申请部位表退费申请状态(退费申请时调用)
/// InPut:     oeori-医嘱ID,mListData-申请单部位ID串,reqFlag-申请状态Y
/// OutPut:    0-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).SetExaReqFlag("医嘱ID","申请单部位ID串","申请状态Y/N")
ClassMethod SetExaReqFlag(oeori As %String, mListData As %String, reqFlag As %String) As %String
{
	n (oeori,mListData,reqFlag)
	Q:(oeori="")||(reqFlag="") ""
	s Len=$L(mListData,"!!")
	s Err=0
	TS
	f i=1:1:Len Q:Err'=0  D
	.s arRowID=$p(mListData,"!!",i)
	.Q:arRowID=""
	.s Err=##Class(web.DHCAPPExaReport).UpdPartReqFlag(arRowID,reqFlag)
	.
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	s ^DHCDocAPPAPREP("PartStr",oeori)=mListData
	Q Err
}

///  Creator：	 bianshuai
///  CreatDate： 2016-07-26
///  Descript:   取医嘱项目对应部位(计费组使用)
///  InPut:      医嘱ID
///  OutPut：    部位1^部位2^部位2 
///  w ##Class(web.DHCAPPInterface).GetReqPartID("1271||7")
ClassMethod GetReqPartID(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.Q:$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)="D"
	.s reqFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",6) /// 退费申请
	.Q:reqFlag'="Y"
	.i ListData'="" s ListData=ListData_"^"_PartID
	.E  s ListData=PartID

	Q ListData
}

/// Flag(1：部分退,0：全退或未退)$C(1)已申请退费$C(1)未进行过申请的
/// w ##Class(web.DHCAPPInterface).GetReqBillPartID("1271||7")
ClassMethod GetReqBillPartID(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))      /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	s ListData=""
	s Sub=""
	s Flag=0
	s PartStr=$g(^DHCDocAPPAPREP("PartStr",oeori))
	s PartListID=""
	if (PartStr'=""){
		for i=1:1:$L(PartStr,"!!") {
			s Arreqid=$P(PartStr,"!!",i)
			continue:(Arreqid="")
			s PartID = $p(^DHCAPREP(+Arreqid,"AR",$P(Arreqid,"||",2),"PA",$P(Arreqid,"||",3)),"^",1)
			if PartListID="" {s PartListID=PartID  }else{  s PartListID=PartListID_"^"_PartID}
		}
		}
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.Q:$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)="D"
	.s reqFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",6) /// 退费申请
	.;Q:reqFlag="Y"
	.s RowID=arReqID_"||"_CH_"||"_Sub
	.s AROrdExecDr=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",9)
	.s StatusCode=""
	.if AROrdExecDr'="" d
	..s StatusRowId=$P($g(^OEORD(+AROrdExecDr,"I",$P(AROrdExecDr,"||",2),"X",$P(AROrdExecDr,"||",3))),"^",16)
	..if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
	.q:((("!!"_PartStr_"!!")[("!!"_RowID_"!!"))&&(StatusCode'="F"))
	.i ListData'="" s ListData=ListData_"^"_PartID
	.E  s ListData=PartID
	.s Flag=1

	Q Flag_$C(1)_PartListID_$C(1)_ListData
}

/// Descript:  提供根据医嘱取已做退费申请的医嘱项目对应部位描述
/// w ##Class(web.DHCAPPInterface).GetReqBillPartIDDesc("1271||7")
ClassMethod GetReqBillPartIDDesc(oeori)
{
	n (oeori)
	s PartStr=$g(^DHCDocAPPAPREP("PartStr",oeori))
	s PartList=""
	if (PartStr'=""){
		for i=1:1:$l(PartStr,"!!") {
			s Arreqid=$P(PartStr,"!!",i)
			continue:Arreqid=""
			s PartID=$p(^DHCAPREP(+Arreqid,"AR",$P(Arreqid,"||",2),"PA",$P(Arreqid,"||",3)),"^",1)
			continue:(PartID="")
			s AROrdExecDr=$p(^DHCAPREP(+Arreqid,"AR",$P(Arreqid,"||",2),"PA",$P(Arreqid,"||",3)),"^",9)
			s StatusCode=""
			if AROrdExecDr'="" d
			.s StatusRowId=$P($g(^OEORD(+AROrdExecDr,"I",$P(AROrdExecDr,"||",2),"X",$P(AROrdExecDr,"||",3))),"^",16)
			.if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
			continue:((StatusCode="E")||(StatusCode="F"))
			s PartDesc=$p(^DHCAPPART(PartID),"^",2)
			i (PartList'="") s PartList=PartList_" + "_PartDesc
			e  s PartList=" "_PartDesc
		}
	}
	q PartList
}

/// Descript:  退费时调用,修改部位表为停止状态，重新计算费用
/// InPut:     oeori-医嘱ID,LgUserID-操作人ID
/// OutPut:    0-成功，其他-失败
/// w ##Class(web.DHCAPPInterface).retInvExaReqNo("674||12","1")
ClassMethod retInvExaReqNo(oeori As %String, LgUserID As %String) As %String
{
	n (oeori, LgUserID)
	s $zt="retInvErrMsg"
	Q:oeori="" ""
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,"")) /// 检查申请医嘱项Child
	Q:CH="" ""
	s Err=0
	
	TS
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:(Sub="")||(Err'=0)  D
	.s arRowID=arReqID_"||"_CH_"||"_Sub
	.s reqFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",6)    /// 退费申请状态
	.Q:reqFlag'="Y"
	.s exeFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)    /// 执行状态
	.Q:exeFlag'="V"
	.s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)     /// 部位ID
	./// 设置部位状态
	.s Err=##Class(web.DHCAPPExaReport).SetExaReqPartStat(arRowID,"D",LgUserID)
	.Q:Err'=0
	./// 修改医嘱执行表状态 【门诊暂时不变执行记录状态】
	.//s Err=##Class(web.DHCAPPExaReport).SetPartExecExt(arRowID,PartID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	s Err=..modOeoriStat(oeori,"I")     /// 修改医嘱计费状态
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	s Err=##Class(web.DHCAPPExaReport).SetExaReqTarItm(arReqID_"||"_CH,"")   /// 重新计算费用
	i Err'=0 tro
	Q:Err'=0 "-13"
	TC
	
	Q Err
retInvErrMsg
	Q "-99"
}

/// Descript:  设置医嘱状态
ClassMethod modOeoriStat(oeori As %String, BillFlag As %String) As %String
{
	n (oeori, BillFlag)
    &SQL(update OE_OrdItem set OEORI_Billed=:BillFlag where OEORI_RowId=:oeori)
    Q SQLCODE
}

/// Descript: 	获取医嘱加急标志
/// Creator:	bianshuai
/// CreateDate: 2017-02-08
/// InPut:  	oeori 医嘱ID
/// OutPut:     Y-加急,N-非加急
/// w ##Class(web.DHCAPPInterface).GetEmgFlag("医嘱ID")
ClassMethod GetEmgFlag(oeori As %String) As %String
{
	n (oeori)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:arReqID="" ""
	s arEmgFlag=$p(^DHCAPREP(arReqID),"^",16)        /// 加急标志
	Q arEmgFlag
}

/// Descript: 	根据申请单子表ID取对应部位
/// Creator:	bianshuai
/// CreateDate: 2017-02-09
/// InPut:  	reqItmID 申请单子表ID
/// OutPut:     ListData-PartID:收费项1id,收费项2id@PartID:收费项3id,收费项4id
/// w ##Class(web.DHCAPPInterface).GetAppRepItm("114||1")
ClassMethod GetAppRepItm(reqItmID As %String) As %String
{
	n (reqItmID)
	Q:reqItmID="" ""
	k TmpPart
	s ListData=""
	s TarID=""
	F  s TarID=$o(^DHCAPREPTA(0,"ReqItm",reqItmID,TarID)) Q:TarID=""  D
	.s Billed=$p(^DHCAPREPTA(TarID),"^",9)  /// 计费状态
	.Q:Billed'="TB"
	.s PartID=+$p(^DHCAPREPTA(TarID),"^",1) /// pointor 指针
	.i '$d(TmpPart(PartID)) s TmpPart(PartID)=PartID_":"_TarID
	.e  s TmpPart(PartID)=$g(TmpPart(PartID))_","_TarID
	.
	
	s index=""
	F  s index=$o(TmpPart(index)) Q:index=""  D
	.Q:'$d(TmpPart(index))
	.i ListData="" s ListData=TmpPart(index)
	.e  s ListData=ListData_"@"_TmpPart(index)
	Q ListData
}

/// Descript: 	更新申请子表接口
/// Creator:	bianshuai
/// CreateDate: 2017-02-09
/// InPut:  	param 申请记录子表RowId^部位id1^执行ID^收费项目表ID^操作用户
/// OutPut:     0 - 成功，其他-失败
/// w ##Class(web.DHCAPPInterface).UpdAppRepItm("1182||1^^1532||4||1^")
ClassMethod UpdAppRepItm(param As %String) As %String
{
	n (param)
	s Err=0
	s TraType=..GetTraCatType(param) /// 医嘱项检查分类类型
	i TraType="P" D
	.s Err=..modPisMasNo(param)      /// 病理申请接口
	E  D
	.s Err=..modExaReqNo(param)      /// 检查申请接口
	Q Err
}

/// Descript: 	发送申请单信息到第三方：供医生站调用,触发时刻为医生站在医嘱彻底完成插入后调用
/// Creator:	qqa
/// CreateDate: 2018-12-17
/// InPut:  	OrdItms:医嘱ID串，登录用户ID
/// OutPut:     0 - 成功，其他-失败
/// f
ClassMethod AppInvokInterface(OrdItms, UserID) As %String
{
	n (OrdItms,UserID)
	s OrdLen = $l(OrdItms,"^")
	f i=1:1:OrdLen d
	.s OrdItm = $p(OrdItms,"^",i)
	.q:OrdItm=""
	.s Params = ""
	.s $p(Params,"^",3)=OrdItm
	.s TraType=..GetTraCatType(Params) /// P/E/L
	.i TraType="P" d
	..s ReqID="0"
	..f  s ReqID=$o(^DHCAPPPM(0,"OrdItem",OrdItm,ReqID)) q:ReqID=""  d
	...s ReqSub="0"
	...f  s ReqSub=$o(^DHCAPPPM(0,"OrdItem",OrdItm,ReqID,ReqSub)) q:ReqSub=""  d
	....s OrdItemFlag=$P($g(^DHCAPPPM(ReqID,"A",ReqSub)),"^",4)
	....q:OrdItemFlag'=1
	....s TMPData("P",ReqID)=OrdItm 
	.e  d
	..s ReqID=$o(^DHCAPREP(0,"OrdItem",OrdItm,""))
	..q:+ReqID=0
	..s TMPData("LE",ReqID)=""
	
	b ;data
	
	//病理调用接口需要逐个调用，检查检验申请可一次全部调用
	s PisID=""
	f  s PisID = $o(TMPData("P",PisID)) q:PisID=""  d
	.d ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",+PisID,UserID) 
	.s Oeori=$G(TMPData("P",PisID))
	.d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000042",Oeori)
	
	s ReqIDs="",ReqID=""
	f  s ReqID = $o(TMPData("LE",ReqID)) q:ReqID=""  d
	.s:ReqIDs'="" ReqIDs=ReqIDs_"^"_ReqID
	.s:ReqIDs="" ReqIDs=ReqID
	d:ReqIDs'="" ##Class(web.DHCAPPExaReport).InvokInterface(ReqIDs,UserID)
	q ""
}

/// Descript: 	更新申请子表接口
/// Creator:	bianshuai
/// CreateDate: 2017-02-09
/// InPut:  	param 申请记录子表RowId^部位id1^执行ID
/// OutPut:     0 - 成功，其他-失败
/// w ##Class(web.DHCAPPInterface).modExaReqNo("1182||1^^1532||4||1^")
ClassMethod modExaReqNo(param As %String) As %String
{
	s arRowID=$p(param,"^",1)  /// 申请记录子表RowId
	s UserID = $P(param,"^",5)
	TS
	/// 申请单医嘱项表、申请单部位表
	s Err=##Class(web.DHCAPPExaReport).modExaRepArc(param)
	i Err'=0 tro
	Q:Err'=0 -1
	
	s arReqID=+arRowID
	s SendFlag=$p(^DHCAPREP(arReqID),"^",17) /// 发送状态
	/// 申请单是否全部更新完执行状态
	s ComFlag=..isComplete(arReqID)

	/// 修改申请发送状态
	i (ComFlag=0)&(SendFlag'="Y") s Err=##Class(web.DHCAPPExaReport).modExaRepSendFlag(arReqID)
	i Err'=0 tro
	Q:Err'=0 -2
	
	/// 插入检查申请Html内容表
	i (ComFlag=0)&(SendFlag'="Y") s Err=##Class(web.DHCAPPExaReport).InsExaRepContentHtml(arReqID)
	i Err'=0 tro
	Q:Err'=0 -3
	
	TC
	;i (ComFlag=0)&(SendFlag'="Y") D ##Class(web.DHCAPPExaReport).InvokInterface(arReqID,UserID)  /// 调用其他相关接口
	Q 0
}

/// Descript:	检查申请单部位执行记录内容是否更新完成
ClassMethod isComplete(arReqID As %String) As %String
{
	n (arReqID)
	s quitflag=0
	s CH=""
	F  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(quitflag'=0)  D
	.s reqItmID=arReqID_"||"_CH
	.s oeori=+$p(^DHCAPREP(arReqID,"AR",CH),"^",3) /// 医嘱ID
	.i oeori=0 s quitflag=1
	.s TarID=""
	.F  s TarID=$o(^DHCAPREPTA(0,"ReqItm",reqItmID,TarID)) Q:(TarID="")||(quitflag'=0)  D
	..s Billed=$p(^DHCAPREPTA(TarID),"^",9)     /// 计费状态
	..Q:Billed'="TB"
	..s OrdExecID=+$p(^DHCAPREPTA(TarID),"^",10) /// 执行记录ID
	..Q:OrdExecID'=0
	..s quitflag=1
	Q quitflag
}

/// Descript:	检查申请单通过执行记录获取部位ID
/// ##Class(web.DHCAPPInterface).GetPartByOrdExecExt("")
ClassMethod GetPartByOrdExecExt(OrdExecID As %String) As %String
{
	n (OrdExecID)
	s arID=$o(^DHCAPREP(0,"OrdExeExt",OrdExecID,""))
	Q:arID="" ""
	s CH=$o(^DHCAPREP(0,"OrdExeExt",OrdExecID,arID,""))
	Q:CH="" ""
	s Sub=$o(^DHCAPREP(0,"OrdExeExt",OrdExecID,arID,CH,""))
	Q:Sub="" ""
	s PartID=$p(^DHCAPREP(arID,"AR",CH,"PA",Sub),"^",1)    /// 部位ID
	Q PartID
}

/// Descript:  修改收费项目计费系数
ClassMethod modTarItmDisc(Oeori As %String, PartID As %String, modFlag As %String, arPartID As %String) As %String
{
	n (Oeori, PartID, modFlag, arPartID)
	s Err=0
    s ord=+Oeori
	s itm=+$p(Oeori,"||",2)
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	s EpisodeID=$p(^OEORD(ord),"^",1)
    s PatType=$p(^PAADM(EpisodeID),"^",2)          /// 就诊类型
    Q:PatType'="I" 0
	s arcimid=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	s Point=##Class(web.DHCAPPExaRepCom).GetFeePoint(arcimid,EpisodeID)
	Q:Point'=1 0  /// 非发药计费退出
	i modFlag="E" D
	.s PartNum=..GetExecPartNum(arPartID)         /// 取已执行的部位数
	.s Err=..UpdTarItmDisc(arcimid,Oeori,PartID,PartNum,EpisodeID)
	//E  D
	//.s TarDisc=1
	//.s Err=..UpdTarItmDisc(Oeori,PartID,TarDisc)
	//.
	//q:Err'=0 Err
	/// 重新计算已计费项目的打折系数
	//s Err=..revTarItmDisc(arcimid,Oeori)
	q:Err'=0 Err
	Q Err
}

/// Descript:  重新计算已计费项目的打折系数
ClassMethod revTarItmDisc(arcimid As %String, oeori As %String) As %String
{
	n (arcimid, oeori)
	s Err=0,PartNum=0
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:(TarID="")||(Err'=0)  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    
	.Q:TarBilled'="B"					    /// 账单标志
	.s PartID=$p(^DHCAPREPTA(TarID),"^",1)  /// 部位ID
	.i '$d(TmpPart(PartID)) s PartNum=PartNum+1
	.s TmpPart(PartID)=""
	.s TarDisc=##Class(web.DHCAPPRepTarItm).GetDisc(arcimid, PartNum, Oeori)
	.&SQL(update DHC_APPRepTarItm set ARTI_Disc=:TarDisc where ARTI_RowId=:TarID)
	.i SQLCODE'=0 s Err=SQLCODE
	Q Err
}

/// Descript:  更新收费项打折系数
ClassMethod UpdTarItmDisc(arcimid As %String, oeori As %String, PartID As %String, PartNum As %String, EpisodeID As %String) As %String
{
	n (arcimid, oeori, PartID, PartNum, EpisodeID)
	s Err=0
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:(TarID="")||(Err'=0)  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    
	.Q:(TarBilled'="TB")					  	   /// 账单标志
	.s InTarId=$p(^DHCAPREPTA(TarID),"^",5)    /// 收费项ID
	.Q:InTarId=""
	.s BasFlag=..GetTarItemBasFlag(arcimid,InTarId,PartID)   /// 基价标志
	.Q:BasFlag'="Y"
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)   /// 部位ID
	.Q:(PartID'="")&(TarPartID'=PartID)         /// 筛选部位
	.i $d(TmpPart(TarPartID_"^"_InTarId)) s PartNum=PartNum+1
	.s TmpPart(TarPartID_"^"_InTarId)=""
	.s TarDisc=##Class(web.DHCAPPInterface).GetTarDisc(arcimid, PartNum, EpisodeID)
	.&SQL(update DHC_APPRepTarItm set ARTI_Disc=:TarDisc where ARTI_RowId=:TarID)
	.i SQLCODE'=0 s Err=SQLCODE
	Q Err
}

/// Descript:  获取医嘱项目对应收费项目基价标志
ClassMethod GetTarItemBasFlag(arcimid As %String, InTarId As %String, PartID As %String) As %String
{
	n (arcimid, InTarId, PartID)
	
	s BasFlag=""
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:(StartDate="")||(BasFlag'="")  D
	.Q:StartDate>+$H
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:(LkTarID="")||(BasFlag'="")  D
	..s EndDate=$p(^DHCOLT(LkTarID),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+31
	..Q:EndDate<+$H
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)
	..Q:InTarId'=TarId
	..s BasFlag=$p(^DHCOLT(LkTarID),"^",8)  /// 基价标志
	.
	Q BasFlag
}

/// Descript:  取计费的部位数
ClassMethod GetExecPartNum(arPartID As %String) As %String
{
	n (arPartID)
	s PartNum=1
	s arReqID=$p(arPartID,"||",1)
	s CH=$p(arPartID,"||",2)
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)   /// 部位ID
	.Q:PartID=0
	.s ExecFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)   /// 执行状态
	.Q:ExecFlag'="E"							/// 执行标志
	.Q:arPartID=(arReqID_"||"_CH_"||"_Sub)
	.s PartQty=$p(^DHCAPPART(PartID),"^",7) 	/// 按部位数累加
	.i +PartQty=0 s PartQty=1
	.s PartNum=PartNum+PartQty
	.
	Q PartNum
}

/// Descript:   取PAC组检查报告链接
/// w ##Class(web.DHCAPPInterface).GetRepLinkUrl("2","4||5","E")
ClassMethod GetRepLinkUrl(EpisodeID As %String, Oeori As %String, TraType As %String = "") As %String
{
	n (EpisodeID, Oeori, TraType)
	s $zt="LinkErrMsg"
	s recLoc=""
	i Oeori'="" s recLoc=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6) /// 接收科室
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s LinkUrl=##Class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(recLoc)
	i TraType="L" D
	.s Link="dhcapp.seepatlis.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&OEORIID="_Oeori
	i TraType="P" D
	.s Link=$p(LinkUrl,"^",1)_"?dept="_recLoc_"&patID="_PatNo_"&OrderID="_Oeori_"&Rpt=1"
	i TraType="E" D
	.i ..GetExaResQty(Oeori)=1 D
	..s ID=$o(^DHCPACRegInfoi("OEORI",Oeori,""))
	..Q:ID=""
    ..s StudyNo=$p(^DHCPACRegInfo(ID),"^",2)
    ..s PacsInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(recLoc)
    ..s UrlParams = PatNo_"^"_StudyNo_"^"_Oeori
    ..s Link = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsInfo,UrlParams)
	.E  D
	..s No=..GetExaReqNo(Oeori)
	..s Link="dhcapp.inspectrs.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeID_"&OEORIID="_Oeori_"&ReqNo="_No

	Q Link
LinkErrMsg
	zn "DHC-APP"
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-01
/// Descript:   取医嘱的检查报告数量
/// InPut:      Oeori-医嘱ID
/// OutPut:     项目描述，空
/// w ##Class(web.DHCAPPInterface).GetExaResQty("")
ClassMethod GetExaResQty(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" 0
	s ID="",ResQty=0
	F  s ID=$o(^DHCPACRegInfoi("OEORI",Oeori,ID)) Q:ID=""  D
    .s StudyNo=$p(^DHCPACRegInfo(ID),"^",2)
    .s ResQty=1+ResQty
	Q ResQty
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-01
/// Descript:   提取执行记录对应的项目描述
/// InPut:      OrdExecID-执行记录ID
/// OutPut:     项目描述，空
/// w ##Class(web.DHCAPPInterface).GetOrdExecDesc("")
ClassMethod GetOrdExecDesc(OrdExecID As %String) As %String
{
	n (OrdExecID)
	Q:OrdExecID="" ""
	s TrID=$o(^DHCAPREPTA(0,"IndexOrdExec",OrdExecID,""))
	Q:TrID="" ""
	s TarID=$p(^DHCAPREPTA(TrID),"^",5)      /// 收费项ID
	s TarDesc=$p(^DHCTARI(TarID),"^",2) 	 /// 收费项描述
	s oeori=$p(^DHCAPREPTA(TrID),"^",2)
	s ItmDesc=..GetOeoriDesc(oeori)          /// 医嘱项名称
	s OrdExDesc=""
	s TrType=$p(^DHCAPREPTA(TrID),"^",3)
	i TrType'="P" D
	.s OrdExDesc=ItmDesc_"【"_TarDesc_"】"
	E  D
	.s PartDesc=..GetPartDesc(TrID)
	.s OrdExDesc=ItmDesc_"【"_PartDesc_"、"_TarDesc_"】"
	Q OrdExDesc
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-01
/// Descript:   医嘱项名称
/// InPut:      oeori-医嘱ID
/// OutPut:     医嘱项名称，空
/// w ##Class(web.DHCAPPInterface).GetOeoriDesc("")
ClassMethod GetOeoriDesc(oeori As %String) As %String
{
	n (oeori)
	Q:oeori="" ""
	Q:'$d(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)) ""
	s arcimid=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2) /// 医嘱项ID
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	Q arcitmdesc
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-01
/// Descript:   根据收费项目表ID获取部位描述
/// InPut:      TrID-收费项目表ID
/// OutPut:     部位描述，空
/// w ##Class(web.DHCAPPInterface).GetPartDesc("")
ClassMethod GetPartDesc(TrID As %String) As %String
{
	s PartID=$p(^DHCAPREPTA(TrID),"^",1)      /// 部位ID
	s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	s reqItmID=$p(^DHCAPREPTA(TrID),"^",11)   /// 项目ID
	s arReqID=+reqItmID,CH=$p(reqItmID,"||",2)
	s Sub=$o(^DHCAPREP(0,"Part",PartID,arReqID,CH,""))
	s arPartID=arReqID_"||"_CH_"||"_Sub
	s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	i PosiDesc'="" s PartDesc=PartDesc_"("_PosiDesc_")"
	Q PartDesc
}

/// Descript:  撤销部位时，调用接口发送给PAC
/// W ##Class(web.DHCAPPInterface).InvokeRISService()
ClassMethod InvokeRISService(arPartID As %String, PartID As %String, LgUserID As %String) As %String
{
	n (arPartID, PartID, LgUserID)
	s arReqID=$p(arPartID,"||",1)
	s CH=$p(arPartID,"||",2)
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)  /// 医嘱ID
 	D ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(Oeori,LgUserID,PartID)
 	Q 0
}

/// Descript:  检查申请调用账单程序
/// w ##Class(web.DHCAPPInterface).InvBillNo("2950||7","220")
ClassMethod InvBillNo(Oeori As %String, PartID As %String) As %String
{
	n (Oeori, PartID)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)   /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)          /// 就诊类型
    Q:PatType'="I" 0
	s TarID="",ListData=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",Oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    
	.Q:TarBilled'="TB"					        /// 账单标志
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)     /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)   /// 部位ID
	.Q:(TarType="P")&(PartID'="")&(TarPartID'=PartID)         /// 筛选部位
	.s TarExecID=$p(^DHCAPREPTA(TarID),"^",10)  /// 执行记录ID
	.i ListData="" s ListData=TarExecID
	.E  s ListData=ListData_"^"_TarExecID
	.
	//b  ////aaa
  	D ##class(web.UDHCJFBILLIP).BILL(EpisodeID,ListData,,0)
  	Q 0
}

/// Descript:  根据医嘱id、检查部位id获取对应的执行记录id串，可能是多个
///           (供PACS组调用、用于检查登记时记根据执行记录id判断是否欠费)
/// Creator: 	 liangqiang
/// CreateDate:  2018-01-08
/// Input:医嘱id、检查部位id
/// OutPut:对应的执行记录id串
ClassMethod GetEexcRowidByOrdItem(Oeori As %String, PartID As %String) As %String
{
	n (Oeori, PartID)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)   /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)          /// 就诊类型
    Q:PatType'="I" ""
	s TarID="",ListData=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",Oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    
	.//Q:TarBilled'="TB"					    /// 账单标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)     /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)   /// 部位ID
	.Q:(TarType="P")&(PartID'="")&(TarPartID'=PartID)         /// 筛选部位
	.s TarExecID=$p(^DHCAPREPTA(TarID),"^",10)  /// 执行记录ID
	.i ListData="" s ListData=TarExecID
	.E  s ListData=ListData_"^"_TarExecID
	.
  	Q ListData
}

///  Creator：	 bianshuai
///  CreatDate： 2018-03-12
///  Descript:   取医嘱项目对应部位【护理组使用】
///  InPut:      Oeori - 医嘱ID
///  OutPut：    部位ID@部位^部位ID@部位^部位ID@部位 
///  w ##Class(web.DHCAPPInterface).GetExaReqPartNur("6||84")
ClassMethod GetExaReqPartNur(Oeori As %String) As %String
{
	n (Oeori,%session)
	Q:Oeori="" ""
	Set langid=..%LanguageID()
	/// 根据医嘱获取申请单子表ID
	s ID="",CH=""
	s arID=..GetExaReqID(Oeori)
	Q:arID="" "-11"
	s ID=$p(arID,"||",1),CH=$p(arID,"||",2)
	s ListData=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(ID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPREP(ID,"AR",CH,"PA",Sub),"^",1)  /// 部位ID
	.//Q:$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)="D"
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.i ListData'="" s ListData=ListData_"^"_PartID_"@"_PartDesc
	.E  s ListData=PartID_"@"_PartDesc

	Q ListData
}

/// Descript:  根据医嘱获取申请单子表ID
/// ##Class(web.DHCAPPInterface).GetExaReqID("144||50")
ClassMethod GetExaReqID(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	/// 检查申请ID
	s ID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))
	Q:ID="" ""
    /// 检查申请医嘱项Child
	s CH=$o(^DHCAPREP(0,"OrdItem",Oeori,ID,""))
	Q:CH="" ""
	s arID=ID_"||"_CH
	Q arID
}

///  Creator：	 bianshuai
///  CreatDate： 2018-03-12
///  Descript:   取医嘱项目和部位对应的执行记录ID列表【护理组使用】
///  InPut:      Oeori - 医嘱ID, PartID-部位ID, Type = E 执行
///  OutPut：    执行记录ID列表，空 - 失败
///  w ##Class(web.DHCAPPInterface).GetExaReqOrdExNur("6||84","10","E")
ClassMethod GetExaReqOrdExNur(Oeori As %String, PartID As %String, Type As %String) As %String
{
	n (Oeori, PartID, Type)
	Q:Oeori="" ""
	/// 根据医嘱获取申请单子表ID
	s arReqID=..GetExaReqID(Oeori)
	Q:arReqID="" "-11"
	/// 取医嘱项目对应的执行记录是否已经执行
	s OrdExecFlag=0, PartQty=0
	i Type="E" s OrdExecFlag=..GetOrdExecFlag(Oeori)
	E  s PartQty=..GetExPartQty(arReqID, PartID)  /// 取医嘱项目已执行部位数量
	s PartFlag=..GetPartExecFlag(arReqID, PartID) /// 医嘱部位对应的执行记录是否执行
	s OrdExList="", TrID=""
	F  s TrID=$o(^DHCAPREPTA(0,"ReqItm",arReqID,TrID)) Q:TrID=""  D
	.s Billed=$p(^DHCAPREPTA(TrID),"^",9)     /// 计费状态
	.Q:(Billed="I")||(Billed="R")
	.s TarType=$p(^DHCAPREPTA(TrID),"^",3)    /// 类型
	.Q:(TarType'="P")&(OrdExecFlag=1)&(Type="E")
	.Q:(TarType'="P")&(PartQty'=1)&(Type'="E")
	.Q:(TarType'="P")&(PartFlag'=1)&(Type'="E")
	.Q:(TarType="P")&(+$p(^DHCAPREPTA(TrID),"^",1)'=PartID)
	.s OrdExecID=$p(^DHCAPREPTA(TrID),"^",10) /// 执行记录ID
	.i OrdExList="" s OrdExList=OrdExecID
	.E  s OrdExList=OrdExList_"^"_OrdExecID
	.
	Q OrdExList
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-03
/// Descript:	医嘱部位对应的执行记录是否执行
/// InPut:      Oeori - 医嘱ID, 部位ID
/// OutPut:     0-未知，1-已执行
/// w ##Class(web.DHCAPPInterface).GetPartExecFlag("13||1||1")
ClassMethod GetPartExecFlag(arReqID As %String, PartID As %String) As %String
{
	n (arReqID, PartID)
	s TrID="",OrdExecFlag=0
	F  s TrID=$o(^DHCAPREPTA(0,"ReqItm",arReqID,TrID)) Q:(TrID="")||(OrdExecFlag=1)  D
	.s Billed=$p(^DHCAPREPTA(TrID),"^",9)     /// 计费状态
	.Q:(Billed="I")||(Billed="R")
	.Q:$p(^DHCAPREPTA(TrID),"^",3)'="P"       /// 类型
	.Q:+$p(^DHCAPREPTA(TrID),"^",1)'=PartID
	.s OrdExecID=$p(^DHCAPREPTA(TrID),"^",10)
	.s Ord=+OrdExecID, Itm=$p(OrdExecID,"||",2), Sub=$p(OrdExecID,"||",3)
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.Q:ExecID=""
	.s ExCode=$p(^OEC("STAT",ExecID),"^",1)
	.i ExCode="F" s OrdExecFlag=1
	.
	Q OrdExecFlag
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-03
/// Descript:	取医嘱项目对应的执行记录是否已经执行
/// InPut:      Oeori - 医嘱ID
/// OutPut:     0-未知，1-已执行
/// w ##Class(web.DHCAPPInterface).GetOrdExecFlag("13||1||1")
ClassMethod GetOrdExecFlag(Oeori As %String) As %String
{
	n (Oeori)
	s Ord=$p(Oeori,"||",1), Itm=$p(Oeori,"||",2)
	s OrdExecFlag=0, Sub=0
	F  s Sub=$o(^OEORD(Ord,"I",Itm,"X",Sub)) Q:(Sub="")||(OrdExecFlag=1)  D
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.Q:ExecID=""
	.s ExCode=$p(^OEC("STAT",ExecID),"^",1)
	.i ExCode="F" s OrdExecFlag=1
	Q OrdExecFlag
}

/// Creator:    bianshuai
/// CreateDate: 2017-08-03
/// Descript:   取医嘱项目已执行部位数量
/// InPut:      arReqID-申请项目子表ROWID
/// OutPut:     0-未知，1-已执行
/// w ##Class(web.DHCAPPInterface).GetExPartQty("13||1||1")
ClassMethod GetExPartQty(arReqID As %String, PartID As %String) As %String
{
	n (arReqID, PartID)
	k TmpPart
	s TrID="" s ExPartQty=0
	F  s TrID=$o(^DHCAPREPTA(0,"ReqItm",arReqID,TrID)) Q:TrID=""  D
	.s Billed=$p(^DHCAPREPTA(TrID),"^",9)    /// 计费状态
	.Q:(Billed="I")||(Billed="R")
	.Q:$p(^DHCAPREPTA(TrID),"^",3)'="P"      /// 类型
	.s PartID=$p(^DHCAPREPTA(TrID),"^",1)    /// 部位ID
	.Q:$d(TmpPart(arReqID,PartID))
	.s TmpPart(arReqID,PartID)=""
	.s OrdExecID=$p(^DHCAPREPTA(TrID),"^",10)
	.s Ord=+OrdExecID, Itm=$p(OrdExecID,"||",2), Sub=$p(OrdExecID,"||",3)
	.s ExecID=$p(^OEORD(Ord,"I",Itm,"X",Sub),"^",16)  /// 执行状态
	.Q:ExecID=""
	.s ExCode=$p(^OEC("STAT",ExecID),"^",1)
	.i ExCode="F" s ExPartQty=ExPartQty+1
	.
	Q ExPartQty
}

/// Creator:	   bianshuai
/// CreateDate:    2018-03-21
/// Descript:	   更新病理申请医嘱ID
/// w ##Class(web.DHCAPPInterface).modPisMasNo("321||1^^51||169")
ClassMethod modPisMasNo(param As %String) As %String
{
	n (param)
	s ItmID=$p(param,"^",1)     /// 申请记录子表RowId
	s arExecID=$p(param,"^",3)  /// 执行记录ID
	s arOeori=$p(arExecID,"||",1)_"||"_$p(arExecID,"||",2) 	/// 医嘱ID
	s UserID = $p(param,"^",5)
	s apStatus = $p(^DHCAPPPM(+ItmID),"^",9)
	s Err=0
	TS
	s Err=##Class(web.DHCAppPisMaster).UpdPisArc(ItmID, arOeori)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	s Err=##Class(web.DHCAppPisMaster).UpdPisSendFlag(+ItmID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 分子病理绑定检测项目医嘱
	s Err=##Class(web.DHCAppPisMaster).InsPisOeori(+ItmID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	
	;d:apStatus'="Y" ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",+ItmID,UserID)   
	
	Q Err
}

/// Creator:	   bianshuai
/// CreateDate:    2018-03-21
/// Descript:	   医嘱项检查分类类型
/// w ##Class(web.DHCAPPInterface).GetTraCatType("320||1^^51||169")
ClassMethod GetTraCatType(param As %String) As %String
{
	n (param)
	s Oeori=$p(param,"^",3)  /// 医嘱ID
	/// 医嘱项ID
	s arcimid=##Class(web.DHCAPPPisInterface).GetArcimID(Oeori)
	Q:arcimid="" ""
	/// 检查分类类型 P - 病理，E - 检查
	s Type=##Class(web.DHCAPPExaReportQuery).GetTraType(arcimid)
	Q Type
}

/// Creator:	   bianshuai
/// CreateDate:    2018-07-26
/// Descript: 	   获取检查医嘱和部位对用的执行记录【PAC调用】
/// w ##class(web.DHCAPPInterface).GetOeoriExec("4||3","40")
ClassMethod GetOeoriExec(Oeori As %String, PartIDs As %String) As %String
{
	n (Oeori, PartIDs)
	s ExecFlag=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)    /// 医嘱状态
	s TarID="",ListData=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",Oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    
	.Q:(TarBilled="I")||(TarBilled="R")			/// 账单标志
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)     /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)   /// 部位ID
	.Q:(TarType="P")&(PartIDs'="")&('$LF($LISTFROMSTRING(PartIDs,"^"),TarPartID))       /// 筛选部位
	.Q:(TarType'="P")&(ExecFlag="E")
	.s TarExecID=$p(^DHCAPREPTA(TarID),"^",10)  /// 执行记录ID
	.i ListData="" s ListData=TarExecID
	.E  s ListData=ListData_"^"_TarExecID
	.
	Q ListData
}

/// Creator:	   qqa
/// CreateDate:    2018-10-29
/// Descript: 	   获取检查报告连接
/// Input: RecLocID:检查科室ID,Params:登记号^检查号^医嘱ID^报告ID,Model:1(报告)2(图像)
/// w ##class(web.DHCAPPInterface).GetPacsPortUrl("22","0000000098^no234212^22||1",1)
ClassMethod GetPacsPortUrl(RecLocID, Params, Model) As %String
{
	n (RecLocID,Params,Model)
	s PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(RecLocID)
	s:Model=1 Url = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,Params)
	s:Model=2 Url = ##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,Params)
	q Url
}

/// Creator:	   qqa
/// CreateDate:    2018-10-29
/// Descript: 	   获取检查报告连接
/// Input: OeoriId:医嘱ID(多个用,号分割),PartID:部位ID,Model:1(报告)2(图像)
/// w ##class(web.DHCAPPInterface).GetPacsPortUrlByOrd("136||117","",1)
ClassMethod GetPacsPortUrlByOrd(OeoriId, PartID, Model) As %String
{
	n (OeoriId,PartID,Model)
	q:+OeoriId=0 "医嘱ID数据格式错误！"
	s ItmOrd = $p(OeoriId,",",1)
	s Ord = +ItmOrd
	s Itm = $p(ItmOrd,"||",2)
	s RepID=""
	s LabNo = $p($g(^OEORD(Ord,"I",Itm,3)),"^",20) //检验号
	;s:LabNo'="" RepID = ##class(web.DHCAPPLocLinkClinicSet).GetLisReportIDs(OeoriId)
	s:LabNo'="" RepID =##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabNo)
	if $l(RepID,",")>1 { //循环
	s Url=""
	for itemInd=1:1:$l(RepID,","){
		s itemRepID=$p(RepID,",",itemInd)
		s itemRepID=$p(itemRepID,"||",2)

		s RecLocID = $p($g(^OEORD(Ord,"I",Itm,3)),"^",6) ///接收科室
		s Adm = $p(^OEORD(Ord),"^",1)
		S PatID = $p(^PAADM(Adm),"^",1)
		s RegNo = $p($g(^PAPER(PatID,"PAT",1)),"^",1)
		s Params = RegNo_"^"_LabNo_"^"_OeoriId_"^"_itemRepID

		s itemUrl =##class(web.DHCAPPInterface).GetPacsPortUrl(RecLocID,Params,Model)
		s:itemUrl'="" Url=Url_$s(Url="":"",1:"$$$")_itemUrl
		}
		q Url

	}

	if RepID'="" s RepID=$P(RepID,"||",2)
	s:LabNo="" LabNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OeoriId,PartID)  //检查号
	s RecLocID = $p($g(^OEORD(Ord,"I",Itm,3)),"^",6) ///接收科室
	s Adm = $p(^OEORD(Ord),"^",1)
	S PatID = $p(^PAADM(Adm),"^",1)
	s RegNo = $p($g(^PAPER(PatID,"PAT",1)),"^",1)
	s Params = RegNo_"^"_LabNo_"^"_OeoriId_"^"_RepID
	
	s Url =##class(web.DHCAPPInterface).GetPacsPortUrl(RecLocID,Params,Model)
	q Url
}

/// Creator:	   qqa
/// CreateDate:    2018-11-06
/// Descript: 	   判断部位是否存在于医嘱项
/// Input: ArciID(医嘱项ID),PartList(部位1A部位2A部位3)
/// w ##class(web.DHCAPPInterface).VerifyPartInArci("4092||1","9")
ClassMethod VerifyPartInArci(ArciID, PartList)
{
	n (ArciID,PartList)
	
	s ArciParts=""
	s TraID="" 
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",ArciID,TraID)) Q:(TraID="")  D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",ArciID,TraID,CH)) Q:(CH="")  D
	..s Itempartid=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)        //部位
	..;w Itempartid,!
	..q:Itempartid=""
	..
	..s:ArciParts'="" ArciParts=ArciParts_"^"_Itempartid
	..s:ArciParts="" ArciParts=Itempartid
	s PartInArci="Y"
	s PartLen = $l(ArciParts,"^")
	s Len = $l(PartList,"A")
	f i=1:1:Len d
	.s ItmPartID = +$P(PartList,"A",i)
	.s ItmPartInArci="N"
	.f j=1:1:PartLen d
	..s Itempartid = +$P(ArciParts,"^",j)
	..q:Itempartid'=ItmPartID
	..s ItmPartInArci="Y"
	.s:ItmPartInArci="N" PartInArci="N"
	q PartInArci
}

/// Creator:QQA
/// CreatDate:2018-11-07
/// Descript:报告查看和图像查看
/// Input:Model(I图像R报告),医嘱id^检查病理号/检验号^当前登录科室^阅读人
/// w ##class(web.DHCAPPInterface).ClinicRecordSet("R","48||148^0000000863^95^10209^537")
ClassMethod ClinicRecordSet(Model, Params)
{
	n (Model,Params)
	s OrditemDR=$p($g(Params),"^",1)   //医嘱ID
	s StudyNo=$p($g(Params),"^",2)     //检查号
	s LoginLocDR=$p($g(Params),"^",3)  //登录科室
	s:LoginLocDR'="" LoginLocHospDr=$p(^CTLOC(LoginLocDR),"^",22)
	s UserDR=$p($g(Params),"^",4)      //阅读人
	s VisitNumberReportDRs=$p($g(Params),"^",5)
	s Date=..%SysDate()						   //阅读日期
	s Time=..%SysTime()				   //阅读时间
	q:+OrditemDR=0 "医嘱ID不能为空！"
	s Len = $l(OrditemDR,",")
	s PartStr=$p($g(Params),"^",6)
	s DeptCode="",DeptDesc=""
	if (LoginLocDR'=""){
		s DeptCode=$P($G(^CTLOC(+LoginLocDR)),"^",1)
		s DeptDesc=$P($G(^CTLOC(+LoginLocDR)),"^",2)
	}
	ts 
	s Ret=0
	f i=1:1:Len q:Ret'=0  d
	.s OrderItmID = $p(OrditemDR,",",i)
	.&sql(INSERT INTO DHC_AppReadRecord (RRE_OrdItm_Dr, RRE_LabNo , RRE_Loc_Dr, RRE_User_Dr, RRE_Date, RRE_Time, RRE_Type) 
		VALUES (:OrderItmID,:StudyNo,:LoginLocDR,:UserDR,:Date,:Time,:Model))
	.s Ret = SQLCODE
	tro:Ret'=0
	q:Ret'=0 Ret
	//调用平台方法
	s UserName=$p(^SSU("SSUSR",UserDR),"^",2)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[{")
	S del=""""
	for i=1:1:Len {
		s OrderItmID = $p(OrditemDR,",",i)
		if i'=1 d Stream.Write("},{")
		d Stream.Write(del_"OEOrdItemID"_del_":"_del_OrderItmID_del_",")
		d Stream.Write(del_"Position"_del_":"_del_PartStr_del_",")
		d Stream.Write(del_"ExamID"_del_":"_del_StudyNo_del_",")
		d Stream.Write(del_"Status"_del_":"_del_"RD"_del_",")
		d Stream.Write(del_"UserID"_del_":"_del_UserDR_del_",")
		d Stream.Write(del_"UserName"_del_":"_del_UserName_del_",")
		d Stream.Write(del_"UpDateTime"_del_":"_del_$zdt($h,3)_del_",")
		d Stream.Write(del_"OperateDeptCode"_del_":"_del_DeptCode_del_",")
		d Stream.Write(del_"OperateDept"_del_":"_del_DeptDesc_del_",")
		d Stream.Write(del_"SourceSystem"_del_":"_del_"HIS"_del)
		}
	
	d Stream.Write("}]")
	b ;s jsonStr=Stream.Read()
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Stream)
	if VisitNumberReportDRs'="" d ##class(DHCLIS.DHCReportControl).AddViewLog(UserDR,VisitNumberReportDRs,LoginLocHospDr,OrditemDR)	
	b //44
	tc
	q Ret
}

/// Creator:QQA
/// CreatDate:2018-11-17
/// Descript:检查病理检验报告是否阅读
/// Input:Params(医嘱ID^检查病理号/检验号^用户ID)[医嘱ID必传,其他参数表示可按照检查号和阅读人判断是否阅读]
/// Return:Y/N
/// w ##class(web.DHCAPPInterface).IsReadByParams("1||1^^")
ClassMethod IsReadByParams(Params)
{
	n (Params)
	s OEORIId = $p(Params,"^",1)        //医嘱ID
	s StudyNo = $p(Params,"^",2)		//检查号
	s ReadUserID = $p(Params,"^",3)     //阅读人ID
	q:+OEORIId=0 "医嘱ID不能为空！"
	
	s ReadFlag="N"
	s RREId=""
	f  s RREId = $o(^DHCAPPRRE(0,"IndexOrdItm",OEORIId,RREId)) q:(RREId="")||(ReadFlag="Y")  d
	.s RRELabNo = $p(^DHCAPPRRE(RREId),"^",2)
	.s RREUserDr = $p(^DHCAPPRRE(RREId),"^",4)
	.q:(StudyNo'=RRELabNo)
	.q:(ReadUserID'="")&&(ReadUserID'=RREUserDr)
	.s ReadFlag="Y"
	q ReadFlag
}

/// w ##class(web.DHCAPPInterface).ReadDetailByParams(1,12,"18||60^U20190216005")
ClassMethod ReadDetailByParams(page, rows, Params)
{
	n (page, rows, Params)
	s Start=page-1*rows+1
	s End=page*rows
	s Oeori = $p(Params,"^",1)
	s StudyNo = $p(Params,"^",2)
	q:+Oeori=0 ""
	s Tmp = "ReadDoctorName^ReadDate^ReadTime"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s RERowID="",Count=0
	f  s RERowID = $o(^DHCAPPRRE(0,"IndexOrdItm",Oeori,RERowID)) q:RERowID=""  d
	.s ReadDoctorName=""
	.s ReadUserID = $p(^DHCAPPRRE(RERowID),"^",4)
	.s:ReadUserID'="" ReadDoctorName = $p(^SSU("SSUSR",ReadUserID),"^",2)
	.s ReadDate="",ReadTime=""
	.s ReadDate = $p(^DHCAPPRRE(RERowID),"^",5)
	.s:ReadDate'="" ReadDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ReadDate)
	.s ReadTime = $p(^DHCAPPRRE(RERowID),"^",6)
	.s:ReadTime'="" ReadTime = ..%ZT(ReadTime,2)
	.s TmpData = ReadDoctorName_"^"_ReadDate_"^"_ReadTime
	.S Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData(Tmp,TmpData)

	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCAPPInterface","dealInsListData",pid)
	q ""
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	//Q $I(^DHCST("DHCEMInterface"))
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// 通过医嘱和部位取收费数据，供计费使用 DHC_AppRepPart/DHC_AppRepTarItm
/// w ##Class(web.DHCAPPInterface).GetEPTRAStr("2677||6","2779||1||1!!2779||1||2!!2779||1||3!!")
ClassMethod GetEPTRAStr(oeori As %String, PartIDStr As %String)
{
	n (oeori,PartIDStr)
	s Adm=$p(^OEORD(+oeori),"^",1)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	; 门诊退费审核-检查、治疗医嘱审核模式 0:先撤销执行再审核 1：先审核再撤销执行
	s TreatItmReqMode=##class(web.DHCBillInterface).IGetTreatItmReqMode(AdmHospitalId)
	s reqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:reqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,reqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(reqID,"AR",CH)) ""
	s rtn=""
	s Flag=1
	s Sub=""
	f  s Sub=$o(^DHCAPREP(reqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",1)   /// 部位ID
	.Q:PartID=0
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 /// 部位
	.s ExeStat=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",2)   /// 执行状态
	.s arPartID=reqID_"||"_CH_"||"_Sub
	.Q:(ExeStat'="V")&&(ExeStat'="E")
	.;Q:(ExeStat'="V")&&(TreatItmReqMode=0)
	.if (("!!"_PartIDStr_"!!")[("!!"_arPartID_"!!")) d 
	..s TarID=""
	..f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) q:TarID=""  d
	...s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    // 计费标志
	...q:(TarBilled'="P")
	...s TarType=$p(^DHCAPREPTA(TarID),"^",3)      // 类型
	...q:(TarType'="P")
	...q:$p(^DHCAPREPTA(TarID),"^",1)'=PartID        // 指针
	...i rtn="" s rtn=TarID
	...e  s rtn=rtn_"!!"_TarID
	.e  s Flag=0
	;后处理相关
	if (Flag=1) {
		s TarID=""
		f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) q:TarID=""  D
		.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    //计费标志
		.q:(TarBilled'="P")
		.s TarType=$p(^DHCAPREPTA(TarID),"^",3)      //类型
		.q:(TarType'="D")
		.//q:$p(^DHCAPREPTA(TarID),"^",1)'=""
		.i rtn="" s rtn=TarID
		.e  s rtn=rtn_"!!"_TarID
	}
	q rtn
}

///  Descript:   获取已申请中间表id串(计费组使用)
///  InPut:      医嘱ID
///  w ##Class(web.DHCAPPInterface).GetReqEPTRAStr("1785||11")
ClassMethod GetReqEPTRAStr(oeori As %String) As %String
{
	new (oeori)
	set rtn=""

	set isAllRef=##class(web.DHCOPBillRefund).IsAllRefundRepPart(oeori)
	if (isAllRef=0) {
		set TarID=""
		for  set TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) quit:(TarID="")  do
		.set TarBilled=$p(^DHCAPREPTA(TarID),"^",9)      // 计费标志
		.quit:(TarBilled'="P")
		.s AROrdExecDr=$p(^DHCAPREPTA(TarID),"^",10)
		.s StatusCode=""
		.if AROrdExecDr'="" d
		..s StatusRowId=$P($g(^OEORD(+AROrdExecDr,"I",$P(AROrdExecDr,"||",2),"X",$P(AROrdExecDr,"||",3))),"^",16)
		..if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
		.q:(StatusCode="E")||(StatusCode="F")
		.if (rtn="") set rtn=TarID
		.else  set rtn=rtn_"!!"_TarID
	}else {
		set arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
		quit:(arReqID="") ""
		set CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))
		quit:(CH="") ""
		quit:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
		
		set Sub=""
		for  set Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) quit:(Sub="")  do
		.set PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  //部位ID
		.set ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2)
		.quit:(ExeStat'="V")
		.set reqFlag=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",6)  //退费申请
		.quit:(reqFlag'="Y")
		.s AROrdExecDr=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",9)
		.s StatusCode=""
		.if AROrdExecDr'="" d
		..s StatusRowId=$P($g(^OEORD(+AROrdExecDr,"I",$P(AROrdExecDr,"||",2),"X",$P(AROrdExecDr,"||",3))),"^",16)
		..if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
		.q:(StatusCode="E")||(StatusCode="F")
		.set TarID=""
		.for  set TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) quit:(TarID="")  do
		..set TarPatID=$p(^DHCAPREPTA(TarID),"^",1)
		..quit:(TarPatID'=PartID)
		..set TarType=$p(^DHCAPREPTA(TarID),"^",3)      //类型
		..quit:(TarType'="P")
		..set TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    //计费标志
		..quit:(TarBilled'="P")
		..if (rtn="") set rtn=TarID
		..else  set rtn=rtn_"!!"_TarID
	}

	quit rtn
}

/// 部分作废部位是调用平台和pace的接口
/// w ##Class(web.DHCAPPInterface).StopPartID(oeori, UserID)
ClassMethod StopPartID(oeori, UserID)
{
	n (oeori, UserID)
	s PartStr=$g(^DHCDocAPPAPREP("PartStr",oeori))
	if (PartStr'=""){
		for i=1:1:$L(PartStr,"!!") {
			s Arreqid=$P(PartStr,"!!",i)
			s PartID = $p(^DHCAPREP(+Arreqid,"AR",$P(Arreqid,"||",2),"PA",$P(Arreqid,"||",3)),"^",1)
			d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(oeori,UserID,PartID)
			d ..UpdExaReqItmStatusOrd("OCA",oeori,PartID,UserID)
		}
	}
	q 0
}

/// 得到患者的检查医嘱
/// 入参 就诊号EpisodeID 出参Json串
/// w ##class(web.DHCAPPInterface).GetPatPacsOrdDetails(35)
ClassMethod GetPatPacsOrdDetails(EpisodeID As %String)
{
	q:EpisodeID="" ""
	s ARRowID=""
	s retObj={}
	k LisOrdList
	for {
		s ARRowID=$O(^DHCAPREP(0,"ADM",EpisodeID,ARRowID))
		q:ARRowID=""
		s ARChildSub=""
		for {
			s ARChildSub=$o(^DHCAPREP(ARRowID,"AR",ARChildSub)) 
			q:ARChildSub=""
			;b ;09334
			s OEORIId = $p(^DHCAPREP(ARRowID,"AR",ARChildSub),"^",3)
			continue:OEORIId=""
			s OECCatDesc = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(OEORIId)
			continue:OECCatDesc'["检查"
			s OEOrd = +OEORIId
			s OEOrdItm = $p(OEORIId,"||",2)
			s ArciID=$p($g(^OEORD(OEOrd,"I",OEOrdItm,1)),"^",2)
			s ItmStatDesc = ""   //医嘱描述
			s ItmStatDr = $p(^OEORD(OEOrd,"I",OEOrdItm,1),"^",13)
			s ItmStatDesc = $p(^OEC("OSTAT",ItmStatDr),"^",2)
			continue:(ItmStatDesc["撤销")!(ItmStatDesc["作废")!(ItmStatDesc["停止") //这些状态的医嘱不显示
			s ServerMaterial=$p($g(^ARCIM($p(ArciID,"||",1),$p(ArciID,"||",2),7)),"^",6)
			continue:(ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
			if ('$d(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA"))){
				s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,"")
				s:StudyNo="" StudyNo=0
				;b ;093
				s LisOrdList("PacsGroup",StudyNo,OEORIId,0)=""
			}else{
				s RepPartID=""
				for{
					s RepPartID= $o(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID))
					q:RepPartID=""
					s ReqPartStatus = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",2)
					Continue:ReqPartStatus="D"                      //D为停止状态
					s PartID = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",1)
					s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,PartID)
					s hasBooked=##class(web.DHCRisResApptSchudleSystem).HasBooked(OEORIId,PartID)
					s:(hasBooked="Y")&&(StudyNo="") StudyNo=-1
					s:StudyNo="" StudyNo=0
					s:PartID="" PartID=0
					s LisOrdList("PacsGroup",StudyNo,OEORIId,ARRowID_"||"_ARChildSub_"||"_RepPartID)=PartID
				}
			}
		}
	}
	s StudyNo="" 
	s ListObj=[]
	s total=0
	f  {
		s StudyNo = $o(LisOrdList("PacsGroup",StudyNo)) 
		q:StudyNo=""  
		s OEORIId = ""
		f  {
			s OEORIId = $o(LisOrdList("PacsGroup",StudyNo,OEORIId))
			q:OEORIId=""
			s obj={}
			s Ord = +OEORIId
			s Itm = $p(OEORIId,"||",2)
			s ARCIMId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
			s ARCIName = 	$p(^ARCIM($p(ARCIMId,"||",1),$p(ARCIMId,"||",2),1),"^",2)   ///获取医嘱名称
			s RecLocName=""
			s RecLocDr=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
			i RecLocDr'="" s RecLocName=$p(^CTLOC(RecLocDr),"^",2)
			s:RecLocDr'="" PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(RecLocDr)
			s ClinicRowid=$o(^DHCRBCi("LocClinicSet",RecLocDr,0))
			s RepPartID = "",PartDesc=""
			s ExamID = $case(StudyNo,-1:"",0:"",:StudyNo)
			s IsCVR = ##Class(web.DHCAntService).IsCVReport(ExamID,OEORIId)
			s IsCVR = $case(+IsCVR,1:"是",:"否")
			s Position=""
			f  s RepPartID = $o(LisOrdList("PacsGroup",StudyNo,OEORIId,RepPartID)) q:RepPartID=""  d
			.s PartID=$g(LisOrdList("PacsGroup",StudyNo,OEORIId,RepPartID))
			.Q:PartID=""
			.s PartItmDesc = $p($g(^DHCAPPART(PartID)),"^",2) 
			.s:PartDesc'="" PartDesc=PartDesc_"+"_PartItmDesc
			.s:PartDesc="" PartDesc=PartItmDesc
			.s:Position'="" Position=Position_"@@"_PartItmDesc
			.s:Position="" Position=PartItmDesc
			s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OEORIId,ExamID,Position)
			s StrOrderName = ARCIName_$case(PartDesc,"":"",:"("_PartDesc_")")
			s OrderDate=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",9)
			s OrderTime=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",10)
			s OrderByDesc = +OrderDate_+OrderTime
			s OrdAdm = $p(^OEORD(+OEORIId),"^",1)								   //就诊ID	
			s PatDr = $p(^PAADM(OrdAdm),"^",1)							   //病人ID
			s RegNo=$p(^PAPER(PatDr,"PAT",1),"^",1)                              //病人登记号
			s DepLoc=$p(^PAADM(OrdAdm),"^",4)       						       //就诊科室
			s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)	
			s PatID = PatDr
			s OrderDate="",OrderTime=""													   //病人ID
			s OrderDate=$p(^OEORD(Ord,"I",Itm,1),"^",9)
			s strOrderDate=..%ZD(OrderDate)
			s OrderTime=$p(^OEORD(Ord,"I",Itm,1),"^",10) 
			s strOrderTime=..%ZT(OrderTime,2)
			s strOrderDateDesc = strOrderDate_" "_strOrderTime                  //日期+时间
			s IshasImg="",Image="",Report="",Memo="",ImageUrl="",Grade="",IsReaded="",ImgUrl="",ResultDescEx="",ExamDescEx=""
			s PortUrl="",BlMorePort="",IsIll=""
			i (StudyNo'=0)&&(StudyNo'=-1) d
			.s RegRowid = $o(^DHCPACRegInfoi("StudyNo",StudyNo,""))
			.s:RegRowid'="" ImageUrl=$p(^DHCPACRegInfo(RegRowid),"^",22)      ;存放外部传输过来的URL RegRowid 待发布
			.s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
			.s IshasImg=##class(web.DHCAPPSeePatPacs).GetImageStatus(StudyNo)
			.i Imgrowid'="" s IshasImg="Y"
			.s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
			.i RptRowId'="" d
			..s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
			..s StatusCode=""
			..i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
			..s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
			..s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
			..s ResultDescEx=$replace($G(^DHCRBStudy("Report",RptRowId,"ResultDescEx")),$c(10),"")           
			..s ExamDescEx=$replace($G(^DHCRBStudy("Report",RptRowId,"ExamDescEx")),$c(10),"")
			s:IsIll="" IsIll = ##class(web.DHCEkg.GetEkgReportState).GetEkgPositive(OEORIId)   //心电报告是否阳性 
			i ((ExamStatus="RP")||(ExamStatus="RD")) d   ;默认检查完成后才能查看报告和图像
			.s:IshasImg="Y" Image="图像"
			.s Report="报告"
			.s Grade="评级"
			;s Params = OEORIId_"^"_$case(StudyNo,0:"",:StudyNo)_"^"_UserID
			s IsReadedFlag="" ;##class(web.DHCAPPInterface).IsReadByParams(Params)
			s IsModify=""                 		//是否修改                      
			s:(ExamStatus="RP")&&(IsReadedFlag'="Y") IsReaded="未阅读"
			s:(ExamStatus'="RP") IsReaded=""
			s:IsReadedFlag="Y" IsReaded="已阅读"
			s ItemStatus=##class(web.DHCAPPSeePatPacs).GetResultStatus(ExamStatus)
			s No=##class(web.DHCAPPSeePatPacs).GetReqNo(OEORIId)
			s Bookingtime=""
			if (ItemStatus="预约") d
			..s Bookingtime=##class(web.DHCAPPSeePatPacs).GetBookDateObj(OEORIId,"")
			s UrlParams = RegNo_"^"_StudyNo_"^"_OEORIId
			s ImgUrl = ##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",7)     //
			s PortUrl = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",1)
			s obj.No=No
			s obj.RegNo=RegNo
			s obj.DepLocDesc=DepLocDesc
			s obj.StudyNo=StudyNo
			if (StudyNo=0) s obj.StudyNo=""
			s obj.StrOrderName=StrOrderName
			s obj.strOrderDateDesc=strOrderDateDesc
			s obj.ItemStatus=ItemStatus
			s obj.OEORIId=OEORIId
			s obj.IsIll=$g(IsIll)
			s obj.RecLocName=RecLocName
			s obj.RecLocDr=RecLocDr
			s obj.IshasImg=IshasImg
			s obj.MediumName=$g(MediumName)
			s obj.Image=Image
			s obj.Shut=$g(Shut)
			s obj.Report=Report
			s obj.Memo=Memo
			s obj.ImageUrl=ImageUrl
			s obj.Grade=Grade
			s obj.IsModify=$g(IsModify)
			s obj.IsReaded=IsReaded
			s obj.ImgUrl=ImgUrl
			s obj.PortUrl=PortUrl
			s obj.BlMorePort=BlMorePort
			s obj.IsCVR=IsCVR
			s obj.Bookingtime=Bookingtime
			s obj.ARCIMId=ARCIMId
			s obj.ResultDescEx=ResultDescEx
			s obj.ExamDescEx=ExamDescEx
			d ListObj.%Push(obj)
			s total=total+1
			}
		}
	s retObj.rows=ListObj
	s retObj.total=total
	Q retObj.%ToJSON()
}

/// 得到患者的检验医嘱
/// 入参 就诊号EpisodeID 出参Json串
/// w ##class(web.DHCAPPInterface).GetPatlisDetails(35)
ClassMethod GetPatlisDetails(EpisodeID As %String)
{
	q:EpisodeID="" ""
	s ARRowID=""
	s retObj={}
	s ListObj=[]
	s total=0
	s SamLabRowID=""
	s OrdId=""  f  {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeID,OrdId)) 
		q:OrdId=""  
		s SubId=""	f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
			q:SubId=""  
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			i '$l(ItmMastDr) continue
			i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) continue
			s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
			//比较申请日期
			s ReqDate=$p(OrdStr3,"^",7)
			//检验号
			s PlacerNo=$p(OrdStr3,"^",36)
			s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
			i '$l(LabEpisode) continue
			//报告ID
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			s stat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
			s StatusDesc="",StatusCode=""
			i stat'=""{
				s StatusDesc=$P(^OEC("OSTAT",stat),"^",2) 
				s StatusCode=$P(^OEC("OSTAT",stat),"^",1) 
			}
			continue:StatusCode="D"	//停止
			continue:StatusCode="U"	//作废
			continue:StatusCode="C"	//撤销
			
			//病人所属医院
			s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
			i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
			i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
			i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
			i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
			//就诊日期
			s AdmDate=$p(^PAADM(Adm),"^",6)
			i $l(AdmDate) s AdmDate=$zd(AdmDate,3)
			s PAAdmType=$p(^PAADM(Adm),"^",2)
			i PAAdmType="O" s AdmType="门诊"
			i PAAdmType="I" s AdmType="住院"
			i PAAdmType="E" s AdmType="急诊"
			i PAAdmType="H" s AdmType="体检"
			s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
			s AdmDepDr=$p($g(^PAADM(Adm)),"^",4)
			s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
			;0:普通收费模式；1：押金收费模式
			s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
			s OrdRowIds=""
			i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
			e  s OrdRowIds=OrdRowId
			s OrdNames=""
			i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
			e  s OrdNames=OrdName
			//申请日期时间
			s ReqDate=$p(OrdStr3,"^",7)
			s ReqTime=$p(OrdStr1,"^",17)
			s OGTTGroupReqDate=ReqDate
			i $l(ReqDate) s ReqDate= ..%ZD(ReqDate)
			i $l(ReqTime) s ReqTime=..%ZT(ReqTime)
			s ReqDateTime=ReqDate_" "_ReqTime
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			//标本类型
			s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
			s (SpecCode,SpecName)=""
			i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
			i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
			//采集日期时间Collection
			s (SpecDate,SpecTime)=""
			s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
			i $l(retval)  d
			.s SpecDate=$p(retval,"^",2)
			.i $l(SpecDate) s SpecDate=..%ZD(SpecDate)
			.s SpecTime=$p(retval,"^",3)
			.i $l(SpecTime) s SpecTime=..%ZT(SpecTime)
			s SpecDateTime=SpecDate_" "_SpecTime
			s (RecDateTime,ResultStatus,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,ReceiveNotes,MajorConclusion)=""
			s PrintFlag=""
			s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(OrdRowId_"^^")
			if ReadFlag="Y" s ReadFlag=1  else  s ReadFlag=0
			s HasMC="",HasMid="",HasBic="",RepFlag="",ManualState="",ManualOrdItemList=""
			s OutPutReportDR=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode)
			if (OutPutReportDR'="") {
				for reportIndex=1:1:$l(OutPutReportDR,",") {
					s oneReportDR=$p(OutPutReportDR,",",reportIndex)
					Set result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
					Set sc=result.Execute(oneReportDR)
					Set colNum=result.GetColumnCount() //列数
					If $$$ISERR(sc) continue
					While(result.Next()){
						Set ret=""
						s ResultStatus="3"
						if ($g(result.Data("ReceiveDate"))'=""){
							s ReceiveDate=$g(result.Data("ReceiveDate"))
							if (ReceiveDate["/") s ReceiveDate=..%ZTH(ReceiveDate,4)
							if (ReceiveDate["-") s ReceiveDate=..%ZTH(ReceiveDate,3)
							s RecDateTime=..%ZD(ReceiveDate)_" "_$g(result.Data("ReceiveTime")) //$ZD($g(result.Data("ReceiveDate")),3)_" "_..%ZT($g(result.Data("ReceiveTime")))
						}
						if ($g(result.Data("AuthDate"))'=""){
							s AuthDate=$g(result.Data("AuthDate"))
							s AuthDateTime=..%ZD(AuthDate)_" "_..%ZT($g(result.Data("AuthTime")))
						}
						s ReceiveNotes=$g(result.Data("ResNoes"))
						s MajorConclusion=$g(result.Data("MajorConclusion"))
						if ($g(result.Data("CollectionDate"))'=""){
							s CollectionDate=$g(result.Data("CollectionDate"))
							s SpecDateTime=..%ZD(CollectionDate)_" "_..%ZT($g(result.Data("CollectionTime")))
						}
						s RepStatus=$g(result.Data("RepStatus"))
						;s RepStatus=$case(RepStatus,"1":"审核","2":"取消审核","3":"作废")
						s TSMemo="【"_##class(websys.Translation).Get("dhcapp.seepatlis.csp",RepStatus)_"】"
						s StatusDesc=RepStatus
						;ManualState不为空代表微生物有未缴费的手工医嘱
						s ManualOrdItemList=$g(result.Data("ManualOrdItemList"))
						if (ManualOrdItemList'="")&&(SelfCheckFee=1) {
							if (PAAdmType'="I") s ResetManualState=1
							;急诊留观押金模式
							if " 1 2 "[(" "_PatCurStat_" ")&&(StayPayMode=1)&&(PAAdmType="E"){ 
								s ResetManualState=0
							}
							if (ResetManualState=1){
								s OEORIBilled=$p($g(^OEORD(+ManualOrdItemList,"I",$p(ManualOrdItemList,"||",2),3)),"^",5)
								if (OEORIBilled'="P") {
									s ManualState=1
								}
							}
						}
					}
					s OrdRowIds=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISOrdIDByRpt",oneReportDR)
					if ((","_OrdRowIds_",")'[(","_OrdRowId_",")) {
						s OrdRowIds=OrdRowId
						s oneReportDR=""
						s (RecDateTime,ResultStatus,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,ReceiveNotes,MajorConclusion)=""
					}
					if ((","_SamLabRowID_",")[(","_OrdId_"||"_SubId_",")) {
						continue
					}else{
						s SamLabRowID=SamLabRowID_","_OrdRowIds
					}				
					continue:OrdNames=""
					s obj={}
					s obj.oneReportDR=oneReportDR
					s obj.OrdRowIds=OrdRowIds
					s obj.OrdNames=OrdNames
					s obj.ReqDateTime=ReqDateTime
					s obj.ResultStatus=ResultStatus
					s obj.LabEpisode=LabEpisode
					s obj.LabTestSetRow=LabTestSetRow
					s obj.SpecName=SpecName
					s obj.SpecDateTime=SpecDateTime
					s obj.RecDateTime=RecDateTime
					s obj.AuthDateTime=AuthDateTime
					s obj.ReportFlag=ReportFlag
					s obj.TransComm=TransComm
					s obj.TSResultAnomaly=TSResultAnomaly
					s obj.TSMemo=TSMemo
					s obj.Adm=Adm
					s obj.AdmDate=AdmDate
					s obj.AdmLoc=AdmLoc
					s obj.AdmType=AdmType
					s obj.ReadFlag=ReadFlag
					s obj.PrintFlag=PrintFlag
					s obj.StatusDesc=StatusDesc
					s obj.ReceiveNotes=ReceiveNotes
					s obj.MajorConclusion=MajorConclusion
					s obj.HasMC=HasMC
					s obj.HasMid=HasMid
					s obj.HasBic=HasBic
					s obj.HasBic=HasBic
					s obj.RepFlag=RepFlag
					s obj.ManualState=ManualState
					d ListObj.%Push(obj)
					s total=total+1
				}
			}else{
				s suborder="",OrdRowIds=""
				for  {
					s suborder=$O(^OEORD(0,"EpisNo",LabEpisode,OrdId,suborder))
					q:suborder=""
					if OrdRowIds=""  s OrdRowIds=OrdId_"||"_suborder
					else   s OrdRowIds=OrdRowIds_","_OrdId_"||"_suborder
				
				}
				if ((","_SamLabRowID_",")[(","_OrdId_"||"_SubId_",")) {
					continue
				}else{
					s SamLabRowID=SamLabRowID_","_OrdRowIds
				} 
				s obj={}
				s obj.oneReportDR=""
				s obj.OrdRowIds=OrdRowIds
				s obj.OrdNames=OrdNames
				s obj.ReqDateTime=ReqDateTime
				s obj.ResultStatus=ResultStatus
				s obj.LabEpisode=LabEpisode
				s obj.LabTestSetRow=LabTestSetRow
				s obj.SpecName=SpecName
				s obj.SpecDateTime=SpecDateTime
				s obj.RecDateTime=RecDateTime
				s obj.AuthDateTime=AuthDateTime
				s obj.ReportFlag=ReportFlag
				s obj.TransComm=TransComm
				s obj.TSResultAnomaly=TSResultAnomaly
				s obj.TSMemo=TSMemo
				s obj.Adm=Adm
				s obj.AdmDate=AdmDate
				s obj.AdmLoc=AdmLoc
				s obj.AdmType=AdmType
				s obj.ReadFlag=ReadFlag
				s obj.PrintFlag=PrintFlag
				s obj.StatusDesc=StatusDesc
				s obj.ReceiveNotes=ReceiveNotes
				s obj.MajorConclusion=MajorConclusion
				s obj.HasMC=HasMC
				s obj.HasMid=HasMid
				s obj.HasBic=HasBic
				s obj.HasBic=HasBic
				s obj.RepFlag=RepFlag
				s obj.ManualState=ManualState
				d ListObj.%Push(obj)
				s total=total+1
			}
		}
	}
	s retObj.rows=ListObj
	s retObj.total=total
	Q retObj.%ToJSON()
}

/// 检验列表数据
/// w ##class(web.DHCAPPInterface).JsonQryTSInfo(169)
ClassMethod JsonQryTSInfo(ReportDR As %String)
{
	q:ReportDR="" "" 
	
	Set result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
	Set sc=result.Execute(ReportDR)
	If $$$ISERR(sc) Quit ""
	s retjson=""
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	s retjson=##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
		s retObj = ##class(%DynamicAbstractObject).%FromJSON("{"_ret_"}")
		Set count = count+1
		If count=1 s retjson=retjson_ "{"_ret_"}"
		Else  s retjson=retjson_",{"_ret_"}"
	 }
	  s retjson=retjson_"]"
	  s retjson=retjson_","_del_"total"_del_":"_count
	  s retjson=retjson_"}"
	 Do result.Close()
	 Quit retjson
}

}
