Import SQLUser

/// 接诊日志 by Liuxuefeng 2008-09-01
Class web.DHCWMRReceiptLogCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 25;

/*****************************************
/功能：保存接诊或取消接诊日志
/参数：
/LogStr   OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
/返回值：ret   <0:日志保存失败   >0:日志保存成功
/*****************************************/
ClassMethod UpdateReceiptLog(Instring)
{
	n (Instring)
	/*Modify by liuxuefeng 2009-05-27
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$UpdateReceiptLog^DHCWMRReceiptLog(InPut)
	zn CurrentNS
	q ret
	*/
    s RecLogRowid=$p(Instring,"^",1)        ;DHC_WMR_ReceiptLogRowID
    s PLIST(2)=$p(Instring,"^",2)          	;OpeType: 		操作类型（0-取消接诊，1-接诊）      
    q:PLIST(2)="" -100   
    s PLIST(3)=$p(Instring,"^",3)          	;MrType_Dr: 	病案类型         
    s PLIST(4)=$p(Instring,"^",4)          	;MrNo: 			病案号码     
    s PLIST(5)=$p(Instring,"^",5)          	;Volume_Dr: 	卷Rowid 
    s PLIST(6)=$p(Instring,"^",6)          	;Papmi_Dr: 		病人基本信息
    s PLIST(7)=$p(Instring,"^",7)          	;Paadm_Dr:		病人就诊信息
    s PLIST(8)=$p(Instring,"^",8)			;RecLoc_Dr:		接诊/取消科室
    s PLIST(9)=$p(Instring,"^",9)			;RecUser_Dr:	接诊/取消操作员
	s PLIST(10)=$p(Instring,"^",10)			;RecDate:		操作日期
	s:$p(Instring,"^",10)["-" PLIST(10)=$zdh($p(Instring,"^",10),3)
	s:$p(Instring,"^",10)["/" PLIST(10)=$zdh($p(Instring,"^",10),4)
	s:$p(Instring,"^",10)="" PLIST(10)=+$h
	s PLIST(11)=$p(Instring,"^",11)			;RecTime:		操作时间
    s:$p(Instring,"^",11)[":" PLIST(11)=$zth($p(Instring,"^",11),2)
    s:$p(Instring,"^",11)="" PLIST(11)=$p($h,",",2)
    s PLIST(12)=$s($p(Instring,"^",12)["Y":"Y",1:"N")		;IsActive:		是否有效
	s PLIST(13)=$p(Instring,"^",13)			;ResumeText:	备注
 
    i RecLogRowid="" d
    .&sql(Insert into DHC_WMR_ReceiptLog values :PLIST())
    e  d
    .&sql(Update DHC_WMR_ReceiptLog values :PLIST() where Rowid=:RecLogRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

/*********************************
/功能：取接诊日志信息
/w ##class(web.DHCWMRReceiptLogCtl).GetReceiptLogById(Rowid)
/*********************************/
ClassMethod GetReceiptLogById(RecLogRowid)
{
	n (RecLogRowid)
	s ret=""
    q:RecLogRowid="" ret
    q:'$d(^DHCWMRRecLog(RecLogRowid)) ret
    s ret=$g(^DHCWMRRecLog(RecLogRowid))
    s ret=RecLogRowid_"^"_ret
    s:$p(ret,"^",10)'="" $p(ret,"^",10)=$zd($p(ret,"^",10),3)
    s:$p(ret,"^",11)'="" $p(ret,"^",11)=$zt($p(ret,"^",11),1)
    q ret
}

/*****************************************
/功能：保存接诊或取消接诊日志
/参数：
/LogStr   OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
/返回值：ret   <0:日志保存失败   >0:日志保存成功
/*****************************************/
ClassMethod SaveReceiptLog(LogStr)
{
	n (LogStr)
	s OprType=$p(LogStr,"^",1)     //操作类型
	s MrType=$p(LogStr,"^",2)      //病案类型
	s MrNo=$p(LogStr,"^",3)        //病案号
	s VolId=$p(LogStr,"^",4)       //卷ID
	s Papmi=$p(LogStr,"^",5)       //病人基本信息ID
	s Paadm=$p(LogStr,"^",6)       //就诊ID
	s RecLoc=$p(LogStr,"^",7)      //接诊科室
	s RecUser=$p(LogStr,"^",8)     //接诊操作员
	s ResumeText=$p(LogStr,"^",9)  //备注
	
	s (xMrType,xMrNo,xPaadm,xPapmi)=""
	i VolId'="" d
	.s sVol=$g(^DHCWMRVOL(VolId))
	.q:sVol=""
	.s xPaadm=$p(sVol,"^",2)
	.s sMainId=$p(sVol,"^",1)
	.s sMain=$g(^DHCWMRMAIN(+sMainId))
	.s xMrType=$p(sMain,"^",1)
	.s xMrNo=$p(sMain,"^",2)
	.s xPapmi=$p(sMain,"^",3)
	s:MrType="" MrType=xMrType
	s:MrNo="" MrNo=xMrNo
	s:Papmi="" Papmi=xPapmi
	s:Paadm="" Paadm=xPaadm
	
	s RecDate=+$h                   //操作日期
	s RecTime=$p($h,",",2)          //操作时间
	s IsActive="Y"                  //是否有效标记
	
	s xInPut=""_"^"_OprType_"^"_MrType_"^"_MrNo_"^"_VolId_"^"_Papmi_"^"_Paadm_"^"_RecLoc_"^"_RecUser_"^"_RecDate_"^"_RecTime_"^"_IsActive_"^"_ResumeText
	s ret=..UpdateReceiptLog(xInPut)
	
	q ret
}

/// Creator：    刘学峰
/// CreatDate：  2009-08-25
/// Description：复兴需求6275：新增接诊日志查询界面  
/// Table：      DHC_WMR_ReceiptLog
/// Input：      OpeFromDate：	操作开始日期
/// 				 OpeToDate：	操作结束日期
/// 				 MrType：		病案类型ID
/// 				 OpeUserIn：	操作员ID
/// 				 OpeTypeIn：	操作类型（1-接诊,2-取消接诊）
/// 				 MrNoIn：		病案号
/// Debug:       d ##Class(%ResultSet).RunQuery("web.DHCWMRReceiptLogCtl","QueryReceiptLog",OpeFromDate,OpeToDate,MrType,OpeUserIn,OpeTypeIn,MrNoIn)
Query QueryReceiptLog(OpeFromDate As %String, OpeToDate As %String, MrType As %String, OpeUserIn As %String, OpeTypeIn As %String, MrNoIn As %String) As %Query(ROWSPEC = "Rowid:%String,OpeType:%String:操作类型,MrTypeDr:%String:病案类型,MrNo:%String:病案号,VolumeDr:%String,PapmiDr:%String,PaadmDr:%String,RecLocDr:%String:操作科室,RecUserDr:%String:操作员,RecDate:%String:操作日期,RecTime:%String:操作时间,IsActive:%String:是否有效,ResumeText:%String:备注,MrTypeDesc:%String:病案类型描述,RecLocDesc:%String:操作科室名称,RecUserDesc:%String:操作员姓名")
{
}

ClassMethod QueryReceiptLogExecute(ByRef qHandle As %Binary, OpeFromDate As %String, OpeToDate As %String, MrType As %String, OpeUserIn As %String, OpeTypeIn As %String, MrNoIn As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;s ^CacheTemp("liuxuefeng")=MrType_"^"_OpeFromDate_"^"_OpeToDate_"^"_OpeUserIn_"^"_OpeTypeIn_"^"_MrNoIn
	
	q:MrType="" $$$OK
	q:OpeFromDate="" $$$OK
	q:OpeToDate="" $$$OK

	s:OpeFromDate["-" OpeFromDate=$zdh(OpeFromDate,3)
	s:OpeToDate["-" OpeToDate=$zdh(OpeToDate,3)
	s:OpeFromDate["/" OpeFromDate=$zdh(OpeFromDate,4)
	s:OpeToDate["/" OpeToDate=$zdh(OpeToDate,4)
	
	s:MrNoIn'="" MrNoIn=$tr(MrNoIn," ","")
	
	f tmpDate=OpeFromDate:1:OpeToDate	 d
	.s LogRowId=0
	.f  s LogRowId=$o(^DHCWMRRecLog(0,"RecDate",tmpDate,LogRowId)) q:LogRowId=""  d
	..s strRecLog=LogRowId_"^"_$g(^DHCWMRRecLog(+LogRowId))
	..s OpeType = $p(strRecLog,"^",2) 				// 操作类型（1-接诊,2-取消接诊）
	..q:(OpeTypeIn'="")&&(OpeTypeIn'=OpeType)		//*根据操作类型过滤
	..s:OpeType=1 OpeType="接诊"
	..s:OpeType=2 OpeType="取消接诊"
	..s MrTypeDr = $p(strRecLog,"^", 3)  			// 病案类型ID
	..q:(MrType'="")&&(MrType'=MrTypeDr)			//*根据病案类型过滤
	..s MrTypeDesc=$p(##Class(web.DHCWMRDictionaryCtl).GetDataById(MrTypeDr),"^",4) //病案类型描述
	..s MrNo = $p(strRecLog,"^", 4)  				// 病案号码
	..q:(MrNoIn'="")&&(MrNoIn'=MrNo)				//*根据传入病案号过滤
	..s VolumeDr = $p(strRecLog,"^", 5)  			// 卷Rowid
	..s PapmiDr = $p(strRecLog,"^", 6)  			// 病人基本信息
	..s PaadmDr = $p(strRecLog,"^", 7)  			// 病人就诊信息
	..s RecLocDr = $p(strRecLog,"^", 8) 			// 接诊/取消科室
	..s RecLocDesc= $p($g(^CTLOC(RecLocDr)),"^",2)	// 操作科室名称
	..s RecUserDr = $p(strRecLog,"^", 9)  			// 接诊/取消操作员ID
	..q:(OpeUserIn'="")&&(OpeUserIn'=RecUserDr)		//*根据操作员过滤
	..s RecUserDesc = $p($g(^SSU("SSUSR",RecUserDr)),"^",2) //操作员名称
	..s RecDate = $p(strRecLog,"^", 10)  			// 操作日期
	..s:RecDate'="" RecDate=$zd(RecDate,3)
	..s RecTime = $p(strRecLog,"^", 11)  			// 操作时间
	..s:RecTime'="" RecTime=$zt(RecTime)
	..s IsActive = $p(strRecLog,"^", 12)  			// 是否有效
	..s ResumeText = $p(strRecLog,"^", 13)  		// 备注
	..s Data=$lb(LogRowId,OpeType,MrTypeDr,MrNo,VolumeDr,PapmiDr,PaadmDr,RecLocDr,RecUserDr,RecDate,RecTime,IsActive,ResumeText,MrTypeDesc,RecLocDesc,RecUserDesc)
 	..Set ^CacheTemp(repid,ind)=Data
 	..Set ind=ind+1
 	
	s Cnt=ind-1
	w !,"数量:"_Cnt	
	
	Quit $$$OK
}

ClassMethod QueryReceiptLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReceiptLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryReceiptLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReceiptLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
