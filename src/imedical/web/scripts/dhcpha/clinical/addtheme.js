/*
Creator:LiangQiang
CreatDate:2014-07-20
Description:主题字典维护
*/
var url='dhcpha.clinical.action.csp' ;
var lastIndex;


//请求rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

function BodyLoadHandler()
{

	$('#themegrid').datagrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:false,//行号 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  
			  {field:'code',title:'代码',width:80 ,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'desc',title:'描述',width:160,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'active',title:'启用',width:80},
			  {field:'rowid',title:'rowid',width:80}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryFunLibTheme'
			  },
			  //修复双击编辑 duwensheng 2016-09-12
			  onDblClickRow:function(rowIndex, rowData){ 
          
						 $('#themegrid').datagrid('endEdit', lastIndex);    
						 $('#themegrid').datagrid('beginEdit', rowIndex);        
					 lastIndex = rowIndex;
 
			  },
		      onClickRow:function(rowIndex, rowData){ 
                      var main=rowData.rowid;

					  $('#themeitmgrid').datagrid('options').url=url;
					  $('#themeitmgrid').datagrid('load',  {  
							action:'QueryThemeItm',
							main:main
					  });

			  },
				 
			  toolbar: [{
				    text:'增加',
					iconCls: 'icon-add',
					handler: function(){

							insertRow();
						}
				  },{
				    text:'停用/启用',
					iconCls: 'icon-remove',
					handler: function(){
	                                 stopActive()

							
						}
				  },{
				    text:'保存',
					iconCls: 'icon-save',
					handler: function(){

							saveData();
						}
				  }]



		  });

		  //项目列表
		  
	　　　$('#themeitmgrid').datagrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:false,//行号 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  
			  {field:'code',title:'代码',width:80 ,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'desc',title:'描述',width:160,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'rowid',title:'rowid',width:80,hidden:true}
			  ]],
			  //url:url,
			  //queryParams: {
			  //		action:'QueryThemeItm',
			  //		main:'4'
			  //},

			  //修复双击编辑 duwensheng 2016-09-12
			  onDblClickRow:function(rowIndex, rowData){ 
						 $('#themeitmgrid').datagrid('endEdit', lastIndex);    
						 $('#themeitmgrid').datagrid('beginEdit', rowIndex);      
					 lastIndex = rowIndex;
 
			  },
			  toolbar: [{
				    text:'增加',
					iconCls: 'icon-add',
					handler: function(){

							insertItmRow();
						}
				  },{
				    text:'删除',
					iconCls: 'icon-remove',
					handler: function(){
							delItmRow();
						}
				  },{
				    text:'保存',
					iconCls: 'icon-save',
					handler: function(){

							saveItmData();
						}
				  }]



		  });
             
 $('#themeitmgrid').datagrid('loadData',{total:0,rows:[]});


}

//增加项目空行
function insertItmRow()
{

	lastIndex = $('#themeitmgrid').datagrid('getRows').length-1; 
	$('#themeitmgrid').datagrid('endEdit', lastIndex);

	lastIndex = $('#themeitmgrid').datagrid('getRows').length;
	$('#themeitmgrid').datagrid('insertRow',{
					index: lastIndex,	
					row: {
						  code:'',      
					      desc:'',    
					      rowid:''
					}
         

	});

    lastIndex = $('#themeitmgrid').datagrid('getRows').length-1; 
	//$('#themeitmgrid').datagrid('selectRow', lastIndex);  wangxuejian 2016/10/19
	$('#themeitmgrid').datagrid('beginEdit', lastIndex);

}

// 删除选中行  bianshuai 2014-09-19
function delItmRow()
{ 
	var row = $("#themeitmgrid").datagrid('getSelected'); //选中要删除的行
	if (row)
	{
		//提示是否删除
		$.messager.confirm("提示","您确定要删除这些数据吗",function(res){
			if(res){
				$.post(url+'?action=DelFunLibTheItm',{"input":row.rowid}, function(data){
					$('#themeitmgrid').datagrid('reload'); //重新加载
					var rowIndex = $('#themeitmgrid').datagrid('getRowIndex', row);  //wangxuejian 2016/10/19
                                        $('#themeitmgrid').datagrid('deleteRow', rowIndex);  
				});
			}
		});
	}
	else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
} 


