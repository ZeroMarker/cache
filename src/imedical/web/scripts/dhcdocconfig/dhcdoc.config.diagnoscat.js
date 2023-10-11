var DiagnosCatDataGrid;
var DiagnosCatDetailDataGrid;
var DiagnosCatItemDataGrid;
var editRow=undefined;
var editRow2=undefined;
var editRow3=undefined;
var dialog,dialog1;
var PAADMTypeStr=[{"code":"I","desc":"InPatient"},{"code":"O","desc":"OutPatient"},{"code":"E","desc":"Emergency"}];
var DCTypeStr=[{"code":"S","desc":"特殊病"},{"code":"M","desc":"慢性病"},{"code":"C","desc":"押金"}];
$(function(){
	InitHospList();
	InitCache();
	InitMRCIDLookup();
	InitARCIDLookup();
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_DiagnosCat");
	hospComp.jdata.options.onSelect = function(e,t){
		InitDiagnosCatGrid();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitDiagnosCatGrid();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitDiagnosCatGrid(){
	var DiagnosCatBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
	            editRow = undefined;
                DiagnosCatDataGrid.datagrid("rejectChanges");
                DiagnosCatDataGrid.datagrid("unselectAll");
                if (editRow != undefined) {
                    DiagnosCatDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
                    DiagnosCatDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    DiagnosCatDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = DiagnosCatDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DCRowid);
                            }
                            var DCRowid=ids.join(',');
                            if (DCRowid==""){
	                            editRow = undefined;
				                DiagnosCatDataGrid.datagrid("rejectChanges");
				                DiagnosCatDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
								MethodName:"delete",
							   	Rowid:DCRowid,
							},false)
							if(value=="0"){
								DiagnosCatDataGrid.datagrid('load');
	           					DiagnosCatDataGrid.datagrid('unselectAll');
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
					var rows=DiagnosCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");  
					//var rows = DiagnosCatDataGrid.datagrid("getSelected");  					
                	var editors = DiagnosCatDataGrid.datagrid('getEditors', editRow);  				
					var Code =  editors[0].target.val();
					var Desc =  editors[1].target.val();
					if (Code==""){
						$.messager.alert('提示',"请输入代码!");
						return false;
					}
					if(Desc==""){
						$.messager.alert('提示',"请输入名称!");
						return false;
					}
					var PAADMType =  editors[2].target.combobox('getValue');
					if(PAADMType==""){
						$.messager.alert('提示',"请选择诊别!");
						return false;
					}
	                var BillType=editors[3].target.combobox('getValue');
					if(BillType==""){
						$.messager.alert('提示',"请选择费别!");
						return false;
					}
					var Dur=editors[4].target.combobox('getValue');
					if(Dur==""){
						$.messager.alert('提示',"请选择疗程!");
						return false;
					}
					var DiagnosType=editors[5].target.combobox('getValue');
					if(DiagnosType==""){
						$.messager.alert('提示',"请选择病种类型!");
						return false;
					}
			        
					var Str=Code+"!"+Desc+"!"+PAADMType+"!"+BillType+"!"+Dur+"!"+DiagnosType;
					//此处CS版有判断记录是否重复，但判断没有作用，BS是否也要做控制
					// DHC_DiagnosCat 的DC_Type 只有状态 C S 没有M，此处要在表DHC_DiagnosCat增加M
					if(rows.DCRowid){
						var value=$.m({
							ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
							MethodName:"update",
						   	Rowid:rows.DCRowid,
						   	str:Str
						},false)
						if(value=="0"){
							DiagnosCatDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							DiagnosCatDataGrid.datagrid('unselectAll').datagrid('load');
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
					}else{
						var value=$.m({
							ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
							MethodName:"insert",
						   	str:Str,
						   	HospId:$HUI.combogrid('#_HospList').getValue()
						},false)
						if(value=="0"){
							DiagnosCatDataGrid.datagrid("endEdit", editRow);
                			editRow = undefined;
							DiagnosCatDataGrid.datagrid('unselectAll').datagrid('load');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if (value=="-1"){
								$.messager.alert('提示',"保存失败,请选择有效费别!");
							}else if(value=="-2"){
								$.messager.alert('提示',"保存失败,请选择有效疗程!");
							}else{
								$.messager.alert('提示',"保存失败:"+value);
							}
							return false;
						}
					}
			}
		  }             
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow = undefined;
                DiagnosCatDataGrid.datagrid("rejectChanges");
                DiagnosCatDataGrid.datagrid("unselectAll");
            }
        },
        '-', {
            text: '诊断明细',
            iconCls: 'icon-edit',
            handler: function() {
	            var rows = DiagnosCatDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
	                 if (!rows[0].DCRowid) return;
	                $("#DiagnosCatDetail-form").css("display", ""); 
				  dialog = $( "#DiagnosCatDetail-form" ).dialog({
				    autoOpen: false,
				    height: 500,
				    width: 500,
				    modal: true
				  });
				  dialog.dialog( "open" );
				  InitDiagnosCatDetail();
	            }else{
		            $.messager.alert("提示", "请选择行");
		        }
               
            }
        },
        '-', {
            text: '医嘱明细',
            iconCls: 'icon-edit',
            handler: function() {
	           var rows = DiagnosCatDataGrid.datagrid("getSelections");
               if (rows.length > 0) {
	               if (!rows[0].DCRowid) return;
	                $("#DiagnosCatItem-form").css("display", ""); 
					dialog1 = $( "#DiagnosCatItem-form" ).dialog({
					  autoOpen: false,
					  height: 500,
					  width: 700,
					  modal: true
					});
					dialog1.dialog( "open" );
					InitDiagnosCatItem();
			   }else{
		            $.messager.alert("提示", "请选择行");
		       }
            }
        }];
    var DiagnosCatColumns=[[    
	                { field : 'DCRowid',title : '',width : 1,hidden:true  
                    },
        			{ field: 'DCCode', title: '代码', width: 50,
        			  editor : {
                        type : 'text'
					  }
        			},
					{ field : 'DCDesc',title : '名称',width : 100 , 
                        editor : {
                        type : 'text',
						options:{
							required:true
						}
					  }
                    },
                    {
                      field : 'DCPAADMType',title : '诊别',width : 50,
                        editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:true,
						      data:PAADMTypeStr
					        }
				         },
						  formatter:function(value, record){
							  return record.PAADMType;
						  }		
                     },
					{ field: 'PAADMType', title: '', width: 100,hidden:true 	
					},
                    { field: 'DCBillType', title: '费别', width: 100,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'BillTypeRowid',
								textField:'BillTypeDesc',
								required:true,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						  formatter:function(value,record){
							  return record.BillType;
						  }
					},
					{ field: 'BillType', title: '', width: 100,hidden:true
					},
					{ field: 'DCDuration', title: '限定疗程', width: 100,
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
						  formatter:function(value,record){
							  return record.Duration;
						  }
					},	
                    { field: 'Duration', title: '', width: 100,hidden:true
					},
                    { field: 'DCType', title: '病种类型', width: 100,
					  editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:true,
						      data:DCTypeStr
					        }
				         },
						  formatter:function(value, record){
							  return record.Type;
						 }
					},
                    { field: 'Type', title: '', width: 100,hidden:true
					}					
    			 ]];
	DiagnosCatDataGrid=$("#tabDiagnosCat").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL+"?ClassName=DHCDoc.DHCDocConfig.DiagnosCat&QueryName=GetDiagnosCat&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCRowid",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DiagnosCatColumns,
    	toolbar :DiagnosCatBar,
		onDblClickRow:function(rowIndex, rowData){
			if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			DiagnosCatDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
			
		},
		onBeforeLoad:function(){
			editRow = undefined;
			if (DiagnosCatDataGrid)  DiagnosCatDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
		}
	});
}
function InitDiagnosCatDetail()
{
	$("#MRCIDLookup").lookup("setValue",'').lookup('setText','');
	var DiagnosCatDetailToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	 editRow2 = undefined;
                DiagnosCatDetailDataGrid.datagrid("rejectChanges");
                DiagnosCatDetailDataGrid.datagrid("unselectAll");
                if (editRow2 != undefined) {
                    return;
                }else{
                    DiagnosCatDetailDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    DiagnosCatDetailDataGrid.datagrid("beginEdit", 0);
                    editRow2 = 0;
                }
              
            }
        }, {
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = DiagnosCatDetailDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DiagnosCatDetailID);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow2 = undefined;
				                DiagnosCatDetailDataGrid.datagrid("rejectChanges");
				                DiagnosCatDetailDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
								MethodName:"deleteDetail",
							   	Rowid:ID
							},false)
					        if(value=="0"){
						       DiagnosCatDetailDataGrid.datagrid('load');
       					       DiagnosCatDetailDataGrid.datagrid('unselectAll');
       					       $.messager.popover({msg: '删除成功!',type:'success'});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow2 = undefined;
                DiagnosCatDetailDataGrid.datagrid("rejectChanges");
                DiagnosCatDetailDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  var rows = DiagnosCatDataGrid.datagrid("getSelected");
			  //var rows=DiagnosCatDetailDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
			  if(rows.DCRowid){
				  var DCRowid=rows.DCRowid
			  }else{
				  var DCRowid=""
			  }
			  //alert(rows.DCRowid)
			  if (editRow2 != undefined) {
				  var editors = DiagnosCatDetailDataGrid.datagrid('getEditors', editRow2);
				 // var ICDDr = editors[0].target.combogrid('getValue'); 
				 var rows1=DiagnosCatDetailDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
				 var ICDDr =rows1.DCDDiagnosDR
				  if ((ICDDr=="")||(ICDDr==undefined)){
					  $.messager.alert('提示',"诊断不能为空");
					  return false;
				  }
				  var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
					MethodName:"insertDetail",
				   	CatRowid:DCRowid,
				   	ICDDr:ICDDr
				},false)
				if(value==0){
				   DiagnosCatDetailDataGrid.datagrid('load');
				   DiagnosCatDetailDataGrid.datagrid('unselectAll');
				   editRow2 = undefined;
				   $.messager.popover({msg: '保存成功!',type:'success'});
				}else if(value=="-1"){
					 $.messager.alert('提示',"记录重复");
				}else{
				   $.messager.alert('提示',"保存失败:"+value);
				}
			  }
			}
		}];
	DiagnosCatDetailColumns=[[    
                    { field: 'DiagnosCatDetailID', title: 'ID', width: 1,hidden:true
					}, 
					{ field: 'DCDDiagnosDR', title:'诊断', width: 150,hidden:true	
					}, 
					{ field: 'MRCIDDesc', title:'诊断名称', width: 150,
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
								var rows=DiagnosCatDetailDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
                                if(rows)rows.DCDDiagnosDR=rowData.MRCIDRowId
		                     },
							onBeforeLoad:function(param){
								if (param['q']) {
									var desc=param['q'];
								}
								param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
							}
                        }
                     }
					}, 
					{ field: 'MRCIDCode', title:'代码', width: 50
					}
					
    			 ]];
	DiagnosCatDetailDataGrid=$('#tabDiagnosCatDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : $URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DiagnosCatDetailID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DiagnosCatDetailColumns,
		toolbar:DiagnosCatDetailToolBar,
		onBeforeLoad:function(param){
		   editRow2 = undefined;
		   var MRCIDLookup = $("#MRCIDLookup").lookup("getValue");
		   if (typeof MRCIDLookup == "undefined"){
		       MRCIDLookup = "";
		   }
		   //$("#ItemSelList").datagrid("load",{"params":arRepID});
		   if (DiagnosCatDetailDataGrid)  DiagnosCatDetailDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
	       var DCRowid="";
	       var rows = DiagnosCatDataGrid.datagrid("getSelected"); 
	       if(rows) DCRowid=rows.DCRowid
	       if(DCRowid=="") return 
	       param.ClassName ='DHCDoc.DHCDocConfig.DiagnosCat';
	       param.QueryName ='GetDiagnosCatDetail';
	       param.DCRowid =DCRowid;
	       param.MRCRowid =MRCIDLookup;		
	       //param.ArgCnt =1;
	   }
	});
	
};
function InitARCIDLookup(){
	$("#ARCIDLookup").lookup({
		panelWidth:450,
		panelHeight:350,
		url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimRowID',
	    textField:'ArcimDesc',
        columns:[[  
       		{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
        ]],
        pagination:true,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.ArcItemConfig',QueryName: 'FindAllItem'},
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}else{
				//return false;
			}
			param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    },onSelect:function(ind,item){
		    $('#tabDiagnosCatItem').datagrid("load",{param:""});
		} 
    }).change(function(){
		if($(this).val()==''){
			$("#ARCIDLookup").lookup("setValue",'');
			$('#tabDiagnosCatItem').datagrid("load",{param:""});
		}
	});
}
function InitMRCIDLookup(){
	$("#MRCIDLookup").lookup({
		panelWidth:450,
		panelHeight:350,
		url:$URL,
        mode:'remote',
        method:"Get",
        idField:'MRCIDRowId',
	    textField:'MRCIDDesc',
        columns:[[  
       		{field:'MRCIDDesc',title:'名称',width:350},
	         {field:'MRCIDRowId',title:'ID',width:50}
        ]],
        pagination:true,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.CNMedCode',QueryName: 'FindDiagnoseList'},
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{desc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    },onSelect:function(ind,item){
		    $('#tabDiagnosCatDetail').datagrid("load",{param:""});
		}
    }).change(function(){
		if($(this).val()==''){
			$("#MRCIDLookup").lookup("setValue",'');
			$('#tabDiagnosCatDetail').datagrid("load",{param:""});
		}
	});
}
function InitDiagnosCatItem()
{
	$('#ARCIDLookup').lookup('setValue','').lookup('setText','');
	var DiagnosCatItemToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                editRow3 = undefined;
                DiagnosCatItemDataGrid.datagrid("rejectChanges");
                DiagnosCatItemDataGrid.datagrid("unselectAll");

                if (editRow3 != undefined) {
                    return;
                }else{
                    DiagnosCatItemDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    DiagnosCatItemDataGrid.datagrid("beginEdit", 0);
                    editRow3 = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = DiagnosCatItemDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DiagnosCatItemID);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow3 = undefined;
				                DiagnosCatItemDataGrid.datagrid("rejectChanges");
				                DiagnosCatItemDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
								MethodName:"deleteItem",
							   	Rowid:ID
							},false)
					        if(value=="0"){
						       DiagnosCatItemDataGrid.datagrid('load');
       					       DiagnosCatItemDataGrid.datagrid('unselectAll');
       					       $.messager.popover({msg: '删除成功!',type:'success'});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
					        }
					        editRow3 = undefined;
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
                editRow3 = undefined;
                DiagnosCatItemDataGrid.datagrid("rejectChanges");
                DiagnosCatItemDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  //var rows = DiagnosCatItemDataGrid.datagrid("getSelected");
			  if (editRow3 != undefined) {
				  var rows=DiagnosCatItemDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected");
				  var editors = DiagnosCatItemDataGrid.datagrid('getEditors', editRow3);
				  var ARCIMDr = rows.DCIARCIMDR //editors[0].target.combobox('getValue'); 
				  var Dur=editors[1].target.combobox('getValue'); 
				  if (!Dur) Dur="";
				  var YearMaxQty="" //editors[2].target.val();
				  var MonthMaxQty="" //editors[3].target.val();
				  if ((ARCIMDr=="")||(ARCIMDr==undefined)){
					  $.messager.alert('提示',"医嘱不能为空!");
					  return false;
				  }
				  var str=ARCIMDr+","+Dur+","+YearMaxQty+","+MonthMaxQty;
				  //return false;
				  if(rows.DiagnosCatItemID){
					  var value=$.m({
							ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
							MethodName:"updateItem",
						   	Rowid:rows.DiagnosCatItemID,
						   	str:str
						},false)
						if(value==0){
							DiagnosCatItemDataGrid.datagrid("endEdit", editRow3);
						   DiagnosCatItemDataGrid.datagrid('load');
						   DiagnosCatItemDataGrid.datagrid('unselectAll');
						   $.messager.popover({msg: '保存成功！',type:'success'});
						}else{
						   $.messager.alert('提示',"保存失败:"+value);
						   return;
						}
						editRow3 = undefined;
				  }else{
					  var rows1 = DiagnosCatDataGrid.datagrid("getSelected");
					  var value=$.m({
							ClassName:"DHCDoc.DHCDocConfig.DiagnosCat",
							MethodName:"insertItem",
						   	CatRowid:rows1.DCRowid,
						   	str:str
						},false)
						if(value==0){
						   DiagnosCatItemDataGrid.datagrid('load');
						   DiagnosCatItemDataGrid.datagrid('unselectAll');
						   $.messager.popover({msg: '保存成功!',type:'success'});
						}else{
						   $.messager.alert('提示',"保存失败:"+value);
						   return;
						}
						editRow3 = undefined;
				  }
			  }
			}
		}];
	DiagnosCatItemColumns=[[    
                    { field: 'DiagnosCatItemID', title: 'ID', width: 1,hidden:true}, 
					{ field: 'DCIARCIMDR', title: '名称', width: 150,resizable: true,hidden:true},
					{ field: 'ARCIMDesc', title:'名称', width: 150,
					   editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:290,
									 delay: 500,  
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
										var rows=DiagnosCatItemDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected");
                                        if(rows)rows.DCIARCIMDR=rowData.ArcimRowID
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
					{ field: 'DCIDurationDR', title:'限定疗程', width: 50,resizable: true,
						  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value=&Type=XY",
								valueField:'DurRowId',
								textField:'DurCode',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						  formatter:function(value, record){
							  return record.PHCDUDesc;
						  }
					},					
					{ field: 'PHCDUDesc', title:'限定疗程', width: 50,hidden:true
					  
					}, 
					{ field: 'DCIYearMaxQty', title:'年最大量', width: 50,hidden:true
					  //editor : {type : 'text',options : {}}
					}, 
					{ field: 'DCIMonthMaxQty', title:'月最大量', width: 50,hidden:true
					  //editor : {type : 'text',options : {}}
					}
					
    			 ]];
	DiagnosCatItemDataGrid=$('#tabDiagnosCatItem').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DiagnosCatItemID",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DiagnosCatItemColumns,
		toolbar:DiagnosCatItemToolBar,
		onClickRow:function(rowIndex, rowData){
			if (editRow3 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			DiagnosCatItemDataGrid.datagrid("beginEdit", rowIndex);
			editRow3=rowIndex
		}
		,onBeforeLoad:function(param){
			editRow3 = undefined;
		   if (DiagnosCatItemDataGrid)  DiagnosCatItemDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
	       var DCRowid="";
	       var ARCIDLookup = $("#ARCIDLookup").lookup("getValue");
		   if (typeof ARCIDLookup == "undefined"){
		       ARCIDLookup = "";
		   }
	       var rows = DiagnosCatDataGrid.datagrid("getSelected"); 
		   if(rows) DCRowid=rows.DCRowid
	       if(DCRowid=="") return 
	       param.ClassName ='DHCDoc.DHCDocConfig.DiagnosCat';
	       param.QueryName ='GetDiagnosCatItem';
	       param.DCRowid =DCRowid;	
	       param.ARCIMRowid=ARCIDLookup;
	       //param.ArgCnt =1;
	   }
	});
}