Class web.DHCDocPatAssPlan Extends (%CSP.Page, DHCDoc.Util.RegisteredObject) [ Not ProcedureBlock ]
{

/*
DHCDocPatAssPlan.csp给用户的诊疗计划单操作界面
DHCDocPatAssPlanFav.csp给用户的诊疗计划单模板的维护界面
*/
/// Creat:tanjishan
ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	s action=$g(%request.Data("action",1),"")
	s EpisodeID=$g(%request.Data("EpisodeID",1),"")
	s ^DHCDocPatAssPlan("EpisodeID"," "_EpisodeID)=$H_"^"_action
	Lock +^DHCDocPatAssPlan("EpisodeID"," "_EpisodeID):30
	s Json=""
	if (action="SavePAP")
	{
		s Param=$g(%request.Data("Param", 1), "")
		s Json=..SavePAP(Param,EpisodeID)
	}elseif (action="DeletePAP"){
		s RowID=$g(%request.Data("RowID", 1), "")
		s Json=..DeletePAP(RowID)
	}elseif (action="LoadAssPlanFav"){
		s SaveTypeStr=$g(%request.Data("SaveTypeStr", 1), "")
		s SaveReferStr=$g(%request.Data("SaveReferStr", 1), "")
		s UserType=$g(%request.Data("UserType", 1), "")
		s Json=..LoadAssPlanFav(SaveTypeStr,SaveReferStr,UserType)
	}elseif (action="InserAPFNode"){
		s RowID=$g(%request.Data("RowID", 1), "")
		s parent=$g(%request.Data("parent", 1), "")
		s Title=$g(%request.Data("Title", 1), "")
		s UserType=$g(%request.Data("UserType", 1), "")
		s SaveType=$g(%request.Data("SaveType", 1), "")
		s SaveRefer=$g(%request.Data("SaveRefer", 1), "")
		s Json=..InserAPFNode(RowID,parent,Title,UserType,SaveType,SaveRefer)
	}elseif (action="SavePatAssToFav"){
		s PatAssRowID=$g(%request.Data("PatAssRowID", 1), "")
		s FavNodeRowID=$g(%request.Data("FavNodeRowID", 1), "")
		s Title=$g(%request.Data("Title", 1), "")
		s Json=..SavePatAssToFav(PatAssRowID,FavNodeRowID,Title)
	}elseif (action="UpdateAPFNode"){
		s RowID=$g(%request.Data("RowID", 1), "")
		s PatSymptom=$g(%request.Data("PatSymptom", 1), "")
		s ExpectedGoal=$g(%request.Data("ExpectedGoal", 1), "")
		s Measures=$g(%request.Data("Measures", 1), "")
		s Json=..UpdateAPFNode(RowID,PatSymptom,ExpectedGoal,Measures)
	}elseif (action="DeleteAPFNode"){
		s RowID=$g(%request.Data("RowID", 1), "")
		s Json=..DeleteAPFNode(RowID)
	}elseif (action="InsFavToTable"){
		s FavRowID=$g(%request.Data("FavRowID", 1), "")
		s EpisodeID=$g(%request.Data("EpisodeID", 1), "")
		s UserType=$g(%request.Data("UserType", 1), "")
		s SignUser=$g(%request.Data("SignUser", 1), "")
		s Json=..InsFavToTable(FavRowID,EpisodeID,UserType,SignUser)
	}elseif (action="MoveAction"){
		s RowID=$g(%request.Data("RowID", 1), "")
		s MoveType=$g(%request.Data("MoveType", 1), "")
		s UserType=$g(%request.Data("UserType", 1), "")
		s Json=..MoveAction(RowID,MoveType,UserType)
	}else{

		s Json=""
	}
	Lock -^DHCDocPatAssPlan("EpisodeID"," "_EpisodeID)
 	w Json
	Quit $$$OK
ErrorHandler
	s ^DHCDocPatAssPlan("Err"," "_EpisodeID,$H)=action_"^"_errInfo
	Lock -^DHCDocPatAssPlan("EpisodeID"," "_EpisodeID)
	w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
	Quit $$$OK
}

Query PatAssPlanList(EpisodeID As %String) As %Query(ROWSPEC = "RowID:%String,UserType:%String,SymptomTime:%String,PatSymptom:%String,ExpectedGoal:%String,Measures:%String,ExpectedCompletionTime:%String,SignUserInfo:%String,Result:%String,ResultCode:%String,ResultUserInfo:%String,SeqNo:%String,OtherInfo:%String")
{
}

