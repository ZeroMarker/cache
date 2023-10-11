var tablabreportSetDataGrid;
var editRow = undefined;
var RowID="";
var dialog1;
$(function(){
	InitHospList();
	$("#BSave").click(SaveClickHandler);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SplitPrescriptSetting");
	hospComp.jdata.options.onSelect = function(e,t){
		//InitPrescript();
		$('#tablabreportSet').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InittablabreportSet();
	}
}
function InittablabreportSet()
{
	var PrescriptTypeToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    editRow = undefined;
	                tablabreportSetDataGrid.datagrid("rejectChanges");
	                tablabreportSetDataGrid.datagrid("unselectAll");
					RowID=""
                }
                tablabreportSetDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                editRow = 0;
                tablabreportSetDataGrid.datagrid("beginEdit", 0);
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = tablabreportSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ID=rows[0].RowID
                            if (ID==""){
	                            editRow = undefined;
				                tablabreportSetDataGrid.datagrid("rejectChanges");
				                tablabreportSetDataGrid.datagrid("unselectAll");
								RowID="";
								return;
	                        }
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCApp.LabReportSet", 
								MethodName:"Delect",
								RowID:ID
							},false); 
					        if(value=="0"){
						       tablabreportSetDataGrid.datagrid('load');
       					       tablabreportSetDataGrid.datagrid('unselectAll');
							   RowID="";
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
						       return false;
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                tablabreportSetDataGrid.datagrid("rejectChanges");
                tablabreportSetDataGrid.datagrid("unselectAll");
				RowID=""
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow != undefined) {
				var rows=tablabreportSetDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow);
				var Type=editors[0].target.combobox('getValue'); 
				if(Type==""){
					$.messager.alert('提示',"类型不能为空");
					return false;
				};
				var ReportFullFile=editors[2].target.val();
				var ARCIMDR=rows.ARCIMDR
				var ARCIMCatDR=rows.ARCIMCatDR
				
				if ((Type=="医嘱项")&&(ARCIMDR=="")){
					$.messager.alert('提示',"医嘱项不能为空");
					return false;
					}
				if ((Type=="子类")&&(ARCIMCatDR=="")){
					$.messager.alert('提示',"子类不能为空");
					return false;
					}
				if (Type=="默认"){
					ARCIMDR=""
					ARCIMCatDR=""
					}
				var ToReportNo=editors[3].target.is(':checked');
				if(ToReportNo) ToReportNo="Y";
				else {ToReportNo="N"};
				var BeforeReportNo=editors[4].target.val();
				var BeforeReportNoSplit=editors[5].target.val();
				var ToRegistNo=editors[6].target.is(':checked');
				if(ToRegistNo) ToRegistNo="Y";
				else {ToRegistNo="N"};
				var BeforeRegistNo=editors[7].target.val();
				var  ToUserCode=editors[8].target.is(':checked');
				if( ToUserCode)  ToUserCode="Y";
				else { ToUserCode="N"};
				var BeforeUserCode=editors[9].target.val();
				var BeforeOther=editors[10].target.val();
				var InfoStr=ToReportNo+String.fromCharCode(1)+BeforeReportNo+String.fromCharCode(1)+BeforeReportNoSplit+String.fromCharCode(1)+ToRegistNo
				InfoStr=InfoStr+String.fromCharCode(1)+BeforeRegistNo+String.fromCharCode(1)+ToUserCode+String.fromCharCode(1)+BeforeUserCode+String.fromCharCode(1)+BeforeOther
				var RowID=""
				if (rows.RowID) RowID=rows.RowID
                var value=$.m({ 
					ClassName:"DHCDoc.DHCApp.LabReportSet", 
					MethodName:"Insert",
					RowID:RowID, Type:Type, ReportFullFile:ReportFullFile, ARCIMDR:ARCIMDR,
					 ARCIMCatDR:ARCIMCatDR, InfoStr:InfoStr, HospID:$HUI.combogrid('#_HospList').getValue(),
					dataType:"text"
				},false); 
				if(value==0){
				   RowID="";
				   tablabreportSetDataGrid.datagrid('load');
				   tablabreportSetDataGrid.datagrid('unselectAll');
				   $.messager.show({title:"提示",msg:"保存成功"});
				}else{
				   $.messager.alert('提示',"保存失败:"+value);
				   return ;
				}
				editRow = undefined;
				
				
			 }
			}
		},'-',{
			text: '浏览报告设置',
			iconCls: 'icon-edit',
			handler: function() {
				
	          $("#dialog-LabSelect").dialog( "open" );
	          GetRadioValue("LabReport")
			}
		}];
	PrescriptTypeColumns=[[    
                    { field: 'RowID', title: 'ID', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Type', title:'类型', width: 80, align: 'center', sortable: true,
					  editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[
						      		{"code":"默认","desc":"默认"},
						      		{"code":"医嘱项","desc":"医嘱项"},
						      		{"code":"子类","desc":"子类"}
						      	   ]
					        }
				         },
						  formatter:function(value, record){
							  return record.Type;
						 }
					},
        			{ field: 'Desc', title: '医嘱项/子类', width: 150, align: 'center', sortable: true,
					    editor:{
		                         type:'combogrid',
		                         options:{
		                             required: false,
		                             panelWidth:450,
									 panelHeight:350,
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
									delay:500,
		                            url:$URL+"?ClassName=DHCDoc.DHCApp.LabReportSet&QueryName=FindItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onSelect : function(rowIndex, rowData) {
										var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow); 
										var Type=editors[0].target.combobox('getValue'); 
										var rows=tablabreportSetDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
										if (Type=="医嘱项") {
												if(rows){
													rows.ARCIMDR=rowData.ArcimRowID
													rows.ARCIMCatDR=""
												}
											}else{
											    if(rows){
												    rows.ARCIMDR=""
													rows.ARCIMCatDR=rowData.ArcimRowID
												    }
												}
      
				                     },
				                     onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 var editors = tablabreportSetDataGrid.datagrid('getEditors', editRow); 
						                 var Type=editors[0].target.combobox('getValue'); 
						                 param = $.extend(param,{Alias:param["q"],Type:Type,HospId:$HUI.combogrid('#_HospList').getValue()});
						             }
                        		}
		        			}
					},
					{ field: 'ARCIMDR', title: '医嘱项ID', width: 250,hidden:true},
					{ field: 'ARCIMCatDR', title: '子类ID', width: 250,hidden:true},
					{ field: 'ReportFullFile', title:'报告路径', width: 250, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToReportNo', title: '是否开启报告号', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
                            }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 				},
		 				formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 		}
					},
					{ field: 'BeforeReportNo', title:'报告号前参数', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'BeforeReportNoSplit', title:'多个报告号分隔符', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToRegistNo', title: '是否开启登记号', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
                            }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 				},
		 				formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 		}
					},
					{ field: 'BeforeRegistNo', title:'登记号前参数', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'ToUserCode', title: '是否开启用户代码', width: 130,
					   editor : {
                            type : 'icheckbox',
                            options : {
                                on : 'Y',
                                off : ''
                            }
                       },
                       styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else{
					 			return 'color:#f16e57;';
					 		}
		 				},
		 				formatter:function(value,record){
				 			if (value=="Y") return "是";
				 			else  return "否";
				 		}
					},
					{ field: 'BeforeUserCode', title:'用户代码前参数', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'BeforeOther', title:'其他参数', width: 130, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	tablabreportSetDataGrid=$('#tablabreportSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCApp.LabReportSet&QueryName=GetLabReportSetList&HospId=",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :PrescriptTypeColumns,
		toolbar:PrescriptTypeToolBar,
		onClickRow:function(rowIndex, rowData){
			RowID=rowData.RowID
		},
		onDblClickRow:function(rowIndex, rowData){ 
		    RowID=rowData.RowID 
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			editRow=rowIndex
			tablabreportSetDataGrid.datagrid("beginEdit", rowIndex);
       },
       onLoadSuccess:function(data){
	       editRow=undefined;
	   },
	   onBeforeLoad:function(param){
		   RowID="";
		   $('#tabPrescriptSet').datagrid('unselectAll');
		   param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
	   }
	});
}
function SaveClickHandler(){
	 var DataList="";
	 var LabReport = $("input[name='DHCAPP_LabReport']:checked").val();
	 if (LabReport==undefined) {LabReport=""}
	 DataList="LabReport"+String.fromCharCode(1)+LabReport;
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SavebaseInfo",
	 	DataList:DataList,
	 	HospId:HospID
		},false);
	if (value==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		$("#dialog-LabSelect").dialog( "close" );
	}else{
		$.messager.alert("提示", "保存失败"+value, "error");
        return false;	
		}	
}
function GetRadioValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value!=""){
		$HUI.radio("#"+value).setValue(true);
		}
	}