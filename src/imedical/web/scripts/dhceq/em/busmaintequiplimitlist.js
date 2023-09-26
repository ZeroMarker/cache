var columns=getCurColumnsInfo('EM.L.Equip','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	initButtonWidth();   //add by lmm 2020-04-26 1292188
	//modify by lmm 2019-10-28 1040240 LMM0048
	initButton();
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Click);
	//add by lmm 2020-05-07
	jQuery("#BComputer").linkbutton({iconCls: 'icon-w-ok'});
	jQuery("#BComputer").on("click", BComputer_Click);
	//modify by lmm 2020-03-27 
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
	//add by lmm 2020-05-07
		$HUI.datagrid("#maintlimitequipdatagrid",{   
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
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetShortEquip",
	        Equip:'',
	        VUseLoc:'',
	        NeedUseLoc:'',
	        StockStatuType:'',
	        VBAFlag:'',
	        QXType:'',
	        VComputerFlag:'',    
	        PlanNameDR:'',
	        IncludeBussFlag:'',
	        VModelDR:'',   
	        VEquipTypeDR:'',
	        VNo:''
	    }, 
	//add by lmm 2019-08-06 end 972010 
    	//modify by lmm 2019-10-28 1040240 LMM0048
    	/*toolbar:[
    		{
				iconCls:'icon-search', 
				text:'查询',
				handler:function(){findGridData();}
			},{
		        id:"add",
				iconCls:'icon-add', 
				text:'添加',
				handler:function(){AddgridData(SourceType);}
			} 
		], */

	});
	$('#maintlimitequipdatagrid').datagrid('showColumn','TCheckFlag');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TUnit');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TOriginalFee');
	//$('#maintlimitequipdatagrid').datagrid('hideColumn','TManuFactory');  //modify by lmm 2020-06-05
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TProvider');
	$('#maintlimitequipdatagrid').datagrid('hideColumn','TFileNo');
    	
}

//modify by lmm 2019-10-28 1040240 LMM0048
function BAdd_Click()
{
	var rows = $('#maintlimitequipdatagrid').datagrid('getChecked');
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
		alertShow("未勾选数据！")
		return;	
	}
	var SourceType=$('#SourceType').val()
	websys_showModal("options").mth(SourceType,copyrows);  //modify by lmm 2019-02-19
	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
}

//modify by lmm 2019-10-28 1040240 LMM0048
function BFind_Clicked()
{
		$HUI.datagrid("#maintlimitequipdatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSEquip",
	        QueryName:"GetShortEquip",
	        Equip:$("#EquipName").val(),
	        VUseLoc:getElementValue("UseLocDR"),
	        NeedUseLoc:'',
	        StockStatuType:'',
	        VBAFlag:'',
	        QXType:'',
	        VComputerFlag:getElementValue("ComputerFlag"),    //modify by lmm 2019-05-30  919473
	        PlanNameDR:'',
	        IncludeBussFlag:'',
	        VModelDR:getElementValue("ModelDR"),   //modify by lmm 2019-05-29  919133
	        VEquipTypeDR:getElementValue("EquipTypeDR"),
	        VNo:getElementValue("No")
	    },
	});
	jQuery('#maintlimitequipdatagrid').datagrid('unselectAll')   //modify by lmm 2019-08-27 1006842
	
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
	var rows = $('#maintlimitequipdatagrid').datagrid('getChecked');
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
	var DataList="id1&"   //计量设备
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute", "SaveSourIDInfoEquipAttribute",SourceType,EquipInfo,DataList);
	websys_showModal("options").mth();
	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
	
	
	
	
}