ClassMethod PatAssPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatAssPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PatAssPlanListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocPatAssPlan","PatAssPlanList","550")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s stream = ##Class(%GlobalBinaryStream).%New()
	k DataArr
	d ##Class(web.DHCDocPatAssPlan).SortData(EpisodeID,.DataArr)
	s Sequence=""
	for {
		s Sequence=$O(DataArr(Sequence))
		q:Sequence=""
		s ID=$G(DataArr(Sequence,"ID"))
		s SeqNo=$G(DataArr(Sequence,"SeqNo"))
		d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	d ResetVariables1
	s RowID=ID
	s obj=##Class(User.DHCDocPatAssPlan).%OpenId(ID)
	s UserType=obj.PAPUserType
	Set langid=..%LanguageID()
	//s UserType=$CASE(UserType,"DOCTOR":"医生","NURSE":"护士","Dietitian":"营养师",:"其他")
	
	s SymptomDate=obj.PAPSymptomDate
	s SymptomTime=obj.PAPSymptomTime
	if (SymptomDate'=""){
		s SymptomTimeInfo=..%ZD(SymptomDate)
	}
	if (SymptomTime'="") {
		s SymptomTime=..%ZT(SymptomTime,2)
		s SymptomTimeInfo=SymptomTimeInfo_" "_SymptomTime
	}
	d stream.Clear(),stream.CopyFrom(obj.PAPPatSymptom)
	s PatSymptom=stream.Read()
	d stream.Clear(),stream.CopyFrom(obj.PAPExpectedGoal)
	s ExpectedGoal=stream.Read()
	d stream.Clear(),stream.CopyFrom(obj.PAPMeasures)
	s Measures=stream.Read()
	s ExpectedCompletionDate=obj.PAPExpectedCompletionDate
	s ExpectedCompletionTime=obj.PAPExpectedCompletionTime
	/*if (ExpectedCompletionDate'="")&&(ExpectedCompletionTime'="") {
		s ExpectedCompletionTimeInfo=..%ZD(ExpectedCompletionDate)_" "_..%ZT(ExpectedCompletionTime,2)
	}*/
	
	if (ExpectedCompletionDate'=""){
		s ExpectedCompletionTimeInfo=..%ZD(ExpectedCompletionDate)
	}
	if (ExpectedCompletionTime'="") {
		s ExpectedCompletionTime=..%ZT(ExpectedCompletionTime,2)
		s ExpectedCompletionTimeInfo=ExpectedCompletionTimeInfo_" "_ExpectedCompletionTime
	}
	
	if $IsObject(obj.PAPSignUser) {
		s SignUserID=obj.PAPSignUser.%Id()
		s SignUserName=obj.PAPSignUser.SSUSRName
		s SignUserName =##class(User.SSUser).GetTranByDesc("SSUSRName",SignUserName,langid)
		s SignUserDate=..%ZD(obj.PAPSignDate) //$ZD(obj.PAPSignDate,3)
		s SignUserTime=..%ZT(obj.PAPSignTime,2)
		s SignUserInfo=SignUserName_" "_SignUserDate_" "_SignUserTime
	}
	////Result,ResultCode,ResultUserInfo
	d stream.Clear(),stream.CopyFrom(obj.PAPResult)
	s Result=stream.Read()
	s ResultCode=obj.PAPResultCode
	if $IsObject(obj.PAPResultUser) {
		s ResultUserID=obj.PAPResultUser.%Id()
		s ResultUserName=obj.PAPResultUser.SSUSRName
		s ResultUserName =##class(User.SSUser).GetTranByDesc("SSUSRName",ResultUserName,langid)
		s ResultUserDate=..%ZD(obj.PAPResultUserDate) //$ZD(obj.PAPResultUserDate,3)
		s ResultUserTime=..%ZT(obj.PAPResultUserTime,2)
		s ResultUserInfo=ResultUserName_" "_ResultUserDate_" "_ResultUserTime
	}
	d obj.%Close()
	
	if (ExpectedCompletionDate<+$H)&&(ResultCode="")&&(ExpectedCompletionDate'=""){
		s OtherInfo="OverTime^^^"
	}
	
	s PatSymptom=..CheckJsonData(PatSymptom)
	s ExpectedGoal=..CheckJsonData(ExpectedGoal)
	s Measures=..CheckJsonData(Measures)
	set Data=$lb(RowID,UserType,SymptomTimeInfo,PatSymptom,ExpectedGoal,Measures,ExpectedCompletionTimeInfo,SignUserInfo,Result,ResultCode,ResultUserInfo,SeqNo,OtherInfo)  //
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
	
ResetVariables1
	set (RowID,UserType,SymptomTimeInfo,PatSymptom,ExpectedGoal,Measures,ExpectedCompletionTimeInfo,SignUserInfo,Result,ResultCode,ResultUserInfo,OtherInfo)=""
	quit
}

ClassMethod PatAssPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatAssPlanListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
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

