var ComponentName="DHCEQMMaintRequestSimple"; //add by zx 2016-05-18 
function BodyLoadHandler() 
{
	KeyUp("ExObj^RequestUser^ObjLoc^FaultCase^EmergencyLevel^SeverityLevel^Request^AcceptUser^FaultReason^DealMethod^Accessory^EvaluateType^FaultType^MaintMode^EquipStatus^MaintResults^MaintGroup","N");
	InitUserInfo();
	InitPage();
	var AssignDate=GetElementValue("AssignDate");
	if (Status=GetElementValue("Status")>0) ComponentName="DHCEQMMaintRequest"; //add by zx 2016-05-18 
	FillData();
	TotalFee_Change();
	SetEnabled();
	SetElementEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"),GetElementValue("Action"));
	InitApproveButton();
	SetFocus("ExObj");
	SetElement("SourceTypeDR","1"); //add by zx 2016-08-30
	Muilt_LookUp("ExObj^RequestUser^ObjLoc^FaultCase^EmergencyLevel^SeverityLevel^Request^AcceptUser^FaultReason^DealMethod^Accessory^EvaluateType^FaultType^MaintMode^EquipStatus^MaintResults^MaintGroup");
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iExObj");
	if (obj) obj.onclick=ExObj_Change;
	
	var obj=document.getElementById("ReturnFlag");
	if (obj) obj.onclick=Maint_Return;
	
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iMaintModeWay");
	if (obj) obj.onclick=Maint_Change;

  	var obj=document.getElementById("MaintDetail");
	if (obj) obj.onclick=BMaintDetail_Click;
	
	var obj=document.getElementById("MaintFee");		//Add By DJ 2014-09-23
	if (obj) obj.onchange=TotalFee_Change;
	
	var obj=document.getElementById("OtherFee");		//Add By DJ 2014-09-23
	if (obj) obj.onchange=TotalFee_Change;
	
	var obj=document.getElementById("BEvaluateDetail");		//Add By DJ 2014-09-23
	if (obj) obj.onclick=BEvaluateDetail_Click;
	
	var obj=document.getElementById("ExObj");
	if (obj) obj.onkeydown=ExObj_Change;
	var GetFaultCaseOperMethod=GetElementValue("GetFaultCaseOperMethod")  //Modefied by zc 2015-03-06 ZC0019 begin
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetFaultCaseOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iFaultCase").removeNode(true)
	}
	var obj=document.getElementById("MaintProcess");
	if (obj) obj.onchange=MaintProcess;         
	var obj=document.getElementById("InsurFlag");
	if (obj) obj.onchange=InsurFlag;          //Modefied by zc 2015-03-06 ZC0019 end
	var obj=document.getElementById("BEvaluate");	//Add By DJ 2015-08-28 DJ0159
	if (obj) obj.onclick=BEvaluate_Click;
	var obj=document.getElementById("BPicture");
	if (obj) obj.onclick=BPicture_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BEquipInfo");
	if (obj) obj.onclick=BEquipInfo_Click;
	
	var obj=document.getElementById("SourceType");  //add by zx 2016-08-30
	if (obj) obj.onchange=SourceType;

	var obj=document.getElementById("BMaintUser"); //add by zc 2018-03-19 zc0036
	if (obj) obj.onclick=BMaintUser_Click;
	
	//add by lmm 2017-11-22 begin 466969
	var GetFaultReasonOperMethod=GetElementValue("GetFaultReasonOperMethod")  
	if (GetFaultReasonOperMethod==1)    
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iFaultReason").removeNode(true)
	}
	//add by lmm 2017-11-22 end 466969
	//add by lmm 2017-11-22 begin 466980
	var GetDealMethodOperMethod=GetElementValue("GetDealMethodOperMethod")  
	if (GetDealMethodOperMethod==1)  
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iDealMethod").removeNode(true)
	}
	//add by lmm 2017-11-22 end 466980
	
	//add by lmm 2017-09-22 503001 begin
	var GetFaultTypeOperMethod=GetElementValue("GetFaultTypeOperMethod")
	if (GetFaultTypeOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iFaultType").removeNode(true)
	}
	//add by lmm 2017-09-22 503001 end
	
}
//Modefied by zc 2015-03-06 ZC0019
function InsurFlag()
{
	var RowID=GetElementValue("RowID");
	var obj=document.getElementById("InsurFlag")
	var encmeth=GetElementValue("UpdInsurFlag");
	if(obj.checked == true)
	{
		var Result=cspRunServerMethod(encmeth,RowID,"Y");
	}
	else
	{
		var Result=cspRunServerMethod(encmeth,RowID,"N");
	}
}
//Modefied by zc 2015-03-06 ZC0019
function MaintProcess()
{
	var RowID=GetElementValue("RowID");
	var MaintProcess=GetElementValue("MaintProcess");
	//alertShow(ManageTypeDR);
	var encmeth=GetElementValue("UpdMaintProcess");
	var Result=cspRunServerMethod(encmeth,RowID,MaintProcess);
}
function Maint_Change()
{
	var MaintMode=GetElementValue("MaintModeDR");
	if (MaintMode=="")
	{
		alertShow("请选择维修方式!");
		return;
	}
	else if (MaintMode==3) //保修合同
	{
		LookUp("","web.DHCEQM.DHCEQMMaintRequest:GetContract","GetContract","MaintModeWay");
	}
	else if (MaintMode==2) //服务商
	{
		LookUp("","web.DHCEQM.DHCEQMMaintRequest:GetService","GetService","MaintModeWay");
	}
	else  //维修科室
	{
		LookUpCTLoc("GetLoc","0,MaintModeWay,vgroupid,LocType");
	}
}

