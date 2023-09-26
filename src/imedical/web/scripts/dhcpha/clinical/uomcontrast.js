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

var uomgrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtUomList&input=Y',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#uomgrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:'#uomgridbar' //�Ϲ�����,��Ϊnull

}


//����rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}



var hiscolumns =[[  
              {field:'code',title:'����',width:120},
			  {field:'desc',title:'����',width:120},
			  {field:'fac',title:'����',width:80,editor : {  
                       type : 'numberbox',  
                        options : {  
                            required : true  
                        }  
                    }} ,  

			  {field:'fac',title:'����',width:80,editor : {  
                       type : 'numberbox',  
                        options : {  
                            required : true  
                        }  
                    }} , 
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'opt',title:'����',width:60,align:'center', 
                   formatter:function(value,rec,index){    
                        var e = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">����</a> ';
                        return e;  
                    }  
              }
			  ]];

var hisuomgrid;
var hisdg = {
	url: url+'?action=QueryHisUom',  //csp, ��Ϊnull
	columns: hiscolumns,  //����Ϣ
	pagesize:50,  //һҳ��ʾ��¼��
	table: '#hisuomgrid', //grid ID
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

var conuomgrid;
var condg = {
	url: url+'?action=QueryUomCon',  //csp, ��Ϊnull
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
                  
					rq.url=url+'?action=DelUomCon' ;
					rq.data={"input":input},

					ajax=new JRequest(rq);
					ajax.post(AddCallback);
		}
	 });

	
}
function addconitm(rowid)
{

	    var main="";
		var selectedrow = $("#uomgrid").datagrid("getSelected"); 
		if (selectedrow)
		{
			var main=selectedrow.rowid ;
			mainrowid=main;
		}

		var input=main+"^"+rowid;
        
	    rq.url=url+'?action=ContrastUom' ;
		rq.data={"input":input},

		ajax=new JRequest(rq);
		ajax.post(AddCallback);
}

function BodyLoadHandler()
{


       uomgrid = new DataGrid(dg);
       uomgrid.init(); 
	   uomgrid.clickrow(uomgridclick);

	   //
�x�x   conuomgrid = new DataGrid(condg);
       conuomgrid.init(); 

	   //
�x�x   hisuomgrid = new DataGrid(hisdg);
       hisuomgrid.init(); 


	   $('#hisdesc').bind('keydown',function(event){
				 if(event.keyCode == "13"){
					 ReLoadHisUom();


				 }
		})

        



        
	
}






function uomgridclick(rowIndex, rowData)
{

	ReLoadUom(rowData.rowid);
}



//�ص�
function AddCallback(r,	params)
{

		 if (r)
		 {
			 var ret=r.retvalue; 

			 if (ret=="0")
			 {

					ReLoadUom(mainrowid);
				
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
function ReLoadHisUom()
{
	
	$('#hisuomgrid').datagrid('load',  {  
				action: 'QueryHisUom',
				input:$.trim($("#hisdesc").val())
	});

	
}

function ReLoadUom(input)
{
	
	$('#congrid').datagrid('load',  {  
				action: 'QueryUomCon',
				input:input
	});

	
}








