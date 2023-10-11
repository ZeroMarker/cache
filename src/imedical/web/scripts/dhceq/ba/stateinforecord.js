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
	defindTitleStyle(); //Ĭ��Style
	initDocument();
});

function initDocument()
{
   	initButton(); 			//��ť��ʼ��
    initButtonWidth();
    InitEvent();
    initLookUp(); 			//��ʼ���Ŵ�
    initSINoType();
    initSIOrigin();
    //initSISex();
    
    setRequiredElements("SIStartDate"); //������
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
	                text:'����',
	                handler: function(){
	                    UpdateGridData();
	                }
                },'----------',
                {
	                iconCls: 'icon-cancel',
	                text:'ɾ��',
					id:'delete',
	                handler: function(){
	                   DeleteGridData();
	                }
                },'----------',
                {
	                iconCls: 'icon-stamp',
	                text:'�ύ���',
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
		onDblClickRow :function(rowIndex,rowData){onDblSelect(rowIndex,rowData);},		//˫���¼�
		onUnselect:function (rowIndex, rowData) { onUnselect(rowIndex, rowData)},
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
	disableElement("delete",true);
	disableElement("audit",true);
}
function InitEvent() //��ʼ��
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
		data:[{id: '0',text: '�ǼǺ�'}],	// ,{id: '1',text: '�����'},{id: '2',text: '������'},{id: '3',text: 'סԺ��'},{id: '4',text: '�����'},{id: '5',text: '�걾��'},{id: '6',text: 'ҽ����'}	MZY0117	2528189,2528299		2022-03-21	ע��δʵ�ֵĲ�ѯ����
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
		data:[{id: '1',text: '��'},{id: '2',text: 'Ů'}],
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
		messageShow('alert','error','������ʾ',jsonData.Data)
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
	var lable_innerText="<h2 style='color:red'>����ʾ����˼�¼, ˫����ȡ��¼������Ϣ!</h2>"; // background-color:red
	$("#notice").html(lable_innerText);
}
//��ѯ
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

/// ����
function UpdateGridData()
{
	if ((getElementValue("SIStartDate")=="")||(getElementValue("SIStartTime")==""))
	{
		messageShow('alert','error','������ʾ','��������ʱ�䲻��Ϊ��!');
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
        jQuery.messager.alert("��������!", "����д�豸������Ϣ��ѡ���豸(���м�¼)!", 'error');
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
		messageShow('alert','error','������ʾ',jsonData.Data);
		return
    }
}
/// ɾ��
function DeleteGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//��ȡÿһ�е�����
		if (checkedItems[i].SIRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].SIRowID;
		}
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("����", "δѡ���豸!", 'error');
        return false;
    }
    jQuery.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ����?',
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
					messageShow('alert','error','������ʾ',jsonData.Data);
					return
			    }
	        }
    	}
    )
}
/// �ύ���
function AuditGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//��ȡÿһ�е�����
		if (checkedItems[i].SIRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].SIRowID;
		}
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("����", "δѡ���豸!", 'error');
        return false;
    }
    jQuery.messager.confirm('��ȷ��', '��ȷ��Ҫ�ύ�����ѡ����?',
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
					messageShow('alert','error','������ʾ',jsonData.Data);
					return
			    }
	        }
    	}
    )
}
/// ����:��պ���
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
		messageShow("alert",'info',"��ʾ","�������ѯ��!");
		return
	}
	ClearPatientInfo();
	// 0:�ǼǺ�1:����� 2:������ 3:סԺ��4:�����5:�걾��6:ҽ����
	if (+getElementValue("SINoType")==0)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSStateInfo","getPatWristInfo", getElementValue("No"));
		//alert(jsonData)
		jsonData=JSON.parse(jsonData)
		if (jsonData.msg=="�ɹ�")
		{
			setElement("SINo", getElementValue("No"));
			setElement("SIPatientID", jsonData.patInfo.patientID);
			setElement("SIPatientName", jsonData.patInfo.name);
			setElement("SIBedNo", jsonData.patInfo.bedCode);
			setElement("SINurse", jsonData.patInfo.mainNurse);
			//setElement("SISex", 1);			// ��
			//if (jsonData.patInfo.sex=="Ů") setElement("SISex", 2);
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
			jQuery.messager.alert("����", "δ��ѯ���û�����Ϣ!", 'error');
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
