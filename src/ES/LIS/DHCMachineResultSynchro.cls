Class ES.LIS.DHCMachineResultSynchro Extends %RegisteredObject
{

/// Creator：      xuzhiguo
/// CreatDate：    20210824
/// Description：  查询仪器结果
/// Input：        fReceiveDate：接收日期、WorkGroupDR：工作组
/// Output：       
/// d ##Class(%ResultSet).RunQuery("ES.LIS.DHCMachineResultSynchro","QryMachineResult","2021-08-31","1","","","","","","","","","","","10","2","113^3^0^12^1")
Query QryMachineResult(fReceiveDate, WorkGroupDR, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "MachineResultID,WorkGroupMachine,ReceiveDate,AssayNo,TestCode,Result,TextRes,ExtraRes,ResultDate,MachineParameterDR,MachineDesc,EpisodeNo,ResultFlag,OtherRes,ResNoes")
{
}

ClassMethod QryMachineResultExecute(ByRef qHandle As %Binary, fReceiveDate, WorkGroupDR, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, PageSize, PageIndex, Sessions, Output RowCount As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	s RowCount=0 
	
	k ^TMP($zn,$j,"DATA")
	
	s fReceiveDate=$g(fReceiveDate)
	s WorkGroupDR=$g(WorkGroupDR)
	s Sessions=$g(Sessions)
	i $l(fReceiveDate) s fReceiveDate=$tr(fReceiveDate,"-")
	i '$l(fReceiveDate) s fReceiveDate=$zd($p($h,",",1),8)
	s PageSize=$g(PageSize)
	s PageIndex=$g(PageIndex)
	
	s PageSize=+$g(PageSize),PageIndex=+$g(PageIndex),ToRow=0,FormRow=0
 	i PageIndex>0,PageSize>0 s ToRow=PageIndex*PageSize,FormRow=ToRow-PageSize+1
	
	s WorkGroupMachineCode=""
	f  s WorkGroupMachineCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WorkGroupMachineCode)) q:WorkGroupMachineCode=""  d
	.s WorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WorkGroupMachineCode,""))
	.zw WorkGroupMachineDR
	.s fAssayNo="" f  s fAssayNo=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo)) q:fAssayNo=""  d
	..zw fAssayNo
	..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo,TestCodeDR)) q:TestCodeDR=""  d
	...s MachineResultID=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo,TestCodeDR,""))
	...s MachineResultData=$g(^dbo.RPMachineResultD(MachineResultID))
	...s WorkGroupMachine=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)
	...s ReceiveDate=$lg(MachineResultData,3)
	...i $l(ReceiveDate) s ReceiveDate=$zd($zdh(ReceiveDate,8),3)
	...s ReceiveTime=$lg(MachineResultData,4)
	...i $l(ReceiveTime) s ReceiveTime=$zt(ReceiveTime,1)
	...s ReceiveDate=ReceiveDate_" "_ReceiveTime
	...s AssayNo=$lg(MachineResultData,5)
	...s TestCode=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
	...s Result=$lg(MachineResultData,7)
	...s TextRes=$lg(MachineResultData,8)
	...s ExtraRes=$lg(MachineResultData,9)
	...s ResultDate=$lg(MachineResultData,10)
	...i $l(ResultDate) s ResultDate=$zd($zdh(ResultDate,8),3)
	...s ResultTime=$lg(MachineResultData,11)
	...i $l(ResultTime) s ResultTime=$zt(ResultTime,1)
	...s MachineParameterDR=$lg(MachineResultData,12)
	...s MachineDesc=""
	...i $l(MachineParameterDR) s MachineDesc=$lg($g(^dbo.BTMIMachineParameterD(MachineParameterDR)),3)
	...s EpisodeNo=$lg(MachineResultData,13)
	...s ResultFlag=$lg(MachineResultData,14)
	...s OtherRes=$lg(MachineResultData,15)
	...s ResNoes=$lg(MachineResultData,16)
	...d OutPut
	
	
	s sortNum=0
	s MachineParameterDR=""
	f  s MachineParameterDR=$o(^TMP($zn,$j,"DATA","EpisodeNo",MachineParameterDR)) q:MachineParameterDR=""  d
	.s AssayNo="" f  s AssayNo=$o(^TMP($zn,$j,"DATA","EpisodeNo",MachineParameterDR,AssayNo)) q:AssayNo=""  d
	..s count="" f  s count =$o(^TMP($zn,$j,"DATA","EpisodeNo",MachineParameterDR,AssayNo,count)) q:count=""  d
	...s Data=$g(^TMP($zn,$j,"DATA","EpisodeNo",MachineParameterDR,AssayNo,count)) 
	...s sortNum=sortNum+1
	...i FormRow>0,ToRow>0,FormRow>sortNum q
	...i FormRow>0,ToRow>0,ToRow<sortNum q
	...S ^CacheTemp(repid,ind)=Data
	...S ind=ind+1

	k ^TMP($zn,$j,"DATA")
	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK

