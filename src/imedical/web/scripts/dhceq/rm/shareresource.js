var columns=getCurColumnsInfo('RM.G.Rent.ShareResource','','','N'); //获取列定义
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initMessage("Rent"); //Modify by zx 2020-04-10 BUG ZX0083
	initLookUp();
	if (getElementValue("LocType")=="0")
	{
		var paramsFrom=[{"name":"Type","type":"2","value":"2"},{"name":"LocDesc","type":"1","value":"Loc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}];
        singlelookup("Loc","PLAT.L.Loc",paramsFrom,"");
	}
	defindTitleStyle();
	initButton(); //按钮初始化
	initButtonWidth();
	setRequiredElements("PutOnSet");
	$HUI.datagrid("#tDHCEQShareResource",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"GetEquipListBySet",
			ParaPutOnSetDR:'',
			ParaEquip:'',
			ParaItemDR:'',
			ParaModelDR:'',
			ParaLocDR:'',
			ParaLocID:''
		},
		border:false,
	    fit:true,
	    striped : true,
	    //singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    toolbar:[
		    {
				iconCls: 'icon-top-green',
	            text:'上架',
	            id:'add',
	            handler: function(){
	                 addShareResource();
	            }
	        }
        ],
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
				//creatToolbar();
			},
		onSelect:function(rowIndex,rowData){
				//fillData(rowData);
			}
	});
}

function BFind_Clicked()
{
	if (checkMustItemNull()) return;
	$HUI.datagrid("#tDHCEQShareResource",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.RM.BUSShareResource",  //Modefied by zc0044 2018-11-22 修改query名称
	        QueryName:"GetEquipListBySet",
	        ParaPutOnSetDR:getElementValue("PutOnSetDR"),
			ParaEquip:getElementValue("Equip"),
			ParaItemDR:getElementValue("ItemDR"),
			ParaModelDR:getElementValue("ModelDR"),
			ParaLocDR:getElementValue("LocDR")
	    }
	});
}

// Author add by zx 2019-12-24
// Desc DR元素赋值
// Input elementID:LookUp元素ID,item:选择项目
// Output 无
function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}

// Author add by zx 2019-12-24
// Desc DR元素赋值清空
// Input elementID:LookUp元素ID
// Output 无
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

// Author add by zx 2019-12-24
// Desc 设备上架处理
// Input 无
// Output 无
function addShareResource()
{
	var checkedItems = $('#tDHCEQShareResource').datagrid('getChecked');
	if(checkedItems.length==0)
	{
		messageShow('popover','error','提示',"未选择上架设备！");
		return false;
	}
	var num=0;
	$.each(checkedItems, function(index, item){
		if (num!=0) return;
    	var jsonData = tkMakeServerCall("web.DHCEQ.RM.BUSShareResource", "SaveShareResource",item.TPutOnSetDR,item.TEquipDR);
    	jsonData=JSON.parse(jsonData);
		if (jsonData.SQLCODE!=0)
		{
			num=num+1;
		}
	});
	if (num==0)
	{
		messageShow('popover','success','提示',"上架完成！");
	}
	else
	{
		messageShow('popover','success','提示',"上架失败！");
	}
	websys_showModal("options").mth();
	$('#tDHCEQShareResource').datagrid('reload');
}
//add by LMH 20220928 2804641
function getParam(ID)
{
	if (ID=='EquipTypeDR'){return getElementValue('EquipTypeDR')}
}