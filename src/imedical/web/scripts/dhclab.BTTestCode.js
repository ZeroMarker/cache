
//显示医院
function ShowBTTestCode() {
    $('#dgBTTestCode').datagrid({	
    	url:'jquery.easyui.dhclabclassjson.csp',
		method: 'get',
		queryParams: { 
			ClassName:"DHCLIS.DHCBTData",
			QueryName:"QryTestCode",
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
          { field: 'RowID', title: 'RowID', width: 60, sortable: true, align: 'left',editor:'text' },
          { field: 'Code', title: '代码', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'CName', title: '名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Synonym', title: '缩写', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Units', title: '单位', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Precision', title: '精确度', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'ResultFormat', title: '数据格式', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RefRanges', title: '特殊显示参考范围', width: 100, sortable: true, align: 'left' ,editor:'text'},
          { field: 'SCode', title: '标准码', width: 60, sortable: true, align: 'left' ,editor:'text'},
          { field: 'Sequence', title: '序号', width: 60, sortable: true, align: 'left',editor:'text'},
          { field: 'HospCode', title: '医院代码', width: 100, sortable: true, align: 'center' ,editor:'text'},
          { field: 'HospName', title: '医院名称', width: 200, sortable: true, align: 'left' ,editor:'text'},
          { field: 'RetValue', title: '导入信息', width: 120, sortable: true, align: 'left' ,editor:'text'}
        ]]
    });
}; //ShowBTHospital

//鏂板
function AddTestCode() {
	$('#dgBTTestCode').datagrid('appendRow',{
		RowID:'',
		Code: '',
		CName: '',
		Sequence: '',
		HospCode: '',
		HospName: ''
	});
}

//更新
function UpdTestCode() {
    var RowID = "";
    var CName = "";
    var Code = "";
    var Synonym="";
    var Units="";
    var Precision="";
    var ResultFormat="";
    var RefRanges="";
    var SCode="";
    var Sequence="";
    var HospCode="";
    var HospName="";    
       
    var rowsel = $('#dgBTTestCode').datagrid("getSelected");
    var currow = $('#dgBTTestCode').datagrid('getRowIndex', rowsel);
    
    t = $('#dgBTTestCode');
	endEditing(t);

    if (rowsel) {
	    RowID=rowsel.RowID
	    CName=rowsel.CName
	    Code=rowsel.Code
	    Synonym=rowsel.Synonym
	    Units=rowsel.Units
	    Precision=rowsel.Precision
	    ResultFormat=rowsel.ResultFormat
	    RefRanges=rowsel.RefRanges
	    SCode=rowsel.SCode
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCode",RowID:RowID,Code:Code,CName:CName,Synonym:Synonym,Units:Units,Precision:Precision,ResultFormat:ResultFormat,RefRanges:RefRanges,SCode:SCode,Sequence:Sequence,HospCode:HospCode},
				function(rtn){
					if (rtn == 1) {
                        message="更新成功"
					}else
					{
						message="更新失败" +rtn
					}
                   $('#dgBTTestCode').datagrid('updateRow', {
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
function DelTestCode() {
	var RowID = "";
	var CName = "";
	var rowsel = $('#dgBTTestCode').datagrid("getSelected");
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
	        	$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"DelBTTestCode",RowID:RowID},
				function(rtn){
					if (rtn == 1) {
                            $('#dgBTTestCode').datagrid('reload');
                            $('#dgBTTestCode').datagrid('clearSelections');
					}else
					{
						message="删除失败" +rtn
						$.messager.alert("提示信息", message, "info");
					}
			});	
        }
    })
}
function ImportDataTestCode() {
	var rows = $('#dgBTTestCode').datagrid('getRows');
	var currow=0
	for (var i = 0; i < rows.length; i++) {
		var RowID=rows[i].RowID
	    var CName=rows[i].CName
	    var Code=rows[i].Code
	    var Synonym=rows[i].Synonym
	    var Units=rows[i].Units
	    var Precision=rows[i].Precision
	    var ResultFormat=rows[i].ResultFormat
	    var RefRanges=rows[i].RefRanges
	    var SCode=rows[i].SCode
	    var Sequence=rows[i].Sequence
		var HospCode=rows[i].HospCode
			    
		$.ajaxRunServerMethod({ClassName:"DHCLIS.DHCBTData",MethodName:"UpdBTTestCode",RowID:RowID,Code:Code,CName:CName,Synonym:Synonym,Units:Units,Precision:Precision,ResultFormat:ResultFormat,RefRanges:RefRanges,SCode:SCode,Sequence:Sequence,HospCode:HospCode},
		function(rtn){
			var message="";
			if (rtn == 1) {
				message="更新成功"
			}else
			{
				message="更新失败" +rtn
			}
			currow++
			$('#dgBTTestCode').datagrid('updateRow', {index: currow-1, row: {RetValue:message}});
		});	
	}
    //$('#dgBTTestCode').datagrid('reload');
    //$('#dgBTTestCode').datagrid('clearSelections');
	$.messager.alert("提示信息", "导入保存完成,请检查导入信息情况!", "info");
}


function RefreshTestCode(){
    $('#dgBTTestCode').datagrid('reload');
    $('#dgBTTestCode').datagrid('clearSelections');
}
//载入导入数据
function ReadExcelTestCode() {
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
	$('#dgBTTestCode').datagrid("loadData",[]);
	
	xBooks.worksheets("检验项目").select(); 
	var xSheet = xBooks.ActiveSheet; 
	var rowcount=xSheet.UsedRange.Cells.Rows.Count ;  ///行数  
	var colcount=xSheet.UsedRange.Cells.Columns.Count ;  ///列数
	var sheetname=xSheet.name;  //获取sheet的表中文含义
	
	for (var row=4;row<=rowcount;row++){
		var Code=xSheet.Cells(row,1).value;
		var CName=xSheet.Cells(row,2).value;
		var Synonym=xSheet.Cells(row,3).value;
		var Units=xSheet.Cells(row,4).value;
		var Precision=xSheet.Cells(row,5).value;
		var ResultFormat=xSheet.Cells(row,6).value;
		var RefRanges=xSheet.Cells(row,12).value;
		var SCode=xSheet.Cells(row,18).value;
		var HospCode=xSheet.Cells(row,19).value;
		var HospName=xSheet.Cells(row,20).value;
				
		var msginfo=""
		if (typeof(Code)=="undefined") msginfo="代码不能为空！"
		if (typeof(CName)=="undefined") msginfo="名称不能为空！"
		if (msginfo==""){
			$('#dgBTTestCode').datagrid('appendRow',{
				RowID:'',
				Code: Code,
				CName: CName,
				Synonym:Synonym,
				Units:Units,
				Precision:Precision,
				ResultFormat:ResultFormat,
				RefRanges:RefRanges,
				SCode:SCode,
				Sequence: row-3,
				HospCode:HospCode,
				HospName:HospName,					
				RetValue:msginfo
			});		
		};
	}
	xBooks.Close (savechanges=false);
	xApp.Quit(); 
	xApp=null;
	xSheet=null;
	xBooks=null;
	alert("检验项目数据装载成功！");
}

