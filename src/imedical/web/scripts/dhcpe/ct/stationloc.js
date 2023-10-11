
/*
 * FileName: dhcpe/ct/stationloc.js
 * Author: xy
 * Date: 2021-08-10
 * Description: 站点分类维护
 */
var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_StationLoc";
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//初始化站点Grid 
	InitStationGrid();
	 
	//初始化站点分类Grid 
	InitStationLocGrid();
	
   //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
	      BFind_click();
	      $('#StationID,#SLDesc,#Desc,#STLocID').val("");
		  BLFind_click();	 		 
       }
		
	});
	
	//查询（站点）
	$("#BFind").click(function() {	
		BFind_click();
			
     });
           
	 
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
	
    //查询（站点分类维护）
	$("#BLFind").click(function() {	
		BLFind_click();		
     });
         
    	 
	$("#SLDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BLFind_click();
		}
	});


	   
     //新增（站点分类维护）
	$("#BLAdd").click(function() {	
		BLAdd_click();		
     });
        
    //修改（站点分类维护）
	$("#BLUpdate").click(function() {	
		BLUpdate_click();		
     });
         
     //保存（站点分类维护）
     $('#BLSave').click(function(){
    	BLSave_click();
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

/*******************************站点分类维护start*************************************/

//按钮操作权限（管控数据）
function DisableButton(){
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var flag = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetUserPower",UserID,GroupID);
	
	if(flag=="S"){
		$('#RelateLoc').linkbutton('enable');
		$('#BLSave').linkbutton('enable');
		$("#BLUpdate").linkbutton('enable');
		$("#BLAdd").linkbutton('enable');	
		$("#RelateStandard").linkbutton('enable');	
	}else{
		$('#RelateLoc').linkbutton('disable');
		$('#BLSave').linkbutton('disable');
		$("#BLUpdate").linkbutton('disable');
		$("#BLAdd").linkbutton('disable');
		$("#RelateStandard").linkbutton('disable');
	}
}



//数据关联科室
function BRelateLoc_click()
{	
	var STLocID=$('#STLocID').val();
	if (STLocID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}   
   var LocID=$("#LocList").combobox('getValue');
   //var LocID=session['LOGON.CTLOCID'];
   OpenLocWin(tableName,STLocID,SessionStr,LocID,InitStationLocGrid) 
    
}

function RelateStandard_click()
{
    var STLocID=$('#STLocID').val();
    if (STLocID==""){
        $.messager.alert("提示","请选择需要对照的记录","info"); 
        return false;
    }   
    $("#StandardWin").show();
	$('#ExamItemCatGrid_search').searchbox("setValue",'');
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
                
                if(selected==null)
                {
                    $.messager.alert("提示", "请选择标准分类！", "info");
                    return false;
                }
                $.m({
                ClassName: "web.DHCPE.CT.StationLoc",
                MethodName: "UpdateStationLocEx",
                ID:STLocID,
                Code: selected.EICCode,
                Desc: selected.EICDesc
            
                }, function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('提示', '保存成功', 'success');      
					}
					
					$("#StationLocGrid").datagrid('reload');
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
				fitColumns : false,
				autoRowHeight : false,
				rownumbers:true,
				pagination : true,
				pageSize: 20,
				pageList : [20,100,200],  
				rownumbers : true,  
				singleSelect: true,
				selectOnCheck: true,
				columns: [[
					{ field:'EICRowId', title:'EICRowId', hidden:true }
					,{ field:'EICCode', width: 70, title:'内部编码', sortable: true, resizable: true}
					,{ field:'EICDesc', width: 100, title:'分类描述', sortable: true, resizable: true }
					,{ field:'EICDesc2', width: 200, title:'别名', sortable: true, resizable: true }
					,{ field:'EICSort', width: 60, title:'顺序号', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QueryExamItemCat",
					aType:"STC"
				},
				onLoadSuccess: function (data) {
					Public_gridsearch1 = [];
				}
			});
        }
    });
}
//查询（站点分类）
function BLFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStationLocNew",
		StationID:$("#StationID").val(), 
		Desc:$("#SLDesc").val(),
		LocID:LocID
		
	});	
	
	
}

