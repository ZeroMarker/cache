/// HIS产品组内部相互调用的统一入口
Class web.DHCENS.EnsHISService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012—03-06
/// Description：平台提供给其他产品组调用统一入口
/// Table：Ens_Interface
/// Input：Input:方法参数,KeyName:事件参数
/// Return：0^成功  15559-2-001^15559||2
/// Others：w ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDDOCORDITEMINFO","109||1")
ClassMethod DHCHisInterface(KeyName As %String, Input...) As %GlobalCharacterStream
{
  	s $zt="err"
	s n = $zu(41)
	s method = $zu(41,n-2)	
	s proc = ##class(%SYS.ProcessQuery).%OpenId($j)
	s ip = proc.ClientIPAddress
	s proc=""
	q:(""=KeyName) "-1^方法代码为空!"
	s rowId=$o(^User.EnsInterfaceMethodI("MethodCode","classMethod",KeyName,""))
	s methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	if '$isobject(methodObj){
		q "-1^方法不存在!"
	}
	s methodStatus=methodObj.methodStatus
	if (methodStatus="N") {
		q "-1^方法未启用!"
	}
	
	s className=methodObj.methodClassName
	s methodName=methodObj.methodName
	s methodInput=methodObj.methodInput
	s OutputType=$p($p(methodObj.methodOutput,$char(28),1),$char(2),1)
	s OutputDesc=$p($p(methodObj.methodOutput,$char(28),1),$char(2),2)
	
	s tmpInput="",tmpSubInput="",perInput="",IntInputDesc=""
	f i=1:1:$g(Input,0){
		s @("Input"_i)=$g(Input(i),"<NULL>")
		s tInputType=$p($p(methodInput,$char(28),i),$char(2),1)
		s tmpSubInput=$g(Input(i),"<NULL>")
		s tmpIntInputDesc=$p($p(methodInput,$char(28),i),$char(2),3)
		if (IntInputDesc=""){
			s IntInputDesc=tmpIntInputDesc
		}else{
			s IntInputDesc=IntInputDesc_$char(2)_tmpIntInputDesc
		}
		if (tInputType="%GlobalCharacterStream"){
			s tmpSubInput=tmpSubInput.Read()
			s tsc=Input(i).Rewind()
		}
		if (tmpInput=""){
			s tmpInput="Input"_i
			s perInput=tmpSubInput
		}else{
			s tmpInput=tmpInput_","_"Input"_i
			s perInput=perInput_","_tmpSubInput
		}
	}
	//启用日志记录标识功能
	s EnsInterfaceFlag=methodObj.EnsInterfaceFlag
	if (EnsInterfaceFlag="N")
	{
		s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
		s @exeStr
		s result=@"rtn"
		q result	
	}
	s perStream=##class(%GlobalCharacterStream).%New()
	d perStream.Write(perInput)
	//接口表写数据
	s @"KeyName"=rowId
	s @"Method"=method
	s @"Ip"=ip
	s @"PerStream"=perStream
	s @"IntInputDesc"=IntInputDesc
	s exeStr="ensRtn=##class(web.DHCENS.STBLL.UTIL.EnsInterface).InsertEnsInterface(KeyName,Method,Ip,PerStream,IntInputDesc)"
	s @exeStr
	
	s resultStr=@"ensRtn"
	if (className="web.DHCENS.STBLL.UTIL.EnsInterface")&&(methodName="InsertEnsInterface"){
		if OutputType="%GlobalCharacterStream" {
			set rtn=##class(web.DHCENS.STBLL.MANAGE.MergeInstance).SendMergeInfo(KeyName,perStream)
			do resultStr.CopyFrom(rtn)
			set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",resultStr)
		}
		else {
			set stream=##class(%Stream.GlobalCharacter).%New()
			d stream.Write(resultStr)
			set rtn=##class(web.DHCENS.STBLL.MANAGE.MergeInstance).SendMergeInfo(KeyName,perStream)
			d stream.Write("^")
			do stream.CopyFrom(rtn)
			set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",stream)
		}
		;d ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).SendMergeInfo(KeyName,perStream)
		q resultStr
	}
	s exeStr="rtn=##class("_className_")."_methodName_"("_tmpInput_")"
	s @exeStr
	set result=@"rtn"
	if OutputType="%GlobalCharacterStream" {
		set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",result)
	}
	else {
		set stream=##class(%GlobalCharacterStream).%New()
		d stream.Write(result)
		set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"Y",stream)
	}
	s methodObj=""
	
	q result
err
	//set resultStr=@"ensRtn"
	//set stream=##class(%GlobalCharacterStream).%New()
	//d stream.Write("-1^"_$ze)
	//set sc=##class(web.DHCENS.STBLL.UTIL.EnsInterface).UpdateOutputResult($p(resultStr,"^",2),"N",stream)
	q "-1^"_$ze
}

// -------------------------------------医生站调用（同步）-----------------------------------------------------------

