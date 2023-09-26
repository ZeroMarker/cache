Import SQLUser

/// 公共字典信息
Class web.DHCWMRCircul.Operation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

/// *****************************************************************
/// 事务           :  Operation
/// 功能描述       ： 业务操作 
///                   操作目标,判断  －  是病案/卷
///                   根据病案/卷的病案类别取当前工作流
///                   取操作项目,判断
///                           －  工作流/突发项目  
///                           －  是否有附加项目  
///                           －  是否有特殊操作
///                   写Main/Volume
///                   写Status
///                   写Dtl
///                   写系统操作
/// by wuqk 2007-04
/// 入参           ：
///   ObjectType   ： 操作目标   0-病案    1-病案卷
///   ItemDr       ： 操作项目   DHC_WMR_WorkItem.Rowid
///   MainRowid    :  DHC_WMR_Main.Rowid         ObjectType=0
///   VolRowid     :  DHC_WMR_MainVolume.Rowid   ObjectType=1
///   sStatus      :  DHC_WMR_MainStatus/DHC_WMR_VolStatus的写入串
///   sDtlList     ： StatusDtl的写入串列表  $c(1)分隔
///   
///   ;add by wuqk 2008-03
///   sReqRowId    ： 申请表RowId DHC_WMRRequest.RowId
/// 返回值         ： ret=0 成功    ret<0 失败
/// *****************************************************************
ClassMethod Operation(ObjectType, WorkFlow, ItemDr, MainRowid, VolRowid, sStatus, sDtlList, sReqRowId)
{
    n (ObjectType,WorkFlow,ItemDr,MainRowid,VolRowid,sStatus,sDtlList,sReqRowId)
	s ret=-1
	
	q:(ObjectType="")!(ItemDr="")!(sStatus="") ret
	q:(ObjectType="0")&(MainRowid="") ret
	q:(ObjectType="1")&(VolRowid="") ret
	
	i ObjectType="1" d
	.s MainRowid=+$p($g(^DHCWMRVOL(+VolRowid)),"^",1)
	s MrType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)
	
	s sFlow=##class(web.DHCWMRCircul.WorkFlow).GetWorkItemsByFlow(WorkFlow)
	s sItem=##class(web.DHCWMRWorkItemCtl).GetDataById(ItemDr)
	s IsOrderItem=$s($p($g(^DHCWMRDIC(+$p(sItem,"^",2))),"^",3)["顺序":"Y",1:"N")
	
	;是否有附加项目
	s ItemListFlag=$s($d(^DHCWMRWITM(ItemDr,"L")):"Y",1:"N")
	
	s SysOperDr=$p(sItem,"^",6),sSysOper=""
	s:SysOperDr'="" sSysOper=##class(web.DHCWMRDictionaryCtl).GetDataById(SysOperDr)
	s SysOperCode=$p(sSysOper,"^",3)             ;特殊操作代码
	
	s:ObjectType="0" ret=$$OperationMain()
	s:ObjectType="1" ret=$$OperationVolume()

	q ret
	
  /********************************
  /;病案操作
  /********************************/
OperationMain()
    TStart
    
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    s IsStayIn=$p(sMain,"^",8)
    ;取出最后一卷
    s LastVolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,""),-1)
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+LastVolRowid)
    s IsReprography=$p(sVolume,"^",5)
    s IsSeal=$p(sVolume,"^",6)
    
    s ret=-4.1                        ;写Status
    s flag=0
    s $p(sStatus,"^",1)=MainRowid
    s $p(sStatus,"^",3)=ItemDr
    s flag=##class(web.DHCWMRMainCtl).UpdateMainStatus(sStatus)
    i flag<0 TRollBack
    q:flag<0 ret    
    s MainStatusRowid=flag
    
    s ret=-4.11                       ;响应申请  add by wuqk 2008-03
    s flag=0
    i sReqRowId'="" d
    .s sRequest=##class(web.DHCWMRRequest).GetRequest(sReqRowId)
    .s:sRequest="" flag=-1
    .q:sRequest=""
    .s $p(sRequest,"^",16)=$p(sStatus,"^",4)
    .s $p(sRequest,"^",17)=MainStatusRowid
    .s flag=##class(web.DHCWMRRequest).RespRequest(sRequest)
    i flag<0 TRollBack
    q:flag<0 ret 
    
    s ret=-4.2                        ;写Dtl
    s flag=0
    i (sDtlList'="")&(ItemListFlag="Y") d
    .f index=1:1:$l(sDtlList,$c(1)) d
    ..s sDtl=$p(sDtlList,$c(1),index)
    ..s $p(sDtl,"^",1)=MainStatusRowid
    ..s flag=##class(web.DHCWMRMainCtl).UpdateMainStatusDtl(sDtl)
    ..q:flag<0
    .q:flag<0
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-4.3                        ;写系统操作
    s flag=0
    i SysOperCode="2" d       //突发事件发生
    .s IsStayIn="N"
    e  i SysOperCode="3" d    //突发事件还回
    .s IsStayIn="Y"
    e  i SysOperCode="4" d    //封存病案
    .s flag=$$UpdateVol4()
    e  i SysOperCode="5" d    //复印病案
    .s flag=$$UpdateVol5()
    e  i SysOperCode="6" d    //复印病案（只记录复印状态）
    .s flag=$$UpdateVol5()
    .s IsStayIn=$p(sMain,"^",8)
    ;对 2 3,更新主信息
    s $p(sMain,"^",8)=IsStayIn
    s flag=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
    i flag<0 TRollBack
    q:flag<0 ret
    
    ;对4 5,更新最后一卷的信息
    s ret=-4.4
    s $p(sVolume,"^",5)=IsReprography
    s $p(sVolume,"^",6)=IsSeal
    s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
    i flag<0 TRollBack
    q:flag<0 ret
    
	TCommit
	s ret=0
    q ret


  /********************************
  /;卷操作
  /********************************/
OperationVolume()
    TStart
    s VolItemDr=""                    ;用来存储卷的目标状态
    
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    s IsReprography=$p(sVolume,"^",5)
    s IsSeal=$p(sVolume,"^",6)
    
    s ret=-5.1                        ;写Status
    s flag=0
    s $p(sStatus,"^",1)=+VolRowid
    s $p(sStatus,"^",3)=ItemDr
    s flag=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sStatus)
    i flag<0 TRollBack
    q:flag<0 ret    
    s VolStatusRowid=flag
    s VolItemDr=ItemDr                ;目标状态
    
    s ret=-5.2                        ;写Dtl
    s flag=0
    i (sDtlList'="")&(ItemListFlag="Y") d
    .f index=1:1:$l(sDtlList,$c(1)) d
    ..s sDtl=$p(sDtlList,$c(1),index)
    ..s $p(sDtl,"^",1)=VolStatusRowid
    ..s flag=##class(web.DHCWMRVolumeCtl).UpdateVolStatusDtl(sDtl)
    ..q:flag<0
    .q:flag<0
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-5.3                        ;写系统操作
    s flag=0
    i SysOperCode="1" d               //病案回收
    .s flag=$$UpdateVol1()
    e  i SysOperCode="2" d            //突发事件发生
    .
    e  i SysOperCode="3" d            //突发事件还回
    .
    e  i SysOperCode="4" d            //封存病案
    .s flag=$$UpdateVol4()
    e  i SysOperCode="5" d            //复印病案
    .s flag=$$UpdateVol5()
    e  i SysOperCode="6" d            //复印病案（只记录状态列表，不更新当前状态）
    .s flag=$$UpdateVol5()
    .s VolItemDr=$p(sVolume,"^",7)    //把原当前状态再放到当前状态位置上，等于没有改变当前状态
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-5.5
    s flag=0
    s InFlow="Y"
    s IsLastItem=..CheckItemIsLast(ItemDr,sFlow)
    s:IsLastItem="Y" InFlow="N"
    s:(IsLastItem="Y")&&(IsOrderItem'="Y") VolItemDr=$p($p(sFlow,$c(1),1),"^",3)
    s $p(sVolume,"^",7)=VolItemDr                  ;卷当前状态
    s:InFlow="N" $p(sVolume,"^",9)=InFlow          ;流是否完成
    s $p(sVolume,"^",5)=IsReprography              ;是否被复印过
    s $p(sVolume,"^",6)=IsSeal                     ;是否被封存过
    s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
    i flag<0 TRollBack
    q:flag<0 ret
    
	TCommit
	s ret=0
    q ret
    
  /********************************
  /;系统操作
  /********************************/
UpdateVol1()
    ;病案回收:修改DHC_WMR_VolAdm
    s flag=0
    s sPaadm=##class(web.DHCWMRVolDisAdmQry).GetAdmList(+VolRowid)
    f index=1:1:$l(sPaadm,"^") q:flag<0  d
    .s paadm=$p(sPaadm,"^",index)
    .q:paadm=""
    .q:$d(^DHCWMRVOL(0,"VolAdm",paadm,+VolRowid))
    .s sVolAdm=""
    .s $p(sVolAdm,"^",1)=+VolRowid
    .s $p(sVolAdm,"^",3)=paadm
    .s flag=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
    q flag
    
    ;封存
UpdateVol4()
    s IsSeal="Y"
    q 0
    
    ;复印
UpdateVol5()
    s IsReprography="Y"
    q 0
}

/// 判断操作是否工作流的最后一个操作
ClassMethod CheckItemIsLast(ItemDr, sFlow)
{
	n (ItemDr,sFlow)
	
	s Flag="N"
    s aFlow=$p(sFlow,$c(1),$l(sFlow,$c(1)))
    s FlowItem=$p(aFlow,"^",3)
	s:FlowItem=ItemDr Flag="Y"
	q Flag
}

/// 取消卷操作
/// w ##Class(web.DHCWMRCircul.Operation).CancelOperation(ObjectType, FlowId, ItmId, MainId, VolId, UserId)
ClassMethod CancelOperation(ObjectType, FlowId, ItmId, MainId, VolId, UserId)
{
	n (ObjectType, FlowId, ItmId, MainId, VolId, UserId)
	s ret=0
	
	q:(ObjectType'=0)&&(ObjectType'=1) ret
	i ObjectType=1 d
	.s tmpVol=$g(^DHCWMRVOL(+VolId))
	.q:tmpVol=""
	.q:$p(tmpVol,"^",7)'="Y"
	.s CurrStatus=$p(tmpVol,"^",6)
	.q:CurrStatus'=ItmId
	.s MainId=$p(tmpVol,"^",1)
	s:ObjectType="0" VolId=""
	s tmpMain=$g(^DHCWMRMAIN(+MainId))
	q:tmpMain="" ret
	q:$p(tmpMain,"^",6)'="Y" ret
	s MrType=$p(tmpMain,"^",1)
	s:ObjectType=0 VolId=""
	s:ObjectType=1 MainId=""
	
	//当前操作的前一操作项
	s SubId=$o(^DHCWMRWFLOW(+FlowId,"S",0,"ItemDr",+ItmId,0))
	q:(+SubId)=0 ret
	s PrevSubId=$o(^DHCWMRWFLOW(+FlowId,"S",SubId),-1)
	s PrevItmId=$p($g(^DHCWMRWFLOW(+FlowId,"S",PrevSubId)),"^",2)
	q:PrevItmId="" ret
	
	//作废状态表操作
	s flg=..CancelStatus(ObjectType, ItmId, MainId, VolId, UserId)
	q:flg<0 ret
	
	//做取消操作 时间为“0”表示是无效记录
	s StatusInfo=""
	s $p(StatusInfo,"^",1)=VolId
	s $p(StatusInfo,"^",3)=PrevItmId
	s $p(StatusInfo,"^",4)=UserId
	s $p(StatusInfo,"^",5)=$zd(0,3)
	s $p(StatusInfo,"^",6)=$zt(0,1)
	s $p(StatusInfo,"^",7)=""
	s flg=..Operation(ObjectType,FlowId,PrevItmId, MainId, VolId, StatusInfo, "", "")
	q:flg<0 flg
	
	s ret=1
	q ret
}

ClassMethod CancelStatus(ObjectType, ItmId, MainId, VolId, UserId)
{
	n (ObjectType, ItmId, MainId, VolId, UserId)
	s ret=-1
	
	;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{ChildSub})
	i ObjectType=0 d
	.s SubId=$o(^DHCWMRMAIN(+MainId,"S",""),-1)
	.q:(+SubId)=0
	.s tmpStatus=$g(^DHCWMRMAIN(+MainId,"S",SubId))
	.s StaItem=$p(tmpStatus,"^",1)
	.q:StaItem'=ItmId
	.s $p(tmpStatus,"^",3)=$zd(0,3)
	.s $p(tmpStatus,"^",4)=$zt(0,1)
	.s sStatus=MainId_"^"_SubId_"^"_tmpStatus
	.s flag=##class(web.DHCWMRMainCtl).UpdateMainStatus(sStatus)
	.s:flag>0 ret=1
	
	;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",{ChildSub})
	i ObjectType=1 d
	.s SubId=$o(^DHCWMRVOL(+VolId,"S",""),-1)
	.q:(+SubId)=0
	.s tmpStatus=$g(^DHCWMRVOL(+VolId,"S",SubId))
	.s StaItem=$p(tmpStatus,"^",1)
	.q:StaItem'=ItmId
	.s $p(tmpStatus,"^",3)=$zd(0,3)
	.s $p(tmpStatus,"^",4)=$zt(0,1)
	.s sStatus=VolId_"^"_SubId_"^"_tmpStatus
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sStatus)
	.s:flag>0 ret=1
	
	q ret
}

