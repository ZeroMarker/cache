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
                text:'关闭',
				id:'close',
                handler: function(){
                     closeWindow("modal");
                },
        },{
    			iconCls: 'icon-add',
                text:'新增',
				id:'addconfig',
                handler: function(){
                     BAddConfig();
                },
        }],
		//rownumbers: true,  //如果为true则显示一个行号列
		//singleSelect:true,
		nowrap:false,
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

//hisui.common.js错误纠正需要
function clearData(str)
{
	return;
}

function BAddConfig()
{
	var RowID=getElementValue("EquipDR");
	if (RowID=="")
	{
		alertShow("设备ID不能为空!")
		return
	}
	
	var ReadOnly=getElementValue("ReadOnly");
	var str='dhceq.process.confignew.csp?&OpenFlag=N&SourceType=2&SourceID='+RowID+'&ReadOnly='+ReadOnly;
	showWindow(str,"台账附属设备","","","icon-w-paper","modal","","","large",reloadGrid);
}

function reloadGrid()
{
	$("#DHCEQConfigInfo").datagrid('reload');
}
