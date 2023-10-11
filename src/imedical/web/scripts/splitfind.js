///设备拆分查询
///Add By czf 2014955 2021-07-04
var Columns=getCurColumnsInfo('EM.G.Split.Split','','','');
jQuery(function()
{
	initDocument();
});

function initDocument()
{
	initLookUp(); 
   	defindTitleStyle();
    initButton(); 
    //initButtonWidth();
    initPage();
    initStatusData();
    setElement("Status",getElementValue("StatusDR"));

	$HUI.datagrid("#tDHCEQSplitFind",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSSplit",
	        QueryName:"GetSplit",
			QXType:getElementValue("QXType"),
			CurRole:getElementValue("CurRole"),
			WaitAD:getElementValue("WaitAD"),
			RequestNo:getElementValue("RequestNo"),
			Type:getElementValue("Type"),
			EquipName:getElementValue("EquipName"),
			EquipNo:getElementValue("EquipNo"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			StatusDR:getElementValue("Status"),
			EquipTypeDR:getElementValue("EquipTypeDR"),
			LocDR:getElementValue("LocDR")
		},
		rownumbers: false,
		singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
		},
		onDblClickRow:function(rowIndex, rowData)
		{
			
		}
	});
}

function initPage()
{
    ///add by ZY20221206 bug:3127952
    ///重复定义事件
    /*
    if (jQuery("#BAdd").length>0)
    {
        jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});    
        jQuery("#BAdd").on("click", BAdd_Clicked);
    }
    */
    if (getElementValue("Type")!=0)
    {
        hiddenObj("BAdd",1)
    }
}

function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '新增'
			},{
				id: '1',
				text: '提交'
			},{
				id: '2',
				text: '审核'
			}],
		onSelect : function(){
			setElement("StatusDR",getElementValue("Status"));
			}
	});
}
   
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSplitFind",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.BUSSplit",
	        QueryName:"GetSplit",
			QXType:getElementValue("QXType"),
			CurRole:getElementValue("CurRole"),
			WaitAD:getElementValue("WaitAD"),
			RequestNo:getElementValue("RequestNo"),
			Type:getElementValue("Type"),
			EquipName:getElementValue("EquipName"),
			EquipNo:getElementValue("EquipNo"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			StatusDR:getElementValue("Status"),
			EquipTypeDR:getElementValue("EquipTypeDR"),
			LocDR:getElementValue("LocDR")
		}
	});
}

function BAdd_Clicked()
{
	var url="dhceq.em.split.csp?WaitAD=off&Type=0"; 
	showWindow(url,"设备拆分单","","","icon-w-paper","modal","","","large",BFind_Clicked)
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID);
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

