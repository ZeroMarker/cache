var columns=getCurColumnsInfo('RM.G.Rent.ShareResource','','','N'); //��ȡ�ж���
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
	initButton(); //��ť��ʼ��
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
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    toolbar:[
		    {
				iconCls: 'icon-top-green',
	            text:'�ϼ�',
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
	        ClassName:"web.DHCEQ.RM.BUSShareResource",  //Modefied by zc0044 2018-11-22 �޸�query����
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
// Desc DRԪ�ظ�ֵ
// Input elementID:LookUpԪ��ID,item:ѡ����Ŀ
// Output ��
function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}

// Author add by zx 2019-12-24
// Desc DRԪ�ظ�ֵ���
// Input elementID:LookUpԪ��ID
// Output ��
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

// Author add by zx 2019-12-24
// Desc �豸�ϼܴ���
// Input ��
// Output ��
function addShareResource()
{
	var checkedItems = $('#tDHCEQShareResource').datagrid('getChecked');
	if(checkedItems.length==0)
	{
		messageShow('popover','error','��ʾ',"δѡ���ϼ��豸��");
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
		messageShow('popover','success','��ʾ',"�ϼ���ɣ�");
	}
	else
	{
		messageShow('popover','success','��ʾ',"�ϼ�ʧ�ܣ�");
	}
	websys_showModal("options").mth();
	$('#tDHCEQShareResource').datagrid('reload');
}
//add by LMH 20220928 2804641
function getParam(ID)
{
	if (ID=='EquipTypeDR'){return getElementValue('EquipTypeDR')}
}