/// Creator：      WY
/// CreatDate：    2020-10-16
/// Description:   库房管理类组
var PreSelectedRowID = "";	//取当前选中的组件设备记录ID
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  
});

function initDocument()
{
	initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp(); //初始化放大镜
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"LELStoreLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("LELStoreLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    //add by wy 2021-6-2 1967835 WY0093
    var paramsFrom=[{"name":"Desc","type":"1","value":"LELEquipTypeDR_ETDesc"},{"name":"QXType","type":"2","value":"1"}];
    singlelookup("LELEquipTypeDR_ETDesc","PLAT.L.EquipType",paramsFrom,"");
	defindTitleStyle();
    initButton(); //按钮初始化
    initButtonWidth();
    setRequiredElements("LELStoreLocDR_CTLOCDesc^LELEquipTypeDR_ETDesc")
    //fillData(); //数据填充
    setEnabled(); //按钮控制
	$HUI.datagrid("#DHCEQCStoreEquipType",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.CTStoreEquipType",
	        	QueryName:"GetStoreEquipType",
			    StoreLocDR:getElementValue("LELStoreLocDR"),
			    EquipTypeDR:getElementValue("LELEquipTypeDR"),
			    Flag:GetCheckValue("LELFlag")
		},
		fit:true,
		singleSelect:true, //modified by wy 20-21-5-28 列表改成单选
	    rownumbers: true,
   		fitColumns:true,  //add by wy 2021-5-287 列表自适应  
		onClickRow:function(rowIndex,rowData){
				fillData_OnClickRow(rowIndex, rowData);
			},
		columns:[[
    	{field:'TLELRowID',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TLELStoreLoc',title:'库房',width:200,align:'center'},
        {field:'TLELEquipType',title:'访问设备类组',width:200,align:'center'}, 
        {field:'TLELFlag',title:'默认访问',width:200,align:'center'} 
         ]], 
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="LELStoreLocDR_CTLOCDesc") {setElement("LELStoreLocDR",rowData.TRowID)}
	else if(elementID=="LELEquipTypeDR_ETDesc") {setElement("LELEquipTypeDR",rowData.TRowID)}

}
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQCStoreEquipType",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.CTStoreEquipType",
	        	QueryName:"GetStoreEquipType",
			    StoreLocDR:getElementValue("LELStoreLocDR"),
			    EquipTypeDR:getElementValue("LELEquipTypeDR"),
			    Flag:GetCheckValue("LELFlag")
		},
		columns:[[
    	{field:'TLELRowID',title:'Rowid',width:50,align:'center',hidden:true},    
        {field:'TLELStoreLoc',title:'库房',width:200,align:'center'},
        {field:'TLELEquipType',title:'访问设备类组',width:200,align:'center'},
        {field:'TLELFlag',title:'默认访问',width:200,align:'center'} 
         ]], 
	    fit:true,
		singleSelect:true,
	    rownumbers: true
	});

}
///Creator: WY
///CreatDate: 2020-10-20
///Description: 数据新增方法
function BSave_Clicked()
{
	if(checkMustItemNull()){return;}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTStoreEquipType","SaveData",data,"2");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","新增成功！");  
	var url="dhceq.plat.storeequiptype.csp?&RowID=";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}

///Creator: WY
///CreatDate: 2020-10-20
///Description: 数据删除方法
function BDelete_Clicked()
{
	var data=getInputList();
	data=JSON.stringify(data);
	var truthBeTold = window.confirm("是否删除此条记录？");  
	if (!truthBeTold) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTStoreEquipType","SaveData",data,"1");
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示",jsonData.Data);return;}
	messageShow("alert","success","提示","删除成功！");  
	var url="dhceq.plat.storeequiptype.csp?&RowID=";
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href= url},50);
}
///点击行事件
function fillData_OnClickRow(rowIndex, rowData)
{
	if (PreSelectedRowID!=rowData.TLELRowID)
	{
		setElement("LELRowID",rowData.TLELRowID);
		setElement("LELStoreLocDR_CTLOCDesc",rowData.TLELStoreLoc);
		setElement("LELStoreLocDR",rowData.TLELStoreLocDR);
		setElement("LELEquipTypeDR_ETDesc",rowData.TLELEquipType);
		setElement("LELEquipTypeDR",rowData.TLELEquipTypeDR);
		setElement("LELFlag",rowData.TLELFlagDR);
		disableElement("BSave",false);
	    disableElement("BDelete",false);
		PreSelectedRowID=rowData.TLELRowID
	}
	else
	{
		BClear_Clicked();
		PreSelectedRowID=""
		setEnabled();
	}	
}

//清空按钮触发事件，取消选中行触发事件
function BClear_Clicked()
{
		setElement("LELRowID","");
		setElement("LELStoreLocDR_CTLOCDesc","");
		setElement("LELStoreLocDR","");
		setElement("LELEquipTypeDR_ETDesc","");
		setElement("LELEquipTypeDR","");
		setElement("LELFlag","");
}
function setEnabled()
{
	disableElement("BSave",false);
	disableElement("BDelete",true);
}

function clearData(elementID)
{
	if(elementID=="LELStoreLocDR_CTLOCDesc") {setElement("LELStoreLocDR","")}
	else if(elementID=="LELEquipTypeDR_ETDesc") {setElement("LELEquipTypeDR","")}
}
function GetCheckValue(checkName)
{
	return (jQuery("#" + checkName).is(':checked')==true)?"Y":"";
}