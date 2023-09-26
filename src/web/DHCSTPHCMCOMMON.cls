/// Creator: bianshuai
/// CreateDate: 2014-06-20
/// Descript: 公共类
Class web.DHCSTPHCMCOMMON Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存用户选择的科室列表
ClassMethod SaveAudPreLocGrp(useID, input) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","SaveAudPreLocGrp",useID)
	S Len=$L(input,"^")
	F i=1:1:Len d
	.S LocID=$p(input,"^",i)
	.S ^TMP("DHCST","web.DHCSTPHCMCOMMON","SaveAudPreLocGrp",useID,LocID)=""
	Q ""
}

/// Descript:判断科室和人员是否对应
ClassMethod CheckUseIDAndLocID(useID, LocID) As %String
{
	N (useID,LocID)
	Q $d(^TMP("DHCST","web.DHCSTPHCMCOMMON","SaveAudPreLocGrp",useID,LocID))
}

/// Descript:k掉临时global
ClassMethod killTempGlobal(useID) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","SaveAudPreLocGrp",useID)
	Q ""
}

/// Descript:获取科室组设置
ClassMethod getLocGrpMan(LocDr) As %String
{
	N (LocDr)
	S String=""
	S SLGID=""
	F  S SLGID=$o(^DHCSLG(0,"TypeLoc","G",LocDr,SLGID)) Q:SLGID=""  D //科室组
	.S LocGrpDesc=$p(^DHCSLG(SLGID),"^",2)
	.S Ch="" ,LocDescStr=""
	.F  S Ch=$o(^DHCSLG(SLGID,"I",Ch)) Q:Ch=""  D
	..S LocID=$p(^DHCSLG(SLGID,"I",Ch),"^",1)	/// 科室ID
	..S LocDesc=$p(^CTLOC(LocID),"^",2) 		/// 科室描述
	..S:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..If LocDescStr="" S LocDescStr=LocID_"^"_LocDesc
	..ELSE  S LocDescStr=LocDescStr_"||"_LocID_"^"_LocDesc
	.If String="" S String=LocGrpDesc_"&"_LocDescStr
	.ELSE  S String=String_"//"_LocGrpDesc_"&"_LocDescStr
	Q String
}

/// Descritp:科室信息
ClassMethod SelAllLoc(LocType As %String = "", HospID As %String = "", Input As %String = "") As %String
{
	N (LocType, HospID, Input,%session)
	s Input=$zcvt(Input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
	s:LocType'="" sqlStr=sqlStr_" where CTLOC_NationCode="_""""_LocType_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		continue:(HospID'="")&(HospID'=$p(^CTLOC(LocDr),"^",22))
		s LocDesc = result.Data("LocDesc")
		s LocCode=##class(web.DHCST.Common.AppCommon).GetCNCODE(LocDesc)
		continue:(LocDesc["停")||(LocDesc["工作量")
		continue:(Input'="")&&((LocDesc'[Input)&(LocCode'[Input))
		s LocDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLOC","CTLOCDESC","",LocDesc)
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:科室信息
ClassMethod SelAllPhLoc(HospID As %String) As %String
{
	N (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
	s sqlStr=sqlStr_" where CTLOC_Type="_""""_"D"_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		continue:(HospID'="")&(HospID'=$p(^CTLOC(LocDr),"^",22))
		s LocDesc = result.Data("LocDesc")
		continue:(LocDesc["停")||(LocDesc["工作量")||(LocDesc'["药房")||(LocDesc["草")
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// description: 安全组能访问的科室
/// Table:SS_GroupStockLocations
ClassMethod QueryGroupLoc(GroupId As %String) As %String
{
    n (GroupId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT ST_CTLOC_DR AS LocDr,ST_CTLOC_DR->CTLOC_Code AS LocCode,ST_CTLOC_DR->CTLOC_DESC AS LocDesc FROM SS_GroupStockLocations"_
    " WHERE ST_ParRef='"_GroupId_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		s LocDesc = result.Data("LocDesc")
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:按照安全组查询对应组内人员
/// d ##class(web.DHCSTPHCMCOMMON).SelUserByGrp("177")
ClassMethod SelUserByGrp(grpId As %String) As %String
{
	n (grpId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSUSR_RowId,SSUSR_Name FROM SS_USER WHERE SSUSR_Group="_grpId
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s UserId = result.Data("SSUSR_RowId")
		s UserName = result.Data("SSUSR_Name")
		s tmp=UserId_"^"_UserName
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:按照安全组查询对应组内人员
ClassMethod GetDeptUser(LocID As %String) As %String
{
	n (LocID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSUSR_RowId as RowId,SSUSR_Name as Name FROM SS_USER WHERE SSUSR_DefaultDept_DR="_LocID
    s sqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where othll_ctloc_dr="_LocID
    s sqlStr =sqlStr_" union "_sqlStr1 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s UserId = result.Data("RowId")
		s UserName = result.Data("Name")
		s tmp=UserId_"^"_UserName
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Creator: qunianpeng 
/// CreateDate: 2016-01-05
/// Descritp:取某安全组下的所有人包括是默认登录安全组或者其他登录安全组
/// w ##class(web.DHCSTPHCMCOMMON).GetGroupUser("198")
ClassMethod GetGroupUser(grpId As %String) As %String
{
	n (grpId,%session)
	s dateNow=$p($h,",",1)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSUSR_RowId as RowId,SSUSR_Name as Name FROM SS_USER WHERE SSUSR_Group="_grpId
    s sqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where OTHLL_UserGroup_DR="_grpId
    s sqlStr=sqlStr_"and SSUSR_Active='Y'"
    s sqlStr =sqlStr_" union "_sqlStr1 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s UserId = result.Data("RowId")
		s dataTo=$p(^SSU("SSUSR",UserId),"^",97)    //hezg 2018-7-16
		i dataTo'="" q:dataTo<dateNow
		s UserName = result.Data("Name")
		s UserName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",UserName)
		s tmp=UserId_"^"_UserName
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript;临床路径字段
ClassMethod ClinPathWayDic() As %String
{
	S CPWDID=0,count = 0
	W "["
	F  S CPWDID=$o(^DHCMRC("CPWD",CPWDID)) Q:CPWDID=""  d
	.S objCPWD=..GetObjById(CPWDID)
	.If $IsObject(objCPWD) d
	..S Code=objCPWD.CPWDCode
	..S Desc=objCPWD.CPWDDesc
	..S (TypeID,TypeDesc)=""
	..If $IsObject(objCPWD.CPWDCPWTypeDR) d
	...//S TypeID=objCPWD.CPWDCPWTypeDR.%Id()
	...Q:objCPWD.CPWDCPWTypeDR.CLPTCode="SYNDROME"  //科室临床路径维护模块，过滤并发症
	...//S TypeDesc=objCPWD.CPWDCPWTypeDR.CLPTDesc
	..S Active=$s(objCPWD.CPWDActive["Y":"Yes",1:"No")
	..Q:(Active'["Y")
	..s tmp=CPWDID_"^"_Code_"^"_Desc
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^code^text",tmp)
	..e  d
	...W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^code^text",tmp)
	..
	W "]"
	Q ""
}

/// Creator：     zhufei
/// CreatDate：   2010-10-29
/// Description:  根据ID取临床路径字典
/// Table：       User.DHCMRCClinPathWaysDic
/// Input：       ID:    User.DHCMRCClinPathWaysDic.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCClinPathWaysDic
{
	New (argId)
	Set return=##Class(User.DHCMRCClinPathWaysDic).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator:bianshuai
/// CreateDate:2014-08-24
/// Descritp:显示主题
ClassMethod SelAllTheme() As %String
{
	//N (ThType)  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHC_PHFunTheme Where PHTHE_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s Code = result.Data("PHTHE_Code")
		s Desc = result.Data("PHTHE_Desc")
		s tmp=Code_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// Descritp:病区列表
ClassMethod SelAllWard() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT Ward_Rowid As WardID,Ward_Desc As WardDesc FROM PAC_WARD"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s WardDr = result.Data("WardID")
		s WardDesc = result.Data("WardDesc")
		continue:(WardDesc["停")||(WardDesc["工作量")
		s tmp=WardDr_"^"_WardDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	N (Title,DataList,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)		//列
	S DLen=$L(DataList,Deli)	//值
	F i=1:1:HLen  d
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.S Value=$tr(Value,$c(10))   ;替换换行符
	.S Value=$tr(Value,$c(13))	;替换回车符
	.S Value=$tr(Value,del)	;替换双引号
	.S Value=$Replace(Value,"\","\\")
	.;S:Value'["\'" Value=$Replace(Value,"'","\'")
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Descript:返回Json串起始符
ClassMethod getJsonStartSign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":["
}

/// Descript:返回Json串结束符
ClassMethod getJsonEndSign() As %String
{
	q "]}"
}

/// Descript:返回Json空串符
ClassMethod getJsonEmptySign(Count) As %String
{
	N (Count)
	S del=""""
	q "{"_del_"total"_del_":"_Count_","_del_"rows"_del_":[]}"
}

/// Descript:获取病人基本信息
/// w ##class(web.DHCSTPHCMCOMMON).GetPatInfo(970)
ClassMethod GetPatInfo(AdmDr As %String) As %String
{
	N (AdmDr,%session)
	S papmi=$p(^PAADM(AdmDr),"^",1)
	S PatName=$p(^PAPER(papmi,"ALL"),"^",1) 		/// 姓名
	S PatNo=$p(^PAPER(papmi,"PAT",1),"^",1) 		/// 登记号
	
	S SexId=$p(^PAPER(papmi,"ALL"),"^",7 )  		/// 姓别
	S PatSex=$p(^CT("SEX",SexId),"^",2)
	S PatAge=##class(PHA.FACE.IN.Com).GetAge(papmi,AdmDr)  /// 年龄
	S nationdr=$p(^PAPER(papmi,"PER",1),"^",2)      /// 民族
	S nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	S patW=""
	S patTel=$p(^PAPER(papmi,"PER",1),"^",11)   	//sufan 2016/09/14
	S address=$g(^PAPER(papmi,"PER","ADD",1))		//sufan 2016/09/14
	S PayType=..PayType(AdmDr) 						/// 费别
	S PatBedNo=..getBed(AdmDr) 						/// 床号
	s AdmType=$p($g(^PAADM(+AdmDr)),"^",2)
	s MedicalNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(AdmDr,AdmType) //lbb 2020.5.29 修改病案号取统一接口
	S AdmDate=$p(^PAADM(AdmDr),"^",6) //入院日期
	S:AdmDate'="" AdmDate=..DateLogicalToHtml(AdmDate)  ;$zd(AdmDate,3)
	S MainDiag=..GetMRDiagnosByEpisodeID(AdmDr)  	//入院诊断    //sufan 2016/09/13
	S OutPDiag=..GetOutPDiagnosByEpisodeID(AdmDr)   //出院诊断   //sufan 2016/09/14
	s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
	s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s PayType=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACAdmReason","READesc","",PayType)
	s MainDiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",MainDiag)
	s OutPDiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",OutPDiag)
	s nation=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTNation","CTNATDesc","",nation)
	s address=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPerson","PAPERStName","",address)
	Q PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatBedNo_"^"_MedicalNo_"^"_PayType_"^"_AdmDate_"^"_MainDiag_"^"_OutPDiag_"^"_papmi_"^"_nationdr_"^"_nation_"^"_patW_"^"_patTel_"^"_address
}

/// Descript:	病人费用类型
ClassMethod PayType(AdmDr As %String) As %String
{
	N (AdmDr)
	Q:AdmDr="" ""
	S PayTypeDR=$p($g(^PAADM(AdmDr,1)),"^",7)
	Q:(PayTypeDR="") ""
	S PayType=$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	Q PayType
}

/// Descript:	获取床号病人
ClassMethod getBed(AdmDr As %String) As %String
{
	N (AdmDr)
	S BedDr=$p($g(^PAADM(AdmDr)),"^",73) //床号
	S BedWDr=+$p(BedDr,"||",1)
	S BedCh=+$p(BedDr,"||",2)
    Q:($d(^PAWARD(BedWDr,"BED"))'=10) ""
	S BedNo = $p($g(^PAWARD(BedWDr,"BED",BedCh)),"^",1)
	Q BedNo
}

/// Descript:获取病人最后一次就诊ID
ClassMethod getLastAdmIDByPatNo(InPatNo As %String) As %String
{
	N (InPatNo)
	Q:InPatNo="" ""
	///取最近一次就诊记录
	S papmi=$o(^PAPERi("PAPMI_PatNo",InPatNo,""))
	Q:papmi="" ""
	S AdmDr=$o(^PAPERdr(papmi,"ADM","I",""),-1)
	Q:AdmDr="" ""
	Q AdmDr
}

/// Descript:获取病人登记号
ClassMethod getPatNoByAdm(AdmDr As %String) As %String
{
	N (AdmDr)
	Q:AdmDr="" ""
	S Papmi=$p(^PAADM(AdmDr),"^",1)
	S PatName=$p(^PAPER(Papmi,"ALL"),"^",1) //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1) //登记号
	Q PatNo
}

/// Descript: 取具体监测项目
ClassMethod SelMonItemByTheme(Theme As %String) As %String
{
	N (Theme,%session)
	S ThemeID=$o(^DHCPHFUTHE(0,"Code",Theme,""))
	i ThemeID="" w "[]"
	Q:ThemeID="" ""
	s count = 0
	w "["
	S ch=""
	F  S ch=$o(^DHCPHFUTHE(ThemeID,"I",ch)) Q:ch=""  D
	.S code=$p(^DHCPHFUTHE(ThemeID,"I",ch),"^",1) //项目代码
	.S desc=$p(^DHCPHFUTHE(ThemeID,"I",ch),"^",2) //项目名称
	.s desc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHFunTheItem","PHTHEIDesc","",desc) 
	.S tmp=ThemeID_"||"_ch_"^"_desc
	.S count = count+1
	.I count=1 d
	..W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	w "]"
}

/// Descript:获取病人医嘱信息
/// W ##class(web.DHCSTPHCMCOMMON).GetPatOrdItmInfo("2","1","17240458","TMD")
ClassMethod GetPatOrdItmInfo(rows As %String, page As %String, AdmDr As %String, priCode As %String, AppType As %String) As %String
{
	N (rows,page,AdmDr,priCode,AppType)
	Q:AdmDr="" "-1"
	S EndPage=page*rows				/// 结束行
	S StPage=((page-1)*rows)+1		/// 开始行
	S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.S orditm=ord_"||"_chl
	.S priDr=+$p($g(^OEORD(ord,"I",chl,1)),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1)	/// 医嘱优先级代码              
    .//Q:priorty["OM"					/// 自备药
    .Q:(priCode'="")&(priCode'=priorty)
    .S priorty=$p(^OECPR(priDr),"^",2)  /// 医嘱优先级
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.//Q:(OeFlag'="V")&(OeFlag'="E")
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12)	/// 滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(OeFlag'="D")  		  		/// 长嘱非首日和截止日期的记录过滤
    .q:(##Class(web.DHCSTPCHCOLLS).IfAuditByPriority(ord,chl,priDr))&(priorty'="S")&(OeFlag'="D")
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)		/// 医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
    .///按照应用程序代码过滤
	.//S funLibTheItmList=##class(web.DHCSTPHCMCOMMON).getFunLibTheItmList(AppType)
	.//Q:'..ChkExItm(orditm,funLibTheItmList)
	.Q:'..CheckItmIfExist(AppType,orditm)
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  									/// 医嘱名称
	.S inciDesc=$p(^INCI(inci,1),"^",2)            	/// 药品名称
	.;S dosage=$p(^OEORD(ord,"I",chl,2),"^",1)      	/// 剂量
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/6/28 同频次不同剂量,剂量串
	.S dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   	/// 剂量单位
	.;S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  /// OEORI_PHFreq_DR
    .;S freq=$p($g(^PHCFR(freqdr)),"^",3)            /// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .S instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2)        /// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
	.S doctorID=$p($g(^OEORD(ord,"I",chl,7)),"^",1) /// 医生ID
	.S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     /// 停止日期
	.S:EndDate'="" EndDate=..DateLogicalToHtml(EndDate) ;$zd(EndDate,3)
	.i FillerNo'="" d
	..S orditm=$p(FillerNo,"!!",1)
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  /// 开始日期
	.S:StartDate'="" StartDate=..DateLogicalToHtml(StartDate) ;$zd(StartDate,3)
	.s StartTime=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",10) /// 开始时间
	.s:StartTime'="" StartTime=$zt(StartTime,2)
	.s StartDate=StartDate_" "_StartTime
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)  /// 医生
	.S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm) /// 主医嘱
	.S priorty=$E(priorty,1,2)
	.i orditm'=moeori S inciDesc="______"_inciDesc
	.S index=StartDate_"||"_moeori_"||"_orditm
	.i $d(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index)) d
	..S $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index),"^",13)=EndDate
	..S $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index),"^",14)=OeFlag
	.E  D
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_priorty_"^"_inci_"^"_doctorID_"^"_moeori_"^"_EndDate_"^"_OeFlag_"^"_duration

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)	/// 输出空的json串
	
	S Title="orditm^StartDate^MedName^Dosage^freq^Instance^duration^Doctor^Pri^inci^doctorID^moeori^EndDate^OeFlag^duration"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)		/// 输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() 		 	/// 输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:检查关联项
