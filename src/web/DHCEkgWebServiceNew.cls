/// web.DHCEkgWebServiceNew
/// For DHC EKG Studio System . 2008-12-30, Created by Rocky Lau .
/// 公布的Webservice方法，提供给EKGStudio系统使用
Class web.DHCEkgWebServiceNew Extends %SOAP.WebService
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCEkgWebServiceNew";

// Parameter LOCATION = "http://localhost/csp/websource";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/EKG";

/// Creator：		liupeng
/// CreatDate：		2008-12-30
/// Modify: 		yyl
/// ModifyDate：	2021-4-13
/// Description:	按照输入条件查询符合条件的数据集 
/// Table：			
/// Input：			执行科室id；登记号；起始日期；终止日期
/// Output：		记录
/// Return：		记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：		返回的最后一个字段是医嘱状态，其它分别是：
/// 					"TPattype:%String,TRegNo:%String,TStudyID:%String,TName:%String,
/// 					TSex:%String,TAge:%String,TBrithday:%String,TOrderItem:%String,
/// 					TStudyWay:%String,TStudyStatus:%String,TRptID:%String,TRptStatus:%String,
/// 					TImgCount:%String,TClinic:%String,TReqDocName:%String,TReqLocName:%String,
/// 					TRptDocName:%String,TRptDate:%String,TRptTime:%String,TVerifyDocName:%String,
/// 					TVerifyDate:%String,TVerifyTime:%String,TIsJZ:%String,TIsYX:%String,
/// 					TIsTSBL:%String,TIsKYBL:%String,TRegDate:%String,RegTime:%String,
/// 					TTotalPrice:%String,TEQdesc:%String,TOrderDate:%String,
/// 					TOrderTime:%String,TAccessionNum:%String,GetIndex:%String,
/// 					AppointDate:%String,AppointTime:%String,GetResDesc:%String,
/// 					Getifbed:%String,GetIPNo:%String,GetWardName:%String,Getroomdesc:%String,
/// 					GetBedNo:%String,feetype:%String,BodyPart:%String,Getbilled:%String,
/// 					MainDoc:%String,AssiantDoc:%String,Paadmdr:%String,OEordDR:%String,
/// 					GroupDesc:%String,OldNo:%String,Required:%String,SafetynetCardNo:%String,
/// 					TMemo:%String,TCallStatus:%String,TNumber:%String,TTelphone:%String,
/// 					TOEItemNum:%String,TAssisName:%String,TRoomIndex:%String,TReportInfo:%String")
/// History		2008-12-30	liupeng	根据RIS产品的脚本改造
/// 			2009-03-11	liupeng	增加注释
/// 			2021-4-13 yyl 改为调用新的查询接口，优化查询速度
/// w ##class(web.DHCEkgWebServiceNew).GetEKGInfoTxt("85","0000000021","2021-08-27","2021-09-11")
ClassMethod GetEKGInfoTxt(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxt",$zd($h,3),$zt($p($h,",",2),1),LocId_"^"_InRegNo_"^"_StartDate_"^"_Enddate,"params")
	s return=""
	//新方法，优化查询速度
	s return=##class(web.DHCEkgService).GetEKGInfoTxtNew(LocId,InRegNo,StartDate,Enddate)
	//原来的方法↓
	//s return=##class(web.DHCEkgService).GetEKGInfoTxt(LocId,InRegNo,StartDate,Enddate)
	if return[$c(0) set return=$translate(return,$c(0),"")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxt",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
	
	//quit ""
}

// 谷山丰获取医嘱信息 

// 规则：返回一条医嘱信息 1、返回最新开单的核实医嘱 2、没有核实医嘱 返回最新开单医嘱

ClassMethod GetEKGInfoTxt4GSF(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	b ;GetEKGInfoTxt in
	//set return=""
	//test 
	//set return="住院病人^0123456789^LX^测试^女^33岁^1980-04-19^8849||1#WL0007#常规心电图检查(12导联)^^^^^^^demo^6#ZXYJHYK-中西医结合一科^^^^^^^^^^^^^20^^2014-02-18^09:50:00^^^^^^N^500220^中西医结合一科护理单元^中西医一科05^0501床^自费^^I^^^402^3561||330^^^^^^^^123^1^^^^V#核实$住院病人^0123456789^LX^测试^女^33岁^1980-04-19^8849||1#WL0007#常规心电图检查(12导联)^^^^^^^demo^6#ZXYJHYK-中西医结合一科^^^^^^^^^^^^^20^^2014-02-18^09:50:00^^^^^^N^500220^中西医结合一科护理单元^中西医一科05^0501床^自费^^I^^^402^3561||331^^^^^^^^123^1^^^^V#核实"
	//set return="住院病人^0123456789^LX^测试^女^33岁^1980-04-19^8849||1#WL0007#常规心电图检查(12导联)^^^^^^^demo^6#ZXYJHYK-中西医结合一科^^^^^^^^^^^^^20^^2014-02-18^09:50:00^^^^^^N^500220^中西医结合一科护理单元^中西医一科05^0501床^自费^^I^^^402^356||30^^^^^^^^123^1^^^^V#核实"
	
	;set return="住院病人^0123456789^LX^测试^女^33岁^1980-04-19^8849||1#WL0007#常规心电图检查(12导联)^^^^^^^demo^6#ZXYJHYK-中西医结合一科^^^^^^^^^^^^^20^^2014-02-18^09:50:00^^^^^^N^500220^中西医结合一科护理单元^中西医一科05^0501床^自费^^I^^^402^123456||30^^^^^^^^123^1^^^^V#核实"
	;set return="住院病人^02936749^DYT ^邓艳婷 ^女^34岁^1984-04-13^21754||1#310701001-00#心电图检查^^^^^^前置胎盘状态伴出血孕2产1宫内妊娠22周+2天单活胎 高危妊娠监督 ^刘明烨^597#CK-产科^^^^^^^^^^^^^^^2018-08-18^15:44:47^^^^^^^1047228^产科1区病区^FCKYQ-03^A08^韶关职工医保^^B^^^10828961^10817982||44^^^^1047228^^^^13178428050^1^^^^V#核实^"
	;quit return
	
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxt4GSF",$zd($h,3),$zt($p($h,",",2),1),LocId_"^"_InRegNo_"^"_StartDate_"^"_Enddate,"params")
	s return=""
	s return=##class(web.DHCEkgService).GetEKGInfoTxt(LocId,InRegNo,StartDate,Enddate)
	
	//start caolonglong
	set order=""
	if $l(return,"$")>1 do 
	.for i=1:1:$l(return,"$") do
	..set orderCur=$p(return,"$",i)
	..if $p(orderCur,"^",62)="V#核实" do
	...set order=orderCur
	break
	
	if order="" do
	.set return=$p(return,"$",1)
	else  do 
	.set return=order
	
	//if return'="" do
	//.set dept=$p(return,"^",16)
	//.set deptN=$p(dept,"#",2)
	//.set deptName=$p(deptN,"-",2)
	//.set $p(return,"^",16)=deptName
	//end
	
	if return[$c(0) set return=$translate(return,$c(0),"")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxt4GSF",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
	
	//quit ""
}

/// 中国医大
ClassMethod GetEKGInfoTxtTest(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxtTest",$zd($h,3),$zt($p($h,",",2),1),LocId_"^"_InRegNo_"^"_StartDate_"^"_Enddate,"params")
	s return=""
	s return=##class(web.DHCEkgService).GetEKGInfoTxt(LocId,InRegNo,StartDate,Enddate)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxtTest",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
	
	//quit ""
}

/// Creator：      jibing
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 按照输入条件查询符合条件的数据集，尝试提高速度
/// Table：        
/// Input：        执行科室id；登记号；起始日期；终止日期
/// Output：       记录
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// w ##class(web.DHCEkgWebServiceNew).GetEKGInfoTxtSpeed("85","0000000015","2020-1-1","2021-9-25")
ClassMethod GetEKGInfoTxtSpeed(LocId As %String, InRegNo As %String, StartDate As %String, Enddate As %String) As %String [ WebMethod ]
{
	//
	//1724529^CARDNO idtype=CARDNO
	//登记号 住院号 走原来的 idtype=""
	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxtSpeed",$zd($h,3),$zt($p($h,",",2),1),LocId_"^"_InRegNo_"^"_StartDate_"^"_Enddate,"params")
	s return=""
	
	set tmpRegNo = $p(InRegNo,"^",1)
	set idType = $p(InRegNo,"^",2)
	if idType="" do
	.s return=##class(web.DHCEkgService).GetEKGInfoTxtSpeed(LocId,InRegNo,StartDate,Enddate)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoTxtSpeed",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	
	q return
}

/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 更新检查医嘱状态
/// Table：        
/// Input：        用户id；医嘱号；子类；状态；病人主索引
/// Output：       
/// Return：       
/// Others：       此方法慎用，可能导致用户纠纷，Status为"E",变成“执行”；"V",变成“核实”
/// History	2008-12-30	liupeng	根据RIS产品的脚本改造
/// 			2009-03-11	liupeng	增加注释
/// do ##class(web.DHCEkgWebServiceNew).UpdataOrdInfo("607||21","RP")RPTMODIFY
/// w ##class(web.DHCEkgWebServiceNew).UpdataOrdInfo("35||20","E^admin")
/// w ##class(web.DHCEkgWebServiceNew).UpdataOrdInfo("203||111","E^636")
ClassMethod UpdataOrdInfo(OrditmRowids As %String, Status As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataOrdInfo",$zd($h,3),$zt($p($h,",",2),1),OrditmRowids_"^"_Status,"params")
	q "0"
	set tmpStatus = Status
	set Status=$p(tmpStatus,"^",1)
	set userId=""
	set userId=$p(tmpStatus,"^",2)
	s return=##class(web.DHCEkgService).UpdataOrdInfo(OrditmRowids,userId, Status,"","")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataOrdInfo",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      liupeng
/// CreatDate：    2009-06-17
/// Modify: 	   liuwei
/// ModifyDate：   2011-12-06
/// Description:： 更新诊断结论及报告状态
/// Table：        
/// Input：         OrditmRowids-医嘱号；
/// 				BaseInfo- 病人类型^报告书写者代码^确认者^终审者
/// 				DiagInfo- 临床诊断
/// 				ExtInfo- 检查所见^诊断意见^其它
/// Output：       
/// Return：        暂未定义
/// History	2009-06-17	liupeng	创建
/// 		2009-06-22	hulifei	调试&修正bug
ClassMethod UpdataRptInfo(OrditmRowids As %String, BaseInfo As %String, DiagInfo As %String, ExtInfo As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataRptInfo",$zd($h,3),$zt($p($h,",",2),1),OrditmRowids_"^"_BaseInfo_"^"_DiagInfo_"^"_ExtInfo,"params")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataRptInfo",$zd($h,3),$zt($p($h,",",2),1),BaseInfo,"params","BaseInfo")
	s PatType=""
	s ReportUser="" 
	s AffirmUser="" 
	s ArbiterUser="" 
	s ClinicInfo="" 
	s ExamDesc="" 
	s ExamResult=""
	s normal="1" ;1:正常  0:异常
	s rtn=""
	i (OrditmRowids'="")  d   ///&(BaseInfo'="")&(ExtInfo'="")  d
	.s examInfo= ##class(web.DHCEkgService).GetExamDesc(OrditmRowids)
	.s negPos=$p(examInfo,"^",5) 
	.i (negPos="阳性") s normal="0"
    .s PatType=$p(BaseInfo,"^",1)
	.s ReportUser=$p(BaseInfo,"^",2)
	.s AffirmUser=$p(BaseInfo,"^",3) 
	.s ArbiterUser=$p(BaseInfo,"^",4)
	
	.if DiagInfo'[$c(10) set DiagInfo=DiagInfo_$c(10) ;2015-08-13
	.set D=""
	.for i=1:1:$l(DiagInfo,$c(10)) do
	..set tmpD=$p(DiagInfo,$c(10),i)
	..if (tmpD'="") do
	...if (D="") set D=tmpD
	...else  set D=D_","_tmpD
	.b ;00
	.set ClinicInfo=D
	.;i PatType["体检"  d ;标准版去掉此控制，因为住院也有体检的
	.;.b 100
	.s rtn= ##class(web.DHCPE.CRM.Gateway).UpdatePEResult(OrditmRowids, ReportUser,ArbiterUser, "",ClinicInfo,ClinicInfo,normal)
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataRptInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,OrditmRowids,"rtn")
	q rtn
}

/// ////////////PE OP////////////////////////////////////////////////////////
/// GetCTLOCList
/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 获取所有科室代码集合
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// History	2008-12-30	liupeng	参考RIS产品的脚本创建
/// 			2009-03-11	liupeng	增加注释
/// w ##class(web.DHCEkgWebServiceNew).GetCTLOCList()
ClassMethod GetCTLOCList() As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetCTLOCList",$zd($h,3),$zt($p($h,",",2),1),"","Invoke")
	s return=##class(web.DHCEkgService).GetCTLOCList()
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetCTLOCList",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetDeptCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 获取所有科室代码集合
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetDeptCodeList()
ClassMethod EKGGetDeptCodeList() As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetDeptCodeList",$zd($h,3),$zt($p($h,",",2),1),"","Invoke")
	s return=##class(web.DHCEkgService).EKGGetDeptCodeList()
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetDeptCodeList",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetDeptByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 根据科室RowId，获取科室信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetDeptByCode(85)
ClassMethod EKGGetDeptByCode(CtLocId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetDeptByCode",$zd($h,3),$zt($p($h,",",2),1),CtLocId,"params")
	s return=##class(web.DHCEkgService).EKGGetDeptByCode(CtLocId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetDeptByCode",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetExamCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 取检查类的医嘱RowId
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetExamCodeList("")
ClassMethod EKGGetExamCodeList(OrdCat As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetExamCodeList",$zd($h,3),$zt($p($h,",",2),1),OrdCat,"params")
	;w ##Class(web.DHCEkgService).EKGGetExamCodeList(1)
	s:OrdCat="" OrdCat="1"
	s return=##class(web.DHCEkgService).EKGGetExamCodeList(OrdCat)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetExamCodeList",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetExamByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 根据检查类的RowId取医嘱信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetExamByCode("11661||1")
ClassMethod EKGGetExamByCode(ArcimId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetExamByCode",$zd($h,3),$zt($p($h,",",2),1),ArcimId,"params")
	;w ##Class(web.DHCEkgService).EKGGetExamByCode()
	s return=##class(web.DHCEkgService).EKGGetExamByCode(ArcimId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetExamByCode",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetUserCodeList
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetUserCodeList()
ClassMethod EKGGetUserCodeList() As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetUserCodeList",$zd($h,3),$zt($p($h,",",2),1),"","Invoke")
	;w ##Class(web.DHCEkgService).EKGGetUserCodeList()
	s return=##class(web.DHCEkgService).EKGGetUserCodeList()
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetUserCodeList",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// EKGGetUserByCode
/// Creator：      lipandong
/// CreatDate：    2010-05-27
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户基本信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       记录，记录之间用$间隔；记录的值之间用^间隔
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EKGGetUserByCode("1")
ClassMethod EKGGetUserByCode(UserId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetUserByCode",$zd($h,3),$zt($p($h,",",2),1),UserId,"params")
	;w ##Class(web.DHCEkgService).EKGGetUserCodeList()
	s return=##class(web.DHCEkgService).EKGGetUserByCode(UserId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGGetUserByCode",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// UserAuthenticate
/// Creator：      liupeng
/// CreatDate：    2008-12-30
/// Modify: 	   liuwei
/// ModifyDate：   2011-03-24
/// Description:： 用户登陆验证
/// Table：        
/// Input：        用户名，密码
/// Output：       
/// Return：       返回类似：23296^ys001^医师测试1^1188^医师测试1；非法登陆返回都为空
/// Others：
/// History	2008-12-30	liupeng	参考RIS产品的脚本创建
/// 			2009-03-11	liupeng	增加注释
/// w ##class(web.DHCEkgWebServiceNew).UserAuthenticate("636","1")
ClassMethod UserAuthenticate(User As %String, PWD As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UserAuthenticate",$zd($h,3),$zt($p($h,",",2),1),User_"^"_PWD,"params")
	s return=##class(web.DHCEkgService).UserLogon(User,PWD)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UserAuthenticate",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// UserAuthenticate
/// Creator：      jibing
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 获取预约列表
/// Table：
/// Input：        执行科室id（必须有）；登记号patID(可无)；patName病人姓名（可无）；stdDate开始日期（必须有）；endDate结束日期（必须有）
/// Output：       记录
/// Return：       记录，
/// w ##class(web.DHCEkgWebServiceNew).GetBookedListXML("85","0000000015","王五","2019-1-1","2019-1-1")
ClassMethod GetBookedListXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListXML",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetBookedListXML(locId,patID,patName,stdDate,endDate)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListXML",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// UserAuthenticate
/// Creator：      jibing
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 获取预约列表
/// Table：
/// Input：        执行科室id（必须有）；登记号patID(可无)；patName病人姓名（可无）；stdDate开始日期（必须有）；endDate结束日期（必须有）
/// Output：       记录
/// Return：       记录，
ClassMethod GetBookedListCardXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListCardXML",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetBookedListCardXML(locId,patID,patName,stdDate,endDate)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListCardXML",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// History: xzy--creator  协和预约 2013-4-25
/// Input：        
/// Output：       记录
/// Return：       记录，
/// Others：       
/// "1839977||209","344","2013-4-26","超声心动图"
ClassMethod GetBookRescoure(OrdId As %String, LocId As %String, BookDateTime As %String, ResourceName As %String) As %String [ WebMethod ]
{
	s params=OrdId_"^"_LocId_"^"_BookDateTime_"^"_ResourceName
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookRescoure",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetBookRescoure(OrdId,LocId,BookDateTime,ResourceName)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookRescoure",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// History: xzy--creator 协和预约 2013-4-25
/// Input： 医嘱号，
/// Output： 记录
/// Return： 记录，
/// Others： 
/// "1839977||209","1034",
ClassMethod UpdateBookDateTime(OrdId As %String, ResSchduleID As %String) As %String [ WebMethod ]
{
	s params=OrdId_"^"_ResSchduleID
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdateBookDateTime",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""
	s return=##class(web.DHCEkgService).UpdateBookDateTime(OrdId,ResSchduleID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdateBookDateTime",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

// -----电子病历 密码-------------

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-2-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 获取his设定的密码最小长度限制
/// Table：
/// Input：        
/// Output：       密码最小长度
/// w ##class(web.DHCEkgWebServiceNew).GetPasswordMinLength()
ClassMethod GetPasswordMinLength() As %String [ WebMethod ]
{
	;q "6"
	s return=##Class(web.DHCEkgService).GetPasswordMinLength()
	q return
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-2-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 获取his设定的密码规则和时效
/// Table：
/// Input：        参数为PwdContainWordAndNum获取是否必须包含数字与字母
/// 			   参数为PwdValidInterval获取密码时效性间隔
/// Output：       
/// w ##class(web.DHCEkgWebServiceNew).GetFieldValue("PwdContainWordAndNum")
/// w ##class(web.DHCEkgWebServiceNew).GetFieldValue("PwdValidInterval")
ClassMethod GetFieldValue(sign As %String) As %String [ WebMethod ]
{
	s return=##Class(web.DHCEkgService).GetFieldValue(sign)
	q return
}

/// Creator：      yangyali
/// CreatDate：    2016-2-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:： 获取his设定的密码连续错误次数
/// Table：
/// Input：      
/// Output： 		密码连续错误次数
/// w ##class(web.DHCEkgWebServiceNew).GetInvalidLoginAttempts()
ClassMethod GetInvalidLoginAttempts() As %String [ WebMethod ]
{
	s return=##Class(web.DHCEkgService).GetInvalidLoginAttempts()
	q return
}

// -----电子病历 密码-------------

ClassMethod PortalUnReadReport(portalUnReadReportInfo As %String) As %String [ WebMethod ]
{
}

/// Creator：      xuzuyuan
/// CreatDate：    2015-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:   portal确认报告已读
/// Table：
/// Input：        医嘱号^用户ID
/// Output： 	   调用结果
/// w ##class(web.DHCEkgWebServiceNew).SetRtpReadedStatus("699||133^1")
ClassMethod SetRtpReadedStatus(info As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SetRtpReadedStatus",$zd($h,3),$zt($p($h,",",2),1),info,"params")
	s return = "-1^失败"
	set return=##class(web.DHCEkgService).SetRtpReadedStatus(info)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SetRtpReadedStatus",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:   调用临床接口发送危急值
/// Table：
/// Input：        检查号，医嘱号，日期，时间，医生工号，诊断，检查结果
/// Output： 	   调用结果
/// w ##class(web.DHCEkgWebServiceNew).SaveEmergency("EKG||21||2","21||2","2019-8-16","10:30","admin","心肌梗塞","心肌梗塞")
ClassMethod SaveEmergency(ExamID As %String, RowID As %String, Date As %String, Time As %String, Doctor As %String, Desc As %String, Result As %String) As %String [ WebMethod ]
{
	  s params=ExamID_"^"_RowID_"^"_Date_"^"_Time_"^"_Doctor_"^"_Desc_"^"_Result
	  d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SaveEmergency",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	  s rtn=##Class(web.DHCEkgService).SaveEmergency(ExamID,RowID,Date,Time,Doctor,Desc,Result)
	  d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SaveEmergency",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	  q rtn
}

// 危急值

// ==================================================================

// web.DHCEkgWebServiceNew里增加：

// -----------------------------------------------

/// Modify: 	   yangyali
/// ModifyDate：   2014-08-11
/// Description:： 按照输入条件查询符合条件的申请单 
/// Table：        
/// Input：        执行科室id；登记号、病人姓名可为空；开始日期；结束日期
/// 					patientType=I O E H
/// Output：       xml串
/// Return：       xml串
/// w ##class(web.DHCEkgWebServiceNew).GetConOrdXML("85","","","2019-8-1","2019-8-17","","")
ClassMethod GetConOrdXML(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String, examItemID As %String, execFlag As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate_"^"_examItemID_"^"_execFlag
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetConOrdXML",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""
	s return=##class(web.DHCEkgService).GetConOrdXML(locId,patID,patName,stdDate,endDate,examItemID, execFlag,"")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetConOrdXML",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

// ================================================================

/// Creator：      yangyali
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:   科室 用户跟HIS 同步-Synchronous
/// Table：
/// Input：        用户名，密码
/// Output： 	   调用结果
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGDetpUserSynchronous("demo","1")
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGDetpUserSynchronous("2222222222222222","1")
ClassMethod DHCEKGDetpUserSynchronous(userName As %String, password As %String) As %String [ WebMethod ]
{
	s params=userName_"^"_password
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGDetpUserSynchronous",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##Class(web.DHCEkgService).DHCEKGDetpUserSynchronous(userName,password)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGDetpUserSynchronous",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-12-1
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-17
/// Description:   用户登录验证 同步-Synchronous
/// Table：
/// Input：        用户名，密码
/// Output： 	   调用结果
/// w ##class(web.DHCEkgWebServiceNew).userLoginSynchronous("demo","1")
/// w ##class(web.DHCEkgWebServiceNew).userLoginSynchronous("2222222222222222","1")
ClassMethod userLoginSynchronous(userName As %String, password As %String) As %String [ WebMethod ]
{
	s params=userName_"^"_password
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","userLoginSynchronous",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##Class(web.DHCEkgService).userLoginSynchronous(userName,password)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","userLoginSynchronous",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   是否为his用户 
/// Input：        用户工号
/// Output：       
/// Return： 	   Y：是HIS用户；N：非his用户
/// w ##class(web.DHCEkgWebServiceNew).IsHisUser("admin")
ClassMethod IsHisUser(userName As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","IsHisUser",$zd($h,3),$zt($p($h,",",2),1),userName,"params")
	s rtn=##Class(web.DHCEkgService).IfHisUser(userName)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","IsHisUser",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      xuzuyuan
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   更新ss_user表中的密码 
/// Input：        用户名，密码
/// Output：       
/// Return： 	   调用结果
/// w ##class(web.DHCEkgWebServiceNew).updateSSUserPwd("2222222222222222","1")
ClassMethod updateSSUserPwd(userName As %String, password As %String) As %String [ WebMethod ]
{
	s params=userName_"^"_password
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","updateSSUserPwd",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##Class(web.DHCEkgService).updateSSUserPwd(userName,password)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","updateSSUserPwd",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      xuzuyuan
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   向电子病历提供报告路径的接口 
/// Input：        就诊号
/// Output：       
/// Return： 		检查报告路径
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGPdfPathOut("221")
ClassMethod DHCEKGPdfPathOut(EpisodeID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfPathOut",$zd($h,3),$zt($p($h,",",2),1),EpisodeID,"params")
	s rtn=##Class(web.DHCEkgService).DHCEKGPdfPathOut(EpisodeID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfPathOut",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      wangguanyu
/// CreatDate：    2019-7-31
/// Description:   向电子病案归档的接口 
/// Input：        就诊号
/// Output：       
/// Return： 		检查是否需要归档
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGPdfFiled("45")
ClassMethod DHCEKGPdfFiled(EpisodeID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfFiled",$zd($h,3),$zt($p($h,",",2),1),EpisodeID,"params")
	s rtn=##Class(web.DHCEkgService).DHCEKGPdfFiled(EpisodeID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfFiled",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   温岭向电子病历提供报告路径的接口，独特性是心电库没保存就诊号 
/// Input：        就诊号
/// Output：       
/// Return： 		检查报告路径
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGPdfPathOutWL("457")
ClassMethod DHCEKGPdfPathOutWL(EpisodeID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfPathOutWL",$zd($h,3),$zt($p($h,",",2),1),EpisodeID,"params")
	s rtn=##Class(web.DHCEkgService).DHCEKGPdfPathOutWL(EpisodeID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGPdfPathOutWL",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      xuzuyuan
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   中日医院，获取密级级别
/// Input：        就诊号，错误信息
/// Output：       密级
/// Return： 
/// GetPatEncryptLevel(PAPMIRowId,.ErrMsg)
ClassMethod GetPatEncryptLevel(PAPMIRowId As %String, ErrMsg = "") As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetPatEncryptLevel",$zd($h,3),$zt($p($h,",",2),1),PAPMIRowId_"^"_ErrMsg,"params")
	//w ##class(web.DHCEkgWebServiceNew).GetPatEncryptLevel("221",ErrMsg)
	set rtn=##Class(web.DHCEkgService).GetPatEncryptLevel(PAPMIRowId,ErrMsg)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetPatEncryptLevel",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      xuzuyuan
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   中日医院，日志记录 
/// Input：        info=ModelName^Condition^Content^SecretCode^Success^UserId^IP^Mac^CName^LocId^GroupId
/// Output：       
/// Return：
/// w ##class(web.DHCEkgWebServiceNew).EventLog("221",ErrMsg)       
ClassMethod EventLog(info As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EventLog",$zd($h,3),$zt($p($h,",",2),1),info,"params")
	set rtn=##Class(web.DHCEkgService).EventLog(info)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EventLog",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-7-20
/// Description:： 获取服务器当前时间
/// Input：        
/// Output：       
/// Return：       当前时间，例：2017-1-12 13:40:33
/// w ##class(web.DHCEkgWebServiceNew).getDateTimeNow()
ClassMethod getDateTimeNow() As %String [ WebMethod ]
{
	  quit $zdt($h,3)_"."_$p($Now(),".",2)
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:   用卡号获取登记号
/// Input：        卡号
/// Output：       
/// Return：       登记号
/// w ##class(web.DHCEkgWebServiceNew).getRegNoByCardNo("")
ClassMethod getRegNoByCardNo(CardNo As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getRegNoByCardNo",$zd($h,3),$zt($p($h,",",2),1),CardNo,"params")
	set rtn=##Class(web.DHCEkgService).getRegNoByCardNo(CardNo)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getRegNoByCardNo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:： 向第三方体检回传检查结果等信息，郑州颐和
/// Input：        登记号^医嘱编码^医嘱名称^检查号^诊断^检查结果^医生姓名^发布时间^1#医嘱号（注：医嘱号是心电系统拼凑的登记号+医嘱编码的医嘱唯一识别码）
/// Output：       
/// Return：       调用结果
ClassMethod SentResultToTJ(ResultToTJ As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentResultToTJ",$zd($h,3),$zt($p($h,",",2),1),ResultToTJ,"params")
	set rtn=##Class(web.DHCEkgService).SentResultToTJ(ResultToTJ)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentResultToTJ",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-12
/// Description:： 提供检查报告路径
/// Input：        就诊号
/// Output：       
/// Return：       报告路径
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGExamNamePdfPathOut("45")
ClassMethod DHCEKGExamNamePdfPathOut(EpisodeID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGExamNamePdfPathOut",$zd($h,3),$zt($p($h,",",2),1),EpisodeID,"params")
	set rtn=""
	if EpisodeID'="" do
	.set rtn=##Class(web.DHCEkgService).DHCEKGExamNamePdfPathOut(EpisodeID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGExamNamePdfPathOut",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-10
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-25
/// Description:： 判断用户是否已阅读过此医嘱的检查报告
/// Input：        医嘱ID，用户ID（ss_user.rowid）
/// Output：       是否已阅读
/// Return：       返回：Y表示已阅读；N表示未阅读
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).IfRptRead("105","4||40")
ClassMethod IfRptRead(RowId As %String, UserId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","IfRptRead",$zd($h,3),$zt($p($h,",",2),1),RowId_"^"_UserId,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).IfRptRead(RowId,UserId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","IfRptRead",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-15
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-25
/// Description:： 密码加密，用于拼电子病历链接
/// Input：        his用户密码
/// Output：       加密后的密码
/// Return：       返回类似：7DDEB10883804C0C04911262A37E420C
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).EncryptPassword("1")
ClassMethod EncryptPassword(Password As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EncryptPassword",$zd($h,3),$zt($p($h,",",2),1),Password,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).MEncrypt(Password)
	if (rtn'="") set rtn=##Class(web.DHCEkgService).Md5Encrypt(rtn)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EncryptPassword",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-15
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-25
/// Description:： 获取用户安全组，用于拼电子病历链接
/// Input：        his用户工号
/// Output：       安全组名称
/// Return：       返回类似：Technician Manager
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetUserGroup("337")
ClassMethod GetUserGroup(userInitial As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetUserGroup",$zd($h,3),$zt($p($h,",",2),1),userInitial,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).GetUserGroup(userInitial)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetUserGroup",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-8-31
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-31
/// Description:   查询病人所有的心电图检查
/// Input：        登记号，住院号，来源
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGExamInfo("0000000249","","I")
ClassMethod DHCEKGExamInfo(PatientCode As %String, InPatientCode As %String, PatSourceCode As %String) As %String [ WebMethod ]
{
	s params=PatientCode_"^"_InPatientCode_"^"_PatSourceCode
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGExamInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).DHCEKGExamInfo(PatientCode,InPatientCode,PatSourceCode )
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGExamInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2016-8-31
/// Modify: 	   yangyali
/// ModifyDate：   2016-8-31
/// Description:   获取心电图报告
/// Input：        登记号，住院号，来源
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGRptInfo("154")
ClassMethod DHCEKGRptInfo(EXAMId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGRptInfo",$zd($h,3),$zt($p($h,",",2),1),EXAMId,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).DHCEKGRptInfo(EXAMId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGRptInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-9-1
/// Modify: 	   yangyali
/// ModifyDate：   2016-9-1
/// Description:   查询病人在时间范围内所有的心电图检查和报告
/// Input：        登记号/卡号，开始日期，结束日期
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGAutoPrtRptInfo("0000000202","2016-01-05","2020-10-07")
ClassMethod DHCEKGAutoPrtRptInfo(PatientCode As %String, StartDate As %String, Enddate As %String) As %String
{
	s params=PatientCode_"^"_StartDate_"^"_Enddate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGAutoPrtRptInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).DHCEKGAutoPrtRptInfo(PatientCode, StartDate, Enddate)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGAutoPrtRptInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2016-9-21
/// Modify: 	   yangyali
/// ModifyDate：   2016-9-21
/// Description:   黄岛与浙江远图所做接口，检查结果查询，供集成平台调用
/// Input：        开始日期，结束日期，病人来源，平台流水号，号码类型，卡类型，卡号/住院号
/// Output：       xml串
/// Return：       检查信息
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetExamInfo("2016-01-01","2020-10-22","住院","","1","","0000000202")
ClassMethod GetExamInfo(startDate As %String, endDate As %String, visitFrom As %String, platformId As %String, type As %String, cardType As %String, cardNo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=startDate_"^"_endDate_"^"_visitFrom_"^"_platformId_"^"_type_"^"_cardType_"^"_cardNo
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetExamInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set rtn=""
	set rtn=##Class(web.DHCEkgService).GetExamInfo(startDate, endDate , visitFrom,platformId,type,cardType,cardNo)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetExamInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      xuzuyuan
/// CreatDate：    2016-11-24
/// Modify: 	   yangyali
/// ModifyDate：   2016-11-24
/// Description:   华西医院，获取预约列表
/// Input：        登记号，姓名，开始日期，结束日期
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetHXYYBookXML("0000000202","","2016-01-01","2020-10-22")
ClassMethod GetHXYYBookXML(patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=patID_"^"_patName_"^"_stdDate_"^"_endDate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetHXYYBookXML",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetHXYYBookXML(patID,patName,stdDate,endDate)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetHXYYBookXML",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2016-11-24
/// Modify: 	   yangyali
/// ModifyDate：   2017-5-16
/// Description:   调用his接口获取病人年龄
/// Input：        就诊号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetPatAgeStr("45")
ClassMethod GetPatAgeStr(PAAdm As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetPatAgeStr",$zd($h,3),$zt($p($h,",",2),1),PAAdm,"params")
	set rtn=""
	if (PAAdm="")!(PAAdm=0) q "-1001"
	set rtn=##class(web.DHCEkgService).GetPatAgeStr(PAAdm)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetPatAgeStr",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-1-10
/// Modify: 	   yangyali
/// ModifyDate：   2017-1-10
/// Description:   温岭调电子病历迟归接口
/// Input：        医嘱号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).DHCEKGEPRPublish("7716242||39")
ClassMethod DHCEKGEPRPublish(ordID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGEPRPublish",$zd($h,3),$zt($p($h,",",2),1),ordID,"params")
	set rtn=""
	set rtn=##class(web.DHCEkgService).DHCEKGEPRPublish(ordID)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DHCEKGEPRPublish",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-2-5
/// Modify: 	   yangyali
/// ModifyDate：   2017-2-5
/// Description:   根据医嘱号查询医嘱信息
/// Input：        医嘱号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetOrdInfoByID("580||71")
ClassMethod GetOrdInfoByID(ordID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetOrdInfoByID",$zd($h,3),$zt($p($h,",",2),1),ordID,"params")
	set rtn=""
	if (ordID="") q rtn
	set OrderRowid=$p(ordID,"||",1)
	set itemsub=$p(ordID,"||",2)
	if ((OrderRowid="")||(itemsub="")) q rtn
    s OrderRowid=$p(ordID,"||",1) //64
    s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i (paadmdr'="")
    {
		s recLocDr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6) ;获取医嘱接收科室DR
		s recDeptCode=""
		i (recLocDr'="")
		{
			s CurrSpace=$ZNSPACE
			d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
			//获取接收科室代码
			try
			{
				s deptId=""
				f
				{
					s deptId=$o(^dbo.tblDictDeptD(deptId))
					q:(deptId="")
					s deptInfo=$g(^dbo.tblDictDeptD(deptId))
					s ekgExtend=$lg(deptInfo,3)
					i (ekgExtend=recLocDr) s recDeptCode=$lg(deptInfo,2)
				}
			}
			catch
			{
			}
			zn CurrSpace
		}
	    s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
	    s Gettypedesc=$p(PatInfo,"^",7)
		s rtn=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub,Gettypedesc)
		s rtn=rtn_"^"_recDeptCode
    }
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetOrdInfoByID",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-3-2
/// Modify: 	   yangyali
/// ModifyDate：   2017-3-2
/// Description:   根据就诊号查询是否已出院
/// Input：        就诊号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetCurrentDischargeStatus("51")
ClassMethod GetCurrentDischargeStatus(episodId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetCurrentDischargeStatus",$zd($h,3),$zt($p($h,",",2),1),episodId,"params")
	set rtn=""
	;q rtn
	if (episodId="") q rtn
	set rtn=##class(web.DHCEkgService).GetCurrentDischargeStatus(episodId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetCurrentDischargeStatus",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// creator:xzy
/// time:2017-04-07
/// 门诊调用计费方法  划卡之后进行计费
/// Input: 
///        cardNO:卡号,不能为空												读卡获取
///        secrityNo: 卡校验码, 不能为空									读卡获取
///        cardType: 卡类型, 不能为空										读卡获取
///        insType：费别, 可以为空											""
///        episodeID:就诊号, 可以为空（注:为空, OeoriIDStr不能为空)			appointid
///        oeoriIDStr：结算的医嘱串, 可以为空(注:为空, episodeID不能为空)	""
///        guser：操作员RowID, 不能为空										ss_user表中的SSUSR_RowId EKGStudio端传递登录的loginName
///        groupDR：安全组RowID, 不能为空									登录的安全组 EKGStudio端不用传递
///        locDR：登录科室RowID, 不能为空									ct_loc表中的CTLOC_RowID ekg表中的dbo.tblDictDept中的ekgExtend
///        hospDR：院区RowiD, 可以为空(为空时,根据登录科室取院区) 			""
/// Output: 
///         =0 结算成功, <>0 结算失败
///         -200  卡无效
///         -201  此卡无有效账户
///         -204  卡验证错误
///         -205  账户余额不足
///         -207  该卡对应的病人和界面上的病人不一致
///         101   无结算数据
///         102   金额不符
///         105   支付方式错误
///         120   有预结算异常数据,请先处理
///         2621  传入的医嘱串格式错误
///         -210  确认完成失败
///         -211  确认完成失败,撤销异常数据失败
/// w ##class(web.DHCEkgWebServiceNew).checkOut("","","","","","appointno","","636","85","")
ClassMethod checkOut(cardNO As %String, secrityNo As %String, cardType As %String, insType As %String, episodeID As %String, oeoriIDStr As %String, guser As %String, groupDR As %String, locDR As %String, hospDR As %String) As %String [ WebMethod ]
{
	s params=cardNO_"^"_secrityNo_"^"_cardType_"^"_insType_"^"_episodeID_"^"_oeoriIDStr_"^"_guser_"^"_groupDR_"^"_locDR_"^"_hospDR
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","checkOut",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn= ##class(web.DHCEkgService).checkOut(cardNO,secrityNo,cardType,insType,episodeID,oeoriIDStr,guser,groupDR,locDR,hospDR)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","checkOut",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2017-4-11
/// Modify: 	   yangyali
/// ModifyDate：   2017-4-11
/// Description:： 成医附医代码需要
/// Table：
/// Input：        执行科室id（必须有）；登记号patID(可无)；patName病人姓名（可无）；stdDate开始日期（必须有）；endDate结束日期（必须有）
/// Output：       记录
/// Return：       记录，
ClassMethod GetBookedList(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedList",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetBookedListXML(locId,patID,patName,stdDate,endDate)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedList",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// UserAuthenticate
/// Creator：      yangyali
/// CreatDate：    2017-4-11
/// Modify: 	   yangyali
/// ModifyDate：   2017-4-11
/// Description:： 成医附医代码需要
/// Table：
/// Input：        执行科室id（必须有）；登记号patID(可无)；patName病人姓名（可无）；stdDate开始日期（必须有）；endDate结束日期（必须有）
/// Output：       记录
/// Return：       记录，
ClassMethod GetBookedListCard(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s params=locId_"^"_patID_"^"_patName_"^"_stdDate_"^"_endDate
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListCard",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return = ""	
	s return=##class(web.DHCEkgService).GetBookedListXML(locId,patID,patName,stdDate,endDate)	
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetBookedListCard",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-4-11
/// Modify: 	   yangyali
/// ModifyDate：   2017-4-11
/// Description:： 成医附医代码需要
ClassMethod UpdataOrdInfoEx(OrditmRowids As %String, userId As %String, Status As %String, LocId As %String, desc As %String) As %String [ WebMethod ]
{
	;set tmpStatus = Status
	;set Status=$p(tmpStatus,"^",1)
	;set userId=""
	;set userId=$p(tmpStatus,"^",2)
	s params=OrditmRowids_"^"_userId_"^"_Status_"^"_LocId_"^"_desc
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataOrdInfoEx",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return=##class(web.DHCEkgService).UpdataOrdInfo(OrditmRowids,userId, Status,"","")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","UpdataOrdInfoEx",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-5-27
/// Modify: 	   yangyali
/// ModifyDate：   2017-5-27
/// Description:   把申请单状态置为登记，同时执行医嘱
/// Table：        
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgWebServiceNew).SetExamStatusInfo("1318||4","636@孙燕姿","85")
ClassMethod SetExamStatusInfo(OrdId As %String, UserName As %String, LocId As %String) As %String [ WebMethod ]
{
	s params=OrdId_"^"_UserName_"^"_LocId
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SetExamStatusInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s return=##class(web.DHCEkgService).SetExamStatusInfo(OrdId,UserName, LocId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SetExamStatusInfo",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   登记医嘱：把申请单状态置为登记，同时执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgWebServiceNew).EKGRegiseter4His("451||100","636","85")
ClassMethod EKGRegiseter4His(OrdId As %String, UserName As %String, LocId As %String) As %String [ WebMethod ]
{
	s params=OrdId_"^"_UserName_"^"_LocId
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	i (OrdId'="") d
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),UserName,OrdId)
	s return=##class(web.DHCEkgService).EKGRegiseter4His(OrdId,UserName, LocId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   检查后：把申请单状态置为登记，同时执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，是否执行医嘱^是否置检查状态
/// Output：       调用结果
/// w ##class(web.DHCEkgWebServiceNew).EKGExam4His("59||272","admin","Y")
ClassMethod EKGExam4His(OrdId As %String, UserName As %String, IfExecute As %String) As %String [ WebMethod ]
{
	s params=OrdId_","_UserName_","_IfExecute
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	i (OrdId'="") d
	.d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),UserName_","_IfExecute,OrdId)
	i (IfExecute=$c(0)) s IfExecute=""
	s return=##class(web.DHCEkgService).EKGExam4His(OrdId,UserName, IfExecute)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGExam4His",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   取消登记：把申请单状态置为正在申请，同时撤销执行医嘱
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgWebServiceNew).EKGUnRegiseter4His("81||128","admin")
ClassMethod EKGUnRegiseter4His(OrdId As %String, UserName As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName,"params")
	s return=##class(web.DHCEkgService).EKGUnRegiseter4His(OrdId,UserName)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGUnRegiseter4His",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// Creator：      yangyali
/// CreatDate：    2017-6-9
/// Modify: 	   yangyali
/// ModifyDate：   2017-6-9
/// Description:   审核报告：把申请单状态置为登记，同时执行医嘱，把报告状态置为发布
/// Table：       
/// Input：        医嘱号，用户工号，科室ID
/// Output：       调用结果
/// w ##class(web.DHCEkgWebServiceNew).EKGArbiter4His("179||113","636")
ClassMethod EKGArbiter4His(OrdId As %String, UserName As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName,"params")
	s return=##class(web.DHCEkgService).EKGArbiter4His(OrdId,UserName)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGArbiter4His",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// 保存按钮 修改申请单状态 用于内蒙古区域 
/// w ##class(web.DHCEkgWebServiceNew).EKGSave4His("179||113","636")
ClassMethod EKGSave4His(OrdId As %String, UserName As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGSave4His",$zd($h,3),$zt($p($h,",",2),1),OrdId_"^"_UserName,"params")
	set rtnRemote=##class(web.DHCEkg.Remote.EKGServiceN).ChangeReqStatus(OrdId,"2")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGSave4His",$zd($h,3),$zt($p($h,",",2),1),rtnRemote,"rtn")
	q return
}

/// 医嘱号不合法判断 返回空 update by caoll 2022-11-30
/// Creator：      yangyali
/// CreatDate：    2017-2-5
/// Modify: 	   yangyali
/// ModifyDate：   2017-2-5
/// Description:   根据医嘱号查询医嘱信息
/// Input：        医嘱号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).GetEKGInfoByOrdID("41||104")
ClassMethod GetEKGInfoByOrdID(OrdID As %String) As %String [ WebMethod ]
{
	b ;1
	q:OrdID="" ""
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoByOrdID",$zd($h,3),$zt($p($h,",",2),1),OrdID,"params")
	s rtn=""
	if (OrdID'="")
	{
		set OrderRowid=$p(OrdID,"||",1) 
		set itemsub=$p(OrdID,"||",2) 
		if ((OrderRowid'="")&&(itemsub'=""))
		{
			s rtn=##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem(OrdID)
		}
	}
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetEKGInfoByOrdID",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2017-7-18
/// Modify: 	   yangyali
/// ModifyDate：   2017-7-18
/// Description:   给影像CCA发送心电检查结果
/// Input：        医嘱号
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).SentEKGInfoToCCA("001100000002115")
ClassMethod SentEKGInfoToCCA(OrdId As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentEKGInfoToCCA",$zd($h,3),$zt($p($h,",",2),1),OrdId,"params")
	s rtn=##class(web.DHCEkgService).SentEKGInfoToCCA(OrdId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentEKGInfoToCCA",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// web.DHCEkgWebServiceNew.cls
/// Creator：      xzy
/// CreatDate：    2017-8-9
/// Modify: 	   
/// ModifyDate：   
/// Description:   南大二院 纳龙传加急或者急诊状态 心电进行状态更新
/// Input：        纳龙唯一标识 
/// 						patType 1=急诊加急 2=住院加急 3=胸痛加急
/// 				   statusFlag 0=不加急 1=加急
/// Output：       string
/// Return：       string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).SentEKGEmergencyOrUrgent("abc-121-dadf-2323-jkf3")
/// w ##class(web.DHCEkgWebServiceNew).SentEKGEmergencyOrUrgent("abc-121-dadf-2323-jkf3",2)
ClassMethod SentEKGEmergencyOrUrgent(uniqNo As %String, patType = "1", statusFlag = "1") As %String [ WebMethod ]
{
	s params=uniqNo_"^"_patType_"^"_statusFlag
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentEKGEmergencyOrUrgent",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	set rtn=##class(web.DHCEkgService).SentEKGEmergencyOrUrgent(uniqNo,patType,statusFlag)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","SentEKGEmergencyOrUrgent",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// web.DHCEkgWebServiceNew.cls
/// Creator：      xzy
/// CreatDate：    2017-11-13
/// Modify: 	   
/// ModifyDate：   
/// Description:   江苏省中医接口方法
/// Input：        oeordid=医嘱号
/// Return：       json string
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).saveReport("451||81")
ClassMethod saveReport(oeordid As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","saveReport",$zd($h,3),$zt($p($h,",",2),1),oeordid,"params")
	set rtn=##class(web.DHCEkgService).saveReport(oeordid)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","saveReport",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	quit rtn
}

/// Modify: 	   yangyali
/// ModifyDate：   2017-12-19
/// Description:： 按照输入条件查询符合条件的申请单，南大二院增加是否缴费参数
/// Table：        
/// Input：        执行科室id；登记号、病人姓名可为空；开始日期；结束日期；医嘱ID；执行标志；缴费标志
/// 					patientType=I O E H
/// Output：       xml串
/// Return：       xml串
/// w ##class(web.DHCEkgWebServiceNew).GetConOrdNDEY("85","","","2018-3-28","2018-4-2","","1","")
ClassMethod GetConOrdNDEY(locId As %String, patID As %String, patName As %String, stdDate As %String, endDate As %String, examItemID As %String, execFlag As %String, feeFlag As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s return = ""
	s param=locId_","_patID_","_patName_","_stdDate_","_endDate_","_examItemID_","_execFlag_","_feeFlag
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetConOrdNDEY",$zd($h,3),$zt($p($h,",",2),1),param,"params")
	s return=##class(web.DHCEkgService).GetConOrdNDEY(locId,patID,patName,stdDate,endDate,examItemID, execFlag,feeFlag,"")
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","GetConOrdNDEY",$zd($h,3),$zt($p($h,",",2),1),return,"return")
	q return
}

/// web.DHCEkgWebServiceNew.cls
/// Creator：      xzy
/// CreatDate：    2018-04-08
/// Modify: 	   
/// ModifyDate：   
/// Description:   通过医嘱号 获取医嘱状态
/// Input：        oeordid=医嘱号
/// Return：       状态 E V D U C
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).getOeOrdStatus("451||81")
ClassMethod getOeOrdStatus(oeordid As %String) As %String [ WebMethod ]
{
	quit:(oeordid="") "医嘱号为空"
	//451||81
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getOeOrdStatus",$zd($h,3),$zt($p($h,",",2),1),oeordid,"params")
	set ItemStatusCode=""
	set OrderRowid=$p(oeordid,"||",1) //451
    quit:(OrderRowid="") "医嘱号不符合 num||num 格式"
    set itemsub=$p(oeordid,"||",2) //81
	quit:(itemsub="") "医嘱号不符合 num||num 格式"
	set ItemStatDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13) ; 医嘱状态
	quit:(ItemStatDR="") ""
	set ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getOeOrdStatus",$zd($h,3),$zt($p($h,",",2),1),ItemStatusCode,"rtn")
	quit ItemStatusCode
}

/// web.DHCEkgWebServiceNew.cls
/// Creator：      xzy
/// CreatDate：    2018-05-18
/// Modify: 	   
/// ModifyDate：   
/// Description:   调用非东华叫号接口 其中调用的类为东华平台组封装好的类
/// Input：        xml串 呼叫病人以及候诊病人
/// 
/// <Request><call_area>彩超2号</call_area><call_room>彩超2号</call_room><IPaddress>10.102.38.36</IPaddress><doctor_title></doctor_title><doctor_call_name></doctor_call_name><call_no>0000003631</call_no><pat_name>李月杰</pat_name><Call_Type>C</Call_Type><dept_code>特检科</dept_code><dept_name>特检科</dept_name><SeqNo>B003</SeqNo><AdmDate>2018-05-18</AdmDate><AdmTime>00:00:00</AdmTime><WaitPatLists/></Request>
/// call_area 诊区
/// call_room 诊室
/// IPaddress  IP地址
/// doctor_title 医生职称(医技不用传)
/// doctor_call_name 医生名称(医技不用)
/// call_no 登记号
/// pat_name 患者姓名 
/// Call_Type 就诊类别 C正在就诊 W 等候就诊
/// dept_code 呼叫科室代码
/// dept_name 呼叫科室名称
/// SeqNo 流水号
/// AdmDate 就诊日期
/// AdmTime 就诊时间
/// <WaitPatLists><WaitPat><pat_name>姓名</pat_name><call_no>登记号</call_no><Call_Type>W</Call_Type></WaitPat><WaitPat>...</WaitPat></WaitPatLists>  等候患者列表
/// Return：       
/// Others：
/// w ##class(web.DHCEkgWebServiceNew).CallPatientInfo("451||81")
ClassMethod notDHCCall(callInfo As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","notDHCCall",$zd($h,3),$zt($p($h,",",2),1),callInfo,"params")
	s rtn= ##class(web.DHCENS.EnsHISService).CallPatientInfo(callInfo)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","notDHCCall",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Modify: 	   zhouyanwei
/// ModifyDate：   2018-06-01
/// Description:： 获取医嘱加急状态,深圳石岩
/// Table：        
/// Input：        医嘱ROWID
/// Output：       
/// Return：       Y-加急 N-不加急
/// w ##class(web.DHCEkgWebServiceNew).GetReqUrgencyByRowID("68||4")
ClassMethod GetReqUrgencyByRowID(OrdID As %String) As %String [ WebMethod ]
{
	s return = ""
	
	;s return=##class(web.DHCEkgService).GetReqUrgencyByRowID(OrdID)
	
	q return
}

/// Creator:		yangyali
/// CreatDate:		2018-6-28
/// Description:	接口调用统一入口
/// Table:			dbo.tblInterface
/// Input：			KeyName:方法编码,InputParameter:方法参数，参数之间以~分隔
/// Return：		接口调用结果
/// w ##class(web.DHCEkgWebServiceNew).EKGInterfaceInvoke("GETEKGINFOTXT","85~383~2018-3-1~2018-4-1")
/// w ##class(web.DHCEkgWebServiceNew).EKGInterfaceInvoke("GETPAADMINFO","756")
ClassMethod EKGInterfaceInvoke(KeyName As %String, InputParameter As %String) As %GlobalCharacterStream [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGInterfaceInvoke",$zd($h,3),$zt($p($h,",",2),1),KeyName_"^"_InputParameter,"params")
	s return = ""	
	s input=##class(%GlobalCharacterStream).%New()
	d input.Write(InputParameter)
	s return=##class(web.DHCEkgService).EKGInterfaceInvoke(KeyName, input)
	s rtn=return.Read(return.Size)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","EKGInterfaceInvoke",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q return
}

/// 方法说明：	查询医嘱列表
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		locId^patCode^patInCode^cardNo^patName^stdDate^endDate^examItemFilter^execFlag^feeFlag^patientType
/// 			科室ID^登记号^住院号^卡号^姓名^开始日期^结束日期^医嘱过滤^执行状态^费用状态^病人来源
/// 					执行状态：0:核实; 1:执行;
/// 					费用状态：0:未收费;1:已收费;
/// 返回值：	医嘱信息(xml流)
/// w ##class(web.DHCEkgWebServiceNew).getEKGOrdInfo("85^342^^^^2022-11-1^2022-11-14^^0^0^")
ClassMethod getEKGOrdInfo(params As %String(MAXLEN=32767)) As %GlobalCharacterStream [ WebMethod ]
{
	;s objStream=##class(%GlobalCharacterStream).%New()
	;d objStream.Write("<WinData><ConOrdList><RegNo>登记号</RegNo><PatName>姓名</PatName><Sex>性别</Sex><Age>年龄</Age><admType>病人来源</admType><BedCode>床号</BedCode><Ward>病区</Ward><ArcimDesc>医嘱名称</ArcimDesc><OrdDateTime>开单时间</OrdDateTime><OrdStatDesc>医嘱状态</OrdStatDesc><ExamState>检查状态</ExamState><CtcpDesc>申请医生</CtcpDesc><OeordId>医嘱ID</OeordId><Medicare>住院号</Medicare></ConOrdList><ConOrdList><RegNo>0000000545</RegNo><PatName>cs转费用</PatName><Sex>女</Sex><Age>29岁</Age><admType>住院病人</admType><BedCode>1503床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>常规心电图检查(12导联)</ArcimDesc><OrdDateTime>2020-10-09  11:27:52</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>1060||19</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>20</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>20</OrdCost><admId>1091</admId><Medicare>000153</Medicare><DobDate>1991-04-07</DobDate></ConOrdList><ConOrdList><RegNo>0000000545</RegNo><PatName>cs转费用</PatName><Sex>女</Sex><Age>29岁</Age><admType>住院病人</admType><BedCode>1503床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>动态心电图(三导联)</ArcimDesc><OrdDateTime>2020-10-09  11:28:00</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>1060||20</OeordId><OrcatDesc>动态心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>250</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>250</OrdCost><admId>1091</admId><Medicare>000153</Medicare><DobDate>1991-04-07</DobDate></ConOrdList><ConOrdList><RegNo>0000000545</RegNo><PatName>cs转费用</PatName><Sex>女</Sex><Age>29岁</Age><admType>住院病人</admType><BedCode>1503床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>心电图阿托品试验[测试]</ArcimDesc><OrdDateTime>2020-10-09  11:28:00</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>1060||21</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>15</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>15</OrdCost><admId>1091</admId><Medicare>000153</Medicare><DobDate>1991-04-07</DobDate></ConOrdList><ConOrdList><RegNo>0000000545</RegNo><PatName>cs转费用</PatName><Sex>女</Sex><Age>29岁</Age><admType>住院病人</admType><BedCode>1503床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>心电图心得安试验</ArcimDesc><OrdDateTime>2020-10-09  11:28:00</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>1060||22</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>15</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>15</OrdCost><admId>1091</admId><Medicare>000153</Medicare><DobDate>1991-04-07</DobDate></ConOrdList><ConOrdList><RegNo>0000000545</RegNo><PatName>cs转费用</PatName><Sex>女</Sex><Age>29岁</Age><admType>住院病人</admType><BedCode>1503床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>常规心电图检查(18导联)</ArcimDesc><OrdDateTime>2020-10-09  11:28:02</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>1060||25</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>20</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>20</OrdCost><admId>1091</admId><Medicare>000153</Medicare><DobDate>1991-04-07</DobDate></ConOrdList><ConOrdList><RegNo>0000000033</RegNo><PatName>zyh7316</PatName><Sex>男</Sex><Age>3岁</Age><admType>住院病人</admType><BedCode>1601床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>常规心电图检查(12导联)</ArcimDesc><OrdDateTime>2020-10-09  11:29:52</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>47||395</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>20</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>20</OrdCost><admId>39</admId><Medicare>000010</Medicare><DobDate>2017-01-01</DobDate></ConOrdList><ConOrdList><RegNo>0000000033</RegNo><PatName>zyh7316</PatName><Sex>男</Sex><Age>3岁</Age><admType>住院病人</admType><BedCode>1601床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>动态心电图(三导联)</ArcimDesc><OrdDateTime>2020-10-09  11:29:59</OrdDateTime><OrdStatDesc>执行</OrdStatDesc><ExamState>登记</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>47||396</OeordId><OrcatDesc>动态心电</OrcatDesc><ExecDateTime>2020-10-09 14:46:11</ExecDateTime><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>250</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>250</OrdCost><admId>39</admId><Medicare>000010</Medicare><DobDate>2017-01-01</DobDate></ConOrdList><ConOrdList><RegNo>0000000033</RegNo><PatName>zyh7316</PatName><Sex>男</Sex><Age>3岁</Age><admType>住院病人</admType><BedCode>1601床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>心电图阿托品试验[测试]</ArcimDesc><OrdDateTime>2020-10-09  11:29:59</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>47||397</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>15</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>15</OrdCost><admId>39</admId><Medicare>000010</Medicare><DobDate>2017-01-01</DobDate></ConOrdList><ConOrdList><RegNo>0000000033</RegNo><PatName>zyh7316</PatName><Sex>男</Sex><Age>3岁</Age><admType>住院病人</admType><BedCode>1601床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>心电图心得安试验</ArcimDesc><OrdDateTime>2020-10-09  11:30:00</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>47||398</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>15</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>15</OrdCost><admId>39</admId><Medicare>000010</Medicare><DobDate>2017-01-01</DobDate></ConOrdList><ConOrdList><RegNo>0000000033</RegNo><PatName>zyh7316</PatName><Sex>男</Sex><Age>3岁</Age><admType>住院病人</admType><BedCode>1601床</BedCode><Ward>中西医结合二科护理单元</Ward><ArcimDesc>常规心电图检查(18导联)</ArcimDesc><OrdDateTime>2020-10-09  11:30:01</OrdDateTime><OrdStatDesc>核实</OrdStatDesc><ExamState>申请</ExamState><CtcpDesc>孙凤霞</CtcpDesc><OeordId>47||401</OeordId><OrcatDesc>静息心电</OrcatDesc><RecLocDesc>功能检查科心电图</RecLocDesc><AdmDep>中西医结合二科</AdmDep><OrdUnitCost>20</OrdUnitCost><OrdQty>1</OrdQty><OrdCost>20</OrdCost><admId>39</admId><Medicare>000010</Medicare><DobDate>2017-01-01</DobDate></ConOrdList></WinData>")
	;q objStream

	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGOrdInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).getEKGOrdInfo(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGOrdInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

ClassMethod getEKGOrdInfo4m(locId As %String, patCode As %String, patInCode As %String, cardNo As %String, patName As %String, stdDate As %String, endDate As %String, examItemFilter As %String, execFlag As %String, feeFlag As %String, patientType As %String) As %XML.DataSet [ WebMethod ]
{
	s params=locId_"^"_patCode_"^"_patInCode_"^"_cardNo_"^"_patName_"^"_stdDate_"^"_endDate_"^"_examItemFilter_"^"_execFlag_"^"_feeFlag_"^"_patientType
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGOrdInfo4m",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	;q ##class(web.DHCEkgService).getEKGOrdInfo4m(locId,patCode,patInCode,cardNo,patName,stdDate,endDate,examItemFilter,execFlag,feeFlag,patientType)
	;n (locId,patCode,patInCode,cardNo,patName,stdDate,endDate,examItemFilter,execFlag,feeFlag,patientType)
	s RegNoLength = +##class(web.DHCEkgNo).getRegNoLength() //卡号长度
	s CardNoLength = +##class(web.DHCEkgNo).getCardNoLength() //卡号长度
	s InNoLength = +##class(web.DHCEkgNo).getInNoLength() //住院号长度
	
	i (patCode'="") s patCode=##class(web.DHCEkgNo).getFullNo(patCode,RegNoLength)
	e  i (patInCode'="") d
	.s patInCode=##class(web.DHCEkgNo).getFullNo(patInCode,InNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByInNo(patInCode)
	e  i (cardNo'="") d
	.s cardNo=##class(web.DHCEkgNo).getFullNo(cardNo,CardNoLength)
	.s patCode= ##class(web.DHCEkgNo).getRegNoByCardNo(cardNo)
	e  i (patName'="") d
	.s patCode=##class(web.DHCEkgNo).getRegNoByPatName(patName,locId)	
	
	i stdDate="" s stdDate=$p($h,",",1)-5
	else  s stdDate=$zdh(stdDate,3)
	i endDate="" s endDate=$p($h,",",1)+1
	else  s endDate=$zdh(endDate,3)
	
	s rs=##class(%XML.DataSet).%New("web.DHCEkgGetConOrd:GetEkgOdrList")
	d rs.Execute(locId,patCode,stdDate,endDate,examItemFilter, execFlag,feeFlag,patientType)
    d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGOrdInfo4m",$zd($h,3),$zt($p($h,",",2),1),rs,"rtn")
	q rs
}

/// 方法说明：	获取已登记医嘱列表
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-24
/// 入参：		execDept^patCode^patInCode^cardNo^patName^stdDate^endDate^examItemFilter
/// 			接收科室Code^登记号^住院号^卡号^姓名^开始日期^结束日期^医嘱过滤项
/// 返回值：	医嘱信息(xml流)
/// w ##class(web.DHCEkgWebServiceNew).getEKGRegOrderInfo("功能检查科心电图^^^^^2022-11-01^2022-11-10^常规心电图检查(12导联);常规心电图检查(12导联);心电图阿托品试验[测试];心电图心得安试验;心电图平板运动试验;频谱心电图检查;常规心电图检查(18导联);24小时动态血压监测;心电向量图;CT颅脑平扫;动态心电图;十五导联心电图检查(后壁);十二导心电图检查;动态心电图(三导联);床旁心电图检查(12导联)")
ClassMethod getEKGRegOrderInfo(params As %String(MAXLEN=32767)) As %GlobalCharacterStream [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGRegOrderInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).getEKGRegOrderInfo(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getEKGRegOrderInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// update by caoll 2022-11-29
/// 方法说明：	登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-19
/// 入参：		ordID^userLoginName^locCode
/// 			医嘱ID^用户工号^登记者的登录code^判断出院状态("Y")^判断费用状态("Y")
/// 返回值：	存储数据结果^执行医嘱结果^登记申请单结果
/// w ##class(web.DHCEkgWebServiceNew).regEKGInfo("1014||39^admin^功能检查科心电图")
ClassMethod regEKGInfo(params As %String(MAXLEN=32767)) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","regEKGInfo",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).regEKGInfo(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","regEKGInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

ClassMethod getOrderByOrderId(params As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getOrderByOrderId",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn= ##class(web.DHCEkgService).getDHCEKGOrderInfoBylistOrderItem(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getOrderByOrderId",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// update by caoll 2022-11-29
/// 方法说明：	撤销登记医嘱
/// 创建者：	杨亚莉
/// 创建时间：	2018-7-24
/// 入参：		ordID^userLoginName
/// 			医嘱ID^用户工号
/// 返回值：	调用成功返回空，否则返回异常详情
/// w ##class(web.DHCEkgWebServiceNew).revokeEKGOrder("580||74^admin")
ClassMethod revokeEKGOrder(params As %String(MAXLEN=32767)) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","revokeEKGOrder",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).revokeEKGOrder(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","revokeEKGOrder",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// 方法说明：	审核医嘱时调用此方法，将信息入库，已经调用其他方法
/// 创建者：	xzy
/// 创建时间：	2018-8-1
/// 入参：		examId^userId^clientId^toStatus^diagnose^character^NP^isSendEmergency^setHISOrderStatus^deptId^examCode^patSource^opLoginName^abLoginName^deviceId
/// 			examinationId1^用户Id2^客户端Id3^toStatus4将要变为的状态^diagnose5诊断^character6特征^NP7阴性阳性^isSendEmergency8是否发送危急值^setHISOrderStatus9是否执行医嘱^参数deptId10^examCode11^patSource12^opLoginName13^abLoginName14^deviceId15
/// 返回值：	调用成功返回空，否则返回异常详情
/// w ##class(web.DHCEkgWebServiceNew).saveExamination("987^739^23^15^大致正常心电图321^^阴性^^1^85^81||131^住院^admin^admin")
ClassMethod saveExamination(params As %String(MAXLEN=32767)) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","saveExamination",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).saveExamination(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","saveExamination",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// 方法说明：	打印的时候调用此方法，改变打印时间以及打印状态
/// 创建者：	xzy
/// 创建时间：	2018-8-3
/// 入参：		examId
/// 			examinationId1
/// 返回值：	调用成功返回空，否则返回异常详情
/// w ##class(web.DHCEkgWebServiceNew)savePrint("")
ClassMethod savePrint(params As %String(MAXLEN=32767)) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","savePrint",$zd($h,3),$zt($p($h,",",2),1),params,"params")
	s rtn=##class(web.DHCEkgService).savePrint(params)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getData4String",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// 方法说明：	查看申请单时调用此方法获取申请单ID
/// 创建者：	yyl
/// 创建时间：	2018-8-2
/// 入参：		医嘱号
/// 返回值：	申请单ID
/// w ##class(web.DHCEkgWebServiceNew).getReqIdByOrdId("")
ClassMethod getReqIdByOrdId(oeordID As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getReqIdByOrdId",$zd($h,3),$zt($p($h,",",2),1),oeordID,"params")
	s arReqID=""
	i oeordID'=""  d
	.s DARowId=""
	.f  s DARowId=$o(^DHCAPREP(0,"OrdItem",oeordID,DARowId)) q:DARowId=""  d
	..s arReqID=DARowId
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getReqIdByOrdId",$zd($h,3),$zt($p($h,",",2),1),arReqID,"rtn")
	q arReqID
}

/// 方法说明：	验证许可证
/// 创建者：	yyl
/// 创建时间：	2018-10-9
/// 入参：		
/// 返回值：	是否验证成功^提示信息
/// w ##class(web.DHCEkgWebServiceNew).DecryptLic("JHP9AyaBS1o+kg3Qj9DdWJdQn4f4Br8vzWnmt/qlsYfT+GpOwcd0ygZ27KTnS8YZChcKbq47HMbAA2gexnwZOkc+nSWZwXqk2VqjJ/cvV/CZ7gLwL++JoAioEvj3xISnJq/+QAPTb0b+e/ZJYq1XyDVerGU/A8ug6hEkDGeBuIk=a06gqH7KYZ9qcVOoEUJczEXZ37yp3DZWCvhMAeaflAFYe1GOUmmvcd2nFmKjWxgcN0/mMrJVa07En1tVCIIOg1OmcMKbcHZ5NXPqkX60+QAawXIEa7bggZn17X67hjT+4rhNeKsc93HThLFlSX9Y95ruU/jHnZ/mhkIgCnzIoSk=")
ClassMethod DecryptLic(EncLic As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","DecryptLic",$zd($h,3),$zt($p($h,",",2),1),EncLic,"params")
	s permission=##class(websys.License).DecryptLicStr(EncLic,"EKG_LIC_PublicKey.pem")
	s cmpCode=##class(websys.License).EncryptCmpCode()
	q:(permission="") "-1^验证失败，请重新申请许可证"
	s perDate=$p(permission,"^",1)
	s perProduct=$p(permission,"^",2)
	s perCmpCode=$p(permission,"^",5)
	s perVersion=$p(permission,"^",6)
	q:(perDate="")!(perCmpCode="")!(perProduct="") "-1^验证失败，请重新申请许可证"
	q:(perCmpCode'=cmpCode) "-1^验证失败，机器码不匹配，请重新申请许可证"
	q:(perProduct'="EKG") "-1^验证失败，产品不匹配，请重新申请许可证"
	s curVersion=..getEKGVersion()
	q:(perVersion="")!(curVersion'[perVersion) "-1^版本不匹配，请重新申请许可证"
	s perH=$zdh(perDate,3)
	s now=$p($h,",",1)
	q:(now>perH) "-1^许可证已失效，请重新申请许可证"
	s tipH=perH-now ;距离失效的时间
	q:(tipH<30) "0^许可证将在"_tipH_"天后失效，请及时申请许可证"
	
	q "0"
}

/// 方法说明：	获取服务器机器码
/// 创建者：	yyl
/// 创建时间：	2018-10-9
/// 入参：		无
/// 返回值：	服务器机器码
/// w ##class(web.DHCEkgWebServiceNew).getCmpCode()
ClassMethod getCmpCode() As %String [ WebMethod ]
{
	s rtn=##class(websys.License).EncryptCmpCode()
	q rtn
}

/// 方法说明：	验证已注册的许可证
/// 创建者：	yyl
/// 创建时间：	2018-10-10
/// 入参：		无
/// 返回值：	验证结果^提示信息
/// w ##class(web.DHCEkgWebServiceNew).VerifyLicense()
ClassMethod VerifyLicense() As %String [ WebMethod ]
{
	s rtn=""
	s LicStr=$g(^EKGLicenseStr("LicenseStr"))
	b ;w LicStr
	i (LicStr="") s rtn="-1^请申请许可证"
	e  s rtn=..DecryptLic(LicStr)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","VerifyLicense",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// 方法说明：	验证新注册的许可证
/// 创建者：	yyl
/// 创建时间：	2018-10-10
/// 入参：		许可证
/// 返回值：	验证结果^提示信息
/// w ##class(web.DHCEkgWebServiceNew).VerifyNewLicStr("f0RLRrk8uMKP9/OEg/9HpVAE/sZjHTXRKPnNMfpky+jOGgMJ7HLEWJHgzb0bUzkcCfxpHd9rDmOOddUeL7P8h2GBNlehwQrcAF9Gz1IY8g+durdO3D8I8Eawj7VxE6FxXAZ+VjWo77USzNHP9LSfjlGc9YKl82Zk3+97pGyI5so=")
ClassMethod VerifyNewLicStr(EncLic) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","VerifyNewLicStr",$zd($h,3),$zt($p($h,",",2),1),EncLic,"params")
	q:(EncLic="") "-1"
	s permission=##class(websys.License).DecryptLicStr(EncLic,"EKG_LIC_PublicKey.pem")
	q:(permission="") "-1^验证失败"
	b ; w permission
	s rtn=""
	s cmpCode=##class(websys.License).EncryptCmpCode()
	s perDate=$p(permission,"^",1)
	s perProduct=$p(permission,"^",2)
	s perCmpCode=$p(permission,"^",5)
	s perVersion=$p(permission,"^",6)
	q:(perDate="")!(perCmpCode="")!(perProduct="") "-1^验证失败，请重新申请许可证"
	q:(perCmpCode'=cmpCode) "-1^验证失败，机器码不匹配，请重新申请许可证"
	q:(perProduct'="EKG") "-1^验证失败，产品不匹配，请重新申请许可证"
	s curVersion=..getEKGVersion()
	q:(perVersion="")!(curVersion'[perVersion) "-1^版本不匹配，请重新申请许可证"
	s perH=$zdh(perDate,3)
	s now=$p($h,",",1)
	q:(now>perH) "-1^许可证已失效，请重新申请许可证"
	s tipH=perH-now ;距离失效的时间
	i (tipH<30) s rtn="0^许可证将在"_tipH_"天后失效，请及时申请许可证"
	s ^EKGLicenseStr("LicenseStr")=EncLic
	s ^EKGLicenseStr("permission",$zdt($h,3))=permission
	;s ^EKGLicenseStr("permissionSave",$zdt($h,3))=##class(websys.License).DecryptLicAndSave(EncLic,"LIC_Publickey.pem","EKG.LICENSE")
	q "0"
}

/// 方法说明：	获取心电系统版本号
/// 创建者：	yyl
/// 创建时间：	2018-10-18
/// 入参：		
/// 返回值：	版本号
/// w ##class(web.DHCEkgWebServiceNew).getEKGVersion()
ClassMethod getEKGVersion() As %String [ WebMethod ]
{
	s rtn=""
	s rtn=$g(^EKGVersion("Version"))
	
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2019-9-25
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   web浏览报告获取js信息
/// Table：       
/// Input：        exam.id
/// Output：       script内容
/// w ##class(web.DHCEkgWebServiceNew).getJSInfo("139")
ClassMethod getJSInfo(ExamId) As %GlobalCharacterStream [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getJSInfo",$zd($h,3),$zt($p($h,",",2),1),ExamId,"params")
	s rtn=##class(web.DHCEkg.WebReportService).getJSInfo(ExamId)
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getJSInfo",$zd($h,3),$zt($p($h,",",2),1),rtn,"rtn")
	q rtn
}

/// Creator：      yangyali
/// CreatDate：    2020-2-25
/// ModifyDate：   
/// ModifyDesc：   
/// Description:   web浏览报告获取js信息
/// Table：       东营二院旧接口
/// Input：        
/// Output：       
/// w ##class(web.DHCEkgWebServiceNew).getJSInfo("139")
ClassMethod DHCEkgRegPatDoEx(ExamId, param1, param2) As %String [ WebMethod ]
{
	q "0"
}

/// 创建者：	杨亚莉
/// 创建日期：	2020-9-18
/// 方法说明：	调用dhc-ekg中的方法
/// 入参：		类名，方法名，入参字符串
/// 				方法入参规定：
/// 							参数1：方法所需的参数，多个参数以^间隔组合为一个字符串
/// 							参数2：调用是否成功：-1:不成功；0:成功
/// 返回值：	调用方法的返回值
/// w ##class(web.DHCEkgWebServiceNew).getData4String("web.DHCEkgService","RevokeExam","501^739")
ClassMethod getData4String(className As %String, methodName As %String, param As %String) As %String [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getData4String",$zd($h,3),$zt($p($h,",",2),1),className_","_methodName_","_param,"param")
	set obj=##class(%Dictionary.CompiledMethod).%OpenId(className_"||"_methodName,0)
	if ($IsObject(obj))
	{
		set result=$CLASSMETHOD(className,methodName,param,.InvokeResult)
		
		Quit InvokeResult
	}
	else
	{
		quit "failed^方法不存在"
	}
}

/// 创建者：	杨亚莉
/// 创建日期：	2020-9-18
/// 方法说明：	调用dhc-ekg中的方法
/// 入参：		类名，方法名，入参字符串
/// 				方法入参规定：
/// 							参数1：方法所需的参数，多个参数以^间隔组合为一个字符串
/// 							参数2：调用是否成功：-1:不成功；0:成功
/// 返回值：	调用方法的返回值(流类型)
/// w ##class(web.DHCEkgWebServiceNew).getData4Stream("EKGService.Method.GetEKGInfo","GetExamId","85^350;RegNo^^^常规心电图检查(12导联);心电图阿托品试验;心电图心得安试验;常规心电图检查(18导联);电脑多导联心电图^^")
ClassMethod getData4Stream(className As %String, methodName As %String, param As %String) As %GlobalCharacterStream [ WebMethod ]
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgWebServiceNew","getData4Stream",$zd($h,3),$zt($p($h,",",2),1),className_","_methodName_","_param,"param")
	set obj=##class(%Dictionary.CompiledMethod).%OpenId(className_"||"_methodName,0)
	if ($IsObject(obj))
	{
		set result=$CLASSMETHOD(className,methodName,param,.InvokeResult)
		
		Quit InvokeResult
	}
	else
	{
		s rtn=##class(%GlobalCharacterStream).%New()
		d rtn.Write("failed^方法不存在")
		quit InvokeResult
	}
}

///  Description:： 获取所有病区代码集合
///  w ##class(web.DHCEkgWebServiceNew).GetCTZoneList()
ClassMethod GetCTZoneList() As %String [ WebMethod ]
{
	s return=##class(web.DHCEkgService).GetCTZoneList()
	q return
}

/// GetHisUserList
/// Creator：      yangyali
/// CreatDate：    2022-10-14
/// Description:： 获取his所有用户的信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       用户信息的json串，包含用户工号、姓名、医护人员类型、默认登录科室、可登录科室信息
/// Others：s stream= ##class(web.DHCEkgWebServiceNew).GetHisUserList()
ClassMethod GetHisUserList() As %GlobalCharacterStream [ WebMethod ]
{
	s rtn=##class(web.DHCEkgService).GetHisUserList()
	q rtn
}

/// GetHisDeptList
/// Creator：      yangyali
/// CreatDate：    2022-11-29
/// Description:： 获取his所有科室的信息
/// Table：        
/// Input：        
/// Output：       
/// Return：       科室信息的json串
/// Others：s stream= ##class(web.DHCEkgService).GetHisDeptList()
ClassMethod GetHisDeptList() As %GlobalCharacterStream [ WebMethod ]
{
	s rtn=##class(web.DHCEkgService).GetHisDeptList()
	q rtn
}

}
