
var PageLogicObj={
	PHRecLocDataGrid:"",
	ItemCatExtDataGrid:"",
	
	editRow:undefined,
	LocRowID:""
}

$(function(){ 
	InitHospList();
	InitTip();
	
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_PHReclocAbout");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitPHRecLoc();
    InitItemCatExtDataGrid();
	ChangePHRecLocCommon()
	//��ʼ�������������
	InitDosingConfig();
}
function InitItemCatExtDataGrid()
{
	var ItemCatExtTools = [{
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            SaveItemCatExt();
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                PageLogicObj.editRow = undefined;
                PageLogicObj.ItemCatExtDataGrid.datagrid("rejectChanges");
                PageLogicObj.ItemCatExtDataGrid.datagrid("unselectAll");
            }
        }];
        ///ItemCatDr:%String,ItemCatDesc:%String,NormSplitPackQty:%String,AutoCreatONEOrd
	var ItemCatExtColumns=[[    
                    { field: 'ItemCatDr',hidden:true},
        			{ field: 'ItemCatDesc', title: 'ҩƷ����', width: 150, align: 'center', sortable: true},
        			///�Ǽ�������Ѻ��ģʽ�£��Ʒѡ�ҩ�����޷�����
					{ field: 'NormSplitPackQty', title: '��ʱҽ���������װ��ҩ(���ڼ�������Ѻ������ⳤ��ģʽ����Ч)',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "��";
				 			else  return "��";
				 	   }
					}/*,
					{ field: 'EMAutoCreatONEOrd', title: '�������ⳤ�����С��Ա�ҩҽ���Զ��������ȡҩҽ��',  align: 'center', sortable: true,hidden:true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "��";
				 			else  return "��";
				 	   }
					},
					{ field: 'EnableIPDispensingMode', title: '����ҽ�����ҷ�ҩ',  align: 'center', sortable: true,hidden:true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 			   },
			 		   formatter:function(value,record){
				 			if (value=="Y") return "��";
				 			else  return "��";
				 	   }
					}*/
    			 ]];
	PageLogicObj.ItemCatExtDataGrid=$('#tabPHItemCatExtConfig').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //Ϊtrueʱ ����ʾ���������
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"ItemCatDr",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :ItemCatExtColumns,
		toolbar :ItemCatExtTools,
		remoteSort: false,
		onClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
		        return false;
			}
			PageLogicObj.ItemCatExtDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex
		},onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			PageLogicObj.editRow=undefined;
		}
	});
};
function LoadItemCatExtDataGrid()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.PHReclocAbout",
	    QueryName : "GetItemCatExtConfig",
	    PHRecloc:PageLogicObj.LocRowID,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.ItemCatExtDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.editRow = undefined;
		PageLogicObj.ItemCatExtDataGrid.datagrid('unselectAll');
		PageLogicObj.ItemCatExtDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
