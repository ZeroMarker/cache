var PADiagnoseDurationDataGrid;
var editRow=undefined;
var dialog;
$(function(){
	InitHospList();
	$("#BConfirm").click(CopyPatType);
	 $("#BExit").click(function(){
		 dialog.dialog( "close" );
     });
	 $("#BFind").click(function(){
	    PADiagnoseDurationDataGrid.datagrid('reload');
     });
	 InitCombo();
	 InitCache()
})
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitHospList()
{
	var hospComp = GenHospComp("DHCPADiagnoseDuration");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Combo_PatientType").combobox('setValue',"");
     	$("#Combo_Diagnos").combogrid('setValue',"");
		InitCombo();
		PADiagnoseDurationDataGrid.datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPADiagnoseDurationGrid();
	}
}
function InitPADiagnoseDurationGrid(){
	var PADiagnoseDurationBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                editRow = undefined;
                PADiagnoseDurationDataGrid.datagrid("rejectChanges");
                PADiagnoseDurationDataGrid.datagrid("unselectAll");

                if (editRow != undefined) {
                    PADiagnoseDurationDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    PADiagnoseDurationDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    PADiagnoseDurationDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
					editRow1=1;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PADiagnoseDurationDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].PDDRowid);
                            }
                            var PDDRowid=ids.join(',');
                            if (PDDRowid==""){
	                            editRow = undefined;
				                PADiagnoseDurationDataGrid.datagrid("rejectChanges");
				                PADiagnoseDurationDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.PADiagnoseDuration",
								MethodName:"delete",
							   	Rowid:PDDRowid
							},false)
							if(value=="0"){
								PADiagnoseDurationDataGrid.datagrid('load');
								PADiagnoseDurationDataGrid.datagrid('unselectAll');
								$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
							}
					      editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行");
                }
	         
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
               //var rows = PADiagnoseDurationDataGrid.datagrid("getSelected");  		   
               if (editRow != undefined)
                {
                	var rows=PADiagnoseDurationDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");  
					var editors = PADiagnoseDurationDataGrid.datagrid('getEditors', editRow);  				
					var PatientType =  editors[0].target.combobox('getValue');
					if(!PatientType){
						$.messager.alert("提示", "请选择病人类型!");
						return false;
					}
					var DurationRowid =  editors[2].target.combobox('getValue');
					if (!DurationRowid){
						$.messager.alert("提示", "请选择疗程!");
						return false;
					}
					/*var MRCIDRowId =  editors[1].target.combobox('getValue');
					if(MRCIDRowId==""){
						$.messager.alert("提示", "请选择诊断!", "error");
						return false;
					}*/
					var MRCIDRowId=rows.DiagnoseDR
					if ((MRCIDRowId=="")||(MRCIDRowId==undefined)){
						$.messager.alert("提示", "请选择诊断!", "error");
						return false;
					}
	                var Remark=editors[3].target.val();
	                var HospId=$HUI.combogrid('#_HospList').getValue();
					var Str=PatientType+"!"+DurationRowid+"!"+MRCIDRowId+"!"+Remark+"!"+HospId;
					var PDDRowid="";
					var rows1 = PADiagnoseDurationDataGrid.datagrid("getRows");	
					if(rows.PDDRowid){
						 PDDRowid=rows.PDDRowid;		
	                     for(var i=0; i<rows1.length; i++){
						     if(rows1[i].PDDRowid!=rows.PDDRowid){
							   if((PatientType==rows1[i].PatientType)&&(DurationRowid==rows1[i].DurationDR)&&(MRCIDRowId==rows1[i].DiagnoseDR)){
								   $.messager.alert('提示',"不能修改,该记录已存在!");
								   return false;
							   }
					         }
				      	}
					}else{
						var editRow1=0;
						for(var i=0; i<rows1.length; i++){
							if(rows1[i].PDDRowid!=undefined){
							   if((PatientType==rows1[i].PatientType)&&(DurationRowid==rows1[i].DurationDR)&&(MRCIDRowId==rows1[i].DiagnoseDR)){
								   $.messager.alert('提示',"不能增加,该记录已存在!");
								   return false;
							   }
							}
						}
					}
					var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.PADiagnoseDuration",
						MethodName:"save",
					   	Rowid:PDDRowid,
					   	Str:Str
					},false)
					if(value>=0){
						PADiagnoseDurationDataGrid.datagrid("endEdit", editRow);
						editRow = undefined;
						PADiagnoseDurationDataGrid.datagrid('load');
						PADiagnoseDurationDataGrid.datagrid('unselectAll'); 
                        $.messager.popover({msg: '保存成功!',type:'success'});							
					}else{
						if (value=="-1"){
							$.messager.alert('提示',"保存失败,请选择疗程!");
						}else{
							$.messager.alert('提示',"保存失败:"+value);
						}
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
                PADiagnoseDurationDataGrid.datagrid("rejectChanges");
                PADiagnoseDurationDataGrid.datagrid("unselectAll");
            }
        },
        '-', {
            text: '复制人员类型',
            iconCls: 'icon-copy',
            handler: function() {
                $("#dialog-form").css("display", ""); 
				dialog = $( "#dialog-form" ).dialog({
				  autoOpen: false,
				  height: 150,
				  width: 400,
				  modal: true
				});
				dialog.dialog( "open" );
				$("#SSDBCombo_Source").combobox({      
					valueField:'SSRowId',   
					textField:'SSDesc',
					url:"./dhcdoc.cure.query.combo.easyui.csp",
					onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.PACADM';
						param.QueryName = 'GetCTSocialstatusList';
						param.Arg1=$HUI.combogrid('#_HospList').getValue();
						param.ArgCnt =1;
				    } 
				})
                $("#SSDBCombo_Destinate").combobox({      
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
            }
        }];
    var PADiagnoseDurationColumns=[[    
	                { field : 'PDDRowid',title : '',width : 1,hidden:true  
                    },
        			{ field: 'PatientType', title: '病人类型', width: 50, align: 'center',
        			  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PACADM&QueryName=GetCTSocialstatusList",
								valueField:'SSRowId',
								textField:'SSDesc',
								required:true,
								loadFilter:function(data){
								    return data['rows'];
								},
								onBeforeLoad:function(param){
									param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							  }
     					},
						formatter:function(SSRowId,record){
							  return record.PatientTypeDesc;
						}
        			},
					{ field : 'PatientTypeDesc',title : '',width : 100 , align: 'center', sortable: true, hidden: true 
                    },
                    { field: 'DiagnoseDR', title: '诊断', width: 100, align: 'center',hidden:true
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
								 var rows=PADiagnoseDurationDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
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
        			{ field: 'DurationDR', title: '疗程', width: 50, align: 'center',
        			  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value=&Type=XY",
								valueField:'DurRowId',
								textField:'DurCode',
								required:true,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						formatter:function(SSRowId,record){
							  return record.Duration;
						}
        			},
					{ field : 'Duration',title : '',width : 100 , align: 'center', hidden: true 
                    },
					{ field: 'Remark', title: '备注', width: 100, align: 'center',
					  editor : {
                        type : 'text'
					  }
					}				
    			 ]];
	PADiagnoseDurationDataGrid=$("#tabPADiagnoseDuration").datagrid({  
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
		idField:"PDDRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PADiagnoseDurationColumns,
    	toolbar :PADiagnoseDurationBar,
		onDblClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			PADiagnoseDurationDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(queryParams){
			$("#tabPADiagnoseDuration").datagrid("unselectAll");
			editRow=undefined;
			var PatientType = $('#Combo_PatientType').combo('getValue'); 
			var Diagnos = $('#Combo_Diagnos').combogrid('getValue'); 
			queryParams.ClassName ='DHCDoc.DHCDocConfig.PADiagnoseDuration';
			queryParams.QueryName ='GetPADiagnoseDuration';
			queryParams.PatType =PatientType;
			queryParams.Diagnos =Diagnos;
			queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
			//queryParams.ArgCnt =2;
		}
	});
};
function CopyPatType()
{
	var SourceRowId=$("#SSDBCombo_Source").combobox("getValue");
	if(SourceRowId==""){
		$.messager.alert("提示", "请选择要复制的人员类型！", "error");
		return false;
	}
	var DestinateRowId=$("#SSDBCombo_Destinate").combobox("getValue");
	if(DestinateRowId==""){
		$.messager.alert("提示", "请选择要复制到的人员类型！", "error");
		return false;
	}
	if(SourceRowId==DestinateRowId){
		$.messager.alert("提示", "请选择不同的人员类型", "error");
		return false;
	}
	var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.PADiagnoseDuration",
		MethodName:"CopyPatType",
	   	SourceRowId:SourceRowId,
	   	DestinateRowId:DestinateRowId,
	   	HospId:$HUI.combogrid('#_HospList').getValue()
	},false)
	//$$select^DHCPADiagnoseDuration 去掉w Rowid否则程序报错
	if(value==0){
		PADiagnoseDurationDataGrid.datagrid("endEdit", editRow);
		PADiagnoseDurationDataGrid.datagrid('load');
		PADiagnoseDurationDataGrid.datagrid('unselectAll'); 
        $.messager.show({title:"提示",msg:"复制成功"});									
	}else if(value=="-1"){
		    $.messager.alert('提示',"提示请选择有效的病人类型!");
	}else if(value=="-2"){
		    $.messager.alert('提示',"不能复制，该记录已存在!");
	}else{
		$.messager.alert('提示',"复制失败:"+value);
		return false;
	}
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
}