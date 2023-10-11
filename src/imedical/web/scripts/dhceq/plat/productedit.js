$(function(){
    $(function(){$("#Loading").fadeOut("fast");});
    initDocument();
});

function initDocument()
{
    initUserInfo();
    initButton();
    initButtonWidth();
    initLookUp();
    fillData();
    initPanelHeaderStyle()
    $("filebox-label").on("click", pictureInfo);
}
/// modified by ZY20230201 bug:3190947��3191169��3191286��3191319��3191388��3200510
function fillData()
{
    var RowID=getElementValue("RowID")
    if (RowID=="") return;
    jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","GetOneProduct",RowID);
    //messageShow("","","",jsonData)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    setElementByJson(jsonData.Data);
}
/// modified by ZY20230201 bug:3190947��3191169��3191286��3191319��3191388��3200510
function setSelectValue(elementID,rowData)
{
    ///modified by ZY0197
    if(elementID=="PModels_MDesc") {setElement("PModels",rowData.TRowID)}
    else {setDefaultElementValue(elementID,rowData)}
    
}
/// modified by ZY20230201 bug:3190947��3191169��3191286��3191319��3191388��3200510
function BSave_Clicked()
{
    if (getElementValue("RowID")=="")
    {
        messageShow("","","","��Ʒ�����ڣ�")
        return
    }
    var data=getInputList();
    data=JSON.stringify(data);
    jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductEditInfo",data,0);
    jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
        window.location.reload()
    }
    else
    {
        messageShow('popover','error','����',"������Ϣ:"+jsonData.Data);
        return
    }
}
/// modified by ZY20230201 bug:3190947��3191169��3191286��3191319��3191388��3200510
function BDelete_Clicked()
{
	var RowID=getElementValue("RowID")
    if (RowID=="")
    {
        messageShow("","","","��Ʒ�����ڣ�")
        return
    }
    jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductEditInfo",RowID,1);
    jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
        messageShow("","","","ɾ���ɹ���")
        window.location.close()
    }
    else
    {
        messageShow('popover','error','����',"������Ϣ:"+jsonData.Data);
        return
    }
}
function pictureInfo()
{
    var RowID=getElementValue("RowID");
    if (RowID=="")
    {
        alertShow("������Ȩ��Ϣ���ٲ鿴ͼƬ��Ϣ!");
        return;
    }
    var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=96&CurrentSourceID='+RowID+'&Status=0';
    showWindow(str,"ͼƬ��Ϣ","","","icon-w-edit","","","","middle")
}
//hisui.common.js���������Ҫ
function clearData(str)
{
    var _index = vElementID.indexOf('_')
    if(_index != -1){
        var vElementDR = vElementID.slice(0,_index)
        if($("#"+vElementDR).length>0)
        {
            setElement(vElementDR,"");
        }
    }
}
