/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:������Ŀά��
*/


var url='dhcpha.clinical.action.csp' ;

var currEditRow="";currEditID="";currPointer="";currLibDr=""

var libcbclumns=[[    
					  {field:'desc',title:'����',width:150}, 
					  {field:'rowid',title:'rowid',width:50,hidden:true} 
				  ]];
var libcbg= {
	url: url+'?action=QueryLibComboList&page=1&rows=150&input=Y',
	pw:350,
	columns: libcbclumns, 
	pagesize:150,  
	combo: '#libcombo', 
	idfield:'rowid',
	textfield:'desc',
    valuefield:'rowid',
	multiple:false


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
			//alert(option.text)
		}
	}
}


//����rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //��ǰѡ��ĺ�����id
var curfunitmrowid=""; //��ǰѡ��ĺ�����Ŀid


///ҽ��
var doccolumns=[[  
              {field:'code',title:'����',width:200}, 
			  {field:'desc',title:'ҽ��',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var tg = {
	url: url+'?action=QueryAccDocList',  //csp, ��Ϊnull
	columns: doccolumns,  //����Ϣ
	pagesize:30,  //һҳ��ʾ��¼��
	table: '#docgrid', //grid ID
	field:'rowid', 
	params:null,
	tbar:'#doctorbar'

}

///ҽ������
var docloccolumns=[[  
              {field:'code',title:'����',width:200,hidden:true}, 
               {field:'desc',title:'����',width:200}, //qunianpeng 2017/10/9
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var docloctg = {
	url: url+'?action=QueryAccDocLocList',  //csp, ��Ϊnull
	columns: docloccolumns,  //����Ϣ
	pagesize:30,  //һҳ��ʾ��¼��
	table: '#doclocgrid', //grid ID
	field:'rowid', 
	params:null,
	tbar:'#doclocbar'

}

///ҽԺ
var hospcolumns=[[  
              {field:'desc',title:'ҽԺ',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var hosptg = {
	url: url+'?action=QueryHospList',  //csp, ��Ϊnull
	columns: hospcolumns,  //����Ϣ
	pagesize:30,  //һҳ��ʾ��¼��
	table: '#hospgrid', //grid ID
	field:'rowid', 
	params:null

}

///ְ��
var ctpcolumns=[[  
              {field:'desc',title:'ְ��',width:200}, 
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];

var cpttg = {
	url: url+'?action=QueryCtCptList',  //csp, ��Ϊnull
	columns: ctpcolumns,  //����Ϣ
	pagesize:30,  //һҳ��ʾ��¼��
	table: '#cptgrid', //grid ID
	field:'rowid', 
	params:null

}

var detailcolumns=[[  
			  {field:'desc',title:'��Ŀ',width:200}, 
			  {field:'relat',title:'��ϵ',width:80,editor:relatcombo},
			  {field:'pri',title:'���ȼ�',width:80, 
                    formatter:function(value,rec,index){    
                        var a = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">����</a> ';
						var b = '<a href="#" mce_href="#" onclick="addconitm(\''+ rec.rowid + '\')">����</a> ';
                        return a+b;  
                    }  
			  },
			  {field:'rowid',title:'rowid',hidden:true}
			  ]];


var detailtg = {
	url: null, //url+'?action=QueryLibRuleDs',  //csp, ��Ϊnull
	columns: detailcolumns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#detailgrid', //grid ID
	field:'rowid', 
	params:null

}

var itmclumns=[[ 
			  {field:'desc',title:'��Ŀ',width:200}, 
			  {field:'active',title:'��ϵ',width:60},  
			  {field:'code',title:'����',hidden:true},
			  {field:'fun',title:'�������ʽ',hidden:true},
			  {field:'remark',title:'��ע',width:80},
			  {field:'active',title:'����',width:60},  
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'fundr',title:'fundr',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
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



var accitmclumns=[[ 
			  {field:'desc',title:'����',width:200,formatter:title_formatter}, 
			  {field:'libdr',title:'libdr',hidden:true}, 
			  {field:'lib',title:'֪ʶ��',width:50}, 
			  {field:'ralation',title:'��ϵ',hidden:true},   
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'id',title:'id',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true},
			  {field:'contrl',title:'����',hidden:true},
			  {field:'chk',title:'ѡ��',hidden:true}
			  ]];

var accitmtg = {
	url: url+'?action=QueryLibAccMenu', 
	columns: accitmclumns, 
	pagesize:1000,  
	table: '#accitmgrid', 
	field:'id',
	treefield:'desc',
	params:null,  
	tbar:'#accitmtbar'
		


}



var hospgrid;
var docgrid;
var doclocgrid;
var cptgrid;
var detailgrid;
var funitmgrid;
var accitmgrid;

function BodyLoadHandler()
{


    ��$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 
			 var input=$.trim($("#doctorno").val());
  
				$('#docgrid').datagrid('load',  {  
							action: 'QueryAccDocList',
							input:input
				});

		 }
������ });
		//���һس��¼� qunianpeng  2017/4/17
		$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 
			 var input=$.trim($("#doclocbarid").val());
  
				$('#doclocgrid').datagrid('load',  {  
							action: 'QueryAccDocLocList',
							input:input
				});

		 }
������ });
       //֪ʶ��
	   libcomb=new ComboGrid(libcbg);
       libcomb.init(); 

	   var opt=$("#libcombo").combogrid('options');
	   opt.onSelect=function(){
		   var libdr= $('#libcombo').combogrid('grid').datagrid('getSelected').rowid;  
		   currLibDr=libdr;
		   
	   }

       //ҽ��
	   docgrid = new DataGrid(tg);
	   docgrid.init();
	   
	   var opt=$("#docgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"doc";
		   QueryAccitm(input);
	   }

��������//ҽ������
	   doclocgrid = new DataGrid(docloctg);
	   doclocgrid.init();
	   
	   var opt=$("#doclocgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"docloc";
		   QueryAccitm(input);
	   }

��������//ҽԺ
       hospgrid = new DataGrid(hosptg);
	   hospgrid.init(); 

	   var opt=$("#hospgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){

		   if (currLibDr=="")
		   {
			   		$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
					return;
		   }
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"hosp";
		   QueryAccitm(input);
	   }
��������//ְ��
       cptgrid = new DataGrid(cpttg);
	   cptgrid.init();

	   var opt=$("#cptgrid").datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   var pointer=rowData.rowid;
		   var input=currLibDr+"^"+pointer+"^"+"cpt";
		   QueryAccitm(input);
	   }



	   //��Ŀgrid  
	   funitmgrid = new TreeGrid(itmtg);
	   funitmgrid.init();


	   //��Ȩgrid  
	   accitmgrid = new TreeGrid(accitmtg);
	   accitmgrid.init();
	   $('#accitmgrid').datagrid('loadData', {total:0,rows:[]}); //qnp add 2017-4-13

	   var opt=$("#accitmgrid").treegrid('options');
	   opt.onClickRow=function(rowData){
	   }



	   opt.onClickRow=function(rowData){
             //������Ϻ��ȡ���е�checkbox����

                 //�õ�����е�ѡ��ťѡ��
				  //var id="set_power_"+rowData.id;

                  //var val=document.getElementById(id);   //.value ;
				  //val.checked=!(val.checked);
           

       }

	


        //����
	    $("#btnSave").click(function (e) { 

                SaveAcc();

        })
     





			 

}


//������Ȩ
function SaveAcc()
{
    var input="";
	var roots=$('#accitmgrid').treegrid('getRoots');
    //for(i=0;i<roots.length;i++){
	for(i=0;i<1;i++){

		children=$('#accitmgrid').treegrid('getChildren',roots[i].target);
		for(j=0;j<children.length;j++) 
		{
	         var flag="N";
			 var id="set_power_"+children[j].id;
             var val=document.getElementById(id); 
			 if (val.checked)
			 {
				 var flag="Y";
			 }
	         var onerow=children[j].rowid+":"+flag;
            
			 if (children[j]._parentId=="")
			 {
				 
				 if (input=="")
				 {
					 input=onerow ;
				 }else{
					 input=input+"!"+onerow ;
				 }
			 }else{

				 if (input=="")
				 {
					 input=onerow ;
				 }else{
					 input=input+"^"+onerow ;
				 }
			 }
		}		 
    }
   
	input=currPointer+"@"+input;
	Save(input);

   /*
    var chk_value =[];//����һ������    
	$('input[name="set_power"]:checked').each(function(){//����ÿһ������Ϊinterest�ĸ�ѡ������ѡ�е�ִ�к���    
		alert($(this).val());//��ѡ�е�ֵ��ӵ�����chk_value��  
		
		//var id = $(this).attr("id");
		//alert(id)
	});

	*/
}


function title_formatter(value,node){ 
	
	
	if (node.chk=="Y")
	{
		    var content='<input name="set_power" id="set_power_'+node.id+'" onclick="set_power_status('+node.id+')"  type="checkbox" checked value="'+node.rowid+'" />'+value;  
            
	}else{

		    var content='<input name="set_power" id="set_power_'+node.id+'" onclick="set_power_status('+node.id+')"  type="checkbox"  value="'+node.rowid+'" />'+value;  

	}
   
    return content;  
} 


function set_power_status(menu_id){
		
	var nodeValue = $("#set_power_"+menu_id).val();	/// qunianpeng 2018/4/13 ���Ӻ������ƣ�1.���ڵ�ȫѡ/��ѡ 2.�ӽڵ�ѡ�У����ڵ��Զ�ѡ��
	var nodeArray = nodeValue.split("||");
	var rootNode = nodeArray[0];					/// ���ڵ�value
	if (nodeArray.length == 1){						/// ���ڵ�
		if($("#set_power_"+menu_id).is(':checked')){	/// ���ڵ�ѡ�У��ӽڵ�ȫѡ
			$("input[name=set_power]").each(function(){	
				var chlidArray = this.value.split("||");
				if (chlidArray[0] == rootNode ){
					$('#'+this.id).attr("checked",'true'); 			
				}	
			});
		}else{
			$("input[name=set_power]").each(function(){	/// ���ڵ�ȡ�����ӽڵ�ȡ��ȫѡ
				var chlidArray = this.value.split("||");
				if (chlidArray[0] == rootNode ){
					$('#'+this.id).removeAttr("checked"); 			
				}	
			});
		}	
	}else{												/// �ӽڵ�
		if($("#set_power_"+menu_id).is(':checked')){	/// �ӽڵ�ѡ��ʱ,�Զ�ѡ�и��ڵ�				
			$("input[name=set_power]").each(function(){	/// �������е�input �ҵ����ڵ�
				if (this.value == rootNode ){
					$('#'+this.id).attr("checked",'true'); 			
				}
			});
		}			
	}	
} 

///����
function Save(input)
{            

			rq.url=url+'?action=SaveAccItm' ;
            rq.data={"input":input},
            ajax=new JRequest(rq);
            ajax.post(SaveCallback);



}

//����ص�
function SaveCallback(r)
{
		if (r)
		 {
			 ret=r.retvalue; 
			 
			 if (ret=="0")
			 {
				 QueryAccitm(currPointer);

			 }
		 }
}

function QueryAccitm(input)
{

	currPointer=input;
	$('#accitmgrid').treegrid('load',  {  
				action: 'QueryLibAccMenu',
				input:input
	});

}

