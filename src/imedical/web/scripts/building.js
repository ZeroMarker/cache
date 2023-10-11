$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage(""); //��ȡ����ҵ����Ϣ
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initOwnerData(); 
    initOwnerKind();
    initStructure();
    initRightType();
    KeyUpNew("BDStructDR_BSDesc^BDRightTypeDR_RTDesc");
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("BDOwnerFlag^BDOwnerKind^BDBuildingArea^BDUtilizationArea^BDAllotArea^BDPlace^BDStructDR_BSDesc^BDLandArea"); //������
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly=="1")
    {
        disableElement("BSave",true);
    }
    initButtonColor();//cjc 2023-02-01 ���ü��������ť��ɫ
};

function initStructure()
{
	$('#BDStructDR_BSDesc').lookup({
	//$HUI.combogrid('#BDStructDR_BSDesc',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSBuilding",
	        QueryName:"GetBuildingStructure"
	    },
	    idField:'TRowID',
		textField:'TName',
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    singleSelect: true,
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'����',width:150},
	    ]],
	    onSelect:function(rowIndex,rowData){
		    setElement("BDStructDR",rowData.TRowID);
		}
	});
}

function initRightType()
{
	$('#BDRightTypeDR_RTDesc').lookup({
	//$HUI.combogrid('#BDRightTypeDR_RTDesc',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBFind",
	        QueryName:"GetRightType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    singleSelect: true,
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'����',width:150},
	    ]],
	    onSelect:function(rowIndex,rowData){
		    setElement("BDRightTypeDR",rowData.TRowID);
		}
	});
}

function fillData()
{
    var BDRowID=getElementValue("BDRowID");
    if (BDRowID=="") return;
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuilding","GetOneBuilding",BDRowID);
    if (jsonData=="") return; //modify by sjh 2019-10-17  ����ţ�1013659
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData=="") return;
    if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    setElementByJson(jsonData.Data);
    // add by sjh SJH0044 2021-01-26 
    if (getElementValue("BDFloorNum")=="0.00")
    {
        setElement("BDFloorNum","");
    }
    if (getElementValue("BDUnderFloorNum")=="0.00")
    {
        setElement("BDUnderFloorNum","");
    }
}

function BSave_Clicked()
{
    if (checkMustItemNull()) return;
    var LandFlag=getElementValue("LandFlag");  //Add By QW202208016 begin �����:2760300 
    if ((LandFlag!="1")&&(getElementValue("BDBuildingArea")=="")) //Add By QW202208016 begin �����:2760300 
    {
        messageShow("alert","error","��ʾ","�����������Ϊ��!"); //modify hly 2019-9-9
        return
    }
    // add by sjh SJH0044 2021-01-19 begin �жϿ��ƽ���������ܰ��������������ַ���
    var BuildingArea=Number(getElementValue("BDBuildingArea"))
    if(isNaN(BuildingArea))
    {
        messageShow("","","","�������ҪΪ��ֵ���ͣ�")
        return
    } 
    // add by sjh SJH0044 2021-01-19 end
    var data=getInputList();
    data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuilding","SaveData",data);
    if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
    window.location.reload();
}
//Add By QW202208016 begin �����:2760300 
function initOwnerData()
{
    var BDOwnerFlag = $HUI.combobox('#BDOwnerFlag',{
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

function initOwnerKind()
{
	 var BDOwnerKind = $HUI.combobox('#BDOwnerKind',{
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
