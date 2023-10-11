var t=[]
t[-9201]="不能为空"
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	setRequiredElements("MTEquip^MTMaintDate")
	initUserInfo();
	defindTitleStyle();
	initButton();
	//initButtonWidth();	MZY0123	2612988		2022-05-12
	initLookUp();
	initTopPanel();
	initPicAndAppendFile();
	FillData();
	FillEquipData();
	SetEnabled();
	initTemplateList(getElementValue("PMRTemplateDR"),"5",getElementValue("MTEquipDR"),"");  //生成模板信息
};
//初始化查询头面板
function initTopPanel()
{
	jQuery("#BPMReport").on("click", BPMReport_Click);
	jQuery("#BDetail").on("click", EquipInfo);		// MZY0123	2612988		2022-05-12
	$("#MTPlanName").lookup({"onBeforeShowPanel":function(){
	    if ($("#MTEquipDR").val()=="") {
	        messageShow("popover","","","请先选择设备!");
	        setElement("MTPlanName","");
	        setFocus("MTEquip");
	    	return false;    
	    }
	}
	});
}
/*
 *Description:保养记录提交事件
 *author:limm
*/
function BSubmit_Clicked()
{
	var RowID=getElementValue("MTRowID");
  	if (RowID=="") return;
	//var MaintPlanDR=getElementValue("MaintPlanDR");
	var EquipDR=getElementValue("MTEquipDR");
	var PlanNameDR=getElementValue("MTPlanNameDR"); 
	var PERowID=getElementValue("PELPlanExecuteDR");
	//var Remark=getElementValue("Remark");
	var MaintDate=getElementValue("MTMaintDate");
	var BussType=getElementValue("MTType");
	if (MaintDate=="")
	{
		alertShow("保养日期不能为空！");
		return;
	}
	if (PERowID!="")
	{
		messageShow("confirm","","","点击【确定】执行上次计划执行，点击“取消”单独手工记录","",function(){
			SubmitData(RowID,PERowID,BussType,EquipDR,"N")  
			},
			function(){
				SubmitData(RowID,PERowID,BussType,EquipDR,"Y")
			});
	}
	else
	{
		SubmitData(RowID,PERowID,BussType,EquipDR,"Y")
	}
}
function SubmitData(RowID,PERowID,BussType,EquipDR,CancelFlag){	
	//PERowID, MaintRowID, EquipID, BussType
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SubmitData",RowID,PERowID,BussType,EquipDR,"",CancelFlag);
	if (Rtn<0) 
	{
		alertShow("保存失败！");
		return;	
	}
	if ((getElementValue("MTType")==2)&&(getElementValue("MTMaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("MTType")==1)
	{
		var url="dhceq.em.preventivemaint.csp";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
	url+="?&RowID="+Rtn+"&EquipDR="+getElementValue("MTEquipDR")+"&BussType="+getElementValue("MTType")+"&MaintTypeDR="+getElementValue("MTMaintTypeDR");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}
function BDelete_Clicked()
{
	var RowID=getElementValue("MTRowID");
  	if (RowID=="") return;
	messageShow("confirm","","","您确认要删除该记录吗?","",DeleteData,"");
}

function DeleteData()
{
	var RowID=getElementValue("MTRowID");
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint","DeleteData",RowID);
	if (Rtn!=0) 
	{
		alertShow("保存不成功！");
		return;	
	}
	if ((getElementValue("MTType")==2)&&(getElementValue("MTMaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("MTType")==1)
	{
		var url="dhceq.em.preventivemaint.csp";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
	url+="?&BussType="+getElementValue("MTType")+"&MaintTypeDR="+getElementValue("MTMaintTypeDR");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
function BCancel_Clicked()
{
	var RowID=getElementValue("MTRowID");
  	if (RowID=="") return;	
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaint","CancelSubmitData",RowID, getElementValue("PELPlanExecuteListDR"));
	if (Rtn<0) 
	{
		alertShow("状态已经为提交!");
		return;	
	}
	if ((getElementValue("MTType")==2)&&(getElementValue("MTMaintTypeDR")==5))
	{
		var url="dhceq.em.meterage.csp?";
	}
	else if (getElementValue("MTType")==1)
	{
		var url="dhceq.em.preventivemaint.csp";
	}	
	else
	{
		var url="dhceq.em.inspect.csp?";
	}
	url+="?&BussType="+getElementValue("MTType")+"&MaintTypeDR="+getElementValue("MTMaintTypeDR"); 
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}
function FillData()
{
	var EquipDR=getElementValue("MTEquipDR");
	if (EquipDR!="")
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    			setElement("MTEquip",jsonData.Data["EQName"]);
				setElement("MTUseLocDR",jsonData.Data["EQUseLocDR"]);
				setElement("MTUseLocDR_CTLOCDesc",jsonData.Data["EQUseLocDR_CTLOCDesc"]);
		});
		var Result=tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetRangSourceByEquip",EquipDR,"3",getElementValue("MTType"));
		var list=Result.split("^");
		setElement("PMRTemplateDR",list[0]);
	}
	if (getElementValue("PELPlanExecuteDR")!="")
	{
		var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetPlanExecuteByID", getElementValue("PELPlanExecuteDR"))
		var list=Result.split("^");
		setElement("MTPlanExecute",list[0]);
		setElement("MTSourceID",list[1]);	//MTMaintPlanDR
		setElement("MTMaintUserDR",list[8]);
		setElement("MTPlanName",list[15]);
		setElement("MTMaintUserDR_SSUSRName",list[19]);
	}
	var RowID=getElementValue("MTRowID");
	if (RowID=="") return;
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMaint","GetOneMaintNew",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}
function EquipInfo()
{
	if (getElementValue("MTEquipDR")=="") {alertShow("请选择设备");return}
	var ToolBarFlag="0";
	var LifeInfoFlag="0"
	var DetailListFlag="1"
	var winHeight=650;
	if($(document.body).height()<650) winHeight="100%"
	var str="dhceq.em.equip.csp?&RowID="+getElementValue("MTEquipDR")+"&ReadOnly=1&ToolBarFlag="+ToolBarFlag+"&LifeInfoFlag="+LifeInfoFlag+"&DetailListFlag="+DetailListFlag;
	showWindow(str,"台帐详细界面","","","icon-w-paper","","","","verylarge")    
}
function SetEnabled()
{
	var Status=getElementValue("MTStatus");
	if (Status=="")
	{
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancel").linkbutton("disable")
		jQuery("#BPMReport").linkbutton("disable")
		jQuery("#BCancel").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BPMReport").unbind();
		$('div.datagrid div.datagrid-toolbar').hide();
	}
	else if (Status=="0")
	{
		jQuery("#BCancel").linkbutton("disable")
		jQuery("#BCancel").unbind();
	}
	else if (Status=="2")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
	}
	else 
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BCancel").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BCancel").unbind();
	}
}
/*function BPMReport_Click()
{
	if (getElementValue("MTRowID")=="") return; 
	if (getElementValue("MTEquipDR")=="") {alertShow("请选择设备");return}
	var Status=getElementValue("MTStatus")
	var ReadOnly=getElementValue("ReadOnly")
	var str='dhceq.em.pmreport.csp?&MaintDR='+getElementValue("MTRowID")+"&ReadOnly="+ReadOnly;
	showWindow(str,"PM报告打印","","","icon-w-paper","modal","","","large");
	
}*/
function initPicAndAppendFile()
{
	$HUI.datagrid("#tDHCEQPicAndAppendFile",{
		//界面原型不做后台调用
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Lib.Common",
	        QueryName:"GetAppendFileAndPic",
	        SourceType:"32",
			SourceID:getElementValue("MTRowID"),
	    },
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,
    	columns:[[
    		{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
    		{field:'TSourceType',title:'TSourceType',width:0,align:'center',hidden:true},
    		{field:'TSourceID',title:'TSourceID',width:0,align:'center',hidden:true},
    		{field:'TPicTypeDR',title:'TPicTypeDR',width:0,align:'center',hidden:true},
	        {field:'TPicType',title:'类型',width:'200',align:'center'},
	        {field:'TName',title:'名称',width:200,align:'center'}, 
	        {field:'TFileType',title:'TFileType',width:0,align:'center',hidden:true},
	        {field:'TFlag',title:'TFlag',width:0,align:'center',hidden:true},
	       	{field:'TToSwfFlag',title:'TToSwfFlag',width:0,align:'center',hidden:true},
	        {field:'TFlag',title:'TFlag',width:0,align:'center',hidden:true},
	        {field:'TOpt',title:'预览',width:100,align:'center',formatter: fomartOperation},
	        {field:'TDownLoad',title:'下载',width:100,align:'center',formatter: fomartDownLoad}  //modified by zc0107 2021-11-14 2046917 	           
	    ]],
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:
    	[{
            iconCls: 'icon-upload-cloud',
            text:'上传图片',
            handler: function(){
                UpLoadPic()
            }},
            {
            iconCls: 'icon-upload-cloud',
            text:'上传电子资料',
            handler: function(){
                 UpLoadAppendFile()
            }
        }],
		onDblClickRow:function(rowIndex, rowData){},
		onLoadSuccess: function (data) {}
	});
}
function getPicType()
{
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu",32,"")
	window.eval("var PicTypes = " + PicTypesJson);
	var childdatainfo=""
	for (var i=0;i<PicTypes.length;i++)
	{
		var childinfo="{id:'"+PicTypes[i].id+"',text:'"+PicTypes[i].text.replace("<span style='color:red'>*</span>","")+"'}"
		if (childdatainfo!="") childdatainfo=childdatainfo+","
		childdatainfo=childdatainfo+childinfo
	}
	return "[{id:0,text:'请选择'},"+childdatainfo+"]"
}
function UpLoadPic()
{
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=32&CurrentSourceID='+getElementValue("MTRowID")+'&EquipDR='+getElementValue("EquipDR")+'&Status='+getElementValue("MTStatus")+'&ReadOnly='+getElementValue("ReadOnly");
	showWindow(str,"上传图片","","","icon-w-paper","modal","","","middle");
}
function UpLoadAppendFile()
{
	var Status=getElementValue("MTStatus");
	var url='dhceq.plat.appendfile.csp?&CurrentSourceType=32&CurrentSourceID='+getElementValue("MTRowID")+'&Status='+Status+'&ReadOnly='+getElementValue("ReadOnly");
	showWindow(url,"电子资料","","","icon-w-paper","modal","","","large");
}
function fomartOperation(value,row,index){
	if (row.TFlag=="File")
	{
		if ((row.TToSwfFlag!="Y")&&(row.TFileType!="pdf"))
		{
			var ftpappendfilename=row.TRowID+"."+row.TFileType;
			var btn ='<a href="#" onclick="AppendFileSwitchAndView(&quot;'+ftpappendfilename+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png"/></a>'; 
		}
		else
		{
			var btn ='<A onclick="showWindow(&quot;dhceq.process.appendfileview.csp?RowID='+row.TRowID+'&ToSwfFlag=Y&quot;,&quot;文件预览&quot;,&quot;&quot;,&quot;&quot;,&quot;icon-w-paper&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png"/></A>';
		}
	}
	else
	{
		var btn ='<A onclick="showWindow(&quot;dhceq.plat.pictureview.csp?PTRowID='+row.TRowID+'&SourceType=32&SourceID='+getElementValue("MTRowID")+'&ReadOnly=1&quot;,&quot;图片预览&quot;,&quot;&quot;,&quot;&quot;,&quot;icon-w-paper&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png"/></A>';
	}
	return btn;
}

function AppendFileSwitchAndView(ftpappendfilename){
	var DHCEQTomcatServer=getElementValue("DHCEQTomcatServer")
	var url=DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename;
	showWindow(url,"文件预览","","","icon-w-paper","modal","","","large");
}
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=getTemplateListValue();
	var jsonData = tkMakeServerCall("web.DHCEQ.EM.BUSMaint", "SaveDataNew",data,dataList,curUserID);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','提示',jsonData.Data);
		return;
	}
	else
	{
		alertShow("保存成功！");
		if ((getElementValue("MTType")==2)&&(getElementValue("MTMaintTypeDR")==5))
		{
			var url="dhceq.em.meterage.csp?";
		}
		else if (getElementValue("MTType")==1)
		{
			var url="dhceq.em.preventivemaint.csp";
		}
		else
		{
			var url="dhceq.em.inspect.csp?";
		}
		url+="?&RowID="+jsonData.Data+"&EquipDR="+getElementValue("MTEquipDR")+"&BussType="+getElementValue("MTType")+"&MaintTypeDR="+getElementValue("MTMaintTypeDR");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
}

/*
 *Description:检测有效数据
 *author:limm
*/
function CheckInvalidData()
{
	if (IsValidateNumber(getElementValue("MaintFee"),1,1,0,1)==0)
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
	combindata=getElementValue("MTRowID") ; //1
	combindata=combindata+"^"+getElementValue("EquipDR") ; //2
	combindata=combindata+"^"+getElementValue("BussType") ; //3
	combindata=combindata+"^"+getElementValue("PlanNameDR") ; //4
	combindata=combindata+"^"+getElementValue("MaintTypeDR") ; //5
	combindata=combindata+"^"+getElementValue("MaintDate") ; //6
	combindata=combindata+"^"+getElementValue("MaintLocDR") ; //7
	combindata=combindata+"^"+getElementValue("MaintUserDR") ; //8
	combindata=combindata+"^"+getElementValue("MaintModeDR") ; //9
	combindata=combindata+"^"+getElementValue("TotalFee") ; //10
	combindata=combindata+"^"+getElementValue("NormalFlag") ; //11
	combindata=combindata+"^"+getElementValue("ManageLocDR") ; //12
	combindata=combindata+"^"+getElementValue("UseLocDR") ; //13
	combindata=combindata+"^"+getElementValue("Status") ; //14
	combindata=combindata+"^"+getElementValue("Remark") ; //15
	/*
	combindata=combindata+"^"+getElementValue("UpdateUserDR") ; //
	combindata=combindata+"^"+getElementValue("UpdateDate") ; //
	combindata=combindata+"^"+getElementValue("UpdateTime") ; //
	combindata=combindata+"^"+getElementValue("AuditUserDR") ; //
	combindata=combindata+"^"+getElementValue("AuditDate") ; //
	combindata=combindata+"^"+getElementValue("AuditTime") ; //
	combindata=combindata+"^"+getElementValue("SubmitUserDR") ; //
	combindata=combindata+"^"+getElementValue("SubmitDate") ; //
	combindata=combindata+"^"+getElementValue("SubmitTime") ; //*/
	combindata=combindata+"^"+getElementValue("MaintFee") ; //16
	combindata=combindata+"^"+getElementValue("ContractDR") ; //17  Hold1改为合同
	combindata=combindata+"^"+getElementValue("Hold2") ; //18
	combindata=combindata+"^"+getElementValue("Hold3") ; //19
	combindata=combindata+"^"+getElementValue("Hold4") ; //20
	combindata=combindata+"^"+getElementValue("Hold5") ; //21
	combindata=combindata+"^"+getElementValue("MeasureFlag") ; //22
	combindata=combindata+"^"+getElementValue("MeasureDeptDR") ; //23
	combindata=combindata+"^"+getElementValue("MeasureHandler") ; //24
	combindata=combindata+"^"+getElementValue("MeasureTel") ; //25
	combindata=combindata+"^"+getElementValue("MeasureUsers") ; //26
	combindata=combindata+"^"+getElementValue("ServiceDR") ; //27
	combindata=combindata+"^"+getElementValue("ServiceHandler") ; //28
	combindata=combindata+"^"+getElementValue("ServiceTel") ; //29
	combindata=combindata+"^"+getElementValue("ServiceUsers") ; //30
	combindata=combindata+"^"+getElementValue("InvalidFlag") ; //31
	combindata=combindata+"^"+getElementValue("CertificateValidityDate") ; //32
	combindata=combindata+"^"+getElementValue("CertificateNo") ; //33
	combindata=combindata+"^"+getElementValue("PlanExecuteDR") ; //34 计划执行单ID

	/*
	combindata=combindata+"^"+getElementValue("DelUserDR") ; //
	combindata=combindata+"^"+getElementValue("DelDate") ; //
	combindata=combindata+"^"+getElementValue("DelTime") ; //*/
	//alertShow(combindata)
	return combindata;
}
function setSelectValue(vElementID,rowData)
{
	if(vElementID=="MTEquip")
	{
		setElement("MTEquipDR",rowData.TRowID);
		setElement("MTEquip",rowData.TName);
		setElement("MTUseLocDR",rowData.TUseLocDR);
		setElement("MTUseLocDR_CTLOCDesc",rowData.TUseLoc);
		var Str=tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetRangSourceByEquip",rowData.TRowID,"3",getElementValue("MTType"));
		var Info=Str.split("^");
		setElement("PMRTemplateDR",Info[0]);
		FillEquipData();
		initTemplateList(getElementValue("PMRTemplateDR"),"5",getElementValue("MTEquipDR"),"");
	}
	else if(vElementID=="MTPlanName")
	{
		setElement("MTSourceID",rowData.TRowID);
		setElement("MTPlanName",rowData.TName);
		var PlanNameDR=getElementValue("MTSourceID")
		if (PlanNameDR=="")  return
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetOneMaintPlan",PlanNameDR);
		Rtn=Rtn.replace(/\\n/g,"\n");
		var list=Rtn.split("^");
		var sort=50;	//DHC_EQMaintPlan  44
		setElement("PlanName",list[0]);
		setElement("ModelDR",list[4]);
		setElement("MaintTypeDR",list[8]);
		setElement("MaintFee",list[12]);
		setElement("MaintLocDR",list[13]);
		setElement("MaintUserDR",list[14]);
		setElement("MaintModeDR",list[15]);
		setElement("MeasureFlag",list[17]);
		setElement("MeasureDeptDR",list[18]);
		setElement("MeasureHandler",list[19]);
		setElement("MeasureTel",list[20]);
		setElement("ServiceDR",list[21]);
		setElement("ServiceHandler",list[22]);
		setElement("ServiceTel",list[23]);
		setElement("Remark",list[24]);
		setElement("InvalidFlag",list[35]);
		setElement("MaintType",list[sort+4]);
		setElement("MaintLoc",list[sort+5]);
		setElement("MaintUser",list[sort+6]);
		setElement("MaintMode",list[sort+7]);
		setElement("MeasureDept",list[sort+9]);
		setElement("Service",list[sort+10]);
	}
	else if(vElementID=="MTPlanExecute")
	{
		setElement("PELPlanExecuteDR",rowData.TPlanExecuteID);
		setElement("MTPlanExecute",rowData.TPlanExecuteNo);
	}
	else if(vElementID=="MTMaintTypeDR_MTDesc")
	{
		setElement("MTMaintTypeDR",rowData.TRowID);
		setElement("MTMaintTypeDR_MTDesc",rowData.TDesc);
	}
	else if(vElementID=="MTMaintModeDR_MMDesc")
	{
		setElement("MTMaintModeDR",rowData.TRowID);
		setElement("MTMaintModeDR_MMDesc",rowData.TDesc);
	}
	else if(vElementID=="MTMaintUserDR_SSUSRName")
	{
		setElement("MTMaintUserDR",rowData.TRowID);
		setElement("MTMaintUserDR_SSUSRName",rowData.TName);
	}
	else if(vElementID=="MTMaintLocDR_CTLOCDesc")
	{
		setElement("MTMaintLocDR",rowData.TRowID);
		setElement("MTMaintLocDR_CTLOCDesc",rowData.TName);
	}
	else if(vElementID=="MTUseLocDR_CTLOCDesc")
	{
		setElement("MTUseLocDR",rowData.TRowID);
		setElement("MTUseLocDR_CTLOCDesc",rowData.TName);
	}
	else if(vElementID=="MTServiceDR_SVName")
	{
		setElement("MTServiceDR",rowData.TRowID);
		setElement("MTServiceDR_SVName",rowData.TDescription);
		setElement("MTServiceHandler",rowData.TContPerson);
		setElement("MTServiceTel",rowData.TTel);
	}
	else
	{
		setElement(vElementID+"DR",rowData.TRowID);
	}
}
// onChange清除事件
function clearData(vElementID)
{
	if($("#"+vElementID+"DR").length>0)
	{
		setElement(vElementID+"DR","");	//统一清除DR
		
		if(vElementID=="MTEquip")
		{
			setElement("MTUseLocDR","")
			setElement("MTUseLocDR_CTLOCDesc","")
			FillEquipData()
		}
		else if(vElementID=="MTPlanName")
		{
			setElement("MTMaintTypeDR","");
			setElement("MTMaintFee","");
			setElement("MTMaintLocDR","");
			setElement("MTMaintUserDR","");
			setElement("MTMaintModeDR","");
			setElement("MTMeasureDeptDR","");
			setElement("MTMeasureHandler","");
			setElement("MTMeasureTel","");
			setElement("MTServiceDR","");
			setElement("MTServiceHandler","");
			setElement("MTServiceTel","");
			setElement("MTRemark","");
			setElement("MTMaintTypeDR_MTDesc","");
			setElement("MTMaintLocDR_CTLOCDesc","");
			setElement("MTMaintUserDR_SSUSRName","");
			setElement("MTMaintModeDR_MMDesc","");
			setElement("MTMeasureDept","");
			setElement("MTServiceDR_SVName","");
		}
	}
}

function GetEquipID(value) 
{
	var val=value.split("^");
	setElement("EquipDR",val[0]);
	setElement("Equip",val[1]);
	setElement("UseLocDR",val[2]);
	setElement("UseLoc",val[3]);
	FillEquipData();
}
function FillEquipData()
{
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("MTEquipDR"))
}
function BPMReport_Click()
{
	var PMReportDR=getElementValue("PMReportDR");
	if (PMReportDR=="") return;
	var PrintFlag=getElementValue("PrintFlag");	 			//打印方式标志位 excel：0  润乾:1
	var PreviewRptFlag=getElementValue("PreviewRptFlag"); 	//润乾预览标志 不预览 : 0  预览:1
	var HOSPDESC = curSSHospitalName;
	var filename="";
	if(PrintFlag==0)
	{
		MakeExcel();
	}
	if(PrintFlag==1)
	{ 
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQPMReport.raq(ReportDR="+PMReportDR
		    +";HOSPDESC="+HOSPDESC
		    +";curUserName="+curUserName
		    +")}";
	        DHCCPM_RQDirectPrint(fileName);
		}
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQPMReport.raq&ReportDR="+PMReportDR
		    +"&HOSPDESC="+HOSPDESC
		    +"&curUserName="+curUserName
			DHCCPM_RQPrint(fileName);
		}
	}
}
function MakeExcel()
{
	if (getElementValue("ChromeFlag")=="1")
	{
		MakeExcelChrome();
	}
	else
	{
		MakeExcelIE();
	}
}
function MakeExcelChrome()
{
	var pmtemplatedata;
	var Equiplist=tkMakeServerCall("web.DHCEQEquip","GetEquipByID","","",getElementValue("MTEquipDR"));		// MZY0078	1958704		2021-05-31
	Equiplist=Equiplist.split("^");
	var sort=95;
	jQuery.ajax({
	        url :"dhceq.jquery.csp",
	        type:"POST",
	        async: false,//同步请求
	        data:{
	            ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
	        	QueryName:"GetPMReportList",
	        	Arg1:getElementValue("PMReportDR"),
	        	ArgCnt:1
	         },
	         success:function (data, response, status) {
		        pmtemplatedata=jQuery.parseJSON(data);
		        pmtemplatedata.rows.sort(function(a,b){
	            return a.TMaintItemCatDR-b.TMaintItemCatDR})
	          }
	})
	var DataInfo=JSON.stringify(pmtemplatedata.rows)
	//Modify by zx 2021-05-28 模板获取
	var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")
	var Template=TemplatePath+"DHCEQPMReport.xls";
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var Template='"+Template+"';";
	Str +="var xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).value='"+Equiplist[0]+"';"; //EquipName
	Str +="xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).value='"+Equiplist[70]+"';"	//No
	Str +="xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(4,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).value='"+Equiplist[sort+0]+"';" //Model
	Str +="xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).value='"+Equiplist[9]+"';" //LeaveFactoryNo
	Str +="xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).value='"+Equiplist[sort+13]+"';" //生产厂商 ManuFactory
	Str +="xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).value='"+Equiplist[43]+"';"	//启用日期 StartDate
	Str +="xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).value='"+Equiplist[sort+7]+"';"	//使用科室 UseLoc
	Str +="xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).value='"+getElementValue("MTMaintDate")+"';" //pm周期
	Str +="xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).Borders.Weight = 2;"
	Str +="var oldindex,oldvalue;"
	Str +="var total="+pmtemplatedata.total+";"
	Str +="for (var Row=0;Row<total;Row++){"
	Str +="var OneInfo="+DataInfo+";"
	Str +="if (oldvalue==undefined){"
	Str +="oldindex=Row;"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;}"
	Str +="else if (OneInfo[Row].TMaintItemCatDR!=oldvalue){"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).value=OneInfo[Row-1].TMaintItemCatDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).Borders.Weight = 2;"
	Str +="oldindex=Row;"
	Str +="oldvalue=OneInfo[Row].TMaintItemCatDR;}"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).value=OneInfo[Row].TMaintItemDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,4)).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).value=OneInfo[Row].TResult;"
	Str +="xlsheet.Range(xlsheet.Cells(Row+8,5),xlsheet.Cells(Row+8,6)).Borders.Weight = 2;}"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).value=OneInfo[total-1].TMaintItemCatDesc;"
	Str +="xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+8,1).value='仪器现状'";
	Str +="xlsheet.Cells(total+8,1).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).value="+jQuery('#State').val()+";"
	Str +="xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+9,1).value='备注';"
	Str +="xlsheet.Cells(total+9,1).Borders.Weight = 2;"
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).mergecells=true;"
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).value="+jQuery('#Remark').val()+";"//备注
	Str +="xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,1).value='pm人员';"
	Str +="xlsheet.Cells(total+10,1).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,2).value='';"
	Str +="xlsheet.Cells(total+10,2).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,3).value='使用部门';"
	Str +="xlsheet.Cells(total+10,3).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,4).value='';"
	Str +="xlsheet.Cells(total+10,4).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,5).value='完成日期';"	
	Str +="xlsheet.Cells(total+10,5).Borders.Weight = 2;"
	Str +="xlsheet.Cells(total+10,6).value='';"	
	Str +="xlsheet.Cells(total+10,6).Borders.Weight = 2;"
	Str +="xlsheet.printout;"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
}
function MakeExcelIE()
{
	//alert("MakeExcelIE")
	var pmtemplatedata
	var Equiplist=getElementValue("EquipInfo").split("^");
	var sort=95;
	jQuery.ajax({
	        url :"dhceq.jquery.csp",
	        type:"POST",
	        async: false,//同步请求
	        data:{
	            ClassName:"web.DHCEQ.Process.DHCEQPMReportList",
	        	QueryName:"GetPMReportList",
	        	Arg1:getElementValue("PMReportDR"),
	        	ArgCnt:1
	         },
	         success:function (data, response, status) {
		         //JSON.parse( your_string );
		         pmtemplatedata=jQuery.parseJSON(data);
		         pmtemplatedata.rows.sort(function(a,b){
	             return a.TMaintItemCatDR-b.TMaintItemCatDR})
		         //eval("(" + str + ")");
	          }
	    })
	try {
        var xlApp,xlsheet,xlBook;
        // MZY0078	1958704		2021-05-31
	    var Template=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQPMReport.xls";
	    var Equiplist=tkMakeServerCall("web.DHCEQEquip","GetEquipByID","","",getElementValue("MTEquipDR"));
		Equiplist=Equiplist.split("^");
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.Rows.AutoFit;
	    //xlsheet.Columns.AutoFit;
	    //xlsheet.PageSetup.LeftMargin=0;
	    //xlsheet.PageSetup.RightMargin=0;
	    xlsheet.PageSetup.TopMargin=0;
	    
	    xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).value=Equiplist[0]; //EquipName
     	xlsheet.Range(xlsheet.Cells(3,2),xlsheet.Cells(3,3)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).mergecells=true;
     	//xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).value=Equiplist[70];	//No
     	xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(3,6)).value=Equiplist[84];	//FNo
     	xlsheet.Range(xlsheet.Cells(3,5),xlsheet.Cells(4,6)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).value=Equiplist[sort+0]; //Model
     	xlsheet.Range(xlsheet.Cells(4,2),xlsheet.Cells(4,3)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).value=Equiplist[9]; //LeaveFactoryNo
     	xlsheet.Range(xlsheet.Cells(4,5),xlsheet.Cells(4,6)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).value=Equiplist[sort+13] //生产厂商 ManuFactory
     	xlsheet.Range(xlsheet.Cells(5,2),xlsheet.Cells(5,3)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).value=FormatDate(Equiplist[43]);	//启用日期 StartDate
     	xlsheet.Range(xlsheet.Cells(5,5),xlsheet.Cells(5,6)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).value=Equiplist[sort+7]	//使用科室 UseLoc
     	xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,3)).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).value=getElementValue("MTMaintDate") //pm周期
     	xlsheet.Range(xlsheet.Cells(6,5),xlsheet.Cells(6,6)).Borders.Weight = 2;
	    //xlsheet.cells(row,8)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"; 
	    var oldindex,oldvalue;
	    var total=pmtemplatedata.total;
	    for (var Row=0;Row<total;Row++)
		{
			if(oldvalue==undefined)
			{
				oldindex=Row
     		 	oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
			}
			else if(pmtemplatedata.rows[Row].TMaintItemCatDR!=oldvalue)
			{
				oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
				xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).mergecells=true;
				xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).HorizontalAlignment=-4108;	// 水平居中
				xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).VerticalAlignment=-4108;		// 垂直居中
     		 	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).value=pmtemplatedata.rows[Row-1].TMaintItemCatDesc;
     		 	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(Row+7,1)).Borders.Weight = 2;
     		 	oldindex=Row
     		 	oldvalue=pmtemplatedata.rows[Row].TMaintItemCatDR
			}
			else
			{
			}
			//  设置单元格内容自动换行 range.WrapText  =  true  ;
            //  设置单元格内容水平对齐方式 range.HorizontalAlignment  =  Excel.XlHAlign.xlHAlignCenter;//设置单元格内容竖直堆砌方式
            //  range.VerticalAlignment=Excel.XlVAlign.xlVAlignCenter
            //  range.WrapText  =  true;  xlsheet.Rows(3).WrapText=true  自动换行
            //  for(mn=1,mn<=6;mn++) .     xlsheet.Range(xlsheet.Cells(1, mn), xlsheet.Cells(i1, j)).Columns.AutoFit;
     		
     		xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,5)).mergecells=true;
			//xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,5)).WrapText=true;
			xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,5)).VerticalAlignment=-4108;		// 垂直居中
     		xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,5)).value=pmtemplatedata.rows[Row].TMaintItemDesc;
     		
     		xlsheet.Range(xlsheet.Cells(Row+8,2),xlsheet.Cells(Row+8,5)).Borders.Weight = 2;
     		xlsheet.Range(xlsheet.Cells(Row+8,6),xlsheet.Cells(Row+8,6)).mergecells=true;
     		xlsheet.Range(xlsheet.Cells(Row+8,6),xlsheet.Cells(Row+8,6)).HorizontalAlignment=-4108;		// 水平居中
     		xlsheet.Range(xlsheet.Cells(Row+8,6),xlsheet.Cells(Row+8,6)).VerticalAlignment=-4108;		// 垂直居中
     		xlsheet.Range(xlsheet.Cells(Row+8,6),xlsheet.Cells(Row+8,6)).value=pmtemplatedata.rows[Row].TResult;
     		xlsheet.Range(xlsheet.Cells(Row+8,6),xlsheet.Cells(Row+8,6)).Borders.Weight = 2;
	    }
	    xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).mergecells=true;
	    xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).HorizontalAlignment=-4108;	// 水平居中
	    xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).VerticalAlignment=-4108;	// 垂直居中
     	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).value=pmtemplatedata.rows[total-1].TMaintItemCatDesc;
     	xlsheet.Range(xlsheet.Cells(oldindex+8,1),xlsheet.Cells(total+7,1)).Borders.Weight = 2;
     	
		xlsheet.Cells(total+8,1).value="仪器现状";
		xlsheet.Cells(total+8,1).HorizontalAlignment=-4108;	// 水平居中
		xlsheet.Cells(total+8,1).VerticalAlignment=-4108;	// 垂直居中
     	xlsheet.Cells(total+8,1).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).value=jQuery('#State').val();
     	xlsheet.Range(xlsheet.Cells(total+8,2),xlsheet.Cells(total+8,6)).Borders.Weight = 2;
     	xlsheet.Cells(total+9,1).value="备注";
     	xlsheet.Cells(total+9,1).HorizontalAlignment=-4108;	// 水平居中
     	xlsheet.Cells(total+9,1).Borders.Weight = 2;
     	xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).mergecells=true;
     	xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).value=jQuery('#Remark').val();//备注
     	xlsheet.Range(xlsheet.Cells(total+9,2),xlsheet.Cells(total+9,6)).Borders.Weight = 2;
     	xlsheet.Cells(total+10,1).value="PM人员";
     	xlsheet.Cells(total+10,1).HorizontalAlignment=-4108;	// 水平居中
     	xlsheet.Cells(total+10,1).Borders.Weight = 2;
     	xlsheet.Cells(total+10,2).value="";	
     	xlsheet.Cells(total+10,2).Borders.Weight = 2;
     	xlsheet.Cells(total+10,3).value="使用部门";
     	xlsheet.Cells(total+10,3).HorizontalAlignment=-4108;	// 水平居中
     	xlsheet.Cells(total+10,3).Borders.Weight = 2;
     	xlsheet.Cells(total+10,4).value="";	
     	xlsheet.Cells(total+10,4).Borders.Weight = 2;
     	xlsheet.Cells(total+10,5).value="完成日期";	
     	xlsheet.Cells(total+10,5).HorizontalAlignment=-4108;	// 水平居中
     	xlsheet.Cells(total+10,5).Borders.Weight = 2;
     	xlsheet.Cells(total+10,6).value="";	
     	xlsheet.Cells(total+10,6).Borders.Weight = 2;
		xlsheet.printout; //打印输出
		//xlBook.SaveAs("D:\\Return"+i+".xls");
		xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    
	    xlApp=null;
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
//modified by zc0107 2021-11-14 2046917 
function fomartDownLoad(value,row,index){
	if (row.TFlag=="File")
	{
		var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",row.TRowID);
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			ftpappendfilename += "&MWToken="+websys_getMWToken()
		}
		var btn="<a onclick='window.open(&quot;"+ftpappendfilename+"&quot;)'><img border=0 complete='complete' src='../scripts_lib/hisui-0.1.0/dist/css/icons/download.png' /></a>";
	}
	else
	{
		var btn ="";
	}
	return btn;
}