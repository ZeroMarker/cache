///������HISUI���� add by WY
var preRowID=0
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	initButton(); //��ť��ʼ�� add by wy 2019-4-22
    initButtonWidth();
	jQuery('#BAdd').on("click", BAdd_Clicked);
	singlelookup("BussType","PLAT.L.BussType","",GetBussType)
	singlelookup("ParentMenu","PLAT.L.EQMenu","",GetParentMenu)
	initModuleTypeData();
	initClientTypeData();
	initShowinNewData();
	defindTitleStyle();
	setRequiredElements("ModuleType^Name^Caption^MenuType^ClientType")
	initMessage("");
	initDHCEQCSysMenus();			//��ʼ�����
	setEnabled();	// MZY0025	1318602		2020-05-13
}
function GetBussType(item)
{	
	setElement("BussTypeDR",item.TRowID); 
	setElement("BussType",item.TName);	
	setElement("ModuleType",item.TModuleTypeDR);				
}
function GetParentMenu(item)
{
	setElement("ParentMenu",item.TName);			
	setElement("ParentMenuDR",item.TRowID); 			
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function initModuleTypeData()
{
	var ModuleType = $HUI.combobox('#ModuleType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '�豸����'
			},{
				id: '2',
				text: 'ά�޹���'
			},{
				id: '3',
				text: 'Ч�����'
			},{
				id: '4',
				text: '�ƶ��̵�'
			},{
				id: '5',
				text: '�ƶ�ά��'
			},
			//Modified By QW20200116 begin BUG:QW0039�����ƶ����ռ�����
			{
				id: '6',
				text: '�ƶ�����'
			},{
				id: '7',
				text: '�ƶ�����'
			}],
			//Modified By QW20200116 end BUG:QW0039�����ƶ����ռ�����
		onSelect:function(){
                singlelookup("BussType","PLAT.L.BussType","",GetBussType)
                singlelookup("ParentMenu","PLAT.L.EQMenu","",GetParentMenu)  //add by wy ����741539
            },
});
}	
function initClientTypeData()
{
	var ClientType = $HUI.combobox('#ClientType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '6',
				text: 'PC�˲˵�'
			},{
				id: '7',
				text: '�ƶ��˲˵�'
			}]
});
}
function initShowinNewData()
{
	var ShowinNew = $HUI.combobox('#ShowinNew',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '0',
				text: '��'
			},{
				id: '1',
				text: '��'
			}]
});
}
function CombineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("ModuleType");
	val+="^"+getElementValue("BussTypeDR");
	val+="^"+getElementValue("Name");
	val+="^"+getElementValue("Caption");
	val+="^"+getElementValue("MenuType");
	val+="^"+getElementValue("ClientType");
	val+="^"+getElementValue("ParentMenuDR");
	val+="^"+getElementValue("Image");
	val+="^"+getElementValue("LinkUrl");
	val+="^"+getElementValue("Sequence");
	val+="^"+getElementValue("ShortCutkey");
	val+="^"+getElementValue("ShowinNew");
	val+="^"+getElementValue("Remark");
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCSysMenus').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			FillData(selectedRowID)
			setElement("RowID",selectedRowID);
			preRowID=selectedRowID;
			setDisEnabled();	// MZY0025	1318602		2020-05-13
		}
		else
		{
			ClearElement();
			$('#tDHCEQCSysMenus').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
			setEnabled();		// MZY0025	1318602		2020-05-13
		}
	}
}
function FillData(rowid)
{
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTSysMenus',
			MethodName:'GetOneSysMenus',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			var list=data.split("^");
			//messageShow("","","",list)
			setElement("ModuleType",list[0]);
			setElement("BussType",list[17]);
			setElement("BussTypeDR",list[1]);
			setElement("Name",list[2]);
			setElement("Caption",list[3]);
			setElement("MenuType",list[4]);
			setElement("ClientType",list[5]);
			setElement("ParentMenu",list[19]);
			setElement("ParentMenuDR",list[6]);
			setElement("Image",list[7]);
			setElement("LinkUrl",list[8]);
			setElement("Sequence",list[9]);
			setElement("ShortCutkey",list[10]);
			setElement("ShowinNew",list[11]);
			setElement("Remark",list[12]);
		}
	});
}
function ClearElement()
{
	setElement("RowID","");
	setElement("ModuleType","");
	setElement("BussType","");
	setElement("BussTypeDR","");
	setElement("Name","");
	setElement("Caption","");
	setElement("MenuType","");
	setElement("ClientType","");
	setElement("ParentMenu","");
	setElement("ParentMenuDR","");
	setElement("Image","");
	setElement("LinkUrl","");
	setElement("Sequence","");
	setElement("ShortCutkey","");
	setElement("ShowinNew","");
	setElement("Remark","");
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQCSysMenus",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTSysMenus",
	        QueryName:"GetModuleMenu",
	        ModuleType:getElementValue("ModuleType"),
	        BussType:getElementValue("BussTypeDR"),
	        Name:getElementValue("Name"),
	        Caption:getElementValue("Caption"),
	        MenuType:getElementValue("MenuType"),
	        ClientType:getElementValue("ClientType"),  //add by wy ����741595
	        ParentMenuDR:getElementValue("ParentMenuDR"),
	        ShortCutKey:getElementValue("ShortCutkey"),
	        ShowInnewWindow:getElementValue("ShowinNew"),
	        Image:getElementValue("Image"),
	        Linkurl:getElementValue("LinkUrl"),//add by wy ����741595
	        Sequence:getElementValue("Sequence"),
	    },
	})    
}

