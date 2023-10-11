var editRow=undefined;
// 数据源属于基础数据、不需要配置医院2022.5.16
var defaultHosId = 2
$(function(){
	// InitHospList();
	Init();
	$("#BFind").click(function(){
		$("#NurseStatsSourceTab").datagrid("reload");
	});
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#NurseStatsSourceTab").datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitSearchType();
	InitNurseStatsSourceTab();
}
function RefreshData(){
	$("#NurseStatsSourceTab").datagrid("reload");
}

$("#BReportCopy").click(function(){
	var SourceCode = $("#CopySourceCode").val();
	if(SourceCode==""){
		$.messager.popover({msg: '编码不能为空!',type: 'error'});
		return false;
	};
	var SSourceDesc=$("#CopySourceDesc").val();
	if(SSourceDesc==""){
		$.messager.popover({msg: '名称不能为空!',type: 'error'});
		return false;
	}
	var SSourceType=$("#CopySourceType").combobox("getValue");
	if(SSourceType==""){
		$.messager.popover({msg: '类型不能为空!',type: 'error'});
		return false;
	}
	var SourceExpression=$("#CopySourceExpression").val();
	if(SourceExpression==""){
		$.messager.popover({msg: '方法表达式不能为空!',type: 'error'});
		return false;
	}else
	{
		var reg = /[\r\n]+/g;
		if(reg.test(SourceExpression)){
	   		$.messager.popover({msg: '方法表达式中含有换行符!',type: 'error'});
	   		return;
		}
		if (!checkExpression(SourceExpression))
		{
			$.messager.popover({msg: '方法表达式不合法，必须包含返回变量(注意大小写)：s result = ',type: 'error'});
	   		return;
		}
	}
	var SourceRowId = "";
    $.m({ 
		ClassName:"Nur.NIS.Service.ReportV2.SourceConfig", 
		MethodName:"HandleStatsSource",
		rowID:SourceRowId,
		code:SourceCode,
		name:SSourceDesc,
		Type:SSourceType, 
		express:SourceExpression,
		hospId:defaultHosId,
		event:"SAVE",
		sourceRemark:$("#CopySourceRemark").val()
	},function(rtn){
		if(rtn==0){
		   $("#NurseStatsSourceTab").datagrid("reload");
		   $.messager.popover({msg: '保存成功!',type: 'success'});
		   $("#CopyWin").window('close');
		   return false;
		}else{
			$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
		    return false;
		}
	}); 	
});
$("#BCancel").click(function(){
 	$("#CopyWin").window('close');
});
function InitNurseStatsSourceTab(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#NurseStatsSourceTab").datagrid("getRows");
					$("#NurseStatsSourceTab").datagrid("appendRow", {
	                    SourceRowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#NurseStatsSourceTab").datagrid("beginEdit", editRow);
	                var editors = $("#NurseStatsSourceTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
				}else{
					$.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
				}
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#NurseStatsSourceTab").datagrid("getSelections");
				if (rows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {
							var ids = [];
	                        for (var i = 0; i < rows.length; i++) {
	                            ids.push(rows[i].SourceRowId);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#NurseStatsSourceTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.SourceConfig", 
								MethodName:"HandleStatsSource",
								rowID:ID, event:"DELETE"
							},false);
					        if(value=="0"){
						       $('#NurseStatsSourceTab').datagrid('deleteRow',$('#NurseStatsSourceTab').datagrid('getRowIndex',ID));
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
					        editRow = undefined;
	                    }
	                });
				}else{
					$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
				}
			}
	    },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				 if (editRow != undefined) {
					var rows=$("#NurseStatsSourceTab").datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = $("#NurseStatsSourceTab").datagrid('getEditors', editRow);
					var SourceCode = editors[0].target.val();
					if(SourceCode==""){
						$.messager.popover({msg: '编码不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var SSourceDesc=editors[1].target.val();
					if(SSourceDesc==""){
						$.messager.popover({msg: '名称不能为空!',type: 'error'});
						$(editors[1].target).focus();
						return false;
					}
					var SSourceType=editors[2].target.combobox("getValue");
					if(SSourceType==""){
						$.messager.popover({msg: '类型不能为空!',type: 'error'});
						$(editors[2].target).focus();
						return false;
					}
					var SourceExpression=editors[3].target.val();
					if(SourceExpression==""){
						$.messager.popover({msg: '方法表达式不能为空!',type: 'error'});
						$(editors[3].target).focus();
						return false;
					}else
					{
						var reg = /[\r\n]+/g;
						if(reg.test(SourceExpression)){
					   		$.messager.popover({msg: '方法表达式中含有换行符!',type: 'error'});
					   		return;
						}
						if (!checkExpression(SourceExpression))
						{
							$.messager.popover({msg: '方法表达式不合法，必须包含返回变量(注意大小写)：s result = ',type: 'error'});
					   		return;
						}
					}

					var SourceRowId = rows.SourceRowId;
					if (!SourceRowId) SourceRowId="";
	                $.m({ 
						ClassName:"Nur.NIS.Service.ReportV2.SourceConfig", 
						MethodName:"HandleStatsSource",
						rowID:SourceRowId,
						code:SourceCode,
						name:SSourceDesc,
						Type:SSourceType, 
						express:SourceExpression,
						hospId:defaultHosId,
						sourceRemark:editors[4].target.val(),
						event:"SAVE"
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						   $("#NurseStatsSourceTab").datagrid("reload");
						  	$.messager.popover({msg: '保存成功!',type: 'success'});
						   return false;
						}else{
							$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },{
			text: '复制',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#NurseStatsSourceTab").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg: '请选择需要复制的数据！',type: 'error'});
					return false;
				}else if(!selected.SourceRowId){
					$.messager.popover({msg: '请选择已保存的数据！',type: 'error'});
					return false;
				}
				$("#CopyWin" ).window({
				   modal: true,
				   collapsible:false,
				   minimizable:false,
				   maximizable:false,
				   closed:true
				}).window('open');
				$("#CopySourceCode").val(selected.SourceCode+"Copy").focus();
				$("#CopySourceDesc").val(selected.SourceDesc+"Copy");
				$("#CopySourceExpression").val(selected.SourceExpression);
				$("#CopySourceRemark").val(selected.SourceRemark);
				$("#CopySourceType").combobox({
					required:true,
					editable:false,
					value:selected.SourceType,
					valueField:'value',
					textField:'text',
					rowStyle:"checkbox",
					data:ServerObj.SSSourceTypeJson				
				});
			}
	    }
	    ];
	var Columns=[[ 
		{ field: 'SourceCode', title: '编码',width:150, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'SourceDesc', title: '名称',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'SourceType', title: '类型',width:160, editor : 
			{
				type:'combobox',  
				options:{
					editable:false,
					data:ServerObj.SSSourceTypeJson
				}
			},
			formatter: function(value,row,index){
				return row["SourceTypeDesc"];
			}
		},
		{ field: 'SourceExpression', title: '方法表达式',width:700, editor : 
			{type : 'textarea',options : {required:true}}
		},
		{ field: 'SourceRemark', title: '备注',width:300, editor : 
			{type : 'textarea',options : {required:true}}
		}
	]];
	$('#NurseStatsSourceTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		idField:"SourceRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.SourceConfig&QueryName=GetSourceConfigList",
		onBeforeLoad:function(param){
			$('#NurseStatsSourceTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:defaultHosId,
				SearchDesc:$("#SearchDesc").searchbox("getValue"),
				SearchType:$("#SearchType").combobox("getValues").join("^")
			});
		},
		onLoadSuccess:function(){
			editRow = undefined;
		},
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow != undefined) {
	            $.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
		        return false;
			}
			$('#NurseStatsSourceTab').datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
       }
	})
}
function InitSearchType(){
	$("#SearchType").combobox({
		editable:false,
		multiple:true,
		rowStyle:"checkbox",
		data:ServerObj.SSSourceTypeJson
	})
}

