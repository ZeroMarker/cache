var PageLogicObj={
	m_MajorCTLocListDataGrid:"",
	m_SelectLookup:false,
	m_MinorCTLocListDataGrid:"",
	editRow:undefined
};

$(document).ready(function(){ 
	 //Init();
	 InitHospList();
	 InitEvent();
});

function InitHospList()
{
	var hospComp = GenHospComp("DHC_CTLocMajor");
	hospComp.jdata.options.onSelect = function(e,t){
		ClearData();
		MajorCTLocListDataGridLoad();
		InitSortType();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitSortType();
	}
}

function Init(){
	PageLogicObj.m_MajorCTLocListDataGrid=InitMajorCTLocListDataGrid();
	MajorCTLocListDataGridLoad();
};

function InitEvent(){
	$('#BClear').click(function() {
		ClearData();	
	})
	$('#SaveMajorCTLocConfig').click(function() {
		SaveConfigClick();	
	})	
	$('#SaveMinorCTLocConfig').click(function() {
		SaveConfigSubClick();	
	})	
	
	$(document.body).bind("keydown",BodykeydownHandler);
}

function InitMajorCTLocListDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteClickHandle();}
    },"-",{
        text: '二级科室维护',
        iconCls: 'icon-batch-cfg',
        handler: function() { MinorLocClickHandle();}
    },"-",{
        text: '一级科室排序',
        iconCls: 'icon-sort',
        handler: function() { SortBtn("User.DHCCTLocMajor");}
    },{
        text: '挂号界面排队方案选择',
        iconCls: 'icon-filter',
        handler: function() {
    		SetDefConfig("MajorCTLocSort","MajorCTLocSort")
			$("#MajorCTLoc-dialog").dialog("open");}
    },"-",{
        text: '二级科室排序',
        iconCls: 'icon-sort',
        handler: function() { SortBtnSub();}
    },{
        text: '挂号界面二级科室排队方案选择',
        iconCls: 'icon-filter',
        handler: function() {
	        var rows = PageLogicObj.m_MajorCTLocListDataGrid.datagrid("getSelections");
			if (rows.length > 0) {
				var ids = [];
				for (var i = 0; i < rows.length; i++) {
					ids.push(rows[i].RowID);
				}
				var MastRowID=ids.join(',')
			}else{
				$.messager.alert('提示',"请选择一级科室记录!","info");
				return false;
			}
			$.q({
				ClassName:"web.DHCCTLocMajor", //web.DHCBL.BDP.BDPSort
				QueryName:"GetDataForCmb1Sub",
				rowid:"",desc:"",
				tableName:"User.DHCCTLocMinor",hospid:"",MasterRowID:MastRowID,
				dataType:"json"
			},function(Data){
				$("#MinorCTLocSort").combobox({
					textField:"SortType",
					valueField:"ID",
					data:Data.rows,
					OnChange:function(newValue,OldValue){
						if (!newValue) {
							$(this).combobox('setValue',"");
						}
					},
					onLoadSuccess:function(){
						SetDefConfig("MinorCTLocSort"+MastRowID,"MinorCTLocSort")
						}
				})
			})
			$("#MinorCTLoc-dialog").dialog("open");
			}
    }];
	var LocColumns=[[ 
		//Code和Desc 原来EXT版本维护反了
		{ field: 'Name', title: '一级科室代码', width: 300, sortable: true},
		{ field: 'Code', title: '一级科室名称', width: 300, sortable: true},
		{ field: 'StartDate', title: '开始日期', width: 300, sortable: true},
		{ field: 'EndDate', title: '截止日期', width: 300, sortable: true},
		{ field: 'HospDesc', title: '院区', width: 300, sortable: true},
		{ field: 'RowID', title: '科室ID', width: 250, sortable: true,hidden:true
		}
	]];
	var MajorCTLocListDataGrid=$('#MajorCTLocListTab').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		remoteSort: false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 20,
		pageList : [20,50,100],
		columns :LocColumns,
		toolbar :toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_MajorCTLocListDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_MajorCTLocListDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_MajorCTLocListDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return MajorCTLocListDataGrid;	
}

