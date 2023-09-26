Class web.INSUMTReg Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod QueryINSUDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryINSUDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryINSUDocExecute(ByRef qHandle As %Binary, Code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;q:Code="" $$$OK
	//^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4({CTPCP_Desc}),{CTPCP_RowId}) 
	s InsuDocid="",ctpcpcode=""
	f  s ctpcpcode=$o(^CTPCP(0,"Decs",ctpcpcode)) q:ctpcpcode=""  d
	.q:(ctpcpcode'[Code)&(Code'="")
	.s Ctpcpid=""
	.f  s Ctpcpid=$o(^CTPCP(0,"Decs",ctpcpcode,Ctpcpid)) q:Ctpcpid=""  d
	..s InsuDocid=$p(^CTPCP(Ctpcpid,3),"^",11)
	..q:(InsuDocid="")&(Code="")
	..s DocDesc=$p(^CTPCP(Ctpcpid,1),"^",2) //医生
	..d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(Ctpcpid,ctpcpcode,DocDesc,InsuDocid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryINSUDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryINSUDocExecute ]
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

Query QueryINSUDoc(Code As %String) As %Query(ROWSPEC = "Ctpcpid:%String,ctpcpcode:%String,DocDesc:%String,InsuDocid:%String")
{
}

/// 保存门特登记信息
ClassMethod SaveINSURegInfo(InStr As %String) As %String
{
	
	s InString=$tr(InStr,$c(0),"")
	s InString=$tr(InStr,"$","")
	q:InString="" -100
	s Save=$$SaveINSURegInfo^INSUMTReg(InString)
	q Save
}

ClassMethod SaveMTDownload(MTRegRowid As %String, InParam As %String) As %String
{
	q:InParam="" "-1"
	;s ^TMPZMC(33)=InParam
	s InParam=$tr(InParam,$c(0),"")
	s InParam=$tr(InParam,$c(13),"")
	s InParam=$tr(InParam,$c(10),"")
	s InParam=$tr(InParam,$c(13,10),"")
	s InParam=$tr(InParam,"$","")
	s InParam=$tr(InParam,"%","")
	s InParam=$tr(InParam,"{","")
	s InParam=$tr(InParam,"}","")
	q:$l(InParam,"|")<50 "-2"
	s Save="-3"
	i +MTRegRowid>0  d
	.s RebParam=..GetINSURegInfo(MTRegRowid)
	.s $p(RebParam,"^",4)=$p(InParam,"|",3)
	.s $p(RebParam,"^",5)=$p(InParam,"|",19)	//病种
	.s $p(RebParam,"^",6)="I"
	.s $p(RebParam,"^",7)=$p(InParam,"|",4)	//医保号
	.;s $p(RebParam,"^",8)=$p(InParam,"|",12)	//病人类型
	.s $p(RebParam,"^",10)=$p(InParam,"|",3)	//门特登记编号
	.s $p(RebParam,"^",12)=$p(InParam,"|",26)	//登记类别
	.;s $p(RebParam,"^",14)=$p(InParam,"|",3)	//分中心
	.s $p(RebParam,"^",15)=$p(InParam,"|",37)	//有效标志
	.;s $p(RebParam,"^",17)=	//诊断医师
	
	.s $p(RebParam,"^",18)=$p(InParam,"|",21)	//诊断医师编码
	.s $p(RebParam,"^",19)=$p(InParam,"|",30)
	.s $p(RebParam,"^",20)=$p(InParam,"|",31)
	.s $p(RebParam,"^",21)=$p(InParam,"|",32)
	.s $p(RebParam,"^",22)=$p(InParam,"|",34)
	.s $p(RebParam,"^",23)=$p(InParam,"|",22)
	.s $p(RebParam,"^",24)=$p(InParam,"|",41)
	.s $p(RebParam,"^",25)=$p(InParam,"|",42)
	.s $p(RebParam,"^",26)=$p(InParam,"|",33)
	.s $p(RebParam,"^",27)=$p(InParam,"|",38)
	.s $p(RebParam,"^",28)=$p(InParam,"|",43)
	.s $p(RebParam,"^",29)=$p(InParam,"|",44)
	.s $p(RebParam,"^",30)=$p(InParam,"|",45)
	.s $p(RebParam,"^",31)=$p(InParam,"|",46)
	.s $p(RebParam,"^",32)=$p(InParam,"|",49)
	.s $p(RebParam,"^",33)=$p(InParam,"|",50)
	.s $p(RebParam,"^",34)=$p(InParam,"|",51)
	.s $p(RebParam,"^",35)=$p(InParam,"|",52)
	.s $p(RebParam,"^",36)=$p(InParam,"|",20)
	.s $p(RebParam,"^",37)=$p(InParam,"|",15)
	.s $p(RebParam,"^",38)=$p(InParam,"|",12)
	.s $p(RebParam,"^",39)=$Extract($p(InParam,"|",27),1,200)	//病史
	.s $p(RebParam,"^",40)=$Extract($p(InParam,"|",28),1,200)	//辅助检查
	.s $p(RebParam,"^",41)=$Extract($p(InParam,"|",29),1,200)	//临床诊断
	.s $p(RebParam,"^",42)=$p(InParam,"|",23)	//电话
	.s $p(RebParam,"^",43)=$p(InParam,"|",25)	//家庭地址
	.s $p(RebParam,"^",44)=$p(InParam,"|",47)
	.s $p(RebParam,"^",45)=$p(InParam,"|",48)
	.s $p(RebParam,"^",46)=$p(InParam,"|",18)
	.s tmpBeginDate=$p(InParam,"|",35)
	.s tmpBeginDate=$p(tmpBeginDate," ",1)
	.i $g(tmpBeginDate)'="" d
	..s tmpBeginDate=$zdh(tmpBeginDate,3)
	..s $p(RebParam,"^",52)=$zd(tmpBeginDate,4)
	.s $p(RebParam,"^",53)=""
	.s tmpEndDate=$p(InParam,"|",36)
	.s tmpEndDate=$p(tmpEndDate," ",1)
	.i $g(tmpEndDate)'=""  d
	..s tmpEndDate=$zdh(tmpEndDate,3)
	..s $p(RebParam,"^",54)=$zd(tmpEndDate,4)
	.s $p(RebParam,"^",55)=""
	.s Save=$$SaveINSURegInfo^INSUMTReg(RebParam)
	;s Save=$$SaveINSURegInfo^DHCINSUAdmInfo(InString)
	q Save
}

/// 根据rowid取门特登记信息
/// 根据rowid取门特登记信息
ClassMethod GetINSURegInfo(Index As %String) As %String
{
	
	q:+Index=0 "-1"
	q:$d(^DHCINSUREGINFO(Index))=0 "-2"
	s RegInfo=$g(^DHCINSUREGINFO(Index))
	s $p(RegInfo,"^",59)=$zd($p(RegInfo,"^",59),4)
	s:$p(RegInfo,"^",51)'="" $p(RegInfo,"^",51)=$zd($p(RegInfo,"^",51),4)	//门特开始日期
	s:$p(RegInfo,"^",53)'="" $p(RegInfo,"^",53)=$zd($p(RegInfo,"^",53),4)	//门特结束日期日期
	s:$p(RegInfo,"^",55)'="" $p(RegInfo,"^",55)=$zd($p(RegInfo,"^",55),4)	//
	q Index_"^"_RegInfo
}

/// 根据登记号查询门特登记历史
ClassMethod QueryMTRegInfo(PatRegNo As %String) As %String
{
	//^DHCINSUREGINFO("0","PatRegNO",{INRIF_PatRegNo},{INRIF_Rowid})
	q:PatRegNo="" "-1"
	q:$d(^DHCINSUREGINFO("0","PatRegNO",PatRegNo))=0 "-2"
	s INRIFRowid="",RtnStr=""
	f  s INRIFRowid=$o(^DHCINSUREGINFO("0","PatRegNO",PatRegNo,INRIFRowid))  q:INRIFRowid=""  d
	.s RegInfo=$g(^DHCINSUREGINFO(INRIFRowid))
	.;q:$p(RegInfo,"^",10)'="MTDJ"
	.q:$p(RegInfo,"^",5)="S"
	.s $p(RegInfo,"^",59)=$zd($p(RegInfo,"^",59),4)
	.s:$p(RegInfo,"^",51)'="" $p(RegInfo,"^",51)=$zd($p(RegInfo,"^",51),4)	//门特开始日期
	.s:$p(RegInfo,"^",53)'="" $p(RegInfo,"^",53)=$zd($p(RegInfo,"^",53),4)	//门特结束日期日期
	.s:$p(RegInfo,"^",55)'="" $p(RegInfo,"^",55)=$zd($p(RegInfo,"^",55),4)	//
	.s RtnStr=RtnStr_"$"_INRIFRowid_"^"_RegInfo
	q RtnStr
}

}
