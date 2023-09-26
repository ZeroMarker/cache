/// creator:tanjishan
/// date:2020-03-31
/// desc:和东华内部系统的接口类【主要是提供给其他产品组的接口】,仅检查检验申请单相关信息，使用说明详见《his标准接口文档》
Class DHCDoc.Interface.Inside.AppReportService Extends %RegisteredObject [ ProcedureBlock ]
{

/// 根据医嘱项内容获取该医嘱项对应的警示信息、部位、体位、后处理信息
/// w ##Class(DHCDoc.Interface.Inside.AppReportService).GetPartJson("11571||1",2)
ClassMethod GetPartJson(ArcimRowID As %String, LogonHospID As %String) As %String
{
	q:(ArcimRowID="") ""
	k JsonArr
	s Warning=##Class(web.DHCAPPExaReportQuery).jsonItemTemp(ArcimRowID,LogonHospID)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(Warning,.WarningArr)
	m JsonArr("Waining")=WarningArr
	
	s ExistLinkPart=##Class(web.DHCAPPExaReportQuery).isExistLinkPart(ArcimRowID,"",LogonHospID)
	if (ExistLinkPart=0){
		s JsonStr=##Class(DHCDoc.Util.FromJSON).GetArrJson(.JsonArr)
		q JsonStr
	}
	//公共体位信息
	s PositionParaNum=$L(^oddDEF("web.DHCAPPExaReportQuery","m","jsonExaPosition",27),",")
	if (PositionParaNum=2){
		s PublicExaPositionJson=##Class(web.DHCAPPExaReportQuery).jsonExaPosition(ArcimRowID,LogonHospID)
	}else{
		s PublicExaPositionJson=##Class(web.DHCAPPExaReportQuery).jsonExaPosition(ArcimRowID,LogonHospID,"")
	}
	k ExaPositionArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PublicExaPositionJson,.ExaPositionArr)
	m JsonArr("PublicPositionInfo")=ExaPositionArr
	
	
	//部位信息
	s PYCode=""	;检索信息
	s PartJson=##Class(web.DHCAPPExaReportQuery).jsonGetPartTreeByArc(ArcimRowID,PYCode,"",LogonHospID)
	k PartJsonArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PartJson,.PartJsonArr)
	s i=0
	for {
		s i=$O(PartJsonArr(i))
		q:(i="")
		k PartJsonArr(i,"id")
		s j=0
		for {
			s j=$O(PartJsonArr(i,"children",j))
			q:(j="")
			s PartID=$G(PartJsonArr(i,"children",j,"id"))
			
			if (PositionParaNum=2){
				s ExaPositionJson=##Class(web.DHCAPPExaReportQuery).jsonExaPosition(ArcimRowID,LogonHospID)
			}else{
				s ExaPositionJson=##Class(web.DHCAPPExaReportQuery).jsonExaPosition(ArcimRowID,LogonHospID,PartID)
			}
			//如果维护了单独的体位信息，再输出
			if (PublicExaPositionJson'=ExaPositionJson){
				k ExaPositionArr
				d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ExaPositionJson,.ExaPositionArr)
				m PartJsonArr(i,"children",j,"ExaPosit")=ExaPositionArr
			}
		}
	}
	m JsonArr("PartInfo")=PartJsonArr
	///后处理信息
	s ExaDispJson=##Class(web.DHCAPPExaReportQuery).jsonExaDisp(ArcimRowID,LogonHospID)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ExaDispJson,.ExaDispArr)
	m JsonArr("ExaDispJson")=ExaDispArr
	s JsonStr=##Class(DHCDoc.Util.FromJSON).GetArrJson(.JsonArr)
	q JsonStr
}

