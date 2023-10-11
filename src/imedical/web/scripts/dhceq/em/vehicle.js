$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initPlait();
    initDisplacemint();
    initVehicleType();
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("VVehicleNo^VPlait^VHasLicenseNo^VIdentification^VEngineNo^VDisplacemint"); //������
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly=="1")
    {
        disableElement("BSave",true);
    }

};

function fillData()
{
    var VRowID=getElementValue("VRowID");
    if (VRowID=="") return;
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSVehicle","GetOneVehicle",VRowID);
    if (jsonData=="") return; //modify by sjh 2019-10-17  ����ţ�1013659
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData=="") return;
    if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    setElementByJson(jsonData.Data);
}

function BSave_Clicked()
{
    if (checkMustItemNull()) return;
    var data=getInputList();
    data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSVehicle","SaveData",data);
    if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
    window.location.reload();
}

function initPlait()
{
	 var VPlait = $HUI.combobox('#VPlait',{
        valueField:'id', 
        textField:'text',
        panelHeight:"auto",
        data:[{
                id: '1',
                text: '�ڱ�'
            },{
                id: '2',
                text: '���ڱ�'
            },{
                id: '3',
                text: 'δ�˶�����'
            }],
    });
}

function initDisplacemint()
{
	var Displacemint = $HUI.combobox('#VDisplacemint',{
        valueField:'id', 
        textField:'text',
        panelHeight:"auto",
        data:[{
                id: '1',
                text: '1.6L����'
            },{
                id: '2',
                text: '1.6L-1.8L'
            },{
                id: '3',
                text: '2.0L-2.5L'
            },{
                id: '4',
                text: '2.5L����'
            }],
    });
}

function initVehicleType()
{
	var VehicleType = $HUI.combobox('#VVehicleType',{
        valueField:'id', 
        textField:'text',
        panelHeight:"auto",
        data:[{
                id: '1',
                text: '��Ҫͨ���ó�'
            },{
                id: '2',
                text: 'Ӧ�������ó�'
            },{
                id: '3',
                text: '�������չ涨�䱸�Ĺ����ó�'
            },{
                id: '4',
                text: 'ִ��ִ���ó�'
            },{
                id: '5',
                text: '����רҵ�����ó�'
            }],
    });
}