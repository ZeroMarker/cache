/*
 * FileName: edinfocheck.js
 * Author: yupeng
 * Date: 2021-11-24
 * Description: 查看知识库数据
 */
  
 
 
 $(function(){
         
    InitStationDataGrid();
    InitISDataGrid();
    InitExpressDetailDataGrid();
    InitDiagnosisGrid();
    InitDiagnosisRelateGrid();
	/*
    var HospitalTagsObj = $HUI.combobox("#HospitalList",{
        url:$URL+"?ClassName=HMS.BT.HospitalTags&QueryName=TagsAll&ResultSetType=array",
        valueField:'HTRowID',
        textField:'HTDesc'
        })
      */
	
	//知识库版本
	var HospitalTagsObj = $HUI.combobox("#HospitalList",{
		url: $URL,
		editable: false,
		defaultFilter:4, //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) { //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'HMS.BT.HospitalTags';
			param.QueryName = 'QryHospTags';
			param.aAlias = "";
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(){ //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
				 BFind_click(); 
			}
		}
	});
	
   //知识库版本
	$("#HospitalList").combobox({
       onSelect:function(){
			 BFind_click(); 
	}
	});

    
    //查询
    $("#BFind").click(function() {  
        BFind_click();      
     });
    
   //查询
    $("#DFind").click(function() {  
        DFind_click();      
     });
       
})


function DFind_click(){
    
    var NoRelate="N";
    var obj=$("#NoRelate").checkbox('getValue');
    if (obj) NoRelate="Y";
    var tab = $('#TypeTab').tabs('getSelected');
    var index = $('#TypeTab').tabs('getTabIndex',tab)
    var ParRef="",NType="";
    if(index==1) NType="ST";
    if(index==2) NType="IS";
    if(index==3) NType="ED";
    
    $("#DiagnosisGrid").datagrid('load', {
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosCode",
            HospId:$("#HospitalList").combobox("getValue"),
            Desc:$("#DiagnosisDesc").val(),
            NoRelate:NoRelate+"^"+NType
    });
    
    
    
    }

//查询
function BFind_click(){
   
    $("#StationTabGrid").datagrid('load',{
            ClassName:"HMS.PE.STItemCatMap",
            QueryName:"QuerySTItemCatMap",
            HospId:$("#HospitalList").combobox("getValue")
            
        });
        
    $("#ISTabGrid").datagrid('load',{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiseaseCode",
            HospId:$("#HospitalList").combobox("getValue")
            
        });
        
    $("#ExpressDetailTabGrid").datagrid('load',{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosExpress",
            HospId:$("#HospitalList").combobox("getValue"),
			Type:"Detail"
            
        });
        
}

function LoadDiagnosList(rowData,LoadType)
{
    if (LoadType=="ST"){
    $("#DiagnosisGrid").datagrid('load', {
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosCode",
            HospId:$("#HospitalList").combobox("getValue"),
            ParRef:rowData.SICRowId,
            QType:LoadType
    });
    }else if(LoadType=="IS"){
        $("#DiagnosisGrid").datagrid('load', {
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosCode",
            HospId:$("#HospitalList").combobox("getValue"),
            ParRef:rowData.DCRowId,
            QType:LoadType
        
    });
    }else{
        $("#DiagnosisGrid").datagrid('load', {
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosCode",
            HospId:$("#HospitalList").combobox("getValue"),
            ParRef:rowData.DEItemId,
            QType:LoadType
        
    });
    }
    
}


