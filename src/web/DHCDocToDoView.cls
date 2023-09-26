/// 名称:     web.DHCDocToDoView
/// 描述:     医疗待办
/// 编写者:  谭吉善
/// 编写日期: 2020.10.16
Class web.DHCDocToDoView Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 初始化医生医疗待办列表
/// w ##Class(web.DHCDocToDoView).GetDocToDoList(3884,"14/12/2020","12262^131^134")
/// Output	JSON
ClassMethod GetDocToDoList(EpisodeID As %String, QueryDate As %String, SessionStr As %String) As %String
{
	s PatientID=$P(^PAADM(+EpisodeID),"^",1)
	s mradm=$P(^PAADM(+EpisodeID),"^",61)
	Set langid=..%LanguageID()
	i QueryDate="" s QueryDate=..%SysDate()
	e  s QueryDate=..%ZDH(QueryDate)
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocDr)
	s DateNum=##CLass(DHCDoc.DHCDocConfig.DocToDo).GetDateNum(HospitalId)
	s TimeRangeNum=##CLass(DHCDoc.DHCDocConfig.DocToDo).InitTimeRangeList(.TimeRangeList,HospitalId)
	//表格列的时间范围
	s StartDate=QueryDate-(DateNum\2)-$case(DateNum#2,0:0,:1)-1
	s EndDate=QueryDate+(DateNum\2)-1
	//初始化表格数据格式样式
	k TableList
	for date=StartDate:1:EndDate {
		s TableList(date)=""
		for i=1:1:TimeRangeNum {
			s TimeRange=TimeRangeList(i)
			s RangeStartTime=..%ZTH($P(TimeRange,"-"))
			s TableList(date,RangeStartTime,"TimeRange")=TimeRange
		}
	}
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
	if (OrderRowid'="") {
		//遍历医嘱
		s OrdStartDat=StartDate-30
		for {
			s OrdStartDat=$O(^OEORDi(0,"StDtTm1",OrderRowid,OrdStartDat))
			q:(OrdStartDat="")||(OrdStartDat>EndDate)
			s OrdStartTime=""
			for {
				s OrdStartTime=$O(^OEORDi(0,"StDtTm1",OrderRowid,OrdStartDat,OrdStartTime))
				q:(OrdStartTime="")
				s child=""
				for {
					s child=$O(^OEORDi(0,"StDtTm1",OrderRowid,OrdStartDat,OrdStartTime,child))
					q:(child="")
					if ('$D(^OEORD(OrderRowid,"I",child,1))){
						continue
					}
					s statcode=""
					s itemstat=$p($g(^OEORD(OrderRowid,"I",child,1)),"^",13)
					i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
					continue:(statcode="U")
					s StopDate = $p(^OEORD(OrderRowid,"I",child,3),"^",34)
					if (StopDate'="")&&(StopDate<StartDate)&&("DC"[statcode){
						continue
					}
					s OrdRowID=OrderRowid_"||"_child
					///初始化每个医嘱的待办信息
					d ..ExecTODOListFuncByOrd(OrdRowID,SessionStr,.TableList)
				}
			}
		}
	}
	//遍历日期
	for date=StartDate:1:EndDate {
		d ..ExecTODOListFuncByDate(EpisodeID,date,SessionStr,.TableList)
	}
	//将数组转换成按时间为第一维度的数组
	K NewTableList
	s date=""
	for {
		s date=$O(TableList(date))
		q:(date="")
		s RangeStartTime=""
		for {
			s RangeStartTime=$O(TableList(date,RangeStartTime))
			q:(RangeStartTime="")
			s TimeRange=TableList(date,RangeStartTime,"TimeRange")
			s NewTableList(RangeStartTime,TimeRange,date)=""
			m NewTableList(RangeStartTime,TimeRange,date)=TableList(date,RangeStartTime)
			k NewTableList(RangeStartTime,TimeRange,date,"TimeRange")
		}
	}
	
	///输出JSON
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[{")
	d Stream.Write("""Columns"":[")
	d Stream.Write("{""field"":""Date_0"",""title"":""""}")
	s date=0,count=0
	for {
		s date=$O(TableList(date))
		q:(date="")
		s count=count+1
		s WeekDate=$case($zd(date,10),1:"星期一",2:"星期二",3:"星期三",4:"星期四",5:"星期五",6:"星期六",0:"星期日",:"")
		s WeekDate=##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp",WeekDate)
		if (date=..%SysDate()){
			s ToDayFlag="Y"
		}else{
			s ToDayFlag="N"
		}
		s DateTitle=..%ZD(date)
		s DateTitle=DateTitle_" "_WeekDate
		
		d Stream.Write(",{""field"":""Date_"_count_""",""title"":"""_DateTitle_"""}")
	}
	d Stream.Write("],")
	d Stream.Write("""rows"":[")
	s rowCount=0
	s Index=""
	for {
		s Index=$O(NewTableList(Index))
		q:(Index="")
		s TimeRange=$O(NewTableList(Index,0))
		q:(TimeRange="")
		s count=0
		
		s rowCount=rowCount+1
		if (rowCount>1){d Stream.Write(",")}
		d Stream.Write("{""Date_"_count_""":"""_TimeRange_"""")
		for date=StartDate:1:EndDate {
			s Content=""
			s count=count+1
			d Stream.Write(",")
			s FuncNo=""
			for {
				s FuncNo=$O(NewTableList(Index,TimeRange,date,FuncNo))
				q:(FuncNo="")
				s Msg=""
				for {
					s Msg=$O(NewTableList(Index,TimeRange,date,FuncNo,Msg))
					q:(Msg="")
					s OrdList=NewTableList(Index,TimeRange,date,FuncNo,Msg,"OrdList")
					//s OrdList=$replace(OrdList,"@","^")
					s StyleInfo=NewTableList(Index,TimeRange,date,FuncNo,Msg,"Style")
					s FunLevel=$P(StyleInfo,"^",1)
					s FunPrefix=$P(StyleInfo,"^",2)
					s FunURL=$P(StyleInfo,"^",3)
					s FunOutCss=$P(StyleInfo,"^",4)
					s FunInCss=$P(StyleInfo,"^",5)
					if $e(Msg,$L(Msg),$L(Msg))=" "{
						s Text=$e(Msg,1,$L(Msg)-1)
					}else{
						s Text=Msg
					}
					s OrdNum=""
					if (OrdList'=""){
						s OrdNum=$L(OrdList,"@")_##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp","项")
					}
					if (FunPrefix'=""){
						s FunPrefix="【"_##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp",FunPrefix)_"】"
					}
					for i=2:1:FunLevel {
						s FunPrefix="&emsp;&emsp;"_##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp",FunPrefix)
					}
					s Text=FunPrefix_OrdNum_Text
					
					
					if (FunURL'=""){
						s FunURL=$replace(FunURL,"@OrdList",OrdList)
						s FunURL=$replace(FunURL,"@DocToInfoMsg",FunPrefix)
						s FunURL=##Class(web.DHCDoc.OP.AjaxInterface).replaceLinkParams(FunURL,EpisodeID,PatientID,mradm)
						if ($ZCVT(FunURL,"U")[".HTML")||($ZCVT(FunURL,"U")[".CSP"){
							s iconHTML="<A HREF=\""#\"" id=\""TODO_Msg_"_count_"_Id\"" onClick=\""showModal('"_FunURL_"',false,'top=40,left=40');\"" style=\"""_FunInCss_"\"">"_Text_"</A>"
						}else{
							s iconHTML="<A HREF=\""#\"" id=\""TODO_Msg_"_count_"_Id\"" onClick=\"""_FunURL_"\"" style=\"""_FunInCss_"\"">"_Text_"</A>"
						}
						
					}else{
						s iconHTML="<span id=\""TODO_Msg_"_count_"_Id\"" style=\"""_FunInCss_"\"">"_Text_"</span>"
					}
					if (Content=""){
						s Content=iconHTML
					}else{
						s Content=Content_"<br>"_iconHTML
					}
				}
			}
			d Stream.Write("""Date_"_count_""":"""_Content_"""")
		}
		d Stream.Write("}")
		
	}
	
	
	d Stream.Write("]")
	d Stream.Write("}]")
	q Stream.Read()
}

/// 按照日期输出消息卡片，输出卡片的方式主要取决于处理效率
ClassMethod ExecTODOListFuncByDate(EpisodeID As %String, Querydate As %String, SessionStr As %String, ByRef TableList) As %String [ ProcedureBlock = 0 ]
{
	n (EpisodeID,Querydate,SessionStr,TableList)
	s OrdRowID=$o(^OEORD(0,"Adm",EpisodeID,0))
	if (OrdRowID=""){
		q
	}
	s PatientID=$P(^PAADM(+EpisodeID),"^",1)
	s mradm=$P(^PAADM(+EpisodeID),"^",61)
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocDr)
	k TODOListFunc
	s TODOListNum=##CLass(DHCDoc.DHCDocConfig.DocToDo).InitTODOListFunc(.TODOListFunc,HospitalId)
	s i=0
	for {
		s i=$O(TODOListFunc(i))
		q:(i="")
		s OneTODOListFunc=$g(TODOListFunc(i))
		continue:(OneTODOListFunc="")
		//配置编号^级别^前缀^后缀处理方法^URL^外部样式^内部样式^子类列表(!分割)^用法列表(!分割)^运行方式
		s RunType=$P(OneTODOListFunc,"^",10)
		if (RunType'="ByDate"){
			continue
		}
		
		s FuncNo=$P(OneTODOListFunc,"^",1)
		s FunLevel=$P(OneTODOListFunc,"^",2)
		s FunPrefix=$P(OneTODOListFunc,"^",3)
		s Func=$P(OneTODOListFunc,"^",4)
		s FunURL=$P(OneTODOListFunc,"^",5)
		s FunOutCss=$P(OneTODOListFunc,"^",6)
		s FunInCss=$P(OneTODOListFunc,"^",7)
		s FunSubCatStr=$P(OneTODOListFunc,"^",8)
		s FunInstrStr=$P(OneTODOListFunc,"^",9)
		s LimitInfo=FunSubCatStr_"^"_FunInstrStr
		s Expression=$tr(Func,"&","""")
		//单条医嘱的待提醒列表
		s ShowInfo=""
		s Expression=$replace(Expression,"@episodeID",""""_$g(EpisodeID)_"""")
		s Expression=$replace(Expression,"@Querydate",""""_$g(Querydate)_"""")
		s Expression=$replace(Expression,"@SessionStr",""""_$g(SessionStr)_"""")
		s Expression=$replace(Expression,"@LimitInfo",""""_$g(LimitInfo)_"""")
		s Expression="s ShowInfo="_Expression
		try{
			x Expression
		}catch(e){
			b ;"err"
			continue
		}
		if (ShowInfo=""){
			continue
		}
		if i=8,Querydate=(+$h+1) b //90
		for j=1:1:$L(ShowInfo,$C(2)){
			s OneShowInfo=$P(ShowInfo,$C(2),j)
			s ShowDate=$P(OneShowInfo,$C(1),1)
			s ShowDate=..%ZDH(ShowDate)
			s ShowTime=$P(OneShowInfo,$C(1),2)
			s ShowTime=..%ZTH(ShowTime)
			s Msg=$P(OneShowInfo,$C(1),3)
			continue:('$D(TableList(ShowDate)))
			s OrdList=$P(OneShowInfo,$C(1),4)
			if $D(TableList(ShowDate,ShowTime)){
				s RangeStartTime=ShowTime
			}else{
				s RangeStartTime=$O(TableList(ShowDate,ShowTime),-1)
				i RangeStartTime="" s RangeStartTime=$O(TableList(ShowDate,""),-1)
			}
			s OrdList=$replace(OrdList,"^","@")
			s FunURL=##Class(web.DHCDoc.OP.AjaxInterface).replaceLinkParams(FunURL,EpisodeID,PatientID,mradm)
			if $D(TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","OrdList")) {
				s OldOrdList=$g(TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","OrdList"))
				s tmpOrdList=""
				for l=1:1:$l(OrdList,"@") {
					s OneOrdList=$p(OrdList,"@",l)
					if ("@"_OldOrdList_"@")[("@"_OneOrdList_"@") continue
					i tmpOrdList="" s tmpOrdList=OneOrdList
					e  s tmpOrdList=tmpOrdList_"@"_OneOrdList
				}
				if i=8,Querydate=(+$h+1) b //90a
				i tmpOrdList'="" s TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","OrdList")=OldOrdList_"@"_tmpOrdList
			}else{ 
				s TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","OrdList")=OrdList
			}
			if '($D(TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","Style"))){
				s TableList(ShowDate,RangeStartTime,FuncNo,Msg_" ","Style")=FunLevel_"^"_FunPrefix_"^"_FunURL_"^"_FunOutCss_"^"_FunInCss
			}
		}
	}
}

/// 按照医嘱输出消息卡片
ClassMethod ExecTODOListFuncByOrd(OrdRowID As %String, SessionStr As %String, ByRef TableList) As %String [ ProcedureBlock = 0 ]
{
	n (OrdRowID,SessionStr,TableList,%session)
	s EpisodeID=$P(^OEORD(+OrdRowID),"^",1)
	s PatientID=$P(^PAADM(+EpisodeID),"^",1)
	s mradm=$P(^PAADM(+EpisodeID),"^",61)
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s HospitalId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocDr)
	s OrderInstrDr = $p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),2)),"^",7)
	s ItmMastDR = $p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),1)),"^",2)
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s LinkOrderItem=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),11)),"^",39)
	k TODOListFunc
	s TODOListNum=##CLass(DHCDoc.DHCDocConfig.DocToDo).InitTODOListFunc(.TODOListFunc,HospitalId)
	for i=1:1:TODOListNum{
		s OneTODOListFunc=$g(TODOListFunc(i))
		continue:(OneTODOListFunc="")
		//配置编号^级别^前缀^后缀处理方法^URL^外部样式^内部样式^子类列表(!分割)^用法列表(!分割)^运行方式
		s RunType=$P(OneTODOListFunc,"^",10)
		if (RunType'="ByOrder"){
			continue
		}
		
		s FuncNo=$P(OneTODOListFunc,"^",1)
		s FunLevel=$P(OneTODOListFunc,"^",2)
		s FunPrefix=$P(OneTODOListFunc,"^",3)
		s Func=$P(OneTODOListFunc,"^",4)
		s FunURL=$P(OneTODOListFunc,"^",5)
		s FunOutCss=$P(OneTODOListFunc,"^",6)
		s FunInCss=$P(OneTODOListFunc,"^",7)
		s FunSubCatStr=$P(OneTODOListFunc,"^",8)
		s FunInstrStr=$P(OneTODOListFunc,"^",9)
		
		if (FunSubCatStr'="")&&(("!"_FunSubCatStr_"!")'[("!"_ItemCatDR_"!")){
			continue
		}
		if (FunInstrStr'="")&&(("!"_FunInstrStr_"!")'[("!"_OrderInstrDr_"!")){
			continue
		}
		if (FunInstrStr'="")&&(OrderInstrDr=""){
			continue
		}
		s Expression=$tr(Func,"&","""")
		//单条医嘱的待提醒列表
		s ShowInfo=""
		s Expression=$replace(Expression,"@OrdRowID",""""_$g(OrdRowID)_"""")
		s Expression=$replace(Expression,"@SessionStr",""""_$g(SessionStr)_"""")
		s Expression="s ShowInfo="_Expression
		try{
			x Expression
		}catch(e){
			b ;"err"
			continue
		}
		if (ShowInfo=""){
			continue
		}
		
		for j=1:1:$L(ShowInfo,$C(2)){
			s OneShowInfo=$P(ShowInfo,$C(2),j)
			s ShowDate=$P(OneShowInfo,$C(1),1)
			s ShowDate=..%ZDH(ShowDate)
			s ShowTime=$P(OneShowInfo,$C(1),2)
			s ShowTime=..%ZTH(ShowTime)
			s Msg=$P(OneShowInfo,$C(1),3)
			continue:('$D(TableList(ShowDate)))
			if $D(TableList(ShowDate,ShowTime)){
				s RangeStartTime=ShowTime
			}else{
				s RangeStartTime=$O(TableList(ShowDate,ShowTime),-1)
				i RangeStartTime="" s RangeStartTime=$O(TableList(ShowDate,""),-1)
			}
			
			
			s OrdList=$G(TableList(ShowDate,RangeStartTime,FuncNo,Msg,"OrdList"))
			i (OrdList=""){
				s OrdList=OrdRowID
			}else{
				i (LinkOrderItem'="")&&(("^"_OrdList_"^")[("^"_LinkOrderItem_"^")){
					continue
				}
				s OrdList=OrdList_"^"_OrdRowID
			}
			s OrdList=$replace(OrdList,"^","@")
			s TableList(ShowDate,RangeStartTime,FuncNo,Msg,"OrdList")=OrdList
			if '($D(TableList(ShowDate,RangeStartTime,FuncNo,Msg,"Style"))){
				s TableList(ShowDate,RangeStartTime,FuncNo,Msg,"Style")=FunLevel_"^"_FunPrefix_"^"_FunURL_"^"_FunOutCss_"^"_FunInCss
			}
		}
	}
	q
}

/// 加载检查信息
/// w ##Class(web.DHCDocToDoView).InitExaItemInfo("354||512","12175^113^29")
/// OutPut: ShowDate_$C(1)_ShowTime_$C(1)_Msg_$C(2)_....
ClassMethod InitExaItemInfo(OrdRowID, SessionStr) As %String
{
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	
	if (OrdRowID=""){
		q ""
	}
	s ArcimDr=$P($G(^OEORD(+OrdRowID,"I",$P(OrdRowID,"||",2),1)),"^",2)
	if (ArcimDr=""){
		q ""
	}
	s ItmStatDr = $p(^OEORD(+OrdRowID,"I",$P(OrdRowID,"||",2),1),"^",13)
	s ItmStatCode= $p(^OEC("OSTAT",ItmStatDr),"^",1)
	if ("UDC"[ItmStatCode){
		q ""
	}
	s ItemCatDR=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s ServiceFlag=##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimDr)
	if (ServiceFlag'=1)&&(OrderType'="L"){
		q ""
	}
	//w OrdRowID_","
	s StudyNo = ""	//##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OrdRowID,PartID)
	s Params = OrdRowID_"^"_$case(StudyNo,0:"",:StudyNo)_"^"_LogonUserDr
	s IsReadedFlag=##class(web.DHCAPPInterface).IsReadByParams(Params)
	if (IsReadedFlag="Y"){
		q ""
	}
	s TimeLineInfo=..GetTimeLineInfo(OrdRowID)
	s ShowDate=$P(TimeLineInfo,$C(1),1)
	s ShowTime=$P(TimeLineInfo,$C(1),2)
	s Msg=$P(TimeLineInfo,$C(1),3)
	if (Msg=""){
		q ""
	}
	s Msg="已"_Msg
	s Msg=##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp",Msg)
	q ShowDate_$C(1)_ShowTime_$C(1)_Msg
}

/// 获取手术信息
ClassMethod InitOperInfo(OrdRowID, SessionStr) As %String
{
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	
	if (OrdRowID=""){
		q ""
	}
	s ArcimDr=$P($G(^OEORD(+OrdRowID,"I",$P(OrdRowID,"||",2),1)),"^",2)
	if (ArcimDr=""){
		q ""
	}
	s ItmStatDr = $p(^OEORD(+OrdRowID,"I",$P(OrdRowID,"||",2),1),"^",13)
	s ItmStatCode= $p(^OEC("OSTAT",ItmStatDr),"^",1)
	if ("UDC"[ItmStatCode){
		q ""
	}
	
	//手术申请对应的医嘱项配置
	if ..%IsValidMethod("web.DHCANAdaptor","CheckARCIMIsOper"){
		s ret=##Class(web.DHCANAdaptor).CheckARCIMIsOper(ArcimDr)
		if (+ret'=0){
			q ""
		}
	}else{
		q ""
	}
	s TimeLineInfo=..GetTimeLineInfo(OrdRowID)
	s ShowDate=$P(TimeLineInfo,$C(1),1)
	s ShowTime=$P(TimeLineInfo,$C(1),2)
	s Msg=$P(TimeLineInfo,$C(1),3)
	if (Msg=""){
		q ""
	}
	
	s Msg=$replace($E(Msg,1,4),"手术","","",1)_$E(Msg,5,$L(Msg))
	s Msg="已"_Msg
	s Msg=##class(websys.Translation).Get("ipdoc.doctodolistview.hui.csp",Msg)
	q ShowDate_$C(1)_ShowTime_$C(1)_Msg
}

/// 通过基础数据平台组的集成视图，获取医嘱的最后状态信息
/// w ##Class(web.DHCDocToDoView).GetTimeLineInfo("1545||140")
ClassMethod GetTimeLineInfo(OrdRowID As %String) As %String
{
	k OrdStatusList
	//调用基础数据平台组的集成视图
	s Obj=##class(icare.web.TimeLineData).GetActData(OrdRowID)
	//w Obj.Json()
	s LoopActCode=0,i=0
	k ActDataArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(##class(ext.util.JsonObject).ObjToJson(Obj),.ActDataArr)
	s i=""
	for {
		s i=$O(ActDataArr("ActData",i)) Q:(i="")
		if (ActDataArr("ActData",i,"ActCode")'="") {
			s LoopActCode= ActDataArr("ActData",i,"ActCode")
			s LoopOprDate=ActDataArr("ActData",i,"OprDate") 
			s LoopOprTime=ActDataArr("ActData",i,"OprTime")
			s LoopSort=ActDataArr("ActData",i,"Sort")

			s HISCode = $lg(^icare.ClinicalDataTypeActD(LoopActCode),4)
			//不展示阅读流程
			if (HISCode="RD"){
				continue
			}
			s HISStatus= $lg(^icare.ClinicalDataTypeActD(LoopActCode),2)
			////如果最后一个状态是逆流程状态，则需要找到对应的正流程状态时间和逆流程时间，哪个时间靠后
			//显示级别，负数为逆流程级别
			s DisplayLeve=$lg(^icare.ClinicalDataTypeActD(LoopActCode),6)
			//s DisplayLeve=$ZABS(DisplayLeve)
			//s OrdStatusList(+DisplayLeve,..%ZDH(LoopOprDate),..%ZTH(LoopOprTime),LoopActCode)=""
			///tanjishan 对于检验核收-取消核收-拒收的流程来看，完全按照时间去输出最后一个状态，感觉才是正确的
			s OrdStatusList(-100,..%ZDH(LoopOprDate),..%ZTH(LoopOprTime),LoopActCode)=""
		}
	}
	/*while(Obj.Get("ActData",i,"ActCode")'=""){
		
		s LoopActCode= Obj.Get("ActData",i,"ActCode")
		s LoopOprDate=Obj.Get("ActData",i,"OprDate")
		s LoopOprTime=Obj.Get("ActData",i,"OprTime")
		s HISCode = $lg(^icare.ClinicalDataTypeActD(LoopActCode),4)
		s HISStatus= $lg(^icare.ClinicalDataTypeActD(LoopActCode),2)
		//显示级别
		s DisplayLeve=$lg(^icare.ClinicalDataTypeActD(LoopActCode),6)
		s OrdStatusList(+DisplayLeve,LoopActCode)=LoopOprDate_"^"_LoopOprTime
		s i=i+1
	}*/
	//输出最后一个状态，或逆状态
	s DisplayLeve=$O(OrdStatusList(0),-1)
	if (DisplayLeve=""){
		s DisplayLeve=$O(OrdStatusList(""),-1)
	}
	s (LastStatusDate,LastStatusTime,LastStatus)=""
	if (DisplayLeve'=""){
		s LastStatusDate=$O(OrdStatusList(DisplayLeve,""),-1)
		s LastStatusTime=$O(OrdStatusList(DisplayLeve,LastStatusDate,""),-1)
		s ActCode=$O(OrdStatusList(DisplayLeve,LastStatusDate,LastStatusTime,""),-1)
		
		s HISStatus= $lg(^icare.ClinicalDataTypeActD(ActCode),2)
		s HISCode = $lg(^icare.ClinicalDataTypeActD(ActCode),4)
		s LastStatus=HISStatus
		s LastStatusDate=..%ZD(LastStatusDate)
		s LastStatusTime=..%ZT(LastStatusTime)
	}
	q LastStatusDate_$C(1)_LastStatusTime_$C(1)_LastStatus
}

/// 加载出院信息
ClassMethod InitDischargeInfo(EpisodeID As %String, Querydate As %String, SessionStr As %String) As %String
{
	if (EpisodeID=""){
		q ""
	}
	if (Querydate=""){
		q ""
	}
	s Querydate=..%ZDH(Querydate)
	s ShowInfo=""
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s flag=##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(EpisodeID)
	if (flag=0)||(flag=5){
		q ""
	}
	s Msg=$case(flag,2:"已医疗结算",2.5:"费用调整中",3:"已护士结算",4:"已财务结算")
	//时间统一使用医疗结算时间，即医生选定的预计出院时间
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	s estimDischargeTime=$p($g(^PAADM(EpisodeID)),"^",60)
	if (Querydate'=estimDischargeDate){
		q ""
	}
	s OrdList=""
	s ShowDate=..%ZD(estimDischargeDate)
	s ShowTime=..%ZT(estimDischargeTime)
	s ShowInfo=ShowDate_$C(1)_ShowTime_$C(1)_Msg_$C(1)_OrdList
	q ShowInfo
}

/// 加载出院带药信息
ClassMethod InitOutOrdInfo(EpisodeID As %String, Querydate As %String, SessionStr As %String) As %String
{
	if (EpisodeID=""){
		q ""
	}
	if (Querydate=""){
		q ""
	}
	s Querydate=..%ZDH(Querydate)
	s ShowInfo=""
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s flag=##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(EpisodeID)
	if (flag=0)||(flag=5){
		q ""
	}
	s Msg=$case(flag,2:"已医疗结算",2.5:"费用调整中",3:"已护士结算",4:"已财务结算")
	//时间统一使用医疗结算时间，即医生选定的预计出院时间
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	s estimDischargeTime=$p($g(^PAADM(EpisodeID)),"^",60)
	if (Querydate'=estimDischargeDate){
		q ""
	}
	//检索在出院三天内是否开立过出院带药类型的医嘱
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
	if (OrderRowid=""){
		q ""
	}
	s OutPriority=$O(^OECPR(0,"Code","OUT",0))
	if (OutPriority=""){
		q ""
	}
	s HaveOutOrdFlag="N"
	s child=0
	for {
		s child=$O(^OEORDi(0,"Priority",OrderRowid,OutPriority,child))
		q:(child="")||(HaveOutOrdFlag="Y")
		s ItmStatDr = $p(^OEORD(OrderRowid,"I",child,1),"^",13)
		s ItmStatCode= $p(^OEC("OSTAT",ItmStatDr),"^",1)
		if ("UDC"[ItmStatCode){
			continue
		}
		s StartDate=$p(^OEORD(OrderRowid,"I",child,1),"^",9)
		if (StartDate<(estimDischargeDate-3)){
			continue
		}
		s HaveOutOrdFlag="Y"
	}
	if (HaveOutOrdFlag="Y"){
		q ""
	}
	s Msg="未开出院带药"
	s OrdList=""
	s ShowDate=..%ZD(estimDischargeDate)
	s ShowTime=..%ZT(estimDischargeTime)
	s ShowInfo=ShowDate_$C(1)_ShowTime_$C(1)_Msg_$C(1)_OrdList
	q ShowInfo
}

/// 加载未执行口服药信息
/// w ##Class(web.DHCDocToDoView).InitNotExecItemInfo("3884","14/12/2020","12262^131^134","^12")
/// OutPut: ShowDate_$C(1)_ShowTime_$C(1)_Msg_$C(2)_....
ClassMethod InitNotExecItemInfo(EpisodeID As %String, Querydate As %String, SessionStr As %String, LimitInfo As %String) As %String
{
	if (EpisodeID=""){
		q ""
	}
	if (Querydate=""){
		q ""
	}
	s ShowInfo=""
	s LogonUserDr=$P(SessionStr,"^",1)
	s LogonLocDr=$P(SessionStr,"^",2)
	s LogonGroupDr=$P(SessionStr,"^",3)
	s Querydate=..%ZDH(Querydate)
	s LimitSubCatStr=$P(LimitInfo,"^",1)
	s LimitInstrStr=$P(LimitInfo,"^",2)
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,0))
	s ExStTime=""
	for {
		s ExStTime=$o(^OEORDi(0,"Date",OrderRowid,Querydate,ExStTime))
		//s ExStTime=$O(^OEORDi(0,"NotExecE",OrderRowid,Querydate,ExStTime))
		q:(ExStTime="")
		s OrdList=""
		s child=0
		for {
			//s child=$O(^OEORDi(0,"NotExecE",OrderRowid,Querydate,ExStTime,child))
			s child=$o(^OEORDi(0,"Date",OrderRowid,Querydate,ExStTime,child))
			q:(child="")
			s ItmMastDR = $p($g(^OEORD(OrderRowid,"I",child,1)),"^",2)
			if (ItmMastDR=""){
				continue
			}
			s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
			s InstrRowid=$P($G(^OEORD(OrderRowid,"I",child,2)),"^",7)
			
			if (LimitSubCatStr'="")&&(("!"_LimitSubCatStr_"!")'[("!"_ItemCatDR_"!")){
				continue
			}
			if (LimitInstrStr'="")&&(("!"_LimitInstrStr_"!")'[("!"_InstrRowid_"!")){
				continue
			}
			if (LimitInstrStr'="")&&(InstrRowid=""){
				continue
			}
			s HaveUnExecFlag="N"
			s ExecId=0
			for {
				//s ExecId=$O(^OEORDi(0,"NotExecE",OrderRowid,Querydate,ExStTime,child,ExecId))
				s ExecId=$o(^OEORDi(0,"Date",OrderRowid,Querydate,ExStTime,child,ExecId))
				q:(ExecId="")||(HaveUnExecFlag="Y")
				s ExecStateDR= $p($G(^OEORD(OrderRowid,"I",child,"X",ExecId)),"^",16)
				s execStatus=""
				i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
				if (execStatus="")||(execStatus="C"){
					s HaveUnExecFlag="Y"
				}
			}
			if (HaveUnExecFlag="N"){
				continue
			}
			
			s LinkOrderItem=$p($g(^OEORD(OrderRowid,"I",child,11)),"^",39)
			if (OrdList=""){
				s OrdList=OrderRowid_"||"_child
			}else{
				/*i (LinkOrderItem'="")&&(("^"_OrdList_"^")[("^"_LinkOrderItem_"^")){
					continue
				}*/
				s OrdList=OrdList_"^"_OrderRowid_"||"_child
			}
			
		}
		if (OrdList'=""){
			s ShowDate=..%ZD(Querydate)
			s ShowTime=..%ZT(ExStTime)
			if (ShowInfo=""){
				s ShowInfo=ShowDate_$C(1)_ShowTime_$C(1)_$C(1)_OrdList
			}else{
				s ShowInfo=ShowInfo_$C(2)_ShowDate_$C(1)_ShowTime_$C(1)_$C(1)_OrdList
			}
		}
	}
	q ShowInfo
}

ClassMethod GetDefaultQueryDate(EpisodeID As %String) As %String
{
	s CurrDate=..%SysDate()
	s estimDischargeDate=$p($g(^PAADM(EpisodeID)),"^",59)
	if (estimDischargeDate<CurrDate)&&(estimDischargeDate'=""){
		s QueryDate=estimDischargeDate
	}else{
		s QueryDate=CurrDate
	}
	s QueryDate=..%ZD(QueryDate)
	q QueryDate
}

}
