Class web.DHCPAAdmSheets Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CancelSheet(SheetRowid As %Library.String, UserRowId As %Library.String) As %String
{
	; d ##class(web.DHCPAAdmSheets).CancelSheet(812,1312,0)
	s TaskFlag=0
	s StopDate=..%SysDate()
	s StopTime=..%SysTime()
	s SheetStatus="S" 
	TStart
	&SQL(Update SQLUser.DHC_PAAdmSheets set PAADMS_Status=:SheetStatus,
	     PAADMS_StopUser_Dr=:UserRowId,PAADMS_StopDate=:StopDate,PAADMS_StopTime=:StopTime 
 Where PAADMS_RowId=:SheetRowid)
	s TaskFlag=SQLCODE
	i SQLCODE'=0 TRollback
	q:(SQLCODE'=0) SQLCODE
	s child=0     
	f  s child=$O(^DHCPAADMS(SheetRowid,"I",child)) q:((child="")!(TaskFlag'=0))  d  
	.s OrderItemRowId=$P($g(^DHCPAADMS(SheetRowid,"I",child)),"^",1)
	.s BillFlag=$p($g(^OEORD(+OrderItemRowId,"I",+$p(OrderItemRowId,"||",2),3)),"^",5)
	.q:'((BillFlag="B")!(BillFlag="TB")) 
	.s RtnFlag=##class(web.DHCOEOrdItem).Stop(OrderItemRowId,UserRowId)
	.i RtnFlag'=0  s TaskFlag=RtnFlag
	.s StopSYDFlag=..StopSYDItem(OrderItemRowId,UserRowId)
	.i StopSYDFlag'=0  s TaskFlag=StopSYDFlag
	i (TaskFlag=0) TCommit
	e  TRollback
	q TaskFlag
}

ClassMethod ChangeSheetBillType(SheetRowid As %String, CurrentAdmDr As %String, GroupStr As %String, User As %String, Loc As %String, Doc As %String) As %String [ ProcedureBlock = 0 ]
{
	//修改费别
	; d ##class(web.DHCPAAdmSheets).ChangeSheetBillType("","","","","")

	k ^CacheTemp("ChangeSheetBillType",$j)	

	s OrdGroupCount=$L(GroupStr,$c(4))
	s err=0
	f i=2:1:OrdGroupCount	{	
		s GroupInfo=$P(GroupStr,$c(4),i)
		s OrdItemStr=$P(GroupInfo,$c(3),2)
		
		s OldItemCount=0
		Set OrdItemCount=$L(OrdItemStr,$c(1))
		f j=1:1:OrdItemCount {
			s OrdItem=$p(OrdItemStr,$c(1),j)
			s OrderItemRowid=$p(OrdItem,"^",31)
			s BillTypeRowid=$p(OrdItem,"^",9)
			i OrderItemRowid'=""  {
				s ^CacheTemp("ChangeSheetBillType",$j,OrderItemRowid)=BillTypeRowid
			}
		}		
	}
	
	s err=0
	s OrderItemRowid=""
	f  s OrderItemRowid=$o(^CacheTemp("ChangeSheetBillType",$j,OrderItemRowid)) q:OrderItemRowid=""  d 
	.s BillTypeRowid=$g(^CacheTemp("ChangeSheetBillType",$j,OrderItemRowid))
	.&SQL(Update SQLUser.OE_OrdItem set OEORI_BBExtCode=:BillTypeRowid Where OEORI_RowId=:OrderItemRowid)
	.i (SQLCODE'=0) s err=-100
	.q:(err=-100)
	k ^CacheTemp("ChangeSheetBillType",$j)
	q:(err=-100) -100
	q 0
}

ClassMethod ChangeSheets(SheetRowid As %String, CurrentAdmDr As %String, GroupStr As %String, User As %String, Loc As %String, Doc As %String) As %String [ ProcedureBlock = 0 ]
{
 ; 生成处方后,修改化疗单
 ; d ##class(web.DHCPAAdmSheets).ChangeSheets("","","","","","")
 /*
	s ^DHCXPTest("ChangeSheets","SheetRowid")=SheetRowid
	s ^DHCXPTest("ChangeSheets","CurrentAdmDr")=CurrentAdmDr 
	s ^DHCXPTest("ChangeSheets","GroupStr")=GroupStr
	s ^DHCXPTest("ChangeSheets","User")=User
	s ^DHCXPTest("ChangeSheets","Loc")=Loc
	s ^DHCXPTest("ChangeSheets","Doc")=Doc
	
	s SheetRowid=^DHCXPTest("ChangeSheets","SheetRowid")
	s CurrentAdmDr= ^DHCXPTest("ChangeSheets","CurrentAdmDr")
	s GroupStr=^DHCXPTest("ChangeSheets","GroupStr")
	s User=^DHCXPTest("ChangeSheets","User")
	s Loc=^DHCXPTest("ChangeSheets","Loc")
	s Doc=^DHCXPTest("ChangeSheets","Doc")
	q 0
	
	
	*/

	k ^CacheTemp("Log",$j)
	k ^CacheTemp("InsSheets","InsOrderItem")
	Ts	
	s ASRowId=SheetRowid
	s SheetStr=$P(GroupStr,$c(4),1)
	s Cycle=$P(SheetStr,"^",1)
	s StartDate=$P(SheetStr,"^",2)
	s EndDate=$P(SheetStr,"^",3)
	s SheetRemark=$P(SheetStr,"^",4)
	i StartDate'="" s StartDate=$ZDH(StartDate,4)
	e  s StartDate=..%SysDate()
	i EndDate'="" s EndDate=$ZDH(EndDate,4)
	e  s EndDate=..%SysDate()
	;日志
	s OldSheetRemark=$p($g(^DHCPAADMS(SheetRowid)),"^",10)
	s ^CacheTemp("Log",$j,"SheetMark","OldSheetRemark")=OldSheetRemark
	s ^CacheTemp("Log",$j,"SheetMark","NewSheetRemark")=SheetRemark
	
	s SheetStatus=$p(^DHCPAADMS(SheetRowid),"^",11)
	i SheetStatus=""  s SheetStatus="C"
	&sql(update SQLUser.DHC_PAAdmSheets set PAADMS_Remark=:SheetRemark,
				PAADMS_StartDate=:StartDate,PAADMS_EndDate=:EndDate,PAADMS_Status=:SheetStatus
	     where PAADMS_RowId=:SheetRowid)
	i SQLCODE'=0 {
		TRollback 
		q -100
	}
	
	s Adm=CurrentAdmDr
	s OrdGroupCount=$L(GroupStr,$c(4))
	s err=0
	f i=2:1:OrdGroupCount	{	
		s GroupInfo=$P(GroupStr,$c(4),i)
		s GroupRemark=$P($P(GroupInfo,$c(3),1),"^",1)
		s OrdItemStr=$P(GroupInfo,$c(3),2)		
		s OldItemCount=0
		s NewOrdItemStr=""
		s OrdItemCount=$L(OrdItemStr,$c(1))
		f j=1:1:OrdItemCount {
			s OrdItem=$p(OrdItemStr,$c(1),j)
			s OrderItemRowid=$p(OrdItem,"^",31)
			if OrderItemRowid="" {
				i NewOrdItemStr=""  s NewOrdItemStr=OrdItem
				e  s NewOrdItemStr=NewOrdItemStr_$c(1)_OrdItem
			}else{
				s SheetItemStatus=$p(OrdItem,"^",35)
				if (SheetItemStatus="S"){
					s StopRet=..StopOrdItem(OrderItemRowid,User)
					if (StopRet) {
						s err=-100 Break
					}
					s StopSYDFlag=..StopSYDItem(OrderItemRowid,User)
					if (StopSYDFlag) {
						s err=-100 Break
					}
				}
				s SIGroupStatus=$p(OrdItem,"^",38)
				if (SIGroupStatus="S"){
					s SheetRowid=$o(^DHCPAADMS("OEORI",OrderItemRowid,""))
					s ItemSub=$o(^DHCPAADMS("OEORI",OrderItemRowid,SheetRowid,""))
					s SavedSIGroupStatus=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",15)
					if ((SavedSIGroupStatus'="S")&&(SavedSIGroupStatus'="R")) {
						i SavedSIGroupStatus="A" s SIGroupStatus="R"
						&SQL(update SQLUser.DHC_PaadmSheetsItem set SI_GroupStatus=:SIGroupStatus
	     					where SI_OEORI_DR=:OrderItemRowid)
						i (SQLCODE) s err=-100 Break	
					}	
				}

				;更新前的备注信息和日期,日志
				s TempSheetRowid=$o(^DHCPAADMS("OEORI",OrderItemRowid,""))
				s TempItemSub=$o(^DHCPAADMS("OEORI",OrderItemRowid,TempSheetRowid,""))
				i (TempSheetRowid'="")&&(TempItemSub'="") s OldGroupRemark=$p($g(^DHCPAADMS(TempSheetRowid,"I",TempItemSub)),"^",4)
				s ^CacheTemp("Log",$j,"GroupNo",i,"OldGroupRemark")=OldGroupRemark
				s OldDepProcNotes=$g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DEP",1))
				s ^CacheTemp("Log",$j,"GroupNo",i,"OEORI",OrderItemRowid,"OldDepProcNotes")=OldDepProcNotes
				s OldExecuteDateStr=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",1)
				s ^CacheTemp("Log",$j,"GroupNo",i,"OldExecuteDateStr")=OldExecuteDateStr
				; 更新备注信息和日期
				s ExecuteDateStr=$p(OrdItem,"^",29)	
				s BillTypeRowid=$p(OrdItem,"^",9)
				s DepProcNotes=$p(OrdItem,"^",11)
				s VenousFillingFlag=$p(OrdItem,"^",36)
				s SolventFlag=$p(OrdItem,"^",37)
				s LBDepProcNotes=$lb(DepProcNotes)
				i ExecuteDateStr'="" s $p(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC"),"^",1)=ExecuteDateStr
				&SQL(Update SQLUser.OE_OrdItem set OEORI_BBExtCode=:BillTypeRowid,OEORI_DepProcNotes=:LBDepProcNotes Where OEORI_RowId=:OrderItemRowid)
				i (SQLCODE) s err=-100 Break
				&SQL(update SQLUser.DHC_PaadmSheetsItem set SI_GroupRemark=:GroupRemark,SI_VenousFillingFlag=:VenousFillingFlag,
						SI_SolventFlag=:SolventFlag where SI_OEORI_DR=:OrderItemRowid)
				i (SQLCODE) s err=-100 Break
				s OldItemCount=OldItemCount+1
				; 更新后的备注信息和日期,日志
				s ^CacheTemp("Log",$j,"GroupNo",i,"NewGroupRemark")=GroupRemark
				s ^CacheTemp("Log",$j,"GroupNo",i,"OEORI",OrderItemRowid,"NewDepProcNotes")=DepProcNotes
				s ^CacheTemp("Log",$j,"GroupNo",i,"NewExecuteDateStr")=ExecuteDateStr
			}
		}
		
		if (NewOrdItemStr'="") {
			Set Ret=..Insert(Adm,NewOrdItemStr,User,Loc,Doc)
			if (Ret=0)!(Ret=100) {
				s err=-100
				Break
			}
			
			s LastItemNo=$$GetLastItemNo(ASRowId,i-1)    
			f k=1:1:$l(Ret,"^")-1 {
				s newOrdIdDR=$p($p(Ret,"^",k),"*",2)
				Q:newOrdIdDR=""
				s VenousFillingFlag=$p($g(^CacheTemp("InsSheets","InsOrderItem",newOrdIdDR)),"^",1)
				s SolventFlag=$p($g(^CacheTemp("InsSheets","InsOrderItem",newOrdIdDR)),"^",2)
				Set object=##class(User.DHCPAAdmSheetsItem).%New(ASRowId)
				Do object.SISheetParRefSetObjectId(ASRowId)
				Do object.SIOEORIDRSetObjectId(newOrdIdDR)
				set object.SIGroupNo=i-1
				set object.SIGroupItemNo=k+LastItemNo  ; 注意:医嘱序号是在原来的医嘱的基础上累加的
				set object.SIGroupRemark=GroupRemark
				set object.SIStatus="A"
				set object.SIAddDate=..%SysDate()
				set object.SIAddTime=..%SysTime()
				set object.SIAddUserDr=User
				set object.SIVenousFillingFlag=VenousFillingFlag
				set object.SISolventFlag=SolventFlag
				s sc=object.%Save()
				If $$$ISERR(sc) {
					s err=-100
					break
				}
				d object.%Close()
			}
			if err=-100 break
		}
	}
	s err=##class(web.DHCSYD).InsertHLD(Adm)
	if err=-100 {
		tro
		q err
	}
	s err=$$SaveLog(SheetRowid,User)
	if err=-100 {
		tro
		k ^CacheTemp("Log",$j)
		q err
	}
	TC
	k ^CacheTemp("Log",$j)
	k ^CacheTemp("InsSheets","InsOrderItem")
	q 0


GetLastItemNo(ASRowId,i)
	; 取化疗单ASRowId第i组的最后一项的项目号
	s LastItemNo=1
	s ChildSub=""
	f  s ChildSub=$o(^DHCPAADMS(ASRowId,"I",ChildSub)) q:ChildSub=""  d
	.q:$p($g(^DHCPAADMS(ASRowId,"I",ChildSub)),"^",2)'=i
	.s SheetItemNo=$p($g(^DHCPAADMS(ASRowId,"I",ChildSub)),"^",3)
	.i LastItemNo<SheetItemNo  s LastItemNo=SheetItemNo
	q LastItemNo

SaveLog(SheetRowid,User)
	s LogStr=""
	s OldSheetRemark=$g(^CacheTemp("Log",$j,"SheetMark","OldSheetRemark"))
	s NewSheetRemark=$g(^CacheTemp("Log",$j,"SheetMark","NewSheetRemark"))
	i (OldSheetRemark'=NewSheetRemark) d 
	.s SheetMarkStr="将化疗单备注由 ["_OldSheetRemark_"] 修改为 ["_NewSheetRemark_"]"
	.s LogStr=LogStr_$c(13)_SheetMarkStr
	
	s i=0
	f  s i=$o(^CacheTemp("Log",$j,"GroupNo",i)) q:i=""  d
	.;化疗日期
	.s k=i-1
	.s OldExecuteDateStr=$g(^CacheTemp("Log",$j,"GroupNo",i,"OldExecuteDateStr"))
	.s NewExecuteDateStr=$g(^CacheTemp("Log",$j,"GroupNo",i,"NewExecuteDateStr"))
	.i (OldExecuteDateStr'=NewExecuteDateStr) d 
	..s OldExecuteDateStr=..ConvertDateFormat(OldExecuteDateStr,0)
	..s NewExecuteDateStr=..ConvertDateFormat(NewExecuteDateStr,0)
	..s ExecuteDateStrModifyStr="将第"_k_"组化疗日期由  ["_OldExecuteDateStr_"] 修改为 ["_NewExecuteDateStr_"]"
	..s LogStr=LogStr_$c(13)_ExecuteDateStrModifyStr
	.;组级日志
	.s OldGroupRemark=$g(^CacheTemp("Log",$j,"GroupNo",i,"OldGroupRemark"))
	.s NewGroupRemark=$g(^CacheTemp("Log",$j,"GroupNo",i,"NewGroupRemark"))
	.i (OldGroupRemark'=NewGroupRemark) d 
	..s GroupReMarkStr="将第"_k_"组备注由 ["_OldGroupRemark_"] 修改为 ["_NewGroupRemark_"]"
	..s LogStr=LogStr_$c(13)_GroupReMarkStr
	.;药品级日志
	.s OrderItemRowid=0
	.f  s OrderItemRowid=$o(^CacheTemp("Log",$j,"GroupNo",i,"OEORI",OrderItemRowid)) q:OrderItemRowid=""  d 
	..s ARCIMRowid=$p($g(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),1)),"^",2)		;OEORI_ItmMast_DR
	..s ARCIMSubScript=$p(ARCIMRowid,"||",1)
	..s ARCIMSubVersion=$p(ARCIMRowid,"||",2)
	..s OrderName=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)
	..;药品备注
	..s OldDepProcNotes=$g(^CacheTemp("Log",$j,"GroupNo",i,"OEORI",OrderItemRowid,"OldDepProcNotes"))
	..s NewDepProcNotes=$g(^CacheTemp("Log",$j,"GroupNo",i,"OEORI",OrderItemRowid,"NewDepProcNotes"))
	..i (OldDepProcNotes'=NewDepProcNotes) d 
	...s DepProcNotesStr="将第"_k_"组药品"_OrderName_"备注由 ["_OldDepProcNotes_"] 修改为 ["_NewDepProcNotes_"]"
	...s LogStr=LogStr_$c(13)_DepProcNotesStr
	i LogStr'=""  d
	.s UserName=$p(^SSU("SSUSR",User),"^",2)
	.s ChangeDate=$zd(+$h,3)
	.s ChangeTime=..%ZT(..%SysTime(),3)
	.s LogStr="< "_UserName_" "_ChangeDate_"  "_ChangeTime_" >"_LogStr_$c(13)
	.s SLUpdateDate=..%SysDate()
	.s SLUpdateTime=..%SysTime()
	.&sql(insert into SQLUser.DHC_PAAdmSheetsLog(SL_Sheet_ParRef,SL_Log,SI_AddUser_Dr,SI_AddDate,SI_AddTime) 
	      values(:SheetRowid,:LogStr,:User,:SLUpdateDate,:SLUpdateTime))
	i (SQLCODE) s SQLCODE=-100
	q SQLCODE
}

ClassMethod CheckFreqDisTime(OrderFreqRowid) As %String
{
	; w ##class(web.DHCPAAdmSheets).CheckFreqDisTime(26)
	q:OrderFreqRowid="" 0
	q:$p($g(^PHCFR(OrderFreqRowid,"DHC")),"^",1)=1 0
	s DisTimeFlag=0
	s DTChildSub=0
	f  s DTChildSub=$o(^PHCFR(OrderFreqRowid,"DT",DTChildSub)) q:(DTChildSub="")||(DisTimeFlag=1)  d 
	.s DisTimeFlag=1
	q:DisTimeFlag=1 1
	s OPDTChildSub=0
	f  s OPDTChildSub=$o(^PHCFR(OrderFreqRowid,"OPDT",OPDTChildSub)) q:(OPDTChildSub="")||(DisTimeFlag=1)  d 
	.s DisTimeFlag=1
	q DisTimeFlag
}

ClassMethod CheckStartDate(StartDate) As %String
{
	; w ##class(web.DHCPAAdmSheets).CheckExecDate("")
	;测试执行日期是否超过了30天
	s StartDate=$zdh(StartDate,4)
	q:StartDate>(30+$h) 0
	q 1
}

ClassMethod ConvertDateFormat(DateStr As %String, Mode As %String) As %String
{
	s ^tempscl("ttt")=DateStr_","_Mode
	; d ##class(web.DHCPAAdmSheets).ConvertDateFormat("","")	
	s ret=""
	if Mode=0 {
		for i=1:1:$l(DateStr,$C(2)) {
			s DateNum=$P(DateStr,$C(2),i)
			i ret="" s ret=$ZD(DateNum,3)
			e  s ret=ret_","_$ZD(DateNum,3)
		}
	}
	if Mode=1 {
		for i=1:1:$l(DateStr,",") {
			s Date=$P(DateStr,",",i)
			i ret="" s ret=$ZDH(Date,3)
			e  s ret=ret_$C(2)_$ZDH(Date,3)
		}
	}
	if Mode=3 {
		for i=1:1:$l(DateStr,",") {
			s Date=$P(DateStr,",",i)
			i ret="" s ret=$ZDH(Date,3)
			e  s ret=ret_$C(2)_$ZDH(Date,3)
		}
	}
	if Mode=4 {
		for i=1:1:$l(DateStr,$C(2)) {
			s DateNum=$P(DateStr,$C(2),i)
			i ret="" s ret=$ZD(DateNum,4)
			e  s ret=ret_","_$ZD(DateNum,4)
		}
	}
	Q ret
}

ClassMethod DHCPAAdmSheetsQureyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCPAAdmSheetsQureyExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DHCPAAdmSheetsQureyExecute(ByRef qHandle As %Binary, PapmiNo As %String = "", StartDate As %String = "", EndDate As %String = "") As %Status
{
	; d ##class(%ResultSet).RunQuery("web.DHCPAAdmSheets","DHCPAAdmSheetsQurey","00000042","","")
	s repid=$I(^CacheTemp)
 i $g(ind)="" s ind=1
 i PapmiNo=""  {s qHandle=$lb(0,repid,0) q $$$OK} 
 s PapmiNo=$ZCVT(PapmiNo,"U")
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	i PapmiDr=""  {s qHandle=$lb(0,repid,0) q $$$OK} 
	s PaadmType=""
	f  s PaadmType=$o(^PAPERdr(PapmiDr,"ADM",PaadmType)) q:PaadmType=""  d
	.s PaadmDr="" 
	.f  s PaadmDr=$o(^PAPERdr(PapmiDr,"ADM",PaadmType,PaadmDr)) q:PaadmDr=""  d
	..s SheetDr=""
	..f  s SheetDr=$o(^DHCPAADMS("0","PAADM",PaadmDr,SheetDr)) q:SheetDr=""   d
	...s SheetDate=$p(^DHCPAADMS(SheetDr),"^",4)
	...q:SheetDate<61241
	...q:(SheetDate<StartDate)&(StartDate'="")
	...q:(SheetDate>EndDate)&(EndDate'="")
	...s SheetStatus=$p(^DHCPAADMS(SheetDr),"^",11)
	...s SheetTime=$p(^DHCPAADMS(SheetDr),"^",5)
	...s SheetType=$p(^DHCPAADMS(SheetDr),"^",2)
	...s SheetNo=$p(^DHCPAADMS(SheetDr),"^",3)
	...s SheetUserDr=$p(^DHCPAADMS(SheetDr),"^",6)
	...s SheetDepDr=$p(^DHCPAADMS(SheetDr),"^",7)
	...s SheetStopDate=$p(^DHCPAADMS(SheetDr),"^",12)
	...s SheetStopTime=$p(^DHCPAADMS(SheetDr),"^",13)
	...s SheetStopUserDr=$p(^DHCPAADMS(SheetDr),"^",14)
	...s SheetStopUserDesc=""
	...i (SheetStopUserDr'="") s SheetStopUserDesc=$p($g(^SSU("SSUSR",SheetStopUserDr)),"^",2)
	...s SheetDate=$zd(SheetDate,3)
	...s SheetTime=..%ZT(SheetTime,3)
	...i SheetStopDate'="" s SheetStopDate=$zd(SheetStopDate,3)
	...i SheetStopTime'="" s SheetStopTime=..%ZT(SheetStopTime,3)
	...s SheetUserDesc=""
	...s SheetDepDesc=""
	...i SheetUserDr'=""  s SheetUserDesc=$p($g(^SSU("SSUSR",SheetUserDr)),"^",2)
	...i SheetDepDr'="" s SheetDepDesc=$p(^CTLOC(SheetDepDr),"^",2)
	...s SheetStatusDesc=$Case(SheetStatus,"":"未生成处方","S":"停止","P":"生成处方","C":"未生成处方",:"状态错误")
	...s SheetInfrom=SheetType_"^"_SheetNo_"^"_SheetDate_"^"_SheetTime
	...s SheetInfrom=SheetInfrom_"^"_SheetUserDesc_"^"_SheetDepDesc_"^"_SheetDr
	...s SheetInfrom=SheetInfrom_"^"_SheetStatusDesc_"^"_SheetStopDate_"^"_SheetStopTime_"^"_SheetStopUserDesc
	...s ^CacheTemp(repid,ind)=$LB(SheetInfrom)
	...s ind=ind+1
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod DHCPAAdmSheetsQureyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCPAAdmSheetsQureyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" 
 {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      
 {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary, SheetRowId As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 ;
 do ResetVariables5
 if SheetRowId'=""{

 }
 i ind=1 d
 . do ResetVariables5
 . set Data=$lb(SheetGroup)
 . Do OutputRow5	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow5
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables5
 set (SheetGroup)=""
 Quit
}

ClassMethod FindGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupExecute ]
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

ClassMethod GetCurrentSheet(AdmRowId As %Library.String) As %String
{
	; d ##class(web.DHCPAAdmSheets).GetCurrentSheet(175653)
	s PatientID=$P(^PAADM(AdmRowId),"^",1)
	s CurrentSheetId=""
	s AdmRowId=0  f  s AdmRowId=$O(^PAPERdr(PatientID,"ADM","O",AdmRowId)) Q:AdmRowId=""  d
	.s SheetRowId=0  f  s SheetRowId=$O(^DHCPAADMS(0,"PAADM",AdmRowId,SheetRowId)) Q:SheetRowId=""  d
	..s PAADMSEndDate=$p($g(^DHCPAADMS(SheetRowId)),"^",9)
	..q:(PAADMSEndDate<+$h)
	..s SheetStatus=$p($g(^DHCPAADMS(SheetRowId)),"^",11)
	..q:'((SheetStatus="")!(SheetStatus="P")!(SheetStatus="C")) 
	..s CurrentSheetId=SheetRowId
	q CurrentSheetId
}

ClassMethod GetCurrentSheetBak(AdmRowId As %Library.String) As %String
{
	; d ##class(web.DHCPAAdmSheets).GetCurrentSheet(175653)
	s CurrentSheetId=""
	s SheetRowId=$O(^DHCPAADMS(0,"PAADM",AdmRowId,""),-1)
	i (SheetRowId'="") d
	.s SheetStatus=$p($g(^DHCPAADMS(SheetRowId)),"^",11)
	.i ((SheetStatus="")!(SheetStatus="P")) s CurrentSheetId=SheetRowId
	q CurrentSheetId
}

ClassMethod GetDefaultBillType(EpisodeID As %String, ArcimRowId As %String) As %String
{
	; d ##class(web.DHCPAAdmSheets).GetDefaultBillType(176057,"6495||1")    176057  175985
	 s value="",Desc=""
	 s n=0
	 Set rset=##class(%ResultSet).%New("web.DHCPAAdmSheets:LookUpBillType")
	 do rset.Execute(EpisodeID,ArcimRowId)
	 While (rset.Next()) {
		s n=n+1
		i n=1 {
			s Desc=rset.GetData(2)
			s value=rset.GetData(1)
		}
	 }
	 d rset.Close()

	 q value_"^"_Desc_"^"_n
}

ClassMethod GetDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", SheetRowIdRowid As %Library.String) As %String
{
 ; d ##class(web.DHCPAAdmSheets).GetDetailBroker("","",1176) 
	k CacheTemp("SheetDetail",$j)
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s SheetStatus=$p(^DHCPAADMS(SheetRowIdRowid),"^",11)
	s child=0 f  s child=$O(^DHCPAADMS(SheetRowIdRowid,"I",child)) Q:child=""  d  
	.s GroupNo=$P($g(^DHCPAADMS(SheetRowIdRowid,"I",child)),"^",2)
	.q:GroupNo=""
	.s GroupItemNo=$P($g(^DHCPAADMS(SheetRowIdRowid,"I",child)),"^",3)
	.q:GroupItemNo=""
	.s OrderItemRowId=$P($g(^DHCPAADMS(SheetRowIdRowid,"I",child)),"^",1)
	.q:OrderItemRowId=""
	.q:'$d(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2)))
	.s OeoriStatus=$p($g(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),1)),"^",13)
	.;q:(OeoriStatus=4)&&(SheetStatus'="S")
	.s SubGroupRemark=$P($g(^DHCPAADMS(SheetRowIdRowid,"I",child)),"^",4)
	.s SheetItemRowid=SheetRowIdRowid_"||"_child
	.s CacheTemp("SheetDetail",$j,GroupNo,GroupItemNo)=OrderItemRowId_"^"_SubGroupRemark_"^"_SheetItemRowid

	s GroupNo=0  f  s GroupNo=$O(CacheTemp("SheetDetail",$j,GroupNo)) Q:GroupNo=""  d  
	.s GroupStr=""
	.s GroupItemNo=0  f  s GroupItemNo=$O(CacheTemp("SheetDetail",$j,GroupNo,GroupItemNo)) q:GroupItemNo=""  d 
	..s SubGroupStr=""
	..s OrderItemRowId=$p($g(CacheTemp("SheetDetail",$j,GroupNo,GroupItemNo)),"^",1)
	..s OrderRowid=$P(OrderItemRowId,"||",1)
	..s ChildSub=$P(OrderItemRowId,"||",2)
	..i ((OrderRowid="")!(ChildSub=""))  b
	..q:((OrderRowid="")!(ChildSub=""))
	..s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)		;OEORI_ItmMast_DR
	..s ARCIMSubScript=$p(ARCIMRowid,"||",1)
	..s ARCIMSubVersion=$p(ARCIMRowid,"||",2)
	..s OrderName=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)     
	..s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)  ;ARCIM_ItemCat_DR  
	..s OrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)    
	..s OrderDoseQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)	;OEORI_DoseQty
	..s OrderDoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)	;OEORI_Unit_DR
	..s OrderDoseUOM=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2)				;剂量单位
	..s OrderFreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)		;OEORI_PHFreq_DR
	..s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)
	..s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2) ;
	..s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5) ;
	..s OrderInstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)		;OEORI_Instr_DR
	..s OrderInstr=$p($g(^PHCIN(OrderInstrRowid)),"^",2)  
	..;s OrderPrice=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",25)			;OEORI_Price
	..s OrderPrice=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",13)			;OEORI_Price
	..;s OrderPrice=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,"ITP",1)),"^",4)
	..s OrderPrice=$fn(OrderPrice,"",4)
	..s OrderDepProcNote=$g(^OEORD(OrderRowid,"I",ChildSub,"DEP",1))			;OEORI_DepProcNotes
	..s OrderPackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)		;OEORI_QtyPackUOM
	..//s OrderPackUOMRowid=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,8)),"^",14)     ;ARCIM_BillingUOM_DR
	..s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderRowid_"||"_ChildSub)
	..s OrderPackUOM=$p($g(^CT("UOM",OrderPackUOMRowid)),"^",2) ;包装单位
	..s OrderBillTypeRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",18) ;OEORI_BBExtCode
	..i OrderBillTypeRowid=""  s OrderBillType=""
	..e  s OrderBillType=$p($g(^PAC("ADMREA",OrderBillTypeRowid)),"^",2)			;REA_Desc 
	..s OrderItemBilledCode=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",5) 		;OEORI_Billed    
	..s OrderItemBilled=$Case(OrderItemBilledCode,"P":"已结算","I":"已停止","TB":"未结算","B":"未结算","R":"红冲",:"未定义")
	..s OrderMsg=$G(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"OEM",1)) 
	..s OrderSttDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)	;OEORI_SttDat
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, OrderSttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s OrderPrice=$P(retPrice,"^",1) 
	..s OrderSum=OrderPackQty*OrderPrice
	..s OrderPrice=$fn(OrderPrice,"",3)
	..s OrderSum=$fn(OrderSum,"",2) 
	..;s OrderSum=$fn(OrderPrice*OrderPackQty,"",2)
	..s RecDepDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",6)
	..i RecDepDR="" s OrderRecDep=""
	..e  s OrderRecDep=$p($g(^CTLOC(RecDepDR)),"^",2)
	..s OrderPrescNo=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",14)
	..s SubGroupStr=OrderName_"^"_OrderDoseQty_"^"_OrderDoseUOM_"^"_OrderFreq_"^"_OrderInstr
	..s SubGroupStr=SubGroupStr_"^"_OrderPrice_"^"_OrderDepProcNote_"^"_OrderPackQty_"^"_OrderPackUOM
	..s SubGroupStr=SubGroupStr_"^"_OrderBillType_"^"_OrderMsg_"^"_OrderSum_"^"_OrderRecDep
	..s OrderItemRowid=OrderItemRowId
	..s OrderPriorRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8) ;OEORI_Priority_DR  //
	..s OrderARCIMRowid=ARCIMRowid ;   //
	..//s OrderType="" ;
	..s OrderRecDepRowid=RecDepDR ;  //
	..s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	..s OrderConFac=##class(web.DHCDocOrderEntry).GetConFac(ARCIMRowid,INCIRowid)
	..s OrderPoisonCode=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
	..s OrderMaxQty=##Class(web.DHCDocOrderEntry).GetARCIMMaxQty(ARCIMRowid)
	..s OrderBaseQtySum="" ;
	..s OrderBaseQty=""
	..s OrderPHPrescType=""
	..s OrderPHForm="" ;
	..s OrderDrugFormRowid=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",12)  ;
	..s OrderAlertStockQty="" ;
	..s OrderHiddenPara=""
	..s SheetItemRowid=$p($g(CacheTemp("SheetDetail",$j,GroupNo,GroupItemNo)),"^",3)
	..s SheetRowid=+SheetItemRowid
	..s ItemSub=$p(SheetItemRowid,"||",2)
	..s SheetItemStatusCode=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",5)
	..s SheetItemStatus=SheetItemStatusCode
	..s OrderItemStopDate=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",6)	
	..s OrderItemAddDate=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",9)
	..i OrderItemStopDate'="" s OrderItemStopDate=$zd(OrderItemStopDate,4)
	..i OrderItemAddDate'="" s OrderItemAddDate=$zd(OrderItemAddDate,4)
	..s VenousFillingFlag=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",13)
	..s SolventFlag=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",14)
	..s SIGroupStatus=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",15)
	..s SubGroupStr=SubGroupStr_"^"_OrderItemRowid_"^"_OrderPriorRowid_"^"_OrderARCIMRowid_"^"_OrderType
	..s SubGroupStr=SubGroupStr_"^"_OrderDoseUOMRowid_"^"_OrderInstrRowid_"^"_OrderFreqRowid
	..s SubGroupStr=SubGroupStr_"^"_OrderFreqFactor_"^"_OrderFreqInterval_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid
	..s SubGroupStr=SubGroupStr_"^"_OrderPackUOMRowid_"^"_OrderConFac_"^"_OrderBaseQtySum_"^"_OrderBaseQty
	..s SubGroupStr=SubGroupStr_"^"_OrderPHPrescType_"^"_OrderPHForm_"^"_OrderDrugFormRowid_"^"_OrderMaxQty
	..s SubGroupStr=SubGroupStr_"^"_OrderAlertStockQty_"^"_OrderPoisonCode_"^"_OrderHiddenPara_"^"_SheetItemRowid_"^"_OrderPrescNo
	..s SubGroupStr=SubGroupStr_"^"_SheetItemStatus_"^"_OrderItemStopDate_"^"_OrderItemAddDate_"^"_OrderItemBilled
	..s SubGroupStr=SubGroupStr_"^"_VenousFillingFlag_"^"_SolventFlag_"^"_SIGroupStatus
	..i GroupStr=""  s GroupStr=SubGroupStr
	..e  s GroupStr=GroupStr_$c(1)_SubGroupStr
	.s GroupRemark=$p(^DHCPAADMS(SheetRowIdRowid),"^",10)					;化疗单备注
	.s LogStr=""
	.s LogChildsub=0
	.f  s LogChildsub=$o(^DHCPAADMS(SheetRowIdRowid,"L",LogChildsub)) q:LogChildsub=""  d
	..s SubLogStr=$p($g(^DHCPAADMS(SheetRowIdRowid,"L",LogChildsub)),"^",1)
	..i (SubLogStr'="")  d
	...i LogStr="" s LogStr=SubLogStr
	...e  s LogStr=LogStr_"     "_SubLogStr
	.s GroupItemNo=$o(CacheTemp("SheetDetail",$j,GroupNo,0))
	.s SubGroupRemark=$p($g(CacheTemp("SheetDetail",$j,GroupNo,GroupItemNo)),"^",2)
	.s ExecuteDateStr=$p($g(^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),"DHC")),"^",1)
	.i ExecuteDateStr=""  d
	..s ^OEORD(+OrderItemRowId,"I",$p(OrderItemRowId,"||",2),"DHC")=..%SysDate() 
	..s ExecuteDateStr=..%SysDate()
	.s DateStrTemp=""
	.f i=1:1:$l(ExecuteDateStr,$c(2))  d 
	..i DateStrTemp=""  s DateStrTemp=$zd($p(ExecuteDateStr,$c(2),i),3)
	..e  s DateStrTemp=DateStrTemp_","_$zd($p(ExecuteDateStr,$c(2),i),3)
	.s ExecuteDateStr=DateStrTemp
	.s GroupStr=GroupStr_$c(3)_GroupRemark_$c(3)_ExecuteDateStr_$c(3)_SubGroupRemark_$c(3)_LogStr
	.s retval=itmjs_"('"_$ZCVT(GroupStr,"O","JS")_"');"
	.&javascript<#(retval)#>
}

