var columns=getCurColumnsInfo('EM.L.GetMasterItem','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	//modify by lmm 2019-10-28 1040240 LMM0048
	initButton();
	initButtonWidth();   //add by lmm 2020-04-26 1292188
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Click);
	//modify by lmm 2020-03-27 
	//add by lmm 2020-05-07
	jQuery("#BComputer").linkbutton({iconCls: 'icon-w-ok'});
	jQuery("#BComputer").on("click", BComputer_Click);
	if (getElementValue("Planstatus")=="2")
	{
		//disableElement("BAdd",true)
		hiddenObj("BAdd",1)
		hiddenObj("BComputer",1)
		
	}	
	else if (getElementValue("Planstatus")=="3")
	{
		hiddenObj("BAdd",1)
		
	}
	else
	{
		hiddenObj("BComputer",1)
	}	
	
		$HUI.datagrid("#maintlimitmasteritemdatagrid",{   
	    url:$URL, 
		idField:'TRowID', //����   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
		fitColumns:true,   //modify by lmm 2020-06-02
		pagination:true,
    	columns:columns, 
	    //add by lmm 2019-08-06 begin 972010	
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.CTMasterItem",
	        QueryName:"GetMasterItem",
	        EquipTypeDR:'',
	        StatCatDR:'',
	        Name:'',
	        AssetType:'',
	        MaintFlag:'2',  //modify by lmm 2019-09-19 1032851
	        //modify by lmm 2020-05-07
	        ExportType:'Y',
	        EquipAttributeString:getElementValue("EquipAttributeString"),
			InCloudFlag:'Y'
	    },
	    //add by lmm 2019-08-06 end 972010	
    	//modify by lmm 2019-10-28 1040240 LMM0048
    	/*toolbar:[
    		{
				iconCls:'icon-search', 
				text:'��ѯ',
				handler:function(){findGridData();}
			},{
		        id:"add",
				iconCls:'icon-add', 
				text:'����',
				handler:function(){AddgridData(SourceType);}
			} 
		], */

	});  
	$('#maintlimitmasteritemdatagrid').datagrid('showColumn','TCheckFlag');
    	
}
//modify by lmm 2019-10-28 1040240 LMM0048
function BAdd_Click()
{
	var rows = $('#maintlimitmasteritemdatagrid').datagrid('getChecked');
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
	var SourceType=$('#SourceType').val()
	websys_showModal("options").mth(SourceType,copyrows);  //modify by lmm 2019-02-19
	$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
}
//modify by lmm 2019-10-28 1040240 LMM0048
function BFind_Clicked()
{
	
		$HUI.datagrid("#maintlimitmasteritemdatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.CTMasterItem",
	        QueryName:"GetMasterItem",
	        EquipTypeDR:getElementValue("EquipTypeDR"),
	        StatCatDR:'',
	        Name:getElementValue("MasterItem"),
	        AssetType:'',
	        MaintFlag:'2',  //modify by lmm 2019-09-19 1032851
	        EquipAttributeString:getElementValue("EquipAttributeString"), //modify by lmm 2020-05-07
			InCloudFlag:'Y'
	    },
	});
	jQuery('#maintlimitmasteritemdatagrid').datagrid('unselectAll')   //modify by lmm 2019-08-27 1006842
	
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

//add by lmm 2020-05-07
function BComputer_Click()
{
	var rows = $('#maintlimitmasteritemdatagrid').datagrid('getChecked');
	var EquipInfo=""
	
	if (rows!="")
	{
		for(var i=0;i<rows.length;i++)
		{
			if (EquipInfo=="")
			{
				EquipInfo=rows[i].TRowID;
			}
			else
			{
				EquipInfo=EquipInfo+"^"+rows[i].TRowID;
			}
		}

	}
	else
	{
		alertShow("δ��ѡ���ݣ�")
		return;	
	}
	var SourceType=$('#SourceType').val()
	var DataList="id1&"   //�����豸
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute", "SaveSourIDInfoEquipAttribute",SourceType,EquipInfo,DataList);
	websys_showModal("options").mth();
	$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
	
	
	
	
}


