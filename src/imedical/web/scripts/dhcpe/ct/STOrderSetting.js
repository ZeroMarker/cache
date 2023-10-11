/*
 * FileName: STOrderSetting.js
 * Author: zhufei
 * Date: 2021-12-07
 * Description: 站点医嘱项设置
 */
var Public_layer_ID = "";
var Public_gridsearch1 = [];
var Public_gridsearch2 = [];
var Public_gridsearch3 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){
	//初始化表格
    InitGridSTOrder();
    InitGridARCIM();
	$('#gridSTOrder').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	$('#gridARCIM').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	
	$('#gridSTOrder_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#gridSTOrder"),value,Public_gridsearch1);
		}
	});
	
	$('#gridARCIM_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch2 = searchText($("#gridARCIM"),value,Public_gridsearch2);
		}
	});
	
	//获取科室下拉列表
	GetLocComp(SessionStr);
	Common_ComboToExamItemCode("cboExamItemCode2"); //标准项目
	Common_ComboToReportFormat("cboReportFormat2");	//报告格式
	
	//科室联动
	$HUI.combobox('#LocList',{
	    onSelect:function(row){
			//联动站点下拉列表
			Common_ComboToStation("cboStation");
			//联动医嘱子类下拉列表
			Common_ComboToARCIC("cboARCItemCat");
			//联动导诊单类别下拉列表
			Common_ComboToUsherItemCat("cboUsherItemCat");
			Common_ComboToUsherItemCat("cboUsherItemCat2");
	    }
    });
	
	//站点联动
	$HUI.combobox('#cboStation',{
	    onSelect:function(row){
			LoadGridSTOrder();
	    }
    });
	
	//医嘱子类联动
	$HUI.combobox('#cboARCItemCat',{
	    onSelect:function(row){
			LoadGridARCIM();
	    }
    });
	
	
    //设置
    $("#btnSetting").click(function() {
		/***只能单个导入 start***/
		//var ARCIMID = $("#gridARCIM_ID").val();
		//AddSTOrder(ARCIMID);
		/***只能单个导入 end***/

		/***支持批量导入 start***/
		var UserID=session['LOGON.USERID'];

		var LocID = $("#LocList").combobox('getValue');
		if (!LocID){
			$.messager.alert('提示', "请选择科室", 'info');
       	 	return;
		}
		var ARCICID = $("#cboARCItemCat").combobox('getValue');
		if (!ARCICID){
			$.messager.alert('提示', "请选择医嘱子分类", 'info');
        	return;
		}
		
    	var ARCIMIDStr=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
    	if(ARCIMIDStr==""){
	    	$.messager.alert('提示', "请勾选医嘱项！", 'info');
        	return;
    	}
    	var ARCIMIDArr=ARCIMIDStr.split("^");
    	var ARCIMLength=ARCIMIDStr.split("^").length;
	    for ( var i = 1; i <=ARCIMLength; i++) {
		    if(i==ARCIMLength){ 
			    //选择的项目设置成功后，清理选中的医嘱项
    			var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,"");
    			LoadGridARCIM()    
		    }else{
		    	AddSTOrder(ARCIMIDArr[i]);
		    }
		    
		    
	    } 
		/***支持批量导入 end***/

    });
	
    //删除
    $("#btnDelete").click(function() {
		var ID = $("#gridSTOrder_ID").val();
		DeleteSTOrder(ID);
    });
	
    //修改
    $("#btnUpdate").click(function() {
		var rd = $('#gridSTOrder').datagrid('getSelected');
		winExamItemCodeEdit_layer(rd);
    });
	
    //生成站点项目
    $("#btnNewStationOrder").click(function() {
		var ID = $("#gridSTOrder_ID").val();
		NewStationOrder(ID);
    });
	
    //批量生成站点项目
    $("#btnBatchNewStationOrder").click(function() {
		BatchNewStationOrder();
    });
	
	//弹出框-初始化
	InitWinExamItemCodeEdit();
})

