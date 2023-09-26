
//显示医院
function ShowBTSpecimen() {
    $('#dgBTSpecimen').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QrySpecimen",
			FunModul:"JSON"
		},		
		rownumbers: true,
		pagination: true,
		pageSize: 100,
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
          { field: 'RowID', title: 'RowID', width: 80, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'IName', title: '名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'WCode', title: 'Whonet码', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 80, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 120, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 200, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddSpecimen() {
	$('#dgBTSpecimen').datagrid('appendRow',{
		RowID:'',
		Code: '',
		IName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//更新
function UpdSpecimen() {
    var RowID = "";
    var IName = "";
    var Code = "";
    var WCode="";
    var HospCode="";
    var HospName="";    
    var rowsel = $('#dgBTSpecimen').datagrid("getSelected");
    var currow = $('#dgBTSpecimen').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTSpecimen');
	endEditing(t);
	
    if (rowsel) {
	    RowID=rowsel.RowID
	    IName=rowsel.IName
	    Code=rowsel.Code
	    WCode=rowsel.WCode
	    Sequence=rowsel.Sequence
	    HospName=rowsel.HospName
	    HospCode=rowsel.HospCode	    
	}
    if (Code == "") { 
        $.messager.alert("提示信息", '代码不能为空!', "info");
        return;
    }
    if (IName == "") { 
        $.messager.alert("提示信息", '名称不能为空!', "info");
        return;
    }
    $.messager.confirm('提示信息', '确认要更新选择项？【'+ Code + ":" + IName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTSpecimen",RowID:RowID,Code:Code,IName:IName,Sequence:Sequence,WCode:WCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTSpecimen').datagrid('updateRow', {
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
function DelSpecimen() {
	var RowID = "";
	var IName = "";
	var rowsel = $('#dgBTSpecimen').datagrid("getSelected");
	if (rowsel) {
	    RowID=rowsel.RowID
	    IName=rowsel.IName
	}
	if (RowID == "") { 
	    $.messager.alert("提示信息", '请选择记录进行操作!', "info");
	    return;
	} 
    $.messager.confirm('提示信息', '确认要删除选择项？RowID【'+RowID +":"+ IName + '】', function (isClickedOk) {
        if (isClickedOk) {
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTSpecimen",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTSpecimen').datagrid('reload');
                            $('#dgBTSpecimen').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataSpecimen() {
	var rows = $('#dgBTSpecimen').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var IName=rows[i].IName
	    var Code=rows[i].Code
	    var WCode=rows[i].WCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode

		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTSpecimen",RowID:RowID,Code:Code,IName:IName,Sequence:Sequence,WCode:WCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTSpecimen').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTSpecimen').datagrid('reload');
    //$('#dgBTSpecimen').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshSpecimen(){
    $('#dgBTSpecimen').datagrid('reload');
    $('#dgBTSpecimen').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelSpecimen() {
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
	$('#dgBTSpecimen').datagrid("loadData",[]);
	
	xBooks.worksheets("标本类型").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var IName=xSheet.Cells(row,2).value;
		var WCode=xSheet.Cells(row,3).value;
		var HospCode=xSheet.Cells(row,4).value;
		var HospName=xSheet.Cells(row,5).value;
				
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="代码不能为空！"
		if (typeof(IName)=="undefined") msginfo="名称不能为空！"
		$('#dgBTSpecimen').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			IName: IName,
			WCode:WCode,
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
	alert("标本类型数据装载成功！");
}

