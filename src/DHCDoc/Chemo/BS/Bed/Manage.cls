/// CTOR: QP
/// DATE: 2020-12-17
/// DESC: 门诊化疗床位管理
Class DHCDoc.Chemo.BS.Bed.Manage Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-12-22
/// DESC: 本地化数据
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).InitData()
ClassMethod InitData(SelectDate)
{
	;默认显示床位数
	s ^CF.DOC.Chemo.Local("BD","DefaultBedNum")=20
	
	;每行显示床位个数
	s ^CF.DOC.Chemo.Local("BD","RowBedNum")=4
	
	;化疗常用科室
	s ^CF.DOC.Chemo.Local("BD","BedChemoDep")="144,152,176,185,191,203,229,308"
	
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-12-25
/// DESC: 加载卡片
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).LoadCard("2020-12-23","A")
ClassMethod LoadDrugListOLd1(bid)
{
	s mRtn=""
	s rownum=2	;没行展示几个
	s id="",num=0
	f  s id=$o(^CF.DOC.Chemo.DrugDicD(id)) q:id=""  d
	.s arcim=$p(^CF.DOC.Chemo.DrugDicD(id),"^",1)
	.s active=$p(^CF.DOC.Chemo.DrugDicD(id),"^",3)
	.q:active'=1
	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	.s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1) 
	.s record="<input class='c-check' name='drug' type='checkbox' label='"_arcimDesc_"' value='"_arcim_"'>"
	.s mRtn=mRtn_record
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-05-10
/// DESC: 获取就诊科室
/// 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetAdmLoc("20")
ClassMethod GetAdmLoc(PlanDR = "")
{
	Q:PlanDR="" ""
	s AdmLoc=$p(^BS.DOC.Chemo.PlanD(PlanDR),"^",4)
	Q AdmLoc
}

