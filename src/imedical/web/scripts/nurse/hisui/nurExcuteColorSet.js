/*
 护士执行颜色配置js
*/
var GV={
	_CALSSNAME:"Nur.NIS.Service.OrderExcute.ColorConfig"
}
var editIndex=undefined;
$(window).load(function() {
	$("#Loading").hide();
});
$(function(){ 
	InitHospList();
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_ExecuteColorSet"); //CF.NUR.NIS.ButtonConfig
	hospComp.jdata.options.onSelect = function(e,t){
		$('#colorTab').datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitColorTab();
	}
}
function InitColorTab(){
	var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function() {
	        endMenuTabEditing();
	        $('#colorTab').datagrid('insertRow',{
				index: 0,
				row: {
					rowid: '',
					ECSActive: 'Y'
				}
			});
			editIndex = 0;
			$('#colorTab').datagrid('selectRow', 0).datagrid('beginEdit', 0);
			initCombox();
        }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	       saveColorSetData();
        }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	       delColorSetData();
        }
    }];
	$('#colorTab').datagrid({
		fit:true,
		rownumbers:true,
		toolbar :ToolBar,
		border:false,
        url: $URL,
        singleSelect: true,
        bodyCls:'panel-body-gray',
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "getColorList"
        },
        idField:'rowid',
        columns: [[
	        {
	           field: "ECSName",title: "项目名称",width: 140,
	             editor:{
		            type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
	        },
	        {
	           field: "ECSExpress",title: "表达式",width: 280,
	            editor:{
		            type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
	        },
	        { field: 'ECSBackgroundColor',title: '背景颜色',  width: 100, 
			  editor:{
	                type: 'validatebox',
	                options: {
	                    required: true,
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
		    },
		    { field: 'ECSExecutePage',title: '适用页面',  width: 120, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'ID',
                        textField: 'Name',
                        multiple:true,
                        rowStyle:"checkbox",
                        editable:false,
                        data:[{"ID":"NurE","Name":"护士执行"},{"ID":"TechE","Name":"医技执行"},{"ID":"OrdE","Name":"执行记录执行"}],
                        onChange: function (newValue, oldValue){
	                        var sheetObj=$("#colorTab").datagrid('getEditor', {index:editIndex,field:'ECSExecuteSheet'});
	                        var pageStr=$(this).combobox("getValues").join("^");
	                        if (("^"+pageStr+"^").indexOf("^NurE^")>=0) {
		                        sheetObj.target.combobox('enable');
		                    }else{
			                    sheetObj.target.combobox('setValues',"");
			                    sheetObj.target.combobox('disable');
			                }
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["ECSExecutePageDesc"];
	            }
		    },
			{ field: 'ECSExecuteSheet',title: '适用单据',  width: 180, 
			   editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'ID',
                        textField: 'Name',
                        multiple:true,
                        rowStyle:"checkbox",
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.OrderExcute.SheetConfig&QueryName=GetAllSheet&rows=99999&ResultSetType=array",
                        onBeforeLoad:function(param){
	                        param.hospId=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["ECSExecuteSheetDesc"];
	            }
		    },
		    { field: 'ECSValidLocs',title: '适用范围',  width: 180, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["ECSValidLocsDesc"];
	            }
		    },
		    { field: 'ECSInValidLocs',title: '不适用范围',  width: 180, 
			  editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["ECSInValidLocsDesc"];
	            }
		    },
		    { field: 'ECSActive',title: '状态',  width: 60, align:'center',
			  formatter: function (value, row) {
	                if (value=="Y") {
		                return "启用";
		            }else if(value=="N"){
			            return "停用"
			        }
                },
                editor: {
                    type : 'icheckbox',options:{on:'Y',off:'N'}
                }
		    }
			
	    ]],
	    onDblClickRow:function(rowIndex, rowData){
		    if (editIndex != rowIndex) {
		        if (endMenuTabEditing()) {
			        editIndex = rowIndex;
		            $('#colorTab').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		            initCombox();
		        } else {
		            $('#colorTab').datagrid('selectRow', editIndex);
		        }
		    }
		},
        onBeforeLoad:function(param){
	        $('#colorTab').datagrid('unselectAll');
	        editIndex = undefined;
	        param.hospId=$HUI.combogrid('#_HospList').getValue();
	    }
    });
}
function endMenuTabEditing(){
	if (editIndex == undefined) { return true; }
	var rows=$('#colorTab').datagrid('getRows');
	if (rows[editIndex]["rowid"]==""){
		$('#colorTab').datagrid('rejectChanges', editIndex);
	}
    $('#colorTab').datagrid('endEdit', editIndex);
    editIndex = undefined;
    return true;
}
function delColorSetData(){
	var sel=$('#colorTab').datagrid("getSelected");
    if (!sel){
       $.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
       return false;
    }
    $.messager.confirm('确认','是否确认删除?',function(r){    
	    if (r){    
	        var rowid=sel["rowid"];
	        var delDataArr=[rowid];
		    $.cm({
				ClassName:GV._CALSSNAME,
				MethodName:"handleExecuteColorSet",
				SaveDataArr:JSON.stringify(delDataArr),
				EVENT:"DELETE"
			},function(rtn){
				if (rtn<0){
					$.messager.popover({msg: '删除失败！'+rtn,type: 'error'});
					return false;
				}else{
					var index=$('#colorTab').datagrid("getRowIndex",sel["rowid"]);
					$('#colorTab').datagrid("deleteRow",index);
				}
			})   
	    }    
	});
}
function saveColorSetData(){
	if (editIndex == undefined){
	   $.messager.popover({msg:'没有需要保存的记录!',type:'error'});
       return false;
	}
	var rows=$('#colorTab').datagrid('getRows');
	var row = rows[editIndex];
	var NullValColumnArr=[];
    var editors=$('#colorTab').datagrid('getEditors',editIndex);
    for (var k=0;k<editors.length;k++){
	    var field=editors[k].field;
	    var fieldOpts = $('#colorTab').datagrid('getColumnOption',field);
	    if (fieldOpts.editor.type=="combobox") {
		    if (fieldOpts.editor.options.multiple){
			    row[field]=$(editors[k].target).combobox("getValues").join("^");
			}else{
				row[field]=$(editors[k].target).combobox("getValue");
			}
		}else if(fieldOpts.editor.type=="icheckbox"){
			row[field]=$(editors[k].target).checkbox("getValue")?"Y":"N";
		}else if(field=="ECSBackgroundColor"){
			row[field]=$.trim($(editors[k].target).color("getValue"));
		}else{
			row[field]=$.trim($(editors[k].target).val());
		}
	    if (fieldOpts.editor.options){
			if ((fieldOpts.editor.options.required)&&(!row[field])){
				NullValColumnArr.push(fieldOpts.title);
			}
		}
	}
	if (NullValColumnArr.length>0){
		$.messager.alert("提示",NullValColumnArr.join("、")+"不能为空！");
		return false;
	}
	if ((row["ECSValidLocs"].split("^").length>0)&&(row["ECSInValidLocs"].split("^").length>0)){
		var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSValidLocs'});
		var locDescArr=$(ed.target).combobox("getText").split(",");
		var  newArr = [];
		for (var i = 0; i < row["ECSInValidLocs"].split("^").length; i++) {
		      for (var j = 0; j < row["ECSValidLocs"].split("^").length; j++) {
			    if (row["ECSValidLocs"].split("^")[j]=="") continue;
		      	if(row["ECSValidLocs"].split("^")[j] === row["ECSInValidLocs"].split("^")[i]){
					newArr.push(locDescArr[j]);
		        }
		    }
		}
		if (newArr.length>0){
			$.messager.popover({msg:newArr.join("、")+" 同时存在于适用范围和不适用范围中,请核实！",type:'error'});
			return false;
		}
	}
	var saveObj={
	    colorSetId:rows[editIndex]["rowid"],
	    ECSHospDR:$HUI.combogrid('#_HospList').getValue()
	}
	$.extend(saveObj,row);	
    $.m({
		ClassName:GV._CALSSNAME,
		MethodName:"handleExecuteColorSet",
		SaveDataArr:JSON.stringify([saveObj]),
		EVENT:"SAVE"
	},function(rtn){
		if (rtn!=0){
			$.messager.popover({msg: '保存失败！'+rtn,type: 'error'});
			return false;
		}else{
			$('#colorTab').datagrid('reload');
		}
	})
}
function initCombox(){
	var rows=$('#colorTab').datagrid('getRows');
	var row=rows[editIndex];
    var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSBackgroundColor'});
	$(ed.target).color({
		required: true,
		editable:true,
		width:100,
		height:30,
		missingMessage:"该输入项为必填项"
	});
	var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSExecuteSheet'});
	if (row["ECSExecuteSheet"]){
		$(ed.target).combobox("setValues",row["ECSExecuteSheet"].split("^"));
	}else{
		$(ed.target).combobox("setValues","");
	}
	var sheetObj=$("#colorTab").datagrid('getEditor', {index:editIndex,field:'ECSExecuteSheet'});
	var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSExecutePage'});
	if (row["ECSExecutePage"]){
		$(ed.target).combobox("setValues",row["ECSExecutePage"].split("^"));
		if (("^"+row["ECSExecutePage"]+"^").indexOf("^NurE^")>=0) {
	        sheetObj.target.combobox('enable');
	    }else{
	        sheetObj.target.combobox('setValues',"");
	        sheetObj.target.combobox('disable');
	    }
	}else{
		$(ed.target).combobox("setValues","");
		sheetObj.target.combobox('setValues',"");
	    sheetObj.target.combobox('disable');
	}
	
	var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSValidLocs'});
	if (row["ECSValidLocs"]){
		$(ed.target).combobox("setValues",row["ECSValidLocs"].split("^"));
	}else{
		$(ed.target).combobox("setValues","");
	}
	var ed = $('#colorTab').datagrid('getEditor', {index:editIndex,field:'ECSInValidLocs'});
	if (row["ECSInValidLocs"]){
		$(ed.target).combobox("setValues",row["ECSInValidLocs"].split("^"));
	}else{
		$(ed.target).combobox("setValues","");
	}
	    
	//var sheetObj=$("#colorTab").datagrid('getEditor', {index:editIndex,field:'ECSExecuteSheet'});
    //sheetObj.target.combobox('disable');
}