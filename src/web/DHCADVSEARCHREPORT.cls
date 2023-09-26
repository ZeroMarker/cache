Import sqluser

Class web.DHCADVSEARCHREPORT Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 查询不良反应报告（已提交）
/// Creator:     CongYue
/// CreateDate:  2015-12-21  （改）
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间^科室id^病人登记号^安全组ID^科室ID^人员ID^状态^报告类型^接收状态
/// Output:   	 报告id^报告日期^报告编码^病人登记号^病人姓名^操作人^科室描述^当前状态^报告类型^下一状态^下一状态id^接收状态^报告类型代码 
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryMataReport("30","1","2016-08-31^2016-09-29^^^178^63^1061^^^^") 2016-08-31^2016-10-10^^^123^100^4^^1^^
/// w ##class(web.DHCADVSEARCHREPORT).QueryMataReport("40","1","01/01/2017^29/01/2018^^^118^400^9^^^^") 
ClassMethod QueryMataReport(rows As %String, page As %String, StrParam As %String) As %String
{
	N (rows,page,StrParam)
	s ^qnp=$lb(rows,page,StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	S GroupId=$p(StrParam,"^",5)   //安全组ID
    S LocId=$p(StrParam,"^",6)     //科室ID
    S UserId=$p(StrParam,"^",7)    //用户ID
    S StatType=$p(StrParam,"^",8)  //状态
    I StatType="全部" S StatType=""
    S typeevent=$p(StrParam,"^",9)    //填报类型
    S receive=$p(StrParam,"^",10)    //接收状态
    S statShare=$p(StrParam,"^",11)    //分享状态
    
    S DealMeth="" ;$p(StrParam,"^",11)    //处理办法
    S ImpMeth=$p(StrParam,"^",12)    //改进办法
    S Level=$p(StrParam,"^",13)    //事件等级
    S armaCat=$p(StrParam,"^",14)    //事件类别
    
    S Params=GroupId_"^"_LocId_"^"_UserId
	S list=UserId_"^"_LocId_"^"_GroupId
    ///获取授权审批状态
	D ..killTmpGlobal(pid)
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	S QuitFlag=0
	S Num=0
	F dd=StDate:1:EndDate D
	.S ID=""
	.//器械报告
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..;zhaowuqiang  2016-09-23
	..S ReportType=$p(^DHCMATADRR(ID),"^",46) //报告类型   //zhaowuqiang 2016-09-22
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",StatusLast="",StatusLastID="",AssessRowID="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..;s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))  //zhaowuqiang 2016-09-22
	..s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",ReportType,ID,""))  //zhaowuqiang 2016-09-22
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别 
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
	
	..S StatusID=$p(^DHCMATADRR(ID),"^",41) //当前状态
	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S TypeFlowID=$o(^DHCADREVTWF(0,"Event",TypeeventDr,"")) ;2016-09-29
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S AssessRowID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,"")) //评估明细 2016-10-13
	...S Subflag=0
	...S SubUserflag=0 ;2016-09-29
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrRowID),"^",4)
	....S StaFistAuditDr=""
	....S:(ReportType'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, ReportType, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag=1 Subflag=1 //转抄 ;2016-09-29
	...S:Medadrflag=2 Subflag=2 //全部回复 ;2016-09-29
	...S:Medadrflag=3 Subflag=3 //部分回复 ;2016-09-29
	...
	...S params=ID_"^"_typecode_"^"_UserId_"^"_LocId ;2016-09-29
	...S SubUserflag=..SearchAuditIUser(MedadrID,params) ;2016-09-29
	...
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCMATADRR(ID),"^",1)   //编号
	..S RepImp=$p(^DHCMATADRR(ID),"^",47)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCMATADRR(ID),"^",39)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCMATADRR(ID),"^",5)   //登记号
	..S PatName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S CreatorCode=$p(^DHCMATADRR(ID),"^",35)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCMATADRR(ID),"^",36)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..;2016-09-29
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"

	..Q:flag'=1
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeFlowID) ;2016-09-29  wangxuejian 2016-10-17
	..Q:(receive'="")&(receive'[Medadrreceivedr) ;2016-09-29
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..;zhaowuqiang  2016-09-23 ;2016-09-29
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_Status_"^"_Typeevent_"^"_StatusNext_"^"_StatusNextID_"^"_Medadrreceive_"^"_Medadrreceivedr_"^"_typecode_"^"_StatusID_"^"_RepImpFlag_"^"_shareStatus_"^"_Subflag_"^"_SubUserflag_"^"_armaCatDr_"^"_armaLevelDr_"^"_armaCatDesc_"^"_armaLevelDesc_"^"_catDesc_"^"_AssessRowID_"^"_TypeeventDr_"^"_StaFistAuditUser_"^"_BackAuditUser
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,Num)=ListData
	.
	.//用药安全报告
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..;zhaowuqiang  2016-09-23
	..S ReportType=$p(^DHCADVMEDSAR(ID),"^",20) //报告类型   //zhaowuqiang 2016-09-22
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",StatusLast="",StatusLastID="",AssessRowID="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..;s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))   //zhaowuqiang 2016-09-22
	..s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",ReportType,ID,""))   //zhaowuqiang 2016-09-22
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
	
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18) //当前状态
	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S TypeFlowID=$o(^DHCADREVTWF(0,"Event",TypeeventDr,"")) //获取工作流ID ;2016-09-29
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S AssessRowID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,"")) //评估明细 2016-10-13
	...S Subflag=0
	...S SubUserflag=0 ;2016-09-29
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrRowID),"^",4)
	....S StaFistAuditDr=""
	....S:(ReportType'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, ReportType, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...; 2016-09-29
	...S:Medadrflag=1 Subflag=1 //转抄
	...S:Medadrflag=2 Subflag=2 //全部回复
	...S:Medadrflag=3 Subflag=3 //部分回复
	...
	...S params=ID_"^"_typecode_"^"_UserId_"^"_LocId
	...S SubUserflag=..SearchAuditIUser(MedadrID,params)
	...
	
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVMEDSAR(ID),"^",19)   //编号
	..S RepImp=$p(^DHCADVMEDSAR(ID),"^",23)    //重要标记
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVMEDSAR(ID),"^",2)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVMEDSAR(ID),"^",8)   //登记号
	..S PatName=$p(^DHCADVMEDSAR(ID),"^",9)     //病人姓名
	..S CreatorCode=$p(^DHCADVMEDSAR(ID),"^",15)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVMEDSAR(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..; 2016-09-29
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeFlowID) ;2016-09-29  wangxuejian 2016-10-17
	..Q:(receive'="")&(receive'[Medadrreceivedr) ;2016-09-29
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..;zhaowuqiang  2016-09-23 ;2016-09-29
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_Status_"^"_Typeevent_"^"_StatusNext_"^"_StatusNextID_"^"_Medadrreceive_"^"_Medadrreceivedr_"^"_typecode_"^"_StatusID_"^"_RepImpFlag_"^"_shareStatus_"^"_Subflag_"^"_SubUserflag_"^"_armaCatDr_"^"_armaLevelDr_"^"_armaCatDesc_"^"_armaLevelDesc_"^"_catDesc_"^"_AssessRowID_"^"_TypeeventDr_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,Num)=ListData
	.
	.//输血报告
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID)) Q:ID=""  D
	..;zhaowuqiang  2016-09-23
	..S ReportType=$p(^DHCBLDADVRPT(ID),"^",47) //报告类型   //zhaowuqiang 2016-09-22
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",StatusLast="",StatusLastID="",AssessRowID="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..;s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))   //zhaowuqiang 2016-09-22
	..s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",ReportType,ID,""))   //zhaowuqiang 2016-09-22
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
	
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46) //当前状态
	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S TypeFlowID=$o(^DHCADREVTWF(0,"Event",TypeeventDr,"")) //获取工作流ID ;2016-09-29
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S AssessRowID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,"")) //评估明细 2016-10-13
	...S Subflag=0
	...S SubUserflag=0 ;2016-09-29
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrRowID),"^",4)
	....S StaFistAuditDr=""
	....S:(ReportType'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, ReportType, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...; 2016-09-29
	...S:Medadrflag=1 Subflag=1 //转抄
	...S:Medadrflag=2 Subflag=2 //全部回复
	...S:Medadrflag=3 Subflag=3 //部分回复
	...
	...S params=ID_"^"_typecode_"^"_UserId_"^"_LocId
	...S SubUserflag=..SearchAuditIUser(MedadrID,params)
	...
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCBLDADVRPT(ID),"^",3)   //编号
	..S RepImp=$p(^DHCBLDADVRPT(ID),"^",48)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCBLDADVRPT(ID),"^",4)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCBLDADVRPT(ID),"^",9)   //登记号
	..S PatName=$p(^DHCBLDADVRPT(ID),"^",10)     //病人姓名
	..S CreatorCode=$p(^DHCBLDADVRPT(ID),"^",2)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCBLDADVRPT(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..;2016-09-29
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeFlowID) ;2016-09-29  wangxuejian 2016-10-17
	..Q:(receive'="")&(receive'[Medadrreceivedr) ;2016-09-29
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..;zhaowuqiang  2016-09-23 ;2016-09-29
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_Status_"^"_Typeevent_"^"_StatusNext_"^"_StatusNextID_"^"_Medadrreceive_"^"_Medadrreceivedr_"^"_typecode_"^"_StatusID_"^"_RepImpFlag_"^"_shareStatus_"^"_Subflag_"^"_SubUserflag_"^"_armaCatDr_"^"_armaLevelDr_"^"_armaCatDesc_"^"_armaLevelDesc_"^"_catDesc_"^"_AssessRowID_"^"_TypeeventDr_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,Num)=ListData
	.
	.//医疗不良事件liangqiang   
	.S adrRepID=""
	.F  S adrRepID=$o(^DHCMEDADRR(0,"CreateDate",dd,adrRepID)) Q:adrRepID=""  D
	..;zhaowuqiang  2016-09-23
	..S ReportType=$p(^DHCMEDADRR(adrRepID),"^",30) //报告类型   //zhaowuqiang 2016-09-22
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",StatusLast="",StatusLastID="",AssessRowID="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..;s armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,""))   //zhaowuqiang 2016-09-22
	..s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",ReportType,adrRepID,""))   //zhaowuqiang 2016-09-22
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
	
	..S StatusID=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	..S adrAnonymFlag=$p(^DHCMEDADRR(adrRepID),"^",31) //匿名标志  ;2016-09-29

	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCMEDADRR(adrRepID),"^",30)
	...S TypeFlowID=$o(^DHCADREVTWF(0,"Event",TypeeventDr,"")) //获取工作流ID ;2016-09-29
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S MedadriSub=""
	...S AssessRowID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,adrRepID,"")) //评估明细 2016-10-13
	...S Subflag=0
	...S SubUserflag=0 ;2016-09-29
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrRowID),"^",4)
	....S StaFistAuditDr=""
	....S:(ReportType'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(adrRepID, ReportType, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	....b ;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...;2016-09-29
	...S:Medadrflag=1 Subflag=1 //转抄
	...S:Medadrflag=2 Subflag=2 //全部回复
	...S:Medadrflag=3 Subflag=3 //部分回复
	...
	...S params=ID_"^"_typecode_"^"_UserId_"^"_LocId
	...S SubUserflag=..SearchAuditIUser(MedadrID,params)
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=adrRepID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,adrRepID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S AdrRepNo=$p(^DHCMEDADRR(adrRepID),"^",1)   //编号
    ..S RepImp=$p(^DHCMEDADRR(adrRepID),"^",32)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S AdrRepDate=$p(^DHCMEDADRR(adrRepID),"^",25) //日期
	..I AdrRepDate'="" S AdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdrRepDate)
	..;S AdrAdmNo=$p(^DHCMEDADRR(adrRepID),"^",33)     //病人就诊ID
	..;S AdrPatID="",AdrPatName=""
	..;S:AdrAdmNo'="" AdrPatID=$p(^PAADM(AdrAdmNo),"^",1)
	..;S:AdrPatID'="" AdrPatName=$p(^PAPER(+AdrPatID,"ALL"),"^",1)  //姓名
	..S AdrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23)     //病人ID(登记号)
	..S AdrPatID="",AdrPatName=""
	..S:AdrPatNo'="" AdrPatID=$o(^PAPERi("PAPMI_PatNo",(AdrPatNo),""))
	..S:AdrPatID'="" AdrPatName=$p(^PAPER(+AdrPatID,"ALL"),"^",1)  //姓名
	..s anonymityFlag=$p(^DHCMEDADRR(adrRepID),"^",31)   
	..;2017-06-09 人员科室信息获取代码优化
	..S AdrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)   //报告人工号
	..S AdrRepUserDr="",AdrReporter=""
	..S:AdrRepUserCode'="" AdrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AdrRepUserCode),""))
	..S:AdrRepUserDr'="" AdrReporter=$p(^SSU("SSUSR",AdrRepUserDr),"^",2)
	..S:adrAnonymFlag=1 AdrReporter="匿名" ;2017-06-09 匿名时 查询与审核界面统一显示匿名
	..S LocCode=$p(^DHCMEDADRR(adrRepID),"^",20)     //科室代码
	..S AdrRepLoc="",LocDesc=""
	..S:LocCode'="" AdrRepLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..S:AdrRepLoc'="" LocDesc=$p(^CTLOC(AdrRepLoc),"^",2)
	..S:anonymityFlag=1 LocDesc="匿名"  ;2017-06-09 匿名时 查询与审核界面统一显示匿名
	..
	..S RepList=TypeeventDr_"^"_AdrRepLoc_"^"_AdrRepUserDr_"^"_adrRepID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(patNo'="")&(patNo'=AdrPatNo)  ;2016-09-29
	..Q:(typeevent'="")&(typeevent'=TypeFlowID) ;2016-09-29  wangxuejian 2016-10-17
	..Q:(receive'="")&(receive'[Medadrreceivedr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:AdrRepNo=""
	..S armaID=""
	..S LevelDr=""
	..S CatDr=""
	..S DealMethDr=""
	..S ImpMethDr=""
	..F  S armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,armaID))  Q:armaID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(armaID),"^",3)
	...S CatDr=$p(^DHCADVREPMAN(armaID),"^",4)
	...S DealMethDr=$p(^DHCADVREPMAN(armaID),"^",5)
	...S ImpMethDr=$p(^DHCADVREPMAN(armaID),"^",6) 
	..Q:(Level'="")&(Level'=LevelDr)
	..Q:(armaCat'="")&(armaCat'=CatDr)
	..Q:(DealMeth'="")&(DealMeth'=DealMethDr)
	..Q:(ImpMeth'="")&(ImpMeth'=ImpMethDr)
	..;zhaowuqiang  2016-09-23 ;2016-09-29
	..S ListData=adrRepID_"^"_AdrRepDate_"^"_AdrRepNo_"^"_AdrPatNo_"^"_AdrPatName_"^"_AdrReporter_"^"_LocDesc_"^"_Status_"^"_Typeevent_"^"_StatusNext_"^"_StatusNextID_"^"_Medadrreceive_"^"_Medadrreceivedr_"^"_typecode_"^"_StatusID_"^"_RepImpFlag_"^"_shareStatus_"^"_Subflag_"^"_SubUserflag_"^"_armaCatDr_"^"_armaLevelDr_"^"_armaCatDesc_"^"_armaLevelDesc_"^"_catDesc_"^"_AssessRowID_"^"_TypeeventDr_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,Num)=ListData
	.
	.//药品不良事件yangyongtao
	.S advdrID=""    
	.F  S advdrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,advdrID)) Q:advdrID=""  D
	..;zhaowuqiang  2016-09-23
	..S ReportType=$p(^DHCADVDRUGREP(advdrID),"^",49) //报告类型   //zhaowuqiang 2016-09-22
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",StatusLast="",StatusLastID="",AssessRowID="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..;s armaID=$o(^DHCADVREPMAN(0,"Pointer",advdrID,""))   //zhaowuqiang 2016-09-22
	..s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",ReportType,advdrID,""))   //zhaowuqiang 2016-09-22
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
	
	..S StatusID=$p(^DHCADVDRUGREP(advdrID),"^",48) //当前状态
	..I StatusID'=""  D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S TypeFlowID=$o(^DHCADREVTWF(0,"Event",TypeeventDr,"")) //获取工作流ID ;2016-09-29
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S AssessRowID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,advdrID,"")) //评估明细 2016-10-13
	...S Subflag=0
	...S SubUserflag=0 ;2016-09-29
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrRowID),"^",4)
	....S StaFistAuditDr=""
	....S:(ReportType'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(advdrID, ReportType, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...;2016-09-29
	...S:Medadrflag=1 Subflag=1 //转抄
	...S:Medadrflag=2 Subflag=2 //全部回复
	...S:Medadrflag=3 Subflag=3 //部分回复
	...
	...S params=ID_"^"_typecode_"^"_UserId_"^"_LocId
	...S SubUserflag=..SearchAuditIUser(MedadrID,params)
	...
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=advdrID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,advdrID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	..S RepImp=$p(^DHCADVDRUGREP(advdrID),"^",55)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVDRUGREP(advdrID),"^",51)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVDRUGREP(advdrID),"^",8)   //登记号  病人ID
	..S PatName=$p(^DHCADVDRUGREP(advdrID),"^",9)     //姓名
	..S CreatorCode=$p(^DHCADVDRUGREP(advdrID),"^",41)   //报告人工号
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_advdrID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..;2016-09-29
	..I Subflag=0 S Medadrreceive=Medadrreceive
	..I Subflag=1 S Medadrreceive=Medadrreceive_"："_"已转抄"
	..I Subflag=2 S Medadrreceive=Medadrreceive_"："_"全部回复"
	..I Subflag=3 S Medadrreceive=Medadrreceive_"："_"部分回复"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeFlowID) ;2016-09-29
	..Q:(receive'="")&(receive'[Medadrreceivedr) ;2016-09-29
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..;zhaowuqiang  2016-09-23 ;2016-09-29
	..S ListData=advdrID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_Status_"^"_Typeevent_"^"_StatusNext_"^"_StatusNextID_"^"_Medadrreceive_"^"_Medadrreceivedr_"^"_typecode_"^"_StatusID_"^"_RepImpFlag_"^"_shareStatus_"^"_Subflag_"^"_SubUserflag_"^"_armaCatDr_"^"_armaLevelDr_"^"_armaCatDesc_"^"_armaLevelDesc_"^"_catDesc_"^"_AssessRowID_"^"_TypeeventDr_"^"_StaFistAuditUser_"^"_BackAuditUser
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,Num)=ListData
	.
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,index),-1) Q:(index="")||(quitflag=1)  D //wangxuejian 2016-10-09  逆序取值
	.S mdata=^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid,index)
	.;2016-09-29
	.S Title="ID^CreateDate^RepNo^PatNo^PatName^Creator^LocDesc^Status^Typeevent^StatusNext^StatusNextID^Medadrreceive^Medadrreceivedr^typecode^StatusID^RepImpFlag^RepShareFlag^Subflag^SubUserflag^armaCatDr^armaLevelDr^armaCatDesc^armaLevelDesc^catDesc^Assess^TypeID^StaFistAuditUser^BackAuditUser"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// Description: 不良反应报告审批
