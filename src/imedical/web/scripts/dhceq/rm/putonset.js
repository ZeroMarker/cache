var selectedRowID = "";	//ȡ��ǰѡ�е�����豸��¼ID
var columns=getCurColumnsInfo('RM.G.Rent.PutOnSet','','',''); //��ȡ�ж���
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initMessage("Rent");
	initUserInfo(); //�û���Ϣ
	initLookUp();
	if (getElementValue("LocType")=="0")
	{
		var paramsFrom=[{"name":"Type","type":"2","value":"2"},{"name":"LocDesc","type":"1","value":"POSLocDR_DeptDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("POSLocDR_DeptDesc","PLAT.L.Loc",paramsFrom,"");
        setElement("POSLocDR_DeptDesc",curLocName);
		setElement("POSLocDR",curLocID);
		disableElement("POSLocDR_DeptDesc",true);
		setElement("DRUseLocDR",curLocID); //�豸�Ŵ󾵲���
		setRequiredElements("POSShareType^POSItemDR_MIDesc^POSManageLocDR_DeptDesc"); //������ //modified by LMH 20220929 2676683
	}
	else
	{
		setElement("POSManageLocDR_DeptDesc",curLocName);
		setElement("POSManageLocDR",curLocID);
		disableElement("POSManageLocDR_DeptDesc",true);
		setRequiredElements("POSShareType^POSItemDR_MIDesc^POSShareItemDR_SIDesc"); //������
	}
	defindTitleStyle();
	$("#BCancel").on("click", BCancel_Clicked);
	initButton(); //��ť��ʼ��
	initApproveButtonNew(); //��ʼ��������ť UI���� added by LMH 20230203
	//showBtnIcon('BSave^BAudit^BFind^BCancel',true); //modified by LMH 20230203 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	//initButtonWidth();
	initShareType();
	initOuterType();
	initStatus(); //Add by QW20200427
	SetDisabled(3,"") //Add by QW20200512
	setElement("POSFromDate",getElementValue("NoCurDateFlag")==""?GetCurrentDate():"");	//Add by CSJ 2020-07-03 ��ʹ�õ�ǰ���ڱ�־ ����ţ�1396144
	
	//table���ݼ���
	$HUI.datagrid("#tDHCEQPutOnSet",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSPutOnSet",
			QueryName:"GetPutOnSet",
			ShareType:getElementValue("POSShareType"),
			EquipDR:getElementValue("POSEquipDR"),
			SubID:getElementValue("POSSubID"),
			ItemDR:getElementValue("POSItemDR"),
			ModelDR:getElementValue("POSModelDR"),
			HospitalDR:getElementValue("POSHospitalDR"),
			LocDR:getElementValue("POSLocDR"),
			ManageLocDR:getElementValue("POSManageLocDR"),
			AutoPutOnFlag:'',
			OuterType:getElementValue("POSOuterType"),
			FromDate:getElementValue("POSFromDate"),
			ToDate:getElementValue("POSToDate"),
			POSShareItemDR:getElementValue("POSShareItemDR"),//Add by QW20200512
			Status:getElementValue("POSStatus") //modified by csj 2020-07-02
		},
		toolbar:[{}], //Modified by QW20200427
		fitColumns : true, //Add by QW20200427
	    scrollbarSize:0, //Add by QW20200427
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
				creatToolbar(); //Modified by QW20200427
			},
		onSelect:function(rowIndex,rowData){
				fillData(rowData,rowIndex);//Modified by QW20200506 Bug:QW0060 �����:1293289
			}
	});
	//modified by LMH 20230307 3217055
	//Modify by zx 2020-06-09 Bug ZX0100
	/*$("#POSShareItemDR_SIDesc").lookup({
        onSelect:function(index,rowData){
	        setElement("POSShareItemDR",rowData.TRowID); //Modified by QW20200624 Bug:QW0067 -��Դ����-��Դ�ϼ�����-����������ʾ������Ϣ
            initMasterItem(rowData.TRowID);
        },
   });*/
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQPutOnSet",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSPutOnSet",
			QueryName:"GetPutOnSet",
			ShareType:getElementValue("POSShareType"),
			EquipDR:getElementValue("POSEquipDR"),
			SubID:getElementValue("POSSubID"),
			ItemDR:getElementValue("POSItemDR"),
			ModelDR:getElementValue("POSModelDR"),
			HospitalDR:getElementValue("POSHospitalDR"),
			LocDR:getElementValue("POSLocDR"),
			ManageLocDR:getElementValue("POSManageLocDR"),
			AutoPutOnFlag:'',
			OuterType:getElementValue("POSOuterType"),
			FromDate:getElementValue("POSFromDate"),
			ToDate:getElementValue("POSToDate"),			
			POSShareItemDR:getElementValue("POSShareItemDR"), //Add by QW20200512
			Status:getElementValue("POSStatus") //Add by QW20200512
		}
	});
}

