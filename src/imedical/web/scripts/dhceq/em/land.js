///add by ZY 2913588,2913589,2913590
/// 处理土地专属信息界面
$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initOwnerData();
    initLOwnerKind();
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("LOwnerKind^LOwnerFlag^LSelfOwnArea^LShareArea^LPlace"); //必填项
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
    if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
    window.location.reload();
}

//Add By QW202208016 begin 需求号:2760300 
function initOwnerData()
{
    var LOwnerFlag = $HUI.combobox('#LOwnerFlag',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '1',
                text: '有产权'
            },{
                id: '2',
                text: '无产权'
            },{
                id: '3',
                text: '产权待界定'
            }],
    });
    
}

function initLOwnerKind()
{
	 var LOwnerKind = $HUI.combobox('#LOwnerKind',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '1',
                text: '国有'
            },{
                id: '2',
                text: '集体'
            }],
    });
}
