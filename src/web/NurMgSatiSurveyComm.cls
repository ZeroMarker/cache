/// Creator:
/// Date:
/// Description:
Class web.NurMgSatiSurveyComm Extends %RegisteredObject
{

ClassMethod SaveSet(parr As %String) As %String
{
}

/// Creator:
/// Date:
/// 
ClassMethod SendMessage(phone, content, ext) As %String
{
		//Get方法
		/*
		s httprequest=##class(%Net.HttpRequest).%New()
		s httprequest.Server="192.168.1.56"
		s httprequest.Port=80
		s sn="SDK-NFY-020-00077"
		s pwd="NFYYJYK0318"
		s phone="18611739943"
		s content="测试中【南方医院】"
		s ext=49
		s sc=httprequest.Get("/Server/SMS_Send.aspx?sn="_sn_"&pwd="_pwd_"&mobile="_phone_"&content="_content_"&ext="_ext)
		;s tsc=httprequest.HttpResponse.Data
		q sc
		*/
		//Post方法
		;b ;start
		s httprequest=##class(%Net.HttpRequest).%New()
		s httprequest.Server="192.168.1.56"
		s httprequest.Port="80"
		s sn="SDK-NFY-020-00077"
		s pwd="NFYYJYK0318"
		;s phone="18611739943"
		;s content="测试测试【南方医院】"
		d httprequest.InsertFormData("sn",sn)
		d httprequest.InsertFormData("pwd",pwd)
		d httprequest.InsertFormData("mobile",phone)
		d httprequest.InsertFormData("content",content)
		d httprequest.InsertFormData("ext",ext)
		s a=httprequest.Post("/Server/SMS_Send.aspx")
		;b ;end
		q a
}

/// Creator:gzj
/// CreateDate:2017-12-23
/// 
/// Description:接收患者满意度患者回复调查短信内容
/// Table:
/// Input:
/// Output
/// return:
/// Others:此方法要走系统任务
ClassMethod ReceiveMessage() As %String
{
		//192.168.1.56/Server/SMS_Fb.aspx?sn=SDK-NFY-020-00077&pwd=NFYYJYK0318&mobile=18611739943&content=测试中1...【南方医院】&backtime=20171218-20171221&ext=49
		s SetRowID=$O(^DHCNMG.DB.MgSurveySetD(""))
		q:SetRowID=""
		s ObjSet=##class(DHCNMG.DB.MgSurveySet).%OpenId(SetRowID)
		s stage=ObjSet.StAge
		s endage=ObjSet.EndAge
		s ReplyValid=ObjSet.ReplyValid
		s phone=ObjSet.AdminPhone
		s sn="SDK-NFY-020-00077"
		s pwd="NFYYJYK0318"
		s content="【南方医院】"
		;s type="48^49"
		s type="198^199"
		s len=$L(type,"^")
		f i=1:1:len
		{
			s ext=$P(type,"^",i)
			s data=..ReceiveMessageForType(sn,pwd,phone,content,ext)
			i (data>0) 
			{
				s count=$P(data,$c(10),1)
				f j=1:1:count
				{
					s itms=$P(data,$c(10),j+1)
					i itms'=""
					{
						s sn=$p(itms,$c(9),2)
						s ext=$p(itms,$c(9),3)
						s phone=$p(itms,$c(9),4)
						s ReplyType=$p(itms,$c(9),5)
						s ReplyDate=$p($p(itms,$c(9),6)," ",1)
						s ReplyTime=$p($p(itms,$c(9),6)," ",2)
						;^DHCNMG.Survey.MgNurPatSatisI("Type"," 198"," 18611739943",64642,1)
						s senddate=$O(^DHCNMG.Survey.MgNurPatSatisI("Type"," "_ext," "_phone,""),-1)
						q:senddate=""
						q:((senddate+ReplyValid)<$zdh(ReplyDate,3))
						s rowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Type"," "_ext," "_phone,senddate,""),-1)
						q:rowid=""
						s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
						s obj.ReplyType=ReplyType
						s obj.ReplyDate=$zdh(ReplyDate,3)
						s obj.ReplyTime=$zth(ReplyTime,1)
						s sc=obj.%Save()
					}
				}
			}
		}
		;s ^TMP("SatiSurvey")=Data.Read()
		q 0
}

ClassMethod ReceiveMessageForType(sn, pwd, phone, content, ext As %String) As %String
{
	s httprequest=##class(%Net.HttpRequest).%New()
	s httprequest.Server="192.168.1.56"
	s httprequest.Port="80"
	d httprequest.InsertFormData("sn",sn)
	d httprequest.InsertFormData("pwd",pwd)
	d httprequest.InsertFormData("mobile",phone)
	d httprequest.InsertFormData("content",content)
	;d httprequest.InsertFormData("backtime",backtime)
	d httprequest.InsertFormData("ext",ext)
	s a=httprequest.Post("/Server/SMS_Fb.aspx")
	s Data=httprequest.HttpResponse.Data
	q Data.Read()
}

/// Creator:gzj
/// CreateDate:2017-12-23
/// UpdateDate:2018-06-20
/// Description:对出院病人发送满意度调查短信
/// Table:
/// Input:
/// Output
/// return:
/// Others:
ClassMethod SendOutPatMessage() As %String
{
	set $ZT="ERROR"
	s date=+$H-1
	;s date=+$H
	s rowid="" f  s rowid=$O(^PAADMi("DischDate",date,rowid)) q:rowid=""  d
	.s obj=##class(User.PAAdm).%OpenId(rowid)
	.q:obj.PAADMType'="I"
	.s PAPatMasRowID=""
	.s PAPatMasRowID=obj.PAADMPAPMIDR.%Id() //病人登记信息表id
	.q:PAPatMasRowID=""
	.s patobj=##class(User.PAPatMas).%OpenId(PAPatMasRowID)
	.q:'$IsObject(patobj)
	.s AdmInDate=obj.PAADMAdmDate // 病人入院日期
	.s outDate=$zd(obj.PAADMDischgDate,3) //出院日期
	.s PAPMIName=patobj.PAPMIName //患者姓名
	.s PAPMINo=patobj.PAPMINo //登记号
	.s phone=patobj.PAPMIMobPhone //患者手机号
	.s patbirth=patobj.PAPMIDOB //患者出生日期
	.s pacward="" //padward表id
	.i $IsObject(obj.PAADMCurrentWardDR) s pacward=obj.PAADMCurrentWardDR.%Id()
	.q:pacward=""
	.s pacobj=##class(User.PACWard).%OpenId(pacward)
	.q:'$IsObject(pacobj)
	.s pacwardcode=pacobj.WARDCode //获取pacward的病区code
	.//将特殊的几个病区并到相关的病区中去
	.i pacwardcode="H221603" s pacwardcode="H221602" //重症八区护理单元【H221603】并到 心血管外科护理单元【H221602】
	.e  i pacwardcode="H220708" s pacwardcode="H220706" //重症二区护理单元【H220708】并入神经外科监护单元【H220706】
	.e  i pacwardcode="H210911" s pacwardcode="H210902" //重症六区护理单元【H210911】并入神经内科护理单元【H210902】
	.e  i pacwardcode="H210114" s pacwardcode="H210106" //重症七区护理单元【H210114】并入心血管CCU护理单元【H210106】
	.e  i pacwardcode="H220805" s pacwardcode="H220802" //重症三区护理单元【H220805】并入胸外科护理单元【H220802】
	.e  i pacwardcode="H210305" s pacwardcode="H210302" //重症五区护理单元【H210305】并入呼吸科护理单元【H210302】
	.;e  s pacwardcode="H"_pacwardcode
	.s pacwardid=$O(^PAWARD(0,"WARD_Code",pacwardcode,""))
	.q:pacwardid=""
	.s pacwardobj=##class(User.PACWard).%OpenId(pacwardid)
	.q:'$IsObject(pacwardobj)
	.//获取ctloc表ID
	.s ctlocrowid=""
	.i $IsObject(pacwardobj.WARDLocationDR) s ctlocrowid=pacwardobj.WARDLocationDR.%Id()
	.q:ctlocrowid="" //ctloc表id 出院病区ID
	.//检查病区是否已经维护 维护的可以发送短信 setflag
	.s setflag=..CheckSetWard(ctlocrowid)
	.q:setflag=0
	.//检查病区 如果是儿科 或 新生儿科 或江高心理科 时 checkward=1
	.//手机号获取联系人手机号吗
	.s checkward=..CheckWardType(ctlocrowid)
	.s PaPersonID=patobj.PAPMIRowId.%Id() //pa_person表id
	.s foreignPhone=$P(^PAPER(PaPersonID,"ALL"),"^",4) ///联系人电话
	.i foreignPhone'="" d
	..i checkward=1 d
	...s phone=foreignPhone //如果病区为【儿科】【新生儿科】或【江高心理科】如果联系人电话不为空 则将发送短信的手机改为联系人电话
	.s ctlocdesc=$P($P($G(^CTLOC(ctlocrowid)),"^",2),"-",2)
	.s SetRowID=$O(^DHCNMG.DB.MgSurveySetD(""))
	.q:SetRowID=""
	.s ObjSet=##class(DHCNMG.DB.MgSurveySet).%OpenId(SetRowID)
	.s stage=ObjSet.StAge
	.s endage=ObjSet.EndAge
	.s ReplyValid=ObjSet.ReplyValid
	.s yearsold=##class(web.NurMgVueComm).CalAge($zd(patbirth,3),$zd(+$H,3))
	.q:((($P(yearsold,"Y",1)<stage)||($P(yearsold,"Y",1)>endage))&&(checkward'=1))  //当患者为【儿科】【新生儿科】【江高心理科时不受年龄的限制】
	.;q:PAPMINo'="000570111"
	.;s phone="18611739943" ;s phone="18302022923" ;s phone="15595685256" //手机号为测试用户 
	.;b ;01
	.q:phone="" //当手机号或者联系人手机号吗为空时 退出
	.s OperateStr=ObjSet.OperateModel
	.s OperateStr=$replace(OperateStr,"{NAME}",PAPMIName)
	.s OperateStr=$replace(OperateStr,"{TIME}",outDate)
	.s OperateStr=$replace(OperateStr,"{DEPT}",ctlocdesc)
	.s OperateStr=$replace(OperateStr,"{DAY}",ReplyValid)
	.s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",obj.PAADMDischgDate," "_$zcvt(PAPMINo,"U")," P",""))
	.i satirowid="" d
	..;s opflag=..SendMessage(phone,OperateStr,48) //执行SendMessage()发送技术操作模板短信
	..s opflag=..SendMessage(phone,OperateStr,198) //执行SendMessage()发送技术操作模板短信
	..i opflag=1 d
	...;d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,obj.PAADMDischgDate,48,AdmInDate)
	...d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,obj.PAADMDischgDate,198,AdmInDate)
	.s ServiceModel=ObjSet.ServiceModel
	.s ServiceModel=$replace(ServiceModel,"{NAME}",PAPMIName)
	.s ServiceModel=$replace(ServiceModel,"{TIME}",outDate)
	.s ServiceModel=$replace(ServiceModel,"{DEPT}",ctlocdesc)
	.s ServiceModel=$replace(ServiceModel,"{DAY}",ReplyValid)
	.;s phone="18611739943" 
	.s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",obj.PAADMDischgDate," "_$zcvt(PAPMINo,"U")," S",""))
	.i satirowid="" d
	..;s serflag=..SendMessage(phone,ServiceModel,49) ////执行SendMessage()发送服务操作模板短信
	..s serflag=..SendMessage(phone,ServiceModel,199) ////执行SendMessage()发送服务操作模板短信
	..i serflag=1 d
	...;d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,obj.PAADMDischgDate,49,AdmInDate)
	...d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,obj.PAADMDischgDate,199,AdmInDate)
	q 0
ERROR
    s MSG=$ZE
    s ^TMP("SendOutPatMessage","ERROR")=MSG
    Quit ""
}

/// Creator:Guozj
/// CreateDate:2018-03-10
/// Description:将部分出院科室并到对应的护理单元中
/// Table:
/// Input:
/// Output
/// return:
/// Others:
ClassMethod CheckWardToWard() As %String
{
	/*ZZBQHLDY重症八区护理单元    H221603 并到H221602心血管外科护理单元
	ZZEOHLDY重症二区护理单元    H220708  并到SJWKJHDY神经外科监护单元   H220706
	ZZLOHLDY重症六区护理单元    H210911 	SJNKHLDY神经内科护理单元    H210902
	ZZQOHLDY重症七区护理单元    H210114 	XXGCCUHL心血管CCU护理单元   H210106 
	ZZSOHLDY重症三区护理单元    H220805 	XWKHLDY 胸外科护理单元      H220802 
	ZZWOHLDY重症五区护理单元    H210305  	HXKHLDY 呼吸科护理单元      H210302 
*/
	//需要在正式库调试此功能
}