function Maint_Return()
{
	var obj=document.getElementById("ReturnFlag")
	if (obj.checked == true)
	{
		SetElementsReadOnly("MaintRequest",false);	
	}
	else 
	{	SetElementsReadOnly("MaintRequest",true);
		SetElement("MaintRequestDR","");
		SetElement("MaintRequest","");  
	}
}
function GetLoc(value)
{
	var list=value.split("^")
	SetElement('MaintModeWay',list[0]);
	SetElement('MaintModeWayDR',list[1]);
}
function GetContract(value)
{
	var list=value.split("^")
	SetElement('MaintModeWay',list[1]);
	SetElement('MaintModeWayDR',list[2]);
}
function GetService(value)
{
	var list=value.split("^")
	SetElement('MaintModeWay',list[2]);
	SetElement('MaintModeWayDR',list[1]);
}
function FillData()
{
	var obj=document.getElementById("RowID");
	if (obj) var RowID=obj.value;
	if (RowID=="") return;
	var Action=GetElementValue("Action"); //add by zx 2016-03-14 BugZX0035
	var Step=GetElementValue("RoleStep");
	var ApproveRoleDR=GetElementValue("ApproveRoleDR");
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID,ApproveRoleDR,Action,Step);	/// DJ 2016-04-19
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var plist=ReturnList.split("@");
	
	list=plist[0].split("^");
	var sort=76;
    SetElement("RequestNo",list[0]);
    SetElement("ManageTypeDR",list[1]); 
    SetElement("ManageType",list[sort+0]);
    SetElement("EquipTypeDR",list[2]);
    SetElement("EquipType",list[sort+1]);
    SetElement("ObjTypeDR",list[3]); 
    SetElement("ObjType",list[sort+2]);
    SetElement("ExObjDR",list[4]); 
    SetContratByEquip(list[4]); //Modefied by zc 2015-03-06 ZC0019
    SetElement("ExObj",list[sort+3]);
    SetElement("ObjLocDR",list[5]);
    SetElement("ObjLoc",list[sort+4]);
    SetElement("RequestLocDR",list[6]); 
    SetElement("RequestLoc",list[sort+5]);
    SetElement("StartDate",list[7]); 
    SetElement("StartTime",list[8]);  
    SetElement("FaultCaseDR",list[9]); 
    SetElement("FaultCase",list[sort+6]);
    SetElement("FaultCaseRemark",list[10]);  
    SetElement("FaultReasonDR",list[11]); 
    SetElement("FaultReason",list[sort+7]);
    SetElement("FaultReasonRemark",list[12]); 
    SetElement("DealMethodDR",list[13]);   
    SetElement("DealMethod",list[sort+8]);
    SetElement("DealMethodRemark",list[14]); 
    SetElement("EndDate",list[15]); 
    SetElement("EndTime",list[16]);  
    SetElement("RequestDate",list[17]); 
    SetElement("RequestTime",list[18]); 
    SetElement("RequestUserDR",list[19]);   
    SetElement("RequestUser",list[sort+9]);
    SetElement("RequestTel",list[20]);  
    SetElement("Place",list[21]);  
    SetElement("FaultTypeDR",list[22]);   
    SetElement("FaultType",list[sort+10]);
    SetElement("AcceptDate",list[23]);   
    SetElement("AcceptTime",list[24]);  
    SetElement("AcceptUserDR",list[25]); 
    SetElement("AcceptUser",list[sort+11]);
    SetElement("AssignDR",list[26]);   
    SetElement("Assign",list[sort+12]);
    SetElement("MaintModeDR",list[27]); 
    SetElement("MaintMode",list[sort+13]);
    /*SetElement("MaintLocDR",list[28]); 
    SetElement("MaintLoc",list[sort+14]);
    SetElement("ContractDR",list[29]);   
    SetElement("Contract",list[sort+15]);*/
    SetElement("ServiceDR",list[30]);  
    SetElement("Service",list[sort+16]);  // 284821 Modify by BRB 2016-11-12 服务商字段的保存
    if (GetElementValue("MaintModeDR")==3)
    {
    	SetElement("MaintModeWayDR",list[29]);   
        SetElement("MaintModeWay",list[sort+15]); 
    }
    else if (GetElementValue("MaintModeDR")==2)
    {
	    //SetElement("MaintModeWayDR",list[30]);  
        //SetElement("MaintModeWay",list[sort+16]);
        SetElement("ServiceDR",list[30]);
     	SetElement("Service",list[sort+16]);
	}
	else
	{
		SetElement("MaintModeWayDR",list[28]); 
        SetElement("MaintModeWay",list[sort+14]);
	}
    SetElement("UserSignDR",list[31]);   
    SetElement("UserSign",list[sort+17]);
    SetElement("UserOpinion",list[32]); 
    SetElement("ManageLocDR",list[33]);  
    SetElement("ManageLoc",list[sort+18]);
    if (list[34]=="N") SetElement("ReturnFlag",false);
    else SetElement("ReturnFlag",true);
    SetElement("MaintRequestDR",list[35]);  
    SetElement("MaintRequest",list[sort+19]);
    SetElement("MaintRemark",list[36]);   
    SetElement("EstimateWorkHour",list[37]);   
    SetElement("WorkHour",list[38]);   
    SetElement("Remark",list[39]);  
    SetElement("Status",list[40]);    
    /*SetElement("AddUserDR",list[41]);  
    SetElement("AddUser",list[sort+20]);
    SetElement("AddDate",list[42]); 
    SetElement("AddTime",list[43]);     
    SetElement("UpdateUserDR",list[44]);  
    SetElement("UpdateUser",list[sort+21]);
    SetElement("UpdateDate",list[45]);   
    SetElement("UpdateTime",list[46]);  
    SetElement("SubmitUserDR",list[47]);  
    SetElement("SubmitUser",list[sort+22]);
    SetElement("SubmitDate",list[48]); 
    SetElement("SubmitTime",list[49]); 
    SetElement("AuditUserDR",list[50]);  
    SetElement("AuditUser",list[sort+23]);
    SetElement("AuditDate",list[51]);  
    SetElement("AuditTime",list[52]);  
    SetElement("CancelUserDR",list[53]);  
    SetElement("CancelUser",list[sort+24]);
    SetElement("CancelDate",list[54]);    
    SetElement("CancelTime",list[55]);*/     
    SetElement("InvalidFlag",list[56]);    
    SetElement("MaintFee",list[57]);  
    SetElement("OtherFee",list[58]);   
    SetElement("TotalFee",list[59]);
    SetElement("EmergencyLevelDR",list[60]); 
    SetElement("EmergencyLevel",list[sort+25]);
    SetElement("SeverityLevelDR",list[61]); 
    SetElement("SeverityLevel",list[sort+26]);
    SetElement("ApproveSetDR",list[sort+30]);
	SetElement("NextRoleDR",list[sort+31]);
	SetElement("NextFlowStep",list[sort+32]);
	SetElement("ApproveStatu",list[sort+33]);
	SetElement("ApproveRoleDR",list[sort+34]);
	SetElement("CancelFlag",list[sort+35]);
	SetElement("CancelToFlowDR",list[sort+36]);
	//Add By DJ 2014-09-21
	SetElement("EQNo",list[sort+39]);  //Modefiy by zc 2015-03-06 begin
	SetElement("Model",list[sort+40]);
	SetElement("OriginalFee",list[sort+41]);//Modefiy by zc 2015-03-06 end
	SetElement("SourceType",list[62]);
	SetElement("SourceTypeDR",list[62]);
	SetElement("AssignDate",list[63]);
	SetElement("PackageState",list[64]);
	SetElement("Initials",list[sort+42]);//Modefiy by zc 2015-03-06 
	SetChkElement("InsurFlag",list[65]); 	// Mozy	隐藏元素
	SetElement("MaintResultsDR",list[66]); 
    SetElement("MaintResults",list[sort+27]);
    SetElement("EquipStatusDR",list[67]); 
    SetElement("EquipStatus",list[sort+28]);
    SetElement("MaintProcessDR",list[68]);  //add by zx 2016-12-28
    SetElement("MaintProcess",list[sort+46]);
    SetElement("SaveCostFee",list[70]);
    SetElement("MaintGroupDR",list[69]);
    SetElement("MaintGroup",list[sort+43]);
    SetElement("EQDate",list[sort+44]);
	SetElement("FileNo",list[sort+45]);
    if (plist[2]=="1")
    {
	    SetElement("NextRoleDR",GetElementValue("CurRole"));
	    SetElement("NextFlowStep",GetElementValue("RoleStep"));
	}
	
	if (plist[1]!="")
	{
	    evalist=plist[1].split("^");
	    var ECount=evalist.length
	    for (var i=1; i<=ECount; i++)
	    {
		    var EvaluateInfo=evalist[i-1]
		    if (EvaluateInfo!="")
		    {
			    var EDetail=EvaluateInfo.split(",")
			    var MenuApproveRole=GetElementValue("MenuApproveRole");
			    if (MenuApproveRole==EDetail[0])
			    {
				    SetElement(EDetail[1],EDetail[2])
			    }
		    }
	    }
	}
}
//Modefied by zc 2015-03-06 ZC0019
function SetContratByEquip(ExObjDR)
{
	var encmeth=GetElementValue("SetContract");
	var ValueList=cspRunServerMethod(encmeth,ExObjDR);
	var Value=ValueList.split("^");
	//alertShow(Value);
	SetSerContract(Value[0],Value[1],Value[2]);
}
//Modefied by zc 2015-03-06 ZC0019
function SetSerContract(Type,StartDate,EndDate)
{
	if (Type=="0")  //没有保修
	{
		DisableBElement("BSerContract",true);
	}
	else
	{
		DisableBElement("BSerContract",false);
		var obj=document.getElementById("BSerContract");
		if (obj) obj.onclick=BSerContract_Click;
	}
	SetElement("MaintStartDate",StartDate);
	SetElement("MaintEndDate",EndDate);
}
function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+GetElementValue("EXObjDR")+"&ReadOnly=1"
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var curRole=GetElementValue("RoleStep");
	var nextRole=GetElementValue("NextFlowStep");
	var EvaluateFlag=GetElementValue("EvaluateFlag");
	var EvaluateGroup=GetElementValue("EvaluateGroup");
	var RowID=GetElementValue("RowID");
	if(RowID=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BPicture",true);
	}
	if ((Status!=0)||((curRole!=0)&&(curRole!=nextRole)))
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BUpdate",true);
	}
	if (EvaluateFlag=="")
	{
		DisableBElement("BEvaluateDetail",true);
	}
	if (EvaluateGroup=="")
	{
		DisableBElement("BEvaluate",true);
	}
	var Action=GetElementValue("Action") //modified by czf 363741
	if ((Action=="WX_Assign")||(Action=="WX_Accept"))        //派单和受理时维修配件按钮不可用
	{
		DisableBElement("MaintDetail",true);
	}
}


