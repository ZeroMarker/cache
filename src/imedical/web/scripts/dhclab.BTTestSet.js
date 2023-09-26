
//显示医院
function ShowBTTestSet() {
    $('#dgBTTestSet').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestSet",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20, 50, 100, 200,500,1000,2000],
		sortName: 'Sequence',
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
          { field: 'RowID', title: 'RowID', width: 50, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineCode', title: '工作小组代码', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WorkGroupMachineName', title: '工作小组名称', width: 120, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SpecimenCode', title: '标本代码', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SpecimenName', title: '标本名称', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerCode', title: '容器代码', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ContainerName', title: '容器名称', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'HISCode', title: '外部HIS代码', width: 80, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 50	, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 120, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddTestSet() {
	$('#dgBTTestSet').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''
	});
}

//更新
function UpdTestSet() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var WorkGroupMachineCode="";
    var SpecimenCode="";
    var ContainerCode="";
    var HISCode="";
    var Sequence="";
    var HospCode="";
    var HospName="";  
    
    var rowsel = $('#dgBTTestSet').datagrid("getSelected");
    var currow = $('#dgBTTestSet').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestSet');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    WorkGroupMachineCode=rowsel.WorkGroupMachineCode
	    SpecimenCode=rowsel.SpecimenCode
	    ContainerCode=rowsel.ContainerCode
	    HISCode=rowsel.HISCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSet",RowID:RowID,Code:Code,CName:CName,WorkGroupMachineCode:WorkGroupMachineCode,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,HISCode:HISCode,Sequence:Sequence,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTTestSet').datagrid('updateRow', {
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
function DelTestSet() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestSet').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestSet",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestSet').datagrid('reload');
                            $('#dgBTTestSet').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestSet() {
	var rows = $('#dgBTTestSet').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var WorkGroupMachineCode=rows[i].WorkGroupMachineCode
	    var SpecimenCode=rows[i].SpecimenCode
	    var ContainerCode=rows[i].ContainerCode
	    var HISCode=rows[i].HISCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestSet",RowID:RowID,Code:Code,CName:CName,WorkGroupMachineCode:WorkGroupMachineCode,SpecimenCode:SpecimenCode,ContainerCode:ContainerCode,HISCode:HISCode,Sequence:Sequence,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTTestSet').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestSet').datagrid('reload');
    //$('#dgBTTestSet').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshTestSet(){
    $('#dgBTTestSet').datagrid('reload');
    $('#dgBTTestSet').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelTestSet() {
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
	$('#dgBTTestSet').datagrid("loadData",[]);
	
	xBooks.worksheets("检验医嘱").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	var currow=0;
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var WorkGroupMachineCode=xSheet.Cells(row,3).value;
		var WorkGroupMachineName=xSheet.Cells(row,4).value;
		var SpecimenCode=xSheet.Cells(row,7).value;
		var SpecimenName=xSheet.Cells(row,8).value;
		var ContainerCode=xSheet.Cells(row,9).value;
		var ContainerName=xSheet.Cells(row,10).value;
		var HISCode=xSheet.Cells(row,11).value;
		var HospCode=xSheet.Cells(row,12).value;
		var HospName=xSheet.Cells(row,13).value;
	
		if (typeof(Code)=="undefined") continue 
		if (typeof(CName)=="undefined") continue 
		currow++
		$('#dgBTTestSet').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			WorkGroupMachineCode:WorkGroupMachineCode,
			WorkGroupMachineName:WorkGroupMachineName,
			SpecimenCode:SpecimenCode,
			SpecimenName:SpecimenName,
			ContainerCode:ContainerCode,
			ContainerName:ContainerName,
			HospCode:HospCode,
			HospName:HospName,
			Sequence: currow,
			RetValue:""
		});		
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("检验医嘱数据装载成功！");
}