/// w ##Class(web.DHCWMRCircul.Operation).MRHistoryData(1,50000,2)
ClassMethod MRHistoryData(From, To, ItemId)
{
	n (From,To,ItemId)
	s Count=0
	
	q:ItemId="" "Over! Count="_Count
	s VolId=(+From)-1
	f  s VolId=$o(^DHCWMRVOL(VolId)) q:(VolId="")||(VolId>(+To))  d
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:$p(tmpVol,"^",7)'="Y"
	.s Paadm=+$p(tmpVol,"^",2)
	.q:$p($g(^PAADM(Paadm)),"^",20)'="D"
	.s ObjectType=1  //对卷操作
	.s FlowId=1      //工作流ID
	.s ItemId=ItemId //当前操作项ID
	.s UserId=1      //SSUserDR
	.s StatusInfo=""
	.s $p(StatusInfo,"^",1)=VolId
	.s $p(StatusInfo,"^",3)=ItemId
	.s $p(StatusInfo,"^",4)=UserId
	.s $p(StatusInfo,"^",5)=$zd(+$h,3)
	.s $p(StatusInfo,"^",6)=$zt($p($h,",",2),1)
	.s $p(StatusInfo,"^",7)=""
	.s flg=..Operation(ObjectType,FlowId,ItemId, "", VolId, StatusInfo, "", "")
	.s:flg<0 ^ZF("VolHistory",VolId)=flg
	.s Count=Count+1
	.i Count=((Count\100)*100) w "Count="_Count_"  VolId="_VolId,!
	
	q "Over! Count="_Count
}