function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var GRPLocCode=$('#GRPLocCode').val();
	var GRPLocDesc=$('#GRPLocDesc').val();
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCCTLocMajor",
		MethodName:"InsertMajor",
		Code:GRPLocDesc, 
		Desc:GRPLocCode, 
		StartDate:StartDate, 
		EndDate:EndDate,
		HospId:HospID,
		dataType:"text"
	},function(rtn){
		if (rtn==1){
			$.messager.show({title:"提示",msg:"新增成功"});
			PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll');
			ClearData();
			MajorCTLocListDataGridLoad();
		}else if(rtn=="repeat"){ 
			$.messager.alert("提示","新增失败!一级科室代码或名称重复！","error");
			return false;
		}else{
			$.messager.alert("提示","新增失败!","error");
			return false;
		}
	});	
}

function UpdateClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_MajorCTLocListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要修改的记录!","info");
		return false;
	}
	Rowid=row.RowID;	
	if (!CheckDataValid()) return false;	
	var GRPLocCode=$('#GRPLocCode').val();
	var GRPLocDesc=$('#GRPLocDesc').val();
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	$.cm({
		ClassName:"web.DHCCTLocMajor",
		MethodName:"UpdateMajor",
		ID:Rowid, 
		Code:GRPLocDesc, 
		Desc:GRPLocCode, 
		StartDate:StartDate, 
		EndDate:EndDate, 
		dataType:"text"
	},function(rtn){
		if (rtn==1){
			$.messager.show({title:"提示",msg:"修改成功"});
			PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll');
			ClearData();
			MajorCTLocListDataGridLoad();
		}else if(rtn=="repeat"){ 
			$.messager.alert("提示","修改失败!一级科室代码或名称重复！","error");
			return false;
		}else{
			$.messager.alert("提示","修改失败!","error");
			return false;
		}
	});	
}

function DeleteClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_MajorCTLocListDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.RowID;	
	$.cm({
		ClassName:"web.DHCCTLocMajor",
		MethodName:"DeleteMajorLoc",
		ID:Rowid,
	},function(rtn){
		if (rtn==1){
			$.messager.show({title:"提示",msg:"删除成功"});
			PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll');
			ClearData();
			MajorCTLocListDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!","error");
			return false;
		}
	});		
}

function CheckDataValid(){
	var code=$('#GRPLocCode').val();
	if(code==""){
		$.messager.alert("提示","一级科室代码不能为空","info");
		return false
	}
	
	var code=$('#GRPLocDesc').val();
	if(code==""){
		$.messager.alert("提示","一级科室描述不能为空","info");
		return false
	}	
		
	var StartDate=$HUI.datebox("#StartDate").getValue();
	if (StartDate==""){
		$.messager.alert("提示","缺少有效开始日期","info",function(){$("#StartDate").focus();});
		return false;
	}
	var EndDate=$HUI.datebox("#EndDate").getValue();

	if((StartDate!="")&&(EndDate!="")){
		var Rtn=CompareDate(StartDate,EndDate)
		if (!Rtn){
			$.messager.alert("提示","结束日期不能小于开始日期!","info");
			return Rtn
		}
	}
	
	return true;
}

function SetSelRowData(row){
	var TRowid=row["RowID"];
	if(TRowid=="")return;
	var GRPLocCode=row["Code"]
	var GRPLocDesc=row["Name"];
	var TabStartDate=row["StartDate"];
	var TabEndDate=row["EndDate"];
	//Code和Desc 原来EXT版本维护反了
	$("#GRPLocCode").val(GRPLocDesc);
	$("#GRPLocDesc").val(GRPLocCode);
	$HUI.datebox("#StartDate").setValue(TabStartDate);
	$HUI.datebox("#EndDate").setValue(TabEndDate);
}

function ClearData(){
	$("#GRPLocCode").val("");
	$("#GRPLocDesc").val("");
	$HUI.datebox("#StartDate").setValue("");
	$HUI.datebox("#EndDate").setValue("");
}

function MajorCTLocListDataGridLoad()
{ 
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCCTLocMajor",
		QueryName:"GetMajorLocList",
		CTLocID:"",
		Doctor:"",
		HospId:HospID,
		Pagerows:PageLogicObj.m_MajorCTLocListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	})
	
};

