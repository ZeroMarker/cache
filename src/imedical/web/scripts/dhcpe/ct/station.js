
/*
 * FileName: dhcpe/ct/station.js
 * Author: xy
 * Date: 2021-11-05
 * Description: 站点维护-多院区
 */
var STlastIndex = "";
var STEditIndex = -1;
var tableName = "DHC_PE_Station";
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//初始化站点Grid 
	InitStationGrid();
	
	//科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	      BFind_click(); 		 
       }
	});
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
      
    $("#Code").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}		
      }); 
     
   $("#Desc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}		
      }); 
          
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
     });
    
     //新增（站点维护）
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //修改（站点维护）
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
     //保存（站点维护）
    $('#BSave').click(function(){
    	BSave_click();
    });
    
    // 关联数据
    $("#RelateLoc").click(function() {	
		BRelateLoc_click();		
    }); 

    // 标准化对照
    $("#RelateStandard").click(function() {  
        RelateStandard_click();     
    }); 
	
	// 标准化对照 搜索框
	$('#ExamItemCatGrid_search').searchbox({
		searcher:function(value,name){
			Public_gridsearch1 = searchText($("#ExamItemCatGrid"),value,Public_gridsearch1);
		}
	});
	
    //按钮操作权限（管控数据）
    DisableButton();
})


/*******************************站点start*************************************/
//按钮操作权限（管控数据）
function DisableButton(){
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
	if(flag=="S"){
		$('#RelateLoc').linkbutton('enable');
		$('#BSave').linkbutton('enable');
		$("#BUpdate").linkbutton('enable');
		$("#BAdd").linkbutton('enable');	
		$("#RelateStandard").linkbutton('enable');	
	}else{
		$('#RelateLoc').linkbutton('disable');
		$('#BSave').linkbutton('disable');
		$("#BUpdate").linkbutton('disable');
		$("#BAdd").linkbutton('disable');
		$("#RelateStandard").linkbutton('disable');
	}
}

//查询
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationNew",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		LocID:LocID
	});	
}

//清屏
function BClear_click()
{
	var LocID=session['LOGON.CTLOCID'];
	$("#Code,#Desc,#StationID").val("");
	$("#LocList").combobox('setValue',LocID);
	BFind_click();
	
}

//数据关联科室
function BRelateLoc_click()
{	
	var DateID=$("#StationID").val();
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}   
   var LocID=$("#LocList").combobox('getValue');
   //var LocID=session['LOGON.CTLOCID'];
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitStationGrid)
}

//标准化对照
function RelateStandard_click()
{
    var DateID=$("#StationID").val();
    if (DateID==""){
        $.messager.alert("提示","请选择需要对照的记录","info"); 
        return false;
    }
    $("#StandardWin").show();
    $("#ExamItemCatGrid_search").searchbox("setValue",'');
    var StandardWin = $HUI.dialog("#StandardWin", {
        width: 550,
        modal: true,
        height: 450,
        iconCls: '',
        title: '标准化对照',
        resizable: true,
        buttonAlign: 'center',
        buttons: [{
            iconCls: 'icon-w-save',
            text: '对照',
            id: 'save_btn',
            handler: function() {
                var selected = $('#ExamItemCatGrid').datagrid('getSelected');
                if(selected==null){
                    $.messager.alert("提示", "请选择标准分类！", "info");
                    return false;
                }
                $.m({
					ClassName: "web.DHCPE.CT.Station",
					MethodName: "UpdateEx",
					ID:DateID,
					Code: selected.EICCode,
					Desc: selected.EICDesc
                }, function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('提示', '保存成功', 'success');
					}
					
					LoadStaionGrid();
					$HUI.dialog("#StandardWin").close();
				});
            }
        },{
            iconCls: 'icon-w-close',
            text: '关闭',
            handler: function() {
                $HUI.dialog("#StandardWin").close()
            }
        }],
        onOpen: function() {
			// 初始化DataGrid
			$('#ExamItemCatGrid').datagrid({
				url:$URL,
				fit : true,
				border : false,
				striped : true,
				nowrap:true,
				fitColumns : false,
				autoRowHeight : false,
				rownumbers:true,
				pagination : true,
				loadMsg:'数据加载中...',
				pageSize: 20,
				pageList : [20,100,200],
				rownumbers : true,
				singleSelect: true,
				selectOnCheck: true,
				columns: [[
					{ field:'EICRowId', title:'EICRowId', hidden:true }
					,{ field:'EICCode', width: 70, title:'内部编码', sortable: true, resizable: true }
					,{ field:'EICDesc', width: 100, title:'分类描述', sortable: true, resizable: true }
					,{ field:'EICDesc2', width: 200, title:'别名', sortable: true, resizable: true }
					,{ field:'EICSort', width: 60, title:'顺序号', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QueryExamItemCat",
					aType:"ST"
				},
				onLoadSuccess: function (data) {
					Public_gridsearch1 = [];
				}
			});
        }
    });
}

