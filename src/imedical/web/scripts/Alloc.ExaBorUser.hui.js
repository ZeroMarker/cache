var PageLogicObj={
	m_ExaBoroughUserTabDataGrid:""
};
$(function(){
	Init();
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	ExaBoroughUserTabDataGridLoad();
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
	$("#User").combobox({
		valueField: 'id',
		textField: 'name', 
		editable:true,
		mode:'remote',
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=UFindUserNew&username=&rows=99999",
		loadFilter:function(data){
		    return data['rows'];
		},
		onBeforeLoad:function(param){
			var username=param.q?param.q:"";
			var HospID=$HUI.combogrid('#_HospList').getValue();
			param = $.extend(param,{username:username,HospID:HospID});
		}
	})
}
function InitEvent(){
	$('#Bfind').click(ExaBoroughUserTabDataGridLoad);
	$('#Bconfig').click(BconfigclickHandle);
	$('#BSaveCongfid').click(BSaveCongfidclickHandle);
}
function Init(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("DHCBorUser");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		ExaBoroughUserTabDataGridLoad();
	}
	PageLogicObj.m_ExaBoroughUserTabDataGrid=InitExaBoroughUserTabDataGrid();
}
function InitExaBoroughUserTabDataGrid(){
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
		{field:'Tid',hidden:true,title:''},
		{field:'Tusename',title:'����Ա',width:300},
		{field:'Tborname',title:'������',width:300},
		{field:'isDefault',title:'�Ƿ�Ĭ��',width:100,
			styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
			},
			formatter: function(value,row,index){
				if (value=="Y"){
					return "��";
				} else {
					return "��";
				}
			}
		},
		{field:'Tborid',title:'',hidden:true},
		{field:'Tuseid',title:'',hidden:true}
    ]]
	var ExaBoroughUserTabDataGrid=$("#ExaBoroughUserTab").datagrid({
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
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			$("#ExaBord,#User").combobox("select","");
			$("#isDefault").checkbox('uncheck');
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ExaBoroughUserTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.select(row["Tborid"]);
	var cbox=$HUI.combobox("#User"); 
	var ExaRoomDr=cbox.select(row["Tuseid"]);
	var IsDefault=row["isDefault"];
	if (IsDefault=="Y") {
		$("#isDefault").checkbox('check');
	}else{
		$("#isDefault").checkbox('uncheck');
	}
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#User"); 
	var User=cbox.getValue(); 
	var isDefault=$("#isDefault").checkbox('getValue')?"Y":"N";
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertBorUser",
		dataType:"text",
		itmjs:"",
		itmjsex:"",
		useDr:User,
		borDr:BordBorDr,
		isDefault:isDefault
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���ӳɹ�!");
			ClearData();
			PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('uncheckAll');
			ExaBoroughUserTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"deluse",
		itmjs:"",
		itmjsex:"",
		rid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","ɾ���ɹ�!");
			ClearData();
			PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('uncheckAll');
			ExaBoroughUserTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#ExaBord"); 
	var BordBorDr=cbox.getValue();
	var cbox=$HUI.combobox("#User"); 
	var User=cbox.getValue(); 
	var isDefault=$("#isDefault").checkbox('getValue')?"Y":"N";
	$.cm({ 
		ClassName:"web.DHCExaBorough",
		MethodName:"updateBorUser",
		itmjs:"",
		itmjsex:"",
		useDr:User,
		borDr:BordBorDr,
		rowid:row["Tid"],
		isDefault:isDefault
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���³ɹ�!");
			ClearData();
			PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid('uncheckAll');
			ExaBoroughUserTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			return false;
		}
	});
	
}
function ClearData(){
	var cbox=$HUI.combobox("#ExaBord"); 
	cbox.select("");
	var cbox=$HUI.combobox("#User"); 
	cbox.select("");
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
	var cbox=$HUI.combobox("#User"); 
	var ExaRoom=cbox.getValue();
	var ExaRoom=CheckComboxSelData("User",ExaRoom);
	if (ExaRoom==""){
		$.messager.alert("��ʾ","��ѡ�����Ա!","info",function(){
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
		 if (id=="User"){
			 var CombValue=Data[i].id;
		 }else{
		 	var CombValue=Data[i].rid;
		 }
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
function ExaBoroughUserTabDataGridLoad(){
	var borid=$("#ExaBord").combobox("getValue");
	var userid=$("#User").combobox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindDHCBorUser",
	    borid:borid, 
	    userid:userid,
	    HospId:HospID,
	    Pagerows:PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid("uncheckAll");
		PageLogicObj.m_ExaBoroughUserTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function BconfigclickHandle(){
	$("#config-dialog").dialog("open");
	LoadGroupData();
}
function BSaveCongfidclickHandle(){
	var GroupDataStr=""
	var size = $("#List_AudiNotLimitedGroup option").size();
	if(size>0){
		$.each($("#List_AudiNotLimitedGroup  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (GroupDataStr=="") GroupDataStr=svalue
			else GroupDataStr=GroupDataStr+"^"+svalue
		})
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.m({
		ClassName:"web.DHCExaBorough",
		MethodName:"InsertExaBoroughGroupUser",
		Str:GroupDataStr,
		HospID:HospID,
		dataType:"text",
	},function(datastr){
		if (datastr=="0"){
			$.messager.alert("��ʾ","���³ɹ�!");
			$("#config-dialog").dialog("close");
		}
	});	
}
function LoadGroupData(){
	$.m({
		ClassName:"web.DHCExaBorough",
		MethodName:"FindGroupListBroker",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		$("#List_AudiNotLimitedGroup").find("option").remove();
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneGroup=objScopeArr[i];
			var oneGroupArr=oneGroup.split(String.fromCharCode(2))
			var GroupRowID=oneGroupArr[0];
			var GroupDesc=oneGroupArr[1];
			var selected=oneGroupArr[2];
			vlist += "<option value=" + GroupRowID + ">" + GroupDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_AudiNotLimitedGroup").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_AudiNotLimitedGroup").get(0).options[j-1].selected = true;
			}
		}
	});	
}