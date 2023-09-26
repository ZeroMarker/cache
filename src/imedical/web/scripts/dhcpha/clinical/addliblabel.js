/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:剂型字典维护
*/
var url='dhcpha.clinical.action.csp' ;

var columns =[[  
              {field:'code',title:'代码',width:180},
			  {field:'desc',title:'描述',width:180}, 
			  {field:'active',title:'启用',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var extuomgrid;
var ajax;
var dg = {
	url: url+'?action=QueryLibLabelList',  //csp, 空为null
	columns: columns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#liblabelgrid', //grid ID
	field:'rowid', //记录唯一标识
	params:null,  // 请求字段,空为null
	tbar:'#gridtoolbar' //上工具栏,空为null

}


//请求rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}


function BodyLoadHandler()
{


 ﹛﹛﹛extuomgrid = new DataGrid(dg);
   ﹛﹛extuomgrid.init();  
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


}





///新增﹜更新
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
				var row = $("#liblabelgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('错误提示','请先选择一条记录!',"error");
					return;
				}
				var rowid=row.rowid;

			}

﹛﹛﹛﹛﹛﹛var input=code+"^"+desc+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddLibLabel' ;
            rq.data={"input":input},

            ajax=new JRequest(rq);
            ajax.post(AddCallback);


		

			



}



//回调
function AddCallback(r,	params)
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
	
	$('#liblabelgrid').datagrid('load',  {  
				action: 'QueryLibLabelList'
	});

	
}


function ShowText(rowData)
{
	$("#code").val(rowData.code);
	$("#desc").val(rowData.desc);

	var active=rowData.active ;
	if (active=="Y")
	{
		$('#chkactive').attr("checked",true);
	}else{
		
        $('#chkactive').attr("checked",false);
	}

	


}


