/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:ͨ�����ֵ�ά��
*/
var url='dhcpha.clinical.action.csp' ;

var genrowid="";
var columns =[[ 
              {field:'code',title:'����',width:200},
			  {field:'desc',title:'����',width:200}, 
			  {field:'atc',title:'Atc����',width:100},
			  {field:'otc',title:'OTC',width:60},
			  {field:'cat',title:'����',width:150},
			  {field:'cat',title:'�ɷ�',width:150},
			  {field:'active',title:'����',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var extgengrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtGenList',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#extgengrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:'#gridtoolbar' //�Ϲ�����,��Ϊnull

}


//����rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}


function BodyLoadHandler()
{


 �x�x�xextgengrid = new DataGrid(dg);
   �x�xextgengrid.init();  
       extgengrid.clickrow(extgengridclick);

	   function extgengridclick(rowIndex, rowData)
	   {           

			 ShowText(rowData);

	   }
        //����
		$("#btnAdd").click(function (e) { 

                AddFunLib(1);

         })
     
        //����
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);

         })


		//���ӳɷ�
		$("#btnAddIngr").click(function (e) { 
		   var row = $("#extgengrid").datagrid("getSelected"); 
			if (!(row))
			{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
				return;
			}
			var gendr=row.rowid;
			genrowid=row.rowid;
			AddIngrWindow(gendr);
		 })




}





///�����y����
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
						$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
						return;
			}
		    if (desc=="")
			{
						$.messager.alert('������ʾ','��������Ϊ��!',"error");
						return;
			}
            
			if (opflag==1)
			{
				//����
				var rowid="";

			}
			if (opflag==2)
			{
				//����
				var row = $("#extgengrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
					return;
				}
				var rowid=row.rowid;

			}

�x�x�x�x�x�xvar input=code+"^"+desc+"^"+atc+"^"+otc+"^"+cat+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddExtGen' ;
            rq.data={"input":input},

            ajax=new JRequest(rq);
            ajax.post(AddCallback);


		

			



}



//�ص�
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
					 $.messager.alert('������ʾ','�����ظ�����!',"error");
					 return;

				 }
				 $.messager.alert('������ʾ','����ʧ��!',"error");
			 }
          
		 }else{
				 $.messager.alert('������ʾ','����ʧ��!',"error");
		 }

}


//ˢ��
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


 //ɾ��ͨ�����ɷ���ϸ
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

//ά���ɷִ���
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
		var str= "<tr><td>�ɷ�</td><td><input id=\"comboingr\"></td><td><a id=\"btnok\" href=\"#\" >����</a></td><td><a id=\"btnclose\" href=\"#\" >�ر�</a></td>        </tr>"
		$("#ttbl").append(str);

		var mydiv=$("#addingrwin");
		var x = ($(window).width()-450)/2;
		var y = ($(window).height()-500)/2;  
		mydiv.css("position","absolute"); 
		mydiv.css("top",y).css("left",x);  
		mydiv.show();


		mycols = [[
		  {field:'desc',title:'�ɷ�����',width:220}, 
		  {field:'rowid',title:'rowid',hidden:true},
		  {field:'opt',title:'����',width:60,align:'center', 
                   formatter:function(value,rec,index){   
                        var d = '<a href="#" mce_href="#" onclick="DelGenIngr(\''+ index + '\')">ɾ��</a> ';
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
	 �x $('#btnclose').linkbutton({   
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
				{field:'code',title:'����',width:150},
			    {field:'desc',title:'����',width:150}, 
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
							 $.messager.alert('������ʾ','����ѡ��ɷ�!',"error");
							 return;
					     }


						 var input=gendr+"^"+itms ;
            
						�xrq.url=url+'?action=AddGenIngr' ;
						�xrq.data={"input":input},

						�xajax=new JRequest(rq);
						�xajax.post(AddGenIngrBack);


		})
        


		





}



		//�ص�
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
						 $.messager.alert('������ʾ','�����ظ�����!',"error");
						 return;

					 }
					 $.messager.alert('������ʾ','����ʧ��!',"error");
				 }
			  
			 }else{
					 $.messager.alert('������ʾ','����ʧ��!',"error");
			 }


		  }