ClassMethod ChkExItm(oeori As %String, funLibTheItmList As %String) As %String
{
	N (oeori,funLibTheItmList)
	Q:oeori="" 0
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S ord=$p(oeori,"||",1)
 	S chl=$p(oeori,"||",2)
 	S arcItmId=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
 	Q:##class(web.DHCSTCNTANTIBACTERIAL).CheckStrIfExitVar(funLibTheItmList,arcItmId) 1
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S arcItmId=$p(^OEORD(ord,"I",lchl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
 	.Q:'##class(web.DHCSTCNTANTIBACTERIAL).CheckStrIfExitVar(funLibTheItmList,arcItmId)
 	.S qflag=1
 	Q qflag
}

/// Descript:按照模块过滤相关药品
ClassMethod CheckItmIfExist(AppType As %String, oeori As %String) As %String
{
	N (AppType,oeori)
	Q:AppType="" 1
	Q:'$d(^DHCPHDrgItems(AppType)) 1
	Q:oeori="" 0
 	S ord=$p(oeori,"||",1) Q:ord="" 0
 	S chl=$p(oeori,"||",2) Q:chl="" 0
 	Q:'$D(^OEORD(ord,"I",chl,1)) 0
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	S:loeori'="" oeori=loeori /// 主医嘱
 	S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
 	S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	Q:inci="" 0
	Q:$d(^DHCPHDrgItems(AppType,inci)) 1
 	S lchl="",qflag=0
 	F  S lchl=$O(^OEORDi(0,"OEORI",ord,oeori,lchl)) Q:(lchl="")!(qflag=1)  D
 	.S ArcItmId=$p(^OEORD(ord,"I",lchl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""
 	.Q:'$d(^DHCPHDrgItems(AppType,inci))
 	.S qflag=1
 	Q qflag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfo",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetMRCICDDx",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetAdrEvent",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheme",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheDrg",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfoNew",pid)
	k ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid)
}

/// Descript:监测子项目
/// W ##Class(web.DHCSTPHCMCOMMON).FunLibSubTheme("ADR")
ClassMethod FunLibSubTheme(rows, page, AppType) As %String
{
	N (rows,page,AppType)
	S EndPage=page*rows  		//结束行
	S StPage=((page-1)*rows)+1 //开始行
	S ThemeID=$o(^DHCPHFUTHE(0,"Code",AppType,""))
	Q:ThemeID="" "[]"
	S pid=..NewPid()
	S Num=0
	S ch=""
	F  S ch=$o(^DHCPHFUTHE(ThemeID,"I",ch)) Q:ch=""  D
	.S thri=ThemeID_"||"_ch
	.S itmr=""
	.F  S itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) Q:itmr=""  D
	..S code=$p(^DHCPHFULITM(itmr),"^",1)
	..S desc=$p(^DHCPHFULITM(itmr),"^",2)
	..S type=$p(^DHCPHFULITM(itmr),"^",5)
	..S activeflag=$p(^DHCPHFULITM(itmr),"^",6)
	..Q:activeflag'="Y"   //是否激活
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheme",pid,Num)=itmr_"^"_desc_"^"_type
	
	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="val^text^Type"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheme",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheme",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:监测子项目
/// W ##Class(web.DHCSTPHCMCOMMON).FunLibSubTheItm("12","1","ADR")
ClassMethod FunLibSubTheItm(rows, page, thri) As %String
{
	N (rows,page,thri)
	S EndPage=page*rows 		//结束行
	S StPage=((page-1)*rows)+1 //开始行
	Q:thri="" "[]"
	S pid=..NewPid()
	S Num=0
	S itmr=""
	F  S itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) Q:itmr=""  D
	.S code=$p(^DHCPHFULITM(itmr),"^",1)
	.S desc=$p(^DHCPHFULITM(itmr),"^",2)
	.S FunLibID=$p(^DHCPHFULITM(itmr),"^",3) //库函数ID
	.S Arguments=$p(^DHCPHFULITM(itmr),"^",4) //具体项目
	.Q:Arguments=""
	.S activeflag=$p(^DHCPHFULITM(itmr),"^",6)
	.Q:activeflag'="Y"   //是否激活
	.S Len=$L(Arguments,",")
	.F i=1:1:Len D
	..S tmp=..getFunLibItmInfo(FunLibID,$p(Arguments,",",i))
	..Q:tmp=""
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheDrg",pid,Num)=tmp
	
	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="Desc^RowID^Type"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheDrg",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","FunLibSubTheDrg",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

ClassMethod getFunLibItmInfo(FunLibID, RowID) As %String
{
	N (FunLibID,RowID)
	S Type=$p(^DHCPHFULIB(FunLibID),"^",1)
	Q:Type["Lab" ""
	I Type'["Lab" D
	.S Type="D"
	.S ItmDesc=$p(^PHCD(+RowID,1),"^",2)  //药品
	E   D
	.S Type="L"
	.S RowID=$p(RowID,":")
	.S ItmDesc=$p(^ARCIM(+RowID,$p(RowID,"||",2),1),"^",2)

	Q ItmDesc_"^"_RowID_"^"_Type
}

/// Descript:返回主题相关检验和药品列表
ClassMethod getFunLibTheItmList(ThemeCode) As %String
{
	n (ThemeCode)
	q:ThemeCode="" ""
	s funLibTheItmList=""
	s ThemeID=$o(^DHCPHFUTHE(0,"Code",ThemeCode,""))
	q:ThemeID="" ""
	s ActiveFlag=$p(^DHCPHFUTHE(ThemeID),"^",5) //启用
	q:ActiveFlag'="Y" ""
	s ch=""
	f  s ch=$o(^DHCPHFUTHE(ThemeID,"I",ch)) q:ch=""  d
	.s thri=ThemeID_"||"_ch
	.s itmr=""
	.f  s itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) q:itmr=""  d
	..s activeflag=$p(^DHCPHFULITM(itmr),"^",6)
	..q:activeflag'="Y"   //是否激活
	..s fundr=+$p(^DHCPHFULITM(itmr),"^",3)
	..q:fundr=0           //函数是否为空
	..s arguments=$p(^DHCPHFULITM(itmr),"^",4)
	..q:arguments=""
	..s arguments=..filerArguments(arguments)
	..i funLibTheItmList="" s funLibTheItmList=arguments
	..e  s funLibTheItmList=funLibTheItmList_","_arguments
	q funLibTheItmList
}

/// Descript:
ClassMethod filerArguments(arguments) As %String
{
	n (arguments)
	s ret=""
	s Len=$L(arguments,",")
	f i=1:1:Len d
	.s argument=$p(arguments,",",i)
	.i argument'[":" d
	..s code=$p(^PHCD(+argument,1),"^",1)
	..s arc=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	..q:arc=""
	..s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),arc,""))
	..q:sub=""
	..s tempstr=arc_"||"_sub
	.e  d
	..s tempstr=$p(argument,":",1)
	.q:tempstr=""
	.
	.i ret="" s ret=tempstr
	.e  s ret=ret_","_tempstr
	q ret
}

