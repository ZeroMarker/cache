/// 名称:DtPortal.Doctor.EMRInfoService
/// 描述:病历信息服务
/// 编写者：Guozongtao
/// 编写日期: 2014-07-17
Class DtPortal.Doctor.EMRInfoService Extends %RegisteredObject
{

/// Creator：      guozongtao
/// CreatDate：    2014-07-17
/// Description:   D02.10.01 查询当前医生待待签病历数量
///                当前医师为住院医：返回主管患者需要"住院医师签名"的病历数量
///                当前医师为主治医：返回本人和所有下级医师管理的患者需要"主治医师签名"的病历数量
///                当前医师为主任医：...
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData EMRmeta.PowerUser EMRmeta.ChildUsers EMRinstance.EMRLogs
/// Input：        argUserID :当前医生
/// Return：       DtPortal.OutPut.GetAt("EMRCountersign")
/// Others：       
/// Debug:         Do ##Class(DtPortal.Doctor.EMRInfoService).EMRCountersign("245")		
ClassMethod EMRCountersign(argUserCode As %String) As DtPortal.OutPut
{
	Set ResultValue = ##class(DtPortal.OutPut).%New()
	Set array=##Class(%ArrayOfDataTypes).%New()
	Do array.SetAt(0,"EMRCountersign")
	
	//UPDATE BY SHP
	Set argUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(argUserCode,"U"),0))
	
	Set level=##Class(EMRservice.BL.BLPowerUser).GetUserLevel(argUserID)
	If (level="") Set level="Resident"
	If (level="Resident")
	{
		Set paadmlist=..GetChargeAdmList(argUserID)
		Set count=..GetEMRCountersign(argUserID,paadmlist,level)
		Do array.SetAt(count,"EMRCountersign")
		Set ResultValue.data=array
	}
	ElseIf(level="Attending")
	{
		Set paadmlist=##Class(%ListOfDataTypes).%New()
		
		Set Juniordoctors=##Class(%ListOfDataTypes).%New()
		Set JuniordoctorsAdmlist=##Class(%ListOfDataTypes).%New()
		
		///查下级医师		
		Set Juniordoctors=..GetJuniordoctors(argUserID)
		///查每个下级医师主管的患者
		For i=1:1:Juniordoctors.Count()
		{
			Set paadmlist=..GetChargeAdmList(Juniordoctors.GetAt(i))
			For j=1:1:paadmlist.Count()
			{
				Do JuniordoctorsAdmlist.Insert(paadmlist.GetAt(j))
			}
			Set paadmlist=""
		}
		///查每个患者的病历状态
		Set count=..GetEMRCountersign(argUserID,JuniordoctorsAdmlist,level)
		Do array.SetAt(count,"EMRCountersign")
		Set ResultValue.data=array
	}
	ElseIf(level="Chief")
	{
		//...
		set count=0
		Do array.SetAt(count,"EMRCountersign")
		Set ResultValue.data=array
	}
	
	;w "Count: ",ResultValue.data.GetAt("EMRCountersign")
	Quit ResultValue
}

/// Creator：      guozongtao
/// CreatDate：    2014-07-17
/// Description:   查询当前医生主管患者列表(查用户的所有登陆位置，循环每个登陆位置，获取当前登陆位置的主管患者)
/// Table：        
/// Input：        argUserID :当前医生
/// Return：       DtPortal.OutPut.GetAt("EMRCountersign")
/// Others：       
/// Debug:         Set ret=##Class(DtPortal.Doctor.EMRInfoService).GetChargeAdmList("105")		
ClassMethod GetChargeAdmList(argUserID As %String) As %ListOfDataTypes
{
	Quit:(argUserID="") 0
	
	Set ret=##Class(%ListOfDataTypes).%New()
		
	Set CTPCPDR=+$p($g(^SSU("SSUSR",argUserID)),"^",14)
	Set Date="",count=0
	
	Set UserCode=$p($g(^SSU("SSUSR",argUserID)),"^",1)	
	Set LocStr=##class(DtPortal.Doctor.DHCDocComService).GetLocByUserCode(UserCode)
	Quit:LocStr="" ret
	
	For i=1:1:$length(LocStr,"^")
	{
		Set LocID=$p(LocStr,"^",i)
		
		For
		{
			Set Date=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date)) 
			Quit:(Date="")
			Set Time=""
			For
			{
				Set Time=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time)) 
				Quit:(Time="")
			
				Set paadm=""
				For
				{
					Set paadm=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time,paadm)) 
					Quit:(paadm="")
					Set mCurrRow=$g(^PAADM(paadm))
					Set AdmDocCodeDR=$p(mCurrRow,"^",9)
					If (AdmDocCodeDR=CTPCPDR)
					{
						Do ret.Insert(paadm)
					}	
				}		
			}   
		}
	}
	
	Quit ret
}