// Author add by zx 2019-12-19
// Desc ��ʼ����Դ����Ϊcombobox,Ĭ��valueֵΪ '0'
// Input ��
// Output ��
function initShareType()
{
	var Status = $HUI.combobox('#POSShareType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{
				id: '0',
				text: '�豸'
			}/*,{ <!--Modify by QW20200506 ��ʱ�����豸-->
				id: '1',
				text: 'Room'
			}*/]
	});
}

// Author add by zx 2019-12-19
// Desc ��ʼ����������Ϊcombobox,Ĭ��valueֵΪ '0'
// Input ��
// Output ��
//Modified by QW20200427
function initOuterType()
{
	var Status = $HUI.combobox('#POSOuterType',{
		valueField:'id', textField:'text',panelHeight:"auto",value:"0",
		data:[{		//MZY0141	2974578		2022-11-02	ȥ��'ȫ��'ѡ��
				id: '0',
				text: 'Ժ�ڹ���'
			},{
				id: '1',
				text: 'Ժ������'
			},{
				id: '2',
				text: 'Ժ�⹲��'
			}]
	});
	setElement("POSOuterType",getElementValue("OuterTypeAllFlag")=="Y"?"":"0"); //Add by CSJ 2020-07-03 ����ʽȫ����־ ����ţ�1396144
}

// Author add by zx 2019-12-19
// Desc �Ŵ�Ԫ��ѡ���к����ӦDRԪ�ظ�ֵ
// Input elementID:�Ŵ�Ԫ��ID rowData:ѡ��������
// Output ��
function setSelectValue(elementID,rowData)
{
	if(elementID=="POSEquipDR_EQName") 
	{
		setElement("POSEquipDR",rowData.TRowID);
		setElement("POSLocDR_DeptDesc",rowData.TUseLoc);
		setElement("POSLocDR",rowData.TUseLocDR);
		setElement("POSModelDR_MDesc",rowData.TModel);
		setElement("POSModelDR",rowData.TModelDR);
		setElement("POSItemDR_MIDesc",rowData.TName);
		setElement("POSItemDR",rowData.TItemDR);
		setElement("EQItemDR",rowData.TItemDR);
		setElement("POSAutoPutOnFlag",true); //Modify by zx 2020-06-09 Bug ZX0100
		disableElementByEquip(true);
		//Modify by zx 2020-06-09 Bug ZX0100
		var result=tkMakeServerCall("web.DHCEQ.RM.BUSPutOnSet","GetShareItem",rowData.TItemDR);
		if(result=="") $("#ShareItemWarn").html("��ǰ���������޹�������Դ��Ŀ����");
		else $("#ShareItemWarn").html("");
	}
	else if(elementID=="POSSub") {setElement("POSSubID",rowData.TRowID);}
	else if(elementID=="POSModelDR_MDesc") {setElement("POSModelDR",rowData.TRowID);}
	else if(elementID=="POSLocDR_DeptDesc") 
	{
		setElement("POSLocDR",rowData.TRowID);
		setElement("DRUseLocDR",rowData.TRowID);
	}
	else if(elementID=="POSHospitalDR_HOSPDesc") {setElement("POSHospitalDR",rowData.TRowID);}
	else if(elementID=="POSManageLocDR_DeptDesc") {setElement("POSManageLocDR",rowData.TRowID);}
	//Modified by QW20200624 Bug:QW0067 begin
	else if(elementID=="POSItemDR_MIDesc") 
	{
		if (getElementValue("POSShareItemDR")!="")
		{
			setElement("POSItemDR",rowData.TItemDR);
			setElement("EQItemDR",rowData.TItemDR);
		}
		else
		{
			setElement("POSItemDR",rowData.TRowID);
			setElement("EQItemDR",rowData.TRowID);
			//Modify by zx 2020-06-09 Bug ZX0100
			var result=tkMakeServerCall("web.DHCEQ.RM.BUSPutOnSet","GetShareItem",rowData.TRowID);
			if(result=="") $("#ShareItemWarn").html("��ǰ���������޹�������Դ��Ŀ����");
		}
	}//Modified by QW20200624 Bug:QW0067 end
	//added by LMH 20230307 3217055 
	else if(elementID === 'POSShareItemDR_SIDesc')
	{
	    setElement("POSShareItemDR",rowData.TRowID); //Modified by QW20200624 Bug:QW0067 -��Դ����-��Դ�ϼ�����-����������ʾ������Ϣ
        initMasterItem(rowData.TRowID);
	}
}

