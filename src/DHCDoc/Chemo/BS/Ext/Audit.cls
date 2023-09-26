/// CTOR: QP
/// DATE: 2020-07-04
/// DESC: 化疗单审核
Class DHCDoc.Chemo.BS.Ext.Audit Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-04
/// DESC: 查询审核科室
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.Audit","AuditLoc")
Query AuditLoc(InHosp = "", InLoc = "") As %Query(ROWSPEC = "id,text,default")
{
}

ClassMethod AuditLocExecute(ByRef qHandle As %Binary, InHosp = "", InLoc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s ^QP("jj")=$Lb(InHosp,InLoc)
 	s LocType=##class(DHCDoc.Chemo.COM.Func2).GetDepType(InLoc)
 	s LocArr=##class(DHCDoc.Chemo.BS.Data).GetData("BD","AuditLoc")
 	f i=1:1:$l(LocArr,",") d
 	.s id=$P(LocArr,",",i)
 	.s type=##class(DHCDoc.Chemo.COM.Func2).GetDepType(id)
 	.s default=0
 	.s text=$p(^CTLOC(id),"^",2)
 	.s hosp=$p(^CTLOC(id),"^",22)
 	.q:(InHosp'="")&&(InHosp'=hosp)
 	.i (type=LocType) s default=1
 	.d output1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,text,default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod AuditLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AuditLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditLocExecute ]
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

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 审核医生
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.Audit","AuditDoc",9)
Query AuditDoc(depid = "") As %Query(ROWSPEC = "id,text")
{
}

/*ClassMethod AuditDocExecute(ByRef qHandle As %Binary, depid = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s LocArr=##class(DHCDoc.Chemo.BS.Data).GetData("BD","AuditLoc")
 	s DocArr=##class(DHCDoc.Chemo.BS.Data).GetData("BD","AuditDoc")
 	f i=1:1:$l(DocArr,",") {
	 	s uid=$p(DocArr,",",i)
	 	s docName=$p(^SSU("SSUSR",uid),"^",2)
	 	d output2
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	Set Data=$lb(uid,docName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}*/
ClassMethod AuditDocExecute(ByRef qHandle As %Binary, depid = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s LocArr=##class(DHCDoc.Chemo.BS.Data).GetData("BD","AuditLoc")
 	s DocArr=##class(DHCDoc.Chemo.BS.Data).GetData("BD","AuditDoc")
 	K TList
 	i depid'="" d
    .s dep=""
    .f  s dep=$o(^RB("RES",0,"CTLOC",dep))  q:dep=""  d
    ..q:(depid'="")&&(dep'=depid)
    ..s RowId=""
    ..f  s RowId=$o(^RB("RES",0,"CTLOC",dep,RowId))  q:RowId=""  d
    ...s docid=$p($g(^RB("RES",RowId)),"^",2) 
    ...q:docid=""
    ...s CTCarPrvTpDR=$P($g(^CTPCP(docid,1)),"^",4)
	...s docName=$P($g(^CTPCP(docid,1)),"^",2)
	...s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(docid)
	...Q:##class(DHCDoc.Chemo.COM.Func).InArray(DocArr,uid)=0
	...q:$d(TList(uid))
	...S TList(uid)=""

    ...d output2
 	
 	;b ;001
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output2
	Set Data=$lb(uid,docName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod AuditDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AuditDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditDocExecute ]
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

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 查询审核列表
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.Audit","QryList","","","Apply^12213^4^0^2")
Query QryList(StartDate = "", EndDate = "", mList = "") As %Query(ROWSPEC = "id,patName,appUser,appLoc,appDT,chemoDate,status,statusDesc,PLID,PSID,patientDR,admid,PLName,LinkPDAID,LinkDate")
{
}

ClassMethod QryListExecute(ByRef qHandle As %Binary, StartDate = "", EndDate = "", mList = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s ^QP("QryList")=$LB(StartDate,EndDate,mList)
 	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	s Type=$p(mList,"^",1)
 	s UserID=$p(mList,"^",2)
 	s LocID=$p(mList,"^",3)
 	s HasPass=$p(mList,"^",4)
 	s InHosp=$p(mList,"^",5)
 	s LocType=##class(DHCDoc.Chemo.COM.Func2).GetDepType(LocID)
	;b ;;001
 	i (LocType="")||(LocType="H") {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	/*
 	 1.判断申请科室是否属于本院区
 	 2.属于本院区：
 	 	判断科室类型，是否和申请的病人类型一致。
 	 	判断当前医生是否有权限，无权限过滤掉。
 	
 	*/
 	k PList,HList
 	s HList(0)=""
 	/*
 		PList(): 
 		HList(): 已存在
 	*/
 	i (StartDate'="")&&(EndDate'="") {
		i (StartDate>EndDate) {
	 		Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
		//f cDate=StartDate:1:EndDate d
		f cDate=EndDate:-1:StartDate d
		.s PDID=""
		.f  s PDID=$o(^BS.DOC.Chemo.PlanDateI("Date",cDate,PDID))  q:PDID=""  d
		..s sub=""
		..f  s sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub)) q:sub=""  d
		...d output3
	} else {
		s PDID=""
		f  s PDID=$O(^BS.DOC.Chemo.PlanDateD(PDID),-1) Q:PDID=""  d
		.s sub=""
		.;Q:PDID'="1309"
		.f  s sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),-1) q:sub=""  d
		..d output3
	}
 	
 	;合并输出
 	B ;001
 	/*s id=""
 	f  s id=$o(PList(id),-1) q:id=""  d
 	.q:$D(HList(id))
 	.s outData=PList(id)
 	.d OuputListRow*/
 	
 	s seqno=""
 	f  s seqno=$o(PList(seqno),-1) q:seqno=""  d
 	.s id=""
 	.f  s id=$o(PList(seqno,id),-1) q:id=""  d
 	..q:$D(HList(seqno,id))
 	..s outData=PList(seqno,id)
 	..d OuputListRow
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
IsExit(UserID,LocID,Type,status,appUser,needUser,needLoc)
	s mRtn=0
	i Type="Apply" {
		i (appUser'=UserID) {
			Q 1	
		}
	}
	i Type="KS" {
		i (needLoc'=LocID)||(needUser'=UserID)  {
			Q 1	
		}
		i (HasPass=1) {	//已审核
			s KSPass="S,RS,Y,RY"
			i KSPass'[status {
				Q 1	
			}
		} else {		//未审核
			i status'="A" {
				Q 1	
			}
		}
	}
	i Type="YJK" {
		s YJKLoc=$g(^CF.DOC.Chemo.Local("BD","YJKLoc"))
		s YJKDoc=$g(^CF.DOC.Chemo.Local("BD","YJKDoc"))
		b ;002
		i ##class(DHCDoc.Chemo.COM.Func).InArray(YJKLoc,LocID)'=1 {
			Q 1
		}
		i ##class(DHCDoc.Chemo.COM.Func).InArray(YJKDoc,UserID)'=1 {
			Q 1
		}
		i (HasPass=1) {	//已审核
			s KSPass="Y,RY"
			i KSPass'[status {
				Q 1	
			}
		} else {		//未审核
			i status'="S" {
				Q 1	
			}
		}
	}
	Q mRtn
