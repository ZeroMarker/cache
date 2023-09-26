Class web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PAAdm Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取就诊记录表(ACC0004)
/// Table：pa_adm PA_AdmTransaction
/// Input：patRowId：患者AdmNo
/// Output：
/// Return：数据中心pa_adm就诊记录表(json)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmInfo).PAAdmByAdm("25334215")
ClassMethod PAAdmByAdm(admRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set obj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.Data).%New()
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmInfo).%New()
	set subObj=..GetPAAdmInfo(admRowId)
	d obj.PAAdmInfoList.Insert(subObj)
	set JsonString=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.JSONUtil).ObjToJson(obj,"")
	d stream.Write(JsonString)
	q stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""error"":"""_$ze_""",""data"":[]}")
	quit stream
}

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.AdmInfo).GetPAAdmInfo(2)
ClassMethod GetPAAdmInfo(admRowId) As web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmInfo
{
	set subObj=##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Model.PAAdmInfo).%New()
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set businessfieldcode=subObj.businessfieldcode
	set subObj.businessfieldcode=businessfieldcode                        //业务域
	set subObj.papatrelpatientid=businessfieldcode_"_"_patRowId	//全局患者id
	set subObj.updatedate=$zd(+$h,3)      //时间戳
	set subObj.updatetime=$zt($p($h,",",2))   //时间戳
	set subObj.paadmhosvisitnumber=admRowId         //院内就诊唯一id
	set subObj.paadmrelvisitnumber=businessfieldcode_"_"_admRowId   //全局就诊id
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)	
	set subObj.paadmencountertype=AdmTypeCode          //就诊类别代码
	set AdmStatusCode=$p($g(^PAADM(admRowId)),"^",20)
	set subObj.paadmstatus=AdmStatusCode          //就诊状态代码
	set FeeTypeRowID=$p($g(^PAADM(admRowId,1)),"^",7)
	set:FeeTypeRowID'="" subObj.paadmcostcategorycode=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",1)   //患者费别

	q:patRowId="" subObj
	set:subObj.paadmdocumentno="" subObj.paadmdocumentno=$p($g(^PAPER(patRowId,"PAT",1)),"^",22)   //病案号
	if (AdmTypeCode="O") 
	{
		set QueueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",patRowId,""))
		//1 复诊 2 等候 3 过号 4 到达 5 退号 6 未分配 7 报道
		if QueueDr'="" {
		set QSsub=""
		for {
			set QSsub=$o(^DHCQueueStatus(QueueDr,QSsub))
			q:QSsub=""
			set QSStatus=$p($g(^DHCQueueStatus(QueueDr,QSsub)),"^",4)
			if QSStatus="4"{
				set QSDocDr=$p($g(^DHCQueueStatus(QueueDr,QSsub)),"^",3)
				set subObj.paadmattenddoccode=QSDocDr  //接诊医生
				set QSDate=$p($g(^DHCQueueStatus(QueueDr,QSsub)),"^",1)
				set QSTime=$p($g(^DHCQueueStatus(QueueDr,QSsub)),"^",2)
				set:QSDate'="" subObj.qsdate=$zd(QSDate,3)  //接诊日期
				set:QSTime'="" subObj.qstime=$zt(QSTime)   //接诊时间
			} 
		}
		}
		set Completed = $p($g(^PAADM(admRowId),1),"^",23)
		set:Completed="Y" subObj.paadmencountertype="D"
	}
	set subObj.paadmadmitreason=""             //	入院原因
	set FeeTypeRowID=$p($g(^PAADM(admRowId,1)),"^",7)
	set:FeeTypeRowID'="" subObj.paadmcostcategorycode=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",1)
	set subObj.paadmvisittimes=$p($g(^PAADM(admRowId)),"^",29)   //住院次数
	//入院医生
	set TRANSChildsub="",AdmDoctorRowID=""
	for  {
	 set TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub))
	 set:TRANSChildsub'="" AdmDoctorRowID=$p(^PAADM(admRowId,"TRANS",TRANSChildsub),"^",5)
	 	 q:(TRANSChildsub="")||(AdmDoctorRowID'="")  
	}
	set AdmDoctorID=$p($g(^PAADM(admRowId)),"^",9) 
	set:AdmDoctorRowID="" AdmDoctorRowID=AdmDoctorID
	set subObj.paadmadmitdoccode=AdmDoctorRowID
	if (subObj.paadmattenddoccode="") set subObj.paadmattenddoccode=AdmDoctorID
	
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" subObj.paadmstartdate=$zd(AdmDate,3)
	set:AdmTime'="" subObj.paadmstarttime=$zt(AdmTime)
	//当前科室
	set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	set subObj.paadmcurdeptcode=CurrentDetpRowID
	set CurrentBedRowID=$P($g(^PAADM(admRowId)),"^",73)
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		set BedWordRowID = $p(CurrentBedRowID,"||",1)
		set subObj.paadmcurwardcode=BedWordRowID  //当前病区
		set BedChildSub = $p(CurrentBedRowID,"||",2)
		if $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			set subObj.paadmcurbedno=BedWordRowID  //当前床号
			set roomid=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",3)
			set subObj.paadmcurroomcode=roomid //当前房间代码
		}
	}
	//入院科室
	set TRANSChildsub="",AdmDeptRowID=""
	for  {
	 set TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub))
	 set:TRANSChildsub'="" AdmDeptRowID=$p(^PAADM(admRowId,"TRANS",TRANSChildsub),"^",6)
	 q:(TRANSChildsub="")||(AdmDeptRowID'="")  
	}
	set subObj.paadmadmdeptcode=AdmDeptRowID
	set:subObj.paadmadmdeptcode="" subObj.paadmadmdeptcode=subObj.paadmcurdeptcode  
	//出院科室	
	if ((AdmTypeCode="I") || (AdmTypeCode="E"))&&(AdmStatusCode="D")  
	{
	set EndDate= $P($G(^PAADM(admRowId)),"^",17)
	set EndTime=$P($G(^PAADM(admRowId)),"^",18)
	set:EndDate'="" subObj.paadmenddate=$zd(EndDate,3)  //出院日期
	set:EndTime'="" subObj.paadmendtime=$zt(EndTime)    //出院时间
	set subObj.paadmdisdeptcode=subObj.paadmcurdeptcode  //出院科室代码
	set DisChargCondRowID = $P($G(^PAADM(admRowId)),"^",49)
	}
	set paadmupdatedate=$p($g(^PAADM(admRowId,1)),"^",42)
	if paadmupdatedate'="" {
		set subObj.paadmupdatedate=$zd(paadmupdatedate,3)       //最后更新日期
	}
	else { 
		set paadmupdatedate=$p($g(^PAADM(admRowId)),"^",41)
		set subObj.paadmupdatedate=$zd(paadmupdatedate,3)      //创建日期
	}
	set paadmupdatetime=$p($g(^PAADM(admRowId,1)),"^",43) 
	if paadmupdatetime'="" {
		set subObj.paadmupdatetime=$zt(paadmupdatetime)    //最后更新时间
	}
	else { 
		set paadmupdatetime=$p($g(^PAADM(admRowId)),"^",42)
		set subObj.paadmupdatetime=$zt(paadmupdatetime)    //创建日期
	}	
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateUserDr'="" {
	set subObj.paadmupdateusercode=UpdateUserDr
	}
	else { 
		set UpdateUserDr=$p($g(^PAADM(admRowId)),"^",43)
		set subObj.paadmupdateusercode=UpdateUserDr
	}
	quit subObj
}

