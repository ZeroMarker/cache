/*
 * FileName: dhcpe/ct/dhcpediagnosiskey.js
 * Author: yupeng
 * Date: 2021-08-04
 * Description: 建议关键词维护-多院区
 */
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_EDKey";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
    
    
    //获取下拉列表
    GetLocComp(SessionStr)
           
    InitDiagnosisKeyDataGrid();
    
   //科室下拉列表change
	$("#LocList").combobox({
 		onSelect:function(){
		 $('#DiagnosisKeyQueryTab').datagrid('load',{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Desc:$("#Desc").val(),
            Color:$("#Color").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue')
        });       	    		 
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
   
  OpenLocWin(tableName,DateID,SessionStr,LocID,InitDiagnosisKeyDataGrid)

   LoadDiagnosisKey()
}

//清屏
function BClear_click()
{   
     $("#Color,#Desc,#ID").val("");
     $("#NoActive").checkbox('setValue',true);
     LoadDiagnosisKey();
	 BFind_click();

}

//查询
function BFind_click(){
    
    $("#DiagnosisKeyQueryTab").datagrid('load',{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Color:$("#Color").val(),
            Desc:$("#Desc").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:$("#LocList").combobox('getValue')
            
        }); 
}

//新增
function BAdd_click()
 {
    lastIndex = $('#DiagnosisKeyQueryTab').datagrid('getRows').length - 1;
    $('#DiagnosisKeyQueryTab').datagrid('selectRow', lastIndex);
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
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
    $('#DiagnosisKeyQueryTab').datagrid('appendRow', {
        TRowID: '',
        TDesc: '',
        TColor: '',
        TNoActive:'',
        TUpdateDate:'',
        TUpdateTime:'',
        TUserName:'',
        TEmpower:'',
        TEffPowerFlag:''
    });
    lastIndex = $('#DiagnosisKeyQueryTab').datagrid('getRows').length - 1;
    $('#DiagnosisKeyQueryTab').datagrid('selectRow', lastIndex);
    $('#DiagnosisKeyQueryTab').datagrid('beginEdit', lastIndex);
    EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
    if (selected==null){
            $.messager.alert('提示', "请选择待修改的记录", 'info');
            return;
    }
    if (selected) {
        var thisIndex = $('#DiagnosisKeyQueryTab').datagrid('getRowIndex', selected);
        if ((EditIndex != -1) && (EditIndex != thisIndex)) {
            $.messager.alert('提示', "一次只能修改一条记录", 'info');
            return;
        }
        $('#DiagnosisKeyQueryTab').datagrid('beginEdit', thisIndex);
        $('#DiagnosisKeyQueryTab').datagrid('selectRow', thisIndex);
        EditIndex = thisIndex;
    
        var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
        
        var thisEd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', {
                index: EditIndex,
                field: 'TColor'  
        });
            
        var thisEd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', {
                index: EditIndex,
                field: 'TDesc'  
        });
        
        //if((selected.TEffPowerFlag!="Y")){
        //    var dd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });       
        //    $(dd.target).checkbox("disable");
        //}else{
            var dd = $('#DiagnosisKeyQueryTab').datagrid('getEditor', { index: EditIndex, field: 'TEmpower' });       
            $(dd.target).checkbox("enable"); 
        //}
    }
 }

//保存
function BSave_click()
{
    $('#DiagnosisKeyQueryTab').datagrid('acceptChanges');
    
    var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
	 if(selected ==null){
		$.messager.alert('提示', "请选择待保存的数据", 'info');
		return;
	}
    if (selected) {
        
        if (selected.TRowID == "") {
            if ((selected.TColor == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TLevel == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
                $.messager.alert('提示', "数据为空,不允许添加", 'info');
                LoadDiagnosisKey()
                return;
            }
            $.m({
                ClassName: "web.DHCPE.CT.DiagnosisKey",
                MethodName: "Update",
                RowId:"",
                Color:selected.TColor,
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
                    $.messager.popover({msg:'保存成功',type:'success',timeout: 1000});
                }
            
                
            LoadDiagnosisKey()
            });
        } else {
			 $('#DiagnosisKeyQueryTab').datagrid('selectRow', EditIndex);
             var selected = $('#DiagnosisKeyQueryTab').datagrid('getSelected');
			 if(selected ==null){
				return;
			 }
            $.messager.confirm("确认", "确定要保存数据吗？", function(r){
            if (r){
                   
                    if ((selected.TColor == "undefined")||(selected.TDesc=="undefined")||(selected.TNoActive == "undefined")||(selected.TColor == "")||(selected.TDesc=="")||(selected.TNoActive == "")) {
                        $.messager.alert('提示', "数据为空,不允许修改", 'info');
                        LoadDiagnosisKey()
                        return;
                    }
                    
                    $.m({
                        ClassName: "web.DHCPE.CT.DiagnosisKey",
                        MethodName: "Update",
                        RowId:selected.TRowID,
                        Color:selected.TColor,
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
						 $.messager.popover({msg:'修改成功',type:'success',timeout: 1000});
                    }
            
                    LoadDiagnosisKey()
                });
            
            
                }
            }); 
        
            
        }
    }
}



function LoadDiagnosisKey()
{
     $("#DiagnosisKeyQueryTab").datagrid('reload');
     $("#BRelateLoc").linkbutton('disable');
}



function InitDiagnosisKeyDataGrid(){ 
    
    var DiagnosisKeyColumns = [[
            {
                field:'TRowID',
                title:'TRowID',
                hidden:true
            },{
                field:'TDesc',
                width: '200',
                title:'关键词',
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
                field:'TColor',
                width: '200',
                title:'颜色',
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
                
            },{ field:'TEffPowerFlag',
            	width:100,
            	align:'center',
           	 	title:'当前科室授权',
            	formatter: function (value, rec, rowIndex) {
            		if(value=="Y"){
            			return '<input type="checkbox" checked="checked" disabled/>';
            		}else{
            			return '<input type="checkbox" value="" disabled/>';
            		}
            	}
            }, {
                field: 'TUpdateDate',
                width: '100',
                title: '更新日期'
            }, {
                field: 'TUpdateTime',
                width: '100',
                title: '更新时间'
            }, {
                field: 'TUserName',
                width: '80',
                title: '更新人'
            }
            
            
            
        ]];
        
    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; } 
		
    // 初始化DataGrid
    $('#DiagnosisKeyQueryTab').datagrid({
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
        columns: DiagnosisKeyColumns,
        queryParams:{
            ClassName:"web.DHCPE.CT.DiagnosisKey",
            QueryName:"KeyAll",
            Desc:$("#Desc").val(),
            Color:$("#Color").val(),
            NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
            tableName:tableName, 
            LocID:LocID
        },
        onSelect: function (rowIndex, rowData) {
            if(rowIndex!=-1){
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

