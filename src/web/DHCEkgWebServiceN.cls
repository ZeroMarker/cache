Import SQLUser

/// web.DHCEkgWebServiceN
Class web.DHCEkgWebServiceN Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "DHCEkgWebServiceN";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.dhcc.com.cn/EKG";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

ClassMethod Test() As %String [ WebMethod ]
{
	//Return "aaa"
}

/// 说明:获取医嘱列表
/// 入参:locId:app接收科室Id; patCode:登记号; stdDate:开始时间; endDate:结束时间;
///      examItemFilter:过滤医嘱(医嘱1^医嘱2); execFlag:医嘱状态(0:核实; 1:执行);
///      feeFlag:费用状态(0:未收费;1:已收费);
///      patientType:病人来源("":全部;"I":住院病人;"O":门诊病人;"E":急诊病人;"H":体检病人)
/// 返回:xml格式的DateSet的医嘱
/// w ##class(web.DHCEkgWebServiceN).GetOrderDateSet("273","","65643","65644","","","","","","","")
ClassMethod GetOrderDateSet(locId As %String, patCode As %String, stdDate As %String, endDate As %String, examItemFilter As %String, execFlag As %String, feeFlag As %String, patientType As %String, examState As %String, rptState As %String, wardCodeQ As %String) As %XML.DataSet [ WebMethod ]
{
	//s ^tmpekg="a"
	//s rs=##class(%XML.DataSet).%New("web.DHCEkgGetConOrd:GetEkgOdrList")
	s rs=##class(%XML.DataSet).%New("web.DHCEkgWebServiceN:GetOrderDataBothNewOld")
	d rs.Execute(locId,patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType,examState,rptState,wardCodeQ)
    
    q rs
}

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetEkgOdrList","85","","65379","65378","","","","","","","")
Query GetOrderDataBothNewOld(LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String, wardCodeQ = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,ExamState:%String,UnitCode:%String")
{
}

ClassMethod GetOrderDataBothNewOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderDataBothNewOldExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetOrderDataBothNewOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderDataBothNewOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetOrderDataBothNewOldExecute(ByRef qHandle As %Binary, LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String, wardCodeQ = "") As %Status
{
	Set $ZTrap = "ErrorHandle"
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    set RowCount=""
    ;start
    set RowCount=0
    
    s wardCode=""
    s wardName=""
    if (wardCodeQ'="")
    {
	    s wardCode=$p(wardCodeQ,"^",1)
	    s wardName=$p(wardCodeQ,"^",2)
    }
    //查询新库
    s rs=##class(%ResultSet).%New("web.DHCEkgGetConOrd:GetEkgOdrList")
	d rs.Execute(LocId,PatRegNo,StartDate,EndDate,examItemFilter, ExecFlage,FeeFlage,patientType,examStateQ,rptState,wardCode)
	while(rs.Next())
	{
		
		s bingqu=$g(rs.Data("wardid"))
		//s bingqu=$p(bingqu,"-",2)
		//w bingqu,!    
		if ((wardName'="")&&(wardName'=bingqu))
		{
		}
		else
	    {
			s RowCount = RowCount+1 
    	    d OutPut(rs)
		}
		
	}
   
   //查询老库
   if $D(^CTLOC(LocId))
   {
	   s LocCode=$P(^CTLOC(LocId),"^",1)
	  
	   s objOldWeb=##class(DHCEkgWebService.DHCEkgWebServiceSoap).%New()
	   i PatRegNo["^" s PatRegNo=$p(PatRegNo,"^",1)
	   s rsold=objOldWeb.GetOrderDateSet(LocCode,PatRegNo,StartDate,EndDate,examItemFilter, ExecFlage,FeeFlage,patientType,examStateQ,rptState)
   	   while(rsold.Next())
	   {
		    s bingqu=$g(rsold.Data("wardid"))
		    s bingqu=$p(bingqu,"-",2)
		    
		    if ((wardName'="")&&(wardName'=bingqu))
		    {
		    }
		    else
		    {
				s RowCount = RowCount+1 
    			d OutPut(rsold)
		    }
	   }
   }
    
     ;end
    Set qHandle=$lb(0,repid,0)
    q $$$OK
ErrorHandle
	s ^TMP($zn,$j,repid,"ErrorHandle")="-1^错误"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
    Quit $$$OK
OutPut(rs)
	s RegNo=$g(rs.Data("RegNo")) 
	s PatName=$g(rs.Data("PatName")) 
	s BedCode=$g(rs.Data("BedCode")) 
	s ArcimDesc=$g(rs.Data("ArcimDesc")) 
	s OeordId=$g(rs.Data("OeordId")) 
	
	s OrdStatDesc=$g(rs.Data("OrdStatDesc")) 
	s OrcatDesc=$g(rs.Data("OrcatDesc")) 
	s ExecDateTime=$g(rs.Data("ExecDateTime")) 
	s ExecCtcpDesc=$g(rs.Data("ExecCtcpDesc")) 
	
	s CtcpDesc=$g(rs.Data("CtcpDesc")) 
	s RecLocDesc=$g(rs.Data("RecLocDesc")) 
	s OrdDateTime=$g(rs.Data("OrdDateTime")) 
	s AdmDep=$g(rs.Data("AdmDep")) 
	s notes=$g(rs.Data("notes")) 
	
	s OrdUnitCost=$g(rs.Data("OrdUnitCost")) 
	s OrdQty=$g(rs.Data("OrdQty")) 
	s OrdCost=$g(rs.Data("OrdCost")) 
	s admId=$g(rs.Data("admId")) 
	s medcareno=$g(rs.Data("medcareno")) 
	s billed=$g(rs.Data("billed")) 
	
	s admType1=$g(rs.Data("admType1")) 
	s sex=$g(rs.Data("sex")) 
	s wardid=$g(rs.Data("wardid")) 
	s age=$g(rs.Data("age")) 
	s Diagnosis=$g(rs.Data("Diagnosis")) 
	s AdmReason=$g(rs.Data("AdmReason")) 
	
	s dobDate=$g(rs.Data("dobDate")) 
	s FeeState=$g(rs.Data("FeeState")) 
	s ExamState=$g(rs.Data("ExamState")) 
	s UnitCode=..GetEkgUnitCode(OeordId)
	
    set Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,ExamState,UnitCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

/// 说明:通过住院号获取登记号
/// 入参:inPatNo:住院号
/// 返回:登记号
ClassMethod GetPatNoByInpatNo(inPatNo As %String) As %String [ WebMethod ]
{
	quit:inPatNo="" ""
    set papmiId=0,RegNo=""
    set papmiId=$O(^PAPERi("Medicare1",inPatNo,papmiId))
    quit:papmiId="" ""
    set itemStr=$g(^PAPER(papmiId,"PAT",1))
    quit:itemStr="" ""
    set RegNo=$p(itemStr,"^",1)
    if RegNo="" set RegNo=$p(itemStr,"^",2)
    quit RegNo
}

/// 说明:通过卡号获取登记号
/// 入参:cardNo:卡号
/// 返回:登记号
ClassMethod GetPatNoByCardNo(cardNo As %String) As %String [ WebMethod ]
{
	quit:cardNo="" ""
    set CardRowId=0,RegNo=""
    f  set CardRowId=$o(^DHCCARDi("CF",0,"CardNo",cardNo,CardRowId)) q:CardRowId=""  d
    .set RegNo=$p(^DHCCARD("CF",CardRowId),"^",6) //取病人的登记号
    .set flag=$p(^DHCCARD("CF",CardRowId),"^",10)
    .quit:flag'="N"
    quit RegNo
}

/// 说明:通过姓名获取登记号 ???
/// 入参:patName:姓名; locId:app接收科室Id
/// 返回:登记号
/// w ##class(web.DHCEkgWebServiceN).GetPatNoByPatName("测试患者测试患者","273")
ClassMethod GetPatNoByPatName(patName As %String, locId As %String) As %String [ WebMethod ]
{
	s Isfirst=1
	s flag="N"
	s patName=$ZCONVERT(patName,"U")
	s GetName=patName 
	s RegNo=""
	s RegNoRtn=""
	;w !,"sss"
	do 
	{
		if patName="" s flag="Y" q
		if (GetName'[patName) s flag="Y" q
		s GetName=$ZCONVERT(GetName,"U")
	    
		s NoRowid=0 f  s NoRowid=$o(^PAPERi("PAPER_PatName",GetName,NoRowid))  q:NoRowid=""  d
		.s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
		..s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
		...s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
		....s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
		.....s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
		.....s oeorditemdr=OrderRowid_"||"_itemsub 
		.....q:(reploc'=locId)&(locId'="")
		.....s bQLoc=..IsQueryLoc(locId,reploc)
		.....q:(bQLoc=0)
		.....;s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
		.....;q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
		.....;s bOut="N"  ;是否已经输出
		.....;s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
		.....s paadmdr=$p(^OEORD(OrderRowid),"^",1)
		.....;s NoticeSignInfo=..CheckNoticeSignInfo(paadmdr) 
		.....;s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
	    .....if (paadmdr'="") do
	    ......if $d(^PAADM(paadmdr)) do
	    .......s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	    .......s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	    .......if RegNoRtn="" s RegNoRtn=RegNo
	    .......else  if RegNoRtn'[RegNo set RegNoRtn=RegNoRtn_"^"_RegNo
	    .....;s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	    .....;s GetRegNo=$p(PatInfo,"^",1)
	    
		s GetName=$o(^PAPERi("PAPER_PatName",GetName)) 
	}while ((GetName'="")&(flag'="Y"))
	
	quit RegNoRtn
}

/// 说明:执行医嘱
/// 入参:OrdId:医嘱Id; UserId:App用户表Id
/// 返回:执行结果(0:成功;其他:失败)
ClassMethod ExecuteOrder(OrdId As %String, UserId As %String) As %String [ WebMethod ]
{
	
	
	q ##class(appcom.OEOrdItem).Execute(OrdId,UserId)
}

/// 说明:撤销医嘱
/// 入参:OrdId:医嘱Id; UserId:App用户表Id
/// 返回:执行结果(0:成功;其他:失败)
ClassMethod VerifyOrder(OrdId As %String, UserId As %String) As %String [ WebMethod ]
{
	q ##class(appcom.OEOrdItem).Verify(OrdId,UserId)
}

/// 说明:通过用户工号查询UserId
/// 入参:UserNo:用户工号
/// 返回:执行结果(-1:没有该用户)
ClassMethod GetUserRowId(UserNo As %String) As %String [ WebMethod ]
{
	set userRowId="-1"
	  	  
	set userName=$ZCONVERT(UserNo,"U")
	set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserNo,"")) //获取到ss_user表中的rowid
	quit userRowId
}

/// 说明:通过医嘱号获取申请单Id，用于查看申请单
/// 入参:OrdId:医嘱Id
/// 返回:申请单Id("":查询不到)
ClassMethod GetAppIdByOrdId(OrdId As %String) As %String [ WebMethod ]
{
	s arReqID=""
	i OrdId'=""  d
	.s DARowId=""
	.f  s DARowId=$o(^DHCAPREP(0,"OrdItem",OrdId,DARowId)) q:DARowId=""  d
	..s arReqID=DARowId
	q arReqID
}

/// 说明:通过医嘱号获取医嘱信息串
/// 入参:OrdId:医嘱Id(医嘱号1@医嘱号2)
/// 返回:医嘱串
/// w ##class(web.DHCEkgWebServiceN).GetOrderInfoByOrdId("1||727")
ClassMethod GetOrderInfoByOrdId(OrdId As %String) As %String [ WebMethod ]
{
	//q ##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem(OrdId)
	q ##class(web.DHCEkgWebServiceNew).GetEKGInfoByOrdID(OrdId)
}

/// 说明:通过登记号获取医嘱信息串
/// 入参:OrdId:医嘱Id(医嘱号1@医嘱号2)
/// 返回:医嘱串
ClassMethod GetOrderInfoByPatNo(LocId As %String, PatNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	
	s rtn=##class(web.DHCEkgService).GetEKGInfoTxtByLRD(LocId,PatNo,StartDate,Enddate)
	if rtn[$c(0) set rtn=$translate(rtn,$c(0),"")
	q rtn
}

/// 说明:Ens修改检查状态和报告状态
/// 入参: OrdId:医嘱Id; Status:状态; UserInfo:用户工号@用户姓名
/// 返回:执行结果(0^成功)
ClassMethod UpdateOrderStatusByEns(OrdId As %String, Status As %String, UserInfo As %String) As %String [ WebMethod ]
{
	s inputObj=##class(web.DHCEkg.SystemStatus.Dict.UpdateRequest).%New()
	s inputObj.ExamID="EKG||"_OrdId
	s inputObj.OEOrdItemID=OrdId
	s inputObj.Position=""
	s inputObj.SourceSystem="EKG"
	s inputObj.Status=Status
	s inputObj.UpDateTime=$zdt($h,3)
	s inputObj.UserID=$p(UserInfo,"@",1) //工号
	s inputObj.UserName=$p(UserInfo,"@",2) //姓名
	
	s json=##class(ext.util.JsonObject).ObjToJson(inputObj,"","") ;web.DHCEkg.SystemStatus.Dict.UpdateRequest
	s json="["_json_"]"
	s jsonStream=##class(%GlobalCharacterStream).%New()
	d jsonStream.Write(json)
	s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
	
	q rtnUpdateSystem
}

/// 说明:Ris修改检查状态和报告状态
/// 入参:OrdId:医嘱Id; Status:状态; UserInfo:用户工号@用户姓名
/// 返回:执行结果(0)
ClassMethod UpdateOrderStatusByRis(OrdId As %String, Status As %String, UserInfo As %String) As %String [ WebMethod ]
{
	set RID=$Replace(OrdId,"||","_")
	set ExamNo="EKG||"_OrdId
	
	set info=RID_"^^"_$zd($h,3)_"^"_$p($zdt($h,3)," ",2)_"^"_UserInfo_"^^^"_ExamNo_"^"_Status_"^^^"
	set rtn=##class(RISService.TrakRISService).SetExamStatusInfo(info)
	q rtn
}

/// 说明:叫号
/// 入参:xmlInfo:叫号xml串
/// 返回:0-成功,其他-相应错误提示
ClassMethod CallPatRisSendVoice(xmlInfo As %String) As %String [ WebMethod ]
{
	q ##class(web.DHCVISService).RisSendVoice(xmlInfo)
}

/// 说明:调用RIS接口置报告状态
/// 入参:OrdId:医嘱Id; Status:状态; UserInfo:用户工号@用户姓名
/// 返回:执行结果(0)
///  w ##class(web.DHCEkgWebServiceN).SetReportInfoDoByRis("626_53@^EKG||626||53^S^^admin@admin^admin@admin^2020-06-22^2020-06-22^16:15:39^16:15:39^^^N^N^心电^","正常心电图") 
ClassMethod SetReportInfoDoByRis(Notes As %String, Diagnose As %String) As %String [ WebMethod ]
{
	s OrdId="626||52"
	set resultStatus="RP"
	&sql(Update OE_OrdItem set OEORI_ResultFlag=:resultStatus  where OEORI_RowId=:OrdId)
	
	s rtn=##class(RISService.TrakRISService).SetReportInfoDo(Notes,Diagnose,Diagnose,Diagnose)
	
	
	q rtn
}

/// 说明:Ens修改检查状态和报告状态
/// 入参:OrdId:医嘱Id; Status:状态; UserInfo:用户工号@用户姓名
/// 返回:执行结果(0)
ClassMethod UnRegisterOrderByRis(OrdId As %String, UserInfo As %String) As %String [ WebMethod ]
{
	s ExamNo="EKG||"_OrdId
	s userInfo=UserInfo_"^Y^Y^"

	q ##class(RISService.TrakRISService).UnRegister(ExamNo,OrdId,userInfo)
}

/// 被GetPatNoByPatName调用
ClassMethod IsQueryLoc(LogInLocId As %String, OrditemRecLocId As %String) As %Integer
{
	 s bFind=0
	 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LogInLocId,"LINK",LinkSub)) q:LinkSub=""  d    
     .s LinkLocDr=$p(^CTLOC(LogInLocId,"LINK",LinkSub),"^",1)
     .i LinkLocDr=OrditemRecLocId  s bFind=1
  
     i bFind=0 d
     .i OrditemRecLocId=LogInLocId  s bFind=1 
    
     q bFind
}

/// Creator:		yyl
/// CreatDate:		2019-2-22
/// Modify:			yyl
/// ModifyDate:		2019-2-22
/// Description:	向体检发送检查结果
/// Input:			OrditmRowids-医嘱号；
/// 				ReportUser- 报告医生工号
/// 				ArbiterUser- 审核医生工号
/// 				DiagInfo- 诊断结论
/// 				normal- 是否正常,0:正常,1:异常
/// Output:
ClassMethod UpdatePEResult(OrditmRowids As %String, ReportUser As %String, ArbiterUser As %String, DiagInfo As %String, normal As %String) As %String [ WebMethod ]
{
	s rtn= ##class(web.DHCPE.CRM.Gateway).UpdatePEResult(OrditmRowids,ReportUser,ArbiterUser, "",DiagInfo,DiagInfo,normal)
	s ^tmpDHCEKG("UpdatePEResult",OrditmRowids)=ReportUser_"^"_normal_"==>"_rtn
	q rtn
}

/// 说明:通过用户名、密码获取用户以及其默认科室信息
/// 入参:userName:用户名; password:密码
/// 返回: -1:查不到用户; -2:密码验证失败; 用户信息串$科室信息串
/// w ##class(web.DHCEkgWebServiceN).GetDeptUser4LoginSync("284","1")
ClassMethod GetDeptUser4LoginSync(userName As %String, password As %String) As %String [ WebMethod ]
{
	set userName=$ZCONVERT(userName,"U")
	set userRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userName,""))
	q:(userRowId="") "-1" //查不到用户
	set userInfo=^SSU("SSUSR",userRowId)
	q:(userInfo="") "-1"  //查不到用户
	//密码验证
	set pwd=$p(userInfo,"^",3)
	set tmpPwd=password
	set password = ##class(web.SSUser).Encrypt(tmpPwd) //加密之后的密码
	quit:pwd'=password "-2"  ;密码错误
	
	set $p(userInfo,"^",3)=tmpPwd
	
	set ctInfo = ^CTLOC($p(userInfo,"^",4))
	
	q userInfo_"$"_ctInfo
}

/// w ##class(web.DHCEkgWebServiceN).GetEkgUnitCode("284||3")
ClassMethod GetEkgUnitCode(barCode As %String) As %String [ WebMethod ]
{
    s a=$p(barCode,"||",1)
    s b=$p(barCode,"||",2)
	q a_b_$l(b)
}

}
