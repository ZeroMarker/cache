/// 名称: CT.IPMR.FPS.ICDMappingSrv
/// 描述: ICD对照服务
/// 创建者：zhouyang
/// 创建日期: 2021-08-17
Class CT.IPMR.FPS.ICDMappingSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2023-02-21
/// Description:  根据版本代码获取基础平台两版本对照关系是否同步到病案系统版本
/// Table：       
/// Input：       aVerID：ICD版本ID
/// 			  aToVerID：对照ICD版本ID
/// output:       Y/N
/// w ##class(CT.IPMR.FPS.ICDMappingSrv).getICDMapSyncFlg("1","3")
ClassMethod getICDMapSyncFlg(aVerID As %String, aToVerID As %String) As %String
{
	New (aVerID,aToVerID)
	Set return=0
	Set ^TMP("getICDMapSyncFlg") = $lb(aVerID,aToVerID)
	Set objVer = ##Class(CT.IPMR.FP.ICDVer).GetObjById(aVerID)
	Set objTVer = ##Class(CT.IPMR.FP.ICDVer).GetObjById(aToVerID)
	Quit:'$isobject(objVer) return
	Quit:'$isobject(objTVer) return
	
	Set aVerCode = objVer.FICode
	Set aToVerCode = objTVer.FICode
	Set SyncFlg=""
	Set xID = ""
	For {
		Set xID = $o(^CT.IPMR.DP.SystemD(xID))
		Quit:xID=""
		Set objsys = ##class(CT.IPMR.DP.System).GetObjById(xID)
		Continue:'$isobject(objsys)
		Set ExCode = objsys.DSExCode
		Continue:ExCode=""
		
		Set request = ##class(MA.IPMR.IOModel.ENS.Request).Create()
		Set request.Header.SourceSystem="EM"
		Set request.Header.MessageID=""
		Set request.Body.Arguments.ExCode=ExCode
		Set request.Body.Arguments.FromVer=aVerCode
		Set request.Body.Arguments.ToVer=aToVerCode
		If ExCode="localhost"{
			Set xml = ##class(MA.IPMR.IOiMedical.Srv.WebService.Server.ForMR).GetSyncICDMapFlg(request.ToXML())
		}else{
			//暂时只考虑localhost
			//Set xml = ##class(CT.IPMR.DP.SoapConfig).ExecuteSoap(objsys.%Id(),"SignFlg",request.ToXML())
		}
		set response=##class(MA.IPMR.IOModel.ENS.Response).CloneFromXML(xml,"Model","MA.IPMR.IOModel.SignFlg")
		set Models = response.Body.ResultStruct.Models
		while (Models.GetNext(.key))
		{
			set model = Models.GetAt(key)
			Set SyncFlg = model.Flg
		}
	}
	Set return=SyncFlg
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2022-08-07
/// Description:  保存映射
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       MapInfo ：对照信息
///               LogInfo ：登陆信息
///               aSeparate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FPS.ICDMappingSrv).SaveMap("21053^4^T79.604^11^T79.600x004^54149^195862^1^","127.0.0.1^1687^","^")
ClassMethod SaveMap(MapInfo As %String, LogInfo As %String, aSeparate As %String = "^") As %String
{
	New (MapInfo,LogInfo,aSeparate)
	//Set ^TMP("SaveMap")=$lb(MapInfo,LogInfo,aSeparate)
	Set return = 0
	Quit:(MapInfo="")||(LogInfo="")||(aSeparate="") return
	
	Set FVerID 	= $p(MapInfo,aSeparate,2)
	Set TVerID  = $p(MapInfo,aSeparate,4) 
	Set FromICD = $p(MapInfo,aSeparate,3) 
	Set ID=$o(^CT.IPMR.FP.ICDMappingI("IndexVerICDEx",FVerID,TVerID," "_$zcvt(FromICD,"U"),0))
	Set oldData = ""
	if ID'="" {
		Set oldData = $g(^CT.IPMR.FP.ICDMappingD(ID))
		Set oldData = ##class(%Library.List).LogicalToOdbc(oldData)
	}
	
	Tstart
	// 对照信息
	Set MapID = ##class(CT.IPMR.FP.ICDMapping).Update(MapInfo,"^")
	if MapID<1 {
		trollback
		Quit -100
	}
	
	// 日志
	Set newData = $g(^CT.IPMR.FP.ICDMappingD(MapID))
	Set newData = ##class(%Library.List).LogicalToOdbc(newData)
	if oldData=newData{
		Set return = MapID
		trollback
		Quit return 
	}else{
		Set OperType="M1"
	}
	Set aInputStr = MapID
	Set aInputStr = aInputStr_"^"_OperType
	Set aInputStr = aInputStr_"^"_oldData
	Set aInputStr = aInputStr_"^"_newData
	Set aInputStr = aInputStr_"^"_LogInfo
	Set ret = ##class(CT.IPMR.FP.ICDDxLog).Update(aInputStr,"^")
	if (+ret)<1 {
		trollback
		Quit -300
	}
	tcommit
	Set return = MapID
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2021-08-12
/// Description:  查询ICD对照
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       aType：是否对照 1：已对照 0：未对照
/// Return：      
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.ICDMappingSrv","QryMapICD",2,3,"")
Query QryMapICD(aFromVerID As %String, aToVerID As %String, aICD As %String, aType As %String = "") As %Query(ROWSPEC = "ID:%String,FromVerID:%String,FromVerDesc:%String,FromICDID:%String,FromICD:%String,FromICDDesc:%String,ToVerID:%String,ToVerDesc:%String,ToICDID:%String,ToICD:%String,ToICDDesc:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryMapICDExecute(ByRef qHandle As %Binary, aFromVerID As %String, aToVerID As %String, aICD As %String, aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aFromVerID="")||(aToVerID="") $$$OK
 	
 	if (aICD'=""){
	 	set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(aFromVerID,aICD)
	 	Quit:'$isobject(objICDDx) $$$OK
	 	Quit:objICDDx.FIIsActive'=1 $$$OK
	 	if objICDDx.FIICD10[objICDDx.FIICDinPair {
		 	set aICD = objICDDx.FIICD10
		}else{
	 	set aICD = objICDDx.FIICD10_objICDDx.FIICDinPair
		}
	 	set objICDMap = ##class(CT.IPMR.FP.ICDMapping).GetMapObj(aFromVerID,aICD,aToVerID)
	 	if $isobject(objICDMap) {
		 	set xID = objICDMap.%Id()
		 	Do BuildMappingData(objICDMap.%Id())
	 	}else{
		 	Set xID=""
		 	Set objFromVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aFromVerID)
		 	Set FromVerID 	= objFromVer.%Id()
			Set FromVerDesc = objFromVer.FIEdition.BDDesc_" "_objFromVer.FIICDType.BDDesc_" "_objFromVer.FIVersion
			Set FromICDID 	= objICDDx.%Id()
			Set FromICDDesc = objICDDx.FIDesc
			if objICDDx.FIICD10[objICDDx.FIICDinPair {
				Set FromICD		= objICDDx.FIICD10
			}else{
			Set FromICD		= objICDDx.FIICD10_objICDDx.FIICDinPair
			}
			
			Set objToVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aToVerID)
			Set ToVerID 	= objToVer.%Id()
			Set ToVerDesc 	= objToVer.FIEdition.BDDesc_" "_objToVer.FIICDType.BDDesc_" "_objToVer.FIVersion
			Set ToICDID 	= ""
			Set ToICDDesc 	= ""
			Set ToICD 		= ""
			Set IsActive 	= ""
			Set Resume		= ""
		 	Set Data = $LB(xID,FromVerID,FromVerDesc,FromICDID,FromICD,FromICDDesc,ToVerID,ToVerDesc,ToICDID,ToICD,ToICDDesc,IsActive,Resume)
 			Set ^CacheTemp(repid,ind) = Data
 			Set ind = ind + 1
		}
 	}else{
	 	Set xICDID = ""
		For {
			Set xICDID=$o(^CT.IPMR.FP.ICDDxI("IndexICDVer",aFromVerID,xICDID))
			Quit:xICDID=""
			set objICDDx = ##class(CT.IPMR.FP.ICDDx).GetObjById(xICDID)
	 		Continue:'$isobject(objICDDx)
	 		Continue:objICDDx.FIIsActive'=1
			set aICD = objICDDx.FIICD10_objICDDx.FIICDinPair
			set objICDMap = ##class(CT.IPMR.FP.ICDMapping).GetMapObj(aFromVerID,aICD,aToVerID)
			Continue:(aType=1)&&('$isobject(objICDMap)) // 已对照
			Continue:(aType=0)&&($isobject(objICDMap)) // 未对照
			if $isobject(objICDMap) {
			 	set xID = objICDMap.%Id()
			 	Do BuildMappingData(objICDMap.%Id())
			}else{
				Set xID=""
			 	Set objFromVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aFromVerID)
			 	Set FromVerID 	= objFromVer.%Id()
				Set FromVerDesc = objFromVer.FIEdition.BDDesc_" "_objFromVer.FIICDType.BDDesc_" "_objFromVer.FIVersion
				Set FromICDID 	= objICDDx.%Id()
				Set FromICDDesc = objICDDx.FIDesc
				Set FromICD		= objICDDx.FIICD10_objICDDx.FIICDinPair
				
				Set objToVer = ##class(CT.IPMR.FP.ICDVer).GetObjById(aToVerID)
				Set ToVerID 	= objToVer.%Id()
				Set ToVerDesc 	= objToVer.FIEdition.BDDesc_" "_objToVer.FIICDType.BDDesc_" "_objToVer.FIVersion
				Set ToICDID 	= ""
				Set ToICDDesc 	= ""
				Set ToICD 		= ""
				Set IsActive 	= ""
				Set Resume		= ""
			 	Set Data = $LB(xID,FromVerID,FromVerDesc,FromICDID,FromICD,FromICDDesc,ToVerID,ToVerDesc,ToICDID,ToICD,ToICDDesc,IsActive,Resume)
	 			Set ^CacheTemp(repid,ind) = Data
	 			Set ind = ind + 1
			}
		}
		/*
	 	Set xICD = " "
	 	For {
		 	Set xICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFromVerID,aToVerID,xICD))
		 	Quit:xICD=""
		 	
		 	Set xTICD=""
		 	For {
				Set xTICD = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFromVerID,aToVerID,xICD,xTICD))
				Quit:xTICD=""
				
				Set xID = ""
				For {
					Set xID = $o(^CT.IPMR.FP.ICDMappingI("IndexVerICD",aFromVerID,aToVerID,xICD,xTICD,xID))
					Quit:xID=""
					
					Do BuildMappingData(xID)					
				}
		 	}
	 	}*/
 	}
	Quit $$$OK
BuildMappingData(xID)
	Set objMap = ##class(CT.IPMR.FP.ICDMapping).GetObjById(xID)
	Quit:'$isobject(objMap)

	Set objFromVer 	= objMap.IMFVerDr
	Set objToVer 	= objMap.IMTVerDr
	Set FromICD 	= objMap.IMFICD
	Set ToICD 		= objMap.IMTICD
	Set objFromICD 	= objMap.IMFICDDr
	Set objToICD 	= objMap.IMTICDDr
	Set IsActive 	= objMap.IMIsActive
	Set IsActive = $s(IsActive=1:"Y",1:"N")
	Set Resume 		= objMap.IMResume
	Quit:'$isobject(objFromVer)
	Quit:'$isobject(objToVer)
	Quit:'$isobject(objFromICD)
	Quit:'$isobject(objToICD)
	
	Set FromVerID 	= objFromVer.%Id()
	Set FromVerDesc = objFromVer.FIEdition.BDDesc_" "_objFromVer.FIICDType.BDDesc_" "_objFromVer.FIVersion
	Set FromICDID 	= objFromICD.%Id()
	Set FromICDDesc = objFromICD.FIDesc
	Set ToVerID 	= objToVer.%Id()
	Set ToVerDesc 	= objToVer.FIEdition.BDDesc_" "_objToVer.FIICDType.BDDesc_" "_objToVer.FIVersion
	Set ToICDID 	= objToICD.%Id()
	Set ToICDDesc 	= objToICD.FIDesc
	Set Data = $LB(xID,FromVerID,FromVerDesc,FromICDID,FromICD,FromICDDesc,ToVerID,ToVerDesc,ToICDID,ToICD,ToICDDesc,IsActive,Resume)
 	Set ^CacheTemp(repid,ind) = Data
 	Set ind = ind + 1
}

ClassMethod QryMapICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapICDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapICDExecute ]
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

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  组织单行页面导入数据
/// Input：       Row : 单行数据
/// Output:       数据list
ClassMethod buildInputData(Row)
{
	New (Row)
	Set FromICD=Row.%Get("编码")
	Set FromDesc=Row.%Get("名称")
	Set ToICD=Row.%Get("对照编码")
	Set ToDesc=Row.%Get("对照名称")
	Set IsActive=Row.%Get("是否有效")
	Set Resume=Row.%Get("备注")
	Set Data = $lb(FromICD,FromDesc,ToICD,ToDesc,IsActive,Resume)
	Quit Data
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  验证通过界面导入Excel中的ICD数据
/// Input：       Rows : 多行数据
///               JIndex ：进程号
///               FVerID：版本ID
///               TVerID：对照版本ID
/// 			  Start ：excel分段验证时的开始行
/// 			  EndFlag ：结束标志
/// Output:       验证结果json  
/// w ##class(CT.IPMR.FPS.ICDMappingSrv).TestDataInput(1,"","O",0,1)
ClassMethod TestDataInput(Rows As %Library.DynamicArray, JIndex As %String, FVerID As %String, TVerID As %String, Start As %String, EndFlag As %String)
{
	New (Rows,JIndex,FVerID,TVerID,Start,EndFlag)
	Set return={"success":1,"msg":"","jIndex":""}
	Set:JIndex="" JIndex=$j
	//Set ^TEMP("TestDataInput")=Rows
	Set DynamicArray = {}.%FromJSON(Rows)
	Set cnt=0
	Set RowErr=""
	Set iter = DynamicArray.%GetIterator()
	while iter.%GetNext(.key , .Row ) {
	  	Set Data = ..buildInputData(Row)
	  	Set FromICD		= $listget(Data,1)
	  	Set FromDesc	= $listget(Data,2)
	  	Set ToICD		= $listget(Data,3)
	  	Set ToDesc		= $listget(Data,4)
	  	Set IsActive	= $listget(Data,5)
	  	Set Resume		= $listget(Data,6)
		// 校验数据
		Set rowcnt=key+1+Start
		Set RowErr = ""
		If FromICD="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"编码为空！"
		}else{
			If FromICD["+" {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"编码中的加号需为剑号！"
			}else{
				set ICDDxID=""
				Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(FVerID,FromICD)
				set:$isobject(objICD) ICDDxID=objICD.%Id()
	  			Set:ICDDxID="" RowErr=RowErr_"<br>第"_rowcnt_"行"_"编码"_FromICD_"在版本中不存在！"
			}
		}
		If FromDesc="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"名称为空！"
		}
		
		If ToICD="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"对照编码为空！"
		}else{
			If ToICD["+" {
				Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"对照编码中的加号需为剑号！"
			}else{
				set ICDDxID=""
				Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(TVerID,ToICD)
				set:$isobject(objICD) ICDDxID=objICD.%Id()
				Set:ICDDxID="" RowErr=RowErr_"<br>第"_rowcnt_"行"_"对照编码"_ToICD_"在对照版本中不存在！"
			}
		}
		If ToDesc="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"对照名称为空！"
		}
		// 是否有效
		If IsActive="" {
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"是否有效为空！"
		}else{
			If '((IsActive="Y")||(IsActive="N")) {
				If RowErr="" {
					Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"是否有效值域不对！"
				}else{
					Set RowErr=RowErr_"是否有效值域不对！"
				}
			}
		}
		Set return.msg = return.msg_RowErr
	}
	If return.msg="" {
		Set return.jIndex=JIndex
	}else{
		Set return.success=0
		Set return.jIndex=JIndex
	}
	Quit return.%ToJSON()
}

