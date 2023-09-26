/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:通用名字典维护
*/
var url='dhcpha.clinical.action.csp' ;

var genrowid="";
var columns =[[ 
              {field:'code',title:'代码',width:200},
			  {field:'desc',title:'描述',width:200}, 
			  {field:'atc',title:'Atc编码',width:100},
			  {field:'otc',title:'OTC',width:60},
			  {field:'cat',title:'分类',width:150},
			  {field:'cat',title:'成分',width:150},
			  {field:'active',title:'启用',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var extgengrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtGenList',  //csp, 空为null
	columns: columns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#extgengrid', //grid ID
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


 ﹛﹛﹛extgengrid = new DataGrid(dg);
   ﹛﹛extgengrid.init();  
       extgengrid.clickrow(extgengridclick);

	   function extgengridclick(rowIndex, rowData)
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


		//增加成分
		$("#btnAddIngr").click(function (e) { 
		   var row = $("#extgengrid").datagrid("getSelected"); 
			if (!(row))
			{	$.messager.alert('错误提示','请先选择一条记录!',"error");
				return;
			}
			var gendr=row.rowid;
			genrowid=row.rowid;
			AddIngrWindow(gendr);
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
            var atc=$.trim($("#atccode").val());
			var cat=$.trim($("#cat").val());
	
			var otc="N";
			if ($('#otcflag').attr('checked')) 
			{
				var otc="Y" ;
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
				var row = $("#extgengrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('错误提示','请先选择一条记录!',"error");
					return;
				}
				var rowid=row.rowid;

			}

﹛﹛﹛﹛﹛﹛var input=code+"^"+desc+"^"+atc+"^"+otc+"^"+cat+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddExtGen' ;
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
	
	$('#extgengrid').datagrid('load',  {  
				action: 'QueryExtGenList'
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

	
	$("#atccode").val(rowData.atc);

	var otc=rowData.otc ;
	if (otc=="Y")
	{
		$('#otcflag').attr("checked",true);
	}else{
		
        $('#otcflag').attr("checked",false);
	}







}


 //删除通用名成分明细
 function DelGenIngr(index)
 {
			var rows = $('#ingrgrid').datagrid('getRows');
			var rowid = rows[index]['rowid'];
			var input=rowid ;
            
            rq.url=url+'?action=DelGenIngr' ;
            rq.data={"input":input},

            ajax=new JRequest(rq);
            ajax.post(AddGenIngrBack);
			
	}

//维护成分窗体
function AddIngrWindow(gendr)
{

		if($("#addingrwin").length>0)
	    {
		   $("#addingrwin").remove(); 
		    
	    }

		$(document.body).append('<div id="addingrwin" style="width:450px;height:500px;border:2px solid #E6F1FA;position:absolute"></div>') 
		$("#addingrwin").append('<div id="ingrgrid"></div>');


		$(document.body).append('<div id="ingrgridtbr" style="padding: 5px; height:50px; background:#fafafa"></div>')
		$("#ingrgridtbr").append('<table id="ttbl"></table>');
		var str= "<tr><td>成分</td><td><input id=\"comboingr\"></td><td><a id=\"btnok\" href=\"#\" >保存</a></td><td><a id=\"btnclose\" href=\"#\" >关闭</a></td>        </tr>"
		$("#ttbl").append(str);

		var mydiv=$("#addingrwin");
		var x = ($(window).width()-450)/2;
		var y = ($(window).height()-500)/2;  
		mydiv.css("position","absolute"); 
		mydiv.css("top",y).css("left",x);  
		mydiv.show();


		mycols = [[
		  {field:'desc',title:'成分名称',width:220}, 
		  {field:'rowid',title:'rowid',hidden:true},
		  {field:'opt',title:'操作',width:60,align:'center', 
                   formatter:function(value,rec,index){   
                        var d = '<a href="#" mce_href="#" onclick="DelGenIngr(\''+ index + '\')">删除</a> ';
                        return d;  
                    }  
              }

	    ]];

		mydgs = {
	     
			url:url+'?action=QueryGenIngr&phgendr='+gendr,
			columns: mycols, 
			pagesize:30,  
			table: '#ingrgrid', 
			field:'rowid', 
			params:null,  
			tbar:'#ingrgridtbr' 

	    }

		var grid = new DataGrid(mydgs);
        grid.init();


		$('#btnok').linkbutton({  
			iconCls: 'icon-add',
			plain:true
			});
	 ﹛ $('#btnclose').linkbutton({   
			plain:true
			});

		$('#comboingr').combogrid({   
			    panelWidth:400,
				width:200,
				idField:'rowid',
				valueField:'rowid',
				textField:'desc', 
				url:null, 
				columns:[[    
				{field:'code',title:'代码',width:150},
			    {field:'desc',title:'描述',width:150}, 
				{field:'rowid',title:'rowid',width:40} 
		        ]],
				striped: true, 
				pagination:true,
				rownumbers:true,
				pageSize:20,
				pageList:[20,40],
				onChange:function(newVal , oldVal){  
									return false;  
							   }

			
		});


		
		$('#comboingr').combogrid({keyHandler: {
				 enter: function (){
					 var input=$.trim($('#comboingr').combogrid('getText'));
					 input=encodeURIComponent(input);
					 $('#comboingr').combogrid('grid').datagrid('options').url=url+'?action=QueryExtIngrList&input='+input+'&active=1';
					 $('#comboingr').combogrid('grid').datagrid('load');
					
                 },
				 query:function(q){  
                        return false;  
                     }  
  
				 }
				 
		}); 
        
		

		$("#btnclose").click(function (e) { 
				  
			$("#addingrwin").remove(); 
		})


		$("#btnclose").click(function (e) { 
				  
			$("#addingrwin").remove(); 
		})
        
		$("#btnok").click(function (e) { 
				         var itms="";
						 var grid=$("#comboingr").combogrid("grid");
						 var rows  = grid.datagrid('getSelections');
						 for(var i=0; i<rows.length; i++){
								var row = rows[i];
								var rowid=row.rowid ;
								if (itms=="")
								{
									itms=rowid;
								}else{
									itms=itms+","+rowid ; 
								}

						 }


					     if (itms=="")
					     {
							 $.messager.alert('操作提示','请先选择成分!',"error");
							 return;
					     }


						 var input=gendr+"^"+itms ;
            
						﹛rq.url=url+'?action=AddGenIngr' ;
						﹛rq.data={"input":input},

						﹛ajax=new JRequest(rq);
						﹛ajax.post(AddGenIngrBack);


		})
        


		





}



		//回调
		function AddGenIngrBack(r,params)
		{

			 if (r)
			 {
				 var ret=r.retvalue; 

				 if (ret=="0")
				 {
						$('#ingrgrid').datagrid('load',  {  
									action: 'QueryGenIngr',
									phgendr:genrowid
						});

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