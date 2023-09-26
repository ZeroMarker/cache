Class web.DHCDoc.OP.AjaxInterface Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Extends %CSP.Page
/// 请求示例链接
/// http://127.0.0.1/dthealth/web/web.DHCDoc.OP.AjaxInterface?OutputType=Stream&Class=web.DHCDoc.OP.AjaxInterface&Method=GetOPDocProBarJsonData&p1=1&p2=2&p3=3&p4=&p5=&p6=
ClassMethod OnPage() As %Status
{
	/*
	s class = $Get(%request.Data("Class",1),"")
	s method = $Get(%request.Data("Method",1),"")
	s outputType = $Get(%request.Data("OutputType",1),"")
	s param = ""
	s name = "P0"
	for
	{
		s name = $Order(%request.Data(name))
		q:(name = "")
		s:(param '= "") param = param_","
		s param = param_""""_$Get(%request.Data(name,1),"")_""""
	}
	s execCode = "result=##class("_class_")."_method_"("_param_")"
	s @execCode
	s result = @"result" 
	if (outputType = "Stream")
	{
		while (result.AtEnd = 0)
		{
			w $ZSTRIP(result.Read(32000),"*C")
		}
	}
	else
	{
		w $ZSTRIP(result,"*C")
	}
	Quit $$$OK
	*/
	s action = $Get(%request.Data("action",1),"")
	if (action = "GetOPDocProBarJsonData")
	{
  		w ..GetOPDocProBarJsonData()
	}
	Quit $$$OK
}