/// Descritp:民族
ClassMethod SelNation() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTNAT_RowId as NatDr,CTNAT_Desc as NatDesc FROM CT_Nation"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s NatDr = result.Data("NatDr")
		s NatDesc = result.Data("NatDesc")
		s:NatDesc["-" NatDesc=$p(NatDesc,"-",2)
		s tmp=NatDr_"^"_NatDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:不良反应事件
ClassMethod SelAdrEvent() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ADRE_RowID as ADREDr,ADRE_Desc as ADREDesc FROM DHC_PHAdrEvent"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ADREDr = result.Data("ADREDr")
		s ADREDesc = result.Data("ADREDesc")
		s tmp=ADREDr_"^"_ADREDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:不良反应事件
ClassMethod SelAdrReaForMed() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ADRRM_RowID as ADRRMDr,ADRRM_Desc as ADRRMDesc FROM DHC_PHAdrReasonForMed"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ADRRMDr = result.Data("ADRRMDr")
		s ADRRMDesc = result.Data("ADRRMDesc")
		s tmp=ADRRMDr_"^"_ADRRMDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:医院
/// d ##class(web.DHCSTPHCMCOMMON).SelCTHospital()
ClassMethod SelCTHospital() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT HOSP_RowId as HospDr,HOSP_Desc as HospDesc FROM CT_Hospital"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s HospDr = result.Data("HospDr")
		s HospDesc = result.Data("HospDesc")
		s tmp=HospDr_"^"_HospDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descritp:职称
ClassMethod SelCarPrvTp(Alise As %String = "") As %String
{
	N (Alise,%session)
	s Alise=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId as CTCPTDr,CTCPT_Desc as CTCPTDesc,CTCPT_DateTo as DateTo FROM CT_CarPrvTp"
	s:Alise'="" sqlStr=sqlStr_" where CTCPT_Desc="_""""_Alise_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s CTCPTDr = result.Data("CTCPTDr")
		s CTCPTDesc = result.Data("CTCPTDesc")
		s DateTo=result.Data("DateTo")
		continue:(DateTo'="")&(DateTo<+$h)  //lbb  2020.2.26 过滤截止日期小于当前日期
		s CTCPTDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",CTCPTDesc)
		s tmp=CTCPTDr_"^"_CTCPTDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:获取病人医嘱信息
/// W ##class(web.DHCSTPHCMCOMMON).GetPatOEInfo("15","1","264","OUT")
ClassMethod GetPatOEInfo(rows As %String, page As %String, AdmDr As %String, priCode As %String)
{
	n (rows,page,AdmDr,priCode,%session)	
	q:AdmDr="" "[]"
	s EndPage=page*rows  		/// 结束行
	s StPage=((page-1)*rows)+1	/// 开始行
	s ord=$o(^OEORD(0,"Adm",AdmDr,""))
	q:ord="" "[]"
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s Num=0
    s chl=0 
    f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.s orditm=ord_"||"_chl
	.s priDr=+$p($g(^OEORD(ord,"I",chl,1)),"^",8) 
    .q:priDr=0 
    .s priorty=$p(^OECPR(priDr),"^",1)				/// 医嘱优先级代码   
    .//q:priorty["OM" 								/// 自备药   
    .;q:(priCode'="")&(priCode'=priorty)  
    .//-q:(priCode="S")&(priCode'=priorty)			/// qunianpeng 2016-09-13 可取出出院带药、自备药等类型医嘱
    .//-q:(priCode="NORM")&(priorty="S")
    .q:(priCode'="")&(priCode'="OTHER")&(priCode'=priorty)			/// 查询长嘱，临嘱，带药医嘱
    .q:(priCode="OTHER")&((priorty="S")||(priorty="NORM")||(priorty="OUT"))
   	.s priorty=$p(^OECPR(priDr),"^",2)				/// 医嘱优先级
    .s StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .s OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
    .q:OeFlag="U" //作废
    .s OeRowID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OeFlag),""))	/// 增加医嘱描述  qunianpeng 2018/3/13
    .s OeDesc=$p(^OEC("OSTAT",OeRowID),"^",2) 		/// 医嘱状态
	.//q:(OeFlag'="V")&(OeFlag'="E")
	.s FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12)	/// 滚医嘱来源信息 OEORI_FillerNo
    .q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")		/// 长嘱非首日和截止日期的记录过滤
	.s ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)		/// 医嘱 ARC_ItmMast ARCIM_RowId
	.s ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .q:(ordertype'="R")
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.q:inci=""  									/// 医嘱名称
	.;s incidesc=$p(^INCI(inci,1),"^",2) 			/// 药品名称
	.S incidesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2018/12/3 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
	.;s dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1)		/// 剂量
	.//s dosage=$fn(dosage,"")
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/6/28 同频次不同剂量,剂量串
	.s dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)	/// 剂量单位
	.;s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  /// OEORI_PHFreq_DR
    .;s freq=$p($g(^PHCFR(freqdr)),"^",3)			/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .s instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s instru=$p($g(^PHCIN(instrudr)),"^",2)		/// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
    .;s qty=$p(^OEORD(ord,"I",chl,1),"^",18)         ///数量   hzg
    .s oeoersub=$o(^OEORD(ord,"I",chl,"X",""),-1)
    .s qty=$p($g(^OEORD(ord,"I",chl,"X",oeoersub)),"^",4)  //执行数量
    .s arcim=$p($g(^INCI(inci,1)),"^",3)
    .q:arcim=""
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) /// 通用名
    .s formdr=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1)
    .s:formdr'="" form=$p(^PHCF(formdr),"^",2)					/// 剂型 
    .;s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4)			/// 厂家
    .;s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .s apprdocu="",manf=""
    .s itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .i itminfo'="" s apprdocu=$p(^DHCITMINFO(itminfo),"^",10)	/// 批准文号
	.i itminfo'="" s manfdr=$p(^DHCITMINFO(itminfo),"^",48)   //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .s:(apprdocu="-")!(apprdocu="-undefined") apprdocu=""
    .//s spec="["_$p(^INCI(inci,3),"^",9)_"]"		/// 规格
    .s VendorStr=##class(web.DHCST.Common.DrugStkCommon).GetLastVen(inci)    //供应商
    .s Vendor=$p(VendorStr,"^",2)
    .s incibsub=0
    .f  s incibsub=$o(^INCI(inci,"IB",incibsub)) q:incibsub=""  d
    ..s BatNo=$p(^INCI(inci,"IB",incibsub),"^",1)
 	..s ExpDate=+$p(^INCI(inci,"IB",incibsub),"^",2)
 	..;s ExpDate=$zd(ExpDate,3)
	..s ExpDate=..DateLogicalToHtml(ExpDate) //lbb 2018/9/4 修改日期取值
    ..s BatExpStr=BatNo_"~"_ExpDate
    .s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)  //医生
    .;s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s flag=##class(web.DHCSTPHCMStkDrgUtil).JudgeArcimInci(inci)
    .i flag=1  s spec=""
    .e  S spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci) //规格
    .s EndDate=$p($g(^OEORD(ord,"I",chl,3)),"^",34)     /// 停止日期
	.s:EndDate'="" EndDate=..DateLogicalToHtml(EndDate) ;$zd(EndDate,3)
	.s endTime=$p($g(^OEORD(ord,"I",chl,2)),"^",15)     /// 停止时间
	.s:endTime'="" endTime=$zt(endTime,3)
	.s execStat=..CheckIfExec(ord,chl)				/// 是否执行 qunianpeng 2018/3/12
	.s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"") 
	.s sendStat=..CheckIfSend(ord,chl) 				/// 是否发药 qunianpeng 2018/3/12
	.s sendStat=$case(sendStat,"Y":"已发药","N":"未发药",:"") 
	.i FillerNo'="" d
	..s orditm=$p(FillerNo,"!!",1)
	.s StartDate=$p($g(^OEORD(ord,"I",$p(orditm,"||",2),1)),"^",9)		/// 开始日期(要求开始执行)
	.s:StartDate'="" StartDate=..DateLogicalToHtml(StartDate) ;$zd(StartDate,3)
	.s startTime=$p($g(^OEORD(ord,"I",$p(orditm,"||",2),1)),"^",10)  	/// 开始时间(要求开始执行)
	.s:startTime'="" startTime=$zt(startTime,3)	
	.s moeori=..GetMainOeoriNew(orditm)				/// 主医嘱
	.i moeori'="" s incidesc="______"_incidesc     /// 成组医嘱显示符
    .//s index=StartDate_"||"_moeori_"||"_orditm
    .s groupFlag=""									/// 成组医嘱显示符	 qunianpeng 2018/3/13
    .s index=ord_chl ;priorty_"||"_StartDate_"||"_orditm_"||"_moeori
    .s orderbak=##class(web.DHCOutPhCommon).GetOrdRemark(orditm)   //取医嘱备注  lbb 2020.2.25
	.s Num=Num+1
	.s incidesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",incidesc)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.s genenic=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCGeneric","PHCGEName","",genenic)
	.s form=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCForm","PHCFDesc","",form)
	.s manf=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHManufacturer","PHMNFName","",manf)
	.s apprdocu=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCItmAddionInfo","INFORemark","",apprdocu)
	.s priorty=##class(PHA.FACE.IN.Com).GetTransDesc("User.OECPriority","OECPRDesc","",priorty)
	.s execStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(execStat)
	.s sendStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(sendStat)
	.s doctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",doctor)
	.s OeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.OECOrderStatus","OSTATDesc","",OeDesc)
	.s Vendor=##class(PHA.FACE.IN.Com).GetTransDesc("User.APCVendor","APCVMName","",Vendor)
	.s orderbak=##class(PHA.FACE.IN.Com).GetTransDesc("User.OEOrdItem","OEORIDepProcNotes","",orderbak)	
	.s ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)=orditm_"^"_phcdf_"^"_incidesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic
	.s ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)_"^"_formdr_"^"_$g(form)_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty_"^"_execStat_"^"_sendStat_"^"_moeori_"^"_groupFlag_"^"_doctor_"^"_OeDesc_"^"_startTime_"^"_endTime_"^"_Vendor_"^"_BatExpStr_"^"_qty_"^"_orderbak
	.// 临时global用于输出时判断成组医嘱  显示成组符
	.s ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo","moeori",ord,chl)=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)
	
	q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)		/// 输出空的json串
	
	s Title="orditm^phcdf^incidesc^dosage^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^StartDate^EndDate^OeFlag^priorty^execStat^sendStat^moeori^groupFlag^doctor^oeDesc^startTime^endTime^Vendor^BatExpStr^qty^orderbak"
	s maxrow=Num
	i EndPage>maxrow s EndPage=maxrow
	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)			/// 输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)) q:(index="")||(quitflag=1)  d
	.q:+index=0
	.s moeori=$p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",26)
	.s orditm=$p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",1)
	.s ord=$p(orditm,"||",1)
	.s markChild=$d(^OEORDi(0,"OEORI",ord,orditm))	
	.s sub=$p(orditm,"||",2)  ;:moeori'=""
	.s sub=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo","moeori",ord,sub)) 
	.s tempMoeori=""
	.s:sub'="" tempMoeori=$p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo","moeori",ord,sub),"^",26)
	.//主医嘱 
	.s:(moeori="")&&(markChild>0)&&(tempMoeori'="") $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",27)="<p style=display:inline;color:red;>┓</p>"
	.s:(moeori="")&&(markChild>0)&&(tempMoeori="") $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",27)=""
	.//子医嘱
	.s:(moeori'="")&&(tempMoeori'="") $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",27)="<p style=display:inline;color:red;>┃</p>"
	.s:(moeori'="")&&(tempMoeori="") $p(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index),"^",27)="<p style=display:inline;color:red;>┛</p>"
			
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOEInfo",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取诊断字典信息
/// W ##class(web.DHCSTPHCMCOMMON).GetMRCICDDx("2","1","")
ClassMethod GetMRCICDDx(rows As %String, page As %String, alise As %String)
{
	N (rows,page,alise)
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	S Num=0
    S MRCID=0 
    F  S MRCID=$o(^MRC("ID",MRCID)) q:MRCID=""  d
    .S MRCCode=$p(^MRC("ID",MRCID),"^",1)  //代码
    .S MRCDesc=$p(^MRC("ID",MRCID),"^",2)  //描述
    .Q:MRCDesc'[alise
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetMRCICDDx",pid,Num)=MRCID_"^"_MRCDesc

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="MRCID^MRCDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetMRCICDDx",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetMRCICDDx",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取不良反应字典信息
/// W ##class(web.DHCSTPHCMCOMMON).GetAdrEvent("2","1","")
ClassMethod GetAdrEvent(rows As %String, page As %String, adrEvtAlise As %String)
{
	N (rows,page,adrEvtAlise)
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	S Num=0
    S adrEvtID=0 
    F  S adrEvtID=$o(^DHCPHADRE(adrEvtID)) q:adrEvtID=""  d
    .S adrEvtCode=$p(^DHCPHADRE(adrEvtID),"^",1)  //代码
    .S adrEvtDesc=$p(^DHCPHADRE(adrEvtID),"^",2)  //描述
    .Q:(adrEvtAlise'="")&(adrEvtDesc'[adrEvtAlise)
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetAdrEvent",pid,Num)=adrEvtID_"^"_adrEvtDesc

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="AdrEvtID^AdrEvtDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetAdrEvent",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetAdrEvent",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:   获取对应人员的审批状态值
/// CreateDate：2014-12-17
/// Creater：   bianshuai
/// Table：     DHC_PHAdrStatusGrant,DHC_PHAdrStatus
/// Input:      repAppCode-报告代码,安全组id^科室id^用户id
/// Return:     当前参数对应的状态值
/// w class(web.DHCSTPHCMCOMMON).GetUserStatusGrant("","198^36^578")
ClassMethod GetUserStatusGrant(repAppCode As %String, StrParam As %String = "") As %Library.String
{
	N (repAppCode,StrParam)
	S nextStatusID=""
	//S repAppCode=$$ALPHAUP^SSUTIL4(repAppCode)
	//Q:repAppCode="" nextStatus
	s GroupId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s UserId=$p(StrParam,"^",3)
	
	//优先按人取配置
	i (UserId'="")&(nextStatusID="")  d
	.s nextStatusID=$o(^DHCPHADRS(0,"TypePointer","U",UserId,""))
	.

	//不存在按人的定义，则按安全组取
	i (GroupId'="")&(nextStatusID="")  d
	.s nextStatusID=$o(^DHCPHADRS(0,"TypePointer","G",GroupId,""))
	.

    //不存在按人和安全组的定义，则按科室取
	i (LocId'="")&(nextStatusID="")  d
	.s nextStatusID=$o(^DHCPHADRS(0,"TypePointer","L",LocId,""))
	.

	Q nextStatusID
}

/// Descript:获取当前状态的下一个状态
ClassMethod getNextStauts(repAppCode As %String, curStatusID As %String) As %Library.String
{
	n (repAppCode,curStatusID)
	q:curStatusID="" ""
	s nextStatusID=$o(^DHCPHADRP(0,"NextStatus",curStatusID,""))
	q nextStatusID
}

/// Descript:取患者体温单信息
///          入参(EpisodeID患者就诊号:StrDate:日期,格式2013-03-21:StrTime:时间,格式07:00）
///          (时间为03:00,07:00,11:00,15:00,19:00,23:00)
/// Item7^脉搏 Item6^舒张压 Item5^收缩压  Item4^呼吸 Item3^身高 Item2^体重(kg)^ Item1^体温
/// Item9^尿量  Item11^大便次数 Item13^心率 Item14^日出液量  Item16^日入液量
/// Item22^物理降温 Item20^肛温  Item18^药物过敏  Item17^体温未测原因  
/// Item26^项目1 Item21^值1 Item27^项目2 Item23^值2  Item28^项目2 Item24^值2  Item29^项目2 Item25^值2  Item30^项目2 Item19^值2 Item31^疼痛  Item32^复评疼痛
/// Table: MR_Observations 体温单
/// w ##class(web.DHCSTPHCMCOMMON).getPatMRObservations("16581800",+$h,time)
ClassMethod getPatMRObservations(EpisodeID, StrDate, StrTime) As %String
{
	n (EpisodeID, StrDate, StrTime)
	s retstr=""
	s MRAdmId=$P(^PAADM(EpisodeID),"^",61)
	s itmdr=""  
	f  s itmdr=$o(^MR(MRAdmId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	.s chl=""  
	.f  s chl=$o(^MR(MRAdmId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	..s time=$p(^MR(MRAdmId,"OBS",chl),"^",4)
	..q:time'=StrTime
	..s val=$p(^MR(MRAdmId,"OBS",chl),"^",2)
	..//s Desc=$p(^MR(MRAdmId,"OBS",chl),"^",6)
	..s desc=$p($g(^MRC("OBITM",itmdr)),"^",1)
	..q:desc=""
	..i retstr="" s retstr=desc_":"_val
	..e  s retstr=desc_":"_val_","_retstr
	s retstr=$tr(retstr,$C(13,10),"")
	q retstr
}

/// Descript:获取对应项目的值
ClassMethod getobserItems(obserItems, item) As %String
{
	n (obserItems,item)
	s itemval=""
	s len=$L(obserItems,",")
	f i=1:1:len q:itemval'=""  d
	.q:item'=$p($p(obserItems,",",i),":",1)
	.s itemval=$p($p(obserItems,",",i),":",2)
	q itemval
}

/// Descript:主诉
ClassMethod getPatPriAct(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patPriActDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:TextDesc#TID:9#TVER:0#ECODE:E0001")
	q patPriActDesc
}

/// Descript:现病史
///     主诉、起病情况、主要症状、病情的发展与演变、诊疗经过、一般情况、常规检查、特殊检查
ClassMethod getPatHPC(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patHPCDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:TextDesc#TID:10#TVER:0#ECODE:E0001")
	q patHPCDesc
}

/// Descript:既往病史
ClassMethod getPatPMHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	/// 传染病
	s contagDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0022")
	/// 慢性病
	s chronDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0051")
	/// 外伤史
	s rtumHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0035")
	/// 手术史
	s operHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0036")
	/// 输血史
	s TransfDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0037")

    s patPMHisDesc=contagDesc_chronDesc_rtumHisDesc_operHisDesc_TransfDesc
	q patPMHisDesc
}

/// Descript:既往用药史
ClassMethod getPatPMDrgHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	/// 传染病用药
	s contagDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:SegmentSimple#TID:11#TVER:0#TCODE:G0022#SCODE:I0029#VTYPE:V")
	/// 慢性病用药
	s chronDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:SegmentSimple#TID:11#TVER:0#TCODE:G0051#SCODE:I0057#VTYPE:V")
	/// 过敏史用药
	s AllHisDrgDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:SegmentSimple#TID:11#TVER:0#TCODE:G0032#SCODE:I0049#VTYPE:V")
	/// 输血史用药
	s TransfDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:SegmentSimple#TID:11#TVER:0#TCODE:G0065#SCODE:M0069#VTYPE:V")
	
	s patPMDrgHisDesc=contagDesc_chronDesc_AllHisDrgDesc_TransfDesc
	q patPMDrgHisDesc
}

/// Descript:入院诊断
/// w ##class(web.DHCSTPHCMCOMMON).getPatInHosDiag(70)
ClassMethod getPatInHosDiag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patInHosDiagDesc1=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0001#VTYPE:V") //诊断1
	s patInHosDiagDesc2=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0002#VTYPE:V") //诊断2
	s patInHosDiagDesc3=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0003#VTYPE:V") //诊断3
	s patInHosDiagDesc4=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0004#VTYPE:V") //诊断4
	s patInHosDiagDesc5=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0005#VTYPE:V") //诊断5
	s patInHosDiagDesc6=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:31#TVER:0#SCODE:I0006#VTYPE:V") //诊断6
	
	s patInHosDiagDesc=patInHosDiagDesc1_patInHosDiagDesc2_patInHosDiagDesc3_patInHosDiagDesc4_patInHosDiagDesc5_patInHosDiagDesc6
	q patInHosDiagDesc
}

/// Descript:初步诊断
/// w ##class(web.DHCSTPHCMCOMMON).getPatPreDiag(70)
ClassMethod getPatPreDiag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patPreDiagDesc1=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0001#VTYPE:V") //诊断1
	s patPreDiagDesc2=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0002#VTYPE:V") //诊断2
	s patPreDiagDesc3=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0003#VTYPE:V") //诊断3
	s patPreDiagDesc4=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0004#VTYPE:V") //诊断4
	s patPreDiagDesc5=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0005#VTYPE:V") //诊断5
	s patPreDiagDesc6=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Simple#TID:30#TVER:0#SCODE:I0006#VTYPE:V") //诊断6
	
	s patPreDiagDesc=patPreDiagDesc1_patPreDiagDesc2_patPreDiagDesc3_patPreDiagDesc4_patPreDiagDesc5_patPreDiagDesc6
	q patPreDiagDesc
}

/// Descript:个人史
ClassMethod getPatPerHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	/// 吸烟史
	s smokHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:12#TVER:0#GCODE:G0003")
	/// 饮酒史
	s drinkHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:12#TVER:0#GCODE:G0004")
	/// 毒物接触史
	s toxExpHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:12#TVER:0#GCODE:G0005")
	/// 冶游史
	s visProHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:12#TVER:0#GCODE:G0006")
	
	s patPerHisDesc=smokHisDesc_drinkHisDesc_toxExpHisDesc_visProHisDesc
	
	q patPerHisDesc
}

/// Descript:家族史
ClassMethod getPatFamHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patFamHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:15#TVER:0#GCODE:G0001")
	q patFamHisDesc
}

/// Descript:过敏史
ClassMethod getPatAllHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s patAllHisDesc=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, "#TYPE:Segment#TID:11#TVER:0#GCODE:G0032")
	q patAllHisDesc
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("FunLibSubTheme"))
}

/// Descript:获取病人基本就诊信息
/// w ##class(web.DHCSTPHCMCOMMON).GetPatInfoEss("646","1602")
ClassMethod GetPatInfoEss(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	s patSex=""
	i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	s nationdr=$p(^PAPER(PatientID,"PER",2),"^",1) //民族
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	i birthday'="" s birthday=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(birthday) ;$zd(birthday,3)
	s patAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,EpisodeID)  //年龄
	s natplace=""    //籍贯
	s patWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	s patHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) //身高
	s patTel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)     //电话
	s idcard=""      //身份证
	s workunit=""    //工作单位
	s AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
	s medicalNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(EpisodeID,AdmType) //lbb 2020.5.29 修改病案号取统一接口
	
	s AdmLoc=""
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4) //科室
	s:AdmLocID'="" AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
	s AdmDoc=""
	s AdmDocID=$p(^PAADM(EpisodeID),"^",9) //医生
	s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2)
	s AdmWard=""
	s AdmWardID=$p(^PAADM(EpisodeID),"^",70) //病区
	s:AdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	s AdmBed=""
	s AdmBedID=$p(^PAADM(EpisodeID),"^",73) //床号
	i AdmBedID'="" s AdmBed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
	
	s AdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	s AdmTime=$p(^PAADM(EpisodeID),"^",7)  //就诊时间
	i AdmDate'="" S AdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmDate) ;$zd(AdmDate,3)
	i AdmTime'="" S AdmTime=$zt(AdmTime,1)
	s AdmTime=AdmDate_" "_AdmTime
	S PayType=..PayType(EpisodeID) //费别  nisijia 2016-09-22
	s patdiag=##class(PHA.COM.Order).MrDiagnose(EpisodeID,",") //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s allergy=""  //过敏史
	s sysdate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+$h) ;$zd(+$h,3)
	
	s adrrEvtInitStatDR=$o(^DHCPHADRS(0)) //初始状态
    s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
    s patSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",patSex)
    s nation=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTNation","CTNATDesc","",nation)   
	s PayType=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACAdmReason","READesc","",PayType)
	s patdiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",patdiag)
	s AdmDoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",AdmDoc)
	s AdmLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
	s AdmWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
	s ListData=PatientID_"^"_EpisodeID_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge
	s ListData=ListData_"^"_birthday_"^"_nationdr_"^"_nation_"^"_medicalNo_"^"_natplace_"^"_patWeight
	s ListData=ListData_"^"_patHeight_"^"_patTel_"^"_workunit_"^"_idcard_"^"_patdiag_"^"_allergy
	s ListData=ListData_"^"_AdmDoc_"^"_AdmLoc_"^"_AdmWard_"^"_AdmBed_"^"_AdmTime_"^"_sysdate_"^"_adrrEvtInitStatDR_"^"_AdmDate_"^"_PayType
	
	s ListTitle="PatientID^EpisodeID^patno^patname^sexId^patsex^patage^patdob^nationdr^nation^medicalNo^native^weight^height^modphone^workunit^idcard^patdiag^allergy" 
	s ListTitle=ListTitle_"^doctor^admloc^admward^admbed^admdate^sysdate^adrrEvtInitStatDR^admdate^paytype"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:获取病人基本就诊信息
