var cureRBCResSchduleDataGrid;
$(function(){
	$('#btnSearchApp').bind("click",function(){
		LoadCureRBCResSchduleDataGrid();	
	})
	
	$('#Apply_AppDate').datebox({"onSelect":function(date){
		LoadCureRBCResSchduleDataGrid()
	}})
	InitCureRBCResSchduleDataGrid();		
});


function InitCureRBCResSchduleDataGrid()
{  
	var cureRBCResSchduleToolBar = [{
            text: '预约',
            iconCls: 'icon-add',
            handler: function() {
	            var OperateType=$('#OperateType').val();
	            if (OperateType=="ZLYS")
	            {
		            $.messager.alert("错误", "只有治疗前台和医生可以做预约",'error')
		            return false;
		        }
	            var DCARowId=$('#DCARowId').val();
	            if(DCARowId=="")
	            {
		            $.messager.alert("错误", "请选择一个申请单", 'error')
        			return false;
		        }
                var rows = cureRBCResSchduleDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
                            var Para=DCARowId+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID'];
                            var value=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","AppInsert",Para)
                            if (value=="0"){
	                             	cureRBCResSchduleDataGrid.datagrid('load');
           					        cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					         $.messager.alert('提示',"预约成功");
           					       if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
                            }else{
	                              var err=value
							       if (value==100) err="有参数为空";
							       if (value==101) err="停诊的排班不能预约";
							       if (value==102) err="此排班已经过了预约时间,不能预约";
							       if (value==103) err="该申请单包含的项目数量已经约完";
							       if ((value==104)||(value==105)) err="插入执行记录错误";
							       if (value==106) err="此排班已预约完,不能再预约";
							       $.messager.alert('提示',"预约失败:"+err);
	                         }
                            /*
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.Appointment","AppInsert","false",function testget(value){
						        if(value=="0"){
							       cureRBCResSchduleDataGrid.datagrid('load');
           					       cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"预约成功"});
           					       if((parent)&&(typeof(parent.loadCureApplyDataGrid()) == "function")) parent.loadCureApplyDataGrid();
						        }else{
							       var err=value
							       if (value==100) err="有参数为空";
							       if (value==101) err="停诊的排班不能预约";
							       if (value==102) err="此排班已经过了预约时间,不能预约";
							       if (value==103) err="该申请单包含的项目数量已经约完";
							       if ((value==104)||(value==105)) err="插入执行记录错误";
							       if (value==106) err="此排班已预约完,不能再预约";
							       $.messager.alert('提示',"预约失败:"+err);
						        }
						  
						   },"","",Para);
						   */
                } else {
                    $.messager.alert("提示", "请选择要预约的资源", "error");
                }
            }
        }];
	var cureRBCResSchduleColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'日期', width: 25, align: 'center', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 60, align: 'center', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 40, align: 'center', sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 30, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 50, align: 'center', sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '状态', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AppedNumber', title: '已预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '最大预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '自动预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ChargeTime', title: '截止缴费时间', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AvailPatType', title: '可用类型', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 20, align: 'center', sortable: true
					}
    			 ]];
	cureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		width :450,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : false,  //
		idField:"Rowid",
		pageList : [15,50,100,200],
		columns :cureRBCResSchduleColumns,
		toolbar:cureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			Rowid=rowData.Rowid
		}
	});
	//LoadCureRBCResSchduleDataGrid("");
}
function LoadCureRBCResSchduleDataGrid()
{
	var DCARowId=$('#DCARowId').val();
	var AppDate=$('#Apply_AppDate').datebox('getValue');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
	queryParams.QueryName ='QueryAvailResApptSchdule';
	queryParams.Arg1 =DCARowId;
	queryParams.Arg2 =AppDate;
	queryParams.ArgCnt =2;
	var opts = cureRBCResSchduleDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResSchduleDataGrid.datagrid('load', queryParams);
}