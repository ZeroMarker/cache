Import sqluser

/// 此类是接口类，通过外部接口传送数据等 LiangQiang
/// 
Class web.DHCADVINTERFACE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 保存用药安全事件报告  
/// Creator:     LiangQiang
/// CreateDate:  2016-2-23
/// Table: 		 DHC_MedSafetyReport
/// Input:  	 报告表数据，用户id^科室id^安全组id
/// Return： 	 数据id
/// w ##Class(web.DHCADVINTERFACE).SaveMedSafeRep(medsrDataList,medsrRepAuditList)
ClassMethod SaveMedSafeRep(medsrDataList As %String, medsrRepAuditList As %String) As %String
{
	n (medsrDataList,medsrRepAuditList)
	//s ^tlqq(medsrDataList)=""
	//s ^tlqq(medsrRepAuditList)=""
	s medsrDataList="89^2016-04-07^12:57^2016-04-07^01:00^夜班^1862608^41095709^李素英^女^61岁^03778^12U^1^DH444444^^6704"_$c(2)_"^^^6704"_$c(2)_"1-1^^^"_$c(1)_"1-11^^^^6704"_$c(2)_"^^^6704"_$c(2)_"2-1^^^^6704"_$c(2)_"3-1^5^6^^6704"_$c(2)_"4-2^7^8^^6704"_$c(2)_"^^^6704"_$c(2)_"^6704"_$c(2)_"^6704"_$c(2)_"aaaaa^6704"
	s medsrRepAuditList="3880^89^20"
	s EvtTypeCode="drugerr"
	s EvtTypeId=$o(^DHCMEDADREVT(0,"Code",EvtTypeCode,""))
	s medsrRepAuditList="^"_medsrRepAuditList_"^"_""_"^"_""_"^"_""_"^"_EvtTypeId
    s medsrDataLista=$tr(medsrDataList,$c(2),"$C(2)")
    s a1=$p(medsrDataList,$c(2),1)
    s a2=$p(medsrDataList,$c(2),2)
    s a3=$p(medsrDataList,$c(2),3)
    s a4=$p(medsrDataList,$c(2),4)
    s medsrDataList=a1_"$c(2)"_a2_"$c(2)"_a3_"$c(2)"_a4
    b //a
	s ret=##class(web.DHCADVMEDSAREPORT).Insert(medsrDataList,medsrRepAuditList)
	q ret
}

/// w ##class(web.DHCADVINTERFACE).GetPatBldRecord("12")
/// Description: 根据就诊号查询本次就诊的所有发血单信息  
/// Creator:     LiangQiang
/// CreateDate:  2016-3-2
/// Input:  	  就诊id
/// Return： 	  发血单信息
ClassMethod GetPatBldRecord(EpisodeID As %String) As %String
{
	 n (EpisodeID)
	 s result=##class(%Library.ResultSet).%New("LIS.Service.Qry.Nurse:QryPatIssueRecord")
	 s sc=result.Execute(EpisodeID)    
	 i $$$ISERR(sc) q ""
		 
	 s colNum=result.GetColumnCount()

     s colNameStr="issueId^issueDate^issueTime^IsTransBlood^IsReaction^Parity^Gravidity"
     s Start=0
     s Limit=10
	 s count = 0
	 s resultString = ""
	 s end = Start+Limit
	 s json = ##class(Code.JsonObj).%New()
	 While(result.Next())
	 { 
	  s ret=""
	  s issueId=result.%GetData(1)
      s issueDate=result.%GetData(2)
      s issueTime=result.%GetData(3)
      s IsTransBlood=result.%GetData(14) //是否有输血史
      s IsReaction=result.%GetData(16) //是否有输血不良反应史
      s Parity=result.%GetData(19)				//产次
	  s Gravidity=result.%GetData(20)			//孕次
      
	  s ret=issueId_"^"_issueDate_"^"_issueTime_"^"_IsTransBlood_"^"_IsReaction_"^"_Parity_"^"_Gravidity
	  s count = count+1

	  CONTINUE:count<(Start+1)
	  CONTINUE:count>end            
    
	  d json.InsertRowData(tmp)
	 }
	 d result.Close()
	 s resultString = json.getJsonData(colNameStr,count)
	 k json
	 Q resultString
}

/// Description: 根据发血单号查询血袋信息  
/// Creator:     LiangQiang
/// CreateDate:  2016-3-2
/// Input:  	  就诊id
/// Return： 	  发血单信息
ClassMethod GetPatBldRecordPacks(RecordId As %String) As %String
{
	 n (RecordId)
	 s result=##class(%Library.ResultSet).%New("LIS.Service.Qry.Nurse:QryIssueRecordPacks")
	 s sc=result.Execute(RecordId)    
	 i $$$ISERR(sc) q ""

	 s ret=""
	 While(result.Next())
	 { 

	  s packId=result.%GetData(5) //血袋编号
      s desc=result.%GetData(8) //血袋描述(血制品名称)
    
	  if ret="" s ret=packId_"^"_desc
	  e  s ret=ret_"!"_packId_"^"_desc
      

	 }
	 

	 Q ret
}

/// Description: 根据就诊号查询本次就诊的所有发血单信息  
/// Creator:     congyue
/// CreateDate:  2016-10-27
/// Input:  	  就诊id
/// Return： 	  发血单信息(出参（申请单号 ^ 发放日期 ^ 发放时间 ^ 是否有继往输血史@上次输血日期 ^ 是否有输血反应史@不良反应说明 ^ 是否孕产史@孕次@产次^发血单id） 若多条数据，以 $$ 进行分割)
/// other:w ##class(web.DHCADVINTERFACE).GetPatBldRecordNew("12","1","3378")  
ClassMethod GetPatBldRecordNew(rows As %String, page As %String, EpisodeID As %String) As %String
{
	N (rows,page,EpisodeID)
	Q:EpisodeID="" ""
	S BldRecordList=##CLASS(DHCLIS.DHCBloodInterface).GetPackIssueInfo(EpisodeID)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
    K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordNew",pid)  //k掉临时global
	S h=0,count=0
	I BldRecordList'="" D
	.S len=$L(BldRecordList,"$$")
	.F i=1:1:len D
	..S DataList=$p(BldRecordList,"$$",i)
	..S issFormNo=$p(DataList,"^",1) // 输血单申请单号
	..S issueDate=$p(DataList,"^",2) //发放日期
	..S:issueDate["-" issueDate=$zdh(issueDate,3)
	..S:(issueDate'="") issueDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(issueDate)
	..S issueTime=$p(DataList,"^",3) //发放时间
	..S IsTransBlood=+$p(DataList,"^",4) //是否有既往输血史
	..s IsTransBlood=$s(IsTransBlood=1:"是",IsTransBlood=0:"否",1:"")  //sufan 2019-11-13
	..S IsReaction=+$p(DataList,"^",5) //是否有输血反应史
	..s IsReaction=$s(IsReaction=1:"是",IsReaction=0:"否",1:"")  //sufan 2019-11-13
	..S Parity=$p($p(DataList,"^",6),"@",2) //孕次
	..S Gravidity=$p($p(DataList,"^",6),"@",3) //产次
	..S issueId=$p(DataList,"^",7) //发血单id
	..S h=h+1
	..S TempStr=issFormNo_"^"_issueDate_"^"_issueTime_"^"_IsTransBlood_"^"_IsReaction_"^"_Parity_"^"_Gravidity_"^"_issueId
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordNew",pid,h)=TempStr
	.
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="issFormNo^issueDate^issueTime^IsTransBlood^IsReaction^Parity^Gravidity^issueId"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordNew",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordNew",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordNew",pid) //k掉临时global
	Q ""
}

/// Description: 根据发血单id获取血袋信息  
/// Creator:     congyue
/// CreateDate:  2016-10-27
/// Input:  	  发血单id
/// Return： 	  血袋信息(血袋编号 ^ 血袋描述(血产品)^血型^配血方法^血袋血量)  若多条数据，以 $$ 进行分割
/// other:w ##class(web.DHCADVINTERFACE).GetPatBldRecordPacksNew("12","1","9")  
ClassMethod GetPatBldRecordPacksNew(rows As %String, page As %String, RecordId As %String) As %String
{
	N (rows,page,RecordId)
	Q:RecordId="" ""
	S BldRecordPacksList=##CLASS(DHCLIS.DHCBloodInterface).GetPackInfoByIssueId(RecordId)
	S End = page*rows
	S Start = (page-1)*rows+1
    S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew") //k掉临时global
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks") //k掉临时global
	S h=0,count=0
	S bldid=""
	S childSub=""
	S bldNos=""

	I BldRecordPacksList'="" D
	.S len=$L(BldRecordPacksList,"$$")
	.F i=1:1:len D
	..S DataList=$p(BldRecordPacksList,"$$",i)
	..S bldtype=$p(DataList,"^",2) //血液类别
	..S bldNos=$p(DataList,"^",1) //输血编号
	..S bldnum=+$p(DataList,"^",5) //输入血量
	..S h=h+1
	..S TempStr=bldtype_"^"_bldNos_"^"_bldnum
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks",pid,bldtype,h)=TempStr
	.
 
 	S index="",h=0,num=0
	S bldtype="",bldNos="",bldnums=0
	F  S bldtype=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks",pid,bldtype)) Q:bldtype=""  D
	.F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks",pid,bldtype,index)) Q:index=""  D
	..S mdates=$g(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks",pid,bldtype,index))
	..S bldNos=bldNos_"^"_$p(mdates,"^",2)
	..S bldnums=bldnums+(+$p(mdates,"^",3))
	..s num=num+1
	..i num=4 d
	...s h=h+1
	...S TempStr=""_"^"_bldtype_"^"_bldnums_"^"_bldNos
	...S ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew",pid,h)=TempStr
	...s bldNos="",bldnums="",num=0
	.S TempStr=""_"^"_bldtype_"^"_bldnums_"^"_bldNos
	.S h=h+1
	.S ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew",pid,h)=TempStr
	
	Q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="bldid^bldtype^bldnums^^bldone^bldtwo^bldthree^bldfour"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew",pid,index))
	.S count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacksNew") //k掉临时global
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetPatBldRecordPacks") //k掉临时global
	Q ""
}

/// Description: 查询所有不良事件类型描述
/// Creator:     yangyongtao
/// CreateDate:  2018-03-22  
/// Input:  	  
/// Output:   	 不良事件类型  value(desc,subdesc,parentid)
/// Others:		 w ##class(web.DHCADVINTERFACE).GetReportType("12","","")
ClassMethod GetReportType(pid As %String, type As %String, reptypecode) As %String
{
	N (pid,type,reptypecode)
	S h=0,count=0
	S ID="0"
	F  S ID=$o(^DHCMEDADREVT(ID)) Q:ID=""  D
	.S Code=$p(^DHCMEDADREVT(ID),"^",1) //代码
	.S Desc=$p(^DHCMEDADREVT(ID),"^",2) //描述
	.S ActiveFlag=$p(^DHCMEDADREVT(ID),"^",3)
	.;Q:(RepTypeCode'="")&(RepTypeCode'["adv")
	.Q:ActiveFlag="N"
	.;Q:Code="NursingRep"
	.S CodeFlag=""
	.S:Code["NursingRep" CodeFlag="H"
	.S:Code'["NursingRep" CodeFlag="D"
	.Q:(type'="")&(type'=CodeFlag)
	.s SubDesc=""
	.i $o(^DHCMEDADREVTI(ID,"MADREVI","")) D
	..s CH=""
	..F  S CH=$o(^DHCMEDADREVTI(ID,"MADREVI",CH)) Q:CH=""  D
	...S subCode=$p(^DHCMEDADREVTI(ID,"MADREVI",CH),"^",1)    //子类型代码
	...S SubDesc=$p(^DHCMEDADREVTI(ID,"MADREVI",CH),"^",2) //子类型描述
	...S Active=$p(^DHCMEDADREVTI(ID,"MADREVI",CH),"^",3) //是否可用
	...Q:Active="N"
	...Q:(reptypecode'="")&&(reptypecode'=subCode)
	...Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(subCode)))
	...S h=h+1
	...S TempStr=Desc_"^"_SubDesc_"^"_ID_"||"_CH_"^"_subCode
	...S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportType",pid,h)=TempStr
    .E  D
    ..Q:($d(^DHCMEDADREVTI(ID,"MADREVI")))  ;去除带有子元素的类型
	..Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))  ;去除不是表单的类型
	..Q:(reptypecode'="")&&(reptypecode'=Code)
	..S h=h+1
	..S TempStr=Desc_"^"_SubDesc_"^"_ID_"^"_Code
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportType",pid,h)=TempStr
	Q ""
}

///   D ##class(%ResultSet).RunQuery("web.DHCADVINTERFACE","QueryReportType","","")
Query QueryReportType(type As %String, reptypecode As %String) As %Query(ROWSPEC = "desc:%String,subdesc:%String,parentid:%String,code:%String") [ SqlProc ]
{
}

ClassMethod QueryReportTypeExecute(ByRef qHandle As %Binary, type As %String, reptypecode As %String) As %Status
{
   
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	S pid=##class(web.DHCADVMEDCOMMON).GetPID() 
	d ##Class(web.DHCADVINTERFACE).GetReportType(pid,type,reptypecode)
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportType",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportType",pid,index))
	.q:mdata=""
	.s ListData=$LISTFROMSTRING(mdata,"^")
	.s ^CacheTemp(repid,ind)=ListData	
	.s ind=ind+1
	d ..killTmpGlobal(pid)
	q $$$OK
}

