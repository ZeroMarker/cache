Class web.PilotProject.DHCDocPilotProQC Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// /新建质控专业组
ClassMethod CreateQCZYZ(PPRowId As %String) As %String
{
	q:PPRowId="" -1
	s myrtn=0
	s UObj=##class(User.DHCDocPilotProQCZYZ).%New(PPRowId)
	d UObj.PPQCZYZPPParRefSetObjectId(PPRowId)
	s UObj.PPQCZYZDate=+$h
	Set sc = UObj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-105"
	}
	d UObj.%Close()
	q myrtn
}

ClassMethod FindQCZYZClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindQCZYZExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQCZYZExecute(ByRef QHandle As %Binary, PPRowID As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProQC","FindQCZYZ","")
	Set repid=$I(^CacheTemp)
	s ind=1
	s RowId=0
	i PPRowID'="" d
	.s childsub=0
	.f  s childsub=$O(^DHCDocPPQCZYZ(PPRowID,childsub)) q:childsub=""  d
	..s CreateDate=$p($g(^DHCDocPPQCZYZ(PPRowID,childsub)),"^",1)
	..s:CreateDate'="" CreateDate=$zd(CreateDate,3)
	..s QCZYZFlag=$p($g(^DHCDocPPQCZYZ(PPRowID,childsub)),"^",41)
	..;q:QCZYZFlag="Y"
	..s PPCode=$p($g(^DHCDocPP(PPRowID)),"^",1)
	..s PPDesc=$p($g(^DHCDocPP(PPRowID)),"^",2)
	..s DeUser=##class(web.PilotProject.DHCDocPilotProject).GetPPDepartAndUser(PPRowID)
	..s PPDepartment=$p(DeUser,"^",1)
	..s PPStartUser=$p(DeUser,"^",2)
	..s RowId=PPRowID_"||"_childsub
	..Do OutputRow4
	e  d
	.s PPRowID=0 f  s PPRowID=$o(^DHCDocPPQCZYZ(PPRowID)) q:PPRowID=""  d
	..s childsub=0
	..f  s childsub=$O(^DHCDocPPQCZYZ(PPRowID,childsub)) q:childsub=""  d
	...s CreateDate=$p($g(^DHCDocPPQCZYZ(PPRowID,childsub)),"^",1)
	...s:CreateDate'="" CreateDate=$zd(CreateDate,3)
	...s QCZYZFlag=$p($g(^DHCDocPPQCZYZ(PPRowID,childsub)),"^",41)
	...;q:QCZYZFlag="Y"
	...s PPCode=$p($g(^DHCDocPP(PPRowID)),"^",1)
	...s PPDesc=$p($g(^DHCDocPP(PPRowID)),"^",2)
	...s DeUser=##class(web.PilotProject.DHCDocPilotProject).GetPPDepartAndUser(PPRowID)
	...s PPDepartment=$p(DeUser,"^",1)
	...s PPStartUser=$p(DeUser,"^",2)
	...s RowId=PPRowID_"||"_childsub
	...Do OutputRow4
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(RowId,PPDesc,PPCode,PPDepartment,PPStartUser,CreateDate)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables4
	///set (repid)=0
	set (HCPDesc,HCPRowId)=""
	quit
}

ClassMethod FindQCZYZFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQCZYZExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindQCZYZ(PPRowId As %String) As %Query(ROWSPEC = "RowId:%String,PPDesc:%String,PPCode:%String,PPDepartment:%String,PPStartUser:%String,CreateDate:%String") [ SqlProc ]
{
}

//d ##class(web.PilotProject.DHCDocPilotProQC).SetQCZYZ()

