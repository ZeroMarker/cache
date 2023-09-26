var Columns=getCurColumnsInfo('CON.G.Contract.ContractDetail','','','');
// MZY0033	1369965		2020-06-15
if (getElementValue("ContractType")==1)
{
	Columns=getCurColumnsInfo('CON.G.Contract.ContractForMaintDetail','','','');
}
else
{
	$("#ConditionShow").remove();
	$("#LabelShow").remove();
}
jQuery(function()
{
	initLookUp(); 				//��ʼ���Ŵ�
   	defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    InitEvent()
    //initPage(); 				//��ͨ�ó�ʼ��
    //setElementEnabled(); 		//�����ֻ������
    initStatusData();
	
	$HUI.datagrid("#DHCEQContractDetail",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Con.BUSContract",
	        QueryName:"ContractList",
			vData:"^ContractTypeDR="+getElementValue("ContractType"),
			UnSelectFlag:""
		},
		rownumbers: true,  //���Ϊtrue����ʾһ���к���
		singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			if (getElementValue("ContractType")==1)
			{
				// MZY0033	1369965		2020-06-15		���õ�Ԫ�񱳾����ı���ɫ
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
				//alert(trs.length)
				for (var i = 0; i < trs.length; i++)
				{
					// ����������
					//alert(trs[i].cells.length)
					var TRowID="";
					for (var j = 0; j < trs[i].cells.length; j++)
					{
						var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
                        if (cell_field=="TRowID") TRowID=$(row_html).find('div').html();
						if (cell_field=="TEndDate")
						{
				 			// �ı䵥Ԫ����ɫ
							//trs[i].cells[j].style.cssText = 'background:#EEEE00;color:#fff';
							var DaysNum=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetContractEndDays", TRowID);
							if (DaysNum<365) trs[i].cells[j].style.cssText = 'background:#ffff00';
						    if (DaysNum<183) trs[i].cells[j].style.cssText = 'background:#ff8000';
						    if (DaysNum<91) trs[i].cells[j].style.cssText = 'background:#ff0000';
						    if (DaysNum<0) trs[i].cells[j].style.cssText = 'background:#c0c0c0';
						}
					}
				}
			}
			
			// ����������
			if (getElementValue("ContractType")==2)
			{
				//Э���ͬ
				$("#DHCEQContractDetail").datagrid("hideColumn", "TQuantityNum");
				$("#DHCEQContractDetail").datagrid("hideColumn", "TTotal");
				$("#DHCEQContractDetail").datagrid("hideColumn", "TContractFee");
			}
		},
		onDblClickRow:function(rowIndex, rowData)
		{
			if (rowData.TRowID!="")
			{
				var str="";
				var title="";
				// "0":"�ɹ���ͬ","1":"���޺�ͬ","2":"Э���ͬ","3":"Ͷ�ź�ͬ"
				if (getElementValue("ContractType")==0)
				{
					title="�ɹ���ͬ";
					str="dhceq.con.contract.csp?&ReadOnly=1&ContractType=0&RowID="+rowData.TRowID;	// Mozy0248	1201940	2020-02-18
				}
				else if (getElementValue("ContractType")==1)
				{
					title="���޺�ͬ";
					str="dhceq.con.contractformaint.csp?&ReadOnly=1&ContractType=1&RowID="+rowData.TRowID;	// Mozy0248	1201940	2020-02-18
				}
				else if (getElementValue("ContractType")==2)
				{
					title="Э���ͬ";
					str="dhceq.con.contract.csp?&ReadOnly=1&ContractType=2&RowID="+rowData.TRowID;	// Mozy0248	1201940	2020-02-18
				}
				else if (getElementValue("ContractType")==3)
				{
					title="Ͷ�ź�ͬ";
					//str="dhceq.con.contract.csp?&ReadOnly=1&RowID="+rowData.TRowID;
				}
				showWindow(str,title,"","","icon-w-paper","modal","","","large");	// Mozy0248	1201940	2020-02-18
			}
		},
		rowStyler: function(index, row) {
            /*/ MZY0033	1369965		2020-06-15		�����б������ı���ɫ
            var BGColor="background-color:";
            if (getElementValue("ContractType")==1)
			{
				var DaysNum=tkMakeServerCall("web.DHCEQ.Con.BUSContract","GetContractEndDays",row.TRowID);
				if (DaysNum<365) BGColor="background-color:#ffff00";
			    if (DaysNum<183) BGColor="background-color:#ff8000";
			    if (DaysNum<91) BGColor="background-color:#ff0000";
			    if (DaysNum<0) BGColor="background-color:#c0c0c0";
			}
			//return "background-color:yellow;"
            return BGColor;*/
        },
	});
});
function InitEvent() //��ʼ���¼�
{
	//Mozy	984437	2019-8-19
	/*if (jQuery("#BFind").length>0)
	{
		jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
		jQuery("#BFind").on("click", BFind_Clicked);
	}
	*/
	if (jQuery("#BClean").length>0)
	{
		jQuery("#BClean").linkbutton({iconCls: 'icon-w-clean'});	
		jQuery("#BClean").on("click", BClean_Clicked);
	}
	if (jQuery("#BColSet").length>0)
	{
		jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});  //modified by csj 2020-03-18
		jQuery("#BColSet").on("click", BColSet_Click);
	}
	if (jQuery("#BSaveExcel").length>0)
	{
		jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'}); //modified by csj 2020-03-18
		jQuery("#BSaveExcel").on("click", BSaveExcel_Click);
	}
}
function initPage() //��ʼ������
{
	//
}
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '����'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '���'
			}]
	});
}
function setSelectValue(elementID,rowData)
{
	//setElement(vElementID+"DR",rowData.TRowID)
	if(elementID=="SignLocDR_CTLOCDesc") {setElement("SignLocDR",rowData.TRowID)}
	else if(elementID=="ProviderDR_VDesc") {setElement("ProviderDR",rowData.TRowID)}
	else if(elementID=="Status") {setElement("StatusDR",rowData.TRowID)}
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}
function BFind_Clicked()
{
	var vData=GetData();	//modified by CZF0085 2020-03-05 
	$HUI.datagrid("#DHCEQContractDetail",{
	    url:$URL, 
	    queryParams:{
		    ClassName:"web.DHCEQ.Con.BUSContract",
	       	QueryName:"ContractList",
		   	vData:vData,
			UnSelectFlag:""
		}
	});
}

