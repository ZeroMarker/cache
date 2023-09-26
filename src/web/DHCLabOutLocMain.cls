Class web.DHCLabOutLocMain Extends %Persistent
{

Parameter BUILD = 60;

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 判断出库单号是否可以删除
/// Table：        无
/// Input：        TransNo：出库单号,ContainerNo：出库容器编码，TransUserId：运送用户工号
/// Output：       判断标志
/// Return：       0：正常，1^"..."：不能删除及原因
/// Others：		无
ClassMethod CheckTransNoDelete(TransNo As %String) As %String
{
	S TransNo=$G(TransNo)
	S ret=0
	I '$L(TransNo) S ret=""
	I ret'=0 Q ret
	S RowId=$O(^DHCSpecTransi("TransNO",TransNo,""))
	S Status=$P(^DHCSpecTrans(RowId),"^",12) 
	I Status="P||部分完成" S ret=1_"^出库单号已经交接不允许删除！"
	I ret'=0 Q ret
	Q ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 判断出库单号是否符合条件出科
/// Table：        无
/// Input：        TransNo：出库单号,ContainerNo：出库容器编码，TransUserId：运送用户工号
/// Output：       判断标志
/// Return：       0：正常，1^"..."：可以在前台判断是否进行更新处理，2^"..."：不能进行更新操作
/// Others：		无
ClassMethod CheckTransNo(TransNo As %String, ContainerNo As %String, TransUserId As %String) As %String
{
	S TransNo=$G(TransNo),ContainerNo=$G(ContainerNo),TransUserId=$G(TransUserId)
	S ret=0
	I '$L(TransNo) S ret=2_"^运送单号为空！"
	I ret'=0 Q ret
	S RowId=$O(^DHCSpecTransi("TransNO",TransNo,""))
	S Status=$P(^DHCSpecTrans(RowId),"^",12)
	I Status="P||部分完成" S ret=2_"^运送单号已经交接！"
	I ret'=0 Q ret 
	I '$L(ContainerNo) S ret=1_"^运送容器编码为空！"
	I '$L(TransUserId) S ret=1_"^运送用户为空！"
	I '$L(TransUserId),'$L(ContainerNo) S ret=1_"^运送容器运送用户为空！"
	Q ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 交接出库
/// Table：        DHC_SpecTrans
/// Input：        TransNo：出库单号,ContainerNo：出库容器编码，TransUserId：运送用户工号，UserId：护士用户工号，UserLocCode：护士所属科室ID
/// Output：       SQLCODE
/// Return：       0：插入成功
/// Others：		无
ClassMethod ExchangeTransNo(TransNo As %String, ContainerNo As %String, TransUserId As %String, UserId As %String, UserLocCode) As %String
{
	S TransNo=$G(TransNo),ContainerNo=$G(ContainerNo),TransUserId=$G(TransUserId),UserLocCode=$G(UserLocCode)
    S RowId=$O(^DHCSpecTransi("TransNO",TransNo,""))
    S OutDate=$Piece($H,",",1),OutTime=$Piece($H,",",2)
    //S FinshState="P||部分完成"
    K PLIST
    S PLIST(4)=UserId
    S PLIST(5)=OutDate
    S PLIST(6)=OutTime
    S PLIST(7)=UserLocCode
    S PLIST(8)=ContainerNo
    S PLIST(9)=TransUserId
    //S PLIST(13)=FinshState
    &sql(Update lab.DHC_SpecTrans Values :PLIST() Where DCST_RowID=:RowId)
    Q SQLCODE
}

ClassMethod QueryOutInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 查询单号详情
/// Table：        无
/// Input：        DateS：起始日期，DateE：结束日期
/// Output：       DateTimeNo：单号生成时间,TransNo：单号,TransType：运送类型,TransContainer：容器编号,Status：完成状态
/// Return：       无
/// Others：		无
/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCLabOutLocMain","QueryOutInfo","","")
ClassMethod QueryOutInfoExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set DateS=$Get(DateS),DateE=$Get(DateE)
    If '$Length(DateS) Set DateS=$H
	If '$Length(DateE) Set DateE=$H
	S userLocID=$g(%session.Data("LOGON.CTLOCID"))
	Set CurHospitalCode=$Order(^TTABi("CC",1,""))
	For Date=DateS:1:DateE Do
	.Set tt="" 
	.For  Set tt=$Order(^DHCSpecTransi("Date",Date,tt)) Quit:tt=""  Do
	..Set Transmitno=""
	..For  Set Transmitno=$Order(^DHCSpecTransi("Date",Date,tt,Transmitno)) Quit:Transmitno=""  Do
	...Set (RowId,LocDr,locName,SpType,Container,Status)=""
	...For  Set RowId=$Order(^DHCSpecTransi("Date",Date,tt,Transmitno,RowId)) Quit:RowId=""  Do
	....If $Length(RowId) Set LocDr=$Piece(^DHCSpecTrans(RowId),"^",6),SpType=$Piece(^DHCSpecTrans(RowId),"^",13),Container=$Piece(^DHCSpecTrans(RowId),"^",7)
	....S Status=$P(^DHCSpecTrans(RowId),"^",12)
	....S LocTrans=$P(^DHCSpecTrans(RowId),"^",6)
	....I $L(userLocID),userLocID'=LocTrans Q
	....I $L(Status) S Status=$P(Status,"||",2)
	....If $Length(SpType) Set SpType=$Select(SpType="S||标本":"标本",SpType="P||血袋":"血袋")
	....S DateTimeNo=$P(^DHCSpecTrans(RowId),"^",14)
	....Set DateTimeNo=$ZD(DateTimeNo,3)
	....If $Data(^TMP($zn,$j,"Transmit",Transmitno)),Container'[$Piece($Get(^TMP($zn,$j,"Transmit",Transmitno)),"^",4) Set Container=Container_","_$Piece($Get(^TMP($zn,$j,"Transmit",Transmitno)),"^",4)
	....Set ^TMP($zn,$j,"Transmit",Transmitno)=DateTimeNo_"^"_Transmitno_"^"_SpType_"^"_Container_"^"_Status
	Set Transmitno=""
	For  Set Transmitno=$Order(^TMP($zn,$j,"Transmit",Transmitno)) Quit:Transmitno=""  Do
	.Set DateTimeNo=$Piece(^TMP($zn,$j,"Transmit",Transmitno),"^",1)
	.Set TransNo=$Piece(^TMP($zn,$j,"Transmit",Transmitno),"^",2)
	.Set TransType=$Piece(^TMP($zn,$j,"Transmit",Transmitno),"^",3)
	.Set TransContainer=$Piece(^TMP($zn,$j,"Transmit",Transmitno),"^",4)
	.S Status=$P(^TMP($zn,$j,"Transmit",Transmitno),"^",5)
    .Set Data=$lb(DateTimeNo,TransNo,TransType,TransContainer,Status)
	.Do Output
	Kill ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
Output
	set Data=$lb(DateTimeNo,TransNo,TransType,TransContainer,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryOutInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOutLocDataExecute ]
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
Query QueryOutInfo(DateS As %String, DateE As %String) As %Query(ROWSPEC = "DateTimeNo:%String,TransNo:%String,TransType:%String,TransContainer:%String,Status:%String")
{
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 创建出库单号
/// Table：        无
/// Input：        无
/// Output：       出库单号
/// Return：       出库单号
/// Others：		无
ClassMethod CreatTranNo() As %String
{
  Set HospitalID=$Order(^TTABi("CC",1,""))
  //Set Pre=$Extract($Piece($Get(^TTAB("CC",HospitalID)),"\",8),1)
  Set order=+$Get(^DHCSPECTRANS(+$H))+1
  Set ^DHCSPECTRANS(+$H)=order
  Set RetNumber=$ZD(+$H,8)_$TR($J(order,3)," ","0")
  S TransNo=..GetTranNo()
  Quit TransNo
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 获取出库单号
/// Table：        无
/// Input：        无
/// Output：       出库单号
/// Return：       出库单号
/// Others：		无
ClassMethod GetTranNo() As %String
{
 
  Set RetNumber=0
  If $Data(^DHCSPECTRANS(+$H)) Do
  .Set HospitalID=$Order(^TTABi("CC",1,""))
  .//Set Pre=$Extract($Piece($Get(^TTAB("CC",HospitalID)),"\",8),1)
  .Set order=+$Get(^DHCSPECTRANS(+$H))
  .Set RetNumber=$ZD(+$H,8)_$TR($J(order,3)," ","0")
  Quit RetNumber
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 保存出库单好进系统
/// Table：        DHC_SpecTrans
/// Input：        TransNo：出库单号，UserLocCode：护士所属科室ID，SpecType：标本类型
/// Output：       SQLCODE
/// Return：       0：插入成功
/// Others：		无
ClassMethod SaveTransNo(TransNO As %String, UserLocCode As %String, SpecType As %String) As %String
{
 Kill P8
 Kill PLIST
 S ^TMP("XQ")=TransNO_","_UserLocCode_","_SpecType
 Set TransNO=$Get(TransNO),UserLocCode=$Get(UserLocCode),SpecType=$Get(SpecType)
 If SpecType="S" Set SpecType="S||标本"
 If SpecType="P" Set SpecType="P||血袋"
 Set TransDate=$Piece($H,",",1),TransTime=$Piece($H,",",2)
 Set LocName=""
 If UserLocCode="CXS" Do
 .Set LocRowid="CXS"
 .Set LocName="采血室"
 Else  Do
 .//Set LocRowid=$Order(^CTLOC(0,"Code",Dep,""),-1)
 .If $Length(UserLocCode) Set LocName=$Piece(^CTLOC(UserLocCode),"^",2)
 .If $Length(LocName,"-")>1 Set LocName=$Piece(LocName,"-",2)
 S HospCode=$O(^TTABi("CC",1,""))
 S PLIST(2)=HospCode
 Set PLIST(3)=TransNO
 Set PLIST(7)=UserLocCode
 Set PLIST(13)="C||未完成"
 Set PLIST(15)=TransDate
 Set PLIST(16)=TransTime
 Set PLIST(14)=SpecType
 b ;2
 If $Data(^DHCSpecTransi("TransNO",TransNO)) Quit "运送单号已存在！"
 &sql(Insert Into lab.DHC_SpecTrans Values :PLIST())
 S ret=SQLCODE
 Set TransDate=$ZD(TransDate,3),TransTime=$ZT(TransTime,2)
 Set TransDT=TransDate_" "_TransTime
 Set P8=$Char(9)_TransDT_$Char(9)_LocName_$Char(9)_TransNO_$Char(9)_SpecType
 Quit ret
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 删除出库单号
/// Table：        DHC_SpecTrans
/// Input：        TransNo：出库单号
/// Output：       SQLCODE
/// Return：       0：成功
/// Others：		无
ClassMethod DeleteTransNo(TransNo As %String) As %String
{
	S TransNo=$G(TransNo)
	S RowId=$O(^DHCSpecTransi("TransNO",TransNo,""))
	S (RowSubId,ret)=""
	S SQLCODE=0
	b ;1
	F  S RowSubId=$O(^DHCSpecTrans(RowId,RowSubId)) Q:RowSubId=""  D
	.S ret=..DeleteLabno(RowSubId)
	.I ret'=0  Q
	I SQLCODE=0 D
	.&sql(delete from lab.DHC_SpecTrans where DCST_RowID=:RowId)
	Q SQLCODE
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 删除出库单号上的条码号
/// Table：        DHC_SpecTrans
/// Input：        TransNo：出库单号
/// Output：       SQLCODE
/// Return：       0：成功
/// Others：		无
ClassMethod DeleteLabno(RowId As %String) As %String
{
	S RowId=$G(RowId)
	&sql(delete from lab.DHC_SpecTransDetails where DHTD_RowID=:RowId)
    Q SQLCODE
}

/// Creator：      Qiuxianfu
/// CreatDate：    20130410
/// Description:： 计算指定日期单号的总数
/// Table：        DHC_SpecTrans
/// Input：        DateS：起始日期，DateE：结束日期
/// Output：       SQLCODE
/// Return：       0：成功
/// Others：		无
ClassMethod TatSum(DateS As %String, DateE As %String) As %String
{
	S DateS=$G(DateS),DateE=$G(DateE)
	I '$L(DateS) S DateS=$ZD(+$H,4)
	I '$L(DateE) S DateE=$ZD(+$H,4)
	S DateS=$ZDH(DateS,4),DateE=$ZDH(DateE,4)
	S Sum=0
	S UserLocID=$g(%session.Data("LOGON.CTLOCID"))
	S ^DHCTMP("Qxf",1)=UserLocID
	F Date=DateS:1:DateE D
	.S DateSum=0
    .S DateSum=..TatDateSum(Date,UserLocID)
    .S Sum=Sum+DateSum
	Q Sum
}

ClassMethod TatDateSum(Date As %String, UserLocID As %String) As %String
{
	S Date=$G(Date),UserLocID=$G(UserLocID)
	S Num=0
	S Time=""
	F  S Time=$O(^DHCSpecTransi("Date",Date,Time)) Q:Time=""  D
	.S TransNo=""
	.F  S TransNo=$O(^DHCSpecTransi("Date",Date,Time,TransNo)) Q:TransNo=""  D
	..S RowID=""
	..F  S RowID=$O(^DHCSpecTransi("Date",Date,Time,TransNo,RowID)) Q:RowID=""  D
	...S CTLocID=$P(^DHCSpecTrans(RowID),"^",6)
	...I (UserLocID'=CTLocID)&&('$D(^CTLOC(UserLocID,"LINK",0,"Loc",CTLocID))) Q
	...S Num=Num+1
	Q Num
}

ClassMethod GetPath(None As %String) As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
    S NameSpace=Config.LabDataNamespace
    I '$L(NameSpace) S NameSpace="LABDATA"
	S ret=""
	S ret=$P(^[NameSpace]CF("SM",1),"^",11)
	I '$L(ret) S ret=$P(^CF("SM",1),"^",36)
	I $L(ret),$E(ret,$L(ret),$L(ret))'="\" S ret=ret_"\"
	Q ret
}

ClassMethod GetTransName(None As %String) As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
    S NameSpace=Config.LabDataNamespace
	S ret=",^"
	S TransUserId=""
	F  S TransUserId=$O(^DHCLabTransUserID("TransUser",TransUserId)) Q:TransUserId=""  D
	.S TransUserName=$G(^DHCLabTransUserID("TransUser",TransUserId))
	.S ret=ret_TransUserId_","_TransUserName_"^"
	I $L(ret)>2 S ret=$E(ret,1,$L(ret)-1)
	Q ret
}

Storage Default
{
<Data name="DHCLabOutLocMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabOutLocMainD</DataLocation>
<DefaultData>DHCLabOutLocMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabOutLocMainD</IdLocation>
<IndexLocation>^web.DHCLabOutLocMainI</IndexLocation>
<StreamLocation>^web.DHCLabOutLocMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
