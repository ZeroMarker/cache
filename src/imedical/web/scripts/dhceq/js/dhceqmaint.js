jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
)
function initDocument()
{
	initCombogrid();
	initTopPanel();
	FillData();
	FillEquipData();
	SetEnabled();
}
//初始化查询头面板
function initTopPanel()
{
	//initDataGridPanel();
	jQuery("#BUpdate").linkbutton({iconCls: 'icon-save'});
	jQuery("#BUpdate").on("click", BUpdate_Click);
	jQuery("#BSubmit").linkbutton({iconCls: 'icon-ok'});
	jQuery("#BSubmit").on("click", BSubmit_Click);
	jQuery("#BDelete").linkbutton({iconCls: 'icon-cancel'});
	jQuery("#BDelete").on("click", BDelete_Click);
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-no'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Click);
	jQuery("#BPicture").linkbutton({iconCls: 'icon-print'});
	jQuery("#BPicture").on("click", BPicture_Click);
	jQuery("#BPMReport").linkbutton({iconCls: 'icon-print'});
	jQuery("#BPMReport").on("click", BPMReport_Click);
	/*
	jQuery("#BLoc").linkbutton({iconCls: 'icon-add'});
	jQuery("#BLoc").click(function(){AddgridData("4")});
	jQuery("#BMastitem").linkbutton({iconCls: 'icon-add'});
	jQuery("#BMastitem").click(function(){AddgridData("6")});
	jQuery("#BEquip").linkbutton({iconCls: 'icon-add'});
	jQuery("#BEquip").click(function(){AddgridData("5")});
	*/
	//initDataGrid();
	//SetEnabled();
	//CheckContrl();
	
}
/*
 *Description:保存保养记录
 *author:limm
*/
function BUpdate_Click()
{
	var ReqNum=0;
	jQuery('input.validatebox-invalid').each(function(){ ReqNum++});
	if (ReqNum>0) {
		jQuery.messager.alert("提示", "请检查必填字段！");
		return;
	}
	if(CheckInvalidData()) return;
	var combindata=GetMaintInfoList();
	var Rtn = tkMakeServerCall("web.DHCEQMaintNew", "SaveData",combindata);
	if (Rtn<0) 
	{
		alertShow("保存失败！");
		return;	
	}
	
    parent.location.href= "dhceq.process.maint.csp?&RowID="+Rtn+"&EquipDR="+getJQValue($("#EquipDR"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypeDR="+getJQValue($("#MaintTypeDR"));
	
}
/*
 *Description:检测有效数据
 *author:limm
*/
function CheckInvalidData()
{
	if (IsValidateNumber(getJQValue($("#MaintFee")),1,1,0,1)==0)
	{
		alertShow("其他费用数据异常,请修正.");
		return true;
	}
	return false;
}

/*
 *Description:保养记录数据字符串
 *author:limm
*/
function GetMaintInfoList()
{
	var combindata="";	
	combindata=getJQValue($("#RowID")) ; //1
	combindata=combindata+"^"+getJQValue($("#EquipDR")) ; //2
	combindata=combindata+"^"+getJQValue($("#BussType")) ; //3
	combindata=combindata+"^"+getJQValue($("#PlanNameDR")) ; //4
	combindata=combindata+"^"+getJQValue($("#MaintTypeDR")) ; //5
	combindata=combindata+"^"+getJQValue($("#MaintDate")) ; //6
	combindata=combindata+"^"+getJQValue($("#MaintLocDR")) ; //7
	combindata=combindata+"^"+getJQValue($("#MaintUserDR")) ; //8
	combindata=combindata+"^"+getJQValue($("#MaintModeDR")) ; //9
	combindata=combindata+"^"+getJQValue($("#TotalFee")) ; //10
	combindata=combindata+"^"+getJQValue($("#NormalFlag")) ; //11
	combindata=combindata+"^"+getJQValue($("#ManageLocDR")) ; //12
	combindata=combindata+"^"+getJQValue($("#UseLocDR")) ; //13
	combindata=combindata+"^"+getJQValue($("#Status")) ; //14
	combindata=combindata+"^"+getJQValue($("#Remark")) ; //15
	/*
	combindata=combindata+"^"+getJQValue($("#UpdateUserDR")) ; //
	combindata=combindata+"^"+getJQValue($("#UpdateDate")) ; //
	combindata=combindata+"^"+getJQValue($("#UpdateTime")) ; //
	combindata=combindata+"^"+getJQValue($("#AuditUserDR")) ; //
	combindata=combindata+"^"+getJQValue($("#AuditDate")) ; //
	combindata=combindata+"^"+getJQValue($("#AuditTime")) ; //
	combindata=combindata+"^"+getJQValue($("#SubmitUserDR")) ; //
	combindata=combindata+"^"+getJQValue($("#SubmitDate")) ; //
	combindata=combindata+"^"+getJQValue($("#SubmitTime")) ; //*/
	combindata=combindata+"^"+getJQValue($("#MaintFee")) ; //16
	combindata=combindata+"^"+getJQValue($("#Hold1")) ; //17
	combindata=combindata+"^"+getJQValue($("#Hold2")) ; //18
	combindata=combindata+"^"+getJQValue($("#Hold3")) ; //19
	combindata=combindata+"^"+getJQValue($("#Hold4")) ; //20
	combindata=combindata+"^"+getJQValue($("#Hold5")) ; //21
	combindata=combindata+"^"+getJQValue($("#MeasureFlag")) ; //22
	combindata=combindata+"^"+getJQValue($("#MeasureDeptDR")) ; //23
	combindata=combindata+"^"+getJQValue($("#MeasureHandler")) ; //24
	combindata=combindata+"^"+getJQValue($("#MeasureTel")) ; //25
	combindata=combindata+"^"+getJQValue($("#MeasureUsers")) ; //26
	combindata=combindata+"^"+getJQValue($("#ServiceDR")) ; //27
	combindata=combindata+"^"+getJQValue($("#ServiceHandler")) ; //28
	combindata=combindata+"^"+getJQValue($("#ServiceTel")) ; //29
	combindata=combindata+"^"+getJQValue($("#ServiceUsers")) ; //30
	combindata=combindata+"^"+getJQValue($("#InvalidFlag")) ; //31
	combindata=combindata+"^"+getJQValue($("#CertificateValidityDate")) ; //32
	combindata=combindata+"^"+getJQValue($("#CertificateNo")) ; //33	Mozy0193	20170817
	/*
	combindata=combindata+"^"+getJQValue($("#DelUserDR")) ; //
	combindata=combindata+"^"+getJQValue($("#DelDate")) ; //
	combindata=combindata+"^"+getJQValue($("#DelTime")) ; //*/
	return combindata;
}
/*
 *Description:设备名称数据回调函数
 *author:limm
*/
function GetEquip(rowData) 
{
	setJQValue($("#Equip"),rowData.Name,"text");
	setJQValue($("#EquipDR"),rowData.RowID);
	setJQValue($("#UseLoc"),rowData.UseLoc,"text");
	setJQValue($("#UseLocDR"),rowData.UseLocDR);
	
	FillEquipData()
	//setJQValue($("#UseLocDR"),equiplist[18]);
	/*
	setJQValue($("#NameB"),rowData.Name);
	setJQValue($("#NoB"),rowData.No);
	setJQValue($("#ModelB"),rowData.Model);
	setJQValue($("#UseLocB"),rowData.UseLoc);
	setJQValue($("#ManuFactoryB"),rowData.ManuFactory);
	setJQValue($("#LeaveFactoryNoB"),rowData.LeaveFactoryNo);
	setJQValue($("#OriginalFeeB"),rowData.OriginalFee);
	setJQValue($("#NetFeeB"),rowData.NetFee);
	setJQValue($("#StatusB"),rowData.Status);*/
	
}
/*
 *Description:保养记录数据填充
 *author:limm
*/

function FillData()
{
	
	var RowID=getJQValue($("#RowID"));
  	if (RowID=="") return;
  	//var RowID=5
	var list = tkMakeServerCall("web.DHCEQMaintNew", "GetOneMaint",RowID);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");


	var sort=42;
	setJQValue($("#EquipDR"),list[0]);
	setJQValue($("#BussType"),list[1]);
	setJQValue($("#PlanNameDR"),list[2]);
	setJQValue($("#MaintTypeDR"),list[3]);
	setJQValue($("#MaintDate"),list[4]);
	setJQValue($("#MaintLocDR"),list[5]);
	setJQValue($("#MaintUserDR"),list[6]);
	setJQValue($("#MaintModeDR"),list[7]);
	setJQValue($("#TotalFee"),list[8]);
	if(list[9]=="Y") $("#NormalFlag").prop("checked","checked")
	setJQValue($("#ManageLocDR"),list[10]);
	setJQValue($("#UseLocDR"),list[11]);
	setJQValue($("#Status"),list[12]);
	setJQValue($("#Remark"),list[13]);
	/*
	setJQValue($("#UpdateUserDR",list[0]);
	setJQValue($("#UpdateDate",list[0]);
	setJQValue($("#UpdateTime",list[0]);
	setJQValue($("#AuditUserDR",list[0]);
	setJQValue($("#AuditDate",list[0]);
	setJQValue($("#AuditTime",list[0]);
	setJQValue($("#SubmitUserDR",list[0]);
	setJQValue($("#SubmitDate",list[0]);
	setJQValue($("#SubmitTime",list[0]);
	*/
	setJQValue($("#MaintFee"),list[23]);
	setJQValue($("#Hold1"),list[24]);
	setJQValue($("#Hold2"),list[25]);
	setJQValue($("#Hold3"),list[26]);
	setJQValue($("#Hold4"),list[27]);
	setJQValue($("#Hold5"),list[28]);
	if(list[29]=="Y") $("#MeasureFlag").prop("checked","checked")
	setJQValue($("#MeasureDeptDR"),list[30]);
	setJQValue($("#MeasureHandler"),list[31]);
	setJQValue($("#MeasureTel"),list[32]);
	setJQValue($("#MeasureUsers"),list[33],"text");
	setJQValue($("#ServiceDR"),list[34]);
	setJQValue($("#ServiceHandler"),list[35]);
	setJQValue($("#ServiceTel"),list[36]);
	setJQValue($("#ServiceUsers"),list[37]);
	if(list[38]=="Y") $("#InvalidFlag").prop("checked","checked")
	/*
	setJQValue($("#DelUserDR",list[0]);
	setJQValue($("#DelDate",list[0]);
	setJQValue($("#DelTime",list[0]);*/
	setJQValue($("#Equip"),list[sort+0],"text")
	setJQValue($("#PlanName"),list[sort+2],"text")
	setJQValue($("#MaintType"),list[sort+3],"text")
	setJQValue($("#MaintLoc"),list[sort+4],"text")
	setJQValue($("#MaintUser"),list[sort+5],"text")
	setJQValue($("#MaintMode"),list[sort+6],"text")
	setJQValue($("#ManageLoc"),list[sort+7],"text")
	setJQValue($("#UseLoc"),list[sort+8],"text")
	setJQValue($("#MeasureDept"),list[sort+13])
	setJQValue($("#Service"),list[sort+14],"text")
	setJQValue($("#CertificateValidityDate"),list[sort+16])
	setJQValue($("#CertificateNo"),list[sort+17])	//Mozy0193	20170817 
	//setJQValue($("#ModelDR",list[sort+17])
	//setJQValue($("#Model",list[sort+18])
	
}
/*
 *Description:设备数据填充
 *author:limm
*/

function FillEquipData()
{
	var EquipID=getJQValue($("#EquipDR"));
  	if (EquipID=="") return;
  	//var RowID=5
	var equiplist = tkMakeServerCall("web.DHCEQEquip","GetEquipByID",'','',EquipID);
	
	equiplist=equiplist.replace(/\ +/g,"")	//去掉空格
	equiplist=equiplist.replace(/[\r\n]/g,"")	//去掉回车换行
	equiplist=equiplist.split("^");
	var sort=95
	
	
	setJQValue($("#NameB"),equiplist[sort+36]);
	setJQValue($("#NoB"),equiplist[70]);
	setJQValue($("#ModelB"),equiplist[sort+0]);
	setJQValue($("#UseLocB"),equiplist[sort+7]);
	setJQValue($("#ManuFactoryB"),equiplist[sort+13]);
	setJQValue($("#LeaveFactoryNoB"),equiplist[9]);
	setJQValue($("#OriginalFeeB"),equiplist[26]);
	setJQValue($("#NetFeeB"),equiplist[27]);
	setJQValue($("#StatusB"),equiplist[sort+29]);
}
/*
 *Description:保养记录提交事件
 *author:limm
*/

function BSubmit_Click()
{
	
	var RowID=getJQValue($("#RowID"));
  	if (RowID=="") return;
	var MaintPlanDR=getJQValue($("#MaintPlanDR"));
	var EquipDR=getJQValue($("#EquipDR"));
	var PlanNameDR=getJQValue($("#PlanNameDR"));  
	var Remark=getJQValue($("#Remark"));
	var MaintDate=getJQValue($("#MaintDate"));
	if (MaintDate=="")
	{
		alertShow("检查日期不能为空！");
		return;
	}
	if (PlanNameDR!="") 
	{
		var truthBeTold = window.confirm("是否执行上次计划执行清单中设备？");	
	if (!truthBeTold) var PlanNameDR="";
	}
	var Rtn = tkMakeServerCall("web.DHCEQMaintNew", "SubmitData",RowID,'',EquipDR,Remark,PlanNameDR);
	if (Rtn<0) 
	{
		alertShow("保存失败！");
		return;	
	}
	
    parent.location.href= "dhceq.process.maint.csp?&RowID="+Rtn+"&EquipDR="+getJQValue($("#EquipDR"))+"&BussType="+getJQValue($("#BussType"))+"&MaintTypeDR="+getJQValue($("#MaintTypeDR"));
	
}
/*
 *Description:按钮灰化事件
 *author:limm
*/
function SetEnabled()
{
	
	var Status=getJQValue($("#Status"));
	if (Status=="")
	{
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BPicture").linkbutton("disable")
		jQuery("#BPMReport").linkbutton("disable")
		jQuery("#BMaintPlanItem").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BPicture").unbind();
		jQuery("#BPMReport").unbind();
		jQuery("#BMaintPlanItem").unbind();
		
	}
	else if (Status=="0")
	{
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
	}	
	else 
	{
		
		jQuery("#BUpdate").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BUpdate").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BCancelSubmit").unbind();
		
	}
	
}
/*
 *Description:保养记录删除事件
 *author:limm
*/

function BDelete_Click()
{
	var RowID=getJQValue($("#RowID"));
  	if (RowID=="") return;
	var truthBeTold = window.confirm("您确认要删除该记录吗?");	
	if (!truthBeTold) return;
	
	var Rtn = tkMakeServerCall("web.DHCEQMaintNew","DeleteData",RowID);
	
	if (Rtn!=0) 
	{
		alertShow("保存不成功！");
		return;	
	}
	
    parent.location.href= "dhceq.process.maint.csp?&MaintTypeDR="+getJQValue($("#MaintTypeDR"));
}
/*
 *Description:保养记录作废事件
 *author:limm
*/
function BCancelSubmit_Click()
{

	var RowID=getJQValue($("#RowID"));
  	if (RowID=="") return;	
	var Rtn = tkMakeServerCall("web.DHCEQMaintNew","CancelSubmitData",RowID);	
	if (Rtn<0) 
	{
		alertShow("状态已经为提交!");
		return;	
	}
    parent.location.href= "dhceq.process.maint.csp?&BussType="+getJQValue($("#BussType"))+"&MaintTypeDR="+getJQValue($("#MaintTypeDR"));		//2011-08-29 HZY0005 

	
}
/*
 *Description:图片上传链接界面
 *author:limm
*/
function BPicture_Click()
{
	if (getJQValue($("#RowID"))=="") return; 
	if (getJQValue($("#EquipDR"))=="") {alertShow("请选择设备");return}
	var Status=getJQValue($("#Status"))
	var str='dhceq.process.picturemenu.csp?&CurrentSourceType=32&CurrentSourceID='+getJQValue($("#RowID"))+'&EquipDR='+getJQValue($("#EquipDR"))+"&Status="+Status;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	
}
/*
 *Description:pm报告打印链接界面
 *author:limm
*/
function BPMReport_Click()
{
	if (getJQValue($("#RowID"))=="") return; 
	if (getJQValue($("#EquipDR"))=="") {alertShow("请选择设备");return}
	var Status=getJQValue($("#Status"))
	var ReadOnly=getJQValue($("#ReadOnly"))
	var str='dhceq.process.pmreport.csp?&MaintDR='+getJQValue($("#RowID"))+"&ReadOnly="+ReadOnly;
	//window.open(str,'_blank','left=0,top=0,width='+ (screen.availWidth - 10) +',height='+ (screen.availHeight-50) +',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	
	
}
/*
 *Description:根据计划名称填充数据
 *author:limm
*/
function GetPlanNameID(value)
{
	var PlanNameDR=getJQValue($("#PlanNameDR"))
	if (PlanNameDR=="")  return
	
	var Rtn = tkMakeServerCall("web.DHCEQMaintPlanNew","GetOneMaintPlan",PlanNameDR);
	
	Rtn=Rtn.replace(/\\n/g,"\n");
	var list=Rtn.split("^");
	var sort=50;	//DHC_EQMaintPlan  44
	setJQValue($("#PlanName"),list[0],"text");
	setJQValue($("#ModelDR"),list[4]);
	setJQValue($("#MaintTypeDR"),list[8]);
	setJQValue($("#MaintFee"),list[12]);
	setJQValue($("#MaintLocDR"),list[13]);
	setJQValue($("#MaintUserDR"),list[14]);
	setJQValue($("#MaintModeDR"),list[15]);
	if(list[17]=="Y") $("#MeasureFlag").prop("checked","checked")
	setJQValue($("#MeasureDeptDR"),list[18]);
	setJQValue($("#MeasureHandler"),list[19]);
	setJQValue($("#MeasureTel"),list[20]);
	setJQValue($("#ServiceDR"),list[21]);
	setJQValue($("#ServiceHandler"),list[22]);
	setJQValue($("#ServiceTel"),list[23]);
	setJQValue($("#Remark"),list[24]);
	if(list[35]=="Y") $("#InvalidFlag").prop("checked","checked")
	setJQValue($("#MaintType"),list[sort+4],"text");
	setJQValue($("#MaintLoc"),list[sort+5],"text");
	setJQValue($("#MaintUser"),list[sort+6],"text");
	setJQValue($("#MaintMode"),list[sort+7],"text");
	setJQValue($("#MeasureDept"),list[sort+9],"text");
	setJQValue($("#Service"),list[sort+10],"text");
}


//add by lmm 2018-02-02
//表单元素获取
//入参说明：
//		name:表单元素id 
//返回值：表单元素具体值
function GetElementValue(vElementID)
{
	var result=""
	var obj=document.getElementById(vElementID);
	if (!obj) return ""
	var objType=jQuery("#"+vElementID).prop("type")  //prop
	var objClassInfo=jQuery("#"+vElementID).prop("class")	
	if (objType=="checkbox")
	{
		//result=jQuery("#"+vElementID).is(':checked')
		result=jQuery("#"+vElementID).checkbox("getValue",true);
	}
	else if (objType=="select-one")
	{
		result=jQuery("#"+vElementID).combobox("getValue");
	}
	else if (objType=="text")
	{
		//var objClass=objClassInfo.split(" ")
		//var objType=objClass[0].split("-")
		if (objClassInfo.indexOf("combogrid")>=0)
		{
			result=jQuery("#"+vElementID).combogrid("getText");
		}
		else if (objClassInfo.indexOf("datebox-f")>=0)
		{
			result=jQuery("#"+vElementID).datebox('getText');
		}
		else if (objClassInfo.indexOf("combobox")>=0)
		{
			result=jQuery("#"+vElementID).combobox("getValue");
		}
		else
		{
			result=jQuery("#"+vElementID).val()
				
		}
		
	}
	else  //textarea,text,hidden
	{
			result=jQuery("#"+vElementID).val()
		

	}
	return result
}