/// Creator：      guozongtao
/// CreatDate：    2014-07-17
/// Description:   查询当前医生需要签名的病历数量
/// Table：        
/// Input：        argUserID:当前医生 argAdmList :当前医生主管患者集合 argLevel ：医师级别
/// Return：       DtPortal.OutPut.GetAt("EMRCountersign")
/// Others：       
/// Debug:         w ##Class(DtPortal.Doctor.EMRInfoService).GetEMRCountersign("105",.ret,"Attending")		
ClassMethod GetEMRCountersign(argUserID As %String, argAdmList As %ListOfDataTypes, argLevel As %String) As %String
{
	Quit:(argAdmList.Count()=0) 0
	
	Set count=0
	
	For i=1:1:argAdmList.Count()
	{
		Set EMRDocID=""
		Set curadm=argAdmList.GetAt(i)
		For
		{
			Set EMRDocID=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID))	
			Quit:EMRDocID=""
			
			Set EMRNum=""
			For
			{
				Set EMRNum=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID,EMRNum))
				Quit:EMRNum=""
				
				Set rowid=""
				For
				{
					Set rowid=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID,EMRNum,rowid))
					Quit:rowid=""
					
					Set objEMRLog=##Class(EMRinstance.EMRLogs).%OpenId(rowid)
					Set Status=objEMRLog.EMRStatus
					If ((argLevel="Resident")&&(Status="finished"))
					{
						Set count=count+1
					}
					ElseIf((argLevel="Attending")&&(Status="commited")) //住院医师审核过的病历
					{
						Set count=count+1
					}
					ElseIf((argLevel="Attending")&&((Status="finished")&&(argUserID=objEMRLog.CreateUserID))) //主治医师本人保存的病历
					{
						Set count=count+1
					}					
					ElseIf((argLevel="Chief")&&(Status="attendingChecked"))
					{
						Set count=count+1
					}
					ElseIf((argLevel="Chief")&&((Status="finished")&&(argUserID=objEMRLog.CreateUserID))) //主任医师本人保存的病历
					{
						Set count=count+1
					}					
				}	
			}
		}
	}
	
	Quit count
}

