
//显示医院
function ShowBTTestCodeRanges() {
    $('#dgBTTestCodeRanges').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCodeRanges",
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
          { field: 'Code', title: '代码', width: 60, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 160, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Species', title: '性别', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AgeLow', title: '年龄低', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'AgeHigh', title: '年龄高', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ValueLow', title: '低值', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ValueHigh', title: '高值', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'PanicLow', title: '危急低值', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'PanicHigh', title: '危急髙值', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'OrderNo', title: '序号', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 200, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital 

//鏂板
function AddTestCodeRanges() {
	$('#dgBTTestCodeRanges').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''	
	});
}

//更新
function UpdTestCodeRanges() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Species="";
    var AgeLow="";
    var AgeHigh="";
    var ValueLow="";
    var ValueHigh="";
    var PanicLow="";
    var PanicHigh="";
    var OrderNo="";
    var HospCode="";
    var HospName="";    
        
    var rowsel = $('#dgBTTestCodeRanges').datagrid("getSelected");
    var currow = $('#dgBTTestCodeRanges').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCodeRanges');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    Code=rowsel.Code
	    CName=rowsel.CName
	    Species=rowsel.Species
	    AgeLow=rowsel.AgeLow
	    AgeHigh=rowsel.AgeHigh
	    ValueLow=rowsel.ValueLow
	    ValueHigh=rowsel.ValueHigh
	    PanicLow=rowsel.PanicLow
	    PanicHigh=rowsel.PanicHigh
	    OrderNo=rowsel.OrderNo
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeRanges",RowID:RowID,Code:Code,Species:Species,AgeLow:AgeLow,AgeHigh:AgeHigh,ValueLow:ValueLow,ValueHigh:ValueHigh,PanicLow:PanicLow,PanicHigh:PanicHigh,OrderNo:OrderNo,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTTestCodeRanges').datagrid('updateRow', {
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
function DelTestCodeRanges() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCodeRanges').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCodeRanges",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCodeRanges').datagrid('reload');
                            $('#dgBTTestCodeRanges').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCodeRanges() {
	var rows = $('#dgBTTestCodeRanges').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var Code=rows[i].Code
	    var Species=rows[i].Species
	    var AgeLow=rows[i].AgeLow
	    var AgeHigh=rows[i].AgeHigh
	    var ValueLow=rows[i].ValueLow
	    var ValueHigh=rows[i].ValueHigh
	    var PanicLow=rows[i].PanicLow
	    var PanicHigh=rows[i].PanicHigh
	    var OrderNo=rows[i].OrderNo
		var HospCode=rows[i].HospCode
	    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCodeRanges",RowID:RowID,Code:Code,Species:Species,AgeLow:AgeLow,AgeHigh:AgeHigh,ValueLow:ValueLow,ValueHigh:ValueHigh,PanicLow:PanicLow,PanicHigh:PanicHigh,OrderNo:OrderNo,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTTestCodeRanges').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCodeRanges').datagrid('reload');
    //$('#dgBTTestCodeRanges').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshTestCodeRanges(){
    $('#dgBTTestCodeRanges').datagrid('reload');
    $('#dgBTTestCodeRanges').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelTestCodeRanges() {
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
	$('#dgBTTestCodeRanges').datagrid("loadData",[]);
	
	xBooks.worksheets("检验项目").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	var OrderNo=0,tCode=""
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		
		var Species=xSheet.Cells(row,7).value;
		var AgeLow=xSheet.Cells(row,8).value;
		var AgeHigh=xSheet.Cells(row,9).value;
		
		var ValueLow=xSheet.Cells(row,10).value;
		var ValueHigh=xSheet.Cells(row,11).value;
		var PanicLow=xSheet.Cells(row,13).value;
		var PanicHigh=xSheet.Cells(row,14).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
		
		if ((typeof(ValueLow)=="undefined") && (typeof(ValueHigh)=="undefined")){
			continue ;
		}
		if (typeof(Code)=="undefined") {
			continue ;
		}
		
		var msginfo=""
		if (Code==tCode)
		{
			OrderNo=OrderNo+1
		}else
		{
			tCode=Code
			OrderNo=1
		}
		$('#dgBTTestCodeRanges').datagrid('appendRow',{
			RowID:'',
			Code: Code,
			CName: CName,
			Species:Species,
			AgeLow:AgeLow,
			AgeHigh:AgeHigh,
			ValueLow:ValueLow,
			ValueHigh:ValueHigh,
			PanicLow:PanicLow,
			PanicHigh:PanicHigh,
			OrderNo:OrderNo,
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
	alert("检验项目参考范围数据装载成功！");
}