/// creator:宋春莉
/// date:2016-07-09
/// desc:返回门诊接诊流程图json数据 
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetOPDocProBarJsonData()     
ClassMethod GetOPDocProBarJsonData() As %String
{
	//TODO
	//测试数据
	//s json="[{""id"":""WhiteEMR"",""Name"":""写病历"",""click"":""WhiteEMROnClick"",""link"":""""},{""id"":""InsertDiag"",""Name"":""下诊断"",""click"":""InsertDiagOnClick"",""link"":""diagnosentry.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""InsertOrder"",""Name"":""开医嘱"",""click"":""InsertOrderOnClick"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""PrintAll"",""Name"":""打印&申请单"",""click"":""PrintAllOnClick"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""},{""id"":""CompleteAdm"",""Name"":""完成接诊"",""click"":""CompleteRecAdm"",""link"":""oeorder.oplistcustom.new.csp?PatientID=@patientID&EpisodeID=@episodeID""}]"
	//q json
	s DisplayNum=0,ret=""
	f  s DisplayNum=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum)) q:DisplayNum=""  d
	.s ID=0
	.f  s ID=$o(^User.DocCFStreamlineInfoI("DisplayNum",DisplayNum,ID)) q:ID=""  d
	..s id=$list(^User.DocCFStreamlineInfoD(ID),8)
	..s Name=$list(^User.DocCFStreamlineInfoD(ID),9)
	..s click=$list(^User.DocCFStreamlineInfoD(ID),10)
	..s link=$list(^User.DocCFStreamlineInfoD(ID),3)
	..s oneret=""""_"id"_""":"""_##class(web.DHCDocUtil).EvalJSON(id)_""""
	..s oneret=oneret_","_""""_"Name"_""":"""_##class(web.DHCDocUtil).EvalJSON(Name)_""""
	..s oneret=oneret_","_""""_"click"_""":"""_##class(web.DHCDocUtil).EvalJSON(click)_""""
	..s oneret=oneret_","_""""_"link"_""":"""_##class(web.DHCDocUtil).EvalJSON(link)_""""
	..s oneret="{"_oneret_"}"
	..i ret="" d
	...s ret="["_oneret
	..else  d
	...s ret=ret_","_oneret
	q ret_"]"
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:返回门急诊患者信息
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetOPInfoBar()     
ClassMethod GetOPInfoBar(EpisodeID As %String, CONTEXT As %String, PatientID As %String = "", HospId As %String = "") As %String
{
	n (EpisodeID,CONTEXT,PatientID,HospId,%session,%request)
	s SessionStr=..%SessionStr()
	i $g(HospId)="" s HospId=$P(SessionStr,"^",4)
	s UserID=$P(SessionStr,"^",1)
	//blue：炫彩 lite：极简
	s HISUIStyleCode=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")
	i HISUIStyleCode="" s HISUIStyleCode="blue"
	s PatInfoBarStr=""
	if (EpisodeID'=""){
		s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
		if PAAdmType="E" {
			;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	 		s StayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
		}
		if PAAdmType="H" s PAAdmType="O" //体检患者按照门诊患者显示
		s PatientID=$p(^PAADM(EpisodeID),"^",1),mradm=$p(^PAADM(EpisodeID),"^",61)
	}else{
		s PAAdmType="O"
		s mradm=""
	}
	s DisplayNum=0
	for{
		s DisplayNum=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum))
		q:DisplayNum=""
		s ID=0
		for{
			s ID=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum,ID))
			q:ID=""
			s Active=$list(^User.DocCFPatientInfoD(ID),10)
			continue:Active'="1"
			s HospDr=$lg(^User.DocCFPatientInfoD(ID),12)
			continue:HospDr'=HospId
			s paraAdmType=$list(^User.DocCFPatientInfoD(ID),11)
			i PAAdmType="H" s PAAdmType="O"
			continue:((PAAdmType="O")||(PAAdmType="I"))&&(PAAdmType'=paraAdmType)
			continue:(PAAdmType="E")&&(" 1 2 "[(" "_StayStatusFlag_" "))&&(paraAdmType'="IE")
			continue:(PAAdmType="E")&&(" 1 2 "'[(" "_StayStatusFlag_" "))&&(paraAdmType'="OE")
			s id=$list(^User.DocCFPatientInfoD(ID),3)
			s Name=$list(^User.DocCFPatientInfoD(ID),2)
			s style=$list(^User.DocCFPatientInfoD(ID),6)
			s Expression=$list(^User.DocCFPatientInfoD(ID),5)
			s Expression=$tr(Expression,"&","""")
			s Expression="s result="_Expression
			X Expression
			continue:(EpisodeID="")&&(result="") //就诊为空 结果为空 不显示
			s iconHTML=""
			s LinkUrl=$list($g(^User.DocCFPatientInfoD(ID)),7)
			s LinkUrl=..replaceLinkParams(LinkUrl,EpisodeID,PatientID,mradm)
			i LinkUrl'="" {
				s iconHTML="<A HREF=""#"" id='"_id_"' onClick=""websys_lu('"_LinkUrl_"',false,'top=40,left=40');"">"_result_"</A>"
			}else{
				s Name=##class(websys.Translation).Get("ipdoc.patinfoview.csp",Name)
				i Name'="" s Name=Name_":" 
				s iconHTML="<div style='"_style_";display:inline-block;'>"
				if (Name'="") {
					s iconHTML=iconHTML_"<lable>"_Name_"</lable>"
				}
				s iconHTML=iconHTML_""_result_""
				s iconHTML=iconHTML_"</div>"

				#; if (Name'="") {
				#; 	s iconHTML="<span style='color:#666;margin-left:5px;'>"_Name_"</span>"
				#; }
				#; s iconHTML=iconHTML_"<span style='"_style_"'>"_result_"</span>"
				#; if (Name'="") {
				#; 	s iconHTML=iconHTML_"<span style='color:#bbb;'>/</span>"
				#; }
				
			}
			if (PatInfoBarStr'=""){
				s iconHTML="<div style='color:#bbb;display:inline-block;'>/</div>"_iconHTML
			}
			i PatInfoBarStr="" s PatInfoBarStr=iconHTML
			e  s PatInfoBarStr=PatInfoBarStr_" "_iconHTML
		}
	}
	s sex=##class(web.DHCDoc.OP.AjaxInterface).GetPatSex(PatientID)
	s imgName=$CASE(sex,"女":"woman","男":"man",:"unman") 
	if (HISUIStyleCode="lite"){
		s imgName=imgName_"_lite"
	}
	w "<div style='background:url(../images/"_imgName_".png) no-repeat;background-size:cover;position: absolute;left:10px;top:5px;width:30px;height:30px;border-radius:30px;border:none;' ></div>"
	q PatInfoBarStr
}

/*
<div class="PatImage man" src="../scripts/dhcdoc/image/icon-big-woman.png"></div>
*/
ClassMethod replaceLinkParams(lnk As %String, EpisodeID As %String, PatientID As %String, mradm As %String)
{
	s ret = $replace(lnk,"@patientID",PatientID)
	s ret = $replace(ret,"@episodeID",EpisodeID) 
	s ret = $replace(ret,"@mradm",mradm) 
	Q ret
}

ClassMethod GetMRAdmDiagnosis(EpisodeID As %String) As %String
{
	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID)
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者出生日期 
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatDob()     
ClassMethod GetPatDob(PatientID As %String)
{
	s PatDob=$p(^PAPER(PatientID,"ALL"),"^",6)
	Q:PatDob="" ""
	Q ..%ZD(PatDob) //$zd(PatDob,3)
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取就诊费别
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason()     
ClassMethod GetAdmReason(EpisodeID As %String)
{
	n (EpisodeID,%session)
	Q:EpisodeID="" ""
	Set langid=..%LanguageID()
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	Q:PAADMAdmReasonDR="" ""
	s AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,langid)
	Q AdmReason
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者性别
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatSex()     
ClassMethod GetPatSex(PatientID As %String) As %String
{
	n (PatientID,%session)
	s PatSex=""
	Set langid=..%LanguageID()
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") {
		s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
		;s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
	}
	Q PatSex
}

ClassMethod GetPatSexByAdm(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	Q:PatientID="" ""
	s PatSex=""
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	Q PatSex
}

/// 获取床号
ClassMethod GetPatBedNo(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s bedno=""
	/// 护士站 -转移记录中增加床位号字段---用于取值 2018-8-1
	/*if ..%IsValidMethod("Nur.Interface.OutSide.Patient","getPatientLastBedCode"),##class(%Dictionary.CompiledProperty).%ExistsId("User.PAAdmTransaction||TRANSBedCode"){
		Set bedno = ##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)
	}
	if (bedno=""){
		s beddr=""
		s:$d(^PAADM(EpisodeID)) beddr = $p(^PAADM(EpisodeID),"^",73)
		s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
	}*/
	s beddr = ##class(Nur.Interface.OutSide.Patient).GetBedId(EpisodeID)
	s:+beddr>0 bedno=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
	Q bedno
}

/// 获取住院患者住院天数
ClassMethod GetInPatAdmDays(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s admInfo=##class(web.DHCBillInterface).IGetAdmInOutDatebyEpisodeID(EpisodeID)
	//##Class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(EpisodeID) 
	//s ipDays=$p(admInfo,"^",12)
	s ipDays=$p(admInfo,"^",3)
	Q ipDays
}

/// 获取就诊天数
ClassMethod GetPatAdmDays(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s ipdate = $p(^PAADM(EpisodeID),"^",6)
	if ipdate'="" {
		Set ipDays = +$h-ipdate
		set ipdate=$zd(ipdate,3)
		set baseInfoAdmDays=ipDays
		if (baseInfoAdmDays=0) set baseInfoAdmDays=1
	}
	Q baseInfoAdmDays
}

/// creator:宋春莉
/// date:2016-07-18
/// desc:获取患者卡号
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatCardNo()  
ClassMethod GetPatCardNo(PatientID As %String) As %String
{
	s CFRowID=0,CardNo=""
	f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID)) q:(CFRowID="")||(CardNo'="")  d
	.s CFActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
	.Q:CFActiveFlag'="N"
	.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
	Q CardNo
}

/// creator:谭吉善
/// date:2020-01-07
/// desc:获取患者入院时间
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPAAdmDate()  
ClassMethod GetPAAdmDate(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s AdmDate = $p(^PAADM(EpisodeID),"^",6)
	//s AdmTime = $p(^PAADM(EpisodeID),"^",7)
	if AdmDate'="" {
		s AdmDate=..%ZD(AdmDate)
	}
	Q AdmDate
}

ClassMethod test() As %String
{
	//s aCmdValue="ChildSub=$O(^DHCDocEntryTree("""_RootNodeId_""",""""),-1)"
	//s @aCmdValue
	X "s PatName=$p(^PAPER(189,"_"""ALL""),"_"""^"",7)"
	q PatName
}

/// creator:宋春莉
/// date:2016-08-02
/// desc:根据本次就诊获取最近四次就诊信息
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","GetPatAdmList","189")
Query GetPatAdmList(EpisodeID As %String = "", Limit As %String = "5") As %Query(ROWSPEC = "MainDiagnos:%String,AdmDate:%String,AdmLoc:%String,AdmDoc:%String,AdmRowId:%String")
{
}

ClassMethod GetPatAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod GetPatAdmListExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", Limit As %String = "5") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","GetPatAdmList","189")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if EpisodeID="" {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s Num=0
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PAADMTypeStr="O^E"
	for i=1:1:$l(PAADMTypeStr,"^") d
	.Q:(Num>=Limit)&&(Limit'="")
	.s PAADMType=$p(PAADMTypeStr,"^",i)
	.s AdmRowId=EpisodeID
	.f  s AdmRowId=$o(^PAPERdr(PatientID,"ADM",PAADMType,AdmRowId),-1) q:(AdmRowId="")||((Num>=Limit)&&(Limit'=""))  d
	..s PAADMMainMRADMDR=$p($g(^PAADM(AdmRowId)),"^",61)
	..s MRDIAChildsub=0,MainDiagnos=""
	..f  s MRDIAChildsub=$o(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)) q:(MRDIAChildsub="")||(MainDiagnos'="")||((Num>=Limit)&&(Limit'=""))  d 
	...s MainDiagFlag=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub,1)),"^",20)
	...i MainDiagFlag="Y" d
	....s MRDIAICDCodeDR=$p($g(^MR(PAADMMainMRADMDR,"DIA",MRDIAChildsub)),"^",1)
	....i MRDIAICDCodeDR'="" s MainDiagnos=$p(^MRC("ID",MRDIAICDCodeDR),"^",2)
	....e  s MainDiagnos=$g(^MR(PAADMMainMRADMDR,"DIA",MRDIAICDCodeDR,"DES",1))
	..s AdmDate=$zd($p($g(^PAADM(AdmRowId)),"^",6),3)
	..s AdmLocDr=$p($g(^PAADM(AdmRowId)),"^",4)
	..s AdmLoc=$p(^CTLOC(AdmLocDr),"^",2)
	..s AdmLocDesc=$p(AdmLoc,"-",2)
	..i AdmLocDesc'="" s AdmLoc=AdmLocDesc
	..s AdmDoc=""
	..s PAAdmDocCodeDR=$P($g(^PAADM(AdmRowId)),"^",9)
	..i PAAdmDocCodeDR'="" s AdmDoc=$P($g(^CTPCP(PAAdmDocCodeDR,1)),"^",2)
	..s Num=Num+1
	..Q:(Num>=Limit)&&(Limit'="")
	..Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
     set Data=$lb(MainDiagnos,AdmDate,AdmLoc,AdmDoc,AdmRowId)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod GetPatAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatAdmListExecute ]
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