//生成站点项目
function NewStationOrder(ID){
	if (!ID){
		$.messager.alert('提示', "请选择生成站点项目记录", 'info');
        return;
	}
	$.messager.confirm("确认", "确定要生成站点项目记录吗？", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "NewStationOrder",
				aID:ID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					if (parseInt(rtn)==-100) {
						$.messager.alert('提示', '站点医嘱项无效', 'error');
					} else if (parseInt(rtn)==-101) {
						$.messager.alert('提示', '站点医嘱项设置不允许重复生成站点项目', 'error');
					} else if (parseInt(rtn)==-102) {
						$.messager.alert('提示', '已存在站点项目组合信息，不允许重复添加', 'error');
					} else if (parseInt(rtn)==-103) {
						$.messager.alert('提示', '常规检查项目必须关联标准项目', 'error');
					}else {
						$.messager.alert('提示', '生成站点项目失败', 'error');
					}
				} else {
					$.messager.popover({msg:'生成站点项目成功',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//批量生成站点项目
function BatchNewStationOrder(){
	var LocID = $("#LocList").combobox('getValue');
	var StationID = $("#cboStation").combobox('getValue');
	if (!LocID){
		$.messager.alert('提示', "请选择生成科室", 'info');
        return;
	}
	if (!StationID){
		$.messager.alert('提示', "请选择生成站点", 'info');
        return;
	}
	$.messager.confirm("确认", "确定要批量生成站点项目吗？", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "BatchNewStationOrder",
				aLocID:LocID,
				aStationID:StationID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					$.messager.alert('提示', '批量生成站点项目失败', 'error');
				} else {
					$.messager.popover({msg:'批量生成站点项目成功',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//设置操作
function AddSTOrder(ARCIMID){
	if (!ARCIMID){
		$.messager.alert('提示', "请选择设置医嘱项", 'info');
        return;
	}
	var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('提示', "请选择科室", 'info');
        return;
	}
	var StationID = $("#cboStation").combobox('getValue');
	if (!StationID){
		$.messager.alert('提示', "请选择站点", 'info');
        return;
	}
    var ItemCode = Common_GetValue("cboExamItemCode2");
    var ItemDesc = Common_GetText("cboExamItemCode2");
    var ReportFormat = Common_GetValue("cboReportFormat2");
	if (!ReportFormat){
		$.messager.alert('提示', "请选择报告格式", 'info');
        return;
	}
    var UsherItemCatDR = Common_GetValue("cboUsherItemCat2");
	if (!UsherItemCatDR){
		$.messager.alert('提示', "请选择导诊单类别", 'info');
        return;
	}
	var InputStr = ARCIMID + "^" + LocID + "^" + StationID + "^" + session['LOGON.USERID'] + "^" + ItemCode + "^" + ItemDesc + "^" + ReportFormat + "^" + UsherItemCatDR;
	
	$.m({
		ClassName: "web.DHCPE.CT.STOrderSetting",
		MethodName: "AddSTOrder",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<0) {
			if (parseInt(rtn)==-101){
				$.messager.alert('提示', '站点医嘱项记录不允许重复添加', 'error');
			} else if (parseInt(rtn)==-102){
				$.messager.alert('提示', '已存在站点项目组合信息，不允许重复添加', 'error');
			} else if (parseInt(rtn)==-103){
				$.messager.alert('提示', '医嘱项与站点不符，不允许添加', 'error');
			} else {
				$.messager.alert('提示', '站点医嘱项添加失败', 'error');
			}
		} else {
			$.messager.popover({msg:'站点医嘱项添加成功',type:'success',timeout: 1000});
			LoadGridSTOrder();
		}
	})
}

//删除操作
function DeleteSTOrder(ID){
	if (!ID){
		$.messager.alert('提示', "请选择删除记录", 'info');
        return;
	}
	$.messager.confirm("确认", "确定要删除记录吗？", function(r){
		if (r){
			$.m({
				ClassName: "web.DHCPE.CT.STOrderSetting",
				MethodName: "DeleteSTOrder",
				aId:ID
			}, function (rtn) {
				if (parseInt(rtn)<0) {
					if (parseInt(rtn)==-101) {
						$.messager.alert('提示', '已生成站点项目不允许删除', 'error');
					} else {
						$.messager.alert('提示', '删除站点医嘱项失败', 'error');
					}
				} else {
					$.messager.popover({msg:'删除站点医嘱项成功',type:'success',timeout: 1000});
					LoadGridSTOrder();
				}
			})
		}
	})
}

//弹出框-保存操作
function winExamItemCodeEdit_btnSave_click(){
	var ID = Public_layer_ID;
    var OrderType = Common_GetValue("cboOrderType");
    var ItemCode = Common_GetValue("cboExamItemCode");
    var ItemDesc = Common_GetText("cboExamItemCode");
    var Active = (Common_GetValue("chkActive") ? 'Y' : 'N');
    var ReportFormat = Common_GetValue("cboReportFormat");
    var UsherItemCatDR = Common_GetValue("cboUsherItemCat");
	
	if (!ReportFormat){
		$.messager.alert('提示', "请选择报告格式", 'info');
        return;
	}
	if (!UsherItemCatDR){
		$.messager.alert('提示', "请选择导诊单类别", 'info');
        return;
	}
	var InputStr = ID + "^" + OrderType + "^" + ItemCode + "^" + ItemDesc + "^" + Active + "^" + session['LOGON.USERID'] + "^" + ReportFormat + "^" + UsherItemCatDR;
	
	$.m({
		ClassName: "web.DHCPE.CT.STOrderSetting",
		MethodName: "EditSTOrder",
		aInputStr:InputStr,
		aDelimiter:"^"
	}, function (rtn) {
		if (parseInt(rtn)<1) {
			if (parseInt(rtn)==-101) {
				$.messager.alert('提示', '已生成站点项目不允许编辑', 'error');
			}
			$.messager.alert('提示', '编辑站点医嘱项失败', 'error');
		} else {
			$.messager.popover({msg:'编辑站点医嘱项成功',type:'success',timeout: 1000});
			$HUI.dialog('#winExamItemCodeEdit').close();
			LoadGridSTOrder();
		}
	})
}

//弹出框-Open操作
function winExamItemCodeEdit_layer(rd){
	if(rd){
		Public_layer_ID = rd['ID'];
		Common_SetValue('chkActive',(rd['Active']=='Y'));
		//Common_SetValue('cboOrderType',rd['OrderType'],rd['OrderTypeDesc']);
		//Common_SetValue('cboExamItemCode',rd['ItemCode'],rd['ItemDesc']);
		//Common_SetValue('cboReportFormat',rd['ReportFormat'],rd['ReportFormatDesc']);
		//Common_SetValue('cboUsherItemCat',rd['UsherItemCatID'],rd['UsherItemCatDesc']);
		$("#cboOrderType").combobox('select',rd['OrderType']);
		$("#cboExamItemCode").combobox('select',rd['ItemCode']);
		$("#cboReportFormat").combobox('select',rd['ReportFormat']);
		$("#cboUsherItemCat").combobox('select',rd['UsherItemCatID']);
	}else{
		Public_layer_ID = "";
		Common_SetValue('chkActive',0);
		Common_SetValue('cboOrderType','','');
		Common_SetValue('cboExamItemCode','','');
		Common_SetValue('cboReportFormat','','');
		Common_SetValue('cboUsherItemCat','','');
	}
	$HUI.dialog('#winExamItemCodeEdit').open();
}

function InitWinExamItemCodeEdit(){
	//初始化编辑窗
	$('#winExamItemCodeEdit').dialog({
		title: '标准项目',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text: $g('保存'),
			handler:function(){
				winExamItemCodeEdit_btnSave_click();
			}
		},{
			text:$g('关闭'),
			handler:function(){
				$HUI.dialog('#winExamItemCodeEdit').close();
			}
		}]
	});
	//初始化表单控件（下拉框）
	Common_ComboToOrderType("cboOrderType");
	Common_ComboToExamItemCode("cboExamItemCode");
	Common_ComboToReportFormat("cboReportFormat");	//报告格式
	Common_ComboToUsherItemCat("cboUsherItemCat");	//导诊单类别
}

function LoadGridSTOrder(){
	$('#gridSTOrder').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"web.DHCPE.CT.STOrderSetting",
		QueryName:"QrySTOrder",
		aLocID:$("#LocList").combobox('getValue'),
		aStationID:$("#cboStation").combobox('getValue'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridSTOrder').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
	});
}

function InitGridSTOrder(){
    // 初始化DataGrid
    $('#gridSTOrder').datagrid({
		fit: true,
		//title: "站点医嘱项",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //控制是否显示横向滚动条
        columns: [[
            { field:'ID', title:'ID', hidden:true }
			,{ field:'ItmMastDR', width: 80, title:'医嘱项ID', sortable: true, resizable: true}
			,{ field:'ItmMastDesc', width: 180, title:'医嘱项', sortable: true, resizable: true}
			//,{ field:'LocDesc', width: 60, title:'科室', sortable: true, resizable: true}
			,{ field:'ItmCatDesc', width: 80, title:'医嘱分类', sortable: true, resizable: true}
			,{ field:'OrderTypeDesc', width: 60, title:$g('医嘱<br>类型'), sortable: true, resizable: true}
			,{ field:'StationDesc', width: 80, title:'站点', sortable: true, resizable: true}
			,{ field:'ReportFormatDesc', width: 100, title:'报告格式', sortable: true, resizable: true}
			,{ field:'UsherItemCatDesc', width: 100, title:'导诊单类别', sortable: true, resizable: true}
			,{ field:'ItemDesc', width: 100, title:'标准体检项目', sortable: true, resizable: true}
			,{ field:'ActiveDesc', width: 50, title:$g('是否<br>有效'), sortable: true, resizable: true}
			,{ field:'UpdateDate', width: 90, title:'更新日期', sortable: true, resizable: true}
			,{ field:'UpdateTime', width: 80, title:'更新时间', sortable: true, resizable: true}
			,{ field:'UpdateUser', width: 80, title:'更新人', sortable: true, resizable: true}
			,{ field:'NewOrdFlagDesc', width: 50, title:$g('生成<br>标记'), sortable: true, resizable: true}
			,{ field:'NewOrdDate', width: 90, title:'生成日期', sortable: true, resizable: true}
			,{ field:'NewOrdTime', width: 80, title:'生成时间', sortable: true, resizable: true}
			,{ field:'NewOrdUser', width: 80, title:'操作人', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnUpdate").linkbutton("disable");
					$("#btnDelete").linkbutton("disable");
					$("#btnNewStationOrder").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnUpdate").linkbutton("enable");
					$("#btnDelete").linkbutton("enable");
					$("#btnNewStationOrder").linkbutton("enable");
				}
			}
        },
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				winExamItemCodeEdit_layer(rowData);
			}
		},
        onLoadSuccess: function (data) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch1 = [];
			$("#btnUpdate").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnNewStationOrder").linkbutton("disable");
			$("#btnBatchNewStationOrder").linkbutton("enable");
        }
    });
}