/// Creator：      guozongtao
/// CreatDate：    2014-07-17
/// Description:   查询当前医生的下级医师
/// Table：        EMRmeta.PowerUser EMRmeta.ChildUsers
/// Input：        argUserID :当前医生 
/// Return：       %ListOfDataTypes
/// Others：       
/// Debug:         w ##Class(DtPortal.Doctor.EMRInfoService).GetJuniordoctors("105")		
ClassMethod GetJuniordoctors(argUserID As %String) As %ListOfDataTypes
{
	Quit:argUserID="" ""
	Set ret=##Class(%ListOfDataTypes).%New()
	Set powerUserid=""
	Set powerUserid=$o(^DHCEMRM.PowerUserI("UserIDIndex"," "_argUserID,powerUserid))
	Set objPowerUser=##Class(EMRmeta.PowerUser).%OpenId(powerUserid)
	Set key = ""
	
	//update By chengpeng 2104/8/12  将医生本人加入List
	Do ret.Insert(argUserID)	
	
	Do
	{
		Set ChildUser = objPowerUser.ChildUser.GetNext(.key)
		If (ChildUser '= "") 
		{
			Do ret.Insert(ChildUser.UserID)		    
		}
	}
	While (key '= "")
	
	Quit ret
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   查询当前医生的登陆位置的列表
/// Table：        
/// Input：        argUserID :当前医生 
/// Return：       %ListOfDataTypes
/// Others：       
/// Debug:         Do ##Class(DtPortal.Doctor.EMRInfoService).GetSSUserOtherLogonLoc("105")		
ClassMethod GetSSUserOtherLogonLoc(argUserID As %String) As %ListOfDataTypes
{
	/*
	Quit:argUserID="" 
	Set ret=##Class(%ListOfDataTypes).%New()
	
	Set objSSUser=##Class(User.SSUser).%OpenId(argUserID)
	Set key = "",objCtloc=""
	
	Set objCtloc=objSSUser.SSUSRDefaultDeptDR
	Do ret.Insert(objCtloc.%Id())
	
	Do
	{
		Set OtherLogonLoc = objSSUser.ChildSSUserOtherLogonLoc.GetNext(.key)
		If (OtherLogonLoc '= "") 
		{
			Set objCtloc=OtherLogonLoc.OTHLLCTLOCDR				
			Do ret.Insert(objCtloc.%Id())
		}
	}
	While (key '= "")
	
	Quit ret
	*/
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   D02.10.02 查询当前医生待签病历列表
///                当前医师为住院医：返回主管患者需要"住院医师签名"的病历列表
///                当前医师为主治医：返回本人和所有下级医师管理的患者需要"主治医师签名"的病历列表
///                当前医师为主任医：...
/// Table：        EMRmeta.PowerUser EMRmeta.ChildUsers EMRinstance.EMRLogs
/// Input：        argUserID :当前医生
/// Return：       
/// Others：      
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRsignInfo","776")		
Query GetEMRsignInfo(argUserCode As %String) As DtPortal.Query(ROWSPEC = "BedNum:%String,EpisodeID:%String,PapmiNO:%String,PapmiName:%String,DoucumnetDesc:%String,InstanceID:%String,SignUserName:%String,EMRStatus:%String,DocID:%String,MedicareNo:%String,AdmReason:%String,Sex:%String,Age:%String")
{
}

ClassMethod GetEMRsignInfoExecute(ByRef qHandle As %Binary, argUserCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	//Quit:(argUserID="") $$$OK
	
	//update by shp
	Quit:(argUserCode="") $$$OK
	Set argUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(argUserCode,"U"),0))
	
	Set EMRList=##Class(DtPortal.Doctor.EntityEMRList).%New()

	Set level=##Class(EMRservice.BL.BLPowerUser).GetUserLevel(argUserID)
	
	If (level="") Set level="Resident"
	
	If (level="Resident")
	{
		Set paadmlist=..GetChargeAdmList(argUserID)
		Set EMRList=..GetEMRsignInfo(argUserID,paadmlist,level)
	}
	ElseIf(level="Attending")
	{
		Set paadmlist=##Class(%ListOfDataTypes).%New()
		
		Set Juniordoctors=##Class(%ListOfDataTypes).%New()
		Set JuniordoctorsAdmlist=##Class(%ListOfDataTypes).%New()
		
		///查下级医师		
		Set Juniordoctors=..GetJuniordoctors(argUserID)
		///查每个下级医师主管的患者
		For i=1:1:Juniordoctors.Count()
		{
			Set paadmlist=..GetChargeAdmList(Juniordoctors.GetAt(i))
			For j=1:1:paadmlist.Count()
			{
				Do JuniordoctorsAdmlist.Insert(paadmlist.GetAt(j))
			}
			Set paadmlist=""
		}
		///查每个患者的病历状态
		Set EMRList=..GetEMRsignInfo(argUserID,JuniordoctorsAdmlist,level)
	}
	ElseIf(level="Chief")
	{
		//...
	}	
	
	For i=1:1:EMRList.Items.Count()
	{
		Set BedNum=EMRList.Items.GetAt(i).BedNum
		Set EpisodeID=EMRList.Items.GetAt(i).EpisodeID
		Set PapmiNO=EMRList.Items.GetAt(i).PapmiNo
		Set PapmiName=EMRList.Items.GetAt(i).PapmiName
		Set DoucumnetDesc=$ZSTRIP(EMRList.Items.GetAt(i).DocumentDesc,"*C")
		Set InstanceID=EMRList.Items.GetAt(i).InstanceID
		Set SignUserName=EMRList.Items.GetAt(i).SignDocName
		Set EMRStatus=EMRList.Items.GetAt(i).EMRStatus
		Set DocID=EMRList.Items.GetAt(i).EMRDocID
		//Update By Chengpeng
		set PatInfo=##class(DtPortal.Doctor.DHCDocComService).GetPatInfo(EpisodeID)
		Continue:PatInfo=""
		set Sex=$p(PatInfo,"^",3)
		set Age=$p(PatInfo,"^",4)
		set MedicareNo=$p(PatInfo,"^",5)
		set AdmReason=$p(PatInfo,"^",6)
		
		Set ^||CacheTemp(repid, i) = $LB(BedNum,EpisodeID,PapmiNO,PapmiName,DoucumnetDesc,InstanceID,SignUserName,EMRStatus,DocID,MedicareNo,AdmReason,Sex,Age)
	}
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   构造当前医生待签病历列表信息集合类
/// Table：        EMRinstance.EMRLogs
/// Input：        argEMRlog 病历操作日志实例
/// Return：       DtPortal.Doctor.EntityEMRList  待签病历列表服务返回值实体类,集合类，累加待签病历，返回待签病历的集合
/// Others：       在Query：GetEMRsignInfo 中调用
/// Debug:         		
ClassMethod GetEMRsignInfo(argUserID As %String, argAdmList As %ListOfDataTypes, argLevel As %String) As DtPortal.Doctor.EntityEMRList
{
	Quit:(argAdmList.Count()=0) 0
	
	Set ResultValue=##Class(DtPortal.Doctor.EntityEMRList).%New()
	
	Set count=0
	
	For i=1:1:argAdmList.Count()
	{
		Set EMRDocID=""
		Set curadm=argAdmList.GetAt(i)
		For
		{
			Set EMRDocID=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID))	
			Quit:EMRDocID=""
			
			Set EMRNum=""
			For
			{
				Set EMRNum=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID,EMRNum))
				Quit:EMRNum=""
				
				Set rowid=""
				For
				{
					Set rowid=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_curadm,EMRDocID,EMRNum,rowid))
					Quit:rowid=""
					
					Set objEMRLog=##Class(EMRinstance.EMRLogs).%OpenId(rowid)
					Set Status=objEMRLog.EMRStatus
					If ((argLevel="Resident")&&(Status="finished"))
					{
						Do ResultValue.Items.Insert(..BuildEntityEMRListItem(objEMRLog))
					}
					ElseIf((argLevel="Attending")&&(Status="commited")) //住院医师审核过的病历
					{
						Do ResultValue.Items.Insert(..BuildEntityEMRListItem(objEMRLog))
					}
					ElseIf((argLevel="Attending")&&((Status="finished")&&(argUserID=objEMRLog.CreateUserID))) //主治医师本人保存的病历
					{
						Do ResultValue.Items.Insert(..BuildEntityEMRListItem(objEMRLog))
					}					
					ElseIf((argLevel="Chief")&&(Status="attendingChecked"))
					{
						Do ResultValue.Items.Insert(..BuildEntityEMRListItem(objEMRLog))
					}
					ElseIf((argLevel="Chief")&&((Status="finished")&&(argUserID=objEMRLog.CreateUserID))) //主任医师本人保存的病历
					{
						Do ResultValue.Items.Insert(..BuildEntityEMRListItem(objEMRLog))
					}					
				}	
			}
		}
	}
	
	Quit ResultValue
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   构造当前医生待签病历列表信息明细类
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEMRlog 病历操作日志实例
/// Return：       DtPortal.Doctor.EntityEMRListItem  待签病历列表服务返回值实体类,明细类
/// Others：       在类方法：GetEMRsignInfo 中调用
/// Debug:         		
ClassMethod BuildEntityEMRListItem(argEMRlog As EMRinstance.EMRLogs) As DtPortal.Doctor.EntityEMRListItem
{
	Set objItem=##Class(DtPortal.Doctor.EntityEMRListItem).%New()
	
	Set ECRecordID=""
	Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEMRlog.EpisodeID," "_argEMRlog.EMRDocID,ECRecordID))
	Quit:ECRecordID="" ""
			
	Set InstanceID=""
	Set InstanceID=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_argEMRlog.EMRNum,InstanceID))
	Quit:InstanceID="" ""
	
	set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(argEMRlog.EpisodeID)
	set BedNo=""
	
	set:PatInfo'="" BedNo=$p(PatInfo,"^",1)											//床号
	Set objItem.BedNum=BedNo
	Set objItem.EpisodeID=argEMRlog.EpisodeID
	Set papmiDr=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEMRlog.EpisodeID)
	Set objItem.PapmiNo=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
	Set objItem.PapmiName=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)

	Set SingUserID=argEMRlog.CreateUserID
	I SingUserID'="" Set objItem.SignDocName=$p($g(^SSU("SSUSR",SingUserID)),"^",2)
	Set objItem.EMRStatus=##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(argEMRlog.EMRStatus)
	
	Set InstanceID=ECRecordID_"||"_InstanceID
	Set objInstanceData=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
	
	Set objItem.InstanceID=InstanceID
	Set objItem.DocumentDesc=objInstanceData.Title
	Set objItem.EMRDocID=argEMRlog.EMRDocID
	//w "objItem.DocumentDesc"_objItem.DocumentDesc,!
	Quit objItem
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   C00.00.01 根据就诊号查看电子病历
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEpisodeID 患者就诊号
/// Return：       InstanceID:病历实例数据ID ,DocID:病历目录展现结构ID
/// Others：       利用打开保存的第一份病历作为默认浏览病历
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRBrowser","9","601")		
Query GetEMRBrowser(argEpisodeID As %String, UserCode As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String,UserID:%String,locID:%String")
{
}

ClassMethod GetEMRBrowserExecute(ByRef qHandle As %Binary, argEpisodeID As %String, UserCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	q:UserCode=""
	Set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	S ^TEMPSHP("EMRBrowser")=argEpisodeID
	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argEpisodeID="null")||(argEpisodeID="NULL") $$$OK
	Set BreakFlag=""
	
	Set EMRDocID=""
	For
	{
		Set EMRDocID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID))
		Quit:((EMRDocID="")||(BreakFlag="1")) 
		
		Set ECRecordID=""
		For
		{
			Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID,ECRecordID))
			Quit:((ECRecordID="")||(BreakFlag="1"))
		
			Set ListNo=""
			For
			{
				Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo))
				Quit:((ListNo="")||(BreakFlag="1"))
				Set Rowid=""
				For
				{
					Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid))
					Quit:Rowid=""
					
					Set InstanceID=ECRecordID_"||"_Rowid
					Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
					If (objInstance.Status="Save")
					{
						Set BreakFlag="1"
						Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
						Set curPatientID=objEcrecord.PatientID
						Set curEpisodeID=objEcrecord.EpisodeID
						Set curDocID=objEcrecord.ChartItemID
						Set curInstanceID=InstanceID
					}
					Quit:objInstance.Status="Save"
				}
				
			}
		}
	}
	set locID=$p($g(^PAADM(argEpisodeID)),"^",4)
	Set ^CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID,UserID,locID)
	Quit $$$OK
}