ClassMethod SetQCZYZ()
{
	s ^DHCDocQCZYZSet(1)="A1"_"^"_"国家食品药品监督管理局批件"_"^"_"查研究者文件夹相关文件"
	s ^DHCDocQCZYZSet(2)="A2"_"^"_"药检报告"_"^"_"查研究者文件夹相关文件"
	s ^DHCDocQCZYZSet(3)="A3"_"^"_"伦理委员会批件及伦理委员会成员表"_"^"_"查研究者文件夹相关文件"
	s ^DHCDocQCZYZSet(4)="A4"_"^"_"研究者手册"_"^"_"查研究者文件夹相关文件"
	s ^DHCDocQCZYZSet(5)="A5"_"^"_"知情同意书（样本）及其修改获得伦理委员会批准"_"^"_"查研究者文件夹相关文件"
	s ^DHCDocQCZYZSet(6)="A6"_"^"_"试验方案及其修改须获得伦理委员会批准（PI签名）"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(7)="A7"_"^"_"协议书"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(8)="A8"_"^"_"研究者简历"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(9)="A9"_"^"_"实验室正常值范围"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(10)="A10"_"^"_"实验室质控证明"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(11)="A11"_"^"_"监查访视记录"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(12)="A12"_"^"_"受试者鉴认代码表、筛选入选表"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(13)="A13"_"^"_"研究者签名样张"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(14)="A14"_"^"_"参加临床试验人员的培训记录"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(15)="A15"_"^"_"病例报告表（样表）"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(16)="A16"_"^"_"研究人员职责分工表"_"^"_"查研究者文件夹相关文件"
    s ^DHCDocQCZYZSet(17)="B1"_"^"_"研究人员组成合理，分工明确"_"^"_"查专业人员名单、职责分工表"
    s ^DHCDocQCZYZSet(18)="B2"_"^"_"研究人员均具备相应的专业特长和资格"_"^"_"查除主要研究者外的研究履历表"
    s ^DHCDocQCZYZSet(19)="B3"_"^"_"研究人员经过GCP、相关法规、试验技术及相关SOP培训,"_"^"_"查培训记录、启动会文件记录"
    s ^DHCDocQCZYZSet(20)="C1"_"^"_"具有适当的受试者接待场所，能满足知情同意、随访等需要"_"^"_"查现场"
    s ^DHCDocQCZYZSet(21)="C2"_"^"_"具有专用的、安全的试验用药物储藏设施"_"^"_"查现场及相关温湿度记录"
    s ^DHCDocQCZYZSet(22)="C3"_"^"_"具有专用的、安全的试验文件储藏设施"_"^"_"查现场"
    s ^DHCDocQCZYZSet(23)="C4"_"^"_"具有相适应的仪器设备，定期校验，工作状态良好"_"^"_"查现场"
    s ^DHCDocQCZYZSet(24)="D1"_"^"_"试验用药物的接收记录完整"_"^"_"查试验用药物的接收记录"
    s ^DHCDocQCZYZSet(25)="D2"_"^"_"试验用药物的发放记录完整，药品发放有双人签字"_"^"_"查药物发放记录"
    s ^DHCDocQCZYZSet(26)="D3"_"^"_"试验用药物的用药记录完整，有医生指令的记录"_"^"_"查药物使用记录和原始病历"
    s ^DHCDocQCZYZSet(27)="D4"_"^"_"试验用药物的回收记录完整"_"^"_"查药物回收记录，注意最小包装及空瓶"
    s ^DHCDocQCZYZSet(28)="D5"_"^"_"退回或销毁等记录完整，数量吻合"_"^"_"查退回或销毁记录"
    s ^DHCDocQCZYZSet(29)="D6"_"^"_"试验用药物的包装与标签符合试验方案和GCP要求"_"^"_"现场查看"
    s ^DHCDocQCZYZSet(30)="D7"_"^"_"试验用药物储存条件符合方案规定（常温、低温、避光等）"_"^"_"查现场"
    s ^DHCDocQCZYZSet(31)="D8"_"^"_"试验用药物储存柜符合要求（独立、安全、保密）"_"^"_"查现场"
    s ^DHCDocQCZYZSet(32)="D9"_"^"_"试验用药物储存温湿度记录完整"_"^"_"查温湿度记录"
    s ^DHCDocQCZYZSet(33)="E1"_"^"_"知情同意书有受试者或其法定代理人签名和日期"_"^"_"查知情同意书"
    s ^DHCDocQCZYZSet(34)="E2"_"^"_"知情同意书有研究者签名和日期"_"^"_"查知情同意书"
    s ^DHCDocQCZYZSet(35)="E3"_"^"_"受试者和研究者签署知情同意书的日期一致"_"^"_"查知情同意书"
    s ^DHCDocQCZYZSet(36)="E4"_"^"_"知情同意书修改后及时告诉受试者,并取得受试者同意"_"^"_"查知情同意书"
    s ^DHCDocQCZYZSet(37)="E5"_"^"_"特殊群体获得知情同意书符合GCP规定"_"^"_"查知情同意书和伦理审查批件"
    s ^DHCDocQCZYZSet(38)="E6"_"^"_"受试者在签署知情同意书之后进行研究相关步骤"_"^"_"查知情同意书、筛选入选表、化验单、首次使用药物时间等"
    s ^DHCDocQCZYZSet(39)="E7"_"^"_"获得知情同意书的研究者有资质及PI授权"_"^"_"查知情同意书、职工分工表、简历等"
    s ^DHCDocQCZYZSet(40)="F1"_"^"_"检查的项目能及时提供完整资料,包括筛选失败及退出病例"_"^"_"查原始病历、CRF及其他相关记录等"
    s ^DHCDocQCZYZSet(41)="F2"_"^"_"CRF填写及时、完整、规范、准确，与原始病历的数据一致、可溯源，CRF修改规范"_"^"_"查CRF和原始病历、辅助检查结果"
    s ^DHCDocQCZYZSet(42)="F3"_"^"_"原始记录填写及时、完整、规范、准确，与医疗病例内容一致，可溯源，原始记录修改规范"_"^"_"查原始记录及相关记录"
    s ^DHCDocQCZYZSet(43)="F4"_"^"_"化验单填写项目齐全、为方案规定的实验室所提出具、有研究审阅记录且异常化验结果有研究者判断临床意义"_"^"_"查看化验单"
    s ^DHCDocQCZYZSet(44)="F5"_"^"_"热敏纸心电图须有复印件、有报告人签署的结果及签名日期、有研究者审阅记录"_"^"_"查看心电图"
    s ^DHCDocQCZYZSet(45)="G1"_"^"_"参与实验的研究人员严格遵循现行的临床试验方案"_"^"_"查原始病历及相关文件"
    s ^DHCDocQCZYZSet(46)="G2"_"^"_"入组病例的诊断、纳入与排除与试验方案要求一致"_"^"_"查原始病历及相关文件"
    s ^DHCDocQCZYZSet(47)="G3"_"^"_"所进行的实验室等辅助检查项目与试验方案要求一致"_"^"_"查原始病历及相关文件"
    s ^DHCDocQCZYZSet(48)="G4"_"^"_"临床试验过程中严格执行了随机化分组方案"_"^"_"核对筛选入组顺序与随机分组的对应关系"
    s ^DHCDocQCZYZSet(49)="G5"_"^"_"应急信封保存完整，如紧急破盲，应执行相应的SOP，并记录理由"_"^"_"查在研项目的应急信封和相关记录，现场考核"
    s ^DHCDocQCZYZSet(50)="G6"_"^"_"试验药物剂量、间隔和给药途径与试验方案要求一致"_"^"_"查原始病历及相关文件"
    s ^DHCDocQCZYZSet(51)="G7"_"^"_"观察随访点与试验方案要求一致"_"^"_"查原始病历及相关文件"
    s ^DHCDocQCZYZSet(52)="G8"_"^"_"所有合并用药均已记录，无违反试验方案要求的合并用药"_"^"_"查原始病历和CRF"
    s ^DHCDocQCZYZSet(53)="G9"_"^"_"受试者任何原因的退出与失访，均在病例报告表中详细说明"_"^"_"查原始病历和CRF"
    s ^DHCDocQCZYZSet(54)="G10"_"^"_"对异常且有临床意义的数据及时复查，并作相应的记录"_"^"_"查原始病历和CRF"
    s ^DHCDocQCZYZSet(55)="H1"_"^"_"发生AE后及时处理，记录在案，必要时跟踪随访"_"^"_"查原始病历和CRF"
    s ^DHCDocQCZYZSet(56)="H2"_"^"_"所有发生的SAE，均在CRF中记录，填写SAE报告表，并在规定时间内，按照相关SOP的要求向申办方及相关部门报告"_"^"_"查原始病历、CRF和SAE报告"
}

