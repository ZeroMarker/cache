function InitApplyResListEvent(){
	$('#btnSearchApp').bind("click",function(){
		CureRBCResSchduleDataGridLoad();	
	})
	$('#btnApp').bind("click",function(){
		BtnAppClick();	
	})
}

function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
	var EndDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		'a':"7",
		dataType:"text"   
	},false);
    $("#Apply_StartDate").datebox('setValue',CurDay);	
    $("#Apply_EndDate").datebox('setValue',EndDay);		
}

function InitCureRBCResSchduleDataGrid()
{  
	var cureRBCResSchduleColumns=[[    
                    { field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'日期', width: 30, align: 'left', sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 60, align: 'left', sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 20, align: 'left', sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 40, align: 'left', sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 30, align: 'left', sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 30, align: 'left', sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 50, align: 'left', sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '状态', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 30, align: 'left', sortable: true,resizable: true,
						styler: function(value,row,index){
							value=parseFloat(value)
							row.MaxNumber=parseFloat(row.MaxNumber)
							if (value ==0){
								return 'background:red;';
							}else if((value >0)&&(value<row.MaxNumber)){
								return 'background:#ffee00;';
							}else{
								return 'background:green;';
							}
						}
					},
					{ field: 'AppedNumber', title: '已预约数', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '最大预约数', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '自动预约数', width: 20, align: 'left', sortable: true,resizable: true, hidden: true
					},
					{ field: 'ChargeTime', title: '截止缴费时间', width: 20, align: 'left', sortable: true,resizable: true
					},
					{ field: 'AvailPatType', title: '可用类型', width: 20, align: 'left', hidden: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 20, align: 'left', hidden: true
					}
    			 ]];
	CureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		//width : 500,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:10,
		pageList : [10,50,100,200],
		columns :cureRBCResSchduleColumns,
		rowStyler:function(rowIndex, rowData){
 			if (rowData.DDCRSStatus!="正常"){
	 			return 'color:#788080;';
	 		}
		},
		
	});
	CureRBCResSchduleDataGridLoad();
}
function CureRBCResSchduleDataGridLoad()
{
	var DCARowId="" //$('#DCARowId').val();
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID //$('#DCARowIdStr').val();
	//var AppDate=$('#Apply_AppDate').datebox('getValue');
	var AppStartDate=$('#Apply_StartDate').datebox('getValue');
	var AppEndDate=$('#Apply_EndDate').datebox('getValue');
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		QueryName:"QueryAvailResApptSchdule",
		'DCARowId':DCARowIdStr,
		'BookDate':"",
		'DCARowIdStr':DCARowIdStr,
		'StartDate':AppStartDate,
		'EndDate':AppEndDate,
		Pagerows:CureRBCResSchduleDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResSchduleDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function BtnAppClick(){
	var OperateType=$('#OperateType').val();
    if (OperateType=="ZLYS")
    {
        $.messager.alert("提示", "只有治疗前台和医生可以做预约", 'error')
        return false;
    }  
    var DCARowId=$('#DCARowId').val();
	var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID //$('#DCARowIdStr').val();
    if(DCARowIdStr=="")
    {
        $.messager.alert("提示", "请选择一个申请单", 'error')
		return false;
    }
    var rows = CureRBCResSchduleDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].Rowid);
		}
		var ID=ids.join(',')
		var DCARowIdArr=DCARowIdStr.split("!");
		var err="";
		for(var j=0;j<DCARowIdArr.length;j++){	
			var oneDCARowId=DCARowIdArr[j];		
			var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
			var PatName="";
			var ArcimDesc="";
			if(CurePatInfo!=""){
				var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
				var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
				var PatName=CurePatInfo.split("^")[2];
				var ArcimDesc=CureInfo.split("^")[0];
			}
			/*var ApplyNoAppTimes=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetApplyNoAppTimes",oneDCARowId);
			if(ApplyNoAppTimes==1){
				var myerr="'"+PatName+" "+ArcimDesc+"'"+",本次治疗为最后一次可预约";
				$.messager.alert('提示',myerr);
			}
			*/
			var Para=oneDCARowId+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID'];
			//多人预约，需要进行同步处理
			var ObjScope=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Appointment",
				MethodName:"AppInsertHUI",
				'Para':Para,
				'JSONType':"JSON",
			},false);
			var value=ObjScope.result;
			if(value=="0"){
				//var obj=window.frames.parent
			}else{
				var err=value
				if (value==100) err="有参数为空";
				else if(value==101) err="停诊的排班不能预约";
				else if(value==1001) err="已撤销的申请不能预约";
				else if(value==102) err="此排班已经过了预约时间,不能预约"; //当前操作预约时间>资源开始时间
				else if(value==103) err="该申请单包含的项目数量已经约完"; //医嘱数量-已经预约的数量=0则不可再预约
				else if(value==1031) err="该申请单可预约数量不足";
				else if((value==104)||(value==105)) err="插入执行记录错误";
				else if(value==106) err="此排班已预约完,不能再预约";
				else if(value==107) err="该申请存在有效的预约未治疗的记录,不能重复预约";
				else if(value==108) err="该申请医嘱未缴费,无法进行预约";
				else if(value==109) err="该申请医嘱为长期,无法进行预约,请直接执行";
				else if(value=="202") err="该申请为直接执行治疗医嘱,不可预约";
				else if(value=="203") err="该申请医嘱已停止,不可预约";
				err="'"+PatName+" "+ArcimDesc+"'"+"预约失败,失败原因:"+err;
				$.messager.alert('提示',"预约失败:"+err);
			}
		}
		//CureRBCResSchduleDataGrid.datagrid('load');
		CureRBCResSchduleDataGridLoad();
		CureRBCResSchduleDataGrid.datagrid('unselectAll');
		if(err==""){$.messager.show({title:"提示",msg:"预约成功"});}
		if(window.frames.parent.CureApplyDataGrid){
			window.frames.parent.RefreshDataGrid();
		}else{
			RefreshDataGrid();	
		}
    } else {
        $.messager.alert("提示", "请选择要预约的资源", "error");
    }
}