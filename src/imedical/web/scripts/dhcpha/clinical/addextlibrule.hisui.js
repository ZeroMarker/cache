/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:规则维护
*/

var url='dhcpha.clinical.ckbaction.csp' ;

var currEditRow="";currEditID="";currDetailEditID="";currDetailEditRow="";

var relatcombo={  //设置其为可编辑
	type: 'combobox', //设置编辑格式
	options: {
		//required: true, //设置编辑规则属性
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
			//$(ed.target).val(option.value);  //设置科室ID
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

var drelatcombo={  //设置其为可编辑
	type: 'combobox', //设置编辑格式
	options: {
		//required: true, //设置编辑规则属性
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
			var input=rowid+"^"+option.value+"^"+row.condition;  //qnp 增加了前提条件 17/4/10;

			rq.url=url+'?action=UpdLibRuleItm' ;
			rq.data={"input":input},
			ajax=new JRequest(rq);
			ajax.post(UpdLibRuleCallback);
		}
	}
}

/// Description: 前提条件选择
/// Creator:     QuNianpeng
/// CreateDate:  2017-04-10

var condCombo={  //设置其为可编辑
	type: 'combobox', //设置编辑格式
	options: {
		//required: true, //设置编辑规则属性
		panelHeight:"auto",
		valueField: "value", 
		textField: "text",
		data: [{
			text: '是',
			value: '是'
		},{
			text: '否',
			value: '否'
		}],
		onSelect:function(option){
            var rowid="";
            var row = $("#detailgrid").datagrid("getSelected");
			if (row)
			{
				rowid=row.rowid;

			}
			var input=rowid+"^"+row.relation+"^"+option.value; //qnp 增加了关系 17/4/10

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
	 if(up === undefined){		// 存在溢出
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
	 if(down === undefined){		// 存在溢出
		 return;
	}
	 var downrowid=down.rowid;
     var downordnum=down.ordnum;

	 var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
     SaveUp(input);
	 mysort(index, 'down', 'rulegrid');
}



//请求rq
var rq={
	url: url,  
	async:true,
	type:'json',
	data:null
}

var curfunrowid="";  //当前选择的函数库id
var curfunitmrowid=""; //当前选择的函数项目id

var rulecolumns=[[  
	{field:'desc',title:'描述',width:100}, 
	{field:'lib',title:'知识库',width:80}, 
	{field:'ordnum',title:'ordnum',hidden:true},
	{field:'relat',title:'关系',width:80,editor:relatcombo},
	{field:'pri',title:'优先级',width:100, 
	    formatter:function(value,rec,index){    
	         var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
	        return a+b; 
	    }  
	},
	{field:'rowid',title:'rowid',width:65}
]];

var tg = {
	url: url+'?action=QueryLibRuleDs',  //csp, 空为null
	columns: rulecolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#rulegrid', //grid ID
	field:'rowid', 	
	toolbar:[],
	striped:'false', 
	//treefield:'desc',
	params:null

}

var detailcolumns=[[  
	{field:'desc',title:'项目',width:200}, 
	{field:'relation',title:'关系',width:80,editor:drelatcombo},
	{field:'ordnum',title:'ordnum',hidden:true},			  
	{field:'pri',title:'优先级',width:80, 
	    formatter:function(value,rec,index){    
	        var a = '<a href="#" mce_href="#" onclick="upitmclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downitmclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
	        return a+b;    
	    }  
	},
	{field:'rowid',title:'rowid',hidden:true},
	{field:'condition',title:'前提条件',width:80,editor:condCombo}
]];


var detailtg = {
	url: url+'?action=QueryRuleItmDs',  //
	columns: detailcolumns,  //列信息
	pagesize:150,  //一页显示记录数
	table: '#detailgrid', //grid ID
	field:'rowid', 
	params:null

}




var itmclumns=[[ 
	{field:'desc',title:'项目',width:200}, 
	{field:'relation',title:'关系',width:30},  
	{field:'code',title:'代码',hidden:true},
	{field:'fun',title:'函数表达式',hidden:true},
	{field:'remark',title:'备注',width:60},
	{field:'active',title:'启用',width:20},  
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

   //规则grid   
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
	

	//明细grid
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
		//$.messager.alert('错误提示','请!',"error");
  //}


	//detailopt.onDblClickRow=function (rowIndex,rowData) {//双击选择行编辑 	

	   //DelRuleItm(rowData.rowid);		   
	   /*
        if ((currDetailEditRow != "")||(currDetailEditRow == "0")) {
					$("#"+currDetailEditID).datagrid('endEdit', currDetailEditRow);
		} 
		$("#"+this.id).datagrid('beginEdit', rowIndex); 
        currDetailEditID=this.id;
		currDetailEditRow=rowIndex;
					
		*/
		//$.messager.alert('错误提示','请先选择一条规则!',"error");	
					 
	// }    
    
   //项目grid  
   funitmgrid = new TreeGrid(itmtg);
   funitmgrid.init();
  
   
   var opt=$("#funitemgrid").treegrid('options');
   opt.onDblClickRow=function (rowData) {//双击选择行编辑 
		 
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


//增加规则明细
function AddRuleItm(itmrowid)
{
	var ruledr="";
	var row = $("#rulegrid").datagrid("getSelected");
	if (row)
	{
		ruledr=row.rowid;

	}else{
		$.messager.alert('错误提示','请先选择一条规则!',"error");
		return;
	}
	var input=ruledr+"^"+itmrowid ;

	rq.url=url+'?action=AddRuleItm' ;
	rq.data={"input":input},
	ajax=new JRequest(rq);
	ajax.post(AddRuleItmCallback);
}

//回调
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

//刷新
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



//移除规则明细
function DelRuleItm(itmrowid)
{

	var input=itmrowid ;

	rq.url=url+'?action=DelRuleItm' ;
	rq.data={"input":input},
	ajax=new JRequest(rq);
	ajax.post(AddRuleItmCallback);
}