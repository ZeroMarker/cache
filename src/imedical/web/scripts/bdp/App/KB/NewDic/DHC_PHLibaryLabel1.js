/*
Creator:石萧伟
CreatDate:2018-07-23
Description:知识库标识字典
*/
//var url='dhcpha.clinical.action.csp' ;
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=GetList";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHLibaryLabel";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=DeleteData";
var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassMethod=NewOpenData";

var columns =[[  
              {field:'PHLICode',title:'代码',width:180},
			  {field:'PHLIDesc',title:'描述',width:180}, 
			  {field:'PHLIActiveFlag',title:'启用',width:60},
			  {field:'PHLIRowId',title:'PHLIRowId',hidden:true}
			  ]];

var extuomgrid;
var ajax;
var dg = {

	url: QUERY_ACTION_URL,  //csp, 空为null
	columns: columns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#funcatgrid', //grid ID
	field:'PHLIRowId', //记录唯一标识
	params:null,  // 请求字段,空为null
	tbar:'#gridtoolbar' //上工具栏,空为null

}


//请求rq
/*var rq={
	url: "",  
	async:true,
	type:'json',
	data:null
}

var funcatgridopt;*/

function BodyLoadHandler()
{


 　　　extuomgrid = new DataGrid(dg);
   　　extuomgrid.init();  
       extuomgrid.clickrow(extuomgridclick);

	   function extuomgridclick(rowIndex, rowData)
	   {           

			 ShowText(rowData);

	   }
        //新增
		$("#btnAdd").click(function (e) { 

                AddFunLib(1);

         })
     
        //更新
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);

         })

        //删除
		$("#btnDel").click(function (e) { 

                DeleteFunLib();

         })  
        //重置
		$("#btnRel").click(function (e) { 

                ClearFunLib();

         })   		 
		//funcatgridopt=GetGridOpt("#funcatgrid");
		
		//funcatgridopt.onClickCell=function(rowIndex, field, value){
					  
		//}


}


///新增、更新
function AddFunLib(opflag)
{            
	        		
			var code=$.trim($("#code").val());
			var desc=$.trim($("#desc").val());
  
	
			var active="N";
			if ($('#chkactive').attr('checked')) 
			{
				var active="Y" ;
			 }

            
			if (code=="")
			{
						$.messager.alert('错误提示','代码不能为空!',"error");
						return;
			}
		    if (desc=="")
			{
						$.messager.alert('错误提示','描述不能为空!',"error");
						return;
			}
            
			if (opflag==1)
			{
				//增加
				var rowid="";

			}
			if (opflag==2)
			{
				//更新
				var row = $("#funcatgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('错误提示','请先选择一条记录!',"error");
					return;
				}
				var rowid=row.PHLIRowId;

			}
            
            /*var input=code+"^"+desc+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddFuncatFeild' ;
            rq.data={"input":input},

            ajax=new JRequest(rq);
            ajax.post(AddCallback);*/
			$('#form-save').form('submit', { 
				url: SAVE_ACTION_URL, 
				onSubmit: function(param){
					param.PHLIRowId = rowid;
				},
				success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
					$.messager.show({ 
					  title: '提示消息', 
					  msg: '提交成功', 
					  showType: 'show', 
					  timeout: 1000, 
					  style: { 
						right: '', 
						bottom: ''
					  } 
					}); 
					 $('#funcatgrid').datagrid('reload');  // 重新载入当前页面数据  
					 ClearFunLib();
				  } 
				  else { 
					var errorMsg ="更新失败！"
					if (data.errorinfo) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
					}
					 $.messager.alert('操作提示',errorMsg,"error");
        
				}

				} 
			}); 


		

			



}

///删除
function DeleteFunLib()
{                  

	//更新
	var row = $("#funcatgrid").datagrid("getSelected"); 
	if (!(row))
	{	$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	var rowid=row.PHLIRowId;

	$.ajax({
		url:DELETE_ACTION_URL,  
		data:{"id":rowid},  
		type:"POST",   
		//dataType:"TEXT",  
		success: function(data){
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
					$.messager.show({ 
					  title: '提示消息', 
					  msg: '删除成功', 
					  showType: 'show', 
					  timeout: 1000, 
					  style: { 
						right: '', 
						bottom: ''
					  } 
					}); 
					 ClearFunLib()
					 $('#funcatgrid').datagrid('reload');  // 重新载入当前页面数据  
				  } 
				  else { 
					var errorMsg ="删除失败！"
					if (data.info) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.info
					}
					 $.messager.alert('操作提示',errorMsg,"error");
        
				}			
		}  
	})

}

//重置
function ClearFunLib()
{
	$('#form-save').form('clear')
}
//回调
/*function AddCallback(r,	params)
{

		 if (r)
		 {
			 var ret=r.retvalue; 
	
			 if (ret=="0")
			 {
				ReLoad();
			 }else{
                 if (ret=="-99"){
					 $.messager.alert('操作提示','不能重复增加!',"error");
					 return;

				 }
				 $.messager.alert('操作提示','更新失败!',"error");
			 }
          
		 }else{
				 $.messager.alert('操作提示','连接失败!',"error");
		 }

}


//刷新
function ReLoad()
{
	
	$('#funcatgrid').datagrid('load',  {  
				action: 'QueryFunCatList'
	});

	
}*/


function ShowText(rowData)
{
	/*$("#code").val(rowData.PHLICode);
	$("#desc").val(rowData.PHLIDesc);

	var active=rowData.PHLIActiveFlag ;
	if (active=="Y")
	{
		$('#chkactive').attr("checked",true);
	}else{
		
        $('#chkactive').attr("checked",false);
	}*/
	
	//对于普通的input元素，只要json中的key与表单元素的name一致，就可以自动填充，如果不一致，那只能自己手动通过获取元素$("#name").val(record.name); 去设置
	var record = $("#funcatgrid").datagrid("getSelected"); 
	//$('#form-save').form("load",OPEN_ACTION_URL+'&id='+record.PHLIRowId);
	$('#form-save').form("load",record);

}
