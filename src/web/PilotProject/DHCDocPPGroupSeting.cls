Class web.PilotProject.DHCDocPPGroupSeting Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetConfigNode(NodeString As %String, Para1 As %String = "", myExpStr As %String = "", InHosp = "")
{
	if (Para1="")&&(myExpStr="")&&(InHosp=""){
		Q $g(^DHCDocPilotSeting(NodeString))
	}elseif (Para1'=""){
		Q $g(^DHCDocPilotSeting(NodeString,Para1))
	}elseif (myExpStr'=""){
		Q $g(^DHCDocPilotSeting(NodeString,Para1,myExpStr))
	}elseif (InHosp'=""){
		Q $g(^DHCDocPilotSeting(InHosp,NodeString))
	}else{
		Q ""
	}
}

ClassMethod GetCFGValue(InHosp = "", Code As %String = "")
{
	;##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"PilotProReg")
	Q:Code=""||InHosp="" ""
	Q $g(^DHCDocPilotSeting(InHosp,Code))
}

ClassMethod Save1Method(ParaStr As %String, myExpStr As %String = "", InHosp = "") As %String
{
	Q:InHosp="" -101
	s PilotExpression=$p(ParaStr,"^",1)
	s SuperDepRowId=$p(ParaStr,"^",2)
	s PilotProReg=$p(ParaStr,"^",3)
	s PilotProSubCatStr=$p(ParaStr,"^",4)  ;以$C(1)分割字符串内项目eg:"1S1"_$c(1)_"1S2",S代表||
	s ProCodeLenght=$p(ParaStr,"^",5)
	s EntryOrdBillPad=$p(ParaStr,"^",6)
	s PilotPatAdmReason=$p(ParaStr,"^",7)
	s PatAddNeedProRem=$p(ParaStr,"^",8)
	s IPPilotPatAdmReason=$p(ParaStr,"^",9)
	s AutoProCode=$p(ParaStr,"^",10)
	s ProCodeStart=$p(ParaStr,"^",11)
	s ArchivesFilesNoStart=$p(ParaStr,"^",12)
	s OPOrdAutoBilled=$p(ParaStr,"^",13)
	/*  //对rowid有||符号的处理
	for i=1:1:$l(PilotProSubCatStr,"!") {
		s tempStr=$p(PilotProSubCatStr,"!",i)
		if tempStr="" continue
		s tempStr1=$p(tempStr,"S",1)
		s tempStr2=$p(tempStr,"S",2)
		s $p(PilotProSubCatStr,"!",i)=tempStr1_"||"_tempStr2
	}
	*/
	b
	;使用$I计算开始号那么开始号设定需要比填写值小一位
	if (+ProCodeStart=0) s ProCodeStart=""
	else  s ProCodeStart=(ProCodeStart-1)
	;档案自动起始编号
	if (+ArchivesFilesNoStart=0) s ArchivesFilesNoStart=""
	else  s ArchivesFilesNoStart=(ArchivesFilesNoStart-1)
	
	s ^DHCDocPilotSeting(InHosp,"PilotExpression")=PilotExpression
	s ^DHCDocPilotSeting(InHosp,"SuperDepRowId")=SuperDepRowId
	s ^DHCDocPilotSeting(InHosp,"PilotProReg")=PilotProReg
	s ^DHCDocPilotSeting(InHosp,"PilotProSubCatStr")=PilotProSubCatStr
	s ^DHCDocPilotSeting(InHosp,"ProCodeLenght")=ProCodeLenght
	s ^DHCDocPilotSeting(InHosp,"EntryOrdBillPad")=EntryOrdBillPad
	s ^DHCDocPilotSeting(InHosp,"PilotPatAdmReason")=PilotPatAdmReason
	s ^DHCDocPilotSeting(InHosp,"PatAddNeedProRem")=PatAddNeedProRem
	s ^DHCDocPilotSeting(InHosp,"IPPilotPatAdmReason")=IPPilotPatAdmReason
	s ^DHCDocPilotSeting(InHosp,"AutoProCode")=AutoProCode
	s ^DHCDocPilotSeting(InHosp,"ProCodeStart")=ProCodeStart
	s ^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart")=ArchivesFilesNoStart
	s ^DHCDocPilotSeting(InHosp,"OPOrdAutoBilled")=OPOrdAutoBilled
	Q 0
}

