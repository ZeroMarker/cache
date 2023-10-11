var editRow=undefined;
var editRow1=undefined;
var editRow2=undefined;
var ItemOrderQtyLimitDataGrid;
var ItemConflictDataGrid;
var ItemReplaceDataGrid;
//var DARCIMPartialStr=[{"code":"1","desc":"一个基本单位"},{"code":"2","desc":"半个基本单位"},{"code":"3","desc":"无限制"}];
var ConflictTypeArr=[{"code":"OW","desc":"单向"},{"code":"TW","desc":"双向"}];
var dialog1;
$(function(){
	InitHospList();
    $("#BFind").click(LoadItemOrderQtyLimitDataGrid);
});
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitHospList()
{
	var hospComp = GenHospComp("DHC_ItmMast");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#Combo_Arcim').combogrid('setValue',"");
		$('#Combo_Arcim').combogrid('grid').datagrid('load',{Alias:""});
		LoadItemOrderQtyLimitDataGrid();
		editRow=undefined;
		editRow1=undefined;
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitArcimList();
		InitItemOrderQtyLimitGrid();
		LoadItemOrderQtyLimitDataGrid();
		InittabItemReplaceDataGrid();
		InitCache();
	}
}
function InitItemOrderQtyLimitGrid()
{
	var ItemOrderQtyLimitToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow = undefined;
                ItemOrderQtyLimitDataGrid.datagrid("rejectChanges");
                ItemOrderQtyLimitDataGrid.datagrid("unselectAll");
                if (editRow != undefined) {
                    ItemOrderQtyLimitDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    ItemOrderQtyLimitDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {
							DARCIMConflictTypeValue:"TW",
							DARCIMConflictType:"双向",
							DARCIMPartialValue:"",
							DARCIMCanCrossDay:""
						}
                    });
                    //将新插入的那一行开户编辑状态
                    ItemOrderQtyLimitDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow = 0;
                    var editors = ItemOrderQtyLimitDataGrid.datagrid('getEditors', editRow); 
                    editors[5].target.combobox('setValue','FU');
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = ItemOrderQtyLimitDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DARCIMRowid);
                            }
                            var DARCIMRowid=ids.join(',');
                            if (DARCIMRowid==""){
	                            editRow = undefined;
				                ItemOrderQtyLimitDataGrid.datagrid("rejectChanges");
				                ItemOrderQtyLimitDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
								 MethodName:"delete",
								 Rowid:DARCIMRowid
							},false);
							if(value=="0"){
								ItemOrderQtyLimitDataGrid.datagrid('load');
	           					ItemOrderQtyLimitDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg:"删除成功!",type:'success'});
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
			  if(editRow==undefined){
				  return false;
			  }
			    var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                //var rows = ItemOrderQtyLimitDataGrid.datagrid("getRows");
                if(rows.DARCIMRowid){
	                var DARCIMRowid=rows.DARCIMRowid
	            }else{
		            var DARCIMRowid=""
		        }
		        var editors = ItemOrderQtyLimitDataGrid.datagrid('getEditors', editRow); 
				//var ArcimRowid=editors[0].target.combobox('getValue');
				var ArcimRowid=rows.DARCIMARCIMDR
				if ((ArcimRowid=="")||(ArcimRowid==undefined)){
					$.messager.alert('提示',"请选择医嘱项");
					return false;
				}
				//var MinQty=editors[1].target.val();
				//var MaxQty=editors[2].target.val();
				var MinQty=""
				var MaxQty=""
				var ShowOEMessage=editors[1].target.is(':checked');
				if(ShowOEMessage) ShowOEMessage="Y";
				else {ShowOEMessage="N"};
				var RequireNote=editors[2].target.is(':checked');
				if(RequireNote) RequireNote="Y";
				else {RequireNote="N"};
				/*var NeedSkinTest=editors[5].target.is(':checked');
				if(NeedSkinTest) NeedSkinTest="Y";
				else {NeedSkinTest="N"};*/
				var NeedSkinTest="N"
				var AlertStockQty=editors[3].target.val();
				var IPNeedBillQty=editors[4].target.is(':checked');
				if(IPNeedBillQty) IPNeedBillQty="Y";
				else {IPNeedBillQty="N"};
				
				var SttIsCanCrossDay=rows['DARCIMSttCanCrossDay'] ;//editors[6].target.is(':checked');
				if (!SttIsCanCrossDay) SttIsCanCrossDay="";
				//if(IsCanCrossDay) IsCanCrossDay="Y";
				//else {IsCanCrossDay="N"};
				
				var AllowOnlyOnce=editors[7].target.is(':checked');
				if(AllowOnlyOnce) AllowOnlyOnce="Y";
				else {AllowOnlyOnce="N"};
				
				var DARCIMConflictType=rows.DARCIMConflictTypeValue;
				var PartialValue=editors[5].target.combobox('getValue'); //
				var OrderType=$.m({
					 ClassName:"web.DHCDocOrderCommon",
					 MethodName:"GetArcimClassification",
					 ArcimRowid:ArcimRowid,
					 CurLogonHosp:session['LOGON.HOSPID']
				},false);
				///RW 西药/成药 RC 中草药,L 检验,E 检查,O 其他,""
				if ((PartialValue=="")&&((OrderType=="RW")||(OrderType=="RC"))) {
					$.messager.alert("提示", "请选择单次剂量计算偏好");
					return false;
				}
				var AutoInsertONEOrd=editors[9].target.is(':checked');
				if(AutoInsertONEOrd) AutoInsertONEOrd="Y";
				else {AutoInsertONEOrd="N"};
				
				var SameFreqDifferentDoses=editors[10].target.is(':checked');
				if(SameFreqDifferentDoses) SameFreqDifferentDoses="Y";
				else {SameFreqDifferentDoses="N"};
				
				//var CustomDescOrd=editors[10].target.is(':checked');
				if(false) CustomDescOrd="Y";
				else {CustomDescOrd="N"};
				var OrdDateIsCanCrossDay=rows['DARCIMOrdDateCanCrossDay'] ;
				if (!OrdDateIsCanCrossDay) OrdDateIsCanCrossDay="";
				var LabOrdDayAllowRepeat=editors[12].target.is(':checked');
				if(LabOrdDayAllowRepeat) LabOrdDayAllowRepeat="Y";
				else {LabOrdDayAllowRepeat="N"};
				var DARCIMCountInButNotOutFlag=editors[13].target.is(':checked')?"Y":"N";
				var DARCIMCountInButNotOutIPLongOrdRollSttTime=editors[14].target.timespinner('getValue');
				if (DARCIMCountInButNotOutIPLongOrdRollSttTime!="") {
					var time= /^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$/;
					if (time.test(DARCIMCountInButNotOutIPLongOrdRollSttTime) != true) {
					    $.messager.alert("提示", "计入不记出医嘱-无频次长嘱滚动默认开始时间格式不正确!");
						return false;
					}
					if (DARCIMCountInButNotOutIPLongOrdRollSttTime=="00:00") {
						$.messager.alert("提示", "计入不记出医嘱-无频次长嘱滚动默认开始时间不能设置为00:00!");
						return false;
					}
				}
				var NotLimitQty=editors[15].target.is(':checked')?"Y":"N";
				var ValStr=DARCIMRowid+"^"+ArcimRowid+"^"+MinQty+"^"+MaxQty+"^"+ShowOEMessage+"^"+RequireNote+"^"+NeedSkinTest+"^"+AlertStockQty+"^"+IPNeedBillQty+"^"+PartialValue+"^"+SttIsCanCrossDay+"^"+AllowOnlyOnce+"^"+DARCIMConflictType+"^"+AutoInsertONEOrd+"^"+SameFreqDifferentDoses+"^"+CustomDescOrd+"^"+OrdDateIsCanCrossDay+"^"+LabOrdDayAllowRepeat+"^"+DARCIMCountInButNotOutFlag+"^"+DARCIMCountInButNotOutIPLongOrdRollSttTime+"^"+NotLimitQty;
				var value=$.m({
					 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
					 MethodName:"save",
					 str:ValStr
				},false);
				if(value=="0"){
					ItemOrderQtyLimitDataGrid.datagrid("endEdit", editRow);
					editRow = undefined;
					ItemOrderQtyLimitDataGrid.datagrid('load');
					ItemOrderQtyLimitDataGrid.datagrid('unselectAll');
					$.messager.popover({msg:"保存成功!",type:'success'});
				}else if(value=="-1"){
					$.messager.alert('提示',"不能增加或更新，该记录已存在");
					return false;
				}else{
					$.messager.alert('提示',"保存失败:"+value);
					return false;
				}
				editRow = undefined;
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                ItemOrderQtyLimitDataGrid.datagrid("rejectChanges");
                ItemOrderQtyLimitDataGrid.datagrid("unselectAll");
            }
        },'-', {
            text: '互斥项',
            iconCls: 'icon-edit',
            handler: function() {
				var rows = ItemOrderQtyLimitDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
					var ids = [];
					for (var i = 0; i < rows.length; i++) {
						if (rows[i].DARCIMRowid!=""){
							ids.push(rows[i].DARCIMRowid);
						}
					}
					var DARCIMRowid=ids.join(',')
				}else{
					$.messager.alert('提示',"请选择一条记录!");
					return false;
				}
				if (DARCIMRowid==""){
					$.messager.alert('提示',"请选择一条记录!");
					return false;
				}
                $("#dialog-ItemConflict").css("display", ""); 
				dialog1 = $("#dialog-ItemConflict" ).dialog({
				  autoOpen: false,
				  height: 500,
				  width: 600,
				  modal: true
				});
				dialog1.dialog( "open" );
				InittabItemConflict(DARCIMRowid);
            }
        },'-', {
            text: '医嘱项替换',
            iconCls: 'icon-edit',
            handler: function() {
				var rows = ItemOrderQtyLimitDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
					var ids = [];
					for (var i = 0; i < rows.length; i++) {
						if (rows[i].DARCIMRowid!=""){
							ids.push(rows[i].DARCIMRowid);
						}
					}
					var DARCIMRowid=ids.join(',')
				}else{
					$.messager.alert('提示',"请选择一条记录!");
					return false;
				}
				if (DARCIMRowid==""){
					$.messager.alert('提示',"请选择一条记录!");
					return false;
				}
				$("#dialog-ItemReplace").dialog("open");
				InittabItemReplaceDataGrid(DARCIMRowid);
            }
        },'-', {
            text: '导出EXCEL',
            iconCls: 'icon-export-data',
            handler: function() {
	            var xlsname="医嘱项扩展设定";
	            var Str ="(function test(x){"
					Str +="var xlApp = new ActiveXObject('Excel.Application');"
					Str +="var xlBook = xlApp.Workbooks.Add();"
					Str +="var xlSheet = xlBook.ActiveSheet;"
					Str +="xlSheet.Columns.NumberFormatLocal = '@';"
					//设置工作薄名称  
					Str +="xlSheet.name = '"+xlsname+"DocItemDefault.xlsx';"; 
					var columns = ItemOrderQtyLimitDataGrid.datagrid("options").columns[0];
					Str +="xlSheet.cells("+(1)+","+(1)+")='ID';";
					Str +="xlSheet.cells("+(1)+","+(2)+")='医嘱项ID';";
					var columnCount=2;
					for (var i=0;i<columns.length;i++) {
						if (columns[i].hidden) continue;
						Str +="xlSheet.cells("+(1)+","+(columnCount+1)+")='"+columns[i].title+"';";
						columnCount++;
					}
					/*
					DARCIMRowid_"^"_DARCIMARCIMDR_"^"_ARCIMDesc_"^"_DARCIMShowOEMessage
					_"^"_DARCIMRequireNote_"^"_DARCIMAlertStockQty_"^"_
					DARCIMIPNeedBillQty_"^"_DARCIMPartial_"^"_
					DARCIMSttCanCrossDay_"^"_AllowOnlyOnce_"^"_DARCIMConflictType
					_"^"_AutoInsertONEOrd_"^"_SameFreqDifferentDoses_"^"_DARCIMOrdDateCanCrossDay
					_"^"_LabOrdDayAllowRepeat_"^"_DARCIMCountInButNotOutFlag
					_"^"_DARCIMCountInButNotOutIPLongOrdRollSttTime
					*/
					LoadItemOrderQtyLimitDataGrid();
					var data=ItemOrderQtyLimitDataGrid.datagrid('getData');
					for (var i=1; i<(data.total+1); i++){
						var objScope=$.m({
							 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
							 MethodName:"ItemOrderQtyLimitListExport1",
							 num:i
						},false);
						objScope=eval("(" + objScope + ")");
						var value1=objScope.result;
						var rtnarry=value1.split("^");
						for (var j=0;j<rtnarry.length;j++){
							Str +="xlSheet.cells("+(i+1)+","+(j+1)+")='"+rtnarry[j]+"';";
						}
					}	
					var filename=xlsname+".xls";
					Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
					Str += "xlBook.SaveAs(fname);"
					Str +="xlApp.Visible = false;"
					Str +="xlApp.UserControl = false;"
					Str +="xlBook.Close(savechanges=false);"
					Str +="xlApp.Quit();"
					Str +="xlSheet=null;"
					Str +="xlBook=null;"
					Str +="xlApp=null;"
					Str +="return 1;}());";
				//以上为拼接Excel打印代码为字符串
				CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
				var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
			}
        },'-',{
			id:'tip',
			iconCls: 'icon-help',
			text:'互斥类型使用说明',
			handler: function(){
				$("#tip").popover('show');
			}
	    }];
	ItemOrderQtyLimitColumns=[[    
                    { field: 'DARCIMRowid', title: 'ID', width: 1,hidden:true},
                    { field: 'ARCIMDesc', title: '名称', width: 250,
					    editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
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
		                            //url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onSelect : function(rowIndex, rowData) {
										var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                        if(rows)rows.DARCIMARCIMDR=rowData.ArcimRowID
				                     },
				                     onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             }
                        		}
		        			}
					},
        			{ field: 'DARCIMARCIMDR', title: '医嘱项ID', width: 250,hidden:true},
					
					/*{ field: 'DARCIMMinQty', title: '最小量', width: 100, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'DARCIMMaxQty', title: '最大量', width: 100, align: 'center', sortable: true,
					  editor : {type : 'text',options : {}}
					},*/
					{ field: 'DARCIMShowOEMessage', title: '是否提示', width: 70,
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
					{ field: 'DARCIMRequireNote', title: '需要备注(非草药)', width: 115,
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
					/*{ field: 'DARCIMNeedSkinTest', title: '需要皮试', width: 50, align: 'center', sortable: true,
					   editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					},*/
					{ field: 'DARCIMAlertStockQty', title: '最小提示库存(待用)', width: 130,
					   editor : {type : 'text',options : {}}
					},
					{ field: 'DARCIMIPNeedBillQty', title: '住院用整数量', width: 100,
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
					{ field: 'DARCIMPartialValue', title: '单次剂量计算偏好', width: 175,
					   editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[
						      		{"code":"A","desc":"按实际单次剂量计算"},
						      		{"code":"H","desc":"偏好取半(即不足一半取半,足够一半取整)"},
						      		{"code":"FD","desc":"偏好向下取整(即不为整数则向下取整，最小值不低于1)"},
						      		{"code":"FU","desc":"偏好向上取整(即不为整数则向上取整)"}
						      	   ]
					        }
				         },
						  formatter:function(value, record){
							  return record.DARCIMPartial;
						 }
					},
					/*{ field: 'DARCIMPartial', title: '', hidden:true
					
					},*/
					{ field: 'DARCIMSttCanCrossDay', title: '修改医嘱开始日期时间权限', width: 175,
						editor:{
					        type:'combobox',
					        options:{
						      editable:true,
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[{"code":"Y","desc":"是"},{"code":"N","desc":"否"}],
						      onSelect:function(rec){
						        var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.DARCIMSttCanCrossDay=rec.code;
						      },
						      onChange:function(newValue, oldValue){
							      if (newValue==""){
								      var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                	  rows.DARCIMSttCanCrossDay="";
								  }
							  }
					        }
				         },
						 formatter:function(value, record){
							 if (value=="Y"){
								 return "是";
						     }else if(value=="N"){
							     return "否"
							 }
							 return "";
						 },
						 styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else if(value=="N"){
					 			return 'color:#f16e57;';
					 		}
		 				}
					   /*editor : {
                                type : 'checkbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }*/
					},{ field: 'AllowOnlyOnce', title: '只允许开一次(所有就诊)', width: 160,
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
					{ field: 'DARCIMConflictType', title: '医嘱互斥类型(仅西医)', width: 150,
					   editor:{
					        type:'combobox',
					        options:{
						      editable:false,
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:ConflictTypeArr,
						      onSelect:function(rec){
						        var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.DARCIMConflictTypeValue=rec.code;
						       }
					        }
				         },
						 formatter:function(value, record){
							 return record.DARCIMConflictType;
						 }
					},
					/*{ field: 'DARCIMConflictTypeValue', title: '', width: 50, align: 'center', sortable: true,hidden:true
					
					},*/{ field: 'AutoInsertONEOrd', title: '长期自备或嘱托自动插入取药医嘱', width: 220,
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
					{ field: 'SameFreqDifferentDoses', title: '同频次不同剂量医嘱', width: 140,
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
					}/*,
					{ field: 'CustomDescOrd', title: '自定义描述医嘱', width: 120,
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
					}*/
					,
					{ field: 'DARCIMOrdDateCanCrossDay', title: '修改开医嘱日期时间权限', width: 180,
						editor:{
					        type:'combobox',
					        options:{
						      editable:true,
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[{"code":"Y","desc":"是"},{"code":"N","desc":"否"}],
						      onSelect:function(rec){
						        var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.DARCIMOrdDateCanCrossDay=rec.code;
						      },
						      onChange:function(newValue, oldValue){
							      if (newValue==""){
								      var rows=ItemOrderQtyLimitDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                	  rows.DARCIMOrdDateCanCrossDay="";
								  }
							  }
					        }
				         },
						 formatter:function(value, record){
							 if (value=="Y"){
								 return "是";
						     }else if(value=="N"){
							     return "否"
							 }
							 return "";
						 },
						 styler: function(value,row,index){
			 				if (value=="Y"){
				 				return 'color:#21ba45;';
				 			}else if(value=="N"){
					 			return 'color:#f16e57;';
					 		}
		 				}
					},{ field: 'LabOrdDayAllowRepeat', title: '检验医嘱同一天允许重复(仅门诊)', width: 230,
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
					},{ field: 'DARCIMCountInButNotOutFlag', title: '计入不记出医嘱标识', width: 135,
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
					{ field: 'DARCIMCountInButNotOutIPLongOrdRollSttTime', title: '计入不记出医嘱-无频次长嘱滚动默认开始时间', width: 295, align: 'center', sortable: true,
					  editor : {type : 'timespinner',options : {}}
					},
					{ field: 'NotLimitQty', title: '检查检验不控制数量', width: 135,
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
					}
    			 ]];
	ItemOrderQtyLimitDataGrid=$('#tabItemOrderQtyLimit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=ItemOrderQtyLimitList",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DARCIMRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemOrderQtyLimitColumns,
		toolbar :ItemOrderQtyLimitToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			ItemOrderQtyLimitDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
		},
		onBeforeLoad:function(param){
			var ArcimRowid = $('#Combo_Arcim').combogrid('getValue'); 
			var HospId=$HUI.combogrid('#_HospList').getValue();
			param = $.extend(param,{ArcimRowid:ArcimRowid,HospId:HospId});
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			editRow=undefined;
		}
	});
	InitTip();
};
function LoadItemOrderQtyLimitDataGrid()
{ 
	var ArcimRowid = $('#Combo_Arcim').combogrid('getValue'); 
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.ItemOrderQtyLimit';
	queryParams.QueryName ='ItemOrderQtyLimitList';
	queryParams.ArcimRowid =ArcimRowid;
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
	//queryParams.ArgCnt =1;
	var opts = ItemOrderQtyLimitDataGrid.datagrid("options");
	opts.url = $URL;
	ItemOrderQtyLimitDataGrid.datagrid('clearSelections');
	ItemOrderQtyLimitDataGrid.datagrid('load', queryParams);
};
function InittabItemConflict(DARCIMRowid)
{
	var ItemConflictToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow1 = undefined;
                ItemConflictDataGrid.datagrid("rejectChanges");
                ItemConflictDataGrid.datagrid("unselectAll");
                if (editRow1 != undefined) {
                    ItemConflictDataGrid.datagrid("endEdit", editRow1);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    ItemConflictDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    ItemConflictDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow1 = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = ItemConflictDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var RowID=ids.join(',');
                            if (RowID==""){
	                             editRow1 = undefined;
				                 ItemConflictDataGrid.datagrid("rejectChanges");
				                 ItemConflictDataGrid.datagrid("unselectAll");
				                 return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
								 MethodName:"deleteConflict",
								 Rowid:RowID
							},false);
							if(value=="0"){
								ItemConflictDataGrid.datagrid('load');
	           					ItemConflictDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg:"删除成功!",type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
							}
							editRow1 = undefined;
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
			  if(editRow1==undefined){
				  return false;
			  }
                var rows = ItemConflictDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(editRow1==i){
						   var editors = ItemConflictDataGrid.datagrid('getEditors', editRow1); 
						   //var ArcimRowid=editors[0].target.combobox('getValue');
						   var rows=ItemConflictDataGrid.datagrid("selectRow",editRow1).datagrid("getSelected");
                           var ArcimRowid=rows.ITCConflictItmDR;
						   if(!ArcimRowid){
								$.messager.alert('提示',"请选择医嘱项");
								return false;
				            }
				            var ConflictType=editors[1].target.combobox('getValue');
				            var IsCMFlag=tkMakeServerCall("web.DHCDocOrderCommon","IsCNMedItem",ArcimRowid)
				            if ((IsCMFlag=="1")&&(!ConflictType)){
					            $.messager.alert('提示',"请选择类型");
								return false;
				            }
				            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
								 MethodName:"insertConflict",
								 DARCIMRowid:DARCIMRowid,
								 arcim:ArcimRowid,
								 ConflictType:ConflictType
							},false);
							if(value=="0"){
								ItemConflictDataGrid.datagrid("endEdit", editRow);
								editRow1 = undefined;
								ItemConflictDataGrid.datagrid('load');
								ItemConflictDataGrid.datagrid('unselectAll');
								$.messager.popover({msg:"保存成功!",type:'success'});
							}else if(value=="-1"){
								$.messager.alert('提示',"不能增加，该记录已存在");
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
							editRow1 = undefined;
						}
				   }
				}

            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow1 = undefined;
                ItemConflictDataGrid.datagrid("rejectChanges");
                ItemConflictDataGrid.datagrid("unselectAll");
            }
        }];
	ItemConflictColumns=[[    
                    { field: 'RowID', title: '', width: 1,hidden:true},
        			{ field: 'ITCConflictItmDR', title: '名称', width: 250,hidden:true},
					{ field: 'ARCIMDesc', title: '医嘱名称', width: 250, align: 'center', sortable: true,
					  editor:{
		                         type:'combogrid',
		                         options:{
		                            required: true,
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
									delay: 500,  
									url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindItem",
		                            //url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             },
						             onSelect : function(rowIndex, rowData) {
										var rows=ItemConflictDataGrid.datagrid("selectRow",editRow1).datagrid("getSelected");
                                        if(rows)rows.ITCConflictItmDR=rowData.ArcimRowID
				                     },
                        		}
		        			  }
					},
					{ field : 'ConflictType',title : '类型',width : 50,
					  editor :{
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindConflictType",
								valueField:'ConflictTypeRowid',
								textField:'ConflictTypeDesc',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  }
                    }
    			 ]];
	ItemConflictDataGrid=$('#tabItemConflict').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=ItemConflictList&DARCIMRowid="+DARCIMRowid,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemConflictColumns,
		toolbar :ItemConflictToolBar
	});
}
function InitArcimList()
{
	$('#Combo_Arcim').combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindItem",
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
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
			var selected = $('#Combo_Arcim').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#Combo_Arcim').combogrid("options").value=selected.ArcimRowID;
			}
		 },
		 onBeforeLoad:function(param){
             var desc=param['q'];
             var HospId=$HUI.combogrid('#_HospList').getValue();
             param = $.extend(param,{Alias:param["q"],HospId:HospId});
         }
	});
};
//医嘱项替换
function InittabItemReplaceDataGrid(DARCIMRowid)
{
	var ItemeplaceToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow2 = undefined;
                ItemReplaceDataGrid.datagrid("rejectChanges");
                ItemReplaceDataGrid.datagrid("unselectAll");
                if (editRow2 != undefined) {
                    ItemReplaceDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    ItemReplaceDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    ItemReplaceDataGrid.datagrid("beginEdit", 0);
                    //给当前编辑的行赋值
                    editRow2 = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = ItemReplaceDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var RowID=ids.join(',');
                            if (RowID==""){
	                             editRow1 = undefined;
				                 ItemReplaceDataGrid.datagrid("rejectChanges");
				                 ItemReplaceDataGrid.datagrid("unselectAll");
				                 return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
								 MethodName:"deleteItmReplace",
								 Rowid:RowID
							},false);
							if(value=="0"){
								ItemReplaceDataGrid.datagrid('load');
	           					ItemReplaceDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg:"删除成功!",type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
							}
							editRow2 = undefined;
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
			  if(editRow2==undefined){
				  return false;
			  }
                var rows = ItemReplaceDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(editRow2==i){
						   var editors = ItemReplaceDataGrid.datagrid('getEditors', editRow2); 
						   var rows=ItemReplaceDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
                           var ArcimRowid=rows.IRReplaceItmDR;
						   if(!ArcimRowid){
								$.messager.alert('提示',"请选择医嘱项");
								return false;
				            }
				            var Expression=editors[1].target.val();
				            if (Expression=="") {
					            $.messager.alert('提示',"请填写替换规则!");
								return false;
					        }
					        var RowID=rows.RowID;
					        if (!RowID) RowID="";
				            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemOrderQtyLimit",
								 MethodName:"saveItmReplace",
								 RowID:RowID,
								 DARCIMRowid:DARCIMRowid,
								 arcim:ArcimRowid,
								 Expression:Expression
							},false);
							if(value=="0"){
								ItemReplaceDataGrid.datagrid("rejectChanges");
								//ItemReplaceDataGrid.datagrid("endEdit", editRow);
								editRow2 = undefined;
								ItemReplaceDataGrid.datagrid('unselectAll').datagrid('load');
								$.messager.popover({msg:"保存成功!",type:'success'});
							}else if(value=="-1"){
								$.messager.alert('提示',"保存失败!记录重复!");
								return false;
							}else if(value=="-2"){
								$.messager.alert('提示',"保存失败！替换项不能与被替换项一致！");
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
							editRow2 = undefined;
						}
				   }
				}

            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow2 = undefined;
                ItemReplaceDataGrid.datagrid("rejectChanges");
                ItemReplaceDataGrid.datagrid("unselectAll");
            }
        }];
	ItemReplaceColumns=[[    
                    { field: 'RowID', title: '', width: 1,hidden:true},
        			{ field: 'IRReplaceItmDR', title: '名称', width: 250,hidden:true},
					{ field: 'ARCIMDesc', title: '医嘱名称', width: 220, align: 'center', sortable: true,
					  editor:{
		                         type:'combogrid',
		                         options:{
		                            required: true,
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
									delay: 500,  
									url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=FindItem",
		                            //url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             },
						             onSelect : function(rowIndex, rowData) {
										var rows=ItemReplaceDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
                                        if(rows)rows.IRReplaceItmDR=rowData.ArcimRowID
				                     }
                        		}
		        			  }
					},
					{ field : 'Expression',title : '替换规则(m程序表达式)',width : 200,
					  editor : {type : 'text',options : {require:true}}
                    }
    			 ]];
	ItemReplaceDataGrid=$('#tabItemReplace').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemOrderQtyLimit&QueryName=ItemReplaceList&DARCIMRowid="+DARCIMRowid,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : false,  //
		idField:"RowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemReplaceColumns,
		toolbar :ItemeplaceToolBar,
		onClickRow:function(rowIndex, rowData){
			if ((editRow2 != undefined)&&(editRow2 !=rowIndex)) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
		},
		onDblClickRow:function(rowIndex, rowData){
			ItemReplaceDataGrid.datagrid("beginEdit", rowIndex);
			editRow2=rowIndex
		},
		onBeforeLoad:function(){
			if (ItemReplaceDataGrid) ItemReplaceDataGrid.datagrid("rejectChanges");
		},
		onLoadSuccess:function(data){
			$(this).datagrid('unselectAll');
			editRow2=undefined;
		}
	});
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>医嘱互斥类型使用说明</li>" + 
		'<li>以"一级护理"，互斥医嘱维护 二级护理、三级护理、特级护理 为例:</li>' +
		'<li>1、单向： 录入"一级护理"后，互斥项里面的医嘱不能录入或录入后停止原"一级护理"，但不存在"一级护理"时互斥项里面的医嘱不进行相互互斥，即二级护理和三级护理、特级护理之间不进行互斥。</li>' +
		'<li>2、双向(默认)：录入"一级护理"后,互斥项里面的医嘱不能录入或录入后停止原"一级护理"，且互斥项里面的医嘱也相互互斥,即二级护理和三级护理、特级护理相互之间互斥。</li>'
		"</ul>" 
		
	$("#tip").popover({
		width:500,
		trigger:'hover',
		content:_content
	});
}
