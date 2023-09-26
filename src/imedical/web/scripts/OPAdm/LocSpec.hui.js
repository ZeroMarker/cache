var PageLogicObj={
	m_LocSpecTabDataGrid:"",
}
function InitHospList()
{
	var hospComp = GenHospComp("DHC_LocSpec");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_LocSpecTabDataGrid=InitLocSpecTabDataGridLoad();
		Init();
	}
}
$(function(){
	InitHospList();
	//Init();
	InitEvent();
	PageHandle();
});

function Init(){
	//��ʼ������
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
		ClassName:"web.DHCOPAdmReg",	//"web.DHCRBResSession",
		QueryName:"OPDeptList",			//"FindLoc",
		UserId:session['LOGON.USERID'],
		HospitalID:$HUI.combogrid('#_HospList').getValue()
	},function(Data){
		var cbox = $HUI.combobox("#Loc", {
				valueField: 'CTCode',
				textField: 'CTDesc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["CTAlias"].toUpperCase().indexOf(q)>=0)||(row["CTDesc"].toUpperCase().indexOf(q)>=0)) return true;
				}
		 });
	});
	//��ʼ��רҵ��
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		QueryName:"GetAllClinicGroupNew",
		dataType:"json",
		CLGRPCode:"",
		CLGRPDesc:"",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},function(Data){
		var cbox=$HUI.combobox("#Clinic",{
			valueField:'ID',
			textField:'CLGRPDesc',
			editable:true,
			data:Data["rows"],
			filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			}
		})
	})
	//��ʼ��������
	$.cm({
		ClassName:"web.DHCRBCClinicServiceGroup",
		QueryName:"GetAllClinicServiceGroupNew",
		dataType:"json",
		CLSGRPCode:"",CLSGRPDesc:"",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},function(Data){
		var cbox=$HUI.combobox("#ClinicService",{
			valueField:'ID',
			textField:'CLSGRPDesc',
			editable:true,
			data:Data["rows"],
			filter: function(q, row){
					var opts = $(this).combobox('options');
					return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			}
		})
	})
	LocSpecTabDataGridLoad();
}

function PageHandle(){
}
function InitEvent(){
	$('#Bfind').bind('click', function(){
		LocSpecTabDataGridLoad();
	});
}

function InitLocSpecTabDataGridLoad(){
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
		{field:'LocName',title:'����',width:300},
		{field:'ClinicName',title:'רҵ��',width:300},
		{field:'ClinicService',title:'������',width:300},
		{field:'locid',title:'',hidden:true},
		{field:'clinicid',title:'',hidden:true},
		{field:'TimeOutFlag',title:'',hidden:true}
    ]]
	var LocSpecTabDataGrid=$("#LocSpecTab").datagrid({
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
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_LocSpecTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_LocSpecTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_LocSpecTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return LocSpecTabDataGrid;
}
function SetSelRowData(row){
	var cbox=$HUI.combobox("#Loc")
	cbox.select(row["locid"])
	var cbox=$HUI.combobox("#Clinic")
	if(row["TimeOutFlag"]!="Y") cbox.select(row["clinicid"])
	else cbox.select('');
	var cbox=$HUI.combobox("#ClinicService")
	if(row["ServiceTimeOut"]!="Y") cbox.select(row["ClinicServiceId"])
	else cbox.select('');
	
}
function LocSpecTabDataGridLoad(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var LocId=$("#Loc").combobox("getValue");
	var ClinicId=$("#Clinic").combobox("getValue");
	var ServiceGroupId=$("#ClinicService").combobox("getValue");
	$.q({
		ClassName:"web.DHCLocSpec",
		QueryName:"GetAllLocSpecNew",
		LocRowID:LocId,
		ClinicRowID:ClinicId,
		ServiceGroupId:ServiceGroupId,
		HospId:HospID,
		Pagerows:PageLogicObj.m_LocSpecTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_LocSpecTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var LocId=$("#Loc").combobox("getValue");
	var ClinicId=$("#Clinic").combobox("getValue");
	var ServiceGroupId=$("#ClinicService").combobox("getValue");
	$.q({
		ClassName:"web.DHCLocSpec",
		MethodName:"InsertLocSpec",
		loc:LocId,
		spec:ClinicId,
		serviceGroup:ServiceGroupId
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("��ʾ","����ɹ�!")
			ClearData()
			LocSpecTabDataGridLoad()
		}else if(rtn=="2"){
			$.messager.alert("��ʾ","������ͬ����!")
			return false;
		}else{
			$.messager.alert("��ʾ","����ʧ��!")
			return false;
		}
	})
}
function DelClickHandle(){
	var row=PageLogicObj.m_LocSpecTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["ID"]
	$.q({
		ClassName:"web.DHCLocSpec",
		MethodName:"DeleteLocSpecByID",
		id:ID
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("��ʾ","ɾ���ɹ�!")
			ClearData()
			LocSpecTabDataGridLoad()
			var oldIndex=PageLogicObj.m_LocSpecTabDataGrid.datagrid('getRowIndex',row);
			PageLogicObj.m_LocSpecTabDataGrid.datagrid('unselectRow',oldIndex);
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ��!")
			return false;
		}
	})
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_LocSpecTabDataGrid.datagrid('getSelected')
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	if(!CheckData()) return false;
	var ID=row["ID"]
	var LocId=$("#Loc").combobox("getValue")
	var ClinicId=$("#Clinic").combobox("getValue")
	var ServiceGroupId=$("#ClinicService").combobox("getValue");
	$.q({
		ClassName:"web.DHCLocSpec",
		MethodName:"UpdateLocSpec",
		id:ID,
		loc:LocId,
		spec:ClinicId,
		serviceGroup:ServiceGroupId
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("��ʾ","���³ɹ�!")
			ClearData()
			LocSpecTabDataGridLoad()
		}else{
			$.messager.alert("��ʾ","����ʧ��!")
			return false
		}
	})
}
function CheckData(){
	var LocId=$("#Loc").combobox("getValue")
	var ClinicId=$("#Clinic").combobox("getValue")
	var ServiceGroupId=$("#ClinicService").combobox("getValue");
	if ((LocId=="")||(!LocId)){$.messager.alert("��ʾ","��ѡ�����!");return false}
	if ((ClinicId=="")||(!ClinicId)){$.messager.alert("��ʾ","��ѡ��רҵ��!");return false}
	if ((ServiceGroupId=="")||(!ServiceGroupId)){$.messager.alert("��ʾ","��ѡ�������!");return false}
	return true
}
function ClearData(){
	$("#Loc,#Clinic,#ClinicService").combobox("select","")
}