//modified by CZF0085 2020-03-05 
function GetData()
{
	var vData="^ContractTypeDR="+getElementValue("ContractType");
	vData=vData+"^Name="+getElementValue("EquipName");
	vData=vData+"^ContractName="+getElementValue("ContractName");
	vData=vData+"^ContractNo="+getElementValue("ContractNo");
	vData=vData+"^SignLocDR="+getElementValue("SignLocDR");
	vData=vData+"^ProviderDR="+getElementValue("ProviderDR");
	vData=vData+"^SignBeginDate="+getElementValue("StartDate");
	vData=vData+"^SignEndDate="+getElementValue("EndDate");
	vData=vData+"^StatusDR="+getElementValue("Status");
	vData=vData+"^FileNo="+getElementValue("FileNo");
	//MZY0033	1369965		2020-06-15
	vData=vData+"^GEBeginDate="+getElementValue("GEStartDate");
	vData=vData+"^GEEndDate="+getElementValue("GEEndDate");
	return vData;
}

//������ͬ��ϸ
//modified by CZF0085 2020-03-05 
function BSaveExcel_Click()
{
	var ObjTJob=$('#DHCEQContractDetail').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	var vData=GetData();
	PrintDHCEQEquipNew("ContractList",1,TJob,vData,"ContractList",100); 
	return;
} 

function BColSet_Click() //��������������
{
	var para="&TableName=ContractList&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	//showWindow(url,"����������","1200","14row","icon-w-paper","","","",""); //modified by lmm 2020-06-02
	colSetWindows(url)
}
//Mozy	984437	2019-8-19
function BClean_Clicked()
{
	setElement("ContractNo","");
	setElement("ContractName","");
	setElement("SignLocDR_CTLOCDesc","");
	setElement("SignLocDR","");
	setElement("ProviderDR_VDesc","");
	setElement("ProviderDR","");
	setElement("EquipName","");
	setElement("StartDate","");
	setElement("EndDate","");
	setElement("Status","");
	//MZY0033	1369965		2020-06-15
	setElement("GEStartDate","");
	setElement("GEEndDate","");
}