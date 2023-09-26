var ItmDiagnoseDataGrid;
var editRow=undefined;
$(function(){
	InitHospList();
	InitCombo();
	$("#BFind").click(function(){
	    ItmDiagnoseDataGrid.datagrid('reload');
     });
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_ItmDiagnose");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Combo_PatientType").combobox('setValue',"");
		$("#Combo_Item,#Combo_Diagnos").combogrid('setValue',"");
		InitCombo();
		ItmDiagnoseDataGrid.datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitItmDiagnosGrid();
	}
}
function InitItmDiagnosGrid(){
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
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].ItmDiaRowid);
                            }
                            var ItmDiaRowid=ids.join(',');
                            if (ItmDiaRowid==""){
	                            editRow = undefined;
				                ItmDiagnoseDataGrid.datagrid("rejectChanges");
				                ItmDiagnoseDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.ItmDiagnose",
								MethodName:"delete",
							   	Rowid:ItmDiaRowid
							},false)
							if(value=="0"){
								ItmDiagnoseDataGrid.datagrid('load');
								ItmDiagnoseDataGrid.datagrid('unselectAll');
								$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
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
               //var rows = ItmDiagnoseDataGrid.datagrid("getSelected");     
               if (editRow != undefined)
                {
                	var rows=ItmDiagnoseDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");  
					var editors = ItmDiagnoseDataGrid.datagrid('getEditors', editRow);  				
					var PatientType =  editors[0].target.combobox('getValue');
					if (!PatientType) {
						PatientType="";
					}
					var ArcimDr =  rows.ItmMastDR //editors[1].target.combobox('getValue');
					if(ArcimDr==""){
						$.messager.alert("提示", "请选择医嘱项!", "error");
						return false;
					}
					/*var MRCIDRowId =  editors[2].target.combobox('getValue');
					if(MRCIDRowId==""){
						$.messager.alert("提示", "请选择诊断!", "error");
						return false;
					}*/
					var MRCIDRowId=rows.DiagnoseDR
					if(MRCIDRowId==""){
						$.messager.alert("提示", "请选择诊断!", "error");
						return false;
					}
	                var Remark=editors[3].target.val();
					var Str=PatientType+"!"+ArcimDr+"!"+MRCIDRowId+"!"+Remark;
					var ItmDiaRowid="";
					var rows1 = ItmDiagnoseDataGrid.datagrid("getRows");	
					if(rows.ItmDiaRowid){
						 ItmDiaRowid=rows.ItmDiaRowid;		
	                     for(var i=0; i<rows1.length; i++){
					     if(rows1[i].ItmDiaRowid!=rows.ItmDiaRowid){
						   if((PatientType==rows1[i].PatientType)&&(ArcimDr==rows1[i].ItmMastDR)&&(MRCIDRowId==rows1[i].DiagnoseDR)){
							   $.messager.alert('提示',"不能修改,该记录已存在!");
							   return false;
						   }
				       }
				      }
					}else{
						for(var i=0; i<rows1.length; i++){
							if(rows1[i].ItmDiaRowid!=undefined){
							   if((PatientType==rows1[i].PatientType)&&(ArcimDr==rows1[i].ItmMastDR)&&(MRCIDRowId==rows1[i].DiagnoseDR)){
								   $.messager.alert('提示',"不能增加,该记录已存在!");
								   return false;
							   }
							}
						}
					}
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.ItmDiagnose",
						MethodName:"save",
					   	Rowid:ItmDiaRowid,
					   	Str:Str,
					   	HospId:$HUI.combogrid('#_HospList').getValue()
					},false)
					if(value=="0"){
						ItmDiagnoseDataGrid.datagrid("endEdit", editRow);
						editRow = undefined;
						ItmDiagnoseDataGrid.datagrid('load');
						ItmDiagnoseDataGrid.datagrid('unselectAll'); 
                        $.messager.popover({msg: '保存成功!',type:'success'});							
					}else if(value=="-1"){
						$.messager.alert('提示',"保存失败,请选择有效的医嘱项目");
						return false;
					}else if(value=="-2"){
						$.messager.alert('提示',"保存失败,请选择有效的诊断");
						return false;
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
	                { field : 'ItmDiaRowid',title : '',width : 1,hidden:true  
                    },
        			{ field: 'PatientType', title: '患者类型', width: 50, align: 'center', sortable: true, resizable: true,
        			  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PACADM&QueryName=GetCTSocialstatusList",
								valueField:'SSRowId',
								textField:'SSDesc',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								},
								onBeforeLoad:function(param){
									param.HospId=$HUI.combogrid('#_HospList').getValue();
								}
							  }
     					},
						formatter:function(SSRowId,record){
							  return record.PatientTypeDesc;
						}
        			},
					{ field : 'PatientTypeDesc',title : '',width : 100 , align: 'center', sortable: true, hidden: true 
                    },
                    {
                      field : 'ItmMastDR',title : '药品名称',width : 150,hidden:true
                    },
					{ field: 'ARCIMDesc', title: '药品名称', width: 150, align: 'center', sortable: true,
					   editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:290,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
		                            value:'',//缺省值 
		                            mode:'remote',
									pagination : true,//是否分页   
									rownumbers:true,//序号   
									collapsible:false,//是否可折叠的   
									fit: true,//自动大小   
									pageSize: 10,//每页显示的记录条数，默认为10   
									pageList: [10],//可以设置每页记录条数的列表  
		                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									onSelect : function(rowIndex, rowData) {
										  var rows=ItmDiagnoseDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                      if(rows)rows.ItmMastDR=rowData.ArcimRowID
					                 },
					                 onBeforeLoad:function(param){
										if (param['q']) {
											var desc=param['q'];
										}else{
											//return false;
										}
										param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
									}
                        		}
		        			  }		
					},
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
					{ field: 'Remark', title: '备注', width: 100, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text'
					  }
					}				
    			 ]];
	ItmDiagnoseDataGrid=$("#tabItmDiagnos").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ItmDiaRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItmDiagnoseColumns,
    	toolbar :ItmDiagnoseBar,
		onDblClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			ItmDiagnoseDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},onBeforeLoad:function(param){
		   editRow = undefined;
		   if (ItmDiagnoseDataGrid) ItmDiagnoseDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
	       var PatientType = $('#Combo_PatientType').combo('getValue'); 
	       var Diagnos = $('#Combo_Diagnos').combogrid('getValue');
	       var ARCIMRowid=$('#Combo_Item').combogrid('getValue');
	       param.ClassName ='DHCDoc.DHCDocConfig.ItmDiagnose';
	       param.QueryName ='GetItmDiagnose';
	       param.PatType =PatientType;
	       param.ARCIMRowid =ARCIMRowid;
	       param.Diagnose =Diagnos;
	       param.HospId=$HUI.combogrid('#_HospList').getValue();
	   }
	});
}
function InitCombo()
{
	$("#Combo_PatientType").combobox({      
    	valueField:'SSRowId',   
    	textField:'SSDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.PACADM';
			param.QueryName = 'GetCTSocialstatusList';
			param.Arg1=$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =1;
		}  
	});
	$('#Combo_Diagnos').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 200,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDiagnoseList",
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
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}else{
				//return false;
			}
			param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
  $('#Combo_Item').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 200,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
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
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#Combo_Item').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_Item').combogrid("options").value=selected.ArcimRowID;
			}
		},
		onBeforeLoad:function(param){
			var desc="";
			if (param['q']) {
				var desc=param['q'];
			}else{
				//return false;
			}
			param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
}