output3
	s id=PDID_"||"_sub
	s status=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",3)
	Q:status["C"
	s statusDesc=..GetStatusDesc(status)
	s appUserDR=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",1)
	s appUser=$p(^SSU("SSUSR",appUserDR),"^",2)
	s appLocDR=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",2)
	s appHosp=##class(DHCDoc.Chemo.COM.Func2).GetDepHosp(appLocDR)
	Q:appHosp'=InHosp
	//s RLocdesc="3"
	//if RLocdesc'="" Q:appLocDR'=RLocdesc
	s appLoc=$p(^CTLOC(appLocDR),"^",2)
	s appDate=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",4)
	s appDate=##class(websys.Conversions).DateLogicalToHtml(appDate)
	s appTime=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",5)
	s appDT=appDate_" "_$zt(appTime,2)
	s chemoDate=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",5)
	s chemoDate=##class(websys.Conversions).DateLogicalToHtml(chemoDate)
	s patientDR=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",3)
	s admid=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",4)
	Q:'$D(^PAPER(patientDR,"ALL"))
	s patName=$p(^PAPER(patientDR,"ALL"),"^",1)
	s admType=$p(^PAADM(admid),"^",2)
	q:admType'=LocType
	s PLID=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",1)
	s PSID=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",2)
	s needUser=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",6)
	s needLoc=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",7)
	s isExit=$$IsExit(UserID,LocID,Type,status,appUserDR,needUser,needLoc)
	q:isExit=1
	s PLName=$p(^BS.DOC.Chemo.PlanD(PLID),"^",2)
	s PLStatus=$p(^BS.DOC.Chemo.PlanD(PLID),"^",7)
	q:PLStatus="D"	//删除的方案过滤
	s LinkPDAID=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",13)
	s LinkDate=##class(DHCDoc.Chemo.BS.Ext.Audit).GetLinkDate(id)
	Set Data=$lb(id,patName,appUser,appLoc,appDT,chemoDate,status,statusDesc,PLID,PSID,patientDR,admid,PLName,LinkPDAID,LinkDate)
	
	d ..DoPList(.PList,.HList,id,LinkPDAID,Data)
	Q
	
OuputListRow
	Set ^CacheTemp(repid,ind)=outData
	Set ind=ind+1
	quit
}