/// CTOR: QP
/// DATE: 2020-12-25
/// DESC: 加载卡片
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).LoadDrugList("1731","2021-05-10")
ClassMethod LoadDrugList(bid, ChemoDate, PlanDR = "")
{
	s ^QP("ddd")=$lb(bid,ChemoDate)
	s mRtn=""
	s langid=..%LanguageID()
	i PlanDR="" s PlanDR=$p(^BS.DOC.Chemo.BedD(bid),"^",10)
	Q:PlanDR="" mRtn
	s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ChemoDate)
	s rownum=2	;每行展示几个
	s num=0
	s SID=""
	f  s SID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID)) Q:SID=""  D
	.s startDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",3)
	.s endDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",4)
	.s showDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID),"^",21)
	.q:showDate=""
	.q:(startDate>ChemoDate)||(endDate<ChemoDate)
	.s tempFlag=##class(DHCDoc.Chemo.COM.Func2).ContainDate(showDate,ChemoDate)
	.q:tempFlag'=1
	.s GID=""
	.f  s GID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID)) Q:GID=""  D
	..s ID=""
	..f  s ID=$O(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID)) Q:ID=""  D
	...s arcim=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID),"^",1)
	...s showDate=$p(^BS.DOC.Chemo.PlanD(PlanDR,SID,GID,ID),"^",28)
	...s tempFlag=##class(DHCDoc.Chemo.COM.Func2).ContainDate(showDate,ChemoDate)
	...q:tempFlag'=1
	...s ARC=+arcim,VER=$P(arcim,"||",2)
 	...s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
 	...s arcimDesc= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcimDesc,langid)
	...s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1) 
	...s num=num+1
	...s TR="<tr>",EndTR="</tr>"
	...s record="<td><input class='c-check' name='drug' type='checkbox' checked disabled label='"_arcimDesc_"' value='"_arcim_"'></td>"
	...i num#rownum=0 d
	....s mRtn=mRtn_record_EndTR
	...e  d
	....s mRtn=mRtn_TR_record
	
	i num#rownum=1 s mRtn=mRtn_EndTR
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-25
/// DESC: 加载卡片
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).LoadCard("2020-12-23","A")
ClassMethod LoadDrugListOld2(bid)
{
	//s ^QP("ddd")=bid
	s mRtn=""
	s rownum=2	;没行展示几个
	s id="",num=0
	f  s id=$o(^CF.DOC.Chemo.DrugDicD(id)) q:id=""  d
	.s arcim=$p(^CF.DOC.Chemo.DrugDicD(id),"^",1)
	.s active=$p(^CF.DOC.Chemo.DrugDicD(id),"^",3)
	.q:active'=1
	.s ARC=+arcim,VER=$P(arcim,"||",2)
 	.s arcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	.s arcimCode=$p(^ARCIM(ARC,VER,1),"^",1) 
	.s num=num+1
	.s TR="<tr>",EndTR="</tr>"
	.s record="<td><input class='c-check' name='drug' type='checkbox' label='"_arcimDesc_"' value='"_arcim_"'></td>"
	.i num#rownum=0 d
	..s mRtn=mRtn_record_EndTR
	.e  d
	..s mRtn=mRtn_TR_record
	
	i num#rownum=1 s mRtn=mRtn_EndTR
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-22
/// DESC: 加载卡片
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).LoadCard("24/03/2021","A")
ClassMethod LoadCard(SelectDate, Type, StartRow = "1", EndRow = "5", InHsop = "")
{
	s mRtn=""
	Q:InHsop="" mRtn
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s CurrentDate=+$H
	s IsHoliday=##class(web.DHCOPRegFestivalSet).CheckDayIsFestival(SelectDate)
	i '$d(^BS.DOC.Chemo.BedI("HospChemoDate",InHsop,SelectDate)) {
		;自动创建默认的床位
		s res=..CreateDefaultBed(SelectDate,InHsop)
		Q:res'=1 ""
	}
	s langid=..%LanguageID()
	k BList
	s TotalBed=..GetNumByType(SelectDate,Type,InHsop)
	Q:TotalBed=0 ""
	s RowBedNum=$g(^CF.DOC.Chemo.Local("BD","RowBedNum"))
	Q:RowBedNum="" ""
	s rows = 0	;行数
	i (TotalBed#RowBedNum)=0 {
		s rows = TotalBed/RowBedNum
	} else {
		s rows = TotalBed/RowBedNum + 1	
	}
	d ..GetBList(SelectDate,Type,InHsop,.BList)
	s count=0
	//i rows>=EndRow s 
	Q:StartRow>rows mRtn
	i StartRow=1 {
		//i rows<
	}
	;
	k FYList
	s FYList("BedNo")=##class(websys.Translation).Get("chemo.bs.bed.csp","床号")
	s FYList("IDNo")=##class(websys.Translation).Get("chemo.bs.bed.csp","ID号")
	s FYList("Sex")=##class(websys.Translation).Get("chemo.bs.bed.csp","性别")
	s FYList("Age")=##class(websys.Translation).Get("chemo.bs.bed.csp","年龄")
	s FYList("Phone")=##class(websys.Translation).Get("chemo.bs.bed.csp","电话")
	s FYList("Loc")=##class(websys.Translation).Get("chemo.bs.bed.csp","科室")
	s FYList("AddUser")=##class(websys.Translation).Get("chemo.bs.bed.csp","录入人")
	s FYList("Arrange")=##class(websys.Translation).Get("chemo.bs.bed.csp","分配")
	s FYList("Edit")=##class(websys.Translation).Get("chemo.bs.bed.csp","关联")
	s FYList("Clear")=##class(websys.Translation).Get("chemo.bs.bed.csp","清空")
	s FYList("Delete")=##class(websys.Translation).Get("chemo.bs.bed.csp","删除")
	f i=1:1:rows {
		s mRtn=mRtn_"<div class='a-row'>"
		f j=1:1:RowBedNum {
			s count=count+1
			//$lb(bid,PatientID,AdmID,CType,Address)
			continue:'$d(BList(count))
			s bid=$lg(BList(count),1)
			s PatientID=$lg(BList(count),2)
			s PatientNum="",tel=""
			i PatientID'="" {
				s PatientNum=$P(^PAPER(PatientID,"PAT",1),"^",1)
				s tel=$P(^PAPER(PatientID,"PER",1),"^",11)
			}
			s address=$lg(BList(count),5)
			s bnum=$lg(BList(count),6)
			s admLoc=$lg(BList(count),7)
			s admLocDesc=$lg(BList(count),8)
			s admLocDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",admLocDesc,langid)
			s EditUser=$lg(BList(count),9)
			i EditUser'="" s EditUser=$p(^SSU("SSUSR",EditUser),"^",2)
			s EditUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",EditUser,langid)
			s PatInfo=..GetPatientInfo(PatientID,InHsop)
			s patName=$p(PatInfo,"^",2)
			s age=$p(PatInfo,"^",3)
			s sex=$p(PatInfo,"^",4)
			s imgClass="imgunkonw"
			s cardClass="card"
			s:Type="P" cardClass="card cardPM"
			//w i_","_j,!
			i sex="女" s imgClass="imgwoman"
			i sex="男" s imgClass="imgman"
			//s mRtn=mRtn_"<div id='"_bid_"' class='card' ondblclick='Arrange_Handle("_bid_")'>"
			s mRtn=mRtn_"<div id='"_bid_"' class='"_cardClass_"'>"
			s mRtn=mRtn_	"<div class='cardtop'>"
			s mRtn=mRtn_	"<div class='imgdiv'>"
			s mRtn=mRtn_		"<div class='"_imgClass_"'></div>"
			s mRtn=mRtn_	"</div>"
			s mRtn=mRtn_	"<div class='content'>"
			s mRtn=mRtn_			"<div class='title'>"_patName_"</div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("BedNo")_"：</span><span class='c-label2'>"_bnum_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("IDNo")_"：</span><span class='c-label2'>"_PatientNum_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("Sex")_"：</span><span class='c-label2'>"_sex_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("Age")_"：</span><span class='c-label2'>"_age_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("Phone")_"：</span><span class='c-label2'>"_tel_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("Loc")_"：</span><span class='c-label2'>"_admLocDesc_"</span></div>"
			s mRtn=mRtn_			"<div><span class='c-label'>"_FYList("AddUser")_"：</span><span class='c-label2'>"_EditUser_"</span></div>"
			s mRtn=mRtn_	"</div>"
			s mRtn=mRtn_"</div>"
			s mRtn=mRtn_	"<div class='cardfoot'>"
			i (SelectDate>=CurrentDate)&&(IsHoliday'=1) {
			s mRtn=mRtn_		"<span class='c-btn-save' onclick='Arrange_Handle("_bid_","""_PatientID_""")'>"_FYList("Arrange")_"</span>"
			s mRtn=mRtn_		"<span class='c-btn-blue' onclick='Edit_Handle("_bid_","_PatientID_")'>"_FYList("Edit")_"</span>"
			s mRtn=mRtn_		"<span class='c-btn-yellow' onclick='Reset_Handle("_bid_")'>"_FYList("Clear")_"</span>"
			s mRtn=mRtn_		"<span class='c-btn-cancel' onclick='Del_Handle("_bid_")'>"_FYList("Delete")_"</span>"
			}
			s mRtn=mRtn_	"</div>"
			s mRtn=mRtn_"</div>"
		}
		s mRtn=mRtn_"</div>"
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-22
/// DESC: 产生默认数据
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).CreateDefaultBed(65735)
ClassMethod CreateDefaultBed(SelectDate, InHsop)
{
	s mRtn=1
	Q:$d(^BS.DOC.Chemo.BedI("HospChemoDate",InHsop,SelectDate)) mRtn
	s defaultNum=$g(^CF.DOC.Chemo.Local("BD","DefaultBedNum"))
	i defaultNum="" {
		d ..InitData()	
		s defaultNum=$g(^CF.DOC.Chemo.Local("BD","DefaultBedNum"))
	}
	TS
	;产生上午数据
	f i=1:1:defaultNum {
		//s bedNo=i+49	//1、床号从50开始，到59结束，59后增加 监1床位，之后增加床号为+1，+2表示
		s bedNo=i
		s mList="^"_SelectDate_"^A^^^^"_bedNo_"^^"_InHsop
		s mRtn=..Save(mList)
		Q:mRtn<0
	}
	i mRtn<0 {
		TRO
		Q -101	
	}
	
	;产生下午数据
	f i=1:1:defaultNum {
		//s bedNo=i+49
		s bedNo=i
		s mList="^"_SelectDate_"^P^^^^"_bedNo_"^^"_InHsop
		s mRtn=..Save(mList)
		Q:mRtn<0
	}
	i mRtn<0 {
		TRO
		Q -101
	}
	TC
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-1
/// DESC: 重置床位
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetBedNo(71)
ClassMethod GetBedNo(bnum)
{
	s mRtn=""
	i bnum=70 {
		s mRtn="监1床"
	} elseif bnum>70 {
		s mRtn="加"_(bnum-70)
	} else {
		s mRtn=bnum
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-22
/// DESC: 保存Bed
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).Save("")
ClassMethod Save(mList)
{
	s id=$p(mList,"^",1)
	s chemoDate=$p(mList,"^",2)
	s type=$p(mList,"^",3)
	s papmi=$p(mList,"^",4)
	s admid=$p(mList,"^",5)
	s address=$p(mList,"^",6)
	s bnum=$p(mList,"^",7)
	s dep=$p(mList,"^",8)
	s hosp=$p(mList,"^",9)
	
	i id="" {
		s a=##class(User.ChemoBed).%New()
		s a.BChemoDate=chemoDate
		s a.BNum=bnum
		d a.BHospSetObjectId(hosp)
	} else {
		s a=##class(User.ChemoBed).%OpenId(id)
	}
	d a.BAdmLocSetObjectId(dep)
	d a.BAdmDRSetObjectId(admid)
	d a.BPapmiDRSetObjectId(papmi)
	s a.BType=type
	s a.BAddress=address
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-120"
	}
	
	Q a.%Id()
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 获取总的床位数
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetNumByType("2021-03-11","A")
ClassMethod GetNumByType(SelectDate, Type, InHsop = "")
{
	s mRtn=0
	q:InHsop="" mRtn
	//s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	i '$d(^BS.DOC.Chemo.BedI("HospChemoDate",InHsop,SelectDate)) {
		s mRtn=$g(^CF.DOC.Chemo.Local("BD","DefaultBedNum"))
	} else {
		s bid=""
		f  s bid=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHsop,SelectDate,Type,bid)) q:bid=""  d
		.s mRtn=mRtn+1
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到病人信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetPatientInfo("1")
ClassMethod GetPatientInfo(PatientID = "", InHosp = "")
{
	s mRtn=""
	Q:PatientID="" mRtn
	s langid=..%LanguageID()
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)
	;s age=##class(web.DHCSTKUTIL).GetAge(PatientID)
	s age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",InHosp)
 	s patSex=$p(^PAPER(PatientID,"ALL"),"^",7)
 	s sex=$p(^CT("SEX",patSex),"^",2)
 	s sex= ##class(User.CTSex).GetTranByDesc("CTSEXDesc",sex,langid)
	s mRtn=PatientID_"^"_patName_"^"_age_"^"_sex
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到病人信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetPatientInfoByPatNo("0012121212")
ClassMethod GetPatientInfoByPatNo(PatNo = "", InHosp = "")
{
	s mRtn=""
	s PatNo=$zcvt(PatNo,"U")
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	s mRtn=..GetPatientInfo(PatientID,InHosp)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到病人信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetBList("0000000001")
ClassMethod GetBList(SelectDate, Type, InHsop, ByRef BList)
{
	s bid="",num=0
	f  s bid=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHsop,SelectDate,Type,bid)) q:bid=""  d
	.s PatientID=$P(^BS.DOC.Chemo.BedD(bid),"^",2)
	.s AdmID=$P(^BS.DOC.Chemo.BedD(bid),"^",3)
	.s CType=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	.s Address=$P(^BS.DOC.Chemo.BedD(bid),"^",5)
	.s BNum=$P(^BS.DOC.Chemo.BedD(bid),"^",7)
	.;s BNum=..GetBedNo(BNum)
	.s AdmLoc=$P(^BS.DOC.Chemo.BedD(bid),"^",8)
	.s EditUser=$P(^BS.DOC.Chemo.BedD(bid),"^",9)
	.s PlanDR=$P(^BS.DOC.Chemo.BedD(bid),"^",10)
	.i PlanDR'="" s AdmLoc=$p(^BS.DOC.Chemo.PlanD(PlanDR),"^",4)
	.s AdmLocDesc=""
	.i AdmLoc'="" d
	..s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	..i AdmLocDesc["-" s AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s num=num+1
	.s BList(num)=$lb(bid,PatientID,AdmID,CType,Address,BNum,AdmLoc,AdmLocDesc,EditUser)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 分配床位
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).Arrange("0000000001")
ClassMethod Arrange(bid, PatientID)
{
	Q:(bid="")||(PatientID="") -1_"^"
	s Type=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	s ChemoDate=$P(^BS.DOC.Chemo.BedD(bid),"^",1)
	s CPatientID=$P(^BS.DOC.Chemo.BedD(bid),"^",2)
	i CPatientID'=PatientID {
		i $d(^BS.DOC.Chemo.BedI("ChemoDatePapmi",ChemoDate,PatientID)) {
			Q -2_"^"_Type
		}
	}
	&SQL(
		 UPDATE SQLUser.Chemo_Bed
		 SET B_PapmiDR=:PatientID
		 WHERE B_ID=:bid
	)
	Q SQLCODE_"^"_Type
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 修改
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).Arrange("0000000001")
ClassMethod Edit(bid, Address, DrugList, AdmLoc, UserID, ChemoPlan = "")
{
	Q:(bid="") -1_"^"
	s Type=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	&SQL(
		 UPDATE SQLUser.Chemo_Bed
		 SET B_Address=:Address,
		 	 B_DrugList=:DrugList,
		 	 B_AdmLoc=:AdmLoc,
		 	 B_EditUser=:UserID,
		 	 B_PlanDR=:ChemoPlan
		 WHERE B_ID=:bid
	)
	Q SQLCODE_"^"_Type
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 删除
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).Arrange("0000000001")
ClassMethod Delete(bid)
{
	Q:(bid="") -1_"^"
	s Type=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	&SQL(
		 DELETE FROM SQLUser.Chemo_Bed
		 WHERE B_ID=:bid
	)
	Q SQLCODE_"^"_Type
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 增加
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).Arrange("0000000001")
ClassMethod Add(SelectDate, Type)
{
	Q:(SelectDate="")||(Type="") -1
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s BNum=$o(^BS.DOC.Chemo.BedI("ChemoDateBTypeNum",SelectDate,Type,""),-1)
	Q:BNum="" -1
	s BNum=BNum+1
	&SQL(
		INSERT INTO SQLUser.Chemo_Bed (B_ChemoDate, B_Type, B_Num)
		VALUES (:SelectDate,:Type,:BNum)
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 增加
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetDefaultDate()
ClassMethod GetDefaultDate()
{
	s mRtn=##class(websys.Conversions).DateLogicalToHtml(+$h)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-09
/// DESC: 获取病人最后一次就诊
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetLastAdm()
ClassMethod GetLastAdm(PatientID)
{
	s OID=$O(^PAPERdr(PatientID,"ADM","O",""),-1)
	s EID=$O(^PAPERdr(PatientID,"ADM","O",""),-1)
	s IID=$O(^PAPERdr(PatientID,"ADM","O",""),-1)
	Q:((OID="")&&(EID="")&&(IID="")) ""
	s OAdmDate=0,EAdmDate=0,IAdmDate=0
	i OID'="" s OAdmDate=$p(^PAADM(OID),"^",6)
	i EID'="" s EAdmDate=$p(^PAADM(EID),"^",6)
	i IID'="" s IAdmDate=$p(^PAADM(IID),"^",6)
	s MaxID=""
	i OAdmDate>EAdmDate {
		i OAdmDate>IAdmDate {
			s MaxID=OID
		} else {
			s MaxID=IID
		}
	} else {
		i EAdmDate>IAdmDate {
			s MaxID=EID
		} else {
			s MaxID=IID	
		}
	}
	
	Q MaxID
}

/// CTOR: QP
/// DATE: 2021-03-1
/// DESC: 重置床位
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).ResetBed()
ClassMethod ResetBed(bid)
{
	Q:(bid="") -1_"^"
	s Type=$P(^BS.DOC.Chemo.BedD(bid),"^",4)
	&SQL(
		 UPDATE SQLUser.Chemo_Bed
		 SET B_PapmiDR=NULL,B_AdmDR=NULL,B_Address=NULL,
		 	 B_DrugList=NULL,B_AdmLoc=NULL,B_EditUser=NULL,
		 	 B_PlanDR=NULL
		 WHERE B_ID=:bid
	)
	Q SQLCODE_"^"_Type
}

/// CTOR: QP
/// DATE: 2021-03-29
/// DESC: 比较两个日期大小
/// IN  : 
/// OUT : 1/0/-1/""
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).CompareDate()
ClassMethod CompareDate(D1, D2 = "")
{
	
	Q:D1=""
	s D1=##class(websys.Conversions).DateHtmlToLogical(D1)
	i D2="" S D2=+$H
	e  s D2=##class(websys.Conversions).DateHtmlToLogical(D2)
	Q:D1=D2 0
	Q:D1>D2 1
	Q:D1<D2 -1
	Q ""
}

/// CTOR: QP
/// DATE: 2022-03-16
/// DESC: 获取当前时间是上午还是下午
/// 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.Manage).GetAmOrPM()
ClassMethod GetAmOrPM()
{
	s mRtn="AM"
	s CurrentTime=$p($h,",",2)
	i CurrentTime>43200 {
		s mRtn="PM"	
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-11
/// DESC: 化疗常用科室
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","QryChemoDep","")
Query QryChemoDep(InDesc = "") As %Query(ROWSPEC = "id,desc,otherName")
{
}

ClassMethod QryChemoDepExecute(ByRef qHandle As %Binary, InDesc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i InDesc="" {
	 	//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	s BedChemoDep=$g(^CF.DOC.Chemo.Local("BD","BedChemoDep"))
	i BedChemoDep="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s langid=..%LanguageID()
	f i=1:1:$l(BedChemoDep,",") {
		s id=$p(BedChemoDep,",",i)
		s desc=$p(^CTLOC(id),"^",2)
		s otherName=$p(^CTLOC(id),"^",43)
		s otherName=$zcvt(otherName,"U")
		s descUpper=$zcvt(desc,"U")
		i desc["-" s desc=$p(desc,"-",2)
		s isExit=1
		i InDesc'="" {
			i otherName[InDesc s isExit=0
			i descUpper[InDesc s isExit=0
		} else { 
			s isExit=0
		}
		continue:isExit=1
		s desc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",desc,langid)
		d output1
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output1
	Set Data=$lb(id,desc,otherName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryChemoDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChemoDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryChemoDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChemoDepExecute ]
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
/// DATE: 2021-03-11
/// DESC: 化疗其余科室
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","QryChemoOtherDep","")
Query QryChemoOtherDep(InDesc = "") As %Query(ROWSPEC = "id,desc,otherName")
{
}

ClassMethod QryChemoOtherDepExecute(ByRef qHandle As %Binary, InDesc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i InDesc="" {
	 	//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK
	}
	s langid=..%LanguageID()
	s InDesc=$zcvt(InDesc,"U")
	s id=0
	f  s id=$o(^CTLOC(id)) q:id=""  d
	.s desc=$p(^CTLOC(id),"^",2)
	.s otherName=$p(^CTLOC(id),"^",43)
	.i desc["-" s desc=$p(desc,"-",2)
	.s otherName=$zcvt(otherName,"U")
	.s descUpper=$zcvt(desc,"U")
	.s isExit=1
	.i InDesc'="" d
	..i otherName[InDesc s isExit=0
	..i descUpper[InDesc s isExit=0
	.e  d
	..s isExit=0
	.q:isExit=1
	.d output2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output2
	s desc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",desc,langid)
	Set Data=$lb(id,desc,otherName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryChemoOtherDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryChemoOtherDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryChemoOtherDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryChemoOtherDepExecute ]
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
/// DATE: 2021-03-16
/// DESC: 查询卡类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","QryCardType")
Query QryCardType() As %Query(ROWSPEC = "id,desc,minfo")
{
}

ClassMethod QryCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id="2",desc="就诊卡" d output3
 	s id="3",desc="医保卡" d output3
 	s id="4",desc="工行银医卡" d output3
 	s id="5",desc="健康卡" d output3
 	s id="6",desc="建行银医卡" d output3
 	s id="7",desc="中行银医卡" d output3
 	s id="8",desc="交行银医卡" d output3
 	s id="9",desc="工行绑定卡" d output3
 	s id="10",desc="建行绑定卡" d output3
 	s id="11",desc="中行绑定卡" d output3
 	s id="12",desc="交行绑定卡" d output3
 	s id="13",desc="二代身份证" d output3
 	s id="14",desc="就医凭证" d output3
 	s id="15",desc="农行银医卡" d output3
 	s id="16",desc="农行绑定卡" d output3
 	s id="17",desc="农行卡" d output3
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output3
	Set Data=$lb(id,desc,minfo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCardTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCardTypeExecute ]
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
/// DATE: 2021-05-08
/// DESC: 查询有效的化疗方案
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","ChemoPlanQry","15")
Query ChemoPlanQry(PatientID = "", InHosp = "") As %Query(ROWSPEC = "id,PLName,LocName,DocName")
{
}

ClassMethod ChemoPlanQryExecute(ByRef qHandle As %Binary, PatientID = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	i PatientID="" {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s langid=..%LanguageID()
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanI("ChemoPlan","PatientDR",PatientID,id)) q:id=""  d
	.s status=$p(^BS.DOC.Chemo.PlanD(id),"^",7)
	.q:status'="Y"
	.s PLName=$p(^BS.DOC.Chemo.PlanD(id),"^",2)
	.s PLName=##class(User.ChemoTemplate).GetTranByDesc("TPName",PLName,langid)
	.s Loc=$p(^BS.DOC.Chemo.PlanD(id),"^",4)
	.s Doc=$p(^BS.DOC.Chemo.PlanD(id),"^",5)
	.s HospDr=""
	.s:Loc'="" HospDr=$p(^CTLOC(Loc),"^",22)
	.q:(HospDr'=InHosp)&&(InHosp'="")
	.s LocName=$p(^CTLOC(Loc),"^",2)
	.s DocName=$p(^SSU("SSUSR",Doc),"^",2)
	.s AddDate=$p(^BS.DOC.Chemo.PlanD(id),"^",10)
	.s AddTime=$p(^BS.DOC.Chemo.PlanD(id),"^",11)
	.d output4
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output4
	Set Data=$lb(id,PLName,LocName,DocName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod ChemoPlanQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChemoPlanQryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ChemoPlanQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChemoPlanQryExecute ]
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
/// DATE: 2022-03-18
/// DESC: 化疗预约数量查询
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","AppointNum","2022-03-18","2022-03-18")
Query AppointNum(StartDate = "", EndDate = "", IsCount = "", InHosp = "") As %Query(ROWSPEC = "id,ShowDate,AMCount,PMCount,IsTotalRow")
{
}

ClassMethod AppointNumExecute(ByRef qHandle As %Binary, StartDate = "", EndDate = "", IsCount = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (StartDate="")||(EndDate="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 	
	}
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s IsTotalRow=0
	s AMCountTotal=0,PMCountTotal=0
	f CDate=StartDate:1:EndDate {
		s BType=""
		s AMCount=0,PMCount=0
		s ShowDate=##class(websys.Conversions).DateLogicalToHtml(CDate)
		for {
			s BType=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,CDate,BType))	
			Q:BType=""
			s id=""
			for {
				s id=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,CDate,BType,id))	
				Q:id=""
				s PatientID=$p(^BS.DOC.Chemo.BedD(id),"^",2)
				continue:PatientID=""
				s BAdmLoc=""
				s PlanDR=$P(^BS.DOC.Chemo.BedD(id),"^",10)
				i PlanDR'="" s BAdmLoc=$p(^BS.DOC.Chemo.PlanD(PlanDR),"^",4)
				continue:BAdmLoc=""
				i BType="P" s PMCount=PMCount+1
				e  s AMCount=AMCount+1
			}
		}
		s AMCountTotal=AMCountTotal+AMCount
		s PMCountTotal=PMCountTotal+PMCount
		d output11
	}
 	i IsCount=1 {
	 	s IsTotalRow=1
	 	s ShowDate="<b>"_##class(websys.Translation).Get("chemo.bs.bed.find.csp","合计")_"</b>"
	 	s AMCount=AMCountTotal
	 	s PMCount=PMCountTotal
	 	s id=""
	 	d output11
	}
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output11
	Set Data=$lb(id,ShowDate,AMCount,PMCount,IsTotalRow)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod AppointNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AppointNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AppointNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AppointNumExecute ]
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
/// DATE: 2022-03-18
/// DESC: 化疗预约数量科室分布
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Bed.Manage","LocAppointNum","2022-07-05",2)
Query LocAppointNum(InDate = "", InHosp = "", StartDate = "", EndDate = "") As %Query(ROWSPEC = "BAdmLoc,BAdmLocDesc,AMCount,PMCount,ShowDate")
{
}

ClassMethod LocAppointNumExecute(ByRef qHandle As %Binary, InDate = "", InHosp = "", StartDate = "", EndDate = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	if (InDate="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 	
	}
	;参数初始化
	i InDate="total" {
		s StartDate=..%ZDH(StartDate)
		s EndDate=..%ZDH(EndDate)
	} else {
		s InDate=..%ZDH(InDate)
		s StartDate=InDate
		s EndDate=InDate
	}
	;组织TList
	s langid=..%LanguageID()
	k TList
	for CDate=StartDate:1:EndDate {
		s BType=""
		for {
			s BType=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,CDate,BType))	
			Q:BType=""
			s id=""
			for {
				s id=$o(^BS.DOC.Chemo.BedI("HospChemoDateBType",InHosp,CDate,BType,id))	
				Q:id=""
				s PatientID=$p(^BS.DOC.Chemo.BedD(id),"^",2)
				continue:PatientID=""
				s BAdmLoc=$p(^BS.DOC.Chemo.BedD(id),"^",8)
				s PlanDR=$P(^BS.DOC.Chemo.BedD(id),"^",10)
				i PlanDR'="" s BAdmLoc=$p(^BS.DOC.Chemo.PlanD(PlanDR),"^",4)
				continue:BAdmLoc=""
				i BAdmLoc="" s BAdmLoc="999999"
				i '$d(TList(CDate,BAdmLoc,BType)) s TList(CDate,BAdmLoc,BType)=1
				e  s TList(CDate,BAdmLoc,BType)=TList(CDate,BAdmLoc,BType)+1
			}
		}
	
	}
	;循环输出
	s CDate=""
	for {
		s CDate=$O(TList(CDate))
		Q:CDate=""
		s ShowDate=..%ZD(CDate)
		s BAdmLoc=""
		for {
			s BAdmLoc=$O(TList(CDate,BAdmLoc))
			Q:BAdmLoc=""
			i BAdmLoc="999999" {
				s BAdmLocDesc=##class(websys.Translation).Get("chemo.bs.bed.find.csp","未分配科室")
			} else {
				s BAdmLocDesc=$p(^CTLOC(BAdmLoc),"^",2)
				s BAdmLocDesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",BAdmLocDesc,langid)
			}
			s PMCount=0,AMCount=0
			i $d(TList(CDate,BAdmLoc,"A")) s AMCount=TList(CDate,BAdmLoc,"A")
			i $d(TList(CDate,BAdmLoc,"P")) s PMCount=TList(CDate,BAdmLoc,"P")
			d output12
		}
		
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output12
	Set Data=$lb(BAdmLoc,BAdmLocDesc,AMCount,PMCount,ShowDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod LocAppointNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocAppointNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LocAppointNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocAppointNumExecute ]
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

}