function InitPHRecLoc(){
	var GridData=$.cm({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindDep",
	    desc:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},false);
	if (PageLogicObj.PHRecLocDataGrid!=""){
		PageLogicObj.PHRecLocDataGrid.datagrid("unselectAll").datagrid("loadData",GridData['rows']);
		PageLogicObj.LocRowID="";
		ChangePHRecLocCommon();
		return ;
	}
	var PHRecLocColumns=[[    
		{ field: 'CTLOCRowID',hidden:true},
		{ field: 'CTLOCDesc', title: '����', width: 150, align: 'center', sortable: false}
	]]
	PageLogicObj.PHRecLocDataGrid=$("#tabPHRecLoc").datagrid({   
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //Ϊtrueʱ ����ʾ���������
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false,  //�Ƿ��ҳ
		rownumbers : true,  //
		idField:"CTLOCRowID",
		columns :PHRecLocColumns,
		toolbar :[],
		data:GridData['rows'],
		onSelect:function(rowIndex, rowData){
			PageLogicObj.LocRowID=rowData.CTLOCRowID;
			ChangePHRecLocCommon();
		}
	})
}
function ChangePHRecLocCommon(){
	//����������չ����
	LoadItemCatExtDataGrid();
	//���ؾ�������
	LoadDosingConfig();
}
function SaveItemCatExt(){
	if ((PageLogicObj.LocRowID=="")||(PageLogicObj.editRow == undefined)){
	  return false;
	}
	var rows = PageLogicObj.ItemCatExtDataGrid.datagrid("getRows"); 
	var NormSplitPackQty="0";
	var EMAutoCreatONEOrd="0";
	var EnableIPDispensingMode="0";
	var rows=PageLogicObj.ItemCatExtDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	var editors = PageLogicObj.ItemCatExtDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
	var selected=editors[0].target.is(':checked');
	if(selected) NormSplitPackQty="1";
	/*
	var selected=editors[1].target.is(':checked');
	if(selected) EMAutoCreatONEOrd="1";
	var selected=editors[2].target.is(':checked');
	if(selected) EnableIPDispensingMode="1";
	*/
	if ((EMAutoCreatONEOrd=="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('��ʾ',"�������޷�ͬʱ���װ��ҩ���Զ�����ȡҩ��");
		return false;
	}
	
	var HospDr=$HUI.combogrid('#_HospList').getValue();
	var UserEMVirtualtLong = $.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNode",
		    Node:"UserEMVirtualtLong",
		    HospId:HospDr,
			dataType:"text"
		},false)
	//Ŀǰҩ�����Ƿ�����ҽ�����ҷ�ҩ�Ǹ������ⳤ�ڹ�ѡ�жϵģ���ʹ��ҽ�����ҷ�ҩ�������ʱ���ܰ�ִ�м�¼��ҩ���Ʒѡ���ҩ���˷�
	//Ŀǰҩ���޷����ж��޸�Ϊ�ù�ѡ����Ϊ�漰��ͬ������Ҫ�л���ҩ��������⡣
	if ((UserEMVirtualtLong!="1")&&(NormSplitPackQty=="1")){
		$.messager.alert('��ʾ',"��ǰҽԺδ�����������ⳤ�ڣ��޷�������ʱҽ���������װ��ҩ��");
		return false;
	}
	/*
	if ((NormSplitPackQty=="1")&&(EnableIPDispensingMode=="0")){
		$.messager.alert('��ʾ',"�������ڲ��װ��ҩģʽ��,���������סԺ��ҩģʽ��");
		return false;
	}
	*/
	var DHCFieldNumStr="1^2^3";
	var ValStr=NormSplitPackQty+"^"+EMAutoCreatONEOrd+"^"+EnableIPDispensingMode;

	$.m({
		ClassName:"DHCDoc.DHCDocConfig.PHReclocAbout",
		MethodName:"SetPHReclocAboutItemCatExtValue",
		PHRecloc:PageLogicObj.LocRowID, ItemCatDr:rows.ItemCatDr,DHCFieldNumStr:DHCFieldNumStr, ValStr:ValStr
	},function(value){
		if(value=="0"){
			PageLogicObj.ItemCatExtDataGrid.datagrid("endEdit", PageLogicObj.editRow);
			LoadItemCatExtDataGrid();
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});
		}else{
			$.messager.alert('��ʾ',"����ʧ��:"+value);
			return false;
		}
	});
}


function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>�����������ҳ��ʹ��˵��</li>"
		+ "<li>1�������ü������ⳤ�ڹ��ܣ��������������Һ�����๴ѡ����ʱҽ���������װ��ҩ�������ɰ�ִ�м�¼���г�������ʵ�ֲ�����ҩ��ҵ�񳡾���</li>"
	;
	$("#Panel-Tools-CatExtConfig-Tip").popover({
		trigger:'hover',
		content:_content
	});

	var _content = "<ul class='tip_class'><li style='font-weight:bold'>�����������ҳ��ʹ��˵��</li>"
		+ "<li>1���������ö���ͨҩ��������Ч��</li>"
		+ "<li>2����ѡ����<i>������Һ�������°�ʱ���޸ľ�����տ���</i>���ú�:</li>"
		+ "<li>2.1�����ղ���������ҩ����ҽ��һ�ɽ��յ�Ĭ��ҩ����</li>"
		+ "<li>2.2��������ʱҽ��ʱ�����յ������ʱ��ֱ��ܱ������е���Һʱ���߼���<i>�÷��������տ�������</i>�е���ֹʱ��ܿأ���������������ҽ������ʱ��Ҫ��ʱ����ʱҽ�������ɽ��յ����䡣</li>"
		+ "<li>     ע�⣺��ҽ������ࡢ������������������ĵ�ҽ����ϵͳĬ�Ͼ���ҩ������ȫʱ�ν�����ʱҽ����</li>"
		+ "<li>3��<i>������Һ�������°�ʱ���޸ľ�����տ���</i>���ر�ʱ��Ĭ�Ͼ����������ִ�м�¼���������ղ�������</li>"
	;
	$("#Panel-Tools-DosingRecConfig-Tip").popover({
		trigger:'hover',
		content:_content
	});

}
function GetConfigData2(Node,SubNode)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode1",
		Node:Node,
		SubNode:SubNode,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	return value
}
function GetConfigData3(Node,SubNode1,SubNode2)
{
	var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode3",
		Node:Node,
		SubNode1:SubNode1,
		SubNode2:SubNode2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	return value
}
function InitDosingConfig(){
	$("#BSaveDosingConfig").click(SaveDosingConfig);
	$("#Check_IPDosingNextDay,#Check_IPDosingTodayRecLoc").checkbox({
		onCheckChange:function (e,value){
			var id=e.target.id;
			if (id=="Check_IPDosingNextDay"){
				if (value==true){
					$("#DTPicker_DosingStartTime").timespinner('enable');
					var time=$("#DTPicker_DosingStartTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingStartTime").timespinner('setValue','00:00:00');
					}
					$("#Check_IPDosingTodayRecLoc").checkbox('uncheck');
					$("#DTPicker_DosingEndTime").timespinner('disable').timespinner('setValue','');
				}
			}
			if (id=="Check_IPDosingTodayRecLoc"){
				if (value==true){
					$("#DTPicker_DosingStartTime,#DTPicker_DosingEndTime").timespinner('enable')
					var time=$("#DTPicker_DosingStartTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingStartTime").timespinner('setValue','00:00:00');
					}
					var time=$("#DTPicker_DosingEndTime").timespinner('getValue');
					if (time==""){
						$("#DTPicker_DosingEndTime").timespinner('setValue','23:59:59');
					}
					$("#Check_IPDosingNextDay").checkbox('uncheck');
				}
				
			}
			var value1=$("#Check_IPDosingNextDay").checkbox('getValue');
			var value2=$("#Check_IPDosingTodayRecLoc").checkbox('getValue');
			if ((value1==false)&&(value2==false)){
				$("#DTPicker_DosingStartTime").timespinner('disable').timespinner('setValue','');
				$("#DTPicker_DosingEndTime").timespinner('disable').timespinner('setValue','');
			}
		}
	});
}
	