function MinorLocClickHandle(){
	var rows = PageLogicObj.m_MajorCTLocListDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].RowID);
		}
		var LocRowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一级科室记录!","info");
		return false;
	}
    $("#add-diag").css("display", ""); 
	PageLogicObj.editRow = undefined
	$("#add-diag").dialog( "open" );
	PageLogicObj.m_MinorCTLocListDataGrid=InitMinorCTLocTab(LocRowID);
	MinorCTLocListDataGridLoad(LocRowID);		
}

function InitMinorCTLocTab(Rowid)
{
	var MinorLocToolBar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {
		    //PageLogicObj.editRow = undefined;
            //PageLogicObj.m_MinorCTLocListDataGrid.datagrid("rejectChanges");
            PageLogicObj.m_MinorCTLocListDataGrid.datagrid("unselectAll");
            if (PageLogicObj.editRow != undefined) {
                $.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
                //PageLogicObj.m_MinorCTLocListDataGrid.datagrid("endEdit", PageLogicObj.editRow);
                return;
            }else{
	            PageLogicObj.editRow = 0;
                //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                PageLogicObj.m_MinorCTLocListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {
						RowID:"",
						CTLocDR:"",
						CTLOCDesc:"",
						IsActive:"",
						Hospital:"",						
					}
                });
                PageLogicObj.m_MinorCTLocListDataGrid.datagrid("beginEdit", 0);
                
            }
          
        }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            if(PageLogicObj.editRow==undefined){
				return false;
		  	}
            var rows = PageLogicObj.m_MinorCTLocListDataGrid.datagrid("getRows");
			if (rows.length > 0){
			   for (var i = 0; i < rows.length; i++) {
				   if(PageLogicObj.editRow==i){
					   var editors = PageLogicObj.m_MinorCTLocListDataGrid.datagrid('getEditors', PageLogicObj.editRow); 
					   //var LocRowID=editors[0].target.combobox('getValue');
					   //if(LocRowID=="")LocRowID=rows[i].CTLocDR;
					   var LocRowID=rows[i].CTLocDR;
					   var CTLMNRowID=rows[i].RowID;
					   if((typeof(LocRowID)=='undefined')||(LocRowID=="")){
							$.messager.alert('提示',"请正确选择科室.","info");
							return false;
			           }
			            var IsActive=0;
			            var selected=editors[1].target.is(':checked');
						if(selected) IsActive=1;
						if(CTLMNRowID==""){
							$.cm({
								ClassName:"web.DHCCTLocMinor",
								MethodName:"InsertMinor",
								'ParRef':Rowid,
								'CTLocID':LocRowID,
								'IsActive':IsActive,
								dataType:"text",
							},function testget(value){
								if(value=="1"){
									PageLogicObj.m_MinorCTLocListDataGrid.datagrid("endEdit", PageLogicObj.editRow);
									PageLogicObj.editRow = undefined;
									MinorCTLocListDataGridLoad(Rowid);
									PageLogicObj.m_MinorCTLocListDataGrid.datagrid('unselectAll');
									$.messager.show({title:"提示",msg:"保存成功"});
								}else{
									$.messager.alert('提示',"保存失败:"+value,"error");
									return false;
								}
								//PageLogicObj.editRow = undefined;
							});
						}else{
							$.cm({
								ClassName:"web.DHCCTLocMinor",
								MethodName:"UpdateMinor",
								'ID':CTLMNRowID,
								'ParRef':Rowid,
								'CTLocID':LocRowID,
								'IsActive':IsActive,
								dataType:"text",
							},function testget(value){
								if(value=="1"){
									PageLogicObj.m_MinorCTLocListDataGrid.datagrid("endEdit", PageLogicObj.editRow);
									PageLogicObj.editRow = undefined;
									MinorCTLocListDataGridLoad(Rowid);
									PageLogicObj.m_MinorCTLocListDataGrid.datagrid('unselectAll');
									$.messager.show({title:"提示",msg:"保存成功"});
								}else{
									$.messager.alert('提示',"保存失败:"+value,"error");
									return false;
								}
								//PageLogicObj.editRow = undefined;
							});	
						}
				   }
			   }
			}

        }
    }, {
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
	        if(PageLogicObj.editRow!=undefined){
	        	var row=PageLogicObj.m_MinorCTLocListDataGrid.datagrid("getRows")[PageLogicObj.editRow];
	        	if(!row.RowID){
		        	PageLogicObj.m_MinorCTLocListDataGrid.datagrid("deleteRow",PageLogicObj.editRow);
		        	PageLogicObj.editRow = undefined;
		        	return
		        }
	        }
            PageLogicObj.editRow = undefined;
            PageLogicObj.m_MinorCTLocListDataGrid.datagrid("rejectChanges");
            PageLogicObj.m_MinorCTLocListDataGrid.datagrid("unselectAll");
        }
    },
    {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {
            //删除时先获取选择行
            var rows = PageLogicObj.m_MinorCTLocListDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
                $.messager.confirm("提示", "确定删除吗?",
                function(r) {
                    if (r) {
                        var ids = [];
                        for (var i = rows.length-1; i>=0; i--) {
	                        if(!rows[i].RowID){
		                        PageLogicObj.m_MinorCTLocListDataGrid.datagrid("deleteRow",i);
		                    }else{
                            	ids.push(rows[i].RowID);
		                    }
                        }
                        var RowID=ids.join(',');
                        if (RowID=="") {
	                        PageLogicObj.editRow = undefined;
				            PageLogicObj.m_MinorCTLocListDataGrid.datagrid("rejectChanges");
				            PageLogicObj.m_MinorCTLocListDataGrid.datagrid("unselectAll");
				            return;
	                    }
                        $.cm({
                            ClassName:"web.DHCCTLocMinor",
                            MethodName:"DeleteMinorLoc",
                            'ID':Rowid+"||"+RowID,
                        },function testget(value){
							if(value=="1"){
								MinorCTLocListDataGridLoad(Rowid);
	           					PageLogicObj.m_MinorCTLocListDataGrid.datagrid('unselectAll');
	           					$.messager.show({title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value,"error");
							}
							PageLogicObj.editRow = undefined;
						});
                    }
                });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "info");
            }
         
        }
    }];
	var MinorLocColumns=[[    
		{ field: 'RowID', title: '', width: 1, align: 'left', sortable: true,hidden:true},
		{ field: 'CTLocDR', title: '', width: 1, align: 'left', sortable: true,hidden:true},
		{ field: 'CTLocDesc', title: '科室名称', width: 300, align: 'left', sortable: true,
			editor:{
				type:'combogrid',
				options:{
					required: true,
					panelWidth:300,
					panelHeight:430,
					idField:'CTCode',
					textField:'CTDesc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,
					rownumbers:true,
					collapsible:false,
					fit: true,
					pageSize: 10,
					pageList: [10],
					columns:[[
		                {field:'CTDesc',title:'科室名称',width:250,sortable:true},
		                {field:'CTCode',title:'LocRowID',width:120,sortable:true,hidden:true},
		                {field:'CTAlias',title:'CTAlias',width:120,sortable:true,hidden:true}
		             ]],
		             onShowPanel:function(){
		                var trObj = $HUI.combogrid(this);
						var object = trObj.grid();
		             	LoadItemData("",object)
		             },
		             onChange:function(newValue, oldValue){
			             if (!newValue) {
					       var rows=PageLogicObj.m_MinorCTLocListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	                       rows.CTLocDR="";
				         }
			         },
			         onSelect: function (rowIndex, rowData){
					    var rows=PageLogicObj.m_MinorCTLocListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	                    rows.CTLocDR=rowData.CTCode;
					},
					onClickRow: function (rowIndex, rowData){
					     var rows=PageLogicObj.m_MinorCTLocListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	                     rows.CTLocDR=rowData.CTCode;
					},
					 keyHandler:{
						up: function () {
			                //取得选中行
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //取得选中行的rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //向上移动到第一行为止
			                    if (index > 0) {
			                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
			                    }
			                } else {
			                    var rows = $(this).combogrid('grid').datagrid('getRows');
			                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
			                }
			             },
			             down: function () {
			               //取得选中行
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //取得选中行的rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //向下移动到当页最后一行为止
			                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
			                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
			                    }
			                } else {
			                    $(this).combogrid('grid').datagrid('selectRow', 0);
			                }
			            },
						left: function () {
							return false;
			            },
						right: function () {
							return false;
			            },            
						enter: function () { 
			                var selected = $(this).combogrid('grid').datagrid('getSelected');  
						    if (selected) { 
						      $(this).combogrid("options").value=selected.CTDesc;
						      var rows=PageLogicObj.m_MinorCTLocListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
		                      rows.CTLocDR=selected.CTCode;
						    }
			                $(this).combogrid('hidePanel');
							$(this).focus();
			            },
						query:function(q){
							var object=new Object();
							object=$(this)
							var trObj = $HUI.combogrid(this);
							var object = trObj.grid();

							if (this.AutoSearchTimeOut) {
								window.clearTimeout(this.AutoSearchTimeOut)
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object);},400); 
							}else{
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object);},400); 
							}
							$(this).combogrid("setValue",q);
						}
					}
				}
			}
		},{ field: 'IsActive', title: '激活标志', width: 70, align: 'center', sortable: true,
			editor : {
	            type : 'checkbox',
	            options : {
	                on : 'Y',
	                off : ''
	            }
           }
		},
		{ field: 'Hospital', title: '医院', width: 210, align: 'left',
			editor : {
	            type : 'text',
           }}
	]];
	MinorCTLocListDataGrid=$('#MinorCTLocListTab').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize:10,
		pageList : [10,20,50],
		columns :MinorLocColumns,
		toolbar :MinorLocToolBar,
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
		        return false;
			}
			PageLogicObj.m_MinorCTLocListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex;
			LocRowID=rowData.CTLocDR;
			var cellEdit = $(this).datagrid('getEditor', {index:rowIndex,field:'Hospital'});
			var $input = cellEdit.target; // 得到文本框对象
			$input.prop('readonly',true); // 设值只读
			$input.prop('disabled',true);
		},
		onLoadSuccess:function(){
			PageLogicObj.editRow = undefined;
			PageLogicObj.m_MinorCTLocListDataGrid.datagrid("unselectAll");
		}
	});
	return MinorCTLocListDataGrid;
}

