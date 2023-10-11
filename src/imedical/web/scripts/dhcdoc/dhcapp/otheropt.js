//zhouxin 2016-04-19
var HospID=""
$(function(){ 
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Otheropt",hospStr);
	hospComp.jdata.options.onSelect   = function(){
		HospID=$HUI.combogrid('#_HospList').getValue();
		$('#datagrid').datagrid('load',{AOCode:"",AODesc:"",HospId:HospID}); 
		} 
	//选择上级部位
	$('#datagrid').datagrid({    
		 onClickRow:function(rowIndex, rowData){
	            $("#AOIOptParRef").val(rowData.ID);
	            
	            Initsubdatagrid(rowData.AOType) 
				
				 setTimeout(function(){
					 $('#subdatagrid').datagrid('load', {    
					    AOIOptParRef: rowData.ID  
					});
					 },500)
         },onBeforeEdit:function(rowIndex,rowData){
	         setTimeout(function(){reLoadReq();},200)
	     }
	});
	HospID=$HUI.combogrid('#_HospList').getValue();
	$('#datagrid').datagrid('load',{AOCode:"",AODesc:"",HospId:HospID}); 
	Initsubdatagrid("Check");
});

//函数commonQuery 和 commonReload 说明
//<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="javascript:commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})">查询</a> 

//如上所示在csp中给按钮注册 单击事件
//commonQuery 和 commonReload 的入参都是 json字符串,格式为 {'datagrid':'#datagrid','formid':'#queryForm'}
// 其中datagrid 是datagrid的id
 // formid 是<form>的id ，这个form必须是在所有查询条件的父容器，所有查询条件都必须在这个容器里面
 // <input type="text" name="AOCode" class="textParent"></input>
 //所有查询条件都应该有name属性，这里的属性和后台类的入参名相同
 // 如果满足以上条件，调用commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})
 // 会把#queryForm 下面的所有表单元素提交到datagrid 定义的后台类方法，并且类方法的入参名和表单元素的name一直
 //  commonReload 方法同 commonQuery ,只不过是清空查询条件而已

//其他部位字典新增一行
//commonAddRow 函数说明
//第一个参数 datagrid 是需要新增一行的datagrid的id
//第二个参数 value 是新增行赋初始值
//如果没有需要初始的值可以不传第二个参数
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'AORequired':'Y','AOType':'Input'}})
}
//其他部位字典双击编辑
//第三个参数将双击的datagrid的id传入
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
//其他部位保存
//"web.DHCAPPOtherOpt" 类名
//"save"   			  方法名
//"#datagrid"          要保存的datagrid的id
// 此方法自动将datagrid中的编辑的待保存的数据传入后台
// 一行数据之间用 "^" 分割
// 多行数据之间用 "$$" 分割
// 提交 到后台的参数名是 params
// 第四个参数是后台执行完的回调函数

function save(){
	saveByDataGridNew("web.DHCAPPOtherOpt","save","#datagrid",function(data){
			if(data==0){
				$.messager.alert('提示','保存成功')			
			}else if(data==-10){
				$.messager.alert('提示','代码重复')	
			}else{
				$.messager.alert('提示','保存失败:'+data)
			}
			$("#datagrid").datagrid('reload')
		});	
}
function saveByDataGridNew(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");
	//alert(params)
	var HospID=$HUI.combogrid('#_HospList').getValue();
	runClassMethod(className,methodName,{'params':params,HospID:HospID},handle,datatype)
}
function addRowSub(){
	if($("#AOIOptParRef").val() == ""){
		$.messager.alert('提示','请先选择其它项目字典')
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{AOIOptParRef:$("#AOIOptParRef").val()}})
	subdataEditRow = 0;
}
function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
	subdataEditRow=index
}
function saveSub(){
	saveByDataGrid("web.DHCAPPOtherOpt","saveSub","#subdatagrid",function(data){
		if(data == 0){     //qunianpeng 2016-07-15
			$.messager.alert('提示','添加成功');
		}else if(data == -10){
			$.messager.alert('提示','代码不能重复');
		}else{
			$.messager.alert('提示','添加失败:'+data);
		}		
		$("#subdatagrid").datagrid('reload');
	});	

}