/// ���ؾ�����������
function LoadDosingConfig(){
	if (PageLogicObj.LocRowID==""){
		ActiveDosingConfig(false);
		return;
	}else{
		ActiveDosingConfig(true);
	}
	$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
		var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,ele.id.split("_")[1]);
		$(ele).checkbox(value==1?'check':'uncheck');
	})
	$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
		var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,ele.id.split("_")[1]);
		$(ele).timespinner('setValue',value);	//value==""?'00:00:00':value
	})
	var value=GetConfigData3("IPDosingRecLoc",PageLogicObj.LocRowID,"Active");
	$HUI.switchbox('#ISDosingRecLoc').setValue(value==1?true:false);

	function ActiveDosingConfig(Active){
		$HUI.switchbox('#ISDosingRecLoc').setValue(Active);
		$HUI.switchbox('#ISDosingRecLoc').setActive(Active);
		$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
			$(ele).checkbox('setValue',Active).checkbox('setDisable',!Active);
		})
		$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
			$(ele).timespinner(Active?'enable':'disable').timespinner('setValue','');
		})
	}
}
function SaveDosingConfig(){
	if (PageLogicObj.LocRowID==""){
		$.messager.alert("��ʾ", "��ѡ����Ҫ�����ҩ��!");
		return false;
	}
	var LocRowID=PageLogicObj.LocRowID;
	var value=$HUI.switchbox('#ISDosingRecLoc').getValue();
	var IPDosingRecLoc=value===true?1:0;
	var DosingConfig={};
	DosingConfig[LocRowID]={}
	DosingConfig[LocRowID]["Active"]=IPDosingRecLoc
	
	$('#DosingConfig').find('[class~="hisui-checkbox"]').each(function(index,ele){
		var value=$(ele).checkbox('getValue');
		DosingConfig[LocRowID][ele.id.split("_")[1]]=value==true?'1':'0'
	})
	
	$('#DosingConfig').find('[class~="hisui-timespinner"]').each(function(index,ele){
		var value=$(ele).timespinner('getValue');
		DosingConfig[LocRowID][ele.id.split("_")[1]]=value;	//value==""?'00:00:00':value
	})
	var ConfigJson=$.extend({},{IPDosingRecLoc:DosingConfig});
	console.log(JSON.stringify(ConfigJson))
	var rtn=$.m({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		MethodName:"SaveDocConfigCommon",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		ConfigJson:JSON.stringify(ConfigJson)
	},false);
	if (rtn=="0"){
		$.messager.popover({msg: '����ɹ���',type: 'success',timeout: 2000, showType: 'slide' });
	}else{
		$.messager.popover({msg: '����ʧ�ܣ��������쳣��',type: 'error',timeout: 2000});
	}
}




