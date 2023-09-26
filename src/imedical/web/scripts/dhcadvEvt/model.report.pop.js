
//zhouxin
//2019-07-16
$(function(){
	init();
});


function init(){
	if($("#type").val()=="datagrid"){
		initDataGrid()	
	}else{
		runClassMethod(
					"web.DHCADVModel",
					"EntityToJson",
					{'id':$("#dic").val(),'entity':"User.DHCAdvFormDic"},
					function(data){
						if(data.url==""){
							initTree();
						}else{
							initTree(data.url);
						}
					},"json")	 	
	}
}

function initTree(par){
	var url=LINK_CSP+"?ClassName=web.DHCADVFormDic&MethodName=listTree&id="+$("#dic").val();
	if(par!=undefined){
		url=par
	}
	$('#dataGrid').tree({    
    	url: url, 
    	lines:true,
    	onDblClick: function(node) {
             var key=$("#key").val()
		 	 $('#'+key, window.parent.document).val(node.text);
		 	 $('#'+key, window.parent.document).attr("data-id",node.id)
		 	 window.parent.closeDiv();
        },
        loadFilter:function(data){  
            var newData = new Array();
            var key=$("#key").val();
            var filter = $('#'+key, window.parent.document).val();
            if(filter!=""){
            	for(var i=0; i<data.length; i++){
                	if(data[i].text.indexOf(filter)>=0){  
                    	newData.push(data[i]);  
                	}
            	}	            
	        }
            if(newData.length==0){
                return data; 
            }else{
                return newData; 
 
            }
        },
	});
}
function initDataGrid(){
	var formNameId=$('#formNameId', window.parent.document).val();
	formNameId=(formNameId==undefined)?0:formNameId
	$('#dataGrid').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVFormDic&MethodName=listGrid&queryField="+$("#input").val()+"&queryForm="+formNameId,
		columns:[[
			{field:'ID',hidden:true},
			{field:'field',title:'代码',width:60,align:'center'},
			{field:'title',title:'名称',width:60,align:'center'},
			{field:'style',title:'类型',width:30,align:'center'}		
		 ]],
		title:'双击行选择', 
		fit:true,
		headerCls:'panel-header-gray',
		border:true,
		fitColumns:true,	
		nowrap: false,
		striped: true,
		rownumbers:true,
	    pagination:true,
	    pageSize:10,
	    pageList:[10,20,100],
	    onDblClickRow: function (rowIndex, rowData) {
		 	   var key=$("#key").val()
		 	   $('#'+key, window.parent.document).val(rowData.title);
		 	   $('#'+key, window.parent.document).attr("data-id",rowData.ID)
		 	   window.parent.closeDiv();
	    },onLoadSuccess:function(){
            //默认选中第一行
            $('#dataGrid').datagrid('selectRow',0); 
            //$('#dataGrid').datagrid('keyCtr');
         } 
	});	
}