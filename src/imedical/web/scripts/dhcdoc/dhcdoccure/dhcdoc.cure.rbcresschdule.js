var cureRBCResSchduleDataGrid;
var cureResourceList;
var cureTimeDescList;
var cureServiceGroupList;
$(function(){ 
	$('#btnSave').bind('click', function(){
	  if(!SaveFormData())return false;
   });
   $('#btnFind').bind('click', function(){
	  LoadCureRBCResSchduleDataGrid();
   });  
   //资源列表
    cureResourceList=$('#Resource').combobox({      
    	valueField:'TRowid',   
    	textField:'TResDesc'   
	});
  //科室列表
    $('#LocName').combobox({      
    	valueField:'LocId',   
    	textField:'LocDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'QueryCureLoc'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var locId=record.LocId;
			var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+locId+"&ArgCnt=1";
			cureResourceList.combobox('clear');
			cureResourceList.combobox('reload',url);		
		}  
	});
	//资源列表
    $('#ResourceList').combobox({      
    	valueField:'TRowid',   
    	textField:'TResDesc'   
	});
  //科室列表
    $('#LocList').combobox({      
    	valueField:'LocId',   
    	textField:'LocDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.Config';
						param.QueryName = 'QueryCureLoc'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var locId=record.LocId;
			var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+locId+"&ArgCnt=1";
			$('#ResourceList').combobox('clear');
			$('#ResourceList').combobox('reload',url);		
		}  
	});
	//时段列表
    cureTimeDescList=$('#TimeDesc').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCResPlan';
						param.QueryName = 'QueryBookTime'
						param.ArgCnt =0;
		},
		onSelect:function(record){
			var Rowid=record.Rowid;
			//alert(Rowid);
			var ret=tkMakeServerCall("DHCDoc.DHCDocCure.RBCTimePeriodSet","GetCureRBCTimePeriodSetById",Rowid)		
			if (ret!="")
			{
				var TempArr=ret.split("^");
				$("#StartTime").val(TempArr[2]);
				$("#EndTime").val(TempArr[3]);
				$("#ChargTime").val(TempArr[4]);
			}
		} 
	});
	//服务组列表
    cureServiceGroupList=$('#ServiceGroup').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCServiceGroupSet';
						param.QueryName = 'QueryServiceGroup'
						param.ArgCnt =0;
		}
	});
	InitCureRBCResSchdule();
});	
function InitCureRBCResSchdule()
{
	var cureRBCResSchduleToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
                //$("#add-dialog").dialog("open");
                $('#LocList').combobox("enable")
	 			$('#ResourceList').combobox("enable")
	 			$('#TimeDesc').combobox("enable") 
	 			$('#Date').datebox("enable") 
                $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
	 			//清空表单数据
	 		  $('#add-form').form("clear")  
            }
        },'-',{
            text: '停诊/撤销停诊',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCResSchduleDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要停诊/撤销停诊吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Rowid);
                            }
                            var ID=ids.join(',')
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","StopOneRBCSchedule","false",function testget(value){
						        if(value=="0"){
							       cureRBCResSchduleDataGrid.datagrid('load');
           					       cureRBCResSchduleDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"执行成功"});
						        }else if(value=="101"){
							        $.messager.alert('提示',"执行失败:"+"存在有效的相同记录,无法撤销停诊");
							    }else{
							       $.messager.alert('提示',"执行失败:"+value);
						        }
						  
						   },"","",ID,session['LOGON.USERID']);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要停诊的行", "error");
                }
            }
        },'-',{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
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
					{ field: 'MaxNumber', title: '最大预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoNumber', title: '自动预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'ChargeTime', title: '截止缴费时间', width: 20, align: 'center', sortable: true,resizable: true
					}
					/*,
					{ field: 'AvailPatType', title: '可用类型', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 20, align: 'center', sortable: true
					}*/,
					{ field: 'LocDr', title: 'LocDr', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'ResourceDr', title: 'ResourceDr', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'TimePeriodCode', title: 'TimePeriodCode', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'ServiceGroupDr', title: 'ServiceGroupDr', width: 1, align: 'center', sortable: true,hidden:true
					}
    			 ]];
	cureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"TRowid",
		pageList : [15,50,100,200],
		columns :cureRBCResSchduleColumns,
		toolbar:cureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();	
       }
	});
	LoadCureRBCResSchduleDataGrid();
}
function LoadCureRBCResSchduleDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
	queryParams.QueryName ='QueryResApptSchdule';
	queryParams.Arg1 =$('#LocName').combobox('getValue');
	queryParams.Arg2 =$('#Resource').combobox('getValue');
	queryParams.Arg3 =$('#BookDate').datebox('getValue');
	queryParams.ArgCnt =3;
	var opts = cureRBCResSchduleDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResSchduleDataGrid.datagrid('load', queryParams);
}
function CheckData(){
	var Date=$('#Date').datebox('getValue');
	if(Date=="")
	{
		$.messager.alert('Warning','请选择日期');   
        return false;
	}
	var LocId=$('#LocList').combobox('getValue');
	if(LocId=="")
	{
		 $.messager.alert("错误", "请选择科室", 'error')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	if(ResourceId=="")
	{
		 $.messager.alert("错误", "请选择资源", 'error')
        return false;
	}
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	if(TimeDesc=="")
	{
		$.messager.alert('Warning','请选择时段');   
        return false;
	}
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	if(ServiceGroup=="")
	{
		$.messager.alert('Warning','请选择服务组');   
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('Warning','请填写开始时间');   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('Warning','请填写结束时间');   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('Warning','请填写最大预约数');   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
   		if(!CheckData()) return false;
   		var Rowid=$("#Rowid").val();
   		var Date=$('#Date').datebox('getValue');
   		var LocId=$('#LocList').combobox('getValue');
   		var ResourceId=$('#ResourceList').combobox('getValue');   
	    var TimeDesc=$('#TimeDesc').combobox('getValue');
	    var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	    var StartTime=$("#StartTime").val();
	    var EndTime=$("#EndTime").val();
	    var Max=$("#Max").val();
	    var AutoNumber=$("#AutoNumber").val();
	    var ChargTime=$("#ChargTime").val();
	    if (Rowid=="")
	    {
	    var InputPara=Date+"^"+LocId+"^"+ResourceId+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		//alert(InputPara);
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","InsertOneRBCSchedule","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCResSchduleDataGrid()
			return true;							
		}else{
			var err=value
			if ((value==101)) err="该资源同一时段已经排过班次";
             $.messager.alert('提示',"保存失败:"+err);
			return false;
		}
	   },"","",InputPara,session['LOGON.USERID']);
	    }else{
		var InputPara=Rowid+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","UpdateOneRBCSchedule","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			LoadCureRBCResSchduleDataGrid()
			return true;							
		}else{
			if ((value==104)||(value==105)) err="插入执行记录错误";
            $.messager.alert('提示',"保存失败:"+err);
			return false;
		}
	   },"","",InputPara,session['LOGON.USERID']);	
		}
}
///修改表格函数
function UpdateGridData(){
   var rows = cureRBCResSchduleDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
	 	$('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //清空表单数据
	 	$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocDr)
		var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocDr+"&ArgCnt=1";
		$('#ResourceList').combobox('clear');
		$('#ResourceList').combobox('reload',url);
		$('#ResourceList').combobox('setValue',rows[0].ResourceDr)
		$('#TimeDesc').combobox('setValue',rows[0].TimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].ServiceGroupDr)
		 $('#add-form').form("load",{
		 Rowid:rows[0].Rowid,
		 Date:rows[0].DDCRSDate,
		 StartTime:rows[0].StartTime,
		 EndTime:rows[0].EndTime,
		 Max:rows[0].MaxNumber,
		 AutoNumber:rows[0].AutoNumber,
		 ChargTime:rows[0].ChargTime	 	 
	 })
	 $('#LocList').combobox("disable")
	 $('#ResourceList').combobox("disable")
	 $('#TimeDesc').combobox("disable") 
	 $('#Date').datebox("disable")    
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