/// w ##Class(web.DHCDocPatAssPlan).SavePAP($P(^tan("SavePAP"),",",1),$P(^tan("SavePAP"),",",2))
ClassMethod SavePAP(Param As %String, EpisodeID As %String) As %String
{
	n (Param, EpisodeID)
	s ^tan("SavePAP")=Param_","_EpisodeID

	s RowID=$P(Param,"^",1)
	
	s UserType=$P(Param,"^",2)
	s SymptomTimeInfo=$P(Param,"^",3)
	s PatSymptom=$P(Param,"^",4)
	s ExpectedGoal=$P(Param,"^",5)
	s Measures=$P(Param,"^",6)
	s PatSymptom=..CheckJsonData(PatSymptom)
	s ExpectedGoal=..CheckJsonData(ExpectedGoal)
	s Measures=..CheckJsonData(Measures)
	s ExpectedCompletionTimeInfo=$P(Param,"^",7)
	s SignUser=$P(Param,"^",8)
	s ResultCode=$P(Param,"^",9)
	s Result=$P(Param,"^",10)
	s Result=..CheckJsonData(Result)
	s ResultUser=$P(Param,"^",11)
	s UpdateUser=$P(Param,"^",12)
	s Level=$P(Param,"^",13)
	
	s SymptomDate=$P(SymptomTimeInfo," ",1)
	s:SymptomDate'="" SymptomDate=..%ZDH(SymptomDate) //SymptomDate=$S(SymptomDate["-":$ZDH(SymptomDate,3),SymptomDate["/":$ZDH(SymptomDate,4),1:SymptomDate)
	s SymptomTime=$P(SymptomTimeInfo," ",2)
	s:SymptomTime'="" SymptomTime=..%ZTH(SymptomTime)
	s ExpectedCompletionDate=$P(ExpectedCompletionTimeInfo," ",1)
	s:ExpectedCompletionDate'="" ExpectedCompletionDate=..%ZDH(ExpectedCompletionDate) //$S(ExpectedCompletionDate["-":$ZDH(ExpectedCompletionDate,3),ExpectedCompletionDate["/":$ZDH(ExpectedCompletionDate,4),1:ExpectedCompletionDate)
	s ExpectedCompletionTime=$P(ExpectedCompletionTimeInfo," ",2)
	s:ExpectedCompletionTime'="" ExpectedCompletionTime=..%ZTH(ExpectedCompletionTime)
	s stream = ##Class(%GlobalBinaryStream).%New()
	if (RowID'=""){
		s obj=##Class(User.DHCDocPatAssPlan).%OpenId(RowID)
	}else{
		s obj = ##class(User.DHCDocPatAssPlan).%New()
	}
	if (RowID=""){
		s obj.PAPEpisodeID=EpisodeID
	}
	s obj.PAPUserType=UserType
	s obj.PAPSymptomDate=SymptomDate
	s obj.PAPSymptomTime=SymptomTime
	d stream.Clear(),stream.Write(PatSymptom)
	d obj.PAPPatSymptom.CopyFrom(stream)
	d stream.Clear(),stream.Write(ExpectedGoal)
	d obj.PAPExpectedGoal.CopyFrom(stream)
	d stream.Clear(),stream.Write(Measures)
	d obj.PAPMeasures.CopyFrom(stream)
	s obj.PAPExpectedCompletionDate=ExpectedCompletionDate
	s obj.PAPExpectedCompletionTime=ExpectedCompletionTime
	s mySignUser=""
	if ($IsObject(obj.PAPSignUser)){
		s mySignUser=obj.PAPSignUser.%Id()
	}
	if (SignUser'="")&&(SignUser'=mySignUser){
		d obj.PAPSignUserSetObjectId(SignUser)
		s obj.PAPSignDate=..%SysDate()
		s obj.PAPSignTime=..%SysTime()
	}
	
	d stream.Clear(),stream.CopyFrom(obj.PAPResult)
	s TmpResult=stream.Read()
	if ((ResultCode'=obj.PAPResultCode)||(TmpResult'=Result)){
		s obj.PAPResultCode=ResultCode
		d stream.Clear(),stream.Write(Result)
		d obj.PAPResult.CopyFrom(stream)
		d obj.PAPResultUserSetObjectId(ResultUser)
		s obj.PAPResultUserDate=..%SysDate()
		s obj.PAPResultUserTime=..%SysTime()
	}
	d obj.PAPUpdateUserSetObjectId(UpdateUser)
	s obj.PAPUpdateDate=..%SysDate()
	s obj.PAPUpdateTime=..%SysTime()
	
	s Sequence=$TR($O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,""),-1)," ","")+1
	s:Level="" Level=1
	if (RowID=""){
		s obj.PAPSequence=Sequence
		s obj.PAPLevel=Level
	}
	s sc=obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"
		q myrtn_"^"
	}
	q 0
}

/// w ##Class(web.DHCDocPatAssPlan).DeletePAP("4")
ClassMethod DeletePAP(RowID As %String) As %String
{
	k DataArr
	k SeqNoArr
	k RowArr
	s EpisodeID=$list(^DHCDocPatAssPlanD(RowID),2)
	s Sequence=$list(^DHCDocPatAssPlanD(RowID),23)
	d ##Class(web.DHCDocPatAssPlan).SortData(EpisodeID,.DataArr)
	s SeqNo=DataArr(Sequence,"SeqNo")
	
	s NeedDelRowStr=RowID
	s mySequence=""
	for {
		s mySequence=$O(DataArr(mySequence))
		q:mySequence=""
		s myID=$G(DataArr(mySequence,"ID"))
		s mySeqNo=$G(DataArr(mySequence,"SeqNo"))
		s myUserType=$list(^DHCDocPatAssPlanD(myID),3)
		s Value="SeqNoArr("_$TR(mySeqNo,".",",")_")=myID_""^""_myUserType"
		s @Value
		s RowArr(myID)=mySeqNo_""
	}
	///找到相邻的同级别或者高于自己级别的顺序号
	s NextSequence=##Class(web.DHCDocPatAssPlan).GetNearNode(SeqNo,"Down",.SeqNoArr)
	s MaxSequence=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,""),-1)
	s MaxSequence=$TR(MaxSequence," ","")
	
	if (NextSequence=""){
		s SubMaxSequence=MaxSequence
	}else{
		s SubMaxSequence=NextSequence-1
	}
	s NeedDelCount=SubMaxSequence-Sequence+1
	
	TS
	s Err=0
	for i=Sequence:1:SubMaxSequence {
		s DelRowID=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,i,0))
		&SQL(delete SQLUser.DHC_DocPatAssPlan WHERE PAP_RowID=:DelRowID)
		s Err=Err+SQLCODE
	}
	if (NextSequence'=""){
		for i=NextSequence:1:(MaxSequence) {
			s UpdateRowID=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,i,0))
			s UpdateSequence=$list(^DHCDocPatAssPlanD(UpdateRowID),23)
			s NewSequence=(UpdateSequence-NeedDelCount)
			&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Sequence=:NewSequence WHERE PAP_RowID=:UpdateRowID)
			s Err=Err+SQLCODE
			
		}
	}
	if (Err){
		TRO
		q -1
	}else{
		TC
	}
	q 0
}

