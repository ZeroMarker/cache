var editRow=undefined;
// ����Դ���ڻ������ݡ�����Ҫ����ҽԺ2022.5.16
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
		$.messager.popover({msg: '���벻��Ϊ��!',type: 'error'});
		return false;
	};
	var SSourceDesc=$("#CopySourceDesc").val();
	if(SSourceDesc==""){
		$.messager.popover({msg: '���Ʋ���Ϊ��!',type: 'error'});
		return false;
	}
	var SSourceType=$("#CopySourceType").combobox("getValue");
	if(SSourceType==""){
		$.messager.popover({msg: '���Ͳ���Ϊ��!',type: 'error'});
		return false;
	}
	var SourceExpression=$("#CopySourceExpression").val();
	if(SourceExpression==""){
		$.messager.popover({msg: '�������ʽ����Ϊ��!',type: 'error'});
		return false;
	}else
	{
		var reg = /[\r\n]+/g;
		if(reg.test(SourceExpression)){
	   		$.messager.popover({msg: '�������ʽ�к��л��з�!',type: 'error'});
	   		return;
		}
		if (!checkExpression(SourceExpression))
		{
			$.messager.popover({msg: '�������ʽ���Ϸ�������������ر���(ע���Сд)��s result = ',type: 'error'});
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
		   $.messager.popover({msg: '����ɹ�!',type: 'success'});
		   $("#CopyWin").window('close');
		   return false;
		}else{
			$.messager.popover({msg: '����ʧ��:'+rtn,type: 'error'});
		    return false;
		}
	}); 	
});
$("#BCancel").click(function(){
 	$("#CopyWin").window('close');
});
function InitNurseStatsSourceTab(){
	var ToolBar = [{
			text: '����',
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
					$.messager.popover({msg: '�����ڱ༭���У����ȵ������!',type: 'error'});
				}
			}
		},{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#NurseStatsSourceTab").datagrid("getSelections");
				if (rows.length > 0) {
					$.messager.confirm("��ʾ", "ȷ��ɾ����?",
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
	   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
					        }else{
						       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
					        }
					        editRow = undefined;
	                    }
	                });
				}else{
					$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
				}
			}
	    },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				 if (editRow != undefined) {
					var rows=$("#NurseStatsSourceTab").datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = $("#NurseStatsSourceTab").datagrid('getEditors', editRow);
					var SourceCode = editors[0].target.val();
					if(SourceCode==""){
						$.messager.popover({msg: '���벻��Ϊ��!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var SSourceDesc=editors[1].target.val();
					if(SSourceDesc==""){
						$.messager.popover({msg: '���Ʋ���Ϊ��!',type: 'error'});
						$(editors[1].target).focus();
						return false;
					}
					var SSourceType=editors[2].target.combobox("getValue");
					if(SSourceType==""){
						$.messager.popover({msg: '���Ͳ���Ϊ��!',type: 'error'});
						$(editors[2].target).focus();
						return false;
					}
					var SourceExpression=editors[3].target.val();
					if(SourceExpression==""){
						$.messager.popover({msg: '�������ʽ����Ϊ��!',type: 'error'});
						$(editors[3].target).focus();
						return false;
					}else
					{
						var reg = /[\r\n]+/g;
						if(reg.test(SourceExpression)){
					   		$.messager.popover({msg: '�������ʽ�к��л��з�!',type: 'error'});
					   		return;
						}
						if (!checkExpression(SourceExpression))
						{
							$.messager.popover({msg: '�������ʽ���Ϸ�������������ر���(ע���Сд)��s result = ',type: 'error'});
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
						  	$.messager.popover({msg: '����ɹ�!',type: 'success'});
						   return false;
						}else{
							$.messager.popover({msg: '����ʧ��:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },{
			text: '����',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#NurseStatsSourceTab").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg: '��ѡ����Ҫ���Ƶ����ݣ�',type: 'error'});
					return false;
				}else if(!selected.SourceRowId){
					$.messager.popover({msg: '��ѡ���ѱ�������ݣ�',type: 'error'});
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
		{ field: 'SourceCode', title: '����',width:150, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'SourceDesc', title: '����',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'SourceType', title: '����',width:160, editor : 
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
		{ field: 'SourceExpression', title: '�������ʽ',width:700, editor : 
			{type : 'textarea',options : {required:true}}
		},
		{ field: 'SourceRemark', title: '��ע',width:300, editor : 
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
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false,
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		idField:"SourceRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
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
	            $.messager.popover({msg: '�����ڱ༭���У����ȵ������!',type: 'error'});
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

// �ж��Ƿ����ĳЩ�ַ�
var isContains = function(str, substr) {
    return new RegExp(substr).test(str);
}

// У���ʽ�Ƿ���ȷ
function checkExpression(expression)
{
	var c0 = isContains(''+expression+'',"s result = ")
	var c1 = isContains(''+expression+'',"s result= ")
	var c2 = isContains(''+expression+'',"s result=")
	var c3 = isContains(''+expression+'',"s result =")
	return (c0||c1||c2||c3)
}

// ��չtextarea�༭�����Կ��ơ���ק����Ϊ��
$.extend($.fn.datagrid.defaults.editors, {
	textarea: {  // ��������     
        init : function(container, options) {  
           //container ����װ�ر༭�� options,�ṩ�༭����ʼ����
           //�����һ����Ⱦ��easyui-editable-input��textarea����ؼ���ӵ�����container�У�
           //��Ҫʱ�ô���options, �������� input.textarea(options)
          var input = $('<textarea class="datagrid-editable-input" style="resize:vertical;height:120px"></textarea>').appendTo(container);  
          
          /*
          // textarea ���� 2022.4.18 add
		  input.textcomplete([{
		    match: /(^|\b)(\w{2,})$/,
		    search: function (term, callback) {
		        var words = ['google', 'adm', 'emr'];
		        callback($.map(words, function (word) {
			         if (term == "adm"){
		             	return '##class(Nur.NIS.Service.DataSourse.Patient).GetMethodXXX($g(EpisodeID))';
			         }else if (term == "emr")
			         {
				         return '(result,DataID,EmrCode) s result=$s($g(EmrCode)="����¼��ģ��ؼ���":##class(Nur.NIS.Service.DataSourse.NewEmr).GetValueByIdAndItem($g(DataID),"ItemXXX"),1:"")'
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
            //�п�ı������༭�����
            var input = $(target); 
            //Query.boxModel�������ڼ��������Ƿ�ʹ�ñ�׼��ģ����Ⱦ��ǰҳ�档��׼ģʽ����true�����򷵻�false��
            if ($.boxModel == true) {  

                input.width(width - (input.outerWidth() - input.width()) - 10);  
            } else {  
                input.width(width-10);  
            }  
        }
}      
});