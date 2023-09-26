var PageLogicObj={
	m_ChgDepMarkSetTabDataGrid:""
};
$(function(){
	InitHospList();
});
function InitHospList(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("DHC_OPChgDepMarkSet");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ClearData()
		PageHandle();
		ChgDepMarkSetTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//ҳ��Ԫ�س�ʼ��
		PageHandle();
		//������ݳ�ʼ��
		PageLogicObj.m_ChgDepMarkSetTabDataGrid=InitExaBoroughRoomTabDataGrid();
		ChgDepMarkSetTabDataGridLoad();
	}
	
}
function PageHandle(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	//��ʼ������
	$.cm({
		ClassName:"web.DHCOPChgDepMarkSet",
		QueryName:"Finddep",
		dataType:"json",
		DepDesc:"",
		HospId:HospID,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#DepSource,#DepTarget", {
				valueField: 'RowID',
				textField: 'Desc',
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					var opts = $(this).combobox('options');
					return row['Desc'].toUpperCase().indexOf(q.toUpperCase()) >= 0||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(rec){
					//���ؿ����б�
					if (rec) {
						LoadMarkSource(this.id,rec["RowID"]);
					}
				},onChange:function(newValue,OldValue){
					if (newValue==""){
						if (this.id=="DepSource"){
							var cbox = $HUI.combobox("#MarkSource");
						}else{
							var cbox = $HUI.combobox("#MarkTarget");
						}
						cbox.select("");
					}
				}
		 });
	});
}
function LoadMarkSource(objectid,deptid){
	//�ű����ݼ��أ��˴�������ͬ�����أ�����ᵼ�µ�һ��ѡ����ʱѡ��������
	var Data=$.cm({
		ClassName:"web.DHCOPChgDepMarkSet",
		QueryName:"Findloc",
		dataType:"json",
		depid:deptid,
		MarkSource:"",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
	if (objectid=="DepSource"){
		var id="MarkSource";
	}else{
		var id="MarkTarget";
	}
	var cbox = $HUI.combobox("#"+id, {
			valueField: 'RowID',
			textField: 'Desc', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
	 });
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
        handler: function() { SaveClickHandle();}
    }];
	var Columns=[[ 
		{field:'ID',hidden:true,title:''},
		{field:'DepSourceDesc',title:'ԭ����',width:150},
		{field:'MarkSourceDesc',title:'ԭ�ű�',width:150},
		{field:'DepTargetDesc',title:'ת������',width:150},
		{field:'MarkTargetDesc',title:'ת���ű�',width:150},
		{field:'DepSourceDr',title:'',hidden:true},
		{field:'MarkSourceDr',title:'',hidden:true},
		{field:'DepTargetDr',title:'',hidden:true},
		{field:'MarkTargetDr',title:'',hidden:true}
    ]]
	var ChgDepMarkSetTabDataGrid=$("#ChgDepMarkSetTab").datagrid({
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
			$("#DepSource,#MarkSource,#DepTarget,#MarkTarget").combobox('select',"");
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return ChgDepMarkSetTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#DepSource"); 
	cbox.select(row["DepSourceDr"]);
	var cbox=$HUI.combobox("#MarkSource"); 
	cbox.select(row["MarkSourceDr"]);
	var cbox=$HUI.combobox("#DepTarget"); 
	cbox.select(row["DepTargetDr"]);
	var cbox=$HUI.combobox("#MarkTarget"); 
	cbox.select(row["MarkTargetDr"]);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#DepSource"); 
	var DepSourceDr=cbox.getValue();
	var cbox=$HUI.combobox("#MarkSource"); 
	var MarkSourceDr=cbox.getValue();
	var cbox=$HUI.combobox("#DepTarget"); 
	var DepTargetDr=cbox.getValue();
	var cbox=$HUI.combobox("#MarkTarget"); 
	var MarkTargetDr=cbox.getValue();
	$.cm({
		ClassName:"web.DHCOPChgDepMarkSet",
		MethodName:"Insert",
		DepSourceDr:DepSourceDr,
		MarkSourceDr:MarkSourceDr,
		DepTargetDr:DepTargetDr,
		MarkTargetDr:MarkTargetDr
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���ӳɹ�!");
			ClearData();
			PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('uncheckAll');
			ChgDepMarkSetTabDataGridLoad();
		}else{
			if (rtn=="-1"){
				$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			}else{
				$.messager.alert("��ʾ","����ʧ��!");
			}
			return false;
		}
	});
}
function SaveClickHandle(){
	var row=PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('getSelected');
	if (row){
		var ID=row['ID'];
	}else{
		$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var cbox=$HUI.combobox("#DepSource"); 
	var DepSourceDr=cbox.getValue();
	var cbox=$HUI.combobox("#MarkSource"); 
	var MarkSourceDr=cbox.getValue();
	var cbox=$HUI.combobox("#DepTarget"); 
	var DepTargetDr=cbox.getValue();
	var cbox=$HUI.combobox("#MarkTarget"); 
	var MarkTargetDr=cbox.getValue();
	$.cm({
		ClassName:"web.DHCOPChgDepMarkSet",
		MethodName:"Update",
		ID:ID,
		DepSourceDr:DepSourceDr,
		MarkSourceDr:MarkSourceDr,
		DepTargetDr:DepTargetDr,
		MarkTargetDr:MarkTargetDr
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","����ɹ�!");
			ClearData();
			PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('uncheckAll');
			ChgDepMarkSetTabDataGridLoad();
		}else{
			if (rtn=="-1"){
				$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			}else{
				$.messager.alert("��ʾ","����ʧ��!");
			}
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCOPChgDepMarkSet",
		MethodName:"Delete",
		ID:row["ID"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","ɾ���ɹ�!");
			ClearData();
			PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid('uncheckAll');
			ChgDepMarkSetTabDataGridLoad();
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
			return false;
		}
	});
}
function ClearData(){
	var cbox=$HUI.combobox("#DepSource"); 
	cbox.select("");
	var cbox=$HUI.combobox("#MarkSource"); 
	cbox.select("");
	var cbox=$HUI.combobox("#DepTarget"); 
	cbox.select("");
	var cbox=$HUI.combobox("#MarkTarget"); 
	cbox.select("");
}
function CheckDataValid(){
	var cbox=$HUI.combobox("#DepSource"); 
	var deptid=cbox.getValue();
	var deptid=CheckComboxSelData("DepSource",deptid);
	if (deptid==""){
		$.messager.alert("��ʾ","��ѡ��ԭ����!","info",function(){
			$('#DepSource').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#MarkSource"); 
	var markid=cbox.getValue();
	var markid=CheckComboxSelData("MarkSource",markid);
	if (markid==""){
		$.messager.alert("��ʾ","��ѡ��ԭ�ű�!","info",function(){
			$('#MarkSource').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#DepTarget"); 
	var deptid=cbox.getValue();
	var deptid=CheckComboxSelData("DepTarget",deptid);
	if (deptid==""){
		$.messager.alert("��ʾ","��ѡ��ת������!","info",function(){
			$('#DepTarget').next('span').find('input').focus();
		});
		return false;
	}
	var cbox=$HUI.combobox("#MarkTarget"); 
	var markid=cbox.getValue();
	var markid=CheckComboxSelData("MarkTarget",markid);
	if (markid==""){
		$.messager.alert("��ʾ","��ѡ��ת���ű�!","info",function(){
			$('#MarkTarget').next('span').find('input').focus();
		});
		return false;
	}
	return true;
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
	      var CombValue=Data[i].RowID
	 	  var CombDesc=Data[i].Desc
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function ChgDepMarkSetTabDataGridLoad(){
	$(".hisui-combobox").combobox('select','');
	$.q({
	    ClassName : "web.DHCOPChgDepMarkSet",
	    QueryName : "UFindChgDepMark",
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ChgDepMarkSetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}