/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:������Ŀά��
*/


var url='dhcpha.clinical.action.csp' ;
var itmTypeArr = [{ "val": "ҽ��", "text": "ҽ��" }, { "val": "����", "text": "����" }]   //wangxuejian 2016-09-20  ������Ŀά��������
//����
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //��ǰѡ��ĺ�����id
var curfunitmrowid=""; //��ǰѡ��ĺ�����Ŀid
var type="";  //��ǰѡ��ĺ�����Ŀ����  wangxuejian 2016-09-21

var funscolumns=[[  
			  {field:'desc',title:'����',width:120}, 
			  {field:'code',title:'����',width:80},
			  {field:'funtions',title:'�������ʽ',width:200},
			  {field:'returnval',title:'����ֵ',width:80},
			  {field:'remark',title:'��ע',width:80},
			  {field:'active',title:'����',width:60},
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
			  ]];

var tg = {
	url: url+'?action=QueryFuntionLib',  //csp, ��Ϊnull
	columns: funscolumns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#funtionsgrid', //grid ID
	field:'rowid', 
	treefield:'desc',
	params:null

}

var itmclumns=[[{field:'theme',title:'����',width:180},
 			  {field:'code',title:'����',width:100},
			  {field:'desc',title:'����',width:160},
			  {field:'funtions',title:'�������ʽ',width:100},
			 // {field:'arguments',title:'���',width:100,hidden:true},
			  {field:'remark',title:'��ע',width:100},
			  {field:'active',title:'����',width:40,align:'center'},
			  {field:'type',title:'����',width:40,align:'center'},  
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'fundr',title:'fundr',hidden:true},
			  {field:'themedr',title:'themedr',hidden:true}
			  ]];

var dg = {
	url: url+'?action=QueryFuntionLibItm', 
	columns: itmclumns, 
	pagesize:150,  
	table: '#funitemgrid', 
	field:'rowid',
	params:null,
	fitColumns:true, 
	tbar:null 

}

var tcombclumns=[[    
					  {field:'desc',title:'����',width:150}, 
					  {field:'itmdesc',title:'��Ŀ',width:150},
					  {field:'rowid',title:'rowid',width:50,hidden:true} 
				  ]];


var cbg= {
	url: url+'?action=QueryThemeItmDs&page=1&rows=150&input=Y',
	pw:350,
	columns: tcombclumns, 
	pagesize:150,  
	combo: '#themecombo', 
	idfield:'rowid',
	textfield:'itmdesc',
    valuefield:'rowid',
	multiple:false


}
var themecomb;
var fungrid;
var funitmgrid;

function BodyLoadHandler()
{

       
       //����
	   themecomb=new ComboGrid(cbg);
       themecomb.init();
	   //������grid
	   fungrid = new TreeGrid(tg);
	   fungrid.init();  
	   fungrid.dblclickrow(ShowText);

	   //��Ŀgrid
	   funitmgrid = new DataGrid(dg);
	   funitmgrid.init();  
	   funitmgrid.clickrow(ShowItmText);

        //����
	    $("#btnAdd").click(function (e) { 

                AddFunLib(1);

        })
     
        //����
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);

         })
         //����
         $("#btnClear").click(function(e){
	         ClearFunLib();
         })

        //ҩƷ
		$("#btnOpenDrugWin").click(function (e) { 

               //OpenDrugFunWin(curfunitmrowid);
               if (curfunitmrowid == ""){
	           	  	$.messager.alert('��ʾ','��ѡ������Ӳ��������Ŀ�����ԣ�','warning');
					return;
               }
	            if(type=="����")    //wangxuejian 2016/10/24
	           {
		           $.messager.alert('��ʾ','�������Ͳ������ҽ����Ŀ��','warning');
					return;
	           }
               createArtWin();

         })


		//����
		$("#btnOpenLabWin").click(function (e) { 

               //OpenLabWin(curfunitmrowid);
               if (curfunitmrowid == ""){
	           	  	$.messager.alert('��ʾ','��ѡ������Ӳ��������Ŀ�����ԣ�','warning');
					return;
	           }
	           if(type=="ҽ��")    //wangxuejian 2016/10/24
	           {
		           $.messager.alert('��ʾ','ҽ�����Ͳ�����Ӽ���ָ�꣡','warning');
					return;
	           }
               createLabWin();

         })
         
         initScroll();//��ʼ����ʾ���������  //2014-09-16 bianshuai ����в���ʾ����
         
   //����                       //2016-09-20 wangxuejian
	$('#itmtype').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:itmTypeArr
	});
}
//Ĭ����ʾ���������
function initScroll(){
	var opts=$('#funitemgrid').datagrid('options');   //�������Զ��� 
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
			if((typeof opts.columns[i][j].field)=='undefined')break;    
			text+="'"+opts.columns[i][j].field+"':''";    
			if(j!=inner_len-1){    
				text+=",";    
			}    
		}    
	}    
	text+="}";    
	text=eval("("+text+")");    
	var data={"total":1,"rows":[text]};    
	$('#funitemgrid').datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}
	
