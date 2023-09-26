/// 名称:     DHCDoc.DHCDocConfig.DocToDo
/// 描述:     医疗待办配置项目
/// 编写者:  谭吉善
/// 编写日期: 2020.10.16
Class DHCDoc.DHCDocConfig.DocToDo Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取一次需要展示的日期个数
/// TODO
ClassMethod GetDateNum(HospDr As %String) As %String
{
	q 6
}

/// 获取时间段信息
/// TODO
/// output		TimeRangeList:时间段信息，前开后闭，比如00:00-06:00,指包含00:00但不包含06:00
/// 			TimeNum:时间段个数
/// d ##Class(DHCDoc.DHCDocConfig.DocToDo).InitTimeRangeList(.Arr,2)
ClassMethod InitTimeRangeList(ByRef TimeRangeList, HospDr As %String) As %String
{
	k TimeRangeList
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.DocToDo:FindTimeRangeList")
	do rset.Execute(HospDr)
	s columns = rset.GetColumnCount()
	s Index=0
	While (rset.Next()) {
		s Index=Index+1
		s TimeRangeStartTime=rset.GetData(2)
		s TimeRangeEndTime=rset.GetData(3)
		s TimeRangeList(Index)=TimeRangeStartTime_"-"_TimeRangeEndTime
		
	}
	if '$D(TimeRangeList){
		s Index=Index+1
		s TimeRangeList(1)="00:00-00:00"
	}
	q Index
}

/// 获取时间段信息
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocToDo","FindTimeRangeList","2")
Query FindTimeRangeList(HospId As %String = "") As websys.Query(ROWSPEC = "Index:%String,TimeRangeStartTime:%String,TimeRangeEndTime:%String")
{
}