/// Creator：wl
/// CreatDate：2020-12-22
/// Description：根据id取就诊记录表(ACC0004)历史数据Global
/// Table：pa_adm PA_AdmTransaction
/// Input：patRowId：患者AdmNo
/// Output：
/// Return：数据中心pa_adm就诊记录表(Global)
/// Others：s st= ##class(web.DHCENS.STBLL.CDRJSONV2.EMPI.Method.PAAdm).PAAdmByAdmhistoryGlobal("1","6314734")
ClassMethod PAAdmByAdmhistoryGlobal(stradmRowId As %String, endadmRowId As %String) As %String
{
	set ^ExportHistoryData("paadm")=$lb("院内就诊唯一id","全局患者id","就诊类别代码","就诊状态代码","接诊医生","入院医生","入院日期","入院时间","入院科室代码","入院原因","当前科室代码","当前病区代码","当前房间代码","当前床号","出院日期","出院时间","出院科室代码","出院情况代码","最后更新日期","最后更新时间","最后更新人编码","时间戳","时间戳","住院次数","业务域","患者费别","病案号")
	set $zt="Exception"
	if (stradmRowId="")||(endadmRowId="") {
		quit "-1^id不能为空"
	}
	set admRowId="",con=0,strtime=$zt($p($now(),",",2))
	set sum=endadmRowId-stradmRowId+1
	for admRowId=stradmRowId:1:endadmRowId
	{
		continue:$d(^PAADM(admRowId))=0
		set subObj=..GetPAAdmInfo(admRowId)
		set ^ExportHistoryData("paadm",admRowId)=$lb(admRowId,subObj.papatrelpatientid,subObj.paadmencountertype,subObj.paadmstatus,subObj.paadmattenddoccode,
													 subObj.paadmadmitdoccode,subObj.paadmstartdate,subObj.paadmstarttime,subObj.paadmadmdeptcode,subObj.paadmadmitreason,
													 subObj.paadmcurdeptcode,subObj.paadmcurwardcode,subObj.paadmcurroomcode,subObj.paadmcurbedno,subObj.paadmenddate,
													 subObj.paadmendtime,subObj.paadmdisdeptcode,subObj.paadmdisstatuscode,subObj.paadmupdatedate,subObj.paadmupdatetime,
													 subObj.paadmupdateusercode,subObj.updatedate,subObj.updatetime,subObj.paadmvisittimes,subObj.paadmcostcategorycode,
													 subObj.paadmdocumentno,subObj.paadmrelvisitnumber,subObj.businessfieldcode)
		set con=con+1
		set no=##class(web.DHCENS.STBLL.CDRJSONV2.Utils.StringUtil).point(stradmRowId, endadmRowId, con, admRowId)		
	}
	quit "Finish   count:"_con
Exception
	quit "-1^"_$ze
}

}
