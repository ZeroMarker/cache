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

var freqgrid;
var ajax;
var dg = {
	url: url+'?action=QueryExtFreqList&input=Y',  //csp, ��Ϊnull
	columns: columns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#freqgrid', //grid ID
	field:'rowid', //��¼Ψһ��ʶ
	params:null,  // �����ֶ�,��Ϊnull
	tbar:'#freqgridbar' //�Ϲ�����,��Ϊnull

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

var hisfreqgrid;
var hisdg = {
	url: url+'?action=QueryHisFreq',  //csp, ��Ϊnull
	columns: hiscolumns,  //����Ϣ
	pagesize:50,  //һҳ��ʾ��¼��
	table: '#hisfreqgrid', //grid ID
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

var confreqgrid;
var condg = {
	url: url+'?action=QueryFreqCon',  //csp, ��Ϊnull
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
                  
					rq.url=url+'?action=DelFreqCon' ;
					rq.data={"input":input},

					ajax=new JRequest(rq);
					ajax.post(AddCallback);
		}
	 });

	
}
function addconitm(rowid)
{

	    var main="";
		var selectedrow = $("#freqgrid").datagrid("getSelected"); 
		if (selectedrow)
		{
			var main=selectedrow.rowid ;
			mainrowid=main;
		}

		var input=main+"^"+rowid;
        
	    rq.url=url+'?action=ContrastFreq' ;
		rq.data={"input":input},

		ajax=new JRequest(rq);
		ajax.post(AddCallback);
}

function BodyLoadHandler()
{


       freqgrid = new DataGrid(dg);
       freqgrid.init(); 
	   freqgrid.clickrow(freqgridclick);

	   //
�x�x   confreqgrid = new DataGrid(condg);
       confreqgrid.init(); 

	   //
�x�x   hisfreqgrid = new DataGrid(hisdg);
       hisfreqgrid.init(); 


	   $('#hisdesc').bind('keydown',function(event){
				 if(event.keyCode == "13"){
					 ReLoadHisFreq();
				 }
		})


}


function freqgridclick(rowIndex, rowData)
{

	ReLoadFreq(rowData.rowid);
}



//�ص�
function AddCallback(r,	params)
{

		 if (r)
		 {
			 var ret=r.retvalue; 

			 if (ret=="0")
			 {

					ReLoadFreq(mainrowid);
				
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
function ReLoadHisFreq()
{
	
	$('#hisfreqgrid').datagrid('load',  {  
				action: 'QueryHisFreq',
				input:$.trim($("#hisdesc").val())
	});

	
}

function ReLoadFreq(input)
{
	
	$('#congrid').datagrid('load',  {  
				action: 'QueryFreqCon',
				input:input
	});

	
}