function disableElementByEquip(value)
{
	disableElement("POSLocDR_DeptDesc",value);
	disableElement("POSModelDR_MDesc",value);
	disableElement("POSItemDR_MIDesc",value);
	$("#POSAutoPutOnFlag").prop("disabled",value); //Modify by zx 2020-06-09 Bug ZX0100
}
// Author add by zx 2019-12-19
// Desc �Ŵ�Ԫ���ı����ݱ仯ʱ�����Ӧ��DRԪ��ֵ
// Input elementID:�Ŵ�Ԫ��ID
// Output ��
function clearData(elementID)
{
	if(elementID=="POSSub")
	{
		setElement("POSSubID","");
	}
	else if (elementID=="POSEquipDR_EQName")
	{
		//disableElementByEquip(false);
		setElement("POSEquipDR","");
		setElement("POSModelDR_MDesc","");
		setElement("POSModelDR","");
		setElement("POSItemDR_MIDesc","");
		setElement("POSItemDR","");
		setElement("EQItemDR","");
		if (getElementValue("LocType")=="1")
		{
			disableElementByEquip(false);
		}
		//Modify by zx 2020-06-09 Bug ZX0100
		setElement("POSAutoPutOnFlag",false);
		$("#ShareItemWarn").html("");
	}
	else if(elementID=="DRUseLocDR")
	{
		setElement("DRUseLocDR","");
		setElement("POSLocDR","");
	}
	else if (elementID=="POSShareItemDR_SIDesc")
	{
		//Modify by zx 2020-06-09 Bug ZX0100
		setElement("POSShareItemDR","");
		setElement("POSShareItemDR_SIDesc","");
		initMasterItem("");
	}
	else
	{
		var elementName=elementID.split("_")[0];
		setElement(elementName,"");
		if(elementID=="POSItemDR_MIDesc") $("#ShareItemWarn").html(""); //Modify by zx 2020-06-09 Bug ZX0100
	}
	return;
}

// Author add by zx 2019-12-19
// Desc ���ݱ���
// Input ��
// Output ��
function saveData(type)
{
	//Modefied by zc0107 2021-11-14  begin
	var result=tkMakeServerCall("web.DHCEQ.RM.BUSPutOnSet","GetShareItem",getElementValue("POSItemDR"));
	if(result=="") 
	{
		messageShow('alert','info','��ʾ',"��ǰ���������޹�������Դ��Ŀ����");  //Modify by zx 2022-05-16 BUG 2612995
		return;
	}
	//Modefied by zc0107 2021-11-14  end
	//����Ƿ��ѱ���������������
	if (type!="1")
	{
		var rtData=tkMakeServerCall("web.DHCEQ.RM.BUSShareResource","CheckIsInPutOnSet",getElementValue("POSEquipDR"),getElementValue("POSItemDR"),getElementValue("POSModelDR"),getElementValue("POSLocDR"));
		if((rtData!="0")&&(rtData!=getElementValue("POSRowID")))
		{
			messageShow('alert','info','��ʾ',"�������÷�Χ���������ú��ǣ�");  //Modify by zx 2022-05-16 BUG 2612995
			return;
		}
		if (checkMustItemNull()) return; //Modified by QW20200506 Bug:QW0061 �����:1293262

	}
	var data=getInputList();
	//Add by QW20200506 Bug:QW0061 �����:1293262 begin
	if ((type=="1")&&(data.POSRowID=="")) 
	{
		messageShow('alert','info','��ʾ',"������Ϣ:δѡ��������");  //Modify by zx 2022-05-16 BUG 2612995
		return;
	}
	//Add by QW20200506 Bug:QW0061 �����:1293262 end
	if ($("#POSAutoPutOnFlag").is(':checked'))
	{
		data.POSAutoPutOnFlag="1";
		if((getElementValue("POSEquipDR")=="")&&(type!="1")&&((getElementValue("POSLocDR")=="")&&(getElementValue("POSModelDR")=="")))
		{
			messageShow("confirm","","ȷ��Ҫ�Զ��ϼ�","�豸��δ���ֿ��Һͻ��͵��Զ��ϼ�.","",function(){saveDataCall(data,type);},""); //Modified by QW20200506 Bug:QW0062 �����:1284157
		}
		else saveDataCall(data,type);
	}
	else
	{
		data.POSAutoPutOnFlag="0";
		saveDataCall(data,type);
	}
}

