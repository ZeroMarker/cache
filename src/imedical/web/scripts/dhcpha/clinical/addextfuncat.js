/*
Creator:LiangQiang
CreatDate:2015-11-12
Description:֪ʶ�⺯���ֵ�ά��
*/
var url='dhcpha.clinical.action.csp' ;

var columns =[[  
              {field:'code',title:'����',width:180},
			  {field:'desc',title:'����',width:180}, 
			  {field:'active',title:'����',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var extuomgrid;
var ajax;
var dg = {
	url: url+'?action=QueryFunCatList',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#funcatgrid', //grid ID
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

var funcatgridopt;

function BodyLoadHandler()
{


 ������extuomgrid = new DataGrid(dg);
   ����extuomgrid.init();  
       extuomgrid.clickrow(extuomgridclick);

	   function extuomgridclick(rowIndex, rowData)
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

        
		//funcatgridopt=GetGridOpt("#funcatgrid");
		
		//funcatgridopt.onClickCell=function(rowIndex, field, value){
					  
		//}


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
				var row = $("#funcatgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
					return;
				}
				var rowid=row.rowid;

			}
            
            var input=code+"^"+desc+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddFuncatFeild' ;
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
	
	$('#funcatgrid').datagrid('load',  {  
				action: 'QueryFunCatList'
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


