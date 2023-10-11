///===========================================================================================
/// Author��      qunianpeng
/// Date:		 2021-04-22
/// Description:	 �������ҩƷtab
///===========================================================================================

var drugTypeArr = [{"value":"DrugData","text":"��ҩ"},{"value":"ChineseDrugData","text":"�г�ҩ"},{"value":"ChineseHerbalMedicineData","text":"��ҩ��Ƭ"}]
var selDataID = "";	// ѡ����ֵ�id
var selCatID = "";	// ѡ��ķ���id
var chkValue = "";	// �Ƿ����
var drugType = "";	// ҩƷ����
var datagridID = "";// tab�е�datagirdID

/// ҳ���ʼ������
function initPageDefault(){
	
	initParams();		// ��ʼ������
	InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitCombobox();		// ��ʼ��combobox
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitTree();     	// ��ʼ������
}

/// ��ʼ������
function initParams(){
	
	selDataID =  getParam("selDataID");
	selCatID = getParam("selCatID");

}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){
	
	/* tab�л� */
	$HUI.tabs("#linkTab",{	
		onSelect:function(title){
			switchTab();						
		}		
	});
	
	datagridID = getDatagridId("");
	$HUI.radio("[name='FilterCK']",{	// ������ѡ 
        onChecked:function(e,value){	        
	        //$HUI.combotree("#"+datagridID).setValue("");
	        chkValue=this.value;
	        var tab = this.getAttribute("data-code");	        
	        findLinkList(tab);
	        cleanCombotree(tab);
        }
	});
	
	$('#drugDesc').searchbox({	// ҩƷ����
	    searcher:function(value,name){
		    findLinkList("drug");
		}	   
	});
	
	$('#genformDesc').searchbox({	// ������ͨ��������
	    searcher:function(value,name){
		    findLinkList("genform");
		}	   
	});
	
	$('#generDesc').searchbox({	// ͨ��������
	    searcher:function(value,name){
		    findLinkList("gener");
		}	   
	});
	
	$('#ingrDesc').searchbox({	// �ɷּ���
	    searcher:function(value,name){
		    findLinkList("ingr");
		}	   
	});

	$("#selmulitm").bind("click",selItmMulSelRow);	// ��������	
	
	$("#remomulitm").bind("click",revItmMulSelRow);	// �����Ƴ�
	
	
}

/// ��ʼ��combobox
function InitCombobox(){

	/*  ҩƷ���� */
    $HUI.combobox("#drugType",{	 
		    valueField:'value',
			textField:'text',
			panelHeight:"150",
			mode:'remote',
			data:drugTypeArr,
			onSelect:function(opt){
				findLinkList("");
			}
	   })
}

/// ҳ��DataGrid��ʼ������
function InitDataList(){
	
	/* ҩƷtab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'����',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'ҩƷ����',width:100,align:'center'},
		{field:'Desc',title:'ҩƷ����',width:150,align:'center'},
		{field:'CatDesc',title:'�����ķ���',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        }
	};	
	var params = selCatID;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params+"&drugType=";
	new ListComponent('drugTable', columns, uniturl, option).Init(); 
	
	/* ͨ����(������)tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'����',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'ͨ��������',width:100,align:'center'},
		{field:'Desc',title:'ͨ��������',width:150,align:'center'},
		{field:'CatDesc',title:'�����ķ���',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        }
	};	
	var uniturl = ""
	new ListComponent('genformTable', columns, uniturl, option).Init(); 
	
	/* ͨ����tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'����',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'ͨ��������',width:100,align:'center'},
		{field:'Desc',title:'ͨ��������',width:150,align:'center'},
		{field:'CatDesc',title:'�����ķ���',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        }
	};	

	var uniturl = ""
	new ListComponent('generTable', columns, uniturl, option).Init(); 
	
	/* �ɷ�tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'����',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'�ɷִ���',width:100,align:'center'},
		{field:'Desc',title:'�ɷ�����',width:150,align:'center'},
		{field:'CatDesc',title:'�����ķ���',width:150,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        }
	};
	
	var uniturl = "";
	new ListComponent('ingrTable', columns, uniturl, option).Init(); 
}

/// ��ʼ������
function InitTree(){
	
	/* ҩƷtab-������ */
	$HUI.combotree("#drugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){			
			findLinkList("");
		}
	})
	
	/* ͨ����(������)tab-������ */
	$HUI.combotree("#genformdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){
			findLinkList("");
		}
	})
	
	/* ͨ����tab-������ */
	$HUI.combotree("#generdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){			
			findLinkList("");
		}
	})
	
	/* �ɷ�tab-������ */
	$HUI.combotree("#ingrdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){
			findLinkList("");
		}
	})
}

function SetLinkOp(value, rowData, rowIndex){
	
	if (rowData.Link == "0"){
		var html = "<a href='#' onclick='selItmSelRow("+rowIndex+")'>����</a>";
	}else{
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>�Ƴ�</a>";
	}
    return html;
}

/// ��ѯ����������
function findLinkList(tab){
	
	var paramsArr = getParams(tab);
	var params = paramsArr[0];
	var drugType = paramsArr[1];
	$("#"+datagridID).datagrid('load',{"params":params,"drugType":drugType});
}


/// ����
function selItmSelRow(rowIndex){

	var rowData=$("#"+datagridID).datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id||"";
	var DrugCatAttrId=rowData.DrugCatAttrId||"";	
	var ListData="" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ selCatID +"^"+ "";
	
	//runClassMethod("web.DHCCKBDicLinkAttr","InsText",{"ListData":ListData},
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":ListData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},	
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});            	
           	}
           	$("#"+datagridID).datagrid('reload');
 	})
}