/// w ##class(web.DHCSTPHCMCOMMON).GetPatEssInfo(533,861)
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)		/// 姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)		/// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)		/// 姓别
	s patSex=""
	i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)    /// 出生日期	
	s nationdr=$p(^PAPER(PatientID,"PER",2),"^",1)  /// 民族  //qunianpeng 2016-09-07 
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	
	i birthday'="" s birthday=..DateLogicalToHtml(birthday) ;$zd(birthday,3)
	s patAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,EpisodeID)	/// 年龄

	s patCityDr=$p(^PAPER(PatientID,"ALL"),"^",18)      /// 籍贯  //qunianpeng 2016-09-07 改到工作单位
	s natplace=""
	i patCityDr'="" s natplace=$p(^CT("CIT",patCityDr),"^",2)	
	s patWeight=##class(PHA.COM.Order).PatWeight(EpisodeID)	/// 体重
	s patHeight=##class(PHA.COM.Order).PatHeight(EpisodeID)	/// 身高
	s patTel=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s workunit=$p($g(^PAPER(PatientID,"PER",4)),"^",18) /// 工作单位

	s AdmType=$p($g(^PAADM(+EpisodeID)),"^",2)
	s medicalNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(EpisodeID,AdmType) //lbb 2020.5.29 修改病案号取统一接口
	
	s AdmLoc=""
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4)				/// 科室
	s:AdmLocID'="" AdmLoc=$p($p(^CTLOC(AdmLocID),"^",2),"-",2)
	s AdmWard=""
	s AdmWardID=$p(^PAADM(EpisodeID),"^",70)			/// 病区
	s:AdmWardID'="" AdmWard=$p(^PAWARD(AdmWardID),"^",2)
	s AdmBed=""
	s AdmBedID=$p(^PAADM(EpisodeID),"^",73)				/// 床号
	i AdmBedID'="" s AdmBed=$p(^PAWARD($p(AdmBedID,"||",1),"BED",$p(AdmBedID,"||",2)),"^",1)
    s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
    s patSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",patSex)
    s nation=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTNation","CTNATDesc","",nation)   
	s workunit=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPERSecondPhone","",workunit)
	s natplace=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCity","CTCITDesc","",natplace)
	s AdmLoc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",AdmLoc)
	s AdmWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
	s ListData=PatientID_"^"_EpisodeID_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge
	s ListData=ListData_"^"_birthday_"^"_nationdr_"^"_nation_"^"_medicalNo_"^"_natplace_"^"_patWeight
	s ListData=ListData_"^"_patHeight_"^"_patTel_"^"_workunit
	s ListData=ListData_"^"_AdmLocID_"^"_AdmLoc_"^"_AdmWardID_"^"_AdmWard_"^"_AdmBed
	
	q ListData
}

