var PageLogicObj={
	m_MajorCTLocListDataGrid:"",
	m_SelectLookup:false,
	m_MinorCTLocListDataGrid:"",
	editRow:undefined,
};

$(document).ready(function(){ 
	 //Init();
	 InitHospList();
	 InitEvent();
});

function InitHospList()
{
	var hospComp = GenHospComp("DHC_CTLoc_Major");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
		ClearData();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
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
	});
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
		HospId:HospID
	},function(rtn){
		if (rtn==1){
			$.messager.show({title:"提示",msg:"新增成功"});
			PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll');
			ClearData();
			MajorCTLocListDataGridLoad();
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
	},function(rtn){
		if (rtn==1){
			$.messager.show({title:"提示",msg:"修改成功"});
			PageLogicObj.m_MajorCTLocListDataGrid.datagrid('uncheckAll');
			ClearData();
			MajorCTLocListDataGridLoad();
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
		PageLogicObj.m_MajorCTLocListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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