/*
Creator:LiangQiang
CreatDate:2014-07-20
Description:�����ֵ�ά��
*/
var url='dhcpha.clinical.action.csp' ;
var lastIndex;


//����rq
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
			  rownumbers:false,//�к� 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  
			  {field:'code',title:'����',width:80 ,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'desc',title:'����',width:160,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'active',title:'����',width:80},
			  {field:'rowid',title:'rowid',width:80}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryFunLibTheme'
			  },
			  //�޸�˫���༭ duwensheng 2016-09-12
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
				    text:'����',
					iconCls: 'icon-add',
					handler: function(){

							insertRow();
						}
				  },{
				    text:'ͣ��/����',
					iconCls: 'icon-remove',
					handler: function(){
	                                 stopActive()

							
						}
				  },{
				    text:'����',
					iconCls: 'icon-save',
					handler: function(){

							saveData();
						}
				  }]



		  });

		  //��Ŀ�б�
		  
	������$('#themeitmgrid').datagrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:false,//�к� 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  
			  {field:'code',title:'����',width:80 ,editor:{
				  type:'text',    
				  options:{     
							required:true 
						  }
				  } 
			  },
			  {field:'desc',title:'����',width:160,editor:{
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

			  //�޸�˫���༭ duwensheng 2016-09-12
			  onDblClickRow:function(rowIndex, rowData){ 
						 $('#themeitmgrid').datagrid('endEdit', lastIndex);    
						 $('#themeitmgrid').datagrid('beginEdit', rowIndex);      
					 lastIndex = rowIndex;
 
			  },
			  toolbar: [{
				    text:'����',
					iconCls: 'icon-add',
					handler: function(){

							insertItmRow();
						}
				  },{
				    text:'ɾ��',
					iconCls: 'icon-remove',
					handler: function(){
							delItmRow();
						}
				  },{
				    text:'����',
					iconCls: 'icon-save',
					handler: function(){

							saveItmData();
						}
				  }]



		  });
             
 $('#themeitmgrid').datagrid('loadData',{total:0,rows:[]});


}

//������Ŀ����
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

// ɾ��ѡ����  bianshuai 2014-09-19
function delItmRow()
{ 
	var row = $("#themeitmgrid").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (row)
	{
		//��ʾ�Ƿ�ɾ��
		$.messager.confirm("��ʾ","��ȷ��Ҫɾ����Щ������",function(res){
			if(res){
				$.post(url+'?action=DelFunLibTheItm',{"input":row.rowid}, function(data){
					$('#themeitmgrid').datagrid('reload'); //���¼���
					var rowIndex = $('#themeitmgrid').datagrid('getRowIndex', row);  //wangxuejian 2016/10/19
                                        $('#themeitmgrid').datagrid('deleteRow', rowIndex);  
				});
			}
		});
	}
	else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
} 


//���ӿ���
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




//������������
function saveData()
{
	$('#themegrid').datagrid('endEdit', lastIndex);
	var rows = $('#themegrid').datagrid('getChanges');                     
    if (rows.length<=0){
		$.messager.alert('������ʾ','û�д���������!',"error");
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
		    $.messager.alert("��ʾ","�������������Ϊ��!"); 
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

/// ͣ/����      wangxuejian 2016-09-22
function stopActive()
{
	var rows = $('#themegrid').datagrid('getSelected');                     
    if (!(rows)){
		$.messager.alert('������ʾ','����ѡ��һ������!',"error");
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
 $('#themegrid').datagrid('reload'); //���¼���
}

//������Ŀ����

function saveItmData()
{
	var mianrow = $("#themegrid").datagrid('getSelected'); 
    if (!(mianrow))
    {
		$.messager.alert('������ʾ','����ѡ��һ�������¼!',"error");
		return;
    }
	var mainid=mianrow.rowid;

	$('#themeitmgrid').datagrid('endEdit', lastIndex);
	var rows = $('#themeitmgrid').datagrid('getChanges'); 
if (rows.length<=0){
		$.messager.alert('������ʾ','û�д���������!',"error");
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
		    $.messager.alert("��ʾ","�������������Ϊ��!"); 
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

///�ص�
function AddCb(r,params)
{
	 if (r)
	 {
		 ret=r.retvalue; 
		 
		 if (ret=="0")
		 {
			 $.messager.alert('��ʾ','����ɹ�');
		 }
		  else if(ret=="1"){
			 $.messager.alert('��ʾ','����Ŀ�Ѿ�����');

		 }
		  else if(ret=="2"){
			 $.messager.alert('��ʾ','�������ֵ��Ѿ�����');

		 }
		 else{
			 $.messager.alert('������ʾ','����ʧ��!',"error");

		 }
	 }else{
		   $.messager.alert('������ʾ','����ʧ��!',"error");
	 }
}