/// Creator:     CongYue
/// CreateDate:  2016-03-09
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 审批成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).AuditMataReport("1^3||1^600^63^126^2^aaaaa^Y^blood")
ClassMethod AuditMataReport(params As %String) As %String
{
	N (params)
	S ListData = ..AuditReport(params)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告审批
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^审核状态^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0 审批成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).AuditReport("138^5||2^600^63^126^2^wqdewq^未接收^med")
ClassMethod AuditReport(params As %String) As %String
{
	
	N (params)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrStatusDR=$p(params,"^",2)  //审核状态
	S medadrAuditUserDR=+$p(params,"^",3)     //用户ID
	S LgCtLocID=+$p(params,"^",4)     //科室ID
	S LgGroupID=+$p(params,"^",5)     //安全组ID
	S medadrNextLocDR=$p(params,"^",6)
	S medadrLocAdvice=$p(params,"^",7)
	S medadrReceive=$p(params,"^",8)
	Q:medadrReceive="2" "-6^报告已驳回，不能审核"
	
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	S typecode=$p(params,"^",9) // 报告类型代码
	S eventDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	s Typeparref="",Typesub="" ;2021-02-20
	i eventDr=""  d
	.S Typeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:Typeparref'="" Typesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),Typeparref,""))
	.S:(Typeparref'="")&&(Typesub'="") eventDr=Typeparref_"||"_Typesub
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",eventDr,ID,""),-1)
	S flag=..SearchAuditIMess(MedadrID)
	;Q:flag="-1" "-7^转抄审批信息未完成，不能审核"
	Q:(flag'="2")&&(flag'="0") "-7^转抄审批信息未完成，不能审核"
	
	S meventdr="",seventdr="",beventdr="",medeventdr="",adveventdr=""
	S matadrID=$o(^DHCMATADRR(""),-1)
	S:matadrID'="" meventdr=$p(^DHCMATADRR(matadrID),"^",46) //器械报告类型
	S medsrID=$o(^DHCADVMEDSAR(""),-1)
	S:medsrID'="" seventdr=$p(^DHCADVMEDSAR(medsrID),"^",20) //用药安全报告类型
	S bldrptID=$o(^DHCBLDADVRPT(""),-1)
	S:bldrptID'="" beventdr=$p(^DHCBLDADVRPT(bldrptID),"^",47) //输血报告类型
	S medID=$o(^DHCMEDADRR(""),-1)
	S:medID'="" medeventdr=$p(^DHCMEDADRR(medID),"^",30) //医疗报告类型
	S advdrID=$o(^DHCADVDRUGREP(""),-1)
	S:advdrID'="" adveventdr=$p(^DHCADVDRUGREP(advdrID),"^",49) //药品报告类型
	
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S Listt=ID_"^"_eventDr_"^"_list
	
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt)
	Q:StatusNextID="-1" "-1^无权限"
	Q:StatusNextID="-2" "-2^已是最后一个权限"
	Q:StatusNextID="-3" "-3^无授权工作流"
	Q:StatusNextID="-4" "-4^无配置子项"
	I StatusNextID'="" D
	.S AdrewRowIDn=$p(StatusNextID,"||",1)
	.S AdrewChildSubn=$p(StatusNextID,"||",2)
	.S MataStatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	;S medadrReceive="1"
	S Insflag=0
	I medadrReceive="未接收"  D
	.S medadrReceive="1"
	.S matadrRepAuditList=medadrStatusDR_"^"_list_"^"_""_"^"_""_"^"_medadrReceive_"^"_eventDr
	.S Insflag=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	Q:Insflag'=0 "-5^审核失败"
	
	TS
	S Err=0

	I meventdr=eventDr D  //器械报告
	.S Err=..InsMatStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-01"
	
	I seventdr=eventDr D  //用药安全报告
	.S Err=..InsMedSStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-02"
	
	I beventdr=eventDr D  //输血报告
	.S Err=..InsBldStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-03"
	
	I medeventdr=eventDr D  //医疗报告
	.S Err=..InsMedRStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-04"

	I adveventdr=eventDr D  //药品报告
	.S Err=..InsAdvRStart(ID,medadrStatusDR)
	I Err'=0 tro
	Q:Err'=0 "-05"

	S matadrRepAuditList=medadrStatusDR_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceive_"^"_eventDr
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	
	TC
	Q 0
}

/// Description: 插入器械报告表状态
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Input:  	 报告id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsMatStart(ID As %String, medadrStatusDRAs As %String) As %String
{
	N (ID,medadrStatusDR)
	&SQL(update DHC_MatAdrReport set MATADR_CurStatus_DR=:medadrStatusDR WHERE MATADR_RowID=:ID)
	Q SQLCODE
}

/// Description: 插入用药差错报告表状态
/// Creator:     CongYue
/// CreateDate:  2015-11-10
/// Input:  	 报告id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsMedSStart(ID As %String, medadrStatusDR As %String) As %String
{
	N (ID,medadrStatusDR)
	&SQL(update DHC_MedSafetyReport set MEDSR_CurStatus_DR=:medadrStatusDR WHERE MEDSR_RowID=:ID)
	Q SQLCODE
}

/// Description: 插入输血报告表状态
/// Creator:     CongYue
/// CreateDate:  2016-01-22
/// Input:  	 报告id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsBldStart(ID As %String, medadrStatusDR As %String) As %String
{
	N (ID,medadrStatusDR)
	&SQL(update DHC_AdvBloodReport set BLDRPT_CurStatus_DR=:medadrStatusDR WHERE BLDRPT_RowID=:ID)
	Q SQLCODE
}

/// Description: 插入医疗报告表状态
/// Creator:     CongYue
/// CreateDate:  2016-04-27
/// Input:  	 报告id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsMedRStart(ID As %String, medadrStatusDR As %String) As %String
{
	N (ID,medadrStatusDR)
	&SQL(update DHC_MedAdrReport set MEDADR_CurStatus_DR=:medadrStatusDR WHERE MEDADR_RowID=:ID)
	Q SQLCODE
}

/// Description: 插入药品报告表状态
/// Creator:     CongYue
/// CreateDate:  2016-04-01
/// Input:  	 报告id , 报告状态
/// Return:		 插入成功 0,插入失败 非0
ClassMethod InsAdvRStart(ID As %String, medadrStatusDR As %String) As %String
{
	N (ID,medadrStatusDR)
	&SQL(update DHC_AdvDrugReport set ADVDR_CurStatus_DR=:medadrStatusDR WHERE ADVDR_RowID=:ID)
	Q SQLCODE
}

/// Description: 不良反应报告接收
/// Creator:     CongYue
/// CreateDate:  2016-03-09
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0  接收成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).REMataReport("12^600^63^126^^^N^blood")
ClassMethod REMataReport(params As %String) As %String
{
	N (params)
	S ListData = ..REceiveReport(params)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告接收
/// Creator:     CongYue
/// CreateDate:  2015-11-16
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码^报告状态id
/// Return: 	 0  接收成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).REceiveReport("20^600^63^126^^^N^blood^3||1")
ClassMethod REceiveReport(params As %String) As %String
{
	
	N (params)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrAuditUserDR=+$p(params,"^",2)     //用户ID
	S LgCtLocID=+$p(params,"^",3)     //科室ID
	S LgGroupID=+$p(params,"^",4)     //安全组ID
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S medadrNextLocDR=$p(params,"^",5)
	S medadrLocAdvice=$p(params,"^",6)
	
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	
	S typecode=$p(params,"^",8) // 报告类型代码
	S medadrType=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	s eventparref="",eventsub="" ;2021-02-20
	i medadrType=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") medadrType=eventparref_"||"_eventsub
	
	S StatusID=$p(params,"^",9) // 当前状态
	
	S medadrReceivedr=$p(params,"^",7)
	Q:medadrReceivedr="1" "-1^已接收"
	S medadrReceivedr="1"
	
	//判断该报告是否有接收权限
	S Listt=ID_"^"_medadrType_"^"_list
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt)
	Q:StatusNextID="-1" "-2^无权限"
	Q:StatusNextID="-2" "-3^已是最后一个权限"

	TS
	S matadrRepAuditList=StatusID_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceivedr_"^"_medadrType
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	TC
	
	Q 0
}

/// Description: 查询不良反应报告（所有）
/// Creator:     CongYue
/// CreateDate:  2015-12-21  （改）
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间^科室id^病人登记号^安全组ID^科室ID^人员ID^提交状态^报告类型
/// Output:   	 报告id^报告日期^报告编码^病人登记号^病人姓名^操作人^科室描述^提交状态^报告类型^报告类型代码 
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).GetMataReport("30","1","2016-05-23^2016-05-24^63^^126^63^600^^")
ClassMethod GetMataReport(rows As %String, page As %String, StrParam As %String) As %String
{
	N (rows,page,StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	S GroupId=$p(StrParam,"^",5)   //安全组ID
    S LocId=$p(StrParam,"^",6)     //科室ID
    S UserId=$p(StrParam,"^",7)    //用户ID
    S StatType=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    //填报类型
    S statShare=$p(StrParam,"^",10)  //分享状态
    S Params=GroupId_"^"_LocId_"^"_UserId
	S list=UserId_"^"_LocId_"^"_GroupId
    ///获取授权审批状态
	D ..killTmpGlobal(pid)
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	S QuitFlag=0
	S Num=0
	F dd=StDate:1:EndDate D
	.S ID=""
	.//器械报告
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S TypeeventDr=$p(^DHCMATADRR(ID),"^",46)
	..S TypeCode="",Typeevent="",statusname="",armaID="",Medadrreceivedr="",Medadrreceive="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..I TypeeventDr'="" D
	...S TypeCode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...s armaID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,""))   //评估id 2017-06-12
	..S StatusID=$p(^DHCMATADRR(ID),"^",41) //当前状态   ;^DHCADREVTWFI({DHC_AdrEvtWorkFlow.ADREW_RowID},"ADREWI",{ADREWI_ChildSub})
	..I StatusID=""  D
	...S status="N"
	...S statusname="未提交"
	..E  D 
	...S status="Y"
	...S statusname=$p(^DHCADREVTWFI(+StatusID,"ADREWI",$p(StatusID,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....I Medadrreceive'=""  S statusname=statusname_"："_Medadrreceive
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	....S StaFistAuditDr=""
	....S:(TypeeventDr'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, TypeeventDr, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...
	..S quitflag=1
	..S RepNo=$p(^DHCMATADRR(ID),"^",1)   //编号
	..S CreateDate=$p(^DHCMATADRR(ID),"^",39)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCMATADRR(ID),"^",5)   //登记号
	..S PatName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S CreatorCode=$p(^DHCMATADRR(ID),"^",35)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCMATADRR(ID),"^",36)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..S shareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	..I rshShare'="" D
	...S shareStatus="分享"
	..Q:flag'=1
	..Q:(StatType'="")&(StatType'=status)
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_statusname_"^"_Typeevent_"^"_TypeCode_"^"_shareStatus_"^"_armaID_"^"_Medadrreceivedr_"^"_Medadrreceive_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,Num)=ListData
	.
	.//用药安全报告
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S TypeeventDr=$p(^DHCADVMEDSAR(ID),"^",20)
	..S TypeCode="",Typeevent="",statusname="",armaID="",Medadrreceivedr="",Medadrreceive="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..S TypeCode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	..S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	..S:TypeeventDr'="" armaID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,""))   //评估id 2017-06-12
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18) //当前状态
	..I StatusID=""  D
	...S status="N"
	...S statusname="未提交"
	..E  D 
	...S status="Y"
	...S statusname=$p(^DHCADREVTWFI(+StatusID,"ADREWI",$p(StatusID,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....I Medadrreceive'=""  S statusname=statusname_"："_Medadrreceive
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	....S StaFistAuditDr=""
	....S:(TypeeventDr'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, TypeeventDr, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...
	..S quitflag=1
	..S RepNo=$p(^DHCADVMEDSAR(ID),"^",19)   //编号
	..S CreateDate=$p(^DHCADVMEDSAR(ID),"^",2)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVMEDSAR(ID),"^",8)   //登记号
	..S PatName=$p(^DHCADVMEDSAR(ID),"^",9)     //病人姓名
	..S CreatorCode=$p(^DHCADVMEDSAR(ID),"^",15)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVMEDSAR(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	
	..S shareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	..I rshShare'="" D
	...S shareStatus="分享"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_statusname_"^"_Typeevent_"^"_TypeCode_"^"_shareStatus_"^"_armaID_"^"_Medadrreceivedr_"^"_Medadrreceive_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,Num)=ListData
	.
	.//输血报告
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S TypeeventDr=$p(^DHCBLDADVRPT(ID),"^",47)
	..S TypeCode="",Typeevent="",statusname="",armaID="",Medadrreceivedr="",Medadrreceive="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..S TypeCode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	..S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	..S:TypeeventDr'="" armaID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,ID,""))   //评估id 2017-06-12
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46) //当前状态
	..I StatusID=""  D
	...S status="N"
	...S statusname="未提交"
	..E  D 
	...S status="Y"
	...S statusname=$p(^DHCADREVTWFI(+StatusID,"ADREWI",$p(StatusID,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....I Medadrreceive'=""  S statusname=statusname_"："_Medadrreceive
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	....S StaFistAuditDr=""
	....S:(TypeeventDr'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, TypeeventDr, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...
	..S quitflag=1
	..S RepNo=$p(^DHCBLDADVRPT(ID),"^",3)   //编号
	..S CreateDate=$p(^DHCBLDADVRPT(ID),"^",4)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCBLDADVRPT(ID),"^",9)   //登记号
	..S PatName=$p(^DHCBLDADVRPT(ID),"^",10)     //病人姓名
	..S CreatorCode=$p(^DHCBLDADVRPT(ID),"^",2)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCBLDADVRPT(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_ID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	
	..S shareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	..I rshShare'="" D
	...S shareStatus="分享"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_statusname_"^"_Typeevent_"^"_TypeCode_"^"_shareStatus_"^"_armaID_"^"_Medadrreceivedr_"^"_Medadrreceive_"^"_StaFistAuditUser_"^"_BackAuditUser
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,Num)=ListData
	.
	.
	.//医疗不良事件liangqiang
	.S adrRepID=""
	.F  S adrRepID=$o(^DHCMEDADRR(0,"CreateDate",dd,adrRepID)) Q:adrRepID=""  D
	..S TypeeventDr=$p(^DHCMEDADRR(adrRepID),"^",30)
	..S TypeCode="",Typeevent="",statusname="",armaID="",Medadrreceivedr="",Medadrreceive="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..I TypeeventDr'="" D
	...S TypeCode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	..S:TypeeventDr'="" armaID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,adrRepID,""))   //评估id 2017-06-12
	..S StatusID=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	..S adrAnonymFlag=$p(^DHCMEDADRR(adrRepID),"^",31) //匿名标志 ;2016-09-29
	..I StatusID=""  D
	...S status="N"
	...S statusname="未提交"
	..E  D 
	...S status="Y"
	...S statusname=$p(^DHCADREVTWFI(+StatusID,"ADREWI",$p(StatusID,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....I Medadrreceive'=""  S statusname=statusname_"："_Medadrreceive
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	....S StaFistAuditDr=""
	....S:(TypeeventDr'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(adrRepID, TypeeventDr, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...
	..S quitflag=1
	..S AdrRepNo=$p(^DHCMEDADRR(adrRepID),"^",1)   //编号
	..S AdrRepDate=$p(^DHCMEDADRR(adrRepID),"^",25) //日期
	..I AdrRepDate'="" S AdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdrRepDate)
	..S AdrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23)     //病人ID(登记号)
	..S AdrPatID="",AdrPatName=""
	..S:AdrPatNo'="" AdrPatID=$o(^PAPERi("PAPMI_PatNo",(AdrPatNo),""))
	..S:AdrPatID'="" AdrPatName=$p(^PAPER(+AdrPatID,"ALL"),"^",1)  //姓名
	..s anonymityFlag=$p(^DHCMEDADRR(adrRepID),"^",31)   //乔庆澳  2016/7/12
	..;2017-06-09 人员科室信息获取代码优化
	..S AdrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)   //报告人工号
	..S AdrRepUserDr="",AdrReporter=""
	..S:AdrRepUserCode'="" AdrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AdrRepUserCode),""))
	..S:AdrRepUserDr'="" AdrReporter=$p(^SSU("SSUSR",AdrRepUserDr),"^",2)
	..S:adrAnonymFlag=1 AdrReporter="匿名" ;2017-06-09 匿名时 查询与审核界面统一显示匿名
	..S LocCode=$p(^DHCMEDADRR(adrRepID),"^",20)     //科室代码
	..S AdrRepLoc="",LocDesc=""
	..S:LocCode'="" AdrRepLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..S:AdrRepLoc'="" LocDesc=$p(^CTLOC(AdrRepLoc),"^",2)
	..S:anonymityFlag=1 LocDesc="匿名"  ;2017-06-09 匿名时 查询与审核界面统一显示匿名
	..
	..S RepList=TypeeventDr_"^"_AdrRepLoc_"^"_AdrRepUserDr_"^"_adrRepID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	..S shareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,adrRepID,""))
	..I rshShare'="" D
	...S shareStatus="分享"
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..Q:(StatType'="")&(StatType'=status)
	..Q:(patNo'="")&(patNo'=AdrPatNo) ;2016-09-29
	..Q:(typeevent'="")&(typeevent'=TypeeventDr) ;2016-09-29  
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:AdrRepNo=""
	..S ListData=adrRepID_"^"_AdrRepDate_"^"_AdrRepNo_"^"_AdrPatNo_"^"_AdrPatName_"^"_AdrReporter_"^"_LocDesc_"^"_statusname_"^"_Typeevent_"^"_TypeCode_"^"_shareStatus_"^"_armaID_"^"_Medadrreceivedr_"^"_Medadrreceive_"^"_StaFistAuditUser_"^"_BackAuditUser
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,Num)=ListData
	.
	.
	.//药品不良事件yangyongtao
    .S advdrID=""    
	.F  S advdrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,advdrID)) Q:advdrID=""  D
	..S TypeeventDr=$p(^DHCADVDRUGREP(advdrID),"^",49)   //报告类型
	..S TypeCode="",Typeevent="",statusname="",armaID="",Medadrreceivedr="",Medadrreceive="",StaFistAuditUserDr="",BackAuditUserDr="",StaFistAuditUser="",BackAuditUser=""
	..I TypeeventDr'="" D
	...S TypeCode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	..S:TypeeventDr'="" armaID=$o(^DHCADVREPMAN(0,"TyepPointer",TypeeventDr,advdrID,""))   //评估id 2017-06-12
	..S StatusID=$p(^DHCADVDRUGREP(advdrID),"^",48) //当前状态
	..I StatusID=""  D
	...S status="N"
	...S statusname="未提交"
	..E  D 
	...S status="Y"
	...S statusname=$p(^DHCADREVTWFI(+StatusID,"ADREWI",$p(StatusID,"||",2)),"^",2)
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...I MedadrID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....I Medadrreceive'=""  S statusname=statusname_"："_Medadrreceive
	....S MedadrUserID=$p(^DHCMEDREPADT(MedadrID),"^",4)
	....S StaFistAuditDr=""
	....S:(TypeeventDr'="")&&(Medadrreceivedr="2") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(advdrID, TypeeventDr, StatusID ) 
	....S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	....S:Medadrreceivedr="2" BackAuditUserDr=MedadrUserID
	....S:BackAuditUserDr'="" BackAuditUser=$p(^SSU("SSUSR",BackAuditUserDr),"^",2) ;驳回操作人
	...
	..S quitflag=1
	..S RepNo=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	..S CreateDate=$p(^DHCADVDRUGREP(advdrID),"^",51)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVDRUGREP(advdrID),"^",8)   //登记号  病人ID
	..S PatName=$p(^DHCADVDRUGREP(advdrID),"^",9)     //姓名
	..S CreatorDr=$p(^DHCADVDRUGREP(advdrID),"^",41)   //报告人工号
	..I CreatorDr'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorDr),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID_"^"_advdrID ;2016-09-29
	..S flag=..CheckQuerySec(RepList,list)
	
	..S shareStatus="未分享"
	..S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,advdrID,""))
	..I rshShare'="" D
	...S shareStatus="分享"
	
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=advdrID_"^"_CreateDate_"^"_RepNo_"^"_PatNo_"^"_PatName_"^"_Creator_"^"_LocDesc_"^"_statusname_"^"_Typeevent_"^"_TypeCode_"^"_shareStatus_"^"_armaID_"^"_Medadrreceivedr_"^"_Medadrreceive_"^"_StaFistAuditUser_"^"_BackAuditUser
	
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,Num)=ListData
	.
	
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,index),-1) Q:(index="")||(quitflag=1)  D  //wangxuejian 2016-10-09 逆向进行取值
	.S mdata=^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid,index)
	.S Title="ID^CreateDate^RepNo^PatNo^PatName^Creator^LocDesc^status^Typeevent^TypeCode^RepShareFlag^Assess^Medadrreceivedr^Medadrreceive^StaFistAuditUser^BackAuditUser"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// Description: 校验查看权限
