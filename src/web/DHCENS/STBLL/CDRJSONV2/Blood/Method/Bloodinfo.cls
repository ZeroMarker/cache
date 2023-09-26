Class web.DHCENS.STBLL.CDRJSONV2.Blood.Method.Bloodinfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取输血申请表(ACC0033)
/// Table：BD_ReqForm表rowid
/// Input：BDReqFormid：输血申请单表id
/// Output：
/// Return：数据中心pa_bloodtransapp患者输血申请表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.Bloodinfo).BloodInfo("63373")
ClassMethod BloodInfo(BDReqFormid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	if (BDReqFormid="")||($d(^dbo.BDReqFormD(BDReqFormid))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..getbloodtransapp(BDReqFormid)   //取BD_ReqForm表
	d obj.pabloodtransappList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
	b ;2
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""theme"":""theme001"",""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取输血申请表(ACC0033)历史数据
/// Table：BD_ReqForm表rowid
/// Input：BDReqFormid：输血申请单表id
/// Output：
/// Return：数据中心pa_bloodtransapp患者输血申请表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.Bloodinfo).BloodGlobal("1","2635460")
ClassMethod BloodGlobal(stradmRowId As %String, endadmRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("pabloodtransapp")=$lb("院内输血申请id","申请类型","abo血型","rh血型","申请科室代码","申请科室描述","抗体筛查","品种","用血模式",
													"申请医生工号","申请医生姓名","血量","申请日期时间","用血日期时间","输血反应日期时间",
													"输血反应","备注","输血目的","输血史","妊娠史",
													"时间戳","时间戳","全局患者id","全局就诊id","申请单状态描述")
	set BDReqFormid="",con=0,strtime=$zt($p($now(),",",2))
	for BDReqFormid=stradmRowId:1:endadmRowId{
		continue:$d(^dbo.BDReqFormD(BDReqFormid))=0
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
		set subObj=..getbloodtransapp(BDReqFormid)
		set ^ExportHistoryData("pabloodtransapp",BDReqFormid)=$lb(BDReqFormid,subObj.pabtaapptypedesc,subObj.pabtaabo,subObj.pabtarh,subObj.pabtaappdeptcode,
																subObj.pabtaappdeptdesc,subObj.pabtaantibodyscreening,subObj.pabtabloodvariety,subObj.pabtabloodmode,subObj.pabtaappdoccode,
																subObj.pabtaappdocname,subObj.pabtabloodvolume,subObj.pabtaappdatetime,subObj.pabtabloodusedatetime,subObj.pabtabloodreactdatetime,
																subObj.pabtabloodreaction,subObj.pabtabloodtransremarks,subObj.pabtabloodpurpose,subObj.pabtabloodtranshistory,subObj.pabtapregnancyhistory,
																subObj.updatedate,subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.pabtaappstatusdesc,
																subObj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, BDReqFormid)		
		}
	
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod getbloodtransapp(BDReqFormid) As web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp
{
	try{
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
		set AdmId=$lg(^dbo.BDReqFormD(BDReqFormid),4)
		set patmasId=$P($g(^PAADM(AdmId)),"^",1)
		set businessfieldcode=subObj.businessfieldcode
		set subObj.businessfieldcode=businessfieldcode                  //业务域
		set subObj.papatrelpatientid=businessfieldcode_"_"_patmasId     //全局患者id
		set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmId      //全局就诊id
		set subObj.pabtahosappid=BDReqFormid                            //院内输血申请id
		set subObj.pabtarelappid=businessfieldcode_"_"_BDReqFormid       //全局输血申请id
		set subObj.updatedate=$zd(+$h,3)                                //时间戳
		set subObj.updatetime=$zt($p($h,",",2))                         //时间戳
		set ReqTypeDR=$lg(^dbo.BDReqFormD(BDReqFormid),3)
		set:ReqTypeDR'="" subObj.pabtaapptypedesc=$lg(^dbo.BBReqTypeD(ReqTypeDR),3)  //申请类型
		set ABODR=$lg(^dbo.BDReqFormD(BDReqFormid),18)
		set:ABODR'="" subObj.pabtaabo= $lg(^dbo.BTABOBGD(ABODR),3)   //abo血型
		set RHDR=$lg(^dbo.BDReqFormD(BDReqFormid),19)
		set:RHDR'="" subObj.pabtarh=$lg(^dbo.BTRHBGD(RHDR),3)        //rh血型
		set LocationDR=$lg(^dbo.BDReqFormD(BDReqFormid),23)
	#;	set:LocationDR'="" subObj.pabtaappdeptcode=$p($g(^CTLOC(LocationDR)),"^",1) //申请科室代码
		set subObj.pabtaappdeptcode=LocationDR
		set:LocationDR'="" subObj.pabtaappdeptdesc=$p($g(^CTLOC(LocationDR)),"^",2) //申请科室描述
		set ReqProductDR="" ,variety="",volume="",volumestr="",PurposeDR=""
		///血制品品质 数量单位，目的用 ;拼起来 （血制品1;血制品2;血制品3）（数量1 单位1;数量2 单位2;数量3 单位3）（目的1;目的2;目的3）
		for {
			set ReqProductDR=$o(^dbo.BDReqFormProductI("IndexMaster",BDReqFormid,ReqProductDR))
			q:ReqProductDR=""
			set reqproid=""
			for {
				set reqproid=$o(^dbo.BDReqFormProductI("IndexMaster",BDReqFormid,ReqProductDR,reqproid)) 
				q:reqproid=""
				set PurposeDR=$lg(^dbo.BDReqFormProductD(reqproid),4)
				set volume = $lg(^dbo.BDReqFormProductD(reqproid),5)
				set Unit=$lg(^dbo.BDReqFormProductD(reqproid),6)
				if variety=""{
					set variety=$lg(^dbo.BBReqProductD(ReqProductDR),3)
					set volumestr=volume_" "_Unit
					set Purpose=$lg(^dbo.BBPurposeD(PurposeDR),3)
					}
				else {	
					set variety=variety_";"_$lg(^dbo.BBReqProductD(ReqProductDR),3)
					set volumestr=volumestr_";"_volume_" "_Unit
					set Purpose=Purpose_";"_$lg(^dbo.BBPurposeD(PurposeDR),3)
					}
				}
			}
		set subObj.pabtabloodvariety=variety
		set subObj.pabtabloodvolume=volumestr
		set subObj.pabtabloodpurpose=Purpose
		set AddUserDR=$lg(^dbo.BDReqFormD(BDReqFormid),7)
		set subObj.pabtaappdoccode=AddUserDR
		set:AddUserDR'="" subObj.pabtaappdocname=$lg(^dbo.SYSUserD(AddUserDR),3)  //申请医生姓名
		set AddDate=$lg(^dbo.BDReqFormD(BDReqFormid),5)
		set AddTime=$lg(^dbo.BDReqFormD(BDReqFormid),6)
		set:((AddDate'="")&&(AddTime'="")) subObj.pabtaappdatetime=$zd($zdh(AddDate,8),3)_" "_$zt(AddTime)  //申请日期时间
		set BookDate=$lg(^dbo.BDReqFormD(BDReqFormid),40)
		set:((BookDate'="")&&($l(BookDate)=8)) subObj.pabtabloodusedatetime=$zd($zdh(BookDate,8),3)   //预定用血日期时间
		set:((BookDate'="")&&($l(BookDate)=5)) subObj.pabtabloodusedatetime=$zd(BookDate,3)   //预定用血日期时间
		set subObj.pabtabloodtranshistory=$lg(^dbo.BDReqFormD(BDReqFormid),27)    //输血史
		set subObj.pabtapregnancyhistory=$lg(^dbo.BDReqFormD(BDReqFormid),37)     //妊娠史
		set pabtaappstatusdesc=$lg(^dbo.BDReqFormD(BDReqFormid),51)      
		set:pabtaappstatusdesc'="" subObj.pabtaappstatusdesc=$case(pabtaappstatusdesc,10:"待审",15:"作废",20:"医务科待审核",25:"审核",30:"拒审",35:"接收",40:"拒收",:"其他") //申请单状态描述
		set PackDR=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormid,""),-1)
		if PackDR'=""{
			set XMPid=$o(^dbo.BDXMPlanI("IndexMaster",BDReqFormid,PackDR,""),-1)
			set:XMPid'="" subObj.pabtaantibodyscreening=$lg(^dbo.BDXMPlanD(XMPid),36)   //取最后一个血袋的最后一次配血计划的抗体筛查结果
			set PackScoutid=$o(^dbo.BDPackScoutI("IndexPack",PackDR,""),-1)             //取最后一个血袋的最后一次输血巡视
			if PackScoutid'="" {        
			set ScoutDate=$lg(^dbo.BDPackScoutD(PackScoutid),3)
			set ScoutTime=$lg(^dbo.BDPackScoutD(PackScoutid),4)
			set:((ScoutDate'="")&&(ScoutTime'="")) subObj.pabtabloodreactdatetime=$zd($zdh(ScoutDate,8),3)_" "_$zt(ScoutTime)  //输血反应日期时间
			set subObj.pabtabloodreaction=$lg(^dbo.BDPackScoutD(PackScoutid),13)	//输血反应
			}
		}
		set AgreeFormNo=$lg(^dbo.BDReqFormD(BDReqFormid),48)  
		if AgreeFormNo'=""{
			set AgreeFormid=$o(^dbo.BDAgreeFormI("IndexAgreeFormNo",AgreeFormNo,""),-1)
			if AgreeFormid'="" {
				set pabtabloodmode=$lg(^dbo.BDAgreeFormD(AgreeFormid),29)           
				set:pabtabloodmode'="" subObj.pabtabloodmode=$case(pabtabloodmode,"A":"自体","N":"异体") //用血模式(输血方式 N异体，A自体)
				} 
			}
		set subObj.pabtabloodtransremarks=""    //备注
	}
	catch
	{
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	}
	quit subObj
}

}
