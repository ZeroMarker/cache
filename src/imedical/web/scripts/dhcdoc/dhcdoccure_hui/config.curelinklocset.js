var PageLogicObj={
	editRow1:undefined,
	CureLocDataGrid:""
}
var CureLinkLocDataGrid
$(document).ready(function(){ 
	 //Init();
	 //InitCureLinkLoc();
	 InitHospList();
	 //CureLocDataGridLoad();
});
function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_LinkLoc",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		InitCureLinkLoc();
		CureLocDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.CureLocDataGrid=Init();
		InitCureLinkLoc();
		CureLocDataGridLoad();
	}
}
function Init()
{
	var CureLocToolBar = [{
            text: '关联科室',
            iconCls: 'icon-edit',
            handler: function() {
				LinkLocClickHandle();
            }
        }];
	CureLocColumns=[[    
                    { field: 'LocDesc', title: '名称', width: 850, sortable: true
					},
        			{ field: 'LocRowID', title: '科室ID', width: 250, sortable: true,hidden:true
					}
    			 ]];
	var CureLocDataGrid=$('#tabCureLoc').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"LocRowID",
		pageSize : 15,
		pageList : [15,50,100],
		columns :CureLocColumns,
		toolbar :CureLocToolBar,
		onDblClickRow:function(rowIndex, rowData){ 
			LinkLocClickHandle();
       }
	});
	
	return CureLocDataGrid;
};

