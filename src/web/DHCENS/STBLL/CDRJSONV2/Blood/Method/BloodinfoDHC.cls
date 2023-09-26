Class web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoDHC Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取输血申请表(ACC0033)  DHC_BldApplicationForm
/// Table：DHC_BldApplicationForm
/// Input：BDReqFormid：输血申请单表id
/// Output：
/// Return：数据中心pa_bloodtransapp患者输血申请表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoDHC).BloodInfo("1")
ClassMethod BloodInfo(BDReqFormid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	if (BDReqFormid="")||($d(^DHCBLDAPPFORM(BDReqFormid))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..getDHCBldApplicationForm(BDReqFormid)   //取DHC_BldApplicationForm表
	d obj.pabloodtransappList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	quit stream
Exception
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
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoDHC).BloodGlobal("1","20")
ClassMethod BloodGlobal(stradmRowId As %String, endadmRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("pabloodtransapp")=$lb("院内输血申请id","申请类型","abo血型","rh血型","申请科室代码","申请科室描述",
												"抗体筛查","品种","用血模式","申请医生工号","申请医生姓名",
												"血量","申请日期时间","用血日期时间","输血反应日期时间",
												"输血反应","备注","输血目的","输血史",
												"妊娠史","时间戳","时间戳","全局患者id","全局就诊id","申请单状态描述")
	set BDReqFormid="",con=0,strtime=$zt($p($now(),",",2))
	for BDReqFormid=stradmRowId:1:endadmRowId
	{
		continue:$d(^DHCBLDAPPFORM(BDReqFormid))=0 
		set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
		set subObj=..getDHCBldApplicationForm(BDReqFormid) //取DHC_BldApplicationForm表
		set ^ExportHistoryData("pabloodtransapp",BDReqFormid)=$lb(BDReqFormid,subObj.pabtaapptypedesc,subObj.pabtaabo,subObj.pabtarh,subObj.pabtaappdeptcode,
															subObj.pabtaappdeptdesc,subObj.pabtaantibodyscreening,subObj.pabtabloodvariety,subObj.pabtabloodmode,subObj.pabtaappdoccode,
															subObj.pabtaappdocname,,subObj.pabtaappdatetime,subObj.pabtabloodusedatetime,subObj.pabtabloodreactdatetime,
															subObj.pabtabloodreaction,subObj.pabtabloodtransremarks,subObj.pabtabloodpurpose,subObj.pabtabloodtranshistory,subObj.pabtapregnancyhistory,
															subObj.updatedate,subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.pabtaappstatusdesc,
															subObj.businessfieldcode)
		set con=con+1
		if con#100=0 w !,con_"   "_BDReqFormid
		}
	
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod getDHCBldApplicationForm(BDReqFormid As %String) As web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	s bloodInfo=##Class(LIS.BLD.BT.REQ.Request).Bind(BDReqFormid,"","",1)
	quit:bloodInfo="" subObj
	set pabtahosappid=$p(bloodInfo,$c(2),1)
	set bloodapptype=$p(bloodInfo,$c(2),4)
	set abo=$p(bloodInfo,$c(2),23)
	set rh=$p(bloodInfo,$c(2),24)
	set patientInfo=$p(bloodInfo,$c(2),43)
	set appdeptcode=$p(patientInfo,$c(3),37)
	set appdeptdesc=$p(patientInfo,$c(3),37)
	set bloodComponents=$p(bloodInfo,$c(2),71)
	set bloodmode=$p($p(bloodInfo,$c(2),6)," ",1)
	set appdoccode=$p(bloodInfo,$c(2),72)
	set appdocname=$p(bloodInfo,$c(2),73)
	set bloodvolume=$p(bloodInfo,$c(2),13)
	set appdatetime=$p(bloodInfo,$c(2),81)			
	set pabtabloodvariety="",bloodvolume=""
	set ordInfos=$p(bloodInfo,$c(2),64)
	set len=$l(ordInfos,$c(4))
	for i=1:1:len-1 {
		set ordInfo=$p(ordInfos,$c(4),i)
		set ordName=$p(ordInfo,$c(3),4)
		set ordNum=$p(ordInfo,$c(3),10)
		set ordUnit=$p(ordInfo,$c(3),11)
		if pabtabloodvariety'=""{
			set pabtabloodvariety=pabtabloodvariety_";"_ordName
		}else{
			set pabtabloodvariety=ordName
		}	
		set ord=ordNum_"\"_ordUnit
		if bloodvolume'=""{
			set bloodvolume=bloodvolume_";"_ord
		}else{
			set bloodvolume=ord
		}
	}
	set bloodusedatetime=$p(bloodInfo,$c(2),10)
	set bloodreactdatetime=""
	set bloodreaction=$p(bloodInfo,$c(2),26)
	set bloodreaction=$case(bloodreaction,"1":"有",:"无")
	set bloodtransremarks=$p(bloodInfo,$c(2),19)
	set bloodpurpose=$p(bloodInfo,$c(2),87)
	set bloodpurpose=$Replace($Replace(bloodpurpose,$c(3),","),$c(4),";")
	set bloodtranshistory=$p(bloodInfo,$c(2),88)
	set AdmId=$p(patientInfo,$c(3),18)
	set appstatusdesc=$p(bloodInfo,$c(2),21)
	set patmasId=$p(patientInfo,$c(3),17)
	if +AdmId'=0 set patmasId=$P($g(^PAADM(AdmId)),"^",1)
	set patID=$p($g(^PAPER(patmasId,"PAT",1)),"^",1)
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                  //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patID    //全局患者id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmId      //全局就诊id
	set subObj.pabtahosappid=pabtahosappid                         //院内输血申请id
	set subObj.pabtarelappid=businessfieldcode_"_"_pabtahosappid    //全局输血申请id
	set subObj.updatedate=$zd(+$h,3)                                //时间戳
	set subObj.updatetime=$zt($p($h,",",2))                         //时间戳
	set subObj.pabtaapptypedesc=bloodapptype  //申请类型
	set subObj.pabtaabo=abo  //abo血型
	set subObj.pabtarh=rh	 //rh血型
	set subObj.pabtaappdeptcode=appdeptcode //申请科室代码
	set subObj.pabtaappdeptdesc=appdeptdesc //申请科室描述
	set:bloodvolume="" bloodvolume="未填"
	set subObj.pabtabloodvolume=bloodvolume
	set subObj.pabtabloodpurpose=bloodpurpose
	set subObj.pabtaappdoccode=appdoccode  //申请医生工号
	set subObj.pabtaappdocname=appdocname  //申请医生姓名
	set subObj.pabtaappdatetime=appdatetime  //申请日期时间
	set subObj.pabtabloodusedatetime=bloodusedatetime  //预定用血日期时间
	set subObj.pabtabloodtranshistory=bloodtranshistory   //输血史
	set subObj.pabtapregnancyhistory="无"     //妊娠史
	set subObj.pabtaappstatusdesc=appstatusdesc
	set subObj.pabtaantibodyscreening="未填"  //取最后一个血袋的最后一次配血计划的抗体筛查结果
	set subObj.pabtabloodreactdatetime="未填"  //输血反应日期时间
	set subObj.pabtabloodreaction=bloodreaction	//输血反应
	set subObj.pabtabloodmode=bloodmode //用血模式(输血方式 N异体，A自体)
	set subObj.pabtabloodtransremarks=bloodtransremarks    //备注
	set subObj.pabtabloodvariety=pabtabloodvariety	//品种类型
	quit subObj
}

}
