/*
模块:		移动药房
子模块:		移动药房-备药规则维护
Creator:	hulihua
CreateDate:	2016-10-07
*/
var currEditRow=undefined; //控制行编辑
$(function(){
    InitDrawSortDetail();
	commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
	//货位检索采用回车事件
     $('#sbdesctext').keyup(function(e){
        if(e.which == "13")    
        {
			find();
		}
    }); 
    $('#drawsortdetail').datagrid('loadData',{total:0,rows:[]});
	$('#drawsortdetail').datagrid('options').queryParams.params = "";     
});

///单击显示备药规则明细
function onClickRow(index,row){
	var phlocdr=row["PhLocId"];
	var dsid=row["ID"];
	var params=phlocdr+"^"+dsid;
	$('#drawsortdetail').datagrid('load',{params:params});
}

///双击编辑备药规则
function onDblClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

///默认选中第一行
function LoadSuccessRow(){
	if ($('#datagrid').datagrid("getRows").length>0){
		$('#datagrid').datagrid("selectRow", 0)
	}else{
	    $('#drawsortdetail').datagrid('loadData',{total:0,rows:[]});
		$('#drawsortdetail').datagrid('options').queryParams.params = "";     	
	}
	find();
}

/// 检查条件
function ChkCondition(){
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	if (phlocdr==""||phlocdr==null){
		$.messager.alert('提示',"药房不能为空!","info");
		return false;
	}
	return true ;
} 

///检索右边明细
function find(){
	if (ChkCondition()==false) return;
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	var sbdesc=$.trim($("#sbdesctext").val());
	var row =$("#datagrid").datagrid('getSelected');
	if (row==null){
		return;
	}
	var dsid=row.ID;
	var params=phlocdr+"^"+dsid+"^"+sbdesc;
	$('#drawsortdetail').datagrid('load',{params:params});
}

///新增备药规则
function addRow(){
	if (ChkCondition()==false) return;
	var phlocdr=$('#CombPhaloc').combobox('getValue');
	commonAddRow({'datagrid':'#datagrid',value:{'PhLocId':phlocdr}});
}

///保存备药规则
function save(){
	saveByDataGrid("web.DHCINPHA.MTDrawSort.DrawSortQuery","Save","#datagrid",function(data){
			if(data==0){
				$("#datagrid").datagrid('reload');
				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
			}else if(data==-1){
				$.messager.alert("提示","代码或者描述为空,不能保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-11){
				$.messager.alert("提示","代码重复,不能保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-12){
				$.messager.alert("提示","描述重复,不能保存!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}

///删除备药规则
function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个备药排序规则删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除所选的备药排序规则记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		runClassMethod("web.DHCINPHA.MTDrawSort.SqlDbDrawSort","Delete",{'Id':row.ID},function(data){
			if(data==0){
				$("#datagrid").datagrid('reload')
			}else if(data==-1){
				$.messager.alert("提示","未选中所要删除的记录!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-2){
				$.messager.alert("提示","所选中记录已删除!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('提示','删除失败:'+data)
			}  
		});
    }    
});

}
///初始化备药规则明细列表
function InitDrawSortDetail(){
	//定义columns
	var columns=[[  
	    {field:'TSBID',title:'货位ID',width:100,hidden:true},     
        {field:'TSBCode',title:'货位代码',width:200,align:'center'},
        {field:'TSBDesc',title:'货位描述',width:200,align:'center'},
        {field:'TDSId',title:'主表ID',width:200,hidden:true},
        {field:'TDSiId',title:'ID',width:100,hidden:true},
        {field:'TDSiSN',title:'SN顺序',width:100,align:'right',
        	editor:{
				type:'numberbox',
				options:{
					precision:0
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
        }     
   ]];  
	
   //定义datagrid	
   $('#drawsortdetail').datagrid({    
      url:LINK_CSP+'?ClassName=web.DHCINPHA.MTDrawSort.DrawSortQuery&MethodName=GetDrawSortDetailList',
      fit:true,
	  border:false,
	  singleSelect:true,
	  rownumbers:true,
      columns:columns,
      pageSize:50,  // 每页显示的记录条数
	  pageList:[20,50,100,300],   // 可以设置每页记录条数的列表
	  loadMsg: '正在加载信息...',
	  pagination:true,    
	  onLoadSuccess: function(){
		if (currEditRow!=undefined){
			$('#drawsortdetail').datagrid('endEdit', currEditRow);
			currEditRow = undefined
		}
	  },
  	  onClickCell: function (rowIndex, field, value) {
		if (field!="TDSiSN"){return;}
	  	if (rowIndex != currEditRow) {
        	if (endEditing(field)) {
				$("#drawsortdetail").datagrid('beginEdit', rowIndex);
				var editor = $('#drawsortdetail').datagrid('getEditor', {index:rowIndex,field:field});
	     	    editor.target.focus();
	     	    editor.target.select();
				$(editor.target).bind("blur",function(){
                	endEditingdt(field);      
            	});
				currEditRow=rowIndex;  
        	}
		}		
			  	  
  	  }  
   });
 }

///验证输入的SN的合法性
var endEditingdt = function (field) {
    if (currEditRow == undefined) { return true }
    if ($('#drawsortdetail').datagrid('validateRow', currEditRow)) {
        var ed = $('#drawsortdetail').datagrid('getEditor', { index: currEditRow, field: field });
		var selecteddata = $('#drawsortdetail').datagrid('getRows')[currEditRow]; 
		var dsid=selecteddata["TDSId"];
		var dsiid=selecteddata["TDSiId"];
		var dsisbid=selecteddata["TSBID"];
		var dsisn=selecteddata["TDSiSN"];
        var inputtxt=$(ed.target).numberbox('getValue');
        $('#drawsortdetail').filter(":contains('2')").addClass("promoted")
	    if (inputtxt<0){ t
	    	$.messager.alert('错误提示',"第 "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (currEditRow+1)+'</span>'+" 行SN顺序不能小于0!","info");
	    	return false;
	    }
		$('#drawsortdetail').datagrid('updateRow',{
			index: currEditRow,
			row: {TDSiSN:inputtxt}
		});
		var detaildata=dsid+"^"+dsiid+"^"+inputtxt+"^"+dsisbid;
		savedata(detaildata);
        $('#drawsortdetail').datagrid('endEdit', currEditRow);
        currEditRow = undefined;
        return true;
    } else {
        return false;
    }
}

///保存备药规则明细的SN
function savedata(detaildata){
	var data=tkMakeServerCall("web.DHCINPHA.MTDrawSort.DrawSortQuery","SaveDeatil",detaildata)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","没有选择规则或者货位码为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!');		
		}else if(data==-3){	
			$.messager.alert('提示','SN重复,请重新输入!');		
		}
		$("#drawsortdetail").datagrid('reload');
	}	
}