function LoadGridARCIM(){
	//$('#gridARCIM').datagrid('loadData',{ 'total':'0',rows:[]});  //初始加载显示记录为0
	$cm ({
		ClassName:"web.DHCPE.CT.STOrderSetting",
		QueryName:"QryARCIM",
		aLocID:$("#LocList").combobox('getValue'),
		aARCICID:$("#cboARCItemCat").combobox('getValue'),
		page:1,
		rows:9999
	},function(rs){
		$('#gridARCIM').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
		//$('#gridARCIM').datagrid().datagrid('loadData', rs);
		var LocID = $("#LocList").combobox('getValue');
	var ARCICID = $("#cboARCItemCat").combobox('getValue');
	       
    $("#gridARCIM").datagrid('unselectAll');
	var info=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
		var objtbl = $("#gridARCIM").datagrid('getRows');
		if (objtbl) {
		 	//遍历datagrid的行            
		 		$.each(objtbl, function (index) { 
		 		
	        		if(info.indexOf("^"+objtbl[index].ID+"^")>=0){
		        		//alert(objtbl[index].ID)
				 		//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 		$('#gridARCIM').datagrid('checkRow',index);
					 }
			   });
		}
			
	});

}

function InitGridARCIM(){
    // 初始化DataGrid
    $('#gridARCIM').datagrid({
		fit: true,
		//title: "医嘱项列表",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,100,200],
		nowrap:true,
		fitColumns: false,  //控制是否显示横向滚动条
        columns: [[
             { field:'ID', checkbox:true }
			,{ field:'Desc', width: 240, title:'医嘱项名称', sortable: true, resizable: true}
			,{ field:'OrderTypeDesc', width: 50, title:$g('医嘱<br>类型'), sortable: true, resizable: true}
			,{ field:'ItmCatDesc', width: 80, title:'医嘱子类', sortable: true, resizable: true}
			,{ field:'OrdCatDesc', width: 80, title:'医嘱大类', sortable: true, resizable: true}
		]],
        onSelect: function (rowIndex, rowData) {
			if (rowIndex>-1) {
				var SelectVal = rowData["ID"];
				var cmp = "#"+this.id+"_ID";
				if (SelectVal == $(cmp).val()){
					$(cmp).val("");
					$("#btnSetting").linkbutton("disable");
					$("#"+this.id).datagrid("clearSelections");
				} else {
					$(cmp).val(SelectVal);
					$("#btnSetting").linkbutton("enable");
				}
			}
        },
		 //选中行函数
		onCheck:function(rowIndex,rowData){
				AddSelectItem(rowIndex,rowData); 
				
			},
        //取消选中行函数	
		onUncheck:function(rowIndex,rowData){
				RemoveSelectItem(rowIndex,rowData);
			},
		onCheckAll: function (rows) { 
				//遍历datagrid的行 
		 		$.each(rows, function (index) {
			 		$('#gridARCIM').datagrid('checkRow',index);
			 	});
			 		
				
		},
		onUncheckAll: function (rows) { 
				//遍历datagrid的行 
		 		$.each(rows, function (index) {
			 		$('#gridARCIM').datagrid('uncheckRow',index);
			 	});	 		
				
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				var ARCIMID = rowData["ID"];
				AddSTOrder(ARCIMID);
			}
		},
        onLoadSuccess: function (rowData) {
			$("#"+this.id+"_ID").val("");
			Public_gridsearch2 = [];
			$("#btnSetting").linkbutton("disable");
			
			var LocID = $("#LocList").combobox('getValue');
	        var ARCICID = $("#cboARCItemCat").combobox('getValue');
			$("#gridARCIM").datagrid('unselectAll');
			var info=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","GetAddSTOrderStr",LocID,ARCICID);
	    	var objtbl = $("#gridARCIM").datagrid('getRows');
	        if (rowData) {
		         //遍历datagrid的行            
		 		$.each(rowData.rows, function (index) { 
	        		if(info.indexOf(objtbl[index].ID)>=0){
				 		//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 		$('#gridARCIM').datagrid('checkRow',index);
					 }
			   });
	        }
        }
    });
}
var SelectItems=[];