ClassMethod GetHLDFlag(OrderItemRowid As %String) As %String
{
	 q $d(^DHCPAADMS("OEORI",OrderItemRowid))
}

ClassMethod GetMaxNo(PatientID As %Library.String) As %String
{
	s MaxNo=0
	s AdmRowId=0  f  s AdmRowId=$O(^PAPERdr(PatientID,"ADM","O",AdmRowId)) Q:AdmRowId=""  d
	.s SheetRowId=0  f  s SheetRowId=$O(^DHCPAADMS(0,"PAADM",AdmRowId,SheetRowId)) Q:SheetRowId=""  d
	..s No=$P(^DHCPAADMS(SheetRowId),"^",3)
	..i No>MaxNo s MaxNo=No
	Q (MaxNo+1)
}

ClassMethod GetPatientInfo(SheetId As %Library.String) As %String
{
	s PrintTime=$ZDATETIME($HOROLOG,3)
	s AdmRowId=$p($g(^DHCPAADMS(SheetId)),"^",1)
	s Papmi=$p(^PAADM(AdmRowId),"^",1)
	s info=##Class(web.DHCDocOrderEntry).GetPatientByRowid(Papmi)
	s Medicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(Papmi,"",$g(%session.Data("LOGON.HOSPID")))
	s Name3=$p(^PAPER(Papmi,"ALL"),"^",19)
	s FirstSheetItem=$o(^DHCPAADMS(SheetId,"I",0))
	s itemrowid=$p($g(^DHCPAADMS(SheetId,"I",FirstSheetItem)),"^",1)
	s OEORDRowId=$p(itemrowid,"||",1) s OEORIChildsub=$p(itemrowid,"||",2)
	s OrdDept=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",3)
	s DoctorRowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",11)
	s CTLOCName=$p($p(^CTLOC(OrdDept),"^",2),"-",2)
	s DoctorDesc=$p(^CTPCP(DoctorRowid,1),"^",2)
	s info=info_"^"_PrintTime_"^"_Medicare_"^"_Name3_"^"_CTLOCName_"^"_DoctorDesc
	q info
}