ClassMethod GetEMRBrowserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRBrowserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEMRBrowserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRBrowserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   C00.00.02 根据就诊号查看电子病历首页
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEpisodeID 患者就诊号 argDocID 病历目录展现结构ID
/// Return：       InstanceID:病历实例数据ID ,DocID:病历目录展现结构ID  如果有Save状态的首页数据，正常返回4列出参，如果没有首页实例数据4列出参均为""
/// Others：        
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRHDSD0011","356","71")		
Query GetEMRHDSD0011(argEpisodeID As %String, argDocID As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String")
{
}

ClassMethod GetEMRHDSD0011Execute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argDocID="") $$$OK
	Set BreakFlag=""
	
	Set EMRDocID=" "_argDocID	
	Set ECRecordID=""
	For
	{
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID,ECRecordID))
		Quit:((ECRecordID="")||(BreakFlag="1"))
	
		Set ListNo=""
		For
		{
			Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo))
			Quit:((ListNo="")||(BreakFlag="1"))
			Set Rowid=""
			For
			{
				Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid))
				Quit:Rowid=""
				
				Set InstanceID=ECRecordID_"||"_Rowid
				Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
				If (objInstance.Status="Save")
				{
					Set BreakFlag="1"
					Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
					Set curPatientID=objEcrecord.PatientID
					Set curEpisodeID=objEcrecord.EpisodeID
					Set curDocID=objEcrecord.ChartItemID
					Set curInstanceID=InstanceID
				}
				Quit:objInstance.Status="Save"
			}
			
		}
	}
	
	Set ^CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID)
	Quit $$$OK
}