/// �Ƴ�
function revItmSelRow(rowIndex){
	
	var rowData=$("#"+datagridID).datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id||"";
	var DrugCatAttrId=rowData.DrugCatAttrId||"";
	var ListData=DrugId +"^"+ DrugCatAttrId +"^"+ selCatID;
	
	
	//runClassMethod("web.DHCCKBDiction","revRelation",{"ListData":ListData},	function(data){
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":ListData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},function(data){
    	if(data==0){
        	$.messager.popover({msg: '�Ƴ��ɹ���',type:'success',timeout: 1000});
       	}
       	$("#"+datagridID).datagrid('reload');
	})
}

/// ��������
function selItmMulSelRow() {
	
	var radioObj = $("input[name='FilterCK']:checked");
	if (radioObj.val() == 1){
		$.messager.popover({
			msg: 'ѡ���ҩƷ�Ѿ�����,����Ҫ�ظ�����!',
			type: 'info',
			timeout: 2000, 		//0���Զ��رա�3000s
			showSpeed: 'slow', //fast,slow,normal,1500
			showType: 'fade'  //show,fade,slide
		});	
		return;
	}
	
	var rowData = $("#"+datagridID).datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('��ʾ',"��ѡ����Ҫ����������!","info");
		return false;
	}
		
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		var DrugId = rowData[i].Id||"";
		var DrugCatAttrId = rowData[i].DrugCatAttrId||"";
		var tempList = "" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ selCatID +"^"+ "";
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":listData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
            	
           	}
           $("#"+datagridID).datagrid('reload');
 	})
}

/// �����Ƴ�
function revItmMulSelRow(){
	var rowData = $("#"+datagridID).datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('��ʾ',"��ѡ����Ҫ������ҩƷ!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		
		var DrugId = rowData[i].Id||"";
		var DrugCatAttrId = rowData[i].DrugCatAttrId||"";
		var tempList = DrugId +"^"+ DrugCatAttrId +"^"+ selCatID
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":listData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '�Ƴ��ɹ���',type:'success',timeout: 1000});
            	
           	}
           	$("#"+datagridID).datagrid('reload');
 	})
}

/// tab�л��¼�
function switchTab(){
	
	var selTab = $('#linkTab').tabs('getSelected');
	var tab = selTab.panel('options').id; 
	datagridID = getDatagridId(tab);
	chkValue = "";
	$('input:radio[name=FilterCK]').each(function (i) {
		 	$(this).attr("checked","false");		 	   
	});  
	
	var paramsArr = getParams(tab);
	var params = paramsArr[0];
	var drugType = paramsArr[1];
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params+"&drugType="+drugType;
	$('#'+datagridID).datagrid('options').url = uniturl;
	$('#'+datagridID).datagrid('reload');	
}

/// ��ȡ��ѯ�Ĳ���
function getParams(tabID){
	
	var paramsArr = []; 
	if (tabID == ""){
		tabID = "drug";
	}
	switch (tabID){
		 case "drug":	// ҩƷ��������
			var drugDesc = $HUI.searchbox("#drugDesc").getValue();
			var subSelCatObj = $HUI.combotree("#drugcat").getValue();
			var subSelCatID = "";
			if (subSelCatObj){
				subSelCatID = subSelCatObj.id;
			}
			var drugType =$HUI.combobox("#drugType").getValue()||"";
			var params = selCatID +"^"+ drugDesc +"^"+ chkValue +"^"+ subSelCatID;	
			paramsArr.push(params);
			paramsArr.push(drugType);
			break;			
			
		 case "genform":	// ͨ���������͹�������
		 	var genformDesc = $HUI.searchbox("#genformDesc").getValue();
		 	var params = selCatID +"^"+ genformDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "GeneralFromData";
			paramsArr.push(params);
			paramsArr.push(drugType);			
			break;
			
		 case "gener":		// ͨ������������
			var generDesc = $HUI.searchbox("#generDesc").getValue();
		 	var params = selCatID +"^"+ generDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "GeneralData";
			paramsArr.push(params);
			paramsArr.push(drugType);			
		 	break;
		 case "ingr":		// �ɷ�
			var ingrDesc = $HUI.searchbox("#ingrDesc").getValue();
		 	var params = selCatID +"^"+ ingrDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "ingredientData";
			paramsArr.push(params);
			paramsArr.push(drugType);	
		 	break;	
	}
	
	return paramsArr;
}

/// ��ȡtab�е������б�id
function getDatagridId(tabID){
	var datagridID = "";
	switch (tabID){
		 case "drug":	// ҩƷ��������	
		 	datagridID = "drugTable";	
			break;			
			
		 case "genform":	// ͨ���������͹�������
		 	datagridID = "genformTable";		
			break;
			
		 case "gener":		// ͨ������������
			datagridID = "generTable";			
		 	break;
		 	
		 case "ingr":		// �ɷ�
			datagridID = "ingrTable";
		 	break;	
		 	
		 default:
		 	datagridID = "drugTable";
	}
	
	return datagridID;
}

/// �����ѯ����ķ���
function cleanCombotree(tab){
	
	var combotreeId = "";
	switch (tab){
		 case "drug":	// ҩƷ��������	
		 	combotreeId = "drugcat";	
			break;			
			
		 case "genform":	// ͨ���������͹�������
		 	combotreeId = "genformdrugcat";		
			break;
			
		 case "gener":		// ͨ������������
			combotreeId = "generdrugcat";			
		 	break;
		 	
		 case "ingr":		// �ɷ�
			combotreeId = "ingrdrugcat";
		 	break;	
		 	
		 default:
		 	combotreeId = "drugcat";
	}
	
	$HUI.combotree("#"+combotreeId).setValue("");
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