ClassMethod GetInitInfo(InHosp = "") As %String
{
	Q:InHosp="" ""
	s PilotProSubCatStr=$g(^DHCDocPilotSeting(InHosp,"PilotProSubCatStr"))
	/*  //对rowid有||符号的处理
	for i=1:1:$l(PilotProSubCatStr,"!") {
		s tempStr=$p(PilotProSubCatStr,"!",i)
		s tempStr1=$p(tempStr,"||",1)
		s tempStr2=$p(tempStr,"||",2)
		s $p(PilotProSubCatStr,"!",i)=tempStr1_"S"_tempStr2
	}
	*/
	s ProCodeLenght=$g(^DHCDocPilotSeting(InHosp,"ProCodeLenght"))
	s EntryOrdBillPad=$g(^DHCDocPilotSeting(InHosp,"EntryOrdBillPad"))
	s PilotPatAdmReason=$g(^DHCDocPilotSeting(InHosp,"PilotPatAdmReason"))
	s PatAddNeedProRem=$g(^DHCDocPilotSeting(InHosp,"PatAddNeedProRem"))
	s IPPilotPatAdmReason=$g(^DHCDocPilotSeting(InHosp,"IPPilotPatAdmReason"))
	s AutoProCode=$g(^DHCDocPilotSeting(InHosp,"AutoProCode"))
	s ProCodeStart=$g(^DHCDocPilotSeting(InHosp,"ProCodeStart"))
	s:ProCodeStart'="" ProCodeStart=(ProCodeStart+1)
	s ArchivesFilesNoStart=$g(^DHCDocPilotSeting(InHosp,"ArchivesFilesNoStart"))
	s:ArchivesFilesNoStart'="" ArchivesFilesNoStart=(ArchivesFilesNoStart+1)
	

	
	s myrtnStr=$g(^DHCDocPilotSeting(InHosp,"PilotExpression"))_"^"_$g(^DHCDocPilotSeting(InHosp,"SuperDepRowId"))_"^"_$g(^DHCDocPilotSeting(InHosp,"PilotProReg"))
	s myrtnStr=myrtnStr_"^"_PilotProSubCatStr
	s myrtnStr=myrtnStr_"^"_ProCodeLenght
	s myrtnStr=myrtnStr_"^"_EntryOrdBillPad
	s myrtnStr=myrtnStr_"^"_PilotPatAdmReason
	s myrtnStr=myrtnStr_"^"_PatAddNeedProRem
	s myrtnStr=myrtnStr_"^"_IPPilotPatAdmReason
	s myrtnStr=myrtnStr_"^"_AutoProCode
	s myrtnStr=myrtnStr_"^"_ProCodeStart
	s myrtnStr=myrtnStr_"^"_ArchivesFilesNoStart
	s myrtnStr=myrtnStr_"^"_$g(^DHCDocPilotSeting(InHosp,"OPOrdAutoBilled"))
	Q myrtnStr
}

