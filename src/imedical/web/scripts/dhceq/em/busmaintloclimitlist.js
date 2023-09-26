var columns=getCurColumnsInfo('PLAT.L.Loc','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	//modify by lmm 2019-10-28 1040240 LMM0048
	initButton();
	initButtonWidth();   //add by lmm 2020-04-26 1292188
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Click);
	
	//modify by lmm 2020-03-27 
	if (getElementValue("Planstatus")=="2")
	{
		disableElement("BAdd",true)
		
	}	
		$HUI.datagrid("#maintloclimitdatagrid",{   
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
	        ClassName:"web.DHCEQ.Plat.LIBFind",
	        QueryName:"GetEQLoc",
	        Type:'',
	        LocDesc:'',
	        vgroupid:'',
	        LocType:'',
	        notUseFlag:'',
	        ExportType:'Y'  
	    },    
	    //add by lmm 2019-08-06 end 972010	LMM0048
    	//modify by lmm 2019-10-28 1040240
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
		],*/ 

	}); 
	$('#maintloclimitdatagrid').datagrid('showColumn','TCheckFlag');
    	
}
//modify by lmm 2019-10-28 1040240 LMM0048
function BAdd_Click()
{
	var rows = $('#maintloclimitdatagrid').datagrid('getChecked');
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
	
		$HUI.datagrid("#maintloclimitdatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.LIBFind",
	        QueryName:"GetEQLoc",
	        Type:'',
	        LocDesc:getElementValue("UseLoc"),
	        vgroupid:'',
	        LocType:'0102',
	        notUseFlag:''
	    },
	});
	jQuery('#maintloclimitdatagrid').datagrid('unselectAll')   //modify by lmm 2019-08-27 1006842
	
}

