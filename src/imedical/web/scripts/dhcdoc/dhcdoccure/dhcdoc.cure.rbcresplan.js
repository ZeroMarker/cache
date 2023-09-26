var cureRBCResPlanDataGrid;
var cureWeekList;
var cureTimeDescList;
var cureServiceGroupList;
$(function(){ 
  $('#btnSave').bind('click', function(){
	  if(!SaveFormData())return false;
   });
   $('#btnFind').bind('click', function(){
	  LoadCureRBCResPlanDataGrid();
   });
   $('#btnGen').bind('click', function(){
	  CreateResApptSchulde();
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
	//星期列表
    cureWeekList=$('#Week').combobox({      
    	valueField:'WeekId',   
    	textField:'WeekName',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCResPlan';
						param.QueryName = 'QueryWeek'
						param.ArgCnt =0;
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
	InitCureRBCResPlan();
});	
function CheckData(){
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
	var Week=$('#Week').combobox('getValue');
	if(Week=="")
	{
		$.messager.alert('Warning','请选择星期');   
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
   		var LocId=$('#LocList').combobox('getValue');
   		var ResourceId=$('#ResourceList').combobox('getValue');   
	    var Week=$('#Week').combobox('getValue');
	    var TimeDesc=$('#TimeDesc').combobox('getValue');
	    var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	    var StartTime=$("#StartTime").val();
	    var EndTime=$("#EndTime").val();
	    var Max=$("#Max").val();
	    var AutoNumber=$("#AutoNumber").val();
	    var ChargTime=$("#ChargTime").val();
	    var InputPara=Rowid+"^"+LocId+"^"+ResourceId+"^"+Week+"^"+TimeDesc+"^"+ServiceGroup+"^"+StartTime+"^"+EndTime+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResPlan","SaveCureRBCResPlan","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			//LoadCureRBCResPlanDataGrid()
			return true;							
		}else{
			var errmsg="";
			if (value==100)errmsg=",必填数据不能为空或者不合法";
			else if (value==101)errmsg=",已经存在同时段的模板,不能重复添加";
			else errmsg=value;
			$.messager.alert("错误","保存失败"+errmsg)
			return false;
		}
	   },"","",InputPara);
}
///修改表格函数
function UpdateGridData(){
   var rows = cureRBCResPlanDataGrid.datagrid('getSelections');
    if (rows.length ==1) {
       //$("#add-dialog").dialog("open");
	 $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
        //清空表单数据
	 	$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocId)
		var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocId+"&ArgCnt=1";
		$('#ResourceList').combobox('clear');
		$('#ResourceList').combobox('reload',url);
		$('#ResourceList').combobox('setValue',rows[0].ResSourceDR)
		$('#Week').combobox('setValue',rows[0].TWeekNum)
		$('#TimeDesc').combobox('setValue',rows[0].TTimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].TSerivceGourpId)
		 $('#add-form').form("load",{
		 Rowid:rows[0].TRowid,
		 StartTime:rows[0].TStartTime,
		 EndTime:rows[0].TEndTime,
		 Max:rows[0].TMax,
		 AutoNumber:rows[0].TAutoNumber,
		 ChargTime:rows[0].TChargTime	 	 
	 })
      $('#btnSave').val("修改")    
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}
function InitCureRBCResPlan()
{
	var cureRBCResPlanToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
              //$("#add-dialog").dialog("open");
              $('#add-dialog').window('open').window('resize',{width:'250px',height:'450px',top: 100,left:400});
	 			//清空表单数据
	 		  $('#add-form').form("clear") 
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                var rows = cureRBCResPlanDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].TRowid);
                            }
                            var ID=ids.join(',')
                            //alert(ID);
							$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResPlan","DeleteCureRBCResPlan","false",function testget(value){
						        if(value=="0"){
							       cureRBCResPlanDataGrid.datagrid('load');
           					       cureRBCResPlanDataGrid.datagrid('unselectAll');
           					       $.messager.show({title:"提示",msg:"删除成功"});
						        }else{
							       $.messager.alert('提示',"删除失败:"+value);
						        }
						  
						   },"","",ID);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },'-',{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
			  UpdateGridData();
			}
		}];
	var cureRBCResPlanColumns=[[    
                    { field: 'TRowid', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LocDesc', title:'科室', width: 80, align: 'center', sortable: true,resizable: true  
					},
					{ field: 'LocId', title:'LocId', width: 10, align: 'center', sortable: true ,hidden:true 
					},
					{ field: 'ResSourceDR', title:'ResSourceDR', width: 100, align: 'center', sortable: true ,hidden:true  
					},
					{ field: 'ResourceDesc', title:'资源', width: 10, align: 'center', sortable: true ,resizable: true 
					}, 
					{ field: 'TWEEK', title:'星期', width: 10, align: 'center', sortable: true,resizable: true  
					},
        			{ field: 'TTimeDesc', title: '时段', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TServiceGroup', title: '服务组', width: 20, align: 'center', sortable: true, resizable: true
					},
					{ field: 'TStartTime', title: '开始时间', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TEndTime', title: '结束时间', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TMax', title: '最大预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TAutoNumber', title: '自动预约数', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TChargTime', title: '截止缴费时间', width: 20, align: 'center', sortable: true,resizable: true
					},
					{ field: 'TWeekNum', title: 'TWeekNum', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'TSerivceGourpId', title: 'TServiceGroupId', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'TTimePeriodCode', title: 'TTimePeriodCode', width: 1, align: 'center', sortable: true,hidden:true
					}
    			 ]];
	cureRBCResPlanDataGrid=$('#tabCureRBCResPlan').datagrid({  
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
		columns :cureRBCResPlanColumns,
		toolbar:cureRBCResPlanToolBar,
		onClickRow:function(rowIndex, rowData){
			TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 UpdateGridData();	
       }

	});
	LoadCureRBCResPlanDataGrid();
}
function LoadCureRBCResPlanDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResPlan';
	queryParams.QueryName ='QueryResourceWeekPlan';
	queryParams.Arg1 =$('#LocName').combobox('getValue');
	queryParams.Arg2 =$('#Resource').combobox('getValue');
	queryParams.ArgCnt =2;
	var opts = cureRBCResPlanDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	cureRBCResPlanDataGrid.datagrid('load', queryParams);
}
///生成资源排班
function CreateResApptSchulde()
{
	var LocId=$('#LocName').combobox('getValue');
	var StartDate=$('#StartDate').combobox('getValue');
	var EndDate=$('#EndDate').combobox('getValue');
	if(LocId=="")
	{
		 $.messager.alert("错误", "请选择科室", 'error')
        return false;
	}
	var Info=LocId+"^"+StartDate+"^"+EndDate;
	$.dhc.util.runServerMethod("DHCDoc.DHCDocCure.RBCResSchdule","CreateResApptSchulde","false",function testget(value){
	if(value=="0"){
           	$.messager.show({title:"提示",msg:"生成资源计划成功!"});
	}else{
		    var err=""
		    if(value=="1000") err="请检查排班模板数据是否存在问题"
			$.messager.alert('提示',"生成资源计划失败!"+err);
	}
						  
	},"","",Info,session['LOGON.USERID']);
}