ClassMethod QueryReportTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportTypeExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryReportTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 按条件查询报告明细数据
/// Creator:     yangyongtao
/// CreateDate:  2018-03-22  
/// Input:  	 开始日期^结束日期^病区科室Id^科室id^不良事件类型Id^登录用户信息^审核状态
/// Output:   	 序号^事件类型描述^事件类型子类描述^事件等级^病区科室Id^病区科室^审核状态^上报日期^上报时间
/// Output:      报告单Id^状态Code^病人姓名^性别^年龄^审核人^审核日期^点评^点评签名^病案号^主管医生姓名
/// Output:      费用类别^患者诊断^病床^事件发生原因^就诊id^报告人^报告类型Id^记录ID^状态ID^接收ID^发生日期^发生时间
/// Output:      ^报告上一状态^报告上一状态id^报告下一状态^报告下一状态id^报告待审批标识^大科护士长标识^归档标识^报告第一处理人^登录人id^登录科室id^登录安全组id   
/// Others:		 d ##class(web.DHCADVINTERFACE).GetReportDetail("","","")
ClassMethod GetReportDetail(pid As %String, StDate As %String, EndDate As %String, DeptID As %String, TypeID As %String, StrParam As %String, AuditStatus As %String, NurType As %String, hospitalId As %String, NurStatus As %String, Finish As %String = "") As %String
{
      
	N (pid,StDate,EndDate,DeptID,TypeID,StrParam,AuditStatus,NurType,hospitalId,NurStatus,Finish)
	D ..killTmpGlobal(pid)
	S StDate=$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3)
    S UserId=$p(StrParam,"^",1)    //用户ID    4805
    I UserId="" S UserId=0
    S LocId=$p(StrParam,"^",2)     //科室ID    193
    I LocId="" S LocId=0
    S GroupId=$p(StrParam,"^",3)   //安全组ID  23
    I GroupId="" S GroupId=0
    s DeptCode=""
    S iNNum=0
    S:DeptID'="" iNNum=$l(DeptID,"^")
	for i=1:1:iNNum
	{	
		set loc=$p(DeptID,"^",i)	
		s:DeptCode'="" DeptCode=DeptCode_"^"_$p(^CTLOC(loc),"^",1)
		s:DeptCode="" DeptCode=$p(^CTLOC(loc),"^",1)	
		
	 }
    
    S list=UserId_"^"_LocId_"^"_GroupId
	S h=0
	S ID=""
	F dd=StDate:1:EndDate D
	.//医疗
	.F  S ID=$o(^DHCMEDADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..q:ID'=""
	..S recordID="" 
	..S typedr=$p(^DHCMEDADRR(ID),"^",30)
	..q:typedr=""
	..S code=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型code
	..I typecode["adv"  S code="H"
	..Q:(NurType'="")&(NurType'=code)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S typesub="" 
	..S LevelID="",LevelDr=""
	..F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ...S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S AdmNo=$p(^DHCMEDADRR(ID),"^",33) //就诊ID
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..//Q:AdmNo=""
	..I AdmNo'="" D
	...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生
	..S RepStausDr=$p(^DHCMEDADRR(ID),"^",27) 
	..//Q:RepStausDr=""	
	..S RepStaus=""
	..S StausFlag="" //状态标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A"
	..E  D   
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S CreateDate=$p(^DHCMEDADRR(ID),"^",25) //报告日期  
	..I CreateDate'="" S CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCMEDADRR(ID),"^",26) //报告时间
	..I CreateTime'="" S CreateTime=$zt(CreateTime,1)
	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=$p(^DHCMEDADRR(ID),"^",12) //原因
	..S RepUserCode=$p(^DHCMEDADRR(ID),"^",19)   //报告人工号
	..S RepUserDr="",Reporter=""
	..S:RepUserCode'="" RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocCode=$p(^DHCMEDADRR(ID),"^",20)     //科室代码
	..S LocDr="",LocDesc="",hospID=""
	..S:LocCode'="" LocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..I LocDr'="" s hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S LocDesc=$p(^CTLOC(LocDr),"^",2)
	..i LocDesc["-" s LocDesc=$p(LocDr,"-",2) //科室
	
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
	..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptID'="")&(DeptID'=LocDr)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive

	.;药品   
	.F  S ID=$o(^DHCADVDRUGREP(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..q:ID'=""
	..S recordID="" 
	..S typedr=$p(^DHCADVDRUGREP(ID),"^",49)
	..q:typedr=""
	..S code=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型code
	..I typecode["adv"  S code="H"
	..Q:(NurType'="")&(NurType'=code)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S typesub=""
	..S LevelID="",LevelDr=""
	..F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ...S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S AdmNo=$p(^DHCADVDRUGREP(ID),"^",7) //就诊ID
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..//Q:AdmNo=""
	..I AdmNo'="" D
	...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生
	..S RepStausDr=$p(^DHCADVDRUGREP(ID),"^",48)
	..//Q:RepStausDr=""	
	..S RepStaus=""
	..S StausFlag="" //状态标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A"
	..E  D 
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S CreateDate=$p(^DHCADVDRUGREP(ID),"^",51)     //报告日期
	..S:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCADVDRUGREP(ID),"^",52)    //报告时间
	..S:CreateTime'="" CreateTime=$zt(CreateTime,1)
	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=$p(^DHCADVDRUGREP(ID),"^",47)      //备注
	..S RepUserCode=$p(^DHCADVDRUGREP(ID),"^",41)   //报告人工号
	..S RepUserDr="",Reporter=""
	..S:RepUserCode'="" RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocCode=$p(^DHCADVDRUGREP(ID),"^",42)     //科室代码
	..S LocDr="",LocDesc="",hospID=""
	..S:LocCode'="" LocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..I LocDr'="" s hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S LocDesc=$p(^CTLOC(LocDr),"^",2)
	..i LocDesc["-" s LocDesc=$p(LocDr,"-",2) //科室
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
    ..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptID'="")&(DeptID'=LocDr)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive
	
	.;器械
	.F  S ID=$o(^DHCMATADRR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..q:ID'=""
	..S recordID="" 
	..S typedr=$p(^DHCMATADRR(ID),"^",46)
	..q:typedr=""
	..S code=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型code
	..I typecode["adv"  S code="H"
	..Q:(NurType'="")&(NurType'=code)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S typesub=""
	..S LevelID="",LevelDr=""
	..F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ...S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S AdmNo=$p(^DHCMATADRR(ID),"^",48) //就诊ID
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..//Q:AdmNo=""
	..I AdmNo'="" D
	...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生
	..S RepStausDr=$p(^DHCMATADRR(ID),"^",41)
	..//Q:RepStausDr=""	
	..S RepStaus=""
	..S StausFlag="" //状态标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A"
	..E  D 
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S CreateDate=$p(^DHCMATADRR(ID),"^",39)    //报告日期
	..S:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCMATADRR(ID),"^",40)    //报告时间
	..S:CreateTime'="" CreateTime=$zt(CreateTime,1)
	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=$p(^DHCMATADRR(ID),"^",29) //事件发生初步原因分
	..S RepUserCode=$p(^DHCMATADRR(ID),"^",35)   //报告人工号
	..S RepUserDr="",Reporter=""
	..S:RepUserCode'="" RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocCode=$p(^DHCMATADRR(ID),"^",36)     //科室代码
	..S LocDr="",LocDesc="",hospID=""
	..S:LocCode'="" LocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..I LocDr'="" s hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S LocDesc=$p(^CTLOC(LocDr),"^",2)
	..i LocDesc["-" s LocDesc=$p(LocDr,"-",2) //科室
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
    ..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptID'="")&(DeptID'=LocDr)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive
	
	.;用药差错  
	.F  S ID=$o(^DHCADVMEDSAR(0,"CreateDate",dd,ID))  Q:ID=""  D 
	..q:ID'=""
	..S recordID="" 
	..S typedr=$p(^DHCADVMEDSAR(ID),"^",20) //类型ID
	..q:typedr=""
	..S code=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1) //类型code
	..I typecode["adv"  S code="H"
	..Q:(NurType'="")&(NurType'=code)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2) //类型
	..S typesub="" //子类型
	..S typesub=""
	..S LevelID="",LevelDr=""
	..F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ...S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S AdmNo=$p(^DHCADVMEDSAR(ID),"^",21) //就诊ID
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..//Q:AdmNo=""
	..I AdmNo'="" D
	...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生 
	..S RepStausDr=$p(^DHCADVMEDSAR(ID),"^",18)
	..//Q:RepStausDr=""	
	..S RepStaus=""
	..S StausFlag="" //状态标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A"
	..E  D 
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S CreateDate=$p(^DHCADVMEDSAR(ID),"^",2)    //报告 日期
	..S:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCADVMEDSAR(ID),"^",3)    //报告 时间
	..S:CreateTime'="" CreateTime=$zt(CreateTime,1)

	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=$p(^DHCADVMEDSAR(ID),"^",14)     //即时行动（原因）
	..S RepUserCode=$p(^DHCADVMEDSAR(ID),"^",15)   //报告人工号
	..S RepUserDr="",Reporter=""
	..S:RepUserCode'="" RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocCode=$p(^DHCADVMEDSAR(ID),"^",1)     //科室代码
	..S LocDr="",LocDesc="",hospID=""
	..S:LocCode'="" LocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..I LocDr'="" s hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S LocDesc=$p(^CTLOC(LocDr),"^",2)
	..i LocDesc["-" s LocDesc=$p(LocDr,"-",2) //科室
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
    ..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptID'="")&(DeptID'=LocDr)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive
	
	.;输血  
	.F  S ID=$o(^DHCBLDADVRPT(0,"CreateDate",dd,ID))  Q:ID=""  D
	..q:ID'=""
	..S recordID="" 
	..S typedr=$p(^DHCBLDADVRPT(ID),"^",47)
	..q:typedr=""
	..S code=""
	..S typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..I typecode["adv"  S code="H"
	..Q:(NurType'="")&(NurType'=code)
	..S type=$p(^DHCMEDADREVT(typedr),"^",2)
	..S typesub="" //子类型
	..S LevelID="",LevelDr=""
	..F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	...S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ...S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S AdmNo=$p(^DHCBLDADVRPT(ID),"^",7) //就诊ID
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..//Q:AdmNo=""
	..I AdmNo'="" D 
	...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生
	..S RepStaus=""
	..S RepStausDr=$p(^DHCBLDADVRPT(ID),"^",46)
	..//Q:RepStausDr=""	
	..S RepStaus=""
	..S StausFlag="" //状态标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A"
	..E  D 
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S CreateDate=$p(^DHCBLDADVRPT(ID),"^",4)    //报告日期
	..S:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCBLDADVRPT(ID),"^",5)    //报告时间
	..S:CreateTime'="" CreateTime=$zt(CreateTime,1) 
	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=$p(^DHCBLDADVRPT(ID),"^",41)   //临床处置(原因)
	..S RepUserCode=$p(^DHCBLDADVRPT(ID),"^",2)   //报告人工号
	..S RepUserDr="",Reporter=""
	..S:RepUserCode'="" RepUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(RepUserCode),""))
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocCode=$p(^DHCBLDADVRPT(ID),"^",1)     //科室代码
	..S LocDr="",LocDesc="",hospID=""
	..S:LocCode'="" LocDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),"")) 
	..I LocDr'="" s hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S LocDesc=$p(^CTLOC(LocDr),"^",2)
	..i LocDesc["-" s LocDesc=$p(LocDr,"-",2) //科室
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
    ..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptID'="")&(DeptID'=LocDr)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive
    
    .//新版不良事件
	.f  s ID=$o(^DHCADVMASTER(0,"RepDate",dd,ID)) q:ID=""  d
	..S code="",typeparcode="",reptypedr="",reptypecode="",type="",typedr="",typecode=""
	..S recordID=$p(^DHCADVMASTER(ID),"^",1)
	..Q:recordID=""
	..S typedr=$p(^DHCADVMASTER(ID),"^",2)
	..q:typedr=""
	..;S:(typedr'="")&&(typedr'["||") typecode=$p(^DHCMEDADREVT(typedr),"^",1)
	..;S:(typedr'="")&&(typedr["||") typecode=$p(^DHCMEDADREVTI(+typedr,"MADREVI",$p(typedr,"||",2)),"^",1)
	..S:(typedr'="") typeparcode=$p(^DHCMEDADREVT(+typedr),"^",1)
	..S:typeparcode="NursingRep" code="H"
	..S:typeparcode'="NursingRep" code="D"
	..Q:(NurType'="")&(NurType'=code)
	..;S:(typedr'="")&&(typedr'["||") type=$p(^DHCMEDADREVT(typedr),"^",2)
	..;S:(typedr'="")&&(typedr["||") type=$p(^DHCMEDADREVTI(+typedr,"MADREVI",$p(typedr,"||",2)),"^",2)
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id） 2020-06-22
	..S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(ID)
	..S reptypedr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S reptypecode=$p(RepTypeString,"^",2)
	..S type=$p(RepTypeString,"^",3)
	..S typedr=$p(RepTypeString,"^",4)
	..S typecode=$p(RepTypeString,"^",5)
	
	..S typesub=$p(^DHCADVMASTER(ID),"^",8) //子类型
	..S LevelID="",LevelDr=""
	..;F  S LevelID=$o(^DHCADVREPMAN(0,"Pointer",ID,LevelID))  Q:LevelID=""  D
	..;.S LevelDr=$p(^DHCADVREPMAN(LevelID),"^",3)
    ..;.S LevelDr=$S(LevelDr="0":"非不良事件",LevelDr="1":"Ⅰ级警告事件",LevelDr="2":"Ⅱ级不良后果事件",LevelDr="3":"Ⅲ级未造成后果事件",LevelDr="4":"Ⅳ级隐患事件",1:"")
	..S LevelDr=$p(^DHCADVMASTER(ID),"^",12)
	..S:LevelDr["：" LevelDr=$p(LevelDr,"：",1)
	..S PatInfo="",curBedcode="",PatName="",PatSex="",PatAge="",medicalNo="",AdmReason="",PatDiag="",AdmDocID="",AdmDoc=""
	..S AdmNo=$p(^DHCADVMASTER(ID),"^",16) //就诊ID
	..//Q:AdmNo=""
	..I AdmNo'="" D
    ...S PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmNo)
	...S curBedcode=$p(PatInfo,"^",1) //床位号
	...S PatName=$p(PatInfo,"^",2) //病人姓名
	...S PatSex=$p(PatInfo,"^",3) //性别
	...S PatAge=$p(PatInfo,"^",4) ////年龄
	...S medicalNo=$p(PatInfo,"^",5) //病案号
	...S AdmReason=$p(PatInfo,"^",6)  //费用类别
	...;S PatDiag=##class(DtPortal.Doctor.DHCDocComService).GetMainDiagnosis(AdmNo) //诊断
	...S PatDiag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmNo)  //诊断
	...s AdmDoc=""
	...s AdmDocID=$p(^PAADM(AdmNo),"^",9) 
	...s:AdmDocID'="" AdmDoc=$p(^CTPCP(AdmDocID,1),"^",2) //医生
	
	..S CreateDate=$p(^DHCADVMASTER(ID),"^",4) //报告日期
	..S:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..S CreateTime=$p(^DHCADVMASTER(ID),"^",5)  //报告时间
	..S:CreateTime'="" CreateTime=$zt(CreateTime,1) 
	..S occdate=$p(^DHCADVMASTER(ID),"^",25)  ///发生日期
	..S:occdate'="" occdate=$zd(occdate,3)
	..S occtime=$p(^DHCADVMASTER(ID),"^",26)  ///发生时间
	..S:occtime'="" occtime=$zt(occtime,1)
	..S matadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1) //获取审批表的ID 
	..Q:matadrID=""
	..S matadReceive=$p(^DHCMEDREPADT(matadrID),"^",9) //报告接收状态
	..S matadrInvaild=$p(^DHCMEDREPADT(matadrID),"^",11) //报告作废状态
	..Q:matadrInvaild="Y" //如果报告已经作废不显示该报告
	..S AuditUserDR=""
	..S AuditUserDR=$p(^DHCMEDREPADT(matadrID),"^",4) //审批人
	..S AuditUser=""
	..S:AuditUserDR'="" AuditUser=$p(^SSU("SSUSR",AuditUserDR),"^",2)
	..S AuditLocID=$p(^DHCMEDREPADT(matadrID),"^",12) //审批科室
	..S AuditDate=$p(^DHCMEDREPADT(matadrID),"^",5) //审批日期
	..I AuditDate'="" S AuditDate=$zd(AuditDate,3)
	..S AuditTime=$p(^DHCMEDREPADT(matadrID),"^",6) //审批时间
	..I AuditTime'="" S AuditTime=$zt(AuditTime,1)
	..S Review=""    //   点评
	..S ReviewName="" //  点评签名
	..S Reason=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"原因分析") //事件经过(原因)
	..S RepUserDr=$p(^DHCADVMASTER(ID),"^",6)   //报告人ID
	..S Reporter=""
	..S:RepUserDr'="" Reporter=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S LocDr=$p(^DHCADVMASTER(ID),"^",7)     //科室ID
	..S LocCode="",LocDesc="",hospID=""
	..S:LocDr'="" LocCode=$p($g(^CTLOC(LocDr)),"^",1)     //科室Code
	..S:LocDr'="" LocDesc=$p($g(^CTLOC(LocDr)),"^",2) //科室Desc
	..s:LocDr'="" hospID=$p($g(^CTLOC(LocDr)),"^",22)
	..S RepList=typedr_"^"_LocDr_"^"_RepUserDr_"^"_ID 
	..S flag=""
	..I (UserId=0)&&(LocId=0)&&(GroupId=0)  S flag=1
	..E  S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,list)
   
    ..S RepStausDr=$p(^DHCADVMASTER(ID),"^",3)
    ..S RepLevel=$p(^DHCADVMASTER(ID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",typedr,ID,""),-1)
	..s MedadrNextLocDR=""
	..S:MedadrID'="" MedadrNextLocDR=$p(^DHCMEDREPADT(MedadrID),"^",7) ;指向科室（分派科室）
	..S Listt=ID_"^"_typedr_"^"_list_"^"_RepStausDr_"^"_MedadrNextLocDR_"^"_RepLevelDr
	..S StatusLastID="",StatusLast="",StatusNextID="",StatusNext="",RepAppAuditFlag=0
	..I (UserId=0)&&(LocId=0)&&(GroupId=0) D
	...S RepAppAuditFlag=0
	..E  D
	...S matalast=##class(web.DHCADVCOMMON).InsStatusLast(Listt) 
	...S StatusLastID=$p(matalast,"^",2)  //上一状态
	...I StatusLastID'=""  D
	....S AdrewRowIDnLast=$p(StatusLastID,"||",1)
	....S AdrewChildSubnLast=$p(StatusLastID,"||",2)
	....S StatusLast=$p(^DHCADREVTWFI(AdrewRowIDnLast,"ADREWI",AdrewChildSubnLast),"^",2)
	...S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	...S StatusNextID=$p(matalist,"^",2)  //下一状态
	...I StatusNextID'=""  D
	....S AdrewRowIDn=$p(StatusNextID,"||",1)
	....S AdrewChildSubn=$p(StatusNextID,"||",2)
	....S StatusNext=$p(^DHCADREVTWFI(AdrewRowIDn,"ADREWI",AdrewChildSubn),"^",2)
	...S StatusNextIDaudit=##class(web.DHCADVCOMMON).GetRepNextStatusDr(Listt)
	...S:StatusNextIDaudit=StatusNextID RepAppAuditFlag=1
	..S UserLeadflag=##class(web.DHCADVCOMMONPART).GetSecuUserLeader(UserId)
	..S FILERowID=$o(^DHCADVFILE(0,"RepDrType",ID,reptypedr,""))
	..S File="",FileFlag=""
	..S File="",FileFlag=""
	..s LgParam=list_"^"_hospitalId
	..S:FILERowID'="" File=$p(^DHCADVFILE(FILERowID),"^",3)
	..s:(File'="Y")||(File'="N") File=##class(web.DHCADVCOMMONPART).JudgeIsOutCome(ID,reptypedr,LgParam)
	..S FileFlag=$S(File="0":"未归档",(File="1")||(File="3"):"已归档",File="4":"归档(待复核)",(File="2")||(File="5"):"撤销归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..;S FileFlag=$S(File="":"未归档",File="N":"撤销归档",File="Y":"已归档",1:"")
	..S Subflag=0
	..S SubUserflag=0 
	..S MedadrRevStatus=$p(^DHCMEDREPADT(matadrID),"^",14) ;驳回指向
	..S StaFistAuditUser="",StaFistAuditUserDr=""
	..S:(typedr'="")&&(MedadrRevStatus'="") StaFistAuditUserDr=##class(web.DHCADVCOMMON).GetStaFisUserID(ID, typedr, MedadrRevStatus ) ;$o(^DHCMEDREPADT(0,"TypeSta",RepTypeDr,MedadrRevStatus,""))
	..S:StaFistAuditUserDr'="" StaFistAuditUser=$p(^SSU("SSUSR",StaFistAuditUserDr),"^",2) ;被驳回人
	..S RepStaus=""
	..S StausFlag=""  //状态标识
	..S NurStatusFlag="" //护理部审核标识
	..I RepStausDr'="" D
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)  //审核状态
	...S StausFlag="A" 
	...;S:RepAppAuditFlag=1 NurStatusFlag="S" //护理部待审核
	...;S:(matadReceive=4)&&(AuditUserDR=UserId) NurStatusFlag="A"   //护理部已审核
	...;I NurStatus="T" D
    ...;.I (RepAppAuditFlag=1)||((matadReceive=4)&&(AuditUserDR=UserId)) S NurStatusFlag="T"
	..E  D 
	...I RepStaus=""  S RepStaus="未提交" 
	...S StausFlag="S" 
	..S StsusGrant=0
	..S:RepStausDr'="" StsusGrant=##class(web.DHCADVCOMMON).CheckWorkItmGrant(RepStausDr,list) 
    ..S CurOrderNo="",NextOrderNo=""
	..S:RepStausDr'="" CurOrderNo=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",3)
	..S:CurOrderNo'="" NextOrderNo=$o(^DHCADREVTWFI(0,"OrderNo",+RepStausDr,CurOrderNo))
    ..Q:flag'=1
	..Q:(TypeID'="")&(TypeID'=typedr)
	..Q:(DeptCode'="")&(DeptCode'[LocCode)
	..Q:(AuditStatus'="")&(AuditStatus'=StausFlag)
	..q:(hospitalId'="")&&(hospitalId'=hospID)
	..;Q:(NurStatus'="")&&(NurStatus'=NurStatusFlag)
	..Q:(Finish="Y")&&((NextOrderNo'="")||(RepStausDr=""))
	..Q:(Finish="N")&&(NextOrderNo="")&&(RepStausDr'="")
	..Q:(NurStatus="S")&&(RepAppAuditFlag'=1)  ;校验报告是否为本人待审批的报告
	..Q:(NurStatus="A")&&((AuditUserDR'=UserId)||(matadReceive'="4"))  ;校验报告是否为本人已审批的报告	
	..S h=h+1 
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,h)=type_"^"_typesub_"^"_LevelDr_"^"_LocDr_"^"_LocDesc_"^"_RepStaus_"^"_CreateDate_"^"_CreateTime_"^"_ID_"^"_typecode_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AuditUser_"^"_AuditDate_"^"_Review_"^"_ReviewName_"^"_medicalNo_"^"_AdmDoc_"^"_AdmReason_"^"_PatDiag_"^"_curBedcode_"^"_Reason_"^"_AdmNo_"^"_Reporter_"^"_typedr_"^"_recordID_"^"_RepStausDr_"^"_matadReceive_"^"_occdate_"^"_occtime_"^"_StatusLast_"^"_StatusLastID_"^"_StatusNext_"^"_StatusNextID_"^"_RepAppAuditFlag_"^"_UserLeadflag_"^"_FileFlag_"^"_StaFistAuditUser_"^"_StsusGrant
    
   Q ""
}

/// 5318^^25  D ##class(%ResultSet).RunQuery("web.DHCADVINTERFACE","QueryReportDetail","2018-12-01","2019-12-26","","","","","D","","","")
Query QueryReportDetail(StDate As %String, EndDate As %String, DeptID As %String, TypeID As %String, StrParam As %String, AuditStatus As %String, NurType As %String, hospitalId As %String = "", NurStatus As %String = "", Finish As %String = "") As %Query(ROWSPEC = "id:%String,desc:%String,subdesc:%String,grade:%String,locdr:%String,locdesc:%String,statusdesc:%String,emrdate:%String,emrtime:%String,reportid:%String,statuscode:%String,comment:%String,sex:%String,age:%String,recaudituser:%String,recauditdate:%String,DianPing:%String,name:%String,medicalNo:%String,doctor:%String,costCategories:%String,diagnosis:%String,bed:%String,eventInfo:%String,EpisodeId:%String,emruser:%String,typeid:%String,recordr:%String,stausdr:%String,receivedr:%String,occdate:%String,occtime:%String,statuslast:%String,statuslastid:%String,statusnext:%String,statusnextid:%String,repappauditflag:%String,userleadflag:%String,fileflag:%String,stafistaudituser:%String,stsusgrant:%String") [ SqlProc ]
{
}

ClassMethod QueryReportDetailExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, DeptID As %String, TypeID As %String, StrParam As %String, AuditStatus As %String, NurType As %String, hospitalId As %String = "", NurStatus As %String = "", Finish As %String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	S pid=##class(web.DHCADVCOMMON).NewPid()
	d ##Class(web.DHCADVINTERFACE).GetReportDetail(pid,StDate,EndDate,DeptID,TypeID,StrParam,AuditStatus,NurType,hospitalId,NurStatus,Finish)
	S typedr=""
	F  S typedr=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr)) Q:typedr=""  D
	.S index=""
	.F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,index)) Q:index=""  D
	..S mdata=ind_"^"_$g(^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid,typedr,index))
	..q:mdata=""
	..s ListData=$LISTFROMSTRING(mdata,"^")
	..s ^CacheTemp(repid,ind)=ListData	
	..s ind=ind+1
	d ..killTmpGlobal(pid)
	q $$$OK
}

ClassMethod QueryReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportDetailExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:     yangyongtao
/// CreateDate:  2018.04.10
/// Description: 护理部审核报告
/// Table:       DHC_AdvMaster
/// Input:       RepID,RepStausDr,Receive,UserId,RepTypeDr,typecode ||  报告ID,状态ID,接收ID,用户ID,类型ID,类型Code  
/// Output:      
/// Return：     
/// Others:      w ##class(web.DHCADVINTERFACE).NurAuditReport("11","10||3","4","1496","82","advAccidentFill")     
ClassMethod NurAuditReport(RepID As %String, RepStausDr As %String, Receive As %String, UserCode As %String, RepTypeDr As %String, typecode As %String) As DtPortal.OutPut
{
	
	N (RepID,RepStausDr,Receive,UserCode,RepTypeDr,typecode)
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
  	Set $ZT = "ErrSendMessage1"
	
	//I typecode["adv"  S typecode="NursingRep"
	S UserId=""
	S:UserCode'="" UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	S LocId="",GroupId=""
	I LocId=""  S LocId=0    //科室ID
	I GroupId="" S GroupId=0    //安全组ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S Listt=RepID_"^"_RepTypeDr_"^"_list_"^"_RepStausDr
	S matalist=##class(web.DHCADVCOMMON).InsStatusDr(Listt) 
	S StatusNextID=$p(matalist,"^",2)  //下一状态
	S NextLoc=""     //下一科室ID
	S LocAdvice=""     //审核意见	
	S params=RepID_"^"_StatusNextID_"^"_UserId_"^"_LocId_"^"_GroupId_"^"_NextLoc_"^"_LocAdvice_"^"_Receive_"^"_typecode
	s str= ##class(web.DHCADVCOMMONPART).AuditReport(params)
	i (str=0) {
		Set ret.status = 1
		Set ret.errMSG = ""
		
	}else{
		Set ret.status = -2
		Set ret.errMSG = "审核失败"
	}

	set ret.data=str
	b ;end
	Quit ret
	
ErrSendMessage1
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = $ZE
	Set ret.data = "程序错误"
	b ;err
	Quit ret
}

ClassMethod killTmpGlobal(pid)
{
 
    k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportDetail",pid)
    k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryReportType",pid)
}

/// Description: 根据发血单id获取血袋信息  
/// Creator:     congyue
/// CreateDate:  2018-09-25 
/// Input:  	  发血单id
/// Return： 	  血袋信息(血袋编号 ^ 血袋描述(血产品)^血型^配血方法^血袋血量)  若多条数据，以 $$ 进行分割
/// other:w ##class(web.DHCADVINTERFACE).GetPatBldRecordPacksNew("12","1","9")  
ClassMethod GetPatBldRecordPacksList(BldRecordId As %String) As %String
{
	N (BldRecordId)
	Q:BldRecordId="" ""
	S BldRecordPacksList=##CLASS(DHCLIS.DHCBloodInterface).GetPackInfoByIssueId(BldRecordId)
	Q BldRecordPacksList
}

/// Description:	不良事件按人员统计填写报告数量（药房药库 临床药学产品使用）
/// Creator:		Congyue
/// CreateDate:		2019-01-08
/// Input:			开始日期(M 格式),结束日期(M 格式),报告类型code
/// return:			数据多条以$$进行分割  人员id^人员code^人员描述^报告数量 $$ 人员code^人员描述^报告数量 ……
/// other:		w ##class(web.DHCADVINTERFACE).GetRepStaticInfo(64649,65539,"advDrug",1)
ClassMethod GetRepStaticInfo(StDate As %String, EndDate As %String, RepCode As %String, HospID As %String) As %String
{
	N (StDate,EndDate,RepCode,HospID)
	
	S pid=##class(web.DHCADVCOMMON).NewPid()
    K ^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid)  //k掉临时global
	F dd=StDate:1:EndDate  D
	.s RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,"RepDate",dd,RepID)) q:RepID=""  d
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:RepCode'=RepTypeCode
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3) //当前状态
	..Q:RepStausDr=""
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6) //报告人
	..Q:RepUserDr=""
	..S careProv=$p(^SSU("SSUSR",RepUserDr),"^",14)	// 医护人员表
	..Q:careProv=""
	..S carPrvTp=$p(^CTPCP(careProv,1),"^",4)		// 医护人员类型
	..Q:carPrvTp=""
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..s RepHospID=""
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..Q:(HospID'="")&&(RepHospID'="")&&(RepHospID'=HospID)
	..S internalType=$p(^CT("CPT",carPrvTp),"^",4)	// 类型 护士(NURSE) 医生(DOCTOR) 技师(Technician) 药师(Pharmacist) 其他(Other)
	..S internalType=$zcvt(internalType,"U")
	..Q:internalType'="PHARMACIST"					// 过滤不是药师填写报告 	
	..S userCode=$p(^SSU("SSUSR",RepUserDr),"^",1)   //工号
	..S userName=$p(^SSU("SSUSR",RepUserDr),"^",2)   //姓名
	..I '$d(^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,RepUserDr))  D
	...S ^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,RepUserDr)=RepUserDr_"^"_userCode_"^"_userName_"^"_1 
	..E  D
	...S $p(^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,RepUserDr),"^",4)=$p(^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,RepUserDr),"^",4)+1 
	S RepListInfo=""
	S index=""
	F  S index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,index)) Q:index=""  D
	.S ListData=$g(^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid,index))
	.I RepListInfo=""  D
	..S RepListInfo=ListData
	.E  D
	..S RepListInfo=RepListInfo_"$$"_ListData
	K ^TMP("DHCADV","web.DHCADVINTERFACE","GetRepStaticInfo",pid)  //k掉临时global
	Q RepListInfo
}

