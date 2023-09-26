/// 名称:     web.DHCDocOrderCommon
/// 描述:     医嘱录入的控制类
/// 编写者:  周志强
/// 编写日期: 2009.02.20
/// 适用医院:深圳中医院;沈阳医科大医院;地坛医院;北京妇产医院;衢州人民医院;
/// 珠海人民医院;潍坊人民医院,银夏医学院,烟台中医院,南通大学附属医院
Class web.DHCDocOrderCommon Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// tanjishan 2023-02-22
/// 各关键业务场景之间的加锁；
/// 加锁场景：
/// 			1多用户进入医嘱录入互斥（存在会诊id时不加锁）；
/// 			2审核医嘱动作与点击结算动作互斥；
/// 			3审核医嘱动作与账单互斥；
/// 			4停医嘱与点击结算互斥；停止与停止之间不加锁
/// 			5进入医嘱录入界面与进入结算界面不存在互斥；
/// 			6进入批量补录界面不加锁，
/// orderrow：患者医嘱主表
/// SessionStr：Session信息，参照BSP.SYS.SRV.Session.GetSessionStr
/// LockType：加锁类型，
/// 		医生角色登录医嘱界面加锁，调用位置:医嘱录入、中草药录入的登录位置，结算查询患者不再加锁
/// 		User.OEOrder审核医嘱的锁（包含审核、结算等），批量补录医嘱界面通过InsertOrderItem的加锁去控制,调用位置:保存医嘱方法、结算
/// 		User.OEOrder.Stop结算的锁，停止与审核之间不加锁,停止与停止之间不加锁，停止与结算之间加锁，调用位置:结算（结算同时锁User.OEOrder）
/// 		Check只校验，不主动加锁,调用位置:批量补录医嘱界面的提前验证、各审核功能的checkbeforeupdate
/// 		CheckStop只校验，不主动加锁,调用位置:停止、撤销等位置。互斥导致的停医嘱与结算之间的锁，通过审核医嘱时的User.OEOrder锁去管理
ClassMethod OrderLock(orderrow As %String, SessionStr As %String, LockType As %String, ExpStr As %String) As %String [ ProcedureBlock = 1 ]
{
	s ^tempscl("OrderEntryLock")=$LB(orderrow,SessionStr,LockType,ExpStr)
	s warning=""
	
	s LgUserID=$P(SessionStr,"^",1)
	s LgLoc=$P(SessionStr,"^",3)
	s HOSPID=$P(SessionStr,"^",4)
	s LgLangID=$P(SessionStr,"^",6)
	s LgSessionId=$P(SessionStr,"^",9)
	s EmConsultItm=$P(ExpStr,"^",1)			//会诊id，会诊场景下不校验登录锁
	s EpisodeID=$P(ExpStr,"^",2)			//就诊id
	if (+EpisodeID'=0)&&(+orderrow=0){
		s orderrow=$o(^OEORD(0,"Adm",+EpisodeID,""))
	}
	Q:+orderrow=0 ""
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(LgUserID)
	s CareProvType=$zcvt(CareProvType,"U")
	if (HOSPID=""){
		s HOSPID=##class(DHCDoc.Common.Hospital).GetAffiliatedHospitalId("",LgLoc,LgUserID,"", orderrow)
	}
	s EpisodeID=$p(^OEORD(orderrow),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s timeout=1800
	if (LockType="User.OEOrder.LoginIn"){
		if (AdmType="I"){
			s OrderEntryLock=..%GetConfig("OrderEntryLock",HOSPID)
		}else{
			s OrderEntryLock=..%GetConfig("OPOrderEntryLock",HOSPID)
		}
		i OrderEntryLock="" s OrderEntryLock=0
		if (OrderEntryLock=0){
			//登录医嘱录入界面的锁走开关配置
			q ""
		}
		if (EmConsultItm'=""){
			//会诊场景下不校验登录锁
			q ""
		}
		if (LgSessionId=""){
			q ""
		}
		if (CareProvType'="DOCTOR"){
			//医生和医生之间加锁、医生和护士不加锁、护士和护士不加锁
			q ""
		}
		d ##Class(websys.Lock).Lock($lb(orderrow,LockType),LgSessionId,LgUserID,.warning,LgLoc,timeout)
	}elseif (LockType="Check")||(LockType="CheckStop"){
		if (LockType="Check"){
			s ClassName="User.OEOrder"
		}elseif (LockType="CheckStop"){
			s ClassName="User.OEOrder.Stop"
		}
		s warning=""
		s timeout=##class(web.DHCBillLockAdm).GetLockTimeout(AdmType)
		s SessionId=0
		for {
			s SessionId=$o(^websys.LockI("Lock",ClassName,orderrow,SessionId)) Q:(SessionId="")||(warning'="")
			s websysLockId=0
			for{
				s websysLockId=$o(^websys.LockI("Lock",ClassName,orderrow,SessionId,websysLockId)) Q:websysLockId=""
				;// (记录分类、ip地址、'',sessionid、userid、orderrow、locid、日期、时间、电脑名称)
				s g=$G(^websys.LockD(websysLockId))
				s websysLockUserID=$lg(g,5)
				continue:(LgUserID=websysLockUserID)		;排除自己锁定的自己
				s websysLockLocID=$lg(g,7)
				s LockUserCareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(websysLockUserID)
				s LockUserCareProvType=$zcvt(LockUserCareProvType,"U")
				//continue:(LockUserCareProvType="DOCTOR")||(LockUserCareProvType="NURSE")||(LockUserCareProvType="TECHNICIAN")
				;其他用户锁定了此记录。请联系超级用户或系统管理员解除锁定。(收费01 | 挂号收费处 | 10.1.30.179 | ll-PC | 2021-01-26 08:37:35)
				s websysLockUser=$p($g(^SSU("SSUSR",websysLockUserID)),"^",2)
				s websysLockLoc=$p(^CTLOC(websysLockLocID),"^",2)
				s websysLockIP=$lg(g,2)
				s websysLockIpName=$lg(g,10)
				s websysLockDate=$lg(g,8)
				s websysLockTime=$lg(g,9)
				if (timeout>0),(websysLockDate_websysLockTime+timeout)<(..%SysDate()_..%SysTime()){
					continue
				}
				s websysLockUser =##class(User.SSUser).GetTranByDesc("SSUSRName",websysLockUser,LgLangID)
				s websysLockLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",websysLockLoc,LgLangID)
				s warning=websysLockUser_" | "_websysLockLoc_" | "_websysLockIP_" | "_websysLockIpName_" | "_..%ZD(websysLockDate)_" "_..%ZT(websysLockTime,1)
				Q
			}
		}
		if (warning'=""){
			s warning=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","其他用户临时锁定了此记录，请稍后重试或联系超级用户解锁。",LgLangID)_warning
			Q:warning'="" warning
		}
	}else{
		s timeout=##class(web.DHCBillLockAdm).GetLockTimeout(AdmType)
		if (LgSessionId=""){
			q ""
		}
		d ##Class(websys.Lock).Lock($lb(orderrow,LockType),LgSessionId,LgUserID,.warning,LgLoc,timeout)
	}
	
	q warning
}

/// 各关键业务场景之间的加锁；
/// 按SessionStr清除；指定SessionStr与LockType清除
ClassMethod OrderEntryClearLock(SessionStr As %String = "", LockType As %String = "") As %String
{
	if (SessionStr=""){
		s SessionStr=..%SessionStr()
	}
	s LgSessionId=$P(SessionStr,"^",9)
	q:(LgSessionId="") 1
	if (LockType'=""){
		&sql(DELETE FROM websys.Lock where SessionId=:LgSessionId and ClassName=:LockType)
	}else{
		d ##Class(websys.Lock).LockClearSession(LgSessionId)
	}
	q 1
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:  保存前判断库存和住院开医嘱是否需要输入整包装标志
/// Table:        INC_ItmLoc
/// Input:        arcim:医嘱项RowId   Qty:数量   RecLoc:接受科室
/// Return:       库存是否够(0,1)_"^"_住院开医嘱需按整包装单位发药(1)
/// Others:        
ClassMethod CheckBeforeUpdate(arcim As %String, Qty As %String, RecLoc As %String, EpisodeType As %String = "", ExpStr As %String = "") As %Status
{
	s StockEnough=..CheckStockEnough(arcim,Qty,RecLoc,EpisodeType,ExpStr)
	s ItemCatRowid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	s LogonLocRowId=$p(ExpStr,"^",2)
  	s HospitalID=$p(^CTLOC(LogonLocRowId),"^",22)
	//s IPNeedPackQtyFlag=..GetNeedPackQtyFlag(arcim,RecLoc,ItemCatRowid,HospitalID)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+arcim)
    s IPNeedPackQtyFlag=##Class(PHA.FACE.OUT.Com).GetIncilInPhUom(RecLoc, INCIRowid).inPhPack	///住院发整包装
    s IPNeedPackQtyFlag=$CASE(IPNeedPackQtyFlag,"Y":1,:"0")
	q StockEnough_"^"_IPNeedPackQtyFlag
}

ClassMethod CheckBillTypeSum(PAADMRowid As %String, InsType As %String, PrescLimitSum As %String, Amount As %String, PrescLimitType As %String = "", LogOnLoc As %String = "") As %String
{
	n (PAADMRowid,InsType,PrescLimitSum,Amount,PrescLimitType,LogOnLoc)
	s ToBillSum=0
	s ToBillPatSum=0
	s ToBillDiscSum=0
	s ToBillInsSum=0
	s PatientID=$P(^PAADM(PAADMRowid),"^",1)
	s PatType=$P(^PAPER(PatientID,"PER",1),"^",10)
	s PrescLimitSum=$fn(PrescLimitSum,"",2)
	s:LogOnLoc="" LogOnLoc=%session.Get("LOGON.CTLOCID")
	Q:(PrescLimitSum="0.00") 0
	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(PAADMRowid)
	Q:OrderRowid="" 0
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s OrderBillTypeRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",18)
	.Q:(OrderBillTypeRowid'=InsType)
	.s OEORIDate=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",7)
	.q:(OEORIDate'=..%SysDate())
	.;如果医嘱未核实则为退出
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.;trakcare先开的医嘱是inactive
	.Q:($g(statcode)'="V")&&($g(statcode)'="E")
	.;医嘱录入科室
	.s OEORIUserDepartmentDR=$p($g(^OEORD(OrderRowid,"I",itemsub,7)),"^",2)
	.q:(PrescLimitType'="")&&(PrescLimitType="S")&&(OEORIUserDepartmentDR'=LogOnLoc)
	.s OEORIRowid=OrderRowid_"||"_itemsub
	.s OEORIDetail=##Class(web.DHCDocOrderEntry).GetOrderItemDetail(PatType,InsType,OEORIRowid)
	.s OEORISum=$p(OEORIDetail,"^",1)
	.s OEORIDiscSum=$p(OEORIDetail,"^",2)
	.s OEORIInsSum=$p(OEORIDetail,"^",3)
	.s OEORIPatSum=$p(OEORIDetail,"^",4)
	.s ToBillSum=ToBillSum+OEORISum
	.s ToBillInsSum=ToBillInsSum+OEORIDiscSum
	.s ToBillDiscSum=ToBillDiscSum+OEORIDiscSum
	.s ToBillPatSum=ToBillPatSum+OEORIPatSum
	s Amount=$fn(Amount,"",4)
	s ToBillSum=$fn(ToBillSum,"",4)
	Q:(ToBillSum+Amount)>PrescLimitSum 1
	Q 0
}

ClassMethod CheckDiagnosLimit(PAADMRowid As %String, ARCIMRowid As %String) As %String
{
}

ClassMethod CheckItemAuthority(UserRowId, ArcimRowId) As %String
{
	;w ##class(web.DHCDocOrderCommon).CheckItemAuthority("590","4661||1")
	s ArcimRowId=$p(ArcimRowId,"||")
	s ssgroup=$p(^SSU("SSUSR",UserRowId),"^",5)
	s ItemCat=$p(^ARCIM(ArcimRowId,1,1),"^",10)
	s OrdCat=$p(^ARC("IC",ItemCat),"^",8)
	
	&SQL(Select Count(*) into :Count From SQLUser.SS_GroupOrderCategory where SSORD_ParRef=:ssgroup And SSORD_OrdCat_DR=:OrdCat and SSORD_OrdSubCategory<>"")
	if Count>0 {
		&SQL(Select SSORD_RowId into :RowId From SQLUser.SS_GroupOrderCategory where SSORD_ParRef=:ssgroup And SSORD_OrdCat_DR=:OrdCat And SSORD_OrdSubCategory=:ItemCat)
	}else{
		&SQL(Select SSORD_RowId into :RowId From SQLUser.SS_GroupOrderCategory where SSORD_ParRef=:ssgroup And SSORD_OrdCat_DR=:OrdCat)
	}
	q:SQLCODE 0
	Q 1
}

ClassMethod CheckItemExcutable(EpisodeID As %String, OrderItemRowId As %String, LogonDepRowId As %String) As %String
{
	s Find=0
	s ArcimRowId=$P($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),1)),"^",2)
	s RecLocRowId=$P($G(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),3)),"^",6)
	s ret=..GetRecloc(EpisodeID,ArcimRowId)
	s len=$l(ret,$C(2))
	f i=1:1:len {
		s recloc=$p($P(ret,$C(2),i),$c(1),1)
		if recloc=LogonDepRowId {
			s Find=1
			Q 
		}
	}
	Q:Find=1 1
	Q 0
}

/// Creator:      郭荣勇
/// CreatDate:    2009.05.17
/// Description:  根据外部代码判断检验医嘱是否可用?由于设备或试剂原因会临时停用该检验项目
/// Table:        
/// Input:        OrderLabExCode:外部代码
/// Return:       Y:可以使用?N:不可用
/// Others: 
ClassMethod CheckLabItemActive(OrderLabExCode As %String, HospitalId As %String = "") As %String
{
	n (OrderLabExCode,HospitalId,%session)
	s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
	Q:OrderLabExCode="" "Y"
	i $d(^DHCLISBSVersion(1)) Quit ##Class(DHCLIS.DHCCommon).GetTSActive(OrderLabExCode,$g(HospitalCode))
	
	s TempData=^TTAB("TS",OrderLabExCode)
	s ActiveFlag=$p(TempData,"\",12)
	
	Q ActiveFlag
}

ClassMethod CheckNeedSkinTest(EpisodeID As %String, ArcimRowid As %String) As %String
{
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Q:OrderRowid="" "N"
	s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ArcimRowid)
	Q:GenericName'="青霉素类" "N"
	s ARCIMDesc="",find="N"
	s SttDat1=..%SysDate()-3
	;循环取出医嘱
	for SttDat=SttDat1:1:+$H  {
		s child=0 f  s child=$o(^OEORDi(0,"StDt",SttDat,OrderRowid,child)) q:(child="")!(find="Y")  d
		.s itemstat=$p($g(^OEORD(OrderRowid,"I",child,1)),"^",13)
		.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	 	.Q:statcode'="V" 
		.s itemrowid=$p($g(^OEORD(OrderRowid,"I",child,1)),"^",2)
		.Q:itemrowid=""
		.s ItemGenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(itemrowid)
		.i ItemGenericName="青霉素类" d
		..s find="Y"
		..s ARCIMDesc=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1)),"^",2)
		.Q:find="Y"
	}
	Q find_"^"_ARCIMDesc
}

/// Creator:      周志强
/// CreatDate:    2009.03.24
/// Description:: 查询患者是否正医保中途结算中,可以录医嘱
/// Table:        PA_Adm
/// Input:        EpisodeID:就诊RowId
/// Output:         
/// Return:       1:禁止录入   0:可以录入
/// Others:        
ClassMethod CheckOrderUnabled(EpisodeID As %String) As %String
{
	s Flag=0
	s DHCADMRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,0))
	Q:DHCADMRowId="" Flag
	s UnableOrder=$P($G(^DHCPAAdm(DHCADMRowId)),"^",10)
	if UnableOrder="Y" s Flag=1
	Q Flag
}

ClassMethod CheckPHInteractWith(DrgItemRowid, OtherDrgItemRowids) As %String
{
	n (DrgItemRowid,OtherDrgItemRowids)
	s Find=0,DrgMastDesc=""
	s DrgMast=+DrgItemRowid
	s len=$l(OtherDrgItemRowids,"^")
	for i=1:1:len  {
		s CurrDrgMast=+$P(OtherDrgItemRowids,"^",i)
		i $D(^PHCD(DrgMast,"INT",0,"Drug",CurrDrgMast)) s Find=1
		i $D(^PHCD(CurrDrgMast,"INT",0,"Drug",DrgMast)) s Find=1
		i Find=1 s DrgMastDesc=$P(^PHCD(CurrDrgMast,1),"^",2)
		Q:Find=1
	}
	Q Find_"^"_DrgMastDesc
}

/// Creator:      周志强
/// CreatDate:    2009.03.12
/// Description:: 查询患者是否正在住院
/// Table:        PA_Adm
/// Input:        PatientID:病人ID
/// Output:         
/// Return:       1:在院   0:不在院
/// Others:        
ClassMethod CheckPatInIPAdmission(PatientID As %String, HospID As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s PaadmRowId="",InFlag=0
	if PatientID="" {
		s EpisodeID=%request.Get("EpisodeID")
		if EpisodeID="" q ""
		s PatientID=$P(^PAADM(EpisodeID),"^",1)
	}
	f  s PaadmRowId=$O(^PAPERdr(PatientID,"ADM","I",PaadmRowId)) q:(PaadmRowId="")||(InFlag=1)  d
	.s PatVistiStatus=$p($g(^PAADM(PaadmRowId)),"^",20)
	.q:PatVistiStatus'="A" // 不是在院病人则退出
	.s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowId)
    .Q:(AdmHospitalId'=HospID)
	.s InFlag=1
	
	Q InFlag
}

ClassMethod CheckRepeatLabSpec(TSList As %String, TS As %String, HospitalId As %String = "") As %String
{
	
	s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
 	s TSList=$g(TSList),TS=$g(TS)
 	i $d(^DHCLISBSVersion(1)) q ##Class(DHCLIS.DHCCommon).CheckRepeatLabSpec(TSList,TS,$g(HospitalCode))
 
 k ^TMP($zn,$j)
 s temtc=$p($p(TS,$c(1),2),"@",1)
 s TS=$p(TS,$c(1),1)
 i $l(temtc),$d(^TTAB("TC",temtc)) d   //医嘱合并
 .s ^TMP($zn,$j,"TC",temtc)=""
 e  d
 .s seq="" f  s seq=$o(^TTAB("TS",TS,0,seq)) q:seq=""  d
 ..s temstr=^(seq)
 ..s temtc=$p(temstr,"\",8)
 ..i '$l(temtc) q
 ..;科室代码+9999为备注项目
 ..i $e(temtc,2,$l(temtc))="9999" q
 ..;检查微生物项目
 ..i $p(^TTAB("TC",temtc),"\",3)="V" q
 ..;检查ResultCopy设置
 ..i $p(^TTAB("TC",temtc),"\",6)="Y" q
 ..s ^TMP($zn,$j,"TC",temtc)=""
 s flag=0
 f temi=1:1:$l(TSList,"^") d  i flag=1 q
 .s temTS=$p(TSList,"^",temi)
 .s temtc=$p($p(temTS,$c(1),2),"@",1)
 .s temTS=$p(temTS,$c(1),1)
 .i $l(temtc),$d(^TMP($zn,$j,"TC",temtc)) s flag=1 q
 .i $l(temtc),$d(^TTAB("TC",temtc)) q
 .s seq=""  f  s seq=$o(^TTAB("TS",temTS,0,seq)) q:seq=""  d
 ..s temstr=^(seq)
 ..s temtc=$p(temstr,"\",8)
 ..i '$l(temtc) q
 ..;科室代码+9999为备注项目
 ..i $e(temtc,2,$l(temtc))="9999" q
 ..;检查微生物项目
 ..i $p(^TTAB("TC",temtc),"\",3)="V" q
 ..;检查ResultCopy设置
 ..i $p(^TTAB("TC",temtc),"\",6)="Y" q
 ..i $d(^TMP($zn,$j,"TC",temtc)) s flag=1 q
 k ^TMP($zn,$j)
 q flag
}

// ##class(web.DHCDocOrderCommon).CheckItemRecLoc("685||1","308"_$c(1)_"门诊药房"_$c(1)_"Y"_$c(1)_"","655")

ClassMethod CheckItemRecLoc(ArcimRowId As %String, PassRecLocStr As %String, EpisodeID As %String = "") As %String
{
	;s ^zhou("CheckItemRecLoc")="##class(web.DHCDocOrderCommon).CheckItemRecLoc("""_ArcimRowId_""","""_PassRecLocStr_""","""_EpisodeID_""")"

	Q:PassRecLocStr="" ""
	s ret=""
	s RecLocCount=$LENGTH(PassRecLocStr,$C(2))
	F i=1:1:RecLocCount {
		S RecLocStr=$P(PassRecLocStr,$C(2),i)
		s ReclocRowId=$P(RecLocStr,$C(1),1)
		if (..CheckItemLoc(ArcimRowId,ReclocRowId,EpisodeID)) {
			if ret="" {
				s ret=RecLocStr
			}else{
				s ret=ret_$C(2)_RecLocStr
			}
		}
	}
	Q ret
}

ClassMethod CheckItemLoc(ArcimRowId As %String, LocRowId As %String, EpisodeID As %String = "") As %String
{
	s AllowOrderWOStockCheck=$p($G(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",11)
	Q:AllowOrderWOStockCheck="Y" 1

	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
	s OrderType=""
	i ItemCatRowid'="" s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	Q:OrderType'="R" "1"
	s INCIRowId=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowId)
	Q:INCIRowId="" 1
	s LimitFlag=0
	//作为接收科室时能接收的就诊类型 ClinicType(门诊O,急诊E,住院I,体检H)
    s CTLOCClinicType=$p($g(^CTLOC(LocRowId)),"^",85)
    if (CTLOCClinicType'="")&&(EpisodeID'="") {
	    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	    i ("&"_CTLOCClinicType_"&")'[("&"_AdmType_"&") s LimitFlag=1
	}
	Q:LimitFlag=1 0
    s BroadPatientGroupDR=$p($g(^CTLOC(LocRowId)),"^",33)
    i (BroadPatientGroupDR'="")&(EpisodeID'="") {
            s BroadPatientGroupCode=$p($g(^PAC("BPG",BroadPatientGroupDR)),"^",1)
            s BroadPatientGroupDesc=$p($g(^PAC("BPG",BroadPatientGroupDR)),"^",2)
            s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
            i ("-"_BroadPatientGroupDesc_"-")'[("-"_AdmType_"-") s LimitFlag=1
    }
    Q:LimitFlag=1 0

	&SQL(SELECT INCIL_RowId into :INCILRowId FROM SQLUser.INC_ItmLoc
	WHERE INCIL_INCI_ParRef=:INCIRowId AND INCIL_CTLOC_DR=:LocRowId)
	;if SQLCODE Q 0
	Q 1
}

ClassMethod CheckStockEnoughOld(arcim As %String, Qty As %String, RecLoc As %String, EpisodeType As %String = "") As %Status
{
	Quit:arcim="" 1
	set AllowOrderWOStockCheck=$p($G(^ARCIM(+arcim,$p(arcim,"||",2),8)),"^",11)
	set HospitalCode=..GetCurrentSYSHospitalCode("")
	set HospitalID=""
	if (HospitalCode'="") s HospitalID=$o(^CT("HOSP",0,"Code",HospitalCode,""))
	set IsEnableBatItem=##class(web.DHCOEDispensing).IsEnableBatItem(arcim,"",HospitalID)
	Q:(AllowOrderWOStockCheck="Y")&&(IsEnableBatItem="0") 1

	//Q:AllowOrderWOStockCheck="Y" 1
	Set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	Quit:inci="" 1
	
	s HospitalCode=..GetCurrentHospitalCode()
	//是否判断实库存 0 判断逻辑库存 1 判断实际库存
	s CheckRealStock=..%GetConfig("CheckRealStock")
	//是否判断库存
	s NotCheckStock=..%GetConfig("NotCheckStock")
	q:NotCheckStock="1" "1"
	;判断药品是否被药房锁定
	;2010.07.13更新标准版时由药库组迁移至DHC-APP下类中
	;s INCIItemLocked=$$GetIncItmLockFlag^DHCSTCOMMONSRV3(RecLoc,inci)
	s INCIItemLocked=##Class(web.DHCSTCOMMONSRV).GetIncItmLockFlag(RecLoc,inci)
	q:INCIItemLocked="Y" "-1"
	;集成药房接口 0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
	s Ret=##Class(web.DHCSTINTERFACE).GetAvailQtyByArc(arcim , RecLoc, Qty, CheckRealStock)
	s:Ret<0 Ret=0
	Q Ret
}

// w ##class(web.DHCDocOrderCommon).CheckStockEnough("2323||1",3,113,"I","195^113^0^12^1^7^2020-08-17^")

ClassMethod CheckStockEnough(arcim As %String, Qty As %String, RecLoc As %String, EpisodeType As %String = "", ExpStr As %String = "") As %Status
{
	s ^tempscl("CheckStockEnough",arcim)=arcim_","_Qty_","_RecLoc_","_EpisodeType_","_ExpStr
	Quit:arcim="" 1
	s Adm=$p(ExpStr,"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s LogonLocRowId=$p(ExpStr,"^",2)
	s Sequence=$p(ExpStr,"^",3)
	s InstrRowId=$p(ExpStr,"^",4)
	s OrderOpenForAllHosp=$p(ExpStr,"^",5)
	if (OrderOpenForAllHosp="") s OrderOpenForAllHosp=0
	s OrderPriorRowid=$p(ExpStr,"^",6)
	s OrdStartDate=$p(ExpStr,"^",7)
	s ImportByContingences=$p(ExpStr,"^",8)
	s acimDesc=$p($G(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	set AllowOrderWOStockCheck=$p($G(^ARCIM(+arcim,$p(arcim,"||",2),8)),"^",11)
	if (LogonLocRowId'="") {
		s HospitalID=$p(^CTLOC(LogonLocRowId),"^",22)
	}else{
		s HospitalID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	}
	set IsEnableBatItem=##class(web.DHCOEDispensing).IsEnableBatItem(arcim,Adm,HospitalID)
	s Ret=0
	if (AllowOrderWOStockCheck="Y")&&(IsEnableBatItem="0") s Ret=1

	Set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci="") s Ret=1
	;是否判断实库存 0 判断逻辑库存 1 判断实际库存
	s CheckRealStock=..%GetConfig("CheckRealStock",HospitalID)
	;是否判断库存
	s NotCheckStock=..%GetConfig("NotCheckStock",HospitalID)
	if (NotCheckStock=1)&&(IsEnableBatItem=0) s Ret=1
	;判断药品是否被药房锁定
	;2010.07.13更新标准版时由药库组迁移至DHC-APP下类中
	s INCIItemLocked=##Class(web.DHCSTCOMMONSRV).GetIncItmLockFlag(RecLoc,inci,PAAdmType)
	q:INCIItemLocked="Y" "-2^"_acimDesc
	if (Ret=0){
		;集成药房接口 0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
		s Ret=##Class(web.DHCSTINTERFACE).GetAvailQtyByArc(arcim , RecLoc, Qty, CheckRealStock)
		s:Ret<0 Ret=0
	}
	/*if Ret'=0,Sequence=0{
		s AppendExpStr=LogonLocRowId_$C(1)_InstrRowId_$C(1)_OrderOpenForAllHosp_$C(1)_OrderPriorRowid_$C(1)_RecLoc_$C(1)_OrdStartDate_$C(1)_ImportByContingences
		s AppendItem=..GetAppendItemStr(Adm,arcim,AppendExpStr)
		Q:AppendItem="" Ret
		s rtn=1
	    For i=1:1:$l(AppendItem,"^") {
		    s OneAppendItemStr=$p(AppendItem,"^",i)
		    continue:OneAppendItemStr=""
		    s AppendItemRowId=$p(OneAppendItemStr,$c(1),1)
			s AppendItemQty=$p(OneAppendItemStr,$c(1),2)
			s CFRecLocByLogonLoc=$$GetDHCCTLOCFieldValue^DHCDocConfig(LogonLocRowId,1)
			s PAAdmType=$p($g(^PAADM(Adm)),"^",2)
			//s UserLocRowId=$p(OneAppendItemStr,$c(1),3)
			//continue:(UserLocRowId'="")&&(UserLocRowId'=LogonLocRowId)
			s ItemRecLocRowId=$p(OneAppendItemStr,$c(1),3)
			if (ItemRecLocRowId=""){
				if (PAAdmType="I"){
					if CFRecLocByLogonLoc=1 Set RecDepRowid=$$GetLocRecLoc^DHCDocOrderCommonNew(LogonLocRowId,AppendItemRowId)
				    else  Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(Adm,AppendItemRowId)
				}else{
					if CFRecLocByLogonLoc=1 Set RecDepRowid=$$GetLocRecLoc^DHCDocOrderCommon(LogonLocRowId,AppendItemRowId)
			        else  Set RecDepRowid=$$GetRecloc^DHCDocOrderCommon(Adm,AppendItemRowId)
				}
			}else{
				Set RecDepRowid=ItemRecLocRowId
			}
			if (RecDepRowid="") {
				if (PAAdmType="I"){
					;没有维护接受科室默认为患者所在科室
					s PACWardID=$P($g(^PAADM(Adm)),"^",70)
					s:(PACWardID'="") RecDepRowid=$P($g(^PAWARD(PACWardID)),"^",5)
				}
				;没有维护接受科室默认为患者所在科室
				s admloc=$P($G(^PAADM(Adm)),"^",4)
				s:RecDepRowid="" RecDepRowid=admloc
			}
			s ExpStr1=Adm_"^"_LogonLocRowId_"^"_i
		    s rtn=..CheckStockEnough(AppendItemRowId,AppendItemQty,RecDepRowid,EpisodeType,ExpStr1)
		    s acimdesc=$p($G(^ARCIM(+AppendItemRowId,$p(AppendItemRowId,"||",2),1)),"^",2)
		    s LocDesc=$p(^CTLOC(RecDepRowid),"^",2)
		    Q:rtn'=1
		    
		}
		i rtn="-1" {
		    Q "-2^"_acimdesc //被锁定
		}
	    i rtn="0" {
		   Q "-3^"_acimdesc_LocDesc //库存不足
		}
	}*/
	Q Ret
}

/// creator：郭荣勇
/// date:20170913
/// desc:根据传入的库存项目及数量判断库存
/// input:INCIPackCombStr:inicRow1_"!"_Qty1_"@"_inicRow2_"!"_Qty2_......
/// output:1 有库存，其他为无库存或者被锁
/// 使用场景：医嘱审核之前调用
/// w ##class(web.DHCDocOrderCommon).CheckStockEnoughByInc("400687!70",99)
ClassMethod CheckStockEnoughByInc(INCIPackCombStr As %String, RecLoc As %String, EpisodeType As %String = "", ExpStr As %String = "", DurFactor As %String, TakingMedicineMethod As %String = "") As %String
{
	s ^tempqujian("CheckStockEnoughByInc")=INCIPackCombStr_","_RecLoc_","_EpisodeType_","_ExpStr_","_DurFactor_","_TakingMedicineMethod
	Q:INCIPackCombStr="" 1
	s Ret=0
	s HospId=$p(ExpStr,"^",1)
	s TakingMedicine="Y" //取药方式可以不判断库存
	if (TakingMedicineMethod'=""){
		s ToStock=$P(^DHCDocConfig("TakingMedicineMethod",TakingMedicineMethod),$c(1),4)
		if ((ToStock="N")||(ToStock=""))  s TakingMedicine="N"
	}
	q:TakingMedicine="N" 1
	//是否判断实库存 0 判断逻辑库存 1 判断实际库存
	s CheckRealStock=..%GetConfig("CheckRealStock",HospId)
	//是否判断库存
	s NotCheckStock=..%GetConfig("NotCheckStock",HospId)
	if (NotCheckStock=1) s Ret=1
	s Lockflag=""
	for i=1:1:$L(INCIPackCombStr,"@") {
		s oneINCIPackComb=$p(INCIPackCombStr,"@",i)
		s inicRow=$p(oneINCIPackComb,"!",1)
		continue:+inicRow=0
		;无库存医嘱不判断
		s arcim=$p(^INCI(inicRow,1),"^",3)
		set AllowOrderWOStockCheck=$p($G(^ARCIM(+arcim,$p(arcim,"||",2),8)),"^",11)
		if AllowOrderWOStockCheck="Y" s Ret=1 quit
		s INCIItemLocked=##Class(web.DHCSTCOMMONSRV).GetIncItmLockFlag(RecLoc,inicRow,EpisodeType)
		if INCIItemLocked="Y" s Lockflag="-1"
		continue:INCIItemLocked="Y" 
		s Qty=$p(oneINCIPackComb,"!",2)*DurFactor
		s Ret=##Class(web.DHCSTINTERFACE).GetAvailQtyByInc(inicRow, RecLoc, Qty, CheckRealStock)
		//b ;只要有无库存的则退出
		i Ret'>0 quit
	}
	i Ret<0 s Ret=0
	if ((Lockflag'="")&&(Ret=0)) q Lockflag
	Q Ret
}

ClassMethod GetAppendItemStr(Adm As %String, arcim As %String, AppendExpStr As %String = "") As %String
{
	Set ord=$o(^OEORD(0,"Adm",Adm,""))
	s EpisodeType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s LogonLocRowId=$p(AppendExpStr,$C(1),1)
	s InstrRowId=$p(AppendExpStr,$C(1),2)
	s OrderOpenForAllHosp=$p(AppendExpStr,$C(1),3)
	s OrderPriorRowid=$p(AppendExpStr,$C(1),4)
	s OrderRecLoc=$p(AppendExpStr,$C(1),5)
	s OrdStartDate=$p(AppendExpStr,$C(1),6)
	s ImportByContingences=$p(AppendExpStr,$C(1),7)
	if (LogonLocRowId'="") {
		s CurLogonHosp=$p(^CTLOC(LogonLocRowId),"^",22)
	}else{
		s CurLogonHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	}
	;绑定医嘱设置->附加医嘱设定(按医嘱)
	s AppendItemStr=##class(DHCDoc.DHCDocConfig.Items).GetItmAddItem(arcim,LogonLocRowId,OrderOpenForAllHosp,CurLogonHosp)
	;绑定医嘱设置->附加医嘱设定(按子类)
	s ARCIMItemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	s ItemCatAppendItemStr=##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem(ARCIMItemCatDR,LogonLocRowId,OrderOpenForAllHosp,CurLogonHosp)
	if (AppendItemStr'="") {
		if (ItemCatAppendItemStr'="") s AppendItemStr=AppendItemStr_"^"_ItemCatAppendItemStr
	}else{
		s AppendItemStr=ItemCatAppendItemStr
	}
	;医生站设置-用法扩展设置-按用法绑定医嘱
	Q:OrderPriorRowid="" AppendItemStr
	Set NotNeedInstrArcim=$$GetDHCCTLOCFieldValue^DHCDocConfig(LogonLocRowId,6)
	Q:NotNeedInstrArcim=1 AppendItemStr
	Q:ImportByContingences="Y" AppendItemStr
	Set OutPriorRowid=+$O(^OECPR(0,"Code","OUT",0))
	Set OnePriorRowid=+$O(^OECPR(0,"Code","ONE",0))
	Q:(OrderPriorRowid=OnePriorRowid)||(OrderPriorRowid=OutPriorRowid) AppendItemStr
	if (EpisodeType="I") {
		Set ExcluedePriorStr=..%GetConfig("IInstrAutoLinkOrdExcludePrior",CurLogonHosp)
	}else{
		Set ExcluedePriorStr=..%GetConfig("OInstrAutoLinkOrdExcludePrior",CurLogonHosp)
	}
	if ((InstrRowId'="")&&("^"_ExcluedePriorStr_"^")'[("^"_OrderPriorRowid_"^")){
		s CFInstrRowId=InstrRowId_"||"_CurLogonHosp
		s NewInstrAppendItemStr=""
		if EpisodeType="I" {
			Set InstrAppendItemStr=$$getconfignode1^DHCDocConfig("InstrIPArcim",CFInstrRowId)
		}else{
			Set InstrAppendItemStr=$$getconfignode1^DHCDocConfig("InstrArcim",CFInstrRowId)
		}
		//用法绑定医嘱,绑定医嘱指定了科室，则按照指定科室医嘱产生，未指定的则按未指定科室产生绑定医嘱
		s InstrAppendItemStr=##Class(DHCDoc.DHCDocConfig.InstrArcim).CheckInstrAppendItemStr(InstrAppendItemStr,LogonLocRowId)
		if (InstrAppendItemStr'="") {
			for InstrAppendIndex=1:1:$L(InstrAppendItemStr,"^") {
				Set AppendItemNod=$p(InstrAppendItemStr,"^",InstrAppendIndex)
				continue:AppendItemNod=""
				Set AppendARCIMRowid=$P(AppendItemNod,"!",1)
				continue:+AppendARCIMRowid=0
				Set AppendQty=$P(AppendItemNod,"!",5)
				i +AppendQty=0 s AppendQty=1
				Set AppInstrRowId=$P(AppendItemNod,"!",6)
				Set OneInstrAppendItem=AppendARCIMRowid_$C(1)_AppendQty_$C(1)_""_$C(1)_AppInstrRowId_$C(1)_OrderOpenForAllHosp
				if NewInstrAppendItemStr="" s NewInstrAppendItemStr=OneInstrAppendItem
				else  if NewInstrAppendItemStr="" s NewInstrAppendItemStr=NewInstrAppendItemStr_"^"_OneInstrAppendItem
			}
		}
		if (AppendItemStr'="") {
			if (NewInstrAppendItemStr'="") s AppendItemStr=AppendItemStr_"^"_NewInstrAppendItemStr
		}else{
			s AppendItemStr=NewInstrAppendItemStr
		}
	}
	;病区绑定医嘱
	if (EpisodeType="I") {
		;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
	 	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LogonLocRowId,Adm)
	 	if (LoginAdmLocFlag="Y"){
		 	s NewArcimWardInfo=""
		 	s ArcimWardInfo=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(Adm,arcim,InstrRowId,"1",OrderOpenForAllHosp)
		 	for AddIndex=1:1:$L(ArcimWardInfo,$C(2)) {
			 	s OneArcimWardInfo=$P(ArcimWardInfo,$C(2),AddIndex)
				s AddArcimItem=$P(OneArcimWardInfo,"^",1)		
				;1:按天,2:按次
				s ExecType=$P(OneArcimWardInfo,"^",2)
				continue:AddArcimItem=""
				s SingleNotFee=$P(OneArcimWardInfo,"^",6)
				s NotLinkPriorStr=$P(OneArcimWardInfo,"^",9)
				s OrderOpenForAllHosp=$P(OneArcimWardInfo,"^",10)
				if (("_"_NotLinkPriorStr_"_")[("_"_OrderPriorRowid_"_")) {
					continue
				}
				/*if (SingleNotFee="1")&&('$D(CacheTemp("DHCCDocInsertItem",$J,ord,MasterSeqNo,"sub"))){
					continue
				}*/
				s ByDay=$CASE(ExecType,1:1,2:"")
				if ByDay=1 {
					Set IsNotInsertFlag=$$GetInstrNotInsertFlag^DHCDocOrderCommonNew(OrderRecLoc,InstrRowId,AddArcimItem,ord,OrdStartDate,LogonLocRowId)
					if IsNotInsertFlag=1 continue
				}
				s Qty=$P(OneArcimWardInfo,"^",4)
				i NewArcimWardInfo="" {
					s NewArcimWardInfo=AddArcimItem_$C(1)_Qty_$C(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp
				}else{
					s NewArcimWardInfo=NewArcimWardInfo_"^"_AddArcimItem_$C(1)_Qty_$C(1)_""_$C(1)_""_$C(1)_OrderOpenForAllHosp
				}
			}
			if (AppendItemStr'="") {
				if (NewArcimWardInfo'="") s AppendItemStr=AppendItemStr_"^"_NewInstrAppendItemStr
			}else{
				s AppendItemStr=NewArcimWardInfo
			}
		}
	}
	
 	Q AppendItemStr
}

/// w ##class(web.DHCDocOrderCommon).CheckOutOrderSum(30,"",11)
ClassMethod CheckOutOrderSum(PAADMRowid As %String, InsType As %String, Amount As %String) As %String
{
	n (PAADMRowid,InsType,Amount)
	;需要做成设置,需要建表,现只徐州用
	s ^gry("Out",0)=PAADMRowid_","_InsType_","_Amount
	s EpisodeType=$P(^PAADM(PAADMRowid),"^",2)
	s PAADMInsType=$P(^PAADM(PAADMRowid,1),"^",7)
	i EpisodeType="I" s InsType=PAADMInsType
	
	s OutOrderLimitSum=0
	s HospitalCode=..GetCurrentHospitalCode()
	if HospitalCode="JSXZZXYY" {
		if ..GetInsurFlag(InsType)=1 s OutOrderLimitSum=200
	}
	s ToBillSum=0
	s ToBillPatSum=0
	s ToBillDiscSum=0
	s ToBillInsSum=0
	s PatientID=$P(^PAADM(PAADMRowid),"^",1)
	s PatType=$P(^PAPER(PatientID,"PER",1),"^",10)
	s OutOrderLimitSum=$fn(OutOrderLimitSum,"",2)
	Q:(OutOrderLimitSum="0.00") 0
	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(PAADMRowid)
	Q:OrderRowid="" 0
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s OrderBillTypeRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",18)
	.Q:(OrderBillTypeRowid'=InsType)
	.;如果医嘱未核实则为退出
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.;trakcare先开的医嘱是inactive
	.Q:($g(statcode)'="V")&&($g(statcode)'="E")
	.s ArcimRowId=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.s ItemCatRowid=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10)
 	.s OrderType=""
 	.i ItemCatRowid'="" s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
 	.Q:OrderType'="R"
 	.s OEORIPriorityDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",8)
 	.s OEORIPriorityCode=""
 	.if OEORIPriorityDR'="" s OEORIPriorityCode=$p(^OECPR(OEORIPriorityDR),"^",1)
 	.Q:OEORIPriorityCode'="OUT"
	.s OEORIRowid=OrderRowid_"||"_itemsub
	.s OEORIDetail=##Class(web.DHCDocOrderEntry).GetOrderItemDetail(PatType,InsType,OEORIRowid)
	.s OEORISum=$p(OEORIDetail,"^",1)
	.s OEORIDiscSum=$p(OEORIDetail,"^",2)
	.s OEORIInsSum=$p(OEORIDetail,"^",3)
	.s OEORIPatSum=$p(OEORIDetail,"^",4)
	.s ToBillSum=ToBillSum+OEORISum
	.s ToBillInsSum=ToBillInsSum+OEORIDiscSum
	.s ToBillDiscSum=ToBillDiscSum+OEORIDiscSum
	.s ToBillPatSum=ToBillPatSum+OEORIPatSum
	s ^gry("Out",1)=Amount_","_ToBillSum_","_OutOrderLimitSum
	s Amount=$fn(Amount,"",4)
	s ToBillSum=$fn(ToBillSum,"",4)
	Q:(ToBillSum+Amount)>OutOrderLimitSum 1
	Q 0
}

/// w ##class(web.DHCDocOrderCommon).CheckPriorAllowRange("",7,"5503||1",2,"")
ClassMethod CheckPriorAllowRange(Adm As %String, OrderPriorRowid As %String, OrderARCIMRowid As %String, HospId As %String = "", Loc As %String = "", FreqID As %String = "", ErrMsg As %String = "") As %String
{
	;s ^Tempscl("CheckPriorAllowRange")=Adm_","_OrderPriorRowid_","_OrderARCIMRowid_","_HospId_","_Loc
	Q:OrderPriorRowid="" 0
	s langid=..%LanguageID()
	s OrderName=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",2)
	s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
	;出院带药医嘱
    s OutOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))
    ;s OneOrderPriorRowid=$O(^OECPR(0,"Code","ONE",0))
	if (Adm'="") {
		;医生开出院医嘱后,不允许护士开长期医嘱
		s PAADMMedDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(Adm)
		if ((PAADMMedDischarged=1)||(PAADMMedDischarged=2))&&(OrderPriorRowid=LongOrderPriorRowid){
			s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",医生开立出院医嘱后,不允许录入长期医嘱!",langid)
			Q 9
		}
	}
	s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(OrderARCIMRowid,HospId)
	s TransType=##Class(DHCDoc.Interface.Inside.Invoke).GetArcimTransType(OrderARCIMRowid,HospId)
    if (LongPriorFlag=1)&&((DischargeOrdFlag'=0)||(TransType'="")){
		s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp","是出院转科类医嘱,只能开临时!",langid)
		Q 4
	}
    s ARCIMExtInfo=##class(DHCDoc.DHCDocConfig.ARCIMExt).getARCIMConfig(OrderARCIMRowid)
	;医嘱开始日期停止长期医嘱标志
	s StopAfterLongOrder=$P(ARCIMExtInfo,"^",3)
	;配置自动停长期后是否允许开立成长期
	s AllowLongOrder=+$P(ARCIMExtInfo,"^",6)
	if (StopAfterLongOrder=1)&&(AllowLongOrder=0)&&(LongPriorFlag=1){
		s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",是配置审核之后停所有长期的医嘱,只能开临时!",langid)
		Q 6
	}
	s PRNFreqRowid=$o(^PHCFR(0,"Code","PRN",0))
	s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	if (OrderPriorRowid=OutOrderPriorRowid) {
		;出院医嘱只能是临时医嘱
		if (OrderType'="R"){
			s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",不能将该非药品医嘱开为出院带药医嘱.",langid)
			Q 5
		}
		s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(OrderARCIMRowid)
		;出院带药不能下的子分类
		s OutOrderNotItemCatStr=..%GetConfig1("OutOrderNotItemCat",OrderPriorRowid,HospId)
		s OutOrderNotItemCatStr="^"_OutOrderNotItemCatStr_"^"
		;出院带药不能下的子分类-例外科室
		s OutOrderNotItemCatLessLocStr=##class(DHCDoc.DHCDocConfig.ItemPrior).GetLessLocConfig("OutOrderNotItemCat",ItemCatRowid,HospId)
		s:OutOrderNotItemCatLessLocStr OutOrderNotItemCatLessLocStr="^"_OutOrderNotItemCatLessLocStr_"^"
		
		;出院带药不能下的管制分类
		s OutOrderNotPoisonStr=..%GetConfig1("OutOrderNotPoison",OrderPriorRowid,HospId)
		s OutOrderNotPoisonStr="^"_OutOrderNotPoisonStr_"^"
		;出院带药不能下的管制分类-例外科室
		s OutOrderNotPoisonLessLocStr=""
		if (PoisonRowid'="") {
			s OutOrderNotPoisonLessLocStr=##class(DHCDoc.DHCDocConfig.ItemPrior).GetLessLocConfig("OutOrderNotPoison",PoisonRowid,HospId)
		}
		s:OutOrderNotPoisonLessLocStr OutOrderNotPoisonLessLocStr="^"_OutOrderNotPoisonLessLocStr_"^"
		//if (OutOrderNotItemCatStr[("^"_ItemCatRowid_"^"))&&(ItemCatRowid'="") Q 1
		if (OutOrderNotItemCatStr[("^"_ItemCatRowid_"^"))&&(ItemCatRowid'="") {
			if (OutOrderNotItemCatLessLocStr="")||((OutOrderNotItemCatLessLocStr'[("^"_Loc_"^"))&&(Loc'="")){
				s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp","出院带药不能下该子类和管制分类！",langid)
				Q 1
			}
		}else{
			if (OutOrderNotItemCatLessLocStr[("^"_Loc_"^"))&&(Loc'=""){
				s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp","出院带药不能下该子类和管制分类！",langid)
				Q 1
			}
		}
		
		if (OutOrderNotPoisonStr[("^"_PoisonRowid_"^"))&&(PoisonRowid'="") {
			if (OutOrderNotPoisonLessLocStr="")||((OutOrderNotPoisonLessLocStr'[("^"_Loc_"^"))&&(Loc'="")){
				s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp","出院带药不能下该子类和管制分类！",langid)
				Q 2
			}
		}else{
			if (OutOrderNotPoisonLessLocStr[("^"_Loc_"^"))&&(Loc'=""){
				s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp","出院带药不能下该子类和管制分类！",langid)
				Q 2
			}
		}
		;出院带药不能下的频次
		if FreqID'=""{
			s OutOrderNotFreqIDStr="^"_..%GetConfig1("OutOrderNotFreq",OrderPriorRowid,HospId)_"^"
			s OutOrderNotFreqLessLoc="^"_##class(DHCDoc.DHCDocConfig.ItemPrior).GetLessLocConfig("OutOrderNotFreq",FreqID,HospId)_"^"
			;出院带药医嘱扩展设置-不能下的频次：勾选频次科室没有例外、未勾选频次科室例外
			if ((OutOrderNotFreqIDStr[("^"_FreqID_"^"))&&((OutOrderNotFreqLessLoc'[("^"_Loc_"^"))||(Loc="")))
			 ||((OutOrderNotFreqIDStr'[("^"_FreqID_"^"))&&(OutOrderNotFreqLessLoc[("^"_Loc_"^")))||(PRNFreqRowid=FreqID){
				s FreDesc=$P(^PHCFR(FreqID),"^",3)
	    		s FreDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FreDesc,langid)
        		s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",出院带药不能下该频次:",langid)_FreDesc
				Q 11
			}
		}
	}
	;检验,检查不能下长期医嘱
	s IsExamItemFlag=..GetItemServiceFlag(OrderARCIMRowid)
	i ((OrderType="L")||(IsExamItemFlag=1))&&(LongPriorFlag=1){
		s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",检验检查仅允许开临时医嘱,请修改.",langid)
		Q 3
	}
	s PAADMType="",UserEMVirtualtLong=0
	i Adm'="" {
		s PAADMType=$p($g(^PAADM(Adm)),"^",2)
		s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(Adm)
	}
	;长期不能开ST ONCE
	if FreqID'=""{
		s FreqCode=$ZCVT($P($g(^PHCFR(FreqID)),"^",1),"U")
		if ((FreqCode="ST")||(FreqCode="ONCE"))&&LongPriorFlag{
			s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",",ONCE与ST频次不能下长期医嘱",langid)
			Q 12
		}
	}
	;门诊与出院带药不能开PRN
	if (PRNFreqRowid=FreqID)&&'LongPriorFlag{
		s ErrMsg=..%Translate("oeorder.oplistcustom.new.csp",",非长期医嘱不能下PRN医嘱",langid)
		Q 13
	}
	if PAADMType="I"{
		s PriorCheckRet=##Class(DHCDoc.DHCDocConfig.ItemPrior).CheckItemPriorAllow(OrderARCIMRowid,OrderPriorRowid,HospId,.TipMsg)
		if PriorCheckRet=0{
			s ErrMsg=OrderName_..%Translate("oeorder.oplistcustom.new.csp",","_TipMsg,langid)
			Q:LongPriorFlag 7
			Q 10
		}
	}
	//pb by tanjishan 不再限制只能录入长期医嘱
	#;s IsHourItem=..IsHourItem(OrderARCIMRowid)
	#; if (IsHourItem="1")&&(LongOrderPriorRowid'=OrderPriorRowid){
	#; 	Q 8
	#; }
	Q 0
}

/// creator:guorongyong
/// date:2011-04-29
/// desc:根据费别控制医嘱子类可下品种数和疗程
/// w ##class(web.DHCDocOrderCommon).CheckOutOrderOtherContral(42628,131,95,217,"7^761||1!7^29||1!7^1729||1!7^1740||1","1740||1",24,2,75,102)
ClassMethod CheckOutOrderOtherContral(EpisodeID As %String, OrderBillTypeRowid As %String, DurRowid As %String, ItemCatRowid As %String, ARCIMRowidStr As %String, ArcimId = "", FreqRowid = "", qtyPackUom = "", DoseQty = "", unitUomId = "", CurLogonHospId = "") As %String
{
	n (EpisodeID,OrderBillTypeRowid,DurRowid,ItemCatRowid,ARCIMRowidStr,ArcimId,FreqRowid,qtyPackUom,DoseQty,unitUomId,CurLogonHospId,%session)
	s ^tmpgry("CheckOutOrderOtherContral")=EpisodeID_","_OrderBillTypeRowid_","_DurRowid_","_ItemCatRowid_","_ARCIMRowidStr_","_ArcimId_","_FreqRowid_","_qtyPackUom_","_DoseQty_","_unitUomId
	
	kill ^TMPOutOrderSum($J)
	s HospitalCode=..GetCurrentHospitalCode()
	s myrtn=0,myDesc=""
	s PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
	if OrderBillTypeRowid=""  s OrderBillTypeRowid=PAADMInsType
	Set langid=..%LanguageID()
	s DurFactor=0
	if DurRowid'="" {
		i HospitalCode="BJXHYY" {
			;通过界面参数计算医嘱的实际使用天数
			s DurFactor=##class(web.DHCDocOrderEntry).CalcDurByArcim(ArcimId,FreqRowid,DurRowid,qtyPackUom,DoseQty,unitUomId)
			s today=..%SysDate()
			s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
			s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
			s ARCIMIdStr="^"_ArcimId_"^"
			s findorder=""
			;循环取出医嘱
			s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
			.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
			.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
			.s BBExtCode=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",18)
			.s SttDat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
			.s Billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
			.Q:(ARCIMIdStr'[("^"_itemrowid_"^"))
			.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
			.Q:(statcode'="V")&&(statcode'="I")
			.Q:((PAAdmType="I")!(PAAdmType="E"))&(SttDat'=today)
			.i findorder="" s findorder=OrderRowid_"||"_itemsub
			.e  s findorder=findorder_"^"_OrderRowid_"||"_itemsub
			for i=1:1:$l(findorder,"^") {
				s findorderitem=$p(findorder,"^",i)
				if findorderitem="" continue
				s PriorityCode=""
				s PriorityDR=$p($g(^OEORD(+findorderitem,"I",+$p(findorderitem,"||",2),1)),"^",8)
				i PriorityDR'="" s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
				i $zcvt(PriorityCode,"U")="OUT" {
					s findorderDur=##class(web.DHCDocOrderEntry).CalcDur(findorderitem)
					s DurFactor=DurFactor+findorderDur
				}
			}
			b ;1
		}else{
			s DurFactor=$p($g(^PHCDU(DurRowid)),"^",2)
		}
	}
	;找之前已经审核的出院带药医嘱数
	s OEORDRowId=""
	s OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,OEORDRowId),-1)
	if OEORDRowId'="" {
		s OEORIRowId=0
		for  s OEORIRowId=$O(^OEORD(OEORDRowId,"I",OEORIRowId)) Q:OEORIRowId=""  d
		.s OrdStr1=$g(^OEORD(OEORDRowId,"I",OEORIRowId,1))
		.s OrdStr2=$g(^OEORD(OEORDRowId,"I",OEORIRowId,2))
		.s OrdStr3=$g(^OEORD(OEORDRowId,"I",OEORIRowId,3))
		.s OrdStr11=$g(^OEORD(OEORDRowId,"I",OEORIRowId,11))
		.s ArcimRowId=$P(OrdStr1,"^",2)
		.s DuratDR=$P(OrdStr2,"^",6)
		.s statcode=""
		.s itemstat=$p(OrdStr1,"^",13)
		.i itemstat'="" d
		..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		.Q:(statcode'="V")
		.s OrderType=""
		.s SubCatRowId=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",10)
		.if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		.Q:SubCatRowId=""
		.s PriorityCode=""
		.s PriorityDR=$P(OrdStr1,"^",8)
		.if PriorityDR'="" s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
		.if $zcvt(PriorityCode,"U")="OUT" d
		..s ^TMPOutOrderSum($J,SubCatRowId)=(+$G(^TMPOutOrderSum($J,SubCatRowId))+1)_"^"_ArcimRowId
	}
	b ;判断传入医嘱串出院带药品种数
	;ARCIMRowidStr  PriorityDR_"^"_ARCIMRowid_"!"_PriorityDR_"^"_ARCIMRowid
	s Len=$L(ARCIMRowidStr,"!")
	for i=1:1:Len {
		s TempStr=$p(ARCIMRowidStr,"!",i)
		s PriorityDR=$p(TempStr,"^",1)
		s ARCIMRowid=$p(TempStr,"^",2)
		if (ARCIMRowid="")||(PriorityDR="") continue
		s PriorityCode=$P(^OECPR(PriorityDR),"^",1)
		s SubCatRowId=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
		if $zcvt(PriorityCode,"U")="OUT" {
			s ^TMPOutOrderSum($J,SubCatRowId)=(+$G(^TMPOutOrderSum($J,SubCatRowId))+1)_"^"_ARCIMRowid
		}
	}
	b 
	s ItemCatID=0
	for {
		s ItemCatID=$O(^TMPOutOrderSum($J,ItemCatID)) Q:ItemCatID=""
		s TheOutOrderSum=+$g(^TMPOutOrderSum($J,ItemCatID))
		s ARCIMRowid=$p($g(^TMPOutOrderSum($J,ItemCatID)),"^",2)
		s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
		s find=0
		;费别,子类上都设置的情况
		s OOCRowid=0 for {
			;s OOCRowid=$O(^DHCOOOC(0,"ItemCat",ItemCatID,OOCRowid)) Q:OOCRowid=""
			s OOCRowid=$O(^DHCOOOC(OOCRowid)) Q:OOCRowid=""
			s ItemCatRowid=$p($g(^DHCOOOC(OOCRowid)),"^",1)
			s AdmReasonDr=$p($g(^DHCOOOC(OOCRowid)),"^",2)
			s Factor=0
			s DurDR=$p($g(^DHCOOOC(OOCRowid)),"^",3)
			if DurDR'="" s Factor=$p($g(^PHCDU(DurDR)),"^",2)
			s Drugspecies=$p($g(^DHCOOOC(OOCRowid)),"^",4)
			s Drugspecies=##class(User.DHCOutOrderOtherContral).GetTranByDesc("OOCDrugspecies",Drugspecies,langid)
			if AdmReasonDr="" continue
			if OrderBillTypeRowid'=AdmReasonDr continue
			s LimitUseHospDr=$p($g(^DHCOOOC(OOCRowid)),"^",5)
			continue:LimitUseHospDr'=CurLogonHospId
			
			if (ItemCatID'="")&&(ItemCatID'=ItemCatRowid) continue
			s find=1
			if (Drugspecies'="")&&(+Drugspecies<TheOutOrderSum) {
				s myrtn=1
				//s myDesc="医嘱:"_ARCIMDesc_"超出出院带药品种数."
				s myDesc=..%Translate("oeorder.oplistcustom.new.csp","超出出院带药品种数【")_Drugspecies_..%Translate("oeorder.oplistcustom.new.csp","】种")
				Q
			}
			if (Factor'=0)&&(+Factor<+DurFactor) {
				s ARCIMIdStr="^"_ArcimId_"^"
				if ARCIMIdStr'[("^"_ARCIMRowid_"^") continue
				
				s myrtn=1
				s myDesc=..%Translate("oeorder.oplistcustom.new.csp","医嘱:")_ARCIMDesc_..%Translate("oeorder.oplistcustom.new.csp","可用")_DurFactor_..%Translate("oeorder.oplistcustom.new.csp","天,超出出院带药疗程限制")_Factor_..%Translate("oeorder.oplistcustom.new.csp","天.")
				Q
			}
			
		}
		
		;只设置了费别,子类上没有设置的情况,
		if find=0 {
			s OOCRowid=0 for {
				s OOCRowid=$O(^DHCOOOC(OOCRowid)) Q:OOCRowid=""
				s ItemCatRowid=$p($g(^DHCOOOC(OOCRowid)),"^",1)
				i ItemCatRowid'="" continue
				s AdmReasonDr=$p($g(^DHCOOOC(OOCRowid)),"^",2)
				s Factor=0
				s DurDR=$p($g(^DHCOOOC(OOCRowid)),"^",3)
				if DurDR'="" s Factor=$p($g(^PHCDU(DurDR)),"^",2)
				s Drugspecies=$p($g(^DHCOOOC(OOCRowid)),"^",4)
				s Drugspecies=##class(User.DHCOutOrderOtherContral).GetTranByDesc("OOCDrugspecies",Drugspecies,langid)
				if AdmReasonDr="" continue
				if OrderBillTypeRowid'=AdmReasonDr continue
				if (Drugspecies'="")&&(+Drugspecies<TheOutOrderSum) {
					s myrtn=1
					//s myDesc="医嘱:"_ARCIMDesc_"超出出院带药品种数."
					s myDesc=..%Translate("oeorder.oplistcustom.new.csp","超出出院带药品种数【")_Drugspecies_..%Translate("oeorder.oplistcustom.new.csp","】种")
					Q
				}
				if (Factor'=0)&&(+Factor<+DurFactor) {
					s ARCIMIdStr="^"_ArcimId_"^"
					if ARCIMIdStr'[("^"_ARCIMRowid_"^") continue
					b ;
					s myrtn=1
					s myDesc=..%Translate("oeorder.oplistcustom.new.csp","医嘱:")_ARCIMDesc_..%Translate("oeorder.oplistcustom.new.csp","可用")_DurFactor_..%Translate("oeorder.oplistcustom.new.csp","天,超出出院带药疗程限制")_Factor_..%Translate("oeorder.oplistcustom.new.csp","天.")
					Q
				}
			}
		} 		
		
		if myrtn=1 Q
	}
	
	 Q myrtn_"^"_myDesc
}

ClassMethod FindItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, Days As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PAADMRegConDisDR=""
	s:EpisodeID'="" PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s arcim=0 f  s arcim=$o(^ARCIM(arcim)) q:arcim=""  d
	.do ResetVariables
	.s sub=$O(^ARCIM(arcim,0))
	.Q:sub=""
	.s ArcimRowid=arcim_"||"_sub
	.q:##class(web.DHCDocOrderEntry).ValARCItem(ArcimRowid)
	.s isOwn=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",13)
	.q:isOwn="N"
	.s Item=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
	.s EffDateTime=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",13)
	.s EffDate=$P(EffDateTime,"Z",1)
	.s CurrDate=..%SysDate()
	.q:EffDate+Days<CurrDate
	.s EffDateStr=$Zd(EffDate,3)
	.s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.s OrderCatDr=$P(^ARC("IC",ItemCatDR),"^",8)
	.s OrderCat=$p(^OEC("ORCAT",OrderCatDr),"^",2)
	.s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	.s BillUOMDesc=""
	.s ExpStrIn="^^"_EpisodeID_"^"
	.s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ArcimRowid, CurrDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,"",ExpStrIn)
	.s Price=$P(retPrice,"^",1)
	.;s BillUOM=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	.s BillUOM=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,AdmType)
	.i BillUOM'="" s BillUOMDesc= $P(^CT("UOM",BillUOM),"^",2)
	.;s EffDateStr=EffDate
	.do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OrderType,Item,EffDateStr,BillUOMDesc,Price,ArcimRowid,OrderCat)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	set (OrderType,Item,EffDateStr,BillUOMDesc,tPrice,ArcimRowid,OrderCat)=""
	Quit
}

ClassMethod FindItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOEPrefersClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOEPrefersFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOEPrefersExecute(ByRef qHandle As %Library.Binary, TABITEMS As %Library.String = "", groupno As %Library.Integer = 0, getDetails As %Library.Boolean = 0, SSGroupID As %Library.String = "", EpisodeID As %Library.String = "", formulary As %Library.String = "") As %Library.Status
{
	;n (TABITEMS)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;
	s Values="",Desc=""
	s Items=$P(TABITEMS,$C(1),groupno)
	s len=$l(Items,$C(28))
	
	for i=2:1:len  {
		s ItemStr=$P(Items,$C(28),i)
		Q:ItemStr=""
		s ordertype=$P(ItemStr,$C(4),1)
		s itemrowid=$P(ItemStr,$C(4),2)
		Q:itemrowid=""
		s Values=itemrowid
		if ordertype="ARCIM" d
		.Q:##class(web.DHCDocOrderEntry).ValARCItem(itemrowid)'=0
		.Q:$p($g(^ARCIM(itemrowid,1,7)),"^",13)'["Y"
		.s Baseuomdesc=""
		.s FormDurRowid=""
		.s ItemCatDR=$p(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
		.s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
		.Set inci=$o(^INCI(0,"ARCIM_DR",+itemrowid,""))
		.if inci'="" d
		..s baseuom=$p(^INCI(inci,1),"^",10)
	    ..i baseuom'="" s Baseuomdesc=..GetUOMDesc(baseuom)
	    .s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itemrowid)
	    .i DrgformRowid'="" d
	    ..s FormDurRowid=$p($g(^PHCD(+DrgformRowid,"DF",$P(DrgformRowid,"||",2),1)),"^",8)
		.s Desc=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1)),"^",2)
		.s Values="ARCIM"_$C(4,4)_itemrowid_$C(4,4,4,4)_Baseuomdesc_$C(4)_FormDurRowid_$C(4)_ordertype_$C(4,4,4,4,4,4,4,4)
		e  d
		.Q:##class(web.DHCDocOrderEntry).ValARCOS(itemrowid)'=0
		.s Desc=$p(^ARCOS(itemrowid),"^",2)
		.s Values="ARCOS"_$C(4,4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4,4,4)
	    do OuputRow3    }
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow3
	set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindOEPrefersFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOEPrefersExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOETabItemsClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOETabItemsFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOETabItemsExecute(ByRef qHandle As %Library.Binary, TABITEMS As %Library.String = "", groupno As %Library.Integer = 0, getDetails As %Library.Boolean = 0, SSGroupID As %Library.String = "", EpisodeID As %Library.String = "", formulary As %Library.String = "") As %Library.Status
{
	n (qHandle,TABITEMS, groupno, getDetails, SSGroupID, EpisodeID , formulary)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	;
	s Values="",Desc=""
	s Items=$P(TABITEMS,$C(1),groupno)
	s len=$l(Items,$C(28))
	
	for i=2:1:len  {
		s ItemStr=$P(Items,$C(28),i)
		continue:ItemStr=""
		s ordertype=$P(ItemStr,$C(4),1)
		s itemrowidInfo=$P(ItemStr,$C(4),2)
		s itemNotes=$P(ItemStr,$C(4),3)
		continue:itemrowidInfo=""
		s Values=itemrowidInfo
		if ordertype="ARCIM" {
			s ArcimRowID=$P(itemrowidInfo,"*",1)
			s PartInfo=""
			if $P(itemrowidInfo,"*",2)="S" {
				;新产品的【部位、体位和后处理描述串^部位和体位串^后处理ID】
				s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR($P(itemrowidInfo,"*",3,$L(itemrowidInfo,"*")),"*","^"))
			}
			
			continue:##class(web.DHCDocOrderEntry).ValARCItem(ArcimRowID)'=0
			s Baseuomdesc=""
			s FormDurRowid=""
			continue:'$d(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1))
			s ItemCatDR=$p(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1),"^",10)
			s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
			Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowID,""))
			if inci'="" {
				s baseuom=$p(^INCI(inci,1),"^",10)
	    		i baseuom'="" s Baseuomdesc=..GetUOMDesc(baseuom)
			}
	    	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowID)
	    	i DrgformRowid'="" s FormDurRowid=$p($g(^PHCD(+DrgformRowid,"DF",$P(DrgformRowid,"||",2),1)),"^",8)
			s Desc=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",2)
			s Desc=Desc_PartInfo
			if (itemNotes'="") {
				s Desc=Desc_"**"_itemNotes
			}
			i getDetails=1 {
				s Values="ARCIM"_$C(4,4)_itemrowidInfo_$C(4,4,4,4)_Baseuomdesc_$C(4)_FormDurRowid_$C(4)_ordertype_$C(4,4,4,4,4,4,4)_itemNotes
			}else{
				s Values="ARCIM"_$C(4)_itemrowidInfo_$C(4,4,4,4,4,4,4,4,4,4,4,4,4)_itemNotes
			}
		}else{
			s itemrowid=itemrowidInfo
			continue:##class(web.DHCDocOrderEntry).ValARCOS(itemrowid)'=0
			continue:'$d(^ARCOS(itemrowid))
			s Desc=$p(^ARCOS(itemrowid),"^",2)
			i getDetails=1 {
				s Values="ARCOS"_$C(4,4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4,4,4)
			}else{
				s Values="ARCOS"_$C(4)_itemrowid_$C(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
			}
		}
	    do OuputRow2 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindOETabItemsFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOETabItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOSItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOSItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","FindOSItems","1738","2",5716)

ClassMethod FindOSItemsExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, HospitalId As %String, EpisodeID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Temp("DHCOSItem",$j)
	Kill ^||TempSortQueue($j)
	kill ^||TempARCOSSeqNoArr($j)
	s ARCOSCount=0
	Set langid=..%LanguageID()
	s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
	d GetAllOrderSetItem(ARCOSRowid,HospitalCode,EpisodeID,"",ARCOSCount,langid)
	d Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOrderSetItem(ARCOSRowid,ARCOSDateRowid,EpisodeID,OSSerialNo,ARCOSCount,langid)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.do ResetVariables1
	.//添加备注项//医嘱类型项
    .s ItemRemark=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"NOTES",1))
    .s DHCDocOrderTypeID=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",1)
    .i (DHCDocOrderTypeID'="") s DHCDocOrderType=$P($G(^OECPR(DHCDocOrderTypeID)),"^",2) 
    .s DHCDocOrderType=##class(User.OECPriority).GetTranByDesc("OECPRDesc",DHCDocOrderType,langid)
    .i (DHCDocOrderTypeID="") s DHCDocOrderType=""
	.s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(DHCDocOrderTypeID)
    .s ItemSpec=""
    .s ItemSpecCode=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",2)
    .i ItemSpecCode'="" d
    ..i $d(^DHCLISBSVersion(1)) d
    ...s ItemSpec=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(ItemSpecCode,$g(HospitalCode)),$c(2),2)
    ..e  d
    ...s ItemSpec=$p($G(^TTAB("SPEC",ItemSpecCode)),"\",1)
    .s OrderPriorRemarksDR=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",3)
    .s OrderPriorRemarks=$CASE(OrderPriorRemarksDR,"ONE":"取药医嘱","OUT":"出院带药","PRN":"PRN","OM":"自备药","ZT":"嘱托",:"")
	.s OrderPriorRemarks=..%Translate("doc.arcositemlist.hui.csp",OrderPriorRemarks)
	.s OrderMustEnter=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",4)
	.s SpeedFlowRate=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",5)
	.s FlowRateUnitRowid=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",6)
	.if (FlowRateUnitRowid'="") s FlowRateUnit=$p($g(^OEC("SFR",FlowRateUnitRowid)),"^",2)
	.e  s FlowRateUnit=""
	.s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
	.s OrderBodyPartLabel=$p($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",7)
	.s NotifyClinician=$P($G(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",8)
	.s OrderBodyPartLabelText=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR(OrderBodyPartLabel,"*","^"))
	.s ARCIMRowid=$p(s,"^",1)
	.;q:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	.s ItemFreqInterval="",ItemFreqFactor="1",ItemDurFactor="1"
	.s Item=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	.s Item=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",Item,langid)
	.s Item=Item_OrderBodyPartLabelText
	.s ItemQty=$p(s,"^",2)
	.s ItemDurRowid=$p(s,"^",7)
	.s ItemFreqRowid=$p(s,"^",8)
	.s ItemInstrRowid=$p(s,"^",9)
	.s ItemDoseUOMRowid=$p(s,"^",10)
	.s ItemDoseQty=$p(s,"^",13)
	.i (ItemDoseQty[".") s ItemDoseQty=##class(DHCDoc.Util.Base).FormateNumber(ItemDoseQty)
	.s ItemLinkDoctor=$p(s,"^",14)
	.i ItemLinkDoctor'="" d
	..s tempMaster=$p(ItemLinkDoctor,".",1)
	..s tempSubSeqNo=$p(ItemLinkDoctor,".",2)
	..//i (tempSubSeqNo'="")&&($d(^||TempARCOSSeqNoArr($j,ItemLinkDoctor))) s tempMaster=$g(^||TempARCOSSeqNoArr($j,tempMaster))+1,ItemLinkDoctor=tempMaster_"."_tempSubSeqNo
	..//s ^||TempARCOSSeqNoArr($j,ItemLinkDoctor)=tempMaster
	..if tempSubSeqNo'="" d
	...s ItemLinkDoctor=ARCOSCount_"."_tempSubSeqNo
	..e  d
	...if ($d(^||TempARCOSSeqNoArr($j,ARCOSCount))) s ARCOSCount=ARCOSCount+1
	...s ItemLinkDoctor=ARCOSCount
	...s ^||TempARCOSSeqNoArr($j,ARCOSCount)=1
	.s ItemNO=$p(s,"^",20) //---------------------------------------------------------加入NO用于排序
	.i OSSerialNo'="" s ItemNO=OSSerialNo_"."_ItemNO
	.s OrderStage=$p(s,"^",22)
	.s OrderStageDesc=##CLass(web.DHCDocOrderCommon).GetOrderStageDesc(OrderStage)
	.s ItemBillUOMRowid=$p(s,"^",23) //$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
	.;i ItemBillUOMRowid="" s ItemBillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
	.i ItemBillUOMRowid="" s ItemBillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,AdmType)
	.;if ItemQty="" s ItemQty=1
	.if ItemDurRowid'="" d 
	..s ItemDur=$P($G(^PHCDU(ItemDurRowid)),"^",3)
	..s ItemDurFactor=$P($g(^PHCDU(ItemDurRowid)),"^",2)
	..s ItemDur=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",ItemDur,langid)
	.;
	.if (ItemFreqRowid'="") d
	..s Active=$P($g(^PHCFR(ItemFreqRowid)),"^",6)
	..s AvailableType=$P($g(^PHCFR(ItemFreqRowid)),"^",7)
	..if ((AvailableType'="")&&(AvailableType'[AdmType))||(Active="N") d
	...s FormFreqRowid=""
	.if ItemFreqRowid'="" d
	..s ItemFreq=$P($G(^PHCFR(ItemFreqRowid)),"^",3)
	..s ItemFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",ItemFreq,langid)
	..s ItemFreqFactor=$P($g(^PHCFR(ItemFreqRowid)),"^",2)
	..s ItemFreqInterval=$P($g(^PHCFR(ItemFreqRowid)),"^",5)
	.;
	.if (ForbidDosingInstr[("^"_ItemInstrRowid_"^")) s ItemInstrRowid=""
	.if ItemInstrRowid'="" d
	..s Active=$P($g(^PHCIN(ItemInstrRowid)),"^",4)
	..s AvailableType=$P($g(^PHCIN(ItemInstrRowid)),"^",5)
	..if ((AdmType'="")&&(AvailableType'="")&&(AvailableType'[AdmType))||(Active="N") d
	...s ItemInstrRowid=""
	.if ItemInstrRowid'="" s ItemInstr=$P($G(^PHCIN(ItemInstrRowid)),"^",2)
	.s ItemInstr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",ItemInstr,langid)
	.if ItemDoseUOMRowid'="" s ItemDoseUOM=$P($G(^CT("UOM",ItemDoseUOMRowid)),"^",2)
	.if ItemBillUOMRowid'="" s ItemBillUOM=$P($G(^CT("UOM",ItemBillUOMRowid)),"^",2)
	.s ItemDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ItemDoseUOM,langid)
	.s ItemBillUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ItemBillUOM,langid)
	.s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	.s Sensitive=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),9)),"^",18)
	.s ItemOrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.i ItemOrderType="R" d
	..s PHPrescType=..GetPHPrescType(ItemCatDR,"",ARCIMRowid)
	..i PHPrescType="3" d
	...s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	...;s ItemQty=##class(web.DHCDocOrderEntry).GetPackqty(ARCIMRowid,DrgformRowid,ItemFreqRowid,"",ItemDurRowid,ItemDoseQty,ItemDoseUOMRowid)
	.s:$e(ItemQty,1)="." ItemQty="0"_ItemQty
	.s PatType="",InsType="",PAADMRegConDisDR=""
	.s:EpisodeID'="" PatType=$P(^PAADM(EpisodeID,1),"^",6)
	.s:EpisodeID'="" InsType=$P(^PAADM(EpisodeID,1),"^",7)
	.s:EpisodeID'="" PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	.s ExpStrin=PAADMRegConDisDR_"^^^"_EpisodeID_"^"_""_"^"_""_"^"_""
	.s retPrice=..GetOrderPriceConUom(EpisodeID,InsType,"",ARCIMRowid,"",ItemBillUOMRowid,"","")
	.;s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType,InsType,ARCIMRowid,+$h , "", "", "", "","",ExpStrin)
	.s ItemPrice=$P(retPrice,"^",1)
	.s ConFac=""
	.s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	.if (INCIRowid'="") d
	..s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ARCIMRowid,INCIRowid,ItemBillUOMRowid)
	..//s ItemPrice=$fn(ItemPrice*ConFac,"",4)
	.s ARCIMPHCDFDR=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",12)
	.s BaseDoseQty=##Class(web.DHCDocOrderEntry).CalDose(ItemDoseUOMRowid,ARCIMPHCDFDR,ItemDoseQty)
	.;s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ARCIMRowid, +$H, "", "", "", "")
	.;s ItemPrice=$P(retPrice,"^",1)
	.s CNMedItemFlag=..IsCNMedItem(ARCIMRowid) //草药标志
	.s ARCOSSubCatRowid=$p($g(^ARCOS(ARCOSRowid)),"^",9)
	.s SkinTest=$p(s,"^",24)
 	.s SkinTestAction=$p(s,"^",25)
 	.;同频次不同剂量串
	.s ITMFreqTimeDoseQtyStr=$p($G(^ARCOS(+ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",10)
	.if (ITMFreqTimeDoseQtyStr'="") s ItemDoseQty=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(ITMFreqTimeDoseQtyStr)
 	.;周频次星期串
	.s OrderFreqDispTimeStr=$p($G(^ARCOS(+ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item,"DHC")),"^",11)
	.i ItemFreqRowid="" s OrderFreqDispTimeStr=""
	.if (OrderFreqDispTimeStr'="") d
	..s OrderFreqOtherInfo=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(ItemFreqRowid,OrderFreqDispTimeStr)
	..s ItemFreq=ItemFreq_"-"_OrderFreqOtherInfo
	.if (ItemDoseQty["-") d
	..s BaseDoseQty=0
	..f k=1:1:$l(ItemDoseQty,"-") d
	...s BaseDoseQty=BaseDoseQty+##Class(web.DHCDocOrderEntry).CalDose(ItemDoseUOMRowid,ARCIMPHCDFDR,$p(ItemDoseQty,"-",k))
	.e  d
	..s BaseDoseQty=##Class(web.DHCDocOrderEntry).CalDose(ItemDoseUOMRowid,ARCIMPHCDFDR,ItemDoseQty)
	.s ItemData=ItemDoseQty_$C(1)_ItemDoseUOM_$C(1)_ItemDoseUOMRowid
	.s ItemData=ItemData_"^"_ItemFreq_$C(1)_ItemFreqRowid_$C(1)_ItemFreqFactor_$C(1)_ItemFreqInterval
	.s ItemData=ItemData_"^"_ItemInstr_$C(1)_ItemInstrRowid
	.s ItemData=ItemData_"^"_ItemDur_$C(1)_ItemDurRowid_$C(1)_ItemDurFactor
	.s ItemData=ItemData_"^"_ItemQty_$C(1)_ItemBillUOM_$C(1)_ItemBillUOMRowid
	.s ItemData=ItemData_"^"_DHCDocOrderType_$C(1)_DHCDocOrderTypeID_$C(1)_""
	.s ItemData=ItemData_"^"_ARCOSRowid
	.s ItemData=ItemData_"^^"_ARCOSSubCatRowid_"^"_ItemRemark
	.;----------
	.s ItemData=ItemData_"^"_OrderPriorRemarksDR
	.s ItemData=ItemData_"^"	//抗生素
	.s ItemData=ItemData_"^"_Sensitive	//紧急标志
	.s ItemData=ItemData_"^"_ARCOSRowid_"||"_ARCOSDateRowid_"||"_item
	.s ItemData=ItemData_"^"_ItemSpecCode		///标本
	.s ItemData=ItemData_"^"_OrderStage_$C(1)_OrderStageDesc		//医嘱阶段
	.s ItemData=ItemData_"^"_SpeedFlowRate_$C(1)_FlowRateUnit_$C(1)_FlowRateUnitRowid
	.s ItemData=ItemData_"^"_OrderBodyPartLabel
	.s ItemData=ItemData_"^"_SkinTestAction_"^^"_SkinTest //皮试 皮试备注
	.s ItemData=ItemData_"^" //计费组套餐明细编号
	.s ItemData=ItemData_"^"_ITMFreqTimeDoseQtyStr_"^"_OrderFreqDispTimeStr //同频次不同剂量、周频次
	.;s ItemData=ItemData_"^"_ItemSpecCode_"^"_Sensitive_"^"_ARCOSRowid_"||"_ARCOSDateRowid_"||"_item
	.;串的数量要与##class(web.DHCDocMain).CreateCopyItem(对应起来
	.;--------
	.s ItemData=$tr(ItemData,$C(1),"~")
	.s ItemData=$tr(ItemData,$C(2),"@") //周频次串$C(2) json不支持
	.//s ItemData=##class(web.DHCDocUtil).EvalJSON(ItemData)
	.s ItemStatus=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	.i ItemStatus=1 s ItemStatus="停用"
	.e  s ItemStatus=""
	.s ItemStatus=..%Translate("doc.arcositemlist.hui.csp",ItemStatus)
	.s ReclocDescStr=##class(web.DHCDocOrderCommon).GetReclocDescStr(EpisodeID, ARCIMRowid, "/", "")
	.;do OutputRow1
	.s id=ARCOSRowid_"||"_ARCOSDateRowid_"||"_item
	.do SetTempGlobe
	;Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetAllOrderSetItem(ARCOSRowid,HospitalId,EpisodeID,OSSerialNo,ARCOSCount,langid)
	n (ARCOSRowid,HospitalId,EpisodeID,OSSerialNo,ARCOSCount,langid,%session)
	s ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	
	s ForbidDosingInstr=""
	s AdmType=""
	if (EpisodeID'=""){
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
		if (AdmLoc'=""){
			s ForbidDosing=$P($G(^CTLOC(AdmLoc,"DHC")),"^",18)
			i (ForbidDosing="1"){
				if (AdmType="I"){
					s ForbidDosingInstr=..%GetConfig("IPDosingInstr")
				}elseif (PAAdmType="O"){
					s ForbidDosingInstr=..%GetConfig("OPInfusionInstr")
				}
				i ForbidDosingInstr'="" s ForbidDosingInstr="^"_ForbidDosingInstr_"^"
			}
		}
	}
	s ARCOSCount=ARCOSCount+1
	d GetOrderSetItem(ARCOSRowid,ARCOSDateRowid,EpisodeID,OSSerialNo,ARCOSCount,langid)
	;下面是调出医嘱套里的医嘱套,属于嵌套调用
	s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.s ARCOSDr=$P(s,"^",1)
	.q:ARCOSDr=""
	.s datefrom=$p($g(^ARCOS(+ARCOSDr)),"^",15)
	.s dateto=$p($g(^ARCOS(+ARCOSDr)),"^",16)
	.;开始日期和结束日期当天应该都算有效数据
	.s ValidItemFlag=(datefrom<=+$H)&&(datefrom'="")&&((dateto="")||(dateto>=+$H))
	.i 'ValidItemFlag d  q
	..s (ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ItemOrderType,ItemPrice,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode,OrderPriorRemarksDR,OrderPriorRemarks,Sensitive,ConFac,ItemFreqFactor,BaseDoseQty,OrderMustEnter,CNMedItemFlag,ReclocDescStr,id,NotifyClinician,ItemCatDR,LongPriorFlag)=""
	..s Item=$p($g(^ARCOS(+ARCOSDr)),"^",2)
	..s ARCIMRowid=ARCOSDr
	..s ItemStatus=..%Translate("doc.arcositemlist.hui.csp","停用")
	..d SetTempGlobe
	.s OSSerialNo=$p(s,"^",3)
	.d GetAllOrderSetItem(+s,HospitalId,EpisodeID,OSSerialNo,ARCOSCount,langid)
	Q 0
SetTempGlobe
	set Data=$lb(Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemPrice,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode,OrderPriorRemarksDR,OrderPriorRemarks,Sensitive,ConFac,ItemFreqFactor,BaseDoseQty,OrderMustEnter,CNMedItemFlag,ReclocDescStr,id,NotifyClinician,ItemCatDR,LongPriorFlag)
	;modify by guorongyong 2015.7.6 标准版
	;按维护顺序排序,SortNo 排序队列
	i ItemNO="" s SortNo=0
	e  s SortNo=ItemNO
	i ItemLinkDoctor'="" {
		;成组医嘱,则都为主医嘱队列节点
		i (ItemLinkDoctor[".")&&(SortNo'[".") {
			s SortNo=$$GetMasterSortNo(ARCOSRowid_"||"_ARCOSDateRowid,ItemLinkDoctor,SortNo)
		}
	}else{
		s ItemLinkDoctor=0
	}
	s ^||TempSortQueue($j,SortNo,ItemLinkDoctor,ARCOSRowid_"||"_ARCOSDateRowid_"||"_item)=Data
	
	quit
GetMasterSortNo(ARCOSSubId,ItemLinkDoctor,SortNo)
	n (ARCOSSubId,ItemLinkDoctor,%session)
	i $p(ItemLinkDoctor,".",1)="" Q SortNo
	s ARCOSRowid=$p(ARCOSSubId,"||",1)
	s ARCOSDateRowid=$p(ARCOSSubId,"||",2)
	s LoopId=0
	s LoopId=0 for{
		s LoopId=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",LoopId)) q:LoopId=""
		s ARCOSData=$g(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",LoopId))
		s LoopItemLinkDoctor=$p(ARCOSData,"^",14)
		s SortNo=0
		i LoopItemLinkDoctor=$p(ItemLinkDoctor,".",1) {
			s SortNo=$p(ARCOSData,"^",20)
			i SortNo="" s SortNo=0
			quit
		}
	}
	
	quit SortNo
Output
	kill ^||TempLastMasterSeqNoArr($j)
	s SortNo="",LastMasterSeqNo=""
	for {
		s SortNo=$O(^||TempSortQueue($j,SortNo)) Q:SortNo=""
		s ItemLinkDoctor=""
		for {
			s ItemLinkDoctor=$O(^||TempSortQueue($j,SortNo,ItemLinkDoctor)) Q:ItemLinkDoctor=""
			s m=0
			s ItemRowId=0
			for {
				s ItemRowId=$O(^||TempSortQueue($j,SortNo,ItemLinkDoctor,ItemRowId)) Q:ItemRowId=""
				s m=m+1
				s Data=$G(^||TempSortQueue($j,SortNo,ItemLinkDoctor,ItemRowId))
				i (ItemLinkDoctor=0)||(SortNo=0) {
					s SeqNo=""
				}else{
					/*i m=1 {
						s SeqNo=ItemLinkDoctor
						//if (SortNo[".") {
							s SubSeqNo=$p(SeqNo,".",2)
							if $d(^||TempLastMasterSeqNoArr($j,$p(SeqNo,".",1))) {
								s MaxMasterSeqNo=$o(^||TempLastMasterSeqNoArr($j,""),-1)
								if (SubSeqNo="") {
									s SeqNo=MaxMasterSeqNo+1
								}else{
									s SeqNo=MaxMasterSeqNo_"."_SubSeqNo
								}
							}
						//}
					}else {
						s SeqNo=ItemLinkDoctor_"."_(m-1)
					}
					s ^||TempLastMasterSeqNoArr($j,$p(SeqNo,".",1))=1*/
					s SeqNo=ItemLinkDoctor
				}
				s NewLength=$LISTLENGTH(Data)+1
				s $LIST(Data,NewLength)=SeqNo
				s ^CacheTemp(repid,ind)=Data
				s ind=ind+1
			}
		}
		
	}
	kill ^||TempLastMasterSeqNoArr($j)
	Quit

OutputRow1
	set Data=$lb(Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemPrice,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode,OrderPriorRemarksDR,OrderPriorRemarks,Sensitive,OrderMustEnter,CNMedItemFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables1
	set (Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ARCIMRowid,ItemOrderType,ItemData,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,ItemSpecCode,OrderPriorRemarksDR,OrderPriorRemarks,Sensitive,OrderMustEnter,CNMedItemFlag)=""
	Quit
}

ClassMethod FindOSItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOSItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQwMethod(QWStr As %String) As %String
{
 Set RetStr=""
 Set PHCFRRowid=""
 Set PHCFRRowid=$O(^PHCFR(0,"Code",QWStr,-1))
 if PHCFRRowid'="" Do
 .Set PHCFRCode=$P($G(^PHCFR(PHCFRRowid)),"^",1)
 .Set PHCFRDesc=$P($G(^PHCFR(PHCFRRowid)),"^",3)
 .Set PHCFRFactor=$P($G(^PHCFR(PHCFRRowid)),"^",2)
 .Set PHCFRDays=$P($G(^PHCFR(PHCFRRowid)),"^",5)
 .Set RetStr=PHCFRCode_"^"_PHCFRDesc_"^"_PHCFRFactor_"^"_PHCFRDays_"^"_PHCFRRowid_"^^"
 Else  Do
 .Set PHCFRCode=QWStr
 .Set PHCFRDesc=QWStr
 .Set PHCFRFactor=$P($P(QWStr,"q",2),"w",1)
 .Q:(PHCFRFactor="")||(PHCFRCode="")
 .Set DayStr=$P($P(QWStr,"q",1),"W",2)
 .Q:DayStr=""
 .Lock +^PHCFR:2
 .&Sql(Insert into SQLUSER.PHC_Freq Set PHCFR_Code=:PHCFRCode,PHCFR_Desc1=:PHCFRDesc,PHCFR_Desc2=:PHCFRDesc,PHCFR_Factor=:PHCFRFactor,PHCFR_Days=7)
 .If (SQLCODE = 0) Do
 ..For i=1:1:$L(DayStr) Do
 ...;W $E(DayStr,i),! %ROWID
 ...If '$D(^PHCFR(%ROWID,"OPDT",0)) Set ^PHCFR(%ROWID,"OPDT",0)=0
 ...Set PHCFRTimeNum=^PHCFR(%ROWID,"OPDT",0)
 ...Set PHCFRTimeNum=PHCFRTimeNum+1
 ...Set ^PHCFR(%ROWID,"OPDT",PHCFRTimeNum)="28800"_"^"_$E(DayStr,i)
 ...Set ^PHCFR(%ROWID,"OPDT",0)=PHCFRTimeNum
 .Lock -^PHCFR
 .Set RetStr=PHCFRCode_"^"_PHCFRDesc_"^"_PHCFRFactor_"^"_"7"_"^"_%ROWID_"^^"
 Q RetStr
}

ClassMethod FindSameOrderItemCat(PAADMRowid As %String, ItemCatRowid As %String, CurLogonHosp As %String = "") As %Boolean
{
	n (PAADMRowid,ItemCatRowid,CurLogonHosp,%session)
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(PAADMRowid)
	s today=..%SysDate()
	s findorderitem=0
	q:OrderRowid="" findorderitem
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAADMRowid)
	;判断是否需要检查重复的子类
	s OPUnRepeatItemCat=..%GetConfig("OPUnRepeatItemCat",CurLogonHosp)
	Q:OPUnRepeatItemCat="" findorderitem
	s OPUnRepeatItemCat="^"_OPUnRepeatItemCat_"^"
	Q:(OPUnRepeatItemCat'[("^"_ItemCatRowid_"^")) findorderitem
	
	;循环取出医嘱
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")!(findorderitem=1)!(findorderitem=2)  d
	.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.i itemstat'="" d
	..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.Q:(statcode'="V")
	.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.s sttdate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.s ItemCatDR=$p(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
	.Q:(PAAdmType'="O")
	.Q:(ItemCatDR'=ItemCatRowid)
	.s findorderitem=1
	Q findorderitem
}

ClassMethod GetARCIMAlertStockQty(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	Q:DHCARCIMRowid="" ""
	s AlertStockQty=$p(^DHCItmMast(DHCARCIMRowid),"^",7)
	q $g(AlertStockQty)
}

ClassMethod GetAlertAuditSpecialItem(ARCIMRowid As %String, InsType As %String) As %String
{
	n (ARCIMRowid,InsType)
	s ^gry("GetAlertAuditSpecialItem")=ARCIMRowid
	s findRet=0
	if ..GetInsurFlag(InsType)'=1 Quit findRet
	
	s PHPoisonID=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
	s PHPoisonCode=""
	if PHPoisonID'="" s PHPoisonCode=$p(^PHCPO(PHPoisonID),"^",1)
	if PHPoisonCode="SHYP" s findRet=1
	
	s ItemCatDR=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",10)
	if ItemCatDR'="" {
		S OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	    S ORCATDr=$P(^ARC("IC",ItemCatDR),"^",8)
	    S OrderCatCode=$P(^OEC("ORCAT",ORCATDr),"^",1)
	    if (OrderCatCode="04")||(OrderCatCode="05") s findRet=2
	}
	
	Q findRet
}

ClassMethod GetARCIMDetail(ArcimRowid As %String) As %String
{
	n ret
	Set langid=..%LanguageID()
	s BillGrpDesc="",FormDesc="",ItemType=""
	s FormFreqDesc="",FormInstrDesc="",FormDurDesc=""
	s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
	s FormFreqDesc="",FormFreqRowid="",FormFreqInterval="",FormFreqFactor="1"
	s FormDurDesc="",FormDurRowid="",FormDurFactor="1"
	s FormInstrDesc="",FormInstrRowid=""
	s FormRowid="",FormDesc=""
	s PackQty="1",OrderDoseStr="",OrderMsg="",ConFac=1

	
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s BillsubRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",9)
	i BillsubRowid'="" s BillGrpDesc=$p(^ARCBG(+BillsubRowid),"^",2)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	//s BillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s BillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,"")
	s BillUOMDesc=..GetUOMDesc(BillUOMRowid)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	s OrderMsg=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"OEM",1))
	i INCIRowid'="" d
	.; INCI_CTUOM_DR  库存基本单位
	.s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	.s BaseUOMDesc=..GetUOMDesc(BaseUOMRowid)

	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	i DrgformRowid'="" {
	  s PHCDRowid=$P(DrgformRowid,"||",1)
	  s ChildSub=$P(DrgformRowid,"||",2)
	  ;剂型
	  s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
	  i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	  s FormDesc=##class(User.PHCForm).GetTranByDesc("PHCFDesc",FormDesc,langid)
	  ;频率
	  s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	  s FreqValidFlag=##class(web.DHCDocOrderCommon).CheckDataValid("PHCFreq","",FormFreqRowid,%session.Get("LOGON.CTLOCID"))
	  if (FreqValidFlag="0") s FormFreqRowid=""
	  i FormFreqRowid'="" {
		  s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		  s FormFreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FormFreqDesc,langid)
		  s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		  s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
	  }
	  ;用法
	  s FormInstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5)
	  s InstrucValidFlag=##class(web.DHCDocOrderCommon).CheckDataValid("PHCInstruc","",FormInstrRowid,%session.Get("LOGON.CTLOCID"))
	  if (InstrucValidFlag="0") s FormInstrRowid=""
	  i FormInstrRowid'="" s FormInstrDesc=$P($g(^PHCIN(FormInstrRowid)),"^",2)
	  s FormInstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",FormInstrDesc,langid)
	  ;疗程
	  s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  i FormDurRowid'="" {
		  s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		  s FormDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",FormDurDesc,langid)
		  s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
	  }
	  ;剂量
	  s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  s FormDoseUOMDesc=..GetUOMDesc(FormDoseUOMRowid)
	  s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
	  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  i leq'="" d
	  .s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	  .s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	  .if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
	  .e  s FormDoseQty=eqqty
	  .s FormDoseUOMDesc=..GetUOMDesc(FormDoseUOMRowid)
	  .s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(2)_OrderDoseStr
	}

	if (INCIRowid'="") s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimRowid,INCIRowid,BillUOMRowid)
	;是否可以使用紧急标志
	s Sensitive=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",18)
	;是否默认加急
	s ARCIMDefSensitive= $p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",41) 
	;得到医嘱分类
	s ArcimClassification=..GetArcimClassification(ArcimRowid)
	;同频次不同剂量医嘱
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ArcimRowid,""))
	if (DARCIMRowid'=""){
		s AllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",13)
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	s PHPrescType=..GetPHPrescType(ItemCatRowid,"",ArcimRowid)
	s ret=ArcimDesc_"^"_OrderType_"^"_ItemCatRowid_"^"_DrgformRowid_"^"_INCIRowid
	s ret=ret_"^"_PackQty_$C(1)_BillUOMDesc_$C(1)_BillUOMRowid
	s ret=ret_"^"_FormDesc_$C(1)_DrgformRowid_$C(1)_ConFac
	s ret=ret_"^"_OrderDoseStr
	s ret=ret_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
	s ret=ret_"^"_FormInstrDesc_$C(1)_FormInstrRowid
	s ret=ret_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
	s ret=ret_"^"_OrderMsg
	s ret=ret_"^"_ArcimClassification
	s ret=ret_"^"_Sensitive
	s ret=ret_"^"_ARCIMDefSensitive_"^"_SameFreqDifferentDosesFlag_"^"_PHPrescType
	Q ret
}

/// creator:郭荣勇
/// date:2015.1.08
/// desc:得到医嘱分类,RW 西药/成药 RC 中草药,L 检验,E 检查,O 其他,""
ClassMethod GetArcimClassification(ArcimRowid As %String, CurLogonHosp As %String = "") As %String
{
	n (ArcimRowid,CurLogonHosp,%session)
	s ret=""
	Q:+ArcimRowid="0" ret
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s CNMedItemFlag=..IsCNMedItem(ArcimRowid,CurLogonHosp)
	s ServiceFlag=..GetItemServiceFlag(ArcimRowid)
	
	i OrderType="R" {
		i CNMedItemFlag="1" {s ret="RC"}else{s ret="RW"}
	}elseif (OrderType="L") {
		s ret="L"
	}else{
		i ServiceFlag="1" {s ret="E"}else{s ret="O"}
	}
	Q ret
}

ClassMethod GetARCIMEQRes(ArcimRowId As %String, RecLocRowId As %String) As %String
{
	;w ##class(web.DHCDocOrderCommon).GetARCIMEQRes("10||1",46)
	s ResRowId=""
	q:$g(ArcimRowId)=""
	q:'$d(^RBC("SER",0,"ARCIM",ArcimRowId)) ""
	s SERRowId=0  f  s SERRowId=$O(^RBC("SER",0,"ARCIM",ArcimRowId,SERRowId)) Q:SERRowId=""  d
	.s EQRowId=$P(^RBC("SER",SERRowId),"^",5)
	.Q:EQRowId=""
	.s ResRowId=$O(^RB("RES",0,"EQ",EQRowId,RecLocRowId,0))
	;w "ResRowId:"_ResRowId
	Q ResRowId
}

ClassMethod GetARCIMIPNeedBillQty(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	Q:DHCARCIMRowid="" ""
	s NeedBillkQty=$p(^DHCItmMast(DHCARCIMRowid),"^",8)
	q $g(NeedBillkQty)
}

/// Creator?      郭荣勇
/// CreatDate?    2009.09.12
/// Description:? 得到一个就诊已经审核的医嘱数量,成组医嘱算一个,深圳中医院控制一个就诊只能下5个医嘱
/// Table?        OE_OrdItem
/// Input?        EpisodeID:就诊ID
/// Output:         
/// Return?       ItemSum :就诊医嘱数
/// Others?  
ClassMethod GetAdmOrdItemSum(EpisodeID As %String = "") As %String
{
	s ItemSum=0,GroupSum=0
	s OEORDRowId=""
	s OEORDRowId=$O(^OEORD(0,"Adm",EpisodeID,OEORDRowId),-1)
	if OEORDRowId="" quit ItemSum
	s OEORIRowId=0
	for  s OEORIRowId=$O(^OEORD(OEORDRowId,"I",OEORIRowId)) Q:OEORIRowId=""  d
	.s OrdStr1=$g(^OEORD(OEORDRowId,"I",OEORIRowId,1))
	.s OrdStr2=$g(^OEORD(OEORDRowId,"I",OEORIRowId,2))
	.s OrdStr3=$g(^OEORD(OEORDRowId,"I",OEORIRowId,3))
	.s OrdStr11=$g(^OEORD(OEORDRowId,"I",OEORIRowId,11))
	.s ArcimRowId=$P(OrdStr1,"^",2)
	.s OrderType=""
 .s SubCatRowId=$p(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1),"^",10)
 .if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
 .Q:OrderType'="R"    ;药品
 .s OEORIDr=$P(OrdStr11,"^",39)
 .if OEORIDr'="" d
 ..if $d(^OEORDi(0,"OEORI",OEORDRowId,OEORIDr,OEORIRowId)) d
 ...s GroupSum=GroupSum+1                                      
 .Q:OEORIDr'=""      ;非子医嘱
 .s ItemSum=ItemSum+1

 Q ItemSum_"^"_GroupSum
}

/// w ##class(web.DHCDocOrderCommon).GetAllergy(90,"681||1")
ClassMethod GetAllergy(PatientID As %String, ArcimRowid As %String, CheckConflictFlag As %String = "Y")
{
	s ^TMP("GetAllergy")=PatientID_","_ArcimRowid
	
	s ret=""
	s Prior="" //优先级 01 医嘱项 02 药学项 03通用名
	s status="" //限制状态 Y 限制录入 其他 提示录入
	
	s PHCDGenericDR="",Prior="",status=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	i DrgFormRowid'="" s PHCDGenericDR=$p($G(^PHCD(+DrgFormRowid,4)),"^",1)

 s ArcimDrugMastDRStr="",ArcimGenericDRStr="",ArcimAllergyDRStr=""
 i DrgFormRowid'=""  d
 .i ArcimDrugMastDRStr="" s ArcimDrugMastDRStr=+DrgFormRowid
 .e  i ("^"_ArcimDrugMastDRStr_"^")'[("^"_+DrgFormRowid_"^")  s ArcimDrugMastDRStr=ArcimDrugMastDRStr_"^"_+DrgFormRowid
 i PHCDGenericDR'=""  d
 .i ArcimGenericDRStr="" s ArcimGenericDRStr=PHCDGenericDR
 .e  i ("^"_ArcimGenericDRStr_"^")'[("^"_PHCDGenericDR_"^")  s ArcimGenericDRStr=ArcimGenericDRStr_"^"_PHCDGenericDR
 s ARCIMConflict=0
 /*
 //当前开立医嘱项所有的关联过敏源
 s SKTARCIMDR=0
 f  s SKTARCIMDR=$o(^ARCSKTi("SKINTEST",ArcimRowid,SKTARCIMDR)) Q:SKTARCIMDR=""  d
 .
 */
 ;医嘱项上定义的会产生作用的过敏原  ARC_ItemAllergy,有自定义,通用名,药学项三种类型
 s chl=0  f  s chl=$O(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),"ALG",chl)) q:chl=""  d
 .s s=$g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),"ALG",chl))
 .s ArcimDrugMastDR=$P(s,"^",1)
 .s ArcimGenericDR=$P(s,"^",2)
 .s ArcimAllergyDR=$P(s,"^",3)
 .i ArcimDrugMastDR'="" d
 ..i ArcimDrugMastDRStr="" s ArcimDrugMastDRStr=ArcimDrugMastDR
 ..e  s ArcimDrugMastDRStr=ArcimDrugMastDRStr_"^"_ArcimDrugMastDR
 .;
 .i ArcimGenericDR'="" d
 ..i ArcimGenericDRStr="" s ArcimGenericDRStr=ArcimGenericDR
 ..e  s ArcimGenericDRStr=ArcimGenericDRStr_"^"_ArcimGenericDR
 .;
 .i ArcimAllergyDR'="" d
 ..i ArcimAllergyDRStr="" s ArcimAllergyDRStr=ArcimAllergyDR
 ..e  s ArcimAllergyDRStr=ArcimAllergyDRStr_"^"_ArcimAllergyDR
 ;b ;病人过敏记录  PA_Allergy
 s PatALGDrugMastDRStr="",PatALGGenericDRStr="",PatALGAllergyDRStr=""
 s chl=0  f  s chl=$O(^PAPER(PatientID,"ALG",chl)) q:chl=""  d
 .s s=$G(^PAPER(PatientID,"ALG",chl))
 .;过敏记录开关
 .s CheckConflict=$P($g(^PAPER(+PatientID,"ALG",chl,"DHC")),"^",3)
 .//q:(CheckConflictFlag="Y")&&(CheckConflict'="Y")
 .s ALGStatus=$P(s,"^",8)  
 .Q:ALGStatus="I"
 .s ALGDate=$P(s,"^",10)  
 .s ALGTypeDR=$P(s,"^",9)            ;自定义       PAC_Allergy
 .s ALGPHCGEDR=$P(s,"^",4)           ;通用名       PHC_Generic
 .s ALGPHCDMDR=$P(s,"^",27)          ;药学项       PHC_DrgMast
 .s ALGSkinText=$P(s,"^",35) 
 .i ALGTypeDR'="" d
 ..i PatALGAllergyDRStr="" s PatALGAllergyDRStr=ALGTypeDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ..e  i ("^"_PatALGAllergyDRStr_"^")'[("^"_ALGTypeDR_"^")  s PatALGAllergyDRStr=PatALGAllergyDRStr_"^"_ALGTypeDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 .i ALGPHCGEDR'="" d
 ..i PatALGGenericDRStr="" s PatALGGenericDRStr=ALGPHCGEDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ..e  i ("^"_PatALGGenericDRStr_"^")'[("^"_ALGPHCGEDR_"^")  s PatALGGenericDRStr=PatALGGenericDRStr_"^"_ALGPHCGEDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 .i ALGPHCDMDR'="" d
 ..i PatALGDrugMastDRStr="" s PatALGDrugMastDRStr=ALGPHCDMDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ..e  i ("^"_PatALGDrugMastDRStr_"^")'[("^"_ALGPHCDMDR_"^")  s PatALGDrugMastDRStr=PatALGDrugMastDRStr_"^"_ALGPHCDMDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 .//医嘱项关联过敏源
 .s ALGExternalID=$P(s,"^",30)       ;医嘱项       ARC_ItmMast
 .i ALGExternalID["||"  d
 ..s ALGArcimRowid=ALGExternalID
 ..// 同医嘱项
 ..i ALGArcimRowid=ArcimRowid d
 ...s ARCIMConflict=1
 ...i PatALGAllergyDRStr="" s PatALGAllergyDRStr=ALGArcimRowid_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ...e  i ("^"_PatALGAllergyDRStr_"^")'[("^"_ALGArcimRowid_"^") s PatALGAllergyDRStr=PatALGAllergyDRStr_"^"_ALGArcimRowid_"^"_ALGPHCDMDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ..//同药学项
 ..s ALGDrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ALGArcimRowid)
 ..i (ALGDrgFormRowid'="")&&(("^"_ArcimDrugMastDRStr_"^")'[("^"_ALGDrgFormRowid_"^")) d
 ...i PatALGDrugMastDRStr="" s PatALGDrugMastDRStr=ALGPHCDMDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ...e  i ("^"_PatALGDrugMastDRStr_"^")'[("^"_ALGDrgFormRowid_"^") s PatALGDrugMastDRStr=PatALGDrugMastDRStr_"^"_ALGPHCDMDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ..//同通用名
 ..s ALGPHCDGenericDR=""
 ..i ALGDrgFormRowid'="" s ALGPHCDGenericDR=$p($G(^PHCD(+ALGDrgFormRowid,4)),"^",1)
 ..i ALGPHCDGenericDR'="" d
 ...i PatALGGenericDRStr="" s PatALGGenericDRStr=ALGPHCDGenericDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 ...e  i ("^"_PatALGGenericDRStr_"^")'[("^"_ALGPHCDGenericDR_"^")  s PatALGGenericDRStr=PatALGGenericDRStr_"^"_ALGPHCDGenericDR_"&"_ALGSkinText_"&"_CheckConflict_"&"_ALGDate
 
 ..s child=0  f  s child=$O(^ARCIM(+ALGArcimRowid,$P(ALGArcimRowid,"||",2),"ALG",child)) q:child=""  d
 ...s s=$g(^ARCIM(+ALGArcimRowid,$P(ALGArcimRowid,"||",2),"ALG",child))
 ...s ALGArcimDrugMastDR=$P(s,"^",1)
 ...s ALGArcimGenericDR=$P(s,"^",2)
 ...s ALGArcimAllergyDR=$P(s,"^",3)
 ...i ALGArcimAllergyDR'="" d
 ....i PatALGAllergyDRStr="" s PatALGAllergyDRStr=ALGArcimAllergyDR_"&"_ALGSkinText
 ....e  i ("^"_PatALGAllergyDRStr_"^")'[("^"_ALGArcimAllergyDR_"^")  s PatALGAllergyDRStr=PatALGAllergyDRStr_"^"_ALGArcimAllergyDR_"&"_ALGSkinText
 ...i ALGArcimGenericDR'="" d
 ....i PatALGGenericDRStr="" s PatALGGenericDRStr=ALGArcimGenericDR_"&"_ALGSkinText
 ....e  i ("^"_PatALGGenericDRStr_"^")'[("^"_ALGArcimGenericDR_"^")  s PatALGGenericDRStr=PatALGGenericDRStr_"^"_ALGArcimGenericDR_"&"_ALGSkinText
 ...i ALGArcimDrugMastDR'="" d
 ....i PatALGDrugMastDRStr="" s PatALGDrugMastDRStr=ALGArcimDrugMastDR_"&"_ALGSkinText
 ....e  i ("^"_PatALGDrugMastDRStr_"^")'[("^"_ALGArcimDrugMastDR_"^")  s PatALGDrugMastDRStr=PatALGDrugMastDRStr_"^"_ALGArcimDrugMastDR_"&"_ALGSkinText
 
 ..s ALGArcimPHCDGenericDR=""
 ..s ALGArcimDrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ALGArcimRowid)
 ..i ALGArcimDrgFormRowid'="" s ALGArcimPHCDGenericDR=$p($G(^PHCD(+ALGArcimDrgFormRowid,4)),"^",1)
 ..i ALGArcimPHCDGenericDR'="" d
 ...i PatALGGenericDRStr="" s PatALGGenericDRStr=ALGArcimPHCDGenericDR_"&"_ALGSkinText
 ...e  i ("^"_PatALGGenericDRStr_"^")'[("^"_ALGArcimPHCDGenericDR_"^")  s PatALGGenericDRStr=PatALGGenericDRStr_"^"_ALGArcimPHCDGenericDR_"&"_ALGSkinText
 ..i ALGArcimDrgFormRowid'="" d
 ...i PatALGDrugMastDRStr="" s PatALGDrugMastDRStr=+ALGArcimDrgFormRowid_"&"_ALGSkinText
 ...e  i ("^"_PatALGDrugMastDRStr_"^")'[("^"_+ALGArcimDrgFormRowid_"^")  s PatALGDrugMastDRStr=PatALGDrugMastDRStr_"^"_+ALGArcimDrgFormRowid_"&"_ALGSkinText	
 
 ;判断过敏记录需根据如下优先级以此判断并实现：
 ;同医嘱项的存在过敏记录-》同药学项的存在过敏记录-》同通用名的存在过敏记录
 ;-》当前开立医嘱项所有的关联过敏源只要其中之一存在过敏记录的-》
 ;医生站设置开启了【过敏记录药学子类需提示】则需判断同药学子类医嘱是否有过敏记录
 ;------------------------------------
 kill ^TempAllergyStr($j)
 //451
 //医嘱项过敏检测
 if (ARCIMConflict="1")&&(PatALGAllergyDRStr'="") {
	 for countA=1:1:$l(PatALGAllergyDRStr,"^"){
		 s PatALGAllergyDRInfo=$p(PatALGAllergyDRStr,"^",countA)
		 continue:PatALGAllergyDRInfo=""
		 s ALGDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(PatALGAllergyDRInfo,"&",4))
		 continue:ALGDate=""
		 s ret=ALGDate
		 s status=$p(PatALGAllergyDRInfo,"&",3)
		 s Prior="01" 
     }
     if (ret'=""){
	 	Q Prior_$C(1)_ret_$C(1)_status
	 }
 }
 for count=1:1:$l(ArcimAllergyDRStr,"^")  d 
 .s ArcimAllergyDR=$p(ArcimAllergyDRStr,"^",count)
 .q:ArcimAllergyDR=""
 .for countA=1:1:$l(PatALGAllergyDRStr,"^")  d 
 ..s PatALGAllergyDRInfo=$p(PatALGAllergyDRStr,"^",countA)
 ..q:PatALGAllergyDRInfo=""
 ..s ALGStatus=$p(PatALGAllergyDRInfo,"&",3)
 ..i $p(PatALGAllergyDRInfo,"&",1)=ArcimAllergyDR d
 ...s ALGDesc=$P($g(^PAC("ALG",ArcimAllergyDR)),"^",2)
 ...Q:$d(^TempAllergyStr($j,ALGDesc))
 ...s ^TempAllergyStr($j,ALGDesc)=1
 ...s ALGDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(PatALGAllergyDRInfo,"&",4))
 ...i ALGDate'="" s ALGDesc=ALGDesc_" 过敏日期:"_ALGDate
 ...i ret="" s ret=ALGDesc
 ...e  s ret=ret_","_ALGDesc
 ...s status=$p(PatALGAllergyDRInfo,"&",3)
 ...s Prior="01"
 if (ret'=""){
 	Q Prior_$C(1)_ret_$C(1)_status
 }
 //药学项过敏检测
 for count=1:1:$l(ArcimDrugMastDRStr,"^")  d 
 .s ArcimDrugMastDR=$p(ArcimDrugMastDRStr,"^",count)
 .q:ArcimDrugMastDR=""
 .for countA=1:1:$l(PatALGDrugMastDRStr,"^")  d 
 ..s PatALGDrugMastDRInfo=$p(PatALGDrugMastDRStr,"^",countA)
 ..q:PatALGDrugMastDRInfo=""
 ..i $p(PatALGDrugMastDRInfo,"&",1)=ArcimDrugMastDR d
 ...s ALGPHCDMDesc=$P(^PHCD(ArcimDrugMastDR,1),"^",2) 
 ...Q:$d(^TempAllergyStr($j,ALGPHCDMDesc))
 ...s ^TempAllergyStr($j,ALGPHCDMDesc)=1
 ...s ALGDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(PatALGDrugMastDRInfo,"&",4))
 ...i ALGDate'="" s ALGPHCDMDesc=ALGPHCDMDesc_" 过敏日期:"_ALGDate
 ...i ret="" s ret=ALGPHCDMDesc
 ...e  s ret=ret_","_ALGPHCDMDesc
 ...//i $p(PatALGDrugMastDRInfo,"&",2)="Y"  s Prior="03"
 ...s status=$p(PatALGDrugMastDRInfo,"&",3)
 ...s Prior="02"
 if (ret'=""){
 	Q Prior_$C(1)_ret_$C(1)_status
 }
 //通用名过敏检测
 for count=1:1:$l(ArcimGenericDRStr,"^")  d 
 .s ArcimGenericDR=$p(ArcimGenericDRStr,"^",count)
 .q:ArcimGenericDR=""
 .for countA=1:1:$l(PatALGGenericDRStr,"^")  d 
 ..s PatALGGenericDRInfo=$p(PatALGGenericDRStr,"^",countA)
 ..q:PatALGGenericDRInfo=""
 ..i $p(PatALGGenericDRInfo,"&",1)=ArcimGenericDR d
 ...s ALGPHCGEDesc=$P(^PHCGE("GE",ArcimGenericDR),"^",2) 
 ...Q:$d(^TempAllergyStr($j,ALGPHCGEDesc))
 ...s ^TempAllergyStr($j,ALGPHCGEDesc)=1
 ...s ALGStatus=$p(PatALGGenericDRInfo,"&",3)
 ...s ALGDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(PatALGGenericDRInfo,"&",4))
 ...i ALGDate'="" s ALGPHCGEDesc=ALGPHCGEDesc_" 过敏日期:"_ALGDate
 ...i ret="" s ret=ALGPHCGEDesc
 ...e  s ret=ret_","_ALGPHCGEDesc
 ...//i $p(PatALGGenericDRInfo,"&",2)="Y"  s Prior="03" 
 ...s status=$p(PatALGGenericDRInfo,"&",3)
 ...s Prior="03"
 kill ^TempAllergyStr($j)
 Q:ret="" ""
 i Prior="" s Prior="03"
 Q Prior_$C(1)_ret_$C(1)_status
}

ClassMethod GetAuditInfo(OrderItemRowid As %String) As %String
{
 q:OrderItemRowid="" ""
	s DHCORrowid="",SaveInfo=""
 f  s DHCORrowid=$o(^DHCORDItem(0,OrderItemRowid,DHCORrowid))  q:DHCORrowid=""  d
 .s SaveInfo=$g(^DHCORDItem(DHCORrowid,"EQ",5))
 q SaveInfo
}

ClassMethod GetBillTypeDiagnosCat(AdmType As %String, InsurType As %String, HospId As %String = "")
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s ret=""
	s DiagnosCatRowid=0 f  s DiagnosCatRowid=$O(^DHCDiagnosCat(DiagnosCatRowid)) Q:DiagnosCatRowid=""  d
	.s DCBillType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",3)
	.s DCAdmType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",2)
	.s DCType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",5)
	.s DCHospDr=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",7)
	.Q:(DCHospDr'=HospId)
	.Q:(DCType'="S")!(DCAdmType'=AdmType)!(DCBillType'=InsurType)
	.i ret="" s ret=DiagnosCatRowid
	.e  s ret=ret_"^"_DiagnosCatRowid
	Q ret
}

ClassMethod GetCMKLRecLoc(EpLoc As %String) As %String
{
	//s ^tan("GetCMRecLoc")=EpLoc
	s ret=""
	s CNMedKLItemCatStr=..%GetConfig("CNMedKLItemCat")
	Q:CNMedKLItemCatStr="" ""
	s len=$l(CNMedKLItemCatStr,"^")
	for i=1:1:len  {
		s ItemCat=$P(CNMedKLItemCatStr,"^",i)
		s ret1=..GetLocRecLocByItemCat(EpLoc,ItemCat)
		i ret="" {s ret=ret1} 
		else {
			s RecLocCount=$LENGTH(ret1,$C(2))
			For j=1:1:RecLocCount {
			 	S RecLocStr=$P(ret1,$C(2),j)
			 	s MatchRecLoc=$P(RecLocStr,$C(1),1,2)
			 	if ret'[(MatchRecLoc) {
				   s ret=ret_$C(2)_RecLocStr
			 	}
			}
		} 
	}
	Q ret
}

ClassMethod GetCMRecLoc(EpisodeID As %String, ItemCatStr As %String, LogonHospID As %String, CMOrderOpenForAllHosp As %String = "", OrderDateStr As %String = "") As %String
{
	s ret=""
	s admType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s admLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	if (admType="I")||(PatCurStat="1") do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	.s LinkLoc=..GetLocLinkLocation(EpLoc)
	.if ($l(LinkLoc,"^")>1)||(PatCurStat=1) do
	..;s ExistFlag=..CheckIsExistWardEpLoc(EpLoc,Arcim,OpenForAllHosp)
	..s ExistFlag=..CheckIsExistWardEpLocByItemCat(EpLoc,ItemCatStr,CMOrderOpenForAllHosp)
	..if ExistFlag=0 s EpLoc=admLoc
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	
	Q:ItemCatStr="" ""
	s len=$l(ItemCatStr,"^")
	for i=1:1:len  {
		s ItemCat=$P(ItemCatStr,"^",i)
		s ret1=..GetLocRecLocByItemCat(EpLoc,ItemCat,CMOrderOpenForAllHosp,OrderDateStr)
		i ret="" {s ret=ret1} 
		else {
			s RecLocCount=$LENGTH(ret1,$C(2))
			For j=1:1:RecLocCount {
			 	S RecLocStr=$P(ret1,$C(2),j)
			 	s MatchRecLoc=$P(RecLocStr,$C(1),1,2)
			 	if ret'[(MatchRecLoc) {
				   s ret=ret_$C(2)_RecLocStr
			 	}
			}
		} 
	}
	Q ret
}

ClassMethod GetCurrentDateTime(DateFormat As %String, TimeFormat As %String) As %String
{
	n (DateFormat,TimeFormat)
	s Curr=$H
	s CurrDateNum=$P(Curr,",",1)
	s CurrTimeNum=$P(Curr,",",2)
	;dd/mm/yyyy hh:mm
	s CurrDate=$ZD(CurrDateNum,DateFormat)
	s CurrTime=..%ZT(CurrTimeNum,TimeFormat)
	Quit CurrDate_"^"_CurrTime_"^"_CurrDateNum_"^"_CurrTimeNum
}

/// 患者余额
/// 改为调用计费组统一接口
ClassMethod GetCurrentDeposit(PAADMRowid As %String) As %String
{
	Q:PAADMRowid="" ""
	s AdmDepDr=$p($g(^PAADM(PAADMRowid)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
	s $ZT="ErrorGetCurrentDeposit"
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAADMRowid)
	s Str=##Class(web.DHCBillInterface).IGetDepAndBalnace(PAADMRowid)
	set stayRtn=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(PAADMRowid)
	set stayFlag=$p(stayRtn,"^",1)
	if (AdmType="I"){ //住院患者余额取 押金-自付费用
		s Num=$P(Str,"^",2) 
	}else{
		if (stayFlag="Y"){ //急诊留观
			s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId) //0:普通收费模式；1：押金收费模式
			if (StayPayMode=0){
				s Num=$P(Str,"^",1)
			}else{
				s Num=$P(Str,"^",2) 
			}
		}else{
			s Num=$P(Str,"^",1)
		}
	}
	s Num=$j(Num,"",2)

	Q Num
ErrorGetCurrentDeposit
    q 0
}

/// Creator:      周志强
/// CreatDate:    2009.03.20
/// Description:: 得到医生站设置里当前医院的代码
/// Table:        
/// Input:        
/// Return:       医院的代码 
/// Others:
ClassMethod GetCurrentHospitalCode() As %String
{
	s HospitalCode=##class(web.DHCDocCommon).GetDocHospitalCode()
	Q HospitalCode
}

ClassMethod GetDiagnosCatArcim(DiagnosCatStr As %String, ArcimRowid As %String) As %String
{
	s ret="",MatchingDiagnosCatStr=""
	Q:DiagnosCatStr="" ""
	s len=$l(DiagnosCatStr,"^")
	for i=1:1:len  {
		s DiagnosCatRowid=$p(DiagnosCatStr,"^",i)
		s sub=0 f  s sub=$O(^DHCDiagnosCat(DiagnosCatRowid,"Item",sub)) Q:sub=""  d
		.s DCArcimRowid=$P($g(^DHCDiagnosCat(DiagnosCatRowid,"Item",sub)),"^",1)
		.Q:DCArcimRowid'=ArcimRowid
		.s DurationRowid=$P($g(^DHCDiagnosCat(DiagnosCatRowid,"Item",sub)),"^",2)
		.s YearMaxQty=$P($g(^DHCDiagnosCat(DiagnosCatRowid,"Item",sub)),"^",3)
	    .s MonthMaxQty=$P($g(^DHCDiagnosCat(DiagnosCatRowid,"Item",sub)),"^",4)
	    .;在获得特殊诊断中存在医嘱匹配的情况下,可控制只显示匹配的特殊诊断
	    .i MatchingDiagnosCatStr="" s MatchingDiagnosCatStr=DiagnosCatRowid
	    .e  s MatchingDiagnosCatStr=MatchingDiagnosCatStr_"^"_DiagnosCatRowid
		.i ret="" s ret=DurationRowid_"^"_YearMaxQty_"^"_MonthMaxQty
		.e  d
		..s PreDurationRowid=$P(ret,"^",1)
		..s PreYearMaxQty=$P(ret,"^",2)
		..s PreMonthMaxQty=$P(ret,"^",3)
		..;取最大疗程限制
		..i DurationRowid'="" s DurationFactor=$p($g(^PHCDU(DurationRowid)),"^",2)
		..e  s DurationFactor=0
		..i DurationFactor="" s DurationFactor=0
		..i PreDurationRowid'="" s PreDurationFactor=$p($g(^PHCDU(PreDurationRowid)),"^",2)
		..e  s PreDurationFactor=0 
		..i PreDurationFactor="" s PreDurationFactor=0
		..i PreDurationFactor>DurationFactor  s DurationRowid=PreDurationRowid
		..;取年最大限制
		..i YearMaxQty'="" d
		...i PreYearMaxQty'="",PreYearMaxQty>YearMaxQty s YearMaxQty=PreYearMaxQty
		..e  s YearMaxQty=PreYearMaxQty
		..;取月最大限制
		..i MonthMaxQty'="" d
		...i MonthMaxQty'="",PreMonthMaxQty>MonthMaxQty s MonthMaxQty=PreMonthMaxQty
		..e  s MonthMaxQty=PreMonthMaxQty
		..s ret=DurationRowid_"^"_YearMaxQty_"^"_MonthMaxQty
	}
	i MatchingDiagnosCatStr="" s MatchingDiagnosCatStr=DiagnosCatStr
	Q ret_$C(1)_MatchingDiagnosCatStr
}

/// Creator:      周志强
/// CreatDate:    2009.04.24
/// Description:: 得到医护人员可以操作的管制级别
/// Table:        CT_CareProv,CT_CarPrvTp,CarPrvTpPHPoison
/// Input:        
/// Output:         
/// Return:       以"^"分隔的管制分类指针字符串
/// Example        w ##class(web.DHCDocOrderCommon).GetDoctorTypePoisonStr(659)
ClassMethod GetDoctorTypePoisonStr(DoctorID As %String, PAAdmType As %String) As %String
{
	s ^TMPgry("GetDoctorTypePoisonStr")=DoctorID_","_PAAdmType
	if DoctorID="" Q ""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:Child=""  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)
	.q:TPPEpisodeType'=PAAdmType
	.i ret="" s ret=PoisonRowId_$C(1)_ControlType
	.e  s ret=ret_"^"_PoisonRowId_$C(1)_ControlType
	Q ret
}

/// Creator?      郭荣勇
/// CreatDate?    2010.07.14
/// Description:? 得到是否存在有效出院医嘱——判断最终结算标志
/// Table?        ARC_ItmMast,OE_OrdItem
/// Input?        EpisodeID:就诊ID
/// Return?       IsExistFlag:存在标志  1为存在  0为不存在
/// Others:       w ##class(web.DHCDocOrderCommon).GetIsExistDischarged(74362)   
ClassMethod GetIsExistDischarged(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	s find=0
	Q:EpisodeID="" find
	
	s PAADMEstimDischargeDate=0,PAADMEstimDischargeTime=0
	s AdmObj=##class(User.PAAdm).%OpenId(EpisodeID)
	if $IsObject(AdmObj){
		s VisitStatus=AdmObj.PAADMVisitStatus
		d AdmObj.%Close()
	}
	s UserRowID=%session.Data("LOGON.USERID")
	s CareProvType=..GetCareProvType(UserRowID)
	s CareProvType=$zcvt(CareProvType,"U")
	i (VisitStatus="D")&&((CareProvType="DOCTOR")||(CareProvType="NURSE")) s find=1
	Q find
	
	/// 判断是否可以录入医嘱,以最终结算为准。不再判断医疗结算
	
	if $IsObject(AdmObj){
		s PAADMEstimDischargeDate=AdmObj.PAADMEstimDischargeDate
		s PAADMEstimDischargeTime=AdmObj.PAADMEstimDischargeTime
		d AdmObj.%Close()
	}
	if +PAADMEstimDischargeDate>0 {
		s find=1
	}

	if find=0 {
		s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
		Q:OrderRowid="" find
		;循环取出医嘱
		s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")||(find=1)  d
		.s billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
		.;如果医嘱未核实则为退出
		.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		.s statcode=""
		.i itemstat'="" d
		..s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		.Q:($g(statcode)'="V")&&($g(statcode)'="E")
		.s ArcimRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
		.s OrderType="",CatDesc=""
		.s ItemCatDR=$P($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
		.if ItemCatDR'="" s OrderType=$p(^ARC("IC",ItemCatDR),"^",7)
		.s CatDesc=$p(^ARC("IC",ItemCatDR),"^",2)
		.if CatDesc="出院" s find=1
	}
	
	Q find
}

/// Creator?      lxz
/// CreatDate?    2014.01.14
/// Description:? 得到医疗结算标志。
/// Table?        ARC_ItmMast,OE_OrdItem
/// Input?        EpisodeID:就诊ID
/// Return?       IsExistFlag:存在标志  1为存在  0为不存在
/// Others:       w ##class(web.DHCDocOrderCommon).GetIsMidDischarged(208)   
ClassMethod GetIsMidDischarged(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s find=0
	Q:EpisodeID="" find
	s PAADMEstimDischargeDate=0,PAADMEstimDischargeTime=0
	s AdmObj=##class(User.PAAdm).%OpenId(EpisodeID)
	if $IsObject(AdmObj){
		s PAADMEstimDischargeDate=AdmObj.PAADMEstimDischargeDate
		s PAADMEstimDischargeTime=AdmObj.PAADMEstimDischargeTime
		d AdmObj.%Close()
	}
	if (PAADMEstimDischargeDate=..%SysDate())&&(+PAADMEstimDischargeTime<..%SysTime())||((+PAADMEstimDischargeDate'=0)&&(PAADMEstimDischargeDate<+$h)) {
		s find=1
	}elseif (+PAADMEstimDischargeDate'=0){
		s find=2
	}
	Q find
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 得到开医嘱需要返回到界面上处理医嘱相关信息
/// Table:        ARC_ItmMast,PHC_DrgMast,PHC_Form,PHC_FormDoseEquiv,
/// DHC_DiagnosCat,DHC_DiagnosCatItem,DHC_DiagnosCatDetail
/// Input:        EpisodeID:就诊ID   InsType:费别,住院病人可以为空  OrderDepRowid:下医嘱科室  ArcimRowid:医嘱项RowId,OpenForAllHosp:跨院标志
/// Return:       信息串 
/// Others:        
ClassMethod GetEPARCIMDetail(EpisodeID As %String, InsType As %String, OrderDepRowid As %String, ArcimRowid As %String, OpenForAllHosp As %String = "", SessionStr As %String = "", ItemDefaultRowId As %String = "", RelocRowID As %String = "", ExpStr As %String = "") As %String
{
	s ^Temp("GetEPARCIMDetail")="w ##class(web.DHCDocOrderCommon).GetEPARCIMDetail("_EpisodeID_","_InsType_","_OrderDepRowid_","""_ArcimRowid_""","_OpenForAllHosp_","""_SessionStr_","""_ItemDefaultRowId_","""_RelocRowID_","_ExpStr_""")"
	n (EpisodeID, InsType, OrderDepRowid, ArcimRowid,OpenForAllHosp,SessionStr,ItemDefaultRowId,RelocRowID,ExpStr,%session)
	s MaterialBarcode=$p(ExpStr,"^",1) //高值条码
	s ITMRowId=$p(ExpStr,"^",2) //医嘱明细ID
	s PPRowId=$p(ExpStr,"^",3) //药理ID
	s CNMEDEntryFlag=$p(ExpStr,"^",4) //是否为草药录入
	s OrderBodyPartLabel=$p(ExpStr,"^",5) //新产品传入的部位体位等数据
	s DCAInfoStr=$p(ExpStr,"^",6) //治疗申请单ID_$c(3)_接收科室ID_$c(3)_首日次数,目前无法从前台传入默认科室,是否可扩展
	s OriginalArcimRowID=$p(ExpStr,"^",7) //医嘱项替换前的原始医嘱ID，为防止替换医嘱维护独立标志，部分权限验证使用原始医嘱进行判断
	i OriginalArcimRowID="" s OriginalArcimRowID=ArcimRowid
	s HospitalCode=..GetCurrentHospitalCode()
	s UserRowId=$p(SessionStr,"^",1)
	s GROUPID=$p(SessionStr,"^",2)
	s CurLogonDep=$p(SessionStr,"^",3)
	s CurLogonHosp=$p(SessionStr,"^",4)
	s DCARowId=$p(DCAInfoStr,$c(3),1)
	s DCARecLocRowId=+$p(DCAInfoStr,$c(3),2)
	;按登录科室取接收科室设置
	/*s CFRecLocByLogonLoc=""
	i OrderDepRowid="" {
		i CurLogonDep'="" s CFRecLocByLogonLoc=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CurLogonDep,1)
	    i CFRecLocByLogonLoc=1 s OrderDepRowid=CurLogonDep
	    //e  s OrderDepRowid=""
	}*/
	s BillGrpDesc="",FormDesc="",ItemType=""
	s FormFreqDesc="",FormInstrDesc="",FormDurDesc=""
	s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
	s FormFreqDesc="",FormFreqRowid="",FormFreqInterval="",FormFreqFactor="1"
	s FormDurDesc="",FormDurRowid="",FormDurFactor="1"
	s FormInstrDesc="",FormInstrRowid="",FormMaxDoseQty=""
	s DefPriorDesc="",DefPriorRowid=""
	s FormRowid="",FormDesc=""
	s PackQty="1",PHPrescType=""
	s OrderDoseStr="",OrderMsg=""
	s PoisonRowid="",PoisonCode="",SkinTestYY="",PHCDFCQZTFlag="N",PHCDFONEFlag="N",PHCDFCHKOMFlag="N"
	s OrderDepProcNote="",OrderSpeedFlowRate="",OrderFlowRateUnitDr="",OrderFlowRateUnit="",DIDExceedReasonDR=""
	Set langid=$p(SessionStr,"^",6)
    s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	s AdmDepId=$P($G(^PAADM(EpisodeID)),"^",4)
	s ArcimCode=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s ArcimDesc=..GetFormateOrderName(ArcimRowid,CurLogonHosp,langid)
	if (OrderBodyPartLabel'=""){
		s VerifyPartFlag=##class(web.DHCAPPInterface).VerifyPartInArci(ArcimRowid,$TR(OrderBodyPartLabel,"*","^"))
		if (VerifyPartFlag="Y"){
			s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR(OrderBodyPartLabel,"*","^"),langid)
			i PartInfo'="" s ArcimDesc=ArcimDesc_PartInfo
		}
	}
	s BillsubRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",9)
	i BillsubRowid'="" s BillGrpDesc=$p(^ARCBG(+BillsubRowid),"^",2)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s AllowOrderWithoutStock=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",11)
	//s BillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s BillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,EpisodeType)
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcimRowid)
	if (CheckCHNFlag="Y") {
		S Phcdf=$P($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1)),"^",12)
		if (Phcdf'=""){
			s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
	}
	s DefPriorRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8),"^",22)
	i DefPriorRowid'="" s DefPriorDesc=$p($g(^OECPR(DefPriorRowid)),"^",2) 
	s BillUOMDesc=..GetUOMDesc(BillUOMRowid,langid)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	
	s OrderMsg=..GetOrderMsg(EpisodeID,ArcimRowid)
	;是否可以使用紧急标志
	s Sensitive=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",18)
	;是否默认加急
	s ARCIMDefSensitive= $p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",41) 
	;医嘱特检代码
	s SpecCheckCode=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",32)
	;处方类型,可以根据设置里的类别来定或者也可以根据账单单位确定
	i OrderType="R"{
		s PHPrescType=..GetPHPrescType(ItemCatRowid,CurLogonHosp,ArcimRowid)
		i PHPrescType="" s PHPrescType="1"
	}else{
		s PHPrescType=..GetPHPrescType(ItemCatRowid,CurLogonHosp,ArcimRowid)
	}
	s ForbidDosingInstr=""
	if (CurLogonDep'=""){
		s ForbidDosing=$P($G(^CTLOC(CurLogonDep,"DHC")),"^",18)
		i (ForbidDosing="1"){
			if (EpisodeType="I"){
				s ForbidDosingInstr=..%GetConfig("IPDosingInstr",CurLogonHosp)
			}elseif (EpisodeType="O"){
				s ForbidDosingInstr=..%GetConfig("OPInfusionInstr",CurLogonHosp)
			}
			i ForbidDosingInstr'="" s ForbidDosingInstr="^"_ForbidDosingInstr_"^"
		}
	}
	i INCIRowid'="" d
	.; INCI_CTUOM_DR  库存基本单位
	.s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	.s BaseUOMDesc=..GetUOMDesc(BaseUOMRowid,langid)
	
	s ItemDefPackQty="",ItemDefSkinTest="",ItemDefSkinAction="",ItemDefNotes="",PHCDFCriticalFlag="N",DIDLocDr="",SpecOrderPackUomRowid=""
	s PHCDoseStr=""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	i DrgformRowid'="" {
	  s PHCDRowid=$P(DrgformRowid,"||",1)
	  s ChildSub=$P(DrgformRowid,"||",2)
	  ;剂型
	  s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
	  i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	  ;频率
	  s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	  if (FormFreqRowid'=""){
	      s Active=$P($g(^PHCFR(FormFreqRowid)),"^",6)
	      s AvailableType=$P($g(^PHCFR(FormFreqRowid)),"^",7)
	      if ((AvailableType'="")&&(AvailableType'[EpisodeType))||(Active="N"){
		  	s FormFreqRowid=""
		  }
	  }
	  i FormFreqRowid'="" {
		  s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		  s FormFreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FormFreqDesc,langid)
		  s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		  s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
	  }
	  ;用法
	  s FormInstrRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5)
	  if (FormInstrRowid'=""){
	      s Active=$P($g(^PHCIN(FormInstrRowid)),"^",4)
	      s AvailableType=$P($g(^PHCIN(FormInstrRowid)),"^",5)
	      if ((AvailableType'="")&&(AvailableType'[EpisodeType))||(Active="N"){
		  	s FormInstrRowid=""
		  }
	  }elseif (ForbidDosingInstr[("^"_FormInstrRowid_"^")){
	  	s FormInstrRowid=""
	  }
	  
	  i FormInstrRowid'="" d
	  .s FormInstrDesc=$P($g(^PHCIN(FormInstrRowid)),"^",2)
	  .s FormInstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",FormInstrDesc,langid)
	  .i (FormInstrDesc="遵医嘱")&&(HospitalCode="YKYZLYY") d
	  ..s FormInstrDesc="",FormInstrRowid=""
	  ;疗程
	  s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  i FormDurRowid'="" {
		  s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		  s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
	  }
	  if EpisodeType="I" {
	  	s FormDurRowid=..%GetConfig("IPDefaultDuration")
	  	i FormDurRowid'="" {
		  s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		  s FormDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",FormDurDesc,langid)
		  s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
	  	}
	  }
	  
	  ;剂量
	  s PHUseEqQty=..%GetConfig("PHUseEqQty",CurLogonHosp)
	  s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  s FormDoseUOMDesc=..GetUOMDesc(FormDoseUOMRowid,langid)
	  if FormDoseUOMRowid'=""{
			s formDoseQty(FormDoseUOMRowid)=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(1)_"N"
	  }
	  ;s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  ;i leq'="" d
	  ;草药不取等效单位
	  s defaultFindFlag=0,firstEqUomID=""
	  if (PHPrescType'=3) {
		  s leq=0  f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) q:leq=""  d
		  .s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
		  .s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3),defaultFlag=$p(eqrec,"^",4)
		  .;s FormDoseQty=eqdefaultqty
		  .if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
		  .e  d
		  ..i PHUseEqQty=1 s FormDoseQty=eqqty
		  ..e  s FormDoseQty=""
		  .s FormDoseUOMDesc=..GetUOMDesc(FormDoseUOMRowid,langid)
		  .i (FormDoseQty'="")&(FormDoseQty<1)&(FormDoseQty'=0) s FormDoseQty="0"_FormDoseQty
		  .s formDoseQty(FormDoseUOMRowid)=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(1)_defaultFlag_$C(1)_FormDoseQty
		  .s:firstEqUomID="" firstEqUomID=FormDoseUOMRowid
		  .s:defaultFlag="Y" defaultFindFlag=1
	  }
	  //没有设置默认 默认第一个等效单位
	  if 'defaultFindFlag&&(firstEqUomID'=""){
		s $P(formDoseQty(firstEqUomID),$C(1),4)="Y"
	  }
	  s OrderDoseStr=""
	  s fromDoseId="" for {
		s fromDoseId=$o(formDoseQty(fromDoseId)) Q:fromDoseId=""
		i OrderDoseStr="" s OrderDoseStr=formDoseQty(fromDoseId)
		e  s OrderDoseStr=OrderDoseStr_$C(2)_formDoseQty(fromDoseId)
	  }
	  s PHCDoseStr=$p(OrderDoseStr,$C(2),1)
	  ;得到医嘱常用信息
	  if ItemDefaultRowId'="" {
		  s ItemDefaultExpStr=""
		  s PreFormInstrRowid=FormInstrRowid,PreFormInstrDesc=FormInstrDesc
		  s PreFormFreqRowid=FormFreqRowid,PreFormFreqDesc=FormFreqDesc,PreFormFreqFactor=FormFreqFactor,PreFormFreqInterval=FormFreqInterval
		  d ##class(web.DHCDocItemDefault).GetItemDefault(ItemDefaultRowId,.DefPriorRowid,.DefPriorDesc,.OrderDoseStr,.FormInstrRowid,.FormInstrDesc,.FormFreqRowid,.FormFreqDesc,.FormFreqFactor,.FormFreqInterval,.FormDurRowid,.FormDurDesc,.FormDurFactor,.ItemDefaultExpStr,langid)
		  if (FormInstrRowid'=""){
		      s Active=$P($g(^PHCIN(FormInstrRowid)),"^",4)
		      s AvailableType=$P($g(^PHCIN(FormInstrRowid)),"^",5)
		      if ((AvailableType'="")&&(AvailableType'[EpisodeType))||(Active="N")||(ForbidDosingInstr[("^"_FormInstrRowid_"^")){
			  	s FormInstrRowid=PreFormInstrRowid,FormInstrDesc=PreFormInstrDesc
			  }
		  }
		  if (FormFreqRowid'=""){
		      s Active=$P($g(^PHCFR(FormFreqRowid)),"^",6)
		      s AvailableType=$P($g(^PHCFR(FormFreqRowid)),"^",7)
		      if ((AvailableType'="")&&(AvailableType'[EpisodeType))||(Active="N"){
			  	s FormFreqRowid=PreFormFreqRowid,FormFreqDesc=PreFormFreqDesc,FormFreqFactor=PreFormFreqFactor,FormFreqInterval=PreFormFreqInterval
			  }
		  }
		  s ItemDefPackQty=$p(ItemDefaultExpStr,"^",1)
		  s ItemDefSkinTest=$p(ItemDefaultExpStr,"^",2)
		  s ItemDefSkinAction=$p(ItemDefaultExpStr,"^",3)
		  s ItemDefNotes=$p(ItemDefaultExpStr,"^",4)
		  s OrderDepProcNote=ItemDefNotes
		  s OrderSpeedFlowRate=$p(ItemDefaultExpStr,"^",5)
		  s OrderFlowRateUnitDr=$p(ItemDefaultExpStr,"^",6)
		  if OrderFlowRateUnitDr'="" s OrderFlowRateUnit=$P($G(^OEC("SFR",OrderFlowRateUnitDr)),"^",2)
		  s DIDExceedReasonDR=$p(ItemDefaultExpStr,"^",7)
		  s DIDLocDr=$p(ItemDefaultExpStr,"^",8)
		  //s PHCDoseStr=$p(OrderDoseStr,$C(2),1)
		  for i=1:1:$l(OrderDoseStr,$C(2)){
			  s OneOrderDoseStr=$p(OrderDoseStr,$C(2),i)
			  if ($p(PHCDoseStr,$C(1),3)=$p(OneOrderDoseStr,$C(1),3)) {
				  s PHCDoseStr=$p(PHCDoseStr,$C(1),1)_$C(1)_$p(OneOrderDoseStr,$C(1),2,3)
				  Q
			  }
		  }
		  s OrderFreqTimeDoseStr=$p(ItemDefaultExpStr,"^",9)
		  s SameFreqDifferentDosesFlag="N"
		  s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ArcimRowid,""))
		 if (DARCIMRowid'=""){
				s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
				if (SameFreqDifferentDosesFlag="N")&&(OrderFreqTimeDoseStr'=""){
					s OrderFreqTimeDoseStr=""
					}
			}
		  s OrderFreqWeekStr=$p(ItemDefaultExpStr,"^",10)
		  s SpecOrderPackUomRowid=$p(ItemDefaultExpStr,"^",11)
	  }else{
		  ;不能直接找默认,会护士关联医嘱套等冲突？
		  ;do ..GetItemDefault(ArcimRowid,SessionStr,.DefPriorRowid,.DefPriorDesc,.OrderDoseStr,.FormInstrRowid,.FormInstrDesc,.FormFreqRowid,.FormFreqDesc,.FormFreqFactor,.FormFreqInterval,.FormDurRowid,.FormDurDesc,.FormDurFactor)
	  }
	  //判断默认用法是否是配液用法,验证录入科室是否可以录入配液用法
	  if (FormInstrRowid'=""){
		  s ForbidDosingInstr=""
		  if (CurLogonDep'=""){
			s ForbidDosing=$P($G(^CTLOC(CurLogonDep,"DHC")),"^",18)
			i (ForbidDosing="1"){
				if (EpisodeType="I"){
					s ForbidDosingInstr=..%GetConfig("IPDosingInstr",CurLogonHosp)
				}elseif (EpisodeType="O"){
					s ForbidDosingInstr=..%GetConfig("OPInfusionInstr",CurLogonHosp)
				}
			}
		  }
		  if (ForbidDosingInstr'=0)&&(("^"_ForbidDosingInstr_"^")[("^"_FormInstrRowid_"^")){
			  s FormInstrRowid="",FormInstrDesc=""
		  }

	  }
	  
	  ;计算整包装
	  if (EpisodeType="O")!(EpisodeType="E") {
	    s PriorRowid=""
		i OrderType="R" d
		.s PackQty=##class(web.DHCDocOrderEntry).GetPackqty(ArcimRowid,DrgformRowid,FormFreqRowid,PriorRowid,FormDurRowid,FormDoseQty,FormDoseUOMRowid,BillUOMRowid)
		e  s PackQty="1"
	  }else{
		i OrderType="R" s PackQty=""
	  }
	  i ItemDefPackQty'="" s PackQty=ItemDefPackQty
	  
	  s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
	  s PoisonCode=""
	  i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	  
	  ;皮试是否使用原液
	  i EpisodeType="I" d
	  .s SkinTestYY=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",3)
	  e  d
	  .s SkinTestYY=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",2)
	  ;PHCDF_PBSQuan
	  s FormMaxDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,3)),"^",16)
	  
	  s PHCDFCQZTFlag=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",40) //长期默认嘱托
	  s PHCDFONEFlag=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",41) //临时默认取药
	  s PHCDFCriticalFlag=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",9) //危重药标志
	  s PHCDFCHKOMFlag=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC",2)),"^",2) //附加说明默认自备
	}
	//取得可以录入频次疗程的非药品医嘱的默认设置
	if PHPrescType="4" {
		s FormFreqFactor=1
		s FormDurFactor=1
		s FormFreqRowid= $P($G(^ARC("IC",ItemCatRowid,"DHC")),"^",3)
		i FormFreqRowid="" s FormFreqRowid=..%GetConfig("FrequencedItemFreq",CurLogonHosp)
		i +FormFreqRowid'=0 {
		  s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		  s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		  s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		}
		//住院默认一天
		if EpisodeType'="I" {
			s FormDurRowid=..%GetConfig("FrequencedItemDur",CurLogonHosp)
			i FormDurRowid=0 s FormDurRowid=""
		}else{
			s FormDurRowid=..%GetConfig("IPDefaultDuration",CurLogonHosp)
		}
	  	i +FormDurRowid'=0 {
		  s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		  s FormDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",FormDurDesc,langid)
		  s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		}
		s PackQty=FormDurFactor*FormFreqFactor
	}
	if (EpisodeType="I"){
		/*s defFormDurRowid=..%GetConfig("IPDefaultDuration",CurLogonHosp)
		if (FormDurRowid'=defFormDurRowid){
			s FormDurRowid=defFormDurRowid
			i FormDurRowid'="" {
			  s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
			  s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
			}
		}*/
		if (OrderType="L")||(..GetItemServiceFlag(ArcimRowid)=1){
			s FormDurDesc="",FormDurRowid="",FormDurFactor=""
		}
	}
	s FormFreqWeekFlag="N"
    if (FormFreqRowid'=""){
		s FormFreqWeekFlag=$P(^PHCFR(FormFreqRowid),"^",9)   
	}
	s LabSpec=""
	if OrderType="L" s LabSpec=..GetLabSpec(ArcimRowid,CurLogonHosp,langid)
	s SttDate=..%SysDate()
	s PatType=""
	
	s PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
	i EpisodeType="I" s InsType=PAADMInsType
	s:+InsType=0 InsType=""
	i InsType="" s BillTypeDesc="自费"
	e  s BillTypeDesc=$P(^PAC("ADMREA",InsType),"^",2)
	
	;取接收科室
	/* 
	i OrderDepRowid'="" s RecLocStr=..GetLocRecLoc(OrderDepRowid,ArcimRowid,OpenForAllHosp)
	e  s RecLocStr=..GetRecloc(EpisodeID,ArcimRowid,OpenForAllHosp)
	*/
	//2019-12-11 长期医嘱接收科室不受节假日接收科室限制
	//按节假日接收科室设置 
	s RecLocStr="",HolidayRecLocStr=""
	s OutOrderRecLocStr="",OneOrderRecLocStr=""
	s DefaultRecLoc=""
	 //增加对医嘱套维护接收科室设置
    if ((+ITMRowId'="0")&&($l(ITMRowId,"||")=3)){
	    s DefaultRecLoc=$p($g(^ARCOS(+ITMRowId,"DATE",$p(ITMRowId,"||",2),"ITM",$p(ITMRowId,"||",3))),"^",21)
	}
    //常用用法维护接收科室设置
    if (DIDLocDr'=""){
		s DefaultRecLoc=DIDLocDr
	}
	//治疗申请传入接收科室
	if DCARecLocRowId>0{
		s DefaultRecLoc=DCARecLocRowId
	}
	
	//----
	k ParamJson,ParamArr
	s ParamArr("EpisodeID")=EpisodeID
    s ParamArr("SessionStr")=SessionStr
    s ParamArr("OpenForAllHosp")=OpenForAllHosp
    s ParamArr("FindRecLocByLogonLoc")=$CASE(OrderDepRowid,"":0,:1)
	
	s ParamArr("DefaultReclocRowid")=DefaultRecLoc
    s ParamArr("OrderARCIMRowid")=ArcimRowid
    s ParamArr("OrderInstrRowid")=""	;ReclocByInstr,此处不能调用按用法取接收科室篡改RecLocStr的值,这样将导致前台修改用法后无法得到正确的接收科室.转到前台js中处理
    s ParamArr("OrderDateStr")=""
    s ParamArr("OrderPriorRowid")=$O(^OECPR(0,"Code","S",0))
    s ParamArr("OrderPriorRemarksRowId")=""

	s ParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParamArr)
	s RecLocJson=..GetRecLocInfo(ParamJson)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocJson,.RecLocArr)

	s RecLocStr=$G(RecLocArr("OrderNormalRecLocStr"))
	s OutOrderRecLocStr=$G(RecLocArr("OrderOutPriorRecLocStr"))
    s OneOrderRecLocStr=$G(RecLocArr("OrderOnePriorRecLocStr"))
    s HolidayRecLocStr=$G(RecLocArr("OrderHolidayRecLocStr"))

	s DefaultRecLoc=""
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,DefaultRecLoc)
	s DefaultRecLoc=$$GetDefalocID(RecLocStr)
	i RelocRowID'="" {
		s DefaultRecLoc=RelocRowID ;如果传入接收科室按照传入的计算价格
	}
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s ExpStrin=PAADMRegConDisDR_"^^^"_EpisodeID_"^"_DefaultRecLoc_"^"_""_"^"_MaterialBarcode
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ArcimRowid, SttDate, "", "", "", "",CurLogonHosp,ExpStrin)
	s Price=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s ConFac=1
	s RealStockQty=1
	
	;if (INCIRowid'="")&&(AllowOrderWithoutStock'="Y") {
	if (INCIRowid'="") {
		s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimRowid,INCIRowid,BillUOMRowid)
		s Price=$fn(Price*ConFac,"",4)
		s DiscPrice=$fn(DiscPrice*ConFac,"",4)
		s InsPrice=$fn(InsPrice*ConFac,"",4)
		s PatPrice=$fn(PatPrice*ConFac,"",4)
	}
	//45
	if (INCIRowid'="")&(AllowOrderWithoutStock="Y") s INCIRowid=""
	;皮试标志 
	s NeedSkinTestINCI=##class(web.DHCOutPhCommon).GetSkinTestFlag(ArcimRowid)
	
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowid,0))
	i DHCARCIMRowid'="" d
	.s NeedSkinTest=$P(^DHCItmMast(DHCARCIMRowid),"^",6)
	.s SttIsCanCrossDay=$P(^DHCItmMast(DHCARCIMRowid),"^",11) //医嘱开始日期时间是否可以跨日
	.s OrdDateIsCanCrossDay=$P(^DHCItmMast(DHCARCIMRowid),"^",25) //开医嘱日期时间是否可以跨日
	.//i IsCanCrossDay="" s IsCanCrossDay="N"
	e  s NeedSkinTest="N",SttIsCanCrossDay="",OrdDateIsCanCrossDay=""
	i NeedSkinTest="" s NeedSkinTest="N"
	i ItemDefSkinTest'="" s NeedSkinTest=ItemDefSkinTest
	/*
	i NeedSkinTest="N" s NeedSkinTest=NeedSkinTestINCI
	if (HospitalCode="SHHSPD")&&(EpisodeType="I") {
		s TempStr=..CheckNeedSkinTest(EpisodeID,ArcimRowid)
		s NeedSkinTest=$P(TempStr,"^",1)
	}
	
	//i ItemDefSkinAction'="" s SkinTestYY=ItemDefSkinAction
	if (NeedSkinTest'="Y")&&(FormInstrRowid'=""){
		;皮试用法
		s SkinTestInstr=..%GetConfig("SkinTestInstr")
		if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
		if (SkinTestInstr[("^"_FormInstrRowid_"^")){
			 s NeedSkinTest="N",ItemDefSkinAction=""
		}
	}
	if (SkinTestYY=1)&&(NeedSkinTest="N") {
		s NeedSkinTest="Y"
	}
	*/
	
	;
	;药品的门诊住院限用标志
	s InsurAdmFlag=""
	s OrderAdmLimit=..%GetConfig("OrderAdmLimit",CurLogonHosp)
	i OrderAdmLimit=1 s InsurAdmFlag=..GetOrderAdmLimit(EpisodeID,ArcimRowid,InsType)
	;
	;单次最大基本剂量	ARCIM_MaxCumDose
	s MaxDoseQty=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",30)
	s MaxDoseQty=##class(DHCDoc.Util.Base).FormateNumber(MaxDoseQty)
	;限制疗程	ARCIM_NoOfCumDays
	s LimitDays=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",31)
	;一天总剂量	ARCIM_MaxQtyPerDay
	s MaxDoseQtyPerDay=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",37)
	s MaxDoseQtyPerOrder=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",38)
	
	;剂量最大值,诊断的最大疗程参数
	s MaxQty=##Class(web.DHCDocOrderEntry).GetARCIMMaxQty(ArcimRowid)
	;基本设置-》费别疗程限制,针对的是就诊费别
	s LimitDuratonRowid=..%GetConfig1("BillTypeDuration",PAADMInsType,CurLogonHosp)
	;s LimitDuratonRowid=..%GetConfig1("BillTypeDuration",InsType)
	if LimitDuratonRowid'="" s LimitDurFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(LimitDuratonRowid)
	e  s LimitDurFactor=0
	//i LimitDurFactor=0 s LimitDurFactor=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",31) //ARCIM_NoOfCumDays药品信息维护，限制使用天数

	s MaxDurFactor=0
	;s MaxDurFactor=##class(web.DHCDocOrderEntry).GetDiagnosLimitDurFactor(PatType,madm)
	if MaxDurFactor=0 s MaxDurFactor=LimitDurFactor
	s WarningUseQty=""
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowid,0))
	i DHCARCIMRowid'="" s WarningUseQty=$p($G(^DHCItmMast(DHCARCIMRowid)),"^",12)
	
	;
	;取特殊病疗程,数量限定
	s MrAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s DiagnosCatArcimPass="1"
	s HaveDiagnosCat="0"
	s DCDurationFactor=0
	s IsADMInsTypeDCArcim="0"
	;是否费别定义的特病分类,肿瘤要求如果是特病处方但没有特病诊断不允许录医嘱
	s BillTypeHaveDiagnosCat="0"
	s EPDiagnosCatStr=""
	;虽然GetDiagnosCatArcim中会根据病种设定中的诊别去判断,但为了提高效率在此次只判断门诊
	if (EpisodeType'="I") {
		/*
		;判断此类项目是否在就诊费别的特病限定里,如果存在则不允许在其他的费别(处方类型)中开出
		i (PAADMInsType'=InsType) {
			s PAADMDiagnosCat=..GetEPDiagnosCat(EpisodeType,PAADMInsType,MrAdmRowid)
			i (PAADMDiagnosCat'="") {
		    	//s HaveDiagnosCat="1"
		    	s TempStr=..GetDiagnosCatArcim(PAADMDiagnosCat,ArcimRowid)
		    	i TempStr'="" s IsADMInsTypeDCArcim="1"
			}
		}
		*/
		i IsADMInsTypeDCArcim="0" {
			s BillTypeDiagnosCat=..GetBillTypeDiagnosCat(EpisodeType,InsType,CurLogonHosp)
			s EPDiagnosCat=..GetEPDiagnosCat(EpisodeType,InsType,MrAdmRowid,CurLogonHosp)
			i EPDiagnosCat'="" {
		    	s EPHaveDiagnosCat="1"
		    	s TempStr=..GetDiagnosCatArcim(EPDiagnosCat,ArcimRowid)
		    	s EPDurationInfo=$p(TempStr,$c(1),1)
		    	i EPDurationInfo'="" {
			    	s MatchingDiagnosCatStr=$p(TempStr,$c(1),2)
			    	;得到医嘱匹配的特殊诊断分类
			    	s EPDiagnosCat=MatchingDiagnosCatStr
		    		s DCDurationRowid=$P(EPDurationInfo,"^",1)
		    		i DCDurationRowid'="" s DCDurationFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(DCDurationRowid)
		    		//诊断设置-特殊诊断分类-医嘱明细未设置疗程，特殊诊断记录的疗程设置
			    	if (DCDurationFactor=0){
				    	s DCDurationRowid=$p($g(^DHCDiagnosCat(EPDiagnosCat)),"^",4)
				    	i DCDurationRowid'="" s DCDurationFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(DCDurationRowid)
				    }
		    	}else{
			    	s EPDiagnosCat=""
		    		s NotDiagnosCatArcimAllow=..%GetConfig1("DiagnosCatArcimAllow",InsType,CurLogonHosp)
		    		i NotDiagnosCatArcimAllow'="1" s DiagnosCatArcimPass="0"
		    		i (HospitalCode'="ZGYKDFSYY"){
	    				i OrderType'="R" s DiagnosCatArcimPass="1"
	    			}
		    	}
				
			}else{
		    	s NotDiagnosCatArcimAllow=..%GetConfig1("DiagnosCatArcimAllow",InsType,CurLogonHosp)
				i (BillTypeDiagnosCat'="")&&(OrderType="R")&&(NotDiagnosCatArcimAllow'="1") s DiagnosCatArcimPass="0"
			}
			s EPDiagnosCatStr=""
			for i=1:1:$l(EPDiagnosCat,"^") {
				s DiagnosCatRowid=$p(EPDiagnosCat,"^",i)
				continue:DiagnosCatRowid=""
				s DCDesc=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",1)
				Set langid=$p(SessionStr,"^",6)
				Set DCDesc= ##class(User.DHCDiagnosCat).GetTranByDesc("DCDesc",DCDesc,langid)
				i EPDiagnosCatStr="" s EPDiagnosCatStr=DiagnosCatRowid_$C(1)_DCDesc
				e  s EPDiagnosCatStr=EPDiagnosCatStr_$C(2)_DiagnosCatRowid_$C(1)_DCDesc
			}
		}
	}
	if DCDurationFactor>0 s MaxDurFactor=DCDurationFactor 
	;
	s OrderFile1=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",5)
	s OrderFile2=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",19)
	s OrderFile3=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",20)
	;
	;检查是否在既往医嘱的疗程内
	s PreOrderDate="",PreOrderIntervalDur=""
	//s NotAllowItemInDuration=..%GetConfig1("NotAllowItemInDuration",InsType)
	s NotAllowItemInDuration=..%GetConfig1("NotAllowItemInDuration",PAADMInsType,CurLogonHosp)
	s CheckItemInDur=0
	i EpisodeType="O",OrderType="R" d
	.;优先确定是否判断精神类药品
	.i PoisonRowid'="" s CheckItemInDur=1
	.e  i NotAllowItemInDuration'=0 s CheckItemInDur=1
	i CheckItemInDur=1 d
	.//s TempStr=##class(web.DHCDocOrderEntry).CheckItemInDuration(EpisodeID,InsType,ArcimRowid)
	.s TempStr=##class(web.DHCDocOrderEntry).CheckItemInDuration(EpisodeID,PAADMInsType,ArcimRowid,CurLogonHosp)
	.i TempStr'="" s PreOrderDate=$P(TempStr,"^",3) s PreOrderIntervalDur=$P(TempStr,"^",4)
	
	s LabExcode=""
	i OrderType="L" s LabExcode=..GetExCode(ArcimRowid)

	s PapmiRowid=$p($G(^PAADM(EpisodeID)),"^",1)
	s Allergy=..GetAllergy(PapmiRowid,ArcimRowid)

	s limitFlag="",InsurAdmAllowFlag=""
	;s ArcimLinkInsu=##class(web.INSUTarContrastCom).ArcimLinkInsu(ArcimRowid,InsType)
	;医保组从2010.3.3号起统一到了web.DHCINSUPort里面了
	//s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ArcimRowid,InsType,CurLogonHosp)
	s ArcimLinkInsu=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimRowid,InsType,CurLogonHosp,"",1)
	i (ArcimLinkInsu'="")&&(ArcimDesc'=""){
		;医保返回错误代码的情况
		if +ArcimLinkInsu>=0{ 
			s ArcimLinkInsu=$replace(ArcimLinkInsu,$c(10),"</br>")
			s ArcimLinkInsu=$replace(ArcimLinkInsu,$c(13),"</br>")
			;医保类别(甲,乙,丁等) ;自负比例
			s ArcimLinkInsu1=##class(web.DHCDocInPatPortalCommon).GetInsuClassInfo(ArcimRowid,InsType,CurLogonHosp)
			
			;适应症描述
			s InsurAdmAllowFlag=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimRowid,InsType,CurLogonHosp,"",8)
			;限制用药标志(0不限制,1限制)
			s limitFlag=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ArcimRowid,InsType,CurLogonHosp,"",9)
			;草药录入框显示的就比较小,所以就不加前缀了
			i (PHPrescType'=3)&&(ArcimLinkInsu1'="") s ArcimDesc="("_ArcimLinkInsu1_")"_ ArcimDesc
			i InsurAdmAllowFlag="N" s InsurAdmFlag="2"
		}
	}
	;医保标志
	s InsurFlag=..GetInsurFlag(InsType)
	///医保适应症提示信息
	s (InsurAlertStr,InsuContrastCode,InsuContrastDesc)=""
	if InsurFlag'="0" {
		Set langid=$p(SessionStr,"^",6)
		;s InsurAlertStr=##class(web.INSUTarContrastCom).ArcimLinkTarStr(ArcimRowid,EpisodeID)
		s InsurAlertStr=##class(web.DHCINSUPort).ArcimLinkTarStr(ArcimRowid,InsType,CurLogonHosp,langid)
		s InsurAlertStr=$tr(InsurAlertStr,"^","!")
        ;医保目录对照
        s ArcimLinkInsuList=##class(web.DHCINSUPort).ArcimLinkInsuList(ArcimRowid,InsType,CurLogonHosp,"")
        if ($p(ArcimLinkInsuList,"^",1)<0){
            s InsuContrastCode=$p(ArcimLinkInsuList,"^",1)
            s InsuContrastDesc=$p(ArcimLinkInsuList,"^",2)
        }
	}
	
	;特殊药品或者材料需要医保审核的提示
	s AlertAuditSpecialItem="0"
	i (HospitalCode="JSXZZXYY"){
		s AlertAuditSpecialItem=..GetAlertAuditSpecialItem(ArcimRowid,InsType)
	}
	
	;可以提示给用户的最小库存数量
	s AlertStockQty=..GetARCIMAlertStockQty(ArcimRowid)
	
	;住院是否需要录入整包装数量 
	s IPNeedBillQty=..GetARCIMIPNeedBillQty(ArcimRowid)
	
	s isOwn="Y"
	;判断是否此医嘱项已经停止
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ArcimRowid)
	i OrderItemInValid="0" {
		s isOwn=$p($g(^ARCIM(+OriginalArcimRowID,$p(OriginalArcimRowID,"||",2),7)),"^",13)
	    i (isOwn="N")&&(+ITMRowId="0") s OrderItemInValid=1 //非独立医嘱通过医嘱套要求能录入
	}
	;草药备注
	s ProcessingNotes=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",14)
	;草药备注
	s CNMedItemCatStr=..GetCNMedItemCatStr(CurLogonHosp)
	i CNMedItemCatStr'="" s CNMedItemCatStr="^"_CNMedItemCatStr_"^"
	i DrgformRowid'="",CNMedItemCatStr[("^"_ItemCatRowid_"^") {
		s PHCDRowid=$P(DrgformRowid,"||",1)
		s ChildSub=$P(DrgformRowid,"||",2)
    	s ProcessingNotesId=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,"DHC")),"^",7)
    	s CNMedItemPhSpecInstr=..%GetConfig("CNMedItemPhSpecInstr",CurLogonDep)
    	//$g(^DHCDocConfig("CNMedItemPhSpecInstr"))
    	s ProcessingNotes=$P($p(CNMedItemPhSpecInstr,"^",ProcessingNotesId),$c(1),2)
	}

	;药品通用名
	s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	
	;判断检验是否可用
	s LabItemActive=..CheckLabItemActive(LabExcode,CurLogonHosp)
	;权限控制
	s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GROUPID,OriginalArcimRowID,EpisodeType,AdmDepId,UserRowId,CurLogonDep,CNMEDEntryFlag,ITMRowId,PatientID,EpisodeID)
	;药理子类控制
	s PilotCatFlag=..CheckPilotCat(EpisodeID,ArcimRowid,PPRowId,CurLogonHosp)
	;判断是否是小时医嘱
	s IsHourItem=..IsHourItem(ArcimRowid)
	;按照医嘱项上的门诊用药、急诊用药、住院用药标志来检测医嘱项是否可用
	s CheckArcimTypeStr=..CheckArcimType(ArcimRowid,EpisodeID)
	;录入医嘱的时候,判断医嘱的药学子类和过敏记录的药品的药学子类是否相同
	s AllergyChildNotice=..CheckAllergyChildNotice(PatientID,ArcimRowid)
	;;医嘱/药学项设置】-【医嘱扩展设置】-需要提示
	s ARCIMShowOEMessageFlag=..GetARCIMShowOEMessageFlag(ArcimRowid)
	;得到医嘱的性别/年龄限制 1 限制,0非限制
	s PAPMIRowid=$P(^PAADM(EpisodeID),"^",1)
	Set langid=$p(SessionStr,"^",6)
	s ASCheckStr=..GetItemAgeSexRestriction(ArcimRowid,PAPMIRowid,CurLogonHosp,langid)
	;验证医嘱默认类型和能够使用的类型是否冲突、存在
	i DefPriorRowid'="" s OldDefPriorCode=$p($g(^OECPR(DefPriorRowid)),"^",1)
	e  s OldDefPriorCode=""
	s OrderPriorRemarks="",OrderPriorRemarksRowId=""
	S DefPriorRowid=..CheckDefPrior(EpisodeID,DefPriorRowid,CurLogonDep)
	if (DefPriorRowid'=""){
		s DefPriorDesc=$p($g(^OECPR(DefPriorRowid)),"^",2) 
		;长期医嘱
		s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
		if (DefPriorRowid=LongOrderPriorRowid){
			if (OldDefPriorCode="OMST"){
				s OrderPriorRemarks="自备药"
				s OrderPriorRemarksRowId="OM"
			}
			if (OldDefPriorCode="OMCQZT"){
				s OrderPriorRemarks="嘱托"
				s OrderPriorRemarksRowId="ZT"
			}
			
		}
		;临时医嘱
		s ShortOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
		if (DefPriorRowid=ShortOrderPriorRowid){
			if (OldDefPriorCode="ONE")&&(EpisodeType="I"){
				s OrderPriorRemarks="取药医嘱"
				s OrderPriorRemarksRowId="ONE"
			}
			if (OldDefPriorCode="OM"){
				s OrderPriorRemarks="自备药"
				s OrderPriorRemarksRowId="OM"
			}
			if (OldDefPriorCode="OMLSZT"){
				s OrderPriorRemarks="嘱托"
				s OrderPriorRemarksRowId="ZT"
			}
		}
	}
	;是否存在医疗结算标志
	s MidDischargedFlag=..GetIsMidDischarged(EpisodeID)
	;高值标志
	s IncItmHighValueFlag=..GetIncItmHighValueFlag(ArcimRowid)
	;转科类医嘱提示
	s TransFlag=0
	;停今日及以后长期医嘱设置
	s ARCIMExtInfo=##class(DHCDoc.DHCDocConfig.ARCIMExt).getARCIMConfig(ArcimRowid)
	s StopAfterLongOrderFlag=$P(ARCIMExtInfo,"^",3)
	i StopAfterLongOrderFlag=1 {
		if (CurLogonDep'=AdmDepId)&($D(^PAADMi("TransLoc",EpisodeID,CurLogonDep))){
			s TransFlag=1
		}
	}
	;对只允许开一次的医嘱进行检测
	s AllowOnlyOnceRepeatFlag=..CheckARCIMAllowOnlyOnce(EpisodeID,ArcimRowid,.AllowOnlyOnce,.AdmAllowOnlyOnce)
	;同频次不同剂量医嘱标志
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ArcimRowid,""))
	if (DARCIMRowid'=""){
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	s ret=ArcimDesc_"^"_OrderType_"^"_ItemCatRowid_"^"_DrgformRowid_"^"_INCIRowid_"^"_PHPrescType_"^"_BillTypeDesc
	s ret=ret_"^"_Price_$C(1)_DiscPrice_$C(1)_InsPrice_$C(1)_PatPrice
	s ret=ret_"^"_PackQty_$C(1)_BillUOMDesc_$C(1)_BillUOMRowid_$C(1)_SpecOrderPackUomRowid
	s ret=ret_"^"_RecLocStr
	s ret=ret_"^"_FormDesc_$C(1)_DrgformRowid_$C(1)_ConFac_$C(1)_PoisonRowid_$C(1)_$G(PoisonCode)
	s ret=ret_"^"_OrderDoseStr
	s ret=ret_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval_$C(1)_FormFreqWeekFlag
	s ret=ret_"^"_FormInstrDesc_$C(1)_FormInstrRowid
	s ret=ret_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
	s ret=ret_"^"_DefPriorDesc_$C(1)_DefPriorRowid_$C(1)_OrderPriorRemarks_$C(1)_OrderPriorRemarksRowId
	s ret=ret_"^"_OrderMsg_$C(1)_OrderFile1_$C(1)_OrderFile2_$C(1)_OrderFile3_$C(1)_ProcessingNotes
	s ret=ret_"^"_RealStockQty
	s ret=ret_"^"_LabSpec_$C(1)_LabExcode_$C(1)_LabItemActive
	s ret=ret_"^"_NeedSkinTest_$C(1)_SkinTestYY_$C(1)_IPNeedBillQty_$C(1)_Sensitive_$C(1)_NeedSkinTestINCI_$C(1)_SttIsCanCrossDay_$C(1)_ItemDefSkinAction_$C(1)_ARCIMDefSensitive_$C(1)_OrdDateIsCanCrossDay
	s ret=ret_"^"_InsurAdmFlag_$C(1)_DiagnosCatArcimPass_$C(1)_PreOrderDate_$c(3)_PreOrderIntervalDur_$C(1)_IsADMInsTypeDCArcim_$C(1)_limitFlag_$C(1)_InsurAdmAllowFlag_$C(1)_InsurFlag_$C(2)_InsurAlertStr_$C(2)_InsuContrastCode_$C(1)_InsuContrastDesc
	s ret=ret_"^"_MaxDurFactor_$C(1)_MaxQty_$C(1)_AlertStockQty_$C(1)_FormMaxDoseQty_$C(1)_MaxDoseQty_$C(1)_MaxDoseQtyPerDay_$C(1)_LimitDays_$C(1)_MaxDoseQtyPerOrder_$C(1)_PHCDFCQZTFlag_$C(1)_PHCDFONEFlag_$C(1)_AllowOnlyOnce_$C(1)_WarningUseQty_$C(1)_PHCDFCHKOMFlag_$C(1)_SameFreqDifferentDosesFlag_$C(1)_AdmAllowOnlyOnce
	s ret=ret_"^"_OutOrderRecLocStr
	s ret=ret_"^"_Allergy
	s ret=ret_"^"_OneOrderRecLocStr
	s ret=ret_"^"_EPDiagnosCatStr
	s ret=ret_"^"_OrderItemInValid_$C(1)_GenericName_$C(1)_SpecCheckCode_$C(1)_AlertAuditSpecialItem_$C(1)_ArcimCode_$C(1)_OrderAuthInValid_$C(1)_ASCheckStr_$c(1)_PilotCatFlag_$c(1)_IsHourItem_$c(1)_CheckArcimTypeStr_$c(1)_AllergyChildNotice_$c(1)_ARCIMShowOEMessageFlag_$c(1)_OrderDepProcNote_$c(1)_OrderSpeedFlowRate_$c(1)_OrderFlowRateUnitDr_$c(1)_OrderFlowRateUnit_$c(1)_DIDExceedReasonDR_$c(1)_MidDischargedFlag_$c(1)_IncItmHighValueFlag_$C(1)_isOwn_$C(1)_TransFlag_$C(1)_AllowOnlyOnceRepeatFlag_$C(1)_StopAfterLongOrderFlag_$C(1)_PHCDFCriticalFlag
	s ret=ret_"^"_PHCDoseStr
	s ret=ret_"^"_HolidayRecLocStr_"^"_$g(OrderFreqTimeDoseStr)_"^"_$g(OrderFreqWeekStr)
	q ret
	/*;转为JSON数据
	#dim obj As ext.util.JsonObject
	s obj = ##class(ext.util.JsonObject).%New()
	d obj.Put("idesc",ArcimDesc).Put("OrderType",OrderType).Put("OrderItemCatRowid",ItemCatRowid)
	d obj.Put("DrgformRowid",DrgformRowid).Put("InciRowid",INCIRowid).Put("OrderPHPrescType",PHPrescType)
	d obj.Put("OrderBillType",BillTypeDesc)
	d obj.Put("iretPrice",Price_$C(1)_DiscPrice_$C(1)_InsPrice_$C(1)_PatPrice)
	d obj.Put("ipackqtystr",PackQty_$C(1)_BillUOMDesc_$C(1)_BillUOMRowid)
	d obj.Put("ireclocstr",RecLocStr)
	d obj.Put("iformstr",FormDesc_$C(1)_DrgformRowid_$C(1)_ConFac_$C(1)_PoisonRowid_$C(1)_$G(PoisonCode))
	d obj.Put("idoseqtystr",OrderDoseStr)
	d obj.Put("ifrequencestr",FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval)
	d obj.Put("iinstructionstr",FormInstrDesc_$C(1)_FormInstrRowid)
	d obj.Put("idurationstr",FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor)
	d obj.Put("idefpriorstr",DefPriorDesc_$C(1)_DefPriorRowid)
	d obj.Put("iordermsg",OrderMsg_$C(1)_OrderFile1_$C(1)_OrderFile2_$C(1)_OrderFile3_$C(1)_ProcessingNotes)
	d obj.Put("realstockqty",RealStockQty)
	d obj.Put("ilab",LabSpec_$C(1)_LabExcode_$C(1)_LabItemActive)	
	d obj.Put("iskintest",NeedSkinTest_$C(1)_SkinTestYY_$C(1)_IPNeedBillQty_$C(1)_Sensitive)	
	d obj.Put("iinsurinfo",InsurAdmFlag_$C(1)_DiagnosCatArcimPass_$C(1)_PreOrderDate_$C(1)_IsADMInsTypeDCArcim_$C(1)_limitFlag_$C(1)_InsurAdmAllowFlag_$C(1)_InsurFlag_$C(2)_InsurAlertStr)	
	d obj.Put("ilimitstr",MaxDurFactor_$C(1)_MaxQty_$C(1)_AlertStockQty_$C(1)_FormMaxDoseQty_$C(1)_MaxDoseQty_$C(1)_MaxDoseQtyPerDay_$C(1)_LimitDays_$C(1)_MaxDoseQtyPerOrder)
	d obj.Put("ioutpriorreclocstr",OutOrderRecLocStr)
	d obj.Put("iallergy",Allergy).Put("ionepriorreclocstr",OneOrderRecLocStr).Put("idiagnoscatstr",EPDiagnosCatStr)
	d obj.Put("iother",OrderItemInValid_$C(1)_GenericName_$C(1)_SpecCheckCode_$C(1)_AlertAuditSpecialItem)
	s retJson=obj.Json()
	s ^tmpgry=retJson
	
	Q retJson
	*/
GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S LoopRecLocStr=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(LoopRecLocStr,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(LoopRecLocStr,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
	}
	Q DeLocID
}

ClassMethod GetEPDSYMCodeStr(EpisodeID As %String) As %String
{
	s CodeStr=""
	Q:EpisodeID="" ""
	s OrderRowId=$o(^OEORD(0,"Adm",+EpisodeID,""))
	Q:OrderRowId="" ""
	s Code=0 f  s Code=$O(^OEORDi(0,"DSYMCode",OrderRowId,Code)) Q:Code=""  d
	.i CodeStr="" s CodeStr=Code
	.e  s CodeStr=CodeStr_$C(2)_Code
	Q CodeStr
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 得到与就诊类型和费别相关的特病类别
/// Table;        DHC_DiagnosCat
/// Input:        AdmType:就诊类型("I","O","E")   InsurType:费别   MrAdmRowid:患者病历指针
/// Return:       以字符"^"分隔的特病类别指针信息串 
/// Others:
ClassMethod GetEPDiagnosCat(AdmType As %String, InsurType As %String, MrAdmRowid As %String, CurLogonHosp As %String = "") As %String
{
	i ($g(CurLogonHosp)="")&&($d(%session)) s CurLogonHosp=%session.Get("LOGON.HOSPID")
	s HospitalCode=..GetCurrentHospitalCode()
	
	;肿瘤医院暂时不控制到诊断
	if HospitalCode="YKYZLYY" Q ..GetBillTypeDiagnosCat(AdmType, InsurType,CurLogonHosp)
	s ret=""
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MrAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s DiagnosRowid=obj.Data("MRDIAICDCodeDR")
	.Q:DiagnosRowid=""
	.s DiagnosCatRowid="" for  s DiagnosCatRowid=$O(^DHCDiagnosCatI("0","Diagose",DiagnosRowid,DiagnosCatRowid))  Q:DiagnosCatRowid=""  d
	..q:'$d(^DHCDiagnosCat(DiagnosCatRowid))
	..s DCBillType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",3)
	..s DCAdmType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",2)
	..s DCType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",5)
	..s DCHosp=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",7)
	..Q:(DCHosp'=CurLogonHosp)
	..;类型=特殊病,就诊类型,费别
	..Q:(DCType'="S")!(DCAdmType'=AdmType)!(DCBillType'=InsurType)
	..i ret="" s ret=DiagnosCatRowid
	..e  s ret=ret_"^"_DiagnosCatRowid
	Q ret
}

ClassMethod GetEPDiagnosCatStr(AdmType As %String, InsurType As %String, MrAdmRowid As %String) As %String
{
	s ret=""
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MrAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s DiagnosRowid=obj.Data("MRDIAICDCodeDR")
	.Q:DiagnosRowid=""
	.s DiagnosCatRowid="" for  s DiagnosCatRowid=$O(^DHCDiagnosCatI("0","Diagose",DiagnosRowid,DiagnosCatRowid))  Q:DiagnosCatRowid=""  d
	..q:'$d(^DHCDiagnosCat(DiagnosCatRowid))
	..s DCDesc=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",1)
	..s DCAdmType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",2)
	..s DCBillType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",3)
	..s DCType=$P(^DHCDiagnosCat(DiagnosCatRowid),"^",5)
	..;类型=特殊病,就诊类型,费别
	..Q:(DCType'="S")!(DCAdmType'=AdmType)!(DCBillType'=InsurType)
	..i ret="" s ret=DiagnosCatRowid_$C(1)_DCDesc
	..e  s ret=ret_$C(2)_DiagnosCatRowid_$C(1)_DCDesc
	Q ret
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:; 得到检验医嘱项的外部代码
/// Table:        ARC_ItmMast
/// Input:        ArcimRowid:医嘱项指针
/// Return:       检验医嘱项的外部代码 
/// Others:
ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	s arcsub=$p(ArcimRowid,"||",2)
	q:arcsub="" ""
	s ExCode=""
	s chl=0 f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.q:(fromd'="")&(fromd>+$h)
	.q:(tod'="")&(tod<+$h)
	.s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	q ExCode
}

ClassMethod GetFreqDispTimeStr(PHCFRrow As %String) As %String
{
	s ret=""
	q:(PHCFRrow="") ret
	s childsub=0  f  s childsub=$O(^PHCFR(PHCFRrow,"OPDT",childsub)) Q:childsub=""  d
	.s time=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",1)
	.s timestr=..%ZT(time,3)
	.s week=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",2)
	.s DispTime=time_$C(2)_week
	.i ret="" s ret=DispTime
	.e  s ret=ret_$C(1)_DispTime
	Q ret
}

/// 得到住院频次分发时间
ClassMethod GetIPFreqDispTimeStr(PHCFRrow As %String) As %String
{
	n IPFreqDispTimeArr
	q:PHCFRrow="" ""
	s weekflag=$P($g(^PHCFR(+$g(PHCFRrow),"DHC")),"^",1)
	s ret=""
	if weekflag=1 {
		s childsub=0  f  s childsub=$O(^PHCFR(PHCFRrow,"OPDT",childsub)) Q:childsub=""  d
		.s time=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",1)
		.s timestr=..%ZT(time,2)
		.s week=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",2)
		.s DispTime=timestr_" "_$p($g(^CT("DOW",1,week)),"^",1)
		.//i ret="" s ret=DispTime
		.//e  s ret=ret_","_DispTime
		.s IPFreqDispTimeArr(time)=DispTime
	}else{
		s childsub=0  f  s childsub=$O(^PHCFR(PHCFRrow,"DT",childsub)) Q:childsub=""  d
		.s time=$p(^PHCFR(PHCFRrow,"DT",childsub),"^",1)
		.s timestr=..%ZT(time,2)
		.s DispTime=timestr
		.//i ret="" s ret=DispTime
		.//e  s ret=ret_","_DispTime
		.s IPFreqDispTimeArr(time)=DispTime
	}
	s DispTime="" for {
		s DispTime=$O(IPFreqDispTimeArr(DispTime))
		Q:DispTime=""
		i ret="" s ret=IPFreqDispTimeArr(DispTime)
		e  s ret=ret_","_IPFreqDispTimeArr(DispTime)
	}
	Q ret
}

ClassMethod GetInstrGroupCode(InstrRowid As %String) As %String
{
	n (InstrRowid)
	Q:InstrRowid="" ""
	s InstrCode=$P($g(^PHCIN(InstrRowid)),"^",1)
	s len=$length(InstrCode,".")
	Q:len=2 $P(InstrCode,".",1)
	Q ""
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 根据就诊指针取医保号
/// Table:        
/// Input:        ArcimRowid:医嘱项指针
/// Return:       检验医嘱项的外部代码 
/// Others:       宁波明州医院用
ClassMethod GetInsuNobyAdmDr(strAdmDr) As %String
{
	s INADMInsuId=""
	s InsAdmDr="0"
	s InsAdmDr=$o(^DHCINADM("0","ADM",strAdmDr,InsAdmDr))
	i InsAdmDr'=""  d
	.s mCurrRowInsAdm=$g(^DHCINADM(InsAdmDr))
	.s INADMInsuId=$p(mCurrRowInsAdm,"^",2)
	q INADMInsuId
}

/// tanjishan
/// 202020618
/// 获取医保标识费别串
/// w ##Class(web.DHCDocOrderCommon).GetInsurBillStr("I")
ClassMethod GetInsurBillStr(PAAdmType As %String) As %String
{
	n (PAAdmType)
	s InsurBillStr=""
	s BillTypeID=""
	for {
		s BillTypeID=$O(^PAC("ADMREA",BillTypeID))
		q:(BillTypeID="")
		if (..GetInsurFlag(BillTypeID,PAAdmType)=0){
			continue
		}
		if (InsurBillStr=""){
			s InsurBillStr=BillTypeID
		}else{
			s InsurBillStr=InsurBillStr_"^"_BillTypeID
		}		
	}
	q InsurBillStr
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 根据费别的RowID,得到医保的标志
/// Table:        PAC_AdmReason
/// Input:        BillType:费别
/// Return:       医保标志(0代表非医保) 
/// Others;
ClassMethod GetInsurFlag(BillType As %String, PAAdmType As %String = "") As %String
{
	Q:(BillType="") 0
	s InsurFlag=0
	s HospitalCode=..GetCurrentHospitalCode()
	s AdmSource=$p($g(^PAC("ADMREA",BillType)),"^",9)
	s NationalCode=$p($g(^PAC("ADMREA",BillType)),"^",5)
	if (HospitalCode="BJXHYY") {
		if PAAdmType="I" {
			s InsurFlag=$CASE(NationalCode,"01":1,"02":1,:0)
		}else{
			if AdmSource>0 s InsurFlag=1
		}
	}else{
		if AdmSource>0 s InsurFlag=1
	}
	
	Q InsurFlag
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:; 得到检验医嘱项定义的标本,根据医院设置可以从LabTrak或者Medtrak中去标本
/// Table:        ARC_ItmMast,ARC_ItemSpecimen
/// Input:        ArcimRowid:医嘱项指针
/// Return:       检验标本
/// Others:       w ##class(web.DHCDocOrderCommon).GetLabSpec("3950||1",2)
ClassMethod GetLabSpec(ArcimRowid As %String, HospitalId As %String = "", langid As %String = "") As %String
{
	s ^Temp("wanghc","ArcimRowid")=ArcimRowid
	/*
	s HospitalCode=..GetCurrentHospitalCode()
	i HospitalCode="SCDXHXYY" {
		Q ..GetLabSpecLocal(ArcimRowid)
	}else{
		s retno=""
		s excode=..GetExCode(ArcimRowid)
		q:excode="" ""
		Q ..GetSpecimenByTestset(excode)
	}
	*/
	s retno=""
	s excode=..GetExCode(ArcimRowid)
	if excode="" Q ..GetLabSpecLocal(ArcimRowid,HospitalId)
	Q ..GetSpecimenByTestset(excode,HospitalId,langid)
		
	q:'$d(^TTAB("TS",excode)) ""
	s contdr=$o(^TTAB("TS",excode,"SC",""))
	;q:contdr="" ""
	i contdr="" d
	.s specdr=$o(^TTAB("TS",excode,1,""))
	e  d
	.s specdr=$o(^TTAB("TS",excode,"SC",contdr,""))
	q:specdr="" ""  
	s specdesc=$p($G(^TTAB("SPEC",specdr)),"\",1)
	q specdesc
}

ClassMethod GetLabSpecLocal(ArcimRowid As %String, HospitalId As %String = "") As %String
{
	;w ##class(web.DHCDocOrderCommon).GetLabSpecLocal("3309||1")
	s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
	s num=0,ret=""
	s child=0  f  s child=$O(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),"SPEC",child)) Q:(child="")  d
	.s specdr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),"SPEC",child),"^",1)
	.i $d(^DHCLISBSVersion(1)) s specdesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specdr,$g(HospitalCode)),$c(2),2)
	.e  s specdesc=$P(^TTAB("SPEC",specdr),"\",1)
	.s default=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),"SPEC",child),"^",2)
	.s num=num+1
	.i default="Y" d 
	..s data=specdr_$c(3)_specdesc_$c(3)_""_$c(3)_""_$c(3)_"Y"
	.e  s data=specdr_$c(3)_specdesc_$c(3)_""_$c(3)_""_$c(3)_"N"
	.s PLIST(num)=data
	For i=1:1:num {
	 	i ret="" s ret=PLIST(i)
		e  s ret=ret_$c(2)_PLIST(i)
 }
	q ret
}

ClassMethod GetLocDesc(LocRowid As %String) As %String
{
	Q:LocRowid="" ""
	Set langid=..%LanguageID()
	s LocDesc=$P($g(^CTLOC(LocRowid)),"^",2)
	s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	s LocDesc1=$P(LocDesc,"-",2)
	i LocDesc1'="" s LocDesc=LocDesc1
	Q LocDesc
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:: 根据接收科室定义得到医嘱项接收科室,优先级顺序为:医嘱项,子类,大类
/// Table:        RC_ItmRecLoc,ARC_ItemCatRecLoc,OEC_OrdCatRecLoc
/// Input:        EpLoc:科室指针,Arcim:医嘱项指针,OpenForAllHosp:跨院标志 1:可以跨院
/// Return:       以字符"^"分隔的接收科室指针字符串
/// Others:       
ClassMethod GetLocRecLoc(EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "", OrdDate As %String = "", admType As %String = "") As %String
{
	n ret
	s ret=""
	s ret=..GetLocRecLocByItem(EpLoc,Arcim,OpenForAllHosp,admType)
	Q:ret'="" ret
	;
	s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
	Q:ItemCat="" ""
	s ret=..GetLocRecLocByItemCat(EpLoc,ItemCat,OpenForAllHosp,OrdDate,admType)
	Q:ret'="" ret

	s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
	Q:OrderCat="" ""
	s ret=..GetLocRecLocByCat(EpLoc,OrderCat,OpenForAllHosp,OrdDate,admType)

	Q ret
}

ClassMethod GetLocRecLocByCat(EpLoc As %String, OrderCat As %String, OpenForAllHosp As %String = "", OrdDateStr As %String = "", admType As %String = "") As %String
{
	n (EpLoc,OrderCat,OpenForAllHosp,OrdDateStr,admType,%session)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	i OrdDateStr'=""{
		s OrdTime=$p(OrdDateStr," ",2)
		i OrdTime'=""{
			s ToTime=..%ZTH(OrdTime)
		}
	}
	if EpLoc'="" {
		s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	}else{
		s HospitalID=%session.Get("LOGON.HOSPID")
	}
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub=$O(^OEC("ORCAT",OrderCat,"RL",sub)) Q:(sub="")  d
	. s OrdLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 2)
	. Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 5)
	. s TimeTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 6)
	. s DateFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 8)
	. s DateTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 9)
	. Q:(DateFrom'="")&&(DateFrom>Today)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 4)
	. s RecLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 3)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=..GetLocDesc(RecLoc)  
	. s OrderPriority=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^",10)
	. s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	. s ClinicType=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 12)
	. Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	. i OrderPriority="" d
	. . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	. . e  d
	. . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	. . i OrdLoc'="" d
	. . . i Default="Y" d
	. . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	. . . e  d 
	. . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	. . e  d
	. . . i Default="Y" d
	. . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	. . . e  d 
	. . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }

	 Q ret
}

ClassMethod GetLocRecLocByItem(EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "", admType As %String = "") As %String
{
	n (EpLoc,Arcim,OpenForAllHosp,admType,%session)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	
	if EpLoc'="" {
		s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	}else{
		s HospitalID=%session.Get("LOGON.HOSPID")
	}
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub= $O(^ARCRL(+Arcim,sub))  Q:(sub="")  d 
	. s OrdLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 1)
	. Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 5)
	. s TimeTo=$P($g(^ARCRL(+Arcim,sub)),"^", 6)
	. s DateFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 8)
	. s DateTo=$P($g(^ARCRL(+Arcim,sub)),"^", 9)
	. Q:(DateFrom'="")&&(DateFrom>Today)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^ARCRL(+Arcim,sub)),"^", 4)
	. s RecLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 2)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=..GetLocDesc(RecLoc)  
	. s OrderPriority=$P($g(^ARCRL(+Arcim,sub)),"^", 10)
	
	. s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	. s ClinicType=$P($g(^ARCRL(+Arcim,sub)),"^", 12)
	. Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	 . i OrderPriority="" d
	 . . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . e  d
	 . . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . i OrdLoc'="" d
	 . . . i Default="Y" d
	 . . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	 . . e  d
	 . . . i Default="Y" d
	 . . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 s priority=0
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }

	 Q ret
}

ClassMethod GetLocRecLocByItemCat(EpLoc As %String, ItemCat As %String, OpenForAllHosp As %String = "", OrdDateStr As %String = "", admType As %String = "") As %String
{
	n (EpLoc,ItemCat,OpenForAllHosp,OrdDateStr,admType,%session)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	i OrdDateStr'=""{
		s OrdTime=$p(OrdDateStr," ",2)
		i OrdTime'=""{
			s ToTime=..%ZTH(OrdTime)
		}
	}
	if EpLoc'="" {
		s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	}else{
		s HospitalID=%session.Get("LOGON.HOSPID")
	}
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	 
	 s rl=0  f  s rl=$O(^ARC("IC",ItemCat,"RL",rl)) q:(rl="")  d
	 . s OrdLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",2)
	 . Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	 . s TimeFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",5)
	 . s TimeTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",6)
	 . s DateFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",8)
	 . s DateTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",9)
	 . Q:(DateFrom'="")&&(DateFrom>Today)
	 . Q:(DateTo'="")&&(DateTo<Today)
	 . Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	 . s RecLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",3)
	 . Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	 . s Default=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",4)
	 . s RecLocDesc=..GetLocDesc(RecLoc)
	 . s OrderPriority=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",10)
	 . s RecLocHospitalID=$P(^CTLOC(RecLoc),"^",22)
	 . Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	 . s ClinicType=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",12)
	 . Q:((admType'="")&&(ClinicType'="")&&(admType'=ClinicType))
	 .; 
	 . i OrderPriority="" d
	 . . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . e  d
	 . . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . i OrdLoc'="" d
	 . . . i Default="Y" d
	 . . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	 . . e  d
	 . . . i Default="Y" d
	 . . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 s priority=0
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			 	s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }
	 Q ret
}

/// Creator:      周志强
/// CreatDate:    2009.04.14
/// Description:; 查询身体部位,供医嘱录入时做为备注选择
/// Table:       
/// Input:        
/// Output:         
/// Return:       以"^"分隔的字符串:RowId+$C(1)+代码+$C(1)+描述
ClassMethod GetMRCBodyPart(type As %String = "") As %String
{
	s ret=""
	s rowid=0 f  s rowid=$o(^MRC("BODP",rowid)) q:rowid=""  d
	.s code=$p($g(^MRC("BODP",rowid)),"^",1)
	.s desc=$p($g(^MRC("BODP",rowid)),"^",2)
	.i type="JSON" d
	..i ret="" s ret=rowid_":"_desc
	..e  s ret=ret_";"_rowid_":"_desc
	.e  d
	..i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	..e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc	
	q ret
}

/*
/// 该方法已弃用，请使用药房：科室药品信息维护->住院按整包装单位发药
ClassMethod GetNeedPackQtyFlag(arcim, LocRowId, ItemCatRowId, HospitalID As %String = "") As %String
{
	s ItemCatStr=..%GetConfig1("IPRecLocSubCatNeedPackQty",LocRowId,HospitalID)
	i (ItemCatStr'="")&(ItemCatRowId'="") {
		Q:("^"_ItemCatStr_"^")[("^"_ItemCatRowId_"^") "1"
	}else{
		Q:LocRowId="" 0
		s NeedPackQtyFlag=0
		s ItemNeedPackQtyIndex=0
	    for {
		    s ItemNeedPackQtyIndex=$o(^DHCDocConfig("IPRecLocArcItemNeedPackQty",LocRowId,"Item",ItemNeedPackQtyIndex)) Q:(ItemNeedPackQtyIndex="")||(NeedPackQtyFlag=1)
		    if (arcim=$g(^DHCDocConfig("IPRecLocArcItemNeedPackQty",LocRowId,"Item",ItemNeedPackQtyIndex))) s NeedPackQtyFlag=1
		    
		}
		Q NeedPackQtyFlag
	}
	Q 0
}
*/
ClassMethod GetOneOrderPriorQty(FreqRowid As %String, StartTime As %String) As %String
{
	s n=0,FirstDayCount=0,SecondDayCount=0
	S SttTime=..%ZTH(StartTime)
	;s DispTime=..%ZTH("12:00")
	s DispTime=$G(^DHCCLSet("Exec","DateStartTime"))
	Q:DispTime="" 0
	s sub=0 f  s sub=$O(^PHCFR(FreqRowid,"DT",sub))  Q:(sub="")  d
	.s n=n+1
	.s ExeTime=^PHCFR(FreqRowid,"DT",sub)
	.i (SttTime<ExeTime)!(SttTime=ExeTime) s FirstDayCount=FirstDayCount+1
	.i (DispTime>ExeTime) s SecondDayCount=SecondDayCount+1
	Q:n<1 0
	s Qty=FirstDayCount+SecondDayCount-n
	Q Qty
}

ClassMethod GetLocOneOrderRecloc(EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n (EpLoc,Arcim,OpenForAllHosp,ret,%session)
	s ret=""
	Q:Arcim="" ""
	s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	s LocNoInOneOrderCF=..%GetConfig("LocNoInOneOrderCF",HospitalID)
	if LocNoInOneOrderCF'="" {
		s LocNoInOneOrderCF="^"_LocNoInOneOrderCF_"^"
		if LocNoInOneOrderCF[("^"_EpLoc_"^") Q ret
	}
	s RecLocStr=..%GetConfig1("OneOrderRecLoc",ItemCatDR,HospitalID)
	if RecLocStr="" {
		s RecLocStr=..%GetConfig("OneOrderDefaultRecLoc",HospitalID)
	}
	i RecLocStr'="" {
		s RecLocCount=$LENGTH(RecLocStr,"^")
	    F i=1:1:RecLocCount {
		    s RecLocRowid=$P(RecLocStr,"^",i)
			continue:+RecLocRowid=0
			continue:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLocRowid)
			s RecLocHospitalID=$P($g(^CTLOC(RecLocRowid)),"^",22)
			continue:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)

		    s RecLocDesc=..GetLocDesc(RecLocRowid)
		    i ret=""  s ret=RecLocRowid_$C(1)_RecLocDesc_$C(1)_"Y"_$C(1)_""
		    e  s ret=ret_$C(2)_RecLocRowid_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_""
	    }
	}
	Q ret
}

ClassMethod GetOneOrderRecloc(EpisodeID As %String, Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n (EpisodeID,Arcim,OpenForAllHosp,ret)
	s ^Tempscl("GetLocOneOrderRecloc")=EpisodeID_","_Arcim_","_OpenForAllHosp
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	s admLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	if admType="I" do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	.s LinkLoc=..GetLocLinkLocation(EpLoc)
	.if ($l(LinkLoc,"^")>1) do
	..s ExistFlag=..CheckIsExistWardEpLoc(EpLoc,Arcim,OpenForAllHosp)
	..if ExistFlag=0 s EpLoc=admLoc
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s ret=..GetLocOneOrderRecloc(EpLoc,Arcim,OpenForAllHosp)
	Q ret
}

/*
ClassMethod GetOrderAction() As %String
{
	s ret=""
	s rowid=0 f  s rowid=$o(^OEC("ACT",rowid)) q:rowid=""  d
	.s code=$p($g(^OEC("ACT",rowid)),"^",1)
	.s desc=$p($g(^OEC("ACT",rowid)),"^",2)
	.i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	.e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	q ret
}
*/
ClassMethod GetOrderAction(type As %String = "") As %String
{
	s ret=""
	Set langid=..%LanguageID()
	s rowid=0 f  s rowid=$o(^OEC("ACT",rowid)) q:rowid=""  d
	.s code=$p($g(^OEC("ACT",rowid)),"^",1)
	.s desc=$p($g(^OEC("ACT",rowid)),"^",2)
	.s desc =##class(User.OECAction).GetTranByDesc("ACTDesc",desc,langid)
	.s DateFrom=$p($g(^OEC("ACT",rowid)),"^",3)
	.Q:(DateFrom'="")&&(DateFrom>+$h)
	.s DateTo=$p($g(^OEC("ACT",rowid)),"^",4)
	.Q:(DateTo'="")&&(DateTo<=..%SysDate())
	.i type="JSON" d
	..i ret="" s ret=rowid_":"_desc
	..e  s ret=ret_";"_rowid_":"_desc
	.e  d
	..i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	..e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	
	q ret
}

ClassMethod GetOrderAdmLimit(EpisodeID As %String, ARCIMRowid As %String, InsType As %String) As %String
{
	s InsuAdmType=""
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	if admType="I" d
	.s InsuAdmRowid=$O(^DHCINADM("0","ADM",EpisodeID,0))
	.i InsuAdmRowid'="" s InsuAdmType=$P(^DHCINADM(InsuAdmRowid),"^",18)
	e  d
	.s InsuAdmTypeInfo=##Class(web.INSUDicDataCtl).QueryByCodeNB("AdmReasonToInsuType",InsType)
	.i InsuAdmTypeInfo'="" s InsuAdmType=$P(InsuAdmTypeInfo,"^",4)
	Q:InsuAdmType="" 0
	s ExecuDate=""
	s sttdate=..%SysDate()
	q:'$d(^DHCOLT(0,"ARCIM",ARCIMRowid)) 0
	;
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA
	;
	s TarItemInsuInfo=""
	f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",ARCIMRowid,"Z",ExecuDate)) q:ExecuDate=""  d
	.q:ExecuDate>sttdate
	.s OLT=""
	.;找到计费项
	.f  s OLT=$o(^DHCOLT(0,"ARCIM",ARCIMRowid,"Z",ExecuDate,OLT)) q:OLT=""  d
	..s EndDate=$p(^DHCOLT(OLT),"^",5)
	..i EndDate="" s EndDate=..%SysDate()+1
	..q:EndDate<sttdate
	..s Itm=$p(^DHCOLT(OLT),"^",2)
 ..s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(Itm,InsuAdmType,"")
	ZN CurrentNS
	Q:TarItemInsuInfo="" 0
	
 s DrugLimitFlg=$p(TarItemInsuInfo,"^",27)      ;取门诊限用标志1为限门诊用药
	Q DrugLimitFlg
}

ClassMethod GetOrderName(OrderItemRowid As %String) As %String
{
	n (OrderItemRowid)
	Q:OrderItemRowid'="" ""
	s arcim=$P($G(^OEORD(+OrderItemRowid,"I",$P(OrderItemRowid,"||",2),1)),"^",2)
	Q:arcim="" ""
	s arcimdesc=$P(^ARCIM(+arcim,$P(aricm,"||",2),1),"^",2)
	Q arcimdesc
}

/// modified by xp,2014-05-30,增加协议包装处理 OrderPackUOMRowid
ClassMethod GetOrderPrice(PatType As %String, InsType As %String, ArcimRowid As %String, SttDate As %String, PriorRowid As %String, InstrRowid As %String, LinkTo As %String, OEPrice As %String, RecLoc As %String, PAADMRegConDisDR As %String = "", OrderPackUOMRowid As %String = "", ExpStrIn As %String = "") As %String
{
	s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,RecLoc)
	s CurrDate=..%SysDate()
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ArcimRowid, CurrDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,OrderPackUOMRowid,ExpStrIn)
	//s Price=$P(retPrice,"^",1)
	Q retPrice
}

/// creator:郭荣勇
/// date:2015-03-05
/// desc:根据医嘱Rowid,得到医嘱单价
/// input: OEORIRowId 医嘱Rowid,OEORERowId 医嘱的某条执行记录Rowid(主要考虑住院不同执行记录按批次单价不一样的情况,其他情况可以为空)
/// output:医嘱单价
ClassMethod GetOEORIPrice(OEORIRowId As %String, OEORERowId As %String = "") As %String
{
	n (OEORIRowId,OEORERowId,%session)
	s par=+OEORIRowId
	s sub=$p(OEORIRowId,"||",2)
	s AdmId=$p($g(^OEORD(par)),"^",1)
	s EpissubtypeDR=$p(^PAADM(AdmId,1),"^",6)
	s AdmReasonDR=$p(^PAADM(AdmId,1),"^",7)
	
	s ArcimId=$p($g(^OEORD(par,"I",sub,1)),"^",2)
	s SttDate=$p($g(^OEORD(par,"I",sub,1)),"^",9)
	s PriorityDR=$p($g(^OEORD(par,"I",sub,1)),"^",8)
	s InstrDR=$p($g(^OEORD(par,"I",sub,2)),"^",7)
	s OEORIRecDepDR=$p($g(^OEORD(par,"I",sub,3)),"^",6)
	s LinkTo=""
	s OEORIPrice=$p($g(^OEORD(par,"I",sub,3)),"^",25)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmId,"DHC")),"^",25)
	s ProtocolPackUOMDR=$p($g(^OEORD(par,"I",sub,"DHC")),"^",13)
	s admloc=$p(^PAADM(AdmId),"^",4)
	s AdmLocHospDr=$p($g(^CTLOC(admloc)),"^",22)
	s GetPriceExpStr=par_"||"_sub_"^"_OEORERowId_"^"_AdmId_"^"_OEORIRecDepDR_"^"_AdmLocHospDr
	s retPrice=..GetOrderPrice(EpissubtypeDR,AdmReasonDR,ArcimId,SttDate,PriorityDR,InstrDR,LinkTo,OEORIPrice,OEORIRecDepDR,PAADMRegConDisDR,ProtocolPackUOMDR,GetPriceExpStr)
	
	Q retPrice
}

/*
ClassMethod GetOrderPrior(EpisodeType As %String = "") As %String
{
	Kill ^TMPGetOrderPrior($J) ;排序global
	s ret=""
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s code=$p($g(^OECPR(rowid)),"^",1)
	.s priority=$p($g(^OECPR(rowid)),"^",3)
	.;为0就不显示?因为有些医嘱类型有些医院用不上
	.Q:priority=0
	.Q:((EpisodeType="O")||(EpisodeType="E"))&&((code="OMST")||(code="S")||(code="OUT")||(code="STAT")||(code="PRN")||(code="ONE"))
	.s desc=$p($g(^OECPR(rowid)),"^",2)
	.s Priority=$p($g(^OECPR(rowid)),"^",3)
	.i Priority="" s Priority=1
	.s ^TMPGetOrderPrior($J,Priority,rowid)=rowid_$C(1)_code_$C(1)_desc
	.;i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	.;e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	;排序
	s PriorityLoop="" for  s PriorityLoop=$O(^TMPGetOrderPrior($J,PriorityLoop)) Q:PriorityLoop=""  d
	.s Loop=0 for  s Loop=$O(^TMPGetOrderPrior($J,PriorityLoop,Loop)) Q:Loop=""  d
	..i ret="" s ret=$g(^TMPGetOrderPrior($J,PriorityLoop,Loop))
	..e  s ret=ret_"^"_$g(^TMPGetOrderPrior($J,PriorityLoop,Loop))
	
	q ret
}
*/
/// Creator:      周志强
/// CreatDate:    2009.09.27
/// Description:: 得到不同就诊类型下的医嘱类型,门诊一般为临时或即刻
/// Table:        
/// Input:        EpisodeType:就诊类型代码
/// Output:         
/// Return:       以"^"分隔的字符串:Rowid+$C(1)+代码+$C(1)+描述
ClassMethod GetOrderPrior(EpisodeID As %String = "", Type As %String = "", CTLOCLongon As %String = "", langid As %String = "", UserID = "", GroupID = "") As %String
{
	s ret=""
	s PriorJsonStr=##class(DHCDoc.Order.Common).GetOrderPriorJSON(EpisodeID,CTLOCLongon,UserID,GroupID,"","",langid)
	s PriorJson=[].%FromJSON(PriorJsonStr)
	for i=1:1:PriorJson.%Size(){
		s PriorObj=PriorJson.%Get(i-1)
		s OrderPriorRowid=PriorObj.rowid
		s OrderPriorCode=PriorObj.code
		s OrderPrior=PriorObj.text
		if Type="JSON"{
			i ret="" s ret=OrderPriorRowid_":"_OrderPrior
			e  s ret=ret_";"_OrderPriorRowid_":"_OrderPrior
		}else{
			i ret="" s ret=OrderPriorRowid_$C(1)_OrderPriorCode_$C(1)_OrderPrior
			e  s ret=ret_"^"_OrderPriorRowid_$C(1)_OrderPriorCode_$C(1)_OrderPrior
		}
	}
	Q ret
}

/// Creator:      周志强
/// CreatDate:    2009.04.14
/// Description:: 得到医嘱阶段的定义,以后可以走设置
/// Table:       
/// Input:        
/// Output:         
/// Return:       以"^"分隔的字符串:+代码+$C(1)+描述
ClassMethod GetOrderStage(type As %String = "") As %String
{
	s ret=""
	if (type="JSON"){
		s ret="SQ:"_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术前")_";"
		s ret=ret_"SZ:"_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术中")_";"
		s ret=ret_"SH:"_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术后")_";"
		s ret=ret_"CZ:"_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","产中")
	}else{
		s ret="SQ"_$C(1)_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术前")
		s ret=ret_"^"_"SZ"_$C(1)_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术中")
		s ret=ret_"^"_"SH"_$C(1)_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","术后")
		s ret=ret_"^"_"CZ"_$C(1)_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","产中")
	}
	q ret
}

ClassMethod GetOrderStageDesc(Code As %String = "") As %String
{
	n (Code,%session)
	q:Code="" ""
	s Desc=""
	s OrderStageStr=##class(web.DHCDocOrderCommon).GetOrderStage("")
	s LenR=$L(OrderStageStr,"^")
	s JNO=0
	for J=1:1:LenR{
		s SUStr=$P(OrderStageStr,"^",J)
		s SRowID=$P(SUStr,$C(1),1)
		Continue:(SRowID="")||(SRowID'=Code)
		s Desc=$P(SUStr,$C(1),2)
		
	}
	q Desc
}

/// Creator:      谭吉善
/// CreatDate:    2018.03.29
/// Description:: 出院带药接收科室也必须判断院区
/// Table:        
/// Input:        
/// Output:         
/// Return:       接收科室字符串
/// Other:        w ##Class(web.DHCDocOrderCommon).GetLocOutOrderRecloc(132,"11791||1",0)
ClassMethod GetLocOutOrderRecloc(EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n (EpLoc,Arcim,OpenForAllHosp,ret,%session)
	s ret=""
	Q:Arcim="" ""
	s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	s LocNoInOutOrderCF=..%GetConfig("LocNoInOutOrderCF",HospitalID)
	if LocNoInOutOrderCF'="" {
		s LocNoInOutOrderCF="^"_LocNoInOutOrderCF_"^"
		if LocNoInOutOrderCF[("^"_EpLoc_"^") Q ret
	}
	s RecLocStr=..%GetConfig1("OutOrderRecLoc",ItemCatDR,HospitalID)
	if RecLocStr="" {
		s RecLocStr=..%GetConfig("OutOrderDefaultRecLoc",HospitalID)
		i +RecLocStr=0 s RecLocStr=""
	}
	i RecLocStr'="" {
		s RecLocCount=$LENGTH(RecLocStr,"^")
	    F i=1:1:RecLocCount {
		    S RecLocRowid=$P(RecLocStr,"^",i)
		    continue:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLocRowid)
		    s RecLocHospitalID=$P($g(^CTLOC(RecLocRowid)),"^",22)
			continue:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
		    s RecLocDesc=..GetLocDesc(RecLocRowid)
		    i ret=""  s ret=RecLocRowid_$C(1)_RecLocDesc_$C(1)_"Y"_$C(1)_""
		    e  s ret=ret_$C(2)_RecLocRowid_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_""
	    }
	}
	Q ret
}

/// Creator:      周志强
/// CreatDate:    不详
/// Description:: 首先判断是否此科室在不走此规则,否则去医生站设置里的的接收科室定义
/// Table:        
/// Input:        
/// Output:         
/// Return:       接收科室字符串
/// Other:        w ##Class(web.DHCDocOrderCommon).GetOutOrderRecloc(1,"1||1")
ClassMethod GetOutOrderRecloc(EpisodeID As %String, Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n (EpisodeID,Arcim,OpenForAllHosp,ret)
	
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	s admLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	if admType="I" do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	.s LinkLoc=..GetLocLinkLocation(EpLoc)
	.if ($l(LinkLoc,"^")>1) do
	..s ExistFlag=..CheckIsExistWardEpLoc(EpLoc,Arcim,OpenForAllHosp)
	..if ExistFlag=0 s EpLoc=admLoc
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s ret=..GetLocOutOrderRecloc(EpLoc,Arcim,OpenForAllHosp)
	q ret
}

/// Creator:      周志强
/// CreatDate:    2009.02.20
/// Description:  根据子类取得相应的处方类别
/// Table:        
/// Input:        ItemCatRowid:医嘱子类指针
/// Return:       处方类别代码:1:西药,2:中成药3:草药4:有频次的处置治疗5:精神二类药
/// log:          2020.11.25添加ArcimRowid，用于扩展处方类型代码4，担心GetPHPrescTypeByItem无法正确返回草药类型，所以在原方法基础上修改
ClassMethod GetPHPrescType(ItemCatRowid As %String, CurLogonHosp As %String = "", ArcimRowid As %String = "") As %String
{
	n (ItemCatRowid, CurLogonHosp,ArcimRowid,%session)
	s:(ArcimRowid'="")&&(ItemCatRowid="") ItemCatRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	Q:ItemCatRowid="" ""
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s ItemType=""
	;草药
	s CNMedItemCat=..GetCNMedItemCatStr(CurLogonHosp)
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	;西药
	s MedItemCat=..%GetConfig("MedItemCat",CurLogonHosp)
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	;中成药
	s CPMedItemCat=..%GetConfig("CPMedItemCat",CurLogonHosp)
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	s FreqItemCat=..%GetConfig("FrequencedItemCat",CurLogonHosp)
	i "^"_FreqItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="4"
	if (ArcimRowid'=""){
		s AllowLDAInputFreq=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",42)
		i AllowLDAInputFreq="Y" s ItemType="4"
	}
	;精神二类药
	s CNMedItemCat=..%GetConfig("LimitMedItemCat",CurLogonHosp)
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="5"
	Q ItemType
}

/// Creator:      郭荣勇
/// CreatDate:    2016.08.11
/// Description:  根据医嘱项取得相应的处方类别
/// Table:        
/// Input:        ArcimRowid:医嘱项指针
/// Return:      处方类别代码:1:西药,2:中成药3:草药4:有频次的处置治疗5:精神二类药6:精神一类药7:抗生素8:毒麻
/// Others:       
ClassMethod GetPHPrescTypeByItem(ArcimRowid As %String, CurLogonHosp As %String = "") As %String
{
	n (ArcimRowid,CurLogonHosp,%session)
	s ^Tempscl("GetPHPrescTypeByItem")=ArcimRowid
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s ItemType=""
	Q:ArcimRowid="" ItemType
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	;草药
	s CNMedItemCat=..GetCNMedItemCatStr(CurLogonHosp)
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	;西药
	s MedItemCat=..%GetConfig("MedItemCat",CurLogonHosp)
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	;中成药
	s CPMedItemCat=..%GetConfig("CPMedItemCat",CurLogonHosp)
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	;可以录入频次
	s FreqItemCat=..%GetConfig("FrequencedItemCat",CurLogonHosp)
	i "^"_FreqItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="4"
	s AllowLDAInputFreq=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9)),"^",42)
	i AllowLDAInputFreq="Y" s ItemType="4"
	;精神二类药
	s CNMedItemCat=..%GetConfig("LimitMedItemCat",CurLogonHosp)
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="5"
	
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
	i PoisonRowid'="" {
		s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		;精神一类
		if PoisonCode="J1" s ItemType="6"
		;精神二类
		if PoisonCode="J2" s ItemType="5"
		;抗菌素,包含KSS即为抗菌素
		if PoisonCode["KSS" s ItemType="7"
		;毒麻、毒性、麻醉
		if (PoisonCode="DM")||(PoisonCode="DX")||(PoisonCode="MZ") s ItemType="8"
	}	
	Q ItemType
}

ClassMethod GetPatientAddress(PapmiRowid As %String) As %String
{
	;&SQL(select PAPER_StNameLine1,PAPER_StName into :PatientCompany1,:PatientCompany from pa_person where paper_rowid=1)
	s a=$g(^PAPER(PapmiRowid,"PER","ADD",1))
	;s a=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
	s b=$l(a,2)
	q $ZCVT(a,"O","JS")
	;Q PatientCompany
}

ClassMethod GetIPWardIDByLoc(loc As %String) As %String
{
	s myWardID=""
	Q:loc="" myWardID
	s myEpLoc=$o(^CTLOC(loc,"LINK",0,"Loc",0))
	if myEpLoc'="" {
		s myWardID=$o(^PAWARD(0,"WARD_LocationDR",myEpLoc,0))
	}
	
	Q myWardID
}

/// Creator:      周志强
/// CreatDate:    2009.05.26
/// Description:  开医嘱时根据医嘱和病人就诊取得接受科室,如果药品被锁定也不能使用
/// Table:        CT_Loc,Arc_ItmCatRecloc,OEC_OrderCatRecloc,Arc_ItmRecloc,inc_itmloc
/// Input:        EpisodeID:就诊指针,Arcim:医嘱项指针,OpenForAllHosp:跨院  1:允许  其他:不允许
/// OutPut:		  接受科室字符串
/// Others:        
ClassMethod GetRecloc(EpisodeID As %String, Arcim As %String, OpenForAllHosp As %String = "", OrdDate As %String = "") As %String
{
	n (EpisodeID,Arcim,OpenForAllHosp,OrdDate,%session)
	s ^tmpgry("GetRecloc")=EpisodeID_"^"_Arcim_"^"_OpenForAllHosp
	;w ##class(web.DHCDocOrderCommon).GetRecloc(2566,"11802||1","")
	
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	s admLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	;admLoc_"^"_admType
	if (admType="I")||(PatCurStat="1") do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	.s LinkLoc=..GetLocLinkLocation(EpLoc)
	.if ($l(LinkLoc,"^")>1)||(PatCurStat=1) do
	..s ExistFlag=..CheckIsExistWardEpLoc(EpLoc,Arcim,OpenForAllHosp)
	..if ExistFlag=0 s EpLoc=admLoc
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	Q:EpLoc="" "" 
	;EpLoc,Arcim,OpenForAllHosp
	s ret=..GetLocRecLoc(EpLoc,Arcim,OpenForAllHosp,OrdDate,admType)
	Q ret
}

/// Creator:      周志强
/// CreatDate:    2009.05.22
/// Description:  取得医嘱项的有库存接受科室字符串,为医嘱录入弹出医嘱项列表用
/// Table:        CT_Loc,Arc_ItmCatRecloc,OEC_OrderCatRecloc,Arc_ItmRecloc,inc_itmloc
/// Input:        EpisodeID:就诊指针,ArcimRowid:医嘱项指针,Delim:分隔符号,OrderDepRowId:当前就诊科室
/// OutPut:		  有库存接受科室字符串
/// Others:        
ClassMethod GetReclocDescStr(EpisodeID As %String, ArcimRowid As %String, Delim As %String, OrderDepRowId As %String = "", OrderOpenForAllHosp As %String = "") As %String
{
	s ^Temspc("GetReclocDescStr")=EpisodeID_","_ArcimRowid_","_Delim_","_OrderDepRowId_","_OrderOpenForAllHosp
	s Str=""
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	;先判断假日接受科室
	s RecLocStrret=""
	i (OrderType="R")&&(EpisodeID'=""){
		s RecLocStrret=..GetHolidaysRecLoc(EpisodeID,OrderDepRowId,ArcimRowid,OrderOpenForAllHosp)
	}
	if (RecLocStrret=""){
		i OrderDepRowId'="" {
			s RecLocStrret=..GetLocRecLoc(OrderDepRowId,ArcimRowid,OrderOpenForAllHosp)
		}else {
			i EpisodeID'="" s RecLocStrret=..GetRecloc(EpisodeID,ArcimRowid,OrderOpenForAllHosp)
		}
	}
	k RecLocList
	if RecLocStrret'="" {
		s CNMedItemFlag=..IsCNMedItem(ArcimRowid)
		s RecLocCount=$LENGTH(RecLocStrret,$C(2))
		F i=1:1:RecLocCount {
			S RecLocStr=$P(RecLocStrret,$C(2),i)
			s ReclocRowId=$P(RecLocStr,$C(1),1)
			continue:$d(RecLocList(ReclocRowId))
			s RecLocList(ReclocRowId)=1
			if (EpisodeID'="") {
				s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
			}else{
				s EpisodeType=""
			}
			if (CNMedItemFlag=1) {
				s StockEnough=1
			}else{
				s StockEnough=..CheckStockEnough(ArcimRowid,1,ReclocRowId,EpisodeType,EpisodeID)
			}
			if StockEnough>0 {
				if Str="" {
					s Str=$P(RecLocStr,$C(1),2)
				}else{
					s Str=Str_Delim_$P(RecLocStr,$C(1),2)
				}
			}
		}
	}
	Quit Str
}

/// Creator:      郭荣勇
/// CreatDate:    2010-09-27
/// Description:  根据科室得到关联科室
/// Table:        CT_Loc,CT_LocLinkLocation
/// Input:        LocID:科室指针
/// OutPut:		  关联科室的rowid串
/// Others:        
ClassMethod GetLocLinkLocation(LocID As %String) As %String
{
	n (LocID)
	s ret=""
	Q:LocID="" ret
	s LinkLocChildSub=0
	for {
		s LinkLocChildSub=$O(^CTLOC(LocID,"LINK",LinkLocChildSub))
		Q:LinkLocChildSub=""
		s LINKCTLOCDR=$p($g(^CTLOC(LocID,"LINK",LinkLocChildSub)),"^",1)
		if LINKCTLOCDR="" continue
		if '$d(^CTLOC(LINKCTLOCDR)) continue
		if ret="" s ret=LINKCTLOCDR
		else  s ret=ret_"^"_LINKCTLOCDR
	}
	
	Q ret
}

/// Creator:      郭荣勇
/// CreatDate:    2010-09-27
/// Description:  审查是否存在此科室为开单科室的接收科室
/// Table:        CT_Loc,Arc_ItmCatRecloc,OEC_OrderCatRecloc,Arc_ItmRecloc,inc_itmloc
/// Input:        EpisodeID:就诊指针,Arcim:医嘱项指针,OpenForAllHosp:跨院  1:允许  其他:不允许
/// OutPut:		  接受科室字符串
/// Others:
ClassMethod CheckIsExistWardEpLoc(EpLoc As %String, Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n find
	
	;1 判断医嘱接收科室
	s find=0
	s sub=0  f  s sub= $O(^ARCRL(+Arcim,sub))  Q:(sub="")||(find=1)  d 
	. s OrdLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 1)
	. Q:(EpLoc'=OrdLoc)&&(EpLoc'="")
	. s find=1
	Q:find=1 find
	;2 判断医嘱子类接收科室、判断医嘱大类接收科室
	s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
	if ItemCat'="" {
		s find=..CheckIsExistWardEpLocByItemCat(EpLoc,ItemCat,OpenForAllHosp)
	}
	
	Q find
}

/// Creator:      tanjishan
/// CreatDate:    2020-03-17
/// Description:  审查是否存在此科室为开单科室的接收科室，获取草药接收科室时复用改方法
/// Table:        CT_Loc,Arc_ItmCatRecloc,OEC_OrderCatRecloc,Arc_ItmRecloc,inc_itmloc
/// Input:        EpisodeID:就诊指针,ItemCatList:^分割的子类串,OpenForAllHosp:跨院  1:允许  其他:不允许
/// OutPut:		  接受科室字符串
/// Others:
ClassMethod CheckIsExistWardEpLocByItemCat(EpLoc As %String, ItemCatList As %String, OpenForAllHosp As %String = "") As %String
{
	s find=0
	for i=1:1:$L(ItemCatList,"^"){
		s ItemCat=$P(ItemCatList,"^",i)
		continue:ItemCat=""
		;1 判断医嘱子类接收科室
		s rl=0  f  s rl=$O(^ARC("IC",ItemCat,"RL",rl)) q:(rl="")||(find=1)  d
		. s OrdLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",2)
		. Q:(EpLoc'=OrdLoc)&&(EpLoc'="")
		. s find=1
		Q:find=1 
		
		;2 判断医嘱大类接收科室
		s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
		if OrderCat'="" {
			s sub=0  f  s sub=$O(^OEC("ORCAT",OrderCat,"RL",sub)) Q:(sub="")  d
			. s OrdLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 2)
			. Q:(EpLoc'=OrdLoc)&&(EpLoc'="")
			. s find=1
			Q:find=1
		}
	}
	q find
}

ClassMethod GetSignSymptomDescByCode(Code As %String) As %String
{
	n (Code)
	s Desc=""
	Q:Code="" ""
	s Code=$ZCVT(Code,"U")
	s RowId=$O(^MRC("DSYM",0,"Code",Code,0))
	i RowId'="" {
		s Desc=$P(^MRC("DSYM",RowId),"^",2)
	}
	Q Desc
}

ClassMethod GetSkinTestResult(OrderItemRowid As %String) As %String
{
	n (OrderItemRowid)
	s Desc=""
	s Oew=+OrderItemRowid
	s OrdSub=$P(OrderItemRowid,"||",2)
	;s OrdStat=
 s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
 if (skintest="Y") d
 .s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
 .if abnorm="Y" s Desc="阳性"
 .if abnorm="N" s Desc="阴性"
 Q Desc
}

ClassMethod GetSpecimenByTestset(Testsetcode As %String, HospitalId As %String = "", langid As %String = "") As %String
{
	;根据检验套取标本 
	;PLIST:标本代码,$c(2),标本名称,$c(2),容器代码,容器名称
	;return:默认标本代码,$c(1),标本名称,$c(1),容器代码,$c(1),容器名称
	s Testsetcode=$g(Testsetcode)
	s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
	i $d(^DHCLISBSVersion(1)) q ##Class(DHCLIS.DHCCommon).GetTestsetDefSpecCon(Testsetcode,$g(HospitalCode),langid)
	
	q ""
}

ClassMethod GetStockQty(loc As %String, Arcim As %String) As %String
{
	s today=..%SysDate()
	s fdate=today-2
	s inci=##class(web.DHCDocOrderEntry).GetINCI(+Arcim)
	q:inci="" "0^0"
	q:loc="" "0^0"
	s realqty=##class(web.DHCDocOrderEntry).GetRealInciQty(inci,loc)
	s packedqty=##class(web.DHCDocOrderEntry).GetPkInciQty("P",fdate,today,loc,inci)
	s convqty=##class(web.DHCDocOrderEntry).GetItemConFac(Arcim)
	s qty=realqty/convqty
	s qty1=packedqty/convqty
	q qty_"^"_qty1
}

/// w ##class(web.DHCDocOrderCommon).GetTodayDispTimes(4,"10:53")
ClassMethod GetTodayDispTimes(FreqRowId As %String, StartTime As %String, StartDate As %String = "", OrderFreqFreeTimeStr As %String = "") As %String
{
	Q $P(##class(web.DHCOEOrdItemView).GetOrderFirstDayTimes("","",FreqRowId,"",StartDate_" "_StartTime,"",OrderFreqFreeTimeStr),"^",1)
}

ClassMethod GetUOMDesc(UOMRowid As %String, UserLanguage As %String = "") As %String
{
	n (UOMRowid, UserLanguage,%session)	
	Q:UOMRowid="" ""
	s langid=UserLanguage
	if langid="" Set langid=..%LanguageID()
    s doseUOM=$P($g(^CT("UOM",UOMRowid)),"^",2)
    s doseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",doseUOM,langid)
    q doseUOM
	/*if UserLanguage="EN" {
		Q $P($g(^CT("UOM",UOMRowid)),"^",3)
	}else{
		Q $P($g(^CT("UOM",UOMRowid)),"^",2)
	}*/
}

ClassMethod GetForeignName(ARCIMRowId As %String) As %String
{
	Q:ARCIMRowId="" ""
	Q $P($g(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1)),"^",3)
}

/// CreatDate?    2010.01.26
/// Description:? 得到节假日串
/// Table?        DHC_OPRegFestivalSet
/// Input?        ?
/// Return?       节假日信息串 
/// Others?
ClassMethod GetHolidaysStr() As %String
{
	;w ##class(web.DHCDocOrderCommon).GetHolidaysStr()
	s HolidaysStr=""
	s FestivalRowid=0
	for {
		s FestivalRowid=$o(^User.DHCOPRegFestivalSetD(FestivalRowid))
		q:FestivalRowid=""
		s Festival=$List(^User.DHCOPRegFestivalSetD(FestivalRowid),7)
		i HolidaysStr="" s HolidaysStr="!"_Festival_"!"
		e  s HolidaysStr=HolidaysStr_"^"_"!"_Festival_"!"
	} 
	Q HolidaysStr
}

/// /走新的节假日设置
/// w ##Class(web.DHCDocOrderCommon).IsHolidayFlag(+$H,$P(+$H,",",2))
ClassMethod IsHolidayFlag(Nowday As %String, Nowtime As %String, HospId As %String = "") As %String
{
	n (Nowday,Nowtime,HospId,%session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s isHoliday="0",HolidayRowId=""
	s FestivalRowid=""
	for {
		s FestivalRowid=$o(^User.DHCOPRecDepHolidayD(FestivalRowid),-1)
		q:FestivalRowid=""
		s RDHStartDate=$list(^User.DHCOPRecDepHolidayD(FestivalRowid),6)
	    s RDHStartTime=+$list(^User.DHCOPRecDepHolidayD(FestivalRowid),7)
	    s RDHEndDate=$list(^User.DHCOPRecDepHolidayD(FestivalRowid),8)
	    s RDHEndTime=+$list(^User.DHCOPRecDepHolidayD(FestivalRowid),9)
	    if ($listlength(^User.DHCOPRecDepHolidayD(FestivalRowid))>=10) {
		    s RDHHospDr=$list($g(^User.DHCOPRecDepHolidayD(FestivalRowid)),10)
		    continue:(RDHHospDr'=HospId)
	    }else{
		    continue
		}
	    continue:(RDHStartDate="")||(RDHEndDate="")
		if (Nowday>=RDHStartDate)&&(Nowday<=RDHEndDate){
			
			if (Nowday>RDHStartDate)&&(Nowday<RDHEndDate) {
			    s isHoliday="1"
			    s HolidayRowId=FestivalRowid
				quit
		    }
			if (Nowday=RDHStartDate)&&(Nowtime>=RDHStartTime)&&(Nowday<RDHEndDate){
				s isHoliday="1"
				s HolidayRowId=FestivalRowid
				quit
			}
			if (Nowday=RDHEndDate)&&(Nowtime<=RDHEndTime)&&(Nowday>RDHStartDate) {
			    s isHoliday="1"
			    s HolidayRowId=FestivalRowid
				quit
		    }
		    if (Nowday=RDHStartDate)&&(Nowday=RDHEndDate)&&(Nowtime>=RDHStartTime)&&((Nowtime<=RDHEndTime)||(RDHEndTime=0)){
				s isHoliday="1"
				s HolidayRowId=FestivalRowid
				quit
			}
			
		}
	} 
	q isHoliday_"^"_FestivalRowid
}

/// CreatDate:    2010.03.18
/// Description:: 取此次就诊开医嘱所在科室
/// Table:        
/// Input:        EpisodeID:就诊指针  OrderDepRowid:开医嘱科室
/// Return:       接收科室信息串 
/// Others:       w ##class(web.DHCDocOrderCommon).GetHolidaysRecLoc("418","","5220||1")
ClassMethod GetEpLoc(EpisodeID As %String, OrderDepRowId As %String)
{
	if (OrderDepRowId=""){
		s admType=$P($g(^PAADM(EpisodeID)),"^",2)
		if admType="I" do
		.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
		else  d
		.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
		s OrderDepRowId=EpLoc
	}
	Q OrderDepRowId
}

/// CreatDate:    2010.01.26
/// Description:: 取节假日定义的接收科室串
/// Table:        
/// Input:        开医嘱科室,OrderDepRowid,EpisodeID,ArcimRowid
/// Return:       接收科室信息串 
/// Others:       w ##class(web.DHCDocOrderCommon).GetHolidaysRecLoc(195,"","5129||1",0)
ClassMethod GetHolidaysRecLoc(EpisodeID As %String, OrderDepRowId As %String, ArcimRowid As %String, OpenForAllHosp As %String = "", OrdDateStr As %String = "", OrderPriorRowid As %String = "") As %String
{
	n (OrderDepRowId,EpisodeID,ArcimRowid,OpenForAllHosp,OrdDateStr,OrderPriorRowid,%session)
	s ^Tempscl("GetHolidaysRecLoc")=EpisodeID_","_OrderDepRowId_","_ArcimRowid_","_OpenForAllHosp
	
	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	if admType="I" do
	.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	else  d
	.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	if (OrderDepRowId=""){
		s OrderDepRowId=EpLoc
	}
	Q:OrderDepRowId="" ""
	s ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s HospId=$p(^CTLOC(OrderDepRowId),"^",22)
	s HospCodeNode="HospDr_"_HospId
	s RecHolidayDr=""
	s QueryHospId=HospId	;默认不需要跨院
	if (OpenForAllHosp=1){
		s QueryHospId=""
	}
	s RecLocStr=""
	s WeekendAsHoliday=..%GetConfig("WeekendAsHoliday",HospId)
	
	s Nowday=..%SysDate(),Nowtime=..%SysTime()
	i OrdDateStr'=""{
		s OrdDate=$p(OrdDateStr," ",1)
		if (OrdDate'="") {
			s Nowday=..%ZDH(OrdDate)
		}
		s OrdTime=$p(OrdDateStr," ",2)
		i OrdTime'=""{
			s Nowtime=..%ZTH(OrdTime)
		}
	}
	s isHoliday=0
	s HolidaysStr="",HolidayRecLocStr=""
	s rtn=..IsHolidayFlag(Nowday,Nowtime,HospId)
	s isHoliday=$p(rtn,"^",1)
	if (isHoliday=1){
		s RecHolidayDr=$p(rtn,"^",2)
		s ConfigType="HolidaysRecStr"
		d GetHolidaysRecLocDetails
		if (RecLocStr'=""){
			Q RecLocStr
		}
	}
	s isHoliday=0
	;下班时间段改为 可以维护多个下班时间段
	s IsWorkTime=0,IsExistWorkTimeRecord=0
	s OffWorkTimesSetRowId=""     
	f  s OffWorkTimesSetRowId=$o(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)) q:(OffWorkTimesSetRowId="")||(IsWorkTime=1)  d
	.s active=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",3)
	.Q:active=0 
	.s IsExistWorkTimeRecord=1
	.s OffWorkStartTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",1)
	.i (OffWorkStartTime'="")&&(OffWorkStartTime'[":") s OffWorkStartTime=..%ZT(OffWorkStartTime,1)
	.s OffWorkStartTime=..%ZTH(OffWorkStartTime)
	.s OffWorkEndTime=$p($g(^DHCDocConfig(HospCodeNode,"OffWorkTimesSet",OffWorkTimesSetRowId)),"^",2)
	.i (OffWorkEndTime'="")&&(OffWorkEndTime'[":")  s OffWorkEndTime=..%ZT(OffWorkEndTime,1)
	.s OffWorkEndTime=..%ZTH(OffWorkEndTime)
	.i ((+OffWorkStartTime)<Nowtime)&&(Nowtime<(+OffWorkEndTime)) s IsWorkTime=1
	;2020-08-03 只有在存在有效的上下班记录且当前时间不在上班范围内才置节假日标识
	i IsWorkTime=0,IsExistWorkTimeRecord=1 s isHoliday=1 
	i WeekendAsHoliday="1"{
		i ($ZD(+$h,10)=6)!($ZD(+$h,10)=0) s isHoliday="1"
	}
	
	;是节假日 下班时间 周末
	i (isHoliday="1"){
		s RecHolidayDr=""
		s ConfigType="OffWorkTimesRecStr"
		d GetHolidaysRecLocDetails
		if (RecLocStr'=""){
			Q RecLocStr
		}
	}
	/*节假日接收科室串$c(1)分割的第五个标志设置为1，
	代表是接收科室来自节假日,此标志在##class(web.DHCOEOrdItemView).GetRecLocStrByPrior中使用
	*/
	q RecLocStr
GetHolidaysRecLocDetails
	Set RCObj=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.HolidaysRecLoc:FindRecConfig")
	do RCObj.Execute(ConfigType,RecHolidayDr,QueryHospId)
	While (RCObj.Next()) {
		
		s ConfigRowID=RCObj.Data("RowID")
	    s IsActiveFlag=RCObj.Data("IsActiveFlag")
		continue:(IsActiveFlag'="Y")
		s OrdLocDr=RCObj.Data("OrdLocDr")
		continue:(OrdLocDr'="")&&(("!"_OrderDepRowId_"!"_EpLoc_"!")'[("!"_OrdLocDr_"!"))
		
		s OrderPriorID=RCObj.Data("OrderPriorID")
		continue:(OrderPriorRowid'="")&&(OrderPriorID'="")&&(OrderPriorID'=OrderPriorRowid)
		s OrderPrior=RCObj.Data("OrderPrior")
		s NotifyClinician=RCObj.Data("NotifyClinician")
		s NotifyClinician=$CASE(NotifyClinician,"Y":"Y","N":"N",:"")
		s ItemCatList=RCObj.Data("ItemCatList")
		continue:(ItemCatList'="")&&(("!"_ItemCatList_"!")'[("!"_ItemCatDR_"!"))
		s ExceptionArcimList=RCObj.Data("ExceptionArcimList")
		continue:(ExceptionArcimList'="")&&(("!"_ExceptionArcimList_"!")[("!"_ArcimRowid_"!"))

		Set RCDObj=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.HolidaysRecLoc:FindRecDetails")
		do RCDObj.Execute(ConfigRowID)
		While (RCDObj.Next()) {
			s HolidayRecLocRowid=RCDObj.Data("ReclocDr")
			continue:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(HolidayRecLocRowid)
			if (QueryHospId'=""){
				continue:(##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",HolidayRecLocRowid,QueryHospId)'="Y")
			}
			s HolidayRecLocDesc=..GetLocDesc(HolidayRecLocRowid)

			i RecLocStr="" s RecLocStr=HolidayRecLocRowid_$C(1)_HolidayRecLocDesc_$C(1)_"Y"_$C(1)_OrderPriorID_$C(1)_"1"_$C(1)_NotifyClinician
			e  s RecLocStr=RecLocStr_$C(2)_HolidayRecLocRowid_$C(1)_HolidayRecLocDesc_$C(1)_"N"_$C(1)_OrderPriorID_$C(1)_"1"_$C(1)_NotifyClinician
		}
	}

	q
}

/// CreatDate:    2010.01.26
/// Creator:	  张翔
/// Description:  补充用法定义的接收科室串
/// Table:        DHC_PHCInstrRecLoc
/// Input:        用法rowid,医嘱录入科室,原来的接收科室串
/// Return:       接收科室信息串 
/// Others:		  w ##class(web.DHCDocOrderCommon).GetInstrRecLocStr(361,12,115,1,3,"",2,0)
ClassMethod GetInstrRecLocStr(EpisodeID As %String, FormInstrRowid As %String, OrdDepRowId As %String, OrdSubCatRowid As %String, PriorRowid As %String, RecLocStr As %String, HOSPID As %String = "", OrderOpenForAllHosp As %String = "0", OrdDateStr As %String = "", InstrLinkOrderARCIMList As %String = "") As %String [ ProcedureBlock = 1 ]
{
	s ^RP("GetInstrRecLocStr")=EpisodeID_","_FormInstrRowid_","_OrdDepRowId_","_OrdSubCatRowid_","_PriorRowid_","_RecLocStr_","_HOSPID_","_OrderOpenForAllHosp
	
	q:FormInstrRowid="" RecLocStr
	s InstrRecLocStr="",InstrOrdDepRowid="",InstrDefault="1",InstrRecLocRowid="",InstrRecLocDesc=""
	s StartTime="",EndTime="",InstrHosCode=""
	s HOSPID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HOSPID)
	if HOSPID="" s HOSPID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	if HOSPID'="" s HospitalCode=$P(^CT("HOSP",HOSPID),"^",1)
	if (OrdDepRowId=""){
		s admType=$P($g(^PAADM(EpisodeID)),"^",2)
		if admType="I" do
		.s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		.s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
		else  d
		.s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
		s OrdDepRowId=EpLoc
	}
	q:OrdDepRowId="" RecLocStr
	//化疗药、TPN药物标志
	s Chemotherapeutic="N",TPN="N",TMPArcimDr=""
	///
	for i=1:1:$L(InstrLinkOrderARCIMList,"^"){
		s LinkOrderARCIMRowid=$P(InstrLinkOrderARCIMList,"^",i)
		continue:(LinkOrderARCIMRowid="")
		s:(TMPArcimDr="") TMPArcimDr=LinkOrderARCIMRowid
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(LinkOrderARCIMRowid)
		if (DrgformRowid'=""){
			s LinkChemotherapeutic=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"DHC",2)),"^",10)
			i LinkChemotherapeutic="Y" s Chemotherapeutic="Y"
			s LinkTpnFlag=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"DHC")),"^",38)
			i LinkTpnFlag="Y" s TPN="Y"
		}
	}
	s OrdDate=..%SysDate()
	s OrdTime=..%SysTime()
	i OrdDateStr'=""{
		s OrdDate=$p(OrdDateStr," ",1)
		i OrdDate'=""{
			s OrdDate=..%ZDH(OrdDate)
		}
		s OrdTime=$p(OrdDateStr," ",2)
		i OrdTime'=""{
			s OrdTime=..%ZTH(OrdTime)
		}
	}
	s IPDosingRecLoc=##Class(DHCDoc.DHCDocConfig.DocConfig).GetDosingRecLocStr(HOSPID)
	s LongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
	s strRecLocSub=0
	for {
		s strRecLocSub=$o(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub))
		q:strRecLocSub=""
		s InstrOrdDepList=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",1)
		if (("!"_InstrOrdDepList_"!")'[("!"_OrdDepRowId_"!"))&&(InstrOrdDepList'="") {continue}

		s InstrRecLocRowid=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",2)
		i InstrRecLocRowid'="" s InstrRecLocDesc=..GetLocDesc(InstrRecLocRowid)
		continue:(OrderOpenForAllHosp'=1)&&($p($g(^CTLOC(InstrRecLocRowid)),"^",22)'=HOSPID)
		s InstrDefault=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",3)
		i InstrDefault="1" s InstrDefault="Y"
		s InstrOrdSubCatRowid=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",4)
		; OrdSubCatRowid  InstrOrdSubCatRowid
		i (OrdSubCatRowid'=InstrOrdSubCatRowid)&&(InstrOrdSubCatRowid'="") {continue}
		s InstrOrdPrior=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",5)
		;  PriorRowid   InstrOrdPrior
		i (PriorRowid'=InstrOrdPrior)&&(InstrOrdPrior'="") {continue}
		//只接收化疗药物|TPN药物
		s OnlyChemotherapeuticAndTPN=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",8)
		if (OnlyChemotherapeuticAndTPN="Y")&&(Chemotherapeutic="N")&&(TPN="N") {continue}
		
		s InstrTimeRangeStr=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",6)
		i InstrTimeRangeStr'="~"{
			s StartTime=$p(InstrTimeRangeStr,"~",1)
			i StartTime'="" s StartTime=..%ZTH(StartTime)
			s EndTime=$p(InstrTimeRangeStr,"~",2)
			i EndTime'="" s EndTime=..%ZTH(EndTime)
			if (StartTime'="")&&(OrdTime<StartTime) {continue}
			if (EndTime'="")&&(OrdTime>EndTime) {continue}
			//i (OrdTime<StartTime)!(OrdTime>EndTime) {continue}
		}
		/// 接收到静配的临时医嘱，需要受静配上下班时间的管控
		if (("^"_IPDosingRecLoc_"^")[("^"_InstrRecLocRowid_"^"))&&('LongOrdFlag){
			s PYFlag="Y"
			d ##Class(appcom.OEDispensing).GetFirstDaySetting(EpisodeID,TMPArcimDr,InstrRecLocRowid,..%ZD(OrdDate),..%ZT(OrdTime),.PYFlag,..%ZD(OrdDate),..%ZT(OrdTime))
			if (PYFlag="N"){
				continue
			}
		}

		s InstrHosRowid=$p($g(^PHCIN(FormInstrRowid,"RecLoc",strRecLocSub)),"^",7)
		i InstrHosRowid'="" s InstrHosCode=$p(^CT("HOSP",InstrHosRowid),"^",1)
		i (HospitalCode'=InstrHosCode)&&(InstrHosCode'="") {continue}

		i InstrRecLocStr=""{
			s InstrRecLocStr=InstrRecLocRowid_$C(1)_InstrRecLocDesc_$C(1)_InstrDefault_$C(1)_""
		}else{
			s InstrRecLocStr=InstrRecLocRowid_$C(1)_InstrRecLocDesc_$C(1)_InstrDefault_$C(1)_""_$C(2)_InstrRecLocStr
		}
	} 
	; InstrRecLocStr
	Q:InstrRecLocStr'="" InstrRecLocStr
	q RecLocStr
}

ClassMethod LookUpBrokerDuration(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpDuration")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerFrequency(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerInstr(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerSingleDuration(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpDuration")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	}
	d rset.Close()
	if row=1{
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerSingleFrequency(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	}
	d rset.Close()
	if row=1 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpBrokerSingleInstr(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	}
	d rset.Close()
	if row=1 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpFrequencyClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFrequencyFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","LookUpFrequency","bid","")

ClassMethod LookUpFrequencyExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, PAAdmType As %Library.String = "", UserID As %Library.String = "", OrderPriorRowid As %Library.String = "", OrderARCIMRowid As %Library.String = "", LocID As %Library.String = "", InstrucID As %Library.String = "") As %Library.Status
{
	n (qHandle,desc,PAAdmType,UserID,OrderPriorRowid,OrderARCIMRowid,LocID,InstrucID,%session)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	//因为周频次前台会自动改描述
	s desc=$P(desc," ",1)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s OrderPriorCode=$p($G(^OECPR(+OrderPriorRowid)),"^",1)
	s LongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
	s IsHourItem=##Class(web.DHCDocOrderCommon).IsHourItem(OrderARCIMRowid)
	;出院带药医嘱扩展设置-不能下的频次
	s OutOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))
	i (LocID="")&&($d(%session)) s LocID=%session.Get("LOGON.CTLOCID")
	s HospId=$P($G(^CTLOC(+LocID)),"^",22)
	s OutOrderNotFreqIDStr="^"_..%GetConfig1("OutOrderNotFreq",OutOrderPriorRowid,HospId)_"^"
	s PHCFRRowId=0 for{
		s PHCFRRowId=$O(^PHCFR(PHCFRRowId)) Q:PHCFRRowId=""
		s FreqStr=^PHCFR(PHCFRRowId)
		s PHCFRCode=$P(FreqStr,"^",1)
		s FreqCode=$ZCVT(PHCFRCode,"U")
		s PHCFRFactor=$P(FreqStr,"^",2)
		s PHCFRDesc1=$P(FreqStr,"^",3)
		s PHCFRDesc2=$P(FreqStr,"^",4)
		s PHCFRDays=$P(FreqStr,"^",5)
		s Active=$P(FreqStr,"^",6)
		s AvailableType=$P(FreqStr,"^",7)
		continue:Active="N"
		continue:(PHCFRDesc2="饮片")||(PHCFRDesc2="UNUSE")
		continue:(PAAdmType'="")&&(AvailableType'="")&&(AvailableType'[PAAdmType)
		continue:(PAAdmType'="")&&(PAAdmType'="I")&&'LongOrdFlag&&(FreqCode="PRN")
		if OrderPriorRowid'=""{
			if LongOrdFlag{
				continue:(" ONCE ST "[(" "_FreqCode_" "))
				continue:IsHourItem&&LongOrdFlag&&(FreqCode'="PRN")
			}else{
				;非长期不能下PRN
				continue:FreqCode="PRN"
				;住院临时不能下ONCE、ST以外的频次	
				continue:(PAAdmType="I")&&(" OUT ONE "'[(" "_OrderPriorCode_" "))&&(" ONCE ST "'[(" "_FreqCode_" "))
				if OrderPriorCode="OUT"{
					;出院带药医嘱扩展设置-不能下的频次：勾选频次科室没有例外、未勾选频次科室例外
					s OutOrderNotFreqLessLoc="^"_##class(DHCDoc.DHCDocConfig.ItemPrior).GetLessLocConfig("OutOrderNotFreq",PHCFRRowId,HospId)_"^"
					continue:((OutOrderNotFreqIDStr[("^"_PHCFRRowId_"^"))&&(OutOrderNotFreqLessLoc'[("^"_LocID_"^")))||((OutOrderNotFreqIDStr'[("^"_PHCFRRowId_"^"))&&(OutOrderNotFreqLessLoc[("^"_LocID_"^")))
				}
			}
		}
		s IPShortFlag=0
		if (PAAdmType="I")&&('LongOrdFlag)&&(" OUT ONE "'[(" "_OrderPriorCode_" ")) s IPShortFlag=1
		if (InstrucID'="")&&(IPShortFlag'=1){
			;用法关联频次(住院临时医嘱不取此数据)
			continue:'..IsValidFreqDurat(InstrucID, PHCFRRowId)
		}
		if desc'=""{
			s FindFlag=0
			s SubCode=$$ALPHAUP^SSUTIL4(PHCFRCode)
			s subDesc1=$$ALPHAUP^SSUTIL4(PHCFRDesc1)
			s subDesc2=$$ALPHAUP^SSUTIL4(PHCFRDesc2)
			if ((SubCode=desc)||(subDesc1[desc)){
				s FindFlag=1
			}else{
				s SubID=0 for{
					s SubID=$O(^User.BDPAliasI("DataRef","PHC_Freq",PHCFRRowId,SubID)) Q:SubID=""
					continue:'$D(^User.BDPAliasD(SubID))
					s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
					if SUbCode[desc{
						s FindFlag=1
						Q
					}
				}
			}
			continue:'FindFlag
		}
		s WeekFlag=$P(FreqStr,"^",9)
		s OPNoDelayExe=$P(FreqStr,"^",8)
		s IPNoDelayExe=$P(FreqStr,"^",10)
		s FreeTimeFreqFlag=$P(FreqStr,"^",13)
		s NoDelayExe=$CASE(PAAdmType,"I":IPNoDelayExe,:OPNoDelayExe)
		s desc1=PHCFRDesc1
		s code=PHCFRCode
		s factor=PHCFRFactor
		s days=PHCFRDays
		s rowid=PHCFRRowId
		s PHCFRDesc1=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHCFRDesc1,langid)
		s PHCFRDesc2=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc2",PHCFRDesc2,langid)
		;上边是SQL改为M---------------end--------
		s PHCFRMarkNO=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.PHCFreq",rowid,UserID,"U")
		S OutList(PHCFRMarkNO,rowid)=desc1_"^"_code_"^"_factor_"^"_days_"^"_rowid_"^"_""_"^"_WeekFlag_"^"_NoDelayExe_"^"_FreeTimeFreqFlag  //建立临时Globle
	}
	//按照序号排序
	s seq="" for {
		s seq=$O(OutList(seq),-1) Quit:seq=""
		s seq1="" for {
			s seq1=$O(OutList(seq,seq1)) Quit:seq1=""
			s temp=OutList(seq,seq1)
			s desc1=$P(temp,"^",1)
			s code=$P(temp,"^",2)
			s factor=$P(temp,"^",3)
			s days=$P(temp,"^",4)
			s rowid=$P(temp,"^",5)
			s disptimestr=$P(temp,"^",6)
			s WeekFlag=$P(temp,"^",7)
			s NoDelayExe=$P(temp,"^",8)
			s FreeTimeFreqFlag=$P(temp,"^",9)
			d OuputRow4		
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow4
	set Data=$lb(desc1,code,factor,days,rowid,disptimestr,WeekFlag,NoDelayExe,FreeTimeFreqFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequencyFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFrequencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpInsurSignSymptomClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInsurSignSymptomFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:      周志强
/// CreatDate:    2009.02.23
/// Description:; 查询医保适应症
/// Table:        MRC_DiagnosSignSymptom
/// Input:        ARCIMID:医嘱项RowId   BillType:类型
/// Output:        描述,代码,RowId 
/// Return:       
/// Others:        
ClassMethod LookUpInsurSignSymptomExecute(ByRef qHandle As %Library.Binary, ARCIMID As %Library.String, BillType As %Library.String) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Desc="",Code="",RowId=""
	//医保给出的接口,返回适应症代码串(以"^"分隔)
	s SignSymptomCodeStr= ##class(web.DHCINSUPort).GetAPPName(ARCIMID,BillType)
	i SignSymptomCodeStr'="" {
		s len=$length(SignSymptomCodeStr,"^")
		f i=1:1:len {
			s Code=$ZCVT($P(SignSymptomCodeStr,"^",i),"U")
			s RowId=$O(^MRC("DSYM",0,"Code",Code,0))
			i RowId'="" {
				s Desc=$P(^MRC("DSYM",RowId),"^",2)
				d OutputRow6
			}
		}
	}
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(Desc,Code,RowId)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpInsurSignSymptomFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInsurSignSymptomExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else  {					// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookupArcimInsurCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupArcimInsurCatExecute ]
{
 Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","LookupArcimInsurCat","1||1",4,2)
ClassMethod LookupArcimInsurCatExecute(ByRef qHandle As %Binary, ArcimRowid As %String, AdmReason As %String, LogonHospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s LogonHospDr=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s HisCode="",Desc="",TarType="",Note=""
	;只在深圳用,医保组从2010.3.3号起统一到了web.DHCINSUPort里面了,
	;s Ret=##class(web.INSUTarContrastCom).ArcimLinkTarStr(ArcimRowid,"2")
	s Ret=##class(web.DHCINSUPort).ArcimLinkTarStr(ArcimRowid,AdmReason,LogonHospDr)
	q:Ret="" $$$OK
	b ;-2
	f i=1:1:$l(Ret,"^") {
		s Str=$P(Ret,"^",i)
		s HisCode=$P(Str,$c(1),1)
		s Desc=$P(Str,$c(1),2)
		s TarType=$P(Str,$c(1),3)
		s Note=$P(Str,$c(1),4)
		s InsurCat=""
		/*
		if (TarType="01") s InsurCat="受限医保"
		if (TarType="02") s InsurCat="受限地方"
		if (TarType="03") s InsurCat="受限自费"
		*/
		s InsurCat=$P(Str,$c(1),5)
		if (Note'=""){
			s InsurCat=InsurCat_";"_Note
		}
		if (TarType=""){
			//continue
		}
		Do OutputRow3 
	}	 
	Set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow3
	set Data=$lb(HisCode,Desc,TarType,Note,InsurCat)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookupArcimInsurCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupArcimInsurCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2009.07.21
/// Description:: 保存检查治疗项目财务审核内容
/// Table:        DHC_OE_OrdItem
/// Input:        AuditDoc:医生RowId
/// Return:      成功标志(0成功?其他不成功)
/// Others:        
ClassMethod SaveAfterAuditDocEncrypt(AuditDoc As %String, OrderItemRowid As %String) As %Status
{
 s ConfirmFlag="N"
 &sql(Select DHCORI_DoctorConfirmFlag into :ConfirmFlag from SQLUser.DHC_OE_OrdItem where DHCORI_OEORI_Dr=:OrderItemRowid)
	q:(ConfirmFlag'="Y") -1
	s AuditDate=..%SysDate()
	s AuditTime=..%SysTime()
	s DHCORIConfirmFlag="Y"
	i ('SQLCODE)  d   
	.&sql(Update SQLUser.DHC_OE_OrdItem set DHCORI_ConfirmFlag=:DHCORIConfirmFlag,DHCORI_ConfirmDate=:AuditDate,DHCORI_ConfirmTime=:AuditTime,DHCORI_ConfirmUser=:AuditDoc where DHCORI_OEORI_Dr=:OrderItemRowid)
	q:'SQLCODE 0
}

/// Creator?      郭荣勇
/// CreatDate?    2009.07.21
/// Description:? 保存检查治疗项目科室审核内容
/// Table?        DHC_OE_OrdItem
/// Input?        AuditDoc:医生RowId
/// Return?      成功标志(0成功?其他不成功)
/// Others?        
ClassMethod SaveAuditDocEncrypt(AuditDoc As %String, OrderItemRowid As %String, SaveInfo As %String) As %Status
{
 ;s ^TMP("saveaudit")=AuditDoc_"^"_OrderItemRowid_"^"_SaveInfo
 ;q:'$d(^DHCORDItem(0,OrderItemRowid))||(OrderItemRowid="") "-1"
 s ConfirmFlag="N"
 &sql(Select DHCORI_DoctorConfirmFlag into :ConfirmFlag from SQLUser.DHC_OE_OrdItem where DHCORI_OEORI_Dr=:OrderItemRowid)
	q:(ConfirmFlag="Y") 1
 s DHCORrowid=""
 f  s DHCORrowid=$o(^DHCORDItem(0,OrderItemRowid,DHCORrowid))  q:DHCORrowid=""  d
 .s $p(^DHCORDItem(DHCORrowid,"EQ",5),"^",5)=SaveInfo
	s AuditDate=..%SysDate()
	s AuditTime=..%SysTime()
	s DoctorConfirmFlag="Y"
	&sql(Update SQLUser.DHC_OE_OrdItem set DHCORI_DoctorConfirmFlag=:DoctorConfirmFlag,DHCORI_DoctorConfirmDate=:AuditDate,DHCORI_DoctorConfirmTime=:AuditTime,DHCORI_DoctorConfirmUser_Dr=:AuditDoc where DHCORI_OEORI_Dr=:OrderItemRowid)
	q SQLCODE
}

/// Creator:      郭荣勇
/// CreatDate:    2009.07.21
/// Description:  保存检查治疗项目医生申请内容
/// Table:        DHC_OE_OrdItem
/// Input:        AuditDoc:医生RowId
/// Return:      成功标志(0成功?其他不成功)
/// Others:        
ClassMethod SaveDocEncrypt(SaveInfo As %String, OrderItemRowid As %String) As %Status
{
 s ^TMP("DocEncrypt")=SaveInfo_"^"_OrderItemRowid
 ;q:(OrderItemRowid="") "-1"
 &sql(select count(*) into :num from SQLUser.DHC_OE_OrdItem where DHCORI_OEORI_Dr=:OrderItemRowid)
 q:num'=0 "-1"
 &sql(insert  into  SQLUser.DHC_OE_OrdItem(DHCORI_OEORI_Dr) values(:OrderItemRowid))
 i ('SQLCODE)  d   
 .q:'$d(^DHCORDItem(0,OrderItemRowid)) 
 .s DHCORrowid=""
 .f  s DHCORrowid=$o(^DHCORDItem(0,OrderItemRowid,DHCORrowid))  q:DHCORrowid=""  d
 ..s ^DHCORDItem(DHCORrowid,"EQ",5)=SaveInfo
 q 0
}

/// Creator:      徐鹏
/// CreatDate:    2009.04.01
/// Description:  对中文做utf-8转换,解决P8中文传递参数时的 bug
/// Table:       
/// Input:        InStr:字符串
/// Others:       为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
/// 在在组件使用该类方法得到值及Query中执行查询前进行该转换  
/// Return:       装换后的字符串
ClassMethod UnEscape(InStr As %String) As %String
{
	n (InStr)
	s num=1,retStr="",tmpNum=1
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num)
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

Query FindItems(EpisodeID As %String, Days As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "OrderType:%String,Item:%String,EffDateStr:%String,BillUOM:%String,Price:%String,Rowid:%String,OrderCat:%String")
{
}

Query FindOEPrefers(TABITEMS As %Library.String, GroupID As %Library.Integer, UserID As %Library.Boolean, SSGroupID As %Library.String, EpisodeID As %Library.String, formulary As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

/// brings back each item for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
/// accepts a boolean 'getDetails' to determine whether to fetch extra details against ecah item.
/// getDetails = 0 (default) for preferences setup.
/// getDetails = 1 in order entry screen (oeorder.entry.redrawprefs.csp)
Query FindOETabItems(TABITEMS As %Library.String, groupno As %Library.Integer, getDetails As %Library.Boolean, SSGroupID As %Library.String, EpisodeID As %Library.String, formulary As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

/// lxz注意：添加出参，ItemSeqNo:%String始终要放在最后一个。这样才能保证和Execute方法中对齐。
Query FindOSItems(ARCOSRowid As %String, HospitalId As %String = "", EpisodeID As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "Item:%String,ItemQty:%String,ItemBillUOM:%String,ItemDoseQty:%String,ItemDoseUOM:%String,ItemFreq:%String,ItemInstr:%String,ItemDur:%String,ItemData:%String,ItemRowid:%String,ItemOrderType:%String,ItemPrice:%String,ItemStatus:%String,ItemRemark:%String,DHCDocOrderType:%String,DHCDocOrderTypeID:%String,ItemSpec:%String,ItemSpecCode:%String,OrderPriorRemarksDR:%String,OrderPriorRemarks:%String,Sensitive:%String,OrderConFac:%String,ItemFreqFactor:%String,BaseDoseQty:%String,OrderMustEnter:%String,CNMedItemFlag:%String,ReclocDescStr:%String,id:%String,NotifyClinician:%String,ItemCatDR:%String,LongPriorFlag:%String,ItemSeqNo:%String")
{
}

/*
Query LookUpDuration(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,CTPCPDesc,CTPCPCode,HIDDEN:%String")
{
	SELECT PHCDU_Rowid,PHCDU_Desc1, PHCDU_Code, PHCDU_Factor
	FROM SQLUser.PHC_Duration
	WHERE   ((PHCDU_Factor=:desc) or (PHCDU_Desc1 %STARTSWITH :desc)) and ((PHCDU_Desc2 is null) or(PHCDU_Desc2 <>'饮片'))
	ORDER   BY PHCDU_Code
}
*/
/// creater lxz
/// desc 医嘱录入放大镜统一改为M 加入别名检索部分
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","LookUpDuration","te")
Query LookUpDuration(desc As %String) As %Query(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,CTPCPDesc:%String:描述,CTPCPCode:%String:编码,HIDDEN:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set langid=..%LanguageID()
 	s desc=$$ALPHAUP^SSUTIL4(desc)
 	s PHCDURowId=0
 	f  s PHCDURowId=$O(^PHCDU(PHCDURowId)) Q:PHCDURowId=""  d
 	.s PHCDUCode=$P(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$P(^PHCDU(PHCDURowId),"^",2)
 	.s PHCDUDesc1=$P(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",PHCDUDesc1,langid)
 	.s PHCDUDesc2=$P(^PHCDU(PHCDURowId),"^",4)
 	.Q:PHCDUDesc2="饮片"
 	.s PHCDUDesc2=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc2",PHCDUDesc2,langid)
	.s StartDate=$P(^PHCDU(PHCDURowId),"^",5)
	.s EndDate=$P(^PHCDU(PHCDURowId),"^",6)
	.q:(StartDate'="")&&(StartDate>+$h)
	.q:(EndDate'="")&&(EndDate<+$h)
 	.s FindFlag=1
 	.i desc'=""  d
 	..s FindFlag=0
 	..s SubFactor=$$ALPHAUP^SSUTIL4(PHCDUFactor)
 	..s SubDesc1=$$ALPHAUP^SSUTIL4(PHCDUDesc1)
 	..i ((SubFactor=desc)||(SubDesc1[desc))  d
 	...s FindFlag=1
 	..i FindFlag'=1 d
 	...s SubID=0  
	...f  s SubID=$O(^User.BDPAliasI("DataRef","PHC_Duration",PHCDURowId,SubID)) Q:SubID=""  d
	....i $D(^User.BDPAliasD(SubID)) d
	.....s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
	.....i SUbCode[desc  d
	......s FindFlag=1
	.Q:FindFlag'=1
	.s RowID=PHCDURowId
	.s CTPCPDesc=PHCDUDesc1
	.s CTPCPCode=PHCDUCode
	.s Facter=PHCDUFactor
	.Do OutputDuration
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDuration
	set Data=$lb(RowID,CTPCPDesc,CTPCPCode,Facter)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LookUpFrequency(desc As %Library.String, PAAdmType As %Library.String = "", UserID As %Library.String = "", OrderPriorRowid As %Library.String = "", OrderARCIMRowid As %Library.String = "", LocID As %Library.String = "", InstrucID As %Library.String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "Desc:%String:描述,Code:%String:编码,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpInstr(instrdesc As %Library.String, paadmtype As %String = "", arcimrowid As %Library.String = "", LocRowId As %String = "", UserID As %Library.String = "", ExtInfo As %Library.String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,Desc:%String:描述,Code:%String:编码")
{
}

ClassMethod LookUpInstrClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpInstrFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","LookUpInstr","kf","8598||1")

ClassMethod LookUpInstrExecute(ByRef qHandle As %Library.Binary, instrdesc As %Library.String, paadmtype As %String = "", arcimrowid As %Library.String = "", LocRowId As %String = "", UserID As %Library.String = "", ExtInfo As %Library.String = "") As %Library.Status
{
	n (qHandle,instrdesc,paadmtype,arcimrowid,LocRowId,UserID,ExtInfo,%session)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	s SkinTestInstr=""
	s ForbidDosingInstr=""
	if (LocRowId'=""){
		s ForbidDosing=$P($G(^CTLOC(LocRowId,"DHC")),"^",18)
		i (ForbidDosing="1"){
			if (paadmtype="I"){
				s ForbidDosingInstr=..%GetConfig("IPDosingInstr")
			}elseif (paadmtype="O"){
				s ForbidDosingInstr=..%GetConfig("OPInfusionInstr")
			}
		}
		s LogonHosp=$P(^CTLOC(LocRowId),"^",22)
		;皮试用法仅能够通过皮试引导窗口录入
		s SkinTestInstr=..%GetConfig("SkinTestInstr",LogonHosp)
		
	}
	i SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	s SeachSkinInstrFlag=$P(ExtInfo,"^",1)
	K ^TMP($J,"InstrLookup")
	s instrdesc=$zcvt(instrdesc,"U")
	;现在不启用使用医嘱项目找用法的程序,知识库未提供接口,药学项也没有相关维护
	s arcimrowid=""
	if $g(arcimrowid)'="" {
		Set rset=##Class(%ResultSet).%New("web.DHCSTINTERFACE.GetPHCInstruc")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute(arcimrowid)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s code=rset.GetData(1)
				s desc1=rset.GetData(2)
				s rowid=rset.GetData(3)
				continue:(instrdesc'="")&&((desc1'[instrdesc)&&(code'[instrdesc))
				continue:(SkinTestInstr'="")&&(SkinTestInstr[("^"_rowid_"^"))&&(SeachSkinInstrFlag="Remove")
				continue:(SkinTestInstr'="")&&(SkinTestInstr'[("^"_rowid_"^"))&&(SeachSkinInstrFlag="OnlySkin")
				s ^TMP($J,"InstrLookup",rowid)=rowid_"^"_desc1_"^"_code				
			}
			d rset.Close()
		}
		Set repid=$I(^CacheTemp)
		If $g(ind)="" Set ind=1
		//按照序号排序
		s rid=0 for {
			s rid=$O(^TMP($J,"InstrLookup",rid))
			Quit:rid=""
			s temp=^TMP($J,"InstrLookup",rid)
			s rowid=$P(temp,"^",1)
			s desc1=$P(temp,"^",2)
			s desc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",desc1,langid)
			s code=$P(temp,"^",3)
			do OuputRow5		
		}
		
	}else{
		s InstrRowStrByAlias=##class(web.DHCBL.BDP.BDPAlias).GetDataStrByAlias("PHC_Instruc",instrdesc)
		s InstrRowAliasList=$LISTFROMSTRING(InstrRowStrByAlias,"^")
		&sql(declare CurInstr cursor for
			SELECT PHCIN_RowId,PHCIN_Desc1,PHCIN_Code,PHCIN_ClinicType,PHCIN_ActiveFlag,PHCIN_Desc2 FROM SQLUser.PHC_Instruc 
			WHERE (PHCIN_Desc1 %STARTSWITH :instrdesc or PHCIN_Code %STARTSWITH :instrdesc 
			or PHCIN_Desc2 %STARTSWITH :instrdesc or PHCIN_Code %STARTSWITH :instrdesc
			or PHCIN_RowId %INLIST (:InstrRowAliasList)) and (PHCIN_Desc1 NOT LIKE '%停用%') and PHCIN_Desc2<>'UNUSE' and (PHCIN_Desc2<>'饮片')
			ORDER BY PHCIN_Code)
		&sql(open CurInstr)
		s num=0,zcnum=1
		f  &sql(fetch CurInstr into :rowid,:desc1,:code,:ClinicType,:ActiveFlag,:desc2) q:SQLCODE  d
		.q:(ActiveFlag="N")
		.q:(paadmtype'="")&&(ClinicType'="")&&(ClinicType'[paadmtype)
		.q:(ForbidDosingInstr'="")&&(("^"_ForbidDosingInstr_"^")[("^"_rowid_"^"))
		.q:(SkinTestInstr'="")&&(SkinTestInstr[("^"_rowid_"^"))&&(SeachSkinInstrFlag="Remove")
		.q:(SkinTestInstr'="")&&(SkinTestInstr'[("^"_rowid_"^"))&&(SeachSkinInstrFlag="OnlySkin")
		.;s SeqNo=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.PHCInstruc","正式",rowid)
		.s SeqNo=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.PHCInstruc",rowid,UserID,"U")
		.S ^TMP($J,"InstrLookup",SeqNo,rowid)=rowid_"^"_desc1_"^"_code
		&sql(close CurInstr)
		s rid="" f  s rid=$O(^TMP($J,"InstrLookup",rid),-1) Quit:rid=""  d
		.s rno=0 f  s rno=$O(^TMP($J,"InstrLookup",rid,rno)) Quit:rno=""  d
		..s temp=^TMP($J,"InstrLookup",rid,rno)
		..s rowid=$P(temp,"^",1)
		..s desc1=$P(temp,"^",2)
		..s desc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",desc1,langid)
		..s code=$P(temp,"^",3)
		..do OuputRow5			
	}
	
	K ^TMP($J,"InstrLookup")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow5
	set Data=$lb(rowid,desc1,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*
Query LookUpInstr(desc As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
	SELECT PHCIN_RowId,PHCIN_Desc1,PHCIN_Code FROM SQLUser.PHC_Instruc 
	WHERE (PHCIN_Desc1 %STARTSWITH :desc or PHCIN_Code %STARTSWITH :desc) and (PHCIN_Desc2<>'饮片')
	ORDER BY PHCIN_Code
}
*/
Query LookUpInsurSignSymptom(ARCIMID As %Library.String, BillType As %Library.String) As %Library.Query(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
}

Query LookUpLocActiveDoc(LocID As %Library.String, docDesc As %Library.String, conFlag As %String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Doc:%String,HDDEN:%String,HDDEN:%String")
{
	SELECT RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Desc,RES_CTPCP_DR->CTPCP_Rowid
	FROM SQLUser.RB_Resource
	WHERE ((RES_CTLOC_DR = :LocID) or RES_CTLOC_DR in (select Link_parref from SQLUser.CT_LocLinkLocation where link_ctloc_dr=:LocID))
	AND (%ALPHAUP RES_CTPCP_DR->CTPCP_Desc [ %ALPHAUP :docDesc) 
	AND ((RES_DateTo >= :activedate) OR (RES_DateTo IS NULL) OR (:activedate IS NULL))
	AND ((RES_AdmittingRights ='Y') OR (RES_AdmittingRights IS NULL))
	AND	((RES_CTPCP_DR->CTPCP_DateActiveTo >= :activedate) OR (RES_CTPCP_DR->CTPCP_DateActiveTo IS NULL) OR (:activedate IS NULL))
	ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

Query LookupArcimInsurCat(ArcimRowid As %String, AdmReason As %String, LogonHospDr As %String) As %Query(ROWSPEC = "HisCode:%String,Desc:%String,TarType:%String,Note:%String,InsurCat:%String")
{
}

/// Creator:      周志强
/// CreatDate:    2010.03.16
/// Description:  根据科室,医生,职称判断医嘱项的可开的权限
/// Table:        DHC_ArcItemAut
/// Input:        
/// Output:       Arcim:医嘱项RowId, EpLoc:就诊科室RowId,UserRowId:用户RowId 
/// Return:       1:允许   0:不允许
/// Others:       w ##class(web.DHCDocOrderCommon).CheckArcimAuthorize("4081||1",44,1513)
ClassMethod CheckArcimAuthorize(Arcim As %String, EpLoc As %String, UserRowId As %String) As %String
{
	Q:(UserRowId="")||(EpLoc="") 1

	s ConditionStr=""
	 s child=$O(^ARCIM(+Arcim,$P(Arcim,"||",2),"DHCAUT",0))
	 While child'="" {
		 s AUT=$G(^ARCIM(+Arcim,$P(Arcim,"||",2),"DHCAUT",child))
		 s AUTRelation=$P(AUT,"^",1)
		 if AUTRelation="" s Condition=child
		 e  s Condition=child_AUTRelation
		 s ConditionStr=ConditionStr_Condition
		 s child=$O(^ARCIM(+Arcim,$P(Arcim,"||",2),"DHCAUT",child))
	 }
	 if ConditionStr="" Q 1
	 
	 s DoctorRowId=$P(^SSU("SSUSR",UserRowId),"^",14)
	 if DoctorRowId="" Q 1
	 s DoctorTypeRowId=$P($G(^CTPCP(DoctorRowId,1)),"^",4)
	 s DoctorTypeCode=$P(^CT("CPT",DoctorTypeRowId),"^",1)
	 
	 if ConditionStr'="" {
		 s Auth=0
		 for i=1:1:$length(ConditionStr,"OR") {
			 s Condition=$P(ConditionStr,"OR",i)
			 if Condition=""  continue
			 s AuthAnd=1
			 for j=1:1:$length(Condition,"AND") {
				 s child=$P(Condition,"AND",j)
				 if child="" continue
				 s AUT=$G(^ARCIM(+Arcim,$P(Arcim,"||",2),"DHCAUT",child))
				 s AUTType=$P(AUT,"^",2)
				 s AUTOperate=$P(AUT,"^",3)
				 s AUTPointer=$P(AUT,"^",4)
				 s AutValue=""
				 if AUTType="KS" s AutValue=EpLoc
				 if AUTType="YS" s AutValue=DoctorRowId
				 if AUTType="ZC" {
					 s AutValue=DoctorTypeCode
					 
					 s TypeCode=$P($g(^CT("CPT",AUTPointer)),"^",1)
					 s AUTPointer=TypeCode
				 }
				 if AUTType="HP" {
					s AutValue=##class(DHCDoc.Common.Hospital).GetLocHospitalId(EpLoc)
				 }
				 if AUTOperate="=" {
					 if AutValue'=AUTPointer {
						 S AuthAnd=0
						 Quit
					 }
				 }
				 if AUTOperate="<>" {
					 if AutValue=AUTPointer {
						 S AuthAnd=0
						 Quit
					 }
				 }
				 
				 if (AUTOperate=">=")&&(AUTType="ZC") {
					 if AutValue<AUTPointer {
						 S AuthAnd=0
						 Quit
					 }
				 }
				 
			 }
			 //w "AuthAnd:"_AuthAnd,!
			   
			 if AuthAnd=1 {
				 s Auth=1
				 Quit
			 }
		 }
	 }
	 Q Auth
}

ClassMethod GetNormKL(NormKL As %String)
{
	Q:'$D(^DHCDocConfig("CNMedNormKL")) "" 
	Set ret="",ItemCatStr="",InStrDesc=""
	Set RecLoc=$o(^DHCDocConfig("CNMedNormKL",NormKL,0))
	if RecLoc'="" Set ItemCatStr=^DHCDocConfig("CNMedNormKL",NormKL,RecLoc)
	Set CookMode=$g(^DHCDocConfig("CNMedNormKL",NormKL,"Cookmode"))
	Set InStr=$g(^DHCDocConfig("CNMedNormKL",NormKL,"InStr"))
	if InStr'="" Set InStrDesc=$p($g(^PHCIN(InStr)),"^",2)
	Set ret=ItemCatStr_","_CookMode_","_InStr_"^"_InStrDesc_","_NormKL_","_RecLoc
	Quit ret
}

/// creator:郭荣勇
/// date:2011-11-02
/// desc:保存医嘱常用(默认)信息
/// table:DHC_Doc_ItemDefault,ARC_ItmMast
ClassMethod SaveItemDefault(OrderItemStr As %String, UserID As %String, LogonHospDr As %String = "") As %String
{
	n (OrderItemStr,UserID,LogonHospDr,%session)
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	KILL ^TMPItemDefault($j)
	s ret=0,RowidStr=""
	Quit:OrderItemStr="" "-100"
	
	;重新组织主子医嘱串
	set Len=$L(OrderItemStr,$c(3))
	for i=1:1:Len {
		set ItemStr=$p(OrderItemStr,$c(3),i)
		if ItemStr="" continue
		set OrderMasterSeqNo=$p(ItemStr,"^",13)
		set OrderSeqNo=$p(ItemStr,"^",14)
		if (OrderMasterSeqNo'="")&&($D(^TMPItemDefault($j,"Master",OrderMasterSeqNo))){
			set ^TMPItemDefault($j,"Master",OrderMasterSeqNo,"Sub",OrderSeqNo)=ItemStr
		}else{
			set ^TMPItemDefault($j,"Master",OrderSeqNo)=ItemStr
		}
		
	}
	
	TS
	set MasterSeqNo=0
	for {
		set MasterSeqNo=$O(^TMPItemDefault($j,"Master",MasterSeqNo)) q:MasterSeqNo=""
		set ItemStr=$g(^TMPItemDefault($j,"Master",MasterSeqNo))
		if ItemStr="" continue
		set $p(ItemStr,"^",13)=""
		//if '$D(^TMPItemDefault($j,"Master",MasterSeqNo,"Sub")){
			s SameFlag=##Class(web.DHCDocItemDefault).CheckSameData(ItemStr,UserID,"",LogonHospDr)
			if (SameFlag=1) set ret="-101" quit
		//}
		
		set Rowid=$$Insert(ItemStr,UserID)
		if Rowid="" set ret="-101" quit
		if RowidStr="" s RowidStr=Rowid
		else  set RowidStr=RowidStr_"*"_Rowid
		set MasterRowid=Rowid
		set SubSeqNo=0
		for {
			set SubSeqNo=$O(^TMPItemDefault($j,"Master",MasterSeqNo,"Sub",SubSeqNo)) q:SubSeqNo=""
			set ItemStr=$g(^TMPItemDefault($j,"Master",MasterSeqNo,"Sub",SubSeqNo))
			if ItemStr="" continue
			set $p(ItemStr,"^",13)=MasterRowid
			s SameFlag=##Class(web.DHCDocItemDefault).CheckSameData(ItemStr,UserID,"",LogonHospDr)
			if (SameFlag=1) set ret="-101" quit
			set Rowid=$$Insert(ItemStr,UserID)
			if Rowid="" set ret="-102" quit
			if RowidStr="" s RowidStr=Rowid
			else  set RowidStr=RowidStr_"*"_Rowid
		}
	}
	
	if ret=0 {
		TC
	}else{
		TRO
	}
	
	KILL ^TMPItemDefault($j)
	
	q ret_"^"_RowidStr
Insert(ItemStr,UserID)
	n (ItemStr,UserID,LogonHospDr,%session)
	set Rowid=""
	set ARCIMDR=$p(ItemStr,"^",1)
	set ContralType=$p(ItemStr,"^",2)
	set ContralKey=$p(ItemStr,"^",3)
	set ActiveFlag="Y"
	set PriorityDR=$p(ItemStr,"^",4)
	set Dose=$p(ItemStr,"^",5)
	set DoseUomDR=$p(ItemStr,"^",6)
	set InstrDR=$p(ItemStr,"^",7)
	set PHFreqDR=$p(ItemStr,"^",8)
	set DuratDR=$p(ItemStr,"^",9)
	set PackQty=$p(ItemStr,"^",10)
	set SkinTest=$p(ItemStr,"^",11)
	set SkinAction=$p(ItemStr,"^",12)
	set RelevanceNo=$p(ItemStr,"^",13)
	set UserAddDR=UserID
	set DateAdd=..%SysDate()
	set TimeAdd=..%SysTime()
	set OrderSeqNo=$p(ItemStr,"^",14)
	set Notes=$p(ItemStr,"^",15)
	set AdmType=$p(ItemStr,"^",16)
	set ExceedReasonDR=$p(ItemStr,"^",17)
	set OrderSpeedFlowRate = $p(ItemStr,"^",18)
    set OrderFlowRateUnit =$p(ItemStr,"^",19)
	set OrderFreqTimeDoseStr =$P($p(ItemStr,"^",20),"@")
	set OrderFreqDispTimeStr =$p(ItemStr,"^",21)
	set OrderPackUOMRowid =$p(ItemStr,"^",22)
	set Obj=##class(User.DHCDocItemDefault).%New()
	if $ISOBJECT(Obj) {
		if ARCIMDR'="" do Obj.DIDARCIMDRSetObjectId(ARCIMDR)
		set Obj.DIDContralType=ContralType
		set Obj.DIDContralKey=ContralKey
		set Obj.DIDActiveFlag=ActiveFlag
		if PriorityDR'="" do Obj.DIDPriorityDRSetObjectId(PriorityDR)
		set Obj.DIDDose=Dose
		if DoseUomDR'="" do Obj.DIDDoseUomDRSetObjectId(DoseUomDR)
		if InstrDR'="" do Obj.DIDInstrDRSetObjectId(InstrDR)
		if PHFreqDR'="" do Obj.DIDPHFreqDRSetObjectId(PHFreqDR)
		if DuratDR'="" do Obj.DIDDuratDRSetObjectId(DuratDR)
		set Obj.DIDPackQty=PackQty
		if OrderPackUOMRowid'="" do Obj.DIDPackUomDRSetObjectId(OrderPackUOMRowid)
		set Obj.DIDSkinTest=SkinTest
		if SkinAction'="" do Obj.DIDSkinActionSetObjectId(SkinAction)
		set Obj.DIDRelevanceNo=RelevanceNo
		do Obj.DIDUserAddDRSetObjectId(UserAddDR)
		set Obj.DIDDateAdd=DateAdd
		set Obj.DIDTimeAdd=TimeAdd
		do Obj.DIDLastUpdateUserSetObjectId(UserAddDR)
		set Obj.DIDLastUpdateDate=DateAdd
		set Obj.DIDLastUpdateTime=TimeAdd
		set Obj.DIDNotes=Notes
		set Obj.DIDAdmType=AdmType
		set Obj.DIDSpeedFlowRate=OrderSpeedFlowRate
		if OrderFlowRateUnit'="" do Obj.DIDFlowRateUnitSetObjectId(OrderFlowRateUnit)
		do Obj.DIDExceedReasonDRSetObjectId(ExceedReasonDR)
		set Obj.DIDOrderFreqTimeDoseStr=OrderFreqTimeDoseStr
		set Obj.DIDOrderFreqWeekStr=OrderFreqDispTimeStr
		do Obj.DIDUserHospDRSetObjectId(LogonHospDr)
		set sc=Obj.%Save()
		if $$$ISERR(sc) {
			s Rowid=""
			QUIT Rowid
		}
		do Obj.%Close()
		set Rowid=Obj.%Id()
	}
	
	QUIT Rowid
}

ClassMethod GetOEPrefTabs(objectType)
{
	n data,t,LOGONLOCDESC,CONTEXT,ActiveObject,type,SaveContextActive,SaveContextAs
	n ChartID,eprChart
	
	;s ^tmpgry("GetOEPrefTabs")=objectType
	s CONTEXT=$g(%request.Data("XCONTEXT",1))
	d ##class(websys.Component).GetComponentMessages(.t,"OEOrder.PrefTabs.EditList")
	
	s PrefType=""
	if objectType="User.SSUser" {
		s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(%session.Data("LOGON.CTLOCID"))
		s objectReference=%session.Data("LOGON.USERID")
	}
	if objectType="User.CTLoc" s objectReference=%session.Data("LOGON.CTLOCID")
	if objectType="User.CTHospital" s objectReference=%session.Data("LOGON.HOSPID")
	
	s appKey="ORDER"_CONTEXT_PrefType
	s appSubKey="OEOrder.PrefTabs.EditList"
	s data=##class(websys.Preferences).GetData(objectType,objectReference,appKey,appSubKey)
	if data="" {
		s appKey="ORDER"_PrefType
		s data=##class(websys.Preferences).GetData(objectType,objectReference,appKey,appSubKey)
	}
	s ChartID=$lg(data,1)
	s eprChartFrameSize=$lg(data,2)
	s TABLIST=$lg(data,3)
	s NoShowAlias=$lg(data,4)
	s NoShowAliasSameCode=$lg(data,5)
	
	s eprChart=""
	if ChartID'="" s eprChart=$Lg(##class(epr.Chart).GetCodeDescriptionFromId(ChartID),1)
	s %request.Data("eprChart",1)=eprChart
	s %request.Data("Chart",1)=ChartID
	s %request.Data("eprChartFrameSize",1)=eprChartFrameSize
	
	for i=1:1:$listlength(TABLIST){
		s %request.Data("TABLIST",i)=$lg(TABLIST,i)
	}

	;s val=$g(%request.Data("OEWIN",1))
	s %request.Data("NoShowAlias",1)=NoShowAlias
	s %request.Data("NoShowAliasSameCode",1)=NoShowAliasSameCode
}

/*
ClassMethod GetOrderPriorRemarks(EpisodeType As %String = "") As %String
{
	s PRNRemarks=1_$C(1)_"PRN"_$C(1)_"PRN"
	s ONERemarks=2_$C(1)_"ONE"_$C(1)_"取药医嘱"
	s OMRemarks=3_$C(1)_"OM"_$C(1)_"自备药"
	s OUTRemarks=4_$C(1)_"OUT"_$C(1)_"出院带药"
	i EpisodeType'="I" {
		s OrderPriorRemarks=OMRemarks
	}else{
		s OrderPriorRemarks=ONERemarks_"^"_OMRemarks
	}
	
	
	q OrderPriorRemarks
}
*/
/// 取得医嘱类型的附加说明.医嘱类型只分为长期医嘱和临时医嘱."自备药"等只作为医嘱类型的附加说明
/// w ##class(web.DHCDocOrderCommon).GetOrderPriorRemarks("I")
ClassMethod GetOrderPriorRemarks(EpisodeType As %String = "", type As %String = "", EpisodeID = "") As %String
{
 
	s Delimiter="^"
	if (type="JSON"){
		s PRNRemarks="PRN:"_..%Translate("oeorder.oplistcustom.new.csp","PRN")
		s ONERemarks="ONE:"_..%Translate("oeorder.oplistcustom.new.csp","取药医嘱")
		s OMRemarks="OM:"_..%Translate("oeorder.oplistcustom.new.csp","自备药")
		s OUTRemarks="OUT:"_..%Translate("oeorder.oplistcustom.new.csp","出院带药")
		s ZTRemarks="ZT:"_..%Translate("oeorder.oplistcustom.new.csp","嘱托")
		
		s Delimiter=";"
	}else{
		s PRNRemarks=1_$C(1)_"PRN"_$C(1)_"PRN"
		s ONERemarks=2_$C(1)_"ONE"_$C(1)_..%Translate("oeorder.oplistcustom.new.csp","取药医嘱")
		s OMRemarks=3_$C(1)_"OM"_$C(1)_..%Translate("oeorder.oplistcustom.new.csp","自备药")
		s OUTRemarks=4_$C(1)_"OUT"_$C(1)_..%Translate("oeorder.oplistcustom.new.csp","出院带药")
		s ZTRemarks=5_$C(1)_"ZT"_$C(1)_..%Translate("oeorder.oplistcustom.new.csp","嘱托")
	}
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	i GetStayStatusFlag=1{
		s OrderPriorRemarks=OMRemarks_Delimiter_ZTRemarks_Delimiter_ONERemarks
	}elseif EpisodeType="I" {
		s OrderPriorRemarks=ONERemarks_Delimiter_OMRemarks_Delimiter_ZTRemarks
	}else{
		s OrderPriorRemarks=OMRemarks_Delimiter_ZTRemarks
	}
	q OrderPriorRemarks
}

/*
ClassMethod GetOrderFlowRateUnit() As %String
{
	s ret=""
	s rowid=0 f  s rowid=$o(^OEC("SFR",rowid)) q:rowid=""  d
	.s code=$p($g(^OEC("SFR",rowid)),"^",1)
	.s desc=$p($g(^OEC("SFR",rowid)),"^",2)
	.i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	.e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	q ret
}
*/
/// w ##class(web.DHCDocOrderCommon).GetOrderFlowRateUnit()
ClassMethod GetOrderFlowRateUnit(type As %String = "") As %String
{
	Set langid=..%LanguageID()
	s ret=""
	s rowid=0 f  s rowid=$o(^OEC("SFR",rowid)) q:rowid=""  d
	.s code=$p($g(^OEC("SFR",rowid)),"^",1)
	.s desc=$p($g(^OEC("SFR",rowid)),"^",2)
	.s desc=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",desc,langid)
	.i type="JSON" d
	..i ret="" s ret=rowid_":"_desc
	..e  s ret=ret_";"_rowid_":"_desc
	.else  d
	..i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	..e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	q ret
}

ClassMethod GetDocHICApproved(DoctorID As %String)
{
	s HICApproved=""
	Q:'$D(^CTPCP(+DoctorID,3)) HICApproved 
	s HICApproved=$p($g(^CTPCP(+DoctorID,3)),"^",31)
	Quit HICApproved
}

// 2012.4.12

ClassMethod GetOperationLoc(anaId As %String, LogonDepRowId As %String) As %String
{
	n (anaId,LogonDepRowId)
  	Q:anaId="" ""
  	s opaId=""
	s curOpaId="" f  s curOpaId=$o(^DHCANOPArrange(0,"Adm",+anaId,curOpaId)) q:curOpaId=""  d
	.i anaId=$p(^DHCANOPArrange(curOpaId),"^",2) s opaId=curOpaId
  
	q:opaId="" ""

  	s RecLoc=$p($g(^DHCANOPArrange(opaId)),"^",54)
  	s RecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecLoc)
 	s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_""
 	
  	s LogonDepDesc=##class(web.DHCDocOrderCommon).GetLocDesc(LogonDepRowId)
  	s ret=ret_$C(2)_LogonDepRowId_$C(1)_LogonDepDesc_$C(1)_"Y"_$C(1)_""
 	Q ret
}

ClassMethod GetArcimDescByOEItemID(OEItemID As %String) As %String
{
	n (OEItemID)
	Q:OEItemID="" ""
	s ArcimRowid=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",2)
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	
	Q ArcimDesc
}

/// creator:郭荣勇
/// date:2011-09-06
/// desc:删除管制药品申请
/// table:
ClassMethod DeleteAntibApply(AntibApplyRowid As %String) As %String
{
	&sql(Delete From SQLUser.DHC_Doc_AntibioticApply where AA_Rowid=:AntibApplyRowid)
	Q SQLCODE
}

/// creator:李宇峰
/// date:2012-08-01
/// desc:删除管制药品使用目的
/// table:
ClassMethod DeleteAntReason(AntReasonId As %String) As %String
{
	&sql(Delete From SQLUser.DHC_AntUsePurpose where DAUP_Rowid=:AntReasonId)
	Q SQLCODE
}

/// w ##class(web.DHCDocOrderCommon).GetAntUseReason()
ClassMethod GetAntUseReason(type As %String = "") As %String
{
	s ret=""
	s rowid=0 f  s rowid=$o(^DCTAR("AUR",rowid)) q:rowid=""  d
	.s code=$p($g(^DCTAR("AUR",rowid)),"^",1)
	.s desc=$p($g(^DCTAR("AUR",rowid)),"^",2)
	.i type="JSON" d
	..i ret="" s ret=rowid_":"_desc
	..e  s ret=ret_";"_rowid_":"_desc
	.e  d
	..i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	..e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	q ret
}

/// w ##class(web.DHCDocOrderCommon).CheckPracticeFlag()
ClassMethod CheckPracticeFlag(UserID) As %String
{
	n (CTPCPRowId,%session)
	s UserID=%session.Data("LOGON.USERID")
	s ^DHCXPTest("UserID")=UserID
	s CTPCPRowId=$p(^SSUSR("SSUSR",UserID),"^",9)
	q:CTPCPRowId="" 0
	s CarPrvTypeCode=""
	i CTPCPRowId'="" d
	.s CarPrvTypeRowid=$P($g(^CTPCP(CTPCPRowId,1)),"^",4)
	.s CarPrvTypeCode=$P($g(^CT("CPT",CarPrvTypeRowid)),"^",1)
	Q:CarPrvTypeCode="PRACTICE" 1
	Q 0
}

ClassMethod GetInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetInstrExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","GetInstr","b")
	//s ^liyufeng("GetInstrExecute")=code
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=$$ALPHAUP^SSUTIL4(code)
 	Set InstrRowid=0
 	For  Set InstrRowid=$o(^PHCIN(InstrRowid)) Quit:InstrRowid=""  do
 	.Set code1=$$ALPHAUP^SSUTIL4($p(^PHCIN(InstrRowid),"^",1))
 	.Set desc=$$ALPHAUP^SSUTIL4($p(^PHCIN(InstrRowid),"^",2))
 	.Quit:(code1'[code)&&(desc'[code)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(InstrRowid,desc,code1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetInstr(code As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

/// w ##class(web.DHCDocOrderCommon).GetCareProvType(2610)
ClassMethod GetCareProvType(UserID) As %String
{
	q:UserID="" ""
	s DoctorDR=$P(^SSU("SSUSR",UserID),"^",14)
	q:DoctorDR="" ""
	s CareProvTypeDR=$p($g(^CTPCP(DoctorDR,1)),"^",4)
	q:CareProvTypeDR="" ""
	s InternalType=$p($g(^CT("CPT",CareProvTypeDR)),"^",4)
	q InternalType
}

/// creator:李宇峰
/// date:2012-08-22
/// description: 由管制分类的代码取其描述
/// input:  
/// output: 药品管制分类的描述
ClassMethod GetPHCPoisonByCode(Code As %String)
{
	Set Desc=""
	Set Rowid=$o(^PHCPO(0,"Code",Code,0))
	if Rowid'="" Set Desc=$p(^PHCPO(Rowid),"^",2)
	Quit Desc
}

/// creator:郭荣勇
/// date:2011-10-14
/// desc:转换日期格式函数
/// table:
ClassMethod ConverDate(Date As %String, FormatFrom As %Integer, FormatTo As %Integer) As %String
{
	s DateFrom=$zdh(Date,FormatFrom)
	
	q $zd(DateFrom,FormatTo)
}

/// creator:郭荣勇
/// date:2011-10-14
/// desc:日期比较函数
/// table:
/// output:1 date<date1,2 date=date1,3 date>date1,0 未比较
ClassMethod CompareDate(Date As %String, Date1 As %String) As %String
{
	s $ZT="CompareDateError"
	q:(Date="")||(Date1="") 0
	i $l(Date,"-")=3 s Date=$zdh(Date,3)
	i $l(Date,"/")=3 s Date=$zdh(Date,4)
	
	i $l(Date1,"-")=3 s Date1=$zdh(Date1,3)
	i $l(Date1,"/")=3 s Date1=$zdh(Date1,4)
	
	i Date<Date1 {
		q 1
	}elseif Date=Date1 {
		q 2
	}elseif Date>Date1 {
		q 3
	}
	
	q 0
CompareDateError
	q 0
}

/// creator:郭荣勇
/// date:2012-04-27
/// desc:得到日期差异(年差异^月差异^日差异)
/// table:
/// output:年差异^月差异^日差异
ClassMethod GetDiffDateNum(Date As %String, Date1 As %String) As %String
{
	s $ZT="GetDiffDateNum"
	q:(Date="")||(Date1="") 0
	i $l(Date,"-")=3 s Date=$zdh(Date,3)
	i $l(Date,"/")=3 s Date=$zdh(Date,4)
	
	i $l(Date1,"-")=3 s Date1=$zdh(Date1,3)
	i $l(Date1,"/")=3 s Date1=$zdh(Date1,4)
	
	s DiffDay=Date-Date1
	Q DiffDay
GetDiffDateNum
	q 0
}

/// w ##class(web.DHCDocOrderCommon).GetNurMastOrderPriorRowid("510||161")
ClassMethod GetNurMastOrderPriorRowid(LinkedMasterOrderRowid) As %String
{
	q:LinkedMasterOrderRowid="" 0
	s OrderPriorRowid=0
	s ord=$p(LinkedMasterOrderRowid,"||",1)
	s child=$p(LinkedMasterOrderRowid,"||",2)
	s OrderPriorRowid=$p($g(^OEORD(ord,"I",child,1)),"^",8)
	q OrderPriorRowid
}

/// creator:guorongyong
/// date:2013-03-20
/// desc:判断医嘱需开特定医嘱设置
/// input:EpisodeID,ARCIMRowidStr 医嘱项字符串 医嘱优先级Rowid^医嘱项Rowid!医嘱优先级Rowid^医嘱项Rowid
/// output:标识^医嘱项描述
/// w ##class(web.DHCDocOrderCommon).CheckSpecOrdLinked(39,"5^1270||1!5^1028||1")
ClassMethod CheckSpecOrdLinked(EpisodeID, ARCIMRowidStr, HospId As %String = "") As %String
{
	s ^tmpgry("CheckSpecOrdLinked")=EpisodeID_","_ARCIMRowidStr
	s myflag=0,myDesc="",AllOrdLinkStr=""
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	Set langid=..%LanguageID()
	for i=1:1:$l(ARCIMRowidStr,"!") {
		s ARCIMRowidItem=$p(ARCIMRowidStr,"!",i)
		s PriorRowid=$p(ARCIMRowidItem,"^",1)
		s ArcimRowid=$p(ARCIMRowidItem,"^",2)
		s OrdLinkStr=##class(web.DHCDocOrdLinkContr).GetOrdLinkStr(ArcimRowid,HospId)
		continue:OrdLinkStr=""
		s OrdLinkStr="^"_OrdLinkStr_"^"
		;s PriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		s findArcimitem=""
		if OrderRowid'="" {
			;循环取出医嘱
			s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")!(findArcimitem'="")  d
			.s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
			.s itemrowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
			.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
			.e  s statcode=""
			.Q:(statcode'="V")
			.s itemPriorRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",8)
			.;s itemPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(itemPriorRowid)
			.;if (OrdLinkStr[("^"_itemrowid_"^"))&&(PriorFlag=itemPriorFlag) d
			.if (OrdLinkStr[("^"_itemrowid_"^")) d
			..s findArcimitem=itemrowid
		}
		;查找本次审核的医嘱项串
		if findArcimitem="" {
			for j=1:1:$l(ARCIMRowidStr,"!") {
				continue:i=j
				s ARCIMRowidItemLocal=$p(ARCIMRowidStr,"!",j)
				s PriorRowidLocal=$p(ARCIMRowidItemLocal,"^",1)
				s ArcimRowidLocal=$p(ARCIMRowidItemLocal,"^",2)
				;s itemPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowidLocal)
				;if (OrdLinkStr[("^"_ArcimRowidLocal_"^"))&&(PriorFlag=itemPriorFlag) {
				if (OrdLinkStr[("^"_ArcimRowidLocal_"^")) {
					s findArcimitem=ArcimRowidLocal
					Quit
				}
			}
		}
		Q:findArcimitem'=""
		;没有找到条件医嘱
		s myflag=1
		s OrdLinkStrArcimRowid("ArcimRowid",i)=ArcimRowid
		s LinkArcim=##class(web.DHCDocOrdLinkContr).GetOrdLinkStr(ArcimRowid,HospId)
		if ($G(OrdLinkStrArcimRowid("ArcimRowidLink",ArcimRowid))'=""){
			s OrdLinkStrArcimRowid("ArcimRowidLink",ArcimRowid)=$G(OrdLinkStrArcimRowid("ArcimRowidLink",ArcimRowid))_"^"_LinkArcim
		}else{
			s OrdLinkStrArcimRowid("ArcimRowidLink",ArcimRowid)=LinkArcim	
			}
	}
	if myflag=1 {
		s i=0
		for{
			s i=$O(OrdLinkStrArcimRowid("ArcimRowid",i))
			q:i=""
			s ArcimRowid=$g(OrdLinkStrArcimRowid("ArcimRowid",i))
			s AlertArcimDesc=$p($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1)),"^",2)
			s AlertArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",AlertArcimDesc,langid)
			s OrdLinkStr=$G(OrdLinkStrArcimRowid("ArcimRowidLink",ArcimRowid))
			for j=1:1:$l(OrdLinkStr,"^") {
				s OrdLinkDR=$P(OrdLinkStr,"^",j)
				continue:OrdLinkDR=""
				s OrderName=$p($g(^ARCIM(+OrdLinkDR,$P(OrdLinkDR,"||",2),1)),"^",2)
				s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
				if myDesc="" s myDesc=OrderName
				else  s myDesc=myDesc_","_OrderName
			}
			s myDesc=AlertArcimDesc_..%Translate("oeorder.oplistcustom.new.csp","(条件医嘱:")_myDesc_")"
		}
	}
	
	Q myflag_"^"_myDesc
}

/// w ##class(web.DHCDocOrderCommon).GetLocalInfusionInstr()
ClassMethod GetLocalInfusionInstr(CurLogonHosp As %String = "") As %String
{
	s LocalInfusionInstrStr=..%GetConfig("OPInfusionInstr",CurLogonHosp)
	Q LocalInfusionInstrStr
}

/// 得到剂型Rowid
ClassMethod GetArcimFormRowid(DrgformRowid As %String) As %String
{
	Q:DrgformRowid="" ""
	s PHCDRowid=+DrgformRowid
	s ChildSub=$p(DrgformRowid,"||",2)
	s FormRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)
	i FormRowid'="" s FormDesc=$P($G(^PHCF(FormRowid)),"^",2)
	q FormRowid
}

/// CreatDate:    2013.05.14
/// Description:  得到是否是或者有检查医嘱标识
/// Table:       
/// Input:        InStr:ArcimROWID字符串
/// Others:       为自动弹出检查申请单
/// Return:       1 是 ,  0 不是或不存在
ClassMethod GetItemServiceFlag(InStr As %String) As %String
{
	n (InStr)
	s num=1,retStr="",Flag=0
	f num=1:1:$l(InStr,"^") q:Flag=1  d
	.s ArcimRowid=$p(InStr,"^",num)
	.q:ArcimRowid=""
	.s ServerMaterial=""
	.s ItemCatDR=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	.i ItemCatDR'="" d
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	..s ServerMaterial=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",6)
	..if (ServerMaterial="Service")||(ServerMaterial="S") s Flag=1
	
	q Flag
}

/// CreatDate:    2017.01.14
/// Description:  得到将审核医嘱中需要做检查、检验申请的医嘱项目与序号
/// Table:       
/// Input:        InStr:将审核医嘱字符串
/// Others:       为自动弹出检查、检验申请单
/// Return:       需要做检查、检验申请的数据, 空
/// 原GetItemServiceARCIMStrMethod方法，修正为也返回检验数据，---tanjishan
ClassMethod GetItemServiceARCIMStrMethod(EpisodeID As %String, OrderItemStr As %String, DoctorID As %String, LocID As %String) As %String
{
	n (EpisodeID,OrderItemStr,DoctorID,LocID)
	s ARCIMStr="",AutoGenARCIMStr=""
	Q:OrderItemStr="" ""
	s Hospid=$p(^CTLOC(LocID),"^",22)
	Set OrdItemCount=$L(OrderItemStr,$c(1))
	for i=1:1:OrdItemCount {
		s OrdItem=$p(OrderItemStr,$c(1),i)
		continue:OrdItem=""
		s ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		s ItemQty=$p(OrdItem,"^",14)
		s OrderSeqNo=$p(OrdItem,"^",20)
		s specimen=$p(OrdItem,"^",28)
		s RecDepRowid=$p(OrdItem,"^",8)
		s AdmReasonDr=$replace($p(OrdItem,"^",9),$c(10),"")
		s NotifyClinician=$p(OrdItem,"^",30)
		s OrderBodyPartLabel=$p(OrdItem,"^",64)
		s OrderBodyPartLabel=$TR(OrderBodyPartLabel,"*","^")
		s OrderBodyPartLabel=$TR(OrderBodyPartLabel,"@","%")
		s startdate=$p(OrdItem,"^",4)
		i startdate'="" {
			if $l(startdate,"/")=3 s startdate=$zdh(startdate,4)
  			if $l(startdate,"-")=3 s startdate=$zdh(startdate,3)
		}else{s startdate=..%SysDate()}
		s startdate=$zd(startdate,3)
		s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		
		//后处理
		s arDisData=""
		
		s ServiceFlag=..GetItemServiceFlag(ARCIMRowid)
		i (ServiceFlag=1) {
			s TarType=##Class(web.DHCAPPExaReportQuery).GetTraType(ARCIMRowid)
			s OutOneARCIMStr=NotifyClinician_"^"_RecDepRowid_"^"_startdate_"^"_ARCIMRowid_"^"_OrderSeqNo_"^"_OrderBodyPartLabel_"^^^"_AdmReasonDr_"^"_ItemQty
			;是否自动生成检查申请单
			s AutoGenFlag=##Class(web.DHCAPPExaRepCom).GetItemPopFlag(ARCIMRowid)
			
			;是否为多部位
			s LinkPartNo =##Class(web.DHCAPPExaReportQuery).isExistLinkPartNoTraID(ARCIMRowid,Hospid)

			i AutoGenFlag="Y",TarType'="P",LinkPartNo'=1 {
			
				i AutoGenARCIMStr="" s AutoGenARCIMStr=OutOneARCIMStr
				e  s AutoGenARCIMStr=AutoGenARCIMStr_"@"_OutOneARCIMStr
			}else{
				i ARCIMStr="" {
					s ARCIMStr=OutOneARCIMStr
				}else{
					s ARCIMStr=ARCIMStr_"@"_OutOneARCIMStr
				}
			}
		}elseif (OrderType="L"){
			s OutOneARCIMStr=NotifyClinician_"^"_RecDepRowid_"^"_startdate_"^"_ARCIMRowid_"^"_OrderSeqNo_"^"_OrderBodyPartLabel_"^"_arDisData_"^"_specimen_"^"_AdmReasonDr_"^"_ItemQty
			i AutoGenARCIMStr="" s AutoGenARCIMStr=OutOneARCIMStr
			e  s AutoGenARCIMStr=AutoGenARCIMStr_"@"_OutOneARCIMStr
		}
	}
	s BaseInfo=EpisodeID_"^"_DoctorID_"^"_LocID
	if ARCIMStr'="" s ARCIMStr=BaseInfo_"!"_ARCIMStr
	if AutoGenARCIMStr'="" s AutoGenARCIMStr=BaseInfo_"!"_AutoGenARCIMStr
	
	q ARCIMStr_$C(2)_AutoGenARCIMStr
}

/// creater   lxz
/// desc		 用来获得一条医嘱的ID对应的医嘱详细信息,可用来扩展做统一接口.以后的医嘱信息往后拼接即可
/// InPut	 OrderIDInput：医嘱ID
/// OutPut	 医嘱信息串用^分割.顺序如下。可往后扩展拼接。
/// 	医嘱ID——1
/// 	医嘱名称——2
/// 	医嘱价格——3
/// 	医嘱数量——4
/// 	数量单位——5
/// 	接收科室——6
/// 	处方号——7
/// 	单价——8
/// 	收费状态——9
/// 	医嘱状态(Code,Desc)——10
/// 	医嘱有效价格(部分退药后剩下的价格,如果没有退药和医嘱价格相同)——11
/// 	医嘱有效数量——12
/// 	退药数量——13
/// 	医嘱发药状态——14
/// 	接收科室——15
/// 	下医嘱人——16
/// 	下医嘱科室——17
/// 	下医嘱日期——18
/// 	下医嘱时间——19
/// 	医嘱开始日期——20
/// 	医嘱开始时间——21
/// 	医嘱结束日期——22
/// 	医嘱结束时间——23
/// 	医嘱停止日期——24
/// 	医嘱停止时间——25
/// 	标本号——26
/// 	标本——27
/// 	是否皮试标志(Y)——28
/// 	皮试备注——29
/// 	皮试结果——30
/// 	医嘱备注——31
/// 	高值条码——32
/// 	关联医嘱ID-33
/// 		接收科室ID-34
/// w ##class(web.DHCDocOrderCommon).GetOrderMesage("14||1")
ClassMethod GetOrderMesage(OrderIDInput As %String = "") As %String
{
	s OrderID=+OrderIDInput
	s SubID=$P(OrderIDInput,"||",2) 
	Q:((OrderID="")||(SubID="")) ""
	s AdmRowID=$P($G(^OEORD(OrderID)),"^",1)
	s PatType=$P(^PAADM(AdmRowID),"^",2)
	s PAADMRegConDisDR=$P($G(^PAADM(AdmRowID,"DHC")),"^",25)
	s admloc=$p(^PAADM(AdmRowID),"^",4)
	s AdmLocHospDr=$p($g(^CTLOC(admloc)),"^",22)
	s GetStr=$$GetOEORIMesage(OrderID,SubID,PatType,AdmRowID,AdmLocHospDr)
	Q GetStr
GetOEORIMesage(OrderID,SubID,PatType,AdmRowID,AdmLocHospDr)
	s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2)  ;
	s statcode="V"
	s statDesc="核实"
	s TtemStat=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",13) ;OEORI_Billed
	i TtemStat'="" d
	.s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	.s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2)
	;Q:($g(statcode)'="V")&&(OrderIDInput="") ""
	s OrderBilled=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",5) ;OEORI_Billed
	;Q:(OrderBilled="P")&&(OrderIDInput="") ""
	s OrderDoseUOMRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",3) ;OEORI_Unit_DR
	s ARCIMPHCDFDR=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",12) ;OEORI_ItmMast_DR->ARCIM_PHCDF_DR
	s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrderIDInput) //$P($G(^OEORD(OrderID,"I",SubID,2)),"^",1) ;OEORI_DoseQty
	s InsType=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s OrderSttDate=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",9) ;OEORI_SttDat
	s OrderPriorRowid=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",8) ; OEORI_Priority_dr
	s OrderInstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7) ; OEORI_Instr_DR
	s OrderLinkTo=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",1)  ;OEORI_LinkToOrder
	s OEORIPrice=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",25)  ;OEORI_Price 自定义价格
	s OrderRecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6) ;OEORI_RecDep_DR
	s OEORIOEORIDR=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",39) ;OEORI_OEORI_DR ；关联医嘱ID
	s OrderFirstDayTimes=$p($G(^OEORD(+OrderID,"I",SubID,1)),"^",18)
	s OrderRecDep=""
	if OrderRecDepRowid'="" s OrderRecDep=$P(^CTLOC(OrderRecDepRowid),"^",2)
	if OrderRecDep["-" s OrderRecDep=$P(OrderRecDep,"-",2)
	s OrderBillTypeRowid=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18) ;OEORI_BBExtCode
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s OrderType=""
	if ItemCatDr'="" d
	.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7) ; OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
	s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4) ;OEORIQtyPackUOM
	//s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14) 
	s ARCIMBillingUOM=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderIDInput)
	s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOM)
	;
	s OrderPrescNo=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",14) ;OEORI_PrescNo
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	s OrderDurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6) ;OEORI_Durat_DR
	s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1) ;下医嘱人
	if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	s UserDepart=""  ;下医嘱科室
	s UserDepartId=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",2)
	If UserDepartId'=""  d
	.Set UserDepart=$P($G(^CTLOC(UserDepartId)),"^",2)
	.if UserDepart["-" s UserDepart=$P(UserDepart,"-",2)
	s XUser=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",29)	;停医嘱人
	if XUser'="" Set XUser=$P($G(^CTPCP(XUser,1)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",7)	;下医嘱日期
	if OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",17)	;下医嘱时间
	if OrderTime'="" s OrderTime=..%ZT(OrderTime,2)
	s OrderStarDate=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",9) ;医嘱开始日期
	if OrderStarDate'="" s OrderStarDate=$zd(OrderStarDate,3)
	s OrderStarTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",10) ;医嘱开始时间
	if OrderStarTime'="" s OrderStarTime=..%ZT(OrderStarTime,2)
	s OrderEndDate=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",9) ;医嘱结束日期
	if OrderEndDate'="" s OrderEndDate=$zd(OrderEndDate,3)
	s OrderEndTime=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",10) ;医嘱结束时间
	if OrderEndTime'="" s OrderEndTime=..%ZT(OrderEndTime,2)
	s OrderXDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34) ;医嘱停止日期
	if OrderXDate'="" s OrderXDate=$zd(OrderXDate,3)
	s OrderXTime=$p($g(^OEORD(OrderID,"I",SubID,2)),"^",15) ;医嘱停止时间
	if OrderXTime'="" s OrderXTime=..%ZT(OrderXTime,2)
	s LabEpisodeNo=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",20) ;标本号
	s OrdLabSpec=$$GetSpecDesc(OrderID_"||"_SubID) ;标本
	s MaterialBarCode=$p($G(^OEORD(OrderID,"I",SubID,"DHC")),"^",14) ;高值条码
	s OrdSkinTest=$p($g(^OEORD(OrderID,"I",SubID,5)),"^",2) ;皮试
	s OrdAction=$p($g(^OEORD(OrderID,"I",SubID,11)),"^",21)	;皮试备注
	i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	s OrdDepProcNotes=$g(^OEORD(OrderID,"I",SubID,"DEP",1)) ;备注
	s OrdSkinTestResult=""	;皮试结果
	i OrdSkinTest="Y" d
	.s abnorm=$p($g(^OEORD(OrderID,"I",SubID,11)),"^",3)
	.i abnorm="Y" s OrdSkinTestResult="阳性"
	.i abnorm="N" s OrdSkinTestResult="阴性"
	s PriorRowid=""
	s InstrRowid=""
	s LinkTo=""
	s OEPrice=""
	s OrderBillType=""
	s Qty=##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	//s ExpStr=PAADMRegConDisDR_"^"_OrderID_"||"_SubID_"^"_""_"^"_AdmRowID_"^"_OrderRecDepRowid
	s ExpStr=OrderID_"||"_SubID_"^"_""_"^"_AdmRowID_"^"_OrderRecDepRowid_"^"_AdmLocHospDr
	;转换系数
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimID)
	s ConFac=1
	if (INCIRowid'="")&&(ARCIMBillingUOM'="")  d
	.s ConFac=##class(web.DHCDocOrderEntry).GetConFac(ArcimID,INCIRowid,ARCIMBillingUOM)
	s ProtocolPackUOMDR=$p($g(^OEORD(OrderID,"I",SubID,"DHC")),"^",13)
	;通过转换系数转成基本单位
	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ArcimID, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	s OrderPrice=$P(retPrice,"^",1)
	s DiscPrice=$P(retPrice,"^",2)
	s InsPrice=$P(retPrice,"^",3)
	s PatPrice=$P(retPrice,"^",4)
	s OrderPrice=$fn($P(retPrice,"^",1),"",4)
	i OEORIPrice'="" s OrderPrice=OEORIPrice  ;如果自定义价格存在则使用自定义价格
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P($G(^PAC("ADMREA",OrderBillTypeRowid)),"^",2)
	i OrderDoseQty'="" d
	. i OrderDoseQty<1,OrderDoseQty'["-" s OrderDoseQty="0"_$number(OrderDoseQty)
	i OrderType'="R" d
	.s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	.s OrderPackQty=DoseqtySum
	;s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderPackQty'="" d
	. i OrderPackQty<1 s OrderPackQty="0"_$number(OrderPackQty)
	s DepProcNotes=$g(^OEORD(OrderID,"I",SubID,"DEP",1))
	if (((OrderPackQty=0)||(OrderPackQty=""))&&(OrderType="R"))  d  ;如果没有填数量则自动计算数量
	.s OrderPrice=$fn((OrderPrice/ConFac),"",4)  ;整包装的单价要转换
	.s DiscPrice=$fn((DiscPrice/ConFac),"",4)
	.s InsPrice=$fn((InsPrice/ConFac),"",4)
	.s PatPrice=$fn((PatPrice/ConFac),"",4)
	.s PHCDUFactor=1
	.s:OrderDurRowid'="" PHCDUFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
	.i OrderDoseQty["-" d
	..k OrderDoseQtyList
	..s Qty=0
	..for index=1:1:$l(OrderDoseQty,"-") d
	...s OneQty=##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,$p(OrderDoseQty,"-",index))
	...s OrderDoseQtyList(index)=OneQty
	...s Qty=Qty+OneQty
	..if (+OrderFirstDayTimes>0) d
	...s FirstDayQty=0
	...for index=1:1:OrderFirstDayTimes d
	....s Qtyindex=$o(OrderDoseQtyList(""),-1)-OrderFirstDayTimes+index
	....s FirstDayQty=FirstDayQty+$g(OrderDoseQtyList(Qtyindex))
	...s OrderPackQty=FirstDayQty+(Qty*(PHCDUFactor-1))
	..e  s OrderPackQty=Qty*PHCDUFactor
	.e  d
	..s Qty=##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid,ARCIMPHCDFDR,OrderDoseQty)
	..if (+OrderFirstDayTimes>0) d
	...for index=1:1:OrderFirstDayTimes d
	....s OrderPackQty=OrderPackQty+(+Qty)
	...s OrderPackQty=OrderPackQty+($P(^PHCFR(OrderFreqRowid),"^",2)*(PHCDUFactor-1))
	..e  s OrderPackQty=+Qty*$P(^PHCFR(OrderFreqRowid),"^",2)*PHCDUFactor
	.s OrderSum=(OrderPackQty*OrderPrice)
	
	.s bsUOMph=$p($g(^PHCD(+ARCIMPHCDFDR,"DF",$p(ARCIMPHCDFDR,"||",2),2)),"^",4)
	.s BaseUomDesc=$P(^CT("UOM",bsUOMph),"^",2)
	.;展示的时候单位和数量匹配
	.s OrderPackUOM=BaseUomDesc
	s OrderSum=$fn(OrderSum,"",4)
	s statcode=statcode_","_statDesc
	;按照基本单位退药单位和返回的数量单位一直
	s HaveDispensing=0,dstatus=""
	s DspConfirmQty=0     
	s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OrderID_"||"_SubID,dis)) Q:dis=""  d
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.s HaveDispensing=1
	.i dstatus="R" d                             
	..s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)  
	..s DspConfirmQty=DspConfirmQty+dconfirmqty  
	i DspConfirmQty'="" d
	.s DspConfirmQty=DspConfirmQty
	i HaveDispensing=1 d
	.i dstatus="C" s dstatus="已发"
	.i dstatus="TC" s dstatus="未发"
	.i dstatus=""  s dstatus="未打包"
	.i dstatus="R" s dstatus="已退药"
	s ValueNU=(OrderPackQty-DspConfirmQty) 
	s ValueSum=ValueNU*OrderPrice	;有效价格
	s ValueSum=$fn(ValueSum,"",4)
	s ValueNU=ValueNU_OrderPackUOM	;有效数量
	s DspConfirmQty=DspConfirmQty_OrderPackUOM ;退药数量
	;医嘱ID，医嘱名称，医嘱价格，医嘱数量，数量单位，接收科室，处方号，单价,收费状态，医嘱状态
	;医嘱有效价格(部分退药后剩下的价格,如果没有退药和医嘱价格相同),有效数量,退药数量,医嘱发药状态
	;下医嘱人,下医嘱科室,停医嘱人,
	;下医嘱日期，下医嘱时间，医嘱开始日期，遗嘱开始时间，医嘱结束日期，医嘱结束时间，医嘱停止日期，医嘱停止时间
	;标本号；标本,是否皮试标志(Y),皮试备注，皮试结果，医嘱备注
	;高值条码
	s Str=OrderID_"||"_SubID_"^"_OrderName_"^"_OrderSum_"^"_OrderPackQty_"^"_OrderPackUOM_"^"_OrderRecDep_"^"_OrderPrescNo_"^"_OrderPrice_"^"_OrderBilled_"^"_statcode
    s Str=Str_"^"_ValueSum_"^"_ValueNU_"^"_DspConfirmQty_"^"_dstatus
    s Str=Str_"^"_UserAdd_"^"_UserDepart_"^"_XUser
    s Str=Str_"^"_OrderDate_"^"_OrderTime_"^"_OrderStarDate_"^"_OrderStarTime_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderXDate_"^"_OrderXTime
    s Str=Str_"^"_LabEpisodeNo_"^"_OrdLabSpec_"^"_OrdSkinTest_"^"_OrdAction_"^"_OrdSkinTestResult_"^"_OrdDepProcNotes
    s Str=Str_"^"_MaterialBarCode_"^"_OEORIOEORIDR_"^"_OrderRecDepRowid
    Q Str
GetSpecDesc(OrderItemRowid)
 s SpecStr=""
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
 s HospitalId=""
 s UserDepartmentDR=$p($g(^OEORD(OrderRowid,"I",Childsub,7)),"^",2)
 i UserDepartmentDR'="" s HospitalId=$p(^CTLOC(UserDepartmentDR),"^",22)
 s HospitalCode=..GetCurrentSYSHospitalCode(HospitalId)
 
 s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 . s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 . i $d(^DHCLISBSVersion(1)) d
 .. s SpecDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,$g(HospitalCode)),$c(2),2)
 . e  d
 .. s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 . i SpecStr="" s SpecStr=SpecDesc
 . e  s SpecStr=SpecStr+","+SpecDesc
 Q SpecStr
}

/// creater	lxz 13-11-08
/// desc 验证安全组是否对一个医嘱项有可开医嘱权限
/// input ArcimRowID:医嘱项RowID GroupRowID：安全组RowiD
/// OutPut Y-有  ;N 没有
/// w ##class(web.DHCDocOrderCommon).OrdRootCheck("36990||1",100)
ClassMethod OrdRootCheck(ArcimRowID As %String, GroupRowID As %String) As %String
{
	Q:((ArcimRowID="")||(GroupRowID="")) "N"
	s OrdRoot="N"
	;验证医嘱录入权限设置
	s ArcItmcatID=$P(^ARCIM(+ArcimRowID,$P(ArcimRowID,"||",2),1),"^",10)
	s OrderCategory=$P(^ARC("IC",ArcItmcatID),"^",8) 
	s MainSub="" 
	s ord=0 f  s ord=$o(^SSU("SSGRP",GroupRowID,"SSORD",ord)) q:ord=""  d
	.s MianStr=$G(^SSU("SSGRP",GroupRowID,"SSORD",ord))
	.s MainGetID=$P(MianStr,"^",1)
	.s SubGetID=$P(MianStr,"^",5)
	.if MainSub'=""  d
	..if (MainGetID'="") d
	...if ((("^"_MainSub_"^")'[("^"_MainGetID_"^"))) d
	....s MainSub=MainSub_"^"_MainGetID
	...s SubSub=$G(TempRootCheck(MainGetID))
	...if (SubGetID'="")&&(("^"_SubSub_"^")'[("^"_SubGetID_"^"))  d
	....if SubSub="" s SubSub=SubGetID
	....else  s SubSub=SubSub_"^"_SubGetID
	....s TempRootCheck(MainGetID)=SubSub
	.else  d
	..if MainGetID'=""  d
	...s MainSub=MainGetID
	...if SubGetID'="" d
	....s SubSub=SubGetID
	....s TempRootCheck(MainGetID)=SubSub
	if ("^"_MainSub_"^")[("^"_OrderCategory_"^")  d
	.s SubItemCatStr=$G(TempRootCheck(OrderCategory))
	.if SubItemCatStr="" s OrdRoot="Y"
	.else  d
	..if (("^"_SubItemCatStr_"^")[("^"_ArcItmcatID_"^"))  d
	...s OrdRoot="Y"
	Q OrdRoot
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String, LogonHospDr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
	i $g(desc)'="" s desc=$$ALPHAUP^SSUTIL4(desc)
	s len=$l(desc)
	Set langid=..%LanguageID()
    s ctlocrowid=0
    f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
    . q:'$d(^CTLOC(ctlocrowid))
    . Q:(LogonHospDr'="")&&($p(^CTLOC(ctlocrowid),"^",22)'=LogonHospDr)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(ctlocrowid)
    . s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
    . s ctlocdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctlocdesc,langid)
    . s desc1=$$ALPHAUP^SSUTIL4(ctlocdesc)
    . s desc1=$e(desc1,1,len)
    . s NO=ctlocrowid
    . s RowId=ctlocrowid
    . //q:desc1'=desc
    . Q:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1 
 	. Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(NO,ctlocdesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ctloclookup(desc As %String, LogonHospDr As %String = "") As %Query(ROWSPEC = "NO:%String,CtLoc:%String")
{
}

ClassMethod FindLocDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// desc 获取科室中的所有医生 
ClassMethod FindLocDocExecute(ByRef qHandle As %Binary, LocID As %String, DocDescIn As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if DocDescIn'="" s DocDescIn=$$ALPHAUP^SSUTIL4(DocDescIn)
 	s Len=$l(DocDescIn)
 	Set langid=..%LanguageID()
 	if LocID'=""  d
    .s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId)) Q:RowId=""  d
    ..s DateActiveFrom=$p($g(^RB("RES",RowId)),"^",22)
	..q:(DateActiveFrom'="")&&(DateActiveFrom>+$H)
	..s DateActiveTo=$p($g(^RB("RES",RowId)),"^",23)
	..q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	..S DocID=$p(^RB("RES",RowId),"^",2)
	..Q:DocID=""
	..s DocCode=$p($G(^CTPCP(DocID,1)),"^",1)
	..s OtherDesc=$p($G(^CTPCP(DocID,3)),"^",28)
	..s DocDesc=$p($G(^CTPCP(DocID,1)),"^",2)
	..Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
	..;if DocDesc'="" s DocDesc=$$ALPHAUP^SSUTIL4(DocDesc)
	..Q:(DocDescIn'="")&&(DocDescIn'=$e(DocDesc,1,Len))
	..if OtherDesc'="" s DocDesc=DocDesc ;_"-"_OtherDesc
 	..Do OutputRowFindLocDoc
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowFindLocDoc
	set Data=$lb(DocID,DocDesc,DocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLocDoc(LocID As %String, DocDescIn As %String = "") As %Query(ROWSPEC = "DocID:%String,DocDesc:%String,DocCode:%String")
{
}

/// lxz
/// desc  获取医嘱状态
/// input OrderRowid医嘱ID
/// OutPut StatusCode 医嘱状态Code
ClassMethod GetOrderStatus(OrderRowid As %String) As %String
{
	q:OrderRowid="" ""
	s StatusCode=""
	s StatusRowId=$p($g(^OEORD(+OrderRowid,"I",$p(OrderRowid,"||",2),1)),"^",13)
	s:StatusRowId'="" StatusCode=$p(^OEC("OSTAT",StatusRowId),"^",1)
	q StatusCode
}

/// lxz
/// desc  医嘱项是否是小时医嘱
/// input ArcimRowId 医嘱项RowiD
/// OutPut 1 是 0不是
ClassMethod IsHourItem(ArcimRowId As %String) As %String
{
	Q:+ArcimRowId=0 0
	s BillUomRowId=$p($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),8)),"^",14)
	s BillUomCode=""
	s:+BillUomRowId'=0 BillUomCode=$p($g(^CT("UOM",BillUomRowId)),"^")
	s BillUomCode=$zcvt($g(BillUomCode),"U")
	Q:BillUomCode="HOUR" 1
	Q 0
}

/// Desc  医嘱项是否是高值材料
/// input ArcimRowId 医嘱项RowiD
/// OutPut N 不是 Y 是
ClassMethod GetIncItmHighValueFlag(ArcimRowid As %String)
{
	n (ArcimRowid)
    s flag=##Class(web.DHCSTMHUI.PCHCOLLSM).GetArcimHighValueFlag(ArcimRowid)
    s flag=$CASE(flag,"Y":"Y",:"N")
	q flag
}

/// lxz
/// Desc  医嘱项权限设置是否门诊，住院，急诊,体检可用
/// input ArcimRowId 医嘱项RowiD，AdmID就诊ID.AdmTypeIN病人类型，如果病人类型不为空以病人类型为主
/// OutPut 空,可用  不为空返回提示信息。不可用
ClassMethod CheckArcimType(ArcimRowid As %String, AdmID As %String, AdmTypeIN As %String = "")
{
	n (ArcimRowid,AdmID,AdmTypeIN)
	s AdmType=""
	Q:ArcimRowid="" ""
    s:AdmID AdmType=$P($G(^PAADM(AdmID)),"^",2)
	S:AdmTypeIN'="" AdmType=AdmTypeIN
	s RestrictEP=$p($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),10)),"^",12)
 	s RestrictIP=$p($g(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),10)),"^",13)
	s RestrictOP=$p($G(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),10)),"^",14)
	s RestrictHP=$p($G(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),10)),"^",15)
	Q:((RestrictEP="")||(RestrictEP="N"))&&((RestrictIP="")||(RestrictIP="N"))&&((RestrictOP="")||(RestrictOP="N"))&&((RestrictHP="")||(RestrictHP="N")) ""
	Q:(AdmType="O")&&(RestrictOP'="Y") "此医嘱非门诊医嘱"
	Q:(AdmType="E")&&(RestrictEP'="Y") "此医嘱非急诊医嘱"
	Q:(AdmType="I")&&(RestrictIP'="Y") "此医嘱非住院医嘱"
	Q:(AdmType="H")&&(RestrictHP'="Y") "此医嘱非体检医嘱"
    Q ""
}

/// CreatDate:    2014.04.15
/// Description:  得到病人费别对应的处方类型
/// Table:       
/// Input:        BillTypeID 费别ID
/// Others:       
/// Return:       所有的处方类型^默认的处方类型
ClassMethod GetPrescriptTypeInfo(BillTypeID As %String, PAAdmType As %String, langid As %String = "", SessionStr As %String = "") As %String
{
	//w ##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo("1","O")
	n (BillTypeID,PAAdmType,langid,SessionStr,%session)
	s HOSPID=$P(SessionStr,"^",4)
    s langid=$P(SessionStr,"^",6)
    s:langid="" langid=..%LanguageID()
	if (HOSPID="")&&($d(%session)){
		s HOSPID=$g(%session.Data("LOGON.HOSPID"))
    }
	s PrescriptTypeStr=""
	s FirstPrescType="",FirstPrescTypeBillId=""
	s DefaultPrescType="",DefaultPrescTypeBillId=""
	s PrescTypeDetailDelim="!"
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM(PAAdmType,BillTypeID,HOSPID,langid) //"O"
	s PrescriptTypesCount=$l(PrescriptTypes,"||")
	f i=1:1:PrescriptTypesCount d
	.s PrescriptTypeTemp=$p(PrescriptTypes,"||",i)
	.s presctypebilltypeid=$p(PrescriptTypeTemp,PrescTypeDetailDelim,5)
	.s presctypedesc=$p(PrescriptTypeTemp,PrescTypeDetailDelim,3)
	.i i=1 s FirstPrescType=presctypedesc,FirstPrescTypeBillId=presctypebilltypeid
	.s presctypedefault=$p(PrescriptTypeTemp,PrescTypeDetailDelim,8)
	.i presctypedefault="Y" s DefaultPrescType=presctypedesc,DefaultPrescTypeBillId=presctypebilltypeid
	.i PrescriptTypeStr="" s PrescriptTypeStr=presctypebilltypeid_":"_presctypedesc
	.e  s PrescriptTypeStr=PrescriptTypeStr_";"_presctypebilltypeid_":"_presctypedesc
	;没有默认标识就默认第一个
	i DefaultPrescType="" s DefaultPrescType=FirstPrescType,DefaultPrescTypeBillId=FirstPrescTypeBillId

	if (PAAdmType="I") {
		s PrescriptTypeStr=DefaultPrescTypeBillId_":"_DefaultPrescType
	}
	s DefaultPrescTypeStr=DefaultPrescTypeBillId_":"_DefaultPrescType
	
	Q PrescriptTypeStr_"^"_DefaultPrescTypeStr
}

/// CreatDate:    2014.04.15
/// Description:  根据病人就诊费别和选择的上一行费别得到对应的默认费别,处方类型设置中有不还原到默认费别的设置
/// Table:       
/// Input:        EpisodeID 就诊Rowid,PreBillTypeID 上一行的费别ID
/// Others:       
/// Return:       默认的处方类型
ClassMethod GetDefaultPrescriptType(EpisodeID As %String, PreBillTypeID As %String, PreBillType As %String) As %String
{
	Q:(EpisodeID="") ""
	s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i PreBillTypeID="" s PreBillTypeID=BillTypeID
	s PrescriptTypeInfo=..GetPrescriptTypeInfo(BillTypeID,PAAdmType)
	s DefaultPrescTypeStr=$p(PrescriptTypeInfo,"^",2)
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O",PreBillTypeID)
	s PrescriptTypesCount=$l(PrescriptTypes,"||")
	;取对应的处方类型
	s NotRestoreDefalut=0
	for i=1:1:PrescriptTypesCount {
		s OnePrescriptTypes=$p(PrescriptTypes,"||",i)
		s OnePrescriptTypeDesc=$p(OnePrescriptTypes,"!",3)
		i OnePrescriptTypeDesc=PreBillType {
			s PrePrescTypeId=$p(OnePrescriptTypes,"!",1)
			continue:PrePrescTypeId=""
			s NotRestoreDefalut=$p($g(^DHCPrescriptType(PrePrescTypeId)),"^",10)
			quit
		}
	}
	
	b ;
	i NotRestoreDefalut=1 s DefaultPrescTypeStr=PreBillTypeID_":"_PreBillType
	Q DefaultPrescTypeStr
}

/// 新医嘱录入根据输入频次自动查找第一个匹配的频次，原来调用js的方法，因为没有行ID所以重写了一下。
ClassMethod GetOneFrequencyStr(val As %Library.String = "", paadmtype As %Library.String = "", OrderPriorRowid As %Library.String = "") As %Library.String
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	do rset.Execute(val,paadmtype,"",OrderPriorRowid)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
		s FreqStr=""
	    For col = 1:1:columns {
		   i FreqStr="" s FreqStr=rset.GetData(col)
	       e  s FreqStr=FreqStr_"^"_rset.GetData(col)
	    }
	    i ret="" s ret=FreqStr
	    e  s ret= ret_$C(2)_FreqStr
	    s row=row+1
	    //If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		q ret
	}
	Q row
}

/// 新医嘱录入根据输入用法自动查找第一个匹配的频次，原来调用js的方法，因为没有行ID所以重写了一下。
ClassMethod GetOneInstrStr(val As %Library.String = "", paadmtype As %Library.String = "", LocRowId As %String = "") As %Library.String
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	do rset.Execute(val,paadmtype,"",LocRowId)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
		s InstrStr=""
	    For col = 1:1:columns {
		   i InstrStr="" s InstrStr=rset.GetData(col)
	       e  s InstrStr= InstrStr_"^"_rset.GetData(col)
	    }
		i ret="" s ret=InstrStr
	    e  s ret= ret_$C(2)_InstrStr
	    s row=row+1
	    //If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		q ret
	}
	Q row
}

/// 新医嘱录入根据输入疗程自动查找第一个匹配的频次，原来调用js的方法，因为没有行ID所以重写了一下。
ClassMethod GetOneDurationStr(val As %Library.String = "") As %Library.String
{
	Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpDuration")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		q ret
	}
	Q row
}

/// 根据医嘱类型ID取描述
ClassMethod GetOrderPriorByID(rowid As %String = "") As %Library.String
{
	s desc=""
	i rowid'="" s desc=$p($g(^OECPR(rowid)),"^",2)
	Q desc
}

/// 根据医嘱类型Code取ID
ClassMethod GetOrderPriorByCode(PriorCode As %String = "") As %Library.String
{
	s PriorRowid=""
	if (PriorCode'="") s PriorRowid = $O(^OECPR(0,"Code",PriorCode,0))
	Q PriorRowid
}

/// creator:郭荣勇
/// date:2012-11-23
/// desc:得到医嘱的性别/年龄限制 1 限制,0 非限制
/// modify:王清雍 2023-02-08
ClassMethod GetItemAgeSexRestriction(ArcimRowid, PatientID, HospID = "", langid = "") As %String
{
	n (ArcimRowid,PatientID,HospID,langid,%session)
	if (langid="") Set langid=..%LanguageID()
	q:PatientID="" 0
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ret=1		;默认限制
	s LimitSexStr="",LimitMsg=""
	s PatSexId=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	s Childsub=0 for {
		s Childsub=$O(^ARCIM(+ArcimRowid,1,"AGE",Childsub)) Q:Childsub=""
		s GData=$g(^ARCIM(+ArcimRowid,1,"AGE",Childsub))
		s SexDR=$p(GData,"^",1)
		continue:SexDR=""
		s Sex=$P(^CT("SEX",SexDR),"^",2)
		s Sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",Sex,langid)
		i LimitSexStr="" s LimitSexStr=Sex
		e  s LimitSexStr=LimitSexStr_","_Sex
		s OneLimitMsg=..%Translate("oeorder.oplistcustom.new.csp","性别:",langid)_Sex
		s AgeFrom=$p(GData,"^",2)
		s AgeTo=$p(GData,"^",3)
		s PatAgeFrom="",PatAgeTo=""
		if AgeFrom'=""{
			s AgeFromType=$ZCVT($P(GData,"^",4),"U")
			s OneLimitMsg=OneLimitMsg_..%Translate("oeorder.oplistcustom.new.csp",",最小年龄为:",langid)_AgeFrom_..%Translate("oeorder.oplistcustom.new.csp",$CASE(AgeFromType,"Y":"岁","M":"月","D":"天"),langid)
			s PatAgeFrom=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID,"","",AgeFromType)
		}
		if AgeTo'=""{
			s AgeToType=$ZCVT($P(GData,"^",5),"U")
			s OneLimitMsg=OneLimitMsg_..%Translate("oeorder.oplistcustom.new.csp",",最大年龄为:",langid)_AgeTo_..%Translate("oeorder.oplistcustom.new.csp",$CASE(AgeToType,"Y":"岁","M":"月","D":"天"),langid)
			s PatAgeTo=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID,"","",AgeToType)
		}
		if (SexDR=PatSexId)&&((AgeFrom="")||(PatAgeFrom>=AgeFrom))&&((AgeTo="")||(PatAgeTo<=AgeTo)){
			s ret=0
		}
		i LimitMsg="" s LimitMsg=OneLimitMsg
		e  s LimitMsg=LimitMsg_"； "_OneLimitMsg
	}
	s:LimitMsg="" ret=0	;没有维护限制条件,不限制
	Q:'ret ret
	Q ret_$C(2)_LimitSexStr_$C(2)_LimitMsg
}

/// 
/// Description:  取协议包装单位,医嘱项上为维护的（门诊发药单位\住院发药单位）排在最后
/// Table:        
/// Input:        ArcimRowid:医嘱项表,LocRowid:医嘱项接受科室,
/// 	          Type:使用类型（空:一般场景,OrderEntry:医嘱录入场景[仅展示有效整包装单位]）,
/// 	          VailINICStr:可用库存项列表(TODO:适用于库存项一对多的情况),AdmType:就诊类型
/// Return:       整包装单位列表
/// Others:       w ##class(web.DHCDocOrderCommon).GetBillUOMStr("2||1")
ClassMethod GetBillUOMStr(ArcimRowid As %String, LocRowid As %String, Type As %String, VailINICStr As %String, AdmType As %String, langid As %String = "") As %String
{
	n (ArcimRowid,LocRowid,Type,VailINICStr,AdmType,%session,langid)
	s ^tempfxn("GetBillUOMStr")=$lb(ArcimRowid,LocRowid,Type,VailINICStr,AdmType)
	if langid="" Set langid=..%LanguageID()
	s BillUOMStr=""
	q:ArcimRowid="" BillUOMStr
	s OrderType=""
	s ItemCatDr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	if ((Type'="OrderEntry")||((OrderType="R")&&(Type="OrderEntry"))){
		// 协议包装单位
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
		if (INCIRowid'="")&&(LocRowid'="")  d
		.s ChildSub=$o(^INCI("IL_LOC",LocRowid,INCIRowid,0))
		.s INCILocRowid=INCIRowid_"||"_ChildSub
		.s Rowid=0
		.f  s Rowid=$o(^DHCILDU(0,"INCIL",INCILocRowid,Rowid)) q:Rowid=""  d
		..
		..s DispUomDR=$p($g(^DHCILDU(Rowid)),"^",1)
		..s ActiveFlag=$p($g(^DHCILDU(Rowid)),"^",2) ;激活标志
		..Q:ActiveFlag'="Y"
		..s StDate=$p($g(^DHCILDU(Rowid)),"^",3) ;有效日期
		..Q:(StDate'="")&&(StDate>+$H)
		..s EnDate=$p($g(^DHCILDU(Rowid)),"^",4)
		..Q:(EnDate'="")&&(EnDate<+$H)
		..s DispUomDesc=$p($g(^CT("UOM",DispUomDR)),"^",2)
		..s DispUomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DispUomDesc,langid)
		..s DispUomStr=DispUomDR_$C(1)_DispUomDesc
		..i BillUOMStr="" s BillUOMStr=DispUomStr
		..e  i ($C(2)_BillUOMStr_$C(2))'[($C(2)_DispUomStr_$C(2)) s BillUOMStr=BillUOMStr_$C(2)_DispUomStr
		//发药单位
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
		if (INCIRowid'="")&&(LocRowid'="")  d
		.s ChildSub=$o(^INCI("IL_LOC",LocRowid,INCIRowid,0))
		.s INCILocRowid=INCIRowid_"||"_ChildSub
		.s Rowid=0
		.f  s Rowid=$o(^DHCILDU(0,"INCIL",INCILocRowid,Rowid)) q:Rowid=""  d
		..s DispUomDR=$p($g(^DHCILDU(Rowid)),"^",1)
		..s ActiveFlag=$p($g(^DHCILDU(Rowid)),"^",2) ;激活标志
		..Q:ActiveFlag'="Y"
		..s StDate=$p($g(^DHCILDU(Rowid)),"^",3) ;有效日期
		..Q:(StDate'="")&&(StDate>+$H)
		..s EnDate=$p($g(^DHCILDU(Rowid)),"^",4)
		..Q:(EnDate'="")&&(EnDate<+$H)
		..s DispUomDesc=$p($g(^CT("UOM",DispUomDR)),"^",2)
		..s DispUomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DispUomDesc,langid)
		..s DispUomStr=DispUomDR_$C(1)_DispUomDesc
		..i BillUOMStr="" s BillUOMStr=DispUomStr
		..e  i ($C(2)_BillUOMStr_$C(2))'[($C(2)_DispUomStr_$C(2)) s BillUOMStr=BillUOMStr_$C(2)_DispUomStr

	}
	// 计价单位
	s ArcimBillUOMRowid=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,AdmType)
	q:ArcimBillUOMRowid="" BillUOMStr
	s ArcimBillUOMDesc=$p($g(^CT("UOM",ArcimBillUOMRowid)),"^",2)
	s ArcimBillUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ArcimBillUOMDesc,langid)
	s ArcimBillUOMStr=ArcimBillUOMRowid_$C(1)_ArcimBillUOMDesc
	i BillUOMStr="" s BillUOMStr=ArcimBillUOMStr
	e  i ($C(2)_BillUOMStr_$C(2))'[($C(2)_ArcimBillUOMStr_$C(2)) s BillUOMStr=BillUOMStr_$C(2)_ArcimBillUOMStr
	q BillUOMStr
}

/// 获取已审核医嘱的单位ID
ClassMethod GetOrdPackUOMDR(OEOrdItem As %String) As %String [ ProcedureBlock = 1 ]
{
	;协议单位
	s ProtocolPackUOMDR=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),"DHC")),"^",13)
	i ProtocolPackUOMDR'="" {
		q ProtocolPackUOMDR
	}
	s AdmId=$P(^OEORD(+OEOrdItem),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmId)
	s ArcimRowid=$p($g(^OEORD(+OEOrdItem,"I",$p(OEOrdItem,"||",2),1)),"^",2)
	//发药单位
	s BillUOMRowID=..GetBillUOMRowID(ArcimRowid,AdmType)
	q BillUOMRowID
}

/// Description:  根据就诊类型，获取医嘱项发药单位
ClassMethod GetBillUOMRowID(ArcimRowid As %String, AdmType As %String) As %String
{
	n (ArcimRowid,AdmType)
	s ArcimBillUOMRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	s OrderType=""
	s ItemCatDr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	s INCI=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	if (INCI'=""){
		//门诊发药单位 INCI_CTUOM_OutPat_DR
		s CTUOMOutPatDR=$P(^INCI(INCI,1),"^",12)
		//住院发药单位 INCI_CTUOM_InPat_DR
		s CTUOMInPatDR=$P(^INCI(INCI,1),"^",13)
	}else{
		s CTUOMOutPatDR=""
		s CTUOMInPatDR=""
	}
	if (AdmType="I"){
		s BillUOMRowID=CTUOMInPatDR
	}else{
		s BillUOMRowID=CTUOMOutPatDR
	}
	i BillUOMRowID="" s BillUOMRowID=ArcimBillUOMRowid
	
	q BillUOMRowID
}

/// w ##class(web.DHCDocOrderCommon).GetOrderPriceConUom(11381,29,"","138||1","","")
ClassMethod GetOrderPriceConUom(EpisodeID As %String, InsType As %String, OrderDepRowid As %String, ArcimRowid As %String, OpenForAllHosp As %String = "", OrderPackUOMRowid As %String = "", RelocDr As %String = "", ExpStr As %String = "") As %String
{
	n (EpisodeID, InsType, OrderDepRowid, ArcimRowid,OpenForAllHosp,OrderPackUOMRowid,RelocDr,ExpStr)	
	s PAADMInsType=""
	s:EpisodeID'="" PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
	i InsType="" s InsType=PAADMInsType
	s SttDate=..%SysDate()
	s DefaultRecLoc="",PatType="",PAADMRegConDisDR=""
	s:EpisodeID'="" PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	s:EpisodeID'="" CurrAdmLoc=..GetPatientCurrAdmLoc(EpisodeID)
	//s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,DefaultRecLoc,CurrAdmLoc)
	s:EpisodeID'="" PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,DefaultRecLoc)
	s:EpisodeID'="" PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s OrderMaterialBarCode=$p(ExpStr,"^",1)
	s CurLogonHosp=$p(ExpStr,"^",2)
	s ExtInstr="^^"_EpisodeID_"^"_RelocDr_"^"_CurLogonHosp_"^^"_OrderMaterialBarCode
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ArcimRowid, SttDate, "", "", "", "",PAADMRegConDisDR,OrderPackUOMRowid,ExtInstr)
	s ConFac=$p(retPrice,"^",5)
	//s FreeMedFee=##class(web.DHCINSUPort).GetInsuWelfareFee(EpisodeID,ArcimRowid)
	//s FreeMedFee=$fn(FreeMedFee*ConFac,"",4)
	//s retPrice=retPrice_"^"_FreeMedFee
	//s Price=$P(retPrice,"^",1)
	q retPrice
}

/// Creator:      郭荣勇
/// CreatDate:    2010.05.29
/// Description:  取得病人当前所在的就诊科室
/// Table:        CT_Loc,PA_AdmTransaction,PA_Adm
/// Input:        EpisodeID:就诊指针
/// OutPut:		  所在科室RowId
/// Others:        
ClassMethod GetPatientCurrAdmLoc(EpisodeID As %String) As %String
{
	n (EpisodeID)
	Q:EpisodeID="" ""
	s RetLocRowId=""
	s AdmObj=##class(User.PAAdm).%OpenId(EpisodeID)
	if $IsObject(AdmObj) {
		s RetLocRowId=AdmObj.PAADMDepCodeDRGetObjectId()
		s AdmTransID=0,findflag="N"
		for {
			s AdmTransID=$O(^PAADM(EpisodeID,"TRANS",AdmTransID),-1)
			Q:(AdmTransID="")||(findflag="Y")
			s AdmTransObj=##class(User.PAAdmTransaction).%OpenId(AdmTransID)
			s TRANSStartDate=AdmTransObj.TRANSStartDate
			s TRANSEndDate=AdmTransObj.TRANSEndDate
			s TRANSCTLOCDR=AdmTransObj.TRANSCTLOCDRGetObjectId()
			s TRANSRoomDR=AdmTransObj.TRANSRoomDRGetObjectId()
			s TRANSBedDR=AdmTransObj.TRANSBedDRGetObjectId()
			s TRANSWardDR=AdmTransObj.TRANSWardDRGetObjectId()
			Q:(TRANSBedDR="")||(TRANSEndDate'="")
			s TRANSWard=""
			s TRANSWard=""
			s RetLocRowId=AdmTransObj.TRANSWardDR.WARDLocationDRGetObjectId()
			s findflag="Y"
		}
	}
	
	Q RetLocRowId
}

/// desc 调用病案组接口获取患者病历号
/// Input EpisodeID就诊ID PatID患者ID MedType病案号类型(I住院、O门诊、E急诊) HosipitalID 医院ID 集团化需要传入
/// w ##class(web.DHCDocOrderCommon).GetMrNo(1,"","O","")	
ClassMethod GetMrNo(EpisodeID As %String, PatID As %String, MedType As %String, HosipitalID As %String = "", ErrMsg As %String = "") As %String
{
	Q:MedType="" ""
	Q:(EpisodeID="")&&(PatID="") ""
	s $ZT="ErrorGetGetMrNo"
	s MrNo=""
	s ErrMsg=""
	if EpisodeID'=""  d
	.s MrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	else  d
	.S MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatID,MedType,HosipitalID,.ErrMsg)
	Q MrNo
ErrorGetGetMrNo
    q ""
}

/// 验证日期时间有效格式	
/// w ##class(web.DHCDocOrderCommon).CheckDate("20140122","12:22")
ClassMethod CheckDateTime(DateStr As %String, TimeStr As %String) As %String
{
	s $ZT="DateTimeError"
	s DateTimeFlag=$$CheckDate(DateStr)
	if DateTimeFlag'="N"  d
	.s DateTimeFlag=$$CheckTime(TimeStr)
	q DateTimeFlag
CheckTime(TimeStr)
	s DateTimeFlag="Y"
	if TimeStr'=""
	{
		s TimeLeng=$L(TimeStr,"^")
		for TimeSub=1:1:TimeLeng
		{
			s TimeGet=$P(TimeStr,"^",TimeSub)
			s TimeGet=$tr(TimeGet," ")
			continue:TimeGet=""
			s TimeGet=..%ZTH(TimeGet)
		}
	}
	q DateTimeFlag
CheckDate(DateStr)
	s DateTimeFlag="Y"
	if DateStr'=""
	{
		s DateLeng=$L(DateStr,"^")
		for DateSub=1:1:DateLeng
		{
			s DateGet=$P(DateStr,"^",DateSub)
			s DateGet=$tr(DateGet," ")
			continue:DateGet=""
			if DateGet["-"  d
			.s DateGet=$ZDH(DateGet,3)
			else  if DateGet["/"  d
			. s DateGet=$ZDH(DateGet,4)
			else  d
			.s DateTimeFlag="N"	
		}
	}
	q DateTimeFlag
DateTimeError
 q "N"
}

/// desc 获取库存项 规格
/// input 医嘱项ID
ClassMethod Getspec(ArcItemID) As %String
{
	Q:ArcItemID="" ""
	s ArcimS=$p(ArcItemID,"||",1)
	s Inci=$o(^INCI(0,"ARCIM_DR",ArcimS,"")) 
	s info=$O(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:info="" ""
	s spec=$p($g(^DHCITMINFO(info)),"^",27)
	Q spec
}

ClassMethod ShowMessage(Message As %String) As %String
{
	w "<LABEL  STYLE=""FONT-SIZE:14"">"_Message_"</LABEL>"
}

/// 通过主医嘱获取所有关联子医嘱ID
/// input MaiOrdID 主医嘱ID
/// Type=1 只包含有效子医嘱
/// w ##class(web.DHCDocOrderCommon).GetLinkOrdItem("19||15")
ClassMethod GetLinkOrdItem(MaiOrdID As %String, Type As %String = 0) As %String
{
	s ReturnStr=""
	s Link=0
	f  s Link=$O(^OEORDi(0,"OEORI",+MaiOrdID,MaiOrdID,Link)) Q:Link=""  d
	.s LikOrdID=+MaiOrdID_"||"_Link
	.s statcode=$$GetStat(LikOrdID)
	.Q:((statcode="U")||(statcode="D")||(statcode="C"))&&(Type=1)
	.if ReturnStr="" s ReturnStr=LikOrdID
	.else  s ReturnStr=ReturnStr_"^"_LikOrdID
	Q ReturnStr
GetStat(OrderID)
	s statcode=""
	s Stat=$P($G(^OEORD(+OrderID,"I",$P(OrderID,"||",2),1)),"^",13)
	s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
	Q statcode
}

/// 监测DefPriorRowid是否为病人可用的医嘱类型，如果不是返回一个默认可用的
ClassMethod CheckDefPrior(EpisodeID As %String, DefPriorRowid As %String = "", LogonDep As %String = "") As %String
{
   
	n (EpisodeID,DefPriorRowid,LogonDep,%session)
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	s FindDefPrior="N"
	i DefPriorRowid'="" s OldDefPriorCode=$p($g(^OECPR(DefPriorRowid)),"^",1)
	e  s OldDefPriorCode=""
	;长期医嘱
	if (OldDefPriorCode="OMST")||(OldDefPriorCode="OMCQZT"){
		s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
		s DefPriorRowid=LongOrderPriorRowid
	}
	;临时医嘱
	s ShortOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	if (OldDefPriorCode="ONE")&&(EpisodeType="I"){
		s DefPriorRowid=ShortOrderPriorRowid
	}
	if (OldDefPriorCode="OM"){
		s DefPriorRowid=ShortOrderPriorRowid
	}
	if (OldDefPriorCode="OMLSZT"){
		s DefPriorRowid=ShortOrderPriorRowid
	}
	s DefPriorStr=##Class(web.DHCDocOrderCommon).GetOrderPrior(EpisodeID,"",LogonDep)
	s LengthPrior=$l(DefPriorStr,"^")
	s FirstPrior=""
	for SubI=1:1:LengthPrior
	{
		s PriorStr=$P(DefPriorStr,"^",SubI)
		continue:PriorStr=""
		s PriorID=$P(PriorStr,$c(1),1)
		s:FirstPrior="" FirstPrior=PriorID
		if PriorID=DefPriorRowid  s FindDefPrior="Y"
	}
	//tanjs20191012如果当前默认医嘱类型不能使用，应该直接清空
	s:FindDefPrior="N" DefPriorRowid=""
  	Q DefPriorRowid
}

/// CTOR: QP
/// DATE: 2021-07-22
/// DESC: 医嘱能否开具，不判断免费次数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.DHCDocOrderCommon).CheckPilotCat("1246","740||1","19","","")
ClassMethod CheckPilotCat(EpisodeID, ArcimID, PPRowId, CurLogonHosp = "", VisitFlag = "") As %String
{
	s ^QP("CheckPilotCat")=$LB(EpisodeID, ArcimID, PPRowId,CurLogonHosp, VisitFlag)
	
	Q:VisitFlag=1 "Y"	;访视外医嘱均可以开具
	s OrderType=""
	i CurLogonHosp="" {
		s admLoc=$p(^PAADM(EpisodeID),"^",4)	
		i admLoc'="" s CurLogonHosp=$p(^CTLOC(admLoc),"^",22)
	}
	i CurLogonHosp="" s PilotCatStr=""
	e  s PilotCatStr=$G(^DHCDocPilotSeting(CurLogonHosp,"PilotProSubCatStr"))
	
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	i PPRowId'="" {
		s PPOpenOrdEntryLimit=$p(^DHCDocPP(PPRowId),"^",117)
		i PPOpenOrdEntryLimit="Y" {
			i PilotCatStr="" {
				//判断免费医嘱
				s InStage=##class(web.PilotProject.Extend.PatAdd).GetStageByAdm(PPRowId,EpisodeID,"")
				Q:InStage="" "N"
				Q:'$d(^DHCDocPPF(0,"PrjStageArcim",PPRowId,InStage,ArcimID)) "N"
				
			} else {
				i (("!"_PilotCatStr_"!")'[("!"_ItemCatDr_"!")) {
					//判断免费医嘱
					s InStage=##class(web.PilotProject.Extend.PatAdd).GetStageByAdm(PPRowId,EpisodeID,"")
					Q:InStage="" "N"
					Q:'$d(^DHCDocPPF(0,"PrjStageArcim",PPRowId,InStage,ArcimID)) "N"
				} else {
					Q "Y"
				}
			}
			
		} else {
			;开启医嘱限制，非药品可开具
			if (OrderType="R") {
				Q:PilotCatStr="" "N"
				Q:(("!"_PilotCatStr_"!")'[("!"_ItemCatDr_"!")) "N"
				
			} else {
				Q "Y"	
			}
		}
	} else {
		Q:PilotCatStr="" "Y"
		Q:(("!"_PilotCatStr_"!")[("!"_ItemCatDr_"!")) "N"
	}
	Q "Y"
}

/// creater lxz
/// desc 验证所开药品是否在可开临床药理子类中
/// return Y 可开 N 不可开
ClassMethod CheckPilotCatOld(EpisodeID As %String, ArcimID As %String, PPRowId As %String = "") As %String
{
	;临床药理可以录入的医嘱子类
	s PilotCatStr=$G(^DHCDocPilotSeting("PilotProSubCatStr"))
	Q:PilotCatStr="" "Y"
	s OrderType=""
	s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	Q:OrderType'="R" "Y"
	if PPRowId'="" {
		;临床药理病人仅可以开立药理子类药品
		Q:(("!"_PilotCatStr_"!")'[("!"_ItemCatDr_"!")) "N"
	}else{
		;非临床药理病人不可以开立药理子类药品
		Q:(("!"_PilotCatStr_"!")[("!"_ItemCatDr_"!")) "N"
	}
	Q "Y"
}

/// pcq
/// pcq
/// desc  ：护士补录关联医嘱需要的主医嘱信息
/// input ：itemid 医嘱ID
/// OutPut：医嘱信息
/// w ##class(web.DHCDocOrderCommon).GetVerifiedOrder("1436||588")
ClassMethod GetVerifiedOrder(itemid As %String) As %String
{
	s ItemData=""
	s ARCIMRowid="",OrderSeqNo="",OrderDoseQty="",OrderDoseUOM="",OrderDoseUOMRowid=""
	s OrderFreq="",OrderFreqRowid="",OrderFreqFactor="",OrderFreqInterval="",OrderFreDesc="",OrderFreqDispTimeStr=""
	s OrderInstr="",OrderInstrRowid=""
	s OrderDur="",OrderDurRowid="",OrderDurFactor=""
	s OrderPackQty="",OrderPackUOM="",OrderPackUOMRowid=""
	s OrderPrior="",OrderPriorRowid=""
	s OrderType="",OrderBillTypeRowId="",OrderDate=""
	Q:itemid="" 0
	Set langid=..%LanguageID()
	s JFlag="0"
    &SQL(
	 	SELECT OEORI_ItmMast_DR,
		OEORI_DoseQty,OEORI_Unit_DR,OEORI_Unit_DR->CTUOM_Desc,
		OEORI_QtyPackUOM,
		OEORI_Priority_dr,OEORI_Priority_dr->OECPR_Desc,
		OEORI_PHFreq_DR,OEORI_PHFreq_DR->PHCFR_Desc1,
		OEORI_Instr_DR,OEORI_Instr_DR->PHCIN_Desc1,
		OEORI_Durat_DR,OEORI_Durat_DR->PHCDU_Desc1,	
		OEORI_BBExtCode,
		OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
		OEORI_SeqNo,OEORI_Date,OEORI_SttDat,OEORI_SttTim
	  	INTO :ARCIMRowid,
	  	:OrderDoseQty,:OrderDoseUOMRowid,:OrderDoseUOM,
	  	:OrderPackQty,
		:OrderPriorRowid,:OrderPrior,
		:OrderFreqRowid,:OrderFreq,
		:OrderInstrRowid,:OrderInstr,
		:OrderDurRowid,:OrderDur,
		:OrderBillTypeRowid,:OrderType,
		:OrderSeqNo,:OrderDate,:OrderSttDate,:OrderSttTime
		From SQLUser.OE_OrdItem 
	 	WHERE OEORI_Rowid=:itemid 
	)
	s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(itemid)
	s OrderPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
	s StatCode="",StatDesc=""
	s Stat=$P($G(^OEORD(+itemid,"I",$p(itemid ,"||",2),1)),"^",13)
	if (Stat'=""){
		s StatCode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		s StatDesc=$p($g(^OEC("OSTAT",Stat)),"^",2)
	}
	Q:+ARCIMRowid=0 0
	s VerifiedOrderName=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",2)
	//频次
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(itemid," ")
	s OrderFreqRowid=$List(OrdFreqInfo,1)
	s IntervalUnit=""
	if (OrderFreqRowid'="") {
		s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
		i (+OrderFreqInterval=0) s OrderFreqInterval=1
		s IntervalUnit=$P(^PHCFR(OrderFreqRowid),"^",14)	;间隔单位
	}
	s OrderFreDesc=$List(OrdFreqInfo,2)
	s OrderFreqFactor=$List(OrdFreqInfo,3)
	s OrderFreqDispTimeStr=$List(OrdFreqInfo,4)
	s IntervalTimeFlag=$List(OrdFreqInfo,7)
	
	s OrderFreqDispTimeStr=$TR(OrderFreqDispTimeStr,$C(1),$C(13))	
	if (OrderDurRowid'="") d
	.//疗程
	.s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
	s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
	if (OrderPriorCode="OUT"){
		s JFlag="出院带药医嘱不能补录."
	}elseif OrderPriorCode="ONE"{
		s Adm=$P(^OEORD(+itemid),"^",1)
		s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
		s OrderFreqRowid=..%GetConfig("IPShortOrderPriorDefFreq",AdmHospitalId)
		s:OrderFreqRowid="" OrderFreqRowid=$O(^PHCFR(0,"Code","ONCE",0))
		s OrderFreqInterval=""
		s OrderFreDesc=$P($g(^PHCFR(OrderFreqRowid)),"^",3)
		s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
		s OrderFreqDispTimeStr=""
		s IntervalTimeFlag=""
		s OrderFreqDispTimeStr=""
	}
	if ##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid){
		s OrderPriorRowid=$O(^OECPR(0,"Code","S",0))
	}else{
		s OrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	}
	s VerifiedOrderMasterRowid=itemid
	s VerifiedOrderMasterSeqNo=OrderSeqNo
	s VerifiedOrderPriorRowid=OrderPriorRowid
	s VerifiedOrderFreFactor=OrderFreqFactor
	s VerifiedOrderFreRowId=OrderFreqRowid
	s VerifiedOrderFreDesc=OrderFreDesc
	s VerifiedOrderFreInterval=OrderFreqInterval
	s VerifiedOrderFreqDispTimeStr=OrderFreqDispTimeStr
	
	s VerifiedOrderOrderInstr=OrderInstr
	s VerifiedOrderOrderInstrRowid=OrderInstrRowid
	s NurseLinkOrderRowId=$p($g(^OEORD(+itemid,"I",$p(itemid ,"||",2),"DHC")),"^",54)
	if (+NurseLinkOrderRowId'="0"){
		s NurseLinkOrderARCIId=$p(^OEORD(+NurseLinkOrderRowId,"I",$p(NurseLinkOrderRowId ,"||",2),1),"^",2)
		s NurseLinkOrderDesc=$P(^ARCIM(+NurseLinkOrderARCIId,$P(NurseLinkOrderARCIId,"||",2),1),"^",2)
		s JFlag="该条医嘱是绑定在长期医嘱"_NurseLinkOrderDesc_"上的临时护嘱,不能补录."
	}
	s CrruDate=..%SysDate()
	;2018-10-24 允许补录当天之前的医嘱,控制补录的医嘱开始日期和时间不能修改到昨天及之前
	;i OrderDate<CrruDate s Flag="该医嘱日期小于当前日期,不能补录."
	
	if (StatCode'="E")&&(StatCode'="V"){
		s JFlag="该医嘱当前状态为"_StatDesc_",不能补录."
	}
	s SttDateLessCurDateFlag="N"
	i OrderSttDate<+$h s OrderSttDate=..%SysDate(),OrderSttTime=..%SysTime(),SttDateLessCurDateFlag="Y" //若补录的医嘱开始日期小于今天,则默认当天
	s OrderSttDate=..%ZD(OrderSttDate)
	s OrderSttTime=..%ZT(OrderSttTime,1)
	s OrderSttDate=OrderSttDate_" "_OrderSttTime
	s VerifiedOrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",VerifiedOrderName,langid)
	s ItemData=JFlag_"^"_VerifiedOrderName_"^"_VerifiedOrderMasterRowid_"^"_VerifiedOrderMasterSeqNo_"^"_VerifiedOrderPriorRowid
	s ItemData=ItemData_"^"_VerifiedOrderFreRowId_$C(1)_VerifiedOrderFreFactor_$C(1)_VerifiedOrderFreInterval_$C(1)_VerifiedOrderFreDesc_$C(1)_VerifiedOrderFreqDispTimeStr_$C(1)_IntervalTimeFlag_$C(1)_IntervalUnit
    s ItemData=ItemData_"^"_OrderSttDate_"^"_SttDateLessCurDateFlag_"^"_VerifiedOrderOrderInstr_"^"_VerifiedOrderOrderInstrRowid
	q ItemData
}

/// creater lxz
/// modify 郭荣勇
/// modify 王清雍 20210527 方法整理优化
/// desc   获取新医嘱录入是否可录入长期标识:登陆科室是否在患者就诊科室或者就诊科室的linklocation中,如果在则可以录入长期或者不可以
/// input  CTLOCID 登陆科室ID  EpisodeID就诊ID
/// output "Y" 可录长期 "N" 不可录长期
ClassMethod CheckINAdmTypeLoc(LogonLOCID As %String, EpisodeID As %String, EmConsultItm As %String = "", CNMedFlag As %String = "") As %String
{
	Q:(LogonLOCID="")||(EpisodeID="") "N"
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	Q:AdmType'="I" "N"
	s VisitStatus=$p($G(^PAADM(EpisodeID)),"^",20)
	Q:VisitStatus'="A" "N"	;出院与预住院患者不能录入长期
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s ConsultAllowLong=..%GetConfig("ConsultAllowLong",AdmHospitalId)
	s:CNMedFlag="Y" ConsultAllowLong=1 ;草药界面不走此配置
	;会诊开发录入医嘱节点内容,住院患者允许录入长嘱
	Q:(ConsultAllowLong=1)&&##Class(DHCDoc.Interface.Inside.Invoke).TakOrdLongAut(EpisodeID,EmConsultItm) "Y"
	Q ..IsLoginAdmLoc(LogonLOCID,EpisodeID)
}

/// creater 郭荣勇
/// modify 王清雍 20210527 不限制收治病区里的其他科室病人,可以录入长期,判断Ward是不是当前登录科室
/// desc   判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
/// input  EpisodeID就诊ID
/// output "Y" 是 "N" 不是
ClassMethod IsLoginAdmLoc(LogonLOCID As %String, EpisodeID As %String) As %String
{
	Q:(LogonLOCID="")||(EpisodeID="") "N"
	s LinkCTLocStr="^"_..GetAdmLocStr(EpisodeID)_"^"
	Q:LinkCTLocStr[("^"_LogonLOCID_"^") "Y"
	;WangQingyong 20210527
	s WardID=$P(^PAADM(EpisodeID),"^",70)
	s WardLocID=$P($G(^PAWARD(+WardID)),"^",5)
	Q:LogonLOCID=WardLocID "Y"
	Q "N"
}

/// creater 郭荣勇
/// desc   获取患者就诊科室及就诊科室的linklocation中的科室
/// input  EpisodeID就诊ID
/// output "Y" 可录长期 "N" 不可录长期
ClassMethod GetAdmLocStr(EpisodeID As %String) As %String
{
	q:(EpisodeID="") ""
	s AdmDepDR=$p(^PAADM(EpisodeID),"^",4)
	;取科室的关联科室
	s LinkCTLocStr=""
	s LinkChlsub=0
	for {
		s LinkChlsub=$O(^CTLOC(AdmDepDR,"LINK",LinkChlsub)) Q:LinkChlsub=""
		s LinkCTLocDR=$p($g(^CTLOC(AdmDepDR,"LINK",LinkChlsub)),"^",1)
		i LinkCTLocDR'=AdmDepDR {
			i LinkCTLocStr="" {
				s LinkCTLocStr=LinkCTLocDR
			}else{
				s LinkCTLocStr=LinkCTLocStr_"^"_LinkCTLocDR
			}
		}
	}
	
	i LinkCTLocStr="" {
		s LinkCTLocStr=AdmDepDR
	}else{
		s LinkCTLocStr=LinkCTLocStr_"^"_AdmDepDR
	}
	
	Q LinkCTLocStr
}

/// creater 郭荣勇
/// desc   得到药学项或库存项基本单位rowid和描述
/// input  ARCIMRowid
/// output 基本单位Rowid^基本单位描述
ClassMethod GetBaseUom(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s ARCIMmas=$p(ARCIMRowid,"||",1)
	s ARCIMsub=$p(ARCIMRowid,"||",2)
	s BaseUOMRowid="",BaseUOMDesc=""
	s DrgFormrow=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	i DrgFormrow'="" {
		s BaseUOMRowid=$p(^PHCD(+DrgFormrow,"DF",$p(DrgFormrow,"||",2),2),"^",4)
	}else{
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(ARCIMmas)
		i INCIRowid'="" s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
	}
	i BaseUOMRowid'="" s BaseUOMDesc=..GetUOMDesc(BaseUOMRowid)
	
	q BaseUOMRowid_"^"_BaseUOMDesc
}

/// 获取医嘱类型的Code和描述 护士补录医嘱医嘱录入界面使用
ClassMethod GetPrioCodeAndDesc(PrioDr As %String) As %String
{
	Q:PrioDr="" "^"
	s Code=$p($G(^OECPR(PrioDr)),"^",1)
	s Desc=$p($G(^OECPR(PrioDr)),"^",2)
	q Code_"^"_Desc
}

ClassMethod GetARCIMRequireNoteFlag(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	Q:DHCARCIMRowid="" ""
	s RequireNoteFlag=$p(^DHCItmMast(DHCARCIMRowid),"^",5)
	q $g(RequireNoteFlag)
}

ClassMethod GetARCIMOrderMsg(ArcimRowid As %String) As %String
{
	q:ArcimRowid="" ""
	q:$l(ArcimRowid,"||")=1 "" 
	q:'$d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2))) ""
	s OrderMsg=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"OEM",1))
	s OrderMsg=$TR(OrderMsg,$C(13),"")
	s OrderMsg=$TR(OrderMsg,$C(10),"")
	q OrderMsg
}

ClassMethod GetARCIMShowOEMessageFlag(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	Q:DHCARCIMRowid="" ""
	s ShowOEMessageFlag=$p(^DHCItmMast(DHCARCIMRowid),"^",4)
	q $g(ShowOEMessageFlag)
}

/// creator:郭荣勇
/// date:2015-12-08
/// desc:得到草药子类字符拼接串(^)
/// w ##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
ClassMethod GetCNMedItemCatStr(CurLogonHosp As %String = "") As %String
{
	n (CurLogonHosp,%session)
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s CNMedItemCat=""
	if ($g(CurLogonHosp)'=""){
		s HospCodeNode="HospDr_"_CurLogonHosp
		s PrescTypeCode=0
		for{
			s PrescTypeCode=$O(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",PrescTypeCode))
			q:PrescTypeCode=""
			s PrescTypeActive=$P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",PrescTypeCode),"^",2)
			continue:(PrescTypeActive="N")
			s PrescTypeItemCat=##class(web.DHCDocConfig).GetConfigNodeNew2(PrescTypeCode,CurLogonHosp)
			if CNMedItemCat'="" {
				if PrescTypeItemCat'="" s CNMedItemCat=CNMedItemCat_"^"_PrescTypeItemCat
			}else{
				s CNMedItemCat=PrescTypeItemCat
			}
		}
	}else{
		for {
			s CurLogonHosp=$O(^CT("HOSP",CurLogonHosp))
			q:(CurLogonHosp="")
			if (CNMedItemCat=""){
				s CNMedItemCat=..GetCNMedItemCatStr(CurLogonHosp)
			}else{
				s CNMedItemCat=CNMedItemCat_"^"_..GetCNMedItemCatStr(CurLogonHosp)
			}
		}
	}
	Q CNMedItemCat
}

/// creator:郭荣勇
/// date:2015-12-08
/// desc:得到医嘱是否为草药
/// output:0 不是,1 是
ClassMethod IsCNMedItem(ArcimRowid As %String, CurLogonHosp As %String = "") As %String
{
	n (ArcimRowid,CurLogonHosp,%session)
	
	s CurLogonHosp=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s ret=0
	Q:ArcimRowid="" ret
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s CNMedItemCatStr=..GetCNMedItemCatStr(CurLogonHosp)
	Q:CNMedItemCatStr="" ret
	i ("^"_CNMedItemCatStr_"^")[("^"_ItemCatRowid_"^") {
		s ret=1
	}
	
	Q ret
}

ClassMethod GetCurrentSYSHospitalCode(HospitalId As %String) As %String
{
	i ($g(HospitalId)="")&&($d(%session)) s HospitalId=%session.Get("LOGON.HOSPID")
	s HospitalCode=""
	i HospitalId'="" s HospitalCode=$p($g(^CT("HOSP",HospitalId)),"^",1)
	Q HospitalCode
}

/// creator:郭荣勇
/// date:2016-01-15
/// desc:得到安全组是否有医嘱模板维护某一个保存菜单权限
/// input: "按科室保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForLocation
/// 		   "按安全组保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForGroup
/// 		   "按站点保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForSite 
/// 		   "按用户保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForUser
/// 		   "按医院保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForHospital
/// output:0 没有权限,1 有
/// w ##class(web.DHCDocOrderCommon).IsHaveMenuAuthOrderOrgFav(29,"System.OEOrder.OrgFav.Save.SetSaveForUser")
ClassMethod IsHaveMenuAuthOrderOrgFav(GroupId As %String, MenuName As %String) As %String
{
	n (GroupId,MenuName,%session,%request)
	Q:(GroupId="")||(MenuName="") 0
	s ret=0
	s masterMenuId=$o(^websys.MenuI("UniqueNameIndex"," SYSTEM.OEORDER.ORGFAV.SAVE",0))
	Q:masterMenuId="" 0
	s MenuName=$zcvt(MenuName,"U")
	s menuId=$O(^websys.MenuI("UniqueNameIndex"," "_MenuName,0))
	Q:menuId="" 0
	
	Set rs=##Class(%ResultSet).%New("websys.Menu:SelectSubMenu")
	If rs.QueryIsValid() {
		Set Status=rs.Execute(masterMenuId,GroupId,1)
		If 'Status Quit
		While (rs.Next()) {
		    s HaveAuthMenuId=rs.GetData(1)
		    i HaveAuthMenuId=menuId s ret=1
		}
		d rs.Close()
	}
	
	Q ret
}

/// creator:郭荣勇
/// date:2016-01-15
/// desc:得到安全组对应的组件菜单的Id
/// input: "按科室保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForLocation,XTYPE="L"
/// 		   "按安全组保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForGroup,XTYPE="G"
/// 		   "按站点保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForSite,XTYPE="T"
/// 		   "按用户保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForUser,XTYPE="U"
/// 		   "按医院保存设置"菜单:System.OEOrder.OrgFav.Save.SetSaveForHospital,XTYPE="H"
/// output:组件菜单的Id
/// w ##class(web.DHCDocOrderCommon).GetMenuAuthOrderOrgFavId(29,"System.OEOrder.OrgFav.Save.SetSaveForUser")
ClassMethod GetMenuAuthOrderOrgFavId(GroupId As %String, XTYPE As %String) As %String
{
	n (GroupId,XTYPE)
	Q:(GroupId="")||(XTYPE="") ""
	s ret=""
	s masterMenuId=$o(^websys.MenuI("UniqueNameIndex"," SYSTEM.OEORDER.ORGFAV.SAVE",0))
	Q:masterMenuId="" ""
	s MenuName=""
	if XTYPE="L" {
		s MenuName="System.OEOrder.OrgFav.Save.SetSaveForLocation"
	}elseif (XTYPE="U") {
		s MenuName="System.OEOrder.OrgFav.Save.SetSaveForUser"
	}elseif (XTYPE="G") {
		s MenuName="System.OEOrder.OrgFav.Save.SetSaveForGroup"
	}elseif (XTYPE="H") {
		s MenuName="System.OEOrder.OrgFav.Save.SetSaveForHospital"
	}elseif (XTYPE="T") {
		s MenuName="System.OEOrder.OrgFav.Save.SetSaveForSite"
	}
	Q:MenuName="" ""
	
	s MenuName=$zcvt(MenuName,"U")
	s menuId=$O(^websys.MenuI("UniqueNameIndex"," "_MenuName,0))
	Q:menuId="" ""
	
	Set rs=##Class(%ResultSet).%New("websys.Menu:SelectSubMenu")
	If rs.QueryIsValid() {
		Set Status=rs.Execute(masterMenuId,GroupId,1)
		If 'Status Quit
		While (rs.Next()) {
		    s HaveAuthMenuId=rs.GetData(1)
		    i HaveAuthMenuId=menuId s ret=menuId
		}
		d rs.Close()
	}
	
	Q ret
}

/// 录入医嘱的时候,判断医嘱的药学子类和过敏记录的药品的药学子类是否相同
/// 1 相同 0 不相同  AllergyChildNotice
/// w ##class(web.DHCDocOrderCommon).CheckAllergyChildNotice(108,"1076||1")
ClassMethod CheckAllergyChildNotice(PatientID As %String, ARCIMRowId As %String) As %String
{
	n (PatientID,ARCIMRowId)
	q:(PatientID="")||(ARCIMRowId="") "0"_$c(2)_""
	s Find=0,Message=""
    s PHCDPHCSCDR=##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(ARCIMRowId)
    s PHCDPHCSCDR=$p(PHCDPHCSCDR,"^",1)
    q:PHCDPHCSCDR="" "0"_$c(2)_""
	s ALGChildSub=0
	f  s ALGChildSub=$o(^PAPER(PatientID,"ALG",ALGChildSub)) q:ALGChildSub=""  d
	.s ALGExternalID=$p(^PAPER(PatientID,"ALG",ALGChildSub),"^",30)
	.q:(ALGExternalID="")||(ALGExternalID=ARCIMRowId)
	.;过敏记录开关
	.s CheckConflict=$P($g(^PAPER(+PatientID,"ALG",ALGChildSub,"DHC")),"^",3)
	.q:(CheckConflict'="Y")
	.s ALGPHCDPHCSCDR=##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(ALGExternalID)
	.s ALGPHCDPHCSCDR=$p(ALGPHCDPHCSCDR,"^",1)
	.q:(ALGPHCDPHCSCDR="")||(ALGPHCDPHCSCDR'=PHCDPHCSCDR)
	.s ARCIMDesc=$p($g(^ARCIM(+ALGExternalID,$p(ALGExternalID,"||",2),1)),"^",2)
	.s Find=1
	.i Message="" s Message=ARCIMDesc
	.e  s Message=Message_","_ARCIMDesc
	q Find_$c(2)_Message
}

ClassMethod CheckOrderDate(EpisodeID As %String, OrderDateStr As %String) As %String
{
	s PAADMDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s PAADMTime=$p($g(^PAADM(EpisodeID)),"^",7)
	s OrderDate=$p(OrderDateStr," ",1)
	i (OrderDate["/") s OrderDate=$zdh(OrderDate,4)
	i (OrderDate["-") s OrderDate=$zdh(OrderDate,3)
	i OrderDate="" s OrderDate=..%SysDate()
	s OrderTime=$p(OrderDateStr," ",2)
	i (OrderTime[":") s OrderTime=..%ZTH(OrderTime)
	i OrderTime="" s OrderTime=$p(OrderTime,",",2)
	s APPTLastStatusChangeDate=""
	i $d(^RBAS("ADM",EpisodeID)) d
	.s RESRowId=$o(^RBAS("ADM",EpisodeID,""))
	.s ASChildSub=""
	.s:RESRowId'="" ASChildSub=$o(^RBAS("ADM",EpisodeID,RESRowId,""))
    .s APPTChildSub=""
	.s:ASChildSub'="" APPTChildSub=$o(^RBAS("ADM",EpisodeID,RESRowId,ASChildSub,""))
    .s:APPTChildSub'="" APPTLastStatusChangeDate=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",63)
	q:((OrderDate=PAADMDate)&&(OrderTime<PAADMTime)&&((APPTLastStatusChangeDate=OrderDate)||(APPTLastStatusChangeDate=""))) "开医嘱时间不能小于就诊时间!"
	q:(OrderDate<PAADMDate) "开医嘱日期不能小于就诊日期!"
	q ""
}

ClassMethod CheckDiagnosCatArcimPass(EpisodeID As %String, InsType As %String, ArcimRowid As %String, OrderDIACatRowId As %String, HospId As %String = "") As %String
{
	n (EpisodeID,InsType,ArcimRowid,OrderDIACatRowId,HospId,%session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	s MrAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s OrderType=""
	s ItemCatDr=$P(^ARCIM(+ArcimRowid,$P(ArcimRowid,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	s DiagnosCatArcimPass=1
	s BillTypeDiagnosCat=..GetBillTypeDiagnosCat(EpisodeType,InsType,HospId)
	s EPDiagnosCat=..GetEPDiagnosCat(EpisodeType,InsType,MrAdmRowid,HospId)
	s DCDurationFactor=0
	i EPDiagnosCat'="" {
		if (OrderDIACatRowId'="") s EPDiagnosCat=OrderDIACatRowId
	    	s TempStr=..GetDiagnosCatArcim(EPDiagnosCat,ArcimRowid)
	    	s EPDurationInfo=$p(TempStr,$c(1),1)
	    	i EPDurationInfo'="" {
		    	s MatchingDiagnosCatStr=$p(TempStr,$c(1),2)
		    	;得到医嘱匹配的特殊诊断分类
		    	s EPDiagnosCat=MatchingDiagnosCatStr
	    		s DCDurationRowid=$P(EPDurationInfo,"^",1)
	    		i DCDurationRowid'="" s DCDurationFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(DCDurationRowid)
    	    }else{  
	    		s NotDiagnosCatArcimAllow=..%GetConfig1("DiagnosCatArcimAllow",InsType,HospId)
	    		i NotDiagnosCatArcimAllow'="1" s DiagnosCatArcimPass="0"
	    		i (HospitalCode'="ZGYKDFSYY"){
					i OrderType'="R" s DiagnosCatArcimPass="1"
				}
		   }
		   //诊断设置-特殊诊断分类-医嘱明细未设置疗程，特殊诊断记录的疗程设置
	    	if (DCDurationFactor=0){
		    	s DCDurationRowid=$p($g(^DHCDiagnosCat(EPDiagnosCat)),"^",4)
		    	i DCDurationRowid'="" s DCDurationFactor=##class(web.DHCDocOrderEntry).GetDurationFactor(DCDurationRowid)
		    }
	}else{
    	s NotDiagnosCatArcimAllow=..%GetConfig1("DiagnosCatArcimAllow",InsType,HospId)
		i (BillTypeDiagnosCat'="")&&(OrderType="R")&&(NotDiagnosCatArcimAllow'="1") s DiagnosCatArcimPass="0"
	}
	Q DiagnosCatArcimPass_"^"_DCDurationFactor
}

ClassMethod GetPreFraGroup() As %String
{
	 w "<DIV id='preftabsList' style='position:relative; padding:10px;'>"
	 w "<SPAN id='OEPrefLoc' class='PrescTypeTab'>科室模板</SPAN>"
	 w "<SPAN id='OEPrefUser' class='PrescTypeTab'>个人模板</SPAN>"
	 w "</DIV>"
}

ClassMethod CheckDataValidByAdmType(CheckType As %String, PAAdmType As %String) As %String
{
	n (CheckType,PAAdmType)
	s ValidStr=""
	if (CheckType="Freq"){
		Set rset=##Class(%ResultSet).%New("web.DHCDocOrderCommon.LookUpFrequency")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute("",PAAdmType)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s RowId=rset.GetData(5)
				i ValidStr="" s ValidStr=RowId
				e  s ValidStr=ValidStr_"^"_RowId
			}
		}
	}
	Q ValidStr
}

/// /w ##Class(web.DHCDocOrderCommon).SetARCOSItemDirect("AddCopyItemToList",186,2,2064)
ClassMethod SetARCOSItemDirect(itmjs As %Library.String = "", ARCOSRowid As %String, HospitalId As %String, EpisodeID As %String) As %String
{
	s CopyData=""
	///Item,ItemQty,ItemBillUOM,ItemDoseQty,ItemDoseUOM,ItemFreq,ItemInstr,ItemDur,ItemData,ItemRowid,
	///ItemOrderType,ItemPrice,ItemStatus,ItemRemark,DHCDocOrderType,DHCDocOrderTypeID,ItemSpec,
	///ItemSpecCode,OrderPriorRemarksDR,OrderPriorRemarks,Sensitive,ItemSeqNo
	Set obj=##class(%ResultSet).%New("web.DHCDocOrderCommon:FindOSItems")
	d obj.Execute(ARCOSRowid,HospitalId,EpisodeID)
	For {
		Quit:'obj.Next()
		
		s ItemData=obj.Data("ItemData")
		s ItemData=$tr(ItemData,"~",$C(1))
		s ItemRowid=obj.Data("ItemRowid")
		s ItemSeqNo=obj.Data("ItemSeqNo")
		s ItemOrderType=obj.Data("ItemOrderType")
		s $p(ItemData,"^",13)=obj.Data("NotifyClinician") //紧急标志
		s OrderFreqTimeDoseStr=$p(ItemData,"^",23)
		if (OrderFreqTimeDoseStr'="") {
			s ispecdoseqtystr = $P(ItemData, "^", 1)
			s $p(ispecdoseqtystr,$C(1),1)=""
			s $P(ItemData, "^", 1)=ispecdoseqtystr
		}
		s $p(ItemData,"^",23)=##class(web.DHCDocUtil).Replace(OrderFreqTimeDoseStr,"!",$C(2))
		s FreqWeekStr=$p(ItemData,"^",24)
		s $p(ItemData,"^",24)=##class(web.DHCDocUtil).Replace(FreqWeekStr,"@",$C(2))
		s retval=ItemRowid_"!"_ItemSeqNo_"!"_ItemData_"!"_ItemOrderType_"!"_"!"_ARCOSRowid_"!"_"OSItem"
		if (CopyData=""){
			s CopyData=retval
		}else{
			s CopyData=CopyData_"###"_retval
		}
		
	}
	d obj.Close()
	if (itmjs'="")&&(CopyData'=""){
		///s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		s retval="var CopyDataArr=('"_$ZCVT(CopyData,"O","JS")_"').split('###');"
		s retval=retval_itmjs_"(CopyDataArr);"
		&javascript<#(retval)#>
	}
	q CopyData
}

ClassMethod GetIPNecessaryCat(EpisodeID As %String, CurLogonHosp As %String = "") As %String
{
	n (EpisodeID,CurLogonHosp,%session)
	s OrderRowid=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:OrderRowid="" ""
	s IPNecessaryCat=..%GetConfig("IPNecessaryCat",CurLogonHosp)
	q:IPNecessaryCat="" ""
	s IPNecessaryCat="^"_IPNecessaryCat_"^"
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	q:PAAdmType'="I" ""
	Set langid=..%LanguageID()
	s Childsub=0
	for {
		s Childsub=$O(^OEORD(OrderRowid,"I",Childsub))
		q:Childsub=""
		continue:'$d(^OEORD(OrderRowid,"I",Childsub))
		s OeoriStatusDR=$p($g(^OEORD(OrderRowid,"I",Childsub,1)),"^",13)
		continue:OeoriStatusDR=""
		s OeoriStatusCode=$p($g(^OEC("OSTAT",OeoriStatusDR)),"^",1)
		i "ICU"[OeoriStatusCode{
			continue
		}
		s ItmMastrowid=$p($g(^OEORD(OrderRowid,"I",Childsub,1)),"^",2)
		s ItemCatDR=$p(^ARCIM(+ItmMastrowid,$P(ItmMastrowid,"||",2),1),"^",10)
		s IPNecessaryCat=$replace(IPNecessaryCat,"^"_ItemCatDR_"^","^")
	}
	s Prompt=""
	for i=1:1:$L(IPNecessaryCat,"^") {
		s Cat=$P(IPNecessaryCat,"^",i)
		continue:Cat=""
		s CatDsc=$P(^ARC("IC",Cat),"^",2)
		Set CatDsc= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",CatDsc,langid)
		i (Prompt=""){
			s Prompt=CatDsc
		}else{
			s Prompt=Prompt_"-"_CatDsc
		}
		
	}
	q Prompt
}

/// w ##Class(web.DHCDocOrderCommon).GetCMPrescTypeStr(397,2)
ClassMethod GetCMPrescTypeStr(EpisodeID As %String, LogonHospID As %String) As %String
{
	n (EpisodeID , LogonHospID)
	s ^temptan("GetCMPrescTypeStr")=EpisodeID_","_LogonHospID
	if (EpisodeID="") {
		s PAAdmType=""
	}else {
		s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	 }
	set CMPrescTypeStr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.CMDocConfig:FindCMPrescType")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(LogonHospID,"Y")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s CMPrescTypeCode=rset.GetData(1)
			s CMPrescTypeDesc=rset.GetData(2)
			s CMPrescTypeActive=rset.GetData(3)
			continue:(CMPrescTypeActive="N")
			s FormFreqDesc="",FormFreqRowid=""
			s FormDurDesc="",FormDurRowid="",FormDurFactor="1"
			s FormInstrDesc="",FormInstrRowid=""
			s DefaultQtyID="",DefaultQty=""
			s DefaultRefLoc=""
			
			s CNMedDefaultFrequence="",CNMedDefaultFrequenceDesc=""
			//默认频次
			s FormFreqRowid=..%GetConfig1(CMPrescTypeCode,"CNMedDefaultFrequence",LogonHospID)
			//$G(^DHCDocConfig(CMPrescTypeCode,"CNMedDefaultFrequence"))
			if (FormFreqRowid'=""){
				s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
			}
			//默认用法
			s FormInstrRowid=..%GetConfig1(CMPrescTypeCode,"CNMedDefaultInstruction",LogonHospID)
			//$G(^DHCDocConfig(CMPrescTypeCode,"CNMedDefaultInstruction"))
			if (FormInstrRowid'=""){
				s FormInstrDesc=$P($g(^PHCIN(FormInstrRowid)),"^",2)
			}
			//默认疗程
			s FormDurRowid=..%GetConfig1(CMPrescTypeCode,"CNMedDefaultDuration",LogonHospID)
			//$G(^DHCDocConfig(CMPrescTypeCode,"CNMedDefaultDuration"))
			i FormDurRowid'="" {
				s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
				s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
			}
			//默认用量
			s DefaultQtyID=..%GetConfig1(CMPrescTypeCode,"DefaultQty",LogonHospID)
			//$G(^DHCDocConfig(CMPrescTypeCode,"DefaultQty"))
			if (DefaultQtyID'=""){
				s DefaultQty=$p($g(^PHCDO(DefaultQtyID)),"^",3)
			}
			
			s CNItemCat=..%GetConfig(CMPrescTypeCode,LogonHospID)
			s (CMRecLocStr,OpenHospCMRecLocStr)=""
			if (EpisodeID'=""){
				//s CMRecLocStr=##Class(web.DHCDocOrderCommon).GetCMRecLoc(EpisodeID,CNItemCat,LogonHospID)
				//s OpenHospCMRecLocStr=##Class(web.DHCDocOrderCommon).GetCMRecLoc(EpisodeID,CNItemCat,LogonHospID,1)
				//if PAAdmType'="I" s DefaultRefLoc=..%GetConfig1(CMPrescTypeCode,"CNMedNormKLRefLoc",LogonHospID)
				//else  s DefaultRefLoc=..%GetConfig1(CMPrescTypeCode,"IPCNMedNormKLRefLoc",LogonHospID)
				s OrdParamObj=##class(DHCDoc.Util.ArrayData).%New()
				d OrdParamObj.SetAt(EpisodeID,"EpisodeID")
				d OrdParamObj.SetAt(CMPrescTypeCode,"CMPrescTypeCode")
				d OrdParamObj.SetAt(0,"OrderOpenForAllHosp")
				d OrdParamObj.SetAt("","CNMedCookModeRowId")	//暂时获取不到煎药方式
				d OrdParamObj.SetAt("","OrderPriorRowid")		//暂时获取不到医嘱类型
				d OrdParamObj.SetAt(LogonHospID,"LogonHospID")
				d OrdParamObj.SetAt("","OrderDateStr")
				s OrdParamJson=OrdParamObj.%ToJSON().Read()
				//子类
				s CMRecLocJson=##class(web.DHCDocOrderCommon).GetCMRecLocStr(OrdParamJson)
				s CMRecLocStr=##Class(DHCDoc.Util.ArrayData).%New().%FromJSON(CMRecLocJson).Data("CMRecLocStr")
				
				//跨院子类接收科室
				d OrdParamObj.SetAt(1,"OrderOpenForAllHosp")
				s OrdParamJson=OrdParamObj.%ToJSON().Read()
				s OpenHospCMRecLocJson=##class(web.DHCDocOrderCommon).GetCMRecLocStr(OrdParamJson)
				s OpenHospCMRecLocStr=##Class(DHCDoc.Util.ArrayData).%New().%FromJSON(OpenHospCMRecLocJson).Data("CMRecLocStr")
			}
			
			//自动计算附加材料数量
			s CNMedAppendItemQtyCalcu=..%GetConfig1(CMPrescTypeCode,"CNMedAppendItemQtyCalcu",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"CNMedAppendItemQtyCalcu"))
			//住院自动增加代煎费
			s IPCookModeFeeNoAutoAdd=..%GetConfig1(CMPrescTypeCode,"IPCookModeFeeNoAutoAdd",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"IPCookModeFeeNoAutoAdd"))
			if (##class(web.DHCDocOrderEntry).ValARCItem(IPCookModeFeeNoAutoAdd)){
				s IPCookModeFeeNoAutoAdd=""
			}
			//原代煎接收科室设置已弃用
			//代煎接受科室
			s CNMedCookReclocStr=""
			//if PAAdmType="" s CNMedCookReclocStr=""
			//else  s CNMedCookReclocStr=##class(web.DHCDocOrderEntryCM).GetCNMedCookRecloc(PAAdmType,LogonHospID,CMPrescTypeCode)
			//跨院代煎接收科室
			s OpenHospCNMedCookReclocStr=""
			//if PAAdmType="" s OpenHospCNMedCookReclocStr=""
			//else  s OpenHospCNMedCookReclocStr=##class(web.DHCDocOrderEntryCM).GetCNMedCookRecloc(PAAdmType,LogonHospID,CMPrescTypeCode,1)
			//代煎费
			s CNMedCookModeFeeItem=..%GetConfig1(CMPrescTypeCode,"CNMedCookModeFeeItem",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"CNMedCookModeFeeItem"))
			if (+CNMedCookModeFeeItem'=0){
				i '$d(^ARCIM(+CNMedCookModeFeeItem,$p(CNMedCookModeFeeItem,"||",2),1)) s CNMedCookModeFeeItem=""
			}
			if (##class(web.DHCDocOrderEntry).ValARCItem(CNMedCookModeFeeItem)){
				s CNMedCookModeFeeItem=""
			}
			//附加费
			s CNMedAppendItem=..%GetConfig1(CMPrescTypeCode,"CNMedAppendItem",LogonHospID)
			//$G(^DHCDocConfig(CMPrescTypeCode,"CNMedAppendItem"))
			if (+CNMedAppendItem'=0){
				i '$d(^ARCIM(+CNMedAppendItem,$p(CNMedAppendItem,"||",2),1)) s CNMedAppendItem=""
			}
			if (##class(web.DHCDocOrderEntry).ValARCItem(CNMedAppendItem)){
				s CNMedAppendItem=""
			}
			//禁用代煎勾选
			s NotAllowChangeCook=..%GetConfig1(CMPrescTypeCode,"NotAllowChangeCook",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"NotAllowChangeCook"))
			
			//住院默认处方类型
			s IPDefaultCMPrescType=..%GetConfig1(CMPrescTypeCode,"IPDefaultCMPrescType",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"IPDefaultCMPrescType"))
			//门诊默认处方类型
			s OPDefaultCMPrescType=..%GetConfig1(CMPrescTypeCode,"OPDefaultCMPrescType",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"OPDefaultCMPrescType"))
			//关联费用列表
			s CMPrescTypeLinkFeeStr=..%GetConfig1(CMPrescTypeCode,"CMPrescTypeLinkFee",LogonHospID) //$G(^DHCDocConfig(CMPrescTypeCode,"CMPrescTypeLinkFee"))
			
			s CNMedCookReclocStr=$Replace(CNMedCookReclocStr,$C(2),"!")
			s CNMedCookReclocStr=$Replace(CNMedCookReclocStr,$C(1),"@")
			s CMRecLocStr=$Replace(CMRecLocStr,$C(2),"!")
			s CMRecLocStr=$Replace(CMRecLocStr,$C(1),"@")
			
			s OpenHospCMRecLocStr=$Replace(OpenHospCMRecLocStr,$C(2),"!")
			s OpenHospCMRecLocStr=$Replace(OpenHospCMRecLocStr,$C(1),"@")
			s OpenHospCNMedCookReclocStr=$Replace(OpenHospCNMedCookReclocStr,$C(2),"!")
			s OpenHospCNMedCookReclocStr=$Replace(OpenHospCNMedCookReclocStr,$C(1),"@")
			//默认煎药方式
			s CNMedCookModeDefualt=..%GetConfig1(CMPrescTypeCode,"CNMedCookModeDefualt",LogonHospID)
			if CNMedCookModeDefualt'=""{
				if '$D(^DHCDocConfig("HospDr_"_LogonHospID,"CookMode",CNMedCookModeDefualt)){
					s CNMedCookModeDefualt=""
				}elseif FormInstrRowid'=""{
					s CookModeInstr=##class(DHCDoc.DHCDocConfig.DocConfig).GetCookModeInstr(CNMedCookModeDefualt,LogonHospID)
					if (CookModeInstr'="")&&(("^"_CookModeInstr_"^")'[("^"_FormInstrRowid_"^")){
						s CNMedCookModeDefualt=""
					}
				}
			}
			s Value=CMPrescTypeCode
			s Value=Value_"#"_FormFreqRowid_"!"_FormFreqDesc
			s Value=Value_"#"_FormInstrRowid_"!"_FormInstrDesc
			s Value=Value_"#"_FormDurRowid_"!"_FormDurDesc_"!!"_FormDurFactor
			s Value=Value_"#"_DefaultQtyID_"!"_DefaultQty
			
			s Value=Value_"#"_CNItemCat
			s Value=Value_"#"_CMRecLocStr
			s Value=Value_"#"_CNMedCookReclocStr
			s Value=Value_"#"_CNMedAppendItemQtyCalcu
			s Value=Value_"#"_IPCookModeFeeNoAutoAdd
			
			s Value=Value_"#"_CNMedCookModeFeeItem
			s Value=Value_"#"_CNMedAppendItem
			s Value=Value_"#"_NotAllowChangeCook
			s Value=Value_"#"_IPDefaultCMPrescType
			s Value=Value_"#"_OPDefaultCMPrescType
			s Value=Value_"#"_OpenHospCMRecLocStr
			s Value=Value_"#"_OpenHospCNMedCookReclocStr
			s Value=Value_"#"_CMPrescTypeLinkFeeStr
			s Value=Value_"#"_CNMedCookModeDefualt
			i CMPrescTypeStr="" s CMPrescTypeStr=Value_$C(1)_CMPrescTypeDesc
			e  s CMPrescTypeStr=CMPrescTypeStr_$C(2)_Value_$C(1)_CMPrescTypeDesc
		}
		d rset.Close()
 	}
 	q CMPrescTypeStr
}

ClassMethod GetARCOSCat(ARCOSRowid As %String) As %String
{
	q:ARCOSRowid="" ""
	s ARCOSCat=$P(^ARCOS(ARCOSRowid),"^",9)
	q ARCOSCat
}

ClassMethod GetARCOSName(ARCOSRowid As %String) As %String
{
	q:ARCOSRowid="" ""
	s ARCOSName=$P(^ARCOS(ARCOSRowid),"^",2)
	q ARCOSName
}

ClassMethod GetFormateOrderName(ArcimRowid As %String, CurLogonHosp As %String = "", langid As %String = "") As %String
{
 	n (ArcimRowid,CurLogonHosp,langid,%session)
 	if langid="" Set langid=..%LanguageID()
 	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
 	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
 	s OrderEntryNameDisplay=..%GetConfig("OrderEntryNameDisplay",CurLogonHosp)
 	//$g(^DHCDocConfig("OrderEntryNameDisplay"))
 	if (OrderEntryNameDisplay="GenericName"){
	 	;药品通用名
		s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimRowid)
	 	if (GenericName'="") s ArcimDesc=GenericName
	}
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
	Q:INCIRowid="" ArcimDesc
	s OrderSpecifications=..%GetConfig("OrderSpecifications",CurLogonHosp) //$g(^DHCDocConfig("OrderSpecifications")) //规格
	if (OrderSpecifications=1){
		if (..GetPHPrescTypeByItem(ArcimRowid)'=3){
			s OrdSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",INCIRowid)
			if (OrdSpec'="") s ArcimDesc=ArcimDesc_OrdSpec
		}
	}
	s OrderCompany=..%GetConfig("OrderCompany",CurLogonHosp) //$g(^DHCDocConfig("OrderCompany"))
	if (OrderCompany=1){
		s OrdComInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(INCIRowid)
		if (OrdComInfo'="") s ArcimDesc=ArcimDesc_$p(OrdComInfo,"^",3)
	}
	Q ArcimDesc
}

ClassMethod CheckIsNeedSkinAlert(EpisodeID As %String, ArcimRowid As %String) As %String
{
	s NeedSkinAlert=1
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Q:OEORDRowId="" "0"
	//获取医嘱项关联的过敏源
	s CurARCIMLinkAllergy=..GetArcimLinkAllergy(ArcimRowid)
	s OEORDRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	s CurrentDate=..%SysDate(),CurrentTime=..%SysTime()
	s OEORIChildsub=0
	f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:(OEORIChildsub="")||(NeedSkinAlert=0)  d
	.s OEORISttDat=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9)
	.s PriorityDR = $p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",8)
	.s LongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	.q:(OEORISttDat<(CurrentDate-3))&&(LongOrdFlag=0)
	.s itemstat=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	.q:($g(statcode)="I")||($g(statcode)="U")||($g(statcode)="C")
	.s ARCIMRowId=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.Q:(CurARCIMLinkAllergy="")&&(ARCIMRowId'=ArcimRowid)
	.s ARCIMLinkAllergy=""
	.i CurARCIMLinkAllergy'="" d
	..s ARCIMLinkAllergy=..GetArcimLinkAllergy(ARCIMRowId)
	.Q:(CurARCIMLinkAllergy'="")&&(..CompareAlleryStr(CurARCIMLinkAllergy,ARCIMLinkAllergy)=0)&&(ARCIMRowId'=ArcimRowid)
	.s OrdSkinTest=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,5)),"^",2) ;皮试
	.i OrdSkinTest="Y" d
	..s abnorm=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",3)
	..i abnorm'="" s NeedSkinAlert=0
	.q:(NeedSkinAlert=0)&&(LongOrdFlag=0)
	.for ExStDate=(CurrentDate-3):1:CurrentDate Q:NeedSkinAlert=0  d
	..s ExStTime=CurrentTime
	..f  s ExStTime=$o(^OEORDi(0,"Date",OEORDRowId,ExStDate,ExStTime)) q:(ExStTime="")||(NeedSkinAlert=0)  d
	...s OEOREChildsub=0
	...f  s OEOREChildsub=$o(^OEORDi(0,"Date",OEORDRowId,ExStDate,ExStTime,OEORIChildsub,OEOREChildsub)) q:(OEOREChildsub="")||(NeedSkinAlert=0)  d
	....s str = $g(^OEORD(OEORDRowId,"I",OEORIChildsub,"X",OEOREChildsub))
	....s ExecStateDR = $p(str,"^",16)
	....q:ExecStateDR=""
	....s ExecStateCode = $p(^OEC("STAT",ExecStateDR),"^",1)
	....q:ExecStateCode'="F"
	....s NeedSkinAlert=0
	q NeedSkinAlert
}

ClassMethod GetArcimLinkAllergy(ArcimRowid As %String) As %String
{
	n (ArcimRowid)
	s ALGRowId=0,ArcimLinkAllergyStr=""
	if +ArcimRowid'=0  d
	.f  s ALGRowId=$o(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"ALG",ALGRowId)) q:ALGRowId=""  d
	..s str=$g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"ALG",ALGRowId))
	..s ALGAllergyDR=$p(str,"^",3)
	..i ArcimLinkAllergyStr="" s ArcimLinkAllergyStr=ALGAllergyDR
	..e  s ArcimLinkAllergyStr=ArcimLinkAllergyStr_"^"_ALGAllergyDR
	Q ArcimLinkAllergyStr
}

ClassMethod CompareAlleryStr(CurARCIMLinkAllergy As %String, ARCIMLinkAllergy As %String) As %String
{
	s FindSameAllergy=0
	For i=1:1:$l(CurARCIMLinkAllergy,"^") q:FindSameAllergy=1  d
	.s oneAlleryDr=$p(CurARCIMLinkAllergy,"^",i)
	.q:("^"_ARCIMLinkAllergy_"^")'[("^"_oneAlleryDr_"^")
	.s FindSameAllergy=1
	Q FindSameAllergy
}

/// creator:郭荣勇
/// date:2017.6.16
/// desc:根据医嘱项目或者医嘱套得到其所有别名
/// input:Type 类型("ARCOS","ARCIM"),医嘱项目rowid(ARC_ItmMast)或者医嘱套rowid(ARC_OrdSets)
/// output:别名串,以^分割
/// other：w ##class(web.DHCDocOrderCommon).GetAliasByItem("ARCOS",4)
ClassMethod GetAliasByItem(Type As %String, ItemRowId As %String) As %String
{
	n (Type,ItemRowId)
	Q:(Type="")||(ItemRowId="") ""
	s Ret=""
	s Id=0
	for {
		s Id=$O(^ARC("ALIAS",0,Type,ItemRowId,Id)) q:Id=""
		s Text=$p(^ARC("ALIAS",Id),"^",6)
		s DateFrom=$p(^ARC("ALIAS",Id),"^",12)
		s DateTo=$p(^ARC("ALIAS",Id),"^",13)
		continue:(DateFrom'="")&&(DateFrom>+$h)
		continue:(DateTo'="")&&(DateTo<+$h)
		i Ret="" s Ret=Text
		e  s Ret=Ret_"^"_Text
	}
	
	Q Ret
}

/// creater lxz
/// desc 获取ST频次的频次ID
/// 对于原来医嘱录入的CSP判断迁移.
/// 1:医嘱审核插入执行记录调用该接口判断ST的执行记录时间为当前时间
/// 2:医嘱录入Csp界面调用.返回st
ClassMethod GetSTFreq() As %String
{
	s Hospital=..%GetConfig("CurrentHospital")
 	i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
	e  s HospitalCode=""
	s STFreqRowid=$O(^PHCFR(0,"Desc1","ST",0))
 	i HospitalCode="ZGYKDFSYY" s STFreqRowid=$O(^PHCFR(0,"Code","ST",0))
 	i HospitalCode="SDWFYY"    s STFreqRowid=$O(^PHCFR(0,"Code","ST",0))
 	q STFreqRowid
}

/// 根据周频次的间隔天数，找对应的第一个疗程
/// 需要考虑单位
ClassMethod GetFirstDurByWeekFreq(Days As %String, OrderFreqRowid As %String = "") As %String
{
	if OrderFreqRowid'=""{
		s IntervalTime=$p($g(^PHCFR(+OrderFreqRowid)),"^",5) ;频次间隔时间	$p(FreqStr,"^",12)
		s IntervalUnit=$P($g(^PHCFR(+OrderFreqRowid)),"^",14)	;间隔单位
		s:IntervalUnit="" IntervalUnit="D"
		if IntervalUnit="D"{
			s Days=IntervalTime
		}elseif IntervalUnit="H"{
			s Days=IntervalTime\24
			s:Days=0 Days=1
		}
	}
	s FindFlag=0,RowID="",CTPCPDesc="",CTPCPCode="",Facter=""
	Q:+Days="0" RowID_","_CTPCPDesc_","_CTPCPCode_","_Facter
	Set langid=..%LanguageID()
	s PHCDURowId=0
 	f  s PHCDURowId=$O(^PHCDU(PHCDURowId)) Q:(PHCDURowId="")||(FindFlag=1)  d
 	.s PHCDUCode=$P(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$P(^PHCDU(PHCDURowId),"^",2)
 	.Q:PHCDUFactor<Days
 	.s PHCDUDesc1=$P(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",PHCDUDesc1,langid)
 	.s PHCDUDesc2=$P(^PHCDU(PHCDURowId),"^",4)
 	.s PHCDUDesc2=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc2",PHCDUDesc2,langid)
 	.Q:PHCDUDesc2="饮片"
 	.s FindFlag=1
	.s RowID=PHCDURowId
	.s CTPCPDesc=PHCDUDesc1
	.s CTPCPCode=PHCDUCode
	.s Facter=PHCDUFactor
	Q RowID_","_CTPCPDesc_","_CTPCPCode_","_Facter
}

/// w ##Class(web.DHCDocOrderCommon).GetOrderMsg("685||1")
ClassMethod GetOrderMsg(EpisodeID As %String, ArcimRowId As %String) As %String
{
	n (EpisodeID,ArcimRowId)
	s ^tempscl("GetOrderMsg")=EpisodeID_","_ArcimRowId
	q:ArcimRowId="" ""
	q:$l(ArcimRowId,"||")=1 "" 
	q:'$d(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2))) ""
	s EpisodeType=$p(^PAADM(EpisodeID),"^",2)
	;维护的消息
	s OrderMsg=..GetARCIMOrderMsg(ArcimRowId)
	;皮试的消息
	s NeedSkinTestINCI=##class(web.DHCOutPhCommon).GetSkinTestFlag(ArcimRowId)
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowId,0))
	i DHCARCIMRowid'="" d
	.s NeedSkinTest=$P(^DHCItmMast(DHCARCIMRowid),"^",6)
	e  s NeedSkinTest="N"
	i NeedSkinTest="" s NeedSkinTest="N"
	i NeedSkinTest="N" s NeedSkinTest=NeedSkinTestINCI
	if (NeedSkinTest="Y"){
		if (OrderMsg=""){
			s OrderMsg="该医嘱需要皮试"
		}else{
			s OrderMsg=OrderMsg_";"_"该医嘱需要皮试"
		}
	}
	if (EpisodeType="I")&&(NeedSkinTest="Y") {
		s NeedSkinAlertFlag=..CheckIsNeedSkinAlert(EpisodeID,ArcimRowId)
		if (NeedSkinAlertFlag="1"){
			if (OrderMsg=""){
				s OrderMsg="该患者72小时之内没有进行皮试且无治疗用药,请开具皮试医嘱!"
			}else{
				s OrderMsg=OrderMsg_";"_"该患者72小时之内没有进行皮试且无治疗用药,请开具皮试医嘱!"
			}
		}
	}
	//if (OrderMsg=""){s OrderMsg="无"}
	q OrderMsg
}

// 验证数据是否有效

// 1 有效 0 无效

ClassMethod CheckDataValid(Type As %String, EpisodeID As %String, RowId As %String, LogonLocRowId As %String) As %String
{
	s ^tempscl("CheckDataValid")=Type_","_EpisodeID_","_RowId_","_LogonLocRowId
	q:RowId="" "1"
	s AdmType=""
	if (EpisodeID'=""){
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	}
	s LogonHospDr=$P(^CTLOC(LogonLocRowId),"^",22)
	if (Type="PHCFreq"){
		s Active=$P($g(^PHCFR(RowId)),"^",6)
		Q:Active="N" "0"
	    s AvailableType=$P($g(^PHCFR(RowId)),"^",7)
	    Q:(AvailableType'="")&&((","_AvailableType_",")'[(","_AdmType_","))&&(AdmType'="") "0"
	}elseif (Type="PHCInstruc"){
		s Active=$P($g(^PHCIN(RowId)),"^",4)
		Q:Active="N" "0"
		s ForbidDosingInstr=""
		if (EpisodeID'=""){
			s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
			s AvailableType=$P($g(^PHCIN(RowId)),"^",5)
			Q:(AvailableType'="")&&((","_AvailableType_",")'[(","_AdmType_","))&&(AdmType'="") "0"
			if (AdmLoc'=""){
				s ForbidDosing=$P($G(^CTLOC(AdmLoc,"DHC")),"^",18)
				i (ForbidDosing="1"){
					if (AdmType="I"){
						s ForbidDosingInstr=..%GetConfig("IPDosingInstr",LogonHospDr)
					}elseif (PAAdmType="O"){
						s ForbidDosingInstr=..%GetConfig("OPInfusionInstr",LogonHospDr)
					}
					i ForbidDosingInstr'="" s ForbidDosingInstr="^"_ForbidDosingInstr_"^"
				}
				Q:(ForbidDosingInstr[("^"_RowId_"^"))&&(ForbidDosingInstr'="") "0"
			}
		}
		
	}
	Q 1
}

/// 判断医嘱项目是否可以录入频次和疗程 
ClassMethod CanFrequenc(ArcimID As %String) As %String
{
	//录入频次的非药品子类
	Q:ArcimID="" "Y"
	s ItemCatRowid=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
	b ;01
	s OrderType=""
	i ItemCatRowid'="" s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	b //02
	Q:OrderType="R" "Y"
	s FrequencedItemCat=..%GetConfig("FrequencedItemCat")
	Q:("^"_FrequencedItemCat_"^")[("^"_ItemCatRowid_"^") "Y"
	q "N"
}

/// 获取登录科室可查看的病人类型
ClassMethod CheckLogonLocAdmTypeLimit(LogonLoc As %String, AdmType As %String) As %String
{
	n (LogonLoc,AdmType)
	s warning=""
	///没有维护数据的科室，默认能对所有病人下医嘱
	s Count=0
	s AdmTypeDr=""
	for {
		s AdmTypeDr=$O(^PAC("ADMLOC",0,"AdmType",AdmTypeDr))
		q:(AdmTypeDr="")
		if $D(^PAC("ADMLOC",0,"AdmType",AdmTypeDr,LogonLoc)) {
			s Count=Count+1
		}
	}
	if (Count=0){
		q warning
	}
	//基础数据-病人管理-访问类型位置
	i AdmType="N" s AdmType="I"
	if '$D(^PAC("ADMLOC",0,"AdmType",AdmType,LogonLoc)){
		s FindSuit=0
		s LinkLocDr=0
		for {
			Set LinkLocDr=$o(^CTLOC(LogonLoc,"LINK",0,"Loc",LinkLocDr))
			q:LinkLocDr=""
			if ($D(^PAC("ADMLOC",0,"AdmType",AdmType,LinkLocDr))){
				s FindSuit=1
				q
			}
		}
		s:FindSuit=0 warning="受访问类型位置限定,当前登录科室不可给此患者下医嘱."
	}
	q warning
}

ClassMethod CheckOEtime(Padate As %String, Patime As %String) As %String
{
    s curdate=..%SysDate()
    q:((curdate-Padate)>1) 1
    q:(curdate=Padate) 0
    s curtime=..%SysTime()
    s lasttime=86400-Patime
    q:(Patime>curtime) 0
    q:(Patime<curtime) 1
}

/// 修改返回值:0不限制,1本次就诊限制开一次,2患者所有就诊只能开一次
/// W ##class(web.DHCDocOrderCommon).CheckARCIMAllowOnlyOnce(116597)
ClassMethod CheckARCIMAllowOnlyOnce(EpisodeID As %String = "", ARCIMRowId As %String = "", ByRef DARCIMAllowOnlyOnce = "", ByRef DARCIMAdmAllowOnlyOnce = "")
{
	n (EpisodeID,ARCIMRowId,DARCIMAllowOnlyOnce,DARCIMAdmAllowOnlyOnce)
	s flag=0
	s DARCIMAllowOnlyOnce="N",DARCIMAdmAllowOnlyOnce="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ARCIMRowId,""))
	Q:DARCIMRowid="" flag
	s DARCIMAllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",13)		;一个患者只允许开一次
	s DARCIMAdmAllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",36)	;一次就诊只允许开一次
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	if (DARCIMAdmAllowOnlyOnce="Y"){
		s Paadm=EpisodeID
		d OneAdm
		s:Find flag=1
	}
	if 'flag&&(DARCIMAllowOnlyOnce="Y"){
		s Paadmtype="" for{
			s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype)) Q:Paadmtype=""
			s Paadm="" for{
				s Paadm=$o(^PAPERdr(PatientID,"ADM",Paadmtype,Paadm)) Q:Paadm=""
				d OneAdm
				s:Find flag=2
				Q:flag
			}
			Q:flag
		}
	}
	Q flag
OneAdm
	s Find=0
	s OEORDRowId=$o(^OEORD(0,"Adm",Paadm,"")) 
	Q:OEORDRowId=""
	s OEORISttDat="" for{
		s OEORISttDat=$o(^OEORDi(0,"ARCIM",OEORDRowId,ARCIMRowId,OEORISttDat)) Q:OEORISttDat=""
		s OEORIChildsub=0 for{
			s OEORIChildsub=$o(^OEORDi(0,"ARCIM",OEORDRowId,ARCIMRowId,OEORISttDat,OEORIChildsub)) Q:OEORIChildsub=""
			if ##class(DHCDoc.Order.Common).IsValidOrd(OEORDRowId_"||"_OEORIChildsub){
				s Find=1
				Q
			}
		}
		Q:Find
	}
	Q
}

/// w ##class(web.DHCDocOrderCommon).OrdSkinTestRuleText("929||1",65)
ClassMethod OrdSkinTestRule(ArcimRowid, EpisodeID) As %String
{
	n (ArcimRowid,EpisodeID)
	s NeedSkinAlert=""
	//获取医嘱项关联的过敏源
	s CurARCIMLinkAllergy=..GetArcimLinkAllergy(ArcimRowid)
	s CurrentDate=..%SysDate(),CurrentTime=..%SysTime()
	s minDate=..%SysDate()-3
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	if (AdmType="I"){
		s InPatDays=+##class(web.DHCDoc.OP.AjaxInterface).GetInPatAdmDays(EpisodeID)
		if (InPatDays>3){
			//住院天数大于3天,只验证本次就诊按当前时间往前推72小时是否有皮试结果
			s ord=$O(^OEORD(0,"Adm",EpisodeID,0))
			d CheckAdmSkinAlert(ord)
			Q:NeedSkinAlert'="" NeedSkinAlert
		}else{
			//小于三天,验证从当天起一个月内的门、急诊、住院就诊记录
			d CheckPatSkinAlert
		}
	}else{
		//门、急诊验证从当天起一个月内的就诊记录
		d CheckPatSkinAlert
	}
	Q NeedSkinAlert
CheckAdmSkinAlert(ord)
	for StDate=CurrentDate:-1:minDate {
		s ordSub=0
		for {
			s ordSub=$o(^OEORDi(0,"StDt",StDate,ord,ordSub))
			Q:(ordSub="")||(NeedSkinAlert'="")
			s OEORISttTime=$p($g(^OEORD(ord,"I",ordSub,1)),"^",10)
			s DifferTime=(CurrentDate-StDate-1)*24+((CurrentTime+86400-OEORISttTime)/3600)
			if (DifferTime<=72){
				d GetOrdSkinAlert(ord,ordSub)
				Q:NeedSkinAlert'=""
			}
		}
	}
	Q NeedSkinAlert
GetOrdSkinAlert(ord,ordSub)
	s itemstat=$p($g(^OEORD(ord,"I",ordSub,1)),"^",13)
	i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	Q:($g(statcode)'="V")&&($g(statcode)'="E") ""
	s OrdSkinTest=$p($g(^OEORD(ord,"I",ordSub,5)),"^",2) ;皮试
	//Q:OrdSkinTest'="Y" ""
	s ARCIMRowId=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	Q:(CurARCIMLinkAllergy="")&&(ARCIMRowId'=ArcimRowid) ""
	s ARCIMLinkAllergy=""
	i CurARCIMLinkAllergy'="" s ARCIMLinkAllergy=..GetArcimLinkAllergy(ARCIMRowId)
	Q:(CurARCIMLinkAllergy'="")&&(..CompareAlleryStr(CurARCIMLinkAllergy,ARCIMLinkAllergy)=0)&&(ARCIMRowId'=ArcimRowid) ""
	s abnorm=$p($g(^OEORD(ord,"I",ordSub,11)),"^",3)
	i abnorm="" //s NeedSkinAlert=0 //没有皮试结果
	e  i abnorm="Y" s NeedSkinAlert=1 //阳性
	e  s NeedSkinAlert=2 //阴性
	Q NeedSkinAlert
CheckPatSkinAlert
	/*for AdmDate=..%SysDate():-1:($h-30){
		Q:NeedSkinAlert'=""
		s AdmId=0
		for {
			s AdmId=$o(^PAADMi("AdmDateCurr",AdmDate,AdmId))
			Q:(AdmId="")||(NeedSkinAlert'="")
			s ord=$O(^OEORD(0,"Adm",AdmId,0))
			if (ord'=""){
				d CheckAdmSkinAlert(ord)
			}
		}
	}*/
	f AdmType="I","O","E" {
		Q:NeedSkinAlert'=""
		s AdmId=""
		for {
			s AdmId=$o(^PAPERdr(PatientID,"ADM",AdmType,AdmId),-1) 
			Q:(AdmId="")||(NeedSkinAlert'="")
			s AdmDate=$p(^PAADM(AdmId),"^",6)
			if (AdmDate<=..%SysDate())&&(AdmDate>=($h-30)){
				s ord=$O(^OEORD(0,"Adm",AdmId,0))
				if (ord'=""){
					d CheckAdmSkinAlert(ord)
				}
			}
		}
	}
	Q NeedSkinAlert
}

/// w ##class(web.DHCDocOrderCommon).OrdSkinTestRule("929||1",70)
ClassMethod OrdSkinTestRuleOld(ArcimRowid, EpisodeID) As %String
{
	n (ArcimRowid,EpisodeID)
	s NeedSkinAlert=""
	//获取医嘱项关联的过敏源
	s CurARCIMLinkAllergy=..GetArcimLinkAllergy(ArcimRowid)
	s CurrentDate=..%SysDate(),CurrentTime=..%SysTime()
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	f AdmType="I","O","E" d
	.s AdmId=""
	.f  s AdmId=$O(^PAPERdr(PatientID,"ADM",AdmType,AdmId),-1) q:(AdmId="")||(NeedSkinAlert'="")  d	//从最新的就诊记录检索
	..q:$D(^PAADMi("PAADM_VisitStatus","C",AdmId))
	..s ord=$O(^OEORD(0,"Adm",AdmId,0))
	..q:ord=""
	..s ordSub=0
	..f  s ordSub=$o(^OEORD(ord,"I",ordSub)) q:(ordSub="")||(NeedSkinAlert'="")  d
	...s OEORISttDat=$p($g(^OEORD(ord,"I",ordSub,1)),"^",9)
	...s OEORISttTime=$p($g(^OEORD(ord,"I",ordSub,1)),"^",10)
	...//q:(OEORISttDat<(CurrentDate-7))
	...s DifferTime=(CurrentDate-OEORISttDat-1)*24+((CurrentTime+86400-OEORISttTime)/3600)
	...q:DifferTime>72 //只查询72小时内的医嘱
	...s itemstat=$p($g(^OEORD(ord,"I",ordSub,1)),"^",13)
	...i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
	...q:($g(statcode)'="V")&&($g(statcode)'="E")
	...s ARCIMRowId=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)
	...Q:(CurARCIMLinkAllergy="")&&(ARCIMRowId'=ArcimRowid)
	...s ARCIMLinkAllergy=""
	...i CurARCIMLinkAllergy'="" s ARCIMLinkAllergy=..GetArcimLinkAllergy(ARCIMRowId)
	...Q:(CurARCIMLinkAllergy'="")&&(..CompareAlleryStr(CurARCIMLinkAllergy,ARCIMLinkAllergy)=0)&&(ARCIMRowId'=ArcimRowid)
	...s OrdSkinTest=$p($g(^OEORD(ord,"I",ordSub,5)),"^",2) ;皮试
	...i OrdSkinTest="Y" d
	....s abnorm=$p($g(^OEORD(ord,"I",ordSub,11)),"^",3)
	....i abnorm="" s NeedSkinAlert=0 //没有皮试结果
	....e  i abnorm="Y" s NeedSkinAlert=1 //阳性
	....e  s NeedSkinAlert=2 //阴性
	...q:NeedSkinAlert'=""
	q NeedSkinAlert
}

/// 描述：根据就诊id判断该病人是否在有效就诊时间内 
/// 入参：就诊id，
/// w ##class(web.DHCDocOrderCommon).GetVisitTimeToDay("4027")
/// w ##class(web.DHCDocOrderCommon).GetVisitTimeToDay("3808")
/// 出参：0：在有效就诊时间内 "-100^单位（天、小时）^时间：不在有效时间内，单位代表配置的单位，时间代表配置的时间
ClassMethod GetVisitTimeToDay(Adm As %String)
{
	s rtn=0
	q:Adm="" rtn
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
	s AdmType=$p(^PAADM(Adm),"^",2)
	s AdmDate=$p(^PAADM(Adm),"^",6)
	s AdmTime=$p(^PAADM(Adm),"^",7)
	s date=..%SysDate()
	s time=..%SysTime()
	s StayStr=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(Adm)
	//留观的不判断
	if ($p(StayStr,"^",1)="Y")&&(AdmType="E"){
		q rtn
	}
	i AdmType="E" d
	.s LimitTime=..%GetConfig("EPAdmDayLimit",AdmHospitalId)
	.s LimitType=..%GetConfig("EPLimitType",AdmHospitalId)
	e  d
	.s LimitTime=..%GetConfig("OPAdmDayLimit",AdmHospitalId)
	.s LimitType=..%GetConfig("OPLimitType",AdmHospitalId)
	
	
	i LimitTime="" d
	.s LimitTime=1
	.s LimitType="Day"
	if LimitType="Day" d 
	.s DifferTime=date-AdmDate
	.i +LimitTime<1 s LimitTime=1
	.i DifferTime>(LimitTime-1) d
	..i (LimitTime=1) s LimitTime="当"
	..s rtn="-100^天^"_LimitTime
	if LimitType="Hour" d
	.s DifferTime=(date-AdmDate-1)*24+((time+86400-AdmTime)/3600)
	.i DifferTime>LimitTime s rtn="-100^小时^"_LimitTime
	
	q rtn
}

/// 根据就诊类型获取门诊/住院对应的发药单位 仅限于药品 （草药取药学项单位）
/// w ##class(web.DHCDocOrderCommon).GetPhDispUom("23974||1","I")
ClassMethod GetPhDispUom(ArcimDr As %String, AdmType As %String, HospitalId As %String = "") As %String
{
	n (ArcimDr,AdmType,HospitalId,%session)
	Q:ArcimDr="" ""
	;应该统一调用药房的接口:##class(web.DHCSTINTERFACE).GetPhDispUom 需修正 20190523
	
	s InciRowId=##class(web.DHCSTCOMINC).GetInciID(ArcimDr)
	;Q:InciRowId="" ""
	s ItemCatDR=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	Q:OrderType'="R" ""
	s OutPhUomDr="",InPhUomDr=""
	if (InciRowId'=""){
		s OutPhUomDr=$p(^INCI(InciRowId,1),"^",12)
		i '$d(^CT("UOM",OutPhUomDr)) s OutPhUomDr=""
		s InPhUomDr=$p(^INCI(InciRowId,1),"^",13)
		i '$d(^CT("UOM",InPhUomDr)) s InPhUomDr=""
	}
	//if (OutPhUomDr="")||(InPhUomDr="") {
		;判断是否是协定处方 0 不是,1 是 则返回单位 付 85
		;s FormulaFlag=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(ArcimDr)
		;Q:FormulaFlag="1" 85
		
		;判断是否是草药 0 不是,1 是 则返回药学基本单位 g 219
		s PhUomDr=""
		s CNMedFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimDr,HospitalId)
		
		if (CNMedFlag="1") {
			s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimDr)
			i DrgformRowid'="" s PhUomDr=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2)),"^",4)
			i PhUomDr'="" {
				s OutPhUomDr=PhUomDr
				s InPhUomDr=PhUomDr
			}
		}
	//}
	if ((AdmType="O")||(AdmType="E")||(AdmType="H")) {
		q OutPhUomDr
	}else{
		q InPhUomDr
	}
}

ClassMethod GetOrderType(ArcimRowid As %String) As %String
{
	n (ArcimRowid)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	Q OrderType
}

ClassMethod GetOrderSubCat(ArcimRowid As %String) As %String
{
	n (ArcimRowid)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	Q ItemCatRowid
}

/// creator:郭荣勇
/// date：2019-03-11
/// desc: 判断是否是下医嘱人(含下医嘱医生)
/// input:OEORI 医嘱RowId,UserId 需判断的操作用户RowId
/// output:Y 是,N 不是
ClassMethod IsEntryOEORIUser(OEORI As %String, UserId As %String) As %String
{
	n (OEORI,UserId)
	
	s ret="N"
	Q:UserId="" ret
	s DoctorDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",11)
	if DoctorDR'="" {
		s OEORIUserAdd=$o(^SSU("SSUSR",0,"CTPCP",DoctorDR,""))
		i OEORIUserAdd=UserId s ret="Y" q ret
	}
	s UserAddDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),7)),"^",1)
	if UserAddDR'="" {
		i UserAddDR=UserId s ret="Y" q ret
	}
	s LinOrdRowid = $p(^OEORD(+OEORI,"I",$P(OEORI,"||",2),11),"^",39)
	if (LinOrdRowid=""){
		s LinOrdRowid = $p($G(^OEORD(+OEORI,"I",$P(OEORI,"||",2),"DHC")),"^",54)
		}
	if (LinOrdRowid'=""){
		s DoctorDR=$p($g(^OEORD(+LinOrdRowid,"I",$p(LinOrdRowid,"||",2),1)),"^",11)
		if DoctorDR'="" {
			s OEORIUserAdd=$o(^SSU("SSUSR",0,"CTPCP",DoctorDR,""))
			i OEORIUserAdd=UserId s ret="Y" q ret
		}
		s UserAddDR=$p($g(^OEORD(+LinOrdRowid,"I",$p(LinOrdRowid,"||",2),7)),"^",1)
		if UserAddDR'="" {
			i UserAddDR=UserId s ret="Y" q ret
		}
	}
	
	Q ret
}

/// 医嘱录入选择行后获取各个接收科室的库存数
/// w ##class(web.DHCDocOrderCommon).GetOrderStockMsg(198,"5676||1","住院药房/静脉药物配置中心","")
ClassMethod GetOrderStockMsg(EpisodeID As %String, ArcimRowId As %String, OrdRecLocStr As %String, OrderDepRowId As %String) As %String
{
	s ^Tempscl("GetOrderStockMsg")=EpisodeID_","_ArcimRowId_","_OrdRecLocStr_","_OrderDepRowId
	s OrderMsg=""
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	Set langid=..%LanguageID()
	s INCI=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowId)
	if (INCI'=""){
		s INCIbaseuom=$p(^INCI(INCI,1),"^",10) //库存基本单位
		s INCIbaseuomDesc=""
		i INCIbaseuom'="" s INCIbaseuomDesc=$p($g(^CT("UOM",INCIbaseuom)),"^",2)
	}else{
		s INCIbaseuomDesc=""
	}
	for i=1:1:$l(OrdRecLocStr,"/"){
		s RecLocDesc=$P(OrdRecLocStr,"/",i)
		s RecLocDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTLoc","CTLOCDesc","EN",RecLocDesc)
		s ReclocRowId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RecLocDesc),""))
		continue:ReclocRowId=""
		s StockQtyStr=##Class(web.DHCSTINTERFACE).GetIncilQtyList(ArcimRowId,ReclocRowId,EpisodeType) //##class(web.DHCDocOrderEntry).GetStockQty(EpisodeID,ArcimRowId,OrderDepRowId,ReclocRowId)
		s StockQty=##class(DHCDoc.Util.Base).FormateNumber(+$P(StockQtyStr,"^",9))
		s RecLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",RecLocDesc,langid)
		s INCIbaseuomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",INCIbaseuomDesc,langid)
		s StockQty=StockQty_"("_INCIbaseuomDesc_")"
		i OrderMsg="" s OrderMsg=RecLocDesc_":"_StockQty
		e  s OrderMsg=OrderMsg_"  "_RecLocDesc_":"_StockQty
	}
	Q OrderMsg
}

ClassMethod GetARCIMFreeDurgFlag(ARCIMRowid As %String, HOSPID As %String = "") As %String
{
	n (ARCIMRowid,HOSPID,%session)
	s HOSPID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HOSPID)
	Q ##class(PHA.FACE.OUT.Com).ChkFreeDrug(ARCIMRowid,HOSPID)
	/*s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowid,0))
	Q:DHCARCIMRowid="" ""
	s FreeDurgFlag=$p(^DHCItmMast(DHCARCIMRowid),"^",21)
	s FreeDurgFlag=$case(FreeDurgFlag,"Y":"Y",:"")
	q $g(FreeDurgFlag)*/
}

ClassMethod GetAdmReasonDesc(AdmReasonDr) As %String
{
	Q:AdmReasonDr=""
	set AdmReason=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	Q AdmReason
}

/// Description: 根据开医嘱时间取接收科室串
/// w ##class(web.DHCDocOrderCommon).GetRecLocStrByOrdDate("90979","19355||1","1","","87","5","87"_$c(1)_"住院药房"_$c(1)_"Y"_$c(1,2)_"89"_$c(1)_"手术室药房"_$c(1)_"N"_$c(1),"2","57","2020-05-05 09:57:13","0")
ClassMethod GetRecLocStrByOrdDate(OrdParamJson As %String) As %String
{
	n (OrdParamJson,%session)
	k CalPackArr
	k OrdParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdParamJson,.OrdParamArr)
	s EpisodeID=OrdParamArr("EpisodeID")
	s ARCIMRowId=OrdParamArr("ARCIMRowId")
	s OrderPriorRowid=OrdParamArr("OrderPriorRowid")
	s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
	
	s OrderPriorRemarksRowId=OrdParamArr("OrderPriorRemarksRowId")
	
	s OrderInstrRowid=OrdParamArr("OrderInstrRowid")
	s OrdDepRowId=OrdParamArr("OrdDepRowId")
	s CurLogonDep=OrdParamArr("CurLogonDep")
	s OrderDateStr=OrdParamArr("OrderDateStr")
	s OrderOpenForAllHosp=OrdParamArr("OrderOpenForAllHosp")
	//未用到
	s OrderOutPriorRecLocStr=OrdParamArr("OrdOutPriorRecLocStr")
	//未用到
	s OrderOnePriorRecLocStr=OrdParamArr("OrderOnePriorRecLocStr")
	s OldCurrentRecLocStr=OrdParamArr("CurrentRecLocStr")
	s HOSPID=$p(^CTLOC(CurLogonDep),"^",22)
	
	;按登录科室取接收科室设置
	s CFRecLocByLogonLoc=""
	i OrdDepRowId="" {
		i CurLogonDep'="" s CFRecLocByLogonLoc=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CurLogonDep,1)
	    i CFRecLocByLogonLoc=1 s OrdDepRowId=CurLogonDep
	}
	//----
	k ParamJson,ParamArr
	s ParamArr("EpisodeID")=EpisodeID
    s ParamArr("SessionStr")="^^"_CurLogonDep_"^"_HOSPID
    s ParamArr("OpenForAllHosp")=OrderOpenForAllHosp
    s ParamArr("FindRecLocByLogonLoc")=$CASE(OrdDepRowId,"":0,:1)
	s ParamArr("DefaultReclocRowid")=""
    s ParamArr("OrderARCIMRowid")=ARCIMRowId
    s ParamArr("OrderInstrRowid")=OrderInstrRowid
    s ParamArr("OrderDateStr")=OrderDateStr
    s ParamArr("OrderPriorRowid")=OrderPriorRowid
    s ParamArr("OrderPriorRemarksRowId")=OrderPriorRemarksRowId

	s ParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParamArr)
	s RecLocJson=..GetRecLocInfo(ParamJson)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocJson,.RecLocArr)

	s CurrentRecLocStr=$G(RecLocArr("CurrentRecLocStr"))
	if (OldCurrentRecLocStr=CurrentRecLocStr) s RecLocArr("NotChangeRecLocStr")="Y"
	s RecLocJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.RecLocArr)
    Q RecLocJson
}

/***
  **Description      :获取医嘱录入接受科室相关数据
                     :获取草药接受科室相关数据请使用web.DHCDocOrderCommon.GetCMRecLocStr
  **Quote            :医嘱录入、治疗申请单、检查检验申请单、化疗单
  **Author           :tanjishan
  **Time             :2022/02/16
  **debugger         :w ##Class(web.DHCDocOrderCommon).GetRecLocInfo(^TEMP("GetRecLocInfo"))
  **Parameter        OrdParamJson:
					{
						"EpisodeID":*就诊号,
						"SessionStr":*Session串，参照DHCDoc.Util.RegisteredObject->%SessionStr，主要应用为按登陆科室取接受科室、翻译两个场景,
						"OpenForAllHosp":*是否允许跨院接收，(1/0),
						"FindRecLocByLogonLoc":*是否按照登录科室获取接受科室，(1/0),
						"DefaultReclocRowid":*期望的默认接受科室ID，可在使用医嘱套、存在常用用法或治疗指定接受科室时使用，未维护该接受科室时会忽略该参数,
						"OrderARCIMRowid":*医嘱项ID,
						"OrderInstrRowid":当前用法ID,用于获取用法接受科室,非必填
						"OrderDateStr":医嘱开立时间，用于验证接受科室的上下班时间,默认按当前时间判断,非必填
						"OrderPriorRowid":*医嘱优先级,
						"OrderPriorRemarksRowId":附加说明(OM/ZT/ONE),可统一使用医嘱优先级，内部也会自动识别附加说明
						"NotifyClinician":医嘱加急标志(Y\N)
						"LinkOrderARCIMList":成组的药品医嘱串(^分割),用于识别成组静配或TPN成组静配
					}
  **Returns          :ResLocInfo
					{
						"CurrentRecLocStr":完全符合当前计算规则的接受科室串,
						"OrderNormalRecLocStr":常规接受科室串,
						"OrderHolidayRecLocStr":节假日接受科室串,
						"OrderOutPriorRecLocStr":出院带药接受科室串,
						"OrderOnePriorRecLocStr":取药医嘱接受科室串
					}

  					接受科室串说明:科室ID_$C(1)_科室描述_$C(1)_默认标志(Y/N)_$C(1)_限制某个医嘱优先级下使用_$C(1)_节假日标志(Y/N)_$C(1)_限制加急状态使用(空/N/Y)_$C(2)_第二组接受科室_$C(2)_第三组接受科室
***/
ClassMethod GetRecLocInfo(OrdParamJson As %String) As %String [ ProcedureBlock = 1 ]
{
	;s ^TEMP("GetRecLocInfo")=OrdParamJson
    k OrdParamArr,RecLocArr
    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdParamJson,.OrdParamArr)
    ///常规数据入参
    s EpisodeID=OrdParamArr("EpisodeID")
    s SessionStr=OrdParamArr("SessionStr")
    s OpenForAllHosp=OrdParamArr("OpenForAllHosp")
    s FindRecLocByLogonLoc=$G(OrdParamArr("FindRecLocByLogonLoc"))
    s DefaultReclocRowid=$G(OrdParamArr("DefaultReclocRowid"))
    ///行数据入参
    s OrderARCIMRowid=OrdParamArr("OrderARCIMRowid")
    s OrderInstrRowid=$G(OrdParamArr("OrderInstrRowid"))
    s OrderDateStr=$G(OrdParamArr("OrderDateStr"))
    s OrderPriorRowid=OrdParamArr("OrderPriorRowid")
    s OrderPriorRemarksRowId=$g(OrdParamArr("OrderPriorRemarksRowId"))
	s NotifyClinician=$g(OrdParamArr("NotifyClinician"))
	s NotifyClinician=$CASE(NotifyClinician,"Y":"Y",:"N")
	s LinkOrderARCIMList=$g(OrdParamArr("LinkOrderARCIMList"))
    //真正的医嘱优先级
    s SpecOrderPriorRowid=##class(web.DHCOEOrdItemView).ReSetOrderPriorRowid(OrderPriorRowid,OrderPriorRemarksRowId)

	s AppendPriorStr=##class(web.DHCOEOrdItemView).SplitOrderPriorRowid(SpecOrderPriorRowid)
	s OrderPriorRowid=$P(AppendPriorStr,"^",1)
	s OrderPriorRemarksRowId=$P(AppendPriorStr,"^",3)
    
    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
    s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
    s SpecOrderPriorCode=$P(^OECPR(SpecOrderPriorRowid),"^",1)
    s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
    s LgUserID=$P(SessionStr,"^",1)
    s LgGroupID=$P(SessionStr,"^",2)
    s LgDeptID=$p(SessionStr,"^",3)
    s LgHospID=$p(SessionStr,"^",4)
	s langid=$p(SessionStr,"^",6)
	i (LgHospID=""){
		s LgHospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LgDeptID)
	}
    s OrderDepRowid=""
    if (FindRecLocByLogonLoc=1){
        s OrderDepRowid=LgDeptID
    }
    s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	//2019-12-11 长期医嘱接收科室不受节假日接收科室限制
	//按节假日接收科室设置 
	s RecLocStr="",OrderHolidayRecLocStr=""
	
	s OrderHolidayRecLocStr=..GetHolidaysRecLoc(EpisodeID,OrderDepRowid,OrderARCIMRowid,OpenForAllHosp,OrderDateStr,SpecOrderPriorRowid)

	//如果节假日接收科室设置为空则取正常接收科室定义
	i OrderDepRowid'="" s RecLocStr=..GetLocRecLoc(OrderDepRowid,OrderARCIMRowid,OpenForAllHosp,OrderDateStr,PAAdmType)
	e  s RecLocStr=..GetRecloc(EpisodeID,OrderARCIMRowid,OpenForAllHosp,OrderDateStr)
	
	//医嘱走节假日接收科室时同时显示按医嘱项/子类/大类维护的接收科室,处理某些医嘱只有某个接收科室才能处理。但默认接收科室认为节假日接收科室
	if (OrderHolidayRecLocStr'="")&&(RecLocStr'="") {
        //严格使用节假日接收科室时,只获取节假日接收科室,不再使用常规配置中的接收科室
        s StrictHolRecLoc=##class(web.DHCDocConfig).GetConfigNode("StrictHolRecLoc",LgHospID)
        if (StrictHolRecLoc'=1){
            for i=1:1:$LENGTH(RecLocStr,$C(2)) {
                s OneRecLocStr=$P(RecLocStr,$C(2),i)
                s OneReclocRowId=$P(OneRecLocStr,$C(1),1)
                s OneReclocDesc=$P(OneRecLocStr,$C(1),2)
                s OneOrderPriority=$P(OneRecLocStr,$C(1),4)
                
                i OrderHolidayRecLocStr'[(OneReclocRowId_$C(1)_OneReclocDesc) {
                    s OrderHolidayRecLocStr=OrderHolidayRecLocStr_$C(2)_OneRecLocStr                
                }else {
                    /*
                    s NewRecLocStr=""
                    // 如果医嘱接收科室和节假日定义的接收科室一致的时候，开长嘱就没接收科室了
                    f j=1:1:$l(OrderHolidayRecLocStr,$C(2)) {
                        s OneHolidayRecLoc=$p(OrderHolidayRecLocStr,$C(2),j)
                        if OneHolidayRecLoc[(OneReclocRowId_$C(1)_OneReclocDesc) {
                            s $p(OneHolidayRecLoc,$c(1),5)=""
                        }
                        if NewRecLocStr="" s NewRecLocStr=OneHolidayRecLoc
                        else  s NewRecLocStr=NewRecLocStr_$c(2)_OneHolidayRecLoc
                    }
                    s OrderHolidayRecLocStr=NewRecLocStr
                    */
                    ///pb by tanjishan 2022-06-10 现在节假日接受科室设置对长嘱也生效，医嘱接收科室和节假日定义的接收科室一致的时候，应该还是算坐节假日接受科室
                    s NewRecLocStr=OrderHolidayRecLocStr
                    f j=1:1:$l(OrderHolidayRecLocStr,$C(2)) {
                        s OneHolidayRecLoc=$p(OrderHolidayRecLocStr,$C(2),j)
                        if OneHolidayRecLoc'[(OneReclocRowId_$C(1)_OneReclocDesc) {
                            continue
                        }
                        //当医嘱优先级条件、加急标志条件不一致时，也需要同步展示，防止出现找不到接受科室的问题
                        if ($P(OneHolidayRecLoc,$C(1),4))=($P(OneRecLocStr,$C(1),4))&&
                            ($P(OneHolidayRecLoc,$C(1),6))=($P(OneRecLocStr,$C(1),6)){
                            continue
                        }
                        if NewRecLocStr="" s NewRecLocStr=OneRecLocStr
                        else  s NewRecLocStr=NewRecLocStr_$c(2)_OneRecLocStr
                    }
                    s OrderHolidayRecLocStr=NewRecLocStr
                }
            }
        }
	}
	//按用法取接收科室,如果按用法取不到接收科室,则返回接收科室入参串RecLocStr.
	//此处不能调用按用法取接收科室篡改RecLocStr的值,这样将导致前台修改用法后无法得到正确的接收科室.转到前台js中处理
	s ReclocByInstr=..%GetConfig("ReclocByInstr",LgHospID)
	i (ReclocByInstr="1")&&(OrderType="R")&&(OrderInstrRowid'=""){
		s InstrLinkOrderARCIMList=LinkOrderARCIMList_"^"_OrderARCIMRowid
		s RecLocStr=..GetInstrRecLocStr(EpisodeID,OrderInstrRowid,OrderDepRowid,ItemCatRowid,OrderPriorRowid,RecLocStr,LgHospID,OpenForAllHosp,OrderDateStr,InstrLinkOrderARCIMList)
	}
    s OrderOutPriorRecLocStr="",OrderOnePriorRecLocStr=""
	i PAAdmType="I" {
		i OrderDepRowid'="" s OrderOutPriorRecLocStr=..GetLocOutOrderRecloc(OrderDepRowid,OrderARCIMRowid,OpenForAllHosp)
		e  s OrderOutPriorRecLocStr=..GetOutOrderRecloc(EpisodeID,OrderARCIMRowid,OpenForAllHosp)
		
		i OrderDepRowid'="" s OrderOnePriorRecLocStr=..GetLocOneOrderRecloc(OrderDepRowid,OrderARCIMRowid,OpenForAllHosp)
		e  s OrderOnePriorRecLocStr=..GetOneOrderRecloc(EpisodeID,OrderARCIMRowid,OpenForAllHosp)
	}
    s RecLocStr=..CheckItemRecLoc(OrderARCIMRowid,RecLocStr,EpisodeID)
	s RecLocStr=##class(web.DHCARCOrdSets).CheckARCOSItemRecLoc(RecLocStr,DefaultReclocRowid)
    s OrderHolidayRecLocStr=..CheckItemRecLoc(OrderARCIMRowid,OrderHolidayRecLocStr,EpisodeID)
	s OrderHolidayRecLocStr=##class(web.DHCARCOrdSets).CheckARCOSItemRecLoc(OrderHolidayRecLocStr,DefaultReclocRowid)
	
    s OrderOutPriorRecLocStr=..CheckItemRecLoc(OrderARCIMRowid,OrderOutPriorRecLocStr,EpisodeID)
    s OrderOnePriorRecLocStr=..CheckItemRecLoc(OrderARCIMRowid,OrderOnePriorRecLocStr,EpisodeID)
    s CalPackArr("NotChangeRecLocStr")="N"

	s RecLocParams=##Class(DHCDoc.Util.ArrayData).%New()
	d RecLocParams.SetAt(SpecOrderPriorRowid,"PriorRowId")
	d RecLocParams.SetAt(NotifyClinician,"NotifyClinician")
	

	if ((PAAdmType="I")&&(OrderType="R")) {
		//注：  出院带药、取药医嘱接收科室定义优先级高于节假日接收科室
	    //      非长期药品医嘱节假日接收科室优先级高于用法接收科室
        //      用法接受科室
        //      接受科室设置（医嘱项>子类>大类）
	    if (((OrderPriorCode="OUT")||(OrderPriorRemarksRowId="OUT"))&&(OrderOutPriorRecLocStr'="")) {
		    s CalPackArr("NotChangeRecLocStr")="Y"
		    s CurrentRecLocStr =OrderOutPriorRecLocStr
		}elseif (((OrderPriorCode="ONE")||(OrderPriorRemarksRowId="ONE")) && (OrderOnePriorRecLocStr'="")) {
			s CalPackArr("NotChangeRecLocStr")="Y"
			s CurrentRecLocStr =OrderOnePriorRecLocStr
		}elseif ((OrderHolidayRecLocStr'="")){
			//(LongPriorFlag'="1")&&  --tanjishan 不再验证医嘱类型,
			s CurrentRecLocStr=##class(web.DHCOEOrdItemView).GetRecLocStrByParams(OrderHolidayRecLocStr, RecLocParams.%ToJSON().Read())
		}else {
            s CurrentRecLocStr =##class(web.DHCOEOrdItemView).GetRecLocStrByParams(RecLocStr, RecLocParams.%ToJSON().Read())
        }
	}else {
	    if (OrderHolidayRecLocStr'="") {
		    s CurrentRecLocStr=##class(web.DHCOEOrdItemView).GetRecLocStrByParams(OrderHolidayRecLocStr, RecLocParams.%ToJSON().Read())
			// 节假日接收科室默认值需要重置用户选择，防止节假日加急医嘱切换失败
			for i=1:1:$L(CurrentRecLocStr,$C(2)) {
				s ArrData =$P(CurrentRecLocStr,$C(2),i)
				if (($P(ArrData,$C(1),3)="Y")) {
					s DefaultReclocRowid = $P(ArrData,$C(1),1)
				}
        	}
		}else{
       		s CurrentRecLocStr = ##class(web.DHCOEOrdItemView).GetRecLocStrByParams(RecLocStr, RecLocParams.%ToJSON().Read())
        }
    }
    if (DefaultReclocRowid'=""){
		s CurrentRecLocStr=##class(web.DHCARCOrdSets).CheckARCOSItemRecLoc(CurrentRecLocStr,DefaultReclocRowid)
    }
	if (OrderHolidayRecLocStr'=""){
		s OrderNormalRecLocStr=OrderHolidayRecLocStr
	}else{
		s OrderNormalRecLocStr=RecLocStr
	}
	if (langid'=""){
		//处理翻译问题
		s OrderHolidayRecLocStr=$$TranslatLocStr(OrderHolidayRecLocStr,langid)
		s OrderOutPriorRecLocStr=$$TranslatLocStr(OrderOutPriorRecLocStr,langid)
		s OrderOnePriorRecLocStr=$$TranslatLocStr(OrderOnePriorRecLocStr,langid)
		s OrderNormalRecLocStr=$$TranslatLocStr(OrderNormalRecLocStr,langid)
		s CurrentRecLocStr=$$TranslatLocStr(CurrentRecLocStr,langid)
	}
	s RecLocArr("OrderHolidayRecLocStr")=OrderHolidayRecLocStr
    s RecLocArr("OrderOutPriorRecLocStr")=OrderOutPriorRecLocStr
    s RecLocArr("OrderOnePriorRecLocStr")=OrderOnePriorRecLocStr
	//常规接受科室串
	s RecLocArr("OrderNormalRecLocStr")=OrderNormalRecLocStr
	//完全符合当天计算规则的接受科室串
    s RecLocArr("CurrentRecLocStr")=CurrentRecLocStr

    s RecLocJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.RecLocArr)
    q RecLocJson
TranslatLocStr(LocStr,langid)
	q:(LocStr="") LocStr
	s Len = $L(LocStr,$C(2))
	for i=1:1:Len {
		s OneLocStr=$P(LocStr,$C(2),i)
		s $P(OneLocStr,$C(1),2)=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$P(OneLocStr,$C(1),2),langid)
		s $P(LocStr,$C(2),i)=OneLocStr
	}
	q LocStr
}

/// 统一草药接收科室获取(涉及：处方类型、煎药方式、医嘱类型、跨院、开始时间)
/// w ##class(web.DHCDocOrderCommon).GetCMRecLocStr(^Tempsclk("GetCMRecLocStr"))
ClassMethod GetCMRecLocStr(OrdParamJson As %String) As %String
{
	n (OrdParamJson,%session)
	s ^Tempsclk("GetCMRecLocStr")=OrdParamJson
	k CalPackArr
	k OrdParamArr
	Set DefaultReclocRowid=""
	Set langid=..%LanguageID()
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdParamJson,.OrdParamArr)
	s EpisodeID=OrdParamArr("EpisodeID")
	s CMPrescTypeCode=OrdParamArr("CMPrescTypeCode")
	s OrderOpenForAllHosp=OrdParamArr("OrderOpenForAllHosp")
	s CNMedCookModeRowId=OrdParamArr("CNMedCookModeRowId")
	s OrderPriorRowid=OrdParamArr("OrderPriorRowid")
	s LogonHospID=OrdParamArr("LogonHospID")
	s OrderDateStr=OrdParamArr("OrderDateStr")
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	;子类接收科室
	s CNItemCatStr=..%GetConfig(CMPrescTypeCode,LogonHospID)
	s CMRecLocStr=##Class(web.DHCDocOrderCommon).GetCMRecLoc(EpisodeID,CNItemCatStr,LogonHospID,OrderOpenForAllHosp,OrderDateStr)
	s CMRecLocStr=..GetCMRecLocStrByPrior(CMRecLocStr,OrderPriorRowid)
	;煎药方式接收科室
	if (CNMedCookModeRowId '="") {
		s CookModeReclocStr=##class(DHCDoc.DHCDocConfig.DocConfig).GetCookRecLoc(CNMedCookModeRowId,EpisodeID,LogonHospID,OrderOpenForAllHosp)
	}
	if ($g(CookModeReclocStr)'="") {
		s DefaultReclocRowid=$P($P(CookModeReclocStr,$C(2),1),$C(1),1)
		s CMRecLocStr=CookModeReclocStr_$C(2)_CMRecLocStr
	}
	//处方剂型上维护的接受科室
	if (DefaultReclocRowid=""){
		if PAAdmType'="I" s DefaultReclocRowid=..%GetConfig1(CMPrescTypeCode,"CNMedNormKLRefLoc",LogonHospID)
		else  s DefaultReclocRowid=..%GetConfig1(CMPrescTypeCode,"IPCNMedNormKLRefLoc",LogonHospID)
	}
	//重置默认接受科室
	if (DefaultReclocRowid'=""){
		s CMRecLocStr=##class(web.DHCARCOrdSets).CheckARCOSItemRecLoc(CMRecLocStr,DefaultReclocRowid)
	}
	s CMRecLocStrLength=$L(CMRecLocStr,$C(2))
	for i=1:1:CMRecLocStrLength{
		s OneRecloc = $P(CMRecLocStr,$C(2),i)
		s LocDesc=$P(OneRecloc,$C(1),2)
		s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
		s $P(OneRecloc,$C(1),2)=LocDesc
		s $P(CMRecLocStr,$C(2),i)=OneRecloc
		}
	s CalPackArr("CMRecLocStr")=CMRecLocStr
	s CalPackJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.CalPackArr)
    Q CalPackJson
}

ClassMethod GetCMRecLocStrByPrior(str, PriorRowId) As %String
{
	s RecLocStr=""
	s Find = 0
    for i = 1:1:$L(str,$C(2)) {
        s ArrData =$p(str,$C(2),i)
        if ($P(ArrData,$C(1),4)= PriorRowId) {
            s Find = 1
        }
    }
    for i = 1:1:$L(str,$C(2)) {
    	s ArrData =$p(str,$C(2),i)
    	if ($P(ArrData,$C(1),4)= "") {
	    	//由于节假日接收科室设置页面没有地方维护医嘱类型，故此处不需要按照医嘱类型进行过滤
            if (Find = 0){
	        	if (RecLocStr=""){
		        	s RecLocStr=ArrData
		        }else{
			    	s RecLocStr=RecLocStr_$C(2)_ArrData
			    }
	        }
        }elseif ($P(ArrData,$C(1),4)= PriorRowId){
	    	if (RecLocStr=""){
	        	s RecLocStr=ArrData
	        }else{
		    	s RecLocStr=RecLocStr_$C(2)_ArrData
		    }
	    }
    }
    Q RecLocStr
}

/***
  **Description      :获取 数量可以录入小数的子类(对门急诊药品无效,急诊虚拟长期模式下，使用住院模式发药，可以录入小数)
  **Author           :tanjishan
  **Time             :2021/04/15
  **debugger         :##Class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(PAAdmType,CurLogonHosp)
  **Parameter        :
  **Returns          :数量可以录入小数的子类串
***/
ClassMethod GetAllowEntryDecimalItemCat(EpisodeID As %String, HospId As %String = "") As %String
{
	n (EpisodeID,HospId)
	if (HospId=""){
		s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	}
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	;可以录入小数的子类
 	s AllowEntryDecimalItemCat=..%GetConfig("AllowEntryDecimalItemCat",HospId)
	s NewAllowEntryDecimalItemCat=""
	s UserEMVirtualtLong=0
	if (EpisodeID'="")&&(..%IsValidMethod("web.DHCDocOrderVirtualLong","GetUserEMVirtualtLong")){
		s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	}
	if (PAAdmType="I")||(PAAdmType="")||(UserEMVirtualtLong="1"){
		s NewAllowEntryDecimalItemCat=AllowEntryDecimalItemCat
	}else{
		for i=1:1:$Length(AllowEntryDecimalItemCat,"^"){
			s ItemCatRowid=$P(AllowEntryDecimalItemCat,"^",i)
			continue:(ItemCatRowid="")
			s OrderType=$P($G(^ARC("IC",ItemCatRowid)),"^",7)
			continue:OrderType="R" 
			if (NewAllowEntryDecimalItemCat=""){
				s NewAllowEntryDecimalItemCat=ItemCatRowid
			}else{
				s NewAllowEntryDecimalItemCat=NewAllowEntryDecimalItemCat_"^"_ItemCatRowid
			}
		}
	}
	q NewAllowEntryDecimalItemCat
}

/// 判断用法频次关联是否存在
ClassMethod IsValidFreqDurat(InstrRowid, FreqRowid) As %Boolean
{
	n (InstrRowid,FreqRowid)
	Q:(InstrRowid="")||(FreqRowid="") 1
	s FreqCode=$ZCVT($P($g(^PHCFR(FreqRowid)),"^",1),"U")
	Q:" ONCE ST "[(" "_FreqCode_" ") 1	;ST与ONCE不做判断
	Q:'$D(^PHCINLF(0,"Link",InstrRowid)) 1
	Q $O(^PHCINLF(0,"Link",InstrRowid,FreqRowid,0))>0
}

/// 或者是否曾经就诊过该科室或病区
/// PA_AdmTransaction(转科记录表)
ClassMethod IsVisitedLoc(EpisodeID, LocID) As %Boolean
{
	n (EpisodeID,LocID)
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LocID,EpisodeID)
	Q:LoginAdmLocFlag="Y" 1
	s Count=0
	&SQL(SELECT count(TRANS_RowId) INTO :Count FROM SQLUser.PA_AdmTransaction WHERE TRANS_ParRef=:EpisodeID AND (TRANS_CTLOC_DR=:LocID OR TRANS_Ward_DR->WARD_LocationDR=:LocID))
	Q Count>0
}

/// Description:: 根据费别的RowID,得到医保的标志 并判断是否默认医保标识为Y
/// Table:        PAC_AdmReason
/// Input:        BillType:费别
/// Return:       医保标志(0代表非医保) 
/// Others;
ClassMethod GetDefInsurFlag(BillType As %String, PAAdmType As %String = "", HospId As %String = "") As %String
{
	s InsurFlag=..GetInsurFlag(BillType,PAAdmType)
	s CFAllConfirmInsurSYMM=..%GetConfig("AllConfirmInsurSYMM",HospId)
	if (InsurFlag=1)||(CFAllConfirmInsurSYMM=1){
		q 1
	}	
	q 0
}

/***
  **Description      :判断是否是 "允许作为子医嘱时可自定义流速信息" 的用法
  **Author           :zhouc
  **Time             :2023/01/18
  **debugger         :w ##Class(web.DHCDocOrderCommon).GetIsSpeedRateSeparateInstr()
  **Parameter        :
  **Returns          :0:"否" 1:"是"
***/
ClassMethod GetIsSpeedRateSeparateInstr(InstrRowId, HospID)
{
	q:InstrRowId="" "0"
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s SpeedRateSeparateInstr=##class(DHCDoc.DHCDocConfig.InstrArcim).GetSpeedRateSeparateInstr(HospID)
	s:SpeedRateSeparateInstr'="" SpeedRateSeparateInstr="^"_SpeedRateSeparateInstr_"^"
	q:SpeedRateSeparateInstr[("^"_InstrRowId_"^") "1"
	q "0"
}

}
