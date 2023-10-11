var AddAttrCode="DrugLibaryData";
/// 页面初始化函数
function initPageDefault(){

	InitDataList();		//左边 页面DataGrid初始化定义
	//InitDataListnew();			// 右边DataGrid初始化定义
	InitButton();
}

function InitButton(){
$('#queryCode').searchbox({
		    searcher:function(value,name){
		   		QueryDicList();
		    }	   
		});
	
}
/// 页面DataGrid初始定义通用名（药品目录字典）
function InitDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: false //设置编辑规则属性
		}
	}
	
	/*// 职务
	var Roleeditor={type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option) {
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'postID'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'}) ;
							var unitUrl=$URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QueryValue&AddAttrCode="+AddAttrCode;
							$(ed.target).combobox('reload',unitUrl) ;
				    	}	  
					}
	}*/
	
	// 定义columns
	var columns=[[   
			{field:'ID',title:'ID',width:80,hidden:true},
			{field:'postID',title:'描述ID',width:80,editor:texteditor,hidden:true},
			{field:'encoded',title:'代码',width:80,hidden:false,editor:texteditor,hidden:true},
			{field:'post',title:'描述',width:80,hidden:false,editor:texteditor},
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
 			getRuleIframe(rowData.ID);
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=Queryposlifecycle&AddAttrCode="+AddAttrCode;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


function QueryDicList(){
	var params = $HUI.searchbox("#queryCode").getValue();
	var AddAttrCode="DrugLibaryData"
	$('#diclist').datagrid('load',{
		AddAttrCode:AddAttrCode,
		params:params
	})
	
	
	}
	
/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}

	
function getRuleIframe(catalogueid){
	$('#saveTreeDic').attr('src', "dhcckb.sourcepriority.csp?catalogueid="+catalogueid); 
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })