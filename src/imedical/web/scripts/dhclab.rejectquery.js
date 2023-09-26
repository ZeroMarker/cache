/// dhclab.rejectquery.js
///ҳ�����
var HospID=session['LOGON.HOSPID']; 
var UserID = session['LOGON.USERID'];

$(function() {
    pageInit();
});

function pageInit() {
 	var thisDate = GetCurentDate();
	$('#dt_FindSttDate').datebox('setValue',thisDate);
	$('#dt_FindEndDate').datebox('setValue',thisDate);
	//����
	$('#cmb_Ward').combogrid({
	    panelWidth:210,    
	    idField:'RowID',    
	    textField:'CName', 
    	url:'jquery.easyui.dhclabclassjson.csp',    
	    queryParams: {
			ClassName:"DHCLIS.DHCBTQuery",
			QueryName:"QueryWard",
			FunModul:"JSON",
			P0:"",
			P1:HospitalDR
		},	   
        columns:[[    
        	{field:'RowID',title:'����ID',width:10},
        	{field:'CName',title:'��������',width:190} 
    	]],
        onLoadSuccess: function (data) {
            $('#cmb_Ward').combogrid("setValue",WardDR);
    		findRejectList();
        }
    });  
    	
	$('#txt_RegNo').bind('keypress',function(event){
        if (event.keyCode == "13")    
        {
	        var RegNo = $('#txt_RegNo').val();
	        var iLen=RegNo.length
	        if (iLen>0)
	        {
				for (var i = iLen; i < 10; i++) {
					RegNo ="0" + RegNo;
				}
     			$('#txt_RegNo').val(RegNo);
            	findRejectList();
	        }
        }
    });
   	
    	
}   ///pageInit


//��ʾΣ������
function findRejectList() {
	var IsFinish = 0;
	if (document.getElementById("ckIsFinish").checked) {
		IsFinish = 1;
	}	
	var SttDate="";	
	var EndDate="";
	SttDate = $('#dt_FindSttDate').datebox('getValue');
    EndDate = $('#dt_FindEndDate').datebox('getValue');
    var WardDR = $("#cmb_Ward").combobox('getValue');
	var RegNo = $('#txt_RegNo').val();
    $('#dgRejectSpec').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCRejectSpecimen",
			QueryName:"QryRejectSpec",
			FunModul:"JSON",
			P0:EpisodeID, 
			P1:IsFinish,   
			P2:SttDate,
			P3:EndDate,   
			P4:WardDR,  
			P5:RegNo, 
			P6:LocationDR,  
			P7:"", 
			P8:""
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
		fit:true, 
        columns: [[
          { field: 'Operate', title: '����', width: 30, sortable: true, align: 'center',formatter: OptIconPrompt },
          { field: 'RegNo', title: '�ǼǺ�', width: 80, sortable: true, align: 'left' },
          { field: 'SurName', title: '��������', width: 60, sortable: true, align: 'center' },
          { field: 'Ward', title: '����', width: 100, sortable: true, align: 'left' },
          { field: 'Labno', title: '�����', width: 80, sortable: true, align: 'left' },
          { field: 'TestSetDesc', title: 'ҽ������', width: 180, sortable: true, align: 'left' },
          { field: 'SpecimenDesc', title: '�걾', width: 80, sortable: true, align: 'left' },
          { field: 'RejectNotes', title: '�ܾ�ԭ��', width: 150, sortable: true, align: 'left' },
          { field: 'CreateUser', title: '�ܾ��û�', width: 60, sortable: true, align: 'center' },
          { field: 'CreateDate', title: '�ܾ�����', width: 80, sortable: true, align: 'center' },
          { field: 'CreateTime', title: '�ܾ�ʱ��', width: 80, sortable: true, align: 'center' },
          { field: 'OperateNotes', title: '����ԭ��', width: 150, sortable: true, align: 'left' },
          { field: 'OperateUser', title: '�����û�', width: 60, sortable: true, align: 'center' },
          { field: 'OperateDate', title: '��������', width: 80, sortable: true, align: 'center' },
          { field: 'OperateTime', title: '����ʱ��', width: 80, sortable: true, align: 'center' }
        ]]
    });
}; //ShowOrdItmListsGrid

//���ͼ����ʾ
function OptIconPrompt(value, rowData, rowIndex) {
	if (rowData.IsFinish!="1") {
		//return "<a style='text-decoration:none;color:red;' href='javascript:void(OperateReject(" + rowData.RejectDR + "))';><span class='icon-edit' title='���մ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
		return "<a style='text-decoration:none;color:red;'  onclick='ShowReportTrace(\""+rowData.AdmNo+"\")';><span class='icon-edit' title='���մ���')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
	}
}

///�򿪴�������б�
function ShowReportTrace(EpisodeID) {
	if(EpisodeID==''&&EpisodeID==null) return;
	var width = document.body.clientWidth - 200;
	var height = 350;
	$("#win_ReportReject").window({
		modal:true,
		title:'���մ���',
		//closable:false,
		collapsible:false,
		iconCls:'icon-message',
		width:width,
		height:height,
		content:'<iframe src="jquery.easyui.dhclabreject.csp?EpisodeID='+EpisodeID+'" scrolling="no" frameborder="0" style="width:100%;height:100%;"></iframe>'
		//top: xy.top+20,
		//left: xy.left-width+100
	});
	return false;
}

///���ձ걾����
var OperateReject = function(){
	var OperateNotes = $('#txt_Notes').val();
	if(OperateNotes==''){
		$.messager.alert("������ʾ", "���ձ걾����˵������Ϊ�գ�", "info", function () {
			$('#txt_Notes').focus();
			return;
		});	
	}
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
					   }
					}
				);
	    }
    }
}

//��ȡ��ǰʱ��
function GetCurentDate() {
    var now = new Date();

    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    var day = now.getDate();            //��

    var hh = now.getHours();            //ʱ
    var mm = now.getMinutes();          //��

    var clock = year + "-";

    if (month < 10)
        clock += "0";

    clock += month + "-";

    if (day < 10)
        clock += "0";

    clock += day;

    return (clock);
}