Class ABN.dao.DHCNurPatchTestSub Extends %RegisteredObject
{

Query Find(skinTestRecRowid) As websys.Query(ROWSPEC = "Rowid:%String:RowId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,Hor48:%String:48HR,Hor72:%String:72HR,OtherHor:%String:其它间隔,OtherRec:%String:其它结果,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,isExecOrder:%String:是否执行")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		 
		k ^||TempPatchRecSub
		s tab = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
		s sub=""
		f  s sub=$o(^ABN.DHCNurPatchTestD(skinTestRecRowid,"ChildSub",sub))   q:sub=""  s item=^(sub)    d
		.s subObj = ##class(ABN.DHCNurPatchTestSub).%OpenId(skinTestRecRowid_"||"_sub)
		.q:subObj.OrderStatus()'="V"
		.s orditm=$list(item,3)		
		.s arcosdr = $p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",10)
		.s arcim=$list(item,9)
		.s ItmMastDesc = $p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
		.s Hor48=$list(item,4)
		.s Hor72=$list(item,5)
		.;s:Hor48="" Hor48="-"
		.;s:Hor72="" Hor72="-"
		.s OtherHor=$list(item,6)
		.s OtherRec=$list(item,7)
		.s Memo=$list(item,8)
        .s billed=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s Testable=1
        .s orderParref=+orditm
		.s orderId=$p(orditm,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
		.s isExecOrder = subObj.IsExec()
		.s isExecOrder=$s((isExecOrder=1):"已执行",1:"未执行")
        .s ^||TempPatchRecSub(arcosdr,arcim,$I(^||TempPatchRecSub(arcosdr,arcim)))=$lb(skinTestRecRowid_"||"_sub,orditm,arcim,tab_ItmMastDesc,1,Hor48,Hor72,OtherHor,OtherRec,Memo,isPaid,isPaidDesc,isExecOrder)
		
		;循环--变态反应科的过敏源套
		s arcosdr=0 f  s arcosdr=$o(^DHCCTACARCOSi(0,"ARCOS",arcosdr)) q:arcosdr=""  d
		.q:$d(^||TempPatchRecSub(arcosdr))'=10			;没有出现在病人医嘱中
		.s arcosdesc = $p(^ARCOS(arcosdr),"^",2)
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0,"","","","","")		;组名	
		.s ARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(arcosdr)
		.s arcossub=$p(ARCOSDateRowid,"||",2)
		.s item=0 f  s item= $o(^ARCOS(arcosdr,"DATE",arcossub,"ITM",item)) q:item=""  s str=^(item)  d
		..s ItmMastdr = $p(str,"^",1)
		..s ItmMastDesc = $p($g(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1)),"^",2)
		..i $G(^||TempPatchRecSub(arcosdr,ItmMastdr))>=1 d
		...s index=0 f  s index=$o(^||TempPatchRecSub(arcosdr,ItmMastdr,index)) q:index=""  d
		....s ind=ind+1
		....s ^CacheTemp(repid,ind)=^||TempPatchRecSub(arcosdr,ItmMastdr,index)	
		..e  d
		...s ind = ind+1
		...s ^CacheTemp(repid,ind) = $lb("","",ItmMastdr,tab_ItmMastDesc,0,"","","","","")				
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

Query FindReport(skinTestRecRowid) As websys.Query(ROWSPEC = "Rowid:%String:RowId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,Hor48:%String:48HR,Hor72:%String:72HR,OtherHor:%String:其它间隔,OtherRec:%String:其它结果,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,no:%String:序号") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurPatchTestSub","FindReport","4255")
ClassMethod FindReportExecute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		 
		k ^||TempPatchRecSub
		s tab = " "
		s sub=""
		f  s sub=$o(^ABN.DHCNurPatchTestD(skinTestRecRowid,"ChildSub",sub))   q:sub=""  s item=^(sub)   d
		.s orditm=$list(item,3)		
		.s arcosdr = $p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",10)
		.s ItmMastdr=$list(item,9)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s Hor48=$list(item,4)
		.s Hor72=$list(item,5)
		.;s:Hor48="" Hor48="-"
		.;s:Hor72="" Hor72="-"
		.s OtherHor=$list(item,6)
		.s OtherRec=$list(item,7)
		.s Memo=$list(item,8)
        .s billed=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s Testable=1
        .s orderParref=+orditm
		.s orderId=$p(orditm,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
        .s ^||TempPatchRecSub(arcosdr,ItmMastdr)=$lb(skinTestRecRowid_"||"_sub,orditm,ItmMastdr,tab_ItmMastDesc,1,Hor48,Hor72,OtherHor,OtherRec,Memo,isPaid,isPaidDesc)
		
		s len = $ll(^||TempPatchRecSub(arcosdr,ItmMastdr))
		s arcosdr=0
		f  s arcosdr=$o(^||TempPatchRecSub(arcosdr)) q:arcosdr=""  d
		.s arcosdesc=$p(^ARCOS(arcosdr),"^",2)
		.s no=1
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0)		;组名	
		.s ItmMastdr=0 
		.f  s ItmMastdr=$o(^||TempPatchRecSub(arcosdr,ItmMastdr)) q:ItmMastdr=""  d
		..s ind=ind+1
		..s ^CacheTemp(repid,ind)=^||TempPatchRecSub(arcosdr,ItmMastdr)
		..s $list(^CacheTemp(repid,ind),len+1)=no
		..s no=no+1
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