function InitStationDataGrid()
{
    
    var HospitalCatColumns = [[
            {
                field:'SICRowId',
                title:'SICRowId',
                hidden:true
            },{
                field:'SICCode',
                title:'站点代码',
                width: '100',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'SICDesc',
                title:'站点描述',
                width: '200',
                editor: 'text',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }
            
        ]];
        
    
    // 初始化DataGrid
    $('#StationTabGrid').datagrid({
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
        columns: HospitalCatColumns,
        queryParams:{
            ClassName:"HMS.PE.STItemCatMap",
            QueryName:"QuerySTItemCatMap"
        },
        onSelect: function (rowIndex, rowData) {
            
            LoadDiagnosList(rowData,"ST");
            
        }
    });

}
function InitDiagnosisGrid()
{
    
    var DiagnosisDataColumns = [[
            {
                field:'DCRowId',
                title:'DCRowId',
                hidden:true
            },{
                field:'DCDiagnos',
                title:'建议结论',
                editor: 'text',
                sortable: true,
                resizable: true,
                width: '100',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DCAdvice',
                title:'建议内容',
                editor: 'text',
                sortable: true,
                resizable: true,
                width: '200',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }
            
        ]];
        
    
    // 初始化DataGrid
    $('#DiagnosisGrid').datagrid({
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
        columns: DiagnosisDataColumns,
        nowrap:false,
        queryParams:{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosCode"
        },
        onSelect: function (rowIndex, rowData) {
           
            $("#DiagnosisRelateGrid").datagrid('load', {
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosExpress",
            HospId:$("#HospitalList").combobox("getValue"),
            ParRef:rowData.DCRowId,
			Type:"Express"
        
    });
            
            
            
        }
    });

}
function InitISDataGrid()
{
    
    var ISDataColumns = [[
            {
                field:'DCRowId',
                title:'DCRowId',
                hidden:true
            },{
                field:'DCDesc',
                title:'疾病名称',
                editor: 'text',
                sortable: true,
                resizable: true,
                width: '100',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DCDetail',
                title:'疾病建议',
                editor: 'text',
                sortable: true,
                resizable: true,
                width: '200',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }
            
        ]];
        
    
    // 初始化DataGrid
    $('#ISTabGrid').datagrid({
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
        columns: ISDataColumns,
        nowrap:false,
        queryParams:{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiseaseCode"
        },
        onSelect: function (rowIndex, rowData) {
            
            LoadDiagnosList(rowData,"IS");
        }
    });

}

function InitDiagnosisRelateGrid()
{
    
    var DiagnosisRelateColumns = [[
            {
                field:'DERowId',
                title:'DERowId',
                hidden:true
            },{
                field:'DEPreBracket',
                title:'前置括号',
                editor: 'text',
                width: '80',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEItemDesc',
                title:'项目',
                editor: 'text',
                width: '80',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEOperator',
                title:'运算符',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEReference',
                title:'参考值',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DESex',
                title:'性别',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DENoBloodFlag',
                title:'非血',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEAgeRange',
                title:'年龄',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEAfterBracket',
                title:'括号',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DERelation',
                title:'关系',
                editor: 'text',
                sortable: true,
                width: '80',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }
            
        ]];
        
    
    // 初始化DataGrid
    $('#DiagnosisRelateGrid').datagrid({
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
        columns: DiagnosisRelateColumns,
        queryParams:{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosExpress",
			Type:"Express"
        },
        onSelect: function (rowIndex, rowData) {
            
        }
    });

}
function InitExpressDetailDataGrid()
{
    
    var ExpressDetailColumns = [[
            {
                field:'DERowId',
                title:'DERowId',
                hidden:true
            },{
                field:'DEStationDesc',
                title:'站点名称',
                editor: 'text',
                width: '80',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEItemCode',
                title:'细项编码',
                editor: 'text',
                width: '80',
                sortable: true,
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             },{
                field:'DEItemDesc',
                title:'细项名称',
                editor: 'text',
                sortable: true,
                width: '150',
                resizable: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
             }
            
        ]];
        
    
    // 初始化DataGrid
    $('#ExpressDetailTabGrid').datagrid({
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
        columns: ExpressDetailColumns,
        queryParams:{
            ClassName:"HMS.PE.ExamItemData",
            QueryName:"QueryDiagnosExpress",
			Type:"Detail"
        },
        onSelect: function (rowIndex, rowData) {
            LoadDiagnosList(rowData,"ED");
            
        }
    });

}