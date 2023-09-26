/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:����ά��
*/

var url='dhcpha.clinical.ckbaction.csp' ;

var currEditRow="";currEditID="";currDetailEditID="";currDetailEditRow="";

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
			//var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'rowid'});
			//$(ed.target).val(option.value);  //���ÿ���ID
			//var text=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'text'});
            var ruledr="";
            var row = $("#rulegrid").datagrid("getSelected");
			if (row)
			{
				ruledr=row.rowid;

			}
			var input=ruledr+"^"+option.value;

			rq.url=url+'?action=UpdLibRule' ;
			rq.data={"input":input},
			ajax=new JRequest(rq);
			ajax.post(UpdLibRuleCallback);
		}
	}
}

var drelatcombo={  //������Ϊ�ɱ༭
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
	        var rowid="";
	        var row = $("#detailgrid").datagrid("getSelected");
			if (row)
			{
				rowid=row.rowid;

			}
			var input=rowid+"^"+option.value+"^"+row.condition;  //qnp ������ǰ������ 17/4/10;

			rq.url=url+'?action=UpdLibRuleItm' ;
			rq.data={"input":input},
			ajax=new JRequest(rq);
			ajax.post(UpdLibRuleCallback);
		}
	}
}

/// Description: ǰ������ѡ��
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10

var condCombo={  //������Ϊ�ɱ༭
	type: 'combobox', //���ñ༭��ʽ
	options: {
		//required: true, //���ñ༭��������
		panelHeight:"auto",
		valueField: "value", 
		textField: "text",
		data: [{
			text: '��',
			value: '��'
		},{
			text: '��',
			value: '��'
		}],
		onSelect:function(option){
            var rowid="";
            var row = $("#detailgrid").datagrid("getSelected");
			if (row)
			{
				rowid=row.rowid;

			}
			var input=rowid+"^"+row.relation+"^"+option.value; //qnp �����˹�ϵ 17/4/10

			rq.url=url+'?action=UpdLibRuleItm' ;
			rq.data={"input":input},
			ajax=new JRequest(rq);
			ajax.post(UpdLibRuleCallback);
		}
	}
}


function upitmclick(index)
{
        
	 var newrow=parseInt(index)-1;	
	 var curr=$("#detailgrid").datagrid('getData').rows[index];
	 var currowid=curr.rowid;
	 var currordnum=curr.ordnum;
	 var up =$("#detailgrid").datagrid('getData').rows[newrow];
	 if (up === undefined){
	     return;
	 }
	 var uprowid=up.rowid;
     var upordnum=up.ordnum;  
	 var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	      
     SaveItmUp(input);
	 mysort(index, 'up', 'detailgrid');
}

function downitmclick(index)
{

	 var newrow=parseInt(index)+1 ;	
	 var curr=$("#detailgrid").datagrid('getData').rows[index];
	 var currowid=curr.rowid;
	 var currordnum=curr.ordnum;
	 var down =$("#detailgrid").datagrid('getData').rows[newrow];
	 if (down === undefined){
	     return;
	 }
	 var downrowid=down.rowid;
     var downordnum=down.ordnum;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	
     SaveItmUp(input);
	 mysort(index, 'down', 'detailgrid');
}


function upclick(index)
{
     var newrow=parseInt(index)-1; 	
	 var curr=$("#rulegrid").datagrid('getData').rows[index];
	 var currowid=curr.rowid;	 
	 var currordnum=curr.ordnum;
	 var up =$("#rulegrid").datagrid('getData').rows[newrow];
	 if(up === undefined){		// �������
		 return;
	}
	 var uprowid=up.rowid;
     var upordnum=up.ordnum;
	 var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;

     SaveUp(input);
	 mysort(index, 'up', 'rulegrid');     
	
}



function downclick(index)
{

	 var newrow=parseInt(index)+1 ;	
	 var curr=$("#rulegrid").datagrid('getData').rows[index];
	 var currowid=curr.rowid;	 
	 var currordnum=curr.ordnum;
	 var down =$("#rulegrid").datagrid('getData').rows[newrow];
	 if(down === undefined){		// �������
		 return;
	}
	 var downrowid=down.rowid;
     var downordnum=down.ordnum;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'down', 'rulegrid');
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

var rulecolumns=[[  
	{field:'desc',title:'����',width:100}, 
	{field:'lib',title:'֪ʶ��',width:80}, 
	{field:'ordnum',title:'ordnum',hidden:true},
	{field:'relat',title:'��ϵ',width:80,editor:relatcombo},
	{field:'pri',title:'���ȼ�',width:100, 
	    formatter:function(value,rec,index){    
	         var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
	        return a+b; 
	    }  
	},
	{field:'rowid',title:'rowid',width:65}
]];

