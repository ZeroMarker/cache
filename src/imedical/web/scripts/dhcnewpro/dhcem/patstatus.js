///CreatDate:  2016-08-01
///Author:    lvpeng 
var editRow = "";
var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
$(function(){
	//自定义编辑器在 jquery.easyui.extend.js 增加，需要实现编辑器的4个默认方法
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					//options.enterNullValueClear=false;
					var input = $('<select class="hisui-combogrid" id="combogrid" style="width:210px">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
	
	//描述绑定回车事件
     $('#Stdesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
   
   	hospComp = GenHospComp("DHC_EmPatStatusAcc");  //hxy 2020-05-26
    hospComp.options().onSelect = function(){///选中事件
		//$("#datagrid").datagrid('load');
		//$("#datagrid1").datagrid('loadData',{total:0,rows:[]});
		ClickRowSys();
	}//ed
});

///csp中状态授权表类型值调用
function fillValue(rowIndex, rowData){
	$('#datagrid1').datagrid('getRows')[editIndex]['PSAPointer']=rowData.id
}

///单击编辑 产品表(父表) 
function ClickRowSys(){
	var row =$("#datagrid").datagrid('getSelected');
	PVId=row.ID; ///父id
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	$('#datagrid1').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatus&MethodName=ListPstAccItm&PVId='+PVId+'&HospDr='+HospDr //hxy 2020-05-26 +'&HospDr='+HospDr
	});
	
	}


///新增行 状态授权表(子表) 
function addRowPsaAcc(){
	 if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请先选择 病人状态表！');
		return;
	 }
	 var row =$("#datagrid").datagrid('getSelected');
	 PVSRowId=row.ID; ///父id  
	 var HospDr=hospComp.getValue(); //hxy 2020-06-02
	commonAddRow({'datagrid':'#datagrid1',value:{'PSAStatusDr':PVSRowId,'HospDr':HospDr}}) //hxy 2020-06-02 HospDr
}
///双击编辑 状态授权表(子表)
function onClickRowSysItm(index,row){
	CommonRowClick(index,row,"#datagrid1");
	PSAtypeID=row.PSAType;
	var rowIndex=$('#datagrid1').datagrid('getRowIndex',$('#datagrid1').datagrid('getSelected'))
	var varEditor = $('#datagrid1').datagrid('getEditor', { index: rowIndex, field: 'PointerDesc' });
	$(varEditor.target).combogrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatStatus&MethodName=ListGroup&type='+PSAtypeID
	})
}

///双击编辑 状态授权表(子表)
function onClickRowSys(rowIndex,row){
	if ((editRow != "")||(editRow == "0")) { 
        $("#datagrid").datagrid('endEdit', editRow); 
    } 
    $("#datagrid").datagrid('beginEdit', rowIndex); 
    editRow = rowIndex;
}


///保存 状态授权表(子表)
function savePsaAcc(){
	saveByDataGrid("web.DHCEMPatStatus","SavePsaAcc","#datagrid1",function(data){
			if(data==0){
				$.messager.alert("提示","保存成功!");
				$("#datagrid1").datagrid('load')
			}else if(data==1){
				$.messager.alert("提示","指向值已存在,不能重复保存!"); 
				$("#datagrid1").datagrid('load')
			}else if(data==2){
				$.messager.alert("提示","手动录入无效,请下拉选择!"); 
				$("#datagrid1").datagrid('load')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				$("#datagrid1").datagrid('load')
			}
		});	
}

///删除 状态授权表(子表)
function cancelPsaAcc(){
	var row =$("#datagrid1").datagrid('getSelected');  

	if (row== null) {
		$.messager.alert('提示','请选择一行记录删除');
		return;
	}
	
	if(row.ID==""||row.ID==undefined){
		$.messager.alert('提示','选中记录未保存！');
		return;
	}
	
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	        
		 runClassMethod("web.DHCEMPatStatus","RemovePsaAcc",{'Id':row.ID},function(data){
			if(data==0){
				$.messager.alert('提示','删除成功！');
				$('#datagrid1').datagrid('load'); 
				return;			
			}else{
			$.messager.alert('提示','删除失败！');	
			}
		 })
    }    
}); 
}


function addRowPsa(){
	
	if(editRow>="0"){
		$("#datagrid").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#datagrid").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#datagrid').datagrid('selectRow',0);
			$("#datagrid").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#datagrid").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {PTCode:'', PTDesc:'', PTProCombo:'', PTProID:'', ID:''}
	});
	$("#datagrid").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;	
}

function savePsa(){
	
	if(editRow>="0"){
		$("#datagrid").datagrid('endEdit', editRow);
	}

	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","warning");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PTCode=="")||(rowsData[i].PTDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!","warning"); 
			return false;
		}
	
		var tmp=rowsData[i].ID +"^"+ rowsData[i].PTCode +"^"+ rowsData[i].PTDesc +"^"+ rowsData[i].PTProID +"^"+ rowsData[i].AutoDis+"^"+ rowsData[i].Active;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMPatStatus","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#datagrid').datagrid('reload'); //重新加载
	})	
}



/// 删除选中行
function cancelPsa(){
	
	var rowsData = $("#datagrid").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMPatStatus","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#datagrid').datagrid('reload'); //重新加载
					$('#datagrid1').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	}else if (value=='N'){
		return '否';
	}
}
