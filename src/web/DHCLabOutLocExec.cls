Class web.DHCLabOutLocExec Extends %Persistent
{

Parameter BUILD = 60;

/// Creator：      Qiuxianfu
/// CreatDate：    20130617
/// Description:： 去用户所在科室
/// Table：        DHCLab_OutOrdExec
/// Input：        StrData: 字符串集
/// Output：       
/// Return：       
/// Others：
/// d ##Class(web.DHCLabOutLocExec).UpdateLocExec("")     
ClassMethod Getnuctname(ctlocid As %String) As %String
{
	//Set StrData="^597632||405||1632584||||||||二十七病区||0154||^597632||408||1632585||||||||二十七病区||0154||"
	Quit:ctlocid=""
	Set ctlocid=$Get(ctlocid)
    Set ^TMP("QXF",1)=ctlocid
    Set ctlocname=$Piece(^CTLOC(ctlocid),"^",2)
    Quit ctlocname
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 判断标本是否可以删除
/// Table：        无
/// Input：        Labno:条码号
/// Output：       判断标志
/// Return：       0：可以，1^"..."：不能删除及原因
/// Others：		无
ClassMethod CheckLabnoDelete(Labno As %String) As %String
{
	S Labno=$G(Labno)
	S ret=0
	I '$D(^DHCSpecTransi("LabNo",Labno)) S ret=1_"^条码未曾扫入过入库单！"
	I ret'=0 Q ret
	S RowId=$O(^DHCSpecTransi("LabNo",Labno,""))
	S Status=$P(^DHCSpecTrans(RowId),"^",12)
	I Status="P||部分完成" S ret=1_"^条码关联的出库单号已经交接不允许删除！"
	I ret'=0 Q ret
	Q ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 判断标本是否能关联到出库单号
/// Table：        无
/// Input：        Labno:条码号,UserLocCode:用户科室ID
/// Output：       判断标志
/// Return：       0：正常，1^"..."：可以在前台判断进行更新处理，2^"..."：不能进行更新操作
/// Others：		无
ClassMethod CheckLabno(Labno As %String, UserLocCode As %String, TransNumber As %String) As %String
{
	S Labno=$G(Labno),UserLocCode=$G(UserLocCode),TransNumber=$G(TransNumber)
	S ret=0
	S (TransNo,TransStatus)=""
	I '$L(TransNumber) S ret=2_"^未选中出库单号！"
	I $D(^TEPI(Labno)) S ret=2_"^标本已经进入了检验科！"
	I $D(^DHCSpecTransi("LabNo",Labno)) D
	.S RowId=$O(^DHCSpecTransi("LabNo",Labno,""))
	.S TransNo=$P(^DHCSpecTrans(RowId),"^",2)
	.S TransStatus=$P(^DHCSpecTrans(RowId),"^",12)
	.I TransStatus="P||部分完成" S ret=2_"^条码号已经扫入出库单【"_TransNo_"】且已完成交接不能做修改！"
	.E  D
	..S ret=1_"^条码号已经扫入入库单【"_TransNo_"】！"
	I ret'=0 Q ret
	I $D(^DHCSpecTransi("TransNO",TransNumber)) D
	.S RowId=$O(^DHCSpecTransi("TransNO",TransNumber,""))
	.S Status=$P(^DHCSpecTrans(RowId),"^",12)
	.I Status="P||部分完成" S ret=2_"^入出库单【"_TransNumber_"】已完成交接不能做修改！"
	I ret'=0 Q ret
	I '$D(^OEORD(0,"EpisNo",Labno)) S ret=2_"^系统不存在此条码号"
	S ^TMP("Q!Q")=Labno
	//I $D(^TEPI(Labno)) S ret=2_"^标本已经进入了检验科！"
	I ret'=0 Q ret
	S (PatLocCode,PatLocName)=""
	S OrdId=$O(^OEORD(0,"EpisNo",Labno,""))
	S OrdSubId=$O(^OEORD(0,"EpisNo",Labno,OrdId,""))
	S PatLocCode=$P(^OEORD(OrdId,"I",OrdSubId,1),"^",3)
	I $L(PatLocCode) S PatLocName=$P(^CTLOC(PatLocCode),"^",2)
	I (UserLocCode'=PatLocCode),('$D(^CTLOC(UserLocCode,"LINK",0,"Loc",PatLocCode))) S ret=1_"^病人是【"_PatLocName_"】的不是本科室病区的！"
    I ret'=0 Q ret
    Q ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140410
/// Description:： 保存条码信息到出库单
/// Table：        DHC_SpecTransDetails
/// Input：        Labno:条码号，TransNo:出库单号，Remark：异常说明
/// Output：       SQLCODE
/// Return：       0:插入成功
/// Others：
/// d ##Class(web.DHCLabOutLocExec).Update("")     
ClassMethod Update(Labno As %String, TransNo As %String, Remark As %String) As %String
{
	S Labno=$G(Labno),TransNo=$G(TransNo),Remark=$G(Remark)
	S ^TMP("CMR",1)=Labno_","_TransNo_","_Remark
	TSTART
	If (Labno="") Quit 104   
	Set SQLCODE=100
	Set (CurHospitalCode,ContainerNo,TSLabCode,OrdId,childsub,HospID)=""
	//I '$D(^OEORD(0,"EpisNo",Labno)) Q SQLCODE
	Set OrdId=$Order(^OEORD(0,"EpisNo",Labno,""),-1)
	S childsub=$O(^OEORD(0,"EpisNo",Labno,OrdId,""),-1)
	Set locCode=$Piece(^OEORD(OrdId,"I",childsub,1),"^",3)
	If $Length(locCode) Set HospID=$Piece(^CTLOC(locCode),"^",22)
	If $Length(HospID) Set CurHospitalCode=$Piece(^CT("HOSP",HospID),"^",1)
	If '$Length(CurHospitalCode) Set CurHospitalCode=$Order(^TTABi("CC",1,""))
	Set TSCode=$Piece(^OEORD(OrdId,"I",childsub,1),"^",2)
	If $Length(TSCode) Set Code1=$Piece(TSCode,"||",1),Code2=$Piece(TSCode,"||",2)
	Set EXTLabCode=""
	For i=1:1:10  Do
	.If $Data(^ARCIM(Code1,Code2,"EXT",i)) Set EXTLabCode=$Piece(^ARCIM(Code1,Code2,"EXT",i),"^",4)
	.If $Length(EXTLabCode) Quit
	If '$Length(EXTLabCode) Quit
	If '$Data(^TTAB("TS",EXTLabCode,"SC")) Quit 
	Set ContainerNo=$Order(^TTAB("TS",EXTLabCode,"SC","")),ContainerNoName=$Piece($Get(^TTAB("CON",ContainerNo)),"\",1)
	If $Length(Labno),$Data(^DHCSpecTransi("LabNo",Labno)) Do
	.If '$L(Labno) S SQLCODE=104 Quit
	.S ret=..Delete(Labno)
	.Set SQLCODE=100
	.Kill PLIST
	.Set ParRef=$Order(^DHCSpecTransi("TransNO",TransNo,""),-1)
	.Set PLIST(0)=ParRef  
	.Set Order=$Order(^DHCSpecTrans(ParRef,""),-1)+1
	.Set PLIST(2)=Order
	.Set PLIST(3)=Labno
	.Set PLIST(5)="C||未完成"
	.Set PLIST(6)=Remark
	.Set PLIST(8)=ContainerNo
	.&sql(Insert Into lab.DHC_SpecTransDetails Values :PLIST())	
	Else  Do
	.Kill PLIST
	.Set ParRef=$Order(^DHCSpecTransi("TransNO",TransNo,""),-1)
	.Set PLIST(0)=ParRef  
	.Set Order=$Order(^DHCSpecTrans(ParRef,""),-1)+1
	.Set PLIST(2)=Order
	.Set PLIST(3)=Labno
	.Set PLIST(5)="C||未完成"
	.Set PLIST(6)=Remark
	.Set PLIST(8)=ContainerNo
	.&sql(Insert Into lab.DHC_SpecTransDetails Values :PLIST())
	If (SQLCODE'=0) TRollBack  Quit SQLCODE 
	TCOMMIT
	Quit SQLCODE
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130924
/// Description:： 得到医院代码
/// Table：        无
/// Input：        无
/// Output：       医院代码
/// Return：       医院代码
/// Others：
/// d ##Class(web.DHCLabOutLocExec).GetHospitalID("") 
ClassMethod GetHospitalID() As %String
{
	Set HospitalID=$Order(^TTABi("CC",1,""))
	Quit HospitalID
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130924
/// Description:： 新建运送单号
/// Table：        无
/// Input：        无
/// Output：       运送单号
/// Return：       运送单号
/// Others：
/// d ##Class(web.DHCLabOutLocExec).CreatTransmitNo("") 
ClassMethod CreatTransmitNo(HospitalID As %String) As %String
{
	  Set HospitalID=$Get(HospitalID)
	  Set Pre=$Extract($Piece($Get(^TTAB("CC",HospitalID)),"\",8),1)
  	  Set order=+$Get(^DHCSPECTRANS(+$H))+1
  	  Set ^DHCSPECTRANS(+$H)=order
  	  Set RetNumber=Pre_$ZD(+$H,8)_$TR($J(order,3)," ","0")
  	  Quit RetNumber
}

ClassMethod GetTranNo(Str As %String) As %String
{
   
    Set RetNumber=0
    If $Data(^DHCSPECTRANS(+$H)) Do
    .Set HospitalID=$Order(^TTABi("CC",1,""))
	.Set Pre=$Extract($Piece($Get(^TTAB("CC",HospitalID)),"\",8),1)
	.Set order=+$Get(^DHCSPECTRANS(+$H))
	.Set RetNumber=Pre_$ZD(+$H,8)_$TR($J(order,3)," ","0")
	Quit RetNumber
}

/// d ##Class(web.DHCLabOutLocExec).GetTransmitNo("")
ClassMethod GetTransmitNo(TransmitNo As %String) As %String
{
   
    Set TransmitNo=$Get(TransmitNo)
	Quit TransmitNo
}

/// 获取血袋信息
/// Return：       0:此血袋未进行发血操作,1:此血袋手工发血
/// d ##Class(web.DHCLabOutLocExec).GetBPInfo("")
ClassMethod GetBPInfo(PackID As %String) As %String
{
   
    Set PackID=$Get(PackID)
    Set ^TMP("QXF",112)=PackID
    If '$Data(^TBBP(PackID)) Quit 0 
    Set SubID=$Order(^TBBP(PackID,""))
    If '$Data(^TBBP(PackID,SubID,"XM")) Quit 0 
    Set Labno=$Order(^TBBP(PackID,SubID,"XM",""))
    If +Labno=0 Quit 1
	Quit Labno
}

/// 获取标本接收信息
/// Return：       0:此血袋未进行发血操作,1:此血袋手工发血
/// d ##Class(web.DHCLabOutLocExec).GetBPInfo("")
ClassMethod GetRecieveDT(RowId As %String, labno As %String) As %String
{
   
    S RowId=$G(RowId),labno=$G(labno)
    I '$L(RowId) Q ""
    S OrdId=$P(RowId,"||",1),childsub=$P(RowId,"||",2)
    S TSCode=""
    S ReceiveDT=""
    Set TSCode=$P(^OEORD(OrdId,"I",childsub,1),"^",2)
	If $L(TSCode) S Code1=$P(TSCode,"||",1),Code2=$P(TSCode,"||",2)
	Set EXTLabCode=""
	F i=1:1:10  D
	.I $D(^ARCIM(Code1,Code2,"EXT",i)) S EXTLabCode=$P(^ARCIM(Code1,Code2,"EXT",i),"^",4)
	.I $D(^TEPI(labno,1,TSCode)) S ReceiveDT=$P(^TEPI(labno,1,TSCode,1),"\",21)_"^"_$P(^TEPI(labno,1,TSCode,1),"\",22)
	Quit ReceiveDT
}

/// 查询检验科室对应的设备信息！
ClassMethod QueryOutLocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 查询单号详情
/// Table：        无
/// Input：        TransmitNo:单号
/// Output：       Num,DocRowID,PatName,Gender,Age,labNo,Adm,ColDate,ColTime,OutDate,OutTime,locName,userName,OutUserName,Transmit,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecType,ContainerNo,PackId
/// Return：       无
/// Others：		无
/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名machineooooooooooy称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCLabOutLocExec","QueryOutLocData","","","","","","","","","")
ClassMethod QueryOutLocDataExecute(ByRef qHandle As %Binary, TransmitNo As %String) As %Status
{
	Set TransmitNo=$Get(TransmitNo)
	S ^TMP("CMR")=TransmitNo
	S UserId=$g(%session.Data("LOGON.USERID"))
	S userLocID=$g(%session.Data("LOGON.CTLOCID"))
	S ^TMP("QQ")=UserId_"^"_userLocID
	S LabNameSapce="LABDATA"
	Set repid=$I(^CacheTemp)
	I $Get(ind)="" Set ind=1
	S (RowID,Transmit,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecType,ContainerNo)=""
	S (Num,DocRowID,PatName,Gender,Age,labNo,Adm,ColDate,ColTime,OutDate,OutTime,locName,userName,OutUserName,Transmit,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecType,ContainerNo,PackID)="" 
	I '$L(TransmitNo) Set qHandle=$lb(0,repid,0) Quit $$$OK	
	S Transmit=TransmitNo
	S RowId=$O(^DHCSpecTransi("TransNO",TransmitNo,""))
	S RowSubId=""
	F  S RowSubId=$O(^DHCSpecTrans(RowId,RowSubId)) Quit:RowSubId=""  D
	.S labNo=$P(^DHCSpecTrans(RowId,RowSubId),"^",1)
	.S OrdId=$O(^OEORD(0,"EpisNo",labNo,""))
	.S OrdSub=$O(^OEORD(0,"EpisNo",labNo,OrdId,""))
	.S DocRowID=OrdId_"||"_OrdSub
	.S locCode=$P(^DHCSpecTrans(RowId),"^",6)
	.S locName=$P(^CTLOC(locCode),"^",2)
	.S (patID,patRowId,Name,id,TSCode,TSName)=""
	.S patID=$Piece(^OEORD(OrdId,"I",OrdSub,3),"^",9)
	.I $Length(patID) Set patRowId=$Order(^PAPERi("PAPMI_PatNo",patID,""))
	.S Adm=patRowId
	.I $Length(patRowId) Set PatName=$Piece(^PAPER(patRowId,"ALL"),"^",1)
	.S SexDr=$Piece(^PAPER(patRowId,"ALL"),"^",7)
	.S Gender=$Piece(^CT("SEX",SexDr),"^",2)
	.S Age=$Piece((+$H-$Piece(^PAPER(patRowId,"ALL"),"^",6))/365,".",1)
	.S TSCode=$Piece(^OEORD(OrdId,"I",OrdSub,1),"^",2)
    .S TSName=$Piece(^ARCIM($Piece(TSCode,"||",1),$Piece(TSCode,"||",2),1),"^",2)
    .S OutDate=$Piece(^DHCSpecTrans(RowId),"^",4)
    .S OutTime=$Piece(^DHCSpecTrans(RowId),"^",5)
    .If $Length(OutDate),$Length(OutTime) Do
    ..Set OutDate=$ZD(OutDate,3)
    ..Set OutTime=$ZT(OutTime,2)
    .Set SpecCollDate=$p($g(^OEORD(OrdId,"I",OrdSub,"X",1,"NUR")),"^",2)
    .Set SpecCollTime=$p($g(^OEORD(OrdId,"I",OrdSub,"X",1,"NUR")),"^",3)
    .If $Length(SpecCollDate),$Length(SpecCollTime) Do
    ..Set ColDate=$zd($g(SpecCollDate),3)
    ..Set ColTime=$zt($g(SpecCollTime),2)
    .S RecieveDate=""
    .S RecieveTime=""
    .//S RecieveDate=$Piece(^DHCSpecTrans(RowId),"^",9)
    .//S RecieveTime=$Piece(^DHCSpecTrans(RowId),"^",10)
    .S RecieveDT=""
    .S RecieveDT=..GetRecieveDT(DocRowID,labNo)
    .S RecieveDate=$P(RecieveDT,"^",1),RecieveTime=$P(RecieveTime,"^",1)
    .//接收时间不存在，取统一接收时间。
    .i labNo=10005388 b ;1
    .I '$L(RecieveDate),$D(^[LabNameSapce]DHCSpecimenRegister(labNo)) D
    ..S RecieveDate=$P(^[LabNameSapce]DHCSpecimenRegister(labNo),"\",4)
    ..S RecieveTime=$P(^[LabNameSapce]DHCSpecimenRegister(labNo),"\",5)
    .//统一接收时间时间不存在,取技师工作站接收时间。
    .I '$L(RecieveDate),$D(^TEPI(labNo)) D
    ..S TestSet="" F  S TestSet=$O(^TEPI(labNo,1,TestSet)) Q:TestSet=""  D
    ...S RecieveDate=$P(^TEPI(labNo,1,TestSet,1),"\",21)
    ...S RecieveTime=$P(^TEPI(labNo,1,TestSet,1),"\",22)
    .If $Length(RecieveDate) D
    ..Set RecieveDate=$ZD(RecieveDate,3)
    .If $Length(RecieveTime) Do
    ..Set RecieveTime=$ZT(RecieveTime,2)
    .S userCode=$Piece(^DHCSpecTrans(RowId),"^",3)
    .I $L(userCode) S userName=$P(^SSU("SSUSR",userCode),"^",2) 
    .S OutUserCode=$Piece(^DHCSpecTrans(RowId),"^",8)
    .S OutUserName=""
    .I $L(OutUserCode) S OutUserName=$G(^DHCLabTransUserID("TransUser",OutUserCode))
    .S Remark=$Piece(^DHCSpecTrans(RowId,RowSubId),"^",4)
    .S PackID=$Piece(^DHCSpecTrans(RowId,RowSubId),"^",2)
    .S SpecType=$Piece(^DHCSpecTrans(RowId,RowSubId),"^",13)
    .If $Length(SpecType) Set SpecType=$Select(SpecType="S":"标本",SpecType="P":"血袋")
    .S FinshState=$Piece(^DHCSpecTrans(RowId,RowSubId),"^",3)
    .If $Length(FinshState) Set FinshState=$Select(FinshState="C||未完成":"未完成",FinshState="F||完成":"完成")
    .S RecieveUser=$Piece(^DHCSpecTrans(RowId),"^",11)
    .S ContainerNo=$Piece(^DHCSpecTrans(RowId,RowSubId),"^",6)
    .I $L(ContainerNo) S ContainerNo=$P(^TTAB("CON",ContainerNo),"\",1)
    .Set Num=Num+1
	.Set Data=$lb(Num,DocRowID,PatName,Gender,Age,labNo,Adm,ColDate,ColTime,OutDate,OutTime,locName,userName,OutUserName,Transmit,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecType,ContainerNo,PackId)
	.Do Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(Num,DocRowID,PatName,Gender,Age,labNo,Adm,OutDate,OutTime,locName,userName,OutUserName,Transmit,RecieveDate,RecieveTime,FinshState,Remark,TSName,RecieveUser,SpecType,ContainerNo,PackID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryOutLocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130608
/// Description:： 查询标本出科信息
/// Table：        DHCLab_OutOrdExec
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryOutLocData(TransmitNo As %String) As %Query(ROWSPEC = "Num:%String,DocRowID:%String,PatName:%String,Gender:%String,Age:%String,labNo:%String,Adm:%String,OutDate:%String,OutTime:%String,locName:%String,userName:%String,OutUserName:%String,Transmit:%String,RecieveDate:%String,RecieveTime:%String,FinshState:%String,Remark:%String,TSName:%String,RecieveUser:%String,SpecType:%String,ContainerNo:%String,PackID:%String")
{
}

ClassMethod QueryUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCLabOutLocExec","QueryOutLocData","","","","","","","","","")
ClassMethod QueryUserIDExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set UserID="" 
	For  Set UserID=$Order(^DHCSpecimenTrans("SSUSR",UserID)) Quit:UserID=""  Do
	.If '$Length(UserID) Quit
	.Set UserName=$Get(^DHCSpecimenTrans("SSUSR",UserID))
	.Set Data=$lb(UserID,UserName)
	.Do Output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(UserID,UserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20130608
/// Description:： 查询标本出科信息
/// Table：        DHCLab_OutOrdExec
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryUserID(input As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String")
{
}

/// Creator：      DaiYi
/// CreatDate：    20140410
/// Description:： 删除出库单上此条码信息
/// Table：        DHC_SpecTransDetails
/// Input：        Labno:条码号
/// Output：       SQLCODE
/// Return：       0:删除成功
/// Others：
ClassMethod Delete(Labno As %String) As %String
{
 S Labno=$G(Labno)
 &sql(delete from lab.DHC_SpecTransDetails where DSTD_Labno=:Labno)
 Q SQLCODE
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 计算指定日期单号关联标本的总数
/// Table：        DHC_SpecTrans
/// Input：        TransNo：单号
/// Output：       SQLCODE
/// Return：       0：成功
/// Others：		无
ClassMethod TatSum(TransNo As %String) As %String
{
	S TransNo=$G(TransNo)
	S Num=0
	I '$L(TransNo) Q Num
	S RowId=$O(^DHCSpecTransi("TransNO",TransNo,""))
	b ;1
	S RowSubId=""
	F  S RowSubId=$O(^DHCSpecTrans(RowId,RowSubId)) Q:RowSubId=""  D
	.S Num=Num+1
	Q Num
}

Storage Default
{
<Data name="DHCLabOutLocExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabOutLocExecD</DataLocation>
<DefaultData>DHCLabOutLocExecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabOutLocExecD</IdLocation>
<IndexLocation>^web.DHCLabOutLocExecI</IndexLocation>
<StreamLocation>^web.DHCLabOutLocExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