ClassMethod LoadAssPlanFav(SaveTypeStr As %String, SaveReferStr As %String, UserType As %String) As %String
{
	;w ##Class(web.DHCDocPatAssPlan).LoadAssPlanFav("User.CTLoc","15","DOCTOR")
	s ^tan("LoadAssPlanFav")=SaveTypeStr_","_SaveReferStr_","_UserType
	Q:(SaveTypeStr="")||(SaveReferStr="")||(UserType="") "[]"
	k ItemList
	for i=1:1:$length(SaveTypeStr,"^"){
		s SaveType=$P(SaveTypeStr,"^",i)
		s SaveRefer=$P(SaveReferStr,"^",i)
		s Directory=""
		for {
			s Directory=$O(^DHCDocAssPlanFavI("SaveType"," "_$ZCVT(SaveType,"U")," "_SaveRefer,Directory))
			q:Directory=""
			s Parent=$TR(Directory," ","")
			s ID=""
			for {
				s ID=$O(^DHCDocAssPlanFavI("SaveType"," "_$ZCVT(SaveType,"U")," "_SaveRefer,Directory,ID))
				q:ID=""
				continue:'$D(^DHCDocAssPlanFavD(ID))
				s LoopUserType=$list(^DHCDocAssPlanFavD(ID),4)
				continue:LoopUserType'=UserType
				s ParentNodeStr=..GetNodeStr(ID)
				///此处的id可改为顺序号，扩展以后的排序功能
				if (ParentNodeStr'=""){
					s NodeStr=ParentNodeStr_","_ID
				}else{
					s NodeStr=ID
				}
				x "s ItemList("_NodeStr_")="_ID
			}
		}
	}
	b ;ItemList
	s rows=$$OutItemList(.ItemList)
	Q rows.%ToJSON()
OutItemList(List)
	n (List)
	s rows=[]
	s stream = ##Class(%GlobalBinaryStream).%New()
	s Node=0 for{
		s Node=$O(List(Node)) Q:Node=""
		s ID=$g(List(Node))
		s obj=##Class(User.DHCDocAssPlanFav).%OpenId(ID)
		continue:'$ISOBJECT(obj)
		s Title=obj.PAPTitle
		d stream.Clear(),stream.CopyFrom(obj.APFPatSymptom)
		s PatSymptom=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFExpectedGoal)
		s ExpectedGoal=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFMeasures)
		s Measures=stream.Read()
		s APFState=obj.APFState
		d obj.%Close()
		
		s PatSymptom=..CheckJsonData(PatSymptom)
		s ExpectedGoal=..CheckJsonData(ExpectedGoal)
		s Measures=..CheckJsonData(Measures)
		s row={}
		s row.RowID=ID
		s row.Title=Title
		s row.UserType=obj.APFUserType
		s row.PatSymptom=PatSymptom
		s row.ExpectedGoal=ExpectedGoal
		s row.Measures=Measures
		if $O(List(Node,0))>0{
			k ChildList
			m ChildList=List(Node)
			s row.children=$$OutItemList(.ChildList)
		}
		d rows.%Push(row)
		
	}
	Q rows
}

