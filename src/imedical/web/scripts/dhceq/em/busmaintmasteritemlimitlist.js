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
	//modified by cjt 20221210 需求号3116057
	//jQuery("#BAdd").linkbutton({iconCls:'icon-w-add'});
	//jQuery("#BAdd").on("click",BAdd_Clicked);//modified by zc0122 20221012 修改BAdd_Click为BAdd_Clicked
	//modify by lmm 2020-03-27 
	//add by lmm 2020-05-07
	//jQuery("#BComputer").linkbutton({iconCls: 'icon-w-ok'});
	//jQuery("#BComputer").on("click", BComputer_Click);
	if (getElementValue("Planstatus")=="2"||getElementValue("Planstatus")=="3")
	{
		//disableElement("BAdd",true)
		hiddenObj("BAdd",1)
		
	}		
	//modify by zyq 2022-11-03 end
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
	        MaintFlag:'2',  //modify by lmm 2019-09-19 1032851
	        //modify by lmm 2020-05-07
	        ExportType:'Y',
	        EquipAttributeString:getElementValue("EquipAttributeString"),
			InCloudFlag:''  //modify by lmm 2020-09-09 1485332
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
	$('#maintlimitmasteritemdatagrid').datagrid('showColumn','TCheckFlag');
    	
}
//modify by lmm 2019-10-28 1040240 LMM0048
//Modefied by zc0122 2022-10-12 修改BAdd_Click为BAdd_Clicked
function BAdd_Clicked()
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
			InCloudFlag:''  //modify by lmm 2020-09-09 1485332
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

/*modify by zyq 2022-11-03 begin
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
		alertShow("未勾选数据！")
		return;	
	}
	var SourceType=$('#SourceType').val()
	var DataList="id1&"   //计量设备
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute", "SaveSourIDInfoEquipAttribute",SourceType,EquipInfo,DataList);
	websys_showModal("options").mth();
	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
}
*/

// MZY0111	2400072		2022-01-14
//元素参数重新获取值
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return getElementValue("EquipTypeDR")}
}

