Import SQLUser

/// Creator: 	yangyongtao
/// CreateDate: 2017-05-12
/// Descript: 	患者诊断信息
Class web.DHCSTPHCMDIAGLIST Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取诊断信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// 通过病人的ID获取诊断信息
/// Creator: 	yangyongtao
/// CreateDate: 2016-12-27
/// Others:		 w ##class(web.DHCSTPHCMDIAGLIST).QueryAppDiagtList("100","1","27^13")
ClassMethod QueryAppDiagtList(offet As %String, limit As %String, PatID As %String) As %GlobalCharacterStream
{
	 n (offet, limit, PatID)
	 s rows=offet
	 s page=limit 
	 S End = page*rows
	 S Start=(page-1)*rows+1
	 S pid=..NewPid()
	 K ^TMP("DHCST","web.DHCSTPHCMDIAGLIST","QueryDiagtList",pid)
	 s OutBinStream=##Class(%GlobalCharacterStream).%New()
	 S patNo=$p(PatID,"^",1)    //病人ID
	 S admID=$p(PatID,"^",2)     //就诊ID
	 S n=0     
     S admtype=""
     F  S admtype=$o(^PAPERdr(patNo,"ADM",admtype),-1) Q:admtype=""  D
	 .S adm="" 
	 .F  S adm=$o(^PAPERdr(patNo,"ADM",admtype,adm),-1) Q:adm=""  D  //就诊ID
	 ..Q:(admID'="")&(admID'=adm)
	 ..S depDesc=""  
	 ..S depcodedr=$p(^PAADM(adm),"^",4)  //
	 ..s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") /// 诊断
	 ..Q:PatDiagDesc=""
	 ..s AdmDoctor=""
	 ..s AdmDocCodeDR=$p(^PAADM(adm),"^",9)   /// 医生
	 ..s:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)
	 ..I depcodedr'="" S depDesc=$p(^CTLOC(depcodedr),"^",2)
	 ..I depDesc'="" S depDesc=$p(depDesc,"-",2) //获取科室描述
	 ..S admdate=$p(^PAADM(adm),"^",6) //就诊日期
	 ..I +admdate>0 S admdate=$zd(admdate,3) 
	 ..S admtime=$p(^PAADM(adm),"^",7) //就诊时间
	 ..I +admtime>0 S admtime=$zt(admtime)
	 ..S n=n+1
	 ..S data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_" "_$g(admtime)_"^"_patNo_"^"_PatDiagDesc_"^"_AdmDoctor_"^"_AdmDocCodeDR
	 ..S ^TMP("DHCST","web.DHCSTPHCMDIAGLIST","QueryDiagtList",pid,n)=data
     S maxrow=n
     S count=0
     d OutBinStream.Write("[")  //输出json前缀串
     S h=""
     F  S h=$o(^TMP("DHCST","web.DHCSTPHCMDIAGLIST","QueryDiagtList",pid,h)) Q:h=""  D
     .S mdata=^TMP("DHCST","web.DHCSTPHCMDIAGLIST","QueryDiagtList",pid,h)
     .S count = count+1
	 .S Title="Adm^AdmLoc^dateTime^patNo^diagDesc^AdmDoctor^AdmDocCodeDR"
	 .Q:(count<Start)||(count>End)
	 .I count=Start D
	 
	 ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	 .e  d
	 ..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	 d OutBinStream.Write("]")   //输出json结尾符
	 K ^TMP("DHCST","web.DHCSTPHCMDIAGLIST","QueryDiagtList",pid)
     //D OutBinStream.OutputToDevice()
	 Q OutBinStream
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMDIAGLIST"))
}

}
