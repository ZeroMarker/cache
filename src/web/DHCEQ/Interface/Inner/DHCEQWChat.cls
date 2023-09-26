/// web.DHCEQ.Interface.Inner.DHCEQWChat
Class web.DHCEQ.Interface.Inner.DHCEQWChat Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCEQWChat";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService0005
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// GetWChat
/// 弋矶山微信接口
Method GetWChat(ActionCode As %String = "", RequestXML As %String = "", CheckInfo As %String = "") As %String [ WebMethod ]
{
	//测试编号及XML
	//s ActionCode="0005"     
	//s RequestXML="<Request><Status>0</Status><RequestLocDR></RequestLocDR><ApproveRole></ApproveRole><WaitAD>off</WaitAD><CurGroupID>85</CurGroupID></Request>"    //查询待提交单据   申请
	//s RequestXML="<Request><Status>1</Status><RequestLocDR></RequestLocDR><ApproveRole>18</ApproveRole><WaitAD>on</WaitAD><CurGroupID>85</CurGroupID></Request>"   //查询已提交单据   受理
	//s RequestXML="<Request><Status>1</Status><RequestLocDR></RequestLocDR><ApproveRole>19</ApproveRole><WaitAD>on</WaitAD><CurGroupID>85</CurGroupID></Request>"   //查询待受理单据  
	//s RequestXML="<Request><Status>1</Status><RequestLocDR></RequestLocDR><ApproveRole>20</ApproveRole><WaitAD>on</WaitAD><CurGroupID>85</CurGroupID></Request>"   //查询待完成单据   完成
	//s RequestXML="<Request><Status>1</Status><RequestLocDR></RequestLocDR><ApproveRole>21</ApproveRole><WaitAD>on</WaitAD><CurGroupID>85</CurGroupID></Request>"   //查询已完成单据
	//s ActionCode="0001"
	//s RequestXML="<Request><EquipNo>3220305000002</EquipNo></Request>"
	//s ActionCode="0002" //
	//s RequestXML="<Request><TableName>DHCEQMCMaintProcess</TableName><Name></Name><NumFrom></NumFrom></Request>"
	//s ActionCode="0010"
	//s RequestXML="<Request><itmjs></itmjs><itmjsex></itmjsex><rowid>76</rowid></Request>"
	//s ActionCode="0011"
	//s RequestXML="<Request><code></code><desc></desc></Request>"
	//s ActionCode="0012"
	//s RequestXML="<Request><vSourceType>1</vSourceType><vSourceID>76</vSourceID><vApproveRole></vApproveRole></Request>"
	//s ActionCode="0013"
	//s RequestXML="<Request><UserID></UserID><UserName>Demo</UserName><NumFrom>0</NumFrom><NumTo></NumTo></Request>"
	//s ActionCode="0014"
	//s RequestXML="<Request><vSourceType>1</vSourceType><vSourceID>76</vSourceID><vCurRole>21</vCurRole><vUser>85</vUser><vEvaluationInfo>1=6^2=8^3=5^</vEvaluationInfo></Request>"
	//s ActionCode="0019"
	//s RequestXML="<Request><MaintID>76</MaintID><MaintProgress>2</MaintProgress></Request>"
	//s ActionCode="0020"
	//s RequestXML="<Request><MaintID>76</MaintID></Request>"
	//s ActionCode="0003"
	//s RequestXML="<Request><MaintInfo>^^^2^25^1^1^95^14/06/2016^^2^故障现象备注^^^^^^^13/06/2016^^1^0775-3922832^19楼^^^^^^^^^^^^^^^^^^备注^0^1^^^^^3^1^^^</MaintInfo><PictureInfo>^sahl3.jpg^微信图片^^^^3^122^1</PictureInfo></Request>"
	//s ActionCode="0006"
	//s RequestXML="<Request><itmjs></itmjs><itmjsex></itmjsex><MRRowID>122</MRRowID><MRStatus>1</MRStatus><vUser>1</vUser></Request>"
	//s ActionCode="0007"    
	//受理：<Request><mInfo>121^1^^^85</mInfo><mRole>19</mRole><mRoleStep>2</mRoleStep><mEditInfo>DHC_EQMMaintRequest&amp;121^13/06/2016,35^2,36^1,37^2,38^1,39^FaultReasonRemark,40^DealMethodRemark,41^34.0,42^0,43^0,44@</mEditInfo></Request>
	//s RequestXML="<Request><mInfo>121^1^^^85</mInfo><mRole>19</mRole><mRoleStep>2</mRoleStep><mEditInfo>DHC_EQMMaintRequest&amp;121^13/06/2016,35^2,36^1,37^2,38^1,39^FaultReasonRemark,40^DealMethodRemark,41^34.0,42^0,43^0,44@</mEditInfo></Request>"
	//完成：<Request><mInfo>119^1^^^85</mInfo><mRole>20</mRole><mRoleStep>3</mRoleStep><mEditInfo>DHC_EQMMaintRequest&amp;119^,45^2,46^1,47^2,48^FaultReasonRemark,49^DealMethodRemark,50^1056,51^34.0,52^0,53^07/06/2016,54^,55@</mEditInfo></Request>
	//s RequestXML="<Request><mInfo>120^1^^^85</mInfo><mRole>20</mRole><mRoleStep>3</mRoleStep><mEditInfo>DHC_EQMMaintRequest&amp;120^,45^2,46^1,47^2,48^FaultReasonRemark,49^DealMethodRemark,50^1056,51^34.0,52^0,53^07/06/2016,54^,55@</mEditInfo></Request>"
	//s ActionCode="0018"
	//s RequestXML="<Request><ExObjID>1</ExObjID></Request>"
	//s ActionCode="0021"
	//s RequestXML="<Request><vSourceType>1</vSourceType><vSourceID>65</vSourceID></Request>"
	//s ActionCode="0022"
	//s RequestXML="<Request><rowid>1999</rowid><Path>1998.jpg</Path><Remark>微信图片</Remark><Equipdr></Equipdr><IsDel></IsDel><vSourceType></vSourceType><vSourceID></vSourceID><vUser>1</vUser></Request>"
	//s ActionCode="0023"
	//s RequestXML="<Request><vSourceType>5</vSourceType><vSourceID>123</vSourceID></Request>"
	s RequestXML=$TR(RequestXML,$C(10))
    s RequestXML=$TR(RequestXML,$C(0))
    ;Add By QW20160920 Permission
    i ActionCode="0999" s CheckInfo="-1^0^^^^^"
    s LogData=CheckInfo_"^"_ActionCode ;"006^1^85^102"_"^"_ActionCode
    s perminssion=##Class(web.DHCEQWChatUser).CallPermission(LogData)
    i ($P(perminssion,"^",1)="0") q "<Response><ResultCode>1</ResultCode><ResultDesc>No Permission</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
    ;End By QW20160920 Permission
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(RequestXML)
    d reader.Correlate("Request","web.DHCEQ.Interface.Inner.DHCEQWChatProperty")
	/******************扫描设备条码得到设备基本信息*****************************/
	i ActionCode="0001"
	{
		s EquipNo=""
	   	While reader.Next(.request,.sc)
		{
		   s EquipNo=request.EquipNo
		}
		s info=##class(web.DHCEQM.DHCEQMaintForService).GetEquipByEquipNo(EquipNo)
		s info=##Class(web.DHCEQCommon).Replace(info,"&","&amp;")		//add by czf 20200613 特殊字符转换 begin
		s info=##Class(web.DHCEQCommon).Replace(info,"<","&lt;")
		s info=##Class(web.DHCEQCommon).Replace(info,">","&gt;")
		s info=##Class(web.DHCEQCommon).Replace(info,"""","&quot;")
		s info=##Class(web.DHCEQCommon).Replace(info,"'","&apos;") 		//add by czf 20200613 特殊字符转换 end
		//定义输出参数   //
		s OutputParameter="TRowID^TName^TNo^TModel^TLeaveFactoryNo^TUseLoc^TUseLocDR^TOriginalFee^TFileNo^TEquipTypeDR^TStatCatDR^TStartDate^TManuFactory^TProvider"
		s result=##class(web.DHCEQCommon).OutputToXml(OutputParameter,info)
		q result 
	}
	/**************************维修基础数据**********************/
	//故障现象:DHCEQCFaultCase
	//故障原因:DHCEQCFaultReason
	//故障类型:DHCEQCFaultType
	//维修方式:DHCEQMCMaintMode
	//解决办法:DHCEQCDealMethod
	//维修结果:DHCEQMCMaintResults
	//维修进度:DHCEQMCMaintProcess
	
	i ActionCode="0002"
	{
		s TableName=""
	   	While reader.Next(.request,.sc)
		{
		   s TableName=request.TableName
		}
		//i (TableName="DHCEQMCMaintProcess")	q "<Response><select>0-维修中&1-等待配件&2-返厂维修&3-其他&4-保内维修</select><Response>"   ;q "0-维修中&1-等待配件&2-返厂维修&3-其他&4-保内维修"
		s result=##Class(web.DHCEQCommon).doFormatToXML(TableName)
		q result
	}
	/*****************************保存维修单**********************************/
	i ActionCode="0003"
	{
		s MaintInfo=""
		s PictureInfo=""
	   	While reader.Next(.request,.sc)
		{
		   s MaintInfo=request.MaintInfo
		   s PictureInfo=request.PictureInfo
		}
		s EvaluateInfo="EEvaluateTypeDR^EScore^EContent^ERemark^EUserDR^EDate^ETime"
		s result1=##class(web.DHCEQM.DHCEQMMaintRequest).UpdateMaintRequest("","",MaintInfo,EvaluateInfo)
		s result2=0
		i PictureInfo'=$c(0)
		{
			s result=0
			f i=1:1:$l(PictureInfo,"&")
			{
				s Info=$p(PictureInfo,"&",i)
				s rowid=$p(Info,"^",1)
				s Path=$p(Info,"^",2)
				s Remark=$p(Info,"^",3)
				s Equipdr=$p(Info,"^",4)
				s IsDel=$p(Info,"^",5)
				s vSourceType=$p(Info,"^",6)
				s vSourceID=$p(Info,"^",7)
				s vUser=$p(Info,"^",8)  
				s Path=$p(Path,".",$l(Path,"."))   //获取图片后缀名  ".jpg、.png、.bmp"
				s result=##Class(web.DHCEQPicture).SaveData("","",rowid,Path,Remark,Equipdr,IsDel,"",vSourceType,vSourceID,vUser,"Y")
				i i=1 s result2=result	
				else  s result2=result2_"-"_result    //返回图片RowID
			}
			
		}
		i (result1>0)&((result2>=0))
		{   //成功
			q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result1_"^"_result2_"</result></DirectorData></ResultList></Response>"
		}
		else
		{    //失败
			q "<Response><ResultCode>1</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result1_"^"_result2_"</result></DirectorData></ResultList></Response>"
		}
	}
	/**************************自动保存维修对象*********************************/
	i ActionCode="0004"
	{
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		}
		s result=##class(web.DHCEQM.DHCEQMExObj).AutoSaveExObj(EQRowID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************待操作维修单据查询*****************************/
	i ActionCode="0005"
	{
		s Status=""
		s RequestLocDR="" 
		s ApproveRole=""
		s WaitAD=""
		s CurGroupID=""
		s CurUser=""
	   	While reader.Next(.request,.sc)
		{
		   s Status=request.Status
		   s RequestLocDR=request.RequestLocDR
		   s ApproveRole=request.ApproveRole
		   s WaitAD=request.WaitAD	
		   s CurUser=request.CurUser	
		   s CurGroupID=request.CurGroupID		
		}
		i Status=$C(0) s Status=""
		i RequestLocDR=$c(0) s RequestLocDR=""
		i ApproveRole=$c(0) s ApproveRole=""
		i CurUser=$c(0) s CurUser=""
		i WaitAD=$c(0) s WaitAD=""
		i CurGroupID=$c(0) s CurGroupID=""
		//s EndDate=64055
		//s StartDate=$h-3  //筛选数据
	/*
		s result =##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest")
  		Do result.SetArgs(Status,"",RequestLocDR,"","",ApproveRole,WaitAD,"","","N","","1","85","1","1","Action=WX_Accept^SubFlag=") 
  		s ^DHCEQZX(2)=result
  		Quit result
		*/
		s ds =##class(%Library.ResultSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest")
  		d ds.Execute(Status,"",RequestLocDR,"","",ApproveRole,WaitAD,"","","N","","",CurUser,CurGroupID,CurUser,"Action=WX_Accept^SubFlag=") //modifeid by hhm 2016-05-30 CurGroupID
  		s result=""
		while(ds.Next())  
		{	
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TRequestNO="<TRequestNO>"_ds.TRequestNO_"</TRequestNO>"
			s TRequestDate="<TRequestDate>"_ds.TRequestDate_" "_ds.TRequestTime_"</TRequestDate>"
			;s TRequestTime="<TRequestTime>"_ds.TRequestTime_"</TRequestTime>"
			s TFaultCase="<TFaultCase>"_ds.TFaultCase_"</TFaultCase>"
			s TExObj="<TExObj>"_ds.TExObj_"</TExObj>"
			s TEquipNo="<TEquipNo>"_ds.TEquipNo_"</TEquipNo>"  //----
			s TUseLoc="<TUseLoc>"_ds.TUseLoc_"</TUseLoc>"
			//s TFileNo="<TFileNo>"_ds.TFileNo_"</TFileNo>"
			s TStatus="<TStatus>"_ds.TStatus_"</TStatus>"
			s EmergencyLevel="<TEmergencyLevel>"_ds.TEmergencyLevel_"</TEmergencyLevel>"  //add by HHM 添加紧急程度 2016-06-01
			s TRequestLoc="<TRequestLoc>"_ds.TRequestLoc_"</TRequestLoc>"            //add by HHM 添加申请科室 2016-06-07
			s info=TRowID_TRequestNO_TRequestDate_TUseLoc_TEquipNo_TExObj_TFaultCase_TStatus_EmergencyLevel_TRequestLoc
			s result=result_info
		}
		s result="<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
		q result
		
	}
	
	/**************************提交维修单*********************************/
	i ActionCode="0006"
	{
		s MRRowID=""
		s MRStatus=""
		s vUser=""
		S GroupID=""
	   	While reader.Next(.request,.sc)
		{
		   ;s itmjs=request.itmjs
		   ;s itmjsex=request.itmjsex
		   s MRRowID=request.MRRowID
		   s MRStatus=request.MRStatus
		   s vUser=request.vUser
		   s GroupID=request.GroupID
		}
		;i itmjs=$c(0) s itmjs=""
		;i itmjsex=$c(0) s itmjsex=""
		i MRRowID=$c(0) s MRRowID=""
		i MRStatus=$c(0) s MRStatus=""
		i vUser=$c(0) s vUser=""
		i GroupID=$c(0) s GroupID=""
		s result=##class(web.DHCEQM.DHCEQMMaintRequest).SubmitMaintRequest("","",MRRowID,"1",vUser,GroupID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/**************************维修受理,完成操作*********************************/
	i (ActionCode="0007")
	{
		s mInfo=""
		s mRole=""
		s mRoleStep=""
		s mEditInfo=""
		s mApproveFlowID=""
		s MaintProcess=""
		s action=""  //add by zx 2017-06-20 BUG ZX0038
		While reader.Next(.request,.sc)
		{
			s mInfo=request.mInfo
			s mRole=request.mRole
			s mRoleStep=request.mRoleStep
			s mEditInfo=request.mEditInfo
			s mApproveFlowID=request.mApproveFlowID
			s MaintProcess=request.MaintProcess
			s action=request.action
		}
		i mInfo=$c(0) s mInfo=""
		i mRole=$c(0) s mRole=""
		i mRoleStep=$c(0) s mRoleStep=""
		i mEditInfo=$c(0) s mEditInfo=""
		i mApproveFlowID=$c(0) s mApproveFlowID=""
		i MaintProcess=$c(0) s MaintProcess=""
		i action=$c(0) s action=""
		s result=##Class(web.DHCEQM.DHCEQMMaintRequest).AuditData(mInfo, mRole, mRoleStep, mEditInfo,mApproveFlowID,MaintProcess,action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/************************获取维修图片*******************************/
	i ActionCode="0008"
	{
		s PLRowID=""
		s UploadFlag=""
		
	}
	/*************************获取一个维修单据***************************/
	i (ActionCode="0010")
	{
		s rowid=""
		s ApproveRoleDR=""
		s action=""
		s step=""
		s role=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		   s ApproveRoleDR=request.ApproveRoleDR
		   s action=request.action
		}
		i rowid=$c(0) s rowid=""
		i ApproveRoleDR=$c(0) s ApproveRoleDR=""
		i action=$c(0) s action=""
		s result=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintRequest("","",rowid,ApproveRoleDR,action,"")
		s result=##Class(web.DHCEQCommon).Replace(result,"<","&lt;")
		s result=##Class(web.DHCEQCommon).Replace(result,">","&gt;")
		//Modify by zx 2021-01-19 BUG ZX0127
		/*i action'="" d
    	.s CurRoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction("37",action)
    	.s role=$p(CurRoleInfo,"^",1)
    	.s step=$p(CurRoleInfo,"^",2)*/
		s result="<MaintRequest>"_result_"</MaintRequest>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"		
	}
	
	/********************获取维修评价项目******************************/
	if ActionCode="0011"
	{
		s code=""
		s desc=""
		s result=""
		While reader.Next(.request,.sc)
		{
			s code=request.code
			s desc=request.desc
		}
		i code=$c(0) s code=""
		i desc=$c(0) s desc=""
		s ds =##class(%Library.ResultSet).%New("web.DHCEQYJSRunQian:GetEvaluateType")
		d ds.Execute(code,desc)
		while(ds.Next())
		{
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TCode="<TCode>"_ds.TCode_"</TCode>"
			s TDesc="<TDesc>"_ds.TDesc_"</TDesc>"
			s TRemark="<TRemark>"_ds.TRemark_"</TRemark>"
			s result=result_TRowID_TCode_TDesc_TRemark
		}
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}	
	/*************获取评价列表**********************/
	if ActionCode="0012"
	{
		s vSourceType=""
		s vSourceID=""
		s vApproveRole=""
		s result=""
		while reader.Next(.request,.sc)
		{
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
			s vApproveRole=request.vApproveRole
		}
		i vSourceType=$c(0) s vSourceType=""
		i vSourceID=$c(0) s vSourceID=""
		i vApproveRole=$c(0) s vApproveRole=""
		s ds =##class(%Library.ResultSet).%New("web.DHCEQYJSRunQian:EvaluateDetail")
		d ds.Execute(vSourceType,vSourceID,vApproveRole)
		while(ds.Next())
		{
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TSourceType="<TSourceType>"_ds.TSourceType_"</TSourceType>"
			s TSourceID="<TSourceID>"_ds.TSourceID_"</TSourceID>"
			s TEvaluateType="<TEvaluateType>"_ds.TEvaluateType_"</TEvaluateType>"
			s TEvaluateTypeDR="<TEvaluateTypeDR>"_ds.TEvaluateTypeDR_"</TEvaluateTypeDR>"
			s TScore="<TScore>"_ds.TScore_"</TScore>"
			s TUser="<TUser>"_ds.TUser_"</TUser>"
			s TDate="<TDate>"_ds.TDate_"</TDate>"
			s TTime="<TTime>"_ds.TTime_"</TTime>"
			s TApproveRole="<TApproveRole>"_ds.TApproveRole_"</TApproveRole>"
			s result=result_TRowID_TSourceType_TSourceID_TEvaluateType_TEvaluateTypeDR_TScore_TUser_TDate_TTime_TApproveRole
		}
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}	
	/***************根据用户获取科室************************/
	if ActionCode="0013"
	{
		s UserID=""
		s UserName=""
		s NumFrom=""
		s NumTo=""
		while reader.Next(.request,.sc)
		{
			s UserID=request.UserID
			s UserName=request.UserName
			s NumFrom=request.NumFrom
			s NumTo=request.NumTo
		}		
		i UserID=$c(0) s UserID=""
		i UserName=$c(0) s UserName=""
		i NumFrom=$c(0) s NumFrom=0
		i NumTo=$c(0) s NumTo=0
		s ds =##class(%Library.ResultSet).%New("web.DHCEQCommon:GetLocByUserID")
		d ds.Execute(UserID,UserName,NumFrom,NumTo)
		s result=""
		while(ds.Next())
		{
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TUserCode="<TUserCode>"_ds.TUserCode_"</TUserCode>"
			s TUserName="<TUserName>"_ds.TUserName_"</TUserName>"
			s TLocDesc="<TLocDesc>"_ds.TLocDesc_"</TLocDesc>"
			s TGroupDesc="<TGroupDesc>"_ds.TGroupDesc_"</TGroupDesc>"
			
			s TGroupDR="<TGroupDR>"_ds.TGroupDR_"</TGroupDR>"
			s TLocDR="<TLocDR>"_ds.TLocDR_"<TLocDR>"
			s LastFlag="<LastFlag>"_ds.LastFlag_"</LastFlag>"
			s result=result_TRowID_TUserCode_TUserName_TLocDR_TLocDesc_TGroupDR_TGroupDesc_LastFlag
		}	
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"		
	}
	/***************保存维修评价信息**********************/
	if ActionCode="0014"
	{
		s vSourceType=""
		s vSourceID=""
		s vCurRole=""
		s vUser=""
		s vEvaluationInfo=""
		while reader.Next(.request,.sc)
		{
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
			s vCurRole=request.vCurRole
			s vUser=request.vUser
			s vEvaluationInfo=request.vEvaluationInfo      //vEvaluationInfo="rowid1=Score1^rowid2=Score2^rowid3=Score3^"  1：难易程度、2：工作态度、3：处理速度
		}
		s info=""
		i vEvaluationInfo=$c(0) s vEvaluationInfo=""
		i $l(vEvaluationInfo,"^")=1 d
		.s info=$p(vEvaluationInfo,"^",1)
		e  d
		.s info=$p(vEvaluationInfo,"^",1)
		.s i=""
		.f i=2:1:$l(vEvaluationInfo,"^")-1 d
		..s info=info_"^"_$p(vEvaluationInfo,"^",i)
		i vSourceType=$c(0) s vSourceType=""
		i vSourceID=$c(0) s vSourceID=""
		i vCurRole=$c(0) s vCurRole=""
		i vUser=$c(0) s vUser=""
		i vEvaluationInfo=$c(0) s vEvaluationInfo=""
		s result=##class(web.DHCEQM.DHCEQMMaintRequest).SaveEvaluation(vSourceType, vSourceID, vCurRole, info,vUser)
		i result>0 q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><SQLCODE>"_result_"</SQLCODE></DirectorData></ResultList></Response>"
		e  q "<Response><ResultCode>1</ResultCode><ResultDesc>保存失败</ResultDesc><ResultList><DirectorData><SQLCODE>"_result_"</SQLCODE></DirectorData></ResultList></Response>"
	}
	/***************远程获取FTP信息********************/
	if ActionCode="0015"
	{
		s path="<Path>"_##class(web.DHCEQCommon).GetSysInfo("990004")_"</Path>"   //图片路径
		s server=##class(web.DHCEQCommon).GetSysInfo("990018")                    //ftp服务信息
		s url="<Url>"_$p(server,"&",1)_"</Url>"                                   //ftp服务器地址
		s ftpuser="<FtpUser>"_$p(server,"&",2)_"</FTpUser>"
		s ftppsd="<FtpPsd>"_$p(server,"&",3)_"<FtpPsd>"
		s port="<Port>"_$p(server,"&",4)_"</Port>"
		s result=path_url_ftpuser_ftppsd_port
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*************************获取单个设备维修单*****************************/
	i ActionCode="0018"
	{
		s ExObjID=""
		while reader.Next(.request,.sc)
		{
			s ExObjID=request.ExObjID
		}
		i ExObjID=$c(0) s ExObjID=""
		s ds =##class(%Library.ResultSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetOneEquipMaint")
		d ds.Execute(ExObjID)
		s result=""
		// TRowID,TRequestNo,TRequestDate,TRequestTime,TExObj,TExObjNo,TModel,TFaultReasonRemark,TTatus,TEmergencyLevel
		while(ds.Next())
		{
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TRequestNo="<TRequestNo>"_ds.TRequestNo_"</TRequestNo>"
			s TRequestDate="<TRequestDate>"_ds.TRequestDate_" "_ds.TRequestTime_"</TRequestDate>"
			//s TRequestTime="<TRequestTime>"_ds.TRequestTime_"</TRequestTime>"
			s TExObj="<TExObj>"_ds.TExObj_" "_ds.TModel_"</TExObj>"
			s TExObjNo="<TExObjNo>"_ds.TExObjNo_"</TExObjNo>"
			//s TModel="<TModel>"_ds.TModel_"</TModel>"
			s TFaultReasonRemark="<TFaultReasonRemark>"_ds.TFaultReasonRemark_"</TFaultReasonRemark>"
			s TTatus="<TTatus>"_ds.TTatus_"</TTatus>"
			s TEmergencyLevel="<TEmergencyLevel>"_ds.TEmergencyLevel_"</TEmergencyLevel>"
			s result=result_TRowID_TRequestNo_TRequestDate_TExObj_TExObjNo_TFaultReasonRemark_TTatus_TEmergencyLevel
		}
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/****************保存维修进度报告********************/
	if ActionCode="0019"
	{
		s MaintID=""
		s MaintProgress=""
		while reader.Next(.request,.sc)
		{
			s MaintID=request.MaintID
			s MaintProgress=request.MaintProgress
		}
		i MaintID=$c(0) s MaintID=""
		i MaintProgress=$c(0) s MaintProgress=""
		s result=##Class(web.DHCEQM.DHCEQMMaintRequest).SaveMaintProgress(MaintID,MaintProgress)
		s result="<SQLCODE>"_result_"</SQLCODE>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*******************获取维修进度报告信息***************************/
	i ActionCode="0020"
	{
		s MaintID=""
		while reader.Next(.request,.sc)
		{
			s MaintID=request.MaintID
		}
		i MaintID=$c(0) s MaintID=""
		s result=##Class(web.DHCEQM.DHCEQMMaintRequest).GetMaintProgress(MaintID)
		s result="<MaintProgress>"_result_"</MaintProgress>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*********************获取一个评价信息**********************/
	i ActionCode="0021"
	{
		s vSourceType=""
		s vSourceID=""
		while reader.Next(.request,.sc)
		{
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
		}
		i vSourceType=$c(0) s vSourceType=""
		i vSourceID=$c(0) s vSourceID=""
		s info=##class(web.DHCEQM.DHCEQMMaintRequest).GetOneEvaluate(vSourceType,vSourceID)
		s result=""
		s i=0
		f i=2:1:$l(info,"^") d
		.s TRowID="<EApproveRole>"_$p($p(info,"^",i),",",1)_"</EApproveRole>"
		.s TItem="<TItem>"_$p($p(info,"^",i),",",2)_"</TItem>"
		.s TScore="<TScore>"_$p($p(info,"^",i),",",3)_"</TScore>"
		.s result=result_TRowID_TItem_TScore
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/********************保存维修图片信息*************************/
	// 用于在保存维修信息同时保存图片信息后，保存图片名字（名字为:RowID.jpg）
	//入参：RowID、Path、Remark、User
	/*i ActionCode="0022"
	{
		s rowid=""
		s Path=""
		s Remark=""
		s Equipdr=""
		s IsDel=""
		s CheckisDR=""
		s vSourceType=""
		s vSourceID=""
		s vUser=""
		while reader.Next(.request,.sc)
		{
			s rowid=request.rowid
			s Path=request.Path
			s Remark=request.Remark
			s Equipdr=request.Equipdr
			s IsDel=request.IsDel
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
			s vUser=request.vUser
		}
		i rowid=$c(0) s rowid=""
		i Path=$c(0) s Path=""
		i Remark=$c(0) s Remark=""
		i IsDel=$c(0) s IsDel=""
		i vSourceType=$c(0) s vSourceType=""
		i vSourceID=$c(0) s vSourceID=""
		i vUser=$c(0) s vUser=""
		s result=##Class(web.DHCEQPicture).SaveData("","",rowid,Path,Remark,"","","","","",vUser)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"	
	}*/
	/*******************获取维修图片信息***********************/
	/*i ActionCode="0023"
	{
		s vSourceType=""
		s vSourceID=""
		while reader.Next(.request,.sc)
		{
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
		}
		i vSourceType=$c(0) s vSourceType=""
		i vSourceID=$c(0) s vSourceID=""
		s ds =##class(%Library.ResultSet).%New("web.DHCEQPicture:GetPictureList")
		d ds.Execute("","",vSourceType,vSourceID)
		s result=""
		while(ds.Next())
		{
			s TRowID="<TRowID>"_ds.TRowID_"</TRowID>"
			s TEquipDR="<TEquipDR>"_ds.TEquipDR_"</TEquipDR>"
			s TPath="<TPath>"_ds.TPath_"</TPath>"
			s TRemark="<TRemark>"_ds.TRemark_"</TRemark>"
			s result=result_TRowID_TEquipDR_TPath_TRemark
		}
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}*/
	i ActionCode="0022"
	{
		s PTData=""
		s PLData=""
		while reader.Next(.request,.sc)
		{
			s PTData=request.PTData
			s PLData=request.PLData
		}
		if PTData=$C(0) set PTData=""
		if PLData=$C(0) set PLData=""
		s result=##Class(web.DHCEQ.Process.DHCEQPicture).SaveData(PTData,PLData)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"	
	}
	/*******************获取安全组可访问菜单代码***************************/
	i ActionCode="0024"
	{
		s GroupID=""
		while reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
		}
		i GroupID=$c(0) s GroupID=""
		s result=##Class(web.DHCEQCSysMenus).GetAllowMenus(GroupID)
		s result="<AllowMenus>"_result_"</AllowMenus>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*******************获取可编辑字段***************************/
	i ActionCode="0034"
	{
		s ApproveSetDR=""
		s mRole=""
		s action=""
		while reader.Next(.request,.sc)
		{
			s ApproveSetDR=request.ApproveSetDR
			s mRole=request.mRole
			s action=request.action
		}
		i ApproveSetDR=$c(0) s ApproveSetDR=""
		i mRole=$c(0) s mRole=""
		i action=$c(0) s action=""
		s result=##class(web.DHCEQApprove).GetRequiredFields(ApproveSetDR, mRole, action)
		s result="<EditFields>"_result_"</EditFields>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*******************获取审批流类型***************************/
	i ActionCode="0035"
	{
		s vSourceID=""
		s CurRoleID=""
		s ApproveTypeCode=""
		s Type=""
		s RoleStep=""
		s action=""  //add by zx 2017-06-21 BUG ZX0038
		while reader.Next(.request,.sc)
		{
			s vSourceID=request.vSourceID
			s CurRoleID=request.CurRoleID
			s ApproveTypeCode=request.ApproveTypeCode
			s Type=request.Type
			s RoleStep=request.RoleStep
			s action=request.action
		}
		i vSourceID=$c(0) s vSourceID=""
		i CurRoleID=$c(0) s CurRoleID=""
		i ApproveTypeCode=$c(0) s ApproveTypeCode=""
		i Type=$c(0) s Type=""
		i RoleStep=$c(0) s RoleStep=""
		i action=$c(0) s action=""
		s result=##class(web.DHCEQCApproveFlow).GetApproveFlowType(vSourceID, CurRoleID, ApproveTypeCode, Type, RoleStep, action)
		s result="<ApproveFlowType>"_result_"</ApproveFlowType>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	/*******************获取审批流信息***************************/
	i ActionCode="0037"
	{
		s ApproveTypeCode=""
		s rowid=""
		s ApproveRole=""
		while reader.Next(.request,.sc)
		{
			s ApproveTypeCode=request.ApproveTypeCode
			s rowid=request.rowid
			s ApproveRole=request.ApproveRole
		}
		i ApproveTypeCode=$c(0) s ApproveTypeCode=""
		i rowid=$c(0) s rowid=""
		i ApproveRole=$c(0) s ApproveRole=""
		s result=##class(web.DHCEQApprove).GetApproveInfoBySourceID(ApproveTypeCode, rowid, ApproveRole)
		s result="<ApproveInfo>"_result_"</ApproveInfo>"
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
	}
	
	/*******************验证登陆信息是否正确***********************/
	i ActionCode="0042"
	{
		s TUser=""
		s Password=""
		while reader.Next(.request,.sc)
		{
			s TUser=request.TUser
			s Password=request.Password
		}
		i TUser=$c(0) s TUser=""
		i Password=$c(0) s Password=""
		s result=""
		s Password=##class(web.Util.Encryption).Base64Decode(Password)
		s result=##Class(web.DHCEQCommon).InnerLogon(TUser,Password)  //Modify by zx 2020-07-8 登陆调整
		
        s result=$p(result,"@",1)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
		/*******************验证安全组是否正确***********************/
	i ActionCode="0044"
	{
		s GroupID=""
		s Type=""
		while reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
			s Type=request.Type
		}
		i GroupID=$c(0) s GroupID=""
		i Type=$c(0) s Type=""
		s result=""
		Set result= ##Class(web.DHCEQCommon).CheckFunction(GroupID, Type)

		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*******************绑定id***********************/
	i ActionCode="0045"
	{
		/// Modify by zx 2021-09-02 增加访问类型 BUG ZX0140
		s GroupID=""
		s UserID=""
		s LocID=""
		s ChatID=""
		s Type=""
		s Password=""
		s AccessType=""
		s UserTel=""   //Modify by zx 2022-08-25
		while reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
			s UserID=request.UserID
			s LocID=request.LocID
			s ChatID=request.ChatID
			s Type=request.Type
			s Password=request.Password
			s AccessType=request.AccessType
			s UserTel=request.vData
		}
		i GroupID=$c(0) s GroupID=""
		i UserID=$c(0) s UserID=""
		i LocID=$c(0) s LocID=""
		i ChatID=$c(0) s ChatID=""
		i Type=$c(0) s Type=""
		i Password=$c(0) s Password=""
		i AccessType=$c(0) s AccessType=""
		i UserTel=$c(0) s UserTel=""
		s result=""
		Set result= ##Class(web.DHCEQWChatUser).BindChatID(GroupID,UserID,LocID,ChatID,Type,Password,AccessType,UserTel)

		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
		/*******************检验用户微信是否绑定***********************/
	i ActionCode="0046"
	{
		/// Modify by zx 2021-09-02 增加访问类型 BUG ZX0140
		s ChatID=""
		s AccessType=""
		while reader.Next(.request,.sc)
		{
			s ChatID=request.ChatID
			s AccessType=request.AccessType
		}
		i ChatID=$c(0) s ChatID=""
		i AccessType=$c(0) s AccessType=""
		s result=""
		s info=""
		Set info= ##Class(web.DHCEQWChatUser).CheckoutChatID(ChatID, AccessType)
		s OutputParameter="UserID^GroupID^LocID^User^Group^Loc^UserTel^Password^HospitalID^LogProcess" //Add By QW20200108 BUG:QW0035 增加HospitalID
		s result=##class(web.DHCEQCommon).OutputToXml(OutputParameter,info)
		q result
		//q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*******************维修配件增删改***********************/
	i ActionCode="0050"
	{
		s val=""
		s IsDel=""
		s UserID=""
		s LocID=""
		while reader.Next(.request,.sc)
		{
			s val=request.val
			s IsDel=request.IsDel
			s UserID=request.UserID
			s LocID=request.LocID
		}
		i val=$c(0) s val=""
		i IsDel=$c(0) s IsDel=""
		i UserID=$c(0) s UserID=""
		i LocID=$c(0) s LocID=""
		Set result= ##Class(web.DHCEQM.DHCEQMMaintPart).SaveData(val,IsDel,UserID,LocID)

		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}

	/*******************配件明细提交审核***********************/
		i ActionCode="0051"  //add by zx 2016-11-28 
	{
		s rowid=""
		s LocID=""
		s UserID=""
		while reader.Next(.request,.sc)
		{
			s rowid=request.rowid
			s LocID=request.LocID
			s UserID=request.UserID
		}
		i rowid=$c(0) s rowid=""
		i LocID=$c(0) s LocID=""
		i UserID=$c(0) s UserID=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).SubmitManage(rowid,LocID,UserID)

		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*******************配件明细取消提交审核***********************/
	i ActionCode="0052"   //add by zx 2016-11-28
	{
		s rowid=""
		while reader.Next(.request,.sc)
		{
			s rowid=request.rowid
		}
		i rowid=$c(0) s rowid=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).CancelManage(rowid,"")

		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	i ActionCode="0059"
	{
		s GroupID=""
		s LocID=""
		s QXType=""
		s UserID=""
		while reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
			s LocID=request.LocID
			s QXType=request.QXType
			s UserID=request.UserID
		}
		i GroupID=$c(0) s GroupID=""
		i LocID=$c(0) s LocID=""
		i QXType=$c(0) s QXType=""
		i UserID=$c(0) s UserID=""
		Set result= ##Class(web.DHCEQMessages).GetManagementInfo(GroupID,LocID,QXType,UserID)
		Set result=$TR(result,"&","*")
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	i ActionCode="0058"
	{
		s PLID=""	
	   	While reader.Next(.request,.sc)
		{
		   s PLID=request.PLID	
		}
		if PLID=$C(0) set PLID=""
		;s ^DHCEQQWTest("PLID",2)=PLID
		&SQL(Update SQLUSER.DHC_EQPictureList set PL_UpLoadFlag='Y' where PL_RowID = :PLID)
		s result=$g(%ROWID)
		;s ^DHCEQQWTest("rowid",1)=rowid
	 	if SQLCODE  s result=SQLCODE
	 	q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*******************单条配件信息***********************/
	i ActionCode="0060"
	{
		s rowid=""
		while reader.Next(.request,.sc)
		{
			s rowid=request.rowid
		}
		i rowid=$c(0) s rowid=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).GetOneMaintPart("","",rowid)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	i ActionCode="0048"
	{
		s FileName=""
		while reader.Next(.request,.sc)
		{
			s FileName=request.rowid
		}
		if FileName=$C(0) set FileName=""
		s success="ok"
		set path=##class(web.DHCEQCommon).GetSysInfo("990004")_FileName
		Set ftp=##class(%Net.FtpSession).%New()
		set server=##class(web.DHCEQCommon).GetSysInfo("990018")
		set name=$p(server,"&",2)
		set password=$p(server,"&",3)
		set port=$p(server,"&",4)
		if port="" set port=21
		set server=$p(server,"&",1)
		If 'ftp.Connect(server,name,password,port) s success=server_"Not connected"
		If 'ftp.Binary() s success=server_"Can not swap to binary mode"
		Set BinaryStream =##class(%Library.FileBinaryStream).%New()
		d ftp.Retrieve(path,BinaryStream)
		If 'ftp.Logout() s success=server_"Failed to logout"
		//保存到临时FTP服务器 
		;在此修改临时FTP服务器 
		;set server="172.16.71.186"
		;set name="DHCEQ"
		;set password="nanfang123!"
		;set port=60982
		
		set server="192.168.1.152"
		set name="DHCEQ"
		set password="nanfang123!"
		set port=21

		If 'ftp.Connect(server,name,password,port) s success=server_"Not connected"
		If 'ftp.Binary() s success=server_"Can not swap to binary mode"
		;If 'ftp.Store(path,BinaryStream) s success=server_"Failed to save file"
		s FileName=##class(web.DHCEQCommon).GetSysInfo("990004")_FileName
		If 'ftp.Store(FileName,BinaryStream) s success=server_"Failed to save file"
		If 'ftp.Logout()  s success=server_"Failed to logout"
		d BinaryStream.Flush()
		d BinaryStream.%Close()
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_success_"</result></DirectorData></ResultList></Response>"
	}
	/***************获取租赁中心科室ID***************/
	i ActionCode="0063"
	{
		s RentLocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0301","")
		s RentLoc=##Class(web.DHCEQCommon).GetFirstIDByLocType("0301","Y")
		s result=RentLocDR_"^"_RentLoc
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*******************租赁调用SavaData方法*******************/
	i ActionCode="0064"
	{
		s val=""
		s Type=""
		s action=""
		s UserID=""
        	s GroupID="" //add by zx 2017-05-17
		While reader.Next(.request,.sc)
		{
			s val=request.val
			s Type=request.Type
			s action=request.action
			s UserID=request.UserID
            		s GroupID=request.GroupID
		}
		i val=$C(0) s val=""
		i Type=$C(0) s Type=""
		i action=$C(0) s action=""
		i UserID=$C(0) s UserID=""
        	i GroupID=$C(0) s GroupID=""
        	s result=##Class(web.DHCEQRent).SaveData(val,Type,action,UserID,GroupID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/**********************根据ID获取租赁明细************************/
	i ActionCode="0065"
	{
		s rowid=""
		s ApproveRole=""
		While reader.Next(.request,.sc)
		{
			s rowid=request.rowid
			s ApproveRole=request.ApproveRole
		}
		i rowid=$C(0) s rowid=""
		i ApproveRole=$C(0) s ApproveRole=""
		s result=##Class(web.DHCEQRent).GetRentByID(rowid,ApproveRole)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*************************获取台账表设备信息**************************/
	i ActionCode="0066"
	{
		s EquipNo=""
		While reader.Next(.request,.sc)
		{
			s EquipNo=request.EquipNo
		}
		i EquipNo=$C(0) s EquipNo=""
		s rowid = ##Class(web.DHCEQM.DHCEQMaintForService).GetEquipIDByNoNew(EquipNo)
		i rowid="" q 0
		s result = ##Class(web.DHCEQEquip).GetEquipByID("","",rowid)
		s result = rowid_"^"_result
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	i ActionCode="0068"
	{
		s Equipdr=""
		s rowid=""
		s action=""
		While reader.Next(.request,.sc)
		{
			s Equipdr=request.Equipdr
			s rowid=request.rowid
			s action=request.action
		}
		i Equipdr=$C(0) s Equipdr=""
		i rowid=$C(0) s rowid=""
		i action=$C(0) s action=""
		s result = ##Class(web.DHCEQEquipRent).GetEquipUsedInfo(Equipdr,rowid,action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*************************检测设备是否处于维修过程中**************************/
	i ActionCode="0075"
	{
		s vSourceType=""
		s vSourceID=""
		While reader.Next(.request,.sc)
		{
			s vSourceType=request.vSourceType
			s vSourceID=request.vSourceID
		}
		i vSourceType=$C(0) s vSourceType=""
		i vSourceID=$C(0) s vSourceID=""
		s result = ##Class(web.DHCEQM.DHCEQMMaintRequest).CheckMaintProcess(vSourceType,vSourceID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*************************消息发送结果返回**************************/
    i ActionCode="0999"
    {
        s val=""
        While reader.Next(.request,.sc)
        {
            s val=request.val
        }
        i val=$C(0) s val=""
        s result = ##Class(web.DHCEQMessageSendInfo).UpdateData(val)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    
    /*************************参与维修人员信息保存 Modify by zx 2021-09-01 ZX0139**************************/
    i ActionCode="0109"
    {
        s val=""
        While reader.Next(.request,.sc)
        {
            s val=request.val
        }
        i val=$C(0) s val=""
        s result = ##Class(web.DHCEQMaintUserList).SaveList(val)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    /*************************参与维修人员信息删除 Modify by zx 2021-09-01 ZX0139**************************/
    i ActionCode="0110"
    {
        s rowid=""
        While reader.Next(.request,.sc)
        {
            s rowid=request.rowid
        }
        i rowid=$C(0) s rowid=""
        s result = ##Class(web.DHCEQMaintUserList).DeleteData(rowid)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
	/******************根据类型、ID、审批角色和动作获取业务明细*******************/
	//add by czf 20171120 CZF0014
	i ActionCode="1008"
	{
		s BussType=""
		s rowid=""
		s action=""
		While reader.Next(.request,.sc)
		{
			s BussType=request.BussType
			s rowid=request.rowid
			s action=request.action
		}
		i BussType=$C(0) s BussType=""
		i rowid=$C(0) s rowid=""
		i action=$C(0) s action=""
		s result=##Class(web.DHCEQMessages).GetBussInfoBySourceID(BussType,rowid,action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	///Add By QW20200108 BUG:QW0035 Begin 类方法统一调用
	i ActionCode="2998"
	{
		s classname=""
	    s methodname=""
	    s methodparas=""
        While reader.Next(.request,.sc)
        {
            s classname=request.classname
            s methodname=request.methodname
            s methodparas=request.methodparas
        }
        i classname=$C(0) s classname=""
        i methodname=$C(0) s methodname=""
        i methodparas=$C(0) s methodparas=""
		if (classname=""||methodparas="")
		{
			q "<Response><ResultCode>-1</ResultCode><ResultDesc>代码未定义</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
		}
		s WchatLogID=$P(perminssion,"^",2)
		i WchatLogID'="" &SQL(UpDate SQLUSER.DHC_EQWChatLog Set WCL_ClassName=:classname,WCL_MethodName=:methodname where WCL_RowID=:WchatLogID)
		s methodparas=##Class(web.DHCEQCommon).Replace(methodparas,"***","&")		
		s result=##Class(web.DHCEQWChatUser).GetMethodResult(classname,methodname,methodparas)
		s result=##Class(web.DHCEQCommon).Replace(result,"&","&amp;")		//add by czf 20200613 特殊字符转换 begin
		s result=##Class(web.DHCEQCommon).Replace(result,"<","&lt;")
		s result=##Class(web.DHCEQCommon).Replace(result,">","&gt;")
		s result=##Class(web.DHCEQCommon).Replace(result,"""","&quot;")
		s result=##Class(web.DHCEQCommon).Replace(result,"'","&apos;") 		//add by czf 20200613 特殊字符转换 end
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	///Add By QW20200108 BUG:QW0035 End 
	/******************add by zouxuan 2019-03-26 台账信息获取*******************/
	i ActionCode="eq101"
	{
		s EquipNo=""
	   	While reader.Next(.request,.sc)
		{
		   s EquipNo=request.EquipNo
		}
		i EquipNo=$C(0) s EquipNo=""
		s ID = $Order(^DHCEQEquip(0,"No",EquipNo,0))
		i ID="" d
		.s result="-1"
		e  d
		.s result=##Class(web.DHCEQEquip).GetEquipByID("","",ID)_"$"_ID
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by QW 2019-03-31 附件详细信息获取*******************/
	 i ActionCode="aff101"
	 {
		s rowid=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		}
		i rowid=$C(0) s rowid=""
		s result=##Class(web.DHCEQAffix).GetAffixByID("","",rowid)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 2019-11-05 报废申请*******************/
	 i ActionCode="disuse101"
	 {
		s rowid=""
		s UserID=""
		s LocID=""
		s val=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		   s UserID=request.UserID
		   s LocID=request.LocID
		   s val=request.val
		}
		i rowid=$C(0) s rowid=""
		i UserID=$C(0) s UserID=""
		i LocID=$C(0) s LocID=""
		i val=$C(0) s val=""
		s result=##class(web.DHCEQBatchDisuseRequest).BatchDisuseRequestBuild(rowid,UserID,LocID,val)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 报废审核*******************/
	 i ActionCode="disuse102"
	 {
		s val=""
		s UserID=""
		s action=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s UserID=request.UserID
		   s action=request.action
		}
		i val=$C(0) s val=""
		i UserID=$C(0) s UserID=""
		i action=$C(0) s action=""
		s result=##Class(web.DHCEQBatchDisuseRequest).AuditData(val,"",UserID,action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 报废单信息获取*******************/
	 i ActionCode="disuse103"
	 {
		s val=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		}
		i val=$C(0) s val=""
		s result=##Class(web.DHCEQBatchDisuseRequest).GetOneDisuseRequest("","",val)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 报废取消审核*******************/
	 i ActionCode="disuse104"
	 {
		s val=""
		s UserID=""
		s action=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s UserID=request.UserID
		   s action=request.action
		}
		i val=$C(0) s val=""
		i UserID=$C(0) s UserID=""
		i action=$C(0) s action=""
		s result=##Class(web.DHCEQBatchDisuseRequest).CancelSubmit(val,UserID,action)
		;s ^DHCEQZX(1)=result
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 报废提交*******************/
	 i ActionCode="disuse105"
	 {
		s rowid=""
		s UserID=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		   s UserID=request.UserID
		}
		i rowid=$C(0) s rowid=""
		i UserID=$C(0) s UserID=""
		s result=##Class(web.DHCEQBatchDisuseRequest).SubmitData(rowid,UserID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 转移单信息获取*******************/
	 i ActionCode="storemove101"
	 {
		s rowid=""
		s action=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		   s action=request.action
		}
		i rowid=$C(0) s rowid=""
		i action=$C(0) s action=""
		s result=##Class(web.DHCEQ.EM.BUSStoreMove).GetOneStoreMove(rowid,"",action,"")
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 转移明细审核*******************/
	 i ActionCode="storemove102"
	 {
		s val=""
		s action=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s action=request.action
		}
		i val=$C(0) s val=""
		i action=$C(0) s action=""
		
		s result=##Class(web.DHCEQ.EM.BUSStoreMove).AuditData(val, "", "", "", action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/*************************上传图片删除**************************/
    i ActionCode="1009"
    {
        s rowid=""
        While reader.Next(.request,.sc)
        {
            s rowid=request.rowid
        }
        i rowid=$C(0) s rowid=""
        //Modify by zx 2021-07-08 移动端删除整单 BUG ZX0137
        s result = ##Class(web.DHCEQ.Process.DHCEQPicture).DeletePicture(rowid)
        //s result = ##Class(web.DHCEQ.Process.DHCEQPictureList).DeletePictureList(rowid)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    /******************add by zx 维修基础数据保存*******************/
	 i ActionCode="code101"
	 {
		s val=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		}
		i val=$C(0) s val=""
		s FaultType=$p(val,"^",1)
		s FaultReason=$p(val,"^",2)
		s DealMethod=$p(val,"^",3)
		s Service=$p(val,"^",4)
		s result=""
		i FaultType'="" s result=result_##Class(web.DHCEQM.DHCEQMaintForService).AutoSaveBaseCodeByTable("FaultType",FaultType,"")
		s result=result_"^"
		i FaultReason'="" s result=result_##Class(web.DHCEQM.DHCEQMaintForService).AutoSaveBaseCodeByTable("FaultReason",FaultReason,"")
		s result=result_"^"
		i DealMethod'="" s result=result_##Class(web.DHCEQM.DHCEQMaintForService).AutoSaveBaseCodeByTable("DealMethod",DealMethod,"")
		//Modify by zx 2021-11-15
		s result=result_"^"
		i Service'="" s result=result_##Class(web.DHCEQM.DHCEQMaintForService).AutoSaveBaseCodeByTable("Service",Service,"")
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zx 转移申请*******************/
	 i ActionCode="storemove103"
	 {
		//EQID, FromLocDR, ToLocDR, ReciverDR, UserID, Remark
		s EQRowID=""
		s LocID=""
		s TLocDR=""
		s TUser=""
		s UserID=""
		s TRemark=""
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		   s LocID=request.LocID
		   s TLocDR=request.TLocDR
		   s TUser=request.TUser
		   s UserID=request.UserID
		   s TRemark=request.TRemark
		}
		i EQRowID=$C(0) s EQRowID=""
		i LocID=$C(0) s LocID=""
		i TLocDR=$C(0) s TLocDR=""
		i TUser=$C(0) s TUser=""
		i UserID=$C(0) s UserID=""
		i TRemark=$C(0) s TRemark=""
		
		s result=##Class(web.DHCEQ.EM.BUSStoreMove).CreateStoreMoveByID(EQRowID,LocID,TLocDR,TUser,UserID,TRemark)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2019-12-24 维修取消提交*******************/
	i ActionCode="maint101"
	{
		s val=""
		s vCurRole=""
		s action=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s vCurRole=request.vCurRole
		   s action=request.action
		}
		i val=$C(0) s val=""
		i vCurRole=$C(0) s vCurRole=""
		i action=$C(0) s action=""
		s result=##Class(web.DHCEQ.EM.BUSMMaintRequest).CancelSubmitData(val,vCurRole,action)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2019-12-26 维修监控完成*******************/
	i ActionCode="maint102"
	{
		s GroupID=""
		s LocID=""
		s QXType=""
		s UserID=""
		while reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
			s LocID=request.LocID
			s QXType=request.QXType
			s UserID=request.UserID
		}
		i GroupID=$c(0) s GroupID=""
		i LocID=$c(0) s LocID=""
		i QXType=$c(0) s QXType=""
		i UserID=$c(0) s UserID=""
		s result=##Class(web.DHCEQMessages).GetMaintAnaly(GroupID,LocID,QXType,UserID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2020-01-14 维修单删除*******************/
	i ActionCode="maint103"
	{
		s MRRowID=""
		s UserID=""
		while reader.Next(.request,.sc)
		{
			s MRRowID=request.MRRowID
			s UserID=request.UserID
		}
		i MRRowID=$c(0) s MRRowID=""
		i UserID=$c(0) s UserID=""
		s result=##Class(web.DHCEQ.EM.BUSMMaintRequest).DeleteMaintRequest(MRRowID,UserID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	
	/******************根据设备编号获取盘点单里单台设备信息*******************/
	i ActionCode="pd101"
	{
		s InventoryDR=""
		s EquipNo=""
		s InventoryLocDR=""
		While reader.Next(.request,.sc)
		{
			s InventoryDR=request.InventoryDR
			s EquipNo=request.EquipNo
			s InventoryLocDR=request.TLocDR
		}
		i InventoryDR=$C(0) s InventoryDR=""
		i EquipNo=$C(0) s EquipNo=""
		i InventoryLocDR=$C(0) s InventoryLocDR=""
		s result=##Class(web.DHCEQInventory).GetInfoByEquipNo(InventoryDR,EquipNo,"","",InventoryLocDR)
		s result=##Class(web.DHCEQCommon).Replace(result,"&","&amp;")		//add by czf 20200825 特殊字符转换 begin 1489150
		s result=##Class(web.DHCEQCommon).Replace(result,"<","&lt;")
		s result=##Class(web.DHCEQCommon).Replace(result,">","&gt;")
		s result=##Class(web.DHCEQCommon).Replace(result,"""","&quot;")
		s result=##Class(web.DHCEQCommon).Replace(result,"'","&apos;") 		//add by czf 20200825 特殊字符转换 end 1489150
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	
	/******************盘点设备*******************/
	i ActionCode="pd102"
	{
		s val=""
		s vallistinfo=""		//modified by czf 20200629 begin
		While reader.Next(.request,.sc)
		{
			s val=request.val
			s vallistinfo=request.datalist
		}
		i val=$C(0) s val=""
		i vallistinfo=$C(0) s vallistinfo=""
		s result=##Class(web.DHCEQInventory).SaveInventoryResult(val,vallistinfo)	//modified by czf 20200629 end
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	
	/******************取消盘点设备*******************/
	i ActionCode="pd103"
	{
		s val=""
		While reader.Next(.request,.sc)
		{
			s val=request.val
		}
		i val=$C(0) s val=""
		s result=##Class(web.DHCEQInventory).CancelInventoryResult(val)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	
	/******************设备第三方编号绑定*******************/
	i ActionCode="pd104"
	{
		s IsDel=""
		s val=""
		s UserID=""
		While reader.Next(.request,.sc)
		{
			s IsDel=request.IsDel
			s val=request.val
			s UserID=request.UserID
		}
		i IsDel=$C(0) s IsDel=""
		i val=$C(0) s val=""
		i UserID=$c(0) s UserID=""
		s result=##Class(web.DHCEQInventory).SaveBindObj(IsDel,val,UserID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************盘点审核调用 Modify by zx 2020-06-30*******************/
	i ActionCode="pd105"
	{
		s InventoryDR=""
		s TLocDR=""
		While reader.Next(.request,.sc)
		{
			s InventoryDR=request.InventoryDR
			s TLocDR=request.TLocDR
		}
		i InventoryDR=$C(0) s InventoryDR=""
		i TLocDR=$C(0) s TLocDR=""
		//Modify by zx 2020-07-07
		s result=##Class(web.DHCEQ.EM.BUSInventory).LocInventory(InventoryDR,"1")
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************盘点管理部门审核调用 Modify by zx 2020-07-09*******************/
	i ActionCode="pd106"
	{
		s InventoryDR=""
		s CurUser=""
		While reader.Next(.request,.sc)
		{
			s InventoryDR=request.InventoryDR
			s CurUser=request.CurUser
		}
		i InventoryDR=$C(0) s InventoryDR=""
		i CurUser=$C(0) s CurUser=""
		s result=##Class(web.DHCEQ.EM.BUSInventory).DeleteData(InventoryDR,"2",CurUser)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************盘点管理部门分科室审核调用 Modify by zx 2020-07-09*******************/
	i ActionCode="pd107"
	{
		s InventoryDR=""
		s IsDel=""
		While reader.Next(.request,.sc)
		{
			s InventoryDR=request.InventoryDR
			s IsDel=request.IsDel
		}
		i InventoryDR=$C(0) s InventoryDR=""
		i IsDel=$C(0) s IsDel=""
		s result=##Class(web.DHCEQ.EM.BUSInventory).LocInventory(InventoryDR,IsDel)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/**************获取设备无结束日期的使用记录 Modify by zx 2020-09-01*************/
	 i ActionCode="jl101"
	 {
		s EQRowID=""
		s GroupID=""
		s LocID=""
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		   s GroupID=request.GroupID
		   s LocID=request.LocID
		}
		i EQRowID=$C(0) s EQRowID=""
		i GroupID=$C(0) s GroupID=""
		i LocID=$C(0) s LocID=""
		s result=##Class(web.DHCEQStateInfo).GetOneStateInfo(EQRowID,GroupID,LocID,"0")
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************保存使用记录信息 Modify by zx 2020-09-01*******************/
	 i ActionCode="jl102"
	 {
		//Modify by zx 2020-09-01 UserID参数处理
		s val=""
		s UserID=""
		s Type=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s UserID=request.UserID
		   s Type=request.Type
		}
		i val=$C(0) s val=""
		i UserID=$C(0) s UserID=""
		i Type=$C(0) s Type=""
		Set val=$TR(val,"*","&")
		s result=##Class(web.DHCEQStateInfo).SaveStateInfo(val,Type,UserID)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2019-06-27 根据设备id获取默认计划,执行记录单,模板等*******************/
	i ActionCode="pm101"
	{
		s EQRowID=""
		s GroupID=""
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		   s GroupID=request.GroupID
		}
		i EQRowID=$C(0) s EQRowID=""
		i GroupID=$C(0) s GroupID=""
		s PlanInfo=##Class(web.DHCEQ.EM.BUSEquipRange).GetRangSourceByEquip(EQRowID,"2","1","1",GroupID)
		s TemplateInfo=##Class(web.DHCEQ.EM.BUSEquipRange).GetRangSourceByEquip(EQRowID,"3","1","",GroupID)
		s result=PlanInfo_"#"_TemplateInfo
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2019-07-04 检查保养记录保存*******************/
	i ActionCode="pm102"
	{
		s val=""
		s Type=""
		s UserID=""
		s PMReport=""
		s PMReportList=""
	   	While reader.Next(.request,.sc)
		{
		   s val=request.val
		   s Type=request.Type
		   s UserID=request.UserID
		   s PMReport=request.PMReport
		   s PMReportList=request.PMReportList
		}
		i val=$C(0) s val=""
		i Type=$C(0) s Type=""
		i UserID=$C(0) s UserID=""
		i PMReport=$C(0) s PMReport=""
		i PMReportList=$C(0) s PMReportList=""
		s result=##Class(web.DHCEQ.EM.BUSMaint).SaveData(val,Type,UserID,PMReport,PMReportList)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	/******************add by zouxuan 2019-07-07 检查保养记录提交*******************/
	i ActionCode="pm103"
	{
		s rowid=""
		s TRowID=""
		s TSourceType=""
		s EQRowID=""
		s UserID=""
		// Modify by zx 2021-09-01 ZX0139
		s FinishFlag=""
	   	While reader.Next(.request,.sc)
		{
		   s rowid=request.rowid
		   s TRowID=request.TRowID
		   s TSourceType=request.TSourceType
		   s EQRowID=request.EQRowID
		   s UserID=request.UserID
		   s FinishFlag=request.FinishFlag
		}
		i rowid=$C(0) s rowid=""
		i TRowID=$C(0) s TRowID=""
		i TSourceType=$C(0) s TSourceType=""
		i EQRowID=$C(0) s EQRowID=""
		i UserID=$C(0) s UserID=""
		i FinishFlag=$C(0) s UsFinishFlagerID=""
		s result=##Class(web.DHCEQ.EM.BUSMaint).SubmitData(rowid, TRowID, TSourceType, EQRowID, UserID, FinishFlag)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
	///Add By QW20200108 BUG:QW0035 End 
	/*************************评价信息保存**************************/
    i ActionCode="1007"
    {
        s val=""
        s vData=""
        s vUser=""
        While reader.Next(.request,.sc)
        {
            s val=request.val
            s vData=request.vData
            s vUser=request.vUser
        }
        i val=$C(0) s val=""
        i vData=$C(0) s vData=""
        i vUser=$C(0) s vUser=""
        s result = ##Class(web.DHCEQEvaluate).SaveData(val_"^^^",vData,vUser,"")
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    /*************************文件上传后台保存 add by zx 2020-12-29**************************/
    i ActionCode="ftp101"
    {
        s val=""
        While reader.Next(.request,.sc)
        {
            s val=request.val
        }
        i val=$C(0) s val=""
        s result = ##Class(web.DHCEQ.Process.DHCEQAppendFile).SaveAppendFile(val)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    /*************************文件上传后台删除 add by zx 2020-12-29**************************/
    i ActionCode="ftp102"
    {
        s val=""
        While reader.Next(.request,.sc)
        {
            s val=request.val
        }
        i val=$C(0) s val=""
        s result = ##Class(web.DHCEQ.Process.DHCEQAppendFile).DeleteAppendFile(val)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    /*************************文件类型加载 add by zx 2021-01-11**************************/
    i ActionCode="ftp103"
    {
        s vSourceType=""
        s vSourceID=""
        s GroupID=""
        s Type=""
        While reader.Next(.request,.sc)
        {
            s vSourceType=request.vSourceType
            s vSourceID=request.vSourceID
            s GroupID=request.GroupID
            s Type=request.Type
        }
        i vSourceType=$C(0) s vSourceType=""
        i vSourceID=$C(0) s vSourceID=""
        i GroupID=$C(0) s GroupID=""
        i Type=$C(0) s Type=""
        s result = ##Class(web.DHCEQ.Process.DHCEQCPicSourceType).GetPicTypeMenu(vSourceType,vSourceID,"1",GroupID,Type)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    i ActionCode="msg101"     //add by ZX 2022-6-10
    {
        s val=""
       
        While reader.Next(.request,.sc)
        {
            s val=request.val
        }
        i val=$C(0) s val=""
        s result = ##class(web.DHCEQMessageSendInfo).MessageDealByRecInfo(val)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    i ActionCode="eq102"
    {
        s EquipNo=""
        While reader.Next(.request,.sc)
        {
            s EquipNo=request.EquipNo
        }
        i EquipNo=$C(0) s EquipNo=""
        s EQID=##class(web.DHCEQEquip).GetEquipIDByNo(no)
        i EQID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","无效编号")
        s result = ##Class(web.DHCEQ.EM.BUSEquip).GetOneEquip(EQID)
        q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
    }
    i ActionCode="pd107"
	{
		s InventoryDR=""
		s val=""
		While reader.Next(.request,.sc)
		{
			s InventoryDR=request.InventoryDR
			s val=request.val
		}
		i InventoryDR=$C(0) s InventoryDR=""
		i val=$C(0) s val=""
		s result=##Class(web.DHCEQ.EM.BUSInventory).SaveInventoryList(InventoryDR,val)
		q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData><result>"_result_"</result></DirectorData></ResultList></Response>"
	}
    q "<Response><ResultCode>1</ResultCode><ResultDesc>代码未定义</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
}

/// add by zx 2016-07-30
/// 微信端获取xml格式数据
/// 入参为对应代码和参数mxl格式
ClassMethod GetWChatXML(ActionCode As %String = "", RequestXML As %String = "", CheckInfo As %String = "") As %XML.DataSet [ WebMethod ]
{
	s RequestXML=$TR(RequestXML,$C(10))
    s RequestXML=$TR(RequestXML,$C(0))
    ;Add By QW20160920 Permission
    s LogData=CheckInfo_"^"_ActionCode ;"006^1^85^102"_"^"_ActionCode
    s perminssion=##Class(web.DHCEQWChatUser).CallPermission(LogData)
    i ($P(perminssion,"^",1)="0") q "<Response><ResultCode>1</ResultCode><ResultDesc>No Permission</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
    ;End By QW20160920 Permission
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(RequestXML)
    d reader.Correlate("Request","web.DHCEQ.Interface.Inner.DHCEQWChatProperty")
	
	/*******************维修列表***************************/
	i ActionCode="0005"
	{
		s Status=""
		s RequestLocDR="" 
		s ApproveRole=""
		s WaitAD=""
		s LocFlag=""
		s CurGroupID=""
		s CurUser=""
	   	While reader.Next(.request,.sc)
		{
		   s Status=request.Status
		   s RequestLocDR=request.RequestLocDR
		   s ApproveRole=request.ApproveRole
		   s WaitAD=request.WaitAD	
		   s LocFlag=request.LocFlag
		   s CurGroupID=request.CurGroupID	
		   s CurUser=request.CurUser
		}
		i Status=$C(0) s Status=""
		i RequestLocDR=$c(0) s RequestLocDR=""
		i ApproveRole=$c(0) s ApproveRole=""
		i WaitAD=$c(0) s WaitAD=""
		i LocFlag=$c(0) s LocFlag=""
		i CurGroupID=$c(0) s CurGroupID=""
		i CurUser=$c(0) s CurUser=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest")
		Do result.SetArgs(Status,"","","","",ApproveRole,WaitAD,"","","N","","",CurGroupID,CurUser,"^Action=^SubFlag=1")
		
		Quit result
	}
	/*******************维修待办列表***************************/
	i ActionCode="0025"
	{
		s BussType=""
		s GroupID=""
		s UserID=""
		s LocID=""
        s action=""
	   	While reader.Next(.request,.sc)
		{
		   s BussType=request.BussType
		   s GroupID=request.GroupID
		   s UserID=request.UserID	
		   s LocID=request.LocID
           s action=request.action
		}
		i BussType=$C(0) s BussType=""
		i GroupID=$C(0) s GroupID=""
		i UserID=$C(0) s UserID=""
        i LocID=$C(0) s LocID=""
        i action=$C(0) s action=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.LIBMessages:GetBussDataByCode")
		Do result.SetArgs(BussType,GroupID,UserID,LocID,"","","","","","","","","")
		
		Quit result
	}
	/*******************紧急程度***************************/
	i ActionCode="0026"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCEmergencyLevel:EmergencyLevel")
		Do result.SetArgs("","","","")
		
		Quit result
	}
	/*******************人员列表***************************/
	i ActionCode="0027"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQFind:EQUser")
		Do result.SetArgs("",mInput,"","")  //,""
		
		Quit result
	}
	/*******************故障类型***************************/
	i ActionCode="0028"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCFaultType:FaultType")
		Do result.SetArgs("","","")
		
		Quit result
	}
	/*******************故障原因***************************/
	i ActionCode="0029"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCFaultReason:Faultreason")
		Do result.SetArgs("",mInput,"")
		
		Quit result
	}
	/*******************解决方法***************************/
	i ActionCode="0030"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCDealMethod:DealMethod")
		Do result.SetArgs("",mInput,"")
		
		Quit result
	}
	/*******************维修方式***************************/
	i ActionCode="0031"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCMaintMode:MaintMode")
		Do result.SetArgs("","","3","")
		
		Quit result
	}
	/*******************待办业务列表***************************/
	i ActionCode="0032"
	{
		s MeunType=""
		s GroupID=""
		s UserID=""
	   	While reader.Next(.request,.sc)
		{
		   s MeunType=request.MeunType
		   s GroupID=request.GroupID
		   s UserID=request.UserID
		}
		i MeunType=$C(0) s MeunType=""
		i GroupID=$C(0) s GroupID=""
		i UserID=$C(0) s UserID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCRoleBuss:GetBussByRole")
		Do result.SetArgs(MeunType,GroupID,UserID)
		
		Quit result
	}
	/*******************故障现象***************************/
	i ActionCode="0033"   //Add By QW20160810
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCFaultCase:FaultCase")
		Do result.SetArgs("","","")
		
		Quit result
	}
	/*******************获取可转向步奏 ***************************/
	i ActionCode="0036"
	{
		s vSourceID=""
		s CurRoleID=""
		s ApproveTypeCode=""
		s Type=""
		s CurStep=""
		s action=""  //add by zx 2017-06-20 BUG ZX0038
		while reader.Next(.request,.sc)
		{
			s vSourceID=request.vSourceID
			s CurRoleID=request.CurRoleID
			s ApproveTypeCode=request.ApproveTypeCode
			s Type=request.Type
			s CurStep=request.CurStep
			s action=request.action
		}
		i vSourceID=$c(0) s vSourceID=""
		i CurRoleID=$c(0) s CurRoleID=""
		i ApproveTypeCode=$c(0) s ApproveTypeCode=""
		i Type=$c(0) s Type=""
		i CurStep=$c(0) s CurStep=""
		i action=$c(0) s action=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCApproveFlow:GetUserApprovesForPDA")
		Do result.SetArgs(vSourceID,CurRoleID,ApproveTypeCode,Type,CurStep,action)
		
		Quit result
	}
	/*******************严重程度***************************/
	i ActionCode="0038"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCSeverityLevel:SeverityLevel")
		Do result.SetArgs("","","","")
		
		Quit result
	}
	/*******************维修个人列表***************************/
	//add by zx 2016-12-08
	i ActionCode="0039"
	{
		s StartDate=""
		s EndDate=""
		s CurUser=""
		s Name=""
		s RequestLocDR=""
		s FinishFlag=""
		s LeaderFlag=""
		s LocID=""
		s AcceptUser=""
		s action=""
		s CTLocID=""
		s CurGroupID=""
	   	While reader.Next(.request,.sc)
		{
		   s StartDate=request.StartDate
		   s EndDate=request.EndDate	
		   s CurUser=request.CurUser
		   s Name=request.Name
		   s RequestLocDR=request.RequestLocDR	
		   s FinishFlag=request.FinishFlag
		   s LeaderFlag=request.LeaderFlag
		   s LocID=request.LocID
		   s AcceptUser=request.AcceptUser	
		   s action=request.action	
		   s CTLocID=request.CTLocID	
		   s CurGroupID=request.CurGroupID	
		}
		i StartDate=$c(0) s StartDate=""
		i EndDate=$c(0) s EndDate=""
		i CurUser=$c(0) s CurUser=""
		i Name=$c(0) s Name=""
		i RequestLocDR=$c(0) s RequestLocDR=""
		i FinishFlag=$c(0) s FinishFlag=""
		i LeaderFlag=$c(0) s LeaderFlag=""
		i LocID=$c(0) s LocID=""
		i AcceptUser=$c(0) s AcceptUser=""
		i action=$c(0) s action=""
		i CTLocID=$C(0) s CTLocID=""
		i CurGroupID=$C(0) s CurGroupID=""
		i StartDate'="" s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")  ;Modified by QW20170302日期格式统一调整
		i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  ;Modified by QW20170302日期格式统一调整
		//Modify by zx 2020-11-23 调用query参数调整
		//Modify by wy 2022-6-13 调用query参数调整vCurGroupID
		s vData="^vCurGroupID="_CurGroupID_"^^^^^FinishStartDate=^FinishEndDate="
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetail")
		
		;Do result.SetArgs("","","111","","","0","","N","","","","2")
		;Do result.SetArgs("","",RequestLocDR,64733,65098,"0","","N","","","",2,3810,"",957,85,action)  //add by zx 2016-11-25 个人单据bug修复
		Do result.SetArgs("",RequestLocDR,StartDate,EndDate,"0","","N",AcceptUser,CurUser,Name,FinishFlag,LeaderFlag,LocID,CTLocID,vData)
		Quit result
	}
	/*******************服务商***************************/
	i ActionCode="0040"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCService:LookUp")
		Do result.SetArgs(mInput)
		
		Quit result
	}
	/*******************维修结果***************************/
	i ActionCode="0041"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCMaintResults:LookUp")
		Do result.SetArgs("")
		
		Quit result
	}
	/*******************获取安全组登陆科室 ***************************/
	i ActionCode="0043"
	{
		s UserID=""
		while reader.Next(.request,.sc)
		{
			s UserID=request.UserID
		}
		i UserID=$c(0) s UserID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCommon:LogonLocGrp")
		Do result.SetArgs(UserID)
		Quit result
	}
	/*******************消息获取***************************/
	i ActionCode="0047"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQMessages:GetBussDataForWChat")
		Do result.SetArgs("")
		
		Quit result
	}
		/*******************获取维修图片信息***********************/
	i ActionCode="0023"
	{		
		s SourceType=""
		s SourceID=""
		s PLID=""	
	   	While reader.Next(.request,.sc)
		{
		   s SourceType=request.vSourceType
		   s SourceID=request.vSourceID
		   s PLID=request.PLID	
		}
		if SourceType=$C(0) set SourceType=""
		if SourceID=$C(0) set SourceID=""
		if PLID=$C(0) set PLID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQ.Process.DHCEQPictureList:GetPictureListInfo")
		Do result.SetArgs(SourceType,SourceID,PLID)
		Quit result
	}
	/*******************维修人员信息***************************/
	i ActionCode="0049"
	{
		s mInput=""
		s UserID=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		   s UserID=request.UserID	
		}
		if mInput=$C(0) set mInput=""
		if UserID=$C(0) set UserID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQMCMaintGroupList:GetMaintGroupList")
		Do result.SetArgs(mInput,"","",UserID)
		
		Quit result
	}
	/*******************维修单配件列表信息***************************/
	i ActionCode="0053"
	{
		s MaintID=""
		s MaintItemDR=""
		s UserID=""
	   	While reader.Next(.request,.sc)
		{
		   s MaintID=request.MaintID
		   s MaintItemDR=request.MaintItemDR
		   s UserID=request.UserID
		}
		i MaintID=$C(0) s MaintID=""
		i MaintItemDR=$C(0) s MaintItemDR=""
		i UserID=$C(0) s UserID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintPart:MaintPart")
		Do result.SetArgs(MaintID,MaintItemDR,UserID)
		
		Quit result
	}
	
	/*******************生产厂商***************************/
	i ActionCode="0054"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCManufacturer:LookUp")
		Do result.SetArgs(mInput)
		Quit result
	}
	/*******************供应商***************************/
	i ActionCode="0055"
	{
		s mInput=""
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		}
		i mInput=$C(0) s mInput=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCVendor:GetVendor")
		Do result.SetArgs(mInput)
		Quit result
	}
	/*******************配件类组***************************/
	i ActionCode="0056"
	{
		s GroupID=""
		s LocID=""			//modified by czf 202001012 begin
	   	While reader.Next(.request,.sc)
		{
		   s GroupID=request.GroupID
		   s LocID=request.LocID
		}
		i GroupID=$C(0) s GroupID=""
		i LocID=$C(0) s LocID=""
		Set AccessoryInputType=##class(web.DHCEQCommon).GetSysInfo("503006")
		i AccessoryInputType="DHC-STM" d
		.Set result=##class(%XML.DataSet).%New("web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets:GetAccessoryType")
		.Do result.SetArgs(LocID,"")
		e  d
		.Set result=##class(%XML.DataSet).%New("web.DHCEQFind:GetAccessoryType")	//modified by czf 202001012 end
		.Do result.SetArgs("",GroupID)
		Quit result
	}
	/*******************配件项列表信息***************************/
	i ActionCode="0057"
	{
		s mInput=""
		s AccessoryTypeDR=""
		s GroupID=""
		s LocID=""		//modified by czf 2020-10-12 begin
	   	While reader.Next(.request,.sc)
		{
		   s mInput=request.mInput
		   s AccessoryTypeDR=request.AccessoryTypeDR
		   s GroupID=request.GroupID
		}
		i mInput=$C(0) s mInput=""
		i AccessoryTypeDR=$C(0) s AccessoryTypeDR=""
		i GroupID=$C(0) s GroupID=""
		//add by zx 2019-11-17
		//Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMaintForService:GetAStockDetail")
		//Do result.SetArgs("","485",AccessoryTypeDR,mInput,"false","2","","")
		//web.DHCEQ.MP.BUSAccessory
		Set AccessoryInputType=##class(web.DHCEQCommon).GetSysInfo("503006")	//配件录入方式
		i AccessoryInputType="DHC-STM" d
		.Set result=##class(%XML.DataSet).%New("web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets:GetAccessoryList")
		.Do result.SetArgs("",mInput,"",AccessoryTypeDR)
		e  d
		.Set result=##class(%XML.DataSet).%New("web.DHCEQ.MP.BUSAccessory:GetAccessoryList")
		.Do result.SetArgs(mInput,AccessoryTypeDR,GroupID)	//modified by czf 2020-10-12 end
		Quit result
  }
  /**********************租赁设备信息**************************/
   i ActionCode="0061"
   {
	   s TDesc=""
	   s TLocDR=""
	   s TItemDR=""
	   While reader.Next(.request,.sc)
	   {
		   s TDesc=request.TDesc
		   s TLocDR=request.TLocDR
		   s TItemDR=request.TItemDR
	   }
	   i TDesc=$C(0) s TDesc=""
	   i TLocDR=$C(0) s TLocDR=""
	   i TItemDR=$C(0) s TItemDR=""
	   Set result=##class(%XML.DataSet).%New("web.DHCEQEquipRent:GetEquipRentByEquipForWechat")
	   Do result.SetArgs(TDesc,TLocDR,TItemDR)
	   Quit result
   }
   /*********************租赁设备项************************/
   i ActionCode="0062"
   {
	   s TDesc=""
	   s TLocDR=""
	   While reader.Next(.request,.sc)
	   {
		   s TDesc=request.TDesc
		   s TLocDR=request.TLocDR
	   }
	   i TDesc=$C(0) s TDesc=""
	   i TLocDR=$C(0) s TLocDR=""
	   Set result=##class(%XML.DataSet).%New("web.DHCEQEquipRent:GetEquipRentByItemForWechat")
	   Do result.SetArgs(TDesc,TLocDR)
	   Quit result
   }
 /*********************租赁单据列表************************/
   i ActionCode="0067"
   {
	   s QXType=""
	   s vQXType=""
	   s Type=""
	   s TItemDR=""
	   s Status=""
	   s ApproveRole=""
	   s action=""
	   s Equipdr=""
	   s UserID=""
	   
	   While reader.Next(.request,.sc)
	   {
		   s QXType=request.QXType
		   s vQXType=request.vQXType
		   s Type=request.Type
		   s TItemDR=request.TItemDR
		   s Status=request.Status
		   s ApproveRole=request.ApproveRole
		   s action=request.action
		   s Equipdr=request.Equipdr
		   s UserID=request.UserID
	   }
	   i QXType=$C(0) s QXType=""
	   i vQXType=$C(0) s vQXType=""
	   i Type=$C(0) s Type=""
	   i TItemDR=$C(0) s TItemDR=""
	   i Status=$C(0) s Status=""
	   i ApproveRole=$C(0) s ApproveRole=""
	   i action=$C(0) s action=""
	   i Equipdr=$C(0) s Equipdr=""
	   i UserID=$C(0) s UserID=""
	   Set result = ##class(%XML.DataSet).%New("web.DHCEQRent:GetRentList")
	   ;s ^DHCEQMozy(1)=QXType_"^"_vQXType_"^"_Type_"^"_""_"^"_""_"^"_TItemDR_"^"_Status_"^"_""_"^"_""_"^"_""_"^"_""_"^"_ApproveRole_"^"_action_"^"_Equipdr_"^"_""_"^"_UserID
	   Do result.SetArgs(QXType,vQXType,Type,"","",TItemDR,Status,"","","","",ApproveRole,action,Equipdr,"",UserID)
	   Quit result
   }
   /*******************获取主界面菜单信息***************************/
	i ActionCode="0069"
	{
		s GroupID=""
		s UserID=""
		s LocID=""
		While reader.Next(.request,.sc)
		{
			s GroupID=request.GroupID
			s UserID=request.UserID
			s LocID=request.LocID
		}
		i GroupID=$C(0) s GroupID=""
		i UserID=$C(0) s UserID=""
		i LocID=$C(0) s LocID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQCSysGroupMenu:GetGroupMenus")
		Do result.SetArgs(GroupID,UserID,"WeChat",LocID)
		Quit result
	}
	/*******************获取审批进度信息***************************/
	i ActionCode="0070"
	{
		s TSourceType=""
		s TSourceID=""
		While reader.Next(.request,.sc)
		{
			s TSourceType=request.TSourceType
			s TSourceID=request.TSourceID
		}
		i TSourceType=$C(0) s TSourceType=""
		i TSourceID=$C(0) s TSourceID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQMessages:GetApproveList")
		Do result.SetArgs(TSourceType,TSourceID)
		Quit result
	}
	/*******************获取维修对象列表***************************/
	i ActionCode="0071"
	{
		s mInput=""
		s LocID=""
		s GroupID=""
		s UserID=""
        s Type=""
        s TLocDR=""
        s QXType=""
        s TDesc=""  //Modify by zx 2021-11-15
		While reader.Next(.request,.sc)
		{
			s mInput=request.mInput
			s LocID=request.LocID
			s GroupID=request.GroupID
			s UserID=request.UserID
            s Type=request.Type
            s TLocDR=request.TLocDR
            s QXType=request.QXType
            s TDesc=request.TDesc  //Modify by zx 2021-11-15 规格型号描述查询
		}
		i mInput=$C(0) s mInput=""
		i LocID=$C(0) s LocID=""
		i GroupID=$C(0) s GroupID=""
		i UserID=$C(0) s UserID=""
        i Type=$C(0) s Type=""
        i TLocDR=$C(0) s TLocDR=""
        i QXType=$C(0) s QXType=""
        i TDesc=$C(0) s TDesc=""
        
        s vData="SSLocID="_LocID_"^"_"SSGroupID="_GroupID_"^"_"SSUserID="_UserID   //add by wy 2022-4-14 入参名称修改 
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSEquip:GetShortEquip")
        Do result.SetArgs(mInput,TLocDR,"","","",QXType,"","","","",Type,"^"_TDesc,"","","",vData)  //Modify by zx 2021-11-15
		Quit result
	}
	/*******************获取业务单据预警统计***************************/
	i ActionCode="0072"
	{
		s BussType=""
		s QXType=""
		s LocID=""
		s CurGroupID=""
		s LeaderFlag=""
		s CurUser=""
		While reader.Next(.request,.sc)
		{
			s BussType=request.BussType
			s QXType=request.QXType
			s LocID=request.LocID
			s CurGroupID=request.CurGroupID
			s LeaderFlag=request.LeaderFlag
			s CurUser=request.CurUser
		}
		i BussType=$C(0) s BussType=""
		i QXType=$C(0) s QXType=""
		i LocID=$C(0) s LocID=""
		i CurGroupID=$C(0) s CurGroupID=""
		i LeaderFlag=$C(0) s LeaderFlag=""
		i CurUser=$C(0) s CurUser=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQPrescription:GetBussPrcSum")
		Do result.SetArgs(BussType,QXType,LocID,CurGroupID,LeaderFlag,CurUser)
		Quit result
	}
	/*******************获取业务单据预警明细***************************/
	i ActionCode="0073"
	{
		s BussType=""
		s QXType=""
		s LocID=""
		s CurGroupID=""
		s LeaderFlag=""
		s CurUser=""
		While reader.Next(.request,.sc)
		{
			s BussType=request.BussType
			s QXType=request.QXType
			s LocID=request.LocID
			s CurGroupID=request.CurGroupID
			s LeaderFlag=request.LeaderFlag
			s CurUser=request.CurUser
		}
		i BussType=$C(0) s BussType=""
		i QXType=$C(0) s QXType=""
		i LocID=$C(0) s LocID=""
		i CurGroupID=$C(0) s CurGroupID=""
		i LeaderFlag=$C(0) s LeaderFlag=""
		i CurUser=$C(0) s CurUser=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQPrescription:GetBussPrcDetail")
		Do result.SetArgs(BussType,QXType,LocID,CurGroupID,LeaderFlag,CurUser)
		Quit result
	}
	/*******************维修进度***************************/
	i ActionCode="0074"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCMaintProcess:LookUp")
		Do result.SetArgs("")
		Quit result
	}
	/*******************消息通知***************************/
	i ActionCode="0076"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMaintForService:WeChatNotice")
		Do result.SetArgs("")
		Quit result
	}
    /*******************获取评价明细列表***************************/
    i ActionCode="0091"
    {
        s TRowID=""
        s vSourceType=""
        s vSourceID=""
        s CurRoleID=""
        s action=""
        s ApproveSetDR=""
        While reader.Next(.request,.sc)
        {
            s TRowID=request.TRowID
            s vSourceType=request.vSourceType
            s vSourceID=request.vSourceID
            s CurRoleID=request.CurRoleID
            s action=request.action
            s ApproveSetDR=request.ApproveSetDR
        }
        i TRowID=$C(0) s TRowID=""
        i vSourceType=$C(0) s vSourceType=""
        i vSourceID=$C(0) s vSourceID=""
        i CurRoleID=$C(0) s CurRoleID=""
        i action=$C(0) s action=""
        i ApproveSetDR=$C(0) s ApproveSetDR=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQEvaluate:EvaluateDetail")
        Do result.SetArgs(TRowID,vSourceType,vSourceID,CurRoleID,action,ApproveSetDR)
        Quit result
    }
    /*******************获取评价业务数据列表***************************/
    i ActionCode="0092"
    {
        s BussType=""
        s QXType=""
        s LocID=""
        s CurGroupID=""
        s CurUser=""
        s FinishFlag=""
        s LeaderFlag=""
        While reader.Next(.request,.sc)
        {
            s BussType=request.BussType
            s QXType=request.QXType
            s LocID=request.LocID
            s CurGroupID=request.CurGroupID
            s CurUser=request.CurUser
            s FinishFlag=request.FinishFlag
            s LeaderFlag=request.LeaderFlag
        }
        i BussType=$C(0) s BussType=""
        i QXType=$C(0) s QXType=""
        i LocID=$C(0) s LocID=""
        i CurGroupID=$C(0) s CurGroupID=""
        i CurUser=$C(0) s CurUser=""
        i FinishFlag=$C(0) s FinishFlag=""
        i LeaderFlag=$C(0) s LeaderFlag=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQEvaluate:GetBussEvaluate")
        Do result.SetArgs(BussType,QXType,LocID,CurGroupID,CurUser,FinishFlag,LeaderFlag)
        Quit result
    }
    /*******************获取设备待办业务明细***************************/
    i ActionCode="0099"
    {
        s BussType=""
        s GroupID=""
        s UserID=""
        s LocID=""
        s EQRowID=""
        While reader.Next(.request,.sc)
        {
            s BussType=request.BussType
            s GroupID=request.GroupID
            s UserID=request.UserID
            s LocID=request.LocID
            s EQRowID=request.EQRowID
        }
        i EQRowID=$C(0) s EQRowID=""
        i GroupID=$C(0) s GroupID=""
        i UserID=$C(0) s UserID=""
        i LocID=$C(0) s LocID=""
        i BussType=$C(0) s BussType=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.LIBMessages:GetBussDataByCode")
        Do result.SetArgs(BussType,GroupID,UserID,LocID,EQRowID,"","","","","","","","")
        Quit result
    }
    /*******************参与维修人员信息 Modify by zx 2021-09-01***********************/
    i ActionCode="0108"
    {
        s vSourceType=""
        s vSourceID=""
        While reader.Next(.request,.sc)
        {
            s vSourceType=request.vSourceType
            s vSourceID=request.vSourceID
        }
        i vSourceType=$C(0) s vSourceType=""
        i vSourceID=$C(0) s vSourceID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQMaintUserList:GetMaintUserList")
        Do result.SetArgs(vSourceType,vSourceID)
        Quit result
    }
	///Add By QW20200108 BUG:QW0035 Begin query统一调用
    i ActionCode="2999"
    {
	    s classname=""
	    s queryname=""
	    s queryparas=""
        While reader.Next(.request,.sc)
        {
            s classname=request.classname
            s queryname=request.queryname
            s queryparas=request.queryparas
        }
        i classname=$C(0) s classname=""
        i queryname=$C(0) s queryname=""
        i queryparas=$C(0) s queryparas=""
		s WchatLogID=$P(perminssion,"^",2)
		i WchatLogID'="" &SQL(UpDate SQLUSER.DHC_EQWChatLog Set WCL_ClassName=:classname,WCL_MethodName=:queryname where WCL_RowID=:WchatLogID)
		if (classname=""||queryname="")
		{
			q "<Response><ResultCode>-1</ResultCode><ResultDesc>代码未定义</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
		}
		else
		{
			s result=##class(web.DHCEQWChatUser).GetQueryResult(classname,queryname,queryparas)
        	Quit result
		}
	}
	///Add By QW20200108 BUG:QW0035 End query统一调用
    /*******************获取设备待办业务明细***************************/
    i ActionCode="pd203"
    {
        s InventoryDR=""
        s mInput=""
        While reader.Next(.request,.sc)
        {
            s InventoryDR=request.InventoryDR
            s mInput=request.mInput
        }
        i InventoryDR=$C(0) s InventoryDR=""
        i mInput=$C(0) s mInput=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetInventoryLoc")
        Do result.SetArgs(InventoryDR,mInput)
        Quit result
    }
     i ActionCode="pd201"
     {
	    s StartDate=""
        s EndDate=""
        s InventoryNo=""
        s QXType=""
        s Status=""
        s ReadOnly=""
        s CTLocID=""
        s CurGroupID=""
        s CurHospID=""
        While reader.Next(.request,.sc)
        {
		    s StartDate=request.StartDate
	        s EndDate=request.EndDate
	        s InventoryNo=request.InventoryNo
	        s QXType=request.QXType
	        s Status=request.Status
	        s ReadOnly=request.ReadOnly
	        s CTLocID=request.CTLocID
	        s CurGroupID=request.CurGroupID
	        s CurHospID=request.CurHospID
        }
        i StartDate=$C(0) s StartDate=""
        i EndDate=$C(0) s EndDate=""
        i InventoryNo=$C(0) s InventoryNo=""
        i QXType=$C(0) s QXType=""
        i Status=$C(0) s Status=""
        i ReadOnly=$C(0) s ReadOnly=""
        i CTLocID=$C(0) s CTLocID=""
        i CurGroupID=$C(0) s CurGroupID=""
        i (CurHospID=$C(0))||(CurHospID="null") s CurHospID=""
        s StoreLocDR=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryInventory")
        Do result.SetArgs(StartDate, EndDate, InventoryNo, QXType, Status, ReadOnly,CurHospID, StoreLocDR,CurGroupID, CTLocID)
        Quit result
	 }
	 
	 /*******************获取盘点明细结果列表***************************/
	//add by zc 20181128 zc0046
	i ActionCode="pd202"
    {
        s InventoryDR=""
        s InventoryLocDR=""
		s differStatu=""
		s ManageLocFlag=""
		s CTLocID=""
		s CurGroupID=""
        s CurHospID=""
        s InvalidFlag=""
        s EquipTypeDR=""
        s EquipNo=""
        s Model=""
        While reader.Next(.request,.sc)
        {
            s InventoryDR=request.InventoryDR
            s InventoryLocDR=request.InventoryLocDR
			s differStatu=request.differStatu
			s ManageLocFlag=request.ManageLocFlag
			s CTLocID=request.CTLocID
			s CurGroupID=request.CurGroupID
	        s CurHospID=request.CurHospID
	        s InvalidFlag=request.InvalidFlag
	        s EquipTypeDR=request.EquipTypeDR
	        s EquipNo=request.EquipNo
	        s Model=request.Model
        }
        i InventoryDR=$C(0) s InventoryDR=""
        i InventoryLocDR=$C(0) s InventoryLocDR=""
		i differStatu=$C(0) s differStatu=""
		i ManageLocFlag=$C(0) s ManageLocFlag=""
		i CTLocID=$C(0) s CTLocID=""
		i CurGroupID=$C(0) s CurGroupID=""
        i CurHospID=$C(0) s CurHospID=""
        i InvalidFlag=$C(0) s InvalidFlag=""
        i EquipTypeDR=$C(0) s EquipTypeDR=""
        i EquipNo=$C(0) s EquipNo=""
        i Model=$C(0) s Model=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetInventoryDiffer")
        Do result.SetArgs(InventoryDR,InventoryLocDR,differStatu,ManageLocFlag,CTLocID, CurGroupID, CurHospID, InvalidFlag,EquipTypeDR,EquipNo,Model)
        Quit result
    }
    i ActionCode="0090"
    {
        Set result=##class(%XML.DataSet).%New("web.DHCEQMessageSendInfo:GetMSIDetail")
        Do result.SetArgs("1","1")
        Quit result
    }
     /*******************基础数据查询***************************/
    i ActionCode="BC201"
    {
	    s TableName=""
        s mInput=""
        
        While reader.Next(.request,.sc)
        {
	        s TableName=request.TableName
            s mInput=request.mInput
            
        }
        i TableName=$C(0) s TableName=""
        i mInput=$C(0) s mInput=""
        
        Set result=##class(%XML.DataSet).%New("web.DHCEQWChatBaseCode:GetBaseCodeByTable")
        Do result.SetArgs(TableName,mInput)
        Quit result
    }
    /*******************维修个人跟踪列表***************************/
	//add by zx 2016-12-08
	i ActionCode="Maint201"
	{
		s StartDate=""
		s EndDate=""
		s CurUser=""
		s FinishFlag=""
		s AcceptUser=""
		s CTLocID=""
		s CurGroupID=""
	   	While reader.Next(.request,.sc)
		{
		   s StartDate=request.StartDate
		   s EndDate=request.EndDate	
		   s CurUser=request.CurUser
		   s FinishFlag=request.FinishFlag
		   s AcceptUser=request.AcceptUser	
		   s CTLocID=request.CTLocID	
		   s CurGroupID=request.CurGroupID	
		}
		i StartDate=$c(0) s StartDate=""
		i EndDate=$c(0) s EndDate=""
		i CurUser=$c(0) s CurUser=""
		i FinishFlag=$c(0) s FinishFlag=""
		i AcceptUser=$c(0) s AcceptUser=""
		i CTLocID=$C(0) s CTLocID=""
		i CurGroupID=$C(0) s CurGroupID=""
		i StartDate'="" s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")  ;Modified by QW20170302日期格式统一调整
		i EndDate'="" s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  ;Modified by QW20170302日期格式统一调整
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetailByUser")
		;StartDate, EndDate, QXType, AcceptUserDR, CurUser As %String = "", FinishFlag As %String = "", CurLocID As %String = "", CurGroupID
		Do result.SetArgs(StartDate,EndDate,"0",AcceptUser,CurUser,CTLocID,CurGroupID)  //add by zx 2016-11-25 个人单据bug修复
		
		Quit result
	}
    /*******************维修历史记录***************************/
    i ActionCode="Maint202"
	{
		s EQRowID=""
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		}
		i EQRowID=$c(0) s EQRowID=""
		
		Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestHiStory")
		Do result.SetArgs(EQRowID)  //add by zx 2016-11-25 个人单据bug修复
		
		Quit result
	}
	 /*******************文件资料***************************/
    i ActionCode="file201"
	{
		s EQRowID=""
	   	While reader.Next(.request,.sc)
		{
		   s EQRowID=request.EQRowID
		}
		i EQRowID=$c(0) s EQRowID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.CTProduct:GetProductAppendFile")
		Do result.SetArgs(EQRowID)  
		
		Quit result
	}
	/*******************获取设备相关图片***************************/
    i ActionCode="pic201"
    {
        s EQRowID=""
        While reader.Next(.request,.sc)
        {
            s EQRowID=request.EQRowID
        }
        i EQRowID=$C(0) s EQRowID=""
      
        //获取可访问图片类型
        s PicTypeDRs=""
		s PicTypeDR=0
		f  s PicTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex","52",PicTypeDR))  q:PicTypeDR=""  d
		.s PSTRowID=0
		.f  s PSTRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex","52",PicTypeDR,PSTRowID))  q:PSTRowID=""  d
		..s InvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",9)
		..q:InvalidFlag="Y"
		..i PicTypeDRs'=""  d
		...s PicTypeDRs=PicTypeDRs_","
		..s PicTypeDRs=PicTypeDRs_PicTypeDR
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.Process.DHCEQPicture:GetPictureList")
        Do result.SetArgs("52",EQRowID,PicTypeDRs)
        Quit result
    }
    /*******************获取设备附件列表***************************/
    i ActionCode="aff201"
    {
        s EQRowID=""
        While reader.Next(.request,.sc)
        {
            s EQRowID=request.EQRowID
        }
        i EQRowID=$C(0) s EQRowID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQAffix:GetAffix")
        Do result.SetArgs(EQRowID)
        Quit result
    }
    /*******************设备台账数据查询***************************/
    i ActionCode="Eq201"
    {
        s mInput=""
        s LocID=""
        s Provider=""
		s CTLocID=""
		s CurGroupID=""
		s StartDate=""
		s EndDate=""
		s MaxValue=""
		s MinValue=""
		s UserID=""
		s QXType=""  //Modify by zx 2020-11-23 增加QXType处理
        While reader.Next(.request,.sc)
        {
            s mInput=request.mInput
            s LocID=request.LocID
            s Provider=request.Provider
	    	s CTLocID=request.CTLocID	
	    	s CurGroupID=request.CurGroupID
	    	s StartDate=request.StartDate
            s EndDate=request.EndDate
	    	s MaxValue=request.MaxValue	
	    	s MinValue=request.MinValue
	    	s UserID=request.UserID
	    	s QXType=request.QXType	
        }
		i mInput=$C(0) s mInput=""
        i LocID=$C(0) s LocID=""
        i Provider=$C(0) s Provider=""
		i CTLocID=$C(0) s CTLocID=""
		i CurGroupID=$C(0) s CurGroupID=""
		i StartDate=$C(0) s StartDate=""
        i EndDate=$c(0) s EndDate=""
		i MaxValue=$C(0) s MaxValue=""
		i MinValue=$C(0) s MinValue=""
		i UserID=$C(0) s UserID=""
		i QXType=$C(0) s QXType=""
		i StartDate'="" s StartDate=$zdh(StartDate,3)
		i EndDate'="" s EndDate=$zdh(EndDate,3)
		s vData="SSLocID="_LocID_"^"_"SSGroupID="_GroupID_"^"_"SSUserID="_UserID  //add by wy 2022-4-14 入参名称修改
        Set result=##class(%XML.DataSet).%New("web.DHCEQEquip:GetShortEquip")
        Do result.SetArgs(mInput,LocID,"","","",QXType,"","",Provider,"",vData,MaxValue,MinValue,StartDate,EndDate,"Y")
        Quit result
    }
    i ActionCode="0112"
    {
        s mInput=""
        s TSourceID=""
        While reader.Next(.request,.sc)
        {
            s mInput=request.mInput
            s TSourceID=request.TSourceID
        }
        i mInput=$C(0) s mInput=""
        i TSourceID=$C(0) s TSourceID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQTraining:GetOutMaintUserList")
        Do result.SetArgs(mInput,TSourceID)
        Quit result
    }

	/*******************获取科室列表信息***************************/
	i ActionCode="0089"
	{
		s mInput=""
		s UserID=""
		s GroupID=""
		s CurHosptailID=""
		While reader.Next(.request,.sc)
		{
			s mInput=request.mInput
			s UserID=request.UserID
			s GroupID=request.GroupID
			s CurHosptailID=request.CurHospID
		}
		i mInput=$C(0) s mInput=""
		i UserID=$C(0) s UserID=""
		i GroupID=$C(0) s GroupID=""
		i CurHosptailID=$C(0) s CurHosptailID=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQFind:GetEQLoc")
		Do result.SetArgs("",mInput,GroupID,"","",UserID,CurHosptailID,"")
		Quit result
	}
	/*******************add by zx 2019-11-07 获取转移明细列表***************************/
	i ActionCode="storemove201"
	{
		s rowid=""
		While reader.Next(.request,.sc)
		{
			s rowid=request.rowid
		}
		i rowid=$C(0) s rowid=""
		Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSStoreMove:GetStoreMoveList")
		Do result.SetArgs(rowid)
		Quit result
	}
	/*******************add by zx 2019-11-26 生命周期***************************/
    i ActionCode="Eq202"
    {
        s EQRowID=""
        s GroupID=""
        s LocID=""
        While reader.Next(.request,.sc)
        {
            s EQRowID=request.EQRowID
            s GroupID=request.GroupID
            s LocID=request.LocID
        }
        i EQRowID=$C(0) s EQRowID=""
        i GroupID=$C(0) s GroupID=""
        i LocID=$C(0) s LocID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSLifeInfo:LifeInfo")
        Do result.SetArgs(EQRowID,"","","","","","","",GroupID,LocID)
        Quit result
    }
    /*******************add by zx 2019-12-24 跟人单据信息跟踪***************************/
    i ActionCode="disuse201"
    {
        s BussType=""
        s StartDate=""
        s EndDate=""
        s CurUser=""
        While reader.Next(.request,.sc)
        {
            s BussType=request.BussType
            s StartDate=request.StartDate
            s EndDate=request.EndDate
            s CurUser=request.CurUser
        }
        i BussType=$C(0) s BussType=""
        i StartDate=$C(0) s StartDate=""
        i EndDate=$C(0) s EndDate=""
        i CurUser=$C(0) s CurUser=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.LIBMessages:GetDetailByMessages")
        Do result.SetArgs(BussType,StartDate,EndDate,CurUser)
        Quit result
    }
    /*******************add by zx 2020-06-30 ***************************/
    i ActionCode="pd204"
    {
	    s StartDate=""
        s EndDate=""
        s InventoryNo=""
        s QXType=""
        s Status=""
        s CurHospID=""
        s LocID=""
        s CTLocID=""
        s MRStatus=""
        While reader.Next(.request,.sc)
        {
            s StartDate=request.StartDate
            s EndDate=request.EndDate
            s InventoryNo=request.InventoryNo
            s QXType=request.QXType
            s Status=request.Status
            s CurHospID=request.CurHospID
            s LocID=request.LocID
            s CTLocID=request.CTLocID
            s MRStatus=request.MRStatus
        }
        i StartDate=$C(0) s StartDate=""
        i EndDate=$C(0) s EndDate=""
        i InventoryNo=$C(0) s InventoryNo=""
        i QXType=$C(0) s QXType=""
        i Status=$C(0) s Status=""
        i CurHospID=$C(0) s CurHospID=""
        i LocID=$C(0) s LocID=""
        i CTLocID=$C(0) s CTLocID=""
        i MRStatus=$C(0) s MRStatus=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSInventory:QueryInventory")
        Do result.SetArgs(StartDate,EndDate,InventoryNo,QXType,Status,CurHospID,LocID,CTLocID,MRStatus)
        Quit result
    }
    /*******************add by zx 2020-07-09 ***************************/
    i ActionCode="pd205"
    {
        s InventoryDR=""
        s LocID=""
        While reader.Next(.request,.sc)
        {
            s InventoryDR=request.InventoryDR
            s LocID=request.LocID
        }
        i InventoryDR=$C(0) s InventoryDR=""
        i LocID=$C(0) s LocID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSInventory:InventoryAudit")
        Do result.SetArgs(InventoryDR,LocID)
        Quit result
    }
	/*******************使用记录列表 Modify by zx 2020-09-01***************************/
	i ActionCode="jl201"
	{	
    	s EquipNo=""
    	s LocID=""
    	s UserID=""
    	s GroupID=""
    	While reader.Next(.request,.sc)
    	{
        		s EquipNo=request.EquipNo
        		s LocID=request.LocID
        		s UserID=request.UserID
        		s GroupID=request.GroupID
    	}
    	i EquipNo=$C(0) s EquipNo=""
    	i LocID=$C(0) s LocID=""
    	i UserID=$C(0) s UserID=""
    	i GroupID=$C(0) s GroupID=""
    	
    	Set result=##class(%XML.DataSet).%New("web.DHCEQStateInfo:GetStateInfo")
    	Do result.SetArgs("",EquipNo,"","","",LocID,UserID,"","",GroupID)
    	Quit result
	}
	/*******************add by zx 2019-06-27 获取模板内容明细***************************/
    i ActionCode="pm201"
    {
        s vSourceID=""
        s MaintID=""
        While reader.Next(.request,.sc)
        {
            s vSourceID=request.vSourceID
             s MaintID=request.MaintID
        }
        i vSourceID=$C(0) s vSourceID=""
        i MaintID=$C(0) s MaintID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.Code.DHCEQCPMTemplateList:PMTemplateList")
        Do result.SetArgs(vSourceID)
        Quit result
    }
    /*******************add by zx 2019-06-28 获取计划列表***************************/
    i ActionCode="pm202"
    {
        s BussType=""
        s mInput=""
        s EQRowID=""
        s LocID=""
        s GroupID=""
        While reader.Next(.request,.sc)
        {
            s BussType=request.BussType
            s mInput=request.mInput
            s EQRowID=request.EQRowID
            s LocID=request.LocID
            s GroupID=request.GroupID
        }
        i BussType=$C(0) s BussType=""
        i mInput=$C(0) s mInput=""
        i EQRowID=$C(0) s EQRowID=""
        i LocID=$C(0) s LocID=""
        i GroupID=$C(0) s GroupID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSMaintPlan:GetPlanName")
        Do result.SetArgs(BussType,mInput,EQRowID,"","",LocID,"","",GroupID)
        Quit result
    }
    /*******************add by zx 2019-06-28 获取执行计划列表***************************/
    i ActionCode="pm203"
    {
        s PTData=""
        s PLData=""
        s LocID=""
        s MaintID=""
        s EQRowID=""
        While reader.Next(.request,.sc)
        {
            s PTData=request.PTData
            s PLData=request.PLData
            s LocID=request.LocID
            s MaintID=request.MaintID
            s EQRowID=request.EQRowID
        }
        i PTData=$C(0) s PTData=""
        i PLData=$C(0) s PLData=""
        i LocID=$C(0) s LocID=""
        i MaintID=$C(0) s MaintID=""
        i EQRowID=$C(0) s EQRowID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSMaintPlan:GetPlanExecuteList")
        Do result.SetArgs(PTData,PLData,LocID,MaintID,EQRowID)
        Quit result
    }
    /*******************维修配件来源***************************/
	i ActionCode="0120"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.LIBFind:GetAccessoryOriginal")
		Do result.SetArgs("")
		Quit result
	}
    /*******************add by zx 2019-06-28 获取相关模板列表***************************/
    i ActionCode="pm204"
    {
        s Type=""
        s EQRowID=""
        While reader.Next(.request,.sc)
        {
            s Type=request.Type
            s EQRowID=request.EQRowID
        }
        i Type=$C(0) s Type=""
        i EQRowID=$C(0) s EQRowID=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.Code.DHCEQCPMTemplate:PMTemplateRange")
        Do result.SetArgs(Type,EQRowID)
        Quit result
    }
    /*******************add by zx 2019-06-28 保养方式***************************/
    i ActionCode="pm205"
    {
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.LIBFind:GetMaintMode")
        Do result.SetArgs("","1")
        Quit result
    }
    i ActionCode="PDA201"   //Add by QW20210907
    {
        s Type=""
        While reader.Next(.request,.sc)
        {
            s Type=request.Type
        }
        i Type=$C(0) s Type=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryPDABroadcast")
        Do result.SetArgs(Type)
        Quit result
    }
     /*******************来源类型***************************/
	i ActionCode="maintmove201"
	{
		Set result=##class(%XML.DataSet).%New("web.DHCEQMoveNew:GetFromDeptType")
		Do result.SetArgs()
		
		Quit result
	}
	/*******************add by zx 2022-07-30 盘盈理由***************************/
    i ActionCode="pd206"
    {
        s mInput=""
        While reader.Next(.request,.sc)
        {
            s mInput=request.mInput
        }
        i mInput=$C(0) s mInput=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSInventory:GetProfitReason")
        Do result.SetArgs(mInput)
        Quit result
    }
    /*******************add by zx 2022-07-30 盘亏理由***************************/
    i ActionCode="pd207"
    {
        s mInput=""
        While reader.Next(.request,.sc)
        {
            s mInput=request.mInput
        }
        i mInput=$C(0) s mInput=""
        Set result=##class(%XML.DataSet).%New("web.DHCEQ.EM.BUSInventory:GetLossReason")
        Do result.SetArgs(mInput)
        Quit result
    }
    
    i ActionCode="3000"   //Add by QW20220818 盘点图片复制 sftp 用到
    {
        s classname=""
	    s queryname=""
	    s queryparas=""
        While reader.Next(.request,.sc)
        {
            s classname=request.classname
            s queryname=request.queryname
            s queryparas=request.queryparas
        }
        i classname=$C(0) s classname=""
        i queryname=$C(0) s queryname=""
        i queryparas=$C(0) s queryparas=""
		s WchatLogID=$P(perminssion,"^",2)
		;i WchatLogID'="" &SQL(UpDate SQLUSER.DHC_EQWChatLog Set WCL_ClassName=:classname,WCL_MethodName=:queryname where WCL_RowID=:WchatLogID)
		if (classname=""||queryname="")
		{
			q "<Response><ResultCode>-1</ResultCode><ResultDesc>代码未定义</ResultDesc><ResultList><DirectorData></DirectorData></ResultList></Response>"
		}
		else
		{
			s result=##class(web.DHCEQWChatUser).GetQueryResult(classname,queryname,queryparas)
        	Quit result
		}
    }
}

}
