$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage("InStock"); //获取所有业务消息
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("IATitleOfInvention^IACertificateNo^IARegistrationDept^IARegistrationDate"); //必填项
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly=="1")
    {
        disableElement("BSave",true);
    }

};

function fillData()
{
    var IARowID=getElementValue("IARowID");
    if (IARowID=="") return;
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIntangibleAssets","GetOneIntangibleAssets",IARowID);
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
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIntangibleAssets","SaveData",data);
    if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
    window.location.reload();
}
