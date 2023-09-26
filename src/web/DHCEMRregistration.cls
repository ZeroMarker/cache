/// Descript:   登记本
/// Creator:    huaxiaoying
/// CreateDate: 2018-07-19
Class web.DHCEMRregistration Extends %RegisteredObject
{

Query RregisterQuery(stDate, edDate) As %Query(ROWSPEC = "PatCardNo:%String,CardType:%String,Regno:%String,Name:%String,Birth:%String,Age:%String,Sex:%String,PatNation:%String,PatCountry:%String,PatIdNo:%String,Tel:%String,Address:%String,RegDate:%String,EmAgainFlag:%String,EmBatchFlag:%String,EmBatchNum:%String,EmPatChkType:%String,EmPatChkHis:%String,EmPatSource:%String,EmPatAdmWay:%String,SixSick:%String,Measure:%String,EmAware:%String,EmPoisonFlag:%String,EmOxygenFlag:%String,EmScreenFlag:%String,EmCombFlag:%String,EmECGFlag:%String,EmHisDrug:%String,EmMaterial:%String,EmPatChkSign:%String:%String,EmPain:%String,AisDataStr:%String,GCSDataStr:%String,Notes:%String,EmSymDesc:%String,EmOtherDesc:%String,EmRecLevel:%String,EmUpdLevRe:%String,NurseLevel:%String,Area:%String,EmLoc:%String,EmPatChkCare:%String,EmWard:%String,EmPatGreFlag:%String,UserName:%String") [ SqlProc ]
{
}

ClassMethod RregisterQueryExecute(ByRef qHandle As %Binary, stDate, edDate) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMRregistration","RregisterQuery","2018-11-26","2018-11-26")
 	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1
	
  	//编码开始
  	
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	s num=0                 																//这里是通过分诊表来查找
	f Date=stDate:1:edDate  d 
	.s EmPCLvID = 0
	.f  s EmPCLvID = $o(^DHCEMPCL(0,"CreateDate",Date,EmPCLvID)) q:EmPCLvID=""  d
	..s PAPMIDr=$p(^DHCEMPCL(EmPCLvID),"^",1)      /// 病人ID Pa_PatMas PAPMIDr PatientID
	..q:'$d(^PAPER(PAPMIDr))            ///QQA 2017-08-22 过滤错误数据
	..Q:$d(^PAPER(PAPMIDr))=0 
    ..
    ..s PatCardNo="",CardType="",Regno="",Name="",Birth="",Age="",Sex="",PatIdNo="",Tel="",Address=""
	..s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDr,""),-1)
	..s PatCardNo=""
	..s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) /// 卡号
	..s CardTypeID=""
	..s:CardNoID'="" CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 
	..s CardType=""
	..s:CardTypeID'="" CardType=$p(^DHCCARDTYPEDef(CardTypeID),"^", 2) /// 卡类型
	..s Regno=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)	   /// 病人登记号	
	..s Name=$p(^PAPER(PAPMIDr,"ALL"),"^",1)    /// 病人姓名
	..s Birth=$p($g(^PAPER(PAPMIDr,"ALL")),"^",6) //出生日期
	..s Birth=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Birth) //
	..s Age= ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(EmPCLvID)  /// 年龄:根据病人ID
	..s sexId=$p(^PAPER(PAPMIDr,"ALL"),"^",7)      /// 性别
	..i sexId'="" s Sex=$p(^CT("SEX",sexId),"^",2)
	..s PatNation=""
	..s nationdr=$p($g(^PAPER(PAPMIDr,"PER",2)),"^",1)  /// 民族
	..i nationdr'="" s PatNation=$p(^CT("NAT",nationdr),"^",2)
	..s PatCountry=""
	..s PatCyID=$p(^PAPER(PAPMIDr,"PER",1),"^",8) 	    
	..i PatCyID'="" s PatCountry=$p(^CT("COU",PatCyID),"^",2) ///国籍
	..s PatIdNo=$p(^PAPER(PAPMIDr,"ALL"),"^",9)         /// 身份证号//身份证号
	..s Tel=$p(^PAPER(PAPMIDr,"PER",1),"^",11) 	    /// 电话 
	..s Address=$g(^PAPER(PAPMIDr,"PER","ADD",1)) 	    /// 家庭住址
	..s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PAPMIDr,""),-1)          /// 登记ID
    ..s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记日期
	..s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)  /// 登记时间
	..s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) 
	..s:EmRegTime'="" EmRegTime=$zt(EmRegTime,2)
	..s RegDate=EmRegDate_" "_EmRegTime //来诊时间
	..s UserName="" //2018-08-07 分诊护士
	..s UserID=$p(^DHCEMPCL(EmPCLvID),"^",3)  		/// 分诊人员
	..i UserID'="" s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s EmRecLevel=$p(^DHCEMPCL(EmPCLvID),"^",6)  /// 推荐分级
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",1:"")
	..s NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)  /// 护士分级
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",1:"")
	..;q:+NurseLevel=0
	..s EmUpdLevRe=$p(^DHCEMPCL(EmPCLvID),"^",8)  /// 护士更改分级原因
	..;i (EmUpdLevRe'="")&&(EmUpdLevRe'=0)  //hxy 2018-08-05 (EmUpdLevRe'=0)
	..s:EmUpdLevRe'="" EmUpdLevRe=$p($g(^DHCEMDUR(EmUpdLevRe)),"^",2)
	..s Area=$p(^DHCEMPCL(EmPCLvID),"^",9)  		/// 去向分区
	..s Area=$s(Area=1:"红区",Area=2:"红区",Area=3:"黄区",Area=4:"绿区",1:"")
	..s EmLocID=$p(^DHCEMPCL(EmPCLvID),"^",10) 	/// 分诊科室
	..s EmAgainFlag=$p(^DHCEMPCL(EmPCLvID),"^",11) 	/// 重返标识
	..s EmBatchFlag=$p(^DHCEMPCL(EmPCLvID),"^",12) 	/// 成批就诊
	..s EmBatchNum=$p(^DHCEMPCL(EmPCLvID),"^",13) 	/// 成批就诊人数
	..s EmPatSource=$p(^DHCEMPCL(EmPCLvID),"^",15) 	/// 病人来源
	..i EmPatSource'="" s EmPatSource=$p(^DHCEMPSO(EmPatSource),"^",2) 
	..s EmPatAdmWay=$p(^DHCEMPCL(EmPCLvID),"^",16) 	/// 来诊方式
	..i EmPatAdmWay'="" s EmPatAdmWay=$p(^DHCEMPADW(EmPatAdmWay),"^",2)
	
	..s EmAware=$p(^DHCEMPCL(EmPCLvID),"^",17) 	    /// 意识状态
	..i EmAware'="" s EmAware=$p($g(^DHCEMPAW(EmAware)),"^",2) 	
	..s EmScreenFlag=$p(^DHCEMPCL(EmPCLvID),"^",18) 	/// 筛查
	..i EmScreenFlag=1 s EmScreenFlag="发热"
	..i EmScreenFlag=2 s EmScreenFlag="肠道"
	..s EmHisDrug=$p(^DHCEMPCL(EmPCLvID),"^",19) 	    /// 用药情况
	..s EmHisDrugDesc=$p(^DHCEMPCL(EmPCLvID),"^",20) 	/// 用药情况描述
	..s EmHisDrug=EmHisDrug_"  "_EmHisDrugDesc ///用药情况
	..s EmMaterial=$p(^DHCEMPCL(EmPCLvID),"^",21) 	/// 辅助物
	..s EmMaterialDesc=$p(^DHCEMPCL(EmPCLvID),"^",22) /// 辅助物描述
	..s EmMaterial=EmMaterial_"  "_EmMaterialDesc ///辅助物
	..s EmCombFlag=$p(^DHCEMPCL(EmPCLvID),"^",26) 	/// 复合伤
	..s EmECGFlag=$p(^DHCEMPCL(EmPCLvID),"^",27) 	    /// ECG
	..s EmPoisonFlag=$p(^DHCEMPCL(EmPCLvID),"^",28)   /// 中毒
	..
	..s EmPainFlag=$p(^DHCEMPCL(EmPCLvID),"^",29) 	/// 疼痛
	..s EmPainLev=$p(^DHCEMPCL(EmPCLvID),"^",30) 	    /// 疼痛分级
	..s EmPainRange=$p(^DHCEMPCL(EmPCLvID),"^",31) 	/// 疼痛范围
	..s EmPainRangeDesc=$s(EmPainRange="1":"中枢",EmPainRange="2":"外周",1:"")
	..s EmPainDate=$p(^DHCEMPCL(EmPCLvID),"^",32) 	/// 疼痛日期
	..s:EmPainDate'="" EmPainDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmPainDate) //$zd(EmPainDate,3)
	..s EmPainTime=$p(^DHCEMPCL(EmPCLvID),"^",33) 	/// 疼痛时间
	..s:EmPainTime'="" EmPainTime=$zt(EmPainTime,2)
	..s:EmPainDate'="" EmPainTime=EmPainDate_" "_EmPainTime
	..s EmPain=EmPainFlag_"  疼痛范围:"_EmPainRangeDesc_",疼痛时间:"_EmPainTime_",疼痛分级:"_EmPainLev
	..i EmPainLev="" s EmPain="" //2018-07-21
	..
	..s EmOxygenFlag=$p(^DHCEMPCL(EmPCLvID),"^",34)   /// 吸氧
	..s EmPatAskFlag=$p(^DHCEMPCL(EmPCLvID),"^",35) 	/// 请假
	..s EmOtherDesc=$p(^DHCEMPCL(EmPCLvID),"^",36) 	/// 其它
	..s EmSymDescStr=$p(^DHCEMPCL(EmPCLvID),"^",25) 	    /// 症状 / 主诉
	..s EmSymDesc=""
	..s EmSymDesc=##Class(web.DHCEMECheck).GetSymDesc(EmPCLvID)
	..s EmSymDesc=$tr(EmSymDesc,"!","")
	..s EmSymDesc=$tr(EmSymDesc,"#",",")
	..s PCLOther=$p(^DHCEMPCL(EmPCLvID),"^",36)       //其他 2016-09-13 congyue
	..s:EmSymDesc'="" EmSymDesc=EmSymDesc_";"
	..s EmSymDesc=EmSymDesc_""_PCLOther 			  //其他 2016-09-13 congyue
	..s EmPatChkType=$p(^DHCEMPCL(EmPCLvID),"^",40) 	/// 特殊人群
	..i EmPatChkType'="" s EmPatChkType=$p(^DHCEMPT(EmPatChkType),"^",2)
	..s EmToLocID=$p(^DHCEMPCL(EmPCLvID),"^",41) 		/// 转向科室 2016-09-09 congyue
	..s EmLocID=""									/// 分诊科室 
	..s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",EmPCLvID,""))
	..i EmPccID'="" s EmLocID=$p(^DHCEMPCC(EmPccID),"^",3) 
	..i EmLocID'="" s EmLoc=$p(^CTLOC(EmLocID),"^",2) /// 分诊科室 
	..s EmPatChkHis=""
	..s EmPatChkHisStr= ##class(web.DHCEMPatCheckLevQuery).GetEmPatChkLvHis(EmPCLvID)		/// 既往史
	..s len=$l(EmPatChkHisStr,"#")
	..for i=1:1:len d
  	...s str=$p(EmPatChkHisStr,"#",i)
  	...q:str=""
  	...s PatChkHis=$p(^DHCEMPHI(str),"^",2)
  	...i i=1 s EmPatChkHis=EmPatChkHis_PatChkHis
  	...i i>1 s EmPatChkHis=EmPatChkHis_","_PatChkHis
	..s EmPatChkSignStr=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSign(EmPCLvID)      /// 生命体征
	..;s EmPatChkSign="时间 "_$p(EmPatChkSignStr,"@",1)_" ; " //hxy 2018-08-07
    ..;s EmPatChkSign=EmPatChkSign_"T "_$p(EmPatChkSignStr,"@",2)_" (℃); "
    ..s EmPatChkSign="T "_$p(EmPatChkSignStr,"@",2)_" (℃); " //hxy 2018-08-07
    ..s EmPatChkSign=EmPatChkSign_"HR "_$p(EmPatChkSignStr,"@",3)_" (次/分); "
    ..s EmPatChkSign=EmPatChkSign_"P "_$p(EmPatChkSignStr,"@",4)_" (次/分); "
    ..s EmPatChkSign=EmPatChkSign_"BP "_$p(EmPatChkSignStr,"@",5)_"/"_$p(EmPatChkSignStr,"@",6)_"(mmHg); "
    ..s EmPatChkSign=EmPatChkSign_"SPO2 "_$p(EmPatChkSignStr,"@",7)_" (%); "
    ..s EmPatChkSign=EmPatChkSign_"R "_$p(EmPatChkSignStr,"@",8)_" (次/分) "
	..s EmPatChkCare=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkCare(EmPCLvID)      /// 预检号别表
	..s EmPatChkCare=$p(EmPatChkCare,"@",2)

	..S AisDataStr = ##class(web.DHCEMPatCheckLevQuery).GetAisData(EmPCLvID)       	/// 创伤分级
	..S GCSDataStr = ##class(web.DHCEMPatCheckLevQuery).GetGCSData(EmPCLvID)    		/// 格拉斯哥
	..S GcsFlag = $p(^DHCEMPCL(EmPCLvID),"^",45)		/// 格拉斯哥标注
	..S AisFlag = $p(^DHCEMPCL(EmPCLvID),"^",46)      /// 创伤评分标注
	
	..s SixSickStr = ##class(web.DHCEMPatCheckLevQuery).GetSixSick(EmPCLvID) //六大病种 
	..s len=$l(SixSickStr,"#")
	..for i=1:1:len d
  	...s str=$p(SixSickStr,"#",i)
  	...q:str=""
  	...s Six=$p(^DHCEMSPD(str),"^",2)
  	...i i=1 s SixSick=EmPatChkHis_Six
  	...i i>1 s SixSick=EmPatChkHis_","_Six
	..s EmWoundedFlag="" ;##class(web.DHCEMPatCheckLevQuery).GetEmPatChkHisMoreObsAG(EmPCLvID) ///批量伤 hxy 2018-06-19
	..s MeasureStr="" ;##class(web.DHCEMPatCheckLevQuery).GetEmPatChkHisMoreS(EmPCLvID,"处理措施") ///处理措施 hxy 2018-07-21
	..s Measure="",PatMeasure=""
	..s len=$l(MeasureStr,"#")
	..for i=1:1:len d
  	...s str=$p(MeasureStr,"#",i)
  	...s PatMeasure=""
  	...i i=1 s Measure=Measure_PatMeasure
  	...i i>1 s Measure=Measure_","_PatMeasure
	..s Notes=$p(^DHCEMPCL(EmPCLvID),"^",56) ///备注 hxy 2018-07-21
	..
	..s EmPatAdm=##Class(web.DHCEMPatCheckLev).GetEmPatCheckLvAdm(EmPCLvID)   	/// 预检就诊ID  2017-02-28 bianshuai
	..s EpisodeID=+EmPatAdm
	..s EmWardID=$p(^DHCEMPCL(EmPCLvID),"^",47)         /// 病区
    ..i EmWardID'="" s EmWard=$p($g(^PAWARD(EmWardID)),"^",2)
    ..s EmPatGreFlag=""
    ..s:EpisodeID'=0 EmPatGreFlag=$p(^PAADM(EpisodeID),"^",5) ;##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(EmPCLvID,"") /// 绿色通道 2017-02-28 bianshuai
	..s:EpisodeID=0 EmPatGreFlag=""
	..s:EmPatGreFlag'=1 EmPatGreFlag=""
	..s:EmPatGreFlag=1 EmPatGreFlag="绿色通道"
    ..s num=num+1
    ..d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PatCardNo,CardType,Regno,Name,Birth,Age,Sex,PatNation,PatCountry,PatIdNo,
	Tel,Address,RegDate,EmAgainFlag,EmBatchFlag,EmBatchNum,EmPatChkType,EmPatChkHis,EmPatSource,EmPatAdmWay,
	SixSick,Measure,EmAware,EmPoisonFlag,EmOxygenFlag,EmScreenFlag,EmCombFlag,EmECGFlag,EmHisDrug,EmMaterial,
	EmPatChkSign,EmPain,AisDataStr,GCSDataStr,Notes,EmSymDesc,EmOtherDesc,EmRecLevel,EmUpdLevRe,NurseLevel,
	Area,EmLoc,EmPatChkCare,EmWard,EmPatGreFlag,UserName
    )
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RregisterQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RregisterQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RregisterQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RregistertQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

}
