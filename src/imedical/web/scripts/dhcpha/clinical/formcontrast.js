/*
Creator:LiangQiang
CreatDate:2014-09-20
Description:�����ֵ�ά��
*/
var url='dhcpha.clinical.action.csp' ;

var mainrowid="";
var columns =[[  
              {field:'code',title:'����',width:180},
			  {field:'desc',title:'����',width:180}, 
			  {field:'type',title:'����',width:40}, 
			  {field:'active',title:'����',width:40},
			  {field:'rowid',title:'rowid',width:40}
			  ]];

var formgrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtFormList&input=Y',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#formgrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:'#formgridbar' //�Ϲ�����,��Ϊnull

}


//����rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}



var hiscolumns =[[  
              {field:'code',title:'����',width:180},
			  {field:'desc',title:'����',width:180}, 
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'opt',title:'����',width:60,align:'center', 
                   formatter:function(value,rec,index){    
                        var e = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">����</a> ';
                        return e;  
                    }  
              }
			  ]];

var hisformgrid;
var hisdg = {
	url: url+'?action=QueryHisForm',  //csp, ��Ϊnull
	columns: hiscolumns,  //����Ϣ
	pagesize:50,  //һҳ��ʾ��¼��
	table: '#hisformgrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:'#hisgridbar' //�Ϲ�����,��Ϊnull

}

var concolumns =[[  
			  {field:'opt',title:'����',width:60,align:'center', 
                   formatter:function(value,rec,index){    
                        var e = '<a href="#" mce_href="#" onclick="delconitm(\''+ rec.rowid + '\')">ɾ��</a> ';
                        return e;  
                    }  
              },
              {field:'code',title:'����',width:100},
			  {field:'desc',title:'����',width:100},
			  {field:'hiscode',title:'his����',width:100}, 
			  {field:'hisdesc',title:'his����',width:100}, 
			  {field:'rowid',title:'rowid',hidden:true}

			  ]];

var conformgrid;
var condg = {
	url: url+'?action=QueryFormCon',  //csp, ��Ϊnull
	columns: concolumns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#congrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:null //�Ϲ�����,��Ϊnull

}

function delconitm(rowid)
{
   $.messager.confirm('��ʾ', '��ȷ����������������?', function(r){
		if (r){

					var input=rowid;
                  
					rq.url=url+'?action=DelFormCon' ;
					rq.data={"input":input},

					ajax=new JRequest(rq);
					ajax.post(AddCallback);
		}
	 });

	
}
function addconitm(rowid)
{

	    var main="";
		var selectedrow = $("#formgrid").datagrid("getSelected"); 
		if (selectedrow)
		{
			var main=selectedrow.rowid ;
			mainrowid=main;
		}

		var input=main+"^"+rowid;
        
	    rq.url=url+'?action=ContrastForm' ;
		rq.data={"input":input},

		ajax=new JRequest(rq);
		ajax.post(AddCallback);
}

function BodyLoadHandler()
{


       formgrid = new DataGrid(dg);
       formgrid.init(); 
	   formgrid.clickrow(formgridclick);

	   //
�x�x   conformgrid = new DataGrid(condg);
       conformgrid.init(); 

	   //
�x�x   hisformgrid = new DataGrid(hisdg);
       hisformgrid.init(); 


	   $('#hisdesc').bind('keydown',function(event){
				 if(event.keyCode == "13"){
					 ReLoadHisForm();
				 }
		})


}


function formgridclick(rowIndex, rowData)
{

	ReLoadForm(rowData.rowid);
}



//�ص�
function AddCallback(r,	params)
{

		 if (r)
		 {
			 var ret=r.retvalue; 

			 if (ret=="0")
			 {

					ReLoadForm(mainrowid);
				
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
function ReLoadHisForm()
{
	
	$('#hisformgrid').datagrid('load',  {  
				action: 'QueryHisForm',
				input:$.trim($("#hisdesc").val())
	});

	
}

function ReLoadForm(input)
{
	
	$('#congrid').datagrid('load',  {  
				action: 'QueryFormCon',
				input:input
	});

	
}








