var selectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
var columns=getCurColumnsInfo('RM.G.Rent.ResourcePrice','','',''); //��ȡ�ж���
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initMessage("Rent");
	initUserInfo(); //�û���Ϣ
	initLookUp();
	defindTitleStyle();
	initButton(); //��ť��ʼ��
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
	initButtonWidth();
	initRPSourceType();
	initRHPMode();
	var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");
	setRequiredElements("RPSource^RHPFromDate^RHPUomQuantity^RHPPrice"); //������
	setEnabled();		//��ť����
	//table���ݼ���
	$HUI.datagrid("#tDHCEQSResourcePrice",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.CTResourcePrice",
			QueryName:"GetResourcePrice",
			HospitalDR:getElementValue("RPHospitalDR"),
			SourceType:getElementValue("RPSourceType"),
			SourceID:getElementValue("RPSourceID"),
			ModelDR:getElementValue("RPModelDR")
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:columns,
	    fitColumns: true,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
				//creatToolbar();
			},
		onSelect:function(rowIndex,rowData){
				fillData(rowData);
			}
	});
	// Modify by zc 2020-06-11
	if (getElementValue("RPSourceType")=="1")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="��Դ��Ŀ"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='��Դ��Ŀ';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
	else if (getElementValue("RPSourceType")=="2")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="��Դ"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='��Դ';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
	else if (getElementValue("RPSourceType")=="3")
	{
		var label=document.getElementById("cRPSource");   
		label.innerHTML="�豸���"; 
		var bcolumn=$('#tDHCEQSResourcePrice').datagrid('getColumnOption','RPSource');  
		bcolumn.title='�豸���';
		$('#tDHCEQSResourcePrice').datagrid();                     
	}
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSResourcePrice",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.CTResourcePrice",
			QueryName:"GetResourcePrice",
			HospitalDR:getElementValue("RPHospitalDR"),
			SourceType:getElementValue("RPSourceType"),
			SourceID:getElementValue("RPSourceID"),
			ModelDR:getElementValue("RPModelDR")
		}
	});
}
///��ʼ����ť״̬
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
///ѡ���а�ť״̬
function UnderSelect()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}
function BAdd_Clicked()
{
	if(CheckDate()) return;
	if(checkMustItemNull()){return;}
	if(getElementValue("RHPUOMDR")==""){$.messager.alert('��ʾ','�Ƽ۵�λ����Ϊ�գ�','warning');return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"2");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","�����ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
function CheckDate()
{
	var FromDate = new Date(FormatDate(getElementValue("RHPFromDate")).replace(/\-/g, "\/"))     //modified by wy ����782084
	var CurDate=new Date(FormatDate(getElementValue("CurDate")).replace(/\-/g, "\/"))
	if (FromDate<CurDate)    
	{
		messageShow('alert','error','��ʾ',"��Ч���ڲ������ڵ�ǰ����");
		return true
	}
	return false
}
function BSave_Clicked()
{
	if(CheckDate()) return;
	if(checkMustItemNull()){return;}
	if(getElementValue("RHPUOMDR")==""){$.messager.alert('��ʾ','�Ƽ۵�λ����Ϊ�գ�','warning');return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","���³ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
function BDelete_Clicked()
{
	if(getElementValue("RPRowID")==""){$.messager.alert('��ʾ','��ѡ��һ����Ҫɾ���ļ�¼��','warning');return;}
	messageShow("confirm","info","��ʾ",t[-9203],"",DeleteData,"")

}
function DeleteData()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.CTResourcePrice","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","������ʾ",jsonData.Data);return;}
	messageShow("alert","success","��ʾ","ɾ���ɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.rm.resourceprice.csp?&RPSourceType="+getElementValue("RPSourceType")},50);
}
// Author add by zx 2019-12-19
// Desc ��ʼ����Դ����Ϊcombobox,Ĭ��valueֵΪ '0'
// Input ��
// Output ��
function initRPSourceType()
{
	
	setElement("RPSource","");
	setElement("RPSourceID","");
	var RPSourceType = getElementValue("RPSourceType");
	if (RPSourceType=="1")
	{
    	singlelookup("RPSource","RM.L.ShareItem","",GetRPSource);
    	var paramsFrom=[{"name":"Desc","type":"1","value":"RPModelDR_Desc"},{"name":"ShareItemDR","type":"1","value":"RPSourceID"}];
    	singlelookup("RPModelDR_Desc","RM.L.ShareItemModel",paramsFrom,"");
	}
	else if (RPSourceType=="2")
	{
		singlelookup("RPSource","RM.L.EquipByShareResource","",GetSourceID);
		singlelookup("RPModelDR_Desc","PLAT.L.Model","","");
	}
	else
	{
		var paramsFrom=[{"name":"Desc","type":"1","value":"RPSource"}];
    	singlelookup("RPSource","RM.L.Rent.ResourceItem",paramsFrom,"");
    	var paramsFrom=[{"name":"ItemDR","type":"1","value":"RPSourceID"},{"name":"Name","type":"1","value":"RPModelDR_Desc"}];
    	singlelookup("RPModelDR_Desc","PLAT.L.Model",paramsFrom,"");
	}
	
}
function GetRPSource(item)
{
	setElement("RPSource",item.TDesc);  
	setElement("RPSourceID",item.TRowID);
}
function GetSourceID(item)
{
	setElement("RPSource",item.TEquipName);  
	setElement("RPSourceID",item.TRowID);
	setElement("RPModelDR",item.TModelDR);
	setElement("RPModelDR_Desc",item.TModel);   
}
function initRHPMode()
{
	var Status = $HUI.combobox('#RHPMode',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"1",
		data:[{
				id: '1',
				text: '����ʱ��'
			},{
				id: '2',
				text: '������'
			}],
		onSelect: function () {
	    	ValueClear()
			var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    		singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");

    }
	});
}