/// Creator：     liyi
/// CreatDate：   2022-07-25
/// Description:  通过界面导入Excel中的ICD对照数据
/// Table：       CT.IPMR.FP.ICDMapping
/// Input：       Rows : 多行数据
///               JIndex ：进程号
///               FVerID：版本ID
///               TVerID：对照版本ID
/// 			  Start ：excel分段导入时的开始行
/// 			  EndFlag ：结束标志
/// 			  LogInfo ：登陆信息
/// Output:       验证结果json  
/// w ##class(CT.IPMR.FPS.ICDMappingSrv).DataInput("","1176","4","11","23600","1","127.0.0.1^1687^页面导入")
ClassMethod DataInput(Rows As %Library.DynamicArray, JIndex As %String, FVerID As %String, TVerID As %String, Start As %String, EndFlag As %String, LogInfo As %String)
{
	New (Rows,JIndex,FVerID,TVerID,Start,EndFlag,LogInfo)
	Set return={"success":1,"msg":"","jIndex":""}
	Set:JIndex="" JIndex=$j
	//Set ^TEMP("DataInput",1)=$lb(JIndex,FVerID,TVerID,Start,EndFlag,LogInfo)
	//Set ^TEMP("DataInput")=Rows
	Set DynamicArray = {}.%FromJSON(Rows)
	Set cnt=0
	Set iter = DynamicArray.%GetIterator()
	while iter.%GetNext(.key , .Row ) {
	  	Set Data = ..buildInputData(Row)
	  	Set FromICD		= $listget(Data,1)
	  	Set FromDesc	= $listget(Data,2)
	  	Set ToICD		= $listget(Data,3)
	  	Set ToDesc		= $listget(Data,4)
	  	Set IsActive	= $listget(Data,5)
	  	Set Resume		= $listget(Data,6)
	  	Set IsActive = $s(IsActive="Y":1,1:0)
	  	set FICDID=""
		Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(FVerID,FromICD)
		set:$isobject(objICD) FICDID=objICD.%Id()
		
		set TICDID=""
		Set objICD = ##class(CT.IPMR.FP.ICDDx).GetObjByICD10(TVerID,ToICD)
		set:$isobject(objICD) TICDID=objICD.%Id()
		
		Set ID= $o(^CT.IPMR.FP.ICDMappingI("IndexVerICDEx",FVerID,TVerID," "_$zcvt(FromICD,"U"),0))
		Set InputStr = ID
		Set InputStr = InputStr_"^"_FVerID
		Set InputStr = InputStr_"^"_FromICD
		Set InputStr = InputStr_"^"_TVerID 
		Set InputStr = InputStr_"^"_ToICD
		Set InputStr = InputStr_"^"_FICDID
		Set InputStr = InputStr_"^"_TICDID
		Set InputStr = InputStr_"^"_IsActive
		Set InputStr = InputStr_"^"_Resume
		Set ret = ##class(CT.IPMR.FPS.ICDMappingSrv).SaveMap(InputStr,LogInfo,"^")
		Set rowcnt=key+1+Start
		Set RowErr = ""
		if (+ret)<0 {
			Set ^LLLL=InputStr
			Set RowErr=RowErr_"<br>第"_rowcnt_"行"_"导入失败！"
		}
		Set return.msg = return.msg_RowErr
	}
	If return.msg="" {
		Set return.jIndex=JIndex
	}else{
		Set return.success=0
		Set return.jIndex=JIndex
	}
	Quit return.%ToJSON()
}

}