function SetElementEnabled()
{
	var Status=GetElementValue("Status");
	var RoleStep=GetElementValue("RoleStep");
	var Action=GetElementValue("Action"); //add by zx 2016-03-15 Bug ZX0035  通过动作控制按钮灰化
	if (Status>0)	//提交之后
	{
		SetElementsReadOnly("SeverityLevel^MaintMode^RequestDate^RequestLoc^RequestUser^RequestTel^EmergencyLevel^FaultCase^StartDate^EstimateWorkHour^ReturnFlag^ExObj^SourceType^ObjType^ObjLoc^Place^MaintModeWay^MaintRequest^FaultCaseRemark^Remark^AcceptUser^FaultType^FaultReason^DealMethod^FaultReasonRemark^DealMethodRemark^MaintFee^EProcessSpeed^EWorkAttitude^EDifficulty^PackageState^Service^MaintProcess^MaintResults^InsurFlag^SaveCostFee^MaintGroup^WorkHour^EquipStatus",true); //modified by csj 20180323 需求号：572137 提交后设备状态只读
		if (Action=="WX_Assign")  //(RoleStep==1)	//Add By DJ 2014-09-22  派单 begin
		{
			SetElement("Assign",curUserName);
			SetElement("AssignDR",curUserID);
			if (GetElementValue("AssignDate")=="")
			{
				SetElement("AssignDate",GetElementValue("CurDate"));
			}
			SetElementsReadOnly("SeverityLevel^EmergencyLevel^EstimateWorkHour^AcceptUser^MaintGroup",false);
		}
		if ((Action=="WX_Accept")||(Action=="WX_Maint")||(Action=="WX_Finish"))  //((RoleStep==2)||(RoleStep==3))	//受理维修单,完成维修单
		{
			///Mozy	2016-7-5	affix^qty,affix^qty
			var result=GetMaintNumForAffix();
			if (result!="")
			{
				result=result.replace("^","维修");
				result=result.replace(",","次,");
				result=result+"次."
				
				alertShow("本维修单设备附属附件在保修期内维修(次数)信息:\n"+result);
			}
			if (GetElementValue("AcceptDate")=="")
			{
				SetElement("AcceptDate",GetElementValue("CurDate"));
			}
			if ((Action=="WX_Finish")&&(GetElementValue("EndDate")==""))
			{
				SetElement("EndDate",GetElementValue("CurDate"));
			}
			if ((Action=="WX_Maint")||(Action=="WX_Finish"))
			{
				SetElementsReadOnly("MaintMode^FaultType^FaultReason^DealMethod^FaultReasonRemark^DealMethodRemark^MaintFee^Service^MaintProcess^MaintResults^InsurFlag^SaveCostFee^WorkHour",false);		//Modify DJ 2016-04-20
			}
		}
		if (Action=="WX_Evaluate")  //(RoleStep==4)	//组长评价
		{
			SetElementsReadOnly("EWorkAttitude",false)
		}
		if (Action=="")  //(RoleStep==5)	//主任评价
		{
			SetElementsReadOnly("EWorkAttitude^EProcessSpeed^EDifficulty",false)
		}
	}
	else
	{
		SetElement("Assign","");
		SetElement("AssignDR","");
		SetElement("AssignDate","");
		var obj=document.getElementById("ReturnFlag")
		if (obj.checked == true)
		{
			SetElementsReadOnly("Assign^FaultReasonRemark^ERemark^AcceptUser^EndDate^AcceptDate^UserSign^WorkHour^OtherFee^TotalFee^EContent^EEvaluateType^EScore^DealMethod^FaultReason^FaultType^DealMethodRemark^MaintMode^EstimateWorkHour^EmergencyLevel^SeverityLevel^EProcessSpeed^EWorkAttitude^EDifficulty^Service^MaintProcess^MaintResults^InsurFlag",true); //^MaintRequest	
		}
		else	
		{
			SetElementsReadOnly("Assign^FaultReasonRemark^ERemark^AcceptUser^EndDate^AcceptDate^UserSign^WorkHour^OtherFee^TotalFee^EContent^EEvaluateType^EScore^DealMethod^FaultReason^FaultType^DealMethodRemark^MaintRequest^MaintMode^EstimateWorkHour^EmergencyLevel^SeverityLevel^EProcessSpeed^EWorkAttitude^EDifficulty^MaintFee^Service^MaintProcess^MaintResults^InsurFlag",true); 
		}
	}
}