// Author add by zx 2020-03-09
// Desc ���ݱ���ص�����
// Input ��
// Output ��
function saveDataCall(data,type)
{
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.RM.BUSPutOnSet","SaveData",data,type);
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		url="dhceq.rm.putonset.csp?StatusDR="+getElementValue("StatusDR"); //Modified By QW20200529 BUG:QW0064
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		messageShow('alert','info','��ʾ',"������Ϣ:"+jsonData.Data); //Modify by zx 2022-05-16 BUG 2612995
		return
    }
}

// Author add by zx 2019-12-19
// Desc ѡ��datagrid�к�����
// Input rowData:datagridѡ��������
// Output ��
//Modified by QW20200506 Bug:QW0060 �����:1293289
function fillData(rowData,rowIndex)
{
	if (selectedRowID!=rowData.POSRowID)
	{
		setElementByJson(rowData);
		selectedRowID=rowData.POSRowID;
		setElement("EQItemDR",getElementValue("POSItemDR"));
		setElement("DRUseLocDR",getElementValue("POSLocDR"));
		SetDisabled(2,rowData.POSStatus) //Add by QW20200512
		//Modify by zx 2020-06-09 Bug ZX0100
		var result=tkMakeServerCall("web.DHCEQ.RM.BUSPutOnSet","GetShareItem",rowData.POSItemDR);
		if(result=="") $("#ShareItemWarn").html("��ǰ���������޹�������Դ��Ŀ����");
		else $("#ShareItemWarn").html("");
	}
	else
	{
		clearFormData();
		selectedRowID="";
		setElement("EQItemDR","");
		SetDisabled(1,"") //Add by QW20200512
		$('#tDHCEQPutOnSet').datagrid('uncheckRow',rowIndex);//Modified by QW20200506 Bug:QW0060 �����:1293289
		$("#ShareItemWarn").html(""); //Modify by zx 2020-06-09 Bug ZX0100
	}
}

// Author add by zx 2019-12-19
// Desc �ٴ�ѡ��datagrid�к���ձ�
// Input ��
// Output ��
function clearFormData()
{
	setElement("POSRowID","");
	setElement("POSShareType","0");
	setElement("POSEquipDR","");
	setElement("POSEquipDR_EQName","");
	setElement("POSSubID","");
	setElement("POSSub","");
	setElement("POSItemDR","");
	setElement("POSItemDR_MIDesc","");
	setElement("POSModelDR","");
	setElement("POSModelDR_MDesc","");
	//Modified By QW20200529 BUG:QW0064 Begin
	if (getElementValue("LocType")=="1")
	{
		setElement("POSLocDR","");
		setElement("POSLocDR_DeptDesc","");
		setElement("DRUseLocDR","");
	}else{
		setElement("POSManageLocDR","");
		setElement("POSManageLocDR_DeptDesc","");
	}
	//Modified By QW20200529 BUG:QW0064 End
	setElement("POSHospitalDR","");
	setElement("POSHospitalDR_HOSPDesc","");
	setElement("POSOuterType","0");
	setElement("POSAutoPutOnFlag","");
	setElement("POSFromDate","");
	setElement("POSToDate","");
	//Add by QW20200506 ��Դ��begin
	setElement("POSShareItemDR_SIDesc","");
	setElement("POSShareItemDR","");
	//Add by QW20200506 ��Դ��end
	setElement("POSStatus","");
}