ClassMethod FindQCZYZDetailClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindQCZYZDetailExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindQCZYZDetailExecute(ByRef QHandle As %Binary, PPQCZYZRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.PilotProject.DHCDocPilotProQC","FindQCZYZDetail","")
	Set repid=$I(^CacheTemp)
	s ind=1
	S Id=""
	f  s Id=$o(^DHCDocQCZYZSet(Id)) q:Id=""  d
	.s Seq=$p(^DHCDocQCZYZSet(Id),"^",1)
	.s ResearchContent=$p(^DHCDocQCZYZSet(Id),"^",2)
	.Do OutputRow5
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(Id,Seq,PPCode,ResearchContent)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables5
	///set (repid)=0
	set (Id,Seq,PPCode,ResearchContent)=""
	quit
}

ClassMethod FindQCZYZDetailFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQCZYZDetailExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindQCZYZDetail(PPQCZYZRowId As %String) As %Query(ROWSPEC = "Id,Seq,PPCode,ResearchContent:%String") [ SqlProc ]
{
}

/// w ##class(web.PilotProject.DHCDocPilotProQC)DeleteQCZYZByID(1||17)
ClassMethod DeleteQCZYZByID(PPQCZYZRowID As %String) As %String
{
	q:PPQCZYZRowID=""
	i PPQCZYZRowID'="" d
	.&sql(delete from SQLUser.DHC_DocPilotProQCZYZ where PPQCZYZ_RowId=:PPQCZYZRowID)
	Q SQLCODE
}

