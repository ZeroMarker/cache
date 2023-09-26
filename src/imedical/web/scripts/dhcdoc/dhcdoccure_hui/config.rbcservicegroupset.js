var PageLogicObj={
	CureRBCServiceGroupSetDataGrid:"",
	m_ReHospitalDataGrid:""
}
$(document).ready(function(){ 
	PageLogicObj.CureRBCServiceGroupSetDataGrid=Init();
	InitEvent();
	InitHospUser();
	//CureRBCServiceGroupSetDataGridLoad();
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		CureRBCServiceGroupSetDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		CureRBCServiceGroupSetDataGridLoad();
	}	
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
}
function CheckData(){
	var DDCSGSCode=$("#DDCSGSCode").val();
	if(DDCSGSCode=="")
	{
		 $.messager.alert("����", "���벻��Ϊ��", 'error')
        return false;
	}
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	if(DDCSGSDesc=="")
	{
		$.messager.alert('Warning','��������Ϊ��');   
        return false;
	}
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	if(DDCSGSDateFrom=="")
	{
		$.messager.alert('Warning','��ʼ���ڲ���Ϊ��');   
        return false;
	}
	return true;
}
///�޸ı����
function SaveFormData(){
	if(!CheckData()) return false;    
	var DDCSGSROWID=$("#DDCSGSROWID").val();
	var DDCSGSCode=$("#DDCSGSCode").val();
	var DDCSGSDesc=$("#DDCSGSDesc").val();
	var DDCSGSDateFrom=$("#DDCSGSDateFrom").datebox("getValue");
	var DDCSGSDateTo=$("#DDCSGSDateTo").datebox("getValue");
	var InputPara=DDCSGSROWID+"^"+DDCSGSCode+"^"+DDCSGSDesc+"^"+DDCSGSDateFrom+"^"+DDCSGSDateTo;
	//alert(InputPara)
	var UserHospID=GetUserHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		MethodName:"SaveCureRBCServiceGroupSet",
		'str':InputPara,
		'hisui':"1",
		HospID:UserHospID
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			CureRBCServiceGroupSetDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�����ظ�";
			else if (value=="201") err="��ֹ���ڲ���С�ڿ�ʼ����";
			else err=value;
			$.messager.alert('��ʾ',err);   
			return false;
		}
	});
}
///�޸ı����
function UpdateGridData(){
   var rows = PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCServiceGroupSetDataGrid.getSelections();
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
        $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //��ձ�����
	 	$('#add-form').form("clear")
	 	
		 $('#add-form').form("load",{
		 DDCSGSROWID:rows[0].Rowid,
		 DDCSGSCode:rows[0].Code,
		 DDCSGSDesc:rows[0].Desc,
		 DDCSGSDateFrom:rows[0].DateFrom,
		 DDCSGSDateTo:rows[0].DateTo	 
	 })
	 
      $('#updateym').val("�޸�")    
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}
function Init()
{
	var cureRBCServiceGroupSetToolBar = [
        {
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
              $("#add-dialog").dialog("open");
	 			//��ձ�����
	 		  $('#add-form').form("clear")
	 		  $('#submitdata').val("���")  
            }
        }/*,
        {
            text: 'ɾ��',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("getSelections"); //PageLogicObj.CureRBCServiceGroupSetDataGrid.getSelections();
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
                            $.m({
								ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
								MethodName:"DeleteCureRBCServiceGroupSet",
								'Rowid':ID
							},function(value){
								if(value=="0"){
							       //CureRBCServiceGroupSetDataGrid.load();
							       CureRBCServiceGroupSetDataGridLoad();
           					       PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("unselectAll");
           					       $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
						        }else{
							       $.messager.alert('��ʾ',"ɾ��ʧ��:"+value);
						        }
							})	
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        }*/,{
			text: '�޸�',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},{
			text: '����ҽԺ',
			iconCls: 'icon-house',
			handler: function() {
				ReHospitalHandle();
			}
		}];
	cureRBCServiceGroupSetColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Code', title:'����', width: 260, sortable: true  
					},
        			{ field: 'Desc', title: '����', width: 300, sortable: true
					},
					{ field: 'DateFrom', title: '��ʼ����', width: 260, sortable: true, resizable: true
					},
					{ field: 'DateTo', title: '��ֹ����', width: 260, sortable: true,resizable: true
					}
    			 ]];
	var CureRBCServiceGroupSetDataGrid=$("#tabCureRBCServiceGroupSet").datagrid({ //$HUI.datagrid('#tabCureRBCServiceGroupSet',{  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"Rowid",
		pageSize: 15,
		pageList : [15,50,100],
		columns :cureRBCServiceGroupSetColumns,
		toolbar:cureRBCServiceGroupSetToolBar,
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       }
	});
	return CureRBCServiceGroupSetDataGrid;
}

function CureRBCServiceGroupSetDataGridLoad()
{
	var UserHospID=GetUserHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCServiceGroupSet",
		QueryName:"QueryServiceGroup",
		'config':1,
		HospID:UserHospID,
		Pagerows:PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
	})

};
function GetUserHospID(){
	var UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	return UserHospID
}

function ReHospitalHandle(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var GenHospObj=GenHospWin("DHC_DocCureRBCServiceGroupSet",row["Rowid"])
	return;
	//���û���ƽ̨���
	$("#ReHospital-dialog").dialog("open");
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
	LoadReHospitalDataGrid();
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
		toolbar:toobar
	}); 
	return ReHospitalDataGrid;
}
function LoadReHospitalDataGrid(){
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.q({
	    ClassName : "web.DHCOPRegConfig",
	    QueryName : "FindHopital",
	    BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
	    BDPMPHDataReference:ID,
	    Pagerows:PageLogicObj.m_ReHospitalDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReHospitalDataGrid.datagrid("unselectAll");
		PageLogicObj.m_ReHospitalDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function ReHospitaladdClickHandle(){
	var HospID=$("#Hosp").combobox("getValue")
	if (HospID==""){
		$.messager.alert("��ʾ","��ѡ��ҽԺ","info");
		return false;
	}
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"SaveHOSP",
		BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
		BDPMPHDataReference:ID,
		BDPMPHHospital:HospID,
		dataType:"text",
	},function(data){
		if (data=="1"){
			$.messager.alert("��ʾ","�����ظ�","info");
		}else{
			$.messager.popover({msg: data.split("^")[1],type:'success',timeout: 1000});
			LoadReHospitalDataGrid();
		}
	})
}
function ReHospitaldelectClickHandle(){
	var SelectedRow = PageLogicObj.m_ReHospitalDataGrid.datagrid('getSelected');
	if (!SelectedRow){
		$.messager.alert("��ʾ","��ѡ��һ��","info");
		return false;
	}
	var row=PageLogicObj.CureRBCServiceGroupSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ��һ�У�")
		return false
	}
	var ID=row["Rowid"]
	$.cm({
		ClassName:"web.DHCBL.BDP.BDPMappingHOSP",
		MethodName:"DeleteHospital",
		BDPMPHTableName:"DHC_DocCureRBCServiceGroupSet",
		BDPMPHDataReference:ID,
		BDPMPHHospital:SelectedRow.HospID,
		dataType:"text",
	},function(data){
		$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 1000});
		LoadReHospitalDataGrid();
	})
	
}