//新增
function BAdd_click()
 {
	STlastIndex = $('#StaionGrid').datagrid('getRows').length - 1;
	$('#StaionGrid').datagrid('selectRow', STlastIndex);
	
	var selected = $('#StaionGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((STEditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#StaionGrid').datagrid('appendRow', {
		TID: '',
		TCode: '',
		TDesc: '',
	});
	STlastIndex = $('#StaionGrid').datagrid('getRows').length - 1;
	$('#StaionGrid').datagrid('selectRow', STlastIndex);
	$('#StaionGrid').datagrid('beginEdit', STlastIndex);
	STEditIndex = STlastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#StaionGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StaionGrid').datagrid('getRowIndex', selected);
		if ((STEditIndex != -1) && (STEditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#StaionGrid').datagrid('beginEdit', thisIndex);
		$('#StaionGrid').datagrid('selectRow', thisIndex);
		STEditIndex = thisIndex;
		var selected = $('#StaionGrid').datagrid('getSelected');

		var STthisEd = $('#StaionGrid').datagrid('getEditor', {
				index: STEditIndex,
				field: 'TCode'  
			});
			
			
		var STthisEd = $('#StaionGrid').datagrid('getEditor', {
				index: STEditIndex,
				field: 'TDesc'  
			});
		
	}
 }

//保存
function BSave_click()
{
	var UserID=session['LOGON.USERID'];
	$('#StaionGrid').datagrid('acceptChanges');
	var selected = $('#StaionGrid').datagrid('getSelected');
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TCode == "undefined") || (selected.TDesc == "undefined")||(selected.TCode == "") ||(selected.TDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				LoadStaionGrid();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "Insert",
				Code: selected.TCode,
				Desc: selected.TDesc,
				UserID:UserID
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.alert('提示', '保存成功', 'success');		
				}

				LoadStaionGrid();
			});
		} else {
			$('#StaionGrid').datagrid('selectRow', STEditIndex);
			var selected = $('#StaionGrid').datagrid('getSelected');
			if ((selected.TCode == "undefined") || (selected.TDesc == "undefined")||(selected.TCode == "") ||(selected.TDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				LoadStaionGrid();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.Station",
				MethodName: "Update",
				ID: selected.TID,
				Code: selected.TCode,
				Desc: selected.TDesc,
				UserID:UserID
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('提示', '修改成功', 'success');
					
				}
			
				LoadStaionGrid();
			});
		}
	}
}

function LoadStaionGrid()
{
	 $("#StaionGrid").datagrid('reload');
}

var StationColumns = [[
	{
		field:'TID',
		title:'TID',
		hidden:true
	},{  
		field:'TCode',
		width: '150',
		title:'代码',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	 },{  
		field:'TDesc',
		width: '300',
		title:'描述',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			 }
		}
	},{ 
		field:'TEffPowerFlag',
		width:'100',
		align:'center',
		title:'当前科室授权',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	},{
		field:'TSTKBItemCatDesc',
		width:200,
		title:'知识库分类描述'
	}		
]];

// 初始化站点维护DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//隐藏分页下面的文字"显示几页到几页,共多少条数据" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationNew",
			LocID:LocID	
		},
		onSelect: function (rowIndex,rowData) {
			$("#StationID").val(rowData.TID);
		},
		onLoadSuccess: function (data) {
			STEditIndex = -1;
		}
	});
}
/*******************************站点end*************************************/

