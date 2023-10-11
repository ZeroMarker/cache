/**
@desc 报表配置
*/
var PageLogicObj={
	m_WardJson:""
}
editRow = undefined;
editRow_search = undefined;

// 报表对应的query
var queryJson = ""

var reportItemJson = ""

$(function(){
	InitHospList();                
	InitEvent();                       
});
//初始化医院列表
function InitHospList(){
	/*
	var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:205});    //websys.com.js
	hospComp.jdata.options.onSelect = function(e,t){
		RefreshData();
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
		},
		onLoadSuccess:function(data){
			Init();
		}
	  });
	}
}
//页面初始化
function Init(){
	editRow = undefined;
	InitWardJson();
	InitReportListTabTab();
	InitReportItemListTab();
	InitSearchCondition();
	$("#BFind").click(function(){
		RefreshData();
	});

}
//初始化右击事件
function InitEvent(){
	$("#BReportCopy").click(ReportCopyHandle);
	$("#BCancel").click(function(){
	 	$("#CopyWin").window('close');
	});
}
//刷新数据
function RefreshData(){
	editRow = undefined;
	$('#ReportListTab').datagrid('reload',{
		ClassName:"Nur.NIS.Service.ReportV2.DataManager",
		QueryName:"GetReportList",
		SearchName:$("#SearchName").searchbox("getValue"),
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:9999
	})
	$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
	$('#ReportSearchTab').datagrid("loadData", {"rows":[],"total":0});
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
function InitReportListTabTab(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
				if (editRow == undefined) {
					var maxRow=$("#ReportListTab").datagrid("getRows");
					$("#ReportListTab").datagrid("appendRow", {
	                    ReportRowId: ''
	                })
	                editRow=maxRow.length-1;
	                $("#ReportListTab").datagrid("beginEdit", editRow);
	                var editors = $("#ReportListTab").datagrid('getEditors', editRow);
					$(editors[0].target).focus();
					$('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
					$('#ReportSearchTab').datagrid("loadData", {"rows":[],"total":0});
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
	                            ids.push(rows[i].ReportRowId);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
	                            editRow = undefined;
				                $("#ReportListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
								MethodName:"HandleReport",
								rowID:ID, event:"DELETE"
							},false);
					        if(value=="0"){
						       $('#ReportListTab').datagrid('deleteRow',$('#ReportListTab').datagrid('getRowIndex',ID));
						       $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
						       $('#ReportSearchTab').datagrid("loadData", {"rows":[],"total":0});
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

					var name = editors[0].target.val();
					if(name==""){
						$.messager.popover({msg: '表单名称不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					//var validLocs=editors[1].target.combobox("getValues").join("^");
					//var inValidLocs=editors[2].target.combobox("getValues").join("^");
					var reportProperty=editors[1].target.combobox("getValues").join();
					if(reportProperty==""){
						$.messager.popover({msg: '请选择表单属性!',type: 'error'});
						$(editors[1].target).focus();
						return false;
					};
					var reportaddress = editors[2].target.val();
					if ((reportProperty=="CSP")&&(reportaddress=="")){
						/* 暂时解除限制 可以扩展query
						$.messager.popover({msg: '表单属性为：自定义CSP，地址不能为空!',type: 'error'});
						$(editors[2].target).focus();
						return false;
						*/
					};
					
					// 校验Query是否存在
					var queryInfo = editors[4].target.val();
					// 是否分页
					var showPage = editors[5].target.combobox("getValues").join();
					if (queryInfo && queryInfo !="")
					{
						var checkResult = $cm({
								ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
								MethodName:"CheckQuery",
								queryInfo:queryInfo
							},false)
						if (checkResult == "0")
						{
							$.messager.popover({msg: 'Query格式不对或当前库不存在！(格式：ClassName||QueryName)',type: 'error'});
							$(editors[4].target).focus();
							return false;
						}
					}
					var templateCode = editors[3].target.val();
					var ReportRowId = rows.ReportRowId;
					if (!ReportRowId) ReportRowId="";
					// 2022.6.17 add
					var sortInfo = editors[6].target.val();
					// 2022.7.18 add
					var filterCondition = editors[7].target.val();
	                $.m({
						ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
						MethodName:"HandleReport",
						rowID:ReportRowId,
						name:name,
						//validLocs:validLocs,
						//inValidLocs:inValidLocs,
						hospId:$HUI.combogrid('#_HospList').getValue(),
						reportProperty:reportProperty,
						reportAddress:reportaddress,
						templateCode:templateCode,
						queryInfo:queryInfo,
						showPage:showPage,
						sortInfo:sortInfo,
						filterCondition:filterCondition,
						event:"SAVE"
					},function(rtn){
						if(rtn==0){
						   editRow = undefined;
						   $("#ReportListTab").datagrid('unselectAll').datagrid('load');
						   $('#ReportItemListTab').datagrid("loadData", {"rows":[],"total":0});
						   $('#ReportSearchTab').datagrid("loadData", {"rows":[],"total":0});
						   $.messager.popover({msg: '保存成功!',type: 'success'});
						}else{
							
							$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
						    return false;
						}
					}); 
				 }
			}
	    },'-',{
			text: '全部复制',
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
				   closed:true,
				   
				}).window('open');
				$("#CopyReportProperty").combobox({
					valueField:'ReportProperty',
					textField:'ReportPropertyDescs',
					required:true,
					valueField:'value',
					textField:'text',
					rowStyle:"checkbox",
					data:ServerObj.ReportPropertyTypeJson,				
					});
				$("#CopyReportName").val("").focus();
				$("#CopyReportName").val(selected.ReportName+"-复制");
				/*
				$("#CopyReportAddress").val(selected.ReportAddress);
				$("#CopyTemplateCode").val(selected.TemplateCode);
				$("#CopyQueryInfo").val(selected.QueryInfo);
				*/
			}
	    },
	    /*
	    {
			text: '查看示例',
			iconCls: 'icon-copy',
			handler: function() {
				var selected = $("#ReportListTab").datagrid("getSelected");
				$("#demoImg").attr("src",selected.DemoImg);
				$("#DemoWin" ).window({
				   modal: true,
				   collapsible:false,
				   minimizable:false,
				   maximizable:false,
				   closed:true,
				}).window('open');
			}
	    }
	    */
	    ];
	var Columns=[[
		{ field: 'ReportRowId', title: 'ID',width:50},
		{ field: 'ReportCode', title: '表单编码',width:120
		},
		{ field: 'ReportName', title: '表单名称',width:160, editor : 
			{type : 'text',options : {required:true}}
		},
		/**
		{ field: 'ReportValidLocs', title: '适用范围',hidden:true,width:180, editor : 
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
		{ field: 'ReportInValidLocs', title: '不适用范围',hidden:true,width:180, editor : 
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
				return row["ReportInValidLocDescs"];
			}
		},
		**/
		{ field: 'ReportProperty', title: '表单属性',width:180, editor : 
			{
				type:'combobox', 
				options : {
					mode: "local",
					valueField:'ReportProperty',
					textField:'ReportPropertyDescs',
					required:true,
					valueField:'value',
					textField:'text',
					rowStyle:"checkbox",
					data:ServerObj.ReportPropertyTypeJson,					
				}
			},
			formatter: function(value,row,index){
				return row["ReportPropertyDescs"];
			}
		},
		{ field: 'ReportAddress', title: 'CSP名称',width:160, editor : 
			{type : 'text',}
		},
		{ field: 'TemplateCode', title: '模板编码',width:160, editor : 
			{type : 'text',}
		},
		{ field: 'QueryInfo', title: 'Query',width:400, editor : 
			{type : 'text',}
		},
		{field:'DemoImg',hidden:true},
		{ field: 'ShowPage', title: '分页',width:60, editor : 
			{
				type:'combobox', 
				options : {
					mode: "local",
					rowStyle:"checkbox",
					data:[{"text":"N","value":"N"},{"text":"Y","value":"Y"}],					
				}
			},
			formatter: function(value,row,index){
				return row["ShowPage"];
			}
		},
		{ field: 'SortInfo', title: '排序',width:240, editor : 
			{type : 'text',}
		},
		{ field: 'FilterCondition', title: '病历过滤条件',width:240, editor : 
			{type : 'text',}
		}
		
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
		idField:"ReportRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.DataManager&QueryName=GetReportList",
		onBeforeLoad:function(param){
			$('#ReportListTab').datagrid("unselectAll");
			param = $.extend(param,{
				HospId:$HUI.combogrid('#_HospList').getValue(),
				SearchName:$("#SearchName").searchbox("getValue")
			});
		},
		onLoadSuccess:function(){
			editRow = undefined;
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
	        // 获取query列信息
	        queryJson = $cm({
						ClassName:"Nur.NIS.Service.ReportV2.Tools", 
						MethodName:"GetOptionOfQuery",
						queryInfo:rowData.QueryInfo
					},false)
	       //$("#ReportItemListTab").datagrid("reload");
	       
	       reportItemJson = $cm({
						ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
						MethodName:"GetReportItemConfig",
						ReportId:rowData.ReportRowId
					},false)
	      
	       InitReportItemListTab(); // 刷新报表项列表
	       //$('#ReportSearchTab').datagrid("reload");
	       InitSearchCondition(); // 刷新检索条件
	      
	   }
	})
}

