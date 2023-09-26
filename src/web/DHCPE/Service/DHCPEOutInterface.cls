Class web.DHCPE.Service.DHCPEOutInterface Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 功能：采血（提供平台获取检验医嘱采血信息）
/// 入参：医嘱id
/// 出参：采血日期^采血时间^采集人
/// w ##class(web.DHCPE.Service.DHCPEOutInterface).GetBlood()
ClassMethod GetBlood(OrdItemId)
{
	 q:OrdItemId="" ""
	 s SpecNo=$p($G(^OEORD($p(OrdItemId,"||",1),"I",$p(OrdItemId,"||",2),3)),"^",20)
 	 q:SpecNo="" ""
 	 q:'$D(^DHCPETempLabEpisodeScan(SpecNo)) ""
	 s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	 s TReceiver=$P(Info,"^",3)	
     s:TReceiver'="" TReceiver=$P(^SSU("SSUSR",TReceiver),"^",2)
     s Time=$P(Info,"^",2)
     i Time'="" s Time=$zt(Time)
	 s Date=$P(Info,"^",1)
	 i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	 q Date_"^"_$zt(Time)_"^"_TReceiver
}

/// Creator：	 xy 
/// CreatDate：	 20230512
/// Description: 采集标本时调用平台方法更新闭环状态
/// Input:       OrdItemId：医嘱id，LocID：操作科室ID
/// Return：     0/非0
/// dubug：w ##class(web.DHCPE.Service.DHCPEOutInterface).UpdatePTBloodInfo("223||5",105)
ClassMethod UpdatePTBloodInfo(OrdItemId, LocID)
{
	 //s ^tempdhcpe("UpdatePTBloodInfo")=$lb(OrdItemId, LocID)
	 q:OrdItemId="" ""
	 s TReceiver="",TReceiverID="",Date="",Time=""
	 s LocCode=$p($g(^CTLOC(LocID)),"^",1)
	 s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	 
	 s SpecNo=$p($G(^OEORD($p(OrdItemId,"||",1),"I",$p(OrdItemId,"||",2),3)),"^",20)
 	 q:SpecNo="" ""
 	 
 	 q:'$D(^DHCPETempLabEpisodeScan(SpecNo)) ""
	 s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	 s TReceiverID=$P(Info,"^",3)	
     s:TReceiverID'="" TReceiver=$P(^SSU("SSUSR",TReceiverID),"^",2)
     s Time=$P(Info,"^",2)
     i Time'="" s Time=$zt(Time,1)
	 s Date=$P(Info,"^",1)  
	 i Date'="" s Date=$zd(Date,3)
	 
	 s inputObj=##class(web.DHCPE.Service.SystemStatus).%New()
	 s jsonStream=##class(%GlobalCharacterStream).%New()  //字符流
	 s inputObj.OEOrdItemID = OrdItemId
	 s inputObj.Position = ""
	 s inputObj.ExamID = ""
	 s inputObj.Status = "DB"  //采集标本状态
	 s inputObj.UserID = TReceiverID
	 s inputObj.UserName = TReceiver
	 s inputObj.UpDateTime = Date_" "_Time 
	 s inputObj.SourceSystem = "HIS"
	 s inputObj.Notes = ""
	 s inputObj.OperateDeptCode = LocCode
	 s inputObj.OperateDept = LocDesc
	
	 s jsonData=##class(ext.util.JsonObject).ObjToJson(inputObj,"","")  //转换为Json
	 s jsonData="["_jsonData_"]"
	 ;w !,jsonData
	 d jsonStream.Write(jsonData) //将Json转换为字符流
	 s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)  //平台更新闭环状态接口
	 s rtnUpdateStr=""
	 i ($IsObject(rtnUpdateSystem)) d
	 .s rtnUpdateStr=rtnUpdateSystem.Read()
	 e  s rtnUpdateStr=rtnUpdateSystem
	 s ^DHCPEDataEx("UpdateSystemStatus","BloodInfo",LocID,OrdItemId)=$zdt($h,3)_"==>"_jsonData_"==>"_rtnUpdateStr  //记录更新平台状态日志记录
	 i (+rtnUpdateStr<0) s rtn=rtn_"-1^更新平台收费状态失败"_rtnUpdateStr 
	 e  s rtn="0"
	 q rtn
}

