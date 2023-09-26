var PageLogicObj={
	m_RBCClinicGroupTabDataGrid:"",
	m_ReHospitalDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		RBCClinicGroupTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		RBCClinicGroupTabDataGridLoad();
	}
});
function Init(){
	PageLogicObj.m_RBCClinicGroupTabDataGrid=InitRBCClinicGroupTabDataGrid();
}
function InitRBCClinicGroupTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }, {
        text: 'ҽԺ��Ȩ',
        iconCls: 'icon-house',
        handler: function() { ReHospitalHandle();}
    }];
    var Columns=[[ 
    	{field:'ID',hidden:true,title:''},
		{field:'CLGRPCode',title:'����',width:300},
		{field:'CLGRPDesc',title:'����',width:300},
		{field:'CLGRPDateFrom',title:'��ʼ����',width:300},
		{field:'CLGRPDateTo',title:'��������',width:300}
    ]];
    var RBCClinicGroupTabDataGrid=$("#RBCClinicGroupTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true, 
		idField:'ID', 
		pageSize: 20,
		pageList : [20,100,200],
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			clear();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return RBCClinicGroupTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["CLGRPCode"]);
	$("#name").val(row["CLGRPDesc"]); 
	$HUI.datebox("#StartDate").setValue(row["CLGRPDateFrom"]);
	$HUI.datebox("#EndDate").setValue(row["CLGRPDateTo"]);
}
function InitEvent(){
	$('#Bfind').click(RBCClinicGroupTabDataGridLoad);
}
function RBCClinicGroupTabDataGridLoad(){
	var CLGRPCode=$("#code").val();
	var CLGRPDesc=$("#name").val();
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.q({
	    ClassName : "web.DHCRBCClinicGroup",
	    QueryName : "GetAllClinicGroupNew",
	    CLGRPCode:CLGRPCode,
	    CLGRPDesc:CLGRPDesc,
	    HospId:HospID,
	    Pagerows:PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"InsertClinicGroup",
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate,
		HospID:HospID
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("��ʾ","���ӳɹ�!")
			clear()
			RBCClinicGroupTabDataGridLoad()
		}else if(rtn=="2"){
			$.messager.alert("��ʾ","רҵ������ظ�!")
			return false
		}else{
			$.messager.alert("��ʾ","����ʧ��!")
			return false
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	if(!CheckData()) return false;
	var ID=row["ID"]
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	var EndDate=$HUI.datebox("#EndDate").getValue()
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"UpdateClinicGroup",
		id:ID,
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("��ʾ","���³ɹ�!")
			PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid("getRowIndex",row),
				row: {
					CLGRPCode:Code,
					CLGRPDesc:Name,
					CLGRPDateFrom:StDate,
					CLGRPDateTo:EndDate
				}
			});
		}else if(rtn=="2"){
			$.messager.alert("��ʾ","רҵ������ظ�!")
			return false
		}else{
			$.messager.alert("��ʾ","����ʧ��!")
			return false
		}
	});
	
}
function CheckData(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if(Code==""){$.messager.alert("��ʾ","���������!");return false;}
	if(Name==""){$.messager.alert("��ʾ","����������!");return false;}
	if(StDate==""){$.messager.alert("��ʾ","�����뿪ʼ����!");return false;}
	return true;
}
function clear(){
	$("#code").val("")
	$("#name").val("")
	$HUI.datebox("#StartDate").setValue("")
	$HUI.datebox("#EndDate").setValue("")
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function ReHospitalHandle(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	GenHospWin("RBC_ClinicGroup",row.ID,function(){
	});
	/*$("#ReHospital-dialog").dialog("open");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			QueryName:"GetHos",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Hosp", {
				editable:false,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc', 
				data: GridData["rows"],
				onLoadSuccess:function(){
					$("#Hosp").combobox('select','');
				}
			 });
	});
	PageLogicObj.m_ReHospitalDataGrid=ReHospitalDataGrid();
	LoadReHospitalDataGrid();*/
}
function ReHospitalDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {ReHospitaladdClickHandle();}
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() {ReHospitaldelectClickHandle();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:'Rowid'},
		{field:'HospID',hidden:true,title:'HospID'},
		{field:'HospDesc',title:'ҽԺ',width:100}
    ]]
	var ReHospitalDataGrid=$("#ReHospitalTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar,
		onClickCell:function(rowIndex, field, value){
			},
		onCheck:function(index, row){
		},
		onUnselect:function(index, row){
		},
		onBeforeSelect:function(index, row){

		},onLoadSuccess:function(data){
		}
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["ID"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"RBC_ClinicGroup",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("��ʾ","��ѡ��ҽԺ","info");
		return false;
		}
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["ID"]
	$.cm({
		ClassName:"DHCDoc.Common.Hospital",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"RBC_ClinicGroup",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("��ʾ","�����ظ�","info");
		}else{
		$.messager.alert("��ʾ",data.split("^")[1],"info");
		LoadReHospitalDataGrid();}
	})
	}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (SelectedRow==null){
		$.messager.alert("��ʾ","��ѡ��һ��","info");
		return false;
	}
	var row=PageLogicObj.m_RBCClinicGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["ID"]
	$.cm({
		ClassName:"DHCDoc.Common.Hospital",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"RBC_ClinicGroup",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
			$.messager.alert("��ʾ","ɾ���ɹ�","info");
			LoadReHospitalDataGrid();
	})
	
	}