function FindSelectItem(ID) { 
 	//alert("SelectItems.length:"+SelectItems.length)
      for (var i = 0; i < SelectItems.length; i++) { 
            if (SelectItems[i] == ID) return i; 
         } 
       return -1; 
  } 

function AddSelectItem(rowIndex,rowData)
{
	 var SelectIds="";
	
     if (FindSelectItem(rowData.ID) == -1) { 
         SelectItems.push(rowData.ID);  	
      }
                
      for (var i = 0; i < SelectItems.length; i++) { 
          if(SelectIds==""){
	          var SelectIds="^"+SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }
               
       }              
    
    var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('提示', "请选择科室", 'info');
        return;
	}
    var ARCICID = $("#cboARCItemCat").combobox('getValue');
	if (!ARCICID){
		$.messager.alert('提示', "请选择医嘱子分类", 'info');
        return;
	}
	if(SelectIds!=""){
		$("#btnSetting").linkbutton("enable");
	}else{
		$("#btnSetting").linkbutton("disable");
	}
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,SelectIds);
	  
}

function RemoveSelectItem(rowIndex, rowData) { 

    var SelectIds="";
    
    var k = FindSelectItem(rowData.ID); 
    
    if (k != -1) { 
             SelectItems.splice(k,1);
      } 
      
     
    for (var i = 0; i < SelectItems.length; i++) { 
           if(SelectIds==""){
	          var SelectIds="^"+SelectItems[i];
          }else{
	          var SelectIds=SelectIds+"^"+SelectItems[i];
          }  
      }
      
	 if(SelectIds=="^"){var SelectIds="";}
	
	 if(SelectIds!=""){
		$("#btnSetting").linkbutton("enable");
	}else{
		$("#btnSetting").linkbutton("disable");
	}
    var LocID = $("#LocList").combobox('getValue');
	if (!LocID){
		$.messager.alert('提示', "请选择科室", 'info');
        return;
	}
	var ARCICID = $("#cboARCItemCat").combobox('getValue');
	if (!ARCICID){
		$.messager.alert('提示', "请选择医嘱子分类", 'info');
        return;
	}
	var UserID=session['LOGON.USERID'];
    var flag=tkMakeServerCall("web.DHCPE.CT.STOrderSetting","SetAddSTOrderStr",LocID,UserID,ARCICID,SelectIds);
                     
  } 
 
