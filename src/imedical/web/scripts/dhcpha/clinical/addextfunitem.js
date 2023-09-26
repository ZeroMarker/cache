/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:������Ŀά��
*/
var RelationArray=[{ "value": "And", "text": "And" },{ "value": "Or", "text": "Or" }]; // qunianpeng 2017/04/17
var url='dhcpha.clinical.action.csp' ;


//����rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //��ǰѡ��ĺ�����id
var curfunitmrowid=""; //��ǰѡ��ĺ�����Ŀid

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



var relatcombo={  //������Ϊ�ɱ༭
	type: 'combobox', //���ñ༭��ʽ
	options: {
		//required: true, //���ñ༭��������
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
			//$(ed.target).val(option.value);  //���ÿ���ID
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'usereason'});
			//$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc

			//var text=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'text'});
		
			 $("#relation").val(option.text);
		}
	}
}



var itmclumns=[[ 
			  {field:'desc',title:'��Ŀ',width:200}, 
			  {field:'relation',title:'��ϵ',editor:relatcombo},  
			  {field:'code',title:'����',width:100},
			  {field:'fun',title:'����',width:300},
			  {field:'arguments',title:'���',width:200},
			  {field:'val',title:'����ֵ',width:80},
			  {field:'remark',title:'��ע',width:80},
			  {field:'active',title:'����',width:40},  
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'fundr',title:'fundr',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true},
			  {field:'catdr',title:'����id',hidden:true},
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
					  {field:'desc',title:'����',width:150}, 
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
       //����
	   catgrid=new ComboGrid(cbg);
       catgrid.init(); 
		
		//��ϵ  2017/4/17 qunianpeng
		$('#relation').combobox({
				panelHeight:"auto",  //���������߶��Զ�����
				data:RelationArray
		});
		$('#relation').combobox('setValue',"Or"); //����comboboxĬ��ֵ

	   //��Ŀgrid  
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
		  

	   } */ //2017/10/16 ���������ȡ���˴��޸ķ�ʽ qunianpeng 

        //����
	    $("#btnAdd").click(function (e) { 

                AddFunLib(1);

        })
     
        //����
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


///����������
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
	
			var val=$.trim($("#val").val());��//ֵ

			//var relation=$.trim($("#relation").val());��//��ϵ
			var relation=$('#relation').combobox('getValue'); //qunianpeng 2017/4/17
            if (catdr =="")
			{
						$.messager.alert('������ʾ','���಻��Ϊ��!',"error");
						return;
			}

			if (code=="")
			{
						$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
						return;
			}

			if (funtions=="")
			{
						//$.messager.alert('������ʾ','��������Ϊ��!',"error");
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
								$.messager.alert('������ʾ','����ѡ����Ҫ���µĺ�����!',"error");
								return;
					}

			}

			var parentid=curfunitmrowid;
		    var input=code+"^"+desc+"^"+curfunrowid+"^"+remark+"^"+active+"^"+catdr+"^"+rowid+"^"+val+"^"+arguments+"^"+parentid+"^"+relation ;


            if (curfunitmrowid=="")
            {		
				    $.messager.confirm('������ʾ','û��ѡ���ϼ���Ŀ,ȷ��Ҫ����һ����Ŀ��?',function(r){  
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

//�����ص�
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




