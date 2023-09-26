Class ABN.dao.DHCNurSkinTestRecSub Extends %RegisteredObject
{

/// 保存皮肤记录
ClassMethod SaveSkinSub(TestId, OeordItemID, ArcimId, AcosId)
{
	s TestSubObj = ##class(ABN.DHCNurSkinTestRecSub).%New(TestId)
	s TestSubObj.OrdRowId = OeordItemID
	s TestSubObj.ArcimId = ArcimId
	d TestSubObj.SkinParefSetObjectId(TestId)
	s TestSubObj.SkinTestGroup = AcosId
	s TestObj = ##class(ABN.DHCNurSkinTestRec).%OpenId(TestId)
	;有的不用默认值
	i TestObj.IsSkin(),^DHCDocConfig("AllergyCureItem","EditCombo")'["^"_ArcimId_"^"{
		s TestSubObj.MissionWind1="3"	
		s TestSubObj.MissionWind2="3"
		s TestSubObj.Pseudopodia="N"
	}
	i TestObj.IsPrick(){
		s TestSubObj.MissionWind1="0"
		s TestSubObj.MissionWind2="0"
	}
	d TestObj.%Close()
	s TestObj = ""
	d TestSubObj.%Save()
	s id = TestSubObj.%Id()
	d TestSubObj.%Close()
	s TestSubObj=""
	q "0^"_id
}

/// w ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(50,"",194,"ZLDO",3880)
/// 撤销皮试对应的医嘱
ClassMethod CancelExecOrder(SkinSubID, userId)
{
	s obj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(SkinSubID)
	s OrdRowId = obj.OrdRowId
	s rtn = ##class(ABN.dao.DHCDocAllergyInterface).CancelExecGroup(OrdRowId,userId)
	q 0_"^"_SkinSubID
}

Query Find(skinTestRecRowid) As websys.Query(ROWSPEC = "no:%String:行号,ID:%String:SubId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,MissionWind1:%String:风团1,MissionWind2:%String:风团2,Blushes1:%String:红晕1,Blushes2:%String:红晕2,Pseudopodia:%String:伪足,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,isExecOrder:%String:是否执行") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurSkinTestRecSub","Find","1")
/// 不考虑一个病人有多个试验方式
ClassMethod FindExecute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		s ^Temp("ABN.dao.DHCNurSkinTestRecSub","find")=skinTestRecRowid
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		i skinTestRecRowid="" set qHandle = $lb(0,repid,0) q $$$OK
		k ^||TempSkinTestSub
		s tab = "    " ;"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
		s sub=0
		f  s sub=$o(^ABN.DHCNurSkinTestRecD(skinTestRecRowid,"ChildSub",sub)) q:sub=""  s item=^(sub) d
		.s subObj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(skinTestRecRowid_"||"_sub)
		.;q:subObj.OrderStatus()'="V"
		.s ItmMastdr=$list(item,3)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s OeorditemID = $list(item,4)
		.s orderParref=+OeorditemID
		.s orderId=$p(OeorditemID,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
		.s arcosdr = $p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",10)		;OEORI_ARCOS_DR
		.s MissionWind1=$list(item,5)
		.s MissionWind2=$list(item,6)
		.;s:MissionWind1="" MissionWind1=0
		.;s:MissionWind2="" MissionWind2=0
		.s Blushes1=$list(item,7)
		.s Blushes2=$list(item,8)
		.s Pseudopodia=$list(item,9)
		.s Memo=$list(item,10)
		.s billed=$p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s isExecOrder = subObj.IsExec()
		.s isExecOrder=$s((isExecOrder=1):"已执行",1:"未执行")
		.s Testable=1
		.s ^||TempSkinTestSub(arcosdr,ItmMastdr)=$lb(skinTestRecRowid_"||"_sub,OeorditemID,ItmMastdr,tab_ItmMastDesc,Testable,MissionWind1,MissionWind2,Blushes1,Blushes2,Pseudopodia,Memo,isPaid,isPaidDesc,isExecOrder) 
		
		;循环--变态反应科的过敏源套
		s arcosdr=0 f  s arcosdr=$o(^DHCCTACARCOSi(0,"ARCOS",arcosdr)) q:arcosdr=""  d
		.q:$d(^||TempSkinTestSub(arcosdr))'=10			;没有出现在病人医嘱中
		.s arcosdesc = $p(^ARCOS(arcosdr),"^",2)
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb("")_$lb("","","",arcosdesc,0)		;组名	
		.s ARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(arcosdr)
		.s arcossub=$p(ARCOSDateRowid,"||",2)
		.s no=1
		.s item=0 f  s item= $o(^ARCOS(arcosdr,"DATE",arcossub,"ITM",item)) q:item=""  s str=^(item)  d
		..s ItmMastdr = $p(str,"^",1)
		..s ItmMastDesc = $p($g(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1)),"^",2)
		..s ind = ind+1
		..i $d(^||TempSkinTestSub(arcosdr,ItmMastdr))=1 d
		...s ^CacheTemp(repid,ind)=$lb(no)_^||TempSkinTestSub(arcosdr,ItmMastdr)		
		..e  d		
		...s ^CacheTemp(repid,ind) =$lb(no)_$lb("","",ItmMastdr,tab_ItmMastDesc,0)		;组名	
		..s no=no+1
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