/// 根据待保存医嘱列表获取是否需要填写申请单明细标志，获取默认主诉、现病史、生命体征信息
/// w ##Class(DHCDoc.Interface.Inside.AppReportService).GetAppReportInfo(35,"11571||1^X^3^2020-10-30^16:47:03^^345^441^33^^^^^1^64^1^^^^1^N^^Y^^^^^^^N^^^^^^^^^^^^^^^^2020-10-30^16:46:52^N^^^^^N^^76^^N^^^^^^",1,777)
ClassMethod GetAppReportInfo(EpisodeID As %String, OrderItemStr As %String, DoctorID As %String, LocID As %String) As %String
{
	s ItemServiceARCIMStr=##Class(web.DHCDocOrderCommon).GetItemServiceARCIMStrMethod(EpisodeID,OrderItemStr,DoctorID,LocID)
	s ManualItemStr=$P(ItemServiceARCIMStr,$C(2))
	s ARCIMStr=$P(ManualItemStr,"!",2)
	s AppReportFlag="N"
	if (ARCIMStr'=""){
		s AppReportFlag="Y"
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write("{""AppReportFlag"":"""_AppReportFlag_""",")
	s ExaReqHisSignInfo=##Class(web.DHCAPPExaReportQuery).jsonExaReqHisSign("",EpisodeID)
	//去掉两边的大括号
	s ExaReqHisSignInfo=$E(ExaReqHisSignInfo,2,$Length(ExaReqHisSignInfo))
	s ExaReqHisSignInfo=$E(ExaReqHisSignInfo,1,$Length(ExaReqHisSignInfo)-1)
	d Stream.Write(ExaReqHisSignInfo)
	
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/*
(第一组医嘱的部位信息)部位ID+"B"+体位ID+"A"+部位ID+"B"+体位ID+"A"+....(下一组部位及体位信息)+"^"+后处理ID+"^"+SeqNo
+$C(2)+
...（第二组医嘱的申请单信息）
+$C(2)+
...（第三组医嘱的申请单信息）
+$C(1)+主诉+$C(1)+现病史+$C(1)+体征+$C(1)+检查目的

测试:"308BA427B^^1"_$C(1)_"ni"_$C(1)_"hao"_$C(1)_"a"_$C(1)_"!"

*/
/// 在调用审核医嘱之前，生成申请单信息;
/// Input		EpisodeID:就诊ID
/// 			OrderItemStr:待保存医嘱信息串
/// 			DoctorID:CT_Careprov表ID,登录医护
/// 			LocID：登录科室
/// 			LogonHospID:登录HospDr
/// 			AppListData:申请单信息
/// Output 		-100：返回错误
/// 				OrderItemStr：返回正常
/// w ##Class(DHCDoc.Interface.Inside.AppReportService).CreatAppReport(1000,"27135||1^X^3^2020-03-31^16:47:03^^345^441^33^^^^^1^64^1^^^^1^N^^Y^^^^^^^N^^^^^^^^^^^^^^^^2020-03-31^16:46:52^N^^^^^N^^76^^N^^^^^^",1,777,"308BA427B^^1"_$C(1)_"ni"_$C(1)_"hao"_$C(1)_"a"_$C(1)_"!",.Msg)
ClassMethod CreatAppReport(EpisodeID As %String, OrderItemStr As %String, DoctorID As %String, LocID As %String, AppListData As %String, LogonHospID As %String, ByRef ErrMsg) As %String
{
	s ItemServiceARCIMStr=##Class(web.DHCDocOrderCommon).GetItemServiceARCIMStrMethod(EpisodeID,OrderItemStr,DoctorID,LocID)
	s ManualItemStr=$P(ItemServiceARCIMStr,$C(2))
	s AutoItemStr=$P(ItemServiceARCIMStr,$C(2),2)
	
	///
	TS
	s AutoGenresult=""
	if (AutoItemStr'=""){
		s AutoGenresult=##Class(web.DHCAPPInterface).InsExaReqNo(AutoItemStr)
		if (AutoGenresult<0){
			TRO
			s ErrMsg="-100^插入自动生成申请单项目失败:"_AutoGenresult_"。"
			q -100
		}
	}
	s UserDr=$O(^SSU("SSUSR",0,"CTPCP",DoctorID,0))
	s ExaSym=$P(AppListData,$C(1),2)	;主诉
	s ExaDisHis=$P(AppListData,$C(1),3)	;现病史
	s ExaPhySig=$P(AppListData,$C(1),4)	;体征
	s ExaPurp=$P(AppListData,$C(1),5)	;检查目的
	s ManualGenresult=""
	if (ManualItemStr'=""){
		s ErrMsg=""
		s TotalListData=""
		s Length=$L(ManualItemStr,"@")
		for i=1:1:Length {
			s OneManualItemStr=$P($P(ManualItemStr,"!",2),"@",i)
			s RecDepRowid=$P(OneManualItemStr,"^",2)
			s startdate=$P(OneManualItemStr,"^",3)
			s ARCIMRowid=$P(OneManualItemStr,"^",4)
			s OrderSeqNo=$P(OneManualItemStr,"^",5)
			//获取对应的行医嘱信息
			d GetOrderStrBySeqNo
			s RecLocDr=$p(OrdItem,"^",8)
			s DepProcNotes=$p(OrdItem,"^",11)
			s NotifyClinician=$p(OrdItem,"^",30)
			s PartInfo=""
			//b ;001
			s ExistLinkPart=##Class(web.DHCAPPExaReportQuery).isExistLinkPart(ARCIMRowid,"",LogonHospID)
			//b ;002
			if (ExistLinkPart="0"){
				//获取单部位检查项目和部位,可能存在无部位医嘱，这里要做保护
				s PartID=""
				s TraID=""
				f  s TraID=$o(^DHCAPPTRA(0,"Arc",ARCIMRowid,TraID)) q:(TraID="")||(PartID'="")  d
				.s HospDr=$p(^DHCAPPTRA(TraID),"^",5) 
				.q:(HospDr'="")&&(LogonHospID'=HospDr)  //-cy 网络 门诊先屏蔽
				.s CH=""
				.f  s CH=$o(^DHCAPPTRA(0,"Arc",ARCIMRowid,TraID,CH)) q:(CH="")||(PartID'="")  d
				..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
		        //b ;003
				if (PartID'=""){
					s PartInfo=PartID_"B^^"
				}
			}else{
				///获取对应的部位信息
				d GetAppPartInfo
				if (PartInfo=""){
					s ErrMsg=ErrMsg_",编号"_OrderSeqNo_"未检索到对应的部位信息。"
					q
				}
			}
			
			//后处理
			s ExaDispID=$p(PartInfo,"^",2)
			//部位体位列表
			s PartList=$p(PartInfo,"^",1)
			
			for j=1:1:$L(PartList,"A"){
				s OnePartList=$P(PartList,"A",j)
				s ExaPartID=$P(OnePartList,"B",1)	/// 部位ID
				s ExaPosiID=$P(OnePartList,"B",2)	/// 体位ID
				
				s ListData = EpisodeID_"^"_RecLocDr_"^"_NotifyClinician_"^"_ExaPurp_"^"_UserDr
				s ListData = ListData_"^"_ExaDisHis_"^"_ExaPhySig_"^"_LocID_"^"_ExaSym_"^"_"N"
				s ListData = ListData_"#"_ARCIMRowid_"^"_ExaPosiID_"^"_ExaPartID_"^"_ExaDispID_"^"_startdate
				s ListData = ListData_"^"_OrderSeqNo_"^"_NotifyClinician_"^"_DepProcNotes
				
				if (TotalListData=""){
					s TotalListData=ListData
				}else{
					s TotalListData=TotalListData_"!!"_ListData
				}
			}
		}
		if (ErrMsg'=""){
			TRO
			s ErrMsg="校验检查附加数据失败:"_ErrMsg_"。"
			q -100
		}
		///这个值目前用于暂存其他项目，暂时传空
		s pid=""
		s ManualGenresult=##Class(web.DHCAPPExaReport).saveDoc(pid, TotalListData)
		if (ManualGenresult<0){
			TRO
			s ErrMsg="插入手工生成申请单项目失败:"_ManualGenresult_"。"
			q -100
		}
	}
	
	TC
	s AppGenresult=AutoGenresult
	if (ManualGenresult'=""){
		if (AppGenresult=""){
			s AppGenresult=ManualGenresult
		}else{
			s AppGenresult=AppGenresult_"@"_ManualGenresult
		}
	}
	if (AppGenresult'=""){
		///把生成的申请单信息回写到OrderItemStr中
		k AppGenresultList
		for i=1:1:$L(AppGenresult,"@") {
			s OneAppGenresult=$P(AppGenresult,"@",i)
			s ApplyArcId=$P(OneAppGenresult,"^",1)
			s OrderSeqNo=$P(OneAppGenresult,"^",3)
			s AppGenresultList(OrderSeqNo)=ApplyArcId
		}
		for i=1:1:$L(OrderItemStr,$c(1)) {
			s OrdItem=$p(OrderItemStr,$c(1),i)
			continue:OrdItem=""
			s ARCIMRowid=$p(OrdItem,"^",1)
			continue:ARCIMRowid=""
			s OrderSeqNo=$p(OrdItem,"^",20)
			s ApplyArcId=$G(AppGenresultList(OrderSeqNo))
			continue:(ApplyArcId="")
			s $p(OrdItem,"^",59)=ApplyArcId
			s $p(OrderItemStr,$c(1),i)=OrdItem
		}
	}
	q OrderItemStr
GetOrderStrBySeqNo
	s OrdItem=""
	for k=1:1:$L(OrderItemStr,$c(1)) {
		s myOrdItem=$p(OrderItemStr,$c(1),k)
		continue:myOrdItem=""
		s myARCIMRowid=$p(myOrdItem,"^",1)
		continue:myARCIMRowid=""
		s myOrderSeqNo=$p(myOrdItem,"^",20)
		continue:(myOrderSeqNo'=OrderSeqNo)
		s OrdItem=myOrdItem
	}
	q
GetAppPartInfo
	s PartInfo=""
	s myPatInfoList=$P(AppListData,$C(1),1)
	for k=1:1:$L(myPatInfoList,$c(2)) {
		s myPatInfo=$p(myPatInfoList,$c(2),k)
		
		s myOrderSeqNo=$p(myPatInfo,"^",3)
		continue:(myOrderSeqNo'=OrderSeqNo)
		s PartInfo=myPatInfo
		q
	}
	q
}

}
