var Columns=getCurColumnsInfo('BA.G.StateInfo.StateList','','','');
$.extend($.fn.datagrid.defaults.view,{
	onAfterRender:function(target){
		var h = $(window).height();
		var offset = $(target).closest('.datagrid').offset();
		$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
$(function(){
	initMessage("");
	defindTitleStyle(); //默认Style
	initDocument();
});

function initDocument()
{
   	initButton(); 			//按钮初始化
    initButtonWidth();
    InitEvent();
    initLookUp(); 			//初始化放大镜
    initSINoType();
    initSIOrigin();
    //initSISex();
    
    setRequiredElements("SIStartDate"); //必填项
    setElement("SIStartDate",GetCurrentDate());
    setElement("SIOrigin",0);
    setElement("SINoType",0);
   	$HUI.datagrid("#stateinfodatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSStateInfo",
	        	QueryName:"GetStateInfo"
		},
	    toolbar:[{
	                iconCls: 'icon-save',
	                text:'保存',
	                handler: function(){
	                    UpdateGridData();
	                }
                },'----------',
                {
	                iconCls: 'icon-cancel',
	                text:'删除',
					id:'delete',
	                handler: function(){
	                   DeleteGridData();
	                }
                },'----------',
                {
	                iconCls: 'icon-stamp',
	                text:'提交审核',
					id:'audit',
	                handler: function(){
	                   AuditGridData();
	                }
                }
        ],
		cache: false,
		columns:Columns,
		striped : true,
		border:false,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
   		singleSelect:false,
		onSelect:function (rowIndex, rowData) {onSelect(rowIndex,rowData);},
		onDblClickRow :function(rowIndex,rowData){onDblSelect(rowIndex,rowData);},		//双击事件
		onUnselect:function (rowIndex, rowData) { onUnselect(rowIndex, rowData)},
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
	disableElement("delete",true);
	disableElement("audit",true);
}
function InitEvent() //初始化
{
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Clicked);
	jQuery("#BCheckEQ").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BCheckEQ").on("click", BCheckEQ_Clicked);
	jQuery("#BCheckNo").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BCheckNo").on("click", BCheckNo_Clicked);
	jQuery("#BCheckTMPFileNo").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BCheckTMPFileNo").on("click", BCheckTMPFileNo_Clicked);
}
function initSINoType()
{
	var SINoType = $HUI.combobox('#SINoType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '0',text: '登记号'}],	// ,{id: '1',text: '就诊号'},{id: '2',text: '病案号'},{id: '3',text: '住院号'},{id: '4',text: '门诊号'},{id: '5',text: '标本号'},{id: '6',text: '医技号'}	MZY0117	2528189,2528299		2022-03-21	注释未实现的查询类型
		onSelect : function(){}
	});
}
function initSIOrigin()
{
	var SIOrigin = $HUI.combobox('#SIOrigin',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '0',text: 'DHC_PC'},{id: '1',text: 'DHC_PDA'},{id: '2',text: 'DHC_WChat'},{id: '3',text: 'GreatWall_PDA'}],
		onSelect : function(){}
	});
}
/*function initSISex()
{
	var SISex = $HUI.combobox('#SISex',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{id: '1',text: '男'},{id: '2',text: '女'}],
		onSelect : function(){}
	});
}*/
function onSelect(index,selected)
{
	disableElement("delete",false);
	disableElement("audit",false);
}
function onDblSelect(index,selected)
{
	if (selected.SIRowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","GetOneStateInfo",selected.SIRowID);
	//alertShow(jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	SelectedRow=index;
}
function onUnselect(index,selected)
{        				
     BClear_Clicked();
     SelectedRow = -1;
     var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
     if (checkedItems.length==0)
     {
	     disableElement("delete",true);
	     disableElement("audit",true);
     }
}
function creatToolbar()
{
	var lable_innerText="<h2 style='color:red'>不显示已审核记录, 双击获取记录运行信息!</h2>"; // background-color:red
	$("#notice").html(lable_innerText);
}
//查询
function BCheckEQ_Clicked()
{
	$HUI.datagrid("#stateinfodatagrid",{
	    url:$URL,
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSStateInfo",
	        QueryName:"GetStateInfo",
	        PFileNo:getElementValue("EQFileNo"),
	        PNo:getElementValue("EQNo"),
	        PName:getElementValue("EQName")
	    }
    });
    disableElement("delete",true);
    disableElement("audit",true);
}

function BCheckTMPFileNo_Clicked()
{
	$HUI.datagrid("#stateinfodatagrid",{
	    url:$URL,
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSStateInfo",
	        QueryName:"GetStateInfo",
	        TMPFileNo:getElementValue("TMPFileNo")
	    }
    });
	disableElement("delete",true);
    disableElement("audit",true);
}