/// Descript:取病人的诊断信息
ClassMethod GetPatRelaDiag(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
}

/// Descript:取病人的生命体征
ClassMethod GetPatVitalSigns(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	q:EpisodeID="" ""
	s obserItemsVal="",obserstr=""
	//取最近一次查房记录值
	s curTime=$p($h,",",2)
	s timestr="23:00,19:00,15:00,11:00,07:00,03:00"
	s len=$L(timestr,",")
	f i=1:1:len  q:obserItemsVal'=""  d
	.s time=$zth($p(timestr,",",i),3)
	.q:time>curTime
	.s obserItemsVal=##class(web.DHCSTPHCMCOMMON).getPatMRObservations(EpisodeID,+$h,time)
	.

	q:obserItemsVal="" ""

	s obserItemsVal=$REPLACE(obserItemsVal,"Item13","心率") //心率
	s obserItemsVal=$REPLACE(obserItemsVal,"Item11","大便次数") //大便次数
	s obserItemsVal=$REPLACE(obserItemsVal,"Item9","尿量") //尿量
	s obserItemsVal=$REPLACE(obserItemsVal,"Item7","脉搏")  //脉搏
	s obserItemsVal=$REPLACE(obserItemsVal,"Item4","呼吸") //呼吸
	s obserItemsVal=$REPLACE(obserItemsVal,"Item3","身高") //身高
	s obserItemsVal=$REPLACE(obserItemsVal,"Item2","体重") //体重
	s obserItemsVal=$REPLACE(obserItemsVal,"Item1","体温") //体温

	q "{"_obserItemsVal_"}"
}

