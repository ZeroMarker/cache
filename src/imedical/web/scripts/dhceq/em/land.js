///add by ZY 2913588,2913589,2913590
/// ��������ר����Ϣ����
$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage("InStock"); //��ȡ����ҵ����Ϣ
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initOwnerData();
    initLOwnerKind();
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("LOwnerKind^LOwnerFlag^LSelfOwnArea^LShareArea^LPlace"); //������
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly=="1")
    {
        disableElement("BSave",true);
    }

};

function fillData()
{
    var LRowID=getElementValue("LRowID");
    if (LRowID=="") return;
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSLand","GetOneLand",LRowID);
    if (jsonData=="") return; 
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
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSLand","SaveData",data);
    if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
    window.location.reload();
}

//Add By QW202208016 begin �����:2760300 
function initOwnerData()
{
    var LOwnerFlag = $HUI.combobox('#LOwnerFlag',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '1',
                text: '�в�Ȩ'
            },{
                id: '2',
                text: '�޲�Ȩ'
            },{
                id: '3',
                text: '��Ȩ���綨'
            }],
    });
    
}

function initLOwnerKind()
{
	 var LOwnerKind = $HUI.combobox('#LOwnerKind',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '1',
                text: '����'
            },{
                id: '2',
                text: '����'
            }],
    });
}