Query FindReport2(skinTestRecRowid) As websys.Query(ROWSPEC = "Rowid:%String:RowId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,Hor48:%String:48HR,Hor72:%String:72HR,OtherHor:%String:其它间隔,OtherRec:%String:其它结果,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,no:%String:序号,Rowid2:%String:RowId,OeordItemId2:%String:医嘱Id,ItmMastDr2:%String:医嘱项Id,ItmMastDesc2:%String:医嘱名,Testable,Hor482:%String:48HR,Hor722:%String:72HR,OtherHor2:%String:其它间隔,OtherRec2:%String:其它结果,Memo2:%String:备注,isPaid2:%String:是否收费,isPaidDesc2:%String:是否收费提示,no2:%String:序号") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurPatchTestSub","FindReport","46")
ClassMethod FindReport2Execute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		 
		k ^||TempPatchRecSub
		s tab = " "
		s pagesize=15	;最多行数的一半加1
		s sub=""
		f  s sub=$o(^ABN.DHCNurPatchTestD(skinTestRecRowid,"ChildSub",sub))   q:sub=""  s item=^(sub)   d
		.s orditm=$list(item,3)		
		.s arcosdr = $p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",10)
		.s ItmMastdr=$list(item,9)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s Hor48=$list(item,4)
		.s Hor72=$list(item,5)
		.s:Hor48="" Hor48="-"
		.s:Hor72="" Hor72="-"
		.s OtherHor=$list(item,6)
		.s OtherRec=$list(item,7)
		.s Memo=$list(item,8)
        .s billed=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s Testable=1
        .s orderParref=+orditm
		.s orderId=$p(orditm,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
        .s ^||TempPatchRecSub(arcosdr,ItmMastdr)=$lb(skinTestRecRowid_"||"_sub,orditm,ItmMastdr,tab_ItmMastDesc,1,Hor48,Hor72,OtherHor,OtherRec,Memo,isPaid,isPaidDesc)
		
		;循环--变态反应科的过敏源套
		s arcosdr=0 f  s arcosdr=$o(^DHCCTACARCOSi(0,"ARCOS",arcosdr)) q:arcosdr=""  d
		.q:$d(^||TempPatchRecSub(arcosdr))'=10
		.s arcosdesc = $e($p(^ARCOS(arcosdr),"^",2),5,)
		.s ind = ind+1
		.s no=1
		.i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1) =^CacheTemp(repid,(ind#pagesize)+1)_$lb("","","",arcosdesc,0,"48hour","72hour","其它(hour)","结果","","","","")
		.i ind\pagesize=0 s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0,"48hour","72hour","其它(hour)","结果","","","","")
		.s ARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(arcosdr)
		.s arcossub=$p(ARCOSDateRowid,"||",2)
		.s item=0 f  s item= $o(^ARCOS(arcosdr,"DATE",arcossub,"ITM",item)) q:item=""  s str=^(item)  d
		..s ItmMastdr = $p(str,"^",1)
		..q:$d(^||TempPatchRecSub(arcosdr,ItmMastdr))=0
		..s index=0 f  s index=$o(^||TempPatchRecSub(arcosdr,ItmMastdr,index)) q:index=""  d
		...s ind=ind+1
		...i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1)=^CacheTemp(repid,(ind#pagesize)+1)_^||TempPatchRecSub(arcosdr,ItmMastdr,index)_$lb(no)		
		...i ind\pagesize=0 s ^CacheTemp(repid,ind)=^||TempSkinTestSub(arcosdr,ItmMastdr,index)_$lb(no)
		...s no=no+1
		
		/*
		s len = $ll(^||TempPatchRecSub(arcosdr,ItmMastdr))
		s arcosdr=0
		f  s arcosdr=$o(^||TempPatchRecSub(arcosdr)) q:arcosdr=""  d
		.s arcosdesc=$p(^ARCOS(arcosdr),"^",2)
		.s no=1
		.s ind = ind+1
		.i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize+1)) =^CacheTemp(repid,ind#pagesize+1)_$lb("","","",arcosdesc,0,"48hour","72hour","其它(hour)","结果","","","","")		
		.i ind\pagesize=0 s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0,"48hour","72hour","其它(hour)","结果","","","","")
		.s ItmMastdr=0 
		.f  s ItmMastdr=$o(^||TempPatchRecSub(arcosdr,ItmMastdr)) q:ItmMastdr=""  d
		..s ind=ind+1
		..i ind\pagesize=1 s ^CacheTemp(repid,ind#pagesize+1)=^CacheTemp(repid,(ind#pagesize+1))_^||TempPatchRecSub(arcosdr,ItmMastdr)_$lb(no)		
		..i ind\pagesize=0 s ^CacheTemp(repid,ind)=^||TempPatchRecSub(arcosdr,ItmMastdr)_$lb(no)
		..s no=no+1
		*/
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

ClassMethod UpDate(UpinfoList, User)
{
    q:UpinfoList="" 0
    s len=$l(UpinfoList,$c(2))
    s ret=0
    f i=1:1:len  q:ret'=0   d
    .s info=$p(UpinfoList,$c(2),i)
    .q:info=""
    .s id=$p(info,"^",1)
    .s rec48=$p(info,"^",2)
    .s rec72=$p(info,"^",3)
    .s otherhr=$p(info,"^",4)
    .s otherrec=$p(info,"^",5)
    .s memo=$p(info,"^",6)
    .s ret=..UpDatePatchRec(id,User,rec48,rec72,otherrec,otherhr,memo)
    
    q ret
}

/// d ##class(ABN.dao.DHCNurPatchTestSub).UpDatePatchRec("3||21",2021,"+","","","","")
ClassMethod UpDatePatchRec(RowId, User, Rec48, Rec72, Recother, OtherHr, Memo)
{
     s ^TMP("UpDatePatchRec")=RowId_","_User_","_Rec48_","_Rec72_","_Recother_","_OtherHr_","_Memo

	q:('$d(^ABN.DHCNurPatchTestD(+RowId,"ChildSub",$p(RowId,"||",2)))) -111
	
	s sub=$p(RowId,"||",2)
	s FirstDate=$list(^ABN.DHCNurPatchTestD(+RowId,"ChildSub",sub),10)
	s FirstTime=$list(^ABN.DHCNurPatchTestD(+RowId,"ChildSub",sub),12)
	s FirUsr=$list(^ABN.DHCNurPatchTestD(+RowId,"ChildSub",sub),14)

	q:((FirstDate'="")&(FirstDate'=+$h))||((FirUsr'="")&&(FirUsr'=User)) -112
	
	i FirstDate=""  s FirstDate=+$h
	i FirstTime=""  s FirstTime=$p($h,",",2)
	i FirUsr=""   s FirUsr=User
	
    s a=##class(ABN.DHCNurPatchTestSub).%OpenId(RowId)
 
    s a.Hours48=Rec48
    s a.Hours72=Rec72
    s a.OtherHours=OtherHr
    s a.OtherResponse=Recother
    s a.Memo=Memo
    s a.FirstDate=FirstDate
    s a.FirstTime=FirstTime
    s a.CheckUser=FirUsr
    s a.UpdDate=+$h
    s a.UpdTime=$p($h,",",2)
    s a.UpdUser=User

    d a.%Save()
    q 0
}

/// 保存斑贴记录
ClassMethod SavePatchSub(TestId, OeordItemID, ArcimId, AcosId)
{
	s TestSubObj = ##class(ABN.DHCNurPatchTestSub).%New(TestId)
	s TestSubObj.OrdRowId = OeordItemID
	s TestSubObj.ArcimID = ArcimId
	d TestSubObj.SkinParefSetObjectId(TestId)
	s TestSubObj.SkinTestGroup = AcosId
	s TestSubObj.Hours48="-"
	s TestSubObj.Hours72="-"
	d TestSubObj.%Save()
	s id = TestSubObj.%Id()	
	d TestSubObj.%Close()
	s TestSubObj=""
	q "0^"_id
}

/// 撤销皮试对应的医嘱
ClassMethod CancelExecOrder(SkinSubID, userId)
{
	s obj = ##class(ABN.DHCNurPatchTestSub).%OpenId(SkinSubID)
	s OrdRowId = obj.OrdRowId
	s rtn = ##class(ABN.dao.DHCDocAllergyInterface).CancelExecGroup(OrdRowId,userId)
	q 0_"^"_SkinSubID
}

}