/// Descript:根据维护，输出维护的列接口
/// $c(2):分割每条数据，$c(1):分割每条的每个字段，$c(4):每条数据中的表格的每行，$c(3):表格的每列
/// Creator:sufan
/// CreateDate:20200406
/// Input:开始日期，结束日期
/// Output:维护的数据列信息
/// w ##class(web.DHCADVINTERFACE).QueryAdvData("2020-6-2","2020-6-12")
ClassMethod QueryAdvData(StDate, EndDate)
{
	n (StDate,EndDate)
	Q:(StDate = "")||(EndDate = "") ""
	s StDate = $zdh(StDate,3)
	s EndDate = $zdh(EndDate,3)
	
	s pid=##class(web.DHCADVCOMMON).NewPid()
	k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvData",pid)
	k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryInterface",pid)
	///取接口列
	s InteId = "0"
	for  s InteId = $o(^DHCADVAFC(InteId)) Q:InteId=""  d
	.s ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvData",pid,InteId) = InteId
	
	///取接口数据
	s count = 0
	for date = StDate:1:EndDate  d
	.s MasterId = ""
	.for  s MasterId = $o(^DHCADVMASTER(0,"RepDate",date,MasterId))  Q:MasterId=""  d
	..s List=""
	..s RecordId = $p(^DHCADVMASTER(MasterId),"^",1)
	..s Column = "" 
	..for  s Column = $o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvData",pid,Column)) q:Column=""  d
	...s ColCode = $p(^DHCADVAFC(Column),"^",1)									//接口code
	...s ConInfo = ..GetDicContrast(Column, RecordId)							//取对照元素
	...s ConDicId = $p(ConInfo,"^",1)
	...s ConCode = $p(ConInfo,"^",2)
	...s RecordItm = +$o(^User.DHCAdvFormRecordItmI("IndexDic",RecordId,ConDicId,""))
	...s HasChild = ##class(web.DHCADVEXPFIELD).IsHasChildDic(ConDicId)  		//判断是否有子元素
	...s DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(ConDicId)
	...s DicStyle = $p(DicInfo,"^",3)
	...s RecordItmValue = ""
	...i DicStyle="datagrid"  d
	....s RecordItmValue = ..GetTableData(RecordId,ConCode,pid) 
	...i (DicStyle="label")&&(HasChild'=0)  d 						 			//有子元素的取下级	  		 							//元素类型      
	....s RecordItmValue=..GetSubValue(RecordId, ConDicId, pid)
	...e   d
	....s:RecordItm'=0 RecordItmValue=$LG(^User.DHCAdvFormRecordItmD(RecordItm),4)
	...i List=""  s List=ColCode_":"_RecordItmValue
	...e  s List=List_$c(1)_ColCode_":"_RecordItmValue
	..s count=count+1
	..s ^TMP("DHCADV","web.DHCADVINTERFACE","QueryInterface",pid,count)=List
	
	s ListData=""
	s Index=""
	for  s Index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryInterface",pid,Index)) Q:Index=""  d
	.s data=^TMP("DHCADV","web.DHCADVINTERFACE","QueryInterface",pid,Index)
	.i ListData=""  s ListData=data
	.e  s ListData=ListData_$c(2)_data
	k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvData",pid)
	k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryInterface",pid)
	Q ListData
}

/// Descript:取对照元素
/// Creator:sufan
/// CreateDate:20200406
/// Input:元素ID,表单记录Id
/// Output:已对照元素ID
/// w ##class(web.DHCADVINTERFACE).GetDicContrast(3,720)
ClassMethod GetDicContrast(DicId, RecordId)
{
	n (DicId,RecordId)
	Q:DicId="" 0
	s ColCode=$p(^DHCADVAFC(DicId),"^",1)	
	s ForNameId=$LG(^User.DHCAdvFormRecordD(RecordId),2)
	s FormNameCode=$LG(^User.DHCAdvFormNameD(ForNameId),2)
	Q:'$d(^DHCADVDC(0,"FromCode",1,ColCode,FormNameCode)) 0
	s FormDicCode=$o(^DHCADVDC(0,"FromCode",1,ColCode,FormNameCode,""))
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(FormDicCode),""))
	Q FormDicId_"^"_FormDicCode
}

