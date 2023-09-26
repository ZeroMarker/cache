
//显示医院
function ShowBTTestSetLayout() {
    $('#dgBTTestSetLayout').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestSetLayout",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200,500,1000,2000],
		sortName: 'Code',
		sortOrder: 'dasc',		
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
        remoteSort: false,
        onClickCell: onClickCell,
		fit:true, 
        columns: [[
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'WorkGroupCode', title: '工作组代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'WorkGroupName', title: '工作组名称', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'TestSetCode', title: '医嘱代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestSetName', title: '医嘱名称', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'TestCode', title: '项目代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestName', title: '项目名称', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineCode', title: '工作小组代码', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineName', title: '工作小组名称', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 200, sortable: true, align: 'left' ,editor:'text'}
          
        ]]
    });
}; //ShowBTHospital 

//鏂板
function AddTestSetLayout() {
	$('#dgBTTestSetLayout').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//更新
function UpdTestSetLayout() {
    var RowID = "";
    var WorkGroupCode = "";
    var TestSetCode = "";
    var TestCode="";
    var HospCode="";
    var HospName="";   
    var WorkGroupMachineCode="";
    var rowsel = $('#dgBTTestSetLayout').datagrid("getSelected");
    var currow = $('#dgBTTestSetLayout').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestSetLayout');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    WorkGroupCode=rowsel.WorkGroupCode
	    TestSetCode=rowsel.TestSetCode
	    TestCode=rowsel.TestCode
	    WorkGroupMachineCode=rowsel.WorkGroupMachineCode
	    HospName=rowsel.HospName
	    HospCode=rowsel.HospCode		
	}
    if (Code == "") { 
        $.messager.alert("提示信息", '代码不能为空!', "info");
        return;
    }
    if (CName == "") { 
        $.messager.alert("提示信息", '名称不能为空!', "info");
        return;
    }

    $.messager.confirm('提示信息', '确认要更新选择项？【'+ Code + ":" + CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetLayout",RowID:RowID, WorkGroupCode:WorkGroupCode, TestSetCode:TestSetCode, TestCode:TestCode,WorkGroupMachineCode:WorkGroupMachineCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTTestSetLayout').datagrid('updateRow', {
		                index: currow,
		                row: {
		                    RetValue: message
		                }
		            });						
			});	
        }
    })    
    
}

 //删除
function DelTestSetLayout() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestSetLayout').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	}
	if (RowID == "") { 
	    $.messager.alert("提示信息", '请选择记录进行操作!', "info");
	    return;
	} 
    $.messager.confirm('提示信息', '确认要删除选择项？RowID【'+RowID +":"+ CName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestSetLayout",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestSetLayout').datagrid('reload');
                            $('#dgBTTestSetLayout').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestSetLayout() {
	var rows = $('#dgBTTestSetLayout').datagrid('getRows');
	var currow=0 //RowID, Code, CName, AbFlag, Sequence, TestCode
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var WorkGroupCode=rows[i].WorkGroupCode
	    var TestSetCode=rows[i].TestSetCode
	    var TestCode=rows[i].TestCode
		var WorkGroupMachineCode=rows[i].WorkGroupMachineCode
		var HospCode=rows[i].HospCode
		
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSetLayout",RowID:RowID, WorkGroupCode:WorkGroupCode, TestSetCode:TestSetCode, TestCode:TestCode,WorkGroupMachineCode:WorkGroupMachineCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTTestSetLayout').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestSetLayout').datagrid('reload');
    //$('#dgBTTestSetLayout').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshTestSetLayout(){
    $('#dgBTTestSetLayout').datagrid('reload');
    $('#dgBTTestSetLayout').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelTestSetLayout() {
	var filename=$('#filename').val()
	if (filename=='')
	{
		alert("请选择导入文件！");
		return;
	}   	
   	//var filename="D:\\iMedicalLIS标准模板.xls"
	try{ 
		var xApp = new ActiveXObject("Excel.application"); 
		var xBooks = xApp.Workbooks.open(filename);   
	}		
	catch(e){
		var emsg="请在IE下导入，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
		alert(e.message);
		return;
	}
	$('#dgBTTestSetLayout').datagrid("loadData",[]);
	
	xBooks.worksheets("检验医嘱").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	var tTestSetCode="",tWorkGroupMachineCode=""
	for (var row=4;row<=rowcount;row++){
		var TestSetCode=xSheet.Cells(row,1).value;
		var TestSetName=xSheet.Cells(row,2).value;
		var WorkGroupMachineCode=xSheet.Cells(row,3).value;
		var WorkGroupMachineName=xSheet.Cells(row,4).value;
		var TestCode=xSheet.Cells(row,5).value;
		var TestName=xSheet.Cells(row,6).value;
		var HospCode=xSheet.Cells(row,12).value;
		var HospName=xSheet.Cells(row,13).value;
		if ((typeof(TestCode)=="undefined") && (typeof(WorkGroupMachineCode)=="undefined")){
			continue ;
		}
		
		var msginfo=""
		if (typeof(TestSetCode)=="undefined") TestSetCode=tTestSetCode
		tTestSetCode=TestSetCode
		if (typeof(WorkGroupMachineCode)=="undefined") WorkGroupMachineCode=tWorkGroupMachineCode
		tWorkGroupMachineCode=WorkGroupMachineCode
		
		$('#dgBTTestSetLayout').datagrid('appendRow',{
			RowID:'',
			TestSetCode:TestSetCode,
			TestSetName:TestSetName,
			TestCode:TestCode,
			TestName:TestName,
			WorkGroupMachineCode:WorkGroupMachineCode,
			WorkGroupMachineName:WorkGroupMachineName,
			HospCode:HospCode,
			HospName:HospName,		
			RetValue:msginfo
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("医嘱套布局数据装载成功！");
}