Query FindReport(skinTestRecRowid) As websys.Query(ROWSPEC = "ID:%String:SubId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,MissionWind:%String:风团,Blushes:%String:红晕,Pseudopodia:%String:伪足,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,no:%String:序号") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurSkinTestRecSub","FindReport","10")
/// 不考虑一个病人有多个试验方式
ClassMethod FindReportExecute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		i skinTestRecRowid="" set qHandle = $lb(0,repid,0) q $$$OK
		s skinObj = ##class(ABN.DHCNurSkinTestRec).%OpenId(skinTestRecRowid)
		s flag = skinObj.IsSkin()
		d skinObj.%Close()
		s skinObj = ""
		k ^||TempSkinTestSub
		s tab = " "
		s sub=0
		f  s sub=$o(^ABN.DHCNurSkinTestRecD(skinTestRecRowid,"ChildSub",sub)) q:sub=""  s item=^(sub) d
		.s (MissionWind,Blushes,MissTip)=""
		.s subObj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(skinTestRecRowid_"||"_sub)
		.q:subObj.OrderStatus()'="V"
		.s ItmMastdr=$list(item,3)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s OeorditemID = $list(item,4)
		.s orderParref=+OeorditemID
		.s orderId=$p(OeorditemID,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
		.s arcosdr = $p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",10)		;OEORI_ARCOS_DR
		.q:arcosdr=""
		.s MissionWind1=$list(item,5)
		.s MissionWind2=$list(item,6)
		.s MaxMissionWind=$s(MissionWind1>MissionWind2:MissionWind1,1:MissionWind2)
		.s:flag MissTip = "("_$s(MaxMissionWind>=20:"++++",MaxMissionWind>=15:"+++",MaxMissionWind>=10:"++",MaxMissionWind>=5:"+",1:"-")_")"
		.s MissionWind = MissionWind1_"*"_MissionWind2_MissTip
		.s:^DHCDocConfig("AllergyCureItem","EditCombo")[ItmMastdr MissionWind=MissionWind1
		.s:^DHCDocConfig("AllergyCureItem","NoChangeAdd")[ItmMastdr MissionWind = MissionWind1_"*"_MissionWind2
		.s Blushes1=$list(item,7)
		.s Blushes2=$list(item,8)
		.s:Blushes1'="" Blushes=Blushes1_"*"_Blushes2
		.s Pseudopodia=$list(item,9)
		.s Memo=$list(item,10)
		.s billed=$p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s Testable=1
		.s ^||TempSkinTestSub(arcosdr,ItmMastdr)=$lb(skinTestRecRowid_"||"_sub,OeorditemID,ItmMastdr,tab_ItmMastDesc,Testable,MissionWind,Blushes,Pseudopodia,Memo,isPaid,isPaidDesc) 
		
		;s len = $ll(^||TempSkinTestSub(arcosdr,ItmMastdr))
		s arcosdr=0
		f  s arcosdr=$o(^||TempSkinTestSub(arcosdr)) q:arcosdr=""  d
		.s arcosdesc=$p(^ARCOS(arcosdr),"^",2)
		.s no=1
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0)		;组名	
		.s ItmMastdr=0 
		.f  s ItmMastdr=$o(^||TempSkinTestSub(arcosdr,ItmMastdr)) q:ItmMastdr=""  d
		..s ind=ind+1
		..s ^CacheTemp(repid,ind)=^||TempSkinTestSub(arcosdr,ItmMastdr)_$lb(no)
		..s no=no+1
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

Query FindReport2(skinTestRecRowid) As websys.Query(ROWSPEC = "ID:%String:SubId,OeordItemId:%String:医嘱Id,ItmMastDr:%String:医嘱项Id,ItmMastDesc:%String:医嘱名,Testable,MissionWind:%String:风团,Blushes:%String:红晕,Pseudopodia:%String:伪足,Memo:%String:备注,isPaid:%String:是否收费,isPaidDesc:%String:是否收费提示,no:%String:序号,ID2:%String:SubId,OeordItemId2:%String:医嘱Id,ItmMastDr2:%String:医嘱项Id,ItmMastDesc2:%String:医嘱名,Testable2,MissionWind2:%String:风团,Blushes2:%String:红晕,Pseudopodia2:%String:伪足,Memo2:%String:备注,isPaid2:%String:是否收费,isPaidDesc2:%String:是否收费提示,no2:%String:序号") [ SqlProc ]
{
}

/// @params User.DHCDocAllergyCure表rowid
/// d ##class(%ResultSet).RunQuery("ABN.dao.DHCNurSkinTestRecSub","FindReport2","10")
/// 分二列打印 ，runqian报表用到
ClassMethod FindReport2Execute(ByRef qHandle As %Binary, skinTestRecRowid As %String) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		i skinTestRecRowid="" set qHandle = $lb(0,repid,0) q $$$OK
		s ^Temp("wanghc","skinid")=skinTestRecRowid
		s skinObj = ##class(ABN.DHCNurSkinTestRec).%OpenId(skinTestRecRowid)
		s flag = skinObj.IsSkin()
		d skinObj.%Close()
		s skinObj = ""
		k ^||TempSkinTestSub
		s tab = " "
		s pagesize=21	;行数
		s sub=0
		f  s sub=$o(^ABN.DHCNurSkinTestRecD(skinTestRecRowid,"ChildSub",sub)) q:sub=""  s item=^(sub) d
		.s (MissionWind,Blushes,MissTip)=""
		.s subObj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(skinTestRecRowid_"||"_sub)
		.;q:subObj.OrderStatus()'="V"
		.s ItmMastdr=$list(item,3)
		.s ItmMastDesc = $p(^ARCIM(+ItmMastdr,$p(ItmMastdr,"||",2),1),"^",2)
		.s ItmMastDesc = $p(ItmMastDesc,"(")
		.s OeorditemID = $list(item,4)
		.s orderParref=+OeorditemID
		.s orderId=$p(OeorditemID,"||",2)
		.s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		.s depProcNotesIndex = 0
		.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		..s depProcNotes = ^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
		.s:depProcNotes'="" ItmMastDesc=depProcNotes
		.s arcosdr = $p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",10)		;OEORI_ARCOS_DR
		.s MissionWind1=$list(item,5)
		.s MissionWind2=$list(item,6)
		.s MaxMissionWind=$s(MissionWind1>MissionWind2:MissionWind1,1:MissionWind2)
		.s:flag MissTip = "("_$s(MaxMissionWind>=20:"++++",MaxMissionWind>=15:"+++",MaxMissionWind>=10:"++",MaxMissionWind>=5:"+",1:"-")_")"
		.s MissionWind = MissionWind1_"*"_MissionWind2_MissTip
		.s:^DHCDocConfig("AllergyCureItem","EditCombo")[ItmMastdr MissionWind=MissionWind1
		.s:^DHCDocConfig("AllergyCureItem","NoChangeAdd")[ItmMastdr MissionWind = MissionWind1_"*"_MissionWind2
		.s Blushes1=$list(item,7)
		.s Blushes2=$list(item,8)
		.s:Blushes1'="" Blushes=Blushes1_"*"_Blushes2
		.s Pseudopodia=$list(item,9)
		.s Memo=$list(item,10)
		.s billed=$p(^OEORD(+OeorditemID,"I",$p(OeorditemID,"||",2),3),"^",5)
		.s isPaid=0,isPaidDesc="该项目没有收费"
		.s:billed="P" isPaid=1,isPaidDesc="已收"	;没收费的不能测试
		.s Testable=1
		.s ^||TempSkinTestSub(arcosdr,ItmMastdr)=$lb(skinTestRecRowid_"||"_sub,OeorditemID,ItmMastdr,tab_ItmMastDesc,Testable,MissionWind,Blushes,Pseudopodia,Memo,isPaid,isPaidDesc) 
		
		;循环--变态反应科的过敏源套
		s arcosdr=0 f  s arcosdr=$o(^DHCCTACARCOSi(0,"ARCOS",arcosdr)) q:arcosdr=""  d
		.q:$d(^||TempSkinTestSub(arcosdr))'=10
		.s arcosdesc = $e($p(^ARCOS(arcosdr),"^",2),5,)
		.s ind = ind+1
		.s no=1
		.i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1) =^CacheTemp(repid,(ind#pagesize)+1)_$lb("","","",arcosdesc,0,"风团","红晕","伪足","","","","")		;组名
		.i ind\pagesize=0 s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0,"风团","红晕","伪足","","","","")		;组名	
		.s ARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(arcosdr)
		.s arcossub=$p(ARCOSDateRowid,"||",2)
		.s item=0 f  s item= $o(^ARCOS(arcosdr,"DATE",arcossub,"ITM",item)) q:item=""  s str=^(item)  d
		..s ItmMastdr = $p(str,"^",1)
		..q:$d(^||TempSkinTestSub(arcosdr,ItmMastdr))=0
		..s ind=ind+1
		..i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1)=^CacheTemp(repid,(ind#pagesize)+1)_^||TempSkinTestSub(arcosdr,ItmMastdr)_$lb(no)		
		..i ind\pagesize=0 s ^CacheTemp(repid,ind)=^||TempSkinTestSub(arcosdr,ItmMastdr)_$lb(no)
		..s no=no+1
		
		/*
		;s len = $ll(^||TempSkinTestSub(arcosdr,ItmMastdr))
		s arcosdr=0
		f  s arcosdr=$o(^||TempSkinTestSub(arcosdr)) q:arcosdr=""  d
		.s arcosdesc=$e($p(^ARCOS(arcosdr),"^",2),5,)
		.s no=1
		.s ind = ind+1
		.i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1) =^CacheTemp(repid,(ind#pagesize)+1)_$lb("","","",arcosdesc,0,"风团","红晕","伪足","","","","")		;组名
		.; ind\pagesize=0 第一列
		.i ind\pagesize=0 s ^CacheTemp(repid,ind) = $lb("","","",arcosdesc,0,"风团","红晕","伪足","","","","")		;组名	
		.s ItmMastdr=0 
		.f  s ItmMastdr=$o(^||TempSkinTestSub(arcosdr,ItmMastdr)) q:ItmMastdr=""  d
		..s ind=ind+1
		..i ind\pagesize=1 s ^CacheTemp(repid,(ind#pagesize)+1)=^CacheTemp(repid,(ind#pagesize)+1)_^||TempSkinTestSub(arcosdr,ItmMastdr)_$lb(no)		
		..i ind\pagesize=0 s ^CacheTemp(repid,ind)=^||TempSkinTestSub(arcosdr,ItmMastdr)_$lb(no)
		..s no=no+1
		*/
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// d ##class(ABN.dao.DHCNurSkinTestRecSub).Save("1||1^1^1^10^10^^")
ClassMethod Save(req, userdr)
{
	s ^Temp("wanghc","ABN.dao.DHCNurSkinTestRecSub","Save")=req_","_userdr
	s $zt="ERROR"	
	s len = $l(req,$c(2))
	s id = $p($p(req,$c(2),1),"^",1)
	s parref =+id
	s parrefObj = ##class(ABN.DHCNurSkinTestRec).%OpenId(parref)
	;s applyDate = parrefObj.ApplyDate
	;q:applyDate'=+$h "-1^不是当天,不能修改"
	s parrefObj.CheckUser=userdr
	s parrefObj.CheckDate = +$h
	s parrefObj.CheckTime = $p($h,",",2)
	;i parrefObj.IsExec'="Y" {
	;	d ##class(ABN.dao.DHCNurSkinTestRec).RunExecOrder(parref,SeatNo,CtLocId,QueryTypeCode,userdr)
	;	s parrefObj.IsExec="Y"
	;}
	d parrefObj.%Save()
	d parrefObj.%Close()
	s parrefObj=""
	f i=1:1:len d
	.s item = $p(req,$c(2),i)
	.s id = $p(item,"^",1)
	.s obj = ##class(ABN.DHCNurSkinTestRecSub).%OpenId(id)
	.s obj.MissionWind1 = $p(item,"^",2)
	.s obj.MissionWind2 = $p(item,"^",3)
	.s obj.Blushes1 = $p(item,"^",4) 
	.s obj.Blushes2 = $p(item,"^",5)
	.s obj.Pseudopodia = $p(item,"^",6)
	.s obj.Memo=$p(item,"^",7)	
	.d obj.%Save()
	q 0
ERROR
	S ^Temp("ABN.dao.DHCNurSkinTestRecSub","Save","ERROR")=	$ZE	
	Q -1_"^"_$ZE
}

}