function ValueClear()
{
	setElement("RHPUOMDR_Desc","");
	setElement("RHPUOMDR","");
}
// Author add by zx 2019-12-19
// Desc �Ŵ�Ԫ��ѡ���к����ӦDRԪ�ظ�ֵ
// Input elementID:�Ŵ�Ԫ��ID rowData:ѡ��������
// Output ��
function setSelectValue(elementID,rowData)
{
	if(elementID=="RPSource") 
	{
		setElement("RPSource",rowData.TDesc);
		setElement("RPSourceID",rowData.TRowID);
	}
	else if(elementID=="RHPUOMDR_Desc")
	{
		setElement("RHPUOMDR_Desc",rowData.TName);
		setElement("RHPUOMDR",rowData.TRowID);
	}
	else if(elementID=="RPHospitalDR_Desc") {setElement("RPHospitalDR",rowData.TRowID);}
	else if(elementID=="RHPPriceTypeDR_Desc") {setElement("RHPPriceTypeDR",rowData.TRowID);}
	else if(elementID=="RPModelDR_Desc") {setElement("RPModelDR",rowData.TRowID);}  //Modify By ZX 2020-06-24 Bug ZX0093
}
// Author add by zx 2019-12-19
// Desc �Ŵ�Ԫ���ı����ݱ仯ʱ�����Ӧ��DRԪ��ֵ
// Input elementID:�Ŵ�Ԫ��ID
// Output ��
function clearData(elementID)
{
	return;
}


// Author add by zx 2019-12-19
// Desc ѡ��datagrid�к�����
// Input rowData:datagridѡ��������
// Output ��
function fillData(rowData)
{
	if (selectedRowID!=rowData.RPRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.RPRowID;
		setElement("RPRowID",selectedRowID);
		// Modify by zc 2020-06-11
		disableElement("RPHospitalDR_Desc",true);
		disableElement("RPSource",true);
		disableElement("RPModelDR_Desc",true);
		disableElement("RHPPriceTypeDR_Desc",true);
		if (rowData.RPSourceType=="1")
		{
			singlelookup("RPSource","RM.L.ShareItem","","");
    		var paramsFrom=[{"name":"Desc","type":"1","value":"RPModelDR_Desc"},{"name":"ShareItemDR","type":"1","value":"RPSourceID"}];
    		singlelookup("RPModelDR_Desc","RM.L.ShareItemModel",paramsFrom,"");
		}
		else if (rowData.RPSourceType=="2")
		{
			singlelookup("RPSource","RM.L.EquipByShareResource","",GetSourceID);
			singlelookup("RPModelDR_Desc","PLAT.L.Model","","");
		}
		else
		{
			var paramsFrom=[{"name":"Desc","type":"1","value":"RPSource"}];
    		singlelookup("RPSource","RM.L.Rent.ResourceItem",paramsFrom,"");
    		var paramsFrom=[{"name":"ItemDR","type":"1","value":"RPSourceID"},{"name":"Name","type":"1","value":"RPModelDR_Desc"}];
    		singlelookup("RPModelDR_Desc","PLAT.L.Model",paramsFrom,"");
		}
		UnderSelect();
	}
	else
	{
		clearFormData();
		selectedRowID="";
		setEnabled()
		// Modify by zc 2020-06-11
		disableElement("RPHospitalDR_Desc",false);
		disableElement("RPSource",false);
		disableElement("RPModelDR_Desc",false);
		disableElement("RHPPriceTypeDR_Desc",false);
	}
}

// Author add by zx 2019-12-19
// Desc �ٴ�ѡ��datagrid�к���ձ�
// Input ��
// Output ��
function clearFormData()
{
	setElement("RPRowID","");
	setElement("RPHospitalDR","");
	setElement("RPHospitalDR_Desc","");
	setElement("RPSource","");
	setElement("RPSourceID","");
	setElement("RPModelDR","");
	setElement("RPModelDR_Desc","");
	setElement("RHPRowID","");
	setElement("RHPPriceTypeDR","");
	setElement("RHPPriceTypeDR_Desc","");
	setElement("RHPMode","1");
	setElement("RHPUomQuantity","");
	setElement("RHPUOMDR","");
	setElement("RHPUOMDR_Desc","");
	setElement("RHPPrice","");
	setElement("RHPFromDate","");
	var paramsFrom=[{"name":"Desc","type":"1","value":"RHPUOMDR_Desc"},{"name":"Type","type":"2","value":"1"}];
    singlelookup("RHPUOMDR_Desc","PLAT.L.UOM",paramsFrom,"");
}

//Modify by zx 2020-05-18 Bug ZX0088
//Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="ItemDR"){return ""}
	else if (ID=="ModelDR") {return getElementValue("RPModelDR")}
}