function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}

function GetExObj(value)
{
	var data=value.split("^");
	var obj=document.getElementById('ExObjDR');
	obj.value=data[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+data[1];
	//SetContratByExObj(data[1]);
	var obj=new GetExObjOBJ(data[1],"");
	
	SetElement("UseLoc",obj.UseLoc);
	SetElement("UseLocDR",obj.UseLocDR);
	SetElement("UserSign",obj.Keeper);
	SetElement("UserSignDR",obj.KeeperDR);
	SetElement("AcceptUser",obj.MaintUser);
	SetElement("AcceptUserDR",obj.MaintUserDR);
}

function BUpdate_Click() //保存数据同时新增可编辑字段所需的表
{
	if (CheckItemNull(1,"ExObj")) return;
	//Add By DJ 2018-03-18
	var MStartStopFlag=GetElementValue("MStartStopFlag")
	var SourceTypeDR=GetElementValue("SourceTypeDR")
	if ((MStartStopFlag==1)&&((SourceTypeDR==1)||(SourceTypeDR==2)))
	{
		var EQNo=GetElementValue("EQNo")
		//获取设备当前状态启用提示,停用则不再提示
		var encmeth=GetElementValue("CurEQStatus")
		if (encmeth=="")
		{
			alertShow("请设置获取设备当前状态信息!")
			return
		}
		var CurEquipStatus=cspRunServerMethod(encmeth,EQNo)
		if (CurEquipStatus==1)		//仅启用设备提示是否停用
		{
			var truthBeTold = window.confirm("是否停用当前设备?");
			if (!truthBeTold) SetElement("MStartStopFlag",0)
		}
		else
		{
			SetElement("MStartStopFlag",0)
		}
	}
	//add by lmm 2018-03-13 begin 562193
	var FaultCaseRowID=GetFaultCaseRowID(GetElementValue("GetFaultCaseOperMethod"))
	if (FaultCaseRowID!="") 
	{
		SetElement("FaultCaseDR",FaultCaseRowID);		
	}
	//add by lmm 2018-03-13 end 562193
	if (CheckMustItemNull("ExObj")) return;
	if (CheckInvalidData()) return;
	//add by zx 2017-01-04 begin
	var ExObjDR=GetElementValue("ExObjDR")
	var SourceTypeDR=GetElementValue("SourceTypeDR")
	//add by wy 2017-6-2 增加入参RowID
	var RowID=GetElementValue("RowID")
	var CheckMaintProcess=document.getElementById('CheckMaintProcess');
	if (CheckMaintProcess){var encmeth=CheckMaintProcess.value} else {var encmeth=""};
	var CheckValue=cspRunServerMethod(encmeth,SourceTypeDR,ExObjDR,RowID);
	var CheckList=CheckValue.split("^");
	if(CheckList[0]=="1")
	{
		var truthBeTold = window.confirm(CheckList[2]+"于"+CheckList[3]+"已报修，设备正在维修当中，单号："+CheckList[1]+"！是否继续？");
		if (!truthBeTold) return;
	}
	//add by zx 2017-01-04 end
	var combindata=GetDataList();
	var Evaluate=PackageData("EEvaluateTypeDR^EScore^EContent^ERemark^EUserDR^EDate^ETime")
	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata,Evaluate);
	if (ReturnValue<0) 
	{
		alertShow("更新失败!   "+ReturnValue);
		return;
	}
	//add by zx 2016-05-19
	AlertDialogShow("更新成功!",1);
	window.setTimeout(function(){window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&RowID="+ReturnValue+"&CurRole="+GetElementValue("CurRole")+"&ApproveRoleDR="+GetElementValue("ApproveRoleDR")+"&QXType="+GetElementValue("QXType")},1500); 
	//window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequest&RowID="+ReturnValue+"&CurRole="+GetElementValue("CurRole")+"&ApproveRoleDR="+GetElementValue("ApproveRoleDR");
}

function GetDataList()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("RequestNo") ;
	combindata=combindata+"^"+GetElementValue("ManageTypeDR") ;
	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
	combindata=combindata+"^"+GetElementValue("ObjTypeDR") ;
	combindata=combindata+"^"+GetElementValue("ExObjDR") ;
	combindata=combindata+"^"+GetElementValue("ObjLocDR") ;
	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
	combindata=combindata+"^"+GetElementValue("StartDate") ;
	combindata=combindata+"^"+GetElementValue("StartTime") ;	//10
	combindata=combindata+"^"+GetElementValue("FaultCaseDR"); //Modefied by lmm 2018-03-13 562193
	combindata=combindata+"^"+GetElementValue("FaultCaseRemark") ;
	combindata=combindata+"^"+GetFaultReasonRowID(GetElementValue("GetFaultReasonOperMethod"));  //modify by lmm 2017-11-22 466969
	combindata=combindata+"^"+GetElementValue("FaultReasonRemark") ;
	combindata=combindata+"^"+GetDealMethodRowID(GetElementValue("GetDealMethodOperMethod"));  //modify by lmm 2017-11-22 466980
	combindata=combindata+"^"+GetElementValue("DealMethodRemark") ;
	combindata=combindata+"^"+GetElementValue("EndDate") ;
	combindata=combindata+"^"+GetElementValue("EndTime") ;
	combindata=combindata+"^"+GetElementValue("RequestDate") ;
	combindata=combindata+"^"+GetElementValue("RequestTime") ;	//20
	combindata=combindata+"^"+GetElementValue("RequestUserDR") ;
	combindata=combindata+"^"+GetElementValue("RequestTel") ;
	combindata=combindata+"^"+GetElementValue("Place") ;
	combindata=combindata+"^"+GetFaultTypeRowID(GetElementValue("GetFaultTypeOperMethod")); //modify by lmm 2017-09-22 503001
	combindata=combindata+"^"+GetElementValue("AcceptDate") ;
	combindata=combindata+"^"+GetElementValue("AcceptTime") ;
	combindata=combindata+"^"+GetElementValue("AcceptUserDR") ;
	combindata=combindata+"^"+GetElementValue("AssignDR") ;
	combindata=combindata+"^"+GetElementValue("MaintModeDR") ;	//29
	if (GetElementValue("MaintModeDR")==3)
	{
	    combindata=combindata+"^"+"^"+GetElementValue("MaintModeWayDR")+"^" ;
	}
    else if (GetElementValue("MaintModeDR")==2)
    {
        combindata=combindata+"^"+"^"+"^"+GetElementValue("MaintModeWayDR") ;
    }
    else
    {
        combindata=combindata+"^"+GetElementValue("MaintModeWayDR")+"^"+"^" ;
    }
	combindata=combindata+"^"+GetElementValue("UserSignDR") ;
	combindata=combindata+"^"+GetElementValue("UserOpinion") ;
	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;
	var obj = document.getElementById("ReturnFlag") ;
	if (obj.checked==false){combindata=combindata+"^"+"N";}
	else combindata=combindata+"^"+"Y" ;
	combindata=combindata+"^"+GetElementValue("MaintRequestDR") ;
	combindata=combindata+"^"+GetElementValue("MaintRemark") ;
	combindata=combindata+"^"+GetElementValue("EstimateWorkHour") ;
	combindata=combindata+"^"+GetElementValue("WorkHour") ;	//40
	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+GetElementValue("Status") ;
	combindata=combindata+"^"+Guser;
	//combindata=combindata+"^"+curUserID ;
	/*combindata=combindata+"^"+GetElementValue("AddDate") ;
	combindata=combindata+"^"+GetElementValue("AddTime") ;
	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
	combindata=combindata+"^"+GetElementValue("AuditDate") ;
	combindata=combindata+"^"+GetElementValue("AuditTime") ;
	combindata=combindata+"^"+GetElementValue("CancelUser") ;
	combindata=combindata+"^"+GetElementValue("CancelDate") ;
	combindata=combindata+"^"+GetElementValue("CancelTime") ;*/
	combindata=combindata+"^"+GetElementValue("InvalidFlag") ;
	combindata=combindata+"^"+GetElementValue("MaintFee") ;
	combindata=combindata+"^"+GetElementValue("OtherFee") ;
	combindata=combindata+"^"+GetElementValue("TotalFee") ;
	combindata=combindata+"^"+GetElementValue("EmergencyLevelDR") ;
	combindata=combindata+"^"+GetElementValue("SeverityLevelDR") ;
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;		//50	Modify DJ 2014-09-21
	combindata=combindata+"^"+GetElementValue("AssignDate") ;		//Modify DJ 2014-09-22
	combindata=combindata+"^"+GetElementValue("PackageState") ;		//Modify DJ 2014-09-26
	combindata=combindata+"^"+GetElementValue("InsurFlag") ;			//Modify ZC 2015-03-06
	combindata=combindata+"^"+GetElementValue("MaintResultsDR") ;		//Modify ZC 2015-03-06
	combindata=combindata+"^"+GetElementValue("EquipStatusDR") ;		//Modify ZC 2015-03-06
	combindata=combindata+"^"+GetElementValue("MaintProcessDR") ;			//add by zx 2016-12-28
	/*combindata=combindata+"^"+GetElementValue("EvaluateType") ;
	combindata=combindata+"^"+GetElementValue("Content") ;
	combindata=combindata+"^"+GetElementValue("EvaluateRemark") ;
	combindata=combindata+"^"+GetElementValue("Score") ;
	combindata=combindata+"^"+GetElementValue("Accessory") ;
	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
	combindata=combindata+"^"+GetElementValue("PriceFee") ;*/
	combindata=combindata+"^"+GetElementValue("MStartStopFlag") ;	//Add By DJ 2018-03-18
    return combindata;
  }
function BDelete_Click()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID=="")
	{
		alertShow(t["05"])
		return
	}
	var truthBeTold = window.confirm(t["10"]);
	if (!truthBeTold) return;
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var Ret=cspRunServerMethod(encmeth,"","",RowID)
	if (Ret!='0')
	{
		alertShow(t["07"]);
		return;
	}
	//add by zx 2016-05-19
	AlertDialogShow("删除成功!",1);
	window.setTimeout(function(){window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestSimple&RowID=&Status=0"},1500); 
}
function BSubmit_Click()	// 提交
{
	var IRowID=document.getElementById('RowID').value;
	if (IRowID=="")
	{
		alertShow(t["06"]);
		return 0;
	}
	
	//midified by zy 2015-7-1 ZY0132
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	if (GetStopEquipFlag==1)
	{
		var truthBeTold = window.confirm("当前维修设备是否停用?");
		if (truthBeTold) GetStopEquipFlag=2;
	}
	else if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"31",IRowID,"1");
		if (result!=0)
		{
			alertShow("设备停用失败!")
			return;
		}
	}
	
	var obj=document.getElementById('submit');
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var Ret=cspRunServerMethod(encmeth,"","",IRowID,"1",Guser);
	if (Ret!="0") 
	{
		if (Ret=="-1015")
		{
			alertShow(t[Ret])
		}
		else
		{
			alertShow(t["04"]);
		}
		return 0;
	}
	//add by zx 2016-05-19
	AlertDialogShow("提交成功!",1);
	var SimpleFlag=GetElementValue("SimpleFlag");
	if (SimpleFlag!="")
	{
		window.setTimeout(function(){window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestSimple&RowID="+IRowID+"&CurRole="+GetElementValue("CurRole")},1500); 
	}
	else
	{
		window.setTimeout(function(){window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequest&RowID="+IRowID+"&CurRole="+GetElementValue("CurRole")},1500); 	
	}
}

function BCancelSubmit_Clicked() // 取消提交
{
	//midified by zy 2015-7-1 ZY0134
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	if (GetStopEquipFlag==1)
	{
		var truthBeTold = window.confirm("当前维修设备是否取消停用?");
		if (truthBeTold) GetStopEquipFlag=2;
	}
	else if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"31",RowID,"0");
		if (result!=0)
		{
			alertShow("设备取消停用失败!")
			return;
		}
	}
	var CurRole=GetElementValue("CurRole")
	var RoleStep=GetElementValue("RoleStep")
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("GetApproveAllowType");
	var ApproveTypeCode="25";
	var Type="1";
	var GotoType=cspRunServerMethod(encmeth,RowID,CurRole,ApproveTypeCode,Type,RoleStep) //add by zx 2016-03-04  BugZX0035
	SetElement("ApproveTypeCode","25");
	SetElement("Type","1")
	if (GotoType==2)
	{
		//GetUserApproves
		LookUp("","web.DHCEQCApproveFlow:GetUserApproves","GetUserCancelApprove","RowID,CurRole,ApproveTypeCode,Type,RoleStep");
		return ;	
	}

	
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
	    //add by zx 2016-05-19
	    AlertDialogShow("取消成功!",1);
	    window.setTimeout(function(){window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequest&RowID="+Rtn+"&CurRole="+GetElementValue("CurRole")},1500); 
	}
    else
    {
	    alertShow(Rtn+"  : "+t["01"]);
    }
}
function GetUserCancelApprove(Value)
{
	var list=Value.split("^");
	SetElement("CancelToFlowDR",list[0]);

	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
	    //add by zx 2016-05-19
	    AlertDialogShow("取消成功!",1);
	    window.setTimeout(function(){window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequest&RowID="+Rtn+"&CurRole="+GetElementValue("CurRole")},1500); 		
	}
    else
    {
	    alertShow(Rtn+"  : "+t["01"]);
    }
}
function BApprove_Clicked()
{
	//Add By DJ 2018-03-18
	var Action=GetElementValue("Action")
	if (Action=="WX_Finish")
	{
		var MStartStopFlag=GetElementValue("MStartStopFlag")
		var SourceTypeDR=GetElementValue("SourceTypeDR")
		if ((MStartStopFlag==1)&&((SourceTypeDR==1)||(SourceTypeDR==2)))
		{
			var EQNo=GetElementValue("EQNo")
			//获取设备当前状态停用提示,启用则不再提示
			var encmeth=GetElementValue("CurEQStatus")
			if (encmeth=="")
			{
				alertShow("请设置获取设备当前状态信息!")
				return
			}
			var CurEquipStatus=cspRunServerMethod(encmeth,EQNo)
			if (CurEquipStatus==2)		//仅启用设备提示是否停用
			{
				var truthBeTold = window.confirm("是否启用当前设备?");
				if (!truthBeTold) SetElement("MStartStopFlag",0)
			}
			else
			{
				SetElement("MStartStopFlag",0)
			}
		}
	}
	//add by lmm 2107-11-22 begin 466969

  	var GetFaultReasonOperMethod=GetElementValue("GetFaultReasonOperMethod");
  	var FaultReasonDR=GetFaultReasonRowID(GetFaultReasonOperMethod);
  	if (FaultReasonDR<0)
  	{
	  	alertShow("故障原因发生异常!");
	  	return;
  	}
  	SetElement("FaultReasonDR",FaultReasonDR);
  	//add by lmm 2017-11-22 end 466969
	//add by lmm 2107-11-22 begin 466980
  	var GetDealMethodOperMethod=GetElementValue("GetDealMethodOperMethod");
  	var DealMethodDR=GetDealMethodRowID(GetDealMethodOperMethod);
  	if (DealMethodDR<0)
  	{
	  	alertShow("解决方法发生异常!");
	  	return;
  	}
  	SetElement("DealMethodDR",DealMethodDR);	
  	//add by lmm 2017-11-22 end 466980
	
	//add by lmm 2017-09-22 503001 begin
  	var GetFaultTypeOperMethod=GetElementValue("GetFaultTypeOperMethod");
  	var FaultTypeDR=GetFaultTypeRowID(GetFaultTypeOperMethod);
  	if (FaultTypeDR<0)
  	{
	  	alertShow("故障类型发生异常!");
	  	return;
  	}
  	SetElement("FaultTypeDR",FaultTypeDR);
	//add by lmm 2017-09-22 503001 end


	//保存评价信息 Modify DJ 2015-08-28 DJ0159
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
	
	//add by GBX GBX0037 判断审批流转类型，如果是人为操作指定步骤，则取用户选择的步骤
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("GetApproveAllowType");
	var ApproveTypeCode="25";
	var Type="0";
	var GotoType=cspRunServerMethod(encmeth,RowID,CurRole,ApproveTypeCode,Type,RoleStep) //add by zx 2016-03-04  BugZX0035
	SetElement("ApproveTypeCode","25");
	SetElement("Type","0");
	if (GotoType==2)
	{
		//GetUserApproves
		LookUp("","web.DHCEQCApproveFlow:GetUserApproves","GetUserApprove","RowID,CurRole,ApproveTypeCode,Type,RoleStep");
		return;	
	}
	///modify by GBX2015-12-21 GBX0037
	var objtbl=GetParentTable("RequestNo")
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn=="0")		//Modify DJ 2015-08-28 DJ0159
    {
	    //add by zx 2016-05-19
	    AlertDialogShow("操作成功!",1);
	    if (parent.parent.opener)	//Add By DJ 2017-11-17
	    {
		    parent.parent.opener.initMaintWaitListDataGrid()
	    }
	    window.setTimeout(function(){window.location.reload()},1500); 
	}
    else
    {
	    var RtnInfo=Rtn.split("^");
	    if ((RtnInfo[0]=="-1016")||(RtnInfo[0]=="-1017"))
	    {
		    alertShow(RtnInfo[1]);
	    }
	    else
	    {
	    	alertShow(RtnInfo[0]+t["04"]);
	    }
    }
}
///modify by GBX2015-12-21 GBX0037
function GetUserApprove(Value)
{
	var list=Value.split("^");
	var ApproveFlowID=list[0]; //add by zx 2016-03-02 认为操作指定传对应审批流id
	
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;

	var objtbl=GetParentTable("RequestNo")
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var combindata=GetValueList();
	var MaintProcess=GetElementValue("MaintProcess");
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo,ApproveFlowID,MaintProcess);  //add by zx 2016-02-24 Bug ZX0034
	//alertShow(CurRole+"   "+RoleStep)
    if (Rtn=="0")		//Modify DJ 2015-08-28 DJ0159
    {
	    //add by zx 2016-05-19
	    AlertDialogShow("审核成功!",1);
	    window.setTimeout(function(){window.location.reload()},1500);
	}
    else
    {
	    var RtnInfo=Rtn.split("^");
	    if ((RtnInfo[0]=="-1016")||(RtnInfo[0]=="-1017"))
	    {
		    alertShow(RtnInfo[1]);
	    }
	    else
	    {
	    	alertShow(RtnInfo[0]+t["04"]);
	    }
    }
}
function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("EvaluateGroup");		//Add By DJ 2015-08-28 DJ0159
	ValueList=ValueList+"^"+GetElementValue("MStartStopFlag");		//Add By DJ 2018-03-18
	
	return ValueList;
}

