/// dhclab.rejectlists.js
///页面加载
var HospID=session['LOGON.HOSPID']; 
var UserID = session['LOGON.USERID'];

$(function() {
    pageInit();
});

function pageInit() {
    ShowRejectSpecList();
}   ///pageInit


//显示危急报告
function ShowRejectSpecList() {
    $('#dgRejectSpec').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCRejectSpecimen",
			QueryName:"QryRejectSpec",
			FunModul:"JSON",
			P0:EpisodeID, 
			P1:"0",   ///只查询未处理的
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
          //{ field: 'Operate', title: '处理', width: 30, sortable: true, align: 'center',formatter: OptIconPrompt },
          { field: 'RegNo', title: '登记号', width: 80, sortable: true, align: 'left' },
          { field: 'SurName', title: '病人姓名', width: 60, sortable: true, align: 'center' },
          { field: 'Labno', title: '检验号', width: 80, sortable: true, align: 'left' },
          { field: 'TestSetDesc', title: '医嘱名称', width: 180, sortable: true, align: 'left' },
          { field: 'SpecimenDesc', title: '标本', width: 80, sortable: true, align: 'left' },
          { field: 'RejectNotes', title: '拒绝原因', width: 150, sortable: true, align: 'left' },
          { field: 'CreateUser', title: '拒绝用户', width: 60, sortable: true, align: 'center' },
          { field: 'CreateDate', title: '拒绝日期', width: 80, sortable: true, align: 'center' },
          { field: 'CreateTime', title: '拒绝时间', width: 80, sortable: true, align: 'center' }
        ]]
    });
}; //ShowOrdItmListsGrid

//结果图标显示
function OptIconPrompt(value, rowData, rowIndex) {
	return "<a style='text-decoration:none;color:red;' href='javascript:void(OperateReject(" + rowData.RejectDR + "))';><span class='icon-edit' title='拒收处理')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>";
}

///拒收标本处理
var OperateReject = function(){
	var OperateNotes = $('#txt_Notes').val();
	if(OperateNotes==''){
		$.messager.alert("操作提示", "拒收标本处理说明不能为空！", "info", function () {
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
									title:'提示消息',
									msg:'拒收标本处理成功!',
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