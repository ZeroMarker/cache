/// dhclab.rejectlists.js
///ҳ�����
var HospID=session['LOGON.HOSPID']; 
var UserID = session['LOGON.USERID'];

$(function() {
    pageInit();
});

function pageInit() {
    ShowRejectSpecList();
}   ///pageInit


//��ʾΣ������
function ShowRejectSpecList() {
    $('#dgRejectSpec').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCRejectSpecimen",
			QueryName:"QryRejectSpec",
			FunModul:"JSON",
			P0:EpisodeID, 
			P1:"0",   ///ֻ��ѯδ�����
			P2:"",
			P3:"",   
			P4:"",  
			P5:"", 
			P6:"",  
			P7:"", 
			P8:""
		},		
		rownumbers: true,
		pagination: false,
		//pageSize: 20,
		//pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          //{ field: 'Operate', title: '����', width: 30, sortable: true, align: 'center',formatter: OptIconPrompt },
          { field: 'RegNo', title: '�ǼǺ�', width: 80, sortable: true, align: 'left' },
          { field: 'SurName', title: '��������', width: 60, sortable: true, align: 'center' },
          { field: 'Labno', title: '�����', width: 80, sortable: true, align: 'left' },
          { field: 'TestSetDesc', title: 'ҽ������', width: 180, sortable: true, align: 'left' },
          { field: 'SpecimenDesc', title: '�걾', width: 80, sortable: true, align: 'left' },
          { field: 'RejectNotes', title: '�ܾ�ԭ��', width: 150, sortable: true, align: 'left' },
          { field: 'CreateUser', title: '�ܾ��û�', width: 60, sortable: true, align: 'center' },
          { field: 'CreateDate', title: '�ܾ�����', width: 80, sortable: true, align: 'center' },
          { field: 'CreateTime', title: '�ܾ�ʱ��', width: 80, sortable: true, align: 'center' }
        ]]
    });
}; //ShowOrdItmListsGrid

//���ͼ����ʾ
function OptIconPrompt(value, rowData, rowIndex) {
	return "<a style='text-decoration:none;color:red;' href='javascript:void(OperateReject(" + rowData.RejectDR + "))';><span class='icon-edit' title='���մ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
}

///���ձ걾����
var OperateReject = function(){
	var OperateNotes = $('#txt_Notes').val();
	if(OperateNotes==''){
		$.messager.alert("������ʾ", "���ձ걾����˵������Ϊ�գ�", "info", function () {
			$('#txt_Notes').focus();
			return;
		});	
	} else {
	    var curRows = $('#dgRejectSpec').datagrid('getRows');
	    if (curRows) {
	        for (var i = 0; i < curRows.length; i++) {
		        var RejectDR=curRows[i].RejectDR;
					$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCRejectSpecimen",MethodName:"SaveOperate",RejectDR:RejectDR,UserID:UserID,OperateNotes:OperateNotes,HospID:HospID},
					   function(rtn){
						   if (rtn == "1") {
							   $.messager.show({
									title:'��ʾ��Ϣ',
									msg:'���ձ걾����ɹ�!',
									timeout:5000,
									showType:'slide'
								});
								$('#dgRejectSpec').datagrid("reload");
								window.parent.findRejectList();
						   }
						}
					);
		    }
	    }
	}
}