function ExObj_Change()
{
	var UseLocDR=GetElementValue("ObjLocDR")
	var SourceTypeDR=GetElementValue("SourceType")
	if (UseLocDR=="")
	{
		alertShow("请先选择使用科室!")
		return
	}
	LookUp("","web.DHCEQM.DHCEQMExObj:ShortExObj","GetExObjID","ExObj,'',ObjLocDR,'','',SourceTypeDR");	//add by zx 2017-03-20 BUG ZX0036
	/*
	if(SourceTypeDR=="1")
	{
		LookUp("","web.DHCEQM.DHCEQMExObj:ShortExObj","GetExObjID","ExObj,'',ObjLocDR");	//Modify DJ 2014-09-21
	}
	else if(SourceTypeDR=="2")
	{
		LookUpMasterItem("GetMasterItem",",,Name,,'Y'");	//add by zx 2016-06-15
	}*/
	//LookUp("","web.DHCEQM.DHCEQMExObj:ShortExObj","GetExObjID","ExObj,'',ObjLocDR");	//Modify DJ 2014-09-21
	//LookUp("","web.DHCEQM.DHCEQMExObj:ShortExObj","GetExObjID","ExObj,SourceTypeDR,ObjLocDR");	//Modify zy 20150901 ZY0140
}
function GetExObjID(value)
{   
   	var list=value.split("^")
	SetElement('ExObj',list[0]);
	SetElement('ExObjDR',list[1]);
	SetElement('EquipDR',list[6]);
	SetElement('ObjLoc',list[4]);
	SetElement('ObjLocDR',list[3]);
	SetElement('ObjTypeDR',list[7]);
	SetElement('ObjType',list[10]);
	//Add By DJ 2014-09-21
	SetElement('EQNo',list[2]);
	//SetElement('SourceType',list[5]);
	//SetElement('SourceTypeDR',list[5]);
	SetElement('EquipTypeDR',list[11]);
	SetElement('Model',list[12]);
	SetElement('OriginalFee',list[13]);
	SetElement('Place',list[14]);
	SetElement('FileNo',list[15]);
	//来自设备时自动保存维护对象
	if (list[5]=="1")
	{
		var encmeth=GetElementValue("AutoSaveExObj")
  		if (encmeth=="") return;
  		var Rtn=cspRunServerMethod(encmeth,list[6]);
  		if (Rtn>0)
  		{
	  		SetElement('ExObjDR',Rtn);
  		}
  		else
  		{
	  		alertShow("自动保存维护对象失败!")
	  		return
  		}
	}
}
// add by zx 2016-06-15 
function GetMasterItem(value)
{ 
	var list=value.split("^");
	SetElement('ExObj',list[0]);
	SetElement('ExObjDR',list[1]);
	//SetElement('EquipDR',list[7]);
	SetElement('ObjTypeDR',list[9]);
	SetElement('ObjType',list[10]);
	SetElement('EQNo',"");
	SetElement('FileNo',"");
	//SetElement('SourceType',"2");
	//SetElement('SourceTypeDR',"2");
	SetElement('EquipTypeDR',list[7]);
	SetElement('Model',"");
	SetElement('OriginalFee',"");
	SetElement('Place',"");
}
function GetUserSign(value)
{
	GetLookUpID('UserSignDR',value);
}
function GetDealMethod(value)
{
	GetLookUpID('DealMethodDR',value);
}
function GetAcceptUser(value)
{
	var val=value.split("^");	//Add By DJ 2014-09-22
	SetElement("AcceptUser",val[2])  //add HHM by 2016-01-05
	SetElement("Initials",val[6])	//Add By DJ 2014-09-22
	GetLookUpID('AcceptUserDR',value);
}
function GetRequestUser(value)
{
	GetLookUpID('RequestUserDR',value);
}

