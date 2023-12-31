
//显示医院
function ShowBTTestCodeComments() {
    $('#dgBTTestCodeComments').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCodeComments",
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
          { field: 'TestCode', title: '项目代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'TestName', title: '项目名称', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Code', title: '备注代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '备注描述', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AbFlag', title: '异常标记', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 200, sortable: true, align: 'left' ,editor:'text'}
          
        ]]
    });
}; //ShowBTHospital 

//鏂板
function AddTestCodeComments() {
	$('#dgBTTestCodeComments').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//更新
function UpdTestCodeComments() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var TestCode="";
    var AbFlag="";
    var Sequence="";
    var HospCode="";
    var HospName="";    
        
    var rowsel = $('#dgBTTestCodeComments').datagrid("getSelected");
    var currow = $('#dgBTTestCodeComments').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCodeComments');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    Code=rowsel.Code
	    CName=rowsel.CName
	    AbFlag=rowsel.AbFlag
	    Sequence=rowsel.Sequence
	    TestCode=rowsel.TestCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeComments",RowID:RowID, Code:Code, CName:CName, AbFlag:AbFlag, Sequence:Sequence, TestCode:TestCode,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTTestCodeComments').datagrid('updateRow', {
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
function DelTestCodeComments() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCodeComments').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCodeComments",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCodeComments').datagrid('reload');
                            $('#dgBTTestCodeComments').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCodeComments() {
	var rows = $('#dgBTTestCodeComments').datagrid('getRows');
	var currow=0 //RowID, Code, CName, AbFlag, Sequence, TestCode
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var Code=rows[i].Code
	    var CName=rows[i].CName
	    var AbFlag=rows[i].AbFlag
	    var Sequence=rows[i].Sequence
	    var TestCode=rows[i].TestCode
		var HospCode=rows[i].HospCode
	    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeComments",RowID:RowID, Code:Code, CName:CName, AbFlag:AbFlag, Sequence:Sequence, TestCode:TestCode,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTTestCodeComments').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCodeComments').datagrid('reload');
    //$('#dgBTTestCodeComments').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshTestCodeComments(){
    $('#dgBTTestCodeComments').datagrid('reload');
    $('#dgBTTestCodeComments').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelTestCodeComments() {
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
	$('#dgBTTestCodeComments').datagrid("loadData",[]);
	
	xBooks.worksheets("检验项目").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	var Sequence=0,tTestCode=""
	for (var row=4;row<=rowcount;row++){
		var TestCode=xSheet.Cells(row,1).value;
		var TestName=xSheet.Cells(row,2).value;
		var Code=xSheet.Cells(row,15).value;
		var CName=xSheet.Cells(row,16).value;
		var AbFlag=xSheet.Cells(row,17).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
		
		if ((typeof(Code)=="undefined") && (typeof(CName)=="undefined")){
			continue ;
		}
		
		var msginfo=""
		if (typeof(TestCode)=="undefined")
		{
			TestCode=tTestCode
			Sequence=Sequence+1
		}else
		{
			Sequence=1
		}
		tTestCode=TestCode
		$('#dgBTTestCodeComments').datagrid('appendRow',{
			RowID:'',
			TestCode:TestCode,
			TestName:TestName,
			Code: Code,
			CName: CName,
			AbFlag:AbFlag,
			Sequence:Sequence,
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
	alert("检验项目标准数据装载成功！");
}

