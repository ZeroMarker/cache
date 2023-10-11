$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initPlait();
    initDisplacemint();
    initVehicleType();
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("VVehicleNo^VPlait^VHasLicenseNo^VIdentification^VEngineNo^VDisplacemint"); //必填项
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
    if (jsonData=="") return; //modify by sjh 2019-10-17  需求号：1013659
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
    if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
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
                text: '在编'
            },{
                id: '2',
                text: '不在编'
            },{
                id: '3',
                text: '未核定车编'
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
                text: '1.6L以下'
            },{
                id: '2',
                text: '1.6L-1.8L'
            },{
                id: '3',
                text: '2.0L-2.5L'
            },{
                id: '4',
                text: '2.5L以上'
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
                text: '机要通信用车'
            },{
                id: '2',
                text: '应急保障用车'
            },{
                id: '3',
                text: '其他按照规定配备的公务用车'
            },{
                id: '4',
                text: '执法执勤用车'
            },{
                id: '5',
                text: '特种专业技术用车'
            }],
    });
}