function GetFaultCase(value)
{
	GetLookUpID('FaultCaseDR',value);
}
function GetFaultReason(value)
{
	GetLookUpID('FaultReasonDR',value);
}
function GetFaultType(value)
{
	GetLookUpID('FaultTypeDR',value);
}
function GetMaintMode(value)
{
	GetLookUpID('MaintModeDR',value);
	var val=value.split("^");
	if (val[2]=="02") SetChkElement("InsurFlag",1);
    else SetChkElement("InsurFlag",0);
}
function GetMaintGroup(value)
{
	GetLookUpID('MaintGroupDR',value);
}
function GetManageLoc(value)
{
	GetLookUpID('ManageLocDR',value);
}
function GetUseLoc(value)
{
	GetLookUpID('UseLocDR',value);
}
function GetRequestLoc(value)
{
	GetLookUpID('RequestLocDR',value);
}
function GetExObj(value)
{
	GetLookUpID('ExObjDR',value);
}
function GetEvaluateType(value)
{
	GetLookUpID('EEvaluateTypeDR',value);
}
function GetSeverityLevel(value)
{
	GetLookUpID('SeverityLevelDR',value);
}
function GetEmergencyLevel(value)
{
	GetLookUpID('EmergencyLevelDR',value);
}
function GetRequest(value)
{
	GetLookUpID('MaintRequestDR',value);
}
function GetExObjLoc(value)
{
	GetLookUpID('ObjLocDR',value);
	//20160919 Mozy0172
	var val=value.split("^");
	SetElement("RequestTel",val[4]);
}