function MinorCTLocListDataGridLoad(Rowid)
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if(Rowid=="")return;
	$.cm({
		ClassName:"web.DHCCTLocMinor",
		QueryName:"GetMinorList",
		'parref':Rowid,
		'HUIFlag':"HUI",
		HospID:HospID,
		Pagerows:PageLogicObj.m_MinorCTLocListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_MinorCTLocListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
};

function LoadItemData(q,obj){
	var val = q
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"OPDeptList",
		'UserId':"",
		'AdmType':"",
		'paradesc':val,
		HospitalID:HospID,
		Pagerows:obj.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
	})
	
};

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}
function InitFunLib(usertableName){
	var indexs="";var sortstr="";
	var sortWin='<div id="sortWin" style="width:570px;height:450px;"></div>';
	var sortGrid='<table id="sortGrid"></table>';
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('body').append(sortWin);
	$('#sortWin').append(sortGrid);
	  var columns=[[
	    {field:'SortId',title:'SortId',hidden:true},
	    {field:'RowId',title:'对应表RowId',hidden:true},
	    {field:'Desc',title:'描述',width:180},
	    {field:'SortType',title:'排序类型',hidden:true},
	    {field:'SortNum',title:'顺序号',editor:{'type':'numberbox'},width:180}
	  ]];
  var sortGrid=$HUI.datagrid('#sortGrid',{
      url: $URL,
      queryParams:{
        ClassName:"web.DHCCTLocMajor",
        QueryName:"GetList",
        'tableName':usertableName,
        'hospid':HospID
      },
      columns: columns,  //列信息
      pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
      pageSize:20,
      pageList:[5,10,14,15,20,25,30,50,75,100,200,300,500,1000],
      singleSelect:true,
      idField:'SortId',
      fit:true,
      rownumbers:true,    //设置为 true，则显示带有行号的列。
      fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
      //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
      //toolbar:'#mytbar'
      toolbar:[],
      onClickCell:function(index, field, value){
        if(indexs!==""){
           $(this).datagrid('endEdit', indexs);
        }
        $(this).datagrid('beginEdit', index);
        indexs=index;
      },
      onAfterEdit:function(index, row, changes){
        var type=$HUI.combobox('#TextSort').getText();
        if(JSON.stringify(changes)!="{}"){
          if(sortstr!==""){
            sortstr=sortstr+'*'+usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
          else{
            sortstr=usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
        }
      },
      onClickRow:function(index,row){
      },
      onDblClickRow:function(index, row){
      }
  });
  var toolbardiv='<div id="Sortb">排序类型&nbsp;<input id="TextSort" style="width:207px"></input><a plain="true" id="SortRefreshBtn" >重置</a><a plain="true" id="SortSaveBtn" >保存</a><a plain="true" id="SortUpBtn" >升序</a><a plain="true" id="SortLowBtn" >降序</a></div>';

  $('#sortWin .datagrid-toolbar tr').append(toolbardiv);
  $('#SortRefreshBtn').linkbutton({
      iconCls: 'icon-reload'
  });
  $('#SortSaveBtn').linkbutton({
      iconCls: 'icon-save'
  });
  $('#SortUpBtn').linkbutton({
      iconCls: 'icon-arrow-top'
  });
  $('#SortLowBtn').linkbutton({
      iconCls: 'icon-arrow-bottom'
  });
  $('#SortRefreshBtn').click(function(event) {
    //$('#TextSort').combobox('reload');
    $HUI.combobox('#TextSort').reload();
    $HUI.combobox('#TextSort').setValue();
    GridLoad(usertableName,'','');
  });

  $('#SortUpBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'ASC')
  });
  $('#SortLowBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'DESC')
  });
  $('#SortSaveBtn').click(function(event){
    var type=$HUI.combobox('#TextSort').getText();
    if(type==""){
      $.messager.alert('提示','排序类型不能为空！','error');
      return
    }
    if(indexs!==""){
      $('#sortGrid').datagrid('endEdit', indexs);
    }
    if(sortstr==""){
      $.messager.alert('提示','没有修改排序顺序号数据无需保存！','error');
      return
    }
    var NewSortArr=new Array();
	for (var i=0;i<sortstr.split("*").length;i++){
		var onesort=sortstr.split("*")[i];
		var onesortArr=onesort.split("^");
		onesortArr[2]=type;
		NewSortArr.push(onesortArr.join("^"));
	}
	sortstr=NewSortArr.join("*");
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData",
      data:{
            "sortstr":sortstr,
            MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
      },
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
            $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
          sortstr="";
          var types=$HUI.combobox('#TextSort').getText();
          GridLoad(usertableName,types,'')
          //$HUI.combobox('#TextSort').reload();
        }
        else{
          var errorMsg="修改失败！";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
          }
          $.messager.alert('错误提示',errorMsg,'error')
        }
      }
    });
  });
  
};
function SortBtn(usertableName){
	 InitFunLib(usertableName)
	var Sortwin=$HUI.dialog('#sortWin',{
	  iconCls:'icon-w-list',
	  resizeable:true,
	  title:'排序(排序类型可手动录入)',
	  modal:true,
	  onClose:function(){
		  InitSortType();
	  }
	});
	GridLoad(usertableName,'','');
	$('#TextSort').combobox({
	  url:$URL+"?ClassName=web.DHCCTLocMajor&QueryName=GetDataForCmb1&ResultSetType=array",
	  valueField:'SortType',
	  textField:'SortType',
	  onBeforeLoad:function(param){
	    param.tableName=usertableName;
	    param.hospid=$HUI.combogrid('#_HospList').getValue();
	  },
	  onLoadSuccess:function(data){
	  },
	  onSelect:function(record){
	    var type=record.SortType;
	    GridLoad(usertableName,type,'')
	  }
	});
};
function GridLoad (usertableName,type,dir){
    sortstr="";
    var HospID=$HUI.combogrid('#_HospList').getValue();
    $('#sortGrid').datagrid('load',{
      ClassName:"web.DHCCTLocMajor",
      QueryName:"GetList",
      'tableName':usertableName,
      'type':type,
      'dir':dir,
      'hospid':HospID
    });
    $('#sortGrid').datagrid('unselectAll');
  };