function LinkLocClickHandle(){
	var rows = PageLogicObj.CureLocDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].LocRowID);
		}
		var LocRowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一条记录!");
		return false;
	}
    $("#dialog-CureLinkLoc").css("display", ""); 
	var dialog1 = $HUI.dialog("#dialog-CureLinkLoc",{ //$("#dialog-CureLinkLoc").dialog({
		autoOpen: false,
		height: 500,
		width: 400,
		modal: true
	});
	dialog1.dialog( "open" );
	InitCureLinkLoc(LocRowID);	
}
function CureLocDataGridLoad()
{ 
	var HospDr=GetSelHospID();
	var LocDesc=$("#SLocDesc").searchbox("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:LocDesc,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:PageLogicObj.CureLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureLocDataGrid.datagrid("unselectAll").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	
};
function InitCureLinkLoc(Rowid)
{
	var CureLinkToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    PageLogicObj.editRow1 = undefined;
                //CureLinkLocDataGrid.datagrid("rejectChanges");
                CureLinkLocDataGrid.datagrid("unselectAll");
                if (PageLogicObj.editRow1 != undefined) {
	                $.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
                    CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    CureLinkLocDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {
							RowID:"",
							LinkLocRowID:"",
							LocDesc:"",						
						}
                    });
                    //将新插入的那一行开户编辑状态
                    CureLinkLocDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    PageLogicObj.editRow1 = 0;
                }
              
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if(PageLogicObj.editRow1==undefined){
					return false;
			  	}
                var rows = CureLinkLocDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(PageLogicObj.editRow1==i){
						   var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");  
						   var editors = CureLinkLocDataGrid.datagrid('getEditors', PageLogicObj.editRow1); 
						   var LinkLocRowID=editors[0].target.combobox('getValue');
						   if ((!LinkLocRowID)||(rows.LinkLocRowID=="")){
								$.messager.alert('提示',"请选择关联科室");
								return false;
				            }
							$.m({
								ClassName:"DHCDoc.DHCDocCure.Config",
								MethodName:"insertLinkLoc",
								'MainLocID':Rowid,
								'LinkLocID':LinkLocRowID
							},function testget(value){
								if(value=="0"){
									CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
									PageLogicObj.editRow1 = undefined;
									//CureLinkLocDataGrid.datagrid('load');
									CureLinkLocDataGridLoad(Rowid);
									CureLinkLocDataGrid.datagrid('unselectAll');
									$.messager.show({title:"提示",msg:"保存成功"});
								}else if(value=="-1"){
									$.messager.alert('提示',"保存失败,该记录已存在");
									return false;
								}else if(value=="-2"){
									$.messager.alert('提示',"保存失败,请正确选择关联科室");
									return false;
								}else if(value=="-101"){
									$.messager.alert('提示',"保存失败,本科室不能关联自身");
									return false;
								}else{
									$.messager.alert('提示',"保存失败:"+value);
									return false;
								}
								PageLogicObj.editRow1 = undefined;
								
							});
					   }
				   }
				}

            }
        }, {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                PageLogicObj.editRow1 = undefined;
                CureLinkLocDataGrid.datagrid("rejectChanges");
                CureLinkLocDataGrid.datagrid("unselectAll");
            }
        },
        {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = CureLinkLocDataGrid.datagrid("getSelections");
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
	                            PageLogicObj.editRow1 = undefined;
				                CureLinkLocDataGrid.datagrid("rejectChanges");
				                CureLinkLocDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            $.m({
	                            ClassName:"DHCDoc.DHCDocCure.Config",
	                            MethodName:"deleteLink",
	                            'RowID':RowID
                            },function testget(value){
								if(value=="0"){
									//CureLinkLocDataGrid.datagrid('load');
									CureLinkLocDataGridLoad(Rowid);
		           					CureLinkLocDataGrid.datagrid('unselectAll');
		           					$.messager.show({title:"提示",msg:"删除成功"});
								}else{
									$.messager.alert('提示',"删除失败:"+value);
								}
								PageLogicObj.editRow1 = undefined;
							});
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        }];
	CureLinkColumns=[[    
					{ field: 'RowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LinkLocRowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
					},
					{ field: 'LocDesc', title: '关联科室名称', width: 300, align: 'center', sortable: true,
					  editor:{
							type:'combogrid',
							options:{
								required: true,
								panelWidth:300,
								panelHeight:350,
								idField:'LocRowID',
								textField:'LocDesc',
								value:'',
								mode:'remote',
								pagination : true,
								rownumbers:true,
								collapsible:false,
								fit: true,
								pageSize: 10,
								pageList: [10],
								//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
								columns:[[
	                                {field:'LocDesc',title:'名称',width:250,sortable:true},
				                    {field:'LocRowID',title:'LocRowID',width:120,sortable:true,hidden:true},
				                    {field:'selected',title:'LocRowID',width:120,sortable:true,hidden:true}
	                             ]],
	                             onShowPanel:function(){
		                            var trObj = $HUI.combogrid(this);
									var object1 = trObj.grid();
		                         	LoadItemData("",object1)
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
									  //文本框的内容为选中行的的字段内容
						                var selected = $(this).combogrid('grid').datagrid('getSelected');  
									    if (selected) { 
									      $(this).combogrid("options").value=selected.ArcimDesc;
									      var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                                          rows.LinkLocRowID=selected.LocRowID
									    }
									    //
						                //选中后让下拉表格消失
						                $(this).combogrid('hidePanel');
										$(this).focus();
						            },
									 query:function(q){
										var object1=new Object();
										object1=$(this)
										var trObj = $HUI.combogrid(this);
										var object1 = trObj.grid();

										if (this.AutoSearchTimeOut) {
											window.clearTimeout(this.AutoSearchTimeOut)
											this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
										}else{
											this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
										}
										$(this).combogrid("setValue",q);
									}
                    			},
                    			onSelect:function(rowIndex, rowData){
							      var rows=CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                                  rows.LinkLocRowID=rowData.LocRowID
	                    		}
                    		}
	        			 }
					  
					}
    			 ]];
	CureLinkLocDataGrid=$('#tabCureLinkLoc').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		pageSize:10,
		pageList : [10,20,50],
		columns :CureLinkColumns,
		toolbar :CureLinkToolBar,
	});
	CureLinkLocDataGridLoad(Rowid);
	return CureLinkLocDataGrid;
}

function CureLinkLocDataGridLoad(Rowid)
{
	if(Rowid=="")return;
	/*
	CureLinkLocDataGrid.datagrid({
		url:$URL,
		queryParams:{
			ClassName:"DHCDoc.DHCDocCure.Config",
			QueryName:"FindCureLinkLoc",
			'RowIDLocRowID':Rowid,
		},onLoadSuccess:function(){
			var opts = CureLinkLocDataGrid.datagrid('options');
			var pageNum1=opts.pageNumber;
			var pageSize1=opts.pageSize;
			CureLinkLocDataGrid.datagrid('getPager').pagination('refresh',{
				pageNumber:pageNum1,
				pageSize:pageSize1})
		}
	})*/
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindCureLinkLoc",
		'RowIDLocRowID':Rowid,
		Pagerows:CureLinkLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureLinkLocDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
};

function LoadItemData(q,obj1){
	var val = q //$('#Combo_CTLoc').combogrid('getValue'); 
	var HospDr=GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:val,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:obj1.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj1.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	
};

function GetSelHospID(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}