/// Creator:     CongYue
/// CreateDate:  2016-04-20 ;2016-09-29
/// Input:  	 报告类型^报告科室^报告人 , 人员ID^科室ID^安全组ID^医院ID
/// Table:		 DHC_AdvQuerySec
/// Return: 	 flag 0 无查看权限， 1 有查看权限 
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).CheckQuerySec("85^624^13102^1","3^101^132")
ClassMethod CheckQuerySec(RepList As %String, DataList As %String = "") As %String
{
	N (RepList,DataList)
	S RepType=$p(RepList,"^",1)
	S RepLoc=$p(RepList,"^",2)
	S RepUser=$p(RepList,"^",3)
	S RepID=$p(RepList,"^",4)
	S UserID=$p(DataList,"^",1)
	S UserCode=""
	S:UserID'="" UserCode=$p(^SSU("SSUSR",UserID),"^",1)
	S LocID=$p(DataList,"^",2)
	S GroupID=$p(DataList,"^",3)
    S HospID=$p(DataList,"^",4)
	S HospIDGroup=""
	S:HospID'="" HospIDGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvQuerySec",HospID)  ///2021-06-18 cy 多院区业务改造
    S flag="0"
	S USERSHUNT=##class(web.DHCADVCOMMON).GetEmSysConfig("USERSHUNT",DataList) ;2021-02-24 cy 医生护士分流查看报告
	S ShuntFlag=##class(web.DHCADVCOMMONPART).ChkUserType(UserID,RepUser,USERSHUNT)
	Q:ShuntFlag=0 flag
    
    S SecFlagID="" ,MedIChildSub="" 
    S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepType,RepID,""),-1)
    S:(MedadrID'="")&&(UserCode'="") MedIChildSub=$o(^DHCMEDREPADT(0,"NextUser",MedadrID,UserCode,""))
    S:MedIChildSub'="" flag=1
	S RepTypeCode=""
	S:(RepType'="")&&(RepType'["||") RepTypeCode=$p(^DHCMEDADREVT(RepType),"^",1)
	S:(RepType'="")&&(RepType["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepType,"MADREVI",$p(RepType,"||",2)),"^",1)

    Q:RepType="" "0"
    S:'$d(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType)) RepType=+RepType
    //没有维护查看权限 仅查本科室本人的
    I '$d(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType))  D
    .S:(UserID=RepUser)&&(LocID=RepLoc) flag=1
    Q:flag'="0" flag
    
    //安全组权限
    S AdvqsID="",SecFlagID="",SecHospID=""
	S:+GroupID'="0" AdvqsID=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,1,GroupID,""))
	D ChkSec
	Q:flag'="0" flag
	//科室权限
	S:+LocID'="0" AdvqsID=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,2,LocID,""))
	D ChkSec
	Q:flag'="0" flag
	//人员权限
	S:+UserID'="0" AdvqsID=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,3,UserID,""))
	D ChkSec
	Q:flag'="0" flag
	//大科权限
	S flag=..ChkSecuGroup(RepType,UserID,LocID,RepUser,RepLoc,HospID)
	Q:flag'="0" flag
	Q flag
	
ChkSec
	I AdvqsID'=""  D
	.S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	.S:(SecFlagID="1")&&(UserID=RepUser) flag=1
	.S:(SecFlagID="2")&&(LocID=RepLoc) flag=1
	.S:(SecFlagID="3") flag=1
}

/// Description: 判断大科是否有查看权限
/// Creator:     CongYue
/// CreateDate:  2021-07-21  
/// Table:		 DHC_AdvSecuGroupUserWard
/// Input:   	 报告类型id , 登录人id , 登录科室id , 报告人id , 报告科室id 
/// Output:  	 flag 0 无权限  1 有权限  RepType,UserID,LocID,RepUser,RepLoc
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).ChkSecuGroup(90,"3","101","13102","624")
ClassMethod ChkSecuGroup(RepType, UserID, LocID, RepUser, RepLoc, HospID = "") As %String
{
	N (RepType,UserID,LocID,RepUser,RepLoc,HospID)
	S flag=0
	S WardId="",RepWardId=""	
	S:+LocID'=0 WardId=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	S:+RepLoc'=0 RepWardId=$o(^PAWARD(0,"WARD_LocationDR",RepLoc,""))
	S HospIDGroup=""
	S:HospID'="" HospIDGroup=##Class(web.DHCADVCOMMON).GetDefHospIdByTableName("DHC_AdvQuerySec",HospID)  ///2021-06-18 cy 多院区业务改造

	S AdvSecuGrpDr=""
	F  S AdvSecuGrpDr=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,5,AdvSecuGrpDr))  Q:(AdvSecuGrpDr="")||(flag'="0")  D
	.Q:flag'="0"
	.Q:+AdvSecuGrpDr=0
	.S SecGrpActFlag=$p(^DHCADVSECUG(AdvSecuGrpDr),"^",4) ; 大科是否可用
	.Q:SecGrpActFlag="N"
	.S SecGrpHosp=$p(^DHCADVSECUG(AdvSecuGrpDr),"^",3) ; 大科所属医院
	.Q:(HospIDGroup'="")&&(SecGrpHosp'="")&&(SecGrpHosp'=HospIDGroup)
	.S SecuUserGrpDr=$o(^DHCADVSECUGU(0,"GroupUser",AdvSecuGrpDr,+UserID,""))
	.Q:SecuUserGrpDr=""
	.S SecuLeadFlag=$p(^DHCADVSECUGU(SecuUserGrpDr),"^",3) ; 人员是否为组长
	.Q:(SecuLeadFlag'="Y")&&(SecuUserGrpDr="")
	.S SecuUser=""
	.S AdvSecuGrpDrFlag=""
	.F  S SecuUser=$o(^DHCADVSECUGU(0,"GroupUser",AdvSecuGrpDr,SecuUser)) Q:(SecuUser="")||(flag'="0")  D
	..Q:AdvSecuGrpDrFlag=1
	..Q:+SecuUser=0
	..Q:(SecuLeadFlag'="Y")&&(SecuUser'=UserID)
	..Q:'((((RepWardId'="")&&($d(^DHCADVSECUGUW(0,"GroupUserWard",AdvSecuGrpDr,SecuUser,RepWardId))))||(RepWardId=""))&&(((SecuLeadFlag'="Y")&&(((WardId'="")&&($d(^DHCADVSECUGUW(0,"GroupUserWard",AdvSecuGrpDr,SecuUser,WardId))))||(WardId="")))||(SecuLeadFlag="Y"))&&(((RepLoc'="")&&($d(^DHCADVSECUGUL(0,"GroupUserLoc",AdvSecuGrpDr,SecuUser,RepLoc))))||(RepLoc=""))&&(((SecuLeadFlag'="Y")&&($d(^DHCADVSECUGUL(0,"GroupUserLoc",AdvSecuGrpDr,SecuUser,LocID))))||(SecuLeadFlag="Y")))
	..S AdvSecuGrpDrFlag=1
	..Q:AdvSecuGrpDrFlag=1
	..S AdvqsID=""
	.Q:AdvSecuGrpDrFlag'=1
	.S AdvqsID=$o(^DHCADVQUS(0,"HospRepType",HospIDGroup,RepType,5,AdvSecuGrpDr,""))
	.Q:+AdvqsID=0
	.S SecuUser=""
	.S SecFlagID=$p(^DHCADVQUS(AdvqsID),"^",4) //权限
	.S:(SecFlagID="1")&&(UserID=RepUser) flag=1
	.S:(SecFlagID="2") flag=1
	.S:(SecFlagID="3") flag=1
	..Q:flag'="0"
	Q flag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataReport",pid)
	
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetMataReport",pid)
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid)
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranLocUser",pid)
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryUserMess",pid)
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid)
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranMess",pid)
}

/// Description: 科室
/// Creator:     congyue
/// Table: 		 CT_LOC
/// Output:  	 所有科室描述（下拉框显示）  
ClassMethod SelAllLoc(input) As %String
{
	n (input)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as LocDr, CTLOC_DateActiveTo as DateActiveTo,CTLOC_Desc as LocDesc  FROM CT_LOC"
	i input'=""  d
	.s input=$zcvt(input,"U") 
	.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "
	;.//旧版(拼音码和描述为分开) S sqlStr = "SELECT CTLOC_ROWID as LocDr, CTLOC_Desc as LocDesc FROM CT_LOC"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	s curDate=$p(($h),",",1)
	w "["
	While(result.Next())
	{	
		S LocDr = result.Data("LocDr")
		S LocDesc = result.Data("LocDesc")
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出hxy 2017-12-28 
		S tmp=LocDr_"^"_LocDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	}
	W "]"
}

/// Description: 事件类型
/// Creator:     CongYue
/// Table:		 DHC_MedAdrRepEvent
/// Output:  	 事件类型描述（下拉框显示）  
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SelEvent()
ClassMethod SelEvent() As %String
{
	S count=0
	W "["
	S EventDr=""
	F  S EventDr=$o(^DHCMEDADREVT(EventDr)) Q:EventDr=""  D
	.Q:+EventDr=0
	.S EventDesc=$p(^DHCMEDADREVT(EventDr),"^",2)
	.S tmp=EventDr_"^"_EventDesc
	.S count = count+1
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("val^text",tmp)
	W "]"
	Q ""
}

/// Description: 不良反应报告驳回
/// Creator:     CongYue
/// CreateDate:  2016-04-25
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码
/// Return: 	 0  驳回成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).ReportBack("12^600^63^126^^^N^blood")
ClassMethod ReportBack(params As %String) As %String
{
	N (params)
	S ListData = ..BackRep(params)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 不良反应报告驳回
/// Creator:     CongYue
/// CreateDate:  2016-04-25
/// Input:  	 params :以字符"^"分割,格式为:不良反应报告ID^用户ID^科室ID^安全组ID^科室指向^建议^接收状态^报告类型代码^报告状态
/// Return: 	 0  驳回成功
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).BackRep("20^600^63^126^^^N^blood^3||1")
ClassMethod BackRep(params As %String) As %String
{
	
	N (params)
	S ID=+$p(params,"^",1)       //不良反应报告ID
	S medadrAuditUserDR=+$p(params,"^",2)     //用户ID
	S LgCtLocID=+$p(params,"^",3)     //科室ID
	S LgGroupID=+$p(params,"^",4)     //安全组ID
	S list=medadrAuditUserDR_"^"_LgCtLocID_"^"_LgGroupID
	S medadrNextLocDR=$p(params,"^",5)
	S medadrLocAdvice=$p(params,"^",6)
	S medadRetReason=$p(params,"^",10) //驳回原因
	S RevStatus=$p(params,"^",11) //驳回指向
	S medadrAuditDate=+$h
	S medadrAuditTime=$p($h,",",2)
	
	S typecode=$p(params,"^",8) // 报告类型代码
	S medadrType=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(typecode),"")) //报告类型id
	s eventparref="",eventsub="" ;2021-02-20
	i medadrType=""  d
	.S eventparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),"")) //子表类别指向
	.S:eventparref'="" eventsub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(typecode),eventparref,""))
	.S:(eventparref'="")&&(eventsub'="") medadrType=eventparref_"||"_eventsub
	
	S StatusID=$p(params,"^",9) // 报告当前状态
	
	S medadrReceivedr=$p(params,"^",7)
	Q:medadrReceivedr="2" "-1^已驳回"
	S medadrReceivedr="2"
	
	//判断该报告是否有驳回权限
	S Listt=ID_"^"_medadrType_"^"_list
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt)
	Q:StatusNextID="-1" "-2^无权限"
	Q:StatusNextID="-2" "-3^已是最后一个权限"

	TS
	S matadrRepAuditList=StatusID_"^"_list_"^"_medadrNextLocDR_"^"_medadrLocAdvice_"^"_medadrReceivedr_"^"_medadrType_"^"_medadRetReason_"^"_RevStatus
	
	S retVal=##class(web.DHCADVCOMMON).InsRepAudit(ID,matadrRepAuditList)
	I retVal'=0 tro
	Q:retVal'=0 retVal
	TC
	
	Q 0
}