/// Descritp:性别
ClassMethod SelCTSex() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTSEX_RowId as CTSexDr,CTSEX_Desc as CTSexDesc,CTSEX_DateTo as DateTo FROM CT_SEX"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s SexDr = result.Data("CTSexDr")
		s SexDesc = result.Data("CTSexDesc")
		s DateTo=result.Data("DateTo")
		continue:(DateTo'="")&(DateTo<+$h)  //lbb  2020.2.26 过滤截止日期小于当前日期
		s SexDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",SexDesc)
		s tmp=SexDr_"^"_SexDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// W ##Class(web.DHCSTPHCMCOMMON).GetPatOrdItmInfoNew("10","1","116","","")
ClassMethod GetPatOrdItmInfoNew(rows As %String, page As %String, AdmDr As %String, priCode As %String, AppType As %String, allFlag As %String = "") As %String
{
	n (rows,page,AdmDr,priCode,AppType,allFlag,%session)
	q:AdmDr="" "-1"
	s EndPage=page*rows  			/// 结束行
	s StPage=((page-1)*rows)+1		/// 开始行
	s ord=$o(^OEORD(0,"Adm",AdmDr,""))
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	d ..killTmpGlobal(pid)
	s Num=0
    s chl=0 
    f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.s orditm=ord_"||"_chl
	.s priDr=+$p($g(^OEORD(ord,"I",chl,1)),"^",8) 
    .q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) 									/// 医嘱优先级代码              
    .//q:(priCode="S")&(priCode'=priorty)
    .//q:(priCode="NORM")&(priorty="S")
    .q:(priCode'="")&(priCode'="OTHER")&(priCode'=priorty)				/// 查询长嘱，临嘱，带药医嘱 qunianpeng 2018/3/12
    .q:(priCode="OTHER")&((priorty="S")||(priorty="NORM")||(priorty="OUT"))
    .s priorty=$p(^OECPR(priDr),"^",2) 									/// 医嘱优先级
    .;S oeStopTimeList=##Class(web.DHCLONGTIMEORD).PRX(ord,chl) 		/// 医生停止医嘱日期时间
    .s oeStopTimeList=..PRX(ord,chl) 									/// 医生停止医嘱日期时间
	.s statDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .s oeFlag=$p(^OEC("OSTAT",statDr),"^",1) 							/// 增加医嘱描述  qunianpeng 2018/3/13
    .q:oeFlag="U" //作废
    .//s oeRowID=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(oeFlag),""))	/// 增加医嘱描述  qunianpeng 2018/3/13
    .//s oeDesc=$p(^OEC("OSTAT",oeRowID),"^",2) 						/// 医嘱状态
	.//q:(OeFlag'="V")&(OeFlag'="E")
    .s XDate=$p(oeStopTimeList,"|",1)    
    .s XTime=$p(oeStopTimeList,"|",2)
    .s XCpt=$p(oeStopTimeList,"|",3)
    .S Lgorditm=##Class(web.DHCSTPHCMCOMMON).GetLgOrdFillerNo(ord,chl) 	/// 长嘱首次医嘱ID
    .s nurseStopList=##Class(web.DHCLONGTIMEORD).SingNur(ord,chl) 		/// 护士
    .s NurseStopDate=$p(nurseStopList,"|",1)
    .s NurseStopTime=$p(nurseStopList,"|",2)
    .s NurseStop=$p(nurseStopList,"|",3)
    .S ODate=$P($G(^OEORD(ord,"I",chl,8)),"^",14)						/// 长期医嘱开医嘱日期
    .q:ODate'=""
    .s OrdDate=$P($G(^OEORD(ord,"I",chl,3)),"^",7)						/// 取得医嘱表医嘱日期时间
	.s OrdDate=+OrdDate
	.s OrdTime=$P($G(^OEORD(ord,"I",chl,1)),"^",17)
	.s Status=$P($G(^OEORD(ord,"I",chl,1)),"^",13)						/// OEC_OrderStatus    OEORI_ItemStat_DR 
    .q:Status=11    //未激活
    .s Seq2=$P($G(^OEORD(ord,"I",chl,3)),"^",4)  ;relation No
    .s moeori=$p($g(^OEORD(ord,"I",chl,11)),"^",39)
    .if moeori'="" d
    ..s tmpSeqNo=$P(moeori,"||",2)
    .e  s tmpSeqNo=chl
    .s Seq1=tmpSeqNo
    .s StDate=$P($G(^OEORD(ord,"I",chl,1)),"^",9)
	.s StTime=$P($G(^OEORD(ord,"I",chl,1)),"^",10) 
    .s doctorID=$p($g(^OEORD(ord,"I",chl,7)),"^",1) 					/// 医生ID
    .q:doctorID=""
    .s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl)  	/// 医生
    .s ExceChl=$o(^OEORD(ord,"I",chl,"X",0))
    .i ExceChl'=""  d
	..s DateEx=$p(^OEORD(ord,"I",chl,"X",ExceChl),"^",19)
	..i DateEx'="" s DateEx=..DateLogicalToHtml(DateEx)					/// $ZD(DateEx,3)  ;nursing execute
	..s TimeEx=$p(^OEORD(ord,"I",chl,"X",ExceChl),"^",20)
	..i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	..s CPTExDR=$p(^OEORD(ord,"I",chl,"X",ExceChl),"^",15)
	..i CPTExDR'="" s CPTEx=$p(^CTPCP(CPTExDR,1),"^",2)  
    .s ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  						/// 医嘱 ARC_ItmMast ARCIM_RowId
    .s ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .q:ordertype'="R"
    .;s arcitmdesc=tmpSeqNo_$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)
    .s arcitmdesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)   //qunianpeng 2016-09-08
    .i moeori'="" s arcitmdesc="______"_arcitmdesc
    .s StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .s OrdStat=$p(^OEC("OSTAT",StatDr),"^",1) 
    .q:(allFlag="false")&&((OrdStat="D")||(OrdStat="C"))
    .s index=OrdDate_"^"_OrdTime_"^"_ord_"^"_chl
    .i OrdDate'="" s OrdDate=..DateLogicalToHtml(OrdDate)  ;$zd(OrdDate,3)
    .i OrdTime'="" s OrdTime=$zt(OrdTime,1)
    .;s dosage=$p(^OEORD(ord,"I",chl,2),"^",1)    			/// 剂量
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/6/28 同频次不同剂量,剂量串
	.s dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)			/// 剂量单位
	.;s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)			/// OEORI_PHFreq_DR
    .;s freq=$p($g(^PHCFR(freqdr)),"^",3)      				/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .s instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s instru=$p($g(^PHCIN(instrudr)),"^",2)  				/// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
	.s execStat=##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,chl)	/// 是否执行 qunianpeng 2018/3/12
	.s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"") 
	.s sendStat=##class(web.DHCSTPHCMCOMMON).CheckIfSend(ord,chl) 	/// 是否发药 qunianpeng 2018/3/12
	.s sendStat=$case(sendStat,"Y":"已发药","N":"未发药",:"") 
	.s orderbak=##class(web.DHCOutPhCommon).GetOrdRemark(orditm)   //取医嘱备注  lbb 2020.2.25
	.s Num=Num+1
	.s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(ord_"||"_chl)	/// 主医嘱
	.s priorty=##class(PHA.FACE.IN.Com).GetTransDesc("User.OECPriority","OECPRDesc","",priorty)
	.s arcitmdesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",arcitmdesc)
	.s doctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",doctor)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.s execStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(execStat)
	.s sendStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(sendStat)
	.s orderbak=##class(PHA.FACE.IN.Com).GetTransDesc("User.OEOrdItem","OEORIDepProcNotes","",orderbak)
	.s AuditStat=##class(web.DHCSTPHCMCOMMON).CheckIfAudit(orditm)
	.s AuditStat=$case(AuditStat,"Y":"已审核","N":"已建议","":"",:"") 
	.s AuditStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(AuditStat)
    .s ^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfoNew",pid,OrdDate,index)=orditm_"^"_priorty_"^"_moeori_"^"_arcitmdesc_"^"_OrdDate_"^"_OrdTime_"^"_doctor_"^"_CPTExDR_"^"_XDate_"^"_XTime_"^"_XCpt_"^"_NurseStop_"^"_OrdStat_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_execStat_"^"_sendStat_"^"_orderbak_"^"_AuditStat
	
	q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign() /// 输出空的json串
	
	s Title="orditm^Pri^moeori^MedName^StartDate^StartTime^Doctor^CPTEx^EndDate^EndTime^XCpt^NurseStop^OeFlag^Dosage^freq^Instance^duration^execStat^sendStat^orderbak^AuditStat"
	s maxrow=Num
	i EndPage>maxrow s EndPage=maxrow
	s quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)	/// 输出json前缀串
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfoNew",pid,index),-1) q:(index="")||(quitflag=1)  d
	.s index1=""
	.f  s index1=$o(^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfoNew",pid,index,index1)) q:(index1="")||(quitflag=1)  d
	..s mdata=^TMP("DHCST","web.DHCSTPHCMCOMMON","GetPatOrdItmInfoNew",pid,index,index1)
	..s Num=Num+1
	..q:Num<StPage
	..s:Num=EndPage quitflag=1
	..i Num=StPage d
	...w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	..e  d
	...w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() 	/// 输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取长嘱首次医嘱ID
ClassMethod GetLgOrdFillerNo(ord As %String, chl As %String) As %String
{
	N (ord, chl)
	S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
	Q:FillerNo="" ""
	S orditm=$p(FillerNo,"!!",1)
	Q orditm
}

/// Descript:在session里保存临时的点评条件
ClassMethod saveTmpCmtConIntoSession(strCmtConContainer As %String) As %String
{
	q:strCmtConContainer="" 0
	s %session.Data("CmtConContainer")=strCmtConContainer
	q ""
}

/// Descript:获取保存的临时点评条件
ClassMethod GetTmpCmtConFromSession() As %String
{
	q $g(%session.Data("CmtConContainer"))
}

/// Descript:根据登记号获取病人基本信息
/// d ##class(web.DHCSTPHCMCOMMON).GetPatEssInfoByPatNo("0000001091","I","10")
ClassMethod GetPatEssInfoByPatNo(PatientNo As %String, type As %String = "", hospID As %String = "") As %String
{
	n (PatientNo,type,hospID)
	i type="" s type="O"
	s PatientID=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
	i PatientID="" w "[]"
	q:PatientID="" ""
	s EpisodeID=$o(^PAPERdr(PatientID,"ADM",type,""),-1)
	i EpisodeID="" s EpisodeID=$o(^PAPERdr(PatientID,"ADM","E",""),-1)
	s Locdr=$p(^PAADM(EpisodeID),"^",4)
	q:(hospID'="")&(hospID'=$p($g(^CTLOC(Locdr)),"^",22))   //过滤病区
	;i EpisodeID="" s EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""),-1)
	i EpisodeID="" w "[]"
	q:EpisodeID="" ""
	w ##Class(web.DHCSTPHCMCOMMON).GetPatInfoEss("",EpisodeID)  
 	q ""
}

/// Descript:  获取护理管理身高体重
ClassMethod GetPatHighWeight(EpisodeId As %String, CtlocDesc As %String) As %String
{
	n (EpisodeId,CtlocDesc)
 	q:EpisodeId="" ""
	
	s hight="",weight=""
	if (CtlocDesc["产科") d  //产科
	.s EmrCode="DHCNURANHUI2"
	.s code=$ZConvert(EmrCode,"U")
	.s Moudid=""
	.f  s Moudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,Moudid)) q:Moudid=""  d
	..s a=##class(Nur.DHCMoudData).%OpenId(Moudid)
	..q:a.RecCancelDate'=""
	..s weight=a.Item75
	e  if ((CtlocDesc["儿内")||(CtlocDesc["小儿外科")||(CtlocDesc["儿童重症")) d   //儿科
	.s EmrCode="DHCNURANHUI20"
	.s code=$ZConvert(EmrCode,"U")
	.s Moudid=""
	.f  s Moudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,Moudid)) q:Moudid=""  d
	..s a=##class(Nur.DHCMoudData).%OpenId(Moudid)
	..q:a.RecCancelDate'=""
	..s weight=a.Item75
	e  if (CtlocDesc["日间") d   //日间病房
	.s EmrCode="DHCNURANHUIRJ14"
	.s code=$ZConvert(EmrCode,"U")
	.s Moudid=""
	.f  s Moudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,Moudid)) q:Moudid=""  d
	..s a=##class(Nur.DHCMoudData).%OpenId(Moudid)
	..q:a.RecCancelDate'=""
	..s weight=a.Item74
	..s hight=a.Item77
	e  if (CtlocDesc["新生儿") d   //新生儿科
	.s EmrCode="DHCNURANHUIXSEPG"
	.s code=$ZConvert(EmrCode,"U")
	.s Moudid=""
	.f  s Moudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,Moudid)) q:Moudid=""  d
	..s a=##class(Nur.DHCMoudData).%OpenId(Moudid)
	..q:a.RecCancelDate'=""
	..s weight=a.Item26
	..s hight=a.Item28
	e  d
    .s EmrCode="DHCNURANHUI14"   //通用
	.s code=$ZConvert(EmrCode,"U")
	.s Moudid=""
	.f  s Moudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,Moudid)) q:Moudid=""  d
	..s a=##class(Nur.DHCMoudData).%OpenId(Moudid)
	..q:a.RecCancelDate'=""
	..s weight=a.Item74
	..s hight=a.Item77
	i +hight>0 s hight=hight_"M"
	i +weight>0 s weight=weight_"KG"
	s retstr=hight_"^"_weight     
	q retstr
}

/// Descritp:性别
/// w ##Class(web.DHCSTPHCMCOMMON).jsonCTSex()
ClassMethod jsonCTSex() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTSEX_RowId as CTSexDr,CTSEX_Desc as CTSexDesc FROM CT_SEX"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s SexDr = result.Data("CTSexDr")
		s SexDesc = result.Data("CTSexDesc")
		s tmp=SexDr_"^"_SexDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:职称
ClassMethod jsonCarPrvTp() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId as CTCPTDr,CTCPT_Desc as CTCPTDesc FROM CT_CarPrvTp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s CTCPTDr = result.Data("CTCPTDr")
		s CTCPTDesc = result.Data("CTCPTDesc")
		s tmp=CTCPTDr_"^"_CTCPTDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:	科室
