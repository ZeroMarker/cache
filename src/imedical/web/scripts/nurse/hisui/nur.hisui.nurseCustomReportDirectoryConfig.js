<!-- nur.hisui.nurseCustomReportDirectoryConfig.js 根目录配置-->
var PageLogicObj={
	m_WardJson:""
}
editRow = undefined;
$(function(){
	InitHospList();                
                       
});
//初始化医院列表
function InitHospList(){
	/*
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:205});    //websys.com.js
	hospComp.jdata.options.onSelect = function(e,t){
		RefreshData();
		$("#SearchName").searchbox('setValue', '');

	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	*/
	
	try
	{
		// 多院区
		var sessionInfo = session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question",sessionInfo);
		hospComp.jdata.options.onSelect = function(e,t){
			RefreshData();
			$("#SearchName").searchbox('setValue', '');
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			Init();
		}
	}catch(ex)
	{
	  // 兼容老项目，非多院区的场景
	  $("#_HospList").combobox({
	    url:
	      $URL +
	      "?1=1&ClassName=Nur.NIS.Service.ReportV2.LocUtils" +
	      "&QueryName=GetHospitalList&ResultSetType=array",
	    valueField: "HospitalId",
	    textField: "HospitalDesc",
	    defaultFilter: 4,
	    width:250,
	    value:session['LOGON.HOSPID'],
	    onSelect:function(e,t){
		   RefreshData();
			$("#SearchName").searchbox('setValue', '');
		},
		onLoadSuccess:function(data){
			Init();
		}
	  });
	}
}
//页面初始化
function Init(){
	InitWardJson();
	InitReportDirectory();
	editRow = undefined;
	$("#SearchName").searchbox('setValue', '');
}

//刷新数据
function RefreshData(){
	$("#ReportListTab").datagrid("reload");

}
//科室数据
function InitWardJson(){
	PageLogicObj.m_WardJson=$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.LocUtils",
		QueryName:"NurseCtloc",
		desc:"",
		hosId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false)
}
//初始化报表列表界面
function InitReportDirectory(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#ReportListTab").datagrid("getRows");
					$("#ReportListTab").datagrid("appendRow", {
	                    RowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#ReportListTab").datagrid("beginEdit", editRow);
	                var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
				}else{
					$.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
				}
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#ReportListTab").datagrid("getSelections");
				if (rows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {
							var ids = [];
	                        for (var i = 0; i < rows.length; i++) {
	                            ids.push(rows[i].rowid);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#ReportListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
								MethodName:"UpdateReportDirectory",
								RowIDs:ID, 
								event:"DELETE",
							},false);
					        if(value=="0"){
						       RefreshData();
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
					        editRow = undefined;
	                    }
	                });
				}else{
					$.messager.popover({msg: '请选择要删除的行!',type: 'error'});
				}
			}
	    },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				 if (editRow != undefined) {
					var rows=$("#ReportListTab").datagrid("selectRow",editRow).datagrid("getSelected");
					var editors = $("#ReportListTab").datagrid('getEditors', editRow);
//					var Code = editors[0].target.val();
//					if(Code==""){
//						$.messager.popover({msg: 'Code不能为空!',type: 'error'});
//						$(editors[0].target).focus();
//						return false;
//					};
					var Name=editors[0].target.val();
					//var LocID=editors[2].target.combobox("getValues");  //启用时注意编辑器序号
					var SortNo=editors[1].target.val();
					var RowId = rows.rowid;

	                $.m({ 
						ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
						MethodName:"UpdateReportDirectory",
						event:"SAVE",
						RowIDs:RowId,
						//DirectoryCode:Code,
						DirectoryName:Name,
						DirectoryHospitalID:$HUI.combogrid('#_HospList').getValue(),
						//DirectoryLocID:LocID,
						DirectorySortNo:SortNo,
						DirectoryUpdateUser:session['LOGON.USERID'] || '',
						
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						    RefreshData();
						   $.messager.popover({msg: '保存成功!',type: 'success'});
						}
						else if(rtn.indexOf("不唯一")!=-1){
							$.messager.popover({msg: '保存失败: 名称不能重复',type: 'error'});
						    return false;
						}else{
							$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },
	    /**
	    '-',{
			text: '复制',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#ReportListTab").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg: '请选择需要复制的报表！',type: 'error'});
					return false;
				}else if(!selected.ReportRowId){
					$.messager.popover({msg: '请选择已保存的报表！',type: 'error'});
					return false;
				}
				$("#CopyWin" ).window({
				   modal: true,
				   collapsible:false,
				   minimizable:false,
				   maximizable:false,
				   closed:true
				}).window('open');
				$("#CopyReportName").val("").focus();
				$("#CopyReportName").val(selected.ReportName+"-复制");
			}
	    }
	    **/    
	    ];
	var Columns=[[
		{ field: 'rowid', title: 'ID',width:50},
		{ field: 'DirectoryCode', title: '编码',width:160
		},
		{ field: 'DirectoryName', title: '名称',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		/**
		{ field: 'DirectoryLocID', title: '科室',width:180, editor : 
			{
				type:'combobox',  
				options:{
					mode: "local",
					valueField:'locID',
					textField:'locDesc',
					mode: "local",
					multiple:true,
					rowStyle:"checkbox",
					data:PageLogicObj.m_WardJson.rows
				}
			},
			formatter: function(value,row,index){
				return row["ReportValidLocsDesc"];
			}
		},
		**/
		{ field: 'DirectorySortNo', title: '目录序号',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'DirectoryUpdateUser', title: '更新人',width:160
		},
		{ field: 'DirectoryUpdateDate', title: '更新日期',width:160
		},
		{ field: 'DirectoryUpdateTime', title: '更新时间',width:160
		},
	]];
	$('#ReportListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false,
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		idField:"rowid",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url: $URL,
		queryParams: {
				ClassName: "Nur.NIS.Service.ReportV2.DataManager",
				QueryName: "FindReportDirectory",
				//RowID : "" ,
				HospitalID:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue"),
			},
		onBeforeLoad:function(param){
			$('#ReportListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospitalID:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue")
			});
		},
		onLoadSuccess:function(v){
			editRow =undefined;
		},
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow != undefined) {
	            $.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
		        return false;
			}
			$('#ReportListTab').datagrid("beginEdit", rowIndex);
			editRow=rowIndex;
       },
       onClickRow:function(rowIndex, rowData){
	       $("#ReportItemListTab").datagrid("reload");
	       $('#ReportSearchTab').datagrid("reload")
	       //InitSearchCondition();
		   //editRow = undefined;
	   }
	})
}
/**
//获取列表选中项的RowID
function GetSelReportId(){
	var rows = $("#ReportListTab").datagrid("getSelected");
	if (rows){
		return rows["rowid"] || "";
	}
	return "";
}
//报表列表复制功能
function ReportCopyHandle(){
	var CopyReportName = $.trim($("#CopyReportName").val());
	if(CopyReportName==""){
		$.messager.popover({msg: '表单名称不能为空!',type: 'error'});
		$("#CopyReportName").focus();
		return false;
	};
	var selected = $("#ReportListTab").datagrid("getSelected");
	var CopyFromReportRowId=selected.ReportRowId;
	$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.ReportConfig",
		MethodName:"CopyReport",
		CopyFromReportRowId:CopyFromReportRowId,
		CopyReportName:CopyReportName
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '复制成功！',type: 'success'});
			$("#CopyWin").window('close');
			RefreshData();
		}else{
			$.messager.popover({msg: '复制失败！'+rtn,type: 'error'});
		}
	})
}
**/