/// Description:  操作[转抄界面操作]
/// Creator:     CongYue
/// CreateDate:  2016-05-16
/// Return: 	 保存成功 0,保存失败 错误代码^错误内容
ClassMethod SaveTranMess(medadrList As %String, medadriList As %String, LgParam As %String = "") As %String
{
	N (medadrList,medadriList,LgParam)
	S ListData = ..SaveTranMesage(medadrList,medadriList,LgParam)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 保存[审批子表信息(转抄操作)]
/// Creator:     CongYue
/// CreateDate:  2016-05-17
/// Table: 		 DHC_MedAdrRepAuditItm 			
/// Input:  	 medadrList: 以字符"^"分割,格式为：报告ID^报告类型代码^指向科室^部门意见^报告接收状态^报告下一状态ID,
/// 				 medadriList: 保存:审批子表信息id^转抄人ID^指向科室ID^指向人员ID^部门意见^子表信息接收状态^接收日期^接收时间^完成日期^完成时间
/// 				 medadriList: 修改(回复): 回复人ID^回复信息      接收:接收人ID^回复信息
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SaveTranMesage("169^material^63^dsadasd^未接收^1||2","^60^63^600^^^^^^^dsadasd&&^60^63^600^^^^^^^dsadasd")
/// //w ##class(web.DHCADVSEARCHREPORT).SaveTranMesage("157^material^^查询还只能去^1^1||3","1^600^")
ClassMethod SaveTranMesage(medadrList As %String, medadriList As %String, LgParam As %String = "") As %String
{
	N (medadrList,medadriList,LgParam)
	S Err=0
	S ReportID=$p(medadrList,"^",1)
	S EpisodeId=$p(^DHCADVMASTER(ReportID),"^",16)
	S TypeCode=$p(medadrList,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	s Typeparref="",Typesub="" ;2021-02-20
	i TypeDr=""  d
	.S Typeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:Typeparref'="" Typesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),Typeparref,""))
	.S:(Typeparref'="")&&(Typesub'="") TypeDr=Typeparref_"||"_Typesub
	S medadrNextLocDR=$p(medadrList,"^",3)
	S medadrLocAdvice=$p(medadrList,"^",4)
	S medadrReceive=$p(medadrList,"^",5)
	Q:medadrReceive="2" "-2^报告已驳回，不能转抄"
	S medadrStatusNextID=$p(medadrList,"^",6)
	Q:medadrStatusNextID="" "-3^报告已审批完成，不能转抄"
	S LgUserID=$p(medadrList,"^",7)
	S LgCtLocID=$p(medadrList,"^",8)
	S LgGroupID=$p(medadrList,"^",9)
	S list=LgUserID_"^"_LgCtLocID_"^"_LgGroupID
	S medadrStatusID=$p(medadrList,"^",10)
	S RepType=$p(medadrList,"^",11)
	;S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	;Q:MedadrID="" "-1^无审批记录"
	
	//2017-11-22 cy 转抄前进行判断是否有审核权限，是否审核完成
	S Listt=ReportID_"^"_TypeDr_"^"_list
	S StatusNextID=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt,"",LgParam)
	Q:StatusNextID'["||" "-20^无审核权限不能进行转抄"
	
	S MedadrID="0"
	I medadrReceive="未接收"  d
	.S medadrReceive="1"
	.S matadrRepAuditList=medadrStatusID_"^"_list_"^"_""_"^"_""_"^"_medadrReceive_"^"_TypeDr
	.S MedadrID=##class(web.DHCADVCOMMON).InsRepAudit(ReportID,matadrRepAuditList)
	Q:MedadrID'="0" "-01^审批失败"
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	Q:MedadrID="" "-1^无审批记录"
	
	TS
	
	I medadriList'="" D
	.S len=$L(medadriList,"&&")
	.F i=1:1:len D
	..S TmpStr=$p(medadriList,"&&",i)
	..I $p(TmpStr,"^",1)'="" D
	...S Err=..InsTranMes(MedadrID,TmpStr,medadrList) ;//-11 ;..UpdTranMes(MedadrID,TmpStr)  ;2016-09-29
	..E  D
	...S Err=..InsTranMes(MedadrID,TmpStr,medadrList)
	..I Err'=0 tro
	..Q:Err'=0
	..D ##class(web.DHCADVCOMMONPART).SendMessage(LgUserID,EpisodeId,$p(TmpStr,"^",4),$p(TmpStr,"^",3),"转抄",RepType,"1185")

	
	Q:Err=-10 "-10^指向人员重复"
	Q:Err=-11 "-11^转抄提交重复"
	;Q:Err=-4 "-4^修改审批记录出错"
	Q:Err'=0 "-5^保存转抄信息出错"
		
	TC
	
	Q 0
}

/// Description:  操作[转抄界面回复提交，接收操作]
/// Creator:     CongYue
/// CreateDate:  2016-07-12
/// Return: 	 保存成功 0,保存失败 错误代码^错误内容
ClassMethod SaveReplyMess(medadrList As %String, medadriList As %String) As %String
{
	N (medadrList,medadriList)
	S ListData = ..SaveReply(medadrList,medadriList)
	S ListTitle="ErrCode^ErrMsg"
	W ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	Q ""
}

/// Description: 保存[转抄界面回复提交，接收操作]
/// Creator:     CongYue
/// CreateDate:  2016-07-12
/// Table: 		 DHC_MedAdrRepAuditItm 			
/// Input:  	 medadrList: 以字符"^"分割,格式为：报告ID^报告类型代码^指向科室^部门意见^报告接收状态^报告下一状态ID,
/// 				 medadriList: 保存:审批子表信息id^转抄人ID^指向科室ID^指向人员ID^部门意见^子表信息接收状态^接收日期^接收时间^完成日期^完成时间
/// 				 medadriList: 修改(回复): 回复人ID^回复信息      接收:接收人ID^回复信息
/// Return: 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SaveReply("157^material^^查询还只能去^1^1||3","1^600^")
ClassMethod SaveReply(medadrList As %String, medadriList As %String) As %String
{
	N (medadrList,medadriList)
	S Err=0
	S ReportID=$p(medadrList,"^",1)
	S TypeCode=$p(medadrList,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	s Typeparref="",Typesub="" ;2021-02-20
	i TypeDr=""  d
	.S Typeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:Typeparref'="" Typesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),Typeparref,""))
	.S:(Typeparref'="")&&(Typesub'="") TypeDr=Typeparref_"||"_Typesub
	
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	Q:MedadrID="" "-1^无审批记录"
	S medadrReceive=$p(medadrList,"^",5)
	Q:medadrReceive="2" "-2^报告已驳回，不能转抄"
	S medadrStatusNextID=$p(medadrList,"^",6)
	Q:medadrStatusNextID="" "-3^报告已审批完成，不能转抄"
	
	S CompleteDate="" 
	S CompleteTime=""
	S NexUserDr=$p(medadriList,"^",1) //指向处理部门人员
	S NexUserCode=$p(^SSU("SSUSR",NexUserDr),"^",1)
	S UserAdvice=$p(medadriList,"^",2) //人员回复意见
	S Replyflag=$p(medadriList,"^",3) //回复标志
	S dutyFlag=$p(medadriList,"^",4) //是否回复 ;2016-09-29
	S ChildSub=$o(^DHCMEDREPADT(0,"NextUser",MedadrID,NexUserCode,""))
	S Receive="Y"
	S ReceiveDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",8) //接收日期
	S ReceiveTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",9) //接收时间
	S:ReceiveDate="" ReceiveDate=+$h    //接收日期
	S:ReceiveTime="" ReceiveTime=$p($h,",",2)   //接收时间
	S:Replyflag=1 CompleteDate=+$h //完成日期
	S:Replyflag=1 CompleteTime=$p($h,",",2)   //完成时间
	;I UserAdvice'="" D
	;.S CompleteDate=+$h    //完成日期
	;.S CompleteTime=$p($h,",",2)   //完成时间
	S MedadriID=MedadrID_"||"_ChildSub
	;2016-09-29
	&SQL(Update DHC_MedAdrRepAuditItm Set MEDADRI_UserAdvice=:UserAdvice,MEDADRI_Receive=:Receive,MEDADRI_ReceiveDate=:ReceiveDate,
	MEDADRI_ReceiveTime=:ReceiveTime,MEDADRI_CompleteDate=:CompleteDate,MEDADRI_CompleteTime=:CompleteTime,MEDADRI_DutyFlag=:dutyFlag where MEDADRI_RowID=:MedadriID) 
 	Q SQLCODE
}

/// Description: 更新[审批信息]
/// Creator:     CongYue
/// CreateDate:  2016-05-17
/// Table: 		 DHC_MedAdrRepAudit
/// Input:  	 MedadrID: 审批表ID  medadrList: 以字符"^"分割,格式为：报告ID^报告类型代码^指向科室^部门意见^报告接收状态^报告下一状态ID,
/// Return:	 	 操作成功 0,操作失败 非0
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).UpdTranMes("")
ClassMethod UpdRepAudit(MedadrID As %String, medadrList As %String) As %String
{
	N (MedadrID,medadrList)
	S medadrAuditDate=+$h    //审核日期
	S medadrAuditTime=$p($h,",",2)   //审核时间
	S medadrNextLocDR=$p(medadrList,"^",3) //指向科室
	S medadrLocAdvice=$p(medadrList,"^",4) //科室意见
	S medadrReceive=$p(medadrList,"^",5)  //接收状态
	S medadrReceive="1"
	&SQL(Update DHC_MedAdrRepAudit Set MEDADR_AuditDate=:medadrAuditDate,MEDADR_AuditTime=:medadrAuditTime,
		MEDADR_NextLoc_DR=:medadrNextLocDR,MEDADR_LocAdvice=:medadrLocAdvice,MEDADR_Receive=:medadrReceive where MEDADR_RowID=:MedadrID) 
	Q SQLCODE
}

/// Description: 更新[转抄信息]
/// Creator:     CongYue
/// CreateDate:  2016-05-19
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 DataList:  修改(回复): 回复人ID^回复信息      接收:接收人ID^回复信息
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).UpdTranMes("85^med^^阿迪王发财的^1^5||2","600^assddss")
ClassMethod UpdTranMes(MedadrID As %String, DataList As %String) As %String
{
	N (MedadrID,DataList)
	S CompleteDate="" 
	S CompleteTime=""
	S NexUserDr=$p(DataList,"^",1) //指向处理部门人员
	S NexUserCode=$p(^SSU("SSUSR",NexUserDr),"^",1)
	S ChildSub=$o(^DHCMEDREPADT(0,"NextUser",MedadrID,NexUserCode,""))
	S Receive="Y"
	S UserAdvice=$p(DataList,"^",2) //人员回复意见
	S ReceiveDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",8) //接收日期
	S ReceiveTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",9) //接收时间
	S:ReceiveDate="" ReceiveDate=+$h    //接收日期
	S:ReceiveTime="" ReceiveTime=$p($h,",",2)   //接收时间
	I UserAdvice'="" D
	.S CompleteDate=+$h    //完成日期
	.S CompleteTime=$p($h,",",2)   //完成时间
	S MedadriID=MedadrID_"||"_ChildSub
	&SQL(Update DHC_MedAdrRepAuditItm Set MEDADRI_UserAdvice=:UserAdvice,MEDADRI_Receive=:Receive,MEDADRI_ReceiveDate=:ReceiveDate,
	MEDADRI_ReceiveTime=:ReceiveTime,MEDADRI_CompleteDate=:CompleteDate,MEDADRI_CompleteTime=:CompleteTime where MEDADRI_RowID=:MedadriID) 
 	Q SQLCODE
}

/// Description: 增加[转抄信息]
/// Creator:     CongYue
/// CreateDate:  2016-05-17
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 DataList: 转抄信息数据信息, 以字符"^"分割,格式为：id^代码^描述,
/// Return:	 	 保存成功 0,保存失败 非0
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).InsTranMes("")
ClassMethod InsTranMes(MedadrID As %String, DataList As %String, medadrList As %String) As %String
{
	N (MedadrID,DataList,medadrList)
		
	S AuditDate=+$h    //转抄日期
	S AuditTime=$p($h,",",2)   //转抄时间
	S AuditUserDr=$p(DataList,"^",2)    //转抄人
	S AuditUser=$p(^SSU("SSUSR",AuditUserDr),"^",1)
	S NexLocDr=$p(DataList,"^",3) //指向处理部门
	S NexLoc=$p(^CTLOC(NexLocDr),"^",1) 
	S NexUserDr=$p(DataList,"^",4) //指向处理部门人员
	S NexUser=$p(^SSU("SSUSR",NexUserDr),"^",1)
	Q:($d(^DHCMEDREPADT(0,"NextUser",MedadrID,NexUser))) "-10"
	S UserAdvice=$p(DataList,"^",5) //人员意见
	S Receive=$p(DataList,"^",6)  //接收状态
	S Receive="N"  //接收状态
	S ReceiveDate=$p(DataList,"^",7) //接收日期
	S ReceiveTime=$p(DataList,"^",8) //接收时间
	S CompleteDate=$p(DataList,"^",9) //完成日期
	S CompleteTime=$p(DataList,"^",10) //完成时间
	S LocAdvice=$p(medadrList,"^",4) //科室意见
 	S ChildSub=$o(^DHCMEDREPADT(MedadrID,"MEDADRI",""),-1)+1
 	&SQL(INSERT INTO DHC_MedAdrRepAuditItm(
 		MEDADRI_Adt_ParRef,MEDADRI_ChildSub,MEDADRI_AuditDate,MEDADRI_AuditTime,MEDADRI_AuditUser,MEDADRI_NexLoc_DR,MEDADRI_NextUser_DR,
 		MEDADRI_UserAdvice,MEDADRI_Receive,MEDADRI_ReceiveDate,MEDADRI_ReceiveTime,MEDADRI_CompleteDate,MEDADRI_CompleteTime,MEDADRI_LocAdvice) 
 	VALUES( :MedadrID,:ChildSub,:AuditDate,:AuditTime,:AuditUser,:NexLoc,:NexUser,
 			:UserAdvice,:Receive,:ReceiveDate,:ReceiveTime,:CompleteDate,:CompleteTime,:LocAdvice))
 	Q SQLCODE
}