/// Creator:Guozj
/// CreateDate:2018-02-23
/// Description:检查发送短信的病区是否已经维护
/// Table:
/// Input:
/// Output
/// return:
/// Others:
ClassMethod CheckSetWard(ctlocid As %String) As %String
{
	s flag=0
	s rowid=$O(^DHCNMG.Survey.SetWardI("wardlink"," "_ctlocid,""))
	q:rowid="" flag
	s flag=1
	q flag
}

/// Creator:Guozj
/// CreateDate:2018-02-04
/// Description:对军卫老系统系统出院病人发送满意度调查短信
/// Table:
/// Input:
/// Output
/// return:
/// Others:
ClassMethod SendOldHISMessage() As %String
{
	Set $ZT="ERROR"
	s date=+$H-1
	s retval=##class(web.DHCENS.BLL.HIS.Method.GetJWIPAdmInfo).GetJWIPAdmInfo($zd(date,3))
	q:retval="" ""
	d retval.Rewind()
	s reader=##class(%XML.Reader).%New()
	s sc=reader.OpenStream(retval)
	d reader.Correlate("JWIPAdmInfo","DHCNMG.Model.SatiPatientInfo")
	s str=""
	;b ;11120
	While reader.Next(.obj,.sc)
	{
		;b ;01
		s PatientId=obj.PatientId //登记号
		s DischargeDateTime=obj.DischargeDateTime //出院日期时间【2018-02-03 10:00:00】
		s AdmissionDateTime=obj.AdmissionDateTime //入院日期时间【2018-01-30 09:12:06】
		s DeptDischarge=obj.DeptDischarge //出院病区
		s rw=$O(^PAPERi("PAPMI_PatNo",PatientId,""))
		
		i rw'="" d
		.s list=^PAPER(rw,"ALL")
		.s PAPMIName=$p(list,"^",1) //患者姓名
		.s outDate=$p(DischargeDateTime," ",1)
		.q:outDate=""
		.s AdmInDate=$P(AdmissionDateTime," ",1) //入院日期
		.s outDate=$zdh(outDate,3) //出院日期
		.s PAPMINo=$tr(PatientId," ","") //登记号
		.s phone=$P(^PAPER(rw,"PER",4),"^",21) //患者联系方式
		.s phone1=phone
		.s patbirth=$P(^PAPER(rw,"ALL"),"^",6) //患者出生日期
		.s ctlocrowid=""
		.i DeptDischarge'="" d
		..i DeptDischarge="221603" s DeptDischarge="H221602" //重症八区护理单元【H221603】并到 心血管外科护理单元【H221602】
		..e  i DeptDischarge="220708" s DeptDischarge="H220706" //重症二区护理单元【H220708】并入神经外科监护单元【H220706】
		..e  i DeptDischarge="210911" s DeptDischarge="H210902" //重症六区护理单元【H210911】并入神经内科护理单元【H210902】
		..e  i DeptDischarge="210114" s DeptDischarge="H210106" //重症七区护理单元【H210114】并入心血管CCU护理单元【H210106】
		..e  i DeptDischarge="220805" s DeptDischarge="H220802" //重症三区护理单元【H220805】并入胸外科护理单元【H220802】
		..e  i DeptDischarge="210305" s DeptDischarge="H210302" //重症五区护理单元【H210305】并入呼吸科护理单元【H210302】
		..e  s DeptDischarge="H"_DeptDischarge
		..s ctlocrow=$O(^CTLOC(0,"Code",DeptDischarge,""))
		..i ctlocrow'="" d
		...s ctlocrowid=ctlocrow
		.q:ctlocrowid=""
		.;i ctlocrowid=545 b ;ceshi001
		.//检查病区是否已经维护 维护的可以发送短信 setflag
		.s setflag=..CheckSetWard(ctlocrowid)
		.q:setflag=0
		.s checkward=..CheckWardType(ctlocrowid)
		.s PaPersonID=rw //pa_person表id
		.s foreignPhone=$P(^PAPER(PaPersonID,"ALL"),"^",4) ///联系人电话
		.i foreignPhone'="" d
		..i checkward=1 d
		...s phone=foreignPhone //如果病区为【儿科】【新生儿科】或【江高心理科】如果联系人电话不为空 则将发送短信的手机改为联系人电话
		.s ctlocdesc=$P($P($G(^CTLOC(ctlocrowid)),"^",2),"-",2)
		.s SetRowID=$O(^DHCNMG.DB.MgSurveySetD(""))
		.q:SetRowID=""
		.s ObjSet=##class(DHCNMG.DB.MgSurveySet).%OpenId(SetRowID)
		.s stage=ObjSet.StAge
		.s endage=ObjSet.EndAge
		.s ReplyValid=ObjSet.ReplyValid
		.s yearsold=##class(web.NurMgVueComm).CalAge($zd(patbirth,3),$zd(+$H,3))
		.q:((($P(yearsold,"Y",1)<stage)||($P(yearsold,"Y",1)>endage))&&(checkward'=1)) //当患者为【儿科】【新生儿科】【江高心理科时不受年龄的限制】
		.s phone="18255162779" //为了测试 改为测试手机号，正式上线后注释此行代码
		.b ;01
		.q:phone="" //当手机号或者联系人手机号吗为空时 退出
		.s OperateStr=ObjSet.OperateModel
		.s OperateStr=$replace(OperateStr,"{NAME}",PAPMIName)
		.s OperateStr=$replace(OperateStr,"{TIME}",$zd(outDate,3))
		.s OperateStr=$replace(OperateStr,"{DEPT}",ctlocdesc)
		.s OperateStr=$replace(OperateStr,"{DAY}",ReplyValid)
		.s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",outDate," "_$zcvt(PAPMINo,"U")," P",""))
		.i satirowid="" d
		..;s opflag=..SendMessage(phone,OperateStr,48) //执行SendMessage()发送技术操作模板短信
		..s opflag=..SendMessage(phone,OperateStr,198) //执行SendMessage()发送技术操作模板短信
		..i opflag=1 d
		...;d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,outDate,48,AdmInDate)
		...d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,outDate,198,AdmInDate)
		.s ServiceModel=ObjSet.ServiceModel
		.s ServiceModel=$replace(ServiceModel,"{NAME}",PAPMIName)
		.s ServiceModel=$replace(ServiceModel,"{TIME}",$zd(outDate,3))
		.s ServiceModel=$replace(ServiceModel,"{DEPT}",ctlocdesc)
		.s ServiceModel=$replace(ServiceModel,"{DAY}",ReplyValid)
		.s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",outDate," "_$zcvt(PAPMINo,"U")," S",""))
		.i satirowid="" d
		..;s serflag=..SendMessage(phone,ServiceModel,49) ////执行SendMessage()发送服务操作模板短信
		..s serflag=..SendMessage(phone,ServiceModel,199) ////执行SendMessage()发送服务操作模板短信
		..i serflag=1 d
		...;d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,outDate,49,AdmInDate)
		...d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,outDate,199,AdmInDate)
		
	}
	q 0
ERROR
    s MSG=$ZE
    s ^TMP("SATIPATIENTMSG","ERROR")=MSG
    Quit ""
}

/// 检查科室是否为【儿科】【新生儿】【江高心理科】
ClassMethod CheckWardType(ctlocid As %String) As %String
{
	//^DHCNMG.Survey.SetWardI("wardlink"," 4",2)
	s flag=0
	;s PACRowID=$O(^PAWARD(0,"WARD_LocationDR",ctlocid,""))
	;q:PACRowID="" 0
	;s RowID=$O(^DHCNMG.Survey.SetWardI("wardlink"," "_$tr(PACRowID," ",""),""))
	s RowID=$O(^DHCNMG.Survey.SetWardI("wardlink"," "_$tr(ctlocid," ",""),""))
	q:RowID="" 0
	s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
	i ((obj.WardSetDesc="新生儿")||(obj.WardSetDesc="儿科")||(obj.WardSetDesc="江高心理科")) s flag=1
	q flag
}

ClassMethod SendOutPatMessageTest() As %String
{
	s date=+$H
	s patbirth="1989-01-20"
	s PAPMIName="鲁林"
	s outDate="2017-12-24"
	s ctlocrowid="118"
	s PAPMINo="ceshi0000002"
	s phone="18366646874"
	s ctlocdesc=$P($P($G(^CTLOC(ctlocrowid)),"^",2),"-",2)
	s SetRowID=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:SetRowID=""
	s ObjSet=##class(DHCNMG.DB.MgSurveySet).%OpenId(SetRowID)
	s stage=ObjSet.StAge
	s endage=ObjSet.EndAge
	s ReplyValid=ObjSet.ReplyValid
	s yearsold=##class(web.NurMgVueComm).CalAge(patbirth,$zd(+$H,3))
	q:(($P(yearsold,"Y",1)<stage)||($P(yearsold,"Y",1)>endage))
	s OperateStr=ObjSet.OperateModel
	s OperateStr=$replace(OperateStr,"{NAME}",PAPMIName)
	s OperateStr=$replace(OperateStr,"{TIME}",outDate)
	s OperateStr=$replace(OperateStr,"{DEPT}",ctlocdesc)
	s OperateStr=$replace(OperateStr,"{DAY}",ReplyValid)
	s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",$zdh(outDate,3)," "_$zcvt(PAPMINo,"U")," P",""))
	i satirowid="" d
	.;s opflag=..SendMessage(phone,OperateStr,48) //执行SendMessage()发送技术操作模板短信
	.s opflag=..SendMessage(phone,OperateStr,198) //执行SendMessage()发送技术操作模板短信
	.i opflag=1 d
	..;d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,$zdh(outDate,3),48)
	..d ..InsertPatSatis(PAPMINo,ctlocrowid,"P",+$H,$P($H,",",2),phone,$zdh(outDate,3),198)
	s ServiceModel=ObjSet.ServiceModel
	s ServiceModel=$replace(ServiceModel,"{NAME}",PAPMIName)
	s ServiceModel=$replace(ServiceModel,"{TIME}",outDate)
	s ServiceModel=$replace(ServiceModel,"{DEPT}",ctlocdesc)
	s ServiceModel=$replace(ServiceModel,"{DAY}",ReplyValid)
	s satirowid=$O(^DHCNMG.Survey.MgNurPatSatisI("Date",$zdh(outDate,3)," "_$zcvt(PAPMINo,"U")," S",""))
	i satirowid="" d
	.;s serflag=..SendMessage(phone,ServiceModel,49) ////执行SendMessage()发送服务操作模板短信
	.s serflag=..SendMessage(phone,ServiceModel,199) ////执行SendMessage()发送服务操作模板短信
	.i serflag=1 d
	..;d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,$zdh(outDate,3),49)
	..d ..InsertPatSatis(PAPMINo,ctlocrowid,"S",+$H,$P($H,",",2),phone,$zdh(outDate,3),199)
	q 0
}