/// Creator：WuXianPu
/// CreatDate：2012—05-24
/// Description：医生站叫号
/// Table：
/// Input：标志^顺序号^登记号^姓名^日期^时间^科室Rowid^科室^医生Rowid^医生^状态^诊室IP^号别名称^诊室名称
/// Return：0^成功
/// Others: w ##class(web.DHCENS.EnsHISService).SetAdmCallInfo("Y^5^377^辛维青^2011-05-06^09:58:46AM^72^心胸外科门诊^451^田凯华^复诊^二十^胸外科专家号(全天)^二十")
ClassMethod SendAdmCallInfo(Input As %String) As %String
{
	Quit "0^成功"
	q:Input="" "-1^输入信息不能为空"
	//set result=##class(web.DHCENS.BLL.Empi.Method.CallInfo).SetCallInfo(Input)
}

/// 结算前
ClassMethod DHCHisOpChargeSend(Input As %String) As %String
{
	Quit "0^成功"
}

/// Creator：WuXianPu
/// CreatDate：2012—05-10
/// Description：计算试管数量
/// Table：
/// Input：医嘱RowID^医嘱RowID^医嘱RowID^
/// Return：0^成功,-1^失败
/// Others：w ##class(web.DHCENS.EnsHISService).GetAmountOfTube("149||5^149||6")
ClassMethod GetAmountOfTube(Input As %String, DeptCode As %String = "") As %String
{
	Quit "0^成功"
	set result=##class(web.DHCENS.STBLL.LIS.METHOD.AmountOfTube).AmountOfTube(Input,DeptCode)
	Quit result
}

/// Creator：WuXianPu
/// CreatDate：2012—03-06
/// Description：根据处方号查询处方状态(同步门诊发药机) 
/// Table：
/// Input：处方号
/// Return：
/// Others：w ##class(web.DHCENS.EnsHISService).StartSendDrugInfo("34794")
ClassMethod StartSendDrugInfo(Input As %String) As %String
{
	Quit "0^成功"
	//q:Input="" "-1^输入信息不能为空"
	//set result=##class(web.DHCENS.BLL.Drug.Method.SelectPresStatus).SelectPresStatusByPresno(Input)
	//q result
}

/// Creator：WuXianPu
/// CreatDate：2012—06-12
/// Description：HIS发送完成病人发药信息
/// Table：
/// Input：
/// Return：0^成功
/// Others：w ##class(web.DHCENS.EnsHISService).FinishSendDrugInfo("")
ClassMethod FinishSendDrugInfo(Input As %String) As %String
{
	Quit "0^成功"
	//set result=##class(web.DHCENS.BLL.Drug.Method.FinishPharmaceutist).FinishPharmaceutist(Input)
	//q result
}

// -------------------------------药房调用部分(同步)--------------------------------------------

/// Creator：WuXianPu
/// CreatDate：2012—03-06
/// Description：发送HIS中药品医嘱信息(同步住院摆药机) 
/// Table：DHC_PhaCollected
/// Input：住院药品发药表ROWID
/// Return：0^成功
/// Others：w ##class(web.DHCENS.EnsHISService).DispenseIPDrugInfo("34271")
ClassMethod DispenseIPDrugInfo(Input As %String) As %String
{
	Quit "0^成功"
	;q:Input="" "-1^输入信息不能为空"
	set result=##class(web.DHCENS.STBLL.DRUG.METHOD.IPDrugOrdInfo).DispenseIPDrugInfo(Input)
	q result
}

// ---------------------------------------------------------------------------------------------------------------

/// Creator：WuXianPu
/// CreatDate：2012—11-10
/// Description：医生停医嘱，通知第三方系统此申请单作废
/// Table：
/// Input： 病人RowID^医嘱号^血液类型信息^日期
/// Return：0^0不需要采血；0^1需要采血
/// Others: w ##class(web.DHCENS.EnsHISService).JudgeCollection("")
ClassMethod JudgeCollectionBloodInfo(Input As %String) As %String
{
	Quit "0^成功"
	//set result=##class(web.DHCENS.BLL.Blood.Method.JudgeCollection).JudgeCollection(Input)
	//q result
}