ClassMethod GetEMRHDSD0011Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRHDSD0011Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEMRHDSD0011Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRHDSD0011Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   C00.00.03	根据就诊号查看电子病历 （查找最近一次的 标题为转入/转出记录）
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEpisodeID 患者就诊号 argDocID 病历目录展现结构ID  argTitleID 住院病程记录中转入/转记录出标题ID
/// Return：       InstanceID:病历实例数据ID ,DocID:病历目录展现结构ID
/// Others：       如果有转入记录，返回转入记录信息，若无转入，有转出记录，返回转出记录，二这都没有，4列返回“”
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRHDSD0014","391","88","9^8")		
Query GetEMRHDSD0014(argEpisodeID As %String, argDocID As %String, argTitleID As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String")
{
}

ClassMethod GetEMRHDSD0014Execute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String, argTitleID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argDocID="")||(argTitleID="") $$$OK
	Set BreakFlag=""
	
	Set curTransIn=$p(argTitleID,"^",1)   //住院病程记录中标题为"转入记录"的标题代码 
	Set curTransOut=$p(argTitleID,"^",2)  //住院病程记录中标题为"转出记录"的标题代码
	
	Set EMRDocID=" "_argDocID		
	Set ECRecordID=""
	For
	{
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID,ECRecordID))
		Quit:((ECRecordID="")||(BreakFlag="1"))
	
		Set ListNo=""
		For
		{
			Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo),-1)
			Quit:((ListNo="")||(BreakFlag="1"))
			Set Rowid=""
			For
			{
				Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid),-1)
				Quit:Rowid=""
				
				Set InstanceID=ECRecordID_"||"_Rowid
				Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
				If ((objInstance.Status="Save")&&(objInstance.TitleCode=curTransIn))
				{
					Set BreakFlag="1"
					Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
					Set curPatientID=objEcrecord.PatientID
					Set curEpisodeID=objEcrecord.EpisodeID
					Set curDocID=objEcrecord.ChartItemID
					Set curInstanceID=InstanceID
				}
				Quit:((objInstance.Status="Save")&&(objInstance.TitleCode=curTransIn))
				
				If ((objInstance.Status="Save")&&(objInstance.TitleCode=curTransOut))
				{
					Set BreakFlag="1"
					Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
					Set curPatientID=objEcrecord.PatientID
					Set curEpisodeID=objEcrecord.EpisodeID
					Set curDocID=objEcrecord.ChartItemID
					Set curInstanceID=InstanceID
					
				}
				Quit:((objInstance.Status="Save")&&(objInstance.TitleCode=curTransOut))
		
			}
			
		}
	}
	
	Set ^CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID)
	Quit $$$OK
}

ClassMethod GetEMRHDSD0014Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRHDSD0014Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEMRHDSD0014Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRHDSD0014Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-02
/// Description:   C00.00.05	调用填写病程记录服务
/// Table：        
/// Input：        argEpisodeID 患者就诊号 argDocID 病历目录展现结构ID  argTitleID 创建病程记录标题 argUserID 病历作者
/// Return：       InstanceID:"",在前端拼装URL,病历实例数据ID为空时是新建病历 ,DocID:病历目录展现结构ID argTitleID:日常病程记录标题代码(目前病历编辑器尚不支持传入标题直接创建,此功能在后续支持,参数先加上 argUserID 病历创建者ss_user)
/// Others：       
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","CreateEMRHDSD0014","578","88","","834")	
/// update :      by  shp   
/// 	Description:   入参改为usercode 
Query CreateEMRHDSD0014(argEpisodeID As %String, argDocID As %String, argTitleID As %String, argUserCode As %String) As DtPortal.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String,TitlesID:%String,USERID:%String,locID:%String")
{
}

