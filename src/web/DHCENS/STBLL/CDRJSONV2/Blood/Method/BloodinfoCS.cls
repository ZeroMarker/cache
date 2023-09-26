Class web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoCS Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-25
/// Description：根据id取输血申请表(ACC0033)
/// Table：
/// Input：BDReqFormid：输血申请单表id
/// Output：
/// Return：数据中心pa_bloodtransapp患者输血申请表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoDHC).BloodInfoByBloodInfo("1")
ClassMethod BloodInfoByBloodInfo(BDReqFormid As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.Data).%New()
	set obj.theme="theme001"
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	if (BDReqFormid="")||($d(^dbo.BDReqFormD(BDReqFormid))=0) {
		d stream.Write("{""theme"":""theme001"",""data"":[]}")
		quit stream	
	}
	set subObj=..getbloodtransappcs(BDReqFormid)  // cs BDReqFormid 为 登记号||序号
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
/// Description：根据id取输血申请表(ACC0033)历史数据CS版
/// Table：^DHCBldReques
/// Input：登记号
/// Output：
/// Return：数据中心pa_bloodtransapp患者输血申请表(Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Method.BloodinfoDHC).BloodInfoGlobalcs("1","20")
ClassMethod BloodInfoGlobalcs(stradmRowId As %String, endadmRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set ^ExportHistoryData("pabloodtransapp")=$lb("院内输血申请id","申请类型","abo血型","rh血型","申请科室代码","申请科室描述","抗体筛查","品种","用血模式","申请医生工号","申请医生姓名","血量","申请日期时间","用血日期时间","输血反应日期时间","输血反应","备注","输血目的","输血史","妊娠史","时间戳","时间戳","全局患者id","全局就诊id","申请单状态描述")
	if (stradmRowId="")||(endadmRowId="") {
		quit "-1^id不能为空"
	}
	set BDReqFormid="",con=0,strtime=$zt($p($now(),",",2))
	set sum=endadmRowId-stradmRowId+1
	for BDReqFormid=stradmRowId:1:endadmRowId
	{
		continue:$d(^PAPER(BDReqFormid))=0
		continue:$p($g(^PAPER(BDReqFormid,"PAT",1)),"^",1)=""
		
		set PatientNo=$p($g(^PAPER(BDReqFormid,"PAT",1)),"^",1)
		continue:$d(^DHCBldRequest(PatientNo))=0
		set ReqFormNo=0
		for {
			set ReqFormNo=$o(^DHCBldRequest(PatientNo,ReqFormNo))
			quit:ReqFormNo=""
			set BDReqFormid=PatientNo_"||"_ReqFormNo
			set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
			set subObj=..getbloodtransappcs(BDReqFormid)
			set ^ExportHistoryData("pabloodtransapp",BDReqFormid)=$lb(BDReqFormid,subObj.pabtaapptypedesc,subObj.pabtaabo,subObj.pabtarh,subObj.pabtaappdeptcode,
			subObj.pabtaappdeptdesc,subObj.pabtaantibodyscreening,subObj.pabtabloodvariety,subObj.pabtabloodmode,subObj.pabtaappdoccode,
			subObj.pabtaappdocname,,subObj.pabtaappdatetime,subObj.pabtabloodusedatetime,subObj.pabtabloodreactdatetime,subObj.pabtabloodreaction,
			subObj.pabtabloodtransremarks,subObj.pabtabloodpurpose,subObj.pabtabloodtranshistory,subObj.pabtapregnancyhistory,subObj.updatedate,
			subObj.updatetime,subObj.papatrelpatientid,subObj.paadmrelvisitnumber,subObj.pabtaappstatusdesc,subObj.businessfieldcode)
			set con=con+1
			set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, BDReqFormid)		
		}
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

ClassMethod getbloodtransappcs(Id) As web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp
{
	
	set PatientNo=+Id
	set ReqFormNo=$p(Id,"||",2)
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp).%New()
	set BldReqData=$G(^DHCBldRequest(PatientNo,ReqFormNo))
	set BldReqLabData=$G(^DHCBldRequest(PatientNo,ReqFormNo,"Lab"))
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                  //业务域
	set subObj.pabtahosappid=Id                            //院内输血申请id
	set subObj.pabtarelappid=businessfieldcode_"_"_Id       //全局输血申请id
	set subObj.updatedate=$zd(+$h,3)                                //时间戳
	set subObj.updatetime=$zt($p($h,",",2))                         //时间戳
 	set PatientID=$o(^PAPERi("PAPMI_PatNo",PatientNo,""))
 	set subObj.papatrelpatientid=businessfieldcode_"_"_PatientID     //全局患者id
	set SequnNos="",pabtabloodvariety="",pabtabloodvarietys="",pabtabloodvolume="",pabtabloodvolumes=""
	for{
		set SequnNos=$O(^DHCBldReqOrd(PatientNo,ReqFormNo,SequnNos))
		quit:SequnNos=""
		set CurOrdRowID=$P($g(^DHCBldReqOrd(PatientNo,ReqFormNo,SequnNos)),"^",1)  
		set pabtabloodvariety=$P($g(^DHCBldReqOrd(PatientNo,ReqFormNo,SequnNos)),"^",3)
		set pabtabloodvolume=$P($g(^DHCBldReqOrd(PatientNo,ReqFormNo,SequnNos)),"^",3)    
		if pabtabloodvarietys="" set pabtabloodvarietys=pabtabloodvariety
		else  set pabtabloodvarietys=pabtabloodvarietys_";"_pabtabloodvariety
		if pabtabloodvolumes="" set pabtabloodvolumes=pabtabloodvolume
		else  set pabtabloodvolumes=pabtabloodvolumes_";"_pabtabloodvolume
	}
	set subObj.pabtabloodvariety=pabtabloodvarietys	  //品种
	set subObj.pabtabloodvolume=pabtabloodvolumes	 //血量
	set AdmID=$p($g(^OEORD(+CurOrdRowID)),"^",1)
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_AdmID      //全局就诊id 
	set lstCheckDate=$P(BldReqData,"\",15)
	Set:$L(lstCheckDate) lstCheckDate=$ZD(lstCheckDate,3)
	set lstCheckTime=$P(BldReqData,"\",16)
	Set:$L(lstCheckTime) lstCheckTime=$ZT(lstCheckTime,2)
	Set subObj.pabtaappdatetime=""
	set:(lstCheckDate'=""&&lstCheckTime'="") subObj.pabtaappdatetime=lstCheckDate_""_lstCheckTime   //申请日期时间
	set pabtaapptypedesc=$P(BldReqLabData,"\",3) //申请类型
	set subObj.pabtaapptypedesc=$case(pabtaapptypedesc,"JJSX":"急诊输血","CGSX":"常规输血","CGZL":"常规治疗",:"其他")
	set subObj.pabtaabo=$P(BldReqLabData,"\",1) //abo血型
	set subObj.pabtarh=$P(BldReqLabData,"\",2) //rh血型
	set locdr=$p(^PAADM(AdmID),"^",4)
#;	set subObj.pabtaappdeptcode=$p($g(^CTLOC(locdr)),"^",1)   //申请科室代码
	set subObj.pabtaappdeptcode=locdr
	set subObj.pabtaappdeptdesc=$p($g(^CTLOC(locdr)),"^",2)   //申请科室描述
	set pabtabloodpurpose=$P(BldReqData,"\",17)
	set pabtabloodpurpose=$replace(pabtabloodpurpose,",",";")  
	set purposelen=$l(pabtabloodpurpose)
	if purposelen > 2
	set subObj.pabtabloodpurpose =$e(pabtabloodpurpose,2,purposelen)  //输血目的
	set subObj.pabtapregnancyhistory=$P(BldReqData,"\",10)  //妊娠史
	set subObj.pabtabloodreaction=$P(BldReqData,"\",6)  //输血反应
	set subObj.pabtabloodreactdatetime=""               //输血反应日期时间
	set pabtaappdocdr=$P(BldReqData,"\",14)
	set AddUserDR =$p($g(^OEORD(+CurOrdRowID,"I",$p(CurOrdRowID,"||",2),1)),"^",11)
	set subObj.pabtaappdoccode=""
	set subObj.pabtaappdocname=""
#;	set:AddUserDR'="" subObj.pabtaappdoccode=$p($g(^CTPCP(AddUserDR)),"^",1)  //申请医生工号
	set subObj.pabtaappdoccode=AddUserDR
	set:AddUserDR'="" subObj.pabtaappdocname=$p($g(^CTPCP(AddUserDR)),"^",1)  //申请医生姓名
	
	set subObj.pabtaantibodyscreening=""	//抗体筛查
	set subObj.pabtabloodmode=""	//用血模式
	set DestBldDate =$P(BldReqData,"\",2)
	set:DestBldDate'="" DestBldDate=$zd(DestBldDate,3) 
	set subObj.pabtabloodusedatetime=""
	set:DestBldDate'="" subObj.pabtabloodusedatetime=DestBldDate_" 00:00:00"	//用血日期时间
	set subObj.pabtabloodreactdatetime=""	//输血反应日期时间
	set subObj.pabtabloodtransremarks=""	//备注
	set subObj.pabtabloodtranshistory=""	//输血史
	set subObj.pabtaappstatusdesc=""	//申请单状态描述
	q subObj
}

}