/// 保存
function UpdateGridData()
{
	if ((getElementValue("SIStartDate")=="")||(getElementValue("SIStartTime")==""))
	{
		messageShow('alert','error','错误提示','开机日期时间不能为空!');
		return;
	}
	var SIRowIDStr="";
	var EquipDRStr="";
	var TMPFileNo=getElementValue("SITMPFileNo").replace(/,/g, "");
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		if (checkedItems[i].SIRowID!="")
		{
			if (SIRowIDStr!="") SIRowIDStr=SIRowIDStr+",";
			SIRowIDStr=SIRowIDStr+checkedItems[i].SIRowID;
		}
		else
		{
			if (checkedItems[i].SIEquipDR!="")
			{
				if (EquipDRStr!="") EquipDRStr=EquipDRStr+",";
				EquipDRStr=EquipDRStr+checkedItems[i].SIEquipDR;
			}
		}
	}
	if ((SIRowIDStr=="")&&(EquipDRStr=="")&&(TMPFileNo==""))
	{
        jQuery.messager.alert("操作错误!", "请填写设备运行信息或选择设备(运行记录)!", 'error');
        return false;
    }
    var data=getInputList();
	data=JSON.stringify(data);
	//alert(EquipDRStr+","+SIRowIDStr+","+TMPFileNo)
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","SaveData",data,EquipDRStr,SIRowIDStr,TMPFileNo);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		$('#stateinfodatagrid').datagrid('reload');
		messageShow("","","",t[0]);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
		return
    }
}
/// 删除
function DeleteGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//获取每一行的数据
		if (checkedItems[i].SIRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].SIRowID;
		}
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("错误", "未选择设备!", 'error');
        return false;
    }
    jQuery.messager.confirm('请确认', '您确定要删除所选的行?',
        function (b)
        { 
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
		        var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","DeleteStateInfo",RowIDStr)
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE==0)
				{
					$('#stateinfodatagrid').datagrid('reload');
					messageShow("","","",t[0]);
				}
				else
			    {
					messageShow('alert','error','错误提示',jsonData.Data);
					return
			    }
	        }
    	}
    )
}
/// 提交审核
function AuditGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//获取每一行的数据
		if (checkedItems[i].SIRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].SIRowID;
		}
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("错误", "未选择设备!", 'error');
        return false;
    }
    jQuery.messager.confirm('请确认', '您确定要提交审核所选的行?',
        function (b)
        { 
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
		        var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","AuditStateInfo",RowIDStr);
		        jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE==0)
				{
					$('#stateinfodatagrid').datagrid('reload');
					messageShow("","","",t[0]);
				}
				else
			    {
					messageShow('alert','error','错误提示',jsonData.Data);
					return
			    }
	        }
    	}
    )
}
/// 描述:清空函数
function BClear_Clicked()
{
	setElement("SIStartDate",GetCurrentDate());
	setElement("SIStartTime","");
	setElement("SIEndDate","");
	setElement("SIEndTime","");
	setElement("SIEndState","");
	setElement("SIUserDR","");
	setElement("SIUserDR_SSUSRName","");
	setElement("SIUseContent","");
	setElement("SIRemark","");
	setElement("SIEQName","");
	setElement("SIModelDR","");
	setElement("SIModelDR_MDesc","");
	setElement("SIStoreLocDR","");
	setElement("SIStoreLocDR_CTLOCDesc","");
	setElement("SITMPFileNo","");
	setElement("SISnNumber","");
	setElement("SILocation","");
	setElement("SITemperature","");
	setElement("SIHumidity","");
	setElement("SIDisinfectFlag",0);
	setElement("SIDisinfector","");
	setElement("SIOrigin",0);
	ClearPatientInfo();
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function BCheckNo_Clicked()
{
	//alert("BCheckNo_Clicked:"+getElementValue("No"));		0000000017	0000000047
	if (getElementValue("No")=="")
	{
		messageShow("alert",'info',"提示","请输入查询号!");
		return
	}
	ClearPatientInfo();
	// 0:登记号1:就诊号 2:病案号 3:住院号4:门诊号5:标本号6:医技号
	if (+getElementValue("SINoType")==0)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","getPatWristInfo", getElementValue("No"));
		//alert(jsonData)
		jsonData=JSON.parse(jsonData)
		if (jsonData.msg=="成功")
		{
			setElement("SINo", getElementValue("No"));
			setElement("SIPatientID", jsonData.patInfo.patientID);
			setElement("SIPatientName", jsonData.patInfo.name);
			setElement("SIBedNo", jsonData.patInfo.bedCode);
			setElement("SINurse", jsonData.patInfo.mainNurse);
			//setElement("SISex", 1);			// 男
			//if (jsonData.patInfo.sex=="女") setElement("SISex", 2);
			setElement("SISex", jsonData.patInfo.sex);
			setElement("SIAgeYr", jsonData.patInfo.age);	// MZY0123	2668211		2022-05-12
			//setElement("SIAgeMth", jsonData.patInfo.);
			//setElement("SIAgeDay", jsonData.patInfo.);
			// MZY0117	2528299,2528299		2022-03-21
			setElement("SIWardCode", jsonData.WardCode);
			setElement("SIWardName", jsonData.patInfo.wardDesc);
			setElement("SIUseLocDR", jsonData.CTDepartmentID);
			setElement("SIUseLocDR_CTLOCDesc", jsonData.patInfo.ctLocDesc);
		}
		else
		{
			jQuery.messager.alert("错误", "未查询到该患者信息!", 'error');
		}
	}
	else if (getElementValue("SINoType")==1)
	{
		
	}
	else if (getElementValue("SINoType")==2)
	{
		
	}
}
function ClearPatientInfo()
{
	setElement("SINo","");
	setElement("SIPatientID","");
	setElement("SIPatientName","");
	setElement("SIBedNo","");
	setElement("SINurse","");
	setElement("SISex","");
	setElement("SIAgeYr","");
	setElement("SIAgeMth","");
	setElement("SIAgeDay","");
	setElement("SIWardCode","");
	setElement("SIWardName","");
	setElement("SIUseLocDR_CTLOCDesc","");
	setElement("SIUseLocDR","");
}
