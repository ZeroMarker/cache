    //引用函数窗体

	var url="dhcpha.clinical.action.csp";


	AddFunWindow= function(Fn)
    {
  

			$('#addFunWin').window({ 
			     title:' ',
			     minimizable:false,
			     maximizable:false,
			     collapsible:false,
			     width:1000,   
			     height:600,   
			     modal:true
			});

 

            var mywin = document.getElementById("addFunWin");
			if (mywin)
			{
				mywin.style.display="block";
			}




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




	   //函数库grid
	   fungrid = new TreeGrid(tg);
	   fungrid.init();  


	   var opt=$("#funtionsgrid").treegrid('options');
	   opt.onDblClickRow=function(rowData){
	　　　　　
		　　　var fun=rowData.funtions;
	          var fundr=rowData.rowid;
	          Fn(fun,fundr);
			  CloseWin();
		 
	   } 



	 function CloseWin()
	 {
		    
           $('#addFunWin').window('close');

	 }














 
  
       
}

     

