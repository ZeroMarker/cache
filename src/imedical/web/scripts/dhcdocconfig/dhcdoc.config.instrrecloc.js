var editRow = undefined;
var instrDataGrid;
var InstrRecLocDataGrid;
$(function(){
	InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_InstrRecloc");
	hospComp.jdata.options.onSelect = function(e,t){
		loadInstrDataGrid("");
		loadInstrRecLocDataGrid("");
		InitCheck();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitInstr();
	InitInstrRecLoc();
	InitCheck();
}
function InitCheck(){
	$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"GetConfigNode",
		Node:"ReclocByInstr",
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(value){
		if(value==1) $("#Check_ReclocByInstr").checkbox('check');
		else  $("#Check_ReclocByInstr").checkbox('uncheck');
	});
	$("#Check_ReclocByInstr").checkbox({
		onCheckChange:function(e,value){
			var CheckedValue=value?1:0;
			var value=$.m({ 
				ClassName:"web.DHCDocConfig", 
				MethodName:"SaveConfig2",
				Node:"ReclocByInstr",
				NodeValue:CheckedValue,
				HospId:$HUI.combogrid('#_HospList').getValue()
			},false);
		}
	});
}
function InitInstrRecLoc(){
	var InstrRecLocBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow != undefined) {
                    //InstrRecLocDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                editRow = 0;
                    InstrRecLocDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {
							InstrRecLocRowid:"",
							OrdDepDr:"",
							RecLocDr:"",
							HospitalRowid:"",
							OrdPrior:"",
							OrdSubCat:""
						}
                    });
                    InstrRecLocDataGrid.datagrid("beginEdit", 0);
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = InstrRecLocDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrRecLocRowid);
                            }
                            var InstrRecLocRowid=ids.join(',');
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.InstrRecloc", 
								MethodName:"Delete",
								InstrRecLocRowid:InstrRecLocRowid
							},false);
							if(value=="0"){
								InstrRecLocDataGrid.datagrid('load');
								InstrRecLocDataGrid.datagrid('unselectAll');
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
					return false;
                }
	         
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
              var rows = instrDataGrid.datagrid("getSelections");
                //选择要删除的行  
               if (rows.length > 0)
               { 
       				var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].InstrRowID);
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                    //console.info(ids);
                    var InstrRowId=ids.join(',')
                if (editRow != undefined)
                {
	                var rows = InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                var InstrRecLocRowid=rows["InstrRecLocRowid"];
	                if (!InstrRecLocRowid) InstrRecLocRowid="";
                	var editors = InstrRecLocDataGrid.datagrid('getEditors', editRow);
					var OrdDep = rows.OrdDepDr; //editors[0].target.combobox('getValue');
					if(!OrdDep){
						OrdDep="";
						//$.messager.alert('提示',"请选择病人所在科室!");
						//return false;
					}
					var RecLoc =  rows.RecLocDr; //editors[1].target.combobox('getValue');
					if(!RecLoc){
						$.messager.alert('提示',"请选择接收科室!");
						return false;
					}
					var Default =  editors[2].target.is(':checked');
					if (Default) Default=1;
					else Default=0;
	                var OrdCat=rows.OrdSubCat; //editors[3].target.combobox('getValue');
	                if (!OrdCat) OrdCat="";
					var PriorDr=rows.OrdPrior; //editors[4].target.combobox('getValue');
					if (!PriorDr) PriorDr="";
					var OrdTimeStart=editors[5].target.val();
					var time=/^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/ 
			        if ((time.test(OrdTimeStart) != true)&&(OrdTimeStart!="")) {
		             $.messager.alert("提示", "开始时间格式不正确,正确格式为:12:00:00", "error");
				     return false;
				    }
					var OrdTimeEnd=editors[6].target.val();
			        if ((time.test(OrdTimeEnd) != true)&&(OrdTimeEnd!="")) {
		              $.messager.alert("提示", "结束时间格式不正确,正确格式为:12:00:00", "error");
				      return false;
				    }
					var TimeRange=OrdTimeStart+"~"+OrdTimeEnd;
					var Hos=$HUI.combogrid('#_HospList').getValue(); //editors[7].target.combobox('getValue');
					if (!Hos) Hos="";
					var RecLocStr=OrdDep+"!"+RecLoc+"!"+Default+"!"+OrdCat+"!"+PriorDr+"!"+TimeRange+"!"+Hos+"!"+InstrRecLocRowid;
					var value=$.m({ 
						ClassName:"DHCDoc.DHCDocConfig.InstrRecloc", 
						MethodName:"Save",
						InstrRowId:InstrRowId,
						RecLocStr:RecLocStr
					},false);
					if(value=="0"){
						InstrRecLocDataGrid.datagrid("endEdit", editRow);
            			editRow = undefined;
						InstrRecLocDataGrid.datagrid('load');
       					InstrRecLocDataGrid.datagrid('unselectAll');
						$.messager.show({title:"提示",msg:"保存成功"});        					
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}
					editRow = undefined;
            	}
            
             }else{
	            $.messager.alert("提示", "请选择一个要维护的用法"); 
	         }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                InstrRecLocDataGrid.datagrid("rejectChanges");
                InstrRecLocDataGrid.datagrid("unselectAll");
            }
        }];
    var InstrRecLocColumns=[[    
	                { field : 'InstrRecLocRowid',title : '',width : 1,hidden:true  
                    },
                    { field: 'OrdDepDr', title: '', width: 100,hidden:true},
        			{ field: 'OrdDep', title: '患者所在科室', width: 120,
        			  editor :{  
							type:'combobox',  
							options:{
								mode:"remote",
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrRecloc&QueryName=GetOrdDep&desc=rows=99999",
								valueField:'CTLOCRowID',
								textField:'CTLOCDesc',
								//required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onBeforeLoad:function(param){
						            if (param['q']) {
										var desc=param['q'];
									}else{
										var desc="";
									}
									param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								},
								onSelect:function(rec){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.OrdDepDr=rec.CTLOCRowID;
								},
								onChange:function(newValue, oldValue){
									if (!newValue){
										var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.OrdDepDr="";
									}
								},
								onHidePanel:function(){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.OrdDepDr=$(this).combobox('getValue');
								}
							  }
     					  }
        			},
					{ field : 'RecLoc',title : '接收科室',width : 100 , align: 'center', sortable: true, resizable: true, 
                        editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.DocConfig&QueryName=FindDep&value=",
								valueField:'CTLOCRowID',
								textField:'CTLOCDesc',
								required:true,
								loadFilter: function(data){
									return data['rows'];
								},
								onSelect:function(rec){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.RecLocDr=rec.CTLOCRowID;
								},
								onChange:function(newValue, oldValue){
									if (!newValue){
										var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.RecLocDr="";
									}
								},
								onHidePanel:function(){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.RecLocDr=$(this).combobox('getValue');
								}
							  }
     					  }				
                    },
                    {
                      field : 'Default',title : '默认',width : 50,
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
                     },
					{ field: 'OrdSubCat', title: '', width: 100,hidden:true},
					{ field: 'OrdSubCatDesc', title: '医嘱子类', width: 100, align: 'center',
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindCatList&value=",
								valueField:'ARCICRowId',
								textField:'ARCICDesc',
								required:false,
								onBeforeLoad:function(param){
									param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
								},
								loadFilter: function(data){
									return data['rows'];
								},
								onSelect:function(rec){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.OrdSubCat=rec.ARCICRowId;
								},
								onChange:function(newValue, oldValue){
									if (!newValue){
										var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.OrdSubCat="";
									}
								},
								onHidePanel:function(){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.OrdSubCat=$(this).combobox('getValue');
								}
							  }
     					  }
					},
                    { field: 'OrdPrior', title: '', width: 100, align: 'center',hidden:true},
					{ field: 'OrdPriorDesc', title: '医嘱类型', width: 100, align: 'center',
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.HolidaysRecLoc&QueryName=FindPriorByLoc&LocID=&value=&Type=InstrLoc",
								valueField:'OECPRRowId',
								textField:'OECPRDesc',
								required:false,
								loadFilter: function(data){
									return data['rows'];
								},
								onSelect:function(rec){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.OrdPrior=rec.OECPRRowId;
								},
								onChange:function(newValue, oldValue){
									if (newValue==""){
										var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.OrdPrior="";
									}
								},
								onHidePanel:function(){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.OrdPrior=$(this).combobox('getValue');
								}
							  }
     					  }
					},
					{ field: 'OrdTimeRangeFrom', title: '医嘱开始时间', width: 100, align: 'center', sortable: true,
					  editor : {
                        type : 'text',
                        options : {

                       }
					  }
					},
					{ field: 'OrdTimeRangeTo', title: '医嘱结束时间', width: 100, align: 'center', sortable: true, resizable: true,
					  editor : {
                        type : 'text',
                        options : {

                       }
					  }
					},	
                    { field: 'HospitalDesc', title: '医院', width: 100, align: 'center', sortable: true, resizable: true/*,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrRecloc&QueryName=GetCTHospital",
								valueField:'HOSPRowId',
								textField:'HOSPDesc',
								required:false,
								loadFilter: function(data){
									return data['rows'];
								},
								onSelect:function(rec){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                rows.HospitalRowid=rec.HOSPRowId;
								},
								onChange:function(newValue, oldValue){
									if (!newValue){
										var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                                    rows.HospitalRowid="";
									}
								},
								onHidePanel:function(){
									var rows=InstrRecLocDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
									if (!$.isNumeric($(this).combobox('getValue'))) return;
									rows.HospitalRowid=$(this).combobox('getValue');
								}
							  }
     					  }*/
					}					
    			 ]];
	InstrRecLocDataGrid=$("#tabInstrRecLocList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrRecloc&QueryName=GetInstrLinkRecLoc&InstrRowId=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrRecLocRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :InstrRecLocColumns,
    	toolbar :InstrRecLocBar,
    	onLoadSuccess:function(data){
	    	editRow = undefined;
	    },
	    onDblClickRow:function(index, row){
		    if ((editRow!=undefined)&&(editRow!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			editRow=index;
			InstrRecLocDataGrid.datagrid("beginEdit", index);
			var OrdDepObj=InstrRecLocDataGrid.datagrid('getEditor', {index:index,field:'OrdDep'});
			$(OrdDepObj).next('span').find('input').focus();
		}
	});
};
function loadInstrRecLocDataGrid(InstrRowID)
{
	//if(InstrRowID=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrRecloc';
	queryParams.QueryName ='GetInstrLinkRecLoc';
	queryParams.InstrRowId =InstrRowID;	
	queryParams.HospId=$HUI.combogrid('#_HospList').getValue();
	//queryParams.ArgCnt =1;
	var opts = InstrRecLocDataGrid.datagrid("options");
	opts.url = $URL
	InstrRecLocDataGrid.datagrid('load', queryParams);
	editRow2 = undefined;	
}
function InitInstr(){
	///用法列表columns
    instrColumns=[[    
        			{ field: 'InstrDesc', title: '用法名称', width: 100, align: 'center'},
					{ field: 'InstrRowID', title: '用法ID', width: 100, align: 'center',hidden:true}
    			 ]];
     // 用法列表Grid
	instrDataGrid=$('#tabInstrList').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindInstr&InstrAlias="+$('#searchInstrItem').searchbox('getValue'),
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :instrColumns,
		onClickRow:function(rowIndex, rowData){
			instrDataGrid.datagrid('selectRow',rowIndex);
			var selected=instrDataGrid.datagrid('getRows'); 
			var InstrRowID=selected[rowIndex].InstrRowID;
			loadInstrRecLocDataGrid(InstrRowID);
			
			editRow = undefined;
            InstrRecLocDataGrid.datagrid("rejectChanges");
            InstrRecLocDataGrid.datagrid("unselectAll");
		}
	});
};
function searchInstrItem(value,name){
	loadInstrDataGrid(value);
}
function loadInstrDataGrid(value)
{
	instrDataGrid.datagrid('unselectAll');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindInstr';
	queryParams.InstrAlias =value;
	//queryParams.ArgCnt =1;
	var opts = instrDataGrid.datagrid("options");
	opts.url = $URL;
	instrDataGrid.datagrid('reload', queryParams);
}