ClassMethod Insert(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String) As %Status
{
	;w ##class(web.DHCPAAdmSheets).Insert("","","","","")
	/*
	s ^DHCXPTest("ChangeSheets","OrdItemStr")=OrdItemStr
	s ^DHCXPTest("OrderItemInsert","Adm")=Adm
	s ^DHCXPTest("OrderItemInsert","OrdItemStr")=OrdItemStr
	s ^DHCXPTest("OrderItemInsert","User")=User
	s ^DHCXPTest("OrderItemInsert","Loc")=Loc
	s ^DHCXPTest("OrderItemInsert","Doc")=Doc
	
	s Adm=176200
	s OrdItemStr="6182||1^R^5^^^15^0.46^187^9^94||1^^400^66^1200^20^1^21^1^1^5^N^^N^^^^^^61203^N^^^1||5^Y"
	s OrdItemStr="6182||1^R^5^^^15^0.46^187^9^94||1^^400^66^1200^20^1^21^1^1^5^N^^N^^^^^^61203^N^^^1||5^Y"
	"6173||1^R^5^^^1^100.4^187^9^85||1^^125^63^125^15^1^5^1^^3^N^^N^^^^^^61208^N^^^2||3^Y"_$C(1)_"6596||1^R^5^^^1^125.63^187^9^508||1^^4^63^4^15^1^5^1^1^4^N^^N^^^^^^61208^N^^^2||4^Y"
	s User=1312
	s Loc=5
	s Doc=2699
	*/
	
	
	;i Adm="" s Adm=^zhou("Adm")
	;i User="" s User=^zhou("User")
	;i Doc="" s Doc=^zhou("Doc")
	;i Loc="" s Loc=^zhou("Loc")
	;i OrdItemStr="" s OrdItemStr=^zhou("order")
	;;i LABDATA="" s LABDATA="LABDATA"
	;s ^zhou("Adm")=Adm
	;s ^zhou("order")=OrdItemStr
	;s ^zhou("User")=User
	;s ^zhou("Loc")=Loc
	;s ^zhou("Doc")=Doc
	Quit:$g(OrdItemStr)="" 0
	Quit:$g(Adm)="" 0
	Set admloc=$p(^PAADM(Adm),"^",4)
	s EpLoc=admloc
	s admType=$P($g(^PAADM(Adm)),"^",2)
	if admType="I" s EpLoc=$P($g(^PAADM(Adm)),"^",70)
	;是否直接审核,是否采用新的打包方式
	Set NewOrderUpdate=..%GetConfig("NewOrderUpdate")
	Set NewDispensing=..%GetConfig("NewDispensing")
	;
	Set ord=##class(web.DHCaOET).GetOrder(Adm)
	Quit:ord="" 0
	k ^CacheTemp("DHCCDocInsertItem",$J,ord)
	s RowidStr=""
	;
	;Set Err=$$LOCK^SSLOCK("OE_Order",ord,User,$g(Machine))
	;
	;insert into OE_OrdEnt  zhaocz
	k PLIST
	;s PLIST(3)=""
	;s err=$$insert^MVBOEENT(ord)
	;s entrid=%ROWID
	s entrid=""
	Set OrdItemCount=$L(OrdItemStr,$c(1))
	For i=1:1:OrdItemCount	Do
	.Set OrdItem=$p(OrdItemStr,$c(1),i)
	.Quit:OrdItem=""
	.Set ARCIMRowid=$p(OrdItem,"^",1)
	.Quit:ARCIMRowid=""
	.Set OrderType=$p(OrdItem,"^",2)	
	.Set MasterSeqNo=$p(OrdItem,"^",19)
	.Set OrderSeqNo=$p(OrdItem,"^",20)
	.s VenousFillingFlag=$p(OrdItem,"^",36)
	.s SolventFlag=$p(OrdItem,"^",37)
	.i MasterSeqNo="" d
	..Set ^CacheTemp("DHCCDocInsertItem",$J,ord,OrderSeqNo)=OrdItem
	..Set ^CacheTemp("DHCCDocInsertItem",$J,ord,OrderSeqNo,"VenousFilling")=VenousFillingFlag_"^"_SolventFlag
	.e  d
	..if '$d(^CacheTemp("DHCCDocInsertItem",$J,ord,MasterSeqNo)) d
	...Set ^CacheTemp("DHCCDocInsertItem",$J,ord,MasterSeqNo)=""
	..Set ^CacheTemp("DHCCDocInsertItem",$J,ord,MasterSeqNo,"sub",OrderSeqNo)=OrdItem
	s seq=0 f  s seq=$o(^CacheTemp("DHCCDocInsertItem",$J,ord,seq)) q:seq=""  d
	.s OrdItem=^CacheTemp("DHCCDocInsertItem",$J,ord,seq)
	.Q:OrdItem=""
	.;用当前日期好像也没什么问题
	.;Set SttDate=$p(OrdItem,"^",4)
	.;Set SttDate=$zdh(SttDate)
	.Set SttDate=..%SysDate()
	.Set SeqNo=$$GetSeqNo(ord,SttDate)
	.Set $p(OrdItem,"^",20)=SeqNo
	.Do SetPLIST
	.Set ExecuteDateStr=$p(OrdItem,"^",29)
	.if NewOrderUpdate="1" Set udf="Y^^"_ExecuteDateStr
	.else  Set udf="Y^W^"_ExecuteDateStr
	.s err=$$insert(ord,udf)
	.Quit:err
	.Set oeitm=%ROWID
	.;s err=##Class(web.DHCOEDispensing).Insert(oeitm)
	.d ##class(web.DHCaOET).GenExe(oeitm)
	.i RowidStr="" s RowidStr=ARCIMRowid_"*"_oeitm_"*"_"V"
	.e  s RowidStr=RowidStr_"^"_ARCIMRowid_"*"_oeitm_"*"_"V"
	.s ^CacheTemp("InsSheets","InsOrderItem",oeitm)=$g(^CacheTemp("DHCCDocInsertItem",$J,ord,seq,"VenousFilling"))
	.;
	.Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",18)=AdmReason
	.Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",55)=NotifyClinician
	.;
	.Set specimen=$p(OrdItem,"^",28)
	.Set Convolumn="",Container=""
	.;If (OrderType="L")&($g(specimen)'="") s err=$$SetLabSpecimen^DHCOrdItem(%ROWID,specimen,Container,Convolumn)
	.Set LinkOrderItem=oeitm
	.Set SeqNoid=0
	.s sub=0 f  s sub=$o(^CacheTemp("DHCCDocInsertItem",$J,ord,seq,"sub",sub)) q:sub=""  d
	..Set OrdItem=^CacheTemp("DHCCDocInsertItem",$J,ord,seq,"sub",sub)
	..Set ARCIMRowid=$p(OrdItem,"^",1)
	..;生成序列号
	..Set SeqNoid=SeqNoid+1
	..Set SubSeqNo=SeqNo_"."_SeqNoid
	..Set $p(OrdItem,"^",20)=SubSeqNo
	..;
	..Do SetPLIST
	..Set ExecuteDateStr=$p(OrdItem,"^",29)
	..if NewOrderUpdate="1" Set udf="Y^^"_ExecuteDateStr
	..else  Set udf="Y^W^"_ExecuteDateStr
	..Set err=$$insert(ord,udf)
	..Quit:err
	..;
	..Set oeitm=%ROWID
	..;s err=##Class(web.DHCOEDispensing).Insert(oeitm)
	..d ##class(web.DHCaOET).GenExe(oeitm)
	..;
	..Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",18)=AdmReason
	..Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",39)=LinkOrderItem
	..Set $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),11),"^",55)=NotifyClinician
	..if LinkOrderItem'="" Set ^OEORDi(0,"OEORI",+oeitm,LinkOrderItem,$p(oeitm,"||",2))=""
	..Set specimen=$p(OrdItem,"^",28)
	..Set Convolumn="",Container=""
	..;If (OrderType="L")&($g(specimen)'="") s err=$$SetLabSpecimen^DHCOrdItem(%ROWID,specimen,Container,Convolumn)
	..i RowidStr="" s RowidStr=ARCIMRowid_"*"_oeitm_"*"_"V"
	..e  s RowidStr=RowidStr_"^"_ARCIMRowid_"*"_oeitm_"*"_"V"

	;Set err=$$LOCKCLR^SSLOCK("OE_Order",ord)
	k ^CacheTemp("DHCCDocInsertItem",$J,ord)
	Quit:RowidStr="" 0 
	Quit RowidStr_"^"
	;
insert(par,udf)        ;
	 ;call UDF for validation
	 s udf=$g(udf)
	 s udf1=$p(udf,"^"),udf2=$p(udf,"^",2),ExecuteDateStr=$p(udf,"^",3)
	 s udf=udf1
	 s PLIST(0)=par
	 ;adjust unit cost
	 i '$g(PLIST(46)) s PLIST(46)=""
	 s par=$g(par) 
	 ;n rowid,itemcat,calc,calcfl,phartype
	 k PLIST(1),PLIST(2) s PLIST(0)=par
	 k PLIST(81),PLIST(84),PLIST(90),PLIST(76),PLIST(135)
	 s calcfl=##class(web.DHCaOET).calcfl($g(PLIST(4)))
	 s phartype=##class(web.DHCaOET).phartype($g(PLIST(4)))
	 i calcfl["Y",phartype'["X" s:'$g(PLIST(85)) PLIST(85)=1 s PLIST(29)=$$CO29^at122($g(PLIST(85)),$g(PLIST(25)),$g(PLIST(35)),$g(PLIST(23)),$g(PLIST(17)),$g(PLIST(159))) ;k PLIST(29)
	 i calcfl["Y",phartype["X" s PLIST(29)=##class(web.DHCaOET).CO29(1,$g(PLIST(112)),$g(PLIST(113)),$g(PLIST(23)))
	 i calcfl'["Y" s PLIST(29)=+$g(PLIST(29)) s:'PLIST(29) PLIST(29)=1
	 s PLIST(76)=##class(web.DHCaOET).DEF76($g(PLIST(0)),$g(PLIST(4)))
	 s:PLIST(76)="Ignore" PLIST(76)="I"
	 s:PLIST(76)="To Bill" PLIST(76)="TB"
	 ;if discontinued order then ignore 
	 i $p($g(^OEC("OSTAT",+$g(PLIST(10)))),"^")="D" s PLIST(76)="I"
	 i $p($g(^OEC("OSTAT",+$g(PLIST(10)))),"^")="DI" s PLIST(76)="I"
	 ;if executed  order then "TB"
	 i $p($g(^OEC("OSTAT",+$g(PLIST(10)))),"^")="E" s PLIST(76)="TB"
	 ;if priority PRN then Ignore
	 i ##class(web.DHCaOET).admtype(par)["I",$p($g(^OECPR(+$g(PLIST(23)))),"^")="PRN" s PLIST(76)="I"
	 i $g(PLIST(111))="" s PLIST(111)="A"
	 ;if result status N, status should be executed
	 i PLIST(111)="N" s PLIST(10)=$o(^OEC("OSTAT",0,"Code","E",""))
	 ;default value for field 54-insur billing conditions
	 ;s:'$g(PLIST(54)) PLIST(54)=$$def1^MVBARCIS(+$g(^OEORD(+par)),$g(PLIST(4)),$g(PLIST(17)))
	 ;get default operation category
	 s PLIST(64)=##class(web.DHCaOET).opercat($g(PLIST(4)))
	 i '$g(PLIST(161)) s PLIST(161)=##class(web.DHCaOET).admloc(par)
	 ; piece 77 is the sequence number, sometimes in the vb stuff
	 ; this gets set to a string value e.g. 08 which then fails
	 ; validation. This next line ensures this doesn't happen.
	 ;s PLIST(77)=+$g(PLIST(77))
	 i $g(PLIST(77))="" s PLIST(77)=0
	 ;fix some number fields
	 ;
	 ; they sometimes put in some strange data into these fields
	 ; so they should be converted to numeric, but only if they
	 ; exist otherwise it always puts a zero in the database for
	 ; every order which is wrong
	 i $g(PLIST(59))'="" s PLIST(59)=+PLIST(59)
	 i $g(PLIST(74))'="" s PLIST(74)=+PLIST(74)
	 ;
	 ;s $ZT="ERROR^SSERR" 
	 Ts
	 &SQL(Insert Into SQLUser.OE_OrdItem Values PLIST())
	 TC
	 //b ;insert
	 s SQLflag=SQLCODE
	 i 'SQLflag {
	 	s rowid=%ROWID 
		;***********add by zhouzq *********
	 	i ExecuteDateStr'="" s $p(^OEORD(+rowid,"I",$p(rowid,"||",2),"DHC"),"^",1)=ExecuteDateStr
	 	;**********************************
	 }
	 q SQLCODE
SetPLIST
	;OrderARCIMRowid+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderStartTime+"^"+OrderRecDepRowid
	;OrderPackQty+"^"+OrderPrice+"^"+BillTypeRowid+"^"+OrderDrugFormRowid+"^"+OrderDepProcNotes;
	;OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderQtySum+"^"+OrderFreqRowid+"^"+OrderDurRowid+"^"+OrderInstrRowid;
	;PHPrescType+"^"+OrderMasterSeqNo+"^"+OrderSkinTest;
	Set ARCIMRowid=$p(OrdItem,"^",1)
	Set OrderType=$p(OrdItem,"^",2)	
	Set PriorRowid=$p(OrdItem,"^",3)
	If PriorRowid="" Set PriorRowid=$o(^OECPR(0))
	Set startdate=$p(OrdItem,"^",4)
	if startdate="" s SttDate=..%SysDate()
	e  Set SttDate=$zdh(startdate,4)
	Set starttime=$p(OrdItem,"^",5)
	if starttime="" s SttTime=..%SysTime()
	e  Set SttTime=..%ZTH(starttime)
	Set PackQty=$p(OrdItem,"^",6)
	Set oeprice=$p(OrdItem,"^",7)
	Set RecDepRowid=$p(OrdItem,"^",8)
	Set AdmReason=$p(OrdItem,"^",9)
	Set DrugFormRowid=$p(OrdItem,"^",10)
	Set DepProcNotes=$p(OrdItem,"^",11)
	Set DoseQty=$p(OrdItem,"^",12)
	Set DoseUOMRowid=$p(OrdItem,"^",13)
	Set DoseQtySum=$p(OrdItem,"^",14)
	Set FreqRowid=$p(OrdItem,"^",15)
	if FreqRowid'="" {
		s WeekFlag=$P($g(^PHCFR(+$g(FreqRowid),"DHC")),"^",1)
		if WeekFlag=1 {
			Set CurrWeek=$ZD(SttDate,10)
			If CurrWeek=0 Set CurrWeek=7
			Set nextweek="",minweek="",inter=0
			Set childsub=0  f  s childsub=$O(^PHCFR(FreqRowid,"OPDT",childsub)) Q:childsub=""  d
			.Set time=$p(^PHCFR(FreqRowid,"OPDT",childsub),"^",1)
			.Set week=$p(^PHCFR(FreqRowid,"OPDT",childsub),"^",2)
			.if minweek="" s minweek=week
			.else  if minweek>week Set minweek=week 
			.Q:week<=CurrWeek
			.i nextweek="" s nextweek=week
			.e  i nextweek>week s nextweek=week
			if nextweek="" s nextweek=minweek
			if nextweek>CurrWeek Set inter=nextweek-CurrWeek
			if nextweek<=CurrWeek Set inter=(7-CurrWeek)+nextweek
			s SttDate=SttDate+inter	
		}
	}

	Set DurRowid=$p(OrdItem,"^",16)
	Set InstrRowid=$p(OrdItem,"^",17)
	Set PHPrescType=$p(OrdItem,"^",18)
	Set MasterSeqNo=$p(OrdItem,"^",19)
	Set OrderSeqNo=$p(OrdItem,"^",20)
	Set SkinTest=$p(OrdItem,"^",21)
	Set PhSpecInstr=$p(OrdItem,"^",22)
	Set OrderCoverMainIns=$p(OrdItem,"^",23)
	Set ActionRowid=$p(OrdItem,"^",24)
	Set ARCOSRowid=$p(OrdItem,"^",25)
	Set EndDate=$p(OrdItem,"^",26)
	Set EndTime=$p(OrdItem,"^",27)
	Set ExecuteDateStr=$p(OrdItem,"^",29)
	Set NotifyClinician=$p(OrdItem,"^",30)
	i EndDate'="" s EndDate=$zdh(EndDate,4)
	i EndTime'="" s EndTime=..%ZTH(EndTime)
	;Set specimen=$p(OrdItem,"^",5)
	;i OrderType="L" Set StatusRowid=$o(^OEC("OSTAT",0,"Code","I",""))  ;未激活
	;e  Set StatusRowid=$o(^OEC("OSTAT",0,"Code","V",""))  ;激活
	;
	set StatusRowid=$o(^OEC("OSTAT",0,"Code","I",""))  ;未激活
	If StatusRowid="" Set StatusRowid=$o(^OEC("OSTAT",0))
	;ResultFlag="N",则不会再走Insert^MVBOEIT0的打包程序 d reserve^aOET1(...
	;如果ResultFlag="N" 则代表医嘱插入时状态会变为"E"执行
	;if NewDispensing="1" s ResultFlag="N" e  s ResultFlag=""
	if Doc="" Set Doc=$p(^SSU("SSUSR",User),"^",9)
	;if OrderType'="R" s DoseQtySum=PackQty
	KILL PLIST
	set PLIST(3)=entrid			         ;OEORI_OrdEnt_DR
	Set PLIST(4)=ARCIMRowid
	Set PLIST(6)=admloc		 	         ;OEORI_OrdDept_DR
	Set PLIST(10)=StatusRowid	         ;OEORI_ItemStat_DR
	Set PLIST(14)=Doc   		         ;OEORI_Doctor_DR
	Set PLIST(17)=SttDate		         ;SttDate
	Set PLIST(18)=SttTime   	         ;SttTime
	Set PLIST(23)=PriorRowid	         ;OEC_Priority
	Set PLIST(25)=FreqRowid
	Set PLIST(27)=InstrRowid
	Set PLIST(28)=DoseUOMRowid
	Set PLIST(29)=$number(DoseQtySum)	 ;PhyQtyOrd	
	Set PLIST(35)=DurRowid	
	;Set Price=$$GetOrderPrice^DHCPRICE("","",arcim,+$H,"","","",oeprice)
	;Set PLIST(46)=$p(OrderPrice,"^",1)
	Set PLIST(43)=PhSpecInstr
	Set PLIST(46)=$number(oeprice) 
	;Set PLIST(52)=MasterSeqNo           ;LinkToOrder
	Set PLIST(53)=$lb(DepProcNotes)      
	Set PLIST(55)=OrderCoverMainIns		 ;CoverMainIns
	Set PLIST(56)="N"			         ;Portable Equviment
	Set PLIST(63)="P"                    ;WhoGoWhere:Patient To Doctor
	Set PLIST(57)=SkinTest		         ;SkinTest
	Set PLIST(75)=RecDepRowid
	;Set SeqNo=$o(^OEORDi(0,"StDtSeqNo",ord,+$H,""),-1)
	;Set SeqNo=+SeqNo+1
	Set PLIST(77)=OrderSeqNo
	Set PLIST(82)=""                     ;NoOrdersLink
	Set PLIST(85)=DoseQty                ;DoseQty
	Set PLIST(86)=ARCOSRowid             ;ARCOS
	Set PLIST(87)=""                     ;LinkNo
	Set PLIST(120)=$g(User)	 	         ;User Add
	;Set PLIST(111)=ResultFlag
	Set PLIST(121)=$g(Loc) 	 	         ;User Dept
	Set PLIST(141)=$g(User)	             ;User Update
	Set PLIST(161)=EpLoc		         ;OEORI_AdmLoc_Dr
	Set PLIST(139)=entrid
	Set PLIST(154)=$number(PackQty)		 ;PackingUom Qty
	Set PLIST(159)=EndDate		         ;End Date
	Set PLIST(160)=EndTime		         ;End Time
	Set PLIST(192)=..%SysDate()		             ;Update Date
	Set PLIST(193)=..%SysTime()          ;Update Time
	Set PLIST(209)=ActionRowid           ;Action
	if ActionRowid'="" d
	.set ActionCode=$P(^OEC("ACT",ActionRowid),"^",1)
	.if ActionCode="MS" Set PLIST(57)="N"
	.if ActionCode="YY" Set PLIST(57)="Y"
	if (OrderType="P"){
		Set PLIST(45)=""    			 ;OEORI_BillDesc
		Set PLIST(79)=oeprice			 ;OEORI_Price
		Set PLIST(46)=oeprice*PackQty	 ;OEORI_UnitCost
		Set PLIST(151)=""
		Set PLIST(154)=""
	}
	Quit
GetOELabSpecimen(Par)
	;n (Par)
	Quit:$g(Par)="" ""
	Set OERid=+Par
	Set OESubrid=$P(Par,"||",2)
	Set OESpecRid=$O(^OEORD(OERid,"I",OESubrid,"SPEC",0))
	Q:OESpecRid="" "" 
	Set specimen=""
	Set specimen=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",1)
	Set Container=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",11)
	Set Convolumn=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",12)	
	Quit specimen
GetSeqNo(ord,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",ord,sttdate," "),-1)
 i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

ClassMethod InsertAdmSheets(Adm As %String, GroupStr As %String, User As %String, Loc As %String, Doc As %String) As %String [ ProcedureBlock = 0 ]
{
	;Set $ZT="ERROR^DHCSSERR"
	; d ##class(web.DHCPAAdmSheets).InsertAdmSheets("","","","","")	
	Ts
	k ^CacheTemp("InsSheets","InsOrderItem")
	s SheetStr=$P(GroupStr,$c(4),1)
	s Cycle=$P(SheetStr,"^",1)
	s StartDate=$P(SheetStr,"^",2)
	s EndDate=$P(SheetStr,"^",3)
	s SheetRemark=$P(SheetStr,"^",4)
	i StartDate'="" s StartDate=$ZDH(StartDate,4)
	e  s StartDate=..%SysDate()
	i EndDate'="" s EndDate=$ZDH(EndDate,4)
	e  s EndDate=..%SysDate()
	
	Set object = ##class(User.DHCPAAdmSheets).%New()
	Do object.PAADMSAdmDrSetObjectId(Adm)
	set object.PAADMSType="HLD"
	set object.PAADMSDate=..%SysDate()
	set object.PAADMSTime=..%SysTime()
	Do object.PAADMSUserDrSetObjectId(User)
	Do object.PAADMSDepDrSetObjectId(Loc)
	set object.PAADMSNo=Cycle
	set object.PAADMSStartDate=StartDate
	set object.PAADMSEndDate=EndDate
	set object.PAADMSRemark=SheetRemark
	s sc= object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit -100
	}
	s ASRowId=object.%Id()
	d object.%Close()
	
	set err=0
	Set OrdItemCount=$L(GroupStr,$c(4))
	For i=2:1:OrdItemCount	{
		s GroupInfo=$P(GroupStr,$c(4),i)
		s GroupRemark=$P($P(GroupInfo,$c(3),1),"^",1)
		s OrdItemStr=$P(GroupInfo,$c(3),2)
		Set Ret=..Insert(Adm,OrdItemStr,User,Loc,Doc)
		if (Ret=0)!(Ret=100) {
			s err=-100
			Break
		}
		f k=1:1:$l(Ret,"^")-1 {
			s newOrdIdDR=$p($p(Ret,"^",k),"*",2)
			Q:newOrdIdDR=""
			s VenousFillingFlag=$p($g(^CacheTemp("InsSheets","InsOrderItem",newOrdIdDR)),"^",1)
			s SolventFlag=$p($g(^CacheTemp("InsSheets","InsOrderItem",newOrdIdDR)),"^",2)
			Set object=##class(User.DHCPAAdmSheetsItem).%New(ASRowId)
			Do object.SISheetParRefSetObjectId(ASRowId)
			Do object.SIOEORIDRSetObjectId(newOrdIdDR)
			set object.SIGroupNo=i-1
			set object.SIGroupItemNo=k
			set object.SIGroupRemark=GroupRemark
			set object.SIVenousFillingFlag=VenousFillingFlag
			set object.SISolventFlag=SolventFlag
			s sc=object.%Save()
			If $$$ISERR(sc) {
				s err=-100
				break
			}
			d object.%Close()
		}
		if err=-100 break
	}
	s SYDRet=##class(web.DHCSYD).InsertHLD(Adm)
	i (SYDRet'=0) s err=-100
	if err=-100 {
		tro
		Q err
	}
	k ^CacheTemp("InsSheets","InsOrderItem")
	TC
	Q ASRowId
}

ClassMethod LookUpBillTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpBillTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpBillTypeExecute(ByRef qHandle As %Binary, EpisodeID As %String, ArcimRowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPAAdmSheets","LookUpBillType","175783","1197||1")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	s ItemCat=$P($g(^ARCIM(+ArcimRowId,$p(ArcimRowId,"||",2),1)),"^",10 )
	s OrderType=$P(^ARC("IC",ItemCat),"^",7)
	s PAADMInsType=$P(^PAADM(EpisodeID,1),"^",7)
	i EpisodeType="I" s InsType=PAADMInsType
	s IsADMInsTypeDCArcim=0
	s PAADMDiagnosCat=##class(web.DHCDocOrderCommon).GetBillTypeDiagnosCat(EpisodeType,PAADMInsType)
	i (PAADMDiagnosCat'="") {
		 s TempStr=##class(web.DHCDocOrderCommon).GetDiagnosCatArcim(PAADMDiagnosCat,ArcimRowId)
		 i TempStr'="" s IsADMInsTypeDCArcim="1"
	}
	if (EpisodeID'="") {
		 s PrescTypeDetailDelim="!"
		 s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM("O",PAADMInsType)
		 s PrescriptTypesCount=$l(PrescriptTypes,"||")
		 s prescparameter=""
		 s firstprescparameter=""
		 f i=1:1:PrescriptTypesCount {
		 	s PrescriptTypeTemp=$p(PrescriptTypes,"||",i)
		 	s presctypebilltypeid=$p(PrescriptTypeTemp,PrescTypeDetailDelim,5)
		 	s presctypecode=$p(PrescriptTypeTemp,PrescTypeDetailDelim,2)
		 	s presctypedesc=$p(PrescriptTypeTemp,PrescTypeDetailDelim,3)
		 	s presctypeitemcat=$p(PrescriptTypeTemp,PrescTypeDetailDelim,4)
		 	s presctypedefault=$p(PrescriptTypeTemp,PrescTypeDetailDelim,8)
		 	s BillTypeNationalCode=$P(^PAC("ADMREA",presctypebilltypeid),"^",5)
		 	if OrderType'="R" {
				S Data=$lb(presctypebilltypeid,presctypedesc)
				d OutputRow6
		 	}else{
			 	i (("^"_presctypeitemcat_"^")[("^"_ItemCat_"^")){ 
				 	;Q:("^"_presctypeitemcat_"^")'[("^"_ItemCat_"^")
				 	if BillTypeNationalCode'="Private" {
				 		if (IsADMInsTypeDCArcim=1)&&(PAADMInsType'=presctypebilltypeid) continue
					 	//if PAADMDiagnosCat=0 {
							s BillTypeDiagnosCat=##class(web.DHCDocOrderCommon).GetBillTypeDiagnosCat(EpisodeType,presctypebilltypeid)
							i BillTypeDiagnosCat'="" {
								s TempStr=##class(web.DHCDocOrderCommon).GetDiagnosCatArcim(BillTypeDiagnosCat,ArcimRowId)
								i TempStr="" continue
							}
					 	//}
				 	}
					;S Data=$lb(presctypedesc,presctypebilltypeid)
					S Data=$lb(presctypebilltypeid,presctypedesc)
					d OutputRow6
			 	}
		 	}
		 }
		 
	}
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRow6
 Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 quit
}

ClassMethod LookUpBillTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpBillTypeExecute ]
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

ClassMethod RefreshOEORI(NewOrderRowid As %String, OldOeoriRowid As %String) As %String
{
	
	// 复制原来的医嘱项,新增医嘱项,删除原来的医嘱项
	; d ##class(web.DHCPAAdmSheets).RefreshOEORI("176361","176303||11")
	; d ##class(web.DHCPAAdmSheets).presno("","","")
	TS
	q:'$d(^OEORD(NewOrderRowid)) -1
	q:'$d(^OEORD(+OldOeoriRowid,"I",+$p(OldOeoriRowid,"||",2))) -2
	s ObjOld=##class(User.OEOrdItem).%OpenId(OldOeoriRowid)
	s ObjNew=##class(User.OEOrdItem).%New(NewOrderRowid)
	s ObjNew=ObjOld.%ConstructClone()
	s NewChildSub=$o(^OEORD(NewOrderRowid,"I",""),-1)+1
	d ObjNew.OEORIOEORDParRefSetObjectId(NewOrderRowid)
	s ObjNew.OEORIChildsub=NewChildSub
	s ObjNew.OEORISttDat=..%SysDate()
	s ObjNew.OEORISttTim=..%SysTime()
	s NewOeoriRowid=NewOrderRowid_"||"_NewChildSub
	s sc=ObjNew.%Save() 
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		q 100
	}
	&sql(update SQLUser.DHC_PAAdmSheetsItem set SI_OEORI_DR=:NewOeoriRowid where SI_OEORI_DR=:OldOeoriRowid)
	if (SQLCODE) {
		Trollback
		q 100
	}
	s ExecuteDateStr=$p($g(^OEORD(+OldOeoriRowid,"I",$p(OldOeoriRowid,"||",2),"DHC")),"^",1)
	s $p(^OEORD(+NewOeoriRowid,"I",$p(NewOeoriRowid,"||",2),"DHC"),"^",1)=ExecuteDateStr
	&sql(delete from SQLUser.OE_OrdItem where OEORI_Rowid=:OldOeoriRowid)
	if (SQLCODE) {
		Trollback
		q 100
	}
	d ObjNew.%Close()
	d ObjOld.%Close()
	TC
	q NewOrderRowid_"||"_NewChildSub
}

ClassMethod SaveAdmSheets(SheetRowid As %String, CurrentAdmDr As %String, GroupStr As %String, User As %String, Loc As %String, Doc As %String) As %String [ ProcedureBlock = 0 ]
{
 ; 生成处方前,修改化疗单
	Ts
	s ASRowId=SheetRowid
	s SheetStr=$P(GroupStr,$c(4),1)
	s Cycle=$P(SheetStr,"^",1)
	s StartDate=$P(SheetStr,"^",2)
	s EndDate=$P(SheetStr,"^",3)
	s SheetRemark=$P(SheetStr,"^",4)	
	i StartDate'="" s StartDate=$ZDH(StartDate,4)
	e  s StartDate=..%SysDate()
	i EndDate'="" s EndDate=$ZDH(EndDate,4)
	e  s EndDate=..%SysDate()
	
	&sql(update SQLUser.DHC_PAAdmSheets set PAADMS_Remark=:SheetRemark,PAADMS_No=:Cycle,
			 PAADMS_StartDate=:StartDate,PAADMS_EndDate=:EndDate 
	     where PAADMS_RowId=:SheetRowid)

	i SQLCODE'=0 TRollback
	
	s Child=0 f  s Child=$o(^DHCPAADMS(SheetRowid,"I",Child)) q:Child=""  d  
	.s OrderItemRowId=$p($g(^DHCPAADMS(SheetRowid,"I",Child)),"^",1)
	.&sql(delete from SQLUser.OE_OrdItem where OEORI_Rowid=:OrderItemRowId)
	.i SQLCODE'=0 TRollback
	
	&sql(delete from SQLUser.DHC_PaadmSheetsItem where SI_Sheet_ParRef=:SheetRowid)
	i SQLCODE'=0 TRollback
		
	//s Adm=$p($g(^DHCPAADMS(SheetRowid)),"^",1)
	s Adm=CurrentAdmDr
	set err=0
	Set OrdItemCount=$L(GroupStr,$c(4))
	For i=2:1:OrdItemCount	{
		s GroupInfo=$P(GroupStr,$c(4),i)
		s GroupRemark=$P($P(GroupInfo,$c(3),1),"^",1)
		s OrdItemStr=$P(GroupInfo,$c(3),2)
		Set Ret=..Insert(Adm,OrdItemStr,User,Loc,Doc)
		if (Ret=0)!(Ret=100) {
			s err=-100
			Break
		}
		f k=1:1:$l(Ret,"^")-1 {
			s newOrdIdDR=$p($p(Ret,"^",k),"*",2)
			Q:newOrdIdDR=""
			Set object=##class(User.DHCPAAdmSheetsItem).%New(ASRowId)
			Do object.SISheetParRefSetObjectId(ASRowId)
			Do object.SIOEORIDRSetObjectId(newOrdIdDR)
			set object.SIGroupNo=i-1
			set object.SIGroupItemNo=k
			set object.SIGroupRemark=GroupRemark
			s sc=object.%Save()
			If $$$ISERR(sc) {
				s err=-100
				break
			}
			d object.%Close()
		}
		if err=-100 break
	}
	if err=-100 {
		tro
		Q err
	}
	TC
	Q 0
}

ClassMethod StopOrdItem(OrdItmRowId As %String, UserRowId As %String) As %String
{
	; d ##class(web.DHCPAAdmSheets).StopOrdItem("176199||3",1312)
	s SheetRowid=$o(^DHCPAADMS("OEORI",OrdItmRowId,""))
	s ItemSub=$o(^DHCPAADMS("OEORI",OrdItmRowId,SheetRowid,""))
	i (SheetRowid'="")&&(ItemSub'="") d
	.s SheetItemStatus=$p($g(^DHCPAADMS(SheetRowid,"I",ItemSub)),"^",5)
	q:SheetItemStatus="S" 0
	q:SheetItemStatus="R" 0
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	i SheetItemStatus="A" s SheetItemStatus="R"
	e  s SheetItemStatus="S"
	&SQL(update SQLUser.DHC_PaadmSheetsItem set SI_Status=:SheetItemStatus,SI_StopDate=:CurrDate,
	            SI_StopTime=:CurrTime,SI_StopUser_Dr=:UserRowId
	     where SI_OEORI_DR=:OrdItmRowId)
	q:(SQLCODE'=0) SQLCODE 
	
	s BillFlag=$p($g(^OEORD(+OrdItmRowId,"I",+$p(OrdItmRowId,"||",2),3)),"^",5)
	q:'(" B TB "[(" "_BillFlag_" ")) 0
	s BillFlag="I"
	s StatusRowId=$O(^OEC("OSTAT",0,"Code","D",0))
	&SQL(Select SSUSR_CareProv_DR into :DoctorRowId from SQLUser.SS_User where SSUSR_RowId=:UserRowId )
	TS
	s err=##class(web.DHCOEOrdItem).UpdateStatus(OrdItmRowId,UserRowId,StatusRowId)
	if err Q SQLCODE
	
	if DoctorRowId="" { 
		&SQL(Update SQLUser.OE_OrdItem set OEORI_Xdate=:CurrDate,OEORI_Xtime=:CurrTime,OEORI_Billed=:BillFlag where OEORI_rowid=:OrdItmRowId)
	}else{
		&SQL(Update SQLUser.OE_OrdItem set OEORI_Xdate=:CurrDate,OEORI_Xtime=:CurrTime,OEORI_XCTCP_DR=:DoctorRowId,OEORI_Billed=:BillFlag where OEORI_rowid=:OrdItmRowId)
	}
	if SQLCODE TRo  Q SQLCODE
	
	d ##class(web.DHCOEDispensing).Return(OrdItmRowId)
	if SQLCODE TRo  Q SQLCODE
	
	TC
	Q 0
}

ClassMethod StopSYDItem(OrderItemRowId As %String, UserRowId As %String) As %String
{
	; 停止医嘱后,更新输液单的医嘱状态等医嘱信息
	; w ##class(web.DHCPAAdmSheets).StopSYDItem("179920||3","1312")
	s SYDRowid=$o(^DHCSYD("OEORD",OrderItemRowId,0))
	q:SYDRowid="" 0
	q:'$d(^DHCSYD(SYDRowid)) 102
	s StopDate=..%SysDate()
	s StopTime=..%SysTime()
	&sql(update SQLUser.DHC_SYD set DHCSYD_Status='Stop',DHCSYD_StopUser=:UserRowId,
		DHCSYD_StopDate=:StopDate,DHCSYD_StopTime=:StopTime where DHCSYD_Rowid=:SYDRowid
	)
	q 0
}

ClassMethod presno(sheet As %String, CurrentAdmDr As %String, PrescOrditemStr As %String) As %String
{
	;Also setup Lab episode No if LabOrder
	;  d ##class(web.DHCPAAdmSheets).presno("","","")
	/*
	s ^DHCXPTest("presno","sheet")=sheet  
	s ^DHCXPTest("presno","CurrentAdmDr")=CurrentAdmDr
	s ^DHCXPTest("presno","PrescOrditemStr")=PrescOrditemStr
	  
	s sheet=1225
	s CurrentAdmDr=176425
	s PrescOrditemStr="176321||7^176379||3"
	//q 0
	*/
	
	q:$g(sheet)="" 0
	;s adm=$P(^DHCPAADMS(sheet),"^",1)
	s adm=CurrentAdmDr
	s admtype=$p($g(^PAADM(+adm)),"^",2)
	;************生成处方前,用新插入的医嘱,代替以前就诊的医嘱**********************
	/*
	s Err=0
	s NewOrderRowid=$o(^OEORD(0,"Adm",CurrentAdmDr,""))
	s TempStr=""
	f ItemIndex=1:1:$l(PrescOrditemStr,"^")  q:(Err=-100)  d
	.s OrderItemRowid=$p(PrescOrditemStr,"^",ItemIndex)
	.s OrderAdmRowid=$p(^OEORD(+OrderItemRowid),"^",1)
	.i (OrderAdmRowid'=CurrentAdmDr)  d
	..;s NewOrderItem=..RefreshOEORI(NewOrderRowid,OrderItemRowid)	
	..i NewOrderItem'["||" s Err=-100  q
	.e  s NewOrderItem=OrderItemRowid
	.i TempStr="" s TempStr=NewOrderItem
	.e  s TempStr=TempStr_"^"_NewOrderItem
	q:(Err=-100) -100
	s PrescOrditemStr=TempStr	
	*/
	;************生成处方前,用新插入的医嘱,代替以前就诊的医嘱**********************
	k ^TMP("MVB",$j)
	s par=$o(^OEORD(0,"Adm",+adm,0))
	q:'par 0
	l +^DBLock($zn,adm):1 e  q
	;
	s que1count=0
	Set StatusRowid=$o(^OEC("OSTAT",0,"Code","V",""))
	;n que1,que,queres,que2
	S PrescByInstr=..%GetConfig("PrescByInstr")
	 ;s OEITM=0 f  s OEITM=$o(^OEORD(+par,"I",OEITM)) q:OEITM=""  d
	s child=0 f  s child=$O(^DHCPAADMS(sheet,"I",child)) Q:child=""  d  
	.s OrderItemRowId=$P(^DHCPAADMS(sheet,"I",child),"^",1)
	.s row=OrderItemRowId
	.Q:(PrescOrditemStr'="")&&(("^"_PrescOrditemStr_"^")'[("^"_OrderItemRowId_"^"))
	.;s row=+par_"||"_OEITM
	.d getdata
	.s speccode=##class(web.DHCaOET).GetOELabSpecimen(row)
	.q:labepis'=""
	.q:presc'=""  
	.q:prseq'=""   
	.q:" DS DIS E V I "'[(" "_$g(status)_" ")
	.s prior=##class(web.DHCaOET).prior(row)
	.q:(prior="REV")||(prior="OM")
	.s labflag=$p($g(labflag),$c(1))
	.;ignore executed non-lab items,not any more
	.;i $e(labflag)'="L",$g(status)="E" q
	.;ignore non-pahramacy, non-lab items
	.i $e(labflag)'="L",'##class(web.DHCaOET).stock(arcim) q
	.i 'locord s locord=##class(web.DHCaOET).ordloc(adm)
	.;
	.s PHPrescTypeCount=5
	.s PHPrescType=##class(web.DHCaOET).GetPHPrescTypeByArcim(row)
	.s BillTypeRowid=$p($G(^OEORD(+row,"I",$p(row,"||",2),11)),"^",18)
	.s InstrGroupCode=""
	.i PrescByInstr=1 s InstrGroupCode=##class(web.DHCaOET).GetInstrGroupCode(instr)
	.;
	.s seq1="1/1",loc=recloc  ;s loc=$s(recloc:+recloc,1:+$$recloc(arcim,locord)) ;s:'loc loc=+locord
	.s key=+loc_"^"_(+sttdat)_##class(web.DHCaOET).auth(arcim)_"*"_PHPrescType_BillTypeRowid_InstrGroupCode
	.i prior="STAT" s STAT(key)=""
	.q:'loc  s epis=labepis
	.;add by zhou
	.s prno1="",epis1=""
	.i loc,$e(labflag)'="L" d
	..;i '$d(que1(key)) s prno=$s(1:##class(web.DHCaOET).PRNO1(+sttdat,adm,loc),$p($g(^CTLOC(loc)),"^",13)="D":##class(web.DHCaOET).PRNO(+sttdat),1:"")
	..;i '$d(que1(key)) s que1(key)=prno_"^"_$g(locord)
	..s key=$$newque3(key,PHPrescTypeCount)
	..i $d(que1(key)) s prno1=$p(que1(key),"^")
	.i loc,$e(labflag)="L",epis="" d
	..s keylab=loc_"^"_(+sttdat)_"^"_speccode
	..i '$d(que2(keylab)) s que2(keylab)=##class(web.DHCaOET).EPIS()
	..i $d(que2(keylab)) s epis=que2(keylab)
	..s epis1=epis
	.;i loc,'$d(queres(+loc)),resexe["F" s queres(+loc)=prno_"^"_$g(locord)_"^"_epis
	.i epis1'="" d
	..&SQL(Update SQLUser.OE_OrdItem 
		set OEORI_PrescNo=:prno1,OEORI_PrescSeqNo=:seq1,OEORI_RecDep_DR=:loc,
			OEORI_OrdDept_DR=:locord,OEORI_LabEpisodeNo=:epis1
		Where OEORI_RowId=:row)
	.i epis1="" d
	..&SQL(Update SQLUser.OE_OrdItem 
		set OEORI_PrescNo=:prno1,OEORI_PrescSeqNo=:seq1,OEORI_RecDep_DR=:loc,
			OEORI_OrdDept_DR=:locord,OEORI_ItemStat_DR=:StatusRowid
		Where OEORI_RowId=:row)
	..if status="I" d
	...s err=##Class(web.DHCOEDispensing).Insert(row)
	...;d ##class(web.DHCaOET).GenExe(row)
	...s drgform=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",12)
	...s doseqty=$p($g(^OEORD(+row,"I",+$p(row,"||",2),2)),"^",1)
	...s uom=$p($g(^OEORD(+row,"I",+$p(row,"||",2),2)),"^",3)
	...s dispqty=##class(web.DHCaOET).calcqty1(drgform,uom,doseqty,row)
	...d ##class(web.DHCOEDispensing).reserve(row,dispqty)
	..;i labepis'="",epis'=labepis s epis1=""
	.;add by zhouzq
	.i seq2 s sum=$g(^TMP("MVB",$j,+loc))+1
	.i  s ^TMP("MVB",$j,+loc)=sum
	.i  s ^TMP("MVB",$j,+loc,+(seq2\1),row)=sum
	;
	;;&SQL(CLOSE CurOEIT1)
	;
	;
	s loc="" f  s loc=$o(^TMP("MVB",$j,loc)) q:loc=""  s tot=$g(^TMP("MVB",$j,loc)),ss="" f  s ss=$o(^TMP("MVB",$j,loc,ss)) q:ss=""  s row="" f  s row=$o(^TMP("MVB",$j,loc,ss,row)) q:row=""  s s=^(row) d
	.s seq1=s_"/"_tot
	.&SQL(Update SQLUser.OE_OrdItem set OEORI_PrescSeqNo=:seq1 Where OEORI_RowId=:row)
	;
	;In(L)sert Pharmacy Queue, now only for Dispensing/Injection Location
	;for outpatients check order entry configuration if they need to pay
	;if not insert queue with status "paid"
	s loc="" f  s loc=$o(que1(loc)) q:loc=""  s prno=$p(que1(loc),"^"),locord=$p(que1(loc),"^",2) d
	.i prno'="",##class(web.DHCaOET).exist(prno,adm) d newstat(prno) q
	.q:'loc  k que s que(3)=+loc,que(5)=$s("IE"[admtype:"P",##Class(web.DHCaOET).pay()["P":"T",1:"P"),que(6)=prno,que(2)=+adm,que(16)=$g(doc) ;,que(18)=$g(locord)
	.i $d(STAT(loc)) s que(19)="STAT"
	.;Only for dispensing/injection location
	.q:" D DI "'[(" "_$p($g(^CTLOC(+loc)),"^",13)_" ")
	.&SQL(Insert Into SQLUser.PA_Que1 Values que() )
	.;check queue status and update if some of orders were packed
	.i prno'="",$g(que(5))["P" d newstat(prno)
	k ^TMP("MVB",$j)
	
	l -^DBLock($zn,adm)
	
	&SQL(Update SQLUser.DHC_PAAdmSheets set PAADMS_Status='P' Where PAADMS_RowId=:sheet)	
	b ;updatestatus
	s adm=+adm
	s type=$p($g(^PAADM(adm)),"^",2) ;i $$pay^at122d()["P" q:"IE"'[type 
	s order=$o(^OEORD(0,"Adm",+adm,""))
	;Check all que entry with status "Paid",accept prescription
	;check order entry configuration
	;inpatient/emergency
	i "IE"[type,$$iaccept()'["Y" d  q 0
	;outpatient
	i "HO"[type,$$oaccept()'["Y" d  q 0	
	s que="" f  s que=$o(^PAQUE1(0,"QUE1_PAADM_DR",adm,que)) q:que=""  d
	.; Check here against a status of P for PAID. This is because we 
	.; only want to perform this code the first time, and in patient
	.; prescriptions are inserted with a status of Paid.
	.q:'$d(^PAQUE1(que))  
	.s s=^(que),stat=$p(s,"^",13) 
	.q:stat'["P"
	.s recloc=$p(s,"^",4),presno=$p(s,"^",14)
	.d ##class(web.DHCaOET).updque(que,stat)
	q 0
	;
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
	..b ;find
	..s presccount=presccount+1
	..s que1(nod)=$P(que1(nod),"^",1,2)_"^"_presccount
	..s findnod=nod
	
	i findnod="" {
	b ;new
	 s que1count=que1count+1
	 s findnod=key_"^"_que1count
	 s prno=$s(1:##class(web.DHCaOET).PRNO1(+sttdat,adm,loc),$p($g(^CTLOC(loc)),"^",13)="D":##class(web.DHCaOET).PRNO(+sttdat),1:"")
	 s que1(findnod)=prno_"^"_$g(locord)_"^"_"1"
	}
	
	Q findnod
newstat(prno) ;check status of queue
	 ;n (prno)
	 s err=##class(web.DHCaOET).updqueue(prno)
	 q
iaccept() ;check order entry configuration: 
	 ;automatic accept inpatient prescription 
	 q $p($g(^CF("OE",1)),"^",22)
 ;
oaccept() ;check order entry configuration: 
	 ;automatic accept outpatient prescription 
	 q $p($g(^CF("OE",1)),"^",23)
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
	 OEORI_SttDat
	 INTO :row,:arcim,:form,:dose,:dur,:instr,:presc,:locord,:recloc,:prseq,:doc,:freq,:status,:seq2,:labflag,:labepis,:resexe,:sttdat
	 FROM SQLUser.OE_OrdItem
	 WHERE OEORI_RowId = :row)
	 q

 ;
}

Query DHCPAAdmSheetsQurey(PapmiNo As %String = "", StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "SheetInfrom:%String")
{
}

/// 查找预约记录
Query FindGroup(SheetRowId As %String) As %Query(ROWSPEC = "SheetGroup:%String")
{
}

Query LookUpBillType(EpisodeID As %String, ArcimRowId As %String) As %Query(CONTAINID = 1, ROWSPEC = "hidden:%String,ReasonDesc:%String")
{
}

}