OutPut         
	s RowCount=RowCount+1
	s Data=$lb(MachineResultID,WorkGroupMachine,ReceiveDate,AssayNo,TestCode,Result,TextRes,ExtraRes,ResultDate,MachineParameterDR,MachineDesc,EpisodeNo,ResultFlag,OtherRes,ResNoes)
 	s ^TMP($zn,$j,"DATA","EpisodeNo",MachineParameterDR,AssayNo,RowCount)=Data
 	;Set ^CacheTemp(repid,ind)=Data
 	;Set ind=ind+1
	Quit
}

ClassMethod QryMachineResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMachineResultExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMachineResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMachineResultExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      xuzhiguo
/// CreatDate：    20210824
/// Description：  查询仪器结果推送
/// Input：        fReceiveDate：接收日期、WorkGroupDR：工作组
/// Output： 
/// w ##Class(ES.LIS.DHCMachineResultSynchro).MachineResultPushMTHD("5","20210830", "", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod MachineResultPushMTHD(WorkGroupDR, fReceiveDate, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	s ^MTMPLIS("MachineResultPush")=$lb(WorkGroupDR, fReceiveDate)
	
	s fReceiveDate=$g(fReceiveDate)
	s WorkGroupDR=$g(WorkGroupDR)
	s Sessions=$g(Sessions)
	i $l(fReceiveDate) s fReceiveDate=$tr(fReceiveDate,"-")
	i '$l(fReceiveDate) s fReceiveDate=$zd($p($h,",",1),8)
	
	s Address=""
    s paramDR = $o(^dbo.SYSParameterI("IndexCode"," PROSYNCADDRESS", " SYS"," DHCC",""))
	i $l(paramDR) s Address = $lg(^dbo.SYSParameterD(paramDR),6)
    i '$l(Address)  q "-1^系统参数表未维护待同步库的WebService地址"
	
	s WorkGroupMachineCode=""
	f  s WorkGroupMachineCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WorkGroupMachineCode)) q:WorkGroupMachineCode=""  d
	.s WorkGroupMachineDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,WorkGroupMachineCode,""))
	.s fAssayNo="" f  s fAssayNo=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo)) q:fAssayNo=""  d
	..s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo,TestCodeDR)) q:TestCodeDR=""  d
	...s MachineResultID=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,fReceiveDate,fAssayNo,TestCodeDR,""))
	...s MachineResult=$g(^dbo.RPMachineResultD(MachineResultID))
	...s WorkGroupMachineDR=$lg(MachineResult,2)
	...s ReceiveDate=$lg(MachineResult,3)
	...s ReceiveTime=$lg(MachineResult,4)
	...s AssayNo=$lg(MachineResult,5)
	...s TestCodeDR=$lg(MachineResult,6)
	...s Result=$lg(MachineResult,7)
	...s TextRes=$lg(MachineResult,8)
	...s ExtraRes=$lg(MachineResult,9)
	...s ResultDate=$lg(MachineResult,10)
	...s ResultTime=$lg(MachineResult,11)
	...s MachineParameterDR=$lg(MachineResult,12)
	...s EpisodeNo=$lg(MachineResult,13)
	...s ResultFlag=$lg(MachineResult,14)
	...s OtherRes=$lg(MachineResult,15)
	...s ResNoes=$lg(MachineResult,16)
	...B //数据组装
	...s RetXML=##class(LIS.Util.COM.XML).New("Response")
	...s objMachineResult=##class(LIS.Util.COM.XML).New("Body")
	...s MachineInfo=##class(LIS.Util.COM.XML).New("MachineInfo")
	...s MachineInfo.WorkGroupMachineDR=WorkGroupMachineDR
	...s MachineInfo.ReceiveDate=ReceiveDate
	...s MachineInfo.ReceiveTime=ReceiveTime
	...s MachineInfo.AssayNo=AssayNo
	...s MachineInfo.TestCodeDR=TestCodeDR
	...s MachineInfo.Result=Result
	...s MachineInfo.TextRes=TextRes
	...s MachineInfo.ExtraRes=ExtraRes
	...s MachineInfo.ResultDate=ResultDate
	...s MachineInfo.ResultTime=ResultTime
	...s MachineInfo.MachineParameterDR=MachineParameterDR
	...s MachineInfo.EpisodeNo=EpisodeNo
	...s MachineInfo.ResultFlag=ResultFlag
	...s MachineInfo.OtherRes=OtherRes
	...s MachineInfo.ResNoes=ResNoes
	...d objMachineResult.Insert(MachineInfo)
	...d RetXML.Insert(objMachineResult)
	...s InParam=RetXML.ToXML()
	...s objStream=##class(%GlobalCharacterStream).%New()
	...d objStream.Write(InParam)  
	...s strStream=objStream.Read()         
	...s ret=##class(LIS.WS.DHCLISServiceBase).RemoteGetData(Address,"ES.LIS.DHCMachineResultSynchro","MachineResultstorageMTHD",strStream,"", "", "", "", "", "", "", "", "", "", "", "", "", Sessions,"")    
	...//s ret=##Class(ES.LIS.DHCMachineResultSynchro).MachineResultstorage(objStream)
	...i ret=1 &sql(delete from dbo.RP_MachineResult where RowID=:MachineResultID) 
	
 	q 0
}