/// 功能：收费（提供平台获取体检医嘱收费信息）
/// 入参：医嘱id
/// 出参：收费日期^收费时间^收费人
/// w ##class(web.DHCPE.Service.DHCPEOutInterface).GetPayInfo()
ClassMethod GetPayInfo(OrdItemId)
{
	 q:OrdItemId="" ""
	 s Date="",Time="",User=""
	 s flag=0
	 s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OrdItemId,0))
	 q:CRMORowId="" ""
	 s PreIOrdItem=$p($g(^DHCPECRMO(CRMORowId)),"^",2)
	 s OrdEnt=$p($g(^DHCPEPreIADM($p(PreIOrdItem,"||",1),"ORDITEM",$p(PreIOrdItem,"||",2))),"^",2)
	 
	 S FSub=0
	 f  S FSub=$O(^DHCPEPreIADM($p(PreIOrdItem,"||",1),"ORDITEM",$p(PreIOrdItem,"||",2),"FEE",FSub))  q:(FSub="")||(flag=1)  d
	 .s PAuditDR=$p($g(^DHCPEPreIADM($p(PreIOrdItem,"||",1),"ORDITEM",$p(PreIOrdItem,"||",2),"FEE",FSub)),"^",5)
	 .s UseFlag=$p($g(^DHCPEPreA(PAuditDR)),"^",21)
	 .q:UseFlag="NU"
	 .s PAPBRowId=$o(^DHCPEPAPBR(0,"PADR",PAuditDR,0))
	 .q:PAPBRowId=""
	 .s PBDR=$p($g(^DHCPEPAPBR(PAPBRowId)),"^",2)
	 .q:PBDR=""
	 .s InvId=$o(^DHCPEINVPRT(0,"PB",PBDR,0))
	 .i InvId'="" s flag=1
	 .s User=$p($g(^DHCPEINVPRT(InvId)),"^",10)
	 .s:User'="" User=$P(^SSU("SSUSR",User),"^",2)
	 .s Date=$p($g(^DHCPEINVPRT(InvId)),"^",11)
	 .i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	 .s Time=$p($g(^DHCPEINVPRT(InvId)),"^",12)
	 .i Time'="" s Time=$zt(Time)
	 i OrdEnt'="" d
	 .S EFSub=0
	 .f  S EFSub=$O(^DHCPEPreIADM($p(OrdEnt,"||",1),"ORDENT",$p(OrdEnt,"||",2),"FEE",EFSub))  q:(EFSub="")||(flag=1)  d
	 ..s PAuditDR=$p($g(^DHCPEPreIADM($p(OrdEnt,"||",1),"ORDENT",$p(OrdEnt,"||",2),"FEE",EFSub)),"^",5)
	 ..s UseFlag=$p($g(^DHCPEPreA(PAuditDR)),"^",21)
	 ..q:UseFlag="NU"
	 ..s PAPBRowId=$o(^DHCPEPAPBR(0,"PADR",PAuditDR,0))
	 ..q:PAPBRowId=""
	 ..s PBDR=$p($g(^DHCPEPAPBR(PAPBRowId)),"^",2)
	 ..q:PBDR=""
	 ..s InvId=$o(^DHCPEINVPRT(0,"PB",PBDR,0))
	 ..i InvId'="" s flag=1
	 ..s User=$p($g(^DHCPEINVPRT(InvId)),"^",10)
	 ..s:User'="" User=$P(^SSU("SSUSR",User),"^",2)
	 ..s Date=$p($g(^DHCPEINVPRT(InvId)),"^",11)
	 ..i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	 ..s Time=$p($g(^DHCPEINVPRT(InvId)),"^",12)
	 ..i Time'="" s Time=$zt(Time)
	 q Date_"^"_Time_"^"_User
}