//获取报表列表选中项的RowID
function GetSelReportId(){
	var rows = $("#ReportListTab").datagrid("getSelected");
	if (rows){
		return rows["ReportRowId"] || "";
	}
	return "";
}
//初始化报表项配置界面
function InitReportItemListTab(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
					var ReportRowId=GetSelReportId();
					if (!ReportRowId){
						$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
		        		return false;
					}
					var maxRow=$("#ReportItemListTab").datagrid("getRows");
					$("#ReportItemListTab").datagrid("appendRow", {
	                    ReportItemRowId: ''
	                })
	                $("#ReportItemListTab").datagrid("beginEdit", maxRow.length-1);
	                var editors = $("#ReportItemListTab").datagrid('getEditors', maxRow.length-1);
					$(editors[0].target).focus();
					var target=$('#ReportItemListTab').datagrid('getEditor',{'index':maxRow.length-1,'field':'ReportItemAlternativeVal'}).target;
	        		$(target).attr("placeHolder","多个选项用^分割");
	        		
	        		// 识别Query方法，自定增加数据类型为：Query
	        		if (queryJson && queryJson !=""){
						$("#ReportItemListTab").datagrid("getEditor",{'index':maxRow.length-1,'field':"ReportItemDataType"}).target.combobox('setValue', "Query");
	        		}
			}
		},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var selRows = $("#ReportItemListTab").datagrid("getSelections");
				if (selRows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {
		                    var ErrMsg=[];
							var ids = [];delSeqNoObj={};
							var rows = $("#ReportItemListTab").datagrid("getSelections");
	                        for (var i = 0; i < selRows.length; i++) {
	                            var ReportItemRowId=selRows[i].ReportItemRowId;
	                            var ReportItemSeqNo=selRows[i].ReportItemSeqNo;
	                            ids.push(ReportItemRowId);
	                            if ((ReportItemSeqNo!="")&&(ReportItemRowId)){
		                            var index=$("#ReportItemListTab").datagrid("getRowIndex",ReportItemRowId);
		                            delSeqNoObj[ReportItemSeqNo]=index+1;
		                        }
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
				                $("#ReportItemListTab").datagrid("rejectChanges").datagrid("unselectAll");
				                
				                return;
	                        }
	                        var rows=$("#ReportItemListTab").datagrid("getRows");
	                        for (var i=0;i<rows.length;i++){
		                        var ReportItemSeqNo=rows[i]["ReportItemSeqNo"];
		                        if (ReportItemSeqNo){
			                        var ItemSeqNoArr=ReportItemSeqNo.split(".");
			                        if (ItemSeqNoArr.length ==2){
				                        if (delSeqNoObj[ItemSeqNoArr[0]]){
					                        ErrMsg.push("第"+delSeqNoObj[ItemSeqNoArr[0]]+"行存在子序号，请核实!");
					                    }
				                    }else if(ItemSeqNoArr.length ==3){
					                    if (delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]){
						                    ErrMsg.push("第"+delSeqNoObj[ItemSeqNoArr[0]+"."+ItemSeqNoArr[1]]+"行存在子序号，请核实!");
					                    }
					                }
			                    }
		                    }
		                    if (ErrMsg.length>0){
								$.messager.popover({msg: ErrMsg.join("</br>"),type: 'error'});
								return false;
							}
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
								MethodName:"HandleReportItem",
								SaveDataArr:JSON.stringify(ids), event:"DELETE"
							},false);
					        if(value=="0"){
						       for (var i = 0; i < ids.length; i++) {
	                              var index=$('#ReportItemListTab').datagrid("getRowIndex",ids[i]);
	                              $('#ReportItemListTab').datagrid('deleteRow',index);
	                           }
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
					        }
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
				var ReportRowId=GetSelReportId();
				if (!ReportRowId){
					$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
	        		return false;
				}
				var MsgArr=[]; //错误信息提示数组
				var SeqNoVerify={}; //用来验证序号的父序号是否存在
				var SaveDataArr=[],ReportItemNameObj={},ReportItemSeqObj={};
				var rows=$("#ReportItemListTab").datagrid("getRows");
				for (var i=0;i<rows.length;i++){
					var editors = $("#ReportItemListTab").datagrid('getEditors', i);
					if (editors.length==0) {
						ReportItemNameObj[rows[i]["ReportItemName"]]=1;
						if (rows[i]["ReportItemSeqNo"]!=""){
							ReportItemSeqObj[rows[i]["ReportItemSeqNo"]]=1;
						}
						continue;
					}
					//var colIndex =0 
					var SSReportItemName = $.trim(editors[0].target.val());
					if(SSReportItemName==""){
						$.messager.popover({msg: '第'+(i+1)+'行 列名不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					var SSReportItemDataType = editors[1].target.combobox("getValue");
					if(SSReportItemDataType==""){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型不能为空!',type: 'error'});
						$(editors[1].target).next('span').find('input').focus();
						return false;
					};
					if (SSReportItemDataType=="ManualEntry" || SSReportItemDataType=="EmptyHeader" || SSReportItemDataType=="Query"){
						var SSReportItemLinkSource=editors[2].target.combobox("getText");
					}else{
						var SSReportItemLinkSource=editors[2].target.combobox("getValue");
						if ($.hisui.indexOfArray(editors[2].target.combobox("getData"),"SourceRowId",SSReportItemLinkSource)<0){
							$.messager.popover({msg: '第'+(i+1)+'行请在下拉框中选择关联数据！',type: 'error'});
							$(editors[2].target).next('span').find('input').focus();
							return false;
						}
					}
					if((SSReportItemLinkSource=="")&&(SSReportItemDataType!="ManualEntry")&&(SSReportItemDataType!="EmptyHeader")&&(SSReportItemDataType!="Query")){
						$.messager.popover({msg: '第'+(i+1)+'行关联数据不能为空!',type: 'error'});
						$(editors[2].target).next('span').find('input').focus();
						return false;
					};
					
					// 2022.5.20 add Query
					var SSQueryColumn = editors[3].target.combobox("getValue");
					if (SSQueryColumn == ""){
						if (SSReportItemDataType == "Query" && queryJson && queryJson !=""){
							$.messager.popover({msg: '第'+(i+1)+'行请在下拉框中选择绑定Query列！',type: 'error'});
							$(editors[3].target).next('span').find('input').focus();
							return false;
						}
					}
					
					var SSReportItemComponentType = editors[4].target.combobox("getValue");
					if (SSReportItemComponentType){
						if ($.hisui.indexOfArray(editors[4].target.combobox("getData"),"value",SSReportItemComponentType)<0){
							$.messager.popover({msg: '第'+(i+1)+'行请在下拉框中选择组件类型！',type: 'error'});
							$(editors[4].target).next('span').find('input').focus();
							return false;
						}
					}
					if ((SSReportItemComponentType=="")&&(SSReportItemDataType=="ManualEntry")){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型是手工录入时组件类型不能为空!',type: 'error'});
						$(editors[4].target).next('span').find('input').focus();
						return false;
					};
					var SSReportItemAlternativeVal=editors[5].target.val();
					if ((SSReportItemComponentType!="")&&(SSReportItemComponentType!="text")&&(!SSReportItemAlternativeVal)){
						$.messager.popover({msg: '第'+(i+1)+'行数据类型是单选或多选时备选值不能为空！',type: 'error'});
						$(editors[5].target).focus();
						return false;
					}
					var SSReportItemRequired=editors[6].target.checkbox("getValue")?"Y":"";
					var SSReportItemRowMerge=editors[7].target.checkbox("getValue")?"Y":"";
					var SSReportItemSeqNo=$.trim(editors[8].target.val());
					var SSReportItemWidth = $.trim(editors[9].target.val());
					
					// 2022.5.27 add
					var SSHidden = editors[10].target.checkbox("getValue")?"Y":"";
					var SSExpression = $.trim(editors[11].target.val());
					var SSNote = $.trim(editors[12].target.val());
							
					if (ReportItemNameObj[SSReportItemName]){
						//MsgArr.push('第'+(i+1)+'行列名重复！');  --列名可能会重复 不做校验
					}else{
						ReportItemNameObj[SSReportItemName]=1;
					}
					if (ReportItemSeqObj[SSReportItemSeqNo]){
						 MsgArr.push('第'+(i+1)+'行列排序重复！');
					}else if (SSReportItemSeqNo!=""){
						ReportItemSeqObj[SSReportItemSeqNo]=1;
						delete SeqNoVerify[SSReportItemSeqNo];
						var SeqNoArr=SSReportItemSeqNo.split(".");
						if (SeqNoArr.length ==2){
							if (!ReportItemSeqObj[SeqNoArr[0]]){
								SeqNoVerify[SeqNoArr[0]]='第'+(i+1)+'行序号 '+SSReportItemSeqNo+" 的父序号 "+SeqNoArr[0]+" 不存在！";
							}else{
								delete SeqNoVerify[SeqNoArr[0]];
							}
						}else if(SeqNoArr.length ==3){
							if (!ReportItemSeqObj[SeqNoArr[0]+"."+SeqNoArr[1]]){
								SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]]='第'+(i+1)+'行序号 '+SSReportItemSeqNo+" 的父序号 "+SeqNoArr[0]+"."+SeqNoArr[1]+" 不存在！";
							}else{
								delete SeqNoVerify[SeqNoArr[0]+"."+SeqNoArr[1]];
							}
						}
					}
					var ReportItemRowId = rows[i].ReportItemRowId;
					if (!ReportRowId) ReportItemRowId="";
					SaveDataArr.push({
						ReportRowId:ReportRowId,
						ReportItemRowId:ReportItemRowId,
						SSReportItemName:SSReportItemName,
						SSReportItemDataType:SSReportItemDataType,
						SSReportItemLinkSource:SSReportItemLinkSource,
						SSReportItemComponentType:SSReportItemComponentType,
						SSReportItemAlternativeVal:SSReportItemAlternativeVal,
						SSReportItemDelFlag:"N",
						SSReportItemRequired:SSReportItemRequired,
						SSReportItemRowMerge:SSReportItemRowMerge,
						SSReportItemSeqNo:SSReportItemSeqNo,
						SSReportItemWidth:SSReportItemWidth,
						SSQueryColumn:SSQueryColumn,
						SSHidden:SSHidden,
						SSExpression:SSExpression,
						SSNote:SSNote
					});
				}
				if (SaveDataArr.length==0){
					$.messager.popover({msg: "没有需要保存的数据！",type: 'error'});
					return false;
				}
				for (item in SeqNoVerify){
					MsgArr.push(SeqNoVerify[item]);
				}
				if (MsgArr.length>0){
					$.messager.popover({msg: MsgArr.join("</br>"),type: 'error'});
					return false;
				}
				$.m({ 
					ClassName:"Nur.NIS.Service.ReportV2.ReportConfig", 
					MethodName:"HandleReportItem",
					SaveDataArr:JSON.stringify(SaveDataArr),
					event:"SAVE"
				},function(rtn){
					if(rtn==0){
					   $("#ReportItemListTab").datagrid('unselectAll').datagrid('load');
					   $.messager.popover({msg: '保存成功!',type: 'success'});
					}else{
						$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
					    return false;
					}
				}); 
			}
	    }];
	var Columns=[[ 
		{ field: 'ReportItemRowId', checkbox:"true"},
		{ field: 'ReportItemName', title: '列名',width:130, editor : 
			{type : 'text',options : {required:true}}
		},
		{ field: 'ReportItemDataType', title: '数据类型',width:110, editor : 
			{
				type:'combobox',  
				options:{
					editable:false,
					mode: "local",
					data:ServerObj.ReportItemDataTypeJson,
					onSelect: function (rowIndex, rowData){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var sourceObj=$('#ReportItemListTab').datagrid('getEditor', {index:index,field:'ReportItemLinkSource'});
						sourceObj.target.combobox('setValue',"").combobox('reload');
					}
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemDataTypeDesc"];
			}
		},
		{ field: 'ReportItemLinkSource', title: '关联数据',width:150, editor : 
			{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.ReportV2.SourceConfig&QueryName=GetSourceConfigList&rows=999999",
					valueField:'SourceRowId',
					textField:'SourceDesc',
					loadFilter:function(data){
					    return data['rows'];
					},
					onBeforeLoad:function(param){
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var ReportItemDataType=""
						var editors = $('#ReportItemListTab').datagrid('getEditors', index); 
						if (editors[1]){
							var ReportItemDataType=editors[1].target.combobox('getValue');
						}
						if (ReportItemDataType=="") {
							var ReportItemDataType=$('#ReportItemListTab').datagrid("getData").rows[index].ReportItemDataType || "";
						}									
						param = $.extend(param,{
							SearchDesc:"",
							SearchType:ReportItemDataType,
							HospId:$HUI.combogrid('#_HospList').getValue(),
							SearchByType:"Y"
						});
					}
				 }
			},
			formatter: function(value,row,index){
				return row["ReportItemLinkSourceDesc"];
			}
		},
		{ field: 'QueryColumn', title: '绑定Query列',width:110, editor : 
			{
				type:'combobox',  
				options:{
					editable:true,
					mode: "local",
					data: queryJson,
					onSelect: function (rowIndex, rowData){
						/*
						var tr = $(this).closest('tr.datagrid-row');
      					var index= parseInt(tr.attr('datagrid-row-index'));
						var sourceObj=$('#ReportItemListTab').datagrid('getEditor', {index:index,field:'QueryColumn'});
						sourceObj.target.combobox('setValue',"").combobox('reload');
						*/
					}
				}
			},
			formatter: function(value,row,index){
				return row["QueryColumn"];
			}
		},
		{ field: 'ReportItemComponentType', title: '组件类型',width:80, editor : 
			{
				type:'combobox',  
				options:{
					//editable:false,
					mode: "local",
					data:ServerObj.ReportItemComponentTypeJson
				}
			},
			formatter: function(value,row,index){
				return row["ReportItemComponentTypeDesc"];
			}
		},
		{ field: 'ReportItemAlternativeVal', title: '备选值',width:180, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemRequired', title: '必填项',width:70, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			},
			formatter: function(value,row,index){
				return row["ReportItemRequired"] == "Y" ? "Y":"";
			}
		},

		{ field: 'ReportItemRowMerge', title: '数据行合并',width:100, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			},
			formatter: function(value,row,index){
				return row["ReportItemRowMerge"] == "Y" ? "Y":"";
			}
		},
		{ field: 'ReportItemSeqNo', title: '列排序',width:70, editor : 
			{
				type:'text'
			}
		},
		{ field: 'ReportItemWidth', title: '列宽',width:70, editor : 
			{
				type:'text'
			}
		},
		{ field: 'Hidden', title: '隐藏项',width:100, align:"center",editor : 
			{
				type:'icheckbox',
				options : {
                    on : 'Y',
                    off : ''
                }
			},
			formatter: function(value,row,index){
				return row["Hidden"] == "Y" ? "Y":"";
			}
		},
		{ 
			field: 'ReportItemCode', title: '数据集代码', width:200
		},
		{ field: 'Expression', title: '计算公式',width:300, editor : 
			{
				type:'text'
			}
		},
		{ field: 'Note', title: '备注',width:300, editor : 
			{
				type:'text'
			}
		}
	]];
	$('#ReportItemListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true,
		idField:"ReportItemRowId",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&QueryName=GetReportListItem&rows=999999",
		onBeforeLoad:function(param){
			$('#ReportItemListTab').datagrid("unselectAll");
			param = $.extend(param,{
				ReportRowId:GetSelReportId()
			});
		},
		onDblClickRow:function(rowIndex, rowData){ 
			//alert(queryJson)
			$('#ReportItemListTab').datagrid("beginEdit", rowIndex);
			var target=$('#ReportItemListTab').datagrid('getEditor',{'index':rowIndex,'field':'ReportItemAlternativeVal'}).target;
	        $(target).attr("placeHolder","多个选项用^分割");
       },
       onLoadSuccess:function(data){
           editRow_search = undefined;
       }
	})
}
//报表列表复制功能
function ReportCopyHandle(){
	var CopyReportCode = $.trim($("#CopyReportCode").val());
	var CopyReportName = $.trim($("#CopyReportName").val());
	var CopyReportProperty= $("#CopyReportProperty").combobox("getValue");
	if(CopyReportName==""){
		$.messager.popover({msg: '表单名称不能为空!',type: 'error'});
		$("#CopyReportName").focus();
		return false;
	};
	var selected = $("#ReportListTab").datagrid("getSelected");
	var CopyFromReportRowId=selected.ReportRowId;
	var CopyReportAddress = $("#CopyReportAddress").val();
	var CopyTemplateCode = $("#CopyTemplateCode").val();
	var CopyQueryInfo = $("#CopyQueryInfo").val();
	$.cm({
		ClassName:"Nur.NIS.Service.ReportV2.DataManager",
		MethodName:"CopyReport",
		CopyFromReportRowId:CopyFromReportRowId,
		// CopyReportCode:CopyReportCode,
		CopyReportName:CopyReportName,
		CopyReportProperty:CopyReportProperty,
		CopyReportAddress:CopyReportAddress,
		CopyTemplateCode:CopyTemplateCode,
		CopyQueryInfo:CopyQueryInfo
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

//初始化检索条件界面
function InitSearchCondition(){
	var ToolBar = [{
			text: '新增',
			iconCls: '	icon-add',
			handler: function() {
					var ReportRowId=GetSelReportId();
					if (!ReportRowId){
						$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
		        		return false;
					}
					if (editRow_search != undefined) {
	            		$.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
		        		return false;
					}
					var maxRow=$("#ReportSearchTab").datagrid("getRows");
					$("#ReportSearchTab").datagrid("appendRow", {
	                    CustomReportSearchChildSub: ''	                    
	                })
	                $("#ReportSearchTab").datagrid("beginEdit", maxRow.length-1);
		            var editors = $("#ReportSearchTab").datagrid('getEditors', maxRow.length-1);
					$(editors[0].target).focus();
					editRow_search=maxRow.length-1;

				}				
			},{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var ReportRowId=GetSelReportId();
				var selRows = $("#ReportSearchTab").datagrid("getSelections");
				if (selRows.length > 0) {
					$.messager.confirm("提示", "确定删除吗?",
	                function(r) {
	                    if (r) {

							var ids = [];
	                        for (var i = 0; i < selRows.length; i++) {
	                            var CustomReportSearchChildSub=selRows[i].CustomReportSearchChildSub;
	                            ids.push(CustomReportSearchChildSub);
	                        }
	                        var ID=ids.join(',');
	                        if (ID==""){
				                $("#ReportSearchTab").datagrid("rejectChanges").datagrid("unselectAll");
				                ReportRowId='';
				                return;
	                        }
	                        var value=$.m({ 
								ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
								MethodName:"UpdateReportSearch",
								event:"DELETE",
								ParRefs:ReportRowId,
								childsubs:ID,
							},false);
					        if(value=="0"){
	   					       $.messager.popover({msg: '删除成功!',type: 'success'});
	   					       $("#ReportSearchTab").datagrid('unselectAll').datagrid('load');
	   					       editRow_search=undefined;
					        }else if(value=="1"){
						       $("#ReportSearchTab").datagrid('unselectAll').datagrid('load');
					        }else{
						       $.messager.popover({msg: '删除失败:'+value,type: 'error'});
						       
					        }
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
				var ReportRowId=GetSelReportId();
				if (!ReportRowId){
					$.messager.popover({msg: '请先选择有效的表单！',type: 'error'});
	        		return false;
				}				
                var ids=[],names=[],keys=[],values=[];
                var controlTypeArr=[],controlValuesArr=[],controlWidthArr=[],reportItemIdVal=[];
                var sortNoArr=[]
               
				var rows=$("#ReportSearchTab").datagrid("getRows");
				var isRepeatFlag = false
				var varArray = []
				for (var i=0;i<rows.length;i++){
					if (rows[i].TemplateCode)
					{
						if (rows[i].TemplateCode !="custom")
						{
							// add code
							varArray.push(rows[i].TemplateCode);
						}
					}
					
					var editors = $("#ReportSearchTab").datagrid('getEditors', i);
					if (editors.length==0) {
					    //$.messager.popover({msg: '取不到编辑器',type: 'error'});
						continue;
					}			
					ids.push(rows[i].CustomReportSearchChildSub);
					
					var CRSItemCode = $.trim(editors[0].target.combobox("getValue"));
					if(CRSItemCode==""){
						$.messager.popover({msg: '第'+(i+1)+'行 变量名不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					
					// add code
					if (!rows[i].CustomReportSearchChildSub || rows[i].CustomReportSearchChildSub == "") // 不存在后台数据，才追加
					{
						if (CRSItemCode !="custom")
						{
							varArray.push(CRSItemCode);
						}
					}
					
					var CRSItemName = $.trim(editors[1].target.val());
					if(CRSItemName==""){
						$.messager.popover({msg: '第'+(i+1)+'行 名称不能为空!',type: 'error'});
						$(editors[0].target).focus();
						return false;
					};
					names.push(CRSItemName);
					var CRSItemKey = $.trim(editors[2].target.combobox("getValue"));
					if(CRSItemKey==""){
						$.messager.popover({msg: '第'+(i+1)+'行 类型不能为空!',type: 'error'});
						$(editors[1].target).focus();
						return false;
					};
					keys.push(CRSItemKey);
					var CRSInitialValue =$.trim(editors[3].target.combobox("getValue"));
					values.push(CRSInitialValue);	
					
					// 2022.6.1 new add
					var ControlTypeVal = editors[4].target.combobox("getValue");
					controlTypeArr.push(ControlTypeVal)
					
					var ControlValuesVal = editors[5].target.val();
					controlValuesArr.push(ControlValuesVal)
					
					var ControlWidthVal = editors[6].target.val();
					controlWidthArr.push(ControlWidthVal)
					
					var ReportItemIdVal = editors[7].target.combobox("getValue");
					reportItemIdVal.push(ReportItemIdVal)
					
					var SortNoVal = editors[8].target.val();
					sortNoArr.push(SortNoVal)
				}
				if (isRepeat(varArray))
				{	
				 	$.messager.popover({msg: '变量名不能重复！',type: 'error'});
		        	return false;	
				}
//				var id=ids.join(',');
//				var code=codes.join(',');
//				var name=names.join(',');
//				var key=keys.join(',');
//				var value=values.join(',');
				if (!names || names == "" || names.length == 0) 
				{
					editRow_search = undefined;
					return false;
				}
				$.m({ 
					ClassName:"Nur.NIS.Service.ReportV2.DataManager", 
					MethodName:"UpdateReportSearch",
					event:"SAVE",
					//SaveDataArr:JSON.stringify(SaveDataArr),
					ParRefs:ReportRowId,
					childsubs:ids.join(','), 
					code:CRSItemCode, 
					ItemName:names.join(','), 
					ItemKey:keys.join(','),
					InitialValue:values.join(','),
					ControlType:controlTypeArr.join(''),
					ControlValues:controlValuesArr.join(''),
					ControlWidth:controlWidthArr.join(''),
					ReportItemId:reportItemIdVal.join(''),
					SortNo:sortNoArr.join('')
					
				},function(rtn){
					if(rtn==0){
					   $("#ReportSearchTab").datagrid('unselectAll').datagrid('load');
					   $.messager.popover({msg: '保存成功!',type: 'success'});
					   editRow_search = undefined;

					}else{
						$.messager.popover({msg: '保存失败:'+rtn,type: 'error'});
						editRow_search = undefined;
					    return false;
					}
				}); 
			}
	    }];
	var ReportRowId2=GetSelReportId();
    setColumns = [[
			{field:'CustomReportSearchParRef',hidden:true},
			{field:'CustomReportSearchChildSub',checkbox:"true"},
			/*
			{field:'TemplateCode',title:'变量名',width:150,editor : 
			{
				type:'text'
			}},
			*/
			{
				field:'TemplateCode',
				title:'变量名',
				width:150,
				editor :
				{
					type:'combobox',  
					options:{
						editable:false,
						mode: "local",
						data:[{"text":"wardLocs","value":"wardLocs"},  // 定义变量名 TODO
							  {"text":"startDate","value":"startDate"},
							  {"text":"endDate","value":"endDate"},
							  {"text":"outFlag","value":"outFlag"},
							  {"text":"custom","value":"custom"}
							  ],
						onChange:function(nv,ov){ // 级联 
							// 获取当前编辑行索引
							var tr = $(this).closest('tr.datagrid-row');
        					var rindex = parseInt(tr.attr('datagrid-row-index'));
        					if (rindex >=0)
        					{
								var editors = $("#ReportSearchTab").datagrid('getEditors', rindex);
								// 设置初始值
								if (nv == "wardLocs")
								{
									editors[1].target.val("病区")
									editors[2].target.combobox("setValue","CTLocID")
								}
								if (nv == "startDate")
								{
									editors[1].target.val("开始日期")
									editors[2].target.combobox("setValue","AssessDate")
								}
								if (nv == "endDate")
								{
									editors[1].target.val("结束日期")
									editors[2].target.combobox("setValue","AssessDate")
								}
								if (nv == "outFlag")
								{
									editors[1].target.val("出院患者")
									editors[2].target.combobox("setValue","OutFlag")
								}
        					}
						}
					}
				},
				formatter: function(value,row,index){
					return row["TemplateCode"];
				}
			},
			{
				field:'ItemName',title:'名称',width:150,editor:{type:'text'}
			},
			{
				field:'ItemKey',
				title:'系统类型',
				width:150,
				editor :
				{
					type:'combobox',  
					options:{
						editable:false,
						mode: "local",
						//valueField:'ItemKey',
						//textField:'ItemKeyDesc',
						data:ServerObj.ReportItemKeyJson,
					}
				},
				formatter: function(value,row,index){
					return row["ItemKeyDesc"];
				}
			},
			{
				field:'InitialValue',title:'系统初始值',width:150,editor : 
				{
				type:'combobox',
				options:{
					editable:true,
					//valueField:'InitialValue',
					//textField:'InitialValueDesc',
					mode: "local",
					data:ServerObj.ReportInitialValueJson,
					}					
				},
				formatter: function(value,row,index){
					return row["InitialValueDesc"];
				}

			},
			{
				field:'ControlType',
				title:'控件类型',
				width:100,
				editor :
				{
					type:'combobox',  
					options:{
						editable:false,
						mode: "local",
						data:ServerObj.ControlTypeJson,
					}
				},
				formatter: function(value,row,index){
					return row["ControlTypeName"];
				}
			},
			{
				field:'ControlValues',title:'控件选项值',width:300,editor:{type:'text'}
			},
			{
				field:'ControlWidth',title:'控件宽度',width:80,editor:{type:'text'}
			},
			{
				field:'ReportItemId',
				title:'关联报表项',
				width:120,
				editor :
				{
					type:'combobox',  
					options:{
						editable:true,
						mode: "local",
						data:reportItemJson,
						//url:$URL+"?ClassName=Nur.NIS.Service.ReportV2.ReportConfig&MethodName=GetReportItemConfig&ReportId="+ReportRowId2+"&rows=999999",
					}
				},
				formatter: function(value,row,index){
					return row["ReportItemName"];
				}
			},
			{
				field:'SortNo',title:'排序号',width:55,editor:{type:'text'}
			},
			
				
			]];
	var Height = document.getElementById("ReportSearchTab-div").offsetHeight;	    
    setDataGrid = $('#ReportSearchTab').datagrid({	        
			//fit : true,
			//width : 'auto',

			height:Height,
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			loadMsg : '加载中..',  
			pagination : false, 
			rownumbers : true,
			nowrap:false,  /*此处为false*/
			
			field:'CustomReportSearchChildSub',
			toolbar :ToolBar,
			columns :setColumns,		
			url:$URL,
        	queryParams: {
            	ClassName: "Nur.NIS.Service.ReportV2.DataManager",
            	QueryName: "GetReportSearch",
        	},
        	onBeforeLoad:function(param){
				$('#ReportSearchTab').datagrid("unselectAll");
				param = $.extend(param,{
					ParRef:GetSelReportId()
				});
			},
			onDblClickRow:function(rowIndex, rowData){ 
            if (editRow_search != undefined) {
	            $.messager.popover({msg: '有正在编辑的行，请先点击保存!',type: 'error'});
		        return false;
				}
				$('#ReportSearchTab').datagrid("beginEdit", rowIndex);
				editRow_search=rowIndex;
			},
			onLoadSuccess:function(data){
                editRow_search = undefined;
			}
	});
}

function isRepeat(arr){
	if (arr && arr.length == 1) return false;
	var hash = {};
    for(var i in arr) {
        if(hash[arr[i]]) {
            return true;
        }
        // 不存在该元素，则赋值为true，可以赋任意值，相应的修改if判断条件即可
        hash[arr[i]] = true;
    }
    return false;
}