    //���ú�������

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
						  {field:'desc',title:'����',width:300}, 
						  {field:'code',title:'����',hidden:true},
						  {field:'funtions',title:'�������ʽ',width:300},
						  {field:'returnval',title:'����ֵ',width:80},
						  {field:'remark',title:'��ע',width:80},
						  {field:'active',title:'����',width:60,hidden:true},
						  {field:'rowid',title:'rowid',hidden:true},
						  {field:'_parentId',title:'parentId',hidden:true}
						  ]];

			var tg = {
				url: url+'?action=QueryFunLibList',  //csp, ��Ϊnull
				columns: funscolumns,  //����Ϣ
				pagesize:150,  //һҳ��ʾ��¼��
				table: '#funtionsgrid', //grid ID
				field:'rowid', 
				treefield:'desc',
				params:null

			}




	   //������grid
	   fungrid = new TreeGrid(tg);
	   fungrid.init();  


	   var opt=$("#funtionsgrid").treegrid('options');
	   opt.onDblClickRow=function(rowData){
	����������
		������var fun=rowData.funtions;
	          var fundr=rowData.rowid;
	          Fn(fun,fundr);
			  CloseWin();
		 
	   } 



	 function CloseWin()
	 {
		    
           $('#addFunWin').window('close');

	 }














 
  
       
}

     