/// Descript:取子元素值
/// Creator:sufan
/// CreateDate:20200406
/// Input:元素ID,pid
/// Output:
/// w ##class(web.DHCADVINTERFACE).GetDicContrast(9,49)
ClassMethod GetSubItem(ConDicId, pid)
{
	n (ConDicId,pid)
	s RetValue=""
	
	s Ret=0
	s SubId=""
	for  s SubId=$o(^User.DHCAdvFormDicI("IndexParef"," "_ConDicId,SubId)) Q:SubId=""  d
	.s ^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid,ConDicId,SubId)=SubId
	.i $d(^User.DHCAdvFormDicI("IndexParef",""_SubId))  d
	.s Ret=..GetSubItem(SubId,pid)
	
	Q Ret
}

/// Descript:取子元素值
/// Creator:sufan
/// CreateDate:20200406
/// Input:元素ID,pid
/// Output:
/// w ##class(web.DHCADVINTERFACE).GetSubValue(49,93776,1)
ClassMethod GetSubValue(RecordId, ConDicId, pid)
{
	n (RecordId,ConDicId,pid)
	s RetValue=""
	s Ret=0
	k ^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid)
	s Ret= ..GetSubItem(ConDicId, pid)			//存数据
	Q:Ret'=0 "-1"
	s RetValue=..QueryItemValue(RecordId, ConDicId, pid,.RetValue)		//取数据
	k ^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid)
	Q RetValue
}