/// creator:宋春莉
/// date:2016-08-02
/// desc:有效卡列表
/// d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
Query ReadCardTypeList() As %Query(ROWSPEC = "CardTypeDesc:%String,CardTypeValue:%String,DefaultFlag:%String")
{
}

ClassMethod ReadCardTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod ReadCardTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDoc.OP.AjaxInterface","ReadCardTypeList")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s myTypeID=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDateFrom=+$p(^DHCCARDTYPEDef(myTypeID),"^", 9)		;CTD_DateFrom
	.q:((+myDateFrom'=0)&(myDateFrom>+$h))			;生效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" d
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
     s ^tmpscl("data12",ind)=myval
     set Data=$lb(mydes,myval,mySelFlag)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 quit
}

ClassMethod ReadCardTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReadCardTypeListExecute ]
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

/// creator:屈坚
/// date:2020-03-11
/// desc:获取患者职业
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatVocation()  
ClassMethod GetPatVocation(PatientID As %String) As %String
{
	q:PatientID="" ""
	s Vocation=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
	if (Vocation'="") s Vocation=$p(^CT("OCC", Vocation),"^",2)
	Q Vocation
}

/// creator:宋春莉
/// date:2021-02-07
/// desc:获取患者体重
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatWeight()  
ClassMethod GetPatWeight(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	//体重
    s Weight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight") 
    if (Weight=""){
		s Weight=$p($g(^MR(mradm,"PRO",1)),"^",27)
	}
	if (Weight'=""){
		s Weight=Weight_"<span style='color:#999999;'>Kg</span>"
	}else{
		s Weight="-"
	}

	Q Weight
}

/// creator:宋春莉
/// date:2021-02-07
/// desc:获取患者身高
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatHeight()  
ClassMethod GetPatHeight(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	//身高
    s Height=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height") 
    if (Height=""){
		s Height=$p($g(^MR(mradm,"PRO",1)),"^",20)
    }
	if (Height'=""){
		s Height=Height_"<span style='color:#999999;'>CM</span>"
	}else{
		s Height="-"
	}
    Q Height
}

/// creator:宋春莉
/// date:2021-02-07
/// desc:获取患者BMI
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatBMI()  
ClassMethod GetPatBMI(EpisodeID As %String) As %String
{
	//计算公式为：BMI=体重（千克）除以身高（米）的平方。
	s Weight=..GetPatWeight(EpisodeID)
	Q:+Weight=0 "-"
	s Height=..GetPatHeight(EpisodeID)
	Q:+Height=0 "-"
	s BMI=Weight/((Height/100)*(Height/100))
	s BMI=$fn(BMI,"",1)
	Q BMI
}

/// creator:宋春莉
/// date:2021-02-07
/// desc:获取患者BSA
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatBSA()  
ClassMethod GetPatBSA(EpisodeID As %String) As %String
{
	//许文生氏公式计算式:BSA = S（m2）=0.0061×身高（cm）+0.0128×体重（kg）-0.1529
	s Weight=..GetPatWeight(EpisodeID)
	Q:+Weight=0 "-"
	s Height=..GetPatHeight(EpisodeID)
	Q:+Height=0 "-"
	s BSA=(0.0061*Height)+(0.0128*Weight)-0.1529
	s BSA=$fn(BSA,"",2)_"m²"
	Q BSA
}

/// creator:李旭
/// date:2023-03-18
/// desc:获取患者就诊时的挂号优惠
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetRegConDisCount()  
ClassMethod GetRegConDisCount(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
    s langid=..%LanguageID()
	s RegConDis=""
    s RegConDisID=$p($g(^PAADM(EpisodeID,"DHC")),"^",25)
    if RegConDisID'=""{
        s RegConDis=$p($g(^DHCRCD(RegConDisID)),"^",2)
		s RegConDis=##class(User.DHCRegConDisCount).GetTranByDesc("RCDDesc",RegConDis,langid)
    }
    Q RegConDis
}

