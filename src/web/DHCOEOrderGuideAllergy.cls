/// 名称:     web.DHCOEOrderGuideAllergy
/// 描述:     医嘱录入界面引导皮试录入界面
/// 编写者:  谭吉善
/// 编写日期: 2020.03.23
Class web.DHCOEOrderGuideAllergy Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*
药房提供的数据接口
w ##class(PHA.FACE.OUT.Com).GetAlgStrByArcim("1074||1",+$h) -- 返回过敏源id串
w ##class(PHA.FACE.OUT.Com).GetSkinTestList("24^25^26").Next() -- 根据过敏源id串获取所有的皮试药品配置信息
w ##class(PHA.FACE.OUT.Com).GetSkinTestInfo("1074||1").Next() -- 医嘱项获取当前医嘱项维护的右上角数据，如果是根据通用名维护的，就返回当前通用名的数据。如果是两种都用，都返回（虽然现在是控制了只能维护一种，但是这个接口不用考虑这个控制）
w ##class(PHA.FACE.OUT.Com).GetSkinTestInfoRela("1074||1").Next() -- 跟进皮试用药获取对应的治疗用药
*/
/// 用于初始化引导皮试录入界面的simplydatagrid
/// SkinMsg:控制级别^描述^Table名称^对应的记录ID
/// w ##Class(web.DHCOEOrderGuideAllergy).GetGuideAllergyTableJson(35,"2354||1","2020-06-29 15:54:03","")
ClassMethod GetGuideAllergyTableJson(EpisodeID As %String, ArcimRowId As %String, OrderStartDateStr As %String, ByRef SkinMsg As %String = "") As %String
{
	//s ^tan("GetGuideAllergyTableJson")=EpisodeID_","_ArcimRowId_","_OrderStartDateStr
	s OrderRowid=$o(^OEORD(0,"Adm",+EpisodeID,""))
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
	s OrderStartDate=$P(OrderStartDateStr," ",1)
	s OrderStartTime=$P(OrderStartDateStr," ",2)
	Set langid=..%LanguageID()
	Kill SkinMsgList
	s Stream=##class(%Stream.GlobalCharacter).%New()
	///根据药房的皮试药品维护，获取皮试控制串,
	s SkinControlInfo=..GetArcimSkinControlInfo(ArcimRowId,OrderStartDate,HospitalDR)
	/*
	if (SkinControlInfo=""){
		d Stream.Write("[]")
		q Stream.Read()
	}
	*/
	s SkinValidTime=$P(SkinControlInfo,"^",1)		;皮试有效时间
	i SkinValidTime="" s SkinValidTime=72
	s $P(SkinControlInfo,"^",1)=SkinValidTime
	s SkinDesensitFlag=$P(SkinControlInfo,"^",2)	;允许脱敏
	s SkinNoTestFlag=$P(SkinControlInfo,"^",3)		;允许免试
	s SkinExceptionFlag=$P(SkinControlInfo,"^",4)	;控制例外
	s DefNoTest=$P(SkinControlInfo,"^",7)			;默认免试
	/*
	根据配置的相关医嘱项内容，初始化医嘱列表
		TableArr("SkinList")--皮试医嘱列表
		TableArr("TreatList")--治疗医嘱列表
	*/
	Kill TableArr
	d ..BuildSkinOrdList(EpisodeID,ArcimRowId,OrderStartDateStr,SkinControlInfo,.TableArr)
	
	d Stream.Write("{""GuideAllergyTable"":[")
	s tableCount=0
	///先输出皮试记录
	if ($D(TableArr("SkinList"))){
		d:tableCount>0 Stream.Write(",")
		s tableCount=tableCount+1
		s colDefine=##class(DHCDoc.Util.MapIndex).%New()
		s col="OrderSttDateStr:医嘱开始时间,OrderName:医嘱名称,SkinInfo:皮试结果,SkinAbnorm:SkinAbnorm,SkinTestDateStr:皮试结果时间,SkinTestUser:操作人,OrderDept:开单科室,ID:ID"
		f i=1:1:$Length(col,",") {
			d colDefine.add($P($P(col,",",i),":",1))
			s colDefine.map($P($P(col,",",i),":",1),"Type")=10
		}
		d Stream.Write("{")
		d Stream.Write(##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine))
		d Stream.Write(",""id"":""SkinList_Table""")
		s SkinTilte="皮试记录"
		s SkinTilte=..%Translate("oeorder.guideallergy.csp",SkinTilte)
		d Stream.Write(",""title"":"""_SkinTilte_"""")
		d Stream.Write(",""titleClass"":""normal-head""")
		d Stream.Write(",""rows"":[")
		s rowCount=0
		s SttDateStr=""
		for {
			s SttDateStr=$O(TableArr("SkinList",SttDateStr),-1)
			q:(SttDateStr="")
			s OEORIRowid=""
			for {
				s OEORIRowid=$O(TableArr("SkinList",SttDateStr,OEORIRowid))
				q:(OEORIRowid="")
				d:rowCount>0 Stream.Write(",")
				s rowCount=rowCount+1
				s LoopEpisodeID=$P(^OEORD(+OEORIRowid),"^",1)
				s LoopAdmType=$p(^PAADM(LoopEpisodeID),"^",2)

				s Details=$G(TableArr("SkinList",SttDateStr,OEORIRowid))
				s ValidTimeFlag=$P(Details,"^",1)
				s OrderRowid=$P(OEORIRowid,"||",1),child=$P(OEORIRowid,"||",2)
				s OrderSttDate=$p(^OEORD(OrderRowid,"I",child,1),"^",9)
				s OrderSttTime=$p(^OEORD(OrderRowid,"I",child,1),"^",10)
				s OrderSttDateStr=..%ZD(OrderSttDate)_" "_..%ZT(OrderSttTime,2)
				s ItmMastDR = $p(^OEORD(OrderRowid,"I",child,1),"^",2)
				s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
				s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
				s OEORIActionDesc="",SkinInfo=""
				s OEORIActionDR=$p($g(^OEORD(OrderRowid,"I",child,11)),"^",21)
				if (OEORIActionDR'=""){
					s OEORIActionDesc=$p($g(^OEC("ACT",OEORIActionDR)),"^",2)_"&nbsp"
				}
				s OEORIActionDesc =##class(User.OECAction).GetTranByDesc("ACTDesc",OEORIActionDesc,langid)
				s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(OrderRowid,child)
				if (SkinAbnorm="Y"){
					s SkinMsgList(1,"ID",OEORIRowid)=1
					s SkinInfo="<font color=red>"_OEORIActionDesc_..%Translate("oeorder.guideallergy.csp","阳性")_"</font>"
				}elseif (SkinAbnorm="N"){
					s SkinMsgList(1,"ID",OEORIRowid)=2
					s SkinInfo="<font color=green>"_OEORIActionDesc_..%Translate("oeorder.guideallergy.csp","阴性")_"</font>"
				}else{
					s SkinMsgList(1,"ID",OEORIRowid)=3
				}
				if (ValidTimeFlag=0){
					k SkinMsgList(1,"ID",OEORIRowid)
				}
				s OEOREChildsub=$O(^OEORD(OrderRowid,"I",child,"X",0))
				s SkinTestDateStr="",SkinTestUser=""
				if (OEOREChildsub'=""){
					if (LoopAdmType="I"){
						//护理组
						s SkinTestCTCPDR=$P($G(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub,"NUR")),"^",13)
						s SkinTestDate=$P($G(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub,"NUR")),"^",14)
						s SkinTestTime=$P($G(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub,"NUR")),"^",15)
						if (SkinTestDate'=""){
							s SkinTestDateStr=..%ZD(SkinTestDate)_" "_..%ZT(SkinTestTime,2)
						}
						if (SkinTestCTCPDR'=""){
							s SkinTestUser=$P(^CTPCP(SkinTestCTCPDR,1),"^",2)
							Set SkinTestUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",SkinTestUser,langid)
						}
					}else{
						//新产品组
						s DHCOriId=$o(^DHCORDItem(0,OrderRowid_"||"_child,""))
						i DHCOriId'="" {
							s SkinCtpcpDr = $p(^DHCORDItem(DHCOriId),"^",2)
							if (SkinCtpcpDr'=""){
								s SkinTestUser=$P(^CTPCP(SkinCtpcpDr,1),"^",2)
								Set SkinTestUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",SkinTestUser,langid)
							}
							s SkinTestDate=$p(^DHCORDItem(DHCOriId),"^",3)
							s SkinTestTime=$p(^DHCORDItem(DHCOriId),"^",4)
							if (SkinTestDate'=""){
								s SkinTestDateStr=..%ZD(SkinTestDate)_" "_..%ZT(SkinTestTime,2)
							}
						}
						
					}
				}
				s OrderDept=""
				s OrderDeptDr=$p(^OEORD(OrderRowid,"I",child,7),"^",2)
				if (OrderDeptDr'="") {
					s OrderDept=$P(^CTLOC(OrderDeptDr),"^",2)
					s OrderDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderDept,langid)
				}
				s list=$LB(OrderSttDateStr,OrderName,SkinInfo,SkinAbnorm,SkinTestDateStr,SkinTestUser,OrderDept,OEORIRowid)
				d Stream.Write(##class(DHCDoc.Util.FormatData).GetJsonList(colDefine,list))
			}
		}
		d Stream.Write("]")
		d Stream.Write("}")
	}
	///输出治疗记录
	kill plist
	if ($D(TableArr("TreatList"))){
		
		s SttDateStr=""
		for {
			s SttDateStr=$O(TableArr("TreatList",SttDateStr))
			q:(SttDateStr="")
			
			s OEORIRowid=""
			for {
				s OEORIRowid=$O(TableArr("TreatList",SttDateStr,OEORIRowid))
				q:(OEORIRowid="")
				
				s OrderRowid=$P(OEORIRowid,"||",1),child=$P(OEORIRowid,"||",2)
				continue:('$D(^OEORD(OrderRowid,"I",child,1)))
				s str1=$G(^OEORD(OrderRowid,"I",child,1))
				s ItmMastDR = $p(str1,"^",2)
				s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
				s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
				continue:(OrderType'="R")
				s itemStatDr = $p(str1,"^",13) 
				s TItemStatCode=""
				s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
				s scope=1	;1 全部   非作废, 
				continue:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,OrderRowid,child,"0")
				
				s (OrderLastExeDateStr,OrderName,DoseQtyInfo,InstrDesc,PHFreqCode,PriorDesc,OrderDept,Doctor,groupIcon)=""
				s groupdr = $p(^OEORD(OrderRowid,"I",child,11),"^",39)
				s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
				s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
				s str2 = $g(^OEORD(OrderRowid,"I",child,2))
				s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEORIRowid)
				if (doseQty["-") s doseQty="("_doseQty_")"		
				s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
				s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
				s DoseQtyInfo=doseQty_doseUOM
				s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
				s:+instrDr'=0 InstrDesc=$p(^PHCIN(instrDr),"^",2)
				s InstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",InstrDesc,langid)
				/*s PHFreqDr = $p(str2,"^",4)	;频次 OEORI_PHFreq_DR
				s PHFreqCode=""
				if (PHFreqDr'=""){
					s PHFreqDesc1 = $p($G(^PHCFR(PHFreqDr)),"^",3)
					s PHFreqCode = $p($G(^PHCFR(PHFreqDr)),"^",1)
					s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
					i WeekFlag="Y" {
						s OrderFreqWeek=$p($g(^OEORD(OrderRowid,"I",child,"DHC")),"^",55)
						s PHFreqDesc1=PHFreqDesc1_"-"_$TR(OrderFreqWeek,"|","")
						s PHFreqCode=PHFreqCode_" "_$TR(OrderFreqWeek,"|","")
					}
				}*/
				s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrderRowid_"||"_child,"-")
				s PHFreqDr=$List(OrdFreqInfo,1)
				s PHFreqDesc1=$List(OrdFreqInfo,2)
				s PHFreqCode=$List(OrdFreqInfo,5)
				
				s PriorityDR = $p(str1,"^",8)
				s PriorDesc = $p(^OECPR(PriorityDR),"^",2)
				s PriorDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorDesc,langid)
				s OrderDept=""
				s OrderDeptDr=$p(^OEORD(OrderRowid,"I",child,7),"^",2)
				if (OrderDeptDr'="") {
					s OrderDept=$P(^CTLOC(OrderDeptDr),"^",2)
					s OrderDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderDept,langid)
				}
				s DoctorDr=$p(str1,"^",11)
				if (DoctorDr'=""){
					s Doctor=$P(^CTPCP(DoctorDr,1),"^",2)
					Set Doctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Doctor,langid)
				}
				if (groupdr=""){
					s OrderLastExeDateStr=..GetOrderLastExeDateStr(OEORIRowid)
				}
				s OEORIActionDR=$p($g(^OEORD(OrderRowid,"I",child,11)),"^",21)
				s (OEORIActionCode,OEORIActionDesc)=""
				if (OEORIActionDR'=""){
					s OEORIActionCode=$p($g(^OEC("ACT",OEORIActionDR)),"^",1)
					s OEORIActionDesc=$p($g(^OEC("ACT",OEORIActionDR)),"^",2)
					s OEORIActionDesc =##class(User.OECAction).GetTranByDesc("ACTDesc",OEORIActionDesc,langid)
					s OEORIActionDesc="<font color=green>"_OEORIActionDesc_"&nbsp"_"</font>"
				}
				s OrderName=OEORIActionDesc_OrderName
				if (OEORIActionCode="TM"){
					//脱敏治疗
					s SkinMsgList(2,"ID",OEORIRowid)=1
				}else{
					s SkinMsgList(2,"ID",OEORIRowid)=2
				}
				
				
				s list=$LB(OrderLastExeDateStr,OrderName,DoseQtyInfo,InstrDesc,PHFreqCode,PriorDesc,OrderDept,Doctor,groupIcon,OEORIRowid)

				i +groupdr>0 d //处理护士补录今天以前的长期医嘱
				.s StartDate=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",9)
				.s StartTime=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",10)
				e  d
				.s StartDate=$p(str1,"^",9)
				.s StartTime=$p(str1,"^",10)
				s times=StartDate*24*3600+StartTime
				i groupdr="" d
				.s groupdr=$p($g(^OEORD(OrderRowid,"I",child,"DHC")),"^",54)
				.if (+groupdr'="0")&&('$d(plist(+groupdr,times,$p(groupdr,"||",2)))) s groupdr=""
				i +groupdr>0 d
				.s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", child) = list
				e  d
				.s plist(OrderRowid,times,child) = list
			}
		}
	}
	s orderParref = $o(plist(""))
	if (orderParref'=""){
		d:tableCount>0 Stream.Write(",")
		s tableCount=tableCount+1
		s colDefine=##class(DHCDoc.Util.MapIndex).%New()
		s col="OrderLastExeDateStr:末次用药时间,OrderName:医嘱名称,DoseQtyInfo:剂量,InstrDesc:用法,PHFreqCode:频次,PriorDesc:医嘱类型,OrderDept:开单科室,Doctor:医生,groupIcon:组号,ID:ID"
		f i=1:1:$Length(col,",") {
			d colDefine.add($P($P(col,",",i),":",1))
			s colDefine.map($P($P(col,",",i),":",1),"Type")=10
		}
		d Stream.Write("{")
		d Stream.Write(##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine))
		d Stream.Write(",""id"":""TreatList_Table""")
		s SkinTilte="治疗记录"
		s SkinTilte=..%Translate("oeorder.guideallergy.csp",SkinTilte)
		d Stream.Write(",""title"":"""_SkinTilte_"""")
		d Stream.Write(",""titleClass"":""normal-head""")
		d Stream.Write(",""rows"":[")
		s rowCount=0
		
		s time=""
		for  {
			Set time=$o(plist(orderParref,time),-1)
			Quit:time=""
			s parref=0
			for{
				s parref=$o(plist(orderParref,time,parref))
				q:parref=""
				s plist(orderParref,time,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
				s sub=0
				for{
					s sub = $o(plist(orderParref,time,parref,"Sub",sub))
					q:sub=""
					if $o(plist(orderParref,time,parref,"Sub",sub))="" {
						s $list(plist(orderParref,time,parref,"Sub",sub),9)="<font color=red>┛</font>"
					}else{ 
						s $list(plist(orderParref,time,parref,"Sub",sub),9)="<font color=red>┃</font>"
					}
					s plist(orderParref,time,parref,"ChildNum")=plist(orderParref,time,parref,"ChildNum")+1
				}
				i plist(orderParref,time,parref,"ChildNum")>0 Set $list(plist(orderParref,time,parref),9)="<font color=red>┓</font>"
			}
		}
		
		s time=""
		for{
			Set time=$o(plist(orderParref,time),-1)
			Quit:time=""
			Set parref=0
			for{
				s parref=$o(plist(orderParref,time,parref))
				q:parref=""
				d:rowCount>0 Stream.Write(",")
				s rowCount=rowCount+1
				s list=plist(orderParref,time,parref)
				d Stream.Write(##class(DHCDoc.Util.FormatData).GetJsonList(colDefine,list))
				s subIndex=0, sub=0
				for{
					s sub = $o(plist(orderParref,time,parref,"Sub", sub))
					q:sub=""
					d:rowCount>0 Stream.Write(",")
					s rowCount=rowCount+1
					s list=plist(orderParref,time,parref,"Sub",sub)
					d Stream.Write(##class(DHCDoc.Util.FormatData).GetJsonList(colDefine,list))
				}
			}
		}
		d Stream.Write("]")
		d Stream.Write("}")
	}
	///输出过敏记录
	k RelatedAllergiesList
	d ..BuildRelatedAllergyList(EpisodeID, ArcimRowId, OrderStartDate,.RelatedAllergiesList)
	if ($D(RelatedAllergiesList)){
		d:tableCount>0 Stream.Write(",")
		s tableCount=tableCount+1
		///ALGItem,Allergen,OnsetDateText,CareProvider,Category
		s colDefine=##class(DHCDoc.Util.MapIndex).%New()
		s col="ALGItem:过敏项目,Allergen:过敏源,OnsetDateText:过敏时间,CareProvider:操作用户,Category:过敏源分类"
		f i=1:1:$Length(col,",") {
			d colDefine.add($P($P(col,",",i),":",1))
			s colDefine.map($P($P(col,",",i),":",1),"Type")=10
		}
		d Stream.Write("{")
		d Stream.Write(##class(DHCDoc.OPDoc.TreatPrint).FormatDataTableCols2(col,.colDefine))
		d Stream.Write(",""id"":""Allergy_Table""")
		s SkinTilte="过敏记录"
		s SkinTilte=..%Translate("oeorder.guideallergy.csp",SkinTilte)
		d Stream.Write(",""title"":"""_SkinTilte_"""")
		d Stream.Write(",""titleClass"":""normal-head""")
		d Stream.Write(",""rows"":[")
		//s RelatedAllergiesList(OnsetDate,RowID)
		s rowCount=0
		s OnsetDate=""
		for {
			s OnsetDate=$O(RelatedAllergiesList(OnsetDate),-1)
			q:(OnsetDate="")
			s RowID=""
			for {
				s RowID=$O(RelatedAllergiesList(OnsetDate,RowID))
				q:(RowID="")
				d:rowCount>0 Stream.Write(",")
				s rowCount=rowCount+1
				s Str=$G(RelatedAllergiesList(OnsetDate,RowID))
				s ALGItem=$P(Str,"^",1)
				s Allergen=$P(Str,"^",2)
				s OnsetDateText=$P(Str,"^",3)
				s CareProvider=$P(Str,"^",4)
				s Category=$P(Str,"^",5)
				s Level=$G(RelatedAllergiesList(OnsetDate,RowID,"Level"))
				if ($G(SkinMsgList(3,"ID",RowID))="")||($G(SkinMsgList(3,"ID",RowID))>Level){
					s SkinMsgList(3,"ID",RowID)=Level
				}
				
				s list=$LB(ALGItem,Allergen,OnsetDateText,CareProvider,Category)
				d Stream.Write(##class(DHCDoc.Util.FormatData).GetJsonList(colDefine,list))
			}
		}
		d Stream.Write("]")
		d Stream.Write("}")
	}
	d Stream.Write("],")
	s SkinMsg=..GetSkinMsg(EpisodeID,SkinControlInfo,.SkinMsgList)	
	d Stream.Write("""SkinMsg"":"""_SkinMsg_"""")
	d Stream.Write("}")
	
	q Stream.Read()
}

/// 获取医嘱项的皮试控制明细
/// 皮试有效时间^允许脱敏^允许免试^控制例外^过敏原名称^PHAIN_SkinTest表ID^默认免试^医嘱项ID^^^^^^^
ClassMethod GetArcimSkinControlInfo(ArcimRowId As %String, OrderStartDate As %String, HospitalDR As %String) As %String
{
	if OrderStartDate="" s OrderStartDate=..%SysDate()
	e  Set OrderStartDate=..%ZDH(OrderStartDate)
	
	s SkinControlInfo=""
	s DefNoTest=##class(PHA.FACE.OUT.Com).IsDefNoTest(ArcimRowId, HospitalDR)
	Kill ArcimSkinList
	s rs=##class(PHA.FACE.OUT.Com).GetSkinTestInfo(ArcimRowId,HospitalDR)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s pistid=rs.Data("pist")					//PHAIN_SkinTest表ID
		s alg=rs.Data("alg")						//过敏原ID
		s algDesc=rs.Data("algDesc")				//过敏原名称
		s itemId=rs.Data("itemId")					//项目ID
		s itemDesc=rs.Data("itemDesc")				//项目名称
		continue:(itemId="")
		s itemType=rs.Data("itemType")				//项目类型,G通用名,A医嘱项
		s validTime=rs.Data("validTime")			//皮试有效时间
		s desensitFlag=rs.Data("desensitFlag")		//允许脱敏
		s noTestFlag=rs.Data("noTestFlag")			//允许免试
		s exceptionFlag=rs.Data("exceptionFlag")	//控制例外
		s startDate=rs.Data("startDate")			//开始日期
		s endDate=rs.Data("endDate")				//截止日期
		if (startDate'="")&&(startDate>OrderStartDate){
			continue
		}
		if (endDate'="")&&(endDate<OrderStartDate){
			continue
		}
		s ArcimSkinList(itemType,itemId)=""
		s ArcimSkinList(itemType,itemId,"Details")=validTime_"^"_desensitFlag_"^"_noTestFlag_"^"_exceptionFlag_"^"_algDesc_"^"_pistid_"^"_DefNoTest_"^"_ArcimRowId
	}
	d rs.%Close()
	if '$D(ArcimSkinList){
		q SkinControlInfo
	}
	
	if $D(ArcimSkinList("A")){
		s SkinControlInfo=$G(ArcimSkinList("A",ArcimRowId,"Details"))
		if (SkinControlInfo=""){
			s SkinControlInfo=$G(ArcimSkinList("A",$O(ArcimSkinList("A",0)),"Details"))
		}
	}else{
		//通用名的优先级应小于医嘱项
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowId)
		if (DrgformRowid'=""){
			s GenericId=$p($g(^PHCD(+DrgformRowid,4)),"^",1)
			if $D(ArcimSkinList("G",GenericId)){
				s SkinControlInfo=$G(ArcimSkinList("G",GenericId,"Details"))
			}
			if (SkinControlInfo=""){
				s SkinControlInfo=$G(ArcimSkinList("G",$O(ArcimSkinList("G",0)),"Details"))
			}
		}
	}
	q SkinControlInfo
}

/// 根据药房的皮试药品维护，获取与该医嘱项关联的皮试内容
ClassMethod BuildRelatedArcimList(EpisodeID As %String, ArcimRowId As %String, OrderStartDate As %String, ByRef RelatedArcimList) As %String
{
	if OrderStartDate="" s OrderStartDate=..%SysDate()
	e  Set OrderStartDate=..%ZDH(OrderStartDate)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
	kill RelatedArcimList
	s rs=##class(PHA.FACE.OUT.Com).GetSkinTestInfoRela(ArcimRowId,HospitalDR)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s pisti=rs.Data("pisti")					//PHAIN_SkinTestItm表ID
		s admType=rs.Data("admType")						//就诊类型(O/E/I)
		continue:(admType'="")&&(admType'=AdmType)
		s locID=rs.Data("locID")				//科室ID
		continue:(locID'="")&&(locID'=AdmLoc)
		s autoInsFlag=rs.Data("autoInsFlag")					//自动插入
		//continue:(autoInsFlag="Y")
		s itemId=rs.Data("itemId")				//关联项目ID
		s itemDesc=rs.Data("itemDesc")
		continue:(itemId="")
		s resultFlag=rs.Data("resultFlag")
		continue:(resultFlag="N")
		s itemType=rs.Data("itemType")			///关联项目类型,G通用名,A医嘱项
		s RelatedArcimList(itemType,itemId)=""
	}
	s GenericId=""
	for {
		s GenericId=$O(RelatedArcimList("G",GenericId))
		q:(GenericId="")
		s DrgFormRowid=""
		for {
			s DrgFormRowid=$O(^PHCD(0,"Gener",GenericId,DrgFormRowid))
			q:(DrgFormRowid="")
			s ArcimSubscript=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",0))
			continue:(ArcimSubscript="")
			s ArcimVersion=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",ArcimSubscript,0))
			s ArcimDr=ArcimSubscript_"||"_ArcimVersion
			continue:($D(RelatedArcimList("A",ArcimDr)))
			m RelatedArcimList("A",ArcimDr)=RelatedArcimList("G",GenericId)
		}
	}
	if '$D(RelatedArcimList("A",ArcimRowId)){
		s RelatedArcimList("A",ArcimRowId)=""
	}
	q
}

/// 获取医嘱的最后一次执行时间
/// w ##Class(web.DHCOEOrderGuideAllergy).GetOrderLastExeDateStr("62||71")
ClassMethod GetOrderLastExeDateStr(OEORIRowid As %String) As %String
{
	s OrderLastExeDateStr=""
	k ExeDateList
	s OrderRowid=$P(OEORIRowid,"||",1),child=$P(OEORIRowid,"||",2)
	s OEOREChildsub=""
	for {
		s OEOREChildsub=$O(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub),-1)
		q:(OEOREChildsub="")
		s StatusRowId=$P(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub),"^",16)
		continue:(StatusRowId="")
		s StatusCode=$P(^OEC("STAT",StatusRowId),"^",1)
		continue:(StatusCode'="F")
		s DateExecuted=$P(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub),"^",19)
		s TimeExecuted=$P(^OEORD(OrderRowid,"I",child,"X",OEOREChildsub),"^",20)
		s ExeDateList(DateExecuted,TimeExecuted)=""
	}
	if $D(ExeDateList){
		s LastDateExecuted=$O(ExeDateList(""),-1)
		s LastTimeExecuted=$O(ExeDateList(LastDateExecuted,""),-1)
		s OrderLastExeDateStr=..%ZD(LastDateExecuted)_" "_..%ZT(LastTimeExecuted,2)
	}
	q OrderLastExeDateStr
}

/// 获取有效的过敏记录列表
ClassMethod BuildRelatedAllergyList(EpisodeID As %String, ArcimRowId As %String, OrderStartDate As %String, ByRef RelatedAllergiesList) As %String
{
	
	f OrderStartDate="" s OrderStartDate=..%SysDate()
	e  Set OrderStartDate=..%ZDH(OrderStartDate)
	Set langid=..%LanguageID()
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=$P(^CTLOC(AdmLoc),"^",22)
	i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
	;过敏记录药学子类需提示
    
 	s AllergyChildNotice=..%GetConfig("AllergyChildNotice",HospitalDR)
	s PHCDPHCSCDR=##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(ArcimRowId)
    s PHCDPHCSCDR=$p(PHCDPHCSCDR,"^",1)
    
	///获取医嘱项关联的过敏源
	s AlgStr=##class(PHA.FACE.OUT.Com).GetAlgStrByArcim(ArcimRowId,OrderStartDate,HospitalDR)
	//根据过敏源id串获取所有的皮试药品配置信息
	kill ArcimSkinList
	s rs=##class(PHA.FACE.OUT.Com).GetSkinTestList(AlgStr,HospitalDR)
	while rs.Next(.sc) {
		s pistid=rs.Data("pist")					//PHAIN_SkinTest表ID
		s alg=rs.Data("alg")						//过敏原ID
		s algDesc=rs.Data("algDesc")				//过敏原名称
		s itemId=rs.Data("itemId")					//项目ID
		s itemDesc=rs.Data("itemDesc")				//项目名称
		continue:(itemId="")
		s itemType=rs.Data("itemType")				//项目类型,G通用名,A医嘱项
		s validTime=rs.Data("validTime")			//皮试有效时间
		s desensitFlag=rs.Data("desensitFlag")		//允许脱敏
		s noTestFlag=rs.Data("noTestFlag")			//允许免试
		s exceptionFlag=rs.Data("exceptionFlag")	//控制例外
		s startDate=rs.Data("startDate")			//开始日期
		s endDate=rs.Data("endDate")				//截止日期
		if (startDate'="")&&(startDate>OrderStartDate){
			continue
		}
		if (endDate'="")&&(endDate<OrderStartDate){
			continue
		}
		s ArcimSkinList(itemType,itemId)=""
		s ArcimSkinList(itemType,itemId,"Details")=validTime_"^"_desensitFlag_"^"_noTestFlag_"^"_exceptionFlag_"^"_algDesc
	}
	d rs.Close()
	s GenericId=""
	for {
		s GenericId=$O(ArcimSkinList("G",GenericId))
		q:(GenericId="")
		s DrgFormRowid=""
		for {
			s DrgFormRowid=$O(^PHCD(0,"Gener",GenericId,DrgFormRowid))
			q:(DrgFormRowid="")
			s ArcimSubscript=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",0))
			continue:(ArcimSubscript="")
			s ArcimVersion=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",ArcimSubscript,0))
			s ArcimDr=ArcimSubscript_"||"_ArcimVersion
			continue:($D(ArcimSkinList("A",ArcimDr)))
			m ArcimSkinList("A",ArcimDr)=ArcimSkinList("G",GenericId)
		}
	}
	if '$D(ArcimSkinList("A",ArcimRowId)){
		s ArcimSkinList("A",ArcimRowId)=""
		
	}
	///d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","Allergies","173")
	///根据过敏源获取有效的
	Set rsObj=##Class(%ResultSet).%New("web.DHCPAAllergy:Allergies")
	If rsObj.QueryIsValid() {
		 Set Status=rsObj.Execute(PatientID)
		 If 'Status Quit
		 While rsObj.Next() {
			s RowID=rsObj.GetData(1)
			//过敏分类
			s Category=rsObj.GetData(2)
			///过敏源描述
			s Allergen=rsObj.GetData(3)
			//过敏源名称
			s ALGItem=rsObj.GetData(4)
			//分类
			s tag=rsObj.GetData(25)
			s InActive=rsObj.GetData(11)
			continue:InActive="Y"
			s ALGItemRowID=""
			///过敏源ID
			s ALGTypeDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",9)	;PACAllergy
			s ALGPHCGEDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",4) ;通用名 PHC_Generic
			s ALGPHCDMDR=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",27) ;药学项 PHC_DrgMast
			s ALGPHCDMDRArcimDr=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",30) ;医嘱项 ARC_ItmMast
			
			s FindActiveALG=0
			if (ALGTypeDR'="")&&(("^"_AlgStr_"^")[("^"_ALGTypeDR_"^")){
				s FindActiveALG=1
			}
			s ArcimList=""
			if (ALGPHCGEDR'=""){
				s DrgFormRowid=""
				for {
					s DrgFormRowid=$O(^PHCD(0,"Gener",ALGPHCGEDR,DrgFormRowid))
					q:(DrgFormRowid="")
					s ArcimSubscript=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",0))
					continue:(ArcimSubscript="")
					s ArcimVersion=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",ArcimSubscript,0))
					s ArcimDr=ArcimSubscript_"||"_ArcimVersion
					if (ArcimList=""){
						s ArcimList=ArcimDr
					}else{
						s ArcimList=ArcimList_"^"_ArcimDr
					}
				}
			}
			if (ALGPHCDMDR'=""){
				s ArcimSubscript=$O(^ARCIM(0,"PHCDF",ALGPHCDMDR_"||1",0))
				if (ArcimSubscript'=""){
					s ArcimVersion=$O(^ARCIM(0,"PHCDF",ALGPHCDMDR_"||1",ArcimSubscript,0))
					s ArcimDr=ArcimSubscript_"||"_ArcimVersion
					if (ArcimList=""){
						s ArcimList=ArcimDr
					}else{
						s ArcimList=ArcimList_"^"_ArcimDr
					}
				}
			}
			if (ALGPHCDMDRArcimDr'=""){
				if (ArcimList=""){
					s ArcimList=ALGPHCDMDRArcimDr
				}else{
					s ArcimList=ArcimList_"^"_ALGPHCDMDRArcimDr
				}
			}
			for i=1:1:$Length(ArcimList,"^"){
				s ArcimDr=$P(ArcimList,"^",i)
				continue:(ArcimDr="")
				if ($D(ArcimSkinList("A",ArcimDr))){
					s FindActiveALG=1
				}
				if (AllergyChildNotice=1){
					s ALGPHCDPHCSCDR=##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(ArcimDr)
					s ALGPHCDPHCSCDR=$p(ALGPHCDPHCSCDR,"^",1)
					//同药学项分类的增加特殊标志，防止项目组合并整个β内酰胺类抗菌药，这里逻辑做好区分
					if (ALGPHCDPHCSCDR=PHCDPHCSCDR)&&(ALGPHCDPHCSCDR'=""){
						s FindActiveALG=2
					}
				}
			}
			;FindActiveALG
			continue:(FindActiveALG=0)
			//医护人员
			s CareProvider=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",1)
			if (CareProvider'=""){
				s CareProvider=$P($G(^CTPCP(CareProvider,1)),"^",2)
				Set CareProvider= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",CareProvider,langid)
			}
			s OnsetDate=$P(^PAPER(+RowID,"ALG",$P(RowID,"||",2)),"^",14)
			//发作日期描述
			s OnsetDateText=rsObj.GetData(12)
			//最后更新用户
			s LastUpdateUser=rsObj.GetData(16)
			s LastUpdateUser =##class(User.SSUser).GetTranByDesc("SSUSRName",LastUpdateUser,langid)
			Set Category= ##class(User.MRCAllType).GetTranByDesc("MRCATDesc",Category,langid)
			s ALGItem=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ALGItem,langid)
			Set Allergen= ##class(User.PACAllergy).GetTranByDesc("ALGDesc",Allergen,langid) 
			s RelatedAllergiesList(OnsetDate,RowID)=ALGItem_"^"_Allergen_"^"_OnsetDateText_"^"_LastUpdateUser_"^"_Category
			s RelatedAllergiesList(OnsetDate,RowID,"Level")=FindActiveALG
		 }
		 d rsObj.Close()
	}
	q
}

/// 获取与皮试配置关联的 皮试记录和治疗记录
ClassMethod BuildSkinOrdList(EpisodeID As %String, ArcimRowId As %String, OrderStartDateStr As %String, SkinControlInfo As %String, ByRef TableArr) As %String
{
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=$P(^CTLOC(AdmLoc),"^",22)
	i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
	s OrderStartDate=$P(OrderStartDateStr," ",1)
	s OrderStartTime=$P(OrderStartDateStr," ",2)
	
	if OrderStartDate="" s StartDate=..%SysDate()
	e  Set StartDate=..%ZDH(OrderStartDate)
	if OrderStartTime="" s StartTime=..%SysTime()
	e  Set StartTime=..%ZTH(OrderStartTime)
	s CurrDateStr=StartDate*24*3600+StartTime
	s SkinValidTime=$P(SkinControlInfo,"^",1)		;皮试有效时间
	s SkinDesensitFlag=$P(SkinControlInfo,"^",2)	;允许脱敏
	s SkinNoTestFlag=$P(SkinControlInfo,"^",3)		;允许免试
	s SkinExceptionFlag=$P(SkinControlInfo,"^",4)	;控制例外
	;仅将已执行的治疗医嘱算作有效治疗(门急诊)
    s SkinTestOPNeedExcutedCur=..%GetConfig("SkinTestOPNeedExcutedCur",HospitalDR)
	

	///获取当前医嘱项的需验证医嘱项列表
	k RelatedArcimList
	d ..BuildRelatedArcimList(EpisodeID,ArcimRowId,OrderStartDate,.RelatedArcimList)
	if '$D(RelatedArcimList){
		q ""
	}
	
	s SkinTestInstr=..%GetConfig("SkinTestInstr",HospitalDR)	;皮试用法
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	k HistoryOrdList
	s ArcimDr=0
	for {
		s ArcimDr=$O(RelatedArcimList("A",ArcimDr))
		q:(ArcimDr="")
		s LoopADMType=""
		for {
			s LoopADMType=$O(^PAPERdr(PatientID,"ADM",LoopADMType))
			q:(LoopADMType="")
			s LoopAdm=""
			for {
				s LoopAdm=$O(^PAPERdr(PatientID,"ADM",LoopADMType,LoopAdm))
				q:(LoopAdm="")
				s LoopOrderRowid=$o(^OEORD(0,"Adm",+LoopAdm,""))
				continue:(LoopOrderRowid="")
				d LoopSkinOrdList
				
			}
		}
	}
	q ""
LoopSkinOrdList
	s LoopPAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(LoopAdm)
	if (LoopPAAdmType="I"){
		s LoopSkinTestOPNeedExcutedCur=1		;住院强制判断执行状态
	}else{
		s LoopSkinTestOPNeedExcutedCur=SkinTestOPNeedExcutedCur
	}
	//^OEORDi(0,"DateARCIM",{OEORE_ExStDate},$P($G(^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},1)),"^",2),{OE_Order.OEORD_RowId},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
	
	s ExStDate=..%SysDate()-((SkinValidTime\24)+$CASE((SkinValidTime#24)>0,1:1,:0))-1
	for{
		s ExStDate=$O(^OEORDi(0,"DateARCIM",ExStDate))
		q:(ExStDate="")
		q:(ExStDate>(+$H+((SkinValidTime\24)+$CASE((SkinValidTime#24)>0,1:1,:0))))
		
		s child=0
		for {
			s child=$O(^OEORDi(0,"DateARCIM",ExStDate,ArcimDr,LoopOrderRowid,child))
			q:(child="")
			continue:('$D(^OEORD(LoopOrderRowid,"I",child,1)))
			s LoopOEORIRowid=LoopOrderRowid_"||"_child
			continue:($D(HistoryOrdList(LoopOEORIRowid)))
			s HistoryOrdList(LoopOEORIRowid)=""
			s TItemStatCode=""
			s itemStatDr = $p(^OEORD(LoopOrderRowid,"I",child,1),"^",13) 
			s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
			if (LoopADMType="I"){
				continue:(("VED")'[TItemStatCode)
			}else{
				continue:(("VE")'[TItemStatCode)
			}
			s SttDat=$p(^OEORD(LoopOrderRowid,"I",child,1),"^",9)
			s SttTime=$p(^OEORD(LoopOrderRowid,"I",child,1),"^",10)
			s OrdLinkRowId=$p($g(^OEORD(LoopOrderRowid,"I",child,11)),"^",39)
			if (OrdLinkRowId'=""){
				s LinkSttDat=$p(^OEORD(LoopOrderRowid,"I",$P(OrdLinkRowId,"||",2),1),"^",9)
				s LinkSttTime=$p(^OEORD(LoopOrderRowid,"I",$P(OrdLinkRowId,"||",2),1),"^",10)
				s SttDateStr=LinkSttDat*24*3600+LinkSttTime
			}else{
				s SttDateStr=SttDat*24*3600+SttTime
			}
			s EMStayFlag=$p($g(^OEORD(LoopOrderRowid,"I",child,"DHC")),"^",17)
			if (EMStayFlag="1"){
				s LoopSkinTestOPNeedExcutedCur=1	//留观强制判断执行状态
			}
			//判断医嘱开始时间
			s ValidTimeFlag=0
			if ($ZABS((CurrDateStr-SttDateStr)/3600)<=SkinValidTime)&&(+LoopSkinTestOPNeedExcutedCur=0){
				s ValidTimeFlag=1
			}
			//判断末次执行时间
			if (ValidTimeFlag'=1){
				s OrderLastExeDateStr=..GetOrderLastExeDateStr(LoopOEORIRowid)
				if (OrderLastExeDateStr'=""){
					Set OrderLastExeDateDate=..%ZDH($P(OrderLastExeDateStr," "))
					Set OrderLastExeDateTime=..%ZTH($P(OrderLastExeDateStr," ",2))
					s SttDateStr=OrderLastExeDateDate*24*3600+OrderLastExeDateTime
					if (((CurrDateStr-SttDateStr)/3600)<=SkinValidTime){
						s ValidTimeFlag=1
					}
				}
			}
			
			;ValidTimeFlag
			///仅显示【皮试有效时间】内的皮试医嘱或治疗医嘱
			if (ValidTimeFlag=0){
				continue
			}
			i OrdLinkRowId="" s OrdLinkRowId=LoopOEORIRowid
			s skintest=$p($g(^OEORD(LoopOrderRowid,"I",child,5)),"^",2)
			s skintestStr=skintest
			s actionDRStr=$p($g(^OEORD(LoopOrderRowid,"I",child,11)),"^",21)
			s Sub=0
			for {
				s Sub=$O(^OEORDi(0,"OEORI",LoopOrderRowid,OrdLinkRowId,Sub))
				q:(Sub="")
				s Subskintest=$p($g(^OEORD(LoopOrderRowid,"I",Sub,5)),"^",2)
				s SubactionDR=$p($g(^OEORD(LoopOrderRowid,"I",Sub,11)),"^",21)
				s skintestStr=skintestStr_Subskintest
				//tanjishan 关联医嘱的皮试备注为什么药拼接在这，会把氯化钠获取到皮试备注导致错误的弹出引导
				//s actionDRStr=actionDRStr_SubactionDR
				
			}
			s str2=$G(^OEORD(LoopOrderRowid,"I",child,2))
			s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
			s isSkinTestInstrFlag=0
			//只有遍历的医嘱项本身符合皮试条件时，才收录到皮试列表中
			if (instrDr'="")&&(SkinTestInstr[("^"_instrDr_"^")){
				if ((skintest["Y")){
					s TableArr("SkinList",SttDateStr,LoopOEORIRowid)=ValidTimeFlag
				}
			//}elseif (skintest["Y")&&(actionDRStr'=""){
			}elseif (skintest["Y")||(actionDRStr'=""){
				///1、正常的治疗用药会勾选皮试勾选；2、或者续注等没有勾选，但也要按照治疗医嘱处理
				s MainOrdRowId=OrdLinkRowId
				i MainOrdRowId="" s MainOrdRowId=LoopOEORIRowid
				s TableArr("TreatList",SttDateStr,MainOrdRowId)=ValidTimeFlag
				s Sub=0
				for {
					s Sub=$O(^OEORDi(0,"OEORI",LoopOrderRowid,MainOrdRowId,Sub))
					q:(Sub="")
					s TableArr("TreatList",SttDateStr,LoopOrderRowid_"||"_Sub)=ValidTimeFlag
				}
				
			}
			
		}
	}
	q
}

/// 获取皮试相关提醒
/// Input		SkinMsgList(SkinType,ID)=SkinLevel
/// 				SkinType(1:存在皮试相关记录;2:存在治疗相关记录;3:存在过敏史)
/// output		Type:(PositiveSkin:皮试阳性,NegativeSkin:皮试阴性,NoResultSkin:皮试未出结果,TMTreat:存在脱敏治疗记录,Treat:存在治疗记录,PAAllergy:存在过敏记录,PHAClassTypePAAllergy:存在同药学分类过敏记录,NotSkinOrd:无皮试医嘱)
/// 			Msg
/// 			SkinDesensitFlag:允许脱敏
/// 			SkinNoTestFlag:允许免试
/// 			SkinExceptionFlag:控制例外--指缴费、发药控制
/// 			受控表TableName
/// 			受控表IDList
///  			默认免试
ClassMethod GetSkinMsg(EpisodeID As %String, SkinControlInfo As %String, ByRef SkinMsgList) As %String
{
	
	s SkinValidTime=$P(SkinControlInfo,"^",1)		;皮试有效时间
	s SkinDesensitFlag=$P(SkinControlInfo,"^",2)	;允许脱敏
	s SkinNoTestFlag=$P(SkinControlInfo,"^",3)		;允许免试
	s SkinExceptionFlag=$P(SkinControlInfo,"^",4)	;控制例外--指缴费、发药控制
	s SkinAlgDesc=$P(SkinControlInfo,"^",5)			;过敏源
	s PHAINSkinTestDr=$P(SkinControlInfo,"^",6)		;PHAIN_SkinTest表ID
	s DefNoTest=$P(SkinControlInfo,"^",7)			;默认免试
	s ArcimRowId=$P(SkinControlInfo,"^",8)			;医嘱项ID
	s SkinType=""
	for {
		s SkinType=$O(SkinMsgList(SkinType))
		q:(SkinType="")
		s ID=""
		for {
			s ID=$O(SkinMsgList(SkinType,"ID",ID))
			q:(ID="")
			s SkinLevel=$P(SkinMsgList(SkinType,"ID",ID),"^",1)
			//皮试结果优先以执行时间排序，同时执行时以医嘱开始时间为准
			if (SkinType="1"){
				s SttDat=$p(^OEORD(+ID,"I",$P(ID,"||",2),1),"^",9)
				s SttTime=$p(^OEORD(+ID,"I",$P(ID,"||",2),1),"^",10)
				s SttDateStr=SttDat*24*3600+SttTime
				s OrderLastExeDateStr=..GetOrderLastExeDateStr(ID)
				s ExeDateStr=0
				if (OrderLastExeDateStr'=""){
					Set OrderLastExeDateDate=..%ZDH($P(OrderLastExeDateStr," "))
					Set OrderLastExeDateTime=..%ZTH($P(OrderLastExeDateStr," ",2))
					s ExeDateStr=OrderLastExeDateDate*24*3600+OrderLastExeDateTime
				}
				s SkinMsgList(SkinType,"Type",ExeDateStr,SttDateStr)=SkinLevel
				s SkinMsgList(SkinType,"Type",ExeDateStr,SttDateStr,ID)=SkinMsgList(SkinType,"ID",ID)
			}else{
				s SkinMsgList(SkinType,"Type",SkinLevel,ID)=SkinMsgList(SkinType,"ID",ID)
			}
		}
	}
	s SkinType=$O(SkinMsgList(""))
	//没有任何记录,且没有维护对应的皮试医嘱信息
	q:((SkinType="")&&(PHAINSkinTestDr="")) ""
	s SkinLevel=""
	s:SkinType'="" SkinLevel=$O(SkinMsgList(SkinType,"Type",""))
	;GetSkinMsg
	//存在皮试记录
	if (SkinType=1){
		//d SetIDList
		s LastExeDateStr=$O(SkinMsgList(SkinType,"Type",""),-1)
		s LastStDateStr=$O(SkinMsgList(SkinType,"Type",LastExeDateStr,""),-1)
		s SkinLevel=$G(SkinMsgList(SkinType,"Type",LastExeDateStr,LastStDateStr))
		if (SkinLevel=1){
			s $P(SkinMsg,"^",1)="PositiveSkin"
			s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内有皮试记录,皮试结果<font color=red>阳性</font>"
			s DefNoTest="N"
		}elseif (SkinLevel=2){
			s $P(SkinMsg,"^",1)="NegativeSkin"
			s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内有皮试记录,皮试结果<font color=green>阴性</font>"
		}elseif (SkinLevel=3){
			s $P(SkinMsg,"^",1)="NoResultSkin"
			s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内有皮试医嘱,未出结果"
		}
		s $P(SkinMsg,"^",6)="OE_OrdItem"
		
		s IDList=""
		s ID=""
		for {
			s ID=$O(SkinMsgList(SkinType,"Type",LastExeDateStr,LastStDateStr,SkinLevel,ID))
			q:(ID="")
			if (IDList=""){
				s IDList=ID
			}else{
				s IDList=IDList_"#"_ID
			}
		}
		
		
		s $P(SkinMsg,"^",7)=IDList
	}elseif (SkinType=2){
		//存在治疗记录
		d SetIDList
		if (SkinLevel=1){
			s $P(SkinMsg,"^",1)="TMTreat"
			s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内<font color=red>有脱敏治疗记录</font>"
		}else{
			s $P(SkinMsg,"^",1)="Treat"
			s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内<font color=green>有用药记录</font>"
		}
		s $P(SkinMsg,"^",6)="OE_OrdItem"
		s $P(SkinMsg,"^",7)=IDList
	}elseif (SkinType=3){
		//存在过敏史
		d SetIDList
		if (SkinLevel=1){
			s $P(SkinMsg,"^",1)="PAAllergy"
			s $P(SkinMsg,"^",2)="病人有<font color=red>"_SkinAlgDesc_"过敏史</font>"
			s DefNoTest="N"
		}elseif (SkinLevel=2){
			s ret=##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(ArcimRowId)
			s PHYClassTypeDesc=$P(ret,"^",2)
			s PHYClassTypeDesc=$P(PHYClassTypeDesc,"-",$L(PHYClassTypeDesc,"-"))
			i PHYClassTypeDesc'="" s SkinAlgDesc=PHYClassTypeDesc
			s $P(SkinMsg,"^",1)="PHAClassTypePAAllergy"
			s $P(SkinMsg,"^",2)="病人有<font color=red>"_SkinAlgDesc_"过敏史</font>"
		}
		s $P(SkinMsg,"^",6)="PA_Allergy"
		s $P(SkinMsg,"^",7)=IDList
	}else{
		s $P(SkinMsg,"^",1)="NotSkinOrd"
		s $P(SkinMsg,"^",2)="病人"_SkinValidTime_"小时内无皮试医嘱"
		s $P(SkinMsg,"^",6)=""
		s $P(SkinMsg,"^",7)=""
	}
	;over
	s $P(SkinMsg,"^",3)=SkinDesensitFlag
	s $P(SkinMsg,"^",4)=SkinNoTestFlag
	s $P(SkinMsg,"^",5)=SkinExceptionFlag
	s $P(SkinMsg,"^",8)=DefNoTest


	q SkinMsg
SetIDList
	s IDList=""
	s ID=""
	for {
		s ID=$O(SkinMsgList(SkinType,"Type",SkinLevel,ID))
		q:(ID="")
		if (IDList=""){
			s IDList=ID
		}else{
			s IDList=IDList_"#"_ID
		}
	}
	q
}

/// 根据药房的皮试药品维护，获取与该医嘱项关联的需自动插入的皮试医嘱
/// d ##Class(web.DHCOEOrderGuideAllergy).BuildAppendAllergyOrder(527,"1076||1","17/04/2020 15:54:03",.a)
ClassMethod BuildAppendAllergyOrder(EpisodeID As %String, ArcimRowId As %String, OrderStartDate As %String, ByRef RelatedArcimList) As %String
{
	if OrderStartDate="" s OrderStartDate=..%SysDate()
	e  Set OrderStartDate=..%ZDH(OrderStartDate)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	
	kill RelatedArcimList
	s SeqNo=0
	s rs=##class(PHA.FACE.OUT.Com).GetSkinTestInfoRela(ArcimRowId,HospitalDR)
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s startDate=rs.Data("startDate")
		s startDate=..%ZDH(startDate)
		continue:(startDate'="")&&(startDate>+$h)
		s endDate=rs.Data("endDate")
		s endDate=..%ZDH(endDate)
		continue:(endDate'="")&&(endDate<=..%SysDate())
		s SeqNo=SeqNo+1
		s pisti=rs.Data("pisti")					//PHAIN_SkinTestItm表ID
		s admType=rs.Data("admType")						//就诊类型(O/E/I)
		continue:(admType'="")&&(admType'=AdmType)
		s locID=rs.Data("locID")				//科室ID
		continue:(locID'="")&&(locID'=AdmLoc)
		s autoInsFlag=rs.Data("autoInsFlag")					//自动插入
		continue:(autoInsFlag'="Y")
		s itemId=rs.Data("itemId")				//关联项目ID
		s itemDesc=rs.Data("itemDesc")
		continue:(itemId="")
		s itemType=rs.Data("itemType")			///关联项目类型,G通用名,A医嘱项
		continue:(itemType="G")
		///	pisti-子表ID, pist-主表ID, admType-就诊类型(O/E/I), admTypeDesc-就诊类型名称,
		/// locID-科室ID, locDesc-科室内容, itemId-关联项目ID, itemDesc-关联项目名称,
		/// itemType-项目类型, itemTypeDesc-项目类型名称, resultFlag-结果标志, priID-优先级ID,
		/// priDesc-优先级描述, doseQty-剂量, unitID-剂量单位ID, unitDesc-剂量单位描述,
		/// freqID-频次ID, freqDesc-频次描述, instID-用法ID, instDesc-用法描述,
		/// seqNo-关联序号, autoInsFlag-自动插入, startDate-开始日期, endDate-截止日期
		s resultFlag=rs.Data("resultFlag")	;结果标志-用于给相关治疗医嘱置皮试结果
		s LinkseqNo=rs.Data("seqNo")			;关联序号
		s priID=rs.Data("priID")			;优先级ID
		s doseQty=rs.Data("doseQty")		;剂量
		s unitID=rs.Data("unitID")			;剂量单位ID
		s instID=rs.Data("instID")			;用法ID
		s freqID=rs.Data("freqID")			;频次ID
		s OrdDetails=itemId_"^"_priID_"^"_doseQty_"^"_unitID_"^"_instID
		s OrdDetails=OrdDetails_"^"_freqID_"^"_resultFlag
		if (LinkseqNo=""){
			s RelatedArcimList("All",SeqNo)=OrdDetails
		}else{
			if ($D(RelatedArcimList("All",LinkseqNo))){
				s Index=$I(RelatedArcimList("All",LinkseqNo,"Sub"))
				if ($D(RelatedArcimList("All",LinkseqNo))){
					
					s RelatedArcimList("All",LinkseqNo,"Sub",Index)=OrdDetails
				}else{
					s RelatedArcimList("All",LinkseqNo,"Sub",Index)=OrdDetails
				}
			}else{
				s RelatedArcimList("All",LinkseqNo)=OrdDetails
				}
		}
		
		if (resultFlag="Y"){
			s RelatedArcimList("Drug",itemId)=""
		}
	}
	//主数据无效，做独立数据处理
	s MaxseqNo=$O(RelatedArcimList("All",""),-1)
	s LinkseqNo=""
	for {
		s LinkseqNo=$O(RelatedArcimList("All",LinkseqNo))
		q:(LinkseqNo="")
		continue:(RelatedArcimList("All",LinkseqNo)'="")
		s Index=0
		for {
			s Index=$O(RelatedArcimList("All",LinkseqNo,"Sub",Index))
			q:(Index="")
			s MaxseqNo=MaxseqNo+1
			s RelatedArcimList("All",MaxseqNo)=RelatedArcimList("All",LinkseqNo,"Sub",Index)
		}
		k RelatedArcimList("All",LinkseqNo)
	}
	
	
	q
}

Query QueryAppendAllergyOrd(EpisodeID As %String, ArcimRowId As %String, OrderStartDateStr As %String) As websys.Query(ROWSPEC = "ID:%String,SeqNo:%String,Priority:%String,OrderName:%String,DoseQtyInfo:%String,InstrDesc:%String,FreqDesc:%String,LinkSeqNo:%String,GroupSign:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOEOrderGuideAllergy","QueryAppendAllergyOrd",83,"1076||1","14/04/2020 15:54:03")
ClassMethod QueryAppendAllergyOrdExecute(ByRef qHandle As %Binary, EpisodeID As %String, ArcimRowId As %String, OrderStartDateStr As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	Set langid=..%LanguageID()
	s OrderStartDate=$P(OrderStartDateStr," ",1)
	;获取待关联医嘱列表
	k AppendArcimList
	d ##Class(web.DHCOEOrderGuideAllergy).BuildAppendAllergyOrder(EpisodeID,ArcimRowId,OrderStartDate,.AppendArcimList)
	if '$D(AppendArcimList){
		Quit $$$OK
	}
	s ID=0
	s SeqNo=""
	for {
		s SeqNo=$O(AppendArcimList("All",SeqNo))
		q:(SeqNo="")
		s OrdDetails=$G(AppendArcimList("All",SeqNo))
		s ID=ID+1
		s LinkSeqNo=""
		s GroupSign=""
		
		if ($D(AppendArcimList("All",SeqNo,"Sub"))){
			s GroupSign="┓"
		}
		d OutPutData
		
		s SubNo=""
		for {
			s SubNo=$O(AppendArcimList("All",SeqNo,"Sub",SubNo))
			q:(SubNo="")
			s OrdDetails=$G(AppendArcimList("All",SeqNo,"Sub",SubNo))
			s ID=ID+1
			s LinkSeqNo=SeqNo
			if $o(AppendArcimList("All",SeqNo,"Sub",SubNo))="" {
				s GroupSign="┛"
			}else{ 
				s GroupSign="┃"
			}
			d OutPutData
		}
	}
	q $$$OK
OutPutData
	s ARCIMRowid=$P(OrdDetails,"^",1)
	s PriorRowID=$P(OrdDetails,"^",2)
	s DoseQty=$P(OrdDetails,"^",3)
	s DoseUnitDr=$P(OrdDetails,"^",4)
	s InstrDr=$P(OrdDetails,"^",5)
	s FreqDr=$P(OrdDetails,"^",6)
	s (Priority,DoseUnit,DoseQtyInfo,InstrDesc,FreqDesc)=""
	s:PriorRowID'="" Priority=$P(^OECPR(PriorRowID),"^",2)
	s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
	s OrderName=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",2)
	s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	s:DoseUnitDr'="" DoseUnit=$P(^CT("UOM",DoseUnitDr),"^",2)
	s DoseUnit=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUnit,langid)
	s DoseQtyInfo=DoseQty_DoseUnit
	s:+InstrDr'=0 InstrDesc=$p(^PHCIN(InstrDr),"^",2)
	s InstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",InstrDesc,langid)
	s:FreqDr'="" FreqDesc=$P($g(^PHCFR(FreqDr)),"^",3)
	s FreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FreqDesc,langid)
	s ^CacheTemp(repid,ind) = $lb(ID,SeqNo,Priority,OrderName,DoseQtyInfo,InstrDesc,FreqDesc,LinkSeqNo,GroupSign)
	s ind = ind + 1
	q
}

/// 获取皮试医嘱的关联治疗用药
/// OutPut:以^分割的医嘱ID串
/// 	w ##Class(web.DHCOEOrderGuideAllergy).GetLinkTreatOrdList("552||26")
ClassMethod GetLinkTreatOrdList(OEOrdRowID As %String) As %String
{
	s EpisodeID=$P(^OEORD(+OEOrdRowID),"^",1)
	s AdmLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospDr=$P(^CTLOC(AdmLoc),"^",22)
	s OrderArcimRowID=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",2)
	s OrderStartDate=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",9)
	s OrderStartTime=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",10)
	s OrderInstrRowid=$p($g(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),2)),"^",7)
	if (OrderInstrRowid=""){
		q ""
	}
	s SkinTestInstr=..%GetConfig("SkinTestInstr",HospDr)
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	if (SkinTestInstr'[("^"_OrderInstrRowid_"^")){
		q ""
	}
	s OrdLinkRowId=$p($g(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),11)),"^",39)
	if (OrdLinkRowId'=""){
		s SubOrdStr=##class(web.DHCDocOrderCommon).GetLinkOrdItem(OrdLinkRowId)
		s OrdStr=OrdLinkRowId_"^"_SubOrdStr
	}else{
		s SubOrdStr=##class(web.DHCDocOrderCommon).GetLinkOrdItem(OEOrdRowID)
		if (SubOrdStr'=""){
			s OrdStr=OEOrdRowID_"^"_SubOrdStr
		}else{
			s OrdStr=OEOrdRowID
		}
	}
	k RelatedArcimList
	for i=1:1:$L(OrdStr,"^"){
		s OrdRowID=$P(OrdStr,"^",i)
		/*
		过敏源ID^过敏源描述^项目ID(医嘱项ID)^项目描述(医嘱项描述)^项目类型(A-医嘱项/G-通用名)^
		脱敏标志(Y/N)^免试标志(Y/N)^控制例外(Y/N)^开始日期($zd)^截止日期($zd)
		*/
		
		s SkinTestList=##class(PHA.FACE.OUT.Com).GetSkinTestInfoForNur(OrdRowID,HospDr)
		continue:(SkinTestList="")
		for j=1:1:$L(SkinTestList,"!!") {
			s OneSkinTestList=$P(SkinTestList,"!!",j)
			s itemType=$P(OneSkinTestList,"^",5)
			s itemId=$P(OneSkinTestList,"^",3)
			s startDate=$P(OneSkinTestList,"^",9)
			s endDate=$P(OneSkinTestList,"^",10)
			s SkinValidTime=$P(OneSkinTestList,"^",11)		;皮试有效时间
			i SkinValidTime="" s SkinValidTime=72
			
			if (startDate'="")&&(startDate>OrderStartDate){
				continue
			}
			if (endDate'="")&&(endDate<OrderStartDate){
				continue
			}
			s RelatedArcimList(itemType,itemId)=SkinValidTime
		}
	}
	s GenericId=""
	for {
		s GenericId=$O(RelatedArcimList("G",GenericId))
		q:(GenericId="")
		s DrgFormRowid=""
		for {
			s DrgFormRowid=$O(^PHCD(0,"Gener",GenericId,DrgFormRowid))
			q:(DrgFormRowid="")
			s ArcimSubscript=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",0))
			continue:(ArcimSubscript="")
			s ArcimVersion=$O(^ARCIM(0,"PHCDF",DrgFormRowid_"||1",ArcimSubscript,0))
			s ArcimDr=ArcimSubscript_"||"_ArcimVersion
			continue:($D(RelatedArcimList("A",ArcimDr)))
			m RelatedArcimList("A",ArcimDr)=RelatedArcimList("G",GenericId)
		}
	}
	if '$D(RelatedArcimList("A",OrderArcimRowID)){
		s RelatedArcimList("A",OrderArcimRowID)="72^^^^"
	}
	s LinkTreatOrdList=""
	s OrderStartDateNum=OrderStartDate*24*3600+OrderStartTime
	s ArcimDr=""
	for {
		s ArcimDr=$O(RelatedArcimList("A",ArcimDr))
		q:(ArcimDr="")
		s SkinValidTime=$P(RelatedArcimList("A",ArcimDr),"^",1)
		//只检索有效皮试时间内的用药医嘱记录
		s SttDat=OrderStartDate-((SkinValidTime\24)+$CASE((SkinValidTime#24)>0,1:1,:0))
		for{
			s SttDat=$O(^OEORDi(0,"ARCIM",+OEOrdRowID,ArcimDr,SttDat))
			q:(SttDat="")
			s child=0
			for {
				s child=$O(^OEORDi(0,"ARCIM",+OEOrdRowID,ArcimDr,SttDat,child))
				q:(child="")
				continue:('$D(^OEORD(+OEOrdRowID,"I",child,1)))
				s ActionCode=""
				s ActionDR=$p($g(^OEORD(+OEOrdRowID,"I",child,11)),"^",21)
				if (ActionDR'=""){
					s ActionCode=$p($g(^OEC("ACT",ActionDR)),"^",1)
				}
				s skintest=$p($g(^OEORD(+OEOrdRowID,"I",child,5)),"^",2)
				continue:(skintest'="Y")&&(ActionCode'="TM")&&(ActionCode'="YX")
				continue:'##class(DHCDoc.Order.Common).IsValidOrd(+OEOrdRowID_"||"_child)
				s OrderInstrRowid=$p($g(^OEORD(+OEOrdRowID,"I",child,2)),"^",7)
				continue:(SkinTestInstr[("^"_OrderInstrRowid_"^"))
				s SttTime=$p(^OEORD(+OEOrdRowID,"I",child,1),"^",10)
				s OrdLinkRowId=$p($g(^OEORD(+OEOrdRowID,"I",child,11)),"^",39)
				if (OrdLinkRowId'=""){
					s LinkSttDat=$p(^OEORD(+OEOrdRowID,"I",$P(OrdLinkRowId,"||",2),1),"^",9)
					s LinkSttTime=$p(^OEORD(+OEOrdRowID,"I",$P(OrdLinkRowId,"||",2),1),"^",10)
					s SttDateStr=LinkSttDat*24*3600+LinkSttTime
				}else{
					s SttDateStr=SttDat*24*3600+SttTime
				}
				s ValidTimeFlag=1
				if (($ZABS(OrderStartDateNum-SttDateStr)/3600)>SkinValidTime){
					s ValidTimeFlag=0
				}
				continue:(ValidTimeFlag=0)
				;已经置过皮试结果的治疗用药--护理组反馈，有可能已经置过皮试结果的药品可能会修改结果
				s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(+OEOrdRowID,child)
				/*
				if (SkinAbnorm'=""){
					continue
				}
				*/
				if (LinkTreatOrdList'=""){
					s LinkTreatOrdList=LinkTreatOrdList_"^"_(+OEOrdRowID_"||"_child)
				}else{
					s LinkTreatOrdList=(+OEOrdRowID_"||"_child)
				}
				
			}
		}
	}
	q LinkTreatOrdList
}

/// 获取治疗医嘱的关联皮试用医嘱
/// OutPut:以^分割的医嘱ID串
/// 	w ##Class(web.DHCOEOrderGuideAllergy).GetLinkSkinOrdList("552||24")
ClassMethod GetLinkSkinOrdList(OEOrdRowID As %String) As %String
{
	s EpisodeID=$P(^OEORD(+OEOrdRowID),"^",1)
	s AdmLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s HospDr=$P(^CTLOC(AdmLoc),"^",22)
	s OrderStartDate=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",9)
	s OrderStartTime=$p(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1),"^",10)
	s CurrDateStr=OrderStartDate*24*3600+OrderStartTime
	s OrderInstrRowid=$p($g(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),2)),"^",7)
	if (OrderInstrRowid=""){
		q ""
	}
	s SkinTestInstr=..%GetConfig("SkinTestInstr",HospDr)
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	if (SkinTestInstr[("^"_OrderInstrRowid_"^")){
		q ""
	}
	s SkinTest=$p($g(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),5)),"^",2)
	q:(SkinTest'="Y") ""
	
	s ArcimRowId=$p($g(^OEORD(+OEOrdRowID,"I",$P(OEOrdRowID,"||",2),1)),"^",2)
	s OrderSttDateStr=..%ZD(OrderStartDate)_" "_..%ZT(OrderStartTime,2)
	s SkinControlInfo=..GetArcimSkinControlInfo(ArcimRowId,OrderSttDateStr,HospDr)
	s SkinValidTime=$P(SkinControlInfo,"^",1)		;皮试有效时间
	i SkinValidTime="" s SkinValidTime=72
	
	///获取当前医嘱项的需验证医嘱项列表
	k RelatedArcimList
	d ..BuildRelatedArcimList(EpisodeID,ArcimRowId,OrderSttDateStr,.RelatedArcimList)
	if '$D(RelatedArcimList){
		q ""
	}
	s LinkSkinOrdList=""
	s ArcimDr=0
	for {
		s ArcimDr=$O(RelatedArcimList("A",ArcimDr))
		q:(ArcimDr="")
		s SttDat=+OrderStartDate-((SkinValidTime\24)+$CASE((SkinValidTime#24)>0,1:1,:0))
		for{
			s SttDat=$O(^OEORDi(0,"ARCIM",+OEOrdRowID,ArcimDr,SttDat))
			q:(SttDat="")
			s child=0
			for {
				s child=$O(^OEORDi(0,"ARCIM",+OEOrdRowID,ArcimDr,SttDat,child))
				q:(child="")
				continue:('$D(^OEORD(+OEOrdRowID,"I",child,1)))
				s SkinTest=$p($g(^OEORD(+OEOrdRowID,"I",child,5)),"^",2)
				continue:(SkinTest'="Y")
				s TItemStatCode=""
				s itemStatDr = $p(^OEORD(+OEOrdRowID,"I",child,1),"^",13) 
				s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
				if (AdmType="I"){
					continue:(("VED")'[TItemStatCode)
				}else{
					continue:(("VE")'[TItemStatCode)
				}
				
				s SttTime=$p(^OEORD(+OEOrdRowID,"I",child,1),"^",10)
				s SttDateStr=SttDat*24*3600+SttTime
				s ValidTimeFlag=1
				if (((CurrDateStr-SttDateStr)/3600)>SkinValidTime){
					s ValidTimeFlag=0
				}
				///仅显示【皮试有效时间】内的皮试医嘱或治疗医嘱
				if (ValidTimeFlag=0){
					continue
				}
				s str2=$G(^OEORD(+OEOrdRowID,"I",child,2))
				s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
				s skintest=$p($g(^OEORD(+OEOrdRowID,"I",child,5)),"^",2)
				s isSkinTestInstrFlag=0
				if (instrDr'="")&&(SkinTestInstr'[("^"_instrDr_"^")){
					continue
				}
				
				if (LinkSkinOrdList'=""){
					s LinkSkinOrdList=LinkSkinOrdList_"^"_(+OEOrdRowID_"||"_child)
				}else{
					s LinkSkinOrdList=(+OEOrdRowID_"||"_child)
				}
			}
		}
	}
	
	q LinkSkinOrdList
}

/// 判断皮试阳性时是否自动插入过敏记录
/// Output:Y:需要插入过敏记录；N:不需要插入过敏记录
ClassMethod GetAutoInsertAllergiesFlag(OrdItmRowId As %String) As %String
{
	q:(OrdItmRowId="") "N"
	s ArcimRowid=$P(^OEORD(+OrdItmRowId,"I",+$P(OrdItmRowId,"||",2),1),"^",2)
	q:(ArcimRowid="") "N"
	//药房接口,【皮试阳性不生产过敏记录】
	s NoAllergy=$lts(##class(PHA.FACE.OUT.Com).GetDrugProp("PHCDrgFormExt",ArcimRowid,$lb("PHCDFNoAllergy")),"")
	i (NoAllergy="Y"){
		q "N"
	}
	q "Y"
}

/// 获取药品皮试备注为皮试阴性的治疗用药医嘱串 皮试备注为YX的视为阴性 TM阳性
/// input:OrdItmRowId 皮试医嘱ID, AbnormFlag 皮试结果标志
/// OutPut:以^分割的医嘱ID串
/// w ##Class(web.DHCOEOrderGuideAllergy).GetLinkValidTreatOrdList("552||26")
ClassMethod GetLinkValidTreatOrdList(OrdItmRowId, AbnormFlag = "N")
{
	s RetOrdItemStr=""
	s OrdItemIDStr=##Class(web.DHCOEOrderGuideAllergy).GetLinkTreatOrdList(OrdItmRowId)
	for i=1:1:$L(OrdItemIDStr,"^"){
		s OrdItemID=$P(OrdItemIDStr,"^",i)
		continue:OrdItemID=""
		continue:'##class(DHCDoc.Order.Common).IsValidOrd(OrdItemID)
		s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(+OrdItemID,$p(OrdItemID,"||",2))
		if SkinAbnorm=""{
			s ActionDR=$p($g(^OEORD(+OrdItemID,"I",$p(OrdItemID,"||",2),11)),"^",21)
			if (ActionDR'=""){
				s ActionCode=$p($g(^OEC("ACT",ActionDR)),"^",1)
				s:ActionCode="YX" SkinAbnorm="N"
				s:ActionCode="TM" SkinAbnorm="Y"
			}
		}
		continue:AbnormFlag'=SkinAbnorm
		i RetOrdItemStr="" s RetOrdItemStr=OrdItemID
		e  s RetOrdItemStr=RetOrdItemStr_"^"_OrdItemID
	}
	Q RetOrdItemStr
}

}