function InitSortType(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
		ClassName:"web.DHCCTLocMajor", //web.DHCBL.BDP.BDPSort
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.DHCCTLocMajor",hospid:HospID,
		dataType:"json"
	},function(Data){
		$("#MajorCTLocSort").combobox({
			textField:"SortType",
			valueField:"ID",
			data:Data.rows,
			OnChange:function(newValue,OldValue){
				if (!newValue) {
					$(this).combobox('setValue',"");
				}
			}
		})
	})
}

function SetDefConfig(Node1, TypeId) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		if ($.hisui.indexOfArray($("#"+TypeId).combobox('getData'),"SortType",rtn) >=0) {
			$("#"+TypeId).combobox("setText",rtn);
		}else{
			$("#"+TypeId).combobox("setText","");
		}
	})
	
}
function SaveConfigClick() {
	var MajorCTLocSort=$("#MajorCTLocSort").combobox("getText");
	if (($.hisui.indexOfArray($("#MajorCTLocSort").combobox('getData'),"SortType",MajorCTLocSort)<0)&&(MajorCTLocSort!="")) {
		$.messager.alert("提示","请选择一级科室列表排序！","info",function(){
			$("#MajorCTLocSort").next('span').find('input').focus();
		});
		return false;
	}
	var SortConfig="MajorCTLocSort"+"!"+MajorCTLocSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"提示",msg:"保存成功"});
	$("#MajorCTLoc-dialog").dialog("close")
}
function SaveConfig(SortConfig) {
	var HospId=$HUI.combogrid('#_HospList').getValue()
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveConfigHosp",
		Coninfo:SortConfig,
		HospID:HospId
	},false)
}
function InitFunSubLib(){
	var usertableName="User.DHCCTLocMinor"
	var rows = PageLogicObj.m_MajorCTLocListDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].RowID);
		}
		var MastRowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一级科室记录!","info");
		return false;
	}
	var indexs="";var sortstr="";
	var sortWin='<div id="sortWin" style="width:570px;height:450px;"></div>';
	var sortGrid='<table id="sortGrid"></table>';
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('body').append(sortWin);
	$('#sortWin').append(sortGrid);
	  var columns=[[
	    {field:'SortId',title:'SortId',hidden:true},
	    {field:'RowId',title:'对应表RowId',hidden:true},
	    {field:'Desc',title:'描述',width:180},
	    {field:'SortType',title:'排序类型',hidden:true},
	    {field:'SortNum',title:'顺序号',editor:{'type':'numberbox'},width:180}
	  ]];
  var sortGrid=$HUI.datagrid('#sortGrid',{
      url: $URL,
      queryParams:{
        ClassName:"web.DHCCTLocMajor",
        QueryName:"GetListSub",
        'tableName':usertableName,
        'hospid':HospID,
        'MastRowID':MastRowID
      },
      columns: columns,  //列信息
      pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
      pageSize:20,
      pageList:[5,10,14,15,20,25,30,50,75,100,200,300,500,1000],
      singleSelect:true,
      idField:'SortId',
      fit:true,
      rownumbers:true,    //设置为 true，则显示带有行号的列。
      fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
      //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
      //toolbar:'#mytbar'
      toolbar:[],
      onClickCell:function(index, field, value){
        if(indexs!==""){
           $(this).datagrid('endEdit', indexs);
        }
        $(this).datagrid('beginEdit', index);
        indexs=index;
      },
      onAfterEdit:function(index, row, changes){
        var type=$HUI.combobox('#TextSort').getText();
        if(JSON.stringify(changes)!="{}"){
          if(sortstr!==""){
            sortstr=sortstr+'*'+usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
          else{
            sortstr=usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
        }
      },
      onClickRow:function(index,row){
      },
      onDblClickRow:function(index, row){
      }
  });
  var toolbardiv='<div id="Sortb">排序类型&nbsp;<input id="TextSort" style="width:207px"></input><a plain="true" id="SortRefreshBtn" >重置</a><a plain="true" id="SortSaveBtn" >保存</a><a plain="true" id="SortUpBtn" >升序</a><a plain="true" id="SortLowBtn" >降序</a></div>';

  $('#sortWin .datagrid-toolbar tr').append(toolbardiv);
  $('#SortRefreshBtn').linkbutton({
      iconCls: 'icon-reload'
  });
  $('#SortSaveBtn').linkbutton({
      iconCls: 'icon-save'
  });
  $('#SortUpBtn').linkbutton({
      iconCls: 'icon-arrow-top'
  });
  $('#SortLowBtn').linkbutton({
      iconCls: 'icon-arrow-bottom'
  });
  $('#SortRefreshBtn').click(function(event) {
    //$('#TextSort').combobox('reload');
    $HUI.combobox('#TextSort').reload();
    $HUI.combobox('#TextSort').setValue();
    GridSubLoad(usertableName,'','',MastRowID);
  });

  $('#SortUpBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridSubLoad(usertableName,type,'ASC',MastRowID)
  });
  $('#SortLowBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridSubLoad(usertableName,type,'DESC',MastRowID)
  });
  $('#SortSaveBtn').click(function(event){
    var type=$HUI.combobox('#TextSort').getText();
    if(type==""){
      $.messager.alert('提示','排序类型不能为空！','error');
      return
    }
    if(indexs!==""){
      $('#sortGrid').datagrid('endEdit', indexs);
    }
    if(sortstr==""){
      $.messager.alert('提示','没有修改排序顺序号数据无需保存！','error');
      return
    }
    var NewSortArr=new Array();
	for (var i=0;i<sortstr.split("*").length;i++){
		var onesort=sortstr.split("*")[i];
		var onesortArr=onesort.split("^");
		onesortArr[2]=type;
		NewSortArr.push(onesortArr.join("^"));
	}
	sortstr=NewSortArr.join("*");
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData",
      data:{
            "sortstr":sortstr,
            MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
        },
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
            $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
          sortstr="";
          var types=$HUI.combobox('#TextSort').getText();
          //GridLoad(usertableName,types,'')
          GridSubLoad(usertableName,type,'',MastRowID)
          //$HUI.combobox('#TextSort').reload();
        }
        else{
          var errorMsg="修改失败！";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
          }
          $.messager.alert('错误提示',errorMsg,'error')
        }
      }
    });
  });
}
function GridSubLoad(usertableName,type,dir,MastRowID){
	sortstr="";
    var HospID=$HUI.combogrid('#_HospList').getValue();
    $('#sortGrid').datagrid('load',{
      ClassName:"web.DHCCTLocMajor",
      QueryName:"GetListSub",
      'tableName':usertableName,
      'type':type,
      'dir':dir,
      'hospid':HospID,
      'MastRowID':MastRowID
    });
    $('#sortGrid').datagrid('unselectAll');
}
function SortBtnSub(){
	var rows = PageLogicObj.m_MajorCTLocListDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].RowID);
		}
		var MastRowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一级科室记录!","info");
		return false;
	}
	var usertableName="User.DHCCTLocMinor"
	InitFunSubLib();
	var Sortwin=$HUI.dialog('#sortWin',{
		  iconCls:'icon-w-list',
		  resizeable:true,
		  title:'排序(排序类型可手动录入)',
		  modal:true,
		  onClose:function(){
			  InitSortType();
		  }
	});
	GridSubLoad(usertableName,'','',MastRowID);
	$('#TextSort').combobox({
		  url:$URL+"?ClassName=web.DHCCTLocMajor&QueryName=GetDataForCmb1Sub&ResultSetType=array",
		  valueField:'SortType',
		  textField:'SortType',
		  onBeforeLoad:function(param){
		    param.tableName=usertableName;
		    param.hospid=$HUI.combogrid('#_HospList').getValue();
		    param.MasterRowID=MastRowID
		  },
		  onLoadSuccess:function(data){
		  },
		  onSelect:function(record){
		    var type=record.SortType;
		    GridSubLoad(usertableName,type,'',MastRowID)
		  }
	});
};
function SaveConfigSubClick() {
	var rows = PageLogicObj.m_MajorCTLocListDataGrid.datagrid("getSelections");
	if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].RowID);
		}
		var MastRowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一级科室记录!","info");
		return false;
	}
	var MinorCTLocSort=$("#MinorCTLocSort").combobox("getText");
	if (($.hisui.indexOfArray($("#MinorCTLocSort").combobox('getData'),"SortType",MinorCTLocSort)<0)&&(MinorCTLocSort!="")) {
		$.messager.alert("提示","请选择科室列表排序！","info",function(){
			$("#MajorCTLocSort").next('span').find('input').focus();
		});
		return false;
	}
	var SortConfig="MinorCTLocSort"+MastRowID+"!"+MinorCTLocSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"提示",msg:"保存成功"});
	$("#MinorCTLoc-dialog").dialog("close")
}