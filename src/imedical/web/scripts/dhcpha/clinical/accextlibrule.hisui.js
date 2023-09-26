/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:函数项目维护
*/

var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// 知识库类别标记

$(function(){

	InitPageComponent();	/// 初始化界面控件
	InitPageDataGrid();		/// 初始化界面Datagrid
	InitButton();			/// 初始化界面界面按钮响应

});


// 初始化界面控件
function InitPageComponent(){
	
		/// 知识库类型
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //数据加载完毕事件
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibComboListNew";
	new ListCombobox("libcombo",url,'',option).init();

}


// 初始化界面DataGrid
function InitPageDataGrid(){

	/// 医院
	///  定义columns
	var hospcolumns=[[
		{field:'desc',title:'医院',width:400}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	
	///  定义datagrid
	var hospoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: false,
	    onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"hosp";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('错误提示','知识库不能为空!',"error");
				return;			
			}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///职称
	var ctpcolumns=[[  
		{field:'desc',title:'职称',width:400}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var ctpoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"cpt";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('错误提示','知识库不能为空!',"error");
				return;			
			}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryCtCptList&rows=100&page=1";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///医生科室
	var docloccolumns=[[  
		{field:'code',title:'科室',width:200,hidden:true}, 
		{field:'desc',title:'科室',width:400}, //qunianpeng 2017/10/9
		{field:'rowid',title:'rowid',hidden:true}
	]];	
	var doclocoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doclocbar',
		onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"docloc";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('错误提示','知识库不能为空!',"error");
				return;			
			}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryDocLocList&rows=100&page=1&input=";
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();
	
	///医生
	var doccolumns=[[  
		{field:'desc',title:'医生',width:200},
		{field:'code',title:'工号',width:200},  
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var docoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doctorbar',
		onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"doc";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('错误提示','知识库不能为空!',"error");
				return;			
			}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// 权限列表
	var accitmclumns=[[ 
		{field:'desc',title:'描述',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'知识库',width:80}, 
		{field:'ralation',title:'关系',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'控制',hidden:true},
		{field:'chk',title:'选择',hidden:true}
	]];	
	var accoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		//fit : false,
		toolbar:'#toolbar',
		pageSize : [150],
		pageList : [150,300,450],
		pagination: true,
		 onLoadSuccess: function (index,data) { //数据加载完毕事件
           $.each(data.rows,function(tmpindex,obj){
	           if (obj._parentId == ""){
		       		return true;		// 退出本次循环
		       }
		       if(obj.chk == "Y"){
			   		$HUI.treegrid("#accitmgrid").checkNode(obj.id);	
			   }
	       })
        }		
			   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibAccMenu";
	new ListTreeGrid('accitmgrid', accitmclumns, uniturl, accoption).Init();
}


/// 初始化界面按钮响应
function InitButton(){

	// 科室回车事件
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				input:input	
			});
		 }
	});
	
	// 医生回车事件
	$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13") {			 
			 var input=$.trim($("#doctorno").val());  			
			$('#docgrid').datagrid('load',  {  
				input:input	
			});
		 }
　 });

	$("#btnSave").click(function(){
	   	SaveAcc();
    })
}

/// 查询授权项目
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		input:input
	
	}); 
}


//保存授权
function SaveAcc()
{
	if (currPointer == ""){
		$.messager.alert("提示","请选择知识库和授权对象!","info");
		return ;
	}
	
    var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("提示","请选择需要授权的项目后进行保存！!","info");
	    return;
	  
	}
    var tmpPar = "";
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){
			continue; 
		}
		else{
			if(tmpPar == allCheck[i]._parentId){
				continue;
			}
			tmpPar = allCheck[i]._parentId;
			var checkInfo = "";
			var parRowID = "";
			for(var j=0;j<allCheck.length;j++){
				if (allCheck[j]._parentId != allCheck[i]._parentId){				
					continue;
				}
				if (checkInfo == ""){
					checkInfo = allCheck[j].rowid + ":" + "Y"	;
				}else{
					checkInfo = checkInfo +"^"+ allCheck[j].rowid + ":" + "Y"	;
				}	
				parRowID = 	allCheck[j].rowid.split("||")[0];		
			}
			if (input == ""){
				input = parRowID +":"+ "Y" + "^"+ checkInfo;
			}else{
				input = input + "!" +parRowID +":"+ "Y" + "^"+ checkInfo;
			}			
				
		}
	}
	input = currPointer+"@"+input; 
	Save(input);   
 }
 
function Save(input){
	runClassMethod("web.DHCSTPHCMADDEXTLIB","SaveAccItm",{"input":input},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("提示","保存失败:"+jsonString,"error");
		}else{
			$.messager.alert("提示","保存成功","info");
		}
	},'text',false)

}
 
