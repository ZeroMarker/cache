Import User

/// creator:guorongyong
/// date:2014-08-26
Class web.DHCDocPrescript Extends DHCDoc.Util.RegisteredObject
{

/// creator:	谭吉善
/// date:		20210809
/// desc:		预生成处方号、检验号总入口
/// input:		EpisodeID:就诊号
///             OrdItemStr:待保存的医嘱信息串
///             SessionStr:USERID^GROUPID^CTLOCID^HOSPID^WARDID^LANGID
///             LabEpisArray:出参数组，用于记录生成的检验号，以绑定检验费用
///             PrescType:Ord|CM,代表西医录入或者草药信息(先不支持草药吧)
/// output:		OrdItemStr:仿照原始数据串，每个医嘱串修改或新增了对应位置的数据串
///             38=LabEpisodeNo
///             87=OrderSerialNum
///             88=PrescNo
///             89=PrescSeqNo
/// w ##Class(web.DHCDocPrescript).CreatOrdNo(2887,^TEMPtan("OrdNo",2887,1),^TEMPtan("OrdNo",2887,1,"S"),"","Ord")
ClassMethod CreatOrdNo(EpisodeID As %String, OrdItemStr As %String, SessionStr As %String, ByRef LabEpisArray = "", PrescType As %String = "Ord") As %String [ ProcedureBlock = 0 ]
{
	//s $ZT="CreatOrdNoErr"
	n (EpisodeID,OrdItemStr,SessionStr,LabEpisArray,PrescType)
	s LogIndex=$I(^TEMPtan("OrdNo",EpisodeID,"Index"))
	s ^TEMPtan("OrdNo",EpisodeID,LogIndex)=OrdItemStr
	s ^TEMPtan("OrdNo",EpisodeID,LogIndex,"S")=SessionStr
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s CurLogonHosp=$P(SessionStr,"^",4)
	s AutoPresc=##class(web.DHCDocConfig).GetConfigNode("PrescByAuto",CurLogonHosp)
	
	l +^DBLock($zn,EpisodeID):3 
	i '$test {
		d ##class(DHCDoc.Log.Common).General("Insert","web.DHCDocPrescript","CreatOrdNo","生成处方并发,插入医嘱失败",EpisodeID,-1)
		q ""
	}
	;西药分方、检验拆管
	if (PrescType="Ord"){
		//1.------装载需要分配处方或检验号的数据
			/*
				OrdItemPList结构说明
					1.Index										->下标,是根据主子医嘱关系计算后重排之后计算的结果，与原始的SeqNo有区别
					2.PLIST
						PLIST(SqlNum)							->OE_OrdItem,内部的SeqNo和MasterSeqNo是经过重置的
						PLIST("DHC",SqlNum)						->OE_OrdItemExt
						PLIST("Lab")							->标本code^管Code
						PLIST("row")							->★医嘱表ID，只有在检测到没有正常生成处方或检验号的医嘱时，才有值★
						PLIST("OrdItem")						->OrdItem,内部的SeqNo和MasterSeqNo是经过重置的
						PLIST("Bak","OrdItem")					->OrdItem,内部的SeqNo和MasterSeqNo是未经过重置的
						PLIST("CalResult")						->★★★★计算结果，包含处方号、处方编号、检验号★★★★★
				OrdItemPList(0,"OEORI",SubIndex,Index)=""		->通过子医嘱下标找到主医嘱
				OrdItemPList(0,"OEORI_Sub",Index,SubIndex)=""	->通过主医嘱下标找到子医嘱
			*/
		k OrdItemPList
		d InitOrdItemArr(EpisodeID,OrdItemStr,SessionStr,.OrdItemPList)
		//2.------计算处方号、检验号的生成规则
		if (AutoPresc=0){
			//保留基本分方规则(按接收科室+开始日期+处方分类+费别+用法组代码)
			d CreatSimpleNum(EpisodeID,SessionStr,.OrdItemPList)
		}else{
			d CreatNum(EpisodeID,SessionStr,.OrdItemPList)
		}
		
		//3.------整理计算后的处方号、检验号，返回到前台
		s NewOrdItemStr=$$SaveNumData(EpisodeID,SessionStr,OrdItemStr,.OrdItemPList,.LabEpisArray)
	}else{
		;草药分方
		s NewOrdItemStr=$$CreatCMNumData(EpisodeID,SessionStr,OrdItemStr)
		
	}
	
	l -^DBLock($zn,EpisodeID)
	q NewOrdItemStr
SaveNumData(EpisodeID,SessionStr,OrdItemStr,OrdItemPList,LabEpisArray)
	n (EpisodeID,SessionStr,OrdItemStr,OrdItemPList,LabEpisArray)
	k PrescNoArr
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	//如果界面需要重排，则可以使用PLIST("OrdItem")
	//如果界面不重排，则还是使用PLIST("Bak","OrdItem")
	//OEORI_RecDep_DR,OEORI_OrdDept_DR
	s NewOrdItemStr=""
	s Index=0
	for {
		s Index=$O(OrdItemPList(Index))
		q:(Index="")
		s CalResult=$G(OrdItemPList(Index,"CalResult"))
		s PrescNo=$P(CalResult,"^",1)
		s PrescSeqNo=$P(CalResult,"^",2)
		s RecDepDR=$P(CalResult,"^",3)
		s OrdDeptDR=$P(CalResult,"^",4)
		s LabEpisodeNo=$P(CalResult,"^",5)
		s row=$G(OrdItemPList(Index,"row"))

		s BakOrdItem=OrdItemPList(Index,"Bak","OrdItem")
		s BakOrderSeqNo=$p(BakOrdItem,"^",20)
		//1、初始化一部分数据，只是为了让程序结构更容易看明白
		s NewOrdItem=""
		Set OrdItemCount=$L(OrdItemStr,$c(1))
		For i=1:1:OrdItemCount	{
			Set OrdItem=$p(OrdItemStr,$c(1),i)
			continue:OrdItem=""
			s MasterSeqNo=$p(OrdItem,"^",19)
			s OrderSeqNo=$p(OrdItem,"^",20)
			if (OrderSeqNo=BakOrderSeqNo){
				s NewOrdItem=OrdItem
				quit
			}
		}
		s SpecimenCode=$P($G(OrdItemPList(Index,"Lab")),"^",1)
		s ContainerCode=$P($G(OrdItemPList(Index,"Lab")),"^",2)
		if (row'=""){
			Set ItmMastDR=$P($G(^OEORD(+row,"I",$P(row,"||",2),1)),"^",2)
			Set sttdat=$P($G(^OEORD(+row,"I",$P(row,"||",2),1)),"^",9)
		}else{
			Set ItmMastDR=$p(NewOrdItem,"^",1)
			Set sttdat=$p(NewOrdItem,"^",4)
			if sttdat="" s sttdat=$P($H,",",1)
			e  Set sttdat=$$zdhFormat^DHCDocOrderCommonNew(sttdat)
		}
		s loc=$s(RecDepDR:+RecDepDR,1:+..recloc(ItmMastDR,$g(locord)))
		s LabDeptCode=..GetTestCodeRecLoc(ItmMastDR)
		i LabDeptCode="" s LabDeptCode=loc


		//2.检测到没有正常生成处方或检验号的医嘱,直接更新数据
		if (row'=""){
			i LabEpisodeNo'="" {
				&SQL(UPDATE OE_OrdItem (OEORI_PrescNo,OEORI_PrescSeqNo,OEORI_RecDep_DR,OEORI_OrdDept_DR,OEORI_LabEpisodeNo)
					VALUES (:PrescNo,:PrescSeqNo,:RecDepDR,:OrdDeptDR,:LabEpisodeNo)WHERE OEORI_RowId = :row)
				if ('SQLCODE){
					s keylab=LabDeptCode_"^"_(+sttdat)_"^"_SpecimenCode_"^"_ContainerCode_"^"_"^"_"**"_LabEpisodeNo
					s LabEpisArray(keylab)=LabEpisodeNo
				}
			}elseif (PrescNo'=""){
				&SQL(UPDATE OE_OrdItem (OEORI_PrescNo,OEORI_PrescSeqNo,OEORI_RecDep_DR,OEORI_OrdDept_DR) 
					VALUES (:PrescNo,:PrescSeqNo,:RecDepDR,:OrdDeptDR) WHERE OEORI_RowId = :row)
			}
			d ..CreatPAQue(row)
			continue
		}
		
		///3.重置医嘱审核串
		continue:(NewOrdItem="")
		if (LabEpisodeNo="") s LabEpisodeNo=$p(NewOrdItem,"^",38)
		if (PrescNo="") s PrescNo=$p(NewOrdItem,"^",88)
		if (PrescSeqNo="") s PrescSeqNo=$p(OrdItem,"^",89)
		
		set OrderSerialNum=$p(NewOrdItem,"^",87)
		if (OrderSerialNum=""){
			s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(EpisodeID)
		}
		
		s $P(NewOrdItem,"^",38)=LabEpisodeNo
		s $P(NewOrdItem,"^",87)=OrderSerialNum
		s $P(NewOrdItem,"^",88)=PrescNo
		s $P(NewOrdItem,"^",89)=PrescSeqNo
		s $P(NewOrdItemStr,$C(1),i)=NewOrdItem
		
		//准备LabEpisArray数据，用于计算采血费
		if (LabEpisodeNo'=""){
			s keylab=LabDeptCode_"^"_(+sttdat)_"^"_SpecimenCode_"^"_ContainerCode_"^"_"^"_"**"_LabEpisodeNo
			s LabEpisArray(keylab)=LabEpisodeNo
		}
	}
	
	q NewOrdItemStr
CreatCMNumData(EpisodeID,SessionStr,OrdItemStr)
	n (EpisodeID,SessionStr,OrdItemStr)
	s PrescStr=$p(OrdItemStr,$C(2),1)
	s OrdItemStr=$p(OrdItemStr,$C(2),2)
	if (OrdItemStr="")||(PrescStr=""){
		q OrdItemStr
	}
	
	s PrescStartDate=$P(PrescStr,"^",11)
	i PrescStartDate="" s PrescStartDate=+$H
	e  s PrescStartDate=$$zdhFormat^DHCDocOrderCommonNew(PrescStartDate)
	s PrescRecDepRowid=$P(PrescStr,"^",7)
	s PrescNo=""
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount	{
		Set OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		Set ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s RowID=""
		s:ItemCatRowid'="" RowID=$P($G(^ARC("IC",ItemCatRowid)),"^",8)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:OrderType'="R"
		s OldPrescNo=$p(OrdItem,"^",16)
		continue:OldPrescNo'=""
		set OrderSerialNum=$p(OrdItem,"^",15)
		if (OrderSerialNum=""){
			s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(EpisodeID)
		}
		//如果一开始就初始化一个处方号，或导致每次调用该方法都会浪费一个号码
		s PrescNo=$CASE(PrescNo,"":..CreatPrNo(+PrescStartDate,EpisodeID,PrescRecDepRowid,$G(arcim) ,$G(row),$G(DMJPrescNo)),:PrescNo)
		s $P(OrdItem,"^",15)=OrderSerialNum
		s $p(OrdItem,"^",16)=PrescNo
		s $p(OrdItem,"^",17)=i_"/"_OrdItemCount
		s $p(OrdItemStr,$c(1),i)=OrdItem
	}
	q PrescStr_$C(2)_OrdItemStr
CreatSimpleNum(EpisodeID,SessionStr,OrdItemPList)
	n (EpisodeID,SessionStr,OrdItemPList)
	s OEORIUserHospDr=$P(SessionStr,"^",4)
	S PrescByInstr=##class(web.DHCDocConfig).GetConfigNode("PrescByInstr",OEORIUserHospDr)
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(OEORIUserHospDr)
	s adm=EpisodeID
	Set row=$o(^OEORD(0,"Adm",adm,""))
	s RepId=$I(^TMPaOET1("MVB",$j))
 	k ^TMPaOET1("MVB",$j,RepId),queJoin
	s Index=0
	for {
		s Index=$O(OrdItemPList(Index))
		q:(Index="")
		
		k PLIST
		m PLIST=OrdItemPList(Index)
		s ItmMastDR=PLIST(4)
		s locord=PLIST(6)
		
		s StatusRowid=PLIST(10)
		s status=$P(^OEC("OSTAT",StatusRowid),"^")
		continue:$g(status)="I"
		continue:" DS DIS E V I "'[(" "_$g(status)_" ")
		
		s LabEpisodeNo=$G(PLIST(88))
		continue:(LabEpisodeNo'="")
		s PrescNo=$G(PLIST(65))
		s PrescSeqNo=$G(PLIST(66))
		continue:PrescNo'=""
		continue:PrescSeqNo'=""
		s PriorityDR = PLIST(23)
		s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
		continue:(PriorityCode="REV")
		
		s sttdat=$G(PLIST(17))
		s OrderInstrRowid=$G(PLIST(27))
		s recloc=PLIST(75)
		s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		s OrderType=$p($g(OrderType),$c(1))
		s NotifyClinician=$G(PLIST(248))
		s NotifyClinician=$case(NotifyClinician,"Y":"Y",:"N")
		;有存库项关联且不为药品,不为检验则退出
		s inic=##class(web.DHCDocOrderEntry).GetINCI(+ItmMastDR)
		continue:(inic'="")&&($e(OrderType)'="R")&&($e(OrderType)'="L")
		i $e(OrderType)'="L",'..stock(ItmMastDR) continue
		i 'locord s locord=+$$ordloc^DHCOEOrdItem(adm)
		s SpecimenCode=$P($G(PLIST("Lab")),"^",1)
		s ContainerCode=$P($G(PLIST("Lab")),"^",2)
		
		s LabItemGroupFlag=$$GetLabItemGroupFlag^DHCDocOrderCommon(ItmMastDR)
		//获取当前医嘱对应的配置数据
		s ExpandOrdInfo=$$GetLinkOrdInfo(EpisodeID,Index,.OrdItemPList)

		s SplitPrescTypeDetails=$P(ExpandOrdInfo,$C(1),3)
		s PrescTypeCode=$P(SplitPrescTypeDetails,"^",1)			;处方类型代码
		
		s seq1="1/1",loc=$s(recloc:+recloc,1:+..recloc(ItmMastDR,locord))
		s BillTypeRowid=$G(PLIST(206))
		s BillTypeRowid=$$getPHPrescInsurTypeByInfo^DHCDocOrderCommonNew(ItmMastDR,BillTypeRowid,OEORIUserHospDr)
		
		s DiagnosCatRowId=$G(PLIST(119))
		s LinkIndex=$O(OrdItemPList(0,"OEORI",Index,0))
		s InstrGroupCode=""
		i PrescByInstr=1 s InstrGroupCode=$$GetInstrGroupCode^DHCDocOrderCommon(OrderInstrRowid)
		

		s key=+loc_"^"_(+sttdat)_..auth(ItmMastDR,row)_"*"_PrescTypeCode_BillTypeRowid_InstrGroupCode
		s prno1="",epis1=""
		i loc,$e(OrderType)'="L" {
			i '$d(que1(key)) s prno=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
			i '$d(que1(key)) s que1(key)=prno_"^"_$g(locord)
			i $d(que1(key)) s prno1=$p(que1(key),"^")
		}
		s GetTestCode=..GetTestCode(ItmMastDR)
		s LabDeptCode=..GetTestCodeRecLoc(ItmMastDR)
		i LabDeptCode="" s LabDeptCode=loc
		i loc,$e(OrderType)="L",epis="" {
			;相同的医嘱需要产生不同的标本号
			s SameItemSingleFlag=0
			i queArcimStr=""{
				s queArcimStr=ItmMastDR_"*"_(+sttdat)
			}else  {
				i ("^"_queArcimStr_"^")'[("^"_ItmMastDR_"*"_(+sttdat)_"^") s queArcimStr=queArcimStr_"^"_ItmMastDR_"*"_+sttdat
				e  s SameItemSingleFlag=1
			}
			s LabItemSingleFlag=$$GetLabItemSingleFlag^DHCDocOrderCommonNew(ItmMastDR)
			i (LabItemSingleFlag=1)&&(SameItemSingleFlag=0) s keylab=LabDeptCode_"^"_(+sttdat)_"^"_SpecimenCode_"^"_ContainerCode
			e  s keylab=LabDeptCode_"^"_(+sttdat)_"^"_SpecimenCode_"^"_ContainerCode_"^"_Index
			i '$d(que2(keylab)) s que2(keylab)=..CreatLabEpisodeNo($G(row), $G(arcim))
			i $d(que2(keylab)) s epis=que2(keylab)
		}
		
		s seq2=$G(PLIST(77))		//OEORI_SeqNo,这里的SeqNo已经是重置过了的
		i seq2 {
			//i (prno1'="") {
			s sum=$g(^TMPaOET1("MVB",$j,RepId,+loc))+1
			s ^TMPaOET1("MVB",$j,RepId,+loc)=sum
			s ^TMPaOET1("MVB",$j,RepId,+loc,+(seq2\1),Index)=sum
		}
		s PLIST("CalResult")=prno1_"^"_seq1_"^"_loc_"^"_locord_"^"_epis1
		m OrdItemPList(Index)=PLIST	
	}
	d ReSetPrescSeqNo
	q
CreatNum(EpisodeID,SessionStr,OrdItemPList)
	n (EpisodeID,SessionStr,OrdItemPList)
	s OEORIUserHospDr=$P(SessionStr,"^",4)
	S CurrentLoc=$P(SessionStr,"^",3)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s SkinTestInstr=##Class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",AdmHospitalId)
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	S PrescByInstr=##class(web.DHCDocConfig).GetConfigNode("PrescByInstr",AdmHospitalId)
	S PrescByLinkOrder=##class(web.DHCDocConfig).GetConfigNode("PrescByLinkOrder",AdmHospitalId)
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(AdmHospitalId)
	s adm=EpisodeID
	Set row=$o(^OEORD(0,"Adm",adm,""))
	s admtype=$p($g(^PAADM(adm)),"^",2)
	Set AdmReason=$P(^PAADM(adm,1),"^",7)
	i admtype="I" s PrescByLinkOrder=0
	s que1count=0
	
	s RepId=$I(^TMPaOET1("MVB",$j))
 	k ^TMPaOET1("MVB",$j,RepId),queJoin,RepeatOrdList
	f loop=1:1:2 {
		
		s Index=0
		for {
			s Index=$O(OrdItemPList(Index))
			q:(Index="")
			
			k PLIST
			m PLIST=OrdItemPList(Index)
			s ItmMastDR=PLIST(4)
			s locord=PLIST(6)
			
			s StatusRowid=PLIST(10)
			s status=$P(^OEC("OSTAT",StatusRowid),"^")
			continue:$g(status)="I"
			continue:" DS DIS E V I "'[(" "_$g(status)_" ")
			s OrderDocRowid=PLIST(14)
			s ArcimDesc=$P(^ARCIM(+ItmMastDR,$P(ItmMastDR,"||",2),1),"^",2)
			s LabEpisodeNo=$G(PLIST(88))
			continue:(LabEpisodeNo'="")
			s PrescNo=$G(PLIST(65))
			s PrescSeqNo=$G(PLIST(66))
			continue:PrescNo'=""
			continue:PrescSeqNo'=""
			s PriorityDR = PLIST(23)
			s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
			continue:(PriorityCode="REV")
			s sttdat=$G(PLIST(17))
			s OrderInstrRowid=$G(PLIST(27))
			s recloc=PLIST(75)
			s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
			s OrderType=$p($g(OrderType),$c(1))
			s NotifyClinician=$G(PLIST(248))
			s NotifyClinician=$case(NotifyClinician,"Y":"Y",:"N")
			;有存库项关联且不为药品,不为检验则退出
			s inic=##class(web.DHCDocOrderEntry).GetINCI(+ItmMastDR)
			continue:(inic'="")&&($e(OrderType)'="R")&&($e(OrderType)'="L")
			i $e(OrderType)'="L",'..stock(ItmMastDR) continue
			i 'locord s locord=+$$ordloc^DHCOEOrdItem(adm)
			s SpecimenCode=$P($G(PLIST("Lab")),"^",1)
			s ContainerCode=$P($G(PLIST("Lab")),"^",2)
			s LabItemGroupFlag=$$GetLabItemGroupFlag^DHCDocOrderCommon(ItmMastDR)
			//获取当前医嘱对应的配置数据
			s ExpandOrdInfo=$$GetLinkOrdInfo(EpisodeID,Index,.OrdItemPList)
			
			;皮试分方:如果是非成组医嘱则置皮试医嘱分方标识
			s SkinTest=$P(ExpandOrdInfo,$C(1),1)
			s SkinTestFlag=$P(ExpandOrdInfo,$C(1),2)
			s SplitPrescTypeDetails=$P(ExpandOrdInfo,$C(1),3)
			s PrescTypeCode=$P(SplitPrescTypeDetails,"^",1)			;处方类型代码
			s PHPrescTypeCount=$P(SplitPrescTypeDetails,"^",2)		;每张处方限制药物个数
			s PHPrescTypeSingle=$P(SplitPrescTypeDetails,"^",3)		;单独分处方(成组医嘱拆分分方,单药品单处方)
			s DMJPrescNo=$P(SplitPrescTypeDetails,"^",5)			;单独走MJ开头处方号(用于毒麻处方) 
			s PHPrescTypeSingleB=$P(SplitPrescTypeDetails,"^",6)	;单独分处方(成组医嘱拆分分方,同处方类型同处方)
			i PHPrescTypeCount="" s PHPrescTypeCount=5
			
			s BillTypeRowid=$G(PLIST(206))
			i SkinTest="Y" s PHPrescTypeCount=1
			s BillTypeRowid=$$getPHPrescInsurTypeByInfo^DHCDocOrderCommonNew(ItmMastDR,BillTypeRowid,AdmHospitalId)
			
			s DiagnosCatRowId=$G(PLIST(119))
			s LinkIndex=$O(OrdItemPList(0,"OEORI",Index,0))
			s InstrGroupCode=""
			i PrescByInstr=1 s InstrGroupCode=$$GetInstrGroupCode^DHCDocOrderCommon(OrderInstrRowid)
			s UseDepDR=$G(PLIST("DHC",34)) 			;使用科室
			s OrderNeedPIVAFlag=$G(PLIST("DHC",18))	;门诊静脉配液新更
			if OrderNeedPIVAFlag'="Y" Set OrderNeedPIVAFlag="N"
			s ARCIMFreeDurgFlag=##class(web.DHCDocOrderCommon).GetARCIMFreeDurgFlag(ItmMastDR)		;免费药标识
			s seq1="1/1",loc=$s(recloc:+recloc,1:+..recloc(ItmMastDR,locord))
			
			s key=+loc_"^"_(+sttdat)_OrderDocRowid_..auth(ItmMastDR,row)_"*"_PrescTypeCode_BillTypeRowid_InstrGroupCode_UseDepDR_"*"_SkinTestFlag_OrderNeedPIVAFlag_ARCIMFreeDurgFlag
			
			
			i PHPrescTypeSingle="1" s key=key_Index
			i PriorityCode="STAT" s STAT(key)=""
			continue:'loc  s epis=LabEpisodeNo
			
			s prno1="",epis1=""
			if (loop=1){
				;第一次循环，准备需要合并的数据信息
				//成组医嘱处方合并
				i PrescByLinkOrder=1,loc,$e(OrderType)'="L"  {
					d MergePrescGroupQue
				}
				//血糖分组
				i $e(OrderType)="L" {
					s CurOrdBloodSugarGroup=..GetOrdBloogSugarGroup(ItmMastDR,AdmHospitalId)
					i CurOrdBloodSugarGroup="" s CurOrdBloodSugarGroup="NULLGROUP"
					s OrdBloodSugarGroupArr(CurOrdBloodSugarGroup,Index,ItmMastDR)=1
				}
			}else{
				;第二次循环，利用准备的待合并数据，计算合并规则
				;1、处理处方号的分配与合并规则
				i loc,$e(OrderType)'="L" {
					i PrescByLinkOrder'=1  {
						;成组医嘱合并成一个处方
						i (LinkIndex'="")!($d(OrdItemPList(0,"OEORI_Sub",Index))){
							i LinkIndex'="" s mainrowid=LinkIndex
							e  s mainrowid=Index
							s key=key_"*"_mainrowid
							s PHPrescTypeCount=""
						}
						s key=$$MergePrescQue(key,PHPrescTypeCount)
						i $d(que1(key)) s prno1=$p(que1(key),"^")
					}else{
						i LinkIndex'="",+PHPrescTypeSingleB=0 s mainrowid=LinkIndex
						e  s mainrowid=Index
						s find=0
						s nod=""
						for{
							s nod=$O(que1Group(nod))
							Q:(nod="")||(find=1)
							continue:($P(nod,"&")'=key)
							i $d(que1Group(nod,mainrowid)) s find=1,prno1=que1Group(nod,0)
						}
						i prno1=""  {
							s find=0
							s nod=""
							for{
								s nod=$O(que1Single(nod))
								Q:(nod="")||(find=1)
								continue:($P(nod,"&")'=key)
								i $d(que1Single(nod,mainrowid)) {
									s find=1,prno1=que1Single(nod,0)
								}
							}
						}
						;i prno1="" s prno1=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
						;i '$d(queJoin(prno1)) s queJoin(prno1)=adm_"^"_loc
						;tanjishan 当配置为成组医嘱相同接受科室为否时，不同接受科室的成组的医嘱，虽然会拆分处方，但尽量按照相同接受科室进行组内合并处方。
						i prno1="" {
							s key=$$newque3(key,PHPrescTypeCount)
							i $d(que1(key)){
								s prno1=$p(que1(key),"^")
							}else{
								s prno1=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
							}
						}
						i '$d(queJoin(prno1)) s queJoin(prno1)=adm_"^"_loc

							
					}
				}
				;2、处理标本号的分配与合并规则
				;二次循环得到需要生成标本号医嘱对应的LabItemSplitCode
				if '$D(OrdBloodSugarGroupSplitCodeArr){
					s OrdBloodSugarGroup=""
					for{
						s OrdBloodSugarGroup=$o(OrdBloodSugarGroupArr(OrdBloodSugarGroup)) Q:OrdBloodSugarGroup=""  d
						s LabItemSplitCode=1
						s i=0
						for {
							s i=$o(OrdBloodSugarGroupArr(OrdBloodSugarGroup,i))
							Q:i=""
							s arcimId=""
							for{
								s arcimId=$o(OrdBloodSugarGroupArr(OrdBloodSugarGroup,i,arcimId))
								Q:arcimId=""
								s OrdBloodSugarGroupSplitCodeArr(i,arcimId)=LabItemSplitCode
								i OrdBloodSugarGroup'="NULLGROUP" s LabItemSplitCode=LabItemSplitCode+1
							}
						}
					}
				}
				s GetTestCode=..GetTestCode(ItmMastDR)
				s LabDeptCode=..GetTestCodeRecLoc(ItmMastDR)
				i LabDeptCode="" s LabDeptCode=loc
				i loc,$e(OrderType)="L",epis="" {
					s TSGroup=##Class(DHCLIS.DHCCommon).GetTestSetGroup(GetTestCode,HospitalCode)
					s LabItemSingleFlag=$$GetLabItemSingleFlag^DHCDocOrderCommon(ItmMastDR)
					s OrdBloodSugarGroupSplitCode=$g(OrdBloodSugarGroupSplitCodeArr(Index,ItmMastDR))
					s keylab=LabDeptCode_"^"_(+sttdat)_"^"_SpecimenCode_"^"_ContainerCode_"^"_LabItemGroupFlag_"^"_NotifyClinician_"^"_TSGroup
					i (LabItemSingleFlag=0){
						s keylab=keylab_"^"_Index	;row
					}
					;仅拼接到*号之前的数据作为合并计算检验号的规则
					s keylab=keylab_"*"_OrdBloodSugarGroupSplitCode
					s epis=$$MergeLabQue(row,keylab,.PLIST,0)
					;修复同开两组检验医嘱，两组的医嘱项目分别是AB,AB，在相同医嘱项不合的前提下，因程序buG导致，第一组是一个标本号，第二组是两个标本号的问题
					;2022-11-24修复同开两组检验医嘱，两组的医嘱项分别是ABC、EAF,其中A为多标本项目，同组标本相同，因程序bug导致，第一组是一个标本号，第二组是两个标本号的问题
					;相同的医嘱需要产生不同的标本号
					s RepeatNum=$I(RepeatOrdList(ItmMastDR_"*"_(+sttdat)_"*"_SpecimenCode))
					s $P(keylab,"*",2)=""	;OrdBloodSugarGroupSplitCode只用来作为和非血糖类医嘱进行合并判断使用，不同血糖分组之间的拆包规则还是按TSGroup处理
					s keylab=keylab_"*"_RepeatNum
					
					i epis="" {
						i '$d(que2(keylab)) s que2(keylab)=..CreatLabEpisodeNo($G(row), $G(arcim))
						s epis=que2(keylab)
					}
					s epis1=epis
					
					s RepeatOrdList(ItmMastDR_"*"_(+sttdat)_"*"_SpecimenCode,Index)=epis1
				}
				/*
				i epis1'="" {
					&SQL(UPDATE OE_OrdItem (OEORI_PrescNo,OEORI_PrescSeqNo,OEORI_RecDep_DR,OEORI_OrdDept_DR,OEORI_LabEpisodeNo)
						VALUES (:prno1,:seq1,:loc,:locord,:epis1)WHERE OEORI_RowId = :row)
				}
				
				i epis1="" {
					&SQL(UPDATE OE_OrdItem (OEORI_PrescNo,OEORI_PrescSeqNo,OEORI_RecDep_DR,OEORI_OrdDept_DR) 
						VALUES (:prno1,:seq1,:loc,:locord) WHERE OEORI_RowId = :row)
				}*/
				;w prno1_","_epis1,!
				s seq2=$G(PLIST(77))		//OEORI_SeqNo,这里的SeqNo已经是重置过了的
				i seq2 {
				//i (prno1'="") {
					s sum=$g(^TMPaOET1("MVB",$j,RepId,+loc))+1
					s ^TMPaOET1("MVB",$j,RepId,+loc)=sum
					s ^TMPaOET1("MVB",$j,RepId,+loc,+(seq2\1),Index)=sum
				}
				
				s PLIST("CalResult")=prno1_"^"_seq1_"^"_loc_"^"_locord_"^"_epis1
				m OrdItemPList(Index)=PLIST
				
				
			}	///第二层循环在此截至
		}

	}
	// m LabEpisArray=que3
	d ReSetPrescSeqNo
	
	q
ReSetPrescSeqNo
	//重置PrescSeqNo
	s loc=""
	for{
		s loc=$o(^TMPaOET1("MVB",$j,RepId,loc)) 
		q:loc=""
		s tot=$g(^TMPaOET1("MVB",$j,RepId,loc))
		s ss=""
		for{
			s ss=$o(^TMPaOET1("MVB",$j,RepId,loc,ss))
			q:ss=""
			s row=""
			for{
				s Index=$o(^TMPaOET1("MVB",$j,RepId,loc,ss,Index))
				q:Index=""
				s s=^(Index)
				s seq1=s_"/"_tot
				if ($D(OrdItemPList(Index,"CalResult"))){
					s $P(OrdItemPList(Index,"CalResult"),"^",2)=seq1
				}
			}
		}
	}
	k ^TMPaOET1("MVB",$j,RepId)
	q
 ;获取可以合并的检验号
MergeLabQue(row,keylab,PLIST,timelen)
	n (row,keylab,PLIST,timelen,que2,RepeatOrdList)
	s ^DHCDocConfig("OverAllEPIS")=0

	s findepis=""
	i keylab[("^"_row) q findepis
	
	i +timelen=0 s timelen=86399
	e  s timelen=$zth(timelen,1)
	
	s adm=$p($g(^OEORD(+row)),"^",1)
	s admtype=$p($g(^PAADM(adm)),"^",2)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(adm)
	s OEORIUserDepartmentDR=$G(PLIST(121))
	s ARCIMRowId=$G(PLIST(4))
	k LabOrdPlanArray
	d ##class(DHCDoc.DHCDocConfig.LabBindRuleSetting).GetLabOrdUsedPlanArr(adm,.LabOrdPlanArray)
	s planlab=0,OrdUsedPlanId=""
	for {
		s planlab=$O(LabOrdPlanArray(planlab)) 
		Q:planlab=""
		s planData=$g(LabOrdPlanArray(planlab))
		s planLimitLocStr=$p(planData,$C(1),1)
		s planLimitOrdStr=$p(planData,$C(1),2)
		continue:("^"_planLimitLocStr_"^")'[("^"_OEORIUserDepartmentDR_"^")
		continue:(planLimitOrdStr'="")&&(("^"_planLimitOrdStr_"^")'[("^"_ARCIMRowId_"^"))
		if (("^"_planLimitOrdStr_"^")[("^"_ARCIMRowId_"^")) {
			s OrdUsedPlanId=planlab
			Q
		}
		s OrdUsedPlanId=planlab
	}
	if (OrdUsedPlanId'=""){
		s MergeLabPlan=$lg(^User.DHCDocLabPlanD(OrdUsedPlanId),9)
		//如果是配置【仅合并一次审核的医嘱】，则直接退出
		if (MergeLabPlan="OnceInsertOrder"){
			q findepis
		}
	}
	
	s StayStatus=0
	s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(adm)
	i " 1 2 "[(" "_PatCurStat_" ") s StayStatus=1
	s cursttdat=$G(PLIST(17))
	s curstttim=$G(PLIST(18))
	s startdat=cursttdat,enddat=cursttdat
	s enddatinter=curstttim\timelen+$s(curstttim#timelen:1,1:0)
	
	
	;是否启用同时间点合并规则,默认不按时间规则,可以考虑做配置
	s ActiveTimeFlag=0
	s curarcimrowid=$G(PLIST(4))
	s cursttdate=$G(PLIST(17))
	s CurOrdBloogSugarGroup=..GetOrdBloogSugarGroup(curarcimrowid,AdmHospitalId)
	f datloop=startdat:1:enddat {
		s oeoriid=0
		for{
			s oeoriid=$o(^OEORDi(0,"StDt",datloop,+row,oeoriid))
			q:(oeoriid="")||(findepis'="")
			s data1=$g(^OEORD(+row,"I",oeoriid,1))
			s data3=$g(^OEORD(+row,"I",oeoriid,3))
			s arcimrowid=$p(data1,"^",2)
			s ItemStatCode=""
			s ItemStatDR=$p(data1,"^",13)
			i ItemStatDR'="" s ItemStatCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
			continue:ItemStatCode'="V"
			
			i ActiveTimeFlag=0 d
			.s stttimloop=""
			e  d
			.s stttimloop=$p(data1,"^",10)
			s ItemCatDR=$p($g(^ARCIM(+arcimrowid,$p(arcimrowid,"||",2),1)),"^",10)
			s OrderType=$P($g(^ARC("IC",+ItemCatDR)),"^",7)
			continue:OrderType'="L"
			s Billed=$p(data3,"^",5)
			s reclocid=$p(data3,"^",6)
			s LabEpisodeNo=$p(data3,"^",20)
			continue:LabEpisodeNo=""
			s LabRejectSpecFlag=##Class(DHCLIS.DHCCommon).GetRejectSpecFlag(LabEpisodeNo)
			continue:LabRejectSpecFlag=1
			;验证当前医嘱血糖分组和所循环医嘱血糖分组相同则退出
			s OrdBloogSugarGroup=..GetOrdBloogSugarGroup(arcimrowid,AdmHospitalId)
			continue:(CurOrdBloogSugarGroup=OrdBloogSugarGroup)&&(CurOrdBloogSugarGroup'="")
			s ResultFlag=$p(data1,"^",5)
			
			s quitflag=0
			;包含同项目不合并、包含当前血糖分组不合并
			s childsub=0 
			for{
				s childsub=$O(^OEORD(0,"EpisNo",LabEpisodeNo,+row,childsub))
				Q:childsub=""
				continue:'$d(^OEORD(+row,"I",childsub,1))
				//continue:(childsub=oeoriid)
				
				s ItemStatDR=$p($g(^OEORD(+row,"I",childsub,1)),"^",13)
				i ItemStatDR'="" s ItemStatCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
				e  s ItemStatCode=""
				continue:ItemStatCode'="V"
				s SameArcimRowid=$p($g(^OEORD(+row,"I",childsub,1)),"^",2)
				s SameOrdBloogSugarGroup=..GetOrdBloogSugarGroup(SameArcimRowid,AdmHospitalId)
				i (SameOrdBloogSugarGroup=CurOrdBloogSugarGroup)&&(CurOrdBloogSugarGroup'="") s quitflag=1
				i curarcimrowid=SameArcimRowid s quitflag=1
				
			}
			s speccode=$$GetOELabSpecimen^DHCDocOrderCommon(+row_"||"_oeoriid)
			//w +row_"||"_oeoriid_"!!!!"_quitflag,!
			if (quitflag=1){
				;累计计数器，防止在已经录入A的前提下，再审核BAB医嘱，导致【虽然前面的AB合管了，但后面的AB医嘱无法合管】的问题
				if ("^"_$G(RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode,"SaveOrdList"))_"^")'[("^"_oeoriid_"^"){
					d $I(RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode))
					//防止待审核医嘱中有多组BBBB,导致计数器被重复累计计数
					//比如在医生录入A的前提下，再次审核BABAB
					s RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode,"SaveOrdList")=$G(RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode,"SaveOrdList"))_"^"_oeoriid
				}
				
				continue
			}
			;相同医嘱项的已经合并了该检查号，不能再次合并。比如已经录入了AA,再次录入BB时，前一组AB已经合并了，后一组B只能和后面的A合并
			s i=0
			for{
				s i=$O(RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode,i))
				q:(i="")
				if (LabEpisodeNo=RepeatOrdList(curarcimrowid_"*"_(+cursttdate)_"*"_speccode,i)){
					s quitflag=1
				}
			}
			if (quitflag=1){
				continue
			}

			i (admtype="I")!(StayStatus=1) {
				;住院判断已经打印(PT)条码则退出
				s ResultPrintFlag=##Class(web.DHCOEOrdAppendItem).IfPrintLabNo(+row,oeoriid)
				i ResultPrintFlag=1 s quitflag=1
				s ResultPrintFlag=##Class(web.DHCOEOrdAppendItem).IfNurPrintLabNo(+row,oeoriid)
				i ResultPrintFlag=1 s quitflag=1
			}else{
				;门急诊判断项目已经收费则退出
				i (Billed="P")&&(admtype'="H") s quitflag=1
			}
			//w +row_"||"_oeoriid_"!!!!"_quitflag,!
			continue:quitflag=1
			i admtype="H"  d
			.s KeyLabDateTime=$p(keylab,"^",2)
			.s KeyLabDate=$e(KeyLabDateTime,1,5)
			.s KeyLabDateTime=KeyLabDate_stttimloop
			.s $p(keylab,"^",2)=KeyLabDateTime
			s speccode=$$GetOELabSpecimen^DHCDocOrderCommon(+row_"||"_oeoriid)
			s Container=$$GetOELabContainer^DHCDocOrderCommon(+row_"||"_oeoriid)
			s LabItemGroupFlag=$$GetLabItemGroupFlag^DHCDocOrderCommon(arcimrowid)
			s LabItemSingleFlag=$$GetLabItemSingleFlag^DHCDocOrderCommon(arcimrowid)
			s GetTestCode=..GetTestCode(arcimrowid)
			s LabDeptCode=..GetTestCodeRecLoc(arcimrowid)
			i LabDeptCode="" s LabDeptCode=reclocid
			s OEORINotifyClinician=$p($g(^OEORD(+row,"I",oeoriid,11)),"^",55)
			s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"Y",:"N")
			s HospitalId=""
			s UserDepartmentDR=$p($g(^OEORD(+row,"I",oeoriid,7)),"^",2)
			i UserDepartmentDR'="" s HospitalId=$p(^CTLOC(UserDepartmentDR),"^",22)
			s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
			s TSGroup=##Class(DHCLIS.DHCCommon).GetTestSetGroup(GetTestCode,HospitalCode)
			
			s keyloop=LabDeptCode_"^"_(+datloop_stttimloop)_"^"_speccode_"^"_Container_"^"_LabItemGroupFlag_"^"_OEORINotifyClinician_"^"_TSGroup
			i (LabItemSingleFlag=0){
				s keyloop=keyloop_"^"_+row_"||"_oeoriid
			}
			;w +row_"||"_oeoriid_"-----"_keyloop,!
			
			
			i keyloop=($p(keylab,"*",1)) {
				if (OrdBloogSugarGroup=""){
					//只有血糖医嘱的第一条医嘱，与非血糖医嘱进行合并
					if ($p(keylab,"*",2)=1){
						s findepis=LabEpisodeNo
					}
				}else{
					//不同分组之间可以合并，相同分组的医嘱在循环一开始就已经continue了
					s findepis=LabEpisodeNo
				}
				
			}
		}
	}
	q findepis
	
	
 ;普通的处方合并规则，没有特别把处方合并在一起
MergePrescQue(key,PHPrescTypeCount)
	s findnod=""
	s nod="" f  s nod=$O(que1(nod))  Q:(nod="")||(findnod'="")  d
	.s nodkey=$P(nod,"^",1,2)
	.s presccount=$P(que1(nod),"^",3)
	.i presccount="" s presccount=0
	.i (PHPrescTypeCount="")&&(nodkey=key) d  Q
	..s presccount=presccount+1
	..s que1(nod)=$P(que1(nod),"^",1,2)_"^"_presccount
	..s findnod=nod
	.;
	.i (nodkey=key)&&(presccount<PHPrescTypeCount) d
	..s presccount=presccount+1
	..s que1(nod)=$P(que1(nod),"^",1,2)_"^"_presccount
	..s findnod=nod
	i findnod="" {
	 s que1count=que1count+1
	 s findnod=key_"^"_que1count
	 s prno=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
	 s que1(findnod)=prno_"^"_$g(locord)_"^"_"1"
	}
	Q findnod
 ;按照成组医嘱计算合并处方规则
MergePrescGroupQue
 s myIndex=Index
 s childordsubcount=0 
 if (+PHPrescTypeSingleB=0){
	Q:LinkIndex'=""
	s childordsub=""
	f{
		s childordsub=$o(OrdItemPList(0,"OEORI_Sub",Index,childordsub))
		q:childordsub=""
		k SubPLIST
		s SubArcim=OrdItemPList(childordsub,4)
		s SubOrderType=..GetItemCat(SubArcim)
		continue:(SubOrderType'="R")
	 	s childordsubcount=childordsubcount+1
	}
 }
 i +childordsubcount>0  s ordcount=childordsubcount+1
 e  s ordcount=1
 ;1.1 先检查是否有可以合并的组医嘱
 s find=0,currnod=""
 s nod="" f  s nod=$O(que1Group(nod))  Q:(nod="")||(find=1)  d
 .s presccount=+$g(que1Group(nod))
 .i ((presccount+ordcount)'>PHPrescTypeCount)&&(($P(nod,"&")=key))  s find=1,currnod=nod
 i find=1  d   //找到可以合并的组医嘱
 .s que1Group(currnod)=$g(que1Group(currnod))+ordcount
 .s que1Group(currnod,myIndex)=""
 e  d     //没有可以合并的组医嘱
 .;b ;判断是否可以和其他单医嘱合并
 .s find=0,currnod=""
 .s nod="" f  s nod=$O(que1Single(nod))  Q:(nod="")||(find=1)  d
 ..s presccount=+$g(que1Single(nod))
 ..i ((presccount+ordcount)'>PHPrescTypeCount)&&($P(nod,"&")=key)  s find=1,currnod=nod
 .i find=1  d   
 ..;b ;找到可以合并的单医嘱
 ..s que1Single(currnod)=$g(que1Single(currnod))+ordcount
 ..s que1Single(currnod,myIndex)=""  
 .e  d     //没有可以合并的医嘱则单独分一组
 ..i +childordsubcount>0  d
 ...;b ;组医嘱则单独分一组
 ...i $d(que1Group(key)) d
 ....s currcursor=""
 ....f cursor=1:1:10 q:currcursor'=""  d
 .....i '$d(que1Group(key_"&"_cursor)) s currcursor=cursor
 ....i currcursor'="" d 
 .....s que1Group(key_"&"_currcursor)=ordcount
 .....s que1Group(key_"&"_currcursor,myIndex)=""
 .....s que1Group(key_"&"_currcursor,0)=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
 ...e  d
 ....s que1Group(key)=ordcount
 ....s que1Group(key,myIndex)=""
 ....s que1Group(key,0)=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
 ..e  d
 ...;b ;单医嘱则单独分一组
 ...i $d(que1Single(key)) d
 ....s currcursor=""
 ....f cursor=1:1:10 q:currcursor'=""  d
 .....i '$d(que1Single(key_"&"_cursor)) s currcursor=cursor
 ....i currcursor'="" d 
 .....s que1Single(key_"&"_currcursor)=ordcount
 .....s que1Single(key_"&"_currcursor,myIndex)=""
 .....s que1Single(key_"&"_currcursor,0)=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
 ...e  d
 ....s que1Single(key)=ordcount
 ....s que1Single(key,myIndex)=""
 ....s que1Single(key,0)=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
 Q
 ;该方法与本类中的Classmethod：GetLinkOrdInfo处理逻辑一致
GetLinkOrdInfo(EpisodeID,Index,OrdItemPList)
	n (EpisodeID,Index,OrdItemPList)
	m PLIST=OrdItemPList(Index)
	;皮试或者毒麻都单独分处方，硬代码，与配置无关
	s SkinTestFlag=0
	s SkinTest="N"
	s AdmLocHospDr=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	;皮试用法
	s SkinTestInstr=##Class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",AdmLocHospDr)
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"

	///code^处方药品个数^单独分方标识^
	///成组医嘱以此类型为主要属性(成组医嘱包含多个处方类型，不勾选默认按照主医嘱处方类型分处方)^
	///单独走MJ开头处方号(用于毒麻处方)^
	///单独分处方(成组医嘱拆分分方，同处方类型同处方)
	s SplitPrescTypeDetails=..GetSplitPrescTypeDetails(EpisodeID,.PLIST)
	if ($P(SplitPrescTypeDetails,"^",3)=1)||($P(SplitPrescTypeDetails,"^",6)=1){
		q SkinTest_$C(1)_SkinTestFlag_$C(1)_SplitPrescTypeDetails
	}
	s LinkIndex=$O(OrdItemPList(0,"OEORI",Index,0))
	i LinkIndex'="" {
	   k PLIST
	   m PLIST=OrdItemPList(LinkIndex)
	}else{
		s LinkIndex=Index
	}
	s OrderInstrRowid=$G(PLIST(27))
	s OrderSkinTest=$G(PLIST(57))
	if (OrderSkinTest="Y") {
		s SkinTestFlag=1
		if (OrderInstrRowid'="")&&(SkinTestInstr[("^"_OrderInstrRowid_"^")){
			s SkinTestFlag=2
			s SkinTest="Y"
		}
	}
	//成组医嘱默认按照主医嘱处方类型设置
	s SplitPrescTypeDetails=..GetSplitPrescTypeDetails(EpisodeID,.PLIST)
	s SubIndex=0
	for {
		s SubIndex=$O(OrdItemPList(0,"OEORI_Sub",LinkIndex,SubIndex))
		q:SubIndex=""
		k SubPLIST
		m SubPLIST=OrdItemPList(SubIndex)
		s SubInstrRowid=$G(SubPLIST(27))
		s SubSkinTest=$G(SubPLIST(57))
		if (SubSkinTest="Y") {
			s SkinTestFlag=1
			if (SubInstrRowid'="")&&(SkinTestInstr[("^"_SubInstrRowid_"^")){
				s SkinTestFlag=2
				s SkinTest="Y"
			}
		}
		s SubSplitPrescTypeDetails=..GetSplitPrescTypeDetails(EpisodeID,.SubPLIST)
		//成组以此为主要属性
		if ($P(SubSplitPrescTypeDetails,"^",4)=1){
			s SplitPrescTypeDetails=SubSplitPrescTypeDetails
		}
	}
	q SkinTest_$C(1)_SkinTestFlag_$C(1)_SplitPrescTypeDetails
 
   
InitOrdItemArr(EpisodeID,OrdItemStr,SessionStr,OrdItemPList)
	n (EpisodeID,OrdItemStr,SessionStr,OrdItemPList)
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set par=$o(^OEORD(0,"Adm",EpisodeID,""))
	//1、--格式化未保存的医嘱
	k TempOrdList
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount	{
		Set OrdItem=$p(OrdItemStr,$c(1),i)
		continue:OrdItem=""
		/*s MasterOrderRowid=$p(OrdItem,"^",39)
 		i MasterOrderRowid'=""  {
			s SubSeqNo=$$GetSeqNoid^DHCDocOrderCommonNew(MasterOrderRowid)
			Set $p(OrdItem,"^",20)=SubSeqNo
		}*/
		s MasterSeqNo=$p(OrdItem,"^",19)
		s OrderSeqNo=$p(OrdItem,"^",20)
		i OrderSeqNo="" s OrderSeqNo=1
		s MasterOrderRowid=$p(OrdItem,"^",39)
		s Index=$I(TempOrdList)
		i MasterOrderRowid'="" {
			;处理护士绑定医嘱的数据
			s TempOrdList(MasterOrderRowid)=""
			s SubIndex=$I(TempOrdList(MasterOrderRowid,"sub"))
			s TempOrdList(OrderSeqNo)=OrdItem
			
		}else{
			i MasterSeqNo="" {
				s TempOrdList(OrderSeqNo)=OrdItem
			}else{
				if '$d(TempOrdList(MasterSeqNo)) {
					s TempOrdList(MasterSeqNo)=""
				}
				s TempOrdList(MasterSeqNo,"sub",OrderSeqNo)=OrdItem
				
			}
		}
	}
	//2--格式化已保存但是未正常生成处方\检验号的医嘱
	s OEITM=0 
	for{
		s OEITM=$o(^OEORD(+par,"I",OEITM))
		q:OEITM=""
		s row=+par_"||"_OEITM
		d getdata
		continue:labepis'=""
		continue:presc'=""
		continue:prseq'=""
		continue:" DS DIS E V I "'[(" "_$g(status)_" ")
		s prior=..GetPriorCode(row)
		continue:prior="REV"
		continue:prior="OM"
		s labflag=$p($g(labflag),$c(1))
		;有存库项关联且不为药品,不为检验则退出
		s inic=##class(web.DHCDocOrderEntry).GetINCI(+arcim)
		continue:(inic'="")&&($e(labflag)'="R")&&($e(labflag)'="L")
		continue:($e(labflag)'="L")&&('..stock(arcim))
		s LinkOrderItemRowId=$p($g(^OEORD(+row,"I",$p(row,"||",2),11)),"^",39)
		
		if (LinkOrderItemRowId=""){
			s TempOrdList("9999999"_OEITM,"row")=row
		}else{
			s TempOrdList("9999999"_$P(LinkOrderItemRowId,"||",2),"sub",OEITM,"row")=row
		}
	}
	
	//3--装载到Plist中
	s SubCount=0,MasterCount=0
	s MasterSeqNo=0
	for {
		s MasterSeqNo=$O(TempOrdList(MasterSeqNo))
		q:(MasterSeqNo="")
		s Index=""
		s OrdItem=$G(TempOrdList(MasterSeqNo))
		k PLIST
		s row=$G(TempOrdList(MasterSeqNo,"row"))
		if (MasterSeqNo["||"){
			s row=$P(MasterSeqNo,"||",1,2)
		}
		d InitPList
		if $D(PLIST){
			s MasterCount=MasterCount+1
			s PLIST("Bak","OrdItem")=OrdItem
			Set $p(OrdItem,"^",19)=""
			Set $p(OrdItem,"^",20)=MasterCount
			s PLIST("OrdItem")=OrdItem
			S PLIST("row")=row
			Set PLIST(77)=$p(OrdItem,"^",20)
			s Index=$I(OrdItemPList)
			m OrdItemPList(Index)=PLIST
		}
		s i=0,SubCount=0
		for {
			s i=$O(TempOrdList(MasterSeqNo,"sub",i))
			q:(i="")
			s OrdItem=$G(TempOrdList(MasterSeqNo,"sub",i))
			s row=$G(TempOrdList(MasterSeqNo,"sub",i,"row"))
			if (MasterSeqNo["||"){
				s row=$P(MasterSeqNo,"||",1,2)
			}
			d InitPList
			continue:('$D(PLIST))
			s SubCount=$I(SubCount)
			s PLIST("Bak","OrdItem")=OrdItem
			Set $p(OrdItem,"^",19)=MasterCount
			Set $p(OrdItem,"^",20)=+MasterCount+SubCount
			s PLIST("OrdItem")=OrdItem
			S PLIST("row")=row
			Set PLIST(77)=$p(OrdItem,"^",20)
			s SubIndex=$I(OrdItemPList)
			m OrdItemPList(SubIndex)=PLIST
			if (Index'=""){
				;记录主子医嘱关系
				s OrdItemPList(0,"OEORI",SubIndex,Index)=""
				s OrdItemPList(0,"OEORI_Sub",Index,SubIndex)=""
			}
		}
		s MasterCount=MasterCount+SubCount
	}
	q
InitPList
	n (EpisodeID,row,OrdItem,LABDATA,PLIST,SessionStr)
	s User=$P(SessionStr,"^",1)
	s Doc=##class(web.SSUser).GetDefaultCareProvider(User)
	s Loc=$P(SessionStr,"^",3)
	s CurLogonHosp=$P(SessionStr,"^",4)
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	s Adm=EpisodeID
	s err=$$PrepareBeforeOrd^DHCDocOrderCommonNew()
	q:(err'=0)
	if (row["||"){
		&SQL(select * into :PLIST() from OE_OrdItem where OEORI_RowId=:row)
		k PListExt
		&SQL(select * into :PLISTExt() from OE_OrdItemExt where OEORI_RowId=:row)
		m PLIST("DHC")=PLISTExt
		Set SpecimenCode=$$GetOELabSpecimen^DHCDocOrderCommonNew(row)
		Set ContainerCode=$$GetOELabContainer^DHCDocOrderCommonNew(row)
	}else{
		q:(OrdItem="")
		if (PAADMType="I"){
			Do SetPLIST^DHCDocOrderCommonNew
		}else{
			Do SetPLIST^DHCDocOrderCommon
		}
		Set SpecimenCode=$p(OrdItem,"^",28)
		s ContainerCode=$$GetContainer^DHCDocOrderCommonNew(PLIST(4),LABDATA,SpecimenCode,CurLogonHosp)
	}
	
	s PLIST("Lab")=SpecimenCode_"^"_ContainerCode
	

	q
 ;查询是否有可以合并的处方，若找不到就生成一个处方号
newque3(key,PHPrescTypeCount)
	s findnod=""
	s nod="" f  s nod=$O(que1(nod))  Q:(nod="")||(findnod'="")  d
	.s nodkey=$P(nod,"^",1,2)
	.s presccount=$P(que1(nod),"^",3)
	.i presccount="" s presccount=0
	.i (PHPrescTypeCount="")&&(nodkey=key) d  Q
	..s presccount=presccount+1
	..s que1(nod)=$P(que1(nod),"^",1,2)_"^"_presccount
	..s findnod=nod
	.;
	.i (nodkey=key)&&(presccount<PHPrescTypeCount) d
	..s presccount=presccount+1
	..s que1(nod)=$P(que1(nod),"^",1,2)_"^"_presccount
	..s findnod=nod
	i findnod="" {
		s que1count=que1count+1
		s findnod=key_"^"_que1count
		s prno=..CreatPrNo(+sttdat,adm,loc,$G(arcim) ,$G(row),$G(DMJPrescNo))
		s que1(findnod)=prno_"^"_$g(locord)_"^"_"1"
	}
	Q findnod
CreatOrdNoErr
	b ;程序发生异常
	s $ze=""
	l -^DBLock($zn,EpisodeID)
	d ##class(DHCDoc.Log.Common).General("Insert","web.DHCDocPrescript","CreatOrdNo","生成处方发生异常:"_$ZERROR,$G(EpisodeID),-1)
	q $G(OrdItemStr)
getdata ;        
	&SQL(SELECT OEORI_RowId,
	OEORI_ItmMast_DR,
	OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCF_DR,
	OEORI_Dosage_DR,
	OEORI_Durat_DR,
	OEORI_Instr_DR,
	OEORI_PrescNo,
	OEORI_OrdDept_DR,
	OEORI_RecDep_DR,
	OEORI_PrescSeqNo,
	OEORI_Doctor_DR,
	OEORI_PHFreq_DR,
	OEORI_ItemStat_DR->OSTAT_Code,
	OEORI_SeqNo,
	OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
	OEORI_LabEpisodeNo,
	OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code,
	OEORI_SttDat,OEORI_NotifyClinician
	INTO :row,:arcim,:form,:dose,:dur,:instr,:presc,:locord,:recloc,:prseq,:doc,:freq,:status,:seq2,:labflag,:labepis,:resexe,:sttdat,:NotifyClinician
	FROM OE_OrdItem
	WHERE OEORI_RowId = :row)
 q
}

/***
  **Description      :生成处方表表及处方扩展表信息
					 在生成医嘱过程调用，此时医嘱表及处方号已生成，初次调用时处方表未生成。同处方号的剩余医嘱调用时处方表已生成。
					 在处理草药医嘱的处方扩展表时需注意，处方扩展表中的数据在插入整张草药处方时生成
  **Author           :tanjishan
  **Time             :2021/10/27
  **debugger         :w ##Class(web.DHCDocPrescript).CreatPAQue("2657||73")
  **Parameter        :rowid:待处理的医嘱表ID，PrescNo:处方号，非必填项
  **Returns          :
***/
ClassMethod CreatPAQue(rowid As %String, PrescNo As %String = "") As %String [ ProcedureBlock = 1 ]
{
	if (PrescNo=""){
		s PrescNo=$P($G(^OEORD(+rowid,"I",$P(rowid,"||",2),1)),"^",14)
	}
	q:(PrescNo="") ""
	s OrderPrescNo=$P($G(^OEORD(+rowid,"I",$P(rowid,"||",2),1)),"^",14)
	q:(PrescNo'=OrderPrescNo) ""
	s EpisodeID=$p(^OEORD(+rowid),"^",1)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s RecDepRowid=$P($G(^OEORD(+rowid,"I",$P(rowid,"||",2),3)),"^",6)
	i ..exist(PrescNo,EpisodeID) {
		d ..newstat(PrescNo)
		q ""
	}
	if ('RecDepRowid){
		q ""
	}
	s DoctorDR=$p($g(^OEORD(+rowid,"I",$p(rowid,"||",2),1)),"^",11)
	s OrderPriorRowid=$P($G(^OEORD(+rowid,"I",$p(rowid,"||",2),1)),"^",8)
	s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
	s UserAdd=$p($g(^OEORD(+rowid,"I",$p(rowid,"||",2),7)),"^",1)
	s OrdStatus=$p(^OEORD(+rowid,"I",$p(rowid,"||",2),1),"^",13)
	s ArcimRowID=$p(^OEORD(+rowid,"I",$p(rowid,"||",2),1),"^",2)
	
	k que 
	s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(PrescNo)
	if DMFlag=1 {
		s SupplyInfo= ##class(web.DHCDocCheckPoison).GetSupplyMethod(EpisodeID)
		//Set ret=PAPMIDVAnumber_"^"_AgencyName_"^"_AgencyCredNo_"^"_AgencyTel_"^"_AgencyCredDr_"^"_PAPMIDCredTypeDr_"^"_Weight_"^"_PatAddress_"^"_mradm_"^"_PatientID_"^"_PatDobDate_"^"_PatSex
		s que(28)=$P(SupplyInfo,"^",5)
		s que(29)=$P(SupplyInfo,"^",3)
		s que(30)=$P(SupplyInfo,"^",2)
		s que(31)=$P(SupplyInfo,"^",4)
	}
	s que(3)=+RecDepRowid,que(5)=$s("IE"[AdmType:"P",$$pay^DHCOEOrdItem()["P":"T",1:"P"),que(6)=PrescNo,que(2)=+EpisodeID,que(16)=$g(DoctorDR) ;,que(18)=$g(locord)
	i OrderPriorCode="STAT" s que(19)="STAT"
	;Only for dispensing/injection location
	;只有接受科室是药房或注射室的医嘱，才需要生成处方号
	if " D DI "'[(" "_$p($g(^CTLOC(+RecDepRowid)),"^",13)_" "){
		q ""
	}
	&SQL(INSERT INTO SQLUser.PA_Que1 VALUES :que())
	if (SQLCODE){
		s count=$o(^DHCSYSERROR($ZN,..%SysDate(),""),-1)+1
		s ^DHCSYSERROR($ZN,..%SysDate(), count)="100^<ERROR>"_SQLCODE_"---"_$ZERROR_"  "_$H_"  "_$G(%msg)
		q ""
	}
	s PrescRowid=$p(%ROWID,$c(1))
	;check queue status and update if some of orders were packed
	i $g(que(5))["P" d ..newstat(PrescNo)
	///处理处方扩展表
	s IsCNMedItem=##Class(web.DHCDocOrderCommon).IsCNMedItem(ArcimRowID,AdmHospitalId)
	if (IsCNMedItem=0){
		K DHCPAQueList
		s DHCPAQueList(1)=PrescRowid
		s DHCPAQueList(3)=1
		s DHCPAQueList(4)=UserAdd
		s DHCPAQueList(5)=+$H
		s DHCPAQueList(6)=$P($H,",",2)
		s DHCPAQueList(9)=OrdStatus
		s DHCPAQueList(31)=##class(PHA.FACE.OUT.Com).GetPrescTitle(PrescNo)
		&SQL(UPDATE SQLUser.DHCPA_Que1 VALUES :DHCPAQueList() where DHCQUE_RowId=:PrescRowid)
	}
	q ""
}

/// creator:	谭吉善
/// date:		20210818
/// desc:		预览预生成的检验号码
/// input:		EpisodeID:就诊号
///             LabNoInfo:待保存的检验信息
///            
Query QueryLabOrdPreView(EpisodeID As %String, LabNoInfo As %String) As websys.Query(ROWSPEC = "Index:%String,LabNo:%String,ArcimDesc:%String,OrdRowID:%String,SpecimenDesc:%String,ContainerDesc:%String,LabNoDesc:%String,LabGroup:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.DHCDocPrescript","QueryLabOrdPreView","25","2765||1^21081800002^静脉血")
ClassMethod QueryLabOrdPreViewExecute(ByRef qHandle As %Binary, EpisodeID As %String, LabNoInfo As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	Set langid=..%LanguageID()
	s ^TEMPtan("QueryLabOrdPreView")=EpisodeID_","_LabNoInfo
	set ind=1
	if (LabNoInfo="") quit $$$OK
	s HospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
	Set ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	k LabNoArr
	for i=1:1:$Length(LabNoInfo,"@") {
		s OneLabNoInfo=$P(LabNoInfo,"@",i)
		s ArcimRowID=$P(OneLabNoInfo,"^",1)
		s LabEpisodeNo=$P(OneLabNoInfo,"^",2)
		s SpecimenCode=$P(OneLabNoInfo,"^",3)
		s OrdRowID=""
		s Count=$I(LabNoArr(LabEpisodeNo,0))
		s LabNoArr(LabEpisodeNo,Count)=ArcimRowID_"^"_SpecimenCode_"^"_OrdRowID
	}
	s LabCount=0
	s LabEpisodeNo=0
	for {
		s LabEpisodeNo=$O(LabNoArr(LabEpisodeNo))
		q:(LabEpisodeNo="")
		s LabCount=LabCount+1
		s LabNoDesc=##class(websys.Translation).Get("dhcdoc.labord.preview.csp","第")_LabCount_##class(websys.Translation).Get("dhcdoc.labord.preview.csp","组条码")
		s SubID=0
		for {
			s SubID=$O(^OEORD(0,"EpisNo",LabEpisodeNo,ord,SubID))
			q:(SubID="")
			s OrdStatus=""
			s OrdStatusDR=$p($G(^OEORD(ord,"I",SubID,1)),"^",13)
			s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
			continue:("VE"'[OrdStatus)
			s ArcimRowID=$p($G(^OEORD(ord,"I",SubID,1)),"^",2)
			s OrdRowID=ord_"||"_SubID
			s SpecCode=$$GetOELabSpecimen^DHCDocOrderCommonNew(OrdRowID)
			s Count=$I(LabNoArr(LabEpisodeNo,0))
			s LabNoArr(LabEpisodeNo,Count)=ArcimRowID_"^"_SpecCode_"^"_OrdRowID
		}
		s Count=0
		for {
			s Count=$O(LabNoArr(LabEpisodeNo,Count))
			q:(Count="")
			s ArcimRowID=$P(LabNoArr(LabEpisodeNo,Count),"^",1)
			s ArcimDesc=$P(^ARCIM(+ArcimRowID,$P(ArcimRowID,"||",2),1),"^",2)
 			s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
			s SpecimenCode=$P(LabNoArr(LabEpisodeNo,Count),"^",2)
			s OrdRowID=$P(LabNoArr(LabEpisodeNo,Count),"^",3)
			s Container=$$GetContainer^DHCDocOrderCommonNew(ArcimRowID,"",SpecimenCode,HospitalId)
			s SpecimenDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecimenCode,$g(HospitalCode)),$c(2),2) 
			s ContainerDesc=$p(##Class(DHCLIS.DHCCommon).GetContainer(Container,$g(HospitalCode)),$c(2),3) 
			
			s GetTestCode=..GetTestCode(ArcimRowID)
			s LabDeptCode=..GetTestCodeRecLoc(ArcimRowID)
			s TSGroup=##Class(DHCLIS.DHCCommon).GetTestSetGroup(GetTestCode,HospitalCode)
			
			s LabGroup=LabDeptCode_" "_TSGroup
			
			d Output
		}
	}
	
	quit $$$OK
	
Output
	set Data=$lb(ind,LabEpisodeNo,ArcimDesc,OrdRowID,SpecimenDesc,ContainerDesc,LabNoDesc,LabGroup)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// 获取唯一的ID 可用于关联第三方审方系统
/// OE_OrdItemExt->OEORI_SerialNum
/// w ##class(web.DHCDocPrescript).GetOrderSerialNum(123)
ClassMethod GetOrderSerialNum(PAADMDr, Count As %String = 1) As %String
{
	s SerialNumS=""
	s length=6
	s cnttype=$p($g(^CF("PATCF",1,7)),"^",2)
	i cnttype="" s cnttype=1
	s dt=$zd($h)
	for i=1:1:Count {
		s ind=..next("^COUNT(""CNTTYPE"","_cnttype_",""OEOrd_Serial"",+$h)")
		;12*(计数器十万位值)+当前月份
		s month=$p(dt,"/")
		s month=($E(ind,1,$L(ind)-length)*12)+month
		s month=..LPAD2(month,"0",2)
		s dt=$e($p(dt,"/",3),3,4)_month_$p(dt,"/",2)
		s SerialNum=dt_..LPAD2(ind,"0",length)
		if (SerialNumS=""){
			s SerialNumS=SerialNum
		}else{
			s SerialNumS=SerialNumS_","_SerialNum
		}
	}
	q SerialNumS
}

/// 获取医嘱审核单编号
ClassMethod GetDemandNumber() As %String
{
	s CurrDate=$zd(..%SysDate(),8)
	s CurrTime=$p($zt($p($h,",",2),2),":",1)_$p($zt($p($h,",",2),2),":",2)
	s DemandNumber=$I(^DHCDocConfig("AuditSerialNo"))	;好像不需要加分钟子节点，这样写就能实现每分钟1万次医嘱插入
	s DemandNumber=..LPAD2(DemandNumber,"0",4)
	s DemandNumber=CurrDate_CurrTime_DemandNumber
	q DemandNumber
}

/// Description:门诊打印统一方法调用,适用于配药,发药,直接发药,查询等界面打印处方,摆药单
/// Input:处方号,科室
/// Output:打印所需内容
/// Other:d ##class(web.DHCDocPrescript).GetPrescInfoByOrd("I181213000019","","")
ClassMethod GetPrescInfoByOrd(PrescNo As %String, phdphl = "", prt = "", SearchDate As %String = "")
{

   //是否需要考虑判断接收科室 1 考虑 0不考虑
   s chkreclocflag=0
   s patstring=""  //处方信息(含患者基本信息)
   s medstring=""  //医嘱信息
   s reclocdr="",recloc=""
   Q:PrescNo="" "OK"
   s IsARCOSFormula=##class(web.UDHCPrescript).IsPresnoFormula(PrescNo) 
   s SearchDate=..%ZDH(SearchDate)
   i SearchDate="" s SearchDate=..%SysDate()
   q:'$D(^PAQUE1(0,"PrescNo",PrescNo)) "OK"
   s:phdphl'="" reclocdr=$p(^DHCPHLOC(phdphl),"^",1)
   s ord="" 
   f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,ord)) q:ord=""  d
   .s adm=$p(^OEORD(ord),"^",1)
   .s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(adm)
   .s papmi=+$p(^PAADM(adm),"^",1)
   .s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   .s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   .s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   .s homeTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)   //家庭电话
   .s workTel=$p($g(^PAPER(papmi,"PER",1)),"^",9)    //工作电话
   .s handtel=$p($g(^PAPER(papmi,"PER",4)),"^",21)   //手机
   .i handtel'="" s ptel=handtel
   .s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   .s paddress=$g(^PAPER(papmi,"PER","ADD",1)) // 住址
   .s getage=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",papmi,adm)
   .s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   .s sex=$p(^CT("SEX",sexdr),"^",2)
   .s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   .s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   .s cardNo=""
   .i cfRowId'="" s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   .s admord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   .s adm=$p(^OEORD(admord),"^",1)
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .i admdate'="" s admdate=$zd(admdate,3)
   .s MRADMID=$p(^PAADM(adm),"^",61)
   .s diagnodesc=##class(web.UDHCPrescript).GetMRDiagnosDescNew(MRADMID,";","")
   .//##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRADMID,";") //##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   .s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   .s deplocdr=$p(^PAADM(adm),"^",4)
   .s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
   .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   .//配药信息
   .s pyname="",fyname="",pydate="",fydate="",phloc="",phwindesc=""
   .s phdrow=$$getphdrow(PrescNo,phdphl,prt)
   .i phdrow'="" d
   ..s pyname=""
   ..s pyuserdr=$p(^DHCPHDISP(phdrow,1),"^",3)
   ..i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
   ..s fyname=""
   ..s fyuserdr=$p(^DHCPHDISP(phdrow,1),"^",2)
   ..i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)
   ..;
   ..s pydate=$p(^DHCPHDISP(phdrow,1),"^",5)
   ..i pydate'="" s pydate=$zd(pydate,3)
   ..s pytime=$p(^DHCPHDISP(phdrow,1),"^",7)
   ..i pytime'="" s pytime=..%ZT(pytime,1)
   ..s pydate=pydate_" "_pytime
   ..; 
   ..s fydate=$p(^DHCPHDISP(phdrow),"^",3)
   ..i fydate'="" s fydate=$zd(fydate,3)
   ..s fytime=$p(^DHCPHDISP(phdrow),"^",5)
   ..i fytime'="" s fytime=..%ZT(fytime,1)
   ..s fydate=fydate_" "_fytime
   ..;
   ..s phl=$p(^DHCPHDISP(phdrow,1),"^",1)
   ..s phlocdr=$p(^DHCPHLOC(phl),"^",1)
   ..s phloc=$p(^CTLOC(phlocdr),"^",2)
   ..;
   ..s phwindesc=""
   ..s phwdr=$p(^DHCPHDISP(phdrow),"^",4)
   ..i phwdr'="" d 
   ...i $D(^DHCPHWIN(phwdr)) d
   ....s phwindesc=$p(^DHCPHWIN(phwdr),"^",1)
   ..
   .
   .s sysdate=$zd(+$h,3)_" "_$p(..%ZT(..%SysTime(),1),":",1,2) 
   .s retstr=..Getpaque(PrescNo)
   .s queinst=$p(retstr,"^",1)
   .s quefac=$p(retstr,"^",2) 
   .s queqty=$p(retstr,"^",3)
   .s quedate=$p(retstr,"^",4)
   .s quexdate=$p(retstr,"^",5)
   .s quenote=$p(retstr,"^",6)  
   .s quecook=$p(retstr,"^",7)
   .s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(PrescNo,reclocdr)
   .s docctloc=$p(docstr,"^",1)
   .s doctor=$p(docstr,"^",2)
   .s orddate=$p(docstr,"^",3)
   .s ordtime=$p(docstr,"^",4)
   .s orddate=orddate_" "_ordtime
   .s paydtae=..GetOrdPayDate(prt)
   .s billtype=..GetPrescType(PrescNo)
   .i billtype="" d
   ..s PatCatDr=$p(^PAPER(papmi,"PER",1),"^",10)
   ..s DefaultBillTypeId=..GetDefaultBillType(PatCatDr)
   ..i DefaultBillTypeId'="" s billtype=$p(^PAC("ADMREA",DefaultBillTypeId),"^",2)
   .;s prescbillchk=##class(web.DHCOutPhCommon).GetPrescBillAuditDesc(PrescNo)
   .s prescbillchk=""
   .s presctitle=..GetPrescPrtTitle(PrescNo)
   .s lgflag=..ChkLGFlagByPrescNo(PrescNo)
   .;
   .s itmSub=$o(^OEORD(0,"PrescNo",PrescNo,ord,0))
   .s:reclocdr="" reclocdr=$P($G(^OEORD(ord,"I",itmSub,3)),"^",6) ;OEORI_RecDep_DR接收科室
   .s:reclocdr'="" recloc=$p(^CTLOC(reclocdr),"^",2)
   .i $F(recloc,"-") s recloc=$p(recloc,"-",2)
   .s EmployeeFunction=""
   .s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,.ErrMsg)
   .i PatEncryptLevel'="" s EmployeeFunction=$p(PatEncryptLevel,"^",2)
   .s Medcare=##class(web.DHCDocOrderCommon).GetMrNo("",papmi,PAAdmType)
   .//if Medcare="" set Medcare=$p($g(^PAPER(papmi,"PAT",1)),"^",22)  //住院病历号
   .Set SessLoc =$g(%session.Data("LOGON.CTLOCID")),SessHospDesc="" 
   .if SessLoc>0 d 
   ..Set SessHosp = $p(^CTLOC(SessLoc),"^",22)
   ..Set:SessHosp>0 SessHospDesc=$p(^CT("HOSP",SessHosp),"^",2)
   
   .Set BedId=$P($g(^PAADM(adm)),"^",73)
   .if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
   .else  Set PAAdmBed=""
   
   .s tmppatstring=perno_"^"_pname_"^"_sex_"^"_getage_"^"_diagnodesc_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo_"^"_PrescNo_"^"_deplocdesc_"^"_phwindesc_"^"_ptel_"^"_paddress_"^"_quecook_"^"_queqty_"^"_presctitle_"^"_docctloc_"^"_doctor
   .s tmppatstring=tmppatstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate_"^"_quenote_"^"_orddate_"^"_paydtae_"^"_billtype_"^"_prescbillchk_"^"_lgflag_"^"_EmployeeFunction
   .s tmppatstring=tmppatstring_"^"_Medcare_"^"_SessHospDesc_"^"_adm_"^"_deplocdr_"^"_PAAdmType_"^"_PAAdmBed
   .;
   .s itm=""
   .f  s itm=$o(^OEORD(0,"PrescNo",PrescNo,ord,itm)) q:itm=""  d
   ..s tmpreclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
   ..q:(tmpreclocdr'=reclocdr)&(chkreclocflag'=0)
   ..s oeori=ord_"||"_itm
   ..s OrdStatus=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
   ..s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
   ..s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
   ..s RePay=##class(web.DHCBillInterface).IOrdItmInvStatusByOeoriDR(ord_"||"_itm)
   ..s RePay=$p(RePay,"^")
   ..i " 0 1 2 "[(" "_RePay_" ") s RePay=$Case(RePay,"0":"","1":"部分退费","2":"全部退费")
   ..Q:((OrdStatus'="V")&&(((OrdStatus="D")&(RePay'="部分退费"))||(OrdStatus'="D")))&&(PAAdmType'="I")
   ..q:(##Class(web.UDHCPrescript).GetOrdExecCount(ord_"||"_itm,SearchDate)=0)&&(PAAdmType="I")
   ..s PriorityDR=$p(^OEORD(+ord,"I",itm,1),"^",8)
   ..s Priority=$p(^OECPR(PriorityDR),"^",2)
   ..s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
   ..s nouseitm=""
   ..//s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
   ..//s qty=$p(^DHCOEDISQTY(dsp),"^",2)
   ..s dsp=0,qty=0
   ..f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp))  q:dsp=""  d
   ...s qty=+$g(qty)+$p(^DHCOEDISQTY(dsp),"^",2)
   ..s freq=$p(^PHCFR(+$p($g(^OEORD(ord,"I",itm,2)),"^",4)),"^",3)  ;用药频率
   ..s WeekFlag=$P(^PHCFR(+$p($g(^OEORD(ord,"I",itm,2)),"^",4)),"^",9)
   ..i WeekFlag="Y" d
   ...s OrderFreqWeek=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",55)
   ...s freq=freq_"-"_$TR(OrderFreqWeek,"|","")
   ..s freq2=$p(^PHCFR(+$p($g(^OEORD(ord,"I",itm,2)),"^",4)),"^",2)  ;用药频率
   ..s inst=$p(^PHCIN(+$p($g(^OEORD(ord,"I",itm,2)),"^",7)),"^",2)  ;用法 
   ..s inst2=$p(^PHCIN(+$p($g(^OEORD(ord,"I",itm,2)),"^",7)),"^",3)  ;用法 
   ..s phdur=$p(^PHCDU(+$p($g(^OEORD(ord,"I",itm,2)),"^",6)),"^",1) ;用药疗程
   ..s dosage=$p($g(^OEORD(ord,"I",itm,2)),"^",1) ;用药剂量
   ..s dosageuomdr=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
   ..s dosageuom=""
   ..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位 
   
   ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
   ..s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcimid)
   ..if (CheckCHNFlag="Y") d
   ...s Phcdf=$P($g(^ARCIM(+arcimid,$P(arcimid,"||",2),1)),"^",12)
   ...if Phcdf'="" s dosageuomdr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),dosageuom=##class(web.DHCDocOrderCommon).GetUOMDesc(dosageuomdr)
   ..s ARCIMBillingUOM=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(oeori)
   ..s totalprice=0
   ..s price=0
   ..i qty'=0 s price=totalprice/qty
   ..e  s price=totalprice
   ..s price=$fn(price,"",4)
   ..
   ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""
   ..s incidsec=$P($g(^ARCIM(+arcimid,$P(arcimid,"||",2),1)),"^",2) //$p(^INCI(inci,1),"^",2)
   
   ..//s PAQUERowId=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
   ..//s PrescNoArcosRowid=$P($g(^PAQUE1(PAQUERowId,"DHC")),"^",24)
   ..//s IsARCOSFormula=##class(web.UDHCPrescript).IsARCOSFormula(PrescNoArcosRowid)
   ..if (IsARCOSFormula="1") d
   ...s ARCIMARcosRowId=$p($g(^OEORD(ord,"I",itm,3)),"^",10)
   ...i ##class(web.UDHCPrescript).IsARCOSFormula(ARCIMARcosRowId)'="1" s incidsec="*"_incidsec
   
   ..s unit=""
   ..//s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
   ..//s qty=$p(qtyinfo,"^",1)
   ..//s unit=$p(qtyinfo,"^",2)
   ..i ARCIMBillingUOM'="" s unit=$p($g(^CT("UOM",ARCIMBillingUOM)),"^",2)
   ..i CheckCHNFlag="Y" s unit=dosageuom
   ..s qty=$p(^OEORD(ord,"I",itm,9),"^",4) 
   ..if +qty=0 d
   ...s dis=0  
   ...f  s dis=$O(^DHCOEDISQTY(0,"OEORI",ord_"||"_itm,dis)) q:dis=""  d
   ....s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
   ....i (dstatus="C")||(dstatus="TC") d
   .....s qty=qty+$p(^DHCOEDISQTY(dis),"^",11)
   ...s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+arcimid)
   ...s BillingUOMDR=$p($g(^INCI(INCIRowid,1)),"^",10)
   ...s unit=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
   ...i CheckCHNFlag="Y" s unit=dosageuom
   
   ..s skintest=""
   ..s skinflag=##class(web.DHCOutPhCommon).SkinTest(ord_"||"_itm)
   ..i (skinflag'<0)&(skinflag'="") s skintest="(-)"
   ..i skinflag=-1 s skintest="(+)"
   ..i skinflag=-6 s skintest="( )"
   ..i skinflag=-5 s skintest="(原液)"
   ..s OrdAction=$p(^OEORD(ord,"I",itm,11),"^",21)
   ..i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2)
   ..s skintest=OrdAction_skintest
   ..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
   ..s ordremark=##class(web.DHCDocUtil).EvalJSON(ordremark)
   ..if (ISLongOrderPrior) d
   ...s price="",totalprice=""
   ..e  d
   ...i prt="" d
   ....s price=+##Class(web.DHCDocOrderCommon).GetOEORIPrice(ord_"||"_itm)
   ....s totalprice=price*qty
   ....s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(oeori)
   ....s totalprice=$P(OrderMesage,"^",3)
   ...e  d
   ....s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
   ....s price=$p(ordpriceinfo,"^",1)
   ....s price=$Fn(price,"",6)
   ....s totalprice=$p(ordpriceinfo,"^",2)
   ....;s:totalprice=0 nouseitm=0
   ....s OrderMesage=##class(web.DHCDocOrderCommon).GetOrderMesage(oeori)
   ....s totalprice=$P(OrderMesage,"^",3)
   
   ..s PriorityDR=$p($g(^OEORD(ord,"I",itm,1)),"^",8)  
   ..s:$g(PriorityDR)="" PriorityCode=""
   ..s:$g(PriorityDR)'="" PriorityCode=$p(^OECPR(PriorityDR),"^",1)
   ..if (PriorityCode="OM")||(PriorityCode="OMST")||(PriorityCode="OMCQZT")||(PriorityCode="OMLSZT") s price=0.00,totalprice=0.00
   
   ..q:$g(nouseitm)=0
   ..s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
   ..s moeori=..GetMainOeori(oeori)
   ..s chkgl=..ChkOrdGL(moeori)
   ..i chkgl=0 d
   ...s tseqno=+$g(tseqno)+1
   ...s prtno=tseqno
   ..
   ..i chkgl=1 d
   ...i oeori'=moeori d
   ....i $g(tseqno)="" s tseqno=1
   ....s tseq=+$g(tseq)+1
   ....s prtno=tseqno_"."_tseq
   ...e  d
   ....s tseq=0
   ....s tseqno=+$g(tseqno)+1
   ....s prtno=tseqno
   ..
   ..s patstring=tmppatstring
   ..s specinst=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
   ..s MaxQty=$p($g(^ARCIM(+arcimid,$p(arcimid,"||",2),9)),"^",30) //单次最大剂量//##Class(web.DHCDocOrderEntry).GetARCIMMaxQty(arcimid)
   ..s OverQtyInfo=""
   ..if (PAAdmType="O")&&(dosage>MaxQty)&&(MaxQty>0) s OverQtyInfo=doctor
   ..if (qty<1)&&($p(qty,".",1)="") s qty="0"_qty
   ..s tmpsting=incidsec_"^"_qty_"^"_unit_"^"_dosage_""_dosageuom_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_prtno_"^"_specinst_"^"_ISLongOrderPrior_"^"_Priority_"^"_OverQtyInfo
   ..i medstring="" d
   ...s medstring=tmpsting
   ..e  d
   ...s medstring=medstring_"@"_tmpsting
   ..
   ..
   q patstring_"!!"_medstring
   
getphdrow(PrescNo,phdphl,prt)
   s phdrow="",tmpphdrow=""
   f  s phdrow=$o(^DHCPHDISPi("PRESCNO",PrescNo,phdrow)) q:phdrow=""  d
   .s tmpphdphl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .q:(tmpphdphl'=phdphl)&(chkreclocflag='0)&(phdphl'="")
   .s tmpptr=$p(^DHCPHDISP(phdrow),"^",2)
   .q:(tmpptr'="")&(tmpptr'=prt)&(prt'="")
   .s tmpphdrow=phdrow
   q tmpphdrow
}

ClassMethod Getpaque(prescno As %String) As %String
{
   ;获得中草药信息 PA_Que1 
    
   q:prescno="" ""
   s queid=""
   s questr=""
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC"))
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=""
   .i insdr'="" s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=""
   .i durdr'="" s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=$zd(quedate,3)
   .i $g(quexdate)'="" s quexdate=$zd(quexdate,3)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type
   .
   q $g(questr)
}

/// 获取处方收费日期
ClassMethod GetOrdPayDate(prt As %String) As %String
{
  q:prt="" ""
  s phar=""
  f  s phar=$o(^DHCPHARi("PRT",prt,phar)) q:phar=""  d
  .s phardate=$p(^DHCPHARW(phar),"^",2)
  .i phardate'="" d
  ..s phardate=$zd(phardate,3)
  .s phartime=$p(^DHCPHARW(phar),"^",5)
  .i phartime'="" d
  ..s phartime=..%ZT(phartime,1)
  ..s phartime=$p(phartime,":",1,2)
  q $g(phardate)_" "_$g(phartime)
}

/// Description:得到处方类型(医保,自费)
/// Creator:郭荣勇
/// CreatDate:2014-08-31
ClassMethod GetPrescType(prescno)
{
  s presctypedesc=""
   s ord=$o(^OEORD(0,"PrescNo",prescno,"")) 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"") ) 
   s preason=$p(^OEORD(ord,"I",itm,11),"^",18)
   q:preason="" ""
   s presctypedesc=$p($G(^PAC("ADMREA",preason,"DOC")),"^",1)
   i presctypedesc=""  s presctypedesc=$p(^PAC("ADMREA",preason),"^",2)
   
   ;北京地区医保病人打印分:医保(内),医保(外)
   s AdmId=$p(^OEORD(ord),"^",1)
   s PatientID=$p(^PAADM(AdmId),"^",1)
   s AdmType=$p(^PAADM(AdmId),"^",2)
   s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
   s DefaultBillTypeId=..GetDefaultBillType(PatCatDr)
   s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(DefaultBillTypeId,AdmType)
   i InsurFlag=1 {
      i presctypedesc="自费"  ;s presctypedesc="医保(外)"
   }
   
   q presctypedesc
}

ClassMethod GetDefaultBillType(PatCatDr As %String) As %String
{
   set AdmReason=""
   i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
   i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
   Q AdmReason
}

/// Description:得到处方打印类型(毒麻,精神一类,精神二类)
/// Creator:Liang Qiang
/// CreatDate:2011-08-31
ClassMethod GetPrescPrtTitle(presc)
{
   /*s prescord="",prescitm="",retval=""
   s prescord=$o(^OEORD(0,"PrescNo",presc,""))
   i prescord="" q ""
   s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
   s prescitmmast=""
   s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
   s prescdrgform="",prescdrgmast=""
   s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
   s prescdrgmast=$p(prescdrgform,"||",1)
   s prescpoisondr=""
   i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
   i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
   s prescitmcat="",oeccat="",oecatdesc=""
   s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
   s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
   s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
   s poisonflag=0
   s poisonflag=..CheckPoison(poisondesc)
   i poisonflag=1 s retval=poisondesc
   e  s retval=""
   q retval*/
   s prescord="",prescitm="",retval=""
   s prescord=$o(^OEORD(0,"PrescNo",presc,""))
   i prescord="" q ""
   s prescitm=0
   for {
      s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,prescitm))
      Q:prescitm=""
      s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
      s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
      continue:prescdrgform=""
      s prescdrgmast=$p(prescdrgform,"||",1)
      s prescpoisondr="",poisondesc=""
      i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
      i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
      s poisonflag=..CheckPoison(poisondesc)
      i poisonflag=1 s retval=poisondesc
      Q:retval'=""
   }
   Q retval
}

ClassMethod CheckPoison(poisondesc)
{
    i poisondesc="" q 0
    i poisondesc["毒" q 1
    i poisondesc["麻" q 1
    i poisondesc["精" q 1
    q 0
}

/// 判断该处方是否留观  0 非  1 是
ClassMethod ChkLGFlagByPrescNo(prescno) As %String
{
   q:prescno="" 0
   s ord=$o(^OEORD(0,"PrescNo",prescno,""))
   q:ord="" 0 
   s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
    q:ord="" 0                      
    s lgflag=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",17)
    q:lgflag="" 0
   q 1
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
   //N (oeori)
   Q:oeori="" ""
   S ord=$p(oeori,"||",1) Q:ord="" ""
   S chl=$p(oeori,"||",2) Q:chl="" ""
   Q:'$D(^OEORD(ord,"I",chl,1)) ""
   Q:'$D(^OEORD(ord,"I",chl,11)) ""
   S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
   Q:loeori'="" loeori
   Q oeori
}

/// 检查是否关联医嘱，1 -是 ，0- 否
ClassMethod ChkOrdGL(moeori)
{
   s mord=+moeori
   s m=0
   s lchl=""
   f  s lchl=$O(^OEORDi(0,"OEORI",mord,moeori,lchl))  q:lchl=""  d
   .s m=m+1
   i m>1 q 1
   q m
}

/// 判断处方是否为草药处方
/// 入参：   PrescNo:     处方号
ClassMethod IsPrescType(PrescNo As %String) As %String
{
   Q:PrescNo="" 0
   s PrescRowId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
   Q:PrescRowId="" 0
   s PrescType=$p($G(^PAQUE1(PrescRowId,"DHC")),"^",2)
   Q:PrescType=3 1
   Q 0
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:得到是否毒麻处方
/// output:1 毒麻,0 非毒麻
/// d ##class(web.DHCDocPrescript).IsDMPresc("OJE14092400002")
ClassMethod IsDMPresc(PrescNo As %String) As %String
{
   /*Q:PrescNo="" 0
   s Ord=$O(^OEORD(0,"PrescNo",PrescNo,0))
   i Ord'="" s Chl=$O(^OEORD(0,"PrescNo",PrescNo,Ord,0))
   Q:$g(Chl)="" 0
   s ARCIMRowid=$p($g(^OEORD(Ord,"I",Chl,1)),"^",2)
   s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
   i PoisonRowid'="" {
      s PoisonCode=$p($g(^PHCPO(PoisonRowid)),"^",1)
      i " J1 DM DX MZ J2 "[ PoisonCode  Q 1
   }
   Q 0*/
    s DMPrescFlag=0
    Q:PrescNo="" DMPrescFlag
    s Ord=$O(^OEORD(0,"PrescNo",PrescNo,0))
    i Ord'="" {
       s Chl=0
       for  {
          s Chl=$O(^OEORD(0,"PrescNo",PrescNo,Ord,Chl))
          Q:Chl=""
          s ARCIMRowid=$p($g(^OEORD(Ord,"I",Chl,1)),"^",2)
          s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
          i PoisonRowid'="" {
            s PoisonCode=$p($g(^PHCPO(PoisonRowid)),"^",1)
            i " J1 DM DX MZ J2 "[ PoisonCode  s DMPrescFlag=1
         }
         Q:DMPrescFlag=1
       }
   }
    
    Q DMPrescFlag
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:得到XML模版打印的ID
ClassMethod GetXMLTemplateId(XMLTemplateName As %String) As %String
{
   Q:XMLTemplateName="" ""
   s XMLTemplateName=$zcvt(XMLTemplateName,"U")
   s XMLTemplateName=" "_XMLTemplateName
   s Id=$O(^User.DHCXMLPConfigI("XPCFlagIndex",XMLTemplateName,0))
   Q Id
}

/// desc:得到XMl模板名
ClassMethod GetXMLTemplateName(XMLTemplateID As %String) As %String
{
   Q:XMLTemplateID="" ""
   s XMLTemplateName=$lg(^User.DHCXMLPConfigD(XMLTemplateID),3)
   Q XMLTemplateName
}

/// Creator:郭荣勇
/// date:2014-08-26
/// desc:输出csp中的空格
ClassMethod OutSpace(Num As %String) As %String
{
   s OutStr=""
   for i=1:1:+Num {
      s OutStr=OutStr_"&nbsp"
   }
   Q OutStr
}

/// Creator:lxz
/// date:2014-12-01
/// desc:创建患者就诊的处方列表
ClassMethod PrescNoList(itmjs As %String, EpisodeID As %String, PresStr As %String = "", DisPlayType As %String = "") As %String
{
 s ReturnStr=""   
 s PrescNo="", TransDate="", TransTime="", RecLoc=""
 &sql(DECLARE EmpCur2 CURSOR FOR
 SELECT distinct OEORI_PrescNo,to_Date(OEORI_Date,'YYYY-MM-DD'),cast(OEORI_Time AS TIMESTAMP),OEORI_RecDep_DR->CTLOC_Desc
     INTO :PrescNo,:TransDate,:TransTime,:RecLoc
     from SQLUser.OE_OrdItem 
    Where OEORI_OEORD_Parref->OEORD_ADM_DR=:EpisodeID and OEORI_PrescNo<>""
     Order By OEORI_PrescNo)
 &sql(OPEN EmpCur2)
 for  &SQL(FETCH EmpCur2) QUIT:SQLCODE  do
 .Q:((PresStr'="")&&(("^"_PresStr_"^")'[("^"_PrescNo_"^")))
 .s Count=##class(web.DHCOEOrdItem).GetPrescItemCount(EpisodeID,PrescNo)
 .i (Count>0)||(DisPlayType="MJ") Do
 ..s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
 ..s itemsub=$O(^OEORD(0,"PrescNo",PrescNo,OrderRowid,0))
 ..s ArcimRowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 
 ..s QUERowID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
 ..q:QUERowID=""
 ..s PHPrescType=##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimRowid)
 ..if (PHPrescType=1) d
 ...s AddUser=$P(^PAQUE1(QUERowID,"DHC"),"^",3)
 ..else  d
 ...s AddUser=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1)
 ..s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
 ..s CareProvType=$zcvt(CareProvType,"U")
 ..Q:(CareProvType'="DOCTOR") 
 
 ..s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
 ..s TransDate=$zd(SttDate,3)
 ..i ArcimRowid'="" s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
 ..s PatientID=$P(^PAADM(EpisodeID),"^",1)
 ..s PatientDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
 ..;1:普通  2:毒麻  3:精二  4:小儿
 ..s PrescType="",PrescTypeDesc=""
 ..i PatientDOB'="" d
 ...i (((+$H)-PatientDOB)/365.25)<15 s PrescType=3
 ..s IsDMPresc=..IsDMPresc(PrescNo)
 ..if IsDMPresc  d
 ...s PrescType=2
 ..i PrescType="" s PrescType=1
 ..i PrescType=1 s PrescTypeDesc="普通"
 ..i PrescType=2 s PrescTypeDesc=..GetPrescPrtTitle(PrescNo)
 ..i PrescType=3 s PrescTypeDesc="小儿"
 ..i ItemCatDR'="" s ItemCatDR="^"_ItemCatDR_"^"
 ..s Desc=PrescNo_"   "_TransDate_"   "_RecLoc_"   "_PrescTypeDesc
 ..if (itmjs'="")  d
 ...s Desc=PrescNo_"   "_TransDate_"   "_RecLoc_"   "_PrescTypeDesc
 ...s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(PrescNo,"O","JS")_"');"
 ...&javascript<#(retval)#>
 ..if ReturnStr="" s ReturnStr=Desc_"!"_PrescNo
 ..else  s ReturnStr=ReturnStr_"^"_Desc_"!"_PrescNo
 &sql(CLOSE EmpCur2)
 q ReturnStr
}

/// Creator:lxz
/// date:2014-12-01
/// desc:获取患者所有的医嘱列表
/// w ##class(web.DHCDocPrescript).GetAllPrescNo(713)
ClassMethod GetAllPrescNo(EpisodeID As %String) As %String
{
   s PrescNoStr=""
   s OEOrdRowID=+$o(^OEORD(0,"Adm",+EpisodeID,0))
   if OEOrdRowID'=0  d
   .s QUERowID=0
   .f  s QUERowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUERowID)) Q:QUERowID=""  d
   ..s QUENO=$P($G(^PAQUE1(QUERowID)),"^",14)
   ..Q:QUENO=""
   ..s PrescNo=QUENO
   ..s Have="0"
   ..s ord=0
   ..f  s ord=$o(^OEORD(0,"PrescNo",PrescNo,OEOrdRowID,ord)) q:((ord="")||(Have=1))  d
   ...s Stat=$P($G(^OEORD(OEOrdRowID,"I",ord,1)),"^",13) 
   ...s statcode="V"
   ...i Stat'="" d
   ...s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
   ...s statDesc=$p($g(^OEC("OSTAT",Stat)),"^",2) 
   ...s statcode=$ZCVT(statcode,"U")
   ...Q:((statcode="C")||(statcode="U")) //||(statcode="D"))
   ...s ARCIMRowid=$p(^OEORD(OEOrdRowID,"I",ord,1),"^",2)
   ...s PHPrescType=##class(web.DHCDocOrderCommon).IsCNMedItem(ARCIMRowid)
   ...if (PHPrescType=1) d
   ....s AddUser=$P(^PAQUE1(QUERowID,"DHC"),"^",3)
   ...else  d
   ....s AddUser=$p(^OEORD(OEOrdRowID,"I",ord,7),"^",1)
    ...s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
    ...s CareProvType=$zcvt(CareProvType,"U")
    ...Q:(CareProvType'="DOCTOR") 
   ...s Have="1"
   ..Q:Have=0
   ..if PrescNoStr=""  s PrescNoStr=PrescNo
   ..else  s PrescNoStr=PrescNoStr_"^"_PrescNo
    q PrescNoStr
}

ClassMethod GetPrescEventLogInfo(AdmId)
{
   s ret=""
   s papmiId=$P(^PAADM(AdmId),"^",1)
   s papmiNo=$P(^PAPER(papmiId,"PAT",1),"^",1)
   s SecretCode=""
   s PAPMISecretLevelDR=$p($g(^PAPER(papmiId,"DHC")),"^",30)
   if PAPMISecretLevelDR'="" s SecretCode=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),2)

   s ret=papmiNo_"^"_AdmId_"^"_SecretCode
   q ret
}

ClassMethod GetCTLocPrintTypeID(LocId As %String) As %String
{
   Q:(LocId="") ""
   q $g(^UDHCPrescriptPrintConfig("PrintConfig",LocId))
}

/// 根据处方号获取医嘱类型
/// 1 西药 2 中成药 3 草药 5 精神二类药
/// w ##class(web.DHCDocPrescript).GetPrescTypeByPrescNum("O181023000005")
ClassMethod GetPrescTypeByPrescNum(presc As %String, CurLogonHosp As %String = "") As %String
{
	s PHPrescType=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q PHPrescType
	s prescitm=0
	for  s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,prescitm)) Q:((prescitm="")||(PHPrescType'=""))  d
	.Q:prescitm=""
	.s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
	.s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
	.q:prescdrgform=""
	.s statcode="V"
	.s statDesc="核实"
	.s TtemStat=$P($G(^OEORD(prescord,"I",prescitm,1)),"^",13) ;OEORI_Billed
	.i TtemStat'="" d
	..s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	..s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2)
	.q:statcode'="V"
	.s ItemCatRowid=$p($g(^ARCIM(+prescitmmast,$p(prescitmmast,"||",2),1)),"^",10)
	.s RowID=""
	.s:ItemCatRowid'="" RowID=$P($G(^ARC("IC",ItemCatRowid)),"^",8)
	.s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	.Q:OrderType'="R"
	.s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatRowid,CurLogonHosp,prescitmmast)
	q PHPrescType
}

/// 根据处方号获取处方上的收费的情况
/// w ##class(web.DHCDocPrescript).GetBilledByPrescNo("O181019000006")
ClassMethod GetBilledByPrescNo(presc As %String) As %String
{
   
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s OrdBilled=""
	s prescitm=0
	for  s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,prescitm)) Q:((prescitm="")||(OrdBilled'=""))  d
	.Q:prescitm=""
	.s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
	.s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
	.q:prescdrgform=""
	.s statcode="V"
	.s statDesc="核实"
	.s TtemStat=$P($G(^OEORD(prescord,"I",prescitm,1)),"^",13) ;OEORI_Billed
	.i TtemStat'="" d
	..s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	..s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2)
	.q:statcode'="V"
	.s OrdBilled=##class(web.DHCBillInterface).IGetOrdItmBilled(prescord_"||"_prescitm)
	q OrdBilled
}

/// 获取血糖分组信息
ClassMethod GetOrdBloogSugarGroup(ARCIMRowID As %String, HospDr As %String) As %String
{
	s OrdBloogSugarGroup=""
	s OrdBloodSugarGroupId=$o(^User.DHCDocOrdBloodSugarGroupI("LabOrdArcimDr",HospDr,ARCIMRowID,""))
	if (OrdBloodSugarGroupId'="") {
	s OrdBloogSugarGroup=$lg(^User.DHCDocOrdBloodSugarGroupD(OrdBloodSugarGroupId),2) //所属血糖分组
	}
	Q OrdBloogSugarGroup
}

/// 获取默认接受科室
ClassMethod recloc(arcim1 As %String, locord As %String) As %String [ Private ]
{
	;,categ,subcat)
	;k ^zleon ;s ^zleon=$g(arcim1)_"^"_$g(locord)
	n SQLCODE n loc,subcat,categ,arcim
	s arcim=$p(arcim1,"||")
	&SQL(SELECT ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR INTO :subcat,:categ
	FROM SQLUser.ARC_ItmMast WHERE ARCIM_RowId = :arcim1)
	q:SQLCODE ""
	;
	&SQL(SELECT ARCRL_RecLoc_DR INTO :loc FROM SQLUser.ARC_ItmRecLoc
	WHERE ARCRL_ARCIMSub = :arcim AND ARCRL_OrdLoc_DR = :locord AND ARCRL_Function = "Execute")
	q:'SQLCODE loc
	;
	&SQL(SELECT ARCRL_RecLoc_DR INTO :loc FROM SQLUser.ARC_ItmRecLoc
	WHERE ARCRL_ARCIMSub = :arcim AND ARCRL_OrdLoc_DR IS NULL AND ARCRL_Function = "Execute")
	q:'SQLCODE loc
	;
	&SQL(SELECT RL_RecLoc_DR INTO :loc FROM SQLUser.ARC_ItemCatRecLoc
	WHERE RL_ParRef = :subcat AND RL_OrdLoc_DR = :locord AND RL_Function = "Execute")
	q:'SQLCODE loc
	;         ;
	&SQL(SELECT RL_RecLoc_DR INTO :loc FROM SQLUser.ARC_ItemCatRecLoc
	WHERE RL_ParRef = :subcat AND RL_OrdLoc_DR IS NULL AND RL_Function = "Execute")
	q:'SQLCODE loc
	;         ;
	&SQL(SELECT RL_RecLoc_DR INTO :loc FROM SQLUser.OEC_OrdCatRecLoc
	WHERE RL_ParRef = :categ AND RL_OrdLoc_DR = :locord AND RL_Function = "Execute")
	q:'SQLCODE loc
	;
	&SQL(SELECT RL_RecLoc_DR INTO :loc FROM SQLUser.OEC_OrdCatRecLoc
	WHERE RL_ParRef = :categ AND RL_OrdLoc_DR IS NULL AND RL_Function = "Execute")
	q $g(loc)
	;
	;&SQL(SELECT CTLOC_DispLoc_DR
	;INTO :loc
	;FROM CT_Loc
	;WHERE CTLOC_RowId = :locord)
	q $g(loc)
}

/// 得到外部代码维护的接收位置
ClassMethod GetTestCodeRecLoc(arcim As %String) As %String
{
	Quit:$g(arcim)="" ""
	Quit:'$d(^ARCIM(+arcim,1,"EXT")) ""
	s TestCodeRecLoc=""
	s Ext=0
	for {
		Set Ext=$o(^ARCIM(+arcim,1,"EXT",Ext)) Quit:$g(Ext)=""
		Set ExtFromDat=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",1)
		Set ExtToDat=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",2)
		continue:(ExtFromDat'="")&(ExtFromDat>+$h)
		continue:(ExtToDat'="")&(ExtToDat<+$h)
		Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
		Set ExtRecLoc=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",8)
		Set TestCodeRecLoc=ExtRecLoc
		quit
	}
	
	Quit TestCodeRecLoc
}

/// 根据外部代码中代码分标本,此方法仅用于分标本用,V8.1.1不使用此配置，使用外部代码维护的接收位置区分
ClassMethod GetTestCode(arcim As %String) As %String
{
	;s CFTestCodeGenLabNo=$$getconfignode^DHCDocConfig("TestCodeGenLabNo")
	;Q:CFTestCodeGenLabNo'=1 ""
	
	Quit:$g(arcim)="" ""
	Quit:'$d(^ARCIM(+arcim,1,"EXT")) ""
	s ExtCode=""
	s Ext=0
	for {
		Set Ext=$o(^ARCIM(+arcim,1,"EXT",Ext)) Quit:$g(Ext)=""
		Set ExtFromDat=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",1)
		Set ExtToDat=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",2)
		continue:(ExtFromDat'="")&(ExtFromDat>+$h)
		continue:(ExtToDat'="")&(ExtToDat<+$h)
		Set ExtCode=$p(^ARCIM(+arcim,1,"EXT",Ext),"^",4)
		quit
	}
	
	Quit ExtCode
}

/// 生成检验号
ClassMethod CreatLabEpisodeNo(row As %String, arcim As %String) As %String [ Private ]
{
	//n (row,arcim)
	s err=$$udfepisno($g(row),$g(arcim)) q:err'="" err
	;check configuration
	s str=$g(^CF("PATCF",1,7)),method=$p(str,"^"),cnttype=$p(str,"^",2),length=$p(str,"^",3)
	;default method - system counter
	s:method="" method="S"
	;if counter type not setup , use system counter
	i method="U",'cnttype s method="S"
	i method="D" {
		s:'length length=5
		s ind=..next("^EPIS(+$h)")
		s dt=$zd($h)
		
		s month=$p(dt,"/")
		s day=$p(dt,"/",2)
		//溢出位数
		s overflowNum=$E(ind,1,$L(ind)-length)
		if (overflowNum'=""){
			//日期逢3进位,理论单日最大值扩展到24倍
			s day=(overflowNum#3)*31+day
			s month=(overflowNum\3)*12+month
			
			;;12*(计数器十万位值)+当前月份
			//s month=($E(ind,1,$L(ind)-length)*12)+month
		}
		s month=..LPAD2(month,"0",2)
		s day=..LPAD2(day,"0",2)
		;s ind=$E(ind,$L(ind)-length+1,$L(ind))
		s dt=$e($p(dt,"/",3),3,4)_month_day,prno=dt_..LPAD2(ind,"0",length)
	}elseif (method="S"){
		s prno=..next("^EPIS(0)")
	}elseif (method="U") {
		//为防止^COUNT("CNTTYPE",cnttype)在项目组经常出现异常锁定的问题，特修改计数器
		s s1=$g(^COUNT("CNTTYPE",cnttype)),pref=$p(s1,"^",2),suf=$p(s1,"^",3)
		s len=$p(s1,"^",4)
		s cnt=..next("^COUNT(""CNTTYPE"","_cnttype_",""No"")")
		s prno=pref_..LPAD2(cnt,"0",len)_suf
	}
	q prno
udfepisno(oeitm,arcim) ;get UDF lab epis number
	s err=$$valid^MVBSSVAL("Generate Episode Number",oeitm,arcim,"")
	q:err ""
	q $g(PLIST(1))
}

/// 生成处方号
/// copy from PRNO1
ClassMethod CreatPrNo(Date As %String, adm As %String, loc As %String, arcim As %String = "", row As %String = "", DMJPrescNo As %String = "") As %String [ Private, PublicList = (prefix, Date) ]
{
	s billver=$p($g(^CF("SM",1)),"^",12) 
	;for authority items , use different number
	i ..auth($g(arcim),row)'="" q ..authno()
	i $G(DMJPrescNo)="1" q $$MJPRNO1(Date)
	s admtype=$p($g(^PAADM(+adm)),"^",2)
	;fist try to find prescription for admission/location if oe configuration = one prescription for receiving location
	i $p($g(^CF("OE",1)),"^",35)="RL" d  q:prno'="" prno
	.s err=..getpresc(adm,loc),prno=$g(PLIST(1))
	;s err=..udfprescno(loc,admtype,Date)
	;q:err'="" err
	s:'$g(Date) Date=+$h
	s ind=..next("^PRESC(Date)"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	s num1=yy+2#10
	s yy1=$e(yy,3,4)
	s num2=$e("ABCDEFGHIJKL",mm)
	s dt=$e($tr(dt1,"/"),1,4)
	s prno=dt_$e(100000+ind,2,6)
	s prno=admtype_yy1_dt_$e(1000000+ind,2,7)
	i billver="M" s prno=admtype_num1_num2_$p(dt1,"/",2)_$e(1000000+ind,2,7)
	s prno=$$checkPrno1Repeat(prno)
	q prno
	
MJPRNO1(Date)
	s prefix="MJ"
	s:'$g(Date) Date=+$h
	s ind=..next("^PRESC(prefix,Date)"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	s yy1=$e(yy,3,4)
	s dt=$e($tr(dt1,"/"),1,4)
	s prno=prefix_yy1_dt_$e(1000000+ind,3,7)
	s prno=$$checkPrno1Repeat(prno)
	q prno

checkPrno1Repeat(paramprno)
	q:paramprno="" ""
	s PrescRowid=$O(^PAQUE1(0,"PrescNo",paramprno,""))
	i PrescRowid'="" {
		q ..CreatPrNo(Date,adm,loc,arcim, row, DMJPrescNo)
	}
	q paramprno
}

/// 该方法已弃用，与CreatPrNo方法内容一致
ClassMethod PRNO(Date As %String, adm As %String, loc As %String, arcim As %String = "", row As %String = "", DMJPrescNo As %String = "") As %String [ Private, PublicList = (prefix, Date) ]
{
	;s ^zhou("PrescNo")=Date_"^"_adm_"^"_loc
	//n (Date,adm,loc,arcim,row,DMJPrescNo)
	s billver=$p($g(^CF("SM",1)),"^",12) 
	;for authority items , use different number
	i ..auth($g(arcim),row)'="" q ..authno()
	i $G(DMJPrescNo)="1" q $$MJPRNO(Date)
	s admtype=$p($g(^PAADM(+adm)),"^",2)
	;fist try to find prescription for admission/location if oe configuration = one prescription for receiving location
	i $p($g(^CF("OE",1)),"^",35)="RL" d  q:prno'="" prno
	.s err=$$getpresc^MVBPAQUE(adm,loc),prno=$g(PLIST(1))
	s err=..udfprescno(loc,admtype,Date)
	q:err'="" err
	s:'$g(Date) Date=+$h
	s ind=..next("^PRESC(Date)"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	s num1=yy+2#10
	s yy1=$e(yy,3,4)
	s num2=$e("ABCDEFGHIJKL",mm)
	s dt=$e($tr(dt1,"/"),1,4)
	s prno=dt_$e(100000+ind,2,6)
	s prno=admtype_yy1_dt_$e(1000000+ind,2,7)
	i billver="M" s prno=admtype_num1_num2_$p(dt1,"/",2)_$e(1000000+ind,2,7)
	s prno=$$checkPrnoRepeat(prno)
	q prno
checkPrnoRepeat(paramprno)
	q:paramprno="" ""
	s PrescRowid=$O(^PAQUE1(0,"PrescNo",paramprno,""))
	i PrescRowid'="" {
		q ..PRNO(Date,adm,loc,arcim, row, DMJPrescNo)
	}
	q paramprno
MJPRNO(Date)
	s prefix="MJ"
	s:'$g(Date) Date=+$h
	s ind=..next("^PRESC(prefix,Date)"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	s yy1=$e(yy,3,4)
	s dt=$e($tr(dt1,"/"),1,4)
	s prno=prefix_yy1_dt_$e(1000000+ind,3,7)
	s prno=$$checkPrnoRepeat(prno)
	q prno
}

/// generate authority presc number
ClassMethod authno() As %String [ Private ]
{
	n
	s $p(a,"0",8)=""
	s cnt=$zincr(^COUNT("AUTHOR"))
	s sum=0
	f j=1:1:$l(cnt) s sum=sum+$e(cnt,j)
	s sum=sum#9
	s cnt=cnt_sum
	i $l(cnt)<8 s cnt=$e(a,1,8-$l(cnt))_cnt
	q cnt
}

/// Description
ClassMethod udfprescno(loc, admtype, Date) As %String [ Private ]
{
	s err=$$valid^MVBSSVAL("Generate Transaction Number",loc_"^"_Date_"^"_admtype,"PRESC","")
	q:err ""
	q $g(PLIST(1))
}

/// check if item requires separate presc per item
ClassMethod auth(arcim As %String, row As %String = "") As %String [ Private ]
{
	;only australian billing
	s billver=$p($g(^CF("SM",1)),"^",12)
	q:billver'="A" ""
	s drgform=$p($g(^ARCIM(+arcim,1,1)),"^",12) 
	q:'drgform ""
	s categ=$p($g(^PHCD(+drgform,1)),"^",4)
	q:'categ ""
	s desc=$p($g(^PHCPO(categ)),"^",2)
	s desc=$$UPPER^SSUTIL4(desc)
	i desc["AUTHORITY" q ("^"_$g(row))
	q ""
}

/// Description
ClassMethod getpresc(adm As %String, loc As %String) As %String [ Private ]
{
	 k PLIST s found=0,prescfound=0
	s que=0 f  s que=$o(^PAQUE1(0,"QUE1_PAADM_DR",+adm,que)) q:que=""  q:found  d
	.s s=$g(^PAQUE1(que)),loc1=$p(s,"^",4),prescfound=1
	.q:loc-loc1  s found=1,PLIST(1)=$p(s,"^",14)
	s PLIST=$o(PLIST(""),-1)
	i 'found,'prescfound q 100
	i 'found,prescfound q 61
	q 0
}

/// 若要在next使用变量，请在调用方法处定义PublicList,共享变量的作用域
ClassMethod next(glo) As %String [ CodeMode = expression, Private ]
{
$I(@glo)
}

/// 自增对应的global节点,为防止glo中引用了其他文件的变量，只能把该方法设置为expression
/// 按照指定的长度，补全STRING
/// 如果字符串本身超过指定长度，优先去除最后一位
ClassMethod LPAD1(STRING, SUB, LENGTH) As %String
{
	s RES=""
	S STRING=$G(STRING),LENGTH=$G(LENGTH)
	S:'$G(LENGTH) LENGTH=8
	S $P(RES,SUB,LENGTH)=SUB
	Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,1,LENGTH)
}

/// 按照指定的长度，补全STRING
/// 如果字符串本身超过指定长度，优先去除第一位
ClassMethod LPAD2(STRING, SUB, LENGTH) As %String
{
	s RES=""
	S STRING=$G(STRING),LENGTH=$G(LENGTH)
	S:'$G(LENGTH) LENGTH=8
	S $P(RES,SUB,LENGTH)=SUB
	Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,$L(STRING)-LENGTH+1,$L(STRING))
}

/// check if item is linked to stock
/// 是否关联了库存项
ClassMethod stock(arcim As %String) As %String [ Private ]
{
	;0-no,1-yes
	i $p($g(^ARCIM(+arcim,1,1)),"^",12) q 1
	i $d(^INCI(0,"ARCIM_DR",+arcim)) q 1
	q 0
}

/// check if prescription exists
ClassMethod exist(prno As %String, adm As %String) As %String [ Private ]
{
	;1-yes,0-no
	q:'adm 0
	q:prno="" 0
	s que=0,found=0 f  s que=$o(^PAQUE1(0,"PrescNo",prno,que)) q:que=""  q:found  d
	.q:$p($g(^PAQUE1(que)),"^",3)-adm
	.s found=1
	q found
}

/// check status of queue
ClassMethod newstat(prno As %String) As %Status [ Private ]
{
	s err=$$updqueue^MVBPAQUE(prno)
 	q
}

/// 获取医嘱大类类型
ClassMethod GetItemCat(arcim As %String) As %String
{
	q:arcim="" ""
	s ItemCatDR=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)	
	q OrderType
}

/// 获取医嘱类型代码
ClassMethod GetPriorCode(row As %String) As %String
{
	s prior=$p($g(^OEORD(+row,"I",+$p(row,"||",2),1)),"^",8)
	q $p($g(^OECPR(+prior)),"^")
}

/// ;获取当前数据的处方配置数据
/// PLIST与OEORIRowId选填一项内容即可
ClassMethod GetSplitPrescTypeDetails(EpisodeID As %String, ByRef PLIST, OEORIRowId As %String = "") As %String
{
	//n (EpisodeID,PLIST)
	s OEORIUserHospDr=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	if $O(PLIST(""))'=""{
		s PrescStr=$G(PLIST("CM"))			//这个节点没找到对应的初始化位置，但是实际草药也不会走这个方法。
		s ArcimRowid=$G(PLIST(4))
		s PrescCookMode=$P(PrescStr,"^",5)
	}elseif (OEORIRowId'=""){
		s ArcimRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1)),"^",2)
		s PrescNo=$p(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),1),"^",14)
		s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
		i PrescRowid'="" {
			s PrescCookMode=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",15)
			#; if (PrescCookMode'="") {
			#; 	s PrescCookModeDesc=$P(^DHCDocConfig("HospDr_"_OEORIUserHospDr,"CookMode",PrescCookMode),"^",2)
			#; }
		}
	}else{
		q ""
	}
	Q:$G(ArcimRowid)="" ""
	s CNMedAppendItemStr="",CMPrescTypeLinkFeeStr=""
	s HospCodeNode="HospDr_"_OEORIUserHospDr
	s PrescTypeCode=0
	for{
		s PrescTypeCode=$O(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",PrescTypeCode))
		q:PrescTypeCode=""
		s PrescTypeActive=$P(^DHCDocConfig(HospCodeNode,"CMPrescTypeList",PrescTypeCode),"^",2)
		continue:(PrescTypeActive="N")
		//s PrescTypeItemCat=##class(web.DHCDocConfig).GetConfigNodeNew2(PrescTypeCode,OEORIUserHospDr)

		//煎药方式附加费用
		s CNMedAppendItem=..%GetConfig1(PrescTypeCode,"CNMedAppendItem",OEORIUserHospDr)
		//处方类型关联费用列表
		s CMPrescTypeLinkFee=..%GetConfig1(PrescTypeCode,"CMPrescTypeLinkFee",OEORIUserHospDr)
		s CNMedAppendItemStr=CNMedAppendItemStr_"^"_CNMedAppendItem
		s CMPrescTypeLinkFeeStr=CMPrescTypeLinkFeeStr_"^"_CMPrescTypeLinkFee
	}
	//加工费
	s CookModeChargeStr=""
	s subNode=""
	for {
		s subNode=$o(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",subNode))
		q:subNode=""
		s LoopArcimRowid="" 
		for {
			s LoopArcimRowid=$o(^DHCDocConfig(HospCodeNode,"PrescTypeCharge",subNode,LoopArcimRowid))
			q:LoopArcimRowid=""
			s CookModeChargeStr=CookModeChargeStr_"^"_LoopArcimRowid
		}
	}
		
	s SplitPrescTypeCode=""
	;如果是附加材料则算成中草药
	if (("^"_CNMedAppendItemStr_"^"_CMPrescTypeLinkFeeStr_"^"_CookModeChargeStr_"^")[("^"_ArcimRowid_"^")){
		s SplitPrescTypeCode="CNMedItemCat"
	}
	if (SplitPrescTypeCode'=""){
		q $$GetSplitPrescTypeSetting("CNMedItemCat",OEORIUserHospDr)   
	}
	s SplitPrescTypeCode=$$GetSplitPrescTypeCode(ArcimRowid,OEORIUserHospDr)
	q $$GetSplitPrescTypeSetting(SplitPrescTypeCode,OEORIUserHospDr)

GetSplitPrescTypeSetting(Code,HospDr)
	q:(Code="") ""
	if (HospDr'="") {
		s HospCodeNode="HospDr_"_HospDr
		s Details=$G(^DHCDocConfig(HospCodeNode,"SplitPrescType",Code,"Details"))
	}else{
		s Details=$G(^DHCDocConfig("SplitPrescType",Code,"Details"))
	}
	s Setting=Code_"^"_Details
	q $G(Setting)
GetSplitPrescTypeCode(ArcimRowid,HospDr)
	s PrescTypeCode=""
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	Q:ItemCatRowid="" PrescTypeCode
	s PoisonRowid=$$GetDrgFormPoison^DHCDocOrderCommon(ArcimRowid)
	if (HospDr'="") {
		s HospCodeNode="HospDr_"_HospDr
		s LoopCode=""
		for {
			s LoopCode=$O(^DHCDocConfig(HospCodeNode,"SplitPrescType",LoopCode))
		    q:(LoopCode="")
		    s ItemCatStr=$G(^DHCDocConfig(HospCodeNode,"SplitPrescType",LoopCode,"ItemCat"))
		    s POList=$G(^DHCDocConfig(HospCodeNode,"SplitPrescType",LoopCode,"POList"))
		    
		    i ("^"_ItemCatStr_"^")[("^"_ItemCatRowid_"^"){
			    s PrescTypeCode=LoopCode
			    q
		    }
			i (("^"_POList_"^")[("^"_PoisonRowid_"^"))&&(POList'=""){
			    s PrescTypeCode=LoopCode
			    q
		    }   
		}
	}else{
		s LoopCode=""
		for {
			s LoopCode=$O(^DHCDocConfig("SplitPrescType",LoopCode))
		    q:(LoopCode="")
		    s ItemCatStr=$G(^DHCDocConfig("SplitPrescType",LoopCode,"ItemCat"))
		    s POList=$G(^DHCDocConfig("SplitPrescType",LoopCode,"POList"))
		    
		    i ("^"_ItemCatStr_"^")[("^"_ItemCatRowid_"^"){
			    s PrescTypeCode=LoopCode
			    q
		    }
			i (("^"_POList_"^")[("^"_PoisonRowid_"^"))&&(POList'=""){
			    s PrescTypeCode=LoopCode
			    q
		    }   
		}
	}    
	q PrescTypeCode
}

/// 获取当前医嘱的对应的处方类型信息
/// 该方法与本类中的routine：GetLinkOrdInfo处理逻辑一致
ClassMethod GetLinkOrdInfo(row) As %String
{
   ;皮试或者毒麻都单独分处方，硬代码，与配置无关
   s SkinTestFlag=0
   s SkinTest="N"
   s AdmDr=$P(^OEORD(+row),"^",1)
   s AdmLocHospDr=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmDr)
   
   ;皮试用法
   s SkinTestInstr=##Class(web.DHCDocConfig).GetConfigNode("SkinTestInstr",AdmLocHospDr)
   if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
   	///code^处方药品个数^单独分方标识^
	///成组医嘱以此类型为主要属性(成组医嘱包含多个处方类型，不勾选默认按照主医嘱处方类型分处方)^
	///单独走MJ开头处方号(用于毒麻处方)^
	///单独分处方(成组医嘱拆分分方，同处方类型同处方)
   s SplitPrescTypeDetails=..GetSplitPrescTypeDetails(AdmDr,"",row)
   if ($P(SplitPrescTypeDetails,"^",3)=1)||($P(SplitPrescTypeDetails,"^",6)=1){
	  q SkinTest_$C(1)_SkinTestFlag_$C(1)_SplitPrescTypeDetails
   }
   s LinkOrderItemRowId=$p($g(^OEORD(+row,"I",$p(row,"||",2),11)),"^",39)
   i LinkOrderItemRowId="" {
	   s LinkOrderItemRowId=row
   }
   s OrderInstrRowid=$p($g(^OEORD(+LinkOrderItemRowId,"I",$p(LinkOrderItemRowId,"||",2),2)),"^",7)
   s OrderSkinTest=$p($g(^OEORD(+LinkOrderItemRowId,"I",$p(LinkOrderItemRowId,"||",2),5)),"^",2)
   if (OrderSkinTest="Y") {
	  s SkinTestFlag=1
	  if (OrderInstrRowid'="")&&(SkinTestInstr[("^"_OrderInstrRowid_"^")){
	    s SkinTestFlag=2
	    s SkinTest="Y"
	  }
   }
   
   
   //成组医嘱默认按照主医嘱处方类型设置
   s SplitPrescTypeDetails=..GetSplitPrescTypeDetails(AdmDr,"",LinkOrderItemRowId)
   s Sub=0
   for {
     s Sub=$O(^OEORDi(0,"OEORI",+row,LinkOrderItemRowId,Sub))
     q:Sub=""
     s SubInstrRowid=$p($g(^OEORD(+row,"I",Sub,2)),"^",7)
     s SubSkinTest=$p($g(^OEORD(+row,"I",Sub,5)),"^",2)
     s SkinTestActionCode=""
     if (SubSkinTest="Y") {
	     s SkinTestFlag=1
	     if (SubInstrRowid'="")&&(SkinTestInstr[("^"_SubInstrRowid_"^")){
	       s SkinTestFlag=2
	       s SkinTest="Y"
	     }
     }
     s SubSplitPrescTypeDetails=..GetSplitPrescTypeDetails(AdmDr,"",(+row)_"||"_Sub)
     //成组以此为主要属性
     if ($P(SubSplitPrescTypeDetails,"^",4)=1){
	 	s SplitPrescTypeDetails=SubSplitPrescTypeDetails
	 }
   }
   q SkinTest_$C(1)_SkinTestFlag_$C(1)_SplitPrescTypeDetails
}

/// 根据处方号获取处方类型
/// w ##class(web.DHCDocPrescript).GetPrescTypeByPrescNo("O181023000005")
ClassMethod GetPrescTypeByPrescNo(presc As %String, CurLogonHosp As %String = "") As %String
{
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	Q:prescord="" ""
	k CatList
	s prescitm=0 for {
		s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,prescitm)) Q:prescitm=""
		s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
		continue:prescitmmast=""
		s ItemCatRowid=$p($g(^ARCIM(+prescitmmast,$p(prescitmmast,"||",2),1)),"^",10)
		s CatList(ItemCatRowid)=""
	}
	s HospNode="HospDr_"_CurLogonHosp
	s PrescTypeCode="" for{
		s PrescTypeCode=$O(^DHCDocConfig(HospNode,"SplitPrescType",PrescTypeCode)) Q:PrescTypeCode=""
		s ItemCatStr=$G(^DHCDocConfig(HospNode,"SplitPrescType",PrescTypeCode,"ItemCat"))
		s NotContainFlag=0
		s ItemCatRowid=0 for{
			s ItemCatRowid=$O(CatList(ItemCatRowid)) Q:ItemCatRowid=""
			if ("^"_ItemCatStr_"^")'[("^"_ItemCatRowid_"^"){
				s NotContainFlag=1
				Q
			}
		}
		Q:'NotContainFlag
	}
	Q PrescTypeCode
}

}