/// Creator:
/// CreateDate:2017-12-25
/// Description:插入患者满意度
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod InsertPatSatis(PAPMINO, ctloc, type, createdate, time, phone, dischgdate, ext, AdmInDate) As %String
{
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%New()
	s obj.PatPMINo=$zcvt(PAPMINO,"U")
	s obj.PatWard=ctloc
	s obj.SatiType=type
	s obj.SendDate=createdate
	s obj.SendTime=time
	s obj.SendPhone=phone
	s obj.OutDate=dischgdate
	s obj.Ext=ext
	s obj.AdmInDate=$tr($g(AdmInDate)," ","")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// CreateDate:2017-12-23
/// Description:保存患者满意度设置
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod SaveSatisSet(parr As %String) As %String
{
	;s ^TMP("savesatisetparr")=parr
	//StAge|20^EndAge|60^SendType|T^ReplyValid|30^ReVisitValid|60
	//^OperateModel|南方医院患者满意度调查。{NAME}，您于{TIME}曾在我院{DEPT}进行治疗，现请您对我院护士的操作技术进行评价。 1.满意 2.不满意  请您在{DAY}天内回复此短信（回复序号即可），感谢您对我院护理工作的支持!【南方医院】
	//^ServiceModel|南方医院患者满意度调查。{NAME}，您于{TIME}曾在我院{DEPT}进行治疗，现请您对我院护士的服务态度进行评价。 1.满意 2.不满意  请您在{DAY}天内回复此短信（回复序号即可），感谢您对我院护理工作的支持!【南方医院】
	//^AdminPhone|15692015603^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.DB.MgSurveySet).%New()
	e  s obj=##class(DHCNMG.DB.MgSurveySet).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.DB.MgSurveySet","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..s $ZOBJPROPERTY(obj,p)=$zcvt($tr(tmp(p)," ",""),"U")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:
/// Description:查询患者满意度设置
/// Date:2017-12-23
/// Table:DHCNMG.DB.MgSetCode
/// Input:
/// Output：
/// Return:
/// Others:
Query FindSatiSurveySet(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSatiSurveySetExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgSurveySetD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgSurveySet).%OpenId(rowid)
	.s StAge=obj.StAge
	.s EndAge=obj.EndAge
	.s SendType=obj.SendType
	.s ReplyValid=obj.ReplyValid
	.s ReVisitValid=obj.ReVisitValid
	.s OperateModel=obj.OperateModel
	.s ServiceModel=obj.ServiceModel
	.s AdminPhone=obj.AdminPhone
	.s ret="StAge|"_StAge_"^EndAge|"_EndAge_"^SendType|"_SendType_"^ReplyValid|"_ReplyValid_"^ReVisitValid|"_ReVisitValid_"^OperateModel|"_OperateModel_"^ServiceModel|"_ServiceModel_"^AdminPhone|"_AdminPhone_"^RowID|"_rowid
	.do OutputSetData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSetData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSatiSurveySetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSatiSurveySetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSatiSurveySetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSatiSurveySetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:查询患者满意度数据
/// Date:2017-12-25
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:
/// Output：
/// Return:
/// Others:
Query FindSatiSurveyData(ward As %String = "", stdate As %String = "", enddate As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSatiSurveyDataExecute(ByRef qHandle As %Binary, ward As %String = "", stdate As %String = "", enddate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("satisurveydataparr")=ward_"%"_stdate_"%"_enddate
	s tmp="",yeartmp="",visittmp="",timevisit="",ctimevisit=""
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s outward=""
	i ward'="" d
	.s setwardobj=##class(DHCNMG.Survey.SetWard).%OpenId(ward)
	.q:'$IsObject(setwardobj)
	.s pacwardid=setwardobj.WardSetLink
	.s paclist=$g(^PAWARD(pacwardid))
	.i paclist'="" d
	..s ctlocid=$p(paclist,"^",5)
	..i ctlocid'="" s outward=ctlocid
	
	s date="" f  s date=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date)) q:date=""  d
	.q:(((stdate'="")&&(date<stdate))||((enddate'="")&&(date>enddate)))
	.s patward="" f  s patward=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,patward)) q:patward=""  d
	..q:((outward'="")&&($tr(patward," ","")'=outward))
	..s satitype="" f  s satitype=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,patward,satitype)) q:satitype=""  d
	...s rowid="" f  s rowid=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,patward,satitype,rowid)) q:rowid=""  d
	....s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
	....s yearMonth=$e($zd(obj.OutDate,8),1,6) //获取患者出院年月
	....s tmp($tr(patward," ",""),$tr(satitype," ",""),rowid)=obj.ReplyType
	....;s yeartmp(rowid,$tr(satitype," ",""),yearMonth)=yearMonth
	....s visittmp($tr(patward," ",""),$tr(satitype," ",""),rowid)=obj.ReplyFlag
	....i ((obj.ReplyFlag="Y")&&(obj.ApplicateFlag="")) s timevisit($tr(patward," ",""),$tr(satitype," ",""),rowid)=1
	
	//操作参与总人数 操作满意的人数  服务参与总人数 服务满意人数
	s sward="" f  s sward=$O(tmp(sward)) q:sward=""  d
	.s sum(sward,"P")=0,sum(sward,"S")=0,ctimevisit(sward,"P")=0,ctimevisit(sward,"S")=0
	.s count(sward,"P","1")=0,count(sward,"P","2")=0,count(sward,"P","-1")=0,count(sward,"P","other")=0
	.s count(sward,"S","1")=0,count(sward,"S","2")=0,count(sward,"S","-1")=0,count(sward,"S","other")=0
	.s visit(sward,"P","Y")=0,visit(sward,"S","Y")=0 //获取回访的记录总数
	.s stype="" f  s stype=$O(tmp(sward,stype)) q:stype=""  d
	..s srowid="" f  s srowid=$O(tmp(sward,stype,srowid)) q:srowid=""  d
	...i stype="P" s sum(sward,"P")=sum(sward,"P")+1
	...i stype="S" s sum(sward,"S")=sum(sward,"S")+1
	...i ((tmp(sward,stype,srowid)=1)&&(stype="P")) s count(sward,"P","1")=count(sward,"P","1")+1
	...e  i ((tmp(sward,stype,srowid)=2)&&(stype="P")) s count(sward,"P","2")=count(sward,"P","2")+1
	...e  i ((tmp(sward,stype,srowid)="")&&(stype="P")) s count(sward,"P","-1")=count(sward,"P","-1")+1
	...e  i (((tmp(sward,stype,srowid)'=1)&&(tmp(sward,stype,srowid)'=2)&&(tmp(sward,stype,srowid)'=-1))&&(stype="P")) s count(sward,"P","other")=count(sward,"P","other")+1
	...e  i ((tmp(sward,stype,srowid)=1)&&(stype="S")) s count(sward,"S","1")=count(sward,"S","1")+1
	...e  i ((tmp(sward,stype,srowid)=2)&&(stype="S")) s count(sward,"S","2")=count(sward,"S","2")+1
	...e  i ((tmp(sward,stype,srowid)="")&&(stype="S")) s count(sward,"S","-1")=count(sward,"S","-1")+1
	...e  i (((tmp(sward,stype,srowid)'=1)&&(tmp(sward,stype,srowid)'=2)&&(tmp(sward,stype,srowid)'=-1))&&(stype="S")) s count(sward,"S","other")=count(sward,"S","other")+1
	...i visittmp(sward,stype,srowid)="Y" s visit(sward,stype,"Y")=visit(sward,stype,"Y")+1
	...i $g(timevisit(sward,stype,srowid))'="" s ctimevisit(sward,stype)=ctimevisit(sward,stype)+timevisit(sward,stype,srowid)
	...;e  s ctimevisit(sward,stype)=ctimevisit(sward,stype)
	//计算全院各种率
	s allOperaterate=0,allOperatenum=0,allServicerate=0,allServicenum=0
	s allWard="" f  s allWard=$O(sum(allWard)) q:allWard=""  d
	.s allType="" f  s allType=$O(sum(allWard,allType)) q:allType=""  d
	..i allType="P" s allOperatenum=allOperatenum+sum(allWard,allType) //所有发送短信的技术操作的总人数
	..e  i allType="S" s allServicenum=allServicenum+sum(allWard,allType) //所有发送短信的服务态度的总人数
	
	s allReplyOperate=0,allReplyService=0
	s allCountOpersum=0,allCountSersum=0,allCountOpNullsum=0,allCountSerNullsum=0,allCountOpNosum=0,allCountSerNosum=0,allCountOthersum=0
	s allCountWard="" f  s allCountWard=$O(count(allCountWard)) q:allCountWard=""  d
	.s allCountType="" f  s allCountType=$O(count(allCountWard,allCountType)) q:allCountType=""  d
	..s allCountReType="" f  s allCountReType=$O(count(allCountWard,allCountType,allCountReType)) q:allCountReType=""  d
	...i ((allCountType="P")&&(allCountReType="1")) s allCountOpersum=allCountOpersum+count(allCountWard,allCountType,allCountReType) //技术操作满意总人数
	...i ((allCountType="S")&&(allCountReType="1")) s allCountSersum=allCountSersum+count(allCountWard,allCountType,allCountReType) //服务满意总人数
	...i ((allCountType="P")&&(allCountReType="-1")) s allCountOpNullsum=allCountOpNullsum+count(allCountWard,allCountType,allCountReType) //技术操作没回复的总人数
	...i ((allCountType="S")&&(allCountReType="-1")) s allCountSerNullsum=allCountSerNullsum+count(allCountWard,allCountType,allCountReType) //服务态度没有回复的总人数
	...i ((allCountType="P")&&(allCountReType="2")) s allCountOpNosum=allCountOpNosum+count(allCountWard,allCountType,allCountReType) //技术操作不满意的总数
	...i ((allCountType="S")&&(allCountReType="2")) s allCountSerNosum=allCountSerNosum+count(allCountWard,allCountType,allCountReType) //服务满意不满意的总数
	...i allCountReType="other" s allCountOthersum=allCountOthersum+count(allCountWard,allCountType,allCountReType) //其他回复总数
	i ((allOperatenum'=0)&&(allOperatenum-allCountOpNullsum)'=0) d
	.s allOperaterate=$fn((allCountOpersum/(allOperatenum-allCountOpNullsum)),"",2)*100_"%"
	.s allReplyOperate=$fn(((allOperatenum-allCountOpNullsum)/allOperatenum),"",2)*100_"%"
	i ((allServicenum'=0)&&(allServicenum-allCountSerNullsum)'=0) d
	.s allServicerate=$fn((allCountSersum/(allServicenum-allCountSerNullsum)),"",2)*100_"%"
	.s allReplyService=$fn(((allServicenum-allCountSerNullsum)/allServicenum),"",2)*100_"%"
	
	s allVisitOperate=0,allVisitOpernum=0,allVisitSerate=0,allVisitSersum=0
	s allVisitWard="" f  s allVisitWard=$O(visit(allVisitWard)) q:allVisitWard=""  d
	.s allVisitType="" f  s allVisitType=$O(visit(allVisitWard,allVisitType)) q:allVisitType=""  d
	..s allReVisitType="" f  s allReVisitType=$O(visit(allVisitWard,allVisitType,allReVisitType)) q:allReVisitType=""  d
	...i allVisitType="P" s allVisitOpernum=allVisitOpernum+visit(allVisitWard,allVisitType,allReVisitType) //计算技术操作回访的总数
	...i allVisitType="S" s allVisitSersum=allVisitSersum+visit(allVisitWard,allVisitType,allReVisitType) //计算服务满意回访的总数
	i allCountOpNosum'=0 d
	.s allVisitOperate=$fn(allVisitOpernum/allCountOpNosum,"",2)*100_"%"
	i allCountSerNosum'=0 d
	.s allVisitSerate=$fn(allVisitSersum/allCountSerNosum,"",2)*100_"%"
	
	s timeVisitOpernum=0,timeVisitSernum=0
	s timeVisitWard="" f  s timeVisitWard=$O(timevisit(timeVisitWard)) q:timeVisitWard=""  d
	.s timeVisitType="" f  s timeVisitType=$O(timevisit(timeVisitWard,timeVisitType)) q:timeVisitType=""  d
	..s timeVisitRw="" f  s timeVisitRw=$O(timevisit(timeVisitWard,timeVisitType,timeVisitRw)) q:timeVisitRw=""  d
	...i timeVisitType="P" s timeVisitOpernum=timeVisitOpernum+timevisit(timeVisitWard,timeVisitType,timeVisitRw)
	...i timeVisitType="S" s timeVisitSernum=timeVisitSernum+timevisit(timeVisitWard,timeVisitType,timeVisitRw)
	s timeVisitOperRate=0,timeVisitSerRate=0
	i ((allCountOpNosum'="")&&(allCountOpNosum'=0)) d
	.s timeVisitOperRate=$fn(timeVisitOpernum/allCountOpNosum,"",2)*100_"%"
	i ((allCountSerNosum'="")&&(allCountSerNosum'=0)) d
	.s timeVisitSerRate=$fn(timeVisitSernum/allCountSerNosum,"",2)*100_"%"
	//操作申请回访的总数 操作不满意总数 服务申请回访总数 服务不满意总数
	s allopervisitnum=0,allservisitnum=0
	//操作申请回访率 服务满意申请回访率
	s allopervisitrate=0,allservisitrate=0
	s allAppWard="" f  s allAppWard=$O(visittmp(allAppWard)) q:allAppWard=""  d
	.s allAppType="" f  s allAppType=$O(visittmp(allAppWard,allAppType)) q:allAppType=""  d
	..s allAppRw="" f  s allAppRw=$O(visittmp(allAppWard,allAppType,allAppRw)) q:allAppRw=""  d
	...i ((allAppType="P")&&(visittmp(allAppWard,allAppType,allAppRw)'="")) s allopervisitnum=allopervisitnum+1
	...i ((allAppType="S")&&(visittmp(allAppWard,allAppType,allAppRw)'="")) s allservisitnum=allservisitnum+1
	i ((allCountOpNosum'="")&&(allCountOpNosum'=0)) s allopervisitrate=$fn(allopervisitnum/allCountOpNosum,"",2)*100_"%"
	i ((allCountSerNosum'="")&&(allCountSerNosum'=0)) s allservisitrate=$fn(allservisitnum/allCountSerNosum,"",2)*100_"%"
	
	;b ;112
	s ret="warddesc|"_"全部"_"^operaterate|"_allOperaterate_"^operatesum|"_allOperatenum_"^replyoprate|"_allReplyOperate_"^visitoprate|"_allVisitOperate_"^timeVisitOperRate|"_timeVisitOperRate_"^servicerate|"_allServicerate_"^servicesum|"_allServicenum_"^replyserate|"_allReplyService_"^visitserate|"_allVisitSerate_"^othersum|"_allCountOthersum_"^timeVisitSerRate|"_timeVisitSerRate_"^wardcode|0"_"^opervisitrate|"_allopervisitrate_"^servisitrate|"_allservisitrate
	d OutputSatiData
	;b ;110
	s scward="" f  s scward=$O(sum(scward)) q:scward=""  d
	.s operaterate="",operatenum="",servicerate="",servicenum="",othersum=0,replyoprate=0,replyserate=0,visitoprate=0,visitserate=0
	.s timeVisitOpernum=0,timeVisitSernum=0,timeVisitOperRate=0,timeVisitSerRate=0
	.s opervisitrate=0,opervisitnum=0,servisitrate=0,servisitnum=0 //操作申请回访率 操作申请回访总数 服务申请回访率 服务申请回访总数
	.s sctype="" f  s sctype=$O(sum(scward,sctype)) q:sctype=""  d
	..s othersum=othersum+count(scward,sctype,"other")
	..i sctype="P" d
	...s operatesum=sum(scward,sctype)-count(scward,sctype,"-1") //操作总人数 
	...s operatenum=count(scward,sctype,"1") //操作满意人数
	...i ((operatesum'="")&&(operatesum'=0)&&(operatenum'="")) d
	....s operaterate=$fn((operatenum/operatesum),"",2)*100_"%" //操作满意率
	...i operatesum=0 d
	....s operaterate="无"
	...i ((operatesum'="")&&(sum(scward,sctype)'=0)) d 
	....s replyoprate=$fn(operatesum/sum(scward,sctype),"",2)*100_"%" //技术操作回复率
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)&&(visit(scward,sctype,"Y")'="")) d //回访率 = 回访的记录数/不满意的记录总数 
	....s visitoprate=$fn(visit(scward,sctype,"Y")/count(scward,sctype,"2"),"",2)*100_"%"
	...i count(scward,sctype,"2")=0 s visitoprate=0
	...s timeVisitOpernum=ctimevisit(scward,sctype) //病区按时回访总数
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)) d
	....s timeVisitOperRate=$fn(timeVisitOpernum/count(scward,sctype,"2"),"",2)*100_"%"
	...
	...s opvisitrw="" f  s opvisitrw=$O(visittmp(scward,sctype,opvisitrw)) q:opvisitrw=""  d
	....i visittmp(scward,sctype,opvisitrw)'="" s opervisitnum=opervisitnum+1
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)) s opervisitrate=$fn(opervisitnum/count(scward,sctype,"2"),"",2)*100_"%"
	...
	..i sctype="S" d
	...s servicesum=sum(scward,sctype)-count(scward,sctype,"-1") //服务总人数
	...s servicenum=count(scward,sctype,"1") //服务满意人数
	...i ((servicesum'="")&&(servicesum'=0)&&(servicenum'="")) d
	....s servicerate=$fn((servicenum/servicesum),"",2)*100_"%"
	...i servicesum=0 d
	....s servicerate="无"
	...i ((servicesum'="")&&(sum(scward,sctype)'=0)) d
	....s replyserate=$fn(servicesum/sum(scward,sctype),"",2)*100_"%"
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)&&(visit(scward,sctype,"Y")'="")) d
	....s visitserate=$fn(visit(scward,sctype,"Y")/count(scward,sctype,"2"),"",2)*100_"%"
	...i count(scward,sctype,"2")=0 s visitserate=0
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)) d
	....s timeVisitSerRate=$fn(timeVisitSerRate/count(scward,sctype,"2"),"",2)*100_"%"
	...
	...s servisitrw="" f  s servisitrw=$O(visittmp(scward,sctype,servisitrw)) q:servisitrw=""  d
	....i visittmp(scward,sctype,servisitrw)'="" s servisitnum=servisitnum+1
	...i ((count(scward,sctype,"2")'="")&&(count(scward,sctype,"2")'=0)) s servisitrate=$fn(servisitnum/count(scward,sctype,"2"),"",2)*100_"%"
	...
	..s warddesc=$P($P($g(^CTLOC(scward)),"^",2),"-",2)
	.s ret="warddesc|"_warddesc_"^operaterate|"_operaterate_"^operatesum|"_operatesum_"^replyoprate|"_replyoprate_"^visitoprate|"_visitoprate_"^timeVisitOperRate|"_timeVisitOperRate_"^servicerate|"_servicerate_"^servicesum|"_servicesum_"^replyserate|"_replyserate_"^visitserate|"_visitserate_"^timeVisitSerRate|"_timeVisitSerRate_"^othersum|"_othersum_"^wardcode|"_scward_"^opervisitrate|"_opervisitrate_"^servisitrate|"_servisitrate
	.do OutputSatiData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSatiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSatiSurveyDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSatiSurveyDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSatiSurveyDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSatiSurveyDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:按月按病区汇总出患者满意度数据
/// Date:2018-01-29
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:
/// Output：
/// Return:
/// Others:
Query FindMonthSatiSurvey(ward As %String = "", stdate As %String = "", enddate As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindMonthSatiSurveyExecute(ByRef qHandle As %Binary, ward As %String = "", stdate As %String = "", enddate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("wardstdate")=ward_"%"_stdate_"%"_enddate
	s tmp="",visittmp="",timevisit="",ctimevisit=""
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s outward=""
	i ward'="" d
	.s setwardobj=##class(DHCNMG.Survey.SetWard).%OpenId(ward)
	.q:'$IsObject(setwardobj)
	.s ctlocid=setwardobj.WardSetLink
	.i ctlocid'="" s outward=ctlocid
	.;s pacwardid=setwardobj.WardSetLink
	.;s paclist=$g(^PAWARD(pacwardid))
	.;i paclist'="" d
	..;s ctlocid=$p(paclist,"^",5)
	..;i ctlocid'="" s outward=ctlocid
	
	s outdate="" f  s outdate=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",outdate)) q:outdate=""  d
	.q:((stdate'="")&&(outdate<stdate))
	.q:((enddate'="")&&(outdate>enddate))
	.s oward="" f  s oward=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",outdate,oward)) q:oward=""  d
	..q:((outward'="")&&($tr(oward," ","")'=outward))
	..s otype="" f  s otype=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",outdate,oward,otype)) q:otype=""  d
	...s orowid="" f  s orowid=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",outdate,oward,otype,orowid)) q:orowid=""  d
	....s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(orowid)
	....s tmp($tr(oward," ",""),$tr(otype," ",""),$e($zd(outdate,8),1,6),orowid)=obj.ReplyType
	....s visittmp($e($zd(outdate,8),1,6),$tr(oward," ",""),$tr(otype," ",""),orowid)=obj.ReplyFlag
	....i ((obj.ReplyFlag="Y")&&(obj.ApplicateFlag="")) s timevisit($e($zd(outdate,8),1,6),$tr(oward," ",""),$tr(otype," ",""),orowid)=1
	
	//操作参与总人数 操作满意的人数  服务参与总人数 服务满意人数
	s sward="" f  s sward=$O(tmp(sward)) q:sward=""  d
	.;s visit(sward,"P","Y")=0,visit(sward,"S","Y")=0 //获取回访的记录总数
	.s stype="" f  s stype=$O(tmp(sward,stype)) q:stype=""  d
	..//循环年月
	..s smonth="" f  s smonth=$O(tmp(sward,stype,smonth)) q:smonth=""  d
	...s ctimevisit(smonth,sward,"P")=0,ctimevisit(smonth,sward,"S")=0
	...i $g(sum(smonth,sward,"P","WARD"))="" s sum(smonth,sward,"P","WARD")=0 //所有回复短信的 技术操作满意记录总数目
	...i $g(sum(smonth,sward,"S","WARD"))="" s sum(smonth,sward,"S","WARD")=0 //所有回复短信的 服务满意记录总数目
	...i $G(count(smonth,sward,"P","WARD","1"))="" s count(smonth,sward,"P","WARD","1")=0
	...i $g(count(smonth,sward,"P","WARD","2"))="" s count(smonth,sward,"P","WARD","2")=0
	...i $g(count(smonth,sward,"P","WARD","-1"))="" s count(smonth,sward,"P","WARD","-1")=0
	...i $g(count(smonth,sward,"P","WARD","other"))="" s count(smonth,sward,"P","WARD","other")=0
	...i $g(count(smonth,sward,"S","WARD","1"))="" s count(smonth,sward,"S","WARD","1")=0
	...i $g(count(smonth,sward,"S","WARD","2"))="" s count(smonth,sward,"S","WARD","2")=0
	...i $g(count(smonth,sward,"S","WARD","-1"))="" s count(smonth,sward,"S","WARD","-1")=0
	...i $g(count(smonth,sward,"S","WARD","other"))="" s count(smonth,sward,"S","WARD","other")=0
	...i $g(visit(smonth,sward,"P","Y"))="" s visit(smonth,sward,"P","Y")=0 //获取回访的记录总数
	...i $g(visit(smonth,sward,"S","Y"))="" s visit(smonth,sward,"S","Y")=0 //获取回访的记录总数
	...s srowid="" f  s srowid=$O(tmp(sward,stype,smonth,srowid)) q:srowid=""  d
	....i stype="P" s sum(smonth,sward,"P","WARD")=sum(smonth,sward,"P","WARD")+1
	....i stype="S" s sum(smonth,sward,"S","WARD")=sum(smonth,sward,"S","WARD")+1
	....i ((tmp(sward,stype,smonth,srowid)=1)&&(stype="P")) d
	.....//获取某月技术操作 满意的记录数
	.....s count(smonth,sward,"P","WARD","1")=count(smonth,sward,"P","WARD","1")+1
	....e  i ((tmp(sward,stype,smonth,srowid)=2)&&(stype="P")) d
	.....//获取某月技术操作 不满意的记录数
	.....s count(smonth,sward,"P","WARD","2")=count(smonth,sward,"P","WARD","2")+1
	....e  i ((tmp(sward,stype,smonth,srowid)="")&&(stype="P")) d
	.....//获取某月技术操作 没有回复短信的记录数
	.....s count(smonth,sward,"P","WARD","-1")=count(smonth,sward,"P","WARD","-1")+1
	....e  i (((tmp(sward,stype,smonth,srowid)'=1)&&(tmp(sward,stype,smonth,srowid)'=2)&&(tmp(sward,stype,smonth,srowid)'=-1))&&(stype="P")) d
	.....//获取某月技术操作 回复其他内容的记录数
	.....s count(smonth,sward,"P","WARD","other")=count(smonth,sward,"P","WARD","other")+1
	....e  i ((tmp(sward,stype,smonth,srowid)=1)&&(stype="S")) d
	.....//获取某月服务 满意的记录数
	.....s count(smonth,sward,"S","WARD","1")=count(smonth,sward,"S","WARD","1")+1
	....e  i ((tmp(sward,stype,smonth,srowid)=2)&&(stype="S")) d
	.....//获取某月服务 不满意的记录数
	.....s count(smonth,sward,"S","WARD","2")=count(smonth,sward,"S","WARD","2")+1
	....e  i ((tmp(sward,stype,smonth,srowid)="")&&(stype="S")) d
	.....//获取某月服务 没有回复短信的记录数
	.....s count(smonth,sward,"S","WARD","-1")=count(smonth,sward,"S","WARD","-1")+1
	....e  i (((tmp(sward,stype,smonth,srowid)'=1)&&(tmp(sward,stype,smonth,srowid)'=2)&&(tmp(sward,stype,smonth,srowid)'=-1))&&(stype="S")) d
	.....//获取某月技术操作 回复其他内容的记录数
	.....s count(smonth,sward,"S","WARD","other")=count(smonth,sward,"S","WARD","other")+1
	....i visittmp(smonth,sward,stype,srowid)="Y" s visit(smonth,sward,stype,"Y")=visit(smonth,sward,stype,"Y")+1
	....;i visittmp(smonth,sward,"S",srowid)="Y" s visit(smonth,sward,"S","Y")=visit(smonth,sward,"S","Y")+1
	....i $g(timevisit(smonth,sward,stype,srowid))'="" s ctimevisit(smonth,sward,stype)=ctimevisit(smonth,sward,stype)+timevisit(smonth,sward,stype,srowid)
	....
	
	//计算全病区的各种率
	
	s allOperaterate=0,allOperatenum=0,allServicerate=0,allServicenum=0
	s allmonth="" f  s allmonth=$O(sum(allmonth)) q:allmonth=""  d
	.s allward="" f  s allward=$O(sum(allmonth,allward)) q:allward=""  d
	..s alltype="" f  s alltype=$O(sum(allmonth,allward,alltype)) q:alltype=""  d
	...i alltype="P" s allOperatenum=allOperatenum+sum(allmonth,allward,alltype,"WARD") //病区操作总人数
	...i alltype="S" s allServicenum=allServicenum+sum(allmonth,allward,alltype,"WARD") //病区服务总人数
	
	s allReplyOperate=0,allReplyService=0
	s allCountOpersum=0,allCountSersum=0,allCountOpNullsum=0,allCountSerNullsum=0,allCountOpNosum=0,allCountSerNosum=0,allCountOthersum=0
	s allCountMonth="" f  s allCountMonth=$O(count(allCountMonth)) q:allCountMonth=""  d
	.s allCountWard="" f  s allCountWard=$O(count(allCountMonth,allCountWard)) q:allCountWard=""  d
	..s allCountType="" f  s allCountType=$O(count(allCountMonth,allCountWard,allCountType)) q:allCountType=""  d
	...s allCountReType="" f  s allCountReType=$O(count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType)) q:allCountReType=""  d
	....i ((allCountType="P")&&(allCountReType="1")) s allCountOpersum=allCountOpersum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //技术操作满意总人数
	....i ((allCountType="S")&&(allCountReType="1")) s allCountSersum=allCountSersum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //服务满意总人数
	....
	....i ((allCountType="P")&&(allCountReType="-1")) s allCountOpNullsum=allCountOpNullsum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //技术操作没回复的总人数
	....i ((allCountType="S")&&(allCountReType="-1")) s allCountSerNullsum=allCountSerNullsum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //服务态度没有回复的总人数
	....i ((allCountType="P")&&(allCountReType="2")) s allCountOpNosum=allCountOpNosum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //技术操作不满意的总数
	....i ((allCountType="S")&&(allCountReType="2")) s allCountSerNosum=allCountSerNosum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //服务满意不满意的总数
	....i allCountReType="other" s allCountOthersum=allCountOthersum+count(allCountMonth,allCountWard,allCountType,"WARD",allCountReType) //其他回复总数
    
    i (allOperatenum'=0&&(allOperatenum-allCountOpNullsum)'=0) d
    .s allOperaterate=$fn((allCountOpersum/(allOperatenum-allCountOpNullsum)),"",2)*100_"%"
    .s allReplyOperate=$fn(((allOperatenum-allCountOpNullsum)/allOperatenum),"",2)*100_"%"
    i ((allServicenum'=0)&&(allServicenum-allCountSerNullsum)'=0) d
	.s allServicerate=$fn((allCountSersum/(allServicenum-allCountSerNullsum)),"",2)*100_"%"
	.s allReplyService=$fn(((allServicenum-allCountSerNullsum)/allServicenum),"",2)*100_"%"
	
	s allVisitOperate=0,allVisitOpernum=0,allVisitSerate=0,allVisitSersum=0
	s allVisitMonth="" f  s allVisitMonth=$O(visit(allVisitMonth)) q:allVisitMonth=""  d
	.s allVisitWard="" f  s allVisitWard=$O(visit(allVisitMonth,allVisitWard)) q:allVisitWard=""  d
	..s allVisitType="" f  s allVisitType=$O(visit(allVisitMonth,allVisitWard,allVisitType)) q:allVisitType=""  d
	...s allReVisitType="" f  s allReVisitType=$O(visit(allVisitMonth,allVisitWard,allVisitType,allReVisitType)) q:allReVisitType=""  d
	....i allVisitType="P" s allVisitOpernum=allVisitOpernum+visit(allVisitMonth,allVisitWard,allVisitType,allReVisitType) //计算技术操作回访的总数
	....i allVisitType="S" s allVisitSersum=allVisitSersum+visit(allVisitMonth,allVisitWard,allVisitType,allReVisitType) //计算服务满意回访的总数
	i allCountOpNosum'=0 d
	.s allVisitOperate=$fn(allVisitOpernum/allCountOpNosum,"",2)*100_"%"
	i allCountSerNosum'=0 d
	.s allVisitSerate=$fn(allVisitSersum/allCountSerNosum,"",2)*100_"%"
	
	s timeVisitOpernum=0,timeVisitSernum=0
	s timeVisitMonth="" f  s timeVisitMonth=$O(timevisit(timeVisitMonth)) q:timeVisitMonth=""  d
	.s timeVisitWard="" f  s timeVisitWard=$O(timevisit(timeVisitMonth,timeVisitWard)) q:timeVisitWard=""  d
	..s timeVisitType="" f  s timeVisitType=$O(timevisit(timeVisitMonth,timeVisitWard,timeVisitType)) q:timeVisitType=""  d
	...s timeVisitRw="" f  s timeVisitRw=$O(timevisit(timeVisitMonth,timeVisitWard,timeVisitType,timeVisitRw)) q:timeVisitRw=""  d
	....i timeVisitType="P" s timeVisitOpernum=timeVisitOpernum+timevisit(timeVisitMonth,timeVisitWard,timeVisitType,timeVisitRw)
	....i timeVisitType="S" s timeVisitSernum=timeVisitSernum+timevisit(timeVisitMonth,timeVisitWard,timeVisitType,timeVisitRw)
	s timeVisitOperRate=0,timeVisitSerRate=0
	i ((allCountOpNosum'="")&&(allCountOpNosum'=0)) d
	.s timeVisitOperRate=$fn(timeVisitOpernum/allCountOpNosum,"",2)*100_"%"
	i ((allCountSerNosum'="")&&(allCountSerNosum'=0)) d
	.s timeVisitSerRate=$fn(timeVisitSernum/allCountSerNosum,"",2)*100_"%"
	
	s ret="scmonth|"_"全部"_"^warddesc|"_"^operaterate|"_allOperaterate_"^operatesum|"_allOperatenum_"^replyoprate|"_allReplyOperate_"^visitoprate|"_allVisitOperate_"^timeVisitOperRate|"_timeVisitOperRate_"^servicerate|"_allServicerate_"^servicesum|"_allServicenum_"^replyserate|"_allReplyService_"^visitserate|"_allVisitSerate_"^othersum|"_allCountOthersum_"^timeVisitSerRate|"_timeVisitSerRate_"^wardcode|0"
	d OutputMonthSatiData
	;b ;110
	s scmonth="" f  s scmonth=$O(sum(scmonth)) q:scmonth=""  d
	.s scward="" f  s scward=$O(sum(scmonth,scward)) q:scward=""  d
	..s operaterate=0,operatenum=0,servicerate=0,servicenum=0,othersum=0,replyoprate=0,replyserate=0,visitoprate=0,visitserate=0
	..s timeVisitOpernum=0,timeVisitSernum=0,timeVisitOperRate=0,timeVisitSerRate=0
	..s sctype="" f  s sctype=$O(sum(scmonth,scward,sctype)) q:sctype=""  d
	...s scnum="" f  s scnum=$O(count(scmonth,scward,sctype,"WARD",scnum)) q:scnum=""  d
	....s othersum=count(scmonth,scward,sctype,"WARD","other")
	....i sctype="P" d
	.....s operatesum=sum(scmonth,scward,sctype,"WARD")-count(scmonth,scward,sctype,"WARD","-1") //操作总人数
	.....s operatenum=count(scmonth,scward,sctype,"WARD","1") //操作满意人数
	.....i ((operatesum'="")&&(operatesum'=0)&&(operatenum'="")) d
	......s operaterate=$fn((operatenum/operatesum),"",2)*100_"%" //操作满意率
	.....i operatesum=0 d
	......s operaterate="无"
	.....i ((operatesum'=0)&&(operatesum'="")&&(sum(scmonth,scward,sctype,"WARD")'="")&&(sum(scmonth,scward,sctype,"WARD")'=0)) d
	......s replyoprate=$fn(operatesum/sum(scmonth,scward,sctype,"WARD"),"",2)*100_"%"
	.....i ((count(scmonth,scward,sctype,"WARD","2")'="")&&(count(scmonth,scward,sctype,"WARD","2")'=0)&&(visit(scmonth,scward,sctype,"Y")'="")) d //回访率 = 回访的记录数/不满意的记录总数 
	......s visitoprate=$fn(visit(scmonth,scward,sctype,"Y")/count(scmonth,scward,sctype,"WARD","2"),"",2)*100_"%"
	.....i count(scmonth,scward,sctype,"WARD","2")=0 s visitoprate=0
	.....s timeVisitOpernum=ctimevisit(scmonth,scward,sctype) //病区按时回访总数
	.....i ((count(scmonth,scward,sctype,"WARD","2")'="")&&(count(scmonth,scward,sctype,"WARD","2")'=0)) d
	......s timeVisitOperRate=$fn(timeVisitOpernum/count(scmonth,scward,sctype,"WARD","2"),"",2)*100_"%"
	....i sctype="S" d
	.....s servicesum=sum(scmonth,scward,sctype,"WARD")-count(scmonth,scward,sctype,"WARD","-1") //服务总人数
	.....s servicenum=count(scmonth,scward,sctype,"WARD","1") //服务满意人数
	.....i ((servicesum'="")&&(servicesum'=0)&&(servicenum'="")) d
	......s servicerate=$fn((servicenum/servicesum),"",2)*100_"%"
	.....i servicesum=0 d
	......s servicerate="无"
	.....i ((servicesum'="")&&(sum(scmonth,scward,sctype,"WARD")'="")&&(sum(scmonth,scward,sctype,"WARD")'=0)) d
	......s replyserate=$fn(servicesum/sum(scmonth,scward,sctype,"WARD"),"",2)*100_"%"
	.....i ((count(scmonth,scward,sctype,"WARD","2")'="")&&(count(scmonth,scward,sctype,"WARD","2")'=0)&&(visit(scmonth,scward,sctype,"Y")'="")) d
	......s visitserate=$fn(visit(scmonth,scward,sctype,"Y")/count(scmonth,scward,sctype,"WARD","2"),"",2)*100_"%"
	.....i count(scmonth,scward,sctype,"WARD","2")=0 s visitserate=0
	.....i ((count(scmonth,scward,sctype,"WARD","2")'="")&&(count(scmonth,scward,sctype,"WARD","2")'=0)) d
	......s timeVisitSerRate=$fn(timeVisitSerRate/count(scmonth,scward,sctype,"WARD","2"),"",2)*100_"%"
	..s warddesc=$P($P($g(^CTLOC(scward)),"^",2),"-",2)
	..s ret="scmonth|"_scmonth_"^warddesc|"_warddesc_"^operaterate|"_operaterate_"^operatesum|"_operatesum_"^replyoprate|"_replyoprate_"^visitoprate|"_visitoprate_"^timeVisitOperRate|"_timeVisitOperRate_"^servicerate|"_servicerate_"^servicesum|"_servicesum_"^replyserate|"_replyserate_"^visitserate|"_visitserate_"^timeVisitSerRate|"_timeVisitSerRate_"^othersum|"_othersum_"^wardcode|"_scward
	..do OutputMonthSatiData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputMonthSatiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMonthSatiSurveyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMonthSatiSurveyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMonthSatiSurveyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMonthSatiSurveyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getSatiSurveyForType(stdate, enddate, ward, type) As %String
{
	//stdate="64618" enddate="64648"  s ^DHCNMG.Survey.MgNurPatSatisI("SType",64641," 118"," P",1)
	s ret=""
	s count=0,count("1")=0,count("2")=0,count("-1")=0,count("other")=0
	s date="" f  s date=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))
	.q:((enddate'="")&&(date>enddate))
	.s sward="" f  s sward=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,sward)) q:sward=""  d
	..q:((ward'="")&&($tr(sward," ","")'=ward))
	..s stype="" f  s stype=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,sward,stype)) q:stype=""  d
	...q:((type'="")&&($tr(stype," ","")'=type))
	...s srow="" f  s srow=$O(^DHCNMG.Survey.MgNurPatSatisI("SType",date,sward,stype,srow)) q:srow=""  d
	....s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(srow)
	....s count=count+1 //总数
	....i obj.ReplyType="1" s count("1")=count("1")+1 //满意人数
	....e  i obj.ReplyType="2" s count("2")=count("2")+1 //不满意的人数
	....e  i obj.ReplyType="" s count("-1")=count("-1")+1 //未回复的人数
	....e  s count("other")=count("other")+1 //其他的人数
	s ret="count|"_count_"^count(""1"")|"_count("1")_"^count(""2"")|"_count("2")_"^count(""-1"")|"_count("-1")_"^count(""other"")|"_count("other")
	q ret
}

/// Creator:
/// Description:查询患者满意度发送短信数据
/// Date:2017-12-25
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:
/// Output：
/// Return:
/// Others:
Query FindSendMessage(stdate As %String = "", enddate As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSendMessageExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	;s ^TMP("sendmessagestdate")=stdate_"%"_enddate
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s date="" f  s date=$O(^DHCNMG.Survey.MgNurPatSatisI("send",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))
	.q:((enddate'="")&&(date>enddate))
	.s rowid="" f  s rowid=$O(^DHCNMG.Survey.MgNurPatSatisI("send",date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
	..i obj.SendDate'="" s SendDate=$zd(obj.SendDate,3)
	..e  s SendDate=""
	..i obj.SendTime'="" s SendTime=$zt(obj.SendTime,1)
	..e  s SendTime=""
	..s PatPMINo=obj.PatPMINo
	..s patmasrow=$O(^PAPERi("PAPMI_PatNo",$zcvt(PatPMINo,"U"),""))
	..q:patmasrow=""
	..s patmasobj=##class(User.PAPatMas).%OpenId(patmasrow)
	..q:'$IsObject(patmasobj)
	..s patname=patmasobj.PAPMIName
	..s SendPhone=obj.SendPhone
	..s ReplyType=obj.ReplyType
	..i obj.ReplyDate'="" s ReplyDate=$zd(obj.ReplyDate,3)
	..e  s ReplyDate=""
	..i obj.ReplyTime'="" s ReplyTime=$zt(obj.ReplyTime,1)
	..e  s ReplyTime=""
	..s ret="SendDate|"_SendDate_"^SendTime|"_SendTime_"^patname|"_patname_"^SendPhone|"_SendPhone_"^ReplyType|"_ReplyType_"^ReplyDate|"_ReplyDate_"^ReplyTime|"_ReplyTime_"^rowid|"_rowid
	..do OutputSatiData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSatiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSendMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSendMessageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSendMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSendMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReplyRate(stdate As %String, enddate As %String) As %String
{
	s ret=""
	;s ^TMP("replyparr")=stdate_"%"_enddate
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s sum=0,count=0
	s date="" f  s date=$O(^DHCNMG.Survey.MgNurPatSatisI("stdate",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))
	.q:((enddate'="")&&(date>enddate))
	.s rowid="" f  s rowid=$O(^DHCNMG.Survey.MgNurPatSatisI("stdate",date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
	..s sum=sum+1
	..i obj.ReplyType'="" s count=count+1
	i sum'=0 s replyrate=$fn((count/sum),"",2)*100_"%"
	i sum=0 s replyrate=0
	q replyrate
}

/// Creator:
/// Description:查询患者满意率等
/// Date:2018-01-02
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:stdate:开始日期 enddate:结束日期 type:满意类型（P:操作满意度 S：服务满意度） Typ:(1:满意 2:不满意  其他) 
/// Output：
/// Return:
/// Others:
Query FindSurveyRate(stdate As %String = "", enddate As %String = "", type As %String = "", Typ As %String = "", ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSurveyRateExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate As %String = "", type As %String = "", Typ As %String = "", ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("surveyrate")=stdate_"%"_enddate_"%"_type_"%"_Typ_"%"_ward
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	
	s date="" f  s date=$O(^DHCNMG.Survey.MgNurPatSatisI("stdate",date)) q:date=""  d
	.q:((stdate'="")&&(date<stdate))
	.q:((enddate'="")&&(date>enddate))
	.s rowid="" f  s rowid=$O(^DHCNMG.Survey.MgNurPatSatisI("stdate",date,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
	..q:((type'="")&&(obj.SatiType'=type))
	..q:((Typ'="")&&(obj.ReplyType'=Typ)&&(Typ'=-1))
	..q:((ward'="")&&(obj.PatWard'=ward))
	..q:((Typ=-1)&&((obj.ReplyType=1)||(obj.ReplyType=2)||(obj.ReplyType="")))
	..s SendDate=""
	..i obj.SendDate'="" s SendDate=$zd(obj.SendDate,3)
	..s SendTime=""
	..i obj.SendTime'="" s SendTime=$zt(obj.SendTime,1)
	..s patrow=$O(^PAPERi("PAPMI_PatNo",$zcvt(obj.PatPMINo,"U"),""))
	..q:patrow=""
	..s patrowobj=##class(User.PAPatMas).%OpenId(patrow)
	..q:'$IsObject(patrowobj)
	..///获取东华HIS住院病人出院记录
	..;s admrowid=$O(^PAPERdr(patrow,"ADM","I",""))
	..;s admobj=##class(User.PAAdm).%OpenId(admrowid)
	..;q:'$IsObject(admobj)
	..;i admobj.PAADMAdmDate'="" s PAADMAdmDate=$zd(admobj.PAADMAdmDate,3)
	..;e  s PAADMAdmDate="" //入院日期
	..//【DHC】HIS住院暂未上线时 军卫系统中的出院病人在【DHC】HIS中没有数据
	..i obj.AdmInDate'="" s PAADMAdmDate=$zd(obj.AdmInDate,3)
	..e  s PAADMAdmDate=""
	..s PatName=patrowobj.PAPMIName //患者姓名
	..s PatPMINo=obj.PatPMINo //登记号
	..s SendPhone=obj.SendPhone //电话
	..s ReplyType=obj.ReplyType //回复内容
	..s PatWard=""
	..i obj.PatWard'="" d
	...s PatWard=$P($P($G(^CTLOC(obj.PatWard)),"^",2),"-",2) //出院病区
	..s OutDate=""
	..i obj.OutDate'="" s OutDate=$zd(obj.OutDate,3) //出院日期
	..e  s OutDate=""
	..s Content=""
	..i obj.SatiType="P" d
	...s setrow=$O(^DHCNMG.DB.MgSurveySetD(""))
	...q:setrow=""
	...s setobj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setrow)
	...s Content=setobj.OperateModel
	...s Content=$replace(Content,"{NAME}",PatName)
	...s Content=$replace(Content,"{TIME}",OutDate)
	...s Content=$replace(Content,"{DEPT}",PatWard)
	...s Content=$replace(Content,"{DAY}",setobj.ReplyValid)	
	..i obj.SatiType="S" d
	...s setrow=$O(^DHCNMG.DB.MgSurveySetD(""))
	...q:setrow=""
	...s setobj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setrow)
	...s Content=setobj.ServiceModel //问题
	...s Content=$replace(Content,"{NAME}",PatName)
	...s Content=$replace(Content,"{TIME}",OutDate)
	...s Content=$replace(Content,"{DEPT}",PatWard)
	...s Content=$replace(Content,"{DAY}",setobj.ReplyValid)
	..s ReplyRecord=obj.ReplyRecord
	..s ApplicateFlag="",AppVisitFlag=""
	..i obj.ApplicateFlag="N" s ApplicateFlag="申请",AppVisitFlag="N"
	..e  i obj.ApplicateFlag="Y" s ApplicateFlag="通过",AppVisitFlag="Y"
	..s ConvertReply=obj.ConvertReply
	..s inputflag=0,inputvisible=0,auditflag=0,visitrow=""
	..s spanret=..GetApplicateFlag2(rowid)
	..s inputflag=$e(spanret,1) // input框显示flag
	..s inputvisible=$e(spanret,2) //input可编辑状态 1 不可编辑 0 可编辑
	..s auditflag=$e(spanret,3) //申请回访按钮flag 1:显示 0:隐藏
	..s status=$e(spanret,4) //操作状态
	..;b ;01 
	..s ret="PatPMINo|"_PatPMINo_"^Content|"_Content_"^PatName|"_PatName_"^SendPhone|"_SendPhone_"^PAADMAdmDate|"_PAADMAdmDate_"^OutDate|"_OutDate_"^PatWard|"_PatWard_"^rowid|"_rowid_"^ReplyType|"_ReplyType_"^ReplyRecord|"_ReplyRecord_"^RecordFlag|false"_"^ApplicateFlag|"_ApplicateFlag_"^ConvertReply|"_ConvertReply_"^AppVisitFlag|"_AppVisitFlag_"^inputflag|"_inputflag_"^inputvisible|"_inputvisible_"^auditflag|"_auditflag_"^status|"_status_"^visitrow|"_rowid
	..do OutputSatiData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSatiData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSurveyRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurveyRateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSurveyRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurveyRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecVisitFlag(id As %String) As %String
{
	s flag=0
	q:id="" -1 //id为空
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(id)
	s now=+$H
	i obj.ConvertDate="" s ReplyDate=obj.ReplyDate //患者回复短信日期
	e  s ReplyDate=obj.ConvertDate
	s setRow=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:setRow=""
	s setObj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setRow)
	i setObj.ReVisitValid="" s visitVal=0
	e  s visitVal=+(setObj.ReVisitValid)
	b ;01
	i ((ReplyDate'="")&&((ReplyDate+visitVal)<now)) d
	.i ((obj.ApplicateFlag="Y")&&(obj.AcceptDate'="")&&((obj.AcceptDate+7)>=now)) s flag=1 //日期超时 但是已经申请回访并通过审核
	.e  i ((obj.ApplicateFlag="Y")&&(obj.AcceptDate'="")&&((obj.AcceptDate+7)<now)) s flag=0
	.e  i ((obj.ApplicateFlag="")||(obj.ApplicateFlag="N")) s flag=0 //日期超时
	i ((ReplyDate="")&&(obj.ReplyType="")) s flag=-2 //没有回复信息
	q flag
}

ClassMethod GetApplicateFlag2(id As %String) As %String
{
	q:id="" "-1" //id为空
	s flag="1000" //此时正常显示Input框
	s now=+$H
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(id)
	q:'$IsObject(obj)
	s ReplyFlag=obj.ReplyFlag //回访标识
	s ReplyDate=obj.ReplyDate //获取病人短信回复日期
	s setRow=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:setRow=""
	s setObj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setRow)
	i setObj.ReVisitValid="" s visitVal=0
	e  s visitVal=+(setObj.ReVisitValid) //回访有效时长
	s convertdate=obj.ConvertDate
	i convertdate'="" //此记录为转成不满意的记录
	{
		s ReplyDate=convertdate
		i (now<(ReplyDate+visitVal)) //在有效期内
		{
			;s flag="100" //正常显示input框
			//已经回访
			i ReplyFlag'=""
			{
				//显示input框并在input框中显示回访内容 禁用可编辑
				//第一个为是否显示input框【1：显示 0：隐藏】第二个为input框的编辑状态【1：不可编辑 0 ：可编辑】
				s flag="1100" 
			}
			else
			{
				s flag="1000"
			}
		}
		else //超出有效期范围
		{
			i ReplyFlag="" //回访标识为空(没有回访)
			{
				s ApplicateFlag=obj.ApplicateFlag
				i ApplicateFlag="" //申请回访标识为空（没有申请回访）
				{
					//第三个为是否显是申请回访按钮【1：显示 0：隐藏】第四个为是否显示未审核状态【1：显示 】
					s flag="0010"
				}
				else //已经申请回访
				{
					i ApplicateFlag="N" //已经申请回访 但是管理员还没有审核通过
					{
						//申请按钮隐藏【护士长：按钮隐藏 管理员：显示审核按钮】
						//申请状态显示为【护士长：“未审核”】
						s flag="0001"
					}
					elseif ApplicateFlag="Y" //已经申请回访 且管理员已经审核通过
					{
						s AcceptDate=obj.AcceptDate
						i (now<(AcceptDate+7)) //审核通过后 在有效期范围内
						{
							s flag="1000"
						}
						else //审核通过后已经超出有效期范围
						{
							s flag="1100"
						}
						
					}
				}
			}
			else //已经回访
			{
				s flag="1100"
			}
		}
	}
	else //正常情况（不满意记录）
	{
		i (now<(ReplyDate+visitVal)) //在有效期范围内
		{
			i ReplyFlag'="" //已经回访
			{
				s flag=1100
			}
			else //没有回访
			{
				s flag=1000
			}
		}
		else //超出病人回复短信的最大回访期范围
		{
			i ReplyFlag="" //回访标识为空(没有回访)
			{
				s ApplicateFlag=obj.ApplicateFlag
				i ApplicateFlag="" //申请回访标识为空（没有申请回访）
				{
					s flag="0010"
				}
				else //已经申请回访
				{
					i ApplicateFlag="N" //已经申请回访 但是管理员还没有审核通过
					{
						//input框隐藏
						//申请按钮隐藏【护士长：按钮隐藏 管理员：显示审核按钮】
						//申请状态显示为【护士长：“已经申请”】
						s flag="0001"
					}
					elseif ApplicateFlag="Y" //已经申请回访 且管理员已经审核通过
					{
						s AcceptDate=obj.AcceptDate
						i (now<(AcceptDate+7)) //审核通过后 在有效期范围内
						{
							//input显示
							s flag="1000"	
						}
						else //审核通过后已经超出有效期范围
						{
							s flag="1100"
						}
					}
				}
			}
			else //已经回访
			{
				s flag="1100"
			}
		}
	}
	q flag
}

/// test
/// 
ClassMethod GetApplicateFlag(id As %String) As %String
{
	q:id="" "-1" //id为空
	s flag="1000" //此时正常显示span标签
	s now=+$H
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(id)
	q:'$IsObject(obj)
	s ReplyFlag=obj.ReplyFlag //回访标识
	s ReplyDate=obj.ReplyDate //获取病人短信回复日期
	s setRow=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:setRow=""
	s setObj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setRow)
	i setObj.ReVisitValid="" s visitVal=0
	e  s visitVal=+(setObj.ReVisitValid) //回访有效时长
	s convertdate=obj.ConvertDate
	i convertdate'="" //此记录为转成不满意的记录
	{
		s ReplyDate=convertdate
		i (now<(ReplyDate+visitVal)) //在有效期内
		{
			s flag="1000"
		}
		else //超出有效期范围
		{
			i ReplyFlag="" //回访标识为空(没有回访)
			{
				s ApplicateFlag=obj.ApplicateFlag
				i ApplicateFlag="" //申请回访标识为空（没有申请回访）
				{
					//span标签隐藏
					//input框隐藏
					//申请按钮显示
					//申请状态隐藏
					s flag="0010"
				}
				else //已经申请回访
				{
					i ApplicateFlag="N" //已经申请回访 但是管理员还没有审核通过
					{
						//span标签隐藏
						//input框隐藏
						//申请按钮隐藏【护士长：按钮隐藏 管理员：显示审核按钮】
						//申请状态显示为【护士长：“已经申请”】
						s flag="0001"
					}
					elseif ApplicateFlag="Y" //已经申请回访 且管理员已经审核通过
					{
						s AcceptDate=obj.AcceptDate
						i (now<(AcceptDate+7)) //审核通过后 在有效期范围内
						{
							//span标签隐藏
							//input显示
							//申请按钮隐藏
							//申请状态隐藏
							s flag="0100"	
						}
						else //审核通过后已经超出有效期范围
						{
							s flag="1000"
						}
						
					}
				}
			}
			else //已经回访
			{
				s flag="1000"
			}
		}
	}
	else //正常情况（不满意记录）
	{
		i (now<(ReplyDate+visitVal)) //在有效期范围内
		{
			s flag="0100"
		}
		else //超出病人回复短信的最大回访期范围
		{
			i ReplyFlag="" //回访标识为空(没有回访)
			{
				s ApplicateFlag=obj.ApplicateFlag
				i ApplicateFlag="" //申请回访标识为空（没有申请回访）
				{
					//span标签隐藏
					//input框隐藏
					//申请按钮显示
					//申请状态隐藏
					s flag="0010"
				}
				else //已经申请回访
				{
					i ApplicateFlag="N" //已经申请回访 但是管理员还没有审核通过
					{
						//span标签隐藏
						//input框隐藏
						//申请按钮隐藏【护士长：按钮隐藏 管理员：显示审核按钮】
						//申请状态显示为【护士长：“已经申请”】
						s flag="0001"
					}
					elseif ApplicateFlag="Y" //已经申请回访 且管理员已经审核通过
					{
						s AcceptDate=obj.AcceptDate
						i (now<(AcceptDate+7)) //审核通过后 在有效期范围内
						{
							//span标签隐藏
							//input显示
							//申请按钮隐藏
							//申请状态隐藏
							s flag="0100"	
						}
						else //审核通过后已经超出有效期范围
						{
							s flag="1000"
						}
						
					}
				}
			}
			else //已经回访
			{
				s flag="1000"
			}
		}
	}
	
	q flag
}

/// 获取申请回访的标识【暂不使用】
ClassMethod GetApplicateFlag1(id As %String) As %String
{
	q:id="" -1 //id为空
	s flag="000"
	s now=+$H
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(id)
	q:'$IsObject(obj)
	s ReplyFlag=obj.ReplyFlag
	s ReplyDate=obj.ReplyDate //获取病人短信回复日期
	s setRow=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:setRow=""
	s setObj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setRow)
	i setObj.ReVisitValid="" s visitVal=0
	e  s visitVal=+(setObj.ReVisitValid) //回访有效时长
	
	i ReplyFlag="" //回访标识为空
	{
		b ;01
		i (now<(ReplyDate+visitVal)) //病人回复短信有效期内
		{
			//input框正常显示
			//申请回访的按钮隐藏
			//不显示任何状态
			s flag="100"
		}
		else //已经超过病人回复短信的有效期 就要申请回访
		{
			s ApplicateFlag=obj.ApplicateFlag
			i ApplicateFlag="" //申请标识为空
			{
				//input框隐藏
				//申请回访按钮显示
				//不显示任何状态
				s flag="010"
			}
			else //申请标识不为空
			{
				i ApplicateFlag="N" //已经申请回访,但是管理员并没有审核通过
				{
					//input框隐藏
					//申请的回访按钮隐藏
					//护士长：状态显示 “未审核”  管理员：显示审核的按钮
					s flag="001"
				}
				else //已经申请回访 并且管理员已经审核通过
				{
					s AcceptDate=obj.AcceptDate
					i (now<(AcceptDate+7))
					{
						//input框正常显示
						//申请的回访按钮隐藏
						//不显示任何状态
						s flag="100"
					}
					else
					{
						s flag="000"
					}
					
				}
			}
		}
		
	}
	else //回访标识不为空
	{
		b ;02
		s flag="000"
	}
	q flag
}

ClassMethod SaveVisitInfo(parr As %String) As %String
{
	;s ^TMP("savevisitinfo")=parr //ReplyRecord|ceshi^ReplyUser|0^ReplyFlag|N^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	q:id="" 0
	s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(id)
	s obj.ReplyRecord=$tr(tmp("ReplyRecord")," ","")
	s obj.ReplyUser=$tr(tmp("ReplyUser")," ","")
	s obj.ReplyFlag=$tr(tmp("ReplyFlag")," ","")
	s obj.VisitDate=+$h
	s sc=obj.%Save()
	
	q $$$ISOK(sc)
}

/// Creator:
/// Description:将其他回复的转为满意或不满意记录
/// Date:2018-01-22
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:【type=1转为满意 type=2转为不满意】
/// Output：
/// Return:
/// Others:
ClassMethod ConvertType(type As %String, parr As %String) As %String
{
	s ^TMP("converttype")=type_"%"_parr
	//2%26^27|1
	s record=$P(parr,"|",1)
	s user=$P(parr,"|",2)
	s len=$l(record,"^")
	b ;01
	for i=1:1:len
	{
		s itm=$p(record,"^",i)
		i itm="" continue
		s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(itm)
		s obj.ConvertReply=obj.ReplyType
		s obj.ReplyType=type
		s obj.ConvertDate=+$h
		s obj.ConvertUser=user
		s sc=obj.%Save()
	}
	q 0
}

ClassMethod IsCheckedFlag() As %String
{
}

/// Creator:
/// Description:对不满意的记录超过规定的日期没有进行回访的进行申请操作
/// Date:2018-01-23
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ChangeCheckedFlag(parr As %String, user As %String) As %String
{
	s ^TMP("changecheckedflag")=parr_"$"_user
	q:parr="" ""
	s ret=0
	//获取回访的有效期
	s setRow=$O(^DHCNMG.DB.MgSurveySetD(""))
	q:setRow="" "0"
	s setObj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setRow)
	s ReVisitValid=setObj.ReVisitValid
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s rowid=$p(parr,"^",i)
		i rowid="" continue
		s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
		s ReplyRecord=obj.ReplyRecord
		s ReplyDate=obj.ReplyDate //患者回复短信日期
		//当回访记录为空 并且已经超出日期限制
		
		i ((ReplyRecord="")&&(ReplyDate'="")&&((ReplyDate+ReVisitValid)<+$H)&&(obj.ApplicateFlag=""))
		{
			s obj.ApplicateFlag="N"
			s obj.ApplicateUser=user //HIS user表id
			s obj.ApplicateDate=+$H
			s sc=obj.%Save()
			s ret=$$$ISOK(sc)
		}
	}
	q ret
}

/// Creator:
/// Description:对申请回访记录进行审核
/// Date:2018-01-23
/// Table:DHCNMG.Survey.MgNurPatSatis
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod AppAuditRec(parr As %String, user As %String) As %String
{
	q:parr="" ""
	s ret=0
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s rowid=$p(parr,"^",i)
		i rowid="" continue
		s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(rowid)
		i (obj.ApplicateFlag="N")
		{
			s obj.ApplicateFlag="Y"
			s obj.AcceptUser=user
			s obj.AcceptDate=+$H
			s sc=obj.%Save()
			s ret=$$$ISOK(sc)
		}
	}
	q ret
}

/// Creator:
/// Description:获取HIS病区
/// Date:2018-01-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindHISWard(ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindHISWardExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	/*
	s Ward="" f  s Ward=$O(^PAWARD(0,"WARD_Desc",Ward)) q:Ward=""  d
	.s RowID="" f  s RowID=$O(^PAWARD(0,"WARD_Desc",Ward,RowID)) q:RowID=""  d
	..s WardDescStr=$P($g(^PAWARD(RowID)),"^",2)
	..q:((ward'="")&&(WardDescStr'[$zcvt(ward,"U")))
	..s WardDesc=$g(WardDescStr)
	..s ret="WardDesc|"_WardDesc_"^WardRowID|"_RowID
	..do OutputHISWardData
	*/
	s desc="" f  s desc=$O(^CTLOC(0,"Desc",desc)) q:desc=""  d
	.s RowID="" f  s RowID=$O(^CTLOC(0,"Desc",desc,RowID)) q:RowID=""  d
	..s WardDescStr=$p($g(^CTLOC(RowID)),"^",2)
	..q:((ward'="")&&(WardDescStr'[$zcvt(ward,"U")))
	..s WardDesc=$g(WardDescStr)
	..s ret="WardDesc|"_WardDesc_"^WardRowID|"_RowID
	..do OutputHISWardData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHISWardData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHISWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHISWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHISWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHISWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 保存满意度病区数据
ClassMethod SaveWardSet(parr As %String) As %String
{
	s ^TMP("savewardset")=parr
	//WardSetDesc|产房^WardSetCode|产房^WardSetLink|31^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExistWard(tmp("WardSetDesc"),id)
	q:flag=1 "此记录已经存在"
	i id="" s obj=##class(DHCNMG.Survey.SetWard).%New()
	e  s obj=##class(DHCNMG.Survey.SetWard).%OpenId(id)
	s obj.WardSetCode=$zcvt($tr($g(tmp("WardSetCode"))," ",""),"U")
	s obj.WardSetDesc=$zcvt($tr($g(tmp("WardSetDesc"))," ",""),"U")
	s obj.WardSetLink=$g(tmp("WardSetLink"))
	s obj.WardSetSpell=##class(web.NurMgVueComm).ToChineseSpell($g(tmp("WardSetDesc")))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExistWard(desc As %String, id As %String) As %String
{
	s flag=0
	s rowid=$O(^DHCNMG.Survey.SetWardI("Desc"," "_$zcvt($tr(desc," ",""),"U"),""))
	b ;01
	i rowid="" s flag=0
	e  d
	.b ;02
	.i ((id'="")&&(rowid'=id)) s flag=1
	.e  i ((id'="")&&(rowid=id)) s flag=0
	.e  i id="" s flag=1
	q flag
}

/// Creator:
/// Description:获取病区列表
/// Date:2018-01-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindWardDataList(ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardDataListExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s spell="" f  s spell=$O(^DHCNMG.Survey.SetWardI("spell",spell)) q:spell=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.Survey.SetWardI("spell",spell,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
	..s warddesc=obj.WardSetDesc
	..s wardcode=obj.WardSetCode
	..s wardLink=""
	..i obj.WardSetLink'="" d
	...;s wardLink=$P($g(^PAWARD(obj.WardSetLink)),"^",2)
	...s wardLink=$P($g(^CTLOC(obj.WardSetLink)),"^",2)
	..s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^wardLink|"_wardLink_"^rowid|"_RowID
	..do OutputWardDataList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardDataList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWardData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.Survey.SetWard).%OpenId(id)
	s WardSetDesc=obj.WardSetDesc
	s WardSetCode=obj.WardSetCode
	s WardSetLink=obj.WardSetLink
	s ret="WardSetDesc|"_WardSetDesc_"^WardSetCode|"_WardSetCode_"^WardSetLink|"_WardSetLink_"^RowID|"_id
	q ret
}

ClassMethod SaveNurHeadData(parr As %String) As %String
{
	s ^TMP("savenurheaddata")=parr
	//NurHeadName|冯红^NurHeadNo|411^NurHeadHISNo|411^NurHeadWard|1^RowID|
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExistNurHead(tmp("NurHeadNo"),id)
	q:flag=1 "此记录已经存在"
	i id="" s obj=##class(DHCNMG.Survey.MgNurHead).%New()
	e  s obj=##class(DHCNMG.Survey.MgNurHead).%OpenId(id)
	s obj.NurHeadHISNo=$zcvt($tr($g(tmp("NurHeadHISNo"))," ",""),"U")
	s obj.NurHeadName=$zcvt($tr($g(tmp("NurHeadName"))," ",""),"U")
	s obj.NurHeadNo=$zcvt($tr($g(tmp("NurHeadNo"))," ",""),"U")
	s obj.NurHeadWard=$g(tmp("NurHeadWard"))
	s obj.NurHeadType=$zcvt($tr($g(tmp("NurHeadType"))," ",""),"U")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod IsExistNurHead(code As %String, id As %String) As %String
{
	s flag=0
	s rowid=$O(^DHCNMG.Survey.MgNurHeadI("HeadNo"," "_$zcvt($tr(code," ",""),"U"),""))
	i rowid="" s flag=0
	e  d
	.i ((id'="")&&(rowid'=id)) s flag=1
	.e  i ((id'="")&&(rowid=id)) s flag=0
	.e  i id="" s flag=1
	q flag
}

/// Creator:
/// Description:获取护士长列表
/// Date:2018-01-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindNurHeadList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurHeadListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s HeadNo="" f  s HeadNo=$O(^DHCNMG.Survey.MgNurHeadI("HeadNo",HeadNo)) q:HeadNo=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.Survey.MgNurHeadI("HeadNo",HeadNo,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.Survey.MgNurHead).%OpenId(RowID)
	..q:((parr'="")&&(obj.NurHeadType'=parr))
	..s nurheadname=obj.NurHeadName
	..s nurheadno=obj.NurHeadNo
	..s nurheadhisno=obj.NurHeadHISNo
	..s nurheadward=""
	..i obj.NurHeadWard'="" d
	...s wardobj=##class(DHCNMG.Survey.SetWard).%OpenId(obj.NurHeadWard)
	...q:'$IsObject(wardobj)
	...s nurheadward=wardobj.WardSetDesc
	..s NurHeadType=""
	..i obj.NurHeadType="N" s NurHeadType="护士长"
	..e  i obj.NurHeadType="A" s NurHeadType="管理员"
	..i obj.NurHeadType="A" s nurheadward="全部"
	..s ret="nurheadname|"_nurheadname_"^nurheadno|"_nurheadno_"^nurheadhisno|"_nurheadhisno_"^nurheadward|"_nurheadward_"^rowid|"_RowID_"^nurheadtype|"_NurHeadType
	..do OutputNurHeadList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurHeadList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHeadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurHeadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHeadData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.Survey.MgNurHead).%OpenId(id)
	s NurHeadName=obj.NurHeadName
	s NurHeadNo=obj.NurHeadNo
	s NurHeadHISNo=obj.NurHeadHISNo
	s NurHeadWard=obj.NurHeadWard
	s NurHeadType=obj.NurHeadType
	s ret="NurHeadName|"_NurHeadName_"^NurHeadNo|"_NurHeadNo_"^NurHeadHISNo|"_NurHeadHISNo_"^NurHeadWard|"_NurHeadWard_"^RowID|"_id_"^NurHeadType|"_NurHeadType
	q ret
}

/// Creator:
/// Description:病区列表
/// Date:2018-01-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindNurHeadWard(ward As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurHeadWardExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ret="warddesc|"_"全部"_"^wardcode|"_"全部"_"^wardLink|"_"0"_"^rowid|0"
	do OutputNurHeadWard
	s ret=""
	s spell="" f  s spell=$O(^DHCNMG.Survey.SetWardI("spell",spell)) q:spell=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.Survey.SetWardI("spell",spell,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
	..s warddesc=obj.WardSetDesc
	..s wardcode=obj.WardSetCode
	..s wardLink=""
	..i obj.WardSetLink'="" d
	...s wardLink=$P($g(^PAWARD(obj.WardSetLink)),"^",2)
	..s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^wardLink|"_wardLink_"^rowid|"_RowID
	..do OutputNurHeadWard
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurHeadWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHeadWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurHeadWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:初始化病区
/// Date:2018-01-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query InitWardStore(loginname As %String, nurse As %String, role As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod InitWardStoreExecute(ByRef qHandle As %Binary, loginname As %String, nurse As %String, role As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("initwardstore")=loginname_"%"_nurse_"%"_role //1087%
	i loginname="DEMO"
	{
		s ret="warddesc|"_"全部"_"^wardcode|"_"全部"_"^wardLink|"_"0"_"^RowID|0"
		do OutputNurHeadWard
		s spell="" f  s spell=$O(^DHCNMG.Survey.SetWardI("spell",spell)) q:spell=""  d
		.s RowID="" f  s RowID=$O(^DHCNMG.Survey.SetWardI("spell",spell,RowID)) q:RowID=""  d
		..s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
		..s warddesc=obj.WardSetDesc
		..s wardcode=obj.WardSetCode
		..s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^RowID|"_RowID
		..d OutputNurHeadWard
	}
	else
	{
		i role="N"
		{
			s rw=$O(^DHCNMG.Survey.MgNurHeadI("HISNO"," "_loginname,""))
			q:rw="" ""
			s obj1=##class(DHCNMG.Survey.MgNurHead).%OpenId(rw)
			q:'$IsObject(obj1)
			;s wardcode=obj1.NurHeadWard
			s warddesc="",wardcode=""
			i obj1.NurHeadWard'="" d
			.s wardobj=##class(DHCNMG.Survey.SetWard).%OpenId(obj1.NurHeadWard)
			.s warddesc=wardobj.WardSetDesc
			.s wardcode=wardobj.WardSetCode
			s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^RowID|"_obj1.NurHeadWard
			d OutputNurHeadWard
			
		}
		elseif role="A"
		{
			s ret="warddesc|"_"全部"_"^wardcode|"_"全部"_"^wardLink|"_"0"_"^RowID|0"
			do OutputNurHeadWard
			s spell="" f  s spell=$O(^DHCNMG.Survey.SetWardI("spell",spell)) q:spell=""  d
			.s RowID="" f  s RowID=$O(^DHCNMG.Survey.SetWardI("spell",spell,RowID)) q:RowID=""  d
			..s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
			..s warddesc=obj.WardSetDesc
			..s wardcode=obj.WardSetCode
			..s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^RowID|"_RowID
			..d OutputNurHeadWard
		}
	}
	/*
	s ret="warddesc|"_"全部"_"^wardcode|"_"全部"_"^wardLink|"_"0"_"^rowid|0"
	do OutputNurHeadWard
	s ret=""
	s spell="" f  s spell=$O(^DHCNMG.Survey.SetWardI("spell",spell)) q:spell=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.Survey.SetWardI("spell",spell,RowID)) q:RowID=""  d
	..s obj=##class(DHCNMG.Survey.SetWard).%OpenId(RowID)
	..s warddesc=obj.WardSetDesc
	..s wardcode=obj.WardSetCode
	..s wardLink=""
	..i obj.WardSetLink'="" d
	...s wardLink=$P($g(^PAWARD(obj.WardSetLink)),"^",2)
	..s ret="warddesc|"_warddesc_"^wardcode|"_wardcode_"^wardLink|"_wardLink_"^rowid|"_RowID
	..do OutputNurHeadWard
	*/
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurHeadWard
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InitWardStoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InitWardStoreExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InitWardStoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InitWardStoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取护士登录权限
ClassMethod GetNurseLimit(nurse As %String) As %String
{
	s ^TMP("getnurselimit")=nurse //1087
	s ret=""
	s list=^SSU("SSUSR",nurse)
	i list'="" d
	.s HISNO=$p(list,"^",1)
	.s RowID=$O(^DHCNMG.Survey.MgNurHeadI("HISNO"," "_$zcvt($tr(HISNO," ",""),"U"),""))
	.i RowID'="" d
	..s obj=##class(DHCNMG.Survey.MgNurHead).%OpenId(RowID)
	..s role=obj.NurHeadType
	..s ward=obj.NurHeadWard
	..s ret=role_"^"_ward
	q ret
}

/// Creator:
/// Description:获取全部的其他回复记录信息
/// Date:2018-02-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindAllOtherInfo(ward As %String = "", stdate As %String, enddate As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAllOtherInfoExecute(ByRef qHandle As %Binary, ward As %String = "", stdate As %String, enddate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("findallotherinfos")=ward_"%"_stdate_"%"_enddate
	i stdate'="" s stdate=$zdh(stdate,3)
	i enddate'="" s enddate=$zdh(enddate,3)
	s wardloc=""
	i (ward'="")&&(ward'=0) d
	.s LocObj=##class(DHCNMG.Survey.SetWard).%OpenId(ward)
	.q:'$IsObject(LocObj)
	.s wardloc=LocObj.WardSetLink
	s Loc="" f  s Loc=$O(^DHCNMG.Survey.MgNurPatSatisI("loc",Loc)) q:Loc=""  d
	.s Date="" f  s Date=$O(^DHCNMG.Survey.MgNurPatSatisI("loc",Loc,Date)) q:Date=""  d
	..s RowID="" f  s RowID=$O(^DHCNMG.Survey.MgNurPatSatisI("loc",Loc,Date,RowID)) q:RowID=""  d
	...s Obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(RowID)
	...q:((stdate'="")&&(Date<stdate))
	...q:((enddate'="")&&(Date>enddate))
	...q:((wardloc'="")&&(Obj.PatWard'=wardloc))
	...q:((Obj.ReplyType="")||(Obj.ReplyType=1)||(Obj.ReplyType=2))
	...s SendDate=""
	...i Obj.SendDate'="" s SendDate=$zd(Obj.SendDate,3)
	...s SendTime=""
	...i Obj.SendTime'="" s SendTime=$zt(Obj.SendTime,1)
	...s patrow=$O(^PAPERi("PAPMI_PatNo",$zcvt(Obj.PatPMINo,"U"),""))
	...q:patrow=""
	...s patrowobj=##class(User.PAPatMas).%OpenId(patrow)
	...q:'$IsObject(patrowobj)
	...i Obj.AdmInDate'="" s PAADMAdmDate=$zd(Obj.AdmInDate,3)
	...e  s PAADMAdmDate=""
	...s PatName=patrowobj.PAPMIName //患者姓名
	...s PatPMINo=Obj.PatPMINo //登记号
	...s SendPhone=Obj.SendPhone //电话
	...s ReplyType=Obj.ReplyType //回复内容
	...s PatWard=""
	...i Obj.PatWard'="" d
	....s PatWard=$P($P($G(^CTLOC(Obj.PatWard)),"^",2),"-",2) //出院病区
	...s OutDate=""
	...i Obj.OutDate'="" s OutDate=$zd(Obj.OutDate,3) //出院日期
	...e  s OutDate=""
	...s Content=""
	...i Obj.SatiType="P" d
	....s setrow=$O(^DHCNMG.DB.MgSurveySetD(""))
	....q:setrow=""
	....s setobj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setrow)
	....s Content=setobj.OperateModel
	....s Content=$replace(Content,"{NAME}",PatName)
	....s Content=$replace(Content,"{TIME}",OutDate)
	....s Content=$replace(Content,"{DEPT}",PatWard)
	....s Content=$replace(Content,"{DAY}",setobj.ReplyValid)
	...i Obj.SatiType="S" d
	....s setrow=$O(^DHCNMG.DB.MgSurveySetD(""))
	....q:setrow=""
	....s setobj=##class(DHCNMG.DB.MgSurveySet).%OpenId(setrow)
	....s Content=setobj.ServiceModel //问题
	....s Content=$replace(Content,"{NAME}",PatName)
	....s Content=$replace(Content,"{TIME}",OutDate)
	....s Content=$replace(Content,"{DEPT}",PatWard)
	....s Content=$replace(Content,"{DAY}",setobj.ReplyValid)
	...s ReplyRecord=Obj.ReplyRecord
	...s ApplicateFlag="",AppVisitFlag=""
	...i Obj.ApplicateFlag="N" s ApplicateFlag="申请",AppVisitFlag="N"
	...e  i Obj.ApplicateFlag="Y" s ApplicateFlag="通过",AppVisitFlag="Y"
	...s ConvertReply=Obj.ConvertReply
	...s ret="PatPMINo|"_PatPMINo_"^Content|"_Content_"^PatName|"_PatName_"^SendPhone|"_SendPhone_"^PAADMAdmDate|"_PAADMAdmDate_"^OutDate|"_OutDate_"^PatWard|"_PatWard_"^rowid|"_RowID_"^ReplyType|"_ReplyType_"^ReplyRecord|"_ReplyRecord_"^RecordFlag|false"_"^ApplicateFlag|"_ApplicateFlag_"^ConvertReply|"_ConvertReply_"^AppVisitFlag|"_AppVisitFlag
	...do OutputAllOtherList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAllOtherList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAllOtherInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllOtherInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAllOtherInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllOtherInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:
/// Description:查询所有病区申请回访的记录
/// Date:2018-04-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others:
Query FindWardAppList(ward As %String = "", stdate As %String, enddate As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardAppListExecute(ByRef qHandle As %Binary, ward As %String = "", stdate As %String, enddate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("findwardapplist")=ward_"%"_stdate_"%"_enddate
	
	
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.Survey.MgNurPatSatisI("app"," N",RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.Survey.MgNurPatSatis).%OpenId(RowID)
	.q:((stdate'="")&&(obj.OutDate<$zdh(stdate,3)))
	.q:((enddate'="")&&(obj.OutDate>$zdh(enddate,3)))
	.s PatWard=$P($g(^CTLOC(obj.PatWard)),"^",1)
	.i obj.SatiType="P" s satitype="技术操作"
	.e  i obj.SatiType="S" s satitype="服务态度"
	.s patmino=obj.PatPMINo
	.s ret="patward|"_PatWard_"^patmino|"_patmino_"^satitype|"_satitype_"^RowID|"_RowID
	.do OutputWardAppList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputWardAppList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardAppListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardAppListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardAppListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