/// Description: 查询[审批子表信息]
/// Creator:     CongYue
/// CreateDate:  2016-05-17
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryTranLocUser("12","1","86^med")
ClassMethod QueryTranLocUser(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params,%session)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S ReportID=$p(params,"^",1)
	S TypeCode=$p(params,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	S RepStausDr=$p(params,"^",3)
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I TypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") TypeDr=RepTypeParref_"||"_RepTypeSub
	S MedadrID=""
	S h=0,count=0
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,MedadrID),-1) Q:(+MedadrID=0)  D
	.S Flag=0
	.S MedadriStatusDr=$p(^DHCMEDREPADT(MedadrID),"^",3) // 报告状态指向
	.S:MedadriStatusDr'=RepStausDr Flag="-1"
	.Q:Flag="-1"
	.S ChildSub=""
	.F  S ChildSub=$o(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub)) Q:ChildSub=""  D
	..S MedadriAuditDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",1) //转抄日期
	..S:MedadriAuditDate'="" MedadriAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedadriAuditDate)
	..S MedadriAuditTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",2) //转抄时间
	..S:MedadriAuditTime'="" MedadriAuditTime=$zt(MedadriAuditTime,1)
	..S MedadriAuditUserCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",3) //转抄人
	..S MedadriAuditUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedadriAuditUserCode),"")) 
	..S MedadriAuditUser=$p(^SSU("SSUSR",MedadriAuditUserDr),"^",2)
	..S MedadriAuditUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedadriAuditUser)  ;2020-06-28 cy
	..S MedadriNexLocCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",4) //指向处理部门
	..S MedadriNexLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedadriNexLocCode),""))
	..S MedadriNexLoc=$p(^CTLOC(MedadriNexLocDr),"^",2)
	..S MedadriNexLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",MedadriNexLoc)  ;2020-06-28 cy
	..S MedadriNextUserCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",5) //指向处理部门人员
	..S MedadriNextUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedadriNextUserCode),""))
	..S MedadriNextUser=$p(^SSU("SSUSR",MedadriNextUserDr),"^",2)
	..S MedadriNextUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedadriNextUser)  ;2020-06-28 cy
	..S MedadriUserAdvice=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",6) //人员意见
	..S MedadriReceive=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",7) //接收状态
	..S MedadriReceiveDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",8) //接收日期
	..S:MedadriReceiveDate'="" MedadriReceiveDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedadriReceiveDate)
	..S MedadriReceiveTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",9) //接收时间
	..S:MedadriReceiveTime'="" MedadriReceiveTime=$zt(MedadriReceiveTime,1)
	..S trancompdate=""
	..S:(MedadriReceiveDate'="")&&(MedadriReceiveTime'="") trancompdate=MedadriReceiveDate_" "_MedadriReceiveTime
	..S MedadriCompleteDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",10) //完成日期
	..S:MedadriCompleteDate'="" MedadriCompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedadriCompleteDate)
	..S MedadriCompleteTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",11) //完成时间
	..S:MedadriCompleteTime'="" MedadriCompleteTime=$zt(MedadriCompleteTime,1)
	..S MedadriLocAdvice=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",12) //部门意见
    ..;2016-09-29
    ..S MedadriDutyFlag=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",13) //备注
    ..I MedadriDutyFlag="N"  S MedadriDutyFlag=""
    ..I MedadriDutyFlag="Y"  S MedadriDutyFlag="该事件已报告本部门第一责任人"

	..S h=h+1
	..S TempStr=MedadrID_"||"_ChildSub_"^"_MedadriAuditDate_" "_MedadriAuditTime_"^"_MedadriAuditUser_"^"_MedadriAuditUserDr_"^"_MedadriNexLoc_"^"_MedadriNexLocDr_"^"_MedadriNextUser
	..S TempStr=TempStr_"^"_MedadriNextUserDr_"^"_MedadriUserAdvice_"^"_MedadriReceive_"^"_trancompdate_"^"_MedadriCompleteDate_" "_MedadriCompleteTime_"^"_MedadriLocAdvice_"^"_MedadriDutyFlag ;2016-09-29
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranLocUser",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^tranDateTime^tranuser^tranuserID^LocDesc^LocDr^name^nameID^advice^tranreceive^tranrecedate^trancompdate^LocAdvice^DutyFlag" ;2016-09-29
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranLocUser",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranLocUser",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[审批子表指向人员信息]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryUserMess("12","1","85^med")
ClassMethod QueryUserMess(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params,%session)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
	S ReportID=$p(params,"^",1)
	S TypeCode=$p(params,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	S RepStausDr=$p(params,"^",3)
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I TypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") TypeDr=RepTypeParref_"||"_RepTypeSub
	S MedadrID=""
	S h=0,count=0
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,MedadrID),-1) Q:(+MedadrID=0)  D
	.S Flag=0
	.S MedadriStatusDr=$p(^DHCMEDREPADT(MedadrID),"^",3) // 报告状态指向
	.S:MedadriStatusDr'=RepStausDr Flag="-1"
	.Q:Flag="-1"
	.S ChildSub=""
	.F  S ChildSub=$o(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub)) Q:ChildSub=""  D
	..S MedadriNexLocCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",4) //指向处理部门
	..S MedadriNexLocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedadriNexLocCode),""))
	..S MedadriNexLoc=$p(^CTLOC(MedadriNexLocDr),"^",2)
	..S MedadriNexLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",MedadriNexLoc)  ;2020-06-28 cy
	..S MedadriNextUserCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",5) //指向处理部门人员
	..S MedadriNextUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedadriNextUserCode),""))
	..S MedadriNextUser=$p(^SSU("SSUSR",MedadriNextUserDr),"^",2)
	..S MedadriNextUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedadriNextUser)  ;2020-06-28 cy
	..S h=h+1
	..S TempStr=MedadrID_"||"_ChildSub_"^"_MedadriNexLoc_"^"_MedadriNexLocDr_"^"_MedadriNextUser_"^"_MedadriNextUserDr
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryUserMess",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^Locname^LocID^Username^UserID"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryUserMess",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryUserMess",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[审批信息](点击转抄按钮，加载的页面信息)
/// Creator:     CongYue
/// CreateDate:  2015-12-15 ;2016-09-29
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 操作人^审核日期^审核时间^处理意见   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SearchAuditMess("12","1","85^med")
ClassMethod SearchAuditMess(params As %String) As %String
{
	N (params)
	S ReportID=$p(params,"^",1)
	S TypeCode=$p(params,"^",2)
	S NextUserID=$p(params,"^",3)
	S RepStausDr=$p(params,"^",4)
	S NextUserCode=$p(^SSU("SSUSR",NextUserID),"^",1)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	S RepTypeParref="",RepTypeSub="" ;2018-08-31
	I TypeDr=""  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") TypeDr=RepTypeParref_"||"_RepTypeSub
	S TempStr=""
	S MedadrID=""
	S h=0,count=0
	F  S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,MedadrID),-1) Q:(+MedadrID=0)||(TempStr'="")  D
	.S Flag=0
	.S MedadriStatusDr=$p(^DHCMEDREPADT(MedadrID),"^",3) // 报告状态指向
	.S:MedadriStatusDr'=RepStausDr Flag="-1"
	.Q:Flag="-1"
	.S ChildSub=""
	.F  S ChildSub=$o(^DHCMEDREPADT(0,"NextUser",MedadrID,NextUserCode,ChildSub)) Q:(ChildSub="")||(TempStr'="")  D  // 指向处理部门人员
	..; 转抄人信息
	..S MedadrUserCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",3)
	..Q:MedadrUserCode=""
	..S MedadrUser="",MedadrUserDr=""
	..S:MedadrUserCode'="" MedadrUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedadrUserCode),""))
	..S:MedadrUserDr'="" MedadrUser=$p(^SSU("SSUSR",MedadrUserDr),"^",2)
	..; 转抄指向科室
	..S MedINextLocCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",4) //指向科室
	..S MedINextLoc="",MedINextLocDR=""
	..S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	..S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
	..; 转抄时间
	..S MedadrDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",1)
	..S:MedadrDate'="" MedadrDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedadrDate)
	..S MedadrTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",2)
	..S:MedadrTime'="" MedadrTime=$zt(MedadrTime,1)
	..; 转抄意见
	..S MedadrLocAdvice=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",12)
	..S TempStr=MedadrUser_"^"_MedadrDate_"^"_MedadrTime_"^"_MedadrLocAdvice_"^"_MedadrUserDr_"^"_NextUserID_"^"_MedINextLocDR

	Q TempStr
}

/// Description: 查询[转抄审批信息是否完成]
/// Creator:     CongYue
/// CreateDate:  2015-12-15 ;2016-09-29
/// Table: 		 DHC_MedAdrRepAudit
/// Input:  	 审批信息ID
/// Output:  	 0 已完成  -1 未完成   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SearchAuditIMess("704")
ClassMethod SearchAuditIMess(MedadrID As %String) As %String
{
	N (MedadrID)
	Q:MedadrID="" "0"
	S ChildSub=""
	S flag=0,i=0,h=0
	F  S ChildSub=$o(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub)) Q:ChildSub=""  D
	.S MedadriCompleteDate=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",10) //完成日期
	.S:MedadriCompleteDate'="" MedadriCompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedadriCompleteDate)
	.S MedadriCompleteTime=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",11) //完成时间
	.S:MedadriCompleteTime'="" MedadriCompleteTime=$zt(MedadriCompleteTime,1)
	.S MedadriReplyContent=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",6) //回复内容
	.S MedadriAdvicContent=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",12) //处理内容
	.q:MedadriAdvicContent=""
	.s i=i+1
	.s:MedadriReplyContent'="" h=h+1
	.;s:(MedadriReplyContent="")&&((flag=1)||(flag=0)) flag=1  //未回复
	.;s:(MedadriReplyContent'="")&&((flag=0)||(flag=2)) flag=2      // 全部回复
	.;s:((MedadriReplyContent="")&&(flag=2))||((MedadriReplyContent'="")&&(flag=1)) flag=3  //部分回复
	.;Q:flag=3
	Q:i=0 flag
	Q:h=0 1 //未回复
	Q:h=i 2 //全部
	Q:h<i 3 //部分
	Q flag
}

/// Description: 查询[登录人是否有被指向转抄信息]
/// Creator:     CongYue
/// CreateDate:  2016-05-19 ;2016-09-29
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码^登录人ID
/// Output:  	 0 无 -1 有   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).SearchAuditIUser("85^med^600")
ClassMethod SearchAuditIUser(MedadrID As %String, params As %String) As %String
{
	N (MedadrID,params)
	Q:MedadrID="" "0"
	S UserId=$p(params,"^",3)
	S LocId=$p(params,"^",4)
	S ChildSub=""
	S flag=0
	F  S ChildSub=$o(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub)) Q:ChildSub=""  D
	.S MedadrNextUserCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",5) // 指向人员
	.Q:MedadrNextUserCode=""
	.S MedadrNextUser="",MedadrNextUserDr=""
	.S:MedadrNextUserCode'="" MedadrNextUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedadrNextUserCode),""))
	.S:MedadrNextUserDr'="" MedadrNextUser=$p(^SSU("SSUSR",MedadrNextUserDr),"^",2)
	.;S MedadrUser=$p(^SSU("SSUSR",MedadrUserDr),"^",2) ;^DHCMEDREPADT({DHC_MedAdrRepAudit.MEDADR_RowID},"MEDADRI",{MEDADRI_ChildSub})
	.S MedINextLocCode=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",4) //指向科室
	.S MedINextLoc="",MedINextLocDR=""
	.S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	.S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
	.S:(MedadrNextUserDr=UserId)&&(MedINextLocDR=LocId) flag=1
	.S MedIUserAdvice=$p(^DHCMEDREPADT(MedadrID,"MEDADRI",ChildSub),"^",6) // 指向人员-回复意见
	.S:(MedadrNextUserDr=UserId)&&(MedINextLocDR=LocId)&&(MedIUserAdvice'="") flag=2
	Q flag
}

/// Description: 查询[审批表信息]
/// Creator:     CongYue
/// CreateDate:  2015-12-15
/// Table: 		 DHC_MedAdrRepAudit
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAudit表中的数据信息   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryAuditMess("12","1","133^med")
ClassMethod QueryAuditMess(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
	S ReportID=$p(params,"^",1)
	S TypeCode=$p(params,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	s Typeparref="",Typesub="" ;2018-08-29
	i TypeDr=""  d
	.S Typeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:Typeparref'="" Typesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),Typeparref,""))
	.S:(Typeparref'="")&&(Typesub'="") TypeDr=Typeparref_"||"_Typesub
	S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,""),-1)
	Q:MedadrID=""
	S h=0,count=0
	S ID=""
	F  S ID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,ID)) Q:ID=""  D
	.Q:ID=0
	.S Subflag=0
	.S Sub=$o(^DHCMEDREPADT(ID,"MEDADRI",""))
	.S:Sub'="" Subflag=1
	.S StatusDR=$p(^DHCMEDREPADT(ID),"^",3) //状态
	.Q:StatusDR=""
	.S Status=""
	.S:StatusDR'="" Status=$p(^DHCADREVTWFI(+StatusDR,"ADREWI",$p(StatusDR,"||",2)),"^",2)	
	.S AuditUserDR=$p(^DHCMEDREPADT(ID),"^",4) //审批人
	.S AuditUser=""
	.S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	.S AuditDate=$p(^DHCMEDREPADT(ID),"^",5) //审批日期
	.I AuditDate'="" S AuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AuditDate)
	.S AuditTime=$p(^DHCMEDREPADT(ID),"^",6) //审批时间
	.I AuditTime'="" S AuditTime=$zt(AuditTime,3)
	.S NextLocDR=$p(^DHCMEDREPADT(ID),"^",7) //科室指向
	.S NextLoc=""
	.S:NextLocDR'="" NextLoc=$p(^CTLOC(NextLocDR),"^",2)
	.S LocAdvice=$p(^DHCMEDREPADT(ID),"^",8) //科室意见
	.S ReceiveDR=$p(^DHCMEDREPADT(ID),"^",9) //接收状态
	.S RetReason=$p(^DHCMEDREPADT(ID),"^",10) //驳回意见
	.S RetStatusDr=$p(^DHCMEDREPADT(ID),"^",14) //驳回指向
	.S RetStatus=""
	.S:RetStatusDr'="" RetStatus=$p(^DHCADREVTWFI(+RetStatusDr,"ADREWI",$p(RetStatusDr,"||",2)),"^",2)	
	.S AuditReason=""
	.S:(RetReason'="")&&(LocAdvice="") AuditReason=RetReason
	.S:(RetReason="")&&(LocAdvice'="") AuditReason=LocAdvice
	.S:(RetReason'="")&&(LocAdvice='"") AuditReason=LocAdvice_"/"_RetReason
	.I ReceiveDR=""  S ReceiveDR="未接收"
	.S Receive=$S(ReceiveDR="未接收":"未接收",ReceiveDR="1":"接收",ReceiveDR="2":"驳回",ReceiveDR="3":"撤销",ReceiveDR="4":"审核",ReceiveDR="5":"归档",ReceiveDR="6":"撤销归档",1:"")
	.S h=h+1
	.S TempStr=ID_"^"_StatusDR_"^"_AuditUserDR_"^"_AuditUser_"^"_AuditDate_" "_AuditTime_"^"_NextLocDR_"^"_NextLoc_"^"_AuditReason_"^"_Receive_"^"_Status_"^"_Subflag_"^"_RetStatus
	.S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="ID^StatusDR^AuditUserDR^AuditUser^AuditDateTime^NextLocDR^NextLoc^LocAdvice^Receive^Status^Subflag^RetStatus"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,index))
	.S count = count+1
	.Q:(count<stpage)||(count>endpage)
	.I count=stpage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[审批子表信息]
/// Creator:     CongYue
/// CreateDate:  2015-12-15 ;2016-09-29
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryAudItmMess("655")
ClassMethod QueryAudItmMess(params As %String) As %String
{
	N (params)
    S pid=##class(web.DHCADVCOMMON).NewPid()
	S AuditID=$p(params,"^",1)
	S h=0,count=0
	S Sub=""
	F  S Sub=$o(^DHCMEDREPADT(AuditID,"MEDADRI",Sub)) Q:Sub=""  D
	.Q:Sub=0
	.S MedIAuditDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",1) //审批日期
	.I MedIAuditDate'="" S MedIAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIAuditDate)
	.S MedIAuditTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",2) //审批时间
	.I MedIAuditTime'="" S MedIAuditTime=$zt(MedIAuditTime,3)
	.S MedIAuditUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",3) //审批人
	.S MedIAuditUser="",MedIAuditUserDR=""
	.S:MedIAuditUserCode'="" MedIAuditUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedIAuditUserCode),""))
	.S:MedIAuditUserDR'="" MedIAuditUser=$p(^SSU("SSUSR",MedIAuditUserDR),"^",2)
	.S MedINextLocCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",4) //指向科室
	.S MedINextLoc="",MedINextLocDR=""
	.S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	.S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
	.S MedINextUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",5) //指向人员
	.S MedINextUser="",MedINextUserDR=""
	.S:MedINextUserCode'="" MedINextUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedINextUserCode),""))
	.S:MedINextUserDR'="" MedINextUser=$p(^SSU("SSUSR",MedINextUserDR),"^",2)
	.S MedIUserAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",6) //人员意见
	.S MedIReceiveDR=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",7) //接收状态
	.I MedIReceiveDR=""  S MedIReceiveDR="N"
	.S MedIReceive=$S(MedIReceiveDR="N":"未接收",MedIReceiveDR="Y":"接收",1:"")
	.S MedIReceiveDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",8) //接收日期
	.I MedIReceiveDate'="" S MedIReceiveDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIReceiveDate)
	.S MedIReceiveTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",9) //接收时间
	.I MedIReceiveTime'="" S MedIReceiveTime=$zt(MedIReceiveTime,3)
	.S MedICompleteDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",10) //完成日期
	.I MedICompleteDate'="" S MedICompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedICompleteDate)
	.S MedICompleteTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",11) //完成时间
	.I MedICompleteTime'="" S MedICompleteTime=$zt(MedICompleteTime,3)
	.S MedILocAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",12) //部门意见
	.S AuditDutyFlag=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",13) //备注
    .I AuditDutyFlag="N"  S AuditDutyFlag=""
    .I AuditDutyFlag="Y"  S AuditDutyFlag="该事件已报告本部门第一责任人"
	.S h=h+1
	.S TempStr=MedIAuditDate_" "_MedIAuditTime_"^"_MedIAuditUserDR_"^"_MedIAuditUser_"^"_MedINextLocDR_"^"_MedINextLoc_"^"_MedINextUserDR_"^"_MedINextUser_"^"_MedIUserAdvice_"^"_MedIReceive_"^"_MedIReceiveDate_" "_MedIReceiveTime_"^"_MedICompleteDate_" "_MedICompleteTime_"^"_MedILocAdvice_"^"_AuditDutyFlag
	.S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="MedIAuditDateTime^MedIAuditUserDR^MedIAuditUser^MedINextLocDR^MedINextLoc^MedINextUserDR^MedINextUser^MedIUserAdvice^MedIReceive^MedIReceiveDateTime^MedICompleteDateTime^MedILocAdvice^DutyFlag"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryAuditMess",pid,index))
	.S count = count+1
	.Q:(count<1)
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 获取转抄处理时间
/// Creator:     yangyongtao CongYue
/// CreateDate:  2016-08-16 ;2016-09-30
/// Table: 		 
/// Input:  	 
/// Output:  	    
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).GetDealDateTime()
ClassMethod GetDealDateTime() As %String
{
	S medadrAuditDate=+$h    //处理日期
	I medadrAuditDate'="" S medadrAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(medadrAuditDate)
	S medadrAuditTime=$p($h,",",2)   //处理时间
	I medadrAuditTime'="" S medadrAuditTime=$zt(medadrAuditTime,1)
	S ListData=medadrAuditDate_"^"_medadrAuditTime
	w ListData
	Q ""
}

/// Description: 获取查询审核界面的报告类型状态
/// Creator:     yangyongtao
/// CreateDate:  2016-08-17
/// Table:		 DHC_AdrEvtWorkFlow
/// Input:  	 params:类型描述
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryEvtworkFlow()
ClassMethod QueryEvtworkFlow() As %String
{
	s count=0
	w "["
	S ID=""
	F  S ID=$o(^DHCADREVTWF(ID)) Q:ID=""  D
	.q:+ID=0
	.S Code=$p(^DHCADREVTWF(ID),"^",1) //代码
	.S Desc=$p(^DHCADREVTWF(ID),"^",2) //描述
	.S EventTypeDr=$p(^DHCADREVTWF(ID),"^",3) //类型
	.S EventType=$p(^DHCMEDADREVT(EventTypeDr),"^",2) //类型的描述
	.S Active=$p(^DHCADREVTWF(ID),"^",4) //是否可用
	.Q:Active="N"
	.S tmp=ID_"^"_EventType
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text","^全部")
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Description: 获取查询审核界面的报告类型状态
/// Creator:     yangyongtao
/// CreateDate:  2016-08-17
/// Table:		 DHC_AdrEvtWorkFlowItm
/// Input:   	 主表id（工作流定义数据id）
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryFlowItm("4")
ClassMethod QueryFlowItm(AdrEwiID As %String) As %String
{
	N (AdrEwiID)
	s count=0
	w "["
	S CH=""
	F  S CH=$o(^DHCADREVTWFI(AdrEwiID,"ADREWI",CH)) Q:CH=""  D
	.q:+CH=0
	.S Desc=$p(^DHCADREVTWFI(AdrEwiID,"ADREWI",CH),"^",2) //描述
	.s tmps=AdrEwiID_"^"_"全部"
	.S ID=AdrEwiID_"||"_CH
	.S tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmps)
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp) //value^text
	w "]"
	q ""
}