/// Descript:递归取值
/// Creator:sufan
/// CreateDate:20200406
/// Input:表单记录id，元素Id，pid，返回值
/// Output:
/// w ##class(web.DHCADVINTERFACE).GetDicContrast(9,49)
ClassMethod QueryItemValue(RecordId, ConDicId, pid, RetValue)
{
	n (RecordId, ConDicId, pid,RetValue)
	s ret=""
	s Index=""
	for  s Index=$o(^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid,ConDicId,Index))  Q:Index=""  d
	.s RecordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",RecordId,Index,""))
	.s RecordItmValue=""
	.s:RecordItm'=0 RecordItmValue=$LG(^User.DHCAdvFormRecordItmD(RecordItm),4)
	.i (RecordItm=0)&&($d(^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid,Index))) d
	..i RetValue="" s RetValue=$lg(^User.DHCAdvFormDicD(Index),4)
	..e  s RetValue=RetValue_""_$lg(^User.DHCAdvFormDicD(Index),4)
	.i RetValue=""  d
	..i RecordItmValue'="" s RetValue=RecordItmValue
	.e   d
	..i RecordItmValue'="" s RetValue=RetValue_"、"_RecordItmValue
	.i $d(^TMP("DHCADV","web.DHCADVINTERFACE","GetSubItem",pid,Index))  d
	..d ..QueryItemValue(RecordId,Index,pid,.RetValue)
	Q RetValue
}

