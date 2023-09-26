/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:函数项目维护
*/
var RelationArray=[{ "value": "And", "text": "And" },{ "value": "Or", "text": "Or" }]; // qunianpeng 2017/04/17
var url='dhcpha.clinical.action.csp' ;


//请求rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //当前选择的函数库id
var curfunitmrowid=""; //当前选择的函数项目id

var funscolumns=[[  
			  {field:'desc',title:'描述',width:300}, 
			  {field:'code',title:'代码',hidden:true},
			  {field:'funtions',title:'函数表达式',width:300},
			  {field:'returnval',title:'返回值',width:80},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:60,hidden:true},
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
			  ]];

var tg = {
	url: url+'?action=QueryFunLibList',  //csp, 空为null
	columns: funscolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#funtionsgrid', //grid ID
	field:'rowid', 
	treefield:'desc',
	params:null

}



var relatcombo={  //设置其为可编辑
	type: 'combobox', //设置编辑格式
	options: {
		//required: true, //设置编辑规则属性
		panelHeight:"auto",
		valueField: "value", 
		textField: "text",
		data: [{
			text: 'And',
			value: 'And'
		},{
			text: 'Or',
			value: 'Or'
		}],
		onSelect:function(option){
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'reasondr'});
			//$(ed.target).val(option.value);  //设置科室ID
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'usereason'});
			//$(ed.target).combobox('setValue', option.text);  //设置科室Desc

			//var text=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'text'});
		
			 $("#relation").val(option.text);
		}
	}
}



var itmclumns=[[ 
			  {field:'desc',title:'项目',width:200}, 
			  {field:'relation',title:'关系',editor:relatcombo},  
			  {field:'code',title:'代码',width:100},
			  {field:'fun',title:'函数',width:300},
			  {field:'arguments',title:'入参',width:200},
			  {field:'val',title:'返回值',width:80},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:40},  
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'fundr',title:'fundr',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true},
			  {field:'catdr',title:'分类id',hidden:true},
			  ]];

var itmtg = {
	url: url+'?action=QueryLibItemDs', 
	columns: itmclumns, 
	pagesize:150,  
	table: '#funitemgrid', 
	field:'rowid',
	treefield:'desc',
	params:null,  
	tbar:null
		


}

var tcombclumns=[[    
					  {field:'desc',title:'分类',width:150}, 
					  {field:'rowid',title:'rowid',width:50,hidden:true} 
				  ]];


var cbg= {
	url: url+'?action=QueryFunCatList&page=1&rows=150&input=Y',
	pw:350,
	columns: tcombclumns, 
	pagesize:150,  
	combo: '#catcombo', 
	idfield:'rowid',
	textfield:'desc',
    valuefield:'rowid',
	multiple:false


}







var catgrid;
var fungrid;
var funitmgrid;

function BodyLoadHandler()
{
       //分类
	   catgrid=new ComboGrid(cbg);
       catgrid.init(); 
		
		//关系  2017/4/17 qunianpeng
		$('#relation').combobox({
				panelHeight:"auto",  //设置容器高度自动增长
				data:RelationArray
		});
		$('#relation').combobox('setValue',"Or"); //设置combobox默认值

	   //项目grid  
	   funitmgrid = new TreeGrid(itmtg);
	   funitmgrid.init();

	   var opt=$("#funitemgrid").treegrid('options');
	   opt.onClickRow=function(rowData){
	
		   ShowItmText(rowData);
	   } 

       var lastIndex ;
	  /* opt.onClickCell=function(field,row){     
		         
				 if (field=="relation")
				 {
					 	  var rowIndex = row.rowid;

						 if (lastIndex != rowIndex){ 

						  $("#"+this.id).treegrid('endEdit', lastIndex); 

						  $("#"+this.id).treegrid('beginEdit', rowIndex); 

						  lastIndex = rowIndex;
				         }

				}
		  

	   } */ //2017/10/16 测试组提出取消此处修改方式 qunianpeng 

        //新增
	    $("#btnAdd").click(function (e) { 

                AddFunLib(1);

        })
     
        //更新
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);

         })

		$("#btnImp").click(function (e) { 

                AddFunWindow(setArgs);

         })
		
		


}



function setArgs(args,argid)
{

	$("#funtions").val(args);

	curfunrowid=argid;

}


///新增函数库
function AddFunLib(opflag)
{            
	        	
			var code=$.trim($("#code").val());
			var desc=$.trim($("#desc").val());
  
	
			var active="N";
			if ($('#chkactive').attr('checked')) 
			{
				var active="Y" ;
			 }
            var funtions=$.trim($("#funtions").val());
			var arguments=$.trim($("#arguments").val());
			var remark=$.trim($("#remark").val());
			
			var catdr="";
			var catcombo=$("#catcombo").combogrid("grid");
			var rows  = catcombo.datagrid('getSelections');
			for(var i=0; i<rows.length; i++){
					var row = rows[i];
					catdr=row.rowid ;


			}
	
			var val=$.trim($("#val").val());　//值

			//var relation=$.trim($("#relation").val());　//关系
			var relation=$('#relation').combobox('getValue'); //qunianpeng 2017/4/17
            if (catdr =="")
			{
						$.messager.alert('错误提示','分类不能为空!',"error");
						return;
			}

			if (code=="")
			{
						$.messager.alert('错误提示','代码不能为空!',"error");
						return;
			}

			if (funtions=="")
			{
						//$.messager.alert('错误提示','函数不能为空!',"error");
						//return;
			}

			if (opflag=="1")
			{
				rowid="" ;
			}

			if (opflag=="2")
			{
				    
				    rowid=curfunitmrowid ;

					if (rowid=="")
					{
								$.messager.alert('错误提示','请先选择需要更新的函数项!',"error");
								return;
					}

			}

			var parentid=curfunitmrowid;
		    var input=code+"^"+desc+"^"+curfunrowid+"^"+remark+"^"+active+"^"+catdr+"^"+rowid+"^"+val+"^"+arguments+"^"+parentid+"^"+relation ;


            if (curfunitmrowid=="")
            {		
				    $.messager.confirm('操作提示','没有选择上级项目,确认要增加一级项目吗?',function(r){  
						if (r){ 
							
                                Add(input);
							 
							}
					});							
            }else{

				   Add(input);
			}







}

function Add(input)
{
			rq.url=url+'?action=AddLibItem' ;
            rq.data={"input":input},
            ajax=new JRequest(rq);
            ajax.post(AddFunLibCallback);
}

//新增回调
function AddFunLibCallback(r)
{
		if (r)
		 {
			 ret=r.retvalue; 
			 
			 if (ret=="0")
			 {
				 	$('#funitemgrid').treegrid('load',  {  
								action: 'QueryLibItemDs'
					});

			 }
		 }
}





function ShowItmText(rowData)
{
	
	curfunitmrowid=rowData.rowid;
	curfunrowid=rowData.fundr;

	$("#code").val(rowData.code);
	$("#desc").val(rowData.desc);
    $("#funtions").val(rowData.fun);
	$("#arguments").val(rowData.arguments);
	$("#remark").val(rowData.remark);
	$('#relation').combobox('setValue',rowData.relation);
	var active=rowData.active ;
	
	if (active=="Y")
	{
		$('#chkactive').attr("checked",true);
	}else{
		
        $('#chkactive').attr("checked",false);
	}

    $("#catcombo").combogrid("clear"); 
	$('#catcombo').combogrid('grid').datagrid('selectRecord',rowData.catdr);

	$("#val").val(rowData.val);

	$("#relation").val(rowData.relation);
	
	

}