/// Description: 审核查询不良反应报告（已提交）（导出）
/// Creator:     yangyongtao
/// CreateDate:  2016-08-19  
/// Input:  	 StrParam : 以字符"^"分割,格式为:开始时间^结束时间^科室id^病人登记号^安全组ID^科室ID^人员ID^状态^报告类型^接收状态
/// Output:   	 报告id^报告日期^报告编码^病人登记号^病人姓名^操作人^科室描述^当前状态^报告类型^下一状态^下一状态id^接收状态^报告类型代码 
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryMataRepExport("2017-08-10^2017-12-30^^^126^63^600^^^^")
ClassMethod QueryMataRepExport(StrParam As %String) As %String
{
	N (StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	S GroupId=$p(StrParam,"^",5)   //安全组ID
    S LocId=$p(StrParam,"^",6)     //科室ID
    S UserId=$p(StrParam,"^",7)    //用户ID
    S StatType=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    //填报类型
    S receive=$p(StrParam,"^",10)    //接收状态
    S statShare=$p(StrParam,"^",11)    //分享状态 
    S DealMeth="" ;$p(StrParam,"^",11)    //处理办法
    S ImpMeth=$p(StrParam,"^",12)    //改进办法
    S Level=$p(StrParam,"^",13)    //事件等级
    S armaCat=$p(StrParam,"^",14)    //事件类别
    
    S Params=GroupId_"^"_LocId_"^"_UserId
	S list=UserId_"^"_LocId_"^"_GroupId
    ///获取授权审批状态
	D ..killTmpGlobal(pid)
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	S QuitFlag=0
	S Num=0
	S advRepDrgStr=""
	F dd=StDate:1:EndDate D
	.S ID=""
	.//器械报告
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施      
	..S matadrImprovie="" //改进建议  
	..S matadrPlace="" //事件发生地点
	..S matadrReason="" //存在隐患
	..S matadrPatMedNo="" //病案号
	..S matadrPatContact="" //联系方式  
	..S matadrName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S matadrSex=$p(^DHCMATADRR(ID),"^",2)      //性别
	..S:matadrSex'="" matadrSex=$p(^CT("SEX",matadrSex),"^",2)
	..S matadrAge=$p(^DHCMATADRR(ID),"^",3)     //年龄
	
	..S matadrPartyType="" // 上报人职业类别
	..S matadrCarPrvTp=$p(^DHCMATADRR(ID),"^",34)   //报告人职称
	..S matadrCarPrvTp=$S(matadrCarPrvTp="10":"医师",matadrCarPrvTp="11":"技师",matadrCarPrvTp="12":"护士",matadrCarPrvTp="99":"其他",1:"")

	
	..S matadrEventDesc=$p(^DHCMATADRR(ID),"^",13)     //事件陈述
	..S StatusID=$p(^DHCMATADRR(ID),"^",41) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCMATADRR(ID),"^",1)   //编号
	..S RepImp=$p(^DHCMATADRR(ID),"^",47)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCMATADRR(ID),"^",39)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCMATADRR(ID),"^",5)   //登记号
	..S PatName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S CreatorCode=$p(^DHCMATADRR(ID),"^",35)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCMATADRR(ID),"^",36)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..Q:flag'=1
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(receive'="")&(receive'=Medadrreceivedr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_matadrPatMedNo_"^"_matadrName_"^"_matadrImprovie_"^"_matadrPatContact_"^"_Creator_"^"_matadrEventDesc_"^"_matadrPlace_"^"_matadrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_matadrSex_"^"_matadrAge_"^"_matadrPartyType_"^"_matadrCarPrvTp
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	.
	.//用药安全报告
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
    ..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S medsrImprovie="" //改进建议
	..S medsrPlace="" //事件发生地点
	..S medsrReason="" //存在隐患
	..S medsrNurAction=$p(^DHCADVMEDSAR(ID),"^",14)     //即时行动{过程描述}
	..S medsrPatNo=$p(^DHCADVMEDSAR(ID),"^",7)     //病案号
	..S medsrPatContact="" //联系方式  
	..S medsrName=$p(^DHCADVMEDSAR(ID),"^",9)   //姓名
	..S medsrSex=$p(^DHCADVMEDSAR(ID),"^",10)     //性别
	..S:medsrSex'="" medsrSex=$p(^CT("SEX",medsrSex),"^",2)
	..S medsrAge=$p(^DHCADVMEDSAR(ID),"^",11)     //年龄
	..S medsrCreatorType="" //上报人职业类别
	..S medsrCreatorCareProv=$p(^DHCADVMEDSAR(ID),"^",16) //报告人职称
	
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0,SubUserflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVMEDSAR(ID),"^",19)   //编号
	..S RepImp=$p(^DHCADVMEDSAR(ID),"^",23)    //重要标记
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVMEDSAR(ID),"^",2)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVMEDSAR(ID),"^",8)   //登记号
	..S PatName=$p(^DHCADVMEDSAR(ID),"^",9)     //病人姓名
	..S CreatorCode=$p(^DHCADVMEDSAR(ID),"^",15)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVMEDSAR(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(receive'="")&(receive'=Medadrreceivedr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_medsrPatNo_"^"_medsrName_"^"_medsrImprovie_"^"_medsrPatContact_"^"_Creator_"^"_medsrPlace_"^"_medsrNurAction_"^"_medsrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_medsrSex_"^"_medsrAge_"^"_medsrCreatorType_"^"_medsrCreatorCareProv
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	.
	.//输血报告
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S bldrptPatNo=$p(^DHCBLDADVRPT(ID),"^",8) //病人病案号
	..S bldrptName=$p(^DHCBLDADVRPT(ID),"^",10) //患者姓名
	
	..S bldrptSex=$p(^DHCBLDADVRPT(ID),"^",11) //性别
	..S:bldrptSex'="" bldrptSex=$p(^CT("SEX",bldrptSex),"^",2)
	..S bldrptAge=$p(^DHCBLDADVRPT(ID),"^",12) //年龄
	
	..S bldrptPartyType="" // 上报人职业类别
	..S bldrptCarPrvTp="" // 上报人职称
	
	
	..S bldrptImprovie="" //改进建议
	..S bldrptPlace="" //事件发生地点
	..S bldrptReason="" //存在隐患
	..S bldrptPatMedNo="" //病案号
	..S bldrptPatContact="" //联系方式  
	..S bldrptWardOp=$p(^DHCBLDADVRPT(ID),"^",41)   //临床处置{过程描述}
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCBLDADVRPT(ID),"^",3)   //编号
	..S RepImp=$p(^DHCBLDADVRPT(ID),"^",48)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCBLDADVRPT(ID),"^",4)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCBLDADVRPT(ID),"^",9)   //登记号
	..S PatName=$p(^DHCBLDADVRPT(ID),"^",10)     //病人姓名
	..S CreatorCode=$p(^DHCBLDADVRPT(ID),"^",2)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCBLDADVRPT(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(receive'="")&(receive'=Medadrreceivedr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_bldrptPatNo_"^"_bldrptName_"^"_bldrptImprovie_"^"_bldrptPatContact_"^"_Creator_"^"_bldrptPlace_"^"_bldrptWardOp_"^"_bldrptReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_bldrptSex_"^"_bldrptAge_"^"_bldrptPartyType_"^"_bldrptCarPrvTp
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	
	.//医疗不良事件  
	.S adrRepID=""
	.F  S adrRepID=$o(^DHCMEDADRR(0,"CreateDate",dd,adrRepID)) Q:adrRepID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S adrAdmNo=$p(^DHCMEDADRR(adrRepID),"^",33) //就诊ID
	..S adrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23) //病人登记号
	..I adrPatNo'="" S adrPatID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(adrPatNo),""))
	..S:adrAdmNo'="" medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(adrAdmNo,"") 
	..S:(adrPatID'="")&&(medicalNo="") medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",adrPatID) //病案号
	..S adrPatSex=$p(^DHCMEDADRR(adrRepID),"^",2) //性别
	..S:adrPatSex'="" adrPatSex=$p(^CT("SEX",adrPatSex),"^",2)
	..S adrPatAge=$p(^DHCMEDADRR(adrRepID),"^",3) //年龄
	..S adrPartyType=$p(^DHCMEDADRR(adrRepID),"^",17) //当事人类别
	..S adrPartyType=$S(adrPartyType="11":"医师",adrPartyType="12":"药师",adrPartyType="13":"技师",adrPartyType="14":"护理人员",adrPartyType="15":"管理人员",adrPartyType="16":"其他",1:"")
	..S adrCarPrvTp=$p(^DHCMEDADRR(adrRepID),"^",18) //报告人职称
	..S adrCarPrvTp=$S(adrCarPrvTp="11":"高级",adrCarPrvTp="12":"中级",adrCarPrvTp="13":"初级",adrCarPrvTp="14":"士级",1:"")
	..S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(adrPatNo,adrAdmNo) //就诊信息
     
	..S Sexdr=$p(PatInfo,"^",4) //性别
	..S PatName=$p(PatInfo,"^",2) //病人姓名
	..S adrImprovie=$p(^DHCMEDADRR(adrRepID),"^",15) //改进建议
	..S adrRepTel=""  //联系电话
	..S adrPlace=$p(^DHCMEDADRR(adrRepID),"^",24) //不良事件场所
	..S adrPlace=$S(adrPlace="10":"急诊",adrPlace="11":"门诊",adrPlace="12":"病房部",adrPlace="16":"手术室",adrPlace="13":"医技检查室",adrPlace="14":"后勤区域",adrPlace="15":"其他",1:"")
	..S adrProcDesc=$p(^DHCMEDADRR(adrRepID),"^",10) //过程描述
	..S adrReason=$p(^DHCMEDADRR(adrRepID),"^",12) //原因存在隐患
	..S StatusID=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCMEDADRR(adrRepID),"^",30)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S MedadriSub=""
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=adrRepID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,adrRepID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S AdrRepNo=$p(^DHCMEDADRR(adrRepID),"^",1)   //编号
    ..S RepImp=$p(^DHCMEDADRR(adrRepID),"^",32)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S AdrRepDate=$p(^DHCMEDADRR(adrRepID),"^",25) //日期
	..I AdrRepDate'="" S AdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdrRepDate)
	..S AdrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23)     //病人ID(登记号)
	..S AdrPatID="",AdrPatName=""
	..S:AdrPatNo'="" AdrPatID=$o(^PAPERi("PAPMI_PatNo",(AdrPatNo),""))
	..S:AdrPatID'="" AdrPatName=$p(^PAPER(+AdrPatID,"ALL"),"^",1)  //姓名
	..S AdrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)   //报告人工号
	..S AdrRepUserDr=""
	..I AdrRepUserCode'="" D
	...S AdrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AdrRepUserCode),""))
	...I AdrRepUserDr'="" S AdrReporter=$p(^SSU("SSUSR",AdrRepUserDr),"^",2)
	..S LocCode=$p(^DHCMEDADRR(adrRepID),"^",20)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S AdrRepLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(AdrRepLoc),"^",2)
	..S RepList=TypeeventDr_"^"_AdrRepLoc_"^"_AdrRepUserDr
	..S flag=..CheckQuerySec(RepList,list)
	..S params=adrRepID_"^"_typecode_"^"_UserId
	..S SubUserflag=..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=1)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..Q:flag'=1
	..Q:(receive'="")&(receive'=Medadrreceivedr)
	..Q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(patNo'="")&(patNo'=AdrPatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:AdrRepNo=""
	..S armaID=""
	..S LevelDr=""
	..S CatDr=""
	..S DealMethDr=""
	..S ImpMethDr=""
	..F  S armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,armaID))  Q:armaID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(armaID),"^",3)
	...S CatDr=$p(^DHCADVREPMAN(armaID),"^",4)
	...S DealMethDr=$p(^DHCADVREPMAN(armaID),"^",5)
	...S ImpMethDr=$p(^DHCADVREPMAN(armaID),"^",6) 
	..Q:(Level'="")&(Level'=LevelDr)
	..Q:(armaCat'="")&(armaCat'=CatDr)
	..Q:(DealMeth'="")&(DealMeth'=DealMethDr)
	..Q:(ImpMeth'="")&(ImpMeth'=ImpMethDr) //LocDesc
	..S ListData=adrRepID_"^"_LocDesc_"^"_AdrRepDate_"^"_medicalNo_"^"_PatName_"^"_adrImprovie_"^"_adrRepTel_"^"_AdrReporter_"^"_adrPlace_"^"_adrProcDesc_"^"_adrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt _"^"_adrPatSex_"^"_adrPatAge_"^"_adrPartyType_"^"_adrCarPrvTp
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	
	.
	.//药品不良事件
	.S advdrID=""    
	.F  S advdrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,advdrID)) Q:advdrID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",advdrID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S advdrImprovie="" //改进建议
	..S advdrPlace="" //事件发生地点
	..S advdrReason="" //存在隐患
	..S advdrRepProc=$p(^DHCADVDRUGREP(advdrID),"^",53)   //过程描述
	..S advdrPatMedNo=$p(^DHCADVDRUGREP(advdrID),"^",17)    //病历号
	..S advdrPatContact=$p(^DHCADVDRUGREP(advdrID),"^",15)  //联系方式
	
	..S StatusID=$p(^DHCADVDRUGREP(advdrID),"^",48) //当前状态
	..I StatusID'=""  D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=advdrID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,advdrID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	..S RepImp=$p(^DHCADVDRUGREP(advdrID),"^",55)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVDRUGREP(advdrID),"^",51)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVDRUGREP(advdrID),"^",8)   //登记号  病人ID
	..S PatName=$p(^DHCADVDRUGREP(advdrID),"^",9)     //姓名
	..S advdrPatSex=$p(^DHCADVDRUGREP(advdrID),"^",10)   //性别
	..S:advdrPatSex'="" advdrPatSex=$p(^CT("SEX",advdrPatSex),"^",2)
	..S advdrPatAge=$p(^DHCADVDRUGREP(advdrID),"^",11)   //年龄
	..S advdrEvtCarOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",38)  //报告人职业
    ..S advdrEvtCarOfRepUser=$S(advdrEvtCarOfRepUser="10":"医生",advdrEvtCarOfRepUser="11":"药师",advdrEvtCarOfRepUser="12":"护士",advdrEvtCarOfRepUser="13":"其他",1:"")
	..S advdrEvtCarOfRepElse=$p(^DHCADVDRUGREP(advdrID),"^",39)  //报告人职业[其他]
	..S advdrEvtProTitOfRep=""  //报告人职称

	
	..S CreatorCode=$p(^DHCADVDRUGREP(advdrID),"^",41)   //报告人工号
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=..CheckQuerySec(RepList,list)
	..S params=advdrID_"^"_typecode_"^"_UserId
	..S SubUserflag=..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..Q:flag'=1
	..Q:(DeptID'="")&(DeptID'=LocID)
	..Q:(StatType'="")&(StatType'=Status)
	..Q:(patNo'="")&(patNo'=PatNo)
	..Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..Q:(receive'="")&(receive'=Medadrreceivedr)
	..Q:(statShare'="")&(statShare'=shareStatus)
	..Q:RepNo=""  //LocDesc
	..S ListData=advdrID_"^"_LocDesc_"^"_CreateDate_"^"_advdrPatMedNo_"^"_PatName_"^"_advdrImprovie_"^"_advdrPatContact_"^"_Creator_"^"_advdrPlace_"^"_advdrRepProc_"^"_advdrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_advdrPatSex_"^"_advdrPatAge_"^"_advdrEvtCarOfRepUser_"^"_advdrEvtProTitOfRep
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData

    ..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid)
	Q advRepDrgStr
}

