$(function(){
    $("#printField").combobox({
        valueField: "Code",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataOptions";
            param.Arg1 = "printField";
            param.ArgCnt = 1;
        }
    });
    $("#fieldType").combobox({
        valueField: "Code",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindDataOptions";
            param.Arg1 = "fieldType";
            param.ArgCnt = 1;
        }
    });//
    $("#printTable").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = "CIS.AN.BL.PrintConfigration";
            param.QueryName = "FindPrintTable";
            param.ArgCnt = 0;
        },
        onSelect:function(rowData){
            $("#template").val(rowData.Template)
            $("#startRow").val(rowData.StartRow)
        }
    });
    

    $('#dataBox').datagrid({
		url: ANCSP.DataQuery,
		queryParams: {
			ClassName: "CIS.AN.BL.PrintConfigration",
			QueryName: "FindPrintConfigDatas",
			Arg1: $("#printTable").combobox("getValue"),
            ArgCnt: 1
        },
        border:false,
     
        onLoadSuccess: function(data) {
          
            $("a[id='btnremove']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
        },
        fit: true,
        singleSelect: true,
        onClickRow: function(rowIndex, rowData) {
            //表单赋值操作
            var printTable=rowData["PrintTable"];
            var field=rowData["Field"];
            var fieldDesc=rowData["FieldDesc"];
            var printType=rowData["PrintType"];
            var width=rowData["Width"];
            var location=rowData["Location"];
            var template=rowData["Template"];
            var startRow=rowData["StartRow"];
            $("#printTable").combobox("setValue",printTable);
            $("#printField").combobox("setValue",field);
            $("#fieldDesc").val(fieldDesc);
            $("#fieldType").combobox("setValue",printType);
            $("#fieldWidth").val(width);
            $("#fieldLocation").val(location);
            $("#template").val(template);
            $("#startRow").val(startRow);
		},
		columns: [
			[  {field:'operate1',title:'删除',align:'center',width:50,
            formatter:function(value, row, index){ 
            var str = '<a href="#" id="btnremove" class="hisui-linkbutton" onClick="CancelRefusedOper(\''+dataForm+'\',\''+row.RowId+'\')" "></a>';
            return str;
            }
            },
                {
				field: 'RowId',
                title: 'RowId',
                hidden: true,
				width: 70
			}, {
				field: 'Field',
				title: '字段',
				width: 100
			}, {
				field: 'FieldDesc',
				title: '字段名称',
				width: 100
			}, {
				field: 'PrintType',
                title: 'PrintType',
                hidden: true,
				width: 100
			}, {
				field: 'PrintTypeDesc',
				title: '字段类型',
				width: 100
            }
            , {
				field: 'Width',
				title: '宽度',
				width: 100
            } , {
				field: 'Location',
				title: '位置',
				width: 100
            }, {
				field: 'PrintTable',
                title: 'PrintTable',
                hidden: true,
				width: 100
            }, {
				field: 'TableCode',
				title: '表单代码',
				width: 100
            }, {
				field: 'TableDesc',
				title: '表单名称',
				width: 100
            }, {
				field: 'Template',
				title: '打印模板',
				width: 100
            }, {
				field: 'StartRow',
				title: '起始列',
				width: 100
            }
        ]
        ],
        toolbar: "#dataTools",
		pagination: true,
		pageSize: 200,
        pageList: [10, 15, 20, 50, 100, 200],
	});
    $("#btnQuery").click(function(){
        $("#dataBox").datagrid({
			queryParams: {
                ClassName: "CIS.AN.BL.PrintConfigration",
                QueryName: "FindPrintConfigDatas",
                Arg1: $("#printTable").combobox("getValue"),
                ArgCnt: 1
            }
		})
    })
    $("#btnAdd").click(function(){
        var field=$("#printField").combobox("getValue"),
        fieldDesc=$("#fieldDesc").val(),
        printType=$("#fieldType").combobox("getValue"),
        width=$("#fieldWidth").val(),
        location=$("#fieldLocation").val(),
        printTable=$("#printTable").combobox("getValue");
        var result=dhccl.runServerMethod("CIS.AN.BL.PrintConfigration","AddPrintConfigData",field,fieldDesc,printType,width,location,printTable);
        if(result.success){
            $.messager.alert("提示","添加成功","info");
            $("#dataBox").datagrid({
                queryParams: {
                    ClassName: "CIS.AN.BL.PrintConfigration",
                    QueryName: "FindPrintConfigDatas",
                    Arg1: $("#printTable").combobox("getValue"),
                    ArgCnt: 1
                }
            })
        }else{
            $.messager.alert("提示","必填项为空","error");
        }
    })
    $("#btnEdit").click(function(){
        var selObj=$('#dataBox').datagrid("getSelected");
        if(selObj==null){
			$.messager.alert("提示","请选择一条记录操作","info");
			return;
        }
        //field, fieldDesc , printType, width , location, printTable
        var field=$("#printField").combobox("getValue"),
            fieldDesc=$("#fieldDesc").val(),
            printType=$("#fieldType").combobox("getValue"),
            width=$("#fieldWidth").val(),
            location=$("#fieldLocation").val(),
            printTable=$("#printTable").combobox("getValue");
        var result=dhccl.runServerMethod("CIS.AN.BL.PrintConfigration","SavePrintConfigData",selObj.RowId,field,fieldDesc,printType,width,location,printTable);
		if(result.success){
            $.messager.alert("提示","修改成功","info");
			$("#dataBox").datagrid({
                queryParams: {
                    ClassName: "CIS.AN.BL.PrintConfigration",
                    QueryName: "FindPrintConfigDatas",
                    Arg1: $("#printTable").combobox("getValue"),
                    ArgCnt: 1
                }
            })
		}else{
            $.messager.alert("提示",result.result,"error");
        }


    })
    
   

});
function CancelRefusedOper(dataForm,index) {
    var selObj=$('#dataBox').datagrid("getSelected");
       
        var result=dhccl.runServerMethod("CIS.AN.BL.PrintConfigration","DeletePrintConfigData",index);
        if(result.success){
            $("#dataBox").datagrid({
                queryParams: {
                    ClassName: "CIS.AN.BL.PrintConfigration",
                    QueryName: "FindPrintConfigDatas",
                    Arg1: $("#printTable").combobox("getValue"),
                    ArgCnt: 1
                }
            })
        }

 }