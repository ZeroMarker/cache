//Modified By QW20181031 �����:628427 
var Columns=getCurColumnsInfo('BA.G.StateInfo.StateList','','','')
$.extend($.fn.datagrid.defaults.view,{  
	onAfterRender:function(target){	
	var h = $(window).height();
	var offset = $(target).closest('.datagrid').offset();
	$(target).datagrid('resize',{height:parseInt(h-offset.top-13)});
	}
});
//End By QW20181031 �����:628427 
$(function(){
	initMessage("");
	defindTitleStyle(); //Ĭ��Style
	initDocument();
});


function initDocument(){
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Clicked);
   	initButton(); //��ť��ʼ��
    initButtonWidth();
    initLookUp(); //��ʼ���Ŵ�
   	$HUI.datagrid("#stateinfodatagrid",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQStateInfo",
	        	QueryName:"GetStateInfo"
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'����',  
				id:'add',        
                handler: function(){
                    AddGridData();
                }},'----------',
                {
                iconCls: 'icon-save',
                text:'����',
                handler: function(){
                    UpdateGridData();
                }},'----------',
                {
                iconCls: 'icon-cancel',    //modify by lmm 2020-04-09
                text:'ɾ��',
				id:'delete',
                handler: function(){
                   DeleteGridData();
                }}
                ],
        //Modified By QW20181031 �����:628427 
		cache: false,
		columns:Columns,
		border:false,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
   		singleSelect:false,
		onSelect:function (rowIndex, rowData) {onSelect(rowIndex,rowData);},
		onUnselect:function (rowIndex, rowData) { onUnselect(rowIndex, rowData)},
		//End By QW20181031 �����:628427 
		onLoadSuccess:function(){
			
		}
	});
	
}
//Add By QW20181031 �����:628427 
function onSelect(index,selected)
{
	 if (selected.TStartDate=="")
    {
       
        setElement("StartDate",GetCurrentDate());
    }
    else
    {
         setElement("StartDate",selected.TStartDate);
    }
    if (selected.TEndDate=="")
    {
        setElement("EndDate",GetCurrentDate());
    }
    else
    {
    	setElement("EndDate",selected.TEndDate);
    }
    setElement("UseContent",selected.TUseContent);
    setElement("EndStateInfo",selected.TEndStateInfo);
    setElement("UserDR",selected.TUserDR);
	setElement("User",selected.TUser);
	SelectedRow=index;
}
//Add By QW20181031 �����:628427 
function onUnselect(index,selected)
{        				
     BClear_Clicked();
     SelectedRow = -1;
}

//��ѯ
//Modified By QW20181031 �����:628427 
function BFind_Clicked()
{
	$HUI.datagrid("#stateinfodatagrid",{    
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQStateInfo",
        QueryName:"GetStateInfo",
        PFileNo:getElementValue("FileNo"),
        PNo:getElementValue("No"),
        PName:getElementValue("Name")
    }
    });
}

/// ����AddGridData����
function AddGridData()
{
	var EquipDRStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//��ȡÿһ�е�����
		if (EquipDRStr!="") EquipDRStr=EquipDRStr+",";
		EquipDRStr=EquipDRStr+checkedItems[i].TEquipDR;
	}
	if (EquipDRStr=="")
	{
        jQuery.messager.alert("����", "δѡ���豸!", 'error');
        return false;
    }
    var Info=EquipDRStr+"&^"+getElementValue("Type")+"^^^"+getElementValue('StartDate')+"^"+getElementValue('StartTime')+"^"+getElementValue('EndDate')+"^"+getElementValue('EndTime')+"^"+getElementValue('UseContent')+"^^^^"+getElementValue('EndStateInfo')+"^"+getElementValue('UserDR')
	var data=tkMakeServerCall("web.DHCEQStateInfo","SaveStateInfo",Info,0)
    var list=data.split("^");
    if (list[0] ==0)
	{
				$('#stateinfodatagrid').datagrid('reload'); 
            	messageShow("","","",t[0]);
    }   
     else
     {
               messageShow("","","",t[-9200]);
               	return;
    }
}

///�޸�
function UpdateGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//Modified By QW20181031 �����:628427 
		if (checkedItems[i].TRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].TRowID;
		}
		//End By QW20181031 �����:628427 
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("����", "δѡ���豸!", 'error');
        return false;
    }
	var Info=RowIDStr+"&^"+getElementValue("Type")+"^^^"+getElementValue('StartDate')+"^"+getElementValue('StartTime')+"^"+getElementValue('EndDate')+"^"+getElementValue('EndTime')+"^"+getElementValue('UseContent')+"^^^^"+getElementValue('EndStateInfo')+"^"+getElementValue('UserDR')
	var data=tkMakeServerCall("web.DHCEQStateInfo","SaveStateInfo",Info,1)
    var list=data.split("^");
    if (list[0] ==0)
	{
				$('#stateinfodatagrid').datagrid('reload'); 
            	messageShow("","","",t[0]);
    }   
     else
     {
               messageShow("","","",t[-9200]);
               	return;
    }
}
function DeleteGridData()
{
	var RowIDStr="";
	var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
	for(var i=0;i<checkedItems.length;i++)
	{
		//��ȡÿһ�е�����
		//Modified By QW20181031 �����:628427 
		if (checkedItems[i].TRowID!="")
		{
			if (RowIDStr!="") RowIDStr=RowIDStr+",";
			RowIDStr=RowIDStr+checkedItems[i].TRowID;
		}
		//End By QW20181031 �����:628427 
		
	}
	if (RowIDStr=="")
	{
        jQuery.messager.alert("����", "δѡ���豸!", 'error');
        return false;
    }
    jQuery.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�',
        function (b)
        { 
	        if (b==false)
	        {
	             return;
	        }
	        else
	        {
		        	var data=tkMakeServerCall("web.DHCEQStateInfo","DeleteStateInfo",RowIDStr)
				    var list=data.split("^");
				    if (list[0] ==0)
					{
								$('#stateinfodatagrid').datagrid('reload'); 
				            	messageShow("","","",t[0]);
				    }   
				     else
				     {
				               messageShow("","","",t[-9200]);
				               	return;
				    }
	        }
    	}
    )
}

/// ����:��պ���
function BClear_Clicked()
{
	setElement("RowID","");
	setElement("EquipDR","");
	setElement("StartDate","");
	setElement("StartTime","");
	setElement("EndDate","");
	setElement("EndTime","");
	setElement("UseContent","");
	setElement("EndStateInfo","");
	setElement("UserDR","");
	setElement("User","");
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}