//add by zx 2020-04-10
//Ԫ�ز������»�ȡֵ
function getParam(ID)
{
	if (ID=="EquipDR"){return getElementValue("POSEquipDR")}
	//Modify by zx 2020-05-19 BUG ZX0088
	if (ID=="ItemDR"){return getElementValue("POSItemDR")}
	else if (ID=="ModelDR") {return getElementValue("POSModelDR")}
}
// Mozy003014		2020-04-21		�����͸��°�ť����
function BSave_Clicked()
{
	saveData(0);
}
// Mozy003014		2020-04-21		ɾ����ť����
function BCancel_Clicked()
{
	saveData(1);
}
// Author add by QW 20200427
// Desc ��ʼ��״̬Ϊcombobox,Ĭ��valueֵΪ '0'
// Input ��
// Output ��
function initStatus()
{
	var Status = $HUI.combobox('#POSStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0',
				text: '����'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '����Ч'
			}]
	});
	setElement("POSStatus",getElementValue("StatusDR"));//add by csj 2020-07-02 Ĭ��ֵ
}
//��ӡ��ϼơ���Ϣ
//Add by QW20200508
function creatToolbar()
{
	var rows = $('#tDHCEQPutOnSet').datagrid('getRows');
	var submitsum=0
	var aduitsum=0
	for (var i = 0; i < rows.length; i++) {
		if (rows[i].POSStatus==2) aduitsum=aduitsum+1
		if (rows[i].POSStatus==1) submitsum=submitsum+1
    }
	var lable_innerText='�ύ����:'+submitsum+' ��Ч����:'+aduitsum+' ������:'+rows.length;
	$("#sumTotal").html(lable_innerText);
}
//Add by QW20200508
function BAudit_Clicked()
{
	saveData(0);
}
//Add by QW20200512
function SetDisabled(disabletype,status)
{
	var StatusDR=getElementValue("StatusDR");
	var LocType=getElementValue("LocType");
	if(disabletype==3)  //Ĭ�Ͽ���ʾ��ť
	{
		if(StatusDR=="1")
		{
				disableElement("BSave",true);
		}
		disableElement("BCancel",true);
		disableElement("BAudit",true);
	}else if(disabletype==2)  //ѡ�п���ʾ��ť
	{
		disableElement("BCancel",true);
		disableElement("BSave",true);
		if((StatusDR=="1")&&(LocType=="1")){ //Modified By QW20200529 BUG:QW0064
			if(status==1)
			{
				disableElement("BAudit",false);
			}
			else  //Modify by zx 2020-05-18 Bug ZX0088
			{
				disableElement("BAudit",true);
			}
			disableElement("BCancel",false);
		}
		else if(StatusDR=="0"||StatusDR=="") //Modified By QW20200529 BUG:QW0064
		{
			if(status==1)
			{
				disableElement("BCancel",false);
			}
			else  //Modify by zx 2020-05-18 Bug ZX0088
			{
				disableElement("BCancel",true);
			}
		}

	}else{  //ȡ��ѡ�п���ʾ��ť
		disableElement("BCancel",true);
		disableElement("BAudit",true);
		if(StatusDR=="0") disableElement("BSave",false);
	}
}

//Modify by zx 2020-06-09 Bug ZX0100
function initMasterItem(shareItemDR)
{
	if (shareItemDR!="")
	{
		var params=[{"name":"ShareItemDR","type":"2","value":shareItemDR},{"name":"ItemDR","type":"2","value":""},{"name":"Name","type":"1","value":"POSItemDR_MIDesc"},{"name":"ModelDR","type":"2","value":""}];
    	singlelookup("POSItemDR_MIDesc","RM.G.Rent.ShareItemList",params,"");
	}
	else
	{
		var params=[{"name":"EquipTypeDR","type":"2","value":""},{"name":"StatCatDR","type":"2","value":""},{"name":"Name","type":"1","value":"POSItemDR_MIDesc"},{"name":"AssetType","type":"2","value":""},{"name":"MaintFlag","type":"2","value":""}];
    	singlelookup("POSItemDR_MIDesc","EM.L.GetMasterItem",params,"");
	}
}
