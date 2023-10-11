var equipcolumns=getCurColumnsInfo('EM.L.Equip','','',''); 
var handoverColumns=getCurColumnsInfo('EM.G.HandOver.HandOverList','','',''); 
var handoverlistColumns=getCurColumnsInfo('EM.G.HandOver.HandOverList','','',''); 
var editIndex=undefined;
var modifyBeforeRow = {};
var GlobalObj = {
	HOEquipStatusDesc : [{"value":"0","text":"����"},{"value":"1","text":"�쳣"}],	

}
$(document).ready(function () {
	initDocument();
});
function initDocument()
{	
	initUserInfo(); 
	defindTitleStyle(); 
	initButton(); 
    initButtonWidth();
	initDHCEQEquipList();			//��ʼ�����
	//���ά�����Ҳǩˢ��
	$HUI.tabs("#RentTabs",{
		onSelect:function(title)
		{
			//Modify by zx 2020-05-21 BUG ZX0089
			if (title=="��������")
			{
				initHandOver();
			}
			else if (title=="�����嵥")
			{
				$('#tDHCEQEquip').datagrid('reload'); 
			}
			else if (title=="���ҽ�����ϸ")
			{
				initHandOverList();
			}
		}
	});	
}
function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQEquip",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSHandOver",   
	        QueryName:"GetEquipList",
	        vLocDR:curLocID,	
	        CurGroupID:curSSGroupID,    
	    },
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,		
    	columns:equipcolumns,
    	toolbar:[{
		        id:"HandOver",
				iconCls:'icon-big-switch', 
				text:'�豸����',
				handler:function(){BBatchHandOver_Click();}
			} 
		],  
		pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20,40,60,80],
});
	$('#tDHCEQEquip').datagrid('showColumn','TCheckFlag');
	$('#tDHCEQEquip').datagrid('hideColumn','TUnit');
	$('#tDHCEQEquip').datagrid('hideColumn','TOriginalFee');
	$('#tDHCEQEquip').datagrid('hideColumn','THospital');
	$('#tDHCEQEquip').datagrid('hideColumn','TProvider');
	$('#tDHCEQEquip').datagrid('hideColumn','TFileNo');
	$('#tDHCEQEquip').datagrid('showColumn','TEquipStatus');
}
function initHandOver()
{
	$HUI.datagrid("#tDHCEQHandOver",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.EM.BUSHandOver",
    	QueryName:"GetHandOver",
		vUser:curUserID,
		vDate:getElementValue("CurDate")
	},
    //fit:true,
    //singleSelect:false,
    rownumbers: true,
    columns:handoverColumns,
    toolbar:[{
		        id:"Aduit",
				iconCls:'icon-save-sure', 
				text:'ȷ��',
				handler:function(){BOK_Click();}
			} 
	], 	
	pagination:true,
	pageSize:10,
	pageNumber:1,
	pageList:[10,20,30,40],
});
	$('#tDHCEQHandOver').datagrid('hideColumn','HOToUser');
	$('#tDHCEQHandOver').datagrid('hideColumn','HOToDate');
	$('#tDHCEQHandOver').datagrid('hideColumn','HOToTime');
	$('#tDHCEQHandOver').datagrid('hideColumn','HOLoc');
	changeColumnOption()
}
///add by lmm 2018-10-14
function changeColumnOption()
{
	var HOEquipStatusDesc=$("#tDHCEQHandOver").datagrid('getColumnOption','HOEquipStatusDesc');	
	HOEquipStatusDesc.editor={type: 'combobox',options:{
					data: GlobalObj.HOEquipStatusDesc,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#tDHCEQHandOver").datagrid('getEditor',{index:editIndex,field:'HOEquipStatus'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#tDHCEQHandOver").datagrid('getEditor',{index:editIndex,field:'HOEquipStatusDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	HOEquipStatusDesc.formatter=	function(value,row){
			return row.HOEquipStatusDesc;
		}
}
function BBatchHandOver_Click()
{
	var checkedItems = $('#tDHCEQEquip').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','��ʾ',"δѡ���豸��")
		return false;
	}
	for(i=0;i<selectItems.length;i++)//��ʼѭ��
	{
		var res = tkMakeServerCall("web.DHCEQ.EM.BUSHandOver", "CheckEquipHasHandOver",selectItems[i]);
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{	
			$.messager.popover({msg:ret[1],type:'alert',timeout:60000});
			return;	
		}
	}
	var url="dhceq.em.batchhandover.csp?RowIDs="+selectItems; 
	showWindow(url,"�豸����","","9row","icon-w-paper","modal","","","small",reloadGrid);
}
//add by zx 2019-06-01 �����޸ĺ�ˢ���б�����
function reloadGrid()
{
	$('#tDHCEQEquip').datagrid('reload');
}
function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#tDHCEQHandOver').datagrid('validateRow', editIndex))
	{
		$('#tDHCEQHandOver').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index)
{
	if (editIndex!=index)
	{
		if (endEditing())
		{
			$('#tDHCEQHandOver').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#tDHCEQHandOver').datagrid('getRows')[editIndex]);
			//bindGridEvent(); //�༭�м�����Ӧ
		} else {
			$('#tDHCEQHandOver').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
function bindGridEvent()
{
	if (editIndex == undefined){return true}
    try
    {
       
    }
    catch(e)
    {
        alertShow(e);
    }
}
function initHandOverList()
{
	$HUI.datagrid("#tDHCEQHandOverList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.EM.BUSHandOver",
    	QueryName:"GetHandOverList",
    	vLocDR:curLocID,	
		SDate:getElementValue("SDate"),
		EDate:getElementValue("EDate")
	},
    fit:true,
    singleSelect:false,
    rownumbers: true,
    columns:handoverlistColumns,
	pagination:true,
	pageSize:20,
	pageNumber:1,
	pageList:[20,40,60,80],	
});
	$('#tDHCEQHandOverList').datagrid('showColumn','HOUser');
	$('#tDHCEQHandOverList').datagrid('hideColumn','TCk');
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQHandOverList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.EM.BUSHandOver",
    	QueryName:"GetHandOverList",
    	vLocDR:curLocID,	
		SDate:getElementValue("SDate"),
		EDate:getElementValue("EDate")
	}
	});
}
function BOK_Click()
{
	//����ȷ����Ϣ
	var dataList="";
	if (editIndex != undefined){ $('#tDHCEQHandOver').datagrid('endEdit', editIndex);}
	var rows = $('#tDHCEQHandOver').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		if (dataList!="") dataList=dataList+getElementValue("SplitRowCode");
		dataList=dataList+rows[i].HORowID+"^"+rows[i].HOEquipStatus+"^"+rows[i].HORemark
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSHandOver","SaveHandOverList", dataList);
	//alert(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
	    $('#tDHCEQHandOver').datagrid('reload');
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}