var editRow=undefined;
var LocExtDataGrid;
var LocRowID="";
$(function(){ 
	InitHospList();
    $("#BFind").click(LoadLocExtDataGrid);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_LocExt");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#Combo_Loc").combobox("select","");
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

function Init(){
	InitComboLoc();
    InitLocExtGrid();
}
function InitLocExtGrid()
{
	var LocExtToolBar = [{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            Save();
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                LocExtDataGrid.datagrid("rejectChanges");
                LocExtDataGrid.datagrid("unselectAll");
            }
        }];
	LocExtColumns=[[    
                    { field: 'LocRowID', title: 'LocRowID', width: 1, align: 'center', sortable: true,hidden:true
					},
        			{ field: 'LocDesc', title: '科室', width: 150, align: 'center', sortable: true,formatter:function(value){
	        			return value.split(" ")[1];
	        		}
					},
					{ field: 'RecLocByLogonLoc', title: '登录时以此取接收科室',  align: 'center', sortable: true,
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
					{ field: 'NoReferral', title: '不允许转诊(未用)',  align: 'center', sortable: true,
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
					{ field: 'NotPackQty', title: '不允许录入整包装数量(未用)',  align: 'center', sortable: true,
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
					/*{ field: 'ARCOSInputByLogonLoc', title: '医嘱套按顺序录入数量',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					},*/
					{ field: 'NotNeedInstrArcim', title: '不需要用法绑定的医嘱',  align: 'center', sortable: true,
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
					/*{ field: 'AddDocByNotPriceOEItem', title: '补录医嘱医生为无费用医嘱医生',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					},*/
					{ field: 'ModifySttDateTimeAuthority', title: '修改医嘱开始日期时间权限',  align: 'center', sortable: true,
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
					{ field: 'ModifySttDateTimeUpHour', title: '医嘱开始日期可提前小时数',  align: 'center', sortable: true,
					   editor : {
                                type : 'numberbox'
                       }
					},
					/*{ field: 'StopOrderDiscExec', title: '停医嘱自动停止执行记录',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					},*/
					/*{ field: 'DocAppIntervalTime', title: '医生预约间隔时间(分钟)',  align: 'center', sortable: true,
					   editor : {type : 'text',options : {}}
					},*/
					{ field: 'LocCAVerify', title: '使用电子签名',  align: 'center', sortable: true,
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
					{ field: 'BloodPressureByEntryDiagnosis', title: '录入诊断时必须录入血压值',  align: 'center', sortable: true,
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
					{ field: 'INCHighMaterialTrack', title: '高值材料跟踪',  align: 'center', sortable: true,
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
					{ field: 'OnlyThisDepStop', title: '医嘱只能本科室停止',  align: 'center', sortable: true,
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
					{ field: 'IsChinaMed', title: '中医科室',  align: 'center', sortable: true,
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
					{ field: 'NotAutoChangeRecloc', title: '药品库存不足时不自动切换药房 ',  align: 'center', sortable: true,
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
					{ field: 'ForbidDosingInstr', title: '禁用配液用法',  align: 'center', sortable: true,
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
					{ field: 'OpenUseDKB', title: '启用诊断知识库',  align: 'center', sortable: true,
					   editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                       }
					}*/,
					{ field: 'NotDisplayNoPayOrd', title: '医嘱录入界面不显示未交费医嘱(仅门诊)',  align: 'center', sortable: true,
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
					},{ field: 'NotAllowAdmissionsIFNoCall', title: '不呼叫禁止医生正常接诊(仅门诊)',  align: 'center', sortable: true,
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
					},{ field: 'OutPriorAllowPoisonDrug', title: '出院带药允许开精神毒麻类药品',  align: 'center', sortable: true,
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
					},{ field: 'DiagFromTempOrHisAutoSave', title: '诊断通过模板/历史录入自动保存', width: 220,
						editor:{
					        type:'combobox',
					        options:{
						      editable:true,
						      valueField:'code',
						      textField:'desc',
							  required:false,
						      data:[{"code":"Y","desc":"是"},{"code":"N","desc":"否"}],
						      onSelect:function(rec){
						        var rows=LocExtDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.DiagFromTempOrHisAutoSave=rec.code;
						      },
						      onChange:function(newValue, oldValue){
							      if (newValue==""){
								      var rows=LocExtDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                	  rows.DiagFromTempOrHisAutoSave="";
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
					},
					{ field: 'ModifyDateTimeAuthority', title: '修改开医嘱日期时间权限',  align: 'center', sortable: true,
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
					{ field: 'ModifyDateTimeUpHour', title: '开医嘱日期可提前小时数',  align: 'center', sortable: true,
					   editor : {
                                type : 'numberbox'
                       }
					}
    			 ]];
	LocExtDataGrid=$('#tabLocExtConfig').datagrid({  
		fit : true,
		width : 'auto', //
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"LocRowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :LocExtColumns,
		toolbar :LocExtToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			LocExtDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
			LocRowID=rowData.LocRowID
		}
	});
	LoadLocExtDataGrid();
};
function LoadLocExtDataGrid()
{
	var LocId=$("#Combo_Loc").combobox("getValue");
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.LocExt",
	    QueryName : "GetLocExtConfig",
	    LocId:LocId,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:LocExtDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		editRow = undefined;
		LocExtDataGrid.datagrid('unselectAll');
		LocExtDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
};
function InitComboLoc()
{
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.LocExt",
	    QueryName : "GetLocExtConfigNew",
	    LocId:"",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(GridData){
		$("#Combo_Loc").combobox({   
			valueField:'LocRowID',   
    		textField:'LocDesc',
    		data:GridData['rows'],
    		filter: function(q, row){
				if (q=="") return true;
				if (row["LocDesc"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["LocAlias"].split("^").length;i++){
					if ((row["LocAlias"].split("^")[i].toUpperCase()).indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			}
		})
	});
};
function Save(){
	if(LocRowID==""){
		  return false;
	  }
	  var rows = LocExtDataGrid.datagrid("getRows"); 
	  var RecLocByLogonLoc=0;
	  var NoReferral=0;
	  var NotPackQty=0;
	  var ARCOSInputByLogonLoc=0;
	  var NotNeedInstrArcim=0;
	  var AddDocByNotPriceOEItem=0;
	  var ModifySttDateTimeAuthority=0;
	  var StopOrderDiscExec=0;
	  var DocAppIntervalTime=0;
	  var LocCAVerify=0;
	  var BloodPressureByEntryDiagnosis=0;
	  var INCHighMaterialTrack=0;
	  var OnlyThisDepStop=0;
	  var AllowCostInputReg=0;
	  var IsChinaMed=0;
	  var NotAutoChangeRecloc=0;
	  var ForbidDosingInstr=0;
	  var OpenUseDKB=0;
	  var NotDisplayNoPayOrd=0;
	  var NotAllowAdmissionsIFNoCall=0;
	  var OutPriorAllowPoisonDrug=0;
	  var ModifyDateTimeAuthority=0;
	    //选择要删除的行  
	   if (rows.length > 0)
	   { 	
	     for (var i = 0; i < rows.length; i++) {
			if(editRow==i){
				 var rows=LocExtDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
				var editors = LocExtDataGrid.datagrid('getEditors', editRow); 
				var selected=editors[0].target.is(':checked');
				if(selected) RecLocByLogonLoc="1";
				var selected=editors[1].target.is(':checked');
				if(selected) NoReferral="1";
				var selected=editors[2].target.is(':checked');
				if(selected) NotPackQty="1";
				//var selected=editors[3].target.is(':checked');
				//if(selected) ARCOSInputByLogonLoc="1";
				var selected=editors[3].target.is(':checked');
				if(selected) NotNeedInstrArcim="1";
				//var selected=editors[5].target.is(':checked');
				//if(selected) AddDocByNotPriceOEItem="1";
				var selected=editors[4].target.is(':checked');
				if(selected) ModifySttDateTimeAuthority="1";
				//var selected=editors[7].target.is(':checked');
				//if(selected) StopOrderDiscExec="1";
				//var DocAppIntervalTime=editors[8].target.val()//editors[8].target.is(':checked');
				//if(selected) DocAppIntervalTime="1";
				/*if (isNaN(Number(DocAppIntervalTime))==true){
				  alert("医生预约间隔分钟应填写数字");
				  return false;
			    }*/
			    var ModifySttDateTimeUpHour=editors[5].target.numberbox('getValue');
			    if (isNaN(Number(ModifySttDateTimeUpHour))==true){
				  $.messager.alert("提示","医嘱开始日期可提前小时数应填写数字!");
				  return false;
			    }
				var selected=editors[6].target.is(':checked');
				if(selected) LocCAVerify="1";
				var selected=editors[7].target.is(':checked');
				if(selected) BloodPressureByEntryDiagnosis="1";
				var selected=editors[8].target.is(':checked');
				if(selected) INCHighMaterialTrack="1";
				var selected=editors[9].target.is(':checked');
				if(selected) OnlyThisDepStop="1";
				//var selected=editors[13].target.is(':checked');
				//if(selected) AllowCostInputReg="1";
				var selected=editors[10].target.is(':checked');
				if(selected) IsChinaMed="1";
				var selected=editors[11].target.is(':checked');
				if(selected) NotAutoChangeRecloc="1";
				var selected=editors[12].target.is(':checked');
				if(selected) ForbidDosingInstr="1";
				//var selected=editors[12].target.is(':checked');
				//if(selected) OpenUseDKB="1";
				var selected=editors[13].target.is(':checked');
				if(selected) NotDisplayNoPayOrd="1";
				var selected=editors[14].target.is(':checked');
				if(selected) NotAllowAdmissionsIFNoCall="1";
				var selected=editors[15].target.is(':checked');
				if(selected) OutPriorAllowPoisonDrug="1";
				var DiagFromTempOrHisAutoSave=rows['DiagFromTempOrHisAutoSave'];
				var selected=editors[17].target.is(':checked');
				if(selected) ModifyDateTimeAuthority="1";
			    var ModifyDateTimeUpHour=editors[18].target.numberbox('getValue');
			    if (isNaN(Number(ModifyDateTimeUpHour))==true){
				  $.messager.alert("提示","开医嘱日期可提前小时数应填写数字!");
				  return false;
			    }
			}
	     } 
		  var DHCFieldNumStr="1^3^4^5^6^7^9^8^10^11^12^13^14^15^16^17^18^19^20^21^22^23^24^25^26";
		  var ValStr=RecLocByLogonLoc+"^"+NoReferral+"^"+NotPackQty+"^"+ARCOSInputByLogonLoc+"^"+NotNeedInstrArcim+"^"+AddDocByNotPriceOEItem+"^"+ModifySttDateTimeAuthority+"^"+StopOrderDiscExec+"^"+DocAppIntervalTime+"^"+LocCAVerify+"^"+BloodPressureByEntryDiagnosis+"^"+INCHighMaterialTrack+"^"+OnlyThisDepStop+"^"+AllowCostInputReg+"^"+IsChinaMed+"^"+NotAutoChangeRecloc+"^"+ForbidDosingInstr+"^"+OpenUseDKB+"^"+NotDisplayNoPayOrd+"^"+ModifySttDateTimeUpHour;
		   	  ValStr=ValStr+"^"+NotAllowAdmissionsIFNoCall+"^"+OutPriorAllowPoisonDrug+"^"+DiagFromTempOrHisAutoSave;
		   	  ValStr=ValStr+"^"+ModifyDateTimeAuthority+"^"+ModifyDateTimeUpHour
		  
	      $.m({
			 ClassName:"DHCDoc.DHCDocConfig.LocExt",
			 MethodName:"SetDHCCTLOCFieldValue",
			 Rowid:LocRowID, DHCFieldNumStr:DHCFieldNumStr, ValStr:ValStr
		  },function(value){
				if(value=="0"){
					LocExtDataGrid.datagrid("endEdit", editRow);
	    			LoadLocExtDataGrid();
					$.messager.show({title:"提示",msg:"保存成功"});
				}else{
					$.messager.alert('提示',"保存失败:"+value);
					return false;
				}
		  });
	 }
}