/// InString=PPQCZYZRowId+"^"+QualityControlor+"^"+QualitycontrolDate+"^"+AllRowStr;
/// AllRowStr=AllRowStr+"$"+EveryRowStr;
/// EveryRowStr=seqno+"^"+Result+"^"+Question;
/// w ##class(web.PilotProject.DHCDocPilotProQC).UpdateQCZYZ("1||27^得到^19/09/2014^A1,Y,$A2,N,得到$A3,N/A,$A4,,$A5,,$A6,,$A7,,$A6,,$A7,,$A7,,$A6,,$A7,,$A8,,$A9,,$A10,,$A11,,$A12,,$A13,,$A14,,$A15,,$A16,,$B1,,$B2,,$B3,,$C1,,$C2,,$C3,,$C4,,$D1,,$D2,,$D3,,$D4,,$D5,,$D6,,$D7,,$D8,,$D9,,$E1,,$E2,,$E3,,$E4,,$E5,,$E6,,$E7,,$F1,,$F2,,$F3,,$F4,,$F5,,$G1,,$G2,,$G3,,$G4,,$G5,,$G6,,$G7,,$G8,,$G9,,$G10,,$H1,,$H2,,")
/// /$A7,,$A6,,$A7,,$A8,,$A9,,$A10,,$A11,,$A12,,$A13,,$A14,,$A15,,$A16,,$B1,,$B2,,$B3,,$C1,,$C2,,$C3,,$C4,,$D1,,$D2,,$D3,,$D4,,$D5,,$D6,,$D7,,$D8,,$D9,,$E1,,$E2,,$E3,,$E4,,$E5,,$E6,,$E7,,$F1,,$F2,,$F3,,$F4,,$F5,,$G1,,$G2,,$G3,,$G4,,$G5,,$G6,,$G7,,$G8,,$G9,,$G10,,$H1,,$H2,,
ClassMethod UpdateQCZYZ(InString) As %String
{
	s ^nk("UpdateQCZYZ")=InString
    s RowID=$p(InString,"^",1)
    q:RowID="" "-101"
    s QualityControlor=$p(InString,"^",2) 
    s QualitycontrolDate=$p(InString,"^",3)
    s QualitycontrolDate=$zdh(QualitycontrolDate,4)
    s AllRowStr=$p(InString,"^",4)
    TS
	&sql(Update SQLUSER.DHC_DocPilotProQCZYZ set Quality_Controlor=:QualityControlor,Quality_controlDate=:QualitycontrolDate,Quality_Control_Result=:AllRowStr  where PPQCZYZ_RowId=:RowID) 
	s myrtn=SQLCODE
	w myrtn
	b ;myrtn
	if myrtn=0{
		&sql(update SQLUSER.DHC_DocPilotProQCZYZ set PP_QCZYZ_Flag="Y" where PPQCZYZ_RowId=:RowID) 
		s myrtn=SQLCODE
	}
	if +myrtn=0{
		TC
	}else{
		TRO
	}
	q myrtn
}

/// 自定义单选按钮
ClassMethod CustomRadioType(Id As %String) As %String
{
	i Id="" s Id="aaa"
    w "<input type='radio' name="_Id_" id="_Id_">"
	q
}

}