/// Creator：	 xy 
/// CreatDate：	 20230510
/// Description: 收费时调用平台方法更新闭环状态
/// Input:       InvID：发票ID，LocID：操作科室ID
/// Return：     0/非0
/// dubug：w ##class(web.DHCPE.Service.DHCPEOutInterface).UpdatePTPayInfo(19,105)
ClassMethod UpdatePTPayInfo(InvID, LocID)
{
	 //s ^tempdhcpe("UpdatePTPayInfo")=$lb(InvID, LocID)
	 q:InvID="" ""
	 s Date="",Time="",UserID="",UserName="",ret=""
	
	 s PBID=$P($g(^DHCPEINVPRT(InvID)),"^",3)
	 q:PBID="" ""
	 s LocCode=$p($g(^CTLOC(LocID)),"^",1)
	 s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	 s UserID=$p($g(^DHCPEINVPRT(InvID)),"^",10) //结算人
	
	 s:UserID'="" UserName=$P(^SSU("SSUSR",UserID),"^",2) 
	 s Date=$p($g(^DHCPEINVPRT(InvID)),"^",11) //结算日期
	 i Date'="" s Date=$zd(Date,3)
	 s Time=$p($g(^DHCPEINVPRT(InvID)),"^",12) //结算时间
	 i Time'="" s Time=$zt(Time,1)
	
	 
	 s PAPBID=0
	 f  s PAPBID=$O(^DHCPEPAPBR(0,"PBDR",PBID,PAPBID)) q:PAPBID=""  d
	 .s PAID=$P($g(^DHCPEPAPBR(PAPBID)),"^",1)
	 .s UseFlag=$p($g(^DHCPEPreA(PAID)),"^",21)
	 .q:UseFlag="NU"
	 .s preAdmId=0	
	 .f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",PAID,preAdmId)) q:(preAdmId="")  d
	 ..;s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
	 ..;q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	 ..s childsub=0
	 ..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",PAID,preAdmId,childsub)) q:(childsub="")  d
	 ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	 ...s PIOI=preAdmId_"||"_childsub
	 ...s CRMRowID=$o(^DHCPECRMO(0,"CRMORI",PIOI,0))
	 ...q:CRMRowID=""
	 ...S OEORID=$P($g(^DHCPECRMO(CRMRowID)),"^",1)
	 ...
	 ...s inputObj=##class(web.DHCPE.Service.SystemStatus).%New()
	 ...s jsonStream=##class(%GlobalCharacterStream).%New()  //字符流
	 ...s inputObj.OEOrdItemID = OEORID
	 ...s inputObj.Position = ""
	 ...s inputObj.ExamID = ""
	 ...s inputObj.Status = "CHARGE"  //收费状态
	 ...s inputObj.UserID = UserID
	 ...s inputObj.UserName = UserName
	 ...s inputObj.UpDateTime = Date_" "_Time 
	 ...s inputObj.SourceSystem = "HIS"
	 ...s inputObj.Notes = ""
	 ...s inputObj.OperateDeptCode = LocCode
	 ...s inputObj.OperateDept = LocDesc
	 ...
	 ...s jsonData=##class(ext.util.JsonObject).ObjToJson(inputObj,"","")  //转换为Json
	 ...s jsonData="["_jsonData_"]"
	 ...;w !,jsonData
	 ...d jsonStream.Write(jsonData) //将Json转换为字符流
	 ...s rtnUpdateSystem=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)  //平台更新闭环状态接口
	 ...s rtnUpdateStr=""
	 ...i ($IsObject(rtnUpdateSystem)) d
	 ....s rtnUpdateStr=rtnUpdateSystem.Read()
	 ...e  s rtnUpdateStr=rtnUpdateSystem
	 ...s ^DHCPEDataEx("UpdateSystemStatus","PayInfo",InvID, LocID,OEORID)=$zdt($h,3)_"==>"_jsonData_"==>"_rtnUpdateStr  //记录更新平台状态日志记录
	 ...i (+rtnUpdateStr<0) s rtn=rtn_"-1^更新平台收费状态失败"_rtnUpdateStr 
	 ...e  s rtn="0"
				
	q rtn
}

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
