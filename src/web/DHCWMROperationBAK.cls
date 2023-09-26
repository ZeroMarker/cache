Import SQLUser

/// 对病案或卷的业务操作
/// by wuqk 2007－04
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMROperationBAK Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

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
ClassMethod Operation(ObjectType, ItemDr, MainRowid, VolRowid, sStatus, sDtlList, sReqRowId)
{
    n (ObjectType,ItemDr,MainRowid,VolRowid,sStatus,sDtlList,sReqRowId)
	s ret=-1
	q:(ObjectType="")!(ItemDr="")!(sStatus="") ret
	q:(ObjectType="0")&(MainRowid="") ret
	q:(ObjectType="1")&(VolRowid="") ret
	
	i ObjectType="1" d
	.s MainRowid=+$p($g(^DHCWMRVOL(+VolRowid)),"^",1)
	s MrType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)
	
	/*   sStatus
	;$p(Instring,"^",1)        ;ParRef
    ;$p(Instring,"^",2)        ;Sub
    ;$p(Instring,"^",3)        ;病案操作项目/状态
    ;$p(Instring,"^",4)        ;转交人   
    ;$p(Instring,"^",5)        ;操作日期  
    ;$p(Instring,"^",6)        ;操作时间   
    ;$p(Instring,"^",7)        ;接收人  
    */
    
    /*   sDtlList
    ;$p(Instring,"^",1)         ;ParRef
    ;$p(Instring,"^",2)         ;Sub
    ;$p(Instring,"^",3)         ;突发项目明细
    ;$p(Instring,"^",4)         ;突发项目值  
    ;$p(Instring,"^",5)         ;备注
    ;$p(Instring,"^",6)         ;WorkItemListDr  
    */
	
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
	s sItem=##class(web.DHCWMRWorkItemCtl).GetDataById(ItemDr)

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
    /*
    i (SysOperCode="2")!(SysOperCode="3") d
    .s:SysOperCode="2" IsStayIn="N"   ;系统操作
    .s:SysOperCode="3" IsStayIn="Y"   ;系统操作
    .;s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    .s $p(sMain,"^",8)=IsStayIn
    .s flag=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
    */
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
    .s flag=$$UpdateVol3()            ;目标状态
    e  i SysOperCode="4" d            //封存病案
    .s flag=$$UpdateVol4()
    e  i SysOperCode="5" d            //复印病案
    .s flag=$$UpdateVol5()
    e  i SysOperCode="6" d            //复印病案（只记录状态列表，不更新当前状态）
    .s flag=$$UpdateVol5()
    .s VolItemDr=$p(sVolume,"^",7)    //把原当前状态再放到当前状态位置上，等于没有改变当前状态
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-5.4
    s flag=0
    s InFlow="Y"
    s LastItemFlag=..CheckItemIsLast(ItemDr,sFlow)    
    i LastItemFlag="Y" d                          ;工作流的最后一个项目
    .s InFlow="N"                                 ;修改DHC_WMR_MainVolume.InFlow="N"
    .;s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    .;s $p(sMain,"^",8)="Y"                        ;对病案主表修改IsStayIn=Y
    .;s flag=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-5.5                          ;写Volume
    s flag=0
    ;s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    ;s $p(sVolume,"^",1)=MainRowid_"^"_$p(VolRowid,"||",2)            //2007-04-07  ZF
    ;s sVolume=MainRowid_"^"_$p(VolRowid,"||",2)_"^"_sVolume
    s $p(sVolume,"^",7)=VolItemDr       ;目标状态
    s:InFlow="N" $p(sVolume,"^",9)=InFlow          ;流是否完成
    s $p(sVolume,"^",5)=IsReprography
    s $p(sVolume,"^",6)=IsSeal
    s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
    i flag<0 TRollBack
    q:flag<0 ret
	TCommit
	s ret=0
    q ret
    
 /******************系统操作**********************/
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
    
    
UpdateVol3()            ;仅设置目标状态 未直接更新 
    ;突发事件还回:对卷修改DHC_WMR_MainVolume的Status_Dr为完成的最后一个工作流操作
    ;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid},"S",{ChildSub})
    s StatusSub="",InFlowFlag="N"
    f  s StatusSub=$o(^DHCWMRVOL(VolRowid,"S",StatusSub),-1) q:(StatusSub="")!(InFlowFlag="Y")  d
    .s tmpItemDr=$p($g(^DHCWMRVOL(VolRowid,"S",StatusSub)),"^",1)
    .s InFlowFlag=..CheckItemInFlow(tmpItemDr,sFlow)
    
    ;目标状态=卷的最后一个工作流操作项目 
    s:InFlowFlag="Y" VolItemDr=tmpItemDr
    q flag
    
    ;封存
UpdateVol4()
    s IsSeal="Y"
    q 0
    
    ;复印
UpdateVol5()
    s IsReprography="Y"
    q 0
    
    /*
    ;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"V",{DHC_WMR_MainVolume.ChildSub},"S",{ChildSub})
    s StatusSub="",InFlowFlag="N"
    f  s StatusSub=$o(^DHCWMRMAIN(+VolRowid,"V",$p(VolRowid,"||",2),"S",StatusSub),-1) q:(StatusSub="")!(InFlowFlag="Y")  d
    .s tmpItemDr=$p($g(^DHCWMRMAIN(+VolRowid,"V",$p(VolRowid,"||",2),"S",StatusSub)),"^",1)
    .s InFlowFlag=..CheckItemInFlow(tmpItemDr,sFlow)
    
    ;目标状态=卷的最后一个工作流操作项目 
    s:InFlowFlag="Y" VolItemDr=tmpItemDr
    */
}

/// 判断操作是否属于流
ClassMethod CheckItemInFlow(ItemDr, sFlow)
{
	n (ItemDr,sFlow)
	
	s Flag="N"
	f Index=1:1:$l(sFlow,$c(1)) q:Flag="Y"  d
	.s aFlow=$p(sFlow,$c(1),Index)
	.s FlowItem=$p(aFlow,"^",3)
	.s:FlowItem=ItemDr Flag="Y"
	q Flag
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

/// 病案类型 01-病案 02-病案卷
/// w ##Class(web.DHCWMROperation).IsActiveMR("02",183695,"N")
ClassMethod IsActiveMR(Type, Rowid, IsActive)
{
	n (Type,Rowid,IsActive)
	s IsActive=$s(IsActive["Y":"Y",1:"N")
	s ret=0
	i Type="01" d
	.s tmpMain=##Class(web.DHCWMRMainCtl).GetMainById(+Rowid)
	.q:tmpMain=""
	.s $p(tmpMain,"^",7)=IsActive
	.;s ret=##Class(web.DHCWMRMainCtl).UpdateMain(tmpMain)
	e  d
	.s tmpVol=##Class(web.DHCWMRVolumeCtl).GetVolume(+Rowid)
	.q:tmpVol=""
	.s $p(tmpVol,"^",8)=IsActive
	.s ret=##Class(web.DHCWMRVolumeCtl).UpdateVol(tmpVol)
	q ret
}

}
