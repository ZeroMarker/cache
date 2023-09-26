var cureApplyAppDataGrid;
$(function(){
	InitCureApplyAppDataGrid();
	loadCureApplyAppDataGrid();
		
});

function InitCureApplyAppDataGrid()
{
	// Toolbar
	var cureApplyAppToolBar = [
	{
		id:'BtnDetailView',
		text:'添加治疗记录', 
		iconCls:'icon-add',  
		handler:function(){
					var OperateType=$('#OperateType').val();
					if (OperateType!="ZLYS")
	            	{
		           	 	$.messager.alert("错误", "只有治疗医生可以添加治疗记录", 'error')
		            	return false;
		        	}  
					var selected = cureApplyAppDataGrid.datagrid('getSelected');
					if (selected){
						if((typeof(selected.DCAAStatus) != "undefined")&&(selected.DCAAStatus=="取消预约")){
							$.messager.alert("提示","该预约记录已经取消,不允许添加治疗记录");	
							return false;
						}
						if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
							var Rowid=selected.Rowid;
							OpenCureRecordDiag(Rowid);
						}
					}else{
					$.messager.alert("提示","请选择一条预约记录");	
				}
		}
	}
	,'-',
	{
		id:'BtnDelete',
		text:'取消预约',
		iconCls:'icon-cut',
		handler:function(){
			    var OperateType=$('#OperateType').val();
	            if (OperateType=="ZLYS")
	            {
		            $.messager.alert("错误", "只有治疗前台和医生可以取消预约", 'error')
		            return false;
		        }  
				var selected = cureApplyAppDataGrid.datagrid('getSelected');
					if (selected){
						if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
							var Rowid=selected.Rowid;
							var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","AppCancel",Rowid,session['LOGON.USERID']);
							if (ret==0){
								cureApplyAppDataGrid.datagrid('load');
           						cureApplyAppDataGrid.datagrid('unselectAll');
           						$.messager.alert("提示","取消成功")
							}else{
								var mesage=""
								if(ret=="100")mesage="入参为空"
								else if(ret=="101")mesage="预约状态不是已预约的记录不能取消"
								else if(ret=="102")value="执行记录已经计费不能取消,如取消请让护士核实后撤销执行"
								else mesage=ret
								$.messager.alert('提示',"取消失败:"+mesage);
								return false
								
							}
						
							loadCureApplyAppDataGrid();
							if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
						}
					}else{
					$.messager.alert("提示","请选择一条预约记录");	
				}
		}
	}];
	// 治疗申请单预约记录Grid
	cureApplyAppDataGrid=$('#tabCureApplyApp').datagrid({  
		fit : true,
		width : 450,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"Rowid",
		pageList : [15,50,100,200],
		columns :[[     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'日期', width: 90, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 150, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 60, align: 'center', resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 100, align: 'center', resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 60, align: 'center',resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 60, align: 'center',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'center',resizable: true
					},
					{ field: 'DDCRSStatus', title: '排班状态', width: 30, align: 'center',resizable: true
					},
					{ field: 'DCAAStatus', title: '预约状态', width: 50, align: 'center',resizable: true
					},
					{ field: 'ReqUser', title: '预约操作人', width: 50, align: 'center',resizable: true
					},
					{ field: 'ReqDate', title: '预约操作时间', width: 80, align: 'center',resizable: true
					},
					{ field: 'LastUpdateUser', title: '更新人', width: 50, align: 'center',resizable: true
					},
					{ field: 'LastUpdateDate', title: '更新时间', width: 80, align: 'center',resizable: true
					}   
    			 ]] ,
    	toolbar : cureApplyAppToolBar
	});
}
function loadCureApplyAppDataGrid(DCARowId)
{
	var DCARowId=$('#DCARowId').val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.Appointment';
	queryParams.QueryName ='FindAppointmentList';
	queryParams.Arg1 =DCARowId;
	queryParams.Arg2 ="";
	queryParams.ArgCnt =2;
	var opts = cureApplyAppDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp";
	cureApplyAppDataGrid.datagrid('load', queryParams);
	cureApplyAppDataGrid.datagrid('unselectAll');
}
function OpenCureRecordDiag(DCAARowId)
{
	var OperateType=$('#OperateType').val();
	var href="dhcdoc.cure.curerecord.csp?OperateType="+OperateType+"&DCAARowId="+DCAARowId;
	var ReturnValue=window.showModalDialog(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
	/*
	var _content ="<iframe src='"+href+ "' scrolling='no' frameborder='0' style='width:100%;height:100%;'></iframe>"
	   $("#cureRecordDetailDiag").dialog({
        width: 800,
        height: 470,
        modal: true,
        content: _content,
        title: "治疗记录单",
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });
    */ 
}

