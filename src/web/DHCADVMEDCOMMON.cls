Import Sqluser

/// 医疗不良事件公共类  20150905
Class web.DHCADVMEDCOMMON Extends %Persistent [ Not ProcedureBlock ]
{

/// 统一取最大进程号
ClassMethod GetPID() As %String
{
	   s pid=$I(^DHCST("DHCADVREPORT"))
	   q pid
}

/// Descript:获取病人基本就诊信息
/// Creator:LiangQiang
/// Input:病人ID，就诊ID
/// Return:病人基本信息
ClassMethod GetPatBaseInfo(PatNo As %String, EpisodeID As %String) As %String
{
	n (PatNo, EpisodeID)
    s PatientID=""
    i PatNo'="" d
    .s PatientID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
    
    .s admtype=$o(^PAPERdr(PatientID,"ADM",""),-1)
    .s EpisodeID=$o(^PAPERdr(PatientID,"ADM",admtype,""),-1)
 
	i EpisodeID'="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	q:PatientID="" ""
	
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	s patSex=""
	i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
	s birthday=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	s nationdr=$p(^PAPER(PatientID,"PER",2),"^",1) //民族
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
	i birthday'="" s birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(birthday)
	s patAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	s natplace=""    //籍贯
	s patWeight=##class(web.DHCSTCNTSCOMMON).GetPatWeight(EpisodeID) //体重
	s patHeight=##class(web.DHCSTCNTSCOMMON).GetPatHeight(EpisodeID) //身高
	s patTel=""      //电话
	s idcard=""      //身份证
	s workunit=""    //工作单位
	s medicalNo=patNo //##Class(web.DHCWMRService).IGetMrNoByEpisodeID(AdmDr) //病案号
	
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
	i AdmDate'="" S AdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdmDate)
	i AdmTime'="" S AdmTime=$zt(AdmTime,1)
	//s AdmTime=AdmDate_" "_AdmTime
	
	s patdiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s allergy=""  //过敏史


	s ListData=PatientID_"^"_EpisodeID_"^"_patNo_"^"_patName_"^"_sexId_"^"_patSex_"^"_patAge
	s ListData=ListData_"^"_birthday_"^"_nationdr_"^"_nation_"^"_medicalNo_"^"_natplace_"^"_patWeight
	s ListData=ListData_"^"_patHeight_"^"_patTel_"^"_workunit_"^"_idcard_"^"_patdiag_"^"_allergy
	s ListData=ListData_"^"_AdmDoc_"^"_AdmLoc_"^"_AdmWard_"^"_AdmBed_"^"_AdmTime_"^"_AdmDate
	
	q ListData
}

/// Descript:获取报告的当关状态
/// Creator:LiangQiang
/// Input:病人ID，就诊ID
/// Return:病人基本信息
ClassMethod GetCurRepStatus(adrRepID As %String, RepType As %String) As %String
{
	n (adrRepID,RepType)
	s statudr="",statusdesc=""
	s repadtdr=$o(^DHCMEDREPADT(0,"Pointer",RepType,adrRepID,""),-1)
	i repadtdr'="" d
	.s statudr=$p(^DHCMEDREPADT(repadtdr),"^",3)
	.i statudr'="" s statusdesc=$p(^DHCPHADRS(statudr),"^",2)
	q statudr_"^"_statusdesc
}

/// Descript:获取当前状态的下一个状态
ClassMethod getNextStauts(curStatusID, RepType) As %Library.String
{
	n (curStatusID,RepType)
    s exit=0
	i curStatusID="" d
	.s statusid=""
	.f  s statusid=$o(^DHCPHADRP(0,"NextStatus",statusid)) q:(statusid="")||(exit=1)  d
	..s typedr=$p(^DHCPHADRS(statusid),"^",3)
	..s type=$p(^DHCMEDADREVT(typedr),"^",1)
	..i type=RepType d
	...s nextStatusID=statusid
	...s exit=1
	...
	e  d
	.s nextStatusID=$o(^DHCPHADRP(0,"NextStatus",curStatusID,""))
	q:$g(nextStatusID)="" ""
	s statusdesc=$p(^DHCPHADRS(nextStatusID),"^",2)
	q nextStatusID_"^"_statusdesc
}

/// Descript:获取当前状态的下一个状态
ClassMethod GetRepNextStauts(adrRepID, RepType) As %Library.String
{
	n (adrRepID ,RepType)
	
	s curdata=..GetCurRepStatus(adrRepID,RepType)
	s curStatusDr=$p(curdata,"^",1)

	s nextdata=..getNextStauts(curStatusDr,RepType)
    q nextdata
}

/// Descript:判断是否可以编辑
/// Input:报告id ，GroupId^LocId^UserId
/// Return:0不可编辑,1可编辑
ClassMethod CheckRepEditFlag(adrRepID As %String, Params As %String) As %Library.String
{
	n (adrRepID,Params)
	
	s ret=0
	
	s GroupId=$p(Params,"^",1)
	s LocId=$p(Params,"^",2)
	s UserId=$p(Params,"^",3)
	
	s AdrRepStatusID=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	i AdrRepStatusID="" d
	.s creator=$p(^DHCMEDADRR(adrRepID),"^",19) //报告人
	.i UserId=creator s ret=1
	
	i AdrRepStatusID'="" d
	.s NextStatusData=##class(web.DHCADVMEDCOMMON).getNextStauts(AdrRepStatusID)
	.s NextStatusID=$p(NextStatusData,"^",1)
	.i NextStatusID="" s ret=0
	.e  s ret=##class(web.DHCADVMEDCOMMON).GetUserStatusGrant(Params,NextStatusID)

	
	q ret
}

/// 检查当前人员是否有下一个状态权限
ClassMethod GetUserStatusGrant(StrParam As %String = "", nextStatusID = "") As %Library.String
{
	N (StrParam,nextStatusID)
	S ret=0

	s GroupId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s UserId=$p(StrParam,"^",3)
	
	//优先按人取配置
	i (UserId'="") d
	.i $d(^DHCPHADRS(0,"TypePointer","U",UserId,nextStatusID)) s ret=1
	

	//不存在按人的定义，则按安全组取
	i (GroupId'="") d
	.i $d(^DHCPHADRS(0,"TypePointer","G",GroupId,nextStatusID)) s ret=1
	.

    //不存在按人和安全组的定义，则按科室取
	i (LocId'="") d
	.i $d(^DHCPHADRS(0,"TypePointer","L",LocId,nextStatusID)) s ret=1
	.

	Q ret
}

/// Descript:不良反应报告审批流程
ClassMethod InsAdrRepAudit(adrrRepID As %String, adrRepAuditdataList As %String) As %String
{
	N (adrrRepID,adrRepAuditdataList)
	s type="med"
	S adrAudStatus=##class(web.DHCADVMEDCOMMON).GetRepNextStauts(adrrRepID,type)  
	
	S adrAudStatusDr=$p(adrAudStatus,"^",1)
	q:adrAudStatusDr="" 0 //结束
	S AuditUserID=$p(adrRepAuditdataList,"^",1)    //审核人
	S adrAuditDate=+$h   //审核日期
	S adrAuditTime=$p($h,",",2)   //审核时间
	s redlocdr=$p(adrRepAuditdataList,"^",2)  //接收科室
	&SQL(Insert into DHC_MedAdrRepAudit(MEDADR_Pointer,MEDADR_Type,MEDADR_Status_DR,MEDADR_AuditUser_DR,
		MEDADR_AuditDate,MEDADR_AuditTime,MEDADR_NextLoc_DR) 
		Values(:adrrRepID,:type,:adrAudStatusDr,:AuditUserID,:adrAuditDate,:adrAuditTime,:redlocdr))
	Q SQLCODE
}

/// Descript:获取不良事件类别信息
/// W ##class(web.DHCADVMEDCOMMON).QueryAdvTypeInfoList("30","1")
ClassMethod QueryAdvTypeInfoList(rows, page) As %String
{
	n (rows, page)
	s rows=100
	s page=1
	s pid=##class(web.DHCADVMEDCOMMON).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	
	s h=0
	s rowid=""
	f  s rowid=$o(^DHCADVTYPE(rowid)) q:rowid=""  d
	.s desc=$p(^DHCADVTYPE(rowid),"^",1)
	.s h=h+1
	.s data=desc_"^"_rowid
	.s ^TMP("DHCST","DHCADVMEDCOMMON","QueryAdvTypeInfoList",pid,h)=data
	
	q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCADVMEDCOMMON","QueryAdvTypeInfoList",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCADVMEDCOMMON","QueryAdvTypeInfoList",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCADVJSONCOMMON).GetJsonFirstCell("desc",desc)
	.s rowid=##class(web.DHCADVJSONCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCADVJSONCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCADVJSONCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCADVJSONCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
	k ^TMP("DHCST","DHCSTPHCMADDINST","QueryAdvTypeInfoList",pid)
	    
    q ""
}

//w ##class(web.DHCADVMEDCOMMON).QueryDocLocList("180","1","")

ClassMethod QueryDocLocList(rows, page) As %String
{
   n (rows, page)
   s pid=##class(web.DHCADVMEDCOMMON).GetPID()
   
   s endpage=page*rows  //结束行
   s stpage=((page-1)*rows)+1 //开始行
   s h=0
   s locdr=""
   f  s locdr=$o(^CTLOC(locdr)) q:locdr=""  d
   .s code=$p(^CTLOC(locdr),"^",1)
   .s desc=$p(^CTLOC(locdr),"^",2)

   .s rowid=locdr
   .s data=code_"^"_desc_"^"_rowid
   .
   .s h=h+1
   .s index=h
   .s ^TMP("DHCST","DHCADVMEDCOMMON ","QueryDocLocList",pid,"Data",index)=data
   q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
   
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
	s count=0
	
	s index=""
	f  s index=$o(^TMP("DHCST","DHCADVMEDCOMMON ","QueryDocLocList",pid,"Data",index)) q:index=""  d
	.s data=^TMP("DHCST","DHCADVMEDCOMMON ","QueryDocLocList",pid,"Data",index)
	.s code=$p(data,"^",1)
	.s desc=$p(data,"^",2)
	.s rowid=$p(data,"^",3)
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage

  	.s desc=##class(web.DHCADVJSONCOMMON).JsonCell("desc",desc)
	.s rowid=##class(web.DHCADVJSONCOMMON).JsonCell("rowid",rowid)
	.s tmpstr=desc_","_rowid
	.
    .i count=stpage w "[{"_tmpstr
    .i (count'=stpage)&(count<endpage) w "},{"_tmpstr
    .i (count=endpage) d
    ..i (count>1) d
    ...w "},{"_tmpstr_"}]"
	..e  d
	...w "}]"
    .
	k ^TMP("DHCST","DHCADVMEDCOMMON ","QueryDocLocList",pid)
	q ""
}

//验证科室

ClassMethod CheckAdtRecLoc(adrRepID As %String, LocDr, Type) As %Library.String
{
	n (adrRepID, LocDr,Type)
	
	i $D(^DHCMEDREPADT(0,"PointerNext",Type,adrRepID,LocDr)) q 1
	q 0
}

/// 查询日志
/// w ##class(web.DHCADVMEDCOMMON).QueryRepAuditLog("100","1","med^31")
ClassMethod QueryRepAuditLog(rows, page, params) As %String
{
	n (rows, page,params)
	s pid=##class(web.DHCADVMEDCOMMON).GetPID()
	
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1 //开始行
	s Num=0
	s RepTypeCode=$p(params,"^",1)
	s adrRepID=$p(params,"^",2)
	s h=0
	s rowid=""
	
	f  s rowid=$o(^DHCMEDREPADT(0,"Pointer",RepTypeCode,adrRepID,rowid)) q:rowid=""  d
	.s StatusDR=$p(^DHCMEDREPADT(rowid),"^",3)
	.s StatusDesc=""
	.i StatusDR'="" s StatusDesc=$p(^DHCPHADRS(StatusDR),"^",1)
	.s adtuserdr=$p(^DHCMEDREPADT(rowid),"^",4)
	.s adtuser=""
	.i adtuserdr'="" s adtuser=$p(^SSU("SSUSR",adtuserdr),"^",2)
	.s adtdate=$p(^DHCMEDREPADT(rowid),"^",5)
	.i adtdate'="" s adtdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(adtdate)
	.s adttime=$p(^DHCMEDREPADT(rowid),"^",6)
	.i adttime'="" s adttime=$zt(adttime,1)
	.s adtlocdr=$p(^DHCMEDREPADT(rowid),"^",7)
	.s adtlocdesc=""
	.i adtlocdr'="" s adtlocdesc=$p(^CTLOC(adtlocdr),"^",2)
	.s Num=Num+1
	.s data=StatusDesc_"^"_adtuser_"^"_adtdate_"^"_adttime_"^"_adtlocdesc_"^"_rowid
	.s ^TMP("DHCST","DHCADVMEDCOMMON","QueryRepAuditLog",pid,Num)=data
	
	q:Num=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCADVMEDCOMMON","QueryRepAuditLog",pid,h)) q:(h="")||(quitflag="1")  d
    .s mdata=^TMP("DHCST","DHCADVMEDCOMMON","QueryRepAuditLog",pid,h)
    .
	.S Title="StatusDesc^AdtUser^AdtDate^AdtTime^AdtLocDesc^AdtRowid"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	
	k ^TMP("DHCST","DHCADVMEDCOMMON","QueryRepAuditLog",pid)
	
	q ""
}

/// Description:获取当前病人就诊列表
/// Input:登记号
/// Output:就诊列表
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod GetAdmDs(RegNo As %String) As %Integer
{
	 s page="1"
	 s rows="100"
	 s End = page*rows
	 s Start=(page-1)*rows+1
	
	 S pid=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	 s n=0
	 s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	 q:papmi="" ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串
	 s adm="" 
	 f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	 .q:$p(^PAADM(adm),"^",2)'="I"  
	 .s depDesc=""    
	 .s depcodedr=$p(^PAADM(adm),"^",4) 
	 .i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	 .i depDesc'="" s depDesc=$p(depDesc,"-",2)
	 .s admdate=$p(^PAADM(adm),"^",6) 
	 .i +admdate>0 s admdate=##class(web.DHCADVCOMMON).DateLogicalToHtml(admdate) 
	 .s admtime=$p(^PAADM(adm),"^",7) 
	 .i +admtime>0 s admtime=$zt(admtime)
	 .s curWardDesc=""
	 .s curWard=$p(^PAADM(adm),"^",70) 
	 .i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	 .i curWardDesc'="" s curWardDesc=$p(curWardDesc,"-",2)
	 .s curBedcode=""
	 .s curBed=$p(^PAADM(adm),"^",73) i curBed'="" d
	 ..s w=+curBed,b=$p(curBed,"||",2) q:(w="")!(b="")
	 ..s curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	 .s doctor=$p(^PAADM(adm),"^",9)
	 .i doctor'=""  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	 .s n=n+1
	 .s data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)_"^"_+$g(curWard)_"^"_RegNo
	 .s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,n)=data
     w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(n) //输出json前缀串
     q:n=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign() //输出空的json串
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid,h)
     .s count = count+1
	 .s Title="Adm^AdmLoc^AdmDate^AdmTime^CurrWard^CurrBed^CurrDoc^CurrWardID^RegNo"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	 k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetAdmDs",pid)
     q ""
}

Storage Default
{
<Data name="DHCADVMEDCOMMONDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCADVMEDCOMMOND</DataLocation>
<DefaultData>DHCADVMEDCOMMONDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCADVMEDCOMMOND</IdLocation>
<IndexLocation>^web.DHCADVMEDCOMMONI</IndexLocation>
<StreamLocation>^web.DHCADVMEDCOMMONS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