/// W ##Class(web.DHCSTPHCMCOMMON).jsonGetEmPatLoc("")
ClassMethod jsonGetEmPatLoc(HospID As %String) As %String
{
	n (HospID)
	s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc FROM CT_LOC"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s LocDr = result.Data("LocDr")
		s LocDesc = result.Data("LocDesc")
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:	人员
/// W ##Class(web.DHCSTPHCMCOMMON).jsonGetSSUser("")
ClassMethod jsonGetSSUser(input As %String) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSUSR_RowId,SSUSR_Name FROM SS_User"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s userID = result.Data("SSUSR_RowId")
		s userName = result.Data("SSUSR_Name")
		continue:userName'[input
		s tmp=userID_"^"_userName
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Description: 获取病人的入院诊断
/// Creator: bian shuai
/// CreatDate: 2015-12-09
/// Input: 就诊记录ID 
ClassMethod getInHosMRDiagnosDesc(EpisodeID As %String) As %String
{
	N (EpisodeID)
	S InHosMRDiagnos=##Class(web.DHCSTPHCMCOMMON).GetMRDiagnosByEpisodeID(EpisodeID)
	Q InHosMRDiagnos
}

/// Creator：    bianshuai
/// CreatDate：  2016-09-21
/// Description：获取入院诊断
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:	  w ##class(web.DHCSTPHCMCOMMON).GetMRDiagnosByEpisodeID(1602)
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:+EpisodeID=0 ""
	s MRDiagnos="",Num=0
	s INDiaType=$O(^MRC("DTYP",0,"Code","C008",0)) ;入院诊断
	s mradmId=$p(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$o(^MR(mradmId,"DIA",mrdiaSub)) Q:(mrdiaSub="")  D
	.s TYPMRCDiagTyp=$p(^MR(mradmId,"DIA",mrdiaSub,"TYP",1),"^",1)
	.Q:TYPMRCDiagTyp'=INDiaType
	.s MRDIAICDCodeDR=+$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.//Q:MRDIAICDCodeDR=""
	.s MRDiagDesc=$p($g(^MRC("ID",MRDIAICDCodeDR)),"^",2)    /// 诊断描述
	.s MRDiagNotes=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))   /// 诊断注释
	.i MRDiagNotes'="" s MRDiagNotes=""_MRDiagNotes_""
	.s prefix=$P($G(^MR(mradmId,"DIA",mrdiaSub,1)),"^",26)   /// 诊断前缀
	.s MRDiagDesc=prefix_MRDiagDesc
	.s Num=Num+1
	.i MRDiagnos="" D
	..s MRDiagnos=Num_"、"_MRDiagDesc_MRDiagNotes
	.E  D
	..s MRDiagnos=MRDiagnos_"；"_Num_"、"_MRDiagDesc_MRDiagNotes
	Q MRDiagnos
}

/// 获取病人的出院诊断
/// bianshuai  2016/09/21  
/// Debug:	  w ##class(web.DHCSTPHCMCOMMON).GetOutPDiagnosByEpisodeID(1602)
ClassMethod GetOutPDiagnosByEpisodeID(EpisodeID As %String) As %String
{
	N (EpisodeID)
	Q:+EpisodeID=0 ""
	s MRDiagnos="",Num=0
	s INDiaType=$O(^MRC("DTYP",0,"Code","DIS",0)) ;出院诊断
	s mradmId=$p(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$o(^MR(mradmId,"DIA",mrdiaSub)) Q:(mrdiaSub="")  D
	.s TYPMRCDiagTyp=$p(^MR(mradmId,"DIA",mrdiaSub,"TYP",1),"^",1)
	.Q:TYPMRCDiagTyp'=INDiaType
	.s MRDIAICDCodeDR=+$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.//Q:MRDIAICDCodeDR=""
	.s MRDiagDesc=$p($g(^MRC("ID",MRDIAICDCodeDR)),"^",2)    /// 诊断描述
	.s MRDiagNotes=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))   /// 诊断注释
	.i MRDiagNotes'="" s MRDiagNotes=""_MRDiagNotes_""
	.s prefix=$P($G(^MR(mradmId,"DIA",mrdiaSub,1)),"^",26)  //诊断前缀
	.s MRDiagDesc=prefix_MRDiagDesc
	.s Num=Num+1
	.i MRDiagnos="" D
	..s MRDiagnos=Num_"、"_MRDiagDesc_MRDiagNotes
	.E  D
	..s MRDiagnos=MRDiagnos_"；"_Num_"、"_MRDiagDesc_MRDiagNotes
	Q MRDiagnos
}

/// 获取session医院 2016-09-14 sufan
ClassMethod GetSessionHosp(hospdr) As %String
{
	s hospdesc=$p(^CT("HOSP",hospdr),"^",2)
	q hospdesc
}

/// Descript:获取不良反应状态ID
ClassMethod GetAdrStatusIDByCode(adrStatCode As %String) As %String
{
	n (adrStatCode)
	s adrAudStatusDr=$o(^DHCPHADRS(0,"StatusCode",adrStatCode,""))
	q adrAudStatusDr
}

/// Descritp:不良反应状态  
/// w ##class(web.DHCSTPHCMCOMMON).jsonAdrStatus("198^36^578")
ClassMethod jsonAdrStatus(StrParam) As %String
{
	n (StrParam)

	/// 权限对应状态ID
	s currStatusID=##Class(web.DHCSTPHCMCOMMON).GetUserStatusGrant("", StrParam)
	
	/// 上一个流程
	s preStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrPreStatus(currStatusID)
	
	/// 退回状态ID
	s retStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrStatusIDByCode("99")
	
	/// 流程初始状态ID
	s begStatusID=##Class(web.DHCSTPHCMCOMMON).GetAdrStatusIDByCode("10")

	w "["
	i currStatusID '= "" d	//by qunianpeng 2016/11/2
	.w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","W^待审") 
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","A^已审")
	i currStatusID = "" d
	.w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","C^已提交")
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","N^未提交")
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","R^退回")
	w "]"
	q ""
}

/// Descritp:不良反应当前状态的上一步状态值
ClassMethod GetAdrPreStatus(currStatusID As %String) As %String
{
	n (currStatusID)
	q:currStatusID="" ""
	s preStatusID=""
	s statusID="0"
	f  s statusID=$o(^DHCPHADRP(statusID)) q:(statusID="")||(preStatusID'="")  d
	.s nextStatusID=$p(^DHCPHADRP(statusID),"^",2)
	.q:nextStatusID'=currStatusID
	.s preStatusID=$p(^DHCPHADRP(statusID),"^",1)
	q preStatusID
}

/// qnp 从web.DHCLONGTIMEORD中复制出来。去医嘱结束日期和医生
ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub,"ST",chl)) q:(chl="")!($G(cdoc)'="")  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub,"ST",chl),"^",3)
	   .q:statDR'=4
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P($g(^OEORD(Oew,"I",OrdSub, "ST",chl)),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=..DateLogicalToHtml(xdate)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=..DateLogicalToHtml(xdate)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   s XSDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  ;stop date
	   s XSTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   ;stop time
	   s XSCpt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",29)    ;stop doctor
	   if XSCpt'="" d
	   .if XSDate'="" d
	   ..s STR=..DateLogicalToHtml(XSDate)_"|"_$ZT(XSTime,2)_"|"_$P(^CTPCP(XSCpt,1),"^",2)
	   q $G(STR)
}

/// Description: 日期根据demo配置进行转换 (等同于$zd())
/// Creator:     qunianpeng
/// CreateDate:  2017-03-09
/// Input:       日期
/// Output:  	 转换后日期
/// Others:	w ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml()
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	s Date=##class(websys.Conversions).DateLogicalToHtml(date)
	q Date
}

/// Description: 日期根据demo配置进行转换 (等同于$zdh())
/// Creator:     qunianpeng
/// CreateDate:  2017-03-09
/// Input:       日期
/// Output:  	转换后日期
/// Others:	w ##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical()
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	s Date=##class(websys.Conversions).DateHtmlToLogical(date)
	q Date
}

/// Description: js 获取配置日期显示类型
/// Creator:     congyue
/// CreateDate:  2017-03-09
/// Table: 		 
/// Input:       
/// Output:  	 4:"DMY" DD/MM/YYYY 3:"YMD" YYYY-MM-DD  1:"MDY" MM/DD/YYYY
/// Others:	w ##class(web.DHCADVCOMMON).getDateType()	
ClassMethod getDateType() As %String
{
	S DateFormat = ##class(websys.Conversions).DateFormat()
	w "<SCRIPT Language='JavaScript'> var DateFormat='"_DateFormat_"';</SCRIPT>"
}