/// Creator：      xuzhiguo
/// CreatDate：    20210824
/// Description：  仪器结果推送
/// Input：        数据流
/// Output： 
/// w ##Class(ES.LIS.DHCMachineResultSynchro).MachineResultstorage("8","", "", "", "", "", "", "", "", "", "", "", "", "", "")
ClassMethod MachineResultstorageMTHD(Input, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	s ^MTMPLIS("MachineResultstorage")=$lb(Input, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions)
	//s Input=$g(Input)
	s ret=""
	//s objStream=Input.Read()
	s xmlData=##class(LIS.Util.COM.XML).FromXML(Input) 
	s MachineBody=xmlData.Body

    f i=0:1:(MachineBody.Length()) d
	.s MachineInfo=MachineBody.Get(i)
	.q:'$l(MachineInfo)
	.s WorkGroupMachineDR=MachineInfo.WorkGroupMachineDR
	.s ReceiveDate=MachineInfo.ReceiveDate
	.s ReceiveTime=MachineInfo.ReceiveTime
	.s AssayNo=MachineInfo.AssayNo
	.s TestCodeDR=MachineInfo.TestCodeDR
	.s Result=MachineInfo.Result
	.s TextRes=MachineInfo.TextRes
	.s ExtraRes=MachineInfo.ExtraRes
	.s ResultDate=MachineInfo.ResultDate
	.s ResultTime=MachineInfo.ResultTime
	.s MachineParameterDR=MachineInfo.MachineParameterDR
	.s EpisodeNo=MachineInfo.EpisodeNo
	.s ResultFlag=MachineInfo.ResultFlag
	.s OtherRes=MachineInfo.OtherRes
	.s ResNoes=MachineInfo.ResNoes
	.s MachineResultID=$o(^dbo.RPMachineResultI("IndexMaster",WorkGroupMachineDR,ReceiveDate,##Class(LIS.Util.Common).IndexData(AssayNo),TestCodeDR,""))
	.i $l(MachineResultID) d
	..s objMachineResult=##class(dbo.RPMachineResult).%OpenId(MachineResultID)
	.e  d
	..s objMachineResult=##class(dbo.RPMachineResult).%New()
	.s objMachineResult.WorkGroupMachineDR=WorkGroupMachineDR
	.s objMachineResult.ReceiveDate=ReceiveDate
	.s objMachineResult.ReceiveTime=ReceiveTime
	.s objMachineResult.AssayNo=AssayNo
	.s objMachineResult.TestCodeDR=TestCodeDR
	.s objMachineResult.Result=Result
	.s objMachineResult.TextRes=TextRes
	.s objMachineResult.ExtraRes=ExtraRes
	.s objMachineResult.ResultDate=ResultDate
	.s objMachineResult.ResultTime=ResultTime
	.s objMachineResult.MachineParameterDR=MachineParameterDR
	.s objMachineResult.EpisodeNo=EpisodeNo
	.s objMachineResult.ResultFlag=ResultFlag
	.s objMachineResult.OtherRes=OtherRes
	.s objMachineResult.ResNoes=ResNoes
	.s sc=objMachineResult.%Save()
	.If ($SYSTEM.Status.IsOK(sc)) d
    ..s ret=1
	.Else  d
	..s ret="-1^仪器结果保存失败:"_$SYSTEM.Status.GetErrorText(sc) 
	
	
 	q ret
}

/// Creator：      xuzhiguo
/// CreatDate：    20210824
/// Description：  医嘱项目外部代码同步到应急库
/// Input：        医院代码
/// Output： 
/// w ##Class(ES.LIS.DHCMachineResultSynchro).HISOrderSynchro("DHSZHYYZY")
ClassMethod HISOrderSynchro(HospitalCode, Output RetValue As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	s HospitalCode=$g(HospitalCode)
	i '$l(HospitalCode) q 0
	
	s HospitalID=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
	
	///获取命名空间
 	s WebNamespace=##Class(OTH.SYSParameter).GetWebNamespace()
	
	s ARCIMSubscript=0 f  s ARCIMSubscript=$o(^[WebNamespace]ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
	.s ARCIMVersion=0 f  s ARCIMVersion=$o(^[WebNamespace]ARCIM(ARCIMSubscript,ARCIMVersion)) q:ARCIMVersion=""  d
	..s ARCRowid=$p($g(^[WebNamespace]ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
	..s OrderType=""
	..i ARCRowid'="" s OrderType=$P(^[WebNamespace]ARC("IC",ARCRowid),"^",7)
	..Q:OrderType'="L"
	..s OrderItemCode=$p($g(^[WebNamespace]ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) //HIS代码
	..s EXTRowId=$o(^[WebNamespace]ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",0))
	..s EXTCode=""
	..i $l(EXTRowId) d
	...s EXTCode=$p($g(^[WebNamespace]ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",EXTRowId)),"^",4)		;外部代码
	..s TestSetID=""
	..i $L(EXTCode) s TestSetID=$O(^dbo.BTTestSetI("IndexCode",HospitalID,##Class(LIS.Util.Common).IndexData(EXTCode),""))
	..i $l(TestSetID) d
	...s WorkGroupDR=$lg($g(^dbo.BTTestSetD(TestSetID)),22)
	...i '$l(WorkGroupDR) d
	....s WorkGroupDR=$o(^dbo.BTTestSetLayoutI("IndexMaster",TestSetID,"")) 
	...s ret=##Class(ES.LIS.DHCMachineResultSynchro).ESHISOrderSave(OrderItemCode,EXTCode,WorkGroupDR)
	...;s ret=##class(LIS.WS.DHCLISServiceBase).ESHISOrderSave("http://114.251.235.30:57772/imedicallis/csp/LIS.WS.DHCLISService.cls?wsdl=1&amp;CacheUserName=_system&amp;CachePassword=SYS","ES.LIS.DHCMachineResultSynchro","ESHISOrderSave",OrderItemCode,EXTCode, WorkGroupDR, "", "", "", "", "", "", "", "", "", "", "", Sessions,"")
	
	
 	q 0
}

/// Creator：      xuzhiguo
/// CreatDate：    20210824
/// Description：  医嘱项目外部代码存储
/// Input：        
/// Output： 
/// w ##Class(ES.LIS.DHCMachineResultSynchro).ESHISOrderSave("DHSZHYYZY")
ClassMethod ESHISOrderSave(OrderItemCode, TestSetCode, WorkGroupDR)
{
	s OrderItemCode=$g(OrderItemCode)
	s TestSetCode=$g(TestSetCode)
	s WorkGroupDR=$g(WorkGroupDR)

	s HISOrderDR=$o(^dbo.BTHISOrderI("IndexMaster",OrderItemCode,TestSetCode,""))
	
	i $l(HISOrderDR) s objHISOrder=##class(dbo.BTHISOrder).%OpenId(HISOrderDR)
	e  s objHISOrder=##class(dbo.BTHISOrder).%New()
	
	s objHISOrder.OrderItemCode=OrderItemCode
	s objHISOrder.TestSetCode=TestSetCode
	s objHISOrder.WorkGroupDR=WorkGroupDR
	s sc=objHISOrder.%Save()
	
	q sc
}

}
