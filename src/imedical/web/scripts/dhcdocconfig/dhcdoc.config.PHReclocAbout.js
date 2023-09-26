
var PageLogicObj={
	ItemCatExtDataGrid:"",
	editRow:undefined,
	LocRowID:""
}

$(function(){ 
	InitHospList();
    $("#BFind").click(LoadItemCatExtDataGrid);
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
	InitComboPHRecLoc();
    InitItemCatExtDataGrid();
}
function InitItemCatExtDataGrid()
{
	var ItemCatExtTools = [{
            text: '����',
            iconCls: 'icon-save',
            handler: function() {
	            Save();
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
		onClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
		        return false;
			}
			PageLogicObj.ItemCatExtDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex
		}
	});
	LoadItemCatExtDataGrid();
};
function LoadItemCatExtDataGrid()
{
	var LocId=$("#Combo_PHRecLoc").combobox("getValue");
	PageLogicObj.LocRowID=LocId;
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.PHReclocAbout",
	    QueryName : "GetItemCatExtConfig",
	    PHRecloc:LocId,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.ItemCatExtDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.editRow = undefined;
		PageLogicObj.ItemCatExtDataGrid.datagrid('unselectAll');
		PageLogicObj.ItemCatExtDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
function InitComboPHRecLoc()
{
	var GridData=$.cm({
	    ClassName : "DHCDoc.DHCDocConfig.DocConfig",
	    QueryName : "FindDep",
	    desc:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},false);
	$("#Combo_PHRecLoc").combobox({   
		valueField:'CTLOCRowID',   
		textField:'CTLOCDesc',
		data:GridData['rows'],
		onSelect:function(){
			$("#BFind").click();
		}
	})
	$("#Combo_PHRecLoc").combobox("setValue","")
};
function Save(){
	if(PageLogicObj.LocRowID==""){
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
