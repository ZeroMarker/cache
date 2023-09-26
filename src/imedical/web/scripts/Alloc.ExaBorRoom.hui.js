var PageLogicObj={
	m_ExaBoroughRoomTabDataGrid:""
}
$(function(){
	Init();
	InitEvent();
});
function PageHandle(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	//��ʼ������
	$.cm({
		ClassName:"web.DHCExaBorough",
		QueryName:"FindExaBorough",
		dataType:"json",
		borname:"",
		HospId:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ExaBord", {
				valueField: 'rid',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
				}
		 });
	});
    //��ʼ������
    $.cm({
		ClassName:"web.DHCOPBorExaRoom",
		QueryName:"FindDHCExaRoom",
		dataType:"json",
		room:"",
		HospId:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ExaRoom", {
				valueField: 'rid',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function InitEvent(){
	$('#Bfind').click(ExaBoroughRoomTabDataGridLoad);
}
function Init(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("DHCBorExaRoom");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		$("#BordMemo").val("");
		$("#ExaBord,#ExaRoom").combobox('select',"");
        ExaBoroughRoomTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_ExaBoroughRoomTabDataGrid=InitExaBoroughRoomTabDataGrid();
		PageHandle();
		ExaBoroughRoomTabDataGridLoad();
	}
}
function InitExaBoroughRoomTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'ID',hidden:true,title:''},
		{field:'BorDesc',title:'������',width:300},
		{field:'BorExaRoomDesc',title:'����',width:300},
		{field:'Memo',title:'��ע',width:300},
		{field:'BorDr',title:'',hidden:true},
		{field:'BorExaRoomDr',title:'',hidden:true}
    ]]
	var ExaBoroughRoomTabDataGrid=$("#ExaBoroughRoomTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'ID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			$("#ExaBord,#ExaRoom").combobox("select","");
			$("#BordMemo").val("");
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ExaBoroughRoomTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.select(row["BorDr"]);
	var cbox=$HUI.combobox("#ExaRoom"); 
	var ExaRoomDr=cbox.select(row["BorExaRoomDr"]);
	$("#BordMemo").val(row["Memo"]);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#ExaRoom"); 
	var ExaRoomDr=cbox.getValue();
	var BordMemo=$("#BordMemo").val();
	$.cm({
		ClassName:"web.DHCOPBorExaRoom",
		MethodName:"insertDHCBorExaRoom",
		itmjs:"",
		itmjsex:"",
		BorDr:BordBorDr,
		ExaRoomDr:ExaRoomDr,
		comm:BordMemo
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '���ӳɹ�!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
			ExaBoroughRoomTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�������Ѿ�����!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCOPBorExaRoom",
		MethodName:"DeleteDHCBorExaRoom",
		itmjs:"",
		itmjsex:"",
		ID:row["ID"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
			ExaBoroughRoomTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#ExaRoom"); 
	var ExaRoomDr=cbox.getValue();
	var BordMemo=$("#BordMemo").val();
	$.cm({
		ClassName:"web.DHCOPBorExaRoom",
		MethodName:"UpdateDHCBorExaRoom",
		itmjs:"",
		itmjsex:"",
		ID:row["ID"],
		BorDr:BordBorDr,
		BorExaRoomDr:ExaRoomDr,
		Memo:BordMemo
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '���³ɹ�!',type:'success',timeout: 1000});
			ClearData();
			PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid('uncheckAll');
			ExaBoroughRoomTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�������Ѿ�����!");
			return false;
		}
	});
	
}
function ClearData(){
	var cbox=$HUI.combobox("#ExaBord"); 
	cbox.select("");
	var cbox=$HUI.combobox("#ExaRoom"); 
	cbox.select("");
	$("#BordMemo").val("");
}
function CheckDataValid(){
	var cbox=$HUI.combobox("#ExaBord"); 
	var ExaBord=cbox.getValue();
	var ExaBord=CheckComboxSelData("ExaBord",ExaBord);
	if (ExaBord==""){
		$.messager.alert("��ʾ","��ѡ�������!","info",function(){
			$('#ExaBord').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#ExaRoom"); 
	var ExaRoom=cbox.getValue();
	var ExaRoom=CheckComboxSelData("ExaRoom",ExaRoom);
	if (ExaRoom==""){
		$.messager.alert("��ʾ","��ѡ������!","info",function(){
			$('#ExaRoom').next('span').find('input').focus();
		});
		return false;
	}
	return true;
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 var CombValue=Data[i].rid
		 var CombDesc=Data[i].name
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function ExaBoroughRoomTabDataGridLoad(){
	var BordBorDr=$("#ExaBord").combobox("getValue");
	var ExaRoomDr=$("#ExaRoom").combobox("getValue");
	$.q({
	    ClassName : "web.DHCOPBorExaRoom",
	    QueryName : "Find",
	    BordBorDr:BordBorDr, 
	    ExaRoomDr:ExaRoomDr,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_ExaBoroughRoomTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}