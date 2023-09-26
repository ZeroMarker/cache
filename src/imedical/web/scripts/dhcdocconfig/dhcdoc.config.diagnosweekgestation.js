var ItmDiagnoseDataGrid;
var editRow=undefined;
$(function(){
	InitHospList();
	InitComboWeekGestationDia();
	$("#BSave").click(function(){
		var WeekGestationDia=$('#Combo_WeekGestationDia').combogrid("options").value;
		var Data="WeekGestationDia"+String.fromCharCode(1)+WeekGestationDia;
		var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
		   	Coninfo:Data,
		   	HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
       	if(value=="0"){
	       	 $.messager.popover({msg: '保存成功!',type:'success'});
			 return false;
		}
	});
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_DiagnosWeekGestation");
	hospComp.jdata.options.onSelect = function(e,t){
		datadefault();
		InitWeekGestationDia();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		datadefault();
		InitWeekGestationDia();
	}
}
function InitWeekGestationDia(){
	var ItmDiagnoseBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                editRow = undefined;
                ItmDiagnoseDataGrid.datagrid("rejectChanges");
                ItmDiagnoseDataGrid.datagrid("unselectAll");

                if (editRow != undefined) {
                    ItmDiagnoseDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    ItmDiagnoseDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    ItmDiagnoseDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = ItmDiagnoseDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var rows=ItmDiagnoseDataGrid.datagrid("getSelected");  
                            var WeekNum=rows.WeekNum;
                            if (WeekNum==undefined){
	                            editRow = undefined;
				                ItmDiagnoseDataGrid.datagrid("rejectChanges");
				                ItmDiagnoseDataGrid.datagrid("unselectAll");
				                return false;
	                        }
	                        var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.ItmDiagnose",
								MethodName:"deleteWeekDiagnose",
							   	WeekNum:WeekNum,
							   	HospId:$HUI.combogrid('#_HospList').getValue()
							},false);
							if(value=="0"){
								ItmDiagnoseDataGrid.datagrid('load');
								ItmDiagnoseDataGrid.datagrid('unselectAll');
								$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
							}
						    editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
               if (editRow != undefined)
                {
                	var rows=ItmDiagnoseDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");  
					var editors = ItmDiagnoseDataGrid.datagrid('getEditors', editRow);  				
					var MRCIDRowId=rows.DiagnoseDR
					if ((MRCIDRowId=="")||(MRCIDRowId==undefined)){
						$.messager.alert("提示", "请选择诊断!", "error");
						return false;
					}
	                var WeekNum=editors[1].target.val();
	                if ($.isNumeric(WeekNum) == false) {
		                $.messager.alert("提示", "请填写对应的周数", "error");
						return false;
	                }
	                var RowData=ItmDiagnoseDataGrid.datagrid('getData'); 
	                var RepeatFlag=0;
	                for (var i=0;i<RowData.rows.length;i++) {
		            	if ((RowData.rows[i].WeekNum==WeekNum)){
			            	RepeatFlag=1;
			            }
		            }
	                if (RepeatFlag==1){
		            	$.messager.alert("提示", "存在相同的周数，不能保存", "error");
						return false;
		            }
	                var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.ItmDiagnose",
						MethodName:"saveWeekDiagnose",
					   	WeekNum:WeekNum,
					   	DiagnoseDr:MRCIDRowId,
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					if(value=="0"){
						ItmDiagnoseDataGrid.datagrid("endEdit", editRow);
						editRow = undefined;
						ItmDiagnoseDataGrid.datagrid('load');
						$.messager.popover({msg: '保存成功!',type:'success'});
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}
				    editRow = undefined;
			}
		  }  
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow = undefined;
                ItmDiagnoseDataGrid.datagrid("rejectChanges");
                ItmDiagnoseDataGrid.datagrid("unselectAll");
            }
        }];
    var ItmDiagnoseColumns=[[    
                    { field: 'DiagnoseDR', title: '诊断', width: 100, align: 'center', sortable: true, resizable: true,hidden:true
					 
					},
					{ field: 'MRCIDDesc', title: '诊断', width: 100, align: 'center', sortable: true,
					    editor:{
                         type:'combogrid',
                         options:{
                             required: true,
                             panelWidth:450,
							 panelHeight:350,
                             idField:'MRCIDRowId',
                             textField:'MRCIDDesc',
                            value:'',//缺省值 
                            mode:'remote',
							pagination : true,//是否分页   
							rownumbers:true,//序号   
							collapsible:false,//是否可折叠的   
							fit: true,//自动大小   
							pageSize: 10,//每页显示的记录条数，默认为10   
							pageList: [10],//可以设置每页记录条数的列表  
                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDiagnoseList",
                            columns:[[
                                 {field:'MRCIDDesc',title:'名称',width:350},
                                 {field:'MRCIDRowId',title:'ID',width:50}
                             ]],
							 onSelect : function(rowIndex, rowData) {
								 var rows=ItmDiagnoseDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
								 if(rows) rows.DiagnoseDR=rowData.MRCIDRowId
		                     },
		                     onBeforeLoad:function(param){
								if (param['q']) {
									var desc=param['q'];
								}else{
									//return false;
								}
								param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
							}
                        }
                       }
					},
					{ field: 'WeekNum', title: '周数', width: 100, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text'
					  }
					}				
    			 ]];
	ItmDiagnoseDataGrid=$("#tabWeekGestationDia").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItmDiagnose&QueryName=GetWeekDiagnose&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"WeekNum",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItmDiagnoseColumns,
    	toolbar :ItmDiagnoseBar,
    	onLoadSuccess:function(data){
	    	ItmDiagnoseDataGrid.datagrid("unselectAll");
	    }
	});
}
function datadefault(){
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		MethodName:"getDIADefaultData",
	   	value:"WeekGestationDia",
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	objScope=eval("(" + objScope + ")");
	$('#Combo_WeekGestationDia').combogrid('setValue',objScope.result.split("^")[1]);
	$('#Combo_WeekGestationDia').combogrid("options").value=objScope.result.split("^")[0];
}
function InitComboWeekGestationDia()
{
	$('#Combo_WeekGestationDia').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 200,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDiagnoseList&desc=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'MRCIDRowId',    
		textField: 'MRCIDDesc',    
		columns: [[    
			{field:'MRCIDDesc',title:'诊断名称',width:400,sortable:true},
			{field:'MRCIDRowId',title:'ID',width:120,sortable:true}
		]],
		keyHandler:{
			up: function () {
	         },
	         down: function () {
	        },
			left: function () {
				return false;
	        },
			right: function () {
				return false;
	        }, 
	              
			enter: function () { 
	        },
			query:function(q){
				//$('#Combo_WeekGestationDia').combogrid("grid").datagrid("reload",{'keyword':q});
				$('#Combo_WeekGestationDia').combogrid("setValue",q);
				LoadDiagnoseData();
            },
		},
        onSelect: function (){
			var selected = $('#Combo_WeekGestationDia').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_WeekGestationDia').combogrid("options").value=selected.MRCIDRowId;
			}
		}
	});
}
function LoadDiagnoseData(){
	var val = $('#Combo_WeekGestationDia').combogrid('getValue'); 
    var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindDiagnoseList';
	queryParams.desc =val;
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
	//queryParams.ArgCnt =1;
	var opts = $('#Combo_WeekGestationDia').combogrid("grid").datagrid("options");
	opts.url = $URL;
	$('#Combo_WeekGestationDia').combogrid("grid").datagrid('load', queryParams);
};