ClassMethod FindSubCat(InHosp = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPPGroupSeting).FindSubCat()
	/*  走组合rowid
	s myrtnStr=""
    s CategoryID=""
    s CategoryID=$o(^ARC("IC",0,"OrdCat",CategoryID)) Q:CategoryID=""  d
 	.s SubCatID="" f  s SubCatID=$o(^ARC("IC",0,"OrdCat",CategoryID,SubCatID)) q:SubCatID=""  d
	..s SubCatDesc=$p(^ARC("IC",SubCatID),"^",2)
	..s SubCatCode=$p(^ARC("IC",SubCatID),"^",1)
	..s IndexValue=CategoryID_"S"_SubCatID
	..if myrtnStr="" s myrtnStr=IndexValue_$c(1)_SubCatDesc
	..else  s myrtnStr=myrtnStr_$c(2)_IndexValue_$c(1)_SubCatDesc
	*/
	s myrtnStr=""
	s SubCatID=""
	for  s SubCatID=$o(^ARC("IC",SubCatID)) Q:SubCatID=""  d
	.q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",SubCatID,InHosp)="N"
	.s SubCatDesc=$p(^ARC("IC",SubCatID),"^",2)
	.s SubCatCode=$p(^ARC("IC",SubCatID),"^",1)
	.if myrtnStr="" s myrtnStr=SubCatID_$c(1)_SubCatDesc
	.else  s myrtnStr=myrtnStr_$c(2)_SubCatID_$c(1)_SubCatDesc
	Q myrtnStr
}

/// 得到费别List信息
ClassMethod ReadAdmReasonListBroker(JSFunName As %String = "", ListName As %String = "", InHosp = "") As %String
{
	;w ##class(web.PilotProject.DHCDocPPGroupSeting).ReadAdmReasonListBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s json="["
	s myIdx=1
	f  s myRowid=$o(^PAC("ADMREA",myRowid)) q:(myRowid="")  d
	.s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason",myRowid,InHosp)
    .q:showflag="N"
	.s mydes=$p(^PAC("ADMREA",myRowid),"^", 2)
	.s StartDate=$p(^PAC("ADMREA",myRowid),"^", 3)
	.s EndDate=$p(^PAC("ADMREA",myRowid),"^", 4)
	.Q:(StartDate'="")&&(StartDate>+$h)
	.Q:(EndDate'="")&&(EndDate<+$h)
	.s myval=myRowid
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.i JSFunName="GetAdmReasonToHUIJson" d
	..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
	..i mySelFlag=1 s OneJsonData=OneJsonData_",""selected"":true"
	..s OneJsonData=OneJsonData_"}"
	..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
	
	.e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	..s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	s json=json_"]"   
	i JSFunName="GetAdmReasonToHUIJson" {
		q json
	}
	q 0
}

Query LookUpAllLoc(Loc As %String, InHosp = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,rowid:%String,Alias:%String,IfApprove:%String") [ SqlProc ]
{
}

ClassMethod LookUpAllLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpAllLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpAllLocExecute(ByRef QHandle As %Binary, Loc As %String, InHosp = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProject","FindLoc","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.i $l(CTDesc,"-")>1 s CTDesc=$p(CTDesc,"-",2,$l(CTDesc,"-"))
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.s CTType=$p($g(^CTLOC(rowid)),"^",13)
	.s CTActive=$p($g(^CTLOC(rowid)),"^",14)
	.q:CTActive'="Y"
	.s Hosp=$p($g(^CTLOC(rowid)),"^",22)
	.s StartDate=$p($g(^CTLOC(rowid)),"^",24)
	.s EndDate=$p($g(^CTLOC(rowid)),"^",25)
	.q:(InHosp'="")&&(InHosp'=Hosp)
	.Q:CTType="OR"
	.Q:(StartDate'="")&&(StartDate>+$h)
	.Q:(EndDate'="")&&(EndDate<+$h)
	.;用作放助记码的地方
	.;s ContactName=$p($g(^CTLOC(rowid)),"^",43)   ;现在维护科室别名的地方
	.s CTContactName=$P($p($g(^CTLOC(rowid)),"^",2),"-",1)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	.//Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Q:##class(web.DHCOPAdmReg).CheckLocDesc(rowid,Loc)'=1 
	.s IfApprove=$g(^UDHCDocPilotProConfig("DeptApprove",rowid))
	.Do OutputRow1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName,IfApprove)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod LookUpAllLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAllLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveConfig(Node As %String, Node1 As %String, NodeValue As %String) As %String
{
	q:(Node="")||(Node1="") 0
	s ^UDHCDocPilotProConfig(Node,Node1)=NodeValue
	q 0
}

}