/// Descript:取表格数据
/// Creator:sufan
/// CreateDate:20200406
/// Input:表单记录id，元素Id
/// Output:
/// w ##class(web.DHCADVINTERFACE).GetTableData(722,"SuspectNewDrug",1)
ClassMethod GetTableData(RecordId, ConCode, pid)
{
	n (RecordId,ConCode,pid)
	s Count=0
	s repid=pid
	k ^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData")
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$zcvt(ConCode,"U"),""))
	s Style=$lg(^User.DHCAdvFormDicD(FormDicId),3)
	s title=..getTableKeyCol(1,ConCode)								//json数据key
	
	q:RecordId="" ""
	s RsDate="",RsString=""
	s RecordItmId=""
	f  s RecordItmId = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",RecordId,RecordItmId))  q:RecordItmId=""  d
	.s TbFormDicId = $lg(^User.DHCAdvFormRecordItmD(RecordItmId),3)  	//元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(RecordItmId),4)  		//值
	.s ItmID = $lg(^User.DHCAdvFormDicD(TbFormDicId),2)        			//元素唯一标示，对应界面的ID
	.q:ItmID'[ConCode         											//只保留表格数据
	.q:ItmValue="title"
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(RecordItmId	),7)	//Key
	.q:DataRowKey=""
	.s Count=Count+1
	.s ListData=ItmID_"^"_ItmValue
	.Q:+TbFormDicId=0
	.s:Style="table" MiddId=..getNumSecCode(TbFormDicId,ConCode)
	.s:Style="datagrid" MiddId=TbFormDicId
	.i $d(^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,MiddId)) d
	..s $p(^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,MiddId),"^",2)=$p(^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,MiddId),"^",2)_","_ItmValue
	.e  s ^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,MiddId)=ListData
	s Num=0,ret=""
	s DataRowKey=0
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey)) q:DataRowKey=""  d
	.s Count=0,RsData="",ListTitle=""
	.f  s Count = $o(^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,Count)) q:Count=""  d
	..s Data = ^TMP("DHCADV","web.DHCADVINTERFACE","GetTableData",repid,DataRowKey,Count)
	..i RsData = "" s RsData = $lg(^User.DHCAdvFormDicD(Count),2)_":"_$p(Data,"^",2)
	..e  s RsData = RsData _$c(3)_$lg(^User.DHCAdvFormDicD(Count),2)_":"_$p(Data,"^",2)
	.i ret = "" s ret = RsData
	.e  s ret = ret_$c(4)_RsData
	q ret
}

/// Descript:根据行取table的每列code
/// Creator:sufan
/// Input:table 行号，table 的code
/// w ##class(web.DHCADVRepPrint).getTableKeyCol(1,"BloodGiveList")
ClassMethod getTableKeyCol(Colnum, TableKye)
{
	n (Colnum,TableKye)
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$zcvt(TableKye,"U"),""))
	s Style=$lg(^User.DHCAdvFormDicD(FormDicId),3)
	s Colnum=" "_Colnum
	s ColnumId=""
	s QuitStr="",QuitId=""    //定义返回的code串，定义对应行号的元素ID
	i Style="table"  d		//datagrid 取key
	.for  s ColnumId=$o(^User.DHCAdvFormDicI("IndexTitle",Colnum,ColnumId)) Q:ColnumId=""  d
	..s Filed=$List(^User.DHCAdvFormDicD(ColnumId),2)
	..Q:Filed'[TableKye
	..s QuitId=ColnumId
	e  d
	.s QuitId=FormDicId
	Q:QuitId="" ""
	///循环取table每列的code
	s FormDicId=""
	for  s FormDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_QuitId,FormDicId))  Q:FormDicId=""  d
	.s Filed=$List(^User.DHCAdvFormDicD(FormDicId),2)
	.i QuitStr="" s QuitStr=Filed
	.e  s QuitStr=QuitStr_"^"_Filed
	Q QuitStr
}

/// Descript:通过元素ID取table第二行元素的code
/// Creator:sufan
/// Input:元素code,table code
/// w ##class(web.DHCADVRepPrint).getNumSecCode(94438,"BloodGiveList")
ClassMethod getNumSecCode(DicId, TableCode)
{
	n (DicId,TableCode)
	s QuitStr=""
	s TableCode=$$ALPHAUP^SSUTIL4(TableCode)
	s TableId=$o(^User.DHCAdvFormDicI("IndexField",TableCode,""))
	s TableDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_TableId,""),-1)
	
	s QuitId=..GetParref(DicId,TableDicId)
	Q QuitId
}

