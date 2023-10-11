var PageLogicObj={
	tabRegChoseTypeListDataGrid:"",
	tabRegArcimListDataGrid:"",
	InitRegArcimListDataGridEditRow:"",
	RowID:""
};
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_BaseConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		CleargChoseTypeList();
		LoadLoc();
		LoadSex();
		LoadRegChoseTypeListDataGrid();
		InitRegArcimListDataGrid();
		PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//页面元素初始化
		InitEvent();
		Init();
		LoadRegChoseTypeListDataGrid();
	}
});
function Init(){
	LoadLoc();
	LoadSex();
	PageLogicObj.tabRegChoseTypeListDataGrid=InitRegChoseTypeListDataGrid();
	PageLogicObj.tabRegArcimListDataGrid=InitRegArcimListDataGrid();
}
function InitEvent(){
	$("#SaveCongfid").click(SaveCongfidClickHandle);
}
function SaveCongfidClickHandle(){
	var LocID=$('#LocList').combobox('getValue');
	if (!LocID) LocID="";
	var MarkID=$('#MarkList').combobox('getValue');
	if ((MarkID)&&($.hisui.indexOfArray($('#MarkList').combobox('getData'),"Hidden1",MarkID) <0)) MarkID="";	
	var SexID=$('#Sex').combobox('getValue');
	if (!SexID) SexID="";
	var AgeSamll=$("#AgeSamll").numberbox('getValue');
	var AgeBig=$("#AgeBig").numberbox('getValue');
	if ((AgeSamll !="")&&(AgeBig !="")&&(+AgeBig < +AgeSamll)) {
		$.messager.alert("提示","开始年龄不能大于结束年龄!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeSamll))||(AgeSamll <0)) {
		$.messager.alert("提示","开始年龄只能是大于等于0的数字!","info",function(){
			$("#AgeSamll").focus();
		});
		return;
	}
	if ((isNaN(AgeBig))||(AgeBig <0)) {
		$.messager.alert("提示","结束年龄只能是大于等于0的数字!","info",function(){
			$("#AgeBig").focus();
		});
		return;
	}
	var AgeRange=AgeSamll+"-"+AgeBig;
	var Prior=$("#FristRange").val();
	if ((isNaN(Prior))||(Prior <0)) {
		$.messager.alert("提示","优先级只能填写大于等于0的数字!","info",function(){
			$("#FristRange").focus();
		});
		return;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((LocID =="")&&(MarkID =="")&&(SexID =="")&&(AgeRange =="-")){
		$.messager.alert("提示","请选择或输入条件!");
		return;
	}
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		MethodName:"Insert",
		RowID:PageLogicObj.RowID,
		LocID:LocID,
		MarkID:MarkID,
		SexID:SexID,
		AgeRange:AgeRange,
		Prior:Prior,
		HospID:HospID,
		dataType:"text",
	},function(data){
		if (data==0){
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$("#Aliteadd-dialog").dialog("close");
			PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
			LoadRegChoseTypeListDataGrid();
		}
	})
}
function CleargChoseTypeList(){
	PageLogicObj.RowID=""
	$("#LocList,#MarkList,#Sex").combobox('select','');
	$("#FristRange").val("");
	$("#AgeSamll,#AgeBig").numberbox('setValue',"");
}
function LoadRegChoseTypeListDataGrid(){
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		QueryName:"FindRegArcimConfig",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		Pagerows:PageLogicObj.tabRegChoseTypeListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	})
}
function InitRegChoseTypeListDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	        $("#Aliteadd-dialog").dialog("open");
	        CleargChoseTypeList();
	    }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() { 
        	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要删除的记录!","info");
				return false;
			}
			$.messager.confirm('确认','您确定要删除吗?',function(r){    
			    if (r){    
			        RowID=row.RowID;
			        $.cm({
						ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
						MethodName:"Delect",
						RowID:RowID,
						dataType:"text",
					},function(data){
						if (data==0){
							$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
							PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',{"total":0,"rows":[]});
							LoadRegChoseTypeListDataGrid();
						}
					})
			    }    
			});  
				
        }
    },{
        text: '修改',
        iconCls: 'icon-save',
        handler: function() { 
        	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
			if ((!row)||(row.length==0)){
				$.messager.alert("提示","请选择需要修改的记录!","info");
				return false;
			}
			PageLogicObj.RowID=row.RowID;
			$("#LocList").combobox('select',row["LocID"]);
			setTimeout(function() { 
	        	$("#MarkList").combobox('setValue',row["MarkID"]);
	        },500);
			$("#Sex").combobox('setValue',row["SexID"]);
			$("#AgeSamll").numberbox('setValue',row["AgeRange"].split("-")[0])
			$("#AgeBig").numberbox('setValue',row["AgeRange"].split("-")[1])
			$("#FristRange").val(row["PriorLeven"])
        	$("#Aliteadd-dialog").dialog("open");
        }
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'LocDesc',title:'科室',width:200},
		{field:'LocID',title:'',hidden:true},
		{field:'MarkDesc',title:'号别',width:200},
		{field:'MarkID',title:'',hidden:true},
		{field:'SexDesc',title:'性别',width:60},
		{field:'SexID',title:'',hidden:true},
		{field:'AgeRange',title:'年龄段',width:60},
		{field:'PriorLeven',title:'优先级',width:60},
    ]]
	var tabRegChoseTypeLisDataGrid=$("#tabRegChoseTypeList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar,
		onSelect: function (index, row){
			RowID=row.RowID
			loadInitRegArcimListData(RowID)
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return tabRegChoseTypeLisDataGrid;
}
function loadInitRegArcimListData(RowID){
	$.cm({
		ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
		QueryName:"FindRegArcimDesc",
		RowID:RowID,
		Pagerows:PageLogicObj.tabRegArcimListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
		PageLogicObj.tabRegArcimListDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	})
}
function InitRegArcimListDataGrid(){
	 var CNMedCookArcModeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择一行记录进行新增!","info");
					return false;
				}
            	PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.tabRegArcimListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.tabRegArcimListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.InitRegArcimListDataGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
	            var row=PageLogicObj.tabRegArcimListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择一行记录进行删除!","info");
					return false;
				}
	            var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				MastRowID=row.RowID;
                var rows = PageLogicObj.tabRegArcimListDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "您确定要删除吗?",
                    function(r) {
                        if (r) {
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
									MethodName:"ArcDelect",
								   	RowID:MastRowID,indnumber:Rowid,
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        loadInitRegArcimListData(MastRowID)	
								}
	                        }else{
								PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                				PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
                PageLogicObj.tabRegArcimListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				 var row=PageLogicObj.tabRegChoseTypeListDataGrid.datagrid('getSelected');
				if ((!row)||(row.length==0)){
					$.messager.alert("提示","请选择一行记录进行保存!","info");
					return false;
				}
				MastRowID=row.RowID;
				if (PageLogicObj.InitRegArcimListDataGridEditRow != undefined){
		            var ArcimSelRow=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected"); 
		           	var ArcimRowID=ArcimSelRow.ARCIMRowid
		           	if (!ArcimRowID){
						$.messager.alert("提示","请选择医嘱!");
                        return false;
			        } 
			        //var editors = PageLogicObj.tabRegArcimListDataGrid.datagrid('getEditors', PageLogicObj.InitRegArcimListDataGridEditRow);
			        var Number=""
			        var subrowid=ArcimSelRow.RowID
			       	ARCIMStr=ArcimRowID+"!"+Number
			        var value=$.m({
						ClassName:"DHCDoc.OPAdm.DHCOPRegArcimConfig",
						MethodName:"ARCInsert",
					   	RowID:MastRowID, ARCIMStr:ARCIMStr, indnumber:subrowid
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
						PageLogicObj.InitRegArcimListDataGridEditRow = undefined;
				        loadInitRegArcimListData(MastRowID)		
					}else if (value =="repeat") {
						$.messager.alert("提示","记录重复!");
					}
		        }
			}
	}];
	var RegServiceGroup= $m({
	    ClassName : "web.DHCOPRegConfig",
	    MethodName : "GetSpecConfigNode",
	    NodeName : "RegServiceGroup",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	},false);
	var SeviceQueryData = $cm({
	    ClassName : "web.DHCBL.BaseReg.BaseDataQuery",
	    QueryName : "SeviceQuery",
	    RegServiceGroupRowId : RegServiceGroup,
	    HospID:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:99999,rows:99999
	},false);
    var CNMedCookArcModeColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
    				{ field: 'ARCIMRowid', title: 'ARCIMRowid', width: 10,hidden:true },
					{ field: 'ARCIMDesc', title: '医嘱名称', width: 20,
						editor:{
				    	type:'combogrid',
				    	options:{
				    		required: true,
				        	panelWidth:450,
							panelHeight:350,
		                    idField:'ID',
		                    textField:'Desc',
		                    value:'',//缺省值 
		                    mode:'remote',
							pagination : false,//是否分页   
							rownumbers:true,//序号   
							collapsible:false,//是否可折叠的   
							fit: true,//自动大小   
							pageSize: 10,//每页显示的记录条数，默认为10   
							pageList: [10],//可以设置每页记录条数的列表  
							data:SeviceQueryData,
		                    columns:[[
		                        {field:'Desc',title:'名称',width:300,sortable:true},
			                    {field:'ID',title:'ID',width:120,sortable:true}
		                     ]],
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
					                //选中后让下拉表格消失
					                $(this).combogrid('hidePanel');
									$(this).focus();
					            }
		        			},
							onSelect : function(rowIndex, rowData) {
								var ArcimSelRow=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected"); 
								var oldInstrArcimId=ArcimSelRow.ARCIMRowid;
								ArcimSelRow.ARCIMRowid=rowData.ID;
							}
		        		}
		        	}
                    	/*editor:{
		              		type:'combogrid',
		                    options:{
			                    enterNullValueClear:false,
								required: true,
								panelWidth:450,
								panelHeight:350,
								delay:500,
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
								url:$URL+"?ClassName=DHCDoc.OPAdm.DHCOPRegArcimConfig&QueryName=FindAllItem",
	                            columns:[[
	                                {field:'ArcimDesc',title:'名称',width:310,sortable:true},
					                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
					                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	                             ]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onClickRow: function (rowIndex, rowData){
									var rows=PageLogicObj.tabRegArcimListDataGrid.datagrid("selectRow",PageLogicObj.InitRegArcimListDataGridEditRow).datagrid("getSelected");
									rows.ARCIMRowid=rowData.ArcimRowID
								},
								onLoadSuccess:function(data){
									$(this).next('span').find('input').focus();
								},
								onBeforeLoad:function(param){
									if (param['q']) {
										var desc=param['q'];
									}
									param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
								}
                    		}
	        			  }*/
					},
        			{ field: 'Number', title: '数量', width: 20,hidden:true ,editor : {type : 'text',options : {}}
					}
    			 ]];
	// 煎药方式列表Grid
	tabRegArcimListDataGrid=$('#tabRegArcimList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :CNMedCookArcModeColumns,
		toolbar :CNMedCookArcModeToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.tabRegArcimListDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.tabRegArcimListDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (CookArcItemDataGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.tabRegArcimListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.InitRegArcimListDataGridEditRow=rowIndex;
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return tabRegArcimListDataGrid;
	
}
function LoadLoc(){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:$HUI.combogrid('#_HospList').getValue(),rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#LocList", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
					if (rec){
						LoadDoc(rec['Hidden']);
					}
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#MarkList").combobox('select','');
						$("#MarkList").combobox('loadData',[]);
					}
				}
		 });
	});
}

function LoadDoc(DepRowId){
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		DepID:DepRowId,
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(Data){
		var cbox = $HUI.combobox("#MarkList", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Hidden2"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(){
				}
		 });
	});
}


function LoadSex(){
	$HUI.combobox("#Sex", {
		valueField: 'id',
		textField: 'text', 
		blurValidValue:true,
		data: JSON.parse(ServerObj.DefaultSexPara),
		filter: function(q, row){
			if (q=="") return true;
			var find=0;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			for (var i=0;i<row["AliasStr"].split("^").length;i++){
				if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
					find=1;
					break;
				}
			}
			if (find==1) return true;
			return false;
		},
		onSelect:function(rec){
		}
	})
	
}