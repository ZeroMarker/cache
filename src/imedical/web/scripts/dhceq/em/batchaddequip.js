var BussType=getElementValue("BussType");
var columns=getCurColumnsInfo('EM.L.GetInStockList','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	initButtonWidth(); 
	initButton();
	setRequiredElements("FromLoc^EquipType"); //������  MZY0100	2288153,2288189		2021-11-18
	setElementEnabled(); 		//�����ֻ������ 
	//jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'}); //modified by LMH 20220915 2909778 ����,initButton()�Ѷ���BAdd����
	//jQuery("#BAdd").on("click", BAdd_Click);   //modified by LMH 20220915 2909778  ���࣬initButton()�Ѷ���BAdd����
		$HUI.datagrid("#batchaddequipdatagrid",{   
	    url:$URL, 
		idField:'TIndex',
		width:1500,
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
		//fitColumns:true,		//czf 1981677 2021-07-07
		pagination:true,
    	columns:columns, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSStoreMove",	
	        QueryName:"GetInStockList",
	       	RowID:"",
			FromLocDR:getElementValue("FromLocDR"),
			EquipTypeDR:getElementValue("EquipTypeDR"),
			StatCatDR:"",
			StockStatus:"1",
			ProviderDR:"",
			ListType:"2",
			Equip:getElementValue("EquipName"),
			InStockNo:"",
			UseLocDR:"",
			Flag:getElementValue("SingleFlag"),
			Type:"",
			AllListInfo	:"",
	    }, 
	});
	$('#batchaddequipdatagrid').datagrid('showColumn','TCheckFlag');   	
}
// modified by LMH 20220915 2909778 ����BAdd_Click����ͳһΪBAdd_Clicked�����³�ʼ��ҳ��ʱinitButton()ʧ��,�������datagrid���ز�����
function BAdd_Clicked()
{
	var rows = $('#batchaddequipdatagrid').datagrid('getChecked');
	var vallist=""
    var copyrows=[]
	
	if (rows!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			
			copyrows.push(rows[i]);
		}
	}
	else
	{
		alertShow("δ��ѡ���ݣ�")
		return;	
	}
	websys_showModal("options").mth(copyrows,getElementValue("SingleFlag"));  
	$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
}

function BFind_Clicked()
{
	var FromLocDR=getElementValue("FromLocDR")
	if (FromLocDR=="")
	{
		alertShow("��ѡ����ң�")
		return;	
	}
	var EquipTypeDR=getElementValue("EquipTypeDR")
	if (EquipTypeDR=="")
	{
		alertShow("��ѡ�����飡")
		return;	
	}
	var SingleFlag=getElementValue("SingleFlag")
	var EquipName=getElementValue("EquipName")
	$HUI.datagrid("#batchaddequipdatagrid",{   
	    url:$URL, 
	    idField:'TIndex',
	    width:1500,			//czf 1981677 2021-02-20
	    fit:true,
	    //fitColumns:true,
	    queryParams:{
	       	ClassName:"web.DHCEQ.EM.BUSStoreMove",	
	        QueryName:"GetInStockList",
	       	RowID:"",
			FromLocDR:FromLocDR,
			EquipTypeDR:EquipTypeDR,
			StatCatDR:"",
			StockStatus:"1",
			ProviderDR:"",
			ListType:"2",
			Equip:EquipName,
			InStockNo:"",
			UseLocDR:"",
			Flag:SingleFlag,
			Type:"",
			AllListInfo	:"",
	    },
	    onLoadSuccess: function() {
	    	$.parser.parse();    //���ݼ��سɹ��Ժ���Ⱦ    czf 1759186 2021-02-20
		}
	});
	jQuery('#batchaddequipdatagrid').datagrid('unselectAll')   //modify by lmm 2019-08-27 1006842
	
}
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

//modified by ZY0274 20210707
function setElementEnabled()
{
	if (BussType=="22")
	{
		disableElement("FromLoc",true);
		disableElement("EquipType",true);
	}
	else if (BussType=="94")
	{
		setElement("SingleFlag",true)
	}
}