/// Descript:	根据元素id取上级ID
/// Creator:sufan
/// Input:		元素ID,对比的元素ID
/// w ##class(web.DHCADVRepPrint).GetParref(98279,98287)
ClassMethod GetParref(FormDicId, MiddKey = "")
{
	n (FormDicId,MiddKey)
	s ret=""
	s ParrefId=+$List(^User.DHCAdvFormDicD(FormDicId),6)
	i (ParrefId=0)||(MiddKey="") Q FormDicId
	i (MiddKey'="")&&(ParrefId=MiddKey)  Q FormDicId
	e  s FormDicId=..GetParref(ParrefId,MiddKey)
	Q FormDicId
}

/// Descript:
/// Description: 根据就诊id获取病人手术信息  
/// Creator:     congyue
/// CreateDate:  2020-05-21 
/// Input:  	  发血单id
/// Return： 	  CIS.AN.DTO.OperInfo 对象列表
/// other:w ##class(web.DHCADVINTERFACE).QueryPatOpeList("100","1","31")  
ClassMethod QueryPatOpeList(rows = 10, page = 1, EpisodeID As %String) As %String
{
	N (rows, page,EpisodeID)
	Q:EpisodeID="" ""
	s objList=##class(CIS.AN.SRV.OperService).GetOperInfoByEpisode(EpisodeID,"")
     //CIS.AN.DTO.OperInfo
	s RetStr=""
	s thisDate=$p($h,",",1)
	s count=0
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	w "{""rows"":["
	 f i=1:1:objList.Count(){
		s object=objList.GetAt(i) 
		s count=count+1
		q:count<Start
		q:count>End
		w $case(count,Start:"",:",")
		s tmpObj={}
		s tmpObj.OPSID=object.OPSID  ; 手术申请ID
		s tmpObj.AppCareProvID=object.AppCareProvID  ; 手术申请医生ID
		s tmpObj.AppCareProvDesc=object.AppCareProvDesc ; 手术申请医生姓名
		s tmpObj.SourceType=object.SourceType  ; 手术类型
		s tmpObj.SourceTypeDesc=object.SourceTypeDesc ; 手术类型名称
		s tmpObj.Status=object.Status ; 手术状态
		s tmpObj.StatusDesc=object.StatusDesc ; 手术状态名称
		s tmpObj.OperDate=object.OperDate ; 手术开始日期 
		s tmpObj.OperTime=object.OperTime ; 手术预计持续时长
		s tmpObj.OperStartDT=object.OperStartDT ; 手术开始日期时间 
		s tmpObj.OperDesc=object.OperDesc ; 手术描述
		s tmpObj.OperStartDT=object.OperStartDT
		w tmpObj.%ToJSON()
		 
	 }
	 w "],""total"":"_count_"}"
	Q ""
}

/// Description: 获取事件类型（提供给护理组漏报接口） 
/// Creator:     CongYue
/// CreateDate:  2021-01-20  
/// Table:		 DHC_MedAdrRepEvent , DHC_MedAdrRepEventItm
/// Input:  	 医院id
/// Output:  	 [{id:"ID","desc":"描述"}]  
/// Others:		 w ##class(web.DHCADVINTERFACE).QueryADVType(3)
ClassMethod QueryADVType(HospId = "") As %String
{
	N (HospId)
	S Stream=##class(%GlobalCharacterStream).%New()
	S count=0
	D Stream.Write("[")
	S EventDr=""
	F  S EventDr=$o(^DHCMEDADREVT(EventDr)) Q:EventDr=""  D
	.Q:+EventDr=0
	.S EventCode=$p(^DHCMEDADREVT(EventDr),"^",1)
	.S EventDesc=$p(^DHCMEDADREVT(EventDr),"^",2)
	.S EventActive=$p(^DHCMEDADREVT(EventDr),"^",3) //是否可用
	.Q:EventActive="N"
	.S CH=""
	.F  S CH=$o(^DHCMEDADREVTI(EventDr,"MADREVI",CH)) Q:CH=""  D
	..S Code=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",1) //代码
	..S Desc=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",2) //描述
	..S Active=$p(^DHCMEDADREVTI(EventDr,"MADREVI",CH),"^",3) //是否可用
	..Q:Active="N"
	..Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(Code)))  ;去除不是表单的类型
	..Q:(HospId'="")&&(Code'="")&&(##class(web.DHCADVFormName).CheckFormName(Code,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S ListData=EventDr_"||"_CH_"^"_Desc
	..S count = count+1
	..I count=1 D
	...D Stream.Write(##class(web.DHCADVJSONCOMMON).getJsonData("id^desc",ListData))
	..E  D
	...D Stream.Write(","_##class(web.DHCADVJSONCOMMON).getJsonData("id^desc",ListData))
	.;Q:($d(^DHCMEDADREVTI(EventDr,"MADREVI")))  ;去除带有子元素的类型
	.Q:'$d(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(EventCode)))  ;去除不是表单的类型
	.Q:(HospId'="")&&(EventCode'="")&&(##class(web.DHCADVFormName).CheckFormName(EventCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	.S tmp=EventDr_"^"_EventDesc
	.S count = count+1
	.I count=1 D
	..D Stream.Write(##class(web.DHCADVJSONCOMMON).getJsonData("id^desc",tmp))
	.E  D
	..D Stream.Write(","_##class(web.DHCADVJSONCOMMON).getJsonData("id^desc",tmp))
	D Stream.Write("]")
	Q Stream
}

/// Description: 获取事件信息（提供给护理组漏报接口） 
/// Creator:     CongYue
/// CreateDate:  2021-01-20  
/// Input:  	 StartDate:开始时间  EndDate:结束时间  LocId:上报报科室(可为空)  EventId:事件类型ID (可为空)  EpisodeId:就诊号(可为空)
/// Output:   	 [{id:"ID"，appDate:"上报日期"，appTime:"上报时间"，appUser:"上报人ID" ,appTypeDr:"报告类型ID", appType:"报告类型描述" , admID:"病人就诊ID"} ] 
/// Others:		 w ##class(web.DHCADVINTERFACE).QueryADVRepList("2020-05-25","2020-10-28")
ClassMethod QueryADVRepList(StDate As %String, EndDate As %String, LocId = "", EventId = "", EpisodeId = "") As %String
{
	N (StDate,EndDate,LocId,EventId,EpisodeId)
	S Stream=##class(%GlobalCharacterStream).%New()
	S:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	S count=0
	Q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(count) //输出json结尾符
	d Stream.Write("{""rows"":[")
	F date=StDate:1:EndDate d
	.S RepID=""
	.F  S RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) Q:RepID=""  D
	..S RepTypeCode="",RepTypeDr="",RepType="",RepStaus="",RepUser="",RepLoc="",RepSubType="",RepImpFlag="",MedadrReceive="",MedadrReceivedr="",FileFlag="",RepOverTimeflag="",AutOverTimeflag="",RepOverTime="",AutOverTime="",RepCancelflag="",StaFistAuditUser="",BackAuditUser="",MedadrNextLocDR=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..// 获取报告id（报告表单类型id或者报告不良事件类别勾选维护工作流的类型id）
	..S RepTypeString=##class(web.DHCADVCOMMONPART).GetRepTypeString(RepID)
	..S TypeDr=$p(RepTypeString,"^",1) ; 报告表单类型id
	..S TypeCode=$p(RepTypeString,"^",2)
	..S Type=$p(RepTypeString,"^",3)
	..S RepTypeDr=$p(RepTypeString,"^",4)
	..S RepTypeCode=$p(RepTypeString,"^",5)
	..Q:(EventId)&&(EventId'=TypeDr)
	
	..S RepDate=$p(^DHCADVMASTER(RepID),"^",4)
	..S:RepDate'="" RepDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(RepDate)
	..S RepTime=$p(^DHCADVMASTER(RepID),"^",5)
	..S:RepTime'="" RepTime=$zt(RepTime,1)
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..I RepStausDr=""  D
	...S RepStaus="未提交"
	...S status="N"
	..E  D 
	...S status="Y"
	...S RepStaus=$p(^DHCADREVTWFI(+RepStausDr,"ADREWI",$p(RepStausDr,"||",2)),"^",2)
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S:RepUserDr'="" RepUser=$p(^SSU("SSUSR",RepUserDr),"^",2)
	..S RecRepUser=##class(web.DHCADVCOMMONPART).QueryInputDataInfo(recordID,"填报人姓名") 
	..S:RecRepUser'="" RepUser=RecRepUser
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepLevel=$p(^DHCADVMASTER(RepID),"^",12)  ///不良事件级别
	..S RepLevelDr=$S(RepLevel["Ⅰ级事件":"1",RepLevel["Ⅱ级事件":"2",RepLevel["Ⅲ级事件":"3",RepLevel["Ⅳ级事件":"4",1:"")
	..S AdmID=$p(^DHCADVMASTER(RepID),"^",16)  
	..S PatName=$p(^DHCADVMASTER(RepID),"^",17)  
	..S AdmNo=$p(^DHCADVMASTER(RepID),"^",20)  ///病案号
	..S OccurLoc=$p(^DHCADVMASTER(RepID),"^",27)  ///发生科室
	..Q:(LocId'="")&&(LocId'=RepLocDr)
	..Q:(EpisodeId'="")&&(EpisodeId'=AdmID)
	
	..S count=count+1
	..D Stream.Write($case(count,1:"",:","))
	..S tmpObj={}
	..S tmpObj.id=RepID
	..S tmpObj.appDate=RepDate
	..S tmpObj.appTime=RepTime
	..S tmpObj.appUser=RepUserDr
	..S tmpObj.appTypeDr=TypeDr
	..S tmpObj.appType=Type
	..S tmpObj.admID=AdmID
	..D Stream.Write(tmpObj.%ToJSON())
	D Stream.Write("],""total"":"_count_"}")
	;Q Stream.Read()  流的读取
	Q Stream
}

/// Descript:根据维护，输出维护的列接口 
/// Creator:congyue
/// CreateDate:2021-05-12
/// Input:开始日期，结束日期，报告类型code
/// Output: 维护的数据列信息json数据（表格数据格式$c(4):每条数据中的表格的每行，$c(3):表格的每列）
/// w ##class(web.DHCADVINTERFACE).QueryAdvJsonData("2020-6-2","2021-6-12","","")
ClassMethod QueryAdvJsonData(StDate, EndDate, TypeCode = "", HospId = "")
{
	N (StDate,EndDate,TypeCode,HospId)
	Q:(StDate = "")||(EndDate = "") ""
	S StDate = $zdh(StDate,3)
	S EndDate = $zdh(EndDate,3)
	
	S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvJsonData",pid)
	S list=##class(DHCNewPro.COM.Array).%New()  /// 使用封装程序，兼容新旧cache   list=[]
	///取接口列
	S InteId = "0" , count=0
	F  S InteId = $o(^DHCADVAFC(InteId)) Q:InteId=""  D
	.S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvJsonData",pid,InteId) = InteId
	///取接口数据
	S count = 0
	F date = StDate:1:EndDate  D
	.S MasterId = ""
	.F  S MasterId = $o(^DHCADVMASTER(0,"RepDate",date,MasterId))  Q:MasterId=""  D
	..S List="",RepTypeDr="",RepTypeCode="",RepType=""
	..S RecordId = $p(^DHCADVMASTER(MasterId),"^",1)
	..// 报告表单类型
	..S RepTypeDr=$p(^DHCADVMASTER(MasterId),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..Q:(TypeCode'="")&&(TypeCode'=RepTypeCode)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,HospId)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S tmpObj=##class(DHCNewPro.COM.Object).%New() /// 使用封装程序，兼容新旧cache   tmpObj={}
	..D tmpObj.Set("RepType",RepType)
	..S Column = "" 
	..F  S Column = $o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvJsonData",pid,Column)) Q:Column=""  D
	...S ColCode = $p(^DHCADVAFC(Column),"^",1)									//接口code
	...S ConInfo = ..GetDicContrast(Column, RecordId)							//取对照元素
	...S ConDicId = $p(ConInfo,"^",1)
	...S ConCode = $p(ConInfo,"^",2)
	...S RecordItm = +$o(^User.DHCAdvFormRecordItmI("IndexDic",RecordId,ConDicId,""))
	...S HasChild = ##class(web.DHCADVEXPFIELD).IsHasChildDic(ConDicId)  		//判断是否有子元素
	...S DicInfo = ##class(web.DHCADVEXPFIELD).GetDicItmInfo(ConDicId)
	...S DicStyle = $p(DicInfo,"^",3)
	...S RecordItmValue = ""
	...I DicStyle="datagrid"  d
	....S RecordItmValue = ..GetTableData(RecordId,ConCode,pid) 
	...I (DicStyle="label")&&(HasChild'=0)  D 						 			//有子元素的取下级	  		 							//元素类型      
	....S RecordItmValue=..GetSubValue(RecordId, ConDicId, pid)
	...E   D
	....S:RecordItm'=0 RecordItmValue=$LG(^User.DHCAdvFormRecordItmD(RecordItm),4)
	...D tmpObj.Set(ColCode,RecordItmValue)
	..D list.Push(tmpObj)
	k ^TMP("DHCADV","web.DHCADVINTERFACE","QueryAdvJsonData",pid)
	Q list.ToJSON()  /// 使用封装程序，兼容新旧cache %ToJson()替换成 ToJson()
}

/// Description: 护理不良事件按病区查询
/// Creator:     CongYue
/// CreateDate:  2021-09-22  
/// Input:  	 开始日期,结束日期,查询科室id(空 代表查询全部),LgParam:登录人id^登录科室id^登录安全组id^医院id
/// Output:   	 护理不良事件按病区显示数据：病区^新发压疮^院外带入压疮^管路滑脱^跌倒坠床^用药错误^意外事件例数(合计^1^1^2^2^1^2$$内分泌科护理单元^1^1^2^1^1^2$$神经外科护理单元^0^0^0^1^0^0)
/// Others:		 d ##class(web.DHCADVINTERFACE).QueryNurRepByWard("2020-01-01","2021-09-22","","23^151^10211^2")
ClassMethod QueryNurRepByWard(StDate As %String, EndDate As %String, InLocID As %String, LgParam As %String) As %String
{
	N (StDate,EndDate,InLocID,LgParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	K ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid)
	K ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid)
    S UserId=$p(LgParam,"^",1)    //用户ID
    S LocId=$p(LgParam,"^",2)     //科室ID
	S GroupId=$p(LgParam,"^",3)   //安全组ID
	S HospId=$p(LgParam,"^",4)   //医院ID
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",LgParam)
	S StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate) //$zdh(StDate,3)
	S EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	; 压疮院内院外  管路滑脱、跌倒坠床、用药错误、意外事件
	S InSKNum=0,OutSKNum=0,PONum=0,FDNum=0,DENum=0,AFNum=0
	S Num=1
	S ID=""
	F date=StDate:1:EndDate D
	.s RepID=""
	.f  s RepID=$o(^DHCADVMASTER(0,"RepDate",date,RepID)) q:RepID=""  d
	..S RepTypeCode="",RepType="",RepStaus="",RepUser="",RepLoc="",RepLocType=""
	..S recordID=$p(^DHCADVMASTER(RepID),"^",1)
	..Q:recordID=""
	..S RepTypeDr=$p(^DHCADVMASTER(RepID),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepType=$p(^DHCMEDADREVT(RepTypeDr),"^",2)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepType=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",2)
	..;过滤掉非 压疮院内院外  管路滑脱、跌倒坠床、用药错误、意外事件
	..Q:(RepType'["压疮不")&&(RepType'["压力性损伤不")&&(RepType'["管路滑脱")&&(RepType'["跌倒")&&(RepType'["用药错误")&&(RepType'["意外")
	..S Ulcerorign=""
	..S:(RepType["压疮不")||(RepType["压力性损伤不") Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95170"))
	..S:Ulcerorign'="" RepType="新发压疮"  ;"(院内发生)"
	..S Ulcerorign=""
	..S:(RepType["压疮不")||(RepType["压力性损伤不") Ulcerorign=##class(web.DHCADVCOMMONPRINT).GetRecordItmData(recordID,##class(web.DHCADVCOMMONPRINT).GetDiscIdByCode("UlcerPart-95158-95163-95171"))
	..Q:((RepType["压疮不")||(RepType["压力性损伤不"))&&(Ulcerorign="")
	..S:Ulcerorign'="" RepType="院外带入压疮"  ;"(院外带入)"
	..S RepStausDr=$p(^DHCADVMASTER(RepID),"^",3)
	..Q:RepStausDr=""  ;2022-08-02  统计已提交的报告 
	..S RepCancelflag=""
	..S MedadrID=$o(^DHCMEDREPADT(0,"Pointer",RepTypeDr,RepID,""),-1)
	..S:MedadrID'="" RepCancelflag=$p(^DHCMEDREPADT(MedadrID),"^",11) ;作废标识
	..Q:RepCancelflag="Y"
	..S RepLocDr=$p(^DHCADVMASTER(RepID),"^",7)
	..Q:(InLocID'="")&&(InLocID'=RepLocDr)
	..s RepHospID="" //hxy 2020-02-18 st
	..s:RepLocDr'="" RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(HospId'="")&(HospId'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S:RepLocDr'="" RepLocType=$p(^CTLOC(RepLocDr),"^",13)  ;为W 属于病区
	..S RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	..S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	..S RepUserDr=$p(^DHCADVMASTER(RepID),"^",6)
	..S GroupDesc="",flag="",Secuflag="",SecuLocflag=""
	..S RepList=RepTypeDr_"^"_RepLocDr_"^"_RepUserDr_"^"_RepID 
	..S:UserId'="" flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,LgParam)
	..Q:((flag'="")&&(flag'=1))
	..S:RepType["新发压疮" InSKNum=InSKNum+1
	..S:RepType["院外带入压疮" OutSKNum=OutSKNum+1
	..S:RepType["管路滑脱" PONum=PONum+1
	..S:RepType["跌倒" FDNum=FDNum+1
	..S:RepType["用药错误" DENum=DENum+1
	..S:RepType["意外" AFNum=AFNum+1
	..I $d(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,RepLoc,RepType)) D
	...S $p(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,RepLoc,RepType),"^",3)=$p(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,RepLoc,RepType),"^",3)+1
	..E  S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,RepLoc,RepType)=RepLocDr_"^"_RepType_"^"_Num
	
	S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid,"1")="ALL^合计"_"^"_InSKNum_"^"_OutSKNum_"^"_PONum_"^"_FDNum_"^"_DENum_"^"_AFNum
	
	S Type=""
	S Ward=""
	F  S Ward=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,Ward)) Q:Ward=""  D
	.S InSKNum=0,OutSKNum=0,PONum=0,FDNum=0,DENum=0,AFNum=0
	.F  S Type=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,Ward,Type)) Q:Type=""  D
	..S Numall=$p(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,Ward,Type),"^",3)
	..S WardDr=$p(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid,Ward,Type),"^",1)
	..S:Type["新发压疮" InSKNum=Numall
	..S:Type["院外带入压疮" OutSKNum=Numall
	..S:Type["管路滑脱" PONum=Numall
	..S:Type["跌倒" FDNum=Numall
	..S:Type["用药错误" DENum=Numall
	..S:Type["意外" AFNum=Numall
	..S ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid,Ward)=WardDr_"^"_Ward_"^"_InSKNum_"^"_OutSKNum_"^"_PONum_"^"_FDNum_"^"_DENum_"^"_AFNum
	.
	
	S Ward=""
	S List=""
	F  S Ward=$o(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid,Ward)) Q:Ward=""  D
	.S ListData=$g(^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid,Ward))
	.Q:ListData=""
	.S:List'="" List=List_"$$"_ListData
	.S:List="" List=ListData
	K ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard",pid)
	K ^TMP("DHCADV","web.DHCADVINTERFACE","QueryNurRepByWard","ALL",pid)
	Q List
}

}