function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("MTPTotalFee"),1,1,0,1)==0)
	{
		alertShow("配件费用数据异常,请修正.");
		return true;
	}
	if (IsValidateNumber(GetElementValue("OtherFee"),1,1,0,1)==0)
	{
		alertShow("其他费用数据异常,请修正.");
		return true;
	}
	if (IsValidateNumber(GetElementValue("MTIMaintFee"),1,1,0,1)==0)
	{
		alertShow("维修费用数据异常,请修正.");
		return true;
	}

	return false;
}
function BMaintDetail_Click()
{
	var BRLRowID=GetElementValue("RowID");
	if (BRLRowID=="")
	{
		alertShow("无设备维修申请信息!");
		return;
	}
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+GetElementValue("RowID")+'&MaintItemDR='+GetElementValue("MaintItemDR")+'&Status='+GetElementValue("Status");
    if (GetElementValue("RoleStep")!=6) var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+GetElementValue("RowID")+'&MaintItemDR='+GetElementValue("MaintItemDR")+'&Status=0';		//非维修选择配件步骤
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=500,left=80,top=0')
}
//Add By DJ 2014-09-23
//描述:自动计算总费用
function TotalFee_Change()
{
	var MaintFee=GetElementValue("MaintFee")
	if (MaintFee=="") MaintFee=0
	MaintFee=parseFloat(MaintFee);
	var OtherFee=GetElementValue("OtherFee")
	if (OtherFee=="") OtherFee=0
	OtherFee=parseFloat(OtherFee);
	var tmpValue=(MaintFee.toFixed(2)*1)+(OtherFee.toFixed(2)*1);
	tmpValue=parseFloat(tmpValue);
	SetElement("TotalFee",tmpValue.toFixed(2))
}
///Add By DJ 2014-09-26
///描述:显示评分详细清单-----
function BEvaluateDetail_Click()
{
	var RowID=GetElementValue("RowID")
 	var str='dhccpmrunqianreport.csp?&reportName=DHCEQEvaluateDetail.raq&vSourceType=1&vSourceID='+RowID;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=990,height=750,left=80,top=0')
}
function GetMaintResults(value)
{
	GetLookUpID('MaintResultsDR',value);
}
function GetService (value)
{
    GetLookUpID("ServiceDR",value);
}
function GetEquipStatus(value)
{
	GetLookUpID('EquipStatusDR',value);
}
//Add By DJ 2015-08-28 DJ0159
function BEvaluate_Click()
{
	var RowID=GetElementValue("RowID");
	var CurRole=GetElementValue("CurRole");
	var EvaluateGroup=GetElementValue("EvaluateGroup");
	var ReturnStr=GetElementValue("CheckEvaluate");
	var SourceNo=GetElementValue("RequestNo");
	var CheckEvaluate=ReturnStr.split("^");
	if (CheckEvaluate[0]<0)
	{
		alertShow(CheckEvaluate[1]);
		return
	}
	var ReadOnly=0
	if (CheckEvaluate[0]==0) ReadOnly=1;
	//打开评价窗口
	var str="dhceqevaluate.csp?&SourceType=31&SourceID="+RowID+"&CurRole="+CurRole+"&EvaluateGroup="+EvaluateGroup+"&SourceNo="+SourceNo+"&ERowID="+CheckEvaluate[1]+"&ReadOnly="+ReadOnly
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function BPicture_Click()
{
	var Status=GetElementValue("Status");
	var str='dhceq.process.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+GetElementValue("RowID")+'&Status='+Status;
	if (GetElementValue("Status")==2) str=str+"&ReadOnly=1";
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes');
}
function BPrint_Click()
{
	alertShow("打印报价单及呈批件...")
}
function BEquipInfo_Click()
{
	if (GetElementValue("EQNo")=="") return;
	var encmeth=GetElementValue("GetEquipIDByNo")
  	if (encmeth=="") return;
  	var EQNo=cspRunServerMethod(encmeth,GetElementValue("EQNo"));
	if (EQNo=="") return;
	var str="dhceqequiplistnew.csp?&ReadOnly=1&RowID="+EQNo;
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
//add by zx 2016-08-30
function SourceType()
{
	var SourceType=GetElementValue("SourceType");
	SetElement("SourceTypeDR",SourceType);
	SetElement("ExObj","");
	SetElement("ExObjDR","");
}
// add by zx 2016-05-19
//自动关闭提示框  
function AlertDialogShow(str,min) {  
    var msgw,msgh,bordercolor;  
    msgw=350;//提示窗口的宽度  
    msgh=80;//提示窗口的高度  
    titleheight=25 //提示窗口标题高度  
    bordercolor="#ABC7EC";//提示窗口的边框颜色  
    titlecolor="#ABC7EC";//提示窗口的标题颜色  
    var sWidth,sHeight;  
    //获取当前窗口尺寸  
    sWidth = document.body.offsetWidth;  
    sHeight = document.body.offsetHeight;  
    //背景div  
    var bgObj=document.createElement("div");  
    bgObj.setAttribute('id','alertbgDiv');  
    bgObj.style.position="absolute";  
    bgObj.style.top="0";  
    bgObj.style.background="#FAFAFA";  
    bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";  
    bgObj.style.opacity="0.6";  
    bgObj.style.left="0";  
    bgObj.style.width = sWidth + "px";  
    bgObj.style.height = sHeight + "px";  
    bgObj.style.zIndex = "10000";  
    document.body.appendChild(bgObj);  
    //创建提示窗口的div  
    var msgObj = document.createElement("div")  
    msgObj.setAttribute("id","alertmsgDiv");  
    msgObj.setAttribute("align","center");  
    msgObj.style.background="#FAFAFA";  
    msgObj.style.border="1px solid " + bordercolor;  
    msgObj.style.position = "absolute";  
    msgObj.style.left = "50%";  
    msgObj.style.font="18px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";  
    //窗口距离左侧和顶端的距离   
    msgObj.style.marginLeft = "-225px";  
    //窗口被卷去的高+（屏幕可用工作区高/2）-150  
    msgObj.style.top = document.body.scrollTop+(window.screen.availHeight/2)-150 +"px";  
    msgObj.style.width = msgw + "px";  
    msgObj.style.height = msgh + "px";  
    msgObj.style.textAlign = "center";  
    msgObj.style.lineHeight ="25px";  
    msgObj.style.zIndex = "10001";  
    document.body.appendChild(msgObj);  
    //提示信息标题  
    var title=document.createElement("h4");  
    title.setAttribute("id","alertmsgTitle");  
    title.setAttribute("align","left");  
    title.style.margin="0";  
    title.style.padding="0px";  
    title.style.background = bordercolor;  
    title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";  
    title.style.opacity="0.75";  
    title.style.border="1px solid " + bordercolor;  
    title.style.height="24px"; 
    title.style.width="350px" 
    title.style.font="18px Verdana, Geneva, Arial, Helvetica, sans-serif";  
    title.style.color="#15429D";
    title.style.fontWeight="bold";//加粗文本  
    title.innerHTML="提示信息";  
    document.getElementById("alertmsgDiv").appendChild(title);  
    //提示信息  
    var txt = document.createElement("p");  
    txt.setAttribute("id","msgTxt");  
    txt.style.margin="16px 0";  
    txt.innerHTML = str;  
    document.getElementById("alertmsgDiv").appendChild(txt);  
    //设置关闭时间  
    window.setTimeout("closewin()",1500*min);   //modified by kdf 2018-03-15 需求号：565896
}  
function closewin() {  
    document.body.removeChild(document.getElementById("alertbgDiv"));  
    document.getElementById("alertmsgDiv").removeChild(document.getElementById("alertmsgTitle"));  
    document.body.removeChild(document.getElementById("alertmsgDiv"));  
}
function GetMaintNumForAffix()
{
	var encmeth=GetElementValue("GetMaintNumForAffix")
  	if (encmeth=="") return 0;
	return cspRunServerMethod(encmeth,GetElementValue("RowID"));
}
//add by zx 2016-12-28
function GetMaintProcess(value)
{
	GetLookUpID('MaintProcessDR',value);
}

//add by zc 2018-03-19 zc0036
function BMaintUser_Click()
{
	var SourceID=GetElementValue("RowID");
	if (SourceID=="")
	{
		alertShow("无设备维修申请信息!");
		return;
	}
	var para="SourceType=31&SourceID="+SourceID+"&Action="+GetElementValue("Action")
    var url='dhceq.process.maintuserlist.csp?'+para;
	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
document.body.onload = BodyLoadHandler;