/// 转抄操作
/// Description: 查询有权限的科室指向下的人员
/// Creator:     CongYue
/// CreateDate:  2016-05-16  
/// Input:  	 报告类型Code^科室ID
/// Output:   	 具有查看报告权限的人员
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).GetUserDr("120","1","advNursing^6")
ClassMethod GetUserDr(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S repTypecode=$p(params,"^",1) ;报告类型代码
	S:repTypecode'="" repType=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(repTypecode),"")) //类别指向
	S RepTypeParref="",RepTypeSub="" ;2021-02-20
	I (repType="")&&(repTypecode'="")  D
	.S RepTypeParref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypecode),"")) //子表类别指向
	.S:RepTypeParref'="" RepTypeSub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(repTypecode),RepTypeParref,""))
	.S:(RepTypeParref'="")&&(RepTypeSub'="") repType=RepTypeParref_"||"_RepTypeSub
	S:'$d(^DHCADVQUS(0,"RepType",repType)) repType=+repType
	Q:repType="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	S LocDr=$p(params,"^",2) ;下拉框科室指向
	S End = page*rows
	S Start=(page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S UserID=""
	S h=0
	S count=0
	F  S UserID=$o(^SSU("SSUSR",UserID)) Q:UserID=""  D
	.S Sub=""
	.S UserActive=$p(^SSU("SSUSR",UserID),"^",19)
	.Q:(UserActive'="")&&(UserActive="N")
	.S UserDateFrom=$p(^SSU("SSUSR",UserID),"^",96) ;生效日期
	.S UserDateTo=$p(^SSU("SSUSR",UserID),"^",97) ;截止日期
	.Q:(UserDateFrom'="")&&(UserDateFrom>+$h)
	.Q:(UserDateTo'="")&&(UserDateTo<+$h)

	.S LocID=$p(^SSU("SSUSR",UserID),"^",4)
	.F  S Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) Q:Sub=""  D
	..Q:Sub=0
	..S OthLogLocID=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	..S flag=0 S flags=0
	..Q:(OthLogLocID="")&&(LocID="")
	..S advqsID=$o(^DHCADVQUS(0,"RepType",repType,3,UserID,""))  ;判断人员是否有权限
	..S:advqsID'="" flag=1
	..S:(LocID'=LocDr)&&(OthLogLocID'=LocDr) flags=-1
	..S:(flag=1)&&((LocID=LocDr)||(OthLogLocID=LocDr)) flags=1
	..S:LocID'="" advqsID=$o(^DHCADVQUS(0,"RepType",repType,2,LocID,""))  ;判断科室是否有权限
	..S:OthLogLocID'="" OthLogadvqsID=$o(^DHCADVQUS(0,"RepType",repType,2,OthLogLocID,""))  ;判断科室是否有权限
	..S:(advqsID'="")||(OthLogadvqsID'="") flag=1
	..S userName=$p(^SSU("SSUSR",UserID),"^",2)
	..Q:flag=0
	..Q:flags=-1
	..S ListData=UserID_"^"_userName
	..Q:$d(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName))
	..S h=h+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName,h)=ListData
	.S flag=0 S flags=0
	.Q:LocID=""
	.S advqsID=$o(^DHCADVQUS(0,"RepType",repType,3,UserID,""))  ;判断人员是否有权限
	.S:advqsID'="" flag=1
	.S:LocID'=LocDr flags=-1
	.S:(flag=1)&&(LocID'=LocDr) flags=1
	.S advqsID=$o(^DHCADVQUS(0,"RepType",repType,2,LocID,""))  ;判断科室是否有权限
	.S:advqsID'="" flag=1
	.S userName=$p(^SSU("SSUSR",UserID),"^",2)
	.Q:flag=0
	.Q:flags=-1
	.Q:$d(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName))
	.S h=h+1
	.S ListDatas=UserID_"^"_userName
	.S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName,h)=ListDatas
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	S Title="UserID^Username"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index="",user=""
	F  S user=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user)) Q:user=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user,index))
	..S count = count+1
	..Q:(count<Start)||(count>End)
	..I count=Start D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询有权限的科室指向下的人员
/// Creator:     guoguomin
/// CreateDate:  2016-05-16  
/// Input:  	 报告类型Code^科室ID
/// Output:   	 具有查看报告权限的人员
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).GetRepInfoByMonth("120","1","advNursing^6")
/// w ##class(web.DHCADVSEARCHREPORT).GetRepInfoByMonth("2017-08-10^2017-12-30^^^126^63^600^^^^")
ClassMethod GetRepInfoByMonth(StrParam As %String) As %String
{
	N (StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S StDate=$p(StrParam,"^",1)    //开始日期
	S EndDate=$p(StrParam,"^",2)   //结束日期
	S DeptID=$p(StrParam,"^",3)    //科室
	S patNo=$p(StrParam,"^",4)     //登记号
	S GroupId=$p(StrParam,"^",5)   //安全组ID
    S LocId=$p(StrParam,"^",6)     //科室ID
    S UserId=$p(StrParam,"^",7)    //用户ID
    S StatType=$p(StrParam,"^",8)  //状态
    S typeevent=$p(StrParam,"^",9)    //填报类型
    S receive=$p(StrParam,"^",10)    //接收状态
    S statShare=$p(StrParam,"^",11)    //分享状态 
    S DealMeth="" ;$p(StrParam,"^",11)    //处理办法
    S ImpMeth=$p(StrParam,"^",12)    //改进办法
    S Level=$p(StrParam,"^",13)    //事件等级
    S armaCat=$p(StrParam,"^",14)    //事件类别
    
    S Params=GroupId_"^"_LocId_"^"_UserId
	S list=UserId_"^"_LocId_"^"_GroupId
    ///获取授权审批状态
	D ..killTmpGlobal(pid)
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	S QuitFlag=0
	S Num=0
	S advRepDrgStr=""
	F dd=StDate:1:EndDate D
	.S ID=""
	.//器械报告
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施      
	..S matadrImprovie="" //改进建议  
	..S matadrPlace="" //事件发生地点
	..S matadrReason="" //存在隐患
	..S matadrPatMedNo="" //病案号
	..S matadrPatContact="" //联系方式  
	..S matadrName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S matadrSex=$p(^DHCMATADRR(ID),"^",2)      //性别
	..S:matadrSex'="" matadrSex=$p(^CT("SEX",matadrSex),"^",2)
	..S matadrAge=$p(^DHCMATADRR(ID),"^",3)     //年龄
	
	..S matadrPartyType="" // 上报人职业类别
	..S matadrCarPrvTp=$p(^DHCMATADRR(ID),"^",34)   //报告人职称
	..S matadrCarPrvTp=$S(matadrCarPrvTp="10":"医师",matadrCarPrvTp="11":"技师",matadrCarPrvTp="12":"护士",matadrCarPrvTp="99":"其他",1:"")

	
	..S matadrEventDesc=$p(^DHCMATADRR(ID),"^",13)     //事件陈述
	..S StatusID=$p(^DHCMATADRR(ID),"^",41) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCMATADRR(ID),"^",1)   //编号
	..S RepImp=$p(^DHCMATADRR(ID),"^",47)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCMATADRR(ID),"^",39)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCMATADRR(ID),"^",5)   //登记号
	..S PatName=$p(^DHCMATADRR(ID),"^",4)     //姓名
	..S CreatorCode=$p(^DHCMATADRR(ID),"^",35)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCMATADRR(ID),"^",36)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=1 //..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=0 //..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..//Q:flag'=1
	..//Q:(StatType'="")&(StatType'=Status)
	..//Q:(DeptID'="")&(DeptID'=LocID)
	..//Q:(patNo'="")&(patNo'=PatNo)
	..//Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..//Q:(receive'="")&(receive'=Medadrreceivedr)
	..//Q:(statShare'="")&(statShare'=shareStatus)
	..//Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_matadrPatMedNo_"^"_matadrName_"^"_matadrImprovie_"^"_matadrPatContact_"^"_Creator_"^"_matadrEventDesc_"^"_matadrPlace_"^"_matadrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_matadrSex_"^"_matadrAge_"^"_matadrPartyType_"^"_matadrCarPrvTp
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	.
	.//用药安全报告
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
    ..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S medsrImprovie="" //改进建议
	..S medsrPlace="" //事件发生地点
	..S medsrReason="" //存在隐患
	..S medsrNurAction=$p(^DHCADVMEDSAR(ID),"^",14)     //即时行动{过程描述}
	..S medsrPatNo=$p(^DHCADVMEDSAR(ID),"^",7)     //病案号
	..S medsrPatContact="" //联系方式  
	..S medsrName=$p(^DHCADVMEDSAR(ID),"^",9)   //姓名
	..S medsrSex=$p(^DHCADVMEDSAR(ID),"^",10)     //性别
	..S:medsrSex'="" medsrSex=$p(^CT("SEX",medsrSex),"^",2)
	..S medsrAge=$p(^DHCADVMEDSAR(ID),"^",11)     //年龄
	..S medsrCreatorType="" //上报人职业类别
	..S medsrCreatorCareProv=$p(^DHCADVMEDSAR(ID),"^",16) //报告人职称
	
	..S StatusID=$p(^DHCADVMEDSAR(ID),"^",18) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0,SubUserflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVMEDSAR(ID),"^",19)   //编号
	..S RepImp=$p(^DHCADVMEDSAR(ID),"^",23)    //重要标记
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVMEDSAR(ID),"^",2)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVMEDSAR(ID),"^",8)   //登记号
	..S PatName=$p(^DHCADVMEDSAR(ID),"^",9)     //病人姓名
	..S CreatorCode=$p(^DHCADVMEDSAR(ID),"^",15)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVMEDSAR(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=1 //..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=0 //..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..//Q:flag'=1
	..//Q:(DeptID'="")&(DeptID'=LocID)
	..//Q:(StatType'="")&(StatType'=Status)
	..
	..//Q:(patNo'="")&(patNo'=PatNo)
	..//Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..//Q:(receive'="")&(receive'=Medadrreceivedr)
	..//Q:(statShare'="")&(statShare'=shareStatus)
	..//Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_medsrPatNo_"^"_medsrName_"^"_medsrImprovie_"^"_medsrPatContact_"^"_Creator_"^"_medsrPlace_"^"_medsrNurAction_"^"_medsrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_medsrSex_"^"_medsrAge_"^"_medsrCreatorType_"^"_medsrCreatorCareProv
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	.
	.//输血报告
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID)) Q:ID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",ID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S bldrptPatNo=$p(^DHCBLDADVRPT(ID),"^",8) //病人病案号
	..S bldrptName=$p(^DHCBLDADVRPT(ID),"^",10) //患者姓名
	
	..S bldrptSex=$p(^DHCBLDADVRPT(ID),"^",11) //性别
	..S:bldrptSex'="" bldrptSex=$p(^CT("SEX",bldrptSex),"^",2)
	..S bldrptAge=$p(^DHCBLDADVRPT(ID),"^",12) //年龄
	
	..S bldrptPartyType="" // 上报人职业类别
	..S bldrptCarPrvTp="" // 上报人职称
	
	
	..S bldrptImprovie="" //改进建议
	..S bldrptPlace="" //事件发生地点
	..S bldrptReason="" //存在隐患
	..S bldrptPatMedNo="" //病案号
	..S bldrptPatContact="" //联系方式  
	..S bldrptWardOp=$p(^DHCBLDADVRPT(ID),"^",41)   //临床处置{过程描述}
	..S StatusID=$p(^DHCBLDADVRPT(ID),"^",46) //当前状态
	..I StatusID'="" D  
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,ID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=ID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,ID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCBLDADVRPT(ID),"^",3)   //编号
	..S RepImp=$p(^DHCBLDADVRPT(ID),"^",48)    //重要关注
	..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCBLDADVRPT(ID),"^",4)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCBLDADVRPT(ID),"^",9)   //登记号
	..S PatName=$p(^DHCBLDADVRPT(ID),"^",10)     //病人姓名
	..S CreatorCode=$p(^DHCBLDADVRPT(ID),"^",2)   //报告人工号
	..S Creator=""
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCBLDADVRPT(ID),"^",1)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=1 //..CheckQuerySec(RepList,list)
	..S params=ID_"^"_typecode_"^"_UserId
	..S SubUserflag=0 //..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..//Q:flag'=1
	..//Q:(DeptID'="")&(DeptID'=LocID)
	..//Q:(StatType'="")&(StatType'=Status)
	..
	..//Q:(patNo'="")&(patNo'=PatNo)
	..//Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..//Q:(receive'="")&(receive'=Medadrreceivedr)
	..//Q:(statShare'="")&(statShare'=shareStatus)
	..//Q:RepNo=""
	..S ListData=ID_"^"_LocDesc_"^"_CreateDate_"^"_bldrptPatNo_"^"_bldrptName_"^"_bldrptImprovie_"^"_bldrptPatContact_"^"_Creator_"^"_bldrptPlace_"^"_bldrptWardOp_"^"_bldrptReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_bldrptSex_"^"_bldrptAge_"^"_bldrptPartyType_"^"_bldrptCarPrvTp
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	
	.//医疗不良事件  
	.S adrRepID=""
	.F  S adrRepID=$o(^DHCMEDADRR(0,"CreateDate",dd,adrRepID)) Q:adrRepID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S adrAdmNo=$p(^DHCMEDADRR(adrRepID),"^",33) //就诊ID
	..S adrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23) //病人登记号
	..I adrPatNo'="" S adrPatID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(adrPatNo),""))
	..S:adrAdmNo'="" medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID(adrAdmNo,"") 
	..S:(adrPatID'="")&&(medicalNo="") medicalNo=##Class(web.DHCADVCOMMON).IGetMrNoByEpisodeID("",adrPatID) //病案号
	..S adrPatSex=$p(^DHCMEDADRR(adrRepID),"^",2) //性别
	..S:adrPatSex'="" adrPatSex=$p(^CT("SEX",adrPatSex),"^",2)
	..S adrPatAge=$p(^DHCMEDADRR(adrRepID),"^",3) //年龄
	..S adrPartyType=$p(^DHCMEDADRR(adrRepID),"^",17) //当事人类别
	..S adrPartyType=$S(adrPartyType="11":"医师",adrPartyType="12":"药师",adrPartyType="13":"技师",adrPartyType="14":"护理人员",adrPartyType="15":"管理人员",adrPartyType="16":"其他",1:"")
	..S adrCarPrvTp=$p(^DHCMEDADRR(adrRepID),"^",18) //报告人职称
	..S adrCarPrvTp=$S(adrCarPrvTp="11":"高级",adrCarPrvTp="12":"中级",adrCarPrvTp="13":"初级",adrCarPrvTp="14":"士级",1:"")
	..S PatInfo=##class(web.DHCADVCOMMON).getRepPatInfo(adrPatNo,adrAdmNo) //就诊信息
     
	..S Sexdr=$p(PatInfo,"^",4) //性别
	..S PatName=$p(PatInfo,"^",2) //病人姓名
	..S adrImprovie=$p(^DHCMEDADRR(adrRepID),"^",15) //改进建议
	..S adrRepTel=""  //联系电话
	..S adrPlace=$p(^DHCMEDADRR(adrRepID),"^",24) //不良事件场所
	..S adrPlace=$S(adrPlace="10":"急诊",adrPlace="11":"门诊",adrPlace="12":"病房部",adrPlace="16":"手术室",adrPlace="13":"医技检查室",adrPlace="14":"后勤区域",adrPlace="15":"其他",1:"")
	..S adrProcDesc=$p(^DHCMEDADRR(adrRepID),"^",10) //过程描述
	..S adrReason=$p(^DHCMEDADRR(adrRepID),"^",12) //原因存在隐患
	..S StatusID=$p(^DHCMEDADRR(adrRepID),"^",27) //当前状态
	..I StatusID'="" D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCMEDADRR(adrRepID),"^",30)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S MedadriSub=""
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	....;S MedadriSub=$o(^DHCMEDREPADT(MedadrRowID,"MEDADRI",""))
	...;S:MedadriSub'="" Subflag=1
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,adrRepID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=adrRepID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,adrRepID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S AdrRepNo=$p(^DHCMEDADRR(adrRepID),"^",1)   //编号
    ..S RepImp=$p(^DHCMEDADRR(adrRepID),"^",32)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S AdrRepDate=$p(^DHCMEDADRR(adrRepID),"^",25) //日期
	..I AdrRepDate'="" S AdrRepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdrRepDate)
	..S AdrPatNo=$p(^DHCMEDADRR(adrRepID),"^",23)     //病人ID(登记号)
	..S AdrPatID="",AdrPatName=""
	..S:AdrPatNo'="" AdrPatID=$o(^PAPERi("PAPMI_PatNo",(AdrPatNo),""))
	..S:AdrPatID'="" AdrPatName=$p(^PAPER(+AdrPatID,"ALL"),"^",1)  //姓名
	..S AdrRepUserCode=$p(^DHCMEDADRR(adrRepID),"^",19)   //报告人工号
	..S AdrRepUserDr=""
	..I AdrRepUserCode'="" D
	...S AdrRepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AdrRepUserCode),""))
	...I AdrRepUserDr'="" S AdrReporter=$p(^SSU("SSUSR",AdrRepUserDr),"^",2)
	..S LocCode=$p(^DHCMEDADRR(adrRepID),"^",20)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S AdrRepLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(AdrRepLoc),"^",2)
	..S RepList=TypeeventDr_"^"_AdrRepLoc_"^"_AdrRepUserDr
	..S flag=1 //..CheckQuerySec(RepList,list)
	..S params=adrRepID_"^"_typecode_"^"_UserId
	..S SubUserflag=0 //..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=1)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..//Q:flag'=1
	..//Q:(receive'="")&(receive'=Medadrreceivedr)
	..//Q:(DeptID'="")&(DeptID'=AdrRepLoc)
	..//Q:(StatType'="")&(StatType'=Status)
	..//Q:(patNo'="")&(patNo'=AdrPatNo)
	..//Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..//Q:(statShare'="")&(statShare'=shareStatus)
	..//Q:AdrRepNo=""
	..S armaID=""
	..S LevelDr=""
	..S CatDr=""
	..S DealMethDr=""
	..S ImpMethDr=""
	..F  S armaID=$o(^DHCADVREPMAN(0,"Pointer",adrRepID,armaID))  Q:armaID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(armaID),"^",3)
	...S CatDr=$p(^DHCADVREPMAN(armaID),"^",4)
	...S DealMethDr=$p(^DHCADVREPMAN(armaID),"^",5)
	...S ImpMethDr=$p(^DHCADVREPMAN(armaID),"^",6) 
	..//Q:(Level'="")&(Level'=LevelDr)
	..//Q:(armaCat'="")&(armaCat'=CatDr)
	..//Q:(DealMeth'="")&(DealMeth'=DealMethDr)
	..//Q:(ImpMeth'="")&(ImpMeth'=ImpMethDr) //LocDesc
	..S ListData=adrRepID_"^"_LocDesc_"^"_AdrRepDate_"^"_medicalNo_"^"_PatName_"^"_adrImprovie_"^"_adrRepTel_"^"_AdrReporter_"^"_adrPlace_"^"_adrProcDesc_"^"_adrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt _"^"_adrPatSex_"^"_adrPatAge_"^"_adrPartyType_"^"_adrCarPrvTp
	..
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData
	..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	
	.
	.//药品不良事件
	.S advdrID=""    
	.F  S advdrID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,advdrID)) Q:advdrID=""  D
	..S armaCatpid="",armaID="",armaCatDr="",armaLevelDr="",catDesc="",armaCatDesc="",armaLevelDesc="",armaAdviceTxt="",armaImpTxt=""
	..s armaID=$o(^DHCADVREPMAN(0,"Pointer",advdrID,""))
	..I armaID'="" s armaCatDr=$p(^DHCADVREPMAN(armaID),"^",4) //不良事件类别
	..I armaCatDr'="" s armaCatpid=$o(^DHCADVMEDRCA(0,"LevelRowID",armaCatDr,""))
	..i armaCatpid'="" & armaCatpid'=0  d
	...s armaCatpid=armaCatDr
	...s armaCatDr=""
	..e  d
	...I armaCatDr'="" s armaCatpid=$p(^DHCADVMEDRCA(armaCatDr),"^",4)
	..I armaCatpid'="" S catDesc=$p(^DHCADVMEDRCA(armaCatpid),"^",2) //一级类别描述
	..I armaCatDr'="" S armaCatDesc=$p(^DHCADVMEDRCA(armaCatDr),"^",2) //二级类别描述
	..I armaID'="" s armaLevelDr=$p(^DHCADVREPMAN(armaID),"^",3) //不良事件等级
    ..I armaLevelDr'="" S armaLevelDesc=$S(armaLevelDr="0":"非不良事件",armaLevelDr="1":"Ⅰ级警告事件",armaLevelDr="2":"Ⅱ级不良后果事件",armaLevelDr="3":"Ⅲ级未造成后果事件",armaLevelDr="4":"Ⅳ级隐患事件",1:"")
   	..I armaID'="" s armaAdviceTxt=$p(^DHCADVREPMAN(armaID),"^",7) //部门陈述意见
	..I armaID'="" s armaImpTxt=$p(^DHCADVREPMAN(armaID),"^",8) //改进措施    
	..S advdrImprovie="" //改进建议
	..S advdrPlace="" //事件发生地点
	..S advdrReason="" //存在隐患
	..S advdrRepProc=$p(^DHCADVDRUGREP(advdrID),"^",53)   //过程描述
	..S advdrPatMedNo=$p(^DHCADVDRUGREP(advdrID),"^",17)    //病历号
	..S advdrPatContact=$p(^DHCADVDRUGREP(advdrID),"^",15)  //联系方式
	
	..S StatusID=$p(^DHCADVDRUGREP(advdrID),"^",48) //当前状态
	..I StatusID'=""  D
	...S AdrewOrderNo=$p(StatusID,"^",2)
	...S StatusNext=""
	...S AdrewRowID=$p(StatusID,"||",1)
	...S AdrewChildSub=$p(StatusID,"||",2)
	...S TypeeventDr=$p(^DHCADREVTWF(AdrewRowID),"^",3)
	...S typecode=$p(^DHCMEDADREVT(TypeeventDr),"^",1)
	...S MedadrRowID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S Subflag=0
	...S MedadriSub=""
	...I MedadrRowID'=""  D
	....S Medadrreceivedr=$p(^DHCMEDREPADT(MedadrRowID),"^",9) 
	....I Medadrreceivedr=""  S Medadrreceivedr="未接收"
	....S Medadrreceive=$S(Medadrreceivedr="未接收":"未接收",Medadrreceivedr="1":"接收",Medadrreceivedr="2":"驳回",1:"")
	...S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",TypeeventDr,advdrID,""),-1)
	...S Medadrflag=..SearchAuditIMess(MedadrID)
	...S:Medadrflag'=0 Subflag=1
	...S Typeevent=$p(^DHCMEDADREVT(TypeeventDr),"^",2)
	...S Status=$p(^DHCADREVTWFI(AdrewRowID,"ADREWI",AdrewChildSub),"^",2)
	...S Listt=advdrID_"^"_TypeeventDr_"^"_list_"^"_StatusID
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	
	...S shareStatus="未分享"
	...S rshShare=$o(^DHCADVRSH(0,"TypePointer",TypeeventDr,advdrID,""))
	...I rshShare'="" D
	....S shareStatus="分享"
	...
	..E  Q
	..S quitflag=1
	..S RepNo=$p(^DHCADVDRUGREP(advdrID),"^",1)   //编号
	..S RepImp=$p(^DHCADVDRUGREP(advdrID),"^",55)    //重要关注
    ..S RepImpFlag=$S(RepImp="Y":"关注",RepImp="N":"未关注",1:"")
	..S CreateDate=$p(^DHCADVDRUGREP(advdrID),"^",51)    //报告 日期
	..I CreateDate'="" S CreateDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(CreateDate)
	..S PatNo=$p(^DHCADVDRUGREP(advdrID),"^",8)   //登记号  病人ID
	..S PatName=$p(^DHCADVDRUGREP(advdrID),"^",9)     //姓名
	..S advdrPatSex=$p(^DHCADVDRUGREP(advdrID),"^",10)   //性别
	..S:advdrPatSex'="" advdrPatSex=$p(^CT("SEX",advdrPatSex),"^",2)
	..S advdrPatAge=$p(^DHCADVDRUGREP(advdrID),"^",11)   //年龄
	..S advdrEvtCarOfRepUser=$p(^DHCADVDRUGREP(advdrID),"^",38)  //报告人职业
    ..S advdrEvtCarOfRepUser=$S(advdrEvtCarOfRepUser="10":"医生",advdrEvtCarOfRepUser="11":"药师",advdrEvtCarOfRepUser="12":"护士",advdrEvtCarOfRepUser="13":"其他",1:"")
	..S advdrEvtCarOfRepElse=$p(^DHCADVDRUGREP(advdrID),"^",39)  //报告人职业[其他]
	..S advdrEvtProTitOfRep=""  //报告人职称

	
	..S CreatorCode=$p(^DHCADVDRUGREP(advdrID),"^",41)   //报告人工号
	..I CreatorCode'="" D
	...S CreatorID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CreatorCode),""))
	...I CreatorID'="" S Creator=$p(^SSU("SSUSR",CreatorID),"^",2)
	..S LocCode=$p(^DHCADVDRUGREP(advdrID),"^",42)     //科室代码
	..S LocDesc=""
	..I LocCode'="" D
	...S LocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	...S LocDesc=$p(^CTLOC(LocID),"^",2)
	..S RepList=TypeeventDr_"^"_LocID_"^"_CreatorID
	..S flag=1 //..CheckQuerySec(RepList,list)
	..S params=advdrID_"^"_typecode_"^"_UserId
	..S SubUserflag=0 //..SearchAuditIUser(params)
	..I (Subflag=1)&(SubUserflag=0)  S Status=Status_"："_"已转抄"
	..I (Subflag=0)&(SubUserflag=1)  S Status=Status_"："_"已回复"
	..//Q:flag'=1
	..//Q:(DeptID'="")&(DeptID'=LocID)
	..//Q:(StatType'="")&(StatType'=Status)
	..//Q:(patNo'="")&(patNo'=PatNo)
	..//Q:(typeevent'="")&(typeevent'=TypeeventDr)
	..//Q:(receive'="")&(receive'=Medadrreceivedr)
	..//Q:(statShare'="")&(statShare'=shareStatus)
	..//Q:RepNo=""  //LocDesc
	..S ListData=advdrID_"^"_LocDesc_"^"_CreateDate_"^"_advdrPatMedNo_"^"_PatName_"^"_advdrImprovie_"^"_advdrPatContact_"^"_Creator_"^"_advdrPlace_"^"_advdrRepProc_"^"_advdrReason_"^"_Typeevent_"^"_armaLevelDesc_"^"_catDesc_"^"_armaCatDesc_"^"_armaAdviceTxt_"^"_armaImpTxt_"^"_advdrPatSex_"^"_advdrPatAge_"^"_advdrEvtCarOfRepUser_"^"_advdrEvtProTitOfRep
	..S Num=Num+1
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid,Num)=ListData

    ..i advRepDrgStr="" S advRepDrgStr=ListData
	..E  S advRepDrgStr=advRepDrgStr_"&&"_ListData
	K ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryMataRepExport",pid)
	Q advRepDrgStr
}

