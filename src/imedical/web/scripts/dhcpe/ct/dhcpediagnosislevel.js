/*
 * FileName: dhcpediagnosislevel.js
 * Author: xy
 * Date: 2021-08-04
 * Description: 建议级别维护
 */
var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_EDClass";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	
	//获取科室下拉列表
	GetLocComp(SessionStr);
	  
	//初始化  建议级别Grid    
    InitDiagnosisLevelDataGrid();
    
    //科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
		InitDiagnosisLevelDataGrid();
		}
	});
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
     //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
        
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
      //保存
     $('#BSave').click(function(){
    	BSave_click();
    });
	   
    //数据关联科室
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
     $('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			BFind_click();		
	    }			
    });   
        
 
})


//数据关联科室
function BRelateLoc_click()
{
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("提示","请选择需要授权的记录","info"); 
		return false;
	}
  
   var LocID=$("#LocList").combobox('getValue')
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,InitDiagnosisLevelDataGrid)
   
}

//清屏
function BClear_click()
{	
	$("#Level,#Desc,#ID").val("");
	$("#NoActive").checkbox('setValue',true);
	LoadDiagnosisLevel();
}

//查询
function BFind_click(){
	
	$("#DiagnosisLevelQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.DiagnosisLevel",
			QueryName:"LevelAll",
			Code:$("#Level").val(),
			Desc:$("#Desc").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:tableName, 
			LocID:$("#LocList").combobox('getValue')
			
		});	
}
//新增
function BAdd_click()
 {
	lastIndex = $('#DiagnosisLevelQueryTab').datagrid('getRows').length - 1;
	$('#DiagnosisLevelQueryTab').datagrid('selectRow', lastIndex);
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if (selected) {
		if (selected.TRowID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#DiagnosisLevelQueryTab').datagrid('appendRow', {
		TRowID: '',
		TLevel: '',
		TDesc: '',
		TNoActive:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUserName:'',
		TEmpower:'',
		TEffPowerFlag:''
	});
	lastIndex = $('#DiagnosisLevelQueryTab').datagrid('getRows').length - 1;
	$('#DiagnosisLevelQueryTab').datagrid('selectRow', lastIndex);
	$('#DiagnosisLevelQueryTab').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#DiagnosisLevelQueryTab').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#DiagnosisLevelQueryTab').datagrid('beginEdit', thisIndex);
		$('#DiagnosisLevelQueryTab').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
	
		var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
		
		var thisEd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', {
				index: EditIndex,
				field: 'TLevel'  
		});
			
		var thisEd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', {
				index: EditIndex,
				field: 'TDesc'  
		});
		
		//if((selected.TEffPowerFlag!="Y")){
		//	var dd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });		
		//	$(dd.target).checkbox("disable");  
	    //}else{
		    var dd = $('#DiagnosisLevelQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });		
			$(dd.target).checkbox("enable"); 
	    //}
	}
 }

//保存
function BSave_click()
{
	$('#DiagnosisLevelQueryTab').datagrid('acceptChanges');
	
	var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('提示', "请选择待保存的数据", 'info');
		return;
	}
	if (selected) {
		
		if (selected.TRowID == "") {
			if ((selected.TLevel == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				LoadDiagnosisLevel()
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.DiagnosisLevel",
				MethodName: "Insert",
				level:selected.TLevel,
				Desc:selected.TDesc,
				NoActive:selected.TNoActive,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('提示', '保存成功', 'success');
					
				}
			
				
			LoadDiagnosisLevel()
			});
		} else {
			$('#DiagnosisLevelQueryTab').datagrid('selectRow', EditIndex);
			var selected = $('#DiagnosisLevelQueryTab').datagrid('getSelected');
            if(selected ==null){ return; }
			$.messager.confirm("确认", "确定要保存数据吗？", function(r){
			if (r){
					
					if ((selected.TLevel == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
						$.messager.alert('提示', "数据为空,不允许修改", 'info');
						LoadDiagnosisLevel()
						return;
					}
					/*
					if ((selected.TNoActive=="Y")&&(selected.TEmpower=="Y")){
						$.messager.alert('提示', "单独授权数据不能作废", 'info');
						return;
					}*/
					$.m({
						ClassName: "web.DHCPE.CT.DiagnosisLevel",
						MethodName: "Update",
						rowid: selected.TRowID,
						level:selected.TLevel,
						Desc:selected.TDesc,
						NoActive:selected.TNoActive,
						UserID:session['LOGON.USERID'],
						tableName:tableName,
						LocID:$("#LocList").combobox('getValue'),
						Empower:selected.TEmpower	
				
					}, function (rtn) {
						var rtnArr=rtn.split("^");
						if(rtnArr[0]=="-1"){	
						$.messager.alert('提示', rtnArr[1], 'error');
					
					}else{	
						$.messager.alert('提示', '修改成功', 'success');
					
					}
			
					LoadDiagnosisLevel()
				});
			
			
				}
			});	
		
			
		}
	}
}



//删除
function BDelete_click()
{
	var ID=$("#ID").val();
	if(ID==""){
			$.messager.alert("提示","请选择待删除的记录","info");
			return false;
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.DiagnosisLevel", MethodName:"Delete",InString:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					if(ReturnValue.indexOf("^")>0){
						$.messager.alert("提示",$g("删除失败:")+ReturnValue.split("^")[1],"error"); 
					} else{
						$.messager.alert("提示","删除失败","error"); 
					}
 
				}else{
					$.messager.alert("提示","删除成功","success");
					BClear_click();	
				}
				});
		}
	});
	
	
}


function LoadDiagnosisLevel()
{
	 $("#DiagnosisLevelQueryTab").datagrid('reload');
	 $("#BRelateLoc").linkbutton('disable');
}



function InitDiagnosisLevelDataGrid(){
	//alert($("#LocList").combobox('getValue')	
	
	var DiagnosisLevelColumns = [[
			{
				field:'TRowID',
				title:'TRowID',
				hidden:true
			},{
				field:'TLevel',
				width: '200',
			 	title:'级别',
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
				width: '200',
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
				field: 'TNoActive',
				width: '80',
				title: '激活',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
						
				},
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
			},{
				field: 'TEmpower',
				width: '80',
				title: '单独授权',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
						
				},
                formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'当前科室授权',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			}, {
				field: 'TUpdateDate',
				width: '120',
				title: '更新日期'
			}, {
				field: 'TUpdateTime',
				width: '120',
				title: '更新时间'
			}, {
				field: 'TUserName',
				width: '120',
				title: '更新人'
			}
			
			
			
		]];
		
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];	

	// 初始化DataGrid
	$('#DiagnosisLevelQueryTab').datagrid({
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
		columns: DiagnosisLevelColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.DiagnosisLevel",
			QueryName:"LevelAll",
			Code:$("#Level").val(),
			Desc:$("#Desc").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:tableName, 
			LocID:locId
		},
		onSelect: function (rowIndex, rowData) {
			if(rowData){
				if((rowData.TEmpower=="Y")&&(rowData.TNoActive=="Y")){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
			    $("#ID").val(rowData.TRowID);
			}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});

		
}