var tg = {
	url: url+'?action=QueryLibRuleDs',  //csp, ��Ϊnull
	columns: rulecolumns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#rulegrid', //grid ID
	field:'rowid', 	
	toolbar:[],
	striped:'false', 
	//treefield:'desc',
	params:null

}

var detailcolumns=[[  
	{field:'desc',title:'��Ŀ',width:200}, 
	{field:'relation',title:'��ϵ',width:80,editor:drelatcombo},
	{field:'ordnum',title:'ordnum',hidden:true},			  
	{field:'pri',title:'���ȼ�',width:80, 
	    formatter:function(value,rec,index){    
	        var a = '<a href="#" mce_href="#" onclick="upitmclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downitmclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
	        return a+b;    
	    }  
	},
	{field:'rowid',title:'rowid',hidden:true},
	{field:'condition',title:'ǰ������',width:80,editor:condCombo}
]];


var detailtg = {
	url: url+'?action=QueryRuleItmDs',  //
	columns: detailcolumns,  //����Ϣ
	pagesize:150,  //һҳ��ʾ��¼��
	table: '#detailgrid', //grid ID
	field:'rowid', 
	params:null

}




var itmclumns=[[ 
	{field:'desc',title:'��Ŀ',width:200}, 
	{field:'relation',title:'��ϵ',width:30},  
	{field:'code',title:'����',hidden:true},
	{field:'fun',title:'�������ʽ',hidden:true},
	{field:'remark',title:'��ע',width:60},
	{field:'active',title:'����',width:20},  
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


var rulegrid;
var detailgrid;
var funitmgrid;

function BodyLoadHandler()
{

   //����grid   
   rulegrid = new DataGrid(tg);
   rulegrid.init();  

   ruleopt=GetGridOpt("#rulegrid");		
   ruleopt.onClickCell=function (rowIndex, rowData) { 
		if ((currEditRow != "")||(currEditRow == "0")) {
			$("#"+currEditID).datagrid('endEdit', currEditRow);
		} 
		$("#"+this.id).datagrid('beginEdit', rowIndex); 
		currEditID=this.id;
		currEditRow=rowIndex;		
    }

	ruleopt.onClickRow=function(rowIndex, rowData){
		ReLoad();
	}
	

	//��ϸgrid
    detailgrid = new DataGrid(detailtg);
    detailgrid.init(); 

	detailopt=GetGridOpt("#detailgrid");		
	/*	
    detailopt.onClickCell=function (rowIndex, rowData) { 
		if ((currDetailEditRow != "")||(currDetailEditRow == "0")) {
			$("#"+currDetailEditID).datagrid('endEdit', currDetailEditRow);
		} 
		$("#"+this.id).datagrid('beginEdit', rowIndex); 
        currDetailEditID=this.id;
		currDetailEditRow=rowIndex;
		
		
    }    
    */

    //detailopt.onDblClickCell=function(rowIndex, rowData){
	//			   alert(1)
	//	}


	$('#detailgrid').datagrid({
		onClickCell: function(rowIndex,field,value){
			if ((field!='relation')&&(field!='condition'))
			{
				return;
			}

			if ((currDetailEditRow != "")||(currDetailEditRow == "0")) {
				$("#"+currDetailEditID).datagrid('endEdit', currDetailEditRow);
			} 

			$("#"+this.id).datagrid('beginEdit', rowIndex); 
			currDetailEditID=this.id;
			currDetailEditRow=rowIndex;
			
			var ed=""
			if(field='relation'){
				ed = $('#detailgrid').datagrid('getEditor', {index:rowIndex,field:'relation'});
			}
			if(field='condition'){
				ed = $('#detailgrid').datagrid('getEditor', {index:rowIndex,field:'condition'}); //qnp add 17/4/10
			}
			$(ed.target).focus();


		},
		onDblClickRow: function(rowIndex,rowData){
            DelRuleItm(rowData.rowid);
		}
	});

  //detailopt.onClickCell=function(rowIndex,field,value){
		//alert("1")
		//$.messager.alert('������ʾ','��!',"error");
  //}


	//detailopt.onDblClickRow=function (rowIndex,rowData) {//˫��ѡ���б༭ 	

	   //DelRuleItm(rowData.rowid);		   
	   /*
        if ((currDetailEditRow != "")||(currDetailEditRow == "0")) {
					$("#"+currDetailEditID).datagrid('endEdit', currDetailEditRow);
		} 
		$("#"+this.id).datagrid('beginEdit', rowIndex); 
        currDetailEditID=this.id;
		currDetailEditRow=rowIndex;
					
		*/
		//$.messager.alert('������ʾ','����ѡ��һ������!',"error");	
					 
	// }    
    
   //��Ŀgrid  
   funitmgrid = new TreeGrid(itmtg);
   funitmgrid.init();
  
   
   var opt=$("#funitemgrid").treegrid('options');
   opt.onDblClickRow=function (rowData) {//˫��ѡ���б༭ 
		 
		var parent=rowData._parentId;
		if (parent!="")
		{
		 AddRuleItm(rowData.rowid)
		}			 
    }
}


function title_formatter(value,node){     
    var content='<input name="set_power" id="set_power_'+node.rowid+'" onclick="set_power_status('+node.rowid+')"  type="checkbox"  value="'+node.rowid+'"  />'+value;  
    return content;  
} 


function set_power_status(menu_id){  
   alert(menu_id);  
} 


//���ӹ�����ϸ
function AddRuleItm(itmrowid)
{
	var ruledr="";
	var row = $("#rulegrid").datagrid("getSelected");
	if (row)
	{
		ruledr=row.rowid;

	}else{
		$.messager.alert('������ʾ','����ѡ��һ������!',"error");
		return;
	}
	var input=ruledr+"^"+itmrowid ;

	rq.url=url+'?action=AddRuleItm' ;
	rq.data={"input":input},
	ajax=new JRequest(rq);
	ajax.post(AddRuleItmCallback);
}

//�ص�
function AddRuleItmCallback(r)
{
	if (r)
	{
	 ret=r.retvalue; 
	 
	 if (ret=="0")
	 {
		ReLoad();

	 }
	}
}

//ˢ��
function ReLoad()
{
	var main="";
	var row = $("#rulegrid").datagrid("getSelected");
	if (row)
	{
		main=row.rowid;

	}
	
	$('#detailgrid').datagrid('load',  {  
		action: 'QueryRuleItmDs',
		input:main
	});
	
}


function UpdLibRuleCallback(r)
{
	if (r)
	 {
		 ret=r.retvalue; 		 
		 if (ret=="0")
		 {
			$('#rulegrid').datagrid('load',  {  
				action: 'QueryLibRuleDs'
			});
		 }
	 }
}

function SaveUp(input)
{
	 rq.url=url+'?action=UpdRuleOrdNum';
	 rq.data={"input":input};
	 ajax=new JRequest(rq);
	 ajax.post(UpdRuleOrdNumCallback);
}



function UpdRuleOrdNumCallback(r)
{
	if (r)
	{
		ret=r.retvalue; 

		if (ret=="0")
		{


		}
	}
}



function SaveItmUp(input)
{
	rq.url=url+'?action=UpdRuleItmOrdNum' ;
	rq.data={"input":input};
	ajax=new JRequest(rq);
	ajax.post(UpdRuleItmOrdNumCallback);
}



function UpdRuleItmOrdNumCallback(r)
{
	if (r)
	 {
		 ret=r.retvalue; 
		 
		 if (ret=="0")
		 {
			

		 }
	 }
}


function mysort(index, type, gridname) {
	
    if ("up" == type) {

        if (index != 0) {

			var nextrow=parseInt(index)-1 ;

			var lastrow=parseInt(index);


            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];

            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
		

            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;

            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;

            $('#' + gridname).datagrid('refreshRow', lastrow);

            $('#' + gridname).datagrid('refreshRow', nextrow);

            $('#' + gridname).datagrid('selectRow', nextrow);

        }

    } else if ("down" == type) {

        var rows = $('#' + gridname).datagrid('getRows').length;

        if (index != rows - 1) {

		    var nextrow=parseInt(index)+1 ;

			var lastrow=parseInt(index);
			
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];

            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];

            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;
              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;

            $('#' + gridname).datagrid('refreshRow', lastrow);

            $('#' + gridname).datagrid('refreshRow', nextrow);

            $('#' + gridname).datagrid('selectRow', nextrow);

        }

    }

}



//�Ƴ�������ϸ
function DelRuleItm(itmrowid)
{

	var input=itmrowid ;

	rq.url=url+'?action=DelRuleItm' ;
	rq.data={"input":input},
	ajax=new JRequest(rq);
	ajax.post(AddRuleItmCallback);
}