function cancelSub(){
	
	if ($("#subdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#subdatagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","removeSub",{'Id':row.ID},function(data){ $('#subdatagrid').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","remove",{'Id':row.ID},function(data){
			  if(data==1){     //lvpeng  2016/7/13
				$.messager.alert("提示：","此项已被引用，无法删除");	 
			 }else{
				$.messager.alert("提示：","删除成功");	 
		     }
			  $('#datagrid').datagrid('load'); })
    }    
}); 
}

///sufan 增加了commonQuery,commonReload方法
function commonQuery()
{
	var code=$("#code").val();
	var desc=$("#desc").val();
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#datagrid').datagrid('load',{AOCode:code,AODesc:desc,HospId:HospID}); 
}

function commonReload()
{
	$("#code").val("");
	$("#desc").val("");
	commonQuery();
}

/// 根据选择类型设置【是否必填】下拉列表
function reLoadReq(){
	
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AOType'});
	if ($(ed.target).combobox("getValue")== "Check"){
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("clear");
		$(ed.target).combobox("loadData",[{"value":"N","text":'否'}]);
		$(ed.target).combobox('setValue',"N");
	}else{
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("loadData",[{"value":"N","text":'否'},{"value":"Y","text":'是'}]);
	}
	
}
var subdataEditRow=""
function Initsubdatagrid(Type){
	if (Type=="Order"){
		 var Columns=[[   
			{ field: 'AOIOptParRef', title: 'AOIOptParRef', width: 10,hidden:true },
			{ field: 'ID', title: 'ID', width: 10,hidden:true },
			{ field: 'ARCIMDesc', title: '医嘱名称', width: 20,
            	editor:{
              		type:'combogrid',
                    options:{
	                    enterNullValueClear:false,
						required: true,
						panelWidth:450,
						panelHeight:350,
						delay:500,
						idField:'ArcimRowID',
						textField:'ArcimDesc',
						value:'',//缺省值 
						mode:'remote',
						pagination : true,//是否分页   
						rownumbers:true,//序号   
						collapsible:false,//是否可折叠的   
						fit: true,//自动大小   
						pageSize: 10,//每页显示的记录条数，默认为10   
						pageList: [10],//可以设置每页记录条数的列表  
						url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                        columns:[[
                            {field:'ArcimDesc',title:'名称',width:310,sortable:true},
			                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
			                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                         ]],
						onSelect: function (rowIndex, rowData){
							var rows=$('#subdatagrid').datagrid("selectRow",subdataEditRow).datagrid("getSelected");
							rows.ARCIMRowid=rowData.ArcimRowID
						},
						onClickRow: function (rowIndex, rowData){
							var rows=$('#subdatagrid').datagrid("selectRow",subdataEditRow).datagrid("getSelected");
							rows.ARCIMRowid=rowData.ArcimRowID
						},
						onLoadSuccess:function(data){
							$(this).next('span').find('input').focus();
						},
						onBeforeLoad:function(param){
							if (param['q']) {
								var desc=param['q'];
							}
							param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
						}
            		}
    			  }
			},
			{ field: 'Number', title: '数量', width: 20,editor : {type : 'text',options : {}}},
			{ field: 'ARCIMRowid', title: 'ARCIMRowid', width: 10,hidden:true }
			
		 ]];
		}else{
		var Columns=[[   
			{ field: 'AOIOptParRef', title: 'AOIOptParRef', width: 10,hidden:true },
			{ field: 'ID', title: 'ID', width: 10,hidden:true },
			{ field: 'AOICode', title: '代码', width: 50,editor : {type : 'text',options : {required:true}}},
			{ field: 'AOIDesc', title: '描述', width: 150,editor : {type : 'text',options : {required:true}}
			}
		 ]];
		}
		$('#subdatagrid').datagrid({  
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			title:"其它项目内容维护",
			toolbar:'#subtoolbar',
			columns :Columns,
		    rownumbers:true,
		    method:'get',
		    fitColumns:true,
		    singleSelect:true,
		    pagination:true,
		    nowrap: false,
		    onDblClickRow:onClickRowSub,
			url:'dhcapp.broker.csp?ClassName=web.DHCAPPOtherOpt&MethodName=listSub',
			onClickRow:function(rowIndex, rowData){
			}
	});
	}