//新增
function BLAdd_click()
 {
	 var StationID=$("#StationID").val();
	if(StationID==""){
		$.messager.alert('提示',"请选择需要维护的站点",'info');
		return;
	}

	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow', lastIndex);
	
	var selected = $('#StationLocGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TSLID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#StationLocGrid').datagrid('appendRow', {
		TSLID: '',
		TSLDesc: '',
	});
	
	lastIndex = $('#StationLocGrid').datagrid('getRows').length - 1;
	$('#StationLocGrid').datagrid('selectRow',lastIndex);
	$('#StationLocGrid').datagrid('beginEdit',lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BLUpdate_click()
 {
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#StationLocGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#StationLocGrid').datagrid('beginEdit', thisIndex);
		$('#StationLocGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#StationLocGrid').datagrid('getSelected');

		var thisEd = $('#StationLocGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSLDesc'  
		});
		
	}
 }

//保存
function BLSave_click()
{ 
	$('#StationLocGrid').datagrid('acceptChanges');
	var selected = $('#StationLocGrid').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('提示', "请选择待保存的数据", 'info');
		return;
	}

	if (selected) {
			
		if (selected.TSLID == "") {
			if ((selected.TSLDesc == "undefined")||(selected.TSLDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "UpdateStationLoc",
				StationID: $("#StationID").val(),
				LocDesc: selected.TSLDesc
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				}

				$("#StationLocGrid").datagrid('reload');
			});
		} else {
			$('#StationLocGrid').datagrid('selectRow', EditIndex);
			var selected = $('#StationLocGrid').datagrid('getSelected');
			if ((selected.TSLDesc == "undefined")||(selected.TSLDesc == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				$("#StationLocGrid").datagrid('reload');
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.StationLoc",
				MethodName: "UpdateStationLoc",
				ID: selected.TSLID,
				LocDesc: selected.TSLDesc	
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});	
				}
			 $("#StationLocGrid").datagrid('reload');
			});
		}
	}
}



var StationLocColumns = [[
	{
		field:'TSLID',
		title:'TSLID',
		hidden:true
	},{  
		field:'TSLDesc',
		width: '300',
		title:'分类',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{ field:'TEffPowerFlag',width:'100',align:'center',title:'当前科室授权',
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

// 初始化科室站点详情维护DataGrid
function InitStationLocGrid()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
	$('#StationLocGrid').datagrid({
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
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: StationLocColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationLoc",
			QueryName:"FindStationLocNew",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:LocID

			
		},
		onSelect: function (rowIndex, rowData) {
			if(rowIndex!="-1"){
				$('#STLocID').val(rowData.TSLID)
			}
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}
 
 function LoadStationLocGrid(StationID){
	
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];

	 $("#StationLocGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationLoc",
		QueryName:"FindStationLocNew",
		StationID:StationID,
		LocID:LocID
	});	
 }

/*******************************站点分类维护end*************************************/


/*******************************站点start******************************************/

// 初始化站点维护DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
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
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',title:'代码',width: 70},
			{field:'TDesc',title:'描述',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationNew",
			LocID:LocID	
			
		},
		onSelect: function (rowIndex,rowData) {
			$("#StationID").val(rowData.TID)
			LoadStationLocGrid(rowData.TID)

		},
		onLoadSuccess: function (data) {
			
		}
	});
	
}


//查询（站点）

function BFind_click(){
	var LocID=$("#LocList").combobox('getValue');
	//var LocID=session['LOGON.CTLOCID'];
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStation",
		Desc:$("#Desc").val(),
		LocID:LocID
	});
}
/*******************************站点end*************************************/

