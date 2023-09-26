var Columns=getCurColumnsInfo('EM.G.Equip.ConfigInfo','','','')
$(function(){
	initDocument();
});

function initDocument()
{
	defindTitleStyle();   //add by lmm 2019-02-19
	initUserInfo();
	$HUI.datagrid("#DHCEQConfigInfo",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSConfig",
	        	QueryName:"GetEQConfigList",
				EquipDR:getElementValue("EquipDR")
		},
		toolbar:[{
    			iconCls: 'icon-no',
                text:'�ر�',
				id:'close',
                handler: function(){
                     closeWindow("modal");
                }
        }],
		//rownumbers: true,  //���Ϊtrue����ʾһ���к���
		//singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
};

function setSelectValue(elementID,rowData)
{
	//if(elementID=="ISLocDR_CTLOCDesc") {setElement("ISLocDR",rowData.TRowID)}
}

//hisui.common.js���������Ҫ
function clearData(str)
{
	return;
}