///����������
function AddFunLib(opflag)
{  

			if (opflag=="2")  //wangxuejian 2016-09-01
			{
				    
				    rowid=curfunitmrowid ;

					if (rowid=="")
					{
								$.messager.alert('������ʾ','����ѡ����Ҫ���µĺ�����!',"error");
								return;
					}

			}          
	        	
			var code=$.trim($("#code").val());
			var desc=$.trim($("#desc").val());
  
	
			var active="N";
			if ($('#chkactive').attr('checked')) 
			{
				var active="Y" ;
			 }
			var type=$('#itmtype').combobox('getValue'); //����  ��ȡ�����ֵ wangxuejian 2016-09-21
			
            var funtions=$.trim($("#funtions").val());
			//var arguments=$.trim($("#arguments").val());
			var remark=$.trim($("#remark").val());
			
			var theme="";  //����
			var themegrid=$("#themecombo").combogrid("grid");//
			var rows  = themegrid.datagrid('getSelections');//
			for(var i=0; i<rows.length; i++){
					var row = rows[i];
					var rowid=row.rowid ;
					if (theme=="")
					{
						theme=rowid;
					}else{
						theme=theme+","+rowid ; 
					}

			}
            if (theme=="")
			{
						$.messager.alert('������ʾ','���ⲻ��Ϊ��!',"error");
						return;
			}

			if (code=="")
			{
						$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
						return;
			}

			if (funtions=="")
			{
						$.messager.alert('������ʾ','��������Ϊ��!',"error");
						return;
			}
			
			if (type=="")
			{
						$.messager.alert('������ʾ','��Ŀ���Ͳ���Ϊ��!',"error");
						return;
			}
			
			if (opflag=="1")// wangxuejian 2016-09-01
			{
				rowid="" ;
			}

                        if (opflag=="2")
			{
				    
				    rowid=curfunitmrowid ;
			}
	
			var input=code+"^"+desc+"^"+active+"^"+curfunrowid+"^"+type+"^"+remark+"^"+rowid+"^"+theme ;
	    //rq.url=url+'?action=AddFunLibItem' ;
        //rq.data={"input":input},
        
 //��������                                                               
	$.post(url+'?action=AddFunLibItem',{"input":input},function(data){     // wangxuejian 2016-09-12
		
		var jsonObj = $.parseJSON(data); //json��ʽת��  

		if(jsonObj.retvalue==0)
		{
	        $.messager.alert("��ʾ","����ɹ�!");
		}
		if(jsonObj.retvalue==1)
		{
				$.messager.alert("������ʾ","����Ŀ�Ѵ���,����ʧ��!","error");
		}
		$('#funitemgrid').datagrid('reload'); //���¼���
	    $('#funitemgrid').datagrid('clearSelections') //wangxuejian 2016/10/24 
	    curfunitmrowid=""    //wangxuejian 2016/10/24
	    
	});
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
				 funitmgrid.loaddata();

			 }
		 }
}



function ShowText(rowData)
{
	
    $("#funtions").val(rowData.funtions);
	curfunrowid=rowData.rowid;
	
	

}

function ShowItmText(rowIndex, rowData)
{
	
	curfunitmrowid=rowData.rowid;
	curfunrowid=rowData.fundr;

	$("#code").val(rowData.code);
	$("#desc").val(rowData.desc);
    $("#funtions").val(rowData.funtions);
	//$("#arguments").val(rowData.arguments);
	$("#remark").val(rowData.remark);
	var active=rowData.active ;
	
	if (active=="Y")
	{
		$('#chkactive').attr("checked",true);
	}else{
		
        $('#chkactive').attr("checked",false);
	}

    $("#themecombo").combogrid("clear"); 
	$('#themecombo').combogrid('grid').datagrid('selectRecord',rowData.themedr);
	
	$('#itmtype').combobox("clear");        //����  wangxuejian 2016-09-21
	$('#itmtype').combobox('setValue',rowData.type)  //���¸�����ֵ
	type=rowData.type;
	

}


/*function OpenDrugFunWin(curfunitmrowid)    //wangxuejian 2016-09-21
{
	AddDrugFunWindow(curfunitmrowid,setArgs);
}


function setArgs(args)
{

	$("#arguments").val(args);

}


function OpenLabWin(curfunitmrowid)
{
	AddLabFunWindow(curfunitmrowid,setArgs);
}*/

/// ���ҽ����Ŀ
function createArtWin(){
	
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('�����Ŀ', 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.funlibitmart.csp?funLibItmID='+curfunitmrowid+'&funLibItmType='+type+'&MWToken='+websys_getMWToken()+'"></iframe>'; //wanguejian   2016-09-21  ���ݲ���
	$("#newItmWin").html(iframe);
}
/// ��Ӽ���ָ��
function createLabWin(){
	
	/// ��ѯ����
	var option = {
		collapsible:true,
		border:true,
		closed:"true"
	};
	new WindowUX('�����Ŀ', 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.funlibitmlabart.csp?funLibItmID='+curfunitmrowid+'&funLibItmType='+type+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);
}
function ClearFunLib(){
	 
	$("#code").val("");
	$("#desc").val("");
	$("#chkactive").attr("checked",false)//δѡ��
    $("#funtions").val("");
	$("#remark").val("");
	$('#itmtype').combobox("setValue",""); //����      
	$("#themecombo").combogrid("clear");//����	 
 }
 