/// creator:李旭
/// date:2021-09-06
/// desc:展示按钮区域(暂时写死一个按钮，后继考虑配置)
/// w ##class(web.DHCDoc.OP.AjaxInterface).ShowButton()  
ClassMethod ShowButton(EpisodeID As %String) As %String
{
	s ParmStr="orgCode=szsrmyy&staffNo=a1n&staffName=张医生&idcard=441881199112279188&patientName=梁春燕&callSysCode=zhspt&requireAuth=0"
	;s Html="<a href=""#"" class=""hisui-linkbutton green"" onClick=""websys_emit('onOpenPatHealth','"_ParmStr_"');return websys_cancel();"">健康浏览器</a>"
	s Html="<a id=""PatHealthBrow"" href=""#"" onClick=""websys_emit('onOpenPatHealth','"_ParmStr_"');return websys_cancel();"">健康浏览器</a>"
	q Html
}

/// creator:王清雍
/// date:2023-02-24
/// desc:返回门急诊患者信息栏数据JSON,HTML在前端处理
/// w ##class(web.DHCDoc.OP.AjaxInterface).GetPatInfoBar()     
ClassMethod GetPatInfoBar(EpisodeID As %String, PatientID As %String = "", CONTEXT = "") As %String
{
	n (EpisodeID,PatientID,CONTEXT,%session)
	s langid=..%LanguageID()
	s retObj={"sexCode":"","rows":[]}
	s PAAdmType="O",mradm=""
	if EpisodeID'=""{
		s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
		s PatientID=$p(^PAADM(EpisodeID),"^",1)
		s PAAdmType=$p(^PAADM(EpisodeID),"^",2)
		s mradm=$p(^PAADM(EpisodeID),"^",61)
	}else{
		s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	}
	Q:PatientID="" retObj.%ToJSON()
	if PAAdmType="H" s PAAdmType="O"
	s StayStatusFlag=""
	if PAAdmType="E" {
		;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
		s StayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	}
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") {
		s retObj.sexCode=$p($g(^CT("SEX",PatSexDr)),"^",1)
	}
	s DisplayNum=0 for{
		s DisplayNum=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum)) Q:DisplayNum=""
		s ID=0 for{
			s ID=$o(^User.DocCFPatientInfoI("DisplayNum",DisplayNum,ID)) Q:ID=""
			s Active=$list(^User.DocCFPatientInfoD(ID),10)
			continue:Active'="1"
			s HospDr=$lg(^User.DocCFPatientInfoD(ID),12)
			continue:HospDr'=HospId
			s paraAdmType=$list(^User.DocCFPatientInfoD(ID),11)
			continue:((PAAdmType="O")||(PAAdmType="I"))&&(PAAdmType'=paraAdmType)
			continue:(PAAdmType="E")&&(" 1 2 "[(" "_StayStatusFlag_" "))&&(paraAdmType'="IE")
			continue:(PAAdmType="E")&&(" 1 2 "'[(" "_StayStatusFlag_" "))&&(paraAdmType'="OE")
			s Expression=$list(^User.DocCFPatientInfoD(ID),5)
			s Expression=$tr(Expression,"&","""")
			s Expression="s result="_Expression
			x Expression
			continue:result=""
			s obj={}
			s obj.id=$list(^User.DocCFPatientInfoD(ID),3)
			s obj.name=##class(User.DocCFPatientInfo).GetTranByDesc("DisplayItem",$list(^User.DocCFPatientInfoD(ID),2),langid)
			s obj.value=$ZCVT(result,"I","HTML")
			s obj.style=$list(^User.DocCFPatientInfoD(ID),6)
			s obj.linkUrl=..replaceLinkParams($list($g(^User.DocCFPatientInfoD(ID)),7),EpisodeID,PatientID,mradm)
			d retObj.rows.%Push(obj)
		}
	}
	Q retObj.%ToJSON()
}

}