function BAdd_Clicked()
{
	if (getElementValue("RowID")!=""){
			$.messager.popover({msg:"����ʧ��,�����ѡ��һ����¼",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTSysMenus',
			MethodName:'SaveData',
			Arg1:CombineData(),
			Arg2:SessionObj.GUSERID,
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			data=data.split("^");
			if(data>0)
			{
				$.messager.popover({msg:"����ɹ�",type:'success'});
				$('#tDHCEQCSysMenus').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.popover({msg:"����ʧ��",type:'error'});
			}
		}
	});
}
function BSave_Clicked()
{
	if (getElementValue("RowID")==""){
			$.messager.popover({msg:"��ѡ��һ��",type:'alert'});
            return false;
    } 
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Plat.CTSysMenus',
			MethodName:'SaveData',
			Arg1:CombineData(),
			Arg2:SessionObj.GUSERID,
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'���ڱ�����'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
			data=data.split("^");
			if(data>0)
			{
				$.messager.popover({msg:"����ɹ�",type:'success'});
				$('#tDHCEQCSysMenus').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.popover({msg:"����ʧ��",type:'error'});
			}
		}
	});
}
function BDelete_Clicked()
{
	if (getElementValue("RowID")==""){
            $.messager.popover({msg:"��ѡ��һ��",type:'alert'}); 
            return false;
    } 
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
					ClassName:'web.DHCEQ.Plat.CTSysMenus',
					MethodName:'DeleteModulemenu',
					Arg1:getElementValue("RowID"),
					ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'����ɾ����'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data>0)
				{
					$.messager.popover({msg:"ɾ���ɹ�",type:'success'});
					$('#tDHCEQCSysMenus').datagrid('reload');
					ClearElement();
				}
				else
				{
				 messageShow('alert','alert','��ʾ',"��ʾ:"+data);
				}
			}
		});
        }
	});
}
function initDHCEQCSysMenus()
{
	$HUI.datagrid("#tDHCEQCSysMenus",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTSysMenus",
	        QueryName:"GetModuleMenu",
	    },
	    fie:true,
	    singleSelect:true,
		fitColumns:true,
		pagination:true,
    	columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:true},    
        {field:'TModuleType',title:'ģ��',width:60,align:'center'},
        {field:'TBussType',title:'ҵ��',width:95,align:'center'},
        {field:'TBussTypeDR',title:'ҵ��dr',width:50,hidden:true},
        {field:'TName',title:'����',width:100,align:'center'},    
        {field:'TCaption',title:'˵��',width:100,align:'center'},
        {field:'TMenuType',title:'�˵�����',width:100,align:'center'},    
        {field:'TClientType',title:'�ͻ�������',width:70,align:'center'},    
        {field:'TParentMenu',title:'���˵�',width:100,align:'center'},
        {field:'TImage',title:'ͼ��',width:100,align:'center'},    
        {field:'TLinkurl',title:'����',width:100,align:'center'},    
        {field:'TSequence',title:'˳��',width:50,align:'center'},
        {field:'TShortCutKey',title:'��ݼ�',width:60,align:'center'},    
        {field:'TShowInnewWindow',title:'�´��ڴ�',width:100,align:'center'},    
        {field:'TRemark',title:'��ע',width:100,align:'center'},
        {field:'TDate',title:'date',width:100,align:'center',hidden:true},    
        {field:'TTime',title:'time',width:100,align:'center',hidden:true},    
        {field:'TUser',title:'������',width:100,align:'center',hidden:true}            
    	]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},

	});
}
// MZY0025	1318602		2020-05-13
function setEnabled()
{
	disableElement("BSave",true);
	disableElement("BDelete",true);
	disableElement("BAdd",false);
}
function setDisEnabled()
{
	disableElement("BSave",false);
	disableElement("BDelete",false);
	disableElement("BAdd",true);
}