ClassMethod CreateEmergencyPageData(StartDate As %String, EndDate As %String) As %String
{
	s:StartDate="" StartDate=$zd(+$h,3)
	s Year=$p(StartDate,"-",1)
	s Month=$p(StartDate,"-",2)
	s SDate=$zdh(Year_"-"_Month_"-01",3)
	s Mod4=Year#4
	s Mod100=Year#100
	if ((Month="04")||(Month="06")||(Month="09")||(Month="11")) 
	{
		set EMonth=Month_"-30"
	}
	elseif((Month="02")&&(Mod4="0")&&(Mod100'="0"))
	{
		set EMonth=Month_"-29"
	}
	elseif((Month="02")&&(Mod4="0")&&(Mod100="0"))
	{
		set EMonth=Month_"-28"
	}
	else
	{
		set EMonth=Month_"-31"
	}
	s EDate=$zdh(Year_"-"_EMonth,3)

	k ^TmpDHCENS("EmergencyPageData")
	f i=SDate:1:EDate
	{
		s PrtRowid="" f  s PrtRowid=$o(^DHCINVPRT(0,"Date",i,PrtRowid)) q:PrtRowid=""  d
		.s DHCBCIRowid="" f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",PrtRowid,DHCBCIRowid)) q:DHCBCIRowid=""  d
		..s AdmDr=$p($g(^DHCBCI(DHCBCIRowid)),"^",3)
		..i AdmDr'="" d
		...s ^TmpDHCENS("EmergencyPageData",$zd(+$h,3),AdmDr)=""
	}
	;调用电子病历方法取得触犯条目，入参就诊号
	f  {
	s ID=$o(^TmpDHCENS("EmergencyPageData",$zd(+$h,3),ID)) q:ID=""
	s status=##Class(EPRservice.BIL.BIEPRLogs).GetOutFristPageStatus(ID)
	i status="finished"
	{
		set intnum=0,result="Items",AdmDate=""
		set AdmDate=""
		set status=""
		k rset
		Set rset = ##class(%ResultSet).%New("EPRservice.BIL.BIQuality:GetResultDetailList")	
		Set sc = rset.Execute(ID)
		While(rset.Next()) 
		{
			s ItemRowId=rset.GetDataByName("ExamEntry")
			s ItemDesc=rset.GetDataByName("EntryDesc")
			s DocName=rset.GetDataByName("DocName")
			s DocRowId=rset.GetDataByName("DocRowid")
			s EntryScore=rset.GetDataByName("EntryScore")
			s result=result_"#"_ItemRowId_":"_ItemDesc
		}
		s AdmDate=$p($g(^PAADM(ID)),"^",6)
		s OnLoadDate=Year_"-"_Month
		;调方法取得质控分数并进行判断，分数小于100的有问题
		s flag="",ItemScore=""
		s ItemScore=##Class(EPRservice.BIL.BIQuality).GetResultScore(ID)
		i ItemScore=100  d
		.s flag="Y"
		e  d
		.s flag="N"
		set retStr=..DHCHisInterface("SENDEMERGENCYADMFIRSTPAGEINFO",ID_"^"_flag_"^"_result_"^"_AdmDate_"^"_OnLoadDate)
		set intnum=intnum+1
		}
	}
	Quit intnum
}

/// creator:liyi
/// creatdate:20121221
/// description:取当天（如果任务在早上凌晨，取前一天）完成病案归档操作的所有病案的adm,paamd_rowid
/// input:argDateFrom argDateTo
/// output:
/// debug:w ##class(web.DHCENS.EnsHISService).GetRecordAdmList("2012-10-01","2013-01-14")
/// debug:w ##class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmList("","")
ClassMethod GetRecordAdmList(argDateFrom As %String, argDateTo As %String) As %String
{
	//New (argDateFrom,argDateTo)
	//Set return=""
	Set $ZT="GetRecordAdmListErr"
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Set Count=0
	//取当前系统的归档上架操作ID
	Set WorkItemId=""
	/*
	For{
		Set WorkItemId=$o(^DHCWMRWITM(WorkItemId))
		Quit:WorkItemId=""
		Continue:$p($g(^DHCWMRWITM(WorkItemId)),"^",3)="N"
		s:$p($g(^DHCWMRWITM(WorkItemId)),"^",2)="病案编目" StatusDr=WorkItemId   //根据医院归档上架具体的描述来判断
		}
	*/
	Set StatusDr=8    ;病案编目
	//如果传入参数为空，前一天的归档操作的所有病案
	if (argDateTo="")&&(argDateFrom="")
		{
			Set QueryDate=$p($h,",",1)
			Set MainVolumeId=""
			For{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDINHOSPITALADMFIRSTPAGEINFO",PaadmDr) 
				Set Count=Count+1
				}
			
		}
	//如果两个传入参数不为空
	if (argDateFrom'="")&&(argDateTo'="")
	{
		;Set QueryDate=argDateFrom
		for QueryDate=argDateFrom:1:argDateTo {
			Set MainVolumeId=""
			for{		
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				;w MainVolumeId,!
				Continue:QueryDate>argDateTo
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDINHOSPITALADMFIRSTPAGEINFO",PaadmDr)
				Set Count=Count+1
			}
		}
	}
	//如果开始日期为不为空，结束日期为空
	if (argDateFrom'="")&&(argDateTo="")
	{
		Set CurrDate=$p($h,",",1)
		if (argDateFrom<=CurrDate)
			{
				Set QueryDate=argDateFrom
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateFrom
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
					//Set return=$lb(PaadmDr,return)
					//此处调用提供的接口
					do ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDINHOSPITALADMFIRSTPAGEINFO",PaadmDr)
					Set Count=Count+1
				}
			}
	 }
	Quit Count
GetRecordAdmListErr
     Quit -1
}

}
