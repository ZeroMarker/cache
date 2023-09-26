
//显示医院
function ShowSYSUser() {
    $('#dgSYSUser').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QrySYSUser",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200],
		sortName: 'Sequence',
		sortOrder: 'dasc',		
		striped:true,
		nowrap: false, 
		border: true,
		collapsible: true,
		singleSelect:true,
		selectOnCheck: false,
        checkOnSelect: false,
        onClickCell: onClickCell,
		fit:true, 
        columns: [[
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Password', title: '密码', width: 260, sortable: true, align: 'left' ,editor:'text'},
          { field: 'GroupCode', title: '安全组', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupCode', title: '登录工作组', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupName', title: '登录工作组名称', width: 180, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 80, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 100, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddSYSUser() {
	$('#dgSYSUser').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: ''
	});
}

//更新
function UpdSYSUser() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Password=""
    var GroupCode="";
    var WorkGroupCode="";
    var HospCode="";
    var HospName="";     
    var rowsel = $('#dgSYSUser').datagrid("getSelected");
    var currow = $('#dgSYSUser').datagrid('getRowIndex', rowsel);
    
    t = $('#dgSYSUser');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Password=rowsel.Password
	    GroupCode=rowsel.GroupCode
	    WorkGroupCode=rowsel.WorkGroupCode
	    Sequence=rowsel.Sequence
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdSYSUser",RowID:RowID,Code:Code,CName:CName,Password:Password,Sequence:Sequence,GroupCode:GroupCode,WorkGroupCode:WorkGroupCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgSYSUser').datagrid('updateRow', {
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
function DelSYSUser() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgSYSUser').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelSYSUser",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgSYSUser').datagrid('reload');
                            $('#dgSYSUser').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataSYSUser() {
	var rows = $('#dgSYSUser').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Password=rows[i].Password
		var GroupCode=rows[i].GroupCode
	    var WorkGroupCode=rows[i].WorkGroupCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdSYSUser",RowID:RowID,Code:Code,CName:CName,Password:Password,Sequence:Sequence,GroupCode:GroupCode,WorkGroupCode:WorkGroupCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgSYSUser').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgSYSUser').datagrid('reload');
    //$('#dgSYSUser').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshSYSUser(){
    $('#dgSYSUser').datagrid('reload');
    $('#dgSYSUser').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelSYSUser() {
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
	$('#dgSYSUser').datagrid("loadData",[]);
	
	xBooks.worksheets("用户").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var Password=xSheet.Cells(row,3).value;
		var GroupCode=xSheet.Cells(row,4).value;
		var WorkGroupCode=xSheet.Cells(row,5).value;
		var HospCode=xSheet.Cells(row,6).value;
		var HospName=xSheet.Cells(row,7).value;
		
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="代码不能为空！"
		if (typeof(CName)=="undefined") msginfo="名称不能为空！"
		$('#dgSYSUser').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			Password:Password,
			GroupCode:GroupCode,
			WorkGroupCode:WorkGroupCode,
			Sequence: row-3,
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
	alert("用户数据装载成功！");
}