ClassMethod QryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryListExecute ]
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

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 获取状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).GetStatusDesc("RY")
ClassMethod GetStatusDesc(mCode As %String)
{
	s mRtn=""
	i mCode="A" s mRtn="申请审核"
	i mCode="S" s mRtn="方案通过（医师）"
	i mCode="RS" s mRtn="方案不通过（医师）"
	i mCode="Y" s mRtn="方案通过（药房）"
	i mCode="RY" s mRtn="方案不通过（药房）"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-13
/// DESC: 是否是当前日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).IsCurrentDate("2020-07-13","")
ClassMethod IsCurrentDate(mDate As %String, cDate As %String = "")
{
	s mDate=##class(websys.Conversions).DateHtmlToLogical(mDate)
	i cDate="" {
		s cDate=+$h
	} else {
		s cDate=##class(websys.Conversions).DateHtmlToLogical(cDate)
	}
	
	Q mDate=cDate
}

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 审核
/// IN  : 
/// OUT : 0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).Verify("477||5","S^12240^52^2","KS","478||5,479||5,480||5,481||5,482||5,483||5,484||5,485||5,486||5,487||5,488||5,489||5,490||5")
ClassMethod Verify(PDAID, mList, Type, Reason = "", LinkPDAID = "")
{
	
	s ^QP("Verify")=$LB(PDAID, mList,Type,Reason)
	s mRtn=0
	Q:PDAID="" mRtn
	s PDList=PDAID
	i LinkPDAID'="" s PDList=PDList_","_LinkPDAID
	s InPDID=+PDAID,SUB=$P(PDAID,"||",2)
	s OldStatus=$p(^BS.DOC.Chemo.PlanDateD(InPDID,"A",SUB),"^",3)
	b ;001
	if (Type="KS") {
		if (OldStatus = "S") {
			Q "-1^已同意了此方案!"
		} elseif (OldStatus = "RS") {
			Q "-1^已拒绝了此方案!"
		} else {}
	} elseif (Type="YJK") {
		if (OldStatus = "Y") {
			Q "-1^已同意了此方案!"
		} elseif (OldStatus = "RY") {
			Q "-1^已拒绝了此方案!"
		} else {}
	} else {}
	
	s status=$p(mList,"^",1)
	s user=$p(mList,"^",2)
	s loc=$p(mList,"^",3)
	s InHosp=$p(mList,"^",4)
	i InHosp="" s InHosp=##class(DHCDoc.Chemo.COM.Func2).GetDepHosp(loc)
	s CDate=+$H
	s CTime=$P($H,",",2)
		
	TS
	f i=1:1:$l(PDList,",") {
		s PDAID=$P(PDList,",",i)
		s PDID=+PDAID
		&SQL(
			UPDATE SQLUser.Chemo_PlanDateApply
			SET PDA_Reason=:Reason,PDA_AuditDate=:CDate,PDA_AuditTime=:CTime,
				PDA_Status=:status,PDA_AuditUser=:user,PDA_AuditLoc=:loc
			WHERE PDA_ID=:PDAID
		)
		i SQLCODE'=0 {
			 s mRtn=SQLCODE
			 Q
		
		}
		
		i status["R" {
			s DList=user_$C(1)_loc_$C(1)_"R"
			d ##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,DList)
			//停医嘱
			d ..StopOrderByPDAID(PDAID,user)
		}
		//将医嘱更改为核实状态
		i status="Y" {
			//更改日期状态
			s DList=user_$C(1)_loc_$C(1)_"Y"
			d ##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,DList)
		
			s OrdItemStr=##class(DHCDoc.Chemo.BS.DateApply).GetApplyOrder(PDAID)
			s Adm=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",4)
			i OrdItemStr'="" {
				s mRtn=##class(DHCDoc.Chemo.COM.Func2).VerifyOrder(Adm,OrdItemStr,user,loc)
				;s mRtn=##class(web.DHCOEOrdItem).SavePractiseDocOrderItems(Adm , user , OrdItemStr, loc)
		
				i mRtn'=0 {
					Q	
				}
				//计费帐单
				d ##class(web.DHCOEOrdItem).InvokeBill(Adm,user,"")
			}
		}
		//发送消息,只发送一次消息
		i i=1 {
			s result=##class(DHCDoc.Chemo.BS.Ext.Message).Send(Type,PDAID,user,loc,status,InHosp)
		}
		
		i result'=1 s mRtn=result
		i mRtn'=0 {
			Q	
		}
	}
	i mRtn'=0 {
		TRO
		Q mRtn
	}
	
	TC
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 获取状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).Test()
ClassMethod Test()
{
	s user=12224
	s loc=19
	s PDID=77
	s OrdItemStr=##class(DHCDoc.Chemo.BS.DateApply).GetApplyOrder("77||15")
	s Adm=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",4)
	B ;0012
	s mRtn=##class(web.DHCOEOrdItem).SavePractiseDocOrderItems(Adm , user , OrdItemStr, loc)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-12
/// DESC: 查询化疗拒绝原因
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.Audit","QryRefuseReason")
Query QryRefuseReason() As %Query(ROWSPEC = "id,text")
{
}

ClassMethod QryRefuseReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=""
 	f  s id=$o(^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",id)) q:id=""  d
 	.s text=$g(^CF.DOC.Chemo.Local("PAGE","ChemoRefuse",id))
 	.d output4
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output4
	Set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryRefuseReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRefuseReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRefuseReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRefuseReasonExecute ]
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

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 组织所有输出List
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).TE()
ClassMethod DoPList(ByRef PList, ByRef HList, PDAID, LinkPDAID, Data)
{
	Q:(PDAID="") 0
	s PList(+PDAID,PDAID)=Data
	
	Q:LinkPDAID="" 0
	f i=1:1:$L(LinkPDAID,",") {
		s CID=$P(LinkPDAID,",",i)
		continue:CID=PDAID
		s PList(+PDAID,PDAID,CID)=""
		s HList(+CID,CID)=""
	}
	

	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 组织所有输出List
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).TE()
ClassMethod DoPListOld(ByRef PList, ByRef HList, PDAID, LinkPDAID, Data)
{
	Q:(PDAID="") 0
	s PList(PDAID)=Data
	
	Q:LinkPDAID="" 0
	f i=1:1:$L(LinkPDAID,",") {
		s CID=$P(LinkPDAID,",",i)
		continue:CID=PDAID
		s PList(PDAID,CID)=""
		s HList(CID)=""
	}
	

	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-12-09
/// DESC: 组织所有输出List
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).GetLinkDate("430||1")
ClassMethod GetLinkDate(PDAID)
{
	s mRtn=""
	Q:PDAID="" mRtn
	s PDID=+PDAID,sub=$p(PDAID,"||",2)
	s appDate=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",5)
	s appDate=##class(websys.Conversions).DateLogicalToHtml(appDate)
	s LinkPDAID=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",13)
	i LinkPDAID="" {
		s mRtn=##class(websys.Conversions).DateLogicalToHtml(appDate)
		
	} else {
		s mRtn=appDate
		f i=1:1:$l(LinkPDAID,",") {
			s CID=$P(LinkPDAID,",",i)
			continue:CID=PDAID
			s par=+CID
			s date=$p(^BS.DOC.Chemo.PlanDateD(par),"^",5)
			s appDate=##class(websys.Conversions).DateLogicalToHtml(date)
			i mRtn="" s mRtn=appDate
			e  s mRtn=mRtn_","_appDate
			
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-09
/// DESC: 组织所有输出List
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).StopOrderByPDAID("1339||1")
ClassMethod StopOrderByPDAID(PDAID, UserID)
{
	s mRtn=0
	s OrdList=""
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID,id)) q:id=""  d
	.s oeori=$p(^BS.DOC.Chemo.PlanOrderD(id),"^",1)
	.q:oeori=""
	.i OrdList="" s OrdList=oeori
	.e  s OrdList=OrdList_"^"_oeori
	//b ;001
	i OrdList'="" {
		s mRtn=##class(appcom.OEOrdItem).StopMulti(OrdList,UserID,"","N")
		Q:mRtn'=0 "-1"	
	}
	
	Q mRtn
}

}