/// Description: 获取科室描述，用于查询条件的下拉框中(标准版新版 科室取消了拼音码-科室的形式)
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-31	 
/// Input:       查询内容(汉字或者拼音码)
/// Output:  	 id^科室描述 （串）
/// Table:		 CT_LOC
/// Others:	w ##class(web.DHCSTPHCMCOMMON).GetAllLocNewVersion("器械",1)	
ClassMethod GetAllLocNewVersion(input As %String, hospID As %String) As %String
{
	n (input,hospID,%session)
	s input=$zcvt(input,"L")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DESC as locDesc,CTLOC_WardFlag as WardFlag, CTLOC_DateActiveTo as DateActiveTo FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "
	.//旧版(拼音码和描述为分开) s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Code LIKE """_""_input_""_"%"_""_""" "
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s wardflag=result.Data("WardFlag")
		s DateActiveTo=result.Data("DateActiveTo")  
		continue:(DateActiveTo'="")&(DateActiveTo<+$h)  //lbb  2020.2.26 过滤截止日期小于当前日期
		continue:wardflag="Y"      //lbb  2019.7.15  过滤病区
		continue:(hospID'="")&(hospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		s locDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLOC","CTLOCDESC","",locDesc)
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Description: 获取病区描述，用于查询条件的下拉框中(标准版新版 科室取消了拼音码-科室的形式)
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-31	 
/// Input:       查询内容(汉字或者拼音码)
/// Output:  	 id^科室描述 （串）
/// Table:		 PAC_WARD
/// w ##class(web.DHCSTPHCMCOMMON).GetAllWardNewVersion("xnk")
ClassMethod GetAllWardNewVersion(input As %String, hospID As %String) As %String
{
	n (input,hospID,%session)
	s input=$zcvt(input,"L")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT Ward_Rowid As WardID,Ward_Desc As WardDesc,WARD_LocationDR As Locdr FROM PAC_WARD"
	i input'="" d
	.s sqlStr=sqlStr_" WHERE WARD_LocationDR->CTLOC_Desc LIKE """_""_input_""_"%"_""" OR WARD_LocationDR->CTLOC_ContactName LIKE """_""_input_""_"%"_""_""" "
	.//旧版(拼音码和描述为分开) s sqlStr=sqlStr_" WHERE WARD_LocationDR->CTLOC_Code LIKE """_""_input_""_"%"_""" OR WARD_LocationDR->CTLOC_ContactName LIKE """_""_input_""_"%"_""_""" "
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s WardDr = result.Data("WardID")
		s WardDesc = result.Data("WardDesc")
		s Locdr=result.Data("Locdr")
		continue:(WardDesc["停")||(WardDesc["工作量")
		continue:(hospID'="")&(hospID'=$p(^CTLOC(Locdr),"^",22))
		s WardDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWARD","WardDesc","",WardDesc)
		s tmp=WardDr_"^"_WardDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Description:	判断医嘱是否执行
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-12
/// Input:			医嘱表id,sub
/// return:			执行标志（Y/N 执行/未执行）
/// other:			长嘱执行一次即认为是执行
/// w ##class(web.DHCSTPHCMCOMMON).CheckIfExec(5326,85) CheckIfSend/CheckIfExec
ClassMethod CheckIfExec(oeord As %String, oeordSub As %String) As %String
{
	n (oeord,oeordSub)	
	
	s execSub="",execFlag="N"
	f  s execSub=$o(^OEORD(oeord,"I",oeordSub,"X",execSub)) q:(execSub="")||(execFlag="Y")  d
	.s execStatus=$p(^OEORD(oeord,"I",oeordSub,"X",execSub),"^",16)
	.q:execStatus=""
	.s execStatus=$p(^OEC("STAT",execStatus),"^",1)
	.s:execStatus="F" execFlag="Y"
	
	q execFlag
}

/// Description:	判断医嘱是否发药
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-12
/// Input:			医嘱表id,sub
/// return:			发药标志（Y/N 发药/未发药）
/// other:			长嘱发药一次即认为是发药
/// w ##class(web.DHCSTPHCMCOMMON).CheckIfSend(5326,85)
ClassMethod CheckIfSend(oeord As %String, oeordSub As %String) As %String
{
	n (oeord,oeordSub)	
	
	s oeordItem=oeord_"||"_oeordSub
	s dspID="",sendFlag="N"
	f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeordItem,dspID)) q:(dspID="")||(sendFlag="Y")  d
	.s dspStat=$p(^DHCOEDISQTY(dspID),"^",7)
	.q:dspStat=""
	.s:dspStat="C" sendFlag="Y"

	q sendFlag
}

/// Description:	获取医嘱的关联主医嘱
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-13
/// Input:			医嘱表id
/// return:			有则返回主医嘱id，否则返回空
/// other:			
/// w ##class(web.DHCSTPHCMCOMMON).GetMainOeoriNew("5326||2")
ClassMethod GetMainOeoriNew(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q ""
}

/// Description:	获取电子病历中病人常用信息
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-13
/// Input:			就诊id
/// return:			信息串
/// other:			
/// w ##class(web.DHCSTPHCMCOMMON).GetPatInfoByEmr(4538)
ClassMethod GetPatInfoByEmr(adm As %String) As %String
{
	s result = ##Class(%ResultSet).%New("web.DHCCM.EMRservice.SystemData:GetPatRecordInfo")
	s sc = result.Execute(adm)
	s data=""
	While (result.Next())
 	{
	 	s patPriActDesc = result.Data("ChiefCom")		/// 主诉
	 	s patHPCDesc = result.Data("CurrentMed")		/// 现病史
	 	s patPMHisDesc = result.Data("PastHistory")		/// 既往病史->contagDesc 传染病用药 chronDesc 慢性病用药 AllHisDrgDesc 过敏史用药  TransfDesc 输血史用药
	 	s patPerHisDesc = result.Data("Personal")		/// 个人史-> smokHisDesc 吸烟史  drinkHisDesc 饮酒史  toxExpHisDesc 毒物接触史  visProHisDesc 冶游史
	 	s patFamHisDesc = result.Data("Family")			/// 家族史
	 	s patAllHisDesc = result.Data("Allergy")		/// 过敏史
	 	s patMarryHistory = result.Data("MarryHistory")  	/// 婚育史
		s patMenstruation = result.Data("Menstruation")  	/// 月经史		
		s patExamination = result.Data("Examination")		/// obj.GetAt("HDSD00.13.088")   ///体格检查
		s patAssist = result.Data("Assist")   				/// 辅助检查
		s patConsultations = result.Data("Consultations") 	/// 四诊概要
		s patSpecialist = result.Data("Specialist")   		/// 专科检查
		s patPMDrgHisDesc = result.Data("patPMDrgHisDesc")		/// 既往用药史->contagDesc 传染病	chronDesc 慢性病  rtumHisDesc 外伤史 operHisDesc 手术史 TransfDesc 输血史
		s patPriActDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patPriActDesc)
		s patHPCDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patHPCDesc)
		s patPMHisDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patPMHisDesc)
		s patPerHisDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patPerHisDesc)
		s patFamHisDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patFamHisDesc)
		s patAllHisDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patAllHisDesc)
		s patMarryHistory=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patMarryHistory)
		s patMenstruation=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patMenstruation)
		s patExamination=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patExamination)
		s patAssist=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patAssist)
		s patConsultations=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patConsultations)
		s patSpecialist=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patSpecialist)
		s patPMDrgHisDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patPMDrgHisDesc)
		s data=patPriActDesc_"@"_patHPCDesc_"@"_patPMHisDesc_"@"_patPerHisDesc_"@"_patFamHisDesc_"@"_patAllHisDesc_"@"_patMarryHistory
		s data=data_"@"_patMenstruation_"@"_patExamination_"@"_patAssist_"@"_patConsultations_"@"_patSpecialist
 	}
	q data
}

/// 统一取最大进程号
ClassMethod GetPID() As %String
{
	   s pid=$I(^DHCST("DHCSTPHCM"))
	   q pid
}

/// Description:	获取医生站病人常用信息
/// Creator:		lbb
/// CreateDate:		2020-02-05
/// Input:			就诊id
/// return:			过敏记录
/// other:			
/// w ##class(web.DHCSTPHCMCOMMON).GetPatAllergies(4538)
ClassMethod GetPatAllergies(PatientID As %String) As %String
{
	s result = ##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:Allergies")
	s sc = result.Execute(PatientID)
	s data=""
	While (result.Next())
 	{
	 	s patALGItem = result.Data("ALGItem")		/// 过敏项目
	 	s patALGItem=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(patALGItem)
	 	i data=""  s data=patALGItem		
		e  s data=data_";"_patALGItem
 	}
	q data
}

// 

// w ##class(web.DHCSTPHCMCOMMON).checkpatFlag("0000000138",2)

/// Description:	增加根据登记号判断患者是否为该院区患者，0代表是，1代表不是
/// Creator:		lbb
/// CreateDate:		2020-06-12
/// Input:			登记号 ,医院id
ClassMethod checkpatFlag(patNo As %String, hospID As %String) As %String
{
   
    n (patNo,hospID)
    s flag=""
	s papmi=$o(^PAPERi("PAPMI_PatNo",patNo,""))
	q:papmi="" ""
	s flag=..GetLastAdm(papmi,hospID)
	q flag
}

/// w ##class(web.DHCSTPHCMCOMMON).GetLastAdm("0000000138",2)
/// Description:	增加根据患者id取最后一条就诊记录
ClassMethod GetLastAdm(papmi As %String, hospID As %String) As %String
{
   
    n (papmi,hospID)
	s type="",flag="",ret=""
	f  s type=$o(^PAPERdr(papmi,"ADM",type),-1) q:((type="")||(flag=1))  d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAPERdr(papmi,"ADM",type, AdmDr),-1) q:((AdmDr="")||(flag=1))  d
	..s Locdr=$p(^PAADM(AdmDr),"^",4)
	..s diag=##class(PHA.COM.Order).MrDiagnose(AdmDr,",")
	..i (hospID'="")&(diag'="")&(hospID=$p($g(^CTLOC(Locdr)),"^",22))  d  //过滤病区
	...s flag=1
	...s ret=AdmDr
	q ret
}

/// w ##class(web.DHCSTPHCMCOMMON).GetPatInfoByCardNo("0199991999")
ClassMethod GetPatInfoByCardNo(CardNo As %String, hospID As %String) As %String
{
	n (CardNo,hospID)
	Q:CardNo="" ""
	s ret=""
 	s CFRowID="0"
	f  s CFRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowID))  Q:CFRowID=""  D
 	.s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
 	.q:ActiveFlag'="N"
 	.s papmi=$p(^DHCCARD("CF",CFRowID),"^",4)
 	.s PatName=$p(^PAPER(papmi,"ALL"),"^",1) 		/// 姓名
	.s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1) 		/// 登记号	
	.s SexId=$p(^PAPER(papmi,"ALL"),"^",7 )  		/// 姓别
	.s PatSex=$p(^CT("SEX",SexId),"^",2)
	.;s type=""
	.;s type=$o(^PAPERdr(papmi,"ADM",type),-1)
	.s EpisodeID=..GetLastAdm(papmi,hospID) //$o(^PAPERdr(papmi,"ADM","I",""),-1)
	.s PatAge=##class(PHA.FACE.IN.Com).GetAge(papmi, EpisodeID)  //年龄 //##class(web.DHCSTKUTIL).GetAge(papmi)  /// 年龄
	.s patdiag=##class(PHA.COM.Order).MrDiagnose(EpisodeID,",")  //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	.s patTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)     //电话
	.s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    .s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	.s patdiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",patdiag)
 	.s ret=papmi_"^"_CardNo_"^"_PatName_"^"_SexId_"^"_PatAge_"^"_patdiag_"^"_PatNo_"^"_patTel
 	q ret
}

/// w ##class(web.DHCSTPHCMCOMMON).GetPatInfoByPatNo("0000000138",2)
ClassMethod GetPatInfoByPatNo(PatientNo As %String, hospID As %String) As %String
{
	n (PatientNo,hospID)
	s ret="",CardNo=""
 	s papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNo),""))
 	q:papmi="" ""
 	s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""))
 	s:CFRowID'="" CardNo=$p($g(^DHCCARD("CF",CFRowID)),"^",2)
 	s PatName=$p(^PAPER(papmi,"ALL"),"^",1) 		/// 姓名
	s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1) 		/// 登记号	
	s SexId=$p(^PAPER(papmi,"ALL"),"^",7 )  		/// 姓别
	s PatSex=$p(^CT("SEX",SexId),"^",2)
	;s type=""
	;s type=$o(^PAPERdr(papmi,"ADM",type),-1)
	s EpisodeID=..GetLastAdm(papmi,hospID) //$o(^PAPERdr(papmi,"ADM","I",""),-1)
	s PatAge=##class(PHA.FACE.IN.Com).GetAge(papmi, EpisodeID)  //年龄 //##class(web.DHCSTKUTIL).GetAge(papmi)  /// 年龄
	s patdiag=##class(PHA.COM.Order).MrDiagnose(EpisodeID,",") //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s patTel=$p($g(^PAPER(papmi,"PER",1)),"^",11)     //电话
	s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s patdiag=##class(PHA.FACE.IN.Com).GetTransDesc("User.MRCICDDx","MRCIDDesc","",patdiag)
 	s ret=papmi_"^"_CardNo_"^"_PatName_"^"_SexId_"^"_PatAge_"^"_patdiag_"^"_PatNo_"^"_patTel
 	q ret
}

/// Description:	判断医嘱是否审核
/// Creator:		lbb
/// CreateDate:		2019-11-28
/// Input:			医嘱表id,sub
/// return:			审核标志（Y/N 审核/未审核）
/// other:			有一次状态为0即为审核
/// w ##class(web.DHCSTPHCMCOMMON).CheckIfAudit("795||19") 
ClassMethod CheckIfAudit(orditm As %String) As %String
{
	n (orditm)	
	s phaRowid="",AuditFlag=""
	f  s phaRowid=$o(^DHCPHAD(0,"OEORI",orditm,phaRowid)) q:(phaRowid="")||(AuditFlag="Y")  d
	.s AuditStatus=$p(^DHCPHAD(phaRowid),"^",6)
	.q:AuditStatus=""
	.i AuditStatus="0" s AuditFlag="Y"
	.e  s AuditFlag="N"
	q AuditFlag
}

}