ClassMethod FindTimeRangeListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",Index))
			q:(Index="")
			s Data=^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",Index)
			s TimeRangeStartTime=$P(Data,"^",1)
			s TimeRangeEndTime=$P(Data,"^",2)
			d OutPut1
		}
	}else{
		s Index=0
		for {
			s Index=$O(^DHCDocConfig("DocToDo","TimeRangeList",Index))
			q:(Index="")
			s Data=^DHCDocConfig("DocToDo","TimeRangeList",Index)
			s TimeRangeStartTime=$P(Data,"^",1)
			s TimeRangeEndTime=$P(Data,"^",2)
			d OutPut1
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut1
	i TimeRangeStartTime'="" s TimeRangeStartTime=$ZT(TimeRangeStartTime,2)
	if (TimeRangeEndTime=0){
		s TimeRangeEndTime="24:00"
	}elseif TimeRangeEndTime'="" {
		s TimeRangeEndTime=$ZT(TimeRangeEndTime,2)
	}
	Set Data=$lb(Index,TimeRangeStartTime,TimeRangeEndTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 删除时间段信息
ClassMethod DelTimeRangeList(IndexS As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		for i=1:1:$L(IndexS,",") {
			s Index=$P(IndexS,",",i)
			k ^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",Index)
		}
	}else{
		for i=1:1:$L(IndexS,",") {
			s Index=$P(IndexS,",",i)
			k ^DHCDocConfig("DocToDo","TimeRangeList",Index)
		}
	}
	q 0
}

/// 保存时间段信息
ClassMethod InsertTimeRangeList(Index As %String, TimeRangeStartTime As %String, TimeRangeEndTime As %String, HospId As %String = "") As %String
{
	
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s TimeRangeStartTime=..%ZTH(TimeRangeStartTime)
	s TimeRangeEndTime=..%ZTH(TimeRangeEndTime)
	if (TimeRangeStartTime=TimeRangeEndTime){
		q "-100^开始时间与结束时间一致，无法保存"
	}
	s ErrInfo=0
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s LoopIndex=0
		for {
			s LoopIndex=$O(^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",LoopIndex))
			q:(LoopIndex="")
			continue:(Index'="")&&(Index=LoopIndex)
			s LoopTimeRangeStartTime=$P(^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",LoopIndex),"^",1)
			s LoopTimeRangeEndTime=$P(^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",LoopIndex),"^",2)
			if ((TimeRangeStartTime>LoopTimeRangeStartTime)&&(TimeRangeStartTime<LoopTimeRangeEndTime))
				||((TimeRangeEndTime>LoopTimeRangeStartTime)&&(TimeRangeEndTime<LoopTimeRangeEndTime))
			{
				s ErrInfo="-100^存在重复的时间段，无法添加:"_..%ZT(LoopTimeRangeStartTime)_"-"_..%ZT(LoopTimeRangeEndTime)
			}
			if (LoopTimeRangeStartTime=TimeRangeStartTime)&&(LoopTimeRangeEndTime=TimeRangeEndTime){
				s ErrInfo="-100^存在重复的时间段，无法添加"
			}
		}
		q:(+ErrInfo'=0) ErrInfo


		s:(Index="") Index=$O(^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",""),-1)+1
		s ^DHCDocConfig(HospCodeNode,"DocToDo","TimeRangeList",Index)=TimeRangeStartTime_"^"_TimeRangeEndTime
		
	}else{
		s LoopIndex=0
		for {
			s LoopIndex=$O(^DHCDocConfig("DocToDo","TimeRangeList",LoopIndex))
			q:(LoopIndex="")
			continue:(Index'="")&&(Index=LoopIndex)
			s LoopTimeRangeStartTime=$P(^DHCDocConfig("DocToDo","TimeRangeList",LoopIndex),"^",1)
			s LoopTimeRangeEndTime=$P(^DHCDocConfig("DocToDo","TimeRangeList",LoopIndex),"^",2)
			if ((TimeRangeStartTime>LoopTimeRangeStartTime)&&(TimeRangeStartTime<LoopTimeRangeEndTime))
				||((TimeRangeEndTime>LoopTimeRangeStartTime)&&(TimeRangeEndTime<LoopTimeRangeEndTime))
			{
				s ErrInfo="-100^存在重复的时间段，无法添加:"_..%ZT(LoopTimeRangeStartTime)_"-"_..%ZT(LoopTimeRangeEndTime)
			}
			if (LoopTimeRangeStartTime=TimeRangeStartTime)&&(LoopTimeRangeEndTime=TimeRangeEndTime){
				s ErrInfo="-100^存在重复的时间段，无法添加"
			}
		}
		q:(+ErrInfo'=0) ErrInfo
		s:(Index="") Index=$O(^DHCDocConfig("DocToDo","TimeRangeList",""),-1)+1
		s ^DHCDocConfig("DocToDo","TimeRangeList",Index)=TimeRangeStartTime_"^"_TimeRangeEndTime
	}
	q ErrInfo
}

/// 获取配置项列表
/// TODO
/// output		TODOListFunc:配置编号^级别^前缀^后缀处理方法^URL^外部样式^内部样式^子类列表(!分割)^用法列表(!分割)^检索类型(ByDate|ByOrder)
/// 			TODOListNum:时间段个数
ClassMethod InitTODOListFunc(ByRef TODOListFunc, HospDr As %String) As %String
{
	k TODOListFunc

	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.DocToDo:FindTODOListFunc")
	do rset.Execute(HospDr)
	s columns = rset.GetColumnCount()
	s Count=0
	While (rset.Next()) {
		s Count=Count+1
		s Index=rset.GetData(1)
		s Level=rset.GetData(2)
		s Prefix=rset.GetData(3)
		s SuffixFunc=rset.GetData(4)
		s URL=rset.GetData(5)
		s OutStyle=rset.GetData(6)
		s InStyle=rset.GetData(7)
		s OrdSubCatStr=rset.GetData(8)
		s InstrStr=rset.GetData(9)
		s SearchType=rset.GetData(10)
		s TODOListFunc(Index)=Index_"^"_Level_"^"_Prefix_"^"_SuffixFunc_"^"_URL
		s TODOListFunc(Index)=TODOListFunc(Index)_"^"_OutStyle_"^"_InStyle_"^"_OrdSubCatStr_"^"_InstrStr_"^"_SearchType
		
	}
	/*
	if $D(%session){
		s TODOListFunc(1)="1^1^检查^##class(web.DHCDocToDoView).InitExaItemInfo(@OrdRowID,@SessionStr)^dhcapp.inspectrs.csp?EpisodeID=@episodeID&PatientID=@patientID&OEORIID=@OrdList^^color:#00949F;background-color:#DEFDFF;border:1px solid #9BE3E8;^19!20!21!22!23!24!25!26!27!28!29!30!31!32!33!34^^ByOrder^^^^^^"
		s TODOListFunc(2)="2^1^检验^##class(web.DHCDocToDoView).InitExaItemInfo(@OrdRowID,@SessionStr)^dhcapp.seepatlis.csp?EpisodeID=@episodeID&PatientID=@patientID&OEORIID=@OrdList^^color:#2A40CB;background-color:#DEE2FF;border:1px solid #B2B9E9;^35!36!37!38!39!40!173!174!175^^ByOrder^^^^^^"
		s TODOListFunc(3)="3^1^手术^##class(web.DHCDocToDoView).InitOperInfo(@OrdRowID,@SessionStr)^ipdoc.patorderview.csp?EpisodeID=@episodeID&OrdList=@OrdList&DefaultOrderPriorType=AllOrderPrior&PageShowFromWay=ShowFromDocToDo&DocToInfoMsg=@DocToInfoMsg^^color:#FF3D2C;background-color:#FFE3E3;border:1px solid #E89B9B;^^^ByOrder^^^^^^"
	}
	s TODOListFunc(4)="4^1^出院^##class(web.DHCDocToDoView).InitDischargeInfo(@episodeID,@Querydate,@SessionStr)^^^color:#FF7E00;background-color:#FFF4E3;border:1px solid #E8CA9B;^^^ByDate^^^^^^"
	//出院带药
	s TODOListFunc(5)="5^2^^##class(web.DHCDocToDoView).InitOutOrdInfo(@episodeID,@Querydate,@SessionStr)^OpenOrdEntryMene()^^color:#FF7E00;background-color:#FFF4E3;border:1px solid #E8CA9B;font-style: oblique;^^^ByDate^^^^^^"
	s TODOListFunc(8)="8^1^需吃药^##class(web.DHCDocToDoView).InitNotExecItemInfo(@episodeID,@Querydate,@SessionStr,@LimitInfo)^ipdoc.patorderview.csp?EpisodeID=@episodeID&OrdList=@OrdList&DefaultOrderPriorType=AllOrderPrior&PageShowFromWay=ShowFromDocToDo&DocToInfoMsg=@DocToInfoMsg^^color:#139E00;background-color:#E2FFDE;border:1px solid #A6E99C;^^12^ByDate^^^^^^"
	s TODOListFunc(9)="9^1^需输液^##class(web.DHCDocToDoView).InitNotExecItemInfo(@episodeID,@Querydate,@SessionStr,@LimitInfo)^ipdoc.patorderview.csp?EpisodeID=@episodeID&OrdList=@OrdList&DefaultOrderPriorType=AllOrderPrior&PageShowFromWay=ShowFromDocToDo&DocToInfoMsg=@DocToInfoMsg^^color:#AC2ACC;background-color:#F8DEFF;border:1px solid #DEB2E9;^^16!17^ByDate^^^^^^"
	*/
	q Count
}

/// 获取配置项列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocToDo","FindTODOListFunc","2")
Query FindTODOListFunc(HospId As %String = "") As websys.Query(ROWSPEC = "Index:%String,Level:%String,Prefix:%String,SuffixFunc:%String,URL:%String,OutStyle:%String,InStyle:%String,OrdSubCatStr:%String,InstrStr:%String,SearchType:%String")
{
}

ClassMethod FindTODOListFuncExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s Index=0
		for {
			s Index=$O(^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index))
			q:(Index="")
			s Data=^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index)
			d OutPut2
		}
	}else{
		s Index=0
		for {
			s Index=$O(^DHCDocConfig("DocToDo","FuncList",Index))
			q:(Index="")
			s Data=^DHCDocConfig("DocToDo","FuncList",Index)
			d OutPut2
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut2
	s Level=$P(Data,"^",1)
	s Prefix=$P(Data,"^",2)
	s SuffixFunc=$P(Data,"^",3)
	s URL=$P(Data,"^",4)
	s OutStyle=$P(Data,"^",5)
	s InStyle=$P(Data,"^",6)
	s OrdSubCatStr=$P(Data,"^",7)
	s InstrStr=$P(Data,"^",8)
	s SearchType=$P(Data,"^",9)
	
	
	Set Data=$lb(Index,Level,Prefix,SuffixFunc,URL,OutStyle,InStyle,OrdSubCatStr,InstrStr,SearchType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// 删除方法列表
ClassMethod DelFuncList(IndexS As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		for i=1:1:$L(IndexS,",") {
			s Index=$P(IndexS,",",i)
			k ^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index)
		}
	}else{
		for i=1:1:$L(IndexS,",") {
			s Index=$P(IndexS,",",i)
			k ^DHCDocConfig("DocToDo","FuncList",Index)
		}
	}
	q 0
}

/// 保存方法列表
/// 
ClassMethod InsertFuncList(Index, HospId As %String, Level As %String, Prefix As %String, SuffixFunc As %String, URL As %String, OutStyle As %String, InStyle As %String, SearchType As %String) As %String
{

	s ^tan("InsertFuncList")=Index_","_HospId_","_Level_","_Prefix_","_SuffixFunc_","_URL_","_OutStyle_","_InStyle_","_SearchType
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s Level=$replace(Level,"^","*")
	s Prefix=$replace(Prefix,"^","*")
	s SuffixFunc=$replace(SuffixFunc,"^","*")
	s URL=$replace(URL,"^","*")
	s OutStyle=$replace(OutStyle,"^","*")
	s InStyle=$replace(InStyle,"^","*")
	s SearchType=$replace(SearchType,"^","*")
	if (SuffixFunc'=""){
		s ClassName=$P($P(SuffixFunc,")"),"(",2)
		s MethodName=$P($P(SuffixFunc,".",3),"(",1)
		if ('..%IsValidMethod(ClassName,MethodName)) {
			q "-100^无效的后缀处理方法"
		}
	}
	s HospCodeNode=""
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}
	s:(Index="") Index=$O(^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",""),-1)+1
	s Data=$G(^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index))
	s $P(Data,"^",1)=Level
	s $P(Data,"^",2)=Prefix
	s $P(Data,"^",3)=SuffixFunc
	s $P(Data,"^",4)=URL
	s $P(Data,"^",5)=OutStyle
	s $P(Data,"^",6)=InStyle
	s $P(Data,"^",9)=SearchType
	if (HospId'="") {
		s ^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index)=Data
	}else{
		s ^DHCDocConfig("DocToDo","FuncList",Index)=Data
	}
	q 0
}

/// 更新方法中的子类串
ClassMethod UpdateFuncListSubCat(Index As %String, HospId As %String, OrdSubCatStr As %String) As %Status
{
	s OrdSubCatStr=$REPLACE(OrdSubCatStr,"^","!")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s $P(^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index),"^",7)=OrdSubCatStr
	}else{
		s $P(^DHCDocConfig("DocToDo","FuncList",Index),"^",7)=OrdSubCatStr
	}
	q 0
}

/// 更新方法中的用法串
ClassMethod UpdateFuncListInstr(Index As %String, HospId As %String, InstrStr As %String) As %Status
{
	s InstrStr=$REPLACE(InstrStr,"^","!")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s $P(^DHCDocConfig(HospCodeNode,"DocToDo","FuncList",Index),"^",8)=InstrStr
	}else{
		s $P(^DHCDocConfig("DocToDo","FuncList",Index),"^",8)=InstrStr
	}
	q 0
}

}
