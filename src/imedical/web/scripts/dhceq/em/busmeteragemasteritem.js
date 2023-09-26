var columns=getCurColumnsInfo('EM.L.GetMasterItem','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	initButton();
	initButtonWidth();
	jQuery("#BComputer").linkbutton({iconCls: 'icon-w-ok'});
	jQuery("#BComputer").on("click", BComputer_Click);
	
		$HUI.datagrid("#maintlimitmasteritemdatagrid",{   
	    url:$URL, 
		idField:'TRowID', //主键   //add by lmm 2018-10-23
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
	        MaintFlag:'2', 
	        EquipAttributeString:getElementValue("EquipAttributeString"),
			InCloudFlag:'Y'
	    },
	    //add by lmm 2019-08-06 end 972010	
    	//modify by lmm 2019-10-28 1040240 LMM0048
    	toolbar:[
    		{
				iconCls:'icon-ok', 
				text:'计量确认',
				handler:function(){BComputer_Click("id1&");}
			},{
		        id:"add",
				iconCls:'icon-cancel', 
				text:'计量取消',
				handler:function(){BComputer_Click("");}
			} 
		], 

	}); 
	$('#maintlimitmasteritemdatagrid').datagrid('showColumn','TCheckFlag');
	$('#maintlimitmasteritemdatagrid').datagrid('showColumn','TComputerFlag');
    	
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
	        StatCatDR:getElementValue("StatCatDR"),
	        EquipCatDR:getElementValue("EquipCatDR"),
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
function BComputer_Click(DataList)
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
		alertShow("未勾选数据！")
		return;	
	}
	var SourceType=$('#SourceType').val()
	if (DataList!="")
	{
		var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute", "SaveSourIDInfoEquipAttribute",SourceType,EquipInfo,DataList);
	}
	else
	{
		var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute", "DeleteEquipAttribute",SourceType,EquipInfo,DataList);
	}
	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
	$('#maintlimitmasteritemdatagrid').datagrid('reload');
	jQuery('#maintlimitmasteritemdatagrid').datagrid('unselectAll')   //modify by lmm 2019-08-27 1006842
		
}

function checkboxComputerFlagChange(TComputerFlag,rowIndex)
{
	var row = jQuery('#maintlimitmasteritemdatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TComputerFlag==key)
			{
				if ((val=="N")||(val=="")) row.TComputerFlag="Y"   
				else row.TComputerFlag="N"
			}
		})
	}
}