/// 转抄操作
/// Description: 查询有权限的科室指向下的人员
/// Creator:     yuliping
/// CreateDate:  2018-01-22  
/// Input:  	 报告类型Code^科室ID
/// Output:   	 具有查看报告权限的人员
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).GetUserDrNew("120","1","advNursing^4")
ClassMethod GetUserDrNew(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	S repTypecode=$p(params,"^",1) ;报告类型代码
	S:repTypecode'="" repType=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(repTypecode),""))
	S LocDr=$p(params,"^",2) ;下拉框科室指向
	S End = page*rows
	S Start=(page-1)*rows+1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S h=0
	S count=0
	D ..killTmpGlobal(pid) //k掉临时global

	s RESRowId1=""
	f  s RESRowId1=$o(^RB("RES",0,"CTLOC",LocDr,RESRowId1)) q:RESRowId1=""  d
	.s RESCTPCPDR=$p($g(^RB("RES",RESRowId1)),"^",2)       //医护人员ID
	.s UserID="" 
	.f  s UserID=$o(^SSU("SSUSR",0,"CTPCP",RESCTPCPDR,UserID)) q:UserID=""  d
	..s userName=$p(^SSU("SSUSR",UserID),"^",2)
	..S ListData=UserID_"^"_userName
	..q:$d(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName))
	..s h=h+1
	..s ^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,userName,h)=ListData
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	S Title="UserID^Username"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index="",user=""
	F  S user=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user)) Q:user=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user,index)) Q:index=""  D
	..S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","GetUserDr",pid,user,index))
	..S count = count+1
	..Q:(count<Start)||(count>End)
	..I count=Start D
	...W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	..E  D
	...W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Description: 查询[转抄明细]
/// Creator:     CongYue
/// CreateDate:  2021-03-18
/// Table: 		 DHC_MedAdrRepAuditItm
/// Input:  	 报告ID^报告类型代码
/// Output:  	 DHC_MedAdrRepAuditItm表中的数据信息   
/// Others:		 w ##class(web.DHCADVSEARCHREPORT).QueryTranMess(10,1,"16^advMedical")
ClassMethod QueryTranMess(rows, page, params As %String) As %String
{
	N (rows,page,params,%session)
	S endpage = page*rows
	S stpage = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
	S ReportID=$p(params,"^",1)
	S TypeCode=$p(params,"^",2)
	S TypeDr=$o(^DHCMEDADREVT(0,"Code",$$ALPHAUP^SSUTIL4(TypeCode),""))
	s Typeparref="",Typesub="" ;2018-08-29
	i TypeDr=""  d
	.S Typeparref=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),"")) //子表类别指向
	.S:Typeparref'="" Typesub=$o(^DHCMEDADREVTI(0,"ItmCode",$$ALPHAUP^SSUTIL4(TypeCode),Typeparref,""))
	.S:(Typeparref'="")&&(Typesub'="") TypeDr=Typeparref_"||"_Typesub
	S h=0,count=0
	S AuditID=""
	F  S AuditID=$o(^DHCMEDREPADT(0,"Pointer",TypeDr,ReportID,AuditID)) Q:AuditID=""  D
	.Q:'$d(^DHCMEDREPADT(AuditID,"MEDADRI"))
	.S Sub=""
	.F  S Sub=$o(^DHCMEDREPADT(AuditID,"MEDADRI",Sub)) Q:Sub=""  D
	..Q:Sub=0
	..S MedIAuditDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",1) // 转抄日期
	..I MedIAuditDate'="" S MedIAuditDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIAuditDate)
	..S MedIAuditTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",2) // 转抄时间
	..I MedIAuditTime'="" S MedIAuditTime=$zt(MedIAuditTime,1)
	..S MedIAuditUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",3) // 转抄人
	..S MedIAuditUser="",MedIAuditUserDR=""
	..S:MedIAuditUserCode'="" MedIAuditUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedIAuditUserCode),""))
	..S:MedIAuditUserDR'="" MedIAuditUser=$p(^SSU("SSUSR",MedIAuditUserDR),"^",2)
	..S MedINextLocCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",4) // 转抄指向科室
	..S MedINextLoc="",MedINextLocDR=""
	..S:MedINextLocCode'="" MedINextLocDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(MedINextLocCode),""))
	..S:MedINextLocDR'="" MedINextLoc=$p(^CTLOC(MedINextLocDR),"^",2)
	..S MedINextUserCode=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",5) // 转抄指向人员
	..S MedINextUser="",MedINextUserDR=""
	..S:MedINextUserCode'="" MedINextUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(MedINextUserCode),""))
	..S:MedINextUserDR'="" MedINextUser=$p(^SSU("SSUSR",MedINextUserDR),"^",2)
	..S MedIUserAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",6) // 人员回复意见
	..S MedIReceiveDR=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",7) // 接收状态
	..I MedIReceiveDR=""  S MedIReceiveDR="N"
	..S MedIReceive=$S(MedIReceiveDR="N":"未接收",MedIReceiveDR="Y":"接收",1:"")
	..S MedIReceiveDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",8) //接收日期
	..I MedIReceiveDate'="" S MedIReceiveDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedIReceiveDate)
	..S MedIReceiveTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",9) //接收时间
	..I MedIReceiveTime'="" S MedIReceiveTime=$zt(MedIReceiveTime,1)
	..S MedICompleteDate=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",10) //完成日期
	..I MedICompleteDate'="" S MedICompleteDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MedICompleteDate)
	..S MedICompleteTime=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",11) //完成时间
	..I MedICompleteTime'="" S MedICompleteTime=$zt(MedICompleteTime,1)
	..S MedILocAdvice=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",12) // 转抄科室处理意见部门意见
	..S AuditDutyFlag=$p(^DHCMEDREPADT(AuditID,"MEDADRI",Sub),"^",13) //备注
    ..I AuditDutyFlag="N"  S AuditDutyFlag=""
    ..I AuditDutyFlag="Y"  S AuditDutyFlag="该事件已报告本部门第一责任人"
	..S MedIAuditUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedIAuditUser)  ;2020-06-28 cy
	..S MedINextUser=##Class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",MedINextUser)  ;2020-06-28 cy
	..S MedINextLoc=##Class(web.DHCADVCOMMON).GetTransDesc("User.CTLoc","CTLOCDesc","",MedINextLoc)  ;2020-06-28 cy
	..S MedIReceive=##class(websys.Translation).Get("dhcadv.reportaudit.csp",MedIReceive)
	..S AuditDutyFlag=##class(websys.Translation).Get("dhcadv.reportaudit.csp",AuditDutyFlag)
	..S h=h+1
	..S TempStr=AuditID_"||"_Sub_"^"_MedIAuditDate_" "_MedIAuditTime_"^"_MedIAuditUserDR_"^"_MedIAuditUser_"^"_MedINextLocDR_"^"_MedINextLoc_"^"_MedINextUserDR_"^"_MedINextUser_"^"_MedIUserAdvice_"^"_MedIReceive_"^"_MedIReceiveDate_" "_MedIReceiveTime_"^"_MedICompleteDate_" "_MedICompleteTime_"^"_MedILocAdvice_"^"_AuditDutyFlag
	..S ^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranMess",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).GetNoJson()
	
	///转换数据为Json格式
	S Title="MedItmID^MedIAuditDateTime^MedIAuditUserDR^MedIAuditUser^MedINextLocDR^MedINextLoc^MedINextUserDR^MedINextUser^MedIUserAdvice^MedIReceive^MedIReceiveDateTime^MedICompleteDateTime^MedILocAdvice^DutyFlag"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranMess",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVSEARCHREPORT","QueryTranMess",pid,index))
	.S count = count+1
	.Q:(count<1)
	.I count=1 D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

}