ClassMethod CreateEMRHDSD0014Execute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String, argTitleID As %String, argUserCode As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argDocID="")||(argUserCode="") $$$OK
	
	//update by chengpeng 
	set locID=$p($g(^PAADM(argEpisodeID)),"^",4)
	//UPDATE BY SHP
	Set curUSERID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(argUserCode,"U"),0))
	
	Set curEpisodeID=argEpisodeID
	Set curPatientID=##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
	Set curDocID=argDocID
	Set curTitlesID=argTitleID
	Set curInstanceID=""	
	
	Set ^||CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID,curTitlesID,curUSERID,locID)
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-30
/// Description:   查询死亡小结接口
/// Table：        
/// Input：        argEpisodeID :患者就诊号
/// Return：       入院情况:DtPortal.OutPut.data.GetAt("HDSD00.14.080")
/// 		       入院日期时间:DtPortal.OutPut.data.GetAt("HDSD00.14.081")
/// 				   入院情况:DtPortal.OutPut.data.GetAt("HDSD00.14.082")
/// 		       死亡日期时间:DtPortal.OutPut.data.GetAt("HDSD00.14.104")
/// 		       死亡诊断:DtPortal.OutPut.data.GetAt("HDSD00.14.107")
/// Others：       
/// Debug:         w ##Class(DtPortal.Doctor.EMRInfoService).GetPortalDeathSummaryInfo("306")		
ClassMethod GetPortalDeathSummaryInfo(argEpisodeID As %String) As DtPortal.OutPut
{
	;Set ResultValue = ##class(DtPortal.OutPut).%New()
	;Set array=##Class(%ArrayOfDataTypes).%New()
	
	;Set ret= ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(argEpisodeID,"HDSD00.14")
	;q:ret="" ""
	;s key = ""
	;s array = ret.GetNext(.key)    
	;Set ResultValue.data=array	
	
	;Quit ResultValue
	 Set ResultValue = ##class(DtPortal.OutPut).%New() 
	 Set array=##Class(%ArrayOfDataTypes).%New() 
	 Set ret= ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(argEpisodeID,"HDSD00.14.14") 
	 
	 q:ret="" "" Set ResultValue.data=ret	
	 
	 Quit ResultValue
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-31
/// Description:   PreoperativeDiscussion	术前讨论(根据手术分级制度规定，二级以上手术均应开展手术术前讨论并书写术前讨论记录)
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEpisodeID 患者就诊号 argDocID 病历目录展现结构ID
/// Return：       InstanceID:病历实例数据ID ,DocID:病历目录展现结构ID  如果有Save状态的数据，正常返回4列出参，如果没有实例数据4列出参均为""
/// Others：        
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","PreoperativeDiscussion","76","633")		
Query PreoperativeDiscussion(argEpisodeID As %String, argDocID As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String")
{
}

ClassMethod PreoperativeDiscussionExecute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argDocID="") $$$OK
	Set BreakFlag=""
	
	Set EMRDocID=" "_argDocID	
	Set ECRecordID=""
	For
	{
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID,ECRecordID))
		Quit:((ECRecordID="")||(BreakFlag="1"))
	
		Set ListNo=""
		For
		{
			Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo))
			Quit:((ListNo="")||(BreakFlag="1"))
			Set Rowid=""
			For
			{
				Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid))
				Quit:Rowid=""
				
				Set InstanceID=ECRecordID_"||"_Rowid
				Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
				If (objInstance.Status="Save")
				{
					Set BreakFlag="1"
					Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
					Set curPatientID=objEcrecord.PatientID
					Set curEpisodeID=objEcrecord.EpisodeID
					Set curDocID=objEcrecord.ChartItemID
					Set curInstanceID=InstanceID
				}
				Quit:objInstance.Status="Save"
			}
			
		}
	}
	
	Set ^CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID)
	Quit $$$OK
}

ClassMethod PreoperativeDiscussionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PreoperativeDiscussionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod PreoperativeDiscussionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PreoperativeDiscussionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-31
/// Description:   FirstRecordAfterOperation 术后首次病程记录
/// Table：        EMRinstance.ECRecord,EMRinstance.InstanceData
/// Input：        argEpisodeID 患者就诊号 argDocID 病历目录展现结构ID  argTitleID 术后首次病程记录标题ID
/// Return：       InstanceID:病历实例数据ID ,DocID:病历目录展现结构ID  如果有Save状态的数据，正常返回4列出参，如果没有实例数据4列出参均为""
/// Others：       
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","FirstRecordAfterOperation","76","616","15")		
Query FirstRecordAfterOperation(argEpisodeID As %String, argDocID As %String, argTitleID As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,DocID:%String,InstanceID:%String")
{
}

ClassMethod FirstRecordAfterOperationExecute(ByRef qHandle As %Binary, argEpisodeID As %String, argDocID As %String, argTitleID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:($d(^PAADM(argEpisodeID))=0)||(argEpisodeID="")||(argDocID="")||(argTitleID="") $$$OK
	Set BreakFlag=""
		
	Set EMRDocID=" "_argDocID		
	Set ECRecordID=""
	For
	{
		Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,EMRDocID,ECRecordID))
		Quit:((ECRecordID="")||(BreakFlag="1"))
	
		Set ListNo=""
		For
		{
			Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo),-1)
			Quit:((ListNo="")||(BreakFlag="1"))
			Set Rowid=""
			For
			{
				Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid),-1)
				Quit:Rowid=""
				
				Set InstanceID=ECRecordID_"||"_Rowid
				Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
				If ((objInstance.Status="Save")&&(objInstance.TitleCode=argTitleID))
				{
					Set BreakFlag="1"
					Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
					Set curPatientID=objEcrecord.PatientID
					Set curEpisodeID=objEcrecord.EpisodeID
					Set curDocID=objEcrecord.ChartItemID
					Set curInstanceID=InstanceID
				}
				Quit:((objInstance.Status="Save")&&(objInstance.TitleCode=argTitleID))
			}
			
		}
	}
	
	Set ^CacheTemp(repid, ind) = $LB(curPatientID,curEpisodeID,curDocID,curInstanceID)
	Quit $$$OK
}