//创建站点下拉框
function Common_ComboToStation(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'TID',
		textField: 'TDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'web.DHCPE.CT.Station';
			param.QueryName = 'FindStation';
			param.Code = "";
			param.Desc = "";
			param.LocID = $("#LocList").combobox('getValue');
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['TID']);
			}
		}
	});
	return  cbox;
}

//创建医嘱子类下拉框
function Common_ComboToARCIC(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'web.DHCPE.CT.STOrderSetting';
			param.QueryName = 'QryARCIC';
			param.aLocID = $("#LocList").combobox('getValue');
			param.aAlias = "";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	return  cbox;
}

//创建标准项目下拉框
function Common_ComboToExamItemCode(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'Code',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'web.DHCPE.CT.STOrderSetting';
			param.QueryName = 'QryExamItemCode';
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['Code']);
			}
		}
	});
	return  cbox;
}

//创建数据格式下拉框
function Common_ComboToOrderType(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Desc: $g('检验'), Code: 'L' }
			,{ Desc: $g('检查'), Code: 'X' }
			,{ Desc: $g('药品'), Code: 'R' }
			,{ Desc: $g('耗材'), Code: 'M' }
			,{ Desc: $g('其他'), Code: 'N' }
		],
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['Code']);
			}
		},
		defaultFilter:0
	});
	return  cbox;
}

//创建导诊单类别下拉框
function Common_ComboToUsherItemCat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'id',
		textField: 'desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'web.DHCPE.CT.HISUICommon';
			param.QueryName = 'FindPatItem';
			param.LocID = $("#LocList").combobox('getValue');
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['id']);
			}
		}
	});
	return  cbox;
}

//创建报告格式下拉框
function Common_ComboToReportFormat(){
	var ItemCode = arguments[0];
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		valueField: 'Code',
		textField: 'Desc',
		panelHeight:"auto",
		data: [
			{ Code: 'RF_CAT', Desc: $g('打印格式 多层') }
			,{ Code: 'RF_LIS', Desc: $g('打印格式 检验')}
			,{ Code: 'RF_NOR', Desc: $g('打印格式 默认')}
			,{ Code: 'RF_RIS', Desc: $g('打印格式 检查')}
			,{ Code: 'RF_EKG', Desc: $g('打印格式 心电')}
			,{ Code: 'RF_PIS', Desc: $g('打印格式 病理')}
		],
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['Code']);
			}
		},
		defaultFilter:0
	});
	return  cbox;
}