/// w ##Class(web.DHCWMRCircul.Operation).MRStatusTimeData(1,50000)
ClassMethod MRStatusTimeData(From, To)
{
	n (From,To)
	s Count=0
	
	s VolId=(+From)-1
	f  s VolId=$o(^DHCWMRVOL(VolId)) q:(VolId="")||(VolId>(+To))  d
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:$p(tmpVol,"^",7)'="Y"
	.s Paadm=+$p(tmpVol,"^",2)
	.q:$p($g(^PAADM(Paadm)),"^",20)'="D"
	.s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    .s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
    .s:DischDate="" DischDate=$zd($p($g(^PAADM(Paadm)),"^",6),3)
	.s SubId=0
	.f  s SubId=$o(^DHCWMRVOL(+VolId,"S",SubId)) q:SubId=""  d
	..s tmpStatus=$g(^DHCWMRVOL(+VolId,"S",SubId))
	..s $p(tmpStatus,"^",3)=DischDate
	..s $p(tmpStatus,"^",4)=DischTime
	..s sStatus=VolId_"^"_SubId_"^"_tmpStatus
	..s flag=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sStatus)
	..s:flag<0 ^ZF("VolStatus",VolId)=flg
	.s Count=Count+1
	.i Count=((Count\100)*100) w "Count="_Count_"  VolId="_VolId,!
	
	q "Over! Count="_Count
}

}