// 判断是否包含某些字符
var isContains = function(str, substr) {
    return new RegExp(substr).test(str);
}

// 校验格式是否正确
function checkExpression(expression)
{
	var c0 = isContains(''+expression+'',"s result = ")
	var c1 = isContains(''+expression+'',"s result= ")
	var c2 = isContains(''+expression+'',"s result=")
	var c3 = isContains(''+expression+'',"s result =")
	return (c0||c1||c2||c3)
}

// 扩展textarea编辑器，以控制“拖拽”行为等
$.extend($.fn.datagrid.defaults.editors, {
	textarea: {  // 调用名称     
        init : function(container, options) {  
           //container 用于装载编辑器 options,提供编辑器初始参数
           //这里把一个渲染成easyui-editable-input的textarea输入控件添加到容器container中，
           //需要时用传入options, 这样调用 input.textarea(options)
          var input = $('<textarea class="datagrid-editable-input" style="resize:vertical;height:120px"></textarea>').appendTo(container);  
          
          /*
          // textarea 联想 2022.4.18 add
		  input.textcomplete([{
		    match: /(^|\b)(\w{2,})$/,
		    search: function (term, callback) {
		        var words = ['google', 'adm', 'emr'];
		        callback($.map(words, function (word) {
			         if (term == "adm"){
		             	return '##class(Nur.NIS.Service.DataSourse.Patient).GetMethodXXX($g(EpisodeID))';
			         }else if (term == "emr")
			         {
				         return '(result,DataID,EmrCode) s result=$s($g(EmrCode)="病历录入模板关键字":##class(Nur.NIS.Service.DataSourse.NewEmr).GetValueByIdAndItem($g(DataID),"ItemXXX"),1:"")'
				     }
		            return word.indexOf(term) === 0 ? word : null;
		        }));
		    },
		    replace: function (word) {
		        return word;
		    }
		  }]);
		  */
		  
          return input;  
        },  
        getValue : function(target) {  
            return $(target).val();  
        },  

        setValue : function(target, value) {  
            $(target).val(value);  
        },  
        resize : function(target, width) {  
            //列宽改变后调整编辑器宽度
            var input = $(target); 
            //Query.boxModel属性用于检测浏览器是否使用标准盒模型渲染当前页面。标准模式返回true，否则返回false。
            if ($.boxModel == true) {  

                input.width(width - (input.outerWidth() - input.width()) - 10);  
            } else {  
                input.width(width-10);  
            }  
        }
}      
});