/// 递归调用，遍历所有子节点
ClassMethod BuildMenuJsonItem(root As %String, LoopNode As %String) As %String
{
	n (root,LoopNode)
	Set Itemstream=##class(%Stream.GlobalCharacter).%New()
	do Itemstream.Rewind()
	d Itemstream.Write("[")
	s stream = ##Class(%GlobalBinaryStream).%New()
	set json=""
	s Node=0
	for {
		s value="Node=$O(^DHCDocAssPlanFavTmp("""_root_""","_LoopNode_","_Node_"))"
		s @value
		q:Node=""
		s value="NodeID=$g(^DHCDocAssPlanFavTmp("""_root_""","_LoopNode_","_Node_"))"
		s @value
		s obj=##Class(User.DHCDocAssPlanFav).%OpenId(NodeID)
		s Title=obj.PAPTitle
		d stream.Clear(),stream.CopyFrom(obj.APFPatSymptom)
		s PatSymptom=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFExpectedGoal)
		s ExpectedGoal=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFMeasures)
		s Measures=stream.Read()
		s myUserType=obj.APFUserType
		s APFState=obj.APFState
		d obj.%Close()
		
		s PatSymptom=..CheckJsonData(PatSymptom)
		s ExpectedGoal=..CheckJsonData(ExpectedGoal)
		s Measures=..CheckJsonData(Measures)

		
		
		i Itemstream.SizeGet()>1 d Itemstream.Write(",")
		d Itemstream.Write("{")
		d Itemstream.Write("""RowID"":"""_NodeID_""",""Title"":"""_Title_""",""UserType"":"""_myUserType_""",""PatSymptom"":"""_PatSymptom_""",""ExpectedGoal"":"""_ExpectedGoal_""",""Measures"":"""_Measures_""",")
		if (APFState="1"){
			s Collap="opened"
		}else{
			s Collap="closed"
		}
		s amdValue="NextNode=$O(^DHCDocAssPlanFavTmp("""_root_""","_LoopNode_","_Node_",0))"
		s @amdValue
		if NextNode="" s Collap="opened"

		d Itemstream.Write("""expanded"":false,""state"":"""_Collap_""",")
		d Itemstream.Write("""leaf"":false")
		s jsonItem=..BuildMenuJsonItem(root,LoopNode_","_Node)
		i $IsObject(jsonItem) {
			d Itemstream.Write(",""children"":")
			d jsonItem.Rewind()
			While (jsonItem.AtEnd = 0) 
			{
				Set len = 1024
				set json= jsonItem.Read(len)
				d Itemstream.Write(json)
			}
		}
		d Itemstream.Write("}")
		
	}
	
	d Itemstream.Write("]")
	q Itemstream
}

/// /// w ##Class(web.DHCDocPatAssPlan).GetNodeStr(6)
ClassMethod GetNodeStr(ID As %String) As %String
{
	n (ID)
	q:ID<=0 ""
	///获取父节点
	///向上寻找其主节点，并建立相关索引
	s LoopIndexStr=""
	s LoopParent=ID
	for{
		s LoopParent=$LG($G(^DHCDocAssPlanFavD(LoopParent)),2)
		if (LoopParent>0){
			if (LoopIndexStr'=""){
				s LoopIndexStr=LoopParent_","_LoopIndexStr
			}else{
				s LoopIndexStr=LoopParent
			}
			
		}else{
			q
		}
	}
	
	q LoopIndexStr
}

/// 获取子节点
/// w ##Class(web.DHCDocPatAssPlan).GetSubNodeStr(1)
ClassMethod GetSubNodeStr(RowID As %String, Level As %String = "") As %String
{
	n (RowID,Level)
	s NextIndexStr=""
	s SubNode=0
	for {
		s SubNode=$O(^DHCDocAssPlanFavI("Directory"," "_RowID,SubNode))
		q:SubNode=""
		if (Level'=""){
			s SubNodeStr=Level_":"_SubNode
		}else{
			s SubNodeStr=SubNode
		}
		if (NextIndexStr=""){
			s NextIndexStr=SubNodeStr	
		}else{
			s NextIndexStr=NextIndexStr_"^"_SubNodeStr
		}
		if $D(^DHCDocAssPlanFavI("Directory"," "_SubNode)){
			if (Level'=""){
				s myNextIndexStr=..GetSubNodeStr(SubNode,(Level+1))
			}else{
				s myNextIndexStr=..GetSubNodeStr(SubNode)
			}
			
			s NextIndexStr=NextIndexStr_"^"_myNextIndexStr
		}
	}
	q NextIndexStr
}

/// w ##Class(web.DHCDocPatAssPlan).InserAPFNode($P(^tan("InserAPFNode"),",",1),$P(^tan("InserAPFNode"),",",2),$P(^tan("InserAPFNode"),",",3),$P(^tan("InserAPFNode"),",",4),$P(^tan("InserAPFNode"),",",5),$P(^tan("InserAPFNode"),",",6))
ClassMethod InserAPFNode(RowID As %String, parent As %String, Title As %String, UserType As %String, SaveType As %String, SaveRefer As %String) As %String
{
	s ^tan("InserAPFNode")=RowID_","_parent_","_Title_","_UserType_","_SaveType_","_SaveRefer
	if (RowID'="")&&('$D(^DHCDocAssPlanFavD(RowID))) {
		s RowID=""
	}
	if (RowID'=""){
		s obj=##Class(User.DHCDocAssPlanFav).%OpenId(RowID)
	}else{
		s obj = ##class(User.DHCDocAssPlanFav).%New()
	}
	s obj.PAPPreDirectory=+parent
	s obj.PAPTitle=Title
	s obj.APFSaveType=SaveType
	s obj.APFSaveRefer=SaveRefer
	s obj.APFUserType=UserType
	//s:RowID="" obj.APFState="1"
	s sc=obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"
		q myrtn
	}
	q obj.%Id()
}

/// w ##Class(web.DHCDocPatAssPlan).SavePatAssToFav($P(^tan("SavePatAssToFav"),",",1),$P(^tan("SavePatAssToFav"),",",2))
ClassMethod SavePatAssToFav(PatAssRowID As %String, FavNodeRowID As %String, Title As %String) As %String
{
	s ^tan("SavePatAssToFav")=PatAssRowID_","_FavNodeRowID_","_Title
	
	s UserType=$List(^DHCDocAssPlanFavD(FavNodeRowID),4)
	s SaveType=$List(^DHCDocAssPlanFavD(FavNodeRowID),8)
	s SaveRefer=$List(^DHCDocAssPlanFavD(FavNodeRowID),9)
	
	s EpisodeID=$list(^DHCDocPatAssPlanD(PatAssRowID),2)
	k DataArr
	k SeqNoArr
	k RowArr
	d ##Class(web.DHCDocPatAssPlan).SortData(EpisodeID,.DataArr)
	s Sequence=""
	for {
		s Sequence=$O(DataArr(Sequence))
		q:Sequence=""
		s ID=$G(DataArr(Sequence,"ID"))
		s SeqNo=$G(DataArr(Sequence,"SeqNo"))
		s myUserType=$list(^DHCDocPatAssPlanD(ID),3)
		s Value="SeqNoArr("_$TR(SeqNo,".",",")_")=ID_""^""_myUserType"
		s @Value
		s RowArr(ID)=SeqNo_""
	}
	
	s Sequence=$list(^DHCDocPatAssPlanD(PatAssRowID),23)
	s Level=$list(^DHCDocPatAssPlanD(PatAssRowID),24)
	s SeqNo=RowArr(PatAssRowID)
	
	s APFRowID=$$Insert(PatAssRowID,FavNodeRowID,Title)
	
	d LoopSeqNo(SeqNo,APFRowID)
	q 0
	
	
LoopSeqNo(mySeqNo,ParentFavNodeRowID)
	n (mySeqNo,ParentFavNodeRowID,RowArr,SeqNoArr,UserType, SaveType, SaveRefer)
	;in LoopSeqNo
	s NextSeqNo=0
	for {
		s Vale="NextSeqNo=$O(SeqNoArr("_$TR(mySeqNo,".",",")_",NextSeqNo))"
		s @Vale
		q:NextSeqNo=""
		s Value="mySeqStr=SeqNoArr("_$TR(mySeqNo,".",",")_",NextSeqNo)"
		s @Value
		
		s NextPatAssRowID=0
		s PatAssPlanID=$P(mySeqStr,"^",1)
		s APFRowID=$$Insert(PatAssPlanID,ParentFavNodeRowID,"")
		s Value="Just=$D(SeqNoArr("_$TR(mySeqNo,".",",")_",NextSeqNo))"
		s @Value
		if (Just=11){
			d LoopSeqNo(mySeqNo_"."_NextSeqNo,APFRowID)
		}
	}
	q 0
Insert(PatAssPlanID,ParentFavNodeRowID,Title)
	n (PatAssPlanID,ParentFavNodeRowID,Title,UserType, SaveType, SaveRefer)
	s stream = ##Class(%GlobalBinaryStream).%New()
	s APFRowID=..InserAPFNode("" ,ParentFavNodeRowID, Title , UserType, SaveType, SaveRefer)
	s obj=##Class(User.DHCDocPatAssPlan).%OpenId(PatAssPlanID)
	d stream.Clear(),stream.CopyFrom(obj.PAPPatSymptom)
	s PatSymptom=stream.Read()
	d stream.Clear(),stream.CopyFrom(obj.PAPExpectedGoal)
	s ExpectedGoal=stream.Read()
	d stream.Clear(),stream.CopyFrom(obj.PAPMeasures)
	s Measures=stream.Read()
	s err=..UpdateAPFNode(APFRowID, PatSymptom, ExpectedGoal , Measures)
	
	q APFRowID
}

ClassMethod UpdateAPFNode(RowID As %String, PatSymptom As %String, ExpectedGoal As %String, Measures As %String) As %String
{
	s ^tan("UpdateAPFNode")=RowID_","_PatSymptom_","_ExpectedGoal_","_Measures
	s stream = ##Class(%GlobalBinaryStream).%New()
	s PatSymptom=..CheckJsonData(PatSymptom)
	s ExpectedGoal=..CheckJsonData(ExpectedGoal)
	s Measures=..CheckJsonData(Measures)
	s obj=##Class(User.DHCDocAssPlanFav).%OpenId(RowID)
	
	d stream.Clear(),stream.Write(PatSymptom)
	d obj.APFPatSymptom.CopyFrom(stream)
	d stream.Clear(),stream.Write(ExpectedGoal)
	d obj.APFExpectedGoal.CopyFrom(stream)
	d stream.Clear(),stream.Write(Measures)
	d obj.APFMeasures.CopyFrom(stream)
	s sc=obj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"
		q myrtn
	}
	q 0
}

ClassMethod DeleteAPFNode(RowID As %String) As %String
{
	s ^tan("DeleteAPFNode")=RowID
	
	s NextIndexStr=..GetSubNodeStr(RowID)
	
	for i=1:1:$l(NextIndexStr,"^"){
		s SubRowID=$P(NextIndexStr,"^",i)
		&SQL(DELETE FROM SQLUser.DHC_DocAssPlanFav WHERE APF_RowID=:SubRowID)
	}
	&SQL(DELETE FROM SQLUser.DHC_DocAssPlanFav WHERE APF_RowID=:RowID)
	
	
	q 0
}

/// w ##Class(web.DHCDocPatAssPlan).GetUserType(153)
ClassMethod GetUserType(UserID As %String) As %String
{
	s CTCareProvDr=$P(^SSU("SSUSR",UserID),"^",14)
	if (CTCareProvDr=""){
		q "Other"
	}
	s CarPrvTp=$P(^CTPCP(CTCareProvDr,1),"^",4)
	s CarePrvTpDesc=$P(^CT("CPT",CarPrvTp),"^",2)
	s InternalType=$P(^CT("CPT",CarPrvTp),"^",4)
	
	if (CarePrvTpDesc["营养"){
		q "Dietitian"
	}
	if ("DOCTOR^NURSE"[InternalType){
		q InternalType
	}
	q "Other"
}

/// w ##Class(web.DHCDocPatAssPlan).InsFavToTable($P(^tan("InsFavToTable"),",",1),$P(^tan("InsFavToTable"),",",2),$P(^tan("InsFavToTable"),",",3),$P(^tan("InsFavToTable"),",",4))
ClassMethod InsFavToTable(FavRowID As %String, EpisodeID As %String, UserType As %String, SignUser As %String) As %String
{
	s ^tan("InsFavToTable")=FavRowID_","_EpisodeID_","_UserType_","_SignUser
	s stream = ##Class(%GlobalBinaryStream).%New()
	s SubNodeStr=##Class(web.DHCDocPatAssPlan).GetSubNodeStr(FavRowID,2)
	if (SubNodeStr'=""){
		s NodeStr="1:"_FavRowID_"^"_SubNodeStr
	}else{
		s NodeStr="1:"_FavRowID
	}
	s err=0
	ts
	for i=1:1:$L(NodeStr,"^"){
		s OneNodeStr=$P(NodeStr,"^",i)
		continue:OneNodeStr=""
		s myLevel=$P(OneNodeStr,":",1)
		s myRowID=$P(OneNodeStr,":",2)
		s obj=##Class(User.DHCDocAssPlanFav).%OpenId(myRowID)
		s Title=obj.PAPTitle
		d stream.Clear(),stream.CopyFrom(obj.APFPatSymptom)
		s PatSymptom=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFExpectedGoal)
		s ExpectedGoal=stream.Read()
		d stream.Clear(),stream.CopyFrom(obj.APFMeasures)
		s Measures=stream.Read()
		d obj.%Close()
		
		//s SymptomTimeInfo=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
		s SymptomTimeInfo=..%ZD(+$h)_" "_..%ZT(..%SysTime())
		s Param="^"_UserType_"^"_SymptomTimeInfo_"^"_PatSymptom_"^"_ExpectedGoal_"^"_Measures
		s Param=Param_"^"_"^"_SignUser_"^^"
		s Param=Param_"^^^"_myLevel
		s err=err+(..SavePAP(Param,EpisodeID))
	}
	if (err){
		tro
		q err
	}else{
		tc
		q err
	}
}

/// w ##Class(web.DHCDocPatAssPlan).MoveAction("3","Left","Other")
ClassMethod MoveAction(RowID As %String, MoveType As %String, UserType As %String) As %String
{
	s ^tan("MoveAction")=RowID_","_MoveType
	///Left,Right,Up,Down
	s EpisodeID=$list(^DHCDocPatAssPlanD(RowID),2)
	k DataArr
	k SeqNoArr
	k RowArr
	d ##Class(web.DHCDocPatAssPlan).SortData(EpisodeID,.DataArr)
	s Sequence=""
	for {
		s Sequence=$O(DataArr(Sequence))
		q:Sequence=""
		s ID=$G(DataArr(Sequence,"ID"))
		s SeqNo=$G(DataArr(Sequence,"SeqNo"))
		s myUserType=$list(^DHCDocPatAssPlanD(ID),3)
		s Value="SeqNoArr("_$TR(SeqNo,".",",")_")=ID_""^""_myUserType"
		s @Value
		s RowArr(ID)=SeqNo_""
	}
	
	s Sequence=$list(^DHCDocPatAssPlanD(RowID),23)
	s Level=$list(^DHCDocPatAssPlanD(RowID),24)
	s SeqNo=RowArr(RowID)
	
	if (MoveType="Left")||(MoveType="Right"){
		//找到自己同组的上一组
		//s PreSequence=$$GetNearNode(SeqNo,"Up")
		s PreSequence=..GetNearNode(SeqNo,"Up",.SeqNoArr)
		if (PreSequence=""){
			q -1
		}
		s PreID=$G(DataArr(PreSequence,"ID"))
		s PreUserType=$list(^DHCDocPatAssPlanD(PreID),3)
		if (PreUserType'=UserType){
			q -2
		}
		
		if (MoveType="Right"){
			s PreLevel=$list(^DHCDocPatAssPlanD(PreID),24)
			if (Level-PreLevel>=1){
				q -3
			}
		}else{
			if (Level=1){
				q -3
			}
		}
		//再找到自己的下一组
		//s NextSequence=$$GetNearNode(SeqNo,"Down")
		s NextSequence=..GetNearNode(SeqNo,"Down",.SeqNoArr)
		if (NextSequence'=""){
			s SubMaxSequence=NextSequence-1
		}else{
			s SubMaxSequence=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,""),-1)
			s SubMaxSequence=$TR(SubMaxSequence," ","")
		}
		for CurrSequence=Sequence:1:SubMaxSequence{
			s CurrID=$G(DataArr(CurrSequence,"ID"))
			s CurrLevel=$list(^DHCDocPatAssPlanD(CurrID),24)
			
			if (MoveType="Right"){
				s CurrLevel=CurrLevel+1
			}else{
				s CurrLevel=CurrLevel-1
			}
			&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Level=:CurrLevel WHERE PAP_RowID=:CurrID)
		}
	}elseif (MoveType="Up")||(MoveType="Down"){
		//先找到自己的下一组
		//s NextSequence=$$GetNearNode(SeqNo,"Down")
		s NextSequence=..GetNearNode(SeqNo,"Down",.SeqNoArr)
		s NextLevel=""
		if (NextSequence'=""){
			s NextID=$G(DataArr(NextSequence,"ID"))
			s NextLevel=$list(^DHCDocPatAssPlanD(NextID),24)
		}
		if (NextSequence'=""){
			s SubMaxSequence=NextSequence-1
		}else{
			s SubMaxSequence=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,""),-1)
			s SubMaxSequence=$TR(SubMaxSequence," ","")
		}
		if (MoveType="Up"){
			//找到自己同组的上一组
			//s PreSequence=$$GetNearNode(SeqNo,"Up")
			s PreSequence=..GetNearNode(SeqNo,"Up",.SeqNoArr)
			if (PreSequence=""){
				q -1
			}
			s PreID=$G(DataArr(PreSequence,"ID"))
			s PreLevel=$list(^DHCDocPatAssPlanD(PreID),24)
			if (PreLevel'=Level){
				q -1
			}
			
			s PreSubMaxSequence=(Sequence-1)
			for i=PreSequence:1:PreSubMaxSequence {
				s CurrSequence=i
				s ID=$G(DataArr(CurrSequence,"ID"))
				s CurrSequence=CurrSequence+(SubMaxSequence-Sequence+1)
				;w ID_","_CurrSequence,!
				&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Sequence=:CurrSequence WHERE PAP_RowID=:ID)
			}
			for i=Sequence:1:SubMaxSequence {
				s CurrSequence=i
				s ID=$G(DataArr(CurrSequence,"ID"))
				s CurrSequence=CurrSequence-(PreSubMaxSequence-PreSequence+1)
				;w ID_","_CurrSequence,!
				&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Sequence=:CurrSequence WHERE PAP_RowID=:ID)
			}
		}elseif(MoveType="Down"){
			if (NextLevel'=Level){
				q -1
			}
			///找到自己下一组的下一组的组长
			s NextSeqNo=$G(DataArr(NextSequence,"SeqNo"))
			//s NextSequenceForNext=$$GetNearNode(NextSeqNo,"Down")
			s NextSequenceForNext=..GetNearNode(NextSeqNo,"Down",.SeqNoArr)
			if (NextSequenceForNext'=""){
				s NextSubMaxSequence=NextSequenceForNext-1
			}else{
				s NextSubMaxSequence=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,""),-1)
				s NextSubMaxSequence=$TR(NextSubMaxSequence," ","")
				
			}
			for i=NextSequence:1:NextSubMaxSequence {
				s CurrSequence=i
				s ID=$G(DataArr(CurrSequence,"ID"))
				s CurrSequence=CurrSequence-(NextSequence-Sequence)
				;w ID_","_CurrSequence,!
				&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Sequence=:CurrSequence WHERE PAP_RowID=:ID)
			}
			for i=Sequence:1:SubMaxSequence {
				s CurrSequence=i
				s ID=$G(DataArr(CurrSequence,"ID"))
				s CurrSequence=CurrSequence+(NextSubMaxSequence-NextSequence+1)
				;w ID_","_CurrSequence,!
				&SQL(UPDATE SQLUser.DHC_DocPatAssPlan SET PAP_Sequence=:CurrSequence WHERE PAP_RowID=:ID)
			}
		}
	}
	q 0
}

/// w ##Class(web.DHCDocPatAssPlan).GetNearNode("550","Other")
ClassMethod GetNearNode(SeqNo As %String, Dire As %String, ByRef SeqNoArr) As %String
{
	;找到该节点下的最近的一个相同级别或大于自己级别的顺序号
	n (SeqNo,SeqNoArr,Dire)
	s NearSequence=""
	s i=-1
	for {
		s i=i+1
		q:(i>($l(SeqNo,".")-1))||(NearSequence'="")
		s CurrSeqNo=$P(SeqNo,".",1,$l(SeqNo,".")-i)
		
		if (Dire="Up"){
			s Value="NearSeqNo=$o(SeqNoArr("_$TR(CurrSeqNo,".",",")_"),-1)"
		}else{
			
			s Value="NearSeqNo=$o(SeqNoArr("_$TR(CurrSeqNo,".",",")_"))"
		}
		s Just="Just=$D(SeqNoArr("_$TR(CurrSeqNo,".",",")_"))"
		s @Just
		if (i>0)&&(Just)&&(Dire="Up"){
			s NearSeqNo=CurrSeqNo
		}else{
			s @Value
		}
		continue:NearSeqNo=""
		if (i>0)&&(Just)&&(Dire="Up"){
			
		}elseif ($P(CurrSeqNo,".",1,$L(CurrSeqNo,".")-1)'=""){
			s NearSeqNo=$P(CurrSeqNo,".",1,$L(CurrSeqNo,".")-1)_"."_NearSeqNo
		}else{
			if (Dire="Down"){
				s NearSeqNo=CurrSeqNo+1
			}else{
				s NearSeqNo=CurrSeqNo-1
			}
			
		}
		s Value="NearSeqStr=SeqNoArr("_$TR(NearSeqNo,".",",")_")"
		s @Value
		s NearRowID=$P(NearSeqStr,"^",1)
		s NearSequence=$list(^DHCDocPatAssPlanD(NearRowID),23)
	}
	q NearSequence
}

/// d ##Class(web.DHCDocPatAssPlan).SortData("",.DataArr)
ClassMethod SortData(EpisodeID As %String, ByRef DataArr) As %String
{
	n (EpisodeID,DataArr)
	s SeqNo=0
	s Sequence=0
	for {
		s Sequence=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,Sequence))
		q:Sequence=""
		s ID=$O(^DHCDocPatAssPlanI("PAPAdm"," "_EpisodeID,Sequence,0))
		s Level=$list(^DHCDocPatAssPlanD(ID),24)
		s DataArr(Sequence,"Level")=Level
		s DataArr(Sequence,"ID")=ID
		
	}
	s Sequence=0
	for {
		s Sequence=$O(DataArr(Sequence))
		q:Sequence=""
		s Level=$G(DataArr(Sequence,"Level"))
		s SeqNo=""
		//向上查找相同级别或者主级别的seqno，并在此基础上计算
		s PreSequence=Sequence
		for {
			s PreSequence=$O(DataArr(PreSequence),-1)
			q:PreSequence=""
			s PreLevel=$G(DataArr(PreSequence,"Level"))
			s PreSeqNo=$G(DataArr(PreSequence,"SeqNo"))
			if (PreLevel=Level){
				if (PreSeqNo["."){
					s SeqNo=$P(PreSeqNo,".",1,$L(PreSeqNo,".")-1)_"."_($P(PreSeqNo,".",$L(PreSeqNo,"."))+1)
				}else{
					s SeqNo=($P(PreSeqNo,".",$L(PreSeqNo,"."))+1)
				}
			}
			if (PreLevel<Level){
				s SeqNo=PreSeqNo_".1"
			}
			q:SeqNo'=""
		}
		if SeqNo="" s SeqNo=1
		s DataArr(Sequence,"SeqNo")=SeqNo
		s ID=DataArr(Sequence,"ID")
	}
	
	q 0
}

ClassMethod CheckJsonData(Data As %String) As %String
{
	n (Data)
	//s Data=$replace(Data,$C(10),"\n")
	s Data=##class(ext.util.String).Replace(Data,"""","|")
	s Data=##class(ext.util.String).Replace(Data,"\","|")
	s Data=##class(ext.util.String).Replace(Data,"'","‘")
	
	q Data
}

}