ClassMethod FirstRecordAfterOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FirstRecordAfterOperationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FirstRecordAfterOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FirstRecordAfterOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：      guozongtao
/// CreatDate：    2014-08-31
/// Description:   病案首页出院诊断信息,首页中出院诊断分为主要诊断和其他诊断，共26个，每个数据项都定了数据元唯一标示符
/// Table：        
/// Input：        argEpisodeID :患者就诊号
/// Return：       出院诊断，数据元唯一标示符见参考文档
/// Others：       
/// Debug:         Do ##Class(DtPortal.Doctor.EMRInfoService).GetEMRHDSD0011DiagInfo("76")		
ClassMethod GetEMRHDSD0011DiagInfo(argEpisodeID As %String) As DtPortal.OutPut
{
	Set ResultValue = ##class(DtPortal.OutPut).%New()
	Set array=##Class(%ArrayOfDataTypes).%New()
	
	Set ret= ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(argEpisodeID,"HDSD00.11")

	If (ret'="")
	{
		b ;em
		Set key = ""
		Set array = ret.GetNext(.key)    
		Set ResultValue.data=array	
	}
	Quit ResultValue
}

/// Do ##Class(DtPortal.Doctor.EMRInfoService).Test()
ClassMethod Test()
{
	///C00.00.01	根据就诊号查看电子病历
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRBrowser","391")

	///C00.00.02 	根据就诊号查看电子病历首页
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRHDSD0011","835","635")
	
	///C00.00.03 	根据就诊号查看转入/转出记录	
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRHDSD0014","391","88","9^8")

	///C00.00.05	调用填写病程记录服务
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","CreateEMRHDSD0014","391","88","9","841")
	
	///             查询死亡小结接口
	Set obj= ##Class(DtPortal.Doctor.EMRInfoService).GetPortalDeathSummaryInfo("710")
	w obj.data.GetAt("HDSD00.14.080")
	w obj.data.GetAt("HDSD00.14.081")
	w obj.data.GetAt("HDSD00.14.082")
	w obj.data.GetAt("HDSD00.14.104")
	w obj.data.GetAt("HDSD00.14.107")
	
	///             术前讨论
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","PreoperativeDiscussion","710","633")
	
	///             术后首次病程记录
	Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","FirstRecordAfterOperation","710","616","15")
	
	///             病案首页出院诊断信息
	Do ##Class(DtPortal.Doctor.EMRInfoService).GetEMRHDSD0011DiagInfo("76")
}

/// Creator：      niucaicai
/// CreatDate：    2016-03-24
/// Description:   根据EpisodeID和InstanceID查询病历信息
/// Table：        EMRinstance.ECRecord, EMRinstance.InstanceData, EMRinstance.EMRLogs
/// Input：        EpisodeID:就诊指针  InstanceID:病历索引ID
/// Return：       
/// Others：       
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRsignInfoByInsIDEpisodeID","1772")	
Query GetEMRsignInfoByInsIDEpisodeID(UserCode As %String) As %Query(ROWSPEC = "BedNum:%String,EpisodeID:%String,PapmiNO:%String,PapmiName:%String,DoucumnetDesc:%String,InstanceID:%String,SignUserName:%String,EMRStatus:%String,DocID:%String,MedicareNo:%String,AdmReason:%String,Sex:%String,Age:%String")
{
}

ClassMethod GetEMRsignInfoByInsIDEpisodeIDExecute(ByRef qHandle As %Binary, UserCode As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	i UserID="" 	Quit $$$OK
	set messageData=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetMessageDataByType(UserID,"1052")
	//业务id
	set argInstanceIDStr=messageData.GetValue("bizObjId") 
	//就诊id
	set argEpisodeIDStr=messageData.GetValue("bizAdmId")
	w argInstanceIDStr,argEpisodeIDStr,!
	Quit:(argEpisodeIDStr = "")||(argInstanceIDStr = "") $$$OK
	
	for indAdm=1:1:$l(argEpisodeIDStr,"^") {
		s argEpisodeID=$p(argEpisodeIDStr,"^",indAdm)
		s argInstanceID=$p(argInstanceIDStr,"^",indAdm)
	
		if (argEpisodeID = "")||(argInstanceID = "") Continue
		
	
		s CurrECRecordID = $p(argInstanceID,"||",1)
		s CurrInstanceSubID = $p(argInstanceID,"||",2)
	
		s EMRDocID = ""
		for
		{
		s EMRDocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_EMRDocID))
		
		q:(EMRDocID = "")
		s EMRDocIDlength = $L(EMRDocID)
		s EMRDocID = $E(EMRDocID,2,EMRDocIDlength)
		
		s ECRecordID = ""
		for
		{
			s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_EMRDocID,ECRecordID))
			
			q:(ECRecordID = "")
			
			continue:(ECRecordID '= CurrECRecordID)
			
			s EMRNum = ""
			for
			{
				s EMRNum = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_EMRNum))
				
				q:(EMRNum = "")
				s length = $L(EMRNum)
				s EMRNum = $E(EMRNum,2,length)
				
				s InstanceSubID = ""
				for
				{
					s InstanceSubID = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_EMRNum,InstanceSubID))
					q:(InstanceSubID = "")
					
					continue:(InstanceSubID '= CurrInstanceSubID)
					
					s EMRlogID = $O(^DHCEMRI.EMRLogsI("IdxMain"," "_argEpisodeID," "_EMRDocID,EMRNum,""))
					continue:(EMRlogID = "")
					
					s EMRlogObj = ##Class(EMRinstance.EMRLogs).%OpenId(EMRlogID)
					
					//s BedNum = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(argEpisodeID)
					
					s EpisodeID = argEpisodeID
					s papmiDr = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
					s PapmiNO = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
					s PapmiName = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)

					s SingUserID = EMRlogObj.CreateUserID
					if (SingUserID'="")
					{
						s SignUserName = $p($g(^SSU("SSUSR",SingUserID)),"^",2)
					}
					
					s EMRStatus = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(EMRlogObj.EMRStatus)

					s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)

					s InstanceID = argInstanceID
					s DoucumnetDesc = $ZSTRIP(objInstanceData.Title,"*C")
					s DocID = EMRlogObj.EMRDocID
					
					s BedNum = ""
					s Sex = ""
					s Age = ""
					s MedicareNo = ""
					s AdmReason = ""
					s PatInfo=##class(DtPortal.Doctor.DHCDocComService).GetPatInfo(EpisodeID)
					if (PatInfo '= "")
					{
						s BedNum = $p(PatInfo,"^",1)
						s Sex = $p(PatInfo,"^",3)
						s Age = $p(PatInfo,"^",4)
						s MedicareNo = $p(PatInfo,"^",5)
						s AdmReason = $p(PatInfo,"^",6)
					}
					
					set ^CacheTemp(repid,ind) = $LB(BedNum,EpisodeID,PapmiNO,PapmiName,DoucumnetDesc,InstanceID,SignUserName,EMRStatus,DocID,MedicareNo,AdmReason,Sex,Age)
					set ind = ind + 1
					
					}
				}
			}
		}
	
	}
	
	
	
	Quit $$$OK
}

