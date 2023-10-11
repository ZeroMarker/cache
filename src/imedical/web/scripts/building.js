$(function(){
    initDocument();
});
function initDocument()
{
    initUserInfo();
    initMessage(""); //获取所有业务消息
    jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
    jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
    initOwnerData(); 
    initOwnerKind();
    initStructure();
    initRightType();
    KeyUpNew("BDStructDR_BSDesc^BDRightTypeDR_RTDesc");
    fillData();
    //initButton(); //modified by sjh SJH0027 2020-06-12 
    setRequiredElements("BDOwnerFlag^BDOwnerKind^BDBuildingArea^BDUtilizationArea^BDAllotArea^BDPlace^BDStructDR_BSDesc^BDLandArea"); //必填项
    var ReadOnly=getElementValue("ReadOnly");
    if (ReadOnly=="1")
    {
        disableElement("BSave",true);
    }
    initButtonColor();//cjc 2023-02-01 设置极简积极按钮颜色
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
	        {field:'TName',title:'描述',width:150},
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
	        {field:'TName',title:'描述',width:150},
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
    if (jsonData=="") return; //modify by sjh 2019-10-17  需求号：1013659
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
    var LandFlag=getElementValue("LandFlag");  //Add By QW202208016 begin 需求号:2760300 
    if ((LandFlag!="1")&&(getElementValue("BDBuildingArea")=="")) //Add By QW202208016 begin 需求号:2760300 
    {
        messageShow("alert","error","提示","建筑面积不能为空!"); //modify hly 2019-9-9
        return
    }
    // add by sjh SJH0044 2021-01-19 begin 判断控制建筑面积不能包含非数字类型字符串
    var BuildingArea=Number(getElementValue("BDBuildingArea"))
    if(isNaN(BuildingArea))
    {
        messageShow("","","","建筑面积要为数值类型！")
        return
    } 
    // add by sjh SJH0044 2021-01-19 end
    var data=getInputList();
    data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuilding","SaveData",data);
    if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data);return;}
    window.location.reload();
}
//Add By QW202208016 begin 需求号:2760300 
function initOwnerData()
{
    var BDOwnerFlag = $HUI.combobox('#BDOwnerFlag',{
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

function initOwnerKind()
{
	 var BDOwnerKind = $HUI.combobox('#BDOwnerKind',{
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
