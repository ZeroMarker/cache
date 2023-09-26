Class web.DHCRBResEffDateSessAppQty Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Delete(RowId As %String) As %String
{
	&SQL(Delete From SQLUser.DHC_RBResEffDateSessAppQty Where AQ_RowId=:RowId )
	if (SQLCODE=0){
		d ..UpdateRBResEffDateSession(RowId)
	}
	Q SQLCODE
}

ClassMethod GetMethodStr() As %String
{
	s ret=""
	Set rset=##class(%ResultSet).%New("web.DHCRBResEffDateSessAppQty:LookupMethod")
	do rset.Execute()
	While (rset.Next()) {
	    s APTMRowId=rset.Data("APTMRowId")
		s APTMDateFrom=$p(^RBC("APTM",APTMRowId),"^",4)
		continue:(APTMDateFrom'="")&&(APTMDateFrom>+$h)
		s APTMDateTo=$p(^RBC("APTM",APTMRowId),"^",5)
		continue:(APTMDateTo'="")&&(APTMDateTo<=..%SysDate())
		if ret="" s ret=rset.Data("APTMRowId")_$C(1)_rset.Data("APTMDesc")
		e  s ret=ret_"^"_rset.Data("APTMRowId")_$C(1)_rset.Data("APTMDesc")
	}
	d rset.Close()
	Q ret
}

ClassMethod Insert(ResSessRowId As %String, Para As %String) As %String
{
	k PLIST
	s AQMethodDR=$P(Para,"^",1)
	s AQQty=$P(Para,"^",2)
	s AQStartNum=$P(Para,"^",3)
	s ResRowId=$P(ResSessRowId,"||",1)
	s DateRowId=$P(ResSessRowId,"||",2)
	s SessRowId=$P(ResSessRowId,"||",3)
	&SQL(Select Sum(AQ_Qty) Into :Total From SQLUser.DHC_RBResEffDateSessAppQty 
	Where AQ_ParRef=:ResSessRowId)
	&SQL(Select Sess_Load  Into :TotalLimit From SQLUser.RB_ResEffDateSession 
	Where Sess_RowId=:ResSessRowId)
	// s Total=(+Total)+AQQty
	// Q:Total>(+TotalLimit) "-201"
	// 判断是否超出最大号
	s EndNum=(AQStartNum+AQQty-1)
	Q:EndNum>(+TotalLimit) "-201"

	Set PLIST(2)=ResRowId
	Set PLIST(3)=DateRowId
	Set PLIST(4)=SessRowId
	Set PLIST(6)=AQMethodDR
	Set PLIST(7)=AQQty
	Set PLIST(9)=AQStartNum
	&SQL(Insert Into SQLUser.DHC_RBResEffDateSessAppQty values :PLIST())
	if (SQLCODE=0){
		s rowid=$p(%ROWID,$c(1))
		d ..UpdateRBResEffDateSession(rowid)
	}
	Q SQLCODE
}

ClassMethod UpdateRBResEffDateSession(rowid As %String) As %String
{
	s ^tempscl("UpdateRBResEffDateSession")=rowid 
	s ResSessRowId=$p(rowid,"||",1,3)
	&SQL(Select Sum(AQ_Qty) Into :Total From SQLUser.DHC_RBResEffDateSessAppQty Where AQ_ParRef=:ResSessRowId)
	&SQL(Select top 1 AQ_StartNum Into :minAppStartNo From SQLUser.DHC_RBResEffDateSessAppQty Where AQ_ParRef=:ResSessRowId order by 1 ASC)
	if (SQLCODE=100){
		s Total="",minAppStartNo="",SQLCODE=0
	}else{
		s rtn=..GetAppNumAndStatr(rowid)
		s minAppStartNo=$P(rtn,"^",1)	
		s Total=$P(rtn,"^",2)	
	}
	Set object = ##class(User.RBResEffDateSession).%OpenId(rowid)
	s object.SESSNoApptSlot=Total
 	s object.SESSNumberOfWeeks=minAppStartNo
 	Set sc = object.%Save()
	If $$$ISERR(sc) {
		 Do $System.Status.DisplayError(sc)
		 Quit 100
	}
	do object.%Close()
}

ClassMethod Update(Para As %String) As %String
{
	s AQRowid=$P(Para,"^",1)
	s AQMethodDR=$P(Para,"^",2)
	s AQQty=$P(Para,"^",3)
	s AQStartNum=$P(Para,"^",4)
	s ResSessRowId=$p(AQRowid,"||",1,3)
	&SQL(Select Sum(AQ_Qty) Into :Total From SQLUser.DHC_RBResEffDateSessAppQty 
	Where AQ_ParRef=:ResSessRowId)
	&SQL(Select AQ_Qty Into :OldQty From SQLUser.DHC_RBResEffDateSessAppQty 
	Where AQ_RowId=:AQRowid)
	s ResSessRowId=$P(AQRowid,"||",1,3)
	&SQL(Select Sess_Load  Into :TotalLimit From SQLUser.RB_ResEffDateSession 
	Where Sess_RowId=:ResSessRowId)
	//s Total=(Total-OldQty)+AQQty
	//Q:Total>TotalLimit "-201"
	// 判断最大号是否超出限额即可
	s EndNum=(AQStartNum+AQQty-1)
	Q:EndNum>(+TotalLimit) "-201"

	Set object = ##class(User.DHCRBResEffDateSessAppQty).%OpenId(AQRowid)
	 d object.AQMethodDRSetObjectId(AQMethodDR)
	 s object.AQQty=AQQty
	 s object.AQStartNum=AQStartNum
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Quit 100
	 }
	 d object.%Close()
	 d ..UpdateRBResEffDateSession(AQRowid)
	 Q 0
}

// 查询预约起始号和预约数量

ClassMethod GetAppNumAndStatr(AQRowid) As %String
{
	s StNum=""
	s AllNum=0
	s RowID=0
	f  s RowID=$O(^RB("RES",+AQRowid,"Date",$p(AQRowid,"||",2),"SESS",$p(AQRowid,"||",3),"AQ",RowID)) Q:RowID=""  d
	.s AppQty=$p(^RB("RES",+AQRowid,"Date",$p(AQRowid,"||",2),"SESS",$p(AQRowid,"||",3),"AQ",RowID),"^",2)
	.s AppStartNum=$p(^RB("RES",+AQRowid,"Date",$p(AQRowid,"||",2),"SESS",$p(AQRowid,"||",3),"AQ",RowID),"^",3)
	.if StNum="" s StNum=AppStartNum
	.if StNum>AppStartNum s StNum=AppStartNum
	.s endnum=(AppQty+AppStartNum-1)
	.if endnum>0 d
	..if endnum>AllNum s AllNum=endnum
	q StNum_"^"_AllNum
}

Query GetSessAppQtys(ResSessRowId As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "AQRowId:%String,AQMethod:%String,AQQty:%String,AQMethodDR:%String,AQStartNum:%String")
{
	Select AQ_Rowid,AQ_Method_DR->APTM_Desc,AQ_Qty,AQ_Method_DR,AQ_StartNum From SQLUser.DHC_RBResEffDateSessAppQty Where AQ_ParRef=:ResSessRowId
}

Query LookupMethod() As %SQLQuery(CONTAINID = 0, ROWSPEC = "APTMDesc,APTMRowId")
{
SELECT APTM_Desc,APTM_RowId FROM SQLUser.RBC_AppointMethod
}

// d ##class(%ResultSet).RunQuery("web.DHCRBResEffDateSessAppQty","FindAppQty","635||1840")

Query FindAppQty(ScheduleID As %String) As %Query(ROWSPEC = "ASQRowId:%String,ApptMethodDr:%String,AppMethodName:%String,AppQty:%String,AppStartNum:%String")
{
}

ClassMethod FindAppQtyExecute(ByRef qHandle As %Binary, ScheduleID As %String) As %Status
{
	n repid
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s APTMRowId=0
	f  s APTMRowId=$o(^RBC("APTM",APTMRowId)) q:APTMRowId=""  d
	.s RowID=0,findRecord=0
	.f  s RowID=$o(^RB("RES",+ScheduleID,"Date",$p(ScheduleID,"||",2),"SESS",$p(ScheduleID,"||",3),"AQ",RowID)) q:RowID=""  d
	..s Methoddr=$p(^RB("RES",+ScheduleID,"Date",$p(ScheduleID,"||",2),"SESS",$p(ScheduleID,"||",3),"AQ",RowID),"^",1)
	..q:Methoddr'=APTMRowId
	..s findRecord=1
	..s AppQty=$p(^RB("RES",+ScheduleID,"Date",$p(ScheduleID,"||",2),"SESS",$p(ScheduleID,"||",3),"AQ",RowID),"^",2)
	..s AppStartNum=$p(^RB("RES",+ScheduleID,"Date",$p(ScheduleID,"||",2),"SESS",$p(ScheduleID,"||",3),"AQ",RowID),"^",3)
	..s AppMethodName=$p($g(^RBC("APTM",Methoddr)),"^",2)
	..d OutPutRow
	.i findRecord=0 d
	..s AppMethodName=$p($g(^RBC("APTM",APTMRowId)),"^",2)
	..s Methoddr=APTMRowId,AppQty="",AppStartNum=""
	..d OutPutRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow
   	s Data=$lb(ScheduleID_"||"_RowID,Methoddr,AppMethodName,AppQty,AppStartNum)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
}

ClassMethod FindAppQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAppQtyExecute ]
{
	n repid
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAppQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAppQtyExecute ]
{
	n repid
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 k ^CacheTemp(repid)
	}Else {				// fetch rowf
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 1521||1003||21^1^1^1,1521||1003||^2^2^1,1521||1003||^20^0^0,1521||1003||^21^0^0,1521||1003||^22^0^0

// w ##class(web.DHCRBResEffDateSessAppQty).SaveScheduleAppQty("1521||1003||^1^1^1,1521||1003||^2^2^1,1521||1003||^20^0^0,1521||1003||^21^0^0,1521||1003||^22^0^0")

ClassMethod SaveScheduleAppQty(paraString As %String) As %String
{
	s ^temscl("SaveScheduleAppQty")=paraString
	s updateParaString="",err=0
	s len=$length(paraString,",")
	TS
	for i=1:1:len
	{
		s oneparaString=$p(paraString,",",i)
		s oneASQRowId=$p(oneparaString,"^",1)
		s ScheduleID=$p(oneASQRowId,"||",1,3)
		if ($p(oneASQRowId,"||",4)'=""){
			i updateParaString="" s updateParaString=oneparaString
			e  s updateParaString=updateParaString_","_oneparaString
		}else{
			s ScheduleID=$p(oneASQRowId,"||",1,3)
			s MethodId=$p(oneparaString,"^",2)
			s AllCount=$p(oneparaString,"^",3)
			s StartNum=$p(oneparaString,"^",4)
			if (AllCount=0)&&(StartNum=0) continue
			s err=..Insert(ScheduleID,MethodId_"^"_AllCount_"^"_StartNum)
		}
	}
	if (updateParaString'=""){
		set len=$length(updateParaString,",")
		for i=1:1:len
		{
			s oneparaString=$p(updateParaString,",",i)
			s err=..Update(oneparaString)
		}
		
	}
	if (err'=0){
		Trollback
		Q err
	}
	TC
    Q err
}

}