ClassMethod GetEMRsignInfoByInsIDEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRsignInfoByInsIDEpisodeIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod GetEMRsignInfoByInsIDEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRsignInfoByInsIDEpisodeIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：      niucaicai
/// CreatDate：    2016-03-24
/// Description:   根据EpisodeID和InstanceID查询病历信息
/// Table：        EMRinstance.ECRecord, EMRinstance.InstanceData, EMRinstance.EMRLogs
/// Input：        EpisodeID:就诊指针  InstanceID:病历索引ID
/// Return：       
/// Others：       
/// Debug:         Do ##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRsignInfoByInsIDEpisodeID","52","16||1")	
Query GetEMRsignInfoByInsIDEpisodeID2(argEpisodeID As %String, argInstanceID As %String) As %Query(ROWSPEC = "BedNum:%String,EpisodeID:%String,PapmiNO:%String,PapmiName:%String,DoucumnetDesc:%String,InstanceID:%String,SignUserName:%String,EMRStatus:%String,DocID:%String,MedicareNo:%String,AdmReason:%String,Sex:%String,Age:%String")
{
}

ClassMethod GetEMRsignInfoByInsIDEpisodeID2Execute(ByRef qHandle As %Binary, argEpisodeID As %String, argInstanceID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	Quit:(argEpisodeID = "")||(argInstanceID = "") $$$OK
	
	
	s CurrECRecordID = $p(argInstanceID,"||",1)
	s CurrInstanceSubID = $p(argInstanceID,"||",2)
	
	s EMRDocID = ""
	for
	{
		s EMRDocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_EMRDocID))
		
		q:(EMRDocID = "")
		s EMRDocIDlength = $L(EMRDocID)
		s EMRDocID = $E(EMRDocID,2,EMRDocIDlength)
		
		s ECRecordID = ""
		for
		{
			s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_EMRDocID,ECRecordID))
			
			q:(ECRecordID = "")
			
			continue:(ECRecordID '= CurrECRecordID)
			
			s EMRNum = ""
			for
			{
				s EMRNum = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_EMRNum))
				
				q:(EMRNum = "")
				s length = $L(EMRNum)
				s EMRNum = $E(EMRNum,2,length)
				
				s InstanceSubID = ""
				for
				{
					s InstanceSubID = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID," "_EMRNum,InstanceSubID))
					q:(InstanceSubID = "")
					
					continue:(InstanceSubID '= CurrInstanceSubID)
					
					s EMRlogID = $O(^DHCEMRI.EMRLogsI("IdxMain"," "_argEpisodeID," "_EMRDocID,EMRNum,""))
					continue:(EMRlogID = "")
					
					s EMRlogObj = ##Class(EMRinstance.EMRLogs).%OpenId(EMRlogID)
					
					//s BedNum = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(argEpisodeID)
					
					s EpisodeID = argEpisodeID
					s papmiDr = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
					s PapmiNO = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmiDr)
					s PapmiName = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(papmiDr)

					s SingUserID = EMRlogObj.CreateUserID
					if (SingUserID'="")
					{
						s SignUserName = $p($g(^SSU("SSUSR",SingUserID)),"^",2)
					}
					
					s EMRStatus = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(EMRlogObj.EMRStatus)

					s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)

					s InstanceID = argInstanceID
					s DoucumnetDesc = $ZSTRIP(objInstanceData.Title,"*C")
					s DocID = EMRlogObj.EMRDocID
					
					s BedNum = ""
					s Sex = ""
					s Age = ""
					s MedicareNo = ""
					s AdmReason = ""
					s PatInfo=##class(DtPortal.Doctor.DHCDocComService).GetPatInfo(EpisodeID)
					if (PatInfo '= "")
					{
						s BedNum = $p(PatInfo,"^",1)
						s Sex = $p(PatInfo,"^",3)
						s Age = $p(PatInfo,"^",4)
						s MedicareNo = $p(PatInfo,"^",5)
						s AdmReason = $p(PatInfo,"^",6)
					}
					
					set ^CacheTemp(repid,ind) = $LB(BedNum,EpisodeID,PapmiNO,PapmiName,DoucumnetDesc,InstanceID,SignUserName,EMRStatus,DocID,MedicareNo,AdmReason,Sex,Age)
					set ind = ind + 1
					
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetEMRsignInfoByInsIDEpisodeID2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRsignInfoByInsIDEpisodeID2Execute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod GetEMRsignInfoByInsIDEpisodeID2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRsignInfoByInsIDEpisodeID2Execute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

}
