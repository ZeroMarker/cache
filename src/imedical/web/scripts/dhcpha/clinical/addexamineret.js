/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:�����ֵ�ά��
*/
var url='dhcpha.clinical.action.csp' ;

var columns =[[  
              {field:'code',title:'����',width:180},
			  {field:'desc',title:'����',width:180}, 
			  {field:'libdesc',title:'��ʶ',width:180}, 
			  {field:'libdr',title:'��ʶid',hidden:true}, 
			  {field:'active',title:'����',width:60},
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var extuomgrid;
var ajax;
var dg = {
	url: url+'?action=QueryExamineretList',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#examinegrid', //grid ID
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


		
	  $('#combolabel').combobox({ 
		  panelHeight: "auto",
		  url:url+"?action=QueryLibLabelComb" , 
		  valueField:'rowid', 
		  textField:'desc',
		  onSelect: function (record) {
			 //$("#hide_quale").val(record.ID);
		  },
		  onLoadSuccess:function(){
				  //��ʼֵ
				  var data = $('#combolabel').combobox('getData');
				  if (data.length > 0) {
						  //$('#route').combobox('select', data[0].rowid);
					  } 
		  }

	  });
          


 �x�x�xextuomgrid = new DataGrid(dg);
   �x�xextuomgrid.init();  
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
				var row = $("#examinegrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
					return;
				}
				var rowid=row.rowid;

			}

			var libdr=$('#combolabel').combobox('getValue')

�x�x�x�x�x�xvar input=code+"^"+desc+"^"+libdr+"^"+active+"^"+rowid ;
            
            rq.url=url+'?action=AddExamineFeild' ;
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
	
	$('#examinegrid').datagrid('load',  {  
				action: 'QueryExamineretList'
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
    var libdr=rowData.libdr ;
	$('#combolabel').combobox('setValue', libdr);

	


}