//增加空行
function insertRow()
{
	lastIndex = $('#themegrid').datagrid('getRows').length-1; 
	$('#themegrid').datagrid('endEdit', lastIndex);

	lastIndex = $('#themegrid').datagrid('getRows').length;
	$('#themegrid').datagrid('insertRow',{
					index: lastIndex,	
					row: {
						  code:'',      
					      desc:'',    
					      rowid:''
					}
         

	});

    lastIndex = $('#themegrid').datagrid('getRows').length-1; 
	$('#themegrid').datagrid('selectRow', lastIndex);
	$('#themegrid').datagrid('beginEdit', lastIndex);

}




//保存主题数据
function saveData()
{
	$('#themegrid').datagrid('endEdit', lastIndex);
	var rows = $('#themegrid').datagrid('getChanges');                     
    if (rows.length<=0){
		$.messager.alert('错误提示','没有待保存数据!',"error");
		return false;
    }
    var data="";
	if (rows.length > 0) {      
		for (var i = 0; i < rows.length; i++) {   
			var rowdata = rows[i]; 
			    var code=rowdata["code"] ;
				var desc=rowdata["desc"] ;
			    var rowid=rowdata["rowid"] ;
        if((code=="")||(desc=="")){
		    $.messager.alert("提示","代码或描述不能为空!"); 
		    $('#themegrid').datagrid('reload');
			return false;
		}
				var str=code+"^"+desc+"^"+rowid;
				if (data=="")
				{
					data=str;
				}else{
					data=data+"%"+str;
				}
			    
			}      
	}

	if (data=="")
	{
		return;
	}


	rq.url=url+'?action=AddFunLibTheme' ;
	rq.data={"input":data},

	ajax=new JRequest(rq);
	ajax.post(AddCb);
	
	$('#themegrid').datagrid('reload')
}

/// 停/启用      wangxuejian 2016-09-22
function stopActive()
{
	var rows = $('#themegrid').datagrid('getSelected');                     
    if (!(rows)){
		$.messager.alert('错误提示','请先选择一行数据!',"error");
		return;
    }
    
	var activeFlag=""
	var rowid=""
	var data=""
	activeFlag=rows.active;
	rowid=rows.rowid	
	if(activeFlag=="Y")
	{
		activeFlag="N"
	}
	else
	{
		activeFlag="Y"
	}

    data=rowid+"^"+activeFlag
    
    if (data=="")
	{
		return;
	}
    rq.url=url+'?action=StopFunLibTheme' ;
	rq.data={"input":data}
	ajax=new JRequest(rq);
	ajax.post(AddCb);
 $('#themegrid').datagrid('reload'); //重新加载
}

//保存项目数据

function saveItmData()
{
	var mianrow = $("#themegrid").datagrid('getSelected'); 
    if (!(mianrow))
    {
		$.messager.alert('错误提示','请先选择一条主题记录!',"error");
		return;
    }
	var mainid=mianrow.rowid;

	$('#themeitmgrid').datagrid('endEdit', lastIndex);
	var rows = $('#themeitmgrid').datagrid('getChanges'); 
if (rows.length<=0){
		$.messager.alert('错误提示','没有待保存数据!',"error");
		return false;
    }                    

    var data="";
	if (rows.length > 0) {      
		for (var i = 0; i < rows.length; i++) {   
			var rowdata = rows[i]; 
			    var code=rowdata["code"] ;
				var desc=rowdata["desc"] ;
			    var rowid=rowdata["rowid"] ;
        if((code=="")||(desc=="")){
		    $.messager.alert("提示","代码或描述不能为空!"); 
		    $('#themeitmgrid').datagrid('reload');
			return false;
		}
				var str=code+"^"+desc+"^"+rowid;
				if (data=="")
				{
					data=str;
				}else{
					data=data+"%"+str;
				}
			    
			}      
	}

	if (data=="")
	{
		return;
	}

	data =mainid+"@"+data ;
    
	rq.url=url+'?action=AddItmTheme' ;
	rq.data={"input":data},

	ajax=new JRequest(rq);
	ajax.post(AddCb);
	
	$('#themeitmgrid').datagrid('reload')
}

///回调
function AddCb(r,params)
{
	 if (r)
	 {
		 ret=r.retvalue; 
		 
		 if (ret=="0")
		 {
			 $.messager.alert('提示','保存成功');
		 }
		  else if(ret=="1"){
			 $.messager.alert('提示','该项目已经存在');

		 }
		  else if(ret=="2"){
			 $.messager.alert('提示','该主题字典已经存在');

		 }
		 else{
			 $.messager.alert('错误提示','保存失败!',"error");

		 }
	 }else{
		   $.messager.alert('操作提示','连接失败!',"error");
	 }
}
