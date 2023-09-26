Import SQLUser

Class web.DHCVISInterface Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/*
<?xml version="1.0" encoding="gb2312"?> <!—版本,编码信息-->
<PatientInfo>
    	<WindowName>窗口诊室名称</WindowName>
    	<WindowIP>IP地址</WindowIP>
    	<WindowDoctor>技师</WindowDoctor>
    	<WindowNote>说明</WindowNote>
		<!—就诊患者--->
        <VisitingPatient> 
        	<Name>患者姓名</Name>
        	<Sex>男/女</Sex>
			<QueueNo>排队号</QueueNo>
			<RegisterNo>登记号</RegisterNo>
			<Department>就诊科室</Department>
		</VisitingPatient>
                    :     <!—多个就诊患者--->
		<VisitingPatient>
               <Name>患者姓名</Name>
               <Sex>男/女</Sex>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department>
		</VisitingPatient>  
		<!—诊室门口候诊患者--->
        <WaitingPatient>
               <Name>患者姓名</Name>
               <Sex>男/女</Sex>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department> 
          </WaitingPatient>
                         :     <!—多个患者--->
          <WaitingPatient>
               <Name>患者姓名</Name>
               <Sex>男/女</Sex>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department>
          </WaitingPatient>
</PatientInfo>
*/
/// w ##Class(web.DHCVISInterface).RisInsertRegQueue("<PatientInfo>"_$c(10)_"  <State>Book</State>"_$c(10)_"  <IP>192.168.52.114</IP>"_$c(10)_"  <WindowName>胃镜诊室</WindowName>"_$c(10)_"  <Priority>平诊</Priority>"_$c(10)_"  <QueueNo>A111号</QueueNo>"_$c(10)_"  <PatientName>这是测试1</PatientName>"_$c(10)_"  <PatientSex>女</PatientSex>"_$c(10)_"  <RegisterNo>N20180809111</RegisterNo>"_$c(10)_"  <Department>胃肠镜室</Department>"_$c(10)_"  <CheckCat>内镜检查</CheckCat>"_$c(10)_"  <ScheduleDate>2018-08-09 00:00:00</ScheduleDate>"_$c(10)_"  <StudyGroup>胃肠镜</StudyGroup>"_$c(10)_"  <Doctor></Doctor>"_$c(10)_"</PatientInfo>")
ClassMethod RisInsertRegQueue(PatientInfo As %String = "") As %String
{
	Set $ZTrap = "VISMessageCatch1"
	i PatientInfo="" s PatientInfo="<?xml version=""1.0"" encoding=""gb2312""?>"_"<PatientInfo><State>Cancel</State ><IP></IP><WindowName>内镜三室</WindowName><Priority>普通</Priority><QueueNo>18</QueueNo><PatientName>李家平</PatientName><PatientSex>女</PatientSex><RegisterNo>ES20171205-023</RegisterNo><Department>WJS-胃镜室</Department><CheckCat></CheckCat><ScheduleDate></ScheduleDate><Doctor></Doctor><StudyGroup>检查分组</StudyGroup></PatientInfo>"
    s PatientInfo=$TR(PatientInfo,$C(10))
    s XMLTitle="<?xml version=""1.0"" encoding=""gb2312""?>"
    i $P(PatientInfo,XMLTitle,2)'="" s PatientInfo=$P(PatientInfo,XMLTitle,2)
    i $P(PatientInfo,"<!-版本,编码信息-->",2)'="" s PatientInfo=$P(PatientInfo,"<!-版本,编码信息-->",2)
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(PatientInfo)
    d reader.Correlate("PatientInfo","VIS.PatientInfo")
	While reader.Next(.person,.sc)
	{
       s ComputerIP=person.IP
       s WindowName=person.WindowName
       s QueueNo=person.QueueNo
       s PatientName=person.PatientName
       s PatientSex=person.PatientSex
       s Priority=person.Priority
       //必须传检查号(唯一标识)
       s RegisterNo=person.RegisterNo
       s Department=person.Department
       s Doctor=person.Doctor
       s State=person.State
       //s CheckCat=person.CheckCat
       s StudyGroup=person.StudyGroup
       s ScheduleDate=person.ScheduleDate
       q:State=""
       q:(WindowName="")
       s CreateDate=$p(ScheduleDate," ",1)  //预约时间
       i CreateDate="" s CreateDate=+$h
       e  s CreateDate=$zdh(CreateDate,3)
       s CreateTime=$P($H,",",2),PatientStatus="W"
       //预约
       i State="Book" d
       .s RegStateB=""
       .s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",CreateDate,RegisterNo,""),-1)
       .i RowID'="" s RegStateB=$p(^DHCVISRegQueue(RowID),"^",11)
       .s result="此检查号已预约"
       .q:(RowID'="")&&(RegStateB="Y")&&(State="Book")
       .s result=""
       .i RegStateB="" d
       ..s RegState="Y"
       ..s Note=""
       ..s PatientName=PatientName_"(预约)"
       ..&SQL(insert into DHC_VIS_RegQueue (QueueNo,PatientName,PatientSex,RegisterNo,Department,WindowName,Doctor,ComputerIP,RegState,CreateDate,CreateTime,Note,StudyGroup,PatientStatus)
         values (:QueueNo,:PatientName,:PatientSex,:RegisterNo,:Department,:WindowName,:Doctor,:ComputerIP,:RegState,:CreateDate,:CreateTime,:Note,:StudyGroup,:PatientStatus))
	   .i RegStateB="N" d
       ..s RegState="Y"
       ..s Note=""
       ..s PatientName=PatientName_"(预约)"
       ..&SQL(Update DHC_VIS_RegQueue set QueueNo=:QueueNo,PatientName=:PatientName,PatientSex=:PatientSex,RegisterNo=:RegisterNo,Department=:Department,WindowName=:WindowName,Doctor=:Doctor,ComputerIP=:ComputerIP,RegState=:RegState,CreateDate=:CreateDate,CreateTime=:CreateTime,Note=:Note,StudyGroup=:StudyGroup,PatientStatus=:PatientStatus where RowID=:RowID )
       //到达或预约并到达,重新报道
       i State="Reg" d
       .s RegStateold="",RegNameold=""
       .s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",CreateDate,RegisterNo,""),-1)
       .i RowID'="" s RegStateold=$p(^DHCVISRegQueue(RowID),"^",11),RegNameold=$p(^DHCVISRegQueue(RowID),"^",2)
       .s result="此检查号已登记"
       .q:(RowID'="")&&(RegStateold="Y")&&(State="Reg")&&(RegNameold'["(预约)")
       .s result=""
       .i RegStateold="" d
       ..s RegState="Y"
       ..s Note=""
       ..&SQL(insert into DHC_VIS_RegQueue (QueueNo,PatientName,PatientSex,RegisterNo,Department,WindowName,Doctor,ComputerIP,RegState,CreateDate,CreateTime,Note,StudyGroup,PatientStatus)
         values (:QueueNo,:PatientName,:PatientSex,:RegisterNo,:Department,:WindowName,:Doctor,:ComputerIP,:RegState,:CreateDate,:CreateTime,:Note,:StudyGroup,:PatientStatus))
	   .i RegStateold="N" d
       ..s RegState="Y"
       ..s Note=""
       ..&SQL(Update DHC_VIS_RegQueue set QueueNo=:QueueNo,PatientName=:PatientName,PatientSex=:PatientSex,RegisterNo=:RegisterNo,Department=:Department,WindowName=:WindowName,Doctor=:Doctor,ComputerIP=:ComputerIP,RegState=:RegState,CreateDate=:CreateDate,CreateTime=:CreateTime,Note=:Note,StudyGroup=:StudyGroup,PatientStatus=:PatientStatus where RowID=:RowID )
	   .i (RegStateold="Y")&&(RegNameold["(预约)") d
       ..s RegState="Y"
       ..s Note=""
       ..&SQL(Update DHC_VIS_RegQueue set QueueNo=:QueueNo,PatientName=:PatientName,PatientSex=:PatientSex,RegisterNo=:RegisterNo,Department=:Department,WindowName=:WindowName,Doctor=:Doctor,ComputerIP=:ComputerIP,RegState=:RegState,CreateDate=:CreateDate,CreateTime=:CreateTime,Note=:Note,StudyGroup=:StudyGroup,PatientStatus=:PatientStatus where RowID=:RowID )
	   //取消
	   i State="Cancel" d
	   .s result=""
	   .s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",CreateDate,RegisterNo,""),-1)
	   .&SQL(update DHC_VIS_RegQueue set RegState='N' where RowID=:RowID)
	   s Index=$I(^DHCVISRisQueue(+$H))
	   s ^DHCVISRisQueue(+$H,Index)="SQLCODE:"_SQLCODE_$G(ComputerIP)_"^"_$G(WindowName)_"^"_$G(QueueNo)_"^"_$G(PatientName)_"^"_$G(RegisterNo)_"^"_$G(Department)_"^"_$G(Doctor)
	   i result'=""  s result=result
	   e  s result=SQLCODE
	}
	q result
VISMessageCatch1
	q "Err"
}

/// w ##Class(web.DHCVISInterface).RisInsertVoiceQueue("<PatientInfo>"_$c(10)_"  <WindowName>超声科1诊室</WindowName>"_$c(10)_"  <WindowIP>172.19.19.23</WindowIP>"_$c(10)_"  <WindowDoctor></WindowDoctor>"_$c(10)_"  <WindowNote>请大家保持安静,等候医生呼叫!</WindowNote>"_$c(10)_"  <VisitingPatient>"_$c(10)_"    <Name>GF05</Name>"_$c(10)_"    <Sex>女</Sex>"_$c(10)_"    <Priority>平诊</Priority>"_$c(10)_"    <QueueNo>JJ001号</QueueNo>"_$c(10)_"    <RegisterNo>U20200812003</RegisterNo>"_$c(10)_"    <Department>超声医学科</Department>"_$c(10)_"  </VisitingPatient>"_$c(10)_"  <WaitingPatient></WaitingPatient>"_$c(10)_"  <SkipPatient></SkipPatient>"_$c(10)_"</PatientInfo>")
/// w ##Class(web.DHCVISInterface).RisInsertVoiceQueue(^DHCVISRisTest(65603,"RisSendVoice",3))
ClassMethod RisInsertVoiceQueue(PatientInfo As %String = "") As %String
{
	Set $ZTrap = "VISMessageCatch2"
	i PatientInfo="" s PatientInfo="<PatientInfo><WindowName>01诊室</WindowName><WindowIP>10.8.1.14</WindowIP><WindowDoctor></WindowDoctor><WindowNote></WindowNote><VisitingPatient><Name>王运友</Name><QueueNo>12号</QueueNo><RegisterNo>0000011033</RegisterNo><Department>皮肤科</Department></VisitingPatient><WaitingPatient><Name>何光</Name><QueueNo>13号</QueueNo><RegisterNo>0000011034</RegisterNo><Department>皮肤科</Department></WaitingPatient><WaitingPatient><Name>陈俊达</Name><QueueNo>14号</QueueNo><RegisterNo>0000011035</RegisterNo><Department>皮肤科</Department></WaitingPatient><SkipPatient><Name>患者姓名</Name><Sex>患者性别</Sex><Priority>平诊</Priority><QueueNo>排队号</QueueNo><RegisterNo>登记号/检查号</RegisterNo><Department>就诊科室</Department></SkipPatient></PatientInfo>"
	//s objStream=##class(%GlobalCharacterStream).%New()
	//d objStream.Write(PatientInfo)
	//Do objStream.Rewind()
	s PatientInfo=$TR(PatientInfo,$C(10))
	s PatientInfo=$TR(PatientInfo," ")
    s XMLTitle="<?xml version=""1.0"" encoding=""gb2312""?>"
    i $P(PatientInfo,XMLTitle,2)'="" s PatientInfo=$P(PatientInfo,XMLTitle,2)
    i $P(PatientInfo,"<!-版本,编码信息-->",2)'="" s PatientInfo=$P(PatientInfo,"<!-版本,编码信息-->",2)
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(PatientInfo)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("PatientInfo","VIS.WindowInfo")
	While reader.Next(.person,.sc)
	{
		s WindowName=person.WindowName
		s WindowIP=person.WindowIP
		s WindowDoctor=person.WindowDoctor
		s WindowNote=person.WindowNote
	}

	Do reader.Rewind()
    d reader.Correlate("VisitingPatient","VIS.WaitPatient")
	While reader.Next(.person,.sc)
	{
		s VisitPatName=person.Name
		s PatientSex=person.Sex
		s VisitQueueNo=person.QueueNo
		s VisitRegisterNo=person.RegisterNo
		s VisitDepartment=person.Department
		i VisitDepartment="胃肠镜室" s StateFlag=..SelectRegPatState(VisitRegisterNo)
		s UpdateRegRet=..UpdateRegCallPatState(VisitRegisterNo,"C",WindowIP)
		s VisitPatName=$TR(VisitPatName," ")
		s VisitQueueNo=$TR(VisitQueueNo," ")
		i VisitQueueNo["JZ" s Priority="急诊"
		//s VisitQueueNo=$E(VisitQueueNo,$L(VisitQueueNo)-2,$L(VisitQueueNo))
		//s VisitQueueNo=+VisitQueueNo
		i VisitQueueNo'["号" s VisitQueueNo=VisitQueueNo_"号"
		i $G(Priority)'="" s VisitQueueNo=Priority_VisitQueueNo
		s VisitRegisterNo=person.RegisterNo
		s VisitDepartment=person.Department
	}
	
	Do reader.Rewind()
    d reader.Correlate("WaitingPatient","VIS.WaitPatient")
    s WaitPat=""
	While reader.Next(.person,.sc)
	{
		s WaitPatName=person.Name
		q:WaitPatName=""
		s PatientSex=person.Sex
		s WaitQueueNo=person.QueueNo
		//s WaitQueueNo=$E(WaitQueueNo,$L(WaitQueueNo)-2,$L(WaitQueueNo))
		//s WaitQueueNo=+WaitQueueNo
		i WaitQueueNo'["号" s WaitQueueNo=WaitQueueNo_"号"
		s WaitRegisterNo=person.RegisterNo
		s WaitDepartment=person.Department
		i WaitPat="" s WaitPat=WaitQueueNo_"-"_WaitPatName
		e  s WaitPat=WaitPat_","_WaitQueueNo_"-"_WaitPatName
	}
	Do reader.Rewind()
    d reader.Correlate("SkipPatient","VIS.WaitPatient")
    //叫号传过号病人解析
    s SkipPatient=""
	While reader.Next(.person,.sc)
	{
		s SkipPatName=person.Name
		q:SkipPatName=""
		s PatientSex=person.Sex
		s SkipPatientNo=person.QueueNo
		s SkipPatientNo=$E(SkipPatientNo,$L(SkipPatientNo)-2,$L(SkipPatientNo))
		s SkipPatientNo=+SkipPatientNo
		i SkipPatientNo'["号" s SkipPatientNo=SkipPatientNo_"号"
		s SkipRegisterNo=person.RegisterNo
		s SkipDepartment=person.Department
		i SkipPatient="" s SkipPatient=SkipPatientNo_"-"_SkipPatName
		e  s SkipPatient=SkipPatient_","_SkipPatientNo_"-"_SkipPatName
	}
	s WindowIP=$TR(WindowIP," ")
	i WindowIP'="" d
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",WindowIP,""))
	.i clientId'="" d
	..s WindowName=$P($G(^DHCVISClient(clientId)),"^",3)
	..s ServerId=$P($G(^DHCVISClient(clientId)),"^",1)
	s IPAddress=WindowIP
	s UserID="1"
	i VisitDepartment="胃肠镜室" d 
	.i StateFlag="W" d
	..s voiceContent="请 "_VisitQueueNo_" "_VisitPatName_" 到 "_WindowName_" 准备"
	.i StateFlag="C" d
	..s voiceContent="请 "_VisitQueueNo_" "_VisitPatName_" 到 "_WindowName_" 就诊"
	e  s voiceContent="请 "_VisitQueueNo_" "_VisitPatName_" 到 "_WindowName_" 检查"
	s ZHScreenStr=..FromatZHStr(WindowName,VisitQueueNo,VisitPatName,WaitPat)
	// LZX - 希望 B超 也能 取 CKSCreenStr数据
	s $P(CKScreenStr,"!",2)=WindowName
	s $P(CKScreenStr,"!",5)=VisitQueueNo
	s $P(CKScreenStr,"!",6)=VisitPatName
	s $P(CKScreenStr,"!",7)=$TR($P(WaitPat,","),",")
	s $P(CKScreenStr,"!",8)=$TR($P(WaitPat,",",2),",")
	s WaitList=WaitPat
	s Note=WindowName_" "_VisitQueueNo_" "_VisitPatName_" "_WindowDoctor
	s type="R"
	s sound="LR"
	s repeat="N"
	s retStr=##Class(web.DHCVISVoiceCall).InsertVoiceQueue(voiceContent,UserID,IPAddress,type,sound,repeat,ZHScreenStr,CKScreenStr,WaitList,Note)
	q retStr
VISMessageCatch2
	q "Err"
}

/// 内腔镜修改,第一次是准备，第二次是检查
/// cy20180725
ClassMethod SelectRegPatState(RegisterNo As %String = "") As %String
{
	q:RegisterNo="" "检查号为空！"
    s RegisterNo=$tr(RegisterNo," ")
    s nowDate=+$h
    s State="W"
    s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",nowDate,RegisterNo,""),-1)
    q:RowID="" "未找到此人！"
    s State=$p((^DHCVISRegQueue(RowID)),"^",13)
    q State
}

/// 呼叫时我组更改呼叫状态
/// cy20180716
ClassMethod UpdateRegCallPatState(RegisterNo As %String = "", PatStatus As %String = "", WindowIP As %String = "") As %String
{
 
    q:RegisterNo="" "检查号为空！"
    q:PatStatus="" "状态不能为空！"
    q:WindowIP="" "呼叫电脑IP不能为空！"
    s WindowIP=$TR(WindowIP," ")
    s RegisterNo=$tr(RegisterNo," ")
    s nowDate=+$h
    s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",nowDate,RegisterNo,""),-1)
    q:RowID="" "未找到此人！"
    &SQL(Update DHC_VIS_RegQueue set PatientStatus=:PatStatus,ComputerIP=:WindowIP where RowID=:RowID)
    q SQLCODE
}

/// w ##Class(web.DHCVISInterface).FromatZHStr("01诊室","111号","龚平","112号龚平")
ClassMethod FromatZHStr(WindowName As %String = "", VisitQueueNo As %String = "", VisitPatName As %String = "", WaitPat As %String = "") As %String
{
	s retStr=""
	s WindowName=$$ALPHAUP^SSUTIL4(WindowName)
	s RoomLen=$L(WindowName)
	i WindowName["0" s RoomLen=RoomLen-1
	i RoomLen>7 s WindowName=$E(WindowName,1,7)
	i RoomLen=6 s WindowName=WindowName_"    "
	i RoomLen=5 s WindowName=WindowName_"        "
	i RoomLen=4 s WindowName=WindowName_"            "
	i RoomLen=3 s WindowName=WindowName_"                "
	i RoomLen=2 s WindowName=WindowName_"                    "
	s VisitQueueNo=+VisitQueueNo
    i VisitQueueNo<10 s VisitQueueNoDesc=" "_VisitQueueNo_"号     "
	i ((VisitQueueNo<100)&&(VisitQueueNo>9)) s VisitQueueNoDesc=VisitQueueNo_"号    "
	i (VisitQueueNo>99)  s VisitQueueNoDesc=VisitQueueNo_"号  "
	s VisitPatName=$$ALPHAUP^SSUTIL4(VisitPatName)
	s VisitPatName=$TR(VisitPatName,$C(0,10,13))
	s VisitPatName=$TR(VisitPatName,"0123456789")
	i $l(VisitPatName)=3 s VisitPatName=VisitPatName_"    "
	i $l(VisitPatName)=2 s VisitPatName=VisitPatName_"        "
	s retStr=WindowName_VisitQueueNoDesc_VisitPatName_"    "_WaitPat
	q retStr
}

/// creator:	zhangyanlin
/// createtime:	201711191102
/// function:	改变医技病人的状态
/// rucan:		patientinfo 包括检查号，病人检查的唯一标识\病人状态：R/W/S/F/C
/// retutn:		sqlcode
/// note:		
/// w ##Class(web.DHCVISInterface).UpdatePatStatus("745","11")
ClassMethod UpdatePatStatus(PatientInfo As %String = "") As %String
{
	Set $ZTrap = "VISMessageCatch5"
    i PatientInfo="" s PatientInfo="<?xml version=""1.0"" encoding=""gb2312""?>"_"<PatientInfo><RegisterNo>ES20171205-023</RegisterNo><PatStatus>S</PatStatus></PatientInfo>"
    s PatientInfo=$TR(PatientInfo,$C(10))
    s XMLTitle="<?xml version=""1.0"" encoding=""gb2312""?>"
    i $P(PatientInfo,XMLTitle,2)'="" s PatientInfo=$P(PatientInfo,XMLTitle,2)
    i $P(PatientInfo,"<!-版本,编码信息-->",2)'="" s PatientInfo=$P(PatientInfo,"<!-版本,编码信息-->",2)
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(PatientInfo)
    d reader.Correlate("PatientInfo","VIS.PatientInfo")
	While reader.Next(.person,.sc)
	{
       s RegisterNo=person.RegisterNo
       s PatStatus=person.PatStatus
       s nowDate=+$h
       s RowID=$O(^DHCVISRegQueuei(0,"DateRegisterNo",nowDate,RegisterNo,""),-1)
       &SQL(Update DHC_VIS_RegQueue set PatientStatus=:PatStatus where RowID=:RowID)
    }
	q SQLCODE
VISMessageCatch5
	q "Err"
}

/// w ##Class(web.DHCVISInterface).RisInsertReport("<PatientInfo><IP>172.22.22.1</IP><WindowName>TOSHIBA640</WindowName><QueueNo>141</QueueNo><PatientName>刘济万</PatientName><PatientSex>男</PatientSex><RegisterNo></RegisterNo><ReportFlag>N</ReportFlag><Department></Department><Doctor></Doctor><CheckNo>109090</CheckNo><CheckCat></CheckCat></PatientInfo>")
ClassMethod RisInsertReport(PatientInfo As %String = "") As %String
{
	Set $ZTrap = "VISMessageCatch3"
	i PatientInfo="" s PatientInfo="<?xml version=""1.0"" encoding=""gb2312""?>"_"<PatientInfo><IP>10.8.22.13</IP><WindowName>01诊室</WindowName><QueueNo>12号</QueueNo><PatientName>王运友</PatientName><RegisterNo>0000011033</RegisterNo><ReportFlag>Y</ReportFlag><Department>皮肤科</Department><Doctor></Doctor><CheckNo>112</CheckNo></PatientInfo>"
    s PatientInfo=$TR(PatientInfo,$C(10))
    s XMLTitle="<?xml version=""1.0"" encoding=""gb2312""?>"
    i $P(PatientInfo,XMLTitle,2)'="" s PatientInfo=$P(PatientInfo,XMLTitle,2)
    i $P(PatientInfo,"<!-版本,编码信息-->",2)'="" s PatientInfo=$P(PatientInfo,"<!-版本,编码信息-->",2)
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(PatientInfo)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("PatientInfo","VIS.PatientInfo")
    //Do reader.Rewind()
	While reader.Next(.person,.sc)
	{
       s IP=person.IP
       s WindowName=person.WindowName
       s QueueNo=person.QueueNo
       s PatientName=person.PatientName
       s PatientSex=person.PatientSex
       s RegisterNo=person.RegisterNo
       s Department=person.Department
       s ReportFlag=person.ReportFlag
       s Doctor=person.Doctor
       s CheckNo=person.CheckNo
       s CheckCat=person.CheckCat
       i ReportFlag="N" d
       .s Ret=..InsertReportQueue(IP,WindowName,QueueNo,PatientName,PatientSex,RegisterNo,Department,Doctor,CheckNo,CheckCat)
	   i ReportFlag="Y" d
	   .s Ret=..UpdateReportState(CheckNo)
	   s Index=$I(^DHCVISRisQueue(+$H,"InsertReport"))
	   s ^DHCVISRisReport(+$H,"InsertReport",Index)="Ret:"_Ret_$G(IP)_"^"_$G(WindowName)_"^"_$G(QueueNo)_"^"_$G(PatientName)_"^"_$G(RegisterNo)_"^"_$G(Department)_"^"_$G(Doctor)
	}
	q Ret
VISMessageCatch3
	q "Err"
}

///  w ##Class(web.DHCVISInterface).InsertReportQueue("172.22.22.1","TOSHIBA640","","刘济万","男","","","","109090","")
ClassMethod InsertReportQueue(ComputerIP As %String = "", WindowName As %String = "", QueueNo As %String = "", PatientName As %String = "", PatientSex As %String = "", RegisterNo As %String = "", Department As %String = "", Doctor As %String = "", CheckNo As %String = "", CheckCat As %String = "") As %String
{
	
	q:CheckNo="" "检查号为空！"
	s ReportState="N"
	s CreateDate=+$H,CreateTime=$P($H,",",2),UpdateDate=+$H,UpdateTime=$P($H,",",2)
	s Note=""
	i CheckNo'="" d
	.s RowID=$O(^DHCVISReportQueuei(0,"CheckNo",CheckNo,""))
	q:($G(RowID)'="") "该检查号已发布报告！" 
	&SQL(insert into DHC_VIS_ReportQueue(QueueNo,PatientName,PatientSex,RegisterNo,Department,WindowName,Doctor,CheckNo,CheckCat,ComputerIP,ReportState,CreateDate,CreateTime,UpdateDate,UpdateTime,Note) 
	values (:QueueNo,:PatientName,:PatientSex,:RegisterNo,:Department,:WindowName,:Doctor,:CheckNo,:CheckCat,:ComputerIP,:ReportState,:CreateDate,:CreateTime,:UpdateDate,:UpdateTime,:Note))
	q SQLCODE
}

/// w ##Class(web.DHCVISInterface).UpdateReportState(109228)
ClassMethod UpdateReportState(CheckNo As %String = "") As %String
{
	q:CheckNo="" "检查号为空！"
	s ReportState="Y"
	s UpdateDate=+$H,UpdateTime=$P($H,",",2)
	i CheckNo'="" d
	.s RowID=$O(^DHCVISReportQueuei(0,"CheckNo",CheckNo,""))
	.i $g(^DHCVISReportQueue(RowID))'="" d
	..s State=$p(^DHCVISReportQueue(RowID),"^",11)
	q:State'="N" "该检查报告已清除"
	q:($G(RowID)="") "该检查报告不存在！"
	&SQL(Update DHC_VIS_ReportQueue set ReportState=:ReportState,UpdateDate=:UpdateDate,UpdateTime=:UpdateTime where RowID=:RowID) 
	q SQLCODE
}

}
